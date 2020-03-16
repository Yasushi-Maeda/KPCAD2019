;;; (defun C:ConfWkTop
;;; (defun C:ConfParts
;;; (defun SC_Conf
;;; (defun PcConfItemNoLSYM
;;; (defun SC_ConfParts

;;; (defun SKY_PartsInfoDialog
;;; (defun PC_ConfWKTop2
;;; (defun PKY_WKTopInfoDialog
;;; (defun PcGetPrintNameH800

;<HOM>*************************************************************************
; <関数名>    : C:ConfWkTop
; <処理概要>  : 設備部材の確認（WORKTOP)
; <戻り値>    :
; <作成>      : 2000-01-26
; <備考>      :
;*************************************************************************>MOH<
(defun C:ConfWkTop ()
  (StartCmnErr)
  (SC_Conf)
  (setq *error* nil)
  (princ)
)
;C:ConfWkTop

;<HOM>*************************************************************************
; <関数名>    : C:ConfParts
; <処理概要>  : 設備部材の確認（LSYM)
; <戻り値>    :
; <作成>      : 2000-01-26
; <備考>      :
;*************************************************************************>MOH<
(defun C:ConfParts ()
  (setq CG_CHG_COL nil) ; 色替え中なら'T
  (StartCmnErr)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;00/09/07 SN S-ADD
      (defun ConfPartsCmnErr ( &msg )
        (CFCmdDefFinish)
        (if CG_CHG_COL ; 01/01/22 YM ADD 色替え中なら'T
          (command "_undo" "b") ; 色替え中
        );_if
        (setq *error* nil)
        (setq CG_CHG_COL nil) ; 色替え中なら'T
        (princ)
      )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq *error* ConfPartsCmnErr)
  (CFCmdDefBegin 6)
  ;00/09/07 SN E-ADD
  (SC_Conf)
  (CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  (setq CG_CHG_COL nil) ; 色替え中なら'T
  (princ)
)
;C:ConfParts

;<HOM>*************************************************************************
; <関数名>    : SC_Conf
; <処理概要>  : アイテム確認 "G_WRKT" "G_FILR" "G_BKGD" "RECT" "G_ROOM" "G_LSYM"
; <戻り値>    : なし
; <作成>      : 2000-01-26 → 01/04/03 MH MOD (全面変更)
; <備考>      :
;*************************************************************************>MOH<
(defun SC_Conf ( / #en #xd$ )
  (setq #en T)
  (while #en
    (setq #en (car (entsel "\n確認するアイテムを選択: ")))
    (cond
      ((not #en) (princ))
      ((setq #xd$ (CFGetXData #en "G_WRKT")) (PC_ConfWKTop2 #en))
      ((setq #xd$ (CFGetXData #en "G_BKGD"));バッグガードはまだPcConfItemNoLSYMに渡さない
        (CFYesDialog (strcat "バックガード品番: [" (nth 0 #xd$) "]")))
      ((or (CFGetXData #en "G_FILR")(CFGetXData #en "G_BKGD"))(PcConfItemNoLSYM #en))
      ((CFGetXData #en "RECT")   (CFYesDialog "矢視領域  　　"))
      ((CFGetXData #en "G_ROOM") (CFYesDialog "間口領域　　  "))
      (T (setq #en (CFSearchGroupSym #en)) ; G_LSYM を持つアイテムの処理
         (if #en (SC_ConfParts #en)) )
    ); cond
  ); while
  (princ)
);SC_Conf

;<HOM>*************************************************************************
; <関数名>    : PcConfItemNoLSYM
; <処理概要>  : アイテム情報表示 "G_FILR" "G_BKGD"
; <戻り値>    : なし
; <作成>      : 01/03/28 MH
; <備考>      : 処理が似てるので一緒にした
;*************************************************************************>MOH<
(defun PcConfItemNoLSYM (
  &eEN
  /
  #xd$ #OPT$ #sOUTNAM #sHIN #ZQLY$ #INF$ #en #TOPflg #wtxd$ #setH #PLPT$ #setH
  #symType ; 2011/12/22 山田 追加
  )

  (cond
    ; フィラー扱いアイテム処理
    ((setq #xd$ (CFGetXData &eEN "G_FILR"))
      ; LWポリ線があるものはその高度、それ以外は0
      (cond
        ((setq #setH (cdr (assoc 38 (entget (nth 2 #xd$))))))
        (t (setq #setH 0))
      ); cond
      (setq #sOUTNAM "天井フィラー")
      (setq #sHIN (car #xd$))
      (setq #ZQLY$ (PcGetPartQLY$ "品番図形" #sHIN nil 0))
      (setq #INF$ (list
        #sHIN
        "Z"   ; 左右別
        #setH     ; Z値
        (nth 3 #ZQLY$);2008/06/28 OK!
        (nth 4 #ZQLY$);2008/06/28 OK!
        (nth 5 #ZQLY$);2008/06/28 OK!
        ""  ;扉開きID   ;2008/06/28 OK!
        (if (nth 6 #ZQLY$) (nth 6 #ZQLY$) "")   ;図形ID    ;2008/06/28 OK!
      )) ; if setq
      (setq #OPT$ (CFGetXData &eEN "G_OPT"))
      (if (= 'LIST (type #OPT$)) (setq #OPT$ (cdr #OPT$)))
      (command "_.undo" "m")
      (setq CG_CHG_COL T) ; 01/01/22 YM ADD 色替え中なら'T
      (command "_.chprop" &eEN "" "C" CG_ConfSymCol ""); 00/10/26 MOD MH "_change" 変更
      ; ダイアログ表示
;;;      (PKY_PartsInfoDialog #INF$ #OPT$ #sOUTNAM nil nil) ; 03/06/17 YM ADD 引数追加(末尾)
;;; ↓2011/12/22 山田 変更・追加 -------------------------------
;;;      (PKY_PartsInfoDialog #INF$ #OPT$ #sOUTNAM nil nil nil) ; 03/10/12 YM ADD 引数"G_LSYM"追加(末尾)
      (if (/= nil #xd$)
        (setq #symType (nth 7 #xd$))
        (setq #symType nil)
      )
      ; 引数 分類 追加(末尾)
      (setq #symType (PKY_PartsInfoDialog #INF$ #OPT$ #sOUTNAM nil nil nil #symType))
;;; ↑2011/12/22 山田 変更・追加 -------------------------------
      (command "_.undo" "b")
;;; ↓2011/12/22 山田 追加 -------------------------------
      (if (/= nil #symType)
        (progn
          (setq #xd$ (CFModList #xd$ (list (list 7 #symType))))
          (CFSetXData &eEN "G_FILR" #xd$)
        )
      )
;;; ↑2011/12/22 山田 追加 -------------------------------
      (setq CG_CHG_COL nil) ; 01/01/22 YM ADD 色替え中なら'T
    )
    ; バックガード、トップ飾りの処理
    ((setq #xd$ (CFGetXData &eEN "G_BKGD"))
      (setq #TOPflg (= 1 (nth 5 #xd$)))
      (setq #sOUTNAM (if #TOPflg "トップ飾り" "バックガード"))
      (setq #wtxd$ (CFGetXData (nth 2 #xd$) "G_WRKT"))
      (setq #sHIN (car #xd$))
      (setq #INF$ (list
        #sHIN
        "Z"   ; 左右別
        (+ (nth 8 #wtxd$) (nth 10 #wtxd$))  ; 挿入点のZ値
        (nth 3 #xd$)     ; W
        (if #TOPflg 140 20) ; D
        (if #TOPflg  60 50) ; H
        ""   ;扉開きID
        ""   ;図形ID
      )) ; if setq
;;;      (PKY_PartsInfoDialog #INF$ nil #sOUTNAM nil nil) ; 03/06/17 YM ADD 引数追加(末尾)
;;;      (PKY_PartsInfoDialog #INF$ #OPT$ #sOUTNAM nil nil nil) ; 03/10/12 YM ADD 引数"G_LSYM"追加(末尾)
      (PKY_PartsInfoDialog #INF$ #OPT$ #sOUTNAM nil nil nil nil) ; 2011/12/22 山田 引数 分類 追加(末尾)
    )
    (t (princ))
  ); cond
);PcConfItemNoLSYM

;;;<HOM>*************************************************************************
;;; <関数名>    : SC_ConfParts
;;; <処理概要>  : アイテム情報(配置部材図形の情報)表示
;;; <戻り値>    :
;;; <作成>      : 1999-11-19
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun SC_ConfParts (
   &enSym
  /
  #en #xd1$ #xd2$ #xd3$ #lst$ #w #d #h #loop #ss #oplst$ #FIG$ #OUTNAME #HIN850
  #gent$ ; 00/08/29 SN ADD
  #sDoorFigID   ;扉開きID 00/09/07 HN ADD
  #SNK_ANA #XDKUTAI$
#DRINFO #DRINFO$ #HANDLE #XDTOKU$ ; 02/11/30 YM ADD
#XDLSYM$ #XDOPT2$ ;2010/01/08 YM ADD
  #symType ; 2011/12/22 山田 追加
  )

  ;// ベースキャビネットの指示
  (command "_.undo" "m")
  (setq CG_CHG_COL T) ; 01/01/22 YM ADD 色替え中なら'T

  (setq #ss (CFGetSameGroupSS &enSym))
;  (command "_.change" #ss "" "P" "C" CG_ConfSymCol "")
  ; 00/10/26 MOD MH "_change" はUCS に平行でない図形が漏れるため
  (command "_.chprop" #ss "" "C" CG_ConfSymCol "")


  (setq #xd1$ (CFGetXData &enSym "G_LSYM"))
  (setq #xd2$ (CFGetXData &enSym "G_SYM"))
  (setq #xdKUTAI$ (CFGetXData &enSym "G_KUTAI"))
  (setq #xdTOKU$  (CFGetXData &enSym "G_TOKU"))

  (setq #gent$ (entget &enSym));00/08/29 SN ADD
  (setq #HIN850 (nth 5 #xd1$)) ; 品番名称
  (setq #outname (PcGetPrintNameH800 #HIN850 (nth 9 #xd1$))) ; 品番名称--->出力名称

  ; 02/07/10 YM ADD-S
  (if (and #xdTOKU$ (nth 8 #xdTOKU$))
    (setq #outname (nth 8 #xdTOKU$)) ; newﾀｲﾌﾟ特注ｷｬﾋﾞはﾕｰｻﾞｰ入力品名を表示する
  );_if
  ; 02/07/10 YM ADD-E

  (if #xdTOKU$
    (setq #HIN850 (nth 0 #xdTOKU$)) ; 特注ｷｬﾋﾞ,ｹｺﾐ伸縮ｷｬﾋﾞの場合品番を変更
  );_if


  (setq #DrInfo (nth 7 #xd1$)) ; 扉ｼﾘ,扉ｶﾗ,取手
  (setq #DrInfo$ (StrtoLisByBrk  #DrInfo ",")) ; 文字列を","で区切ってﾘｽﾄ化する
  (setq #Handle (caddr #DrInfo$)) ; 取手記号( or nil)

  ; くたいの場合"G_SYM","G_LSYM" 01/02/22 YM ADD
  (if #xdKUTAI$
    nil
    (progn
      (setq #fig$
        (CFGetDBSQLRec CG_DBSESSION "品番図形"
          (list
            (list "品番名称" (nth 5 #xd1$) 'STR)
            (list "LR区分"   (nth 6 #xd1$) 'STR)
            (list "用途番号" (itoa (nth 12 #xd1$)) 'INT) ;00/09/21 MH ADD
          )
        )
      )
      (setq #fig$ (DBCheck #fig$ "『品番図形』" "SC_ConfParts"))
    )
  );_if

  (setq #w (nth 3 #xd2$))
  (setq #d (nth 4 #xd2$))
  (setq #h (nth 5 #xd2$))


  ;HOPE-0140 00/09/07 HN ADD G_LSYMの扉図形IDが"none"の場合はDBより取得
  (if #xdKUTAI$
    (setq #sDoorFigID (nth 8 #xd1$)) ; くたい 01/02/22 YM ADD
    (if (= "none" (nth 8 #xd1$))
      (setq #sDoorFigID "")
      (setq #sDoorFigID (nth 8 #xd1$))
    );_if
  );_if
  ;HOPE-0140 00/09/07 HN ADD G_LSYMの扉図形IDが"none"の場合はDBより取得

  (setq #lst$
    (list #HIN850
          (nth  6 #xd1$)
          (nth  3 (assoc 10 #gent$));00/08/29 SN MOD 挿入点はentgetの情報を使用する。
          #w
          #d
          #h
          #sDoorFigID   ;扉開きID
          (nth 0 #xd1$) ; 00/03/23 MH MOD
    )
  )
  ;;; オプション拡張情報(ない場合はnil値) 00/02/22 MH ADD
  (setq #xd3$ (CFGetXData &enSym "G_OPT"))
  (if (= 'LIST (type #xd3$)) (setq #oplst$ (cdr #xd3$)))

  ; 03/06/17 YM ADD 特注ｵﾌﾟｼｮﾝ品情報
  (setq #xdOPT2$ (CFGetXData &enSym "G_OPT2"))

;;; 00/02/22 MH MOD
;;;  (PKY_PartsInfoDialog #lst$ #oplst$ #outname #SNK_ANA #xdOPT2$) ;;; オプション品部を追加 ; 03/06/17 YM ADD 引数追加(末尾)
  (setq #xdLSYM$ (CFGetXData &enSym "G_LSYM"));03/10/12 YM ADD
;;; ↓2011/12/22 山田 変更・追加 -------------------------------
;;;  (PKY_PartsInfoDialog #lst$ #oplst$ #outname #SNK_ANA #xdOPT2$ #xdLSYM$) ; 03/10/12 YM ADD 引数"G_LSYM"追加(末尾)
  (if (/= nil #xd1$)
    (setq #symType (nth 15 #xd1$))
    (setq #symType nil)
  )
  ; 引数 分類 追加(末尾)
  (setq #symType (PKY_PartsInfoDialog #lst$ #oplst$ #outname #SNK_ANA #xdOPT2$ #xdLSYM$ #symType))
;;; ↑2011/12/22 山田 変更・追加 -------------------------------
;;;  (SKY_PartsInfoDialog #lst$)
  (command "_.undo" "b")
;;; ↓2011/12/22 山田 追加 -------------------------------
  (if (/= nil #symType)
    (progn
      (setq #xd1$ (CFModList #xd1$ (list (list 15 #symType))))
      (CFSetXData &enSym "G_LSYM" #xd1$)
    )
  )
;;; ↑2011/12/22 山田 追加 -------------------------------
  (setq CG_CHG_COL nil) ; 01/01/22 YM ADD 色替え中'T
  (princ)
);C:ConfParts

;;;<HOM>*************************************************************************
;;; <関数名>    : SKY_PartInfoDialog
;;; <処理概要>  : アイテム情報(配置部材図形の情報)表示ダイアログ
;;; <戻り値>    :
;;; <作成>      : 1999-11-19
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun SKY_PartsInfoDialog (
    &lst$
    /
    #dcl_id
    #lr
    #_lr
    #findFlg
    #fX #fY
  )

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCCONF.DCL")))
  (if (new_dialog "PartsXData_Box" #dcl_id)
    (progn
      (setq #lr (nth 1 &lst$))
;;; 00/02/07 MH MOD
      (setq #_lr (cond ((= #lr "Z") "") ((= #lr "L") " (L)") ((= #lr "R") " (R)")))
      (set_tile "_name" (strcat (nth 0 &lst$) #_lr))
      (set_tile "_ins_pz" (rtos (nth 2 &lst$) 2 2))
      (set_tile "_sym_w"  (rtos (nth 3 &lst$) 2 2))
      (set_tile "_sym_d"  (rtos (nth 4 &lst$) 2 2))
      (set_tile "_sym_h"  (rtos (nth 5 &lst$) 2 2))

      (setq #fX (dimx_tile "image"))
      (setq #fY (dimy_tile "image"))
      (start_image "image")
      (fill_image  0 0 #fX #fY -0)
      (setq #findFlg T)
      (if CG_DROPENPATH
        (progn
          (if (findfile (strcat CG_DROPENPATH (nth 6 &lst$) ".sld"))
            (progn
              (slide_image 0 0 #fX (- #fY 10) (strcat CG_DROPENPATH (nth 6 &lst$) ".sld"))
            )
            (progn
              (if (findfile (strcat CG_DROPENPATH (substr (nth 6 &lst$) 1 7) ".sld"))
                (progn
                  (slide_image 0 0 #fX (- #fY 10) (strcat CG_DROPENPATH (substr (nth 6 &lst$) 1 7) ".sld"))
                )
              ;else
                (progn
                  (if (findfile (strcat CG_SKDATAPATH "CRT\\" (substr (nth 6 &lst$) 1 7) ".sld"))
                    (slide_image 0 0 #fX (- #fY 10) (strcat CG_SKDATAPATH "CRT\\" (substr (nth 6 &lst$) 1 7) ".sld"))
                    (setq #findFlg nil)
                  )
                )
              )
            )
          )
        )
        (progn
          (if (findfile (strcat CG_SKDATAPATH "CRT\\" (substr (nth 6 &lst$) 1 7) ".sld"))
            (slide_image 0 0 #fX (- #fY 10) (strcat CG_SKDATAPATH "CRT\\" (substr (nth 6 &lst$) 1 7) ".sld"))
            (slide_image 0 0 #fX (- #fY 10) (strcat CG_SYSPATH "notfile.sld"))
          )
        )
      )
      (end_image)
      (action_tile "accept" "(done_dialog)")

      (start_dialog)
    )
  )
  (unload_dialog #dcl_id)
);SKY_PartsInfoDialog

;;;<HOM>*************************************************************************
;;; <関数名>    : PC_ConfWKTop2
;;; <処理概要>  : ワークトップ情報表示
;;; <戻り値>    :
;;; <作成>      : 00/09/22 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PC_ConfWKTop2 (
  &wtEn        ;(ENAME)ワークトップ図形名
  /
  #wtEn #xd1$ #lst$ #loop #62 #XD2$ #RET_WTINFO$ #SET$
  #BRK #DIM #ELM #K
  )

  (command "_.undo" "m")

  ;// ワークトップの指示
  (initget 0)
  (setq #loop T)
  (setq #xd1$ (CFGetXData &wtEn "G_WRKT"))
  (if (= #xd1$ nil)
    (CFAlertMsg "ワークトップではありません。")
    (progn
      ;(command "_.change" &wtEn "" "P" "C" CG_ConfSymCol "")
      ; 01/02/26 MOD MH "_change" はUCS に平行でない図形が漏れるため
      (command "_.chprop" &wtEn "" "C" CG_ConfSymCol "")
      (setq #xd2$ (CFGetXData &wtEn "G_WTSET"))

      (if (/= #xd2$ nil)
        (progn
          (setq #brk " " #dim "")
          (setq #k 12)
          (repeat (nth 11 #xd2$) ; 穴寸法個数
            (setq #elm (nth #k #xd2$))
            (if (equal #elm (fix (+ #elm 0.0001)) 0.001)       ; 小数点以下無し
              (setq #dim (strcat #dim (itoa (fix (+ #elm 0.001))) #brk)) ; 小数点以下切り捨て
              (setq #dim (strcat #dim (rtos #elm 2 1) #brk))             ; 下１桁まで(第２位四捨五入)
            );_if
            (setq #k (1+ #k))
          )

          (setq #lst$ ; 品番確定している
            (list
              (nth  0 #xd2$) ;特注フラグ
              (nth  1 #xd2$) ;品番
              (nth  3 #xd2$) ;価格
              (nth  8 #xd1$) ;取付け高さ
              (nth  2 #xd1$) ;材質
              (car  (nth 55 #xd1$)) ;間口1
              (cadr (nth 55 #xd1$)) ;間口2
              (car  (nth 57 #xd1$)) ;奥行1
              (cadr (nth 57 #xd1$)) ;奥行2
	            (caddr (nth 57 #xd1$));奥行3 2012/04/19 YM ADD
              #dim
            )
          )
        )
        (setq #lst$ ; 品番確定していない
          (list
            ""
            ""
            ""
            (nth  8 #xd1$) ;取付け高さ
            (nth  2 #xd1$) ;材質
            (car  (nth 55 #xd1$)) ;間口1
            (cadr (nth 55 #xd1$)) ;間口2
            (car  (nth 57 #xd1$)) ;奥行1
            (cadr (nth 57 #xd1$)) ;奥行2
            (caddr (nth 57 #xd1$));奥行3 2012/04/19 YM ADD
            ""
          )
        )
      );_if
      (PKY_WKTopInfoDialog #lst$)
      ; ワークトップ色変更部
      (if (CFGetXData &wtEn "G_WTSET")
        ; 01/02/26 MH MOD"_change" はUCS に平行でない図形が漏れるため
        ;(command "_.change" &wtEn "" "P" "C" CG_WorkTopCol "")
        ;(command "_.change" &wtEn "" "P" "C" "BYLAYER" "")
        (command "_.chprop" &wtEn "" "C" CG_WorkTopCol "")
        (command "_.chprop" &wtEn "" "C" "BYLAYER" "")
      )
      (setq #loop nil)
    )
  );_if
  (princ)
);PC_ConfWKTop2

;;;<HOM>*************************************************************************
;;; <関数名>    : PKY_WKTopInfoDialog
;;; <処理概要>  : ワークトップ情報確認表示ダイアログ
;;; <戻り値>    :
;;; <作成>      : 00/09/22 YM 標準
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKY_WKTopInfoDialog (
  &lst$
  /
  #DCL_ID #LST$ #MAGU1 #MAGU2 #MEMO #OKU1 #OKU2 #QRY$ #RET
#CODE #DIM #HIGH #MONEY ; 02/11/30 YM ADD
#LST$
  )
;;;    &lst$
;;;  0;特注フラグ
;;;  1;品番
;;;  2;価格
;;;  3;取付け高さ
;;;  4;材質
;;;  5;間口1
;;;  6;間口2
;;;  7;奥行1
;;;  8;奥行2

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCCONF.DCL")))
  (if (new_dialog "WKTopXDataAll" #dcl_id)
    (progn
      (setq #qry$
        (DBSqlAutoQuery CG_DBSESSION (strcat "select * from WT材質 where 材質記号='" (nth 4 &lst$) "'"))
      )
      (setq #qry$ (DBCheck #qry$ "『WT材質』" "PKY_WKTopInfoDialog"))

      (setq #code (nth 1 &lst$))

      (if (= (nth 2 &lst$) "")
        (setq #money "0")
        (setq #money  (itoa (fix (+ (nth 2 &lst$) 0.001) )))
      )
      (if (= (nth 3 &lst$) "")
        (setq #high "0")
        (setq #high  (itoa (fix (+ (nth 3 &lst$) 0.001) )))
      )
      (if (= (nth 5 &lst$) "")
        (setq #magu1 "0")
        (setq #magu1 (itoa (fix (+ (nth 5 &lst$) 0.001) )))
      )
      (if (= (nth 6 &lst$) "")
        (setq #magu2 "0")
        (setq #magu2 (itoa (fix (+ (nth 6 &lst$) 0.001) )))
      )
      (if (= (nth 7 &lst$) "")
        (setq #oku1 "0")
        (setq #oku1 (itoa (fix (+ (nth 7 &lst$) 0.001) )))
      )
      (if (= (nth 8 &lst$) "")
        (setq #oku2 "0")
        (setq #oku2 (itoa (fix (+ (nth 8 &lst$) 0.001) )))
      )
			;2012/04/19 YM ADD-S
			(if (= (nth 9 &lst$) "")
				(setq #oku3 "0")
				(setq #oku3 (itoa (fix (+ (nth 9 &lst$) 0.001) )))
			)
			;2012/04/19 YM ADD-E
			(if (= (nth 10 &lst$) "")
				(setq #dim " ")
				(setq #dim (nth 10 &lst$))
			)

			;2020/02/13 YM ADD 材質記号も表示する
      (set_tile "WTzai" (strcat (nth 4 #qry$)  " (" (nth 1 #qry$) ")"))  ; 材質
      (set_tile "WTcode"  #code)        ; 品番
      (set_tile "WTmoney" #money)       ; 金額
      (set_tile "WThigh"  #high)        ; 取付け高さ
      (set_tile "WTmagu1" #magu1)       ; 間口1
      (set_tile "WTmagu2" #magu2)       ; 間口2
      (set_tile "WToku1"  #oku1)        ; 奥行1
      (set_tile "WToku2"  #oku2)        ; 奥行2
      (set_tile "WToku3"  #oku3)        ; 奥行3 2012/04/19 YM ADD
      (set_tile "ana"  #dim)            ; 穴寸法
    )
  );_if

  (if (= "" (nth 1 &lst$))
    (set_tile "error" "品番が確定されていません")
  )

  (action_tile "accept" "(setq #lst$ nil)(done_dialog)")
  (action_tile "cancel" "(setq #lst$ nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  (princ)
);PKY_WKTopInfoDialog

;;;<HOM>*************************************************************************
;;; <関数名>    : PcGetPrintNameH800
;;; <処理概要>  : 品番名称を渡すと ｢階層+SERIES名｣ テーブルから出力名称を返す
;;; <戻り値>    : 出力名称文字列 （検索失敗なら"階層名称2"で検索）
;;; <作成>      : 00/04/28 MH      00/06/28 YM MOD
;;; <備考>      : 複数取得の場合は最初に検出のもの
;;;*************************************************************************>MOH<
(defun PcGetPrintNameH800 (
  &sHINBAN    ; 品番名称
  &skk        ; 性格ｺｰﾄﾞ
  /
  #sTABLE #QLY$ #sNAME #NAME$
  )
  (if (and &skk (= &skk CG_SKK_INT_SNK)) ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
    (progn ; ｼﾝｸの場合"WTｼﾝｸ"を検索
      (setq #name$ ; １つ引き当て
        (CFGetDBSQLRec CG_DBSESSION "WTシンク"
          (list (list "品番名称" &sHINBAN 'STR))
        )
      );_(setq
      (setq #sNAME (nth 2 (car #name$))) ; ｼﾝｸの品名取得
    )
    (progn
      ; ｢階層+SERIES名｣ テーブル名作成
      (setq #sTABLE "階層")
      ;クエリ取得
      (setq #QLY$
        (car (CFGetDBSQLRec CG_DBSESSION #sTABLE
          (list
            (list "階層名称" &sHINBAN 'STR)
          ); end of list
      ))); end of setq

      (if #QLY$
        (setq #sNAME (nth 6 #QLY$)) ;階層から品名取得
        ;else
        (setq #sNAME "") ;品名取得できず
      );_if

      (if (/= 'STR (type #sNAME)) (setq #sNAME ""))
    )
  );_if

  (if (/= 'STR (type #sNAME)) (setq #sNAME ""))
  #sNAME
); PcGetPrintNameH800


;;;<HOM>*************************************************************************
;;; <関数名>    : PKY_PartInfoDialog
;;; <処理概要>  : アイテム情報(配置部材図形の情報)とオプション品情報の表示
;;; <戻り値>    :
;;; <作成>      : 00/02/22 MH ADD
;;; <備考>      : オプションリストがnilの場合オプション部を隠す
;;;*************************************************************************>MOH<
(defun PKY_PartsInfoDialog (
  &lst$
  &oplst$
  &outname ; 出力名称
  &SNK_ANA ; ｼﾝｸ穴加工記号
  &G_OPT2  ; "G_OPT2 のまま 特注ｵﾌﾟｼｮﾝ情報 03/06/17 YM ADD NAS版はnil
  &xdLSYM$ ; "G_LSYM" 03/10/12 YM ADD
  &symType ; 分類(キッチン/収納) (拡張データ) 2011/12/22 山田 追加
  /
  #dcl_id
  #lr
  #_lr
  #findFlg #outname
  #fX #fY #sADD #oplst$
#HINBAN #STENKAI_ID #SZUKEI_ID ;03/10/10 YM ADD
  #symType    ; 分類(キッチン/収納) (拡張データ) 2011/12/22 山田 追加
  )

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCCONF.DCL")))
  (if (not (new_dialog "PartsXData_Opt_Box" #dcl_id)) (exit))

  ;;; オプション部の処理
  (if (and (= 'LIST (type &oplst$)) (< 1 (length &oplst$)))
    ;;; オプション情報リストが有効ならばリストボックスに表示
    (progn
      (setq #oplst$ &oplst$)
      (start_list "_option" 3)
      (while (< 1 (length #oplst$))
        (setq #outname (PcGetPrintNameH800 (car #oplst$) nil)) ; 品番名称--->出力名称 06/29 YM
        (if (= #outname "")(setq #outname " "))
;-- 2011/08/05 A.Satoh Mod - S
;        (setq #sADD (strcat (car #oplst$) "\t" #outname "\t" (itoa (fix (cadr #oplst$)))))
        (setq #sADD (strcat (car #oplst$) "\t" (itoa (fix (cadr #oplst$)))))
;-- 2011/08/05 A.Satoh Mod - S
        (add_list #sADD)
        (repeat 2 (setq #oplst$ (cdr #oplst$)))
      )
      (end_list)
      (mode_tile "_option" 0)
    ); end of progn
    ;;; リストが無効、リストボックスを使用禁止にする
    (progn
      (mode_tile "_option" 1)
    ); end of progn
  ); end of if

  (setq #lr (nth 1 &lst$))
  (setq #_lr
    (cond
     ((= #lr "Z") "")
     ((= #lr "L") " (Lﾀｲﾌﾟ)")
     ((= #lr "R") " (Rﾀｲﾌﾟ)")
    )
  )

  ; NAS 独自 01/06/19 YM ADD
  (NPGetDrCol) ; 扉ｶﾗｰをｸﾞﾛｰﾊﾞﾙにｾｯﾄ 01/06/20 YM ADD

  ;03/10/12 YM ADD &xdLSYM$ 追加
;;; (setq #hinban (NPAddHinDrCol_WOODONE (nth 0 &lst$) (nth 1 &lst$) &xdLSYM$)) ; @@%#付き品番,LR,LSYM
  (setq #hinban (strcat (nth 0 &lst$) #_lr))

  (set_tile "key_name" "品　　番") ; 07/13 YM MOD ｼﾝｸ穴加工記号ﾗﾍﾞﾙ
  (set_tile "_name" #hinban); NAS 独自 01/06/19 YM MOD

;-- 2011/08/05 A.Satoh Del - S
;  (set_tile "key_name2" "品　　名") ; 03/06/09 YM ADD
;  (set_tile "_outname" &outname)
;-- 2011/08/05 A.Satoh Del - E

  (if &SNK_ANA
    (progn ; ｼﾝｸ確認のとき
      (set_tile "_ins_pz" "0")
      (set_tile "_sym_w"  "0")
      (set_tile "_sym_d"  "0")
      (set_tile "_sym_h"  "0")
    )
    (progn
      (set_tile "_ins_pz" (rtos (nth 2 &lst$) 2 0)) ; precision=2 to 0 07/22 YM
      (set_tile "_sym_w"  (rtos (nth 3 &lst$) 2 0)) ; precision=2 to 0 07/22 YM
      (set_tile "_sym_d"  (rtos (nth 4 &lst$) 2 0)) ; precision=2 to 0 07/22 YM
      (set_tile "_sym_h"  (rtos (nth 5 &lst$) 2 0)) ; precision=2 to 0 07/22 YM
    )
  );_if

  ;;; ↓2011/12/22 山田 追加 -------------------------------
  ; 分類をダイアログに設定
  (if (/= nil &symType)
    (set_tile "_sym_type" &symType)
    (mode_tile "_sym_type" 1)
  )
  ;;; ↑2011/12/22 山田 追加 -------------------------------

  (setq #fX (dimx_tile "image"))
  (setq #fY (dimy_tile "image"))
  (start_image "image")
  (fill_image  0 0 #fX #fY -0)

  ; 水栓確認で落ちる 01/08/07 YM ADD START
  (setq #sTENKAI_ID (nth 6 &lst$))
  (setq #sZUKEI_ID  (nth 7 &lst$))
  (if (= nil #sTENKAI_ID)
    (setq #sTENKAI_ID #sZUKEI_ID)
  );_if
  ; 水栓確認で落ちる 01/08/07 YM ADD END

  ;;; 00/03/23 MH MOD  分岐部分全面書き換え
  (setq #findFlg T)

  (if (and (= nil #sTENKAI_ID)(= nil #sZUKEI_ID)) ; 条件分岐追加 01/08/07 YM ADD
    (progn
      (slide_image 0 0 #fX (- #fY 10) (strcat CG_SYSPATH "notfile.sld"))
      (setq #findFlg nil)
    )
    (progn
      (cond
        ((findfile (strcat CG_SKDATAPATH "CRT\\" (nth 6 &lst$) ".sld"))
          (slide_image 0 0 #fX (- #fY 10) (strcat CG_SKDATAPATH "CRT\\" (nth 6 &lst$) ".sld"))
        )
        ((findfile (strcat CG_SKDATAPATH "CRT\\" (nth 7 &lst$) ".sld"))
          (slide_image 0 0 #fX (- #fY 10) (strcat CG_SKDATAPATH "CRT\\" (nth 7 &lst$) ".sld"))
          (setq #findFlg nil)
        )
        (t
          (slide_image 0 0 #fX (- #fY 10) (strcat CG_SYSPATH "notfile.sld"))
          (setq #findFlg nil)
        )
      ); end of cond
    )
  );_if

  (end_image)
  ;;; ↓2011/12/22 山田 変更 -------------------------------
  ;(action_tile "accept" "(done_dialog)")
  (action_tile "accept" "(progn (setq #symType (get_tile \"_sym_type\")) (done_dialog))") ; 選択した分類の取得
  ;;; ↑2011/12/22 山田 追加 -------------------------------
  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; ↓2011/12/22 山田 追加 -------------------------------
;  ; 分類を返す(再設定用)
  (if (/= nil &symType)
    #symType
    nil
  )
  ;;; ↑2011/12/22 山田 追加 -------------------------------
);PKY_PartsInfoDialog

;;;<HOM>*************************************************************************
;;; <関数名>    : NPGetDrCol
;;; <処理概要>  : 扉ｶﾗｰをｸﾞﾛｰﾊﾞﾙ(CG_DRColCode)にｾｯﾄする
;;; <戻り値>    : なし
;;; <作成>      : 01/06/20 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun NPGetDrCol (
  /
  #MSG1 #MSG2 #SERI$
  )
  (setq #msg1 "扉COLOR記号が見つかりません。")
  (setq #msg2 "コマンドを終了しました。")
  (if (setq #seri$ (CFGetXRecord "SERI"))
    (setq CG_DRColCode (nth 4 #seri$)) ;扉COLOR記号
    (progn
      (CFAlertErr #msg1)
      (princ #msg2)
      (*error*)
    )
  );_if
  (princ)
);NPGetDrCol

;;;<HOM>*************************************************************************
;;; <関数名>    : NPAddHinDrCol_WOODONE
;;; <処理概要>  : ｷｬﾋﾞ品番の@@%部分に扉ｶﾗｰ+LRを入れて返す
;;; <戻り値>    : 品番文字列
;;; <作成>      : 2010/01/07 YM ADD
;;; <備考>      : 未使用
;;;*************************************************************************>MOH<
(defun NPAddHinDrCol_WOODONE (
  &hinban ; 元品番
  &LR     ; LR区分
  &xdLSYM$ ; "G_LSYM" 03/10/12 YM ADD
  /
  #RET #HIKITE #COLOR #CG_DRCOLCODE #DRSERICODE #RET$ #DoorInfo
#CG_DRSERICODE #CG_HIKITE
  )

  ; 03/10/12 YM ADD-S 部分変更扉記号取得
  (if &xdLSYM$
    (progn
      (setq #DoorInfo  (nth 7 &xdLSYM$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"
      (setq #ret$ (StrParse #DoorInfo ",")) ; 01/10/11 YM MOD ":"->","
      (setq #CG_DRSeriCode (car   #ret$))
      (setq #CG_DRColCode  (cadr  #ret$))
      (setq #CG_HIKITE     (caddr #ret$))
    )
    ;else
    (progn
      (setq #CG_DRSeriCode "$")
      (setq #CG_DRColCode  "@@")
      (setq #CG_HIKITE     "#")
    )
  );_if
  ; 03/10/12 YM ADD-E 部分変更扉記号取得

  (if (or (= nil #CG_DRColCode)(= "" #CG_DRColCode))
    (setq #CG_DRColCode CG_DRColCode)
  );_if

  ;LRを入れる
  (setq #ret (vl-string-subst &LR "%" &hinban))

  (cond
    ((wcmatch #ret "*`@`@`@*");新ｸﾘﾌ
      ;04/07/12 YM MOD-S 扉色記号2 or 3桁対応
      (if (and #CG_DRColCode (/= #CG_DRColCode ""))
        (setq #ret (vl-string-subst #CG_DRColCode "@@@" #ret))
      );_if
      ;03/10/12 YM MOD-E
    )
    ((wcmatch #ret "*`@`@`#*");DIPLOA
      ; 03/10/07 YM ADD ﾃﾞｨﾌﾟﾛｱ対応
      ;引手記号を取得 nil or 1文字
      (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode に変更
      (setq #ret (vl-string-subst #CG_DRColCode "@@#" #ret)) ; "@@#"に扉ｶﾗｰを代入"@@#"がないとそのまま
    )
    (T ;その他ｼﾘｰｽﾞ
      ;03/10/12 YM MOD-S 扉色記号2 or 3桁対応
      ;通常の場合
      (if (and #CG_DRColCode (/= #CG_DRColCode ""))
        (setq #ret (vl-string-subst (substr #CG_DRColCode 1 2) "@@" #ret))
      );_if
      ;03/10/12 YM MOD-E
    )
  );_cond

  (if (wcmatch #ret "*`#*");DIPLOA まだ"#"が残っている
    (progn
      (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode に変更
      (setq #ret (vl-string-subst #HIKITE "#" #ret));品番"SC#"の"#"に引手記号を入れる
    )
  );_if

  (if (wcmatch #ret "*`@*");DIPLOA まだ"@"が残っている
    (progn
      ;更に"@"を扉色記号1桁に変更する 03/10/10 YM ADD
      ;扉色記号1桁を取得 nil or 1文字
      (setq #COLOR (KPGetColor #CG_DRColCode))
      (setq #ret (vl-string-subst #COLOR "@" #ret));品番"A@A"の"@"に色記号を入れる
    )
  );_if

  #ret
);NPAddHinDrCol_WOODONE

;;;<HOM>*************************************************************************
;;; <関数名>    : NPAddHinDrCol
;;; <処理概要>  : ｷｬﾋﾞ品番の@@%部分に扉ｶﾗｰ+LRを入れて返す
;;; <戻り値>    : 品番文字列
;;; <作成>      : 01/06/19 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun NPAddHinDrCol (
  &hinban ; 元品番
  &LR     ; LR区分
  &xdLSYM$ ; "G_LSYM" 03/10/12 YM ADD
  /
  #RET #HIKITE #COLOR #CG_DRCOLCODE #DRSERICODE #RET$
  )

  ; 03/10/12 YM ADD-S 部分変更扉記号取得
  (if &xdLSYM$
    (progn
      (setq #CG_DRColCode  (nth 7 &xdLSYM$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"
      (setq #ret$ (StrParse #CG_DRColCode ",")) ; 01/10/11 YM MOD ":"->","
      (setq #DRSeriCode (car  #ret$))
      (setq #CG_DRColCode  (cadr #ret$))
    )
    ;else
    (setq #CG_DRColCode CG_DRColCode)
  );_if
  ; 03/10/12 YM ADD-E 部分変更扉記号取得

  (if (or (= nil #CG_DRColCode)(= "" #CG_DRColCode))
    (setq #CG_DRColCode CG_DRColCode)
  );_if

  ;LRを入れる
  (setq #ret (vl-string-subst &LR "%" &hinban))

  (cond
    ((wcmatch #ret "*`@`@`@*");新ｸﾘﾌ
      ;04/07/12 YM MOD-S 扉色記号2 or 3桁対応
      (if (and #CG_DRColCode (/= #CG_DRColCode ""))
        (setq #ret (vl-string-subst #CG_DRColCode "@@@" #ret))
      );_if
      ;03/10/12 YM MOD-E
    )
    ((wcmatch #ret "*`@`@`#*");DIPLOA
      ; 03/10/07 YM ADD ﾃﾞｨﾌﾟﾛｱ対応
      ;引手記号を取得 nil or 1文字
      (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode に変更
      (setq #ret (vl-string-subst #CG_DRColCode "@@#" #ret)) ; "@@#"に扉ｶﾗｰを代入"@@#"がないとそのまま
    )
    (T ;その他ｼﾘｰｽﾞ
      ;03/10/12 YM MOD-S 扉色記号2 or 3桁対応
      ;通常の場合
      (if (and #CG_DRColCode (/= #CG_DRColCode ""))
        (setq #ret (vl-string-subst (substr #CG_DRColCode 1 2) "@@" #ret))
      );_if
      ;03/10/12 YM MOD-E
    )
  );_cond

  (if (wcmatch #ret "*`#*");DIPLOA まだ"#"が残っている
    (progn
      (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode に変更
      (setq #ret (vl-string-subst #HIKITE "#" #ret));品番"SC#"の"#"に引手記号を入れる
    )
  );_if

  (if (wcmatch #ret "*`@*");DIPLOA まだ"@"が残っている
    (progn
      ;更に"@"を扉色記号1桁に変更する 03/10/10 YM ADD
      ;扉色記号1桁を取得 nil or 1文字
      (setq #COLOR (KPGetColor #CG_DRColCode))
      (setq #ret (vl-string-subst #COLOR "@" #ret));品番"A@A"の"@"に色記号を入れる
    )
  );_if

  #ret
);NPAddHinDrCol

;;;<HOM>*************************************************************************
;;; <関数名>    : KPGetHikite
;;; <処理概要>  : 扉ｶﾗｰ記号から引手記号を取得
;;; <戻り値>    : "" or 1文字
;;; <作成>      : 03/10/07 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KPGetHikite (
  &CG_DRColCode
  /
  #ret
  )
  (setq #ret "")
  ;引手記号を取得 nil or 1文字
  (if (and &CG_DRColCode (/= nil &CG_DRColCode))
    (setq #ret (substr &CG_DRColCode 3 1))
  );_if
  #ret
);KPGetHikite

;;;<HOM>*************************************************************************
;;; <関数名>    : KPGetColor
;;; <処理概要>  : 扉ｶﾗｰ記号から色記号1桁を取得
;;; <戻り値>    : 1文字
;;; <作成>      : 03/10/10 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KPGetColor (
  &CG_DRColCode
  /
  #ret
  )
  (setq #ret "")
  ;引手記号を取得 nil or 1文字
  (if (and &CG_DRColCode (/= nil &CG_DRColCode))
    (setq #ret (substr &CG_DRColCode 2 1))
  );_if
  #ret
);KPGetColor

;;;<HOM>*************************************************************************
;;; <関数名>    : NPAddHinDrCol2
;;; <処理概要>  : ｷｬﾋﾞ品番の@@%部分に[?:??]内の扉ｶﾗ??ｰ + LRを入れて返す
;;;               ただし
;;; <戻り値>    : 品番文字列
;;; <作成>      : 01/12/07 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun NPAddHinDrCol2 (
  &hinban ; 元品番 "STTF045@@%[B:BA]"
  &LR     ; LR区分
  /
  #RET #CG_DRCOLCODE #NO1 #NO2 #NO3 #HIKITE #COLOR
#COL1 #COL2 #LASTHINBAN #QRY$$ ;03/10/10 YM ADD
#END #NO%
  )
    ;/////////////////////////////////////////////////////////////////////////
    ; &obj が &str の何番めか.なければnilを返す
    (defun ##GetIndex (
      &str ; STR
      &obj ; 対象文字
      /
      #I #LOOP #NO #STR
      )
      (setq #no nil) ; "[" が何番目か
      (setq #i 1 #loop T)
      (while (and #loop (< #i (1+ (strlen &str))))
        (if (= (substr &str #i 1) &obj)
          (progn
            (setq #no #i)
            (setq #loop nil)
          )
        );_if
        (setq #i (1+ #i))
      )
      #no
    );##GetIndex
    ;/////////////////////////////////////////////////////////////////////////

  (setq #no1 (##GetIndex &hinban "[")) ; "[" が何番目か
  (setq #no2 (##GetIndex &hinban ":")) ; ":" が何番目か
  (setq #no3 (##GetIndex &hinban "]")) ; "]" が何番目か
  (if (and #no1 #no2 #no3)
    (progn ; [*]あり
      (setq #CG_DRColCode (substr &hinban (1+ #no2)(- #no3 #no2 1))) ; 扉ｶﾗｰ部分 @@@
    )
    (progn ; [*]なし
      (setq #CG_DRColCode CG_DRColCode) ; 図面の扉ｶﾗｰ
    )
  );_if

;;; (vl-string-subst new-str pattern string [start-pos])

  ; 02/03/21 YM ADD-S
  (setq #LastHinban nil)
  (setq #LastHinban (KPGetLastHinban &hinban &LR))
  (if #LastHinban
    (setq #ret #LastHinban)                                  ; 最終品番を使用
  ; else
    (progn
      ; 03/01/27 YM ADD-S
      ; 扉色変換TB検索
      ; 06/09/25 T.Ari Mod 扉色変換検索削除
      (setq #Qry$$ nil)
;     (setq #Qry$$
;       (CFGetDBSQLRec CG_DBSESSION "扉色変換"
;         (list (list "SERIES記号" CG_SeriesCode 'STR))
;       )
;     )
      (if #Qry$$ ; 複数あり
        (progn
          (setq #COL2 nil) ; 変換後扉色(仕様表の扉色を扉色変換TBに従って変換する)
          (foreach #Qry$ #Qry$$
            (setq #COL1 (nth 2 #Qry$)) ; 変換元
            (if (= #CG_DRColCode #COL1)
              (setq #COL2 (nth 3 #Qry$)) ; 変換後
            );_if
          )
          (if #COL2
            (setq #CG_DRColCode #COL2)
          );_if
        )
      );_if

      ;04/07/30 YM MOD 新ｸﾘﾌ対応
      (setq #ret &hinban)
      (cond
        ((wcmatch #ret "*`@`@`@*");新ｸﾘﾌ
          ;04/07/12 YM MOD-S 扉色記号2 or 3桁対応
          (if (and #CG_DRColCode (/= #CG_DRColCode ""))
            (setq #ret (vl-string-subst #CG_DRColCode "@@@" #ret))
          );_if
          ;03/10/12 YM MOD-E
        )
        ((wcmatch #ret "*`@`@`#*");DIPLOA
          ; 03/10/07 YM ADD ﾃﾞｨﾌﾟﾛｱ対応
          ;引手記号を取得 nil or 1文字
          (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode に変更
          (setq #ret (vl-string-subst #CG_DRColCode "@@#" #ret)) ; "@@#"に扉ｶﾗｰを代入"@@#"がないとそのまま
        )
        (T ;その他ｼﾘｰｽﾞ
          ;03/10/12 YM MOD-S 扉色記号2 or 3桁対応
          ;通常の場合
          (if (and #CG_DRColCode (/= #CG_DRColCode ""))
            (setq #ret (vl-string-subst (substr #CG_DRColCode 1 2) "@@" #ret))
          );_if
          ;03/10/12 YM MOD-E
        )
      );_cond

      (if (wcmatch #ret "*`#*");DIPLOA まだ"#"が残っている
        (progn
          (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode に変更
          (setq #ret (vl-string-subst #HIKITE "#" #ret));品番"SC#"の"#"に引手記号を入れる
        )
      );_if

      (if (wcmatch #ret "*`@*");DIPLOA まだ"@"が残っている
        (progn
          ;更に"@"を扉色記号1桁に変更する 03/10/10 YM ADD
          ;扉色記号1桁を取得 nil or 1文字
          (setq #COLOR (KPGetColor #CG_DRColCode))
          (setq #ret (vl-string-subst #COLOR "@" #ret));品番"A@A"の"@"に色記号を入れる
        )
      );_if
      ;04/07/30 YM MOD 新ｸﾘﾌ対応

;;;     ; 03/09/18 YM ADD ﾃﾞｨﾌﾟﾛｱ対応
;;;     (setq #ret (vl-string-subst #CG_DRColCode "@@#" &hinban)) ; "@@#"に扉ｶﾗｰを代入"@@#"がないとそのまま
;;;
;;;     ;03/10/12 YM MOD-S 扉色記号2 or 3桁対応
;;;     (if (and #CG_DRColCode (/= #CG_DRColCode ""))
;;;       (setq #ret (vl-string-subst (substr #CG_DRColCode 1 2) "@@" #ret))
;;;     );_if
;;;     ;03/10/12 YM MOD-E
;;;
;;;     ; 03/10/07 YM ADD ﾃﾞｨﾌﾟﾛｱ対応
;;;     ;引手記号を取得 nil or 1文字
;;;     (setq #HIKITE (KPGetHikite #CG_DRColCode))
;;;     (setq #ret (vl-string-subst #HIKITE "#" #ret));品番"SC#"の"#"に引手記号を入れる
;;;
;;;     ;更に"@"を扉色記号1桁に変更する 03/10/10 YM ADD
;;;     ;扉色記号1桁を取得 nil or 1文字
;;;     (setq #COLOR (KPGetColor #CG_DRColCode))
;;;     (setq #ret (vl-string-subst #COLOR "@" #ret));品番"A@A"の"@"に色記号を入れる

    )
  );_if
  ; 02/03/21 YM ADD-E

  ;03/10/24 YM ADD-S
  ;"%"があって[]がなかったら末尾の"L","R"を取り除く
  (setq #no% (##GetIndex #ret "%")) ; "%" が何番目か
  (if #no%
    (progn
      (if (and #no1 #no2 #no3)
        nil ;[]あり
        ;else
        (progn ;[]がない
          (setq #end (substr #ret (strlen #ret) 1));末尾1文字
          (if (or (= #end "R")(= #end "L"))
            (setq #ret (substr #ret 1 (1- (strlen #ret))));末尾1文字削除
          );_if
        )
      );_if
    )
  );_if
  ;03/10/24 YM ADD-E


;;;02/03/21YM@MOD (setq #ret (vl-string-subst #CG_DRColCode "@@" &hinban))
  (setq #ret (vl-string-subst &LR "%" #ret))

  ; []部分を取り除く
  (setq #ret (KP_DelDrSeriStr #ret))

  #ret
);NPAddHinDrCol2

;;;<HOM>*************************************************************************
;;; <関数名>    : NPGetLR
;;; <処理概要>  : ｷｬﾋﾞ品番文字列からLRを取得して返す
;;; <戻り値>    : LR
;;; <作成>      : 02/05/13 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun NPGetLR (
  &str ; 元品番 "STTF045@@%[B:BA]"など
  /
  #NO1 #NO2 #NO3 #RET #NO%
  )
    ;/////////////////////////////////////////////////////////////////////////
    ; &obj が &str の何番めか.なければnilを返す
    (defun ##GetIndex (
      &str ; STR
      &obj ; 対象文字
      /
      #I #LOOP #NO #STR
      )
      (setq #no nil) ; "[" が何番目か
      (setq #i 1 #loop T)
      (while (and #loop (< #i (1+ (strlen &str))))
        (if (= (substr &str #i 1) &obj)
          (progn
            (setq #no #i)
            (setq #loop nil)
          )
        );_if
        (setq #i (1+ #i))
      )
      #no
    );##GetIndex
    ;/////////////////////////////////////////////////////////////////////////

  (setq #no1 (##GetIndex &str "[")) ; "[" が何番目か
  (setq #no2 (##GetIndex &str ":")) ; ":" が何番目か
  (setq #no3 (##GetIndex &str "]")) ; "]" が何番目か
  (if (and #no1 #no2 #no3)
    (progn ; [*]あり
      (setq #ret (substr &str (1+ #no3) 1)) ; LR部分 ""もあり
      (if (= #ret "")
        (setq #ret "Z") ; LR
      );_if
    )
    (progn ; [*]なし
;;;     (setq #ret "Z") ; LR 03/10/22 YM MOD
      ;"%"があれば一番最後の文字,それ以外は"Z"
      (setq #no% (##GetIndex &str "%")) ; "%" が何番目か
      (if #no%
        (progn
          (setq #ret (substr &str (strlen &str) 1))
          (if (and (/= #ret "R")(/= #ret "L"))
            (setq #ret "Z") ; LR
          );_if
        )
        ;else
        (setq #ret "Z") ; LR
      );_if
    )
  );_if

  #ret
);NPGetLR

;<HOM>*************************************************************************
; <関数名>    : C:ConfPartsAll
; <処理概要>  : 図面上の全配置部材の確認　(追加部材も表示)
; <戻り値>    :
; <作成>      : 2011/08/12 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun C:ConfPartsAll (
  /
  #CG_SpecList$$ #hin_old #LR_old #num_CHANGE$ #num #hin #LR
  #num_CHANGE #dum1$ #dum2$ #dum$$ #fname #fp #i #k
;-- 2011/09/02 A.Satoh Add - S
  #Expense$
;-- 2011/09/02 A.Satoh Add - E
  #A_CNT #BUNRUI #CG_SPECLIST$ #CG_SPECLISTA$$ #CG_SPECLISTD$$ #D_CNT #LIST$ ;2011/09/23 YM ADD
#ss_LSYM #idx #xd$ #DoorInfo #hinban #Qry_kihon$$ #tenkai_type ;-- 2012/02/18 A.Satoh Add
  )

	;2014/05/29 YM ADD-S
	(setq CG_GLOBAL$ nil)
	;2014/05/29 YM ADD-E

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ConfPartsAll ////")
  (CFOutStateLog 1 1 " ")

  ; 前処理
  (StartUndoErr)

  ; フリープラン設計画面の消去
  (C:arxStartApp (strcat CG_SysPATH "KillPlan.exe") 0)

;-- 2011/09/02 A.Satoh Add - S
  ; buzai.cfgの[EXPENSE]を保持する
  (setq #Expense$ (ConfPartsAll_GetExpenseFromBuzaiFile))
;-- 2011/09/02 A.Satoh Add - E

;-- 2012/02/18 A.Satoh Add - S
; 【[woodone-prj:04712] Re: ２/１３日報】対応
	(setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss_LSYM (< 0 (sslength #ss_LSYM)))
    (progn
			(setq #idx 0)
			(repeat (sslength #ss_LSYM)
				(setq #sym (ssname #ss_LSYM #idx))
				;【品番基本】展開タイプ=0のときG_LSYM扉情報がなければｾｯﾄする
				(setq #xd$ (CFGetXData #sym "G_LSYM"))

	      (setq #DoorInfo (nth 7 #xd$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"
	      (if (or (= nil #DoorInfo)(= #DoorInfo ""))
					(progn
						(setq #hinban (nth 5 #xd$));品番名称
						;展開ﾀｲﾌﾟ取得
		        (setq #Qry_kihon$$
		          (CFGetDBSQLRec CG_DBSESSION "品番基本"
		            (list (list "品番名称"  #hinban 'STR))
		          )
		        )
						(if (and #Qry_kihon$$ (= 1 (length #Qry_kihon$$)))
							(progn
								(setq #tenkai_type (nth 4 (car #Qry_kihon$$)));展開ﾀｲﾌﾟ
								(if (equal #tenkai_type 0.0 0.001);展開ﾀｲﾌﾟ=0
									(progn ;扉情報更新
		                (CFSetXData #sym "G_LSYM"
		                  (CFModList #xd$
		                    (list
		                      (list 7 (strcat CG_DRSeriCode "," CG_DRColCode "," CG_HIKITE))
		                    )
		                  )
		                )
									)
								);_if
							)
						);_if
					)
				);_if
				(setq #idx (1+ #idx))
			);repeart
		)
	);_if
;-- 2012/02/18 A.Satoh Add - E

  ; 図面上の部材を取得する
  (setq #CG_SpecList$$ (ConfPartsAll_SetSpecList))

  (setq #hin_old nil)
  (setq #LR_old  nil)
  (setq #num_CHANGE$ nil)

  ;入れ替え有無判定 同じ品番が連続し、R,Lの順番であればL,Rの順番にする
  (foreach #CG_SpecList$ #CG_SpecList$$
    (setq #num (nth  0 #CG_SpecList$));番号
;-- 2011/10/18 A.Satoh Mod - S
;;;;;    (setq #hin (nth  9 #CG_SpecList$))
;;;;;    (setq #LR  (nth 10 #CG_SpecList$))
    (setq #hin (nth 11 #CG_SpecList$))
    (setq #LR  (nth 12 #CG_SpecList$))
;-- 2011/10/18 A.Satoh Mod - E
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
        (setq #dum$$ (append #dum$$ (list (cons #k #CG_SpecList$ ))));番号を先頭に追加
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
    (if (= #bunrui "A")
      (progn
        (setq #a_cnt (1+ #a_cnt))
        ; キッチン用情報リスト作成
        (setq #list$
          (list
            (list
              #a_cnt
              (nth 1 #CG_SpecList$)
              (nth 2 #CG_SpecList$)
              (nth 3 #CG_SpecList$)
              (nth 4 #CG_SpecList$)
              (nth 5 #CG_SpecList$)
              (nth 6 #CG_SpecList$)
              (nth 7 #CG_SpecList$)
;-- 2011/11/24 A.Satoh Add - S
              (nth 13 #CG_SpecList$)
              (nth 14 #CG_SpecList$)
;-- 2011/11/24 A.Satoh Add - E
            )
          )
        )
        (setq #CG_SpecListA$$ (append #CG_SpecListA$$ #list$))
      )
      (progn
        (setq #d_cnt (1+ #d_cnt))
        ; 収納用情報リスト作成
        (setq #list$
          (list
            (list
              #d_cnt
              (nth 1 #CG_SpecList$)
              (nth 2 #CG_SpecList$)
              (nth 3 #CG_SpecList$)
              (nth 4 #CG_SpecList$)
              (nth 5 #CG_SpecList$)
              (nth 6 #CG_SpecList$)
              (nth 7 #CG_SpecList$)
;-- 2011/11/24 A.Satoh Add - S
              (nth 13 #CG_SpecList$)
              (nth 14 #CG_SpecList$)
;-- 2011/11/24 A.Satoh Add - E
            )
          )
        )
        (setq #CG_SpecListD$$ (append #CG_SpecListD$$ #list$))
      )
    )
  )

  ; 「buzai.cfg」の出力
  (setq #fname (strcat CG_KENMEIDATA_PATH "buzai.cfg"))
  (setq #fp  (open #fname "w"))
  (if (/= #fp nil)
    (progn
      (if #CG_SpecListA$$
        (progn
          (princ "[A]\n" #fp)
          (foreach #CG_SpecListA$ #CG_SpecListA$$
            (setq #i 0)
            (repeat (1- (length #CG_SpecListA$))
              (princ (nth #i #CG_SpecListA$) #fp)
              (princ "," #fp)
              (setq #i (1+ #i))
            )
            (princ (nth #i #CG_SpecListA$) #fp)
            (princ "\n" #fp)
          )
        )
      )

      (if #CG_SpecListD$$
        (progn
          (princ "[D]\n" #fp)
          (foreach #CG_SpecListD$ #CG_SpecListD$$
            (setq #i 0)
            (repeat (1- (length #CG_SpecListD$))
              (princ (nth #i #CG_SpecListD$) #fp)
              (princ "," #fp)
              (setq #i (1+ #i))
            )
            (princ (nth #i #CG_SpecListD$) #fp)
            (princ "\n" #fp)
          )
        )
      )

;-- 2011/09/02 A.Satoh Add - S
      (if #Expense$
        (progn
          (princ "[EXPENSE]\n" #fp)
          (setq #i 0)
          (repeat (length #Expense$)
            (princ (car (nth #i #Expense$)) #fp)
            (princ (cadr (nth #i #Expense$)) #fp)
            (princ "\n" #fp)
            (setq #i (1+ #i))
          )
        )
      )
;-- 2011/09/02 A.Satoh Add - E

      (close #fp)
    )
  )

  ; 「配置部材一括確認」モジュール呼び出し
  (C:arxStartApp (strcat CG_SysPATH "ConfAllParts.exe") 1)

;  (alert "★★★　工事中　★★★")

  ; 後処理
  (setq *error* nil)

  (princ)
);C:ConfPartsAll


;-- 2011/09/02 A.Satoh Add - S
;;;<HOM>************************************************************************
;;; <関数名>  : ConfPartsAll_GetExpenseFromBuzaiFile
;;; <処理概要>: buzai.cfgの[EXPENSE]項目をリストで返す
;;; <戻り値>  : Expense項目リスト or nil
;;; <作成>    : 2011/09/02 A.Satoh
;;; <備考>    : 
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetExpenseFromBuzaiFile (
  /
  #fname #fp #ret$ #buf #j #loop #str #title
#syori ;2011/09/23 YM ADD
  )

  ; buzai.cfgを開く
  (setq #fname (strcat CG_KENMEIDATA_PATH "buzai.cfg"))
  (setq #fp (open #fname "r"))
  (if (/= #fp nil)
    (progn
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
              (setq #j 1)
              (setq #loop T)
              (repeat (strlen #buf)
                (if (= #loop T)
                  (progn
                    (if (= (substr #buf #j 1) "=")
                      (progn
                        (setq #title (substr #buf 1 #j))
                        (setq #str (substr #buf (1+ #j)))
                        (setq #loop nil)
                      )
                    )
                    (setq #j (1+ #j))
                  )
                )
              )

              (setq #ret$ (append #ret$ (list (list #title #str))))
            )
          )
        )
      )

      (close #fp)
    )
    (setq #ret$ nil)
  )


  #ret$

) ;ConfPartsAll_GetExpenseFromBuzaiFile
;-- 2011/09/02 A.Satoh Add - S


;;;<HOM>************************************************************************
;;; <関数名>  : ConfPartsAll_SetSpecList
;;; <処理概要>: 配置部材の仕様表情報を設定する
;;; <戻り値>  : 仕様表情報リスト
;;; <備考>    : 下記グローバル変数を設定
;;;               CG_DBNAME      : DB名称
;;;               CG_SeriesCode  : SERIES記号
;;;               CG_BrandCode   : ブランド記号
;;;************************************************************************>MOH<
(defun ConfPartsAll_SetSpecList (
  /
  #seri$ #spec$$
  )

  ; 現在の商品情報を設定
  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DBNAME      (nth 0 #seri$))  ; DB名称
      (setq CG_SeriesCode  (nth 1 #seri$))  ; SERIES記号
      (setq CG_BrandCode   (nth 2 #seri$))  ; ブランド記号
    )
  )

  ; 共通データベースへの接続
  (if (= CG_CDBSESSION nil)
    (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  )

  ; SERIES別データベースへの接続
  (if (= CG_DBSESSION nil)
    (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  )

;  ;// 配置部材仕様情報を取得
;  (princ "\n配置部材の仕様情報を取得しています...")

  ; 配置部材仕様詳細情報を取得
  (setq #spec$$ (ConfPartsAll_GetSpecInfo))

  ; 配置部材仕様詳細情報を取得
  (setq #spec$$ (ConfPartsAll_GetSpecList #spec$$))


;  ;// 仕様番号Ｐ点に品番名称を設定
;  (SKB_SetBalPten)

  #spec$$

) ;ConfPartsAll_SetSpecList




;;;<HOM>************************************************************************
;;; <関数名>  : ConfPartsAll_GetSpecInfo
;;; <処理概要>: 配置部材仕様詳細情報を取得する
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                 1.連番(1～)
;;;                 2.ソートキー
;;;                 3.ワークトップ品番名称
;;;                 4.図形ハンドル
;;;                 5.入力配置用品番名称
;;;                 6.出力名称コード
;;;                 7.仕様名称コード
;;;                 8.個数
;;;                 9.金額
;;;                10.品コード
;;;                11.部材種類フラグ (0:標準部材 1:特注WT 2:天井フィラー 3:補足部材)
;;;                12.集約ID
;;;                13.寸法
;;;                14.掛率or上乗せ額
;;;               )
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetSpecInfo (
  /
  #wtlst$$
  #bzlst$$
  #all-lst$$
  #dtlst$$
  #lst$
  #no
  #filer$
  #hosoku$
  #option$
  #SpecInfo$$ #BGLST$$ #KEKOMI$
  )

    ;//////////////////////////////////////////////////
    ; 同じ品番なら個数を増やす
    ;//////////////////////////////////////////////////
    (defun ##HINBAN_MATOME (
      &lis$
      /
      #ret$ #LR #e #hin #ko #kosu #loop #i #dum$ #f #fnew
      #hin$
;-- 2011/08/12 A.Satoh Add - S
      #bunrui
;-- 2011/08/12 A.Satoh Add - E
			#t_flg	;-- 2011/11/24 A.Satoh Add
      )

      (setq #ret$ nil #hin$ nil)
      (foreach #e &lis$
        (setq #hin (nth 1 #e))
        (setq #LR  (nth 3 #e))
        (setq #ko  (nth 6 #e))
;-- 2011/08/12 A.Satoh Add - S
        (setq #bunrui (nth 11 #e))
;-- 2011/08/12 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
				(setq #t_flg (nth 13 #e))
;-- 2011/11/24 A.Satoh Add - E

;-- 2011/08/12 A.Satoh Mod - S
;        (setq #dum$ (list #hin #LR))
        (setq #dum$ (list #hin #LR #bunrui))
;-- 2011/08/12 A.Satoh Mod - E
        (if (member #dum$ #hin$)
;-- 2011/11/24 A.Satoh Add - S
					(if (= #t_flg 0)
;-- 2011/11/24 A.Satoh Add - W
          (progn ; 同じものあり
            (setq #loop T #i 0)
            (setq #kosu (length #ret$))
            (while (and #loop (< #i #kosu))
              (setq #f (nth #i #ret$))
              (if (and (= (nth 1 #f) #hin)(= (nth 3 #f) #LR))
                (progn
                  (setq #loop nil)
                  (setq #fnew (CFModList #f (list (list 6 (+ #ko (nth 6 #f))))))
                )
              )
              (setq #i (1+ #i))
            )
            (setq #ret$ (subst #fnew #f #ret$)) ; 要素入替え
          )
;-- 2011/11/24 A.Satoh Add - S
						(progn
	            (setq #hin$ (append #hin$ (list (list #hin #LR #bunrui)))) ; 品番ﾘｽﾄ
	            (setq #ret$ (append #ret$ (list #e)))
						)
					)
;-- 2011/11/24 A.Satoh Add - W
          (progn ; 初めて
;-- 2011/08/12 A.Satoh Mod - S
;            (setq #hin$ (append #hin$ (list (list #hin #LR)))) ; 品番ﾘｽﾄ
            (setq #hin$ (append #hin$ (list (list #hin #LR #bunrui)))) ; 品番ﾘｽﾄ
;-- 2011/08/12 A.Satoh Mod - E
            (setq #ret$ (append #ret$ (list #e)))
          )
        )
      )
      #ret$
    );##HINBAN_MATOME
    ;//////////////////////////////////////////////////

; ; SET構成確認ｺﾏﾝﾄﾞのときは作図しない
;  ; ワークトップ、天井フィラーの仕様番号点を作図
; (if (= nil CG_SetHIN)
;   (progn
;     (KP_DelPTWF) ; 既存の"G_PTWF"を削除する
;     (SKB_MakeWkTopBaloonPoint)
;   )
; )

  ; ワークトップ図形のＷＴ品番情報を検索し、ワークトップ名称を取得
  ; WT素材.DBより現在の素材IDの出力名称コード・仕様名称コードを取得
  ; ワークトップ品番名称・図形ハンドル・出力名称コード・仕様名称コードの一覧表作成
  ; ワークトップが２種類以上ある場合には拡張データ内のWTタイプの番号に並べ替え
  ; ソートキーは０、入力配置用品番名称は品番名称と同じ内容、個数は１を格納
  ;#wtlst$$
  ;例:((0 "HQSI255H-ALQ-L" "2550" "40" "650" "ｽﾃﾝﾚｽSLﾄｯﾌﾟ I 型 D650 H     　Ｌ" 1 126000.0 "A10" ("4C27")))
  (setq #wtlst$$ (ConfPartsAll_GetWKTopList))

  ; 配置済み部材の工種記号・SERIES記号・品番名称・Ｌ／Ｒ区分より品番図形.DBを検索
  ; 品番名称・入力配置用品番名称・図形ハンドルの一覧表を作成
  ; ただし、入力配置用品番名称が同一の場合は１行にまとめて個数＋１
  ;#bzlst$$
  ;例 ("H$030WFB-7%#-@@[J:BW]" "L" "A" ("4937") 1 "0")
  (setq #bzlst$$ (ConfPartsAll_GetBuzaiList))

  (if #bzlst$$
    (progn
      ; 一覧表の品番名称と工種記号・SERIES記号をキーにして品番基本.DBを検索
      ; ソートキー・出力名称コード・仕様名称コードを取得して一覧表に追加
      (setq #dtlst$$ (ConfPartsAll_GetDetailList #bzlst$$))

      ; 一覧表作成後、集約IDおよびソートキーで昇順に並び替え
      ; 一覧表作成後、第1key=集約ID(nth 10),第2key=品番基本.ｿｰﾄｷｰ(nth 0)で昇順に並び替え
      ;#dtlst$$
      ;例:(1011 "H$090S2A-JN#-@@[J:BW]" ("426D") "Z" 0 0 1 0 "xxxxxxx" "0" "A20" "A")
      (if #dtlst$$
        (setq #dtlst$$ (ListSortLevel2 #dtlst$$ 10 0))
      )
    )
  )

  ; ワークトップ一覧に部材一覧を追加
  (setq #all-lst$$ (append #wtlst$$ #dtlst$$))

  ; フィラー関連の仕様情報を追加
  (if (/= nil (setq #filer$ (ConfPartsAll_GetFillerInfo)))
    (setq #all-lst$$ (append #all-lst$$ #filer$))
  )
  ;#filer$
  ;例: ((2046 "HSCM240R-@@" ("4E76") "Z" 0 0 1 0 "xxxxxxx" "2" "A60" "A"))

  ; 追加部材の仕様情報を追加
  (if (/= nil (setq #hosoku$ (ConfPartsAll_GetHosokuInfo)))
    (setq #all-lst$$ (append #all-lst$$ #hosoku$))
  )

  ; オプションアイテムの仕様情報を追加
  (if (/= nil (setq #option$ (ConfPartsAll_GetOptionInfo)))
    (setq #all-lst$$ (append #all-lst$$ #option$))
  )
  (setq #all-lst$$ (##HINBAN_MATOME #all-lst$$))

  ; 一覧表作成後、集約IDおよびソートキーで昇順に並びえ
  (if #all-lst$$
    ; 一覧表作成後、第1key=集約ID(nth 10),第2key=品番基本.ｿｰﾄｷｰ(nth 0)で昇順に並び替え
    (setq #all-lst$$ (ListSortLevel2 #all-lst$$ 10 0))
  )

  ; 扉個別指定対応  同じ集約ID(nth 10),ｿｰﾄｷｰ(nth 0)の場合,品番名称(nth 1)でｿｰﾄする
  (if #all-lst$$
    (setq #all-lst$$ (LisSortHin #all-lst$$ 10 0 1))
  )

  (setq #SpecInfo$$ nil)
  (setq #no 1)

  ; 仕様表情報リストをグローバルに設定
  (foreach #lst$ #all-lst$$
    (setq #SpecInfo$$ (append #SpecInfo$$ (list (cons #no #lst$))))
    (setq #no (1+ #no))
  )

  ; 配置部材仕様情報
  #SpecInfo$$

) ;ConfPartsAll_GetSpecInfo

;;;<HOM>************************************************************************
;;; <関数名>  : ConfPartsAll_GetWKTopList
;;; <処理概要>: ワークトップの仕様詳細情報を取得する
;;; <戻り値>  :
;;;               ; 1.ソートキー
;;;               ; 2.最終品番
;;;               ; 3.巾
;;;               ; 4.高さ
;;;               ; 5.奥行
;;;               ; 6.品名
;;;               ; 7.個数
;;;               ; 8.金額
;;;               ; 9.集約ID  天板,ｶｳﾝﾀｰはきめうち"A10"
;;;               ;10.図形ハンドル
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetWKTopList (
  /
  #ss #i #WT$ #en #xd$ #MAG$ #MAG
  #LAST_HIN #KAKAKU #HINMEI #WWW #HHH #DDD #hnd #lst$$
#TOKU_CD	;-- 2011/12/12 A.Satoh Add
  )

  (setq CG_FuncName "\nConfPartsAll_GetWKTopList")

  ; ワークトップを検索する
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (/= #ss nil)
    (progn
      ; 間口でソートする
      (setq #i 0 #WT$ nil)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_WRKT"))
        (setq #MAG$ (nth 55 #xd$))
        (setq #MAG  (car #MAG$))
        (setq #WT$ (append #WT$ (list (list #MAG #en))))
        (setq #i (1+ #i))
      )
      (setq #WT$ (CFListSort #WT$ 0))
      (setq #WT$ (reverse #WT$))

      (setq #i 0)
      (repeat (length #WT$)
        (setq #en (cadr (nth #i #WT$)))
        ; 拡張データを取得
        (setq #xd$ (CFGetXData #en "G_WTSET"))
        (if (= #xd$ nil)
          (progn
            (CFAlertMsg "ワークトップの品番が確定していません。\n処理を終了します。");2011/09/22 YM MOD
            (exit)
          )
        )
        (setq #LAST_HIN (nth 1 #xd$));最終品番
        (setq #KAKAKU   (nth 3 #xd$));金額
        (setq #HINMEI   (nth 4 #xd$));品名
        (setq #WWW      (nth 5 #xd$));巾
        (setq #HHH      (nth 6 #xd$));高さ
        (setq #DDD      (nth 7 #xd$));奥行
;-- 2011/10/18 A.Satoh Add - S
				(setq #TOKU_CD  (nth 8 #xd$));特注コード
;-- 2011/10/18 A.Satoh Add - E

        ; ワークトップハンドル
        (setq #hnd (cdr (assoc 5 (entget #en))))
        ; ワークトップの情報リストを格納
        (setq #lst$$
          (cons
            (list
              #i              ; 1.ソートキー
              #LAST_HIN       ; 2.最終品番
              #WWW            ; 3.巾
              #HHH            ; 4.高さ
              #DDD            ; 5.奥行
              #HINMEI         ; 6.品名
              1               ; 7.個数
              #KAKAKU         ; 8.金額
              "A10"           ; 9.集約ID  天板,ｶｳﾝﾀｰはきめうち"A10"
              (list #hnd)     ;10.図形ハンドル
              ""
              "A"
;-- 2011/10/18 A.Satoh Add - S
							#TOKU_CD				;13.特注コード
;-- 2011/10/18 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
							(if (= (nth 0 #xd$) 0)
								1
								0
							)
;-- 2011/11/24 A.Satoh Add - E
            )
            #lst$$
          )
        )
        (setq #i (1+ #i))
      )
    )
  )

  #lst$$

) ;ConfPartsAll_GetWKTopList

;;;<HOM>************************************************************************
;;;<関数名>   : ConfPartsAll_GetSpecList
;;; <処理概要>: 仕様表情報を取得する
;;; <戻り値>  : Table.cfgに出力するﾘｽﾄ
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetSpecList (
  &SpecInfo$$ ; (LIST)仕様表情報
  /
  #SpecList$$ #SpecList$ #i #info$ #SORT_KEY #LAST_HIN #WWW #HHH #DDD #HINMEI
  #KOSU #KAKAKU #SYUYAKU_ID #HANDLE #LR #sHinban #drHinban #DoorInfo$ #KOSU
  #Tenkai_ID #Last_Rec$ #bunrui
#Toku_CD #Toku_FLG	;-- 2011/11/24 A.Satoh Add
#xd_TOKU$	;-- 2011/12/09 A.Satoh Add
  )

  (setq #SpecList$$ nil)
  (setq #i 1)

  (foreach #info$ &SpecInfo$$
    (if (< (nth 1 #info$) 10);ソートキーが10以下なら天板とみなす
      ; ワークトップの場合
      (progn
        (setq #SORT_KEY   (nth 1 #info$))
        (setq #LAST_HIN   (nth 2 #info$))
        (setq #WWW        (nth 3 #info$))
        (setq #HHH        (nth 4 #info$))
        (setq #DDD        (nth 5 #info$))
        (setq #HINMEI     (nth 6 #info$))
        (setq #KOSU       (nth 7 #info$))
        (setq #KAKAKU     (nth 8 #info$))
        (setq #SYUYAKU_ID (nth 9 #info$))
        (setq #HANDLE     (nth 10 #info$))
        (setq #sHinban    #LAST_HIN)
        (setq #LR         "")
        (setq #drHinban   #sHinban)
        (setq #bunrui     (nth 12 #info$))
;-- 2011/10/12 A.Satoh Add - S
				(setq #Tenkai_ID -1)
;-- 2011/10/12 A.Satoh Add - E
;-- 2011/10/18 A.Satoh Add - S
        (setq #Toku_CD    (nth 13 #info$))
;-- 2011/10/18 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
				(setq #Toku_FLG   (nth 14 #info$))
;-- 2011/11/24 A.Satoh Add - E
      )
      (progn
        (setq #SORT_KEY   (nth 1 #info$))
        (setq #sHinban    (nth 2 #info$));CAD品番
        (setq #drHinban #sHinban);[]付き品番

        ;ここで部材ごとの扉情報があれば取得する
        (setq #DoorInfo$ (KP_GetSeriStr #sHinban));扉ｸﾞﾚｰﾄﾞ,扉色,引手のﾘｽﾄ

        (setq #sHinban    (KP_DelDrSeriStr #sHinban))
        (if (= #DoorInfo$ nil)
          (setq #drHinban #sHinban)
        )

        (setq #HANDLE     (nth 3 #info$))
        (setq #LR         (nth 4 #info$))
        (setq #SYUYAKU_ID (nth 11 #info$))
        (setq #KOSU       (nth 7 #info$));???
        (setq #Tenkai_ID (GetTenkaiID #sHinban));整数を返す
        (setq #bunrui     (nth 12 #info$))

				;2017/10/30 YM MOD-S

;;;        (if (or (= #LR "L")(= #LR "R"))
;;;          (setq #drHinban (strcat #drHinban #LR))
;;;        )

				;L/R有無を"%"有無で判断する (%)で明細２行になってしまう対策
		    (if (vl-string-search "%" #drHinban)
		      (progn ;"%"あり
	          (setq #drHinban (strcat #drHinban #LR))
					)
					(progn
						nil
					)
        );_if

				;2017/10/30 YM MOD-E


;-- 2011/12/09 A.Satoh Mod - S
;;;;;;-- 特注しよう確定までの暫定処理
;;;;;;******************************************
;;;;;;-- 2011/10/18 A.Satoh Add - S
;;;;;        (setq #Toku_CD    "")
;;;;;;-- 2011/10/18 A.Satoh Add - E
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;				(setq #Toku_FLG   0)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;******************************************
        (setq #Toku_CD    (nth 13 #info$))
				(setq #Toku_FLG   (nth 14 #info$))
;-- 2011/12/09 A.Satoh Mod - E

        (cond
          ((= #Tenkai_ID 0)
            ;品番最終を検索
            (if #DoorInfo$
              (progn ;扉情報(扉ｸﾞﾚｰﾄﾞ,扉色,引手)があれば専用処理
                ;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
                (setq #Last_Rec$ (GetLast_Rec_DoorInfo #sHinban #LR #DoorInfo$));品番最終のﾚｺｰﾄﾞを返す
              )
              (progn
                ;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
                (setq #Last_Rec$ (GetLast_Rec #sHinban #LR 0));品番最終のﾚｺｰﾄﾞを返す
              )
            );_if
          )
          ((= #Tenkai_ID 1)
            ;品番,LR
            (setq #Last_Rec$ (GetLast_Rec #sHinban #LR 1));品番最終のﾚｺｰﾄﾞを返す
          )
          ((= #Tenkai_ID 2)
            ;品番,LR,ｶﾞｽ種
            (setq #Last_Rec$ (GetLast_Rec #sHinban #LR 2));品番最終のﾚｺｰﾄﾞを返す
          )
          ((= #Tenkai_ID nil)
            ;ERROR
            (setq #Last_Rec$ nil)
          )
        );_cond

        (if #Last_Rec$
          (progn
            (setq #LAST_HIN   (ai_strrtrim(nth 10 #Last_Rec$)))
            (setq #WWW        (nth 11 #Last_Rec$))
            (setq #HHH        (nth 12 #Last_Rec$))
            (setq #DDD        (nth 13 #Last_Rec$))
            (setq #HINMEI     (ai_strrtrim(nth 14 #Last_Rec$)))
            (setq #KAKAKU     (nth  8 #Last_Rec$))
          )
          (progn
;-- 2011/12/09 A.Satoh Add - S
						(if (= #Toku_FLG 1)
							(progn
								(setq #xd_TOKU$ (CFGetXData (handent (car #HANDLE)) "G_TOKU"))
								(if #xd_TOKU$
									(progn
				            (setq #LAST_HIN   (nth 0 #xd_TOKU$))
        				    (setq #WWW        (itoa (fix (nth 4 #xd_TOKU$))))
				            (setq #HHH        (itoa (fix (nth 5 #xd_TOKU$))))
        				    (setq #DDD        (itoa (fix (nth 6 #xd_TOKU$))))
				            (setq #HINMEI     (nth 2 #xd_TOKU$))
        				    (setq #KAKAKU     (nth 1 #xd_TOKU$))
									)
									(progn
				            (setq #LAST_HIN   "")
        				    (setq #WWW        "")
				            (setq #HHH        "")
        				    (setq #DDD        "")
				            (setq #HINMEI     "")
        				    (setq #KAKAKU     "")
									)
								)
							)
							(progn
;-- 2011/12/09 A.Satoh Add - E
            (setq #LAST_HIN   "")
            (setq #WWW        "")
            (setq #HHH        "")
            (setq #DDD        "")
            (setq #HINMEI     "")
            (setq #KAKAKU     "")
;-- 2011/12/09 A.Satoh Add - S
							)
						)
;-- 2011/12/09 A.Satoh Add - E
          )
        )
      )
    )

		;2016/11/11 YM ADD-S [品番最終]nil回避
	  (if (= nil #WWW)(setq #WWW "0"))           ;巾
	  (if (= nil #HHH)(setq #HHH "0"))           ;高さ
	  (if (= nil #DDD)(setq #DDD "0"))           ;奥行
	  (if (= nil #HINMEI)(setq #HINMEI " "))     ;品名
	  (if (= nil #KAKAKU)(setq #KAKAKU 0.0))     ;価格
	  (if (= nil #LAST_HIN)(setq #LAST_HIN " ")) ;最終品番
		;2016/11/11 YM ADD-E

    ; 仕様表情報リストを作成する
    (setq #SpecList$
      (list
        (itoa #i)   ;明細番号
        #LAST_HIN   ;最終品番
        #WWW        ;巾
        #HHH        ;高さ
        #DDD        ;奥行
        #HINMEI     ;品名
        #KOSU       ;個数
        #KAKAKU     ;価格
;        #SYUYAKU_ID ;集約ID
;        #sHinban    ;CAD品番
;        #LR         ;LR区分
;        #drHinban   ;[]付き品番
        #bunrui     ;分類
;-- 2011/10/12 A.Satoh Add - S
        #SYUYAKU_ID ;集約ID
				#Tenkai_ID	; 展開タイプ
        #sHinban    ;CAD品番
        #LR         ;LR区分
;-- 2011/10/12 A.Satoh Add - E
;-- 2011/10/18 A.Satoh Add - S
				#Toku_CD		;特注コード
;-- 2011/10/18 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
				#Toku_FLG		;特注フラグ
;-- 2011/11/24 A.Satoh Add - E
      )
    )

    (setq #SpecList$$ (append #SpecList$$ (list #SpecList$)))

    (setq #i (1+ #i))
  );(foreach

  #SpecList$$

) ; ConfPartsAll_GetSpecList


    ;/////////////////////////////////////////////////////////////////////////////
    ; 同じ品番なら個数を増やす 品番に%を含むかどうかでL/R判断
    ;/////////////////////////////////////////////////////////////////////////////
    (defun ##HINBAN_MATOME2 (
      &lis$
      /
      #hinLR$ #e #hin #LR #bunrui #hinLR$ #hinLR #loop #kosu #ii #f #fnew #ret$
			#F_LR #TOKU_F #KO #newLR ;2018/01/09 YM ADD
      )

;;;(if (vl-string-search "%" #kihon_hin)

      (setq #hinLR$ nil)
      (foreach #e &lis$
        (setq #hin    (nth 0 #e))
        (if (vl-string-search "%" (KP_DelHinbanKakko #hin));()外して"%"有無判定
					(setq #LR 1) ;L/Rあり 商品仕様上のLRがあるかどうか
					;else
					(setq #LR 0)
				);_if
        (setq #bunrui (nth 2 #e))
        (setq #ko (nth 4 #e))
        (setq #hinLR  (list #hin #LR #bunrui))
				(setq #toku_f (nth 7 #e))
        (if (and (member #hinLR #hinLR$) (= #LR 0) (= #toku_f 0))
          (progn
            (setq #loop T #ii 0)
            (setq #kosu (length #ret$))
						(setq #fnew nil)
            (while (and #loop (< #ii #kosu))
              (setq #f (nth #ii #ret$))

			        (if (vl-string-search "%" (KP_DelHinbanKakko (nth 0 #f)));()外して"%"有無判定
								(setq #f_LR 1);L/Rあり
								;else
								(setq #f_LR 0)
							);_if

              (if (and (= (nth 0 #f) #hin) (= #f_LR #LR) (= #f_LR 0) (= (nth 2 #f) #bunrui))
                (progn
									;2018/01/09 YM ADD-S
									(setq #newLR (nth 1 #f))
									(if (= #f_LR 0)(setq #newLR "Z"))
									;2018/01/09 YM ADD-E

                  (setq #loop nil)
                  (setq #fnew
                    (CFModList #f
                      (list
                        (list 1 #newLR) ; 2018/01/09 YM ADD
                        (list 3 (append (nth 3 #f) (nth 3 #e))) ; 図形ﾊﾝﾄﾞﾙ追加
                        (list 4 (+ #ko (nth 4 #f)))             ; 個数加算
                      )
                    )
                  )
                )
              );_if
              (setq #ii (1+ #ii))
            );while
						(if #fnew
            	(setq #ret$ (subst #fnew #f #ret$)) ; 要素入替え
						);_if
          )
          (progn
            (setq #hinLR$ (append #hinLR$ (list #hinLR))) ; (品番,LR,分類)ﾘｽﾄ
            (setq #ret$ (append #ret$ (list #e)))
          )
        )
      )

      #ret$

    ) ;##HINBAN_MATOME2


;;;<HOM>************************************************************************
;;; <関数名>  : ConfPartsAll_GetBuzaiList
;;; <処理概要>: 品番名称・入力配置用品番名称・図形ハンドルの一覧表作成
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                 1.工種記号
;;;                 2.SERIES記号
;;;                 3.品番名称
;;;                 4.入力配置用品番名称
;;;                 5.図形ハンドル
;;;                 6.個数
;;;                 7.部材種類フラグ (0:標準部材 1:特注WT 2:天井フィラー 3:補足部材 +100:特注)
;;;                 8.寸法(※)
;;;                 9.掛率or上乗せ額(※)
;;;               )
;;;             )
;;;             ※8,9は特注キャビネットの場合のみ付加
;;; <備考>    :
;;;             1)配置済み部材の工種記号・SERIES記号・品番名称・Ｌ／Ｒ区分より
;;;               品番図形.DBを検索する。
;;;             2)入力配置用品番名称が同一の場合は１行にまとめて個数を１増分する。
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetBuzaiList (
  /
  #ss #i #sym #xd$ #name #lrcd #DRColCode #bunrui #hnd #lst$
  #lst$$ #lst5$$ #num #sort-lst$$
#xd_TOKU$ #toku_cd #toku_flg	;--2011/12/09 A.Satoh Add
  )

    ;/////////////////////////////////////////////////////////////////////////////
    ; 同じ品番なら個数を増やす
    ;/////////////////////////////////////////////////////////////////////////////
    (defun ##HINBAN_MATOME1 (
      &lis$
      /
      #hinLR$ #e #hin #LR #bunrui #hinLR$ #hinLR #loop #kosu #ii #f #fnew #ret$
      )

      (setq #hinLR$ nil)
      (foreach #e &lis$
        (setq #hin    (nth 0 #e))
        (setq #LR     (nth 1 #e))
        (setq #bunrui (nth 2 #e))
        (setq #hinLR  (list #hin #LR #bunrui))
;-- 2011/12/09 A.Satoh Add - S
				(setq #toku_f (nth 7 #e))
;-- 2011/12/09 A.Satoh Add - E
;-- 2011/12/09 A.Satoh Mod - S
;;;;;        (if (member #hinLR #hinLR$)
        (if (and (member #hinLR #hinLR$) (= #toku_f 0))
;-- 2011/12/09 A.Satoh Mod - E
          (progn
            (setq #loop T #ii 0)
            (setq #kosu (length #ret$))
            (while (and #loop (< #ii #kosu))
              (setq #f (nth #ii #ret$))
              (if (and (= (nth 0 #f) #hin)(= (nth 1 #f) #LR) (= (nth 2 #f) #bunrui))
                (progn
                  (setq #loop nil)
                  (setq #fnew
                    (CFModList #f
                      (list
                        (list 3 (append (nth 3 #f) (nth 3 #e))) ; 図形ﾊﾝﾄﾞﾙ追加
                        (list 4 (1+ (nth 4 #f)))                ; 個数+1
                      )
                    )
                  )
                )
              )
              (setq #ii (1+ #ii))
            )
            (setq #ret$ (subst #fnew #f #ret$)) ; 要素入替え
          )
          (progn
            (setq #hinLR$ (append #hinLR$ (list #hinLR))) ; (品番,LR,分類)ﾘｽﾄ
            (setq #ret$ (append #ret$ (list #e)))
          )
        )
      )

      #ret$

    ) ;##HINBAN_MATOME1
    ;/////////////////////////////////////////////////////////////////////////////


;;;    ;/////////////////////////////////////////////////////////////////////////////
;;;    ; 同じ品番なら個数を増やす 品番に%を含むかどうかでL/R判断
;;;    ;/////////////////////////////////////////////////////////////////////////////
;;;    (defun ##HINBAN_MATOME2 (
;;;      &lis$
;;;      /
;;;      #hinLR$ #e #hin #LR #bunrui #hinLR$ #hinLR #loop #kosu #ii #f #fnew #ret$
;;;			#F_LR #TOKU_F #KO
;;;      )
;;;
;;;;;;(if (vl-string-search "%" #kihon_hin)
;;;
;;;      (setq #hinLR$ nil)
;;;      (foreach #e &lis$
;;;        (setq #hin    (nth 0 #e))
;;;        (if (vl-string-search "%" (KP_DelHinbanKakko #hin));()外して"%"有無判定
;;;					(setq #LR 1);L/Rあり
;;;					;else
;;;					(setq #LR 0)
;;;				);_if
;;;        (setq #bunrui (nth 2 #e))
;;;        (setq #ko (nth 4 #e))
;;;        (setq #hinLR  (list #hin #LR #bunrui))
;;;				(setq #toku_f (nth 7 #e))
;;;        (if (and (member #hinLR #hinLR$) (= #LR 0) (= #toku_f 0))
;;;          (progn
;;;            (setq #loop T #ii 0)
;;;            (setq #kosu (length #ret$))
;;;						(setq #fnew nil)
;;;            (while (and #loop (< #ii #kosu))
;;;              (setq #f (nth #ii #ret$))
;;;
;;;			        (if (vl-string-search "%" (KP_DelHinbanKakko (nth 0 #f)));()外して"%"有無判定
;;;								(setq #f_LR 1);L/Rあり
;;;								;else
;;;								(setq #f_LR 0)
;;;							);_if
;;;
;;;              (if (and (= (nth 0 #f) #hin) (= #f_LR #LR) (= #f_LR 0) (= (nth 2 #f) #bunrui))
;;;                (progn
;;;                  (setq #loop nil)
;;;                  (setq #fnew
;;;                    (CFModList #f
;;;                      (list
;;;                        (list 3 (append (nth 3 #f) (nth 3 #e))) ; 図形ﾊﾝﾄﾞﾙ追加
;;;                        (list 4 (+ #ko (nth 4 #f)))             ; 個数加算
;;;                      )
;;;                    )
;;;                  )
;;;                )
;;;              );_if
;;;              (setq #ii (1+ #ii))
;;;            );while
;;;						(if #fnew
;;;            	(setq #ret$ (subst #fnew #f #ret$)) ; 要素入替え
;;;						);_if
;;;          )
;;;          (progn
;;;            (setq #hinLR$ (append #hinLR$ (list #hinLR))) ; (品番,LR,分類)ﾘｽﾄ
;;;            (setq #ret$ (append #ret$ (list #e)))
;;;          )
;;;        )
;;;      )
;;;
;;;      #ret$
;;;
;;;    ) ;##HINBAN_MATOME2
    ;/////////////////////////////////////////////////////////////////////////////

  (setq CG_FuncName "\nConfPartsAll_GetBuzaiList")

  ; G_LSYMを持つ設備部材を検索
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        (if (CfGetXData #sym "G_KUTAI") ; 躯体は無視
          nil
          (progn
            (setq #xd$ (CFGetXData #sym "G_LSYM"))
;-- 2011/12/09 A.Satoh Add - S
						(setq #xd_TOKU$ (CFGetXData #sym "G_TOKU"))
;-- 2011/12/09 A.Satoh Add - E
;-- 2011/12/09 A.Satoh Mod - S
;;;;;            (setq #name      (nth  5 #xd$)) ; 品番名称
						(if #xd_TOKU$
	            (setq #name      (nth  0 #xd_TOKU$)) ; 品番名称
  	          (setq #name      (nth  5 #xd$)) ; 品番名称
						)
;-- 2011/12/09 A.Satoh Mod - E
            (setq #lrcd      (nth  6 #xd$)) ; ＬＲ区分
            (setq #DRColCode (nth  7 #xd$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"
            (setq #bunrui    (nth 15 #xd$)) ; 分類(A:キッチン D:収納)
;-- 2011/12/09 A.Satoh Add - S
						(if #xd_TOKU$
							(progn
								(setq #toku_cd (nth 3 #xd_TOKU$))
								(setq #toku_flg 1)
							)
							(progn
								(setq #toku_cd "")
								(setq #toku_flg 0)
							)
						)
;-- 2011/12/09 A.Satoh Add - E

            (if (and #DRColCode (vl-string-search "," #DRColCode))
              (progn
                (setq #DRColCode (CMN_string-subst "," ":" #DRColCode))
                (setq #name (strcat #name "[" #DRColCode "]"))
              )
            )

            ; 図形ハンドル
            (setq #hnd (cdr (assoc 5 (entget #sym))))

						;2018/01/29 YM ADD-S 【重要】品番の括弧をここで外してしまう。括弧外しても品番基本のデータが同じ前提
						(setq #name (KP_DelHinbanKakko #name))

            (setq #lst$
              (list
                #name       ; 品番名称
                #lrcd       ; LR区分
                #bunrui     ; 分類
                (list #hnd) ; 図形ハンドル
;-- 2011/12/09 A.Satoh Add - S
								1
								"0"
								#toku_cd		; 特注コード
								#toku_flg		; 特注フラグ
								(nth  5 #xd$)	; 品番名称（特注処理用)
;-- 2011/12/09 A.Satoh Add - E
              )
            )
            (setq #lst$$ (append #lst$$ (list #lst$)))
          )
        )
        (setq #i (1+ #i))
      )

      ; 品番名称でソートして同一部材の個数を取得する
      (setq #lst$$ (CFListSort #lst$$ 0))

      ; 規格品のみの前提
      (setq #lst5$$ nil)
;-- 2011/12/09 A.Satoh Del - S
;;;;;      (setq #num 1)
;-- 2011/12/09 A.Satoh Del - E
      (foreach #lst$ #lst$$
;-- 2011/12/09 A.Satoh Del - S
;;;;;        (setq #lst$ (append #lst$ (list #num "0")))
;-- 2011/12/09 A.Satoh Del - E
        (setq #lst5$$ (append #lst5$$ (list #lst$)))
      )

      ; 標準品処理(同一ｱｲﾃﾑ個数加算)
      (setq #sort-lst$$ (##HINBAN_MATOME1 #lst5$$))

			;2017/10/30 YM ADD-S
			;2018/10/15 YM MOD-S
;;;			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
	      (setq #sort-lst$$ (##HINBAN_MATOME2 #sort-lst$$))
;;;			);_if
			;2018/10/15 YM MOD-E
			;2017/10/30 YM ADD-E

    )
    (princ "図面上に部材がありません。")
  )

  #sort-lst$$

) ;ConfPartsAll_GetBuzaiList

;;;<HOM>************************************************************************
;;; <関数名>  : ConfPartsAll_GetDetailList
;;; <処理概要>: 設備部材の詳細情報を取得する
;;; <戻り値>  : (list
;;;                (list
;;;                   1.ソートキー
;;;                   2.品番名称
;;;                   3.図形ハンドル
;;;                   4.入力配置用品番名称
;;;                   5.出力名称コード
;;;                   6.仕様名称コード
;;;                   7.個数
;;;                   8.金額
;;;                   9.品コード
;;;                  10.部材種類フラグ
;;;                  11.集約ID
;;;                  12.分類
;;;                )
;;;                ...
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetDetailList (
  &lst$$  ;(LIST)
          ;  (list
          ;    (list
          ;      1.品番名称
          ;      2.LR区分
          ;      3.分類
          ;      4.図形ハンドルリスト
          ;      5.個数
          ;      6.部材種類フラグ
					;      7.特注コード
					;      8.特注フラグ
					;      9.元々の品番名称
          ;    )
          ;  )
          ;　例 (("H$030WFB-7%#-@@[J:BW]" "L" "A" ("4937") 1 "0") (・・・)・・・)
  /
  #BaseHinban$ #BaseHinban #i #lst$ #hinban #qry$
  #dupflag #dlstent$ #dlst$$ #dlst$ #newent$ 
  #sym #Errmsg #qry2$ #syuyaku
  )

  (setq CG_FuncName "\nConfPartsAll_GetDetailList")

  (setq #BaseHinban$ nil) ; 品番基本検索に失敗した品番
  (setq #i 0)
  (foreach #lst$ &lst$$
    (setq #hinban (nth 0 #lst$))
    (WebOutLog (strcat (itoa #i) "-" #hinban))
    ; []部分を取り除く
    (setq #hinban (KP_DelDrSeriStr #hinban))
;-- 2011/12/09 A.Satoh Add - S
		; 特注品番である場合
		(if (= (nth 7 #lst$) 1)
			(setq #hinban (nth 8 #lst$))
		)
;-- 2011/12/09 A.Satoh Add - S

    ; 『品番基本』を取得する
    (setq #qry$
      (car (CFGetDBSQLHinbanTable "品番基本" #hinban
      (list (list "品番名称" #hinban 'STR))))
    )

    ; 品番基本.積算F=1は除外する処理を追加 ★OK
    (if (and (/= nil #qry$)(not (equal 1.0 (nth 6 #qry$) 0.1)))
      (progn
        ;重複品番は数量を加算する
        (setq #dupflag nil) ; 重複ﾌﾗｸﾞOFF
        ;作成済み一覧分ﾙｰﾌﾟ
        (foreach #dlstent$ #dlst$$
          (if (and #dlstent$
                   (= (nth 3 #dlstent$) (nth 1 #lst$)) ;"L" or "R"を比較。
                   (= (nth 1 #dlstent$)(KP_DelHinbanKakko (nth 0 #lst$))) ; 品番名称を比較
;-- 2011/08/11 A.Satoh Add - S
                   (= (nth 11 #dlstent$) (nth 5 #lst$)) ; 分類 "A" or "D" を比較
;-- 2011/08/11 A.Satoh Add - E
                   )
            (progn
              (setq #newent$   ; 新しくﾘｽﾄを作り直す
                (list
                  (nth  0 #dlstent$)                       ;  1.ソートキー
                  (nth  1 #dlstent$)                       ;  2.品番名称
                  (append (nth 2 #dlstent$) (nth 3 #lst$)) ;  3.元の図形ﾊﾝﾄﾞﾙに図形ﾊﾝﾄﾞﾙを追加する
                  (nth  3 #dlstent$)                       ;  4.入力配置用品番名称
                  (nth  4 #dlstent$)                       ;  5.出力名称ｺｰﾄﾞ
                  (nth  5 #dlstent$)                       ;  6.仕様名称ｺｰﾄﾞ
                  (+ (nth 6 #dlstent$) (nth 4 #lst$))      ;  7.元の個数に現在の個数を加算する
                  (nth  7 #dlstent$)                       ;  8.金額(見積もり処理で取得)
                  (nth  8 #dlstent$)                       ;  9.品ｺｰﾄﾞ
                  (nth  9 #dlstent$)                       ; 10.部材種類ﾌﾗｸﾞ
                  (nth 10 #dlstent$)                       ; 11.集約ID
                  (nth  2 #lst$)                           ; 12.分類
                )
              )
              (setq #dlst$$ (subst #newent$ #dlstent$ #dlst$$));新旧要素情報入替
              (setq #dupflag T)                    ;重複ﾌﾗｸﾞON
            )
          )
        )

        (if (not #dupflag)
          (progn
            (if (and (= (nth 2 #lst$) "D") (= (substr (nth 5 #qry$) 1 1) "A"))
              (progn
                (setq #qry2$
                  (car (CFGetDBSQLHinbanTable "集約ID変換" #hinban
                  (list (list "品番名称" #hinban 'STR))))
                )

                (if (/= #qry2$ nil)
                  (setq #syuyaku (nth 1 #qry2$))
                  (setq #syuyaku (nth 5 #qry$))
                )
              )
              (setq #syuyaku (nth 5 #qry$))
            )

            (setq #dlst$
              (list
                (fix (nth 2 #qry$))               ;  1.ソートキー
                (KP_DelHinbanKakko (nth 0 #lst$)) ;  2.品番名称
                (nth 3 #lst$)                     ;  3.図形ハンドル
                (nth 1 #lst$)                     ;  4.L/R
                0                                 ;  5.出力名称コード
                0                                 ;  6.仕様名称コード
                (nth 4 #lst$)                     ;  7.個数
                0                                 ;  8.金額(見積り処理で取得)
                "xxxxxxx"                         ;  9.品コード
                (nth 5 #lst$)                     ; 10.部材種類フラグ
                ;(nth 5 #qry$)                     ; 11.集約ID
                #syuyaku                          ; 11.集約ID
                (nth 2 #lst$)                     ; 12.分類
;-- 2011/12/09 A.Satoh Add - S
								(nth 6 #lst$)											; 13.特注コード
								(nth 7 #lst$)											; 14.特注フラグ
;-- 2011/12/09 A.Satoh Add - E
              )
            )
            (setq #dlst$$ (append #dlst$$ (list #dlst$)))
          )
        )
      )
      ;else 品番基本になかったか or あっても積算F=1 の場合
      (progn
        ;ｼﾝｸかどうか判定する
        (setq #sym (handent (car (nth 3 #lst$))))
        (if (or (and #sym (equal CG_SKK_INT_SNK (nth 9 (CFGetXData #sym "G_LSYM")) 0.1)) ; 性格ｺｰﾄﾞ=410(ｼﾝｸ)の場合
                (and (/= nil #qry$)(equal 1.0 (nth 6 #qry$) 0.1))) ; 品番基本にあるが、積算F=1の場合 ★OK
          nil ; 元々[品番基本]に登録されていないので例外的に除外する 積算F=1は対象にしない
          ; else
          (progn
            (setq #BaseHinban$ (append #BaseHinban$ (list #hinban)))
          )
        );_if
      )
    );_if
    (setq #i (1+ #i))
  );_foreach

  (if #BaseHinban$
    (progn
      (setq #Errmsg "\n")
      (foreach #BaseHinban #BaseHinban$
        (setq #Errmsg (strcat #Errmsg #BaseHinban "\n"))
      )
      (CFYesDialog (strcat "\n以下の品番がﾃﾞｰﾀﾍﾞｰｽにありませんでした。"
                           "\n※配置部材確認画面に表示されませんのでご注意ください。"
                           "\n  "
                           "\n＜原因＞"
                           "\n商品が廃版になったか、ﾃﾞｰﾀﾍﾞｰｽのﾊﾞｰｼﾞｮﾝが古いか"
                           "\n或いはﾃﾞｰﾀﾍﾞｰｽに誤りがあることが考えられます。"
                           "\n  "
                           #Errmsg))
    )
  );_if

  #dlst$$

) ;ConfPartsAll_GetDetailList

;;;<HOM>************************************************************************
;;; <関数名>  : ConfPartsAll_GetFillerInfo
;;; <処理概要>: 天井処理関連アイテムの仕様詳細情報を取得する
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                  1.ソートキー
;;;                  2.品番名称
;;;                  3.図形ハンドル群
;;;                  4.入力配置用品番名称
;;;                  5.出力名称コード
;;;                  6.仕様名称コード
;;;                  7.個数
;;;                  8.金額
;;;                  9.品コード
;;;                 10.アイテム種類(0:標準 1:特注WT 2:天井関連 3:補足)
;;;                 11.集約ID
;;;                 12.分類
;;;               )
;;;               …
;;;             )
;;; <備考>    : 11/08/04 A.Satoh 新規作成

;;;************************************************************************>MOH<
(defun ConfPartsAll_GetFillerInfo (
  /
  #sKind #Flr$$ #Flr$ #iCnt #fLen #bunrui #out$$
  #xFlr #eName #sHnd #eed$ #sCode #iType #fLen
  #rec$ #iCnt1 #iCnt2 #fLen1 #fLen2 #fLen3
;-- 2011/08/12 A.Satoh Add - S
  #kosu #idx #upd_flg #wk_flr$ #wk_flr1$
;-- 2011/08/12 A.Satoh Add - E
  #FLRN$ #SHND$ #XDOPT$ ;2011/09/23 YM ADD
  )

  (setq #sKind  "2") ; 天井関連(固定)
  (setq #Flr$$  nil)
  (setq #iCnt   0)
  (setq #fLen   0.0)
  (setq #out$$  nil)
;-- 2011/08/11 A.Satoh Del - S
;  (setq #bunrui "A") ; キッチン("A")固定
;-- 2011/08/11 A.Satoh Del - E

  ; 天井関連の図形を検索
  (setq #xFlr (ssget "X" (list (list -3 (list "G_FILR")))))
  (if #xFlr
    (repeat (sslength #xFlr)
      (setq #eName (ssname #xFlr #iCnt))
      (setq #sHnd  (cdr (assoc 5 (entget #eName))))
      (setq #eed$  (CFGetXData #eName "G_FILR"))
      (setq #sCode (nth 0 #eed$))
      (setq #iType (nth 3 #eed$)) ; #iType
                                  ;  1:天井ﾌｨﾗｰ 2:支輪 3:飾り縁 4:ｹｺﾐ飾り 5:幅木 6:ｱｲﾚﾍﾞﾙﾊﾝｶﾞｰｼｽﾃﾑの飾り縁 7:壁処理用ｽﾍﾟｰｻｰ
      (if (/= 7 #iType)
        (setq #fLen (CfGetLWPolyLineLen (nth 2 #eed$)))
        (setq #fLen (nth 4 #eed$))
      )
;-- 2011/08/11 A.Satoh Add - S
      ; 分類の取得
      (if (= (length #eed$) 8)
        (setq #bunrui (nth 7 #eed$))
        (setq #bunrui "A") ; キッチン("A")固定
      )

      ; 個数取得
      (setq #xdOPT$ (CFGetXData #eName "G_OPT"))
      (if #xdOPT$
        (setq #kosu (1+ (nth 2 #xdOPT$)))
        (setq #kosu 1)
      )
;-- 2011/08/11 A.Satoh Add - E

;-- 2011/08/12 A.Satoh Mod - S
      ; 同一品番が無い又は同一品番はあるが分類区分が異なる場合は、リストに新規登録
      ; 同一品番があり、分類区分が同じであれば個数を加算して更新
      (if (= #Flr$$ nil)
        (progn
          (setq #Flr$  (list #sCode #iType #fLen (list #sHnd) #kosu #bunrui))
          (setq #Flr$$ (cons #Flr$ #Flr$$))
        )
        (progn
          (setq #idx 0)
          (setq #upd_flg nil)
          (repeat (length #Flr$$)
            (if (= #upd_flg nil)
              (progn
                (setq #wk_flr1$ (nth #idx #Flr$$))
                (if (and (= #sCode (nth 0 #wk_flr1$)) (= #bunrui (nth 5 #wk_flr1$)))
                  (progn
                    (setq #wk_flr$ #wk_flr1$)
                    (setq #upd_flg T)
                  )
                )
              )
            )
            (setq #idx (1+ #idx))
          )

          (if (= #upd_flg T)
            (progn
              (setq #fLen  (+ #fLen    (nth 2 #wk_flr$)))
              (setq #sHnd$ (cons #sHnd (nth 3 #wk_flr$)))
              (setq #kosu  (+ #kosu    (nth 4 #wk_flr$)))
              (setq #FlrN$ (list #sCode #iType #fLen #sHnd$ #kosu #bunrui))
              (setq #Flr$$ (subst #FlrN$ #wk_flr$ #Flr$$))
            )
            (progn
              (setq #Flr$  (list #sCode #iType #fLen (list #sHnd) #kosu #bunrui))
              (setq #Flr$$ (cons #Flr$ #Flr$$))
            )
          )
        )
      )
;|
      ; 同一品番がない場合、リストに新規登録
      ; 同一品番がある場合、長さと図形ハンドルを加算して更新
      (setq #Flr$ (assoc #sCode #Flr$$))
      (if (= nil #Flr$)
        (progn
;-- 2011/08/11 A.Satoh Mod - S
;          (setq #Flr$  (list #sCode #iType #fLen (list #sHnd)))
          (setq #Flr$  (list #sCode #iType #fLen (list #sHnd) #kosu #bunrui))
;-- 2011/08/11 A.Satoh Mod - E
          (setq #Flr$$ (cons #Flr$ #Flr$$))
        )
        (progn
          (setq #fLen  (+ #fLen    (nth 2 #Flr$)))
          (setq #sHnd$ (cons #sHnd (nth 3 #Flr$)))
;-- 2011/08/11 A.Satoh Mod - S
;          (setq #FlrN$ (list #sCode #iType #fLen #sHnd$))
          (setq #FlrN$ (list #sCode #iType #fLen #sHnd$ #kosu #bunrui))
;-- 2011/08/11 A.Satoh Mod - E
          (setq #Flr$$ (subst #FlrN$ #Flr$ #Flr$$))
        )
      )
|;
;-- 2011/08/12 A.Satoh Mod - E

      (setq #iCnt (1+ #iCnt))
    )
  )

  ; アイテムごとに個数計算
  (foreach #Flr$ #Flr$$
    (setq #sCode (nth 0 #Flr$))
    (setq #iType (nth 1 #Flr$))
;-- 2011/08/12 A.Satoh Del - S
;    (setq #fLen  (nth 2 #Flr$))
;-- 2011/08/12 A.Satoh Del - E
    (setq #sHnd$ (nth 3 #Flr$))
;-- 2011/08/11 A.Satoh Add - S
    (setq #kosu  (nth 4 #Flr$))
    (setq #bunrui (nth 5 #Flr$))
;-- 2011/08/11 A.Satoh Add - S

    ;// 品番基本テーブルからアイテム単品の長さを取得
    (setq #rec$ (CFGetDBSQLHinbanTableChk "品番図形" #sCode (list (list "品番名称" #sCode 'STR))))
;-- 2011/08/12 A.Satoh Mod - S
    (if #rec$
;-- 2011/12/09 A.Satoh Mod - S
;;;;;      (setq #out$$ (cons (list #sCode (nth 1 #rec$) #bunrui #sHnd$ #kosu #sKind) #out$$))
      (setq #out$$ (cons (list #sCode (nth 1 #rec$) #bunrui #sHnd$ #kosu #sKind "" 0 "") #out$$))
;-- 2011/12/09 A.Satoh Mod - S
    )
;|
    (if #rec$
      (if (= 7 #iType)
        (setq #fLen1 (nth 5 #rec$)) ; 壁処理用スペーサー
        (setq #fLen1 (nth 3 #rec$)) ; その他
      )
    )

    ; 天井フィラーの見積り枚数設定を追加
    (if (< 0 CG_FillerNum)
      (setq #fLen (* #fLen1 CG_FillerNum))
    )

    ; ２枚セットがあれば、品番基本テーブルからアイテム単品の長さを取得
    (setq #fLen2  0.0)
    (setq #fLen3  0.0)
    (setq #iCnt1 0)
    (setq #iCnt2 0)

    (if (< 0.0 #fLen2)
      (while (< 0.0 #fLen)
        (cond
          ((>= #fLen1 #fLen)
            (setq #iCnt1 (+ 1 #iCnt1))
            (setq #fLen  0.0)
          )
          ((>= #fLen2 #fLen)
            (setq #iCnt2 (+ 1 #iCnt2))
            (setq #fLen  0.0)
          )
          ((>= #fLen3 #fLen)
            (setq #iCnt1 (+ 2 #iCnt1))
            (setq #fLen  0.0)
          )
          (T
            (setq #iCnt2 (+ 1     #iCnt2))
            (setq #fLen  (- #fLen #fLen2))
          )
        )
      )
      (while (< 0.0 #fLen)
        (cond
          ((>= #fLen1 #fLen)
            (setq #iCnt1 (+ 1 #iCnt1))
            (setq #fLen 0.0)
          )
          (T
            (setq #iCnt1 (+ 1     #iCnt1))
            (setq #fLen  (- #fLen #fLen1))
          )
        )
      )
    )

    (setq #out$$ (cons (list #sCode (nth 1 #rec$) #bunrui #sHnd$ #iCnt1 #sKind) #out$$))
|;
;-- 2011/08/12 A.Satoh Mod - E
  ) ;foreach

  ;ConfPartsAll_GetDetailList に渡す形式（#out$$)
  ;例 ("H$030WFB-7%#-@@[J:BW]" "L" "A" ("4937") 1 "0")

  ;// 天井フィラーの詳細情報を取得
  (if #out$$
    (reverse (ConfPartsAll_GetDetailList #out$$))
  )

) ;ConfPartsAll_GetFillerInfo

;;;<HOM>************************************************************************
;;; <関数名>  : ConfPartsAll_GetHosokuInfo
;;; <処理概要>: 補足部材の仕様詳細情報を取得
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                  1.ソートキー
;;;                  2.品番名称
;;;                  3.図形ハンドル
;;;                  4.入力配置用品番名称
;;;                  5.出力名称コード
;;;                  6.仕様名称コード
;;;                  7.個数
;;;                  8.金額
;;;                  9.品コード
;;;                 10.部材種類フラグ
;;;                    (0:標準部材 1:特注WT 2:天井フィラー 3:補足部材)
;;;                 11.集約ID
;;;                 12.分類
;;;               )
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetHosokuInfo (
  /
  #lst$$ #lst$ #fname #spec$$ #spec$ #hinban #num #name #bunrui #fig$
#qry$ #syuyaku ;-- 2012/01/17 A.Satoh Add
  )

  (setq CG_FuncName "\nConfPartsAll_GetHosokuInfo")

  (setq #lst$$ nil)

  ; HOSOKU.cfgの読込
  (setq #fname (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
  (if (findfile #fname)
    (progn
      (setq #spec$$ (ReadCSVFile #fname))
      (if #spec$$
        (foreach #spec$ #spec$$
          (setq #hinban (nth 0 (StrParse (nth 0 #spec$) "=")))
          (setq #num (atoi (nth 1 (StrParse (nth 0 #spec$) "="))))
          (setq #name (nth 1 #spec$))
          (setq #bunrui (nth 2 #spec$))
          (if (> (strlen #bunrui) 1)
            (setq #bunrui (substr #bunrui 1 1))
          )

          ; 品番基本テーブルからｵﾌﾟｼｮﾝ品情報を取得
          (setq #fig$ (car (CFGetDBSQLHinbanTable "品番基本" #hinban (list (list "品番名称" #hinban 'STR)))))
          (if (/= #fig$ nil)
            (progn
;-- 2012/01/17 A.Satoh Add - S
							(if (and (= (nth 2 #spec$) "D") (= (substr (nth 5 #fig$) 1 1) "A"))
								(progn
									(setq #qry$
										(car (CFGetDBSQLHinbanTable "集約ID変換" #hinban
										(list (list "品番名称" #hinban 'STR))))
									)

									(if (/= #qry$ nil)
										(setq #syuyaku (nth 1 #qry$))
										(setq #syuyaku (nth 5 #fig$))
									)
								)
								(setq #syuyaku (nth 5 #fig$))
							)
;-- 2012/01/17 A.Satoh Add - E

              (setq #lst$
                (list
                  (fix (nth 2 #fig$))  ;  1.ソートキー
                  #hinban              ;  2.品番名称
                  (list "")            ;  3.図形ハンドル
                  "Z"                  ;  4.L/R
                  0                    ;  5.出力名称コード
                  0                    ;  6.仕様名称コード
                  #num                 ;  7.個数
                  0                    ;  8.金額(見積り処理で取得)
                  "xxxxxxx"            ;  9.品コード
                  "3"                  ; 10.部材種類フラグ
;-- 2012/01/17 A.Satoh Mod - S
;;;;;                  (nth 5 #fig$)        ; 11.集約ID
									#syuyaku             ; 11.集約ID
;-- 2012/01/17 A.Satoh Mod - E
                  #bunrui              ; 12.分類
;-- 2011/12/09 A.Satoh Add - S
									""
									0
;-- 2011/12/09 A.Satoh Add - E
                )
              )
              (setq #lst$$ (append #lst$$ (list #lst$)))
            )
          )
        )
      )
    )
  )

;  ; 補足部材の詳細情報を取得する
;  (if (/= #lst$$ nil)
;    (reverse (ConfPartsAll_GetDetailList #lst$$))
;    nil
;  )

);ConfPartsAll_GetHosokuInfo

;;;<HOM>************************************************************************
;;; <関数名>  : ConfPartsAll_GetOptionInfo
;;; <処理概要>: オプション部材の仕様詳細情報を取得
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                  1.ソートキー
;;;                  2.品番名称
;;;                  3.図形ハンドル
;;;                  4.入力配置用品番名称
;;;                  5.出力名称コード
;;;                  6.仕様名称コード
;;;                  7.個数
;;;                  8.金額
;;;                  9.品コード
;;;                 10.部材種類フラグ
;;;                    (0:標準部材 1:特注WT 2:天井フィラー 3:補足部材)
;;;                 11.集約ID
;;;                 12.分類
;;;               )
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetOptionInfo (
  /
  #ss #sslen #i #sym #xdLSYM$ #oya_hinban #LR_oya #hand #xd$ #xd2$
  #hin #num #fig$ #lst$$ #xdFILR$
#qry$ #syuyaku ;-- 2012/02/09 A.Satoh Add
  )

  (setq CG_FuncName "\nConfPartsAll_GetOptionInfo")

  ; G_OPTを持つ設備部材を検索
  (setq #ss (ssget "X" '((-3 ("G_OPT")))))
  (if (= nil #ss)
    (setq #sslen 0)
    (setq #sslen (sslength #ss))
  )

  (setq #i 0)
  (repeat #sslen
    (setq #sym (ssname #ss #i))
    (setq #xdFILR$ (CFGetXData #sym "G_FILR"))
    (if (= #xdFILR$ nil)  ; 2個以上の天井フィラーを対象外に
      (progn
        (setq #xdLSYM$ (CFGetXData #sym "G_LSYM"))

        ; 親図形品番
        (if #xdLSYM$
          (setq #oya_hinban (nth 5 #xdLSYM$))
          (setq #oya_hinban "")
        )

        ; L/R区分
        (if #xdLSYM$
          (setq #LR_oya (nth 6 #xdLSYM$))
          (setq #LR_oya "Z")
        )

        (setq #hand (cdr (assoc 5 (entget #sym))))
        (setq #xd$  (CFGetXData #sym "G_OPT"))

        (setq #xd2$ #xd$)
        (repeat (car #xd$)
          (setq #xd2$ (cdr #xd2$))
          (setq #hin  (car #xd2$))  ;品番
          (setq #xd2$ (cdr #xd2$))
          (setq #num  (car #xd2$))  ;個数

          ;// 品番基本テーブルからｵﾌﾟｼｮﾝ品情報を取得
          (setq #fig$ (car (CFGetDBSQLHinbanTable "品番基本" #hin (list (list "品番名称" #hin 'STR)))))
;-- 2012/02/09 A.Satoh Mod - S
					(if (/= #fig$ nil)
						(progn
							(if (and #xdLSYM$ (= (nth 15 #xdLSYM$) "D") (= (substr (nth 5 #fig$) 1 1) "A"))
								(progn
									(setq #qry$
										(car (CFGetDBSQLHinbanTable "集約ID変換" #hin
										(list (list "品番名称" #hin 'STR))))
									)

									(if (/= #qry$ nil)
										(setq #syuyaku (nth 1 #qry$))
										(setq #syuyaku (nth 5 #fig$))
									)
								)
								(setq #syuyaku (nth 5 #fig$))
							)

							(setq #lst$$
								(append #lst$$
									(list
										(list
											(fix (nth 2 #fig$))             ; 1.ソートキー
											(KP_DelHinbanKakko #hin)        ; 2.品番名称 ()外す
											(list "")                       ; 3.図形ハンドル
											(if (equal (nth 1 #fig$) 1 0.1) ; 4.L/R
												#LR_oya                       ;   親図形のLR
												"Z"                           ;   LRなし
											)
											0                               ; 5.出力名称コード
											0                               ; 6.仕様名称コード
											#num                            ; 7.個数
											0                               ; 8.金額(見積り処理で取得)
											"xxxxxxx"                       ; 9.品コード
											"3"                             ;10.部材種類フラグ
											#syuyaku                        ;11.集約ID
											(nth 15 #xdLSYM$)               ;12.分類
											""
											0
										)
									)
								)
							)
						)
					)
;;;;;          (if (= #fig$ nil)
;;;;;            nil
;;;;;            (setq #lst$$
;;;;;              (append #lst$$
;;;;;                (list
;;;;;                  (list
;;;;;                    (fix (nth 2 #fig$))             ; 1.ソートキー
;;;;;                    (KP_DelHinbanKakko #hin)        ; 2.品番名称 ()外す
;;;;;                    (list "")                       ; 3.図形ハンドル
;;;;;                    (if (equal (nth 1 #fig$) 1 0.1) ; 4.L/R
;;;;;                      #LR_oya                       ;   親図形のLR
;;;;;                      "Z"                           ;   LRなし
;;;;;                    )
;;;;;                    0                               ; 5.出力名称コード
;;;;;                    0                               ; 6.仕様名称コード
;;;;;                    #num                            ; 7.個数
;;;;;                    0                               ; 8.金額(見積り処理で取得)
;;;;;                    "xxxxxxx"                       ; 9.品コード
;;;;;                    "3"                             ;10.部材種類フラグ
;;;;;                    (nth 5 #fig$)                   ;11.集約ID
;;;;;                    (nth 15 #xdLSYM$)               ;12.分類
;;;;;;-- 2011/12/09 A.Satoh Add - S
;;;;;										""
;;;;;										0
;;;;;;-- 2011/12/09 A.Satoh Add - E
;;;;;                  )
;;;;;                )
;;;;;              )
;;;;;            )
;;;;;          )
;-- 2012/02/09 A.Satoh Mod - E
        )
      )
    )
    (setq #i (+ #i 1))
  )

  #lst$$

) ;ConfPartsAll_GetOptionInfo


(princ)

