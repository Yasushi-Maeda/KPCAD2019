(setq CG_LAYOUT_DIM_Z 15000.0)  ; 寸法線のＺ値  01/10/02 HN ADD

;<HOM>*************************************************************************
; <関数名>    : CFIsEqualPt
; <処理概要>  : ２つの点座標が同一であるかを調べる
; <戻り値>    :
;           T : 同一座標である
;         nil : 同一座標ではない
; <作成>      : 04/03/25 SK ADD
; <備考>      :
;*************************************************************************>MOH<
(defun CFIsEqualPt (
		&p1   ;(LIST)座標１
		&p2   ;(LIST)座標２
		/
	)
	;// 指定線分エンティティから始終点を取り出す
	(if (and
				(equal (car  &p1) (car  &p2) 0.001)
				(equal (cadr &p1) (cadr &p2) 0.001)
			)
		T
		nil
	)
)
;CFIsEqualPt

;<HOM>*************************************************************************
; <関数名>    : SCFIsTaimenFlatPlan
; <処理概要>  : 対面フラットプランかどうかを調べる
; <戻り値>    :
;          SF : セミフラット対面プラン
;          FF : フルフラット対面プラン
;         nil : それ以外
; <作成>      : 04/04/08 SK ADD
; <備考>      :
;*************************************************************************>MOH<
(defun SCFIsTaimenFlatPlan (
	/
	#en     #en$
	#wtXd$
	#fType
	)
	; 全図面のシンボル取得
	(setq #en$ (Ss2En$ (ssget "X" '((-3 ("G_WRKT"))))))

	(foreach #en #en$
		(setq #wtXd$ (CFGetXData #en "G_WRKT"))
		(if (/= (nth 31 #wtXd$) "")
			(setq #fType (nth 31 #wtXd$))
		)
	)
	; フラットプランタイプを返す
	#fType
)
;SCFIsTaimenFlatPlan

;<HOM>*************************************************************************
; <関数名>    : SCFGetTaimenFlatPlanInfo
; <処理概要>  : 構成のの外に対面用のベースキャビがあればその奥行き、Ｄ方向を取得する
; <戻り値>    :
;        LIST : (対面の奥行き　対面キャビのＤ方向)
;         nil : 対面キャビがない
; <作成>      : 04/03/25 SK ADD
; <備考>      :
;*************************************************************************>MOH<
(defun SCFGetTaimenFlatPlanInfo (
	&enSym$        ; 構成エンティティリスト
	/
	#en1  #en2  #en2$
	#ang1 #ang2
	#p1   #p2
	#p1z  #p2z
	#xd1$ #xd2$
	#210$
	#tAng          ;対面キャビの対面方向
	#tDepth        ;対面キャビの奥行き
	#tDepthTmp     ;対面キャビの奥行き
	#skk$          ;性格コード
	#no1
	#no2
	#yDist
	)
	; 全図面のシンボル取得
	(setq #en2$ (Ss2En$ (ssget "X" '((-3 ("G_LSYM"))))))

	(foreach #en1 &enSym$
		(if (and #en1 (setq #xd1$ (CFGetXData #en1 "G_LSYM")) (CfGetXData #en1 "G_SKDM"))
			(progn
				; 性格コードを取得する
				(setq #skk$ (CFGetSymSKKCode #en1 nil))
				; ベースキャビ カウンターが対象
				(if (and (or (= (car #skk$) 1) (= (car #skk$) 7)) (= (cadr #skk$) 1))
					(progn
						; 構成内キャビの原点と角度を求める
						(setq #p1   (cdr (assoc 10 (entget #en1))))
						(setq #p1z  (last #p1))
						(setq #p1   (list (car #p1) (cadr #p1)))
						(setq #ang1 (nth 2 #xd1$))

						; 09/04/17 T.Ari Mod
						; モデル番号が同一のものは対象外
						(setq #no1 (nth 2 (CfGetXData #en1 "G_SKDM")))

						; 判定対象キャビが対面かどうか調べる
						(foreach #en2 #en2$
							; 性格コードを取得
							(setq #skk$ (CFGetSymSKKCode #en2 nil))
							; ベースキャビ カウンターが対象
							(if (and (or (= (car #skk$) 1) (= (car #skk$) 7)) (= (cadr #skk$) 1) (CfGetXData #en2 "G_SKDM"))
								(progn
									(setq #xd2$ (CFGetXData #en2 "G_LSYM"))

									; 判定対象キャビの原点と角度を求める
									(setq #p2   (cdr (assoc 10 (entget #en2))))
									(setq #p2z  (last #p2))
									(setq #p2   (list (car #p2) (cadr #p2)))
									(setq #ang2 (nth 2 #xd2$))

									(setq #210$ (cdr (assoc 210 (entget #en2))))
									; 09/04/17 T.Ari Mod
									; モデル番号が同一のものは対象外
									(setq #no2 (nth 2 (CfGetXData #en2 "G_SKDM")))

									; 互いのキャビの向きが逆であること
									(if (and (/= #no1 #no2) (equal (angtos #ang1 0 2) (angtos (+ #ang2 pi) 0 2)))
										(cond
											;// 平面図の場合
											((CFIsEqualPt (list 0 0 1) #210$)
												; T.Ari Mod 09/04/20
												; ある程度Y座標が離れていても対面とする。
												(setq #yDist (- (cadr #p2) (cadr #p1)))
												(if (equal #yDist 0 200)
													(progn
														(setq #xd2$ (CFGetXData #en2 "G_SYM"))
														(setq #tDepthTmp (+ #yDist (nth 4 #xd2$)))
														(if (or (= #tDepth nil) (> #tDepthTmp #tDepth))
															(progn
																(setq #tDepth #tDepthTmp)
																(setq #tAng   (- #ang2 (dtr 90)))
															)
														)
													)
												)
											)
											; 展開ＢＤ上でのチェック
											; 基点XY座標が同じで、Z座標が異なること
											((and (equal (car #p2) (car #p1) 200) (= (equal #p1z #p2z 200) nil))
												(setq #xd2$ (CFGetXData #en2 "G_SYM"))
												(setq #tDepthTmp (+ (nth 4 #xd2$) (- (car #p2) (car #p1))))
												(if (or (= #tDepth nil) (> #tDepthTmp #tDepth))
													(progn
														(setq #tDepth #tDepthTmp)
														(setq #tAng   (- #ang2 (dtr 90)))
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
	)
	; 対面情報を返す
	(if #tDepth
		(list #tDepth #tAng)
	;else
		nil
	)
)
;SCFGetTaimenFlatPlanInfo

;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetBaseHeight
;;; <処理概要>: 床高さのデフォルト値を取得します
;;; <戻り値>  : 床高さ
;;;             設定値がない場合は、nil を返します
;;; <作成>    : 01/09/23
;;; <備考>    : DIMENSION.INI の "BaseHeight" を参照します。
;;;             本関数は、PanaHome様用に作成。
;;;************************************************************************>MOH<
(defun SCFGetBaseHeight
	(
	/
	#sFile      ; ファイル名
	#vData$     ; ファイル データ
	#sData      ; 文字データ
	#rData      ; 実数値データ
	)
	(setq #rData nil)
	(setq #sFname (strcat CG_SYSPATH "DIMENSION.INI"))
	(if (findfile #sFname)
		(progn
			(setq #vData$ (ReadIniFile #sFname))
			(setq #sData (cadr (assoc "BaseHeight" #vData$)))
			(if #sData
				(setq #rData (atof #sData))
			)
		);_progn
	);_if

	#rData
);_defun


;<HOM>*************************************************************************
; <関数名>    : SCFDrawDimensionEx
; <処理概要>  : 展開図の寸法自動生成
; <戻り値>    : なし
; <作成>      : 00/02/18
; <備考>      : この関数では各展開図（展開A・展開B・展開C・展開D）
;               が作成済みであること
;*************************************************************************>MOH<
(defun SCFDrawDimensionEx (
	&ztype      ; 図面種類タイプ（平面:"P" 展開A～F:"A" "B" "C" "D" "E" "F"）
	&dimpat$    ; 出力パタン
	&Zumen      ; 図面種類 商品図 : "02"  施工図 : "03"	2000/07/04 HT ADD
	/
	#clayer #layer #ss #ss$ #ang #ryo$ #pen$ #iti$ #i #flg #tmp$
	)

	; #iti$変数の使いかた
	; (上 下 左 右)の寸法位置
	; ex.
	;     #iti$ = (0 0 1 1)なら、上や下の寸法線は、0段目の位置に作成される
	;     左や右の寸法線は、1段目の位置に作成される。0段目の位置の寸法線と
	;     重ならずに作成できる。
	;
	;     <右側に作成される寸法の例>
	;
	;         300      120   120
	;     |----------|-----|-----|
	;     ＾         ＾    ＾
	;   基点         0段目  1段目
	;
	;     -----------|-----|
	;                |     |
	;                |     |
	;                |     |
	;     -----------|-----|
	;

	;-----  初期設定  -----
	(setq #clayer (getvar "CLAYER"))
	(setvar "CLAYER" "0_DIM")

	(setq CG_DimOffLen 50) ; 施工寸法のオフセット長さ

	; 展開図の方向に応じた画層を指定
	(cond
		((equal "A" &ztype)  (setq #layer "0_SIDE_A"))
		((equal "B" &ztype)  (setq #layer "0_SIDE_B"))
		((equal "C" &ztype)  (setq #layer "0_SIDE_C"))
		((equal "D" &ztype)  (setq #layer "0_SIDE_D"))
		((equal "E" &ztype)  (setq #layer "0_SIDE_E"))
		((equal "F" &ztype)  (setq #layer "0_SIDE_F"))
		;2011/07/15 YM ADD
		((equal "G" &ztype)  (setq #layer "0_SIDE_G"))
		((equal "H" &ztype)  (setq #layer "0_SIDE_H"))
		((equal "I" &ztype)  (setq #layer "0_SIDE_I"))
		((equal "J" &ztype)  (setq #layer "0_SIDE_J"))
	)
	;----------------------
	;タイプ分け
	(setq #ss$ (KCFDivSymByLayoutEx #layer))
	(cond

		; B型 (==正面フラグがON の図形がない場合)
		((= 'PICKSET (type #ss$))

			(if (not #iti$) (setq #iti$ (list 0 0 0 0)))

			; 01/05/17 TM ADD 上側に施工寸法を作図
			(setq #ryo$ (GetRangeUpBas #ss$))
		 	(if (or (/= nil (car #ryo$)) (/= nil (cadr #ryo$)))
				(progn
		 			(setq #pen$ (car (SCFGetPEntity #layer)))
					(setq #iti$ (DrawPtenDim #pen$ #ryo$ #layer (nth 2 &dimpat$) (nth 3 &dimpat$)))
				)
			)

			; 01/06/07 TM 全施工寸法作図後にキャビネット寸法を作図する
			(KCFDrawCabiDim #ss$ #iti$)
		)

		; A型/B型の一部 (==正面フラグがすべて0ではない場合)
		((= 'LIST (type #ss$))

			; 施工寸法ONの時
			(setq #iti$ (list 0 0 0 0))
			; 01/09/09 HN MOD 施工寸法作図の判定処理を変更
			;@MOD@(if (and (= "1" (nth 1 &dimpat$)) (/= &Zumen CG_OUTSHOHINZU))
			(if (= "1" (nth 1 &dimpat$))
				(progn

					; ベースとアッパーの領域座標獲得
					;(princ "\n#ryo$(混合タイプ): ")
					(setq #ryo$ (GetRangeUpBas #ss$))
					;(princ #ryo$)

					; いずれかの領域がある場合に施工寸法を作図
					(if (or (/= nil (car #ryo$)) (/= nil (cadr #ryo$)))
						(progn
							;P図形獲得
							(setq #pen$ (car (SCFGetPEntity #layer)))
							;DEBUG (princ "\nレイヤー: ")
							;DEBUG (princ #layer)
							;DEBUG (princ "\nＰ点寸法は: ")
							;DEBUG (princ #pen$)
							; 施工寸法と施工胴縁寸法を作図
							;DEBUG (princ "\nテスト #ryo$: ")
							;DEBUG (princ #ryo$)
							;DEBUG (princ "\n施工(3番目)胴縁(4番目) ")
							;DEBUG (princ &dimpat$)
							(setq #iti$ (DrawPtenDim #pen$ #ryo$ #layer (nth 2 &dimpat$) (nth 3 &dimpat$)))
						)
				 )
				)
			)
			; キャビネット寸法ON時
			; 寸法制御ダイアログ変更にともない、商品図ONの時は必ず出力
			(if (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU))
				(progn
					; 2000/06/19 HT I型の時のみすべての正面フラグ0でも出力するように修正 START
					;if (or (= CG_KitType "I-LEFT") (= CG_KitType "I-RIGHT")
					;	  (= CG_KitType "D-LEFT") (= CG_KitType "D-RIGHT"))
					;  progn
					; 2000/06/16 I型の時は、正面フラグ0でも出力するように修正 END
					; "K" のみか "D"のみの時のみ処理する 2000/08/28 DEL
					; すべてのモデルで正面フラグがOFFなら
					(setq #tmp$ '())
					; キッチン選択リストを追加
					(if  (/= (car #ss$) nil)
						(progn
							(setq #tmp$ (append (car #ss$)))
						)
					)
					; ダイニング選択リストを追加
					(if (/= (cadr #ss$) nil)
						(progn
							(setq #tmp$ (append #tmp$ (cadr #ss$)))
						)
					)

					(setq #flg 0)
					(foreach #tmp	#tmp$
						(setq #i 0)
						; すべてのキャビネットの正面フラグが0どうか判定
						(repeat (sslength #tmp)
							; 正面フラグが 1(=正面) のキャビネットがあるか？
							(if (and (or (= 1 (nth 3 (CFGetXData (ssname #tmp #i) "G_SKDM")))
													 (= -1 (nth 3 (CFGetXData (ssname #tmp #i) "G_SKDM"))))
											(= CG_SKK_ONE_CAB (CFGetSymSKKCode (ssname #tmp #i) 1)))
								(setq #flg 1)
							)
							(setq #i (1+ #i))
						)
					);_foreach

					; 正面フラグの立っているキャビネットがひとつもない場合
					(if (/= #flg 1)
						(progn
							(foreach #tmp #tmp$
								(KCFDrawCabiDim #tmp #iti$)
							)
						)
						; 正面フラグの立っているキャビネットがある場合
						(progn
							; 上下作図
							(SCF_A_DrawDim #ss$ #iti$)
							;左右作図
							(setq #ss$ (GetModelSideDim #ss$))
							;DEBUG(princ "\n（左右モデル選択エンティティリスト 左右の基点座標）: ")
							;DEBUG(princ #ss$)
							(DrawSideDim (cadr (car #ss$)) "R" #layer (cadr (cadr #ss$)) (nth 3 #iti$))
							(DrawSideDim (car  (car #ss$)) "L" #layer (car  (cadr #ss$)) (nth 2 #iti$))
						)
					)
				)
			);_if
		)
		(t (princ "\nSCFDrawDimensionEx"))
	);_cond

	(setvar "CLAYER" #clayer)
	(princ)
) ; SCFDrawDimensionEx

;<HOM>*************************************************************************
; <関数名>    : KCFDrawCabiDim
; <処理概要>  : キャビネットの寸法を作図
; <戻り値>    : なし
; <作成>      : 01/04/10 TM ##DrawCabDim を移動 (オリジナル:2000/06/16  HT
; <備考>      : モデル全ての正面フラグ=0しかない場合と
;             : I型の商品図の作図を同じルーチンにした。)
;*************************************************************************>MOH<
(defun KCFDrawCabiDim (
	&xSs			; シンボル選択エンティティ
	&iti$			; 作図位置
	/
	#sym$  ; （ベースシンボル図形名 アッパーシンボル図形名リスト ベースキャビネット高さ）
	#bh    ;  ベースキャビネット高さ
	#2pt$  ;
	#ang   ;
	#iti   ;
	#en
	#skk$
	#taimen$
	#ed$
	#no
	#ss
	#wpt$
	#bpt
	)
	;シンボル図形獲得
	; #sym$ =（ベースシンボル図形名 アッパーシンボル図形名リスト ベースキャビネット高さ）
	(setq #sym$ (SCF_B_GetSym &xSs))

	(if (/= nil #sym$)
		(progn
			; ベースキャビネット高さを取得
			(setq #bh (nth 2 #sym$))

			(setq #taimen$ (SCFGetTaimenFlatPlanInfo (Ss2En$ &xSs)))
			(setq #ed$ (CfGetXData (car #sym$) "G_SKDM"))
			(if (and (= "D" (nth 1 #ed$)) (/= #taimen$ nil))
				(princ)
				(progn
					(setq #no (nth 2 #ed$))
					(setq #ss (ssget "X" '((-3 ("G_SKDM")))))
					(foreach #en (Ss2En$ #ss)
						(setq #ed$ (CfGetXData #en "G_SKDM"))
						(if (and (= "W" (nth 1 #ed$)) (= #no (nth 2 #ed$)))
							(setq #wpt$ (cons (cdrassoc 10 (entget #en)) #wpt$))
						)
					)

					; 全図形名のリストを作成
					(setq #sym$ (append (list (nth 0 #sym$)) (nth 1 #sym$)))

					;角度算出
					;シンボル位置とキャビネット奥行き位置を得る
					; 06/09/20 T.Ari Mod 台輪分浮いているベースキャビを考慮
					;(setq #2pt$ (Get2PointByLay (car #sym$)))
					(setq #2pt$ (Get2PointByLay (car #sym$) 1))
					(setq #2pt$ (list
												(polar (car #2pt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData (car #sym$) "G_LSYM"))))
												(polar (cadr #2pt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData (car #sym$) "G_LSYM"))))
											)
					)
					(if (/= nil #2pt$)
						(progn

							; シンボル位置とキャビネット奥行き位置からキャビネットの角度を取得して
							; 寸法を記述する左右方向を決定する
							(setq #ang (angle (cadr #2pt$) (car #2pt$)))
							; CG_DRSeriCodeRV 14. リバーシブル用扉SERIES記号

							(if (or (= CG_DRSeriCodeRV nil) (= CG_DRSeriCodeRV ""))
								; リバーシブルの場合
								(princ)
								; 通常の場合
								(setq #ang (+ #ang PI))
							)
							;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
							; 04/03/25 SK ADD-S 対面プラン対応
;							(if (SCFIsTaimenFlatPlan)
;								(foreach #en (Ss2En$ &xSs)
;									(setq #skk$ (CFGetSymSKKCode #en nil))
;									; カウンター天板は寸法出力対象とする
;									(if (= (car #skk$) CG_SKK_ONE_CNT)
;										(setq #sym$ (append #sym$ (list #en)))
;									)
;								)
;							)
							; 04/03/25 SK ADD-E 対面プラン対応
							;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

							;寸法作図
							;(SCF_B_DrawDim_Din #layer #sym$ #ang nil #iti 1)
							(setq #bpt (car #2pt$))
							(setq #wpt$ (SCFmg_sort$ 'car (cons #bpt #wpt$)))
							(if (/= #taimen$ nil)
								(setq #ang (Angle0to360 (+ #ang PI)))
							)

							(if (or (equal #ang 0.0 0.01) (equal #ang (* 2.0 PI) 0.01))
								(setq #bpt (list (nth 0 (last #wpt$)) (nth 1 #bpt) (nth 2 #bpt)))
								(setq #bpt (list (nth 0 (car #wpt$)) (nth 1 #bpt) (nth 2 #bpt)))
							)
							(if (or (equal #ang 0.0 0.01) (equal #ang (* 2.0 PI) 0.01))
								(setq #iti (nth 3 &iti$)) ; 右
								(setq #iti (nth 2 &iti$))	; 左
							)

							(SCF_B_DrawDim_Din #layer #sym$ #ang #bpt #iti 1)
						)
					);_if (/= nil #2pt$)
				)
			)
		)
	)
);_ defun KCFDrawCabiDim

;<HOM>*************************************************************************
; <関数名>    : KCFGetCabiDimAng
; <処理概要>  : キャビネットの寸法作図方向を取得する
; <戻り値>    : 角度  シンボル図形がない場合 nil
; <作成>      : 01/05/17 TM
; <備考>      : シンボル位置とキャビネット奥行き位置からキャビネット寸法の角度を計算
;*************************************************************************>MOH<
(defun KCFGetCabiDimAng (
	&xSs			; シンボル選択エンティティ
	/
	#sym$			; シンボル図形リスト
	#2pt$			; シンボル位置とキャビネット奥行き位置
	#ang			; 角度
	)

	;シンボル図形獲得
	; #sym$ =（ベースシンボル図形名 アッパーシンボル図形名リスト ベースキャビネット高さ）
	(setq #sym$ (SCF_B_GetSym &xSs))
	(if (/= nil #sym$)
		(progn
			; 全図形名のリストを作成
			(setq #sym$ (append (list (nth 0 #sym$)) (nth 1 #sym$)))

			;シンボル位置とキャビネット奥行き位置を得る
			(setq #2pt$ (Get2PointByLay (car #sym$) 1))
			(if (/= nil #2pt$)
				(progn
					; シンボル位置とキャビネット奥行き位置からキャビネットの角度を取得して
					; 寸法を記述する左右方向を決定する
					(setq #ang (angle (cadr #2pt$) (car #2pt$)))
				)
			)
		)
	)
	#ang

);_defun KCFGetCabiDimAng

;<HOM>*************************************************************************
; <関数名>    : DivSymByLayoutEx
; <処理概要>  : レイアウト後のシンボルを分ける  図形移動時専用
; <戻り値>    : （
;                 （キッチン選択エンティティリスト）
;                 （ダイニング選択エンティティリスト）
;               ）
; <備考>      :
; <作成>      : 00/02/16
; <備考>      : 正面フラグがすべて0のモデルは対象外
;               但し、モデル全てが0のものしかない場合、キッチンのシンボルを返す
;*************************************************************************>MOH<
(defun DivSymByLayoutEx (
&layer      ; シンボルを獲得する画層
/
#ss #i #en #ed$ #data$ #no #dd #tmp$ #flg #kd$ #dd$ #kitss
#err_flag  ;-- 2011/11/13 A.Satoh Add
)
;@@@00/05/18(princ "\n&layer: ")(princ &layer)

;-- 2011/11/13 A.Satoh Add - S
	(setq #err_flag nil)
;-- 2011/11/13 A.Satoh Add - E
	;シンボル図形獲得
	(setq #ss (ssget "X" (list (list -3 (list "G_SKDM")) (cons 8 &layer))))

	(setq #i 0)

	(if #ss
		(progn
			(repeat (sslength #ss)
				; シンボル図形の拡張データを取得
				(setq #en (ssname #ss #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))

;@@@00/05/18(princ "\n#ed$: ")(princ #ed$)
				;(if (/= "W" (nth 1 #ed$))
				;  (setq #data$ (cons (list (nth 2 #ed$)(nth 1 #ed$)(nth 3 #ed$) #en) #data$))
				;)
				;;00/05/18 HN S-ADD ★★★Ｉ型の施工寸法を作成するため暫定対応★★★
				;(if (/= "D" (nth 1 #ed$))
				;  (setq #data$ (cons (list (nth 2 #ed$)(nth 1 #ed$) 1 #en) #data$))
				;)
				;00/05/18 HN E-ADD ★★★Ｉ型の施工寸法を作成するため暫定対応★★★
				; ワークトップ
				(if (/= "W" (nth 1 #ed$))
					; (モデルNo. モデル種類 正面フラグ[1に固定] シンボル図形名)
					(setq #data$ (cons (list (nth 2 #ed$)(nth 1 #ed$) 1 #en) #data$))
				)
				(setq #i (1+ #i))
			)
		)
		(progn
;-- 2011/11/13 A.Satoh Mod - S
;;;;;			(princ "展開元図に図形がありません。") (setq CG_OpenMode nil)
;-- 2012/02/02 A.Satoh Mod - S
			(princ "\n★★★★展開元図に図形がありません。")
;;;;;			(CFAlertMsg "展開元図に図形がありません。")
;-- 2012/02/02 A.Satoh Mod - E
			(setq #err_flag T)
;-- 2011/11/13 A.Satoh Mod - E
		)
	)

;-- 2011/11/13 A.Satoh Add - S
	(if (= #err_flag nil)
		(progn
;-- 2011/11/13 A.Satoh Add - E
	; モデルNo.順にソート
	(setq #data$ (SCFmg_sort$ 'car #data$))

	(setq #no (nth 0 (nth 0 #data$)))
	(foreach #dd #data$
		(if (= #no (nth 0 #dd))
			(progn
				(setq #tmp$ (cons (cdr #dd) #tmp$))
				(if (= 1 (nth 2 #dd))
					(setq #flg T)
				)
			)
			(progn
				(if (/= nil #flg)
					(if (= "K" (nth 0 (nth 0 #tmp$)))
						(setq #kd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #kd$))
						(setq #dd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #dd$))
					)
					(if (= "K" (nth 0 (nth 0 #tmp$)))
						(setq #kitss (En$2Ss (mapcar 'caddr #tmp$)))
					)
				)
				(setq #tmp$ (list (cdr #dd)))
				(setq #no   (car #dd))
				(setq #flg nil)
			)
		)
	)

	(if (/= nil #tmp$)
		(if (/= nil #flg)
			(if (= "K" (nth 0 (nth 0 #tmp$)))
				(setq #kd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #kd$))
				(setq #dd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #dd$))
			)
			(if (= "K" (nth 0 (nth 0 #tmp$)))
				(setq #kitss (En$2Ss (mapcar 'caddr #tmp$)))
			)
		)
	)

	(if (or (/= nil #kd$) (/= nil #dd$))
		(list #kd$ #dd$)
		#kitss
	)
;-- 2011/11/13 A.Satoh Add - S
		)
		nil
	)
;-- 2011/11/13 A.Satoh Add - E
) ; DivSymByLayoutEx

;<HOM>*************************************************************************
; <関数名>    : KCFDivSymByLayoutEx
; <処理概要>  : レイアウト後のシンボルを分ける  展開図用
; <戻り値>    : 1. 正面図が存在する場合: リスト(構造は以下の通り)
;              （
;                 （キッチン選択エンティティリスト）
;                 （ダイニング選択エンティティリスト）
;               ）
;             : 2. 側面図しか存在しない場合: 対象となるすべてのシンボルをまとめた選択セット
; <作成>      : 00/02/16
; <備考>      :
;*************************************************************************>MOH<
(defun KCFDivSymByLayoutEx (
	&layer      ; シンボルを獲得する画層
	/
	#ss #i
	#en #ed$ #data$ #no #dd #tmp$ #flg #kd$ #dd$
	#kitss	; キッチンのシンボル
	#dinss	; ダイニングのシンボル 01/05/16 TM ADD
	#eKSide$	; 側面図形エンティティのリスト(キッチン)
	#eDSide$	; 側面図形エンティティのリスト(ダイニング)
#err_flag  ;-- 2011/11/13 A.Satoh Add
	)
	;@@@00/05/18(princ "\n&layer: ")(princ &layer)

	(setq #i 0)
;-- 2011/11/13 A.Satoh Add - S
	(setq #err_flag nil)
;-- 2011/11/13 A.Satoh Add - E

	; ワークトップ図形以外のデータを集める
	(setq #ss (ssget "X" (list (list -3 (list "G_SKDM")) (cons 8 &layer))))
	(if #ss
		(progn
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				(if (/= "W" (nth 1 #ed$))
					(setq #data$ (cons (list (nth 2 #ed$) (nth 1 #ed$) (nth 3 #ed$) #en) #data$))
				)
				(setq #i (1+ #i))
			)
		)
		; ない場合は終了
		(progn
;-- 2011/11/13 A.Satoh Add - S
;;;;;			(princ "展開元図に図形がありません。") (setq CG_OpenMode nil)
;-- 2012/02/02 A.Satoh Mod - S
			(princ "\n★★★★展開元図に図形がありません。")
;;;;;			(CFAlertMsg "展開元図に図形がありません。")
;-- 2012/02/02 A.Satoh Mod - E
			(setq #err_flag T)
;-- 2011/11/13 A.Satoh Add - E
		)
	)

;-- 2011/11/13 A.Satoh Add - S
	(if (= #err_flag nil)
		(progn
;-- 2011/11/13 A.Satoh Add - E
	; モデル番号でソート
	(setq #data$ (SCFmg_sort$ 'car #data$))

	; 01/06/21 TM ADD
	(setq #eKSide$ '() #eDSide$ '())
	(setq #no (nth 0 (nth 0 #data$)))
	; 集めたデータをモデル番号ごとに集める
	(foreach #dd #data$
			; DEBUG (princ "\nデータ : ")
			; DEBUG (princ #dd)
			(if (= #no (nth 0 #dd))
				; モデル番号が変化していない場合(と最初)
				(progn
					(setq #tmp$ (cons (cdr #dd) #tmp$))
					; 正面フラグON の場合
					(if (= 1 (nth 2 #dd))
						(setq #flg T)
					)
				)
				; モデル番号が変わる場合
				(progn
					; 正面な図形が一個でもあれば正面あり
					(if (/= nil #flg)
						; 正面あり
						(if (= "K" (nth 0 (nth 0 #tmp$)))
							(setq #kd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #kd$))
							(setq #dd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #dd$))
						)
						; 正面以外
						(progn
							; 01/06/21 TM MOD キッチンとダイニングを分けて出力するように変更(2列型対応)
							(if (= "K" (nth 0 (nth 0 #tmp$)))
								(setq #eKSide$ (append (mapcar 'caddr #tmp$) #eKSide$))
								(setq #eDSide$ (append (mapcar 'caddr #tmp$) #eDSide$))
							)
						)
					)
					; #tmp$, #no, #flg 初期化
					(setq #tmp$ (list (cdr #dd)))
					(setq #no   (car #dd))
					; 01/08/07 DEL TM ここで初期化してしまったらすべての図形データが返らない...
					;(setq #flg nil)
				)
			)
		)

		(if (/= nil #tmp$)
			(if (/= nil #flg)
				; 正面
				(if (= "K" (nth 0 (nth 0 #tmp$)))
					(setq #kd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #kd$))
					(setq #dd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #dd$))
				)
				(progn
					; 正面以外
					; 01/06/20 MOD 側面図は"K"/"D" を区別しない("K"と"D"の２列型等が存在するため)
					(if (= "K" (nth 0 (nth 0 #tmp$)))
						(setq #eKSide$ (append (mapcar 'caddr #tmp$) #eKSide$))
						(setq #eDSide$ (append (mapcar 'caddr #tmp$) #eDSide$))
					)
				)
			)
		)
		(if (or #kd$ #dd$)
			(progn
				(list #kd$ #dd$)
			)
	; 01/06/21 TM MOD キッチンとダイニングが両方ある場合の考慮
			(progn
				(if #eKSide$
					(setq #kitss (En$2Ss #eKSide$))
				)
				(if #eDSide$
					(setq #dinss (En$2Ss #eDSide$))
				)

				(if (and #dinss #kitss)
					(progn
						(list (list #kitss) (list #dinss))
					)
					(progn
						(if #kitss #kitss #dinss)
					)
				)
			)
		)
;-- 2011/11/13 A.Satoh Add - S
		)
		nil
	)
;-- 2011/11/13 A.Satoh Add - E
	) ; KCFDivSymByLayoutEx

	;<HOM>*************************************************************************
	; <関数名>    : SCF_B_GetSym
	; <処理概要>  : 寸法を作図するベースとアッパーのシンボルを獲得
	; <戻り値>    : （ベースシンボル図形名 アッパーシンボル図形名リスト ベースキャビネット高さ）
	; <備考>      :  ベースシンボル図形名         = Z座標最大
	;                アッパーシンボル図形名リスト = Z座標最大
	;                ベースキャビネット高さ最大
	; <作成>      : 00/02/03
	;*************************************************************************>MOH<

	(defun SCF_B_GetSym (
		&ss         ; シンボル選択エンティティ
		/
		#findF #i #en #ed$ #code$ #denb$ #bas$ #denu$ #upp$ #bh$ #bh
		#max #bsym
		#z #z$ #usym #usym$
		#eBFbas$		; ビーフリー用台の図形エンティティリスト
		#h #minH    ; 対面プラン対応
		)
		;断面指示されているシンボル図形名を獲得
		(setq #findF nil)
		(setq #i 0)
		(repeat (sslength &ss)
			(setq #en (ssname &ss #i))
			(setq #ed$ (CfGetXData #en "G_LSYM"))
			(setq #code$ (CFGetSymSKKCode #en nil))
			;ベースとアッパーと分ける
			(if (and #code$ (or (= CG_SKK_ONE_CAB (nth 0 #code$))(= CG_SKK_ONE_RNG (nth 0 #code$))))
				(progn
					(cond
						((and (= CG_SKK_TWO_BAS (nth 1 #code$)) (/= CG_SKK_THR_RVS (nth 2 #code$)))
						 	(if (/= BU_CODE_0012 "1") ; フレームキッチンでない場合
								(if (= 1 (nth 14 #ed$))						; 断面指示されている？
									(setq #denb$ (cons #en #denb$))
									; 02/03/31 HN S-ADD 性格CODE=110を対象とする
									(if (= CG_SKK_THR_ETC (nth 2 #code$))
										(setq #denb$ (cons #en #denb$))
									)
									; 02/03/31 HN E-ADD 性格CODE=110を対象とする
								)
							);if
							(setq #bas$ (cons #en #bas$))
						)
						((= CG_SKK_TWO_UPP (nth 1 #code$))
						 	(if (/= BU_CODE_0012 "1") ; フレームキッチンでない場合
								(if (= 1 (nth 14 #ed$))					; 断面指示されている？
									(setq #denu$ (cons #en #denu$))
								)
							);if
							(setq #upp$ (cons #en #upp$))
						)
					)
					; 01/07/31 TM MOD とりあえず、ビーフリー台を検出してみる
					(if (equal (list CG_SKK_ONE_CAB CG_SKK_TWO_BAS CG_SKK_THR_BFR) #code$)
						(progn
							(if #sBFbas$
								(setq #eBFbas$ (append #eBFbas$ (list #en)))
								(setq #eBFbas$ (list #en))
							)
						)
					)
				)
				(progn
					(if (= CG_SKK_ONE_CNT (nth 0 #code$))
						(if (/= BU_CODE_0012 "1") ; フレームキッチンでない場合
							(if (= 1 (nth 14 #ed$))
								(setq #denu$ (cons #en #denu$))     ; 断面指示されている
							)
						);if
						; 01/12/19 HN S-MOD シンク・水栓・その他図形は寸法作図対象としない
						;@MOD@(setq #upp$ (cons #en #upp$))
						(if
							(and
								;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
								; 04/03/25 SK ADD-S 対面プラン対応
								; ベースの部材でない事
								(/= CG_SKK_TWO_BAS (nth 1 #code$))
								; 04/03/25 SK ADD-E 対面プラン対応
								;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
								(/= CG_SKK_ONE_SNK (nth 0 #code$))  ; シンク
								(/= CG_SKK_ONE_WTR (nth 0 #code$))  ; 水栓・浄水器
								(/= CG_SKK_ONE_ETC (nth 0 #code$))  ; その他
							)
							(setq #upp$ (cons #en #upp$))
						);_if
						; 01/12/19 HN E-MOD シンク・水栓・その他図形は寸法作図対象としない
					)
				)
			)
			(setq #i (1+ #i))
		)

		; 断面指示されているものがあれば取り出す。
		(if (/= nil #denb$) (setq #bas$ #denb$))
		(if (/= nil #denu$) (setq #upp$ #denu$))
		;ベースキャビネット高さ獲得
		(foreach #en #bas$
			(setq #bh$ (cons (nth 13 (CfGetXData #en "G_LSYM")) #bh$))
		)
		(if #bh$
			(setq #bh (apply 'max #bh$))
		)

		;Z座標の一番大きいシンボル図形を獲得
		;ベース
		(if (/= nil #bas$)
			(progn
				(setq #max (caddr (cdrassoc 10 (entget (nth 0 #bas$)))))
				(setq #minH (cadr (cdrassoc 10 (entget (nth 0 #bas$)))))
				(setq #bsym (nth 0 #bas$))
				(foreach #en #bas$
;					(setq #z (caddr (cdrassoc 10 (entget #en))))
					(setq #h (cadr  (cdrassoc 10 (entget #en))))
					(setq #z$ (GetZPointByLay #en 0))
					(mapcar
						'(lambda (#z)
							; 04/04/13 SK MODD-S 対面プラン対応
							; Ｚ座標が同じ時は、Ｈ座標の小さい方を優先する
							(if (equal #z #max 0.001)
								(if (< #h #minH)
									(progn
										(setq #max #z)
										(setq #minH #h)
										(setq #bsym #en)
									)
								)
								(if (> #z #max)
									(progn
										(setq #max #z)
										(setq #minH #h)
										(setq #bsym #en)
									)
								)
							)
							; 04/04/13 SK MODD-E 対面プラン対応
						)
						#z$
					)
				)
			)
		)

		; 01/07/31 TM ADD-S ビーフリー台がある場合、最低のシンボルを取得
		;                   (キャビネット本体よりも寸法基準を低くするため)
		(if #eBFbas$
			(foreach #en #eBFbas$
				(setq #z (caddr (cdrassoc 10 (entget #en))))
				(setq #z$ (GetZPointByLay #en 0))
				(mapcar
					'(lambda (#z)
						(if (< #z #max)
							(progn
								(setq #max #z)
								(setq #bsym #en)
							)
						)
					)
					#z$
				)
			)
		)
		; 01/07/31 TM ADD-E ビーフリー台がある場合、最低のシンボルを取得

		;アッパー
		(if (/= nil #upp$)
			(progn
				(setq #max (caddr (cdrassoc 10 (entget (nth 0 #upp$)))))
				(setq #usym (nth 0 #upp$))
				(foreach #en #upp$
;					(setq #z (caddr (cdrassoc 10 (entget #en))))
					(setq #z$ (GetZPointByLay #en 0))
					(mapcar
						'(lambda (#z)
							(if (> #z #max)
								(progn
									(setq #max #z)
								)
							)
						)
						#z$
					)
				)

				(foreach #en #upp$
					(setq #z (caddr (cdrassoc 10 (entget #en))))
					(setq #z$ (GetZPointByLay #en 0))
					(mapcar
						'(lambda (#z)
							(if (equal #z #max 0.01)
								(if (= CG_SKK_TWO_UPP (CFGetSymSKKCode #en 2))
									(setq #usym  #en)
									(setq #usym$ (cons #en #usym$))
								)
							)
						)
						#z$
					)
				)
			)
		) ;_if (/= nil #upp$)

		(if (and #bsym (cons #usym #usym$) #bh)
			(list #bsym (cons #usym #usym$) #bh)
			nil
		)
	) ; SCF_B_GetSym

	;<HOM>*************************************************************************
	; <関数名>    : SCF_Aub_GetSym
	; <処理概要>  : 寸法を作図するベースとアッパーと全体の座標リスト獲得
	; <戻り値>    : （ベース アッパー 全体）
	; <作成>      : 00/02/10
	;*************************************************************************>MOH<
	(defun SCF_Aub_GetSym (
		&ss         ; シンボル選択エンティティ
		&KorD
		/
		#i #en #ed$ #code$ #base$ #midd$ #uppu$ #h #sideu$ #sideb$ #bpt$
		#upt$ #umpt$ #pt$ #spt$
		#eSinkbase
		#bpttmp$
		)
		;正面フラグが正面のもののみを獲得
		(setq #i 0)
		(repeat (sslength &ss)
			(setq #en    (ssname &ss #i))
			(setq #ed$   (CfGetXData #en "G_SKDM"))
			(setq #code$ (CfGetSymSKKCode #en nil))

			; 正面フラグが正面
			(if (= 1 (nth 3 #ed$))
				(progn
					(if (= CG_SKK_ONE_CAB (nth 0 #code$))
						;キャビネット
						(progn
							(cond
								((= CG_SKK_TWO_BAS (nth 1 #code$))   ; ベース
									(if (= CG_SKK_THR_SNK (nth 2 #code$)) ; 2000/10/19 HT シンク
										(setq #eSinkbase #en)
										(setq #base$ (cons #en #base$))
									)
								)
								((= CG_SKK_TWO_MID (nth 1 #code$))   ; ミドル
									(setq #midd$ (cons #en #midd$))
								)
								((= CG_SKK_TWO_UPP (nth 1 #code$))   ; アッパー
									(setq #uppu$ (cons #en #uppu$))
								)
							)
						)
						;その他
						(progn
							(cond
								;サイドパネル
								((= CG_SKK_ONE_SID (nth 0 #code$))
									(if (= CG_SKK_TWO_BAS (nth 1 #code$))
										;ベース
										(progn
											(setq #h (nth 5 (CfGetXData #en "G_SYM")))
											(if (equal CG_CeilHeight #h 0.01)
												(setq #sideu$ (cons #en #sideu$))
											)
											(setq #sideb$ (cons #en #sideb$))
										)
										;アッパー
										(progn
											(setq #sideu$ (cons #en #sideu$))
										)
									)
								)
								;レンジフード
								((= CG_SKK_ONE_RNG (nth 0 #code$))
									(setq #uppu$ (cons #en #uppu$))
								)
								;冷蔵庫 2000/07/25 追加
								((and (= CG_SKK_ONE_ETC (nth 0 #code$))
											(= CG_SKK_TWO_BAS (nth 1 #code$))
											(= CG_SKK_THR_NRM (nth 2 #code$)) ;冷蔵庫、ペニンシュラ
									)
									(setq #base$ (cons #en #base$))
								)
							)
						)
					)
				)
			)
			(setq #i (1+ #i))
		)
		;ベース
		(if (/= nil #base$)
			(progn
				(mapcar
				 '(lambda ( #en / #bpttmp$ )
						; (setq #bpt$ (append (Get2PointByLay #en) #bpt$))
						; リバーシブル対応 2000/10/20 HT MOD START
						; 正面のみ出力
						; 06/09/20 T.Ari Mod 台輪分浮いているベースキャビを考慮
						(setq #bpttmp$ (Get2PointByLay #en 0))
						(setq #bpttmp$ (list (polar (car #bpttmp$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM"))))
																 (polar (cadr #bpttmp$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM"))))))
						(setq #bpt$ (append #bpttmp$ #bpt$))
;						(setq #bpt$ (append (Get2PointByLay #en 0) #bpt$))
            ; リバーシブル対応 2000/10/20 HT MOD END
					)
					(append #base$ #sideb$)
				)
			)
		)

		; リバーシブル対応 2000/10/20 HT MOD START
		; 正面のみ出力
		; ただし、シンクキャビなら背面・正面可
		(if (/= nil #eSinkbase)
			(progn
				; ベースキャビネットのうちシンク
				; 06/09/20 T.Ari Mod 台輪分浮いているベースキャビを考慮
				(setq #bpttmp$ (Get2PointByLay #eSinkbase 1))
				(setq #bpttmp$ (list (polar (car #bpttmp$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #eSinkbase "G_LSYM"))))
														 (polar (cadr #bpttmp$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #eSinkbase "G_LSYM"))))))
				(setq #bpt$ (append #bpttmp$ #bpt$))
;				(setq #bpt$ (append (Get2PointByLay #eSinkbase 1) #bpt$))
				(append #base$ (list #eSinkbase))
			)
		)
		; リバーシブル対応 2000/10/20 HT MOD END
		; Y座標でソートする
		(setq #bpt$ (CfListSort #bpt$ 1))
		;アッパー
		(if (/= nil #uppu$)
			(progn
				(mapcar
				 '(lambda ( #en )
						;(setq #upt$ (append (Get2PointByLay #en) #upt$))
						(setq #upt$ (append (Get2PointByLay #en 1) #upt$))
					)
					#uppu$
				)
				(if (and (/= nil #upt$) (or (> (length #upt$) 2) (/= (length #sideu$) 0)))
					(progn
						; サイドパネルの座標も算出
						(mapcar
						 '(lambda ( #en )
								;(setq #spt$ (append (Get2PointByLay #en) #spt$))
								(setq #spt$ (append (Get2PointByLay #en 1) #spt$))
							)
							#sideu$
						)
						(if (= &KorD "K")
							(progn
								(setq #umpt$ (PtSort #upt$ 0.0 T))
								(setq #umpt$ (list (car #umpt$) (last #umpt$)))
								(setq #umpt$ (append #umpt$ #spt$))
							)
							(setq #upt$ (append #upt$ #spt$))
						)
					)
				)
			)
		)

		(list #bpt$ #upt$ #umpt$)
	) ; SCF_Aub_GetSym

	;<HOM>*************************************************************************
	; <関数名>    : SCF_A_DrawDim
	; <処理概要>  : Ａ型の寸法を作図
	; <戻り値>    : なし
	; <作成>      : 00/02/07
	;*************************************************************************>MOH<
	(defun SCF_A_DrawDim (
		&ss$
		&iti$       ; 寸法表示位置リスト
		/
		#ss #ss$ #pt$ #bpt #upt #all$ #ball$
		#i
		)
		(setq #i 0)
		(foreach #ss (apply 'append &ss$)
			;座標獲得
			(setq #pt$ (SCF_Aub_GetSym #ss (if (and (car &ss$) (< #i (length (car &ss$)))) "K" "D")))
			(setq #i (1+ #i))
			;ベース
			;	寸法表示位置 (高さ)
			;	基準座標 ... 現在の寸法表示位置を基準として作成 (足切り)
			;	寸法座標 ... 基準座標 から １行分下の位置とする
			; ただし、足切りするのは施工寸法のある場合のみ
			(if (/= nil (car #pt$))
				(progn
					(setq #bpt (car (nth 0 #pt$)))
	;					01/03/01 TM MOD 寸法線の足切り
					; 施工寸法がない場合は足切りしない
					(if (= (nth 1 &iti$) 0)
						; 足切りなし
						(progn
							(setq #dpt (polar #bpt (* 1.5 PI) (GetDimHeight (nth 1 &iti$))))
						)
						; 足切り
						(progn
							(setq #bpt (polar #bpt (* 1.5 PI) (GetDimHeight (1- (nth 1 &iti$)))))
							(setq #dpt (polar #bpt (* 1.5 PI) CG_DimHeight_1Line))
						)
					)
					(SCFDrawDimLin (nth 0 #pt$) #bpt #dpt "H")
					(setq #ball$ (append #ball$ (nth 0 #pt$)))
				)
			)
			;アッパー
			;	寸法表示位置 (高さ)
			;	基準座標 ... 現在の寸法表示位置を基準として作成 (足切り)
			;	寸法座標 ... 基準座標 から １行分上の位置とする
			; ただし、足切りするのは施工寸法のある場合のみ
			(if (and (/= nil (nth 0 #pt$)) (/= nil (nth 1 #pt$)))
				(progn
	; 01/04/11 TM MOD 天井高さから寸法を引くように変更
	;	         (if (= nil #bpt)
	;						(progn
	;							; 初回のみキャビネットの座標を用いる
	;	            (setq #bpt (nth 0 (nth 1 #pt$)))
	;						)
	;						; ２回目以降は相対計算
	;						(progn
	;	            (setq #bpt (nth 0 (nth 1 #pt$)))
	;							; 01/04/10 TM DEL 足切りがある場合はここでは上げない
	;          		;(setq #dpt (polar #bpt (* 0.5 PI) (GetDimHeight (nth 0 &iti$))))
	;						)
	;					)
	; 01/04/11 TM MOD  天井高さから寸法を引くように変更
					; 位置をキャビネット座標、高さを天井高さに設定
					(setq #bpt (nth 0 (nth 0 #pt$)))
					(setq #bpt (polar #bpt (* 0.5 PI) CG_CeilHeight))
	; 01/04/11 TM MOD  天井高さから寸法を引くように変更

					; 寸法表示基準位置を参考に、キャビネット寸法表示位置を計算する
					;	施工寸法がない場合は足切りしない
					(if (= (nth 0 &iti$) 0)
						; 足切りなし
						(progn
	; 01/04/11 TM DEL 天井高さから寸法を引くように変更
	;	       		(setq #bpt (polar #bpt (* 0.5 PI) CG_DimHeight_1Line))
							(setq #dpt (polar #bpt (* 0.5 PI) (GetDimHeight (nth 0 &iti$))))
						)
						; 足切り
						(progn
	;	01/04/11 TM MOD 天井高さから寸法を引くように変更
	;						(setq #bpt (polar #bpt (* 0.5 PI) (GetDimHeight (+ (nth 0 &iti$) 1))))
							(setq #bpt (polar #bpt (* 0.5 PI) (GetDimHeight (nth 0 &iti$))))
							; 寸法座標は上記で計算した座標の１行分上
							(setq #dpt (polar #bpt (* 0.5 PI) CG_DimHeight_1Line))
						)
					)
					(SCFDrawDimLin (nth 1 #pt$) #bpt #dpt "H")
				)
			)
			; 全体の寸法表示のために、もっとも外側(最後に描かれる)の基準寸法を記憶する
			(if (/= nil #bpt) (setq #upt #bpt))
			; 01/05/14 TM ADD ここの寸法が変。必ず最後の点が基点になってるので、ここで左右を考慮する必要はない？

			;全体をリストに格納
			(if (and (/= nil (nth 0 #pt$)) (/= nil (nth 1 #pt$))(/= nil (nth 2 #pt$)))
				(progn
					(setq #all$ (append #all$ (nth 2 #pt$)))
				)
			)
		)

		;全体
		(if (and &iti$ #all$ #upt #bpt)
			(progn
				;2000/07/12 U型で下側に寸法が作成される障害を改修
				;(SCFDrawDimLin #all$ #upt (polar #bpt (* 0.5 PI) (GetDimHeight (1+ (nth 0 &iti$)))) "H")
				; 01/03/02 TM MOD 足切り対応を追加
				;	施工寸法の有無(=足切りの有無)によって全体寸法の表示位置が変化する
				(if (= (nth 0 &iti$) 0)
					(progn
						(SCFDrawDimLin #all$ #upt (polar #upt (* 0.5 PI) (GetDimHeight (1+ (nth 0 &iti$)))) "H")
					)
					(progn
						(SCFDrawDimLin #all$ #upt (polar #upt (* 0.5 PI) (* CG_DimHeight_1Line 2)) "H")
					)
				)
			)
		)
		(if (and (= CG_PlanType "SD") (< 2 (length #ball$)))
			(progn
				(setq #ball$ (2dto3d (PtSort (3dto2d #ball$) 0.0 T)))
				(setq #ball$ (list (car #ball$) (last #ball$)))
				(if (= (nth 1 &iti$) 0)
					; 足切りなし
					(progn
						(SCFDrawDimLin #ball$ (car #ball$) (polar (car #ball$) (* 1.5 PI) (GetDimHeight (1+ (nth 1 &iti$)))) "H")
					)
					; 足切り
					(progn
						(setq #bpt (polar (car #ball$) (* 1.5 PI) (GetDimHeight (1- (nth 1 &iti$)))))
						(SCFDrawDimLin #ball$ #bpt (polar #bpt (* 1.5 PI) (* CG_DimHeight_1Line 2)) "H")
					)
				)

			)
		)


		(princ)
) ; SCF_A_DrawDim

;<HOM>*************************************************************************
; <関数名>    : DrawSideDim
; <処理概要>  : 左右の寸法を作図する
; <戻り値>    : なし
; <作成>      : 00/02/17
; <備考>      :
;*************************************************************************>MOH<
(defun DrawSideDim (
	&ss         ; モデル単数の選択エンティティ
	&flg        ; 左右フラグ("L","R")
	&layer      ; 画層名
	&bpt        ; 基準座標点
	&iti        ; 寸法作図位置
	/
	#i #en #code #pt$ #en$ #ptt$ #ent$ #ang #bpt #enpt$ #pt #base #en_n$ #basept
	#dMinMax$		; 領域最大／最小座標リスト
	#bh$        ; 04/04/13 SK ADD 変数宣言追加
	)
	;モデルフラグ獲得
	(setq #kd (nth 1 (CfGetXData (ssname &ss 0) "G_SKDM")))

	;キャビネットとカウンター天板とレンジフードを獲得
	(setq #i 0)
	(repeat (sslength &ss)
		(setq #en   (ssname &ss #i))
		(setq #code (CFGetSymSKKCode #en 1))
		(if
			(and
				;正面フラグ
				(= 1 (nth 3 (CfGetXData #en "G_SKDM")))
				;キャビネット
				(or
					(= CG_SKK_ONE_CAB #code)
					(= CG_SKK_ONE_CNT #code)
					(= CG_SKK_ONE_RNG #code)
				)
			)
			(progn
				; (setq #pt$ (Get2PointByLay #en))
				(setq #pt$ (Get2PointByLay #en 1))
			; 06/09/20 T.Ari Mod 台輪分浮いているベースキャビを考慮
				(if (= CG_SKK_TWO_BAS (CFGetSymSKKCode #en 2))
					(progn
						(setq #en$ (cons (list (polar (car #pt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM")))) #en) #en$))
						(setq #en$ (cons (list (polar (cadr #pt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM")))) #en) #en$))
						(setq #bh$ (cons (+ (nth 13 (CfGetXData #en "G_LSYM")) (nth 2 (nth 1 (CfGetXData #en "G_LSYM")))) #bh$))
					)
					(progn
						(setq #en$ (cons (list (car  #pt$) #en) #en$))
						(setq #en$ (cons (list (cadr #pt$) #en) #en$))
					)
				)
			)
		)
		;(setq #ptt$ (Get2PointByLay #en))
		(setq #ptt$ (Get2PointByLay #en 1))
		; 06/09/20 T.Ari Mod 台輪分浮いているベースキャビを考慮
		(if (= CG_SKK_TWO_BAS (CFGetSymSKKCode #en 2))
			(progn
				(setq #ent$ (cons (list (polar (car #ptt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM")))) #en) #ent$))
				(setq #ent$ (cons (list (polar (cadr #ptt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM")))) #en) #ent$))
			)
			(progn
				(setq #ent$ (cons (list (car  #ptt$) #en) #ent$))
				(setq #ent$ (cons (list (cadr #ptt$) #en) #ent$))
			)
		)
		(setq #i (1+ #i))
	)

	;ベースキャビネット高さ
	(setq #bh (apply 'max #bh$))
	;座標ソート
	(setq #en$  (SCFmg_sort$ 'caar #en$))
	(setq #ent$ (SCFmg_sort$ 'caar #ent$))
	(if (= "L" &flg)
		(progn
			(setq #ang PI)
			; 01/08/02 TM ADD 座標の左下固定
			(setq #bpt
				(list
					(car (KCFCmnListMinMax (mapcar 'car (mapcar 'car #en$))))
					(car (KCFCmnListMinMax (mapcar 'cadr (mapcar 'car #en$))))
					(car (KCFCmnListMinMax (mapcar 'caddr (mapcar 'car #en$))))
				)
			)
		)
		(progn
			(setq #ang 0.0)
			(setq #en$  (reverse #en$))
			(setq #ent$ (reverse #ent$))
			; 01/08/02 TM ADD 座標の右下固定
			(setq #bpt
				(list
					(cadr (KCFCmnListMinMax (mapcar 'car (mapcar 'car #en$))))
					(car (KCFCmnListMinMax (mapcar 'cadr (mapcar 'car #en$))))
					(car (KCFCmnListMinMax (mapcar 'caddr (mapcar 'car #en$))))
				)
			)
		)
	)

	; 01/08/02 TM MOD 座標点領域の右下／左下を検索するように変更
	;(setq #bpt (car (car #en$)))
	(foreach  #enpt$ #en$
		(setq #pt (car  #enpt$))
		(setq #en (cadr #enpt$))
		(setq #code (CFGetSymSKKCode #en 2))
		; ベースキャビネットと同じ座標のもののみ
;;;		(if (equal (car #bpt) (car #pt) 0.01)

;;;(if (= BU_CODE_0012 "1") ; フレームキッチンの場合


						;2018/10/03 YM ADD-S 寸法点に円を書く  <<<後で消す>>>
;;;						(command "_circle" #bpt 10.0)
;;;						(command "_circle" #pt 20.0)
;;;						(command "_REGEN")
						;2018/10/03 YM ADD-E 寸法点に円を書く


		;2017/09/21 YM ADD ﾌﾚｰﾑｷｯﾁﾝの場合は通す(正面縦寸法を作図する)
		(if (or (= BU_CODE_0012 "1") (equal (car #bpt) (car #pt) 25.01)) ;2018ｶｯﾌﾟﾎﾞｰﾄﾞ対応ｶｳﾝﾀｰﾄﾌﾟ勝ち25mm開いている 2019/01/11 YM ADD
;;;		(if (or (= BU_CODE_0012 "1") (equal (car #bpt) (car #pt) 6.01)) ;小間口対応天板と5mm開いている 2017/01/27 YM ADD
			(if (= CG_SKK_TWO_BAS #code)
				(progn
					(if (/= CG_SKK_ONE_CNT (CFGetSymSKKCode #en 1))
						(setq #base #en)
						;else
						(setq #en_n$ (cons #en #en_n$))
					)
				)
				;else
				(setq #en_n$ (cons #en #en_n$))
			);_if

		);_if

	)

	(if (/= #base nil)
		(progn
			(setq #en$ (cons #base #en_n$))

			(setq #basept (car (car #ent$)))
			;寸法作図
			(if (= "K" #kd)
				(if (= "L" &flg)
; 01/08/02 TM MOD 基準点を指定するように変更
;          (SCF_B_DrawDim_Kit &layer #en$ #ang &bpt &iti 1 #bh)
;          (SCF_B_DrawDim_Kit &layer #en$ #ang &bpt &iti 0 #bh)
					(SCF_B_DrawDim_Kit &layer #en$ #ang #bpt &iti 1 #bh)
					(SCF_B_DrawDim_Kit &layer #en$ #ang #bpt &iti 0 #bh)
				)
			 	(if (= "R" &flg)
; 01/08/10 TM MOD 基準点を指定するように変更
;       		(SCF_B_DrawDim_Din &layer #en$ #ang &bpt &iti 1)
;       		(SCF_B_DrawDim_Din &layer #en$ #ang &bpt &iti 0)
			 		(SCF_B_DrawDim_Din &layer #en$ #ang #bpt &iti 1)
			 		(SCF_B_DrawDim_Din &layer #en$ #ang #bpt &iti 0)
				)
			)
		)
	)

	(princ)
) ; DrawSideDim

;<HOM>*************************************************************************
; <関数名>    : KCFCmnListMinMax
; <処理概要>  : 指定した(実数)リストの最小／最大値を取得する
; <戻り値>    : (最小値 最大値)
; <作成>      : 01/08/02
;*************************************************************************>MOH<
(defun KCFCmnListMinMax (
	&rlst$	; リスト
	/
	#dRet$
	)

	(setq #dRet$
		(list
			(eval (append (list 'min) &rlst$))
			(eval (append (list 'max) &rlst$))
		)
	)
	#dRet$

); KCFCmnListMinMax

;<HOM>*************************************************************************
; <関数名>    : SCF_B_DrawDim_Kit
; <処理概要>  : Ｂ型の寸法を作図（キッチン）
; <戻り値>    : なし
; <作成>      : 00/02/03
;*************************************************************************>MOH<
(defun SCF_B_DrawDim_Kit (
	&layer      ; 画層
	&sym$       ; 寸法を作図するシンボル図形名（ベース アッパーその他）
	&ang        ; 寸法を出力する角度
	&bpt        ; 基準位置座標(nilのときベースの座標)
	&iti        ; 寸法作図位置
	&flg        ; 天井高さ寸法出力フラグ（1=ON 1以外=OFF）
	&bh         ; ベースキャビネット高さ
	/
	#en
	#code$ 			; 性格CODE
	#tenb #wt$ #bsym #ed$ #bpt #ang #bpt2 #base #tbpt2 #bg #sym #upt #upt$ #ceil #pt$
	#xDimPt			; 寸法座標     01/03/07 TM ADD  寸法線足切り用
	#eBFbas			; ビーフリー台 01/08/01 TM ADD
	#pt0        ; 床高さ       01/09/23 HN ADD
	)
	(foreach #en (cdr &sym$)
		(setq #code$ (CFGetSymSKKCode #en nil))
		(if (= CG_SKK_ONE_CNT (nth 0 #code$))
			(setq #tenb #en)
		)

	)

	;ワークトップデータ獲得
	(setq #wt$ (car (SCFGetWrktXdata &layer)))

	;ベース位置
	(setq #bsym (car  &sym$))
 	(setq #ed$  (CfGetXData #bsym "G_SYM"))
 	(setq #bpt  (cdrassoc 10 (entget #bsym)))
	; 06/09/20 T.Ari Add 台輪分浮いているベースキャビを考慮
 	(setq #bpt (polar #bpt (* PI 1.5) (nth 2 (nth 1 (CfGetXData #bsym "G_LSYM")))))

	;基準座標
	(if (/= nil &bpt)
		(setq #base &bpt)
		(setq #base #bpt)
	)

	; H方向フラグを取得
	(if (= 1 (nth 10 #ed$))
		(setq #ang (* PI 0.5))
		(setq #ang (* PI 1.5))
	)
	(setq #ed$  (CfGetXData #bsym "G_LSYM"))
;  (if (/= nil #tenb)
;    (setq #bpt2 (polar #bpt #ang                (nth 13 #ed$)))
; 2000/06/308 HT バックガード位置寸法位置不正の障害改修
;                ワークトップの下端取付寸法とする
	;    (setq #bpt2 (polar #bpt #ang (+ (cadr #wt$) (nth 13 #ed$))))
	; (setq #bpt2 (polar #bpt #ang (+ (cadr #wt$) &bh)))
	; 01/03/26 HN S-MOD バックガードなしを想定
	(if #wt$
		; 01/08/02 TM MOD 基準寸法を基準にするように変更
		;(setq #bpt2 (polar #bpt #ang (+ (nth 1 #wt$) (nth 4 #wt$))))
		(setq #bpt2 (polar #base #ang (+ (nth 1 #wt$) (nth 4 #wt$))))
	)
	; 01/03/26 HN E-MOD バックガードなしを想定
;  )

	;ＢＧ高さ
	; 01/05/24 TM ADD ワークトップがない場合、BGもないはず
	(if #wt$
		(if (/= nil #tenb)
			(progn
				; 01/08/02 TM MOD 基準寸法を基準にするように変更
				;(setq #tbpt2 (polar #bpt #ang (+ (cadr #wt$) &bh)))
				(setq #tbpt2 (polar #base #ang (+ (cadr #wt$) &bh)))
				(setq #bg   (polar #tbpt2 (* PI 0.5) (nth 3 #wt$)))
			)
			; 01/03/26 HN S-MOD バックガードなしを想定
			(if #wt$
				(setq #bg   (polar #bpt2 (* PI 0.5) (nth 3 #wt$)))
			)
			; 01/03/26 HN E-MOD バックガードなしを想定
		)
	)

	;その他のシンボル位置
	(foreach #sym (cdr &sym$)
		(if (not (equal #tenb #sym))
			(progn
				(setq #ed$  (CfGetXData #sym "G_SYM"))
				(setq #upt  (cdrassoc 10 (entget #sym)))
				(setq #upt$ (cons #upt #upt$))
				; H方向フラグ 1=正常
				(if (= 1 (nth 10 #ed$))
					(setq #ang (* PI 0.5))
					(setq #ang (* PI 1.5))
				)
				; シンボル基準値H
				(setq #upt (polar #upt #ang (nth 5 #ed$)))
				(setq #upt$ (cons #upt #upt$))
			)
		)
	)

	; 01/09/23 HN S-MOD 寸法に床高さを追加
	;@MOD@; 天井高さ
	;@MOD@; 01/08/02 TM MOD 基準寸法を基準にするように変更
	;@MOD@;(setq #ceil (polar #bpt (* PI 0.5) CG_CeilHeight))
	;@MOD@(setq #ceil (polar #base (* PI 0.5) CG_CeilHeight))
	;@MOD@
	;@MOD@;座標をまとめる
	;@MOD@; 01/08/02 TM MOD 基準寸法を基準にするように変更
	;@MOD@;(setq #pt$ (append #upt$ (list #bpt #bpt2 #bg #ceil)))
	;@MOD@(setq #pt$ (append #upt$ (list #base #bpt2 #bg #ceil)))

;2008/07/03 YM ADD
; 本ファイルのロード時に床高さを取得
(setq CG_BaseHeight (SCFGetBaseHeight))

	(if CG_BaseHeight
		(progn
			(setq #ceil (polar #base (* PI 0.5) (- CG_CeilHeight CG_BaseHeight)))
			(setq #pt0 (list (car #base) (- (cadr #base) CG_BaseHeight) (caddr #base)))
			(setq #pt$ (append #upt$ (list #pt0 #base #bpt2 #bg #ceil)))
		)
		(progn
			(setq #ceil (polar #base (* PI 0.5) CG_CeilHeight))
			(setq #pt$ (append #upt$ (list #base #bpt2 #bg #ceil)))
		)
	);_if
	; 01/09/23 HN E-MOD 寸法に床高さを追加

	; 01/03/07 TM MOD 側面の寸法も足切りする
	; 寸法座標を作成
	; 施工寸法が存在する場合、施工寸法表示の分寸法座標を移動
	(if (/= nil #pt$)
		(setq #xDimPt (polar #base &ang (GetDimHeight (1+ &iti))))
		(setq #xDimPt (polar #base &ang (GetDimHeight &iti)))
	)

	;	位置データが存在する場合、基準座標を嵩上げする (= 足切り)
	(if (/= 0 &iti)
		(setq #base (polar #xDimPt (+ PI &ang) CG_DimHeight_1Line))
	)
	;キャビネット割寸法作図
	; 01/03/07 TM MOD 側面の寸法も足切りする
	;  (SCFDrawDimLin #pt$ #base (polar #base &ang (GetDimHeight &iti)) "V")
	(SCFDrawDimLin #pt$ #base #xDimPt "V")

	;天井高さ寸法作図
	(if (= 1 &flg)
		(progn
			(setq #pt$ (PtSort #pt$ (* 0.5 PI) T))
			(setq #pt$ (list (car #pt$) (last #pt$)))
	; 01/03/07 TM MOD 側面の寸法も足切りする
	;   (SCFDrawDimLin #pt$ #base (polar #base &ang (GetDimHeight (1+ &iti))) "V")
			(SCFDrawDimLin #pt$ #xDimPt (polar #xDimPt &ang  CG_DimHeight_1Line) "V")
		)
	)

	(princ)
) ; SCF_B_DrawDim_Kit


;<HOM>*************************************************************************
; <関数名>    : SCF_B_DrawDim_Din
; <処理概要>  : Ｂ型の寸法を作図（ダイニング）
; <戻り値>    : なし
; <作成>      : 00/02/17
;*************************************************************************>MOH<
(defun SCF_B_DrawDim_Din (
	&layer      ; 画層
	&sym$       ; 寸法を作図するシンボル図形名（ベース アッパーその他）
	&ang        ; 寸法を出力する角度
	&bpt        ; 基準位置座標
	&iti        ; 寸法作図位置
	&flg        ; 天井高さ寸法出力フラグ（1=ON =OFF）
	/
	#en #code #temb #en$ #bsym #ed$ #bpt #ang #bpt2 #sym #upt #upt$ #ceil #pt$ #bg
	#xDimPt			; 寸法座標  01/03/07 TM ADD  寸法線足切り
	#pt0        ; 床高さ    01/09/23 HN ADD
	#BASE #CODE$ #COOK-FLG #DUM$ #SCOOKFREE #TSENMEN_CT #WT$ ; 02/12/16 YM ADD
	#taimen$ #tDepth #tAng  ; 対面情報 04/03/25 SK ADD
	#tembH                  ; 天板情報 04/03/25 SK ADD
	ftpType                 ; フラットプランタイプ "SF":セミフラット "FF":フルフラット
	#sLongBg #rLongBg-Minus #rLongBg-BG #LongBg	;06/07/13 T.Ari ADD コンロキャビバックガード対応
	#CookFree$ #CookFree$$ #LongBg$ #LongBg$$	;06/08/01 T.Ari ADD CookFree & LongBg ini->DB
	#hinban #CookFree	;06/08/01 T.Ari ADD CookFree & LongBg ini->DB
	#counters$$ ; カウンター情報リスト(フレームキッチン用)
	#ct #counter$
	)



;|
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	; 04/03/25 SK ADD-S 対面プラン対応
	; 対面プランの展開ＢＤ寸法の対応
	(if (setq #ftpType (SCFIsTaimenFlatPlan))
		(progn
			; 対面側となるキャビの奥行きと奥行き角度を求める
			;2008/08/13 YM DEL
;;;      (setq #taimen$ (SCFGetTaimenFlatPlanInfo &sym$));nilが返ってしまうので対面とみなされない

;;;      (if #taimen$ ;2008/08/13 YM DEL
				(cond
;2008/08/13 YM DEL
;;;          ((= #ftpType "SF")
;;;            ; 寸法作図開始点を奥行きを見こした位置に調整する
;;;            (setq #tDepth (car  #taimen$))
;;;            (setq #tAng   (cadr #taimen$))
;;;            (setq #tAng (+ #tAng pi))
;;;            (setq #tDepth (nth 4 (CFGetXData (car &sym$) "G_SYM")))
;;;            (setq &bpt (polar &bpt #tAng #tDepth))
;;;            (setq &ang (+ &ang pi))
;;;          )
;;;          ((= #ftpType "FF")
;;;            ; 寸法作図開始点を奥行きを見こした位置に調整する
;;;            (setq #tDepth (car  #taimen$))
;;;            (setq #tAng   (cadr #taimen$))
;;;            (setq &bpt (polar &bpt #tAng #tDepth))
;;;          )

					; 寸法作図開始点を奥行きを見こした位置に調整する
					((= #ftpType "D105")
						(setq #tDepth 400)
						(setq &bpt (polar &bpt &ang #tDepth))
					)


					;2009/04/17 YM ADD-S ｹﾞｰﾄﾀｲﾌﾟ
					((= #ftpType "D650")
						(setq #tDepth 350)
						(setq &bpt (polar &bpt &ang #tDepth))
					)
					;2009/04/17 YM ADD-E


					((= #ftpType "D970")
						(setq #tDepth 320)
						(setq &bpt (polar &bpt &ang #tDepth))
					)
					((= #ftpType "D900")
						(setq #tDepth 250)
						(setq &bpt (polar &bpt &ang #tDepth))
					)
					(T
					 	nil
				 	)
				);_cond
;;;      );_if
		)
	);_if
|;
	; 04/03/25 SK ADD-E 対面プラン対応
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	;天板のシンボル獲得
	(setq #tSENMEN_CT nil); 01/09/05 YM ADD 洗面ｶｳﾝﾀｰあり==>T

	; 02/06/19 YM ADD-S 臨時処理追加 /////////////////////////////////////////////
	; ｳｫｰﾙがないﾌﾟﾗﾝのとき&sym$にｺﾝﾛが2つ入る→展開Ｄ図の高さ方向の寸法
	; でWT付近の寸法がおかしい(ｺﾝﾛの寸法を書いている)
	; &sym$のうち性格ｺｰﾄﾞ210のものは除外する処理を追加するとうまくいった.
	(setq #dum$ nil)
	(foreach sym &sym$
		(if (and sym (= CG_SKK_INT_GAS (nth 9 (CFGetXdata sym "G_LSYM"))))
			nil
		;else
			(setq #dum$ (append #dum$ (list sym)))
		);_if
	)
	(setq &sym$ #dum$)

	; 02/06/19 YM ADD-E 臨時処理追加 /////////////////////////////////////////////
	(foreach #en (cdr &sym$)
		(if #en
			(progn
				(setq #code  (CFGetSymSKKCode #en 1))
				(setq #code$ (CFGetSymSKKCode #en nil)) ; 01/09/05 YM ADD

				; カウンター天板ならシンボル基準値Hを取得
				; それ以外なら図形名取得
				; 01/09/05 YM MOD-S
				(if (= CG_SKK_ONE_CNT #code) ; ｶｳﾝﾀｰだった
					(progn
						(setq #temb (nth 5 (CfGetXData #en "G_SYM"))) ; 厚み

						;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
						; 04/03/25 SK ADD-S 対面プラン対応
						(setq #tembH (nth 2 (nth 1 (CfGetXData #en "G_LSYM"))))
						; 04/03/25 SK ADD-E 対面プラン対応
						;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

						(if (= (caddr #code$) CG_SKK_THR_ETC) ; 洗面ｶｳﾝﾀｰだった
							(setq #tSENMEN_CT T)
						);_if
					)
					(setq #en$ (cons #en #en$))
				);_if
				; 01/09/05 YM MOD-E

;;;01/09/05YM@MOD				(if (= CG_SKK_ONE_CNT #code)
;;;01/09/05YM@MOD					(setq #temb (nth 5 (CfGetXData #en "G_SYM")))
;;;01/09/05YM@MOD					(setq #en$ (cons #en #en$))
;;;01/09/05YM@MOD				)

			)
		)
	)
	; カウンター天板なかったら、0に初期化
	(if (= nil #temb) (setq #temb 0))

	;ベース
	(setq #bsym (car  &sym$))
	(setq #ed$  (CfGetXData #bsym "G_SYM"))

	; 図形自身から取得
	(if (or (= CG_DRSeriCodeRV nil) (= CG_DRSeriCodeRV ""))
		; RV 以外は基点
		(progn
			(setq #bpt  (cdrassoc 10 (entget #bsym)))
			; 06/09/20 T.Ari Add 台輪分浮いているベースキャビを考慮
			(setq #bpt (polar #bpt (* PI 1.5) (nth 2 (nth 1 (CfGetXData #bsym "G_LSYM")))))
		)
		; RV の場合、正面位置を基点とする
		(progn
			(setq #bpt (nth 2 (GetSym4Pt #bsym)))
			; 06/09/20 T.Ari Add 台輪分浮いているベースキャビを考慮
			(setq #bpt (polar #bpt (* PI 1.5) (nth 2 (nth 1 (CfGetXData #bsym "G_LSYM")))))
		)
	)
	; 01/08/10 TM MOD 位置を移動
	;基準座標
	(if (/= nil &bpt)
		(setq #base &bpt)
		(setq #base #bpt)
	)

	; 01/03/07 TM MOD 側面の寸法も足切りする
	; H方向フラグが正常
	(if (= 1 (nth 10 #ed$))
		(setq #ang (* PI 0.5))
		(setq #ang (* PI 1.5))
	)
	(setq #ed$  (CfGetXData #bsym "G_LSYM"))

	;ワークトップデータ獲得  (シンク穴なしWTの場合(D-RIGHT)の対応)
	; 2000/08/28 HT
	(setq #wt$ (car (SCFGetWrktXdata &layer)))
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	; 04/03/25 SK ADD-S 対面プラン対応
	; 対面Ｅの収納部は天板割の寸法とする
	(if (and #ftpType (/= #temb 0))
		(setq #wt$ (list "" 0.0 1 #temb #tembH))
	)
	; 04/03/25 SK ADD-E 対面プラン対応
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	(if (= (car #wt$) nil)
		(progn
			; 基準点 から (寸法H + カウンター天板シンボル基準値H)の高さ位置
			; 01/08/02 TM MOD 基準寸法を基準にするように変更
			;(setq #bpt2 (polar #bpt #ang (+ #temb (nth 13 #ed$))))
			(setq #bpt2 (polar #base #ang (+ #temb (nth 13 #ed$))))
			(setq #bpt2 (polar #bpt2 (* PI 0.5) (nth 2 (nth 1 (CfGetXData #bsym "G_LSYM")))))

		;;;01/06/29YM@		(setq #bg nil)
			; WTがないﾐﾆｷｯﾁﾝにもBG寸法をかく01/06/29 YM ADD START

			; 01/09/05 YM MOD-S
			(if (or (KPCheckMiniKitchen &sym$)
							(and (KP_CT_EXIST) #tSENMEN_CT)) ; 洗面ﾍﾞﾙﾌｫﾝﾃ対応ｼﾘｰｽﾞ且つ洗面ｶｳﾝﾀｰあり 01/09/05 YM
			; 01/09/05 YM MOD-E
;;;01/09/05YM@MOD			(if (KPCheckMiniKitchen &sym$)

				; 02/12/16 YM MOD ﾐﾆｷｯﾁﾝｸｸﾌﾘｰならBG高さ45mmそれ以外50mm
				(progn
;|
					(setq #sCookFree-Snk (CFgetini "COOKFREE" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
					(setq #rSnk-BG       (CFgetini "COOKFREE" "0002" (strcat CG_SKPATH "ERRMSG.INI")))
					(setq #sCookFree-Gas (CFgetini "COOKFREE" "0003" (strcat CG_SKPATH "ERRMSG.INI")))
					(setq #rGas-BG       (CFgetini "COOKFREE" "0004" (strcat CG_SKPATH "ERRMSG.INI")))
;06/07/13 T.Ari ADD-S コンロキャビバックガード対応
					(setq #sLongBg        (CFgetini "LONGBG"    "0001" (strcat CG_SKPATH "ERRMSG.INI")))
					(setq #rLongBg-Minus  (CFgetini "LONGBG"    "0002" (strcat CG_SKPATH "ERRMSG.INI")))
					(setq #rLongBg-BG     (CFgetini "LONGBG"    "0003" (strcat CG_SKPATH "ERRMSG.INI")))
;06/07/13 T.Ari ADD-E コンロキャビバックガード対応
					(setq #Cookflg-Snk nil)
					(setq #Cookflg-Gas nil)
|;
					(setq #CookFree$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from COOKFREE")))
					(setq #LongBg$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from LONGBG")))
					(setq #CookFree nil)
					(setq #LongBg nil)	;06/07/13 T.Ari ADD コンロキャビバックガード対応
					(foreach #sym &sym$
						(if #sym ; 03/01/07 YM ADD #sym = nil 対策
							(progn
								(setq #hinban (nth 5 (CFGetXData #sym "G_LSYM")))
								(if #CookFree$$
									(foreach #CookFree$ #CookFree$$
										(if (wcmatch #hinban (car #CookFree$))
											(setq #CookFree (cdr #CookFree$))
										)
									)
								)
								(if #LongBg$$
									(foreach #LongBg$ #LongBg$$
										(if (wcmatch #hinban (car #LongBg$))
											(setq #LongBg (cdr #LongBg$))
										)
									)
								)
;|
								(if (wcmatch (nth 5 (CFGetXData #sym "G_LSYM")) #sCookFree-Snk)
									(setq #Cookflg-Snk T) ; ｸｯｸﾌﾘｰｼﾝｸありと判断
								);_if
								(if (wcmatch (nth 5 (CFGetXData #sym "G_LSYM")) #sCookFree-Gas)
									(setq #Cookflg-Gas T) ; ｸｯｸﾌﾘｰｶﾞｽありと判断
								);_if
;06/07/13 T.Ari ADD-S コンロキャビバックガード対応
								(if (wcmatch (nth 5 (CFGetXData #sym "G_LSYM")) #sLongBg)
									(setq #LongBg T) ; ｸｯｸﾌﾘｰｶﾞｽありと判断
								);_if
;06/07/13 T.Ari ADD-E コンロキャビバックガード対応
|;
							)
						);_if
					)

					(cond
						(#CookFree
							(setq #bg (polar #bpt2 (* PI 0.5) (car #CookFree)))
						)
						(#LongBg
							(setq #bpt2 (polar #bpt2 (* PI 1.5) (car #LongBg)))
							(setq #bg (polar #bpt2 (* PI 0.5) (cadr #LongBg)))
						)
;|
						(#Cookflg-Snk
							(setq #bg (polar #bpt2 (* PI 0.5) (atof #rSnk-BG)))
					 	)
						(#Cookflg-Gas
							(setq #bg (polar #bpt2 (* PI 0.5) (atof #rGas-BG)))
					 	)
;06/07/13 T.Ari ADD-S コンロキャビバックガード対応
						(#LongBg
							(progn
								(setq #bpt2 (polar #bpt2 (* PI 1.5) (atof #rLongBg-Minus)))
								(setq #bg (polar #bpt2 (* PI 0.5) (atof #rLongBg-BG)))
							)
					 	)
;06/07/13 T.Ari ADD-E コンロキャビバックガード対応
|;
						(T
							(setq #bg (polar #bpt2 (* PI 0.5) CG_BG_H))
					 	)
					);_if
				)
				; 02/12/16 YM MOD ﾐﾆｷｯﾁﾝｸｸﾌﾘｰならBG高さ45mmそれ以外50mm

			; else
			 	; 2017/06/09 KY MOD-S
			 	; フレームキッチン対応
				;(setq #bg nil)
				(progn
					(setq #bg nil)
					(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
						(progn
							(setq #counters$$ (nth 1 (GetFrameInfo$$ nil T))) ; カウンター情報の取得
							(if #counters$$
								(progn
									(foreach #counter$ #counters$$
										(setq #ct (nth 2 (nth 3 #counter$))) ; カウンターの厚み
										(if (and (= nil #bg) (> #ct 0))
											(progn
												(setq #bpt2 (nth 1 #counter$))
												(setq #bpt2 (list (nth 0 #bpt2) (nth 1 #bpt2) 0.0))
												(setq #bg (polar #bpt2 (* PI 0.5) #ct)) ; カウンターの厚み
											);progn
										);if
									);foreach
								);progn
							);if
						);progn
					);if
				);progn
			 	; 2017/06/09 KY MOD-E
			);_if
			; WTがないﾐﾆｷｯﾁﾝにもBG寸法をかく01/06/29 YM ADD END
		)
		(progn
			; ワークトップの下端取付寸法とする
			; 01/08/02 TM MOD 基準寸法を基準にするように変更
			;(setq #bpt2 (polar #bpt #ang (+ (nth 1 #wt$) (nth 4 #wt$))))
			(setq #bpt2 (polar #base #ang (+ (nth 1 #wt$) (nth 4 #wt$))))
			;ＢＧ高さ
			(setq #bg   (polar #bpt2 (* PI 0.5) (nth 3 #wt$)))
		)
	)
	;その他のシンボル位置
	(foreach #sym	#en$
		(setq #ed$  (CfGetXData #sym "G_SYM"))
		(setq #upt  (cdrassoc 10 (entget #sym)))
		(setq #upt$ (cons #upt #upt$))
		(if (= 1 (nth 10 #ed$))
			(setq #ang (* PI 0.5))
			(setq #ang (* PI 1.5))
		)
		(setq #ed$ (CfGetXData #sym "G_LSYM"))

		; 基準点 から 寸法Hの高さ位置
		(setq #upt (polar #upt #ang (nth 13 #ed$)))
		; 基準点 から 寸法Hの高さ位置リスト
		(setq #upt$ (cons #upt #upt$))
	)

	; 01/09/23 HN MOD 寸法に床高さを追加
	;@MOD@;天井高さ
	;@MOD@; 01/08/02 TM MOD 基準寸法を基準にするように変更
	;@MOD@;(setq #ceil (polar #bpt (* PI 0.5) CG_CeilHeight))
	;@MOD@(setq #ceil (polar #base (* PI 0.5) CG_CeilHeight))
	;@MOD@
	;@MOD@;座標をまとめる
	;@MOD@; WTがある場合とない場合
	;@MOD@;(setq #pt$ (append #upt$ (list #bpt #bpt2 #ceil)))
	;@MOD@(if #bg
	;@MOD@	; 01/08/02 TM MOD 基準寸法を基準にするように変更
	;@MOD@	;(setq #pt$ (append #upt$ (list #bpt #bpt2 #bg #ceil)))
	;@MOD@	(setq #pt$ (append #upt$ (list #base #bpt2 #bg #ceil)))
	;@MOD@	; 01/08/02 TM MOD 基準寸法を基準にするように変更
	;@MOD@	;(setq #pt$ (append #upt$ (list #bpt #bpt2 #ceil)))
	;@MOD@	(setq #pt$ (append #upt$ (list #base #bpt2 #ceil)))
	;@MOD@)

	(if CG_BaseHeight
		(progn
			(setq #ceil (polar #base (* PI 0.5) (- CG_CeilHeight CG_BaseHeight)))
			(setq #pt0 (list (car #base) (- (cadr #base) CG_BaseHeight) (caddr #base)))
			(if #bg
				(setq #pt$ (append #upt$ (list #pt0 #base #bpt2 #bg #ceil)))
				(setq #pt$ (append #upt$ (list #pt0 #base #bpt2     #ceil)))
			)
		);_progn
		(progn
			(setq #ceil (polar #base (* PI 0.5) CG_CeilHeight))
			(if #bg
				(setq #pt$ (append #upt$ (list #base #bpt2 #bg #ceil)))
				(setq #pt$ (append #upt$ (list #base #bpt2     #ceil)))
			)
		);_progn
	);_if
	; 01/09/23 HN E-ADD 寸法に床高さを追加

	; 寸法座標を作成
	; 施工寸法が存在する場合、施工寸法表示の分寸法座標を移動
	(if (/= nil #pt$)
		(setq #xDimPt (polar #base &ang (GetDimHeight (1+ &iti))))
	)

	;	位置データが存在する場合、基準座標を嵩上げする (= 足切り)
	(if (/= 0 &iti)
		(progn
			(setq #base (polar #xDimPt (+ PI &ang) CG_DimHeight_1Line))
		)
	)

	;キャビネット割寸法図
	(SCFDrawDimLin #pt$ #base #xDimPt "V")

	;天井高さ寸法作図
	(if (= 1 &flg)
		(progn
			(setq #pt$ (PtSort #pt$ (* 0.5 PI) T))
			(setq #pt$ (list (car #pt$) (last #pt$)))
			; 2000/06/19 HT SCF_B_DrawDim_Kitと同じ扱いにした  &bpt => #base
			; (SCFDrawDimLin #pt$ &bpt (polar &bpt &ang (GetDimHeight (1+ &iti))) "V")
			; (SCFDrawDimLin #pt$ &bpt (polar #base &ang (GetDimHeight (1+ &iti))) "V")
			; 01/03/07 TM MOD 側面の寸法も足切りする
			; (SCFDrawDimLin #pt$ #base (polar #base &ang (GetDimHeight (1+ &iti))) "V")
			(SCFDrawDimLin #pt$ #xDimPt (polar #xDimPt &ang  CG_DimHeight_1Line) "V")
		)
	)
	(princ)
) ; SCF_B_DrawDim_Din


;<HOM>*************************************************************************
; <関数名>    : GetModelSideDim
; <処理概要>  : 縦寸法のモデルシンボルを獲得
; <戻り値>    : （左右モデル選択エンティティリスト 左右の基点座標）
; <作成>      : 00/02/17
;*************************************************************************>MOH<
(defun GetModelSideDim (
	&ss$        ; 選択エンティティリスト
	/
	#ss #ss$ #flg #x #i #en #2pt$ #pt$ #list$ #ssret$
	#ssModel	; モデルNo. ごとの選択セット
	#eModel		; 図形名
	#nII			; 操作変数
	)
	;フラグと、選択エンティティ獲得
; 01/08/10 TM MOD(1)-S オリジナルのソース
;	(foreach #ss (car &ss$)
;		(setq #ss$ (cons (list "K" #ss) #ss$))
;  )
;	(foreach #ss (cadr &ss$)
;		(setq #ss$ (cons (list "D" #ss) #ss$))
;	)
; 01/08/10 TM MOD(1)-E オリジナルのソース

; 01/08/10 TM MOD(2)-S とりあえず動くものを残しておく。
; ただし、K と D のモデルが同じ側にあると寸法が重なる。
;	(princ "\n開始: ")
;	(princ (car &ss$))
;	(if (car &ss$)
;		(progn
;			; キッチン
;			(setq #ssModel (ssadd))
;			(foreach #ss (car &ss$)
;				(setq #nII 0)
;				(repeat (sslength #ss)
;					(setq #ssModel (ssadd (ssname #ss #nII) #ssModel))
;					(setq #nII (1+ #nII))
;				)
;			)
;			(if #ssModel
;				(progn
;					(setq #ss$ (cons (list "K" #ssModel) #ss$))
;					(princ "\n#ss$+: ")
;					(princ #ss$)
;				)
;			)
;		)
;	)
;	(princ "\n開始: ")
;	(princ (cadr &ss$))
;	(if (cadr &ss$)
;		(progn
;			; ダイニング
;			(setq #ssModel (ssadd))
;			(foreach #ss (cadr &ss$)
;				(setq #nII 0)
;				(repeat (sslength #ss)
;					(setq #ssModel (ssadd (ssname #ss #nII) #ssModel))
;					(setq #nII (1+ #nII))
;				)
;			)
;			(if #ssModel
;				(progn
;					(setq #ss$ (cons (list "D" #ssModel) #ss$))
;					(princ "\n#ss$*")
;					(princ #ss$)
;				)
;			)
;		)
;	)
; 01/08/10 TM MOD(2)-E とりあえず動くものを残しておく。

	; 01/08/10 TM MOD-S 全外形をまとめて一つのデータとして扱う
	; キッチンのモデルデータを追加
	(if (car &ss$)
		(progn
			(if (not #ssModel) (setq #ssModel (ssadd)))
			(foreach #ss (car &ss$)
				(setq #nII 0)
				(repeat (sslength #ss)
					(setq #ssModel (ssadd (ssname #ss #nII) #ssModel))
					(setq #nII (1+ #nII))
				)
			)
		)
	)

	; ダイニングのモデルデータを追加
	(if (cadr &ss$)
		(progn
			(if (not #ssModel) (setq #ssModel (ssadd)))
			(foreach #ss (cadr &ss$)
				(setq #nII 0)
				(repeat (sslength #ss)
					(setq #ssModel (ssadd (ssname #ss #nII) #ssModel))
					(setq #nII (1+ #nII))
				)
			)
		)
	)

	; 全モデルデータを"K" として統合
	(if #ssModel
		(progn
			(setq #ss$ (cons (list "K" #ssModel) #ss$))
		)
	)

	; 01/08/10 TM MOD 以降の関数でデータが左右分必要なため、両方に配分する
	(if (= 1 (length #ss$))
		(progn
			(setq #ss$$ (append #ss$ #ss$))
		)
		(progn
			(setq #ss$$ #ss$)
		)
	)
	; 01/08/10 TM MOD-S 全外形をまとめて一つのデータとして扱う

	;各モデルの座標獲得
	(foreach #ss$ #ss$$
		(setq #flg   (car  #ss$))
		(setq #ss    (cadr #ss$))
		;X座標
		(setq #x     (car (car (Get2PointByLay (ssname #ss 0) 1))))
		;左右の座標
		(setq #i 0)
		(repeat (sslength #ss)
			(setq #en (ssname #ss #i))
			(setq #2pt$ (Get2PointByLay #en 1))
			(setq #pt$ (cons (car  #2pt$) #pt$))
			(setq #pt$ (cons (cadr #2pt$) #pt$))
			(setq #i (1+ #i))
		)
		(setq #list$ (cons (list #x #flg #ss) #list$))
	)
	(if #list$
		(progn
			;ソート
			(setq #list$ (mapcar 'cdr (SCFmg_sort$ 'car #list$)))

			;出力寸法を決定する
			(if (assoc "K" #list$)
				;キッチンがある
				(progn
					(if (= "D" (car (last #list$)))
						;右にダイニングがある
						(progn
							(setq #ssret$ (list (cadr (assoc "K" #list$)) (cadr (last #list$))))
						)
						;右にダイニングはない
						(progn
							(setq #ssret$ (list (cadr (car #list$)) (cadr (assoc "K" (reverse #list$)))))
						)
					)
				)
				;ダイニングのみ
				(progn
					(setq #ssret$ (list (cadr (car #list$)) (cadr (last #list$))))
				)
			)

			;左右の基準座標獲得
			;(setq #pt$ (SCFmg_sort$ 'car #pt$)) 2000/10/19 HT MOD START
			;(list #ssret$ (list (car #pt$) (last #pt$)))
			; 最も左右 最も下
			(setq #pt$ (SCFCmnXYSortByX #pt$))
		)
	)
	(if #pt$
		(list #ssret$ (list (car (car #pt$)) (car (last #pt$))))
		nil
	)
	;2000/10/19 HT END
) ; GetModelSideDim

;<HOM>*************************************************************************
; <関数名>    : SCFDrawDimLin
; <処理概要>  : 座標リストと基点座標と寸法位置座標から連続寸法を作図する
; <戻り値>    : 成功フラグ （T:成功 nil:失敗）
; <作成>      : 1998-06-26
; <備考>      : 高さは常に15000とする  01/10/02 HN MOD 10000→15000
;               直列寸法
;*************************************************************************>MOH<
(defun SCFDrawDimLin (
	&pt$    ; (LIST) 寸法位置座標リスト
	&bpt    ; (LIST) 基点座標      （nilのとき&pt$の値をそのまま使用）
	&dpt    ; (LIST) 寸法位置座標
	&flg    ; (STR)  寸法方向フラグ（水平:"H" 垂直:"V"）
	/
	#osmode #pt$ #xy #pt #flg #ang #en #i #subst #no #pt_n
	)
	;--- 初期設定 ---
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	;----------------
	(mapcar
	 '(lambda ( #elm )
			(if (/= nil #elm)
				(setq #pt$ (cons #elm #pt$))
			)
		)
		&pt$
	)

	;座標計算
	(if (/= nil &bpt)
		(if (equal "H" &flg)
			(setq #pt$ (mapcar '(lambda ( #xy ) (list #xy (cadr &bpt) 0.0)) (mapcar 'car  #pt$)))
			(setq #pt$ (mapcar '(lambda ( #xy ) (list (car  &bpt) #xy 0.0)) (mapcar 'cadr #pt$)))
		)
		(setq #pt$ (mapcar '(lambda ( #pt ) (list (car #pt) (cadr #pt) 0.0)) #pt$))
	)
	(setq #flg T)
	;かぶっている座標を省く
	(if (= "H" &flg)
		(setq #ang (* 0.0 PI))
		(setq #ang (* 0.5 PI))
	)
	(setq #pt$ (PtSort #pt$ #ang T))
	;座標をソート
	(if (not (< 1 (length #pt$)))
		(setq #flg nil)
	)
	(if (/= nil #flg)
		(progn
			;寸法を作図する前の図形を獲得
			(setq #en (entlast))
			;寸法作図
			(command "_.dimlinear" (nth 0 #pt$) (nth 1 #pt$) &flg (list (car &dpt) (cadr &dpt) 0.0))
			(setq #i 2)
			(command "_.dimcontinue")
			(repeat (- (length #pt$) 2)
				(command (nth #i #pt$))
				(setq #i (1+ #i))
			)
			(command "" "")
			;作図した寸法図形を高さ15000にあげる  01/10/02 HN MOD 10000→15000
			(while (setq #en (entnext #en))
				(setq #subst (entget #en '("*")))
				(mapcar
				 '(lambda ( #no )
						(setq #pt (cdr (assoc #no #subst)))
						(if (/= nil #pt)
							(progn
								;01/10/02 HN MOD 10000→15000
								;@MOD@(setq #pt_n (list (car #pt) (cadr #pt) 10000.0))
								(setq #pt_n (list (car #pt) (cadr #pt) CG_LAYOUT_DIM_Z))
								(setq #subst (subst (cons #no #pt_n) (assoc #no #subst) #subst))
							)
						)
					)
				 ; 座標
				 '(10 11 12 13 14)
				)
				(entmod #subst)
			)
		)
	)
	(setvar "OSMODE" #osmode)

	#flg
) ; SCFDrawDimLin

;<HOM>*************************************************************************
; <関数名>    : SCFDrawDimAlig
; <処理概要>  : 座標リストと基点座標と寸法位置座標から平行寸法を作図する
; <戻り値>    : 成功フラグ （T:成功 nil:失敗）
; <作成>      : 00/03/02
; <備考>      : 高さは常に15000とする  01/10/02 HN MOD 10000→15000
;*************************************************************************>MOH<
(defun SCFDrawDimAlig (
	&pt$    ; (LIST) 寸法位置座標リスト２点
	&dpt    ; (LIST) 寸法位置座標
	/
	#osmode #pt$ #p #subst #no #pt #pt_n
	)
	;--- 初期設定 ---
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	;----------------
	(setq #pt$
		(mapcar
		 '(lambda ( #p )
				(list (car #p) (cadr #p) 0.0)
			)
			&pt$
		)
	)
	;寸法作図
	(command "_.dimaligned" (nth 0 #pt$) (nth 1 #pt$) (list (car &dpt) (cadr &dpt) 0.0))
	;作図した寸法図形を高さ15000にあげる  01/10/02 HN MOD 10000→15000
	(setq #subst (entget (entlast) '("*")))
	(mapcar
	 '(lambda ( #no )
			(setq #pt (cdr (assoc #no #subst)))
			(if (/= nil #pt)
				(progn
 					;01/10/02 HN MOD 10000→15000
 					;@MOD@(setq #pt_n (list (car #pt) (cadr #pt) 10000.0))
 					(setq #pt_n (list (car #pt) (cadr #pt) CG_LAYOUT_DIM_Z))
					(setq #subst (subst (cons #no #pt_n) (assoc #no #subst) #subst))
				)
			)
		)
	 '(10 11 12 13 14)
	)
	(entmod #subst)
	(setvar "OSMODE" #osmode)

	T
) ; SCFDrawDimAlig

;<HOM>*************************************************************************
; <関数名>    : Get2PointByLay2
; <処理概要>  : 図形名から、シンボル位置とキャビネット幅位置を算出
; <戻り値>    : ２点座標リスト
; <備考>      : 真正面 真横のアイテム以外も投影値で返す)
;*************************************************************************>MOH<
(defun Get2PointByLay2 (
	&en         ; 図形名
	/
	#pt1 #edl$ #eds$ #flg #ang #dis #pt2 #pt$
	)
	(if (and &en (= 'ENAME (type &en)))
		(progn
			(setq #pt1 (cdrassoc 10 (entget &en)))
			(setq #pt1 (list (car #pt1) (cadr #pt1) 0.0))
			(setq #edl$ (CfGetXData &en "G_LSYM"))
			(setq #eds$ (CfGetXData &en "G_SYM"))
			(if (and #edl$ #eds$)
				(progn
					(setq #flg (nth 5 (CfGetXData &en "G_SKDM")))
					(if (= "W" #flg)
						(progn
							(setq #ang (Angle0to360 (nth 2 #edl$)))
							(setq #flg (nth 8 #eds$))
							(setq #dis (nth 3 #eds$))
						)
						(progn
							(setq #ang (Angle0to360 (+ (* PI 1.5) (nth 2 #edl$))))
							(setq #flg (nth 9 #eds$))
							(setq #dis (nth 4 #eds$))
						)
					)
					(if (= -1 #flg)
						(setq #ang (+ PI #ang))
					)
					(if
						(and
							#pt1 #ang #dis
						)
						(progn
			 				(setq #dis (+ #dis (cos #Ang)))
							(setq #pt2 (polar #pt1 #ang #dis))
							(setq #pt$ (list #pt1 #pt2))
						)
					)
				)
			)
		)
	)

	#pt$
) ; Get2PointByLay2

;2011/06/06 YM MOD-S
;;;;<HOM>*************************************************************************
;;;; <関数名>    : Get2PointByLay
;;;; <処理概要>  : 図形名から、シンボル位置とキャビネット幅位置を算出
;;;; <戻り値>    : ２点座標リスト
;;;;             : XY平面に平行なもの(広角度の時どうするか)
;;;;*************************************************************************>MOH<
;;;(defun Get2PointByLay (
;;;	&en         ; 図名
;;;	&iHaimen		; リバーシブル
;;;	/
;;;	#pt1 #edl$ #eds$ #WDflg #flg #ang #dis #pt2 #pt$
;;;	)
;;;	(if (and &en (= 'ENAME (type &en)))
;;;		(progn
;;;			; シンボル基点取得
;;;			(setq #pt1 (cdrassoc 10 (entget &en)))
;;;			(setq #pt1 (list (car #pt1) (cadr #pt1) 0.0))
;;;			(setq #edl$ (CfGetXData &en "G_LSYM"))
;;;			(setq #eds$ (CfGetXData &en "G_SYM"))
;;;			; シンボル図形が存在する場合
;;;			(if (and #edl$ #eds$)
;;;				(progn
;;;					(setq #WDflg (nth 5 (CfGetXData &en "G_SKDM")))
;;;					(if (= "W" #WDflg)
;;;						; "W" 方向の場合
;;;						(progn
;;;							(setq #ang (Angle0to360 (nth 2 #edl$)))
;;;							(setq #flg (nth 8 #eds$))
;;;							(setq #dis (nth 3 #eds$))
;;;						)
;;;						; "D"方向の場合
;;;						(progn
;;;							; 2000/09/06 HT MOD 広角度対応 WIDECAB START
;;;							(if (setq #ang (SCFGetWideCabAng #eds$))
;;;								(progn
;;;								; 広角度の場合
;;;								(setq #ang (Angle0to360 (+ (- (* PI 2.0) #ang) (nth 2 #edl$))))
;;;								)
;;;								(progn
;;;								; 一般 (コーナー角度90度の場合)
;;;								(setq #ang (Angle0to360 (+ (* PI 1.5) (nth 2 #edl$))))
;;;								)
;;;							)
;;;							; 2000/09/06 HT MOD 広角度対応 WIDECAB END
;;;							(setq #flg (nth 9 #eds$))
;;;							(setq #dis (nth 4 #eds$))
;;;						)
;;;					)
;;;					; 逆向き
;;;					(if (= -1 #flg)
;;;						(setq #ang (+ PI #ang))
;;;					)
;;;					(if
;;;						(and
;;;							; 点が取得可能
;;;							#pt1 #ang #dis
;;;							(or
;;;								; 正面向きまたは逆向きの場合
;;;								(equal 0.0 (Angle0to360 #ang) 0.1)
;;;								(equal (* 2.0 PI) (Angle0to360 #ang) 0.1)
;;;								(if (or (= "D" #WDflg) (= &iHaimen 1) (= CG_DRSeriCodeRV nil))
;;;									(equal PI (Angle0to360 #ang) 0.1)
;;;									nil
;;;								)
;;;							)
;;;						)
;;;						(progn
;;;							(setq #pt2 (polar #pt1 #ang #dis))
;;;							(setq #pt$ (list #pt1 #pt2))
;;;						)
;;;						(progn
;;;							; 01/05/29 矢視E/F の場合
;;;							(setq #ang (+ (* 0.5 PI) #ang))
;;;						 	(setq #pt2 (polar #pt1 #ang #dis))
;;;							(if (= "W" #WDflg)
;;;								(progn
;;;									(setq #pt$ (list #pt2 #pt1))
;;;								)
;;;								(progn
;;;									(setq #pt$ (list #pt1 #pt2))
;;;								)
;;;							)
;;;						)
;;;					)
;;;				)
;;;			)
;;;		)
;;;	)
;;;
;;;	#pt$
;;;) ; Get2PointByLay

;<HOM>*************************************************************************
; <関数名>    : Get2PointByLay
; <処理概要>  : 図形名から、シンボル位置とキャビネット幅位置を算出
; <戻り値>    : ２点座標リスト
;             : XY平面に平行なもの(広角度の時どうするか)
;               TSから関数をコピー
;*************************************************************************>MOH<
(defun Get2PointByLay (
  &en         ; 図名
  &iHaimen    ; リバーシブル
  /
  #pt1 #edl$ #eds$ #WDflg #flg #ang #dis #pt2 #pt$ #skDm$ #syomen
  )
  (if (and &en (= 'ENAME (type &en)))
    (progn
      ; シンボル基点取得
      (setq #pt1 (cdrassoc 10 (entget &en)))
      (setq #pt1 (list (car #pt1) (cadr #pt1) 0.0))
      (setq #edl$ (CfGetXData &en "G_LSYM"))
      (setq #eds$ (CfGetXData &en "G_SYM"))

      ; シンボル図形が存在する場合
      (if (and #edl$ #eds$)
        (progn
          (setq #skDm$ (CfGetXData &en "G_SKDM"))
          (setq #WDflg (nth 5 #skDm$))
          (setq #syomen (nth 3 #skDm$))

          (if (or (= "W" #WDflg) (= #syomen -1))
          ;(if (= "W" #WDflg)
            ; "W" 方向の場合
            (progn
              (setq #ang (Angle0to360 (nth 2 #edl$)))
              (setq #flg (nth 8 #eds$))
              (setq #dis (nth 3 #eds$))
            )
            ; "D"方向の場合
            (progn
              ; 一般
              (setq #ang (Angle0to360 (+ (* PI 1.5) (nth 2 #edl$))))

              (setq #flg (nth 9 #eds$))
              (setq #dis (nth 4 #eds$))
            )
          )
          ; 逆向き
          (if (= -1 #flg)
            (setq #ang (+ PI #ang))
          )
          (if
            (and
              ; 点が取得可能
              #pt1 #ang #dis
              (or
                ; 正面向きまたは逆向きの場合
                (equal 0.0 (Angle0to360 #ang) 0.1)
                (equal PI (Angle0to360 #ang) 0.1)
                (equal (* 2.0 PI) (Angle0to360 #ang) 0.1)
                (if (or (= "D" #WDflg) (= &iHaimen 1))
                  (equal PI (Angle0to360 #ang) 0.1)
                  nil
                )
              )
            )
            (progn
              (setq #dis (fix (+ #dis 0.001)))
              (setq #pt2 (polar #pt1 #ang #dis))
              (setq #pt$ (list #pt1 #pt2))
            )
            (progn
              ; 01/05/29 矢視E/F の場合
              ; 04/12/11 ANG設定の意味不明のため除去
              (setq #ang (+ (* 0.5 PI) #ang))
              (setq #pt2 (polar #pt1 #ang #dis))
              (if (= "W" #WDflg)
                (setq #pt$ (list #pt2 #pt1))
              ;else
                (setq #pt$ (list #pt1 #pt2))
              )
            )
          )
        )
      )
    )
  )

  #pt$
) ; Get2PointByLay
;2011/06/06 YM MOD-E

;<HOM>*************************************************************************
; <関数名>    : GetZPointByLay
; <処理概要>  : 図形名から、シンボル位置とキャビネット奥行座標を算出
; <戻り値>    : 2つのZ座標値
;             : XY平面に平行なもの(広角度の時どうするか)
;*************************************************************************>MOH<
(defun GetZPointByLay (
	&en         ; 図名
	&iHaimen    ; リバーシブル
	/
	#pt1 #edl$ #eds$ #WDflg #flg #ang #dis #pt2 #pt$ #skDm$ #syomen
	)
	(if (and &en (= 'ENAME (type &en)))
		(progn
			; シンボル基点取得
			(setq #pt1 (cdrassoc 10 (entget &en)))
			(setq #pt1 (list (nth 0 #pt1) (nth 2 #pt1) (nth 1 #pt1)))
			(setq #edl$ (CfGetXData &en "G_LSYM"))
			(setq #eds$ (CfGetXData &en "G_SYM"))

			; シンボル図形が存在する場合
			(if (and #edl$ #eds$)
				(progn
					(setq #skDm$ (CfGetXData &en "G_SKDM"))
					(setq #WDflg (nth 5 #skDm$))
					(setq #syomen (nth 3 #skDm$))

					(if (or (= "W" #WDflg) (= #syomen -1))
						; "W" 方向の場合
						(progn
							(setq #angx (Angle0to360 (nth 2 #edl$)))
							(setq #flgx (nth 8 #eds$))
							(setq #disx (nth 3 #eds$))
							(setq #angy (Angle0to360 (+ #angx (* 0.5 PI))))
							(setq #flgy (nth 9 #eds$))
							(setq #disy (nth 4 #eds$))
						)
						; "D"方向の場合
						(progn
							; 一般
							(setq #angx (Angle0to360 (+ (* PI 1.5) (nth 2 #edl$))))
							(setq #flgx (nth 9 #eds$))
							(setq #disx (nth 4 #eds$))
							(setq #angy (Angle0to360 (- #angx (* PI 0.5))))
							(setq #flgy (nth 8 #eds$))
							(setq #disy (nth 3 #eds$))
						)
					)
					; 逆向き
					(if (= -1 #flgx)
						(setq #angx (+ PI #angx))
					)
					(if (= -1 #flgy)
						(setq #angy (+ PI #angy))
					)
					(if
						(and
							; 点が取得可能
							#pt1 #angx #disx
							(or
								; 正面向きまたは逆向きの場合
								(equal 0.0 (Angle0to360 #angx) 0.1)
								(equal PI (Angle0to360 #angx) 0.1)
								(equal (* 2.0 PI) (Angle0to360 #angx) 0.1)
								(if (or (= "D" #WDflg) (= &iHaimen 1))
									(equal PI (Angle0to360 #angx) 0.1)
									nil
								)
							)
						)
						(progn
							(setq #disx (fix (+ #disx 0.001)))
							(setq #disy (fix (+ #disy 0.001)))
							(setq #pt2 (polar #pt1 #angx #disx))
							(setq #pt2 (polar #pt2 #angy #disy))
						)
						(progn
							; 01/05/29 矢視E/F の場合
							; 04/12/11 ANG設定の意味不明のため除去
							(setq #angx (+ (* 0.5 PI) #angx))
							(setq #angy (+ (* 0.5 PI) #angy))
							(setq #pt2 (polar #pt1 #angx #disx))
							(setq #pt2 (polar #pt2 #angy #disy))
						)
					)
				)
			)
		)
	)

	(list (nth 1 #pt1) (nth 1 #pt2))
) ; GetZPointByLay

;<HOM>*************************************************************************
; <関数名>    : GetRangeUpBas
; <処理概要>  : ベースとアッパーの領域を獲得（左下点 右上点）
; <戻り値>    : （ベース アッパー）
; <作成>      : 00/02/17
;*************************************************************************>MOH<
(defun GetRangeUpBas (
	&ss$        ; 選択セットリスト
	/
	#ss$ #ss #i #en #code$ #bas$ #upp$ #2pt$ #bpt$ #ed$ #ang #upt #upt$
	#tss$
#hin #INSPT #XD_LSYM$ #DUM_PT #dum_pt1 #dum_pt2 ;2011/06/04 YM ADD
	)
	;アッパーとベースの図形名リスト獲得
	(if (= 'PICKSET (type &ss$))
		(setq #ss$ (list &ss$))
		(progn
			(foreach #ss &ss$
				(if #ss
					(setq #ss$ (append #ss$ #ss))
				)
			)
		)
	)

	(foreach #ss  #ss$
		(setq #i 0)
		(repeat (sslength #ss)
			(setq #en (ssname #ss #i))
			(setq #code$ (CFGetSymSKKCode #en nil))
			(if (or (= CG_SKK_ONE_CAB (nth 0 #code$))(= CG_SKK_ONE_RNG (nth 0 #code$)))
				(cond
					((= CG_SKK_TWO_BAS (nth 1 #code$))  ; ベース
						(setq #bas$ (cons #en #bas$))
					)
					((= CG_SKK_TWO_UPP (nth 1 #code$))  ; アッパー
						(setq #upp$ (cons #en #upp$))
					)
					; 01/08/07 TM ADD ベースでもアッパーでもない座標をベースに所属させる
					; (暫定対応: 取り付け桟寸法の位置をベースキャビネットの位置に合わせる)
					(t (setq #bas$ (cons #en #bas$)))
				)
			)
			(setq #i (1+ #i))
		)
	)

	; 01/07/08 HN S-ADD キャビネットとレンジフードが無い場合、その他部材を対象
	(if (and (= nil #bas$) (= nil #upp$))
		(foreach #ss #ss$
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #bas$ (cons #en #bas$))
				(setq #upp$ (cons #en #upp$))
				(setq #i (1+ #i))
			)
		)
	)
	; 01/07/08 HN E-ADD キャビネットとレンジフードが無い場合、その他部材を対象

	;座標獲得
	; ベース
	(foreach #en #bas$

		;2011/06/04 YM ADD-S
		(setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
		(setq #hin (nth 5 #xd_LSYM$));使わないが確認用
		(setq #insPT (nth 1 #xd_LSYM$));使わないが確認用
		;2011/06/04 YM ADD-E

		;(setq #2pt$ (Get2PointByLay #en))
		(setq #2pt$ (Get2PointByLay #en 1))
		(if (/= nil #2pt$)
			(progn
				(setq #code$ (CFGetSymSKKCode #en nil))
				; 06/09/21 T.Ari Mod 台輪分浮いているベースキャビを考慮
				(if (and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_TWO_BAS (nth 1 #code$)))
					(progn
						;2011/06/04 YM MOD-S
;;;						(setq #bpt$ (cons (polar (car  #2pt$) (* PI 1.5) (nth 2 (nth 1 (CFGetXData #en "G_LSYM")))) #bpt$))
;;;						(setq #bpt$ (cons (polar (cadr #2pt$) (* PI 1.5) (nth 2 (nth 1 (CFGetXData #en "G_LSYM")))) #bpt$))
						(setq #dum_pt (nth 1 #xd_LSYM$))
						(setq #dum_pt1 (polar (car  #2pt$) (* PI 1.5) (nth 2 #dum_pt)))
						(setq #bpt$ (cons #dum_pt1 #bpt$))
						(setq #dum_pt2 (polar (cadr #2pt$) (* PI 1.5) (nth 2 #dum_pt)))
						(setq #bpt$ (cons #dum_pt2 #bpt$))
						;2011/06/04 YM MOD-E
					)
					(progn
						(setq #bpt$ (cons (car  #2pt$) #bpt$))
						(setq #bpt$ (cons (cadr #2pt$) #bpt$))
					)
				)
				(setq #ed$  (CfGetXData #en "G_SYM"))
				(if (= 1 (nth 10 #ed$))
					(setq #ang (* PI 0.5))
					(setq #ang (* PI 1.5))
				)
				(setq #upt (polar (car #2pt$) #ang (nth 5 #ed$)))
				(setq #bpt$ (cons #upt #bpt$))
			)
		)
	)

	; アッパー
	(foreach #en #upp$
		;(setq #2pt$ (Get2PointByLay #en))
		(setq #2pt$ (Get2PointByLay #en 1))
		(if (/= nil #2pt$)
			(progn
				(setq #upt$ (cons (car  #2pt$) #upt$))
				(setq #upt$ (cons (cadr #2pt$) #upt$))
				(setq #ed$  (CfGetXData #en "G_SYM"))
				(if (= 1 (nth 10 #ed$))
					(setq #ang (* PI 0.5))
					(setq #ang (* PI 1.5))
				)
				(setq #upt (polar (car #2pt$) #ang (nth 5 #ed$)))
				(setq #upt$ (cons #upt #upt$))
			)
		)
	)

	;最大と最小の座標を獲得
	(if (/= nil #bpt$)
		(setq #bpt$ (GetPtMinMax #bpt$))
	)
	(if (/= nil #upt$)
		(setq #upt$ (GetPtMinMax #upt$))
	)

	(list #bpt$ #upt$)

) ; GetRangeUpBas

;<HOM>************************************************************************
; <関数名>  : DrawPtenDim
; <処理概要>: 施工寸法と施工胴縁寸法を作図
; <戻り値>  : 位置座標
; <作成>    : 00/02/17
; <備考>    : 00/05/09 HN MOD 施工寸法に施工情報追加予定
;************************************************************************>MOH<
(defun DrawPtenDim (
	&pten$      ; P点図形
	&ryo$       ; ベースとアッパーの領域座標リスト いずれかの座標は有効であること
	&layer      ; 画層
	&sekou      ; 施工寸法出力方向フラグ
	&doubu      ; 施工胴縁出力方向フラグ
	/
	#doubu$     ; 施工胴縁寸法点リスト
	#sekou$			; 施工寸法点リスト
	#bpt$
	#iti$
	#dReg$	; ベースとアッパーの領域座標リスト
	)

;@@@(princ "\nDrawPtenDim  画層: ")(princ &layer);00/05/18
	(setq #doubu$  (nth 1 &pten$))
	(setq #sekou$  (nth 2 &pten$))

	(if (not #iti$) (setq #iti$ (list 0 0 0 0)))
	; 01/05/17 TM ADD 高さを表示するためにダミーの領域座標を追加
	(setq #dReg$ (KCFGetDummyRange &ryo$))
	(if (/= nil #sekou$)
		(progn
			(setq #bpt$ (GetBasePtBySekou #dReg$ &sekou &layer))
			(setq #iti$ (SCFDrawDimSekou #sekou$ (cadr #dReg$) (car #dReg$) CG_DimOffLen #bpt$))
		)
	)
	(if (/= nil (car #doubu$))
		(progn
			;(setq #iti$ (SCFDrawDimDoubuti #doubu$ &ryo$ #iti$ &doubu))
			; 施工同縁寸法 UP/BAS領域の両端の近い方向に作図する
			; (I型2列側面の場合などに片側に寸法がよってしまう不具合修正)

;			(setq #iti$ (SCFDrawDimDoubuti2 #doubu$ #dReg$ #iti$ &doubu))
			(setq #iti$ (SCFDrawDimDoubuti3 #doubu$ #dReg$ #iti$ &doubu))
		)
	)
	#iti$
) ; DrawPtenDim

;<HOM>*************************************************************************
; <関数名>    : KCFGetDummyRange
; <処理概要>  : ベース・アッパー領域がない場合にダミーを作成する
; <戻り値>    : （ベース アッパー）
; <作成>      : 01.05.17 TM
; <備考>      : 垂直方向の寸法(天井高さ－床面)作成用
;             : どちらの座標もない場合は nil
;*************************************************************************>MOH<
(defun KCFGetDummyRange (
	&dReg$		; 領域リスト
	/
	#dReg$		; 領域リスト
	#dBs$			; ベース座標
	#dUp$			; アッパー座標
	#dDum1		; ダミー座標
	#dDum2		; ダミー座標
	)
	(if (cadr &dReg$)
		(progn
			(if (not (car &dReg$))
				; ベース座標がない場合、アッパー座標から作成する
				(progn
					(setq #dDum1 (car (cadr &dReg$)))
					(setq #dDum1 (list (car #dDum1) (+ 831 (- (cadr #dDum1) CG_CeilHeight))))
					(setq #dDum2 (cadr (cadr &dReg$)))
					(setq #dDum2 (list (car #dDum2) (+ 831 (- (cadr #dDum2) CG_CeilHeight))))
					(setq #dBs$ (list #dDum1 #dDum2))
					(setq #dReg$ (list #dBs$ (cadr &dReg$)))
				)
				; 両方ある場合はそのまま返す
				(progn
					(setq #dReg$ &dReg$)
				)
			)
		)
		(progn
			; アッパー座標がない場合、ベース座標から作成する
			(if (car &dReg$)
				(progn
					(setq #dDum1 (car (car &dReg$)))
					(setq #dDum1 (list (car #dDum1) (+ 831 (- CG_CeilHeight (cadr #dDum1)))))
					(setq #dDum2 (cadr (car &dReg$)))
					(setq #dDum2 (list (car #dDum2) (+ 831 (- CG_CeilHeight (cadr #dDum2)))))
					(setq #dUp$ (list #dDum1 #dDum2))
					(setq #dReg$ (list (car &dReg$) #dUp$))
				)
				(princ "\n領域が空?:KCFGetDummyRange")
			)
		)
	)
	#dReg$

);_defun KCFGetDummyRange

;<HOM>*************************************************************************
; <関数名>    : GetRangePlane
; <処理概要>  : 平面図の領域を獲得
; <戻り値>    : （左下点 右上点）
; <作成>      : 00/02/17
;*************************************************************************>MOH<
(defun GetRangePlane (
	&ss$        ; 選択セットリスト
	/
	#ss$ #ss #i #en #code$ #spt$ #pt$
	)
	;アッパーとベースの図形名リスト獲得
	(setq #ss$ (apply 'append &ss$))
	(mapcar
	 '(lambda ( #ss )
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #code$ (CFGetSymSKKCode #en nil))
				(if (or (= CG_SKK_ONE_CAB (nth 0 #code$))(= CG_SKK_ONE_RNG (nth 0 #code$)))
					(progn
						(setq #spt$ (GetSym4Pt #en))
						(setq #pt$ (append #pt$ (list (nth 0 #spt$)(nth 1 #spt$)(nth 2 #spt$))))
					)
				)
				(setq #i (1+ #i))
			)
		)
		#ss$
	)
	(if (not #pt$)
		(mapcar
		 '(lambda ( #ss )
				(setq #i 0)
				(repeat (sslength #ss)
					(setq #en (ssname #ss #i))
					(setq #spt$ (GetSym4Pt #en))
					(setq #pt$ (append #pt$ (list (nth 0 #spt$)(nth 1 #spt$)(nth 2 #spt$))))
					(setq #i (1+ #i))
				)
			)
			#ss$
		)
	)

	;最大と最小の座標を獲得
	(GetPtMinMax #pt$)
) ; GetRangePlane

;<HOM>*************************************************************************
; <関数名>    : IsRegion2Retsu
; <処理概要>  : 領域は２列型の領域か？
; <戻り値>    : T or nil
; <作成>      : 01/04/17 TM
; <備考>      : 領域の真ん中に図形が存在するかで判定
;*************************************************************************>MOH<
(defun IsRegion2Retsu (
	&dRegion$	; 領域座標 (((アッパー１) (アッパー２)) ((ベース１) (ベース２)))
	/
	#dUp
	#dBs
	#sMid
	)
	;DEBUG (princ "\n元の点")
	;DEBUG (princ &dRegion$)
	(if (car &dRegion$)
		(setq #dUp (GetCenterPT (car (car &dRegion$)) (cadr (car &dRegion$))))
	)
	(if (cadr &dRegion$)
		(setq #dBs (GetCenterPT (car (cadr &dRegion$)) (cadr (cadr &dRegion$))))
	)
	;DEBUG (princ "\n中点")
	;DEBUG (princ #dUp)
	;DEBUG (princ #dBs)

	(if (not #dUp) (setq #dUp #dBs))
	(if (not #dBs) (setq #dBs #dUp))

	(setq #sMid (ssget "_C" #dUp #dBs))

	(if #sMid
		(progn
			T
		)
		(progn
			nil
		)
	)
)

;<HOM>*************************************************************************
; <関数名>    : GetBasePtBySekou
; <処理概要>  : 施工寸法の基準点を取得
; <戻り値>    : （アッパー ベース）
; <作成>      : 00/02/24
; <備考>      : L型・W型           ：コーナーキャビ基点
;               I型                ：コンロキャビ側
;               I型でコンロがない時：左右近いほう
;*************************************************************************>MOH<
(defun GetBasePtBySekou (
	&ryo$       ; ベースとアッパーの領域座標リスト
	&flg        ; 出力方向フラグ（I型の時のみ有効）
	&layer      ; 画層
	/
	#ssD #i #en #10 #ed$ #pt0 #flg #pt1 #code$ #gas #ret$ #bpt #half #ptj
	#WEn$  ; (WTEn WTEn ・・・)
	#WEn   ; WTEn基準になるWT
	#ssDum	; ダミー選択セット
	#nII		; 操作変数
	#DPt$		; シンクの基点列(両端)
	#pt0Tmp
	#pt1Tmp
	)
;@@@(princ "\n\nGetBasePtBySekou()"  ) ;DebugHN
;@@@(princ "\n&ryo$: " )(princ &ryo$ ) ;DebugHN
;@@@(princ "\n&flg: "  )(princ &flg  ) ;DebugHN
;@@@(princ "\n&layer: ")(princ &layer) ;DebugHN

	; <処理概要>  : ガス又はシンクキャビの座標を取得
	; <作成>      :
	; <戻り値>    : 座標
	; <備考>			:
	(defun ##GasSinkCab10 (
		/
		#i     ; カウンタ
		#xSs   ; "G_SKDM"の選択セット
		#eEn   ; "G_SKDM"図形名
		#Ed$   ; XData
		#10    ; 座標
		#code$ ; 性格CODE
		#bGetGas
	)

		(setq #bGetGas nil)
		(setq #10 nil)
		(setq #xSs (ssget "X" (list (list -3 (list "G_SKDM")))))
		(if (/= nil #xSs)
			(progn
				(setq #i 0)
				(repeat (sslength #xSs)
					(setq #eEn  (ssname #xSs #i))
					(if (= (nth 1 (CfGetXData #eEn "G_SKDM")) "K")
						(progn
							(setq #code$ (CFGetSymSKKCode #eEn nil))
							(if (and (= CG_SKK_ONE_CAB (nth 0 #code$))
											 (= CG_SKK_TWO_BAS (nth 1 #code$))
											 (= CG_SKK_THR_GAS (nth 2 #code$)))
								(progn ;2011/04/08 YM ADD (prognを追加
									(setq #10  (cdrassoc 10 (entget #eEn)))
									(setq #bGetGas T)
								) ;2011/04/08 YM ADD (prognを追加
							)
							(if (and (= #bGetGas nil)
											 (= CG_SKK_ONE_CAB (nth 0 #code$))
											 (= CG_SKK_TWO_BAS (nth 1 #code$))
											 (= CG_SKK_THR_SNK (nth 2 #code$)))
								(setq #10  (cdrassoc 10 (entget #eEn)))
							)
						)
					)
					(setq #i (1+ #i))
				)
			)
		)
		#10
	)
	; 00/10/31 HT START
	; <処理概要>  : バックガード用の基準座標を求める
	; <作成>      :
	; <戻り値>    : 基準座標
	; <備考>			: 01/03/06 TM 全面的に改造
	(defun ##BKGDBasePt (
		&xReg$		; 領域図形リスト ((ベース) (アッパ))
		&xDumPt$	; ダミー図形
		/
		#ptGasSink
		#xB0			; ベース領域の端点
		#xB1			; ベース領域の端点
		#xBasePt	; 基準座標
		#dist1
		#dist2
		#taimen
		#xDumPtTmp$
		#ptGasSinkTmp
		#DIST3 ;2011/04/08 YM ADD
		)
		(WebOutLog (strcat "★##BKGDBasePt★  " &layer ))

		(setq #ptGasSink (##GasSinkCab10))
		(setq #xB0 (car  (car &xReg$)))
		(setq #xB1 (cadr (car &xReg$)))

		(WebOutLog "#ptGasSink= ")
		(WebOutLog #ptGasSink)
		(WebOutLog "#xB0= ")
		(WebOutLog #xB0)
		(WebOutLog "#xB1= ")
		(WebOutLog #xB1)

		; ベースの領域座標を比較して、バックガード側に近い方の領域の端を基準点とする
		; ダミー図形０と２は対角線上にあるはず
		; T.Arimoto Mod 対面時はキャビ基点(ガス又はシンク)を使用するように修正
		; T.Arimoto Mod 2008/11/04 対面判断方法を修正
		; ワークトップ側面の中心から2/3の距離範囲にベースキャビ基点があれば対面と判断
		(setq #xDumPtTmp$ (list (list (car (car &xDumPt$)) 0.0) (list (car (caddr &xDumPt$)) 0.0)))
		(setq #dist1 (distance (car #xDumPtTmp$) (list (car #xB0) 0.0)))
		(setq #dist2 (distance (cadr #xDumPtTmp$) (list (car #xB0) 0.0)))
		(setq #taimen nil)

		(WebOutLog "★　#xDumPtTmp$= ")
		(WebOutLog #xDumPtTmp$)
		(WebOutLog "★　#dist1= ")
		(WebOutLog #dist1)
		(WebOutLog "★　#dist2= ")
		(WebOutLog #dist2)
		(WebOutLog "★　#taimen= ")
		(WebOutLog #taimen)


		(if #ptGasSink
			(progn
				(WebOutLog (strcat "★##BKGDBasePt★ #ptGasSink あり " &layer ))
				(setq #ptGasSinkTmp (list (car #ptGasSink) 0.0))
				(setq #dist3 (distance #ptGasSinkTmp (list (* (+ (caar #xDumPtTmp$) (caadr #xDumPtTmp$)) 0.5) 0.0)))
;				(setq #taimen (and (< #dist3 (* 2 (distance (car #xDumPtTmp$) #ptGasSinkTmp)))
;													 (< #dist3 (* 2 (distance (cadr #xDumPtTmp$) #ptGasSinkTmp)))))
				(setq #taimen T)

				(WebOutLog "★　#ptGasSinkTmp= ")
				(WebOutLog #ptGasSinkTmp)
				(WebOutLog "★　#dist3= ")
				(WebOutLog #dist3)
				(WebOutLog "★　#taimen= ")
				(WebOutLog #taimen)

			)
			(progn
				nil
				(WebOutLog (strcat "★##BKGDBasePt★ #ptGasSink なし " &layer ))
			)
		)
		(cond
			(#taimen
				(setq #xBasePt (list (car #ptGasSink) (cadr #xB0) 0.0))
			 	(WebOutLog (strcat "★##BKGDBasePt★ cond文 #taimen " &layer ))
			)
			((< #dist1 #dist2)
				(setq #xBasePt  #xB0)
			 	(WebOutLog (strcat "★##BKGDBasePt★ cond文 (< #dist1 #dist2) " &layer ))
			)
			(T
				(setq #xBasePt (list (car #xB1) (cadr #xB0) 0.0))
			 	(WebOutLog (strcat "★##BKGDBasePt★ cond文 T " &layer ))
			)
		)
;|
		(if (< (distance (car &xDumPt$) #xB0) (distance (caddr &xDumPt$) #xB0))
			(progn
				(setq #xBasePt  #xB0)
			)
			(progn
				(setq #xBasePt (list (car #xB1) (cadr #xB0) 0.0))
			)
		)
|;

		(WebOutLog "★　#xBasePt= ")
		(WebOutLog #xBasePt)
		(WebOutLog "★★★★★　(defun ##BKGDBasePt 終了！！！")
		(WebOutLog "　")

		#xBasePt

	) ;_defun
	; 00/10/31 HT END

	; 穴をとるために座標系を変更
	(command "UCS" "W")

	; シンク穴加工ありのワークトップを取得
	(setq #WEn$ (SCFGetWkTopXData))
	(if (> (length #WEn$) 0)
		(progn
			(setq #WPt$ (SCFGetDummyWPtSort))
			; 座標系を戻す
			(command "UCS" "G" "F")
			(command "-VIEW" "O" "F")

			; 取得したワークトップから、シンクを持つものを検索
			(foreach #Pt$ #WPt$
				(setq #xSs (ssget "_C" (car (3dto2d (list (trans (nth 0 #Pt$) 0 1))))
				(car (3dto2d (list (trans (nth 2 #Pt$) 0 1))))))
				; 00/11/01 HT ADD
				(setq #i 0)
				(repeat (length #WEn$)
					(if (ssmemb (nth #i #WEn$) #xSs)
						(progn
							; 基点(両端)
							(setq #DPt$ #Pt$)
							; 図形
							(setq #WEn (nth #i #WEn$))
						)
					)
					(setq #i (1+ #i))
				)
				; 00/11/01 HT ADD
			)

			(command "UCS" "P")
			(command "-VIEW" "O" "T")

			; シンクがある場合
			(if #WEn
				(progn

				; 01/07/05 TM MOD とりあえず落ちないように変更 暫定
				; 基準点
				(setq	#pt0 (nth 0 #DPt$)
							#pt1 (nth 1 #DPt$))

					(setq #Ed$ (CfGetXData #WEn "G_WRKT"))
					(if (= (nth 3 #Ed$) 1)
						; L型   ->  コーナー基点
						(progn
							(setq #ret$ (list (polar #pt0 (* 0.5 PI) CG_CeilHeight) #pt0))
						)
					)
				)
			)
		)
	)

	(if (and #WEn (equal (car #pt0) (car #pt1) 0.01) (equal (cadr #pt0) (cadr #pt1) 0.01))
		; 側面図  ; 01/03/06 TM ADD
		(progn
			; 01/04/17 TM MOD ２列型側面図以外の場合はバックガード側に基点を設定する
			; ２列型は近い方 (== 自分のキャビネット側の基点) から自動作図させるため指定しない
			(if (IsRegion2Retsu &ryo$)
				(progn
					(setq #bpt (##BKGDBasePt &ryo$ #DPt$))
					(setq #ret$ (list (polar #bpt (* 0.5 PI) CG_CeilHeight) #bpt))
				)
			)
		)
		; 側面図以外
		(progn
			; 02/07/11 YM ADD-S
			(if (and (equal (KPGetSinaType) 2 0.1) ; 商品ﾀｲﾌﾟ=2
							 (or (= CG_sType "SB")(= CG_sType "SD"))) ; 展開B,D図
				(setq &flg "A")
			);_if
			; 02/07/11 YM ADD-E

			; 01/04/12 TM MOD シンクがない場合も基点を決定する処理を続行する？
			; ここまでの処理で基点が決定していない場合
			; == L 型以外・側面以外・シンクがない 等
			(if (not #ret$)
				(progn
					; ダイアログで指定した基点方向に従って設定する
					(cond
						; 左方向指定
						((= "L" &flg) (setq #bpt  (car (car &ryo$))))

						; 右方向指定
						((= "R" &flg) (setq #bpt  (list (car (cadr (car &ryo$))) (cadr (car (car &ryo$))) 0.0)))

						; 自動指定
						((= "A" &flg)
							; ガスキャビネットがある場合はガスキャビネット側から引く
							(setq #gas (SCFGetGasCab10))
							; 06/09/27 T.Ari Mod-S ワークトップがなくコンロキャビがあるプラン対応
							(if (/= nil #gas)
								(progn
									; 01/06/20 TM MOD-S 中点より左右→より近いほうに変更
									;(setq #half (* 0.5 (distance #pt0 #pt1)))
									; #ptj ... X座標が小さい方
									;(if (equal 0.0 (angle #pt0 #pt1) 0.01)
									;	(setq #ptj #pt0)
									;	(setq #ptj #pt1)
									;)
									;if (< (distance #ptj #gas) #half)
									; 01/07/05 TM とりあえず落ちないようにすbる 暫定
									(if #pt0
										(if (and (< (* 0.5 PI) (angle #pt0 #pt1)) (> (* 1.5 PI) (angle #pt0 #pt1)))
											(progn (setq #pt0tmp #pt1) (setq #pt1tmp #pt0))
											(progn (setq #pt0tmp #pt0) (setq #pt1tmp #pt1))
										)
									)
									(if #WEn
										(if (and #pt0 (< (distance #pt0tmp #gas) (distance #pt1tmp #gas)))
										; 01/06/20 TM MOD-E 中点より左右→ガスキャビネットがより近いほうに変更
											(setq #bpt (car (car &ryo$)))   																				;X座標小さい方
											(setq #bpt (list (car (cadr (car &ryo$)))(cadr (car (car &ryo$))) 0.0)) ;X座標大きい方
										)
										(if (< (abs (- (nth 0 (car (car &ryo$))) (nth 0 #gas))) (abs (- (nth 0 (cadr (car &ryo$))) (nth 0 #gas))))
											(setq #bpt (car (car &ryo$)))   																				;X座標小さい方
											(setq #bpt (list (car (cadr (car &ryo$)))(cadr (car (car &ryo$))) 0.0)) ;X座標大きい方
										)
									)
								)
							; 06/09/27 T.Ari Mod-E ワークトップがなくコンロキャビがあるプラン対応
								; ガスキャビネットなし、シンクなしの場合は勝手設定の逆方向にする
								(progn
									; 01/06/22 TM ADD-S 側面図の場合の基点方向はダミー図形の基準点から取る
									(if (not (KCFIsShomen))
										; 側面の場合は、バックガード側(==基準点側と仮定)を寸法基点とする
										(progn
											; 01/07/18 MOD HN 最小Ｙ座標を持つ点を基準点とする
											;@MOD@(setq #bpt (car (KCFGetDummyBasePts)))
											(setq #bpt (KCFGetDummyBasePts))
										)
									; 01/06/22 TM ADD-E 側面図の場合の基点方向はダミー図形の基準点から取る
										; 正面の場合は近い方から
										(progn
											; 右勝手
											(if (wcmatch CG_KitType "*-RIGHT")
												(progn
													(if (car &ryo$)
														(setq #bpt (car (car &ryo$)))   ;左
														(progn ; 01/04/16 YM 臨時対応
															(setq #bpt (car (cadr &ryo$))); 01/04/16 YM ADD 吊戸のみのときここを通る
															(setq #bpt (list (car #bpt)(+ 831 (- (cadr #bpt) CG_CeilHeight)))); ﾀﾞﾐｰ 01/04/16 YM ADD
		;;;												(setq #bpt nil) ; 01/04/16 YM ADD 吊戸のみのときここを通る
														) ; 01/04/16 YM 臨時対応
													);_if
												)
												(progn
													(if (car &ryo$)
														(setq #bpt (list (car (cadr (car &ryo$)))(cadr (car (car &ryo$))) 0.0)) ;右
														(progn ; 01/04/16 YM 臨時対応
															(setq #bpt (list (car (cadr (cadr &ryo$)))(cadr (car (cadr &ryo$))) 0.0)) ;右
		;;;												(setq #bpt nil) ; 01/04/16 YM ADD 吊戸のみのときここを通る
														) ; 01/04/16 YM 臨時対応
													);_if
												)
											)
										)
									);_if (not (KCFIsShomen))
								)
							);_if (and (/= nil #gas) #WEn)
						)
						; ダイアログ指定なし？
						(t (princ "\nGetBasePtBySekou error"))
					) ;_cond
					(if #bpt
						(setq #ret$ (list (polar #bpt (* 0.5 PI) CG_CeilHeight) #bpt))
						(progn ; 01/04/16 YM 臨時対応
							(setq #ret$ (list nil nil)) ; 01/04/16 YM ADD 吊戸のみのときここを通る
						) ; 01/04/16 YM 臨時対応
					);_if
				)
			)
		)
	)
	#ret$

); GetBasePtBySekou

;<HOM>*************************************************************************
; <関数名>    : KCFIsShomen
; <処理概要>  : 現在の図形に正面のものが入っているか？
; <戻り値>    : T 入っている nil 入っていない
; <作成>      : 01/06/22 TM
; <備考>      : 展開元図のダミー図形("G_SKDM")が存在すること。
;*************************************************************************>MOH<
(defun KCFIsShomen (
	/
	#ssDum	;	ダミー図形選択セット
	#nII		; 操作変数
	#ret		; 戻り値
	)
	; 図形全体から検索する
	(setq #ssDum (ssget "X" (list (list -3 (list "G_SKDM")))))
	(setq #nII 0)
	(repeat (sslength #ssDum)
		(if (= 1 (nth 3 (CFGetXdata (ssname #ssDum #nII) "G_SKDM"))) (setq #ret 1))
		(setq #nII (1+ #nII))
	)
	#ret

); KCFIsShomen

;<HOM>*************************************************************************
; <関数名>    : KCFGetDummyBasePts
; <処理概要>  : ダミー図形の基準点を求める
; <戻り値>    : 図形がない場合nil その他の場合は基準点
; <作成>      : 01/06/22 TM
; <改訂>      : 01/07/18 HN 戻り値を座標リストから座標に変更
; <備考>      : 展開元図のダミー図形("G_SKDM")が存在すること。
;               最小Ｙ座標を持つ点を基準点とする 01/07/18 ADD HN
;*************************************************************************>MOH<
(defun KCFGetDummyBasePts (
	/
	#ssDum		;	ダミー図形選択セット
	#nII #dd	; 操作変数
	#dRet$		; 座標リスト   01/07/18 HN MOD コメント変更
	#dPt      ; 座標         01/07/18 HN ADD
	#fY       ; Ｙ座標       01/07/18 HN ADD
	#dRet     ; 戻り値       01/07/18 HN ADD
	)
	; 図形全体から検索する
	(setq #ssDum (ssget "X" (list (list -3 (list "G_SKDM")))))
	(setq #nII 0 #dRet$ '())
	(repeat (sslength #ssDum)
		(if (setq #dd (assoc 10 (entget (ssname #ssDum #nII))))
			(setq #dRet$ (append #dRet$ (list (cdr #dd))))
		)
		(setq #nII (1+ #nII))
	)
	#dRet$

	; 01/07/18 S-ADD HN 最小Ｙ座標を持つ点を基準点とする処理を追加
	(setq #dRet (car  #dRet$))
	(setq #fY   (cadr #dRet ))
	(foreach #dPt #dRet$
		(if (> #fY (cadr #dPt))
			(progn
				(setq #dRet #dPt)
				(setq #fY (cadr #dRet))
			)
		)
	)
	#dRet
	; 01/07/18 E-ADD HN 最小Ｙ座標を持つ点を基準点とする処理を追加
); KCFGetDummyBasePts

;<HOM>*************************************************************************
; <関数名>    : C:GetPMEN
; <処理概要>  : P面図形を取得／表示する
; <戻り値>    :
; <作成>      : デバッグ用 01/06/01 TM
; <備考>      : see C:GetPTEN
;*************************************************************************>MOH<
(defun C:GetPMEN (
	/
	#ss
	#i
	#en
	#eg
	#eed$
	#app
	#data$
	)

	(if (setq #ss (ssget "X" (list (list -3 (list "G_PMEN")))))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en    (ssname #ss #i))             ; 図形名取得
				(setq #eg    (entget #en '("*")))         ; 図形データ取得
				(setq #eed$  (cadr (assoc -3 #eg)))       ; 拡張データ取得
				(setq #app   (car #eed$))                 ; アプリケーション名取得
				(setq #data$ (mapcar 'cdr (cdr #eed$)))   ; 属性データ取得
				(cond
					((equal "G_PMEN" #app)                  ; Ｐ面
						; シンク穴、コンロ穴
						(if (or (= 4 (car #data$)) (= 5 (car #data$)))
						; 隠線、外形
						;if (or (= 1 (car #data$)) (= 2 (car #data$)))
							(progn
								(princ "\nP面ｺｰﾄﾞ: ")(princ #data$)(princ "  画層: ")(princ (cdr (assoc 8 #eg)))
								(princ (cdrassoc 10 #eg))
								;(entmod (subst (cons 62 3) (assoc 62 #eg) #eg))
							)
						)
					)
				)
			)
			(setq #i (1+ #i))
		)
		(princ "\nG_PMENの図形はありません.")
	)
	(princ)
)


