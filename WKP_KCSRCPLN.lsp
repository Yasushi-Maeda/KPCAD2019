;|
aaaa
bbb
ccc
ｺﾒﾝﾄ
|;

;;;(SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$)))
;;;(W,D,H)=(20,450,2000)

;;; <関数検索用>
;;;(defun C:KP_AutoEXEC (      : プラン検索から図面出力まで行う(ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ)
;;;(defun C:KPLocalAutoEXEC (  : WEB版LOCAL CAD端末用自動実行
;;;(defun C:Web_AutoEXEC (     : プラン検索から図面出力まで行う.Web版CADｻｰﾊﾞｰ自動ﾚｲｱｳﾄ
;;;(defun WEBclear (           : 図面ｸﾘｱｰ(初期図面状態に戻す) ★未使用
;;;(defun NS_ChPlanInfo (      : PlanInfo.cfgを更新する(通常ﾓｰﾄﾞ)

;;;(defun C:SearchPlan キッチンプラン検索
;;;(defun PK_ClearGlobal ( / ) ｸﾞﾛｰﾊﾞﾙ変数のｸﾘｱｰ
;;;(defun PC_WriteSeriesInfo 現在のSERIES情報をファイルに書き出す
;;;(defun PC_SearchPlanNewDWG プラン検索用の新規図面を開く
;;;(defun C:PC_LayoutPlan プラン検索処理を実行
;;;(defun C:PC_InsertPlan プラン検索された図面を挿入する
;;;(defun PC_LayoutPlanExec プラン検索処理を実行
;;;(defun PK_StartLayout キッチンを自動ﾚｲｱｳﾄする
;;;(defun PD_StartLayout ダイニングを自動ﾚｲｱｳﾄする
;;;(defun CPrint_Time ( / #date_time) 刻み(nick)で数値の繰り上げ
;;;(defun PKG_SetFamilyCode   キッチン用入力情報をグローバルファミリー品番
;;;(defun PcPrintLog ( / )    グローバルをログにかき出し
;;;(defun SDG_SetFamilyCode ダイニング用入力情報をグローバルファミリー品番
;;;(defun SKG_GetOptionHinban オプション品の品番を取得する

;;;(defun PKC_ModelLayout        キッチン構成部材自動配置
;;;(defun PDC_ModelLayout        ダイニング構成部材自動配置
;;;(defun PKC_GetPlan            プラン構成情報取得
;;;(defun PDC_GetPln             プラン構成情報取得
;;;(defun PKC_MoveToSGCabinet    側面Ｌ、Ｒの図形のみを指定図形の側面に移動させる
;;;(defun PKC_MoveToSGCabinetSub 側面Ｌ、Ｒの図形のみを指定図形の側面に移動させる
;;;(defun PFGetCompBase          構成部材取得(構成タイプ=1) CG_UnitBase="1"

;;;(defun PKC_LayoutParts        プラン構成部材配置
;;;(defun PK_Stretch_SidePanel   ﾌﾟﾗﾝ検索収納部ｻｲﾄﾞﾊﾟﾈﾙ伸縮
;;;(defun PKC_LayoutOneParts     単独部材配置
;;;(defun PKC_InsertParts        部材を配置する
;;;(defun PKGetSQL_HUKU_KANRI    複合管理検索のSQLを求める


(setq ST_BLKSTART nil) ; <ｸﾞﾛｰﾊﾞﾙ定義>



  ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ; 全自動対応ｸﾞﾛｰﾊﾞﾙ変数 01/10/02 YM ADD-S

  ; 展開図種別選択ﾀﾞｲｱﾛｸﾞの戻り値 自動ﾓｰﾄﾞ 01/09/07 YM ADD
  (setq CG_AUTOMODE_TENKAI (list (list 1 1 1)(list "0")))

  ; ﾃﾝﾌﾟﾚｰﾄ選択ﾀﾞｲｱﾛｸﾞの戻り値 自動ﾓｰﾄﾞ 01/09/07 YM ADD
;;; (setq CG_AUTOMODE_TEMPLT_L (list (list (list "SK_A3_立" "") (list "SK_A3_L展" "")) "0" 1))
;;; (setq CG_AUTOMODE_TEMPLT_R (list (list (list "SK_A3_立" "") (list "SK_A3_R展" "")) "0" 1))

;04/04/13 YM ADD WEB DIPLOA対面　★★★★★
;;;(setq CG_AUTOMODE_TEMPLT_L_TAIMEN
;;; (list (list (list "SK_A3_対面立2" "") (list "SK_A3_対面AE仕" "") (list "SK_A3_対面B平D" "")) "0" 1))
;;;(setq CG_AUTOMODE_TEMPLT_R_TAIMEN
;;; (list (list (list "SK_A3_対面立2" "") (list "SK_A3_対面AE仕" "") (list "SK_A3_対面B平D" "")) "0" 1))

;;; (setq CG_AUTOMODE_TEMPLT_JPG (list (list (list "JPG立体" "")) "0" 1)) ; 03/02/22 YM ADD

  ; 寸法作成制御ﾀﾞｲｱﾛｸﾞの戻り値 自動ﾓｰﾄﾞ 01/09/07 YM ADD
;;; (setq CG_AUTOMODE_DIMMK_L (list (list "1" "1" "A" "Y") (list (list "SK_A3_立" "04") (list "SK_A3_L展" "04"))))
;;; (setq CG_AUTOMODE_DIMMK_R (list (list "1" "1" "A" "Y") (list (list "SK_A3_立" "04") (list "SK_A3_R展" "04"))))

;04/04/13 YM ADD WEB DIPLOA対面　★★★★★
;;;(setq CG_AUTOMODE_DIMMK_L_TAIMEN
;;; (list (list "1" "1" "A" "Y") (list (list "SK_A3_対面立2" "04") (list "SK_A3_対面AE仕" "04") (list "SK_A3_対面B平D" "04"))))
;;;(setq CG_AUTOMODE_DIMMK_R_TAIMEN
;;; (list (list "1" "1" "A" "Y") (list (list "SK_A3_対面立2" "04") (list "SK_A3_対面AE仕" "04") (list "SK_A3_対面B平D" "04"))))

;;; (setq CG_AUTOMODE_DIMMK_JPG (list (list "1" "1" "A" "Y") (list (list "JPG立体" "04")))) ; 03/02/22 YM ADD

  ; 簡易印刷ﾀﾞｲｱﾛｸﾞの戻り値 自動ﾓｰﾄﾞ 01/09/07 YM ADD
  (setq CG_AUTOMODE_PRINT1 (list "paperA3" "scale1")) ; 立体図
  (setq CG_AUTOMODE_PRINT2 (list "paperA3" "scale30")); 展開図
  (setq CG_AUTOMODE_PRINT3 (list "paperA3" "scale30")); 展開図 DIPLOA 3枚目 04/04/14 YM ADD
  (setq CG_AUTOMODE_PRINT4 (list "paperA3" "scale40")); 展開図

  ; 全自動対応ｸﾞﾛｰﾊﾞﾙ変数 01/10/02 YM ADD-E
  ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

(setq ST_BLKSTART nil) ; <ｸﾞﾛｰﾊﾞﾙ定義>


;;;<HOM>*************************************************************************
;;; <関数名>    : WebGetTemplate
;;; <処理概要>  : WEB版ﾃﾝﾌﾟﾚｰﾄ名を取得する
;;; <戻り値>    : なし
;;; <作成>      : 2008/08/04 YM ADD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun WebGetTemplate (
  &outid
  /
  #QRY$$ #TEMPLATE_NAME
#TEMPLATE_NAME$ #LR ;2009/01/17 YM ADD
  )

  (cond
    ((= CG_UnitCode "K")
      ;ｷｯﾁﾝ
      (setq #qry$$
        (CFGetDBSQLRec CG_CDBSESSION "図面レイアウト"
          (list
            (list "OUTID"    &outid              'STR);1:ﾊﾟｰｽ,2:商品図,4:施工図
            (list "形状"     (nth 5 CG_GLOBAL$)  'STR)
            (list "左右勝手" (nth 11 CG_GLOBAL$) 'STR)
          )
        )
      )
    )
    ((= CG_UnitCode "D")

      (cond
        ;((= CG_SeriesDB "SDA") ;2011/02/01 YM MOD【PG分岐】
        ((= BU_CODE_0003 "1")
          (setq #LR (nth 56 CG_GLOBAL$))
        )
        ;((= CG_SeriesDB "SDB") ;2011/02/01 YM MOD【PG分岐】
        ((= BU_CODE_0003 "2")

          (setq #LR (nth 60 CG_GLOBAL$));左右基準
          (cond
            ((= #LR "LL")
              (setq #LR "L")
            )
            ((= #LR "RR")
              (setq #LR "R")
            )
            (T
              (setq #LR "L")
            )
          );_cond

        )
        (T ;__OTHER

          (setq #LR (nth 60 CG_GLOBAL$));左右基準
          (cond
            ((= #LR "LL")
              (setq #LR "L")
            )
            ((= #LR "RR")
              (setq #LR "R")
            )
            (T
              (setq #LR "L")
            )
          );_cond

        )
      );_cond
        
     
      ;収納
      (setq #qry$$
        (CFGetDBSQLRec CG_CDBSESSION "図面レイアウト"
          (list
            (list "OUTID"    &outid    'STR);1:ﾊﾟｰｽ,2:商品図,4:施工図
            (list "形状"     "D"       'STR)
            (list "左右勝手" #LR       'STR)
          )
        )
      )

    )
  );_if

  ;2009/01/17 YM MOD 複数ありえる
;;;  (if (and #qry$$ (= 1 (length #qry$$)))
;;;   (progn
;;;     (setq #Template_name (nth 5 (car #qry$$)))
;;;   )
;;;   ;else
;;;   (progn
;;;     (princ "\n図面レイアウトがありません")
;;;   )
;;;  );_if

  ;2009/01/17 YM MOD 複数ありえる
  (setq #Template_name$ nil)
  (if #qry$$
    (progn
      (foreach #qry$ #qry$$
        (setq #Template_name (nth 5 #qry$))
        (setq #Template_name$ (append #Template_name$ (list #Template_name)))
      )
    )
    ;else
    (progn
      (princ "\n図面レイアウトがありません")
    )
  );_if

  #Template_name$
);WebGetTemplate

;;;<HOM>*************************************************************************
;;; <関数名>    : WebDefErrFunc
;;; <処理概要>  : WEB版ｴﾗｰ関数を定義する
;;; <戻り値>    : なし
;;; <作成>      : 02/09/11 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun WebDefErrFunc ( / )
  ; 02/09/03 YM MOD ｴﾗｰ関数の分岐使い分け ここで再定義しないといけない
  (cond
    ((= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* TempErr)
      );_if
    )
    ((= CG_AUTOMODE 1)
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError1)
      );_if
    )
    ((= CG_AUTOMODE 2)
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

  ;03/05/12 YM ADD-S
  (if (= 1 CG_DEBUG)(setq *error* nil))
  ;03/05/12 YM ADD-E
  (princ)
);WebDefErrFunc



(defun C:OK ( / )
  (C:Web_AutoEXEC)
)

;;;<HOM>*************************************************************************
;;; <関数名>    : C:Web_AutoEXEC
;;; <処理概要>  : プラン検索から図面出力まで行う.Web版CADｻｰﾊﾞｰ自動ﾚｲｱｳﾄ
;;; <戻り値>    : なし
;;; <作成>      : 02/07/29 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:Web_AutoEXEC (
  /
  #DATE_TIME #IFILEDIA #TEMPLATE_NAME #BLOCK$ #DWG$ #DXF$
  #TEMPLATE_NAME$ ;2009/0/1/17 YM ADD
  #NN #NN_DWG #NUMBER$
#BASE_FLG #ENSS$ #I #SKK$ #SS #UPPER_FLG ;2010/01/08 YM ADD
  )

  ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞを追加 03/04/23 YM ADD-S
  (cond
    ((= 1 CG_STOP)
      (princ "\n※※※ 強制終了 ※※※")
      (setq CG_STOP 2)
      (CFAlertMsg "\n--- ﾃﾞﾊﾞｯｸﾓｰﾄﾞ (C:OK) で再開---")
      (princ "\n★★★ OK で再開 ★★★")
      (quit) ;強制終了
    )
    ((= 2 CG_STOP) ; 再実行中
      (if (CFYesNoDialog "デバックモードで実行しますか？\n(「いいえ」ならｺﾏﾝﾄﾞﾗｲﾝ出力がないので早い)")
        (setq CG_DEBUG 1)
        (setq CG_DEBUG 0)
      );_if
    )
  )
  ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞを追加 03/04/23 YM ADD-E

  (setq CG_AUTOMODE 2) ;自動ﾓｰﾄﾞ
  (setq CG_ZUMEN_FLG nil);商品図か施工図を区別する

  ; 02/09/04 YM ADD ﾛｸﾞ出力追加
  (WebOutLog "//////////////////////////////////////////////////////////////////")
  (WebOutLog "自動ﾚｲｱｳﾄを開始します(C:Web_AutoEXEC)")
  ; 02/09/04 YM ADD ﾛｸﾞ出力加

  ; 02/09/03 YM ADD ｴﾗｰ関数定義
  ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞを追加 03/04/23 YM ADD-S
  (if (= 2 CG_STOP)
    (progn
      (setvar "CMDECHO" 1)
      (setq *error* nil) ; ﾃﾞﾊﾞｯｸﾓｰﾄﾞはｴﾗｰ関数を定義しない
    )
  ;else
    (progn
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError2)
      );_if
    )
  );_if

  (setq #iFILEDIA (getvar "FILEDIA"))
  (setvar "FILEDIA" 0)


  ; ﾌﾟﾗﾝ検索
  (WebOutLog "ﾌﾟﾗﾝ検索を開始(C:SearchPlan)")
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))
  (WebOutLog "****************************")
  (WebOutLog #date_time)
  (WebOutLog "****************************")

  (C:SearchPlan)        ;ﾌﾟﾗﾝ検索 開始
  (WebOutLog "ﾌﾟﾗﾝ検索が終了しました")            ; 02/09/04 YM ADD ﾛｸﾞ出力追加



  ;2008/08/26 YM ADD 一部不要な施工図画層の図形を削除する
  (ST_DelLayer)


  ;  *.datの追加部材情報を"Hosoku.cfg"に出力
;;; (DL_HosokuOut) ;2008/08/04 YM DEL


;;;(makeERR "C:SearchPlan後") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B
  ;WorkTop.cfgを書き出す 01/10/03 YM ADD-S
  (WebOutLog "WorkTop.cfg を書出します(PKOutputWT_Info)"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  (PKOutputWT_Info)

  ; Acaddocでしか行ってなったが物件名称,営業担当,プラン担当が未確定なので再度行う
  (setq CG_KENMEIINFO$ CG_INPUTINFO$)

  ; Head.cfgを書き出す
  (WebOutLog "Head.cfg を書出します(SKB_WriteHeadList)"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  (SKB_WriteHeadList)

  ; 保存
  (WebOutLog "保存,ﾊﾟｰｼﾞします"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  (command "_.QSAVE")
  ; ﾊﾟｰｼﾞ
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")


;ﾊﾟｰｽ図作図する==>"1"
;;; CG_PERS_OUT_FLG
;商品図作図する==>1
;;; CG_SYOHIN_OUT_FLG
;施工図作図する==>1
;;; CG_SEKOU_OUT_FLG


  ;ﾌﾞﾛｯｸ削除
  (setq #block$ (vl-directory-files (strcat CG_KENMEI_PATH "BLOCK\\") "*.dwg"))
  (if #block$
    (foreach #block #block$
      (if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" #block))
        (vl-file-delete (strcat CG_KENMEI_PATH "BLOCK\\" #block))
      );_if
    )
  );_if

  ;\output dwg削除 2008/08/16 YM ADD
  (setq #dwg$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT\\") "*.dwg"))
  (if #dwg$
    (foreach #dwg #dwg$
      (if (findfile (strcat CG_KENMEI_PATH "OUTPUT\\" #dwg))
        (vl-file-delete (strcat CG_KENMEI_PATH "OUTPUT\\" #dwg))
      );_if
    )
  );_if

  ;\output dxf削除 2008/08/16 YM ADD
  (setq #dxf$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT\\") "*.dxf"))
  (if #dxf$
    (foreach #dxf #dxf$
      (if (findfile (strcat CG_KENMEI_PATH "OUTPUT\\" #dxf))
        (vl-file-delete (strcat CG_KENMEI_PATH "OUTPUT\\" #dxf))
      );_if
    )
  );_if


  ;ARX対応版展開図作成で動作させるかどうか
;;; (if (= CG_UnitCode "K")
    (setq CG_KPDEPLOY_ARX_LOAD T)

    ;2010/01/08 YM ADD 収納吊戸のみのときは展開図作成前にﾀﾞﾐｰの下台を配置する
    (if (= CG_UnitCode "D");収納のとき
      (progn
        
        (setq #BASE_FLG nil) ;下台があれば T
        (setq #UPPER_FLG nil);上台があれば T

        (setq #enSS$ (ssget "X" '((-3 ("G_LSYM")))))
        (setq #i 0)
        (setq #ss (ssadd))
        (repeat (sslength #enSS$)
          (setq #skk$ (CFGetSymSKKCode (ssname #enSS$ #i) nil))
          (if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) CG_SKK_TWO_BAS))
            (setq #BASE_FLG T) ;下台があれば T
          );_if
          (if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) CG_SKK_TWO_UPP))
            (setq #UPPER_FLG T);上台があれば T
          );_if
          (setq #i (1+ #i))
        );repeat

        ;もし上台があって下台がなければ
        (if (and (= nil #BASE_FLG)(= T #UPPER_FLG))
          (setq CG_KPDEPLOY_ARX_LOAD nil)
        );_if
      )
    );_if

  
    ;2011/06/08 YM ADD-S 収納吊戸下OPEN BOXありのとき天井高さ-200mm
    (setq #dum_open_box (cadr (assoc "PLAN59" CG_INPUTINFO$)))
    (if (and (/= #dum_open_box nil)(/= #dum_open_box "N"))
      (progn
        (setq CG_CeilHeight (- CG_CeilHeight CG_WallUnderOpenBox))
        (princ "\nOPEN BOXなので200ﾏｲﾅｽ")
      )
    );_if
    ;2011/06/08 YM ADD-E


  ; 展開図作成
  (WebOutLog "展開図作成を行います")
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))
  (WebOutLog "*** 展開図作成開始 ***")
  (WebOutLog #date_time)
  (WebOutLog "*** 展開図作成開始 ***")

  (C:SCFMakeMaterial)

  (WebOutLog "展開図作成が終了しました")
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))
  (WebOutLog "*** 展開図作成終了 ***")
  (WebOutLog #date_time)
  (WebOutLog "*** 展開図作成終了 ***")


  ;2008/08/14 YM MOD 必ず展開図作成する
;;; (cond
;;;   ; ﾊﾟｰｽのみ作成
;;;   ((or (and (= "1" CG_PERS_PDF_FLG)(= "0" CG_SYOHIN_PDF_FLG)(= "0" CG_SEKOU_PDF_FLG)) ; 展開×,ﾊﾟｰｽ○
;;;        (and (= "1" CG_PERS_DWG_FLG)(= "0" CG_SYOHIN_DWG_FLG)(= "0" CG_SEKOU_DWG_FLG)))
;;;     (KP_MakePrs)
;;;   )
;;;   ; 商品図 or 施工図の、PDF or dwg作図が必要
;;;   ((or (= "1" CG_SYOHIN_PDF_FLG)(= "1" CG_SEKOU_PDF_FLG)
;;;        (= "1" CG_SYOHIN_DWG_FLG)(= "1" CG_SEKOU_DWG_FLG))
;;;     ;商品図,施工図のどれかを作図する
;;;
;;;     ; 展開図作成
;;;     (WebOutLog "展開図作成を行います")
;;;     (C:SCFMakeMaterial)
;;;     (WebOutLog "展開図作成が終了しました")
;;;   )
;;; );_cond


      ;ﾃﾝﾌﾟﾚｰﾄ名を求める
;;;     (WebGetTemplate "1");ﾊﾟｰｽ
;;;     (WebGetTemplate "2");商品図
;;;     (WebGetTemplate "4");施工図


  ; 既存PDFﾌｧｲﾙの削除
  (WebOutLog "既存PDFﾌｧｲﾙの削除を行います")
  (DeleteFiles)


;ﾌｧｲﾙ名の命名
;Z0000001_01_PERS.dwg(dxf) パース
;Z0000001_01_SYOHIN.dwg(dxf) 商品図
;Z0000001_01_SEKOU.dwg(dxf) 施工図

;Z0000001_01_01.pdf パース
;Z0000001_01_02.pdf 商品図
;Z0000001_01_03.pdf 施工図

;;;見積No.+追番

  ;2009/01/17 YM MOD
  (setq #number$ (list "01" "02" "03" "04" "05"))
  ;連番初期化
  (setq #NN 0)

  ;●パース図の出力 ================================================================================
  (if (or (= "1" CG_PERS_PDF_FLG)(= "1" CG_PERS_DWG_FLG)
          (/= "" PB_TEMPLATE_TYPE));2009/02/23 YM ADD 何か値が入っていたら
;PB_TEMPLATE_TYPE
    (progn

      ;2009/01/17 YM MOD-S 戻り値=ﾘｽﾄ
;;;     (setq #Template_name (WebGetTemplate "1"))
      (setq #Template_name$ (WebGetTemplate "1"))
      ;2009/01/17 YM MOD-E

      ;2009/01/19 YM MOD 連番を独立させる
      ;連番初期化
      (setq #NN_dwg 0)
      (foreach #Template_name #Template_name$ ;2009/01/17 YM

        ;寸法作成制御ﾀﾞｲｱﾛｸﾞの戻り値
        (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "04") )))
        ;ﾃﾝﾌﾟﾚｰﾄ選択ﾀﾞｲｱﾛｸﾞの戻り値
        (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))

        ; 図面ﾚｲｱｳﾄ & PDF出力
        (WebOutLog "図面ﾚｲｱｳﾄ & PDF出力を行います")
        (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
        (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_PERS_" (nth #NN_dwg #number$) ".dwg"))
        (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_PERS_" (nth #NN_dwg #number$) ".dxf"))

        (setq CG_ZUMEN_FLG nil)
        (C:SCFLayout)
        (WebOutLog "図面ﾚｲｱｳﾄ & PDF出力が終了しました")

        ;2009/01/19 YM MOD 連番を独立させる
        (setq #NN_dwg (1+ #NN_dwg))
        (setq #NN (1+ #NN))
      );foreach ;2009/01/17 YM
    )
  );_if

  ;●商品図の出力 ================================================================================
  (if (or (= "1" CG_SYOHIN_PDF_FLG)(= "1" CG_SYOHIN_DWG_FLG))
    (progn
      ;2009/01/17 YM MOD-S 戻り値=ﾘｽﾄ
;;;     (setq #Template_name (WebGetTemplate "2"))
      (setq #Template_name$ (WebGetTemplate "2"))
      ;2009/01/17 YM MOD-E

      ;2009/01/19 YM MOD 連番を独立させる
      ;連番初期化
      (setq #NN_dwg 0)
      (foreach #Template_name #Template_name$ ;2009/01/17 YM

        ;寸法作成制御ﾀﾞｲｱﾛｸﾞの戻り値
        (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "02") )))
        ;ﾃﾝﾌﾟﾚｰﾄ選択ﾀﾞｲｱﾛｸﾞの戻り値
        (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))

        ; 図面ﾚｲｱｳﾄ & PDF出力
        (WebOutLog "図面ﾚｲｱｳﾄ & PDF出力を行います")
        (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
        ;2008/09/05 YM ADD 施工図末尾に別紙(きめうちPDF図面)を付ける ＜収納のときは商品図に詳細図を添付する＞
        (setq CG_PDF_SYOUSAI  (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_99.pdf"))
        (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SYOHIN_" (nth #NN_dwg #number$) ".dwg"))
        (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SYOHIN_" (nth #NN_dwg #number$) ".dxf"))

        (setq CG_ZUMEN_FLG "02")
        (C:SCFLayout)
        (WebOutLog "図面ﾚｲｱｳﾄ & PDF出力が終了しました")

        ;2009/01/19 YM MOD 連番を独立させる
        (setq #NN_dwg (1+ #NN_dwg))
        (setq #NN (1+ #NN))
      );foreach ;2009/01/17 YM
    )
  );_if

  ;●施工図の出力 ================================================================================
  (if (or (= "1" CG_SEKOU_PDF_FLG)(= "1" CG_SEKOU_DWG_FLG))
    (progn
      ;2009/01/17 YM MOD-S 戻り値=ﾘｽﾄ
;;;     (setq #Template_name (WebGetTemplate "4"))
      (setq #Template_name$ (WebGetTemplate "4"))
      ;2009/01/17 YM MOD-E

      ;2009/01/19 YM MOD 連番を独立させる
      ;連番初期化
      (setq #NN_dwg 0)
      (foreach #Template_name #Template_name$ ;2009/01/17 YM

        ;寸法作成制御ﾀﾞｲｱﾛｸﾞの戻り値
        (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "04") )))
        ;ﾃﾝﾌﾟﾚｰﾄ選択ﾀﾞｲｱﾛｸﾞの戻り値
        (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))

        ; 図面ﾚｲｱｳﾄ & PDF出力→ﾃﾞｽｸﾄｯﾌﾟ
        (WebOutLog "図面ﾚｲｱｳﾄ & PDF出力を行います")
        (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
        ;2008/09/05 YM ADD 施工図末尾に別紙(きめうちPDF図面)を付ける
        (setq CG_PDF_SYOUSAI  (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_99.pdf"))
        (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SEKOU_" (nth #NN_dwg #number$) ".dwg"))
        (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SEKOU_" (nth #NN_dwg #number$) ".dxf"))

        (setq CG_ZUMEN_FLG "04")
        (C:SCFLayout)
        (WebOutLog "図面ﾚｲｱｳﾄ & PDF出力が終了しました")

        ;2009/01/19 YM MOD 連番を独立させる
        (setq #NN_dwg (1+ #NN_dwg))
        (setq #NN (1+ #NN))
      );foreach ;2009/01/17 YM
    )
  );_if

  ; CAD終了
  (setq CG_ZUMEN_FLG nil)
  (WebOutLog "☆☆☆ CADを終了します")    ; 02/09/04 YM ADD ﾛｸﾞ出力追加
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))
  (WebOutLog #date_time)

;;;(makeERR "終了前") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 終了前

  (setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD

  ;04/04/13 YM ADD ﾌﾟﾗﾝﾀｲﾌﾟｸﾞﾛｰﾊﾞﾙｸﾘｱｰDIPLOAの次に別ｼﾘｰｽﾞを実行すると対面ﾌﾟﾗﾝの値が残る
  (setq CG_Type1Code nil);ﾌﾟﾗﾝﾀｲﾌﾟ

  (setq *error* nil)
  (WebOutLog "@@@ quit直前 @@@")
  (WebOutLog "--- C:Web_AutoEXEC 終了！ ---")
  (WebOutLog "★★★　自動作図　終了　★★★")

  (if (= CG_DEBUG 1)
    nil ;デバックモードはCADを閉じない
    ;else
    (command "._quit" "Y");2008/08/11 YM MOD
;;; (command "._quit" "N");2008/08/11 YM MOD
  );_if

  (princ)
);C:Web_AutoEXEC


;;;<HOM>*************************************************************************
;;; <関数名>    : C:AGAIN
;;; <処理概要>  : CADｻｰﾊﾞｰ自動作図で展開図作成以降だけをもう一度実行する
;;; <戻り値>    : 
;;; <作成>      : 
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun C:AGAIN (
  /
  #DATE_TIME #IFILEDIA #TEMPLATE_NAME #BLOCK$ #DWG$ #DXF$
  #TEMPLATE_NAME$ ;2009/0/1/17 YM ADD
  #NN #NN_DWG #NUMBER$
#BASE_FLG #ENSS$ #I #SKK$ #SS #UPPER_FLG ;2010/01/08 YM ADD
  )

  (setq CG_DEBUG 1)

  (setq CG_AUTOMODE 2) ;自動ﾓｰﾄﾞ
  (setq CG_ZUMEN_FLG nil);商品図か施工図を区別する

  (setvar "CMDECHO" 1)
  (setq *error* nil) ; ﾃﾞﾊﾞｯｸﾓｰﾄﾞはｴﾗｰ関数を定義しない
  (setq #iFILEDIA (getvar "FILEDIA"))
  (setvar "FILEDIA" 0)

;;; ; ﾌﾟﾗﾝ検索
;;; ;ﾌﾞﾛｯｸ削除
;;; (setq #block$ (vl-directory-files (strcat CG_KENMEI_PATH "BLOCK\\") "*.dwg"))
;;; (if #block$
;;;   (foreach #block #block$
;;;     (if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" #block))
;;;       (vl-file-delete (strcat CG_KENMEI_PATH "BLOCK\\" #block))
;;;     );_if
;;;   )
;;; );_if
;;;
;;; ;\output dwg削除 2008/08/16 YM ADD
;;; (setq #dwg$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT\\") "*.dwg"))
;;; (if #dwg$
;;;   (foreach #dwg #dwg$
;;;     (if (findfile (strcat CG_KENMEI_PATH "OUTPUT\\" #dwg))
;;;       (vl-file-delete (strcat CG_KENMEI_PATH "OUTPUT\\" #dwg))
;;;     );_if
;;;   )
;;; );_if
;;;
;;; ;\output dxf削除 2008/08/16 YM ADD
;;; (setq #dxf$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT\\") "*.dxf"))
;;; (if #dxf$
;;;   (foreach #dxf #dxf$
;;;     (if (findfile (strcat CG_KENMEI_PATH "OUTPUT\\" #dxf))
;;;       (vl-file-delete (strcat CG_KENMEI_PATH "OUTPUT\\" #dxf))
;;;     );_if
;;;   )
;;; );_if
;;;

  ;ARX対応版展開図作成で動作させるかどうか
    (setq CG_KPDEPLOY_ARX_LOAD T)

;;;   ;2010/01/08 YM ADD 収納吊戸のみのときは展開図作成前にﾀﾞﾐｰの下台を配置する
;;;   (if (= CG_UnitCode "D");収納のとき
;;;     (progn
;;;       
;;;       (setq #BASE_FLG nil) ;下台があれば T
;;;       (setq #UPPER_FLG nil);上台があれば T
;;;
;;;       (setq #enSS$ (ssget "X" '((-3 ("G_LSYM")))))
;;;       (setq #i 0)
;;;       (setq #ss (ssadd))
;;;       (repeat (sslength #enSS$)
;;;         (setq #skk$ (CFGetSymSKKCode (ssname #enSS$ #i) nil))
;;;         (if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) CG_SKK_TWO_BAS))
;;;           (setq #BASE_FLG T) ;下台があれば T
;;;         );_if
;;;         (if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) CG_SKK_TWO_UPP))
;;;           (setq #UPPER_FLG T);上台があれば T
;;;         );_if
;;;         (setq #i (1+ #i))
;;;       );repeat
;;;
;;;       ;もし上台があって下台がなければ
;;;       (if (and (= nil #BASE_FLG)(= T #UPPER_FLG))
;;;         (setq CG_KPDEPLOY_ARX_LOAD nil)
;;;       );_if
;;;     )
;;;   );_if

  

  ; 展開図作成
;;; (C:SCFMakeMaterial)

  ; 既存PDFﾌｧｲﾙの削除
  (WebOutLog "既存PDFﾌｧｲﾙの削除を行います")
  (DeleteFiles)

  (setq #number$ (list "01" "02" "03" "04" "05"))
  ;連番初期化
  (setq #NN 0)

;;; ;●パース図の出力 ================================================================================
;;; (if (or (= "1" CG_PERS_PDF_FLG)(= "1" CG_PERS_DWG_FLG)
;;;         (/= "" PB_TEMPLATE_TYPE));2009/02/23 YM ADD 何か値が入っていたら
;;;
;;;   (progn
;;;     (setq #Template_name$ (WebGetTemplate "1"))
;;;     ;2009/01/17 YM MOD-E
;;;
;;;     ;2009/01/19 YM MOD 連番を独立させる
;;;     ;連番初期化
;;;     (setq #NN_dwg 0)
;;;     (foreach #Template_name #Template_name$ ;2009/01/17 YM
;;;
;;;       ;寸法作成制御ﾀﾞｲｱﾛｸﾞの戻り値
;;;       (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "04") )))
;;;       ;ﾃﾝﾌﾟﾚｰﾄ選択ﾀﾞｲｱﾛｸﾞの戻り値
;;;       (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))
;;;
;;;       ; 図面ﾚｲｱｳﾄ & PDF出力
;;;       (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
;;;       (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_PERS_" (nth #NN_dwg #number$) ".dwg"))
;;;       (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_PERS_" (nth #NN_dwg #number$) ".dxf"))
;;;
;;;       (setq CG_ZUMEN_FLG nil)
;;;       (C:SCFLayout)
;;;
;;;       (setq #NN_dwg (1+ #NN_dwg))
;;;       (setq #NN (1+ #NN))
;;;     );foreach ;2009/01/17 YM
;;;   )
;;; );_if
;;;
;;; ;●商品図の出力 ================================================================================
;;; (if (or (= "1" CG_SYOHIN_PDF_FLG)(= "1" CG_SYOHIN_DWG_FLG))
;;;   (progn
;;;     ;2009/01/17 YM MOD-S 戻り値=ﾘｽﾄ
;;;;;;      (setq #Template_name (WebGetTemplate "2"))
;;;     (setq #Template_name$ (WebGetTemplate "2"))
;;;     ;2009/01/17 YM MOD-E
;;;
;;;     ;2009/01/19 YM MOD 連番を独立させる
;;;     ;連番初期化
;;;     (setq #NN_dwg 0)
;;;     (foreach #Template_name #Template_name$ ;2009/01/17 YM
;;;
;;;       ;寸法作成制御ﾀﾞｲｱﾛｸﾞの戻り値
;;;       (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "02") )))
;;;       ;ﾃﾝﾌﾟﾚｰﾄ選択ﾀﾞｲｱﾛｸﾞの戻り値
;;;       (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))
;;;
;;;       ; 図面ﾚｲｱｳﾄ & PDF出力
;;;       (WebOutLog "図面ﾚｲｱｳﾄ & PDF出力を行います")
;;;       (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
;;;       ;2008/09/05 YM ADD 施工図末尾に別紙(きめうちPDF図面)を付ける ＜収納のときは商品図に詳細図を添付する＞
;;;       (setq CG_PDF_SYOUSAI  (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_99.pdf"))
;;;       (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SYOHIN_" (nth #NN_dwg #number$) ".dwg"))
;;;       (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SYOHIN_" (nth #NN_dwg #number$) ".dxf"))
;;;
;;;       (setq CG_ZUMEN_FLG "02")
;;;       (C:SCFLayout)
;;;
;;;       (setq #NN_dwg (1+ #NN_dwg))
;;;       (setq #NN (1+ #NN))
;;;     );foreach ;2009/01/17 YM
;;;   )
;;; );_if

  ;●施工図の出力 ================================================================================
  (if (or (= "1" CG_SEKOU_PDF_FLG)(= "1" CG_SEKOU_DWG_FLG))
    (progn
      (setq #Template_name$ (WebGetTemplate "4"))

      (setq #NN_dwg 0)
      (foreach #Template_name #Template_name$ ;2009/01/17 YM

        ;寸法作成制御ﾀﾞｲｱﾛｸﾞの戻り値
        (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "04") )))
        ;ﾃﾝﾌﾟﾚｰﾄ選択ﾀﾞｲｱﾛｸﾞの戻り値
        (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))

        ; 図面ﾚｲｱｳﾄ & PDF出力→ﾃﾞｽｸﾄｯﾌﾟ
        (WebOutLog "図面ﾚｲｱｳﾄ & PDF出力を行います")
        (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
        ;2008/09/05 YM ADD 施工図末尾に別紙(きめうちPDF図面)を付ける
        (setq CG_PDF_SYOUSAI  (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_99.pdf"))
        (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SEKOU_" (nth #NN_dwg #number$) ".dwg"))
        (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SEKOU_" (nth #NN_dwg #number$) ".dxf"))

        (setq CG_ZUMEN_FLG "04")
        (C:SCFLayout)
        (WebOutLog "図面ﾚｲｱｳﾄ & PDF出力が終了しました")

        ;2009/01/19 YM MOD 連番を独立させる
        (setq #NN_dwg (1+ #NN_dwg))
        (setq #NN (1+ #NN))
      );foreach ;2009/01/17 YM
    )
  );_if

  ; CAD終了
  (setq CG_ZUMEN_FLG nil)

  (setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD

  (setq CG_Type1Code nil);ﾌﾟﾗﾝﾀｲﾌﾟ

  (setq *error* nil)

  (if (= CG_DEBUG 1)
    nil ;デバックモードはCADを閉じない
    ;else
    (command "._quit" "Y");2008/08/11 YM MOD
  );_if

  (princ)
);C:AGAIN

;;;<HOM>*************************************************************************
;;; <関数名>    : ST_DelLayer
;;; <処理概要>  : 一部不要な施工図画層の図形を削除する
;;; <戻り値>    : なし
;;; <引数>      : 画層のﾘｽﾄ(ﾜｲﾙﾄﾞｶｰﾄﾞOK)
;;; <作成>      : 2008/08/26 YM ADD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun ST_DelLayer (
  /
  #EN #I #LAYER #LAYER$ #NUM #REC$$ #SS #VALUE #RET$
  )
  (setq #layer$ nil)
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "ST施工表示")))
  (foreach #rec$ #rec$$
    (setq #layer     (nth 0 #rec$))
    (setq #num (atoi (nth 1 #rec$)))
    (setq #value     (nth 2 #rec$))
    (if (wcmatch (nth #num CG_GLOBAL$) #value) ;変換値が条件と一致すると、画層が削除対象になる
      (progn
        ;","区切り考慮
        (setq #ret$ (StrParse #layer ","));画層のﾘｽﾄ
        (setq #layer$ (append #layer$ #ret$))
      )
    );_if
  )

  ;特定の画層の図形を削除
  (foreach #layer #layer$
    (setq #ss (ssget "X" (list (cons 8 #layer))))
    (if (and #ss (/= 0 (sslength #ss)))
      (progn
        (setq #i 0)
        (repeat (sslength #ss)
          (setq #en (ssname #ss #i))
          (if (entget #en)
            (entdel #en)
          );_if
          (setq #i (1+ #i))
        );repeat
      )
    );_if
  );foreach
  
  (princ)
);ST_DelLayer


;;;<HOM>*************************************************************************
;;; <関数名>    : DeleteFiles
;;; <処理概要>  : 既存のPDF,DWG,DXFﾌｧｲﾙを削除する
;;; <戻り値>    : なし
;;; <作成>      : 2008/08/07 YM ADD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun DXF_OUT (  /  )
  ;dxf出力
  (command "_saveas" "dxf" "V" "R12" "16" CG_DXF_FILENAME)
  (princ)
)

;;;<HOM>*************************************************************************
;;; <関数名>    : DeleteFiles
;;; <処理概要>  : 既存のPDF,DWG,DXFﾌｧｲﾙを削除する
;;; <戻り値>    : なし
;;; <作成>      : 2008/08/07 YM ADD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun DeleteFiles (
  /
  #DWG$ #DXF$ #PDF$
  )
  (setq #PDF$ (vl-directory-files CG_PDFOUTPUTPATH "*.pdf"))
  (if #PDF$
    (foreach #PDF #PDF$
      (if (findfile (strcat CG_PDFOUTPUTPATH #PDF))
        (vl-file-delete (strcat CG_PDFOUTPUTPATH #PDF))
      );_if
    )
  );_if
      
  (setq #DWG$ (vl-directory-files CG_DWGOUTPUTPATH "*.dwg"))
  (if #DWG$
    (foreach #DWG #DWG$
      (if (findfile (strcat CG_DWGOUTPUTPATH #DWG))
        (vl-file-delete (strcat CG_DWGOUTPUTPATH #DWG))
      );_if
    )
  );_if

  (setq #DXF$ (vl-directory-files CG_DXFOUTPUTPATH "*.dxf"))
  (if #DXF$
    (foreach #DXF #DXF$
      (if (findfile (strcat CG_DXFOUTPUTPATH #DXF))
        (vl-file-delete (strcat CG_DXFOUTPUTPATH #DXF))
      );_if
    )
  );_if

  (setq #DWG$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT\\") "*.dwg"))
  (if #DWG$
    (foreach #DWG #DWG$
      (if (findfile (strcat CG_KENMEI_PATH "OUTPUT\\" #DWG))
        (vl-file-delete (strcat CG_KENMEI_PATH "OUTPUT\\" #DWG))
      );_if
    )
  );_if



  (princ)
);DeleteFiles

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KP_AutoEXEC
;;; <処理概要>  : プラン検索から図面出力まで行う(ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ)
;;; <戻り値>    : なし
;;; <作成>      : 01/09/07 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KP_AutoEXEC (
  /
  #XRec$ #fp #msg
  #iFILEDIA #TAIMEN
  )
  (setq CG_AUTOMODE 1)  ;自動ﾓｰﾄﾞ
;;; (setq CG_ZumenPRINT 1)
;;; (setq CG_MitumoriPRINT 1)

  ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞを追加 03/04/28 YM ADD-S
  (cond
    ((= 1 CG_STOP)
      (princ "\n※※※　強制終了(ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ)　※※※")
      (setq CG_STOP 2)
      (CFAlertMsg "\n--- ﾃﾞﾊﾞｯｸﾓｰﾄﾞ (C:KP_AutoEXEC) で再開---")
      (princ "\n--- ﾃﾞﾊﾞｯｸﾓｰﾄﾞ (C:KP_AutoEXEC) で再開---")
      (quit) ;強制終了
    )
    ((= 2 CG_STOP) ; 再実行中
      (setq CG_DEBUG 1)
    )
  )
  ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞを追加 03/04/28 YM ADD-E


  ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞを追加 03/04/28 YM ADD-S
  (if (= 2 CG_STOP)
    (progn
      (setvar "CMDECHO" 1)
      (setq *error* nil) ; ﾃﾞﾊﾞｯｸﾓｰﾄﾞはｴﾗｰ関数を定義しない
    )
  ;else
    (progn
      ; 02/09/03 YM ADD ｴﾗｰ関数定義
      (setq *error* SKAutoError1)
    )
  );_if

  (setq #iFILEDIA (getvar "FILEDIA")) ; 01/11/22 HN ADD
  (setvar "FILEDIA" 0)

  ; ﾌﾟﾗﾝ検索
  (C:SearchPlan)        ;ﾌﾟﾗﾝ検索 開始

  ; 01/10/04 YM ADD-S Kenmei.cfg を読み込んでｸﾞﾛｰﾊﾞﾙｾｯﾄ
  ; Acaddocでしか行ってなったが物件名称,営業担当,プラン担当が未確定なので再度行う
  (setq CG_KENMEIINFO$ (ReadIniFile (strcat CG_SYSPATH "KENMEI.CFG")))
  ; 01/10/04 YM ADD-S

  ; 01/10/18 YM ADD Head.cfgを書き出す
  (SKB_WriteHeadList)

  ; 保存
  (command "_.QSAVE")
  ; ﾊﾟｰｼﾞ
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")

  (if (CFYesNoDialog "製品の入替･追加を行いますか？")
    (progn
      (setq CG_AUTOMODE 0) ;自動ﾓｰﾄﾞ終了
      ; 01/10/18 YM ADD-S PlanIno.cfg 更新(通常ﾓｰﾄﾞ)
      (NS_ChPlanInfo)
      ; 01/10/18 YM ADD-E PlanIno.cfg 更新(通常ﾓｰﾄﾞ)
      (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 1") 0) ; ﾌﾘｰﾌﾟﾗﾝ設計ﾀﾞｲｱﾛｸﾞ表示
    )
    (progn ; 処理継続
;;;     (C:ChgMenuPlot)       ; 出力ﾒﾆｭｰ

      ; 展開図作成
      (C:SCFMakeMaterial)

      ; //////////////////// ★★★プレゼン用★★★////////////////////
      (setq CG_AUTOMODE 5) ; JPG出力ﾓｰﾄﾞ
      ; JPG用ﾊﾟｰｽ図面ﾚｲｱｳﾄする(専用ﾃﾝﾌﾟﾚｰﾄあり) 03/02/22 YM MOD-S
      (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_JPG)
      (C:SCFLayout) ; JPG出力用ﾊﾟｰｽ図面作成  作成後すぐJPG出力(WebTIFF_OUTPUT)
      ; JPG用ﾊﾟｰｽ図面ﾚｲｱｳﾄする(専用ﾃﾝﾌﾟﾚｰﾄあり)
      ; //////////////////// ★★★プレゼン用★★★////////////////////
      (setq CG_AUTOMODE 1);元に戻す



      ;04/10/05 YM MOD 対面ﾌﾟﾗﾝのﾌﾟﾗﾝﾀｲﾌﾟ記号取得と判定にｼﾘｰｽﾞ記号を追加

      (setq #TAIMEN (CFgetini (strcat "TAIMEN-" CG_SeriesCode) "0001" (strcat CG_SKPATH "ERRMSG.INI")))
      ;2011/05/21 YM MOD
;;;     (if (or (= "IPA" (nth  5 CG_GLOBAL$))(= "G*" (nth  5 CG_GLOBAL$))) ;対面ﾌﾟﾗﾝかどうか
      (if (or (wcmatch (nth  5 CG_GLOBAL$) "IP*" )(wcmatch (nth  5 CG_GLOBAL$) "G*" )) ;対面ﾌﾟﾗﾝかどうか
        (progn ;対面ﾌﾟﾗﾝ
          (if (= (nth 11 CG_GLOBAL$) "R")

;;;(("1" "1" "A" "Y") (("SK_A3_対面立2" "04") ("SK_A3_対面AE仕" "04") ("SK_A3_対面B平D" "04")))

            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_R_TAIMEN)
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_L_TAIMEN)
          );_if
        )
        (progn
          ;従来(対面以外)
          (if (= (nth 11 CG_GLOBAL$) "R")

;;;(("1" "1" "A" "Y") (("SK_A3_立" "04") ("SK_A3_R展" "04")))

            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_R)
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_L)
          );_if
        )
      );_if

      (setq CG_Zumen_Count 0);枚数ｶｳﾝﾀｰ

      (C:SCFLayout)         ; 図面ﾚｲｱｳﾄ

      (PKOutputWT_Info)

      ; 見積り
      (C:arxStartApp (strcat CG_SysPATH "MITUMORI.EXE /Child") 1)
      (command "._quit" "N")
    )
  );_if

  (setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD
  (setq CG_AUTOMODE 0) ;自動ﾓｰﾄﾞ
  (setq CG_ZumenPRINT 0)
  (setq CG_MitumoriPRINT 0)

  (setq CG_Zumen_Count nil);枚数ｶｳﾝﾀｰ
  (setq CG_Type1Code nil);ﾌﾟﾗﾝﾀｲﾌﾟ

  (setq *error* nil)
  (princ)
);C:KP_AutoEXEC

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KPLocalAutoEXEC
;;; <処理概要>  : WEB版LOCAL CAD端末用自動実行
;;; <戻り値>    : なし
;;; <作成>      : 02/08/05 YM
;;; <備考>      : Input.cfgを読んでﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ実行
;;;*************************************************************************>MOH<
(defun C:KPLocalAutoEXEC (
  /
  #XRec$ #fp #msg
  #iFILEDIA #TAIMEN
  )
  (setq CG_AUTOMODE 3)  ;自動ﾓｰﾄﾞ

  ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞを追加 03/04/28 YM ADD-S
  (cond
    ((= 1 CG_STOP)
      (princ "\n※※※　強制終了(DL参照)　※※※")
      (setq CG_STOP 2)
      (CFAlertMsg "\n--- ﾃﾞﾊﾞｯｸﾓｰﾄﾞ (C:KPLocalAutoEXEC) で再開---")
      (princ "\n--- ﾃﾞﾊﾞｯｸﾓｰﾄﾞ (C:KPLocalAutoEXEC) で再開---")
      (quit) ;強制終了
    )
    ((= 2 CG_STOP) ; 再実行中
      (setq CG_DEBUG 1)
    )
  )
  ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞを追加 03/04/28 YM ADD-E


  ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞを追加 03/04/28 YM ADD-S
  (if (= 2 CG_STOP)
    (progn
      (setvar "CMDECHO" 1)
      (setq *error* nil) ; ﾃﾞﾊﾞｯｸﾓｰﾄﾞはｴﾗｰ関数を定義しない
    )
  ;else
    (progn
      ; 02/09/03 YM ADD ｴﾗｰ関数定義
      (setq *error* SKAutoError1)
    )
  );_if

  (setq #iFILEDIA (getvar "FILEDIA")) ; 01/11/22 HN ADD
  (setvar "FILEDIA" 0)

  ; ﾌﾟﾗﾝ検索
  (C:SearchPlan)        ;ﾌﾟﾗﾝ検索 開始

  ; 03/04/28 YM ADD-S *.datの追加部材情報を"Hosoku.cfg"に出力
  (DL_HosokuOut)
  ; 03/04/28 YM ADD-E

  ; 01/10/04 YM ADD-S Kenmei.cfg を読み込んでｸﾞﾛｰﾊﾞﾙｾｯﾄ
  ; Acaddocでしか行ってなったが物件名称,営業担当,プラン担当が未確定なので再度行う
  (setq CG_KENMEIINFO$ (ReadIniFile (strcat CG_SYSPATH "KENMEI.CFG")))
  ; 01/10/04 YM ADD-S

  ; 01/10/18 YM ADD Head.cfgを書き出す
  (SKB_WriteHeadList)

  ; 保存
  (command "_.QSAVE")
  ; ﾊﾟｰｼﾞ
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")

  (if (CFYesNoDialog "製品の入替･追加を行いますか？")
    (progn
      (setq CG_AUTOMODE 0) ;自動ﾓｰﾄﾞ終了
      ; 01/10/18 YM ADD-S PlanIno.cfg 更新(通常ﾓｰﾄﾞ)
      (NS_ChPlanInfo)
      ; 01/10/18 YM ADD-E PlanIno.cfg 更新(通常ﾓｰﾄﾞ)
      (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 1") 0) ; ﾌﾘｰﾌﾟﾗﾝ設計ﾀﾞｲｱﾛｸﾞ表示
    )
    (progn ; 処理継続
;;;     (C:ChgMenuPlot)       ; 出力ﾒﾆｭｰ

      ; 展開図作成
      (C:SCFMakeMaterial)

;;;04/04/13YM@DEL     ; 図面ﾚｲｱｳﾄ
;;;04/04/13YM@DEL     (if (= (nth 11 CG_GLOBAL$) "R")
;;;04/04/13YM@DEL       (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_R)
;;;04/04/13YM@DEL       (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_L)
;;;04/04/13YM@DEL     );_if

      ;04/04/13 YM ADD 対面ﾌﾟﾗﾝのﾌﾟﾗﾝﾀｲﾌﾟ記号取得と判定
      ;04/10/05 YM MOD 対面ﾌﾟﾗﾝのﾌﾟﾗﾝﾀｲﾌﾟ記号取得と判定にｼﾘｰｽﾞ記号を追加
      (setq #TAIMEN (CFgetini (strcat "TAIMEN-" CG_SeriesCode) "0001" (strcat CG_SKPATH "ERRMSG.INI")))
      (if (or (wcmatch CG_Type1Code #TAIMEN));対面ﾌﾟﾗﾝかどうか
        (progn;04/04/13 YM ADD 対面ﾌﾟﾗﾝのﾌﾟﾗﾝﾀｲﾌﾟ記号取得と判定
          (if (= (nth 11 CG_GLOBAL$) "R")
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_R_TAIMEN)
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_L_TAIMEN)
          );_if
        )
        (progn
          ;従来(対面以外)
          (if (= (nth 11 CG_GLOBAL$) "R")
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_R)
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_L)
          );_if
        )
      );_if


      ;04/04/14 YM ADD
      (setq CG_Zumen_Count 0);枚数ｶｳﾝﾀｰ

      (C:SCFLayout)         ; 図面ﾚｲｱｳﾄ


      ;WorkTop.cfgを書き出す 01/10/03 YM ADD-S
      (PKOutputWT_Info)
      ;WorkTop.cfgを書き出す 01/10/03 YM ADD-E

      ; 見積り
      (C:arxStartApp (strcat CG_SysPATH "MITUMORI.EXE /Child") 1)
      (command "._quit" "N")
    )
  );_if
  ; 01/09/21 YM ADD-E

  (setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD
  (setq CG_AUTOMODE 0) ;自動ﾓｰﾄﾞ
  (setq CG_ZumenPRINT 0)
  (setq CG_MitumoriPRINT 0)

  ;04/04/13 YM ADD ﾌﾟﾗﾝﾀｲﾌﾟｸﾞﾛｰﾊﾞﾙｸﾘｱｰDIPLOAの次に別ｼﾘｰｽﾞを実行すると対面ﾌﾟﾗﾝの値が残る
  (setq CG_Type1Code nil);ﾌﾟﾗﾝﾀｲﾌﾟ

  (setq *error* nil)
  (princ)
);C:KPLocalAutoEXEC

;;;<HOM>*************************************************************************
;;; <関数名>    : DL_HosokuOut
;;; <処理概要>  : *.datの追加部材情報を"Hosoku.cfg"に出力
;;; <戻り値>    : なし
;;; <作成>      : 03/04/28 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun DL_HosokuOut (
  /
  #FLG #FP #HINBAN #INFO #SFNAME #WRITE$$
  )
  ;"HOSOKU.cfg"に出力する
  (setq #sFname (strcat CG_KENMEI_PATH "HOSOKU.cfg"))
  ;03/05/27 YM ADD 既存の場合削除する
  (if (findfile #sFname)(vl-file-delete #sFname))

  ;[HOSOKU.cfg]以降の行を取得する CG_INPUTINFO$
  ;(("KENMEICD" "X0S03040022")("BUKKENNAME" "１１ 御中")...
  ; ("[HOSOKU.cfg]") ("DP0405" "1,ｵｰﾌﾞﾝ用ﾌｨﾗｰ")...)
  (setq #write$$ nil #flg nil) ; HOSOKU情報,情報ﾌﾗｸﾞ
  (foreach #elm$ CG_INPUTINFO$
    (if #flg ; HOSOKU情報
      (setq #write$$ (append #write$$ (list #elm$)))
    );_if
    (if (= "[HOSOKU.CFG]" (strcase (car #elm$))) ; 大文字にしてから比較
      (setq #flg T)
    );_if
  )

  (setq #fp  (open #sFname "a")) ; 追加記入ﾓｰﾄﾞ
  (if (/= nil #fp)
    (progn
      (foreach #elm$ #write$$ ; 追加部材情報
        (setq #hinban (car  #elm$))
        (setq #info   (cadr #elm$))
        (if (and #hinban #info (/= "" #hinban))
          (princ (strcat #hinban "=" #info) #fp)
        );_if
        (princ "\n" #fp)
      )
      (close #fp)
    )
    (progn
      ;03/05/27 YM DEL
;;;     (CFAlertMsg "HOSOKU.cfgへの書き込みに失敗しました。")
      (*error*)
    )
  );_if
  (princ)
);DL_HosokuOut


;;;<HOM>*************************************************************************
;;; <関数名>    : WEBclear
;;; <処理概要>  : 図面ｸﾘｱｰ(初期図面状態に戻す)
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 02/07/29 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun WEBclear (
  /
  #I #SSALL #SSROOM
  )
  (setvar "CLAYER" "0") ; 現在画層"0"
  (C:ALP);全画層表示
  (setq #ssROOM (ssget "X" '((-3 ("G_ROOM"))))) ; 残したい
  (setq #ssALL (ssget "X")) ; 全図形
  (setq #i 0)
  (repeat (sslength #ssROOM)
    (ssdel (ssname #ssROOM #i) #ssALL)
    (setq #i (1+ #i))
  )
  (command "_.erase" #ssALL "") ; 図形削除
  ; ﾌﾞﾛｯｸﾊﾟｰｼﾞ
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  ; 画層ﾊﾟｰｼﾞ
  (command "_purge" "LA" "*" "N") ; 使っていない画層を削除する.
  (command "_purge" "LA" "*" "N") ; 使っていない画層を削除する.
  (command "_purge" "LA" "*" "N") ; 使っていない画層を削除する.

  (if (not (tblsearch "LAYER" "N_SYMBOL"))
    (command "_layer" "N" "N_SYMBOL" "C" 4 "N_SYMBOL" "L" SKW_AUTO_LAY_LINE "N_SYMBOL" "")
  );_if
  (if (not (tblsearch "LAYER" "N_BREAKW"))
    (command "_layer" "N" "N_BREAKW" "C" -6 "N_BREAKW" "L" SKW_AUTO_LAY_LINE "N_BREAKW" "")
  );_if
  (if (not (tblsearch "LAYER" "N_BREAKD"))
    (command "_layer" "N" "N_BREAKD" "C" -6 "N_BREAKD" "L" SKW_AUTO_LAY_LINE "N_BREAKD" "")
  );_if
  (if (not (tblsearch "LAYER" "N_BREAKH"))
    (command "_layer" "N" "N_BREAKH" "C" -6 "N_BREAKH" "L" SKW_AUTO_LAY_LINE "N_BREAKH" "")
  );_if
  (if (not (tblsearch "LAYER" "Z_KUTAI"))
    (command "_layer" "N" "Z_KUTAI" "C" 55 "Z_KUTAI" "L" SKW_AUTO_LAY_LINE "Z_KUTAI" "")
  );_if

  (CFSetXRecord "BASESYM" nil) ; 基準ｱｲﾃﾑのｸﾘｱｰ 01/05/16 YM ADD
  (command "pdmode" "0")
  (command "_.QSAVE") ; 上書き保存
  (princ)
);WEBclear

;;;<HOM>***********************************************************************
;;; <関数名>    : NS_ChPlanInfo
;;; <処理概要>  : PlanInfo.cfgを更新する(通常ﾓｰﾄﾞ)
;;; <戻り値>    : なし
;;; <作成>      : 01/10/18 YM
;;; <備考>      :
;;;***********************************************************************>MOH<
(defun NS_ChPlanInfo (
  /
  #FP #PLANINFO$ #SERI$ #SFNAME
  )
  ; PlanInfo.cfgを更新
  ;// 現在のプラン情報(PLANINFO.CFG)を読み込む
  (setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
  ; 項目の更新
  (if (assoc "AUTOMODE"      #PLANINFO$)
    (setq #PLANINFO$ (subst (list "AUTOMODE"      "0")(assoc "AUTOMODE"      #PLANINFO$) #PLANINFO$))
  );_if
  (if (assoc "ZumenPRINT"    #PLANINFO$)
    (setq #PLANINFO$ (subst (list "ZumenPRINT"    "0")(assoc "ZumenPRINT"    #PLANINFO$) #PLANINFO$))
  );_if
  (if (assoc "MitumoriPRINT" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "MitumoriPRINT" "0")(assoc "MitumoriPRINT" #PLANINFO$) #PLANINFO$))
  );_if

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
  #seri$
);NS_ChPlanInfo

;;;<HOF>************************************************************************
;;; <ファイル名>: Pcsrcpln.LSP
;;; <システム名>: KPCADシステム
;;; <最終更新日>: 00/07/27 YM 新仕様ﾌﾟﾗﾝ検索ｷｯﾁﾝ部
;;; <備考>      :
;;;************************************************************************>FOH<

;;;<HOM>*************************************************************************
;;; <関数名>    : C:SearchPlan
;;; <処理概要>  : キッチンプラン検索
;;; <戻り値>    :
;;; <作成>      : 2000.1修正KPCAD
;;; <備考>      :
;;;               プラン検索の処理の流れ
;;;                1.検索画面による入力(C:SearchPlan)（★本処理★）
;;;                2.新規図面を開く(PC_SearchPlanNewDwg)
;;;                3.ACAD.LSP内でC:PC_LayoutPlanをコール
;;;                4.プラン検索が実行しPLAN.DWGとして保存(C:PC_LayoutPlan)
;;;                5.現在の物件に戻る
;;;                6.ACAD.LSP内でPLAN.DWGを挿入する処理を実行(C:PC_InsertPlan)
;;;*************************************************************************>MOH<
(defun C:SearchPlan (
  /
  #XRec$ #fp #msg
  )
  (CPrint_Time) ; 日付時刻をログに書き込む 00/02/17 YM ADD
  (setq CG_Srcpln T) ; プラン検索実行中に'Tになる 00/08/02

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
  (defun TempErr (msg / #msg)
    (setq CG_Srcpln nil)
    (setq CG_OpenMode nil)
    (setq CG_TESTMODE nil)      ;ﾃｽﾄﾓｰﾄﾞ
    (setq CG_AUTOMODE 0)        ;自動ﾓｰﾄﾞ 01/09/07 YM ADD 印刷まで
    (setq *error* nil)
    ;;; ｸﾞﾛｰﾊﾞﾙ変数のｸﾘｱｰ 00/09/08 YM
    (PK_ClearGlobal)
    (princ)
  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

  (if (or (= CG_AUTOMODE 0)(= CG_AUTOMODE nil)) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (setq *error* TempErr)
  );_if


  (if (= CG_AUTOMODE 0) ; 自動ﾓｰﾄﾞでは実行しない
    (C:arxStartApp (strcat CG_SysPATH "KillPlan.exe") 0)
  );_if

  (setq #XRec$ (CFGetXRecord "SERI"))

  (if (= #XRec$ nil)
    (progn
      ; 02/09/02 YM WEB版自動ﾓｰﾄﾞは強制終了
      (if (= CG_AUTOMODE 2)
        (*error*) ; 02/09/02 YM
      );_if

      (setq #msg "図面情報に誤りがあります(XRecordがない)")
      (CFAlertErr #msg)
      (setq *error* CmnErr) ; 何もしないエラー
      (if (or (= CG_TESTMODE 1)(= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 自動ﾓｰﾄﾞ,Web版,LOCAL端末
        (setq *error* nil)
      )
      (quit) ; @YM@ 追加 00/01/31 ｴﾗｰ: quit / exit による中止
    )
  );_if

    (WebOutLog "現在の商品情報を書き出します(SERIES.CFG)")
    (PC_WriteSeriesInfo #XRec$);// 現在の商品情報をファイルに書き出す ---> SERIES.CFG


    ;// プラン検索ダイアログの表示 テキストファイルにかき出す--->"srcpln.cfg"
    (WebOutLog "CADｻｰﾊﾞｰはﾌﾟﾗﾝ検索画面を表示しない")

    (cond
      ((or (= 2 CG_AUTOMODE)(= 3 CG_AUTOMODE)) ; Web版CADｻｰﾊﾞｰﾓｰﾄﾞ,LOCAL CAD端末ﾓｰﾄﾞのとき 02/08/05 YM
        ;ﾌﾟﾗﾝ検索画面を表示しない
        nil
      )
      ((= 1 CG_AUTOMODE); 自動ﾓｰﾄﾞのとき
        (CFYesDialog "自動作図を開始します")
        (C:arxStartApp (strcat CG_SysPATH "SKPlan.exe /Auto") 1)
      )
      (T
        ; 通常
        (if (= CG_TESTMODE 1)
          (progn ; ﾃｽﾄﾓｰﾄﾞ
            (princ)  ; ﾌﾟﾗﾝ検索画面を出さない
          )
          (progn ; 通常ﾓｰﾄﾞ & 自動ﾓｰﾄﾞ
            (C:arxStartApp (strcat CG_SysPATH "SKPLAN.EXE 0") 1)
          )
        );_if
      )
    );_cond


    (CPrint_Time) ; 日付時刻をログに書き込む 00/02/17 YM ADD


    (if (or (= CG_TESTMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3))
      (progn ; ﾃｽﾄﾓｰﾄﾞ or Web版CADｻｰﾊﾞｰﾓｰﾄﾞ
        (WebOutLog "--- (PC_SearchPlanNewDWG) ---")
        (PC_SearchPlanNewDWG)
      )
      (progn ; 通常ﾓｰﾄﾞ
        (if (ReadIniFile (strcat CG_SYSPATH "SRCPLN.CFG"))
          (PC_SearchPlanNewDWG)
        ; else
          (*error*)
        );_if
      )
    );_if

  (command "_REGEN")

  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (setq *error* nil)
  );_if
  
  (setq CG_Srcpln nil) ; プラン検索実行中に'Tになる 00/08/02
  (if (= CG_EyeLevelColCode nil)
    (setq CG_EyeLevelColCode "")
  );_if
  (PcSetKikiColor CG_EyeLevelColCode) ; 08/21 YM ADD
  ;;; ｸﾞﾛｰﾊﾞﾙ変数のｸﾘｱｰ 00/09/07 YM
  (WebOutLog "ｸﾞﾛｰﾊﾞﾙ変数をｸﾘｱｰします(PK_ClearGlobal)"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  (PK_ClearGlobal)

  ;2010/01/07 YM ADD KPCADのﾌﾟﾗﾝ検索のときは変数をｸﾘｱ @@@@@@@@@@@@@@@@@
  (if (= CG_AUTOMODE 0)
    (setq CG_GLOBAL$ nil)
  );_if
  
;;;(makeERR "B") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B
  (princ "\n--- 終了 ---")
  (princ)

);C:SearchPlan

;;;<HOM>*************************************************************************
;;; <関数名>  : PK_ClearGlobal
;;; <処理概要>: ｸﾞﾛｰﾊﾞﾙ変数のｸﾘｱｰ
;;; <戻り値>  : なし
;;; <備考>    : 00/09/07 YM
;;;*************************************************************************>MOH<
(defun PK_ClearGlobal ( / )

  ;03/12/23 YM ADD-S
  (setq CG_PREV_SYMSS nil)
  (setq CG_PREV_WTSS nil)
  (setq CG_AFTER_WTSS nil)
  (setq CG_AFTER_SYMSS nil)
  ;03/12/23 YM ADD-E

  (setq CG_SinkCode         nil) ;ｼﾝｸ記号
  (setq CG_CRCode           nil) ;ｺﾝﾛ
  (setq CG_NPCode           nil) ;食洗機種類
  (setq CG_RangeCode        nil) ;ﾚﾝｼﾞ
  (setq CG_WtrHoleTypeCode  nil) ;水栓穴
  (setq CG_WtrHoleCode      nil) ;水栓

  (setq CG_BASEPT1 nil)
  (setq CG_BASEPT2 nil)
  (setq CG_MAG1 nil)
  (setq CG_MAG2 nil)
  (setq CG_MAG3 nil)
  ; 01/12/17 YM ADD-S
  (setq CG_OPTID nil)
  (setq CG_RECNO$ nil)
  ; 01/12/17 YM ADD-E

  ;03/05/12 YM ADD
  (setq CG_FAMILYCODE nil)

  ;03/11/24 YM ADD
  (setq CG_Counter nil)     ;ｶｳﾝﾀｰ色

  ;04/04/28 YM ADD ﾌﾟﾗﾝ検索のときだけｸﾘｱｰする
  (if (= CG_AUTOMODE 0)
    (setq CG_Type1Code nil);ﾌﾟﾗﾝﾀｲﾌﾟ
  );_if

  ;2011/03/25 YM ADD-S
  (setq CG_DIST_YY nil)
  (setq CG_NO_BOX_FLG nil)
  (setq CG_SYOKUSEN_CAB nil)
  ;2011/03/25 YM ADD-E

  (setq CG_DRSeriCode_D nil)
  (setq CG_DRColCode_D  nil)
  (setq CG_Hikite_D     nil)
  (setq CG_DRSeriCode_M nil)
  (setq CG_DRColCode_M  nil)
  (setq CG_Hikite_M     nil)
  (setq CG_DRSeriCode_U nil)
  (setq CG_DRColCode_U  nil)
  (setq  CG_Hikite_U    nil)

;;;  (setq CG_WT_T nil) ; WTの厚み
;;;  (setq CG_BG_H nil) ; BGの高さ
;;;  (setq CG_BG_T nil) ; BGの厚み
;;;  (setq CG_FG_H nil) ; FGの高さ
;;;  (setq CG_FG_T nil) ; FGの厚み
;;;  (setq CG_FG_S nil) ; 前垂れシフト量
;;;(makeERR "PK_ClearGlobal") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (princ)
);PK_ClearGlobal

;;;<HOM>*************************************************************************
;;; <関数名>  : PC_WriteSeriesInfo
;;; <処理概要>: 現在のSERIES情報をファイルに書き出す
;;; <戻り値>  : なし
;;; <備考>    : SERIES.CFGに書き出す
;;;*************************************************************************>MOH<
(defun PC_WriteSeriesInfo (
  &XRec$
  /
  #fp #XRec$
  )

  (setq #XRec$ &XRec$)
  (setq  #fp (open (strcat CG_SYSPATH "SERIES.CFG") "w"))
  (princ ";-----------------------------------------" #fp)
  (princ "\n; プラン検索ダイアログに引き渡される情報" #fp)
  (princ "\n;"                                        #fp)
  (princ "\n;    00.ＤＢ記号"                         #fp)
  (princ "\n;    01.SERIES記号"                       #fp)
  (princ "\n;    02.ブランド記号×"                   #fp)
  (princ "\n;    03.工種記号    ×"                   #fp)

  (princ "\n;    12.扉SERIES記号"                     #fp)
  (princ "\n;    13.扉COLOR記号"                      #fp)
  (princ "\n;    14.ヒキテ記号"                       #fp)

  (princ "\n;    15.ロックフラグ×"                   #fp)
  (princ "\n;    31.取付タイプ  ×"                   #fp)
  (princ "\n;---------------------------------------" #fp)
  (princ (strcat "\n00=" (substr (nth 0 #XRec$) 4 9)) #fp) ;ＤＢ記号
  (princ (strcat "\n01="         (nth 1 #XRec$)     ) #fp) ;SERIES記号
  (princ         "\n02=N"                             #fp) ;ブランド記号
  (princ         "\n03=K"                             #fp) ;工種記号
  (princ (strcat "\n12="         (nth 3 #XRec$)     ) #fp) ;12.扉SERIES記号
  (princ (strcat "\n13="         (nth 4 #XRec$)     ) #fp) ;13.扉COLOR記号
  (princ (strcat "\n14="         (nth 5 #XRec$)     ) #fp) ;14.ヒキテ記号
  (princ         "\n15=S"                             #fp) ;ロックフラグ
  (princ         "\n31=850"                           #fp) ;取付タイプ
  (princ         "\n"                                 #fp)
  (close #fp)

  (princ)
) ; PC_WriteSeriesInfo

;;;<HOM>*************************************************************************
;;; <関数名>    : PC_SearchPlanNewDWG
;;; <処理概要>  : プラン検索用の新規図面を開く
;;; <戻り値>    : なし
;;; <作成>      : 2000.1.19修正KPCAD
;;; <備考>      :
;;;               プラン検索の処理の流れ
;;;                1.検索画面による入力(C:SearchPlan)
;;;                2.新規図面を開く(PC_SearchPlanNewDwg)（★本処理★）
;;;                3.ACAD.LSP内でC:PC_LayoutPlanをコール
;;;                4.プラン検索が実行しPLAN.DWGとして保存(C:PC_LayoutPlan)
;;;                5.現在の物件に戻る
;;;                6.ACAD.LSP内でPLAN.DWGを挿入する処理を実行(C:PC_InsertPlan)
;;;
;;;*************************************************************************>MOH<
(defun PC_SearchPlanNewDWG ( / )

  ;// 自動保存
  (CFAutoSave)
;;;(makeERR "5") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5
  (setq CG_OPENMODE 1) ;キッチン → (C:PC_LayoutPlan)

  (WebOutLog (strcat "CG_OPENMODE= " (itoa CG_OPENMODE)))

  (if (/= (getvar "DBMOD") 0)
    (progn
      (command "_qsave")
      (vl-cmdf "._new" ".")
    )
    (progn
      (vl-cmdf "._new" ".")
    )
  );_if

  ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
  (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

(WebOutLog (strcat "新規図面オープン後、Acaddoc.lsp からプラン検索(PC_LayoutPlan)を行う"))

  (S::STARTUP)
  ;// 新規図面オープン後、Acad.lsp からプラン検索(PC_LayoutPlan↓)を行う
);PC_SearchPlanNewDWG

;;;<HOM>*************************************************************************
;;; <関数名>    : PC_LayoutPlan
;;; <処理概要>  : プラン検索処理を実行
;;; <戻り値>    : なし
;;; <作成>      :
;;; <備考>      :
;;;               本処理は新規図面で行われ、plan.dwgとして保存される
;;;               処理が完了すると物件のmodel.dwgに戻している
;;;               プラン検索の処理の流れ
;;;                1.検索画面による入力(C:SearchPlan)
;;;                2.新規図面を開く(PC_SearchPlanNewDwg)
;;;                3.ACAD.LSP内でC:PC_LayoutPlanをコール（★本処理★）
;;;                4.プラン検索が実行しPLAN.DWGとして保存(C:PC_LayoutPlan)
;;;                5.現在の物件に戻る
;;;                6.ACAD.LSP内でPLAN.DWGを挿入する処理を実行(C:PC_InsertPlan)
;;;*************************************************************************>MOH<
(defun C:PC_LayoutPlan (
  /
  #pt #Obj$ #res$
  )

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
  (defun TempErr ( msg / #msg )
    (if (= CG_DEBUG 1) ; デバッグモード
      (progn
        (setq #msg (strcat "エラー個所：\n C:PC_LayoutPlan 以降 \n" msg))
      )
      (progn
        (setq #msg "プラン検索に失敗しました.\n")
        (setq #msg (strcat #msg "編集中の物件に戻ります。"))
        (CfDwgOpenByScript (strcat CG_KENMEI_PATH "model.dwg"))
      )
    );_if
    (CFAlertMsg #msg)
    (setq CG_OpenMode nil)      ; ｵｰﾌﾟﾝﾓｰﾄﾞ=nil
    (setq CG_TESTMODE nil)      ;ﾃｽﾄﾓｰﾄﾞ
    (setq CG_AUTOMODE 0)        ;自動ﾓｰﾄﾞ 01/09/07 YM ADD 印刷まで
    (setq *error* nil)
    ;;; ｸﾞﾛｰﾊﾞﾙ変数のｸﾘｱｰ
    (PK_ClearGlobal)
    (princ)
  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

  (WebOutLog "ｴﾗｰ関数 SKAutoError2 を定義します(C:PC_LayoutPlan)")
  (WebDefErrFunc) ; ｴﾗｰ関数定義(02/09/11 YM 関数化)

  (setvar "OSMODE" 0)
  (if (or (= "23" CG_ACADVER)(= "19" CG_ACADVER)(= "18" CG_ACADVER));2020/01/29 YM ADD
		(progn
	    (setvar "3DOSMODE"  1) ;2011/06/30 YM ADD
			(setvar "UCSDETECT" 0) ;ダイナミック UCS をアクティブにしない 2011/10/11 YM ADD
		)
  );_if
  (WebOutLog "ﾌﾟﾗﾝ検索内部処理を実行します(PC_LayoutPlanExec)"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  ;// ﾌﾟﾗﾝ検索内部処理
  (PC_LayoutPlanExec)

  ;// ﾚｲｱｳﾄが完成すれば図面を保存し、物件に戻る SKA,SDAのときだけ
;;; (if (or (wcmatch CG_SeriesDB "SK*")(= CG_SeriesDB "SDA"))
;;;   (progn
      (command "_saveas" "" (strcat CG_SYSPATH "plan.dwg"))
;;;   )
;;;   ;else
;;;   (progn ;収納拡大
;;;     ;plan1～5.dwgを保存済み
;;;     nil
;;;   )
;;; );_if

  (setq CG_OPENMODE 2)
  (command "_.open" (strcat CG_KENMEI_PATH "model.dwg"))
;;; (command "._style" "standard" "ＭＳ 明朝" "" "" "" "" "") ; ｼﾝｸｷｬﾋﾞの"????"をなくす07/07 YM
  ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
  (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

(WebOutLog (strcat "物件図面オープン後、Acaddoc.lsp からｾｯﾄﾌﾟﾗﾝdwgをInsert(PC_InsertPlan)"))

  (S::STARTUP) ; 00/03/03 YM ADD
  ;// 物件図面オープン後、Acad.lsp からレイアウト図面をInsert (PC_InsertPlan)
);C:PC_LayoutPlan

;;;<HOM>*************************************************************************
;;; <関数名>    : PC_InsertPlan
;;; <処理概要>  : プラン検索された図面を挿入する
;;; <戻り値>    : なし
;;; <作成>      :
;;; <備考>      :
;;;               本処理はACAD.LSPからコールされる
;;;               プラン検索の処理の流れ
;;;                1.検索画面による入力(C:SearchPlan)
;;;                2.新規図面を開く(PC_SearchPlanNewDwg)
;;;                3.ACAD.LSP内でC:PC_LayoutPlanをコール
;;;                4.プラン検索が実行しPLAN.DWGとして保存(C:PC_LayoutPlan)
;;;                5.現在の物件に戻る
;;;                6.ACAD.LSP内でPLAN.DWGを挿入する処理を実行(C:PC_InsertPlan)（★本処理★）
;;;*************************************************************************>MOH<
(defun C:PC_InsertPlan (
  /
  #ANG #EN #FAMILY$$ #I #INSPT #SETANG #SETPT #UNDOMARKS #WTBASE #XD$ #XREC$
  #BRK #DIM #ELM #K #SSWT #STRANG #STRH #WT_HINBAN #WT_PRICE #XDWTSET$ #en$
#PLAN$ #PLAN$$ #FP #SFNAME ; 03/12/23 YM ADD
#ss_P_ALL
;-- 2011/10/20 A.Satoh Add - S
#WTInfo$ #oku$ #handle$
;-- 2011/10/20 A.Satoh Add - E
#osmode		;-- 2011/11/02 A.Satoh Add
  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
  (defun TempErr (msg)
    (princ "\nプランの配置を行いませんでした。")
    (setq *error* nil)
    (setq CG_OpenMode nil)
    (setq CG_TESTMODE nil)      ;ﾃｽﾄﾓｰﾄﾞ
    (setq CG_AUTOMODE 0)        ;自動ﾓｰﾄﾞ 01/09/07 YM ADD 印刷まで
    ;;; ｸﾞﾛｰﾊﾞﾙ変数のｸﾘｱｰ 00/09/08 YM
    (PK_ClearGlobal)
    (command "_undo" "b") ; 01/05/16 YM
    (setq *error* nil) ; 01/05/16 YM

    (princ)
  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

  (WebDefErrFunc) ; ｴﾗｰ関数定義(02/09/11 YM 関数化)
  (WebOutLog "ｴﾗｰ関数 SKAutoError2 を定義しました(C:PC_InsertPlan)"); 02/09/04 YM ADD ﾛｸﾞ出力追加

;;;(makeERR "10") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@10

  (setq CG_OpenMode nil)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")

  ;// 現在のシンボル図形を求める
  (setq CG_PREV_SYMSS (ssget "X" '((-3 ("G_LSYM")))))
  (setq CG_PREV_WTSS (ssget "X" '((-3 ("G_WRKT")))))
  (if (= nil CG_PREV_SYMSS) (setq CG_PREV_SYMSS (ssadd)))
  (if (= nil CG_PREV_WTSS) (setq CG_PREV_WTSS (ssadd)))

  (CPrint_Time) ; 日付時刻をログに書き込む 00/02/17 YM ADD

  ;00/09/13 SN S-ADD
  ;ﾌﾟﾗﾝ検索取り消し用に、配置前にUndoのﾏｰｸを設定する。
  ;処理が何も無い状態ではﾏｰｸが設定出来ない？ので
  ;ﾏｰｸが設定出来るまで繰り返す。
  (setq #undomarks (getvar "UNDOMARKS"))
  (while (< (getvar "UNDOMARKS") #undomarks) ;2011/02/01 YM 無限ﾙｰﾌﾟ
    (command "_undo" "m")
  )
  ;00/09/13 SN E-ADD

  (if (= CG_AUTOMODE 2)
    nil  ; Web版CADｻｰﾊﾞｰﾓｰﾄﾞ
    (progn
;-- 2011/11/02 A.Satoh Mod - S
;      (SKChgView "0,0,1")
;      (command "_.vpoint" "2,-2,1")
;      (command "_zoom" "e")
      (command "_.vpoint" "0,0,1")
      (command "_zoom" "e")
;-- 2011/11/02 A.Satoh Del - E
    )
  );_if

  (WebOutLog "ﾌﾟﾗﾝを挿入します(C:PC_InsertPlan)"); 02/09/04 YM ADD ﾛｸﾞ出力追加

  (if CG_TESTMODE
    (progn
;-- 2011/11/02 A.Satoh Mod - S
;;;;;      (command "_Insert" (strcat CG_SYSPATH "plan.dwg") '(0 0 0) 1 1 "0") ; 配置位置固定
			(setq #osmode (getvar "OSMODE"))
			(setvar "OSMODE" 1)

      (princ "\n配置点: ")
			(command "_Insert" (strcat CG_SYSPATH "plan.dwg") PAUSE "" "")
			(princ "\n角度: ")
			(command PAUSE)
;-- 2011/11/02 A.Satoh Mod - E
    )
    (progn ; CG_TESTMODE =T 以外
      
      (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 自動ﾓｰﾄﾞ
        (progn ; 原点に自動配置する

;;;         (if (or (wcmatch CG_SeriesDB "*K*")(= CG_SeriesDB "SDA")) ;2011/02/01 YM MOD【PG分岐】
;;;           (progn
          (cond
            ((= BU_CODE_0005 "1") 

              (if (= (nth 11 CG_GLOBAL$) "R")
                (progn ; 右勝手
                  (command "_Insert" (strcat CG_SYSPATH "plan.dwg") '(0 0 0) 1 1 "0") ; 配置位置固定
                  (if (= CG_AUTOMODE 2)
                    nil  ; Web版CADｻｰﾊﾞｰﾓｰﾄﾞ
                    (progn
                      (SKChgView "2,-2,1") ; 00/02/23 YM ADD 視点東
                    )
                  );_if
                )
                (progn ; 左勝手
                  (command "_Insert" (strcat CG_SYSPATH "plan.dwg") '(3600 0 0) 1 1 "0") ; 配置位置固定
                  (if (= CG_AUTOMODE 2)
                    nil  ; Web版CADｻｰﾊﾞｰﾓｰﾄﾞ
                    (progn
                      (SKChgView "-2,-2,1") ; 視点南西
                    )
                  );_if
                )
              );_if

              (setq #insPt (getvar "LASTPOINT"))
              (setq #ang 0.0)
              (command "_explode" (entlast))

            )
            ((= BU_CODE_0005 "2") 
            ;(progn ;収納拡大 CADｻｰﾊﾞｰ自動作図 ★★★★★★★★★★ ;2011/02/01 YM MOD【PG分岐】

              (setq #ang 0.0)
              ;左右基準 LL or RR
              (cond
                ((= "LL" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_LL);5列挿入関数(左基準)
                )
                ((= "RR" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_RR);5列挿入関数(右基準)
                )
                (T
                  (SD_EXTEND_INSERT_LL);5列挿入関数(左基準)
                )
              );_cond

              ;ｶｳﾝﾀｰ接続 2009/12/1 YM ADD 収納拡大
              (JOIN_COUNTER)
              ;ｶｳﾝﾀｰ接続 2009/12/1 YM ADD 収納拡大

            )
            (T ;__OTHER
              (setq #ang 0.0)
              ;左右基準 LL or RR
              (cond
                ((= "LL" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_LL);5列挿入関数(左基準)
                )
                ((= "RR" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_RR);5列挿入関数(右基準)
                )
                (T
                  (SD_EXTEND_INSERT_LL);5列挿入関数(左基準)
                )
              );_cond

              ;ｶｳﾝﾀｰ接続 2009/12/1 YM ADD 収納拡大
              (JOIN_COUNTER)
              ;ｶｳﾝﾀｰ接続 2009/12/1 YM ADD 収納拡大
            )
          );_cond




        )
        (progn
          ;2010/03/11 YM MOD MJ2対応

;;;         (if (or (wcmatch CG_SeriesDB "*K*")(= CG_SeriesDB "SDA")) ;2011/02/01 YM MOD【PG分岐】
;;;           (progn ;従来
          (cond
            ((= BU_CODE_0005 "1") 

;-- 2011/11/02 A.Satoh Mod - S
;;;;;              (command "_Insert" (strcat CG_SYSPATH "plan.dwg") '(0 0 0) 1 1 0)
							(setq #osmode (getvar "OSMODE"))
							(setvar "OSMODE" 1)

        			(princ "\n配置点: ")
							(command "_Insert" (strcat CG_SYSPATH "plan.dwg") PAUSE "" "")
							(princ "\n角度: ")
							(command PAUSE)
;-- 2011/11/02 A.Satoh Mod - E

              (setq #insPt (getvar "LASTPOINT"))
              (setq #ang (cdr (assoc 50 (entget (entlast)))))
              (command "_explode" (entlast))

            )
            ((= BU_CODE_0005 "2") 
            ;(progn ;収納拡大 ﾌﾟﾗﾝ検索 ★★★★★★★★★★
              (setq #ang 0.0)
              ;左右基準 LL or RR
              (cond
                ((= "LL" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_LL);5列挿入関数(左基準)
                )
                ((= "RR" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_RR);5列挿入関数(右基準)
                )
                (T
                  (SD_EXTEND_INSERT_LL);5列挿入関数(左基準)
                )
              );_cond

              ;ｶｳﾝﾀｰ接続 2009/12/1 YM ADD 収納拡大
              (JOIN_COUNTER)
              ;ｶｳﾝﾀｰ接続 2009/12/1 YM ADD 収納拡大

            )
          );_cond

        )
      );_if


    )
  );_if

;-- 2011/11/02 A.Satoh Add - S
	(setvar "OSMODE" #osmode)
  (if (= CG_AUTOMODE 2)
    nil  ; Web版CADｻｰﾊﾞｰﾓｰﾄﾞ
    (progn
      (SKChgView "0,0,1")
      (command "_.vpoint" "2,-2,1")
      (command "_zoom" "e")
    )
  );_if
;-- 2011/11/02 A.Satoh Add - E


  (KcDelNoExistXRec "DANMENSYM"); Xrecord の項目から図面にないハンドル削除


  (cond
    ((= CG_AUTOMODE 0)
      (setq CG_WorkTop "??")
    )
    ((= CG_AUTOMODE 2);WEB版CADｻｰﾊﾞｰ処理
      (if (nth 16 CG_GLOBAL$) (setq CG_WorkTop (substr (nth 16 CG_GLOBAL$) 2 1))) ; 色柄グローバル設定
    )
  );_cond

;;;  (setq #insPt (getvar "LASTPOINT"))
;;;  (setq #ang (cdr (assoc 50 (entget (entlast)))))
;;;
;;;  (command "_explode" (entlast))

  ;// 配置した基準シンボルG_LSYM の配置点、配置角度を置き換える
  ;// 現在のシンボル図形を求める
  (setq CG_AFTER_SYMSS (ssget "X" '((-3 ("G_LSYM")))))

  ;// 新たに追加されたシンボル図形を求める
  (setq #i 0 #en$ nil)
  ;03/12/23 YM ADD ﾌﾟﾗﾝ検索構成をﾘｽﾄ化する
  (setq #plan$$ nil)

  (repeat (sslength CG_AFTER_SYMSS)
    (setq #en (ssname CG_AFTER_SYMSS #i))
    (if (= nil (ssmemb #en CG_PREV_SYMSS))
      (progn
        ; 03/08/25 YM ADD フードにも扉を貼る
        ; 後で扉を貼るもの #en$ 01/05/14 YM ADD
        (setq #en$ (cons #en #en$))

        (setq #setpt (cdr (assoc 10 (entget #en))))

        (setq #xd$ (CFGetXData #en "G_LSYM"))
        (setq #setang (+ #ang (nth 2 #xd$)))

        ;// 拡張データの更新
        (CFSetXData #en "G_LSYM"
          (list
            (nth  0 #xd$)  ;1 :本体図形ID      :
            #setpt         ;2 :挿入点          :  更新
            #setang        ;3 :回転角度        :  更新
            (nth  3 #xd$)  ;4 :工種記号        :
            (nth  4 #xd$)  ;5 :SERIES記号    :
            (nth  5 #xd$)  ;6 :品番名称        :
            (nth  6 #xd$)  ;7 :L/R区分         :
            (nth  7 #xd$)  ;8 :扉図形ID        :
            (nth  8 #xd$)  ;9 :扉開き図形ID    :
            (nth  9 #xd$)  ;10:性格CODE      :
            (nth 10 #xd$)  ;11:複合フラグ      :
            (nth 11 #xd$)  ;12:配置順番号      :
            (nth 12 #xd$)  ;13:用途番号        :
            (nth 13 #xd$)  ;14:寸法Ｈ          :
            (nth 14 #xd$)  ;15.断面指示の有無  :
            (nth 15 #xd$)  ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
          )
        )
        ;03/12/23 YM ADD-S
        (setq #plan$
          (list
            (nth  5 #xd$)  ;6 :品番名称
            (nth  6 #xd$)  ;7 :L/R区分
            (nth  9 #xd$)  ;10:性格CODE
          )
        )
        (setq #plan$$ (cons #plan$ #plan$$))
        ;03/12/23 YM ADD-E
      )
    );_if

    (KcSetDanmenSymXRec #en); Xrecord の"DANMENSYM" 変更 01/04/24 MH
    (setq #i (1+ #i))
  )

;;;(makeERR "14") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@14

  ;// 最新のワークトップを取得する
  ;// 配置した基準シンボルG_LSYM の配置点、配置角度を置き換える
  ;// 現在のシンボル図形を求める
  (setq CG_AFTER_WTSS (ssget "X" '((-3 ("G_WRKT")))))
  (if (/= CG_AFTER_WTSS nil)
    (progn
      ;// 新たに追加されたシンボル図形を求める
      (setq #i 0)
      (repeat (sslength CG_AFTER_WTSS)
        (setq #en (ssname CG_AFTER_WTSS #i))
        (if (= nil (ssmemb #en CG_PREV_WTSS))
          (progn
            (setq #xd$ (CFGetXData #en "G_WRKT"))
            
            (setq #xdWTSET$ (CFGetXData #en "G_WTSET"))
            (if #xdWTSET$
              (setq #WT_HINBAN (nth  1 #xdWTSET$))
              ;else
              (setq #WT_HINBAN "ERROR")
            );_if

            (setq #plan$
              (list
                #WT_HINBAN  ;WT品番
                ""
                ""
              )
            )
            (setq #plan$$ (cons #plan$ #plan$$))
            ;03/12/23 YM ADD-E ﾌﾟﾗﾝ検索 ﾜｰｸﾄｯﾌﾟ品番を取得する

            (setq #WTbase (PKGetWTLeftUpPT #insPt #ang (nth 32 #xd$)))
            ;// 拡張データの更新
            (CFSetXData #en "G_WRKT"
              (CFModList #xd$
                (list (list 32 #WTbase))
              )
            )

;-- 2011/10/20 A.Satoh Add - S
						(setq #WTInfo$
							(list
								(nth  8 #xd$)	; WTの取付高さ
								(nth 10 #xd$)	; WTの厚み
								(nth 12 #xd$)	; BGの高さ
								(nth 13 #xd$)	; BGの厚み
								(nth 15 #xd$)	; FGの厚み
								(nth 16 #xd$)	; FGの厚み
								(nth 17 #xd$)	; 前垂れシフト量
								""
								""
							)
						)
						(setq #oku$ (nth 57 #xd$))
						(cond
							((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (> (nth 2 #oku$) 0.0))
								(setq #handle$ (AddWTCutLineU #en #WTInfo$ 1))
								(if (/= #handle$ nil)
									(CFSetXData #en "G_WRKT" (CFModList #xd$
										(list
											(list  9 (nth 4 #handle$))
											(list 60 (nth 0 #handle$))
											(list 61 (nth 1 #handle$))
											(list 62 (nth 2 #handle$))
											(list 63 (nth 3 #handle$))
										)
									))
								)
							)
							((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (= (nth 2 #oku$) 0.0))
								;2014/12/15 YM MOD-S ----------------------------------------------------------------
										  ;ｶｯﾄﾀｲﾌﾟを決める (J,N,X,S)
										  (setq #Cut$$
										    (CFGetDBSQLRec CG_DBSESSION "WT材質"
										      (list
										        (list "材質記号" (nth 16 CG_GLOBAL$) 'STR)
										      )
										    )
										  )
										  (if (and #Cut$$ (= 1 (length #Cut$$)))
										    (setq #CutType (nth 6 (car #Cut$$))); 一意に決まった場合(X or J)
										    ;else 特定できない場合
										    (setq #CutType "N");ｶｯﾄなし
										  );_if

										  ;Jｶｯﾄの場合ｶｯﾄ方向を求める
											(setq #CutDirect "")
										  (if (= #CutType "J")
										    (progn
										      (setq #CutDir$$
										        (CFGetDBSQLRec CG_DBSESSION "WTカット方向"
										          (list
										            (list "シンク側間口" (nth  4 CG_GLOBAL$) 'STR)
										            (list "形状"         (nth  5 CG_GLOBAL$) 'STR)
										            (list "シンク位置"   (nth  2 CG_GLOBAL$) 'STR)
										          )
										        )
										      )
										      (if (and #CutDir$$ (= 1 (length #CutDir$$)))
										        (progn
										          (setq #CutDirect (nth 4 (car #CutDir$$))); 一意に決まった場合(S or G)
										        )
										        ;else 特定できない場合
										        (progn
										          (setq #CutType "N");ｶｯﾄなし
										        )
										      );_if
										    )
										  );_if

;(J,N,X,S)==>; カットID　0:カット無し 1:斜めカット 2:方向カット 3:直線ｶｯﾄ
							 (cond
								 ((= #CutType "N") (setq #CutID 0) )
								 ((= #CutType "X") (setq #CutID 1) )
								 ((= #CutType "J") (setq #CutID 2) )
								 ((= #CutType "S") (setq #CutID 3) )
								 (T                (setq #CutID 0) )
							 );_cond

;;;								(setq #handle$ (AddWTCutLineL #en #WTInfo$ 1));斜めｶｯﾄ固定
								(setq #handle$ (AddWTCutLineL_AUTO #en #WTInfo$ #CutID #CutDirect));ｶｯﾄ種類:#CutID 引数:#CutDirect追加

;;;(defun AddWTCutLineL (
;;;  &WT       ; 天板図形
;;;  &WTInfo   ; WTｼﾌﾄ量
;;;  &CutID    ; カットID　0:カット無し 1:斜めカット 2:方向カット
;;;  /


								;2014/12/15 YM MOD-E

								(if (/= #handle$ nil)
									(CFSetXData #en "G_WRKT" (CFModList #xd$
										(list
											(list  9 (nth 4 #handle$))
											(list 60 (nth 0 #handle$))
											(list 61 (nth 1 #handle$))
											(list 62 (nth 2 #handle$))
											(list 63 (nth 3 #handle$))
										)
									))
								);_if
							)
						);_cond
;-- 2011/10/20 A.Satoh Add - E




          )
        );_if
        (setq #i (1+ #i))
      );(repeat
    )
  );_if

  ;// インサートしたブロック定義をパージする
  (command "_purge" "BL" "PLAN" "N")

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

	;2013/11/19 YM MOD-S
  ;// ガス種、電気種を更新する
;;;  (if (/= CG_GasType nil)
;;;    (progn
;;;      (setq #XRec$ (CFGetXRecord "SERI"))
;;;      (CFSetXRecord "SERI"
;;;        (CFModList #XRec$
;;;          (list
;;;            (list 9  CG_GasType) ;ガス種 ; CG_GusCode→CG_GasType ; 02/07/31 YM MOD
;;;            (list 10 CG_HzCode)  ;電気種
;;;          )
;;;        )
;;;      )
;;;    )
;;;  );_if

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

	;2013/11/19 YM MOD-E

  ; 扉はここで始めて貼りつけるように変更
  ; 扉ｸﾞﾙｰﾌﾟ名が名前のないｸﾞﾙｰﾌﾟにならないようにするため

  ;//---------------------------------------------------------
  ;// 扉面の貼付
  ;//---------------------------------------------------------
  (WebOutLog "扉面の貼付を行います(PCD_MakeViewAlignDoor)"); 02/09/04 YM ADD ﾛｸﾞ出力追加

  (cond
    ((= BU_CODE_0011 "1")
      ;// 扉面の貼り付け(SDC下台,中台,上台で指定を分ける)　★2011/04/22 YM ADD 立体陣笠対応
      ;2011/05/27 YM ADD ★ｷｯﾁﾝ立体陣笠対応 もここを通る
      (if (= CG_MKDOOR T)
        (progn
          (Door_Down_Mid_Up #en$  3 T)
        )
      );_if
    )
    (T ;従来一括扉張替え
      (if (= CG_MKDOOR T)
;-- 2011/12/22 A.Satoh Add - S
;;;;;        (PCD_MakeViewAlignDoor #en$ 3 nil)
        (PCD_MakeViewAlignDoor #en$ 3 T)
;-- 2011/12/22 A.Satoh Add - E
      );_if
    )
  );_cond




  (if CG_TESTMODE
    (progn
      nil
    )
    (progn
      (setq #sFname (strcat CG_KENMEI_PATH "PLAN.CFG"))
      (if (findfile #sFname)(vl-file-delete #sFname))
      (setq #fp  (open #sFname "w"))
      (if (and #plan$$ (/= nil #fp))
        (progn
          (foreach #elm #plan$$
            (princ (nth 0 #elm) #fp);品番
            (princ ","  #fp)
            (princ (nth 1 #elm) #fp);LR
            (princ ","  #fp)
            (princ (nth 2 #elm) #fp);性格ｺｰﾄﾞ
            (princ "\n" #fp)
          )
          (close #fp)
        )
        (progn
          (princ)
        )
      );_if

    )
  );_if


  (if (= CG_AUTOMODE 0)
    (setq *error* nil)
  );_if
  (CPrint_Time) ; 日付時刻をログに書き込む 00/02/17 YM ADD
  (WebOutLog "ﾌﾟﾗﾝを挿入しました"); 02/09/04 YM ADD ﾛｸﾞ出力追加

  ;2009/02/06 YM ADD-S CG対応で面に色追加したが、"bylayer"に戻す
  (setq #ss_P_ALL (ssget "X" (list (cons 8 "Z_00_00_00_01"))))
  (command "_chprop" #ss_P_ALL "" "C" "BYLAYER" "")
  ;2009/02/06 YM ADD-E CG対応で面に色追加したが、"bylayer"に戻す

  (setq CG_PREV_SYMSS nil)
  (setq CG_PREV_WTSS nil)
  (setq CG_AFTER_WTSS nil)
  (setq CG_AFTER_SYMSS nil)

  (princ)
);PC_InsertPlan



;<HOM>*************************************************************************
; <関数名>    : Door_Down_Mid_Up
; <処理概要>  : 扉面の貼り付け(SDC下台,中台,上台で指定を分ける)
; <戻り値>    : 作成された扉面
; <備考>      :
; <作成>      : ★2011/04/22 YM ADD 立体陣笠対応
;*************************************************************************>MOH<
(defun Door_Down_Mid_Up (
  &en$ ;部材ﾘｽﾄ
  &iFlg ;3
  &Flg  ;T
  /
  #12 #13 #14 #HIN #QRY$$ #XD$
  )

  (foreach #en &en$
    (setq #xd$ (CFGetXData #en "G_LSYM"))
    (setq #hin (nth 5 #xd$))
    ;"()"を外す
    (setq #hin (KP_DelHinbanKakko #hin))
    ;下,中,上の判定[上中下扉拾い]
    (setq #qry$$
      (CFGetDBSQLRec CG_DBSESSION "上中下扉拾い"
        (list (list "品番名称" #hin 'STR))
      )
    )
    (if (and #qry$$ (= 1 (length #qry$$)))
      (progn
        (setq #12 (atoi (nth 2 (car #qry$$))));扉シリ
        (setq #13 (atoi (nth 3 (car #qry$$))));扉色
        (setq #14 (atoi (nth 4 (car #qry$$))));引手
        (if CG_GLOBAL$
          (progn ;CADｻｰﾊﾞｰ自動作図
            ;一時的に現在の扉を変更
            (setq CG_DRSeriCode   (nth #12 CG_GLOBAL$))
            (setq CG_DRColCode    (nth #13 CG_GLOBAL$))
            (setq CG_Hikite       (nth #14 CG_GLOBAL$))

            (if (= nil CG_DRSeriCode)(setq CG_DRSeriCode   CG_DRSeriCode_D))
            (if (= nil CG_DRColCode) (setq CG_DRColCode    CG_DRColCode_D))
            (if (= nil CG_Hikite)    (setq CG_Hikite       CG_Hikite_D))

          )
          (progn ;KPCAD
;;; (setq CG_DRSeriCode_D (nth 62 CG_GLOBAL$));下台
;;; (setq CG_DRColCode_D  (nth 63 CG_GLOBAL$));下台
;;; (setq CG_Hikite_D     (nth 64 CG_GLOBAL$));下台
;;;
;;; (setq CG_DRSeriCode_M (nth 82 CG_GLOBAL$));中台
;;; (setq CG_DRColCode_M  (nth 83 CG_GLOBAL$));中台
;;; (setq CG_Hikite_M     (nth 84 CG_GLOBAL$));中台
;;;
;;; (setq CG_DRSeriCode_U (nth 92 CG_GLOBAL$));上台
;;; (setq CG_DRColCode_U  (nth 93 CG_GLOBAL$));上台
;;; (setq CG_Hikite_U     (nth 94 CG_GLOBAL$));上台

            (cond
              ((= #12 62)
                (setq CG_DRSeriCode   CG_DRSeriCode_D)
                (setq CG_DRColCode    CG_DRColCode_D)
                (setq CG_Hikite       CG_Hikite_D)
              )
              ((= #12 82)
                (setq CG_DRSeriCode   CG_DRSeriCode_M)
                (setq CG_DRColCode    CG_DRColCode_M)
                (setq CG_Hikite       CG_Hikite_M)
              )
              ((= #12 92)
                (setq CG_DRSeriCode   CG_DRSeriCode_U)
                (setq CG_DRColCode    CG_DRColCode_U)
                (setq CG_Hikite       CG_Hikite_U)
              )
              ;2011/05/27 YM ADD-S ★ｷｯﾁﾝ立体陣笠対応
              ((= #12 12)
                (setq CG_DRSeriCode   CG_DRSeriCode_D)
                (setq CG_DRColCode    CG_DRColCode_D)
                (setq CG_Hikite       CG_Hikite_D)
              )
              ((= #12 112)
                (setq CG_DRSeriCode   CG_DRSeriCode_U)
                (setq CG_DRColCode    CG_DRColCode_U)
                (setq CG_Hikite       CG_Hikite_U)
              )
              ;2011/05/27 YM ADD-E ★ｷｯﾁﾝ立体陣笠対応
              (T
                (setq CG_DRSeriCode   CG_DRSeriCode_D)
                (setq CG_DRColCode    CG_DRColCode_D)
                (setq CG_Hikite       CG_Hikite_D)
              )
            );_cond

          )
        )
      )
      (progn
        ;下台(基準)を使う
        (setq CG_DRSeriCode   CG_DRSeriCode_D)
        (setq CG_DRColCode    CG_DRColCode_D)
        (setq CG_Hikite       CG_Hikite_D)
      )
    );_if
    ;個別に扉張替え
    (PCD_MakeViewAlignDoor (list #en) &iFlg &Flg)
  );(foreach

  ;扉を元に戻す
  (setq CG_DRSeriCode   CG_DRSeriCode_D)
  (setq CG_DRColCode    CG_DRColCode_D)
  (setq CG_Hikite       CG_Hikite_D)

  (princ)
);_Door_Down_Mid_Up

;;;<HOM>*************************************************************************
;;; <関数名>    : JOIN_COUNTER
;;; <処理概要>  : 収納拡大ｶｳﾝﾀｰ接続処理
;;; <戻り値>    : なし
;;; <作成>      : 2009/12/1 YM ADD
;;;
;;;カウンタ接続条件
;;;①奥行きが同じ
;;;②基本構成(高さ)が同じ
;;;③パネルを挟まない
;;;④合計間口2700mm以下
;;;*************************************************************************>MOH<
(defun JOIN_COUNTER (
  /
  #GROUP_1$$ #GROUP_11$$ #GROUP_2$$ #GROUP_22$$ #GROUP_3$$ #GROUP_4$$ #I
  #INFO$ #INFO$$ #RET$$ #SS #SYM #GROUP_A$$ #GROUP_B$$ #GROUP_C$$ #GROUP_D$$
  #GROUP_111$$ #GROUP_222$$
  )
  ;ｶｳﾝﾀに埋め込まれた情報を取得(Xdata"G_COUNTER")
  (setq #ss (ssget "X" '((-3 ("G_COUNTER")))));ｶｳﾝﾀｰを収集

  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (setq #info$$ nil)
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        (setq #info$ (CFGetXData #sym "G_COUNTER"))
        (setq #info$$ (append #info$$ (list #info$)))
        (setq #i (1+ #i))
      )
      ;列順でｿｰﾄ
      (setq #info$$ (CFListSort #info$$ 0)) ; (nth 1 が小さいもの順にｿｰﾄ

      ;ｶｳﾝﾀｰ接続判定1 列番号が連続するｸﾞﾙｰﾌﾟに分ける(5列なので最大2ｸﾞﾙｰﾌﾟ)
      (setq #GROUP_1$$ nil #GROUP_2$$ nil)
      (setq #ret$$ (JOIN_COUNTER_HANTEI1 #info$$))
      (setq #GROUP_1$$ (nth 0 #ret$$))
      (setq #GROUP_2$$ (nth 1 #ret$$))

      ;ｶｳﾝﾀｰ接続判定2 奥行き,高さ(種別)が同じでﾊﾟﾈﾙがない("N")場合だけに絞る
      (setq #GROUP_A$$ nil #GROUP_B$$ nil #GROUP_C$$ nil #GROUP_D$$ nil)
      (if #GROUP_1$$
        (progn

          ;2011/02/22 YM MOD ｶｳﾝﾀｰ接続条件分岐
          (cond
            ((= BU_CODE_0007 "1") 
              (setq #ret$$ (JOIN_COUNTER_HANTEI2 #GROUP_1$$))
            )
            ((= BU_CODE_0007 "2")
              ; 新ｽｲｰｼﾞｨ収納はｶｳﾝﾀｰ色も条件に追加
              (setq #ret$$ (JOIN_COUNTER_HANTEI2_2 #GROUP_1$$))
            )
            (T
              (setq #ret$$ (JOIN_COUNTER_HANTEI2_2 #GROUP_1$$))
            )
          );_cond

          (setq #GROUP_A$$ (nth 0 #ret$$))
          (setq #GROUP_B$$ (nth 1 #ret$$))
        )
      );_if
      (if #GROUP_2$$
        (progn

          ;2011/02/22 YM MOD ｶｳﾝﾀｰ接続条件分岐
          (cond
            ((= BU_CODE_0007 "1") 
              (setq #ret$$ (JOIN_COUNTER_HANTEI2 #GROUP_2$$))
            )
            ((= BU_CODE_0007 "2")
              ; 新ｽｲｰｼﾞｨ収納はｶｳﾝﾀｰ色も条件に追加
              (setq #ret$$ (JOIN_COUNTER_HANTEI2_2 #GROUP_2$$))
            )
            (T
              (setq #ret$$ (JOIN_COUNTER_HANTEI2_2 #GROUP_2$$))
            )
          );_cond
          
          (setq #GROUP_C$$ (nth 0 #ret$$))
          (setq #GROUP_D$$ (nth 1 #ret$$))
        )
      );_if

      ;最大2ｸﾞﾙｰﾌﾟ
      (setq #GROUP_11$$ nil #GROUP_22$$ nil)
      (foreach #GROUP$$ (list #GROUP_A$$ #GROUP_B$$ #GROUP_C$$ #GROUP_D$$)
        (if (/= nil #GROUP$$)
          (progn
            (if (= nil #GROUP_11$$)
              (setq #GROUP_11$$ #GROUP$$)
              ;else
              (setq #GROUP_22$$ #GROUP$$)
            );_if
          )
        );_if
      );foreach

      ;ｶｳﾝﾀｰ接続判定3 間口合計2700mmまでで分ける 2009/12/02
      (setq #GROUP_1$$ nil #GROUP_2$$ nil #GROUP_3$$ nil #GROUP_4$$ nil)
      (if #GROUP_11$$
        (progn
          (setq #ret$$ (JOIN_COUNTER_HANTEI3 #GROUP_11$$))
          (setq #GROUP_1$$ (nth 0 #ret$$))
          (setq #GROUP_2$$ (nth 1 #ret$$))
        )
      );_if
      (if #GROUP_22$$
        (progn
          (setq #ret$$ (JOIN_COUNTER_HANTEI3 #GROUP_22$$))
          (setq #GROUP_3$$ (nth 0 #ret$$))
          (setq #GROUP_4$$ (nth 1 #ret$$))
        )
      );_if


      ;最大2ｸﾞﾙｰﾌﾟ
      (setq #GROUP_111$$ nil #GROUP_222$$ nil)
      (foreach #GROUP$$ (list #GROUP_1$$ #GROUP_2$$ #GROUP_3$$ #GROUP_4$$)
        (if (/= nil #GROUP$$)
          (progn
            (if (= nil #GROUP_111$$)
              (setq #GROUP_111$$ #GROUP$$)
              ;else
              (setq #GROUP_222$$ #GROUP$$)
            );_if
          )
        );_if
      );foreach

      ;ｶｳﾝﾀｰ接続処理を行う
      (Put_JoinCouter #GROUP_111$$ #GROUP_222$$)
        
    )
  );_if
  (princ)
);JOIN_COUNTER

;;;<HOM>*************************************************************************
;;; <関数名>    : Put_JoinCouter
;;; <処理概要>  : 収納拡大ｶｳﾝﾀｰ配置処理
;;; <戻り値>    : なし
;;; <作成>      : 2009/12/2 YM ADD
;;;*************************************************************************>MOH<
(defun Put_JoinCouter (
  &GROUP_11$$
  &GROUP_22$$
  /
  #AB #ANG #CT_HINBAN #DD #GROUP_11$$ #GROUP_22$$ #LLRR #LR #PT #QRY$ #SWW #SYM$ #WW #WW_ALL
  #PT$ #SYM #COL
  )
  (foreach #GROUP$$ (list &GROUP_11$$ &GROUP_22$$)
    (if #GROUP$$
      (progn
        (setq #WW_ALL 0);合計間口
        (setq #sym$ nil);削除ｼﾝﾎﾞﾙ図形
        (setq #pt$  nil);削除ｼﾝﾎﾞﾙ位置座標
        (foreach #GROUP$ #GROUP$$
          (setq #sWW (nth 3 #GROUP$));間口
          (setq #qry$
            (CFGetDBSQLRec CG_DBSESSION "間口"
              (list (list "間口記号" #sWW 'STR))
            )
          )
          (setq #WW (nth 2 (car #qry$)));間口(mm)
          (setq #WW_ALL (+ #WW_ALL #WW));間口を累積させる

          ;削除ｶｳﾝﾀｰｼﾝﾎﾞﾙ図形の累積
          (setq #sym (nth 5 #GROUP$))
          (setq #sym$ (append #sym$ (list (nth 5 #GROUP$))))
          (setq #pt (cdr (assoc 10 (entget #sym))))
          (setq #pt$ (append #pt$ (list #pt)))
        );foreach


        ;ｶｳﾝﾀｰ図形の削除
        (foreach #sym #sym$
          (command "_erase" (CFGetSameGroupSS #sym) "")
        )

        ;接続後ｶｳﾝﾀｰを求める
        ;奥行
        (setq #DD (nth 1 (car #GROUP$$)));奥行き
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "奥行"
            (list (list "奥行記号" #DD 'STR))
          )
        )
        (setq #DD (nth 2 (car #qry$)));奥行(mm)
        (setq #DD (itoa (fix #DD)));奥行(mm)
        ;種別
        (setq #AB (nth 2 (car #GROUP$$)))
        ;間口
        (setq #WW_ALL (itoa (fix #WW_ALL)))

        ;2011/03/02 YM ADD-S "カウンタ色"
        (setq #COL (nth 7 (car #GROUP$$)))
        ;2011/03/02 YM ADD-E "カウンタ色"
        
        ;2011/03/02 YM ADD "カウンタ色"もKEYに追加する SDCだけでなく、SDBに遡るのでPG分岐なし
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "Cカウンタ置換"
            (list
              (list "種類CODE"    #AB     'STR)
              (list "収納間口"    #WW_ALL 'INT)
              (list "奥行き"      #DD     'INT)
              (list "カウンタ色"  #COL    'STR);;2011/03/02 YM ADD
            )
          )
        )
        (setq #qry$ (DBCheck #qry$ "『Cカウンタ置換』" "JOIN_COUNTER"))
        (setq #CT_hinban (nth 4 #qry$))
        (setq #LR        (nth 5 #qry$))

        ;ｶｳﾝﾀｰ挿入基点を求める
        (setq #LLRR (nth 60 CG_GLOBAL$));左右基準 
        (cond
          ((= #LLRR "LL")
            (setq #PT (car #pt$));左基準は最初のｶｳﾝﾀｰ基点
          )
          ((= #LLRR "RR")
            (setq #PT (last #pt$));右基準は最後のｶｳﾝﾀｰ基点
          )
          (T
            (setq #PT (car #pt$))
          )
        );_cond

        ;ｶｳﾝﾀｰ挿入処理
        (setq #ANG 0.0)

        ;2011/07/27 YM MOD-S
        (TK_PosParts #CT_hinban #LR #PT #ANG 1 "D")
;;;       (TK_PosParts #CT_hinban #LR #PT #ANG nil "D")
        ;2011/07/27 YM MOD-E

      )
    );_if

  );foreach
  (princ)
);Put_JoinCouter

;;;<HOM>*************************************************************************
;;; <関数名>    : JOIN_COUNTER_HANTEI3
;;; <処理概要>  : 収納拡大ｶｳﾝﾀｰ接続処理
;;; <戻り値>    : なし
;;; <作成>      : 2009/12/02 YM ADD
;;;ｶｳﾝﾀｰ接続判定3 間口合計2700mmまでで分ける
;;;*************************************************************************>MOH<
(defun JOIN_COUNTER_HANTEI3 (
  &info$$
  /
  #GROUP$$ #GROUP_1$$ #GROUP_2$$ #I #QRY$ #SWW #WW #WW_ALL #MAX
#COL
  )

  ;2011/02/22 YM MOD ｶｳﾝﾀｰ接続対応
  ;従来
  ;ｶｳﾝﾀｰ間口KEY=MAX
;;;  (setq #qry$
;;;   (CFGetDBSQLRec CG_DBSESSION "Cカウンタ最大間口"
;;;     (list (list "KEY" "MAX" 'STR))
;;;   )
;;; )

  ;SDC 新ｽｲｰｼﾞｨ収納 (SDBも遡ってSDCとあわせる "MAX"の代わりに"SW"を登録)
  (setq #COL (nth 7 (car &info$$))) ;ｶｳﾝﾀｰ色
  ;ｶｳﾝﾀｰ間口KEY=材質記号
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "Cカウンタ最大間口"
      (list (list "KEY" #COL 'STR))
    )
  )


  (setq #MAX (nth 1 (car #qry$)));最大間口(mm)
  ;(setq #MAX 1800.0);@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
  (setq #GROUP$$ nil);仮格納用
  (setq #GROUP_1$$ nil);接続ｶｳﾝﾀｰｸﾞﾙｰﾌﾟ1
  (setq #GROUP_2$$ nil);接続ｶｳﾝﾀｰｸﾞﾙｰﾌﾟ2
  (if (< 1 (length &info$$))
    (progn
      (setq #i 0)
      (setq #WW_ALL 0);累積間口

      (foreach #info$ &info$$ ;ｶｳﾝﾀｰ情報
        (setq #sWW (nth 3 #info$));間口
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "間口"
            (list (list "間口記号" #sWW 'STR))
          )
        )
        (setq #WW (nth 2 (car #qry$)));間口(mm)

        (if (= 0 #WW_ALL)
          (progn ;初回
            (setq #GROUP$$ (append #GROUP$$ (list #info$)))
            (setq #WW_ALL (+ #WW_ALL #WW));間口を累積させる
          )
          (progn ;2回目以降 2700mm以下なら追加
            (setq #WW_ALL (+ #WW_ALL #WW));間口を累積させる

            (if (> (+ #MAX 1.0) #WW_ALL) ;2700mm以下なら追加
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
              )
              (progn ;2700mmｵｰﾊﾞｰ
                (if (> 2 (length #GROUP$$))
                  (progn
                    (setq #GROUP$$ nil);ｸﾘｱ
                    (setq #WW_ALL 0)   ;累積間口ｸﾘｱ
                    (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                    (setq #WW_ALL (+ #WW_ALL #WW));間口を累積させる
                  )
                  (progn ;既に2つ以上たまっている
                    (if (= nil #GROUP_1$$)
                      (setq #GROUP_1$$ #GROUP$$)
                      ;else
                      (setq #GROUP_2$$ #GROUP$$)
                    );_if
                    (setq #GROUP$$ nil);ｸﾘｱ
                    (setq #WW_ALL 0)   ;累積間口ｸﾘｱ
                    (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                    (setq #WW_ALL (+ #WW_ALL #WW));間口を累積させる
                  )
                );_if

              )
            );_if
          )
        );_if
        
        (setq #i (1+ #i))
      );foreach
      
      (if (< 1 (length #GROUP$$))
        (progn ;2つ以上たまっている
          (if (= nil #GROUP_1$$)
            (setq #GROUP_1$$ #GROUP$$)
            ;else
            (setq #GROUP_2$$ #GROUP$$)
          );_if
        )
      );_if

    )
  );_if

  ;戻り値
  (list #GROUP_1$$ #GROUP_2$$)
);JOIN_COUNTER_HANTEI3

;;;<HOM>*************************************************************************
;;; <関数名>    : JOIN_COUNTER_HANTEI2
;;; <処理概要>  : 収納拡大ｶｳﾝﾀｰ接続処理
;;; <戻り値>    : なし
;;; <作成>      : 2009/12/1 YM ADD
;;;ｶｳﾝﾀｰ接続判定2 奥行き,高さ(種別)が同じでﾊﾟﾈﾙがない("N")場合だけに絞る
;;;*************************************************************************>MOH<
(defun JOIN_COUNTER_HANTEI2 (
  &info$$
  /
  #DD #DD_OLD #EP #GROUP$$ #GROUP_1$$ #GROUP_2$$ #HH #HH_OLD #I
#EP_OLD
  )
  (setq #GROUP$$ nil);仮格納用
  (setq #GROUP_1$$ nil);接続ｶｳﾝﾀｰｸﾞﾙｰﾌﾟ1
  (setq #GROUP_2$$ nil);接続ｶｳﾝﾀｰｸﾞﾙｰﾌﾟ2
  (if (< 1 (length &info$$))
    (progn
      (setq #i 0)
      (setq #DD_old nil);前回の奥行き
      (setq #HH_old nil);前回の高さ(種別)
      (setq #EP_old nil);ｴﾝﾄﾞﾊﾟﾈﾙ有無

      (foreach #info$ &info$$ ;ｶｳﾝﾀｰ情報
        (setq #DD (nth 1 #info$));奥行き
        (setq #HH (nth 2 #info$));高さ(種別)
        (setq #EP (nth 4 #info$));ｴﾝﾄﾞﾊﾟﾈﾙ有無

        (if (= nil #DD_old)
          (progn ;初回
            (if (= #EP "N");初回"Y"は除く
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                (setq #DD_old #DD);前回の奥行き
                (setq #HH_old #HH);前回の高さ(種別)
                (setq #EP_old #EP);前回のEP有無
              )
            );_if
          )
          (progn ;2回目以降
            (if (and (= #DD #DD_old) ;前回と奥行きが同じ
                     (= #HH #HH_old) ;前回と高さ(種別)が同じ
                     (= #EP_old "N"));ｴﾝﾄﾞﾊﾟﾈﾙなし 前回"Y"は除く
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                (setq #DD_old #DD);前回の奥行き
                (setq #HH_old #HH);前回の高さ(種別)
                (setq #EP_old #EP);前回のEP有無
              )
              (progn
                (if (> 2 (length #GROUP$$))
                  (progn
                    (setq #GROUP$$ nil);ｸﾘｱ
                    (if (= #EP "N")
                      (progn
                        (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                        (setq #DD_old #DD);前回の奥行き
                        (setq #HH_old #HH);前回の高さ(種別)
                        (setq #EP_old #EP);前回のEP有無
                      )
                    );_if
                  )
                  (progn ;既に2つ以上たまっている
                    (if (= nil #GROUP_1$$)
                      (setq #GROUP_1$$ #GROUP$$)
                      ;else
                      (setq #GROUP_2$$ #GROUP$$)
                    );_if
                    (setq #GROUP$$ nil);ｸﾘｱ
                    (if (= #EP "N")
                      (progn
                        (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                        (setq #DD_old #DD);前回の奥行き
                        (setq #HH_old #HH);前回の高さ(種別)
                        (setq #EP_old #EP);前回のEP有無
                      )
                    );_if
                  )
                );_if

              )
            );_if
          )
        );_if
        
        (setq #i (1+ #i))
      );foreach
      
      (if (< 1 (length #GROUP$$))
        (progn ;2つ以上たまっている
          (if (= nil #GROUP_1$$)
            (setq #GROUP_1$$ #GROUP$$)
            ;else
            (setq #GROUP_2$$ #GROUP$$)
          );_if
        )
      );_if

    )
  );_if

  ;戻り値
  (list #GROUP_1$$ #GROUP_2$$)
);JOIN_COUNTER_HANTEI2

;;;<HOM>*************************************************************************
;;; <関数名>    : JOIN_COUNTER_HANTEI2_2
;;; <処理概要>  : 収納拡大ｶｳﾝﾀｰ接続処理
;;; <戻り値>    : なし
;;; <作成>      : 2011/02/22 YM ADD
;;;ｶｳﾝﾀｰ接続判定2 奥行き,高さ(種別)が同じでﾊﾟﾈﾙがない("N")場合だけに絞る
;;;★条件にｶｳﾝﾀｰ色も追加★
;;;*************************************************************************>MOH<
(defun JOIN_COUNTER_HANTEI2_2 (
  &info$$
  /
  #DD #DD_OLD #EP #GROUP$$ #GROUP_1$$ #GROUP_2$$ #HH #HH_OLD #I
#EP_OLD #CO #CO_OLD
  )
  (setq #GROUP$$ nil);仮格納用
  (setq #GROUP_1$$ nil);接続ｶｳﾝﾀｰｸﾞﾙｰﾌﾟ1
  (setq #GROUP_2$$ nil);接続ｶｳﾝﾀｰｸﾞﾙｰﾌﾟ2
  (if (< 1 (length &info$$))
    (progn
      (setq #i 0)
      (setq #DD_old nil);前回の奥行き
      (setq #HH_old nil);前回の高さ(種別)
      (setq #EP_old nil);ｴﾝﾄﾞﾊﾟﾈﾙ有無
      (setq #CO_old nil);★前回のｶｳﾝﾀｰ色★

      (foreach #info$ &info$$ ;ｶｳﾝﾀｰ情報
        (setq #DD (nth 1 #info$));奥行き
        (setq #HH (nth 2 #info$));高さ(種別)
        (setq #EP (nth 4 #info$));ｴﾝﾄﾞﾊﾟﾈﾙ有無
        (setq #CO (nth 7 #info$));★前回のｶｳﾝﾀｰ色★

        (if (= nil #DD_old)
          (progn ;初回
            (if (= #EP "N");初回"Y"は除く
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                (setq #DD_old #DD);前回の奥行き
                (setq #HH_old #HH);前回の高さ(種別)
                (setq #EP_old #EP);前回のEP有無
                (setq #CO_old #CO);★前回のｶｳﾝﾀｰ色★
              )
            );_if
          )
          (progn ;2回目以降
            (if (and (= #DD #DD_old) ;前回と奥行きが同じ
                     (= #HH #HH_old) ;前回と高さ(種別)が同じ
                     (= #EP_old "N") ;ｴﾝﾄﾞﾊﾟﾈﾙなし 前回"Y"は除く
                     (= #CO #CO_old));前回と★ｶｳﾝﾀｰ色★が同じ
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                (setq #DD_old #DD);前回の奥行き
                (setq #HH_old #HH);前回の高さ(種別)
                (setq #EP_old #EP);前回のEP有無
                (setq #CO_old #CO);★前回のｶｳﾝﾀｰ色★
              )
              (progn
                (if (> 2 (length #GROUP$$))
                  (progn
                    (setq #GROUP$$ nil);ｸﾘｱ
                    (if (= #EP "N")
                      (progn
                        (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                        (setq #DD_old #DD);前回の奥行き
                        (setq #HH_old #HH);前回の高さ(種別)
                        (setq #EP_old #EP);前回のEP有無
                        (setq #CO_old #CO);★前回のｶｳﾝﾀｰ色★
                      )
                    );_if
                  )
                  (progn ;既に2つ以上たまっている
                    (if (= nil #GROUP_1$$)
                      (setq #GROUP_1$$ #GROUP$$)
                      ;else
                      (setq #GROUP_2$$ #GROUP$$)
                    );_if
                    (setq #GROUP$$ nil);ｸﾘｱ
                    (if (= #EP "N")
                      (progn
                        (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                        (setq #DD_old #DD);前回の奥行き
                        (setq #HH_old #HH);前回の高さ(種別)
                        (setq #EP_old #EP);前回のEP有無
                        (setq #CO_old #CO);★前回のｶｳﾝﾀｰ色★
                      )
                    );_if
                  )
                );_if

              )
            );_if
          )
        );_if
        
        (setq #i (1+ #i))
      );foreach
      
      (if (< 1 (length #GROUP$$))
        (progn ;2つ以上たまっている
          (if (= nil #GROUP_1$$)
            (setq #GROUP_1$$ #GROUP$$)
            ;else
            (setq #GROUP_2$$ #GROUP$$)
          );_if
        )
      );_if

    )
  );_if

  ;戻り値
  (list #GROUP_1$$ #GROUP_2$$)
);JOIN_COUNTER_HANTEI2_2

;;;<HOM>*************************************************************************
;;; <関数名>    : JOIN_COUNTER_HANTEI1
;;; <処理概要>  : 収納拡大ｶｳﾝﾀｰ接続処理
;;; <戻り値>    : なし
;;; <作成>      : 2009/12/1 YM ADD
;;;ｶｳﾝﾀｰ接続判定1 列番号が連続するｸﾞﾙｰﾌﾟに分ける(最大5列なので最大2ｸﾞﾙｰﾌﾟ)
;;;例 (1,"A")(2,"A")(4,"A")(5,"A")===>①((1,"A")(2,"A")), ②((4,"A")(5,"A"))
;;;例 (1,"A")(3,"A")(4,"A")(5,"A")===>①((3,"A")(4,"A")(5,"A")), ②(nil)
;;;例 (1,"A")(3,"A")(5,"A")       ===>①(nil)           , ②(nil)
;;;*************************************************************************>MOH<
(defun JOIN_COUNTER_HANTEI1 (
  &info$$
  /
  #GROUP$$ #GROUP_1$$ #GROUP_2$$ #I #NUM #NUM_OLD
  )
  (setq #GROUP$$ nil);仮格納用
  (setq #GROUP_1$$ nil);接続ｶｳﾝﾀｰｸﾞﾙｰﾌﾟ1
  (setq #GROUP_2$$ nil);接続ｶｳﾝﾀｰｸﾞﾙｰﾌﾟ2
  (if (< 1 (length &info$$))
    (progn
      (setq #i 0)
      (setq #num_old nil);前回の列番号
      (foreach #info$ &info$$ ;ｶｳﾝﾀｰ情報
        (setq #num (nth 0 #info$));列番号
        (if (= nil #num_old)
          (progn ;初回
            (setq #GROUP$$ (append #GROUP$$ (list #info$)))
          )
          (progn ;2回目以降
            (if (= #num (1+ #num_old))
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
              )
              (progn
                (if (> 2 (length #GROUP$$))
                  (progn
                    (setq #GROUP$$ nil);ｸﾘｱ
                    (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                  )
                  (progn ;既に2つ以上たまっている
                    (if (= nil #GROUP_1$$)
                      (setq #GROUP_1$$ #GROUP$$)
                      ;else
                      (setq #GROUP_2$$ #GROUP$$)
                    );_if
                    (setq #GROUP$$ nil);ｸﾘｱ
                    (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                  )
                );_if

              )
            );_if
          )
        );_if
        
        (setq #num_old #num);前回番号
        (setq #i (1+ #i))
      );foreach
      
      (if (< 1 (length #GROUP$$))
        (progn ;2つ以上たまっている
          (if (= nil #GROUP_1$$)
            (setq #GROUP_1$$ #GROUP$$)
            ;else
            (setq #GROUP_2$$ #GROUP$$)
          );_if
        )
      );_if

    )
  );_if

  ;戻り値
  (list #GROUP_1$$ #GROUP_2$$)
);JOIN_COUNTER_HANTEI1



;;;<HOM>*************************************************************************
;;; <関数名>    : SD_EXTEND_INSERT_LL
;;; <処理概要>  : 収納拡大プラン挿入(左基準)
;;; <戻り値>    : なし
;;; <作成>      : 2009/11/21 YM ADD
;;; <備考>      : 配置方向　→
;;;*************************************************************************>MOH<
(defun SD_EXTEND_INSERT_LL (
  /
  #MAGU #QRY$ #WW #XX_ALL
  #I #OPEN_BOX_ANG #OPEN_BOX_HIN #OPEN_BOX_LR #OPEN_BOX_X #OPEN_BOX_Y #OPEN_BOX_Z
   #PT #QRY$$ #TURITO_UNDER_OPEN_BOX_FLG #TURITO_UNDER_OPEN_BOX_PT #TURITO_UNDER_OPEN_BOX_X #XX
  )
  ;2009/11/21 YM MOD 収納拡大
  ;左右基準 LL or RR
  ;;;(nth 60 CG_GLOBAL$)
  ;2～5列目間口
  ;;;(nth (+ (* 100 #i) 55) CG_GLOBAL$)
  ;2～5列目有無
  ;;;(nth (+ (* 100 #i) 1) CG_GLOBAL$)
  ;2～5列目EP有無
  ;;;(nth (+ (* 100 #i) 71) CG_GLOBAL$)
  ;最終EP有無
  ;;;(nth 71 CG_GLOBAL$)

  ;①列目　EPがあってもなくても(0,0,0)に配置
  (command "_Insert" (strcat CG_SYSPATH "plan1.dwg") '(0 0 0) 1 1 0)
  (command "_explode" (entlast))

  ;2011/05/09 YM ADD-S 1列目を判定　★★★★★★★★★
  (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
    (progn
      (setq #Turito_Under_Open_Box_FLG nil);トール、大型収納以外が見つかれば T
      ;上台構成　1列目 PLAN161="X"
      (if (/= (nth 161 CG_GLOBAL$) "X")
        (progn
          (setq #Turito_Under_Open_Box_FLG T);トール、大型収納以外が見つかれば T
          (setq #Turito_Under_Open_Box_X 0);確定
        )
      );_if
    )
  );_if
  ;2011/05/09 YM ADD-E 1列目を判定　★★★★★★★★★

  ;②～⑤列目　一つ前の列の間口分だけX方向にずらして配置する
  (setq #XX_ALL 0);累積X座標
  (foreach #i (list 2 3 4 5)
    (if (and (= "Y" (nth (+ (* 100 #i) 1) CG_GLOBAL$))
             (findfile (strcat CG_SYSPATH "plan" (itoa #i) ".dwg")))
      (progn
        (setq #magu (nth (+ (* 100 (1- #i)) 55) CG_GLOBAL$));一列目間口
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "間口"
            (list (list "間口記号" #magu 'STR))
          )
        )
        (setq #WW (nth 2 (car #qry$)))
        (setq #XX_ALL (+ #XX_ALL #WW));間口分X座標を累積させる

        (if (and (/="N" (nth (+ (* 100 (1- #i)) 71) CG_GLOBAL$)) ;前の列でEPなしでないとき
                 (/="X" (nth (+ (* 100 (1- #i)) 71) CG_GLOBAL$)))
          (setq #XX_ALL (+ #XX_ALL CG_EP_THICKNESS));EP厚み(扉ｼﾘｰｽﾞに依存)
        );_if
        (command "_Insert" (strcat CG_SYSPATH "plan" (itoa #i) ".dwg") (list #XX_ALL 0 0) 1 1 0)
        (command "_explode" (entlast))

        ;2011/05/09 YM ADD-S　★★★★★★★★★
        (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
          ;上台構成　PLAN?61="X"
          (if (= nil #Turito_Under_Open_Box_FLG)
            (if (/= (nth (+ (* 100 #i) 61) CG_GLOBAL$) "X")
              (progn
                (setq #Turito_Under_Open_Box_FLG T);トール、大型収納以外が見つかれば T
                (setq #Turito_Under_Open_Box_X #XX_ALL);確定
              )
            );_if
          );_if
        );_if

        ;2011/05/09 YM ADD-E　★★★★★★★★★
      )
    );_if
    (setq #i (1+ #i))
  );foreach

  ;2011/05/09 YM ADD-S　吊戸下OPEN_BOXを配置　★★★★★★★★★
  (if (and #Turito_Under_Open_Box_X (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
    (progn
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "吊戸下OPEN_BOX構成"
          (list (list "PLAN59" (nth 59 CG_GLOBAL$) 'STR))
        )
      )
      (if #qry$$
        (progn
          ;(setq #XX #Turito_Under_Open_Box_X)
          (foreach #qry$ #qry$$
            (setq #Open_Box_hin (nth 3 #qry$))
            (setq #Open_Box_LR  (nth 4 #qry$))
            (setq #Open_Box_X   (nth 5 #qry$))
            (setq #Open_Box_Y   (nth 6 #qry$))
            (setq #Open_Box_Z   (nth 7 #qry$))
            (setq #Open_Box_ANG (nth 8 #qry$))
            ;(setq #XX (+ #XX #Open_Box_X));X座標
            (setq #XX (+ #Turito_Under_Open_Box_X #Open_Box_X));X座標
            (setq #PT (list #XX #Open_Box_Y #Open_Box_Z))
            (TK_PosParts #Open_Box_hin #Open_Box_LR #PT #Open_Box_ANG nil "D")
          )
        )
      );_if
    )
  );_if
  ;2011/05/09 YM ADD-E　吊戸下OPEN_BOXを配置　★★★★★★★★★

  (princ)
);SD_EXTEND_INSERT_LL

;;;<HOM>*************************************************************************
;;; <関数名>    : SD_EXTEND_INSERT_RR
;;; <処理概要>  : 収納拡大プラン挿入(右基準)
;;; <戻り値>    : なし
;;; <作成>      : 2009/11/23 YM ADD
;;; <備考>      : 配置方向　←
;;;*************************************************************************>MOH<
(defun SD_EXTEND_INSERT_RR (
  /
  #MAGU #QRY$ #WW #XX_ALL
  #OPEN_BOX_ANG #OPEN_BOX_HIN #OPEN_BOX_LR #OPEN_BOX_X #OPEN_BOX_Y #OPEN_BOX_Z
  #PT #QRY$$ #QRY_MAGU$ #QRY_ZUKEI$ #TURITO_UNDER_OPEN_BOX_FLG #TURITO_UNDER_OPEN_BOX_X #XX
  )
  ;2009/11/21 YM MOD 収納拡大
  ;左右基準 LL or RR
  ;;;(nth 60 CG_GLOBAL$)
  ;2～5列目間口
  ;;;(nth (+ (* 100 #i) 55) CG_GLOBAL$)
  ;2～5列目有無
  ;;;(nth (+ (* 100 #i) 1) CG_GLOBAL$)
  ;2～5列目EP有無
  ;;;(nth (+ (* 100 #i) 71) CG_GLOBAL$)
  ;最終EP有無
  ;;;(nth 71 CG_GLOBAL$)

  ;①列目 間口分左にずらす
  (setq #XX_ALL 0);累積X座標
  (setq #magu (nth (+ (* 100 1) 55) CG_GLOBAL$));間口
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "間口"
      (list (list "間口記号" #magu 'STR))
    )
  )
  (setq #WW (nth 2 (car #qry$)))
  (setq #XX_ALL (- #XX_ALL #WW));間口分X座標を累積させる

  (command "_Insert" (strcat CG_SYSPATH "plan1.dwg") (list #XX_ALL 0 0) 1 1 0)
  (command "_explode" (entlast))

  ;2011/05/09 YM ADD-S 1列目を判定　★★★★★★★★★
  (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
    (progn
      (setq #Turito_Under_Open_Box_FLG nil);トール、大型収納以外が見つかれば T
      ;上台構成　1列目 PLAN161="X"
      (if (/= (nth 161 CG_GLOBAL$) "X")
        (progn
          (setq #Turito_Under_Open_Box_FLG T);1列目でトール、大型収納以外が見つかれば T
          (setq #Turito_Under_Open_Box_X 0);確定
        )
      );_if
    )
  );_if
  ;2011/05/09 YM ADD-E 1列目を判定　★★★★★★★★★


  ;②～⑤列目　間口分だけX軸ﾏｲﾅｽ方向にずらして配置する
  (foreach #i (list 2 3 4 5)
    (if (and (= "Y" (nth (+ (* 100 #i) 1) CG_GLOBAL$))
             (findfile (strcat CG_SYSPATH "plan" (itoa #i) ".dwg")))
      (progn
        (setq #magu (nth (+ (* 100 #i) 55) CG_GLOBAL$));間口
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "間口"
            (list (list "間口記号" #magu 'STR))
          )
        )
        (setq #WW (nth 2 (car #qry$)))
        (setq #XX_ALL (- #XX_ALL #WW));間口分X座標を累積させる

        (if (and (/="N" (nth (+ (* 100 (1- #i)) 71) CG_GLOBAL$));EPなしでないとき
                 (/="X" (nth (+ (* 100 (1- #i)) 71) CG_GLOBAL$)))
          (setq #XX_ALL (- #XX_ALL CG_EP_THICKNESS));EP厚み(扉ｼﾘｰｽﾞに依存)
        );_if
        (command "_Insert" (strcat CG_SYSPATH "plan" (itoa #i) ".dwg") (list #XX_ALL 0 0) 1 1 0)
        (command "_explode" (entlast))

        ;2011/05/09 YM ADD-S　★★★★★★★★★
        (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
          ;上台構成　PLAN?61="X"
          (if (= nil #Turito_Under_Open_Box_FLG)
            (if (/= (nth (+ (* 100 #i) 61) CG_GLOBAL$) "X")
              (progn
                (setq #Turito_Under_Open_Box_FLG T);トール、大型収納以外が見つかれば T
                (setq #Turito_Under_Open_Box_X (+ #XX_ALL #WW ));確定右端点(間口分は引き過ぎなので加える)
              )
            );_if
          );_if
        );_if
        ;2011/05/09 YM ADD-E　★★★★★★★★★

      )
    );_if
    (setq #i (1+ #i))
  );foreach

  ;2011/05/09 YM ADD-S　吊戸下OPEN_BOXを配置　★★★★★★★★★
  (if (and #Turito_Under_Open_Box_X (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
    (progn
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "吊戸下OPEN_BOX構成"
          (list (list "PLAN59" (nth 59 CG_GLOBAL$) 'STR))
        )
      )
      (if #qry$$
        (progn
          (setq #XX #Turito_Under_Open_Box_X);右端点
          (foreach #qry$ #qry$$
            (setq #Open_Box_hin (nth 3 #qry$))
            (setq #Open_Box_LR  (nth 4 #qry$))
            (setq #Open_Box_X   (nth 5 #qry$))
            (setq #Open_Box_Y   (nth 6 #qry$))
            (setq #Open_Box_Z   (nth 7 #qry$))
            (setq #Open_Box_ANG (nth 8 #qry$))

            (setq #qry_zukei$
              (CFGetDBSQLRec CG_DBSESSION "品番図形"
                (list (list "品番名称" #Open_Box_hin 'STR))
              )
            )
            (setq #WW (nth 3 (car #qry_zukei$)));W値

            (setq #XX (- #XX #WW));X座標
            (setq #PT (list #XX #Open_Box_Y #Open_Box_Z))
            (TK_PosParts #Open_Box_hin #Open_Box_LR #PT #Open_Box_ANG nil "D")
          )
        )
      );_if
    )
  );_if
  ;2011/05/09 YM ADD-E　吊戸下OPEN_BOXを配置　★★★★★★★★★

  (princ)
);SD_EXTEND_INSERT_RR

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetWTLeftUpPT
;;; <処理概要>  : 挿入後のプラン検索WT左上点を求める
;;; <戻り値>    : WT左上点座標
;;; <作成>      : 00/09/06 YM 09/11 MOD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKGetWTLeftUpPT (
  &inspt ; 挿入点
  &ang   ; 挿入角度
  &WTPT  ; ﾌﾟﾗﾝ作成時のWT左上点
  /
  #ANG #DIST #PT
  )
;;; 収納部 *:挿入点位置(0,0)
;;;        P:WT左上点(&WTPT)
;;;   +-----------P--------------------------+
;;;   *-----------+--------------------------+
;;;   |           |                          |
;;;   |           |                          |
;;;   |           |                          |
;;;   +-----------+--------------------------+

  (setq #dist (distance '(0 0) &WTPT)) ; 距離
  (setq #ang  (angle '(0 0) &WTPT))    ; 角度
  (setq #pt   (polar &inspt (+ &ang #ang) #dist)) ; 新しいWT左上点
  #pt
);PKGetWTLeftUpPT

;;;<HOM>*************************************************************************
;;; <関数名>    : PC_LayoutPlanExec
;;; <処理概要>  : プラン検索処理を実行
;;; <戻り値>    : なし
;;; <作成>      :
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PC_LayoutPlanExec (
  /
  #family$$ #NEW_SYM_PT
  )

  ;//---------------------------------------------------------
  ;// 作図画面の各種設定
  ;//---------------------------------------------------------
  (command "_zoom" "w" (list -3000 -2000) (list 3000 0))
  (command "VIEW" "S" "INIT")

  ;// 拡張データアプリケーション名を登録
  (princ "\n---拡張データアプリケーション名を登録---")
  (regapp "G_SYM")
  (regapp "G_LSYM")
  ;2009/11/30 YM ADD
  (regapp "G_COUNTER")
  (princ "\n---11111拡張データアプリケーション名を登録---")
  (regapp "G_ARW")
  (princ "\n---22222拡張データアプリケーション名を登録---")
  (regapp "G_OPT")
  (princ "\n---33333拡張データアプリケーション名を登録---")
;;;(makeERR "8-1") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8-1
  ;// ｼｽﾃﾑ変数初期化
  (princ "\n--- ｼｽﾃﾑ変数初期化---")
  (setvar "LISPINIT"  0)     ;Lisp変数を初期化しない
  (setvar "CMDECHO"   0)     ;ｺﾏﾝﾄﾞｴｺｰOFF
  (setvar "EXPERT"    4)     ;上書き確認の制御
  (if (= "ACAD" CG_PROGRAM)
    (setvar "MENUCTL"   0)     ;ﾒﾆｭｰｺﾝﾄﾛｰﾙ
  )
  ;(setvar "PDMODE"    34)    ;点表示ﾓｰﾄﾞ
  (setvar "PDMODE"    0)     ;点表示ﾓｰﾄﾞ
  (setvar "HPSCALE"   10)    ;ﾊｯﾁﾝｸﾞｽｹｰﾙ
  (setvar "LTSCALE"   15)    ;線種ｽｹｰﾙ
  (setvar "PICKSTYLE" 0)     ;グループ選択モードOFF
  (setvar "OSMODE"    0)
  (if (or (= "18" CG_ACADVER)(= "19" CG_ACADVER)(= "23" CG_ACADVER));2020/01/29 YM ADD
		(progn
	    (setvar "3DOSMODE"  1) ;2011/06/30 YM ADD
			(setvar "UCSDETECT" 0) ;ダイナミック UCS をアクティブにしない 2011/10/11 YM ADD
		)
  );_if
  (setvar "SNAPMODE"  0)

  ;// プラン検索ダイアログにて出力された情報を取得する
  (princ "\n--- プラン検索ダイアログにて出力された情報を取得する---")
  (cond
    ((= CG_AUTOMODE 3) ; Web版LOCAL CAD端末ﾓｰﾄﾞ #family$$="Input.cfg"とする; 02/08/05 YM ADD-S
      (setq CG_DATFILE      (cadr (assoc "DATFILE" CG_PLANINFO$)))     ; DATﾌｧｲﾙ名(Input.cfg) Planinfo.dfg
      (setq CG_DOWNLOADPATH (cadr (assoc "DOWNLOADPATH" CG_INIINFO$))) ; 共通ＤＢ名称 KS ADD Kenmei.cfg
      (setq CG_INPUTINFO$ (ReadIniFile (strcat CG_DOWNLOADPATH CG_DATFILE)))
      (WebSetGlobal)   ; ﾌｧﾐﾘｰｺｰﾄﾞからﾌﾟﾗﾝ検索に必要なｸﾞﾛｰﾊﾞﾙをｾｯﾄする CG_PlanType が決定する
      (setq #family$$ CG_INPUTINFO$)
    )
    ((= CG_AUTOMODE 2) ; Web版CADｻｰﾊﾞｰﾓｰﾄﾞ #family$$="Input.cfg"とする
      (setq #family$$ CG_INPUTINFO$) ; 02/07/31 YM DEL 既に CG_PlanType が決定
      (princ "\n---この時点でｸﾞﾛｰﾊﾞﾙｾｯﾄ済み---")
      nil ; この時点でｸﾞﾛｰﾊﾞﾙｾｯﾄ済み
    )
    ;★★★ "SRCPLN.CFG" Read
    (T 
      ; 今まで(通常 or ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ)
      (if (= CG_TESTMODE 1)
        (progn ; ﾃｽﾄﾓｰﾄﾞ
          (setq #family$$ (ReadIniFile (strcat CG_SYSPATH "Srcpln" "_" CG_SeriesDB "_" (itoa CG_TESTCASE) ".cfg")));07/05/11 YM ADD
        )
        (progn ; 通常ﾓｰﾄﾞ & 自動ﾓｰﾄﾞ
          (setq #family$$ (ReadIniFile (strcat CG_SYSPATH "SRCPLN.CFG")))
        )
      );_if

      (setq CG_PlanType (cadr (assoc "PLANTYPE" #family$$))) ; "SK","SD"

    )
  );_cond

  (princ "\n---ｴﾗｰ関数定義---")
  (WebDefErrFunc) ; ｴﾗｰ関数定義(02/09/11 YM 関数化)
  (WebOutLog "ｴﾗｰ関数 SKAutoError2 を定義しました(PC_LayoutPlanExec)")
  (WebOutLog " ")
  (WebOutLog "SK==>PK_StartLayout or SD==>PD_StartLayout などで分岐(PC_LayoutPlanExec)")

  (cond
    ((= CG_PlanType "SK") ; WEB版キッチンはここを通る
      (princ "\nWEB版キッチンはここを通る---")
      (PK_StartLayout #family$$)
    )
    ((= CG_PlanType "SD") ; WEB版収納部はここを通る
      (cond
        ;((= CG_SeriesDB "SDA") ;2011/02/01 YM MOD【PG分岐】
        ((= BU_CODE_0004 "1")
          (princ "\nSDA 従来収納ﾛｼﾞｯｸ---")
          (PD_StartLayout        #family$$);SDA 従来収納ﾛｼﾞｯｸ
        )
        ;((= CG_SeriesDB "SDB") ;2011/02/01 YM MOD【PG分岐】
        ((= BU_CODE_0004 "2")
          ;2009/11/18 YM 収納拡大
          (princ "\nSDB 収納拡大---")
          (PD_StartLayout_EXTEND #family$$);SDB
        )
        (T ;SDC以降
          (PD_StartLayout_EXTEND #family$$);SDB以降
        )
      );_cond
        
    )
    ((= CG_PlanType "WF")
      (WF_StartLayout #family$$)
    )
    (T ; CG_PlanType=nil
      (setq CG_PlanType "SK")
      (PK_StartLayout #family$$)
    )
  );_cond


  (WebOutLog "ﾋﾞｭｰを戻して表示画層の設定を行います"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  ;// ビューを元に戻す
  (princ "\nビューを元に戻す START")
  (command "VIEW" "R" "INIT")
  (princ "\nビューを元に戻す END")
  ;// 表示画層の設定
  (princ "\n表示画層の設定")
  (SetLayer);03/09/29 YM MOD

  (princ)
);PC_LayoutPlanExec

;<HOM>*************************************************************************
; <関数名>     : PKGetPMEN_NO_LIST
; <処理概要>   : ｼﾝｸｼﾝﾎﾞﾙ図形,PMEN番号を渡してPMEN(&NO)図形名を得る
; <戻り値>     : PMEN(&NO)図形名
; <作成>       : 00/05/04 YM
; <備考>       : 2017/10/04 YM ADD PMENを全部返す
;*************************************************************************>MOH<
(defun PKGetPMEN_NO_LIST (
  &scab-en   ;(ENAME)ｷｬﾋﾞｼﾝﾎﾞﾙ図形
  &NO        ;PMEN の番号
  /
  #EN #I #MSG #pmen$ #S-XD$ #SS #XD$ #LOOP #NAME
  )
  (cond
    ((= &NO 1)(setq #NAME "(隠線領域)"))
    ((= &NO 2)(setq #NAME "(外形領域)"))
    ((= &NO 3)(setq #NAME "(特殊ｶｳﾝﾀｰ領域)"))
    ((= &NO 4)(setq #NAME "(ｼﾝｸ穴領域)"))
    ((= &NO 5)(setq #NAME "(ｺﾝﾛ穴領域)"))
    ((= &NO 6)(setq #NAME "(干渉ﾁｪｯｸ領域)"))
    ((= &NO 7)(setq #NAME "(正面用扉領域)"))
    ((= &NO 8)(setq #NAME "(ｼﾝｸ取付領域)"))
    (T (setq #NAME ""))
  );_cond
  (setq #ss (CFGetSameGroupSS &scab-en))
  (setq #i 0)
  (setq #pmen$ nil)
  (while (< #i (sslength #ss))
    (setq #en (ssname #ss #i))
    (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
    (if #xd$
      (progn
        (if (= &NO (car #xd$))
          (progn
            (setq #pmen$ (append #pmen$ (list #en)))
          )
        );_if
      )
    );_(if
    (setq #i (1+ #i))
  )
  #pmen$
);PKGetPMEN_NO_LIST

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetCounterGaikeiPT
;;; <処理概要>  : ｶｳﾝﾀｰ平面外形領域の点列を取得
;;; <戻り値>    : 点列リスト
;;; <作成>      : 2017/10/04 YM ADD
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PKGetCounterGaikeiPT (
  /
	#I #LAYER #PMEN1 #PTA$ #SS #SYM #pmen1$
  )
	(setq #ptALL$ nil)
	(setq #ptRET$ nil);戻り値

	(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
	(setq #i 0)
	(if (and #ss (< 0 (sslength #ss)))
    (while (< #i (sslength #ss))
      (setq #sym (ssname #ss #i))
      (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CNT) ; 性格ｺｰﾄﾞ1桁=7 ｶｳﾝﾀｰ
				(progn
					(setq #pmen1$ (PKGetPMEN_NO_LIST #sym 1)) ;ｶｳﾝﾀｰ
					(setq #loop T)
					(foreach #pmen1 #pmen1$
						(setq #layer (cdr (assoc 8 (entget #pmen1))));画層
						(if (and #loop (= (substr #layer 1 4) "Z_01")) ;平面画層
							(progn
							  (setq #pt$ (GetLWPolyLinePt #pmen1))     ; PMEN1 隠線領域点列をすべて累積させる
								(setq #ptALL$ (append #ptALL$ #pt$))
								(setq #loop nil)
							)
						);_if
					);foreach
				)
      );_if
      (setq #i (1+ #i))
    );while
	);_if

	(setq #XMIN 999999)
	(setq #YMIN 999999)
	(setq #XMAX -999999)
	(setq #YMAX -999999)
	(foreach #pt #ptALL$
		(setq #XX (nth 0 #pt))
		(setq #YY (nth 1 #pt))
		(if (<= #XX #XMIN)(setq #XMIN #XX))
		(if (>= #XX #XMAX)(setq #XMAX #XX))
		(if (<= #YY #YMIN)(setq #YMIN #YY))
		(if (>= #YY #YMAX)(setq #YMAX #YY))
	)
	(setq #ptRET$ (list (list #XMIN #YMAX)(list #XMAX #YMAX)(list #XMAX #YMIN)(list #XMIN #YMIN) ))
	#ptRET$
);PKGetCounterGaikeiPT


;;;<HOM>*************************************************************************
;;; <関数名>    : PK_StartLayout
;;; <処理概要>  : キッチンを自動ﾚｲｱｳﾄする
;;; <戻り値>    :
;;; <作成>      : 2000.1.19修正KPCAD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PK_StartLayout (
  &family$$
  /
  #EN$ #I #SS #VIEWEN #QRY$ #SINA_TYPE
  #DDD #LR #P1 #P2 #P3 #P4 #PE #PS #PT$ #SS_P_HOOD #WT #WWW #XD_P_HOOD$ ;2010/11/10 YM ADD
  #IP_HOOD_DIST #PP_HOOD_DIST ;2010/11/10 YM ADD
  )
  (WebOutLog "ｷｯﾁﾝを自動ﾚｲｱｳﾄします(PK_StartLayout)")

  (WebDefErrFunc) ; ｴﾗｰ関数定義(02/09/11 YM 関数化)
  (WebOutLog "ｴﾗｰ関数 SKAutoError2 を定義しました(PK_StartLayout)")

  (setq CG_PROGMSG "特性値の取得中")

  (if (or (= CG_AUTOMODE 2)(= CG_AUTOMODE 3))
    (progn ; WEB版CADｻｰﾊﾞｰ&LOCAL端末
      nil
;;;     ; 天井ﾌｨﾗｰ,ｻｲﾄﾞﾊﾟﾈﾙ
;;;     (WEB_SetFilPanelCode) ; Web版CADｻｰﾊﾞｰﾓｰﾄﾞ
      (WebOutLog "CADｻｰﾊﾞｰ自動作図はｸﾞﾛｰﾊﾞﾙ変数のｾｯﾄをしない(PK_StartLayout)")
    )
    (progn
      ;グローバル変数のセット
      (PKG_SetFamilyCode &family$$) ; <Pcsetfam.lsp>
      (SKChgView "2,-2,1")
      (command "_zoom" "e")
    )
  );_if

  ;//---------------------------------------------------------
  ;// 構成部材自動配置
  ;//    本処理内でキャビネット等のレイアウトを行う
  ;//---------------------------------------------------------
  (setq CG_PROGMSG "部材の自動展開中")

  (WebOutLog "--- (PKC_ModelLayout)を呼ぶ ---")

  (PKC_ModelLayout)
  (command "_layer" "T" "*" "")

  (WebDefErrFunc) ; ｴﾗｰ関数定義(02/09/11 YM 関数化)


  ;// 天板自動生成
	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn ;2017/09/07 YM ADD
			nil
		)
		(progn
		  (WebOutLog "--- 天板自動生成(PKW_WorkTop)を呼ぶ ---")
		  (setq #WT (PKW_WorkTop));2010/11/10 YM ADD WT図形を返す
		)
	);_if

	;2017/10/11 YM ADD-S 水栓の配置
  (if (= "N" (nth 18 CG_GLOBAL$));水栓穴なしではないとき
    (progn
      ;2009/02/06 YM ADD
      (princ "水栓穴なしのため、水栓を配置しませんでした")
    )
    (progn ; 従来ﾛｼﾞｯｸ [主水栓の配置]

			(FK_PosWTR_plan);            (nth 19
		)
	);_if


  (if (and (=  "B" (nth 18 CG_GLOBAL$)) ;水栓2穴のとき
           (/= "_" (nth 19 CG_GLOBAL$)));水栓2穴あり
    (progn ; [水栓2穴の配置]
			(FK_PosWTR_plan2);浄水器配置 (nth 22
		)
	);_if
	;2017/10/11 YM ADD-E 水栓の配置


  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;2010/11/10 YM ADD-S 新ｽｲｰｼﾞｨ 対面ﾌｰﾄﾞ配置位置を自動的に求める
  ;天板前面が基準なので天板作図まで確定できない(0,0)に配置したﾌｰﾄﾞを正しく移動する

  ;I型時のP型フード配置情報 
  ; 一律：40mm（天板前面からの距離）

  ;P型時のP型フード配置情報 
  ; 一律：20mm（天板前面からの距離）

  (if (and CG_HOOD_FLG CG_P_HOOD_SYM)
    (progn ;P型ﾌｰﾄﾞはとりあえず原点配置している
      ;P型HOOD位置を正しく移動する
      
      ;P型でP型ﾌｰﾄﾞ天板前面からの距離
      (setq #PP_HOOD_DIST 20.0)
      ;I型でP型ﾌｰﾄﾞ天板前面からの距離
;;;     (setq #IP_HOOD_DIST 40.0)
      (setq #IP_HOOD_DIST 20.0)

			
			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
				(progn ;2017/09/07 YM ADD
					(setq #pt$ (PKGetCounterGaikeiPT))
				)
				(progn
		      ;天板外形点列を取得
		      (setq #pt$ (GetWT_MigiShitaPt #WT))
				)
			);_if

      (setq #p1 (nth 0 #pt$));左上
      (setq #p2 (nth 1 #pt$));右上
      (setq #p3 (nth 2 #pt$));右下
      (setq #p4 (nth 3 #pt$));左下

			;2017/07/04 YM ADD L型に必要
      (setq #p5 (nth 4 #pt$))
      (setq #p6 (nth 5 #pt$))

      ;P型ﾌｰﾄﾞの基点位置
      (setq #PS (cdr (assoc 10 (entget CG_P_HOOD_SYM))))
      (setq #PE nil)
       
      ;P型ﾌｰﾄﾞのｻｲｽﾞ CG_P_HOOD_SYM(反転したら変化する)
      (setq #xd_P_HOOD$ (CFGetXData CG_P_HOOD_SYM "G_SYM"))
      (setq #WWW (nth 3 #xd_P_HOOD$));W
      (setq #DDD (nth 4 #xd_P_HOOD$));D

      ;P型ﾌｰﾄﾞ全図形
      (setq #ss_P_HOOD (CFGetSameGroupSS CG_P_HOOD_SYM))

      ;左右勝手
      (setq #LR (nth 11 CG_GLOBAL$))
      (cond
        ((= #LR "L");左勝手

          (cond
            ((= CG_HOOD_FLG "PI")
              ;ﾍﾞｰｽｷｬﾋﾞと同じﾗｲﾝに移動
              (setq #PE
                (list
                  (- (nth 0 #p3) #WWW)
                  0.0
                  (nth 2 #PS) ;ﾌｰﾄﾞのZ座標
                )
              )
            )
            ((= CG_HOOD_FLG "PP")
              ;WT右下(手前)からY方向に20mm＋(ﾌｰﾄﾞ寸法W値分)の位置に移動
              (setq #PE
                (list
                  (nth 0 #p3)
                  (+ (nth 1 #p3) #PP_HOOD_DIST #WWW)
                  (nth 2 #PS) ;ﾌｰﾄﾞのZ座標
                )
              )
            )
            ((= CG_HOOD_FLG "IP")
              ;WT右下(手前)からY方向に40mm＋(ﾌｰﾄﾞ寸法W値分)の位置に移動
              (setq #PE
                (list
                  (nth 0 #p3)
                  (+ (nth 1 #p3) #IP_HOOD_DIST #WWW)
                  (nth 2 #PS) ;ﾌｰﾄﾞのZ座標
                )
              )
            )

						;2017/07/05 YM ADD-S
;   -----------------+ p1
;                    |
;                    |
;          --+       |
;            |       |
;            |       |
;            |       |
;            |       |
;         p3 +-------+ p2

            ((= CG_HOOD_FLG "LP") ;L型
              ;WT右下(手前)からY方向に40mm＋(ﾌｰﾄﾞ寸法W値分)の位置に移動
              (setq #PE
                (list
                  (nth 0 #p2)
                  (nth 1 #p2)
                  (nth 2 #PS) ;ﾌｰﾄﾞのZ座標
                )
              )
            )
						;2017/07/05 YM ADD-E

          );_cond

        )
        ((= #LR "R");右勝手

          (cond
            ((= CG_HOOD_FLG "PI")
              ;ﾍﾞｰｽｷｬﾋﾞと同じﾗｲﾝに移動
              (setq #PE
                (list
                  (nth 0 #p4)
                  0.0
                  (nth 2 #PS) ;ﾌｰﾄﾞのZ座標
                )
              )
            )
            ((= CG_HOOD_FLG "PP")
              ;WT左下(手前)からY方向に20mmの位置に移動
              (setq #PE
                (list
                  (nth 0 #p4)
                  (+ (nth 1 #p4) #PP_HOOD_DIST)
                  (nth 2 #PS) ;ﾌｰﾄﾞのZ座標
                )
              )
            )
            ((= CG_HOOD_FLG "IP")
              ;WT左下(手前)からY方向に40mmの位置に移動
              (setq #PE
                (list
                  (nth 0 #p4)
                  (+ (nth 1 #p4) #IP_HOOD_DIST)
                  (nth 2 #PS) ;ﾌｰﾄﾞのZ座標
                )
              )
            )

						;2017/07/05 YM ADD-S
;            +-----------------+ p1
;            |                 |
;            |                 |
;            |       +---------+ p2
;            |       |
;            |       |
;            |       |
;           @+-------+
;          p5        p4

            ((= CG_HOOD_FLG "LP") ;L型
              ;WT右下(手前)からY方向に40mm＋(ﾌｰﾄﾞ寸法W値分)の位置に移動
              (setq #PE
                (list
                  (nth 0 #p5)
                  (nth 1 #p5)
                  (nth 2 #PS) ;ﾌｰﾄﾞのZ座標
                )
              )
            )

						;2017/07/05 YM ADD-E

          );_cond

        )
      );_cond


      (if #PE
				(progn
        	(command "_move" #ss_P_HOOD "" #PS #PE)
					;2014/10/21 YM ADD 移動したのでXdataを更新
					(setq #xdLSYM$ (CFGetXData CG_P_HOOD_SYM "G_LSYM"))
					(CFSetXData CG_P_HOOD_SYM "G_LSYM"
						(CFModList #xdLSYM$
							(list
								(list 1 #PE)
							)
						)
					)
					;2014/10/21 YM ADD 移動したのでXdataを更新
				)
      );_if


    )
  );_if

;;; (setq CG_HOOD_FLG nil) ;矢視領域の自動作成でﾌﾗｸﾞが必要 2010/11/18 YM DEL
  (setq CG_P_HOOD_SYM nil)
  ;2010/11/10 YM ADD-E 新ｽｲｰｼﾞｨ
  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


  
  ;// 天井ﾌｨﾗｰの作成
  (if (and (/= (nth 46 CG_GLOBAL$) "N")(/= (nth 46 CG_GLOBAL$) "X"));天井ﾌｨﾗｰ取付ける
    (progn
      (WebOutLog "--- 天井ﾌｨﾗｰの作成(PKW_UpperFiller)を呼ぶ ---")
      ;2009/11/21 YM ADD ｷｯﾁﾝは前だけ
      (setq SKW_FILLER_LSIDE 0)
      (setq SKW_FILLER_RSIDE 0)
      (setq SKW_FILLER_BSIDE 0)

      (PKW_UpperFiller);現在天井ﾌｨﾗｰ="A"のみ
    )
  );_if



  ;2011/03/25 YM ADD-S OP置換の仕組みを導入
  ;引数"GO"=足温、引出しﾕﾆｯﾄﾜｺﾞﾝの配置有効、"STOP"=足温、引出しﾕﾆｯﾄﾜｺﾞﾝの配置無効 を追加
  (KP_ChgCab)  ;新ﾛｼﾞｯｸ 性格ｺｰﾄﾞに依存しない
  (WebOutLog "--- (PK_StartLayout)から出る ---")

  (princ)
);PK_StartLayout


;;;<HOM>*************************************************************************
;;; <関数名>    : KP_ChgCab
;;; <処理概要>  : 【OP置換収納】新ﾛｼﾞｯｸ
;;; <戻り値>    :
;;; <作成>      : 2011/03/25 YM ADD
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun KP_ChgCab  (
  /
  #EN #I #INSEN #INSHIN #INSLR #INSPOINT #INSRAD #J #JOKEN #LST$ #N #OPQRY$ #QRY$
  #QRYJOKEN$$ #QRYZU$ #RECNO #SKK #SQL$ #SS #SYM #WIDE #XD$ #XD$1 #XD_NEW$
#sRad ; 2011/04/06 YM ADD
  )


  ;[OP置換収納条件]の全検索
  (setq #qryJOKEN$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "OP置換条件")))

  ;CAD図面上の全図形を検索
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
    
  (if (/= #ss nil)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #sql$ nil #qry$ nil #lst$ nil)
        (setq #en (ssname #ss #i))
        ;// 拡張データを取得
        (setq #xd$ (CFGetXData #en "G_LSYM"))
        ;// 性格コード
        (setq #SKK (nth 9 #xd$))
        (setq #recno (nth 11 #xd$))
      
        (setq #xd$1 (CFGetXData #en "G_SYM"))
        (setq #Wide     (nth 3 #xd$1))
        (setq #InsEN    #en)            ;キャビネット図形
        (setq #InsPoint (nth 1 #xd$))   ;キャビネット挿入起点
        (setq #InsRad   (nth 2 #xd$))   ;キャビネット挿入角度
        (setq #InsHin   (nth 5 #xd$))   ;キャビネット品番
        (setq #InsLR    (nth 6 #xd$))   ;キャビネットLR区分

        ;各条件ﾊﾟﾀｰﾝで検索
        (setq #j 1)
        (foreach #qryJOKEN$ #qryJOKEN$$


          (setq #sql$
            (list
              (list "対象品番"   #InsHin          'STR)
              (list "対象品番LR" #InsLR           'STR)
            )
          )

          (setq #n 1)

          (repeat 7
            (setq #joken (nth #n #qryJOKEN$))

            (if (/= #joken "SK___")
              (progn ;条件が存在すれば追加していく

;;;2016/04/18 YM MOD-S
(setq #tokusei (nth (atoi (substr #joken 5 4)) CG_GLOBAL$));nilを避けるため
(if (= #tokusei nil)(setq #tokusei ""))

                (setq #sql$
                  (append #sql$
                    (list
                      (list (strcat "特性ID" (itoa #n))  #joken    'STR)
                      (list (strcat "特性値" (itoa #n))  #tokusei  'STR)
                    )
                  )
                )
              )
            );_if
            (setq #n (1+ #n))
          );repeat



          ;sql完成→[OP置換収納]検索
          (setq #OPqry$ (CFGetDBSQLRec CG_DBSESSION "OP置換" #sql$))

          
          ;検索結果
          (if (= (length #OPqry$) 1)
            (progn  ;検索結果が1件の場合のみ処理継続
              (setq #OPqry$ (car #OPqry$))
              (setq #lst$ (list (nth 3 #OPqry$) (nth 4 #OPqry$)))
            )
            (progn
              (setq #lst$ nil)
            )
          );_if


          ; 元部材削除/入替部材配置処理
          (if (/= #lst$ nil)
            (progn
              (SCY_DelParts #InsEN nil)

              (setq #sql$
                (list
                  (list "品番名称" (car  #lst$) 'STR)
                  (list "LR区分"   (cadr #lst$) 'STR)
                )
              );_setq

              (setq #qryZU$ (CFGetDBSQLHinbanTable "品番図形" (car  #lst$) #sql$))

              (if (= (length #qryZU$) 1);検索結果が1件の場合処理実行
                (progn
                  (setq #qryZU$ (car #qryZU$))

                  ;配置
                  ;2011/04/06 YM ADD
                  (setq #sRad (angtos #InsRad (getvar "AUNITS") CG_OUTAUPREC))
;-- 2011/12/22 A.Satoh Mod - S
;;;;;                  (setq #sym (TK_PosParts (nth 0 #qryZU$) (nth 1 #qryZU$) #InsPoint #sRad nil (GetBunruiAorD)));2011/07/04 YM ADD 分類追加
                  (setq #sym (TK_PosParts2 (nth 0 #qryZU$) (nth 1 #qryZU$) #InsPoint #sRad nil (GetBunruiAorD)));2011/07/04 YM ADD 分類追加
;-- 2011/12/22 A.Satoh Mod - E
                  
                  ;2010/06/28 YM ADD-S 調理ｷｬﾋﾞ入替時に"G_LSYM"[12]の内容が消えるので引き出しﾕﾆｯﾄに変更できない
                  ;[12]:配置順番号    :配置順番号(1～)           (1070 . 19)
                  ;(setq #recno (nth 11 #xd$))を反映する
                  ;// 拡張データを取得
                  (setq #xd_new$ (CFGetXData #sym "G_LSYM"))
                  (setq #xd_new$
                    (CFModList #xd_new$
                      (list
                        (list 11 #recno)
                      )
                    )
                  )
                  (CFSetXData #sym "G_LSYM" #xd_new$)
                  ;2010/06/28 YM ADD-E 調理ｷｬﾋﾞ入替時に"G_LSYM"[12]の内容が消えるので引き出しﾕﾆｯﾄに変更できない


                  ;;拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ
                  (KcSetG_OPT #sym)
                )
              );if
            )
          );_if

        
;-- 2011/12/22 A.Satoh Del - S
;          ;扉貼付け
;          (if (and (/= #lst$ nil) (/= #sym nil))
;              (PCD_MakeViewAlignDoor (list #sym) 3 nil)
;          );_if
;-- 2011/12/22 A.Satoh Add - E


          (setq #j (1+ #j));検索ﾊﾟﾀｰﾝのﾙｰﾌﾟ
        );foreach


        (setq #i (1+ #i));部材のﾙｰﾌﾟ
      );repeat
    )
  );if

  (princ "\nEND")
  (princ)
);KP_ChgCab


;;;<HOM>*************************************************************************
;;; <関数名>    : GetBunruiAorD
;;; <処理概要>  : ﾌﾟﾗﾝ検索中にｷｯﾁﾝ"A" or 収納"D"を取得する
;;; <戻り値>    :"A" or "D"
;;; <作成>      : 2011/07/04 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun GetBunruiAorD ( / #BUNRUI)
  (setq #bunrui "")
  (cond
    ((= CG_PlanType "SK")
      (setq #bunrui "A")
    )
    ((= CG_PlanType "SD")
      (setq #bunrui "D")
    )
    (T
     (setq #bunrui "")
    )
  );_cond
  #bunrui
);GetBunruiAorD

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_GLASS_PARTISYON
;;; <処理概要>  : ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝの配置
;;; <戻り値>    :
;;; <作成>      : 2009/10/26 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKW_GLASS_PARTISYON (
  /
  #ANG #GLASS$$ #HNO #LR #XX #YY #ZZ #glass
  )
  ;2009/12/11 YM ADD nilで落ちる対策
  (setq #glass (nth 44 CG_GLOBAL$))
  (if (= nil #glass)(setq #glass ""))
  
  ;[ガラスパティション]を検索
  (setq #GLASS$$
    (CFGetDBSQLRec CG_DBSESSION "ガラスパティション"
       (list
        (list "記号"          #glass              'STR);ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝ記号
        (list "シンク側間口"  (nth  4 CG_GLOBAL$) 'STR)
        (list "奥行き"        (nth  7 CG_GLOBAL$) 'STR)
        (list "天板高さ"      (nth 31 CG_GLOBAL$) 'STR)
        (list "シンク記号"    (nth 17 CG_GLOBAL$) 'STR)
       )
    )
  )
  (if (and #GLASS$$ (= 1 (length #GLASS$$)) )
    (progn ;1件HITした
      (setq #GLASS$$ (car #GLASS$$))
      (setq #HNO (nth  5 #GLASS$$));品番名称
      (setq #LR  (nth  6 #GLASS$$));LR区分
      (setq #XX  (nth  7 #GLASS$$))
      (setq #YY  (nth  8 #GLASS$$))
      (setq #ZZ  (nth  9 #GLASS$$))
      (setq #ANG (nth 10 #GLASS$$))
      ;配置
      (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
    )
    (progn
      nil ;何もしない
    )
  );_if
  (princ)
);PKW_GLASS_PARTISYON


;;;<HOM>*************************************************************************
;;; <関数名>    : KP_PutEndPanel
;;; <処理概要>  : ﾌﾟﾗﾝ検索ｴﾝﾄﾞﾊﾟﾈﾙ取付け <ｷｯﾁﾝ用>
;;; <戻り値>    :
;;; <作成>      : 2008/072/26 YM 関数化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_PutEndPanel (
  /
  #ANG #BLK$ #DB_NAME1 #DB_NAME2 #HNO #HUKU_ID #LIST$$ #LR #PANEL_QRY$$ #QRY$
  #T$ #T$$ #TTT #XX #YY #ZZ #RECNO
#TOP_F ;2010/11/08 YM ADD
  )

;(nth 45 CG_GLOBAL$);ｴﾝﾄﾞﾊﾟﾈﾙ

;;;X  -----
;;;N  取付けない
;;;A  シンク側のみ
;;;B  コンロ側のみ
;;;C  両側取付け

  ;2008/09/24 YM MOD [パネル管理][パネル構成]ﾃｰﾌﾞﾙ構造変更 品番のみ取得。配置位置はPG計算
  (if (or (= (nth 45 CG_GLOBAL$) "A")(= (nth 45 CG_GLOBAL$) "B")(= (nth 45 CG_GLOBAL$) "C"))
    (progn
      
      (setq #DB_NAME1 "パネル管理")
      (setq #DB_NAME2 "パネル構成")

      (setq #T$$ ; I型,L型のとき
        (CFGetDBSQLRec CG_DBSESSION "パネル厚み"
          (list
            (list "扉シリ記号"     (nth 12 CG_GLOBAL$) 'STR)
            (list "扉カラ記号"     (nth 13 CG_GLOBAL$) 'STR)
          )
        )
      )
      (setq #T$ (DBCheck #T$$ "『パネル厚み』" "KP_PutEndPanel"))
      (setq #TTT (nth 2 #T$));EP厚み


      ;2010/11/08 YM ADD-S
      ;新ｽｲｰｼﾞｨ対応ﾄｯﾌﾟ勝ち判定を検索
      ;CG_GLOBAL$=nilでないときしかﾀﾞﾒ
      (setq #TOP_F (GetTopFlg))
      ;2010/11/08 YM ADD-E

      
      (setq #LIST$$
        (list
    ;;;     (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR);2008/09/24 YM DEL
    ;;;     (list "形状"               (nth  5 CG_GLOBAL$) 'STR);2008/09/24 YM DEL
    ;;;     (list "商品タイプ"         "6"                 'INT);2008/09/24 YM DEL
          (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
          (list "天板高さ"           (nth 31 CG_GLOBAL$) 'STR)
          (list "厚み"               #TTT                'STR)
          (list "エンドパネル"       "A"                 'STR);2008/09/24 YM MOD
          (list "吊戸高さ"           (nth 32 CG_GLOBAL$) 'STR)
          (list "トップ勝ち"         #TOP_F              'STR);2010/11/08 YM ADD
        )
      )
      (setq #qry$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME1 #LIST$$)
      )

      (setq #qry$ (DBCheck #qry$ "『パネル管理』" "KP_PutEndPanel")) ; 検索結果WEB版ﾛｸﾞ出力

      ; ID
      (setq #huku_id (nth 0 #qry$))

      ;パネル構成
      (setq #panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "ID"  #huku_id  'STR)
            (list "order by \"RECNO\"" nil  'ADDSTR)
          )
        )
      )

      (foreach #panel_qry$ #panel_qry$$
        (setq #RECNO (nth 1 #panel_qry$))  ;recno
        (setq #HNO   (nth 2 #panel_qry$))  ;品番名称
        (setq #LR    (nth 3 #panel_qry$))  ;LR区分

        (if (equal #RECNO 1.0 0.001)
          (progn ;下台

;;;	;2017/01/10 YM ADD-S 最初に配置する部材のX座標を保存
;;;	(setq CG_FIRST_BASE_X (nth 9 (car #qry1$$)))
;;;	(setq CG_FIRST_WALL_X (nth 9 (car #qry2$$)))
;;;	;2017/01/10 YM ADD-E 最初に配置する部材のX座標を保存

            (cond
              ((= (nth 45 CG_GLOBAL$) "A")
                ;ｼﾝｸ側(I型,L型)

								;2017/01/10 YM ADD-S 最初に配置する部材のX座標
;;;								(setq #XX  CG_FIRST_BASE_X)
;;;                (setq #XX  (+ #XX (- (atoi (substr #TTT 2 3))) ))
								;2017/01/10 YM ADD-E 最初に配置する部材のX座標
                (setq #XX  (- (atoi (substr #TTT 2 3))));従来どおり

                (setq #YY  0)
                (setq #ZZ  0)
                (setq #ANG 0.0)
                ;配置
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
              )
              ((= (nth 45 CG_GLOBAL$) "B")
                (if (= "I" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;ｺﾝﾛ側(I型)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (setq #YY  0)
                    (setq #ZZ  0)
                    (setq #ANG 0.0)
                  )
                );_if

                (if (= "L" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;ｺﾝﾛ側(L型)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (cond
                      ((= (nth  5 CG_GLOBAL$) "L16")
                        (setq #YY -1650)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L18")
                        (setq #YY -1800)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L19")
                        (setq #YY -1950)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L21")
                        (setq #YY -2100)
                      )
                    );_cond
                    (setq #ZZ  0)
;;;                   (setq #ANG (- (* 0.5 PI)))
                    (setq #ANG -90)
                  )
                );_if

                ;配置
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
              )
              ((= (nth 45 CG_GLOBAL$) "C")
                ;両側 "A"と"B"の処理を両方行う

                ;ｼﾝｸ側(I型,L型)
                (setq #XX  (- (atoi (substr #TTT 2 3))))
                (setq #YY  0)
                (setq #ZZ  0)
                (setq #ANG 0.0)
                ;配置
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")


                (if (= "I" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;ｺﾝﾛ側(I型)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (setq #YY  0)
                    (setq #ZZ  0)
                    (setq #ANG 0.0)
                  )
                );_if

                (if (= "L" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;ｺﾝﾛ側(L型)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (cond
                      ((= (nth  5 CG_GLOBAL$) "L16")
                        (setq #YY -1650)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L18")
                        (setq #YY -1800)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L19")
                        (setq #YY -1950)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L21")
                        (setq #YY -2100)
                      )
                    );_cond
                    (setq #ZZ  0)
;;;                   (setq #ANG (- (* 0.5 PI)))
                    (setq #ANG -90)
                  )
                );_if

                ;配置
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")

              )
            )
          ) ;下台
        );_if


        (if (equal #RECNO 21.0 0.001)
          (progn ;吊戸

;;;	;2017/01/10 YM ADD-S 最初に配置する部材のX座標を保存
;;;	(setq CG_FIRST_BASE_X (nth 9 (car #qry1$$)))
;;;	(setq CG_FIRST_WALL_X (nth 9 (car #qry2$$)))
;;;	;2017/01/10 YM ADD-E 最初に配置する部材のX座標を保存

            (cond
              ((= (nth 45 CG_GLOBAL$) "A")
                ;ｼﾝｸ側(I型,L型)

								;2017/01/10 YM MOD-S 最初に配置する部材のX座標
								(setq #XX  CG_FIRST_WALL_X)
                (setq #XX  (+ #XX (- (atoi (substr #TTT 2 3))) ))
								;2017/01/10 YM MOD-E 最初に配置する部材のX座標

                (setq #YY  0)
                (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
                (setq #ANG 0.0)
                ;配置
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
              )
              ((= (nth 45 CG_GLOBAL$) "B")
                (if (= "I" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;ｺﾝﾛ側(I型)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (setq #YY  0)
                    (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
                    (setq #ANG 0.0)
                  )
                );_if

                (if (= "L" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;ｺﾝﾛ側(L型)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (cond
                      ((= (nth  5 CG_GLOBAL$) "L16")
                        (setq #YY -1650)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L18")
                        (setq #YY -1800)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L19")
                        (setq #YY -1950)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L21")
                        (setq #YY -2100)
                      )
                    );_cond
                    (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
;;;                   (setq #ANG (- (* 0.5 PI)))
                    (setq #ANG -90)
                  )
                );_if

                ;配置
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
              )
              ((= (nth 45 CG_GLOBAL$) "C")
                ;両側 "A"と"B"の処理を両方行う

                ;ｼﾝｸ側(I型,L型)
                (setq #XX  (- (atoi (substr #TTT 2 3))))
                (setq #YY  0)
                (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
                (setq #ANG 0.0)
                ;配置
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")


                (if (= "I" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;ｺﾝﾛ側(I型)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (setq #YY  0)
                    (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
                    (setq #ANG 0.0)
                  )
                );_if

                (if (= "L" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;ｺﾝﾛ側(L型)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (cond
                      ((= (nth  5 CG_GLOBAL$) "L16")
                        (setq #YY -1650)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L18")
                        (setq #YY -1800)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L19")
                        (setq #YY -1950)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L21")
                        (setq #YY -2100)
                      )
                    );_cond

                    (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
;;;                   (setq #ANG (- (* 0.5 PI)))
                    (setq #ANG -90)
                  )
                );_if

                ;配置
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")

              )
            )
          ) ;吊戸
        );_if


      );foreach

  
    )
  );_if
  (princ)
);KP_PutEndPanel

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_PutEndPanel_FK
;;; <処理概要>  : ﾌﾟﾗﾝ検索ｴﾝﾄﾞﾊﾟﾈﾙ取付け <ﾌﾚｰﾑｷｯﾁﾝ用>
;;; <戻り値>    :
;;; <作成>      : 2017/10/02 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_PutEndPanel_FK (
  /
  #ANG #BLK$ #DB_NAME1 #DB_NAME2 #HNO #HUKU_ID #LIST$$ #LR #PANEL_QRY$$ #QRY$
  #T$ #T$$ #TTT #XX #YY #ZZ #RECNO
#TOP_F ;2010/11/08 YM ADD
  )

;(nth 45 CG_GLOBAL$);ｴﾝﾄﾞﾊﾟﾈﾙ

;;;X  -----
;;;N  取付けない
;;;A  シンク側のみ
;;;B  コンロ側のみ
;;;C  両側取付け

  ;2008/09/24 YM MOD [パネル管理][パネル構成]ﾃｰﾌﾞﾙ構造変更 品番のみ取得。配置位置はPG計算
  (if (or (= (nth 45 CG_GLOBAL$) "A")(= (nth 45 CG_GLOBAL$) "B")(= (nth 45 CG_GLOBAL$) "C"))
    (progn
      
      (setq #DB_NAME1 "パネル管理FK")
      (setq #DB_NAME2 "パネル構成FK")

      (setq #LIST$$
        (list
          (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
          (list "天板高さ"           (nth 31 CG_GLOBAL$) 'STR)
          (list "エンドパネル"       "A"                 'STR)
        )
      )
      (setq #qry$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME1 #LIST$$)
      )

      (setq #qry$ (DBCheck #qry$ "『パネル管理FK』" "KP_PutEndPanel")) ; 検索結果WEB版ﾛｸﾞ出力

      ; ID
      (setq #huku_id (nth 0 #qry$))

      ;パネル構成
      (setq #panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "ID"  #huku_id  'STR)
            (list "order by \"RECNO\"" nil  'ADDSTR)
          )
        )
      )

      (foreach #panel_qry$ #panel_qry$$
        (setq #RECNO (nth 1 #panel_qry$))  ;recno
        (setq #HNO   (nth 2 #panel_qry$))  ;品番名称
        (setq #LR    (nth 3 #panel_qry$))  ;LR区分
        (setq #XX    (nth 4 #panel_qry$))
        (setq #YY    (nth 5 #panel_qry$))
        (setq #ZZ    (nth 6 #panel_qry$))
        (setq #ANG   (nth 7 #panel_qry$))
        ;配置
        (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A") ;G_OPT処理含む
      );foreach
    )
  );_if
  (princ)
);KP_PutEndPanel_FK

;;;<HOM>*************************************************************************
;;; <関数名>    : GetTopFlg
;;; <処理概要>  : [ﾄｯﾌﾟ勝ち判定]検索結果を返す
;;; <戻り値>    : "Y" or "N"
;;; <作成>      : 2010/11/08 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun GetTopFlg (
  /
  #TOP_F #OK1 #QRY$ #QRY$$
  )
  ;初期化
  (setq #TOP_F "N");ﾄｯﾌﾟ勝ちでない

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION "トップ勝ち判定"
       (list
         (list "材質記号"   (nth 16 CG_GLOBAL$) 'STR)
         (list "シンク記号" (nth 17 CG_GLOBAL$) 'STR)
         (list "形状"       (nth  5 CG_GLOBAL$) 'STR)
       )
     )
  )

  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #qry$ (car #qry$$))
      ;1件HITした場合、間口を判定する
      (setq #Ok1 nil)
      (foreach #dbVal (strparse (nth  4 #qry$) ",")
        (if (= (nth  4 CG_GLOBAL$) #dbVal) (setq #Ok1 T));間口が一致した場合
      )
      ;間口が一致しなくとも"ALL"なら真
      (if (= "ALL" (nth 4 #qry$)) (setq #Ok1 T))
      (if #Ok1 (setq #TOP_F "Y"))
    )
    ;else
    nil ;ﾚｺｰﾄﾞが存在しない→ﾄｯﾌﾟ勝ちではないとみなす
  );_if
  #TOP_F
);GetTopFlg

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_PutEndPanel_D
;;; <処理概要>  : ﾌﾟﾗﾝ検索ｻｲﾄﾞﾊﾟﾈﾙ取付け <収納用>
;;; <戻り値>    :
;;; <作成>      : 2008/072/26 YM 関数化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_PutEndPanel_D (
  /
  #T$ #T$$ #TTT
  )

;(nth 71 CG_GLOBAL$);ｴﾝﾄﾞﾊﾟﾈﾙ

;;;N  取付けない
;;;L  左側のみ
;;;R  右側のみ
;;;B  両側取付け

  (setq #T$$ ; 収納用
    (CFGetDBSQLRec CG_DBSESSION "パネル厚み"
      (list
        (list "扉シリ記号"     (nth 62 CG_GLOBAL$) 'STR)
        (list "扉カラ記号"     (nth 63 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #T$ (DBCheck #T$$ "『パネル厚み』" "KP_PutEndPanel_D"))
  (setq #TTT (nth 2 #T$));EP厚み

  (cond
    ((= (nth 71 CG_GLOBAL$) "L")
      ;2009/10/07 YM ADD-S 勝手 PLAN56 で判断
      (cond
        ((= (nth 56 CG_GLOBAL$) "N");勝手なし
          (PutEP_D_sub #TTT "L");そのまま
        )
        ((= (nth 56 CG_GLOBAL$) "L");勝手L
          (PutEP_D_sub #TTT "L");そのまま
        )
        ((= (nth 56 CG_GLOBAL$) "R");勝手R
          (PutEP_D_sub #TTT "R");後で反転するので逆転しておく
        )
        (T
          (PutEP_D_sub #TTT "L");そのまま
        )
      );_cond
      ;2009/10/07 YM ADD-E 勝手 PLAN56 で判断
    )
    ((= (nth 71 CG_GLOBAL$) "R")
      ;2009/10/07 YM ADD-S 勝手 PLAN56 で判断
      (cond
        ((= (nth 56 CG_GLOBAL$) "N");勝手なし
          (PutEP_D_sub #TTT "R");そのまま
        )
        ((= (nth 56 CG_GLOBAL$) "L");勝手L
          (PutEP_D_sub #TTT "R");そのまま
        )
        ((= (nth 56 CG_GLOBAL$) "R");勝手R
          (PutEP_D_sub #TTT "L");後で反転するので逆転しておく
        )
        (T
          (PutEP_D_sub #TTT "R");そのまま
        )
      );_cond
      ;2009/10/07 YM ADD-E 勝手 PLAN56 で判断
      
    )
    ((= (nth 71 CG_GLOBAL$) "B")
      (PutEP_D_sub #TTT "L")
      (PutEP_D_sub #TTT "R")
    )
  );_cond

  (princ)
);KP_PutEndPanel_D


;;;<HOM>*************************************************************************
;;; <関数名>    : KP_PutEndPanel_D_EXTEND
;;; <処理概要>  : ﾌﾟﾗﾝ検索ｻｲﾄﾞﾊﾟﾈﾙ取付け <収納拡大SDB用>
;;; <戻り値>    :
;;; <作成>      : 2009/11/23 YM 関数化
;;; <備考>      : 左基準の場合、各ﾌﾟﾗﾝの終わり(右端)にEPを配置する
;;;*************************************************************************>MOH<
(defun KP_PutEndPanel_D_EXTEND (
  /
  #T$ #T$$ #TTT
  )
;(nth 71 CG_GLOBAL$);ｴﾝﾄﾞﾊﾟﾈﾙ
;;;N  無し
;;;TA3  ﾄｰﾙﾊﾟﾈﾙ D340mm
;;;TA4  ﾄｰﾙﾊﾟﾈﾙ D440mm
;;;TA5  ﾄｰﾙﾊﾟﾈﾙ D590mm
;;;EP ｴﾝﾄﾞﾊﾟﾈﾙ

;;;PLAN60
;;;LL 左基準==>左設置
;;;RR 右基準==>右設置

  (setq #T$$ ; 収納用
    (CFGetDBSQLRec CG_DBSESSION "パネル厚み"
      (list
        (list "扉シリ記号"     (nth 62 CG_GLOBAL$) 'STR)
        (list "扉カラ記号"     (nth 63 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #T$ (DBCheck #T$$ "『パネル厚み』" "KP_PutEndPanel_D"))
  (setq #TTT (nth 2 #T$));EP厚み
  (setq CG_EP_THICKNESS (atof (substr #TTT 2 3)));EP厚み(ｸﾞﾛｰﾊﾞﾙ変数)

  (cond
    ((= (nth 60 CG_GLOBAL$) "LL");左基準
      (PutEP_D_sub_EXTEND CG_D_EXTEND_KAI #TTT "R")
    )
    ((= (nth 60 CG_GLOBAL$) "RR");右基準
      (PutEP_D_sub_EXTEND CG_D_EXTEND_KAI #TTT "L")
    )
    (T
      (PutEP_D_sub_EXTEND CG_D_EXTEND_KAI #TTT "R")
    )
  );_cond

  (princ)
);KP_PutEndPanel_D_EXTEND

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_PutEndPanel_D_EXTEND_START
;;; <処理概要>  : ﾌﾟﾗﾝ検索最終ｻｲﾄﾞﾊﾟﾈﾙ取付け <収納拡大SDB用>
;;; <戻り値>    :
;;; <作成>      : 2009/11/23 YM 関数化
;;; <備考>      : 左基準の場合、各ﾌﾟﾗﾝの終わり(右端)にEPを配置する
;;;*************************************************************************>MOH<
(defun KP_PutEndPanel_D_EXTEND_START (
  /
  #T$ #T$$ #TTT
  )
  (setq #T$$ ; 収納用
    (CFGetDBSQLRec CG_DBSESSION "パネル厚み"
      (list
        (list "扉シリ記号"     (nth 62 CG_GLOBAL$) 'STR)
        (list "扉カラ記号"     (nth 63 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #T$ (DBCheck #T$$ "『パネル厚み』" "KP_PutEndPanel_D"))
  (setq #TTT (nth 2 #T$));EP厚み

  (cond
    ((= (nth 60 CG_GLOBAL$) "LL");左基準
      (PutEP_D_sub_EXTEND_START #TTT "L");ここだけ違う
    )
    ((= (nth 60 CG_GLOBAL$) "RR");右基準
      (PutEP_D_sub_EXTEND_START #TTT "R");ここだけ違う
    )
    (T
      (PutEP_D_sub_EXTEND_START #TTT "L")
    )
  );_cond

  (princ)
);KP_PutEndPanel_D_EXTEND_START

;<HOM>*************************************************************************
; <関数名>    : PutEP_D_sub
; <処理概要>  : ﾊﾟﾈﾙを配置する
; <戻り値>    : なし
; <作成>      : 03/05/12 YM
; <備考>      :
;*************************************************************************>MOH<
(defun PutEP_D_sub (
  &TTT ;EP厚み
  &side
  /
  #ANG #HNO #HUKU_ID #LIST$$ #LR #PANEL_QRY$$ #QRY$ #SIDE #TTT #XX #YY #ZZ
  )
  (setq #TTT   &TTT);EP厚み
  (setq #side &side);EP配置側

  (setq #LIST$$
    (list
      (list "奥行き"         (nth 53 CG_GLOBAL$) 'STR)
      (list "タイプ"         (nth 54 CG_GLOBAL$) 'STR)
      (list "収納間口"       (nth 55 CG_GLOBAL$) 'STR)
      (list "商品タイプ"     "6"                 'INT)
      (list "厚み"           #TTT                'STR)
      (list "エンドパネル"   #side               'STR)

    )
  )
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "パネル管理D" #LIST$$)
  )
  (setq #qry$ (DBCheck #qry$ "『パネル管理D』" "KP_PutEndPanel")) ; 検索結果WEB版ﾛｸﾞ出力

  ; ID
  (setq #huku_id (nth 0 #qry$))

  ;パネル構成
  (setq #panel_qry$$
    (CFGetDBSQLRec CG_DBSESSION "パネル構成"
      (list
        (list "ID"  #huku_id  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  (foreach #panel_qry$ #panel_qry$$
    (setq #HNO (nth 2 #panel_qry$))  ;品番名称
    (setq #LR  (nth 3 #panel_qry$))  ;LR区分
    (setq #XX  (nth 4 #panel_qry$))
    (setq #YY  (nth 5 #panel_qry$))
    (setq #ZZ  (nth 6 #panel_qry$))
    (setq #ANG (nth 7 #panel_qry$))
    ;配置
    (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "D")
  )
  (princ)
);PutEP_D_sub


;<HOM>*************************************************************************
; <関数名>    : PutEP_D_sub_EXTEND
; <処理概要>  : ﾊﾟﾈﾙを配置する(収納拡大)
; <戻り値>    : なし
; <作成>      : 2009/11/23 YM
; <備考>      :
;*************************************************************************>MOH<
(defun PutEP_D_sub_EXTEND (
  &kai  ;列目
  &TTT  ;EP厚み
  &side ;配置側 "L"=左 "R"=右
  /
  #ANG #HNO #LOW_ID #LOW_PANEL_QRY$$ #LR #MAGU #PANEL_QRY$$ #QRY$ #QRY$$ #TTT
  #UPPER_ID #UPPER_PANEL_QRY$$ #XX #YY #ZZ
  )
  (setq #panel_qry$$ nil)
  (setq #LOW_panel_qry$$ nil)
  (setq #UPPER_panel_qry$$ nil)

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION "パネル管理EX"
      (list
        (list "変換値" (nth (+ (* 100 &kai) 71) CG_GLOBAL$) 'STR)
      )
    )
  )
  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #LOW_id   (nth 2 (car #qry$$)));下台EP記号
      (setq #UPPER_id (nth 3 (car #qry$$)));上台EP記号
      ;パネル構成
      (setq #LOW_panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION "パネル構成EX"
          (list
            (list "EP記号"  #LOW_id  'STR)
            (list "EP厚み"  &TTT     'STR)
          )
        )
      )
      (setq #UPPER_panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION "パネル構成EX"
          (list
            (list "EP記号"  #UPPER_id  'STR)
            (list "EP厚み"  &TTT     'STR)
          )
        )
      )
    )
  );_if

  (setq #panel_qry$$ (append #LOW_panel_qry$$ #UPPER_panel_qry$$))

  (cond
    ((= &side "L") ;左配置
      (setq #TTT (atof (substr &TTT 2 3)))
      (setq #XX (- #TTT))
    )
    ((= &side "R") ;右配置
      (setq #magu (nth (+ (* 100 &kai) 55) CG_GLOBAL$))
      (setq #qry$
        (CFGetDBSQLRec CG_DBSESSION "間口"
          (list (list "間口記号" #magu 'STR))
        )
      )
      (setq #XX (nth 2 (car #qry$)))
    )
    (T
      (setq #TTT (atof (substr &TTT 2 3)))
      (setq #XX (- #TTT))
    )
  );_cond

  (foreach #panel_qry$ #panel_qry$$
    (setq #HNO   (nth 3 #panel_qry$))  ;品番名称
    (setq #LR    (nth 4 #panel_qry$))  ;LR区分
    (setq #ZZ    (nth 5 #panel_qry$))  ;Z座標
    ;Y座標
    (setq #YY 0.0)
    ;配置角度
    (setq #ANG 0.0)
    ;配置処理
    (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "D")
  )
  (princ)
);PutEP_D_sub_EXTEND

;<HOM>*************************************************************************
; <関数名>    : PutEP_D_sub_EXTEND_START
; <処理概要>  : ﾊﾟﾈﾙを配置する(収納拡大)
; <戻り値>    : なし
; <作成>      : 2009/11/30 YM
; <備考>      : 最初の開始ｴﾝﾄﾞﾊﾟﾈﾙ
;*************************************************************************>MOH<
(defun PutEP_D_sub_EXTEND_START (
  &TTT  ;EP厚み
  &side ;配置側 "L"=左 "R"=右
  /
  #ANG #HNO #LOW_ID #LOW_PANEL_QRY$$ #LR #MAGU #PANEL_QRY$$ #QRY$ #QRY$$ #TTT
  #UPPER_ID #UPPER_PANEL_QRY$$ #XX #YY #ZZ
  )
  (setq #panel_qry$$ nil)
  (setq #LOW_panel_qry$$ nil)
  (setq #UPPER_panel_qry$$ nil)

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION "パネル管理EX"
      (list
        (list "変換値"   (nth 71 CG_GLOBAL$) 'STR)
      )
    )
  )
  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #LOW_id   (nth 2 (car #qry$$)));下台EP記号
      (setq #UPPER_id (nth 3 (car #qry$$)));上台EP記号
      ;パネル構成
      (setq #LOW_panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION "パネル構成EX"
          (list
            (list "EP記号"  #LOW_id  'STR)
            (list "EP厚み"  &TTT     'STR)
          )
        )
      )
      (setq #UPPER_panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION "パネル構成EX"
          (list
            (list "EP記号"  #UPPER_id  'STR)
            (list "EP厚み"  &TTT     'STR)
          )
        )
      )
    )
  );_if

  (setq #panel_qry$$ (append #LOW_panel_qry$$ #UPPER_panel_qry$$))

  (cond
    ((= &side "L") ;左配置
      (setq #TTT (atof (substr &TTT 2 3)))
      (setq #XX (- #TTT))
    )
    ((= &side "R") ;右配置
      (setq #magu (nth (+ (* 100 1) 55) CG_GLOBAL$))
      (setq #qry$
        (CFGetDBSQLRec CG_DBSESSION "間口"
          (list (list "間口記号" #magu 'STR))
        )
      )
      (setq #XX (nth 2 (car #qry$)))
    )
    (T
      (setq #TTT (atof (substr &TTT 2 3)))
      (setq #XX (- #TTT))
    )
  );_cond

  (foreach #panel_qry$ #panel_qry$$
    (setq #HNO   (nth 3 #panel_qry$))  ;品番名称
    (setq #LR    (nth 4 #panel_qry$))  ;LR区分
    (setq #ZZ    (nth 5 #panel_qry$))  ;Z座標

    ;2011/05/21 YM MOD 吊戸下OPEN_BOXのときZ=2150mmに補正する
    (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
      (if (<= 2000 #ZZ) ;上台用
        (setq #ZZ CG_WallUnderOpenBoxHeight)
      );_if
    );_if

    ;Y座標
    (setq #YY 0.0)
    ;配置角度
    (setq #ANG 0.0)
    ;配置処理
    (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "D")
  )
  (princ)
);PutEP_D_sub_EXTEND_START

;<HOM>*************************************************************************
; <関数名>    : PD_StartLayout
; <処理概要>  : ダイニングを自動ﾚｲｱｳﾄする
; <戻り値>    : なし
; <作成>      : 03/05/12 YM
; <備考>      : WK_SDA用
;*************************************************************************>MOH<
(defun PD_StartLayout (
  &family$$
  /

  )
  (WebOutLog "ｷｯﾁﾝを自動ﾚｲｱｳﾄします(PD_StartLayout)")

  (WebDefErrFunc) ; ｴﾗｰ関数定義
  (WebOutLog "ｴﾗｰ関数 SKAutoError2 を定義しました(PD_StartLayout)")

  (WebOutLog "++++++++++++++++++++++++++++")
  (WebOutLog "*error*関数")
  (WebOutLog *error*)
  (WebOutLog "++++++++++++++++++++++++++++")

  (if (or (= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/08/01 YM ADD ; 02/08/05 YM ADD
    (progn ; WEB版CADｻｰﾊﾞｰ&LOCAL端末
      ; 天井ﾌｨﾗｰ,ｻｲﾄﾞﾊﾟﾈﾙ
;;; 2008/09/11YM@DEL      (WEB_SetFilPanelCode)  ; Web版CADｻｰﾊﾞｰﾓｰﾄﾞ
      nil
    )
    (progn
      (SDG_SetFamilyCode &family$$)
      (SKChgView "2,-2,1") ; ﾃﾞﾊﾞｯｸﾞ用視点南東から
      (command "_zoom" "e")
    )
  );_if


  ;//---------------------------------------------------------
  ;// 構成部材自動配置
  ;//    本処理内でキャビネット等のレイアウトを行う
  ;//---------------------------------------------------------
  (WebOutLog "収納部材を自動配置します(PDC_ModelLayout)")

  ;収納ﾌﾟﾗﾝの挿入
  (PDC_ModelLayout)
  (command "_layer" "T" "*" "")

  (WebDefErrFunc) ; ｴﾗｰ関数定義(02/09/11 YM 関数化)

  ;// 天井ﾌｨﾗｰの作成
  (if (and (/= (nth 72 CG_GLOBAL$) "N")(/= (nth 72 CG_GLOBAL$) "X"));天井ﾌｨﾗｰ取付ける
    (progn
      (WebOutLog "--- 天井ﾌｨﾗｰの作成(PKW_UpperFiller)を呼ぶ ---")
      ;2009/11/21 YM ADD 収納SDAは前だけ
      (setq SKW_FILLER_LSIDE 1)
      (setq SKW_FILLER_RSIDE 1)
      (setq SKW_FILLER_BSIDE 0)
      (PKW_UpperFiller);現在天井ﾌｨﾗｰ="A"のみ
    )
  );_if

  (WebOutLog "--- (PD_StartLayout)から出る ---")

  (princ)
);PD_StartLayout

;<HOM>*************************************************************************
; <関数名>    : PD_StartLayout_EXTEND
; <処理概要>  : ダイニングを自動ﾚｲｱｳﾄする
; <戻り値>    : なし
; <作成>      : 2009/11/18 YM
; <備考>      : 収納拡大 WK_SDB専用ﾛｼﾞｯｸ最大5列並べる
;*************************************************************************>MOH<
(defun PD_StartLayout_EXTEND (
  &family$$
  /

  )
  (setq CG_EP_THICKNESS 0)     ;ｴﾝﾄﾞﾊﾟﾈﾙ厚み初期化
;;; (setq CG_COUNTER_INFO$$ nil) ;ｶｳﾝﾀｰ配置情報(ｶｳﾝﾀｰ接続に使用)
  (setq CG_D_EXTEND_KAI nil)   ;列数

  (princ "\n収納拡大を自動ﾚｲｱｳﾄします(PD_StartLayout_EXTEND)")
  (WebOutLog "収納拡大を自動ﾚｲｱｳﾄします(PD_StartLayout_EXTEND)")

  (WebDefErrFunc) ; ｴﾗｰ関数定義
  (princ "\nｴﾗｰ関数 SKAutoError2 を定義しました(PD_StartLayout)")
  (WebOutLog "ｴﾗｰ関数 SKAutoError2 を定義しました(PD_StartLayout)")

  (if (or (= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/08/01 YM ADD ; 02/08/05 YM ADD
    (progn ; WEB版CADｻｰﾊﾞｰ&LOCAL端末
      (princ "\nWEB版CADｻｰﾊﾞｰ&LOCAL端末")
    )
    (progn
      ;ｸﾞﾛｰﾊﾞﾙ変数に値をｾｯﾄ
      (SDG_SetFamilyCode &family$$)
      (SKChgView "2,-2,1") ; ﾃﾞﾊﾞｯｸﾞ用視点南東から
      (command "_zoom" "e")
    )
  );_if


  ;//---------------------------------------------------------
  ;// 構成部材自動配置
  ;//    本処理内でキャビネット等のレイアウトを行う
  ;//---------------------------------------------------------
  (WebOutLog "収納部材を自動配置します(PDC_ModelLayout_EXTEND)")

  ;★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆
  ;収納一列に対し、構成部材配置→ｴﾝﾄﾞﾊﾟﾈﾙ配置→反転処理→天井ﾌｨﾗｰの作成→表示画層の設定を行う
  ;★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆

  ;ﾌﾟﾗﾝdwgの削除
  (princ "\nﾌﾟﾗﾝdwgの削除")
  (if (findfile (strcat CG_SYSPATH "plan.dwg"))
    (vl-file-delete (strcat CG_SYSPATH "plan.dwg"))
  );_if

  (foreach #i (list "1" "2" "3" "4" "5")
    (if (findfile (strcat CG_SYSPATH "plan" #i ".dwg"))
      (vl-file-delete (strcat CG_SYSPATH "plan" #i ".dwg"))
    );_if
  )

;左右基準 LL or RR
;;;(nth 60 CG_GLOBAL$)
;2～5列目間口
;;;(nth (+ (* 100 #i) 55) CG_GLOBAL$)
;2～5列目有無
;;;(nth (+ (* 100 #i) 1) CG_GLOBAL$)
;2～5列目EP有無
;;;(nth (+ (* 100 #i) 71) CG_GLOBAL$)
;最終EP有無
;;;(nth 71 CG_GLOBAL$)

  ;最終列を求める
  (princ "\n最終列を求める")
  (setq CG_LAST 5);最終列
  (foreach #i (list 5 4 3 2)
    (if (/= "Y" (nth (+ (* 100 #i) 1) CG_GLOBAL$))
      (progn ;"N"
        (setq CG_LAST (1- #i))
      )
    );_if
    (setq #i (1+ #i))
  );foreach

  ;①～⑤列 構成配置,EP配置 plan?.dwgに保存
  (foreach #i (list 1 2 3 4 5)
    (setq CG_D_EXTEND_KAI #i);ｸﾞﾛｰﾊﾞﾙ変数(何列目か格納)
    (if (= "Y" (nth (+ (* 100 #i) 1) CG_GLOBAL$))
      (progn
        (princ (strcat "\n(plan_clear)" (itoa #i)))
        (WebOutLog "(plan_clear)前")
        (plan_clear)
        (WebOutLog "(plan_clear)後")
        (PDC_ModelLayout_EXTEND);左基準==>左にEP、右基準==>右にEP
      )
    );_if
    (setq #i (1+ #i))
  );foreach

  ;ここを出た後 PC_LayoutPlanExec を出てから plan.dwg　の名前で保存
  ;(command "_saveas" "" (strcat CG_SYSPATH "plan.dwg"))

  (WebOutLog "--- (PD_StartLayout)から出る ---")
  (princ)
);PD_StartLayout_EXTEND

;;;<HOM>*************************************************************************
;;; <関数名>    : plan_clear
;;; <処理概要>  : 図面ｸﾘｱｰ(plan.dwg内)
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 2009/11/21 YM ADD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun plan_clear (
  /
  #SSALL
  )
  (setvar "CLAYER" "0") ; 現在画層"0"
  (WebOutLog "(C:ALP)前")
  (C:ALP);全画層表示
  (WebOutLog "(C:ALP)後")
  (setq #ssALL (ssget "X")) ; 全図形
  (if (and #ssALL (< 0 (sslength #ssALL)))
    (command "_.erase" #ssALL "") ; 図形削除
  );_if
  ; ﾊﾟｰｼﾞ
  (command "_purge" "A" "*" "N")
  (command "pdmode" "0")
  (princ)
);plan_clear

;<HOM>*************************************************************************
; <関数名>    : WF_StartLayout
; <処理概要>  : システム洗面を自動レイアウトする
; <戻り値>    :
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun WF_StartLayout (
    &family$$
    /
    #ss #i #en$ #viewEn
  )
  ;// ﾌｧﾐﾘｰ品番ｸﾞﾛｰﾊﾞﾙの設定
  ;//
  (setq CG_PROGMSG "特性値の取得中")
;;;  (CFOutLog 1 nil (strcat "*** " CG_PROGMSG " ***"))
  (WFG_SetFamilyCode &family$$)

  ;// 1-1.構成部材自動配置（川本）
  ;//
  ;//    本処理内でｷｬﾋﾞﾈｯﾄ等のﾚｲｱｳﾄを行う
  (setq CG_PROGMSG "部材の自動展開中")
;;;  (CFOutLog 1 nil (strcat "*** " CG_PROGMSG " ***"))
  (WFC_ModelLayout)
  (command "_.layer" "T" "*" "")

  ;// 水栓の配置




  ;// オプションの配置




  ;// トールキャビの配置



  (if (= CG_MKDOOR T)
    (progn
      (setq CG_PROGMSG "扉面の貼付中")
;;;      (CFOutLog 1 nil (strcat "*** " CG_PROGMSG " ***"))

      ;// 処理高速化の為、画層フリーズ制御
      (command "_.layer" "F"  "Z_*"   "")
      (command "_.layer" "F"  "P*"    "")
      (command "_.layer" "OF" "N_B*"  "")
      (command "_.layer" "T"  "Z_00*" "")

      ;// 扉面の貼り付け
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (repeat (sslength #ss)
        (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode (ssname #ss #i) 1))
          (setq #en$ (cons (ssname #ss #i) #en$))
        )
        (setq #i (1+ #i))
      )
      (SCD_MakeViewAlignDoor #en$ 3 nil)
    )
  )
  (princ)
);WF_StartLayout

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_ChkUpperBaseSYM
;;; <処理概要>  : ﾍﾞｰｽｼﾝﾎﾞﾙ図形を渡して、上に性格ｺｰﾄﾞ"14?"のｼﾝﾎﾞﾙがあれば'Tを返す
;;; <戻り値>    : T or nil
;;; <作成>      : 00/08/14 YM
;;; <備考>      : vpoint '(0 0 1) が必要
;;;*************************************************************************>MOH<
(defun PK_ChkBaseSYM (
  &BaseSym
  /
  #ELM #HNDL #I #P1 #P2 #P3 #P4 #PT #PT$ #RET #SKK$ #SS
  )
  (setq #pt   (cdr (assoc 10 (entget &BaseSym)))) ; ｼﾝﾎﾞﾙ座標
  (setq #hndl (cdr (assoc  5 (entget &BaseSym)))) ; ｼﾝﾎﾞﾙﾊﾝﾄﾞﾙ
  (setq #ret nil)
  (setq #p1 (polar #pt (dtr   45) 10))
  (setq #p2 (polar #pt (dtr  135) 10))
  (setq #p3 (polar #pt (dtr -135) 10))
  (setq #p4 (polar #pt (dtr  -45) 10))
  (setq #pt$ (list #p1 #p2 #p3 #p4 #p1))
  (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_LSYM")))))
  (if #ss
    (if (> (sslength #ss) 0)
      (progn
        (setq #i 0)
        (repeat (sslength #ss)
          (setq #elm (ssname #ss #i))
          (if (equal #hndl (cdr (assoc 5 (entget #elm))))
            (princ)
            (progn ; 引数のｼﾝﾎﾞﾙとは異なる
              (setq #skk$ (CFGetSymSKKCode #elm nil))
              (if (and (= (car #skk$)  CG_SKK_ONE_CAB)  ; 1
                       (= (cadr #skk$) CG_SKK_TWO_MID)) ; 4 ﾐﾄﾞﾙ
                (setq #ret T) ; ｳｫｰﾙｷｬﾋﾞ以外があれば T
              );_if
            )
          );_if
          (setq #i (1+ #i))
        );_repeat
      )
    );_if
  );_if
  #RET
);PK_ChkBaseSYM

;;;<HOM>*************************************************************************
;;; <関数名>    : CPrint_Time
;;; <処理概要>  : 刻み(nick)で数値の繰り上げ
;;; <引数>      : なし
;;; <戻り値>    : 日付時刻の文字列をログに書き込む
;;; <作成>      : 2000.2.17 @YM@
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun CPrint_Time ( / #date_time)
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))
)

;;;<HOM>************************************************************************
;;; <関数名>  : PcPrintLog
;;; <処理概要>: グローバルをログにかき出し 03/24 YM
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun PcPrintLog ( / )
;;; DEBUG用
   (CFOutStateLog 1 1 (strcat "  +物件番号       :" CG_BukkenNo))
   (CFOutStateLog 1 1 (strcat "  +ｼﾘｰｽﾞ          :" CG_SeriesCode))     ;[1]
   (CFOutStateLog 1 1 (strcat "  +ﾕﾆｯﾄ           :" CG_UnitCode))       ;[3] K,D
   (CFOutStateLog 1 1 (strcat "  +間口1          :" CG_W1Code))         ;[4] 180,195,210,225,240,255,260,270,285,300
   (CFOutStateLog 1 1 (strcat "  +間口2          :" CG_W2CODE))         ;[5] Z,K(ｶﾞｽ側1650),L(ｶﾞｽ側1800)
   (CFOutStateLog 1 1 (strcat "  +ﾀｲﾌﾟ1          :" CG_Type1Code))      ;[6] S(標準ﾌﾟﾗﾝ),W(食器洗浄機ﾌﾟﾗﾝ)
   (CFOutStateLog 1 1 (strcat "  +ﾀｲﾌﾟ2          :" CG_Type2Code))      ;[7] F(ﾌﾗｯﾄﾌﾟﾗﾝ),D(段差ﾌﾟﾗﾝ)
   (CFOutStateLog 1 1 (strcat "  +ｼﾝｸ下仕様      :" CG_SinkUnderCode))  ;[8] S(標準仕様),L(ｽﾗｲﾄﾞ仕様),N(ﾆｰｽﾍﾟｰｽ仕様)
   (CFOutStateLog 1 1 (strcat "  +LR             :" (nth 11 CG_GLOBAL$)))         ;[11] L(右勝手),R(左勝手)
   (CFOutStateLog 1 1 (strcat "  +ﾄﾞｱｼﾘ          :" CG_DRSeriCode))     ;[12]
   (CFOutStateLog 1 1 (strcat "  +ﾄﾞｱ色          :" CG_DRColCode))      ;[13]
   (CFOutStateLog 1 1 (strcat "  +ｿﾌﾄﾀﾞｳﾝ        :" CG_SoftDownCode))   ;[14] 0(なし),1(あり)
   (CFOutStateLog 1 1 (strcat "  +ﾛｯｸ            :" CG_LockCode))       ;[15] V(耐震ﾛｯｸなし),S(あり)
   (CFOutStateLog 1 1 (strcat "  +WT素材         :" CG_WTZaiCode))      ;[16]
   (CFOutStateLog 1 1 (strcat "  +ｼﾝｸ            :" CG_SinkCode))       ;[17]
   (CFOutStateLog 1 1 (strcat "  +水栓穴         :" CG_WtrHoleTypeCode));[18] 1(必要),0(不要),2(水栓浄水機穴要)
   (CFOutStateLog 1 1 (strcat "  +水栓           :" CG_WtrHoleCode))    ;[19] 0(なし),1(標準),2,3,4,5,6
   (CFOutStateLog 1 1 (strcat "  +ｺﾝﾛ            :" CG_CRCode))         ;[20]
   (CFOutStateLog 1 1 (strcat "  +ｺﾝﾛ下          :" CG_CRUnderCode))    ;[21]
;;;   (CFOutStateLog 1 1 (strcat "  +ｺﾝﾛ脇          :" CG_CRWakiCode))     ;[22] ｺﾝﾛ脇
   (CFOutStateLog 1 1 (strcat "  +ﾚﾝｼﾞ           :" CG_RangeCode))      ;[23] 0(なし),A,B,C
   (CFOutStateLog 1 1 (strcat "  +ﾌﾛｱ 取付高さ1  :" CG_BaseCabHeight))  ;[31] A(850),B(800)
   (CFOutStateLog 1 1 (strcat "  +ｳｫｰﾙ取付高さ2  :" CG_UpperCabHeight)) ;[32] S(500),C(600),M(700)
   (CFOutStateLog 1 1 (strcat "  +機器色         :" CG_KikiColor))      ;[33] K(黒),S(銀)
   (CFOutStateLog 1 1 (strcat "  +食洗記号       :" CG_NPCode))         ;[42]食洗記号

;;; 07/27 YM 新規追加項目
   (CFOutStateLog 1 1 (strcat "  +ﾌﾛｱ配置ﾌﾗｸﾞ    :" CG_UnitBase))       ;[UNITBASE]
   (CFOutStateLog 1 1 (strcat "  +ｳｫｰﾙ配置ﾌﾗｸﾞ   :" CG_UnitUpper))      ;[UNITUPPER]
   (CFOutStateLog 1 1 (strcat "  +ﾜｰｸﾄｯﾌﾟ配置ﾌﾗｸﾞ:" CG_UnitTop))        ;[UNITTOP]

  (if CG_FilerCode
   (CFOutStateLog 1 1 (strcat "  +天井ﾌｨﾗｰ       :" CG_FilerCode))      ;[SKOPT04]
  )
  (if CG_KekomiCode
   (CFOutStateLog 1 1 (strcat "  +ｹｺﾐ飾り        :" CG_KekomiCode))     ;[SKOPT05]
  )
   (CFOutStateLog 1 1 "")
  (PRINC)
);PcPrintLog

;<HOM>*************************************************************************
; <関数名>    : SDG_SetFamilyCode
; <処理概要>  : ダイニング用入力情報をグローバルファミリー品番
; <戻り値>    :
; <作成>      : 08/09/11 YM
; <備考>      : WOODONE収納部に使用する
;*************************************************************************>MOH<
(defun SDG_SetFamilyCode (
  &family$$ ;(LIST)プラン検索画面の入力情報
  /
  #HINBAN$ #KEY
  #DRCOL$ #DRCOL$$ #DRSERI$ #DRSERI$$ #SIZE_COL #SIZE_SERI #STR_COL #STR_SERI ; 03/12/17 YM ADD
  #UNIT #I #NUM
  )

  (setq #key      (strcat CG_SeriesCode "D"))
  (setq CG_Kcode  "K") ; 工種記号(未使用)

  ;//---------------------------------------------------------------------
  ;// 特性値情報からパラメータを設定する
  (setq CG_FamilyCode      (cadr (assoc "FamilyCode" &family$$)))

  ;2008/09/11 YM MOD
  ;★★★ ｸﾞﾛｰﾊﾞﾙ変数のｾｯﾄ(0～99まで) [SK特性].PLAN??で定義されていないものはnil値 ★★★
  (setq #i 0)
  (setq CG_GLOBAL$ nil)
  ;2009/11/18 収納拡大用
;;; (repeat 100
  (repeat 600 ;項目ID=PLAN600まで対応
    (if (< #i 10)
      (setq #num (strcat "0" (itoa #i)))
      (setq #num (itoa #i))
    );_if

    (setq CG_GLOBAL$ (append CG_GLOBAL$ (list (cadr (assoc (strcat #key #num) &family$$)))))
    (setq #i (1+ #i))
  );repeat

  ;【暫定措置】引手記号のセット
  (setq CG_DRSeriCode   (nth 62 CG_GLOBAL$));下台
  (setq CG_DRColCode    (nth 63 CG_GLOBAL$));下台
  (setq CG_Hikite       (nth 64 CG_GLOBAL$));下台

  ;2011/04/22 YM ADD 立体陣笠対応
  (setq CG_DRSeriCode_D (nth 62 CG_GLOBAL$));下台
  (setq CG_DRColCode_D  (nth 63 CG_GLOBAL$));下台
  (setq CG_Hikite_D     (nth 64 CG_GLOBAL$));下台

  (setq CG_DRSeriCode_M (nth 82 CG_GLOBAL$));中台
  (setq CG_DRColCode_M  (nth 83 CG_GLOBAL$));中台
  (setq CG_Hikite_M     (nth 84 CG_GLOBAL$));中台

  (setq CG_DRSeriCode_U (nth 92 CG_GLOBAL$));上台
  (setq CG_DRColCode_U  (nth 93 CG_GLOBAL$));上台
  (setq CG_Hikite_U     (nth 94 CG_GLOBAL$));上台

;;;    SD51      :ユニット
;;;    SD52      :シリーズ
;;;    SD62      :扉ｼﾘｰｽﾞ  ★
;;;    SD63      :扉カラー ★
;;;    SD64      :取手     ★
;;;    SD53      :奥行き
;;;    SD54      :タイプ
;;;    SD55      :収納間口
;;;    SD56      :左右勝手
;;;    SD57      :ｶｳﾝﾀｰ色
;;;    SD58      :ｿﾌﾄｸﾛｰｽﾞ
;;;    SD59      :ｱﾙﾐ枠ｶﾞﾗｽ
;;;    SD71      :ｴﾝﾄﾞﾊﾟﾈﾙ
;;;    SD72      :天井ﾌｨﾗｰ

  (princ)
);SDG_SetFamilyCode

;<HOM>*************************************************************************
; <関数名>    : WFG_SetFamilyCode
; <処理概要>  : システム洗面用入力情報をグローバルファミリー品番
; <戻り値>    :
; <作成>      : 1998-06-16
; <備考>      :
;*************************************************************************>MOH<
(defun WFG_SetFamilyCode (
  &family$$    ;(LIST)プラン検索画面の入力情報
  /
  #KEY #REC$$ #TYP
  )
  (setq #key      (strcat CG_SeriesCode "W"))

  ;//---------------------------------------------------------------------
  ;// 特性値情報からパラメータを設定する
  (setq CG_Kcode           "W")
  (setq CG_FamilyCode      (cadr (assoc "FamilyCode" &family$$)))
  (setq CG_SeriesCode      (cadr (assoc (strcat #key "01") &family$$)))
  (setq CG_BrandCode       (cadr (assoc (strcat #key "02") &family$$)))

  ;(setq CG_UnitCode        (cadr (assoc (strcat #key "03") &family$$)))
  (setq CG_UnitCode        "D")
  (setq CG_W1Code          (cadr (assoc (strcat #key "05") &family$$))) ;間口
  (setq CG_W2CODE          (cadr (assoc (strcat #key "04") &family$$))) ;形状
  (setq #typ               (cadr (assoc (strcat #key "06") &family$$))) ;タイプ
  (setq CG_Type1Code       (substr #typ 1 1))                           ;タイプ
  (setq CG_Type2Code       (substr #typ 2 1))                           ;タイプ

  (setq CG_DRColCode          (cadr (assoc (strcat #key "09") &family$$))) ;勝手
  (setq CG_DRSeriCode      (cadr (assoc (strcat #key "12") &family$$))) ;扉SERIES
  (setq CG_DRColCode       (cadr (assoc (strcat #key "13") &family$$))) ;扉COLOR
  (setq CG_UpCabCode       (cadr (assoc (strcat #key "07") &family$$))) ;プラン
  (setq CG_LockCode        (cadr (assoc (strcat #key "08") &family$$))) ;ミラー
  (setq CG_WTZaiCode       nil)
  (setq CG_FILERCode       nil)
  (setq CG_SidePanelCode   nil)
;;;  (setq CG_GusCode         nil) ; 02/07/31 YM MOD
  (setq CG_GasType         nil) ; CG_GusCode→CG_GasType ; 02/07/31 YM MOD
  (setq CG_HzCode          nil)

  (setq CG_UnitBase  nil)  ;ベース配置
  (setq CG_UnitUpper nil)  ;アッパー配置
  (setq CG_UnitTop   nil)  ;カウンター配置

;;;  (CFOutLog 1 nil (strcat "  +ｼﾘｰｽﾞ:" CG_SeriesCode))
;;;  (CFOutLog 1 nil (strcat "  +ﾕﾆｯﾄ:"  CG_UnitCode))
;;;  (CFOutLog 1 nil (strcat "  +間口1:" CG_W1Code))
;;;  (CFOutLog 1 nil (strcat "  +形状:"  CG_W2CODE))
;;;  (CFOutLog 1 nil (strcat "  +ﾀｲﾌﾟ1:" CG_Type1Code))
;;;  (CFOutLog 1 nil (strcat "  +ﾀｲﾌﾟ2:" CG_Type2Code))
;;;  (CFOutLog 1 nil (strcat "  +LR:"    CG_DRColCode))
;;;  (CFOutLog 1 nil (strcat "  +ﾄﾞｱｼﾘ:" CG_DRSeriCode))
;;;  (CFOutLog 1 nil (strcat "  +ﾄﾞｱ色:" CG_DRColCode))
;;;  (CFOutLog 1 nil (strcat "  +ﾌﾟﾗﾝ:"  CG_UpCabCode))
;;;  (CFOutLog 1 nil (strcat "  +ﾐﾗｰ:"   CG_LockCode))

;;;  (CFOutLog 1 nil "")

  ;//----------------------------------------------
  ;// ﾃﾞｰﾀﾍﾞｰｽへの接続
  (if (/= CG_DBSESSION nil)
    (progn
      (dbDisconnect CG_DBSESSION)
      (setq CG_DBSESSION nil)
    )
  )
  (setq CG_DBSession (DBConnect CG_DBName "" ""))
  (if (= CG_DBSESSION nil)
    (progn
      (CFAlertErr "ODBCが正しく設定されているか確認して下さい")
      (quit)
    )
  )

  ;//-------------------------------------------------------
  ;// オプション品の品番を取得する
  ;//   1.水栓
  ;//   2.オプション品
  ;//   3.トールキャビ
  ;//
  ;// 水栓の取得
  (setq #key (cadr (assoc (strcat #key "15") &family$$)))
  (setq CG_OPTWTR$$ (SKG_GetOptionHinban  #key nil nil nil))

  ;// オプション品
  (setq #key (cadr (assoc (strcat #key "16") &family$$)))
  (setq #rec$$ (SKG_GetOptionHinban  #key "L" nil nil))
  (setq CG_OPTPTS$$ (cons #rec$$ (list (SKG_GetOptionHinban  #key "R" nil nil))))

  ;// トールキャビ
  (setq #key (cadr (assoc (strcat #key "18") &family$$)))
  (setq #rec$$ (SKG_GetOptionHinban  #key "L" nil nil))
  (setq CG_OPTTOL$$ (cons #rec$$ (list (SKG_GetOptionHinban  #key "R" nil nil))))
);WFG_SetFamilyCode

;<HOM>*************************************************************************
; <関数名>    : SKG_GetOptionHinban
; <処理概要>  : オプション品の品番を取得する
; <戻り値>    :
;        LIST : オプション品番の品番名称リスト
; <作成>      : 1999-10-27
; <備考>      :
;*************************************************************************>MOH<
(defun SKG_GetOptionHinban (
  &type ;(INT) オプション品タイプ(1:浄水器 2:天井ﾌｨﾗｰ 3:サイドパネル)
  &key1 ;(STR) 浄水器の場合--------水洗穴加工のコード
        ;      天井ﾌｨﾗｰの場合------天井ﾌｨﾗｰの取り付けコード (Y,N)
        ;      サイドパネルの場合--サイドパネルの取り付けコード
  &key2 ;(INT) サイドパネルの場合--天井高さ
  &key3 ;(STR) ダイニング、サイドパネルの場合-タイプ１コード
  &key4 ;(STR) ダイニング、サイドパネルの場合-タイプ２コード
  /
  #HINBAN$ #LISTCODE #MSG #OPT$$ #QRY$ #SQL #SQL$
  )
  ;// オプション品タイプによりオプション品管理ＤＢを検索する
  (setq #listCode nil)
  (setq #sql$
    (list
      (list "SERIES記号" CG_SeriesCode 'STR)
      (list "ユニット記号" CG_UnitCode   'STR)
      (list "OP品区分"     (itoa &type)  'INT)
    )
  )
  (if (/= &key1 nil)
    (setq #sql$
      (append #sql$
        (list
          (list "検索KEY1" &key1 'STR)
        )
      )
    )
  )
  (if (/= &key2 nil)
    (setq #sql$
      (append #sql$
        (list
          (list "検索KEY2" &key2 'STR)
        )
      )
    )
  )
  (if (/= &key3 nil)
    (setq #sql$
      (append #sql$
        (list
          (list "検索KEY3" &key3 'STR)
        )
      )
    )
  )
  (if (/= &key4 nil)
    (setq #sql$
      (append #sql$
        (list
          (list "検索KEY4" &key4 'STR)
        )
      )
    )
  )
  ;// プラ管OPテーブルを検索する
;;;  (setq #qry$ (car (CFGetDBSQLRec CG_DBSESSION "プラ管OP" #sql$))) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD ; 01/11/26 YM MOD
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "プラ管OP" #sql$)) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD  ; 01/11/26 YM MOD

  (if (= #qry$ nil)
    (progn
      (setq #msg (strcat "『プラ管OP』にレコードがありません。\nSKG_GetOptionHinban")) ; 01/11/26 YM MOD
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    (progn
      (setq #qry$ (car #qry$))

      (setq #sql (strcat "select * from プラ構OP where \"OPTID\"=")) ; 01/11/26 YM MOD
      (setq #sql (strcat #sql (rtois (car #qry$))))    ;オプション管理ＩＤで検索
      (setq #sql (strcat #sql " order by \"RECNO\""))  ;レコード番号で昇順

      ;// オプション管理IDでプラ構OPテーブルを検索する
      (setq #opt$$
        (CFGetDBSQLRec CG_DBSESSION "プラ構OP"    ;"VISUAL LISPの表示がおかしい ; 01/11/26 YM MOD
          (list
            (list "OPTID" (rtois (car #qry$)) 'INT)
          )
        )
      );_(setq

      (if (= #opt$$ nil)
        (progn
          (setq #msg (strcat "『プラ構OP』にレコードがありません。\nSKG_GetOptionHinban")) ; 01/11/26 YM MOD
          (CMN_OutMsg #msg) ; 02/09/05 YM ADD
        )
      );_if

      (foreach #opt$ #opt$$
        (setq #hinban$ (append #hinban$ (list (caddr #opt$))))
      )
      ;// 品番のリストを返す
      #hinban$
    )
  );_if
);SKG_GetOptionHinban

;<HOM>*************************************************************************
; <関数名>    : SKG_GetOptionHinbanFIRL
; <処理概要>  : オプション品の品番を取得する(天井ﾌｨﾗｰ用)
; <戻り値>    : 品番のリスト
; <作成>      : 01/12/18 YM
; <備考>      : SKG_GetOptionHinbanを使い回しできないので新規作成
;*************************************************************************>MOH<
(defun SKG_GetOptionHinbanFIRL (
  &key1 ;(STR) 天井ﾌｨﾗｰの場合------天井ﾌｨﾗｰの取り付けコード
  /
  #HINBAN$ #LISTCODE #MSG #OPT$$ #QRY$ #SQL #SQL$
  )
  ; オプション品管理ＤＢを検索する
  (setq #listCode nil)
  (setq #sql$
    (list
      (list "SERIES記号" CG_SeriesCode 'STR)
      (list "ユニット記号" CG_UnitCode   'STR)
      (list "OP品区分"     "2"  'INT) ; 2 固定
      (list "検索KEY1" &key1 'STR)
    )
  )
  ;// プラ管OPテーブルを検索する
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "プラ管OP" #sql$))

  (if (= #qry$ nil)
    (progn
      (setq #msg (strcat "『プラ管OP』にレコードがありません。\SKG_GetOptionHinbanFIRL"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    (progn
      (setq #qry$ (car #qry$))
      (setq #sql (strcat "select * from プラ構OP where \"OPTID\"=")) ; 01/11/26 YM MOD
      (setq #sql (strcat #sql (rtois (car #qry$))))    ;オプション管理ＩＤで検索
      (setq #sql (strcat #sql " order by \"RECNO\""))  ;レコード番号で昇順

      (setq CG_OPTID (rtois (car  #qry$))) ; オプション管理IDｸﾞﾛｰﾊﾞﾙ追加

      ;// オプション管理IDでプラ構OPテーブルを検索する
      (setq #opt$$
        (CFGetDBSQLRec CG_DBSESSION "プラ構OP"    ;"VISUAL LISPの表示がおかしい ; 01/11/26 YM MOD
          (list
            (list "OPTID" CG_OPTID 'INT)
          )
        )
      )

      (if (= #opt$$ nil)
        (progn
          (setq #msg (strcat "『プラ構OP』にレコードがありません。\SKG_GetOptionHinbanFIRL"))
          (CMN_OutMsg #msg) ; 02/09/05 YM ADD
        )
      );_if

      (foreach #opt$ #opt$$
        (setq #hinban$ (append #hinban$ (list (caddr #opt$))))
        (setq CG_RECNO$ (append CG_RECNO$ (list (rtois (cadr #opt$))))) ; RECNOｸﾞﾛｰﾊﾞﾙ追加
      )
      ;// 品番のリストを返す
      #hinban$
    )
  );_if
);SKG_GetOptionHinbanFIRL

;;;<HOM>*************************************************************************
;;; <関数名>    : PKC_ModelLayout
;;; <処理概要>  : キッチン構成部材自動配置
;;; <戻り値>    :
;;; <作成>      : 2000.1.修正KPCAD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKC_ModelLayout (
  /
  #pln$$ #res #wtrno #i #SNK_OK #loop #ss #SYM
  )
  (regapp "G_SYM")
  (regapp "G_LSYM")

  (WebOutLog "(PKC_ModelLayout)の中")

  ;// ファミリー品番文字列よりプラン構成情報を取得
  (WebOutLog "[ﾌﾟﾗ管理][ﾌﾟﾗ構成]の検索(PKC_GetPlan)")
  (setq #pln$$ (PKC_GetPlan))   ;プラン構成テーブルのリスト

  (PKC_LayoutParts #pln$$)

  ;// プラン検索【シンク自動配置】

	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn ;2017/09/07 YM ADD

		  ;// ｴﾝﾄﾞﾊﾟﾈﾙの取付け
		  (if (and (/= (nth 45 CG_GLOBAL$) "N")(/= (nth 45 CG_GLOBAL$) "X"));ｴﾝﾄﾞﾊﾟﾈﾙ取付ける
		    (KP_PutEndPanel_FK) ;ﾌﾚｰﾑｷｯﾁﾝ
		  );_if

		)
		(progn
			
		  (setq #SNK_OK nil) ; ｼﾝｸ配置を行う = T
		  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
		  (if (and #ss (> (sslength #ss) 0))
		    (progn
		      (setq #i 0 #loop T)
		      (while (and #loop (< #i (sslength #ss)))
		        (setq #sym (ssname #ss #i))
		        (if (and (= CG_SKK_ONE_CAB (CFGetSymSKKCode #sym 1))
		                 (= CG_SKK_TWO_BAS (CFGetSymSKKCode #sym 2))
		                 (= CG_SKK_THR_SNK (CFGetSymSKKCode #sym 3)))
		          (setq #SNK_OK T #loop nil) ; 図面上にｼﾝｸｷｬﾋﾞがある
		        );_if
		        (setq #i (1+ #i))
		      )
		      (if #SNK_OK
		        (progn
		          (PKC_LayoutSink);;// プラン検索【シンク自動配置】
		        )
		      ) ; <pclosnk.lsp>
		    );while
		  );_if

		  ;// ｴﾝﾄﾞﾊﾟﾈﾙの取付け
		  (if (and (/= (nth 45 CG_GLOBAL$) "N")(/= (nth 45 CG_GLOBAL$) "X"));ｴﾝﾄﾞﾊﾟﾈﾙ取付ける
		    (KP_PutEndPanel)
		  );_if

		) ;2017/09/07 YM ADD
	);_if


  ;// ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝの配置 2009/10/26 YM ADD
  (WebOutLog "--- ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝの配置 ---")
  (PKW_GLASS_PARTISYON)



  ;//【ミラー反転】;2008/06/23 YM MOD
  (if (/= (nth 11 CG_GLOBAL$) "L");初期値左勝手
    (PKC_MirrorParts)
  );_if


;ゆったり
;;;(defun PK_Yuttari_Plan (

	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn ;2017/09/07 YM ADD
			nil
		)
		(progn
			
		  ;ﾏﾙﾁｼﾝｸのｷｬﾋﾞﾈｯﾄｶｯﾄ処理 2008/07/28 YM ADD
		  (MultiCabCut)

		) ;2017/09/07 YM ADD
	);_if

  ;// シンク、ガス関連機器の側面図をそれぞれシンクキャビ、
  ;// ガスキャビにの基点に移動させる
  ;//   本処理はシンク（ガス）キャビ等の断面指示によりシンク（ガス）が
  ;//   隠線処理で隠れてしまうのを防ぐためである

;2008/06/23 YM DEL
  (PKC_MoveToSGCabinet)


  (princ)
);PKC_ModelLayout

;<HOM>*************************************************************************
; <関数名>    : PDC_ModelLayout
; <処理概要>  : 収納部材自動配置
; <戻り値>    :
; <作成>      : 08/09/11 YM
; <備考>      :
;*************************************************************************>MOH<
(defun PDC_ModelLayout (
  /
  #PLN$$
  )
  (regapp "G_SYM")
  (regapp "G_LSYM")

  (WebOutLog "(PDC_ModelLayout)の中")

  ;// ファミリー品番文字列よりプラン構成情報を取得
  (WebOutLog "[ﾌﾟﾗ管理][ﾌﾟﾗ構成]の検索(PDC_GetPlan)")
  (setq #pln$$ (PDC_GetPlan))   ;プラン構成テーブルのリスト

  (PKC_LayoutParts #pln$$)

  ;// ｴﾝﾄﾞﾊﾟﾈﾙの取付け
;;;; (setq CG_UpCabHeight 2350)

  (if (and (/= (nth 71 CG_GLOBAL$) "N")(/= (nth 71 CG_GLOBAL$) "X"));ｴﾝﾄﾞﾊﾟﾈﾙ取付ける
    (KP_PutEndPanel_D);収納 ｴﾝﾄﾞﾊﾟﾈﾙの取付け
  );_if

  ;//【ミラー反転】;2008/06/23 YM MOD
  (if (= (nth 56 CG_GLOBAL$) "R");初期値左勝手 or "N"のときもある。"R"のときに反転する
    (PKC_MirrorParts)
  );_if

  (princ)
);PDC_ModelLayout

;<HOM>*************************************************************************
; <関数名>    : PDC_ModelLayout_EXTEND
; <処理概要>  : 収納部材自動配置
; <戻り値>    :
; <作成>      : 2009/11/18 YM
; <備考>      : 収納拡大 WK_SDB用
;*************************************************************************>MOH<
(defun PDC_ModelLayout_EXTEND (
  /
  #PLN$$
  )
  (regapp "G_SYM")
  (regapp "G_LSYM")

  (WebOutLog "(PDC_ModelLayout_EXTEND)の中")

  ;// ファミリー品番文字列よりプラン構成情報を取得
  (WebOutLog "[ﾌﾟﾗ管理][ﾌﾟﾗ構成]の検索(PDC_GetPlan_EXTEND)")
  (setq #pln$$ (PDC_GetPlan_EXTEND))   ;プラン構成テーブルのリスト

  ;部材を[ﾌﾟﾗ構成]通りに配置 下台+上台
  (PKC_LayoutParts #pln$$)

  ;//【ミラー反転】;2008/06/23 YM MOD
  (if (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "R");初期値左勝手 or "N"のときもある。"R"のときに反転する
    (progn
      (PKC_MirrorParts)
      (PKC_MoveParts)
    )
  );_if


  ;ｴﾝﾄﾞﾊﾟﾈﾙの取付け
;;; (setq CG_UpCabHeight 2350)

  (if (and (/= (nth (+ (* 100 CG_D_EXTEND_KAI) 71) CG_GLOBAL$) "N")
           (/= (nth (+ (* 100 CG_D_EXTEND_KAI) 71) CG_GLOBAL$) "X"));ｴﾝﾄﾞﾊﾟﾈﾙ取付ける
    (KP_PutEndPanel_D_EXTEND);収納 ｴﾝﾄﾞﾊﾟﾈﾙの取付け
  );_if

  ;初回のみ 開始ｴﾝﾄﾞﾊﾟﾈﾙの取付け
  (if (= CG_D_EXTEND_KAI 1)
    (progn
      (if (and (/= (nth 71 CG_GLOBAL$) "N")
               (/= (nth 71 CG_GLOBAL$) "X")) ;開始ｴﾝﾄﾞﾊﾟﾈﾙ取付ける
        (KP_PutEndPanel_D_EXTEND_START) ;収納 開始ｴﾝﾄﾞﾊﾟﾈﾙの取付け
      );_if
    )
  );_if

  ;;---------------------------------------------------------------------------------
  ;; PDC_ModelLayout_EXTEND の外から中に処理を移動
  ;;---------------------------------------------------------------------------------
  (command "_layer" "T" "*" "")
  (WebDefErrFunc) ; ｴﾗｰ関数定義(02/09/11 YM 関数化)

  ;// 天井ﾌｨﾗｰの作成
  (if (and (/= (nth 72 CG_GLOBAL$) "N")(/= (nth 72 CG_GLOBAL$) "X"));天井ﾌｨﾗｰ取付ける
    (progn
      (WebOutLog "--- 天井ﾌｨﾗｰの作成(PKW_UpperFiller)を呼ぶ ---")

      ;2009/11/21 YM ADD 収納拡大 SDBはﾌｨﾗｰ左右あり
      (setq SKW_FILLER_LSIDE 1)
      (setq SKW_FILLER_RSIDE 1)
      (setq SKW_FILLER_BSIDE 0)
      (PKW_UpperFiller);現在天井ﾌｨﾗｰ="A"のみ
    )
  );_if



  ;2011/04/22 YM ADD-S OP置換の仕組みを導入
  ;吊戸手掛かりあり/なし
  (KP_ChgCab)  ;新ﾛｼﾞｯｸ 性格ｺｰﾄﾞに依存しない


  ;// 表示画層の設定
  (SetLayer)

  ;dwg保存
  (command "_saveas" "" (strcat CG_SYSPATH "plan" (itoa CG_D_EXTEND_KAI) ".dwg"))

  (princ)
);PDC_ModelLayout_EXTEND

;;;<HOM>*************************************************************************
;;; <関数名>    : PKC_GetPlan
;;; <処理概要>  : プラン構成情報取得
;;; <戻り値>    :
;;;        LIST : ソートされた『プラ構成』情報リスト(レコードのリスト)
;;; <作成>      : 2000.1.19修正KPCAD
;;; <備考>      : なし
;;;*************************************************************************>MOH<
(defun PKC_GetPlan (
  /
  #QRY$$ #QRY1$$ #QRY2$$ #QRY1$ #RET$
  )
  (setq #qry1$$ '())
  (setq #qry2$$ '())

;;; 構成タイプ=1  (フロア配置にフラグ)
(WebOutLog "--- (PFGetCompBase)を呼ぶ ---")

  (setq #ret$ (PFGetCompBase))
  (setq #qry1$  (car  #ret$));プラ管理
  (setq #qry1$$ (cadr #ret$));プラ構成

(WebOutLog "[ﾌﾟﾗ管理]")
(WebOutLog #qry1$)
(WebOutLog "[ﾌﾟﾗ構成]")
(WebOutLog #qry1$$)


;;; 構成タイプ=2  (ウォール配置フラグにフラグ)

  (if (/= "N" (nth 32 CG_GLOBAL$))
    (progn ;吊戸なし以外
      (WebOutLog "--- (PFGetCompUpper)を呼ぶ ---")
      (setq #qry2$$ (PFGetCompUpper #qry1$))
      (WebOutLog #qry2$$)
    )
  )

  (setq #qry$$ (append #qry1$$ #qry2$$))
  #qry$$ ; 戻り値
);PKC_GetPlan


;;;<HOM>*************************************************************************
;;; <関数名>    : PDC_GetPlan
;;; <処理概要>  : プラン構成情報取得(収納)
;;; <戻り値>    :
;;;        LIST : ソートされた『プラ構成』情報リスト(レコードのリスト)
;;; <作成>      : 2008/09/11 YM
;;; <備考>      : WK_SDA用
;;;*************************************************************************>MOH<
(defun PDC_GetPlan (
  /
  #DB_NAME #LIST$$ #MSG #PLAN_ID #QRY$ #QRY$$ #QRY1$$ #QRY2$$
  )
  (setq #qry1$$ '())
  (setq #qry2$$ '())

  (WebOutLog "--- [ﾌﾟﾗ管理][ﾌﾟﾗ構成]を検索 ---")

  ;[プラ管理]
  (setq #LIST$$
    (list
      (list "ユニット記号"   (nth 51 CG_GLOBAL$) 'STR)
      (list "奥行き"         (nth 53 CG_GLOBAL$) 'STR)
      (list "タイプ"         (nth 54 CG_GLOBAL$) 'STR)
      (list "収納間口"       (nth 55 CG_GLOBAL$) 'STR)
      (list "カウンター色"   (nth 57 CG_GLOBAL$) 'STR)
      (list "SOFT_CLOSE"     (nth 58 CG_GLOBAL$) 'STR)
      (list "アルミ枠ガラス" (nth 59 CG_GLOBAL$) 'STR)
    )
  )
  (setq #DB_NAME "プラ管理")
  (WebOutLog (strcat "検索DB名= "  #DB_NAME))

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$)
  )

  (setq #qry$ (DBCheck #qry$ "『プラ管理』" "PDC_GetPlan")) ; 検索結果WEB版ﾛｸﾞ出力

  ; プランID
  (setq #plan_id (nth 0 #qry$))

  ;[プラ構成]
  (setq #DB_NAME "プラ構成")
  (WebOutLog (strcat "検索DB名= "  #DB_NAME))

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME
      (list
        (list "プランID"  #plan_id  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  (if (= #qry$$ nil)
    (progn
      (setq #msg (strcat "『プラ構成』にレコードがありません。\PDC_GetPlan"))
      (cond
        ((or (= CG_AUTOMODE 0)(= CG_AUTOMODE 1)) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
          (CMN_OutMsg #msg)
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog #msg)
          (quit)
        )
      );_cond
    )
  );_if

  (WebOutLog "[ﾌﾟﾗ管理]")
  (WebOutLog #qry$)
  (WebOutLog "[ﾌﾟﾗ構成]")
  (WebOutLog #qry$$)

  #qry$$ ; 戻り値

);PDC_GetPlan


;;;<HOM>*************************************************************************
;;; <関数名>    : PDC_GetPlan_EXTEND
;;; <処理概要>  : プラン構成情報取得(収納)
;;; <戻り値>    :
;;;        LIST : ソートされた『プラ構成』情報リスト(レコードのリスト)
;;; <作成>      : 2008/09/11 YM
;;; <備考>      : WK_SDA用
;;;*************************************************************************>MOH<
(defun PDC_GetPlan_EXTEND (
  /
  #PLAN_ID_BASE #PLAN_ID_UPPER #QRY1$$ #QRY2$$ #QRY_BASE$ #QRY_BASE$$ #QRY_UPPER$
  #QRY_UPPER$$ #RET
  )
  (setq #qry1$$ '())
  (setq #qry2$$ '())

  (WebOutLog "--- [ﾌﾟﾗ管理][ﾌﾟﾗ構成]を検索 ---")

  ;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
  ;[プラ管理]下台構成 構成ﾀｲﾌﾟ=1
  (setq #qry_BASE$ ;nilの場合(上台のみ)も許す
    (CFGetDBSQLRec CG_DBSESSION "プラ管理"
      (list
        (list "ユニット記号"   (nth  51 CG_GLOBAL$) 'STR);共通
        (list "基本構成"       (nth (+ (* 100 CG_D_EXTEND_KAI) 54) CG_GLOBAL$) 'STR)
        (list "構成タイプ"     "1"                  'INT)
        (list "収納間口"       (nth (+ (* 100 CG_D_EXTEND_KAI) 55) CG_GLOBAL$) 'STR)
        (list "奥行き"         (nth (+ (* 100 CG_D_EXTEND_KAI) 53) CG_GLOBAL$) 'STR)
        (list "SOFT_CLOSE"     (nth  58 CG_GLOBAL$) 'STR);共通
        (list "アルミ枠ガラス" (nth (+ (* 100 CG_D_EXTEND_KAI) 59) CG_GLOBAL$) 'STR);中台
        (list "カウンター色"   (nth (+ (* 100 CG_D_EXTEND_KAI) 57) CG_GLOBAL$) 'STR)
      )
    )
  )
  (if #qry_BASE$
    (progn ;ﾚｺｰﾄﾞあり
      (setq #qry_BASE$ (DBCheck #qry_BASE$ "『プラ管理』" "PDC_GetPlan_EXTEND")) ; 検索結果WEB版ﾛｸﾞ出力
      ; プランID
      (setq #plan_id_BASE (nth 0 #qry_BASE$))
    )
    (progn ;ﾚｺｰﾄﾞなし
      (setq #plan_id_BASE "")
    )
  );if

  ;[プラ構成]下台構成 構成ﾀｲﾌﾟ=1
  (setq #qry_BASE$$ ;nilの場合(上台のみ)も許す
    (CFGetDBSQLRec CG_DBSESSION "プラ構成"
      (list
        (list "プランID"  #plan_id_BASE  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  ;★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
  ;[プラ管理]上台構成 構成ﾀｲﾌﾟ=2
  (setq #qry_UPPER$ ;nilの場合(下台のみ)も許す
    (CFGetDBSQLRec CG_DBSESSION "プラ管理"
      (list
        (list "ユニット記号"   (nth  51 CG_GLOBAL$) 'STR)
        (list "上台構成"       (nth (+ (* 100 CG_D_EXTEND_KAI) 61) CG_GLOBAL$) 'STR)
        (list "構成タイプ"     "2"                  'INT)
        (list "収納間口"       (nth (+ (* 100 CG_D_EXTEND_KAI) 55) CG_GLOBAL$) 'STR)
        (list "SOFT_CLOSE"     (nth  58 CG_GLOBAL$) 'STR);共通
      )
    )
  )
  (if #qry_UPPER$
    (progn ;ﾚｺｰﾄﾞあり
      (setq #qry_UPPER$ (DBCheck #qry_UPPER$ "『プラ管理』" "PDC_GetPlan_EXTEND")) ; 検索結果WEB版ﾛｸﾞ出力
      ; プランID
      (setq #plan_id_UPPER (nth 0 #qry_UPPER$))
    )
    (progn ;ﾚｺｰﾄﾞなし
      (setq #plan_id_UPPER "")
    )
  );if

  ;[プラ構成]下台構成 構成ﾀｲﾌﾟ=1
  (setq #qry_UPPER$$ ;nilの場合(上台のみ)も許す
    (CFGetDBSQLRec CG_DBSESSION "プラ構成"
      (list
        (list "プランID"  #plan_id_UPPER  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  (WebOutLog "[ﾌﾟﾗ管理]下台構成")
  (WebOutLog #qry_BASE$)
  (WebOutLog "[ﾌﾟﾗ構成]下台構成")
  (WebOutLog #qry_BASE$$)

  (WebOutLog "[ﾌﾟﾗ管理]上台構成")
  (WebOutLog #qry_UPPER$)
  (WebOutLog "[ﾌﾟﾗ構成]上台構成")
  (WebOutLog #qry_UPPER$$)

  (setq #ret (append #qry_BASE$$ #qry_UPPER$$)) ; 戻り値
  #ret ;下台＋上台の構成
);PDC_GetPlan_EXTEND

;;;<HOM>*************************************************************************
;;; <関数名>    : PKC_MoveToSGCabinet
;;; <処理概要>  : 側面Ｌ、Ｒの図形のみを指定図形の側面に移動させる
;;; <戻り値>    :
;;; <作成>      : 1999-04-20
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKC_MoveToSGCabinet (
  /
  #ss #i #en #xd$ #skk
  )
	(setq CG_SnkSym nil)
	(setq CG_GasSym nil)
	
  (setq #ss (ssget "X" '((-3 ("G_SYM")))))
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i))
    (setq #skk (CFGetSymSKKCode #en 3)) ; 指定部材の性格CODEを取得する

    (cond
      ((= #skk CG_SKK_THR_SNK)          ;シンクキャビネットの場合  CG_SKK_THR_SNK = 2
        (setq CG_SnkSym #en)
      )
      ((= #skk CG_SKK_THR_GAS)          ;ガスキャビネットの場合  CG_SKK_THR_GAS = 3
        (setq CG_GasSym #en)
      )
    )
    (setq #i (1+ #i))
  )

  (setq #i 0)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i))
    (setq #skk (CFGetSymSKKCode #en 1)) ; 指定部材の性格CODEを取得する
    (cond
      ((or (= #skk CG_SKK_ONE_WTR) (= #skk CG_SKK_ONE_SNK))     ;シンク関連機器の場合 5,4
        (PKC_MoveToSGCabinetSub #en CG_SnkSym)
      )
      ((= #skk CG_SKK_ONE_GAS)     ;ガス関連機器の場合
        (PKC_MoveToSGCabinetSub #en CG_GasSym)
      )
    )
    (setq #i (1+ #i))
  )
);PKC_MoveToSGCabinet

;;;<HOM>*************************************************************************
;;; <関数名>    : PKC_MoveToSGCabinetSub
;;; <処理概要>  : 側面Ｌ、Ｒの図形のみを指定図形の側面に移動させる
;;; <戻り値>    :
;;; <作成>      : 1999-04-20
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKC_MoveToSGCabinetSub (
  &sym1        ;移動させるシンボル（シンク、水栓、ガスコンロ）
  &sym2        ;移動基準となるシンボル（シンクキャビ、ガスキャビ）
  /
  #en$ #i #ss #lay #p1 #p2 #dst #ang #DUMPT #P11
  )

  ;// 同一のグループの図形を取り出す
  (setq #en$ (CFGetGroupEnt &sym1))
  ;// 側面の図形のみ抜き出す
  (setq #i 0)
  (setq #ss (ssadd))
  (foreach #en #en$
    (setq #lay (cdr (assoc 8 (entget #en))))
;;;    (if (wcmatch #lay "Z_05*,Z_06*")         @YM@ 00/01/27 )
    (if #lay
      (if (wcmatch #lay "Z_05*,Z_06*")
        (ssadd #en #ss)
      )
    );_if
    (setq #i (1+ #i))
  )

  ;// 側面のデータを移動させる
  (setq #p1 (cdr (assoc 10 (entget &sym1))))
  (setq #p1 (list (car #p1) (cadr #p1)))
  (setq #p2 (cdr (assoc 10 (entget &sym2))))
  (setq #p2 (list (car #p2) (cadr #p2)))
  (setq #ang (nth 2 (CFGetXData &sym2 "G_LSYM")))
  ; 仮想点
  (setq #dumPT (polar #p2 #ang 1000))
  (setq #p11 (CFGetDropPt #p1 (list #dumPT #p2)))

  ; 2000/09/01 HT 90度単位の方向以外に対応 MOD START
  ;(if (equal #ang 0.0 0.0000001)
  ;  (setq #ang pi)
  ;)
  ;距離を求める
  ;(setq #dp1 (polar #p1 (* -1 #ang) 1))
  ;(setq #dp2 (polar #p2 (+ #ang (dtr 90)) 1))
  ;(setq #cp (inters #p1 #dp1 #p2 #dp2 nil))
  ;(setq #cp (list (car #cp) (cadr #cp)))
  ;(setq #dst (distance #p1 #cp))
  ;(command "move" #ss "" #p1 #cp)
  (setq #dst (distance #p11 #p2))
  ; シンク(ガス)をシンク(ガス)キャビネット方向へ移動
  (if (/= (sslength #ss) 0)  ; 2000/10/19 HT
    (command "move" #ss "" (list (* #dst (- (cos #ang))) (* #dst (- (sin #ang)))) "")
    (princ "移動するシンクorガス図形がありません。")
  );_if

	(setq CG_SnkSym nil)
	(setq CG_GasSym nil)

  (princ)
  ; 2000/09/01 HT 90度単位の方向以外に対応 MOD END
);PKC_MoveToSGCabinetSub

;;;<HOM>*************************************************************************
;;; <関数名>     : PKC_LayoutParts
;;; <処理概要>   : プラン構成部材配置
;;; <戻り値>     :
;;; <作成>       : 2000.1.18修正 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun PKC_LayoutParts (
  &pln$$   ;(LIST)『プラ構成』情報リスト
  /
  #I #RNO #SD #SH #SW #SYM #XD$ #XD2$ #ret$ #pmen2 #PMEN2$
  )

  (WebOutLog "--- (PKC_LayoutParts)の中 ---")

  ;// レコード順に以下の処理を行う
  (setq #rno 1) ; record Number

  (foreach #pln$ &pln$$ ; 部材配置のループ

    (if (= CG_AUTOMODE 2)
      nil  ; Web版CADｻｰﾊﾞｰﾓｰﾄﾞ
      ;else
      (progn
        (command "_zoom" "e")
      )
    );_if

    ;// 『プラ構成』.商品タイプが０の場合は単独図形、それ以外は複合図形とする
    (if (= (fix (nth 6 #pln$)) 0)  ; 商品タイプが０  単独図形
      (progn
        (princ "####################################")
        (princ (strcat "単独部材=[" (nth 2 #pln$) "]"))
        (princ "####################################")

        (WebOutLog "####################################")
        (WebOutLog (strcat "単独部材=[" (nth 2 #pln$) "]"))
        (WebOutLog "####################################")

        ;// 単独部材配置
        (setq #ret$ (PKC_LayoutOneParts #pln$ #rno)) ; 拡張データを返す
        (setq #xd$ (car  #ret$))
        (setq #sym (cadr #ret$))

        (if (/= #xd$ nil)
          (progn

            (setq #xd2$ (CFGetXData #sym "G_SYM"))
            (setq #sw (fix (nth 14 #pln$))) ; 伸縮Ｗ OK!
            (setq #sd (fix (nth 15 #pln$))) ; 伸縮Ｄ OK!
            (setq #sh (fix (nth 16 #pln$))) ; 伸縮Ｈ OK!

            ;// 部材の拡張ﾃﾞｰﾀのｻｲｽﾞを更新
            (WebOutLog "拡張ﾃﾞｰﾀ G_SYM を更新します") ; 02/09/04 YM ADD
            (CFSetXData #sym "G_SYM"
              (list
;;;                (nth 0 #xd2$)    ;シンボル名称
                ;2009/04/14 YM MOD
                "DUM"    ;シンボル名称

                (nth 1 #xd2$)    ;コメント１
                (nth 2 #xd2$)    ;コメント２
                (if (= #sw 0) (nth 3 #xd2$) #sw)   ;シンボル基準値Ｗ
                (if (= #sd 0) (nth 4 #xd2$) #sd)   ;シンボル基準値Ｄ
                (if (= #sh 0) (nth 5 #xd2$) #sh)   ;シンボル基準値Ｈ
                (nth 6 #xd2$)    ;シンボル取付け高さ
                (nth 7 #xd2$)    ;入力方法
                (nth 8 #xd2$)    ;Ｗ方向フラグ
                (nth 9 #xd2$)    ;Ｄ方向フラグ
                (nth 10 #xd2$)   ;Ｈ方向フラグ
                (nth 14 #pln$)   ;伸縮フラグＷ OK!
                (nth 15 #pln$)   ;伸縮フラグＤ OK!
                (nth 16 #pln$)   ;伸縮フラグＨ OK!
                (nth 14 #xd2$)   ;ブレークライン数Ｗ
                (nth 15 #xd2$)   ;ブレークライン数Ｄ
                (nth 16 #xd2$)   ;ブレークライン数Ｈ
              )
            )
            (CFSetXData #sym "G_LSYM" #xd$) ; PKC_LayoutOneParts の戻り値

            ; @@@ ｺｰﾅｰｷｬﾋﾞ"115"はPMEN2の頂点数をﾁｪｯｸする 01/06/19 YM ADD START
            (if (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_CNR))) ; ｺｰﾅｰｷｬﾋﾞﾍﾞｰｽ ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
              (KP_MakeCornerPMEN2 #sym)
            );_if
            (if (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB)(itoa CG_SKK_TWO_UPP)(itoa CG_SKK_THR_CNR))) ; ｺｰﾅｰｷｬﾋﾞｱｯﾊﾟｰ ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
              (progn
                (setq #pmen2$ (KP_MakeCornerPMEN2 #sym))
                (if #pmen2$
                  (foreach #pmen2 #pmen2$
                    (command "_move" #pmen2 "" '(0 0 0)
                      (strcat "@0,0," (rtos (nth 6 #xd2$))) ; シンボル取付け高さ
                    )
                  )
                );_if
              )
            );_if
            ; @@@ ｺｰﾅｰｷｬﾋﾞ"115"はPMEN2の頂点数をﾁｪｯｸする 01/06/19 YM ADD END


            ;2011/02/01 YM MOD 勝手を見ずに常にｾｯﾄ
            (KcSetG_OPT #sym) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ


;;; 2011/02/01YM@DEL            ;;; 左勝手(ﾐﾗｰ反転必要)のときは PKC_MirrorPartsSub でｾｯﾄする
;;; 2011/02/01YM@DEL            ;;; 右勝手(ﾐﾗｰ反転不要)のときにここでｾｯﾄする
;;; 2011/02/01YM@DEL
;;; 2011/02/01YM@DEL            (if (= CG_PlanType "SK")
;;; 2011/02/01YM@DEL              (progn
;;; 2011/02/01YM@DEL                ;ｷｯﾁﾝ用処理 ;2008/09/14 YM ADD
;;; 2011/02/01YM@DEL                (if (= (nth 11 CG_GLOBAL$) "L");デフォルト左勝手の場合
;;; 2011/02/01YM@DEL                  (KcSetG_OPT #sym) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ
;;; 2011/02/01YM@DEL                );_if
;;; 2011/02/01YM@DEL              )
;;; 2011/02/01YM@DEL              (progn
;;; 2011/02/01YM@DEL              
;;; 2011/02/01YM@DEL                (cond
;;; 2011/02/01YM@DEL                  ((= CG_SeriesDB "SDA")
;;; 2011/02/01YM@DEL                    ;収納用処理 ;2008/09/14 YM ADD
;;; 2011/02/01YM@DEL                    (if (or (= (nth 56 CG_GLOBAL$) "L")(= (nth 56 CG_GLOBAL$) "N"))
;;; 2011/02/01YM@DEL                      (KcSetG_OPT #sym) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ
;;; 2011/02/01YM@DEL                    );_if
;;; 2011/02/01YM@DEL                  )
;;; 2011/02/01YM@DEL                  ((= CG_SeriesDB "SDB");2009/12/1 YM ADD 収納拡大
;;; 2011/02/01YM@DEL                    (if (or (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "L")
;;; 2011/02/01YM@DEL                            (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "N")
;;; 2011/02/01YM@DEL                            (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "Z"))
;;; 2011/02/01YM@DEL                      (KcSetG_OPT #sym) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ
;;; 2011/02/01YM@DEL                    );_if
;;; 2011/02/01YM@DEL                  )
;;; 2011/02/01YM@DEL                  (T
;;; 2011/02/01YM@DEL                    (if (or (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "L")
;;; 2011/02/01YM@DEL                            (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "N")
;;; 2011/02/01YM@DEL                            (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "Z"))
;;; 2011/02/01YM@DEL                      (KcSetG_OPT #sym) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ
;;; 2011/02/01YM@DEL                    );_if
;;; 2011/02/01YM@DEL                  )
;;; 2011/02/01YM@DEL                );_cond
;;; 2011/02/01YM@DEL
;;; 2011/02/01YM@DEL              )
;;; 2011/02/01YM@DEL            );_if



          )
        )
      )
    ;else
      (progn                 ;複合図形
        (princ "####################################")
        (princ (strcat "複合部材=[" (nth 2 #pln$) "]"))
        (princ "####################################")

        (WebOutLog "####################################")
        (WebOutLog (strcat "複合部材=[" (nth 2 #pln$) "]"))
        (WebOutLog "####################################")

        ;// 複合ダミー図形を仮配置しておく
        (PKC_LayoutBlockParts #pln$ #rno)
      )
    )
    (setq #rno (1+ #rno))

  );foreach

  (princ)
);PKC_LayoutParts

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_Stretch_SidePanel
;;; <処理概要>  : ﾌﾟﾗﾝ検索収納部ｻｲﾄﾞﾊﾟﾈﾙ伸縮
;;; <戻り値>    :
;;; <作成>      : 2000.8.15 YM
;;; <備考>      : ﾗｯｸﾚｰﾙ：(735,180,40) 飾り縁：(1350,53,29)
;;;*************************************************************************>MOH<
(defun PK_Stretch_SidePanel (
  &sym      ;シンボル図形
  &val_w    ;寸法Ｗ
  &val_d    ;寸法Ｄ
  &val_h    ;寸法Ｈ
  /
  #VAL_D #VAL_H #VAL_W #XD$ #xld$
  #DPT #FANG #I #ORG$ #RTFLG #TMP$
  )

  (setq #xd$  (CFGetXData &sym "G_SYM"))
  (setq #xld$ (CFGetXData &sym "G_LSYM"))
  (setq #val_w (if (/= (nth 3 #xd$) &val_w) &val_w 0))
  (setq #val_d (if (/= (nth 4 #xd$) &val_d) &val_d 0))
  (setq #val_h (if (/= (nth 5 #xd$) &val_h) &val_h 0))

  ; 対象図形は0度または90度以外の場合、回転して0度に
  (setq #fANG (nth 2 #xld$))
  (if (or (equal 0 (RTD #fANG) 0.1) (equal 90 (RTD #fANG) 0.001))
    (setq #rtFLG nil)
    ; アイテム回転, LSYM 挿入角度変更, #xld$再設定
    (progn
      (setq #rtFLG 'T)
      (setq #dPT (cdr (assoc 10 (entget &sym))))
      (command "_rotate" (CFGetSameGroupSS &sym) "" #dPT "R" (RTD #fANG) 0 "")
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
  (StretchPartsSub &sym)
  ; フラグ確認 対象図形が伸縮処理前に回転されていたなら元の角度に戻す
  (if #rtFLG (progn
    (setq #dPT (cdr (assoc 10 (entget &sym))))
    (command "_rotate" (CFGetSameGroupSS &sym) "" #dPT "R" 0 (RTD #fANG) "")
    (CFSetXData &sym "G_LSYM" #ORG$)
  )); if&progn

  (princ)
);PK_Stretch_SidePanel

;;;<HOM>*************************************************************************
;;; <関数名>     : PKC_LayoutOneParts
;;; <処理概要>   : 単独部材配置
;;; <戻り値>     : 拡張データを返す
;;;         LIST : レイアウト時に設定される拡張データ
;;;                  1 :本体図形ID      :
;;;                  2 :挿入点          :
;;;                  3 :回転角度        :
;;;                  4 :工種記号        :
;;;                  5 :SERIES記号    :
;;;                  6 :品番名称        :
;;;                  7 :L/R区分         :
;;;                  8 :扉図形ID        :
;;;                  9 :扉開き図形ID    :
;;;                  10:性格CODE      :
;;;                  11:複合フラグ      :
;;;                  12:配置順番号      :
;;;                  13:用途番号        :
;;; <作成>       : 2000.1.18 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun PKC_LayoutOneParts (
  &pln$  ;(LIST)『プラ構成』情報  17 elements
  &recno ;(INT) 配置番号 integer
  /
  #FIG$ #FLG #HNO #LR #LSYM #POS$ #QRY$ #SEIKAKU #SYM #TWO #YNO #LIST$$
  #BASE_CODE #BASE_CODE$ #COUNTER$ #DD #EP_EXIST #EP_EXIST$ #PT #WW #HAND_SYM ;2009/11/30 YM ADD
  #CT_COL #HINBAN ;209/12/02 YM ADD
  )

  (setq #HNO (nth 2 &pln$))  ;品番名称   OK!
  (setq #LR  (nth 3 &pln$))  ;LR区分     OK!
  (setq #YNO (nth 5 &pln$))  ;用途番号   OK!

  (setq #LIST$$
    (list
      (list "品番名称"      #HNO           'STR) ; OK!
      (list "LR区分"        #LR            'STR) ; OK!
      (list "用途番号"      (rtois #YNO)   'INT) ; OK!
    )
  )

  (setq #fig$  ;  "品番図形"レコード
    (CFGetDBSQLHinbanTable "品番図形" #HNO ;品番名称
      #LIST$$
    )
  )

  (WebOutLog "品番図形  検索結果:")
  (setq #fig$ (DBCheck #fig$ "『品番図形』" "PKC_LayoutOneParts"))

  (setq #LIST$$
    (list
      (list "品番名称" #HNO 'STR)
    )
  )

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "品番基本" #LIST$$)
  )
  (setq #qry$ (DBCheck #qry$ "『品番基本』" "PKC_LayoutOneParts"))

  (setq #seikaku (fix (nth 3 #qry$))) ; 性格CODE
  (setq #two (CFGetSeikakuToSKKCode #seikaku 2))
  (setq #Flg T)
  (cond
;2008/07/26 YM DEL
;;;    ((= #two CG_SKK_TWO_BAS)  ;性格CODEがベース
;;;      (if (/= CG_UnitBase "1")
;;;        (setq #Flg nil)
;;;      )
;;;    )
    ((= #two CG_SKK_TWO_UPP)  ;性格CODEがアッパー
      (if (= (nth 32 CG_GLOBAL$) "N")
        (setq #Flg nil)
      )
    )
    (T
      (setq #Flg T)
    )
  );_cond

  (if (= #Flg nil)
    (progn
      nil
    )
  ;else
    (progn
  ;// プラン構成情報の配置方向 X/Y、原点からの距離 X/Y/Z、部材配置方向 W/D、
  ;// および伸縮値 X/Y/Z を参照して、該当する図形をモデル空間上に配置する
  ;// 『プラ構成』配置方向 X/Y :
  ;// 『プラ構成』原点からの距離 X/Y/Z :
  ;// 『プラ構成』部材配置方向 W/D :
  ;// 『プラ構成』伸縮値 W/D/H :
  ;// 『プラ構成』断面指示の有無 :
      (setq #pos$ (PKC_InsertParts &pln$ #fig$ #seikaku)) ; 部材挿入,分解,ｸﾞﾙｰﾌﾟ作成 戻り値=(配置原点,角度)
      (setq #sym (caddr #pos$))

      (setq #LSYM
        (list
          (nth 6 #fig$)         ;1 :本体図形ID      :『品番図形』.図形ID         ;2008/06/23 YM MOD
          (car   #pos$)         ;2 :挿入点          :配置基点
          (cadr  #pos$)         ;3 :回転角度        :配置回転角度
          CG_Kcode              ;4 :工種記号        :CG_Kcode
          CG_SeriesCode         ;5 :SERIES記号      :CG_SeriesCode
          (nth 0  #fig$)        ;6 :品番名称        :『品番図形』.品番名称       ;2008/06/23 YM MOD
          (nth 1  #fig$)        ;7 :L/R区分         :『品番図形』.部材L/R区分    ;2008/06/23 YM MOD
          ""                    ;8 :扉図形ID        :                            OK!
          ""                    ;9 :扉開き図形ID    :                            OK!
          (fix #seikaku)        ;10:性格CODE        :『品番基本』.性格CODE
          0                     ;11:複合フラグ      :０固定（単独部材）
          &recno                ;12:配置順番号      :配置順番号(1～)
          (fix (nth 2 #fig$))   ;13:用途番号        :『品番図形』.用途番号       ;2008/06/23 YM MOD
          (fix (nth 5 #fig$))   ;14:寸法Ｈ          :『品番図形』.寸法Ｈ         ;2008/06/23 YM MOD
          (fix (nth 17 &pln$))  ;15.断面指示の有無  :『プラ構成』.断面有無       OK!
          (GetBunruiAorD)       ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
        );_list
      )
    )
  );_if

  ;★★★ 収納拡大 ★★★
  ;2009/11/30 YM ADD 収納拡大のときｶｳﾝﾀｰ配置情報を残す
;;; (if (and (= "SD" CG_PlanType)
;;;          (/= CG_SeriesDB "SDA")) ;2011/02/01 YM MOD【PG分岐】
  (if (= BU_CODE_0006 "1") 
    (progn ;収納でSDA以外のとき

      (if (= 717 #seikaku)
        (progn ;収納拡大でｶｳﾝﾀｰなら
          ;;;<ﾘｽﾄ形式>
          ;;;1 列番号(1,2,3,..)
          ; CG_D_EXTEND_KAI
          ;;;2 奥行
          (setq #DD (nth (+ (* 100 CG_D_EXTEND_KAI) 53) CG_GLOBAL$))
          ;;;3 基本構成 種類CODE(A or B)
          (setq #BASE_CODE$
            (CFGetDBSQLRec CG_DBSESSION "Cカウンタ種類"
               (list
                 (list "基本構成" (nth (+ (* 100 CG_D_EXTEND_KAI) 54) CG_GLOBAL$) 'STR)
               )
            )
          )
          (setq #BASE_CODE$ (DBCheck #BASE_CODE$ "『Cカウンタ種類』" "\n PKC_LayoutOneParts"))
          (setq #BASE_CODE (nth 2 #BASE_CODE$))
          ;;;4 間口
          (setq #WW (nth (+ (* 100 CG_D_EXTEND_KAI) 55) CG_GLOBAL$))
          ;;;5 EP有無(Y or N)
          (setq #EP_EXIST$
            (CFGetDBSQLRec CG_DBSESSION "Cエンドパネル有無"
               (list
                 (list "エンドパネル" (nth (+ (* 100 CG_D_EXTEND_KAI) 71) CG_GLOBAL$) 'STR)
               )
            )
          )
          (setq #EP_EXIST$ (DBCheck #EP_EXIST$ "『Cエンドパネル有無』" "\n PKC_LayoutOneParts"))
          (setq #EP_EXIST (nth 2 #EP_EXIST$))
          (if (= CG_LAST CG_D_EXTEND_KAI);最終列は"N"を入れてﾊﾟﾈﾙなし扱いとする(ｶｳﾝﾀｰ接続判定に影響)
            (setq #EP_EXIST "N")
          );_if
          ;;;6 図形挿入基点
          (setq #PT (car   #pos$))
          ;;;7 シンボル図形ﾊﾝﾄﾞﾙ
;;;         (setq #hand_sym (cdr (assoc 5 (entget #sym))))

          ;8 品番名称
          (setq #hinban (nth 0  #fig$))
          ;9 ｶｳﾝﾀｰ色
          (setq #CT_COL (nth (+ (* 100 CG_D_EXTEND_KAI) 57) CG_GLOBAL$))

          (setq #counter$
            (list
              CG_D_EXTEND_KAI ;1 列番号(1,2,3,..)
              #DD             ;2 奥行
              #BASE_CODE      ;3 基本構成 種類CODE(A or B)
              #WW             ;4 間口
              #EP_EXIST       ;5 EP有無(Y or N)
              #sym            ;6 シンボル図形名ﾊﾝﾄﾞﾙ
              #hinban         ;7 品番名称
              #CT_COL         ;8 ｶｳﾝﾀｰ色
            )
          )
          ;Xdataに情報を格納
          (CFSetXData #sym "G_COUNTER" #counter$)
;;;         (setq CG_COUNTER_INFO$$ (append CG_COUNTER_INFO$$ (list #counter$ )))
        )
      );_if

    )
  );_if
  ;★★★　収納拡大　★★★

  (list #LSYM #sym)
);PKC_LayoutOneParts

;;;<HOM>*************************************************************************
;;; <関数名>     : PKC_InsertParts
;;; <処理概要>   : 部材を配置する
;;; <戻り値>     :   ;// 配置原点と角度を返す  (list #pos #ang)
;;;         LIST : (配置原点 配置角度)
;;; <作成>       : 2000.1.18修正 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun PKC_InsertParts (
  &pln$  ;(LIST)『プラ構成』情報
  &fig$  ;(LIST)『品番図形』情報
  &seikaku ; 性格CODE
  /
  #vct-x    ;配置方向 X
  #vct-y    ;配置方向 Y
  #op-x     ;原点からの距離 X
  #op-y     ;原点からの距離 Y
  #op-z     ;原点からの距離 Z
  #pts-w    ;部材の向き W
  #pts-d    ;部材の向き D
  #dim-w    ;寸法 W
  #ANG #ANG2 #DWG #ELM #N #POS #SSP #SYM #K #MSG
  )
  (setq #vct-x (nth 7 &pln$))  ; 方向ｘ
  (setq #vct-y (nth 8 &pln$))  ; 方向ｙ
  (setq #op-x  (nth 9 &pln$))  ; 距離ｘ
  (setq #op-y  (nth 10 &pln$)) ; 距離ｙ

  ;2011/03/24 YM ADD-S NZｸﾗｽは中間BOXがあるが、SAｸﾗｽは中間BOXがないので距離Yをつめないといけない
  (if CG_NO_BOX_FLG
    (setq #op-y (- #op-y CG_DIST_YY))
  );_if



  ;// アッパーキャビの判定       CG_SKK_TWO_UPP=2;アッパー(defined at GLOBAL.LSP)
;;;2008/09/11YM@DEL  (if (= CG_SKK_TWO_UPP (CFGetSeikakuToSKKCode &seikaku 2)) ; 性格CODEの２桁目をとる
;;;2008/09/11YM@DEL    (setq #op-z CG_UpCabHeight)   ;Yes
    (setq #op-z  (nth 11 &pln$))  ;No  ; 距離ｚ
;;;2008/09/11YM@DEL  );_if


  ;2011/05/09 YM ADD-S 吊戸下オープンBOXの配置に伴う吊戸高さ変更
  ;条件1:吊戸下オープンBOXあり　PLAN59="N"以外
  (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
    ;条件2:上台構成　PLAN?61="X"以外  
    (if (/= (nth (+ (* 100 CG_D_EXTEND_KAI) 61) CG_GLOBAL$) "X")
      ;条件3:アッパーキャビ
      (if (= CG_SKK_TWO_UPP (CFGetSeikakuToSKKCode &seikaku 2)) ; 性格CODEの２桁目をとる
        (setq #op-z CG_WallUnderOpenBoxHeight) ;2150固定
      );_if
    );_if
  );_if
  ;2011/05/09 YM ADD-E 吊戸下オープンBOXの配置に伴う吊戸高さ変更

  ;2011/08/12 YM ADD KPCADｷｯﾁﾝで吊戸の場合、吊元高さに配置する
  (if (and (= CG_PlanType "SK")(= CG_AUTOMODE 0)(= CG_SKK_TWO_UPP (CFGetSeikakuToSKKCode &seikaku 2)))
    (setq #op-z CG_UpCabHeight)
  );_if

  (setq #pts-w (fix (nth 12 &pln$))) ; 向きＷ
  (setq #pts-d (fix (nth 13 &pln$))) ; 向きＤ
  (setq #dim-w (advance (nth 3 &fig$) 10))  ; 寸法Ｗ ;2008/06/23 YM MOD

  (setq #ang (angle (list 0 0) (list #vct-x #vct-y)))
  (cond
    ((and (= #pts-w -1) (= #pts-d 1))
      (setq #ang2 (angle (list #vct-x #vct-y) (list 0. 0.)))
      (setq #pos (polar '(0 0) #ang2 (distance '(0 0) (list #op-x #op-y))))
      (setq #pos (polar #pos #ang2 #dim-w))
    )
    (T
      (setq #pos (list #op-x #op-y #op-z))
    )
  )
  (setq #pos (list (car #pos) (cadr #pos) #op-z))
  (setq #dwg (nth 6 &fig$)) ; 図形ＩＤ ;2008/06/23 YM MOD

  (if (= #dwg nil) ; 00/11/14 YM ADD
    (progn
      (setq #msg (strcat "\n『品番図形』に図形IDが未登録です。\n" (nth 0 &fig$)));2008/06/23 YM MOD
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_if


  (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")))
    (progn
      (setq #msg (strcat "図形ID: [" #dwg "] がありません"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  ;else
    (progn
      ;部材の挿入
      (command "_insert" (strcat CG_MSTDWGPATH #dwg) #pos 1 1 (rtd #ang))

      ;GSMでﾌﾘｰｽﾞ、ﾛｯｸされている可能性があるため解除する
      (command "_layer" "T" "*" "")                   ;全画層フリーズ解除
      (command "_layer" "U" "*" "")                   ;全画層ロック解除

      ;配置原点と角度を確保
      (setq #pos (cdr (assoc 10 (entget (entlast)))))
      (setq #ang (cdr (assoc 50 (entget (entlast)))))

      ;分解&グループ化
      (command "_explode" (entlast))                    ;インサート図形分解
;;; <SKMkGroup>
;;; 分解した図形群で名前のないグループ作成
;;; 非グラフィカル図形 entmakex "GROUP"
;;; (dictadd (namedobjdict) "ACAD_GROUP" 図形名)

      (SKMkGroup (ssget "P"))

      (setq #ssP (ssget "P" '((0 . "POINT")))) ; 直前に作られた選択ｾｯﾄの中からﾎﾟｲﾝﾄばかりあつめる
      (setq #n 0 #k 0)

      (if #ssP ;04/01/24 YM ADD #ssP=nilの場合
        (repeat (sslength #ssP)
          (setq #elm (ssname #ssP #n))
          (if (CFGetXData #elm "G_SYM")
            (progn
              (setq #sym #elm)
              (setq #k (1+ #k))
              (if (>= #k 2)
                (progn
                  (setq #msg (strcat "\n★同一図形に\"G_SYM\"が複数あります。\n" #dwg))
                  (if (= CG_AUTOMODE 2) ; 02/09/04 YM ADD
                    (WebOutLog #msg)    ; 02/09/04 YM ADD
                    (CFAlertMsg #msg)
                  )
                )
              );_if
            )
          );_if
          (setq #n (1+ #n))
        );repeat
      );_if
    )
  );_if

  ;04/01/26 YM ADD-S 吊戸のINSERT結果が何故かおかしくなる
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  ;04/01/26 YM ADD-E この処理を入れたら直った

  (WebOutLog "単独部材を配置しました")
  ;// 配置原点と角度,ｼﾝﾎﾞﾙを返す
  (list #pos #ang #sym)
);PKC_InsertParts

;;;<HOM>*************************************************************************
;;; <関数名>     : PKC_LayoutBlockParts
;;; <処理概要>   : 複合構成部材配置
;;; <戻り値>     :
;;; <修正>       : 2000.1修正 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun PKC_LayoutBlockParts (
  &pln$  ;(LIST)『プラ構成』情報
  &recno ;(INT) 配置番号
  /
  #BLK$$ #FIGBASE$ #FLG #HNO #I #LR #MSG #QRY$ #SEIKAKU #SQL #STYP #TWO #YNO
  #DWG #LIST$$ #Kiki$ #GAS$ #GAS$$ #Sum_W
  #ANG #HIN_TYP #RET$ #XX #YY #ZZ #DAN
  #IPA_HOOD$ #IPA_HOOD$$ #XXX #YYY #ZZZ
  #DIRY #OBUN$ #OBUN$$ #YOKOMAKU$ #YOKOMAKU$$ #SYM
#RECNO
#ADDXX #ADDYY #ADDZZ #ORGXX #ORGYY #ORGZZ ;2017/10/05 YM ADD
  )
  (setq #styp (nth 6 &pln$)) ;商品タイプ ;2008/06/23 YM MOD

  (if CG_NO_BOX_FLG
    ;商品ﾀｲﾌﾟ5
    (if (equal #styp 5.0 0.001);ﾌﾛﾝﾄﾊﾟﾈﾙ
      ;距離Yをｸﾞﾛｰﾊﾞﾙで残す
      (setq CG_DIST_YY (nth 10 &pln$))
    );_if
  );_if

  ;2008/11/15 YM ADD-S ﾌｰﾄﾞのみ対応
  ;商品ﾀｲﾌﾟ=6
  (if (equal #styp 6.0 0.001);ﾖｺﾏｸｲﾀ
    (progn ;ﾌｰﾄﾞのみ対応の道筋 ここで配置処理を行う

      ;[複合横幕板]を検索
      (setq #YOKOMAKU$$
        (CFGetDBSQLRec CG_DBSESSION "複合横幕板"
           (list
             (list "記号"     (nth 23 CG_GLOBAL$) 'STR)
             (list "吊戸高さ" (nth 32 CG_GLOBAL$) 'STR)
           )
        )
      )
      ;2009/11/24 YM MOD
      (setq #YOKOMAKU$ (DBCheck2 #YOKOMAKU$$ "『複合横幕板』" "\n PKC_LayoutBlockParts"))
      (if #YOKOMAKU$
        (progn
          (setq #HNO (nth  2 #YOKOMAKU$));品番名称
          (setq #LR  (nth  3 #YOKOMAKU$));LR区分
          (setq #XX  (nth  9 &pln$))
          (setq #YY  (nth 10 &pln$))
					(setq #ZZ  CG_UpCabHeight)

          (setq #dirY (nth 8 &pln$)) ;方向Y=0(I型),-1(L型)
          (cond
            ((equal #dirY 0.0 0.001);I型
              (setq #ANG 0.0);度
            )
            ((equal #dirY -1.0 0.001);L型
              (setq #ANG -90.0);度
            )
          );_cond

          ;配置
          (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
        )
      );_if

    )
    (progn ;従来どおりの道筋
      (setq #ret$ (PKGetSQL_HUKU_KANRI &pln$ #styp)) ; 複合管理検索 SQLを求める
      (setq #qry$  (nth 0 #ret$))
      (setq #blk$$ (nth 1 #ret$))
    )
  );_if

  (cond
    ;商品ﾀｲﾌﾟ=1,5,7
    ((or (equal #styp  1.0 0.001) ;ｻｲﾄﾞﾊﾟﾈﾙ
         (equal #styp  5.0 0.001) ;ﾌﾛﾝﾄﾊﾟﾈﾙ
         (equal #styp 11.0 0.001) ;ﾌﾚｰﾑｷｯﾁﾝｶｳﾝﾀ
         (equal #styp  7.0 0.001));中間BOX 2010/10/13 YM ADD

      (foreach #blk$ #blk$$
        (setq #HNO (nth 2 #blk$))  ;品番名称
        (setq #LR  (nth 3 #blk$))  ;LR区分
        (setq #XX  (nth 4 #blk$))
        (setq #YY  (nth 5 #blk$))
        ;2011/03/24 YM ADD-S NZｸﾗｽは中間BOXがあるが、SAｸﾗｽは中間BOXがないので距離Yをつめないといけない
        (if CG_NO_BOX_FLG
          (setq #YY (- #YY CG_DIST_YY))
        );_if
        (setq #ZZ  (nth 6 #blk$))
        (setq #ANG (nth 7 #blk$))
        ;配置
        (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
      );foreach
    );商品ﾀｲﾌﾟ=1,5,7,11


    ;商品ﾀｲﾌﾟ=12,14
    ((or (equal #styp 12.0 0.001)(equal #styp 14.0 0.001)) ;(複合ｺﾝﾛ,複合食洗)

		 	;相対座標に配置【プラ構成】の座標
      (setq #orgXX  (nth  9 &pln$))
      (setq #orgYY  (nth 10 &pln$))
      (setq #orgZZ  (nth 11 &pln$))

      (foreach #blk$ #blk$$
        (setq #HNO (nth 2 #blk$))  ;品番名称
        (setq #LR  (nth 3 #blk$))  ;LR区分
        (setq #XX  (nth 4 #blk$))
        (setq #YY  (nth 5 #blk$))
        (setq #ZZ  (nth 6 #blk$))
        (setq #ANG (nth 7 #blk$))

	      (setq #addXX  (+ #orgXX #XX))
	      (setq #addYY  (+ #orgYY #YY))
	      (setq #addZZ  (+ #orgZZ #ZZ))

        ;配置
        (TK_PosParts #HNO #LR (list #addXX #addYY #addZZ) #ANG nil "A")
      );foreach


	 	)

    ;商品ﾀｲﾌﾟ=2,3,4
    ((or (equal #styp 2.0 0.001)(equal #styp 3.0 0.001)(equal #styp 4.0 0.001));従来ﾛｼﾞｯｸ(ｺﾝﾛ,食洗,ﾌｰﾄﾞ)

      ;// プラン構成にてすでに配置済みの図形より、同一の開始基準アイテム番号を持つ図形を基準にする
      ;// 設備番号が=0の場合は先頭が複合図形のため(0,0,0)点に複合図形の最初の部材を
      ;// 配置しその図形を元に連続配置を行う
      ;// 『複合構成』.開始基準アイテム番号
      ;// 『複合構成』のレコード数分、処理する
      (setq ST_BLKSTART T)
      (foreach #blk$ #blk$$
        (setq #recno (nth 1 #blk$))  ;recno
        (setq #HNO (nth 2 #blk$))    ;品番名称 ;2008/06/23 YM MOD
        (setq #LR  (nth 3 #blk$))    ;LR区分   ;2008/06/23 YM MOD
        (setq #YNO (nth 4 #blk$))    ;用途番号 ;2008/06/23 YM MOD
        (setq #HIN_TYP (nth 9 #blk$));品番ﾀｲﾌﾟ(1:GAS , 2:OBUN , 3;SYOKUSEN , 3:ﾌﾗｯﾄ用HOOD )

        ;2011/03/31 YM ADD 食洗用ｷｬﾋﾞの品番が必要
        (if (and (equal #styp 4.0 0.001)(equal #recno 1.0 0.001))
          (setq CG_SYOKUSEN_CAB #HNO)
        );_if

        (cond
          ((= #HIN_TYP "1")
            ;【複合GAS】を検索する/////////////////////////////////////////////////////////////
            (setq #GAS$$
              (CFGetDBSQLRec CG_DBSESSION "複合GAS"
                 (list
                   (list "記号" (nth 20 CG_GLOBAL$) 'STR)
                 )
              )
            )
            (setq #GAS$ (DBCheck #GAS$$ "『複合GAS』" "\n PKC_LayoutBlockParts"))
            (setq #HNO (nth 1 #GAS$));品番名称 ;2008/06/23 YM MOD
            (setq #LR  (nth 2 #GAS$));LR区分   ;2008/06/23 YM MOD
          )
          ((= #HIN_TYP "2")

            (setq #OBUN$$
              (CFGetDBSQLRec CG_DBSESSION "複合OBUN"
                 (list
                   (list "記号"       (nth 21 CG_GLOBAL$) 'STR)
                   (list "奥行き"     (nth  7 CG_GLOBAL$) 'STR)
                   (list "天板高さ"   (nth 31 CG_GLOBAL$) 'STR)
                   (list "シンク記号" (nth 17 CG_GLOBAL$) 'STR);2013/12/26 YM ADD
                 )
              )
            )
            (setq #OBUN$ (DBCheck #OBUN$$ "『複合OBUN』" "\n PKC_LayoutBlockParts"))
;2013/12/26 YM MOD-S
;;;            (setq #HNO (nth 3 #OBUN$));品番名称
;;;            (setq #LR  (nth 4 #OBUN$));LR区分
            (setq #HNO (nth 4 #OBUN$));品番名称
            (setq #LR  (nth 5 #OBUN$));LR区分
;2013/12/26 YM MOD-E
          )

          ((= #HIN_TYP "3")
            ;【複合HOOD構成】を検索する/////////////////////////////////////////////////////////////
            (setq #IPA_HOOD$$
              (CFGetDBSQLRec CG_DBSESSION "複合HOOD構成"
                (list
                  (list "シンク側間口"  (nth  4 CG_GLOBAL$) 'STR)
                  (list "奥行き"        (nth  7 CG_GLOBAL$) 'STR)
                  (list "品番名称"      #HNO                'STR)
                  (list "LR区分"        #LR                 'STR)
                )
              )
            )
            (setq #IPA_HOOD$ (DBCheck #IPA_HOOD$$ "『複合HOOD構成』" "\n PKC_LayoutBlockParts"))
            ;座標と角度を取得
            (setq #xxx (nth 4 #IPA_HOOD$));X
            (setq #yyy (nth 5 #IPA_HOOD$));Y
            ;2011/08/18 YM MOD-S
            ;(setq #zzz (nth 6 #IPA_HOOD$));Z
            (setq #zzz CG_UpCabHeight);Z
            ;2011/08/18 YM MOD-E
            (setq #ang (nth 7 #IPA_HOOD$));ANG
          )

          (T
            nil
          )
        );_cond

        ;/////////////////////////////////////////////////////////////


        (setq #LIST$$
          (list
            (list "品番名称"      #HNO           'STR)
            (list "LR区分"        #LR            'STR)
            (list "用途番号"      (rtois #YNO)   'INT)
          )
        )

        (setq #qry$
          (CFGetDBSQLHinbanTable "品番図形" #HNO ;品番名称
            #LIST$$
          )
        )
        (WebOutLog "品番図形　検索結果:")
        (setq #qry$ (DBCheck #qry$ "『品番図形』" "\n PKC_LayoutBlockParts"))

        (setq #LIST$$
          (list
            (list "品番名称" (nth 0 #qry$) 'STR);2008/06/23 YM MOD
          )
        )


        (setq #figBase$
          (CFGetDBSQLHinbanTable "品番基本" (nth 0 #qry$) ;2008/06/23 YM MOD
            #LIST$$
          )
        )
        (setq #figBase$ (DBCheck #figBase$ "『品番基本』" "\n PKC_LayoutBlockParts"))

        (setq #seikaku (fix (nth 3 #figBase$))) ;2008/06/23 YM MOD
        (setq #two (CFGetSeikakuToSKKCode #seikaku 2)) ; 性格CODEの2桁目=1

        (setq #Flg T)
        (cond
;;;         ((= #two CG_SKK_TWO_BAS)   ; 性格CODEが1==>ベース   CG_SKK_TWO_BAS=1
;;;           (if (/= CG_UnitBase "1") ; CG_UnitBase="1" フロア配置フラグ
;;;             (setq #Flg nil)
;;;           )
;;;         )
          ((= #two CG_SKK_TWO_UPP)   ; 性格CODEが2==>アッパー CG_SKK_TWO_BAS=2
            (if (= (nth 32 CG_GLOBAL$) "N"); CG_UnitUpper="1" ウォール配置フラグ
              (setq #Flg nil)
            )
          )
          (T
            (setq #Flg T)            ; ベース、アッパー以外
          )
        );_cond

        (if #Flg
          (progn
            (setq #dwg (nth 6 #qry$)) ; 図形ID ;2008/06/23 YM MOD

            (if (= #dwg nil)
              (progn
                (setq #msg (strcat "\n『品番図形』に図形IDが未登録です。\n" (nth 0 #qry$)))
                (CMN_OutMsg #msg)
              )
            );_if


            ;// 複合構成情報の配置方向フラグにより、連続配置を行う
            ;//  正=0
            ;//  逆=1
            ;//  上=2
            ;//  下=3
            ;//  単独=4
            ;//  コンロ取付線=5
            ;//  同一基準点=6


;2010/11/09 YM MOD-S
;;;           (if (= #HIN_TYP "3")
;;;             (progn ;対面用ﾌｰﾄﾞの場合 ;2010/11/09 ｺﾒﾝﾄ SKA P型ﾌｰﾄﾞ
;;;               ;配置
;;;               (TK_PosParts #HNO #LR (list #xxx #yyy #zzz) #ANG 1)
;;;             )
;;;             (progn ;2010/11/09 ｺﾒﾝﾄI型ﾌｰﾄﾞはこちらを通す
;;;               (PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
;;;             )
;;;           );_if

            (setq CG_P_HOOD_SYM nil);初期化
            (setq CG_HOOD_FLG   nil);初期化
            (cond
              ((= #HIN_TYP "3")
                ;旧ﾛｼﾞｯｸ対面用ﾌｰﾄﾞの場合[複合HOOD構成]から座標を求める ;2010/11/09 ｺﾒﾝﾄ 従来SKA P型ﾌｰﾄﾞ
                (TK_PosParts #HNO #LR (list #xxx #yyy #zzz) #ANG 1 "A")
                (setq CG_HOOD_FLG "PP");P型でP型ﾌｰﾄﾞ
              )
              ((and (= "I00" (nth  5 CG_GLOBAL$))
                    (= #HIN_TYP "4"))
                ;2010/11/09 I型でI型ﾌｰﾄﾞはこちらを通す
                (PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
                (setq CG_HOOD_FLG "II");I型でI型ﾌｰﾄﾞ
              )
              ((and (= "I00" (nth  5 CG_GLOBAL$))(= #HIN_TYP "33"))
                ;2010/11/09 【I型でP型ﾌｰﾄﾞ】(配置位置自動計算) 一旦原点に配置して後で移動する
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 270.0 1 "A"))
                (setq CG_HOOD_FLG "IP");I型でP型ﾌｰﾄﾞ
              )
              ;2011/05/21 YM MOD
;;;             ((or (and (= "IPA" (nth  5 CG_GLOBAL$))(= #HIN_TYP "33"))
              ((or (and (wcmatch (nth  5 CG_GLOBAL$) "IP*" )(= #HIN_TYP "33"))
                   (and (wcmatch (nth  5 CG_GLOBAL$) "G*" )(= #HIN_TYP "33")))
                ;2010/11/09 【P型でP型ﾌｰﾄﾞ】(配置位置自動計算) 一旦原点に配置して後で移動する
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 270.0 1 "A"))
                (setq CG_HOOD_FLG "PP");P型でP型ﾌｰﾄﾞ
              )
              ;2011/05/21 YM MOD
;;;             ((or (and (= "IPA" (nth  5 CG_GLOBAL$))(= #HIN_TYP  "4"))
              ((or (and (wcmatch (nth  5 CG_GLOBAL$) "IP*" )(= #HIN_TYP  "4"))
                   (and (wcmatch (nth  5 CG_GLOBAL$) "G*" )(= #HIN_TYP  "4")))
                ;2010/11/09 【P型でI型ﾌｰﾄﾞ】(配置位置自動計算) 一旦原点に配置して後で移動する
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 000.0 1 "A"))
                (setq CG_HOOD_FLG "PI");P型でI型ﾌｰﾄﾞ
              )
              (T ;従来品番ﾀｲﾌﾟ=0のﾌｰﾄﾞはここを通る
                (PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
              )
            );_cond

;2010/11/09 YM MOD-E


          )
        );_(if #Flg

        (setq ST_BLKSTART nil)
      );_(foreach #blk$ #blk$$

    );商品ﾀｲﾌﾟ=2,3,4


    ;2011/01/26 YM ADD
    ;商品ﾀｲﾌﾟ=9 新設
    ((equal #styp 9.0 0.001);複合管理を使わないﾌｰﾄﾞ引当て

      (setq ST_BLKSTART T)
      (foreach #blk$ #blk$$
        (setq #HNO (nth 3 #blk$))    ;品番名称
        (setq #LR  (nth 4 #blk$))    ;LR区分
        (setq #YNO 0.0)              ;用途番号
        (setq #HIN_TYP (nth 5 #blk$));品番ﾀｲﾌﾟ( 4:I型HOOD , 33:ﾌﾗｯﾄ用HOOD )

        (setq #LIST$$
          (list
            (list "品番名称"      #HNO           'STR)
            (list "LR区分"        #LR            'STR)
            (list "用途番号"      (rtois #YNO)   'INT)
          )
        )

        (setq #qry$
          (CFGetDBSQLHinbanTable "品番図形" #HNO ;品番名称
            #LIST$$
          )
        )
        (WebOutLog "品番図形 検索結果:")
        (setq #qry$ (DBCheck #qry$ "『品番図形』" "\n PKC_LayoutBlockParts"))

        (setq #LIST$$
          (list
            (list "品番名称" (nth 0 #qry$) 'STR)
          )
        )

        (setq #figBase$
          (CFGetDBSQLHinbanTable "品番基本" (nth 0 #qry$)
            #LIST$$
          )
        )
        (setq #figBase$ (DBCheck #figBase$ "『品番基本』" "\n PKC_LayoutBlockParts"))

        (setq #seikaku (fix (nth 3 #figBase$)))
        (setq #two (CFGetSeikakuToSKKCode #seikaku 2)) ; 性格CODEの2桁目=1

        (setq #Flg T)
        (cond
          ((= #two CG_SKK_TWO_UPP)   ; 性格CODEが2==>アッパー CG_SKK_TWO_BAS=2
            (if (= (nth 32 CG_GLOBAL$) "N"); CG_UnitUpper="1" ウォール配置フラグ
              (setq #Flg nil)
            )
          )
          (T
            (setq #Flg T)            ; ベース、アッパー以外
          )
        );_cond

        (if #Flg
          (progn
            (setq #dwg (nth 6 #qry$)) ; 図形ID

            (if (= #dwg nil)
              (progn
                (setq #msg (strcat "\n『品番図形』に図形IDが未登録です。\n" (nth 0 #qry$)))
                (CMN_OutMsg #msg)
              )
            );_if

            (setq CG_P_HOOD_SYM nil);初期化
            (setq CG_HOOD_FLG   nil);初期化
            (cond
              ((= #HIN_TYP "3") ;ここは通らない
                ;旧ﾛｼﾞｯｸ対面用ﾌｰﾄﾞの場合[複合HOOD構成]から座標を求める ;2010/11/09 ｺﾒﾝﾄ 従来SKA P型ﾌｰﾄﾞ
                (TK_PosParts #HNO #LR (list #xxx #yyy #zzz) #ANG 1 "A")
                (setq CG_HOOD_FLG "PP");P型でP型ﾌｰﾄﾞ
              )
              ((and (= "I00" (nth  5 CG_GLOBAL$))
                    (= #HIN_TYP "4"))
                ;2010/11/09 I型でI型ﾌｰﾄﾞはこちらを通す
                (PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
                (setq CG_HOOD_FLG "II");I型でI型ﾌｰﾄﾞ
              )
              ((and (= "I00" (nth  5 CG_GLOBAL$))(= #HIN_TYP "33"))
                ;2010/11/09 【I型でP型ﾌｰﾄﾞ】(配置位置自動計算) 一旦原点に配置して後で移動する
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 270.0 1 "A"))
                (setq CG_HOOD_FLG "IP");I型でP型ﾌｰﾄﾞ
              )
              ;2011/05/21 YM MOD
;;;             ((or (and (= "IPA" (nth  5 CG_GLOBAL$))(= #HIN_TYP "33"))
              ((or (and (wcmatch (nth  5 CG_GLOBAL$) "IP*" )(= #HIN_TYP "33"))
                   (and (wcmatch (nth  5 CG_GLOBAL$) "G*" )(= #HIN_TYP "33")))
                ;2010/11/09 【P型でP型ﾌｰﾄﾞ】(配置位置自動計算) 一旦原点に配置して後で移動する
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 270.0 1 "A"))
                (setq CG_HOOD_FLG "PP");P型でP型ﾌｰﾄﾞ
              )
              ;2011/05/21 YM MOD
;;;             ((or (and (= "IPA" (nth  5 CG_GLOBAL$))(= #HIN_TYP  "4"))
              ((or (and (wcmatch (nth  5 CG_GLOBAL$) "IP*" )(= #HIN_TYP  "4"))
                   (and (wcmatch (nth  5 CG_GLOBAL$) "G*" )(= #HIN_TYP  "4")))
                ;2010/11/09 【P型でI型ﾌｰﾄﾞ】(配置位置自動計算) 一旦原点に配置して後で移動する
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 000.0 1 "A"))
                (setq CG_HOOD_FLG "PI");P型でI型ﾌｰﾄﾞ
              )

              ((and (wcmatch (nth  5 CG_GLOBAL$) "L*" )(= #HIN_TYP "33"));L型Pフード
                ;2017/07/04 【L型でP型ﾌｰﾄﾞ】(配置位置自動計算) 一旦原点に配置して後で移動する
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 180.0 1 "A"))
                (setq CG_HOOD_FLG "LP");L型でP型ﾌｰﾄﾞ
              )
              ((and (wcmatch (nth  5 CG_GLOBAL$) "L*" )(= #HIN_TYP "4"));L型Iフード
                ;2017/07/04 【L型でI型ﾌｰﾄﾞ】(配置位置自動計算) 一旦原点に配置して後で移動する
;;;                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 270.0 1 "A"))
;;;                (setq CG_HOOD_FLG "LI");L型でI型ﾌｰﾄﾞ
								(PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
              )


              (T ;従来品番ﾀｲﾌﾟ=0のﾌｰﾄﾞはここを通る
                (PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
              )
            );_cond

          )
        );_(if #Flg

        (setq ST_BLKSTART nil)
      );_(foreach #blk$ #blk$$

    );商品ﾀｲﾌﾟ=9 新設


  );_cond

  (WebOutLog "複合部材を配置しました")
  (princ)
);PKC_LayoutBlockParts


;<HOM>*************************************************************************
; <関数名>    : KPGetSinaType
; <処理概要>  : 商品ﾀｲﾌﾟ取得
; <戻り値>    : 商品ﾀｲﾌﾟ(実数値)
; <作成>      : 01/06/27 YM
; <備考>      : 商品ﾀｲﾌﾟ=2(ﾐﾆｷｯﾁﾝ)
;*************************************************************************>MOH<
(defun KPGetSinaType (
  /
  #QRY$ #SINA_TYPE
  )

;;;(if CG_SeriesCode
;;; (princ (strcat "\n CG_SeriesCode = " CG_SeriesCode))
;;; (princ (strcat "\n CG_SeriesCode = nil"))
;;;);_if
;;;(if CG_SeriesDB
;;; (princ (strcat "\n CG_SeriesDB = " CG_SeriesDB))
;;; (princ (strcat "\n CG_SeriesDB = nil"))
;;;);_if

  (setq #qry$
    (CFGetDBSQLRecChk CG_CDBSESSION "SERIES" (list (list "SERIES記号" CG_SeriesCode 'STR)
                                                     (list "SERIES名称" CG_SeriesDB   'STR)))) ; 02/03/18 YM ADD CG_SeriesDB追加

;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #qry$)
;;;		;ｼﾘｰｽﾞ別DB,共通DB再接続
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E


  (if (= nil #qry$)
    (CFAlertErr "SERIESテーブルが見つかりません")
  )
  (setq #SINA_Type (nth 9 #qry$)) ; 商品ﾀｲﾌﾟ
);KPGetSinaType

;------------------------------------------------------------------------
; 02/09/03 YM ADD 人工的にｴﾗｰを発生させる
(defun makeERR ( &STR / )
  (princ (strcat "\n0割り人工エラー" &STR))
  (setq err (/ 0 0))
;;; (princ)
)
;------------------------------------------------------------------------

;;;<HOM>*************************************************************************
;;; <関数名>    : timer
;;; <処理概要>  : 引数(秒)処理を待つ
;;; <戻り値>    : なし
;;; <作成>      : 02/10/11 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun timer (
  &sec
  /
  #MIN #ST
  )
  (setq #min 1) ; 待ち時間(分)
  (setq #st (* 86400 (getvar "TDINDWG"))) ; 分(開始時)
  (while (<= (- (* 86400 (getvar "TDINDWG")) #st) &sec)
    nil
  )
  (princ)
);timer




;;;<HOM>************************************************************************
;;; <関数名>  : PKG_SetFamilyCode
;;; <処理概要>: キッチン用入力情報をグローバルファミリー品番
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun PKG_SetFamilyCode (
  &family$$    ;(LIST)プラン検索画面の入力情報
  /
  #key #hinban$ #str #height
  #SSIDEPANELTYPE #num #i
	#sa_H #ERR ;2011/12/19 YM ADD
  )
  (setq #key (strcat CG_SeriesCode "K"))
  (setq CG_Kcode  "K") ; 工種記号(未使用)

  ;//---------------------------------------------------------------------
  ;// 特性値情報からパラメータを設定する
  (setq CG_FamilyCode (cadr (assoc "FamilyCode" &family$$)))

  ;2008/06/21 YM MOD
  ;★★★　ｸﾞﾛｰﾊﾞﾙ変数のｾｯﾄ(0～49まで) [SK特性].PLAN??で定義されていないものはnil値　★★★
  (setq #i 0)
  (setq CG_GLOBAL$ nil)
  (repeat 150
    (if (< #i 10)
      (setq #num (strcat "0" (itoa #i)))
      (setq #num (itoa #i))
    );_if
    
    (setq CG_GLOBAL$ (append CG_GLOBAL$ (list (cadr (assoc (strcat #key #num) &family$$)))))
    (setq #i (1+ #i))
  );repeat

	;2013/11/19 YM ADD-S
	(setq CG_CeilHeight  (atoi (substr (nth 48 CG_GLOBAL$) 3 10))) ;天井高さ
	(setq CG_UpCabHeight (atoi (substr (nth 49 CG_GLOBAL$) 3 10))) ;取付高さ

  ; PlanInfo.cfgの変更 タイミングが悪いから最後に移動
;;;  (ChangePlanInfo);2014/05/29 YM MOV

	;2013/11/19 YM ADD-E

;2011/12/19 YM ADD-S 天幕ﾁｪｯｸ
;特性ID	表示順	特性値	特性値名
;PLAN46	1	X	-----
;PLAN46	2	N	取付けない
	(if (and CG_GLOBAL$ (nth 46 CG_GLOBAL$) (/= (nth 46 CG_GLOBAL$) "N")(/= (nth 46 CG_GLOBAL$) "X"))
		(progn ;天井高さ,吊元高さﾁｪｯｸ CG_CeilHeight , CG_UpCabHeight
			(setq #sa_H (- CG_CeilHeight CG_UpCabHeight))
			(setq #ERR nil)
			(cond
				((= "A" (nth 46 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 100.0) 0.01))
					(if (and (< -0.001 (- 100.0 #sa_H ))(> 100.001 (- 100.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
				((= "B" (nth 46 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 200.0) 0.01))
					(if (and (< -0.001 (- 200.0 #sa_H ))(> 100.001 (- 200.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
				((= "C" (nth 46 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 300.0) 0.01))
					(if (and (< -0.001 (- 300.0 #sa_H ))(> 100.001 (- 300.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
			);_cond
		)
	);_if

	(if (and CG_GLOBAL$ (nth 72 CG_GLOBAL$) (/= (nth 72 CG_GLOBAL$) "N")(/= (nth 72 CG_GLOBAL$) "X"))
		(progn ;天井高さ,吊元高さﾁｪｯｸ CG_CeilHeight , CG_UpCabHeight
			(setq #sa_H (- CG_CeilHeight CG_UpCabHeight))
			(setq #ERR nil)
			(cond
				((= "A" (nth 72 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 100.0) 0.01))
					(if (and (< -0.001 (- 100.0 #sa_H ))(> 100.001 (- 100.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
				((= "B" (nth 72 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 200.0) 0.01))
					(if (and (< -0.001 (- 200.0 #sa_H ))(> 100.001 (- 200.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
				((= "C" (nth 72 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 300.0) 0.01))
					(if (and (< -0.001 (- 300.0 #sa_H ))(> 100.001 (- 300.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
			);_cond
		)
	);_if

	(if #ERR
		(progn
      (CFAlertMsg "\n天井幕板を作成できません。天井高さと吊元高さの差をご確認下さい。")
      (quit) ;強制終了
		)
	)

;2011/12/19 YM ADD-E 天幕ﾁｪｯｸ

  ;【暫定措置】引手記号のセット
  (setq CG_DRSeriCode (nth 12 CG_GLOBAL$))
  (setq CG_DRColCode  (nth 13 CG_GLOBAL$))
  (setq CG_Hikite     (nth 14 CG_GLOBAL$))
  (setq CG_GasType    (nth 24 CG_GLOBAL$))  ;ガス種

  ;2011/05/27 YM ADD ★ｷｯﾁﾝ立体陣笠対応
  (setq CG_DRSeriCode_D (nth 12 CG_GLOBAL$));下台
  (setq CG_DRColCode_D  (nth 13 CG_GLOBAL$));下台
  (setq CG_Hikite_D     (nth 14 CG_GLOBAL$));下台

  (setq CG_DRSeriCode_U (nth 112 CG_GLOBAL$));上台
  (setq CG_DRColCode_U  (nth 113 CG_GLOBAL$));上台
  (setq CG_Hikite_U     (nth 114 CG_GLOBAL$));上台


  ; PlanInfo.cfgの変更 タイミングが悪いからここに移動
  (ChangePlanInfo);2014/05/29 YM MOV


;;;SK01      :シリーズ    CG_SeriesCode ==> (nth  1 CG_GLOBAL$)
;;;SK02      :ｷｬﾋﾞﾈｯﾄﾌﾟﾗﾝ
;;;SK03      :ユニット
;;;SK04      :ｷｯﾁﾝ間口
;;;SK05      :形状        CG_W2CODE    ==> (nth  5 CG_GLOBAL$)
;;;SK06      :ﾌﾛｱｷｬﾋﾞﾀｲﾌﾟ
;;;SK07      :奥行き
;;;SK08      :ｿﾌﾄｸﾛｰｽﾞ
;;;SK09      :ｺﾝﾛ位置
;;;SK10      :食洗位置
;;;SK11      :左右勝手    CG_LRCode    ==> (nth 11 CG_GLOBAL$)
;;;SK12      :扉ｼﾘｰｽﾞ
;;;SK13      :扉カラー
;;;SK14      :取手
;;;SK16      :ﾜｰｸﾄｯﾌﾟ材質 CG_WTZaiCode ==> (nth 16 CG_GLOBAL$)
;;;SK17      :シンク      CG_SinkCode  ==> (nth 17 CG_GLOBAL$)
;;;SK18      :水栓穴加工
;;;SK19      :水栓機種
;;;SK20      :ｺﾝﾛ機種
;;;SK21      :コンロ下
;;;SK22      :水栓機種 2穴
;;;SK23      :ﾚﾝｼﾞﾌｰﾄﾞ機種
;;;SK24      :ガス種
;;;SK25      :ｺﾝﾛ種別(ﾒｰｶｰ)
;;;SK31      :ﾜｰｸﾄｯﾌﾟ高さ
;;;SK32      :吊戸高さ
;;;SK40      :水栓仕様
;;;SK42      :食洗機種
;;;SK44      :ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝ ★★★
;;;SK45      :ｴﾝﾄﾞﾊﾟﾈﾙ
;;;SK46      :天井ﾌｨﾗｰ

;;;  (setq CG_FilerCode       (cadr (assoc "SKOP04"           &family$$))) ;天井ﾌｨﾗｰ
;;;  (setq CG_SidePanelCode   (cadr (assoc "SKOP05"           &family$$))) ;ｻｲﾄﾞﾊﾟﾈﾙ ; 01/07/11 YM
;;;  (setq CG_UnitBase        (cadr (assoc "UNITBASE"         &family$$))) ;ﾌﾛｱ配置ﾌﾗｸﾞ
;;;  (setq CG_UnitUpper       (cadr (assoc "UNITUPPER"        &family$$))) ;ｳｫｰﾙ配置ﾌﾗｸﾞ
;;;  (setq CG_UnitTop         (cadr (assoc "UNITTOP"          &family$$))) ;ﾜｰｸﾄｯﾌﾟ配置ﾌﾗｸﾞ

  ;2008/06/21 YM ログに出力しない(参照することはなく、しばしばエラー原因になる)
;;;  (PcPrintLog)

  (if (= CG_DBSESSION nil)
    (CFAlertErr "ODBCが正しく設定されているか確認して下さい\n PKG_SetFamilyCode")
  )

;;;   ;// 2.天井フィラー品番の取得
;;;   (if (= CG_FilerCode "N")
;;;     (progn
;;;       ;// 天井フィラーなし
;;;       (setq CG_FilerCode nil)
;;;     )
;;;     (progn
;;;       ;// 天井フィラー品番の取得
;;;       (setq #hinban$ (SKG_GetOptionHinbanFIRL CG_FilerCode)) ; 01/12/18 YM MOD ﾌｨﾗｰ専用ﾌﾟﾗ＊OP検索関数
;;;       (setq CG_FilerCode (car #hinban$))
;;;     )
;;;   )

;;;  ;// 3.サイドパネル品番（複数あり）の取得 ; 01/07/11 YM ADD
;;;  (if (or (= CG_SidePanelCode "")(= CG_SidePanelCode nil))
;;;   (setq CG_SidePanel$ nil)         ;サイドパネル
;;;   ;else
;;;    (progn
;;;      (if (> CG_CeilHeight 2400)
;;;        (setq #height (itoa 2700))
;;;        (setq #height (itoa 2400))
;;;      );_if
;;;
;;;     (if (and CG_SidePanelCode (/= CG_SidePanelCode "N"))
;;;       (progn
;;;         ; 天井高さとｳｫｰﾙｷｬﾋﾞ高さを考慮して配置するｻｲﾄﾞﾊﾟﾈﾙﾀｲﾌﾟを決める 01/12/19 YM ADD-S
;;;         (setq #sSidePanelType (NP_DesideSidePanelType))
;;;         ; ｳｫｰﾙ取り付け高さ追加-->01/12/19 500 or 700 を"H" or "L"に変更(判定を追加)
;;;         (setq #hinban$ (SKG_GetSidePanelHinban 3 CG_SidePanelCode #height #sSidePanelType))
;;;       )
;;;     );_if
;;;
;;;      (setq CG_SidePanel$ #hinban$)
;;;    )
;;;  );_if

  (princ)
);PKG_SetFamilyCode

;<HOM>*************************************************************************
; <関数名>    : SKG_GetSidePanelHinban
; <処理概要>  : ｻｲﾄﾞﾊﾟﾈﾙの品番を取得する
; <戻り値>    : (ｻｲﾄﾞﾊﾟﾈﾙの品番,L/R)ﾘｽﾄ
; <作成>      : 2003/12/03
; <備考>      : 元のｿｰｽはｻｲﾄﾞﾊﾟﾈﾙにL/Rがないことを前提だったが→扉(ｾｽﾊﾟﾐﾗﾉ)によってL/Rがあるｹｰｽに対応
;               ([扉COLOR]に「ﾊﾟﾈﾙLR」ﾌｨｰﾙﾄﾞ追加)
;               →DIPLOAのｻｲﾄﾞﾊﾟﾈﾙは最初からL/Rがあり、扉(F*)によって機種が変わりL/Rなし→あり
;               になるｹｰｽがでてきたため[ﾌﾟﾗ管OP]はそのままで[ﾌﾟﾗ構OP]の検索部分を修正
;*************************************************************************>MOH<
(defun SKG_GetSidePanelHinban (
  &type ;OP品区分
  &key1 ;(STR) ｻｲﾄﾞﾊﾟﾈﾙ選択肢記号"A","D"など
  &key2 ;(INT) ｻｲﾄﾞﾊﾟﾈﾙの場合--天井高さ
  &key3 ;(STR) ﾀﾞｲﾆﾝｸﾞ,ｻｲﾄﾞﾊﾟﾈﾙの場合-ﾀｲﾌﾟ1ｺｰﾄﾞ
  /
  #HINBAN$$ #LISTCODE #MSG #OPT$$ #QRY$ #SQL$
#HINBAN #LR_EXIST ; 03/12/17 YM ADD
  )

  ;// オプション品タイプによりオプション品管理ＤＢを検索する
  ;【ﾌﾟﾗ管OP】の検索部分は今までと同じ 2003/12/3 =======================================↓↓↓ここから
  (setq #listCode nil)
  (setq #sql$
    (list
      (list "SERIES記号" CG_SeriesCode  'STR)
      (list "ユニット記号" CG_UnitCode  'STR)
      (list "OP品区分"     (itoa &type) 'INT)
    )
  )
  (if (/= &key1 nil)
    (setq #sql$
      (append #sql$
        (list (list "検索KEY1" &key1 'STR))
      )
    )
  );_if
  (if (/= &key2 nil)
    (setq #sql$
      (append #sql$
        (list (list "検索KEY2" &key2 'STR))
      )
    )
  );_if
  (if (/= &key3 nil)
    (setq #sql$
      (append #sql$
        (list (list "検索KEY3" &key3 'STR))
      )
    )
  );_if
  ;// プラ管OPテーブルを検索する
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "プラ管OP" #sql$))
  (if (= #qry$ nil)
    (progn
      (setq #msg (strcat "『プラ管OP』にレコードがありません。\nSKG_GetOptionHinban"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    (progn
      (setq #qry$ (car #qry$))
      ;【ﾌﾟﾗ管OP】の検索部分は今までと同じ 2003/12/3 =======================================↑↑↑ここまで

      ;03/12/3 YM MOD 【ﾌﾟﾗ構OP】→【ｻｲﾄﾞﾊﾟﾈﾙ】を検索
      ;// オプション管理IDでプラ構OPテーブルを検索する
      (setq #opt$$
        (CFGetDBSQLRec CG_DBSESSION "サイドパネル"
          (list
            (list "OPTID" (rtois (car #qry$)) 'INT)
            (list "扉シリ記号" CG_DRSeriCode  'STR)
          )
        )
      )

      (if (= #opt$$ nil)
        (progn
          (setq #msg (strcat "『プラ構OP』にレコードがありません。\nSKG_GetOptionHinban"))
          (CMN_OutMsg #msg)
        )
      );_if
      (foreach #opt$ #opt$$
        (setq #hinban   (nth 4 #opt$))
        (setq #LR_exist (nth 5 #opt$))
        (setq #hinban$$ (append #hinban$$ (list (list #hinban #LR_exist))))
      )
      ;// 品番のリストを返す
      #hinban$$
    )
  );_if
);SKG_GetSidePanelHinban

;;;<HOM>************************************************************************
;;; <関数名>  : WEB_SetFilPanelCode
;;; <処理概要>: 天井ﾌｨﾗｰ,ｻｲﾄﾞﾊﾟﾈﾙ関連ｸﾞﾛｰﾊﾞﾙ設定
;;; <戻り値>  : なし
;;; <作成>    : 02/08/02 YM
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun WEB_SetFilPanelCode (
  /
  #HEIGHT #HINBAN$ #SSIDEPANELTYPE
  )
  ; 02/09/04 YM ADD ﾛｸﾞ出力追加
  (WebOutLog "天井ﾌｨﾗｰ,ｻｲﾄﾞﾊﾟﾈﾙ関連ｸﾞﾛｰﾊﾞﾙを設定します(WEB_SetFilPanelCode)")

  ;// 2.天井フィラー品番の取得
  (if (or (= "N" CG_FilerCode)(= nil CG_FilerCode)(= "" CG_FilerCode)) ; 03/05/12 YM MOD
;;; (if (= CG_FilerCode "N")
   (progn
     ;// 天井フィラーなし
     (setq CG_FilerCode nil)
   )
   (progn
     (setq #hinban$ (SKG_GetOptionHinbanFIRL CG_FilerCode)) ; 01/12/18 YM MOD ﾌｨﾗｰ専用ﾌﾟﾗ＊OP検索関数
     (setq CG_FilerCode (car #hinban$))
   )
  );_if

  ;// 3.サイドパネル品番（複数あり）の取得 ; 01/07/11 YM ADD
  (if (or (= CG_SidePanelCode "")(= CG_SidePanelCode nil))
    (setq CG_SidePanel$ nil)         ;サイドパネル
    (progn
      (if (> CG_CeilHeight 2400)
        (setq #height (itoa 2700))
        (setq #height (itoa 2400))
      );_if

      (if (and CG_SidePanelCode (/= CG_SidePanelCode "N"))
        (progn
          ; 天井高さとｳｫｰﾙｷｬﾋﾞ高さを考慮して配置するｻｲﾄﾞﾊﾟﾈﾙﾀｲﾌﾟを決める 01/12/19 YM ADD-S
          (setq #sSidePanelType (NP_DesideSidePanelType))
;;;04/04/15YM@DEL         ; ｳｫｰﾙ取り付け高さ追加-->01/12/19 500 or 700 を"H" or "L"に変更(判定を追加)
;;;04/04/15YM@DEL         (setq #hinban$ (SKG_GetOptionHinban 3 CG_SidePanelCode #height #sSidePanelType nil)) ; 01/12/19 YM MOD

          ;04/04/15 YM MOD-S WEB版に更新漏れ
          ; ｳｫｰﾙ取り付け高さ追加-->01/12/19 500 or 700 を"H" or "L"に変更(判定を追加)
          (setq #hinban$ (SKG_GetSidePanelHinban 3 CG_SidePanelCode #height #sSidePanelType))
          ;04/04/15 YM MOD-E WEB版に更新漏れ
        )
      );_if
      (setq CG_SidePanel$ #hinban$)
    )
  );_if

  ; 02/09/04 YM ADD ﾛｸﾞ出力追加
  (WebOutLog "天井ﾌｨﾗｰｺｰﾄﾞ CG_FilerCode=")
  (WebOutLog CG_FilerCode)
  (WebOutLog "ｻｲﾄﾞﾊﾟﾈﾙｺｰﾄﾞ CG_SidePanelCode=")
  (WebOutLog CG_SidePanelCode)
  (WebOutLog " ")
  ; 02/09/04 YM ADD ﾛｸﾞ出力追加
  (princ)
);WEB_SetFilPanelCode

;;;<HOM>*************************************************************************
;;; <関数名>    : NP_DesideSidePanelType
;;; <処理概要>  : 天井高さとｳｫｰﾙｷｬﾋﾞ高さを考慮して配置するｻｲﾄﾞﾊﾟﾈﾙﾀｲﾌﾟを決める
;;; <戻り値>    : ｻｲﾄﾞﾊﾟﾈﾙﾀｲﾌﾟ "H"==>高さ1000mm "L"==>高さ700mm
;;; <作成>      : 01/12/19 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun NP_DesideSidePanelType (
  /
  #DTYPE #FILH #ISIDEH
  )
  ; 天井からの空隙と部材の高さ比較。
  (setq #filH (- CG_CeilHeight CG_UpCabHeight)) ; ﾌｨﾗｰ高さ
  ; CG_UpperCabHeight ; "500" "700"
  (setq #iSideH (+ #filH (atoi CG_UpperCabHeight))) ; ﾌｨﾗｰ高さ+ｳｫｰﾙ高さ

;;;(setq CG_SidePanelLarge 1000) ; ｻｲﾄﾞﾊﾟﾈﾙ大の寸法H
;;;(setq CG_SidePanelMidle  700) ; ｻｲﾄﾞﾊﾟﾈﾙ中の寸法H
;;;(setq CG_SidePanelSmall  500) ; ｻｲﾄﾞﾊﾟﾈﾙ小の寸法H
;;;CG_FloorSidePanel
  
  (cond
    ((and (> #iSideH (+ CG_SidePanelMidle 0.001))(< #iSideH (+ CG_SidePanelLarge 0.001))) ; 700より大きく1000より小さい
      (setq #dType "H") ; 1000mmのｻｲﾄﾞﾊﾟﾈﾙ(大)をﾊｲﾁする
    )
    ((and (> #iSideH (+ CG_SidePanelSmall 0.001))(<= #iSideH (+ CG_SidePanelMidle 0.001))) ; 500より大きく700より小さい
      (setq #dType "M") ; 700mmのｻｲﾄﾞﾊﾟﾈﾙ(中)をﾊｲﾁする
    )
    ((<= #iSideH (+ CG_SidePanelSmall 0.001)) ; 500以下
      (setq #dType "L") ; 500mmのｻｲﾄﾞﾊﾟﾈﾙ(小)をﾊｲﾁする
    )
    (T
      (CFAlertErr "天井高さをご確認ください.適切なｻｲﾄﾞﾊﾟﾈﾙがありません.")
      (quit)
    )
  );_cond

  ; 01/12/26 YM ADD-S H875以上のとき上下分離ﾌﾛｱｻｲﾄﾞﾊﾟﾈﾙは930mmの品番のものを使用する
  (if (<= (- CG_FloorSidePanel 0.001) (atoi CG_BaseCabHeight)) ; ﾌﾛｱ高さが875以上なら"+"追加
    (setq #dType (strcat #dType "+"))
  );_if
  ; 01/12/26 YM ADD-E

  #dType
);NP_DesideSidePanelType

;;;<HOM>*************************************************************************
;;; <関数名>    : PFGetCompUpper
;;; <処理概要>  : 構成部材取得(構成タイプ=2) CG_UnitUpper="1"
;;; <戻り値>    : プラ構成』情報のリスト
;;; <作成>      : 2000.1.19修正KPCAD
;;; <備考>      : アッパー
;;;*************************************************************************>MOH<
(defun PFGetCompUpper (
  &qry$ ; 「プラ管理」ﾚｺｰﾄﾞ
  /
  #I #MSG #QRY$ #QRY$$ #LIST$$ #DB_NAME #PLAN_ID
  )
  (setq #LIST$$
    (list
      (list "ユニット記号"       (nth  3 CG_GLOBAL$) 'STR)
      (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
      (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
      (list "構成タイプ"         "2"                 'INT)
      (list "SOFT_CLOSE"         (nth  8 CG_GLOBAL$) 'STR)
      (list "天板_吊戸高さ"      (nth 32 CG_GLOBAL$) 'STR)
    )
  )

  (setq #DB_NAME "プラ管理")

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$)
  )

  (setq #qry$ (DBCheck #qry$ "『プラ管理』" "PFGetCompUpper"))

  (if (= CG_TESTMODE 1) ; ﾃｽﾄﾓｰﾄﾞ
    (setq P_wallID (strcat "ﾌﾟﾗﾝID(ｳｫｰﾙ)= [" (rtois (car #qry$)) "]"))
  );_if

  ; プランID
  (setq #plan_id (nth 0 #qry$))

  ;;;// 『プラ構成』を検索、
  (setq #DB_NAME "プラ構成")

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME
      (list
        (list "プランID"  #plan_id  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  (if (= #qry$$ nil)
    (progn
      (setq #msg (strcat "『プラ構成』にレコードがありません。\nPFGetCompUpper"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_if


  #qry$$
);PFGetCompUpper

;;;<HOM>*************************************************************************
;;; <関数名>     : PKGetSQL_HUKU_KANRI
;;; <処理概要>   : 複合管理検索のSQLを求める
;;; <戻り値>     : SQLﾘｽﾄ
;;; <修正>       : 2000.6.27 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun PKGetSQL_HUKU_KANRI (
  &pln$  ;(LIST)『プラ構成』情報
  &styp  ; 商品ﾀｲﾌﾟ
  /
  #HEI #LISTCODE #SQL #ZAIF #DB_NAME1 #DB_NAME2 #HUKU_ID #LIST$$ #MSG #PLAN_ID #QRY$ #QRY$$
  #T$ #T$$ #TTT #UNDER_GAS
  #PANEL_DB_NAME ;2009/04/14 YM ADD
  #HOOD_H ;2011/01/26 YM ADD
  )
  
  (cond

    ;// ｻｲﾄﾞﾊﾟﾈﾙ
    ((= &styp 1)
      (setq #DB_NAME1 "複合パネル管理")
      (setq #DB_NAME2 "複合パネル構成")

      ;2009/04/14 YM ADD-S
      (if (wcmatch (nth  5 CG_GLOBAL$) "G*" )
        (setq #PANEL_DB_NAME "パネル厚み_GATE");ｹﾞｰﾄﾀｲﾌﾟ
        ;else
        (setq #PANEL_DB_NAME "パネル厚み");ｹﾞｰﾄﾀｲﾌﾟ以外
      );_if
      ;2009/04/14 YM ADD-E

      (setq #T$$
        (CFGetDBSQLRec CG_DBSESSION #PANEL_DB_NAME
          (list
            (list "扉シリ記号"     (nth 12 CG_GLOBAL$) 'STR)
            (list "扉カラ記号"     (nth 13 CG_GLOBAL$) 'STR)
          )
        )
      )

      (setq #T$ (DBCheck #T$$ "『パネル厚み』" "PKGetSQL_HUKU_KANRI"))
      (setq #TTT (nth 3 #T$));SP厚み
      (setq #LIST$$
        (list
          (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
          (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
          (list "商品タイプ"         "1"                 'INT)
          (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
          (list "天板高さ"           (nth 31 CG_GLOBAL$) 'STR)
          (list "シンク記号"         (nth 17 CG_GLOBAL$) 'STR);2008/09/20 YM ADD
          (list "厚み"               #TTT                'STR)
        )
      )

    )

    ;// ﾌﾛﾝﾄﾊﾟﾈﾙ
    ((= &styp 5)
      (setq #DB_NAME1 "複合パネル管理")
      (setq #DB_NAME2 "複合パネル構成")

      ;2009/04/14 YM ADD-S
      (if (wcmatch (nth  5 CG_GLOBAL$) "G*" )
        (setq #PANEL_DB_NAME "パネル厚み_GATE");ｹﾞｰﾄﾀｲﾌﾟ
        ;else
        (setq #PANEL_DB_NAME "パネル厚み");ｹﾞｰﾄﾀｲﾌﾟ以外
      );_if
      ;2009/04/14 YM ADD-E

      (setq #T$$
        (CFGetDBSQLRec CG_DBSESSION #PANEL_DB_NAME
          (list
            (list "扉シリ記号"     (nth 12 CG_GLOBAL$) 'STR)
            (list "扉カラ記号"     (nth 13 CG_GLOBAL$) 'STR)
          )
        )
      )
      (setq #T$ (DBCheck #T$$ "『パネル厚み』" "PKGetSQL_HUKU_KANRI"))
      (setq #TTT (nth 4 #T$));FP厚み

      ;2011/03/29 YM ADD-S 新ｽｲｰｼﾞｨ対応 場合わけ
      (cond
        ((= BU_CODE_0008 "1") 
          ;SKB ｼﾝｸ記号をKEYに追加
          (setq #LIST$$
            (list
              (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
              (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
              (list "商品タイプ"         "5"                 'INT)
              (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
              (list "天板高さ"           (nth 31 CG_GLOBAL$) 'STR)
              (list "厚み"               #TTT                'STR)
              (list "シンク記号"         (nth 17 CG_GLOBAL$) 'STR);2011/03/29 YM ADD
            )
          )
        )
        (T
          ;従来
          (setq #LIST$$
            (list
              (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
              (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
              (list "商品タイプ"         "5"                 'INT)
              (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
              (list "天板高さ"           (nth 31 CG_GLOBAL$) 'STR)
              (list "厚み"               #TTT                'STR)
            )
          )
        )
      );_cond

    )

    ;2010/10/13 YM ADD-S
    ;// 中間BOX
    ((= &styp 7)
      (setq #DB_NAME1 "複合中間BOX管理")
      (setq #DB_NAME2 "複合中間BOX構成")

      (setq #LIST$$
        (list
          (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
          (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
          (list "商品タイプ"         "7"                 'INT)
          (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
          (list "天板高さ"           (nth 31 CG_GLOBAL$) 'STR)
          (list "扉シリ記号"         (nth 12 CG_GLOBAL$) 'STR)
        )
      )
    )
    ;2010/10/13 YM ADD-E

    ;2017/09/07 YM ADD-S
    ;// 複合カウンタ 商品タイプ=11
    ((= &styp 11)
      (setq #DB_NAME1 "複合カウンタ管理")
      (setq #DB_NAME2 "複合カウンタ構成")

      (setq #LIST$$
        (list
          (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
          (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
          (list "フロアキャビタイプ" (nth  6 CG_GLOBAL$) 'STR) ;2017/10/05 YM ADD
          (list "商品タイプ"         "11"                'INT)
          (list "食洗位置"           (nth 10 CG_GLOBAL$) 'STR) ;2017/10/23 YM ADD
          (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
          (list "カウンタ材質"       (nth 16 CG_GLOBAL$) 'STR)
        )
      )
    )
    ;2017/09/07 YM ADD-E


    ;2017/09/07 YM ADD-S
    ;// 複合コンロ管理 商品タイプ=12 追加理由：ﾌﾚｰﾑｷｯﾁﾝ「ｶﾞｽ」で海外だと横ﾌﾚｰﾑが変化、ｸﾞﾘﾙなしでﾌﾛﾝﾄｽﾘｯﾄ必要構成が変化
    ((= &styp 12) ; 2017/10/05 YM ADD FK対応
      (setq #DB_NAME1 "複合コンロ管理")
      (setq #DB_NAME2 "複合コンロ構成")

      (setq #LIST$$
        (list
          (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
          (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
          (list "商品タイプ"         "12"                'INT)
          (list "フロアキャビタイプ" (nth  6 CG_GLOBAL$) 'STR) ;2017/10/05 YM ADD
          (list "シンク位置"         (nth  2 CG_GLOBAL$) 'STR)
          (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
          (list "天板高さ"           (nth 31 CG_GLOBAL$) 'STR)
          (list "コンロ記号"         (nth 20 CG_GLOBAL$) 'STR)
        )
      )
    )
    ;2017/09/07 YM ADD-E


    ;2017/09/07 YM ADD-S
    ;// 複合食洗管理 商品タイプ=14 追加理由：ﾌﾚｰﾑｷｯﾁﾝ「食洗450」でﾐｰﾚ食洗を登録すると棚板が不要になって構成が変化するから
    ((= &styp 14) ; 2017/10/05 YM ADD FK対応
      (setq #DB_NAME1 "複合食洗管理")
      (setq #DB_NAME2 "複合食洗構成")

      (setq #LIST$$
        (list
          (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
          (list "商品タイプ"         "14"                'INT)
          (list "食洗位置"           (nth 10 CG_GLOBAL$) 'STR) ;2017/10/13 YM ADD
          (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
          (list "天板高さ"           (nth 31 CG_GLOBAL$) 'STR)
          (list "食洗記号"           (nth 42 CG_GLOBAL$) 'STR)
        )
      )
    )
    ;2017/09/07 YM ADD-E


    ;// コンロ
    ((= &styp 2)
      (setq #DB_NAME1 "複合管理")
      (setq #DB_NAME2 "複合構成")

      ;2009/02/10 YM ADD-S
      (if (/= "B" (nth 21 CG_GLOBAL$))
        (setq #under_GAS "O");ｺﾝﾛｷｬﾋﾞでない場合(ｵｰﾌﾞﾝ)
        ;else
        (setq #under_GAS "B");ｺﾝﾛｷｬﾋﾞ
      );_if
     
      (setq #LIST$$
        (list
          (list "ユニット記号"       (nth  3 CG_GLOBAL$) 'STR)
          (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
          (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
          (list "商品タイプ"         "2"                 'INT)
          (list "フロアキャビタイプ" (nth  6 CG_GLOBAL$) 'STR)
          (list "シンク位置"         (nth  2 CG_GLOBAL$) 'STR)
          (list "コンロ位置"         (nth  9 CG_GLOBAL$) 'STR)
          (list "食洗位置"           (nth 10 CG_GLOBAL$) 'STR)
          (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
          (list "シンク記号"         (nth 17 CG_GLOBAL$) 'STR);2008/09/17 YM ADD
          ;2009/02/10 YM ADD-S
;;;         (list "コンロ下設置"       (nth 21 CG_GLOBAL$) 'STR)
          (list "コンロ下設置"       #under_GAS          'STR)
          ;2009/02/10 YM ADD-E
          (list "SOFT_CLOSE"         (nth  8 CG_GLOBAL$) 'STR)
          (list "天板_吊戸高さ"      (nth 31 CG_GLOBAL$) 'STR)
          (list "コンロ脇調理"                       "_" 'STR);2009/02/06 YM MOD きめうち対応する項目が現在はない
        )
      )
    )

    ;// レンジフード
    ((= &styp 3)
      (setq #DB_NAME1 "複合管理")
      (setq #DB_NAME2 "複合構成")

      (setq #LIST$$
        (list
          (list "ユニット記号"       (nth  3 CG_GLOBAL$) 'STR)
          (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
          (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
          (list "商品タイプ"         "3"                 'INT)
          (list "天板_吊戸高さ"      (nth 32 CG_GLOBAL$) 'STR)
          (list "HOOD記号"           (nth 23 CG_GLOBAL$) 'STR)
        )
      )
    )

    
    ;レンジフード(SKB専用) 2011/01/26 YM ADD
    ((= &styp 9)
      (setq #DB_NAME1 "HOOD高さ")
      (setq #DB_NAME2 "複合HOOD")

      ;ﾌｰﾄﾞの高さを求める
      (setq #LIST$$
        (list
          (list "PLAN32"      (nth 32 CG_GLOBAL$) 'STR)
        )
      )
    )

    ;// 食洗機器
    ((= &styp 4)
      (setq #DB_NAME1 "複合管理")
      (setq #DB_NAME2 "複合構成")

      (setq #LIST$$
        (list
          (list "ユニット記号"       (nth  3 CG_GLOBAL$) 'STR)
          (list "商品タイプ"         "4"                 'INT)
          (list "フロアキャビタイプ" (nth  6 CG_GLOBAL$) 'STR)
          (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
          (list "シンク記号"         (nth 17 CG_GLOBAL$) 'STR);2008/10/06 YM ADD
          (list "SOFT_CLOSE"         (nth  8 CG_GLOBAL$) 'STR)
          (list "天板_吊戸高さ"      (nth 31 CG_GLOBAL$) 'STR)
          (list "食洗記号"           (nth 42 CG_GLOBAL$) 'STR)
        )
      )
    )

  );_cond



  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME1 #LIST$$)
  )

  ;2011/03/24 YM ADD-S
  (if (equal &styp 7.0 0.001)
    (progn
      ;[複合中間BOX管理]にﾚｺｰﾄﾞがなかったら空振りさせる
      ;ﾌﾗｸﾞを立てて後続のﾌﾛﾝﾄﾊﾟﾈﾙ,取付金具のY座標をずらす必要がある
      (if (= nil #qry$)
        (setq CG_NO_BOX_FLG T)
        ;else
        (progn
          (setq CG_NO_BOX_FLG nil)
          (setq #qry$ (DBCheck #qry$ "『複合**管理』" "PKGetSQL_HUKU_KANRI"))
        )
      );_if
    )
    (progn
      (setq #qry$ (DBCheck #qry$ "『複合**管理』" "PKGetSQL_HUKU_KANRI")) ; 検索結果WEB版ﾛｸﾞ出力
    )
  );_if

  ;複合構成　または　【複合HOOD】
  (cond
    ;2010/10/13 YM MOD &styp=7 追加==> 2011/03/24 YM MOD &styp=7分離
    ((or (equal &styp 1.0 0.001)(equal &styp 5.0 0.001))
      ; 複合ID or ID
      (setq #huku_id (nth 0 #qry$))
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "ID"  #huku_id  'STR)
            (list "order by \"RECNO\"" nil  'ADDSTR)
          )
        )
      )
    )
    ;2010/10/13 YM MOD &styp=7 追加
    ((equal &styp 7.0 0.001)

      ; 複合ID or ID
      (if CG_NO_BOX_FLG
        (progn
          nil ;[複合中間BOX管理]にﾚｺｰﾄﾞがなし空振り
          (setq #qry$$ nil)
        )
        (progn
          (setq #huku_id (nth 0 #qry$))
          (setq #qry$$
            (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
              (list
                (list "ID"  #huku_id  'STR)
                (list "order by \"RECNO\"" nil  'ADDSTR)
              )
            )
          )
        )
      );_if

    )

    ;2017/09/07 YM ADD &styp=11 追加
    ((or (equal &styp 11.0 0.001)(equal &styp 12.0 0.001)(equal &styp 14.0 0.001)) ;【複合カウンタ構成】【複合食洗構成】【複合コンロ構成】2017/10/05 YM ADD FK対応

  		; 複合ID or ID
      (setq #huku_id (nth 0 #qry$))
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "ID"  #huku_id  'STR)
            (list "order by \"RECNO\"" nil  'ADDSTR)
          )
        )
      )

    )


    ((or (equal &styp 2.0 0.001)(equal &styp 3.0 0.001)(equal &styp 4.0 0.001) )

      ; 複合ID or ID
      (setq #huku_id (nth 0 #qry$))

      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "複合ID"  #huku_id  'STR)
            (list "order by \"RECNO\"" nil  'ADDSTR)
          )
        )
      )
    )

    ;2011/01/26 YM ADD 【複合管理】を使わずにﾌｰﾄﾞを引き当てる仕組み
    ((equal &styp 9.0 0.001)

      ; ﾌｰﾄﾞ高さ
      (setq #HOOD_H (nth 1 #qry$))

;  &pln$  ;(LIST)『プラ構成』情報
;  &styp  ; 商品ﾀｲﾌﾟ

      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "PLAN23"   (nth 23 CG_GLOBAL$) 'STR)
            (list "間口"     (nth  2 &pln$)      'STR);"HOOD750","HOOD900"を想定
            (list "高さ"     #HOOD_H             'STR)
          )
        )
      )
    )

    
  );_cond

  (if CG_NO_BOX_FLG
    nil
    ;else
    (if (= #qry$$ nil)
      (progn
        (setq #msg (strcat "『複合**構成』にレコードがありません。\nPKGetSQL_HUKU_KANRI"))
        (CMN_OutMsg #msg)
      )
    );_if
  );_if
  
  (list #qry$ #qry$$)
);PKGetSQL_HUKU_KANRI

;;;<HOM>*************************************************************************
;;; <関数名>    : FK_PosWTR_plan
;;; <処理概要>  : 水栓を配置する(ﾌﾚｰﾑｷｯﾁﾝ　プラン検索)
;;; <戻り値>    :
;;;        LIST : 水栓穴(G_WTR)図形のリスト
;;; <作成>      : 2017/10/11 YM ADD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun FK_PosWTR_plan (
  /
	#ANA_LAYER #ANG #DB_NAME #DUM_EN #DWG #EN #FIG-QRY$ #HH #HINBAN #I #II #K #KEI 
	#LIST$$ #LOOP #LR #MSG #O #OS #PTEN5 #PTEN5$ #PTEN5$$ #QRY$ #RET$ #SA #SM #SS_DUM 
	#SS_SYOMEN #SUI-QRY$ #WTRHOLEEN$ #XD_PTEN$ #XD_PTEN5$ #ZOKU #ZOKUP #ZOKUP$ #ZZ	
  )

  ;// システム変数保管
  (setq #os (getvar "OSMODE"))   ;Oスナップ
  (setq #sm (getvar "SNAPMODE")) ;スナップ
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)

  (if (not (tblsearch "APPID" "G_WTR")) (regapp "G_WTR"))

  (setq #pten5$$ nil)

  (setq #ret$ (KPGetPTEN 5)) ; 01/06/27 YM 関数化
  (setq #pten5$    (car  #ret$)) ; PTEN5図形ﾘｽﾄ
  (setq #xd_pten5$ (cadr #ret$)) ; "G_PTEN"ﾘｽﾄ
  (setq #i 0)
  (repeat (length #pten5$) ; ﾘｽﾄを合わせる
    (setq #pten5$$ (append #pten5$$ (list (list (nth #i #pten5$)(nth #i #xd_pten5$)))))
    (setq #i (1+ #i))
  )

  ;複合水栓から品番を取得する
  (setq #DB_NAME "複合水栓")
  (setq #LIST$$ (list (list "記号" (nth 19 CG_GLOBAL$)'STR)));水栓の種類
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$))
  (setq #qry$ (DBCheck #qry$ "『複合水栓』" "PKW_WorkTop"))
  (setq #hinban (nth 1 #qry$))       ; 品番名称
  (setq #LR     (nth 2 #qry$))       ; LR区分

  (setq #fig-qry$
    (CFGetDBSQLRec CG_DBSESSION "品番図形"
      (list
        (list "品番名称" #hinban  'STR)
        (list "LR区分"   #LR      'STR)
      )
    )
  )
  (setq #fig-qry$ (DBCheck #fig-qry$ "『品番図形』" (strcat "品番名称=" #hinban)))
  ;水栓図形ID
  (setq #dwg (nth 6 #fig-qry$));2008/06/28 OK!

  ;[水栓位置]を検索して配置位置の水栓穴属性を求める
  (setq #sui-qry$
    (CFGetDBSQLRec CG_DBSESSION "水栓位置"
      (list
        (list "シンク記号" (nth 17 CG_GLOBAL$) 'STR)
        (list "シンク勝手" (nth 11 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #sui-qry$ (DBCheck #sui-qry$ "『水栓位置』" (strcat "シンク=" (nth 17 CG_GLOBAL$))))

  (setq #zoku (nth 3 #sui-qry$))   ; 水栓1の配置位置属性

  ;2009/02/06 YM ADD-S 水栓2穴対応
  ;水栓穴２が選択されていてしかもﾏﾙﾁｼﾝｸなら主水栓の位置が変わる
  (if (and (= "B" (nth 18 CG_GLOBAL$))(wcmatch (nth 17 CG_GLOBAL$) "G*" ))
    (progn
      (setq #zoku (nth 4 #sui-qry$))   ; 水栓1の配置位置属性
    )
  );_if
  ;2009/02/06 YM ADD-E 水栓2穴対応

  (setq #k 0)
  (setq #zokuP$ '())
  (foreach #pten5$ #pten5$$
    (setq #xd_PTEN$ (cadr #pten5$))    ; 拡張ﾃﾞｰﾀ"G_PTEN"
    (setq #zokuP (nth 2 #xd_PTEN$))    ; 属性
    (if (and (= #zokuP #zoku)               ; 属性が同じなら水栓配置
             (= (member #zokuP #zokuP$) nil))
      (progn
        (setq #zokuP$ (append #zokuP$ (list #zokuP))) ; PTEN5図形名
        (setq #pten5 (car  #pten5$))   ; PTEN5図形名
        (setq #kei (nth 1 #xd_PTEN$))  ; 穴径
        (setq #o (cdr (assoc 10 (entget #pten5)))) ; 中心点座標
        ; 水栓ありで「水栓」なしの場合 01/01/15 YM ADD
        ;;;  (setq #ANA_layer "Z_00_00_00_01" ) ; 目に見える
        (setq #ANA_layer SKW_AUTO_SECTION) ; 目に見えない
;-- 2011/09/09 A.Satoh Del - S
;        (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"の円を作成する
;
;
;        ;// 水栓穴拡張データを設定
;        (CFSetXData #dum "G_WTR" (list #zokuP))
;        (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; 水栓穴図形名
;-- 2011/09/09 A.Satoh Del - E
        ;// 水栓金具の配置

        (setq #ang 0.0) ; ｼﾝｸが存在しないとき配置角度0固定



        ;;; 図形が存在するか確認
        (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")));2008/06/28 OK!
          (progn
            (setq #msg (strcat "水栓図形 : ID=" #dwg " がありません"));2008/06/28 OK!
            (CMN_OutMsg #msg) ; 02/09/05 YM ADD
          )
        )

        ;// インサート
        (WebOutLog "水栓を挿入します(PKW_PosWTR_plan)")
        (command "_insert"
          (strcat CG_MSTDWGPATH #dwg) ; 品番図形.図形ID ;2008/06/28 OK!
          #o
          1
          1
          (rtd #ang)
        )
        (command "_explode" (entlast))
        (setq #ss_dum (ssget "P"))

        ;2008/09/01 YM ADD-S 正面図だけ抽出する
        (setq #ss_syomen (ssget "P" (list (cons 8 "Z_03_04_*"))));正面施工図の画層
        ;2008/09/01 YM ADD-E 正面図だけ抽出する


        (SKMkGroup #ss_dum)

        ;04/01/24 YM ADD-S (ssname #ss_dum 0)の図形が不正な場合の回避
        (setq #ii 0 #loop T)
        (while (and #loop (< #ii 10))
          (setq #dum_en (ssname #ss_dum #ii))
          (if (and (= 'ENAME (type #dum_en))(entget #dum_en))
            (setq #loop nil)
          );_if
          (setq #ii (1+ #ii))
        )
        ;04/01/24 YM ADD-E (ssname #ss_dum 0)の図形が不正な場合の回避
        
;;;        (setq #en (SKC_GetSymInGroup #dum_en));04/01/24 YM MOD
         (setq #en (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

        ;// 拡張データの付加
        (WebOutLog "拡張ﾃﾞｰﾀ G_LSYM を設定します(PKW_PosWTR_plan)")
        (CFSetXData #en "G_LSYM"
          (list
            (nth 6 #fig-qry$)          ;1 :本体図形ID  ; 品番図形.図形ＩＤ ;2008/06/28 OK!
            #o                         ;2 :挿入点
            0.0                        ;3 :回転角度
            CG_Kcode                   ;4 :工種記号
            CG_SeriesCode              ;5 :SERIES記号
            (nth 0 #fig-qry$)          ;6 :品番名称
            "Z"                        ;7 :L/R 区分
            ""                         ;8 :扉図形ID
            ""                         ;9 :扉開き図形ID
            CG_SKK_INT_SUI             ;10:性格CODE ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
            2                          ;11:複合フラグ
            0                          ;12:レコード番号
            (fix (nth 2 #fig-qry$))    ;13:用途番号 ;2008/06/28 OK!
            0.0                        ;14:寸法H
            1                          ;15:断面指示の有無
            "A"                        ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
          )
        );_CFSetXData

				;2019/04/26 YM ADD
				(KcSetG_OPT #en) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ

      )
    );_if
  );_foreach

  ;2008/09/01 YM ADD 水栓正面壁だしの絵の高さを天板高さに応じて調整する
  ;天板高さ
  (setq #HH (atoi (substr (nth 31 CG_GLOBAL$) 2 3)));H850,H900,H800
  ;水栓配置高さ
  (setq #ZZ (nth 2 #o))
  (setq #SA (- #HH #ZZ))
  ;もし差がある場合に正面図だけ移動する
  (if (< 0.1 (abs #sa))
    (command "._MOVE" #ss_syomen "" "0,0,0" (strcat "@0,0," (rtos #SA)) ) ; 図形移動
  );_if

  ;// システム変数を元に戻す
  (setvar "OSMODE"   #os)
  (setvar "SNAPMODE" #sm)

  #WtrHoleEn$  ;// 水栓穴(G_WTR)底面図形を返す
);FK_PosWTR_plan

;;;<HOM>*************************************************************************
;;; <関数名>    : FK_PosWTR_plan
;;; <処理概要>  : 水栓を配置する(ﾌﾚｰﾑｷｯﾁﾝ　プラン検索)
;;; <戻り値>    :
;;;        LIST : 水栓穴(G_WTR)図形のリスト
;;; <作成>      : 2017/10/11 YM ADD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun FK_PosWTR_plan2 (
  /
	#ANA_LAYER #ANG #DB_NAME #DUM_EN #DWG #EN #FIG-QRY$ #HH #HINBAN #I #II #K #KEI 
	#LIST$$ #LOOP #LR #MSG #O #OS #PTEN5 #PTEN5$ #PTEN5$$ #QRY$ #RET$ #SA #SM #SS_DUM 
	#SS_SYOMEN #SUI-QRY$ #WTRHOLEEN$ #XD_PTEN$ #XD_PTEN5$ #ZOKU #ZOKUP #ZOKUP$ #ZZ	
  )

  ;// システム変数保管
  (setq #os (getvar "OSMODE"))   ;Oスナップ
  (setq #sm (getvar "SNAPMODE")) ;スナップ
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)

  (if (not (tblsearch "APPID" "G_WTR")) (regapp "G_WTR"))

  (setq #pten5$$ nil)

  (setq #ret$ (KPGetPTEN 5)) ; 01/06/27 YM 関数化
  (setq #pten5$    (car  #ret$)) ; PTEN5図形ﾘｽﾄ
  (setq #xd_pten5$ (cadr #ret$)) ; "G_PTEN"ﾘｽﾄ
  (setq #i 0)
  (repeat (length #pten5$) ; ﾘｽﾄを合わせる
    (setq #pten5$$ (append #pten5$$ (list (list (nth #i #pten5$)(nth #i #xd_pten5$)))))
    (setq #i (1+ #i))
  )

  ;複合水栓から品番を取得する
  (setq #DB_NAME "複合水栓")
  (setq #LIST$$ (list (list "記号" (nth 22 CG_GLOBAL$)'STR)));水栓の種類
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$))
  (setq #qry$ (DBCheck #qry$ "『複合水栓』" "PKW_WorkTop"))
  (setq #hinban (nth 1 #qry$))       ; 品番名称
  (setq #LR     (nth 2 #qry$))       ; LR区分

  (setq #fig-qry$
    (CFGetDBSQLRec CG_DBSESSION "品番図形"
      (list
        (list "品番名称" #hinban  'STR)
        (list "LR区分"   #LR      'STR)
      )
    )
  )
  (setq #fig-qry$ (DBCheck #fig-qry$ "『品番図形』" (strcat "品番名称=" #hinban)))
  ;水栓図形ID
  (setq #dwg (nth 6 #fig-qry$));2008/06/28 OK!

  ;[水栓位置]を検索して配置位置の水栓穴属性を求める
  (setq #sui-qry$
    (CFGetDBSQLRec CG_DBSESSION "水栓位置"
      (list
        (list "シンク記号" (nth 17 CG_GLOBAL$) 'STR)
        (list "シンク勝手" (nth 11 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #sui-qry$ (DBCheck #sui-qry$ "『水栓位置』" (strcat "シンク=" (nth 17 CG_GLOBAL$))))

  (setq #zoku (nth 5 #sui-qry$))   ; 水栓1の配置位置属性

  ;2009/02/06 YM ADD-S 水栓2穴対応
  ;水栓穴２が選択されていてしかもﾏﾙﾁｼﾝｸなら主水栓の位置が変わる
  (if (and (= "B" (nth 18 CG_GLOBAL$))(wcmatch (nth 17 CG_GLOBAL$) "G*" ))
    (progn
      (setq #zoku (nth 4 #sui-qry$))   ; 水栓1の配置位置属性
    )
  );_if
  ;2009/02/06 YM ADD-E 水栓2穴対応

  (setq #k 0)
  (setq #zokuP$ '())
  (foreach #pten5$ #pten5$$
    (setq #xd_PTEN$ (cadr #pten5$))    ; 拡張ﾃﾞｰﾀ"G_PTEN"
    (setq #zokuP (nth 2 #xd_PTEN$))    ; 属性
    (if (and (= #zokuP #zoku)               ; 属性が同じなら水栓配置
             (= (member #zokuP #zokuP$) nil))
      (progn
        (setq #zokuP$ (append #zokuP$ (list #zokuP))) ; PTEN5図形名
        (setq #pten5 (car  #pten5$))   ; PTEN5図形名
        (setq #kei (nth 1 #xd_PTEN$))  ; 穴径
        (setq #o (cdr (assoc 10 (entget #pten5)))) ; 中心点座標
        ; 水栓ありで「水栓」なしの場合 01/01/15 YM ADD
        ;;;  (setq #ANA_layer "Z_00_00_00_01" ) ; 目に見える
        (setq #ANA_layer SKW_AUTO_SECTION) ; 目に見えない
;-- 2011/09/09 A.Satoh Del - S
;        (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"の円を作成する
;
;
;        ;// 水栓穴拡張データを設定
;        (CFSetXData #dum "G_WTR" (list #zokuP))
;        (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; 水栓穴図形名
;-- 2011/09/09 A.Satoh Del - E
        ;// 水栓金具の配置

        (setq #ang 0.0) ; ｼﾝｸが存在しないとき配置角度0固定



        ;;; 図形が存在するか確認
        (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")));2008/06/28 OK!
          (progn
            (setq #msg (strcat "水栓図形 : ID=" #dwg " がありません"));2008/06/28 OK!
            (CMN_OutMsg #msg) ; 02/09/05 YM ADD
          )
        )

        ;// インサート
        (WebOutLog "水栓を挿入します(PKW_PosWTR_plan)")
        (command "_insert"
          (strcat CG_MSTDWGPATH #dwg) ; 品番図形.図形ID ;2008/06/28 OK!
          #o
          1
          1
          (rtd #ang)
        )
        (command "_explode" (entlast))
        (setq #ss_dum (ssget "P"))

        ;2008/09/01 YM ADD-S 正面図だけ抽出する
        (setq #ss_syomen (ssget "P" (list (cons 8 "Z_03_04_*"))));正面施工図の画層
        ;2008/09/01 YM ADD-E 正面図だけ抽出する


        (SKMkGroup #ss_dum)

        ;04/01/24 YM ADD-S (ssname #ss_dum 0)の図形が不正な場合の回避
        (setq #ii 0 #loop T)
        (while (and #loop (< #ii 10))
          (setq #dum_en (ssname #ss_dum #ii))
          (if (and (= 'ENAME (type #dum_en))(entget #dum_en))
            (setq #loop nil)
          );_if
          (setq #ii (1+ #ii))
        )
        ;04/01/24 YM ADD-E (ssname #ss_dum 0)の図形が不正な場合の回避
        
;;;        (setq #en (SKC_GetSymInGroup #dum_en));04/01/24 YM MOD
         (setq #en (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

        ;// 拡張データの付加
        (WebOutLog "拡張ﾃﾞｰﾀ G_LSYM を設定します(PKW_PosWTR_plan)")
        (CFSetXData #en "G_LSYM"
          (list
            (nth 6 #fig-qry$)          ;1 :本体図形ID  ; 品番図形.図形ＩＤ ;2008/06/28 OK!
            #o                         ;2 :挿入点
            0.0                        ;3 :回転角度
            CG_Kcode                   ;4 :工種記号
            CG_SeriesCode              ;5 :SERIES記号
            (nth 0 #fig-qry$)          ;6 :品番名称
            "Z"                        ;7 :L/R 区分
            ""                         ;8 :扉図形ID
            ""                         ;9 :扉開き図形ID
            CG_SKK_INT_SUI             ;10:性格CODE ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
            2                          ;11:複合フラグ
            0                          ;12:レコード番号
            (fix (nth 2 #fig-qry$))    ;13:用途番号 ;2008/06/28 OK!
            0.0                        ;14:寸法H
            1                          ;15:断面指示の有無
            "A"                        ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
          )
        );_CFSetXData
      )
    );_if
  );_foreach

  ;2008/09/01 YM ADD 水栓正面壁だしの絵の高さを天板高さに応じて調整する
  ;天板高さ
  (setq #HH (atoi (substr (nth 31 CG_GLOBAL$) 2 3)));H850,H900,H800
  ;水栓配置高さ
  (setq #ZZ (nth 2 #o))
  (setq #SA (- #HH #ZZ))
  ;もし差がある場合に正面図だけ移動する
  (if (< 0.1 (abs #sa))
    (command "._MOVE" #ss_syomen "" "0,0,0" (strcat "@0,0," (rtos #SA)) ) ; 図形移動
  );_if

  ;// システム変数を元に戻す
  (setvar "OSMODE"   #os)
  (setvar "SNAPMODE" #sm)

  #WtrHoleEn$  ;// 水栓穴(G_WTR)底面図形を返す
);FK_PosWTR_plan2

;<HOM>*************************************************************************
; <関数名>    : PKW_WorkTop
; <処理概要>  : （プラン検索用）ワークトップを生成する
; <引数>      : なし
; <戻り値>    : なし
; <作成>      : 1999-12-20 川本清二 2000.1 修正YM 04/10 修正 新式WT
;               00/07/27 YM MOD 新ﾌﾟﾗﾝ検索ｷｯﾁﾝ部
; <備考>      :
;               (プラン確定時に設定)
;                 CG_Type1Code
;                 CG_Type2Code
;                 CG_KCode
;                 CG_SeriesCode
;                 CG_WTZaiCode
;                 (nth 11 CG_GLOBAL$)
;                 CG_SinkCode
;               (レイアウト時に設定)
;                 CG_SINK_ENT     ;シンク図形
;                 CG_GAS_ENT      ;ガスコンロ図形
;*************************************************************************>MOH<
(defun PKW_WorkTop ( ; プラン検索内
  /
  #BASEPT #BASESYM$ #EN_LOW$ #G_WTR$ #I #OUTPL #OUTPL_LOW #PT$ #PT_LOW$ #QRY$ #QRY$$
  #SETXD$ #SKK$ #SS #STEP #W-XD$ #WT #WTINFO$ #WT_SOLID$ #XD_SYM$ #ZAIF
  #H #THR #SINA_Type #FLAG #WTBASE #OUTPL$ #LIST$$ #DB_NAME
;-- 2011/10/20 A.Satoh Del - S
;;;;;;-- 2011/09/21 A.Satoh Add - S
;;;;;  #handle$ #WT_SOLID
;;;;;;-- 2011/09/21 A.Satoh Add - E
;-- 2011/10/20 A.Satoh Del - E
  )
  (setvar "pdmode" 34)
  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart);  00/02/07 1/31からコピー

  ; 商品ﾀｲﾌﾟ取得 01/06/27 YM ADD
  (setq #SINA_Type (KPGetSinaType))
  (if (equal #SINA_Type 2 0.1)  ; 商品ﾀｲﾌﾟ=2(ﾐﾆｷｯﾁﾝ)ならWT自動生成しない
    (setq #FLAG nil) ; 特殊処理
    (setq #FLAG T)   ; 通常処理
  );_if

  (if #FLAG  ; ﾐﾆｷｯﾁﾝではないとき
    (progn

      ;// プラン検索時の基準点は (0 0 0)固定
      (setq #BasePt (list 0 0 0))
      (command "vpoint" "0,0,1") ;  "LWPOLYLINE"  画層: "Z_wtbase"
      ;// ベースキャビネットを検索
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #skk$ (CFGetSymSKKCode (ssname #ss #i) nil))
        (setq #xd_SYM$ (CFGetXData (ssname #ss #i) "G_SYM"))
        ;03/11/15 YM MOD-S ﾃﾞｨﾌﾟﾛｱ対応 "117"は除外する

        (if (and (= (car #skk$) CG_SKK_ONE_CAB) (= (cadr #skk$) CG_SKK_TWO_BAS)
                 (/= (caddr #skk$) CG_SKK_THR_DIN));03/11/15 YM
          (if (equal (nth 6 #xd_SYM$) 0 0.01)
            (if (PK_ChkBaseSYM (ssname #ss #i)) ; 上にｷｬﾋﾞﾈｯﾄがある
              (princ)
              (setq #BaseSym$ (cons (ssname #ss #i) #BaseSym$)) ; ベースキャビネットばかり 性格ｺｰﾄﾞ=11?

            );_if
          );_if
        );_if

        (cond
          ((= (car #skk$) 4)
            (setq CG_SINK_ENT (ssname #ss #i)) ; ｼﾝｸ図形名
          )
          ((= (car #skk$) 2)
            (setq CG_GAS_ENT (ssname #ss #i))  ; ｶﾞｽ図形名
          )
        );_cond
        (setq #i (1+ #i))
      );_(repeat (sslength #ss)

      (setq #step nil)

      (if #BaseSym$
        (progn
          (foreach #BaseSym #BaseSym$
            (KPMovePmen2_Z_0 #BaseSym) ; ｼﾝﾎﾞﾙ位置Zが0でないとき、PMEN2の高さをZ=0にする
          )
        )
      );_if

      ;// ベースキャビからワークトップのダミーの外形領域を作成する
      (setq #outpl (PKW_MakeSKOutLine #BaseSym$ #step)) ; 引数; ベースキャビネットばかり 性格ｺｰﾄﾞ=11?  #outpl ﾍﾞｰｽ底面ﾎﾟﾘﾗｲﾝ  ; 00/03/13 ADD step 段差

      (setq #pt$ (GetLWPolyLinePt #outpl)) ; 除外前の外形点列
      (setq #outpl$ (PKW_MakeSKOutLine3 #BaseSym$))    ; ｷｬﾋﾞ除外前の外形領域を求める
      (setq CG_GAIKEI (GetLWPolyLinePt (car #outpl$))) ; 除外前の外形点列
      ; 外形点列を後でPLINEにしてから"G_WRKT"にｾｯﾄする段差部も含んだ全外形点列
      ; (この時点では前垂れやWT奥行き拡張を含んでいないがあとで考慮する)

      (setq #pt$ (GetLWPolyLinePt #outpl))    ; 除外前の外形点列

  ;;;   (PKW_SetGlobalFromBaseCab2 #BaseSym$)   ; 間口２記号の判定

      ;// ﾛｰｷｬﾋﾞ部材 nil固定
      (setq #en_LOW$ '())

      ;// Ｏスナップ関連システム変数の解除
      (CFNoSnapStart)

      ;;; WT情報 WT素材の検索
      (setq #WTInfo$ (PKGetWTInfo_plan #pt$ (list #pt$) #BaseSym$ #BaseSym$ #outpl_LOW)) ; (list #WTInfo #retWT_BG_FG$ #SetXd$ #CUT_KIGO$ #CG_WtDepth)
      ;// ワークトップの生成 U型対応
      (setq #WT_SOLID$ (PK_MakeWorktop3 #WTInfo$ #en_LOW$ #pt_LOW$))

      ;// ダミーの外形領域を削除
      (entdel #outpl)

      (entdel (car #outpl$))

    )
  );_if

;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ;2008/06/23 YM DEL 【水栓配置処理要修正】
  (princ "水栓を配置します")

  ;2009/02/06 YM ADD 「水栓穴なし」対応 if文追加
  (if (= "N" (nth 18 CG_GLOBAL$));水栓穴なしではないとき
    (progn
      ;2009/02/06 YM ADD
      (princ "水栓穴なしのため、水栓を配置しませんでした")
    )
    (progn ; 従来ﾛｼﾞｯｸ [主水栓の配置]
      
      (setq #g_wtr$
        (PKW_PosWTR_plan
          CG_KCode        ;(STR)工種記号
          CG_SeriesCode   ;(STR)SERIES記号
          CG_SINK_ENT     ;(ENAME)シンク基準図形
          (nth 17 CG_GLOBAL$)     ;(STR)シンク記号
          #qry$$          ;水栓構成ﾚｺｰﾄﾞのﾘｽﾄ nil あり<---この引数だけｼﾝｸ配置ｺﾏﾝﾄﾞと違う
        )
      )
      (princ "水栓を配置しました")

    )
  );_if


  ;2009/02/06 YM ADD 水栓2穴対応
  (if (and (=  "B" (nth 18 CG_GLOBAL$)) ;水栓2穴のとき
           (/= "_" (nth 19 CG_GLOBAL$)));水栓2穴あり
    (progn ; [水栓2穴の配置]
      
      (setq #g_wtr$
        (PKW_PosWTR_plan_2
          CG_KCode        ;(STR)工種記号
          CG_SeriesCode   ;(STR)SERIES記号
          CG_SINK_ENT     ;(ENAME)シンク基準図形
          (nth 17 CG_GLOBAL$)     ;(STR)シンク記号
          #qry$$          ;水栓構成ﾚｺｰﾄﾞのﾘｽﾄ nil あり<---この引数だけｼﾝｸ配置ｺﾏﾝﾄﾞと違う
        )
      )
      (princ "水栓2穴を配置しました")
    )
  );_if




;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  ;2008/06/23 YM DEL 【水栓配置処理要修正】
;;; (if #FLAG ; ﾐﾆｷｯﾁﾝではないとき
;;;   (progn
;;;
;;;       ;// 水栓関連の拡張データを再設定
;;;       (setq #setxd$ (list (list 22 (length #g_wtr$))))
;;;       (setq #i 23)
;;;       (foreach #en #g_wtr$
;;;         (setq #setxd$ (append #setxd$ (list (list #i #en))))
;;;         (setq #i (1+ #i))
;;;       )
;;;
;;;       (setq #ZaiF (KCGetZaiF (nth 16 CG_GLOBAL$))) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
;;;       ;// ワークトップ拡張データの更新
;;;
;;;       (cond ; 01/05/02 YM ADD 左勝手時に不具合
;;;         ; 人大,左勝手,L型
;;;         ((and (or (= #ZaiF 0)(= #ZaiF -1))(= (nth  5 CG_GLOBAL$) "L")(= (nth 11 CG_GLOBAL$) "L"))
;;;           (setq #WT (cadr #WT_SOLID$))
;;;         )
;;;         ; それ以外
;;;         (T (setq #WT (car #WT_SOLID$))) ; 通常(今まで)
;;;       );_cond
;;;
;;;       (setq #w-xd$ (CFGetXData #WT "G_WRKT"))
;;;       (CFSetXData #WT "G_WRKT"
;;;         (CFModList #w-xd$ #setxd$)
;;;       )
;;;   )
;;; );_if




;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ;2008/06/23 YM DEL 【ﾜｰｸﾄｯﾌﾟ品番確定処理要修正】
  (if #FLAG  ; ﾐﾆｷｯﾁﾝではないとき
    (progn
      (setq #WT (car  #WT_SOLID$))

      ;D1050ならばRｴﾝﾄﾞ処理 2008/09/27 YM ADD
      (if (= "D105" (nth  7 CG_GLOBAL$))
        (setq #WT (subKPRendWT #WT)) ;戻り値=天板図形名
      );_if

      ;// 品番の確定処理
      (KPW_DesideWorkTop3 #WT)

;-- 2011/10/20 A.Satoh Del - S
;;;;;      ;L型の場合天板にｶｯﾄを入れる 2008/09/27 YM ADD
;;;;;      ;[WT材質]でｶｯﾄﾀｲﾌﾟ取得 X(斜め) or J(方向ｶｯﾄ)
;;;;;      ;方向ｶｯﾄの場合は[WTｶｯﾄ方向]から方向を取得
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;      (if (wcmatch (nth  5 CG_GLOBAL$) "L*")
;;;;;;;;;;        (progn ; L型
;;;;;;;;;;          (AddWorkTopCutLine #WT)
;;;;;;;;;;        )
;;;;;;;;;;      );_if
;;;;;      (if (wcmatch (nth  5 CG_GLOBAL$) "L*")
;;;;;        (progn ; L型
;;;;;          (setq #handle$ (AddWorkTopCutLine #WT))
;;;;;          (if (/= #handle$ nil)
;;;;;            (foreach #WT_SOLID #WT_SOLID$
;;;;;              (setq #SetXd$ (CFGetXData #WT_SOLID "G_WRKT"))
;;;;;              (CFSetXData #WT_SOLID "G_WRKT" (CFModList #SetXd$
;;;;;                (list
;;;;;                  (list  9 (nth 4 #handle$))
;;;;;                  (list 60 (nth 0 #handle$))
;;;;;                  (list 61 (nth 1 #handle$))
;;;;;                  (list 62 (nth 2 #handle$))
;;;;;                  (list 63 (nth 3 #handle$))
;;;;;                )
;;;;;              ))
;;;;;            )
;;;;;          )
;;;;;        )
;;;;;      );_if
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;-- 2011/10/20 A.Satoh Del - E
    )
  );_if


;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  (setvar "pdmode" 0)
  ;// Ｏスナップ関連システム変数を元に戻す
  (CFNoSnapEnd) ; 00/02/07 @YM@追加

  (princ "ﾜｰｸﾄｯﾌﾟを自動生成しました")
  #WT ;2010/11/10 YM ADD WT図形を返す
);PKW_WorkTop


;-- 2011/10/20 A.Satoh Del - S
;;;;;;;;<HOM>*************************************************************************
;;;;;;;; <関数名>    : AddWorkTopCutLine
;;;;;;;; <処理概要>  : L型の場合天板にｶｯﾄﾗｲﾝを入れる
;;;;;;;; <戻り値>    : 
;;;;;;;; <作成>      : 2008/09/27 YM
;;;;;;;; <備考>      :
;;;;;;;;*************************************************************************>MOH<
;;;;;(defun AddWorkTopCutLine (
;;;;;  &WT ;天板図形
;;;;;  /
;;;;;  #BASEP #CUT$$ #CUTDIR$$ #CUTDIRECT #CUTTYPE #DUMPT #P1 #P2 #P3 #P4 #P5 #P6
;;;;;  #PT$ #TEI #X1 #X2 #XD$ #CLAYER #HH #Y1 #Y2
;;;;;;-- 2011/09/21 A.Satoh Add - S
;;;;;#handle$ #en #handle1 #handle2 #wt_hand #dirt
;;;;;;-- 2011/09/21 A.Satoh Add - E
;;;;;  )
;;;;;  ;ｶｯﾄﾀｲﾌﾟを決める
;;;;;  (setq #Cut$$
;;;;;    (CFGetDBSQLRec CG_DBSESSION "WT材質"
;;;;;      (list
;;;;;        (list "材質記号" (nth 16 CG_GLOBAL$) 'STR)
;;;;;      )
;;;;;    )
;;;;;  )
;;;;;  (if (and #Cut$$ (= 1 (length #Cut$$)))
;;;;;    (setq #CutType (nth 6 (car #Cut$$))); 一意に決まった場合(X or J)
;;;;;    ;else 特定できない場合
;;;;;    (setq #CutType "N");ｶｯﾄなし
;;;;;  );_if
;;;;;
;;;;;  ;Jｶｯﾄの場合ｶｯﾄ方向を求める
;;;;;  (if (= #CutType "J")
;;;;;    (progn
;;;;;      (setq #CutDir$$
;;;;;        (CFGetDBSQLRec CG_DBSESSION "WTカット方向"
;;;;;          (list
;;;;;            (list "シンク側間口" (nth  4 CG_GLOBAL$) 'STR)
;;;;;            (list "形状"         (nth  5 CG_GLOBAL$) 'STR)
;;;;;            (list "シンク位置"   (nth  2 CG_GLOBAL$) 'STR)
;;;;;          )
;;;;;        )
;;;;;      )
;;;;;      (if (and #CutDir$$ (= 1 (length #CutDir$$)))
;;;;;        (progn
;;;;;          (setq #CutDirect (nth 4 (car #CutDir$$))); 一意に決まった場合(S or G)
;;;;;        )
;;;;;        ;else 特定できない場合
;;;;;        (progn
;;;;;          (setq #CutType "N");ｶｯﾄなし
;;;;;        )
;;;;;      );_if
;;;;;    )
;;;;;  );_if
;;;;;  
;;;;;;;; p1+----------+--LEN2-------------+p2
;;;;;;;;   |          x1                  |
;;;;;;;;   |          |     領域2         |
;;;;;;;;   |          p4                  |
;;;;;;;;   +x2------- +-------------------+p3
;;;;;;;;   |          |
;;;;;;;;   |          |
;;;;;;;;   |  領域1   |
;;;;;;;;LEN1          |
;;;;;;;;   |          |
;;;;;;;;   |  +----+  |
;;;;;;;;   |  | S  |  |
;;;;;;;;   |  +----+  |
;;;;;;;;   |          |
;;;;;;;;   |          |
;;;;;;;; p6+----------+p5
;;;;;
;;;;;  ;天板高さ
;;;;;  (setq #HH (atoi (substr (nth 31 CG_GLOBAL$) 2 3)));H850,H900,H800
;;;;;
;;;;;  (setq #xd$ (CFGetXData &WT "G_WRKT"))
;;;;;  (setq #tei   (nth 38 #xd$))        ; WT底面図形ﾊﾝﾄﾞﾙ
;;;;;  (setq #BaseP (nth 32 #xd$))        ; WT左上点
;;;;;  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
;;;;;;;; 外形点列&pt$を#BASEPを先頭に時計周りにする
;;;;;  (setq #pt$ (GetPtSeries #BaseP #pt$))
;;;;;  (setq #p1 (nth 0 #pt$))
;;;;;  (setq #p2 (nth 1 #pt$))
;;;;;  (setq #p3 (nth 2 #pt$))
;;;;;  (setq #p4 (nth 3 #pt$))
;;;;;  (setq #p5 (nth 4 #pt$))
;;;;;  (setq #p6 (nth 5 #pt$))
;;;;;
;;;;;  (setq #p1 (list (car #p1)(cadr #p1) #HH))
;;;;;  (setq #p2 (list (car #p2)(cadr #p2) #HH))
;;;;;  (setq #p3 (list (car #p3)(cadr #p3) #HH))
;;;;;  (setq #p4 (list (car #p4)(cadr #p4) #HH))
;;;;;  (setq #p5 (list (car #p5)(cadr #p5) #HH))
;;;;;  (setq #p6 (list (car #p6)(cadr #p6) #HH))
;;;;;
;;;;;  ;ﾗｲﾝ作図
;;;;;  (if (/= "N" #CutType)
;;;;;    (progn
;;;;;      
;;;;;      (setq #CLAYER (getvar "CLAYER"))
;;;;;      (setvar "CLAYER" SKW_AUTO_SOLID)
;;;;;
;;;;;      ; T.Ari Add 平面図
;;;;;      (defun AddWorkTopPlaneCutLine (
;;;;;        &WT ;天板図形
;;;;;        &pt$
;;;;;        /
;;;;;        #i #j
;;;;;        #layer
;;;;;        #sstmp #ss
;;;;;        )
;;;;;        (setq #ss (ssadd))
;;;;;        (foreach #i (list 1 2)
;;;;;          (setq #sstmp (ssadd))
;;;;;          (setq #layer (if (= #i 1) "Z_01_02_00_00" "Z_01_04_00_00"))
;;;;;          (MakeLayer #layer 7 "CONTINUOUS")
;;;;;          (setq #j 0)
;;;;;          (repeat (- (length &pt$) 1)
;;;;;            (command "_.line" (nth #j &pt$) (nth (+ #j 1) &pt$) "")
;;;;;            (ssadd (entlast) #ss)
;;;;;            (ssadd (entlast) #sstmp)
;;;;;            (setq #j (+ #j 1))
;;;;;          )
;;;;;          (command "chprop" #sstmp "" "LA" #layer "")
;;;;;        )
;;;;;        (ssadd &WT #ss)
;;;;;        (SKMkGroup #ss)
;;;;;      )
;;;;;      (cond
;;;;;        ((= #CutType "X")
;;;;;          ;斜めｶｯﾄ
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;          (setq #dumpt (polar #p1 (angle #p1 #p2) 20))
;;;;;;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p3) 20))
;;;;;;;;;;          (setq #y1 (list (car #dumpt)(cadr #dumpt) (+ #HH 50)));BG高さ追加
;;;;;;;;;;          (setq #y2 (list (car #p1)(cadr #p1) (+ #HH 50)))
;;;;;;;;;;          (command "_.line" #p4 #dumpt #y1 #y2 "")
;;;;;;;;;;          ; T.Ari Add 平面図
;;;;;;;;;;          (AddWorkTopPlaneCutLine &WT (list #p4 #dumpt #y1 #y2))
;;;;;          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))
;;;;;          (command "_.3DPOLY" #p4 #p1 "")
;;;;;          (setq #en (entlast))
;;;;;          (setq #handle1 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "X"))
;;;;;
;;;;;          (setq #handle2 "")
;;;;;
;;;;;          (setq #handle$ (list #handle1 "" "" "" ""))
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;;;;;        )
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;        ((or (and (= "R" (nth 11 CG_GLOBAL$))(= #CutType "J")(= #CutDirect "S")) ;上方向
;;;;;;;;;;             (and (= "L" (nth 11 CG_GLOBAL$))(= #CutType "J")(= #CutDirect "G")))
;;;;;;;;;;          ;右勝手でｼﾝｸ側ｶｯﾄ or 左勝手でｺﾝﾛ側ｶｯﾄ
;;;;;;;;;;          (setq #dumpt (polar #p4 (angle #p3 #p2) 50))
;;;;;;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p1) 50))
;;;;;;;;;;          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
;;;;;;;;;;          (setq #x1 (polar #x1 (angle #p2 #p3) 20))
;;;;;;;;;;          (setq #y1 (list (car #x1)(cadr #x1) (+ #HH 50)));BG高さ追加
;;;;;;;;;;          (setq #y2 (polar #y1 (angle #p3 #p2) 20))
;;;;;;;;;;          (command "_.line" #p4 #dumpt #x1 #y1 #y2 "")
;;;;;;;;;;          ; T.Ari Add 平面図
;;;;;;;;;;          (AddWorkTopPlaneCutLine &WT (list #p4 #dumpt #x1 #y1 #y2))
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;;;;;        ((or (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "S")) ;上方向
;;;;;             (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "S")))
;;;;;          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))
;;;;;
;;;;;          ;右勝手でｼﾝｸ側ｶｯﾄ or 左勝手でｺﾝﾛ側ｶｯﾄ
;;;;;          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")
;;;;;
;;;;;          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
;;;;;          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x1 "")
;;;;;          (setq #en (entlast))
;;;;;
;;;;;          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
;;;;;          (command "_.LAYER" "F" "WTCUT_HIDE" "")
;;;;;
;;;;;          (setq #handle1 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x2 "")
;;;;;          (setq #en (entlast))
;;;;;
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (setq #handle2 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (if (and (= "L" #lr_flg) (= #CutDirect "S"))
;;;;;            (setq #dirt "S")
;;;;;            (setq #dirt "G")
;;;;;          )
;;;;;          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
;;;;;        )
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;        ((or (and (= "L" (nth 11 CG_GLOBAL$))(= #CutType "J")(= #CutDirect "S")) ;左方向
;;;;;;;;;;             (and (= "R" (nth 11 CG_GLOBAL$))(= #CutType "J")(= #CutDirect "G")))
;;;;;;;;;;          ;左勝手でｼﾝｸ側ｶｯﾄ or 右勝手でｺﾝﾛ側ｶｯﾄ
;;;;;;;;;;          (setq #dumpt (polar #p4 (angle #p3 #p2) 50))
;;;;;;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p1) 50))
;;;;;;;;;;          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
;;;;;;;;;;          (setq #x2 (polar #x2 (angle #p6 #p5) 20))
;;;;;;;;;;          (setq #y1 (list (car #x2)(cadr #x2) (+ #HH 50)));BG高さ追加
;;;;;;;;;;          (setq #y2 (polar #y1 (angle #p5 #p6) 20))
;;;;;;;;;;          (command "_.line" #p4 #dumpt #x2 #y1 #y2 "")
;;;;;;;;;;          ; T.Ari Add 平面図
;;;;;;;;;;          (AddWorkTopPlaneCutLine &WT (list #p4 #dumpt #x2 #y1 #y2))
;;;;;        ((or (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "G")) ;左方向
;;;;;             (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "G")))
;;;;;          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))
;;;;;
;;;;;          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")
;;;;;
;;;;;          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
;;;;;          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x1 "")
;;;;;          (setq #en (entlast))
;;;;;          (setq #handle1 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x2 "")
;;;;;          (setq #en (entlast))
;;;;;
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
;;;;;          (command "_.LAYER" "F" "WTCUT_HIDE" "")
;;;;;
;;;;;          (setq #handle2 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
;;;;;            (setq #dirt "G")
;;;;;            (setq #dirt "S")
;;;;;          )
;;;;;          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;;;;;        )
;;;;;        (T
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;          (princ)
;;;;;          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))
;;;;;
;;;;;          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")
;;;;;
;;;;;          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
;;;;;          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x1 "")
;;;;;          (setq #en (entlast))
;;;;;
;;;;;          (if (= #CutDirect "S")
;;;;;            (progn
;;;;;              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
;;;;;              (command "_.LAYER" "F" "WTCUT_HIDE" "")
;;;;;            )
;;;;;          )
;;;;;
;;;;;          (setq #handle1 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x2 "")
;;;;;          (setq #en (entlast))
;;;;;
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (if (= #CutDirect "G")
;;;;;            (progn
;;;;;              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
;;;;;              (command "_.LAYER" "F" "WTCUT_HIDE" "")
;;;;;            )
;;;;;          )
;;;;;
;;;;;          (setq #handle2 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
;;;;;            (setq #dirt "G")
;;;;;            (setq #dirt "S")
;;;;;          )
;;;;;          (setq #handle$ (list #handle1 #handle2 "" "" ""))
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;;;;;        )
;;;;;      );_cond
;;;;;
;;;;;      (setvar "CLAYER" #CLAYER)
;;;;;    )
;;;;;;-- 2011/09/21 A.Satoh Add - S
;;;;;    (setq #handle$ nil)
;;;;;;-- 2011/09/21 A.Satoh Add - E
;;;;;  );_if
;;;;;
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;  (princ)
;;;;;  #handle$
;;;;;
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;;;;;);AddWorkTopCutLine
;-- 2011/10/20 A.Satoh Del - E

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetWTInfo_plan
;;; <処理概要>  : WT素材の検索 <--- プラン検索用
;;; <戻り値>    :
;;;               (list (cons "WT高さ" #WT_H) (cons "WT厚み" #WT_T)
;;;                     (cons "BG高さ" #BG_H) (cons "BG厚み" #BG_T)
;;;                     (cons "FG高さ" #FG_H) (cons "FG厚み" #FG_T)
;;;               ))
;;; <作成>      : 2000.4.13 YM
;;; <備考>      :
;;; #CG_WtDepth = 0 延長なし
;;; #CG_WtDepth = 1 シンク側のみ
;;; #CG_WtDepth = 10 コンロ側のみ
;;; #CG_WtDepth = 100 その他
;;;*************************************************************************>MOH<
(defun PKGetWTInfo_plan (
  &pt$       ; 元の外形点列
  &pt$$      ; WT外形ﾎﾟﾘﾗｲﾝ点列
  &base$     ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形
  &base_new$ ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形除外後
  &outpl_LOW ; ﾛｰﾀｲﾌﾟｷｬﾋﾞ外形ﾎﾟﾘﾗｲﾝ
  /
  #BG_H #BG_T #CG_WTDEPTH #CUTID #CUT_KIGO$ #FG_H #FG_S #FG_T #IHEIGHT$
  #RET$ #RETWT_BG_FG$ #SETXD$ #WTINFO #WT_H #WT_T
  #QRY$ #WTINFO1 #WTINFO2 #WTINFO3 #ZAIF #TYPE1
  #BG_S #BG_SEP #BG_TYPE #DANMENID #DDAN$$ #FG_TYPE #OFFSET #TOP_FLG
  #OFFSETL #OFFSETR
  )

  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart) ; 00/02/07 @YM@追加

  (PKGetBASEPT_L &pt$ &base$) ; 00/09/29 YM ADD ﾍﾞｰｽｸﾞﾛｰﾊﾞﾙを求める

  (setq #CG_WTDEPTH 0)
  (cond
    ((wcmatch (nth  5 CG_GLOBAL$) "I*") ; I型
      (setq #type1 "0")
    )
    ;2009/04/14 YM ADD-S
    ((wcmatch (nth  5 CG_GLOBAL$) "G*" ) ; GATE型
      (setq #type1 "0")
    )
    ;2009/04/14 YM ADD-E
    ((wcmatch (nth  5 CG_GLOBAL$) "L*") ; L型
      (setq #type1 "1")
    )
    ((wcmatch (nth  5 CG_GLOBAL$) "U*") ; U型
      (setq #type1 "2")
    )
  );_cond

  (setq #CUT_KIGO$ '()) ; nilありえる

  ;// ワークトップの取り付け高さを求める
  (foreach #en &base$
    (setq #iHeight$ (cons (nth 5 (CFGetXData #en "G_SYM")) #iHeight$)) ; シンボル基準値Ｈ (825.0 825.0 630.0 825.0) 630ｶﾞｽ
  )
  (setq #WT_H (apply 'max #iHeight$)) ; 取り付け高さの最大値


  ;関数化 2010/10/27 YM ADD
  (setq #qry$ (GetWtDanmen))

  (if (= nil #qry$)
    (progn
      (CFAlertMsg "\n[WT断面決定]が拾えない")
      (quit)
    )
  );_if

  (setq #WT_T    (nth  2 #qry$)) ; WTの厚み
  (setq #BG_Type (nth  3 #qry$)) ; BG有無 1:あり 0:なし
  (setq #BG_H    (nth  4 #qry$)) ; BGの高さ
  (setq #BG_T    (nth  5 #qry$)) ; BGの厚み
  (setq #FG_Type (nth  6 #qry$)) ; FGﾀｲﾌﾟ 1:片側 2:両側
  (setq #FG_H    (nth  7 #qry$)) ; FGの高さ
  (setq #FG_T    (nth  8 #qry$)) ; FGの厚み
  (setq #FG_S    (nth  9 #qry$)) ; 前垂れシフト量
  (setq #BG_S    (nth 10 #qry$)) ; 後垂れシフト量
  (setq #BG_Sep  (nth 11 #qry$)) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離
  ; 特異天板ﾌﾗｸﾞ
  ;0:標準 1:BGが左右に回り込む 2:前垂れが左側面背面に回りこむ 3:前垂れが右側面背面に回りこむ
  (setq #TOP_FLG (nth 12 #qry$)) ; 特異天板ﾌﾗｸﾞ
  (setq #offsetL  (nth 13 #qry$)) ; ｻｲﾄﾞﾊﾟﾈﾙ分ｼﾌﾄ(天板延長量)
  (setq #offsetR  (nth 14 #qry$)) ; ｻｲﾄﾞﾊﾟﾈﾙ分ｼﾌﾄ(天板延長量)

  (setq #WTInfo  (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))

  (setq #WTInfo1 (list #BG_S #BG_Type #FG_Type #offsetL #offsetR))
  (setq #WTInfo2 #WTInfo1)
  (setq #WTInfo3 #WTInfo1)

;;;  (setq #CutId 0) ; カットなし
;;;  (setq #CutId 1) ; カットの種類=斜め
;;;  (setq #CutId 2) ; カットの種類=方向

  (setq #ZaiF (KCGetZaiF (nth 16 CG_GLOBAL$))) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ

  ;2009/12/15 YM MOD-S [WTカット]廃止
;;;  (setq #qry$
;;;   (CFGetDBSQLRec CG_DBSESSION "WTカット"
;;;     (list
;;;       (list "形状" (nth  5 CG_GLOBAL$) 'STR)
;;;       (list "素材F"  (rtos (FIX #ZaiF))  'INT)
;;;     )
;;;   )
;;; )
;;; (setq #qry$ (DBCheck #qry$ "『WTカット』" "PKGetWTInfo_plan"))
;;;  (setq #CutId (nth 3 #qry$)) ; WTｶｯﾄﾀｲﾌﾟ

  (setq #CutId 0.0) ; WTｶｯﾄﾀｲﾌﾟ 0固定
  ;2009/12/15 YM MOD-E [WTカット]廃止

;;; ワークトップ用画層の作成
  (command "_layer" "N" SKW_AUTO_SECTION "C" 2 SKW_AUTO_SECTION "L" SKW_AUTO_LAY_LINE SKW_AUTO_SECTION "")
  (command "_layer" "N" SKW_AUTO_SOLID   "C" 7 SKW_AUTO_SOLID   "L" SKW_AUTO_LAY_LINE SKW_AUTO_SOLID   "")
  (command "_layer" "T" SKW_AUTO_SECTION "") ; 画層解除
  (command "_layer" "T" SKW_AUTO_SOLID   "") ; 画層解除


;;;DBで得た情報からBG,FG底面ﾎﾟﾘﾗｲﾝを求める.
;;;WTｼﾌﾄ量分WT底面領域を修正する

  (setq #retWT_BG_FG$
    (PKMakeWT_BG_FG_Pline
      &pt$$
      &base_new$
      #CG_WtDepth
      #WTInfo  ; 共通情報
      #WTInfo1 ; 1枚目
      #WTInfo2 ; 2枚目
      #WTInfo3 ; 3枚目
      #CutId
      &outpl_LOW
      (nth 16 CG_GLOBAL$)
    )
  )

;;; <戻り値>    : ((#wt_en1  #bg_en1  #fg_en1  #cut_type1  #dep1  #WT_LEN1 左上点 ),...)
;;;               ((WT底面図形名,BG底面図形名,FG底面図形名,ｶｯﾄﾀｲﾌﾟ)...)

  (if (= nil (tblsearch "APPID" "G_WRKT")) (regapp "G_WRKT"))
  (if (= nil (tblsearch "APPID" "G_BKGD")) (regapp "G_BKGD"))
  (if (= nil (tblsearch "APPID" "G_OPT" )) (regapp "G_OPT" ))

;;; "G_WRKT" *** 共通項目設定 ***

(if (= CG_MAG1 nil)(setq CG_MAG1 0))
(if (= CG_MAG2 nil)(setq CG_MAG2 0))
(if (= CG_MAG3 nil)(setq CG_MAG3 0))

  (setq #SetXd$                ; 未設定項目は-999 or "-999"
    (list "K"                  ;1. 工種記号
          (nth  1 CG_GLOBAL$)  ;2. SERIES記号
          (nth 16 CG_GLOBAL$)  ;3. 材質記号
          (atoi #type1)        ;4. 形状タイプ１          0,1,2(I,L,U) この時点で未決定 00/09/25 YM
;-- 2011/09/21 A.Satoh Mod - S
;;;;;          ""                   ;5. 未使用
;;;;;          0                    ;6. 未使用
          ""                   ;5. 形状タイプ２
          ""                   ;6. 未使用
;-- 2011/09/21 A.Satoh Mod - E
          ""                   ;7. 未使用
          ""                   ;8. カットタイプ番号      0:なし,1:VPK,2:X,3:H 左右
          #WT_H                ;9..下端取付け高さ        827
;-- 2011/09/21 A.Satoh Mod - S
;          "旧WT奥行き"         ;10.未使用
          ""                   ;10.未使用
;-- 2011/09/21 A.Satoh Mod - E
          #WT_T                ;11.カウンター厚さ        23
          1                    ;12.未使用
          #BG_H                ;13.バックガードの高さ    50
          #BG_T                ;14.バックガード厚み      20
          1                    ;15.未使用
          #FG_H                ;16.前垂れ高さ            40
          #FG_T                ;17.前垂れ厚さ            20
          #FG_S                ;18.前垂れシフト量         7
          0 "" "" ""           ;19.ｼﾝｸ穴加工
          0 "" "" "" "" "" "" "" ;23.水栓穴データ数  水栓穴図形ハンドル1～5
          (nth 11 CG_GLOBAL$)            ;31.ＬＲ勝手フラグ        ?       U型対応 --->廃止? ★
;-- 2011/09/21 A.Satoh Mod - S
;;;;;          0.0                  ;32.未使用
          ""                   ;32.未使用
;-- 2011/09/21 A.Satoh Mod - E
          ""                   ;33.コーナー原点          U型対応 --->2つ --->廃止 下に追加★
          ""                   ;34.未使用
          ""                   ;35.未使用
;-- 2011/09/21 A.Satoh Mod - S
;;;;;          "旧ｶｯﾄ相手ﾊﾝﾄﾞﾙ"     ;36.未使用
          ""                   ;36.未使用
;-- 2011/09/21 A.Satoh Mod - E
          ""                   ;37.カット左
          ""                   ;38.カット右
          ""                   ;[39]WT底面図形ﾊﾝﾄﾞﾙ
          0.0                  ;[40]未使用
          0.0                  ;[41]未使用
          0.0                  ;[42]未使用
          CG_MAG1              ;[43]未使用
          CG_MAG2              ;[44]未使用
          CG_MAG3              ;[45]未使用
          ""                   ;[46]未使用
          ""                   ;[47]未使用
          ""                   ;[48]カット相手WTﾊﾝﾄﾞﾙ左
          ""                   ;[49]カット相手WTﾊﾝﾄﾞﾙ右
          ""                   ;[50]BG底面図形ﾊﾝﾄﾞﾙ1
          ""                   ;[51]BG底面図形ﾊﾝﾄﾞﾙ2
          ""                   ;[52]FG底面図形ﾊﾝﾄﾞﾙ
          ""                   ;[53]素材ID
          0.0                  ;[54]間口伸縮量1 ｼﾝｸ側 (旧"G_SIDE"ｶｳﾝﾀｰ伸縮量) 品番確定に必要
          0.0                  ;[55]間口伸縮量2 ｺﾝﾛ側 (旧"G_SIDE"ｶｳﾝﾀｰ伸縮量) 品番確定に必要
          '(0.0 0.0)           ;[56]現在のWTの幅 (旧"G_SIDE"ｶｳﾝﾀｰ押し出し) 品番確定に必要 WT拡張前、ｶｯﾄ前のｺｰﾅｰ基点から角まで
          0.0                  ;[57]現在のWTの伸縮量
          '(0.0 0.0)           ;[58]現在のWTの奥行き
          ""                   ;[59]上面溝加工の有無    "A" 上面溝加工なし or "B" 上面溝加工あり
;-- 2011/09/21 A.Satoh Add - S
          ""                   ;[60]段差部分も含めたWT外形PLINEハンドル
          ""                   ;[61]カットラインハンドル1
          ""                   ;[62]カットラインハンドル2
          ""                   ;[63]カットラインハンドル3
          ""                   ;[64]カットラインハンドル4
;-- 2011/09/21 A.Satoh Add - E
    )
  )

  (setq #ret$ (list #WTInfo #retWT_BG_FG$ #SetXd$ #CUT_KIGO$ #CG_WtDepth #CutId))
  #ret$
);PKGetWTInfo_plan

;;;<HOM>*************************************************************************
;;; <関数名>     : GetWtDanmen
;;; <処理概要>   : [WT断面]を検索する
;;; <戻り値>     : ﾚｺｰﾄﾞ
;;; <作成>       : 2010/10/27 YM ADD
;;; <備考>       : シンク配置時も検索するので関数化した
;;;*************************************************************************>MOH<
(defun GetWtDanmen (
  /
  #DANMENID #DDAN$$ #QRY$
  #TOP_F ;2010/11/08 YM ADD
  )

  ;2010/11/08 YM ADD-S
  ;新ｽｲｰｼﾞｨ対応ﾄｯﾌﾟ勝ち判定を検索
  (setq #TOP_F (GetTopFlg))
  ;2010/11/08 YM ADD-E

  ;断面IDを決める [WT断面決定]
  (setq #DDan$$
    (CFGetDBSQLRec CG_DBSESSION "WT断面決定"
      (list
        (list "形状"       (nth  5 CG_GLOBAL$) 'STR)
        (list "奥行"       (nth  7 CG_GLOBAL$) 'STR)
        (list "左右勝手"   (nth 11 CG_GLOBAL$) 'STR)
        (list "シンク記号" (nth 17 CG_GLOBAL$) 'STR);2008/09/20 YM ADD
        (list "トップ勝ち" #TOP_F              'STR);2010/11/08 YM ADD
      )
    )
  )
  (if (and #DDan$$ (= 1 (length #DDan$$)))
    (setq #DanmenID (car (car #DDan$$))); 一意に決まった場合
    ;else 断面が特定できない場合
    (setq #DanmenID "STD");標準
  );_if


  (setq #qry$
    (car (CFGetDBSQLRec CG_DBSESSION "WT断面"
      (list
        (list "断面ID" #DanmenID 'STR)
      )
    ))
  )

  #qry$
);GetWtDanmen

;;;<HOM>*************************************************************************
;;; <関数名>     : PKC_PosBlkByType
;;; <処理概要>   : 配置方向により複合部材を配置する
;;; <戻り値>     :
;;; <作成>       : 2000.1.修正 YM
;;; <備考>       :
;;;                複合基準部材の配置情報を確保しておく
;;;                  ST_BLKPOS  :基点
;;;                  ST_BLKANG  :配置角度
;;;                  ST_BLKWID  :Ｗ寸法
;;;                  ST_BLKNO   :配置順番号
;;;*************************************************************************>MOH<
(defun PKC_PosBlkByType (
  &pln$     ;(LIST)『プラ構成』情報
  &blk$     ;(INT) 『複合構成』情報
  &fig$     ;(LIST)『品番図形』情報
  &figBase$ ;(LIST)『品番基本』情報
  &recno    ;(INT)  配置番号
  /
  #ANG2 #B-H #B-WID #BRK-D #BRK-H #BRK-W #DIM-W #DWG #EG #EN #H #I #MOVE
  #MSG #OP-X #OP-Y #OP-Z #POS #PT #PTS-D #PTS-W #SEIKAKU #SS #SYM #TMP$ #TYP
  #VCT-X #VCT-Y #XD$ #SYM_ORG
  #boukaF #D_KyuhaiF #DIR$ #iCODE #HaikiDir #D_KyuDir #D_HaiDir #fig$
#DANMEN #RECNO ;2011/01/26 YM ADD
  )
  (setq #fig$ &fig$)
  (setq #seikaku (fix (nth 3 &figBase$))) ; 品番基本 性格CODE OK
  (if (= #seikaku nil)
    (setq #seikaku -1)
  );_if

  (if (equal (nth 6 &pln$) 9.0 0.001) ;2011/01/26 YM ADD 商品ﾀｲﾌﾟ=9
    (progn
      (setq ST_BLKSTART T) ; Yes 基準アイテム=0
    )
    (progn
      (if (= (fix (nth 5 &blk$)) 0) ; 基準アイテム ;2008/06/23 OK
        (progn
          (setq ST_BLKSTART T) ; Yes 基準アイテム=0
          (setq ST_BLK$$ nil)  ; No  基準アイテム 0以外
        )
      );_if
    )
  );_if

  (setq #dwg (nth 6 #fig$)) ; 品番図形 ;2008/06/23 OK

  (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")))
    (progn
      (setq #msg (strcat "図形ID=" (nth 6 #fig$) "のマスター図面がありません。"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    (progn
      (cond
        ((= ST_BLKSTART T)

          (setq #vct-x (nth  7 &pln$)) ; 方向y OK!
          (setq #vct-y (nth  8 &pln$)) ; 方向x OK!
          (setq #op-x  (nth  9 &pln$)) ; 距離y OK!
          (setq #op-y  (nth 10 &pln$)) ; 距離x OK!
          ;// レンジフードの場合は天井高さは、入力情報のアッパーキャビネット高さを用いる
          ;2011/09/06 YM ADD 商品タイプ=9
          (if (or (= (nth 6 &pln$) 3)(= (nth 6 &pln$) 9)) ; 商品タイプ OK!
            (setq #op-z  CG_UpCabHeight) ; Yes        レンジフードの場合     OK!
            (setq #op-z  (nth 11 &pln$)) ; No  距離z  レンジフード以外の場合 OK!
          )

          (setq #pts-w (fix (nth 12 &pln$))) ; 向きw OK!
          (setq #pts-d (fix (nth 13 &pln$))) ; 向きd OK!
          (setq #brk-w (nth 14 &pln$))       ; 伸縮w OK!
          (setq #brk-d (nth 15 &pln$))       ; 伸縮d OK!
          (setq #brk-h (nth 16 &pln$))       ; 伸縮h OK!
          (setq #dim-w (advance (nth 3 #fig$) 10))        ; 品番図形 寸法w ;2008/06/23 OK
          (setq ST_BLKANG (angle (list 0 0) (list #vct-x #vct-y)))

          (cond
            ((and (= #pts-w -1) (= #pts-d 1))
              (setq #ang2 (angle (list #vct-x #vct-y) (list 0. 0.)))
              (setq #pos (polar '(0 0) #ang2 (distance '(0 0) (list #op-x #op-y))))
              (setq #pos (polar #pos #ang2 #dim-w))
            )
            (T
              ; 04/08/08 YM MOD 初期登録が右勝手を想定→左勝手を想定
;;;              (setq #pos (polar '(0 0) ST_BLKANG (distance '(0 0) (list #op-x #op-y))));04/08/08 YM MOD
;             (setq #pos (polar (list #op-x 0) ST_BLKANG (distance (list #op-x 0) (list #op-x #op-y))));04/08/08 YM MOD
              (setq #pos (list #op-x #op-y #op-z)) ; 05/07/12 T.Ari Mod
            )
          )

          (setq ST_BLKWID (advance (nth 3 #fig$) 10))  ;Ｗ寸法 ;2008/06/23 OK
          (setq ST_BLKNO &recno)          ;配置順番号
          (setq ST_BLKPOS (list (car #pos) (cadr #pos) #op-z))
          (setq #SYM_ORG ST_BLKPOS)

          (command "_insert" (strcat CG_MSTDWGPATH #dwg) #SYM_ORG 1 1 (rtd ST_BLKANG))
        )
        (T
          (setq #tmp$ (assoc (nth 5 &blk$) ST_BLK$$)) ; 基準アイテム ;2008/06/23 OK
          (setq ST_BLKWID (nth 3 #tmp$)) ; ??? 600.0
          (setq ST_BLKPOS (nth 2 #tmp$)) ; ??? 150,0,0
          (setq ST_BLKSYM (nth 1 #tmp$)) ; ??? 図形名

          ;// 連続配置部材（基準アイテムサブ部）配置
          (setq #typ (fix (nth 6 &blk$))) ; 複合構成 方向 ;2008/06/23 OK

          (cond
            ((= #typ 0)  ;正（左）
              ;// 基準アイテムの接続点（基準点＋Ｗ寸法の位置の点）および
              ;// 取付高さを基準にＷ方向に並べて配置
              (princ "正（左）")
              (setq #pos (polar ST_BLKPOS ST_BLKANG ST_BLKWID))
              (command "_insert" (strcat CG_MSTDWGPATH #dwg) #pos 1 1 (rtd ST_BLKANG))
            )
            ((= #typ 1)  ;逆（右）
              ;// 基準アイテムの基準点（および取付高さ）を基準にＷ逆方向に並べて配置
              ;;;(setq #pos (polar ST_BLKPOS (* -1 ST_BLKANG) ST_BLKWID))
              (princ "逆（右）")
              (setq #pos ST_BLKPOS)
              (command "_insert" (strcat CG_MSTDWGPATH #dwg) #pos 1 1 (rtd ST_BLKANG))
            )
            ((or (= #typ 2) (= #typ 3) (= #typ 4) (= #typ 6)) ;上/下/単独/同一基準点
              ;// 基準アイテムの基準点（および取付高さ）とＨ方向フラグを基準に並べて配置
              (command "_insert" (strcat CG_MSTDWGPATH #dwg) ST_BLKPOS 1 1 (rtd ST_BLKANG))
            )
            ((= #typ 5)  ;コンロ取付線
              ;// 基準アイテムのコンロ取付線に沿って配置
              (princ "コンロ取付け線")
              (setq #ss (ssget "X" '((-3 ("G_PLIN")))))
              (if (/= #ss nil)
                (progn
                  (setq #i 0)
                  (setq #pos nil)
                  (repeat (sslength #ss)
                    (setq #en (ssname #ss #i))
                    (setq #eg (entget #en))
                    (if (and (= #pos nil) (= (cdr (assoc 0 #eg)) "LINE") (= 2 (car (CFGetXData #en "G_PLIN"))))
                      (progn
                        (setq #pos (cdr (assoc 10 (entget #en))))
                        ;2009/03/04 YM MOD-S
                        ;Y座標を0にする
                        (setq #pos (list (nth 0 #pos) (nth 1 #pos) 0))
                        ;2009/03/04 YM MOD-E
                        (command "_insert" (strcat CG_MSTDWGPATH #dwg) #pos 1 1 (rtd ST_BLKANG))
                      )
                    )
                    (setq #i (1+ #i))
                  )
                  (if (= #pos nil)
                    (progn
                      (setq #msg "コンロ取付け線が見つかりません")
                      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
                    )
                  )
                )
                (progn    ; G_PLIN がない チェック強化 00/03/11 YM ADD
                  (setq #msg "コンロ取付け線が見つかりません。\nPKC_PosBlkByType")
                  (CMN_OutMsg #msg) ; 02/09/05 YM ADD
                )        ; G_PLIN がない チェック強化 00/03/11 YM ADD
              );_if
            )
          );_cond

          ;// 配置順番号をカウントアップ
          (setq ST_BLKNO (1+ ST_BLKNO))
        )
      );_(cond

      (command "_layer" "T" "*" "")                     ;全画層フリーズ解除
      (command "_layer" "U" "*" "")                     ;全画層ロック解除
      (command "_explode" (entlast))                    ;インサート図形分解
      (setq #ss (ssget "P"))
      ;(command "-group" "c" #grp #grp #ss "")   ;分解した図形群でグループ化
      (SKMkGroup #ss)          ;分解した図形群で名前のないグループ作成

      ;// グループの中から基準点図形を求める
;;;      (setq #sym (SKC_GetSymInGroup (ssname #ss (- (sslength #ss) 1)))) ; #sym 親図形
         (setq #sym (PKC_GetSymInGroup #ss))      ;;  2005/08/03 G.YK ADD

      (if (= ST_BLKSTART T)
        (setq ST_BLKSYM #sym)
      )

      (if (= ST_BLKSTART T)
        (setq ST_BLKNO 0)
      ;else
        (progn
          ;// 最後に"G_SYM"の取付高さを調整する
          ;// フラグが 2 または 3 の場合はＨ方向フラグを元に調整する
          ;//
          (setq #typ (fix (nth 6 &blk$))) ; 複合構成 方向 ;2008/06/23 OK
          (setq #xd$  (CFGetXData ST_BLKSYM "G_SYM"))

          (setq #pt (cdr (assoc 10 (entget ST_BLKSYM))))
          (setq #h     (nth 6 #xd$))
          (setq #h     (caddr #pt))
          (setq #b-wid (nth 3 #xd$))
          (setq #b-h   (nth 5 #xd$))
          (cond
            ((= #typ 0)    ;正（左）
              ;(setq #move (strcat "0,0," (rtos #h)))
              ;(command "_move" (ssget "P") "" "0,0,0" #move)
            )
            ((= #typ 1)    ;逆（右）
              (setq #xd$  (CFGetXData #sym "G_SYM"))
              (setq #b-wid (nth 3 #xd$))
              (if (/= ST_BLKANG 0.0)
                (setq #pos (polar ST_BLKPOS (* -1 ST_BLKANG) #b-wid))
                (setq #pos (polar ST_BLKPOS pi #b-wid))
              )
              (command "_move" (ssget "P") "" "@" #pos)

              ;(setq #move (strcat "0,0," (rtos #h)))
              ;(command "_move" (ssget "P") "" "0,0,0" #move)
            )
            ((= #typ 2)    ;上
              ;(setq #move (strcat "0,0," (rtos #h)))
              (setq #move (strcat "0,0," (rtos #b-h)))
              (command "_move" (ssget "P") "" "0,0,0" #move)
              ;2008/08/20 YM ADD 奥行きを見て食洗をさらに移動する
              (if (= #seikaku 110);DEEP食洗 111は除外される
                (progn ;食洗のとき
                  ;2011/03/31 YM MOD-S SKBはD1050のときも食洗用ｷｬﾋﾞがD700用になることがあるので
                  ;食洗ｷｬﾋﾞの品番9桁目="Q"かどうかで50mmずらすかどうかを判断する

                  ;2011/03/31 YM ADD-S 新ｽｲｰｼﾞｨ対応 場合わけ
                  (cond
                    ((= BU_CODE_0009 "1") 
                      ;SKBの場合　;DEEP食洗 111は除外される
                      (if (= "Q" (substr CG_SYOKUSEN_CAB 9 1))
                        (progn
                          ;食洗を手前に50mm移動する
                          (setq #move (strcat "0,-50,0"))
                          (command "_move" (ssget "P") "" "0,0,0" #move)
                        )
                      );_if
                    )
                    (T
                      ;従来どおり
                      (cond
                        ((or (= "D900" (nth  7 CG_GLOBAL$))(= "D700" (nth  7 CG_GLOBAL$)));奥行き
                          ;食洗を手前に50mm移動する
                          (setq #move (strcat "0,-50,0"))
                          (command "_move" (ssget "P") "" "0,0,0" #move)
                        )
            ;;;                   ;2008/09/19 YM DEL D600専用食洗のときは移動不要
            ;;;;;;                    ((= "D600" (nth  7 CG_GLOBAL$));奥行き
            ;;;;;;                      ;食洗を奥に50mm移動する
            ;;;;;;                      (setq #move (strcat "0,50,0"))
            ;;;;;;                      (command "_move" (ssget "P") "" "0,0,0" #move)
            ;;;;;;                    )
                        (T
                          nil
                        )
                      );_cond
                    )
                  );_cond

                )
              );_if


            )
            ((= #typ 3)    ;下
              (if (= (nth 1 (FlagToList #seikaku)) 1)      ;  ﾍﾞｰｽのとき 00/03/31 YM ADD
                (progn
                  (setq #xd$  (CFGetXData #sym "G_SYM"))   ;  ﾍﾞｰｽのとき
                  (setq #b-h   (nth 5 #xd$))
                )
              );_if                                        ; 00/03/31 YM ADD
              (setq #move (strcat "0,0," (rtos (* -1 #b-h))))
              (command "_move" (ssget "P") "" "0,0,0" #move)
            )
            ((= #typ 4)    ;単独
              (princ)
            )
            ((= #typ 5)    ;コンロ取付線
              ;;;(setq #move (strcat "0,0," (rtos #h)))
              (setq #move (strcat "0,0," (rtos #b-h)))
              (command "_move" (ssget "P") "" "0,0,0" #move)
            )
            ((= #typ 6)    ;同一基準点
              (princ)
            )
          )
        )
      )
      ;// 配置図形に属性情報としてレコード番号を持たせる
      ;// （連続配置時の開始基準アイテム番号として参照されるため）
      ;//
      ;// シンボル基準点拡張データ"G_LSYM"の設定
      ;//  1 :本体図形ID      :『品番図形』.図形ID
      ;//  2 :挿入点          :配置基点
      ;//  3 :回転角度        :配置回転角度
      ;//  4 :工種記号        :CG_Kcode
      ;//  5 :SERIES記号    :CG_SeriesCode
      ;//  6 :品番名称        :『品番図形』.品番名称
      ;//  7 :L/R区分         :『品番図形』.部材L/R区分
      ;//  8 :扉図形ID        :
      ;//  9 :扉開き図形ID    :
      ;//  10:性格CODE      :『品番基本』.性格CODE
      ;//  11:複合フラグ      :１固定（複合部材）
      ;//  12:配置順番号      :配置順番号(1～)
      ;//  13:用途番号        :『品番図形』.用途番号
      ;//  14:寸法Ｈ          :『品番図形』.寸法Ｈ
      ;//  15:断面有無        :『プラ構成』.断面有無

      (setq ST_BLKPOS (cdr (assoc 10 (entget #sym))))
      (setq ST_BLKWID (advance (nth 3 #fig$) 10))  ; 品番図形 Ｗ寸法 ;2008/06/23 OK


      (if (equal (nth 6 &pln$) 9.0 0.001) ;2011/01/26 YM ADD 商品ﾀｲﾌﾟ=9
        (progn
          ;&blk$　が【複合構成】の形式ではない
          ; 複合構成 recno
          (setq #recno 1.0)
          ;断面指示の有無
          (setq #danmen 1)
        )
        (progn
          ; 複合構成 recno
          (setq #recno (nth 1 &blk$))
          ;断面指示の有無
          (setq #danmen (fix (nth 8 &blk$)))
        )
      );_if

      (setq ST_BLK$$
        (append ST_BLK$$ (list
          (list
            ;(nth 1 &blk$) ; 複合構成 recno ;2011/01/26 YM MOD
            #recno ;2011/01/26 YM MOD
            #sym
            ST_BLKPOS
            ST_BLKWID
          )
        ))
      )

      (setq #xd$
        (list
          (nth 6 #fig$)         ;1 :本体図形ID      :『品番図形』.図形ID    ;2008/06/23 OK
          ST_BLKPOS             ;2 :挿入点          :配置基点
          ST_BLKANG             ;3 :回転角度        :配置回転角度
          CG_Kcode              ;4 :工種記号        :CG_Kcode
          CG_SeriesCode         ;5 :SERIES記号    :CG_SeriesCode
          (nth 0  #fig$)        ;6 :品番名称        :『品番図形』.品番名称  OK!
          (nth 1  #fig$)        ;7 :L/R区分         :『品番図形』.部材L/R区分 OK!

          ""         ;8 :扉図形ID        :                            OK!
          ""         ;9 :扉開き図形ID    :                            OK!

          (fix #seikaku)        ;10:性格CODE      :『品番基本』.性格CODE
          1                     ;11:複合フラグ      :1:固定（複合部材）
          ST_BLKNO              ;12:配置順番号      :配置順番号(1～)
          (fix (nth 2 #fig$))   ;13:用途番号        :『品番図形』.用途番号
          (fix (nth 5 #fig$))   ;14:寸法Ｈ          :『品番図形』.寸法Ｈ

          ;(fix (nth 8 &blk$))   ;15.断面指示の有無  :『複合構成』.断面有無  ;2011/01/26 YM MOD
          #danmen ;2011/01/26 YM MOD
          (GetBunruiAorD)       ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
        )
      );_(setq #xd$

      (CFSetXData #sym "G_LSYM" #xd$)
      (KcSetG_OPT #sym) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ 01/02/16 MH ADD

    );_(progn
  );_if

  (princ)
);PKC_PosBlkByType

;;;<HOM>*************************************************************************
;;; <関数名>    : PFGetCompBase
;;; <処理概要>  : 構成部材取得(構成タイプ=1) CG_UnitBase="1"
;;; <戻り値>    : プラ構成』情報のリスト
;;; <作成>      : 2000.1.19修正KPCAD
;;; <備考>      : ベース
;;;*************************************************************************>MOH<
(defun PFGetCompBase (
  /
  #I #MSG #QRY$ #QRY$$ #LIST$$ #DB_NAME #PLAN_ID
  )

;;;	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
;;;		(progn
;;;
;;;		  ;2017/09/07 YM MOD ﾌﾚｰﾑｷｯﾁﾝ
;;;		  (setq #LIST$$
;;;		    (list
;;;		      (list "ユニット記号"       (nth  3 CG_GLOBAL$) 'STR)
;;;		      (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
;;;		      (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
;;;		      (list "構成タイプ"         "1"                 'INT)
;;;		      (list "フロアキャビタイプ" (nth  6 CG_GLOBAL$) 'STR)
;;;		      (list "シンク位置"         (nth  2 CG_GLOBAL$) 'STR)
;;;		      (list "コンロ位置"         (nth  9 CG_GLOBAL$) 'STR)
;;;		      (list "食洗位置"           (nth 10 CG_GLOBAL$) 'STR)
;;;		      (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
;;;		      (list "シンク記号"         (nth 17 CG_GLOBAL$) 'STR)
;;;		      (list "SOFT_CLOSE"         (nth  8 CG_GLOBAL$) 'STR)
;;;		      (list "天板_吊戸高さ"      (nth 31 CG_GLOBAL$) 'STR)
;;;		      (list "カウンタ材質"       (nth 16 CG_GLOBAL$) 'STR) ;追加
;;;		    )
;;;		  )
;;;
;;;		)
;;;		(progn

		  ;2008/06/21 YM MOD [プラ管理]下台引当て
		  (setq #LIST$$
		    (list
		      (list "ユニット記号"       (nth  3 CG_GLOBAL$) 'STR)
		      (list "シンク側間口"       (nth  4 CG_GLOBAL$) 'STR)
		      (list "形状"               (nth  5 CG_GLOBAL$) 'STR)
		      (list "構成タイプ"         "1"                 'INT)
		      (list "フロアキャビタイプ" (nth  6 CG_GLOBAL$) 'STR)
		      (list "シンク位置"         (nth  2 CG_GLOBAL$) 'STR)
		      (list "コンロ位置"         (nth  9 CG_GLOBAL$) 'STR)
		      (list "食洗位置"           (nth 10 CG_GLOBAL$) 'STR)
		      (list "奥行き"             (nth  7 CG_GLOBAL$) 'STR)
		      (list "シンク記号"         (nth 17 CG_GLOBAL$) 'STR)
		      (list "SOFT_CLOSE"         (nth  8 CG_GLOBAL$) 'STR)
		      (list "天板_吊戸高さ"      (nth 31 CG_GLOBAL$) 'STR)
		    )
		  )

;;;		)
;;;	);_if


  (setq #DB_NAME "プラ管理")

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$)
  )

  (setq #qry$ (DBCheck #qry$ "『プラ管理』" "PFGetCompBase")) ; 検索結果WEB版ﾛｸﾞ出力

  (if (= CG_TESTMODE 1) ; ﾃｽﾄﾓｰﾄﾞ
    (setq P_baseID (strcat "ﾌﾟﾗﾝID(ﾌﾛｱ)= [" (rtois (car #qry$)) "]"))
  );_if

  ; プランID
  (setq #plan_id (nth 0 #qry$))
  ; シンク位置オフセット量を確保
  (setq CG_WSnkOf (nth 11 #qry$))

  ;;;// 『プラ構成』を検索、
  (setq #DB_NAME "プラ構成")
  (WebOutLog (strcat "検索DB名= "  #DB_NAME))

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME
      (list
        (list "プランID"  #plan_id  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  (if (= #qry$$ nil)
    (progn
      (setq #msg (strcat "『プラ構成』にレコードがありません。\nPFGetCompBase"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
      (quit)
    )
  );_if
  (list #qry$ #qry$$)
);PFGetCompBase

(princ)
