
;; 3/11 品番図形 検索キー 取り付けﾀｲﾌﾟ削除
;;---------------------------------------------------------
;; コマンド一覧
;;
;;   1. C:SelectParts       : 設備選択ダイアログ表示
;;   2. C:PosParts          : 部材配置
;;   3. C:ChgParts          : 部材変更
;;   4. C:BaseParts         : 基準アイテム
;;   5. C:CntPartsL         : 連続配置（左）
;;   6. C:CntPartsR         : 連続配置（右）
;;   7. C:CntPartsT         : 連続配置（上）
;;   8. C:CntPartsD         : 連続配置（下）
;;   9. C:BlockParts        : 複合部材配置
;;  10. C:InsParts          : 部材挿入
;;  11. C:InsPartsR         : 部材挿入（右）
;;  12. C:InsPartsL         : 部材挿入（左）
;;  13. C:DelParts          : 部材削除
;;  14. C:DelPartsCnt       : 部材削除（連続モード）
;;  15. C:ConfParts         : 部材確認
;;  16. C:ConfWkTop         : ワークトップ確認
;;  17. C:PtenDsp           : Ｐ点の表示
;;  18. C:StretchCab        : キャビネットを伸縮
;;---------------------------------------------------------

(setq ST_POS_Y    0)
(setq ST_ANGLE    nil)
(setq ST_BLKSTART nil)

;<HOM>*************************************************************************
; <関数名>    : SelectParts
; <処理概要>  : フリープラン設備選択ダイアログの表示
; <戻り値>    :
; <作成>      : 1999-06-14
; <備考>      :
;*************************************************************************>MOH<
(defun C:SelectParts (
    /
    #XRec$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:SelectParts ////")
  (CFOutStateLog 1 1 " ")

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 前処理
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO処理追加

;;;01/09/03YM@MOD  ;// コマンドの初期化
;;;01/09/03YM@MOD  (StartCmnErr) --- undoBがない

  (setq #XRec$ (CFGetXRecord "SERI"))
  (if (= #XRec$ nil)
    (CFAlertErr "一度も商品設定がされていません\n商品設定を行って下さい")
  )
  ;// データベースに接続
  (if (= CG_DBSESSION nil)
    (progn
      (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
      (if (= nil (tblsearch "APPID" "G_ARW"))  (regapp "G_ARW")) ;2011/10/04 YM MOV 意味ない
      (if (= nil (tblsearch "APPID" "G_LSYM")) (regapp "G_LSYM")) ;2011/10/04 YM MOV 意味ない
    )
  )
	;2011/10/04 YM MOV 意味ない　外に出した
	(if (= nil (tblsearch "APPID" "G_ARW"))  (regapp "G_ARW"))
	(if (= nil (tblsearch "APPID" "G_SYM")) (regapp "G_SYM"))
	(if (= nil (tblsearch "APPID" "G_LSYM")) (regapp "G_LSYM"))
	(if (= nil (tblsearch "APPID" "G_OPT")) (regapp "G_OPT"))
	(if (= nil (tblsearch "APPID" "G_TOKU")) (regapp "G_TOKU"))


  ;// 現在の商品情報をファイルに書き出す
  (PC_WriteSeriesInfo #XRec$)

  (MakeLayer "N_Symbol" 4 "CONTINUOUS")
  (MakeLayer "N_BreakD" 6 "CONTINUOUS")
  (MakeLayer "N_BreakW" 6 "CONTINUOUS")
  (MakeLayer "N_BreakH" 6 "CONTINUOUS")

;;;09/21YM  (command "._shademode" "H") ; 隠線処理 (T)PAT-0007 00/04/01 HN ADD

  ;00/10/10 HN S-MOD モジュール呼び出し方法変更
  ;@@@(if (= "1" CG_KekomiCode)
  ;@@@  (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 1") 0)
  ;@@@  (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 0") 0)
  ;@@@)
  (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 1") 0)
  ;00/10/10 HN E-MOD モジュール呼び出し方法変更

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 後処理
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO処理追加

  (princ)
)
;C:SelectParts

;<HOM>*************************************************************************
; <関数名>    : SKY_DivSeikakuCode
; <処理概要>  : 性格CODE（数値）を指定の桁位置の値を取得する
; <戻り値>    :
; <作成>      : 1999-10-22 山田
; <備考>      :
;*************************************************************************>MOH<
(defun SKY_DivSeikakuCode (
    &SeikakuCode    ; 性格CODE（数値 100以上999以下）
    &Keta           ; 桁位置 (1-3)
    /
    #s #s2 #l #n
  )

  (setq #s (itoa &SeikakuCode))
;  (setq #s (strcat "000" #s))
;  (setq #l (strlen #s))
;  (setq #s (substr #s (- #l 2) 3))
  (setq #s2 (substr #s &Keta 1))
  (setq #n (atoi #s2))
  #n
)
;SKY_DivSeikakuCode

;;;<HOM>***********************************************************************
;;; <関数名>    : SKY_GetItemInfo
;;; <処理概要>  : 設備情報ファイル読み出し
;;; <戻り値>    : 情報リスト
;;; <作成>      : 2000-02-12 中村 博伸
;;; <備考>      : グローバル変数
;;;                 CG_SYSPATH : システム フォルダ名
;;;***********************************************************************>MOH<
(defun SKY_GetItemInfo (
  /
  #sFile        ; ファイル名
  #sRec$$       ; ファイル読込みデータ
  #RES$         ; 結果リスト
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKY_GetItemInfo ////")
  (CFOutStateLog 1 1 " ")

  ; 設備情報ファイルよりデータを読み込む
  (setq #sFile (strcat CG_SYSPATH "SELPARTS.CFG"))
  (if (= nil (findfile #sFile))
    (CFAlertErr (strcat "アイテム情報ファイル " #sFile " がありません."))
  )
  (setq #sRec$$ (ReadIniFile #sFile))

  ; 読み込んだデータより情報リストを作成する
  (setq #RES$ (list
          (SKY_GetData "02" #sRec$$)  ; 01.品番名称
          (SKY_GetData "08" #sRec$$)  ; 02.図形ID
    (atoi (SKY_GetData "01" #sRec$$)) ; 03.階層タイプ
    (atoi (SKY_GetData "04" #sRec$$)) ; 04.用途番号
          (SKY_GetData "03" #sRec$$)  ; 05.L/R区分
    (atof (SKY_GetData "05" #sRec$$)) ; 06.寸法W
    (atof (SKY_GetData "06" #sRec$$)) ; 07.寸法D
    (atof (SKY_GetData "07" #sRec$$)) ; 08.寸法H
    (atoi (SKY_GetData "10" #sRec$$)) ; 09.性格CODE
          (SKY_GetData "20" #sRec$$)  ; 10.伸縮フラグ
          (SKY_GetData "08" #sRec$$)  ; 11.展開ID=図形ID
          (SKY_GetData "30" #sRec$$)  ; 12.★ｷｯﾁﾝ or 収納("A" or "D") 2011/07/05 YM ADD
;-- 2011/12/21 A.Satoh Add - S
    (atoi (SKY_GetData "11" #sRec$$)) ; 13.入力コード
;-- 2011/12/21 A.Satoh Add - E
  ))
  #RES$
)
;;;SKY_GetItemInfo

;;;<HOM>***********************************************************************
;;; <関数名>    : SKY_GetData
;;; <処理概要>  : リストよりキーに該当する文字列を取得する
;;; <戻り値>    : データ文字列
;;;               "" : 該当なし
;;; <作成>      : 2000-02-12 中村 博伸
;;; <備考>      :
;;;               (SKY_GetData "2" (("1" "A") ("2" "B") ("3" "C"))) → "B"
;;;***********************************************************************>MOH<
(defun SKY_GetData (
  &sKey         ; 検索キー
  &sLst$$       ; データリスト
  /
  #sLst$        ; 検索リスト
  )

  (setq #sLst$ (assoc &sKey &sLst$$))
  (if (/= nil #sLst$)
    (cadr #sLst$)
    ""
  )
)
;;;SKY_GetData

;<HOM>*************************************************************************
; <関数名>    : SKY_GetBlockID
; <処理概要>  :
; <戻り値>    :
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun SKY_GetBlockID (
    /
    #Result$$ #FName #BlockID #SyouhinType
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKY_GetBlockID ////")
  (CFOutStateLog 1 1 " ")

  (setq #FName (strcat CG_SYSPATH "SELPARTS.CFG"))
  (if (= nil (findfile #FName))
    (CFAlertErr "アイテム情報ファイルがありません")
  )
  (setq #Result$$ (ReadIniFile #FName))
  (setq #BlockID  (SKY_GetData "30" #Result$$))      ;複合品番
;  (setq #SyouhinType  (SKY_GetData "31" #Result$$)) ;商品タイプ
  (list #BlockID #SyouhinType)
)
;SKY_GetBlockID

;<HOM>*************************************************************************
; <関数名>    : PosParts
; <処理概要>  : 設備配置
; <戻り値>    :
; <作成>      : 1999-06-14 (1999-10-22 山田 修正)
; <備考>      :
;*************************************************************************>MOH<
(defun C:PosParts (
  / #fig$
  #SNAPMODE #GRIDMODE #ORTHOMODE #OSMODE ;00/09/06 SN ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:PosParts ////")
  (CFOutStateLog 1 1 " ")

  ;// Ｏスナップ関連システム変数の解除
  ;(CFNoSnapStart) ;00/09/04 SN MOD 配置のｼｽﾃﾑ変数は特殊扱い
  ;// コマンドの初期化
  (StartUndoErr)
  ;;; 画層をすべてﾌﾘｰｽﾞ解除 00/06/21 YM
;;;  (command "_layer" "T" "*" "") ; 00/06/22 YM
  (CFCmdDefBegin 7);00/09/07 SN MOD 関数化
  ;00/09/06 SN ADD ｽﾅｯﾌﾟ･ｸﾞﾘｯﾄﾞ･直交ﾓｰﾄﾞはON､OSNAPはOFFをﾃﾞﾌｫﾙﾄとする。
  ;(setq #SNAPMODE  (getvar "SNAPMODE"))
  ;(setq #GRIDMODE  (getvar "GRIDMODE"))
  ;(setq #ORTHOMODE (getvar "ORTHOMODE"))
  ;(setq #OSMODE    (getvar "OSMODE"))
  ;(setvar "SNAPMODE" 1)
  ;(setvar "GRIDMODE" 1)
  ;(setvar "ORTHOMODE" 1)
  ;(setvar "OSMODE"   0)

  (if (not (setq #fig$ (SKY_GetItemInfo)))
    (CFAlertErr "品番情報を取得できませんでした"))

;-- 2011/08/03 A.Satoh Add - S
  ; 扉グレード別配置不可部材チェック
  (if (= (CheckDoorGradeFree (nth 0 #fig$) CG_DRSeriCode CG_DRColCode) nil)
    (progn
      (CfAlertMsg "選択した品番は、現在の扉グレード、扉色のとき配置できません。")
      (exit)
    )
  )
;-- 2011/08/03 A.Satoh Add - E

  ;2018/07/12 木製ｶｳﾝﾀｰ対応
  (setq #fig$ (KcChkWCounterItem$ #fig$))

  (if (not (KcSetUniqueItem "POS" #fig$ nil nil nil)); 01/03/13 MH ADD
    (PcSetItem "POS" nil #fig$ nil nil nil nil)  ;特殊部材以外の部材の処理
  ); if

  (command "_.layer" "F" "Z_01*" "")
  ;2011/09/21 YM ADD-S "M_*"画層の色を白にする.何故か30番ｵﾚﾝｼﾞ色になってしまう
  (command "_.layer" "C" 7 "M_*" "")

  ;// Ｏスナップ関連システム変数を元に戻す
  ;(CFNoSnapEnd) ;00/09/04 SN MOD 配置のｼｽﾃﾑ変数は特殊扱い
  (CFCmdDefFinish);00/09/07 SN MOD 関数化
  ;00/09/06 SN ADD ｽﾅｯﾌﾟ･ｸﾞﾘｯﾄﾞ･直交ﾓｰﾄﾞを元に戻す。
  ;(setvar "SNAPMODE"  #SNAPMODE)
  ;(setvar "GRIDMODE"  #GRIDMODE)
  ;(setvar "ORTHOMODE" #ORTHOMODE)
  ;(setvar "OSMODE"    #OSMODE  )

;;; 00/06/20 YM
;;; 表示画層の設定
;;;  (command "_layer"
;;;    "F"   "*"                ;全ての画層をフリーズ
;;;    "T"   "Z_00*"            ;  Z_00立体ソリッド画層のフリーズ解除
;;;    "T"   "N_*"              ;  N_*シンボル原点図形画層のフリーズ解除
;;;    "T"   "M_*"              ;  M_*目地領域図形画層の解除
;;;    "T"   "0"                ;  "0"画層の解除
;;;    "ON"  "M_*"              ;  M_*目地領域図形画層の表示
;;;    "OFF" "N_B*" ""          ;  N_B*ブレークライン図形の非表示
;;;  )
;;; 00/06/20 YM

  ;04/05/26 YM ADD
  (command "_REGEN")

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

  (setq *error* nil)
  (princ)
)
;C:PosParts

;<HOM>*************************************************************************
; <関数名>    : KP_GetSekisanF
; <処理概要>  : 品番名称から品番基本.積算Fを検索する
; <戻り値>    : 積算F=1==>T それ以外nil
; <作成>      : 01/09/03 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KP_GetSekisanF (
  &HINBAN
  /
  #QRY$ #TSEKISAN
  )
  (setq #tSEKISAN nil)
  (setq #qry$
    (car (CFGetDBSQLHinbanTable "品番基本" &HINBAN
    (list (list "品番名称" &HINBAN 'STR))))
  )
  (if (and (/= nil #qry$)(equal 1.0 (nth 10 #qry$) 0.1)) ; 01/09/03 YM MOD 品番基本.積算F
    (progn ; 積算F=1だった
      (setq #tSEKISAN T)
    )
  );_if
  #tSEKISAN
);KP_GetSekisanF

;<HOM>*************************************************************************
; <関数名>    : SKY_SetZukeiXData
; <処理概要>  :
; <戻り値>    :
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun SKY_SetZukeiXData (
  &fig$
  &en
  &pt
  &ang
  /
  #QRY$ #TSEKISAN ; 01/09/03 YM ADD
  )
  ; 01/09/03 YM ADD-S 水栓の積算Fを検索する
  (setq #tSEKISAN (KP_GetSekisanF (nth 0 &fig$)))
  ; 01/09/03 YM ADD-E 水栓の積算Fを検索する

  (if (= nil &fig$)
    (progn
      (CFAlertMsg "品番情報を取得できませんでした")
      (command "_undo" "m")
    )
    (progn
      (SKY_SetXData_ &fig$ &en &pt &ang #tSEKISAN) ; 01/09/03 YM 引数追加 積算F=nil
;;;01/09/03YM@MOD      (SKY_SetXData_ &fig$ &en &pt &ang)
      (command "_layer" "on" "M_*" "")
    )
  )
)
;SKY_SetZukeiXData

;<HOM>*************************************************************************
; <関数名>    : SKY_SetXData_
; <処理概要>  : 図形情報リスト、基点、角度 からG_LSYM をセットする
; <戻り値>    : 図形名
; <作成>      : 01/04/16 MH 断面指示の有無判定を追加
;*************************************************************************>MOH<
(defun SKY_SetXData_ (
  &fig$
  &sym
  &pt
  &ang
  &tSEKISAN ; 01/09/03 YM ADD
  /
  #sec #iskk #UNIT
  )
  (setq #iskk (fix (nth 8 &fig$)))
  (setq #sec 0)   ; デフォルトで断面指示 OFF
  (if (or
    (= #iskk CG_SKK_INT_SCA);シンクキャビ ; 01/08/31 YM MOD 112-->ｸﾞﾛｰﾊﾞﾙ化
    (= #iskk CG_SKK_INT_GCA);コンロキャビ（床置きオーブン） ; 01/08/31 YM MOD 113-->ｸﾞﾛｰﾊﾞﾙ化
;2016/10/20 YM DEL-S
;;;    (= #iskk CG_SKK_INT_CNR);コーナーキャビ（フロア） ; 01/08/31 YM MOD 115-->ｸﾞﾛｰﾊﾞﾙ化
;;;    (= #iskk 125);コーナーキャビ（ウォール）
;2016/10/20 YM DEL-E
    (= #iskk CG_SKK_INT_GAS);ビルトインコンロ ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
    (= #iskk CG_SKK_INT_RNG);レンジフード ; 01/08/31 YM MOD 320-->ｸﾞﾛｰﾊﾞﾙ化
    (= #iskk CG_SKK_INT_RNG_MT);レンジフード ; 02/03/27 YM MOD 328-->ｸﾞﾛｰﾊﾞﾙ化 ﾏｳﾝﾄ型ﾌｰﾄﾞ対応
    ; 01/09/06 YM ADD-S
    (= #iskk 710);洗面用ｶｳﾝﾀｰ
    (= #iskk 717);ｶｳﾝﾀｰ
    ; 01/09/06 YM ADD-E
    (and (= &tSEKISAN nil)(= #iskk CG_SKK_INT_SUI));水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化 01/09/03 YM MOD 積算F=1でないなら
;;;01/09/03YM@MOD  　(= #iskk CG_SKK_INT_SUI);水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
    ); or
    (setq #sec 1)
  ); if

  ; 02/07/10 YM ADD-S 洗面"W"の水栓は断面支持OFF
  (setq #unit (KPGetUnit)) ; ﾕﾆｯﾄ‡を取得
  (if (and (= #iskk CG_SKK_INT_SUI)(= #unit "W"))
    (setq #sec 0)
  );_if

  (CFSetXData &sym "G_LSYM"
    (list
      (cadr &fig$)          ;1 :本体図形ID      :『品番図形』.図形ID
      &pt                   ;2 :挿入点          :配置基点
      &ang                  ;3 :回転角度        :配置回転角度
      CG_KCode              ;4 :工種記号        :CG_Kcode
      CG_SeriesCode         ;5 :SERIES記号    :CG_SeriesCode
      (car &fig$)           ;6 :品番名称        :『品番図形』.品番名称
      (nth 4 &fig$)         ;7 :L/R区分         :『品番図形』.部材L/R区分
      ""                    ;8 :扉図形ID        :
      (nth 10 &fig$)        ;9 :扉開き図形ID    :
      #iskk                 ;10:性格CODE      :『品番基本』.性格CODE
      0                     ;11:複合フラグ      :０固定（単独部材）
      0                     ;12:配置順番号      :配置順番号(1～)
      (fix (nth 3 &fig$))   ;13:用途番号        :『品番図形』.用途番号
      (fix (nth 7 &fig$))   ;14:寸法Ｈ          :『品番図形』.寸法Ｈ
      #sec                  ;15:断面指示の有無  :『プラ構成』.断面有無 00/07/18 SN MOD
      (if (nth 11 &fig$)    ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
        (nth 11 &fig$)
        ;else
        "A" ;不明の場合はｷｯﾁﾝ"A"
      );_if
    )
  )
  (KcSetDanmenSymXRec &sym);  Xrecord の"DANMENSYM" 変更 01/04/24 MH
  &sym
);SKY_SetXData_

;<HOM>*************************************************************************
; <関数名>    : KPGetUnit
; <処理概要>  : ﾕﾆｯﾄ記号取得
; <戻り値>    : ﾕﾆｯﾄ記号
; <作成>      : 02/07/10 YM
; <備考>      : ﾕﾆｯﾄ記号=K(ｷｯﾁﾝ),D(ﾀﾞｲﾆﾝｸﾞ),W(洗面)
;*************************************************************************>MOH<
(defun KPGetUnit (
  /
  #QRY$ #UNIT
  )
  (setq #qry$
    (CFGetDBSQLRecChk CG_CDBSESSION "SERIES" (list (list "SERIES記号" CG_SeriesCode 'STR)
                                                     (list "SERIES名称" CG_SeriesDB   'STR))))

;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #qry$)
;;;		;ｼﾘｰｽﾞ別DB,共通DB再接続
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E

  (if (= nil #qry$)
    (CFAlertErr "SERIESテーブルが見つかりません")
  )
  (setq #unit (nth 3 #qry$)) ; ﾕﾆｯﾄ記号
);KPGetUnit

;<HOM>*************************************************************************
; <関数名>    : C:ChgParts
; <処理概要>  : 設備変更
; <戻り値>    :
; <作成>      : 1999-06-14 (1999-10-25 山田 修正)
; <備考>      :
;*************************************************************************>MOH<
(defun C:ChgParts (
  /
  #eCH #en #ps #ss #pt #ang #fig$ #enFL$ #xd$ #old_W #old_D #old_H #BaseFlag
  #eNX #eNEXT$ #selQLY$ #fMOVE
  )

  ;// コマンドの初期化 ChgPartsはUndo処理が特殊なので独自のErrﾊﾝﾄﾞﾘﾝｸﾞを行う
  (defun ChgPartsUndoErr( &msg )
    (command "_undo" "b")
    (CFCmdDefFinish)
    (setq *error* nil)
    (princ)
  )
  (setq *error* ChgPartsUndoErr)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")
  (CFCmdDefBegin 6);00/09/07 SN E-ADD

  (setq CG_BASESYM (CFGetBaseSymXRec))
  (if (not (setq #fig$ (SKY_GetItemInfo))) (progn
    (CFAlertMsg "品番情報を取得できませんでした")
    (command "_undo" "m") (exit)
  )); if progn

;-- 2011/08/03 A.Satoh Add - S
  ; 扉グレード別配置不可部材チェック
  (if (= (CheckDoorGradeFree (nth 0 #fig$) CG_DRSeriCode CG_DRColCode) nil)
    (progn
      (CfAlertMsg "選択した品番は、現在の扉グレード、扉色のとき配置できません。")
      (exit)
    )
  )
;-- 2011/08/03 A.Satoh Add - E

  (setq #eCH T)
  (while #eCH
    (CFCmdDefEnd)        ;00/09/07 SN ADD ｽﾅﾌﾟ関連一旦戻す
    (command "_undo" "m");00/09/07 SN ADD 一回毎のUndo
    (CFCmdDefStart 6)    ;00/09/07 SN ADD ｽﾅﾌﾟ関連再度設定
    (setq #eCH (car (entsel "\n入替するアイテムを選択: ")));00/06/27 SN MOD ﾒｯｾｰｼﾞ変更
    (if (/= #eCH nil)
      (progn
        ; G_FILRアイテム変更不可
        (if (setq #enFL$ (CFGetXData #eCH "G_FILR")) (progn
          (CFAlertErr (strcat (PcGetPrintName (car #enFL$)) "は入れ替えできません"))
        )); if progn
        (setq #eCH (SearchGroupSym #eCH))
        (setq #BaseFlag (equal #eCH CG_BASESYM))  ;基準アイテムの変更可能
        (if (= #eCH nil)
          (progn
            (CFYesDialog "変更するアイテム部材を選択して下さい "
                         "確認" (logior MB_OK MB_ICONEXCLAMATION))
            (setq #eCH T)
          )
          (progn
            ;// Ｏスナップ関連システム変数の解除
            ;CHGﾓｰﾄﾞでPcSetItemを呼び出せば内部でUndo"b"して返ってくる。
            (CFCmdDefEnd)        ;00/09/07 SN ADD ｽﾅﾌﾟ関連一旦戻す
            (command "_undo" "m")
            (CFCmdDefStart 6)    ;00/09/07 SN ADD ｽﾅﾌﾟ関連再度設定

            (setq #xd$ (CFGetXData #eCH "G_LSYM"))
            (setq #pt (cdr (assoc 10 (entget #eCH))))
            (setq #ang (nth 2 #xd$))

            ;2018/07/12 木製ｶｳﾝﾀｰ対応
            (setq #fig$ (KcChkWCounterItem$ #fig$))

            (if (not (setq #en (KcSetUniqueItem "CHG" #fig$ nil nil #eCH)))
              ;CHGﾓｰﾄﾞでPcSetItemを呼び出せば内部でUndo"b"して返ってくる。
              (setq #en (PcSetItem "CHG" nil #FIG$ #pt #ang nil #eCH))
            ); if
            (setq #eCH nil) ; 入替ｺﾏﾝﾄﾞは繰り返さない 01/04/18 YM ADD
          )
        );_if
      )
    );_if
  );while

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

  (CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  (princ)
)
;C:ChgParts

;<HOM>*************************************************************************
; <関数名>    : BaseParts
; <処理概要>  : 基準アイテム
; <戻り値>    :
; <作成>      : 1999-06-14 (1999-10-22 山田 性格CODE部分 修正 / 1999-12-01 修正)
; <備考>      :
;*************************************************************************>MOH<
(defun C:BaseParts (
    /
    #en #ps #xd$ #pt #Seikaku_1
  )
  ;// コマンドの初期化
  ;(StartCmnErr);00/09/07 SN MOD
  (StartUndoErr);00/09/07 SN MOD Undoに変更
  (CFCmdDefBegin 6);00/09/07 SN ADD
  (setq #en T)
  (while #en
    (setq #en (car (entsel "\n基準とするアイテムまたは解除する基準アイテムを選択: ")));00/07/03 SN MOD
    ;(setq #en (car (entsel "\n基準アイテムとする部材を選択: ")));00/07/03 SN MOD
    (if (/= #en nil)
      (progn
        (setq #en (SearchGroupSym #en))
        (if (= #en nil)
          (progn
            (CFAlertMsg "基準とするアイテムまたは解除する基準アイテムを選択して下さい ");00/07/03 SN MOD
            ;(CFAlertMsg "基準アイテムとする部材を選択して下さい ");00/07/03 SN MOD
            (setq #en T)
          )
          (progn ; ｼﾝﾎﾞﾙあり
;;;00/04/20 DEL MH 基準ｱｲﾃﾑの制限を外す
;;;            (setq #Seikaku_1 (SKY_DivSeikakuCode (nth 9 (CFGetXData #en "G_LSYM")) 1))
;;;            (if (/= nil (member #Seikaku_1 (list CG_SKK_ONE_GAS CG_SKK_ONE_SNK CG_SKK_ONE_WTR CG_SKK_ONE_CNT)))
;;;              (CFAlertMsg "この部材は基準アイテムにできません")
;;;              (progn

                (if (CfGetXData #en "G_KUTAI") ; 01/09/25 YM MOD
;;;01/09/25YM@DEL               (if (or (CfGetXData #en "G_KUTAI")  ; 躯体だった 01/02/20 YM
;;;01/09/25YM@DEL                       (CfGetXData #en "G_WAC")) ; 01/09/18 YM ADD 広角度ｷｬﾋﾞ
                  (progn
                    (setq #en T)
                    (CFAlertMsg "この部材は基準アイテムにできません") ; 01/02/20 YM
                  )
                  (progn

                    (command "_undo" "m")
                    (ResetBaseSym)
                    ;;;00/06/16 SN S-MOD
                    ;;;選択済み部材を基準アイテムとされた場合は基準アイテムキャンセル
                    (if (and (/= CG_BASESYM nil)
                             (= (cdr (assoc 5 (entget CG_BASESYM)))
                                (cdr (assoc 5 (entget #en)))))
                      (progn
                        (if (CFYesNoDialog "この基準アイテムをキャンセルしてよろしいですか？");00/07/03 SN MOD
                        ;(if (CFYesNoDialog "この基準アイテム部材をキャンセルしてよろしいですか？");00/07/03 SN MOD
                          (progn
                            (command "_undo" "b") ;00/09/07 SN ADD
                            (ResetBaseSym)        ;00/09/07 SN ADD
                            (CFSetXRecord "BASESYM" nil)
                            (setq CG_BASESYM nil)
                            (setq #en nil)
                          )
                          (command "_undo" "b")
                        )
                      )
                      (progn
                        ; 00/06/16 SN S-Original Program
                        (GroupInSolidChgCol #en CG_BaseSymCol)
                        (if (CFYesNoDialog "このアイテムを基準としてよろしいですか？");00/07/03 SN MOD
                        ;(if (CFYesNoDialog "この部材を基準アイテムとしてよろしいですか？");00/07/03 SN MOD
                          (progn
                            (command "_undo" "b") ;00/09/07 SN ADD
                            (ResetBaseSym)        ;00/09/07 SN ADD
                            (GroupInSolidChgCol #en CG_BaseSymCol);00/09/07 SN ADD
                            (CFSetBaseSymXRec #en)
                            (setq #en nil)
                          )
                          (command "_undo" "b")
                        )
                        ; 00/06/16 SN E-Original Program
                      )
                    );_if

                  )
                );_if  01/02/20 YM

;;;00/06/16 SN E-MOD
;;;              )
;;;            )
          )
        )
      )
    );_if
  );while

  (CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  (princ)
)
;C:BaseParts

(defun C:CntPartsR () (CntParts "R"))
(defun C:CntPartsL () (CntParts "L"))
(defun C:CntPartsT () (CntParts "T"))
(defun C:CntPartsD () (CntParts "D"))

;06/04/26 YM ADD 連続前配置
(defun C:CntPartsF () (CntParts "F"))

;<HOM>*************************************************************************
; <関数名>    : CntParts
; <処理概要>  : 連続配置
; <戻り値>    :
; <作成>      : 1999-06-14 (1999-10-25 山田 修正)
; <備考>      :
;*************************************************************************>MOH<
(defun CntParts (
  &type           ;向き  "L" "R" "T" "D"
  /
  #xd$ #fig$ #w #d #h #w2 #d2 #h2 #P&A$ #pt #ang
  #sCd        ; 性格CODE
  )
;;;01/09/03YM@MOD  ;// コマンドの初期化
;;;01/09/03YM@MOD  (StartCmnErr)

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 前処理
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO処理追加

  ;;; 画層をすべてﾌﾘｰｽﾞ解除 00/06/21 YM
;;;  (command "_layer" "T" "*" "") ; 00/06/22 YM

  (setq CG_BASESYM (CFGetBaseSymXRec))
  (if (not CG_BASESYM)
    (CFAlertMsg "基準アイテムがありません.基準アイテムを選択して下さい"))
  (setq #xd$ (CFGetXData CG_BASESYM "G_SYM"))
  (setq #pt (cdr (assoc 10 (entget CG_BASESYM))))
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #h (nth 5 #xd$))

  (setq #xd$ (CFGetXData CG_BASESYM "G_LSYM"))
  (if (setq #fig$ (SKY_GetItemInfo))
    (progn
      (setq #w2  (fix (nth 5 #fig$)))
      (setq #d2  (fix (nth 6 #fig$)))
      (setq #h2  (fix (nth 7 #fig$)))
      (setq #sCd (fix (nth 8 #fig$))) ; 01/06/17 HN ADD
    )
    (CFAlertErr "品番情報を取得できませんでした")
  );_if

;-- 2011/08/03 A.Satoh Add - S
  ; 扉グレード別配置不可部材チェック
  (if (= (CheckDoorGradeFree (nth 0 #fig$) CG_DRSeriCode CG_DRColCode) nil)
    (progn
      (CfAlertMsg "選択した品番は、現在の扉グレード、扉色のとき配置できません。")
      (exit)
    )
  )
;-- 2011/08/03 A.Satoh Add - E

  ;// 挿入基点と挿入角度を求める  00/07/17 MH 関数化
  ; 01/06/17 HN MOD 配置アイテムの性格CODEを追加
  ;@MOD@(setq #P&A$
  ;@MOD@  (PcArrangeInsPnt #pt &type #fig$ CG_BASESYM #xd$ (list #w #d #h) (list #w2 #d2 #h2)))
  (setq #P&A$
    (PcArrangeInsPnt #pt &type #fig$ CG_BASESYM #xd$ (list #w #d #h) (list #w2 #d2 #h2) #sCd))
  (setq #pt  (car  #P&A$))
  (setq #ang (cadr #P&A$))

  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart) ; 00/02/07 @YM@ 追加

  ;2018/07/12 木製ｶｳﾝﾀｰ対応
  (setq #fig$ (KcChkWCounterItem$ #fig$))

  (if (not (KcSetUniqueItem "CNT" #fig$ CG_BASESYM &type nil))
    ;;;特殊部材以外の部材の処理
    (PcSetItem "CNT" &type #fig$ #pt #ang CG_BASESYM nil)
  ); end of if

  (CFNoSnapEnd)  ;// Ｏスナップ関連システム変数を元に戻す

;;; 00/06/20 YM
;;; 表示画層の設定
;;;  (command "_layer"
;;;    "F"   "*"                ;全ての画層をフリーズ
;;;    "T"   "Z_00*"            ;  Z_00立体ソリッド画層のフリーズ解除
;;;    "T"   "N_*"              ;  N_*シンボル原点図形画層のフリーズ解除
;;;    "T"   "M_*"              ;  M_*目地領域図形画層の解除
;;;    "T"   "0"                ;  "0"画層の解除
;;;    "ON"  "M_*"              ;  M_*目地領域図形画層の表示
;;;    "OFF" "N_B*" ""          ;  N_B*ブレークライン図形の非表示
;;;  )
;;; 00/06/20 YM

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

  (setq *error* nil)
  (princ)
);CntParts

;<HOM>*************************************************************************
; <関数名>    : PcArrangeInsPnt
; <処理概要>  : 連続モードの方向で挿入基点を移動させる
; <戻り値>    : 移動させた後の点座標 と 挿入角度のリスト
; <作成>      : 00/07/17 MH
; <改訂>      : 01/06/17 HN 連続コンロ配置修正
; <備考>      : コンロ以外の"T"と"D"は 基準アイテムのH方向フラグと挿入図形の
;             : H方向フラグによる図形移動で処理するため挿入点の移動はない。
;*************************************************************************>MOH<
(defun PcArrangeInsPnt (
  &dPT        ; 基点
  &sDIR       ; 方向 "L" "R" "T" "D"
  &FIG$       ; 挿入する図形のリスト
  &eBASESYM   ; 基準となる図形
  &XL$        ; 基準図形のLSYM
  &bsWDH$     ; 基準図形のWDHリスト
  &insWDH$    ; 新設図形のWDHリスト
  &sCd        ; 新設図形の性格CODE  ;01/06/17 HN ADD
  /
  #dPT #fANG #iSKK #chk4P$ #i #ss #en #eg #dSP #dEP
#ANG1 #ANG2 #BASE #P1 #P2 #P3 #P4 #P5 #P6 #PMEN2 #PT$ ; 01/09/25 YM ADD
#DIST #HEIGHT #LAST #ZZ
  )

        ;--------------------------------------------------------------------
        (defun ##DelLastPT (
          &pt$ ; 点列
          /

          )
          (setq #st (nth 0 &pt$))
          (setq #ed (last  &pt$))
          (if (< (distance #st #ed) 0.1)
            (setq #ret$ (reverse (cdr (reverse &pt$)))) ; 始点=終点なら終点削除
            (setq #ret$ &pt$)
          );_if
          #ret$
        )
        ;--------------------------------------------------------------------
  (setq #dPT &dPT)
  ; 02/03/27 YM ADD 基点Z座標をﾌﾟﾗｽ
  (setq #ZZ (nth 2 #dPT))

  (setq #fANG (nth 2 &XL$)) ;基準図形の角度(初期値)
  (setq #iSKK (nth 9 &XL$)) ;基準図形の性格CODE
  (cond
    ((= &sDIR "L")
      ;// コーナーキャビが基準の場合は特別処理
      (if (= (SKY_DivSeikakuCode #iSKK 3) CG_SKK_THR_CNR)
        (progn

          ; 01/09/25 YM 広角度ｺｰﾅｰｷｬﾋﾞ対応 MOD-S
          ; ｺｰﾅｰｷｬﾋﾞ
          ; p1          p2
          ; +-----------+
          ; |           |
          ; |           |
          ; |     +-----+
          ; |     |p4   p3
          ; |     |
          ; +-----+
          ; p6    p5
          (setq #pmen2 (PKGetPMEN_NO &eBASESYM 2))   ; PMEN2
          (setq #pt$ (GetLWPolyLinePt #pmen2))  ; PMEN2 外形領域
          ; 始点=終点の場合終点を除去する 02/02/14 YM ADD
          (setq #pt$ (##DelLastPT #pt$))

          ; 5角形対応 02/02/14 YM ADD
          (if (= 5 (length #pt$))
            (progn
              (setq #base (cdr (assoc 10 (entget &eBASESYM)))); ｺｰﾅｰ基点座標
            )
            (progn ; 従来ﾛｼﾞｯｸ
              (setq #base (PKGetBaseL6 #pt$))       ; ｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙを見ない)
            )
          );_if

          (setq #pt$ (GetPtSeries #base #pt$)); #base を先頭に時計周り
          (setq #p1 (nth 0 #pt$))
          (setq #p2 (nth 1 #pt$))
          (setq #p3 (nth 2 #pt$))
          (setq #p4 (nth 3 #pt$))
          (setq #p5 (nth 4 #pt$))

;;;02/02/14YM@MOD         (setq #p6 (nth 5 #pt$))
          (setq #last (last #pt$)) ; 02/02/14 YM ADD

          (setq #ang1 (angle #p1 #p2))

;;;02/02/14YM@MOD         (setq #ang2 (angle #p1 #p6))
          (setq #ang2 (angle #p1 #last)) ; 02/02/14 YM ADD

          (setq #ang1 (Angle0to360 #ang1)) ; 0～360度の値にする
          (setq #ang2 (Angle0to360 #ang2)) ; 0～360度の値にする

          (setq #fANG (+ #fANG (- (- #ang2 #ang1)(* 2 PI))))
          ; 01/09/25 YM 広角度ｺｰﾅｰｷｬﾋﾞ対応 MOD-E

;;;01/09/25YM@DEL          (setq #fANG (+ #fANG (DTR -90)))
          (setq #dPT (polar #dPT #fANG (+ (cadr &bsWDH$) (car &insWDH$))))
          (setq #fANG (+ #fANG (DTR 180)))
        )
        ; コーナーキャビ以外のアイテム
        (setq #dPT (polar #dPT (+ pi #fANG) (car &insWDH$)))
      )
    ); "L"

    ((= &sDIR "R")
      ;// コーナーキャビが挿入するアイテムの場合は特別処理
      (if (= (SKY_DivSeikakuCode (fix (nth 8 &FIG$)) 3) CG_SKK_THR_CNR)
        (progn
          (setq #dPT (polar #dPT #fANG (+ (car &bsWDH$) (cadr &insWDH$))))
          (setq #fANG (- #fANG (DTR 90)))
        )
        ; コーナーキャビ以外のアイテム
        (setq #dPT (polar #dPT #fANG (car &bsWDH$)))
      )
    ); "R"


    ;06/04/26 YM ADD-S 連続前配置
    ((= &sDIR "F")
      (setq #dPT (polar #dPT (- #fANG (/ pi 2)) (nth 1 &bsWDH$)))

      ;06/08/14 YM MOD-S ﾒｯｾｰｼﾞ追加
      (if (= (SKY_DivSeikakuCode (nth 8 &FIG$) 2) CG_SKK_TWO_UPP)
        (setq #height CG_UpCabHeight)
        (setq #height 0)
      );_if
      (setq #dist (getdist (strcat "\n設置高さ<" (itoa #height) ">: ")))
      (if (=  #dist nil) (setq #dist #height))
      (setq #dPT (list (car #dPT) (cadr #dPT) #dist))
      ;06/08/14 YM MOD-E ﾒｯｾｰｼﾞ追加

    ); "R"


; コーナーコンロ対応 01/08/22 YM MOD-S ---------------------------------------------------------
    ; コンロを連続上配置のときPLINが存在すればPLIN合わせ,なければ基準点合わせ.(性格CODEはみない)
    ((and (= &sDIR "T") (= CG_SKK_INT_GAS &sCd)); 連続上配置で上が"210"ｺﾝﾛのとき ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
      (setq #en (PKGetPLIN_NO &eBASESYM 2)) ; PLIN2図形(LINE)
      (if #en
        (progn
          (setq #dSP (cdr (assoc 10 (entget #en))))
          (setq #dEP (cdr (assoc 11 (entget #en))))
          (setq #fANG (angle #dSP #dEP)) ; PLIN角度
          (setq #dPT (list (car #dSP) (cadr #dSP) (caddr &dPT))) ; 02/03/28 YM MOD 台輪対応
        )
        (setq #dPT nil)
      );_if

      (if (not #dPT)
        (setq #dPT &dPT) ; コンロ取り付け線が見つからないときは基準キャビの基点とする(エラーとしない) 01/07/06 YM MOD
      );_if
    ); "T" でガスコンロだった
; コーナーコンロ対応 01/08/22 YM MOD-E ---------------------------------------------------------

; コーナーコンロ対応 01/08/22 YM DEL-S ---------------------------------------------------------
;;;01/08/22YM@    ;// "T"ガスコンロは取り付け線に合わせる
;;;01/08/22YM@    ; 01/06/17 HN MOD 配置シンボルがコンロかどうか判定を追加
;;;01/08/22YM@    ;@@@((and (= &sDIR "T") (= (SKY_DivSeikakuCode #iSKK 3) CG_SKK_THR_GAS))
;;;01/08/22YM@    ((and (= &sDIR "T") (= (SKY_DivSeikakuCode #iSKK 3) CG_SKK_THR_GAS) (= CG_SKK_INT_GAS &sCd)) ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
;;;01/08/22YM@; 連続上配置で下が"113"ｺﾝﾛｷｬﾋﾞ上が"210"ｺﾝﾛのとき
;;;01/08/22YM@
;;;01/08/22YM@      ; 00/04/26 MH 領域判定に使う基準アイテム4点（10cm広くした）
;;;01/08/22YM@      (setq #chk4P$ (PcGetItem4P$ &eBASESYM 100 100 100 100))
;;;01/08/22YM@      (setq #ss (ssget "X" '((-3 ("G_PLIN"))))) ; <---変更したいが連続配置で視点が真上からになるが嫌なのでこのまま
;;;01/08/22YM@      (if (/= #ss nil)
;;;01/08/22YM@        (progn
;;;01/08/22YM@          (setq #i 0)
;;;01/08/22YM@          (setq #dPT nil)
;;;01/08/22YM@          (repeat (sslength #ss)
;;;01/08/22YM@            (setq #en (ssname #ss #i))
;;;01/08/22YM@            (setq #eg (entget #en))
;;;01/08/22YM@            (if (and (= #dPT nil)
;;;01/08/22YM@                     (= (cdr (assoc 0 #eg)) "LINE")
;;;01/08/22YM@                     (= 2 (car (CFGetXData #en "G_PLIN"))))
;;;01/08/22YM@              (progn
;;;01/08/22YM@                ; 00/11/13 MH MOD  連続配置-上でコンロ取付基準線にコンロを配置する
;;;01/08/22YM@                ; 場合、コンロ取り付け基準線の始点をコンロの基準点とし、
;;;01/08/22YM@                ; 始点→終点を配置方向として配置角度を決める
;;;01/08/22YM@                (setq #dSP (cdr (assoc 10 (entget #en))))
;;;01/08/22YM@                (setq #dEP (cdr (assoc 11 (entget #en))))
;;;01/08/22YM@                ;;; 00/04/26 MH MOD 領域外であれば nil 代入
;;;01/08/22YM@                (if (JudgeNaigai #dSP (append #chk4P$ (list (car #chk4P$))))
;;;01/08/22YM@                  (progn
;;;01/08/22YM@                    (setq #fANG (angle #dSP #dEP))
;;;01/08/22YM@                    (setq #dPT (list (car #dSP) (cadr #dSP) 0))
;;;01/08/22YM@  ;;;01/07/02YM@                  (setq #dPT (list (car #dSP) (cadr #dSP) (caddr &bsWDH$)))
;;;01/08/22YM@                  ); progn
;;;01/08/22YM@                  (setq #dPT nil)
;;;01/08/22YM@                );if
;;;01/08/22YM@              )
;;;01/08/22YM@            ); if
;;;01/08/22YM@            (setq #i (1+ #i))
;;;01/08/22YM@          ); repeat
;;;01/08/22YM@        )
;;;01/08/22YM@      );_if progn
;;;01/08/22YM@      (if (not #dPT)
;;;01/08/22YM@        (progn
;;;01/08/22YM@          (setq #dPT &dPT) ; コンロ取り付け線が見つからないときは基準キャビの基点とする(エラーとしない) 01/07/06 YM MOD
;;;01/08/22YM@;;;01/07/06YM@          (CFAlertMsg
;;;01/08/22YM@;;;01/07/06YM@            "設置範囲にコンロ取り付け線が見つからないため\n \nコンロ挿入基点が求まりません")
;;;01/08/22YM@;;;01/07/06YM@          (princ)
;;;01/08/22YM@;;;01/07/06YM@          (*error*)
;;;01/08/22YM@        )
;;;01/08/22YM@      );if progn
;;;01/08/22YM@      (if (> 150 (distance (list 0 0) (list (car #dPT) (cadr #dPT))))
;;;01/08/22YM@        (progn
;;;01/08/22YM@          (if (CFPosOKDialog "ガスコンロは壁から150mm 以上離す必要があります。")
;;;01/08/22YM@            (princ)
;;;01/08/22YM@            (*error*)
;;;01/08/22YM@          )
;;;01/08/22YM@        )
;;;01/08/22YM@      );_if
;;;01/08/22YM@    ); "T" でガスコンロだった
;;;01/08/22YM@
; コーナーコンロ対応 01/08/22 YM DEL-S ---------------------------------------------------------

    (t nil)
  ); cond

  ;@DEBUG@(princ "\nPcArrangeInsPnt")
  ;@DEBUG@(princ "\n#dPT: " )(princ #dPT )
  ;@DEBUG@(princ "\n#fANG: ")(princ #fANG)
  (list #dPT #fANG)
); PcArrangeInsPnt

;<HOM>*************************************************************************
; <関数名>    : SKY_Stretch_Parts
; <処理概要>  : 伸縮
; <戻り値>    :
; <作成>      : 1999-11-08 山田
; <備考>      :
;*************************************************************************>MOH<
(defun SKY_Stretch_Parts (
  &sym      ;シンボル図形
  &val_w    ;寸法Ｗ
  &val_d    ;寸法Ｄ
  &val_h    ;寸法Ｈ
  /
  #fANG #dPT #ORG$ #rtFLG #TMP$ #i #A #OS #SM
  #xd$ #xld$ #val_w #val_d #val_h #MSG #QLY$ #VIEWEN
#LIST$ #NCODE #QLY$$ ; 03/03/28 YM ADD
  )
  ; Win98角度180,270で設置位置がずれる不具合への対処
  (setq #os (getvar "OSMODE"))   ;Oスナップ
  (setq #sm (getvar "SNAPMODE")) ;スナップ
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)

  (setq #viewEn (MakeWorkView)) ; 00/02/29 YM ADD
  (if (= nil &sym)
    (CFAlertMsg "アイテムではありません")
    (progn
      ;// グループの図形を色替え
      (if (or CG_TOKU CG_WAC) ; 01/09/18 YM MOD
        nil ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中
        (progn
          (command "_undo" "m")
          (GroupInSolidChgCol &sym CG_InfoSymCol)
        )
      );_if

      (setq #xd$ (CFGetXData &sym "G_SYM"))
      (setq #xld$ (CFGetXData &sym "G_LSYM"))

      ; 03/03/28 YM MOD-S 品番基本検索
      (setq #List$ (list (list "品番名称" (nth 5 #xld$) 'STR)))
      (setq #QLY$$ (CFGetDBSQLRec CG_DBSESSION "品番基本" #List$))
      (if (and #QLY$$ (= 1 (length #QLY$$)))
        (setq #nCODE (nth 7 (car #QLY$$)))
        (setq #nCODE -1) ; 入力コード
      );_if
      ; 03/03/28 YM MOD-E 品番基本検索

      ;;; 00/06/20 MH MOD 伸縮比較の対象値を DB か G_SYM に分岐判断
      (cond
        ; SelParts.cfg が有り、かつ入力コードが 0 以上なら｢品番図形｣のWDH値で差分検出
        ((and (not KEKOMI_COM)(not CG_TOKU) ; ｹｺﾐ伸縮,特注ｷｬﾋﾞｺﾏﾝﾄﾞでない
              (findfile (strcat CG_SYSPATH "SELPARTS.CFG"))
              (< 0 #nCODE)) ; 03/03/28 YM MOD
;;; 03/03/28 YM "SELPARTS.CFG"が存在して、ｹｺﾐ伸縮後にﾐﾗｰ反転したらｼﾝｸが品番基本にないので
;;;              強制終了してしまうのでPcGetPartQLY$は使えない
;;;              (< 0 (nth 11 (PcGetPartQLY$  "品番基本" (nth 5 #xld$) nil nil))))

          (setq #QLY$ (PcGetPartQLY$  "品番図形" (nth 5 #xld$) (nth 6 #xld$) (nth 12 #xld$)))
;-- 2011/09/13 A.Satoh Mod - S
;          (setq #val_w (if (/= (nth 4 #QLY$) &val_w) &val_w 0))
;          (setq #val_d (if (/= (nth 5 #QLY$) &val_d) &val_d 0))
;          (setq #val_h (if (/= (nth 6 #QLY$) &val_h) &val_h 0))
          (setq #val_w (if (/= (nth 3 #QLY$) &val_w) &val_w 0))
          (setq #val_d (if (/= (nth 4 #QLY$) &val_d) &val_d 0))
          (setq #val_h (if (/= (nth 5 #QLY$) &val_h) &val_h 0))
;-- 2011/09/13 A.Satoh Mod - E
        )
        ;それ以外は対象図形のG_SYMのWDH値で差分検出
        (t (setq #val_w (if (/= (nth 3 #xd$) &val_w) &val_w 0))
           (setq #val_d (if (/= (nth 4 #xd$) &val_d) &val_d 0))
           (setq #val_h (if (/= (nth 5 #xd$) &val_h) &val_h 0)) )
      ); cond
      ;;; 00/06/20 MH MOD 変更ここまで

      (if (or CG_TOKU CG_WAC) ; 01/09/18 YM MOD
        nil ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中
        (progn
          (command "_undo" "b")
        )
      );_if

      ;;; 00/07/19 MH ADD
      ; 対象図形は0度または90度以外の場合、回転して0度に
      (setq #fANG (nth 2 #xld$))
      (if (or (equal 0 (RTD #fANG) 0.1) (equal 90 (RTD #fANG) 0.1))
        (setq #rtFLG nil)
        ; アイテム回転, LSYM 挿入角度変更, #xld$再設定
        (progn
          (setq #rtFLG 'T)
          (setq #dPT (cdr (assoc 10 (entget &sym))))
          (command "_rotate" (CFGetSameGroupSS &sym) "" #dPT "R" (RTD #fANG) 0)
          (setq #i 0)
          (setq #TMP$ nil)
          (setq #ORG$ #xld$)
          (foreach #A #xld$
            (setq #TMP$ (append #TMP$  (if (= 2 #i) '(0) (list #A))))
            (setq #i (1+ #i))
          ); foreach
          (CFSetXData &sym "G_LSYM" #TMP$)
          (setq #xld$ (CFGetXData &sym "G_LSYM"))
        ); progn
      ); if

      ;// 部材の拡張ﾃﾞｰﾀのｻｲｽﾞを更新
      (CFSetXData &sym "G_SYM"
        (list
          (nth 0 #xd$)    ;シンボル名称
          (nth 1 #xd$)    ;コメント１
          (nth 2 #xd$)    ;コメント２
          (nth 3 #xd$)    ;シンボル基準値Ｗ
          (nth 4 #xd$)    ;シンボル基準値Ｄ
          (nth 5 #xd$)    ;シンボル基準値Ｈ
          (nth 6 #xd$)    ;シンボル取付け高さ
          (nth 7 #xd$)    ;入力方法
          (nth 8 #xd$)    ;Ｗ方向フラグ
          (nth 9 #xd$)    ;Ｄ方向フラグ
          (nth 10 #xd$)   ;Ｈ方向フラグ
          #val_w          ;伸縮フラグＷ
          #val_d          ;伸縮フラグＤ
          #val_h          ;伸縮フラグＨ
          (nth 14 #xd$)   ;ブレークライン数Ｗ
          (nth 15 #xd$)   ;ブレークライン数Ｄ
          (nth 16 #xd$)   ;ブレークライン数Ｈ
        )
      )

      (command "_view" "S" "TEMP")
      ;(setvar "PICKSTYLE" 1)
      (StretchPartsSub &sym)

      ;;; 00/07/19 MH ADD
      ; フラグ確認 対象図形が伸縮処理前に回転されていたなら元の角度に戻す
      (if #rtFLG (progn
        (setq #dPT (cdr (assoc 10 (entget &sym))))
        (command "_rotate" (CFGetSameGroupSS &sym) "" #dPT "R" 0 (RTD #fANG))
        (CFSetXData &sym "G_LSYM" #ORG$)
      )); if&progn
      (command "_view" "R" "TEMP")
    )
  )

  (if (/= #viewEn nil) (entdel #viewEn)) ; 00/02/29 YM ADD
  ;// システム変数を元に戻す
  (setvar "OSMODE"   #os)
  (setvar "SNAPMODE" #sm)
  (princ)
)
;SKY_Stretch_Parts

;<HOM>*************************************************************************
; <関数名>    : StretchParamDlg
; <処理概要>  : 要素変更ﾀﾞｲｱﾛｸﾞ
; <戻り値>    :
; <作成>      : 1998-05-08 (1999-11-09 山田 引数追加)
; <備考>      :
;*************************************************************************>MOH<
(defun StretchParamDlg (
    &w
    &d
    &h
    &InputCode
    /
    #dcl_id
    #xd$
    #res$
  )
  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMain.DCL")))
  (if (not (new_dialog "StretchParamDlg" #dcl_id)) (exit))
  (set_tile "w" (itoa (fix &w)))
  (set_tile "d" (itoa (fix &d)))
  (set_tile "h" (itoa (fix &h)))
  (mode_tile "w" 0)
  (mode_tile "d" 0)
  (mode_tile "h" 0)
  (if (< &InputCode 4) (mode_tile "w" 1))
  (if (or (= &InputCode 1) (= &InputCode 4) (= &InputCode 5)) (mode_tile "d" 1))
  (if (or (= &InputCode 2) (= &InputCode 4) (= &InputCode 6)) (mode_tile "h" 1))
  (mode_tile (substr "hddwwww" &InputCode 1) 2)

  (action_tile "accept" "(setq #res$ (StretchParamDlgOK))")
  (action_tile "cancel" "(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #res$
)
;StretchParamDlg

;<HOM>*************************************************************************
; <関数名>    : NRPrimDlgOK
; <処理概要>  : 要素入力ﾀﾞｲｱﾛｸﾞOK
; <戻り値>    :
; <作成>      : 1998-05-08
; <備考>      :
;*************************************************************************>MOH<
(defun StretchParamDlgOK (
    /
    #h #th #ang #ptp #rtp
    #D #W
  )
  (setq #w (get_tile "w"))
  (setq #d (get_tile "d"))
  (setq #h (get_tile "h"))

  ;// 入力ﾁｪｯｸ
  (if (and
    (or (equal 'INT (type (read #w)))(equal 'REAL (type (read #w))))
    (or (equal 'INT (type (read #d)))(equal 'REAL (type (read #d))))
    (or (equal 'INT (type (read #h)))(equal 'REAL (type (read #h))))
    )
    (progn
      (setq #w (atof #w))
      (setq #d (atof #d))
      (setq #h (atof #h))
      (done_dialog)
      (list #w #d #h)
    )
  ;else
    (progn
      (c:msgbox "有効な値を設定してください." "警告" MB_ICONEXCLAMATION)
      nil
    )
  )
)
;StretchParamDlgOK

;<HOM>*************************************************************************
; <関数名>    : StretchPartsSUB
; <処理概要>  : 要素図形の拡張データ情報から要素を再作成する
; <戻り値>    :
; <作成>      : 1998-07-30 → 00/06/22 MH MOD
; <備考>      : Pcstretch.lspのSKS_StretchPartsSubと全く同じ内容だと思う YM
;*************************************************************************>MOH<
(defun StretchPartsSUB (
    &sym
    /
    #ss #i #en #eg #300 #330 #sym #xd$ #gnam
    #EG$ #EG2$ #EN2 #H #XD_LSYM$
    #OSMODE #SNAPMODE
#BASE #CORNERD1 #CORNERD2 #P1 #P2 #P3 #P4 #P5 #P6 #PMEN2 #PT$ ; 01/09/25 YM ADD
  )
  (setvar "PICKSTYLE" 0)
  ; 伸縮しないとき CG_NO_STRETCH=T (部材更新時に使用する)
  (setq CG_NO_STRETCH nil) ; 02/03/26 YM ADD

  ;// Ｏスナップ関連システム変数の除
  ;00/07/27 SN MOD CFNoSnapStartは外部変数に値を格納するの、
  ;                重複呼び出しを行うと元の値が破棄される。
  (setq #OSMODE   (getvar "OSMODE"))
  (setq #SNAPMODE (getvar "SNAPMODE"))
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)
  ;(CFNoSnapStart); 00/02/07 @YM@ 追加

  (setq #en &sym)
  (setq #xd$ (CFGetXData #en "G_SYM"))


; 01/05/31 YM 特殊処理 01/09/25 YM ADD ｺｰﾅｰｷｬﾋﾞの扉移動処理追加 ------------------------------
(if CG_TOKU
  (if (= (CFGetSymSKKCode #en 3) CG_SKK_THR_CNR)
    (progn ; ｺｰﾅｰｷｬﾋﾞ
      ; p1          p2
      ; +-----------+
      ; |           |
      ; |           |
      ; |     +-----+
      ; |     |p4   p3
      ; |     |
      ; +-----+
      ; p6    p5
      (setq #pmen2 (PKGetPMEN_NO #en 2))    ; PMEN2
      (setq #pt$ (GetLWPolyLinePt #pmen2))  ; PMEN2 外形領域
      (setq #base (PKGetBaseL6 #pt$))       ; ｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙを見ない)
      (setq #pt$ (GetPtSeries #base #pt$))  ; #base を先頭に時計周り
      (setq #p1 (nth 0 #pt$))
      (setq #p2 (nth 1 #pt$))
      (setq #p3 (nth 2 #pt$))
      (setq #p4 (nth 3 #pt$))
      (setq #p5 (nth 4 #pt$))
      (setq #p6 (nth 5 #pt$))
      (setq #cornerD1 (distance #p2 #p3))
      (setq #cornerD2 (distance #p5 #p6))

      (if (and CG_TOKU_BW (/= (nth 11 #xd$) 0); 特注ｷｬﾋﾞｺﾏﾝﾄﾞW方向伸縮時、扉をW方向に移動する量(右側面)
               (< CG_TOKU_BW #cornerD2))
        ; +-|-------+
        ; | |       |
        ; | | +-----+
        ; | | |
        ; +-|-+
        ; 正:扉法線ﾍﾞｸﾄﾙ方向(扉から矢印が出る)
        (setq CG_DOOR_MOVE06 (- (nth 11 #xd$)(nth 3 #xd$))) ; 01/09/25 W方向伸縮量
      );_if

      (if (and CG_TOKU_BD (/= (nth 12 #xd$) 0); 特注ｷｬﾋﾞｺﾏﾝﾄﾞD方向伸縮時、扉をD方向に移動する量
               (< CG_TOKU_BD #cornerD1))
        ; +---------+
        ;------------
        ; |   +-----+
        ; |   |
        ; +---+
        ; 正:扉法線ﾍﾞｸﾄﾙ方向(扉から矢印が出る)
        (setq CG_DOOR_MOVE03 (- (nth 12 #xd$)(nth 4 #xd$))) ; 01/05/31 D方向伸縮量
      );_if

;;;     (if (and (/= (nth 12 #xd$) 0); 特注ｷｬﾋﾞｺﾏﾝﾄﾞD方向伸縮時、扉をD方向に移動する量
;;;              (>= CG_TOKU_BD #cornerD1))
;;;       (progn
;;;       ; +---------+
;;;       ; |         |
;;;       ; |   +-----+
;;;       ; ------
;;;       ; +---+   右側面扉を↑に移動する(特殊処理)
;;;       ; 正:扉法線ﾍﾞｸﾄﾙ方向(扉から矢印が出る)
;;;         (setq CG_DOOR_MOVE06 (- (nth 12 #xd$)(nth 4 #xd$))) ; 01/05/31 D方向伸縮量
;;;;;;          (setq CG_DOOR_MOVE_RIGHT T) ; 01/09/25 扉移動方向が正面ではなく、向かって右方向
;;;       )
;;;     );_if

    )
    (progn ; ｺｰﾅｰｷｬﾋﾞ以外(今までどおり)
      (if (/= (nth 12 #xd$) 0); 特注ｷｬﾋﾞｺﾏﾝﾄﾞD方向伸縮時、扉をD方向に移動する量
        ; 正:扉法線ﾍﾞｸﾄﾙ方向(扉から矢印が出る)
        (setq CG_DOOR_MOVE03 (- (nth 12 #xd$)(nth 4 #xd$))) ; 01/05/31 D方向伸縮量
      );_if
    )
  );_if
);_if
; 01/05/31 YM 特殊処理 01/09/25 YM ADD ｺｰﾅｰｷｬﾋﾞの扉移動処理追加 ------------------------------

  (if (or (/= 0 (fix (nth 11 #xd$))) (/= 0 (fix (nth 12 #xd$))) (/= 0 (fix (nth 13 #xd$))))
    (progn
      ;// ２Ｄ図形の伸縮
      ;(command "_layer" "T" "*" "")
      (SCEExpansion #en)
      ;// ３Ｄ図形の伸縮
      (setq #eg$ (entget (cdr (assoc 330 (entget #en)))))  ;// 親図面情報を取得
      (foreach #lst #eg$  ;// ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰ図形の取得
        (if (= 340 (car #lst))
          (progn
            (setq #en2 (cdr #lst))
            (setq #eg2$ (entget #en2 '("G_PRIM")))
            (if (and (/= nil #eg2$) (= (cdr (assoc 0 #eg2$)) "3DSOLID")
                     (= (cdr (assoc 8 #eg2$)) "Z_00_00_00_01") )
              ;00/06/22 MH"G_PRIM"関連図形名で"G_PRIM"データないものSKS_RemakePrim免除
              (if (CFGetXData #en2 "G_PRIM")
                (progn
                  (setq #gnam (SKGetGroupName #en2))
                  (setq #en2  (SKS_RemakePrim #en2))
                  (command "-group" "A" #gnam #en2 "")
                ); progn
                (progn
                  (setq #gnam (SKGetGroupName #en2))
                  (command "-group" "A" #gnam #en2 "")
                ); progn
              )
            )
          )
        )
      )
      (if (/= (nth 13 #xd$) 0)
        (setq #H (nth 13 #xd$))
        (setq #H (nth  5 #xd$)) ;シンボル基準値Ｈ
      )
      ;;; 出力寸法に反映するため(ｹｺﾐ伸縮)
      (setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
      (CFSetXData #en "G_LSYM"
        (CFModList #xd_LSYM$
;-- 2012/02/17 A.Satoh Mod CG対応 - S
;;;;;          (list (list 13 #H))
					(if (/= CG_SizeH nil)
	          (list (list 13 CG_SizeH))
  	        (list (list 13 #H))
					)
;-- 2012/02/17 A.Satoh Mod CG対応 - E
        )
      )

      ; 伸縮しなかったら更新しない 02/03/26 YM ADD
      (if CG_NO_STRETCH ; 02/03/26 YM ADD
        nil ; 02/03/26 YM ADD
        ; else 今までどおり
        (CFSetXData #en "G_SYM"
          (list
            (nth 0 #xd$)    ;シンボル名称
            (nth 1 #xd$)    ;コメント１
            (nth 2 #xd$)    ;コメント２
            (if (/= (nth 11 #xd$) 0)
              (nth 11 #xd$)
              (nth 3 #xd$)    ;シンボル基準値Ｗ
            )
            (if (/= (nth 12 #xd$) 0)
              (nth 12 #xd$)
              (nth 4 #xd$)    ;シンボル基準値Ｄ
            )
            #H
            (nth 6 #xd$)    ;シンボル取付け高さ
            (nth 7 #xd$)    ;入力方法
            (nth 8 #xd$)    ;Ｗ方向フラグ
            (nth 9 #xd$)    ;Ｄ方向フラグ
            (nth 10 #xd$)   ;Ｈ方向フラグ
            (nth 11 #xd$)   ;伸縮フラグＷ
            (nth 12 #xd$)
            (nth 13 #xd$)
            (nth 14 #xd$)   ;ブレークライン数Ｗ
            (nth 15 #xd$)   ;ブレークライン数Ｄ
            (nth 16 #xd$)   ;ブレークライン数Ｈ
          )
        )
      );_if
    )
  );_if

  ;// Ｏスナップ関連システム変数を元に戻す
  ;00/07/27 SN MOD CFNoSnapStartは外部変数に値を格納するの、
  ;                重複呼び出しを行うと元の値が破棄される。
  (setvar "OSMODE"   #OSMODE)
  (setvar "SNAPMODE" #SNAPMODE)
  ;(CFNoSnapEnd); 00/02/07 @YM@ 追加

  ; 伸縮しないとき CG_NO_STRETCH=T (部材更新時に使用する)
  (setq CG_NO_STRETCH nil) ; 02/03/26 YM ADD

  (command "_vpoint" "0,0,1")
  (command "_ucs" "w")
);StretchPartsSUB

;<HOM>*************************************************************************
; <関数名>    : PcGetAllItemBetween2Pnt
; <処理概要>  : 4点で表されるCP範囲中に位置するすべてのアイテム取得
; <戻り値>    : 選択セット (無ければ Nil)
; <作成>      : 00/06/26 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcGetAllItemBetween2Pnt (
  &PLIST
  /
  #PLIST #view$ #Sset #Sset2 #I #MOV
  #pdsize;00/07/12 SN ADD
  )
  (setq #PLIST (AddPtList &PLIST)) ; 末尾に始点を追加する
  (setq #pdsize (getvar "PDSIZE"));00/07/12 SN ADD
  (setvar "PDSIZE" 1)             ;00/07/12 SN ADD
  (setvar "PICKSTYLE" 0)
  (command "_vpoint" '(0 0 1))
  (setq #Sset (ssget "CP" #PLIST '((-3 ("G_LSYM")))))
  (command "zoom" "p")
  (setvar "PDSIZE" #pdsize);00/07/12 SN ADD

  ;; 取得図形ﾁｪｯｸ用色替
;;;(if #Sset (progn (setq #MOV nil)(setq #i 0)
;;;  (while (< #i (sslength #Sset))
;;;   (setq #MOV (cons (ssname #Sset #i) #MOV))
;;;   (setq #i (1+ #i))
;;;)))
(foreach ## #MOV (GroupInSolidChgCol2 ## 1))

#Sset
); PcGetAllItemBetween2Pnt

;<HOM>*************************************************************************
; <関数名>    : PcGetAllItemBetween2PntWT
; <処理概要>  : 4点で表されるCP範囲中に位置するすべてのワークトップ取得
; <戻り値>    : 選択セット (無ければ Nil)
; <作成>      : 00/07/24 SN
; <備考>      : 本関数はPcGetAllItemBetween2Pntと同処理でワークトップのみを取得する。
;*************************************************************************>MOH<
(defun PcGetAllItemBetween2PntWT (&PLIST / #PLIST #view$ #Sset
  #pdsize;00/07/12 SN ADD
  #wss #wi;00/07/24 SN ADD
  )
  (setq #PLIST &PLIST)

  (setq #pdsize (getvar "PDSIZE"));00/07/12 SN ADD
  (setvar "PDSIZE" 1)             ;00/07/12 SN ADD
  (setvar "PICKSTYLE" 0)
  (setq #view$ (getvar "VIEWDIR"));;; 要視点操作

  (command "_vpoint" '(0 0 1))
  (setq #Sset (ssget "CP" #PLIST '((-3 ("G_WRKT")))))
  (command "_vpoint" #view$)
  (setvar "PDSIZE" #pdsize);00/07/12 SN ADD
  #Sset
); PcGetAllItemBetween2PntWT

;<HOM>*************************************************************************
; <関数名>    : PcGetSameAreaItem$
; <処理概要>  : 範囲全図形のなかから#eNEXT$の各アイテムと同範囲 同高さのものを選択
; <戻り値>    : 図形名リスト なし= nil
; <作成>      : 00/06/26 MH
; <備考>      : コンロや足元温風機を摘出するのが目的
;*************************************************************************>MOH<
(defun PcGetSameAreaItem$ (
  &ss         ; 範囲全図形の選択セット
  &eNEXT$     ; 隣接キャビの名前リスト
  /
  #eRES$ #i #eALL$ #eAL #$ #TEMP$ #FLG #eNT
  )
  ; 選択セットから図形名リスト#eALL$ 作成
  (if &ss (progn
    (setq #i 0)
    (while (< #i (sslength &ss))
      (setq #eALL$ (cons (ssname &ss #i) #eALL$))
      (setq #i (1+ #i))
    ); while
  )); if
  ; #eALL$ 中から隣接キャビの名前を除く
  (if (and #eALL$ &eNEXT$) (progn
    (setq #TEMP$ nil)
    (foreach #eAL #eALL$
      (if (not (member #eAL &eNEXT$)) (setq #TEMP$ (cons #eAL #TEMP$)))
    ); foreach
    (setq #eALL$ #TEMP$)
  )); if progn
  (if (and #eALL$ &eNEXT$) (progn
    ; #eALL$ の図形が &eNEXT$ の図形と同高で範囲にかかれば#eRES$に取得させる。
    (setq #eRES$ nil)
    (foreach #eAL #eALL$
      (setq #i 0)
      (setq #FLG 'T)
      (while (and #FLG (setq #eNT (nth #i &eNEXT$)))
        (if (and (/= (CFGetSymSKKCode #eAL 1) CG_SKK_ONE_SID)
                 (= (CFGetSymSKKCode #eAL 2)(CFGetSymSKKCode #eNT 2))
                 (PcJudgeCrossArea #eNT #eAL)
            )
          (progn
            (setq #eRES$ (cons #eAL #eRES$))
            (setq #FLG nil)
          ); progn
        ); if
        (setq #i (1+ #i))
      ); while
    ); foreach
  )); if progn
  #eRES$
); PcAddSameAreaItem

;<HOM>*************************************************************************
; <関数名>    : PcJudgeCrossArea
; <処理概要>  : &eONE (大) の図形の範囲内に &eTWO (小) が位置するか？
; <戻り値>    : T or nil
; <作成>      : 00/06/26 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcJudgeCrossArea (
  &eONE       ; 図形(大)
  &eTWO       ; 図形(小)
  /
  #RES #1P$ #2P$ #dCK
  )
  ; チェックさせる4点(2次元点)を出す
  (setq #1P$ (PcGetItem4P$ &eONE 0 0 0 0))
  (setq #1P$ (append #1P$ (list (car #1P$))))
  (setq #2P$ (PcGetItem4P$ &eTWO 0 0 0 0))
  (setq #RES nil)
  (foreach #dCK #2P$
    (if (JudgeNaigai #dCK #1P$) (setq #RES 'T))
  ); foreach
  #RES
); PcJudgeCrossArea

;<HOM>*************************************************************************
; <関数名>    : PcGetNextItemSameLevel
; <処理概要>  : 指定図形に隣接するある条件下のアイテムを取得
; <戻り値>    : 図形名リスト 条件の図形がなければ Nil
; <作成>      : 00/06/24 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcGetNextItemSameLevel (
  &eITEM      ; 対象図形名
  &iCODE      ; 性格CODE2ケタ目
  /
  #NEXT$ #eNT #RES$
  )
  (setq #NEXT$ (PcGetEn$CrossArea &eITEM 0 0 0 0 'T))
  (foreach #eNT #NEXT$
    (if (equal (CFGetSymSKKCode #eNT 2) &iCODE 0.01) (setq #RES$ (cons #eNT #RES$)))
  ); foreach
  #RES$
); PcGetNextItemSameLevel

;<HOM>*************************************************************************
; <関数名>    : PcGetItemInAreaSameLevel
; <処理概要>  : 与えられたリンク図形の領域に掛かる同高さのアイテムを取得
; <戻り値>    : 図形名リスト 条件の図形がなければ Nil
; <作成>      : 00/06/26 MH
; <備考>      : リンク図形とダブらないもの(コンロ、足元温風機など)
;*************************************************************************>MOH<
(defun PcGetItemInAreaSameLevel (
  &eITEM$     ; リンク図形名リスト
  &iCODE      ; 性格CODE2ケタ目
  /
  #view$ #OutPLine #pt$ #ss #i #eCHK #RES$
  )
  (setq #view$ (getvar "VIEWDIR"));;; 要視点操作
  (setq #OutPLine (PKW_MakeSKOutLine &eITEM$ nil))
  (setq #pt$ (GetLWPolyLinePt #OutPline))
  (entdel #OutPline)
  (command "_vpoint" '(0 0 1))
  ; 領域内のアイテム摘出("G_LSYM")
  (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_LSYM")))))
  (command "_vpoint" #view$)
  ; 取得されたセットから高さの違うアイテムと基準になったリンク図形アイテムを除外
  (if #ss (progn
    (setq #i 0)
    (while (< #i (sslength #ss))
      (setq #eCHK (ssname #ss #i))
      (if (and (not (member #eCHK &eITEM$)) ; 基準の図形名と違う
               (= &iCODE (CFGetSymSKKCode #eCHK 2))) ; 高さが同じ
        (setq #RES$ (cons #eCHK #RES$))
      ); if
      (setq #i (1+ #i))
    ); while
  )); if progn
  #RES$
); PcGetItemInAreaSameLevel

;<HOM>*************************************************************************
; <関数名>    : PcGetLinkMoveItems
; <処理概要>  : 指定図形に隣接する指定高さの移動の可能性のあるアイテムを取得
; <戻り値>    : 図形名リスト
; <作成>      : 00/06/23 MH
; <備考>      : 再帰により 隣接する基準シンボルをCG_LinkSymに格納する
;*************************************************************************>MOH<
(defun PcGetLinkMoveItems (
    &en       ;(ENAME)任意の図形
    &code     ;(INT)ベース、アッパーの性格CODE(CG_SKK_TWO_BAS,CG_SKK_TWO_UPP)
    /
    #enSS$
    #enS1
    #xd$
    #skk$
    #ss #i
    #ename
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PcGetLinkMoveItems ////")
  (CFOutStateLog 1 1 " ")
  (setq CG_LinkSym nil)
  ;基準シンボルを検索する
  (setq #enS1 (CFSearchGroupSym &en))
  ;2000/06/13  HT 基準シンボルを検索失敗はエラーメッセージ
  (if #enS1 (progn
    (if (= &code (CFGetSymSKKCode #enS1 2)) (progn
      (setq #enSS$ (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (setq #ss (ssadd))                 ; 追加 絞り込み 00/03/10 MOD YM
      ; 00/06/23 MH インテリアパネル、ウォールハンガー、アイレベルハンガー以外全対象
      (repeat (sslength #enSS$)
        (setq #skk$ (CFGetSymSKKCode (ssname #enSS$ #i) nil))
        ; 上記のものは、(cadr #skk$) = 0 なので、避けられる。
        ;(if (= (cadr #skk$) &code)  ; &code のみﾋﾟｯｸｱｯﾌﾟ    ;00/07/17 SN MOD
        (setq #ename (CFGetXData (ssname #enSS$ #i) "G_LSYM"))
        (if (or (= (cadr #skk$) &code)
                (and (= CG_SKK_TWO_BAS &code) ))
            (ssadd (ssname #enSS$ #i) #ss)
        );_if
        (setq #i (1+ #i))
      );_(repeat (sslength #ss)                         ; 00/03/10 ADD YM
      ;// 再帰により隣接するベースキャビを検索する ---> CG_LinkSym に入れる
      ;(SKW_SearchLinkBaseSym #ss #enS1)
      (PcSearchLinkItem #ss #enS1)  ; 00/07/06 MOD MH
      ;// 隣接するキャビの基準シンボル図形を返す
      CG_LinkSym
    ); progn
    nil
    ); if
  ) ; progn
  (progn
    ;2000/06/13  HT 基準シンボルを検索失敗はエラーメッセージ
    (princ "\n基準シンボルを検索失敗G_SYM(0)=")
    (princ (nth 0 (CfGetXData &en "G_SYM")))
    nil
  )
  )
)
; PcGetLinkMoveItems

;<HOM>*************************************************************************
; <関数名>    : PcSearchLinkItem
; <処理概要>  : 指定図形に隣接するアイテムを取得する
; <戻り値>    : なし
; <作成>      : 00/07/06
; <備考>      : SKW_SearchLinkBaseSymから作成。隣接の定義 = 同一辺の有無
;*************************************************************************>MOH<
(defun PcSearchLinkItem (
  &enSS$     ;(PICKSET)ベースキャビネットのリスト
  &enS1      ;(ENAME)キャビネット１
  /
  #ANG #D #ENS2 #H #I
  #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #PT$ #PT0$ #UPPER #W #XD$
  #XDL ;00/08/28 SN ADD
  )
  ; アッパーかどうかのフラグ （ハイミドルの処理）
  (if (= CG_SKK_TWO_UPP (CFGetSymSKKCode &enS1 2)) (setq #Upper 'T))

  (setq #xd$ (CFGetXData &enS1 "G_SYM"))
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #h (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &enS1 "G_LSYM")))
  ;// 矩形領域を求める
  (setq #p1 (cdr (assoc 10 (entget &enS1))))
  ; 00/05/08 ADD MH アッパーなら2次元点に変換(高さ違うフード対策)
  (if #Upper (setq #p1 (list (car #p1) (cadr #p1))))
  (setq #p2 (polar #p1 #ang #w))
  (setq #p3 (polar #p2 (- #ang (dtr 90)) #d))
  (setq #p4 (polar #p1 (- #ang (dtr 90)) #d))
  (setq #pt0$ (list #p1 #p2 #p3 #p4))

  (setq #i 0)
  (repeat (sslength &enSS$)
    (setq #enS2 (ssname &enSS$ #i))
    (setq #xd$ (CFGetXData #enS2 "G_SYM"))
    (setq #w (nth 3 #xd$))
    (setq #d (nth 4 #xd$))
    (setq #h (nth 5 #xd$))
    (setq #XDL (CFGetXData #enS2 "G_LSYM"))         ;00/08/28 SN MOD
    (setq #ang (nth 2 #XDL))                        ;
    ;(setq #ang (nth 2 (CFGetXData #enS2 "G_LSYM")));00/08/28 SN MOD

    ;// 矩形領域を求める
    (setq #p5 (cdr (assoc 10 (entget #enS2))))
    ; 00/05/08 ADD MH アッパーなら2次元点に変換(高さ違うフード対策)
    (if #Upper (setq #p5 (list (car #p5) (cadr #p5))))
    (setq #p6 (polar #p5 #ang #w))
    (setq #p7 (polar #p6 (- #ang (dtr 90)) #d))
    (setq #p8 (polar #p5 (- #ang (dtr 90)) #d))
    (setq #pt$ (list #p5 #p6 #p7 #p8))

    (if (PcJudgeCrossing #pt0$ #pt$)
    ;00/09/04 MH MOD 食洗器の移動不可は性格CODEのせい。判定を元にもどした
      (if (= nil (member #enS2 CG_LinkSym))
        (progn
          (setq CG_LinkSym (cons #enS2 CG_LinkSym))
          (PcSearchLinkItem &enSS$ #enS2)
        )
      )
    )
    (setq #i (1+ #i))
  );_repeat
);PcSearchLinkItem

;<HOM>*************************************************************************
; <関数名>    : PcSearchLinkItem2
; <処理概要>  : 指定図形に隣接するアイテムを取得する(高さは見ない)
; <戻り値>    : なし
; <作成>      : 00/07/06 MH
; <備考>      : 隣接の定義 = 同一辺の有無
;*************************************************************************>MOH<
(defun PcSearchLinkItem2  (
  &eSEL$      ; 隣接を探す対象となるリスト
  &eONE       ; 基準のアイテム
  /
  #dCHK$ #i #eTWO
  )
  (setq #dCHK$ (PcGetItem4P$ &eONE 0 0 0 0))
  (setq #i 0)
  (repeat (sslength &eSEL$)
    (setq #eTWO (ssname &eSEL$ #i))
    (if (PcJudgeCrossing #dCHK$ (PcGetItem4P$ #eTWO 0 0 0 0))
      (if (= nil (member #eTWO CG_LinkSym))
        (progn
          (setq CG_LinkSym (cons #eTWO CG_LinkSym))
          (PcSearchLinkItem #eTWO &eSEL$)
        )
      )
    )
    (setq #i (1+ #i))
  );_repeat
);PcSearchLinkItem

;******************************************************************************
(defun C:InsParts ()
  (StartUndoErr)
  (SKY_InsertPartsSel nil)
) ; 01/01/29 YM "L"==>nil==>ﾕｰｻﾞｰがL/R選択
;******************************************************************************
(defun C:InsPartsR () (KcInsParts "R"))
(defun C:InsPartsL () (KcInsParts "L"))

;<HOM>*************************************************************************
; <関数名>    : KcInsParts
; <処理概要>  : アイテムを基準アイテムの指示方向に挿入、周辺図形移動
; <戻り値>    : なし
; <作成>      : 01/02/21 MH
; <備考>      :
;*************************************************************************>MOH<
(defun KcInsParts (
  &sDIR       ; 挿入方向  "L" "R"
  /
  #eBASE #sDIR
  )
  (StartUndoErr)
  (CFCmdDefBegin 6)

  (setq #sDIR &sDIR)
  ; 基準アイテムが指示されてなければダイアログ
  (setq CG_BASESYM (CFGetBaseSymXRec))
  (if (not CG_BASESYM)
    (CFAlertMsg "基準アイテムがありません.基準アイテムを選択して下さい"))
  ; 挿入実行
  (SKY_InsPartsIN #sDIR CG_BASESYM)

  (CFCmdDefFinish)
  (princ)
); KcInsParts

;<HOM>*************************************************************************
; <関数名>    : SKY_InsertPartsSel
; <処理概要>  : 設備挿入 アイテムを選択して挿入
; <戻り値>    :
; <作成>      : 2000-06-23 西畑
; <備考>      :
;*************************************************************************>MOH<
(defun SKY_InsertPartsSel(
  &type ;向き  "L" "R" ;//"T" "D"     ;現在は"L"のみ対応==>nil(01/01/29 YM MOD)
  /
  #en
  #Gen
  #ret #type
  )
  (setq #type &type)
  (StartUndoErr);00/09/07 SN ADD
  (CFCmdDefBegin 6);00/09/07 SN ADD
  ;(command "_undo" "m");00/09/07 SN MOD

  (setq #en nil)
  (while (not #en)
    (setq #en (car (entsel "\n挿入基準アイテムを指示:")))
    (cond
      (#en
        (setq #Gen (CFSearchGroupSym #en))
        (GroupInSolidChgCol2 #Gen CG_InfoSymCol)
        (setq #ret (CFYesNoCancelDialog "これでよろしいですか？ "))
          (cond
            ((= #ret IDYES)
;;;              (command "_undo" "b")
              ;(SKY_InsPartsIN "R" #Gen) 00/07/17 MH MOD

              ; 01/01/29 YM ADD START
              (if (= #type nil)
                (progn
                  (initget 1 "L R")
                  (setq #type (getkword "\n挿入側を入力 /L=左/R=右/:  "))
                )
              );_if
              ; 01/01/29 YM ADD END

              (command "_undo" "b") ; 01/02/05 ここへ移動
              (SKY_InsPartsIN #type #Gen)
              (setq #en T)
            )
            ((= #ret IDNO)
              (command "_undo" "b")
              (setq #en nil)
            )
            (T
              (*error*)
            )
          )
      )
    )
  )
  (CFCmdDefFinish);00/09/07 SN ADD
  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : SKY_InsPartsIN
; <処理概要>  : 設備挿入
; <戻り値>    :
; <作成>      : 00/06/23 SN
; <備考>      : KSY_InsPartsを汎用関数に改造
;*************************************************************************>MOH<
(defun SKY_InsPartsIN (
  &type     ;向き  "L" "R" ;//"T" "D"     ;現在は"L"のみ対応
  &basesym  ;00/06/23 ADD SN
  /
  #xd$ #fig$ #w #d #h #w2 #d2 #h2 #P&A$ #pt #ang
  #sCd        ; 性格CODE
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKY_InsParts ////")
  (CFOutStateLog 1 1 " ")

  ;00/06/23 SN S-MOD
  ;(setq CG_BASESYM (CFGetBaseSymXRec))
  ;(if (= CG_BASESYM nil)
  ;  (progn
  ;    (CFAlertErr "基準アイテムがありません.基準アイテムを選択して下さい")
  ;  )
  ;)
  ;(setq #xd$ (CFGetXData CG_BASESYM "G_SYM"))
  ;(setq #pt (cdr (assoc 10 (entget CG_BASESYM))))
  (setq #xd$ (CFGetXData &basesym "G_SYM"))
  (setq #pt (cdr (assoc 10 (entget &basesym))))
  ;00/06/23 SN S-MOD

;  (setq #w (if (= (nth 11 #xd$) 0) (nth 3 #xd$) (nth 11 #xd$)))
;  (setq #d (if (= (nth 12 #xd$) 0) (nth 4 #xd$) (nth 12 #xd$)))
;  (setq #h (if (= (nth 13 #xd$) 0) (nth 5 #xd$) (nth 13 #xd$)))
  ;;; 変更 00/05/23 MH MOD 伸縮フラグの定義が変わっているため
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #h (nth 5 #xd$))

  ;(setq #xd$ (CFGetXData CG_BASESYM "G_LSYM"))  00/06/23 SN MOD
  (setq #xd$ (CFGetXData &basesym "G_LSYM"))    ;00/06/23 SN MOD

  (if (setq #fig$ (SKY_GetItemInfo))
    (progn
      (setq #w2  (fix (nth 5 #fig$)))
      (setq #d2  (fix (nth 6 #fig$)))
      (setq #h2  (fix (nth 7 #fig$)))
      (setq #sCd (fix (nth 8 #fig$))) ; 01/06/17 HN ADD
    )
    (CFAlertErr "品番情報を取得できませんでした")
  )


;-- 2011/08/03 A.Satoh Add - S
  ; 扉グレード別配置不可部材チェック
  (if (= (CheckDoorGradeFree (nth 0 #fig$) CG_DRSeriCode CG_DRColCode) nil)
    (progn
      (CfAlertMsg "選択した品番は、現在の扉グレード、扉色のとき配置できません。")
      (exit)
    )
  )
;-- 2011/08/03 A.Satoh Add - E

  ;// 挿入基点と挿入角度を求める  00/07/17 MH 関数化
  ; 01/06/17 HN MOD 配置アイテムの性格CODEを追加
  ;@MOD@(setq #P&A$
  ;@MOD@  (PcArrangeInsPnt #pt &type #fig$ &basesym #xd$ (list #w #d #h) (list #w2 #d2 #h2)))
  (setq #P&A$
    (PcArrangeInsPnt #pt &type #fig$ &basesym #xd$ (list #w #d #h) (list #w2 #d2 #h2) #sCd))
  (setq #pt  (car  #P&A$))
  (setq #ang (cadr #P&A$))

  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart); 00/02/07 @YM@ 追加

  ;2018/07/12 木製ｶｳﾝﾀｰ対応
  (setq #fig$ (KcChkWCounterItem$ #fig$))

  (if (not (KcSetUniqueItem "INS" #fig$ &basesym &type nil))
    ;;;特殊部材以外の部材の処理
    (PcSetItem "INS" &type #FIG$ #pt #ang &basesym nil)
  ); end of if

  ;// Ｏスナップ関連システム変数を元に戻す
  (CFNoSnapEnd); 00/02/07 @YM@ 追加

  (setq *error* nil)
  (princ)
  ; #en;00/06/23 SN ADD 基準ｱｲﾃﾑならアイテム名を返す。00/07/13 MH DEL 基準移行は別関数内
);SKY_InsPartsIN

;<HOM>*************************************************************************
; <関数名>    : BaseCheck
; <処理概要>  : 基準アイテム設定チェック
; <戻り値>    :
; <作成>      : 1999-11-29 山田
; <備考>      :
;*************************************************************************>MOH<
(defun C:BaseCheck ( / #f )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:BaseCheck ////")
  (CFOutStateLog 1 1 " ")

  ;// コマンドの初期化
  (StartCmnErr)

  (setq CG_BASESYM (CFGetBaseSymXRec))

  (if (= CG_BASESYM nil)
    (progn
      (setq #f (open (strcat CG_SYSPATH "Config.cfg") "w"))
      (write-line "BaseParts NG" #f)
      (close #f)
      (CFAlertErr "基準アイテムが設定されていません")
    )
    (progn
      (setq #f (open (strcat CG_SYSPATH "Config.cfg") "w"))
      (write-line "BaseParts OK" #f)
      (close #f)
    )
  )
  (setq *error* nil)
  (princ)
)
;C:BaseCheck

;<HOM>*************************************************************************
; <関数名>    : C:PtenDisp
; <処理概要>  : 作画点表示
; <戻り値>    :
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun C:PtenDisp (
  /
  #ss
  #i
  #pt
  #p1 #p2
  #CCOL #P #OFF
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PC_SearchPlanNewDWG ////")
  (CFOutStateLog 1 1 " ")

  ;// コマンドの初期化
  (StartUndoErr)
  (if (= nil (tblsearch "APPID" "G_PDSP"))
    (regapp "G_PDSP")
  )
  (setq #ss (ssget "X" '((-3 ("G_PDSP")))))
  (if (/= #ss nil)
    (command "_erase" #ss "")
  )
  (setq #ccol (getvar "CECOLOR"))
  (setvar "CECOLOR" "2")
  (setq #off 30)
  (setq #ss (ssget "X" '((-3 ("G_PTEN")))))
  (setq #i 0)

  (repeat (sslength #ss)
    (setq #pt (cdr (assoc 10 (entget (ssname #ss #i)))))
    (setq #p1 (mapcar '(lambda (#p) (- #p #off)) #pt))
    (setq #p2 (mapcar '(lambda (#p) (+ #p #off)) #pt))
    (MakeLwPolyLine (list #p1 #p2) 0 0)
    (CFSetXData (entlast) "G_PDSP" (list 1))
    (setq #pt #p1)
    (setq #p1 (list (car #p1) (cadr #p2)))
    (setq #p2 (list (car #p2) (cadr #pt)))
    (MakeLwPolyLine (list #p1 #p2) 0 0)
    (CFSetXData (entlast) "G_PDSP" (list 1))
    (setq #i (1+ #i))
  )
  (setvar "CECOLOR" #ccol)
  (setq *error* nil)
  (princ)
)
;C:PtenDisp

;<HOM>*************************************************************************
; <関数名>    : C:PtenDel
; <処理概要>  : 作画点表示
; <戻り値>    :
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun C:PtenDel (
    /
    #ss
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:PtenDel ////")
  (CFOutStateLog 1 1 " ")

  ;// コマンドの初期化
  (StartUndoErr)
  (setq #ss (ssget "X" '((-3 ("G_PDSP")))))
  (if (/= #ss nil)
    (command "_erase" #ss "")
  )
  (setq *error* nil)
  (princ)
)
;C:PtenDel

;<HOM>*************************************************************************
; <関数名>    : C:HideSS
; <処理概要>  : 選択セット非表示
; <戻り値>    :
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun C:HideSS (
    /
    #ss
    #i
    #pt
    #EG
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:HideSS ////")
  (CFOutStateLog 1 1 " ")

  ;// コマンドの初期化
  (StartCmnErr)
  (if (= nil (tblsearch "LAYER" "HIDE"))
    (command
      "_layer"
      "N" "HIDE" "F" "HIDE" ""
    )
  )
  (setq #ss (ssget))
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #eg (entget (ssname #ss #i)))
    (entmod (subst (cons 8 "HIDE") (assoc 8 #eg) #eg))
    (setq #i (1+ #i))
  )
  (setq *error* nil)
  (princ)
)
;C:HideSS

;<HOM>*************************************************************************
; <関数名>    : C:dispHideSS
; <処理概要>  : 非表示選択セット表示
; <戻り値>    :
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun C:dispHideSS (
    /
    #ss
    #i
    #pt
    #EG
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:dispHideSS ////")
  (CFOutStateLog 1 1 " ")

  ;// コマンドの初期化
  (StartCmnErr)

  (setq #ss (ssget "X" '((8 . "HIDE"))))
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #eg (entget (ssname #ss #i)))
    (entmod (subst (cons 8 "BYLAYER") (assoc 8 #eg) #eg))
    (setq #i (1+ #i))
  )
  (setq *error* nil)
  (princ)
)
;C:dispHideSS

;<HOM>*************************************************************************
; <関数名>    : Pc_CheckInsertDwg
; <処理概要>  : 挿入する図形ﾌｧｲﾙが存在するかどうかのチェック
; <戻り値>    : なし
; <作成>      : 00/03/15 MH
; <備考>      : もし存在しないなら、メッセージ提出
;*************************************************************************>MOH<
(defun Pc_CheckInsertDwg (
  &sFILE      ; ファイル名
  &sDIR       ; ディレクトリー名
  /
  )
  (if (not (findfile (strcat CG_MSTDWGPATH &sFILE)))
    (progn
      (CFAlertMsg (strcat "挿入する図形ﾌｧｲﾙ " &sFILE " が指定ﾃﾞｨﾚｸﾄﾘｰ \n"
       CG_MSTDWGPATH " 中に発見できません。"))(exit)
    ); progn
  ); end of if
);Pc_CheckInsertDwg

;;;<HOM>***********************************************************************
;;; <関数名>    : SCEExpansion
;;; <処理概要>  : シンボルに属する 2D 図形を全て伸縮する
;;; <戻り値>    : 成功： T　　　失敗：nil
;;; <作成>      : 1998/08/05, 1998/08/17 -> 1998/08/17   松木 健太郎
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun SCEExpansion
  (
    &enSym      ; 伸縮を行うシンボル図形名
  /
    #SymData$   ; シンボルデータ格納用
    #enGroup    ; シンボルの所属するグループ名格納用
    #GrpData$   ; グループ構成図形名(グループのデータ)格納用
    #expData$   ; 伸縮処理を行う図形データ名格納用

    #iRad       ; シンボルの回転角度格納用
    #SymPos$    ; シンボルの挿入点格納用

    #ViewZ$     ; 押し出し方向格納用

    #iHSize     ; 現在の H 方向のサイズ格納用
    #iWSize     ; 現在の W 方向のサイズ格納用
    #iDSize     ; 現在の D 方向のサイズ格納用

    #iHExp      ; H 方向の伸縮幅格納用
    #iWExp      ; W 方向の伸縮幅格納用
    #iDExp      ; D 方向の伸縮幅格納用

    #BrkH$      ; H 方向のブレークライン名格納用
    #BrkW$      ; W 方向のブレークライン名格納用
    #BrkD$      ; D 方向のブレークライン名格納用

    #bCabFlag   ; キャビネットフラグ(アッパーキャビネット:1 それ以外:0)

    #Pos$       ; 伸縮対称図形の矩形領域座標格納用

    #iExpSize   ; 伸縮を行うサイズ格納用

    #iLoop      ; ループ用
    #nn         ; foreach 用

    #strLayer   ; 画層名格納用
    #Temp$      ; テンポラリリスト

    ;; ローカル定数格納用
    Exp_F_View  ; 回転角0正面視点位置定数格納用
    Exp_FM_View ; 回転角マイナス正面視点位置定数格納用
    Exp_FP_View ; 回転角プラス正面視点位置定数格納用
    Exp_S_View  ; 回転角0側面視点位置定数格納用
    Exp_SM_View ; 回転角マイナス側面視点位置定数格納用
    Exp_SP_View ; 回転角プラス側面視点位置定数格納用

    Exp_Temp_Layer; 伸縮作業用画層名格納用
    Upper_Cab_Code ; グローバル定数用
    #LSYMDATA$
  )
	(setq CG_ORG_Layer$ nil);2017/04/17 YM ADD

  ;; 伸縮処理開始
  (CFOutStateLog 1 7 "      SKEExpansion=Start")
  ;T    ; return;
  ;;======================================================================
  ;; ローカル定数の初期化(初期値代入)
  ;;======================================================================
  (setq Upper_Cab_Code CG_SEIKAKU_UPPER)    ; アッパーキャビネット判断用性格CODE一覧
  ;(setq Upper_Cab_Code '(4 12 13 51 57))   ; アッパーキャビネット判断用性格CODE一覧

  (setq Exp_F_View '(0 -1 0))   ; 回転角0正面視点位置定数格納用
  (setq Exp_FM_View '(-1 0 0))  ; 回転角マイナス正面視点位置定数格納用
  (setq Exp_FP_View '(1 0 0))   ; 回転角プラス正面視点位置定数格納用
  (setq Exp_S_View '(-1 0 0))   ; 回転角0側面視点位置定数格納用
  (setq Exp_SM_View '(0 1 0))   ; 回転角マイナス側面視点位置定数格納用
  (setq Exp_SP_View '(0 -1 0))  ; 回転角プラス側面視点位置定数格納用

  (setq Exp_Temp_Layer  "EXP_TEMP_LAYER") ; 伸縮作業用画層名

  ;; 伸縮作業用テンポラリ画層の作成
  ; 00/12/22 SN MOD テンポラリ画層既存チェック
  (if (tblsearch "layer" Exp_Temp_Layer)
    (command "_layer"                    "C" 1 Exp_Temp_Layer "L" SKW_AUTO_LAY_LINE Exp_Temp_Layer "")
    (command "_layer" "N" Exp_Temp_Layer "C" 1 Exp_Temp_Layer "L" SKW_AUTO_LAY_LINE Exp_Temp_Layer "")
  )

  (setq #bCabFlag 0)

  ;;======================================================================
  ;; シンボルの "G_LSYM" 拡張データを取得する
  ;;======================================================================
  (setq #LSymData$ (CFGetXData &enSym "G_LSYM"))
  ;; "G_LSYM" データを取得できたかどうかのチェック
  (if (/= #LSymData$ nil)
    (progn    ; 取得できた
      ;; 取得した拡張データから回転角度(nth 2)を取得する
      (setq #iRad (nth 2 #LSymData$))
      ;; 取得した拡張データから挿入点(nth 1)を取得する
      ;; (setq #SymPos$ (nth 1 #LSymData$))
      (setq #SymPos$ (cdr (assoc 10 (entget &enSym)))) ;00/04/12 MOD MH

      ;;======================================================================
      ;; シンボルの "G_SYM" 拡張データを取得する
      ;;======================================================================
      (setq #SymData$ (CFGetXData &enSym "G_SYM"))

; 01/02/27 YM 昔からあったﾌﾗｸﾞ #bCabFlag を正しくｾｯﾄすると伸縮後にH方向に移動しなくてもいいようである
  (if (and (/= (nth 9 #LSymData$) CG_SKK_INT_SNK)(= -1 (nth 10 #SymData$))) ; 01/03/01 YM DEL ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
    (setq #bCabFlag 1) ; 上基点
  );_if

      ;; "G_SYM" データを取得できたかどうかのチェック
      (if (/= #SymData$ nil)
        (progn    ; 取得できた
          ;; 取得した拡張データから現在の H サイズ(nth 5)を取得する
          (setq #iHSize (nth 5 #SymData$))
          ;; 取得した拡張データから現在の W サイズ(nth 3)を取得する
          (setq #iWSize (nth 3 #SymData$))
          ;; 取得した拡張データから現在の D サイズ(nth 4)を取得する
          (setq #iDSize (nth 4 #SymData$))
          ;; 取得した拡張データから H 方向(nth 13)の伸縮幅を取得する
          (setq #iHExp (nth 13 #SymData$))
          ;; 取得した拡張データから W 方向(nth 11)の伸縮幅を取得する
          (setq #iWExp (nth 11 #SymData$))
          ;; 取得した拡張データから D 方向(nth 12)の伸縮幅を取得する
          (setq #iDExp (nth 12 #SymData$))
          ;;======================================================================
          ;; シンボルのデータを取得する
          ;;======================================================================
          (setq #SymData$ (entget &enSym))
          ;; シンボルのグループ名を取得する
          (setq #enGroup (cdr (assoc 330 #SymData$)))

          ;;======================================================================
          ;; グループ内データ(グループ名リスト)を取得する
          ;;======================================================================
          (setq #GrpData$ (entget #enGroup))

          ;;======================================================================
          ;; 2D 図形で伸縮処理を行うデータを絞り込む。ブレークラインを抽出する
          ;;======================================================================
          (foreach #nn #GrpData$
            ;; グループ構成図形名かどうかのチェック
            (if (= (car #nn) 340)
              (progn    ; グループ構成図形名だった
                ;; グループ構成図形名のデータを取得する
                (setq #Temp$ (entget (cdr #nn)))
                ;; グループ構成図形がソリッドデータ(0 . "3DSOLID")以外かどうかのチェック
;;                (if (and (/= (cdr (assoc 0 #Temp$)) "3DSOLID") (/= (cdr (assoc 0 #Temp$)) "XLINE"))
                (if (/= (cdr (assoc 0 #Temp$)) "XLINE")
                  (progn    ; ソリッドデータではなかった
                    ;; 画層名の取得
                    (setq #strLayer (cdr (assoc 8 #Temp$)))
                    ;; 図形名と画層名を1リストにして格納する(図形名 画層名)
                    (setq #expData$ (cons (list (cdr #nn) #strLayer) #expData$))


                    ;;======================================================================
                    ;; 伸縮対称図形を伸縮処理画層に移動する
                    ;;======================================================================
                    (entmod
                      (subst (cons 8 Exp_Temp_Layer) (assoc 8 #Temp$) #Temp$)
                    )
                  )
                )
                ;; グループ構成図形がブレークラインかどうかのチェック
                (if (= (cdr (assoc 0 #Temp$)) "XLINE")
                  (progn    ; ブレークラインだった
                    ;; ブレークラインの拡張データを取得
                    (setq #Temp$ (CFGetXData (cdr #nn) "G_BRK"))
                    ;; 拡張データが存在するかどうかのチェック
                    (if (/= #Temp$ nil)
                      (progn    ; 拡張データが存在した
                        ;; H,W,D 各ブレークラインの種類毎に図形名を格納する
                        (cond
                          ;; H 方向ブレークラインだった
                          ((= (nth 0 #Temp$) 3) (setq #BrkH$ (cons (cdr #nn ) #BrkH$)))
                          ;; W 方向ブレークラインだった
                          ((= (nth 0 #Temp$) 1) (setq #BrkW$ (cons (cdr #nn ) #BrkW$)))
                          ;; D 方向ブレークラインだった
                          ((= (nth 0 #Temp$) 2) (setq #BrkD$ (cons (cdr #nn ) #BrkD$)))
                        )
                      )
                    )
                  )
                )
              )
            )
          );foreach

					;ｸﾞﾛｰﾊﾞﾙ変数に格納
					(setq CG_ORG_Layer$ #expData$);元の画層格納 2017/04/17 YM ADD

          (if (and (= #BrkH$ nil) (= #BrkW$ nil) (= #BrkD$ nil))
            (progn
;;;             (CFAlertErr "このアイテムには伸縮ラインがありませんでした") ; →伸縮しない
              (princ "\nこのアイテムには伸縮ラインがありませんでした") ; →伸縮しない
              (setq CG_NO_STRETCH T)
            )
          );_if

          ;;======================================================================
          ;; 伸縮処理
          ;;======================================================================
          ;; 押し出し方向の判断
;04/12/01 YM ADD-S 10のﾏｲﾅｽ16乗の誤差あり
          (cond
            ((equal #iRad 0 0.001) (setq #ViewZ$ Exp_F_View))
            ((< #iRad 0) (setq #ViewZ$ Exp_FM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_FP_View))
          )
;;;          (cond
;;;            ((= #iRad 0) (setq #ViewZ$ Exp_F_View))
;;;            ((< #iRad 0) (setq #ViewZ$ Exp_FM_View))
;;;            ((> #iRad 0) (setq #ViewZ$ Exp_FP_View))
;;;          )
;04/12/01 YM ADD-E

          ;; 伸縮を行うサイズのチェック(アッパーキャビネットの場合は +- が逆転)
          (if (and (= #bCabFlag 1) (/= #iHExp 0))
            (progn
              ;// Modify S.Kawamoto
              ;(setq #iExpSize (list 1 (* (- #iHExp #iHSize) -1) 2))
              (setq #iExpSize (list 1 (- #iHExp #iHSize) 2))
            )
            ;; else
            (progn
              (setq #iExpSize (list 0 (- #iHExp #iHSize) 1))
            )
          )
          (if (and (/= #BrkH$ nil) (/= #iHExp 0))
            (progn
              ;; ブレークラインを基点から遠い順にソートする
              (setq #BrkH$ (SKESortBreakLine (list 2 #BrkH$) #SymPos$))
              ;; H 方向の伸縮処理
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkH$ #iExpSize)
              ;; 正常終了
              (CFOutStateLog 1 7 "        SKEExpansion=Hブレーク OK")
            )
            ;; else
            (progn
              ;; 正常終了
              (CFOutStateLog 1 7 "        SKEExpansion=Hブレークなし")
            )
          )

          (if (and (/= #BrkW$ nil) (/= #iWExp 0))
            (progn
              ;; ブレークラインを基点から遠い順にソートする
              (setq #BrkW$ (SKESortBreakLine (list 0 #BrkW$) #SymPos$))
              ;; W 方向の伸縮処理
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkW$ (list 2 (- #iWExp #iWSize)))
              ;; 正常終了
              (CFOutStateLog 1 7 "        SKEExpansion=Wブレーク OK")
            )
            ;; else
            (progn
              ;; 正常終了
              (CFOutStateLog 1 7 "        SKEExpansion=Wブレークなし")
            )
          )

          ;; 押し出し方向の判断
          (cond
            ((= #iRad 0) (setq #ViewZ$ Exp_S_View))
            ((< #iRad 0) (setq #ViewZ$ Exp_SM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_SP_View))
          )
          (if (and (/= #BrkD$ nil) (/= #iDExp 0))
            (progn
              ;; ブレークラインを基点から遠い順にソートする
              (setq #BrkD$ (SKESortBreakLine (list 1 #BrkD$) #SymPos$))
              ;; D 方向の伸縮処理

              ; 左側面から見て右方向に伸縮するのでｼﾝﾎﾞﾙ位置はずれる
;;;              (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 3 (- #iDExp #iDSize))) ; 通ることはない
              ; 左側面から見て左方向に伸縮するのでｼﾝﾎﾞﾙ位置はずれる
;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU T)
;--2011/07/21 A.Satoh Add - E
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 2 (- #iDExp #iDSize)))
;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU nil)
;--2011/07/21 A.Satoh Add - E
              ;; 正常終了
              (CFOutStateLog 1 7 "        SKEExpansion=Dブレーク OK")
            )
            ;; else
            (progn
              ;; 正常終了
              (CFOutStateLog 1 7 "        SKEExpansion=Dブレークなし")
            )
          )

          ;;======================================================================
          ;; 伸縮作業画層から元の画層に図形データを移動する
          ;;======================================================================
;-- 2011/07/21 A.Satoh Add - S
          ; 伸縮を行う図形リストを更新する
          (if (/= nil CG_EXPDATA$)
            (foreach #nn #expData$
              (if (equal (nth 0 #nn) (nth 0 CG_EXPDATA$))
                (setq #expData$ (subst (list (nth 1 CG_EXPDATA$) (nth 1 #nn)) (list (nth 0 CG_EXPDATA$) (nth 1 #nn)) #expData$))
              )
            )
            (setq CG_EXPDATA$ nil)
          )
;-- 2011/07/21 A.Satoh Add - E

          (foreach #nn #expData$
            (setq #Temp$ (entget (nth 0 #nn) '("*")))
            (entmod
              (subst (cons 8 (nth 1 #nn)) (cons 8 Exp_Temp_Layer) #Temp$)
            )
          )
          ;; 正常終了
          (CFOutStateLog 1 7 "      SKEExpansion=OK End")
          T   ; return;
        )
        ;; else
        (progn    ; シンボルの拡張データを取得できなかった
          ;; 異常終了
          (CFOutStateLog 0 7 "      SKEExpansion=\"G_SYM\"拡張データを取得できませんでした error End")
          nil   ; return;
        )
      )
    )
    ;; else
    (progn    ; 拡張データを取得できなかった
      ;; 異常終了
      (CFOutStateLog 0 7 "      SKEExpansion=\"G_LSYM\"拡張データを取得できませんでした error End")
      nil   ; return;
    )
  )
); SCEExpansion

;<HOM>*************************************************************************
; <関数名>    : KP_TOKU_GROBAL_RESET
; <処理概要>  : 特注ｷｬﾋﾞｺﾏﾝﾄﾞの一部ｸﾞﾛｰﾊﾞﾙをｸﾘｱｰ
; <戻り値>    : なし
; <作成>      : 01/09/25 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KP_TOKU_GROBAL_RESET ( / )
  (setq CG_DOOR_MOVE03 nil) ; 01/09/25 YM ADD
  (setq CG_DOOR_MOVE06 nil) ; 01/09/25 YM ADD
;;; (setq CG_DOOR_MOVE_RIGHT nil) ; 01/09/25 扉移動方向が正面ではなく、向かって右方向
  (princ)
);KP_TOKU_GROBAL_RESET

;<HOM>*************************************************************************
; <関数名>    : KPGetPrice
; <処理概要>  : 品番,LRを渡して元の価格を引き当てる
; <戻り値>    : 価格(文字列)
; <作成>      : 01/04/03 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KPGetPrice (
  &HINBAN ; 品番
  &LR     ; LR区分
  /
  #HINBAN #LR #NAME1 #NAME2 #ORG_PRICE #QRY$ #SQL
  )
  (setq #HINBAN &HINBAN #LR &LR)
  (setq #sql (strcat "select * from 階層 where 階層名称='" #HINBAN "'"))
  (setq #qry$ (car (DBSqlAutoQuery CG_DBSESSION #sql)))
  (if (/= nil #qry$)
    (progn
      (setq #name1 (nth 5 #qry$)) ; 商品名
;-- 2011/08/18 A.Satoh Add - S
      (if (= #name1 nil)
        (setq #name1 "")
      )
;-- 2011/08/18 A.Satoh Add - E
      (setq #name2 (nth 6 #qry$)) ; 備考
;-- 2011/08/18 A.Satoh Add - S
      (if (= #name2 nil)
        (setq #name2 "")
      )
;-- 2011/08/18 A.Satoh Add - E
    )
    (progn
      (setq #name1 "")
      (setq #name2 "")
    )
  );_if

  (setq #ORG_price "0");金額取得はまだ実装していない

  (list #ORG_price #name1 #name2) ; 価格,品名,備考
);KPGetPrice

;<HOM>*************************************************************************
; <関数名>    : KPGetLastHinban
; <処理概要>  : 品番,LRを渡して最終品番を引き当てる
; <戻り値>    : 最終品番(文字列) or nil
; <作成>      : 02/03/21 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KPGetLastHinban (
  &HINBAN ; 品番
  &LR     ; LR区分
  /
  #QRY$ #RET #HINBAN
  )
  ; 03/01/25 YM ADD-S
  ; &HINBAN から[]を外さないとﾌﾛｱﾌｨﾗｰのときMX色が引き当たらない
  (setq #HINBAN (KP_DelDrSeriStr &HINBAN))
  ; 03/01/25 YM ADD-E

  (setq #Qry$
    (CFGetDBSQLRec CG_DBSESSION "品番最終"
      (list
        (list "品番名称"   #HINBAN       'STR)
        (list "LR区分"     &LR           'STR)
        (list "扉シリ記号" CG_DRSeriCode 'STR)
        (list "扉カラ記号" CG_DRColCode  'STR)
      )
    )
  )
  (if (and #Qry$ (= 1 (length #Qry$)))
    (setq #ret (nth 18 (car #Qry$)))
  );_if

  #ret
);KPGetLastHinban

;<HOM>*************************************************************************
; <関数名>    : PcChkIntersect
; <処理概要>  : 二つのソリッド図形に重複する部分があるかどうか判断
; <戻り値>    : T (重複有り) or nil
; <作成>      : 00/04/20 MH
; <備考>      : コピー図形を作成し、Intersect実行&判定
;*************************************************************************>MOH<
(defun PcChkIntersect (
  &e1 &e2     ; 図形1 図形2
  /
  #eCPY1 #eCPY2 #en_kosu1 #en_kosu2 #RES
  )
  (setq #eCPY1 (entmakex (entget &e1)))
  (setq #eCPY2 (entmakex (entget &e2)))

  (setq #en_kosu1 (CMN_all_en_kosu)) ; 図面上にある図形の総数
  ;;; コピーされた図形どうしでintersect実行
  (command "._intersect" #eCPY1 #eCPY2 "")
  (setq #en_kosu2 (CMN_all_en_kosu)) ; 図面上にある図形の総数

  ;;; 総数が-1==>共通部分あり   総数が-2==>共通部分なし
  (if (= (- #en_kosu1 #en_kosu2) 2)
    (setq #RES nil)
    (progn
      (setq #RES 'T)
      (entdel (entlast))
    )
  );_if
  (setq #RES #RES)
); PcChkIntersect

;<HOM>*************************************************************************
; <関数名>    : PcMakeFig$ByQLY
; <処理概要>  : "品番図形"と"品番基本"から選択図形データの形式のリストを作成する
; <戻り値>    : リスト
; <作成>      : 00/05/30 MH
;*************************************************************************>MOH<
(defun PcMakeFig$ByQLY (
  &Z_QLY$ &K_QLY$ &iKAISO &stretch
  /
  #sID #RES$
  )
  ; 渡されたデータより情報リストを作成する
  (setq #sID (nth 7 &Z_QLY$))
  (if (not #sID) (setq #sID ""))
  (setq #RES$
    (list
      (nth 0 &Z_QLY$) ; 01.品番名称
      #sID            ; 02.図形ID
      &iKAISO         ; 03.階層タイプ
      (nth 3 &Z_QLY$) ; 04.用途番号
      (nth 1 &Z_QLY$) ; 05.L/R区分
      (nth 4 &Z_QLY$) ; 06.寸法W
      (nth 5 &Z_QLY$) ; 07.寸法D
      (nth 6 &Z_QLY$) ; 08.寸法H
      (fix (nth 3 &K_QLY$)) ; 09.性格CODE
      &stretch        ; 10.伸縮フラグ
      (nth 8 &Z_QLY$) ; 11.展開ID
    )
  )
  #RES$
); PcMakeFig$ByQLY

;<HOM>*************************************************************************
; <関数名>    : PcFig$Stretch
; <処理概要>  : 選択図形データの形式のリストを伸縮可に変更
; <戻り値>    : リスト
; <作成>      : 00/07/24 MH
;*************************************************************************>MOH<
(defun PcFig$Stretch (&FIG$ &W &D &H / #RES$)
  ; 値がnilの部分は変化しない
  (setq #RES$
    (list
      (nth 0 &FIG$)   ; 01.品番名称
      (nth 1 &FIG$)   ; 02.図形ID
      (nth 2 &FIG$)   ; 03.階層タイプ
      (nth 3 &FIG$)   ; 04.用途番号
      (nth 4 &FIG$)   ; 05.L/R区分
      (if &W &W (nth 5 &FIG$))  ; 06.寸法W
      (if &D &D (nth 6 &FIG$))  ; 07.寸法D
      (if &H &H (nth 7 &FIG$))  ; 08.寸法H
      (nth 8 &FIG$)   ; 09.性格CODE
      "Yes"           ; 10.伸縮フラグ
      (nth 10 &FIG$)  ; 11.展開ID
    )
  )
  #RES$
); PcFig$Stretch

;<HOM>*************************************************************************
; <関数名>    : PcJudgeItemSide
; <処理概要>  : 与えられたアイテムから "L" "R" 判定&補正
; <戻り値>    : "L" "R" nil
; <作成>      : 00/07/25 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcJudgeItemSide (
  &eBASE      ; 基準アイテム図形名 "CNT" "INS" 以外ではnilが入る
  &basePT$    ; 基準アイテムの情報 (G_LSYM)
  &sMODE      ; "POS" "CNT" "INS" "CHG"  使用元の関数フラグ
  &sLR        ; "L" "R" "T" "D"   "CNT"以外ではnilが入る
  /
  #Lflg #Rflg #LRflg
  )
  ;;; "CNT" "INS" の場合、"L" "R"の指示が適切かどうか判定させる
  ;;; LR判別、設置位置は空いているかどうかチェック
  (setq #Lflg (PcChkItemNext &eBASE 1 0 0 0))
  (setq #Rflg (PcChkItemNext &eBASE 0 1 0 0))
  (cond
    ;;; 両側面に図形が存在するなら強制終了
    ((and #Lflg #Rflg)
      (CFAlertMsg "設置基準のアイテムは左右両側面に他のアイテムが隣接しています")
      (exit)
    )
    ;;; 左か右の片側のみ空いている場合、それが設定される。
    ((and #Lflg (not #Rflg)) (setq #LRflg "R"))
    ((and #Rflg (not #Lflg)) (setq #LRflg "L"))
    ;;; 左右が開いている"CNT"で"L" "R"なら #sLRの変更なし
    ((and (not #Lflg) (not #Rflg) (= "CNT" &sMODE) (or (= "L" &sLR) (= "R" &sLR)))
      (setq #LRflg &sLR)
    )
    (t (setq #LRflg "D"))
  ); cond
  #LRflg
); PcJudgeItemSide

;<HOM>*************************************************************************
; <関数名>    : KcSetUniqueItem
; <処理概要>  : 設置特殊処理アイテム設置
; <戻り値>    : 設置した図形名。特殊処理に当てはまる項目がなければnilを返す
; <作成>      : 01-03-13 MH
; <備考>      : 引数が多いのは PcChk&SetUniqueItem の写しで使用する可能性有るから
;*************************************************************************>MOH<
(defun KcSetUniqueItem (
  &sMODE      ; "POS" "CNT" "INS" "CHG" 使用元の関数フラグ
  &FIG$       ; SELPARTS.CFG の内容リスト
  &eBASE      ; 基準図形 ("CNT" "INS" 以外は nil)
  &sDIR       ; "L" "R" "D" "T"  ("CNT" "INS" 以外では nil)
  &eCHG       ; "CHG"モード専用 変更元図形
  /
  #en #HINBAN #SKK
  #fig$ ; 木製ｶｳﾝﾀｰ対応
  )

  (setq #hinban (nth 0 &FIG$))
  (setq #skk    (nth 8 &FIG$))

  (cond
    ;;;水栓 処理 性格CODE510
    ((and (= "POS" &sMODE) (= CG_SKK_INT_SUI #skk)) ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
      (setq #en (PcSetWaterTap &FIG$))
      ; 拡張ﾃﾞｰﾀ "G_OPT" セット 2017/09/08 YM ADD
      (KcSetG_OPT #en)
    )
    ;2011/007/19 YM ADD 横幕板
    ((and (= "POS" &sMODE) (CheckSpSetBuzai #hinban "横幕板配置候補") )
      (setq #en (PcSetSpBuzai &FIG$ 11))
      ; 拡張ﾃﾞｰﾀ "G_OPT" セット 2017/09/08 YM ADD
      (KcSetG_OPT #en)
    )
    ;2011/007/19 YM ADD ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝ
    ((and (= "POS" &sMODE) (CheckSpSetBuzai #hinban "ガラス配置候補") )
			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
				(progn
					nil ;何もしない
				)
				(progn
					(CFAlertMsg "エンジニアドストーンでガラスパーテーションを取り付けたら、\n天板を特注品番にしてください。")
				)
			);_if
      (setq #en (PcSetSpBuzai &FIG$ 12))
      ; 拡張ﾃﾞｰﾀ "G_OPT" セット 2017/09/08 YM ADD
      (KcSetG_OPT #en)
    )
    (t
      (setq #en nil)
    )
  );cond

;;;2011/07/19YM@DEL  (setq #en (cond
;;;2011/07/19YM@DEL    ;;;水栓 処理 性格CODE510
;;;2011/07/19YM@DEL    ((and (= "POS" &sMODE) (= CG_SKK_INT_SUI (nth 8 &FIG$))) ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
;;;2011/07/19YM@DEL      (PcSetWaterTap &FIG$)
;;;2011/07/19YM@DEL    )
;;;2011/07/19YM@DEL    (t nil)
;;;2011/07/19YM@DEL  )); setq cond

  #en
);KcSetUniqueItem

;;;<HOM>*************************************************************************
;;; <関数名>    : PcSetSpBuzai
;;; <処理概要>  : ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝ設置処理
;;; <戻り値>    : 設置した図形名
;;; <作成>      : 2011/07/19 YM ADD
;;; <備考>      : P点 12 ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝ配置点に赤＋線表示＆スナップ処理
;;;*************************************************************************>MOH<
(defun PcSetSpBuzai (
  &selPT$     ; 設備部材の情報
  &pten_no    ; 配置対象Ｐ点番号(11:横幕,12:ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝ)
  /
  #DIS #DPT #EN #FH #I #II #LOOP #O #O1 #O2 #O3 #O4 #OK #OMD #PTEN$ #RET$ #SH #SNAP
  #TSEKISAN #UNIT #WORKP$ #XD_PTEN$
  )
  (setq #workP$ nil #pten$ nil #xd_pten$ nil)
  ;// コマンドの初期化
  (StartUndoErr)

  ; 現在のOスナップ、点モード、 点サイズ 取得
  (setq #oMD (getvar "OSMODE"))

  (setq #ret$ (KPGetPTEN &pten_no));引数=P点番号
  (setq #pten$    (car  #ret$))    ; PTEN?図形ﾘｽﾄ
  (setq #xd_pten$ (cadr #ret$))    ; "G_PTEN"ﾘｽﾄ

  ; 取得されたP点の座標に可視点を打つ
  (foreach #pten #pten$
    (setq #o (cdr (assoc 10 (entget #pten))))

    ;2011/07/19 YM MOD 点の作図ではなく線
    (setq #ret$ (GetPlusLinePT #o)); #oを中心に＋の線を引くときの始点、終点を返す
    (setq #o1 (nth 0 #ret$))
    (setq #o2 (nth 1 #ret$))
    (setq #o3 (nth 2 #ret$))
    (setq #o4 (nth 3 #ret$))

    (entmake
      (list
        (cons   0 "LINE")
        (cons 100 "AcDbEntity")
        (cons 100 "AcDbPoint")
        (cons  10 #o1)
        (cons  11 #o2)
        (cons  62 1)
      )
    )
    (setq #workP$ (append #workP$ (list (entlast)))) ; 可視点図形ﾘｽﾄ(後で削除する為)

    (entmake
      (list
        (cons   0 "LINE")
        (cons 100 "AcDbEntity")
        (cons 100 "AcDbPoint")
        (cons  10 #o3)
        (cons  11 #o4)
        (cons  62 1)
      )
    )
    (setq #workP$ (append #workP$ (list (entlast)))) ; 可視点図形ﾘｽﾄ(後で削除する為)
  );_foreach

  (setvar "OSMODE" 32)

;;; 配置点取得(ユーザーに図を出させて角度を付けさせる)
  (setq #OK T #loop T)

  ; 02/07/10 YM ADD-S ｽﾅｯﾌﾟﾓｰﾄﾞOFF
  (setq #snap (getvar "SNAPMODE"))
  (setvar "SNAPMODE" 0)

  (while #OK

    (setq #dPT (getpoint "\n設置点を指定: \n"));ﾕｰｻﾞｰ指定点

    (setq #i 0)
    (while (and #loop (< #i (length #pten$)))
      (setq #o (cdr (assoc 10 (entget (nth #i #pten$)))))
      (setq #dis (distance #o #dPT))
      (if (< #dis 0.1)
        (setq #ii #i #OK nil #loop nil) ; 何番目のPTEN5か？
      );_if
      (setq #i (1+ #i))
    );_foreach

    (if #OK ; PTEN上を選択しなかった
      (progn

        (CFAlertMsg "候補点以外の位置に設置します.")

        (setq #sH (KCFGetWTHeight))
        (if (= #sH nil)(setq #sH "0")) ; 01/06/26 YM ADD 図面に何もないとき#sH=nilで落ちる
        (setq #fH (getreal (strcat "高さ<" #sH ">: ")))
        (if (= nil #fH)
          (setq #fH (atof #sH))
        )
        (setq #dPT (list (car #dPT) (cadr #dPT) #fH))
        (setq #OK nil)
      )
    );_if

  );while

  ; 02/07/10 YM ADD-S ｽﾅｯﾌﾟﾓｰﾄﾞOFF
  (setvar "SNAPMODE" #snap)

  ;;; リストの点削除
  (foreach #P #workP$ (entdel #P))

  ; 設置実行
  (setq #en (PcInsSuisen&SetX #dPT &selPT$ #tSEKISAN))

  ; Oスナップ、点モード、 点サイズ を元に戻す
  (setvar "OSMODE" #oMD)
  (setq *error* nil)

  (if (= #unit "T");「家具」だった場合 ;06/08/23 YM
    (princ "\n引手を配置しました。")
    (princ "\n水栓を配置しました。")
  );_if

  #en
);PcSetSpBuzai


;<HOM>*************************************************************************
; <関数名>    : CheckSpSetBuzai
; <処理概要>  : 引数の品番がｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝ or 横幕板かどうか判定する
; <戻り値>    : T or nil
; <作成>      : 2011/07/19 YM ADD
; <備考>      : 参照ﾃｰﾌﾞﾙ = "ガラス配置候補","横幕板配置候補"
;               ﾌﾘｰﾌﾟﾗﾝ配置時特殊処理
;*************************************************************************>MOH<
(defun CheckSpSetBuzai (
  &hinban
  &table
  /
  #HINBAN #QRY$ #RET
  )
  (setq #ret nil)
  
  (setq #Qry$
    (CFGetDBSQLRec CG_DBSESSION &table
      (list
        (list "品番名称"   &hinban       'STR)
      )
    )
  )
  (if #Qry$
    (setq #ret T)
    ;else
    (setq #ret nil)
  );_if

  #ret
);CheckSpSetBuzai

;;;<HOM>***********************************************************************
;;; <関数名>    : PcChgG_LSYMPntData
;;; <処理概要>  : G_SYMの座標リストを変更
;;; <戻り値>    : 基点図形名
;;; <作成>      : 00-12-21 MH
;;; <備考>      :
;;;***********************************************************************>MOH<
(defun PcChgG_LSYMPntData (
  &eEN          ; G_SYM図形名
  &dNEW$        ; 点 更新内容リスト
  /
  #xd$ #i #xd #newLSYM$
  )
  ; 拡張データ"G_LSYM"中の座標値を変更
  (setq #xd$ (CFGetXData &eEN "G_LSYM"))
  (setq #i 0)
  (foreach #xd #xd$
    (if (= #i 1)
      (setq #newLSYM$ (append #newLSYM$ (list &dNEW$)))
      (setq #newLSYM$ (append #newLSYM$ (list #xd)))
    ); if
    (setq #i (1+ #i))
  ); foreach
  (CFSetXData &eEN "G_LSYM" #newLSYM$)
  &eEN
); PcChgG_LSYMPntData

;<HOM>*************************************************************************
; <関数名>    : PcMoveItem
; <処理概要>  : アイテムを現基点から指定された座標に移動､G_LSYM中の座標値を変更
; <戻り値>    : 図形名
; <作成>      : 01/01/26 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcMoveItem (
  &eEN        ; G_LSYM を持つ図形名
  &dMOV$      ; 移動先点座標
  /
  #eEN #dORG$ #dNEW$)
  (setq #eEN &eEN)
  (setq #dORG$ (cdr (assoc 10 (entget #eEN))))
  (if (= 'LIST (type &dMOV$)) (progn
    (command "_move" (CFGetSameGroupSS #eEN) "" #dORG$ &dMOV$)
    (setq #dNEW$ (cdr (assoc 10 (entget #eEN))))
    (PcChgG_LSYMPntData #eEN #dNEW$)
  )); if progn
  #eEN
);PcMoveItem

;<HOM>*************************************************************************
; <関数名>    : PcMoveItem2P
; <処理概要>  : アイテムを２点間で移動させ､移動した量 G_LSYM中の座標値を変更
; <戻り値>    : 図形名
; <作成>      : 01/01/26 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcMoveItem2P (
  &eEN        ; G_LSYM を持つ図形名
  &dORG$      ; 移動元基準点座標
  &dMOV$      ; 移動先基準点座標
  / #eEN #dNEW$)
  (setq #eEN &eEN)
  (if (and (= 'LIST (type &dORG$))(= 'LIST (type &dMOV$)))
    (progn
      (command "_move" (CFGetSameGroupSS #eEN) "" &dORG$ &dMOV$)
      (setq #dNEW$ (cdr (assoc 10 (entget #eEN))))
      (PcChgG_LSYMPntData #eEN #dNEW$)
    ); progn
  ); if
  #eEN
);PcMoveItem

;<HOM>*************************************************************************
; <関数名>    : KcMoveToSGCabinet
; <処理概要>  : アイテム中の側面図移動が必要かどうか判定して実行
; <戻り値>    : なし
; <作成>      : 01/04/06 MH
; <備考>      : 現状はコンロだけだが、水栓も行う可能性はある。
;*************************************************************************>MOH<
(defun KcMoveToSGCabinet (&eEN / #XL$ #FLG #enD$ #enD #cabXL$)
  ;; コンロ側面移動 配置されたのがコンロで範囲にドロップインキャビが存在する場合
  (if (and (= 'ENAME (type &eEN)) (setq #XL$ (CFGetXData &eEN "G_LSYM")))(progn
    (cond
      ; アイテムがコンロだった場合
      ((= (SKY_DivSeikakuCode (nth 9 #XL$) 1) CG_SKK_ONE_GAS)
        (setq #FLG 'T)
        (setq #enD$ (PcGetEn$CrossArea &eEN 0 0 0 0 'T))
        ;; 範囲にドロップインキャビネットはあるか？
        (while (and #FLG (setq #enD (car #enD$)))
          (setq #cabXL$ (CFGetXData #enD "G_LSYM"))
          (if (and (= (SKY_DivSeikakuCode (nth 9 #cabXL$) 3) CG_SKK_THR_GAS)
                   (equal (read (angtos (nth 2 #cabXL$) 0 3))
                          (read (angtos (nth 2 #XL$) 0 3)) 0.01)
              )(progn
            (PKC_MoveToSGCabinetSub &eEN #enD)
            (setq #FLG nil)
          )); progn if
          (setq #enD$ (cdr #enD$));if progn
        ); while
      )
    ); cond
  )); if progn
  (princ)
); KcMoveToSGCabinet

;;;<HOM>***********************************************************************
;;; <関数名>    : KcChgG_LSYMSecNo
;;; <処理概要>  : G_LSYM中の断面の有無値を変更 Xrecord の"DANMENSYM"に反映
;;; <戻り値>    : 基点図形名
;;; <作成>      : 01/04/16  MH
;;; <備考>      :
;;;***********************************************************************>MOH<
(defun KcChgG_LSYMSecNo (
  &eEN          ; G_SYM図形名
  &iSEC         ; 断面の有無 0 or 1
  /
  #xld$ #i #xl #newLSYM$
  )
  ; 拡張データ"G_LSYM"中の断面の有無値を変更
  (setq #xld$ (CFGetXData &eEN "G_LSYM"))
  (setq #i 0)
  (foreach #xl #xld$
    (if (= #i 14)
      (setq #newLSYM$ (append #newLSYM$ (list &iSEC)))
      (setq #newLSYM$ (append #newLSYM$ (list #xl)))
    ); if
    (setq #i (1+ #i))
  ); foreach
  (CFSetXData &eEN "G_LSYM" #newLSYM$)
  (KcSetDanmenSymXRec &eEN);  Xrecord の"DANMENSYM" 変更 01/04/24 MH
  &eEN
); KcChgG_LSYMSecNo

;;;<HOM>***********************************************************************
;;; <関数名>    : KcSetDanmenSymXRec
;;; <処理概要>  : G_LSYM中の断面の有無に応じて Xrecordの"DANMENSYM" 変更
;;; <戻り値>    : なし
;;; <作成>      : 01/04/24 MH
;;; <備考>      :
;;;***********************************************************************>MOH<
(defun KcSetDanmenSymXRec (
  &eEN          ; G_SYM図形名
  /
  #xld$ #HDL$ #HD #iSEC #TEMP$
  )
  ; "G_LSYM"中の断面の有無値を取得
  (setq #xld$ (CFGetXData &eEN "G_LSYM"))
  (if #xld$ (setq #iSEC (nth 14 #xld$)))
  ; Xrecord 管理
  (setq #HDL$ (CFGetXRecord "DANMENSYM"))
  (setq #HD (cdr (assoc 5 (entget &eEN))))
  (cond
    ; 断面の有無= 1 ,既存の Xrecord "DANMENSYM"に無い場合は追加
    ((and (= 1 #iSEC) (not (member #HD #HDL$)))
      (setq #HDL$ (cons #HD #HDL$))
      (CFSetXRecord "DANMENSYM" #HDL$)
    )
    ; 断面の有無= 0 ,既存の Xrecord "DANMENSYM"にある場合は消去
    ((and (= 0 #iSEC) (member #HD #HDL$))
      (setq #TEMP$ nil)
      (foreach #CHK #HDL$ (if (not (equal #CHK #HD)) (setq #TEMP$ (cons #CHK #TEMP$))))
      (setq #HDL$ #TEMP$)
      (CFSetXRecord "DANMENSYM" #HDL$)
    )
  ); cond
  (princ)
); KcSetDanmenSymXRec

;<HOM>*************************************************************************
; <関数名>    : PcGetNumOfUcab
; <処理概要>  : 図中のウォールキャビの数を算出
; <戻り値>    : 実数値
; <作成>      : 00/05/29 MH ADD
;*************************************************************************>MOH<
(defun PcGetNumOfUcab ( / #ss #i #iSE #iRES)
  (setq #iRES 0)
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if #ss (progn
    (setq #i 0)
    (repeat (sslength #ss)
      (setq #iSE (nth 9 (CFGetXData (ssname #ss #i) "G_LSYM")))
      (if (and (= (SKY_DivSeikakuCode #iSE 1) CG_SKK_ONE_CAB)
               (= (SKY_DivSeikakuCode #iSE 2) CG_SKK_TWO_UPP))
        (setq #iRES (1+ #iRES))
      )
      (setq #i (1+ #i))
    ); end of repeat
  )); if progn
  #iRES
); PcGetNumOfUcab

;<HOM>*************************************************************************
; <関数名>    : PcSetItem
; <処理概要>  : PcParts.lsp 内共通のアイテム設置
; <戻り値>    : 設置された図形名
; <作成>      : 00/06/30 MH
; <共通部>   ①入替モードならば、元サイズ取得、隣接取得、元図形削除
;            ②設置モードならば設置高さ設定
;            ③H800処理用にフラグ設定
;            ④図形挿入、分解、グループ化、データセット
;            ⑤挿入モードの場合、DBとGSYMのW差の補正 移動
;            ⑥必要ならWDH伸縮
;            ⑦扉面処理
;            ⑧H800の高さ調整処理
;            ⑨周辺図形移動
;            ⑩拡張データ"G_OPT"セット
;            ⑪基準アイテム移行
;*************************************************************************>MOH<
(defun PcSetItem (
  &sMODE      ; "POS" "CNT" "INS" "CHG" "SET" 使用元の関数フラグ
  &sDIR       ; "L" "R" "D" "T"  ("CNT" "INS" 以外では nil)
  &FIG$       ; SELPARTS.CFG の内容リスト
  &dINS       ; 挿入点                    ("POS"ならnil)
  &fANG       ; 挿入角度(ラジアン)        ("POS"ならnil)
  &eBASE      ; 基準図形                  ("CNT" "INS" 以外は nil)
  &eCHG       ; 入れ替え元図形            ("CHG"のみで使用)
  /
  #FIG$ #xd$ #baseWDH$ #chgWDH$ #eNEXT$ #sHIN #fname #flg #elv #elv2 #height
  #posZ #fANG #dINS #ss #eNEW #MOV #QLY$ #ss_H800 #en_lis_#ss #B_Hflag #F_Hflag
  #newH #basH #cntZ #fMOVE #mov #eBASE #gsymxd$ #bpt #type #fHmov
  #LASTPT #LASTZ #HMOVEFLG #OS #OT #SM #chgSEC
  #sCd        ; 性格CODE
;-- 2011/10/03 A.Satoh Add - S
  #en_syoku #move #dep #qry$$ #oku
;-- 2011/10/03 A.Satoh Add - E
;-- 2011/10/31 A.Satoh Add - S
#LXD$ #pt #ANG #gnam #eDelBRK_W$ #eDelBRK_D$ #eDelBRK_H$
#XLINE_W #XLINE_D #XLINE_H #eD #BrkW #BrkD #BrkH
;-- 2011/10/31 A.Satoh Add - E
#STR_FLG	;-- 2011/11/24 A.Satoh Add
#alert_f #msg_str #BrkW_str #BrkD_str #BrkH_str ;--2011/12/19 A.Satoh Add
;-- 2012/02/16 A.Satoh Add CG対応 - S
#hinban #qry$ #org_size$ #BrkW2 #BrkD2 #BrkH2 #XLINE_W$ #XLINE_D$ #XLINE_H$
#idx #dist #BRKLINED$ #BRKLINEH$ #BRKLINEW$
;-- 2012/02/16 A.Satoh Add CG対応 - E
#W_f #D_f #H_f #chk  ;-- 2012/02/22 A.Satoh Add
  )
  (setq #sCd (fix (nth 8 &fig$))) ; 01/06/17 HN ADD

  (setq #FIG$ &FIG$)
  (setq #sHIN (car &FIG$))
  (setq #dINS &dINS)
  (setq #fANG &fANG)
  (setq #eBASE &eBASE)
  (if (or (= &sMODE "CNT") (= &sMODE "INS")) (progn
    (setq #xd$ (CFGetXData #eBASE "G_SYM"))
    (setq #baseWDH$ (list (nth 3 #xd$) (nth 4 #xd$) (nth 5 #xd$)))
  )); if progn

;-- 2011/11/09 A.Satoh Add - S
		; グローバル変数を元に戻す
		(setq CG_BASE_UPPER nil)
;-- 2011/11/09 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
		; グローバル変数を元に戻す
		(setq #STR_FLG nil)
		(setq CG_POS_STR nil)
		(setq CG_TOKU nil)
;-- 2011/11/24 A.Satoh Add - E

;-- 2012/02/22 A.Satoh Add - S
	(setq #chk (list nil nil nil))
	(setq #W_f nil)
	(setq #D_f nil)
	(setq #H_f nil)
;-- 2012/02/22 A.Satoh Add - E

  ; ①入替モードの場合  入替え元サイズ取得、隣接取得、元図形削除
  (if (= &sMODE "CHG") (progn
    (setq #xd$ (CFGetXData &eCHG "G_SYM"))
    (setq #chgWDH$ (list (nth 3 #xd$) (nth 4 #xd$) (nth 5 #xd$)))
    (setq #chgSEC (nth 14 (CFGetXData &eCHG "G_LSYM"))); 01/04/16 MH ADD
    ;;; 元図形左に隣接(なければ右)する図形を基準図形として取得
    (setq #eBASE (car (PcChkItemNext &eCHG 1 0 0 0))) ; 左隣接
    (if (not #eBASE) (setq #eBASE (car (PcChkItemNext &eCHG 0 1 0 0)))) ; 右隣接
    ;;; 移動対象図形のリスト（元図形に隣接する）を取得させる
    (setq #eNEXT$ (PcGetNextMoveItem$ &eCHG nil))
;;;01/02/05YM@    ;;; 元図形削除実行
;;;01/02/05YM@    (command "_erase" (CFGetSameGroupSS &eCHG) "") ; 元図形 &eCHG
    ;;; 元図形=基準アイテムだったときの対策(実体がなければＸレコードを初期化)
    (if (and (CFGetBaseSymXRec) (not (entget (CFGetBaseSymXRec))))
      (ResetBaseSym))               ;00/09/25 SN MOD
      ;(CFSetXRecord "BASESYM" nil));00/09/25 SN MOD
  )); if progn

  ; ②設置モードならば設置高さ設定
  ; "POS" のみ高さ設定  00/07/31 MOD MH 高さ指定処理を最初の処理に移動
  (if (= &sMODE "POS") (progn
    ; "POS"は初めての作図の可能性があるため、作図用の画層設置
    (MakeLayer "Z_00_00_00_01" 7 "CONTINUOUS") ; 05/12 MH ADD

    (setq #elv (getvar "ELEVATION"))
    (cond
      ((= (SKY_DivSeikakuCode (nth 8 #FIG$) 2) CG_SKK_TWO_UPP)
        (setvar "ELEVATION" CG_UpCabHeight)
      )
      (t (setvar "ELEVATION" 0))
    )
    (setq #elv2 (getvar "ELEVATION"))

    (if CG_TESTMODE ; 01/05/23 YM 自動配置ﾃｽﾄ中
      (setq #height 0.0)
      (setq #height (getreal (strcat "高さ<" (itoa (fix #elv2)) ">: ")));00/06/27 SN MOD
    );_if

    (if (= #height nil)
      (progn (setvar "ELEVATION" #elv2)
             (setq #posZ #elv2))
      (progn (setvar "ELEVATION" #height)
             (setq #posZ #height))
    ); if
  )); if progn

  ; ③H800処理用にフラグ設定
  (setq #flg nil) ; 01/01/12 YM

  ; ④図形挿入
  (setq #fname (strcat (cadr #FIG$) ".dwg"))
  (Pc_CheckInsertDwg #fname CG_MSTDWGPATH); 挿入予定のIDファイル名作成&チェック
  (if (= &sMODE "POS")
    ; "POS" のみ挿入点ユーザが指定
    (progn

    (if CG_TESTMODE
      (progn ; 01/05/23 YM 自動配置ﾃｽﾄ中
        (command ".insert" (strcat CG_MSTDWGPATH #fname) (list CG_TEST_X CG_TEST_Y 0) 1 1 0) ; 2009
        (setq #fANG 0)
        (setq #lastpt '(0 0 0))
      )
      (progn ; 通常
        (princ "\n挿入点: ")                                          ; 01/01/29 YM DEL
        (command ".insert" (strcat CG_MSTDWGPATH #fname) pause) ; 2009
          (command 1 1);2009

        ; 01/01/29 YM ADD START
  ;;;     (setq #bpt (getpoint "\n挿入点: "))
  ;;;     (setq #bpt (list (car #bpt)(cadr #bpt) #posZ))
  ;;;      (command ".insert" (strcat CG_MSTDWGPATH #fname) #bpt "" "")
        ; 01/01/29 YM ADD END
        (princ "\n配置角度<0>: ")
        (command pause)
        (setq #fANG (cdr (assoc 50 (entget (entlast)))))

        ; 01/02/08 YM START
        (setq #lastpt (getvar "LASTPOINT"))
      )
    );_if

      (setq #lastZ (caddr #lastpt))
      (if (equal #lastZ #posZ 0.001) ; ｺﾏﾝﾄﾞﾗｲﾝ指定高さと違うなら移動する
        (princ)
        (progn
;;; ｼｽﾃﾑ変数設定 01/04/09 YM 一時解除
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
          (command "_move" (entlast) "" '(0 0 0) (list 0 0 (- #posZ #lastZ)))
;;; ｼｽﾃﾑ変数設定 01/04/09 YM
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)

        )
      );_if
      ; 01/02/08 YM END

      ; 高さ下方向に伸縮のある図形だった場合、伸縮分移動
      (if (and #HmoveFLG (/= 0 (setq #mov (- (nth 7 &FIG$) (nth 7 #FIG$)))))
        (command "_move" (entlast) "" '(0 0 0) (list 0 0 #mov))
      )
    ); progn
    ; "POS" 以外は引数の点で出力
    (command "_insert" (strcat CG_MSTDWGPATH #fname) #dINS 1 1 (rtd #fANG));2009
  ); if

;-- 2011/10/03 A.Satoh Add - S
  ; 連続上配置で食洗である場合
  (if (and (= &sMODE "CNT") (= &sDIR "T"))
    (progn
      (setq #en_syoku (entlast))
      (if (= #sCd 110)
        (if (= BU_CODE_0009 "1")
          (if (= "Q" (substr (nth 5 (CFGetXData &eBASE "G_LSYM")) 9 1))
            (progn
              (setq #move "0,-50,0")
              (command "_.MOVE" #en_syoku "" "0,0,0" #move)
            )
          )
          (progn
            (setq #dep (nth 4 (CFGetXData &eBASE "G_SYM")))
            (setq #qry$$
              (CFGetDBSQLRec CG_DBSESSION "奥行"
                (list
                  (list "奥行" (itoa (fix (+ #dep 0.01))) 'INT)
                )
              )
            )
            (if (and #qry$$ (= 1 (length #qry$$)))
              (setq #oku (nth 1 (nth 0 #qry$$)))
              (setq #oku "?")
            )
            (if (or (= #oku "D900") (= #oku "D700"))
              (progn
                (setq #move "0,-50,0")
                (command "_.MOVE" #en_syoku "" "0,0,0" #move)
              )
            )
          )
        )
      )
    )
  )
;-- 2011/10/03 A.Satoh Add - E

  ; HOPE-0313 00/12/07 MH MOD (実行位置変更) 施工情報線が見えるのを防ぐ
;;;  (command "._shademode" "H") ; 01/01/29 YM ADD
  (command "_.layer" "F" "Z_*" "") ; 01/01/29 YM ADD
  (command "_.layer" "T" "Z_00*" "") ; 01/01/29 YM ADD
  (command "_.layer" "T" "Z_KUTAI" "") ; 01/02/20 YM ADD

  ; ④図形 分解、グループ化、データセット
  (command "_explode" (entlast))
  (setq #ss (ssget "P"))
  ; "CHG"モードでユーザが変更にNoならここでUndo終了
  (if (= &sMODE "CHG") (command "_change" #ss "" "P" "C" "RED" ""))
;-- 2011/12/05 A.Satoh Mod - S
;;;;;  (if (and (= &sMODE "CHG") (not (CFYesNoDialog "変更してよろしいですか？")))
  (if (and (= &sMODE "CHG") (= CG_REGULAR nil) (not (CFYesNoDialog "変更してよろしいですか？")))
;-- 2011/12/05 A.Satoh Mod - E
    (command "_undo" "b")
  ; 以下CHG"モード 条件以外
    (progn
;;;01/02/05YM@      (if (= &sMODE "CHG") (command "_change" #ss "" "P" "C" "BYLAYER" ""))
      (SKMkGroup #ss) ;分解した図形群で名前のないグループ作成
      (command "_layer" "u" "N_*" "")

      (setq #eNEW (SearchGroupSym (ssname #ss 0))) ; ｼﾝﾎﾞﾙ図形 #eNEW
      ; "POS" はここで初めて挿入点座標が取れる
      (if (= &sMODE "POS") (setq #dINS (cdr (assoc 10 (entget #eNEW)))))
      (SKY_SetZukeiXData #FIG$ #eNEW #dINS #fANG)
;;;01/09/03M@DEL      (if (= 1 #chgSEC)(KcChgG_LSYMSecNo #eNEW 1)); 01/04/16 MH MOD 入替え時に2重にｾｯﾄすることになる! ここではG_LSYMｾｯﾄしない

;;; @@@ ｺｰﾅｰｷｬﾋﾞ"115"はPMEN2の頂点数をﾁｪｯｸする 01/04/11 YM ADD START
      (if (CheckSKK$ #eNEW (list (itoa CG_SKK_ONE_CAB) "?" (itoa CG_SKK_THR_CNR))) ; ｺｰﾅｰｷｬﾋﾞ ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
        (KP_MakeCornerPMEN2 #eNEW)
      );_if
;;; @@@ ｺｰﾅｰｷｬﾋﾞ"115"はPMEN2の頂点数をﾁｪｯｸする 01/04/11 YM ADD END

; 02/01/09 ⑤と⑥の順番を入れ替えして、補正移動は入力コードに関わらず行う ---------------------------------------------------------------------------

;;;02/01/09YM@MOD      ; ⑤挿入モードの場合、DBとG_SYMの差分を補正
;;;02/01/09YM@MOD      ;   00/06/21MH ADD SelParts.cfgから伸縮作業を行う場合補正させない
;;;02/01/09YM@MOD      (if (and (wcmatch &sMODE "CNT,INS,CHG")
;;;02/01/09YM@MOD            (not (and (findfile (strcat CG_SYSPATH "SELPARTS.CFG"))
;;;02/01/09YM@MOD                      (< 0 (nth 11 (PcGetPartQLY$  "品番基本" #sHIN nil nil))); 入力ｺｰﾄﾞ
;;;02/01/09YM@MOD          ))); if条件
;;;02/01/09YM@MOD        (progn
;;;02/01/09YM@MOD          ; 一般Ｗ方向 補正 ; "L" 方向挿入で、W値に差があった
;;;02/01/09YM@MOD          (if (and (= &sDIR "L")
;;;02/01/09YM@MOD            (/= 0 (setq #MOV (- (nth 5 #FIG$) (nth 3 (CFGetXData #eNEW "G_SYM")))))) ; W 同士比較
;;;02/01/09YM@MOD            (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS (Pcpolar #dINS #fANG #MOV))
;;;02/01/09YM@MOD          );if
;;;02/01/09YM@MOD          ; 隅用キャビ "R" 方向挿入で、D値に差があった 特殊処理
;;;02/01/09YM@MOD          (if (and (= (CFGetSymSKKCode #eNEW 3) CG_SKK_THR_CNR)
;;;02/01/09YM@MOD                   (= &sDIR "R")
;;;02/01/09YM@MOD                   (/= 0 (setq #MOV (- (nth 6 #FIG$) (nth 4 (CFGetXData #eNEW "G_SYM")))))) ; D 同士比較
;;;02/01/09YM@MOD            (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS
;;;02/01/09YM@MOD               (Pcpolar #dINS (- #fANG (dtr 90)) #MOV))
;;;02/01/09YM@MOD          ); if
;;;02/01/09YM@MOD        ); progn
;;;02/01/09YM@MOD      ); if
;;;02/01/09YM@MOD
;;;02/01/09YM@MOD      (command "_.layer" "on" "M_*" ""); 全共通画層処理
;;;02/01/09YM@MOD      ; ⑥必要ならWDH伸縮
;;;02/01/09YM@MOD      (setq #fHmov 0) ; 上基点で伸縮ありの場合の移動値
;;;02/01/09YM@MOD      (if (= (nth 9 #FIG$) "Yes")(progn ; ストレッチフラグ
;;;02/01/09YM@MOD        ;00/08/31 SN MOD 伸縮方向毎に処理を行う
;;;02/01/09YM@MOD        (setq #gsymxd$ (CFGetXData #eNEW "G_SYM"))
;;;02/01/09YM@MOD        ; 伸縮実行前に⑨図形移動用に高さの差を取得しておく 01/02/02 MH MOD
;;;02/01/09YM@MOD        (setq #fHmov (- (nth 7 #FIG$) (nth 5 #gsymxd$)))
;;;02/01/09YM@MOD        (if (not (equal (nth 5 #FIG$) (nth 3 #gsymxd$) 0.0001))
;;;02/01/09YM@MOD          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 4 #gsymxd$) (nth 5 #gsymxd$))
;;;02/01/09YM@MOD        )
;;;02/01/09YM@MOD        (if (not (equal (nth 6 #FIG$) (nth 4 #gsymxd$) 0.0001))
;;;02/01/09YM@MOD          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 5 #gsymxd$))
;;;02/01/09YM@MOD        )
;;;02/01/09YM@MOD        (if (not (equal (nth 7 #FIG$) (nth 5 #gsymxd$) 0.0001))
;;;02/01/09YM@MOD          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$))
;;;02/01/09YM@MOD        )
;;;02/01/09YM@MOD        ;(SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$))
;;;02/01/09YM@MOD      ))



      (command "_.layer" "on" "M_*" ""); 全共通画層処理
      ; ⑥必要ならWDH伸縮
      (setq #fHmov 0) ; 上基点で伸縮ありの場合の移動値
      (if (= (nth 9 #FIG$) "Yes")(progn ; ストレッチフラグ
        ;00/08/31 SN MOD 伸縮方向毎に処理を行う
        (setq #gsymxd$ (CFGetXData #eNEW "G_SYM"))
;-- 2012/02/21 A.Satoh Add CG対応 - S
;;;;;;-- 2012/02/17 A.Satoh Add CG対応 - S
;;;;;				(setq CG_SizeH (nth 5 #gsymxd$))
;;;;;;-- 2012/02/17 A.Satoh Add CG対応 - E
;-- 2012/02/21 A.Satoh Add CG対応 - E
;-- 2011/10/31 A.Satoh Add - S
				(setq #LXD$ (CFGetXData #eNEW "G_LSYM"))
				(setq #pt  (cdr (assoc 10 (entget #eNEW))))      ; ｼﾝﾎﾞﾙ基準点
				(setq #ANG (nth 2 #LXD$))                       ; ｼﾝﾎﾞﾙ配置角度
				(setq #gnam (SKGetGroupName #eNEW))              ; ｸﾞﾙｰﾌﾟ名
;-- 2012/02/21 A.Satoh Add CG対応 - S
				(setq CG_SizeH (nth 13 #LXD$))
;-- 2012/02/21 A.Satoh Add CG対応 - E
;-- 2011/11/28 A.Satoh Del - S
;;;;;  			(setq #eDelBRK_W$ (PcRemoveBreakLine #eNEW "W")) ; W方向ブレーク除去
;;;;;			  (setq #eDelBRK_D$ (PcRemoveBreakLine #eNEW "D")) ; D方向ブレーク除去
;;;;;			  (setq #eDelBRK_H$ (PcRemoveBreakLine #eNEW "H")) ; H方向ブレーク除去
;-- 2011/11/28 A.Satoh Del - E
;-- 2012/02/16 A.Satoh Add CG対応 - S
				(setq #org_size$
					(list
						(nth 3 #gsymxd$)	; 幅
						(nth 4 #gsymxd$)	; 奥行
						(nth 5 #gsymxd$)	; 高さ
					)
				)
;-- 2012/02/16 A.Satoh Add CG対応 - E

;-- 2011/12/19 A.Satoh Mod - S
				(setq #BrkW nil)
				(setq #BrkD nil)
				(setq #BrkH nil)
				(setq #alert_f nil)
				(setq #msg_str "図形に")
;-- 2012/02/16 A.Satoh Add CG対応 - S
				(setq #BrkW2 nil)
				(setq #BrkD2 nil)
				(setq #BrkH2 nil)
				(setq #XLINE_W$ nil)
				(setq #XLINE_D$ nil)
				(setq #XLINE_H$ nil)
;-- 2012/02/16 A.Satoh Add CG対応 - E

;-- 2011/12/21 A.Satoh Add - S
				(if (>= (nth 12 #FIG$) 4)
;-- 2011/12/21 A.Satoh Add - E
				; W方向ブレークラインの存在チェック
;-- 2012/02/16 A.Satoh Mod CG対応 - S
;;;;;				(if (= (PCSetItem_CheckBreakLineExist #eNew "W") nil)
					(progn
						(setq #BrkLineW$ (PCSetItem_CheckBreakLineExist #eNew "W" #pt #ANG))
						(if (= #BrkLineW$ nil)
;-- 2012/02/16 A.Satoh Mod CG対応 - S
							(progn
								(setq #BrkW_str "【幅方向】")
								(setq #BrkW (fix (* (fix (nth 3 #gsymxd$)) 0.5)))
							)
							(setq #BrkW_str "")
						)
;-- 2012/02/16 A.Satoh Add CG対応 - S
					)
;-- 2012/02/16 A.Satoh Add CG対応 - E
;-- 2011/12/21 A.Satoh Add - S
					(setq #BrkW_str "")
				)
;-- 2011/12/21 A.Satoh Add - E

;-- 2011/12/21 A.Satoh Add - S
				(if (or (= (nth 12 #FIG$) 2) (= (nth 12 #FIG$) 3) (= (nth 12 #FIG$) 6) (= (nth 12 #FIG$) 7))
;-- 2011/12/21 A.Satoh Add - E
				; D方向ブレークラインの存在チェック
;-- 2012/02/16 A.Satoh Mod CG対応 - S
;;;;;				(if (= (PCSetItem_CheckBreakLineExist #eNew "D") nil)
					(progn
						(setq #BrkLineD$ (PCSetItem_CheckBreakLineExist #eNew "D" #pt #ANG))
						(if (= #BrkLineD$ nil)
;-- 2012/02/16 A.Satoh Mod CG対応 - E
							(progn
								(setq #BrkD_str "【奥行方向】")
								(setq #BrkD (fix (* (fix (nth 4 #gsymxd$)) 0.5)))
							)
							(setq #BrkD_str "")
;-- 2012/02/16 A.Satoh Mod CG対応 - E
						)
;-- 2012/02/16 A.Satoh Mod CG対応 - S
					)
;-- 2012/02/16 A.Satoh Mod CG対応 - E
;-- 2011/12/21 A.Satoh Add - S
					(setq #BrkD_str "")
				)
;-- 2011/12/21 A.Satoh Add - E

;-- 2011/12/21 A.Satoh Add - S
				(if (or (= (nth 12 #FIG$) 1) (= (nth 12 #FIG$) 3) (= (nth 12 #FIG$) 5) (= (nth 12 #FIG$) 7))
;-- 2011/12/21 A.Satoh Add - E
				; H方向ブレークラインの存在チェック
;-- 2012/02/16 A.Satoh Mod CG対応 - S
;;;;;				(if (= (PCSetItem_CheckBreakLineExist #eNew "H") nil)
					(progn
						(setq #BrkLineH$ (PCSetItem_CheckBreakLineExist #eNew "H" #pt #ANG))
						(if (= #BrkLineH$ nil)
;-- 2012/02/16 A.Satoh Mod CG対応 - E
							(progn
								(setq #BrkH_str "【高さ方向】")
								(if (> 0 (nth 10 #gsymxd$))
									(setq #BrkH (- (+ (fix (* (fix (nth 5 #gsymxd$)) 0.5)) (caddr #pt)) (nth 5 #gsymxd$)))
									(setq #BrkH (fix (* (fix (nth 5 #gsymxd$)) 0.5)))
								)
							)
							(setq #BrkH_str "")
						)
;-- 2012/02/16 A.Satoh Mod CG対応 - S
					)
;-- 2012/02/16 A.Satoh Mod CG対応 - E
;-- 2011/12/21 A.Satoh Add - S
					(setq #BrkH_str "")
				)
;-- 2011/12/21 A.Satoh Add - E

;-- 2011/12/21 A.Satoh Add - S
				(if (> (nth 12 #FIG$) 0)
;-- 2011/12/21 A.Satoh Add - E
				(if (or (/= #BrkW nil) (/= #BrkD nil) (/= #BrkH nil))
					(progn
		        (if (and (not (equal (nth 5 #FIG$) (nth 3 #gsymxd$) 0.0001))
										 (/= #BrkW nil))
							(progn
								(setq #alert_f T)
								(setq #msg_str (strcat #msg_str #BrkW_str))
							)
						)
		        (if (and (not (equal (nth 6 #FIG$) (nth 4 #gsymxd$) 0.0001))
										 (/= #BrkD nil))
							(progn
								(setq #alert_f T)
								(setq #msg_str (strcat #msg_str #BrkD_str))
							)
						)
		        (if (and (not (equal (nth 7 #FIG$) (nth 5 #gsymxd$) 0.0001))
										 (/= #BrkH nil))
							(progn
								(setq #alert_f T)
								(setq #msg_str (strcat #msg_str #BrkH_str))
							)
						)

						(if (= #alert_f T)
							(progn
								(setq #msg_str (strcat #msg_str "のブレークラインがないため、中央位置に自動的に設置します。"))
								(CFAlertMsg #msg_str)
							)
						)
					)
				)
;-- 2011/12/21 A.Satoh Add - S
				)
;-- 2011/12/21 A.Satoh Add - E

;;;;;				(setq #BrkW (fix (* (fix (nth 3 #gsymxd$)) 0.5)))
;;;;;				(setq #BrkD (fix (* (fix (nth 4 #gsymxd$)) 0.5)))
;;;;;				(if (> 0 (nth 10 #gsymxd$))
;;;;;					(setq CG_BASE_UPPER T)
;;;;;				)
;;;;;				(if CG_BASE_UPPER
;;;;;					(setq #BrkH (- (+ (fix (* (fix (nth 5 #gsymxd$)) 0.5)) (caddr #pt)) (nth 5 #gsymxd$)))
;;;;;					(setq #BrkH (fix (* (fix (nth 5 #gsymxd$)) 0.5)))
;;;;;				)
;-- 2011/12/19 A.Satoh Mod - E
;-- 2011/11/28 A.Satoh Del - S
;;;;;				(setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))
;;;;;				(setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))
;;;;;				(setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))
;;;;;				(CFSetXData #XLINE_W "G_BRK" (list 1))
;;;;;				(CFSetXData #XLINE_D "G_BRK" (list 2))
;;;;;				(CFSetXData #XLINE_H "G_BRK" (list 3))
;;;;;				;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
;;;;;				(command "-group" "A" #gnam #XLINE_W "")
;;;;;				(command "-group" "A" #gnam #XLINE_D "")
;;;;;				(command "-group" "A" #gnam #XLINE_H "")
;-- 2011/11/28 A.Satoh Del - E
;-- 2011/10/31 A.Satoh Add - E
        ; 伸縮実行前に⑨図形移動用に高さの差を取得しておく 01/02/02 MH MOD
        (setq #fHmov (- (nth 7 #FIG$) (nth 5 #gsymxd$)))
        (if (not (equal (nth 5 #FIG$) (nth 3 #gsymxd$) 0.0001))
;-- 2011/10/31 A.Satoh Mod - S
;          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 4 #gsymxd$) (nth 5 #gsymxd$))
					(progn
;-- 2011/12/19 A.Satoh Mod - S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;						(setq CG_POS_STR T)
;;;;;						(setq CG_TOKU T)
;;;;;						(setq #STR_FLG T)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;						(setq #eDelBRK_W$ (PcRemoveBreakLine #eNEW "W")) ; W方向ブレーク除去
;;;;;						(setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))
;;;;;						(CFSetXData #XLINE_W "G_BRK" (list 1))
;;;;;						;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
;;;;;						(command "-group" "A" #gnam #XLINE_W "")
;;;;;;-- 2011/11/28 A.Satoh Add - E
;;;;;	          (setq CG_TOKU_BW #BrkW)
;;;;;;-- 2011/11/28 A.Satoh Del - S
;;;;;;;;;;  	        (setq CG_TOKU_BD nil)
;;;;;;;;;;    	      (setq CG_TOKU_BH nil)
;;;;;;-- 2011/11/28 A.Satoh Del - E
						(if #BrkW
							(progn
								(setq #eDelBRK_W$ (PcRemoveBreakLine #eNEW "W")) ; W方向ブレーク除去
								(setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))
								(CFSetXData #XLINE_W "G_BRK" (list 1))
								;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
								(command "-group" "A" #gnam #XLINE_W "")
			          (setq CG_TOKU_BW #BrkW)
;-- 2012/02/16 A.Satoh Add CG対応 - S
								(setq #XLINE_W$ (list #BrkW nil))
;-- 2012/02/16 A.Satoh Add CG対応 - E
							)
;-- 2012/02/16 A.Satoh Add CG対応 - S
							(progn
								(setq #idx 0)
								(repeat (length #BrkLineW$)
									(if (> 2 #idx)
										(progn
											(setq #dist (PCSetItem_GetBreakLineDist (nth #idx #BrkLineW$) "W" #pt #ANG))
											(setq #XLINE_W$ (append #XLINE_W$ (list #dist)))
										)
									)
									(setq #idx (1+ #idx))
								)
							)
;-- 2012/02/16 A.Satoh Add CG対応 - E
						)
;-- 2011/12/19 A.Satoh Mod - E

;-- 2012/02/22 A.Satoh Add - S
						(setq #W_f T)
;-- 2012/02/22 A.Satoh Add - S

						; 幅方向伸縮処理
	          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 4 #gsymxd$) (nth 5 #gsymxd$))

;-- 2011/12/19 A.Satoh Mod - S
;;;;;            ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
;;;;;            (entdel #XLINE_W)
;;;;;            ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
;;;;;            (foreach #eD #eDelBRK_W$
;;;;;              (if (= (entget #eD) nil) (entdel #eD)) ;W方向ブレーク復活
;;;;;            );for
;;;;;
;;;;;;-- 2011/11/28 A.Satoh Del - S
;;;;;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;;;;;;			      (if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))
;;;;;;;;;;-- 2011/11/24 A.Satoh Add - E
;;;;;;-- 2011/11/28 A.Satoh Del - S
						(if #BrkW
							(progn
		            ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
    		        (entdel #XLINE_W)
        		    ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
            		(foreach #eD #eDelBRK_W$
		              (if (= (entget #eD) nil) (entdel #eD)) ;W方向ブレーク復活
    		        )
							)
						)
;-- 2011/12/19 A.Satoh Mod - E
					)
;-- 2011/12/19 A.Satoh Del - S
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;					(progn
;;;;;						(setq CG_POS_STR T)
;;;;;						(setq CG_TOKU T)
;;;;;						(setq #STR_FLG T)
;;;;;	          (setq CG_TOKU_BW #BrkW)
;;;;;					)
;;;;;-- 2011/11/28 A.Satoh Add - E
;-- 2011/12/19 A.Satoh Mod - E
;-- 2011/10/31 A.Satoh Mod - E
        )
        (if (not (equal (nth 6 #FIG$) (nth 4 #gsymxd$) 0.0001))
;-- 2011/10/31 A.Satoh Mod - S
;          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 5 #gsymxd$))
					(progn
;-- 2011/12/19 A.Satoh Mod - S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;;-- 2011/11/28 A.Satoh Mod - S
;;;;;						(if #STR_FLG
;;;;;							(progn
;;;;;								(setq CG_POS_STR nil)
;;;;;							)
;;;;;						(if (= #STR_FLG nil)
;;;;;;-- 2011/11/28 A.Satoh Mod - E
;;;;;							(progn
;;;;;								(setq CG_POS_STR T)
;;;;;								(setq #STR_FLG T)
;;;;;								(setq CG_TOKU T)
;;;;;							)
;;;;;						)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;						(setq #eDelBRK_D$ (PcRemoveBreakLine #eNEW "D")) ; D方向ブレーク除去
;;;;;						(setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))
;;;;;						(CFSetXData #XLINE_D "G_BRK" (list 2))
;;;;;						;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
;;;;;						(command "-group" "A" #gnam #XLINE_D "")
;;;;;;-- 2011/11/28 A.Satoh Add - E
;;;;;  	        (setq CG_TOKU_BD #BrkD)
;;;;;;-- 2011/11/28 A.Satoh Del - S
;;;;;;;;;;	          (setq CG_TOKU_BW nil)
;;;;;;;;;;    	      (setq CG_TOKU_BH nil)
;;;;;;-- 2011/11/28 A.Satoh Del - E
						(if #BrkD
							(progn
								(setq #eDelBRK_D$ (PcRemoveBreakLine #eNEW "D")) ; D方向ブレーク除去
								(setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))
								(CFSetXData #XLINE_D "G_BRK" (list 2))
								;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
								(command "-group" "A" #gnam #XLINE_D "")
  			        (setq CG_TOKU_BD #BrkD)
;-- 2012/02/16 A.Satoh Add CG対応 - S
								(setq #XLINE_D$ (list #BrkD nil))
;-- 2012/02/16 A.Satoh Add CG対応 - E
							)
;-- 2012/02/16 A.Satoh Add CG対応 - S
							(progn
								(setq #idx 0)
								(repeat (length #BrkLineD$)
									(if (> 2 #idx)
										(progn
											(setq #dist (PCSetItem_GetBreakLineDist (nth #idx #BrkLineD$) "D" #pt #ANG))
											(setq #XLINE_D$ (append #XLINE_D$ (list #dist)))
										)
									)
									(setq #idx (1+ #idx))
								)
							)
;-- 2012/02/16 A.Satoh Add CG対応 - E
						)
;-- 2011/12/19 A.Satoh Mod - E

;-- 2012/02/22 A.Satoh Add - S
						(setq #D_f T)
;-- 2012/02/22 A.Satoh Add - S

						; 奥行方向伸縮処理
	          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 5 #gsymxd$))

;-- 2011/12/19 A.Satoh Mod - S
;;;;;            ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
;;;;;            (entdel #XLINE_D)
;;;;;            ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
;;;;;            (foreach #eD #eDelBRK_D$
;;;;;              (if (= (entget #eD) nil) (entdel #eD)) ;D方向ブレーク復活
;;;;;            );for
;;;;;
						(if #BrkD
							(progn
		            ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
    		        (entdel #XLINE_D)
        		    ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
            		(foreach #eD #eDelBRK_D$
		              (if (= (entget #eD) nil) (entdel #eD)) ;D方向ブレーク復活
    		        )
							)
						)
;-- 2011/12/19 A.Satoh Mod - E
;-- 2011/11/28 A.Satoh Del - S
;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;			      (if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))
;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/11/28 A.Satoh Del - E
					)
;-- 2011/12/19 A.Satoh Del - S
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;					(progn
;;;;;						(if (= #STR_FLG nil)
;;;;;							(progn
;;;;;								(setq CG_POS_STR T)
;;;;;								(setq #STR_FLG T)
;;;;;								(setq CG_TOKU T)
;;;;;							)
;;;;;						)
;;;;;  	        (setq CG_TOKU_BD #BrkD)
;;;;;					)
;;;;;-- 2011/11/28 A.Satoh Add - E
;;;;;-- 2011/10/31 A.Satoh Mod - E
;-- 2011/12/19 A.Satoh Del - E
        )
        (if (not (equal (nth 7 #FIG$) (nth 5 #gsymxd$) 0.0001))
;-- 2011/10/31 A.Satoh Mod - S
;          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$))
					(progn
;-- 2011/12/19 A.Satoh Mod - S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;;-- 2011/11/28 A.Satoh Mod - S
;;;;;;;;;;						(if #STR_FLG
;;;;;;;;;;							(progn
;;;;;;;;;;								(setq CG_POS_STR nil)
;;;;;;;;;;							)
;;;;;						(if (= #STR_FLG nil)
;;;;;;-- 2011/11/28 A.Satoh Mod - E
;;;;;							(progn
;;;;;								(setq CG_POS_STR T)
;;;;;								(setq #STR_FLG T)
;;;;;								(setq CG_TOKU T)
;;;;;							)
;;;;;						)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;						(setq #eDelBRK_H$ (PcRemoveBreakLine #eNEW "H")) ; H方向ブレーク除去
;;;;;						(setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))
;;;;;						(CFSetXData #XLINE_H "G_BRK" (list 3))
;;;;;						;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
;;;;;						(command "-group" "A" #gnam #XLINE_H "")
;;;;;;-- 2011/11/28 A.Satoh Add - E
;;;;;    	      (setq CG_TOKU_BH #BrkH)
						(if #BrkH
							(progn
								(setq #eDelBRK_H$ (PcRemoveBreakLine #eNEW "H")) ; H方向ブレーク除去
								(setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))
								(CFSetXData #XLINE_H "G_BRK" (list 3))
								;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
								(command "-group" "A" #gnam #XLINE_H "")
    			      (setq CG_TOKU_BH #BrkH)
;-- 2012/02/16 A.Satoh Add CG対応 - S
								(setq #XLINE_H$ (list #BrkH nil))
;-- 2012/02/16 A.Satoh Add CG対応 - E
							)
;-- 2012/02/16 A.Satoh Add CG対応 - S
							(progn
								(setq #idx 0)
								(repeat (length #BrkLineH$)
									(if (> 2 #idx)
										(progn
											(setq #dist (PCSetItem_GetBreakLineDist (nth #idx #BrkLineH$) "H" #pt #ANG))
											(setq #XLINE_H$ (append #XLINE_H$ (list #dist)))
										)
									)
									(setq #idx (1+ #idx))
								)
							)
;-- 2012/02/16 A.Satoh Add CG対応 - E
						)
;-- 2011/12/19 A.Satoh Mod - E
;-- 2011/11/28 A.Satoh Del - S
;;;;;	          (setq CG_TOKU_BW nil)
;;;;;  	        (setq CG_TOKU_BD nil)
;-- 2011/11/28 A.Satoh Del - E

;-- 2012/02/22 A.Satoh Add - S
						(setq #H_f T)
;-- 2012/02/22 A.Satoh Add - S

						; 高さ方向伸縮処理
	          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$))

;-- 2011/12/19 A.Satoh Mod - S
;;;;;            ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
;;;;;            (entdel #XLINE_H)
;;;;;            ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
;;;;;            (foreach #eD #eDelBRK_H$
;;;;;              (if (= (entget #eD) nil) (entdel #eD)) ;H方向ブレーク復活
;;;;;            );for
;;;;;
						(if #BrkH
							(progn
		            ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
    		        (entdel #XLINE_H)
        		    ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
            		(foreach #eD #eDelBRK_H$
		              (if (= (entget #eD) nil) (entdel #eD)) ;H方向ブレーク復活
    		        )
							)
						)
;-- 2011/12/19 A.Satoh Mod - E
;-- 2011/11/28 A.Satoh Del - S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;			      (if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))
;;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/11/28 A.Satoh Del - E
					)
;-- 2011/12/19 A.Satoh Del - S
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;					(progn
;;;;;						(setq CG_BASE_UPPER nil)
;;;;;						(if (= #STR_FLG nil)
;;;;;							(progn
;;;;;								(setq CG_POS_STR T)
;;;;;								(setq #STR_FLG T)
;;;;;								(setq CG_TOKU T)
;;;;;							)
;;;;;						)
;;;;;    	      (setq CG_TOKU_BH #BrkH)
;;;;;					)
;;;;;;-- 2011/11/28 A.Satoh Add - E
;-- 2011/12/19 A.Satoh Del - E
;-- 2011/10/31 A.Satoh Mod - E
        )
        ;(SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$))
;-- 2011/12/19 A.Satoh Add - S
				(setq CG_BASE_UPPER nil)
;-- 2011/12/19 A.Satoh Add - E

;-- 2012/02/22 A.Satoh Add - S
				(setq #chk (list #W_f #D_f #H_f))
;-- 2012/02/22 A.Satoh Add - E

;-- 2012/02/16 A.Satoh Add CG対応 - S
				(if (= nil (tblsearch "APPID" "G_REG")) (regapp "G_REG"))
				(InputGRegData #eNEW #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ #chk nil nil)
;-- 2012/02/16 A.Satoh Add CG対応 - E
;-- 2012/02/17 A.Satoh Add CG対応 - S
				(setq CG_SizeH nil)
;-- 2012/02/17 A.Satoh Add CG対応 - E
      ))


      ; ⑤挿入モードの場合、DBとG_SYMの差分を補正
      ;   00/06/21MH ADD SelParts.cfgから伸縮作業を行う場合補正させない
;;;02/01/09YM@MOD      (if (and (wcmatch &sMODE "CNT,INS,CHG")
;;;02/01/09YM@MOD            (not (and (findfile (strcat CG_SYSPATH "SELPARTS.CFG"))
;;;02/01/09YM@MOD                      (< 0 (nth 11 (PcGetPartQLY$  "品番基本" #sHIN nil nil))); 入力ｺｰﾄﾞ
;;;02/01/09YM@MOD          ))); if条件

      (if (and (wcmatch &sMODE "CNT,INS,CHG")); if条件 伸縮作業に関わらず補正させる
        (progn
          ; 一般Ｗ方向 補正 ; "L" 方向挿入で、W値に差があった
          (if (and (= &sDIR "L")
            (/= 0 (setq #MOV (- (nth 5 #FIG$) (nth 3 (CFGetXData #eNEW "G_SYM")))))) ; W 同士比較
            (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS (Pcpolar #dINS #fANG #MOV))
          );if
          ; 隅用キャビ "R" 方向挿入で、D値に差があった 特殊処理
          (if (and (= (CFGetSymSKKCode #eNEW 3) CG_SKK_THR_CNR)
                   (= &sDIR "R")
                   (/= 0 (setq #MOV (- (nth 6 #FIG$) (nth 4 (CFGetXData #eNEW "G_SYM")))))) ; D 同士比較
            (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS
               (Pcpolar #dINS (- #fANG (dtr 90)) #MOV))
          ); if
        ); progn
      ); if

; 02/01/09 ⑤と⑥の順番を入れ替え ---------------------------------------------------------------------------

;-- 2011/11/28 A.Satoh Del - S
;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;			(if (= CG_TOKU nil)
;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/11/28 A.Satoh Del - E
      ; ⑦扉面処理
      (if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))
;-- 2011/11/28 A.Satoh Del - S
;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;			)
;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/11/28 A.Satoh Del - E

      ; ⑧H800の高さ調整処理
;;;01/01/12YM@      (if (and (= #flg "-1")
;;;01/01/12YM@            (or (and (= (CFGetSymSKKCode #eNEW 1) CG_SKK_ONE_CAB) ; ｷｬﾋﾞ
;;;01/01/12YM@                     (= (CFGetSymSKKCode #eNEW 2) CG_SKK_TWO_BAS)); ﾍﾞｰｽ
;;;01/01/12YM@                ;(wcmatch #sHIN "KH-S230P*");ﾄｰﾙ用ｽﾍﾟｰｻｰ
;;;01/01/12YM@            )   ;(wcmatch #sHIN "KB-F15AP*"));ﾌﾛｱ用ﾌｨﾗｰ
;;;01/01/12YM@          ); and
;;;01/01/12YM@        (progn
;;;01/01/12YM@          ; 00/08/29 SN MOD 下処理は850高さ対応で事前に行っているのでここではしない。
;;;01/01/12YM@          ; 00/08/22 MH ﾄｰﾙ用ｽﾍﾟｰｻｰのみ特殊処理 高さを2300にする（2248になるのを防ぐため）
;;;01/01/12YM@          ;(if (wcmatch #sHIN "KH-S230P*")
;;;01/01/12YM@          ;  (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) 2300))
;;;01/01/12YM@          (PcCabCutCall #eNEW) ; ｷｬﾋﾞﾈｯﾄの伸縮処理
;;;01/01/12YM@          ; "POS"のみ Z移動が必要。高さ設定が0以外だったときのため
;;;01/01/12YM@          (if (= &sMODE "POS")(progn
;;;01/01/12YM@            ;;; Z移動
;;;01/01/12YM@            (setq #ss_H800 (CFGetSameGroupSS #eNEW))   ; グループ全図形選択セット
;;;01/01/12YM@            (command "._MOVE" #ss_H800 "" "0,0,0" (strcat "0,0," (rtos #posZ)))
;;;01/01/12YM@            (setq #en_lis_#ss  (CMN_ss_to_en  #ss_H800)) ; 選択セット渡し図形名リスト得る
;;;01/01/12YM@            (SetG_LSYM1 #en_lis_#ss)  ; "G_LSYM"(挿入点)拡張データの変更
;;;01/01/12YM@            (SetG_PRIM1 #en_lis_#ss)  ; "G_PRIM" (取り付け高さ)拡張データの変更
;;;01/01/12YM@          ));if progn
;;;01/01/12YM@      )); if progn

;;;01/02/27YM@      ; 上基点でH方向伸縮のあったアイテムは伸縮分H方向に移動 01/02/02 MH ADD
;;;01/02/27YM@      (if (and (not (equal 0 #fHmov 0.1)) (= -1 (nth 10 (CFGetXData #eNEW "G_SYM"))))
;;;01/02/27YM@        (progn
;;;01/02/27YM@          ; 移動先点のZ値を取得
;;;01/02/27YM@          (setq #cntZ (- (caddr #dINS) #fHmov))
;;;01/02/27YM@          (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS
;;;01/02/27YM@            (list (car #dINS) (cadr #dINS) #cntZ))
;;;01/02/27YM@        ); progn
;;;01/02/27YM@      ); if

      ; "CNT" 縦方向の挿入であった場合、基準アイテムのH方向フラグと
      ;       挿入図形のH方向フラグで判断して挿入図形を移動させる (ガスコンロ以外)
      ; 01/06/17 HN S-MOD 配置図形がコンロ以外は通常にＺ値を取得するように判定を変更
      ;@MOD@(if (and (= &sMODE "CNT") (or (= &sDIR "T") (= &sDIR "D"))
      ;@MOD@  (/= (CFGetSymSKKCode CG_BASESYM 3) CG_SKK_THR_GAS))
      (if
        (and
          (= &sMODE "CNT")
          (or (= &sDIR "T") (= &sDIR "D"))
;;;          (/= CG_SKK_INT_GAS #sCd) ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
        )
      ; 01/06/17 HN E-MOD 配置図形がコンロ以外は通常にＺ値を取得するように判定を変更
        (progn
          (setq #B_Hflag (nth 10 (CFGetXData CG_BASESYM "G_SYM")));基準図形のH方向フラグ
          (setq #F_Hflag (nth 10 (CFGetXData #eNEW "G_SYM")));挿入図形のH方向フラグ
;;;01/05/31YM@          (setq #newH (fix (nth 7 #FIG$)))
          (setq #newH (nth 5 (CFGetXData #eNEW "G_SYM"))) ; ;01/05/31 YM

          (setq #basH (caddr #baseWDH$))
          ; 移動先点のZ値を取得
          (setq #cntZ
            (cond
              ((and (= &sDIR "T") (= 1 #B_Hflag) (= 1 #F_Hflag))
                (+ #basH (caddr #dINS))
              )
              ((and (= &sDIR "T") (= 1 #B_Hflag) (= -1 #F_Hflag))
                (+ #basH #newH (caddr #dINS))
              )
              ((and (= &sDIR "T") (= -1 #B_Hflag) (= 1 #F_Hflag))
                (caddr #dINS)
              )
              ((and (= &sDIR "T") (= -1 #B_Hflag) (= -1 #F_Hflag))
                (+ #newH (caddr #dINS))
              )
              ((and (= &sDIR "D") (= 1 #B_Hflag) (= 1 #F_Hflag))
                (- (caddr #dINS) #newH)
              )
              ((and (= &sDIR "D") (= 1 #B_Hflag) (= -1 #F_Hflag))
                (caddr #dINS)
              )
              ((and (= &sDIR "D") (= -1 #B_Hflag) (= 1 #F_Hflag))
                (- (caddr #dINS) #basH #newH)
              )
              ((and (= &sDIR "D") (= -1 #B_Hflag) (= -1 #F_Hflag))
                (- (caddr #dINS) #basH)
              )
            ); end of cond
          ); end of setq
          ; 移動実行
          (if (not (equal (caddr #dINS) #cntZ 0.0001))
            (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS
              (list (car #dINS) (cadr #dINS) #cntZ))
          ); end of if
        ); end of progn
      ); end of if

      ; ⑨周辺図形移動
      (cond
        ((and (= &sMODE "CNT") (or (= &sDIR "R") (= &sDIR "L")))
          ;00/09/25 SN MOD 連続ﾓｰﾄﾞの左右はｱｲﾃﾑの移動はせず、隣のｱｲﾃﾑに重ねる。
          ;(PcMoveItemAround "CNT" #eNEW #eBASE #sDIR (nth 3 (CFGetXData #eNEW "G_SYM")) nil)
        )
        ((= &sMODE "INS")
          (KcMoveItemAround_INS #eNEW #eBASE &sDIR (nth 3 (CFGetXData #eNEW "G_SYM")))
;;;       (PcMoveItemAround "INS" #eNEW #eBASE #type (nth 3 (CFGetXData #eNEW "G_SYM")) nil) ; 挿入側指示YM
        )
        ((= &sMODE "CHG")
          (if (/= 0 (setq #fMOVE (- (nth 3 (CFGetXData #eNEW "G_SYM")) (car #chgWDH$))))
            (progn
;-- 2011/12/08 A.Satoh Add - S
							(if (= CG_REGULAR nil)
								(progn
;-- 2011/12/08 A.Satoh Add - E
              ; 01/01/29 YM ADD
              (initget "L R") ; 01/03/14 YM
              (setq #type (getkword "\n移動側を入力 [左(L)/右(R)] <移動なし>:  ")); ﾃﾞﾌｫﾙﾄEnter 01/03/14 YM
;-- 2011/12/08 A.Satoh Add - S
								)
								(setq #type nil)
							)
;-- 2011/12/08 A.Satoh Add - E


              (command "_change" #ss "" "P" "C" "BYLAYER" "") ; ここで色を戻す
    ;;;         (if (> #fMOVE 0)
    ;;;           (setq #type (getkword "\n移動側を入力 /L=左/R=右/:  "))
    ;;;           (setq #type (getkword "\n移動側を入力 /L=左/R=右/:  "))
    ;;;         );_if
              ; 01/01/29 YM ADD

              ; 新図形,元図形,移動方向,移動量
              (if #type
                (KcMoveItemAround_CHG #eNEW &eCHG #type #fMOVE) ; 01/02/05 YM MOD
                (command "_erase" (CFGetSameGroupSS &eCHG) "")  ; 元図形削除実行 01/03/14 YM
              );_if
    ;;;          (PcMoveItemAround "CHG" #eNEW nil "R" #fMOVE #eNEXT$) ; 01/02/05 YM MOD
            )
            (progn
              ;;; 元図形削除実行
              (command "_erase" (CFGetSameGroupSS &eCHG) "") ; 元図形 &eCHG
              (command "_change" #ss "" "P" "C" "BYLAYER" "") ; ここで色を戻す
            )
          );_if
        )
        (t nil)
      ); cond

      ; ⑩拡張ﾃﾞｰﾀ "G_OPT" セット
      (KcSetG_OPT #eNEW)

      ; ⑪基準アイテム移行
(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
	(progn ;2017/09/12 YM ADD
		(setq CG_SKK_ONE_CNT 0) ;一時的にｶｳﾝﾀｰ性格ｺｰﾄﾞ変更 7==>0
	)
);_if

      (if (or ; 01/06/18 YM ADD 基準ｱｲﾃﾑ移行しない--水栓も追加
            (and (wcmatch &sMODE "POS,CHG")
                 (or (not (CFGetBaseSymXRec))(not (entget (CFGetBaseSymXRec))))
                     (and (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_GAS)
                          (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_WTR)
                          (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_CNT) ; 01/08/22 YM ADD ｶｳﾝﾀｰ追加
                          (/= CG_SKK_INT_SAK (nth 8 #FIG$))) ; 02/05/31 HN ADD 食器洗い乾燥機
            ); and
            ; 連続モードで新図形がコンロ以外だった
            (and (= &sMODE "CNT")
                     (and (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_GAS)
                          (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_WTR)
                          (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_CNT) ; 01/08/22 YM ADD ｶｳﾝﾀｰ追加
                          (/= CG_SKK_INT_SAK (nth 8 #FIG$))) ; 02/05/31 HN ADD 食器洗い乾燥機
            ); and
          ); or
        (progn
          (ResetBaseSym) ; 基準ｱｲﾃﾑｼﾝﾎﾞﾙがあれば色を元に戻す
          (CFSetBaseSymXRec #eNEW) ; XRecordに基準アイテムシンボル図形名を設定する
          (GroupInSolidChgCol #eNEW CG_BaseSymCol) ; 色をつける
      )); if progn


(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
	(progn ;2017/09/12 YM ADD
		(setq CG_SKK_ONE_CNT 7) ;一時的にｶｳﾝﾀｰ性格ｺｰﾄﾞ変更
	)
);_if

    ; 01/04/06 MH ADD 新アイテム中の側面図移動が必要かどうか判定して実行 (コンロ)
    (KcMoveToSGCabinet #eNEW)

    (command "_.layer" "F" "Z_01*" "")

    ; 02/11/18 YM ADD-S
    (command "_layer" "F" "Y_00*" "")   ; ﾌﾘｰｽﾞ
    (command "_layer" "OFF" "Y_00*" "") ; 非表示
    ; 02/11/18 YM ADD-E

    ;// Ｏスナップ関連システム変数を元に戻す
    (CFNoSnapEnd)

;-- 2011/11/09 A.Satoh Add - S
		; グローバル変数を元に戻す
		(setq CG_BASE_UPPER nil)
		(setq CG_TOKU_BW nil)
		(setq CG_TOKU_BD nil)
		(setq CG_TOKU_BH nil)
;-- 2011/11/09 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
		(setq CG_POS_STR nil)
		(setq CG_TOKU nil)
;-- 2011/11/24 A.Satoh Add - E

    (if (= &sMODE "POS")
      (progn
        (command "_.layer" "F" "Z_*" "")
        (command "_.layer" "T" "Z_00*" "")
        (command "_.layer" "T" "Z_KUTAI" "") ; 01/02/20 YM ADD
        (setvar "ELEVATION" #elv) ; 元の高さに戻す 05/30 MH ADD
      )
    ); if progn
  )); if progn "CHG"モード の条件以外

  #eNEW ; 図形名を返す
) ;PcSetItem


;-- 2011/12/17 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : PCSetItem_CheckBreakLineExist
; <処理概要>  : 指定された方向のブレークライン図形を求める
; <戻り値>    : ブレークライン図形リスト or nil
; <作成>      : 11/12/17 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun PCSetItem_CheckBreakLineExist (
	&eEN          ; 図形名
	&sFLG         ; 存在チェックを行うブレークラインの種類 "H" "W" "D"
	&pt						; シンボル基点
	&ang					; 配置角度（ラジアン）
	/
	#ret$ #BrkW$ #BrkD$ #BrkH$ #group$$ #group$ #Temp$
	)

	(setq #BrkW$ nil)
	(setq #BrkD$ nil)
	(setq #BrkH$ nil)
	(setq #ret$ nl)

	(if (= 'ENAME (type &eEN))
		(progn
			(setq #group$$ (entget (cdr (assoc 330 (entget &eEN)))))
			(foreach #group$ #group$$
				;; グループ構成図形がブレークラインかどうかのチェック
				(if (and (= (car #group$) 340)
								 (= (cdr (assoc 0 (entget (cdr #group$)))) "XLINE")
								 (setq #Temp$ (CFGetXData (cdr #group$) "G_BRK")))
					(cond
						((= (nth 0 #Temp$) 1) ; W 方向ブレークライン
							(setq #BrkW$ (cons (cdr #group$) #BrkW$))
						)
						((= (nth 0 #Temp$) 2) ; D 方向ブレークライン
							(setq #BrkD$ (cons (cdr #group$) #BrkD$))
						)
						((= (nth 0 #Temp$) 3) ; H 方向ブレークライン
							(setq #BrkH$ (cons (cdr #group$) #BrkH$))
						)
					)
				)
			)

			(cond
				((= "W" &sFLG)
					(setq #ret$ #BrkW$)
				)
	      ((= "D" &sFLG)
					(setq #ret$ #BrkD$)
				)
	      ((= "H" &sFLG)
					(setq #ret$ #BrkH$)
				)
				(T
					(setq #ret$ nil)
				)
			)
		)
	)

	#ret$

) ;PCSetItem_CheckBreakLineExist
;-- 2011/12/17 A.Satoh Add - E


;-- 2012/02/16 A.Satoh Add CG対応 - S
;<HOM>*************************************************************************
; <関数名>    : PCSetItem_GetBreakLineDist
; <処理概要>  : 指定されたブレークラインの位置(基点からの距離)を求める
; <戻り値>    : ブレークライン位置
; <作成>      : 12/02/16 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun PCSetItem_GetBreakLineDist (
	&eEN          ; ブレークラインの図形名
	&sFLG         ; 存在チェックを行うブレークラインの種類 "H" "W" "D"
	&pt$					; シンボル基点
	&ang					; 配置角度（ラジアン）
	/
	#pnt$ #ang #base_pnt$ #bl_pnt$ #dist
	)

	; ブレークライン図形の頂点を取得
	(setq #pnt$ (cdr (assoc 10 (entget &eEN))))

	; ラジアンを角度に変換
	(setq #ang (fix (rtd &ang)))

	; 視点の向きを変更
	(if (= &sFLG "D")
		(progn
			(cond
				((= #ang 90)
					(C:ChgViewBack)
				)
				((= #ang 180)
					(C:ChgViewSideL)
				)
				((= #ang 270)
					(C:ChgViewFront)
				)
				(T
					(C:ChgViewSideR)
				)
			)
		)
		(progn
			(cond
				((= #ang 90)
					(C:ChgViewSideR)
				)
				((= #ang 180)
					(C:ChgViewBack)
				)
				((= #ang 270)
					(C:ChgViewSideL)
				)
				(T
					(C:ChgViewFront)
				)
			)
		)
	)

	; 視点の向きに合せ、座標系を変更
	(command "_.UCS" "V")

	; 座標変換 WCS ⇒ UCS
	(setq #base_pnt$ (trans &pt$ 0 1))  ; シンボル基点
	(setq #bl_pnt$   (trans #pnt$ 0 1)) ; ブレークライン基点

	(cond
		((= "W" &sFLG)
			(setq #dist (abs (fix (- (car #bl_pnt$) (car #base_pnt$)))))
		)
	  ((= "D" &sFLG)
			(setq #dist (abs (fix (- (car #bl_pnt$) (car #base_pnt$)))))
		)
	  ((= "H" &sFLG)
			(setq #dist (abs (fix (- (cadr #bl_pnt$) (cadr #base_pnt$)))))
		)
		(T
			(setq #dist 0)
		)
	)

	; 視点を戻す
	(command "_.UCS" "W")
	(command "_zoom" "P")

	#dist

) ;PCSetItem_GetBreakLineDist
;-- 2012/02/16 A.Satoh Add CG対応 - E


;<HOM>*************************************************************************
; <関数名>    : PcMoveItemAround
; <処理概要>  : 領域と方向指示による周囲の図形の移動
; <戻り値>    : なし
; <作成>      : 00/07/06 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcMoveItemAround (
    &sMODE    ; "CNT" "INS" "CHG" "DEL" 使用元の関数フラグ
    &eNEW     ; 新設アイテム("DEL" の場合、消去するアイテムが入る)
    &eBASE    ; 基準アイテム("DEL" の場合 nil)
    &fDIR     ; 連続配置タイプ　"L"左、"R"右
    &fMOV     ; 移動量
    &eNEXT$   ; "CHG"用リスト。"CHG"以外はnil
    /
    #osmode #snapmode #XLD$ #WTflg #ss #eNEXT$ #TEMP$ #eNT #eADD$ #eNEXT$
    #fANG #dMOV #i #ss2 #EN
  )
  ;// Ｏスナップ関連システム変数の除
  ;CFNoSnapStartは外部変数に値を確保する為二重呼び出で元の値が狂う。処理は内部で行う
  (setq #osmode   (getvar "OSMODE"))   ;00/07/21 SN ADD
  (setq #snapmode (getvar "SNAPMODE")) ;00/07/21 SN ADD
  (setvar "OSMODE"   0)                ;00/07/21 SN MOD
  (setvar "SNAPMODE" 0)                ;00/07/21 SN MOD

  (setq #XLD$ (CFGetXData &eNEW "G_LSYM"))

  ; 移動対象範囲の全図形取得
  ; SN ADD ﾄｰﾙ用ｽﾍﾟｰｻの時はﾜｰｸﾄｯﾌﾟも選択ｾｯﾄに加算00/07/24
  (setq #WTflg nil);(if (wcmatch (nth 5 #XLD$) "KH-S230P*") 'T nil))
  (setq #ss (PcGetSSAroundItem &sMODE &eNEW &fDIR &fMOV #WTflg))

  ; 対象図形の隣接図形を取得
  (setq #eNEXT$ (if (not &eNEXT$) (PcGetNextMoveItem$ &eNEW nil) (cons &eNEW &eNEXT$)))

  (cond
    ; 連続モード  基準図形と新図形は移動しないので#ss #eNEXT$ から抜く
    ((= &sMODE "CNT")
      (if (and #ss (/= (sslength #ss) 0)) (ssdel &eBASE #ss))
      (if (and #ss (/= (sslength #ss) 0)) (ssdel &eNEW #ss))
      (setq #TEMP$ nil)
      (foreach #eNT #eNEXT$
        (if (and (not (equal #eNT &eNEW)) (not (equal #eNT &eBASE)))
          (setq #TEMP$ (cons #eNT #TEMP$))
        );_if
      )
      (setq #eNEXT$ #TEMP$)
    )
    ; 挿入モード 基準図形と新図形は移動するのでない場合 #ss #eNEXT$ に追加
    ((= &sMODE "INS")
      (if (not #ss) (setq #ss (ssadd)))
      (ssadd &eBASE #ss)
      (ssadd &eNEW #ss)
      (if (not (member &eBASE #eNEXT$)) (setq #eNEXT$ (cons &eBASE #eNEXT$)))
      (setq #eNEXT$ (cons &eNEW #eNEXT$))
    )
  ); cond

  ; 範囲全図形のなかから#eNEXT$の各アイテムと同範囲 同高さのものを選択
  (setq #eADD$ (PcGetSameAreaItem$ #ss #eNEXT$))
  (setq #eNEXT$ (append #eADD$ #eNEXT$)) ; 隣接名リストに追加
  (if (and #ss (/= (sslength #ss) 0)) (progn
    (command "_zoom" "e");; ZOOM
    (setq #fANG (nth 2 #XLD$))
    (if (= &fDIR "L") (setq #fANG (+ pi #fANG)))
    (setq #dMOV (Pcpolar '(0 0 0) #fANG &fMOV)) ;移動先点
    ; 削除モードの際は&eNEW（削除図形）が移動する
    (if (or (= &sMODE "INS")(= &sMODE "DEL")) (ssadd &eNEW #ss) (ssdel &eNEW #ss))
    (if (and #ss (/= (sslength #ss) 0))(progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        ; 隣接図形リストと共通のものだけを移動
        (if (member #en #eNEXT$)
          (progn
            (setq #ss2 (CFGetSameGroupSS (ssname #ss #i)))
            (command "_move" #ss2 "" '(0 0 0) #dMOV)
          ); progn
          ;00/07/24 SN ADD ﾜｰｸﾄｯﾌﾟの時はそのまま移動(ﾄｰﾙ用ｽﾍﾟｰｻの時のみﾜｰｸﾄｯﾌﾌﾟ有)
          (if (CFGetXData #en "G_WRKT")
            (command "_move" #en "" '(0 0 0) #dMOV)
          ); if
        ); if
        (setq #i (1+ #i))
      ); repeat
      ;00/07/27 SN ADD 基準ｱｲﾃﾑが存在する場合は基準ｱｲﾃﾑを再表示
      (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
        (progn
          (setq CG_BASESYM (CFGetBaseSymXRec))
          (ResetBaseSym)
          (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
        ); progn
        (setq CG_BASESYM nil)
      )
     )); if progn
     (command "_zoom" "p");; ZOOM
   )); if progn
  ;// Ｏスナップ関連システム変数を元に戻す
  ;CFNoSnapStartは外部変数に値を確保する為二重呼び出で元の値が狂う。処理は内部で行う
  (setvar "OSMODE"   #osmode)          ;00/07/21 SN ADD
  (setvar "SNAPMODE" #snapmode)        ;00/07/21 SN ADD
) ;PcMoveItemAround

;<HOM>*************************************************************************
; <関数名>    : KcMoveItemAround_INS
; <処理概要>  : 領域と方向指示による周囲の図形の移動(挿入専用)
; <戻り値>    : なし
; <作成>      : 01/01/29 YM "INS" 専用
; <備考>      :
;*************************************************************************>MOH<
(defun KcMoveItemAround_INS (
  &eNEW     ; 新設アイテム
  &eBASE    ; 基準アイテム
  &fDIR     ; 連続配置タイプ　"L"左、"R"右
  &fMOV     ; 移動量
  /
  #DMOV #EADD$ #EN #ENEXT$ #FANG #I #OSMODE #SNAPMODE #SS #SS2 #TEMP$ #XLD$
  )
  ;// Ｏスナップ関連システム変数の除
  ;CFNoSnapStartは外部変数に値を確保する為二重呼び出で元の値が狂う。処理は内部で行う
  (setq #osmode   (getvar "OSMODE"))   ;00/07/21 SN ADD
  (setq #snapmode (getvar "SNAPMODE")) ;00/07/21 SN ADD
  (setvar "OSMODE"   0)                ;00/07/21 SN MOD
  (setvar "SNAPMODE" 0)                ;00/07/21 SN MOD

  (setq #XLD$ (CFGetXData &eNEW "G_LSYM"))

  ; 移動対象範囲の全図形取得
  (setq #ss (KcGetSSAroundItem_INS &eNEW &fDIR &fMOV))
  ; 対象図形の隣接図形を取得
  (setq #eNEXT$ (PcGetNextMoveItem$ &eNEW nil))

;;;    ; 連続モード  基準図形と新図形は移動しないので#ss #eNEXT$ から抜く
;;;    ((= &sMODE "CNT")
  (if (and #ss (/= (sslength #ss) 0))
    (progn
      (ssdel &eBASE #ss)
      (ssdel &eNEW #ss)
    )
  );_if

  (setq #TEMP$ nil)
  (foreach #eNT #eNEXT$
    (if (and (not (equal #eNT &eNEW)) (not (equal #eNT &eBASE)))
      (setq #TEMP$ (cons #eNT #TEMP$))
    )
  )
  (setq #eNEXT$ #TEMP$)

  ; 範囲全図形のなかから#eNEXT$の各アイテムと同範囲 同高さのものを選択
  (setq #eADD$ (PcGetSameAreaItem$ #ss #eNEXT$))
  (setq #eNEXT$ (append #eADD$ #eNEXT$)) ; 隣接名リストに追加
  (if (and #ss (/= (sslength #ss) 0))
    (progn
      (command "_zoom" "e");; ZOOM
      (setq #fANG (nth 2 #XLD$))
      (if (= &fDIR "L") (setq #fANG (+ pi #fANG)))
      (setq #dMOV (Pcpolar '(0 0 0) #fANG &fMOV)) ;移動先点

      (if (and #ss (/= (sslength #ss) 0))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            ; 隣接図形リストと共通のものだけを移動
            (if (member #en #eNEXT$)
              (progn
                (setq #ss2 (CFGetSameGroupSS (ssname #ss #i)))
                (command "_move" #ss2 "" '(0 0 0) #dMOV)
              ); progn
              ;00/07/24 SN ADD ﾜｰｸﾄｯﾌﾟの時はそのまま移動(ﾄｰﾙ用ｽﾍﾟｰｻの時のみﾜｰｸﾄｯﾌﾌﾟ有)
              (if (CFGetXData #en "G_WRKT")
                (command "_move" #en "" '(0 0 0) #dMOV)
              ); if
            ); if
            (setq #i (1+ #i))
          ); repeat
          ;00/07/27 SN ADD 基準ｱｲﾃﾑが存在する場合は基準ｱｲﾃﾑを再表示
          (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
            (progn
              (setq CG_BASESYM (CFGetBaseSymXRec))
              (ResetBaseSym)
              (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
            ); progn
            (setq CG_BASESYM nil)
          );_if
        )
      ); if
      (command "_zoom" "p");; ZOOM
    )
  ); if
  ;// Ｏスナップ関連システム変数を元に戻す
  ;CFNoSnapStartは外部変数に値を確保する為二重呼び出で元の値が狂う。処理は内部で行う
  (setvar "OSMODE"   #osmode)          ;00/07/21 SN ADD
  (setvar "SNAPMODE" #snapmode)        ;00/07/21 SN ADD
) ;KcMoveItemAround_INS

;<HOM>*************************************************************************
; <関数名>    : KcMoveItemAround_CHG
; <処理概要>  : 領域と方向指示による周囲の図形の移動(入替専用)
; <戻り値>    : なし
; <作成>      : 01/01/29 YM "CHG" 専用
; <備考>      : (KcMoveItemAround_CHG #eNEW #type #fMOVE)
;*************************************************************************>MOH<
(defun KcMoveItemAround_CHG (
  &eNEW     ; 新設アイテム
  &eCHG     ; 削除した元図形
  &fDIR     ; 連続配置タイプ　"L"左、"R"右
  &fMOV     ; 移動量
  /
  #DMOV #EADD$ #EN #ENEXT$ #FANG #I #OSMODE #SNAPMODE #SS #SS2 #TEMP$ #XLD$
  #DEL_flg #MOV_flg #OLD_FLG #RET$
  )
  ;// Ｏスナップ関連システム変数の除
  ;CFNoSnapStartは外部変数に値を確保する為二重呼び出で元の値が狂う。処理は内部で行う
  (setq #osmode   (getvar "OSMODE"))   ;00/07/21 SN ADD
  (setq #snapmode (getvar "SNAPMODE")) ;00/07/21 SN ADD
  (setvar "OSMODE"   0)                ;00/07/21 SN MOD
  (setvar "SNAPMODE" 0)                ;00/07/21 SN MOD

  (setq #XLD$ (CFGetXData &eNEW "G_LSYM"))

  ; 移動対象範囲の全図形取得
  (setq #ret$ (KcGetSSAroundItem_CHG &eNEW &fDIR &fMOV))
  (setq #ss      (nth 0 #ret$))
  (setq #DEL_flg (nth 1 #ret$)) ; #DEL_flg = 'T ==>挿入図形も移動
  (setq #MOV_flg (nth 2 #ret$)) ; #DEL_flg = 'T ==>移動距離にマイナスをつける
  (setq #OLD_flg (nth 3 #ret$))
  ; 対象図形の隣接図形を取得
  ; &eCHG 削除した元図形を参照する
  (setq #eNEXT$ (PcGetNextMoveItem$ &eCHG nil)) ; 入替え後ｷｬﾋﾞが元より小さい場合
  ;;; 元図形削除実行
  (command "_erase" (CFGetSameGroupSS &eCHG) "") ; 元図形 &eCHG
  (if (and #ss (> (sslength #ss) 0))(ssdel &eCHG #ss)) ; 01/02/13 YM ADD
  (setq #TEMP$ nil)
  (foreach #eNT #eNEXT$ ; 01/02/13 YM ADD
    (if (equal #eNT &eCHG)
      nil
      (setq #TEMP$ (cons #eNT #TEMP$))
    )
  )
  (setq #eNEXT$ #TEMP$)

  (if #DEL_flg ; #DEL_flg = 'T ==>新図形は移動しないので#ss #eNEXT$ から抜く
    (progn
      (if (and #ss (/= (sslength #ss) 0))
        (ssdel &eNEW #ss)
      );_if

      (setq #TEMP$ nil)
      (foreach #eNT #eNEXT$
        (if (equal #eNT &eNEW)
          nil
          (setq #TEMP$ (cons #eNT #TEMP$))
        )
      )
      (setq #eNEXT$ #TEMP$)
    )
  );_if

  ; 範囲全図形のなかから#eNEXT$の各アイテムと同範囲 同高さのものを選択
  (setq #eADD$ (PcGetSameAreaItem$ #ss #eNEXT$))

  (setq #eNEXT$ (append #eADD$ #eNEXT$)) ; 隣接名リストに追加
  (if (and #ss (/= (sslength #ss) 0))
    (progn
      (command "_zoom" "e");; ZOOM
      (setq #fANG (nth 2 #XLD$))
      (if (= &fDIR "L") (setq #fANG (+ pi #fANG)))
      (if #MOV_flg
        (setq #dMOV (Pcpolar '(0 0 0) #fANG (- &fMOV))) ;移動先点
        (setq #dMOV (Pcpolar '(0 0 0) #fANG &fMOV)) ;移動先点
      );_if
      (if (and #ss (/= (sslength #ss) 0))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            ; 隣接図形リストと共通のものだけを移動
            (if (member #en #eNEXT$)
              (progn
                (setq #ss2 (CFGetSameGroupSS (ssname #ss #i)))
                (command "_move" #ss2 "" '(0 0 0) #dMOV)
              ); progn
              ;00/07/24 SN ADD ﾜｰｸﾄｯﾌﾟの時はそのまま移動(ﾄｰﾙ用ｽﾍﾟｰｻの時のみﾜｰｸﾄｯﾌﾌﾟ有)
              (if (CFGetXData #en "G_WRKT")
                (command "_move" #en "" '(0 0 0) #dMOV)
              ); if
            ); if
            (setq #i (1+ #i))
          ); repeat
          ;00/07/27 SN ADD 基準ｱｲﾃﾑが存在する場合は基準ｱｲﾃﾑを再表示
          (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
            (progn
              (setq CG_BASESYM (CFGetBaseSymXRec))
              (ResetBaseSym)
              (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
            ); progn
            (setq CG_BASESYM nil)
          );_if
        )
      ); if
      (command "_zoom" "p");; ZOOM
    )
  ); if

  ;// Ｏスナップ関連システム変数を元に戻す
  ;CFNoSnapStartは外部変数に値を確保する為二重呼び出で元の値が狂う。処理は内部で行う
  (setvar "OSMODE"   #osmode)          ;00/07/21 SN ADD
  (setvar "SNAPMODE" #snapmode)        ;00/07/21 SN ADD
) ;KcMoveItemAround_CHG

;<HOM>*************************************************************************
; <関数名>    : PcMakeItemSpaceAround
; <処理概要>  : 基準アイテム周囲の図形を移動させ、図形配置のスペースをつくる
; <戻り値>    : なし
; <作成>      : 00/08/22 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcMakeItemSpaceAround (
    &sMODE    ; "CNT" "INS" 使用元の関数フラグ
    &eBASE    ; 基準アイテム
    &iAREA$   ; 移動させるアイテム高さ指示リスト例= '(CG_SKK_TWO_BAS CG_SKK_TWO_UPP)
    &fDIR     ; 移動方向　"L"左、"R"右
    &fMOV     ; 移動量
    &WTflg    ; ワークトップも動かすか？ nil か T
    /
    #osmode #snapmode #fDIR #ss #eNEXT$ #TEMP$ #eNT #eADD$ #fANG #dMOV #i #en #ss2
  )

  ;;; Ｏスナップ関連システム変数解除
  (setq #osmode   (getvar "OSMODE"))
  (setq #snapmode (getvar "SNAPMODE"))
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)
  ;;; 挿入モードと、変更モードは、周辺移動は"R"決めうち
  (setq #fDIR &fDIR)
  (if (or (= &sMODE "INS")(= &sMODE "CHG")) (setq #fDIR "R"))

  ; 移動対象範囲の全図形取得
  (setq #ss (PcGetSSAroundItem &sMODE &eBASE #fDIR  &fMOV &WTflg))

  ; 対象図形の隣接図形を取得
  (setq #eNEXT$ (PcGetNextMoveItem$ &eBASE &iAREA$))

  (cond
    ; 連続モードと設置モード 基準図形は移動しないので#ss #eNEXT$ から抜いておく
    ((or (= &sMODE "POS") (= &sMODE "CNT"))
      (if (and #ss (/= (sslength #ss) 0)) (ssdel &eBASE #ss))
      (setq #TEMP$ nil)
      (foreach #eNT #eNEXT$ (if (/= #eNT &eBASE) (setq #TEMP$ (cons #eNT #TEMP$))))
      (setq #eNEXT$ #TEMP$)
    )
    ; 挿入モードの場合、基準図形は移動するので無い場合 #ss #eNEXT$ に追加
    ((= &sMODE "INS")
      (if (not #ss) (setq #ss (ssadd)))
      (ssadd &eBASE #ss)
      (if (not (member &eBASE #eNEXT$)) (setq #eNEXT$ (cons &eBASE #eNEXT$)))
    )
  ); cond

  ; 範囲全図形のなかから#eNEXT$の各アイテムと同範囲 同高さのものを選択
  (setq #eADD$ (PcGetSameAreaItem$ #ss #eNEXT$))
  (setq #eNEXT$ (append #eADD$ #eNEXT$)) ; 隣接名リストに追加

  (if (and #ss (/= (sslength #ss) 0)) (progn
    (command "_zoom" "e");; ZOOM
    (setq #fANG (nth 2 (CFGetXData &eBASE "G_LSYM")))
    (if (= #fDIR "L") (setq #fANG (+ pi #fANG)))
    (setq #dMOV (Pcpolar '(0 0 0) #fANG &fMOV)) ;移動先点
    (if (and #ss (/= (sslength #ss) 0))(progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        ; 隣接図形リストと共通のものだけを移動
        (if (member #en #eNEXT$)
          (progn
            (setq #ss2 (CFGetSameGroupSS (ssname #ss #i)))
            (command "_move" #ss2 "" '(0 0 0) #dMOV)
          ); progn
          ; ﾜｰｸﾄｯﾌﾟの時はそのまま移動
          (if (CFGetXData #en "G_WRKT")
            (command "_move" #en "" '(0 0 0) #dMOV)
          ); if
        ); if
        (setq #i (1+ #i))
      ); repeat
      ;00/07/27 SN ADD 基準ｱｲﾃﾑが存在する場合は基準ｱｲﾃﾑを再表示
      (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
        (progn
          (setq CG_BASESYM (CFGetBaseSymXRec))
          (ResetBaseSym)
          (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
        ); progn
        (setq CG_BASESYM nil)
      )
     )); if progn
     (command "_zoom" "p");; ZOOM
   )); if progn

  ; Ｏスナップ関連システム変数を元に戻す
  (setvar "OSMODE"   #osmode)
  (setvar "SNAPMODE" #snapmode)
) ;PcMakeItemSpaceAround

;<HOM>*************************************************************************
; <関数名>    : PcGetSSAroundItem
; <処理概要>  : 基準アイテム周囲の移動対象範囲の全図形取得
; <戻り値>    : 選択セットか nil
; <作成>      : 00/08/22 MH
; <備考>      : &WTflg が T なら範囲中のワークトップも取得
;*************************************************************************>MOH<
(defun PcGetSSAroundItem (
    &sMODE    ; "CNT" "INS" "CHG" "DEL" 使用元の関数フラグ
    &eITEM    ; 基準とするアイテム
    &fDIR     ; 移動方向　"L" "R"
    &fMOV     ; 移動量("CHG"モードのみ使用)
    &WTflg    ; 範囲中のワークトップも獲得するか？
    /
    #fDIR #dP #xd$ #W #D #H #ang #dAREA #fANG #p1 #p2 #p3 #p4 #ss #wss #i
  )
  ;;; 挿入モードと、変更モードは、周辺移動は"R"決めうち
  (setq #fDIR &fDIR)
  (if (or (= &sMODE "INS")(= &sMODE "CHG")) (setq #fDIR "R"))

  (setq #dP (cdr (assoc 10 (entget &eITEM))))
  (setq #xd$ (CFGetXData &eITEM "G_SYM"))
  (setq #W (nth 3 #xd$))
  (setq #D (nth 4 #xd$))
  (setq #H (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &eITEM "G_LSYM")))

  ;;; 移動させる図形の範囲を示す4点を求める
  (setq #dAREA
    (cond
      ((= &sMODE "INS") (Pcpolar #dP #ang #W))
      ((= &sMODE "CHG") (Pcpolar #dP #ang (- #W &fMOV)))
      ; 少し戻してやらないと余分なアイテムまで選択セットに含まれる
      ((= #fDIR "L") (Pcpolar #dP #ang (- #W 5)))
      (t #dP)
  )); setq cond
  (setq #fANG (if (= #fDIR "L") (+ pi #ang) #ang))
  (setq #p1 (polar #dAREA (+ #ang (* 0.5 pi)) 150))
  (setq #p2 (polar #dAREA (+ #ang (* -0.5 pi)) (+ 150 #D)))
  (setq #p3 (polar #p2 #fANG 5000))
  (setq #p4 (polar #p1 #fANG 5000))
  ; 範囲チェック用↓
  ;(command "_PLINE" #p1 #p2 #p3 #p4 "c")
  ;(command "_change" (entlast) "" "P" "C" "CYAN" "")

  (setvar "PICKSTYLE" 0)
  ; 移動対象範囲の全図形取得
  (setq #ss (PcGetAllItemBetween2Pnt (list #p1 #p2 #p3 #p4)))
  (setq #ss (PcGetRidOfSink #ss)); 範囲中のシンクを除去 01/03/08 MH ADD
  ; フラグをみて範囲内ワークトップ加える
  (if &WTflg (progn
    (setq #wss (PcGetAllItemBetween2PntWT (list #p1 #p2 #p3 #p4)))
    (if (and #wss (> (sslength #wss) 0)) (progn
      (setq #i 0)
      (repeat (sslength #wss)
        (ssadd (ssname #wss #i) #ss)
        (setq #i (1+ #i))
      ); repeat
    ));if progn
  ));if progn
  #ss
) ;PcGetSSAroundItem

;<HOM>*************************************************************************
; <関数名>    : KcGetSSAroundItem_INS
; <処理概要>  : 基準アイテム周囲の移動対象範囲の全図形取得
; <戻り値>    : 選択セットか nil
; <作成>      : 00/08/22 MH 01/01/29 YM 改造
; <備考>      :
;*************************************************************************>MOH<
(defun KcGetSSAroundItem_INS (
  &eITEM    ; 基準とするアイテム
  &fDIR     ; 移動方向　"L" "R"
  &fMOV     ; 移動量
  /
  #fDIR #dP #xd$ #W #D #H #ang #dAREA #fANG #p1 #p2 #p3 #p4 #ss #wss #i
  #PP1 #PP2
  )
  (setq #fDIR &fDIR)
  (setq #xd$ (CFGetXData &eITEM "G_SYM"))
  (setq #W (nth 3 #xd$))
  (setq #D (nth 4 #xd$))
  (setq #H (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &eITEM "G_LSYM")))

  ;;; 移動させる図形の範囲を示す4点を求める
  (setq #pp1 (cdr (assoc 10 (entget &eITEM))))
  (setq #pp2 (Pcpolar #pp1 #ang #W))

  (cond
    ((= #fDIR "L")
      (setq #fANG (+ pi #ang))
      (setq #p1 (polar #pp2 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp2 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
    )
    ((= #fDIR "R")
      (setq #fANG #ang)
      (setq #p1 (polar #pp1 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp1 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
    )
  );_cond

  ; 範囲チェック用↓
;;;(command "_PLINE" #p1 #p2 #p3 #p4 "c")
;;;(command "_change" (entlast) "" "P" "C" "CYAN" "")

  (setvar "PICKSTYLE" 0)
  ; 移動対象範囲の全図形取得
  (setq #ss (PcGetAllItemBetween2Pnt (list #p1 #p2 #p3 #p4)))
  (setq #ss (PcGetRidOfSink #ss)); 範囲中のシンクを除去 01/03/08 MH ADD
  #ss
);KcGetSSAroundItem_INS

;<HOM>*************************************************************************
; <関数名>    : PcGetRidOfSink
; <処理概要>  : 選択セットからシンク図形と水栓を除く
; <戻り値>    : 選択セット
; <作成>      : 01/03/08 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcGetRidOfSink ( &SS / #i #skk #resSS)
  (setq #i 0)
  (setq #resSS (ssadd))
  (repeat (sslength &SS)
    (setq #skk (fix (nth 9 (CFGetXData (ssname &SS #i) "G_LSYM"))))
    (if (not (or (= CG_SKK_INT_SNK #skk) (= CG_SKK_INT_SUI #skk))) ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化 ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
      (ssadd (ssname &SS #i) #resSS))
    (setq #i (1+ #i))
  ); repeat
  #resSS
); PcGetRidOfSink

;<HOM>*************************************************************************
; <関数名>    : KcGetSSAroundItem_CHG
; <処理概要>  : 基準アイテム周囲の移動対象範囲の全図形取得
; <戻り値>    : 選択セットか nil
; <作成>      : 00/08/22 MH 01/01/29 YM 改造
; <備考>      :
;*************************************************************************>MOH<
(defun KcGetSSAroundItem_CHG (
  &eITEM    ; 基準とするアイテム
  &fDIR     ; 移動方向　"L" "R"
  &fMOV     ; 移動量
  /
  #fDIR #dP #xd$ #W #D #H #ang #dAREA #fANG #p1 #p2 #p3 #p4 #ss #wss #i
  #PP1 #PP2
  #DEL_flg ; 入れ替えた部材を移動対象に含めない===>T
  #MOV_flg ; 移動距離にﾏｲﾅｽをつける
  )
  (setq #fDIR &fDIR)
  (setq #xd$ (CFGetXData &eITEM "G_SYM"))
  (setq #W (nth 3 #xd$))
  (setq #D (nth 4 #xd$))
  (setq #H (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &eITEM "G_LSYM")))

  ;;; 移動させる図形の範囲を示す4点を求める
  (setq #pp1 (cdr (assoc 10 (entget &eITEM))))
  (setq #pp2 (Pcpolar #pp1 #ang #W))

  (cond
    ((and (> &fMOV 0)(= #fDIR "L")) ; 元より幅広いｷｬﾋﾞで左に移動
      (setq #fANG (+ pi #ang)) ; 挿入された部材は移動する
      (setq #p1 (polar #pp1 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp1 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
      (setq #DEL_flg nil)
    )
    ((and (> &fMOV 0)(= #fDIR "R")) ; 元より幅広いｷｬﾋﾞで右に移動
      (setq #fANG #ang) ; 挿入された部材は移動しない
      (setq #p1 (polar #pp1 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp1 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
      (setq #DEL_flg T)
    )
    ((and (< &fMOV 0)(= #fDIR "R")) ; 元より幅狭いｷｬﾋﾞで右に移動
      (setq #fANG (+ pi #ang)) ; 挿入された部材は移動する
      (setq #p1 (polar #pp1 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp1 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
      (setq #DEL_flg nil)
      (setq #MOV_flg T)
    )
    ((and (< &fMOV 0)(= #fDIR "L")) ; 元より幅狭いｷｬﾋﾞで左に移動
      (setq #fANG #ang) ; 挿入された部材は移動しない
      (setq #p1 (polar #pp2 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp2 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
      (setq #DEL_flg T)
      (setq #MOV_flg T)
    )
  );_cond

  ; 範囲チェック用↓
;;;(command "_PLINE" #p1 #p2 #p3 #p4 "c")
;;;(command "_change" (entlast) "" "P" "C" "CYAN" "")

  (setvar "PICKSTYLE" 0)
  ; 移動対象範囲の全図形取得
  (setq #ss (PcGetAllItemBetween2Pnt (list #p1 #p2 #p3 #p4)))
  ;03/03/28 YM ADD-S エラー処理
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #ss (PcGetRidOfSink #ss)); 範囲中のシンクを除去 01/03/08 MH ADD
    )
    (progn
      (CFAlertErr "移動する部材がありません")
    )
  );_if
  (list #ss #DEL_flg #MOV_flg)
);KcGetSSAroundItem_CHG

;<HOM>*************************************************************************
; <関数名>    : PcGetNextMoveItem$
; <処理概要>  : 指定図形に隣接して移動の可能性のあるアイテムのリストを作成
; <戻り値>    : 図形名リスト 条件の図形がなければ Nil
; <作成>      : 00/08/22 MH
; <備考>      : アイテム高さ指示リストがnilなら、&eSYMから範囲がきまる
;*************************************************************************>MOH<
(defun PcGetNextMoveItem$ (
  &eSYM       ; 対象図形名
  &iAREA$     ; 移動させるアイテム高さ指示リスト 例= '(CG_SKK_TWO_BAS CG_SKK_TWO_UPP)
  /
  #sHIN #eNEXT$ #FLG$
  )
  (defun #AddNextItem$ (&NXT$ &eITEM &iAREA / #eNX #eNXT$)
    (setq #eNX (car (PcGetNextItemSameLevel &eITEM &iAREA)))
    (if #eNX (setq #eNXT$ (PcGetLinkMoveItems #eNX (CFGetSymSKKCode #eNX 2))))
    (append &NXT$ #eNXT$)
  ) ; #AddNextItem$

  (if (= 'LIST &iAREA$)
    (setq #FLG$ &iAREA$)
    (progn
      ; 品名で判断して特殊ケース分岐
      (setq #sHIN (nth 5 (CFGetXData &eSYM "G_LSYM")))
      (setq #FLG$ (list (CFGetSymSKKCode &eSYM 2)))
    )
  ); if progn

;-- 2011/09/21 A.Satoh Mod - S
;;;;;  ;06/09/07 YM ADD 家具対応 性格ｺｰﾄﾞ=900も対象にする
;;;;;  ;ﾕﾆｯﾄ記号取得 ;06/08/23 YM ADD-S
;;;;;  (setq #unit (KPGetUnit))
;;;;;  (if (= #unit "T");「家具」だった場合
;;;;;    (progn ;全部一緒に動かす
;;;;;      (setq #eNEXT1$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_BAS));; 隣接フロア
;;;;;      (setq #eNEXT2$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_UPP));; 隣接ウォール
;;;;;      (setq #eNEXT3$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_MID));; 隣接ミドル
;;;;;      (setq #eNEXT4$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_ETC));; 隣接その他(900)
;;;;;      (setq #eNEXT$ (append #eNEXT1$ #eNEXT2$ #eNEXT3$ #eNEXT4$))
;;;;;    )
;;;;;    (progn ;従来ﾛｼﾞｯｸ(家具以外)
;;;;;
;;;;;      (if (member CG_SKK_TWO_BAS #FLG$)
;;;;;        (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_BAS)));; 隣接フロア
;;;;;      (if (member CG_SKK_TWO_UPP #FLG$)
;;;;;        (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_UPP)));; 隣接ウォール
;;;;;      (if (member CG_SKK_TWO_MID #FLG$)
;;;;;        (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_MID)));; 隣接ミドル
;;;;;      (if (member CG_SKK_TWO_EYE #FLG$)
;;;;;        (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_EYE)));; 隣接アイレベル
;;;;;    )
;;;;;  );_if
  (if (member CG_SKK_TWO_BAS #FLG$)
    (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_BAS)));; 隣接フロア
  (if (member CG_SKK_TWO_UPP #FLG$)
    (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_UPP)));; 隣接ウォール
  (if (member CG_SKK_TWO_MID #FLG$)
    (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_MID)));; 隣接ミドル
  (if (member CG_SKK_TWO_EYE #FLG$)
    (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_EYE)));; 隣接アイレベル
  (if (member CG_SKK_TWO_ETC #FLG$)
    (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_ETC)));; 隣接その他
;-- 2011/09/21 A.Satoh Mod - S

  #eNEXT$
); PcGetNextMoveItem$

;;<HOM>***********************************************************************
;;; <関数名>    : PcChgH800HinbanInList
;;; <処理概要>  : 渡されたリストの指定の位置の品番がH800時の ｢階層名称2｣ であれば
;;;             : 「階層名称」の品番に変換
;;; <戻り値>    : リスト
;;; <作成>      : 2000-07-14 MH
;;; <備考>      : H850→H800で品番の変わるアイテムへの対策に使用
;;;***********************************************************************>MOH<
(defun PcChgH800HinbanInList (
  &ORG$         ; 対象リスト
  &i            ; nth 関数でどの位置を変更するか？
  &sCODE        ; SERIES記号
  /
  #sHIN #RES$ #A #i
  )
  (setq #sHIN (PcChgH800Hin (nth &i &ORG$) &sCODE))
  (setq #i 0)
  (foreach #A &ORG$
    (setq #RES$ (append #RES$ (list (if (= #i &i) #sHIN #A))))
    (setq #i (1+ #i))
  ); foreach
  #RES$
); PcChgH800HinbanInList

;;;<HOM>***********************************************************************
;;; <関数名>    : PcChgH800Hin
;;; <処理概要>  : 渡された品番で｢階層名称2｣欄を検索。ヒットした場合｢階層名称｣
;;;             : の品番、ヒットしなかった場合、元の品番を返す
;;; <戻り値>    : 品番文字列
;;; <作成>      : 2000-07-14 MH
;;;***********************************************************************>MOH<
(defun PcChgH800Hin (
  &sHIN         ; 対象品番
  &sCODE        ; SERIES記号
  /
  #QLY$ #sRESHIN
  )
  (setq #QLY$
    (CFGetDBSQLRec CG_DBSESSION (strcat "階層" &sCODE)
      (list (list "階層名称2" &sHIN 'STR))
  ))
  (if #QLY$
    (setq #sRESHIN (nth 2 (car #QLY$)))
    (setq #sRESHIN &sHIN)
  )
  #sRESHIN
);PcChgH800Hin

;<HOM>*************************************************************************
; <関数名>    : PcChk750CentrItemD
; <処理概要>  : 奥行値算出：750用キャビかセンター合わせキャビなら基点のズレ分補正
; <戻り値>    : 補正済み奥行値 (図形が不正ならnil)
; <作成>      : 00/07/28 MH
; <備考>      : 連続配置、挿入などの基準アイテム奥行き取得部で使用
;*************************************************************************>MOH<
(defun PcChk750CentrItemD (&eITEM / #D #resD #sHIN #iSP)
  (setq #sHIN (PcChgH800Hin (nth 5 (CFGetXData &eITEM "G_LSYM")) CG_SeriesCode))
  (setq #resD
    (cond
      ((/= 'ENAME (type &eITEM)) nil)
      ((not #sHIN) nil)
      ((not (setq #D (nth 4 (CFGetXData &eITEM "G_SYM")))) nil)
      (t #D) ;それ以外
    ); cond
  ); setq
  #resD
); PcChk750CentrItemD
; 00/08/30 SN ADD
; 基準ｱｲﾃﾑがｺｰﾅｰｷｬﾋﾞの時は取り付ける方向によって
; 幅と奥行を外形ﾎﾟﾘﾗﾝから取得する。
(defun GetCornerCabWD( &eBase &sDIR
  /
  #lxd
  #xd
  #plpt$
  #plent
  )
  (setq #lxd (CFGetXData &eBase "G_LSYM"))
  (if (= CG_SKK_INT_CNR (nth 9 #lxd)) ; 01/08/31 YM MOD 115-->ｸﾞﾛｰﾊﾞﾙ化
    (progn
      (setq #plent (PKGetPMEN_NO &eBase 2));外形ﾎﾟﾘﾗｲﾝの取得
      (setq #plpt$ (GetLwPolyLinePt #plent));ﾎﾟﾘﾗｲﾝの点取得
      (setq #plpt$ (GetPtSeries (cdr (assoc 10 (entget &eBase))) #plpt$));点の時計周り整列
      (if (= "R" &sDIR)
        (list
          (distance (nth 0 #plpt$) (nth 1 #plpt$));幅
          (distance (nth 1 #plpt$) (nth 2 #plpt$));奥行
        )
        (list
          (distance (nth 5 #plpt$) (nth 0 #plpt$));幅
          (distance (nth 4 #plpt$) (nth 5 #plpt$));奥行
        )
      )
    );progn
    (progn
      (setq #xd (CFGetXData &eBase "G_SYM"))
      (list (nth 3 #xd) (nth 4 #xd))
    )
  );end if
);GetCornerCabWD

;;;<HOM>*************************************************************************
;;; <関数名>    : KcSetG_OPT
;;; <処理概要>  : アイテムに拡張ﾃﾞｰﾀ "G_OPT"を追加セットする。
;;; <戻り値>    : なし
;;; <作成>      : 01/02/04 MH 01/04/27 MH 個数-1ダイアログ処理変更
;;; <備考>      : セットするOPTと数の判定はテーブル"品番OP"で判定
;;;*************************************************************************>MOH<
(defun KcSetG_OPT (
  &eSYM   ; ｼﾝﾎﾞﾙ図形
  /
  #sHIN #QRY$ #QR #sOPT #iHIN #i #iOP #addOP$ #DLG$ #iDN #Dnum$ #FLR$
#QRY2$ ; 02/06/18 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KcSetG_OPT////")
  (CFOutStateLog 1 1 " ")

  (setq #QRY2$ nil) ; 02/06/21 YM ADD 初期化
  (setq #QRY$ nil)  ; 02/06/21 YM ADD 初期化

  ; 天井フィラーにもOPT設置可能  01/04/03 MH MOD
  (if (setq #FLR$ (CFGetXData &eSYM "G_FILR"))
    (setq #sHIN (car #FLR$))
    (setq #sHIN (nth 5 (CFGetXData &eSYM "G_LSYM"))) ; "品番名称"
  ); if

  ;02/06/18 YM ADD-S CG_CeilHeight ; 天井高さ
  ;品番OP2にレコードがあればｵﾌﾟｼｮﾝ品としてｾｯﾄする
  (if (= 'INT (type CG_CeilHeight))
    (progn
      ; 06/09/25 T.Ari Mod 品番OP2の検索削除
      (setq #QRY2$ nil)
;     (setq #QRY2$ ; 複数HIT可
;       (CFGetDBSQLRec CG_DBSESSION "品番OP2"
;          (list
;            (list "品番名称" #sHIN 'STR)
;            (list "天井高さ" (itoa CG_CeilHeight) 'INT)
;          )
;       )
;     )
    )
  );_if
  ;02/06/18 YM ADD-E

  (setq #QRY$ ; 複数HIT可
    (CFGetDBSQLRec CG_DBSESSION "品番OP"
       (list (list "品番名称" #sHIN 'STR))
    )
  )

  ; 02/06/18 YM ADD-S
  (if #QRY2$
    (setq #QRY$ #QRY2$)
  );_if

  ; 02/06/18 YM ADD-E

  (if #QRY$
    (progn
      (setq #DLG$ nil)
      (setq #addOP$ nil) ; 02/05/13 YM ADD
      (setq #iHIN 0) ; 品番個数

    ; 02/05/13 YM DEL-S
;;;    (setq #i 0)
;;;    (repeat (length #QRY$)   ; ﾚｺｰﾄﾞ数回繰り返す
;;;      (setq #QR (nth #i #QRY$)) ; 各ﾚｺｰﾄﾞ
;;;      (setq #sOPT (nth 1 #QR))
;;;      ; #QRのオプション品個数 0 以下ならダイアログ処理リスト作成
;;;      (if (> 0 (nth 3 #QR))
;;;        (setq #DLG$ (append #DLG$ (list #QR)))
;;;        (setq #iOP (fix (nth 3 #QR)))
;;;      ); end of if
;;;      ; ここまででオプション品個数が1以上ならOPT設置リストに取得
;;;      (if (<= 1 #iOP) (progn
;;;        (setq #addOP$ (append #addOP$ (list #sOPT #iOP))) ; 品番と個数
;;;        (setq #iHIN (1+ #iHIN))
;;;      )); end of if&progn
;;;      (setq #i (1+ #i))
;;;    ); repeat
    ; 02/05/13 YM DEL-E

      ; 02/05/13 YM MOD-S
      (setq #i 0)
      (repeat (length #QRY$)   ; ﾚｺｰﾄﾞ数回繰り返す
        (setq #QR (nth #i #QRY$)) ; 各ﾚｺｰﾄﾞ
        (setq #sOPT (nth 1 #QR))
        (setq #iOP (fix (nth 3 #QR)))

        ; #QRのオプション品個数 0 以下ならダイアログ処理リスト作成
        (if (> 0 #iOP)
          (setq #DLG$ (append #DLG$ (list #QR)))
        );_if

        ; オプション品個数が1以上ならOPT設置リストに取得
        (if (<= 1 #iOP)
          (progn
            (setq #addOP$ (append #addOP$ (list #sOPT #iOP))) ; 品番と個数
            (setq #iHIN (1+ #iHIN))
          )
        );_if
        (setq #i (1+ #i))
      ); repeat
      ; 02/05/13 YM MOD-E

      ; 個数-1 のリストが取得されていれば、ダイアログ処理
      (if #DLG$
        (progn
          (if (= "Cancel" (setq #Dnum$ (KcOPTDlg #DLG$)))
            (progn
    ;;;01/05/09YM@          (command "_undo" "b")(exit)
              (exit) ; 01/05/09 YM undoのやり過ぎ?
            )
          );_if
          (setq #i 0)
          ; ダイアログの結果リスト上の個数が1以上ならOPT設置リストに取得
          (foreach #iDN #Dnum$
            (if (< 0 #iDN) (progn
              (setq #sOPT (nth 1 (nth #i #DLG$)))
              (setq #addOP$ (append #addOP$ (list #sOPT #iDN))) ; 品番と個数
              (setq #iHIN (1+ #iHIN))
            )); if progn
            (setq #i (1+ #i))
          );foreach
        )
      );_if

      ; 最終的に品番個数が0なら結果リストnil代入 1以上なら品番個数をOPT設置リスト付加
      (setq #addOP$ (if (< 0 #iHIN) (cons #iHIN #addOP$) nil))

      ; アイテムにOPT付加実行
      (if #addOP$
        (progn
          (if (= (tblsearch "APPID" "G_OPT") nil)
            (regapp "G_OPT");アプリケーション名登録
          );_if
          (CFSetXData &eSYM "G_OPT" #addOP$)
        )
      );_if
    )
  );_if

  (princ)
); KcSetG_OPT

;<HOM>*************************************************************************
; <関数名>    : KcOPTDlg
; <処理概要>  : リストの品番を表示。数の分有無のリストを取得
; <戻り値>    : 1= 有, 0= 無, のリストか "Cancel"
; <作成>      : 01/04/27 MH
; <備考>      : 表示する品番の数は4個まで対応
;*************************************************************************>MOH<
(defun KcOPTDlg ( &QLY$ / #iQLY #sDLG #dcl_id #RES$ #i #Q$ #BIKOU
  )
  (defun ##GetRes$ ( / #i #RES$)
    (setq #i 1)
    (setq #RES$ nil)
    (repeat #iQLY
      (setq #RES$ (append #RES$ (list (atoi (get_tile (strcat "RES" (itoa #i)))))))
      (setq #i (1+ #i))
    ); repeat
    #RES$
  ); ##GetRes$

  (setq #iQLY (length &QLY$))
  (setq #sDLG (strcat "GetKcOPTDlg" (itoa (if (< 4 #iQLY) 4 #iQLY))))
  ;;; ダイアログの実行部 (リストの内容数でダイアログ名変化)
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog #sDLG #dcl_id)) (exit))
  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #RES$ (##GetRes$)) (done_dialog)")
  (action_tile "cancel" "(setq #RES$ \"Cancel\") (done_dialog)")
  ;;;デフォ値代入
  (setq #i 0)
  (repeat #iQLY
    (setq #Q$ (nth #i &QLY$))

    ; 02/06/17 YM MOD-S
    (setq #BIKOU (nth 5 #Q$))
    (if (/= #BIKOU nil)
      (set_tile (strcat "STR" (itoa (1+ #i))) (strcat (nth 1 #Q$) " （" #BIKOU "）"))
      (set_tile (strcat "STR" (itoa (1+ #i))) (strcat (nth 1 #Q$) ))
    );_if
;;;    (set_tile (strcat "STR" (itoa (1+ #i))) (strcat (nth 1 #Q$) " （" (nth 5 #Q$) "）"))
    ; 02/06/17 YM MOD-E

    (setq #i (1+ #i))
  ); repeat
  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; 結果リストを返す
  #RES$
); KcOPTDlg

;<HOM>*************************************************************************
; <関数名>    : PcGetOpNumDlg
; <処理概要>  : ユーザーにオプション品の有無を求めるダイアログ
; <戻り値>    : 1 か 0
; <作成>      : 00/11/24 MH ダイアログ変更にともなう書き換え
; <備考>      :
;*************************************************************************>MOH<
(defun PcGetOpNumDlg (
  &sHin       ; オプション品番
  &sDefo      ; "Yes" "No" デフォルト指定
  /
  #sNAME #iOP #sYN
  )
  (setq #sNAME (PcGetPrintName &sHin))
  (if (= "" #sNAME) (setq #sNAME (strcat "品番：" &sHin)))
  (setq #sYN (if (= "Yes" &sDefo) "36" "294"))
  (setq #iOP
    (if (= "6" (CfMsgBox (strcat #sNAME "を使用しますか？") "確認" #sYN)) 1 0)
  )
  #iOP
);PcGetOpNumDlg

;<HOM>*************************************************************************
; <関数名>    : C:SelectParts_otherseries
; <処理概要>  : 他のｼﾘｰｽﾞでﾌﾘｰﾌﾟﾗﾝ設計を開く
; <戻り値>    : なし
; <作成>      : 02/10/22 YM
; <備考>      : ｱｾｯﾄにﾆｭｰｸﾞﾗｯｾの吊戸を配置したい等の要望に答えるため
;*************************************************************************>MOH<
(defun C:SelectParts_otherseries (
  /
  #XRec$ #QRY$ #RET$ #XREC_BEFORE$ #QLY$$
  )
  ; 前処理
  (StartUndoErr)

  (setq CG_SERI_HENKOU T)
  ; ﾌﾘｰﾌﾟﾗﾝ設計画面を閉じる
  (C:arxStartApp (strcat CG_SysPATH "KillPlan.exe") 0)

  (setq #XRec$ (CFGetXRecord "SERI"))
  (if (= #XRec$ nil)
    (progn
      (CFAlertErr "一度も商品設定がされていません\n商品設定を行って下さい")
      (quit)
    )
  )
  ; 情報を保管しておく
  (setq #XRec_before$ #XRec$)

  ; DB名を入力
;;; (setq CG_DBNAME (getstring "\nDB名を入力せよ。(NK_CKNなど)"))
  ; "SERIES"検索
  (setq #QLY$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "select * from SERIES")))

  (setq #ret$ (KP_ChSeriDlg2 #QLY$$))
  (if #ret$
    (progn
      (setq CG_SeriesDB     (nth 0 #ret$))
      (setq CG_DBNAME       (nth 1 #ret$))
      (setq CG_SeriesCode   (nth 2 #ret$))
    )
    (quit)
  );_if

;;;  &Title        ;(STR)ダイアログタイトル
;;;  &DBName       ;(STR)対象データベース名
;;;  &SeriCode     ;(STR)SERIES記号   引数優先 nil==>Xrecord 01/05/09 YM
;;;  &DrSeriCode   ;(STR)扉SERIES記号 引数優先 nil可能 01/05/09 YM
;;;  &DrColCode    ;(STR)扉COLOR記号   引数優先 nil可能 01/05/09 YM

  ;// 扉面選択ダイアログ
  (setq #ret$
    (SRSelectDoorSeriesDlg
      "扉ｼﾘｰｽﾞ選択"
      CG_DBNAME      ; 対象データベース名
      CG_SeriesCode  ; SERIES記号
      nil            ; 扉SERIES記号
      nil            ; 扉COLOR記号
    )
  )
  (if (/= #ret$ nil)
    (progn
      (setq CG_DRSeriCode (car #ret$))  ;扉SERIES記号(ユーザー選択扉シリ)
      (setq CG_DRColCode  (cadr #ret$)) ;扉COLOR記号(ユーザー選択扉カラ)
    )
    (quit)
  );_if

  ; Xrecord設定
  (setq CG_SetXRecord$
    (list
      CG_DBNAME       ; 1.DB名称★
      CG_SeriesCode   ; 2.SERIES記号★
      CG_BrandCode    ; 3.ブランド記号
      CG_DRSeriCode   ; 4.扉SERIES記号★
      CG_DRColCode    ; 5.扉COLOR記号★
      CG_UpCabHeight  ; 6.取付高さ
      CG_CeilHeight   ; 7.天井高さ
      CG_RoomW        ; 8.間口
      CG_RoomD        ; 9.奥行
      CG_GasType      ;10.ガス種
      CG_ElecType     ;11.電気種
      CG_KikiColor    ;12.機器色
      CG_KekomiCode   ;13.ケコミ飾り
    )
  )
  (CFSetXRecord "SERI" CG_SetXRecord$)

  ;// データベースに接続
  (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  (if (= nil (tblsearch "APPID" "G_ARW"))  (regapp "G_ARW"))
  (if (= nil (tblsearch "APPID" "G_LSYM")) (regapp "G_LSYM"))

  ;// 現在の商品情報をファイルに書き出す
  (PC_WriteSeriesInfo CG_SetXRecord$)

  (MakeLayer "N_Symbol" 4 "CONTINUOUS")
  (MakeLayer "N_BreakD" 6 "CONTINUOUS")
  (MakeLayer "N_BreakW" 6 "CONTINUOUS")
  (MakeLayer "N_BreakH" 6 "CONTINUOUS")

  ; ﾌﾘｰﾌﾟﾗﾝ設計
  (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 1") 0)

  ; 画面左下のｼﾘｰｽﾞと扉ｶﾗｰ
  ;2011/04/22 YM MOD
  (setvar "MODEMACRO"
    (strcat "ｼﾘｰｽﾞ: " CG_SeriesDB " / 扉ｸﾞﾚｰﾄﾞ: " CG_DRSeriCode " / 扉ｶﾗｰ: " CG_DRColCode " / 引手: " CG_HIKITE)
  )

  ; 後処理
  (setq *error* nil)
  (setq CG_SERI_HENKOU T) ; ｼﾘｰｽﾞ変更中ﾌﾗｸﾞ
  (princ)
);C:SelectParts_otherseries





;<HOM>*************************************************************************
; <関数名>    : TK_PosParts
; <処理概要>  : 配置
; <戻り値>    :
; <作成>      : 2004/09/10 G.YK
; <備考>      :
;*************************************************************************>MOH<
(defun TK_PosParts (
  &HinBan &LR &Pos &Ang
  &Dan  ;;  断面指示有無  2005/01/13 G.YK ADD
  &Bunrui ;2011/07/04 YM ADD ｷｯﾁﾝA" or 収納"D"
  /
  #LR #KihonReocrd #FigureReocrd #SeriesRecord
  #dwg #ssP #elm #sym
  #n #k #Pos #Ang
  #xd #w #d #h #glsym #gsym #DoorId
#MSG #TENKAI_TYPE
#KIHONRECORD #ONE
  )

  (setq #sym nil)
  (setq #LR (if (or (= &LR nil)(= &LR "")) "Z" &LR))

  (setq #KihonReocrd
    (car (CFGetDBSQLRec CG_DBSESSION "品番基本"
      (list
        (list "品番名称" &HinBan 'STR)
        (list "LR有無"   (if (= "Z" #LR) "0" "1") 'INT)
      )
    ))
  )

  (setq #FigureReocrd
    (car (CFGetDBSQLRec CG_DBSESSION "品番図形"
      (list
        (list "品番名称" &HinBan 'STR)
        (list "LR区分"   #LR     'STR)
      )
    ))
  )

  (if (and (/= #KihonReocrd nil)(/= #FigureReocrd nil))
    (progn
      ;性格ｺｰﾄﾞ1桁 2011/04/25 YM ADD
      (setq #one (fix (* 0.01 (nth 3 #KihonReocrd))))
      
      (setq #dwg (nth 6 #FigureReocrd));図形ID OK

      (if (and (/= #dwg nil)(/= #dwg ""))
        (progn






;2011/06/14 YM MOD-S EPにも扉情報をｾｯﾄしないとCGがうまく動かない
;;;         (setq #SeriesRecord
;;;           (car (CFGetDBSQLRec CG_DBSESSION "品番シリ"
;;;             (list
;;;               (list "品番名称" &HinBan 'STR)
;;;               (list "LR区分"   #LR     'STR)
;;;             )
;;;           ))
;;;         )
;;;         
;;;         (if (/= #SeriesRecord nil)
;;;           (progn
;;;             (setq #DoorId (strcat
;;;                     (if (/= CG_DRSeriCode nil) CG_DRSeriCode "") ","
;;;                     (if (/= CG_DRColCode  nil) CG_DRColCode  "") ","
;;;                     (if (/= CG_HIKITE     nil) CG_HIKITE     "")))
;;;           )
;;;           (progn
;;;             (setq #DoorId "")
;;;           )
;;;         );_if

;品番ｼﾘの存在で見るのはまずい[品番基本]展開ﾀｲﾌﾟ=0で判断する

          (setq #KihonRecord
            (CFGetDBSQLRec CG_DBSESSION "品番基本"
              (list
                (list "品番名称" &HinBan 'STR)
              )
            )
          )
          (if (and #KihonRecord (= 1 (length #KihonRecord)))
            (progn

              (setq #tenkai_type (nth 4 (car #KihonRecord)));展開ﾀｲﾌﾟ
              (if (equal #tenkai_type 0.0 0.001)
                (progn
                  (setq #DoorId (strcat
                          (if (/= CG_DRSeriCode nil) CG_DRSeriCode "") ","
                          (if (/= CG_DRColCode  nil) CG_DRColCode  "") ","
                          (if (/= CG_HIKITE     nil) CG_HIKITE     "")))
                )
                (progn
                  (setq #DoorId "")
                )
              );_if

            )
          );_if

;2011/06/14 YM MOD-E





          ;2011/06/03 YM ADD-S
          (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg)))
            (progn
              (setq #msg (strcat "\n(TK_PosParts)図形 : ID= " #dwg " がありません"))
              (WebOutLog #msg)
            )
          )

          ; 部材の挿入
          (command "_insert" (strcat CG_MSTDWGPATH #dwg) &Pos 1 1 &Ang);2009

          ; GSMでﾌﾘｰｽﾞ、ﾛｯｸされている可能性があるため解除する
          (command "_layer" "T" "*" "") ; 全画層フリーズ解除
          (command "_layer" "U" "*" "") ; 全画層ロック解除

          ; 配置原点と角度を確保
          (setq #Pos (cdr (assoc 10 (entget (entlast)))))
          (setq #Ang (cdr (assoc 50 (entget (entlast)))))

          ; 分解&グループ化
          (command "_explode" (entlast))  ; インサート図形分解
          (SKMkGroup (ssget "P"))
          (setq #ssP (ssget "P" '((0 . "POINT")))) ; 直前に作られた選択ｾｯﾄの中からﾎﾟｲﾝﾄばかりあつめる
          (setq #n 0 #k 0)
          (repeat (sslength #ssP)
            (setq #elm (ssname #ssP #n))
            (if (CFGetXData #elm "G_SYM")
              (progn
                (setq #sym #elm)
                (setq #k (1+ #k))
                (if (>= #k 2)
                  (progn
                    (WebOutLog (strcat "\n★同一図形に\"G_SYM\"が複数あります。\n" #dwg))
                  )
                );_if
              )
            );_if
            (setq #n (1+ #n))
          );repeat

          ; LSYMの設定
          (setq #glsym
            (list
            #dwg            ;1 :本体図形ID  :『品番図形』.図形ID
            #Pos            ;2 :挿入点    :配置基点
            #Ang            ;3 :回転角度  :配置回転角度
            CG_Kcode        ;4 :工種記号  :CG_Kcode
            CG_SeriesCode   ;5 :SERIES記号  :CG_SeriesCode
            &HinBan         ;6 :品番名称  :『品番図形』.品番名称
            #LR             ;7 :L/R区分   :『品番図形』.部材L/R区分
            #DoorId         ;8 :扉図形ID  :
            ""              ;9 :扉開き図形ID:
            (fix (nth 3 #KihonReocrd))  ;10:性格CODE  :『品番基本』.性格CODE
            0               ;11:複合フラグ  :０固定（単独部材）
            0               ;12:配置順番号  :配置順番号(1～)
            (fix (nth 2 #FigureReocrd)) ;13:用途番号  :『品番図形』.用途番号★OK
            (nth 5 #FigureReocrd)   ;14:寸法Ｈ  :『品番図形』.寸法Ｈ ★OK
            (if (/= &Dan nil) &Dan 0) ;15.断面指示の有無  :『プラ構成』.断面有無
            &Bunrui         ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
            )
          )
          (CFSetXData #sym "G_LSYM" #glsym)

          ; G_SYMの設定
          (setq #xd (CFGetXData #sym "G_SYM"))
          (setq #w (nth 3 #FigureReocrd)) ; Ｗ ★OK
          (setq #d (nth 4 #FigureReocrd)) ; Ｄ ★OK
          (setq #h (nth 5 #FigureReocrd)) ; Ｈ ★OK


;;;         (if (> (nth 11 #KihonReocrd) 0)
;;;           (progn
;;;             (SKY_Stretch_Parts #sym #w #d #h)
;;;           )
;;;           (progn

              (setq #gsym
                (list
                  (if (nth 0 #xd)(nth 0 #xd) "")  ;シンボル名称
                  (nth 1 #xd)           ;コメント１
                  (nth 2 #xd)           ;コメント２
                  (if (= #w 0)(nth 4 #xd) #w)   ;シンボル基準値Ｗ
                  (if (= #d 0)(nth 5 #xd) #d)   ;シンボル基準値Ｄ
                  (if (= #h 0)(nth 6 #xd) #h)   ;シンボル基準値Ｈ
                  (nth 6 #xd)           ;シンボル取付け高さ
                  (nth 7 #xd)           ;入力方法
                  (nth 8 #xd)           ;Ｗ方向フラグ
                  (nth 9 #xd)           ;Ｄ方向フラグ
                  (nth 10 #xd)          ;Ｈ方向フラグ
                  0               ;伸縮フラグＷ
                  0               ;伸縮フラグＤ
                  0               ;伸縮フラグＨ
                  (nth 14 #xd)          ;ブレークライン数Ｗ
                  (nth 15 #xd)          ;ブレークライン数Ｄ
                  (nth 16 #xd)          ;ブレークライン数Ｈ
                )
              )
              (CFSetXData #sym "G_SYM" #gsym)
              
;;;           )
;;;         );_if

          (PCD_MakeViewAlignDoor (list #sym) 3 nil) ;扉を貼り付ける
          (KcSetG_OPT #sym)                         ;ひもつきオプション品(図形なし)をセットする
          (SetLayer)                                ;レイヤーを元の状態に戻す

        )
        (progn

        (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")));2008/06/28 OK!
          (progn
            (setq #msg (strcat "\n品番図形に図形IDが登録されていません: 品番= " &HinBan ))
            (WebOutLog #msg)
          )
        )

        )
      );_if
      
    )
  );_if

  #sym
);TK_PosParts

;-- 2011/12/22 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : TK_PosParts2
; <処理概要>  : 配置
; <戻り値>    :
; <作成>      : 2011/12/22 A.Satoh
; <備考>      :TK_PosParts をコピーして改造
;             : TK_PosPartsの扉を貼らないバージョン
;*************************************************************************>MOH<
(defun TK_PosParts2 (
	&HinBan
	&LR
	&Pos
	&Ang
	&Dan  		; 断面指示有無  2005/01/13 G.YK ADD
	&Bunrui 	; ｷｯﾁﾝA" or 収納"D"
	/
	#sym #LR #KihonReocrd
	#FigureReocrd
	#one #dwg #KihonRecord #tenkai_type #DoorId
	#msg #dwg
	#pos #ang
	#ssP #n #k #elm
	#xd #w #d #h #glsym #gsym
	)

	(setq #sym nil)
	(setq #LR (if (or (= &LR nil)(= &LR "")) "Z" &LR))

	(setq #KihonReocrd
		(car (CFGetDBSQLRec CG_DBSESSION "品番基本"
			(list
				(list "品番名称" &HinBan 'STR)
				(list "LR有無"   (if (= "Z" #LR) "0" "1") 'INT)
			)
		))
	)

	(setq #FigureReocrd
		(car (CFGetDBSQLRec CG_DBSESSION "品番図形"
			(list
				(list "品番名称" &HinBan 'STR)
				(list "LR区分"   #LR     'STR)
			)
		))
	)

	(if (and (/= #KihonReocrd nil)(/= #FigureReocrd nil))
		(progn
			; 性格ｺｰﾄﾞ1桁
			(setq #one (fix (* 0.01 (nth 3 #KihonReocrd))))

			(setq #dwg (nth 6 #FigureReocrd))	; 図形ID

			(if (and (/= #dwg nil)(/= #dwg ""))
				(progn
					;品番ｼﾘの存在で見るのはまずい[品番基本]展開ﾀｲﾌﾟ=0で判断する
					(setq #KihonRecord
						(CFGetDBSQLRec CG_DBSESSION "品番基本"
							(list
								(list "品番名称" &HinBan 'STR)
							)
						)
					)
					(if (and #KihonRecord (= 1 (length #KihonRecord)))
						(progn
							(setq #tenkai_type (nth 4 (car #KihonRecord))) ; 展開ﾀｲﾌﾟ
							(if (equal #tenkai_type 0.0 0.001)
								(progn
									(setq #DoorId
										(strcat
											(if (/= CG_DRSeriCode nil) CG_DRSeriCode "") ","
											(if (/= CG_DRColCode  nil) CG_DRColCode  "") ","
											(if (/= CG_HIKITE     nil) CG_HIKITE     "")
										)
									)
								)
								(progn
									(setq #DoorId "")
								)
							)
						)
					)

					(if (= nil (findfile (strcat CG_MSTDWGPATH #dwg)))
						(progn
							(setq #msg (strcat "\n(TK_PosParts)図形 : ID= " #dwg " がありません"))
							(WebOutLog #msg)
						)
					)

					; 部材の挿入
					(command "_insert" (strcat CG_MSTDWGPATH #dwg) &Pos 1 1 &Ang);2009

					; GSMでﾌﾘｰｽﾞ、ﾛｯｸされている可能性があるため解除する
					(command "_layer" "T" "*" "") ; 全画層フリーズ解除
					(command "_layer" "U" "*" "") ; 全画層ロック解除

					; 配置原点と角度を確保
					(setq #Pos (cdr (assoc 10 (entget (entlast)))))
					(setq #Ang (cdr (assoc 50 (entget (entlast)))))

					; 分解&グループ化
					(command "_explode" (entlast))  ; インサート図形分解
					(SKMkGroup (ssget "P"))

					; 直前に作られた選択ｾｯﾄの中からﾎﾟｲﾝﾄばかりあつめる
					(setq #ssP (ssget "P" '((0 . "POINT"))))
					(setq #n 0 #k 0)
					(repeat (sslength #ssP)
						(setq #elm (ssname #ssP #n))
						(if (CFGetXData #elm "G_SYM")
							(progn
								(setq #sym #elm)
								(setq #k (1+ #k))
								(if (>= #k 2)
									(progn
										(WebOutLog (strcat "\n★同一図形に\"G_SYM\"が複数あります。\n" #dwg))
									)
								);_if
							)
						);_if
						(setq #n (1+ #n))
					);repeat

					; LSYMの設定
					(setq #glsym
						(list
							#dwg													;1 :本体図形ID  :『品番図形』.図形ID
							#pos													;2 :挿入点    :配置基点
							#ang													;3 :回転角度  :配置回転角度
							CG_Kcode											;4 :工種記号  :CG_Kcode
							CG_SeriesCode									;5 :SERIES記号  :CG_SeriesCode
							&HinBan												;6 :品番名称  :『品番図形』.品番名称
							#LR														;7 :L/R区分   :『品番図形』.部材L/R区分
							#DoorId												;8 :扉図形ID  :
							""														;9 :扉開き図形ID:
							(fix (nth 3 #KihonReocrd))		;10:性格CODE  :『品番基本』.性格CODE
							0															;11:複合フラグ  :０固定（単独部材）
							0															;12:配置順番号  :配置順番号(1～)
							(fix (nth 2 #FigureReocrd))		;13:用途番号  :『品番図形』.用途番号★OK
							(nth 5 #FigureReocrd)					;14:寸法Ｈ  :『品番図形』.寸法Ｈ ★OK
							(if (/= &Dan nil) &Dan 0)			;15.断面指示の有無  :『プラ構成』.断面有無
							&Bunrui												;16:分類(ｷｯﾁﾝ"A" or 収納"D")
						)
					)
					(CFSetXData #sym "G_LSYM" #glsym)

					; G_SYMの設定
					(setq #xd (CFGetXData #sym "G_SYM"))
					(setq #w (nth 3 #FigureReocrd)) ; Ｗ ★OK
					(setq #d (nth 4 #FigureReocrd)) ; Ｄ ★OK
					(setq #h (nth 5 #FigureReocrd)) ; Ｈ ★OK

					(setq #gsym
						(list
							(if (nth 0 #xd)(nth 0 #xd) "")	; シンボル名称
							(nth 1 #xd)											; コメント１
							(nth 2 #xd)											; コメント２
							(if (= #w 0)(nth 4 #xd) #w)			; シンボル基準値Ｗ
							(if (= #d 0)(nth 5 #xd) #d)			; シンボル基準値Ｄ
							(if (= #h 0)(nth 6 #xd) #h)			; シンボル基準値Ｈ
							(nth 6 #xd)											; シンボル取付け高さ
							(nth 7 #xd)											; 入力方法
							(nth 8 #xd)											; Ｗ方向フラグ
							(nth 9 #xd)											; Ｄ方向フラグ
							(nth 10 #xd)										; Ｈ方向フラグ
							0																; 伸縮フラグＷ
							0																; 伸縮フラグＤ
							0																; 伸縮フラグＨ
							(nth 14 #xd)										; ブレークライン数Ｗ
							(nth 15 #xd)										; ブレークライン数Ｄ
							(nth 16 #xd)										; ブレークライン数Ｈ
						)
					)
					(CFSetXData #sym "G_SYM" #gsym)

					(KcSetG_OPT #sym) ; ひもつきオプション品(図形なし)をセットする
					(SetLayer)				;レイヤーを元の状態に戻す
				)
				(progn
					(if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")))
						(progn
							(setq #msg (strcat "\n品番図形に図形IDが登録されていません: 品番= " &HinBan ))
							(WebOutLog #msg)
						)
					)
				)
			)
		)
	)

  #sym

);TK_PosParts
;-- 2011/12/22 A.Satoh Add - E

;-- 2011/08/03 A.Satoh Add - S
;;;<HOM>***********************************************************************
;;; <関数名>    : CheckDoorGradeFree
;;; <処理概要>  : 扉グレード別配置不可部材チェック
;;;             :   所定の品番名称が指定された扉のグレード、色である場合に
;;;             :   存在できないかどうかをチェックする
;;; <戻り値>    : T   → 存在可
;;;             : nil → 存在不可
;;; <作成>      : 11/08/03 A.Satoh
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun CheckDoorGradeFree (
  &hinban   ; 品番名称
  &DrSeries ; 扉シリーズ記号
  &DrColor  ; 扉色記号
  /
  #ret #idx #qry$$ #qry$ #ser_lst$ #col_lst$ #ser #col
	#flag
  )

  (setq #ret T)

  ; 品番名称取得
  ; 扉シリ別非対象部材から情報を抽出する
  (setq #qry$$ (CFGetDBSQLRec CG_DBSESSION "扉シリ別非対応部材" (list (list "品番名称" &hinban 'STR))))

  ; 扉シリーズ非対象部材チェック
  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #qry$ (nth 0 #qry$$))
      (setq #ser (nth 2 #qry$))
      (if (/= #ser "ALL")
        (setq #ser_lst$ (StrParse #ser ","))
      )
      (setq #col (nth 3 #qry$))
      (if (/= #col "ALL")
        (setq #col_lst$ (StrParse #col ","))
      )
      (setq #flag (nth 4 #qry$))

      (cond
        ((and (= #ser "ALL") (= #col "ALL"))
          (if (= #flag "NG")
            (setq #ret nil)
          )
        )
        ((and (/= #ser "ALL") (= #col "ALL"))
          (if (/= (member &DrSeries #ser_lst$) nil)
            (if (= #flag "NG")
              (setq #ret nil)
            )
            (if (= #flag "OK")
              (setq #ret nil)
            )
          )
        )
        ((and (= #ser "ALL") (/= #col "ALL"))
          (if (/= (member &DrColor #col_lst$) nil)
            (if (= #flag "NG")
              (setq #ret nil)
            )
            (if (= #flag "OK")
              (setq #ret nil)
            )
          )
        )
        (T
          (if (and (/= (member &DrSeries #ser_lst$) nil)
                   (/= (member &DrColor  #col_lst$) nil))
            (if (= #flag "NG")
              (setq #ret nil)
            )
            (if (= #flag "OK")
              (setq #ret nil)
            )
          )
        )
      )
    )
  )

  #ret

);CheckDoorGradeFree
;-- 2011/08/03 A.Satoh Add - E

; 以下、フレームキッチン対応
;<HOM>*************************************************************************
; <関数名>    : OutputKanaguInfo
; <処理概要>  : フレームキッチンの場合"HOSOKU.cfg"に金具を出力(フレームより算出)
; <戻り値>    : なし
; <作成>      : 2017/06/13 KY
; <備考>      :
;*************************************************************************>MOH<
(defun OutputKanaguInfo (
	/
	#masterKanaguList$$ ; 金具セットの品番/名称/ID/1セットあたり個数のリスト			ローカル変数宣言(初期値 nil)
	#frames$$ ; フレーム情報
	#frameHinbans$ ; フレームの品番のリスト
	#kanaguRem
	#kanaguCnt
	#kanaguInfo$
	#kanaguInfo$$ ; 金具個数情報
	#kanaguInfoOrg$$ ; 金具個数情報(自動積算前)
	#kanaguInfo
	#needSaveCfg
	#hinbanK
	#nameK
	#countK
	#idK
	#qpsK
	)

	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn
			(setq #needSaveCfg nil)
			(setq #frames$$ (GetFrameInfo$$ T nil))
			(princ (strcat "\nフレームの個数=" (itoa (length (nth 0 #frames$$))))) ; debug用
			(setq #frameHinbans$ (mapcar 'caddr (nth 0 #frames$$)))					;| リストの 1 番目の要素の 3 番目の要素(フレームの品番) #frameHinbans$に代入 |;
			(setq #masterKanaguList$$ (GetMasterKanaguList$$))
			(setq #kanaguInfoOrg$$ (GetKanaguCnt$$ #masterKanaguList$$)) ; 品番/名称/個数/分類/ID/1セットあたり個数のリスト

			(if (< 0 (apply '+ (mapcar 'caddr #kanaguInfoOrg$$)))
				; 個数設定済みであれば自動積算しない
				(setq #kanaguInfo$$ (mapcar
					'(lambda (#kanaguInfo$) (append #kanaguInfo$ (list nil)))
					#kanaguInfoOrg$$))
				;else
				(progn
					(setq #kanaguCnt (IntegrateKanaguCnt #frameHinbans$)) ; 金具の個数

					(setq #kanaguInfo$$ nil)
					(foreach #kanaguInfo$ #kanaguInfoOrg$$										;| 金具セット品番のレコード数ループ(ID順) |;
						(setq #hinbanK (nth 0 #kanaguInfo$))
						(setq #nameK (nth 1 #kanaguInfo$))
						(setq #countK (nth 2 #kanaguInfo$))
						(setq #idK (nth 4 #kanaguInfo$))										;| 金具セット品番.ID |;
						(setq #qpsK (nth 5 #kanaguInfo$))										;| 金具セット品番.割る数 |;

						(if (< 0 #kanaguCnt)
							(progn
								(setq #kanaguRem (+ #kanaguCnt 1))
								(setq #kanaguCnt (- (rem #kanaguRem #qpsK) 1))
								(setq #kanaguRem (fix (/ #kanaguRem #qpsK)))
								(princ (strcat "\n金具セット[" #hinbanK "]の個数の積算: " (itoa #kanaguRem))) ; debug
								(if (> #kanaguRem 0) ; 1個以上で積算できた場合
									(progn
										(setq #kanaguInfo$ (append (list-put-nth #kanaguRem #kanaguInfo$ 2) (list T)))
										;;;;(setq #kanaguInfo$ (list-put-nth #kanaguRem #kanaguInfo$ 2))
										(setq #needSaveCfg T)
									);progn
									;else
									(setq #kanaguInfo$ (append #kanaguInfo$ (list nil)))
								);if
							);progn
						);if
;|
						(if (= 0 #countK) ; 金具セットの個数が未設定(0)の場合
							(progn
								(setq #kanaguCnt (IntegrateKanaguCnt #frameHinbans$ #hinbanK #idK #qpsK)) ; 個数の積算
								(princ (strcat "\n金具セット[" #hinbanK "]の個数の積算: " (itoa #kanaguCnt))) ; debug
								(if (> #kanaguCnt 0) ; 1個以上で積算できた場合
									(progn
										;(setq #kanaguInfo$ (list #hinbanK #nameK #kanaguCnt (nth 3 #kanaguInfo$) T))
										(setq #kanaguInfo$ (append (list-put-nth #kanaguCnt #kanaguInfo$ 2) (list T)))
										(setq #needSaveCfg T)
									);progn
									;else
									(setq #kanaguInfo$ (append #kanaguInfo$ (list nil)))
								);if
							);progn
							;else
							(progn
								(princ (strcat "\n金具セット[" #hinbanK "]の個数設定済み: " (itoa #countK))) ; debug
							);progn
						);if
|;
						(setq #kanaguInfo$$ (append #kanaguInfo$$ (list #kanaguInfo$)))
					);foreach
				);progn
			);if

			(setq #kanaguInfo "")
			(foreach #kanaguInfo$ #kanaguInfo$$
				(setq #hinbanK (nth 0 #kanaguInfo$))
				(setq #nameK (nth 1 #kanaguInfo$))
				(setq #countK (nth 2 #kanaguInfo$))
				(setq #kanaguInfo (strcat #kanaguInfo " " #nameK "\t" #hinbanK "\t" (itoa #countK) "個\n"))
			);foreach

			(CFYesDialog (strcat "積算状況(自動積算対象)\n" #kanaguInfo "※【追加部材】で個数を修正できます。"))

			(if #needSaveCfg
				(SaveKanaguCnt #kanaguInfo$$)
			);if
		);progn
	);if

	(princ)
);OutputKanaguInfo

;<HOM>*************************************************************************
; <関数名>    : GetFrameInfo$$
; <処理概要>  : フレーム情報の取得(フレームキッチンのみ有効)
; <戻り値>    : フレーム情報 ((図形名 (X座標 Y座標 Z座標) 品番 (W D H) (方向W 方向D 方向H) 回転角度 縦=1/横=2) …)
;               カウンター情報 ((図形名 (X座標 Y座標 Z座標) 品番 (W D H) (方向W 方向D 方向H) 回転角度) …)
; <作成>      : 2017/06/13 KY
; <備考>      :
;*************************************************************************>MOH<
(defun GetFrameInfo$$ (
	&frames   ; (BOOL)フレーム情報取得
	&counters ; (BOOL)カウンター情報取得
	/
	#frames$$ ; フレーム情報
	#counters$$ ; カウンター情報
	#code$
	#ss
	#idx
	#en
	#pt
	#xd$
	#xdl$
	#hinban
	#dimW #dimD #dimH #dimH2
	#dirW #dirD #dirH
	#ang
	#ft
	#d1$ #d2$ #pt1 #pt2
	)

	; 実数値の比較
	;   -1 : 引数1 < 引数2
	;    0 : 引数1 = 引数2
	;    1 : 引数1 > 引数2
	(defun ##comp ( &d1 &d2 / )
		(cond
			((equal &d1 &d2 0.001)
				0
			)
			((< &d1 &d2)
				-1
			)
			(T
				1
			)
		);cond
	);##comp

	(setq #frames$$ nil)
	(setq #counters$$ nil)

	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn
			(setq #ss (ssget "X" '((-3 ("G_SYM")))))
			(if #ss
				(progn
					(setq #idx 0)
					(repeat (sslength #ss)
						(setq #en (ssname #ss #idx))
						(setq #code$ (CFGetSymSKKCode #en nil))
						(cond
							; 縦フレーム・横フレームの場合
							((and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_TWO_BAS (nth 1 #code$)))
								(if &frames
									(progn
										(setq #xd$ (CfGetXData #en "G_SYM"))
										(setq #xdl$ (CfGetXData #en "G_LSYM"))
										(setq #hinban (nth 5 #xdl$)) ; 品番
										(setq #dimW (nth 3 #xd$)) ; G_SYMのｼﾝﾎﾞﾙ基準値W (実数)
										(setq #dimD (nth 4 #xd$)) ; G_SYMのｼﾝﾎﾞﾙ基準値D (実数)
										(setq #dimH (nth 5 #xd$)) ; G_SYMのｼﾝﾎﾞﾙ基準値H (実数)
										(setq #dimH2 (nth 13 #xdl$)) ; G_LSYMの寸法H (整数)
									 	(setq #ang (nth 2 #xdl$)) ; 回転角度(ラジアン)
										(setq #dirW (nth 8 #xd$)) ; G_SYMのW方向ﾌﾗｸﾞ
										(setq #dirD (nth 9 #xd$)) ; G_SYMのD方向ﾌﾗｸﾞ
										(setq #dirH (nth 10 #xd$)) ; G_SYMのH方向ﾌﾗｸﾞ
										(setq #ft (GetFrameType #xd$ #xdl$))
										(if (or (= #ft 1) (= #ft 2))
											(progn
												(setq #pt (cdrassoc 10 (entget #en)))
												(setq #frames$$ (append #frames$$
													(list (list #en #pt #hinban (list #dimW #dimD #dimH2) (list #dirW #dirD #dirH) #ang #ft))))
											);progn
										);if
									);progn
								);if
							)
							; カウンターの場合
							((equal #code$ (list CG_SKK_ONE_CNT CG_SKK_TWO_BAS CG_SKK_THR_DIN) 0.1)
								(if &counters
									(progn
										(setq #xd$ (CfGetXData #en "G_SYM"))
										(setq #xdl$ (CfGetXData #en "G_LSYM"))
										(setq #hinban (nth 5 #xdl$)) ; 品番
										(setq #dimW (nth 3 #xd$)) ; G_SYMのｼﾝﾎﾞﾙ基準値W (実数)
										(setq #dimD (nth 4 #xd$)) ; G_SYMのｼﾝﾎﾞﾙ基準値D (実数)
										(setq #dimH (nth 5 #xd$)) ; G_SYMのｼﾝﾎﾞﾙ基準値H (実数)
										(setq #ang (nth 2 #xdl$)) ; 回転角度(ラジアン)
										(setq #dirW (nth 8 #xd$)) ; G_SYMのW方向ﾌﾗｸﾞ
										(setq #dirD (nth 9 #xd$)) ; G_SYMのD方向ﾌﾗｸﾞ
										(setq #dirH (nth 10 #xd$)) ; G_SYMのH方向ﾌﾗｸﾞ
										(if (IsCounter #xd$ #xdl$)
											(progn
												(setq #pt (cdrassoc 10 (entget #en)))
												(setq #counters$$ (append #counters$$
													(list (list #en #pt #hinban (list #dimW #dimD #dimH) (list #dirW #dirD #dirH) #ang))))
											);progn
										);if
									);progn
								);if
							)
						);cond
						(setq #idx (1+ #idx))
					);repeat
				);progn
			);if
		);progn
	);if

	(if #frames$$
		; フレームがあり、且つ必要な場合
		(progn
			; 座標でソート
			(setq #frames$$ (vl-sort #frames$$
																'(lambda ( #d1$ #d2$ )
																	(setq #pt1 (nth 1 #d1$)
																				#pt2 (nth 1 #d2$))
																	(< (+ (* 10 (##comp (nth 0 #pt1) (nth 0 #pt2)))
																		(##comp (nth 1 #pt1) (nth 1 #pt2))) 0)
																)
															))
		);progn
	);if

	(if #counters$$
		; カウンターがあり、且つ必要な場合
		(progn
			; 座標でソート
			(setq #counters$$ (vl-sort #counters$$
																'(lambda ( #d1$ #d2$ )
																	(setq #pt1 (nth 1 #d1$)
																				#pt2 (nth 1 #d2$))
																	(< (+ (* 10 (##comp (nth 0 #pt1) (nth 0 #pt2)))
																		(##comp (nth 1 #pt1) (nth 1 #pt2))) 0)
																)
															))
		);progn
	);if

	(list #frames$$ #counters$$)
);GetFrameInfo$$

;<HOM>*************************************************************************
; <関数名>    : GetMasterKanaguList$$
; <処理概要>  : 金具セット引き当てマスタから金具セットの品番と名称のリストの取得
; <戻り値>    : (LIST)金具セットの品番と名称とIDと1セットあたり個数のリスト
; <作成>      : 2017/06/16 KY
; <備考>      :
;*************************************************************************>MOH<
(defun GetMasterKanaguList$$ (
	/
	#rec$$
	#d$
	)

	(setq #rec$$
		(DBSqlAutoQuery CG_DBSESSION
			"SELECT DISTINCT ks.金具品番名称, t.備考2, ks.ID, ks.割る数 FROM 金具セット品番 ks, 階層 t WHERE ks.金具品番名称=t.階層名称 ORDER BY ks.ID"))

	(mapcar '(lambda (#d$) (list (nth 0 #d$) (nth 1 #d$) (fix (nth 2 #d$)) (fix (nth 3 #d$)))) #rec$$)
);GetMasterKanaguList$$

;<HOM>*************************************************************************
; <関数名>    : IntegrateKanaguCnt
; <処理概要>  : 金具セット引き当てマスタから金具の個数の積算
; <戻り値>    : (INT)金具の個数
; <作成>      : 2017/06/19 KY
; <備考>      :
;*************************************************************************>MOH<
(defun IntegrateKanaguCnt (
	&frameHinbans$ ; フレームの品番のリスト
;	&kanaguHinban ; 金具セットの品番
;	&kanaguId ; 金具セットのID
;	&kanaguCntPerSet ; 金具セットの1セット当たりの個数
	/
	#rec$$
	#rec$
	#frameHinban
	#cnt
	#addType
	#addFlg
	;#div
	#div2
	#ret
	)

;	(princ "\n------------")
;	(princ (strcat "\n★積算開始★　金具ｾｯﾄ品番: " &kanaguHinban))
;	(princ "\n------------")
	(setq #ret 0)

	(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
;			(strcat "SELECT 品番名称,個数,加算タイプ FROM 金具セット WHERE 金具品番ID="
;							(itoa &kanaguId)
;							" ORDER BY ID")))
			(strcat "SELECT 品番名称,個数,加算タイプ FROM 金具セット ORDER BY ID")))
	(if #rec$$
		(progn
			;(setq #div2 nil)
;			(setq #div2 &kanaguCntPerSet)
			(foreach #rec$ #rec$$
				(setq #addFlg nil) ; 1回のみの場合の加算済みフラグ(レコード単位)
				(setq #cnt (fix (nth 1 #rec$)))				;| 個数の整数部分を #cnt に代入 |;
				(setq #addType (fix (nth 2 #rec$)))			;| 加算タイプの整数部分を #addType に代入 |;
				;(setq #div (nth 2 #rec$))
				(foreach #frameHinban &frameHinbans$
					(princ (strcat "\n品番: " #frameHinban ))
					(if (= 1 (acet-str-find (nth 0 #rec$) #frameHinban nil T))	;| フレーム品番が品番名称(正規表現)でヒットした場合 |;
						(progn
							(cond
								((= #addType 0) ; 1回のみ加算
									(if (not #addFlg)
										(progn
											(princ "\n････1回のみ加算")
											(setq #ret (+ #ret #cnt))
										);progn
										;else
										(princ "\n････加算済みでスキップ")
									);if
									(setq #addFlg T)
								)
								((= #addType 1) ; 常に加算
									(princ "\n････常に加算")
									(setq #ret (+ #ret #cnt))
								)
							);cond
							;(setq #ret (+ #ret #cnt))
							(princ (strcat "【＋追加】 , 累積: "))(princ #ret)
							;(setq #div2 #div)
						);progn
					);if
				);foreach
			);foreach
;			(if (/= nil #div2)
;				(setq #ret (fix (/ (+ #ret (- #div2 1)) #div2))) ; 端数切り上げ
;				;else
;				(setq #ret 0)
;			);if
		);progn
	);if

;;;	(princ (strcat "\n金具ｾｯﾄ品番: " &kanaguHinban))(princ "個数: ")(princ  #ret)
	#ret
);IntegrateKanaguCnt

;<HOM>*************************************************************************
; <関数名>    : ReadHosokuCfg$$
; <処理概要>  : "HOSOKU.cfg"の内容の取得
; <戻り値>    : (LIST)品番/名称/個数/分類のリスト
; <作成>      : 2017/06/20 KY
; <備考>      :
;*************************************************************************>MOH<
(defun ReadHosokuCfg$$ (
	&funcChk ; 対象の選別のコールバック関数
	&funcOpt
	/
	#fname
	#temp
	#data$$	#data$ #hinban #cnt #name #bunrui
	#add
#DATA2$$ ;2017/07/13 YM ADD
	)

	(setq #data2$$ nil)
	(setq #fname (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
	(if (findfile #fname)
		(progn
			(setq #data$$ (ReadCSVFile #fname))
			(princ "\n #data$$= ")(princ #data$$)

			(if #data$$
				(progn
					(foreach #data$ #data$$
						(setq #temp (StrParse (nth 0 #data$) "="))
						(setq #hinban (nth 0 #temp))
						(setq #cnt (atoi (nth 1 #temp)))
						(setq #name (nth 1 #data$))
						(setq #bunrui (nth 2 #data$)) ; A(キッチン)のみ
						(if (/= nil &funcChk)
							(setq #add (eval (&funcChk #hinban &funcOpt)))
							;else
							(setq #add T)
						);if
						(if (and #add (> #cnt 0))
							(setq #data2$$ (append #data2$$ (list (list #hinban #name #cnt #bunrui))))
						);if
					);foreach
				);progn
			);if
		);progn
	);if

	#data2$$
);ReadHosokuCfg$$

;<HOM>*************************************************************************
; <関数名>    : WriteHosokuCfg
; <処理概要>  : "HOSOKU.cfg"の出力(上書き)
; <戻り値>    : なし
; <作成>      : 2017/06/21 KY
; <備考>      :
;*************************************************************************>MOH<
(defun WriteHosokuCfg (
	&data$$ ; 出力データ
	/
	#fname #fnameTmp #fd #canRen
	#err #errMsg
	)

	; CFGファイル書き出し
	(defun ##outputCfg (
		&afd &adata$$
		/
		#data$
		#hinban #name #cnt #bunrui
		)
		;;;;ファイル書き出し
		(foreach #data$ &adata$$
			(setq #hinban (nth 0 #data$))
			(setq #name (nth 1 #data$))
			(setq #cnt (nth 2 #data$))
			(setq #bunrui (nth 3 #data$))
			(write-line (strcat #hinban "=" (itoa #cnt) "," #name "," #bunrui) &afd)
		);foreach
		nil
	);##outputCfg

	(setq #fname (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
	(setq #fnameTmp (strcat #fname ".tmp"))
	;;;;ファイルオープン
	(setq #fd (open #fnameTmp "w"))
	(if #fd
		(progn ; オープン成功
			;;;;ファイル書き出し
			(setq #err (vl-catch-all-apply '##outputCfg (list #fd &data$$)))
			;;;;ファイルクローズ
			(close #fd)
			(if (vl-catch-all-error-p #err)
				(progn ; 異常時
					(setq #errMsg (vl-catch-all-error-message #err))
					(princ (strcat "\nﾌｧｲﾙに出力できませんでした(\"" #fnameTmp "\")\n" #errMsg "\n"))
					;;;;ファイル削除
					(if (not (vl-file-delete #fnameTmp))
						(princ (strcat "\nﾌｧｲﾙが削除できませんでした(\"" #fnameTmp "\")\n"))
					);if
				);progn
				;else
				(progn ; 正常時
					(setq #canRen T)
					(if (findfile #fname)
						;;;;ファイル削除
						(if (not (setq #canRen (vl-file-delete #fname)))
							(princ (strcat "\nﾌｧｲﾙが削除できませんでした(\"" #fname "\")\n"))
						);if
					);if
					(if #canRen
						;;;;ファイルコピー
						(if (not (vl-file-rename #fnameTmp #fname))
							(princ (strcat "\nﾌｧｲﾙが変名できませんでした(\"" #fnameTmp "\" ⇒ \"" #fname "\")\n"))
						);if
					);if
				);progn
			);if
		);progn
		;else
		(progn ; オープン失敗
			(princ (strcat "\nﾌｧｲﾙが開けませんでした(\"" #fnameTmp "\")\n"))
		);progn
	);if

	(princ)
);WriteHosokuCfg

;<HOM>*************************************************************************
; <関数名>    : GetKanaguCnt$$
; <処理概要>  : フレームキッチンの場合"HOSOKU.cfg"に出力されている金具セットの個数等を取得
; <戻り値>    : (LIST)金具セットの品番/名称/個数/分類/ID/1セットあたり個数のリスト
; <作成>      : 2017/06/13 KY
; <備考>      :
;*************************************************************************>MOH<
(defun GetKanaguCnt$$ (
	&masterKanaguList$$ ; 金具セットの品番/名称/ID/1セットあたり個数のリスト
	/
	#data$ #hinban #opt #id #qps
	#datatmp$
	#data$$
	#ret$$
	)

	(setq #data$$ (ReadHosokuCfg$$
				(lambda (#hinban #opt)
					(/= nil (assoc #hinban #opt))
				) &masterKanaguList$$))
	(princ "\nHOSOKU.cfgの金具の内容: ")(prin1 #data$$) ; debug用

	(setq #ret$$ nil)
	(foreach #data$ &masterKanaguList$$
		(setq #id (nth 2 #data$))
		(setq #qps (nth 3 #data$))
		(setq #data$ (list-remove-nth 3 #data$)) ; 1セットあたり個数の除去
		(setq #data$ (list-remove-nth 2 #data$)) ; IDの除去
		(if #data$$
			(setq #datatmp$ (assoc (nth 0 #data$) #data$$))
			;else
			(setq #datatmp$ nil)
		);if
		(if #datatmp$
			(setq #ret$$ (append #ret$$ (list (append #datatmp$ (list #id #qps)))))
			;else
			(setq #ret$$ (append #ret$$ (list (append #data$ (list 0 "A" #id #qps))))) ; A(キッチン)のみ
		);if
	);foreach

	#ret$$
);GetKanaguCnt$$

;<HOM>*************************************************************************
; <関数名>    : SaveKanaguCnt
; <処理概要>  : フレームキッチンの場合"HOSOKU.cfg"に金具セットの個数等を出力
; <戻り値>    : なし
; <作成>      : 2017/06/19 KY
; <備考>      :
;*************************************************************************>MOH<
(defun SaveKanaguCnt (
	&kanaguInfo$$ ; 金具セットの個数情報(自動積算フラグ付)
	/
	#data$ #data2$ #data$$ #dataAdd$$
	#kanaguInfo$
	)

	(setq #data$$ (ReadHosokuCfg$$ nil nil))
	(setq #dataAdd$$ nil)
	(foreach #kanaguInfo$ &kanaguInfo$$
		(if (nth 6 #kanaguInfo$) ; 金具セットの個数の反映必要(自動積算分)
			(progn
				(setq #data$ (assoc (nth 0 #kanaguInfo$) #data$$))
				(if #data$
					(progn ; 個数変更(個数が0でないものの自動積算はありえないが念のため)
						(setq #data2$ (list-put-nth (nth 2 #kanaguInfo$) #data$ 2)) ; ２番目の要素(個数)の設定
						(setq #data$$ (subst #data2$ #data$ #data$$)) ; リストへの書き戻し
					);progn
					;else
					(progn ; 追加
						(setq #data$ #kanaguInfo$)
						(setq #data$ (list-remove-nth 5 #data$)) ; ５番目の要素(1セットあたり個数)の除去
						(setq #data$ (list-remove-nth 4 #data$)) ; ４番目の要素(ID)の除去
						(setq #dataAdd$$ (append #dataAdd$$ (list #data$)))
					);progn
				);if
			);progn
		);if
	);foreach

	(WriteHosokuCfg (append #data$$ #dataAdd$$))

	(princ)
);SaveKanaguCnt

;<HOM>*************************************************************************
; <関数名>    : GetFrameType
; <処理概要>  : (フレームキッチン用)フレームの種類の取得
; <戻り値>    : (INT)縦フレーム=1/横フレーム=2/他=0/フレームキッチンでない=-1
; <作成>      : 2017/06/16 KY
; <備考>      :
;*************************************************************************>MOH<
(defun GetFrameType (
	&xd$ ; 拡張データ(G_SYM)
	&xdl$ ; 拡張データ(G_LSYM)
	/
	#hinban
	#dimW
	#dimH2
	#ft
	#ret
	#errmsg_ini
	#hinbanPtn_TF #hinbanPtn_YF
	)

	(setq #ret -1)
	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn
			(setq #errmsg_ini (strcat CG_SYSPATH "ERRMSG.INI"))
			(setq #hinbanPtn_TF (CFgetini "HINBAN_PTN" "TATEFRM" #errmsg_ini))
			(setq #hinbanPtn_YF (CFgetini "HINBAN_PTN" "YOKOFRM" #errmsg_ini))
			; 品番で判断
			(setq #hinban (nth 5 &xdl$)) ; G_LSYMの品番名称
			(cond
				((= 1 (acet-str-find #hinbanPtn_TF #hinban nil T))
					(setq #ret 1)
				)
				((= 1 (acet-str-find #hinbanPtn_YF #hinban nil T))
					(setq #ret 2)
				)
				(T
					(setq #ret 0)
				)
			);cond

			(if (= #ret 0)
				(progn
					; サイズで判断
					(setq #dimW (nth 3 &xd$)) ; G_SYMのｼﾝﾎﾞﾙ基準値W (実数)
					(setq #dimH2 (nth 13 &xdl$)) ; G_LSYMの寸法H (整数)
					(setq #ft 0)
					(if (< #dimW 50.0) ; 縦フレーム
						(setq #ft (logior #ft 1))
					);if
					(if (< #dimH2 50) ; 横フレーム
						(setq #ft (logior #ft 2))
					);if
					(cond
						((= #ft 1)
						 (setq #ret 1)
						)
						((= #ft 2)
						 (setq #ret 2)
						)
						(T
						 (setq #ret 0)
						)
					);cond
				);progn
			);if
		);progn
	);if

	#ret
);GetFrameType

;<HOM>*************************************************************************
; <関数名>    : IsCounter
; <処理概要>  : (フレームキッチン用)カウンターかどうか
; <戻り値>    : (BOOL)カウンター=T/カウンターでない=nil
; <作成>      : 2017/06/21 KY
; <備考>      :
;*************************************************************************>MOH<
(defun IsCounter (
	&xd$ ; 拡張データ(G_SYM)
	&xdl$ ; 拡張データ(G_LSYM)
	/
	#hinban
	#dimH
	#ret
	#errmsg_ini
	#hinbanPtn_CT
#XD$ ;2017/07/13 YM ADD
	)

	(setq #ret nil)
	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn
			(setq #errmsg_ini (strcat CG_SYSPATH "ERRMSG.INI"))
			(setq #hinbanPtn_CT (CFgetini "HINBAN_PTN" "COUNTER" #errmsg_ini))
			; 品番で判断
			(setq #hinban (nth 5 &xdl$)) ; G_LSYMの品番名称
			(if (= 1 (acet-str-find #hinbanPtn_CT #hinban nil T))
				(setq #ret T)
			);if

			(if (= #ret nil)
				(progn
					; サイズで判断
					(setq #dimH (nth 5 &xd$)) ; G_SYMのｼﾝﾎﾞﾙ基準値H (実数)
					(if (< #dimH 50.0)
						(setq #ret T)
					);if
				);progn
			);if
		);progn
	);if

	#ret
);IsCounter

;<HOM>*************************************************************************
; <関数名>    : list-put-nth
; <処理概要>  : リストの要素の入れ替え(インデックス指定)
; <戻り値>    : (LIST)入れ替え後のリスト
; <作成>      : 2017/06/20 KY
; <備考>      :
;*************************************************************************>MOH<
(defun list-put-nth (
	&newVal ; 新しい要素
	&data$ ; リスト
	&idx ; インデックス
	/
	#len
	#i
	#ret$
#RET #VAL ;2017/07/13 YM ADD
	)

	(setq #ret$ nil)
	(setq #len (length &data$))
	(setq #i 0)
	(while (< #i #len)
		(if (/= #i &idx)
			(setq #val (nth #i &data$))
			;else
			(setq #val &newVal)
		);if
		(setq #ret$ (append #ret$ (list #val)))
		(setq #i (1+ #i))
	);while
	#ret$
	;(acet-list-put-nth &newVal &data$ &idx)
);list-put-nth

;<HOM>*************************************************************************
; <関数名>    : list-remove-nth
; <処理概要>  : リストの要素の削除(インデックス指定)
; <戻り値>    : (LIST)削除後のリスト
; <作成>      : 2017/06/20 KY
; <備考>      :
;*************************************************************************>MOH<
(defun list-remove-nth (
	&idx ; インデックス
	&data$ ; リスト
	/
	#len
	#i
	#ret$
#RET ;2017/07/13 YM ADD
	)

	(setq #ret$ nil)
	(setq #len (length &data$))
	(setq #i 0)
	(while (< #i #len)
		(if (/= #i &idx)
			(setq #ret$ (append #ret$ (list (nth #i &data$))))
		);if
		(setq #i (1+ #i))
	);while
	#ret$
	;(acet-list-remove-nth &idx &data$)
);list-remove-nth


;2018/07/12 木製ｶｳﾝﾀｰ対応
(defun FixWCounterHinban (
  &hinban
  /
  #dcl_id #wcclr$$ #wcclr$ #hinban
  )

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##GetDlgItem (
    /
    #wcclrStr
    )

    (setq #wcclrStr (get_tile "wcclr"))
    (if (= #wcclrStr "")
      (progn
        (CFAlertMsg "ｶｳﾝﾀｰ色を選択して下さい。")
        (princ)
      );progn
      ;else
      (progn
        (done_dialog)
        (nth (atoi #wcclrStr) #wcclr$$)
      );progn
    );if
  );##GetDlgItem
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##SetWcClrList (
    /
    )

    (setq #wcclr$$ (DBSqlAutoQuery CG_DBSESSION
        "SELECT 画面選択肢文言, [6桁目], [12桁目] FROM 木製カウンタ色 ORDER BY ID"))
    (start_list "wcclr" 3)
    (foreach #wcclr$ #wcclr$$
      (add_list (nth 0 #wcclr$))
    );foreach
    (end_list)
    (princ)
  );##SetWcClrList
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "WCounterColorDlg" #dcl_id)) (exit))
  (##SetWcClrList)

  (setq #wcclr$ nil)
  (action_tile "accept" "(setq #wcclr$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #wcclr$ nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)

  (setq #hinban &hinban)
  (setq #hinban (vl-string-subst (nth 1 #wcclr$) "N$" #hinban))
  (setq #hinban (vl-string-subst (nth 2 #wcclr$) "@@" #hinban))
	(princ (strcat "* 木製ｶｳﾝﾀｰの品番(変換後)=" #hinban "\n"))

  #hinban
);FixWCounterHinban

;<HOM>*************************************************************************
; <関数名>    : KcChkWCounterItem$
; <処理概要>  : 木製ｶｳﾝﾀｰ設置
; <戻り値>    : 品番を変換した後の SELPARTS.CFG の内容リスト
; <作成>      : 2018/07/12
; <備考>      : 対象の品番でなければ $FIG$ をそのまま返す
;*************************************************************************>MOH<
(defun KcChkWCounterItem$ (
  &FIG$       ; SELPARTS.CFG の内容リスト
  /
  #hinban
  )

	(setq #hinban (nth 0 &FIG$))
  (if (CheckSpSetBuzai #hinban "木製カウンタ品番")
    (progn
      ;品番の変換(文字の置換)
      (cons (FixWCounterHinban #hinban) (cdr &FIG$))
    );progn
    ;else
    &FIG$
  );if
);KcSetWCounterItem

(princ)
