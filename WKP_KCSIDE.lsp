;<HOM>*************************************************************************
; <関数名>    : PKP_SidePanel
; <処理概要>  : サイドパネルを配置する
; <戻り値>    :
; <作成日>    : 1999-10-10
; <備考>      :
;*************************************************************************>MOH<
(defun PKP_SidePanel (
;;;    &type  ;(STR)サイドパネルの種類 (N,A,B,C,D) ;03/12/30 YM 引数廃止(ミカド版にあわせる)
    /
    #base$ #gasu$ #appa$ #ss #i #en #xd$ #uper-en$ #base-en$ #lst$
    #skk$
  )
  (CFOutStateLog 1 5 "//// SKPosSidePanel ////")
  (CFOutStateLog 1 5 "--------------------引数 START-----------------")
  (CFOutStateLog 1 5 "サイドパネルの種類                : ")(CFOutStateLog 1 5 &type)
  (CFOutStateLog 1 5 "--------------------引数 END-----------------")
;;;  (CFOutLog 1 nil (strcat "  +サイドパネルの種類: " &type))

  (regapp "G_SIDEP")

	(WebOutLog "++++++++++++++++++++++++++++")
	(WebOutLog "*error*関数") ; 02/09/11 YM ADD
	(WebOutLog *error*)       ; 02/09/11 YM ADD
	(WebOutLog "++++++++++++++++++++++++++++")

;;;// ベースキャビネットを検索し、ベースキャビネットの高さおよび奥行きを取得
;;;// アッパーキャビネットを検索し、アッパーキャビネットの高さおよび奥行きを取得
;;;
;;;// カウンタートップの高さを求めておく
;;;        LIST : 1.ワークトップの最上部の高さ
;;;             : 2.ワークトップの奥行き１
;;;             : 3.ワークトップの奥行き２
;;;  (PKP_GetWorkTopHeight)

  (if (/= CG_SidePanelCode "N")
    (progn
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_LSYM"))
        ;// 性格CODEでベースキャビ、アッパーキャビの判定を行う
        (setq #skk$ (CFGetSeikakuToSKKCode (nth 9 #xd$) nil))

        (if (and (= CG_SKK_ONE_CAB (nth 0 #skk$)) (= CG_SKK_TWO_UPP (nth 1 #skk$)))
          (setq #uper-en$ (cons #en #uper-en$))
        ;else
          (if (and (= CG_SKK_ONE_CAB (nth 0 #skk$)) (= CG_SKK_TWO_BAS (nth 1 #skk$)))
            (setq #base-en$ (cons #en #base-en$))
          )
        )
        (setq #i (1+ #i))
      )
      (setq #lst$ (SKP_GetSidePanelPos #base-en$ #uper-en$ CG_SidePanelCode))
      (cond
        ((= CG_W2Code "Z")     ;Ｉ型
          (PKP_PosSidePanelByKata "I" CG_SidePanelCode #lst$)
        )
        (T                     ;Ｌ型
          (PKP_PosSidePanelByKata "L" CG_SidePanelCode #lst$)
        )
      )
    )
  );_if

	(WebOutLog "ｻｲﾄﾞﾊﾟﾈﾙを取付けました"); 02/09/04 YM ADD ﾛｸﾞ出力追加
	(princ)
);PKP_SidePanel

;<HOM>*************************************************************************
; <関数名>    : PKP_PosSidePanelByKata
; <処理概要>  : サイドパネルを配置する
; <戻り値>    :
; <作成日>    : 1999-10-10
; <備考>      : 02/12/30 NAS専用ﾛｼﾞｯｸ追加
;*************************************************************************>MOH<
(defun PKP_PosSidePanelByKata (
    &kata  ;(STR)型（Ｌ、Ｉ）
    &type  ;(STR)サイドパネルの種類 (N,A,B,C,D)
    &info$ ;(LIST)端の部材の基点と図形名のリスト
           ;       ((最左ベース図形 座標)
           ;        (最右ベース図形 座標)
           ;        (最左アッパー図形 座標)
           ;        (最右アッパー図形 座標)
           ;        (最下ベース図形 座標)
           ;        (最下アッパー図形 座標)
           ;       )
    /
    #filer-h #info$ #en #pt #xd$ #w #d #h #panel$ #fname$ #hin #sql #fig$ #qry$ #msg
		#ANG #PW
#DRCOL$ #DRCOL$$ #FIGL$ #FIGR$ #FNAMEL$ #FNAMER$ #HINLR #LR-FLAG #QRYL$ #QRYR$ ; 02/12/30 YM ADD
#HINBAN #I #LR-FLAG-BASE #LR-FLAG-UPPER #LR_EXIST #PW-BASE #PW-UPPER ;03/12/03 YM ADD
  )
  (CFOutStateLog 1 5 "//// SKPosSidePanel ////")
  (CFOutStateLog 1 5 "--------------------引数 START-----------------")
  (CFOutStateLog 1 5 "型                      : ")(CFOutStateLog 1 5 &kata)
  (CFOutStateLog 1 5 "サイドパネル種類        : ")(CFOutStateLog 1 5 &type)
  (CFOutStateLog 1 5 "端の部材の基点と図形名  : ")(CFOutStateLog 1 5 &info$)
  (CFOutStateLog 1 5 "--------------------引数 END-------------------")

	; 02/09/04 YM ADD ﾛｸﾞ出力追加
	(WebOutLog "ｻｲﾄﾞﾊﾟﾈﾙ取り付け処理(PKP_PosSidePanelByKata)")
	(WebOutLog "ｻｲﾄﾞﾊﾟﾈﾙ品番=")
	(WebOutLog CG_SidePanel$)
	(WebOutLog " ")
	; 02/09/04 YM ADD ﾛｸﾞ出力追加

	(WebOutLog "++++++++++++++++++++++++++++")
	(WebOutLog "*error*関数") ; 02/09/11 YM ADD
	(WebOutLog *error*)       ; 02/09/11 YM ADD
	(WebOutLog "++++++++++++++++++++++++++++")

	
	; 02/12/30 YM ADD-S
;;;	(setq CG_SidePanelLR$ nil)
	(setq #LR-flag nil)
	(setq #fnameR$ nil)
	(setq #fnameL$ nil)
	(setq #fname$  nil)
	; ｻｲﾄﾞﾊﾟﾈﾙにLRが必要かどうか【扉ｶﾗ】で判定 ﾐﾗﾉの場合同じ機種名でK,L/Rあり→廃止 L/Rあり

;03/12/3 YM MOD-S 仕組み変更
;;;元々ｿｰｽはｻｲﾄﾞﾊﾟﾈﾙにL/Rがないことが前提
;;;→扉(ｾｽﾊﾟﾐﾗﾉ)によってL/Rがあるｹｰｽに対応
;;;([扉COLOR]に「ﾊﾟﾈﾙLR」ﾌｨｰﾙﾄﾞ追加)
;;;→WT高さ,天井高さによってｻｲﾄﾞﾊﾟﾈﾙの機種名が変わるのに対応
;;;→この度DIPLOAのｻｲﾄﾞﾊﾟﾈﾙは最初からL/Rがあり、扉(F*)によって
;;;機種名が変わり、しかもL/Rなし→ありになるｹｰｽがでてきたため
;;;[ﾌﾟﾗ管OP]からのOPTID引き当てはそのままで[ﾌﾟﾗ構OP]の検索を廃止
;;;[ｻｲﾄﾞﾊﾟﾈﾙ]ﾃｰﾌﾞﾙ追加
;;;OPTID+扉ｼﾘ記号をKEYにして品番+LR有無の情報を取得する
;;;([扉COLOR]「ﾊﾟﾈﾙLR」使用しない)
;;;=======================================================
;;;[ｻｲﾄﾞﾊﾟﾈﾙ]
;;;OPTID 扉シリ記号 扉シリ名称   RECNO 品番名称      LR有無
;;;3     G          グロスライン 1     CPS240X66@@KF 0
;;;4     G          グロスライン 1     CPS91X66@@KF  0
;;;4     G          グロスライン 2     CPS50X37@@KF  0
;;;...
;;;3     N          ミラノ       1     CPS240X66@@KF 0
;;;4     N          ミラノ       1     CPS91X66@@%F  1
;;;4     N          ミラノ       2     CPS50X37@@%F  1
;;;...
;;;=======================================================



	(setq #i 0);i=0ﾍﾞｰｽ,i=1ｱｯﾊﾟｰ
	(setq #LR-flag-base nil)
	(setq #LR-flag-upper nil)

  (foreach #hin CG_SidePanel$
		(setq #hinban   (car #hin))  ;品番
		(setq #LR_exist (cadr #hin)) ;L/R有無

		(if (equal #LR_exist 1.0 0.001)
			(progn
				;Rﾀｲﾌﾟ
		    (setq #qryR$
		      (CFGetDBSQLHinbanTable "品番図形" #hinban
		         (list
		           (list "品番名称" #hinban 'STR)
		           (list "LR区分" "R" 'STR)
		         )
		      )
		    )
				;Lﾀｲﾌﾟ
		    (setq #qryL$
		      (CFGetDBSQLHinbanTable "品番図形" #hinban
		         (list
		           (list "品番名称" #hinban 'STR)
		           (list "LR区分" "L" 'STR)
		         )
		      )
		    )
				;寸法Wを求める
				(if (and #qryL$ (= (length #qryL$) 1))
					(if (= #i 0)
			  		(setq #pw-base (nth 4 (car #qryL$)))
						;else
						(setq #pw-upper (nth 4 (car #qryL$)))
					);_if
				);_if

				;Rﾀｲﾌﾟ-----------------------------------------------
				(if (and #qryR$ (= (length #qryR$) 1))
					(progn
						(setq #qryR$ (car #qryR$))
		    		(setq #figR$ (list (nth 7 #qryR$) (nth 1 #qryR$)))
					)
					;else
					(setq #figR$ nil)
				);_if
				(if #figR$
		    	(setq #fnameR$ (append #fnameR$ (list #figR$))); (図形ID,LR)のﾘｽﾄ
				);_if

				;Lﾀｲﾌﾟ-----------------------------------------------
				(if (and #qryL$ (= (length #qryL$) 1))
					(progn
						(setq #qryL$ (car #qryL$))
		    		(setq #figL$ (list (nth 7 #qryL$) (nth 1 #qryL$)))
					)
					;else
					(setq #figL$ nil)
				);_if
				(if #figL$
		    	(setq #fnameL$ (append #fnameL$ (list #figL$))); (図形ID,LR)のﾘｽﾄ
				);_if

				;Zﾀｲﾌﾟ=nil ------------------------------------------
				(setq #fig$ nil)
	    	(setq #fname$ (append #fname$ (list #fig$))); (図形ID,LR)のﾘｽﾄ

				;ｻｲﾄﾞﾊﾟﾈﾙL/Rﾌﾗｸﾞ
				(if (= #i 0)
					(setq #LR-flag-base T)
				);_if
				(if (= #i 1)
					(setq #LR-flag-upper T)
				);_if

			)
			;else
			(progn
		    (setq #qry$
		      (CFGetDBSQLHinbanTable "品番図形" #hinban
		         (list
		           (list "品番名称" #hinban 'STR)
		           (list "LR区分" "Z" 'STR)
		         )
		      )
		    )
				;寸法Wを求める
				(if (and #qry$ (= (length #qry$) 1))
					(if (= #i 0)
			  		(setq #pw-base (nth 4 (car #qry$)))
						;else
						(setq #pw-upper (nth 4 (car #qry$)))
					);_if
				);_if

				;Zﾀｲﾌﾟ
				(if (and #qry$ (= (length #qry$) 1))
					(progn
						(setq #qry$ (car #qry$))
		    		(setq #fig$ (list (nth 7 #qry$) (nth 1 #qry$)))
					)
					;else
					(setq #fig$ nil)
				);_if
				(if #fig$
		    	(setq #fname$ (append #fname$ (list #fig$))); (図形ID,LR)のﾘｽﾄ
				);_if

				;L/Rﾀｲﾌﾟ=nil
				(setq #figL$ nil)
				(setq #figR$ nil)
	    	(setq #fnameL$ (append #fnameL$ (list #figL$))); (図形ID,LR)のﾘｽﾄ
	    	(setq #fnameR$ (append #fnameR$ (list #figR$))); (図形ID,LR)のﾘｽﾄ
			)
		);_if
		(setq #i (1+ #i));i=0ﾍﾞｰｽ,i=1ｱｯﾊﾟｰ
  );foreach

  (regapp "G_PTEN")


  ;// ベース（シンク側）
  (if (or (= &type "A") (= &type "B") (= &type "C") (= &type "D"))     ;片側に取り付け
    (progn
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I")  (setq #info$ (nth 1 &info$)))
            ((= &kata "L")  (setq #info$ (nth 1 &info$)))
            ((= &kata "WL") (setq #info$ (nth 4 &info$)))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I")  (setq #info$ (nth 0 &info$)))
            ((= &kata "L")  (setq #info$ (nth 0 &info$)))
            ((= &kata "WL") (setq #info$ (nth 4 &info$)))
          )
        )
      )
      (setq #en  (car #info$))
      (setq #pt  (cadr #info$))
      (setq #xd$ (CFGetXData #en "G_SYM"))
      (setq #w   (nth 3 #xd$))
      (setq #xd$ (CFGetXData #en "G_LSYM"))
      (setq #ang (rtd (nth 2 #xd$)))
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I") (setq #pt (list (+ (car #pt) #w) (cadr #pt) 0.0)))
            ((= &kata "L") (setq #pt (list (+ (car #pt) #w) (cadr #pt) 0.0)))
            ((= &kata "WL")(setq #pt (list (car #pt) (- (cadr #pt) #w) 0.0)))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I") (setq #pt (list (- (car #pt) #pw-base) (cadr #pt) 0.0)))
            ((= &kata "L") (setq #pt (list (- (car #pt) #pw-base) (cadr #pt) 0.0)))
            ((= &kata "WL")(setq #pt (list (car #pt) (- (cadr #pt) #pw-base) 0.0)))
          )
        )
      )
      ;// サイドパネルを生成する

			; 03/04/10 YM MOD-S
			(if (and #LR-flag-base (or (= &type "C") (= &type "D"))) ; 一体か分離かで場合分け必要
				(if (= (nth 11 CG_GLOBAL$) "R") ; 03/04/10 YM ADD 勝手による場合分け
	      	(PKP_MakeSidePanel (car #fnameR$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP1") ; LRありの場合(右勝手)
				;else
	      	(PKP_MakeSidePanel (car #fnameL$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP1") ; LRありの場合(左勝手)
				);_if
			;else
	      (PKP_MakeSidePanel (car #fname$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP1")    ; "K"の場合
			);_if

			; 03/04/10 YM ADD-E

    )
  );_if
  ;// ベース（ガス側）
  (if (or (= &type "B") (= &type "D"))     ;両側に取り付け
    (progn
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I")  (setq #info$ (nth 0 &info$)))
            ((= &kata "L")  (setq #info$ (nth 4 &info$)))
            ((= &kata "WL") (setq #info$ (nth 0 &info$)))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I")  (setq #info$ (nth 1 &info$)))
            ((= &kata "L")  (setq #info$ (nth 4 &info$)))
            ((= &kata "WL") (setq #info$ (nth 1 &info$)))
          )
        )
      )
      ;(dpr '#info$)
      (setq #en (car #info$))
      (setq #pt (cadr #info$))
      (setq #xd$ (CFGetXData #en "G_SYM"))
      (setq #w (nth 3 #xd$))
      (setq #xd$ (CFGetXData #en "G_LSYM"))
      (setq #ang (rtd (nth 2 #xd$)))
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I") (setq #pt (list (- (car #pt) #pw-base) (cadr #pt) 0.0)))
            ((= &kata "L") (setq #pt (list (car #pt) (- (cadr #pt) #pw-base) 0.0)))
            ((= &kata "WL")(setq #pt (list (- (car #pt) #pw-base) (cadr #pt) 0.0)))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I") (setq #pt (list (+ (car #pt) #w) (cadr #pt) 0.0)))
            ((= &kata "L") (setq #pt (list (car #pt) (- (cadr #pt) #w) 0.0)))
            ((= &kata "WL")(setq #pt (list (+ (car #pt) #w) (cadr #pt) 0.0)))
          )
        )
      )
      ;// サイドパネルを生成する

			; 03/04/10 YM MOD-S
			(if (and #LR-flag-base (or (= &type "C") (= &type "D"))) ; 一体か分離かで場合分け必要
				(if (= (nth 11 CG_GLOBAL$) "R") ; 03/04/10 YM ADD 勝手による場合分け
	      	(PKP_MakeSidePanel (car #fnameL$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP2") ; LRありの場合(右勝手)
				;else
	      	(PKP_MakeSidePanel (car #fnameR$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP2") ; LRありの場合(左勝手)
				);_if
			;else
	      (PKP_MakeSidePanel (car #fname$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP2")    ; "K"の場合
			);_if

			; 03/04/10 YM ADD-E
    )
  );_if
  ;// アッパー（シンク側）
  (if (or (= &type "C") (= &type "D"))     ;片側に取り付け（ベース、アッパー分離）
    (progn
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I")  (setq #info$ (nth 3 &info$)))
            ((= &kata "L")  (setq #info$ (nth 3 &info$)))
            ((= &kata "WL") (setq #info$ (nth 5 &info$)))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I")  (setq #info$ (nth 2 &info$)))
            ((= &kata "L")  (setq #info$ (nth 2 &info$)))
            ((= &kata "WL") (setq #info$ (nth 5 &info$)))
          )
        )
      )
      (setq #en (car #info$))
      (setq #pt (cadr #info$))
      (setq #xd$ (CFGetXData #en "G_SYM"))
      (setq #w (nth 3 #xd$))
      (setq #xd$ (CFGetXData #en "G_LSYM"))
      (setq #ang (rtd (nth 2 #xd$)))
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I") (setq #pt (list (+ (car #pt) #w) (cadr #pt))))
            ((= &kata "L") (setq #pt (list (+ (car #pt) #w) (cadr #pt))))
            ((= &kata "WL")(setq #pt (list (car #pt) (- (cadr #pt) #w))))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I") (setq #pt (list (- (car #pt) #pw-upper) (cadr #pt))))
            ((= &kata "L") (setq #pt (list (- (car #pt) #pw-upper) (cadr #pt))))
            ((= &kata "WL")(setq #pt (list (car #pt) (- (cadr #pt) #pw-upper))))
          )
        )
      )
      ;// サイドパネルを生成する

			; 03/04/10 YM MOD-S
			(if (and #LR-flag-upper (or (= &type "C") (= &type "D"))) ; 一体か分離かで場合分け必要
				(if (= (nth 11 CG_GLOBAL$) "R") ; 03/04/10 YM ADD 勝手による場合分け
	      	(PKP_MakeSidePanel (cadr #fnameR$) (car (cadr CG_SidePanel$)) (list (car #pt) (cadr #pt) CG_CeilHeight) #ang #en "SIDEP3") ; LRありの場合(右勝手)
				;else
	      	(PKP_MakeSidePanel (cadr #fnameL$) (car (cadr CG_SidePanel$)) (list (car #pt) (cadr #pt) CG_CeilHeight) #ang #en "SIDEP3") ; LRありの場合(左勝手)
				);_if
			;else
	      (PKP_MakeSidePanel (cadr #fname$) (car (cadr CG_SidePanel$)) (list (car #pt) (cadr #pt) CG_CeilHeight) #ang #en "SIDEP3")    ; "K"の場合
			);_if

			; 03/04/10 YM ADD-E

    )
  );_if

	; 02/12/30 YM ADD-S
	(setq CG_SidePanel$ nil)
;;;	(setq CG_SidePanelLR$ nil)
;;;	(setq #LR-flag nil)
	; 02/12/30 YM ADD-E

  (princ)
)
;PKP_PosSidePanelByKata

;<HOM>*************************************************************************
; <関数名>    : PKP_MakeSidePanel
; <処理概要>  : 配置情報からサイドパネルを作成する
; <戻り値>    :
; <作成日>    : 1999-10-10
; <備考>      :
;*************************************************************************>MOH<
(defun PKP_MakeSidePanel (
    &file         ;(LIST) (挿入ファイル名 LR区分)
    &hin          ;(STR) 品番名称
    &pt           ;(LIST)配置点
    &ang          ;(REAL)配置角度
    &en           ;(ENAME)取り付けるキャビネットの図形名
    &grp          ;(STR)グループ名
    /
    #sym #xd$ #w #d #h
    #listCode #sql #nn #seikaku
    #lst$
    #CounterH #CounterD1 #CounterD2
    #qry$
		#FIL-H #LR #MSG
  )

  (CFOutStateLog 1 5 "//// PKP_MakeSidePanel ////")
  (CFOutStateLog 1 5 "--------------------引数 START-----------------")
  (CFOutStateLog 1 5 "挿入ファイル名   : ")(CFOutStateLog 1 5 &file)
  (CFOutStateLog 1 5 "品番名称         : ")(CFOutStateLog 1 5 &hin)
  (CFOutStateLog 1 5 "配置点           : ")(CFOutStateLog 1 5 &pt)
  (CFOutStateLog 1 5 "配置角度         : ")(CFOutStateLog 1 5 &ang)
  (CFOutStateLog 1 5 "図形名           : ")(CFOutStateLog 1 5 &en)
  (CFOutStateLog 1 5 "グループ名       : ")(CFOutStateLog 1 5 &grp)
  (CFOutStateLog 1 5 "--------------------引数 END-------------------")

  (setq #lr (cadr &file))
  (setq &file (car &file))
;;;  (CFOutLog 1 nil (strcat "  +挿入ファイル名: " &file))
;;;  (CFOutLog 1 nil (strcat "  +LR区分: " #lr))
;;;  (CFOutLog 1 nil (strcat "  +品番名称: "       &hin))
  ;-----------------------------------------
  ; サイドパネルの伸縮量を求める
  ;-----------------------------------------
  (setq #xd$ (CFGetXData &en "G_SYM"))
  (setq #w   (nth 3 #xd$))
  (setq #d   (nth 4 #xd$))
  (setq #h   (nth 5 #xd$))

  ;// ワークトップの情報を取得する
  (setq #lst$ (PKP_GetWorkTopHeight))
  (setq #CounterH  (nth 0 #lst$))
  (setq #CounterD1 (nth 1 #lst$))
  (setq #CounterD2 (nth 2 #lst$))
  (cond
    ;// ベースの伸縮値
    ((or (= &grp "SIDEP1") (= &grp "SIDEP2"))
      (cond
        ((or (= CG_SidePanelCode "A") (= CG_SidePanelCode "B"))
          (setq #h CG_CeilHeight)
        )
        ((or (= CG_SidePanelCode "C") (= CG_SidePanelCode "D"))
          (setq #h (+ #CounterH CG_PANEL_OFFSET))
        )
      )
      ;// サイドパネルの奥行きを設定する
;;;@YM@      (if (and (= CG_Type2Code "W") (= &grp "SIDEP1"))
;;;@YM@        (setq #d (+ #CounterD1 CG_PANEL_OFFSET))
        (setq #d (+ #CounterD2 CG_PANEL_OFFSET))
;;;@YM@      )
    )
    ;// アッパーの伸縮値
    (T
      (setq #fil-h (- CG_CeilHeight CG_UpCabHeight))
      (setq #h (+ #h #fil-h CG_PANEL_OFFSET))
      (setq #d (+ #d CG_PANEL_OFFSET))
    )
  )
  ;-----------------------------------------
  ; 性格CODEを取得
  ;-----------------------------------------
  (setq #qry$
;;;    (car ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
			(CFGetDBSQLHinbanTable
            "品番基本"
            &hin
            (list
;;;              (list "品番名称" "NODATA" 'STR) ; エラーテスト
              (list "品番名称" &hin 'STR)
            )
       )
;;;    ) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
  );_(setq

  (if (= #qry$ nil)
    (progn
			(setq #msg (strcat "『品番基本』にレコードがありません.\nPKP_MakeSidePanel"))
			(CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  )
	(CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
	(CFOutStateLog 1 1 #qry$)

	(if (= (length #qry$) 1) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
		(progn
	  	(setq #qry$ (car #qry$))
		)
    (progn ; 複数ﾋｯﾄしたときはｴﾗｰ
			(setq #msg (strcat "『品番基本』にレコードが複数ありました.\nPKP_MakeSidePanel"))
			(CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
	);_if                    ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD

  (setq #seikaku (nth 3 #qry$)); @YM@ OK!
;;;  (if (/= #qry$ nil)
;;;;;;    (CFOutLog 1 nil (strcat "  +性格CODE: " (rtos #seikaku)))
;;;  )
  ;-----------------------------------------
  ;サイドパネルを挿入する
  ;-----------------------------------------
	; 02/09/04 YM ADD ﾛｸﾞ出力追加
	(WebOutLog "ｻｲﾄﾞﾊﾟﾈﾙを挿入します(PKP_MakeSidePanel)")

  (command "_insert" (strcat CG_MSTDWGPATH &file) &pt 1 1 &ang)
  (command "_explode" (entlast))                    ;インサート図形分解
  ;// 分解した選択セットで名前のないグループを作成する
  (SKMkGroup (ssget "P"))

  ;// 基準図形を取得する
  (setq #sym (SKC_GetSymInGroup (entlast)))

  ;-----------------------------------------
  ;拡張データの付加
  ;-----------------------------------------
  (CFSetXData #sym "G_LSYM"
    (list
      &file           ;1 :本体図形ID      :『品番図形』.図形ID
      &pt             ;2 :挿入点          :配置基点
      (dtr &ang)      ;3 :回転角度        :配置回転角度
      CG_Kcode        ;4 :工種記号        :CG_Kcode      ; 01/10/26 YM ADD ""--> CG_Kcode
      CG_SeriesCode   ;5 :SERIES記号    :CG_SeriesCode ; 01/10/26 YM ADD ""--> CG_SeriesCode
      &hin            ;6 :品番名称        :『品番図形』.品番名称
      #lr             ;7 :L/R区分         :『品番図形』.部材L/R区分
      ""              ;8 :扉図形ID        :
      ""              ;9 :扉開き図形ID    :
      (fix #seikaku)  ;10:性格CODE      :『品番基本』.性格CODE
      0               ;11:複合フラグ      :０固定（単独部材）
      0               ;12:配置順番号      :配置順番号(1～)
      0               ;13:用途番号        :『品番図形』.用途番号
      0               ;14:寸法Ｈ          :『品番図形』.寸法Ｈ
      0               ;15:断面指示の有無  :断面指示の有無
    )
  )
  (setq #xd$ (CFGetXData #sym "G_SYM"))
  (CFSetXData #sym "G_SYM"
    (list
      (nth 0 #xd$)    ;シンボル名称
      (nth 1 #xd$)    ;コメント１
      (nth 2 #xd$)    ;コメント２
      (nth 3 #xd$)   ;シンボル基準値Ｗ
      (nth 4 #xd$)   ;シンボル基準値Ｄ
      (nth 5 #xd$)   ;シンボル基準値Ｈ
      (nth 6 #xd$)    ;シンボル取付け高さ
      (nth 7 #xd$)    ;入力方法
      (nth 8 #xd$)    ;Ｗ方向フラグ
      (nth 9 #xd$)    ;Ｄ方向フラグ
      (nth 10 #xd$)   ;Ｈ方向フラグ
      (nth 11 #xd$)   ;伸縮フラグＷ
      #d              ;伸縮フラグＤ
      #h              ;伸縮フラグＨ
      (nth 14 #xd$)   ;ブレークライン数Ｗ
      (nth 15 #xd$)   ;ブレークライン数Ｄ
      (nth 16 #xd$)   ;ブレークライン数Ｈ
    )
  )
)
;PKP_MakeSidePanel

;<HOM>*************************************************************************
; <関数名>    : SKP_GetSidePanelPos
; <処理概要>  : サイドパネルの配置情報を取得する
; <戻り値>    :
;             : (LIST)端の部材の基点と図形名のリスト
;                  ((最左ベース図形 座標)
;                   (最右ベース図形 座標)
;                   (最左アッパー図形 座標)
;                   (最右アッパー図形 座標)
;                   (最下ベース図形 座標)
;                   (最下アッパー図形 座標)
;                  )
; <作成日>    : 1999-10-10
; <備考>      :
;*************************************************************************>MOH<
(defun SKP_GetSidePanelPos (
    &base-en$     ;(LIST)ベースキャビネット図形のリスト
    &uper-en$     ;(LIST)アッパーキャビネット図形のリスト
    &type         ;(STR)サイドパネルの種類 (N,A,B,C,D)
    /
    #i #maxpt1 #minpt1 #maxpt2 #minpt2 
		#minypt #en #eg #pt #maxen1 #minen1 
		#minypt1 #minyen1 #maxen2 #minen2 #minyen
		#MINYEN2 #MINYPT2
  )
  (CFOutStateLog 1 5 "//// SKP_GetSidePanelPos ////")
  (CFOutStateLog 1 5 "--------------------引数 START-----------------")
  (CFOutStateLog 1 5 "ベースキャビネット図形    : ")(CFOutStateLog 1 5 &base-en$)
  (CFOutStateLog 1 5 "アッパーキャビネット図形  : ")(CFOutStateLog 1 5 &uper-en$)
  (CFOutStateLog 1 5 "サイドパネルの種類        : ")(CFOutStateLog 1 5 &type)
  (CFOutStateLog 1 5 "--------------------引数 END-------------------")

  (setq #i 0)

  (setq #maxpt1 (list -10000 -10000))
  (setq #minpt1 (list 10000 -10000))
  (setq #maxpt2 (list -1000 -1000))
  (setq #minpt2 (list 10000 -10000))
  (setq #minypt1 (list -10000 10000))
  (setq #minypt2 (list -10000 10000))
  (foreach #en &base-en$
    (setq #eg (entget #en))
    (setq #pt (cdr (assoc 10 #eg)))
    
    (if (< (car #maxpt1) (car #pt))
      (progn
        (setq #maxpt1 #pt)
        (setq #maxen1 #en)
      )
    )
    (if (> (car #minpt1) (car #pt))
      (progn
        (setq #minpt1 #pt)
        (setq #minen1 #en)
      )
    )
    (if (> (cadr #minypt1) (cadr #pt))
      (progn
        (setq #minypt1 #pt)
        (setq #minyen1 #en)
      )
    )
    (setq #i (1+ #i))
  )
  (foreach #en &uper-en$
    (setq #eg (entget #en))
    (setq #pt (cdr (assoc 10 #eg)))

    (if (< (car #maxpt2) (car #pt))
      (progn
        (setq #maxpt2 #pt)
        (setq #maxen2 #en)
      )
    )
    (if (> (car #minpt2) (car #pt))
      (progn
        (setq #minpt2 #pt)
        (setq #minen2 #en)
      )
    )
    (if (> (cadr #minypt2) (cadr #pt))
      (progn
        (setq #minypt2 #pt)
        (setq #minyen2 #en)
      )
    )
    (setq #i (1+ #i))
  )
  ;// 結果を返す
  (list (list #minen1 #minpt1)
        (list #maxen1 #maxpt1)
        (list #minen2 #minpt2)
        (list #maxen2 #maxpt2)
        (list #minyen1 #minypt1)
        (list #minyen2 #minypt2)
  )
)
;SKP_GetSidePanelPos

;<HOM>*************************************************************************
; <関数名>    : PKP_GetWorkTopHeight
; <処理概要>  : カウンターの最上部の高さを求める
; <戻り値>    :
;        LIST : 1.ワークトップの最上部の高さ
;             : 2.ワークトップの奥行き１
;             : 3.ワークトップの奥行き２
; <作成日>    : 01/07/11 YM MOD
; <備考>      : 旧型WT用-->新型WT用に再作成
;*************************************************************************>MOH<
(defun PKP_GetWorkTopHeight (
    /
    #ss #xd$ #h
    #en
    #d1 #d2
  )
	(CFOutStateLog 1 1 " ")
	(CFOutStateLog 1 1 "//// PKP_GetWorkTopHeight ////")
	(CFOutStateLog 1 1 " ")

  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (= #ss nil)
    (progn
      (CFOutStateLog 0 5 "PKP_GetWorkTopHeight:ワークトップがありません。")
    )
    (progn
      (setq #xd$ (CFGetXData (ssname #ss 0) "G_WRKT"))
			; 下端取り付け高さ、カウンター厚さ、バックガード高さ
      (setq #h (+ (nth 8 #xd$) (nth 10 #xd$) (nth 12 #xd$)))

      (setq #dep$ (nth 57 #xd$)) ; WT奥行きﾘｽﾄ dep1,dep2(ｽﾃﾝﾚｽL型)
      (setq #d1 (car  #dep$))
      (setq #d2 #d1) ; 01/07/11 YM ??? 奥行き2とは？
;;;			(if (< 0.1 #d2)
;;;				nil
;;;				(setq #d2 nil)
;;;			);_if
      (CFOutStateLog 1 5 (strcat "PKP_GetWorkTopHeight:カウンター最上部高さ=" (rtos #h)))
    )
  )
  (list #h #d1 #d2)
);PKP_GetWorkTopHeight

;;;01/07/11YM@;<HOM>*************************************************************************
;;;01/07/11YM@; <関数名>    : SKP_GetWorkTopHeight
;;;01/07/11YM@; <処理概要>  : カウンターの最上部の高さを求める
;;;01/07/11YM@; <戻り値>    :
;;;01/07/11YM@;        LIST : 1.ワークトップの最上部の高さ
;;;01/07/11YM@;             : 2.ワークトップの奥行き１
;;;01/07/11YM@;             : 3.ワークトップの奥行き２
;;;01/07/11YM@; <作成日>    : 1999-10-10
;;;01/07/11YM@; <備考>      :
;;;01/07/11YM@;*************************************************************************>MOH<
;;;01/07/11YM@(defun SKP_GetWorkTopHeight (
;;;01/07/11YM@    /
;;;01/07/11YM@    #ss #xd$ #h
;;;01/07/11YM@    #en
;;;01/07/11YM@    #d1 #d2
;;;01/07/11YM@  )
;;;01/07/11YM@	(CFOutStateLog 1 1 " ")
;;;01/07/11YM@	(CFOutStateLog 1 1 "//// SKP_GetWorkTopHeight ////")
;;;01/07/11YM@	(CFOutStateLog 1 1 " ")
;;;01/07/11YM@
;;;01/07/11YM@  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
;;;01/07/11YM@  (if (= #ss nil)
;;;01/07/11YM@    (progn
;;;01/07/11YM@      (CFOutStateLog 0 5 "SKP_GetWorkTopHeight:ワークトップがありません。")
;;;01/07/11YM@    )
;;;01/07/11YM@  ;else
;;;01/07/11YM@    (progn
;;;01/07/11YM@      (setq #xd$ (CFGetXData (ssname #ss 0) "G_WRKT"))
;;;01/07/11YM@;;; 下端取り付け高さ、カウンター厚さ、バックガード高さ
;;;01/07/11YM@      (setq #h (+ (nth 8 #xd$) (nth 10 #xd$) (nth 12 #xd$)))
;;;01/07/11YM@      (setq #en (nth 28 #xd$)) ; WT側面図形ハンドル
;;;01/07/11YM@      (setq #d1 (cadr (CFGetXData #en "G_SIDE")))
;;;01/07/11YM@      (if (/= "" (nth 29 #xd$)); カット底面図形ハンドル
;;;01/07/11YM@        (progn
;;;01/07/11YM@          (setq #en (nth 29 #xd$))
;;;01/07/11YM@          (setq #d2 (cadr (CFGetXData #en "G_SIDE")))
;;;01/07/11YM@        )
;;;01/07/11YM@        (setq #d2 nil)
;;;01/07/11YM@      )
;;;01/07/11YM@      (CFOutStateLog 1 5 (strcat "SKP_GetWorkTopHeight:カウンター最上部高さ=" (rtos #h)))
;;;01/07/11YM@    )
;;;01/07/11YM@  )
;;;01/07/11YM@  (list #h #d1 #d2)
;;;01/07/11YM@)
;;;01/07/11YM@;SKP_GetWorkTopHeight

;<HOM>*************************************************************************
; <関数名>    : SDP_PosSidePanel
; <処理概要>  : サイドパネルを配置する
; <戻り値>    :
; <作成日>    : 1999-10-10
; <備考>      :
;*************************************************************************>MOH<
(defun SDP_PosSidePanel (
    &type  ;(STR)サイドパネルの種類 (N,R,L,T or B)
    /
    #base$ #gasu$ #appa$ #ss #i #en #xd$ #uper-en$ #base-en$ #lst$
		#SKK$
  )
  (CFOutStateLog 1 5 "//// SKPosSidePanel ////")
  (CFOutStateLog 1 5 "--------------------引数 START-----------------")
  (CFOutStateLog 1 5 "サイドパネルの種類                : ")(CFOutStateLog 1 5 &type)
  (CFOutStateLog 1 5 "--------------------引数 END-----------------")
;;;  (CFOutLog 1 nil (strcat "  +サイドパネルの種類: " &type))

  (regapp "G_SIDEP")

  ;// ベースキャビネットを検索し、ベースキャビネットの高さおよび奥行きを取得
  ;// アッパーキャビネットを検索し、アッパーキャビネットの高さおよび奥行きを取得

  ;// カウンタートップの高さを求めておく
  (if (/= CG_Type1Code "A")
    (SDP_GetCounterTopHeight)
  )

  (if (/= &type "N")
    (progn
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_LSYM"))

        ;// 性格CODEでベースキャビ、アッパーキャビの判定を行う
        (setq #skk$ (CFGetSeikakuToSKKCode (nth 9 #xd$) nil))

        (if (and (= CG_SKK_ONE_CAB (nth 0 #skk$)) (= CG_SKK_TWO_UPP (nth 1 #skk$)))
          (setq #uper-en$ (cons #en #uper-en$))
        ;else
          (if (and (= CG_SKK_ONE_CAB (nth 0 #skk$)) (= CG_SKK_TWO_BAS (nth 1 #skk$)))
            (setq #base-en$ (cons #en #base-en$))
          )
        )
        ;(if (member (nth 9 #xd$) #appa$)
        ;  (setq #uper-en$ (cons #en #uper-en$))
        ;  (if (member (nth 9 #xd$) #base$)
        ;    (setq #base-en$ (cons #en #base-en$))
        ;  )
        ;)
        (setq #i (1+ #i))
      )
      (setq #lst$ (SDP_GetSidePanelPos #base-en$ #uper-en$ &type))
      (SDP_PosSidePanelByKata &type #lst$)
    )
  )
)
;SDP_PosSidePanel

;<HOM>*************************************************************************
; <関数名>    : SDP_PosSidePanel
; <処理概要>  : サイドパネルを配置する
; <戻り値>    :
; <作成日>    : 1999-10-10
; <備考>      :
;*************************************************************************>MOH<
(defun SDP_PosSidePanelByKata (
    &type  ;(STR)サイドパネルの種類 (N,R,L,T)
    &info$ ;(LIST)端の部材の基点と図形名のリスト
           ;       ((最左ベース図形 座標)
           ;        (最右ベース図形 座標)
           ;        (最左アッパー図形 座標)
           ;        (最右アッパー図形 座標)
           ;        (最下ベース図形 座標)
           ;        (最下アッパー図形 座標)
           ;       )
    /
    #filer-h #info$ #en #pt #xd$ #w #d #h #panel$ #fname$ #hin #sql #fig$ #qry$
		#ANG #MSG #PW 
  )
	(CFOutStateLog 1 1 " ")
	(CFOutStateLog 1 1 "//// SDP_PosSidePanelByKata ////")
	(CFOutStateLog 1 1 " ")

  ;//　CG_SidePanel$の内容
  ;//
  ;//    ・カップボード
  ;//        (
  ;//          天井までのベース品番（１枚分）
  ;//          天井までのアッパー品番（１枚分）
  ;//        )
  ;//    ・カウンターユニット
  ;//        (
  ;//          分離ベース品番（２枚分）
  ;//          分離アッパー品番（２枚分）
  ;//        )
  ;//    ・コンビネーション
  ;//        (
  ;//          分離ベース品番（２枚分）
  ;//          分離アッパー品番（２枚分）
  ;//          天井までのベース品番（１枚）
  ;//        )
  ;//
  ;//   分離ベースの高さはそれぞれカウンターの最上位置＋１８mmに伸縮
  ;//   分離ベースの奥行はそれぞれ隣接キャビネットの奥行き＋１８mmに伸縮
  ;//   分離アッパーの高さはそれぞれ隣接キャビネットの奥行き＋天井フィラー高さ＋１８mmに伸縮
  ;//   分離アッパーの奥行はそれぞれ隣接キャビネットの奥行き＋１８mmに伸縮
  ;//

	(WebOutLog "CG_SidePanel$=") ; 02/09/11 YM ADD
	(WebOutLog CG_SidePanel$)    ; 02/09/11 YM ADD

  (foreach #hin CG_SidePanel$
    (setq #qry$
;;;      (car ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
        (CFGetDBSQLHinbanTable
           "品番図形"
           #hin
           (list
             (list "品番名称" #hin 'STR)
           )
        )
;;;      ) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
    )
    (if (= #qry$ nil)
      (progn
				(setq #msg (strcat "『品番図形』にレコードがありません.\nSDP_PosSidePanelByKata"))
	      (CFOutStateLog 0 1 #msg)
				(CFAlertMsg #msg)
	      (*error*)
      )
    )
		(CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
		(CFOutStateLog 1 1 #qry$)

		(if (= (length #qry$) 1) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
			(progn
		  	(setq #qry$ (car #qry$))
				(WebOutLog "[品番図形]取得ﾚｺｰﾄﾞ=") ; 02/09/11 YM ADD
				(WebOutLog #qry$) ; 02/09/11 YM ADD
			)
	    (progn ; 複数ﾋｯﾄしたときはｴﾗｰ
				(setq #msg (strcat "『品番図形』にレコードが複数ありました.\nSDP_PosSidePanelByKata"))
	      (CFOutStateLog 0 1 #msg)
				(CFAlertMsg #msg)
	      (*error*)
	    )
		);_if                    ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD

    (setq #fig$ (list (nth 6 #qry$)));2008/06/28 YM OK!

    (setq #fname$ (append #fname$ #fig$))

  );foreach


  (regapp "G_PTEN")
  (setq #pw (nth 3 #qry$)) ;2008/06/28 YM OK!

  ;// ベース（右側）
  (if (or (= &type "R") (= &type "T") (= &type "B"))     ;片側または両側に取り付け
    (progn
      (setq #info$ (nth 1 &info$))
      (setq #en  (car #info$))
      (setq #pt  (cadr #info$))
      (setq #xd$ (CFGetXData #en "G_SYM"))
      (setq #w (nth 3 #xd$))
      (setq #xd$ (CFGetXData #en "G_LSYM"))
      (setq #ang (rtd (nth 2 #xd$)))
      (setq #pt (list (+ (car #pt) #w) (cadr #pt) 0.0))
      ;// コンビネーションで右勝手の場合
      (if (and (= CG_Type1Code "C") (= (nth 11 CG_GLOBAL$) "R"))
        (SDP_MakeSidePanel
          (caddr #fname$)
          (caddr CG_SidePanel$)
          #pt
          #ang
          #en
          "SIDEP1"
        )
      ;else
        (SDP_MakeSidePanel
          (car #fname$)
          (car CG_SidePanel$)
          #pt
          #ang
          #en
          "SIDEP1"
        )
      )
    )
  )
  ;// ベース（左側）
  (if (or (= &type "L") (= &type "T") (= &type "B"))     ;両側に取り付け
    (progn
      (setq #info$ (nth 0 &info$))
      (setq #en (car #info$))
      (setq #pt (cadr #info$))
      (setq #xd$ (CFGetXData #en "G_SYM"))
      (setq #w (nth 3 #xd$))
      (setq #xd$ (CFGetXData #en "G_LSYM"))
      (setq #ang (rtd (nth 2 #xd$)))
      (setq #pt (list (- (car #pt) #pw) (cadr #pt) 0.0))
      ;// コンビネーションで左勝手の場合
      (if (and (= CG_Type1Code "C") (= (nth 11 CG_GLOBAL$) "L"))
        (SDP_MakeSidePanel
          (caddr #fname$)
          (caddr CG_SidePanel$)
          #pt
          #ang
          #en
          "SIDEP2"
        )
      ;else
        (SDP_MakeSidePanel
          (car #fname$)
          (car CG_SidePanel$)
          #pt
          #ang
          #en
          "SIDEP2"
        )
      )
    )
  )
  ;// アッパー（右側）
  (if (car (nth 3 &info$))
    ;// 片側に取り付け（ベース、アッパー分離）
    (if (and (/= CG_Type1Code "A")(/= CG_Type1Code "D") (or (= &type "R") (= &type "T") (= &type "B")))
      (progn
        (if (and (= CG_Type1Code "C") (= (nth 11 CG_GLOBAL$) "R"))
          (princ)
        ;else
          (progn
            (setq #info$ (nth 3 &info$))
            (setq #en (car #info$))
            (setq #pt (cadr #info$))
            (setq #xd$ (CFGetXData #en "G_SYM"))
            (setq #w (nth 3 #xd$))
            (setq #xd$ (CFGetXData #en "G_LSYM"))
            (setq #ang (rtd (nth 2 #xd$)))
            (setq #pt (list (+ (car #pt) #w) (cadr #pt)))
            ;// サイドパネルを生成する
            (SDP_MakeSidePanel
              (cadr #fname$)
              (cadr CG_SidePanel$)
              (list (car #pt) (cadr #pt) CG_CeilHeight)
              #ang
              #en
              "SIDEP3"
            )
          )
        )
      )
    )
  )
  ;// アッパー（左側）
  (if (car (nth 2 &info$))
    ;//両側に取り付け（ベース、アッパー分離）
    (if (and (/= CG_Type1Code "A") (/= CG_Type1Code "D")(or (= &type "L") (= &type "T") (= &type "B")))
      (progn
        (if (and (= CG_Type1Code "C") (= (nth 11 CG_GLOBAL$) "L"))
          (princ)
          (progn
            (setq #info$ (nth 2 &info$))
            (setq #en (car #info$))
            (setq #pt (cadr #info$))
            (setq #xd$ (CFGetXData #en "G_SYM"))
            (setq #w (nth 3 #xd$))
            (setq #xd$ (CFGetXData #en "G_LSYM"))
            (setq #ang (rtd (nth 2 #xd$)))
            (setq #pt (list (- (car #pt) #pw) (cadr #pt)))
            ;// サイドパネルを生成する
            (SDP_MakeSidePanel
              (cadr #fname$)
              (cadr CG_SidePanel$)
              (list (car #pt) (cadr #pt) CG_CeilHeight)
              #ang
              #en
              "SIDEP4"
            )
          )
        )
      )
    )
  )
  (princ)
)
;SDP_PosSidePanelByKata

;<HOM>*************************************************************************
; <関数名>    : SDP_MakeSidePanel
; <処理概要>  : 配置情報からサイドパネルを作成する
; <戻り値>    :
; <作成日>    : 1999-10-10
; <備考>      :
;*************************************************************************>MOH<
(defun SDP_MakeSidePanel (
    &file         ;(STR) 挿入ファイル名
    &hin          ;(STR) 品番名称
    &pt           ;(LIST)配置点
    &ang          ;(REAL)配置角度
    &en           ;(ENAME)取り付けるキャビネットの図形名
    &grp          ;(STR)グループ名
    /
    #sym #xd$ #w #d #h
    #listCode #sql #nn #seikaku
    #qry$
		#FIL-H #MSG
  )
  (CFOutStateLog 1 5 "//// SKMakeSidePanel ////")
  (CFOutStateLog 1 5 "--------------------引数 START-----------------")
  (CFOutStateLog 1 5 "挿入ファイル名   : ")(CFOutStateLog 1 5 &file)
  (CFOutStateLog 1 5 "品番名称         : ")(CFOutStateLog 1 5 &hin)
  (CFOutStateLog 1 5 "配置点           : ")(CFOutStateLog 1 5 &pt)
  (CFOutStateLog 1 5 "配置角度         : ")(CFOutStateLog 1 5 &ang)
  (CFOutStateLog 1 5 "図形名           : ")(CFOutStateLog 1 5 &en)
  (CFOutStateLog 1 5 "グループ名       : ")(CFOutStateLog 1 5 &grp)
  (CFOutStateLog 1 5 "--------------------引数 END-------------------")
;;;  (CFOutLog 1 nil (strcat "  +挿入ファイル名: " &file))
;;;  (CFOutLog 1 nil (strcat "  +品番名称: "       &hin))

  ;-----------------------------------------
  ; サイドパネルの伸縮量を求める
  ;-----------------------------------------
  (setq #xd$ (CFGetXData &en "G_SYM"))
  (setq #w   (nth 3 #xd$))
  (setq #d   (nth 4 #xd$))
  (setq #h   (nth 5 #xd$))
  (cond
    ;// ベースの伸縮値
    ((or (= &grp "SIDEP1") (= &grp "SIDEP2"))
      (cond
        (or (= CG_Type1Code "A")(= CG_Type1Code "D")     ;カップボード
          (setq #h CG_CeilHeight)
          (setq #d (+ #d CG_PANEL_OFFSET))
        )
        ((= CG_Type1Code "B")     ;カウンターユニット
          (setq #h (+ CG_CounterHeight CG_PANEL_OFFSET))
          (setq #d (+ CG_CounterDepth CG_PANEL_OFFSET))
        )
        ((= CG_Type1Code "C")     ;コンビネーション
          (if
            (or (and (= (nth 11 CG_GLOBAL$) "R") (= &grp "SIDEP1"))
                (and (= (nth 11 CG_GLOBAL$) "L") (= &grp "SIDEP2"))
            )
            (setq #h CG_CeilHeight)
          ;else
            (setq #h (+ CG_CounterHeight CG_PANEL_OFFSET))
          )
          (setq #d (+ CG_CounterDepth CG_PANEL_OFFSET))
        )
      )
    )
    ;// アッパーの伸縮値
    (T
      (setq #fil-h (- CG_CeilHeight CG_UpCabHeight))
      (setq #h (+ #h #fil-h CG_PANEL_OFFSET))
      (setq #d (+ #d CG_PANEL_OFFSET))
    )
  )
  ;-----------------------------------------
  ; 性格CODEを取得
  ;-----------------------------------------
  (setq #qry$
;;;    (car ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
			(CFGetDBSQLHinbanTable
            "品番基本"
            &hin
            (list
              (list "品番名称" &hin 'STR)
            )
       )
;;;    ) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
  )

  (if (= #qry$ nil)
    (progn
			(setq #msg (strcat "『品番基本』にレコードがありません.\nSDP_MakeSidePanel"))
      (CFOutStateLog 0 1 #msg)
			(CFAlertMsg #msg)
      (*error*)
    )
  )
	(CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
	(CFOutStateLog 1 1 #qry$)

	(if (= (length #qry$) 1) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
		(progn
	  	(setq #qry$ (car #qry$))
		)
    (progn ; 複数ﾋｯﾄしたときはｴﾗｰ
			(setq #msg (strcat "『品番基本』にレコードが複数ありました.\nSDP_MakeSidePanel"))
      (CFOutStateLog 0 1 #msg)
			(CFAlertMsg #msg)
      (*error*)
    )
	);_if                    ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD

  (setq #seikaku (nth 5 #qry$))
;;;  (if (/= #seikaku nil)
;;;    (CFOutLog 1 nil (strcat "  +性格CODE: " (rtos #seikaku)))
;;;  )
  ;-----------------------------------------
  ;サイドパネルを挿入する
  ;-----------------------------------------
  (command "_insert"  (strcat CG_MSTDWGPATH &file) &pt 1 1 &ang)
  (command "_explode" (entlast))                    ;インサート図形分解
  ;// 分解した選択セットで名前のないグループを作成する
  (SKMkGroup (ssget "P"))

  ;// 拡張データの設定
  (setq #sym (SKC_GetSymInGroup (entlast)))
  (CFSetXData #sym "G_LSYM"
    (list
      &file         ;1 :本体図形ID      :『品番図形』.図形ID
      &pt           ;2 :挿入点          :配置基点
      (dtr &ang)    ;3 :回転角度        :配置回転角度
      ""            ;4 :工種記号        :CG_Kcode
      ""            ;5 :SERIES記号    :CG_SeriesCode
      &hin          ;6 :品番名称        :『品番図形』.品番名称
      0            ;7 :L/R区分         :『品番図形』.部材L/R区分
      ""            ;8 :扉図形ID        :
      ""            ;9 :扉開き図形ID    :
      (fix #seikaku)      ;10:性格CODE      :『品番基本』.性格CODE
      0             ;11:複合フラグ      :０固定（単独部材）
      0             ;12:配置順番号      :配置順番号(1～)
      0             ;13:用途番号        :『品番図形』.用途番号
      0             ;14:寸法Ｈ          :『品番図形』.寸法Ｈ
      0             ;15:断面指示の有無  :断面指示の有無
    )
  )
  ;// 取り付けるキャビネットのサイズを元にW,D,Hを設定する
  (setq #xd$ (CFGetXData #sym "G_SYM"))
  (CFSetXData #sym "G_SYM"
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
      (nth 11 #xd$)   ;伸縮フラグＷ
      #d
      #h
      (nth 14 #xd$)   ;ブレークライン数Ｗ
      (nth 15 #xd$)   ;ブレークライン数Ｄ
      (nth 16 #xd$)   ;ブレークライン数Ｈ
    )
  )
)
;SDP_MakeSidePanel

;<HOM>*************************************************************************
; <関数名>    : SDP_GetSidePanelPos
; <処理概要>  : サイドパネルの配置情報を取得する
; <戻り値>    :
;             : (LIST)端の部材の基点と図形名のリスト
;                  ((最左ベース図形 座標)
;                   (最右ベース図形 座標)
;                   (最左アッパー図形 座標)
;                   (最右アッパー図形 座標)
;                   (最下ベース図形 座標)
;                   (最下アッパー図形 座標)
;                  )
; <作成日>    : 1999-10-10
; <備考>      :
;*************************************************************************>MOH<
(defun SDP_GetSidePanelPos (
    &base-en$     ;(LIST)ベースキャビネット図形のリスト
    &uper-en$     ;(LIST)アッパーキャビネット図形のリスト
    &type         ;(STR)サイドパネルの種類 (N,A,B,C,D)
    /
    #i #maxpt1 #minpt1 #maxpt2 #minpt2 #minypt #en #eg #pt 
		#maxen1 #minen1 #minypt1 #minyen1 #maxen2 #minen2 #minyen
		#MINYEN2 #MINYPT2
  )
	(CFOutStateLog 1 1 " ")
	(CFOutStateLog 1 1 "//// SDP_GetSidePanelPos ////")
	(CFOutStateLog 1 1 " ")

  (setq #i 0)
  (setq #maxpt1 (list -10000 0))
  (setq #minpt1 (list 10000 0))
  (setq #maxpt2 (list -10000 0))
  (setq #minpt2 (list 10000 0))
  (setq #minypt1 (list 0 10000))
  (setq #minypt2 (list 0 10000))
  (foreach #en &base-en$
    (setq #eg (entget #en))
    (setq #pt (cdr (assoc 10 #eg)))
    
    (if (< (car #maxpt1) (car #pt))
      (progn
        (setq #maxpt1 #pt)
        (setq #maxen1 #en)
      )
    )
    (if (> (car #minpt1) (car #pt))
      (progn
        (setq #minpt1 #pt)
        (setq #minen1 #en)
      )
    )
    (if (> (cadr #minypt1) (cadr #pt))
      (progn
        (setq #minypt1 #pt)
        (setq #minyen1 #en)
      )
    )
    (setq #i (1+ #i))
  )
  (foreach #en &uper-en$
    (setq #eg (entget #en))
    (setq #pt (cdr (assoc 10 #eg)))
    
    (if (< (car #maxpt2) (car #pt))
      (progn
        (setq #maxpt2 #pt)
        (setq #maxen2 #en)
      )
    )
    (if (> (car #minpt2) (car #pt))
      (progn
        (setq #minpt2 #pt)
        (setq #minen2 #en)
      )
    )
    (if (> (cadr #minypt2) (cadr #pt))
      (progn
        (setq #minypt2 #pt)
        (setq #minyen2 #en)
      )
    )
    (setq #i (1+ #i))
  )
  ;// 結果を返す
  (list (list #minen1 #minpt1)
        (list #maxen1 #maxpt1)
        (list #minen2 #minpt2)
        (list #maxen2 #maxpt2)
        (list #minyen1 #minypt1)
        (list #minyen2 #minypt2)
  )
)
;SDP_GetSidePanelPos

;<HOM>*************************************************************************
; <関数名>    : SDP_GetCounterTopHeight
; <処理概要>  : カウンターの最上部の高さを求める
; <戻り値>    :
;        REAL : 高さ
; <作成日>    : 1999-10-10
; <備考>      :
;*************************************************************************>MOH<
(defun SDP_GetCounterTopHeight (
    /
    #ss #i #en #xd$ #h
  )
	(CFOutStateLog 1 1 " ")
	(CFOutStateLog 1 1 "//// SDP_GetCounterTopHeight ////")
	(CFOutStateLog 1 1 " ")

  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (setq #i 0)
  (while (and (= #h nil) (< #i (sslength #ss)))
    (setq #en (ssname #ss #i))
    (setq #xd$ (CFGetXData #en "G_LSYM"))
    (if (= CG_SKK_ONE_CNT (CFGetSeikakuToSKKCode (nth 9 #xd$) 1))
      (progn
        (setq #xd$ (CFGetXData #en "G_SYM"))
        (setq #h (nth 2 (cdr (assoc 10 (entget #en)))))
        (setq #h (+ #h (nth 5 #xd$)))
        (setq CG_CounterHeight #h)
        (setq CG_CounterDepth  (nth 4 #xd$))
      )
    )
    (setq #i (1+ #i))
  )
)
;SDP_GetCounterTopHeight

(princ)
