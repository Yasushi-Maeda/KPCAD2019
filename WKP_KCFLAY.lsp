(setq CG_FigureScale 34.0)
(setq CG_LayTitleH 2)        ; 図面枠表題尺度１の時の文字高さを2
(setq CG_LayTitleTag "T^")   ; 図面枠表題のタグ
;;;(setq CG_DWG_VERSION "2007") ; DWG保存時のバージョン 2008/09/24 YM MOD
(setq CG_DWG_VERSION "2000") ; DWG保存時のバージョン 2008/09/24 YM MOD
;-- 2011/10/21 A.Satoh Mod - S
;;;;;(setq CG_DXF_VERSION "R12")  ; DWG保存時のバージョン
(setq CG_DXF_VERSION "2000")  ; DWG保存時のバージョン
;-- 2011/10/21 A.Satoh Mod - S

(setq CG_OUTAUPREC 5)        ; 角度の精度


; 施工図の画層
  ; 図面種類 施工図の画層    03 : 建築下地図 04 : 設備配管図
  ; 図面種類 商品図の画層    02 : 商品図
  (setq CG_OUTSHOHINZU "02")
  (setq CG_OUTSEKOUZU  "04")

;図面保存ファイルタイプ
(setq CG_SAVE_OUTPUT_FILE_TYPE "DXF")



;;;<HOM>************************************************************************
;;; <関数名>  : PersHantei
;;; <処理概要>: 立体ﾃﾝﾌﾟﾚｰﾄ含むか判定
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun PersHantei (
	&Pat$
  /
	#DUM_STR
  )
	(setq CG_PERS nil)
  (foreach #Pat &Pat$
    (setq #dum_STR (car #Pat))
      (if (vl-string-search "立体" #dum_STR)
        (setq CG_PERS T)
      );_if
  );foreach
	(princ)
);PersHantei


;;;<HOM>************************************************************************
;;; <関数名>  : C:SCFLayout
;;; <処理概要>: 図面レイアウト
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun C:SCFLayout (
  /
  #iOk #Txt$ #PatRet$ #Pat$ #sNo #iAuto #sType #DIM$ #STMP
  #dimpat$  ; ((キャビネット寸法 施工寸法 自動・左・右 縦横) (パターン パターン・・・))
#TAIMEN ; 04/04/13 YM ADD
#ver #sFname2 ;-- 2011/10/06 A.Satoh Add
#VER$$ #Input$	;-- 2011/10/21 A.Satoh Add
  )

  (WebOutLog "ｴﾗｰ関数 SKAutoError2 を定義します(C:SCFLayout)"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  ; 02/09/03 YM MOD ｴﾗｰ関数定義
  (cond
    ((= CG_AUTOMODE 1)
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError1)
      );_if
    )
    ((member CG_AUTOMODE '(2 4 5))
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError2)
      );_if
    )
    ((= CG_AUTOMODE 3)
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError1)
      );_if
    )
  );_cond
  ; 02/09/03 YM MOD ｴﾗｰ関数の分岐使い分け ここで再定義しないといけない

  ; 02/01/19 HN E-ADD パース図のカメラ視点をシンクキャビネットの配置角度で判断
  (setq CG_AngSinkCab (SCFGetAngSinkCab))

  (SCFStartShori "SCFLayout")
  ; 前処理
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (StartUndoErr)
  );_if
;-- 2011/10/05 A.Satoh Add - S
  (setq CG_OSMODE_BAK (getvar "OSMODE"))
  (setq CG_SNAPMODE_BAK (getvar "SNAPMODE"))
  (setq CG_ORTHOMODE_BAK (getvar "ORTHOMODE"))
  (setq CG_GRIDMODE_BAK (getvar "GRIDMODE"))
;-- 2011/10/05 A.Satoh Add - E
;-- 2012/03/27 A.Satoh Add - S
	(setq CG_PlanType nil)
;-- 2012/03/27 A.Satoh Add - E

;;;(WebOutLog "(1)ｴﾗｰ関数="); 02/09/04 YM ADD ﾛｸﾞ出力追加
;;;(WebOutLog *error*); 02/09/04 YM ADD ﾛｸﾞ出力追加
;;;(makeERR "ﾚｲｱｳﾄ1") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ﾚｲｱｳﾄ1


  (if (/= nil CG_KENMEI_PATH)
    (progn

;;;(makeERR "ﾚｲｱｳﾄ2") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ﾚｲｱｳﾄ2

      (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
        nil
        (progn
          ;保存確認
          (setq #iOk (CFYesNoDialog "図面を一度保存しますか？"))
          (if (= T #iOK)
            (progn
;-- 2011/10/06 A.Satoh Add - S
;;;;;              (command "_.QSAVE")
              (setq #sFname2 (strcat (getvar "dwgprefix") (getvar "dwgname")))
              (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
                      (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
                (setq #ver CG_DWG_VER_MODEL)
                (setq #ver CG_DWG_VER_SEKOU)
              )
              (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/06 A.Satoh Add - E
            )
          );_if
        )
      );_if
      ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞでは保存確認しない

      (setq CG_DwgName (findfile (strcat CG_KENMEI_PATH (getvar "DWGNAME"))))
      ;出力パターン指定ダイアログ
      (setq #Txt$     (SKOutPatReadScv (strcat CG_SKPATH "outpat.cfg")))
      (if (/= nil #Txt$)
        (progn
          (if (member CG_AUTOMODE (list 1 2 3 4 5))
            (progn
              (if (member CG_AUTOMODE (list 4 5));JPG出力ﾓｰﾄﾞ;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
                (progn
                  (setq #PatRet$ CG_AUTOMODE_TEMPLT_JPG) ; JPG用
                )
                ;else
                (progn
                  (setq #PatRet$ CG_AUTOMODE_TEMPLT)
                )
              );_if
            )
            ;else
            (setq #PatRet$ (SCFGetPatDlg #Txt$))
          );_if
          ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞではﾀﾞｲｱﾛｸﾞ表示しない

          (if (/= nil #PatRet$)
            (progn
              (setq #Pat$     (nth 0 #PatRet$))   ;パターンリスト
              (setq #sNo      (nth 1 #PatRet$))   ;領域NO
              (setq #iAuto    (nth 2 #PatRet$))   ;AUTOフラグ

							;2017/09/15 YM ADD-S
;;;							(PersHantei #Pat$) ; 立体ﾃﾝﾌﾟﾚｰﾄ含むか判定  ;パース判定しない 2017/09/21 YM MOD

              ;キッチンタイプ獲得
              (setq #sType    (SKGetKichenType #sNo)) ;ﾌﾚｰﾑｷｯﾁﾝの場合パース図はL/Rをユーザーに聞いている
;;;							(setq CG_PERS nil);ｸﾞﾛｰﾊﾞﾙ変数ｸﾘｱ
							;2017/09/15 YM ADD-E

              (if (/= nil #sType)
                (progn
                  ;自動(STANDARD)のときの図面種類選択ダイアログ
                  (if (= 0 #iAuto)
                    (progn  ;今は常に #iAuto=1 なのでここは通らない
                      ; 一括 平面図 展開図 仕様図を選択する
                      ; STAMDARDの時
                      (setq #Pat$ (SCFGetPatDlgAuto #Pat$ #sType))
                      (setq CG_TMPPATH CG_TMPAPATH)
                    )
                    (progn
                      (setq CG_TMPPATH CG_TMPHPATH)
                    )
                  );_if

                  (if (/= nil #Pat$)
                    (progn
                      ; 寸法作成制御ダイアログを表示する
                      ; 2000/07/04 HT MOD 商品図 施工図選択を行うように変更
                  ; 但し、STANDARDが選択されている時は選択なし
                      ; (setq #dim$ (SCFGetOutDimAuto))

;2011/07/22 YM MOD-S 寸法作成制御ダイアログを表示しない
;;;                     ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞではﾀﾞｲｱﾛｸﾞ表示しない;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
;;;                     (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
;;;                       (setq #dimpat$ CG_AUTOMODE_DIMMK);(setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "02") )))
;;;                       ;else
;;;                       (setq #dimpat$ (SCFGetOutDimAuto #Pat$ #iAuto))  ; #dimpat$ = (#dim$ #Pat$)
;;;                     );_if
;;;                     ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞではﾀﾞｲｱﾛｸﾞ表示しない

                      ;#Pat$から#dimpat$を作る
                      ;(setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "02") )))
                      (setq #dum$ nil)
                      (setq #dum$$ nil)
                      (foreach #Pat #Pat$
                        (setq #dum_STR (car #Pat))
                        (cond
                          ((vl-string-search "02" #dum_STR)
                            (setq #dum$ (list #dum_STR "02"))
                          )
                          ((vl-string-search "04" #dum_STR)
                            (setq #dum$ (list #dum_STR "04"))
                          )
                          ((vl-string-search "立体" #dum_STR)
                            (setq #dum$ (list #dum_STR "00"))
                          )
                          (T
                            (setq #dum$ (list #dum_STR "02"))
                          )
                        );_cond
                        (setq #dum$$ (append #dum$$ (list #dum$)))
                      );foreach

                      (setq #dimpat$ 
                        (list
                          (list "1" "1" "A" "Y")
                          #dum$$
                        )
                      )

;2011/07/22 YM MOD-S 寸法作成制御ダイアログを表示しない

                      ;"立体","仕様"の文字列があるかどうかで判定する
;;;2011/07/22YM@DEL                     (if (/= 0 #iAuto)
;;;2011/07/22YM@DEL                       (progn
;;;2011/07/22YM@DEL                         (setq #dum_STR (car (car (cadr #dimpat$))))
;;;2011/07/22YM@DEL                         (if (or (vl-string-search "立体" #dum_STR)
;;;2011/07/22YM@DEL                                 (vl-string-search "仕様" #dum_STR))
;;;2011/07/22YM@DEL                           (progn
;;;2011/07/22YM@DEL                             (setq #car  (list "0" "0" "A" "Y"))
;;;2011/07/22YM@DEL                             (setq #cadr (list (list #dum_STR "02")))
;;;2011/07/22YM@DEL                             (setq #dimpat$ (list #car #cadr))
;;;2011/07/22YM@DEL                           )
;;;2011/07/22YM@DEL                         );_if
;;;2011/07/22YM@DEL                       )
;;;2011/07/22YM@DEL                     );_if
                      ; ﾊﾟｰｽor仕様表のみﾃﾝﾌﾟﾚｰﾄの場合#dimpat$を修正商品図のみ作図 01/05/10 YM END ----------

                      (if (/= 0 #iAuto)
                        (progn
                        ; STANDARDが選択されていないとき
                          (setq #Pat$ (cadr #dimpat$))
                        )
                      )
                      (setq #dim$ (car #dimpat$))
                      (if (/= nil #dim$)
                        (progn

                          ;00/08/22 SN S-ADD
                          ;XRecord"SERI"の情報を外部変数に出力

                          ;2008/08/13 YM DEL XRECORDから改めてｸﾞﾛｰﾊﾞﾙ変数ｾｯﾄは不要
;;;                          (SCFSetXRecGbl)

                          ;パターンリスト集
                          ; テンプレートファイル名リスト
                          (setq CG_Pattern (SCFEditPattarn #Pat$))
                          ; テンプレートファイル名リストの要素番号
                          (setq CG_PatNo 0)
                          ; 領域No
                          (setq CG_RyoNo #sNo)
                          ; キッチンタイプ ex) I-RIGHTなど
                          (setq CG_KitType #sType)
                          ; 図面枠表題
                          (if (= CG_AUTOMODE 2);CADｻｰﾊﾞｰ
                            (progn
                              (setq CG_TitleStr (SCFGetTitleStr))
                            )
                            ;else KPCAD
;-- 2011/10/21 A.Satoh Mod - S
;;;;;                            (setq CG_TitleStr 
;;;;;                              (list
;;;;;                                "★物件名称★"
;;;;;                                "★プラン番号★"
;;;;;                                "★プラン名称★"
;;;;;                                "★追番★"
;;;;;                                "★営業所名★"
;;;;;                                "★営業担当★"
;;;;;                                "★見積担当★"
;;;;;                                "★バージョン★"
;;;;;                                ""                                                    ; プラン名
;;;;;                                ""                                                    ; 件名コード
;;;;;                                ""                                                    ; 取扱店名
;;;;;                                ""                                                    ; 図面内記事欄
;;;;;                                ""                                                    ; 系列
;;;;;                                ""                                                    ; 扉
;;;;;                                ""                                                    ; ワークトップ
;;;;;                                ""                                                    ; ワークトップ2(ｶｳﾝﾀｰ)
;;;;;                                ""                                                    ; システム名    未使用
;;;;;                                ""                                                    ; 会社名        未使用
;;;;;                              )
;;;;;                            )
														(progn
															(setq #VER$$ (ReadIniFile (strcat CG_SYSPATH  "Version.ini")))
															(setq #Input$$ (ReadIniFile (strcat CG_SYSPATH  "Input.cfg")))
	                            (setq CG_TitleStr 
  	                            (list
    	                            (cadr (assoc "ART_NAME"             #Input$$))	; ★物件名称★
      	                          (cadr (assoc "PLANNING_NO"          #Input$$))	; ★プラン番号★
        	                        (cadr (assoc "PLAN_NAME"            #Input$$))	; ★プラン名称★
          	                      (cadr (assoc "VERSION_NO"           #Input$$))	; ★追番★
            	                    (cadr (assoc "BASE_BRANCH_NAME"     #Input$$))	; ★営業所名★
              	                  (cadr (assoc "BASE_CHARGE_NAME"     #Input$$))	; ★営業担当★
                	                (cadr (assoc "ADDITION_CHARGE_NAME" #Input$$))	; ★見積担当★
                  	              (cadr (assoc "VERNO"                #VER$$))		; ★バージョン★
                    	            ""                                                    ; プラン名
                      	          ""                                                    ; 件名コード
                        	        ""                                                    ; 取扱店名
                          	      ""                                                    ; 図面内記事欄
                            	    ""                                                    ; 系列
                              	  ""                                                    ; 扉
                                	""                                                    ; ワークトップ
	                                ""                                                    ; ワークトップ2(ｶｳﾝﾀｰ)
  	                              ""                                                    ; システム名    未使用
    	                            ""                                                    ; 会社名        未使用
      	                        )
        	                    )
														)
;-- 2011/10/21 A.Satoh Mod - E
                          );_if

                          ; (キャビネット寸法 施工寸法 自動・左・右 縦横)
                          ;  キャビネット寸法 ON : "1"    OFF : "0"
                          ;  施工寸法         ON : "1"    OFF : "0"
                          ;  自動 : A  左 : L  右 : R
                          ;  縦 : T  横 : Y
                          (setq CG_DimPat #dim$)

                          ;テンプレート毎に図面作図
                          (if (nth CG_PatNo CG_Pattern)
                            (progn
                              (setq #sTmp  (car  (nth CG_PatNo CG_Pattern)))   ;テンプレートファイル名
                              ;;(if (findfile (strcat CG_TMPPATH #sTmp ".dwt"))
                                ;;(progn
                                  ; 図面レイアウトモードでオープンする
                                  ; オープン後に、(SCFLayoutDrawBefore)が呼ばれる

                                  (WebOutLog "ｵｰﾌﾟﾝﾓｰﾄﾞ=4 で再ｵｰﾌﾟﾝします(C:SCFLayout)")  ; 02/09/04 YM ADD ﾛｸﾞ出力追加
                                  (WebOutLog "ｵｰﾌﾟﾝ後に(SCFLayoutDrawBefore)を実行します"); 02/09/04 YM ADD ﾛｸﾞ出力追加
                                  (setq CG_OpenMode 4)

                                  ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞではSCFCmnFileOpenが効かない;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
;;;                                 (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"追加 03/02/22 JPGﾚｲｱｳﾄﾓｰﾄﾞ
                                  (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
                                    (progn
;;;                                     (command ".qsave");2008/08/09 YM MOD qsave==>saveas
;-- 2011/10/06 A.Satoh Mod - S
;;;;;                                      (command "_SAVEAS" CG_DWG_VERSION CG_DwgName);2008/08/09 YM MOD
                                      (command "_SAVEAS" CG_DWG_VER_MODEL CG_DwgName);2008/08/09 YM MOD
;-- 2011/10/06 A.Satoh Mod - E
                                      (command "_.Open" (strcat CG_TMPPATH #sTmp ".dwt"))
                                      (S::STARTUP)
                                    )
                                    ; 2000/10/19 HT 関数化
                                    (SCFCmnFileOpen (strcat CG_TMPPATH #sTmp ".dwt") 0)
                                  );_if
                                  ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞではSCFCmnFileOpenが効かない

                            )
                            (CFAlertMsg "パターンが入力されていません")
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
      )
    )
    (progn
      (CFAlertMsg "物件が呼び出されていません.")
    )
  )
  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 後処理
;-- 2012/03/27 A.Satoh Add - S
	(setq CG_PlanType nil)
;-- 2012/03/27 A.Satoh Add - E
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (setq *error* nil)
  );_if
  ; 01/09/03 YM ADD-E UNDO処理追加
;;;(makeERR "ﾚｲｱｳﾄ6") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ﾚｲｱｳﾄ6
;;;(WebOutLog "(2)ｴﾗｰ関数="); 02/09/04 YM ADD ﾛｸﾞ出力追加
;;;(WebOutLog *error*); 02/09/04 YM ADD ﾛｸﾞ出力追加

  (princ)
) ; C:SCFLayout


;;;<HOM>************************************************************************
;;; <関数名>  : SCFSetXRecGbl
;;; <処理概要>: XRecord"SERI"の情報を外部変数に出力
;;; <戻り値>  : なし
;;; <備考>    : 2000/10/10 HT 関数化
;;;************************************************************************>MOH<
(defun SCFSetXRecGbl (
  /
  #serix$
  )

  (setq #serix$ (CFGetXRecord "SERI"))
  (if (> (length #serix$)  0) (setq CG_DBNAME      (nth  0 #serix$)) (setq CG_DBNAME     "") ); 1.DB名称
  (if (> (length #serix$)  1) (setq CG_SeriesCode  (nth  1 #serix$)) (setq CG_SeriesCode "") ); 2.SERIES記号
  (if (> (length #serix$)  2) (setq CG_BrandCode   (nth  2 #serix$)) (setq CG_BrandCode  "") ); 3.ブランド記号
  (if (> (length #serix$)  3) (setq CG_DRSeriCode  (nth  3 #serix$)) (setq CG_DRSeriCode "") ); 4.扉SERIES記号
  (if (> (length #serix$)  4) (setq CG_DRColCode   (nth  4 #serix$)) (setq CG_DRColCode  "") ); 5.扉COLOR記号
  (if (> (length #serix$)  5) (setq CG_UpCabHeight (nth  5 #serix$)) (setq CG_UpCabHeight 0) ); 6.取付高さ
  (if (> (length #serix$)  6) (setq CG_CeilHeight  (nth  6 #serix$)) (setq CG_CeilHeight  0) ); 7.天井高さ
  (if (> (length #serix$)  7) (setq CG_RoomW       (nth  7 #serix$)) (setq CG_RoomW       0) ); 8.間口
  (if (> (length #serix$)  8) (setq CG_RoomD       (nth  8 #serix$)) (setq CG_RoomD       0) ); 9.奥行
  (if (> (length #serix$)  9) (setq CG_GasType     (nth  9 #serix$)) (setq CG_GasType    "") );10.ガス種
  (if (> (length #serix$) 10) (setq CG_ElecType    (nth 10 #serix$)) (setq CG_ElecType   "") );11.電気種
  (if (> (length #serix$) 11) (setq CG_KikiColor   (nth 11 #serix$)) (setq CG_KikiColor  "") );12.機器色
  (if (> (length #serix$) 12) (setq CG_KekomiCode  (nth 12 #serix$)) (setq CG_KekomiCode "") );13.ケコミ飾り
; 02/12/10 YM DEL-S [14]にSX取手記号を入れているため削除
;;;  (if (> (length #serix$) 13) (setq CG_DRSeriCodeRV(nth 13 #serix$)) (setq CG_DRSeriCodeRV nil) ); 14.リバーシブル用扉SERIES記号 00/10/13 SN ADD 00/10/24 SN MOD 初期値をnilに変更
;;;  (if (> (length #serix$) 14) (setq CG_DRColCodeRv (nth 14 #serix$)) (setq CG_DRColCodeRV  nil ) ); 15.リバーシブル用扉COLOR記号   00/10/13 SN ADD 00/10/24 SN MOD 初期値をnilに変更
; 02/12/10 YM DEL-E [14]にSX取手記号を入れているため削除
)


;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetPatDlg
;;; <処理概要>: 図面レイアウト出力パターン選択ダイアログ
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SCFGetPatDlg (
  &Txt$       ; 出力ﾊﾟﾀｰﾝﾘｽﾄ
  /
  #xSp #iI #No$ #iMode #sNo #Pat$ #iId ##SetList ##OK_Click #iRet #Ret$
  )
  (defun ##OK_Click(
    /
    #Pop$
    )
    (setq #sPat (nth (atoi (get_tile "lstPat")) #Pat$))
    (setq #Pop$ (assoc #sPat &Txt$))
    (if (= nil #sNo)
      (progn
        ; 2000/07/06 HT YASHIAC  矢視領域判定変更
  ; 領域は常に"0"
        ; (setq #sNo (nth (atoi (get_tile "popRyo")) #No$))
        (setq #sNo "0")
        (if (= "0" (get_tile "lstPat"))
          (progn
            (setq #sAng (cadr (assoc #sNo #sAng$)))
            (if (/= "90" #sAng)
              (progn
                (CFAlertMsg "現状で、矢視設定された状態での\nSTANDARDパターンの選択はできません.")
              )
              (progn
                (setq #Ret$ (list (cdr (cdr #Pop$)) #sNo (cadr #Pop$)))
                (done_dialog 1)
              )
            )
          )
          (progn
            (setq #Ret$ (list (cdr (cdr #Pop$)) #sNo (cadr #Pop$)))
            (done_dialog 1)
          )
        )
      )
      (progn
        (setq #Ret$ (list (cdr (cdr #Pop$)) #sNo (cadr #Pop$)))
        (done_dialog 1)
      )
    )
  )
  ;リストボックスに値を表示する
  (defun ##SetList ( &SCFey &List$ / #vAl )
    (start_list &SCFey)
    (foreach #vAl &List$
      (add_list #vAl)
    )
    (end_list)
  )

  ; 2000/07/06 HT YASHIAC  矢視領域判定更
  ; 領域は常に"0"
  ;;領域NO獲得
  ;(setq #xSp (ssget "X" (list (list -3 (list "RECT")))))
  ;(if (/= nil #xSp)
  ;  (progn
  ;    (setq #iI 0)
  ;    (repeat (sslength #xSp)
  ;      (setq #Ex$ (CfGetXData (ssname #xSp #iI) "RECT"))
  ;      (setq #No$ (cons (nth 0 #Ex$) #No$))
  ;      (setq #sAng$ (cons (list (nth 0 #Ex$)(nth 1 #Ex$)) #sAng$))
  ;      (setq #iI (1+ #iI))
  ;    )
  ;    (setq #No$ (acad_strlsort #No$))
  ;    (setq #No$ (ExceptToList #No$))
  ;    (setq #iMode 0)
  ;  )
  ;  (progn
      (setq #sNo "0")
      (setq #iMode 1)
  ;  )
  ;)

  ;パターンリスト獲得
  (setq #Pat$ (mapcar 'car &Txt$))

  ;ダイアログ表示
  (setq #iId (GetDlgID "CSFlay"))
  (if (not (new_dialog "GetPat" #iId))(exit))

    (##SetList "lstPat" #Pat$)
    ; 2000/07/06 HT YASHIAC  矢視領域判定更
    ;(##SetList "popRyo" #No$)
    ;(mode_tile "popRyo" #iMode)
    ;(set_tile  "lstPat" "1")
    (set_tile  "lstPat" "0");2011/07/22 YM MOD 一番上にする
    ;(set_tile  "popRyo" "1") 2000/07/06

    (action_tile "accept" "(##OK_Click)")
    (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OKボタン押下
    #Ret$
    nil
  )
) ; SCFGetPatDlg

;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetPatDlgAuto
;;; <処理概要>: 自動選択のときの図面レイアウト出力図面選択ダイアログ
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SCFGetPatDlgAuto (
  &Pat$       ; 出力パターンリスト
  &sType      ; キッチンタイプ
  /
  #iId ##OK_Click #iRet #Ret$
  )
  (defun ##OK_Click(
    /
    #Ret$ #view #sTempfile #Sret$
    )
    (if (= "1" (get_tile "Z00"))   ;立面図
      (setq #Ret$ (cons (list "SK_立体" "00") #Ret$))
    )
    (if (= "1" (get_tile "P02"))   ;平面図
      (setq #Ret$ (cons (list "SK_平面" CG_OUTSHOHINZU) #Ret$)) ; 2000/09/25 HT MOD (setq #Ret$ (cons (list "SK_平面" "02") #Ret$))
    )
    (if
      (or                       ;展開図
        (= "1" (get_tile "T02"))
        (= "1" (get_tile "T03"))
      )
      (progn
        (cond
          ((or (equal &sType "I-RIGHT") (equal &sType "I-LEFT"))
            (setq #sTempfile "SK_BAD展開")
          )
          ((or (equal &sType "D-RIGHT") (equal &sType "D-LEFT"))
            (setq #sTempfile "SK_BAD展開")
          )
          ((or (equal &sType "L-RIGHT") (equal &sType "W-LEFT"))
            (setq #sTempfile "SK_AD展開")
          )
          ((or (equal &sType "L-LEFT") (equal &sType "W-RIGHT"))
            (setq #sTempfile "SK_BA展開")
          )
        )
        (if (= "1" (get_tile "T02"))  (setq #Sret$ (cons CG_OUTSHOHINZU #Sret$))) ; 2000/09/25 HT MOD (setq #Sret$ (cons "02" #Sret$)))
        (if (= "1" (get_tile "T03"))  (setq #Sret$ (cons CG_OUTSEKOUZU #Sret$))) ; 2000/09/25 HT MOD (setq #Sret$ (cons "03" #Sret$)))
        (setq #Ret$ (cons (cons #sTempfile (reverse #Sret$)) #Ret$))
      )
    )
    (if (= "1" (get_tile "Shiyo")) ;仕様図
      (setq #Ret$ (cons (list "SK_仕様表" "") #Ret$)) ;"
    )
    (if (/= nil #Ret$)
      (progn
        (setq #Ret$ (reverse #Ret$))
        (done_dialog 1)
      )
      (CFAlertMsg "何も選択されていません.")
    )
    #Ret$
  )

  ;ダイアログ表示
  (setq #iId (GetDlgID "CSFlay"))
  (if (not (new_dialog "GetPlanAuto" #iId))(exit))

    (action_tile "accept" "(setq #Ret$ (##OK_Click))")
    (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OKボタン押下
    #Ret$
    nil
  )
) ; SCFGetPatDlgAuto


;<HOM>************************************************************************
; <関数名>  : SCFGetOutDimAuto
; <処理概要>: 寸法線作成制御ダイアログ
; <戻り値>  : ダイアログ返り値
; <備考>    : なし
;************************************************************************>MOH<

(defun SCFGetOutDimAuto (
   &Pat$   ;
   &iAuto  ; 自動フラグ (STANDARDの時1)
  /
  #iId ##radio_mode #Ret$ ##OK_Click #iRet
  )

  (defun ##OK_Click (
    /
    #rdi #san
    #dim$  ; (キャビネット寸法 施工寸法 自動・左・右 縦横)
    #Pat$  ; テンプレート名 + 図面種類リスト
    #sPat
    #lst$
    #lst2$
    #i
    #sPat2$
    )

    ; 02/07/22 YM ADD-S 「平面図に寸法を引かない」にチェック→グローバル設定
    (setq CG_PLANE_DIM nil)
    (if (= "1" (get_tile "tglpl"))
      (setq CG_PLANE_DIM T) ; 平面図に寸法を引かない
    );_if
    ; 02/07/22 YM ADD-E

    (cond
      ((= "1" (get_tile "rdia"))  (setq #rdi "A"))
      ((= "1" (get_tile "rdil"))  (setq #rdi "L"))
      ((= "1" (get_tile "rdir"))  (setq #rdi "R"))
    )
    (cond
      ((= "1" (get_tile "yoko"))  (setq #san "Y"))
      ((= "1" (get_tile "tate"))  (setq #san "T"))
    )
    ; 2000/07/04 施工図のチェックボタンがONの時のみ
    ; 寸法種類(施工寸法とキャビネット寸法)が選択できるようにする
    ; 商品図の時はキャビネット寸法のみ(仕様変更なし)
    ; 2000/07/04 HT DEL (list (get_tile "tglK") (get_tile "tglS") #rdi #san)
    (if (or (= "1" (get_tile "tglSet")) (= &iAuto 0))
      (progn
      (setq #dim$ (list (get_tile "tglK") (get_tile "tglS") #rdi #san))
      )
      (progn
      (setq #dim$ (list "0" "0" #rdi #san))
      )
    )
    ; 返り値でパターン編集("02" "03"を付加する)
    (if (= &iAuto 0)
      (progn
        ; STANDARDが選ばれている時は、既に自動で設定されている
        (setq #sPat2$ nil)
      )
      (progn
        (setq #sPat2$ '())

        (setq #lst$ '())
        ; 商品図のチェックがONの時
        (if (= "1" (get_tile "tglRay")) (progn
          (setq #lst$ (append #lst$ (list CG_OUTSHOHINZU))) ; 2000/09/26 HT MOD (setq #lst$ (append #lst$ (list "02")))
        ))
        ; 施工図のチェックがONの時
        (if (= "1" (get_tile "tglSet")) (progn
          (setq #lst$ (append #lst$ (list CG_OUTSEKOUZU))) ; 2000/09/26 HT MOD  (setq #lst$ (append #lst$ (list "03")))
        ))
        (mapcar '(lambda (#sPat)
          (setq #i 1 #lst2$ '())
          (repeat (1- (length #sPat))
            ; テンプレート名の後に "02" "03"以外がついていると保存しておく
              ; (if (= (member (nth #i #sPat) '("02" "03")) nil)  2000/09/26 HT MOD
              (if (= (member (nth #i #sPat) '(CG_OUTSHOHINZU CG_OUTSEKOUZU)) nil)
                (progn
              (setq #lst2$ (append #lst2$ (list (nth #i #sPat))))
              )
            )
            (setq #i (1+ #i))
          )
          ; パターンリスト編集
          ; 例) ((テンプレート名 "02" "03") (テンプレート名 "02" "03") ・・・)
          (if #lst$
            (setq #sPat2$ (append #sPat2$ (list (append (list (car #sPat)) #lst$))))
            (if #lst2$
              (setq #sPat2$ (append #sPat2$ (list (append (list (car #sPat)) #lst2$))))
              (setq #sPat2$ (append #sPat2$ (list (append (list (car #sPat)) (list "")))))
            );_if
          );_if
          )
          &Pat$
        ) ; mapcar
      )
    ) ; if
    (list #dim$ #sPat2$)
  );##OK_Click

  ; 施工寸法のチェックボタンがONの時に呼ばれる関数
  (defun ##radio_mode (
    /
    )
    (if (= "1" (get_tile "tglS"))
      (progn
        (mode_tile "rdi" 0)
        (mode_tile "rdt" 0)
      )
      (progn
        (mode_tile "rdi" 1)
        (mode_tile "rdt" 1)
      )
    )
  )

  ; 施工図のチェックボタンがONの時に呼ばれる関数
  (defun ##radio_mode2 (
    /
    )
    (if (= "1" (get_tile "tglSet"))
      (progn
        (mode_tile "rdi" 0)
        (mode_tile "rdt" 0)
        (mode_tile "tglK" 0)
        (mode_tile "tglS" 0)
      )
      (progn
        (mode_tile "rdi" 1)
        (mode_tile "rdt" 1)
        (mode_tile "tglK" 1)
        (mode_tile "tglS" 1)
      )
    )
  )


  ;ﾀﾞｲｱﾛｸﾞ表示
  (setq #iId (GetDlgID "CSFlay"))
  (if (not (new_dialog "GetOutDim" #iId))(exit))
    (##radio_mode)
    (action_tile "tglS"   "(##radio_mode)")
    ; 2000/07/04 施工図のチェックボタンがONの時のみ
    ; 寸法種類(施工寸法とキャビネット寸法)が選択できるようにする
    ; 商品図の時はキャビネット寸法のみ(仕様変更なし)
    (if (= &iAuto 0)
      (progn
      (mode_tile "tglRay" 1)
      (mode_tile "tglSet" 1)
      )
      (progn
      (##radio_mode2)
      (action_tile "tglSet"   "(##radio_mode2)")
      )
    )
    (action_tile "accept" "(setq #Ret$ (##OK_Click))(done_dialog 1)")
    (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OKボタン押下
    #Ret$
    nil
  )
) ; SCFGetPatDlgAuto


;<HOM>************************************************************************
; <関数名>  : SCFEditPattarn
; <処理概要>: 出力パターンリスト編集
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<

(defun SCFEditPattarn (
  &Pat$       ; パターンリスト
  /
  #Tmp$ #sTmp #sType #Ret$
  )
  (mapcar
   '(lambda ( #Tmp$ )
      (setq #sTmp (car #Tmp$))
      (mapcar
       '(lambda ( #sType )
          (if (or (= "" #sType)(= nil #sType))
            (setq #Ret$ (cons (list #sTmp "")     #Ret$))
            (setq #Ret$ (cons (list #sTmp #sType) #Ret$))
          )
        )
        (cdr #Tmp$)
      )
    )
    &Pat$
  )

  (reverse #Ret$)
) ; SCFEditPattarn


;<HOM>************************************************************************
; <関数名>  : SCFLayoutDrawBefore
; <処理概要>: レイアウト出力
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<
(defun SCFLayoutDrawBefore (
  /
  #sTmp #sView #xSp #iI #eEn #sType #sMfile #sFname
  #bTblDrw  ; 仕様図があるかないかのフラグ 2000/08/08 HT
  #BFLG #STITLE #n
#sFname2 #ver    ;-- 2011/10/06 A.Satoh Add
#FTYPE #RET #SM1FILE #SM2FILE ;2012/01/28 YM ADD
  )

;;;(makeERR "ﾚｲｱｳﾄ7") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ﾚｲｱｳﾄ7
;;;(WebOutLog "(3)ｴﾗｰ関数="); 02/09/04 YM ADD ﾛｸﾞ出力追加
;;;(WebOutLog *error*); 02/09/04 YM ADD ﾛｸﾞ出力追加

  ; 02/06/17 YM ADD-S "0_WAKU"画層を非表示にする
  (command "_layer" "of" "0_WAKU" "")
  ; 02/06/17 YM ADD-E

  ;文字スタイルを設定する(第２水準までカバー）
  (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" ""); 2011/05/30 YM MOD
  (command "._style" "KANJI_M" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

  (setq #sTmp  (car  (nth CG_PatNo CG_Pattern)))   ;テンプレートファイル名
  (setq #sView (cadr (nth CG_PatNo CG_Pattern)))   ;図面種類
  (setq #bTblDrw nil)    ; 2000/08/08 HT ADD
  ;図面内のレイアウトパターンを獲得

  ;2008/08/09 YM ADD as TS
  ;★DXF保存対応★
;;;  (setq #sFname (strcat CG_KENMEI_PATH "OUTPUT\\" #sTmp "_" CG_RyoNo "_" #sView "." CG_SAVE_OUTPUT_FILE_TYPE))
;;;  (SCFSaveOutputFileType #sFname)


  (SCF_LayFreezeOff (list "0_WAKU"))
  (setq #xSp (ssget "X" (list (cons 8 "0_WAKU") (list -3 (list "FRAME")))))


;;; ; 01/05/10 YM ADD "FRAME"が仕様表のみパースのみであるかどうか判定する START ------------------
;;;  (setq #n 0 #kosu_P 0 #kosu_D 0 #kosu 0) ; パース枠,仕様表枠,それ以外の個数
;;;  (repeat (sslength #xSp)
;;;    (setq #dum_Type (car (CfGetXData (ssname #xSp #n) "FRAME")))
;;;   (cond
;;;     ((= #dum_Type "P")(setq #kosu_P (1+ #kosu_P)))
;;;     ((= #dum_Type "D")(setq #kosu_D (1+ #kosu_D)))
;;;     (T (setq #kosu (1+ #kosu)))
;;;   );_cond
;;;   (setq #n (1+ #n))
;;; );repeat
;;;
;;; (if (or (and (= #kosu 0)(> #kosu_P 0))  ; ﾊﾟｰｽのみ
;;;         (and (= #kosu 0)(> #kosu_D 0))) ; 仕様表のみ
;;;   (setq #SYOHIN_ONLY T)
;;;   (setq #SYOHIN_ONLY nil)
;;; );_if
;;; ; 01/05/10 YM ADD "FRAME"が仕様表のみパースのみであるかどうか判定する START ------------------


  (if (/= nil #xSp)
    (progn ; "0_WAKU"がある場合
      (setq #iI 0)
      ;03/07/26 YM ADD-S POINT作図
      (KP_MakeDummyPoint)
      ;03/07/26 YM ADD-E POINT作図


			;****************************************************************************************
			; 2013/09/11 YM ADD 注釈文字を追加する Errmsg.ini参照
			(NS_AddTableMoji #sTmp);パース図以外商品図,施工図で注釈を出力する1/30基準1/20,1/40は座標変換
			;****************************************************************************************

      (repeat (sslength #xSp)

;;;(makeERR "ﾚｲｱｳﾄ8") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ﾚｲｱｳﾄ8
;;;(WebOutLog "(4)ｴﾗｰ関数="); 02/09/04 YM ADD ﾛｸﾞ出力追加
;;;(WebOutLog *error*); 02/09/04 YM ADD ﾛｸﾞ出力追加

        (setq #eEn (ssname #xSp #iI))
        ;図面タイプ
        (setq #sType (car (CfGetXData #eEn "FRAME")))
        ; 商品ﾀｲﾌﾟ=2(ﾐﾆｷｯﾁﾝ,洗面の側面図---展開B,D---の施工寸法は自動とするため
        (setq CG_sType (car (CfGetXData #eEn "FRAME"))) ; ｸﾞﾛｰﾊﾞﾙ化 02/07/11 YM ADD
        ;展開元図名
        (setq #sMfile (strcat CG_KENMEI_PATH "BLOCK\\" #sType "_" CG_RyoNo ".dwg"))

        (cond
          ; ((= "P" #sType)                ;平面図
          ((and (= "P" #sType) (/= #sView ""))    ;平面図 2000/08/08
            ;展開元図名
            (setq #sMfile (strcat CG_KENMEI_PATH "BLOCK\\" #sType "_" CG_RyoNo ".dwg"))
            (if (findfile #sMfile)
              (SCFDrawPlanLayout   #sMfile #eEn CG_KitType #sView)
            )
          )
          ; ((= "S" (substr #sType 1 1))   ;展開図
          ((and (= "S" (substr #sType 1 1)) (/= #sView ""))   ;展開図 2000/08/08
            ;展開元図名
            (setq #sMfile (strcat CG_KENMEI_PATH "BLOCK\\" #sType "_" CG_RyoNo ".dwg"))
            (if (findfile #sMfile)
              (SCFDrawExpandLayout #sMfile #eEn CG_KitType #sView)
            )
          )
          ((= "D" #sType)                ;仕様図
            ;展開元図名
            (setq #sMfile (strcat CG_KENMEI_PATH "Table.cfg"))
            (if (findfile #sMfile)
              (progn
              (SCFDrawTableLayout  #sMfile #eEn)
              (setq #bTblDrw T)    ; 2000/08/08 HT ADD
              )
            )
          )
        )
        ;シンボル図形削除  ; 2000/09/13 DEBUG用
        (if DelSymEntity
          (DelSymEntity)
        )
        (setq #iI (1+ #iI))
      ) ;_repeat

      ; 商品図出力・施工図出力 OFF かつ 仕様図が作成されていない時、
      ; 図面保存しないようにした。 2000/08/08 HT
      (if (not (and (= #bTblDrw nil) (= #sView "")))
        (progn
          ;姿図配置
          (DispFigure)

          ;P図形を非表示にする
          (SKFSetHidePLayer)

          ;ハッチング更新
          (CFRefreshHatchEnt) ;00/05/09 HN DEL とりあえずコメント化

          ;画層
          ; 119 01/04/08 HN MOD 画層"0_HIDE"の非表示処理を追加
          ;MOD(command "_.-layer" "of" "O_hide" "")
          (command "_.-LAYER" "ON" "O_HIDE" "")

          ;タイトル作図
          (cond
            ((= CG_OUTSHOHINZU #sView) (setq #sTitle "商品図")) ; 2000/09/26 HT MOD ((= "02" #sView) (setq #sTitle "商品図"))
            ((= CG_OUTSEKOUZU  #sView) (setq #sTitle "施工図")) ; 2000/09/26 HT MOD ((= "03" #sView) (setq #sTitle "施工図"))
            ;@@@((= "04" #sView) (setq #sTitle "設備配管図"))
          )
          (SCFMakeTitleText #sTitle)

          ;パージ
          (PurgeBlock)

          ;ZOOM
          (command "_.ZOOM" "A")

          ;00/10/24 SN S-ADD XRECORD登録LISTを事前に作成
          (setq CG_SetXRecord$
            (list
              CG_DBNAME       ; 1.DB名称
              CG_SeriesCode   ; 2.SERIES記号
              CG_BrandCode    ; 3.ブランド記号
              CG_DRSeriCode   ; 4.扉SERIES記号
              CG_DRColCode    ; 5.扉COLOR記号
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

          ;設定があれば後から追加する。
          (if CG_DRSeriCodeRV (setq CG_SetXRecord$ (append CG_SetXRecord$ (list CG_DRSeriCodeRV))))
          (if CG_DRColCodeRV  (setq CG_SetXRecord$ (append CG_SetXRecord$ (list CG_DRColCodeRV ))))
          ;00/10/24 SN E-ADD

          ;00/08/22 SN S-ADD
          ; XRecord"SERI"があれば
          ; SCFLayoutで設定した外部変数の値でXRcord上書き
          (if (CFGetXRecord "SERI")
            (CFSetXRecord "SERI"
              ;00/10/24 SN MOD 事前に作成したLISTを使用する。
              CG_SetXRecord$
              ;(list
              ;  CG_DBNAME       ; 1.DB名称
              ;  CG_SeriesCode   ; 2.SERIES記号
              ;  CG_BrandCode    ; 3.ブランド記号
              ;  CG_DRSeriCode   ; 4.扉SERIES記号
              ;  CG_DRColCode    ; 5.扉COLOR記号
              ;  CG_UpCabHeight  ; 6.取付高さ
              ;  CG_CeilHeight   ; 7.天井高さ
              ;  CG_RoomW        ; 8.間口
              ;  CG_RoomD        ; 9.奥行
              ;  CG_GasType      ;10.ガス種
              ;  CG_ElecType     ;11.電気種
              ;  CG_KikiColor    ;12.機器色
              ;  CG_KekomiCode   ;13.ケコミ飾り
              ;  CG_DRSeriCodeRV ;14.扉SERIES記号 00/10/12 SN ADD
              ;  CG_DRColCodeRV  ;15.扉COLOR記号   00/10/12 SN ADD
              ;)
            )
          ) ;_if
          ;00/08/22 SN E-ADD

          ; 02/03/28 HN S-ADD 図面種類を設定
          (CFSetXRecord "DRAWTYPE" (list #sView))
          ; 02/03/28 HN E-ADD 図面種類を設定

          ;図面保存
;2008/08/09 YM DEL DXF保存対応
          (setq #sFname (strcat CG_KENMEI_PATH "OUTPUT\\" #sTmp "_" CG_RyoNo "_" #sView ".dwg"))

          ;06/06/16 AO MOD 保存形式を2004に変更
          ;(command "_SAVEAS" "2000" #sFname)
          (command "_SAVEAS" CG_DWG_VERSION #sFname)

          ; 02/08/01 YM Web版CADｻｰﾊﾞｰﾓｰﾄﾞ場合分け
          (if (= CG_AUTOMODE 2) ; このままPDF保存
            (progn

              (cond
                ((= "02" CG_ZUMEN_FLG)
                  (if (= "1" CG_SYOHIN_PDF_FLG)
                    (progn ;商品図PDF出力指示あり
                      (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT2) ; 展開図
                      ;2009/10/24 YM ｷｯﾁﾝL型のとき1/40に変更
                      (if (and (= CG_UnitCode "K")(= "L" (substr (nth  5 CG_GLOBAL$) 1 1)))
                        (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT4) ; 展開図
                      );_if

                      ;2008/12/24 YM ADD-S 吊戸画層非表示
                      (command "_.-layer" "of" "O_hide" "")
                      (command "_.-layer" "of" "0_WALL" "")
                      ;2008/12/24 YM ADD-E 吊戸画層非表示
                      (WebPDF_OUTPUT)
                      ;(timer 1)

                      ;2008/09/05 YM ADD 施工図末尾に別紙(きめうちPDF図面)を付ける
                      ;2008/09/17 YM ADD ｷｯﾁﾝ,収納で別紙を分けたい
                      (if (= CG_UnitCode "K")
                        nil ;ｷｯﾁﾝ
                        ;else
                        ;収納商品図
                        (setq #ret (vl-file-copy (strcat CG_TMPAPATH "別紙D.pdf") CG_PDF_SYOUSAI))
                      );_if

                    )
                  );_if

                  (if (= "1" CG_SYOHIN_DWG_FLG)
                    (progn ;ﾊﾟｰｽDWG,dxf出力指示あり
                      ;ﾌｧｲﾙｺﾋﾟｰ
                      (setq #ret (vl-file-copy #sFname CG_DWG_FILENAME))
                      ;dxf出力
                      (command "_saveas" "dxf" "V" CG_DXF_VERSION "16" CG_DXF_FILENAME)
                    )
                  );_if

                )
                ((= "04" CG_ZUMEN_FLG)
                  (if (= "1" CG_SEKOU_PDF_FLG)
                    (progn ;商品図PDF出力指示あり
                      (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT2) ; 展開図
                      ;2009/10/24 YM L型のとき1/40に変更
                      (if (and (= CG_UnitCode "K")(= "L" (substr (nth  5 CG_GLOBAL$) 1 1)))
                        (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT4) ; 展開図
                      );_if

                      ;2008/12/24 YM ADD-S 吊戸画層非表示
                      (command "_.-layer" "of" "O_hide" "")
                      (command "_.-layer" "of" "0_WALL" "")
                      ;2008/12/24 YM ADD-E 吊戸画層非表示
                      (WebPDF_OUTPUT)
                      ;(timer 1)

                      ;2008/09/05 YM ADD 施工図末尾に別紙(きめうちPDF図面)を付ける
                      ;2008/09/17 YM ADD ｷｯﾁﾝ,収納で別紙を分けたい
                      (if (= CG_UnitCode "K")
                        ;ｷｯﾁﾝ施工図
                        (setq #ret (vl-file-copy (strcat CG_TMPAPATH "別紙A.pdf") CG_PDF_SYOUSAI))
                        ;else
;;; 2008/10/01YM@DEL                        (setq #ret (vl-file-copy (strcat CG_TMPAPATH "別紙D.pdf") CG_PDF_SYOUSAI))
                      );_if

                    )
                  );_if

                  (if (= "1" CG_SEKOU_DWG_FLG)
                    (progn ;ﾊﾟｰｽDWG出力指示あり
                      ;ﾌｧｲﾙｺﾋﾟｰ
                      (setq #ret (vl-file-copy #sFname CG_DWG_FILENAME))
                      ;dxf出力
                      (command "_saveas" "dxf" "V" CG_DXF_VERSION "16" CG_DXF_FILENAME)
                    )
                  );_if
                )
              );_cond

            )
          );_if

          ;04/04/14 YM 図面参照しない @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;         (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 3)) ; このまま印刷(ﾌﾟﾗﾝﾆｸﾞｼｰﾄ,DL参照)
          (if (member CG_AUTOMODE '(1 3));2008/08/05 YM MOD
            (progn
              (setq CG_Zumen_Count (1+ CG_Zumen_Count));2枚目=2
              ; *** 2枚目 ***
              (if (= 2 CG_Zumen_Count)
                (progn
                  (if (= CG_ZumenPRINT 1);印刷するかどうかのﾌﾗｸﾞ
                    (progn
                      ; 簡易印刷 立体図
                      (if (CFYesNoDialog "印刷を行いますか？")
                        (progn
                          (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT2) ; 立体図
                          (C:PlainPlot) ; Yes
                        )
                        ;else
                        nil             ; No
                      );_if
                    )
                  );_if
                )
              );_if

              ; *** 3枚目 ***
              (if (= 3 CG_Zumen_Count)
                (progn
                  (if (= CG_ZumenPRINT 1)
                    (progn
                      ; 簡易印刷 展開図
                      (if (CFYesNoDialog "印刷を行いますか？")
                        (progn
                          (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT3)
                          (C:PlainPlot) ; Yes
                        )
                        ;else
                        nil             ; No
                      );_if
                    )
                  );_if
                )
              );_if
            )
          );_if
          ;04/04/14 YM 図面参照しない @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


        ) ;_progn
      ) ;_if
    ) ;_progn
    (progn ; 0_WAKUがない場合　ﾊﾟｰｽ用ﾃﾝﾌﾟﾚｰﾄ或いはﾌﾘｰのﾃﾝﾌﾟﾚｰﾄ

      (setq #xSp (ssget "X" (list (cons 0 "VIEWPORT"))))

      ; ﾋﾞｭｰﾎﾟｰﾄの有無で判断するのは止める
      ; ﾌﾘｰﾊﾟｰｽ挿入ｺﾏﾝﾄﾞのためﾌﾘｰのﾃﾝﾌﾟﾚｰﾄにもﾋﾞｭｰﾎﾟｰﾄを追加
      (if (and (/= nil #xSp)(= nil (tblsearch "layer" "FREE"))) ; 03/01/21 YM MOD
;;;      (if (/= nil #xSp) ; 03/01/21 YM MOD
        (progn ; ﾌﾘｰﾃﾝﾌﾟﾚｰﾄではない
          (setq #bFlg nil)
          (setq #iI 0)
          (repeat (sslength #xSp)
            (if (< 1 (cdr (assoc 69 (entget (ssname #xSp #iI)))))
              (setq #bFlg T)
            )
            (setq #iI (1+ #iI))
          )
          (if (/= nil #bFlg)
            (progn    ; パース図作図
              (setq #sMfile (strcat CG_KENMEI_PATH "BLOCK\\M_0.dwg"))
							;2012/01/17 YM MOD-S
							(if (findfile #sMfile)
								(progn
									;2012/01/28 YM MOD M_1,M_2両方なければ旧関数を通す
									(setq #sM1file (strcat CG_KENMEI_PATH "BLOCK\\M_1.dwg"))
									(setq #sM2file (strcat CG_KENMEI_PATH "BLOCK\\M_2.dwg"))
									(if (and (= (findfile #sM1file) nil)(= (findfile #sM2file) nil))
										(progn ;両方nil ﾊﾟｰｽ矢視P1,P2ともに設定がない
              				(SCFDrawPersLayout #sMfile CG_KitType)
										)
										(progn
											(SCFDrawPersLayout2 CG_KitType)
										)
									);_if
								)
							);_if

							;2012/01/17 YM MOD-E

              ;タイトル作図
              (SCFMakeTitleText "パース図") ;00/05/28 HN DEL とりあえずコメント化

              ;P図形を非表示にする
              (SKFSetHidePLayer)

              ; 01/05/29 HN DEL パース図のハッチング処理を削除
              ;@DEL@;ハッチング更新
              ;@DEL@(CFRefreshHatchEnt)

              ;パージ
;;;              (PurgeBlock)

              ;図面保存
              (setq #sFname (strcat CG_KENMEI_PATH "OUTPUT\\" #sTmp "_" CG_RyoNo "_00.dwg"))

              ;06/06/16 AO MOD 保存形式を2004に変更
              ;(command "_SAVEAS" "2000" #sFname)
;-- 2011/10/06 A.Satoh Mod - S
;;;;;              (command "_SAVEAS" CG_DWG_VERSION #sFname)
              (command "_SAVEAS" CG_DWG_VER_MODEL #sFname)
;-- 2011/10/06 A.Satoh Mod - S

              ;2008/08/11 YM ADD
;;;             (setvar "SDI"  0);複数ファイル可能　これにしないとﾊﾟｰｽ図をdxf出力できない

              ; 02/08/01 YM Web版CADｻｰﾊﾞｰﾓｰﾄﾞ場合分け
              (if (= CG_AUTOMODE 2) ; このままPDF保存 "4"のときJPG出力用ﾊﾟｰｽ作成
                (progn

                  (if (= "1" CG_PERS_PDF_FLG)
                    (progn ;ﾊﾟｰｽPDF出力指示あり
                      (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT1) ; パース図
                      (WebPDF_OUTPUT)
                      ;(timer 1)
                    )
                  );_if

                  (if (or (= "1" CG_PERS_DWG_FLG)
                          (/= "" PB_TEMPLATE_TYPE));2009/02/23 YM ADD 
                    (progn ;ﾊﾟｰｽDWG出力指示あり
                      ;ﾌｧｲﾙｺﾋﾟｰ
                      (setq #ret (vl-file-copy #sFname CG_DWG_FILENAME));ﾌﾟﾚｾﾞﾝCGﾌﾗｸﾞだけのときも実行

                      (if (= "1" CG_PERS_DWG_FLG);dxfはﾌﾗｸﾞありのときのみ
                        (command "_saveas" "dxf" "V" CG_DXF_VERSION "16" CG_DXF_FILENAME)
                      );_if
                    )
                  );_if

                )
              );_if

              ; 03/02/22 YM Web版CADｻｰﾊﾞｰﾓｰﾄﾞ場合分け
              (if (= CG_AUTOMODE 4) ; "4"のときJPG出力用ﾊﾟｰｽ作成
                (WebTIFF_OUTPUT)
              );_if

              (if (= CG_AUTOMODE 5) ; "5"のときﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄJPG出力
                (WebJPG_OUTPUT)
              );_if

              ;04/04/14 YM 図面参照しない @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;             (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 3)) ; このまま印刷(ﾌﾟﾗﾝﾆｸﾞｼｰﾄ,DL参照)
              (if (member CG_AUTOMODE '(1 3));2008/08/05 YM MOD
                (progn
                  (setq CG_Zumen_Count (1+ CG_Zumen_Count));1枚目=1
                  ; *** 1枚目 ***
                  (if (= 1 CG_Zumen_Count)
                    (progn
                      (if (= CG_ZumenPRINT 1)
                        (progn
                          ; 簡易印刷 立体図
                          (if (CFYesNoDialog "印刷を行いますか？")
                            (progn
                              (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT1) ; 立体図
                              (C:PlainPlot) ; Yes
                            )
                            ;else
                            nil             ; No
                          );_if
                        )
                      );_if
                    )
                  );_if
                )
              );_if
              ;04/04/14 YM 図面参照しない @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

            ) ;_progn
            ; 01/05/04 HN S-ADD
            (progn
              ;@DEL@(CFAlertMsg "ﾃﾝﾌﾟﾚｰﾄ図面内に図形表示領域枠が存在しません.") ;01/05/09 HN DEL
              (SCFLayoutFree)
            )
            ; 01/05/04 HN E-ADD
          ) ;_if
        ) ;_progn
        ; 01/05/04 HN S-MOD
        ;@MOD@(CFAlertMsg "ﾃﾝﾌﾟﾚｰﾄ図面内に図形表示領域枠が存在しません.")
        (progn ; ﾌﾘｰﾃﾝﾌﾟﾚｰﾄである
          ;@DEL@(CFAlertMsg "ﾃﾝﾌﾟﾚｰﾄ図面内に図形表示領域枠が存在しません.") ;01/05/09 HN DEL

					;****************************************************************************************
					; 2013/09/11 YM ADD 注釈文字を追加する Errmsg.ini参照
					(NS_AddTableMoji #sTmp);パース図以外商品図施工図で注釈を出力する1/30基準1/20,1/40は座標変換
					;****************************************************************************************

          (SCFLayoutFree)

        )
        ; 01/05/04 HN E-MOD
      ) ;_if
    ) ;_progn
  ) ;_if
  ; 01/05/22 HN S-MOD 複数図面対応
  ;@MOD@(setq CG_PatNo (1+ CG_PatNo))
  (if (= nil CG_LayoutFreeContinue)
    (setq CG_PatNo (1+ CG_PatNo))
  )
  ; 01/05/22 HN S-MOD 複数図面対応
  (setq #sTmp  (car  (nth CG_PatNo CG_Pattern)))   ;ﾃﾝﾌﾟﾚｰﾄﾌｧｲﾙ名
  (if (and (/= nil #sTmp)(findfile (strcat CG_TMPPATH #sTmp ".dwt")))
    (progn

      ; 01/10/02 YM MOD-S 自動ﾓｰﾄﾞではSCFCmnFileOpenが効かない;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
;;;     (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"追加 03/02/22 JPGﾚｲｱｳﾄﾓｰﾄﾞ
      (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
        (progn
;-- 2011/10/06 A.Satoh Mod - S
;;;;;          (command ".qsave")
          (setq #sFname2 (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
          (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
                  (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
            (setq #ver CG_DWG_VER_MODEL)
            (setq #ver CG_DWG_VER_SEKOU)
          )
(princ #sFname2)
          (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/06 A.Satoh Mod - E

          (command "_.Open" (strcat CG_TMPPATH #sTmp ".dwt")) ; D:\\WORKS\\NAS\\BUKKEN\\NPS0003\\05\\MODEL.DWG"

          (S::STARTUP)
        )
        (SCFCmnFileOpen (strcat CG_TMPPATH #sTmp ".dwt") 0) ; 2000/10/19 HT 関数化
      );_if
      ; 01/10/02 YM MOD-E 自動ﾓｰﾄﾞではSCFCmnFileOpenが効かない

    )
    (progn
      ; これ以上開くテンプレートがないので、コマンドを終了させる。
      (setq CG_OpenMode nil)

      ;図面の保存
;;;      (CFQSave)

      ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞではSCFCmnFileOpenが効かない;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
;;;     (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"追加 03/02/22 JPGﾚｲｱｳﾄﾓｰﾄﾞ
      (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
        (progn
          (setq #fType  (strcase (vl-filename-extension (getvar "DWGNAME"))))
          (cond
            ((= #fType ".DXF")
              (command "_SAVEAS" "DXF" "V" CG_DXF_VERSION "16" (strcat CG_KENMEI_PATH "OUTPUT\\" (getvar "dwgname")));2008/08/11 YM MOD
            )
            ((= #fType ".DWG")
;-- 2011/10/06 A.Satoh Mod - S
;;;;;              (command "_SAVEAS" CG_DWG_VERSION (strcat CG_KENMEI_PATH "OUTPUT\\" (getvar "dwgname")));2008/08/11 YM MOD
              (progn
                (setq #sFname2 (strcat CG_KENMEI_PATH "OUTPUT\\" (getvar "DWGNAME")))
                (if (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME"))
                  (setq #ver CG_DWG_VER_MODEL)
                  (setq #ver CG_DWG_VER_SEKOU)
                )
(princ #sFname2)
                (command "_.SAVEAS" #ver #sFName2)
              )
;-- 2011/10/06 A.Satoh Mod - E
            )
          );_cond

;;;         (command ".qsave");2008/08/11 YM MOD

          (command "_.Open" CG_DwgName) ; D:\\WORKS\\NAS\\BUKKEN\\NPS0003\\05\\MODEL.DWG"
          (S::STARTUP)
        )

        (SCFCmnFileOpen CG_DwgName 1)
      );_if

    )
  )

;;;(makeERR "ﾚｲｱｳﾄ12") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ﾚｲｱｳﾄ12

  (princ)
) ; SCFLayoutDrawBefore

;;;<HOM>************************************************************************
;;; <関数名>  : CFQSave
;;; <処理概要>: 拡張 QSave
;;; <戻り値>  : なし
;;; <改訂>    : 04/11/30
;;; <備考>    : 通常の(command "_.QSAVE")だけでは、図面保存時に確認が必要と
;;;             なるケースがあるため、オプションの入力なしに保存できるように改良
;;;             （DWG の Qsave の後に DXFの Qsave を実行したときなど）
;;;************************************************************************>MOH<
(defun CFQSave (
  /
  #fType
  )
  (setq #fType  (strcase (vl-filename-extension (getvar "DWGNAME"))))

  (command "_.QSAVE")
  (if (wcmatch (getvar "CMDNAMES") "*QSAVE*")
    (cond
      ((= #fType ".DXF")
        (command "DXF" "V" CG_DXF_VERSION "16" "")
      )
      (T
        (command CG_DWG_VERSION "")
      )
    )
  )
  (princ)
);CFQSave

;<HOM>*************************************************************************
; <関数名>    : SCFSaveOutputFileType
; <処理概要>  : ＯＵＴＰＵＴ図面を保存する
; <戻り値>    : なし
; <備考>      : CG_SAVE_OUTPUT_FILE_TYPE の図面種類によって保存形式を変更する
;*************************************************************************>MOH<
(defun SCFSaveOutputFileType (
  &sFname
  )
  (cond
    ((= CG_SAVE_OUTPUT_FILE_TYPE "DXF")
;;;      (command "_SAVEAS" "DXF" "V" "2004" "16" &sFname)
      (command "_saveas" "dxf" "V" CG_DXF_VERSION "16" CG_DXF_FILENAME)
    )
    (T
      (command "_SAVEAS" CG_DWG_VERSION &sFname)
    )
  )
)
;SCFSaveOutputFileType

;;;<HOM>************************************************************************
;;; <関数名>  : CHG_TENBAN_LAYER
;;; <処理概要>: 天板画層変更処理(天板の画層が"0"になって寸法がうまく出ない)
;;; <戻り値>  : なし
;;; <備考>    : 2015/05/20 YM ADD
;;;************************************************************************>MOH<
(defun CHG_TENBAN_LAYER(
  &ss
  &lay
  /
	#EEN #EG$ #I #SWT$
  )
  (setq #i 0)
  (repeat (sslength &ss)
    (setq #eEn (ssname &ss #i))
		(setq #sWT$ (CfGetXData #eEn "G_WRKT"))
		(if #sWT$ ;天板だった
			(progn
				;画層の変更
				(setq #eg$ (entget #eEn))
				(entmod (subst (cons 8 &lay) (assoc 8 #eg$) #eg$))
			)
		);_if
    (setq #i (1+ #i))
  );repeat
	(princ)
);CHG_TENBAN_LAYER

;;;<HOM>************************************************************************
;;; <関数名>  : SCFDrawPlanLayout
;;; <処理概要>: レイアウト図作成  平面図
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SCFDrawPlanLayout
  (
  &sMfile     ; 展開元図ファイル名
  &eEn        ; 領域図形名
  &sType      ; キッチンタイプ
  &SCFind     ; 図面種類
  /
  #high #zmove #xSp #iI #eEn #sName #eEx #Del$ #xSe #layer #Pt$ #dMin #dMax #dVm
  #sHnd       ; 挿入直後の図形ハンドル
  #d1         ; ﾌﾘｰ配置の範囲1点目
  #d2         ; ﾌﾘｰ配置の範囲2点目
  #psLast     ; 本関数内で作成した図形選択セット
  #sGroup     ; グループ名
	#ss
  )
  (princ "\n SCFDrawPlanLayout ")

  
  (setq #high  0.01)          ; 隠線領域及び単一プリミティブの押し出し高さ
  (setq #zmove 5000)          ; 断面指定図形及びバルーン文字のZ座標移動量

  ;01/05/04 HN S-ADD
  ;@TEST@(if (= nil &eEn)
  ;@TEST@  (progn
  ;@TEST@    (setq #d1 (getpoint "\n1点目:"))
  ;@TEST@    (setq #d2 (getcorner #d1 "\n2点目:"))
  ;@TEST@    (command "_.RECTANG" #d1 #d2)
  ;@TEST@    (setq &eEn (entlast))
  ;@TEST@  )
  ;@TEST@)
  ;01/05/04 HN E-ADD

  ;展開元図挿入
  ; 01/05/04 HN S-MOD 領域図形の判定を追加
  ;@MOD@(command "_.INSERT" &sMfile "0,0" "1" "1" "0")
  (if &eEn
    (progn
      (command "_.INSERT" &sMfile "0,0" 1 1 "0")
    )
    (progn
      (prompt "\n挿入位置を指定: ")
      (command "_.regenall")
      (command "_.INSERT" &sMfile PAUSE 1 1 "0")
    )
  );_if
  ; 01/05/04 HN E-MOD 領域図形の判定を追加
  (setq #sHnd (cdr (assoc 5 (entget (entlast))))) ; 01/05/09 HN ADD
  (command "_.EXPLODE" (entlast))
  ;必要な図面種類を獲得
  (setq #xSp (ssget "P"))

  (setq #iI 0)
  (repeat (sslength #xSp)
    (setq #eEn (ssname #xSp #iI))
    (setq #sName (cdr (assoc 2 (entget #eEn))))
    (if (equal (substr #sName 2) &SCFind)
      (setq #eEx #eEn)
      (setq #Del$ (cons #eEn #Del$))
    )
    (setq #iI (1+ #iI))
  )
  (mapcar 'entdel #Del$)
  (command "_.EXPLODE" #eEx)
  (setq #xSe (ssget "P"))

	;2015/05/20 YM ADD 天板画層変更処理(天板の画層が"0"になって寸法がうまく出ない)
	(CHG_TENBAN_LAYER #xSe "0_PLANE")

  (if (/= nil #xSe)
    (progn
			; 2017/09/14 KY ADD-S
			; フレームキッチン対応
			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
				(progn
					(setq #ss (ssget "X" '((-3 ("G_DEL")))))
					(if #ss
						(progn
							(command "_.ERASE" #ss "")
							(setq #ss nil)
						);progn
					);if
				);progn
			);if
			; 2017/09/14 KY ADD-E

      ;画層獲得
      (setq #layer "0_PLANE")
      (if &eEn      ; 01/05/04 HN ADD 領域図形の判定を追加
        (progn
          ;領域中心位置獲得
          (setq #Pt$  (mapcar 'car (get_allpt_H &eEn)))
          (setq #dMin (list (apply 'min (mapcar 'car #Pt$)) (apply 'min (mapcar 'cadr #Pt$))))
          (setq #dMax (list (apply 'max (mapcar 'car #Pt$)) (apply 'max (mapcar 'cadr #Pt$))))
          (setq #dVm  (mapcar '* '(0.5 0.5 1.0) (mapcar '+ #dMin #dMax)))
          ;図面移動
          (SCFMoveEntityLimmid #dVm #xSe #layer "P")
        )
      )             ; 01/05/04 HN ADD 領域図形の判定を追加

      ; 01/05/24 HN ADD 寸法線の角度と高さの変更処理を追加
      ; (SCFMoveEntityLimmid)内より関数化して移動
      (KCFChgDimAngHigh #xSe)

      ;隠線領域及び単一面プリミティブをソリッド化する
      (SCFPlanePmenTanSlid #xSe #high)
      ;バルーン作成
      ; 01/12/06 HN MOD 定数をグローバル化
      ;@MOD@(DrawBaloon #xSe #layer 15000)
      (DrawBaloon #xSe #layer CG_LAYOUT_DIM_Z)
      ;寸法線作図
      ; 2000/07/10 商品図 施工図の図面種類を引数に増やした
      ; (SCFDrawDimensionPl CG_DimPat)

;;;02/07/22YM@DEL     (SCFDrawDimensionPl CG_DimPat &SCFind)

      ; 02/07/22 YM ADD-S
      (if CG_PLANE_DIM
        nil ; 寸法を引かない
        (SCFDrawDimensionPl CG_DimPat &SCFind)
      );_if
      ; 02/07/22 YM ADD-E

      ; 01/05/06 HN S-ADD 展開図元図と寸法線のグループ化処理を追加
      (setq #psLast (SCFGetEntsLast #sHnd))

      (setq #sGroup "0_PLANE")
      ; 02/01/22 HN ADD グループ名称のチェック処理を追加
      (setq #sGroup (SCFGetGroupName #sGroup))
      (command
        "-GROUP"    ; オブジェクト グループ設定
        "C"         ; 作成
        #sGroup     ; グループ名
        #sGroup     ; グループ明

        #psLast     ; オブジェクト
        ""
      )
      ; 01/05/06 HN E-ADD 展開図元図と寸法線のグループ化処理を追加
    )
  ) ;_if

  (princ)
) ;_SCFDrawPlanLayout

;;;<HOM>************************************************************************
;;; <関数名>  : SCFDrawExpandLayout
;;; <処理概要>: レイアウト図作成  展開図
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SCFDrawExpandLayout
  (
  &sMfile     ; 展開元図ファイル名
  &eEn        ; 領域図形名
  &sType      ; キッチンタイプ
  &SCFind     ; 図面種類
  /
  #high #zmove #xSp #iI #eEn #sName #sView #eEx #Del$ #xSe #Pt$ #dMin #dMax #dVm
  #LAYER
  #sHnd       ; 挿入直後の図形ハンドル
  #d1         ; 自由配置の範囲1点目  ※未使用
  #d2         ; 自由配置の範囲2点目  ※未使用
  #psLast     ; 本関数内で作成した図形選択セット
  #sGroup     ; グループ名
	#ss
  )
  (setq #high  0.01)          ; 隠線領域及び単一プリミティブの押し出し高さ
  (setq #zmove 5000)          ; 断面指定図形及びバルーン文字のZ座標移動量

  ;01/05/04 HN S-ADD
  ;@TEST@(if (= nil &eEn)
  ;@TEST@  (progn
  ;@TEST@    (setq #d1 (getpoint "\n1点目:"))
  ;@TEST@    (setq #d2 (getcorner #d1 "\n2点目:"))
  ;@TEST@    (command "_.RECTANG" #d1 #d2)
  ;@TEST@    (setq &eEn (entlast))
  ;@TEST@  )
  ;@TEST@)
  ;01/05/04 HN E-ADD

  ;展開元図挿入
(princ "\n挿入前★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★")
  ; 01/05/04 HN S-MOD 領域図形の判定を追加
  ;@MOD@(command "_.INSERT" &sMfile "0,0" "1" "1" "0")
  (if &eEn
    (progn
;;;      (command "_.INSERT" &sMfile "0,0" 1 1 "0");2020/03/13 YM MOD
      (command "_.INSERT" &sMfile '(0 0 0) 1 1 0) ;2020/03/13 YM MOD
    )
    (progn
      (prompt "\n挿入位置を指定: ")

(princ "\n挿入直前　★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★")

;;;      (command "_.INSERT" &sMfile PAUSE 1 1 "0")
      (command "_.INSERT" &sMfile PAUSE 1 1 0)

(princ "\n挿入後　　★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★")

    )
  )
  ; 01/05/04 HN E-MOD 領域図形の判定を追加
  (setq #sHnd (cdr (assoc 5 (entget (entlast))))) ; 01/05/09 HN ADD
  (command "_.EXPLODE" (entlast))
  ;必要な図面種類を獲得
  (setq #xSp (ssget "P"))

  (setq #iI 0)
  (repeat (sslength #xSp)
    (setq #eEn (ssname #xSp #iI))
    (setq #sName (cdr (assoc 2 (entget #eEn))))
    (if (equal (substr #sName 2) &SCFind)
      (progn
        (setq #sView (substr #sName 1 1))
        (setq #eEx #eEn)
      )
      (setq #Del$ (cons #eEn #Del$))
    )
    (setq #iI (1+ #iI))
  )
  (mapcar 'entdel #Del$)
  (command "_.EXPLODE" #eEx)
  (setq #xSe (ssget "P"))

	;2015/05/20 YM ADD 天板画層変更処理(天板の画層が"0"になって寸法がうまく出ない)
;;;	(setq #TENKAI (substr str (- (strlen &sMfile) 6) 1));"D"など
;;;	(cond
;;;		((= #TENKAI "A")
;;;		 	(setq #TENKAI_LAYER "")

	(CHG_TENBAN_LAYER #xSe (strcat "0_SIDE_" #sView))

  (if (/= nil #xSe)
    (progn
			; 2017/09/20 KY ADD-S
			; フレームキッチン対応
			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
				(if (or (= #sView "B") (= #sView "D")) ; 展開B図と展開D図は側面のためコピーした図形を先に削除する
					(progn
						(setq #ss (ssget "X" '((-3 ("G_DEL")))))
						(if #ss
							(progn
								(command "_.ERASE" #ss "")
								(setq #ss nil)
							);progn
						);if
					);progn
				);if
			);if
			; 2017/09/20 KY ADD-E
      ;画層獲得
      (setq #layer (strcat "0_SIDE_" #sView))
      (if &eEn      ; 01/05/04 HN ADD 領域図形の判定を追加
        (progn
          ;領域の中心を獲得
          (setq #Pt$  (mapcar 'car (get_allpt_H &eEn)))
          (setq #dMin (list (apply 'min (mapcar 'car #Pt$)) (apply 'min (mapcar 'cadr #Pt$))))
          (setq #dMax (list (apply 'max (mapcar 'car #Pt$)) (apply 'max (mapcar 'cadr #Pt$))))
          (setq #dVm  (mapcar '* '(0.5 0.5 1.0) (mapcar '+ #dMin #dMax)))
          ;図面移動
          (SCFMoveEntityLimmid #dVm #xSe #layer #sView)
        )
      )             ; 01/05/04 HN ADD 領域図形の判定を追加

      ; 01/05/24 HN ADD 寸法線の角度と高さの変更処理を追加
      ; (SCFMoveEntityLimmid)内より関数化して移動
      (KCFChgDimAngHigh #xSe)

      ;隠線領域及び単一面プリミティブをソリッド化する
      (SCFPlanePmenTanSlid #xSe #high)
      ;バルーン作成
      ; 01/12/06 HN MOD 定数をグローバル化
      ;@MOD@(DrawBaloon #xSe #layer 15000)
      (DrawBaloon #xSe #layer CG_LAYOUT_DIM_Z)
      ;寸法線作図
      ; 2000/07/04 商品図 施工図の図面種類を引数に増やした
      ; SCFDrawDimensionEx #sView CG_DimPat)
      (SCFDrawDimensionEx #sView CG_DimPat &SCFind)

			; 2017/09/14 KY ADD-S
			; フレームキッチン対応
			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
				(progn
					(setq #ss (ssget "X" '((-3 ("G_DEL")))))
					(if #ss
						(progn
							(command "_.ERASE" #ss "")
							(setq #ss nil)
						);progn
					);if
				);progn
			);if
			; 2017/09/14 KY ADD-E

      ; 01/05/06 HN S-ADD 展開図元図と寸法線のグループ化処理を追加
      (setq #psLast (SCFGetEntsLast #sHnd))

      (setq #sGroup (strcat "0_SIDE_" #sView))
      ; 02/01/22 HN ADD グループ名称のチェック処理を追加
      (setq #sGroup (SCFGetGroupName #sGroup))
      (command
        "-GROUP"    ; オブジェクト グループ設定
        "C"         ; 作成
        #sGroup     ; グループ名
        #sGroup     ; グループ説明
        #psLast     ; オブジェクト
        ""
      )
      ; 01/05/06 HN E-ADD 展開図元図と寸法線のグループ化処理を追加
    )
  )

  (princ)
) ;_SCFDrawExpandLayout

;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetWakuScale
;;; <処理概要>: 図面枠の表題文字高さから尺度を求める
;;; <戻り値>  : 尺度
;;; <備考>    : なし
;;;************************************************************************>MOH<

(defun SCFGetWakuScale (
  /
  #xSs
  #iScale
  #Eg$
  #dTxtSize
  #ii
)

  (if (= nil (setq #xSs (ssget "X" (list '(-4 . "<AND")
                               (cons '8 "0_TITLET")
                               (cons '0 "TEXT")
                               '(-4 . "AND>")))))
    (progn
    (princ "表題項目の文字高さを取得できません.尺度を30として仕様図を挿入します.")
    (setq #iScale 30)
    )
    (progn
    (setq #ii 0)

    (repeat (sslength #xSs)
      (setq #Eg$ (entget (ssname #xSs #ii)))
      (if (= (substr (cdr (assoc '1 #Eg$)) 1 2) CG_LayTitleTag)
        (progn
        (setq #dTxtSize (cdr (assoc '40 #Eg$)))
        )
      )
      (setq #ii (1+ #ii))
    )
    (setq #iScale (/ #dTxtSize CG_LayTitleH))
    )
  )
#iScale
)


;<HOM>************************************************************************
; <関数名>  : SCFMoveEntityLimmid
; <処理概要>: 図形を図面枠の中心に移動
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<

(defun SCFMoveEntityLimmid (
  &viewmid    ; (LIST)     図面領域の中心点
  &sspln      ; (PICKSET)  図形の選択エンティティ
  &layer      ; (STR)      移動図形の画層名
  &ztype      ; (STR)      図面タイプ
  /
  #ss #ss$ #ext$ #extmin #extmax #minmax #sym$ #pt$ #edl$
  #eds$ #spt #h #pth #extmid #viewmid #i #en
#orthomode #osmode ;-- 2012/03/07 A.Satoh ADD 側面図のズレ対応
  )

;-- 2012/03/07 A.Satoh ADD-S 側面図のズレ対応
  ; 直行モードの設定
	(setq #orthomode (getvar "ORTHOMODE"))
	(setvar "ORTHOMODE" 0)
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
;-- 2012/03/07 A.Satoh ADD-E 側面図のズレ対応

  ; キッチン ダイニング別に図形を分ける
  (setq #ss$ (DivSymByLayoutEx &layer))
  (if (= "P" &ztype)
    ; 図面種類が平面の時
    ; ウオールキャビネットとフロアキャビネットの両方がない時、
    ; (0, 0)位置
    (progn
      (setq #ext$ (GetRangePlane #ss$))
      (setq #extmin (car  #ext$))
      (setq #extmax (cadr #ext$))
    )
    (progn
      (if (/= nil #ss$)
        ; 移動図形の選択セットが取得されている場合
        (progn
          (setq #ext$ (GetRangeUpBas #ss$))
          ; 01/04/05 TM MOD-S ベースまたはアッパー図形がない場合の処理を変更
          (if (or (car #ext$) (cadr #ext$))
            ; ベース図形またはアッパー図形が存在する場合
            (progn
              (setq #tmp$ '())
              ; ベース図形がある場合
              (if (car #ext$)
                (setq #tmp$ (append #tmp$ (car #ext$)))
                ; 01/04/05 ADD 図形がない場合も境界を一定の位置(0,0) に設定する
                (progn
                  (if (/= nil (cadr #ext$))
                    (setq #tmp$ (append #tmp$ (list (list (car (car (cadr #ext$))) 0)
                                                    (list (car (cadr (cadr #ext$))) 0))))
                  )
                )
              )
;-- 2012/03/05 A.Satoh Mod 側面図のズレ解消 - S
;;;;;              ; アッパー図形がある場合
;;;;;              (if (cadr #ext$)
;;;;;                (setq #tmp$ (append #tmp$ (cadr #ext$)))
;;;;;                ; 01/04/05 ADD 図形がない場合も境界を一定の位置（0, 天井高さ）に設定する
;;;;;                (setq #tmp$ (append #tmp$ (list (list (car (car (car #ext$))) CG_CeilHeight)
;;;;;                                                (list (car (cadr (car #ext$))) CG_CeilHeight))))
;;;;;              )
;-- 2012/03/30 A.Satoh Mod 商品図作成エラー - S
;;;;;							(setq #tmp$ (append #tmp$ (list (list (car (car (car #ext$))) CG_CeilHeight)
;;;;;
;;;;;																					(list (car (cadr (car #ext$))) CG_CeilHeight))))
							(if (cadr #ext$)
								(progn
									(setq #tmp$ (append #tmp$ (list (list (car (car (cadr #ext$))) CG_CeilHeight)
																									(list (car (cadr (cadr #ext$))) CG_CeilHeight))))
								)
								(progn
									(if (car #ext$)
										(setq #tmp$ (append #tmp$ (list (list (car (car (car #ext$))) CG_CeilHeight)
																										(list (car (cadr (car #ext$))) CG_CeilHeight))))
										(setq #tmp$ (append #tmp$ (list (list 0 CG_CeilHeight) (list 0 CG_CeilHeight))))
									)
								)
							)
;-- 2012/03/30 A.Satoh Mod 商品図作成エラー - E
;-- 2012/03/05 A.Satoh Mod 側面図のズレ解消 - E
              (setq #ext$ #tmp$)
            )
          )
          ; 01/04/05 TM MOD-S ベースまたはアッパー図形がない場合の処理を変更
          ;(setq #ext$ (apply 'append #ext$))
          (setq #minmax (GetPtMinMax #ext$))
          (setq #extmin (car  #minmax))
          (setq #extmax (cadr #minmax))
        )
        ; いない場合
        (progn
          (setq #ss (ssget "X" (list (list -3 (list "G_SKDM")) (cons 8 &layer))))
          (setq #sym$ (SCF_B_GetSym #ss))
          (if (/= (car #sym$) nil)
            (progn
              ;(setq #pt$ (Get2PointByLay (car #sym$)))
              (setq #pt$ (Get2PointByLay (car #sym$) 1))
              (setq #edl$ (CfGetXData (car #sym$) "G_LSYM"))
              (setq #eds$ (CfGetXData (car #sym$) "G_SYM"))
              (setq #spt  (cdrassoc 10 (entget (car #sym$))))
              (setq #h    (nth 5 #eds$))
              (if (= 1 (nth 9  #eds$))
                (setq #pth (polar #spt (* 0.5 PI) #h))
                (setq #pth (polar #spt (* 1.5 PI) #h))
              )
              (setq #pt$ (cons #pth #pt$))
            )
          )
          (if (/= (caadr #sym$) nil)
            (progn
              ;(setq #pt$ (append #pt$ (Get2PointByLay (cadr #sym$))))
              (setq #pt$ (append #pt$ (Get2PointByLay (cadr #sym$) 1)))
              ; 2000/06/11 HT 暫定対応  アッパーは複数取得できるが１個めを使う
        ;   (setq #edl$ (CfGetXData (cadr #sym$) "G_LSYM"))
              ;(setq #eds$ (CfGetXData (cadr #sym$) "G_SYM"))
              ;(setq #eds$ (CfGetXData (car(cadr #sym$)) "G_SYM"))
              ; 2000/06/20 HT アッパーは複数取得できるので、すべての高さで比較する(06/11の暫定対応解決)
              (mapcar '(lambda (#ss2)
                (setq #eds$ (CfGetXData #ss2 "G_SYM"))
                (setq #spt  (cdrassoc 10 (entget (car(cadr #sym$)))))
                (setq #h    (nth 5 #eds$))
                (if (= 1 (nth 9  #eds$))
                  (setq #pth (polar #spt (* 0.5 PI) #h))
                  (setq #pth (polar #spt (* 1.5 PI) #h))
                )
                (setq #pt$ (cons #pth #pt$))
                )
                (cadr #sym$)
              ) ;mapcar
            )
          )

          (setq #minmax (GetPtMinMax #pt$))
          (setq #extmin (car  #minmax))
          (setq #extmax (cadr #minmax))
        )
      )
    )
  )

  (setq #extmid (mapcar '+ #extmin (mapcar '* (list 0.5 0.5) (mapcar '- #extmax #extmin))))

  ;平面図図形の移動
  (setq #extmid  (list (car #extmid)  (cadr #extmid)))
  (setq #viewmid (list (car &viewmid) (cadr &viewmid)))
  (command "_move" &sspln "" #extmid #viewmid)

  ; 01/05/24 HN S-DEL 関数化(KCFChgDimAngHigh)して本関数の外へ
  ;@DEL@;寸法線があれば回転角度を０にする
  ;@DEL@;寸法線があれば高さを10000にする
  ;@DEL@(setq #i 0)
  ;@DEL@(repeat (sslength &sspln)
  ;@DEL@  (setq #en (ssname &sspln #i))
  ;@DEL@  (if (equal "DIMENSION" (cdr (assoc 0 (entget #en))))
  ;@DEL@    (progn
  ;@DEL@      (SCFEntmodFindDimension #en)
  ;@DEL@      (princ)
  ;@DEL@    )
  ;@DEL@  )
  ;@DEL@  (setq #i (1+ #i))
  ;@DEL@)
  ; 01/05/24 HN E-DEL 関数化(KCFChgDimAngHigh)して本関数の外へ

;-- 2012/03/07 A.Satoh ADD-S 側面図のズレ対応
  ; 直行モードを戻す
	(setvar "ORTHOMODE" #orthomode)
	(setvar "OSMODE" #osmode)
;-- 2012/03/07 A.Satoh ADD-E 側面図のズレ対応

  (princ)
) ; SCFMoveEntityLimmid

;<HOM>************************************************************************
; <関数名>  : SCFEntmodFindDimension
; <処理概要>: 各展開図に既存の寸法図形をワールド座標系で表示する
; <戻り値>  : なし
; <備考>    : 高さを15000にする
;************************************************************************>MOH<

(defun SCFEntmodFindDimension (
  &en         ; (ENAME)    既存の寸法図形名
  /
  #eg #subst #no #pt #pt_n
  )
  (setq #eg (entget &en '("*")))
  ; 回転角度
  (if (assoc 51 #eg)
    (setq #subst (subst (cons 51 0.0) (assoc 51 #eg) #eg))
    (setq #subst (append #eg (list (cons 51 0.0))))
  )

  ;押し出し方向
  (setq #subst (subst (cons 210 '(0.0 0.0 1.0)) (assoc 210 #subst) #subst))

  ;コメントアウト00/03/14
  ;高さを15000にする
;  (mapcar
;   '(lambda ( #no )
;      (setq #pt (cdrassoc #no #subst))
;      (if (/= nil #pt)
;        (progn
;          (setq #pt_n (list (car #pt) (cadr #pt) 15000.0))
;          (setq #subst (subst (cons #no #pt_n) (assoc #no #subst) #subst))
;        )
;      )
;    )
;   '(10 11 12 13 14)
;  )
  ; 図形更新
  (entmod #subst)

  ; 01/01/30 HN DEL 寸法線の分解処理を削除
  ;DEL;既存の寸法は隠線対応するように文字に厚みを加える 99/0423 S.Kawamoto
  ;DEL(SCFSetThickDimText &en)

  (princ)
) ; SCFEntmodFindDimension


;<HOM>************************************************************************
; <関数名>  : SCFSetThickDimText
; <処理概要>: 寸法線を分解し、含まれる文字に厚みをつける。（隠線用）
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<

(defun SCFSetThickDimText (
  &en
  /
  #ss #i #eg #en
  )
  (command "_explode" &en)
  (setq #ss (ssget "P"))
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i))
    (setq #eg (entget #en))
    (if (= "MTEXT" (cdr (assoc 0 #eg)))
      (progn
        (command "_explode" (ssname #ss #i))
        (setq #en (ssname (ssget "P") 0))
        (command "_change" #en "" "P" "T" 1 "")
      )
      (progn
        (command "_change" #en "" "P" "C" "CYAN" "")
      )
    )
    (setq #i (1+ #i))
  )
) ; SCFSetThickDimText


;<HOM>************************************************************************
; <関数名>  : SCFPlanePmenTanSlid
; <処理概要>: 隠線領域及び単一面ﾌﾟﾘﾐﾃｨﾌﾞをｿﾘｯﾄﾞ化する
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<

(defun SCFPlanePmenTanSlid (
  &sspln      ; (PICKSET)対象図形の選択ｴﾝﾃｨﾃｨ
  &high       ; (REAL)   押し出し高さ
  /
  ##CopyExtrude #i #en #eed$
  )
  ;図形押し出し
  ;   +==================================================================+
  ;   |   図形を押し出しすると別図形になるので画層、色、線種がそれぞれ   |
  ;   |   "0","BYLAYER","BYLAYER"に変わってしまう                        |
  ;   |   そのため元の属性に再設定してやらなくてはいけない               |
  ;   +==================================================================+
  (defun ##CopyExtrude (
    &en   ; (ENAME) 押し出す図形名
    &high ; (REAL)  押し出す高さ
    /
    #eg #8 #6 #62 #exen #exeg #subst
    )
    (setq #eg (entget #en '("*")))
    (setq #8  (cdr (assoc 8  #eg)))
    (setq #6  (cdr (assoc 6  #eg)))
    (setq #62 (cdr (assoc 62 #eg)))
    (if (= nil #62)
      (setq #62 256)
    )
    (entmake #eg)
    (setq #exen (entlast))
    ;押し出し
;;;    (command "_extrude" #exen "" &high "0");2008/08/06 YM ADD
    (command "_extrude" #exen "" &high );2008/08/06 YM ADD
    (setq #exen (entlast))
    (setq #exeg (entget #exen))
    ;; 隠線領域は非表示とする
    (setq #subst (subst (cons 8 "O_HIDE")(assoc 8 #exeg)#exeg))
    ;線種変更
    (if (/= nil #6)
      (if (assoc 6 #exeg)
        (setq #subst (subst (cons 6 #6)(assoc 6 #subst)#subst))
        (setq #subst (append #subst (list (cons 6 #6))))
      )
    )
    ;色変更
    (if (assoc 62 #exeg)
      (setq #subst (subst (cons 62 #62)(assoc 62 #subst)#subst))
      (setq #subst (append #subst (list (cons 62 #62))))
    )
    (entmod #subst)
  )

  (setq #i 0)
  (repeat (sslength &sspln)
    (setq #en (ssname &sspln #i))
    (setq #eed$ (cdr (assoc -3 (entget #en '("*")))))
    (if (and (/= nil #eed$) (listp #eed$))
      (cond
        ((assoc "G_PMEN" #eed$)
          (setq #eed$ (assoc "G_PMEN" #eed$))
          (if (= 1 (cdr (nth 1 #eed$)))
            (##CopyExtrude #en &high)
          )
        )
        ((assoc "G_PRIM" #eed$)
          (setq #eed$ (assoc "G_PRIM" #eed$))
          (if (and (= 3 (cdr (nth 1 #eed$))) (= 1 (cdr (nth 4 #eed$))))
            (##CopyExtrude #en &high)
          )
        )
        (T     nil)
      )
    )
    (setq #i (1+ #i))
  )

  (princ) ; return
) ; SCFPlanePmenTanSlid


;;;<HOM>************************************************************************
;;; <関数名>  : SCFMakeTitleText
;;; <処理概要>: 図面枠のタイトルを作図する
;;; <戻り値>  : なし
;;; <備考>    : 画層"0_TITLET"の文字図形を検索して変更します。
;;;             01/11/30 HN 全面改訂 無駄な変数と処理をバッサリ削除
;;;             02/03/17 HN <NAS>施工店と構成備考を追加
;;;************************************************************************>MOH<
(defun SCFMakeTitleText
  (
  &sTitle     ; 図面枠用タイトル  "商品図"／"施工図"／"パース図"  ★未使用★
  /
  #sTitle$    ; タイトル文字列情報
  #sTitle$$   ; キー文字列とタイトル文字列の情報
  #iCnt       ; カウンタ
  #psTitle    ; 図面内のタイトル文字図形の選択セット
  #ent$       ; 図形情報
  #sKey$      ; キー文字列
  #sKey       ; キー文字列
  #sTitle     ; タイトル文字列
#plan_name ;2010/12/13 YM ADD
  )
  ; タイトル文字列獲得
  (setq #sTitle$ CG_TitleStr)

;2010/12/10 YM MOD-S
;;; (setq CG_TitleStr 
;;;   (list
;;;     "★物件名称★" (0)
;;;     "★プラン番号★"
;;;     "★プラン名称★"<===追加(2)
;;;     "★追番★"
;;;     "★営業所名★"   (3)-->(4)
;;;     "★営業担当★"   (4)-->(5)
;;;     "★見積担当★"   (5)-->(6)
;;;     "★バージョン★" (6)-->(7)

  ;2010/12/13 YM ADD-S
  (setq #plan_name (nth  2 #sTitle$))
  (if (= nil #plan_name)(setq #plan_name ""))
  ;2010/12/13 YM ADD-E

  (setq #sTitle$$
    (list
      (list "T^作成日"        (menucmd "M=$(edtime,$(getvar,date),YYYY.MO.DD)"));★★★作成日
      (list "T^図番"          (strcat (nth  1 #sTitle$)(nth  3 #sTitle$)))      ; ★プラン番号★&★追番★
      (list "T^物件名称"      (strcat (nth  0 #sTitle$) "／" #plan_name) )      ;★★★物件名称
      (list "T^プラン名"      "")
      (list "T^件名コード"    "")
      (list "T^注文"          "")
      (list "T^系列"          "")
      (list "T^ワークトップ"  "")
      (list "T^扉"            "")
      (list "T^営業担当"      (nth  5 #sTitle$));★★★営業担当
      (list "T^見積担当"      (nth  6 #sTitle$));★★★見積(積算)担当
      (list "T^バージョン"    (nth  7 #sTitle$))
      (list "T^ワークトップ2" "")
      (list "T^システム名"    "")
      (list "T^会社名"        "")
      (list "T^設計プラン"    "")
      (list "T^営業所"        (nth 4 #sTitle$));★★★営業所
      (list "T^施工店"        "")
      (list "T^構成備考"      "")
    );_list
;2010/12/10 YM MOD-E

;;;  (setq #sTitle$$
;;;    (list
;;;      (list "T^作成日"        (menucmd "M=$(edtime,$(getvar,date),YYYY.MO.DD)"));★★★作成日
;;;      (list "T^図番"          (strcat (nth  1 #sTitle$)(nth  2 #sTitle$)))      ; ★プラン番号★&★追番★
;;;      (list "T^物件名称"      (nth  0 #sTitle$));★★★物件名称
;;;      (list "T^プラン名"      "")
;;;      (list "T^件名コード"    "")
;;;      (list "T^注文"          "")
;;;      (list "T^系列"          "")
;;;      (list "T^ワークトップ"  "")
;;;      (list "T^扉"            "")
;;;      (list "T^営業担当"      (nth  4 #sTitle$));★★★営業担当
;;;      (list "T^見積担当"      (nth  5 #sTitle$));★★★見積(積算)担当
;;;      (list "T^バージョン"    (nth  6 #sTitle$))
;;;      (list "T^ワークトップ2" "")
;;;      (list "T^システム名"    "")
;;;      (list "T^会社名"        "")
;;;      (list "T^設計プラン"    "")
;;;      (list "T^営業所"        (nth 3 #sTitle$));★★★営業所
;;;      (list "T^施工店"        "")
;;;      (list "T^構成備考"      "")
;;;    );_list


  );_setq
  ;@DEBUG@(princ "\nプラン担当: ")(princ (nth  8 #sTitle$)) ; 01/12/25 HN
  ;@DEBUG@(getstring "\ncheck: ")

  ; 図面内のタイトル文字を変更
;-- 2011/09/21 A.Satoh Add - S
  (if (= nil (tblsearch "APPID" "G_ZUWAKU")) (regapp "G_ZUWAKU"))
;-- 2011/09/21 A.Satoh Add - E
  (setq #iCnt 0)
  (setq #psTitle (ssget "X" (list (cons 8 "0_TITLET") (cons 0 "TEXT"))))
  (if #psTitle
    (repeat (sslength #psTitle)
      (setq #ent$   (entget (ssname #psTitle #iCnt)))
      (setq #sKey$  (assoc 1 #ent$))
      ; 02/01/08 HN MOD 判定を変更
      ;@MOD@(setq #sTitle (cadr (assoc (cdr #sKey$) #sTitle$$)))
      (setq #sKey   (cdr #sKey$))
      (setq #sTitle (cadr (assoc #sKey #sTitle$$)))
      (if (= nil #sTitle) (setq #sTitle ""))      ; 01/12/25 HN ADD
      ; 02/01/08 HN MOD 判定を変更
      ;@MOD@(if (= 'STR (type #sTitle))
;-- 2011/09/21 A.Satoh Mod - S
;;;;;      (if (and (= 'STR (type #sTitle)) (= "T^" (substr #sKey 1 2)))
;;;;;        (entmod (subst (cons 1 #sTitle) #sKey$ #ent$))
;;;;;      )
      (if (and (= 'STR (type #sTitle)) (= "T^" (substr #sKey 1 2)))
        (progn
          (cond
            ((= #sKey "T^図番")
              (entmod (append (subst (cons 1 #sTitle) #sKey$ #ent$) (list (list -3 (list "G_ZUWAKU" (cons 1000 "MITSUN"))))))
            )
            ((= #sKey "T^物件名称")
              (entmod (append (subst (cons 1 #sTitle) #sKey$ #ent$) (list (list -3 (list "G_ZUWAKU" (cons 1000 "BUKKEN"))))))
            )
            ((= #sKey "T^営業担当")
              (entmod (append (subst (cons 1 #sTitle) #sKey$ #ent$) (list (list -3 (list "G_ZUWAKU" (cons 1000 "EIGYOT"))))))
            )
            ((= #sKey "T^見積担当")
              (entmod (append (subst (cons 1 #sTitle) #sKey$ #ent$) (list (list -3 (list "G_ZUWAKU" (cons 1000 "MITSUT"))))))
            )
            ((= #sKey "T^営業所")
              (entmod (append (subst (cons 1 #sTitle) #sKey$ #ent$) (list (list -3 (list "G_ZUWAKU" (cons 1000 "EIGYOS"))))))
            )
            (T
              (entmod (subst (cons 1 #sTitle) #sKey$ #ent$))
            )
          )
        )
      )
;-- 2011/09/21 A.Satoh Mod - E
      (setq #iCnt (1+ #iCnt))
    );_repeat
  );_if

  (princ)
);_defun


;<HOM>************************************************************************
; <関数名>  : ExceptToList
; <処理概要>: リスト内の同じ要素を除外する
; <戻り値>  : 除外したリスト
; <備考>    : なし
;************************************************************************>MOH<

(defun ExceptToList (
  &list$      ; リスト
  /
  #work$ #elm #list_new$
  )
  (setq #work$ nil)
  (mapcar
   '(lambda ( #elm )
      (if (not (member #elm #work$))
        (progn
          (setq #list_new$ (cons #elm #list_new$))
          (setq #work$     (cons #elm #work$))
        )
      )
    )
    &list$
  )

  (reverse #list_new$)
) ; ExceptToList

;<HOM>************************************************************************
; <関数名>  : DEL_DOOR_PLIN3
; <処理概要>: ﾊﾟｰｽ挿入後、扉勝手線(G_PLIN 3)を削除
; <戻り値>  : なし
;             06/04/03 YM 関数化
; <備考>    : なし
;************************************************************************>MOH<
(defun DEL_DOOR_PLIN3 (
  /
  #I #SS
  )
  (setq #ss (ssget "X" (list (list -3 (list "G_PLIN")))))
  (if #ss
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (if (= (nth 0 (CFGetXData (ssname #ss #i)  "G_PLIN")) 3)
          (entdel (ssname #ss #i))
        )
        (setq #i (1+ #i))
      )
    )
  )
  (princ)
);DEL_DOOR_PLIN3

;<HOM>************************************************************************
; <関数名>  : SCFDrawPersLayout
; <処理概要>: レイアウト図作成  パース図
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<

(defun SCFDrawPersLayout (
  &sFname     ; 展開元図ファイル名
  &sView      ; 視点名
  /
  #layer #deg #deg2
  #8 #DEGZ #DIST #EG$ #I #INI$$ #SSVIEW #TAIMEN_FLG #VID69L #VID69R #XDEG #ZDEG
	#ORTHOMODE #OSMODE ;2012/02/15 YM ADD
  )

	;2012/02/15 YM ADD-S ｶﾒﾗ位置と目標点の関係が不適切です
  ; 直行モードの設定
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 0)
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	;2012/02/15 YM ADD-E

  (if (findfile &sFname)
    (progn
      ;モデル空間に移動
      (setvar "TILEMODE" 1)
      ;モデル図面挿入
			;2015/03/25 YM MOD-S
;;;      (command "_.INSERT" &sFname "0,0,0" 1 1 "0")
      (command "_.INSERT" &sFname "0,0,0" "1" "1" "0")
			;2015/03/25 YM MOD-E

      (command "_.explode" (entlast))
      ;浮動モデル空間に移動
      (setvar "TILEMODE" 0)
      (command "_.MSPACE")

      ;2009/01/20 YM ADD-S
      (DEL_DOOR_PLIN3);ﾊﾟｰｽ図の場合、扉開き線"G_PLIN"3を削除する
      ;2009/01/20 YM ADD-E

			;2015/03/25 YM ADD-S DVIEWでフリーズしてしまうので模様がそうをフリーズ
;;;			(command "_.layer" "F" "0_PERS" "")
			(command "_regen")

      (if (/= nil &sView)
        (progn
          ;視点呼び出し
          ;---  編集 99/12/01 ---
          ;(command "_.VIEW" "R" &sView)

          ;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
;;;         (if (or (= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; JPG出力ﾓｰﾄﾞ追加 03/02/22 YM ADD


          ; ★微調整ﾊﾟﾗﾒｰﾀをscplot.cfgから取得★
          (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
          (if #ini$$
            (progn
              (setq #XDEG (cadr (assoc "XDEG" #ini$$))) ;X軸からの角度
              (setq #ZDEG (cadr (assoc "ZDEG" #ini$$))) ;XY平面からの角度
              (setq #DIST1 (cadr (assoc "DIST1" #ini$$))) ;目標からの距離<対面以外>
              (setq #DIST2 (cadr (assoc "DIST2" #ini$$))) ;目標からの距離<対面>
            )
          );_if

          ; ﾊﾟﾗﾒｰﾀが取得できない場合は初期値
          (if (= nil #XDEG)(setq #XDEG   "0.0"))
          (if (= nil #ZDEG)(setq #ZDEG   "0.0"))
          (if (= nil #DIST1)(setq #DIST1 "0.0"))
          (if (= nil #DIST2)(setq #DIST2 "0.0"))


          (if (member CG_AUTOMODE '(4 5));2008/08/05 YM MOD
            (progn ;ここはとおらない

              (if (or (equal "L-LEFT" &sView) (equal "W-RIGHT" &sView))
                (setq #deg (+ -110 (atof #XDEG))) ; 左勝手
                (setq #deg  (- -70 (atof #XDEG))) ; 右勝手
              );_if

              (setq #degZ (+ 15 (atof #ZDEG)))   ;XY平面からの角度
              (setq #dist (+ 5500 (atof #dist))) ;目標からの距離
            )
            ; else
            (progn

              ;2008/08/14 YM ADD 空白"TEXT"の存在でﾊﾟｰｽ位置がずれるため削除する
              (Textdel)

              (cond
                ((or (equal "L-LEFT" &sView)(equal "I-LEFT" &sView))
                  (setq #deg  (+ -130 (atof #XDEG))) ; I型左勝手
                  (setq #deg2 (-  130 (atof #XDEG))) ; I型左勝手 対面のﾘﾋﾞﾝｸﾞ側
                )
                ((or (equal "L-RIGHT" &sView)(equal "I-RIGHT" &sView))
                  (setq #deg  (- -50 (atof #XDEG))) ; I型右勝手
                  (setq #deg2 (+  50 (atof #XDEG))) ; I型右勝手 対面のﾘﾋﾞﾝｸﾞ側
                )
                (T
                  (setq #deg (+ -130 (atof #XDEG))) ; ?左勝手
                )
              );_cond

            )

          );_if

          ; 02/01/19 HN ADD パース図のカメラ視点をシンクキャビネットの配置角度で判断
          (setq #deg (+ #deg CG_AngSinkCab))

          ; 02/01/21 HN ADD
          (cond
            ((<  900 #deg) (setq #deg (- #deg 1080))); 03/07/03 YM ADD-S
            ((<  720 #deg) (setq #deg (- #deg 900))); 03/07/03 YM ADD-S
            ((<  540 #deg) (setq #deg (- #deg 720))); 03/07/03 YM ADD-S
            ((<  360 #deg) (setq #deg (- #deg 540))); 03/07/03 YM ADD-S
            ((<  180 #deg) (setq #deg (- #deg 360)))
            ((> -900 #deg) (setq #deg (+ #deg 1080))); 03/07/03 YM ADD-E
            ((> -720 #deg) (setq #deg (+ #deg 900))); 03/07/03 YM ADD-E
            ((> -540 #deg) (setq #deg (+ #deg 720))); 03/07/03 YM ADD-E
            ((> -360 #deg) (setq #deg (+ #deg 540))); 03/07/03 YM ADD-E
            ((> -180 #deg) (setq #deg (+ #deg 360)))
          )

;;;(setvar "cmdecho" 1) ; ﾁｪｯｸﾗｲﾄ
          ;(command "_.DVIEW" "ALL" "" "O" "X")

          ; これでｴﾗｰが出なくなるので様子を見る;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
;;;         (if (or (= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; JPG出力ﾓｰﾄﾞ追加 03/02/22 YM ADD
          (if (member CG_AUTOMODE '(4 5));2008/08/05 YM MOD
            (progn ;ここはとおらない
              ;04/04/14 YM MOVE-S if文の中に移動
              (command "_vpoint" "0,0,1")
              (command "_.ZOOM" "E")
              (command "_.ZOOM" "0.1X")
              ;04/04/14 YM MOVE-E if文の中に移動
              (command "_.DVIEW" "ALL" "" "PO" "0,0,0" "1000,-1000,0" "CA" #degZ #deg "X") ; 03/02/22 YM MOD
              (command "_.ZOOM" "E")
              (command "_.DVIEW" "ALL" "" "D" #dist "X")
            )
            (progn
              ;04/04/14 YM ADD-S 対面用2ﾋﾞｭｰﾊﾟｰｽ向き調整対応
              ;対面用ﾋﾞｭｰﾎﾟｰﾄがあるかどうか検索
              (setq #ssVIEW (ssget "X" '((0 . "VIEWPORT"))))
              (setq #i 0)
              (setq #TAIMEN_FLG nil)
              (if (and #ssVIEW (< 0 (sslength #ssVIEW)))
                (progn
                  (repeat (sslength #ssVIEW)
                    (setq #eg$ (entget (ssname #ssVIEW #i)))
                    (setq #8 (cdr (assoc  8 #eg$)));画層
                    (if (= #8 "VIEWL");対面用ﾃﾝﾌﾟﾚｰﾄのﾋﾞｭｰﾎﾟｰﾄ画層(左側ｷｯﾁﾝ)
                      (progn
                        (setq #TAIMEN_FLG T);対面用だった
                        (setq #VID69L (cdr (assoc 69 #eg$))) ; VIEWPORT ID
                      )
                    );_if
                    (if (= #8 "VIEWR");対面用ﾃﾝﾌﾟﾚｰﾄのﾋﾞｭｰﾎﾟｰﾄ画層(右側ﾘﾋﾞﾝｸﾞ)
                      (progn
                        (setq #TAIMEN_FLG T);対面用だった
                        (setq #VID69R (cdr (assoc 69 #eg$))) ; VIEWPORT ID
                      )
                    );_if
                    (setq #i (1+ #i))
                  )
                )
              );_if




              (if #TAIMEN_FLG
                (progn ;対面

                  (setq #degZ (+ 15 (atof #ZDEG)))    ;XY平面からの角度
                  (setq #dist (+ 7000 (atof #DIST2))) ;目標からの距離

                  (setvar "CVPORT" #VID69L); ﾋﾞｭｰﾎﾟｰﾄID (左側ｷｯﾁﾝ)に切り替えてﾋﾞｭｰの調整
                  (command "_vpoint" "0,0,1")
                  (command "_.ZOOM" "E")
                  (command "_.ZOOM" "0.1X")
                  (command "_.DVIEW" "ALL" "" "PO" "0,0,0" "-1000,-1000,0" "CA" #degZ #deg "X")
                  (command "_.ZOOM" "E")
                  (command "_.DVIEW" "ALL" "" "D" #dist "X")
                  ;2008/09/05 YM ADD めいっぱいズームする
                  (command "_.ZOOM" "E")


                  (setvar "CVPORT" #VID69R); ﾋﾞｭｰﾎﾟｰﾄID (右側ﾘﾋﾞﾝｸﾞ)に切り替えてﾋﾞｭｰの調整
                  (command "_vpoint" "0,0,1")
                  (command "_.ZOOM" "E")
                  (command "_.ZOOM" "0.1X")
                  (command "_.DVIEW" "ALL" "" "PO" "0,0,0" "-1000,1000,0" "CA" #degZ #deg2 "X")
                  (command "_.ZOOM" "E")
                  (command "_.DVIEW" "ALL" "" "D" #dist "X")
                  ;2008/09/05 YM ADD めいっぱいズームする
                  (command "_.ZOOM" "E")

                )
                (progn ;対面以外

                  (setq #degZ (+ 15 (atof #ZDEG)))     ;XY平面からの角度
                  (setq #dist (+ 10000 (atof #DIST1))) ;目標からの距離

                  ;通常(今まで)
                  ;04/04/14 YM MOVE-S 以下前からｺﾋﾟｰ
                  (command "_vpoint" "0,0,1")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 001")

                  (command "_.ZOOM" "E")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 002")

                  (command "_.ZOOM" "0.1X")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 003")

                  ;04/04/14 YM MOVE-E 以下前からｺﾋﾟｰ
                  (command "_.DVIEW" "ALL" "" "PO" "0,0,0" "1000,-1000,0" "CA" #degZ #deg "X") ; 02/04/25 YM MOD ORG
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 004")

                  (command "_.ZOOM" "E")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 005")

                  (command "_.DVIEW" "ALL" "" "D" #dist "X")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 006")

                  ;2008/09/05 YM ADD めいっぱいズームする
                  (command "_.ZOOM" "E")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 007")

                )
              );_if
            )
          );_if

          ;---  編集 99/12/01 ---
          ;ペーパー空間に移動
          (command "_.PSPACE")
        )
      );_if

			;2015/03/25 YM ADD-S DVIEWでフリーズしてしまうので模様がそうをフリーズ
;;;			(command "_.layer" "T" "0_PERS" "");フリーズ解除
			(command "_regen")


    )
  );_if

	;2012/02/15 YM ADD-S ｶﾒﾗ位置と目標点の関係が不適切です
  ; 直行モードを戻す
  (setvar "ORTHOMODE" #orthomode)
	(setvar "OSMODE" #osmode)
	;2012/02/15 YM ADD-E

  (princ)
) ; SCFDrawPersLayout

;<HOM>************************************************************************
; <関数名>  : SCFDrawPersLayout2
; <処理概要>: レイアウト図作成  パース図
; <戻り値>  : T  :挿入した
;             nil:挿入していない
; <備考>    : なし
;************************************************************************>MOH<
(defun SCFDrawPersLayout2 (
	&kitType    ;(STR)視点方向定義(L-LEFT,W-RIGHT等)
	/
	#ssView
	#enView
	#file
	#enLay
	#viewId
	#p1 #p2
	#ss
	#ang
	#extmin #extmax
	#dist
	#ang #dist #layView #no
	#en #eg
	#drawFlg
	#vs$
	#fileL$ #fileL$$
	#i
#orthomode #osmode ;-- 2012/02/28 A.Satoh Add
	)
	;レイアウト空間に切り替える
	(setvar "TILEMODE" 0)

	;2012/02/28 A.Satoh ADD-S ｶﾒﾗ位置と目標点の関係が不適切です
  ; 直行モードの設定
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 0)
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	;2012/02/28 A.Satoh ADD-E ｶﾒﾗ位置と目標点の関係が不適切です

	;VIEWPORT図形を取得する
	(setq #ssView (ssget "X" '((0 . "VIEWPORT"))))
	;VIEWPORT図形数分処理を行う
	(foreach #enView (Ss2En$ #ssView)
		(setq #layView (cdr (assoc 8 (entget #enView))))
		;画層がVIEWで始まる場合
		(if (= (substr #layView 1 4) "VIEW")
			(progn
				;画層のVIEWの番号を取得する
				(setq #no (substr #layView 5 1))
				;ｳｯﾄﾞﾜﾝは"VIEWL","VIEWR"
				(if (= #no "L")(setq #no "1"))
				(if (= #no "R")(setq #no "2"))

				;その番号を元にインサートする図形の画層を作成する
				(MakeLayer (strcat "0_PERS_" #no) 7 "CONTINUOUS")
				;画層リストを覚えておく
				(setq #enLay (strcat "0_PERS_" #no))
				;VIEWPORTのIDリストを覚えておく
				(setq #viewId (cdr (assoc 69 (entget #enView))))

				;挿入するパース図形ファイル名リストを覚えておく
				(setq #file nil)
				(if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" "M_" #no ".dwg"))
					(setq #file (strcat CG_KENMEI_PATH "BLOCK\\" "M_" #no ".dwg"))
					(progn
						(if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" "M_0.dwg"))
							(setq #file (strcat CG_KENMEI_PATH "BLOCK\\" "M_0.dwg"))
						)
					)
				)
				(setq #fileL$$ (cons (list #enView #enLay #viewId #file) #fileL$$))
			)
		)
	)
	;VIEWPORT図形数文ループする
;(dpr '#enView$)
;(dpr '#enLay$)
;(dpr '#viewId$)
;(dpr '#file$)
	(foreach #fileL$ #fileL$$
		(setq #enView (nth 0 #fileL$))
		(setq #enLay (nth 1 #fileL$))
		(setq #viewId (nth 2 #fileL$))
		(setq #file (nth 3 #fileL$))
		;画層がVIEWで始まる図形の場合に処理を行う
		(if (and #file (findfile #file))
			(progn
				(WebOutLog "パースの図形を挿入します")
				(princ "\nパースの図形を挿入します")

				(command "_.MSPACE")
				(setvar "CVPORT" #viewId)    ;VIEWの切り替え

				;既に配置されていれば一旦削除する
				(foreach #en (Ss2En$ (ssget "X" (list (cons 8 #enLay))))
					(entdel #en)
				)
				;パース図形ファイルを挿入する
				(command "_.INSERT" #file "0,0,0" "1" "1" "0")
				(command "_.explode" (entlast))
				(WebOutLog "パースの図形を画層の変更します")
				(princ "\nパースの図形を画層の変更します")

				;画層の変更
				(foreach #en (Ss2En$ (ssget "P"))
					(setq #eg (entget #en))
					(entmod (subst (cons 8 #enLay) (assoc 8 #eg) #eg))
				)

				;06/04/03 YM MOD 関数化
				(DEL_DOOR_PLIN3)


;06/04/03 YM DEL-S 関数化
;;;        (setq #ss (ssget "X" (list (list -3 (list "G_PLIN")))))
;;;        (if #ss
;;;          (progn
;;;            (setq #i 0)
;;;            (repeat (sslength #ss)
;;;              (if (= (nth 0 (CFGetXData (ssname #ss #i)  "G_PLIN")) 3)
;;;                (entdel (ssname #ss #i))
;;;              )
;;;              (setq #i (1+ #i))
;;;            )
;;;          )
;;;        )
;06/04/03 YM DEL-E 関数化

				;ビューポート内で挿入した画層以外はフリーズする
				(command "_.VPLAYER" "F" "*" "C" "")
				(command "_.VPLAYER" "T" #enLay "C" "")

				;パース矢視から視点角度情報を取得して削除する
				(setq #ss (ssget "X" '((-3 ("RECTPERS")))))
				(if (and #ss (= (sslength #ss) 1))
					(progn
						(setq #ang (nth 1 (CFGetXData (ssname #ss 0) "RECTPERS")))
						;パース矢視は要らないので削除しておく
						(entdel (ssname #ss 0))
					)
				;else
					(progn
						(if (or (equal "L-LEFT" &kitType) (equal "W-RIGHT" &kitType))
							(setq #ang  50) ; 左勝手
							(setq #ang 130) ; 右勝手
						)
						;パース図のカメラ視点をシンクキャビネットの配置角度で判断
						(setq #ang (rtos (+ #ang CG_AngSinkCab)))
					)
				)

				(command "_.LAYER" "F" "0_PERS*" "")
				(command "_.LAYER" "T" #enLay "")

				(command "_.REGEN")   ;フリーズ後のEXTMIN,MAXを有効にするため
				(setq #extmin (getvar "EXTMIN"))
				(setq #extmax (getvar "EXTMAX"))

				;ビューサイズを取得する
				(setq #vs$ (GetViewSize))

				;ビューの縦横比率により、距離を調整する
				(if (> (- (cadr #vs$) (car #vs$)) (- (nth 3 #vs$) (nth 2 #vs$)))
					;横長ビューの時
					(setq #dist (* 2.2 (distance #extmin #extmax)))
					;縦長ビューの時
					(setq #dist (* 2.4 (distance #extmin #extmax)))
				)

				(cond
					;鳥瞰図の時
					((= "0" (substr #enLay (strlen #enLay) 1))
						(WebOutLog "鳥瞰図の視線を変更します")
						(princ "\n鳥瞰図の視線を変更します")
            (setq #p1 (polar #extmin (angle #extmin #extmax) (* 0.5 (distance #extmin #extmax))))
					  (setq #p1 (list (car #p1) (cadr #p1) 50000.))
					  (setq #p2 (list (car #p1) (cadr #p1) 0.))
					  (command "_.VPOINT" "0,0,1")
					  (command "_.DVIEW" "ALL" "" "PO" #p2 #p1 "D" #dist "PA" "0,0" "400,230" "X")
					)
					;それ以外のパースの時
					(T
						;視点角度を設定する
						(WebOutLog "パース図の視線を変更します")
						(princ "\nパース図の視線を変更します")
						(setq #p1 (list 0 0 0))
						(setq #p2 (polar #p1 (dtr (atoi #ang)) 100))
						(setq #p2 (list (car #p2) (cadr #p2) -30))
						(command "_.VPOINT" "0,0,1")
						(command "_.DVIEW" "ALL" "" "PO" #p2 #p1 "X")
						(command "_.ZOOM" "E")
						(command "_.DVIEW" "ALL" "" "D" #dist "X")
					)
				)
				(command "_.LAYER" "T" "0_PERS*" "") ;元に戻す
				(command "_.REGEN")
				(setvar "ELEVATION" 0)

				(WebOutLog "パース挿入完了")
				(princ "\nパース挿入完了")

				(setq #drawFlg T)
			)
		;else
			(progn
				(command "_.MSPACE")
				(setvar "CVPORT" #viewId)
				(command "_.VPLAYER" "F" "*" "C" "")
			)
		)
	)

	(command "_.PSPACE")
	(command "_.LAYER" "OF" "VIEW*" "")
;  (WebOutLog "パース枠図形の画層の図形を非表示にしました")

;-- 2012/02/28 A.Satoh ADD-S ｶﾒﾗ位置と目標点の関係が不適切です
  ; 直行モードを戻す
  (setvar "ORTHOMODE" #orthomode)
	(setvar "OSMODE" #osmode)
;-- 2012/02/28 A.Satoh ADD-E ｶﾒﾗ位置と目標点の関係が不適切です

	;戻り値
	#drawFlg
)
; SCFDrawPersLayout2

;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetTitleStr
;;; <処理概要>: ;空白文字の"TEXT"の存在でﾊﾟｰｽ位置がずれるため削除する
;;; <戻り値>  : なし
;;; <備考>    : ;2008/08/14 YM ADD
;;;************************************************************************>MOH<
(defun Textdel
  (
  /
  #1 #EG$ #EN #I #SS
  )
  ;空白ﾃｷｽﾄを削除する
  (setq #ss (ssget "X" (list (cons 0 "TEXT"))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #eg$ (entget #en))
        (setq #1 (cdr (assoc 1 #eg$)))
        (if (or (= #1 "")(= #1 " ")(= #1 "　"))
          (command "_.ERASE" #en "")
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

);Textdel

;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetTitleStr
;;; <処理概要>: 図面枠のタイトル文字列を獲得する
;;; <戻り値>  : タイトル文字列リスト
;;;              1. 物件名
;;;              2. プラン名
;;;              3. 件名コード
;;;              4. 注文No.
;;;              5. 系列
;;;              6. ワークトップ
;;;              7. 扉
;;;              8. 営業担当
;;;              9. プラン担当
;;;             10. バージョン
;;;             11. ワークトップ2
;;;             12. システム名
;;;             13. 会社名
;;;             14. 設計プランNo.
;;;             15. 所課名
;;;             16. 取扱店名
;;;             17. 図面内記事欄
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SCFGetTitleStr
  (
  /
  #HEAD$$
  #VER$$
  #sWT
  #sDoor
  #sWt2
  #INFO$
  #SystemName
  #JisyaName
  )

  ;// ヘッダー情報を読み込む
;;;  (setq #HEAD$$ (ReadIniFile (strcat CG_KENMEI_PATH "HEAD.CFG")))
  (setq #VER$$  (ReadIniFile (strcat CG_SYSPATH  "Version.ini")))

  (setq #sWt  nil)
  (setq #sWt2 nil)


  ;// 戻り値を返す
;;;  (list
;;;    (cadr (assoc "BUKKENNAME" CG_KENMEIINFO$))    ; 物件名
;;;    (cadr (assoc "PLANNAME"   CG_KENMEIINFO$))    ; プラン名
;;;    (cadr (assoc "KENMEICD"   CG_KENMEIINFO$))    ; 件名コード
;;;    (cadr (assoc "ORDERNO"    CG_KENMEIINFO$))    ; 注文No.
;;;    (cadr (assoc "Series"     #HEAD$$))           ; 系列
;;;    (cadr (assoc "WT_zai"     #HEAD$$))           ; ワークトップ  01/01/31 HN MOD
;;;    #sDoor                                        ; 扉            01/02/28 HT MOD
;;;    (cadr (assoc "SALECHARGE" CG_KENMEIINFO$))    ; 営業担当
;;;    (cadr (assoc "PLANCHARGE" CG_KENMEIINFO$))    ; プラン担当
;;;    (cadr (assoc "VERNO"      #VER$$))            ; バージョン
;;;    #sWt2                                         ; ワークトップ2 00/09/25 HT MOD
;;;    #SystemName                                   ; システム名    未使用
;;;    #JisyaName                                    ; 会社名        未使用
;;;   (cadr (assoc "DESIGNNO"   CG_KENMEIINFO$))    ; 設計プランNo. 01/11/30 HN ADD
;;;   (cadr (assoc "SHOPNAME"   CG_KENMEIINFO$))    ; 所課名        01/11/30 HN ADD
;;;   (cadr (assoc "OFFICE"     CG_KENMEIINFO$))    ; 取扱店名      02/03/17 HN ADD
;;;   (cadr (assoc "NEWS"       CG_KENMEIINFO$))    ; 図面内記事欄  02/03/17 HN ADD
;;; )

  (list
    (cadr (assoc "ART_NAME"             CG_KENMEIINFO$))  ; ★物件名称★
    (cadr (assoc "PLANNING_NO"          CG_KENMEIINFO$))  ; ★プラン番号★
    ;2010/12/10 YM ADD-S
    (cadr (assoc "PLAN_NAME"            CG_KENMEIINFO$))  ; ★プラン名★
    ;2010/12/10 YM ADD-E
    (cadr (assoc "VERSION_NO"           CG_KENMEIINFO$))  ; ★追番★
    (cadr (assoc "BASE_BRANCH_NAME"     CG_KENMEIINFO$))  ; ★営業所名★
    (cadr (assoc "BASE_CHARGE_NAME"     CG_KENMEIINFO$))  ; ★営業担当★
    (cadr (assoc "ADDITION_CHARGE_NAME" CG_KENMEIINFO$))  ; ★見積(積算担当)★
    (cadr (assoc "VERNO"      #VER$$))                    ; ★バージョン★
    ""                                                    ; プラン名
    ""                                                    ; 件名コード
    ""                                                    ; 取扱店名
    ""                                                    ; 図面内記事欄
    ""                                                    ; 系列
    ""                                                    ; 扉
    ""                                                    ; ワークトップ
    ""                                                    ; ワークトップ2(ｶｳﾝﾀｰ)
    ""                                                    ; システム名    未使用
    ""                                                    ; 会社名        未使用
  )


)
;;;SCFGetTitleStr


;<HOM>************************************************************************
; <関数名>  : DrawBaloon
; <処理概要>: バルーン作図
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<

(defun DrawBaloon (
  &ss         ; 対象選択セット
  &layer      ; バルーン作図画層
  &high       ; バルーン作図高さ
  /
  #ss #i #en #del$ #table #spec$ #assoc$ #list$ #10 #ed$ #hin #no
  )

  ;拡張データ登録
  (if (not (tblsearch "APPID" "G_REF")) (regapp "G_REF"))

  ;展開番号P点獲得
  (setq #ss (ssget "X" (list (cons 8 &layer) (list -3 (list "G_PTEN")))))
  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (if (not (and (= 7 (car (CfGetXData #en "G_PTEN")))
                  ; 誤差を含むように修正
                      ;(equal '(0.0 0.0 1.0) (cdrassoc 210 (entget #en)))
                      (equal 0.0 (nth 0 (cdrassoc 210 (entget #en))) 0.001)
                      (equal 0.0 (nth 1 (cdrassoc 210 (entget #en))) 0.001)
                      (equal 1.0 (nth 2 (cdrassoc 210 (entget #en))) 0.001)
                      (ssmemb #en &ss)))
          (setq #del$ (cons #en #del$))
        );_if
        (setq #i (1+ #i))
      )
      (mapcar
       '(lambda ( #en )
          (ssdel #en #ss)
        )
        #del$
      )
    )
  )

  ;仕様表ファイル名獲得
  (setq #table (strcat CG_KENMEI_PATH "Table.cfg"))

  (if (and (/= nil #ss) (findfile #table))
    (progn
      ;仕様表読込み
      (setq #spec$ (ReadCSVFile #table))
      ;特注ｷｬﾋﾞは品番+@価格で区別する 01/03/10 YM ADD START lambda mapcar は使用しない
      (setq #assoc$ nil)
      (foreach spec #spec$
        ;2011/06/18 YM MOD-S 天板にバルン番号を作図しない
;-- 2011/12/12 A.Satoh Mod - S
;;;;;        (setq #set_hin (nth 11 spec))
        (setq #set_hin (nth 13 spec))
;-- 2011/12/12 A.Satoh Mod - E
        (setq #assoc$ (append #assoc$ (list
          (list
            #set_hin
            (nth 0 spec) ; 番号
          )
        )))
;;;       ;2011/04/25 YM MOD-S 扉個別指定対応
;;;       (setq #CAD_HIN    (nth  9 spec))
;;;       (setq #DR_CAD_HIN (nth 11 spec))
;;;       (if (= #DR_CAD_HIN "")
;;;         (setq #set_hin #CAD_HIN)
;;;         ;else
;;;         (setq #set_hin #DR_CAD_HIN)
;;;       );_if
;;;       ;2011/04/25 YM MOD-E 扉個別指定対応
;;;
;;;       (setq #assoc$ (append #assoc$ (list
;;;         (list
;;;           #set_hin ;2011/04/25 MOD
;;;           (nth 0 spec) ; 番号
;;;         )
;;;       )))
      );foreach

      (setq #i 0)
      (repeat (sslength #ss)
        ;図形名
        (setq #en  (ssname #ss #i))
        (setq #10  (cdrassoc 10 (entget #en)))
        ;品番獲得
        (setq #ed$ (CfGetXData #en "G_PTEN"))
        (setq #hin (cadr #ed$))

        ;2011/04/25 YM DEL-S 扉個別指定対応
;;;       (setq #hin (KP_DelDrSeriStr #hin))
        ;2011/04/25 YM DEL-E 扉個別指定対応

        ;展開図番号獲得
        (setq #no  (cadr (assoc #hin #assoc$)))
;;;       ; 特注ｷｬﾋﾞにﾊﾞﾙｰﾝがつかない不具合の対応 01/03/01 YM ADD
;;;       (if (and (= nil #no)(= 'STR (type #hin))) ; #hin=0 のときがあるため 01/03/10 YM
;;;         (setq #no (cadr (assoc (strcat "ﾄｸ" #hin) #assoc$)))
;;;       );_if

        (if (/= nil #no)
          (progn
            ;展開図番号作図
            (MakeBalNo #10 #no &high)
            ;拡張データ格納
            (CfSetXData (entlast) "G_REF" (list #no))
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
  (princ)
) ; DrawBaloon


;<HOM>************************************************************************
; <関数名>  : MakeBalNo
; <処理概要>: バルーン番号を作成配置する
; <戻り値>  :
; <備考>    :
;************************************************************************>MOH<
(defun MakeBalNo (
  &pt         ;(ENAME)座標
  &no         ;(STR)表示文字
  &high       ; バルーン作図高さ
  /
  #clayer #ss #eg #pt1
#Freeze #LAY_INFO$ ; 01/12/12 YM ADD
  )
  (setq #clayer (getvar "CLAYER"))
  (setq #ss (ssadd))

  (setq #pt1 (list (car &pt) (cadr &pt) &high))

  (if (not (tblsearch "LAYER" "0_REFNO")) (MakeLayer "0_REFNO" 7 "CONTINUOUS"))
  ; 01/12/12 YM ADD-S 表示制御でﾊﾞﾙﾝ番号がﾌﾘｰｽﾞされていたら落ちるの回避
  (setq #Freeze nil)
  (setq #lay_info$ (tblsearch "LAYER" "0_REFNO"))
  (if (= (cdr (assoc 70 #lay_info$)) 1)
    (progn ; ﾊﾞﾙﾝ番号がﾌﾘｰｽﾞされていた
      (setq #Freeze T)
      (command "_layer" "T" "0_REFNO" "") ; ﾌﾘｰｽﾞ解除
    )
  );_if

  ; 01/12/12 YM ADD-S 表示制御でﾊﾞﾙﾝ番号がﾌﾘｰｽﾞされていたら落ちるの回避
  (setvar "CLAYER" "0_REFNO")
  ;円作図
  (command "_circle" "_non" #pt1 CG_REF_SIZE)
  (setq #ss (ssadd (entlast) #ss))
  ;テキスト作図
  (MakeText &no #pt1 60.0 1 2 "REF_NO")
  (setq #ss (ssadd (entlast) #ss))

  ;// ブロック化
  (CFublock #pt1 #ss)
  (setvar "CLAYER" #clayer)

  ; 01/12/12 YM ADD-S
  (if #Freeze
    (command "_layer" "F" "0_REFNO" "") ; 再ﾌﾘｰｽﾞ
  );_if
  ; 01/12/12 YM ADD-E
  (princ)
) ; MakeBalNo

;<HOM>************************************************************************
; <関数名>  : MakeBalNoSizeCH
; <処理概要>: バルーン番号を作成配置する
; <戻り値>  : なし
; <備考>    : MakeBalNoで半径と文字高さを引数に追加した関数 01/12/21 YM
;************************************************************************>MOH<
(defun MakeBalNoSizeCH (
  &pt         ;(ENAME)座標
  &no         ;(STR)表示文字
  &high       ; バルーン作図高さ
  &rr         ; 円の半径
  &HH         ; 文字高さ
  /
  #CLAYER #FREEZE #LAY_INFO$ #PT1 #SS
  )
  (setq #clayer (getvar "CLAYER"))
  (setq #ss (ssadd))

  (setq #pt1 (list (car &pt) (cadr &pt) &high))

  (if (not (tblsearch "LAYER" "0_REFNO")) (MakeLayer "0_REFNO" 7 "CONTINUOUS"))
  ; 01/12/12 YM ADD-S 表示制御でﾊﾞﾙﾝ番号がﾌﾘｰｽﾞされていたら落ちるの回避
  (setq #Freeze nil)
  (setq #lay_info$ (tblsearch "LAYER" "0_REFNO"))
  (if (= (cdr (assoc 70 #lay_info$)) 1)
    (progn ; ﾊﾞﾙﾝ番号がﾌﾘｰｽﾞされていた
      (setq #Freeze T)
      (command "_layer" "T" "0_REFNO" "") ; ﾌﾘｰｽﾞ解除
    )
  );_if

  ; 01/12/12 YM ADD-S 表示制御でﾊﾞﾙﾝ番号がﾌﾘｰｽﾞされていたら落ちるの回避
  (setvar "CLAYER" "0_REFNO")
  ;円作図
  (command "_circle" "_non" #pt1 &rr)
  (setq #ss (ssadd (entlast) #ss))
  ;テキスト作図
  (MakeText &no #pt1 &HH 1 2 "REF_NO")
  (setq #ss (ssadd (entlast) #ss))

  ;// ブロック化
  (CFublock #pt1 #ss)
  (setvar "CLAYER" #clayer)

  ; 01/12/12 YM ADD-S
  (if #Freeze
    (command "_layer" "F" "0_REFNO" "") ; 再ﾌﾘｰｽﾞ
  );_if
  ; 01/12/12 YM ADD-E
  (princ)
); MakeBalNoSizeCH

;<HOM>************************************************************************
; <関数名>  : C:KPMakeBaloon
; <処理概要>: バルーン番号を作成配置する
; <戻り値>  : 見積項番作成ｺﾏﾝﾄﾞ
; <備考>    : 01/12/17 YM MakeBalNoのｺﾏﾝﾄﾞ化
;************************************************************************>MOH<
(defun C:KPMakeBaloon (
  /
  #CLAYER #FREEZE #HIGH #LAY_INFO$ #NO #PT #PT1 #SS #cmdecho
  )
  (StartUndoErr)

  ; 01/12/25 YM ADD-S
  (setq #cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  ; 01/12/25 YM ADD-E

  ; 01/12/20 YM ADD-S 01/12/25 YM ADD if文追加
  (if (= (getvar "TILEMODE") 0)
    (command "_.MSPACE")
  );_if
  ; 01/12/20 YM ADD-E

  (setq #lay_info$ (tblsearch "LAYER" "0_REFNO"))
  (if (= (cdr (assoc 70 #lay_info$)) 1)
    (progn ; ﾊﾞﾙﾝ番号がﾌﾘｰｽﾞされていた
      (CFAlertMsg "\n表示制御コマンドで仕様表番号を表示してください。")
      (quit)
    )
  );_if

  ;拡張データ登録
  (if (not (tblsearch "APPID" "G_REF")) (regapp "G_REF"))

  (setq #iNO (getint "\n番号を入力: "))
  (setq #sNO (itoa #iNO)) ; 文字列化

  ; 01/12/21 YM ADD-S
  ; 円の半径と文字高さを入力
  (setq #defrr (rtos CG_REF_SIZE)) ; ﾃﾞﾌｫﾙﾄｽｹｰﾙ
;;;01/12/25YM@MOD (setq #defhh (rtos CG_REF_SIZE)) ; ﾃﾞﾌｫﾙﾄｽｹｰﾙ

  (setq #rr (getreal (strcat "\n円の半径<" #defrr ">: ")))
  (if (= #rr nil)
    (setq #rr (atof #defrr))
  ); if

;;;01/12/25YM@MOD  (setq #hh (getreal (strcat "\nY文字の高さ<" #defhh  ">: ")))
;;;01/12/25YM@MOD (if (= #hh nil)
;;;01/12/25YM@MOD   (setq #hh (atof #defhh))
;;;01/12/25YM@MOD ); if
  ; 01/12/21 YM ADD-E

  (setq #pt (getpoint "\n挿入位置を指示: "))
  (setq #high CG_LAYOUT_DIM_Z) ; バルーン作図高さ

  ; ﾊﾞﾙﾝ作図
;;;01/12/21YM@MOD (MakeBalNo #pt #sNO #high)
  (MakeBalNoSizeCH #pt #sNO #high #rr #rr) ; 01/12/25 YM 文字高さは尋ねない
;;;01/12/25YM@MOD (MakeBalNoSizeCH #pt #sNO #high #rr #hh)

  ;拡張データ格納
  (CfSetXData (entlast) "G_REF" (list #sNO))
  (princ "\n見積項番を作成しました。")

  ; 01/12/25 YM ADD-S
  (setvar "CMDECHO" #cmdecho)
  ; 01/12/25 YM ADD-E

  (setq *error* nil)
  (princ)
); C:KPMakeBaloon

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KPInsertSymbol
;;; <処理概要>  : 既存のプランを挿入して再利用する
;;; <戻り値>    : なし
;;; <作成>      : C:PC_InsertPlan を元に作成 01/04/25 YM
;;; <備考>      : 挿入後にG_ARW , G_ROOMを削除
;;;*************************************************************************>MOH<
(defun C:KPInsertSymbol (
  /
  #ANG #INSPT #PURGE #SFNAME #CMDECHO
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPInsertSymbol ////")
  (CFOutStateLog 1 1 " ")
  (StartUndoErr);// コマンドの初期化

  ; 01/12/25 YM ADD-S
  (setq #cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  ; 01/12/25 YM ADD-E

  ; 01/12/20 YM ADD-S 01/12/25 YM ADD if文追加
  (if (= (getvar "TILEMODE") 0)
    (command "_.MSPACE")
  );_if
  ; 01/12/20 YM ADD-E

  ; 既存dwgの検索
  (if (vl-directory-files (strcat CG_SYSPATH "SYMBOL\\") "*.dwg")
    (progn
      ; ﾌｧｲﾙ指定
      (setq #sFname (getfiled "記号配置" (strcat CG_SYSPATH "SYMBOL\\") "dwg" 8))
      (if #sFname
        (progn

          ; 01/12/25 YM ADD-S
          ; 尺度を入力(X,Y毎に尋ねずに1回だけ)
          (setq #defSCL "1.0") ; ﾃﾞﾌｫﾙﾄｽｹｰﾙ

          (setq #scl (getreal (strcat "\n倍率<" #defSCL ">: ")))
          (if (= #scl nil)
            (setq #scl (atof #defSCL))
          ); if
          ; 01/12/25 YM ADD-E

;;;01/12/25YM@MOD         ; 01/12/21 YM ADD-S
;;;01/12/25YM@MOD         ; 尺度を入力
;;;01/12/25YM@MOD         (setq #defSCLX "1.0") ; ﾃﾞﾌｫﾙﾄｽｹｰﾙ
;;;01/12/25YM@MOD         (setq #defSCLY "1.0") ; ﾃﾞﾌｫﾙﾄｽｹｰﾙ

;;;01/12/25YM@MOD         (setq #sclX (getreal (strcat "\nX方向の倍率<" #defSCLX ">: ")))
;;;01/12/25YM@MOD         (if (= #sclX nil)
;;;01/12/25YM@MOD           (setq #sclX (atof #defSCLX))
;;;01/12/25YM@MOD         ); if
;;;01/12/25YM@MOD
;;;01/12/25YM@MOD         (setq #sclY (getreal (strcat "\nY方向の倍率<" #defSCLY ">: ")))
;;;01/12/25YM@MOD         (if (= #sclY nil)
;;;01/12/25YM@MOD           (setq #sclY (atof #defSCLY))
;;;01/12/25YM@MOD         ); if

          ; 01/12/21 YM ADD-E

;;;01/12/21YM@DEL         (command "vpoint" "0,0,1"); 視点を真上から
          (princ "\n配置点: ")
          (command "_Insert" #sFname pause #scl #scl) ; 01/12/25 YM MOD
;;;01/12/25YM@MOD         (command "_Insert" #sFname pause #sclX #sclY)
          (princ "\n角度: ")
          (command pause)

          (setq #insPt (getvar "LASTPOINT"))
          (setq #ang (cdr (assoc 50 (entget (entlast)))))

          (command "_explode" (entlast))
          ;// インサートしたブロック定義をパージする
;;;01/12/21YM@MOD         (command "_purge" "BL" #purge "N")
          (command "_purge" "BL" "*" "N")
          (princ "\n記号を配置しました。")
        )
      );_if
    )
    (progn
      (CFAlertMsg "挿入する記号が登録されていません。")
      (quit)
    )
  );_if

  ; 01/12/25 YM ADD-S
  (setvar "CMDECHO" #cmdecho)
  ; 01/12/25 YM ADD-E

  (setq *error* nil)
  (princ)
);C:KPInsertSymbol

;<HOM>*************************************************************************
; <関数名>    : C:DanmenSelect
; <処理概要>  : 断面抽出ｺﾏﾝﾄﾞ(ｳｯﾄﾞﾜﾝ)
; <戻り値>    : なし
; <作成>      : 2011/07/27 A.Satoh
; <備考>      : 2点指示==>GSMの左右側面を抽出する
;               dwg名:"商品図_右側面.dwg","施工図_右側面.dwg"
;                    :"商品図_左側面.dwg","施工図_左側面.dwg"
;*************************************************************************>MOH<
(defun C:DanmenSelect (
  /
  #orthomode #pp1 #pp2
  #layer$ #layer #layerdata #layername #freez #disp
  #ss #0502_ss #0504_ss #0602_ss #0604_ss
  #idx #sym$ #sym #zukei$ #zukei #en #edata$
  #fpath #fname_0602 #fname_0502 #fname_0604 #fname_0504 
#osmode ;-- 2011/11/21 A.Satoh Add
  )

;**********************************
    ;; エラー処理
    (defun DanmenSelectErr ( msg / )
      (command "_.UNDO" "B")
      (setq *error* nil)
      (princ)
    )
;**********************************

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:DanmenSelect ////")
  (CFOutStateLog 1 1 " ")

  (setq *error* DanmenSelectErr)
  (command "_.UNDO" "M")
  (command "_.UNDO" "A" "OFF")

  ; 現在のビュー情報を保存する
  (command "_.VIEW" "S" "TEMP_MRR")

  ; 直行モードの設定
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)
;-- 2011/11/21 A.Satoh Add - S
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
;-- 2011/11/21 A.Satoh Add - E

  (command "_.VPOINT" (list 0 0 1))
  (command "_.ZOOM" "0.8x")

  ; 断面線の作成
  (setq #pp1 (getpoint "\n1点目を指示:> "))
  (setq #pp2 (getpoint "\n2点目を指示:> " #pp1))
  (if (= #pp2 nil)
    (exit)
  )

  ; 断面線作成チェック
  (if (and (not (equal (nth 0 #pp1) (nth 0 #pp2) 0.001))
           (not (equal (nth 1 #pp1) (nth 1 #pp2) 0.001)))
    (progn
      (alert "断面の指示が間違っています")
      (exit)
    )
  )

  ; 断面図形画層のフリーズ状態確認
  (setq #layer$ nil)
  (setq #layerdata (tblnext "LAYER" T))
  (while #layerdata
    (if (or (= (substr (cdr (assoc 2 #layerdata)) 1 8) "Z_05_02_")
            (= (substr (cdr (assoc 2 #layerdata)) 1 8) "Z_05_04_")
            (= (substr (cdr (assoc 2 #layerdata)) 1 8) "Z_06_02_")
            (= (substr (cdr (assoc 2 #layerdata)) 1 8) "Z_06_04_"))
      (progn
        (setq #layername (cdr (assoc 2 #layerdata)))
        (if (= (cdr (assoc 70 #layerdata)) 0)
          (setq #freez nil)
          (setq #freez T)
        )
        (if (>= (cdr (assoc 62 #layerdata)) 0)
          (setq #disp nil)
          (setq #disp T)
        )
        (setq #layer$ (append #layer$ (list (list #layername #freez #disp))))
      )
    )
    (setq #layerdata (tblnext "LAYER" nil))
  )

  ; 断面図形画層の表示、フリーズ解除
  (foreach #layer #layer$
    (command "_.LAYER" "T" (car #layer) "ON" (car #layer) "")
  )

  ; 断面線に交差する図形(選択セット)を取得する
  (setq #ss (ssget "F" (list #pp1 #pp2)))
  (if (= #ss nil)
    (progn
      (alert "該当する断面は存在しません")
      (exit)
    )
  )

  ; シンボル図形名リスト及び図形名リストを作成する
  (setq #idx 0)
  (setq #sym$ nil)
  (setq #zukei$ nil)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #idx))
    (setq #sym (SearchGroupSym #en))
    (setq #zukei #en)
    (if #sym
      (progn
        (if (= (member #sym #sym$) nil)
          (setq #sym$ (append #sym$ (list #sym)))
        )
      )
      (progn
        (if (= (member #zukei #zukei$) nil)
          (setq #zukei$ (append #zukei$ (list #zukei)))
        )
      )
    )
    (setq #idx (1+ #idx))
  )

  ; シンボル図形から断面図形を取得する
  (setq #0502_ss (ssadd))
  (setq #0504_ss (ssadd))
  (setq #0602_ss (ssadd))
  (setq #0604_ss (ssadd))
  (foreach #sym #sym$
    ; 全グループメンバー図形を取得する
    (setq #ss (CFGetSameGroupSS #sym))

    (setq #idx 0)
    (repeat (sslength #ss)
      (setq #en (ssname #ss #idx))
      (setq #layer (cdr (assoc 8 (entget #en))))
      (cond
        ((= (substr #layer 1 8) "Z_05_02_")
          (setq #0502_ss (ssadd #en #0502_ss))
        )
        ((= (substr #layer 1 8) "Z_05_04_")
          (setq #0504_ss (ssadd #en #0504_ss))
        )
        ((= (substr #layer 1 8) "Z_06_02_")
          (setq #0602_ss (ssadd #en #0602_ss))
        )
        ((= (substr #layer 1 8) "Z_06_04_")
          (setq #0604_ss (ssadd #en #0604_ss))
        )
      )
      (setq #idx (1+ #idx))
    )
  )

  ; ワークトップ、天井フィラーを取得
  (foreach #zukei #zukei$
    (setq #edata$ (entget #zukei '("*")))
    (setq #edata$ (cdr (assoc -3 #edata$)))
    (if (/= #edata$ nil)
      (if (= (nth 0 (car #edata$)) "G_WTSET")
        (progn
          (setq #0502_ss (ssadd #zukei #0502_ss))
          (setq #0504_ss (ssadd #zukei #0504_ss))
          (setq #0602_ss (ssadd #zukei #0602_ss))
          (setq #0604_ss (ssadd #zukei #0604_ss))
        )
        (if (= (nth 0 (car #edata$)) "G_WRKT")
          (progn
            (setq #0502_ss (ssadd #zukei #0502_ss))
            (setq #0504_ss (ssadd #zukei #0504_ss))
            (setq #0602_ss (ssadd #zukei #0602_ss))
            (setq #0604_ss (ssadd #zukei #0604_ss))
          )
          (if (= (nth 0 (car #edata$)) "G_FILR")
            (progn
              (setq #0502_ss (ssadd #zukei #0502_ss))
              (setq #0504_ss (ssadd #zukei #0504_ss))
              (setq #0602_ss (ssadd #zukei #0602_ss))
              (setq #0604_ss (ssadd #zukei #0604_ss))
            )
          )
        )
      )
    )
  )

  ; ファイル名
  (setq #fpath (strcat CG_SYSPATH "SYMBOL\\"))

  (setq #fname_0602 "商品図_右側面.dwg")
  (setq #fname_0502 "商品図_左側面.dwg")
  (setq #fname_0604 "施工図_右側面.dwg")
  (setq #fname_0504 "施工図_左側面.dwg")

  ; ビュー変更(視点を左側に変更)
  (command "_.VPOINT" (list -1 0 0))
  (command "_.UCS" "ZA" "" "-1,0,0")

  ; 断面図形をシンボル図形化
  ;; 商品図_左側図
  (command "_.WBLOCK" (strcat #fpath #fname_0502) "" "0,0,0" #0502_ss "")
  (command "_.OOPS")

  ;; 施工図_左側図
  (command "_.WBLOCK" (strcat #fpath #fname_0504) "" "0,0,0" #0504_ss "")
  (command "_.OOPS")

  (command "_.UCS" "P")

  ; ビュー変更(視点を左側に変更)
  (command "_.VPOINT" (list 1 0 0))
  (command "_.UCS" "ZA" "" "1,0,0")

  ; 断面図形をシンボル図形化
  ;; 商品図_右側図
  (command "_.WBLOCK" (strcat #fpath #fname_0602) "" "0,0,0" #0602_ss "")
  (command "_.OOPS")

  ;; 施工図_右側図
  (command "_.WBLOCK" (strcat #fpath #fname_0604) "" "0,0,0" #0604_ss "")
  (command "_.OOPS")

  (command "ucs" "P")


  ; 断面図形画層をフリーズ状態を元に戻す
  (foreach #layer #layer$
    (if (= (nth 1 #layer) T)
      (command "_.LAYER" "F" (car #layer) "")
    )
    (if (= (nth 2 #layer) T)
      (command "_.LAYER" "OF" (car #layer) "")
    )
  )

  ; 直行モードを戻す
  (setvar "ORTHOMODE" #orthomode)
;-- 2011/11/21 A.Satoh Add - S
	(setvar "OSMODE" #osmode)
;-- 2011/11/21 A.Satoh Add - E

  ; ビューを元に戻す
  (command "_.ZOOM" "P")
  (command "_.VIEW" "R" "TEMP_MRR")
; (command "ucs" "")

  (alert (strcat "断面図を以下の名前で保存しました。\n　" #fname_0502 "\n　" #fname_0504 "\n　" #fname_0602 "\n　" #fname_0604))

  (setq *error* nil)

  (princ)

;  (alert "★★★　工事中　★★★")

);C:DanmenSelect

;<HOM>************************************************************************
; <関数名>  : ChangeYashi
; <処理概要>: 矢視を変更旧矢視に変更
; <戻り値>  : 旧矢視
; <備考>    : なし
;************************************************************************>MOH<

(defun ChangeYashi (
  &yashi      ; 新矢視
  &flg        ; フラグ（"N"新矢視に変更  "O"旧矢視に変更）
  /
  )
  (if (= "N" &flg)
    (cond
      ((= "P" &yashi) "P")
      ((= "A" &yashi) "A")
      ((= "B" &yashi) "D")
      ((= "C" &yashi) "B")
      ((= "D" &yashi) "C")
    )
    (cond
      ((= "P" &yashi) "P")
      ((= "A" &yashi) "A")
      ((= "B" &yashi) "C")
      ((= "C" &yashi) "D")
      ((= "D" &yashi) "B")
    )
  )
)


;<HOM>************************************************************************
; <関数名>  : CdrAssoc
; <処理概要>: 図形データから特定のkeyのデータを獲得
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<

(defun CdrAssoc (
  &key        ; 検索キーワード
  &eg         ; 図形データ
  /
  #ed #d #ret
  )
  (setq #ed (assoc &key &eg))
  (if (/= nil #ed)
    (progn
      (mapcar
       '(lambda ( #d )
          (if (and (= 'REAL (type #d))(equal 0.0 #d 0.00001))
            (setq #ret (cons 0.0 #ret))
            (setq #ret (cons #d  #ret))
          )
        )
        #ed
      )
      (setq #ret (cdr (reverse #ret)))
    )
  )
  #ret
) ; CdrAssoc


;<HOM>************************************************************************
; <関数名>  : PurgeBlock
; <処理概要>: ブロックをパージ
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<

(defun PurgeBlock (
  /
  #cmdecho
  )

  (setq #cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command "_.PURGE" "bl" "*" "Y")
  (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
    (command "Y")
  )
  (command "_.PURGE" "bl" "*" "Y")
  (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
    (command "Y")
  )
  (command "_.PURGE" "bl" "*" "Y")
  (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
    (command "Y")
  )
  (setvar "CMDECHO" #cmdecho)

  (princ)
)


;<HOM>************************************************************************
; <関数名>  : DelSymEntity
; <処理概要>: シンボル図形を削除する
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<

(defun DelSymEntity (
  /
  #ss #i #en
  )
  (setq #ss (ssget "X" (list (list -3 (list "G_SKDM")))))
  (if (/= nil #ss)
    (progn
      (mapcar
       '(lambda ( #en )
          (entdel #en)
        )
        (Ss2En$ #ss)
      )
    )
  )
  (princ)
) ; DelSymEntity


;<HOM>************************************************************************
; <関数名>  : DispFigure
; <処理概要>: 姿図配置
; <戻り値>  : なし
; <備考>    : なし
;************************************************************************>MOH<

(defun DispFigure (
  /
  #high #ss #i #en #ed$ #fr$ #no$ #table #spec$ #elm$ #hin #list$ #new$
  #assoc$ #sp$ #no #fname #fn$ #fpt$ #scale #pt$ #ins #baloon
  )
  ; 01/12/06 HN MOD 定数をグローバル化
  ;@MOD@(setq #high 15000)   ; バルーン作図高さ
  (setq #high CG_LAYOUT_DIM_Z)   ; バルーン作図高さ
  (setq #ss (ssget "X" (list (list -3 (list "FRAME")))))
  (if (/= nil #ss)
    (progn
      ;姿図領域獲得
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #ed$ (CfGetXData #en "FRAME"))
        (if (= "F" (substr (car #ed$) 1 1))
          (setq #fr$ (cons (list (substr (car #ed$) 2) #en) #fr$))
        )
        (setq #i (1+ #i))
      )
      (setq #fr$ (mapcar 'cadr (SCFmg_sort$ 'car #fr$)))

      ;展開番号獲得
      (setq #ss (ssget "X" (list (list -3 (list "G_REF")))))
      (if (/= nil #ss)
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            (setq #ed$ (CfGetXData #en "G_REF"))
            (setq #no$ (cons (car #ed$) #no$))
            (setq #i (1+ #i))
          )
        )
      )
      ;Table.cfgファイル読込み
      (setq #table (strcat CG_KENMEI_PATH "Table.cfg"))
      (if (findfile #table)
        (progn
          ;仕様表読込み
          (setq #spec$ (ReadCSVFile #table))
          ; 02/09/04 YM ADD ﾛｸﾞ出力追加
          (WebOutLog "**************")
          (WebOutLog "Table.cfg")
          (WebOutLog "**************")
          (WebOutLog #spec$)
          (WebOutLog " ")
          ; 02/09/04 YM ADD ﾛｸﾞ出力追加
          (mapcar
           '(lambda ( #elm$ )
              (if (= "1" (substr (nth 3 #elm$) 1 1))
                ;左右判定あり
                (setq #hin$ (list (substr (nth 1 #elm$) 1 (1- (strlen (nth 1 #elm$)))) "R"))
                ;左右判定なし
                (setq #hin$ (list (nth 1 #elm$) "Z"))
              )
              (if (assoc #hin$ #list$)
                (progn
                  (setq #new$ (list #hin$ (cons (nth 0 #elm$) (cadr (assoc #hin$ #list$)))))
                  (setq #list$ (subst #new$ (assoc #hin$ #list$) #list$))
                )
                (progn
                  (setq #list$ (cons (list #hin$ (list (nth 0 #elm$))) #list$))
                )
              )
            )
            #spec$
          )
          (mapcar
           '(lambda ( #elm$ )
              (setq #assoc$ (cons (cons (car (SCFmg_sort$ 'eval (cadr #elm$))) #elm$) #assoc$))
            )
            #list$
          )
        )
      )
    )
  )
  (if (and #fr$ #no$ #assoc$)
    (progn
      ;姿図表示順獲得
      (mapcar
       '(lambda ( #sp$ )
          (setq #no   (nth 0 #sp$))
          (setq #hin$ (nth 1 #sp$))
          (setq #n$   (SCFmg_sort$ 'eval (nth 2 #sp$)))
          (if (member #no #no$)
            (progn
              ;品番名称とLR区分から、品番図形テーブルにクエリーし、扉面IDを獲得
              (setq #fname (GetFnameFigure #hin$))
              (if (and (/= nil #fname)(findfile #fname))
                (setq #fn$   (cons (list #no #fname #n$) #fn$))
              )
            )
          )
        )
        #assoc$
      )
      (setq #fn$ (reverse #fn$))

      ; 姿図がある時のみ 2000/08/24 HT ADD
      (if #fn$
  (progn
        ;姿図配置
        (setq #i 0)
        (mapcar
         '(lambda ( #en )
            (setq #fpt$ (GetInsertPtScale #en))
            (setq #scale (car #fpt$))
            (mapcar
             '(lambda ( #pt$ )
                (if (nth #i #fn$)
                  (progn
                  (setq #ins    (car  #pt$))           ; 姿図ファイル挿入基点
                  (setq #baloon (cadr #pt$))           ; バルーン挿入基点
                  (setq #fname  (nth 1 (nth #i #fn$))) ; 姿図ファイル名
                  (setq #no$    (nth 2 (nth #i #fn$))) ; バルーン番号リスト
                  ;姿図挿入
                  (command "_.insert" #fname "_non" #ins #scale "" "0")
                  ;バルーン作図
                  (mapcar
                   '(lambda ( #no )
                      (MakeBalNo #baloon #no #high)
                      (setq #baloon (mapcar '+ #baloon (list (* 2.0 CG_REF_SIZE) 0.0 0.0)))
                    )
                    #no$
                  )
                  (setq #i (1+ #i))
                  )
                  )
                )
                (cadr #fpt$)
                )
             )
            #fr$
          )
        )
      )
    )
  )
  (princ)
) ; DispFigure


;<HOM>************************************************************************
; <関数名>  : GetFnameFigure
; <処理概要>: 品番名称とLR区分から、品番図形テーブルにクエリーし、扉面IDを獲得
; <戻り値>  : 扉面ID（姿図ファイル名）
; <備考>    : ファイル名はフルパス
;************************************************************************>MOH<
(defun GetFnameFigure (
  &hin$       ; （品番名称 LR区分）
  /
  #seri$ #qry$ #fn #ret
  )
  ;// 現在の商品情報を設定する
  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DBNAME      (nth 0 #seri$))  ;DB名称
      (setq CG_SeriesCode  (nth 1 #seri$))  ;SERIES記号
      (setq CG_BrandCode   (nth 2 #seri$))  ;ブランド記号
    )
  )
  ;// SERIES別データベースへの接続
  (if (= CG_DBSESSION nil)
    (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  )

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "品番図形"
      (list
        (list "品番名称" (car  &hin$)  'STR)
        (list "LR区分"   (cadr &hin$)  'STR)
      )
    )
  )
  (if (/= nil #qry$)
    (progn
      (setq #fn "")
      ; 01/10/01 YM ADD-S ｴﾗｰ処理
      (if (= #fn nil)
        (progn
          (CFAlertMsg (strcat "品番図形の展開IDが未登録です." "\n品番= " (car  &hin$)))
          (setq #ret nil)
        )
      ; 01/10/01 YM ADD-E ｴﾗｰ処理
        (setq #ret (strcat CG_FIGUREDWGPATH #fn ".dwg"))
      );_if
    )
  );_if

  #ret
) ; GetFnameFigure


;<HOM>************************************************************************
; <関数名>  : GetInsertPtScale
; <処理概要>: 領域図形名から、挿入尺度と挿入基点リストを獲得する
; <戻り値>  : 尺度と挿入基点リスト
; <備考>    : CG_FigureScale  =  挿入図形の高さ
;             CG_REF_SIZE     =  バルーン半径
;************************************************************************>MOH<

(defun GetInsertPtScale (
  &en         ; 領域図形名
  /
  #space #pt$ #minmax #xlen #ylen #vect #tpt #pt #loop #bv #bl #scale
  )
  ;スペース
  (setq #space 0)
  ;領域座標獲得
  (setq #pt$ (mapcar 'car (get_allpt_H &en)))
  (setq #minmax (GetPtMinMax #pt$))
  (setq #xlen (abs (- (car  (car #minmax)) (car  (cadr #minmax)))))
  (setq #ylen (abs (- (cadr (car #minmax)) (cadr (cadr #minmax)))))
  ;縦横判定
  (if (< #xlen #ylen)
    (progn
      ;変位値
      (setq #vect (list 0.0 (* -1 (+ #space #xlen)) 0.0))
      ;基点
      (setq #tpt  (list (car (car #minmax)) (cadr (cadr #minmax)) 0.0))
      (setq #pt   (mapcar '+ #tpt #vect))
      ;LOOP数
      (setq #loop (1- (fix (/ #ylen #xlen))))
      ;バルーン位置変位値
      (setq #bv   (list CG_REF_SIZE (- #xlen CG_REF_SIZE) 0.0))
    )
    (progn
      ;変位値
      (setq #vect (list (+ #space #ylen) 0.0 0.0))
      ;基点
      (setq #pt   (car #minmax))
      ;LOOP数
      (setq #loop (1- (fix (/ #xlen #ylen))))
      ;バルーン位置変位値
      (setq #bv   (list CG_REF_SIZE (- #ylen CG_REF_SIZE) 0.0))
    )
  )
  ;基点リスト獲得
  (setq #pt$ nil)
  (setq #bl  (mapcar '+ #pt #bv))
  (setq #pt$ (cons (list #pt #bl) #pt$))
  (repeat #loop
    (setq #pt  (mapcar '+ #pt #vect))
    (setq #bl  (mapcar '+ #pt #bv))
    (setq #pt$ (cons (list #pt #bl) #pt$))
  )
  (setq #pt$ (reverse #pt$))
  ;尺度算出
  (setq #scale (/ (distance '(0 0 0) #vect) CG_FigureScale))

  (list #scale #pt$)
) ; GetInsertPtScale

; 01/05/04 HN ADD
;;;<HOM>************************************************************************
;;; <関数名>  : KCFSelTenkai
;;; <処理概要>: ユーザーに展開元図を選択させる
;;; <戻り値>  : 選択された項目に対応するファイル名（フルパス）
;;; <作成>    : 01/05/02 MH
;;; <改訂>    : 01/05/22 HN
;;;             01/06/21 HN ｸﾞﾛｰﾊﾞﾙ参照をなくす
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun KCFSelTenkai
  (
  &sType      ; 図面種類
  &sPathT     ; 展開元図のファイルパス 01/06/21 HN ADD
  /
  #sPath      ; 結果 (フルパス文字列 か nil値)
  ;@DEL@#sPathT     ; 展開元図のファイルパス
  #sPathP     ; 平面図ファイルパス
  #sPathA     ; 展開Ａ図ファイルパス
  #sPathB     ; 展開Ｂ図ファイルパス
  #sPathC     ; 展開Ｃ図ファイルパス
  #sPathD     ; 展開Ｄ図ファイルパス
  #sPathE     ; 展開Ｅ図ファイルパス
  ;2011/07/15 YM ADD
  #sPathF     ; 展開Ｆ図ファイルパス
  #sPathG     ; 展開Ｇ図ファイルパス
  #sPathH     ; 展開Ｈ図ファイルパス
  #sPathI     ; 展開Ｉ図ファイルパス
  #sPathJ     ; 展開Ｊ図ファイルパス
  )
  (setq #sPath nil)

  ; 01/06/21 HN DEL
  ;@DEL@; 展開図のPATH設定
  ;@DEL@(setq #sPathT (strcat CG_KENMEI_PATH "Block\\"))

  ; 作図ディレクトリー中の各展開元図フルパス取得。(無し=nil)
  ; 01/06/21 HN MOD
  ;@MOD@(setq #sPathP (findfile (strcat #sPathT "P_0.dwg" )))
  ;@MOD@(setq #sPathA (findfile (strcat #sPathT "SA_0.dwg")))
  ;@MOD@(setq #sPathB (findfile (strcat #sPathT "SB_0.dwg")))
  ;@MOD@(setq #sPathC (findfile (strcat #sPathT "SC_0.dwg")))
  ;@MOD@(setq #sPathD (findfile (strcat #sPathT "SD_0.dwg")))
  ;@MOD@(setq #sPathE (findfile (strcat #sPathT "SE_0.dwg")))
  ;@MOD@(setq #sPathF (findfile (strcat #sPathT "SF_0.dwg")))
  (setq #sPathP (findfile (strcat &sPathT "P_0.dwg" )))
  (setq #sPathA (findfile (strcat &sPathT "SA_0.dwg")))
  (setq #sPathB (findfile (strcat &sPathT "SB_0.dwg")))
  (setq #sPathC (findfile (strcat &sPathT "SC_0.dwg")))
  (setq #sPathD (findfile (strcat &sPathT "SD_0.dwg")))
  (setq #sPathE (findfile (strcat &sPathT "SE_0.dwg")))
  (setq #sPathF (findfile (strcat &sPathT "SF_0.dwg")))
  ;2011/07/15 YM ADD-S
  (setq #sPathG (findfile (strcat &sPathT "SG_0.dwg")))
  (setq #sPathH (findfile (strcat &sPathT "SH_0.dwg")))
  (setq #sPathI (findfile (strcat &sPathT "SI_0.dwg")))
  (setq #sPathJ (findfile (strcat &sPathT "SJ_0.dwg")))

  (if (or #sPathP #sPathA #sPathB #sPathC #sPathD #sPathE #sPathF #sPathG #sPathH #sPathI #sPathJ)
    ; いずれかの展開元図が存在した
    (setq #sPath
       (KCFSelTenkaiDlg
         &sType
         #sPathP
         #sPathA #sPathB #sPathC #sPathD #sPathE #sPathF #sPathG #sPathH #sPathI #sPathJ
       )
    )
    ; すべて存在しなかったらメッセージ提示
    (CFAlertMsg "展開元図が作成されていません.")
  ) ;_if

  #sPath
) ;_KCFSelTenkai

;;;<HOM>************************************************************************
;;; <関数名>  : KCFSelTenkaiDlg
;;; <処理概要>: ユーザーに展開元図を選択させる
;;; <戻り値>  : 選択された項目に対応するファイル名
;;;                "table" : 仕様表
;;;             "continue" : 新規図面で続行
;;;                 "undo" : 配置した元図を１つずつ戻す
;;;               "cancel" : 現在図面を保存して図面レイアウトコマンドを終了
;;;                    nil : キャンセルおよび無選択
;;; <作成日>  : 01/05/02 MH
;;; <改訂日>  : 01/05/22 HN
;;;             01/06/23 HN 展開元図挿入コマンド対応
;;;             01/12/09 HN UNDO／キャンセル対応
;;; <備考>    : CG_PatNo=nilの場合、展開元図挿入コマンドから呼び出されたと判定
;;; <ｸﾞﾛｰﾊﾞﾙ> : CG_PatNo        : テンプレートファイル名リストの要素番号
;;;             CG_FreeLayoutNo : 商品図／施工図の現在図面枚数
;;;************************************************************************>MOH<
(defun KCFSelTenkaiDlg
  (
  &sType      ; 図面種類
  &sPathP     ; 平面図ファイルパス
  &sPathA     ; 展開Ａ図ファイルパス
  &sPathB     ; 展開Ｂ図ファイルパス
  &sPathC     ; 展開Ｃ図ファイルパス
  &sPathD     ; 展開Ｄ図ファイルパス
  &sPathE     ; 展開Ｅ図ファイルパス
  &sPathF     ; 展開Ｆ図ファイルパス
  ;2011/07/15 YM ADD
  &sPathG     ; 展開Ｇ図ファイルパス
  &sPathH     ; 展開Ｈ図ファイルパス
  &sPathI     ; 展開Ｉ図ファイルパス
  &sPathJ     ; 展開Ｊ図ファイルパス
  /
  #dcl_id
  #sPath
  #GetRes
  #sContinue
  #sNo
  #sLayout
  #sBack
  #sCancel
  )
  (setq #sContinue "continue") ;01/05/22 HN ADD
  (setq #sUndo     "undo"    ) ;01/12/09 HN ADD
  (setq #sCancel   "cancel"  ) ;01/12/09 HN ADD

;--------------------------------------------------------------------------------------
    ; ラジオボタン オン の項目のファイル名を返す
    (defun #GetRes ( / )
      (cond
        ((= "1" (get_tile "P")) &sPathP)
        ((= "1" (get_tile "A")) &sPathA)
        ((= "1" (get_tile "B")) &sPathB)
        ((= "1" (get_tile "C")) &sPathC)
        ((= "1" (get_tile "D")) &sPathD)
        ((= "1" (get_tile "E")) &sPathE)
        ((= "1" (get_tile "F")) &sPathF)
        ;2011/07/15 YM ADD-S
        ((= "1" (get_tile "G")) &sPathG)
        ((= "1" (get_tile "H")) &sPathH)
        ((= "1" (get_tile "I")) &sPathI)
        ((= "1" (get_tile "J")) &sPathJ)
        ;2011/07/15 YM ADD-E
        ((= "1" (get_tile "S")) "Table") ; 仕様表
        ; ボタンが未選択ならメッセージを表示
        (t (CFAlertMsg "項目を選択してください.") nil)
      ); cond
    ); #GetRes
;--------------------------------------------------------------------------------------
    ; 図面上に仕様表が存在=T,なし=nil 01/07/23 YM ADD 仕様表が既存なら選択不可にしたい
    (defun KPSrcHLINE ( / #ss)
      (setq #ss (ssget "X" '((-3 ("G_HLINE")))))
      (if (and #ss (< 0 (sslength #ss)))
        T
        nil
      );_if
    ); #GetRes
;--------------------------------------------------------------------------------------

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "CSFlay.DCL")))
  (if (not (new_dialog "SelTenkaiDlg" #dcl_id)) (exit))

  ; 01/06/23 HN S-MOD 展開元図挿入コマンド対応
  ;@MOD@; 01/05/22 HN S-ADD 複数図面対応
  ;@MOD@(if CG_FreeLayoutNo
  ;@MOD@  (setq #sNo (itoa (1+ CG_FreeLayoutNo)))
  ;@MOD@  (setq #sNo "1")
  ;@MOD@)
  ;@MOD@(cond
  ;@MOD@  ((= CG_OUTSHOHINZU &sType) (set_tile "type" (strcat "商品図  " #sNo " 枚目")))
  ;@MOD@  ((= CG_OUTSEKOUZU  &sType) (set_tile "type" (strcat "施工図  " #sNo " 枚目")))
  ;@MOD@)
  ;@MOD@; 01/05/22 HN E-ADD 複数図面対応
  (if CG_PatNo
    (progn
      (if CG_FreeLayoutNo
        (setq #sNo (itoa (1+ CG_FreeLayoutNo)))
        (setq #sNo "1")
      )
      (setq #sNo (strcat #sNo " 枚目"))
    )
    (progn
      (setq #sNo "")
      (mode_tile "continue" 1)
    )
  )
  (cond
    ((= CG_OUTSHOHINZU &sType) (set_tile "type" (strcat "商品図  " #sNo)))
    ((= CG_OUTSEKOUZU  &sType) (set_tile "type" (strcat "施工図  " #sNo)))
  )
  ; 01/06/23 HN E-MOD 展開元図挿入コマンド対応

  ; ファイルがない項目はグレイアウト
  (if (not &sPathP) (mode_tile "P" 1))
  (if (not &sPathA) (mode_tile "A" 1))
  (if (not &sPathB) (mode_tile "B" 1))
  (if (not &sPathC) (mode_tile "C" 1))
  (if (not &sPathD) (mode_tile "D" 1))
  (if (not &sPathE) (mode_tile "E" 1))
  (if (not &sPathF) (mode_tile "F" 1))
  ;2011/07/15 YM ADD-S
  (if (not &sPathG) (mode_tile "G" 1))
  (if (not &sPathH) (mode_tile "H" 1))
  (if (not &sPathI) (mode_tile "I" 1))
  (if (not &sPathJ) (mode_tile "J" 1))
  ;2011/07/15 YM ADD-E

  ; 仕様表が既にあるときはｸﾞﾚｲｱｳﾄ
  (if (KPSrcHLINE) (mode_tile "S" 1))

  ; 01/05/23 HN S-ADD 配置済みの元図は選択不可
  ;@MOD@(if (member "P" CG_LAYOUT$) (mode_tile "P" 1))
  ;@MOD@(if (member "A" CG_LAYOUT$) (mode_tile "A" 1))
  ;@MOD@(if (member "B" CG_LAYOUT$) (mode_tile "B" 1))
  ;@MOD@(if (member "C" CG_LAYOUT$) (mode_tile "C" 1))
  ;@MOD@(if (member "D" CG_LAYOUT$) (mode_tile "D" 1))
  ;@MOD@(if (member "E" CG_LAYOUT$) (mode_tile "E" 1))
  ;@MOD@(if (member "S" CG_LAYOUT$) (mode_tile "S" 1))
  (foreach #sLayout CG_LAYOUT$
    (mode_tile #sLayout 1)
  )
  ; 01/05/23 HN E-ADD 配置済みの元図は選択不可

  ; タイル作動設定
  (action_tile "accept" "(if (setq #sPath (#GetRes)) (done_dialog))")
  ; 01/05/22 HN S-MOD 複数図面対応
  ;@MOD@(action_tile "cancel" "(setq #fRES nil)(done_dialog)")
  (action_tile "continue" "(setq #sPath #sContinue)(done_dialog)")
  (action_tile "end" "(setq #sPath nil)(done_dialog)")
  ; 01/05/22 HN E-MOD 複数図面対応
  ; 01/12/09 HN S-ADD UNDO／キャンセル対応
  (action_tile "undo" "(setq #sPath #sUndo)(done_dialog)")
  (action_tile "cancel" "(setq #sPath #sCancel)(done_dialog)")
  ; 01/12/09 HN E-ADD UNDO／キャンセル対応
  (start_dialog)
  (unload_dialog #dcl_id)

  ; 結果を返す
  #sPath
) ;_KCFSelTenkaiDlg

;;;<HOM>************************************************************************
;;; <関数名>  : SCFLayoutFree
;;; <処理概要>: フリーレイアウト出力
;;; <戻り値>  : なし
;;; <備考>    : テンプレートファイルは開いた状態とする。
;;;             パース図・姿図は対応しません。
;;; <ｸﾞﾛｰﾊﾞﾙ> :
;;;             CG_KENMEI_PATH  : プランフォルダのパス名
;;;             CG_Pattern      : テンプレートファイル名リスト
;;;             CG_PatNo        : テンプレートファイル名リストの要素番号
;;;             CG_KitType      : キッチンタイプ  ex. "I-LEFT" "I-RIGHT"
;;;             CG_LAYOUT$      : 配置済み展開元図記号のリスト
;;;                               "P" 平面図
;;;                               "A" 展開Ａ図
;;;                               "B" 展開Ｂ図
;;;                               "C" 展開Ｃ図
;;;                               "D" 展開Ｄ図
;;;                               "E" 展開Ｅ図
;;;                               "F" 展開Ｆ図
;;;                               "S" 仕様表
;;; <作成>    : 01/05/04 HN
;;;************************************************************************>MOH<
(defun SCFLayoutFree
  (
  /
  #sPathB     ; 展開元図パス名
  #sFileB     ; 展開元図ファイル名(フルパス)
  #sFileT     ; テンプレートファイル名
  #sType      ; 図面種類  "02":商品図  "04":施工図
  #sFileS     ; 仕様表元図面ファイル名(フルパス)
  #sView      ; 視点種類  "P":平面  "S":立面  "D":仕様表  "M":モデル(パース)
  #sView2     ; 立面種類  "A" "B" "C" "D" "E" "F"
  #sFileD     ; 保存図面ファイル名(フルパス)
  )
  (setq #sPathB (strcat CG_KENMEI_PATH "BLOCK\\"))
  (setq #sFileT (car  (nth CG_PatNo CG_Pattern)))
  (setq #sType  (cadr (nth CG_PatNo CG_Pattern)))
  (setq #sFileS (strcat CG_KENMEI_PATH "Table.cfg"))  ; 01/05/09 HN ADD
  (setq CG_LAYOUT$ nil)                               ; 01/05/23 HN ADD

  ;; 商品図／施工図を作成する場合
  ;; ダイアログから展開元図を選択して配置
  ;; キャンセル(nil)で終了
  (if (/= "" #sType)
    ;@@@(while (setq #sFileB (getfiled "展開元図を選択" #sPathB "dwg" 2))
    ; 01/05/22 HN MOD
    ;@MOD@(while (setq #sFileB (KCFSelTenkai))
    ; 01/06/21 HN MOD
    ;@MOD@(while (and (setq #sFileB (KCFSelTenkai #sType)) (/= "continue" #sFileB))
    ; 01/12/09 HN MOD UNDO／キャンセル処理を追加
    ;@MOD@(while (and (setq #sFileB (KCFSelTenkai #sType #sPathB)) (/= "continue" #sFileB))
    (while (and (setq #sFileB (KCFSelTenkai #sType #sPathB)) (/= "continue" #sFileB) (/= "cancel" #sFileB))

      ; 01/12/09 HN S-ADD UNDO／キャンセル処理を追加
      ;@MOD@; 展開元図視点
      ;@MOD@(setq #sView  (substr #sFileB (+ 1 (strlen #sPathB)) 1))
      ;@MOD@(setq #sView2 (substr #sFileB (+ 2 (strlen #sPathB)) 1)) ; 01/05/23 HN ADD
      ;@MOD@
      ;@MOD@(cond
      ;@MOD@  ;; 平面図
      ;@MOD@  ((= "P" #sView)
      ;@MOD@    (SCFDrawPlanLayout #sFileB nil CG_KitType #sType)
      ;@MOD@    (setq CG_LAYOUT$ (cons "P" CG_LAYOUT$)) ; 01/05/23 HN ADD
      ;@MOD@  )
      ;@MOD@  ;; 立面図
      ;@MOD@  ((= "S" #sView)
      ;@MOD@    (SCFDrawExpandLayout #sFileB nil CG_KitType #sType)
      ;@MOD@    (setq CG_LAYOUT$ (cons #sView2 CG_LAYOUT$)) ; 01/05/23 HN ADD
      ;@MOD@  )
      ;@MOD@  ;; 仕様図  01/05/09 HN ADD
      ;@MOD@  ((= "Table" #sFileB)
      ;@MOD@    (SCFDrawTableLayout #sFileS nil)
      ;@MOD@    (setq CG_LAYOUT$ (cons "S" CG_LAYOUT$)) ; 01/05/23 HN ADD
      ;@MOD@  )
      ;@MOD@) ;_cond
      ;@MOD@
      ;@MOD@;シンボル図形削除
      ;@MOD@(if DelSymEntity (DelSymEntity))
      (cond
        ; 配置１回分を戻す
        ((= "undo" #sFileB)
          (if CG_LAYOUT$
            (progn
              (command "_.UNDO" "1")
              (setq CG_LAYOUT$ (cdr CG_LAYOUT$))
            )
            (alert "戻す元図が存在しません.")
          )
        )

        ; 選択された展開元図を配置
        (T
          (command "_.UNDO" "BE")

          ; 展開元図視点
          (setq #sView  (substr #sFileB (+ 1 (strlen #sPathB)) 1))
          (setq #sView2 (substr #sFileB (+ 2 (strlen #sPathB)) 1)) ; 01/05/23 HN ADD

          (cond
            ;; 平面図
            ((= "P" #sView)
              (SCFDrawPlanLayout #sFileB nil CG_KitType #sType)
              (setq CG_LAYOUT$ (cons "P" CG_LAYOUT$)) ; 01/05/23 HN ADD
            )
            ;; 立面図
            ((= "S" #sView)
              (SCFDrawExpandLayout #sFileB nil CG_KitType #sType)
              (setq CG_LAYOUT$ (cons #sView2 CG_LAYOUT$)) ; 01/05/23 HN ADD
            )
            ;; 仕様図  01/05/09 HN ADD
            ((= "Table" #sFileB)
              (SCFDrawTableLayout #sFileS nil)
              (setq CG_LAYOUT$ (cons "S" CG_LAYOUT$)) ; 01/05/23 HN ADD
            )
          ) ;_cond

          ;シンボル図形削除
          (if DelSymEntity (DelSymEntity))
          (command "_.UNDO" "E")
        )
      ) ;_cond
      ; 01/12/09 HN E-ADD UNDO／キャンセル処理を追加

    ) ;_while
  ) ;_if

  ;; 姿図配置  未対応
  ;;(DispFigure)

  (if (/= "" #sType)
    (progn
      ;Ｐ図形を非表示
      (SKFSetHidePLayer)

      ;ハッチング更新
      (CFRefreshHatchEnt)

      ; 隠線面画層を非表示
      (command "_.-LAYER" "ON" "O_HIDE" "")

      ;タイトル作図
      (cond
        ((= CG_OUTSHOHINZU #sType) (SCFMakeTitleText "商品図"))
        ((= CG_OUTSEKOUZU  #sType) (SCFMakeTitleText "施工図"))
      )

      ;パージ
      (PurgeBlock)

      ;ズーム(図面全体)
      (command "_.ZOOM" "A")

      ;図面保存
      ; 01/05/22 HN S-MOD 複数図面対応
      ;MOD(setq #sFileD (strcat CG_KENMEI_PATH "OUTPUT\\" #sFileT "_" CG_RyoNo "_" #sType ".dwg"))
      (if CG_FreeLayoutNo
        (setq CG_FreeLayoutNo (1+ CG_FreeLayoutNo))
        (setq CG_FreeLayoutNo 1)
      )
      (setq #sFileD (strcat CG_KENMEI_PATH "OUTPUT\\" #sFileT "_" (itoa CG_FreeLayoutNo) "_" #sType ".dwg"))
      ; 01/05/22 HN E-MOD 複数図面対応
      (command "_.SAVEAS" "2000" #sFileD)

      ; 01/05/22 HN S-MOD 複数図面対応
      (cond
        ; 01/12/09 HN S-ADD キャンセル処理を追加
        ((= "cancel" #sFileB)
          (setq CG_FreeLayoutNo       nil)
          (setq CG_LayoutFreeContinue nil)
          (setq CG_PatNo              999)
        )
        ; 01/12/09 HN E-ADD キャンセル処理を追加
        ((= "continue" #sFileB)
          (setq CG_LayoutFreeContinue T)
          ;;;;(setq CG_OpenMode 4)
          ;;;;(SCFCmnFileOpen (strcat CG_TMPPATH (car (nth CG_PatNo CG_Pattern)) ".dwt") 0)
        )
        ((= nil #sFileB)
          (setq CG_FreeLayoutNo       nil)
          (setq CG_LayoutFreeContinue nil)
        )
      );_cond
      ; 01/05/22 HN E-MOD 複数図面対応
    ) ;_progn
  ) ;_if

  (princ)
) ;_SCFLayoutFree

;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetEntsLast
;;; <処理概要>: 指定した図形より後に作成された図形を取得する
;;; <戻り値>  : 選択セット
;;; <備考>    : 指定した図形を戻り値に含まない。
;;; <作成>    : 01/05/04 HN
;;;************************************************************************>MOH<
(defun SCFGetEntsLast
  (
  &sHnd       ; 図形ハンドル
  /
  #psLast     ; 選択セット(戻り値)
  #sHndL      ; 指定図形の図形ハンドル
  #iCnt       ; カウンタ
  #sHnd       ; 図形ハンドル
  #psX        ; 全図形の選択セット
  #ent        ; 図形名
  )
  (setq #psLast (ssadd))
  (setq #sHndL &sHnd)
  (while (> 5 (strlen #sHndL))
    (setq #sHndL (strcat "0" #sHndL))
  ) ;_while

  (setq #iCnt 0)
  (if (setq #psX (ssget "X"))
    (repeat (sslength #psX)
      (setq #ent (ssname #psX #iCnt))
      (setq #sHnd (cdr (assoc 5 (entget #ent))))
      (while (> 5 (strlen #sHnd))
        (setq #sHnd (strcat "0" #sHnd))
      ) ;_while
      (if (< #sHndL #sHnd)
        (setq #psLast (ssadd #ent #psLast))
      )
      (setq #iCnt (1+ #iCnt))
    ) ;_repeat
  ) ;_if

  (if (< 0 (sslength #psLast))
    #psLast
    nil
  )
) ;_SCFGetEntsLast

;;;<HOM>************************************************************************
;;; <関数名>  : C:PickStyleOn
;;; <処理概要>: グループが選択されるようにします。
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun C:PickStyleOn
  (
  /
  )
  (cond
    ((= 0 (getvar "PICKSTYLE")) (setvar "PICKSTYLE" 1))
    ((= 2 (getvar "PICKSTYLE")) (setvar "PICKSTYLE" 3))
  )
  (princ "\nｸﾞﾙｰﾌﾟが選択されます.")

  (princ)
) ;_C:PickStyleOn

;;;<HOM>************************************************************************
;;; <関数名>  : C:PickStyleOff
;;; <処理概要>: グループが選択されるようにします。
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun C:PickStyleOff
  (
  /
  )
  (cond
    ((= 1 (getvar "PICKSTYLE")) (setvar "PICKSTYLE" 0))
    ((= 3 (getvar "PICKSTYLE")) (setvar "PICKSTYLE" 2))
  )
  (princ "\nｸﾞﾙｰﾌﾟが選択されません.")

  (princ)
) ;_C:PickStyleOff

;;;<HOM>************************************************************************
;;; <関数名>  : KCFChgDimAngHigh
;;; <処理概要>: 寸法線の回転角度と高さを変更
;;; <戻り値>  : なし
;;; <備考>    : 回転角度を０に変更
;;;             高さを10000 に変更
;;;************************************************************************>MOH<
(defun KCFChgDimAngHigh
  (
  &psDim      ; 選択セット
  /
  #iCnt       ; カウンタ
  #eDim       ; 図形名
  )

  (setq #iCnt 0)
  (repeat (sslength &psDim)
    (setq #eDim (ssname &psDim #iCnt))
    (if (equal "DIMENSION" (cdr (assoc 0 (entget #eDim))))
      (progn
        (SCFEntmodFindDimension #eDim)
      )
    )
    (setq #iCnt (1+ #iCnt))
  )

  (princ)
) ;_KCFChgDimAngHigh

;;;<HOM>************************************************************************
;;; <関数名>  : KCFGetKichenType
;;; <処理概要>: ワークトップからキッチンタイプを獲得する
;;; <戻り値>  : キッチンタイプ
;;;             "I-LEFT"
;;;             "I-RIGHT"
;;;             "L-LEFT"
;;;             "L-RIGHT"
;;;             "D-RIGHT"
;;; <備考>    : 関数(SKGetKichenType)の変更版
;;; <作成>    : 2001/06/23 HN
;;;************************************************************************>MOH<
(defun KCFGetKichenType
  (
  /
  #eWT        ; ワークトップの図形名
  #sWT$       ; ワークトップの拡張データ
  #iType      ; 形状タイプ
  #sKitchen   ; 左右勝手
  #sView      ; キッチンタイプ
  )

  ; ワークトップ図形名を取得
  (setq #eWT (car (SCFGetWkTopXData)))
  (if #eWT
    (progn
      (setq #sWT$ (CfGetXData #eWT "G_WRKT"))
      (setq #iType    (nth  3 #sWT$))
      (setq #sKitchen (nth 30 #sWT$))
    )
  ) ;_if

  (cond
    ; Ｉ型
    ((and (= 0 #iType)(= "L" #sKitchen))  (setq #sView "I-LEFT" ))
    ((and (= 0 #iType)(= "R" #sKitchen))  (setq #sView "I-RIGHT"))
    ; Ｌ型
    ((and (= 1 #iType)(= "L" #sKitchen))  (setq #sView "L-LEFT" ))
    ((and (= 1 #iType)(= "R" #sKitchen))  (setq #sView "L-RIGHT"))
    ; Ｕ型
    ((and (= 2 #iType)(= "L" #sKitchen))  (setq #sView "I-LEFT" ))
    ((and (= 2 #iType)(= "R" #sKitchen))  (setq #sView "I-RIGHT"))
    ; その他
    (T (setq #sView "D-RIGHT"))
  ) ;_cond

  #sView
) ;_KCFGetKichenType

;;;<HOM>************************************************************************
;;; <関数名>  : C:KPInsertBlockT
;;; <処理概要>: 展開元図挿入コマンド
;;; <戻り値>  : なし
;;; <備考>    : レイアウト図面は開いた状態とする。
;;;             パース図・姿図は対応しません。
;;; <ｸﾞﾛｰﾊﾞﾙ> :
;;;             CG_KENMEI_PATH  : プランフォルダのパス名
;;;             CG_Pattern      : テンプレートファイル名リスト
;;;             CG_PatNo        : テンプレートファイル名リストの要素番号
;;;             CG_KitType      : キッチンタイプ  ex. "I-LEFT" "I-RIGHT"
;;;             CG_LAYOUT$      : 配置済み展開元図記号のリスト
;;;                               "P" 平面図
;;;                               "A" 展開Ａ図
;;;                               "B" 展開Ｂ図
;;;                               "C" 展開Ｃ図
;;;                               "D" 展開Ｄ図
;;;                               "E" 展開Ｅ図
;;;                               "F" 展開Ｆ図
;;;                               "S" 仕様表
;;; <作成>    : 01/06/23 HN
;;;************************************************************************>MOH<
(defun C:KPInsertBlockT
  (
  /
  #sPathB     ; 展開元図パス名
  #sFileB     ; 展開元図ファイル名(フルパス)
  #sFileS     ; 仕様表元図面ファイル名(フルパス)
  #sFileD     ; 現在図面ファイル名
  #sType      ; 図面種類  "02":商品図  "04":施工図77
  #sView      ; 視点種類  "P":平面  "S":立面  "D":仕様表  "M":モデル(パース)
  #sView2     ; 立面種類  "A" "B" "C" "D" "E" "F"
  )
  ; コマンドの初期化
  (StartUndoErr)

  ; 02/01/22 HN ADD 現在高度を0.0に設定
  (setvar "ELEVATION" 0.0)

  ; 本機能で使用しないグローバル変数を初期化
  (setq CG_PatNo   nil)
  (setq CG_Pattern nil)

  ; 02/04/25 YM ADD-S
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  ; 02/04/25 YM ADD-E

  ; 01/06/25 HN S-ADD 展開元図
  (setq
    CG_DimPat
    (list
      "1"   ; キャビネット寸法 "1":ON  "0":OFF
      "1"   ; 施工寸法         "1":ON  "0":OFF
      "A"   ; "A":自動  "L":左  "R":右
      "Y"   ; "T":縦    "Y":横
    )
  )

  ; フォルダ・ファイル名設定
  (setq #sPathB (strcat CG_KENMEI_PATH "BLOCK\\"  ))
  (setq #sFileS (strcat CG_KENMEI_PATH "Table.cfg"))

  ; キッチンタイプ取得
  (setq CG_KitType (KCFGetKichenType))

  ; 現在図面名の下２桁から図面種類を取得
  (setq #sFileD (getvar "DWGNAME"))
  (setq #sType  (substr #sFileD (- (strlen #sFileD) 5) 2))

  ; 02/03/28 HN S-ADD 図面種類を取得
  (if
    (and
      (/= CG_OUTSHOHINZU #sType)
      (/= CG_OUTSEKOUZU  #sType)
    )
    (setq #sType (car (CfGetXrecord "DRAWTYPE")))
  );_if
  (if
    (and
      (/= CG_OUTSHOHINZU #sType)
      (/= CG_OUTSEKOUZU  #sType)
    )
    (progn
      (alert "ﾌｧｲﾙ名が変更されて図面種類が判断できません.\n施工図として処理します.")
      (setq #sType CG_OUTSEKOUZU)
    )
  );_if
  ; 02/03/28 HN E-ADD 図面種類を取得

  (setq CG_LAYOUT$ nil)
  (command "_.UNDO" "M")

  ;; ダイアログから展開元図を選択して配置
  ;; キャンセル(nil)で終了
  (if (/= "" #sType)
    ; 01/12/09 HN S-MOD UNDO／キャンセル処理を追加
    ;@MOD@(while (and (setq #sFileB (KCFSelTenkai #sType #sPathB)))
    ;@MOD@
    ;@MOD@  ; 展開元図視点
    ;@MOD@  (setq #sView  (substr #sFileB (+ 1 (strlen #sPathB)) 1))
    ;@MOD@  (setq #sView2 (substr #sFileB (+ 2 (strlen #sPathB)) 1))
    ;@MOD@
    ;@MOD@  (cond
    ;@MOD@    ;; 平面図
    ;@MOD@    ((= "P" #sView)
    ;@MOD@      (SCFDrawPlanLayout #sFileB nil CG_KitType #sType)
    ;@MOD@      (setq CG_LAYOUT$ (cons "P" CG_LAYOUT$))
    ;@MOD@    )
    ;@MOD@    ;; 立面図
    ;@MOD@    ((= "S" #sView)
    ;@MOD@      (SCFDrawExpandLayout #sFileB nil CG_KitType #sType)
    ;@MOD@      (setq CG_LAYOUT$ (cons #sView2 CG_LAYOUT$))
    ;@MOD@    )
    ;@MOD@    ;; 仕様図
    ;@MOD@    ((= "Table" #sFileB)
    ;@MOD@      (SCFDrawTableLayout #sFileS nil)
    ;@MOD@      (setq CG_LAYOUT$ (cons "S" CG_LAYOUT$))
    ;@MOD@    )
    ;@MOD@  ) ;_cond
    ;@MOD@
    ;@MOD@  ;シンボル図形削除
    ;@MOD@  (if DelSymEntity (DelSymEntity))
    ;@MOD@) ;_while
    (while (and (setq #sFileB (KCFSelTenkai #sType #sPathB)) (/= "cancel" #sFileB))
      (cond
        ; 配置１回分を戻す
        ((= "undo" #sFileB)
          (if CG_LAYOUT$
            (progn
              (command "_.UNDO" "1")
              (setq CG_LAYOUT$ (cdr CG_LAYOUT$))
            )
            (alert "戻す元図が存在しません.")
          )
        )

        ; 選択された展開元図を配置
        (T
          (command "_.UNDO" "BE")

          ; 展開元図視点
          (setq #sView  (substr #sFileB (+ 1 (strlen #sPathB)) 1))
          (setq #sView2 (substr #sFileB (+ 2 (strlen #sPathB)) 1))

          (cond
            ;; 平面図
            ((= "P" #sView)
              (SCFDrawPlanLayout #sFileB nil CG_KitType #sType)
              (setq CG_LAYOUT$ (cons "P" CG_LAYOUT$))
            )
            ;; 立面図
            ((= "S" #sView)
              (SCFDrawExpandLayout #sFileB nil CG_KitType #sType)
              (setq CG_LAYOUT$ (cons #sView2 CG_LAYOUT$))
            )
            ;; 仕様図
            ((= "Table" #sFileB)
              (SCFDrawTableLayout #sFileS nil)
              (setq CG_LAYOUT$ (cons "S" CG_LAYOUT$))
            )
          ) ;_cond

          ;シンボル図形削除
          (if DelSymEntity (DelSymEntity))

          (command "_.UNDO" "E")
        )
      ) ;_cond
    ) ;_while

    ; 01/12/09 HN E-MOD UNDO／キャンセル処理を追加
  ) ;_if

  ; 01/12/09 HN S-ADD キャンセル処理を追加
  (if (= "cancel" #sFileB)
    (repeat (length CG_LAYOUT$)
      (command "_.UNDO" "1")
    )
  ) ;_if
  ; 01/12/09 HN E-ADD キャンセル処理を追加

  ; 02/01/22 HN ADD 現在高度を15000に設定
  (setvar "ELEVATION" CG_LAYOUT_DIM_Z)

;ハッチング更新 取り付け桟のハッチングが塗りつぶしになるのを回避する
(CFRefreshHatchEnt) ;06/03/15 YM ADD

  ;03/11/12 YM ADD
  (SCAutoFDispOnOff)

  (setq *error* nil)
  (princ)
) ; C:KPInsertBlockT

;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetGroupName
;;; <処理概要>: グループ名称が指定されているか判定する
;;; <戻り値>  : 使用されていないグループ名称
;;;             末尾に"1"～"999"など番号文字を付加する
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SCFGetGroupName
  (
  &sGroup     ; グループ名称
  /
  #sGroup     ; グループ名称(戻り値)
  #vDict$     ; ディクショナリ内の項目内容
  #iCnt       ; カウンタ
  )
  (setq #sGroup &sGroup)
  (setq #vDict$ (dictsearch (namedobjdict) "ACAD_GROUP"))
  (setq #iCnt 1)

  (while (member (cons 3 #sGroup) #vDict$)
    (setq #sGroup (strcat &sGroup "_" (itoa #iCnt)))
    (setq #iCnt (1+ #iCnt)) ; 02/03/04 YM ADD
  )

  #sGroup
);_defun

;;;<HOM>************************************************************************
;;; <関数名>  : SCFDrawTableLayout
;;; <処理概要>: レイアウト図作成 仕様表
;;; <戻り値>  : なし
;;; <備考>    : なし
;;; <改訂>    : 01/06/23 HN 配置位置指定の場合、MOVEからBLOCK-INSERTに変更
;;;************************************************************************>MOH<
(defun SCFDrawTableLayout
  (
  &sMfile     ; 展開元図ファイル名
  &eEn        ; 領域図形名
  /
  #lasten #CG_SpecList$$ #ss_b #n1 #n2 #code #name #kind #ss #i #en #eg
  #1 #y2 #n110y #n111y #code10y #code11y #name10y #name11y #kind10y #kind11y
  #eg$ #10y$ #11y$ #dis #off #str$ #str #10y #11y #10 #11 #10_n #11_n #subst
  #ssv #ssh #y #dis10 #dis11 #pt #xSp #xSl #iI #eEn #dMin #dMax #dEm #Pt$ #dVm
  #dRScale
  #sBlock     ; ブロック名 01/06/23 HN ADD
  )
  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart) ; 02/06/11 YM ADD

  (setq #lasten (entlast))
  ;仕様表読込み
  (setq #CG_SpecList$$ (ReadCSVFile &sMfile))

  ;仕様表元図形挿入
  (command "_insert" (strcat CG_BLOCKPATH "Table.dwg") "0,0,0" 1 1 "0")
  (command "_explode" (entlast))
  (setq #ss_b (ssget "P"))
  (setq
    #n1       "S^N1"
    #n2       "S^N2"
    #LAST_HIN "S^最終品番"
    #WWW      "S^巾"
    #HHH      "S^高さ"
    #DDD      "S^奥行"
    #HINMEI   "S^品名"
  )
  (setq #ss (ssget "X" (list (cons 0 "TEXT")(cons 8 "0_TEXT")(cons 1 "S^*"))))
  (if (/= nil #ss)
    (progn
      ;図形データ取得
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #eg (entget #en))
        (setq #1  (cdr (assoc 1 #eg)))
        (cond
          ((equal #n2   #1)  (setq #y2    (cadr (cdr (assoc 10 #eg)))))
          ((equal #n1   #1)
            (setq #n1      #eg)
            (setq #n110y   (cadr (cdr (assoc 10 #eg))))
            (setq #n111y   (cadr (cdr (assoc 11 #eg))))
          )
          ((equal #LAST_HIN #1)
            (setq #LAST_HIN    #eg)
            (setq #LAST_HIN10y (cadr (cdr (assoc 10 #eg))))
            (setq #LAST_HIN11y (cadr (cdr (assoc 11 #eg))))
          )
          ((equal #WWW #1)
            (setq #WWW    #eg)
            (setq #WWW10y (cadr (cdr (assoc 10 #eg))))
            (setq #WWW11y (cadr (cdr (assoc 11 #eg))))
          )
          ((equal #HHH #1)
            (setq #HHH    #eg)
            (setq #HHH10y (cadr (cdr (assoc 10 #eg))))
            (setq #HHH11y (cadr (cdr (assoc 11 #eg))))
          )
          ((equal #DDD #1)
            (setq #DDD    #eg)
            (setq #DDD10y (cadr (cdr (assoc 10 #eg))))
            (setq #DDD11y (cadr (cdr (assoc 11 #eg))))
          )
          ((equal #HINMEI #1)
            (setq #HINMEI    #eg)
            (setq #HINMEI10y (cadr (cdr (assoc 10 #eg))))
            (setq #HINMEI11y (cadr (cdr (assoc 11 #eg))))
          )
          (T                 nil)
        )
        (entdel #en)
        (setq #i (1+ #i))
      )
      (setq #eg$  (list #n1    #LAST_HIN    #WWW    #HHH    #DDD    #HINMEI   ))
      (setq #10y$ (list #n110y #LAST_HIN10y #WWW10y #HHH10y #DDD10y #HINMEI10y))
      (setq #11y$ (list #n111y #LAST_HIN11y #WWW11y #HHH11y #DDD11y #HINMEI11y))
      ;y軸方向の距離
      (setq #dis (abs (- #y2 (cadr (cdr (assoc 10 #n1))))))
      (setq #off 0)

      ; 01/10/30 YM ADD-S 文字列[S:AG]-->""とする
;;;01/12/07YM@MOD     (setq #CG_SpecList$$ (KP_DelDrSeri #CG_SpecList$$ 2)) ; 扉ｶﾗｰがﾀﾞﾌﾞる不具合修正
      ; 01/10/30 YM ADD-E

      ;文字列作図

      (mapcar
       '(lambda ( #str$ )
          (setq #i 0)
          (mapcar
           '(lambda ( #str #eg #10y #11y)

;;;              (if (= 3 #i)
;;;                (setq #str (substr #str 2))
;;;              )

;;;             ; 01/06/20 YM ADD NAS 独自処理 START
;;;              (if (= 1 #i)
;;;               (progn
;;;                 (setq #LR (NPGetLR #str))
;;;                 (setq #str (NPAddHinDrCol2 #str #LR))
;;;
;;;               )
;;;              );_if
;;;             ; 01/06/20 YM ADD NAS 独自処理 END

              (setq #10 (cdr (assoc 10 #eg)))
              (setq #11 (cdr (assoc 11 #eg)))
              (setq #10_n (list (car #10) (- #10y #off) (caddr #10)))
              (setq #11_n (list (car #11) (- #11y #off) (caddr #11)))
              (setq #subst (subst (cons 10 #10_n) (assoc 10 #eg) #eg))
              (setq #subst (subst (cons 11 #11_n) (assoc 11 #subst) #subst))
              (setq #subst (subst (cons 1  #str)  (assoc  1 #subst) #subst))
              (entmake (cdr #subst))
              (ssadd (entlast) #ss_b)
              (setq #i (1+ #i))

            )
            #str$ #eg$ #10y$ #11y$
          )
          (setq #off (+ #dis #off))
        )
        #CG_SpecList$$
      )

    )
    (progn
      (CFOutStateLog 0 51 "SAMPLE文字列がありません")
    )
  )

  ;線分作図
  (setq #ssv (ssget "X" (list (list -3 (list "G_VLINE")))))
  (setq #ssh (ssget "X" (list (list -3 (list "G_HLINE")))))
  (setq #eg (entget (ssname #ssh 0)))
  (setq #10 (cdr (assoc 10 #eg)))
  (setq #11 (cdr (assoc 11 #eg)))
  (setq #off #dis)
  (repeat (length #CG_SpecList$$)
    (setq #10_n (list (car #10) (- (cadr #10) #off) (caddr #10)))
    (setq #11_n (list (car #11) (- (cadr #11) #off) (caddr #11)))
    (setq #subst (subst (cons 10 #10_n) (assoc 10 #eg) #eg))
    (setq #subst (subst (cons 11 #11_n) (assoc 11 #subst) #subst))
    (entmake (cdr #subst))
    (ssadd (entlast) #ss_b)
    (setq #off (+ #dis #off))
  )
  (setq #y (cadr #10_n))

	; 2013/09/11 YM ADD 注釈文字を追加する Errmsg.ini参照
;	(NS_AddTableMoji) ;移動

  (setq #i 0)
  (repeat (sslength #ssv)
    (setq #en (ssname #ssv #i))
    (setq #eg (entget #en '("*")))
    (setq #10 (cdr (assoc 10 #eg)))
    (setq #11 (cdr (assoc 11 #eg)))
    (setq #dis10 (abs (- #y (cadr #10))))
    (setq #dis11 (abs (- #y (cadr #11))))
    (if (< #dis10 #dis11)
      (progn
        (setq #pt (list (car #10) #y (caddr #10)))
        (setq #subst (subst (cons 10 #pt) (cons 10 #10) #eg))
      )
      (progn
        (setq #pt (list (car #11) #y (caddr #11)))
        (setq #subst (subst (cons 11 #pt) (cons 11 #11) #eg))
      )
    )
    (entmod #subst)
    (setq #i (1+ #i))
  )

  ;仕様表図形獲得
  (setq #xSp (ssadd))
  (while (setq #lasten (entnext #lasten))
    (ssadd #lasten #xSp)
  )

  ; 2000/05/30 土屋 領域挿入基点を中心から右上に変更 かつ 尺度調整する
  ;図形中点獲得
  ;(setq #xSl (ssget "X" (list (list -3 (list "G_VLINE")))))
  ;(setq #iI 0)
  ;(repeat (sslength #xSl)
  ;  (setq #eEn (ssname #xSl #iI))
  ;  (cond
  ;    ((= 0 (nth 0 (CfGetXData #eEn "G_VLINE")))
  ;      (setq #dMin (cdr (assoc 11 (entget #eEn))))
  ;    )
  ;    ((= 4 (nth 0 (CfGetXData #eEn "G_VLINE")))
  ;      (setq #dMax (cdr (assoc 10 (entget #eEn))))
  ;    )
  ;    (T
  ;      nil
  ;    )
  ;  )
  ;  (setq #iI (1+ #iI))
  ;)
  ;(setq #dEm (mapcar '* '(0.5 0.5 1.0) (mapcar '+ #dMin #dMax)))
  ;;領域中点獲得
  ;(setq #Pt$  (mapcar 'car (get_allpt_H &eEn)))
  ;(setq #dMin (list (apply 'min (mapcar 'car #Pt$)) (apply 'min (mapcar 'cadr #Pt$))))
  ;(setq #dMax (list (apply 'max (mapcar 'car #Pt$)) (apply 'max (mapcar 'cadr #Pt$))))
  ;(setq #dVm  (mapcar '* '(0.5 0.5 1.0) (mapcar '+ #dMin #dMax)))

  ;図形右上点獲得
  (setq #xSl (ssget "X" (list (list -3 (list "G_VLINE")))))
  (setq #iI 0)
  (repeat (sslength #xSl)
    (setq #eEn (ssname #xSl #iI))
    (cond
      ((= 0 (nth 0 (CfGetXData #eEn "G_VLINE")))
        (setq #dMin (cdr (assoc 11 (entget #eEn))))
      )
      ((= 4 (nth 0 (CfGetXData #eEn "G_VLINE")))
        (setq #dMax (cdr (assoc 10 (entget #eEn))))
      )
      (T
        nil
      )
    )
    (setq #iI (1+ #iI))
  )
  (setq #dEm #dMax)
  ;領域右上点獲得
  (setq #Pt$  (mapcar 'car (get_allpt_H &eEn)))
  (setq #dMax (list (apply 'max (mapcar 'car #Pt$)) (apply 'max (mapcar 'cadr #Pt$))))
  (setq #dVm #dMax)

  ; 01/03/02 HN S-DEL 尺度変更処理を削除
  ;DEL;尺度を変更する (Table.dwg は30で作成)   2000/05/29 土屋変更
  ;DEL(setq #dRScale (/ (SCFGetWakuScale) 30.))
  ;DEL(command "._scale" #xSp "" #dEm #dRScale)
  ; 01/03/02 HN E-DEL 尺度変更処理を削除

  ;図形移動
  ; 01/06/23 HN S-MOD フリー配置の移動方法を変更
  ;@MOD@; 01/05/09 HN MOD フリーテンプレートの場合、移動先指示に変更
  ;@MOD@;@MOD@(command "_move" #xSp "" #dEm #dVm)
  ;@MOD@(if &eEn
  ;@MOD@  (command "_MOVE" #xSp "" #dEm #dVm )
  ;@MOD@  (command "_MOVE" #xSp "" #dEm PAUSE)
  ;@MOD@)
  (if &eEn
    (progn
      (command "_MOVE" #xSp "" #dEm #dVm)
    )
    (progn
      (setq #sBlock "TableB")
      (command "_BLOCK"  #sBlock #dEm #xSp "")
      (command "_INSERT" #sBlock PAUSE 1 1 "0")
      (command "_explode" (entlast))
      (setq #xSp (ssget "P"))
    )
  ) ;_if
  ; 01/06/23 HN S-MOD フリーテンプレートの移動方法を変更

  ; 01/05/09 HN S-ADD 仕様表のグループ化処理を追加
  (setq #sGroup "TABLE")
  ; 02/01/22 HN ADD グループ名称のチェック処理を追加
  (setq #sGroup (SCFGetGroupName #sGroup))
  (command
    "-GROUP"    ; オブジェクト グループ設定
    "C"         ; 作成
    #sGroup     ; グループ名
    #sGroup     ; グループ説明
    #xSp     ; オブジェクト
    ""
  )
  ; 01/05/09 HN E-ADD 仕様表のグループ化処理を追加


  ;// Ｏスナップ関連システム変数を元に戻す
  (CFNoSnapEnd) ; 02/06/11 YM ADD

  (princ)
) ; SCFDrawTableLayout

;;;<HOM>************************************************************************
;;; <関数名>  : NS_AddTableMoji
;;; <処理概要>: レイアウト図作成 仕様表の下に注釈文を追加する
;;; <戻り値>  : なし
;;; <備考>    : Errmsg.iniを参照する
;;;************************************************************************>MOH<
(defun NS_AddTableMoji (
;  &y  ; 書き出し位置(Y座標)
	&sTmp ;テンプレート名 尺度を求めるの使用
  /
  #I #KOSU #STR #Y #clayer #info_HIKITE #info_TEXT #info_POS
  #HEIGHT #INFO_HHH #RET$ #X #os
	#INFO_H_20 #INFO_H_30 #INFO_H_40 #INFO_POS_20 #INFO_POS_30 #INFO_POS_40
  )

  (setq #info_HIKITE (CFgetini "NOTES" "HIKITE"   (strcat CG_SKPATH "ERRMSG.INI")))

	;2020/01/07 YM MOD 引き手記号カンマ区切り対応  #info_HIKITE = "X,ZA,ZB"
;;;	(if (= CG_HIKITE #info_HIKITE)
	(if (wcmatch CG_HIKITE #info_HIKITE)
		(progn
			;OSNAP解除
		  (setq #os (getvar "OSMODE"))
		  (setvar "OSMODE" 0)

		  (setq #info_TEXT   (CFgetini "NOTES" "TEXT"     (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_POS_20 (CFgetini "NOTES" "POS_1_20" (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_POS_30 (CFgetini "NOTES" "POS_1_30" (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_POS_40 (CFgetini "NOTES" "POS_1_40" (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_H_20   (CFgetini "NOTES" "H_1_20"   (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_H_30   (CFgetini "NOTES" "H_1_30"   (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_H_40   (CFgetini "NOTES" "H_1_40"   (strcat CG_SKPATH "ERRMSG.INI")))

		  (if (and #info_HIKITE #info_TEXT)
		    (progn
		      ;一時的に"0"画層にする
		      (setq #clayer (getvar "CLAYER")); 現在の画層をキープ
		      (command "_layer" "S" "0" ""   ); 現在画層の変更

					;尺度によって座標を変換
					(cond
						((vl-string-search "-20-" &sTmp)
				      (setq #ret$ (StrParse #info_POS_20 ","))
				      (setq #X (atof (car   #ret$)))
				      (setq #Y (atof (cadr  #ret$)))
							(setq #Height (atof #info_H_20));文字高さ
					 	)
						((vl-string-search "-30-" &sTmp)
				      (setq #ret$ (StrParse #info_POS_30 ","))
				      (setq #X (atof (car   #ret$)))
				      (setq #Y (atof (cadr  #ret$)))
							(setq #Height (atof #info_H_30));文字高さ
					 	)
						((vl-string-search "-40-" &sTmp)
				      (setq #ret$ (StrParse #info_POS_40 ","))
				      (setq #X (atof (car   #ret$)))
				      (setq #Y (atof (cadr  #ret$)))
							(setq #Height (atof #info_H_40));文字高さ
					 	)
						(T
							nil ;	座標はそのまま
					 	)
					);_cond

					;文言作図
		      (command "._TEXT" "S" "STANDARD" (list #X #Y) #Height 0.0  #info_TEXT) ; 文字高さ,角度

		      ; 一時的に"0"画層にする
		      (setvar "CLAYER" #clayer) ; 元の画層に戻す
		    )
		  );_if

		  (setvar "OSMODE" #os)
    )
  );_if
  (princ)
);NS_AddTableMoji

; 02/01/19 HN S-ADD パース図のカメラ視点をシンクキャビネットの配置角度で判断
;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetAngSinkCab
;;; <処理概要>: シンクキャビネット(性格CODE=112)の配置角度を取得
;;; <戻り値>  : 角度(-180～+180)
;;; <作成>    : 2002/01/18 HN
;;; <備考>    : 複数存在する場合は、最後に検索したシンクキャビネットの配置角度
;;;             角度は-180～+180で
;;;************************************************************************>MOH<
(defun SCFGetAngSinkCab
  (
  /
  #rAng       ; 配置角度
  #iSinkCab   ; シンクキャビネットの性格CODE
  #iCnt       ; カウンタ
  #psLSYM     ; 部材の選択セット
  #vLSYM$     ; 部材のシンボル情報
  )
  (setq #rAng     0.0)
  (setq #iSinkCab 112)
  (setq #iCnt       0)

  (setq #psLSYM (ssget "X" (list (list -3 (list "G_LSYM")))))
  (if #psLSYM
    (repeat (sslength #psLSYM)
      (if (setq #vLSYM$ (CFGetXData (ssname #psLSYM #iCnt) "G_LSYM"))
        (if (= #iSinkCab (nth 9 #vLSYM$))
          (setq #rAng (* 180.0 (/ (nth 2 #vLSYM$) PI)))
        );_if
      );_if
      (setq #iCnt (1+ #iCnt))
    );_repeat
  );_if

  (if (< 180 #rAng)
    (setq #rAng (- #rAng 360))
  )

  #rAng
);_defun
; 02/01/19 HN E-ADD パース図のカメラ視点をシンクキャビネットの配置角度で判断

;;;<HOM>************************************************************************
;;; <関数名>  : C:SCFConf
;;; <処理概要>: 図面確認 ---->図面参照
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun C:SCFConf (
  /
  #iOk #sFname
#sFname2 #ver ;-- 2011/10/06 A.SAtoh Add
  )
  (setq CG_SCFConf T) ; 02/03/04 YM

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 前処理
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (StartUndoErr)
  )
	;_if
  ; 01/09/03 YM ADD-E UNDO処理追加

;;;01/09/03YM@MOD  (StartCmnErr)
;;;(makeERR "図面参照-1") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 図面参照-1
  (if (/= nil CG_KENMEI_PATH)
    (progn

      ;保存確認

      ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは保存しない ;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
;;;     (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"追加 03/02/22 JPGﾚｲｱｳﾄﾓｰﾄﾞ
      (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
    ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
        (setq #iOk nil)
        (setq #iOk (CFYesNoDialog "図面を一度保存しますか？"))
      );_if
      ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは保存しない

      (if (= T #iOK)
        (progn
          (SKB_WriteColorList);00/06/27 SN ADD
;;;03/04/18YM@MOD          (command "_.save" (strcat (getvar "dwgprefix") (getvar "dwgname")));00/06/21 SN MOD
          ;(command "qsave");00/06/21 SN MOD
;-- 2011/10/06 A.Satoh Add - S
;;;;;          (command "_.QSAVE")
;;;;;          (if (wcmatch (getvar "CMDNAMES") "*QSAVE*")
;;;;;            (command "2000" "")
;;;;;          )
          (setq #sFname2 (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
          (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
                  (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
            (setq #ver CG_DWG_VER_MODEL)
            (setq #ver CG_DWG_VER_SEKOU)
          )
          (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/06 A.Satoh Add - E
        )
      )
      ; 現在の件名のOUTPATフォルダをデフォルト表示する

      ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは図面参照しない;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
;;;     (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"追加 03/02/22 JPGﾚｲｱｳﾄﾓｰﾄﾞ
      (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
    ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
        (setq #sFname CG_AUTOMODE_ZUMEN)
        (setq #sFname (getfiled "図面参照" (strcat CG_KENMEI_PATH "OUTPUT\\") "dwg" 2))
      );_if
      ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞでは図面参照しない

      (if (/= nil #sFname)
        (progn

          ;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
;;;         (if (or (= CG_AUTOMODE 2)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/31 YM ADD "4"追加 03/02/22 JPGﾚｲｱｳﾄﾓｰﾄﾞ
          (if (member CG_AUTOMODE '(2 4 5));2008/08/05 YM MOD
            nil ; WEB版CADｻｰﾊﾞｰﾓｰﾄﾞは切り替えない "4" JPG出力ﾓｰﾄﾞも同様
            ;// 編集メニューに切り替える
            (ChgSystemCADMenu "")
          );_if

          ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞではSCFCmnFileOpenが効かない;ﾌﾟﾗﾝﾆｸﾞｼｰﾄJPG出力04/09/13 YM ADD CG_AUTOMODE=5追加
;;;         (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"追加 03/02/22 JPGﾚｲｱｳﾄﾓｰﾄﾞ
          (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
        ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
            (progn
;-- 2011/10/06 A.Satoh Mod - S
;;;;;              (command ".qsave")
              (setq #sFname2 (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
              (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
                      (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
                (setq #ver CG_DWG_VER_MODEL)
                (setq #ver CG_DWG_VER_SEKOU)
              )
              (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/06 A.Satoh Mod - S
              (command "_.Open"     #sFName)

              (S::STARTUP)

            )
            (progn
              ; 2000/10/19 HT 関数化
              ;2011/08/12 YM ADD 図面参照のときだけﾌﾗｸﾞを立てる
;;;             (setq CG_SCFConf T)
              (SCFCmnFileOpen #sFName 1) ; 2000/10/19 HT 関数化
;;;             (setq CG_SCFConf nil)
            )
          );_if
          ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞではSCFCmnFileOpenが効かない

        )
      )
    )
    (progn
      (CFAlertMsg "物件が呼び出されていません.")
    )
  )
    
  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 後処理
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (setq *error* nil)
  );_if
  ; 01/09/03 YM ADD-E UNDO処理追加

  (princ)
);C:SCFConf



;;;<HOM>************************************************************************
;;; <関数名>  : subSCFConf
;;; <処理概要>: 図面参照で開いたﾊﾟｰｽ図でﾊﾟｰｽﾋﾞｭｰの設置を行う
;;; <戻り値>  : なし
;;; <備考>    : 2011/08/12 YM ADD
;;;************************************************************************>MOH<
(defun subSCFConf (
  /
  #8 #EG$ #I #SSVIEW #VID69L #VID69R
  )
  (setvar "pdmode" 0) ;2011/09/30 YM ADD

  (if CG_SCFConf
    (progn ;図面参照のとき
      (setq CG_SCFConf nil)

      ;2011/08/11 YM ADD-S ﾊﾟｰｽ図のとき平行投影図になってしまう
      (if (vl-string-search "1-立体" (strcase (getvar "DWGNAME")))
        (progn
          ;浮動モデル空間に移動
          (setvar "TILEMODE" 0)
          (command "_.MSPACE")
          (setvar "PERSPECTIVE" 1)
;;;          (command "_.ZOOM" "E")
          (setvar "pdmode" 0) ;2011/09/30 YM ADD
          (command "_.PSPACE");2011/09/30 YM ADD
          (command "_REGEN");2011/09/30 YM ADD
        )
      );_if


      (if (vl-string-search "2-立体" (strcase (getvar "DWGNAME")))
        (progn
          (setvar "TILEMODE" 0)
          (command "_.MSPACE")

          ;対面用2ﾋﾞｭｰﾊﾟｰｽ向き調整対応
          ;対面用ﾋﾞｭｰﾎﾟｰﾄがあるかどうか検索
          (setq #ssVIEW (ssget "X" '((0 . "VIEWPORT"))))
          (setq #i 0)
          (if (and #ssVIEW (< 0 (sslength #ssVIEW)))
            (progn
              (repeat (sslength #ssVIEW)
                (setq #eg$ (entget (ssname #ssVIEW #i)))
                (setq #8 (cdr (assoc  8 #eg$)));画層
                (if (= #8 "VIEWL");対面用ﾃﾝﾌﾟﾚｰﾄのﾋﾞｭｰﾎﾟｰﾄ画層(左側ｷｯﾁﾝ)
                  (progn
                    (setq #VID69L (cdr (assoc 69 #eg$))) ; VIEWPORT ID
                  )
                );_if
                (if (= #8 "VIEWR");対面用ﾃﾝﾌﾟﾚｰﾄのﾋﾞｭｰﾎﾟｰﾄ画層(右側ﾘﾋﾞﾝｸﾞ)
                  (progn
                    (setq #VID69R (cdr (assoc 69 #eg$))) ; VIEWPORT ID
                  )
                );_if
                (setq #i (1+ #i))
              )
            )
          );_if

          (setvar "CVPORT" #VID69L); ﾋﾞｭｰﾎﾟｰﾄID (左側ｷｯﾁﾝ)に切り替えてﾋﾞｭｰの調整
;;;          (command "_.MSPACE")
          (setvar "PERSPECTIVE" 1)
;;;          (command "_.ZOOM" "E")
          (setvar "pdmode" 0) ;2011/09/30 YM ADD
;;;          (command "_.PSPACE");2011/09/30 YM ADD
          (command "_REGEN");2011/09/30 YM ADD

          (setvar "CVPORT" #VID69R); ﾋﾞｭｰﾎﾟｰﾄID (右側ﾘﾋﾞﾝｸﾞ)に切り替えてﾋﾞｭｰの調整
;;;          (command "_.MSPACE")
          (setvar "PERSPECTIVE" 1)
;;;          (command "_.ZOOM" "E")
          (setvar "pdmode" 0) ;2011/09/30 YM ADD
          (command "_.PSPACE");2011/09/30 YM ADD
          (command "_REGEN");2011/09/30 YM ADD
        )
      );_if

      ;2011/08/11 YM ADD-E ﾊﾟｰｽ図のとき平行投影図になってしまう

    )
  );_if

  (princ)
);subSCFConf

;;;<HOM>************************************************************************
;;; <関数名>    : C:SCFConfEnd
;;; <処理概要>  : 物件に戻る
;;; <戻り値>    : なし
;;; <備考>      : なし
;;;************************************************************************>MOH<
(defun C:SCFConfEnd (
  /
  #iOk #sFname
#DWGNAME #KAKUTYO #MSG #QUIT_FLG #STRLEN ; 02/10/18 YM ADD
#sFname2 #ver ;-- 2011/10/06 A.Satoh Add
  )
  ; 02/10/18 YM ADD-S
  (setq #quit_flg nil) ; T==>処理何もせずにを終了するフラグ
  ; 02/10/18 YM ADD-E

  (if (/= nil CG_KENMEI_PATH)
    (progn
      ;保存確認

      ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは保存しない
;;;     (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
      (if (member CG_AUTOMODE '(1 2 3));2008/08/05 YM MOD
    ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
        (setq #iOk T)
        ; 02/10/18 YM MOD-S DXF形式で保存した後は再度保存させない
        (progn
          ; 現在の図面の拡張子で分岐する
          (setq #dwgname (getvar "dwgname"))
          (setq #strlen (strlen #dwgname))
          (setq #kakutyo (substr #dwgname (- #strlen 2) 3))
          (if (= #kakutyo "dwg") ; 通常の場合
            (progn
              (setq #iOk (CFYesNoDialog "図面を一度保存しますか？"))
            )
            (progn ; それ以外"dwt",dxf"
              (if (= #kakutyo "dwt")
                (setq #msg (strcat "図面は保存されませんがよろしいですか？"
                            "\nﾃﾝﾌﾟﾚｰﾄの保存には必ず、[ﾕｰｻﾞｰﾃﾝﾌﾟﾚｰﾄ][ﾕｰｻﾞｰﾃﾝﾌﾟﾚｰﾄ保存]をお使いください"))
              ; else
                (setq #msg "図面は保存されませんがよろしいですか？")
              );_if

              (if (CFYesNoDialog #msg)
                (setq #iOk nil)    ; 図面を保存せずに終了
              ; else
                (setq #quit_flg T) ; 処理何もせずにを終了
              );_if
            )
          );_if

        )
      );_if


      (if #quit_flg ; 02/10/18 YM ADD #quit_flgで分岐するように修正
        nil ; 何もしない
      ; else
        (progn

          (if (= T #iOK)
            (progn
;;;03/04/18YM@MOD             (command "_.save" (strcat (getvar "dwgprefix") (getvar "dwgname")));00/06/21 SN MOD
;-- 2011/10/05 A.Satoh Add - S
;;;;;              ; 03/04/18 YM MOD-S
;;;;;              (command "_.QSAVE")
;;;;;              (if (wcmatch (getvar "CMDNAMES") "*QSAVE*")
;;;;;                (command "2000" "")
;;;;;              )
;;;;;              ; 03/04/18 YM MOD-E
;;;;;
;;;;;              ;(command "qsave");00/06/21 SN MOD
              (setq #sFname2 (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
              (if (or (= (strcase (getvar "DWGNAME")) "MODEL.dwg")
                      (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
                (setq #ver CG_DWG_VER_MODEL)
                (setq #ver CG_DWG_VER_SEKOU)
              )
              (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/05 A.Satoh Add - E
            )
          );_if

          (setq #sFname (strcat CG_KENMEI_PATH "MODEL.dwg"))
          ;// 編集メニューに切り替える
          (ChgSystemCADMenu CG_PROGMODE)

          ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞではSCFCmnFileOpenが効かない
;;;         (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
          (if (member CG_AUTOMODE '(1 2 3));2008/08/05 YM MOD
            (progn
;-- 2011/10/06 A.Satoh Mod - S
;;;;;              (command ".qsave")
              (setq #sFname2 (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
              (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
                      (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
                (setq #ver CG_DWG_VER_MODEL)
                (setq #ver CG_DWG_VER_SEKOU)
              )
              (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/06 A.Satoh Mod - E
              (command "_.Open" #sFName)
              (setq CG_OpenMode nil)
              (S::STARTUP)
            )
            ; 2000/10/19 HT 関数化
            (SCFCmnFileOpen #sFName 1) ; 2000/10/19 HT 関数化
          );_if
          ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞではSCFCmnFileOpenが効かない


        )
      );_if

    )
    (progn
      (CFAlertMsg "物件が呼び出されていません.")
    )
  );_if

  ; 02/10/18 YM ADD-S
  (setq #quit_flg nil) ; T==>処理何もせずにを終了するフラグ
  ; 02/10/18 YM ADD-E

  (princ)
);C:SCFConfEnd

(princ)
;;;End of File
