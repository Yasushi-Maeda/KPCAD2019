;;;2008/09/03YM@DEL;;;<HOF>************************************************************************
;;;2008/09/03YM@DEL;;; <ファイル名>: SCSelect.LSP                                                  
;;;2008/09/03YM@DEL;;; <システム名>: ****システム                                                
;;;2008/09/03YM@DEL;;; <最終更新日>: 00/03/15 中村 博伸                                            
;;;2008/09/03YM@DEL;;; <備考>      : なし                                                          
;;;2008/09/03YM@DEL;;;************************************************************************>FOH<
;;;2008/09/03YM@DEL;@@@(princ "\nSCSelect.fas をﾛｰﾄﾞ中...\n")
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL;<HOM>*************************************************************************
;;;2008/09/03YM@DEL; <関数名>    : C:SRSelect
;;;2008/09/03YM@DEL; <処理概要>  : 商品選択
;;;2008/09/03YM@DEL; <戻り値>    : なし
;;;2008/09/03YM@DEL; <作成>      :
;;;2008/09/03YM@DEL; <備考>      : なし
;;;2008/09/03YM@DEL;*************************************************************************>MOH<
;;;2008/09/03YM@DEL(defun C:SRSelect (
;;;2008/09/03YM@DEL    /
;;;2008/09/03YM@DEL    #key #kenmei$ #i #no
;;;2008/09/03YM@DEL    #dcl_id
;;;2008/09/03YM@DEL    #SRQry$ #SRQry$$
;;;2008/09/03YM@DEL    #ret$
;;;2008/09/03YM@DEL    #loop
;;;2008/09/03YM@DEL    #seri$
;;;2008/09/03YM@DEL    SG_SERIES_CHG
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL  (if (= CG_CDBSESSION nil)
;;;2008/09/03YM@DEL    (progn
;;;2008/09/03YM@DEL      (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
;;;2008/09/03YM@DEL    );_(progn
;;;2008/09/03YM@DEL  );_if
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL  (setq #SRQry$$
;;;2008/09/03YM@DEL    (DBSqlAutoQuery CG_CDBSESSION
;;;2008/09/03YM@DEL      "select * from SERIES where ユニット記号='K' order by \"SERIES記号\""
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL  );_setq
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL  (if CG_DEBUG
;;;2008/09/03YM@DEL    (setq *error* nil)
;;;2008/09/03YM@DEL    (StartUndoErr)
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL  (if (ssget "X" '((-3 ("G_LSYM"))))
;;;2008/09/03YM@DEL    (setq SG_SERIES_CHG nil)
;;;2008/09/03YM@DEL    (setq SG_SERIES_CHG T)
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL  (setq #seri$ (CFGetXRecord "SERI"))
;;;2008/09/03YM@DEL  (if #seri$
;;;2008/09/03YM@DEL    (progn
;;;2008/09/03YM@DEL      (setq CG_DBNAME      (nth  0 #seri$)) ; 1.DB名称        
;;;2008/09/03YM@DEL      (setq CG_SeriesCode  (nth  1 #seri$)) ; 2.SERIES記号  
;;;2008/09/03YM@DEL      (setq CG_BrandCode   (nth  2 #seri$)) ; 3.ブランド記号  
;;;2008/09/03YM@DEL      (setq CG_DRSeriCode  (nth  3 #seri$)) ; 4.扉SERIES記号
;;;2008/09/03YM@DEL      (setq CG_DRColCode   (nth  4 #seri$)) ; 5.扉COLOR記号  
;;;2008/09/03YM@DEL      (setq CG_UpCabHeight (nth  5 #seri$)) ; 6.取付高さ      
;;;2008/09/03YM@DEL      (setq CG_CeilHeight  (nth  6 #seri$)) ; 7.天井高さ      
;;;2008/09/03YM@DEL      (setq CG_RoomW       (nth  7 #seri$)) ; 8.間口          
;;;2008/09/03YM@DEL      (setq CG_RoomD       (nth  8 #seri$)) ; 9.奥行          
;;;2008/09/03YM@DEL      (setq CG_GasType     (nth  9 #seri$)) ;10.ガス種        
;;;2008/09/03YM@DEL      (setq CG_ElecType    (nth 10 #seri$)) ;11.電気種        
;;;2008/09/03YM@DEL      (setq CG_KikiColor   (nth 12 #seri$)) ;12.機器色        
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL    (progn
;;;2008/09/03YM@DEL      (CFYesDialog "商品情報を入力します")
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL;;;      (setq CG_SeriesCode  "PI") ; 00/10/02 YM DEL 影響をみるため
;;;2008/09/03YM@DEL      (setq CG_BrandCode   "N")
;;;2008/09/03YM@DEL      (setq CG_UpCabHeight 2350)
;;;2008/09/03YM@DEL      (setq CG_CeilHeight  2450)
;;;2008/09/03YM@DEL      (setq CG_RoomW       3600)
;;;2008/09/03YM@DEL      (setq CG_RoomD       3600)
;;;2008/09/03YM@DEL;      (setq CG_DRSeriCode  "41")
;;;2008/09/03YM@DEL;      (setq CG_DRColCode   "B")
;;;2008/09/03YM@DEL      (setq #seri$ T)
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;2008/09/03YM@DEL  ;// 商品選択ダイアログでＯＫが押された
;;;2008/09/03YM@DEL  (defun SRSelectOKClick ( / #ret$ #Qry$ )
;;;2008/09/03YM@DEL    (setq #Qry$ (nth (atoi (get_tile "seri")) #SRQry$$) )
;;;2008/09/03YM@DEL;;;     (princ "\n----------------------------------------------")
;;;2008/09/03YM@DEL;;;     (princ "\n(SRSelectOKClick) #Qry$=")(princ #Qry$)
;;;2008/09/03YM@DEL;;;     (princ "\n----------------------------------------------")
;;;2008/09/03YM@DEL;;;   #Qry$=(PIA K N K PI PI 1999秋  NewPI SK_PIA 0.0 1.0 0.0)
;;;2008/09/03YM@DEL;;; ("PIA" "K" "N" "K" "PI" "PI 1999秋 " "NewPI" "SK_PIA" 0.0 1.0 0.0)
;;;2008/09/03YM@DEL    ;// 各入力項目をグローバル設定
;;;2008/09/03YM@DEL    (setq CG_CeilHeight  (atoi (get_tile "hei")))
;;;2008/09/03YM@DEL    (setq CG_UpCabHeight (atoi (get_tile "uphei")))
;;;2008/09/03YM@DEL    (setq CG_RoomW       (atoi (get_tile "ww")))
;;;2008/09/03YM@DEL    (setq CG_RoomD       (atoi (get_tile "dd")))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    (setq CG_SeriesCode (car #Qry$))
;;;2008/09/03YM@DEL    (setq CG_BrandCode  (nth 2 #Qry$))
;;;2008/09/03YM@DEL    (setq CG_DBNAME      (nth 7 #Qry$))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    (done_dialog)
;;;2008/09/03YM@DEL    T
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL  (setq #loop T)
;;;2008/09/03YM@DEL  (while #loop
;;;2008/09/03YM@DEL    ;// 戻り値の初期設定
;;;2008/09/03YM@DEL    (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
;;;2008/09/03YM@DEL    (if (not (new_dialog "SRSelectDlg" #dcl_id)) (exit))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    ;// ｴﾃﾞｨｯﾄﾎﾞｯｸｽ
;;;2008/09/03YM@DEL    (set_tile "lab" "商品選択")  ;ﾀﾞｲｱﾛｸﾞﾀｲﾄﾙ
;;;2008/09/03YM@DEL    (set_tile "hei"   (itoa CG_CeilHeight))
;;;2008/09/03YM@DEL    (set_tile "uphei" (itoa CG_UpCabHeight))
;;;2008/09/03YM@DEL    (set_tile "ww"    (itoa CG_RoomW))
;;;2008/09/03YM@DEL    (set_tile "dd"    (itoa CG_RoomD))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL;;;DCL 文字列で使用できるコントロール文字
;;;2008/09/03YM@DEL;;;
;;;2008/09/03YM@DEL;;;コントロール文字   意 味
;;;2008/09/03YM@DEL;;;\"                 クォーテーション(文字列の内部)
;;;2008/09/03YM@DEL;;;\\                 円記号
;;;2008/09/03YM@DEL;;;\n                 改行
;;;2008/09/03YM@DEL;;;\t                 水平タブ
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    ;// ﾘｽﾄﾎﾞｯｸｽ
;;;2008/09/03YM@DEL    (start_list "seri" 3)
;;;2008/09/03YM@DEL    (setq #i 0)
;;;2008/09/03YM@DEL    (foreach #SRQry$ #SRQry$$
;;;2008/09/03YM@DEL      (add_list (strcat (nth 0 #SRQry$) "\t" "\t"
;;;2008/09/03YM@DEL                        (nth 2 #SRQry$) "\t"
;;;2008/09/03YM@DEL                        (nth 4 #SRQry$) "\t"
;;;2008/09/03YM@DEL                        (nth 5 #SRQry$)))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL      (if (and (= "PIA" (car #SRQry$))) ; YM2000.1.18
;;;2008/09/03YM@DEL        (setq #no #i)
;;;2008/09/03YM@DEL      )
;;;2008/09/03YM@DEL      (setq #i (1+ #i))
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    (end_list)
;;;2008/09/03YM@DEL    (if (/= #no nil)
;;;2008/09/03YM@DEL      (set_tile "seri" (itoa #no))
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL    (if (= SG_SERIES_CHG nil)
;;;2008/09/03YM@DEL      (progn
;;;2008/09/03YM@DEL        (mode_tile "seri" 1)
;;;2008/09/03YM@DEL        (set_tile "error" "既に部材が配置されているのでSERIESは変更できません")
;;;2008/09/03YM@DEL      )
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
;;;2008/09/03YM@DEL    (action_tile "accept" "(setq #ret (SRSelectOKClick))")
;;;2008/09/03YM@DEL    (action_tile "cancel" "(setq #ret nil)(done_dialog)")
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    (start_dialog)
;;;2008/09/03YM@DEL    (unload_dialog #dcl_id)
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    ;// OKが押された場合は図面の拡張レコードに選択情報を格納
;;;2008/09/03YM@DEL    (if #ret ; #ret=T
;;;2008/09/03YM@DEL      (progn
;;;2008/09/03YM@DEL        (setq #ret$
;;;2008/09/03YM@DEL         (SRSelectDoorSeriesDlg "扉SERIES選択"
;;;2008/09/03YM@DEL           CG_DBNAME
;;;2008/09/03YM@DEL           CG_SeriesCode
;;;2008/09/03YM@DEL           CG_DRSeriCode
;;;2008/09/03YM@DEL           CG_DRColCode
;;;2008/09/03YM@DEL         )
;;;2008/09/03YM@DEL       )
;;;2008/09/03YM@DEL        (if #ret$
;;;2008/09/03YM@DEL          (progn
;;;2008/09/03YM@DEL            (setq CG_DRSeriCode (car #ret$))
;;;2008/09/03YM@DEL            (setq CG_DRColCode (cadr #ret$))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL            ;// 間口領域の更新
;;;2008/09/03YM@DEL            (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL            ;// 図面の拡張レコードに商品情報を書き込む
;;;2008/09/03YM@DEL            (CFSetXRecord "SERI"
;;;2008/09/03YM@DEL              (list
;;;2008/09/03YM@DEL                CG_DBNAME       ; 1.DB名称        
;;;2008/09/03YM@DEL                CG_SeriesCode   ; 2.SERIES記号  
;;;2008/09/03YM@DEL                CG_BrandCode    ; 3.ブランド記号  
;;;2008/09/03YM@DEL                CG_DRSeriCode   ; 4.扉SERIES記号
;;;2008/09/03YM@DEL                CG_DRColCode    ; 5.扉COLOR記号  
;;;2008/09/03YM@DEL                CG_UpCabHeight  ; 6.取付高さ      
;;;2008/09/03YM@DEL                CG_CeilHeight   ; 7.天井高さ      
;;;2008/09/03YM@DEL                CG_RoomW        ; 8.間口          
;;;2008/09/03YM@DEL                CG_RoomD        ; 9.奥行          
;;;2008/09/03YM@DEL                CG_GasType      ;10.ガス種        
;;;2008/09/03YM@DEL                CG_ElecType     ;11.電気種        
;;;2008/09/03YM@DEL                CG_KikiColor    ;12.機器色        
;;;2008/09/03YM@DEL              )
;;;2008/09/03YM@DEL            )
;;;2008/09/03YM@DEL            ;// 自動保存
;;;2008/09/03YM@DEL            (CFAutoSave)
;;;2008/09/03YM@DEL            (setq #loop nil)
;;;2008/09/03YM@DEL          )
;;;2008/09/03YM@DEL        )
;;;2008/09/03YM@DEL      )
;;;2008/09/03YM@DEL    ;else
;;;2008/09/03YM@DEL      (setq #loop nil)
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL  (setq *error* nil)
;;;2008/09/03YM@DEL  (princ)
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL)
;;;2008/09/03YM@DEL;C:SRSelect

;<HOM>*************************************************************************
; <関数名>    : SRSetMaguti
; <処理概要>  : 間口領域を作成する
; <戻り値>    : なし
; <作成>      :
; <備考>      : なし
;*************************************************************************>MOH<
(defun SRSetMaguti (
    &RoomW
    &RoomD
    &Height
    /
    #ss
  )
  (if (setq #ss (ssget "X" '((-3 ("G_ROOM")))))
    (command "_erase" #ss "")
  )
  (setq &RoomD (* -1 &RoomD))
  (setvar "CECOLOR" "9")
  (MakeLWPolyLine
    (list
      (list 0 0 0)
      (list &RoomW 0 0)
      (list &RoomW &RoomD 0)
      (list 0 &RoomD 0)
    )
    1 0
  )
  (if (= nil (tblsearch "APPID" "G_ROOM")) (regapp "G_ROOM"))
  (CFSetXData (entlast) "G_ROOM" (list 1))
  (entmake
    (list
      '(0 . "POINT")
      '(100 . "AcDbEntity")
      '(100 . "AcDbPoint")
      (list 10 0.0 0.0 &Height)
    )
  )
  (setvar "CECOLOR" "BYLAYER")
  (CFSetXData (entlast) "G_ROOM" (list 2))

  (setvar "limmin" (list 0 &RoomD))
  (setvar "limmax" (list &RoomW 0))
  (command "zoom" "e")
;;;  (command "zoom" "0.9x") ; 06/05 YM
)
;SRSetMaguti

;<HOM>*************************************************************************
; <関数名>    : SRSelectDoorSeriesDlg
; <処理概要>  : 扉SERIES、COLORの選択
; <戻り値>    : なし
; <作成>      :
; <備考>      : なし
;*************************************************************************>MOH<
(defun SRSelectDoorSeriesDlg (
  &Title        ;(STR)ダイアログタイトル
  &DBName       ;(STR)対象データベース名
  &SeriCode     ;(STR)SERIES記号   引数優先 nil==>Xrecord 01/05/09 YM
  &DrSeriCode   ;(STR)扉SERIES記号 引数優先 nil可能 01/05/09 YM
  &DrColCode    ;(STR)扉COLOR記号   引数優先 nil可能 01/05/09 YM
  /
  #CG_SERIESCODE #DCL_ID #I #LST$ #NO #SERI$
   #MOJI_ICHI #MONGON
  )

  (if (/= CG_DBSESSION nil)
    (progn
      (dbDisconnect CG_DBSESSION)
      (setq CG_DBSESSION (dbconnect &DBName "" ""))
    )
    (progn
      (setq CG_DBSESSION (dbconnect &DBName "" ""))
    )
  )

  (if (= CG_DBSESSION nil)
    (progn
      (CFAlertMsg "SERIES別のデータベースがありませんでした")
      nil
    )
  ;else
    (progn
      ;// 現在の扉SERIES、扉COLORの設定
      (setq #seri$ (CFGetXRecord "SERI"))
      (if #seri$
        (setq #CG_SeriesCode  (nth 1 #seri$)) ; 2.SERIES記号
      )
      (setq SG_DRSERI$$
        (CFGetDBSQLRec CG_DBSESSION "扉シリズ"
          (list
            (if &SeriCode
              (list "SERIES記号" &SeriCode      'STR) ; 引数のｼﾘｰｽﾞ記号を優先
              (list "SERIES記号" #CG_SeriesCode 'STR) ; 引数のｼﾘｰｽﾞ記号を優先
            );_if
          )
        )
      )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;// 商品選択ダイアログでＯＫが押された
      (defun ##SRSelectDoorSeriesOK ( / #lst$ )
        (setq #lst$
          (list
            (nth 1 (nth (atoi (get_tile "drseri")) SG_DRSERI$$))
            (nth 2 (nth (atoi (get_tile "drcol"))  SG_DRCOL$$))
          )
        )
        (done_dialog)
        #lst$
      )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (defun ##SelectDoorSeries (
          /
          #seri #Qry$ #Qry$$ #i #no #sQ #Q$
        )
        (setq #seri (nth 1 (nth (atoi (get_tile "drseri")) SG_DRSERI$$)))
        ;;; (シリ記号   扉シリ記号   扉カラ記号) のリスト取得
        (setq SG_DRCOL$$
          (CFGetDBSQLRec CG_DBSESSION "扉シ管理"
          (list
            (list "扉シリ記号" #seri 'STR))
           )
        )

        ;;; SG_DRCOL$$に扉カラ名称を足す
        (setq #Qry$$ nil) ; 02/04/10 YM ADD
        (foreach #Qry$ SG_DRCOL$$
          (setq #Q$
            (car (CFGetDBSQLRec CG_DBSESSION "扉COLOR"
            (list
              (list "SERIES記号" (nth 0 #Qry$) 'STR)
              (list "扉カラ記号"   (nth 2 #Qry$) 'STR))
            ))
          )
          ; 02/04/10 YM ｴﾗｰ処理修正  (listp nil)='Tより、下記は無意味　#Q$=nilのときﾌﾘｰｽﾞする
;;;02/04/10YM@MOD         (setq #sQ
;;;02/04/10YM@MOD           (if (listp #Q$)
;;;02/04/10YM@MOD             (nth 2 #Q$)
;;;02/04/10YM@MOD             ""
;;;02/04/10YM@MOD           );_if
;;;02/04/10YM@MOD         )

;;;02/04/10YM@MOD             (setq #Qry$$ (append #Qry$$ (list (append #Qry$ (list #sQ)))))

           ; 02/04/10 YM ADD-S
          (if #Q$
            (progn
              (setq #sQ (nth 2 #Q$))
              (setq #Qry$$ (append #Qry$$ (list (append #Qry$ (list #sQ)))))
            )
          );_if
          ; 02/04/10 YM ADD-E

        );foreach

        (setq SG_DRCOL$$ #Qry$$)

;;; エラー処理追加 00/02/20 MH ADD
;;; SG_DRCOL$$が取れたか否かチェックして扉COLORリストBOXへの進行を制御する。
;;; とれていれば扉COLORリストBOXに代入。とれていなければ、エラーダイアログ表示&入力不可に
        (if (not SG_DRCOL$$)
          (progn
            (mode_tile "drseri" 2)
            (start_list "drcol" 3)
            (add_list "")
            (end_list)
            (mode_tile "drcol" 1)
            (mode_tile "accept" 1)
            (set_tile "error" "扉COLORが獲得できませんでした。")
          ); end of progn
          (progn
            (set_tile "lab" &Title)  ;ﾀﾞｲｱﾛｸﾞﾀｲﾄﾙ
            (start_list "drcol" 3)
            (setq #i 0 #no 0)

            (foreach #Qry$ SG_DRCOL$$
              ; 01/07/23 HN MOD 区切り文字を変更
              ;@MOD@(add_list (strcat (nth 2 #Qry$) "\t" (nth 3 #Qry$)))

              ;2008/3/12 YM MOD "ﾋｷﾃ"の文字があれば以降削除する
              (setq #mongon (nth 3 #Qry$))
              (setq #moji_ichi (vl-string-search  "ﾋｷﾃ" #mongon))
              (if #moji_ichi
                (setq #mongon (substr #mongon 1 #moji_ichi))
              );_if
              
              (add_list (strcat (nth 2 #Qry$) " ： " #mongon))
;;;              (add_list (strcat (nth 2 #Qry$) " ： " (nth 3 #Qry$)))

              (if (= &DrColCode (nth 2 #Qry$)) ; 引数使用 01/05/09 YM
                (setq #no #i)
              )
              (setq #i (1+ #i))
            )
            (end_list)
            (set_tile "error" "")
            (set_tile "drcol" (itoa #no))
            (mode_tile "drcol" 0)
            (mode_tile "accept" 0)
          ); end of progn
        ); end of if
      )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      ;// 戻り値の初期設定
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
      (if (not (new_dialog "DoorSelectDlg" #dcl_id)) (exit))

      ;// popup_list
      (set_tile "lab" "扉SERIES選択")  ;ﾀﾞｲｱﾛｸﾞﾀｲﾄﾙ
      (start_list "drseri" 3)

      (setq #i 0 #no 0)
      (foreach #Qry$ SG_DRSERI$$
        ; 01/07/04 HN MOD 区切り文字を変更
        ;@MOD@(add_list (strcat (nth 1 #Qry$) "\t" (nth 3 #Qry$)))
        (add_list (strcat (nth 1 #Qry$) " ： " (nth 3 #Qry$)))
        (if (= &DrSeriCode (nth 1 #Qry$)) ; 引数使用 01/05/09 YM
          (setq #no #i)
        )
        (setq #i (1+ #i))
      )
      (end_list)
      (set_tile "drseri" (itoa #no))
      (##SelectDoorSeries)

      ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
      (action_tile "accept" "(setq #lst$ (##SRSelectDoorSeriesOK))")
      (action_tile "drseri" "(##SelectDoorSeries)")
      (action_tile "cancel" "(setq #lst$ nil)(done_dialog)")

      (start_dialog)
      (unload_dialog #dcl_id)

      ;// OKが押された場合は図面の拡張レコードに選択情報を格納
      #lst$
    )
  )
);SRSelectDoorSeriesDlg

;<HOM>*************************************************************************
; <関数名>    : SRSelectDoorSeriesDlg_Handle
; <処理概要>  : 扉SERIES、COLORの選択(取手の選択も追加)
; <戻り値>    : なし
; <作成>      : 02/11/30 YM
; <備考>      : ミカドＳＸ対応
;*************************************************************************>MOH<
(defun SRSelectDoorSeriesDlg_Handle (
  &Title        ;(STR)ダイアログタイトル
  &DBName       ;(STR)対象データベース名
  &SeriCode     ;(STR)SERIES記号   引数優先 nil==>Xrecord 01/05/09 YM
  &DrSeriCode   ;(STR)扉SERIES記号 引数優先 nil可能 01/05/09 YM
  &DrColCode    ;(STR)扉COLOR記号   引数優先 nil可能 01/05/09 YM
  &DrHandleCode ;(STR)取手記号 02/11/30 YM
  /
  #CG_SERIESCODE #DCL_ID #I #LST$ #NO #SERI$
  )

  (if (/= CG_DBSESSION nil)
    (progn
      (dbDisconnect CG_DBSESSION)
      (setq CG_DBSESSION (dbconnect &DBName "" ""))
    )
    (progn
      (setq CG_DBSESSION (dbconnect &DBName "" ""))
    )
  )

;-- 2011/11/29 A.Satoh Add - S
	(if (= CG_DBSESSION nil)
		(progn
;;;			(princ "\n☆☆☆ セッション再取得 ☆☆☆")
;;;      (princ (strcat "\n☆☆☆　asilisp.arxを再ロードしてDBにCONNECT　☆☆☆"))

			; ARX再ロード
      (cond
        ((= "19" CG_ACADVER)
          (arxunload "asilispX19.arx")
          (arxload "asilispX19.arx")
        )
        ((= "18" CG_ACADVER)
          (arxunload "asilispX18.arx")
          (arxload "asilispX18.arx")
        )
        ((= "17" CG_ACADVER)
          (arxunload "asilispX17.arx")
          (arxload "asilispX17.arx")
        )
        ((= "16" CG_ACADVER)
          (arxunload "asilisp16.arx")
          (arxload "asilisp16.arx")
        )
      )

      (setq CG_DBSESSION  (dbconnect &DBName  "" ""))
		)
	)
;;;  (princ "\n☆☆☆　CG_DBSESSION　☆☆☆ :")(princ CG_DBSESSION)
;-- 2011/11/29 A.Satoh Add - E
  (if (= CG_DBSESSION nil)
    (progn
      (CFAlertMsg "SERIES別のデータベースがありませんでした")
      nil
    )
  ;else
    (progn
      ;扉ｼﾘｰｽﾞのﾘｽﾄ
      (setq SG_DRSERI$$
        (CFGetDBSQLRec CG_DBSESSION "扉シリズ"
          (list
            (list "廃番F" "0"  'INT)
          )
        )
      )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;// 商品選択ダイアログでＯＫが押された
      (defun ##SRSelectDoorSeriesOK ( / #lst$ )
        (setq #lst$
          (list
            (nth 0 (nth (atoi (get_tile "drseri")) SG_DRSERI$$))
            (nth 1 (nth (atoi (get_tile "drcol"))  SG_DRCOL$$ ))
            (nth 3 (nth (atoi (get_tile "handle")) SG_HANDLE$$))
          )
        )
        (done_dialog)
        #lst$
      )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (defun ##SelectDoorSeries (
        /
        #seri #Qry$ #Qry$$ #i #no #sQ #Q$ #COL #COL$
        )
        (setq #seri (nth 0 (nth (atoi (get_tile "drseri")) SG_DRSERI$$)))
        ;;; (シリ記号   扉シリ記号   扉カラ記号) のリスト取得
        (setq SG_DRCOL$$
          (CFGetDBSQLRec CG_DBSESSION "扉シ管理"
          (list
            (list "扉シリ記号" #seri 'STR))
           )
        )

        ;;; SG_DRCOL$$に扉カラ名称を足す
        (setq #Qry$$ nil) ; 02/04/10 YM ADD
        (foreach #Qry$ SG_DRCOL$$
          (setq #Q$
            (car (CFGetDBSQLRec CG_DBSESSION "扉COLOR"
            (list
              (list "扉カラ記号"   (nth 1 #Qry$) 'STR))
            ))
          )

          (if #Q$
            (progn
              (setq #sQ (nth 1 #Q$))
              (setq #Qry$$ (append #Qry$$ (list (append #Qry$ (list #sQ)))))
            )
          );_if

        );foreach

        (setq SG_DRCOL$$ #Qry$$)

;;; エラー処理追加 00/02/20 MH ADD
;;; SG_DRCOL$$が取れたか否かチェックして扉COLORリストBOXへの進行を制御する。
;;; とれていれば扉COLORリストBOXに代入。とれていなければ、エラーダイアログ表示&入力不可に
        (if (not SG_DRCOL$$)
          (progn
            (mode_tile "drseri" 2)
            (start_list "drcol" 3)
            (add_list "")
            (end_list)
            (mode_tile "drcol" 1)
            (mode_tile "accept" 1)
            (set_tile "error" "扉COLORが獲得できませんでした。")
          ); end of progn
          (progn
            (set_tile "lab" &Title)  ;ﾀﾞｲｱﾛｸﾞﾀｲﾄﾙ
            (start_list "drcol" 3)
            (setq #i 0 #no 0)

            (foreach #Qry$ SG_DRCOL$$
              ; 01/07/23 HN MOD 区切り文字を変更
              ;@MOD@(add_list (strcat (nth 2 #Qry$) "\t" (nth 3 #Qry$)))
							;2013/04/01 YM MOD-S
;;;              (add_list (strcat (nth 1 #Qry$) " ： " (nth 2 #Qry$)))
              (add_list (strcat (nth 2 #Qry$)))
							;2013/04/01 YM MOD-E
              (if (= &DrColCode (nth 1 #Qry$))
                (setq #no #i)
              )
              (setq #i (1+ #i))
            )
            (end_list)
            (set_tile "error" "")
            (set_tile "drcol" (itoa #no))
            (mode_tile "drcol" 0)
            (mode_tile "accept" 0)
          ); end of progn
        ); end of if

        (##SelectDoorHandle)

      );defun ##SelectDoorSeries
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (defun ##SelectDoorHandle ( ; 取手選択肢の変更 02/11/30 YM
        /
        #COL #COL$ #I #NO
        )

        ; 取手選択肢---------------------------------------------------------------
        (setq #col$ (nth (atoi (get_tile "drcol")) SG_DRCOL$$))
        (setq #dr_seri (nth 0 #col$))
        (setq #col (nth 1 #col$))

        (setq SG_HANDLE$$
          (CFGetDBSQLRec CG_DBSESSION "引手管理"
            (list
              (list "扉シリ記号"  #dr_seri  'STR)
              (list "扉カラ記号"  #col      'STR)
            )
          )
        )
        (start_list "handle" 3)
        (setq #i 0 #no 0)

        (foreach #Qry$ SG_HANDLE$$
          (add_list (strcat (nth 3 #Qry$) " ： " (nth 4 #Qry$)))
          (if (= &DrHandleCode (nth 3 #Qry$))
            (setq #no #i)
          )
          (setq #i (1+ #i))
        )
        (end_list)
        (set_tile "error" "")
        (set_tile "handle" (itoa #no))
        (mode_tile "handle" 0)
        (mode_tile "accept" 0)
      );defun ##SelectDoorHandle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      ;// 戻り値の初期設定
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
      (if (not (new_dialog "DoorSelectDlg_Handle" #dcl_id)) (exit))

      ;// popup_list
      (set_tile "lab" "扉SERIES選択")  ;ﾀﾞｲｱﾛｸﾞﾀｲﾄﾙ
      (start_list "drseri" 3)

;2011/09/14 YM ADD-S
;;;<ERRMSG.INI>
;;;;現在のｼﾘｰｽﾞ=WK_PSKB,現在の扉ｸﾞﾚｰﾄﾞ="R*"のときﾗｲﾄﾊﾟｯｹｰｼﾞ"X*"にｸﾞﾚｰﾄﾞ変更できない
;;;[DR_GRADE_PROHIBIT]
;;;WK_PSKB==RX
      ; 変更桁数の取得
      (setq #sDR_GRADE_PROHIBIT (CFgetini "DR_GRADE_PROHIBIT" CG_DBNAME (strcat CG_SKPATH "ERRMSG.INI")))
      ;2011/09/14 YM ADD-E

      (setq #i 0 #no 0)
			(setq #dum$$ nil)
      (foreach #Qry$ SG_DRSERI$$

        ;2011/09/14 YM ADD-S if文追加
        (setq #sDR_GRADE (strcat (substr &DrSeriCode 1 1) (substr (nth 0 #Qry$) 1 1)))
        (if (wcmatch #sDR_GRADE #sDR_GRADE_PROHIBIT)
          nil ;ﾘｽﾄに追加しない
          ;else
          (progn
            (add_list (strcat (nth 0 #Qry$) " ： " (nth 1 #Qry$)))
						(setq #dum$$ (append #dum$$ (list #Qry$)))
          )
        );_if
        ;2011/09/14 YM ADD-E if文追加

        (setq #i (1+ #i))
      );(foreach

			;2011/10/17 YM ADD 不具合修正
      (setq #i 0 #no 0)
			(setq SG_DRSERI$$ #dum$$)
      (foreach #Qry$ SG_DRSERI$$
        (if (= &DrSeriCode (nth 0 #Qry$))
          (setq #no #i)
        );_if
        (setq #i (1+ #i))
			);(foreach

      (end_list)
      (set_tile "drseri" (itoa #no))
      (##SelectDoorSeries)

      ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
      (action_tile "accept" "(setq #lst$ (##SRSelectDoorSeriesOK))")
      (action_tile "drseri" "(##SelectDoorSeries)")
      (action_tile "drcol"  "(##SelectDoorHandle)") ; 02/11/30 YM ADD
      (action_tile "cancel" "(setq #lst$ nil)(done_dialog)")

      (start_dialog)
      (unload_dialog #dcl_id)

      ;// OKが押された場合は図面の拡張レコードに選択情報を格納
      #lst$
    )
  )
);SRSelectDoorSeriesDlg_Handle

;<HOM>*************************************************************************
; <関数名>    : C:SetRoomInfo
; <処理概要>  : 部屋枠設定
; <戻り値>    : なし
; <作成>      : 2011/06
; <備考>      : 
;*************************************************************************>MOH<
(defun C:SetRoomInfo (
  /
  #RoomInfo$ #seri$
  )

; (alert "★★★　工事中　★★★")

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:SetRoomInfo ////")
  (CFOutStateLog 1 1 " ")

  ;// コマンドの初期化
  (StartUndoErr)
  (CFCmdDefBegin 0)
  (CFNoSnapReset)

  ; 部屋設定情報の入力（ダイアログ表示）
  (setq #RoomInfo$ (InputRoomInfo))
  (if #RoomInfo$
    (progn
      ; 部屋設定情報の反映
      (setq CG_RoomW (nth 0 #RoomInfo$))        ; 画面領域Ｘ方向
      (setq CG_RoomD (nth 1 #RoomInfo$))        ; 画面領域Ｙ方向
      (setq CG_CeilHeight (nth 2 #RoomInfo$))   ; 天井高さ
      (setq CG_UpCabHeight (nth 3 #RoomInfo$))  ; 吊元高さ
;-- 2011/09/21 A.Satoh Add - S
      (setq CG_GasType (nth 4 #RoomInfo$))  ; ガス種
;-- 2011/09/21 A.Satoh Add - E

      ; 間口領域の再描画
      (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)

      ; 図面の拡張データを更新する
      (setq #seri$
        (list
          CG_DBNAME       ; DB名称
          CG_SeriesCode   ; SERIES記号
          CG_BrandCode    ; ブランド記号
          CG_DRSeriCode   ; 扉SERIES記号
          CG_DRColCode    ; 扉COLOR記号
          CG_HIKITE       ; ヒキテ記号
          CG_UpCabHeight  ; 取付高さ
          CG_CeilHeight   ; 天井高さ
          CG_RoomW        ; 間口
          CG_RoomD        ; 奥行
          CG_GasType      ; ガス種
          CG_ElecType     ; 電気種
          CG_KikiColor    ; 機器色
          CG_KekomiCode   ; ケコミ飾り
        )
      )
      (CFSetXRecord "SERI" #seri$)

      ; PlanInfo.cfgの変更
      (ChangePlanInfo)
    )
  )

  (CFNoSnapFinish)
  (CFCmdDefFinish)
  (setq *error* nil)

  (princ)

);C:SetRoomInfo

;<HOM>*************************************************************************
; <関数名>    : InputRoomInfo
; <処理概要>  : 部屋設定情報の入力
; <戻り値>    : 部屋設定情報リスト
;             :  (画面領域Ｘ方向 画面領域Ｙ方向 天井高さ 吊元高さ)
;             :   (3600 3600 2450 2350) or nil
; <作成>      :
; <備考>      : なし
;*************************************************************************>MOH<
(defun InputRoomInfo (
  /
  #dcl_id #next #room_info$
;-- 2011/09/21 A.Satoh Add - S
  #err_flag #GAS$$ #GAS$ #idx #def
;-- 2011/09/21 A.Satoh Add - E
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;// 文字列が数値文字か否かをチェックする
    (defun ##IsNumeric(
      &str  ;数値チェック対象文字列
      /
      #i #flg #str
      )

      (setq #i 1)
      (setq #flg T)
      (repeat (strlen &str)
        (if (= #flg T)
          (progn
            (setq #str (substr &str #i 1))
            (if (= nil (wcmatch #str "#"))
              (setq #flg nil)
            )
          )
        )
        (setq #i (1+ #i))
      )

      #flg
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;// 部屋設定ダイアログでＯＫが押された
    (defun ##SetRoomInfo_CallBack(
      /
;;; #GAS$$はローカル定義しない
      #lst$ #dist_x #dist_y #ceil_h #hang_h #err_flg
;-- 2011/09/21 A.Satoh Add - S
      #gas_idx #idx #gas
;-- 2011/09/21 A.Satoh Add - E
      )

      (setq #err_flg nil)

      ; 画面領域Ｘ方向の入力チェック
      (setq #dist_x (get_tile "DIST_X"))
      (if (= #dist_x "")
        (progn
          (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
					(mode_tile "DIST_X" 2)
;-- 2011/12/17 A.Satoh Add - E
          (set_tile "error" "「画面領域Ｘ方向」を入力して下さい")
        )
;-- 2011/12/17 A.Satoh Mod - S
				(if (and (/= (type (read #dist_x)) 'INT) (/= (type (read #dist_x)) 'REAL))
;;;;;        (if (= nil (##IsNumeric #dist_x))
;-- 2011/12/17 A.Satoh Mod - E
          (progn
            (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
						(mode_tile "DIST_X" 2)
;-- 2011/12/17 A.Satoh Add - E
            (set_tile "error" "「画面領域Ｘ方向」は数値のみ入力可能です")
          )
;-- 2011/12/17 A.Satoh Mod - S
          (if (< (read #dist_x) 0)
;;;;;          (if (< (fix (atoi #dist_x)) 0)
;-- 2011/12/17 A.Satoh Mod - E
            (progn
              (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
		 					(mode_tile "DIST_X" 2)
;-- 2011/12/17 A.Satoh Add - E
							(set_tile "error" "「画面領域Ｘ方向」がマイナス値で入力されています")
            )
          )
        )
      )

      ; 画面領域Ｙ方向の入力チェック
      (if (= #err_flg nil)
        (progn
          (setq #dist_y (get_tile "DIST_Y"))
          (if (= #dist_y "")
            (progn
              (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
							(mode_tile "DIST_Y" 2)
;-- 2011/12/17 A.Satoh Add - E
              (set_tile "error" "「画面領域Ｙ方向」を入力して下さい")
            )
;-- 2011/12/17 A.Satoh Mod - S
						(if (and (/= (type (read #dist_y)) 'INT) (/= (type (read #dist_y)) 'REAL))
;;;;;            (if (= nil (##IsNumeric #dist_y))
;-- 2011/12/17 A.Satoh Mod - E
              (progn
                (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
								(mode_tile "DIST_Y" 2)
;-- 2011/12/17 A.Satoh Add - E
                (set_tile "error" "「画面領域Ｙ方向」は数値のみ入力可能です")
              )
;-- 2011/12/17 A.Satoh Mod - S
;;;;;              (if (< (fix (atoi #dist_y)) 0)
							(if (< (read #dist_y) 0)
;-- 2011/12/17 A.Satoh Mod - E
                (progn
                  (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
									(mode_tile "DIST_Y" 2)
;-- 2011/12/17 A.Satoh Add - E
                  (set_tile "error" "「画面領域Ｙ方向」がマイナス値で入力されています")
                )
              )
            )
          )
        )
      )

      ; 天井高さの入力チェック
      (if (= #err_flg nil)
        (progn
          (setq #ceil_h (get_tile "CEIL_H"))
          (if (= #ceil_h "")
            (progn
              (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
							(mode_tile "CEIL_H" 2)
;-- 2011/12/17 A.Satoh Add - E
              (set_tile "error" "「天井高さ」を入力して下さい")
            )
;-- 2011/12/17 A.Satoh Mod - S
						(if (and (/= (type (read #ceil_h)) 'INT) (/= (type (read #ceil_h)) 'REAL))
;;;;;            (if (= nil (##IsNumeric #ceil_h))
;-- 2011/12/17 A.Satoh Mod - E
              (progn
                (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
								(mode_tile "CEIL_H" 2)
;-- 2011/12/17 A.Satoh Add - E
                (set_tile "error" "「天井高さ」は数値のみ入力可能です")
              )
;-- 2011/12/17 A.Satoh Mod - S
;;;;;              (if (< (fix (atoi #ceil_h)) 0)
              (if (< (read #ceil_h) 0)
;-- 2011/12/17 A.Satoh Mod - E
                (progn
                  (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
		 							(mode_tile "CEIL_H" 2)
;-- 2011/12/17 A.Satoh Add - E
									(set_tile "error" "「天井高さ」がマイナス値で入力されています")
                )
              )
            )
          )
        )
      )

      ; 吊元高さの入力チェック
      (if (= #err_flg nil)
        (progn
          (setq #hang_h (get_tile "HANG_H"))
          (if (= #hang_h "")
            (progn
              (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
							(mode_tile "HANG_H" 2)
;-- 2011/12/17 A.Satoh Add - E
              (set_tile "error" "「吊元高さ」を入力して下さい")
            )
;-- 2011/12/17 A.Satoh Mod - S
						(if (and (/= (type (read #hang_h)) 'INT) (/= (type (read #hang_h)) 'REAL))
;;;;;            (if (= nil (##IsNumeric #hang_h))
              (progn
;-- 2011/12/17 A.Satoh Mod - E
                (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
								(mode_tile "HANG_H" 2)
;-- 2011/12/17 A.Satoh Add - E
                (set_tile "error" "「吊元高さ」は数値のみ入力可能です")
              )
;-- 2011/12/17 A.Satoh Mod - S
;;;;;              (if (< (fix (atoi #hang_h)) 0)
              (if (< (read #hang_h) 0)
;-- 2011/12/17 A.Satoh Mod - E
                (progn
                  (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
									(mode_tile "HANG_H" 2)
;-- 2011/12/17 A.Satoh Add - E
                  (set_tile "error" "「吊元高さ」がマイナス値で入力されています")
                )
;-- 2011/12/17 A.Satoh Add - S
								(if (> (fix (atoi #hang_h)) (fix (atoi #ceil_h)))
									(progn
										(setq #err_flg T)
										(mode_tile "HANG_H" 2)
	                  (set_tile "error" "「吊元高さ」は「天井高さ」以下で入力して下さい")
									)
								)
;-- 2011/12/17 A.Satoh Add - E
              )
            )
          )
        )
      )

;-- 2011/09/21 A.Satoh Add - S
      (if (= #err_flag nil)
        (progn
          (setq #gas_idx (atoi (get_tile "GAS_TYPE")))
          (setq #idx 0)
          (repeat (length #GAS$$)
            (if (= #gas_idx #idx)
              (setq #gas (nth 0 (nth #idx #GAS$$)))
            )
            (setq #idx (1+ #idx))
          )
        )
      )
;-- 2011/09/21 A.Satoh Add - E

      (if (= #err_flg nil)
        (progn
          (setq #lst$
            (list
              (fix (atoi #dist_x))
              (fix (atoi #dist_y))
              (fix (atoi #ceil_h))
              (fix (atoi #hang_h))
;-- 2011/09/21 A.Satoh Add - S
              #gas
;-- 2011/09/21 A.Satoh Add - E
            )
          )
          (done_dialog 1)
        )
        (setq #lst$ nil)
      )

      #lst$
    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-- 2011/09/21 A.Satoh Add - S
  (setq #err_flag nil)

  ; mdbより【ガス種】情報一覧を取得する
  (setq #GAS$$ (DBSqlAutoQuery CG_CDBSESSION "select * from ガス種"))
  (if #GAS$$
    (progn
      (setq #GAS$$ (CFListSort #GAS$$ 1))
    )
    (progn
      (CFAlertMsg "【ガス種】にﾚｺｰﾄﾞがありません。")
      (setq #room_info$ nil)
      (setq #err_flag T)
    )
  )

  (if (= #err_flag nil)
    (progn
;-- 2011/09/21 A.Satoh Add - E

  ; DCLロード
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "SetRoomInfo.dcl")))
;-- 2011/09/21 A.Satoh Add - S
  (if (not (new_dialog "SetRoomInfoDlg" #dcl_id)) (exit))

  ; 初期値設定
  (set_tile "DIST_X" (itoa CG_RoomW))       ; 画面領域Ｘ方向
  (set_tile "DIST_Y" (itoa CG_RoomD))       ; 画面領域Ｙ方向
  (set_tile "CEIL_H" (itoa CG_CeilHeight))  ; 天井高さ
  (set_tile "HANG_H" (itoa CG_UpCabHeight)) ; 吊元高さ
  (start_list "GAS_TYPE" 3)
  (foreach #GAS$ #GAS$$
    (add_list (nth 0 #GAS$))
  )
  (end_list)

  (setq #idx 0)
  (setq #def 0)
  (repeat (length #GAS$$)
    (if (= (nth 0 (nth #idx #GAS$$)) CG_GasType)
      (setq #def #idx)
    )
    (setq #idx (1+ #idx))
  )
  (set_tile "GAS_TYPE" (itoa #def))
;-- 2011/09/21 A.Satoh Add - E

  (setq #next 99)
  (while (and (/= 1 #next) (/= 0 #next))
;-- 2011/09/21 A.Satoh Del - S
;;;;;    (if (not (new_dialog "SetRoomInfoDlg" #dcl_id)) (exit))
;;;;;
;;;;;   ; 初期値設定
;;;;;   (set_tile "DIST_X" (itoa CG_RoomW))       ; 画面領域Ｘ方向
;;;;;   (set_tile "DIST_Y" (itoa CG_RoomD))       ; 画面領域Ｙ方向
;;;;;   (set_tile "CEIL_H" (itoa CG_CeilHeight))  ; 天井高さ
;;;;;   (set_tile "HANG_H" (itoa CG_UpCabHeight)) ; 吊元高さ
;-- 2011/09/21 A.Satoh Del - E

    ; ボタン押下処理
    (action_tile "accept" "(setq #room_info$ (##SetRoomInfo_CallBack))")
    (action_tile "cancel" "(setq #room_info$ nil)(done_dialog 0)")

    (setq #next (start_dialog))
  )

  (unload_dialog #dcl_id)
;-- 2011/09/21 A.Satoh Add - S
    )
  )
;-- 2011/09/21 A.Satoh Add - E

  #room_info$

) ;InputRoomInfo


;;;<HOM>***********************************************************************
;;; <関数名>    : ChangePlanInfo
;;; <処理概要>  : PlanInfo.cfgを更新する(部屋設定用)
;;; <戻り値>    : なし
;;; <作成>      : 11/06/30 A.Satoh
;;; <備考>      :
;;;***********************************************************************>MOH<
(defun ChangePlanInfo (
  /
  #fp #PLANINFO$ #sFname #elm
  )

  ; 現在のプラン情報(PLANINFO.CFG)を読み込む
  (setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))

  ; 項目の更新
  (if (assoc "Width" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "Width" (itoa CG_RoomW))(assoc "Width" #PLANINFO$) #PLANINFO$))
  );_if
  (if (assoc "Depth" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "Depth" (itoa CG_RoomD))(assoc "Depth" #PLANINFO$) #PLANINFO$))
  );_if
  (if (assoc "CeilingHeight" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "CeilingHeight" (itoa CG_CeilHeight))(assoc "CeilingHeight" #PLANINFO$) #PLANINFO$))
  );_if
  (if (assoc "SetHeight" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "SetHeight" (itoa CG_UpCabHeight))(assoc "SetHeight" #PLANINFO$) #PLANINFO$))
  );_if
;-- 2011/09/21 A.Satoh Add - S
  (if (assoc "GasType" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "GasType" CG_GasType)(assoc "GasType" #PLANINFO$) #PLANINFO$))
  );_if
;-- 2011/09/21 A.Satoh Add - E

  (setq #sFname (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
  (setq #fp  (open #sFname "w"))
  (if (/= nil #fp)
    (progn
      (foreach #elm #PLANINFO$
        (if (= ";" (substr (car #elm) 1 1))
          (princ (car #elm) #fp)
          ;else
          (progn
            (if (= (car #elm) "") ; if文分岐 03/07/22 YM ADD
              nil ; 空行(何も書かない)
							;else
							(progn
								(if (= (cadr #elm) nil) ; if文分岐 2011/10/14 YM ADD
									(princ (car #elm) #fp)
									;else
            			(princ (strcat (car #elm) "=" (cadr #elm)) #fp)
								);_if
							)
            );_if
          )
        );_if
        (princ "\n" #fp)
      );foreach
      (close #fp)
    )
    (progn
      (CFAlertMsg "PLANINFO.CFGへの書き込みに失敗しました。")
      (quit)
    )
  );_if

);ChangePlanInfo


;-- 2011/10/06 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : InputInitInfoDlg
; <処理概要>  : シリーズしか決っていない状態でのKPCAD起動直後に下記情報を設定する
;             :  ・扉グレード
;             :  ・扉色
;             :  ・引手
;             :  ・ガス種
;             :  ・天井高さ
;             :  ・取付高さ
;             :  ・部屋枠X,Y
; <戻り値>    : 設定情報リスト
;             :  (扉グレード 扉色 引手 画面領域Ｘ方向 画面領域Ｙ方向 天井高さ 吊元高さ ガス種)
;             :   ("RF" "G" "J" 3600 3600 2450 2350 "13A") or nil
; <作成>      :
; <備考>      : なし
;*************************************************************************>MOH<
;;;(defun C:qqq (
;;;  /
;;;  #planInfo$
;;;  )
;;;
;;;  (setq #planInfo$ (InputInitInfoDlg))
;;;  (if #planInfo$
;;;    (progn
;;;      (setq CG_DRSeriCode  (nth 0 #planInfo$))
;;;      (setq CG_DRColCode   (nth 1 #planInfo$))
;;;      (setq CG_Hikite      (nth 2 #planInfo$))
;;;      (setq CG_RoomW       (nth 3 #planInfo$))
;;;      (setq CG_RoomD       (nth 4 #planInfo$))
;;;      (setq CG_CeilHeight  (nth 5 #planInfo$))
;;;      (setq CG_UpCabHeight (nth 6 #planInfo$))
;;;      (setq CG_GasType     (nth 7 #planInfo$))
;;;    )
;;;  )
;;;(princ "\nCG_DRSeriCode  = ") (princ CG_DRSeriCode)
;;;(princ "\nCG_DRColCode   = ") (princ CG_DRColCode)
;;;(princ "\nCG_Hikite      = ") (princ CG_Hikite)
;;;(princ "\nCG_RoomW       = ") (princ CG_RoomW)
;;;(princ "\nCG_RoomD       = ") (princ CG_RoomD)
;;;(princ "\nCG_CeilHeight  = ") (princ CG_CeilHeight)
;;;(princ "\nCG_UpCabHeight = ") (princ CG_UpCabHeight)
;;;(princ "\nCG_GasType     = ") (princ CG_GasType)
;;;
;;;)
;;;
(defun InputInitInfoDlg (
  /
  #err_flag #info$ #DRSERI$$ #DRCOL$$ #HANDLE$$ #GAS$$
  #dcl_id #i #no #Qry$ #GAS$ #next #sDR_GRADE_PROHIBIT #sDR_GRADE
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (defun ##SelDoorSeries (
      /
      ;;; #DRSERI$$ #DRCOL$$はローカル定義しない
      #seri #Qry$$ #Qry$ #Q$ #sQ #i #no
      )

      (setq #seri (nth 0 (nth (atoi (get_tile "drseri")) #DRSERI$$)))
      ;;; (シリ記号   扉シリ記号   扉カラ記号) のリスト取得
      (setq #DRCOL$$
        (CFGetDBSQLRec CG_DBSESSION "扉シ管理"
          (list
            (list "扉シリ記号" #seri 'STR)
          )
        )
      )

      ;;; SG_DRCOL$$に扉カラ名称を足す
      (setq #Qry$$ nil) ; 02/04/10 YM ADD
      (foreach #Qry$ #DRCOL$$
        (setq #Q$
          (car (CFGetDBSQLRec CG_DBSESSION "扉COLOR"
            (list
              (list "扉カラ記号"   (nth 1 #Qry$) 'STR)
            )
          ))
        )

        (if #Q$
          (progn
            (setq #sQ (nth 1 #Q$))
            (setq #Qry$$ (append #Qry$$ (list (append #Qry$ (list #sQ)))))
          )
        )
      )

      (setq #DRCOL$$ #Qry$$)

      (if (not #DRCOL$$)
        (progn
          (mode_tile "drseri" 2)
          (start_list "drcol" 3)
          (add_list "")
          (end_list)
          (mode_tile "drcol" 1)
          (mode_tile "accept" 1)
          (set_tile "error" "扉COLORが獲得できませんでした。")
        )
        (progn
          (start_list "drcol" 3)
          (setq #i 0 #no 0)

          (foreach #Qry$ #DRCOL$$
						;2013/04/01 YM MOD-S
;;;            (add_list (strcat (nth 1 #Qry$) " ： " (nth 2 #Qry$)))
            (add_list (strcat (nth 2 #Qry$)))
						;2013/04/01 YM MOD-E
            (if (= CG_DRColCode (nth 1 #Qry$))
              (setq #no #i)
            )
            (setq #i (1+ #i))
          )
          (end_list)
          (set_tile "error" "")
          (set_tile "drcol" (itoa #no))
          (mode_tile "drcol" 0)
          (mode_tile "accept" 0)
        )
      )

      (##SelDoorHandle)

    ) ; ##SelDoorSeries

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (defun ##SelDoorHandle ( ; 取手選択肢の変更 02/11/30 YM
      /
      ;;; #DRCOL$$ #HANDLE$$はローカル定義しない
      #col$ #dr_seri #col #i #no #Qry$
      )

      ; 取手選択肢---------------------------------------------------------------
      (setq #col$ (nth (atoi (get_tile "drcol")) #DRCOL$$))
      (setq #dr_seri (nth 0 #col$))
      (setq #col (nth 1 #col$))

      (setq #HANDLE$$
        (CFGetDBSQLRec CG_DBSESSION "引手管理"
          (list
            (list "扉シリ記号"  #dr_seri  'STR)
            (list "扉カラ記号"  #col      'STR)
          )
        )
      )
      (start_list "handle" 3)
      (setq #i 0 #no 0)

      (foreach #Qry$ #HANDLE$$
        (add_list (strcat (nth 3 #Qry$) " ： " (nth 4 #Qry$)))
        (if (= CG_Hikite (nth 3 #Qry$))
          (setq #no #i)
        )
        (setq #i (1+ #i))
      )
      (end_list)
      (set_tile "error" "")
      (set_tile "handle" (itoa #no))
      (mode_tile "handle" 0)
      (mode_tile "accept" 0)

   ); ##SelDoorHandle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;// 文字列が数値文字か否かをチェックする
    (defun ##IsNumeric(
      &str  ;数値チェック対象文字列
      /
      #i #flg #str
      )

      (setq #i 1)
      (setq #flg T)
      (repeat (strlen &str)
        (if (= #flg T)
          (progn
            (setq #str (substr &str #i 1))
            (if (= nil (wcmatch #str "#"))
              (setq #flg nil)
            )
          )
        )
        (setq #i (1+ #i))
      )

      #flg
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;// ダイアログ上に初期値を設定する
    (defun ##ResetInitInfo(
      &sDR_GRADE_PROHIBIT ; ERRMSG.ini DR_GRADE_PROHIBIT情報
      /
			#i #no #Qry$ #sDR_GRADE
			#GAS$ #idx #def
      )

      ; 扉関連
      (start_list "drseri" 3)
      (setq #i 0 #no 0)
      (foreach #Qry$ #DRSERI$$
;-- 2011/10/17 A.Satoh Mod - S
;;;;;        (setq #sDR_GRADE (strcat (substr CG_DRSeriCode 1 1) (substr (nth 0 #Qry$) 1 1)))
;;;;;        (if (wcmatch #sDR_GRADE &sDR_GRADE_PROHIBIT)
;;;;;          nil ;ﾘｽﾄに追加しない
;;;;;          (progn
;;;;;            (add_list (strcat (nth 0 #Qry$) " ： " (nth 1 #Qry$)))
;;;;;          )
;;;;;        )
        (add_list (strcat (nth 0 #Qry$) " ： " (nth 1 #Qry$)))
;-- 2011/10/17 A.Satoh Mod - S

        (if (= CG_DRSeriCode (nth 0 #Qry$))
          (setq #no #i)
        )
        (setq #i (1+ #i))
      )
      (end_list)

      (set_tile "drseri" (itoa #no))
      (##SelDoorSeries)

      (set_tile "DIST_X" (itoa CG_RoomW))       ; 画面領域Ｘ方向
      (set_tile "DIST_Y" (itoa CG_RoomD))       ; 画面領域Ｙ方向
      (set_tile "CEIL_H" (itoa CG_CeilHeight))  ; 天井高さ
      (set_tile "HANG_H" (itoa CG_UpCabHeight)) ; 吊元高さ

      ; ガス種リスト
      (start_list "GAS_TYPE" 3)
      (foreach #GAS$ #GAS$$
        (add_list (nth 0 #GAS$))
      )
      (end_list)

      (setq #idx 0)
      (setq #def 0)
      (repeat (length #GAS$$)
        (if (= (nth 0 (nth #idx #GAS$$)) CG_GasType)
          (setq #def #idx)
        )
        (setq #idx (1+ #idx))
      )
      (set_tile "GAS_TYPE" (itoa #def))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;// 部屋設定ダイアログでＯＫが押された
    (defun ##SetInitInfo_CallBack(
      /
;;; #DRSERI$$ #DRCOL$$ #HANDLE$$ #GAS$$はローカル定義しない
      #err_flg #dist_x #dist_y #ceil_h #hang_h #gas_idx #idx
      #gas #lst$
      )

      (setq #err_flg nil)

      ; 画面領域Ｘ方向の入力チェック
      (setq #dist_x (get_tile "DIST_X"))
      (if (= #dist_x "")
        (progn
          (setq #err_flg T)
          (set_tile "error" "「画面領域Ｘ方向」を入力して下さい")
        )
        (if (= nil (##IsNumeric #dist_x))
          (progn
            (setq #err_flg T)
            (set_tile "error" "「画面領域Ｘ方向」は数値のみ入力可能です")
          )
          (if (< (fix (atoi #dist_x)) 0)
            (progn
              (setq #err_flg T)
              (set_tile "error" "「画面領域Ｘ方向」がマイナス値で入力されています")
            )
          )
        )
      )

      ; 画面領域Ｙ方向の入力チェック
      (if (= #err_flg nil)
        (progn
          (setq #dist_y (get_tile "DIST_Y"))
          (if (= #dist_y "")
            (progn
              (setq #err_flg T)
              (set_tile "error" "「画面領域Ｙ方向」を入力して下さい")
            )
            (if (= nil (##IsNumeric #dist_y))
              (progn
                (setq #err_flg T)
                (set_tile "error" "「画面領域Ｙ方向」は数値のみ入力可能です")
              )
              (if (< (fix (atoi #dist_y)) 0)
                (progn
                  (setq #err_flg T)
                  (set_tile "error" "「画面領域Ｙ方向」がマイナス値で入力されています")
                )
              )
            )
          )
        )
      )

      ; 天井高さの入力チェック
      (if (= #err_flg nil)
        (progn
          (setq #ceil_h (get_tile "CEIL_H"))
          (if (= #ceil_h "")
            (progn
              (setq #err_flg T)
              (set_tile "error" "「天井高さ」を入力して下さい")
            )
            (if (= nil (##IsNumeric #ceil_h))
              (progn
                (setq #err_flg T)
                (set_tile "error" "「天井高さ」は数値のみ入力可能です")
              )
              (if (< (fix (atoi #ceil_h)) 0)
                (progn
                  (setq #err_flg T)
                  (set_tile "error" "「天井高さ」がマイナス値で入力されています")
                )
              )
            )
          )
        )
      )

      ; 吊元高さの入力チェック
      (if (= #err_flg nil)
        (progn
          (setq #hang_h (get_tile "HANG_H"))
          (if (= #hang_h "")
            (progn
              (setq #err_flg T)
              (set_tile "error" "「吊元高さ」を入力して下さい")
            )
            (if (= nil (##IsNumeric #hang_h))
              (progn
                (setq #err_flg T)
                (set_tile "error" "「吊元高さ」は数値のみ入力可能です")
              )
              (if (< (fix (atoi #hang_h)) 0)
                (progn
                  (setq #err_flg T)
                  (set_tile "error" "「吊元高さ」がマイナス値で入力されています")
                )
              )
            )
          )
        )
      )

      (if (= #err_flg nil)
        (progn
          (setq #gas_idx (atoi (get_tile "GAS_TYPE")))
          (setq #idx 0)
          (repeat (length #GAS$$)
            (if (= #gas_idx #idx)
              (setq #gas (nth 0 (nth #idx #GAS$$)))
            )
            (setq #idx (1+ #idx))
          )
        )
      )

      (if (= #err_flg nil)
        (progn
          (setq #lst$
            (list
              (nth 0 (nth (atoi (get_tile "drseri")) #DRSERI$$))
              (nth 1 (nth (atoi (get_tile "drcol"))  #DRCOL$$ ))
              (nth 3 (nth (atoi (get_tile "handle")) #HANDLE$$))
              (fix (atoi #dist_x))
              (fix (atoi #dist_y))
              (fix (atoi #ceil_h))
              (fix (atoi #hang_h))
              #gas
            )
          )
          (done_dialog 1)
        )
        (setq #lst$ nil)
      )

      #lst$
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #err_flag nil)

  (if (/= CG_DBSESSION nil)
    (progn
      (dbDisconnect CG_DBSESSION)
      (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
    )
    (progn
      (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
    )
  )
;  (if (= CG_CDBSESSION nil)
;   (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
; )

  (if (= CG_DBSESSION nil)
    (progn
      (CFAlertMsg "SERIES別のデータベースがありませんでした")
      (setq #info$ nil)
      (setq #err_flag T)
    )
    (progn
      ;// 現在の扉SERIES、扉COLORの設定
      ;扉ｼﾘｰｽﾞのﾘｽﾄ
      (setq #DRSERI$$
        (CFGetDBSQLRec CG_DBSESSION "扉シリズ"
          (list
            (list "廃番F" "0"  'INT)
          )
        )
      )
      (if (= #DRSERI$$ nil)
        (progn
          (CFAlertMsg "【扉シリズ】にﾚｺｰﾄﾞがありません。")
          (setq #info$ nil)
          (setq #err_flag T)
        )
      )
    )
  )

  (if (= #err_flag nil)
    (progn
      ; mdbより【ガス種】情報一覧を取得する
      (setq #GAS$$ (DBSqlAutoQuery CG_CDBSESSION "select * from ガス種"))
      (if #GAS$$
        (progn
          (setq #GAS$$ (CFListSort #GAS$$ 1))
        )
        (progn
          (CFAlertMsg "【ガス種】にﾚｺｰﾄﾞがありません。")
          (setq #info$ nil)
          (setq #err_flag T)
        )
      )
    )
  )

  (if (= #err_flag nil)
    (progn
      ; DCLロード
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "SetRoomInfo.dcl")))
      (if (not (new_dialog "InitRoomInfoDlg" #dcl_id)) (exit))

      ; 初期値設定
      (setq #sDR_GRADE_PROHIBIT (CFgetini "DR_GRADE_PROHIBIT" CG_DBNAME (strcat CG_SKPATH "ERRMSG.INI")))

      ; 初期値の設定
      (setq CG_DRSeriCode        (CFgetini "INITIAL" "DoorSeriesCode" (strcat CG_SKPATH "ERRMSG.INI")))  ; 扉グレード
      (setq CG_DRColCode         (CFgetini "INITIAL" "DoorColorCode"  (strcat CG_SKPATH "ERRMSG.INI")))  ; 扉色
      (setq CG_Hikite            (CFgetini "INITIAL" "DoorHandle"     (strcat CG_SKPATH "ERRMSG.INI")))  ; 引手
      (setq CG_RoomW       (atoi (CFgetini "INITIAL" "Width"          (strcat CG_SKPATH "ERRMSG.INI")))) ; 部屋枠Ｘ
      (setq CG_RoomD       (atoi (CFgetini "INITIAL" "Depth"          (strcat CG_SKPATH "ERRMSG.INI")))) ; 部屋枠Ｙ
      (setq CG_CeilHeight  (atoi (CFgetini "INITIAL" "CeilingHeight"  (strcat CG_SKPATH "ERRMSG.INI")))) ; 天井高さ
      (setq CG_UpCabHeight (atoi (CFgetini "INITIAL" "SetHeight"      (strcat CG_SKPATH "ERRMSG.INI")))) ; 取付高さ
      (setq CG_GasType           (CFgetini "INITIAL" "GasType"        (strcat CG_SKPATH "ERRMSG.INI")))  ; ガス種
;;;;(princ "\nCG_DRSeriCode  = ") (princ CG_DRSeriCode)
;;;;(princ "\nCG_DRColCode   = ") (princ CG_DRColCode)
;;;;(princ "\nCG_Hikite      = ") (princ CG_Hikite)
;;;;(princ "\nCG_RoomW       = ") (princ CG_RoomW)
;;;;(princ "\nCG_RoomD       = ") (princ CG_RoomD)
;;;;(princ "\nCG_CeilHeight  = ") (princ CG_CeilHeight)
;;;;(princ "\nCG_UpCabHeight = ") (princ CG_UpCabHeight)
;;;;(princ "\nCG_GasType     = ") (princ CG_GasType)

			(##ResetInitInfo #sDR_GRADE_PROHIBIT)

;;;;;      ; 扉関連
;;;;;      (start_list "drseri" 3)
;;;;;      (setq #i 0 #no 0)
;;;;;      (foreach #Qry$ #DRSERI$$
;;;;;        (setq #sDR_GRADE (strcat (substr CG_DRSeriCode 1 1) (substr (nth 0 #Qry$) 1 1)))
;;;;;        (if (wcmatch #sDR_GRADE #sDR_GRADE_PROHIBIT)
;;;;;          nil ;ﾘｽﾄに追加しない
;;;;;          (progn
;;;;;            (add_list (strcat (nth 0 #Qry$) " ： " (nth 1 #Qry$)))
;;;;;          )
;;;;;        )
;;;;;
;;;;;        (if (= CG_DRSeriCode (nth 0 #Qry$))
;;;;;          (setq #no #i)
;;;;;        )
;;;;;        (setq #i (1+ #i))
;;;;;      )
;;;;;      (end_list)
;;;;;
;;;;;      (set_tile "drseri" (itoa #no))
;;;;;      (##SelDoorSeries)
;;;;;
;;;;;      (set_tile "DIST_X" (itoa CG_RoomW))       ; 画面領域Ｘ方向
;;;;;      (set_tile "DIST_Y" (itoa CG_RoomD))       ; 画面領域Ｙ方向
;;;;;      (set_tile "CEIL_H" (itoa CG_CeilHeight))  ; 天井高さ
;;;;;      (set_tile "HANG_H" (itoa CG_UpCabHeight)) ; 吊元高さ
;;;;;
;;;;;      ; ガス種リスト
;;;;;      (start_list "GAS_TYPE" 3)
;;;;;      (foreach #GAS$ #GAS$$
;;;;;        (add_list (nth 0 #GAS$))
;;;;;      )
;;;;;      (end_list)
;;;;;
;;;;;      (setq #idx 0)
;;;;;      (setq #def 0)
;;;;;      (repeat (length #GAS$$)
;;;;;        (if (= (nth 0 (nth #idx #GAS$$)) CG_GasType)
;;;;;          (setq #def #idx)
;;;;;        )
;;;;;        (setq #idx (1+ #idx))
;;;;;      )
;;;;;      (set_tile "GAS_TYPE" (itoa #def))

      (setq #next 99)
      (while (and (/= 1 #next) (/= 0 #next))
        ; ボタン押下処理
        (action_tile "drseri" "(##SelDoorSeries)")
        (action_tile "drcol"  "(##SelDoorHandle)") ; 02/11/30 YM ADD
        (action_tile "accept" "(setq #info$ (##SetinitInfo_CallBack))")
;        (action_tile "cancel" "(setq #info$ nil)(done_dialog 0)")
        (action_tile "cancel" "(##ResetInitInfo #sDR_GRADE_PROHIBIT)")

        (setq #next (start_dialog))
      )

      (unload_dialog #dcl_id)
    )
  )

  #info$

) ;InputInitInfo
;-- 2011/10/06 A.Satoh Add - E

;-- 2011/10/11 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : CFOutInputCfg
; <処理概要>  : Input.cfgファイルへ入力設定情報を書き込む
; <戻り値>    : T  : 正常終了
;             : nil: 異常終了
; <作成>      : 2011-10-11
; <備考>      : 本関数は、KPCADの確定終了および中断終了時に呼び出される
;               破棄終了時は呼び出されない
;*************************************************************************>MOH<
;;;;;(defun C:qqq (
;;;;;	/
;;;;;	)
;;;;;
;;;;;	(CFOutInputCfg T)
;;;;;)
;;;;;
(defun CFOutInputCfg (
	&fix_flg ; 確定終了フラグ T:確定終了 nil:中断終了
  /
	#output$ #planinfo$$ #planinfo$ #plan$ #plan #ret
	#num #num_str #sk$ #spec$ #spec #expense$ #expense #listA$ #listD$
	#DoorGrade$$ #DoorGrade$ #Input$$ #Input$ #fid #wstr #index #write
	#output_presen$ #door$
#DoorColorCode #DoorHandle #DoorSeriesCode #err_flag #GasType #SeriesDB
#offset$ #allWhite ;-- 2012/03/05 A.Satoh Add CG用壁設定(オフセット入力)対応
#CG_Y ;2012/03/06 YM ADD
  )

  (setq #output$ nil)
	(setq #ret T)

;;;(princ "\n☆☆☆☆☆　CFOutInputCfg 111　☆☆☆☆☆")

  ; PlanInfo.cfg読込
	(if (findfile (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
		(progn
		  (setq #planinfo$$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))

;;;(princ "\n☆☆☆☆☆　CFOutInputCfg 222　☆☆☆☆☆")

      (foreach #planinfo$ #planinfo$$
 		    (cond
     		  ((= (nth 0 #planinfo$) "SeriesDB")
						(setq #SeriesDB (nth 1 #planinfo$))
;						(setq #plan$ (append #plan$ (list (list "PLAN01" (nth 1 #planinfo$)))))
					)
					((= (nth 0 #planinfo$) "DoorSeriesCode")
						(setq #DoorSeriesCode (nth 1 #planinfo$))
;						(setq #plan$ (append #plan$ (list (list "PLAN12" (nth 1 #planinfo$)))))
					)
					((= (nth 0 #planinfo$) "DoorColorCode")
						(setq #DoorColorCode (nth 1 #planinfo$))
;						(setq #plan$ (append #plan$ (list (list "PLAN13" (nth 1 #planinfo$)))))
					)
					((= (nth 0 #planinfo$) "DoorHandle")
						(setq #DoorHandle (nth 1 #planinfo$))
;						(setq #plan$ (append #plan$ (list (list "PLAN14" (nth 1 #planinfo$)))))
					)
					((= (nth 0 #planinfo$) "GasType")
						(setq #GasType (nth 1 #planinfo$))
;						(setq #plan$ (append #plan$ (list (list "PLAN24" (nth 1 #planinfo$)))))
					)
				)
			);foreach
;;;(princ "\n☆☆☆☆☆　CFOutInputCfg 333　☆☆☆☆☆")

		)
		(progn
			(setq #SeriesDB CG_SeriesDB)
;			(setq #plan$ (append #plan$ (list (list "PLAN01" CG_SeriesDB))))
			(setq #DoorSeriesCode CG_DRSeriCode)
;      (setq #plan$ (append #plan$ (list (list "PLAN12" CG_DRSeriCode))))
			(setq #DoorColorCode CG_DRColCode)
;      (setq #plan$ (append #plan$ (list (list "PLAN13" CG_DRColCode))))
			(setq #DoorHandle CG_HIKITE)
;      (setq #plan$ (append #plan$ (list (list "PLAN14" CG_HIKITE))))
			(setq #GasType CG_GasType)
;      (setq #plan$ (append #plan$ (list (list "PLAN24" CG_GasType))))
		)
	)

;;;(princ "\n☆☆☆☆☆　CFOutInputCfg 444　☆☆☆☆☆")

;;;(princ "\n DoorSeriesCode= " )(princ  #DoorSeriesCode)
;;;(princ "\n DoorColorCode = " )(princ  #DoorColorCode)
;;;(princ "\n DoorHandle    = " )(princ  #DoorHandle)
;;;(princ "\n #door$        = " )(princ  #door$)

;;;(princ "\n☆☆☆☆☆　OutputPresenDlg　☆☆☆☆☆")

	(if (= &fix_flg T)
		(progn
			(setq #door$ (list #DoorSeriesCode #DoorColorCode #DoorHandle))
			(setq	#output_presen$ (OutputPresenDlg #door$))
			(if (= #output_presen$ nil)
				(setq #ret nil)
				(progn

;;;(princ "\n☆☆☆☆☆　CFOutInputCfg 555　☆☆☆☆☆")

					(setq #DoorSeriesCode (nth 0 #output_presen$))
					(setq #DoorColorCode  (nth 1 #output_presen$))
					(setq #DoorHandle     (nth 2 #output_presen$))

;-- 2012/03/05 A.Satoh Add CG用壁設定(オフセット入力)対応 - S

;;;					(setq #cg_y (nth 21 #output_presen$))
;;;					(setq #allWhite (nth 25 #output_presen$))

					;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;					(setq #cg_y (nth 22 #output_presen$))
;					(setq #allWhite (nth 26 #output_presen$))
					;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

					;2018/04/27 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #cg_y (nth 24 #output_presen$))
					(setq #allWhite (nth 28 #output_presen$))
					;2018/04/27 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;-- 2012/03/15 A.Satoh Mod 照明の強さ対応（元に戻す） - S
					;2012/03/06 YM MOD-S
					(if (= #cg_y "1")
;;;;;					(if (and (= #cg_y "1")(= #allWhite "0"));背景白(#allWhite="1")のとき、CG壁ｵﾌｾｯﾄは入力画面は不要
					;2012/03/06 YM MOD-E
;-- 2012/03/15 A.Satoh Mod 照明の強さ対応（元に戻す） - E
						(progn
							; CG用壁設定処理
;-- 2012/03/15 A.Satoh Mod 照明の強さ対応（元に戻す） - S
;;;;;							(setq #offset$ (SetCGWallDlg));#allWhite="1"のときnilになる
							(setq #offset$ (SetCGWallDlg #allWhite))
;-- 2012/03/15 A.Satoh Mod 照明の強さ対応（元に戻す） - E
							(if (= #offset$ nil)
								(setq #ret nil)
							)
						)
;-- 2012/03/15 A.Satoh Del 照明の強さ対応（元に戻す） - S
;;;;;						;2012/03/06 YM MOD-S
;;;;;						(progn
;;;;;							(setq #offset$ (list "0" "0" "0" "0"))
;;;;;						)
;;;;;						;2012/03/06 YM MOD-E
;-- 2012/03/15 A.Satoh Del 照明の強さ対応（元に戻す） - E
					)
;-- 2012/03/05 A.Satoh Add CG用壁設定(オフセット入力)対応 - E

;;;(princ "\n☆☆☆☆☆　CFOutInputCfg 666　☆☆☆☆☆")

				)
			);_if
		)
	)

;;;(princ "\n☆☆☆☆☆　CFOutInputCfg 777　☆☆☆☆☆")

	(if (= #ret T)
		(progn
			(setq #plan$ nil)
			(setq #plan$ (append #plan$ (list (list "PLAN01" #SeriesDB))))
		  (setq #plan$ (append #plan$ (list (list "PLAN12" #DoorSeriesCode))))
		  (setq #plan$ (append #plan$ (list (list "PLAN13" #DoorColorCode))))
		  (setq #plan$ (append #plan$ (list (list "PLAN14" #DoorHandle))))
		  (setq #plan$ (append #plan$ (list (list "PLAN24" #GasType))))

		  ; [SET_INFORMATION]出力情報の作成
			(setq #output$ (append #output$ (list "[SET_INFORMATION]")))
;;;(princ "\n☆☆☆☆☆　111　☆☆☆☆☆")
			(setq #err_flag nil)
			(setq #num 0)
			(foreach #plan #plan$
				(if (= #err_flag nil)
					(progn
						(setq #sk$ (CFGetSKData #plan))
						(if (= #sk$ nil)
							(setq #err_flag T)
							(progn
								(setq #num (1+ #num))
								(cond
									((< #num 10)
										(setq #num_str (strcat "00" (itoa #num)))
									)
									((and (> #num 9) (< #num 100))
										(setq #num_str (strcat "0" (itoa #num)))
									)
									(T
										(setq #num_str (itoa #num))
									)
								)
								(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) "," (nth 1 #sk$) "," (nth 2 #sk$) "," (nth 3 #sk$)))))
							)
						)
					)
				)
			)
;;;(princ "\n☆☆☆☆☆　222　☆☆☆☆☆")
			(if (= &fix_flg T)
				(progn
;;;(princ "\n☆☆☆☆☆　333　☆☆☆☆☆")
					; キッチン仕様の情報を取得する
					(setq #plan$ nil)
					(setq #plan$ (append #plan$ (list (list "PLAN05" (nth  3 #output_presen$)))))	; 形状
					(setq #plan$ (append #plan$ (list (list "PLAN07" (nth  4 #output_presen$)))))	; 奥行き
					(setq #plan$ (append #plan$ (list (list "PLAN04" (nth  5 #output_presen$)))))	; キッチン間口
					(setq #plan$ (append #plan$ (list (list "PLAN31" (nth  6 #output_presen$)))))	; ワークトップ高さ
					(setq #plan$ (append #plan$ (list (list "PLAN02" (nth  7 #output_presen$)))))	; キャビネットプラン
					(setq #plan$ (append #plan$ (list (list "PLAN17" (nth  8 #output_presen$)))))	; シンク
					(setq #plan$ (append #plan$ (list (list "PLAN16" (nth  9 #output_presen$)))))	; ワークトップ材質
					(setq #plan$ (append #plan$ (list (list "PLAN06" (nth 10 #output_presen$)))))	; フロアキャビタイプ

;;;(princ "\n☆☆☆☆☆　444　☆☆☆☆☆")
					;2016/04/15 YM ADD -S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #plan$ (append #plan$ (list (list "PLAN15" (nth 11 #output_presen$)))))	; フロアキャビタイプ
					;2016/04/15 YM ADD -E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;(princ "\n☆☆☆☆☆　555　☆☆☆☆☆")

					(setq #plan$ (append #plan$ (list (list "PLAN08" (nth 12 #output_presen$)))))	; ソフトクローズ
					(setq #plan$ (append #plan$ (list (list "PLAN32" (nth 13 #output_presen$)))))	; 吊戸高さ
					(setq #plan$ (append #plan$ (list (list "PLAN19" (nth 14 #output_presen$)))))	; 水栓
					(setq #plan$ (append #plan$ (list (list "PLAN22" (nth 15 #output_presen$)))))	; 浄水器
					(setq #plan$ (append #plan$ (list (list "PLAN20" (nth 16 #output_presen$)))))	; 加熱機器
					(setq #plan$ (append #plan$ (list (list "PLAN21" (nth 17 #output_presen$)))))	; コンロ下オーブン
					(setq #plan$ (append #plan$ (list (list "PLAN42" (nth 18 #output_presen$)))))	; 食洗
					(setq #plan$ (append #plan$ (list (list "PLAN23" (nth 19 #output_presen$)))))	; レンジフード
					(setq #plan$ (append #plan$ (list (list "PLAN44" (nth 20 #output_presen$)))))	; ガラスパーティション
					(setq #plan$ (append #plan$ (list (list "PLAN47" (nth 21 #output_presen$)))))	; キッチンパネル

					;2018/04/27 YK ADD -S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;					(setq #plan$ (append #plan$ (list (list "PLAN11" (nth 22 #output_presen$)))))	; 左右勝手
;					(setq #plan$ (append #plan$ (list (list "PLAN48" (nth 23 #output_presen$)))))	; 天井高さ
					;2018/04/27 YK ADD -E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;;;(princ "\n☆☆☆☆☆　666　☆☆☆☆☆")

					(setq #err_flag nil)
					(foreach #plan #plan$
						(if (= #err_flag nil)
							(progn
								(setq #sk$ (CFGetKichinTokusei #plan))
								(if (= #sk$ nil)
									(setq #err_flag T)
									(progn
										(setq #num (1+ #num))
										(cond
											((< #num 10)
												(setq #num_str (strcat "00" (itoa #num)))
											)
											((and (> #num 9) (< #num 100))
												(setq #num_str (strcat "0" (itoa #num)))
											)
											(T
												(setq #num_str (itoa #num))
											)
										)
										(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) "," (nth 1 #sk$) "," (nth 2 #sk$) "," (nth 3 #sk$)))))
									)
								)
							)
						)
					)

;;;(princ "\n☆☆☆☆☆　777　☆☆☆☆☆")

;-- 2012/01/18 A.Satoh Add CG対応 - S

					;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;					(setq #sk$ (list (nth 22 #output_presen$) (nth 23 #output_presen$) (nth 24 #output_presen$)))
;					(setq #sk$ (list (nth 23 #output_presen$) (nth 24 #output_presen$) (nth 25 #output_presen$)))
					;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

					;2018/04/27 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #sk$ (list (nth 25 #output_presen$) (nth 26 #output_presen$) (nth 27 #output_presen$)))
					;2018/04/27 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;;;(princ "\n☆☆☆☆☆　888　☆☆☆☆☆")

					(setq #num (1+ #num))
					(cond
						((< #num 10)
							(setq #num_str (strcat "00" (itoa #num)))
						)
						((and (> #num 9) (< #num 100))
							(setq #num_str (strcat "0" (itoa #num)))
						)
						(T
							(setq #num_str (itoa #num))
						)
					)
;-- 2012/03/05 A.Satoh Mod - S
;;;;;					(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) ",床カラー," (nth 1 #sk$) "," (nth 2 #sk$)))))
					(if (and (= #cg_y "1") (= #allWhite "1"))
							(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) ",," (nth 1 #sk$) "," (nth 2 #sk$)))))
							(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) ",床カラー," (nth 1 #sk$) "," (nth 2 #sk$)))))
					)
;-- 2012/03/05 A.Satoh Mod - E

					;2018/04/27 YK ADD -S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #num (1+ #num))
					(cond
						((< #num 10)
							(setq #num_str (strcat "00" (itoa #num)))
						)
						((and (> #num 9) (< #num 100))
							(setq #num_str (strcat "0" (itoa #num)))
						)
						(T
							(setq #num_str (itoa #num))
						)
					)
					(setq #sk$ (CFGetKichinTokusei (list "PLAN11" (nth 22 #output_presen$))))
					(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) "," (nth 1 #sk$) "," (nth 2 #sk$) "," (nth 3 #sk$)))))
					(setq #num (1+ #num))
					(cond
						((< #num 10)
							(setq #num_str (strcat "00" (itoa #num)))
						)
						((and (> #num 9) (< #num 100))
							(setq #num_str (strcat "0" (itoa #num)))
						)
						(T
							(setq #num_str (itoa #num))
						)
					)
					(setq #sk$ (CFGetKichinTokusei (list "PLAN48" (nth 23 #output_presen$))))
					(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) "," (nth 1 #sk$) "," (nth 2 #sk$) "," (nth 3 #sk$)))))
					;2018/04/27 YK ADD -E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					
;-- 2012/02/28 A.Satoh Del ([KPCAD_CG_RENKEI]セクションの出力箇所変更) - S
;;;;;				  ; [KPCAD_CG_RENKEI]出力情報の作成
;;;;;					(setq #output$ (append #output$ (list "[KPCAD_CG_RENKEI]")))
;;;;;					(setq #cg_y (nth 21 #output_presen$))
;;;;;					(if (= #cg_y "1")
;;;;;						(setq #output$ (append #output$ (list "CG=Y")))
;;;;;						(setq #output$ (append #output$ (list "CG=N")))
;;;;;					)
;-- 2012/02/28 A.Satoh Del ([KPCAD_CG_RENKEI]セクションの出力箇所変更) - E
;-- 2012/01/18 A.Satoh Add CG対応 - E


;;;(princ "\n☆☆☆☆☆　999　☆☆☆☆☆")

					; 配置部材の情報を取得する
					(setq #spec$ (CFGetSpecList))
					(if #spec$
						(progn
						  (setq #output$ (append #output$ (list "[DETAILS_INFORMATION]")))
							(foreach #spec #spec$
								(if #spec$
;-- 2011/11/25 A.Satoh Mod - S
;;;;;									(setq #output$
;;;;;										(append #output$
;;;;;											(list (strcat (nth 0 #spec) "," (nth 1 #spec) "," (nth 2 #spec) "," (itoa (nth 3 #spec)) ","
;;;;;																		(rtos (nth 4 #spec)) "," (rtos (nth 5 #spec)) "," (nth 6 #spec) "," (nth 7 #spec))
;;;;;											)
;;;;;										)
;;;;;									)
;;;;;									(setq #output$ (append #output$ (list ",,,,,,,")))
									(setq #output$
										(append #output$
											(list (strcat (nth 0 #spec) "," (nth 1 #spec) "," (nth 2 #spec) "," (nth 3 #spec) ","
																		(nth 4 #spec) "," (nth 5 #spec) "," (itoa (nth 6 #spec)) "," (rtos (nth 7 #spec)) ","
																		(rtos (nth 8 #spec)) "," (nth 9 #spec) "," (nth 10 #spec) "," (itoa (nth 11 #spec)))
											)
										)
									)
									(setq #output$ (append #output$ (list ",,,,,,,,,,,")))
;-- 2011/11/25 A.Satoh Mod - E
								)
							)
						)
						(progn
;-- 2011/11/25 A.Satoh Mod - S
;;;;;							(setq #output$ (append #output$ (list ",,,,,,,")))
							(setq #output$ (append #output$ (list ",,,,,,,,,,,")))
;-- 2011/11/25 A.Satoh Mod - E
						)
					);_if

;;;(princ "\n☆☆☆☆☆　AAA　☆☆☆☆☆")

					; buzai.cfgの読込
		    	(setq #expense$ (CFGetBuzaiExpense))
					(if (/= #expense$ nil)
						(progn
		      		(setq #listA$ nil #listD$ nil)
							(foreach #expense #expense$
								(cond
									((= (nth 0 #expense) "CONSTRUCT_A")
										(setq #listA$ (append #listA$ (list (nth 1 #expense))))
									)
									((= (nth 0 #expense) "FREIGHT_A")
										(setq #listA$ (append #listA$ (list (nth 1 #expense))))
									)
									((= (nth 0 #expense) "CONSTRUCT_D")
										(setq #listD$ (append #listD$ (list (nth 1 #expense))))
									)
									((= (nth 0 #expense) "FREIGHT_D")
										(setq #listD$ (append #listD$ (list (nth 1 #expense))))
									)
								)
							)

							; [KP_CONSTRUCT]出力情報の作成
							(setq #output$ (append #output$ (list "[KP_CONSTRUCT]")))
							(setq #output$ (append #output$ (list (strcat "A=" (nth 0 #listA$) "," (nth 1 #listA$)))))
							(setq #output$ (append #output$ (list (strcat "D=" (nth 0 #listD$) "," (nth 1 #listD$)))))
						)
					);_if

;;;(princ "\n☆☆☆☆☆　BBB　☆☆☆☆☆")


					; 扉別参考価格の算出
					(setq #DoorGrade$$ (CFGetDoorGrade #spec$))
					(if (/= #DoorGrade$$ nil)
						(progn
				      (setq #output$ (append #output$ (list "[KP_ANOTHER_GRADE]")))
							(foreach #DoorGrade$ #DoorGrade$$
								(if #DoorGrade$
									(setq #output$
										(append #output$
											(list
												(strcat
													(nth 0 #DoorGrade$)
													(nth 1 #DoorGrade$) ","
													(nth 2 #DoorGrade$) ","
													(nth 3 #DoorGrade$) ","
													(nth 4 #DoorGrade$) ","
													(nth 5 #DoorGrade$) ","
													(nth 6 #DoorGrade$)
												)
											)
										)
									)
									(setq #output$ (append #output$ (list ",,,,,")))
								)
							)
						)
						(progn
							(setq #output$ (append #output$ (list "01=,,,,,")))
						)
					);_if

;;;(princ "\n☆☆☆☆☆　CCC　☆☆☆☆☆")

;-- 2012/02/28 A.Satoh Del ([KPCAD_CG_RENKEI]セクションの出力箇所変更) - S
				  ; [KPCAD_CG_RENKEI]出力情報の作成
					(setq #output$ (append #output$ (list "[KPCAD_CG_RENKEI]")))
;-- 2012/03/05 A.Satoh Mod CG用壁設定(オフセット入力)対応 - S
;;;;;					(setq #cg_y (nth 21 #output_presen$))
;;;;;					(if (= #cg_y "1")
;;;;;						(setq #output$ (append #output$ (list "CG=Y")))
;;;;;						(setq #output$ (append #output$ (list "CG=N")))
;;;;;					)
					(if (= #cg_y "1")
						(progn
							(setq #output$ (append #output$ (list "CG=Y")))
							;2012/03/06 YM ADD-S
							(if (= #allWhite "0")
								(progn
							;2012/03/06 YM ADD-E
									(setq #output$ (append #output$ (list (strcat "U_OFFSET=" (nth 0 #offset$)))))
									(setq #output$ (append #output$ (list (strcat "D_OFFSET=" (nth 1 #offset$)))))
									(setq #output$ (append #output$ (list (strcat "L_OFFSET=" (nth 2 #offset$)))))
									(setq #output$ (append #output$ (list (strcat "R_OFFSET=" (nth 3 #offset$)))))
							;2012/03/06 YM ADD-S
								)
							);_if
							;2012/03/06 YM ADD-E
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
							(cond
								((= (nth 4 #offset$) "1")		; 照明の強さ：強い
									(setq #output$ (append #output$ (list "LIGHT_INTENSITY=LEVEL1")))
								)
								((= (nth 4 #offset$) "2")		; 照明の強さ：やや強い
									(setq #output$ (append #output$ (list "LIGHT_INTENSITY=LEVEL2")))
								)
								((= (nth 4 #offset$) "3")		; 照明の強さ：普通
									(setq #output$ (append #output$ (list "LIGHT_INTENSITY=LEVEL3")))
								)
								((= (nth 4 #offset$) "4")		; 照明の強さ：やや弱い
									(setq #output$ (append #output$ (list "LIGHT_INTENSITY=LEVEL4")))
								)
								((= (nth 4 #offset$) "5")		; 照明の強さ：弱い
									(setq #output$ (append #output$ (list "LIGHT_INTENSITY=LEVEL5")))
								)
							)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
						)
						(setq #output$ (append #output$ (list "CG=N")))
					);_if

;;;(princ "\n☆☆☆☆☆　DDD　☆☆☆☆☆")

;-- 2012/03/05 A.Satoh Mod CG用壁設定(オフセット入力)対応 - E
;-- 2012/02/28 A.Satoh Del ([KPCAD_CG_RENKEI]セクションの出力箇所変更) - E
				)
			)

			; Input.cfgを読込む
			(setq #Input$$ (ReadIniFile (strcat CG_SYSPATH "Input.cfg")))
			(if (/= #Input$$ nil)
				(progn
					; Input.cfgのバックアップを取る
					(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
						(vl-file-delete (strcat CG_SYSPATH "Input0.cfg"))
					)
					(vl-file-rename (strcat CG_SYSPATH "Input.cfg") (strcat CG_SYSPATH "Input0.cfg"))

		      ; Input.cfgを書き込みモードで開く
					(setq #fid (open (strcat CG_SYSPATH "Input.cfg") "W"))
					(if #fid
						(progn
							(setq #wstr "")
							(foreach #Input$ #Input$$
								(if (= (length #Input$) 2)
									;2016/04/15 YM MOD PLANNING_NO で誤作動が起きる
;;;									(if (and (> (strlen (nth 0 #Input$)) 5) (= (substr (nth 0 #Input$) 1 4) "PLAN"))
									(if (wcmatch (substr (nth 0 #Input$) 1 6) "PLAN??")
										(progn
											(setq #index (read (substr (nth 0 #Input$) 5)))
											(if (= 'INT (type #index))
												(setq #write nil)
												(setq #write T)
											)

											(if #write
												(setq #wstr (strcat (nth 0 #Input$) "=" (nth 1 #Input$)))
												(setq #wstr "")
											)
										)
										(setq #wstr (strcat (nth 0 #Input$) "=" (nth 1 #Input$)))
									)
									(if (= (nth 0 #Input$) "[SET_INFORMATION]")
										(setq #wstr "")
										(setq #wstr (nth 0 #Input$))
									)
								)

								(if (/= #wstr "")
									(princ (strcat #wstr "\n") #fid)
								)
							)

							(foreach #output #output$
								(princ (strcat #output "\n") #fid)
							)

							(close #fid)
						)
						(progn
							(CFAlertMsg "Input.cfgの出力に失敗しました。")
							(setq #ret nil)
						)
					)
				)
				(progn
					(CFAlertMsg "Input.cfgの読込に失敗しました。")
					(setq #ret nil)
				)
			);_if

;;;(princ "\n☆☆☆☆☆　EEE　☆☆☆☆☆")

		)
	)

;;;(princ "\n☆☆☆☆☆　FFF　☆☆☆☆☆")

  #ret

);CFOutInputCfg


;<HOM>*************************************************************************
; <関数名>    : CFGetSKData
; <処理概要>  : 「SK特性」「SK特性値」テーブルを読込、Input.cfg出力情報を取得する
; <戻り値>    : 出力項目リスト or nil
; <作成>      : 2011-10-11
; <備考>      : 出力項目リストフォーマット
;             :  (特性ID 特性名 特性値 特性値名)
;             :   exp. (PLAN01,シリーズ,SKB,スイージィー)
;*************************************************************************>MOH<
(defun CFGetSKData (
  &plan$  ; INFORMATION情報リスト (特性ID 特性値)
  /
	#err_flag #ret$ #SK_TOKU$ #toku_name #SK_TOKU_VALUE$ #toku_val_name
  )

  (setq #err_flag nil)
  (setq #ret$ nil)

  (setq #SK_TOKU$
    (CFGetDBSQLRec CG_DBSESSION "SK特性"
      (list
        (list "特性ID" (nth 0 &plan$)  'STR)
      )
    )
  )
  (if (= #SK_TOKU$ nil)
    (progn
      (CFAlertMsg "【SK特性】にﾚｺｰﾄﾞがありません。")
      (setq #err_flag T)
    )
  )
  (if (> (length #SK_TOKU$) 2)
    (progn
      (CFAlertMsg "【SK特性】の該当ﾚｺｰﾄﾞが2件以上存在します。")
      (setq #err_flag T)
    )
  )
  (if (= #err_flag nil)
    (setq  #toku_name (nth 5 (car #SK_TOKU$)))
  )

  (if (= #err_flag nil)
    (progn
      (if (= (nth 0 &plan$) "PLAN01")
        (setq #SK_TOKU_VALUE$
          (CFGetDBSQLRec CG_DBSESSION "SK特性値"
            (list
              (list "特性ID" (nth 0 &plan$) 'STR)
            )
          )
        )
        (setq #SK_TOKU_VALUE$
          (CFGetDBSQLRec CG_DBSESSION "SK特性値"
            (list
              (list "特性ID" (nth 0 &plan$) 'STR)
              (list "特性値" (nth 1 &plan$) 'STR)
            )
          )
        )
      )

      (if (= #SK_TOKU_VALUE$ nil)
        (progn
          (CFAlertMsg "【SK特性値】にﾚｺｰﾄﾞがありません。")
          (setq #err_flag T)
        )
      )
      (if (> (length #SK_TOKU_VALUE$) 2)
        (progn
          (CFAlertMsg "【SK特性値】の該当ﾚｺｰﾄﾞが2件以上存在します。")
          (setq #err_flag T)
        )
      )
    )
  )

  (if (= #err_flag nil)
    (progn
      (setq #toku_val_name (nth 3 (car #SK_TOKU_VALUE$)))

      (setq #ret$ (list (nth 0 &plan$) #toku_name (nth 1 &plan$) #toku_val_name))
    )
  )

  #ret$

);CFGetSKData


;<HOM>*************************************************************************
; <関数名>    : CFGetKichinTokusei
; <処理概要>  : 「SK特性」「SK特性値」「PB特性値」テーブルを読込、Input.cfg出力
;             : 情報を取得する
; <戻り値>    : 出力項目リスト or nil
; <作成>      : 2011-10-28
; <備考>      : 出力項目リストフォーマット
;             :  (特性ID 特性名 特性値 特性値名)
;             :   exp. (PLAN01,シリーズ,SKB,スイージィー)
;*************************************************************************>MOH<
(defun CFGetKichinTokusei (
  &plan$  ; INFORMATION情報リスト (特性ID 特性値)
  /
	#err_flag #ret$ #SK_TOKU$ #toku_name #PB_TOKU_VALUE$ #toku_val_name
  )

  (setq #err_flag nil)
  (setq #ret$ nil)

  (setq #SK_TOKU$
    (CFGetDBSQLRec CG_DBSESSION "SK特性"
      (list
        (list "特性ID" (nth 0 &plan$)  'STR)
      )
    )
  )
  (if (= #SK_TOKU$ nil)
    (progn
      (CFAlertMsg "【SK特性】にﾚｺｰﾄﾞがありません。")
      (setq #err_flag T)
    )
  )
  (if (> (length #SK_TOKU$) 2)
    (progn
      (CFAlertMsg "【SK特性】の該当ﾚｺｰﾄﾞが2件以上存在します。")
      (setq #err_flag T)
    )
  )
  (if (= #err_flag nil)
		(progn
	    (setq  #toku_name (nth 5 (car #SK_TOKU$)))

			(setq #PB_TOKU_VALUE$
				(CFGetDBSQLRec CG_DBSESSION "PB特性値"
					(list
						(list "特性ID" (nth 0 &plan$) 'STR)
						(list "記号" (nth 1 &plan$) 'STR)
					)
				)
			)

      (if (= #PB_TOKU_VALUE$ nil)
        (progn
          (CFAlertMsg "【PB特性値】にﾚｺｰﾄﾞがありません。")
          (setq #err_flag T)
        )
      )
      (if (> (length #PB_TOKU_VALUE$) 2)
        (progn
          (CFAlertMsg "【PB特性値】の該当ﾚｺｰﾄﾞが2件以上存在します。")
          (setq #err_flag T)
        )
      )
    )
  )

  (if (= #err_flag nil)
    (progn
      (setq #toku_val_name (nth 3 (car #PB_TOKU_VALUE$)))
			(if (= #toku_val_name nil)
				(setq #toku_val_name "")
			)

      (setq #ret$ (list (nth 0 &plan$) #toku_name (nth 1 &plan$) #toku_val_name))
    )
  )

  #ret$

);CFGetKichinTokusei


;;;<HOM>************************************************************************
;;; <関数名>  : CFGetSpecList
;;; <処理概要>: 配置部材情報を取得する
;;; <戻り値>  : 配置部材情報リスト
;;; <備考>    : 下記グローバル変数を設定
;;;               CG_DBNAME      : DB名称
;;;               CG_SeriesCode  : SERIES記号
;;;               CG_BrandCode   : ブランド記号
;;;************************************************************************>MOH<
(defun CFGetSpecList (
  /
	#spec$$ #CG_SpecList$$ #hin_old #LR_old #num_CHANGE$ #num #hin #LR
	#dum1$ #dum2$ #CG_SpecList$ #k #dum$$ #CG_SpecListA$$ #CG_SpecListD$$
	#a_cnt #d_cnt #bunrui #num_str #list$
  )

  ; 配置部材仕様詳細情報を取得
  (setq #spec$$ (ConfPartsAll_GetSpecInfo))

  ; 配置部材仕様詳細情報を取得
	(setq #CG_SpecList$$ (ConfPartsAll_GetSpecList #spec$$))

	(if #CG_SpecList$$
		(progn
		  (setq #hin_old nil)
		  (setq #LR_old  nil)
		  (setq #num_CHANGE$ nil)

		  ;入れ替え有無判定 同じ品番が連続し、R,Lの順番であればL,Rの順番にする
		  (foreach #CG_SpecList$ #CG_SpecList$$
    		(setq #num (nth  0 #CG_SpecList$));番号
;		    (setq #hin (nth  9 #CG_SpecList$))
		    (setq #hin (nth 11 #CG_SpecList$))
;    		(setq #LR  (nth 10 #CG_SpecList$))
    		(setq #LR  (nth 12 #CG_SpecList$))
		    (if (and (= #hin #hin_old) (= "R" #LR_old) (= "L" #LR))
    		  (setq #num_CHANGE$ (append #num_CHANGE$ (list (atoi #num))));1つ手前と入れ替えが必要(整数)
		    );_if
    		(setq #hin_old #hin)
		    (setq #LR_old   #LR)
		  );foreach

		  ;入れ替え処理
		  (if #num_CHANGE$
    		(progn
		      (foreach #num_CHANGE #num_CHANGE$ ;#num_CHANGEの1つ前と入れ替える
    		    ;1つ前
        		(setq #dum1$ (assoc (itoa (1- #num_CHANGE)) #CG_SpecList$$))

		        ;番号をﾌﾟﾗｽ
    		    (setq #dum1$ (CFModList #dum1$ (list (list 0 (itoa #num_CHANGE)))))

		        ;その次
    		    (setq #dum2$ (assoc (itoa #num_CHANGE) #CG_SpecList$$))

        		;番号をﾏｲﾅｽ
		        (setq #dum2$ (CFModList #dum2$ (list (list 0 (itoa (1- #num_CHANGE))))))

    		    ;1つ前を#dum1$に入れ替える
        		(setq #CG_SpecList$$ (CFModList #CG_SpecList$$ (list (list (- #num_CHANGE 2) #dum1$))))

		        ;その次を#dum2$に入れ替える
    		    (setq #CG_SpecList$$ (CFModList #CG_SpecList$$ (list (list (- #num_CHANGE 1) #dum2$))))
		      )

    		  ; 番号でソート（文字でｿｰﾄすると"1","10","11","2"となってしまうから数字でｿｰﾄしないとﾀﾞﾒ）
		      (setq #dum$$ nil)
    		  (foreach #CG_SpecList$ #CG_SpecList$$
        		(setq #k (atoi (nth 0 #CG_SpecList$)))
		        (setq #dum$$ (append #dum$$ (list (cons #k #CG_SpecList$))));番号を先頭に追加
    		  )

		      ;数字の番号でｿｰﾄ
    		  (setq #dum$$ (CFListSort #dum$$ 0))

		      (setq #CG_SpecList$$ nil);ｸﾘｱ
    		  (foreach #dum$ #dum$$
        		(setq #CG_SpecList$ (cdr #dum$))
		        (setq #CG_SpecList$$ (append #CG_SpecList$$ (list #CG_SpecList$)))
    		  )
		    )
		  )

		  ; キッチン、収納用に分離
		  (setq #CG_SpecListA$$ nil)
		  (setq #CG_SpecListD$$ nil)
		  (setq #a_cnt 0)
		  (setq #d_cnt 0)

		  (foreach #CG_SpecList$ #CG_SpecList$$
    		(setq #bunrui (nth 8 #CG_SpecList$))
				(if (or (= (type (nth 6 #CG_SpecList$)) 'INT) (= (type (nth 6 #CG_SpecList$)) 'REAL))
					(setq #kosu (nth 6 #CG_SpecList$))
					(setq #kosu 0)
				)
				(if (or (= (type (nth 7 #CG_SpecList$)) 'INT) (= (type (nth 7 #CG_SpecList$)) 'REAL))
					(setq #tanka (nth 7 #CG_SpecList$))
					(setq #tanka 0)
				)
		    (if (= #bunrui "A")
    		  (progn
        		(setq #a_cnt (1+ #a_cnt))
		        (cond
    		      ((< #a_cnt 10)
        		    (setq #num_str (strcat "A00" (itoa #a_cnt) "=" (itoa #a_cnt)))
		          )
    		      ((and (> #a_cnt 9) (< #a_cnt 100))
        		    (setq #num_str (strcat "A0" (itoa #a_cnt) "=" (itoa #a_cnt)))
		          )
    		      (T
        		    (setq #num_str (strcat "A" (itoa #a_cnt) "=" (itoa #a_cnt)))
		          )
						)

		        ; キッチン用情報リスト作成
    		    (setq #list$
        		  (list
            		(list
		              #num_str
    		          (nth  1 #CG_SpecList$)	; 最終品番
        		      (nth  5 #CG_SpecList$)	; 品名
;-- 2011/11/25 A.Satoh Add - S
        		      (nth  2 #CG_SpecList$)	; 巾
        		      (nth  3 #CG_SpecList$)	; 高さ
        		      (nth  4 #CG_SpecList$)	; 奥行
;-- 2011/11/25 A.Satoh Add - E
            		  #kosu										; 個数
		              #tanka									; 単価
									(* #kosu #tanka)				; 金額
        		      (nth  9 #CG_SpecList$)	; 集約ID
;									""	; 特注コード（現在特注未対応、特注対応時に反映）2011/10/12
									(nth 13 #CG_SpecList$)	; 特注コード
;-- 2011/11/25 A.Satoh Add - S
        		      (nth 14 #CG_SpecList$)	; 特注フラグ
;-- 2011/11/25 A.Satoh Add - E
		              (nth 10 #CG_SpecList$)	; 展開タイプ
    		          (nth 11 #CG_SpecList$)	; CAD品番
        		    )
		          )
    		    )
        		(setq #CG_SpecListA$$ (append #CG_SpecListA$$ #list$))
		      )
    		  (progn
        		(setq #d_cnt (1+ #d_cnt))
		        (cond
    		      ((< #d_cnt 10)
        		    (setq #num_str (strcat "D00" (itoa #d_cnt) "=" (itoa #d_cnt)))
		          )
    		      ((and (> #d_cnt 9) (< #d_cnt 100))
        		    (setq #num_str (strcat "D0" (itoa #d_cnt) "=" (itoa #d_cnt)))
		          )
    		      (T
        		    (setq #num_str (strcat "D" (itoa #d_cnt) "=" (itoa #d_cnt)))
		          )
						)

		        ; 収納用情報リスト作成
    		    (setq #list$
        		  (list
            		(list
		              #num_str
    		          (nth  1 #CG_SpecList$)	; 最終品番
        		      (nth  5 #CG_SpecList$)	; 品名
;-- 2011/11/25 A.Satoh Add - S
        		      (nth  2 #CG_SpecList$)	; 巾
        		      (nth  3 #CG_SpecList$)	; 高さ
        		      (nth  4 #CG_SpecList$)	; 奥行
;-- 2011/11/25 A.Satoh Add - E
            		  #kosu										; 個数
		              #tanka									; 単価
									(* #kosu #tanka)				; 金額
        		      (nth  9 #CG_SpecList$)	; 集約ID
;									""	; 特注コード（現在特注未対応、特注対応時に反映）2011/10/12
									(nth 13 #CG_SpecList$)	; 特注コード
;-- 2011/11/25 A.Satoh Add - S
        		      (nth 14 #CG_SpecList$)	; 特注フラグ
;-- 2011/11/25 A.Satoh Add - E
		              (nth 10 #CG_SpecList$)	; 展開タイプ
    		          (nth 11 #CG_SpecList$)	; CAD品番
        		    )
		          )
    		    )
        		(setq #CG_SpecListD$$ (append #CG_SpecListD$$ #list$))
		      )
    		)
		  )

			(setq #ret$ (append #CG_SpecListA$$ #CG_SpecListD$$))
		)
		(progn
			(setq #ret$ nil)
		)
	)

	#ret$

) ;CFGetSpecList


;<HOM>*************************************************************************
; <関数名>    : CFGetBuzaiExpense
; <処理概要>  : buzai.cfgの[EXPENSE]項目をリストで返す
; <戻り値>    : Expense項目リスト or nil
; <作成>      : 2011-10-11
; <備考>      :
;*************************************************************************>MOH<
(defun CFGetBuzaiExpense (
  /
	#ret$ #fname #fp #syori #item$
#buf #flag
  )

  (setq #ret$ nil)

  ; buzai.cfgを開く
  (setq #fname (strcat CG_KENMEIDATA_PATH "buzai.cfg"))
  (setq #fp (open #fname "r"))
  (if (/= #fp nil)
    (progn
			; buzai.cfgの内容をリストに纏める
      (setq #syori nil)
      (setq #ret$ nil)
      (setq #buf T)
      (while #buf
        (setq #buf (read-line #fp))
        (if #buf
          (if (= #syori nil)
            (if (= #buf "[EXPENSE]")
              (setq #syori T)
            )
            (progn
              (setq #item$ (strparse #buf "=")) ;文字列をデミリタで区切る
              (setq #ret$ (append #ret$ (list #item$)))
            )
          )
        )
      )
      (close #fp)

			; 作成したリストの内容を確認に不足情報を追加する
			;;; "CONSTRUCT_A"情報存在チェック
			(setq #flag nil)
			(foreach #ret #ret$
				(if (= (nth 0 #ret) "CONSTRUCT_A")
					(setq #flag T)
				)
			)
			(if (= #flag nil)
				(setq #ret$ (append #ret$ (list (list "CONSTRUCT_A" "0"))))
			)

			;;; "FREIGHT_A"情報存在チェック
			(setq #flag nil)
			(foreach #ret #ret$
				(if (= (nth 0 #ret) "FREIGHT_A")
					(setq #flag T)
				)
			)
			(if (= #flag nil)
				(setq #ret$ (append #ret$ (list (list "FREIGHT_A" "0"))))
			)

			;;; "CONSTRUCT_D"情報存在チェック
			(setq #flag nil)
			(foreach #ret #ret$
				(if (= (nth 0 #ret) "CONSTRUCT_D")
					(setq #flag T)
				)
			)
			(if (= #flag nil)
				(setq #ret$ (append #ret$ (list (list "CONSTRUCT_D" "0"))))
			)

			;;; "FREIGHT_D"情報存在チェック
			(setq #flag nil)
			(foreach #ret #ret$
				(if (= (nth 0 #ret) "FREIGHT_D")
					(setq #flag T)
				)
			)
			(if (= #flag nil)
				(setq #ret$ (append #ret$ (list (list "FREIGHT_D" "0"))))
			)
    )
		(progn
			(setq #ret$
				(list
					(list "CONSTRUCT_A" "0")
					(list "FREIGHT_A"   "0")
					(list "CONSTRUCT_D" "0")
					(list "FREIGHT_D"   "0")
				)
			)
		)
  )

  #ret$

);CFGetBuzaiExpense


;<HOM>*************************************************************************
; <関数名>    : CFGetDoorGrade
; <処理概要>  : 扉別参考価格の算出
; <戻り値>    : 扉別参考価格情報リスト or nil
; <作成>      : 2011-10-11
; <備考>      :
;*************************************************************************>MOH<
(defun CFGetDoorGrade (
	&spec$
  /
	#DoorGrade$$ #DoorGrade$ #no_cab$$ #no_cab$ #cab$$ #cab$ #spec$
	#no_cab_kingaku #cab_kingaku #flag
	#qry$ #num #num_str #DoorName #ret$ #err_flag
	#cab_hinban2 ; [扉シリ別非対応部材]テーブルで置換後の品番 2011/12/22
	#sql
#rec$$ #rec$
  )

  (setq #ret$ nil)
	(setq #err_flag nil)

;-- 2012/03/09 A.Satoh Mod 扉グレード別積算修正 - S
;;;;;	(setq #DoorGrade$$
;;;;;		(list
;;;;;			(list "RS" "H"  "H")
;;;;;			(list "RP" "H"  "H")
;;;;;			(list "RM" "H"  "H")
;;;;;			(list "RJ" "H"  "H")
;;;;;			(list "RF" "H"  "J")
;;;;;			(list "UM" "PV" "L")
;;;;;			(list "UJ" "CG" "L")
;;;;;			(list "UF" "Y"  "G")
;;;;;			(list "XF" "Y"  "G")
;;;;;			(list "XC" "Y"  "G")
;;;;;		)
;;;;;	)
	(setq #DoorGrade$$ nil)
	(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "扉シリ別積算")))
	(if #rec$$
		(foreach #rec$ #rec$$
			(if (= (nth 4 #rec$) "Y")  ; 対象="Y"である場合に処理を行う
				(setq #DoorGrade$$
					(append #DoorGrade$$
						(list
							(list
								(nth 1 #rec$)    ; 扉シリ記号
								(nth 2 #rec$)    ; 扉カラ記号
								(nth 3 #rec$)    ; 引手記号
							)
						)
					)
				)
			)
		)
	)
;-- 2012/03/09 A.Satoh Mod 扉グレード別積算修正 - E

	(setq #no_cab$$ nil)
	(setq #cab$$ nil)

	; 部材を扉別参考価格算出対象と非対象で分ける
	; 展開タイプ:(nth 12 #spec$) = 0 を対象とする
	(foreach #spec$ &spec$
;-- 2011/11/25 A.Satoh Mod - S
;;;;;		(if (= (nth 8 #spec$) 0)
		(if (= (nth 12 #spec$) 0)
;-- 2011/11/25 A.Satoh Mod - E
			(setq #cab$$ (append #cab$$ (list #spec$)))
			(setq #no_cab$$ (append #no_cab$$ (list #spec$)))
		)
	)

	; 扉無し部材の金額合計を算出する
	(setq #no_cab_kingaku 0)
  (foreach #no_cab$ #no_cab$$
;-- 2011/11/25 A.Satoh Mod - S
;;;;;		(setq #no_cab_kingaku (+ #no_cab_kingaku (nth 5 #no_cab$)))
		(setq #no_cab_kingaku (+ #no_cab_kingaku (nth 8 #no_cab$)))
;-- 2011/11/25 A.Satoh Mod - E
	)

	; 各扉グレード別金額を求める
	(setq #num 1)
	(foreach #DoorGrade$ #DoorGrade$$
		(if (= #err_flag nil)
			(progn
				(setq #cab_kingaku 0)
				(setq #flag nil)

  			; 扉SERIES名称
				(setq #qry$ (CFGetDBSQLRec CG_DBSESSION "扉シリズ" (list (list "扉シリ記号" (nth 0 #DoorGrade$) 'STR))))
				(if (= #qry$ nil)
					(progn
	  		  	(CFAlertMsg (strcat "【扉シリズ】にﾚｺｰﾄﾞがありません 扉シリ記号:" (nth 0 #DoorGrade$)))
						(setq #err_flag T)
					)
					(setq #DoorName (nth 1 (nth 0 #qry$)))
				)

				(if (= #err_flag nil)
					(progn
						(foreach #cab$ #cab$$
							; 品番最終情報の取得
							(setq #qry$ (CFGetDBSQLRec CG_DBSESSION "品番最終"
								(list
									;(list "最終品番"   (nth 1 #cab$)       'STR)
;-- 2011/11/25 A.Satoh Mod - S
;;;;;									(list "品番名称"   (nth 9 #cab$)       'STR)
									(list "品番名称"   (nth 13 #cab$)       'STR)
;-- 2011/11/25 A.Satoh Mod - E
									(list "扉シリ記号" (nth 0 #DoorGrade$) 'STR)
									(list "扉カラ記号" (nth 1 #DoorGrade$) 'STR)
									(list "引手記号"   (nth 2 #DoorGrade$) 'STR)
								)
							))
							(if (= #qry$ nil)
								(progn
									(setq #qry$ (CFGetDBSQLRec CG_DBSESSION "品番最終"
										(list
											;(list "最終品番"   (nth 1 #cab$)       'STR)
;-- 2011/11/25 A.Satoh Mod - S
;;;;;											(list "品番名称"   (nth 9 #cab$)       'STR)
											(list "品番名称"   (nth 13 #cab$)       'STR)
;-- 2011/11/25 A.Satoh Mod - E
											(list "扉シリ記号" (nth 0 #DoorGrade$) 'STR)
											(list "扉カラ記号" (nth 1 #DoorGrade$) 'STR)
										)
									))
;-- ↓ 2011/12/22 山田 追加 --------------------------------
; [品番最終]テーブルに見つからない場合は、
; [扉シリ別非対応部材]テーブルを参照して品番を置換し
; [品番最終]テーブルから取得しなおす
                  (if (= #qry$ nil)
                    (progn
                      ; [扉シリ別非対応部材]テーブルから置換後の品番の取得
;-- 2012/01/30 A.Satoh Mod - S
;;;;;                      (setq #sql (strcat "SELECT 品番名称 FROM 扉シリ別非対応部材 "
;;;;;                          "WHERE 有効禁止フラグ='OK' AND ',' + 扉シリ + ',' LIKE '%,"
;;;;;                          (nth 0 #DoorGrade$)
;;;;;                          ",%' AND 品番置換GP=(SELECT 品番置換GP FROM 扉シリ別非対応部材 "
;;;;;                          "WHERE 有効禁止フラグ='OK' AND 品番置換GP IS NOT NULL AND 品番名称='"
;;;;;                          (nth 13 #cab$) "')" ; 「品番置換GP」は空文字列不可のためNullで判定
;;;;;                      ))
                      (setq #sql
                        (strcat "SELECT 品番名称 FROM 扉シリ別非対応部材 "
                                "WHERE 有効禁止フラグ='OK' "
                                "AND ',' + 扉シリ + ',' LIKE '%," (nth 0 #DoorGrade$) ",%' "
                                "AND ',' + 扉カラ + ',' LIKE '%," (nth 1 #DoorGrade$) ",%' "
                                "AND 品番置換GP=(SELECT 品番置換GP FROM 扉シリ別非対応部材 "
                                "WHERE 有効禁止フラグ='OK' AND 品番置換GP IS NOT NULL AND 品番名称='"
                                (nth 13 #cab$) "')" ; 「品番置換GP」は空文字列不可のためNullで判定
                        )
                      )
;-- 2012/01/30 A.Satoh Mod - E
                      (setq #qry$ (DBSqlAutoQuery CG_DBSESSION #sql))
                      (if (/= #qry$ nil)
                        (progn
                          (setq #cab_hinban2 (nth 0 (nth 0 #qry$)))

                          ; 品番最終情報の取得
                          (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "品番最終"
                            (list
                              (list "品番名称"   #cab_hinban2        'STR)
                              (list "扉シリ記号" (nth 0 #DoorGrade$) 'STR)
                              (list "扉カラ記号" (nth 1 #DoorGrade$) 'STR)
                              (list "引手記号"   (nth 2 #DoorGrade$) 'STR)
                            )
                          ))
                          (if (= #qry$ nil)
                            (progn
                              (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "品番最終"
                                (list
                                  (list "品番名称"   #cab_hinban2        'STR)
                                  (list "扉シリ記号" (nth 0 #DoorGrade$) 'STR)
                                  (list "扉カラ記号" (nth 1 #DoorGrade$) 'STR)
                                )
                              ))
                            )
                          )
                        )
                      )
                    )
                  )
;-- ↑ 2011/12/22 山田 追加 --------------------------------
									(if (= #qry$ nil)
										(progn
;-- 2011/11/25 A.Satoh Mod - S
;;;;;											(setq #cab_kingaku (+ #cab_kingaku (nth 5 #cab$)))
											(setq #cab_kingaku (+ #cab_kingaku (nth 8 #cab$)))
;-- 2011/11/25 A.Satoh Mod - E
											(setq #flag T)
										)
;-- 2011/11/25 A.Satoh Mod - S
;;;;;										(setq #cab_kingaku (+ #cab_kingaku (* (nth 3 #cab$) (nth 8 (car #qry$)))))
										(setq #cab_kingaku (+ #cab_kingaku (* (nth 6 #cab$) (nth 8 (car #qry$)))))
;-- 2011/11/25 A.Satoh Mod - E
									)
								)
;-- 2011/11/25 A.Satoh Mod - S
;;;;;								(setq #cab_kingaku (+ #cab_kingaku (* (nth 3 #cab$) (nth 8 (car #qry$)))))
								(setq #cab_kingaku (+ #cab_kingaku (* (nth 6 #cab$) (nth 8 (car #qry$)))))
;-- 2011/11/25 A.Satoh Mod - E
							)
						)

						(if (< #num 10)
							(setq #num_str (strcat "0" (itoa #num) "="))
							(setq #num_str (strcat (itoa #num) "="))
						)

						(setq #ret$ (append #ret$ (list
							(list
								#num_str 
								(nth 0 #DoorGrade$)
								(nth 1 #DoorGrade$)
								(nth 2 #DoorGrade$)
								#DoorName
								(rtos (+ #no_cab_kingaku #cab_kingaku))
								(if (= #flag T)
									"1"
									"0"
								)
							)
						)))
						(setq #num (1+ #num))
					)
				)
			)
		)
	)

  #ret$

);CFGetDoorGrade
;-- 2011/10/11 A.Satoh Add - E

;-- 2011/10/27 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : OutputPresenDlg
; <処理概要>  : プレゼンボード出力設定ダイアログ処理を行う
; <戻り値>    : 設定情報リスト or nil
; <作成>      : 2011/10/27 A.Satoh
; <備考>      : なし
;*************************************************************************>MOH<
(defun OutputPresenDlg (
	&door$	; 扉情報リスト
  /
#PB_TOKUSEI$$ #info$ #err_flag #GBL_TOKUSEI$ #next #dcl_id
#DRSERI$$ #wt_ss #wt_en #xd_WRKT$ #type_f
#HANDLE$$ #Init$ #DRCOL$$
#CG_YUKAIRO$$ #CG_YUKAIRO$ #GBL_CGYukairoGoods$ #CG_YukairoCol$ ;-- 2012/01/18 A.Satoh Add CG対応
#OLD_CG_Y #OLD_CG_N  ;-- 2012/01/25 A.Satoh Add CG対応
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;//******************************************************
		;//
    ;// 図面上から"G_LSYM"を持つ図形を抽出し、指定の性格コード
		;// を持つ品番を取得する。
		;// 複数取得される場合は、最初の図形のみを対象とする
		;//
		;//******************************************************
		(defun ##GetHinban (
			&seikaku		; 正確コード
			/
			#hinban #ss #idx #flag #xd_LSYM$
			)
;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##GetHinban ☆☆☆☆☆")
			(setq #hinban nil)

			(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
			(if (/= #ss nil)
				(progn
					(setq #idx 0)
					(setq #flag nil)
					(setq #hinban nil)
					(repeat (sslength #ss)
						(if (= #flag nil)
							(progn
								(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
								(if (= (nth 9 #xd_LSYM$) &seikaku)
									(progn
										(setq #flag T)
										(setq #hinban (nth 5 #xd_LSYM$))
									)
								)
							)
						)
						(setq #idx (1+ #idx))
					)
				)
			)

			#hinban

		) ; ##GetHinban


		;//******************************************************
		;//
    ;// 図面上から"G_LSYM"を持つ図形を抽出し、指定の性格コード
		;// を持つ品番を「複数」取得する。
		;//;2018/10/22 YM MOD
		;//******************************************************
		(defun ##GetHinban_HUKU (
			&seikaku		; 正確コード
			/
			#hinban #ss #idx #flag #xd_LSYM$ #hinban$
			)
;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##GetHinban ☆☆☆☆☆")
			(setq #hinban nil)

			(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
			(if (/= #ss nil)
				(progn
					(setq #idx 0)
;;;					(setq #flag nil)
					(setq #hinban$ nil)
					(repeat (sslength #ss)
						(if (= #flag nil)
							(progn
								(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
								(if (= (nth 9 #xd_LSYM$) &seikaku)
									(progn
;;;										(setq #flag T)
										(setq #hinban$ (append #hinban$ (list (nth 5 #xd_LSYM$))))
									)
								)
							)
						)
						(setq #idx (1+ #idx))
					)
				)
			)

			#hinban$

		) ; ##GetHinban_HUKU


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// 指定の特性IDと品番より該当する逆引値を取得する
		;// 取得できない場合は、"NULL"文字を返す
		;// ※条件1のみ対応
		;//
		;//******************************************************
		(defun ##GetGyakubukiValue (
			&id			; 特性ID
			&jouken	; 条件1
			/
			#value #QRY$
			)
;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##GetGyakubukiValue ☆☆☆☆☆")
			(setq #value nil)

			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB逆引"
					(list
						(list "特性ID" &id     'STR)
						(list "条件1"  &jouken 'STR)
					)
				)
			)

			(if (= #QRY$ nil)
				(setq #value "NULL")
				(setq #value (nth 5 (nth 0 #QRY$)))
			)

			#value

		) ; ##GetGyakubukiValue


		;//******************************************************
		;//
    ;// 指定の特性IDと品番(複数)より該当する逆引値を取得する
		;// 取得できない場合は、"NULL"文字を返す
		;// ※条件1のみ対応
		;//;2018/10/22 YM MOD
		;//******************************************************
		(defun ##GetGyakubukiValue_HUKU (
			&id			 ; 特性ID
			&jouken$ ; 条件1
			/
			#value #QRY$
			)
;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##GetGyakubukiValue ☆☆☆☆☆")
			(setq #value nil)

			(foreach jouken &jouken$
				
				(setq #QRY$
					(CFGetDBSQLRec CG_DBSESSION "PB逆引"
						(list
							(list "特性ID" &id    'STR)
							(list "条件1"  jouken 'STR)
						)
					)
				)

				(if (/= #QRY$ nil)
					(setq #value (nth 5 (nth 0 #QRY$)))
				);_if

;;;				(if (= #QRY$ nil)
;;;					(setq #value "NULL")
;;;					;else
;;;					(setq #value (nth 5 (nth 0 #QRY$)))
;;;				);_if

			);foreach


			(if (= #value nil)(setq #value "NULL")) ;_if
			
			#value

		) ; ##GetGyakubukiValue_HUKU



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// PB逆引により、初期値取得
		;//
		;//******************************************************
		(defun ##GetInitData (
			&xd_WRKT$		; 天板情報(G_WRKT)
			/
			#ret$ #QRY$ #QRY #oku #oku$ #maguchi$
			#wt_height #value #flag #idx #ss #xd_LSYM$
			#wk_hinban #hinban #hinban2 #hinban$ #hinban2$
			#GLASS$$ #GLASS$ #spec$ #spec$$
			#LR$ #LR #wt_LR #TEN$ #TEN #wt_TEN #PLANINFO$ ;2018/04/27 YK ADD
			)
;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##GetInitData ☆☆☆☆☆")
			(setq #ret$ nil)

			;;;;; 形状
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB逆引"
					(list
						(list "特性ID" "PLAN05" 'STR)
					)
				)
			)
			(if (= #QRY$ nil)
				(setq #ret$ (append #ret$ (list "NULL")))
				(progn
					(setq #oku (atoi (nth 2 (car #QRY$))))

					(setq #hinban$ nil)
					(foreach #QRY #QRY$
						(if (/= (nth 3 #QRY) nil)
							(if (= (member (nth 3 #QRY) #hinban$) nil)
								(setq #hinban$ (append #hinban$ (list (nth 3 #QRY))))
							)
						)
					)

					; 図面からゲートカウンターを検索
					(setq #flag nil)
					(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
					(if (/= #ss nil)
						(foreach #hinban #hinban$
							(if (= #flag nil)
								(progn
									(setq #idx 0)
									(repeat (sslength #ss)
										(if (= #flag nil)
											(progn
												(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
												(if (= (nth 5 #xd_LSYM$) #hinban)
													(setq #flag T)
												)
											)
										)
										(setq #idx (1+ #idx))
									)
								)
							)
						)
					)

					(cond
						((= (nth 3 &xd_WRKT$) 0)		; I型
							(if (< (nth 0 (nth 57 &xd_WRKT$)) #oku)
								(if (= #flag T)
									(setq #ret$ (append #ret$ (list "G00")))
									(setq #ret$ (append #ret$ (list "I00")))
								)
								(setq #ret$ (append #ret$ (list "IPA")))
							)
						)
						((= (nth 3 &xd_WRKT$) 1)		; L型
							(if (and (< (nth 0 (nth 57 &xd_WRKT$)) #oku)
											 (< (nth 1 (nth 57 &xd_WRKT$)) #oku))
								(if (= #flag T)
									(setq #ret$ (append #ret$ (list "LG0")))
									(setq #ret$ (append #ret$ (list "L00")))
								)
								(setq #ret$ (append #ret$ (list "LG0")))
							)
						)
						((= (nth 3 &xd_WRKT$) 2)		; U型
							(setq #ret$ (append #ret$ (list "U00")))
						)
						(T
							(setq #ret$ (append #ret$ (list "NULL")))
						)
					)
				)
			)

			;;;;; 奥行き
			(setq #oku$ (nth 57 &xd_WRKT$))
			(cond
				((= (nth 3 &xd_WRKT$) 0)		; I型
					(setq #QRY$
						(CFGetDBSQLRec CG_DBSESSION "奥行"
							(list
								(list "奥行" (rtos (nth 0 #oku$)) 'INT)
							)
						)
					)
					(if (= #QRY$ nil)
						(setq #ret$ (append #ret$ (list "NULL")))
						(setq #ret$ (append #ret$ (list (nth 1 (nth 0 #QRY$)))))
					)
				)
				((= (nth 3 &xd_WRKT$) 1)		; L型
					(if (equal (nth 0 #oku$) (nth 1 #oku$) 0.001) ;2018/08/06 YM MOD 誤差を許容しないと通らない
						(progn
							(setq #QRY$
								(CFGetDBSQLRec CG_DBSESSION "奥行"
									(list
										(list "奥行" (rtos (nth 0 #oku$)) 'INT)
									)
								)
							)
							(if (= #QRY$ nil)
								(setq #ret$ (append #ret$ (list "NULL")))
								(setq #ret$ (append #ret$ (list (nth 1 (nth 0 #QRY$)))))
							)
						)
						(setq #ret$ (append #ret$ (list "NULL")))
					)
				)
				((= (nth 3 &xd_WRKT$) 2)		; U型
					(if (and (equal (nth 0 #oku$) (nth 1 #oku$) 0.001)  ;2018/08/06 YM MOD 誤差を許容しないと通らない
									 (equal (nth 0 #oku$) (nth 2 #oku$) 0.001)) ;2018/08/06 YM MOD 誤差を許容しないと通らない
						(progn
							(setq #QRY$
								(CFGetDBSQLRec CG_DBSESSION "奥行"
									(list
										(list "奥行" (rtos (nth 0 #oku$)) 'INT)
									)
								)
							)
							(if (= #QRY$ nil)
								(setq #ret$ (append #ret$ (list "NULL")))
								(setq #ret$ (append #ret$ (list (nth 1 (nth 0 #QRY$)))))
							)
						)
						(setq #ret$ (append #ret$ (list "NULL")))
					)
				)
				(T
					(setq #ret$ (append #ret$ (list "NULL")))
				)
			)

			;;;;; キッチン間口
			(setq #maguchi$ (nth 55 &xd_WRKT$))
			(cond
				((= (nth 3 &xd_WRKT$) 0)		; I型
					(setq #QRY$
						(CFGetDBSQLRec CG_DBSESSION "間口"
							(list
								(list "間口" (rtos (nth 0 #maguchi$)) 'INT)
							)
						)
					)
					(if (= #QRY$ nil)
						(setq #ret$ (append #ret$ (list "NULL")))
						(setq #ret$ (append #ret$ (list (nth 1 (nth 0 #QRY$)))))
					)
				)
				((= (nth 3 &xd_WRKT$) 1)		; L型
					(if (equal (nth 0 #oku$) (nth 1 #oku$) 0.001) ;2018/08/06 YM MOD 誤差を許容しないと通らない
;;;					(if (= (nth 0 #oku$) (nth 1 #oku$))
						(progn
							(setq #QRY$
								(CFGetDBSQLRec CG_DBSESSION "間口"
									(list
										(list "間口" (rtos (nth 0 #maguchi$)) 'INT)
									)
								)
							)
							(if (= #QRY$ nil)
								(setq #ret$ (append #ret$ (list "NULL")))
								(setq #ret$ (append #ret$ (list (nth 1 (nth 0 #QRY$)))))
							)
						)
						(setq #ret$ (append #ret$ (list "NULL")))
					)
				)
				((= (nth 3 &xd_WRKT$) 2)		; U型
					(setq #ret$ (append #ret$ (list "NULL")))
				)
				(T
					(setq #ret$ (append #ret$ (list "NULL")))
				)
			)

			;;;;; ワークトップ高さ
			(setq #wt_height (fix (nth 8 &xd_WRKT$)))
			(setq #value (##GetGyakubukiValue "PLAN31" (itoa #wt_height)))
			(setq #ret$ (append #ret$ (list #value)))

			;;;;; キャビネットプラン
			(if (= (nth 35 &xd_WRKT$) nil)
				(setq #ret$ (append #ret$ (list "NULL")))
				(setq #ret$ (append #ret$ (list (nth 35 &xd_WRKT$))))
			)

			;;;;; シンク
			(setq #hinban (##GetHinban 410))

			(if (= #hinban nil)
				(setq #ret$ (append #ret$ (list "NULL")))
				(progn
					(setq #QRY$
						(CFGetDBSQLRec CG_DBSESSION "WTシンク"
							(list
								(list "シンク記号" #hinban 'STR)
							)
						)
					)
					(if (= #QRY$ nil)
						(setq #ret$ (append #ret$ (list "NULL")))
						(setq #ret$ (append #ret$ (list (nth 10 (nth 0 #QRY$)))))
					)
				)
			)

			;;;;; ワークトップ材質
			(setq #ret$ (append #ret$ (list (nth 2 &xd_WRKT$))))

			;;;;; フロアキャビタイプ
			(setq #ret$ (append #ret$ (list "NULL")))


			;2016/04/15 YM ADD 項目追加@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			;;; シンク下キャビネット
			(setq #ret$ (append #ret$ (list "NULL")))
			;2016/04/15 YM ADD 項目追加@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


			;;;;; ソフトクローズ
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB逆引"
					(list
						(list "特性ID" "PLAN08" 'STR)
					)
				)
			)
			(if (= #QRY$ nil)
				(setq #ret$ (append #ret$ (list "NULL")))
				(progn
					(setq #flag nil)
					(setq #value nil)
					(foreach #QRY #QRY$
						(if (= #flag nil)
							(if (/= (member (nth 0 &door$) (StrParse (nth 2 #QRY) ",")) nil)
								(progn
									(setq #flag T)
									(setq #value (nth 5 #QRY))
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #ret$ (append #ret$ (list "NULL")))
						(setq #ret$ (append #ret$ (list #value)))
					)
				)
			)

			;;;;; 吊戸高さ
			(setq #ret$ (append #ret$ (list "NULL")))

			;;;;; 水栓
;;;			(setq #hinban$ (##GetHinban 510));2018/10/22 YM MOD
			(setq #hinban$ (##GetHinban_HUKU 510));2018/10/22 YM MOD

			(if (= #hinban$ nil)
				(setq #ret$ (append #ret$ (list "N")))
				(progn
;;;					(setq #value (##GetGyakubukiValue "PLAN19" #hinban));2018/10/22 YM MOD
					(setq #value (##GetGyakubukiValue_HUKU "PLAN19" #hinban$));2018/10/22 YM MOD
					(if (= #value "NULL")
						(setq #value "N")
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; 浄水器
			(setq #ret$ (append #ret$ (list "N")))

			;;;;; 加熱機器
			(setq #hinban (##GetHinban 210))

			(if (= #hinban nil)
				(setq #ret$ (append #ret$ (list "N")))
				(progn
					(setq #value (##GetGyakubukiValue "PLAN20" #hinban))
					(if (= #value "NULL")
						(setq #value "N")
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; コンロ下オーブン
			(setq #hinban (##GetHinban 113))

			(if (= #hinban nil)
				(setq #ret$ (append #ret$ (list "NULL")))
				(progn
					(setq #flag nil)
					(setq #idx 1)
					(repeat (strlen #hinban)
						(if (= #flag nil)
							(if (= (substr #hinban #idx 1) "$")
								(setq #flag T)
							)
						)
						(setq #idx (1+ #idx))
					)

					(if (= #flag nil)
						(setq #value (##GetGyakubukiValue "PLAN21" #hinban))
						(setq #value "B")
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; 食洗
			(setq #hinban (##GetHinban 110))

			(if (= #hinban nil)
				(setq #ret$ (append #ret$ (list "N")))
				(progn
					(setq #value (##GetGyakubukiValue "PLAN42" #hinban))
					(if (= #value "NULL")
						(setq #value "N")
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; レンジフード
			(setq #hinban (##GetHinban 320))

			(if (= #hinban nil)
				(setq #ret$ (append #ret$ (list "N")))
				(progn
					(setq #value (##GetGyakubukiValue "PLAN23" #hinban))
					(if (= #value "NULL")
						(setq #value "N")
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; ガラスパーティション
			(setq #GLASS$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from ガラスパティション")))
			(if (= #GLASS$$ nil)
				(setq #value "NULL")
				(progn
					; ガラスパーティション品番リストを作成
					(setq #hinban$ nil)
					(foreach #GLASS$ #GLASS$$
						(if (= (member (nth 5 #GLASS$) #hinban$) nil)
							(setq #hinban$ (append #hinban$ (list (nth 5 #GLASS$))))
						)
					)

					; 図面からガラスパーティションを検索
					(setq #flag nil)
					(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
					(if (/= #ss nil)
						(foreach #hinban #hinban$
							(if (= #flag nil)
								(progn
									(setq #idx 0)
									(repeat (sslength #ss)
										(if (= #flag nil)
											(progn
												(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
												(if (= (nth 5 #xd_LSYM$) #hinban)
													(progn
														(setq #flag T)
														(setq #hinban2 #hinban)
													)
												)
											)
										)
										(setq #idx (1+ #idx))
									)
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #value "NULL")
						(setq #value (##GetGyakubukiValue "PLAN44" #hinban2))
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; キッチンパネル
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB逆引"
					(list
						(list "特性ID" "PLAN47" 'STR)
					)
				)
			)
			(if (= #QRY$ nil)
				(setq #value "N")
				(progn
					; キッチンパネル品番リストを作成
					(setq #hinban$ nil)
					(foreach #QRY #QRY$
						(if (= (member (nth 2 #QRY) #hinban$) nil)
							(setq #hinban$ (append #hinban$ (list (list (nth 2 #QRY) (nth 5 #QRY)))))
						)
					)

					; 図面からキッチンパネルを検索
					(setq #flag nil)
					(setq #hinban2 nil)
					(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
					(if (/= #ss nil)
						(foreach #hinban #hinban$
							(if (= #flag nil)
								(progn
									(setq #idx 0)
									(repeat (sslength #ss)
										(if (= #flag nil)
											(progn
												(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
												(if (= (nth 5 #xd_LSYM$) (car #hinban))
													(progn
														(setq #wk_hinban #hinban)
														(setq #flag T)
													)
												)
											)
										)
										(setq #idx (1+ #idx))
									)
								)
							)
						)
					)
					(if (= #flag nil)
					  (if (findfile (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
					    (progn
								(setq #hinban2$ nil)
					      (setq #spec$$ (ReadCSVFile (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg")))
					      (if #spec$$
					        (foreach #spec$ #spec$$
					          (setq #hinban2$ (append #hinban2$ (list (nth 0 (StrParse (nth 0 #spec$) "=")))))
									)
								)
								(foreach #hinban #hinban$
									(if (= #flag nil)
										(foreach #hinban2 #hinban2$
											(if (= #flag nil)
												(if (= (car #hinban) #hinban2)
													(progn
														(setq #wk_hinban #hinban)
														(setq #flag T)
													)
												)
											)
										)
									)
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #value "N")
						(setq #value (nth 1 #wk_hinban))
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)


			;左右勝手 2018/04/27 YK ADD-S
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB逆引"
					(list
						(list "特性ID" "PLAN11" 'STR)
					)
				)
			)
			(if (= #QRY$ nil)
				(setq #value "NULL")
				(progn
					(setq #LR nil)
					(foreach #QRY #QRY$
						(if (= (member (nth 2 #QRY) #LR$) nil)
							(setq #LR$ (append #LR$ (list (list (nth 2 #QRY) (nth 5 #QRY)))))
						)
					)

					(setq #flag nil)
					(setq #ss (ssget "X" '((-3 ("G_WRKT")))))
					(if (/= #ss nil)
						(foreach #LR #LR$
							(if (= #flag nil)
								(progn
									(if (= (nth 30 &xd_WRKT$) (car #LR))
										(progn
											(setq #wk_LR #LR)
											(setq #flag T)
										)
									)
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #value "NULL")
						(setq #value (nth 0 #wk_LR))
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)
			;左右勝手 2018/04/27 YK ADD-E



			;天井高さ 2018/04/27 YK ADD-S
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB逆引"
					(list
						(list "特性ID" "PLAN48" 'STR)
					)
				)
			)
			(setq #wk_TEN "NULL")

  		; 現在のプラン情報(PLANINFO.CFG)を読み込む
  		(setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))

  		(if (assoc "CeilingHeight" #PLANINFO$)
    		(setq #value (nth 1 (assoc "CeilingHeight" #PLANINFO$)))
  		);_if

			(setq #flag nil)

			(foreach #QRY #QRY$
				(if (= #flag nil)
					(progn
						(if (= (nth 2 #QRY) #value)
							(progn
								(setq #wk_TEN #value)
								(setq #flag T)
							)
						)
					)
				)
			)
			(setq #ret$ (append #ret$ (list #wk_TEN)))
			;天井高さ 2018/04/27 YK ADD-E

			#ret$

		) ; ##GetInitData

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// 扉グレードの選択処理を行う
		;//
		;//******************************************************
		(defun ##SelDoorSeries (
			/
			;;; #DRSERI$$ #DRCOL$$はローカル定義しない
			#seri #Qry$$ #Qry$ #Q$ #sQ #i #no
			)

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##SelDoorSeries ☆☆☆☆☆")

			(setq #seri (nth 0 (nth (atoi (get_tile "drseri")) #DRSERI$$)))
			;;; (シリ記号   扉シリ記号   扉カラ記号) のリスト取得
			(setq #DRCOL$$
				(CFGetDBSQLRec CG_DBSESSION "扉シ管理"
					(list
						(list "扉シリ記号" #seri 'STR)
					)
				)
			)

			;;; SG_DRCOL$$に扉カラ名称を足す
			(setq #Qry$$ nil)
			(foreach #Qry$ #DRCOL$$
				(setq #Q$
					(car (CFGetDBSQLRec CG_DBSESSION "扉COLOR"
						(list
							(list "扉カラ記号"   (nth 1 #Qry$) 'STR)
						)
					))
				)

				(if #Q$
					(progn
						(setq #sQ (nth 1 #Q$))
						(setq #Qry$$ (append #Qry$$ (list (append #Qry$ (list #sQ)))))
					)
				)
			)

			(setq #DRCOL$$ #Qry$$)

			(if (not #DRCOL$$)
				(progn
					(mode_tile "drseri" 2)
					(start_list "drcol" 3)
					(add_list "")
					(end_list)
					(mode_tile "drcol" 1)
					(mode_tile "accept" 1)
					(set_tile "error" "扉COLORが獲得できませんでした。")
				)
				(progn
					(start_list "drcol" 3)
					(setq #i 0 #no 0)

					(foreach #Qry$ #DRCOL$$
						(add_list (nth 2 #Qry$))
						(if (= (nth 1 &door$) (nth 1 #Qry$))
							(setq #no #i)
						)
						(setq #i (1+ #i))
					)
					(end_list)
					(set_tile "error" "")
					(set_tile "drcol" (itoa #no))
					(mode_tile "drcol" 0)
					(mode_tile "accept" 0)
				)
			)

			(##SelDoorHandle)

		) ; ##SelDoorSeries

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// 取手選択肢の変更を行う
		;//
		;//******************************************************
		(defun ##SelDoorHandle (
			/
			;;; #DRCOL$$ #HANDLE$$はローカル定義しない
			#col$ #dr_seri #col #i #no #Qry$
			)

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##SelDoorHandle ☆☆☆☆☆")

			; 取手選択肢------------------------------------------
			(setq #col$ (nth (atoi (get_tile "drcol")) #DRCOL$$))
			(setq #dr_seri (nth 0 #col$))
			(setq #col (nth 1 #col$))

			(setq #HANDLE$$
				(CFGetDBSQLRec CG_DBSESSION "引手管理"
					(list
						(list "扉シリ記号"  #dr_seri  'STR)
						(list "扉カラ記号"  #col      'STR)
					)
				)
			)
			(start_list "handle" 3)
			(setq #i 0 #no 0)

			(foreach #Qry$ #HANDLE$$
				(add_list (strcat "(" (nth 3 #Qry$) ") " (nth 4 #Qry$)))
				(if (= (nth 2 &door$) (nth 3 #Qry$))
					(setq #no #i)
				)
				(setq #i (1+ #i))
			)
			(end_list)
			(set_tile "error" "")
			(set_tile "handle" (itoa #no))
			(mode_tile "handle" 0)
			(mode_tile "accept" 0)

		); ##SelDoorHandle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// CG床仕様：商品名の選択時処理を行う
		;// 　CG床仕様：色柄リストの設定、リストの有効化
		;//
		;//******************************************************
		(defun ##SelCG_Goods (
			/
			;;; #CG_YUKAIRO$$ #CG_YukairoCol$はローカル定義しない
			#sel_no #goods_type #yukairo$ #flr_col$
			)

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##SelCG_Goods ☆☆☆☆☆")

			(setq #sel_no (atoi (get_tile "goods")))
			(setq #goods_type (nth 1 (nth #sel_no #GBL_CGYukairoGoods$)))

			(setq #CG_YukairoCol$ nil)
			(foreach #yukairo$ #CG_YUKAIRO$$
				(if (= #goods_type (nth 2 #yukairo$))
					(setq #CG_YukairoCol$
						(append #CG_YukairoCol$
							(list
								(list
									(nth 3 #yukairo$)
									(nth 4 #yukairo$)
									(nth 5 #yukairo$)
								)
							)
						)
					)
				)
			)

			(if #CG_YukairoCol$
				(progn
					(start_list "flr_col" 3)
					(foreach #flr_col$ #CG_YukairoCol$
						(add_list (nth 0 #flr_col$))
					)
					(end_list)

					(set_tile "flr_col" "0")
					(mode_tile "flr_col" 0)

					(mode_tile "accept" 0)
				)
				(progn
					(start_list "flr_col" 3)
					(add_list "")
					(end_list)
					(mode_tile "flr_col" 1)

					(mode_tile "accept" 1)
				)
			)

		) ; ##SelCG_Goods

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// プルダウンリストの初期設定を行う
		;//
		;//******************************************************
    (defun ##GetDefIndex(
			&PLAN$$
			&value
			/
			#def #idx #flag
			)

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##GetDefIndex ☆☆☆☆☆")

			; デフォルト設定
      (setq #idx 0)
			(setq #flag nil)
			(setq #def 0)
			(repeat (length &PLAN$$)
				(if (= #flag nil)
					(if (= (nth 2 (nth #idx &PLAN$$)) &value)
						(progn
							(setq #flag T)
							(setq #def #idx)
						)
					)
				)
    		(setq #idx (1+ #idx))
   		)

			#def

		)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// プルダウンリストの初期設定を行う
		;//
		;//******************************************************
    (defun ##ResetInitInfo(
			&type_f	; 工種フラグ　T:キッチン nil:収納
			&Init$	; 初期値リスト
      /
			#i #no #Qry$ #def
			#plan05$$ #plan07$$ #plan04$$ #plan31$$ #plan02$$ #plan17$$
			#plan16$$ #plan06$$ #plan08$$ #plan32$$ #plan19$$ #plan22$$
			#plan20$$ #plan21$$ #plan42$$ #plan23$$ #plan44$$ #plan47$$
			#goods$ ;-- 2012/01/18 A.Satoh Add CG対応
			#PLAN15$$ ;2016/04/15 YM ADD
			#plan11$$ ;2018/04/26 YK ADD
			#plan48$$ ;2018/04/26 YK ADD
      )

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##ResetInitInfo ☆☆☆☆☆")

      ; 扉関連
      (start_list "drseri" 3)
      (setq #i 0 #no 0)
      (foreach #Qry$ #DRSERI$$
        (add_list (nth 1 #Qry$))

        (if (= (nth 0 &door$) (nth 0 #Qry$))
          (setq #no #i)
        )
        (setq #i (1+ #i))
      )
      (end_list)

      (set_tile "drseri" (itoa #no))
      (##SelDoorSeries)

			(setq #plan05$$ (nth  0 #GBL_TOKUSEI$))	; 形状
			(setq #plan07$$ (nth  1 #GBL_TOKUSEI$))	; 奥行き
			(setq #plan04$$ (nth  2 #GBL_TOKUSEI$))	; キッチン間口
			(setq #plan31$$ (nth  3 #GBL_TOKUSEI$))	; ワークトップ高さ
			(setq #plan02$$ (nth  4 #GBL_TOKUSEI$))	; キャビネットプラン
			(setq #plan17$$ (nth  5 #GBL_TOKUSEI$))	; シンク
			(setq #plan16$$ (nth  6 #GBL_TOKUSEI$))	; ワークトップ材質
			(setq #plan06$$ (nth  7 #GBL_TOKUSEI$))	; フロアキャビタイプ
			(setq #plan08$$ (nth  8 #GBL_TOKUSEI$))	; ソフトクローズ
			(setq #plan32$$ (nth  9 #GBL_TOKUSEI$))	; 吊戸高さ
			(setq	#plan19$$ (nth 10 #GBL_TOKUSEI$))	; 水栓
			(setq #plan22$$ (nth 11 #GBL_TOKUSEI$))	; 浄水器
			(setq #plan20$$ (nth 12 #GBL_TOKUSEI$))	; 加熱機器
			(setq #plan21$$ (nth 13 #GBL_TOKUSEI$))	; コンロ下オーブン
			(setq #plan42$$ (nth 14 #GBL_TOKUSEI$))	; 食洗
			(setq #plan23$$ (nth 15 #GBL_TOKUSEI$))	; レンジフード
			(setq #plan44$$ (nth 16 #GBL_TOKUSEI$))	; ガラスパーティション
			(setq #plan47$$ (nth 17 #GBL_TOKUSEI$))	; キッチンパネル

			;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			(setq #plan15$$ (nth 18 #GBL_TOKUSEI$))	; シンク下キャビネット
			;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

			;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			(setq #plan11$$ (nth 19 #GBL_TOKUSEI$))	; 左右勝手
			(setq #plan48$$ (nth 20 #GBL_TOKUSEI$))	; 天井高さ
			;2018/04/26 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


      ; 形状
      (start_list "type" 3)
      (foreach #plan05$ #plan05$$
        (add_list (nth 1 #plan05$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan05$$ (nth 0 &Init$)))
		      (set_tile "type" (itoa #def))
					(mode_tile "type" 0)
				)
				(progn
		      (set_tile "type" "0")
					(mode_tile "type" 1)
				)
			)

      ; 奥行き
      (start_list "deep" 3)
      (foreach #plan07$ #plan07$$
        (add_list (nth 1 #plan07$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan07$$ (nth 1 &Init$)))
		      (set_tile "deep" (itoa #def))
					(mode_tile "deep" 0)
				)
				(progn
		      (set_tile "deep" "0")
					(mode_tile "deep" 1)
				)
			)

      ; キッチン間口
      (start_list "maguchi" 3)
      (foreach #plan04$ #plan04$$
        (add_list (nth 1 #plan04$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan04$$ (nth 2 &Init$)))
		      (set_tile "maguchi" (itoa #def))
					(mode_tile "maguchi" 0)
				)
				(progn
		      (set_tile "maguchi" "0")
					(mode_tile "maguchi" 1)
				)
			)

      ; ワークトップ高さ
      (start_list "wtheight" 3)
      (foreach #plan31$ #plan31$$
        (add_list (nth 1 #plan31$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan31$$ (nth 3 &Init$)))
		      (set_tile "wtheight" (itoa #def))
					(mode_tile "wtheight" 0)
				)
				(progn
		      (set_tile "wtheight" "0")
					(mode_tile "wtheight" 1)
				)
			)

      ; キャビネットプラン
      (start_list "cab_plan" 3)
      (foreach #plan02$ #plan02$$
        (add_list (nth 1 #plan02$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan02$$ (nth 4 &Init$)))
		      (set_tile "cab_plan" (itoa #def))
					(mode_tile "cab_plan" 0)
				)
				(progn
		      (set_tile "cab_plan" "0")
					(mode_tile "cab_plan" 1)
				)
			)

      ; シンク
      (start_list "sink" 3)
      (foreach #plan17$ #plan17$$
        (add_list (nth 1 #plan17$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan17$$ (nth 5 &Init$)))
		      (set_tile "sink" (itoa #def))
					(mode_tile "sink" 0)
				)
				(progn
		      (set_tile "sink" "0")
					(mode_tile "sink" 1)
				)
			)

      ; ワークトップ材質
      (start_list "wt_zai" 3)
      (foreach #plan16$ #plan16$$
        (add_list (nth 1 #plan16$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan16$$ (nth 6 &Init$)))
		      (set_tile "wt_zai" (itoa #def))
					(mode_tile "wt_zai" 0)
				)
				(progn
		      (set_tile "wt_zai" "0")
					(mode_tile "wt_zai" 1)
				)
			)

      ; フロアキャビタイプ
      (start_list "floor_cab" 3)
      (foreach #plan06$ #plan06$$
        (add_list (nth 1 #plan06$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan06$$ (nth 7 &Init$)))
		      (set_tile "floor_cab" (itoa #def))
					(mode_tile "floor_cab" 0)
				)
				(progn
		      (set_tile "floor_cab" "0")
					(mode_tile "floor_cab" 1)
				)
			)



;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      ; シンク下キャビネット
      (start_list "sinkunder_cab" 3)
      (foreach #plan15$ #plan15$$
        (add_list (nth 1 #plan15$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan15$$ (nth 8 &Init$)))
		      (set_tile "sinkunder_cab" (itoa #def))
					(mode_tile "sinkunder_cab" 0)
				)
				(progn
		      (set_tile "sinkunder_cab" "0")
					(mode_tile "sinkunder_cab" 1)
				)
			)
;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



      ; ソフトクローズ
      (start_list "soft_close" 3)
      (foreach #plan08$ #plan08$$
        (add_list (nth 1 #plan08$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan08$$ (nth 9 &Init$)))
		      (set_tile "soft_close" (itoa #def))
					(mode_tile "soft_close" 0)
				)
				(progn
		      (set_tile "soft_close" "0")
					(mode_tile "soft_close" 1)
				)
			)

      ; 吊戸高さ
      (start_list "wool_height" 3)
      (foreach #plan32$ #plan32$$
        (add_list (nth 1 #plan32$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan32$$ (nth 10 &Init$)))
		      (set_tile "wool_height" (itoa #def))
					(mode_tile "wool_height" 0)
				)
				(progn
		      (set_tile "wool_height" "0")
					(mode_tile "wool_height" 1)
				)
			)

      ; 水栓
      (start_list "water" 3)
      (foreach #plan19$ #plan19$$
        (add_list (nth 1 #plan19$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan19$$ (nth 11 &Init$)))
		      (set_tile "water" (itoa #def))
					(mode_tile "water" 0)
				)
				(progn
		      (set_tile "water" "0")
					(mode_tile "water" 1)
				)
			)

      ; 浄水器
;-- 2011/10/29 現時点では、浄水器は選択付加
;|
      (start_list "josui" 3)
      (foreach #plan22$ #plan22$$
        (add_list (nth 1 #plan22$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan22$$ (nth 11 &Init$)))
		      (set_tile "josui" (itoa #def))
					(mode_tile "josui" 0)
				)
				(progn
		      (set_tile "josui" "0")
					(mode_tile "josui" 1)
				)
			)
|;
      (set_tile "josui" "0")
			(mode_tile "josui" 1)

      ; 加熱機器
      (start_list "conro" 3)
      (foreach #plan20$ #plan20$$
        (add_list (nth 1 #plan20$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan20$$ (nth 13 &Init$)))
		      (set_tile "conro" (itoa #def))
					(mode_tile "conro" 0)
				)
				(progn
		      (set_tile "conro" "0")
					(mode_tile "conro" 1)
				)
			)

      ; コンロ下オーブン
      (start_list "oven" 3)
      (foreach #plan21$ #plan21$$
        (add_list (nth 1 #plan21$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan21$$ (nth 14 &Init$)))
		      (set_tile "oven" (itoa #def))
					(mode_tile "oven" 0)
				)
				(progn
		      (set_tile "oven" "0")
					(mode_tile "oven" 1)
				)
			)

      ; 食洗
      (start_list "syokusen" 3)
      (foreach #plan42$ #plan42$$
        (add_list (nth 1 #plan42$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan42$$ (nth 15 &Init$)))
		      (set_tile "syokusen" (itoa #def))
					(mode_tile "syokusen" 0)
				)
				(progn
		      (set_tile "syokusen" "0")
					(mode_tile "syokusen" 1)
				)
			)

      ; レンジフード
      (start_list "rennji" 3)
      (foreach #plan23$ #plan23$$
        (add_list (nth 1 #plan23$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan23$$ (nth 16 &Init$)))
		      (set_tile "rennji" (itoa #def))
					(mode_tile "rennji" 0)
				)
				(progn
		      (set_tile "rennji" "0")
					(mode_tile "rennji" 1)
				)
			)

      ; ガラスパーティション
      (start_list "glass" 3)
      (foreach #plan44$ #plan44$$
        (add_list (nth 1 #plan44$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan44$$ (nth 17 &Init$)))
		      (set_tile "glass" (itoa #def))
					(mode_tile "glass" 0)
				)
				(progn
		      (set_tile "glass" "0")
					(mode_tile "glass" 1)
				)
			)

      ; キッチンパネル
;      (start_list "panel" 3)
;      (foreach #plan47$ #plan47$$
;        (add_list (nth 1 #plan47$))
;      )
;      (end_list)
			(if (= &type_f T)
				(progn
		      (start_list "panel" 3)
    		  (foreach #plan47$ #plan47$$
        		(add_list (nth 1 #plan47$))
		      )
    		  (end_list)

					; デフォルト設定
					(setq #def (##GetDefIndex #plan47$$ (nth 18 &Init$)))
		      (set_tile "panel" (itoa #def))
					(mode_tile "panel" 0)
				)
				(progn
		      (start_list "panel" 3)
       		(add_list "")
    		  (end_list)

		      (set_tile "panel" "0")
					(mode_tile "panel" 1)
				)
			)

			;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      ; 左右勝手
      (start_list "sayu_katte" 3)
      (foreach #plan11$ #plan11$$
        (add_list (nth 1 #plan11$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan11$$ (nth 19 &Init$)))
		      (set_tile "sayu_katte" (itoa #def))
					(mode_tile "sayu_katte" 0)
				)
				(progn
		      (set_tile "sayu_katte" "0")
					(mode_tile "sayu_katte" 1)
				)
			)

      ; 天井高さ
      (start_list "tenjo_height" 3)
      (foreach #plan48$ #plan48$$
        (add_list (nth 1 #plan48$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; デフォルト設定
					(setq #def (##GetDefIndex #plan48$$ (nth 20 &Init$)))
		      (set_tile "tenjo_height" (itoa #def))
					(mode_tile "tenjo_height" 0)
				)
				(progn
		      (set_tile "tenjo_height" "0")
					(mode_tile "tenjo_height" 1)
				)
			)
			;2018/04/26 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;-- 2012/01/18 A.Satoh Add CG対応 - S
			; 商品名
      (start_list "goods" 3)
;;;;;      (foreach #goods$ #GBL_CGYukairoGoods$
;;;;;        (add_list (nth 0 #goods$))
;;;;;      )
			(add_list "")
      (end_list)
			(set_tile "goods" "0")
;;;;;			(mode_tile "goods" 0)
			(mode_tile "goods" 1)

			(start_list "flr_col" 3)
			(add_list "")
			(end_list)
			(set_tile "flr_col" "0")
			(mode_tile "flr_col" 1)

;-- 2012/03/05 A.Satoh Add CG背景色白対応 - S
			(set_tile "all_white" "0")
			(mode_tile "all_white" 1)
;-- 2012/03/05 A.Satoh Add CG背景色白対応 - E

			(mode_tile "accept" 1)
;-- 2012/01/18 A.Satoh Add CG対応 - S

    ) ; ##ResetInitInfo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// 取得したPB特性値情報から特性値別情報リストを作成する
		;//
		;//******************************************************
    (defun ##GetPBTokusei(
			&PB_TOKUSEI$$
      /
			#PB_TOKUSEI$ #ret$ #name
			#plan05$ #plan07$ #plan04$ #plan31$ #plan02$ #plan17$
			#plan16$ #plan06$ #plan08$ #plan19$ #plan22$ #plan20$
			#plan21$ #plan44$ #plan42$ #plan32$ #plan23$ #plan47$
			#plan15$ ;2016/04/15 YM ADD
			#plan11$ ;2018/04/26 YK ADD
			#plan48$ ;2018/04/26 YK ADD
      )

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##GetPBTokusei ☆☆☆☆☆")

			(setq #plan05$ nil #plan07$ nil #plan04$ nil #plan31$ nil #plan02$ nil #plan17$ nil)
			(setq #plan16$ nil #plan06$ nil #plan08$ nil #plan19$ nil #plan22$ nil #plan20$ nil)
			(setq #plan21$ nil #plan44$ nil #plan42$ nil #plan32$ nil #plan23$ nil #plan47$ nil)
			;2016/04/15 YM ADD-S
			(setq #plan15$ nil)
			;2016/04/15 YM ADD-E

			;2018/04/26 YK ADD-S
			(setq #plan11$ nil)
			(setq #plan48$ nil)
			;2018/04/26 YK ADD-E

;;;(princ "\n =============================")
;;;(princ "\n &PB_TOKUSEI$$=")
;;;(princ &PB_TOKUSEI$$)
;;;(princ "\n =============================")

			(foreach #PB_TOKUSEI$ &PB_TOKUSEI$$
				(if (= (nth 3 #PB_TOKUSEI$) nil)
					(setq #name "")
					(setq #name (nth 3 #PB_TOKUSEI$))
				)

				(cond
					((= (nth 1 #PB_TOKUSEI$) "PLAN05")	; 形状
						(setq #plan05$ (append #plan05$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN07")	; 奥行き
						(setq #plan07$ (append #plan07$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN04")	; キッチン間口
						(setq #plan04$ (append #plan04$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN31")	; ワークトップ高さ
						(setq #plan31$ (append #plan31$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN02")	; キャビネットプラン
						(setq #plan02$ (append #plan02$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN17")	; シンク
						(setq #plan17$ (append #plan17$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN16")	; ワークトップ材質
						(setq #plan16$ (append #plan16$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN06")	; フロアキャビタイプ
						(setq #plan06$ (append #plan06$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN08")	; ソフトクローズ
						(setq #plan08$ (append #plan08$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN32")	; 吊戸高さ
						(setq #plan32$ (append #plan32$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN19")	; 水栓
						(setq #plan19$ (append #plan19$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN22")	; 浄水器
						(setq #plan22$ (append #plan22$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN20")	; 加熱機器
						(setq #plan20$ (append #plan20$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN21")	; コンロ下オーブン
						(setq #plan21$ (append #plan21$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN42")	; 食洗
						(setq #plan42$ (append #plan42$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN23")	; レンジフード
						(setq #plan23$ (append #plan23$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN44")	; ガラスパーティション
						(setq #plan44$ (append #plan44$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN47")	; キッチンパネル
						(setq #plan47$ (append #plan47$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					((= (nth 1 #PB_TOKUSEI$) "PLAN15")	; シンク下キャビネット
						(setq #plan15$ (append #plan15$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

					;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					((= (nth 1 #PB_TOKUSEI$) "PLAN11")	; 左右勝手
						(setq #plan11$ (append #plan11$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN48")	; 天井高さ
						(setq #plan48$ (append #plan48$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					;2018/04/26 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
				)
			)

			(setq #ret$
				(list
					#plan05$	; 形状
					#plan07$	; 奥行き
					#plan04$	; キッチン間口
					#plan31$	; ワークトップ高さ
					#plan02$	; キャビネットプラン
					#plan17$	; シンク
					#plan16$	; ワークトップ材質
					#plan06$	; フロアキャビタイプ
					#plan08$	; ソフトクローズ
					#plan32$	; 吊戸高さ
					#plan19$	; 水栓
					#plan22$	; 浄水器
					#plan20$	; 加熱機器
					#plan21$	; コンロ下オーブン
					#plan42$	; 食洗
					#plan23$	; レンジフード
					#plan44$	; ガラスパーティション
					#plan47$	; キッチンパネル
					;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					#plan15$	; シンク下キャビネット
					;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

					;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					#plan11$	; 左右勝手
					#plan48$	; 天井高さ
					;2018/04/26 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
				)
			)

      #ret$
    ) ; ##GetPBTokusei

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2012/01/25 A.Satoh Add - S
		;//******************************************************
		;//
    ;// CG有無のラジオボタン選択時の床商品名リストの活性化
		;// 非活性化を行う
		;//
		;//******************************************************
    (defun ##SetInitCG_List(
      /
			#cg_y #cg_n #goods$
      )

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##SetInitCG_List ☆☆☆☆☆")

			(setq #cg_y (get_tile "cg_y"))
			(setq #cg_n (get_tile "cg_n"))

			(if (or (/= #OLD_CG_Y #cg_y) (/= #OLD_CG_N #cg_n))
				(progn
					(setq #OLD_CG_Y #cg_y)
					(setq #OLD_CG_N #cg_n)

					(if (= #cg_y "1")
						(progn
							; 商品名
    				  (start_list "goods" 3)
		    		  (foreach #goods$ #GBL_CGYukairoGoods$
    		  		  (add_list (nth 0 #goods$))
		      		)
				      (end_list)
							(set_tile "goods" "0")
							(mode_tile "goods" 0)

							; 床色柄
							(setq #CG_YukairoCol$ nil)

							(start_list "flr_col" 3)
							(add_list "")
							(end_list)
							(set_tile "flr_col" "0")
							(mode_tile "flr_col" 1)

;-- 2012/03/05 A.Satoh Add CG背景色白対応 - S
							(mode_tile "all_white" 0)
;-- 2012/03/05 A.Satoh Add CG背景色白対応 - E

							(mode_tile "accept" 1)
						)
						(progn
							(setq #CG_YukairoCol$ nil)

			    	  (start_list "goods" 3)
							(add_list "")
			  	    (end_list)
							(set_tile "goods" "0")
							(mode_tile "goods" 1)

							(start_list "flr_col" 3)
							(add_list "")
							(end_list)
							(set_tile "flr_col" "0")
							(mode_tile "flr_col" 1)

;-- 2012/03/05 A.Satoh Add CG背景色白対応 - S
							(set_tile "all_white" "0")
							(mode_tile "all_white" 1)
;-- 2012/03/05 A.Satoh Add CG背景色白対応 - E

							(mode_tile "accept" 0)
						)
					)
				)
			)

    ) ; ##SetInitCG_List
;-- 2012/01/25 A.Satoh Add - E

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2012/03/05 A.Satoh Add - S
		;//******************************************************
		;//
    ;// 「背景色白」チェック選択時の床商品名リストの活性化
		;// 非活性化を行う
		;//
		;//******************************************************
    (defun ##SetAllWhite(
      /
			#goods$ #all_white
      )

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##SetAllWhite ☆☆☆☆☆")

			(setq #all_white (get_tile "all_white"))

			(if (= #all_white "1")
				(progn
					(setq #CG_YukairoCol$ nil)

	    	  (start_list "goods" 3)
					(add_list "")
	  	    (end_list)
					(set_tile "goods" "0")
					(mode_tile "goods" 1)

					(start_list "flr_col" 3)
					(add_list "")
					(end_list)
					(set_tile "flr_col" "0")
					(mode_tile "flr_col" 1)

					; ＯＫボタン活性化
					(mode_tile "accept" 0)
				)
				(progn
					; 商品名
 				  (start_list "goods" 3)
    		  (foreach #goods$ #GBL_CGYukairoGoods$
 		  		  (add_list (nth 0 #goods$))
      		)
		      (end_list)
					(set_tile "goods" "0")
					(mode_tile "goods" 0)

					; 床色柄
					(setq #CG_YukairoCol$ nil)

					(start_list "flr_col" 3)
					(add_list "")
					(end_list)
					(set_tile "flr_col" "0")
					(mode_tile "flr_col" 1)

					; ＯＫボタン非活性化
					(mode_tile "accept" 1)
				)
			)

    ) ; ##SetAllWhite
;-- 2012/03/05 A.Satoh Add - E

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// ＯＫが押された
		;//
		;//******************************************************
    (defun ##SetPresenInfo_CallBack(
      /
;;; #GBL_TOKUSEI$はローカル定義しない
			#ret$
			#plan05$$ #plan07$$ #plan04$$ #plan31$$ #plan02$$ #plan17$$
			#plan16$$ #plan06$$ #plan08$$ #plan32$$ #plan19$$ #plan22$$
			#plan20$$ #plan21$$ #plan42$$ #plan23$$ #plan44$$ #plan47$$
			#err_flag #cg_y #goods #flrcol #flr_col$
#file$ ;-- 2012/02/29 A.Satoh Add
#allWhite ;-- 2012/03/05 A.Satoh Add
 			#plan11$$ #plan48$$ ;-- 2018/04/26 YK Add
     )

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##SetPresenInfo_CallBack ☆☆☆☆☆")

;-- 2012/01/25 A.Satoh Add CG対応 - S
			(setq #err_flag nil)

			; CG仕様の入力確認
			(setq #cg_y (get_tile "cg_y"))
			(setq #goods (get_tile "goods"))
;-- 2012/03/05 A.Satoh Mod - S
			(setq #allWhite (get_tile "all_white"))
;-- 2012/03/05 A.Satoh Mod - E

;-- 2012/03/05 A.Satoh Mod - S
;;;;;			(if (and (= #cg_y "1") (= (atoi (get_tile "goods")) 0))
			(if (and (= #cg_y "1") (= #allWhite "0") (= (atoi (get_tile "goods")) 0))
;-- 2012/03/05 A.Satoh Mod - E
				(progn
					(set_tile "error" "床商品名が選択されていません")
					(mode_tile "goods" 2)
					(setq #err_flag T)
				)
			)
;-- 2012/01/25 A.Satoh Add CG対応 - E

;-- 2012/02/29 A.Satoh Add - S
			(if (= #err_flag nil)
				(if (= #cg_y "1")
					(progn
						; 「CGあり」である場合、パース図面の存在チェックを行う
						(setq #file$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT") "*立体*.dwg"))
						(if (= #file$ nil)
							(progn
								;;; 「MB_ICONASTERISK」は「MB_ICONINFORMATION」と同じ
								;;; KPCADでは「MB_ICONINFORMATION」の代わりに「MB_ICONASTERISK」を使用する。
								(c:msgbox "CGありの場合、必ずCG用のパース図面を作成するようにして下さい。" "情報" (logior MB_OK MB_ICONASTERISK))
								(setq #err_flag T)
							)
						)
					)
				)
			)
;-- 2012/02/29 A.Satoh Add - E

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE ##SetPresenInfo_CallBack #GBL_TOKUSEI$ ☆☆☆☆☆")
;;;(princ #GBL_TOKUSEI$)

			(if (= #err_flag nil)
				(progn
					(setq #plan05$$ (nth  0 #GBL_TOKUSEI$))	; 形状
;;;(princ "\n☆☆☆☆☆0")
					(setq #plan07$$ (nth  1 #GBL_TOKUSEI$))	; 奥行き
;;;(princ "\n☆☆☆☆☆1")
					(setq #plan04$$ (nth  2 #GBL_TOKUSEI$))	; キッチン間口
;;;(princ "\n☆☆☆☆☆2")
					(setq #plan31$$ (nth  3 #GBL_TOKUSEI$))	; ワークトップ高さ
;;;(princ "\n☆☆☆☆☆3")
					(setq #plan02$$ (nth  4 #GBL_TOKUSEI$))	; キャビネットプラン
;;;(princ "\n☆☆☆☆☆4")
					(setq #plan17$$ (nth  5 #GBL_TOKUSEI$))	; シンク
;;;(princ "\n☆☆☆☆☆5")
					(setq #plan16$$ (nth  6 #GBL_TOKUSEI$))	; ワークトップ材質
;;;(princ "\n☆☆☆☆☆6")
					(setq #plan06$$ (nth  7 #GBL_TOKUSEI$))	; フロアキャビタイプ
;;;(princ "\n☆☆☆☆☆7")
					(setq #plan08$$ (nth  8 #GBL_TOKUSEI$))	; ソフトクローズ
;;;(princ "\n☆☆☆☆☆8")
					(setq #plan32$$ (nth  9 #GBL_TOKUSEI$))	; 吊戸高さ
;;;(princ "\n☆☆☆☆☆9")
					(setq	#plan19$$ (nth 10 #GBL_TOKUSEI$))	; 水栓
;;;(princ "\n☆☆☆☆☆10")
					(setq #plan22$$ (nth 11 #GBL_TOKUSEI$))	; 浄水器
;;;(princ "\n☆☆☆☆☆11")
					(setq #plan20$$ (nth 12 #GBL_TOKUSEI$))	; 加熱機器
;;;(princ "\n☆☆☆☆☆12")
					(setq #plan21$$ (nth 13 #GBL_TOKUSEI$))	; コンロ下オーブン
;;;(princ "\n☆☆☆☆☆13")
					(setq #plan42$$ (nth 14 #GBL_TOKUSEI$))	; 食洗
;;;(princ "\n☆☆☆☆☆14")
					(setq #plan23$$ (nth 15 #GBL_TOKUSEI$))	; レンジフード
;;;(princ "\n☆☆☆☆☆15")
					(setq #plan44$$ (nth 16 #GBL_TOKUSEI$))	; ガラスパーティション
;;;(princ "\n☆☆☆☆☆16")
					(setq #plan47$$ (nth 17 #GBL_TOKUSEI$))	; キッチンパネル
;;;(princ "\n☆☆☆☆☆17")

					;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #plan15$$ (nth 18 #GBL_TOKUSEI$))	;シンク下キャビネット
					;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;(princ "\n☆☆☆☆☆18")

					;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #plan11$$ (nth 19 #GBL_TOKUSEI$))	;シンク下キャビネット
					(setq #plan48$$ (nth 20 #GBL_TOKUSEI$))	;シンク下キャビネット
					;2018/04/26 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;-- 2012/01/18 A.Satoh Add CG対応 - S
					(setq #flrcol (atoi (get_tile "flr_col")))	; CG床仕様：色柄選択番号
;-- 2012/03/05 A.Satoh Mod - S
;					(if #CG_YukairoCol$
;						(setq #flr_col$ (nth #flrcol #CG_YukairoCol$))
;						(setq #flr_col$ (list "" "" "FLOOR_COLOR"))
;					)
					(if (= #cg_y "1")
						(if (= #allWhite "1")
							(setq #flr_col$ (list "" "KP_NO_FLOOR" "FLOOR_COLOR"))
							(setq #flr_col$ (nth #flrcol #CG_YukairoCol$))
						)
						(setq #flr_col$ (list "" "" "FLOOR_COLOR"))
					);_if

;-- 2012/03/05 A.Satoh Mod - E
;-- 2012/01/18 A.Satoh Add CG対応 - E

;;;(princ "\n☆☆☆☆☆ #DRSERI$$ = ")(princ #DRSERI$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #DRCOL$$ = ")(princ #DRCOL$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #HANDLE$$ = ")(princ #HANDLE$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan05$$ = ")(princ #plan05$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan04$$ = ")(princ #plan04$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan31$$ = ")(princ #plan31$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan02$$ = ")(princ #plan02$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan17$$ = ")(princ #plan17$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan16$$ = ")(princ #plan16$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan06$$ = ")(princ #plan06$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan15$$ = ")(princ #plan15$$)(princ "\n")
;;;
;;;(princ "\n☆☆☆☆☆ #plan08$$ = ")(princ #plan08$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan32$$ = ")(princ #plan32$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan19$$ = ")(princ #plan19$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan22$$ = ")(princ #plan22$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan20$$ = ")(princ #plan20$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan21$$ = ")(princ #plan21$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan42$$ = ")(princ #plan42$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan23$$ = ")(princ #plan23$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan44$$ = ")(princ #plan44$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #plan47$$ = ")(princ #plan47$$)(princ "\n")
;;;(princ "\n☆☆☆☆☆ #cg_y = ")(princ #cg_y)(princ "\n")

					(setq #ret$
						(list
							(nth 0 (nth (atoi (get_tile "drseri"))      #DRSERI$$))	; 扉グレード
							(nth 1 (nth (atoi (get_tile "drcol"))       #DRCOL$$ ))	; 扉カラー
							(nth 3 (nth (atoi (get_tile "handle"))      #HANDLE$$))	; 引手
							(nth 2 (nth (atoi (get_tile "type"))        #plan05$$))	; 形状
							(nth 2 (nth (atoi (get_tile "deep"))        #plan07$$))	; 奥行き
							(nth 2 (nth (atoi (get_tile "maguchi"))     #plan04$$))	; キッチン間口
							(nth 2 (nth (atoi (get_tile "wtheight"))    #plan31$$))	; ワークトップ高さ
							(nth 2 (nth (atoi (get_tile "cab_plan"))    #plan02$$))	; キャビネットプラン
							(nth 2 (nth (atoi (get_tile "sink"))        #plan17$$))	; シンク
							(nth 2 (nth (atoi (get_tile "wt_zai"))      #plan16$$))	; ワークトップ材質
							(nth 2 (nth (atoi (get_tile "floor_cab"))   #plan06$$))	; フロアキャビタイプ
							;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@
							(nth 2 (nth (atoi (get_tile "sinkunder_cab")) #plan15$$))	; シンク下キャビネット
							;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@
							(nth 2 (nth (atoi (get_tile "soft_close"))  #plan08$$))	; ソフトクローズ
							(nth 2 (nth (atoi (get_tile "wool_height")) #plan32$$))	; 吊戸高さ
							(nth 2 (nth (atoi (get_tile "water"))       #plan19$$))	; 水栓
							(nth 2 (nth (atoi (get_tile "josui"))       #plan22$$))	; 浄水器
							(nth 2 (nth (atoi (get_tile "conro"))       #plan20$$))	; 加熱機器
							(nth 2 (nth (atoi (get_tile "oven"))        #plan21$$))	; コンロ下オーブン
							(nth 2 (nth (atoi (get_tile "syokusen"))    #plan42$$))	; 食洗
							(nth 2 (nth (atoi (get_tile "rennji"))      #plan23$$))	; レンジフード
							(nth 2 (nth (atoi (get_tile "glass"))       #plan44$$))	; ガラスパーティション
							(nth 2 (nth (atoi (get_tile "panel"))       #plan47$$))	; キッチンパネル
							;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@
							(nth 2 (nth (atoi (get_tile "sayu_katte"))   #plan11$$)) ; 左右勝手
							(nth 2 (nth (atoi (get_tile "tenjo_height")) #plan48$$)) ; 天井高さ
							;2018/04/26 YK YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@
;-- 2012/01/18 A.Satoh Add CG対応 - S
							#cg_y									; CG有無（CGありの値を設定 "1":CGあり "0":CGなし）
							(nth 2 #flr_col$)			; InputCfg項目
							(nth 1 #flr_col$)			; 色柄記号
							(nth 0 #flr_col$)			; 色柄名称
;-- 2012/01/18 A.Satoh Add CG対応 - E
;-- 2012/03/05 A.Satoh Add - S
							#allWhite
;-- 2012/03/05 A.Satoh Add - E
						)
					)

					(done_dialog 1)
				)
				(setq #ret$ nil)
			)

      #ret$
    ) ; ##SetPresenInfo_CallBack

		; 2017/06/15 KY ADD-S
		;//******************************************************
		;//
		;// 性格コードと特性IDにより、PB逆引きで初期値取得
		;//
		;//******************************************************
		(defun ##GetHinbanInitValue (
			&code		; (INT)性格コード(3桁)
			&id			; (STR)特性ID
			/
			#hinban
			#value
			)

			(setq #hinban (##GetHinban &code))

			(if (= #hinban nil)
				"N"
				;else
				(progn
					(setq #value (##GetGyakubukiValue &id #hinban))
					(if (= #value "NULL")
						(setq #value "N")
					)
					#value
				);progn
			);if
		);##GetHinbanInitValue

		;//******************************************************
		;//
		;// 項目の初期値取得(フレームキッチン用)
		;//
		;//******************************************************
		(defun ##GetInitData_FK$ (
			/
			#frames$$ #frame$ #counters$$ #counter$ #type #depth #width #height #sink #dimW #dimD
			#pt1 #pt2 #pt3 #pt4 #ang #bpc #pc #tmp1 #tmp2 #totalW #tmp #hinban
			#Init$ #qry$$
#value44 #value47 ;2017/11/02 YM ADD
#value11 #value48 ;2018/05/07 YK ADD
			)

			(setq #Init$ nil)
			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
				(progn
					; フレーム情報の取得
					(setq #frames$$ (GetFrameInfo$$ T T))
					(setq #counters$$ (nth 1 #frames$$))
					(setq #frames$$ (nth 0 #frames$$))

					; 形状の取得 ---------------------------------------------
					(setq #type "NULL")
					(foreach #counter$ #counters$$
						(if (= #type "NULL")
							(progn
								(setq #hinban (nth 2 #counter$))
								(setq #tmp (vl-string-position (ascii "-") #hinban 6)) ; 品番の最初のハイフンの直後で判断
								(if #tmp
									(progn
										(setq #tmp (substr #hinban (1+ #tmp) 1))
										(cond
											((= #tmp "A") ; I型
												(setq #type "I00")
											)
											((= #tmp "C") ; P型
												(setq #type "IPA")
											)
											((= #tmp "K") ; 収納
												(setq #type "?")
											)
										);cond
									);progn
								);if
								(if (= #type "NULL")
									(progn
										(setq #tmp (fix (+ (nth 1 (nth 3 #counter$)) 0.1)))
										(cond
											((= #tmp 650) ; I型
												(setq #type "I00")
											)
											((= #tmp 900) ; P型
												(setq #type "IPA")
											)
											((= #tmp 450) ; 収納
												(setq #type "?")
											)
										);cond
									);progn
								);if
							);progn
						);if
					);foreach
					; --------------------------------------------------------

					; 奥行きの取得 -------------------------------------------
					(setq #depth "NULL")
					(foreach #counter$ #counters$$
						(if (= #depth "NULL")
							(progn
								(setq #tmp (fix (+ (nth 1 (nth 3 #counter$)) 0.1)))
								(setq #qry$$ (CFGetDBSQLRec CG_DBSESSION "奥行" (list (list "奥行" (itoa #tmp) 'INT))))
								(if #qry$$
									(setq #depth (nth 1 (nth 0 #qry$$)))
								);if
							);progn
						);if
					);foreach
					; --------------------------------------------------------

					; キッチン間口の取得 -------------------------------------
					(setq #ang nil)
					(setq #totalW 0.0)
					(setq #width nil)
					(foreach #counter$ #counters$$
						(setq #pt1 nil)
						(if (= #ang nil)
							(progn
								(setq #ang (nth 5 #counter$))
								(setq #pt1 (nth 1 #counter$))
								;(setq #pt1 (list (nth 0 #pt1) (nth 1 #pt1) 0.0))
								(setq #pt1 (list-put-nth 0.0 #pt1 2))
								(setq #bpt #pt1)
							);progn
							;else
							(if (equal #ang (nth 5 #counter$) 0.0001)
								(progn
									(setq #pt1 (nth 1 #counter$))
									;(setq #pt1 (list (nth 0 #pt1) (nth 1 #pt1) 0.0))
									(setq #pt1 (list-put-nth 0.0 #pt1 2))
									(setq #pt1 (mapcar '- #pt1 #bpt)) ; 基準点からの相対座標
									(setq #pt1 (list (- (* (cos (- #ang)) (nth 0 #pt1)) (* (sin (- #ang)) (nth 1 #pt1)))
																	 (+ (* (sin (- #ang)) (nth 0 #pt1)) (* (cos (- #ang)) (nth 1 #pt1)))
																	 (nth 2 #pt1))) ; 回転
									(setq #pt1 (mapcar '+ #pt1 #bpt)) ; 絶対座標
								);progn
							);if
						);if
						(if #pt1
							(progn
								(setq #dimW (nth 0 (nth 3 #counter$)))
								(setq #dimD (nth 1 (nth 3 #counter$)))
								(setq #pt2 (list (+ (nth 0 #pt1) #dimW) (nth 1 #pt1) (nth 2 #pt1)))
								(setq #pt3 (list (nth 0 #pt2) (- (nth 1 #pt2) #dimD) (nth 2 #pt2)))
								(setq #pt4 (list (nth 0 #pt1) (- (nth 1 #pt1) #dimD) (nth 2 #pt1)))

								(setq #pc (mapcar '(lambda (#tmp1 #tmp2) (/ (+ #tmp1 #tmp2) 2.0)) #pt1 #pt3))
								(if (= #bpc nil)
									(progn
										(setq #bpc #pc)
										(setq #totalW #dimW)
									);progn
									;else
									(progn
										(setq #tmp (+ (- #totalW (- (nth 0 #bpc) (nth 0 #bpt))) (/ #dimW 2.0)))
										(if (equal (mapcar '- #pc #bpc) (list #tmp 0.0 0.0) 0.1)
											(setq #totalW (+ #totalW #dimW))
										);if
									);progn
								);if
							);progn
						);if
					);foreach
					(setq #tmp (fix (+ #totalW 0.1)))
					(if (> #tmp 0)
						(progn
							(setq #qry$$ (CFGetDBSQLRec CG_DBSESSION "間口" (list (list "間口" (itoa #tmp) 'INT))))
							(if #qry$$
								(setq #width (nth 1 (nth 0 #qry$$)))
							);if
						);progn
					);if
					(if (= nil #width)
						(setq #width "NULL")
					);if
					; --------------------------------------------------------

					; ワークトップ高さの取得 ---------------------------------
					(setq #height "NULL")
					(foreach #counter$ #counters$$
						(if (= #height "NULL")
							(progn
								(setq #tmp (+ (nth 2 (nth 1 #counter$)) (nth 2 (nth 3 #counter$))))
								(setq #height (strcat "H" (itoa (fix (+ #tmp 0.1)))))
							);progn
						);if
					);foreach
					; --------------------------------------------------------

					; シンクの取得 -------------------------------------------
					(setq #sink "NULL")
					(foreach #counter$ #counters$$
						(if (= #sink "NULL")
							(progn
								(setq #hinban (nth 2 #counter$))
								(setq #tmp (vl-string-position (ascii "-") #hinban 6)) ; 品番の最初のハイフンの直前で判断
								(if #tmp
									(progn
										(setq #tmp (substr #hinban #tmp 1))
										(cond
											((= #tmp "S") ; ステンレススクエアマルチ
												(setq #sink "S15_")
											)
											((= #tmp "P") ; Pシンク
												(setq #sink "P_")
											)
										);cond
									);progn
								);if
							);progn
						);if
					);foreach
					; --------------------------------------------------------


			;;;;; ガラスパーティション
			(setq #GLASS$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from ガラスパティション")))
			(if (= #GLASS$$ nil)
				(setq #value "NULL")
				(progn
					; ガラスパーティション品番リストを作成
					(setq #hinban$ nil)
					(foreach #GLASS$ #GLASS$$
						(if (= (member (nth 5 #GLASS$) #hinban$) nil)
							(setq #hinban$ (append #hinban$ (list (nth 5 #GLASS$))))
						)
					)

					; 図面からガラスパーティションを検索
					(setq #flag nil)
					(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
					(if (/= #ss nil)
						(foreach #hinban #hinban$
							(if (= #flag nil)
								(progn
									(setq #idx 0)
									(repeat (sslength #ss)
										(if (= #flag nil)
											(progn
												(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
												(if (= (nth 5 #xd_LSYM$) #hinban)
													(progn
														(setq #flag T)
														(setq #hinban2 #hinban)
													)
												)
											)
										)
										(setq #idx (1+ #idx))
									)
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #value44 "NULL")
						(setq #value44 (##GetGyakubukiValue "PLAN44" #hinban2)) ;2017/11/2 YM  これを戻す
					)
;;;					(setq #ret$ (append #ret$ (list #value)))
				)
			);_if

			;;;;; キッチンパネル
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB逆引"
					(list
						(list "特性ID" "PLAN47" 'STR)
					)
				)
			)
			(if (= #QRY$ nil)
				(setq #value "N")
				(progn
					; キッチンパネル品番リストを作成
					(setq #hinban$ nil)
					(foreach #QRY #QRY$
						(if (= (member (nth 2 #QRY) #hinban$) nil)
							(setq #hinban$ (append #hinban$ (list (list (nth 2 #QRY) (nth 5 #QRY)))))
						)
					)

					; 図面からキッチンパネルを検索
					(setq #flag nil)
					(setq #hinban2 nil)
					(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
					(if (/= #ss nil)
						(foreach #hinban #hinban$
							(if (= #flag nil)
								(progn
									(setq #idx 0)
									(repeat (sslength #ss)
										(if (= #flag nil)
											(progn
												(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
												(if (= (nth 5 #xd_LSYM$) (car #hinban))
													(progn
														(setq #wk_hinban #hinban)
														(setq #flag T)
													)
												)
											)
										)
										(setq #idx (1+ #idx))
									)
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #value47 "N")
						(setq #value47 (nth 1 #wk_hinban)) ;2017/11/2 YM  これを戻す？？？
					)

					;左右勝手 2018/04/27 YK ADD-S
					(setq #value11 "NULL")
					;左右勝手 2018/04/27 YK ADD-E

					;天井高さ 2018/04/27 YK ADD-S
					(setq #QRY$
						(CFGetDBSQLRec CG_DBSESSION "PB逆引"
							(list
								(list "特性ID" "PLAN48" 'STR)
							)
						)
					)
					(setq #value48 "NULL")

  				; 現在のプラン情報(PLANINFO.CFG)を読み込む
  				(setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))

		  		(if (assoc "CeilingHeight" #PLANINFO$)
    				(setq #value (nth 1 (assoc "CeilingHeight" #PLANINFO$)))
  				);_if


					(foreach #QRY #QRY$
						(if (= (nth 2 #QRY) #value)
							(progn
								(setq #value48 #value)
							)
						)
					)
					;天井高さ 2018/04/27 YK ADD-E

					(if (= #flag nil)
					  (if (findfile (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
					    (progn
								(setq #hinban2$ nil)
					      (setq #spec$$ (ReadCSVFile (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg")))
					      (if #spec$$
					        (foreach #spec$ #spec$$
					          (setq #hinban2$ (append #hinban2$ (list (nth 0 (StrParse (nth 0 #spec$) "=")))))
									)
								)
								(foreach #hinban #hinban$
									(if (= #flag nil)
										(foreach #hinban2 #hinban2$
											(if (= #flag nil)
												(if (= (car #hinban) #hinban2)
													(progn
														(setq #wk_hinban #hinban)
														(setq #flag T)
													)
												)
											)
										)
									)
								)
							)
						)
					)
				)
			);_if


					(setq #Init$ (list
						; 形状
						#type
						; 奥行き
						#depth
						; キッチン間口
						#width
						; ワークトップ高さ
						#height
						; キャビネットプラン
						"NULL"
						; シンク
						#sink
						; ワークトップ材質
						"NULL"
						; フロアキャビタイプ
						"NULL"
						; シンク下キャビネット
						"NULL"
						; ソフトクローズ
						"NULL"
						; 吊戸高さ
						"NULL"
						; 水栓
						(##GetHinbanInitValue 510 "PLAN19")
						; 浄水器
						"N"
						; 加熱機器
						(##GetHinbanInitValue 210 "PLAN20")
						; コンロ下オーブン
						"NULL"
						; 食洗
						(##GetHinbanInitValue 110 "PLAN42")
						; レンジフード
						(##GetHinbanInitValue 320 "PLAN23")

						; ガラスパーティション
						;2017/11/02 YM MOD-S
;;;						"NULL"
						#value44
						;2017/11/02 YM MOD-E

						;2017/11/02 YM MOD-S
						; キッチンパネル
;;;						"N"
						#value47
						;2017/11/02 YM MOD-E

						;2018/05/07 YK ADD-S
						#value11
						#value48
						;2018/05/07 YK ADD-E

					))
				);progn
			);if
			#Init$
		);##GetInitData_FK$
		; 2017/06/15 KY ADD-E

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE　000　☆☆☆☆☆")

  (setq #err_flag nil)
;-- 2012/01/18 A.Satoh Add CG対応 - S
	(setq #CG_YukairoCol$ nil)
	(setq #CG_YUKAIRO$$ nil)
	(setq #OLD_CG_Y "0")
	(setq #OLD_CG_N "0")
;-- 2012/01/18 A.Satoh Add CG対応 - E

  (if (/= CG_DBSESSION nil)
    (progn
      (dbDisconnect CG_DBSESSION)
      (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
    )
    (progn
      (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
    )
  )

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE　111　☆☆☆☆☆")

  (if (= CG_DBSESSION nil)
    (progn
      (CFAlertMsg "SERIES別のデータベースがありませんでした")
      (setq #info$ nil)
      (setq #err_flag T)
    )
    (progn
      ;// 現在の扉SERIES、扉COLORの設定
      ;扉ｼﾘｰｽﾞのﾘｽﾄ
      (setq #DRSERI$$
        (CFGetDBSQLRec CG_DBSESSION "扉シリズ"
          (list
            (list "廃番F" "0"  'INT)
          )
        )
      )
      (if (= #DRSERI$$ nil)
        (progn
          (CFAlertMsg "【扉シリズ】にﾚｺｰﾄﾞがありません。")
          (setq #info$ nil)
          (setq #err_flag T)
        )
      )
    )
  );_if

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE　222　☆☆☆☆☆")


	(if (= #err_flag nil)
		(progn
			; PB特性値を取得する
			(setq #PB_TOKUSEI$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from PB特性値")))
			(if (= #PB_TOKUSEI$$ nil)
				(progn
					(CFAlertMsg "【PB特性値】にﾚｺｰﾄﾞがありません。")
					(setq #info$ nil)
					(setq #err_flag T)
				)
				(progn
					(setq #GBL_TOKUSEI$ (##GetPBTokusei #PB_TOKUSEI$$))
;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE　#GBL_TOKUSEI$　☆☆☆☆☆")
;;;(princ #GBL_TOKUSEI$)
				)
			)
		)
	)

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE　333　☆☆☆☆☆")

;-- 2012/01/18 A.Satoh Add CG対応 - S
	(if (= #err_flag nil)
		(progn
			; CG床色選択情報を取得する
			(setq #CG_YUKAIRO$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from CG床色選択")))
			(if (= #CG_YUKAIRO$$ nil)
				(progn
					(CFAlertMsg "【CG床色選択】にﾚｺｰﾄﾞがありません。")
					(setq #info$ nil)
					(setq #err_flag T)
				)
				(progn
					; 商品名プルダウン用リストを作成する
					(setq #GBL_CGYukairoGoods$ (list (list "" "")))
					(foreach #CG_YUKAIRO$ #CG_YUKAIRO$$
						(if (= (member (list (nth 1 #CG_YUKAIRO$) (nth 2 #CG_YUKAIRO$)) #GBL_CGYukairoGoods$) nil)
							(setq #GBL_CGYukairoGoods$ (append #GBL_CGYukairoGoods$ (list (list (nth 1 #CG_YUKAIRO$) (nth 2 #CG_YUKAIRO$)))))
						)
					)
				)
			)
		)
	)

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE　444　☆☆☆☆☆")

;-- 2012/01/18 A.Satoh Add CG対応 - E

	(if (= #err_flag nil)
		(progn
			; 天板情報を取得
			(setq #wt_ss (ssget "X" '((-3 ("G_WRKT")))))
			(if (= #wt_ss nil)
				(progn
					(setq #wt_en nil)
					(setq #xd_WRKT$ nil)
					(setq #type_f nil)
					(setq #Init$ nil)
					; 2017/06/15 KY ADD-S
					; フレームキッチン対応
					(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
						(progn
							(setq #type_f T)
							(setq #Init$ (##GetInitData_FK$))
						);progn
					);if
					; 2017/06/15 KY ADD-E
				)
				(progn
					(setq #wt_en (ssname #wt_ss 0))
					(setq #xd_WRKT$ (CFGetXData (ssname #wt_ss 0) "G_WRKT"))
					(setq #type_f T)

					; PB逆引により、初期値取得
					(setq #Init$ (##GetInitData #xd_WRKT$))
				)
			)

      ; DCLロード
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kscmain.dcl")))
      (if (not (new_dialog "KPCAD_OutputPresenDlg" #dcl_id)) (exit))

      ; 初期値設定
			(##ResetInitInfo #type_f #Init$)

      (setq #next 99)
      (while (and (/= 1 #next) (/= 0 #next))
        ; ボタン押下処理
        (action_tile "drseri" "(##SelDoorSeries)")
        (action_tile "drcol"  "(##SelDoorHandle)")
;-- 2012/01/18 A.Satoh Add CG対応 - S
        (action_tile "cg_y"   "(##SetInitCG_List)") ; CGありボタン押下時の処理（床商品名、床色柄リストの活性化）
        (action_tile "cg_n"   "(##SetInitCG_List)") ; CGなしボタン押下時の処理（床商品名、床色柄リストの非活性化）
        (action_tile "goods"  "(##SelCG_Goods)")    ; 商品名リスト選択時の処理（色柄リストの設定）
;-- 2012/01/18 A.Satoh Add CG対応 - E
;-- 2012/03/05 A.Satoh Add CG背景色白対応 - S
        (action_tile "all_white" "(##SetAllWhite)") ; 背景色白チェックの選択処理
;-- 2012/03/05 A.Satoh Add CG背景色白対応 - E
        (action_tile "accept" "(setq #info$ (##SetPresenInfo_CallBack))")
        (action_tile "cancel" "(setq #info$ nil)(done_dialog 0)")

        (setq #next (start_dialog))
      )

      (unload_dialog #dcl_id)
    )
  );_if

;;;(princ "\n☆☆☆☆☆　2016/09/07 CHECK WRITE　555　☆☆☆☆☆")


  #info$

) ;OutputPresenDlg
;-- 2011/10/27 A.Satoh Add - E


;-- 2012/02/07 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <関数名>    : C:AutoDrawWall
;;; <処理概要>  : 壁自動生成コマンド
;;; <戻り値>    :
;;; <作成>      : 2012/02/07 A.Satoh
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:AutoDrawWall (
  /
	#cmdecho #osmode #pickstyle #elevation #luprec #err_flag #size$
	#loop #wt_en #xd_WRKT$ #ret #ss_wt #wt_num 
  )

	;****************************************************
	; エラー処理
	;****************************************************
  (defun AutoDrawWallUndoErr( &msg )
    (command "_undo" "b")
    (CFCmdDefFinish)
    (setq *error* nil)
    (princ)
  )
	;****************************************************

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:AutoDrawWall ////")
  (CFOutStateLog 1 1 " ")

  ;;;基準高さを記憶 PcSetKUTAI内で変更される為
  ;;;RTOSはシステム変数LUPRECによって小数桁を制限できる。
  (setq #elevation (getvar "ELEVATION")) ; 内部処理で変更される為、基準高さを記憶する
  (setq #luprec (getvar "LUPREC"))
  (setvar "LUPREC" 2)

  (setq *error* AutoDrawWallUndoErr)
  (setq #elevation (getvar "ELEVATION")) ; 内部処理で変更される為、基準高さを記憶する
	(setq #cmdecho (getvar "CMDECHO"))
	(setq #osmode (getvar "OSMODE"))
	(setq #pickstyle (getvar "PICKSTYLE"))
  (setq #luprec (getvar "LUPREC"))
	(setvar "CMDECHO" 0)
	(setvar "OSMODE" 0)
  (setvar "PICKSTYLE" 0)
  (setvar "LUPREC" 2)
  (command "_undo" "M")
  (command "_undo" "a" "off")
	(CFCmdDefBegin 6)
	(setq #err_flag nil)

	; 天板の存在チェック
	(setq #ss_wt (ssget "X" '((-3 ("G_WRKT")))))
	(setq #wt_num (sslength #ss_wt))
	(cond
		((= #wt_num 0)	; 天板が存在しない
			(CFAlertMsg "壁を自動配置できません。")
			(setq #err_flag T)
		)
		((= #wt_num 1)	; 天板が１つしかない
			(setq #wt_en (ssname #ss_wt 0))
		)
		(T
			; 天板指定処理
			(setq #loop T)
			(while #loop
				(setq #wt_en (car (entsel "\n壁作図対象の天板図形を選択: ")))
				(if #wt_en
					(progn
						(setq #xd_WRKT$ (CFGetXData #wt_en "G_WRKT"))
						(if (= #xd_WRKT$ nil)
							(CFAlertMsg "天板図形ではありません。")
							(setq #loop nil)
						)
					)
				)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
			; 壁自動生成サイズ指定ダイアログ処理
			; 戻り値
			; 　ＯＫ押下⇒(壁パターン番号 壁Ｘの幅 壁Ｘと天板の隙間 壁Ｙの幅 壁Ｙと天板の隙間 壁Ｚの幅 壁Ｚと天板の隙間 壁の厚み 壁の高さ)
			; 　キャンセル押下⇒nil
			;
			;     壁パターン番号
			;       1:Ｉ型,Ｌ型右勝手用
			;       2:Ｉ型,Ｌ型左勝手用
			;       3:Ｐ型右勝手用
			;       4:Ｐ型左勝手用
			;       5:Ｉ型三方壁
			(setq #size$ (AutoDrawWall_SetWallSizeDlg))
			(if (= #size$ nil)
				(setq #err_flag T)
			)
		)
	)

	(if (= #err_flag nil)
		; 壁自動生成処理
		(AutoDrawWall_MakeWall #wt_en #size$)
	)

	; 終了処理
	(CFCmdDefFinish)
	(setvar "CMDECHO" #cmdecho)
	(setvar "OSMODE" #osmode)
	(setvar "PICKSTYLE" #pickstyle)
	(setvar "ELEVATION" #elevation)
	(setvar "LUPREC" #luprec)
	(setq *error* nil)

  (princ)

) ;C:AutoDrawWall


;;;<HOM>*************************************************************************
;;; <関数名>    : AutoDrawWall_SetWallSizeDlg
;;; <処理概要>  : 壁自動生成サイズ指定ダイアログ処理
;;; <戻り値>    : (壁パターン番号 壁Ｘの幅 壁Ｘと天板の隙間 壁Ｙの幅 壁Ｙと天板の隙間 壁Ｚの幅 壁Ｚと天板の隙間 壁の厚み 壁の高さ) or nil
;;;　　　　　　　　　壁パターン番号
;;;　　　　　　　　　　1:Ｉ型,Ｌ型右勝手用
;;;　　　　　　　　　　2:Ｉ型,Ｌ型左勝手用
;;;　　　　　　　　　　3:Ｐ型右勝手用
;;;　　　　　　　　　　4:Ｐ型左勝手用
;;;						         5:Ｉ型三方壁
;;; <作成>      : 2012/02/07 A.Satoh
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun AutoDrawWall_SetWallSizeDlg (
  /
	#size$ #dcl_id #x #y #next
	#CG_radio1_old #CG_radio2_old #CG_radio3_old #CG_radio4_old #CG_radio5_old
  )

	;***********************************************************************
	; 壁パターンラジオボタン選択処理
	; 戻り値:なし
	;***********************************************************************
	(defun ##SetWallSizeDlg_SelectRadio (
		&type		; 選択パターンコード
						; 1:Ｉ型,Ｌ型右勝手用
						; 2:Ｉ型,Ｌ型左勝手用
						; 3:Ｐ型右勝手用
						; 4:Ｐ型左勝手用
						; 5:Ｉ型三方壁
		/
		#radioILR #radioILL #radioPR #radioPL #radioI3
		)

		; 壁パターンの設定値を取得
		(setq #radioILR (get_tile "radioILR"))	; Ｉ型,Ｌ型右勝手用
		(setq #radioILL (get_tile "radioILL"))	; Ｉ型,Ｌ型左勝手用
		(setq #radioPR  (get_tile "radioPR"))		; Ｐ型右勝手用
		(setq #radioPL  (get_tile "radioPL"))		; Ｐ型左勝手用
		(setq #radioI3  (get_tile "radioI3"))		; Ｉ型三方壁

		(cond
			((= &type 1)	; Ｉ型,Ｌ型右勝手用
				(if (/= #radioILR #CG_radio1_old)
					(progn
						(set_tile "radioILR" "1")
						(set_tile "radioILL" "0")
						(set_tile "radioPR" "0")
						(set_tile "radioPL" "0")
						(set_tile "radioI3" "0")

						(setq #CG_radio1_old (get_tile "radioILR"))
						(setq #CG_radio2_old (get_tile "radioILL"))
						(setq #CG_radio3_old (get_tile "radioPR"))
						(setq #CG_radio4_old (get_tile "radioPL"))
						(setq #CG_radio5_old (get_tile "radioI3"))

						(set_tile "edtWidth_X" "")
						(mode_tile "edtWidth_X" 0)
						(set_tile "edtWidthX_off" "0")
						(mode_tile "edtWidthX_off" 0)
						(set_tile "edtWidth_Y" "")
						(mode_tile "edtWidth_Y" 0)
						(set_tile "edtWidthY_off" "0")
						(mode_tile "edtWidthY_off" 0)
						(set_tile  "edtWidth_Z" "")
						(mode_tile "edtWidth_Z" 1)
						(set_tile  "edtWidthZ_off" "")
						(mode_tile "edtWidthZ_off" 1)
					)
				)
			)
			((= &type 2)	; Ｉ型,Ｌ型左勝手用
				(if (/= #radioILL #CG_radio2_old)
					(progn
						(set_tile "radioILR" "0")
						(set_tile "radioILL" "1")
						(set_tile "radioPR" "0")
						(set_tile "radioPL" "0")
						(set_tile "radioI3" "0")

						(setq #CG_radio1_old (get_tile "radioILR"))
						(setq #CG_radio2_old (get_tile "radioILL"))
						(setq #CG_radio3_old (get_tile "radioPR"))
						(setq #CG_radio4_old (get_tile "radioPL"))
						(setq #CG_radio5_old (get_tile "radioI3"))

						(set_tile "edtWidth_X" "")
						(mode_tile "edtWidth_X" 0)
						(set_tile "edtWidthX_off" "0")
						(mode_tile "edtWidthX_off" 0)
						(set_tile "edtWidth_Y" "")
						(mode_tile "edtWidth_Y" 0)
						(set_tile "edtWidthY_off" "0")
						(mode_tile "edtWidthY_off" 0)
						(set_tile  "edtWidth_Z" "")
						(mode_tile "edtWidth_Z" 1)
						(set_tile  "edtWidthZ_off" "")
						(mode_tile "edtWidthZ_off" 1)
					)
				)
			)
			((= &type 3)	; Ｐ型右勝手用
				(if (/= #radioPR #CG_radio3_old)
					(progn
						(set_tile "radioILR" "0")
						(set_tile "radioILL" "0")
						(set_tile "radioPR" "1")
						(set_tile "radioPL" "0")
						(set_tile "radioI3" "0")

						(setq #CG_radio1_old (get_tile "radioILR"))
						(setq #CG_radio2_old (get_tile "radioILL"))
						(setq #CG_radio3_old (get_tile "radioPR"))
						(setq #CG_radio4_old (get_tile "radioPL"))
						(setq #CG_radio5_old (get_tile "radioI3"))

						(set_tile "edtWidth_X" "")
						(mode_tile "edtWidth_X" 1)
						(set_tile "edtWidthX_off" "")
						(mode_tile "edtWidthX_off" 1)
						(set_tile "edtWidth_Y" "")
						(mode_tile "edtWidth_Y" 0)
						(set_tile "edtWidthY_off" "0")
						(mode_tile "edtWidthY_off" 0)
						(set_tile  "edtWidth_Z" "")
						(mode_tile "edtWidth_Z" 1)
						(set_tile  "edtWidthZ_off" "")
						(mode_tile "edtWidthZ_off" 1)
					)
				)
			)
			((= &type 4)	; Ｐ型左勝手用
				(if (/= #radioPL #CG_radio4_old)
					(progn
						(set_tile "radioILR" "0")
						(set_tile "radioILL" "0")
						(set_tile "radioPR" "0")
						(set_tile "radioPL" "1")
						(set_tile "radioI3" "0")

						(setq #CG_radio1_old (get_tile "radioILR"))
						(setq #CG_radio2_old (get_tile "radioILL"))
						(setq #CG_radio3_old (get_tile "radioPR"))
						(setq #CG_radio4_old (get_tile "radioPL"))
						(setq #CG_radio5_old (get_tile "radioI3"))

						(set_tile "edtWidth_X" "")
						(mode_tile "edtWidth_X" 1)
						(set_tile "edtWidthX_off" "")
						(mode_tile "edtWidthX_off" 1)
						(set_tile "edtWidth_Y" "")
						(mode_tile "edtWidth_Y" 0)
						(set_tile "edtWidthY_off" "0")
						(mode_tile "edtWidthY_off" 0)
						(set_tile  "edtWidth_Z" "")
						(mode_tile "edtWidth_Z" 1)
						(set_tile  "edtWidthZ_off" "")
						(mode_tile "edtWidthZ_off" 1)
					)
				)
			)
			((= &type 5)	; Ｉ型三方壁
				(if (/= #radioI3 #CG_radio5_old)
					(progn
						(set_tile "radioILR" "0")
						(set_tile "radioILL" "0")
						(set_tile "radioPR" "0")
						(set_tile "radioPL" "0")
						(set_tile "radioI3" "1")

						(setq #CG_radio1_old (get_tile "radioILR"))
						(setq #CG_radio2_old (get_tile "radioILL"))
						(setq #CG_radio3_old (get_tile "radioPR"))
						(setq #CG_radio4_old (get_tile "radioPL"))
						(setq #CG_radio5_old (get_tile "radioI3"))

						(set_tile "edtWidth_X" "")
						(mode_tile "edtWidth_X" 0)
						(set_tile "edtWidthX_off" "0")
						(mode_tile "edtWidthX_off" 0)
						(set_tile "edtWidth_Y" "")
						(mode_tile "edtWidth_Y" 0)
						(set_tile "edtWidthY_off" "0")
						(mode_tile "edtWidthY_off" 0)
						(set_tile  "edtWidth_Z" "")
						(mode_tile "edtWidth_Z" 0)
						(set_tile  "edtWidthZ_off" "0")
						(mode_tile "edtWidthZ_off" 0)
					)
				)
			)
		)

	) ; ##SetWallSizeDlg_SelectRadio
	;***********************************************************************

	;***********************************************************************
	; ＯＫボタン押下処理
	; 戻り値:壁自動生成情報リスト
	;        (壁パターン番号 壁Ｘの幅 壁Ｘと天板の隙間 壁Ｙの幅 壁Ｙと天板の隙間 壁Ｚの幅 壁Ｚと天板の隙間 壁の厚み 壁の高さ)
	;***********************************************************************
	(defun ##SetWallSizeDlg_CallBack (
		/
		#err_flag #ret$ #radioILR #radioILL #radioPR #radioPL #radioI3
		#widthX #widthX_off #widthY #widthY_off #widthZ #widthZ_off 
		#depth #height #ptnno
		)

    (setq #err_flag nil)
		(setq #ret$ nil)

		; 壁パターンの設定値を取得
		(setq #radioILR (get_tile "radioILR"))		; Ｉ型,Ｌ型右勝手用
		(setq #radioILL (get_tile "radioILL"))		; Ｉ型,Ｌ型左勝手用
		(setq #radioPR  (get_tile "radioPR"))			; Ｐ型右勝手用
		(setq #radioPL  (get_tile "radioPL"))			; Ｐ型左勝手用
		(setq #radioI3  (get_tile "radioI3"))			; Ｉ型三方壁

		; 壁サイズの入力値を取得
		(setq #widthX     (get_tile "edtWidth_X"))		; 壁Ｘの幅
		(setq #widthX_off (get_tile "edtWidthX_off"))	; 壁Ｘと天板の隙間
		(setq #widthY     (get_tile "edtWidth_Y"))		; 壁Ｙの幅
		(setq #widthY_off (get_tile "edtWidthY_off"))	; 壁Ｙと天板の隙間
		(setq #widthZ     (get_tile "edtWidth_Z"))		; 壁Ｚの幅
		(setq #widthZ_off (get_tile "edtWidthZ_off"))	; 壁Ｚと天板の隙間
		(setq #depth      (get_tile "edtDepth"))			; 壁の厚み
		(setq #height     (get_tile "edtHeight"))			; 壁の高さ

		; 壁パターン入力チェック
		(if (and (= #radioILR "0") (= #radioILL "0") (= #radioPR "0") (= #radioPL "0") (= #radioI3 "0"))
			(progn
				(set_tile "error" "壁パターンが入力されていません")
				(setq #err_flag T)
			)
		)

		(if (= #err_flag nil)
			(if (or (= #radioILR "1") (= #radioILL "1") (= #radioI3 "1"))
				; [壁Ｘの幅]の入力チェック
				(if (or (= #widthX "") (= #widthX nil))
					(progn
						(set_tile "error" "[壁幅Ｘ]が入力されていません")
						(mode_tile "edtWidth_X" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #widthX)) 'INT) (= (type (read #widthX)) 'REAL))
						(if (>= 0 (read #widthX))
							(progn
								(set_tile "error" "[壁幅Ｘ]には1以上の数値を入力して下さい")
								(mode_tile "edtWidth_X" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[壁幅Ｘ]には数値を入力して下さい")
							(mode_tile "edtWidth_X" 2)
							(setq #err_flag T)
						)
					)
				)
			)
			(progn
				; [壁Ｘの幅]は未入力の為、０を設定する
				(setq #widthX "0")
			)
		)

		(if (= #err_flag nil)
			(if (or (= #radioILR "1") (= #radioILL "1") (= #radioI3 "1"))
				; [壁Ｘと天板の隙間]の入力チェック
				(if (or (= #widthX_off "") (= #widthX_off nil))
					(progn
						(set_tile "error" "[壁Ｘと天板の隙間]が入力されていません")
						(mode_tile "edtWidthX_off" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #widthX_off)) 'INT) (= (type (read #widthX_off)) 'REAL))
						(if (> 0 (read #widthX_off))
							(progn
								(set_tile "error" "[壁Ｘと天板の隙間]には0以上の数値を入力して下さい")
								(mode_tile "edtWidthX_off" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[壁Ｘと天板の隙間]には数値を入力して下さい")
							(mode_tile "edtWidthX_off" 2)
							(setq #err_flag T)
						)
					)
				)
			)
			(progn
				; [壁Ｘと天板の隙間]は未入力の為、０を設定する
				(setq #widthX_off "0")
			)
		)

		(if (= #err_flag nil)
			; [壁Ｙの幅]の入力チェック
			(if (or (= #widthY "") (= #widthY nil))
				(progn
					(set_tile "error" "[壁幅Ｙ]が入力されていません")
					(mode_tile "edtWidth_Y" 2)
					(setq #err_flag T)
				)
				(if (or (= (type (read #widthY)) 'INT) (= (type (read #widthY)) 'REAL))
					(if (>= 0 (read #widthY))
						(progn
							(set_tile "error" "[壁幅Ｙ]には1以上の数値を入力して下さい")
							(mode_tile "edtWidth_Y" 2)
							(setq #err_flag T)
						)
					)
					(progn
						(set_tile "error" "[壁幅Ｙ]には数値を入力して下さい")
						(mode_tile "edtWidth_Y" 2)
						(setq #err_flag T)
					)
				)
			)
		)

		(if (= #err_flag nil)
			; [壁Ｙと天板の隙間]の入力チェック
			(if (= #err_flag nil)
				(if (or (= #widthY_off "") (= #widthY_off nil))
					(progn
						(set_tile "error" "[壁Ｙと天板の隙間]が入力されていません")
						(mode_tile "edtWidthY_off" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #widthY_off)) 'INT) (= (type (read #widthY_off)) 'REAL))
						(if (> 0 (read #widthY_off))
							(progn
								(set_tile "error" "[壁Ｙと天板の隙間]には0以上の数値を入力して下さい")
								(mode_tile "edtWidthY_off" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[壁Ｙと天板の隙間]には数値を入力して下さい")
							(mode_tile "edtWidthY_off" 2)
							(setq #err_flag T)
						)
					)
				)
			)
		)

		(if (= #err_flag nil)
			(if (= #radioI3 "1")
				; [壁Ｚの幅]の入力チェック
				(if (or (= #widthZ "") (= #widthZ nil))
					(progn
						(set_tile "error" "[壁Ｚの幅]が入力されていません")
						(mode_tile "edtWidth_Z" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #widthZ)) 'INT) (= (type (read #widthZ)) 'REAL))
						(if (>= 0 (read #widthZ))
							(progn
								(set_tile "error" "[壁Ｚの幅]には1以上の数値を入力して下さい")
								(mode_tile "edtWidth_Z" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[壁Ｚの幅]には数値を入力して下さい")
							(mode_tile "edtWidth_Z" 2)
							(setq #err_flag T)
						)
					)
				)
			)
			(progn
				; [壁Ｚの幅]は未入力の為、０を設定する
				(setq #widthZ "0")
			)
		)

		(if (= #err_flag nil)
			(if (= #radioI3 "1")
				; [壁Ｚと天板の隙間]の入力チェック
				(if (or (= #widthZ_off "") (= #widthZ_off nil))
					(progn
						(set_tile "error" "[壁Ｚと天板の隙間]が入力されていません")
						(mode_tile "edtWidthZ_off" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #widthZ_off)) 'INT) (= (type (read #widthZ_off)) 'REAL))
						(if (> 0 (read #widthZ_off))
							(progn
								(set_tile "error" "[壁Ｚと天板の隙間]には0以上の数値を入力して下さい")
								(mode_tile "edtWidthZ_off" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[壁Ｚと天板の隙間]には数値を入力して下さい")
							(mode_tile "edtWidthZ_off" 2)
							(setq #err_flag T)
						)
					)
				)
			)
			(progn
				; [壁Ｚと天板の隙間]は未入力の為、０を設定する
				(setq #widthZ_off "0")
			)
		)

		(if (= #err_flag nil)
			; [壁の厚み]の入力チェック
			(if (or (= #depth "") (= #depth nil))
				(progn
					(set_tile "error" "[壁の厚み]が入力されていません")
					(mode_tile "edtDepth" 2)
					(setq #err_flag T)
				)
				(if (or (= (type (read #depth)) 'INT) (= (type (read #depth)) 'REAL))
					(if (>= 0 (read #depth))
						(progn
							(set_tile "error" "[壁の厚み]には1以上の数値を入力して下さい")
							(mode_tile "edtDepth" 2)
							(setq #err_flag T)
						)
					)
					(progn
						(set_tile "error" "[壁の厚み]には数値を入力して下さい")
						(mode_tile "edtDepth" 2)
						(setq #err_flag T)
					)
				)
			)
		)

		(if (= #err_flag nil)
			; [壁の高さ]の入力チェック
			(if (or (= #height "") (= #height nil))
				(progn
					(set_tile "error" "[壁の高さ]が入力されていません")
					(mode_tile "edtHeight" 2)
					(setq #err_flag T)
				)
				(if (or (= (type (read #height)) 'INT) (= (type (read #height)) 'REAL))
					(if (>= 0 (read #height))
						(progn
							(set_tile "error" "[壁の高さ]には1以上の数値を入力して下さい")
							(mode_tile "edtHeight" 2)
							(setq #err_flag T)
						)
					)
					(progn
						(set_tile "error" "[壁の高さ]には数値を入力して下さい")
						(mode_tile "edtHeight" 2)
						(setq #err_flag T)
					)
				)
			)
		)

		; 壁サイズ情報リストの作成
		(if (= #err_flag nil)
			(progn
				; 壁パターン番号の設定
				(cond
					((= #radioILR "1")
						(setq #ptnno 1)
					)
					((= #radioILL "1")
						(setq #ptnno 2)
					)
					((= #radioPR "1")
						(setq #ptnno 3)
					)
					((= #radioPL "1")
						(setq #ptnno 4)
					)
					((= #radioI3 "1")
						(setq #ptnno 5)
					)
				)
				; 情報リスト作成
				(setq #ret$ (list #ptnno (atof #widthX) (atof #widthX_off) (atof #widthY) (atof #widthY_off) (atof #widthZ) (atof #widthZ_off) (atof #depth) (atof #height)))
				(done_dialog)
				#ret$
			)
		)

	) ; ##SetWallSizeDlg_CallBack
	;***********************************************************************

	(setq #size$ nil)

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kscmain.dcl")))
  (if (not (new_dialog "SetWallSizeDlg" #dcl_id)) (exit))

	; ダイアログ初期設定
	(setq #CG_radio1_old  "0")												; Ｉ型,Ｌ型右勝手用ラジオボタン
	(setq #CG_radio2_old  "0")												; Ｉ型,Ｌ型左勝手用ラジオボタン
	(setq #CG_radio3_old  "0")												; Ｐ型右勝手用ラジオボタン
	(setq #CG_radio4_old  "0")												; Ｐ型左勝手用ラジオボタン
	(setq #CG_radio5_old  "0")												; Ｉ型三方壁ラジオボタン
	(set_tile "edtWidth_X"    "")											; 壁Ｘの幅
	(mode_tile "edtWidth_X" 1)
	(set_tile "edtWidthX_off" "")											; 壁Ｘと天板の隙間
	(mode_tile "edtWidthX_off" 1)
	(set_tile "edtWidth_Y"    "")											; 壁Ｙの幅
	(mode_tile "edtWidth_Y" 1)
	(set_tile "edtWidthY_off" "")											; 壁Ｙと天板の隙間
	(mode_tile "edtWidthY_off" 1)
	(set_tile "edtWidth_Z"    "")											; 壁Ｚの幅
	(mode_tile "edtWidth_Z" 1)
	(set_tile "edtWidthZ_off" "")											; 壁Ｚと天板の隙間
	(mode_tile "edtWidthZ_off" 1)
	(set_tile "edtDepth"      "150")									; 壁の厚み
	(set_tile "edtHeight"     (itoa CG_CeilHeight))		; 壁の高さ

	; スライド設定
	;;; Ｉ型,Ｌ型右勝手用
	(setq #x (dimx_tile "slide1")
				#y (dimy_tile "slide1")
	)
	(start_image "slide1")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\Wall1"))
	(end_image)

	;;; Ｉ型,Ｌ型左勝手用
	(setq #x (dimx_tile "slide2")
				#y (dimy_tile "slide2")
	)
	(start_image "slide2")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\Wall2"))
	(end_image)

	;;; Ｐ型右勝手用
	(setq #x (dimx_tile "slide3")
				#y (dimy_tile "slide3")
	)
	(start_image "slide3")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\Wall3"))
	(end_image)

	;;; Ｐ型左勝手用
	(setq #x (dimx_tile "slide4")
				#y (dimy_tile "slide4")
	)
	(start_image "slide4")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\Wall4"))
	(end_image)

	;;; Ｉ型三方壁
	(setq #x (dimx_tile "slide5")
				#y (dimy_tile "slide5")
	)
	(start_image "slide5")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\Wall5"))
	(end_image)

	(setq #next 99)
	(while (and (/= #next 1) (/= #next 0))
	  (action_tile "radioILR"   "(##SetWallSizeDlg_SelectRadio 1)")
	  (action_tile "radioILL"   "(##SetWallSizeDlg_SelectRadio 2)")
	  (action_tile "radioPR"    "(##SetWallSizeDlg_SelectRadio 3)")
	  (action_tile "radioPL"    "(##SetWallSizeDlg_SelectRadio 4)")
	  (action_tile "radioI3"    "(##SetWallSizeDlg_SelectRadio 5)")
	  (action_tile "accept"     "(setq #size$ (##SetWallSizeDlg_CallBack))")
  	(action_tile "cancel"     "(setq #size$ nil) (done_dialog)")

	  (setq #next (start_dialog))
	)
  (unload_dialog #dcl_id)

	#size$

) ;AutoDrawWall_SetWallSizeDlg


;;;<HOM>*************************************************************************
;;; <関数名>    : AutoDrawWall_MakeWall
;;; <処理概要>  : 壁自動生成処理
;;; <戻り値>    : なし
;;; <作成>      : 2012/02/07 A.Satoh
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun AutoDrawWall_MakeWall (
	&wt_en			; 天板図形名
	&size$			; 壁自動生成サイズ情報：壁自動生成サイズ指定画面からの入力情報
							;  (壁パターン番号 壁Ｘの幅 壁Ｘと天板の隙間 壁Ｙの幅 壁Ｙと天板の隙間 壁Ｚの幅 壁Ｚと天板の隙間 壁の厚み 壁の高さ)
							;　　壁パターン番号
							;　　　1:Ｉ型,Ｌ型右勝手用
							;　　　2:Ｉ型,Ｌ型左勝手用
							;　　　3:Ｐ型右勝手用
							;　　　4:Ｐ型左勝手用
							;      5:Ｉ型三方壁
  /
	#xd_WRKT$ #keijo #oku #tei #wt_BaseP #pt$ #lr_flg
	#p1 #p2 #p3 #p4 #p5 #p6 #wt_type #ang1 #ang2 #ang3
	#Name$ #idx #idx2 #BaseP #off_x #off_y #offset
	#Name #ang #sql #qry$ #msg #Type #fname #wk_p #dist #rad
	#xd_SYM$ #Wxd #Dxd #Hxd #Bxd #Wset #Dset #Hset #Bset
	#ss #angle #To_p #eNEW #dIns #strFLG #eget #orgLYR$ #emod
  )

	; 天板図形のベース基準点を取り出す
	(setq #xd_WRKT$ (CFGetXData &wt_en "G_WRKT"))
	(setq #keijo    (nth  3 #xd_WRKT$))  ; 形状
	(setq #lr_flg   (nth 30 #xd_WRKT$))  ; 左右勝手フラグ
	(setq #wt_BaseP (nth 32 #xd_WRKT$))  ; WT左上点
	(setq #tei      (nth 38 #xd_WRKT$))  ; WT底面図形ﾊﾝﾄﾞﾙ
	(setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
	(setq #oku      (car (nth 57 #xd_WRKT$)))  ; 奥行

	; 外形点列&pt$を#BASEPを先頭に時計周りにする
	(setq #pt$ (GetPtSeries #wt_BaseP #pt$))

	(if (= #keijo 1)
		(progn		; Ｌ型天板である場合
			(setq #p1 (nth 0 #pt$))
			(setq #p2 (nth 1 #pt$))
			(setq #p3 (nth 2 #pt$))
			(setq #p4 (nth 3 #pt$))
			(setq #p5 (nth 4 #pt$))
			(setq #p6 (nth 5 #pt$))
		)
		(progn		; Ｉ型またはＰ型である場合
			(setq #p1 (nth 0 #pt$))
			(setq #p2 (nth 1 #pt$))
			(setq #p3 (nth 2 #pt$))
			(setq #p4 (nth 3 #pt$))
		)
	)

	; 躯体図形情報を取得
	(setq #wt_type (car &size$))	; 壁パターン番号を抜き出す
	(cond
		((= #wt_type 1)		; Ｉ型,Ｌ型右勝手用
			; 配置角度を求める
			(if (= #keijo 1)
				; Ｌ型である
				(if (= #lr_flg "R")
					(progn		; 右勝手である
						(setq #ang1 (atof (angtos (angle #p1 #p6))))
						(setq #ang2 (atof (angtos (angle #p1 #p2))))
					)
					(progn		; 左勝手または不明である
						(setq #ang1 (atof (angtos (angle #p1 #p6))))
						(setq #ang2 (atof (angtos (angle #p1 #p2))))
					)
				)
				; Ｉ型である
				(progn
					(setq #ang1 (atof (angtos (angle #p1 #p4))))
					(setq #ang2 (atof (angtos (angle #p1 #p2))))
				)
			)

			(setq #Name$ (list (list "間仕切Ｉ型LD" #ang1) (list "間仕切Ｉ型RU" #ang2) nil))
		)
		((= #wt_type 2)		; Ｉ型,Ｌ型左勝手用
			; 配置角度を求める
			(if (= #keijo 1)
				; Ｌ型である
				(if (= #lr_flg "L")
					(progn	; 左勝手である
						(setq #ang1 (atof (angtos (angle #p1 #p2))))
						(setq #ang2 (atof (angtos (angle #p1 #p6))))
					)
					(progn	; 右勝手または不明である
						(setq #ang1 (atof (angtos (angle #p1 #p2))))
						(setq #ang2 (atof (angtos (angle #p1 #p6))))
					)
				)
				; Ｉ型である
				(progn
					(setq #ang1 (atof (angtos (angle #p2 #p3))))
					(setq #ang2 (atof (angtos (angle #p2 #p1))))
				)
			)

			(setq #Name$ (list (list "間仕切Ｉ型RU" #ang1) (list "間仕切Ｉ型LD" #ang2) nil))
		)
		((= #wt_type 3)		; Ｐ型右勝手用
			; 配置角度を求める
			(setq #ang1 (atof (angtos (angle #p1 #p4))))

			(setq #Name$ (list (list "間仕切Ｉ型LD" #ang1) nil nil))
		)
		((= #wt_type 4)		; Ｐ型左勝手用
			; 配置角度を求める
			(setq #ang1 (atof (angtos (angle #p2 #p3))))

			(setq #Name$ (list (list "間仕切Ｉ型RU" #ang1) nil nil))
		)
		((= #wt_type 5)		; Ｉ型三方壁
			; 配置角度を求める
			(setq #ang1 (atof (angtos (angle #p1 #p4))))
			(setq #ang2 (atof (angtos (angle #p1 #p2))))
			(setq #ang3 (atof (angtos (angle #p2 #p3))))

			(setq #Name$ (list (list "間仕切Ｉ型LD" #ang1) (list "間仕切Ｉ型RU" #ang2) (list "間仕切Ｉ型RU" #ang3)))
		)
	)

	(setq #idx 0)
	(repeat (length #Name$)
		(if (/= (nth #idx #Name$) nil)
			(progn
				(cond
					((= #wt_type 1)		; Ｉ型,Ｌ型右勝手用
						(if (= #idx 0)
							(progn
								; 配置基点を求める
								(setq #BaseP #wt_BaseP)

								; 壁図形の移動量
								(setq #off_x (nth 4 &size$))
								(setq #off_y (nth 2 &size$))
							)
							(progn
								; 配置基点を求める
								(setq #BaseP #wt_BaseP)

								; 壁図形の移動量
								(setq #off_x (+ (nth 4 &size$) (nth 7 &size$)))
								(setq #off_y (nth 2 &size$))
							)
						)
					)
					((= #wt_type 2)		; Ｉ型,Ｌ型左勝手用
						(if (= #idx 0)
							(progn
								; 配置基点を求める
								(if (= #keijo 1)
									(setq #BaseP #wt_BaseP)
									(setq #BaseP #p2)
								)

								; 壁図形の移動量
								(setq #off_x (nth 4 &size$))
								(setq #off_y (nth 2 &size$))
							)
							(progn
								; 配置基点を求める
								(if (= #keijo 1)
									(setq #BaseP #wt_BaseP)
									(setq #BaseP #p2)
								)

								; 壁図形の移動量
								(setq #off_x (+ (nth 4 &size$) (nth 7 &size$)))
								(setq #off_y (nth 2 &size$))
							)
						)
					)
					((= #wt_type 3)		; Ｐ型右勝手用
						; 配置基点を求める
						(setq #BaseP #wt_BaseP)

						; 壁図形の移動量
						(setq #off_x (nth 4 &size$))
						(setq #off_y 0)
						(setq #offset (/ (- (nth 3 &size$) #oku) 2))
					)
					((= #wt_type 4)		; Ｐ型左勝手用
						; 配置基点を求める
						(setq #BaseP #p2)

						; 壁図形の移動量
						(setq #off_x (nth 4 &size$))
						(setq #off_y 0)
						(setq #offset (/ (- (nth 3 &size$) #oku) 2))
					)
					((= #wt_type 5)
						(cond
							((= #idx 0)
								; 配置基点を更新する
								(setq #BaseP #wt_BaseP)

								; 壁図形の移動量
								(setq #off_x (nth 4 &size$))
								(setq #off_y (nth 2 &size$))
							)
							((= #idx 1)
								(setq #BaseP #wt_BaseP)

								; 壁図形の移動量
								(setq #off_x (+ (nth 4 &size$) (nth 7 &size$)))
								(setq #off_y (nth 2 &size$))
							)
							((= #idx 2)
								; 配置基点を更新する
								(setq #BaseP #p2)

								; 壁図形の移動量
								(setq #off_x (nth 6 &size$))
								(setq #off_y (nth 2 &size$))
							)
						)
					)
				)

				(setq #Name (nth 0 (nth #idx #Name$)))
				(setq #ang  (nth 1 (nth #idx #Name$)))

				; 躯体図形情報を取得
				(setq #sql (strcat "select * from 躯体図形 where 躯体名称='" #Name "'"))
				(setq #qry$ (car (DBSqlAutoQuery CG_CDBSession #sql)))
				(if (= #qry$ nil)
					(progn
						(setq #msg "  AutoDrawWall_SetKUTAI:『躯体図形』が見つかりませんでした")
						(CFOutStateLog 0 1 #msg)
						(CFOutStateLog 0 1 (strcat "        " #sql))
						(CFAlertMsg #msg)
						(exit)
					)
				)

				; 躯体ﾀｲﾌﾟ
				(setq #Type  (fix (nth 2 #qry$)))

				; 図形ID取得
				(setq #fname (nth 15 #qry$))

			  ; 作図用の画層設置
				(MakeLayer "Z_00_00_00_01" 7 "CONTINUOUS")

				(Pc_CheckInsertDwg (strcat #fname ".dwg") CG_MSTDWGPATH)

				; 配置位置を調整する
				(cond
					((= #idx 0)
						(cond
							((= #wt_type 1)
								(setq #wk_p (list (* #off_x -1) #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 2)
								(setq #wk_p (list #off_x #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(if (= #keijo 1)
									(setq #rad (+ (angle #p6 #p1) (angle '(0 0) #wk_p)))
									(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								)
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 3)
								(setq #wk_p (list (* #off_x -1) #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 4)
								(setq #wk_p (list #off_x #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 5)
								(setq #wk_p (list (* #off_x -1) #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
						)
					)
					((= #idx 1)
						(cond
							((= #wt_type 1)
								(setq #wk_p (list (* #off_x -1) #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 2)
								(setq #wk_p (list #off_x #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(if (= #keijo 1)
									(setq #rad (+ (angle #p6 #p1) (angle '(0 0) #wk_p)))
									(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								)
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 5)
								(setq #wk_p (list (* #off_x -1) #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
						)
					)
					((= #idx 2)
						(if (= #wt_type 5)
							(progn
								(setq #wk_p (list #off_x #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
						)
					)
				)

				; 躯体図形の配置
				(command ".insert" (strcat CG_MSTDWGPATH #fname) #BaseP 1 1 #ang) 

				(command "_explode" (entlast))
				(setq #ss (ssget "P"))

				; Ｐ型右勝手又はＰ型左勝手である場合
				(if (or (= #wt_type 3) (= #wt_type 4))
					(progn
						; 躯体図形を移動する（壁を奥行に対して均等に配置）
						;;; 移動位置を求める
						(setq #angle (+ #ang 180))
						(if (>= #angle 360)
							(setq #angle (- #angle 360))
						)
						(setq #To_p (polar #BaseP (angtof (rtos #angle 2 2)) #offset))

						; 躯体図形を移動
						(command "_.MOVE" #ss "" #BaseP #To_p)
					)
				)

				(SKMkGroup #ss)
				(command "_layer" "u" "N_*" "")
				(setq #eNEW (SearchGroupSym (ssname #ss 0)))
				(setq #dIns (cdr (assoc 10 (entget #eNEW))))

				; XData G_SYM から必要情報取得
				(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM"))
				(setq #Wxd (nth 3 #xd_SYM$))
				(setq #Dxd (nth 4 #xd_SYM$))
				(setq #Hxd (nth 5 #xd_SYM$))
				(setq #Bxd (nth 6 #xd_SYM$))

				; 壁サイズの設定
				(cond
					((= #idx 0)
						(setq #Wset (nth 3 &size$))		; 壁幅Ｙを使用
					)
					((= #idx 1)
						(setq #Wset (nth 1 &size$))		; 壁幅Ｘを使用
					)
					((= #idx 2)
						(setq #Wset (nth 5 &size$))		; 壁幅Ｚを使用
					)
				)
				(setq #Dset (nth 7 &size$))
				(setq #Hset (nth 8 &size$))
				(setq #Bset #Bxd)

				(setvar "ELEVATION" #Bset)

				; XDATA設定
			  (if (= nil (tblsearch "APPID" "G_LSYM")) (regapp "G_LSYM"))

				(CFSetXData #eNew "G_LSYM"
					(list
						#fname                    ;  1:本体図形ID      :『品番図形』.図形ID
						#dIns                     ;  2:挿入点          :配置基点
						(angtof (rtos #ang 2 2))  ;  3:回転角度        :配置回転角度
						CG_KCode                  ;  4:工種記号        :CG_Kcode
						CG_SeriesCode             ;  5:SERIES記号    :CG_SeriesCode
						#Name                     ;  6:品番名称        :『品番図形』.品番名称
						"Z"                       ;  7:L/R区分         :『品番図形』.部材L/R区分
						""                        ;  8:扉図形ID        :
						""                        ;  9:扉開き図形ID    :
						999                       ; 10:性格CODE      :『品番基本』.性格CODE
						0                         ; 11:複合フラグ      :０固定（単独部材）
						0                         ; 12:配置順番号      :配置順番号(1～)
						0                         ; 13:用途番号        :『品番図形』.用途番号
						#Hxd                      ; 14:寸法Ｈ          :『品番図形』.寸法Ｈ
						0                         ; 15:断面指示の有無  :『プラ構成』.断面有無 00/07/18 SN MOD
					)
				)

				(if (= nil (tblsearch "APPID" "G_KUTAI")) (regapp "G_KUTAI"))

				; 躯体タイプを設定する
				(CFSetXData #eNew "G_KUTAI" (list #Type))

			  ; 伸縮関連処理
				(CFCmdDefStart 0)
				(setq #strFLG nil)

				; 変更のあった個所を順次伸縮していく
				(if (not (equal #Wxd #Wset 0.0001))
					(progn
						(setq #strFLG 'T)
						(SKY_Stretch_Parts #eNEW #Wset #Dxd #Hxd)
						; 縦伸縮にともなう位置移動 (Wフラグ= -1のアイテム)
						(if (= -1 (nth 8 #xd_SYM$))
							(PcMoveItem #eNEW #dIns)
						)
					)
				)

				(if (not (equal #Dxd #Dset 0.0001))
					(progn
						(setq #strFLG 'T)
						(SKY_Stretch_Parts #eNEW #Wset #Dset #Hxd)

						; 縦伸縮にともなう位置移動 (Dフラグ= -1のアイテム)
						(if (= -1 (nth 9 #xd_SYM$))
							(PcMoveItem #eNEW #dIns)
						)
					)
				)

				(if (not (equal #Hxd #Hset 0.0001))
					(progn
						(setq #strFLG 'T)
						(SKY_Stretch_Parts #eNEW #Wset #Dset #Hset)

						; 縦伸縮にともなう位置移動 (Hフラグ= -1のアイテム)
						(if (= -1 (nth 10 #xd_SYM$))
							(PcMoveItem #eNEW #dIns)
						)
					)
				)

				; 伸縮が無かった場合、グループ中の"G_PRIM"を持つ3DSOLID再構成
				(if (not #strFLG)
					(setq #eNEW (KcRemakePrimInGroup #eNEW))
				)

				(CFCmdDefEnd);ｽﾅｯﾌﾟ関連を戻す

				; XDATA設定 G_SYMは伸縮処理で内容変更される為、伸縮後再設定する。
				(CFSetXData #eNew "G_SYM"
					(list
						(nth  0 #xd_SYM$)		; シンボル名称
						(nth  1 #xd_SYM$)		; コメント１
						(nth  2 #xd_SYM$)		; コメント２
						(nth  3 #xd_SYM$)		; シンボル基準値Ｗ
						(nth  4 #xd_SYM$)		; シンボル基準値Ｄ
						(nth  5 #xd_SYM$)		; シンボル基準値Ｈ
						(nth  6 #xd_SYM$)		; シンボル取付け高さ
						(nth  7 #xd_SYM$)		; 入力方法
						(nth  8 #xd_SYM$)		; Ｗ方向フラグ
						(nth  9 #xd_SYM$)		; Ｄ方向フラグ
						(nth 10 #xd_SYM$)		; Ｈ方向フラグ
						; 伸縮フラグＷ
			      (if (equal #Wxd #Wset 0.0001)
							(nth 11 #xd_SYM$)
							#Wset
						)
						; 伸縮フラグＤ
						(if (equal #Dxd #Dset 0.0001)
							(nth 12 #xd_SYM$)
							#Dset
						)
						; 伸縮フラグＨ
						(if (equal #Hxd #Hset 0.0001)
							(nth 13 #xd_SYM$)
							#Hset
						)
						(nth 14 #xd_SYM$)		; ブレークライン数Ｗ
						(nth 15 #xd_SYM$)		; ブレークライン数Ｄ
						(nth 16 #xd_SYM$)		; ブレークライン数Ｈ
					)
				)

				; 躯体の画層をZ_00_00_00_01からZ_KUTAIに変更する(伸縮作業の後に行うこと)
				(MakeLayer "Z_KUTAI" 7 "CONTINUOUS")
				(setq #idx2 0)
				(setq #ss (CFGetSameGroupSS #eNEW))
				(repeat (sslength #ss)
					(setq #eget (entget (ssname #ss #idx2)(list "*")))
					(setq #orgLYR$ (assoc 8 #eget))

					; 画層Z_00_00_00_01上の図形, 目地図形 画層 M_* が対象
					(if (and #orgLYR$ (wcmatch (cdr #orgLYR$) "M_*,Z_00_00_00_01"))
						(progn
							(setq #emod (subst (cons 8 "Z_KUTAI") #orgLYR$  #eget))
							(setq #emod (subst (cons 62 256) (assoc 62 #emod) #emod))
							(entmod #emod)
						)
					)

					(setq #idx2 (1+ #idx2))
			  )
			)
		)

		(setq #idx (1+ #idx))
	)

) ; AutoDrawWall_MakeWall
;-- 2012/02/07 A.Satoh Add - E


;-- 2012/03/05 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <関数名>    : AutoDrawWall_SetWallSizeDlg
;;; <処理概要>  : CG用壁設定定ダイアログ処理
;;; <戻り値>    : (上オフセット値 下オフセット値 左オフセット値 右オフセット値) or nil
;;; <作成>      : 2012/03/05 A.Satoh
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun SetCGWallDlg (
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
	&allWhite   ; 背景色白フラグ  1:背景色白  0:背景色色以外
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
  /
	#offset$ #dcl_id #x #y #next
  )

	;***********************************************************************
	; ＯＫボタン押下処理
	; 戻り値:壁オフセット情報リスト
	;        (上オフセット値 下オフセット値 左オフセット値 右オフセット値 照明の強さレベル)
	;***********************************************************************
	(defun ##SetCGWallDlg_CallBack (
		/
		#err_flag #ret$ #UpOffset #DnOffset #LfOffset #RtOffset
		#radioLv1 #radioLv2 #radioLv3 #radioLv4 #radioLv5 #radio  ;-- 2012/03/15 A.Satoh Add 照明の強さ対応

		)

    (setq #err_flag nil)
		(setq #ret$ nil)

		; オフセット入力値を取得
		(setq #UpOffset (get_tile "UpOffset"))		; 上オフセット値
		(setq #DnOffset (get_tile "DnOffset"))		; 下オフセット値
		(setq #LfOffset (get_tile "LfOffset"))		; 左オフセット値
		(setq #RtOffset (get_tile "RtOffset"))		; 右オフセット値

		; 上オフセット値入力チェック
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
		(if (= &allWhite "0")
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
			(if (or (= #UpOffset "") (= #UpOffset nil))
				(progn
					(set_tile "error" "[上オフセット値]が入力されていません")
					(mode_tile "UpOffset" 2)
					(setq #err_flag T)
				)
				(if (or (= (type (read #UpOffset)) 'INT) (= (type (read #UpOffset)) 'REAL))
					(if (> 0 (read #UpOffset))
						(progn
							(set_tile "error" "[上オフセット値]には0以上の数値を入力して下さい")
							(mode_tile "UpOffset" 2)
							(setq #err_flag T)
						)
					)
					(progn
						(set_tile "error" "[上オフセット値]には数値を入力して下さい")
						(mode_tile "UpOffset" 2)
						(setq #err_flag T)
					)
				)
			)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
		)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E

		(if (= #err_flag nil)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
			(if (= &allWhite "0")
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
				; 下オフセット値入力チェック
				(if (or (= #DnOffset "") (= #DnOffset nil))
					(progn
						(set_tile "error" "[下オフセット値]が入力されていません")
						(mode_tile "DnOffset" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #DnOffset)) 'INT) (= (type (read #DnOffset)) 'REAL))
						(if (> 0 (read #DnOffset))
							(progn
								(set_tile "error" "[下オフセット値]には0以上の数値を入力して下さい")
								(mode_tile "DnOffset" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[下オフセット値]には数値を入力して下さい")
							(mode_tile "DnOffset" 2)
							(setq #err_flag T)
						)
					)
				)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
			)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
		)

		(if (= #err_flag nil)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
			(if (= &allWhite "0")
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
				; 左オフセット値入力チェック
				(if (or (= #LfOffset "") (= #LfOffset nil))
					(progn
						(set_tile "error" "[左オフセット値]が入力されていません")
						(mode_tile "LfOffset" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #LfOffset)) 'INT) (= (type (read #LfOffset)) 'REAL))
						(if (> 0 (read #LfOffset))
							(progn
								(set_tile "error" "[左オフセット値]には0以上の数値を入力して下さい")
								(mode_tile "LfOffset" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[左オフセット値]には数値を入力して下さい")
							(mode_tile "LfOffset" 2)
							(setq #err_flag T)
						)
					)
				)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
			)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
		)

		(if (= #err_flag nil)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
			(if (= &allWhite "0")
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
				; 右オフセット値入力チェック
				(if (or (= #RtOffset "") (= #RtOffset nil))
					(progn
						(set_tile "error" "[右オフセット値]が入力されていません")
						(mode_tile "RtOffset" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #RtOffset)) 'INT) (= (type (read #RtOffset)) 'REAL))
						(if (> 0 (read #RtOffset))
							(progn
								(set_tile "error" "[右オフセット値]には0以上の数値を入力して下さい")
								(mode_tile "RtOffset" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[右オフセット値]には数値を入力して下さい")
							(mode_tile "RtOffset" 2)
							(setq #err_flag T)
						)
					)
				)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
			)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
		)

;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
		(if (= #err_flag nil)
			(progn
				; 「照明の強さ」ラジオボタン入力値を取得
				(setq #radioLv1 (get_tile "radioLv1"))		; 強い
				(setq #radioLv2 (get_tile "radioLv2"))		; やや強い
				(setq #radioLv3 (get_tile "radioLv3"))		; 普通
				(setq #radioLv4 (get_tile "radioLv4"))		; やや弱い
				(setq #radioLv5 (get_tile "radioLv5"))		; 弱い

				(cond
					((= #radioLv1 "1")		; 強い
						(setq #radio "1")
					)
					((= #radioLv2 "1")		; やや強い
						(setq #radio "2")
					)
					((= #radioLv3 "1")		; 普通
						(setq #radio "3")
					)
					((= #radioLv4 "1")		; やや弱い
						(setq #radio "4")
					)
					((= #radioLv5 "1")		; 弱い
						(setq #radio "5")
					)
					(T
						(set_tile "error" "[照明の強さ]が選択されていません")
						(mode_tile "radioLv1" 2)
						(setq #err_flag T)
					)
				)
			)
		)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E

		; 壁オフセット情報リストの作成
		(if (= #err_flag nil)
			(progn
				; 情報リスト作成
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
				(if (= &allWhite "0")
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
					(setq #ret$ (list #UpOffset #DnOffset #LfOffset #RtOffset #radio))
					(setq #ret$ (list "0" "0" "0" "0" #radio))
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
				)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E
				(done_dialog)
				#ret$
			)
		)

	) ; ##SetWallSizeDlg_CallBack
	;***********************************************************************

	(setq #offset$ nil)

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kscmain.dcl")))
  (if (not (new_dialog "SetCGWallDlg" #dcl_id)) (exit))

	; ダイアログ初期設定
;-- 2012/03/19 A.Satoh Del 小園様からの依頼 - S
;;;;;	(set_tile "UpOffset" "")			; 上オフセット値
;;;;;	(set_tile "DnOffset" "")			; 下オフセット値
;;;;;	(set_tile "LfOffset" "")			; 左オフセット値
;;;;;	(set_tile "RtOffset" "")			; 右オフセット値
;-- 2012/03/19 A.Satoh Del 小園様からの依頼 - E

;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - S
	(if (= &allWhite "1")
		(progn
;-- 2012/03/19 A.Satoh Add 小園様からの依頼 - S
			(set_tile "UpOffset" "")			; 上オフセット値
			(set_tile "DnOffset" "")			; 下オフセット値
			(set_tile "LfOffset" "")			; 左オフセット値
			(set_tile "RtOffset" "")			; 右オフセット値
;-- 2012/03/19 A.Satoh Add 小園様からの依頼 - E
			(mode_tile "UpOffset" 1)			; 上オフセット値
			(mode_tile "DnOffset" 1)			; 下オフセット値
			(mode_tile "LfOffset" 1)			; 左オフセット値
			(mode_tile "RtOffset" 1)			; 右オフセット値
		)
		(progn
;-- 2012/03/19 A.Satoh Add 小園様からの依頼 - S
			(set_tile "UpOffset" "0")			; 上オフセット値
			(set_tile "DnOffset" "0")			; 下オフセット値
			(set_tile "LfOffset" "0")			; 左オフセット値
			(set_tile "RtOffset" "0")			; 右オフセット値
;-- 2012/03/19 A.Satoh Add 小園様からの依頼 - E
			(mode_tile "UpOffset" 0)			; 上オフセット値
			(mode_tile "DnOffset" 0)			; 下オフセット値
			(mode_tile "LfOffset" 0)			; 左オフセット値
			(mode_tile "RtOffset" 0)			; 右オフセット値
		)
	)
;-- 2012/03/15 A.Satoh Add 照明の強さ対応 - E

;-- 2012/03/28 A.Satoh Mod 小園様からの依頼 照明強さを全て使えるように - S
;;;;;;-- 2012/03/19 A.Satoh Add 小園様からの依頼 - S
;;;;;	(mode_tile "radioLv4" 1)			; 照明の強さ：やや弱い
;;;;;	(mode_tile "radioLv5" 1)			; 照明の強さ：弱い
;;;;;;-- 2012/03/19 A.Satoh Add 小園様からの依頼 - E
;-- 2012/03/28 A.Satoh Mod 小園様からの依頼 照明強さを全て使えるように - E

	; スライド設定
	(setq #x (dimx_tile "slide1")
				#y (dimy_tile "slide1")
	)
	(start_image "slide1")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\CG壁"))
	(end_image)

	(setq #next 99)
	(while (and (/= #next 1) (/= #next 0))
	  (action_tile "accept" "(setq #offset$ (##SetCGWallDlg_CallBack))")
  	(action_tile "cancel" "(setq #offset$ nil) (done_dialog)")

	  (setq #next (start_dialog))
	)
  (unload_dialog #dcl_id)

	#offset$

) ;SetCGWallDlg
;-- 2012/03/05 A.Satoh Add - E


(princ)
