;<関数検索用>
;;;(defun GetMelamineWT   ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟの情報を取得
;;;(defun PKGetMelamineWT_Outline   ～\tmp\temp[&no].dwg として保存
;;;(defun C:PKShowWTinGroundPlan ( WT,BG外形寸法,穴情報,品番,価格,ｷｬﾋﾞ割付を描くコマンド
;;;(defun PKGetWT (                WTを指示
;;;(defun PKSetSYS ( / )           ｼｽﾃﾑ変数の設定
;;;(defun GetANAdimGAS-SNK$ (      WT寸法を、ｺﾝﾛ側、ｼﾝｸ側に分ける
;;;(defun GetANAcabGAS-SNK$ (      ｷｬﾋﾞ寸法Wを、ｺﾝﾛ側、ｼﾝｸ側に分ける
;;;(defun PKListToA_CabW (         ｷｬﾋﾞ寸法W数列を文字列にする (150 300) ==>"(150) (300)"
;;;(defun PKDimWrite (             WT寸法記入
;;;(defun PKCabWrite (             WT下ｷｬﾋﾞ寸法Ｗ記入
;;;(defun PK_BG_DimWrite (         BG寸法記入
;;;(defun PKITOAPRICE (            価格を文字列にする 1234000==>"1,234,000円"
;;;(defun PKWTGroundPlanWAKU (     枠をかく
;;;(defun PKGetWT-ANA_Outline (    WT図形名を渡してWT外形+ｼﾝｸ,ｺﾝﾛ穴図形ﾌﾞﾛｯｸを
;;;(defun PKGetBG_Outline (        WT図形名を渡してWT外形+ｼﾝｸ,ｺﾝﾛ穴図形ﾌﾞﾛｯｸを～\tmp\temp[&no].dwg として保存
;;;(defun XminYmax (               点列から ﾎﾟｲﾝﾄ座標(Xmin,Ymax)を返す

(defun c:ttt()
	(StartUndoErr);ｺﾏﾝﾄﾞの初期化
	(command "vpoint" "0,0,1") ; ===>真上からの外形,穴 がとれないため
	(GetMelamineWT)
)

(defun C:WTLayout ;00/08/03 SN MOD 改名
	(
	/
	#sFName #sMdlName
	#iOk
	)

	(StartUndoErr);ｺﾏﾝﾄﾞの初期化
  ;// ヘッダー情報書き出し 00/09/19 YM ADD
  (SKB_WriteHeadList)

	(setq #sMdlName (strcat (getvar "dwgprefix") (getvar "dwgname")));ｶﾚﾝﾄ図面名を記憶
	(setq #iOk (CFYesNoDialog "図面を一度保存しますか？"))
	(if (= T #iOk)
		(command "_.save" #sMdlName)
	)
	(setq #sFName (getfiled "ワークトップ図面" (strcat CG_KENMEI_PATH "OUTPUT\\") "dwg" 3))
	(if (/= nil #sFName)(progn
		(C:PKShowWTinGroundPlan)
		(command "_.save" #sFName)
		(if (/= (getvar "DBMOD") 0)
			(command "_.open" "y" #sMdlName)
			(command "_.open" #sMdlName)
		);END IF
	));END IF-PROGN
)

;;;<HOM>*************************************************************************
;;; <関数名>    : GetMelamineWT
;;; <処理概要>  : ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟの情報を取得
;;;               ～\tmp\temp[&no].dwg として保存
;;; <戻り値>    : 
;;;               ((ｵﾌﾞｼﾞｪｸﾄID
;;;                 ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ品番名称
;;;                 (ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ基点)
;;;                 (幅ﾘｽﾄ)※ﾜｰｸﾄｯﾌﾟのｺﾝﾛ&ｼﾝｸ無の状態と同ﾃﾞｰﾀ
;;;                 (奥行きﾘｽﾄ)
;;;                 (下のｷｬﾋﾞﾈｯﾄ幅)※個数分LIST
;;;                 ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ幅
;;;                 ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ奥行き
;;;                 ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ高さ
;;;                 ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ角度
;;;                 ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ価格
;;;               ))
;;; <作成>      : 2000.8.04 SN
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun GetMelamineWT(
    /
    ;
    #pdsize
    ;図面からﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟを探す
    #ssLSYM #iI #xdLSYM #mWT$ #mWTdata$$
    ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ領域のｷｬﾋﾞﾈｯﾄ幅を取得
    ;#ssLSYM #xdLSYM #iI
    #mWT #xdSYM #mCabDim$
    #pBasePt #rAng #rW #rD #rH #pOppPt #sHinban
    #fig$ #MCAB$
    )

    ;環境変数初期化
    (setq #pdsize (getvar "PDSIZE"))
    (setvar "PDSIZE" 1)

    ;変数初期化
    (setq #iI 0)
    (setq #mWT$ '())

    ;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;図面からﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟを探す
    ;;;;;;;;;;;;;;;;;;;;;;;;;;
    (setq #ssLSYM (ssget "X" '((-3 ("G_LSYM")))));G_LSYMｱｲﾃﾑを収集
    (if #ssLSYM
      (repeat (sslength #ssLSYM)
        (if (setq #xdLSYM (CFGetXData (ssname #ssLSYM #iI) "G_LSYM"))
          (if (= (nth 9 #xdLSYM) 710);性格ｺｰﾄﾞで判断
          ;(if (wcmatch (nth 5 #xdLSYM) "KS-M*");品番名称で判断
              (setq #mWT$ (append (list (ssname #ssLSYM #iI))))
          );end if
        );end if
        (setq #iI (1+ #iI))
      );end repeat
    );end if

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ関連情報の収集
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (setq #mWTdata$$ '())
    (foreach #mWT #mWT$
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ領域のｷｬﾋﾞﾈｯﾄ幅を取得
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (setq #pBasePt (cdr (assoc 10 (entget #mWT))));基準点を取得
      (if (setq #xdLSYM (CFGetXData #mWT "G_LSYM"))(progn
        (setq #rAng    (nth 2 #xdLSYM));回転角度
        (setq #sHinban (nth 5 #xdLSYM));品番名称
      ));end if-progn
      (if (setq #xdSYM (CFGetXData #mWT "G_SYM"))(progn
        (setq #rW (nth 3 #xdSYM));基準W
        (setq #rD (nth 4 #xdSYM));基準D
        (setq #rH (nth 5 #xdSYM));基準H
      ));end if-progn
      ;対角の点を求める
      (setq #pOppPt (polar (polar #pBasePt #rAng #rW) (- #rAng (* 0.5 pi)) #rD))
      ;接するｷｬﾋﾞﾈｯﾄをｾｯﾄしてしまう為、点を少し内側に寄せる。
      (setq #pOppPt  (polar #pOppPt  #rAng -5))
      ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ領域
      (setq #ssLSYM (ssget "C" #pBasePt #pOppPt '((-3 ("G_LSYM")))))
;(command "line" #pBasePt #pOppPt "");DEBUG
      ;選択ｾｯﾄ内のﾌﾛｱ設置ｱｲﾃﾑを取得
;(princ "選択ｾｯﾄに");debug
;(princ (sslength #ssLSYM));debug
;(princ "のアイテムがセットされました。\n" );debug
      (setq #iI 0)
      (setq #mCab$ '())
      (if #ssLSYM
        (repeat (sslength #ssLSYM)
          (if (setq #xdSYM (CFGetXData (ssname #ssLSYM #iI) "G_SYM"))
            ;高さ0設置ｱｲﾃﾑをｷｬﾋﾞﾈｯﾄとする。
            (if (equal (nth 6 #xdSYM) 0 0.0001)(progn
              (setq #mCabDim$ (append #mCabDim$ (list (nth 3 #xdSYM))))
;(GroupInSolidChgCol2 (ssname #ssLSYM #iI) CG_InfoSymCol);debug
            ));end if
          );end if
          (setq #iI (1+ #iI))
        );end repeat
      );end if
;(princ "メラミン下のキャビネットは");debug
;(princ (length #mCabDim$));debug
;(princ "です。\n");debug
      ;D/B品番基本ﾃｰﾌﾞﾙからﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟの情報を取得
      (setq
        #fig$
        (CFGetDBSQLHinbanTableChk
          "品番基本"
          #sHinban
          (list (list "品番名称" #sHinban 'STR))
        )
      )
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟの情報ﾘｽﾄを作成
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (setq #mWTdata$$ (append #mWTdata$$ 
        (list (list
          #mWT                            ;Entity
          #sHinban                        ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ品番名称
          #pBasePt                        ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ基点
          (list #rW #rW "" "" "" "" "" "");幅ﾘｽﾄ※ﾜｰｸﾄｯﾌﾟのｺﾝﾛ&ｼﾝｸ無の状態
          (list #rD 0.0 0.0)              ;奥行きﾘｽﾄ
          #mCabDim$                       ;下のｷｬﾋﾞﾈｯﾄ幅(個数分LIST)
          #rW                             ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ幅
          #rD                             ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ奥行き
          #rH                             ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ高さ
          #rAng                           ;ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ角度
          (if #fig$ (nth 14 #fig$) 0)     ;価格
        ))
      ))
    );end repeat

    (setvar "PDSIZE" #pdsize)

    #mWTdata$$
);GetMelamineWT

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetMelamineWT_Outline
;;; <処理概要>  : 
;;;               ～\tmp\temp[&no].dwg として保存
;;; <戻り値>    : なし
;;; <作成>      : 2000.8.04 SN
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PKGetMelamineWT_Outline (
	&WT     ; WT図形名
	&no     ; 最右ＷＴからの番号 0,1,2...
	&mWT$
  /
	#ANG #BASEWT #EGAS_P5$ #ESNK_P$ #ESNK_P1$ #ESNK_P4$ #GAS$$ 
	#P1 #P2 #P3 #PT$ #RET$ #SNK$$ #SS #TEIWT #XDWT$ #ZAI
	#lent #gent #nent #olayer #nlayer #dmyWT #MWT$
  #iFILEDIA   ; システム変数 01/11/22 HN ADD
  )
	(setq #teiWT nil)
	(setq #dmyWT nil)
	(setq #ss (ssadd))
	(setq #baseWT (nth 2 #mWT$));基準点を取得
	(setq #xdWT$ (CFGetXData &WT "G_PMEN"))
	(if #xdWT$
		;G_PMENがあればﾎﾟﾘﾗｲﾝ情報を取得 なければﾀﾞﾐｰを作成
		(setq #teiWT (nth 0 #xdWT$))   ;WTﾎﾟﾘﾗｲﾝ
		(progn ; ELSE
			;ﾀﾞﾐｰﾎﾟﾘﾗｲﾝの座標作成
			;6=W 7=D 8=H 9=ANG
			(setq #p1 (polar #baseWT (nth 9 &mWT$) (nth 6 &mWT$)))
			(setq #p2 (polar #p1 (- (nth 9 &mWT$) (* pi 0.5)) (nth 7 &mWT$)))
			(setq #p3 (polar #p2 (nth 9 &mWT$) (* -1 (nth 6 &mWT$))))
			(setq #lent (entlast));現在の最終Entity取得
			(command "_.pline" #baseWT #p1 #p2 #p3 "C")
			(setq #dmyWT (entlast));ﾀﾞﾐｰﾎﾟﾘﾗｲﾝのEntity取得
			;ﾀﾞﾐｰﾎﾟﾘﾗｲﾝ作成が正常ならteiWTに代入
			(if (not (equal #lent #dmyWT))
				(setq #teiWT #dmyWT)
			)
		)
	);end if
;???	(setq #zai (substr (nth 2 #xdWT$) 1 1)) ; 材質

	(if #teiWT (progn
		;ﾀﾞﾐｰﾎﾟﾘﾗｲﾝを作成していたら画層を変える
		(if #dmyWT (progn
			(setq #gent (entget #teiWT))              ;Entity情報
			(setq #olayer (assoc 8 #gent))            ;画層を取得
			(setq #nlayer (cons 8 SKW_AUTO_SECTION))  ;配置画層名
			(setq #nent (subst #nlayer #olayer #gent));画層を置きかえる
			(entmod #nent)                            ;Entyty更新
		));end if - progn

		(ssadd #teiWT #ss)
		;;; UCS定義
		(setq #pt$ (GetLWPolyLinePt #teiWT))    ; WT外形点列
		(setq #pt$ (GetPtSeries #baseWT #pt$))  ; #BASEPT を先頭に時計周り
		(setq #p1 (nth 0 #pt$))
		(setq #p2 (nth 1 #pt$))
		(setq #ang (angle #p1 #p2))
		(setq #p3 (polar #p1 (+ #ang (dtr 90)) 500))
		(command "._ucs" "3" #p1 #p2 #p3)
		(setq #baseWT (trans #baseWT 0 1))      ; ﾕｰｻﾞｰ座標系に変換

		;;; ﾌﾞﾛｯｸ保存
		(setq #iFILEDIA (getvar "FILEDIA")) ; 01/11/22 HN ADD
		(setvar "FILEDIA" 0)
		(command "._wblock" (strcat CG_SYSPATH "tmp\\tempWT" &no ".dwg") "" #baseWT #ss "")
		(command "._oops") ; 図形復活
		(command "._ucs" "P")
		(if #dmyWT (entdel #teiWT));ﾀﾞﾐｰﾎﾟﾘﾗｲﾝ削除
		(setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD
	));end if - progn
	(princ)
);PKGetMelamineWT_Outline

;;;<HOM>*************************************************************************
;;; <関数名>    : C:PKShowWTinGroundPlan
;;; <処理概要>  : WT,BG外形寸法,穴情報,品番,価格,ｷｬﾋﾞ割付を描くコマンド
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.20 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun C:PKShowWTinGroundPlan (
  /
	#BLPT #FLG #HINBAN #HINBAN$ #I #INSPT #NO #PRICE #PRICE$ #TYPE 
	#WT #WT$ #WTMR #XDWT$ #XDWTSET$ #DIM$ #IPT #K #Y #DIM$$ #DEP$$
	#CABW #CABW$ #CABW$$ #XDWTCT$
	#BG$ #BG1 #BG2 #BGTEI #BG_HIN #BG_HIN$ #BG_LEN$ #BG_PRI #BG_PRI$ #XDBG$
	#mWTdata$$ #mWT$
	#title$ #title1 #title2 #title3 #STRANG #STRH #STRPT
  )
	;;; 00/09/19 YM MOVE
	(setq #title$ (SCFGetTitleStr))
	(setq #title1 (strcat "【ワークトップ･バックガード】　" (nth 5 #title$)))
	(setq #title2 (strcat "管理コード：" (nth 2 #title$)))
	(setq #title3 (nth 9 #title$))

  ;;; コマンドの初期化
;	(StartUndoErr);00/08/03 SN MOD ｺﾏﾝﾄﾞの初期化は上位で行う
	;;; WTを指示
	(setq #WT (PKGetWT))
	(command "vpoint" "0,0,1") ; ===>真上からの外形,穴 がとれないため
	;;; 最右WTを取得
	(setq #WTMR (car (PKGetMostRightWT #WT)))
	(setq #WT$ (PKGetWT$FromMRWT #WTMR))    ; 一番右WT==>右から順の関連WTﾘｽﾄを返す
	(setq #xdWT$ (CFGetXData (car #WT$) "G_WRKT"))
	(setq #ZaiCode (nth 2 #xdWT$))
	(setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
	(setq #type (nth 3 #xdWT$))       ; L:形状ﾀｲﾌﾟ1
	(setq #flg nil)
	(if (and (not (equal (KPGetSinaType) -1 0.1))(= #ZaiF 1)(= #type 1))
		(setq #flg "SL") ; ｽﾃﾝﾚｽL型
	);_if
	;;; 画層をすべてﾌﾘｰｽﾞ解除 ===>穴がとれないため
	(command "_layer" "T" "*" "")
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;; WT品番,価格,寸法数列,ｷｬﾋﾞW値数列を格納し、WT平面図ﾌﾞﾛｯｸ作成 ;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(setq #i 0 #dim$$ '() #dep$$ '() #cabW$$ '() #BG$ '())
	(foreach #WT #WT$ ; 1つのプランで隣接ＷＴ繰り返し処理
	  (if (setq #xdWTSET$ (CFGetXData #WT "G_WTSET"))
			(progn ; 品番確定されている
				(setq #HINBAN$ (append #HINBAN$ (list (nth 1 #xdWTSET$)))) ; WT品番
				(setq #PRICE$  (append #PRICE$  (list (nth 3 #xdWTSET$)))) ; WT価格
				; 寸法数列を作成
				(setq #k 6 #dim$ '())
				(repeat (nth 5 #xdWTSET$) ; 穴寸法個数
					(setq #dim$ (append #dim$ (list (nth #k #xdWTSET$))))
					(setq #k (1+ #k))
				)
				(setq #dim$$ (append #dim$$ (list #dim$))) ; 寸法数列
;;;				; ｷｬﾋﾞW数列を作成
;;;				(setq #xdWTCT$ (CFGetXData #WT "G_WTCT"))
;;;				(setq #k 10 #cabW$ '())
;;;				(repeat 14 
;;;					(setq #cabW (nth #k #xdWTCT$))
;;;					(if (/= #cabW "")
;;;						(setq #cabW$ (append #cabW$ (list #cabW)))
;;;					);_if
;;;					(setq #k (1+ #k))
;;;				)
;;;				(setq #cabW$$ (append #cabW$$ (list #cabW$))) ; ｷｬﾋﾞW数列
			)
			(progn ; 品番確定されていない
				(CFAlertMsg "ワークトップは品番確定されていません。")
				(quit)
			)
		)
		(setq #xdWT$ (CFGetXData #WT "G_WRKT"))
		(setq #BG1 (nth 49 #xdWT$))
		(if (/= #BG1 "")
			(if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
				(setq #BG$ (append #BG$ (list #BG1)))
			)
		)

		(setq #BG2 (nth 50 #xdWT$))
		(if (/= #BG2 "")
			(if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
				(setq #BG$ (append #BG$ (list #BG2)))
			)
		)

		(setq #dep$$ (append #dep$$ (list (nth 57 #xdWT$)))) ; 奥行き
		(setq #no (itoa #i))
		(PKGetWT-ANA_Outline #WT #no) ; ﾌﾞﾛｯｸを ～\tmp\tempWT[#i].dwg として保存
		(setq #i (1+ #i))
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;; 00/08/04 SN ADD tempWT[#1]の続きでﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟのﾌﾞﾛｯｸを作成
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(setq #mWTdata$$ (GetMelamineWT));ﾒﾗﾐﾝﾜｰｸﾄｯﾌﾟ関連情報を取得
	(foreach #mWT$ #mWTdata$$
		(setq #WT$     (append #WT$     (list (nth  0 #mWT$))))
		(setq #HINBAN$ (append #HINBAN$ (list (nth  1 #mWT$))))
		(setq #dim$$   (append #dim$$   (list (nth  3 #mWT$))))
		(setq #dep$$   (append #dep$$   (list (nth  4 #mWT$))))
		(setq #cabW$$  (append #cabW$$  (list (nth  5 #mWT$))))
		(setq #PRICE$  (append #PRICE$  (list (nth 10 #mWT$))))
		;ｱｳﾄﾗｲﾝをﾌﾞﾛｯｸに書き出す
		(setq #no (itoa #i))
		(PKGetMelamineWT_Outline (nth 0 #mWT$) #no #mWT$)
		(setq #i (1+ #i))
	)
	;00/08/04 SN E-ADD

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;; BG品番,価格,寸法数列を格納し、BG平面図ﾌﾞﾛｯｸ作成 ;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(setq #i 0)
	(foreach #BG #BG$ ; 1つのプランで隣接ＷＴ繰り返し処理
	  (if (setq #xdBG$ (CFGetXData #BG "G_BKGD"))
			(progn
				(setq #BGtei (nth 1 #xdBG$)) ; BG底面図形
				(setq #WT    (nth 2 #xdBG$)) ; 関連WT
				(setq #BG_HIN$ (append #BG_HIN$  (list (nth 0 #xdBG$)))) ; BG品番
				(setq #BG_LEN$ (append #BG_LEN$  (list (nth 3 #xdBG$)))) ; BG長さ
				(setq #BG_PRI$ (append #BG_PRI$  (list (nth 4 #xdBG$)))) ; BG価格
			)
	  )
		(setq #no (itoa #i))
		(PKGetBG_Outline #BGtei #WT #no) ; ﾌﾞﾛｯｸを ～\tmp\tempBG[#i].dwg として保存
		(setq #i (1+ #i))
	)

;;;03/09/29YM@MOD  ;// 表示画層の設定(プラン検索同様の画層処理)
;;;03/09/29YM@MOD  (command "_layer"
;;;03/09/29YM@MOD    "F"   "*"                ;全ての画層をフリーズ
;;;03/09/29YM@MOD    "T"   "Z_00*"            ;  Z_00立体ソリッド画層のフリーズ解除
;;;03/09/29YM@MOD    "T"   "N_*"              ;  N_*シンボル原点図形画層のフリーズ解除
;;;03/09/29YM@MOD    "T"   "M_*"              ;  M_*目地領域図形画層の解除
;;;03/09/29YM@MOD    "T"   "0"                ;  "0"画層の解除
;;;03/09/29YM@MOD    "ON"  "M_*"              ;  M_*目地領域図形画層の表示
;;;03/09/29YM@MOD    "OFF" "N_B*" ""          ;  N_B*ブレークライン図形の非表示
;;;03/09/29YM@MOD  )
	(SetLayer);03/09/29 YM MOD

	(command "zoom" "p")
  ;;; 自動保存
;;;  (CFAutoSave) ; --->ＷＴ平面図をかかない
	;(command "_.save" (strcat (getvar "dwgprefix") (getvar "dwgname"))) 00/08/03 SN MOD 保存は別個所で行う
	;;; 新規図面を開く
	(if (/= (getvar "DBMOD") 0)
		(progn
			;00/08/03 SN MOD 保存は別途ﾕｰｻﾞ指示により行っているのでここでは強制NEWを行う
			(command "._new" "N" ".")
	   	;(command "_qsave")
	   	;(vl-cmdf "._new" ".")
		)
		(progn
		(vl-cmdf "._new" ".")
		)
	);_if

	;;;;;;;;;;;;;;;;;;;;;;;;
	;;; 新規図面作図開始 ;;;
	;;;;;;;;;;;;;;;;;;;;;;;;
	(PKSetSYS) ; ｼｽﾃﾑ変数の設定

	;;; WT ;;;
	(if (= #flg "SL")
		(setq #Y 5200 #iPT '(600  -900)) ; ｽﾃﾝﾚｽＬ型
		(setq #Y 3200 #iPT '(600 -1400)) ; ｽﾃﾝﾚｽＬ型以外
	);_if

;;; ﾀｲﾄﾙ覧 品番記入
	(setq #strH "120")
	(setq #strANG "0")
	(setq #strPT (list    0 200))
	(command "._TEXT" #strPT #strH #strANG #title1)
	(setq #strPT (list 8500 200))
	(command "._TEXT" #strPT #strH #strANG #title2)

	(setq #i 0)
	(repeat (length #WT$)
		(setq #HINBAN (nth #i #HINBAN$))
		(setq #PRICE  (nth #i #PRICE$ ))
		(setq #PRICE (PKITOAPRICE #PRICE)) ; 1234000==>"1,234,000円"
		(setq #insPT (list 0 (* #i (- (+ #Y 200)))))
		(PKWTGroundPlanWAKU #insPT 5000 #Y 200 #HINBAN #PRICE) ; 枠をかく
 		;;; ﾌﾞﾛｯｸを挿入
		(setq #blPT (mapcar '+ #iPT #insPT))
		(command "._insert" (strcat CG_SYSPATH "tmp\\tempWT" (itoa #i) ".dwg") #blPT 1 1 "0");2009
		;;; 寸法記入
		(PKDimWrite #flg (nth #i #dim$$) (nth #i #dep$$) #blPT)
		;;; ｷｬﾋﾞW記入
;;;		(PKCabWrite #flg (nth #i #dim$$) (nth #i #dep$$) (nth #i #cabW$$) #blPT)
		(setq #i (1+ #i))
	)
	(setq #strPT (list 9300 (- (* #i (- (+ #Y 200))) (atoi #strH))) )
	(command "._TEXT" #strPT #strH #strANG #title3)

	;;; BG ;;;
	(setq #Y 2200 #iPT '(600 -1400))
	
	(setq #i 0)
	(repeat (length #BG$)
		(setq #BG_HIN (nth #i #BG_HIN$))
		(setq #BG_PRI  (nth #i #BG_PRI$))
		(setq #BG_PRI (PKITOAPRICE #BG_PRI)) ; 1234000==>"1,234,000円"
		(setq #insPT (list 5200 (* #i (- (+ #Y 200)))))
		(PKWTGroundPlanWAKU #insPT 5000 #Y 200 #BG_HIN #BG_PRI) ; 枠をかく
 		;;; ﾌﾞﾛｯｸを挿入
		(setq #blPT (mapcar '+ #iPT #insPT))
		(command "._insert" (strcat CG_SYSPATH "tmp\\tempBG" (itoa #i) ".dwg") #blPT 1 1 "0");2009
		;;; BG寸法記入
		(PK_BG_DimWrite (nth #i #BG_LEN$) #blPT)
		(setq #i (1+ #i))
	)

	(command "._zoom" "e")
	(princ)
);C:PKShowWTinGroundPlan

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetWT
;;; <処理概要>  : WTを指示
;;; <戻り値>    : (WT図形名,"G_WRKT")
;;; <作成>      : 2000.6.21 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PKGetWT (
  /
	#LOOP #WT
  )
  ;;; ワークトップの指示
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #WT (car (entsel "\nワークトップを選択: ")))
		(if (= #WT nil)
			(CFAlertMsg "ワークトップではありません。")
			(progn
	      (if (= (CFGetXData #WT "G_WRKT") nil)
	        (CFAlertMsg "ワークトップではありません。")
	        (setq #loop nil)
	      )
			)
		);_if
  )
	#WT ; WT図形名
);PKGetWT

;;;<HOM>*************************************************************************
;;; <関数名>    : PKSetSYS
;;; <処理概要>  : ｼｽﾃﾑ変数の設定
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.21 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PKSetSYS ( / )
	(setvar "GRIDUNIT" '( 150  150))
	(setvar "SNAPUNIT" '(  50   50))
	(setvar "LIMMAX"   '(4000 4000))
	(setvar "LIMMIN"   '(   0    0))
	;;; 寸法関連ｼｽﾃﾑ変数の設定
	(setvar "DIMTMOVE" 1)  			; 寸法値移動規則
	(setvar "DIMEXE" 50)   			; 補助線延長長さ
	(setvar "DIMEXO" 25)   			; 起点からのｵﾌｾｯﾄ
	(setvar "DIMBLK" "OPEN30")  ; 30度開矢印
	(setvar "DIMASZ" 50)   			; 矢印のｻｲｽﾞ
	(setvar "DIMTXT" 50)   			; 文字高さ
	(setvar "DIMTAD"  0)   			; 寸法配置垂直方向
	(setvar "DIMJUST" 0)   			; 寸法配置水平方向
	(setvar "DIMGAP" 25)   			; 寸法線からのｵﾌｾｯﾄ
	(setvar "DIMDEC" 0)    			; 精度
	(setvar "DIMATFIT" 2)  			; 寸法値矢印フィット
	(command "._UCSICON" "OF")
	(princ)
);PKSetSYS

;;;<HOM>*************************************************************************
;;; <関数名>    : GetANAdimGAS-SNK$
;;; <処理概要>  : WT寸法を、ｺﾝﾛ側、ｼﾝｸ側に分ける
;;; <戻り値>    : ｺﾝﾛ側、ｼﾝｸ側 穴寸法数列
;;; <作成>      : 2000.6.21 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun GetANAdimGAS-SNK$ (
	&WTLEN1 ; ｺﾝﾛ側
	&dim$   ; 穴寸法数列
	&dimnum ; 穴寸法数列の実ﾃﾞｰﾀ数
	/
	#GASDIM$ #I #SNKDIM$ #SUM #dim
  )

	(setq #GASdim$ '())
	(setq #SNKdim$ '())
	(setq #i 0 #sum 0)
	(repeat (- &dimnum 2)
	;(repeat 6
		(setq #dim (nth #i &dim$))		
		(if (/= #dim "")
			(progn
				(setq #sum (+ #sum #dim))
				(if (< #sum (+ &WTLEN1 0.1))
					(setq #GASdim$ (append #GASdim$ (list #dim)))
					(setq #SNKdim$ (append #SNKdim$ (list #dim)))
				);_if
			)
		);_if
		(setq #i (1+ #i))
	)
	(list #GASdim$ #SNKdim$)
);GetANAdimGAS-SNK$

;;;<HOM>*************************************************************************
;;; <関数名>    : GetANAcabGAS-SNK$
;;; <処理概要>  : ｷｬﾋﾞ寸法Wを、ｺﾝﾛ側、ｼﾝｸ側に分ける
;;; <戻り値>    : ｺﾝﾛ側、ｼﾝｸ側 寸法W数列
;;; <作成>      : 2000.6.23 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun GetANAcabGAS-SNK$ (
	&WTLEN1 ; ｺﾝﾛ側
	&cab$   ; ｷｬﾋﾞ寸法数列
  /
	#CAB #GASCAB$ #I #SNKCAB$ #SUM
  )

	(setq #GAScab$ '())
	(setq #SNKcab$ '())
	(setq #i 0 #sum 0)
	(repeat (length &cab$)
		(setq #cab (nth #i &cab$))		
		(if (/= #cab "")
			(progn
				(setq #sum (+ #sum #cab))
				(if (< #sum (+ &WTLEN1 0.1))
					(setq #GAScab$ (append #GAScab$ (list #cab)))
					(setq #SNKcab$ (append #SNKcab$ (list #cab)))
				);_if
			)
		);_if
		(setq #i (1+ #i))
	)
	(list #GAScab$ #SNKcab$)
);GetANAcabGAS-SNK$

;;;<HOM>*************************************************************************
;;; <関数名>    : PKListToA_CabW
;;; <処理概要>  : ｷｬﾋﾞ寸法W数列を文字列にする (150 300) ==>"(150) (300)"
;;; <戻り値>    : 文字列
;;; <作成>      : 2000.6.23 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PKListToA_CabW (
	&cab$ ; ｷｬﾋﾞ寸法W数列
  /
	#DUM
  )
	(setq #dum " ")
	(foreach #cab &cab$
		(setq #cab (itoa (fix (+ #cab 0.00001))))
		(setq #dum (strcat #dum "(" #cab ")"))
	)
	#dum
);PKListToA_CabW

;;;<HOM>*************************************************************************
;;; <関数名>    : PKDimWrite
;;; <処理概要>  : WT寸法記入
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.21 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PKDimWrite (
	&flg   ; ﾌﾗｸﾞ ｽﾃﾝﾚｽL=>"SL" 他=> nil
	&dim$  ; 穴寸法数列
	&dep$  ; 奥行きﾘｽﾄのﾘｽﾄ
	&blPT  ; block挿入点
  /
	#DIM #DIMPT #DIMPT1 #DIMPT2 #I #K #WTLEN
	#EDPT #GASDIM$ #RET$ #SNKDIM$ #STPT #WTLEN1 #WTLEN2
	#DIMNUM ;00/08/03 SN ADD
  )
  	;00/08/03 SN ADD 寸法を表記する数を数える
  	;I型の場合 ６個MAX ｼﾝｸ･ｺﾝﾛが抜けるとそれぞれ-2
  	(setq #dimnum 0)
	(foreach #dim &dim$
	  (if (/= #dim "") (setq #dimnum (1+ #dimnum)))
	)
  
	(if (= &flg "SL")
		(progn ; L型
			(setq #WTLEN1 (nth (- #dimnum 2) &dim$)) ; ｺﾝﾛ側 00/08/03 SN MOD
			(setq #WTLEN2 (nth (- #dimnum 1) &dim$)) ; ｼﾝｸ側 00/08/03 SN MOD
			(setq #ret$ (GetANAdimGAS-SNK$ #WTLEN1 &dim$ #dimnum));00/08/03 SN MOD 引数の追加
			;(setq #WTLEN1 (nth 6 &dim$)) ; ｺﾝﾛ側 00/08/03 SN MOD
			;(setq #WTLEN2 (nth 7 &dim$)) ; ｼﾝｸ側 00/08/03 SN MOD
			;(setq #ret$ (GetANAdimGAS-SNK$ #WTLEN1 &dim$))
			(setq #GASdim$ (nth 0 #ret$)) ; ｺﾝﾛ側
			(setq #SNKdim$ (nth 1 #ret$)) ; ｼﾝｸ側
			(setq #stPT (polar &blPT (dtr -90) #WTLEN1)) ; 寸法書き出し点ｺﾝﾛ側
			(setq #edPT (polar &blPT 0.0       #WTLEN2)) ; 寸法終了点ｼﾝｸ側
			;;; ｺﾝﾛ側 穴寸法
			(if (= (length #GASdim$) 1)
				(progn ; 寸法１つだけ===>記入終了
					(setq #dimPT1 (polar #stPT (dtr 90) (nth 0 #GASdim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 180) 400))
					(command "._DIMLINEAR" #stPT #dimPT1 #dimPT2)	; 寸法記入
				)
				(progn  ; 寸法複数
					;;; １つ目の寸法を記入する
					(setq #dimPT1 (polar #stPT (dtr 90) (nth 0 #GASdim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 180) 200))
					(command "._DIMLINEAR" #stPT #dimPT1 #dimPT2)	; 寸法記入

					(setq #dimPT #dimPT1)
					(setq #k 1)
					(repeat (1- (length #GASdim$))
						(setq #dim (nth #k #GASdim$))
						(setq #dimPT (polar #dimPT (dtr 90) #dim))
						(command "._DIMCONTINUE" #dimPT  "" "")	; 直列寸法記入
						(setq #k (1+ #k))
					);_repeat

					;;; 全体の寸法を記入する
					(setq #dimPT1 (polar #stPT (dtr 90) #WTLEN1))
					(setq #dimPT2 (polar #dimPT1 (dtr 180) 400))
					(command "._DIMLINEAR" #stPT #dimPT1 #dimPT2)	; 寸法記入
				)
			);_if
			
			;;; 奥行き
			(setq #dimPT1 (polar #stPT 0.0 (nth 1 &dep$)))
			(setq #dimPT2 (polar #dimPT1 (dtr -90) 400))
			(command "._DIMLINEAR" #stPT #dimPT1 #dimPT2)	; 寸法記入

			;;; ｼﾝｸ側 穴寸法
			(if (= (length #SNKdim$) 1)
				(progn ; 寸法１つだけ===>記入終了
					(setq #dimPT1 (polar &blPT 0.0 (nth 0 #SNKdim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 400))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; 寸法記入
				)
				(progn  ; 寸法複数
					;;; １つ目の寸法を記入する
					(setq #dimPT1 (polar &blPT 0.0 (nth 0 #SNKdim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 200))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; 寸法記入

					(setq #dimPT #dimPT1)
					(setq #k 1)
					(repeat (1- (length #SNKdim$))
						(setq #dim (nth #k #SNKdim$))
						(setq #dimPT (polar #dimPT 0.0 #dim))
						(command "._DIMCONTINUE" #dimPT  "" "")	; 直列寸法記入
						(setq #k (1+ #k))
					);_repeat

					;;; 全体の寸法を記入する
					(setq #dimPT1 (polar &blPT 0.0 #WTLEN2))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 400))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; 寸法記入
				)
			);_if

			;;; 奥行き
			(setq #dimPT1 (polar #edPT (dtr -90) (nth 0 &dep$)))
			(setq #dimPT2 (polar #dimPT1 0.0 400))
			(command "._DIMLINEAR" #edPT #dimPT1 #dimPT2)	; 寸法記入

		)
		(progn ; I型
			(setq #WTLEN (nth (1- #dimnum) &dim$));00/08/03 SN MOD 寸法ﾘｽﾄの最後がWTLEN
		 	;(setq #WTLEN (nth 5 &dim$))          ;00/08/03 SN MOD
			;;; 穴寸法
			(if (equal (nth 0 &dim$) #WTLEN 0.001)
				(progn ; 寸法１つだけ===>記入終了
					(setq #dimPT1 (polar &blPT 0.0 (nth 0 &dim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 400))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; 寸法記入
				)
				(progn  ; 寸法複数
					;;; １つ目の寸法を記入する
					(setq #dimPT1 (polar &blPT 0.0 (nth 0 &dim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 200))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; 寸法記入

					(setq #dimPT #dimPT1)
					(setq #k 1) 
					(repeat (- #dimnum 2);00/08/03 SN MOD 寸法ﾘｽﾄ数-2を直列表記 
					;(repeat 4           ;00/08/03 SN MOD
						(setq #dim (nth #k &dim$))
						(if (/= #dim "")(progn;00/08/03 SN MOD CommandもIF内に含める
							(setq #dimPT (polar #dimPT 0.0 #dim))
						;)
							(command "._DIMCONTINUE" #dimPT  "" "")	; 直列寸法入
						));END IF -PROGN
						(setq #k (1+ #k))
					);_repeat

					;;; 全体の寸法を記入る
					(setq #dimPT1 (polar &blPT 0.0 #WTLEN))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 400))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; 寸法記入
				)
			);_if

			;;; 奥行き
			(setq #dimPT1 (polar &blPT (dtr -90) (car &dep$)))
			(setq #dimPT2 (polar #dimPT1 (dtr 180) 400))
			(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; 寸法記入
		)
	);_if
	(princ)
);PKDimWrite

;;;<HOM>*************************************************************************
;;; <関数名>    : PKCabWrite
;;; <処理概要>  : WT下ｷｬﾋﾞ寸法Ｗ記入
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.21 YM
;;; <備考>      : WT長さ #WTLEN1 とｷｬﾋﾞ寸法Wとは必ずしも一致しない
;;;             ; 
;;;*************************************************************************>MOH<
(defun PKCabWrite (
	&flg   ; ﾌﾗｸﾞ ｽﾃﾝﾚｽL=>"SL" 他=> nil
	&dim$  ; 穴寸法数列
	&dep$  ; 奥行きﾘｽﾄ
	&cab$  ; ｷｬﾋﾞ寸法Ｗ数列
	&blPT  ; block挿入点
  /
	#STR #STRANG #STRH #STRPT
	#EDPT #GASCAB$ #RET$ #SNKCAB$ #STPT #STRANG90 #WTLEN1 #WTLEN2
	#DIMNUM #DIM;00/08/04 SN ADD
  )
  	;00/08/04 SN ADD 寸法を表記する数を数える
  	;I型の場合 ６個MAX ｼﾝｸ･ｺﾝﾛが抜けるとそれぞれ-2
  	(setq #dimnum 0)
	(foreach #dim &dim$
	  (if (/= #dim "") (setq #dimnum (1+ #dimnum)))
	)

	(setq #strH "50")
	(setq #strANG    "0")
	(setq #strANG90 "90")

	(if (= &flg "SL")
		(progn ; L型
;;; &blPT
;;;  +----------------#edPT
;;;  |                 |
;;;  |                 |
;;;  |      +----------+
;;;  |      |
;;;  |      |
;;;#stPT----+
			(setq #WTLEN1 (nth (- #dimnum 2) &dim$)) ; ｺﾝﾛ側 00/08/04 SN MOD
			(setq #WTLEN2 (nth (- #dimnum 1) &dim$)) ; ｼﾝｸ側 00/08/04 SN MOD
			;(setq #WTLEN1 (nth 6 &dim$)) ; ｺﾝﾛ側 00/08/03 SN MOD
			;(setq #WTLEN2 (nth 7 &dim$)) ; ｼﾝｸ側 00/08/03 SN MOD
			(setq #stPT (polar &blPT (dtr -90) #WTLEN1)) ; 寸法書き出し点ｺﾝﾛ側
			(setq #edPT (polar &blPT 0.0       #WTLEN2)) ; 寸法終了点ｼﾝｸ側
			(setq #ret$ (GetANAcabGAS-SNK$ #WTLEN1 &cab$))
			(setq #GAScab$ (nth 0 #ret$)) ; ｺﾝﾛ側
			(setq #SNKcab$ (nth 1 #ret$)) ; ｼﾝｸ側
			;;; ｺﾝﾛ側
			(setq #STR (PKListToA_CabW #GAScab$))
			(setq #strPT (polar #stPT 0.0 (+ (cadr &dep$) 200))) ; 寸法書き出し点ｺﾝﾛ側
			(command "._TEXT" #strPT #strH #strANG90 #STR)
			;;; ｼﾝｸ側
			(setq #STR (PKListToA_CabW #SNKcab$))
			(setq #strPT (polar #edPT  (dtr -90) (+ (car &dep$) 200))) ; 寸法書き出し点ｼﾝｸ側
			(setq #strPT (polar #strPT (dtr 180) (+ (- #WTLEN2 (cadr &dep$)) -200))) ; 寸法書き出し点ｼﾝｸ側
			(command "._TEXT" #strPT #strH #strANG #STR)
		)
		(progn ; I型
			(setq #STR (PKListToA_CabW &cab$))
			(setq #strPT (polar &blPT (dtr -90) (+ (car &dep$) 200))) ; 寸法書き出し点ｺﾝﾛ側
			(command "._TEXT" #strPT #strH #strANG #STR)
		)
	);_if
	(princ)
);PKCabWrite

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_BG_DimWrite
;;; <処理概要>  : BG寸法記入
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.21 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PK_BG_DimWrite (
	&BG_LEN ; BG長さ
	&blPT   ; block挿入点
  /
	#DIMPT1 #DIMPT2
  )
	;;; BG長さ
	(setq #dimPT1 (polar &blPT 0.0 &BG_LEN))
	(setq #dimPT2 (polar #dimPT1 (dtr 90) 200))
	(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; 寸法記入
	;;; 奥行き
	(setq #dimPT1 (polar &blPT (dtr -90) CG_BG_T)) ; BG厚み
	(setq #dimPT2 (polar #dimPT1 (dtr 180) 200))
	(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; 寸法記入

	(princ)
);PK_BG_DimWrite

;;;<HOM>*************************************************************************
;;; <関数名>    : PKITOAPRICE
;;; <処理概要>  : 価格を文字列にする 1234000==>"1,234,000円"
;;; <戻り値>    : 文字列
;;; <作成>      : 2000.6.21 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PKITOAPRICE (
	&price ; 実数
  /
	#DUM #I #J #KOSU #PRICE #STR
  )
	(setq #dum " ")
	(setq #price (itoa (fix (+ &price 0.00001))))
	(setq #kosu (strlen #price))
	(setq #i #kosu)
	(setq #j 1)
	(repeat #kosu
		(setq #str (substr #price #i 1))
		(setq #dum (strcat #str #dum))
		(if (and (= (rem #j 3) 0) (/= #j #kosu)) ; 剰余
			(setq #dum (strcat "," #dum))
		);_if
		(setq #j (1+ #j))
		(setq #i (1- #i))
	)
	(strcat #dum "円")
);PKITOAPRICE

;;;<HOM>*************************************************************************
;;; <関数名>    : PKWTGroundPlanWAKU
;;; <処理概要>  : 枠をかく
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.20 YM
;;; <備考>      : 
;;;           LenX
;;;  O*-----------------+
;;;   |                 |TitY
;;; p1+-----------------+p2
;;;LenY                 |
;;;   |                 |
;;;   |                 |
;;;   +-----------------+
;;;*************************************************************************>MOH<
(defun PKWTGroundPlanWAKU (
	&origin ; 枠左上点
	&LenX   ; 枠幅
	&LenY   ; 枠高さ
	&TitY   ; ﾀｲﾄﾙ幅
	&HINBAN ; WT品番 or BG品番(文字)
	&PRICE  ; 金額(文字)
  /
	#ENDPT #P1 #P2 #STRANG #STRH #STRPT
  )
;;; 枠 作成
	(setq #endPT (strcat "@" (rtos &LenX) "," (rtos (- &LenY))))
	(command "._rectangle" &origin #endpt)
;;; ﾀｲﾄﾙ覧 作成
	(setq #p1 (list    (car &origin)        (+ (cadr &origin)(- &TitY))))
	(setq #p2 (list (+ (car &origin) &LenX) (+ (cadr &origin)(- &TitY))))
	(command "._line" #p1 #p2 "")

;;;	(command "._style" "standard" "ＭＳ 明朝" "" "" "" "" "")
	;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
	(command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
;;; ﾀｲﾄﾙ覧 品番記入
	(if &HINBAN
		(progn
			(setq #strPT (list (+ (car #p1) 200) (+ (cadr #p1) 50)))
			(setq #strH "100")
			(setq #strANG "0")
			(command "._TEXT" #strPT #strH #strANG &HINBAN)
		)
	);_if
;;; ﾀｲﾄﾙ覧 金額記入
	(if &PRICE
		(progn
			(setq #strPT (list (- (car #p2) 1000) (+ (cadr #p2) 50)))
			(setq #strH "100")
			(setq #strANG "0")
			(command "._TEXT" #strPT #strH #strANG &PRICE)
		)
	);_if

;;;	(command "._zoom" "e")
	(princ)
);PKWTGroundPlanWAKU

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetWT-ANA_Outline
;;; <処理概要>  : WT図形名を渡してWT外形+ｼﾝｸ,ｺﾝﾛ穴図形ﾌﾞﾛｯｸを
;;;               ～\tmp\temp[&no].dwg として保存
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.20 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PKGetWT-ANA_Outline (
	&WT     ; WT図形名
	&no     ; 最右ＷＴからの番号 0,1,2...
  /
	#ANG #BASEWT #EGAS_P5$ #ESNK_P$ #ESNK_P1$ #ESNK_P4$$ #GAS$$ #P1 #P2 #P3 #PT$ #RET$ #SNK$$ 
	#SS #TEIWT #XDWT$ #ZAICODE #ZAIF
  #iFILEDIA   ; システム変数 01/11/22 HN ADD
  )
	(setq #ss (ssadd))
	(setq #xdWT$ (CFGetXData &WT "G_WRKT"))
	(setq #ZaiCode (nth 2 #xdWT$)) ; 00/09/26 YM
	(setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
	(setq #baseWT (nth 32 #xdWT$)) ; WT左上点
	(setq #teiWT  (nth 38 #xdWT$)) ; WT底面図形

	(setq #ret$ (PKW_GetWorkTopAreaSym3	&WT))
;;;	#SNK$$ = (#enSNK #enSNKCAB #snkPen1 #snkPen4)
;;;	#GAS$$ = (#enGAS #enGASCAB #GasPen5)
;;; (#SNK$$ #GAS$$ #eWTR$ )
	(setq #SNK$$ (nth 0 #ret$))
	(setq #GAS$$ (nth 1 #ret$))
;;; 変数へ代入<ｼﾝｸ>
	(foreach #SNK$ #SNK$$
		(setq #eSNK_P1$ (append #eSNK_P1$ (list (nth 2 #SNK$)))) ; ｼﾝｸPMEN1ｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
		(setq #eSNK_P4$$ (append #eSNK_P4$$ (list (nth 3 #SNK$)))) ; ｼﾝｸPMEN4ｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
	)
	(setq #eSNK_P1$ (NilDel_List #eSNK_P1$ ))
	(setq #eSNK_P4$$ (NilDel_List #eSNK_P4$$ ))

;;; 変数へ代入<ｺﾝﾛ>
	(foreach #GAS$ #GAS$$
		(setq #eGAS_P5$ (append #eGAS_P5$ (list (nth 2 #GAS$)))) ; ｺﾝﾛPMEN5ｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
	)
	(setq #eGAS_P5$ (NilDel_List #eGAS_P5$ ))

	; 各ｼﾝｸの材質に応じたｼﾝｸ穴領域のﾘｽﾄを返す(ｼﾝｸ複数対応)
	;01/03/27 YM MOD ｼﾝｸ穴領域の属性をみて判断 STRAT
	(setq #eSNK_P$ (KPGetSinkANA #eSNK_P4$$ #ZaiF)) ; 各ｼﾝｸ毎のPMEN4ﾘｽﾄのﾘｽﾄ
	;01/03/27 YM MOD ｼﾝｸ穴領域の属性をみて判断 END

;;;01/03/27YM@	(cond ; 00/09/26 YM
;;;01/03/27YM@		((equal #ZaiF 1 0.1)
;;;01/03/27YM@			(setq #eSNK_P$ #eSNK_P1$) ; ｽﾃﾝﾚｽ
;;;01/03/27YM@		)
;;;01/03/27YM@		((equal #ZaiF 0 0.1)
;;;01/03/27YM@			(setq #eSNK_P$ #eSNK_P4$) ; 人工大理石
;;;01/03/27YM@		)
;;;01/03/27YM@		(T
;;;01/03/27YM@			(CFAlertMsg "\n『WT材質』の\"素材F\"が不正です。")(quit)
;;;01/03/27YM@		)
;;;01/03/27YM@	);_cond

	(ssadd #teiWT #ss)
	(foreach #eSNK_P #eSNK_P$
		(ssadd #eSNK_P #ss)
	)
	(foreach #eGAS_P5 #eGAS_P5$
		(ssadd #eGAS_P5  #ss)
	)

	;;; UCS定義
	(setq #pt$ (GetLWPolyLinePt #teiWT))    ; WT外形点列
	(setq #pt$ (GetPtSeries #baseWT #pt$))  ; #BASEPT を先頭に時計周り
	(setq #p1 (nth 0 #pt$))
	(setq #p2 (nth 1 #pt$))
	(setq #ang (angle #p1 #p2))
	(setq #p3 (polar #p1 (+ #ang (dtr 90)) 500))
	(command "._ucs" "3" #p1 #p2 #p3)
	(setq #baseWT (trans #baseWT 0 1))      ; ﾕｰｻﾞｰ座標系に変換

	;;; ﾌﾞﾛｯｸ保存
	(setq #iFILEDIA (getvar "FILEDIA")) ; 01/11/22 HN
	(setvar "FILEDIA" 0)
	(command "._wblock" (strcat CG_SYSPATH "tmp\\tempWT" &no ".dwg") "" #baseWT #ss "")
	(command "._oops") ; 図形復活
  (command "._ucs" "P")
	(setvar "FILEDIA" #iFILEDIA)
	(princ)
);PKGetWT-ANA_Outline

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetBG_Outline
;;; <処理概要>  : WT図形名を渡してWT外形+ｼﾝｸ,ｺﾝﾛ穴図形ﾌﾞﾛｯｸを
;;;               ～\tmp\temp[&no].dwg として保存
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.20 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PKGetBG_Outline (
	&BGtei ; BG図形名
	&WT    ; 関連WT
	&no    ; ﾌﾞﾛｯｸ番号 0,1,2...
  /
	#ANG #BASEWT #P1 #P2 #P3 #PT$ #SS #TEIWT #XDWT$ #BASEBG
  #iFILEDIA   ; システム変数 01/11/22 HN ADD
  )
	(setq #xdWT$ (CFGetXData &WT "G_WRKT"))
	(setq #baseWT (nth 32 #xdWT$)) ; WT左上点
	(setq #teiWT  (nth 38 #xdWT$)) ; WT底面図形

	(setq #ss (ssadd))
	(ssadd &BGtei #ss)

	;;; UCS定義
	(setq #pt$ (GetLWPolyLinePt #teiWT))    ; WT外形点列
	(setq #pt$ (GetPtSeries #baseWT #pt$))  ; #BASEPT を先頭に時計周り
	(setq #p1 (nth 0 #pt$))
	(setq #p2 (nth 1 #pt$))
	(setq #ang (angle #p1 #p2))
	(setq #p3 (polar #p1 (+ #ang (dtr 90)) 500))
	(command "._ucs" "3" #p1 #p2 #p3)
;;;	(setq #baseWT (trans #baseWT 0 1))      ; ﾕｰｻﾞｰ座標系に変換

	(setq #pt$ (GetLWPolyLinePt &BGtei))    ; BG外形点列
	(setq #baseBG (XminYmax #pt$))          ; 点列から ﾎﾟｲﾝﾄ座標(Xmin,Ymax)を返す
;;;	(setq #baseBG (trans #baseBG 0 1))      ; ﾕｰｻﾞｰ座標系に変換
	(setq #p1 (nth 0 #pt$))

	;;; ﾌﾞﾛｯｸ保存
  (setq #iFILEDIA (getvar "FILEDIA")) ; 01/11/22 HN ADD
	(setvar "FILEDIA" 0)
	(command "._wblock" (strcat CG_SYSPATH "tmp\\tempBG" &no ".dwg") "" #baseBG #ss "")
	(command "._oops") ; 図形復活
  (command "._ucs" "P")
	(setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD
	(princ)
);PKGetBG_Outline

;;;<HOM>*************************************************************************
;;; <関数名>    : XminYmax
;;; <処理概要>  : 点列から ﾎﾟｲﾝﾄ座標(Xmin,Ymax)を返す
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.21 YM
;;; <備考>      : ucs 3 の際中
;;;*************************************************************************>MOH<
(defun XminYmax (
	&pt$
  /
	#PT$ #X #XMIN #Y #YMAX
  )
	(setq #Xmin  1.0e+10)
	(setq #Ymax -1.0e+10)

	(foreach #pt &pt$
		(setq #pt (trans #pt 0 1)) ; ﾕｰｻﾞｰ座標系に変換
		(setq #x (car  #pt))
		(if (<= #x #Xmin)
			(setq #Xmin #x)
		);_if
		(setq #y (cadr #pt))
		(if (>= #y #Ymax)
			(setq #Ymax #y)
		);_if
	)
	(list #Xmin #Ymax)
);XminYmax

(princ)