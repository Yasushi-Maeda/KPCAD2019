;<HOM>*************************************************************************
; <関数名>    : SearchPlanSB
; <処理概要>  : バスプラン検索
; <戻り値>    :
; <作成>      : 1999-06-14
; <備考>      :
;*************************************************************************>MOH<
(defun C:SBSearchPlan ()
  (defun TempErr (msg)
    (CFAlertMsg "プラン検索に失敗しました。")
    (command "_undo" "b")
    (setq *error* nil)
    (princ)
  )
  (if CG_DEBUG
    (setq *error* nil)
    (progn
      (StartUndoErr)
      (setq *error* TempErr)
    )
  )
  ;// システムバスプラン検索画面の表示
  (C:SearchPlanSBFORM)

  ;//-----------------------------------------------------------
  ;// プラン検索ダイアログにて出力された情報を取得する
    (if (ReadIniFile (strcat CG_SYSPATH "SRCPLN.CFG"))
      (SB_SearchPlanNewDWG)
  )
  (setq *error* nil)
  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : SB_SearchPlanNewDWG
; <処理概要>  : プラン検索用の新規図面を開く
; <戻り値>    : なし
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun SB_SearchPlanNewDWG (
    /
    #family$$
  )
  ;// 自動保存
  (CFAutoSave)
  (command "_point" "0,0")
  ;// ファミリーコードを設定する
  (setq #family$$ (ReadIniFile (strcat CG_SYSPATH "SRCPLN.CFG")))
  (SBG_SetFamilyCode #family$$)

  ;(setq CG_OPENMODE 3)    ;バス
  (C:SB_LayoutPlan)
  ;(command "_new" ".")
  ;// 新規図面オープン後、Acad.lsp からプラン検索(C:SB_LayoutPlan)を行う
)


;<HOM>*************************************************************************
; <関数名>    : SBSetFamilyCode
; <処理概要>  : 入力情報をグローバルファミリー品番
; <戻り値>    :
; <作成>      : 1998-11-12
; <備考>      :
;*************************************************************************>MOH<
(defun SBG_SetFamilyCode (
    &family$$    ;(LIST)プラン検索画面の入力情報
    /
    #f
    #sql #qry #series #dseries #color #lst$ #key #fcfg$ #fcfg$$ #tmp$$
  )
  (setq CG_INCNO "00")
  (setq CG_SBOUTPATH (strcat CG_KENMEI_PATH "OUTPUT\\"))
  (setq CG_OUTPUTTYPE "DWG")

  ;//----------------------------------------------------------------
  ;// 各種グローバル変数に格納
  (setq CG_FamilyCode (cadr (assoc "FamilyCode"   &family$$)))  ;ファミリー品番
  (setq CG_WOffset    (atoi (cadr (assoc "SERIBW" &family$$)))) ;ユニットオフセット量W

  (setq CG_GROVALZNO  "111")              ;出力図面種類情報
  (setq CG_KoujiKind  "1階システムバス")

  ;// SRCPLN.CFGの情報
  (setq CG_DBName       (cadr (assoc "SERIDB" &family$$)))         ;データベース名称 "sb_sua"
  (setq CG_Hinmoku      "SB")                                      ;品目             "SB"
  (setq CG_BaseOffset   (atof (cadr (assoc "SERIBW" &family$$))))  ;基準寸法          77
  (setq CG_WPanelThk    (atof (cadr (assoc "SERIWW" &family$$))))  ;ﾊﾟﾈﾙ厚み          33
  (setq CG_DOffset      (atof (cadr (assoc "SERIBD" &family$$))))  ;D基準寸法         70.5
  (setq CG_DPanelThk    (atof (cadr (assoc "SERIWD" &family$$))))  ;Dﾊﾟﾈﾙ厚み         39.5
  (setq CG_SeriesCode   (cadr (assoc "SERIES"       &family$$)))   ;SERIESコード
  (setq CG_SeriesFolder (cadr (assoc "SERIFOLDER"   &family$$)))   ;SERIES毎のフォルダー
  (setq CG_SeriesName   (cadr (assoc "SERINAME"     &family$$)))   ;SERIES名称

  (setq CG_Kouhou (cadr (assoc (strcat CG_SeriesCode "B32")  &family$$)))  ;建築工法
  (setq CG_CeilHeight 2179)                      ;天井高さ

  (CFOutLog 1 nil "")
  (CFOutLog 1 nil (strcat "  +ファミリー品番:" CG_FamilyCode))
  (CFOutLog 1 nil "")
  (CFOutLog 1 nil (strcat "  +工法: "          CG_Kouhou))
  (CFOutLog 1 nil (strcat "  +ﾕﾆｯﾄｵﾌｾｯﾄ量W: "  (itoa CG_WOffset)))
  (CFOutLog 1 nil (strcat "  +工事種類: "      CG_KoujiKind))
  (CFOutLog 1 nil (strcat "  +物件番号: "      CG_BukkenNo))
  (CFOutLog 1 nil (strcat "  +物件名称: "      CG_BukkenName))

  ;//-----------------------------------------------------------
  ;// 共通データベースへの接続
  (if (= CG_CDBSESSION nil)
    (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  )
  ;// SERIES別データベースの接続
  (if (/= CG_DBSESSION nil)
    (dbDisconnect CG_DBSESSION)
  )
  (setq CG_DBSESSION (DBConnect CG_DBNAME "" ""))
  (if (= CG_DBSESSION nil)
    (CFAlertErr "ODBCが正しく設定されているか確認して下さい")
  )

  (CFOutLog 1 nil (strcat "  +DB名称:    "  CG_DBName))
  (CFOutLog 1 nil (strcat "  +品目:      "  CG_Hinmoku))
  (CFOutLog 1 nil (strcat "  +ｼﾘｰｽﾞｺｰﾄﾞ: "  CG_SeriesCode))
  (CFOutLog 1 nil (strcat "  +ｼﾘｰｽﾞﾌｫﾙﾀﾞ: " CG_SeriesFolder))

  ;// SERIES別フォルダーのチェック
  (if (not (dos_subdir (strcat CG_SBDATAPATH CG_SeriesFolder)))
    (CFAlertErr "SBSetFamilyCode:SERIES毎のフォルダーが存在しません")
  )

  ;//----------------------------------------------------------------
  ;// SB特性テーブル情報を取得する
  ;    LAYOUT              123456789012345678901234567890123456789
  ;    ファミリー品番例    SUA-GF1216NN/N#ACA+JBGNNNNNBABNBANN
  ;
  ;      -> (("SUAB01" "SUA"　"SERIES") ("SUAB02" "G" "グレード") ....)
  (setq CG_FamilyInfo$$ (SBG_GetTokusei CG_FamilyCode)) ;SB特性情報を取得する

  ;-------------------------------------------------------------
  ;                    0        1         2         3
  ;LAYOUT              123456789012345678901234567890123456789
  ;ファミリー品番例    SUA-GF1216NN/N#ACA+JBGNNNNNBABNBANN

  ;// サイズコード、ドアコード、モデル名、パッケージ名をグローバル変数に格納
  (setq CG_BrandCode  "NR")                                                  ;ブランドコード（未使用）
  (setq CG_SizeCode   (cadr  (assoc (strcat CG_SeriesCode "B04") CG_FamilyInfo$$))) ;サイズコード
  (setq CG_DoorCode   (cadr  (assoc (strcat CG_SeriesCode "B11") CG_FamilyInfo$$))) ;ドアコード
  (setq CG_DoorLR     (caddr (assoc (strcat CG_SeriesCode "B11") CG_FamilyInfo$$))) ;ドア左右コード
  (setq CG_ModelName (strcat
    (cadr (assoc (strcat CG_SeriesCode "B01") CG_FamilyInfo$$)) "-"
    (cadr (assoc (strcat CG_SeriesCode "B03") CG_FamilyInfo$$)) " "
    (cadr (assoc (strcat CG_SeriesCode "B04") CG_FamilyInfo$$)) " "
    (cadr (assoc (strcat CG_SeriesCode "B11") CG_FamilyInfo$$))
  ))


  (setq CG_PackName (substr CG_FamilyCode 5))    ;パッケージ名称


  (CFOutLog 1 nil (strcat "  +ﾊﾟｯｹｰｼﾞ名称: "  CG_PackName))

  ;//--------------------------------------------------
  ;// 共通データベースの接続解除
  (if (/= CG_DBSESSION nil)
    (progn
      (DBDisConnect CG_DBSESSION)
      (setq CG_DBSESSION nil)
    )
  )
)
;SBG_SetFamilyCode

;<HOM>*************************************************************************
; <関数名>    : SBG_GetTokusei
; <処理概要>  : 特性ＤＢを取得する
; <戻り値>    :
;        LIST : (識別ID 変換値 補足値 機能名)のリスト
;               (("SUAB01" "SUA" "" "SERIES") ("SUAB02" "G" "" "グレード") ....)
; <作成>      : 1998-06-16
; <備考>      :
;*************************************************************************>MOH<
(defun SBG_GetTokusei (
    &family    ;(STR)ファミリー品番文字列
    /
    #sql #qry$ #qry$$ #key #str1 #str2 #tmp$ #kinou #id #family$$ #str
  )

  ;// 現在のバージョンのSB特性テーブルを取得
  (setq #key CG_SeriesCode)
  (setq #sql (strcat "select \"識別ID\",\"機能名\",\"文字位置\",\"サイズ\" from SB特性 where 識別ID like '" #key "B__'"))
  (setq #qry$$ (DBSqlAutoQuery CG_DBSession #sql))
  (if (= #qry$$ nil)
    (progn
      (CFOutStateLog 0 1 "  SKGetTokusei:『SB特性』が見つかりませんでした")
      (CFOutStateLog 0 1 (strcat "        " #sql))
    )
  )

  ;// 識別IDと値のﾘｽﾄに変換する (("SUAB01" "???") ....)
  (foreach #qry$ #qry$$
    (setq #id    (car #qry$))        ;識別ID
    (setq #kinou (cadr #qry$))       ;機能名
    (if (or (= (nth 2 #qry$) nil) (= (nth 2 #qry$) 0))
      (setq #str "")
      (progn
        (setq #str1 "")
        (setq #str2 "")
        ;// SB特性値テーブルにより、値を変換する
        (setq #str1 (substr &family (fix (nth 2 #qry$)) (fix (nth 3 #qry$))))
        (setq #qry$
          (car
            (CFGetDBSQLRec CG_DBSESSION "SB特性値"
              (list
                (list "識別ID" #id 'STR)
                (list "特性値" #str1 'STR)
              )
            )
          )
        )
        (if (= #qry$ nil)
          (progn
            (CFOutStateLog 0 1 (strcat "        " #sql))
          )
          (progn
            (setq #str1 (ai_strtrim (nth 4 #qry$)))
            (setq #str2 (ai_strtrim (nth 5 #qry$)))
          )
        )
      )
    )
    (if (= (substr #id 5 2) "32")   ;躯体部工法はInput.CFGの建築工法とする
      (setq #family$$ (append #family$$ (list (list #id CG_Kouhou #str2 (ai_strtrim #kinou)))))
      (setq #family$$ (append #family$$ (list (list #id #str1 #str2 (ai_strtrim #kinou)))))
    )
  )
  #family$$
)
;SBG_GetTokusei

;<HOM>*************************************************************************
; <関数名>    : SBG_GetSeriesTable
; <処理概要>  : 現在のSERIES情報を取得する
; <戻り値>    :
;        LIST : シリ管テーブルの検索レコード
; <作成>      : 1999-02-16
; <備考>      :
;*************************************************************************>MOH<
(defun SBG_GetSeriesTable (
  &key
  /
  #sql #qry$
  )
  ;(setq #sql (strcat "select * from シリ管理 where 品番文字='" &key "'"))
  (setq #qry$
    (car
      (CFGetDBSQLRec CG_CDBSESSION "SBシリズ"
        (list
          (list "SERIES" &key 'STR)
        )
      )
    )
  )
  (if (= #qry$ nil)
    (progn
      (CFOutStateLog 0 1 "  CFGetSeriesTable:『シリ管理』が見つかりませんでした")
      (CFOutStateLog 0 1 (strcat "        " #sql))
    )
  )
  #qry$
)

;<HOM>*************************************************************************
; <関数名>    : C:SB_LayoutPlan
; <処理概要>  : システムバスのプラン検索処理
; <戻り値>    : なし
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun C:SB_LayoutPlan ()

  (if (= "1" (substr CG_GROVALZNO 1 1))
    (progn
      (princ "\n内観図作成")
      (setq CG_Zno "01")
      (SBDrawInsideBefore)
      (setq CG_GROVALZNO (strcat "0" (substr CG_GROVALZNO 2)))
    )
  )
  (if (= "1" (substr CG_GROVALZNO 2 1))
    (progn
      (princ "\n給排水設備図作成")
      (setq CG_Zno "02")
      (SBDrawDrainageBefore)
      (setq CG_GROVALZNO (strcat (substr CG_GROVALZNO 1 1) "0" (substr CG_GROVALZNO 3)))
    )
  )
  (if (= "1" (substr CG_GROVALZNO 3 1))
    (progn
      (princ "\n仕様図作成")
      (setq CG_Zno "03")
      (SBDrawTableBefore)
      (setq CG_GROVALZNO (strcat (substr CG_GROVALZNO 1 2) "0"))
    )
  )
  (if (= CG_GROVALZNO "000")
    (progn
      (princ "\nシステムバスレイアウトの終了")
      (setq CG_OpenMode nil)
    )
  )
)
(princ)

