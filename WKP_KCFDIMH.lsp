(setq CG_DimOffLen 50)
(setq CG_DimSDispIgnoreMax 120.0)		; 01/03/05 TM ADD 施工寸法のうち、寸法値がこの値以下のものは表示しない

;<HOM>*************************************************************************
; <関数名>    : SCFDrawDimensionPl
; <処理概要>  : 平面図の寸法自動生成
; <戻り値>    : なし
; <作成>      : 00/02/28
; <備考>      : 各展開図（平面）が作成済みであること
;*************************************************************************>MOH<
(defun SCFDrawDimensionPl (
	&dimpat$    ; 出力パターン (((キャビネット寸法 施工寸法 自動・左・右 縦横) (パターン パターン・・・))
	&Zumen      ; 図面種類 商品図 : "02"  施工図 : "03"	2000/07/10 HT ADD
	/
	#clayer 		; 現在の画層
	#pen$				; Ｐ図形のリスト
	#sui 				; 水栓を表すＰ点
	#pten$			; P点図形
	#model$ #flg #ang$ #ang #ss$ #ssall #bpt #basept #entlast
	#zok$ #ss #pm$ #pt$ #iti #drawflg #upt$ #dpt #all$ #iti$
	#ssWt       ; ワークトップの選択セット
	#bUTypeflg  ; ワークトップにU型含む
	#suiAttr$		; 図形属性リスト 01/02/16 TM   とりあえず水栓のみ
	#eSKDM			; 拡張属性
	#iti_sekou	; 施工寸法の終了位置
	#model_bak$	; モデルデータのバックアップ用
	#model			; 単一角度のモデルデータ
	#mmm$       ; モデルデータ foreachループ用  01/08/17 HN ADD
	#enSym$     ; 04/03/24 SK ADD
	#taimen$    ; 対面情報 04/03/24 SK ADD
	#ftpType    ; フラット対面プランタイプ "SF":セミフラット "FF":フルフラット
	#counterPt
	#pm$$				; 09/11/30 T.Arimoto Add 収納拡大
	#pt$$				; 09/11/30 T.Arimoto Add 収納拡大
	#fpm1
	#all2$
#BPD #DPT$ ;2018/10/16 YM ADD
	)
	;-----  初期設定  -----
	;(setvar "CMDECHO" 1)
	(setq #clayer (getvar "CLAYER"))
	(setvar "CLAYER" "0_DIM")
	;----------------------
	; P点、P面獲得
	; ((水栓点 胴縁点 寸法点) (外形面 シンク面 コンロ面))
	; Ｐ点のデータは((属性) Ｐ点座標)
	; Ｐ面のデータは((属性) 対角座標１ 対角座標２)
	(setq #pen$ (SCFGetPEntity "0_PLANE"))

	; 01/07/25 TM ADD ZAN 注意書きを追加
	;
	;   ！！！注意！！！
	;
	;   ここで、上記関数から返ってくる値を以降の処理に都合がいいように変更している。
	;   現在では使用していないデータが含まれているため、実際には「都合のよい」データに
	;   なっていないが、関数の引数の変更の都合上、そのままになっている。
	;
	;   変更前のデータは上記P面、P点獲得の項の通り
	;
	;   変更後のデータは
	;  (水栓データ Ｐ点データ Ｐ面データ)
	;  水栓データ   現在使用していない(座標 ID)
	;  Ｐ点データは (座標 ... )  施工寸法点のみ？
	;  Ｐ面データは ((座標１ 座標２)  ...) 外形面 シンク面 コンロ面
	;  データが存在しない場合は nil
	;
	;  外形データは現状(01/07/25)ではキッチンの場合のみ存在する
	;
	;          水栓データのみ追加  先頭以外  各図形の     P面の
	(setq #pen$ (cons #sui (mapcar 'cdr (mapcar 'car (cadr #pen$)))))
	; DEBUG (princ "\n#pen$: ")
	; DEBUG (princ #pen$)

	(setq #ssall (ssget "X" '((-3 ("G_SKDM")))))

	;モデルを分ける
	; ダミー点G_SKDMのうち、"K" "W"をキッチン、"D"を収納にする。
	; それらを角度毎にわける。
	(setq #model$ (DivSymByLayoutPl))
	(if #model$
		(progn
			; さらに、一直線上にあるものをまとめる
			(setq #model$ (DivAngPtH #model$))

			; 01/07/30 TM DEBUG
			;DEBUG (princ "\nシンボル座標: ")
			;DEBUG (princ (car #model$))
			;DEBUG (foreach #kkk (caddr (car #model$))
			;DEBUG 	(princ "\n点列: ")
			;DEBUG 	(setq #jjj 0)
			;DEBUG 	(repeat (sslength (cadr #kkk))
			;DEBUG 		(princ (cdr (assoc 10 (entget (ssname (cadr #kkk) #jjj)))))
			;DEBUG 		(setq #jjj (1+ #jjj))
			;DEBUG 	)
			;DEBUG )
			; 01/07/30 TM DEBUG
			; 01/07/30 TM MOD-S 暫定対応
			(setq #model_bak$ #model$)
			(setq #model$ '())
			(foreach #mmm$ #model_bak$
				; 01/07/30 TM ZAN とりあえず２つ以上ある場合は、"K" のみにしてみる
				; ??? "D" が入っている場合の意味がよく分からない
				(if (< 1 (length (nth 2 #mmm$)))
					;01/08/17 HN S-MOD "K"がない場合の処理を追加
					;@MOD@(setq #mmm$ (list (nth 0 #mmm$) (nth 1 #mmm$) (list (assoc "K" (nth 2 #mmm$)))))
					(if (assoc "K" (nth 2 #mmm$))
						;01/08/20 HN S-MOD "D"の処理を追加
						; 結局、"K","D"の順に並び替えたのみ
						;@MOD@(setq #mmm$ (list (nth 0 #mmm$) (nth 1 #mmm$) (list (assoc "K" (nth 2 #mmm$)))))
						(if (assoc "D" (nth 2 #mmm$))
							(setq #mmm$ (list (nth 0 #mmm$) (nth 1 #mmm$) (list (assoc "K" (nth 2 #mmm$)) (assoc "D" (nth 2 #mmm$)))))
							(setq #mmm$ (list (nth 0 #mmm$) (nth 1 #mmm$) (list (assoc "K" (nth 2 #mmm$))                          )))
						)
						;01/08/20 HN E-MOD "D"の処理を追加
						(setq #mmm$ (list (nth 0 #mmm$) (nth 1 #mmm$) (nth 2 #mmm$)))
					)
					;01/08/17 HN E-MOD "K"がない場合の処理を追加
				)
				;01/08/17 HN MOD デバッグ文を修正
				;@MOD@;DEBUG (princ "\nモデルデータ")
				;@MOD@;DEBUG (princ #mm$)
				;DEBUG (princ "\nモデルデータ: ")(princ #mmm$) ;DEBUG-HN
				;DEBUG (princ "\nsslength: ")(princ (sslength (cadr (car (nth 2 #mmm$))))) ;DEBUG-HN
				(if #model$
					(setq #model$ (append #model$ (list #mmm$)))
					(setq #model$ (list #mmm$))
				)
			)
			;@DEL@; 01/07/30 TM MOD-E  暫定対応

			; (DivAngPtH)は、
			; 下図のように一直線上にあって離れているものを区別して取得
			;
			;
			;     --------XXX-------
			;    |                  |  <== 全体 + サイドパネル寸法
			;     -- -----    --- --
			;    |  |     |  |   |  |  <== その他の寸法
			;     --------    ------
			;    |cab cab |  | cab  |
			;     --------    ------
			;

			; ワークトップ種類が U 型の時 フラグをたてる
			(setq #ssWt  (ssget "X" (list (list -3 (list "G_WRKT")))))
			(setq #bUTypeflg (SCF_IsUType #ssWt))

			;角度毎に寸法を作図

			(foreach #ang$ #model$

				;角度変更
				(setq #ang (car   #ang$))
				(setq #ss$ (caddr #ang$))

				;シンボル回転
;				(setq #ssall (En$2Ss (apply 'append (mapcar 'Ss2En$ (mapcar 'cadr #ss$)))))
				(setq #bpt (cdrassoc 10 (entget (ssname #ssall 0))))
				(RotateSymDin #bpt #ssall #ang "F" nil)

				;施工寸法基点算出
				(setq #basept (GetBasePtByPlane #ss$ #ang (nth 2 &dimpat$)))

		    (if #basept ;2011/09/30 YM ADD
		      (progn

				(setq #iti$ '())

				;01/08/20 HN S-ADD 基点=nilの場合、従来の方法で再処理（とりあえずの対応）
;				(if (= nil #basept)
;					(progn
;						(setq #ang (car   #ang$))
;						(setq #ss$ (caddr #ang$))
;						;シンボル回転
;						(setq #ssall (En$2Ss (apply 'append (mapcar 'Ss2En$ (mapcar 'cadr #ss$)))))
;						(setq #bpt (cdrassoc 10 (entget (ssname #ssall 0))))
;						(RotateSymDin #bpt #ssall #ang "F" nil)
;						(setq #basept (GetBasePtByPlane #ss$ #ang (nth 2 &dimpat$)))
;					)
;				);_if
				;01/08/20 HN E-ADD 基点=nilの場合、従来の方法で再処理（とりあえずの対応）

				(setq #enSym$ nil)
				(foreach #zok$ #ss$
					(foreach #en (Ss2En$ (cadr #zok$))
						(if (/= nil (CFGetXData #en "G_LSYM"))
							(if (equal #ang (nth 2 (CFGetXData #en "G_LSYM")) 0.01)
								(setq #enSym$ (cons #en #enSym$))
							)
						)
					)
				)
				(setq #taimen$ (SCFGetTaimenFlatPlanInfo #enSym$))
				(if #taimen$
					(setq #basept (list (car #basept) (+ (cadr #basept) (car #taimen$)) (caddr #basept)))
				)

				;？？？　#basept　のZ座標が何故かnilになる。強制的に0にしていいのか？
				(setq #counterPt (GetKitchenCounterBackPos #ang$))
				(if #counterPt
					(if (< (cadr #basept) (cadr #counterPt))
						(setq #basept (list (car #basept) (cadr #counterPt) (caddr #basept)))
;;;						(setq #basept (list (car #basept) (cadr #counterPt) 0.0))   ;2018/11/29 YM MOD ﾛｰｶﾙ変数定義により、これに変更しなくていい
					)
				)
	;2018/11/30 YM ADD  <<<後で消す>>>
;;;	(command "_circle" #basept 50.0)
;;;	(command "_REGEN")
	;2018/11/30 YM ADD

				;？？？　#basept　のZ座標が何故かnilになる。強制的に0にしていいのか？

;|
				;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
				;04/03/24 SK ADD-S 対面プラン対応
				(if (setq #ftpType (SCFIsTaimenFlatPlan))
					(progn
						; 寸法作図対象のシンボル取得
						(foreach #zok$ #ss$
							(setq #enSym$ (append #enSym$ (Ss2En$ (cadr #zok$))))
						)
						; 対面側となるキャビの奥行きと奥行き角度を求める
						;2008/08/14 YM DEL D105,D970は中間ﾎﾞｯｸｽありなので、#taimen$がnilでないがD900はnilが返ってくる
;;;		        (setq #taimen$ (SCFGetTaimenFlatPlanInfo #enSym$))

						;2008/08/13 YM MOD WOODONEはnilが返る==>中間ﾎﾞｯｸｽ性格ｺｰﾄﾞ=117にしたら値が返ってくる
						;07/07/12 YM ADD ｸﾘｴｽﾀD=880対応

								;#ang + (rtos 90)
;;;								(setq #taimen$ (list 220.0 1.5708))

						;対面ﾌﾟﾗﾝ時の調整
						(cond
							((= "D105" (nth 7 CG_GLOBAL$))
							 	;中間ﾎﾞｯｸｽD=200
								(setq #taimen$ (list 400.0 1.5708))
						 	)

							;2009/04/17 YM ADD-S
							((= "D650" (nth 7 CG_GLOBAL$));ｹﾞｰﾄﾀｲﾌﾟ"G*"
							 	;中間ﾎﾞｯｸｽD=100
								(setq #taimen$ (list 350.0 1.5708))
						 	)
							;2009/04/17 YM ADD-E

							((= "D970" (nth 7 CG_GLOBAL$))
							 	;中間ﾎﾞｯｸｽD=130
								(setq #taimen$ (list 320.0 1.5708))
						 	)
							((= "D900" (nth 7 CG_GLOBAL$))
							 	;中間ﾎﾞｯｸｽなし
								(setq #taimen$ (list 250.0 1.5708))
						 	)
							(T
								(setq #taimen$ (list 400.0 1.5708))
						 	)
						);_cond


						; 寸法作図開始点を奥行きを見こした位置に調整する
						(if #taimen$
							(setq #basept (list (car #basept) (+ (cadr #basept) (car #taimen$) 30.)))
						)
					)
				)
				;04/03/24 SK ADD-E 対面プラン対応
				;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
|;
				;GET ENTLAST
				(setq #entlast (entlast))

				(setq #pm$$ nil)
				(setq #pt$$ nil)

				(foreach #zok$ #ss$

					(if (or (and (/= #taimen$ nil) (= (car #zok$) "D"))
									(and (= (car (car #ss$)) "K") (= (car #zok$) "D"))) ; P型の場合
						(princ)
						(progn
							(setq #ss (cadr #zok$))
							(setq #pm$ nil)

							; 01/07/12 TM MOD キッチン／ダイニング兼用に変更
							; ◎P点,P面取得
							;   #pm$: （水洗 外形領域 シンク穴 コンロ穴 施工寸法データ）
							;    01/02/23 TM MOD 施工寸法の平面図表示のため、
							;    施工寸法点のみ、(((X, Y, Z) . 図形ID) ....) のリストに変更
							;    それ以外は点列
							;			(if (= "K" (car #zok$))
							;				(setq #pm$ (GetPenByPlane #pen$ #ss #ang #bpt))
							;				(setq #pm$ (list nil nil nil nil))
							;			)
							; 01/07/12 TM MOD キッチン／ダイニング兼用に変更
							; ◎P点,P面取得
							;   #pm$: （水洗 外形領域 シンク穴 コンロ穴 施工寸法データ）
							;    施工寸法点のみ、(((X, Y, Z) . 図形ID) ....) のリスト
							;    それ以外は点列
							(setq #pm$ (GetPenByPlane #pen$ #ss #ang #bpt (car #zok$)))
							(setq #pm$$ (append #pm$$ (list (list (cadr #zok$) #pm$))))
							; 01/07/12 TM MOD キッチン／ダイニング兼用に変更
							; DEBUG (princ "\nP図形取得(#pm$):\n  ")
							; DEBUG (princ #pm$)

							;座標取得
							; SCF_Pln_GetSym_Kitの戻り値0個めは常にnil
							; キッチンの場合（nil キャビネット シンク・コンロ外形 全体-全体＋サイドパネル）
							;                シンク・コンロ外形未使用
							; 収納の場合（キャビネット nil nil 全体-全体＋サイドパネル）
							; 01/07/13 TM MOD キッチン／ダイニングの関数を共通化
							;			(if (= "K" (car #zok$))
							;				(setq #pt$  (SCF_Pln_GetSym_Kit #ss #pm$ #ang)) ; キッチン
							;				(setq #pt$  (SCF_Pln_GetSym_Din #ss      #ang)) ; ダイニング
							;			)
							; 01/07/13 TM MOD キッチン／ダイニングの関数を共通化
							(setq #pt$  (SCF_Pln_GetSym_Kit #ss #pm$ #ang (car #zok$)))
							(setq #pt$$ (append #pt$$ (list (list (car #zok$) #pt$))))
							; DEBUG (princ "\n寸法座標を取得(#pt$):  \n")
							; DEBUG (princ #pt$)

						)
					);_if
				);(foreach #zok$ #ss$

				(if #bUTypeflg
					(setq #iti_sekou 1)
					(setq #iti_sekou 0)
				);_if

				(setq #fpm1 nil)
				(foreach #pm$ #pm$$
					(setq #fpm1 (or #fpm1 (nth 4 (nth 1 #pm$))))
					(if #bUTypeflg
						(setq #iti 1)
						(setq #iti 0)
					)

					; 施工寸法作図フラグON (==施工図の作図) の場合
					; 01/09/09 HN MOD 施工寸法作図の判定処理を変更
					;@MOD@(if (and (= "1" (nth 1 &dimpat$)) (/= &Zumen CG_OUTSHOHINZU))
					(if (= "1" (nth 1 &dimpat$))
						(progn
							; 施工寸法点・水栓
							(if (or (/= nil (nth 0 (nth 1 #pm$))) (/= nil (nth 4 (nth 1 #pm$))))
								(progn
									(setq #iti (DrawDimPtenByPlane #iti #basept (nth 0 (nth 1 #pm$)) (nth 4 (nth 1 #pm$)) #ang))
									(if (> #iti #iti_sekou)
										(setq #iti_sekou #iti)
									)
								)
							)
						) ;_progn
					);_if (and (= "1" (nth 1 &dimpat$)) (/= &Xuman CG_OUTSHOHINZU))

				);foreach #pm$ #pm$$

				(foreach #pt$ #pt$$

					; キャビネット寸法作図フラグON または 商品図作図を指定の場合
					(if (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU))
						(progn
							;; #pt$ の内容:
							;;  (上シンク・コンロ穴寸法 上キャビネット寸法 下キャビネット寸法 全体＋サイドパネル)
							;;

							; 施工寸法位置
							(setq #iti #iti_sekou)

							; 上側 キャビネット割寸法(ダイニングのみ存在する)
							(if (/= nil (nth 1 (nth 1 #pt$)))
								(progn
									; 01/08/17 HN DEL 不要なデバッグ文を削除
									;@DEL@(princ (car #zok$))
									;@DEL@(princ "\nなんでここに？")
									;@DEL@(princ (nth 1 #pt$))
									(setq #drawflg T)

									(setq #upt$ (nth 1 (nth 1 #pt$)))

									; 施工図の場合、かつ施工寸法がある場合のみ寸法線を足切りする
									(if (and (/= nil #fpm1) (/= 0 #iti))
										(progn
											(setq #basept (polar #basept (* 0.5 PI) (GetDimHeight #iti)))
											(setq #dpt  (polar #basept (* 0.5 PI) CG_DimHeight_1Line))
											; 01/07/25 TM  ??
											(setq #iti -1.5)
											; 2017/06/12 KY ADD-S
											; フレームキッチン対応
											(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
												(setq #iti -0.5)
											)
											; 2017/06/12 KY ADD-E
										)
										(progn
											(setq #dpt  (polar #basept (* 0.5 PI) (GetDimHeight #iti)))
											(setq #iti (1+ #iti))
										)
									)
									; 通常ダイニング:キャビネット割寸法
									; lippleの場合 シンク／コンロ込み
									(SCFDrawDimLin #upt$ #basept #dpt "H")
								)
							)

							; 上側 キャビネット寸法
							(if (/= nil (nth 0 (nth 1 #pt$)))
								(progn
									(setq #drawflg T)
									(setq #upt$ (nth 0 (nth 1 #pt$)))

									; 施工図の場合、かつ施工寸法がある場合のみ寸法線を足切りする
									(if (and (/= nil #fpm1) (/= 0 #iti))
										(progn
											(setq #basept (polar #basept (* 0.5 PI) (GetDimHeight #iti)))
											(setq #dpt  (polar #basept (* 0.5 PI) CG_DimHeight_1Line))
											; 01/07/25 TM  ??
											(setq #iti -0.5)
										)
										(progn
											(setq #dpt  (polar #basept (* 0.5 PI) (GetDimHeight #iti)))
											(setq #iti (1+ #iti))
										)
									)
									; ダイニング／キッチン 全体寸法
									(SCFDrawDimLin #upt$ #basept #dpt "H");★商品図穴寸法、施工図全体寸法(下)★

									;2018/10/03 YM ADD-S 寸法点に円を書く  <<<後で消す>>>
;;;									(foreach #upt #upt$
;;;										(command "_circle" #upt 30.0)
;;;									);foreach
;;;									(command "_circle" #basept 50.0)
;;;									(command "_REGEN")
									;2018/10/03 YM ADD-E

								)
							);_if

							; 下側キャビネット寸法
							(if (/= nil (nth 2 (nth 1 #pt$)))
								(progn
									;下
									(if (/= nil #flg)
										(progn
											(setq #drawflg T)
											(setq #dpt$ (nth 2 (nth 1 #pt$)))
											(setq #bpd  (GetBasePtDown #ss))
											(setq #dpt (polar #bpd (* 1.5 PI) (GetDimHeight 1)))
											(SCFDrawDimLin #dpt$ #bpd #dpt "H")
										)
									)
								)
							)
;-- 2012/03/27 A.Satoh Add - S
							(setq CG_PlanType "SD")
;-- 2012/03/27 A.Satoh Add - E
							; 外形寸法データを貯える(キッチン)
							(if (/= nil (nth 3 (nth 1 #pt$)))
								(progn
									(if (= (nth 0 #pt$) "K")
;-- 2012/03/27 A.Satoh Add - S
										(progn
;-- 2012/03/27 A.Satoh Add - E
										(setq #all$ (append #all$ (nth 3 (nth 1 #pt$))))
;-- 2012/03/27 A.Satoh Add - S
											(setq CG_PlanType "SK")
										)
;-- 2012/03/27 A.Satoh Add - E
									)
									(setq #all2$ (append #all2$ (nth 3 (nth 1 #pt$))))
								)
							)
						)
					);_if (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU))

					(setq #iti$ (cons #iti #iti$))
					(setq #iti nil)
				);_foreach #zok$ #ss$

				; 上側外形寸法(キッチン用)
				(if  (and (/= nil #all$) (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU)))
					(progn
						(setq #iti (apply 'max #iti$))
						(setq #drawflg T)
						;★商品図全体寸法(上)、施工図全体寸法(上)★
						(SCFDrawDimLin #all$ #basept (polar #basept (* 0.5 PI) (GetDimHeight #iti)) "H")

						;2018/10/03 YM ADD-S 寸法点に円を書く  <<<後で消す>>>
;;;									(foreach #all #all$
;;;										(command "_circle" #all 6.0)
;;;									);foreach
;;;									(command "_circle" #basept 10.0)
;;;									(command "_REGEN")
						;2018/10/03 YM ADD-E 寸法点に円を書く

					)
				);_if
				(if (and (= CG_PlanType "SD") (/= nil #all2$) (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU)))
					(progn
						(if (not #iti)
							(setq #iti (- (apply 'max #iti$) 1))
						)
						(setq #all2$ (2dto3d (PtSort (3dto2d #all2$) 0.0 T)))
						(if (> (length #all2$) 2)
							(progn
								(setq #all2$ (list (car #all2$) (last #all2$)))
								(SCFDrawDimLin #all2$ #basept (polar #basept (* 0.5 PI) (GetDimHeight (1+ #iti))) "H")
							)
						)
					)
				);_if

    	);2011/09/30 YM ADD
		);_if

				(setq #all$ nil)
				(setq #all2$ nil)
				(setq #iti nil)
				;シンボル回転
				(RotateSymDin #bpt #ssall #ang "B" #entlast)
			)
			; 横の寸法線作図
			; 寸法作図フラグがON かつ 施工図または商品図寸法がON の場合
			(if (and (/= nil #drawflg) (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU)))
				(DrawSideDimPl #model$)
			)
		)
	)
	(setvar "CLAYER" #clayer)
	(princ)
);SCFDrawDimensionPl

;<HOM>*************************************************************************
; <関数名>    : DivSymByLayoutPl
; <処理概要>  : レイアウト後のシンボルを分ける
; <戻り値>    : （（角度 選択セットリスト）…）
; <作成>      : 00/02/28
; <備考>      : なし
;*************************************************************************>MOH<
(defun DivSymByLayoutPl (
	/
	#ss #i #en #ed$ #en$ #data$ #no #dd #tk$ #tw$ #td$ #kd$ #wd$ #dd$ #flg
	#ssk #ssw #ang$ #ang$$ #ang #ret$
	#nCode$	    ; 性格CODE
	#iCnt       ; カウンタ
	)
	(setq #ss (ssget "X" (list (list -3 (list "G_SKDM")))))
	(if (/= nil #ss)
		(progn
			;モデル番号毎に分ける
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				; ((モデル番号 モデルフラグ 図形名) ...)のリストを作成
				; 01/05/15 TM ADD 駆体をチェックして、シンボルに含めない

				(if (CheckSKK$ #en (list (itoa CG_SKK_ONE_KUT)(itoa CG_SKK_TWO_KUT)(itoa CG_SKK_TWO_KUT))) ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
					nil ; "G_LSYM"存在 and 躯体のとき
					(if (= nil (CheckSKK$ #en (list "9" "0" "0")))  ; 02/03/26 HN ADD その他機器を対象外とする
						(setq #en$ (cons (list (nth 2 #ed$) (nth 1 #ed$) #en) #en$))
					)
				);_if

				(setq #i (1+ #i))
			)
			; モデル番号でソート
			(setq #data$ (SCFmg_sort$ 'car #en$))
			(if #data$
				(progn
					(setq #no (nth 0 (nth 0 #data$)))
					(foreach #dd #data$
						(princ "\n")(princ (list (nth 0 #dd) (cfgetxdata (nth 2 #dd) "G_LSYM")))
						; 最初という意味？ ZAN  01/05/14 TM ADD
						(if (= #no (nth 0 #dd))
							(progn
								(cond
									((= "K" (nth 1 #dd))  (setq #tk$ (cons (cdr #dd) #tk$)))
									((= "W" (nth 1 #dd))  (setq #tw$ (cons (cdr #dd) #tw$)))
									((= "D" (nth 1 #dd))  (setq #td$ (cons (cdr #dd) #td$)))
								)
							)
							(progn
								(if (/= nil #tk$)
									(setq #kd$ (cons (En$2Ss (mapcar 'cadr #tk$)) #kd$))
									(setq #kd$ (cons nil                          #kd$))
								)
								(if (/= nil #tw$)
									(setq #wd$ (cons (En$2Ss (mapcar 'cadr #tw$)) #wd$))
									(setq #wd$ (cons nil                          #wd$))
								)
								(if (/= nil #td$)
									(setq #dd$ (cons (En$2Ss (mapcar 'cadr #td$)) #dd$))
								)
								(setq #tk$ nil)
								(setq #tw$ nil)
								(setq #td$ nil)
								(cond
									((= "K" (nth 1 #dd))  (setq #tk$ (cons (cdr #dd) #tk$)))
									((= "W" (nth 1 #dd))  (setq #tw$ (cons (cdr #dd) #tw$)))
									((= "D" (nth 1 #dd))  (setq #td$ (cons (cdr #dd) #td$)))
								)
								(setq #no   (car #dd))
								(setq #flg nil)
							)
						)
					)

					(if (/= nil #tk$)
						(setq #kd$ (cons (En$2Ss (mapcar 'cadr #tk$)) #kd$))
						(setq #kd$ (cons nil                          #kd$))
					)
					(if (/= nil #tw$)
						(setq #wd$ (cons (En$2Ss (mapcar 'cadr #tw$)) #wd$))
						(setq #wd$ (cons nil                          #wd$))
					)
					(if (/= nil #td$)
						(setq #dd$ (cons (En$2Ss (mapcar 'cadr #td$)) #dd$))
					)
					;各モデルの角度を算出
					;キッチン
					(mapcar
					 '(lambda ( #ssk #ssw )
							(if (/= nil #ssk)
								(progn

									;２角度を獲得
									(setq #ang$ (GetAnglePlan #ssw #ssk))
									;リストに格納
									(setq #ang$$ (cons (car #ang$) #ang$$))
									(if (/= nil (cadr #ang$))
										(setq #ang$$ (cons (cadr #ang$) #ang$$))
									)
								)
							)
						)
						#kd$ #wd$
					)
					;ダイニング
					(foreach #ss #dd$
						; 01/09/09 HN S-MOD 角度取得処理を変更
						; 水平／垂直以外の部材は無視する
						;@MOD@(setq #ang (nth 2 (CfGetXData (ssname #ss 0) "G_LSYM")))
						(setq #iCnt 0)
						(if #ss
							(while (> (sslength #ss) #iCnt)
			 					(setq #ang (nth 2 (CfGetXData (ssname #ss #iCnt) "G_LSYM")))
								; 水平か垂直ならループを抜ける
								(if (equal 0.0 (rem #ang (/ PI 2.0)) 0.00001)
									(setq #iCnt (sslength #ss))
									(setq #iCnt (1+ #iCnt))
								)
							)
						)
						; 01/09/09 HN E-MOD 角度取得処理を変更
						(setq #ang$$ (cons (list #ang "D" #ss) #ang$$))
					)
					;同じ角度でまとめる
					(setq #ret$ (CollectAngle #ang$$))
				)
			)
		)
	)

	#ret$
);_DivSymByLayoutPl

;<HOM>*************************************************************************
; <関数名>    : GetAnglePlan
; <処理概要>  : 各モデルの角度を算出
; <戻り値>    : （
;                 （角度 モデルフラグ 選択セットリスト）
;                 （角度 モデルフラグ 選択セットリスト）L型の時のみ
;               ）
; <作成>      : 00/02/29
; <備考>      : なし
;*************************************************************************>MOH<
(defun GetAnglePlan (
	&ssw        ; モデルの選択エンティティ"W"
	&ssk        ; モデルの選択エンティティ"K"
	/
	#en #ed$ #pt #pt0$ #pt1$ #pt2$ #pt3$ #pt4$ #pt5$ #ang1 #ss1 #ryo$
	#tpt$ #ret1$ #ang2 #ss2 #ret2$

	#ss  ; ワークトップの選択セット
	#pt$ ; ワークトップの頂点リスト
	)

	(mapcar
	 '(lambda ( #en )
			(setq #ed$ (CfGetXData #en "G_SKDM"))
			(setq #pt  (cdrassoc 10 (entget #en)))
			(cond
				((= 0 (nth 3 #ed$))  (setq #pt0$ (list #pt #en)))
				((= 1 (nth 3 #ed$))  (setq #pt1$ (list #pt #en)))
				((= 2 (nth 3 #ed$))  (setq #pt2$ (list #pt #en)))
				((= 3 (nth 3 #ed$))  (setq #pt3$ (list #pt #en)))
				((= 4 (nth 3 #ed$))  (setq #pt4$ (list #pt #en)))
				((= 5 (nth 3 #ed$))  (setq #pt5$ (list #pt #en)))
			)
		)
		(Ss2En$ &ssw)
	)

	(setq #ang1 (Angle0to360 (+ (* PI 0.5) (angle (car #pt1$) (car #pt2$)))))
	(setq #ss1  (ssadd))
	(ssadd (cadr #pt0$) #ss1)
	(ssadd (cadr #pt1$) #ss1)
	(ssadd (cadr #pt2$) #ss1)
	(setq #ryo$ (list (car #pt0$) (car #pt1$) (car #pt2$)))
	(mapcar
	 '(lambda ( #en )
			(setq #tpt$ (GetSym4Pt #en))

			;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
			;04/03/24 SK S-MOD 対面プラン対応
			;サイドパネルは無条件に対象にする
			(if (= CG_SKK_ONE_SID (CFGetSymSKKCode #en 1))
				(progn
					(ssadd #en #ss1)
				)
			;else
				(if
					(or
						(JudgeNaiugaiAng #ryo$ #ang1 (nth 0 #tpt$))
						(JudgeNaiugaiAng #ryo$ #ang1 (nth 1 #tpt$))
					)
					(ssadd #en #ss1)
				)
			)
			;04/03/24 SK E-MOD 対面プラン対応
			;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

		)
		(Ss2En$ &ssk)
	)
	(setq #ret1$ (list #ang1 "K" #ss1))
	(if (/= nil #pt3$)
		(progn
			(setq #ang2 (Angle0to360 (+ (* PI 0.5) (angle (car #pt3$) (car #pt4$)))))
			(setq #ss2 (ssadd))
			(ssadd (cadr #pt0$) #ss2)
			(ssadd (cadr #pt3$) #ss2)
			(ssadd (cadr #pt4$) #ss2)
			(setq #ryo$ (list (car #pt0$) (car #pt3$) (car #pt4$)))
			(mapcar
			 '(lambda ( #en )
					(setq #tpt$ (GetSym4Pt #en))
					(if
						(or
							(JudgeNaiugaiAng #ryo$ #ang2 (nth 0 #tpt$))
							(JudgeNaiugaiAng #ryo$ #ang2 (nth 1 #tpt$))
						)
						(ssadd #en #ss2)
					)
				)
				(Ss2En$ &ssk)
			)
			(if (/= nil #pt5$)
				(progn
					(setq #ang5_1 (Angle0to360 (angle (car #pt0$) (car #pt5$))))
					(setq #ang5_2 (Angle0to360 (+ PI (angle (car #pt0$) (car #pt5$)))))
					(setq #ang1   (Angle0to360 #ang1))
					(setq #ang2   (Angle0to360 #ang2))
					(cond
						((or (equal #ang5_1 #ang1 0.01) (equal #ang5_2 #ang1 0.01))
							(ssadd (cadr #pt5$) #ss1)
						)
						((or (equal #ang5_1 #ang2 0.01) (equal #ang5_2 #ang2 0.01))
							(ssadd (cadr #pt5$) #ss2)
						)
						(T
							nil
						)
					)
				)
			)
			(setq #ret2$ (list #ang2 "K" #ss2))
		)
	)

	(list #ret1$ #ret2$)
) ; GetAnglePlan

;<HOM>*************************************************************************
; <関数名>    : CollectAngle
; <処理概要>  : リストの第一要素でまとめる
; <戻り値>    :
; <作成>      : 00/01/20
; <備考>      : なし(+ PI)
;*************************************************************************>MOH<
(defun CollectAngle (
	&ang$       ; リスト
	/
	#ang$$ #i #tang #tmp$ #ret$
	)
	(setq #ang$$ (SCFmg_sort$ 'car &ang$))
	(setq #i 0)
	(repeat (length #ang$$)
		(if (= nil #tang)
			(setq #tang (car (nth #i #ang$$)))
		)
		(if (equal #tang (car (nth #i #ang$$)) 0.01)
			(progn
				(setq #tmp$ (cons (cdr (nth #i #ang$$)) #tmp$))
			)
			(progn
				(setq #ret$ (cons (list #tang (reverse #tmp$)) #ret$))
				(setq #tmp$ (list (cdr (nth #i #ang$$))))
				(setq #tang (car (nth #i #ang$$)))
			)
		)
		(setq #i (1+ #i))
	)
	(if (/= nil #tmp$)
		(setq #ret$ (cons (list #tang (reverse #tmp$)) #ret$))
	)

	(reverse #ret$)
)

;<HOM>*************************************************************************
; <関数名>    : GetPenByPlane
; <処理概要>  : 各モデル領域内のP点,P面獲得
; <戻り値>    : P点,P面リスト（水栓 外形領域 シンク穴 コンロ穴 施工寸法点リスト）
; <作成>      : 00/02/29
; <備考>      : 01/07/24 TM MOD キッチン／ダイニング両用に変更
; <備考>      : なし
;*************************************************************************>MOH<
(defun GetKitchenCounterBackPos (
	&ang$
	/
	#ssw #ssskdm #en #ed$ #ang #i #ss$ #ss #no #cpt$
	)
	(setq #ssw (ssadd))
	(setq #ssskdm (ssget "X" (list (list -3 (list "G_SKDM")))))
	(if (/= nil #ssskdm)
		(progn
			(setq #i 0)
			(repeat (sslength #ssskdm)
				(setq #en (ssname #ssskdm #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				(if (= (nth 1 #ed$) "W")
					(ssadd #en #ssw)
				)
				(setq #i (1+ #i))
			)
		)
	)
	(if (< 0 (sslength #ssw))
		(progn
			(setq #ang (car &ang$))
			(foreach #ss$ (caddr &ang$)
				(if (= (car #ss$) "K")
					(progn
						(setq #ss (cadr #ss$))
						(if (< 0 (sslength #ss))
							(progn
								(setq #en (ssname #ss 0))
								(setq #ed$ (CfGetXData #en "G_SKDM"))
								(setq #no (nth 2 #ed$))
								(setq #i 0)
								(repeat (sslength #ssw)
									(setq #en (ssname #ssw #i))
									(setq #ed$ (CfGetXData #en "G_SKDM"))
									(if (= #no (nth 2 #ed$))
										(setq #cpt$ (cons (cdrassoc 10 (entget #en)) #cpt$))
									)
									(setq #i (1+ #i))
								)
							)
						)
					)
				)
			)
		)
	)
	(if (/= #cpt$ nil)
		(last (SCFmg_sort$ 'cadr #cpt$))
		nil
	)
)

;<HOM>*************************************************************************
; <関数名>    : GetPenByPlane
; <処理概要>  : 各モデル領域内のP点,P面獲得
; <戻り値>    : P点,P面リスト（水栓 外形領域 シンク穴 コンロ穴 施工寸法点リスト）
; <作成>      : 00/02/29
; <備考>      : 01/07/24 TM MOD キッチン／ダイニング両用に変更
; <備考>      : なし
;*************************************************************************>MOH<
(defun GetPenByPlane (
	&pen$       ; P点,P面リスト
	&ss         ; シンボル選択エンティティ
	&ang        ; モデル回転角度
	&bpt        ; 基点
	&KorD				; キッチン"K" ／ ダイニング "D"
	/
	#i #en #10 #pt$ #minmax #ryo$ #ang #pt1_n$ #pt2_n$ #ret$ #ss #ed$ #pt_n
	#sekou$	; 施工寸法点列
	#eXd$ 	; 拡張データ
	#dPt$		; 操作変数
	#pt0$
	)

	;2018/10/11 YM ADD  <<<後で消す>>>
;;;	(command "_circle" &bpt 5.0)
;;;	(command "_REGEN")
	;2018/10/11 YM ADD

	; シンボルの座標を獲得
	(setq #i 0)
	(repeat (sslength &ss)
		(setq #en  (ssname &ss #i))
		(if (= &KorD "K")
			; キッチンの場合
			(progn
				(setq #10  (cdrassoc 10 (entget #en)))
				(setq #pt$ (cons #10 #pt$))
			)
			(progn
				; 拡張データがあるので、四隅を求める
				(if (CfGetXData #en "G_SYM")
					(progn
						(setq #dPt$ (GetSym4Pt #en))
						(if #pt$
							(setq #pt$ (append #pt$ #dPt$))
							(setq #pt$ #dPt$)
						)
					)
				)
			)
		)
		(setq #i   (1+ #i))
	);_repeat
	; DEBUG (princ "\n全座標: \n")
	; DEBUG (princ #pt$)

	; 領域座標リスト作成(最大限の領域をとる)
	(if #pt$
		(progn
			(setq #minmax (GetPtMinMax #pt$))
			(if #minmax
				(setq #ryo$
					(list
						(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
						(list (car (car  #minmax)) (cadr (car  #minmax)) 0.0)
						(list (car (cadr #minmax)) (cadr (car  #minmax)) 0.0)
						(list (car (cadr #minmax)) (cadr (cadr #minmax)) 0.0)
						(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
					)
				)
				(setq #ryo$ nil)
			)
		)
	)
	; DEBUG(princ "\n領域: ")
	; DEBUG(princ #ryo$)
	(if #ryo$
		(progn
			; 回転角度
			(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))

			;座標変換
			; Ｐ点
			(if (/= nil (car &pen$))
				(setq #pt1_n$
					(mapcar
						'(lambda (#pen)
							(pt1jiHenkanB &bpt #pen #ang)
						)
						(car &pen$)
					)
				)
				(setq #pt1_n$ nil)
			)
			; Ｐ面
			(setq #pt2_n$
				(mapcar
				 '(lambda ( #pt$ )
						(if (/= nil #pt$)
							(list
								(pt1jiHenkanB &bpt (car #pt$) #ang)
								(pt1jiHenkanB &bpt (cadr #pt$) #ang)
							)
							nil
						)
					)
					(cdr &pen$) ; P面
				)
			)

			; 領域内のＰ図形獲得
			; Ｐ点
			(if (and (/= nil #pt1_n$) (JudgeNaigai #pt1_n$ #ryo$))
				(setq #ret$ (cons #pt1_n$ #ret$))
				(setq #ret$ (cons nil     #ret$))
			)
			; Ｐ面
			(foreach #pt$ #pt2_n$
				(if
					(and
						(/= nil (car #pt$))
						(JudgeNaigai (car  #pt$) #ryo$)
						(JudgeNaigai (cadr #pt$) #ryo$)
					)
					(setq #ret$ (cons #pt$ #ret$))
					(setq #ret$ (cons nil  #ret$))
				)
			)

			; 施工寸法点＋図形ＩＤ
			(setq #ss (ssget "X" (list (list -3 (list "G_PTEN")))))
			(if #ss
				(progn
				(setq #i 0)
				(repeat (sslength #ss)
					(setq #en (ssname #ss #i))
					(setq #ed$ (CFGetXData #en "G_PTEN"))
					; 施工寸法点 = 9
					(if (= 9 (nth 0 #ed$))
						(progn
							(setq #10 (cdrassoc 10 (entget #en)))
							(setq #pt_n (pt1jiHenkanB &bpt #10 #ang))
							(if (JudgeNaigai #pt_n #ryo$)
								(progn
									; 01/02/23 TM ADD 図形ID (nth 2 #ed$)  を追加
									(setq #pt_n (cons #pt_n (nth 2 #ed$)))
									(setq #sekou$ (cons #pt_n #sekou$))
								)
							)
						)
					)
					(setq #i (1+ #i))
					)
					(progn
					;;; (princ "施工寸法点がありません。(G_PTEN 存在しない)") 2000/10/24 不要
					)
				)
			)

			(reverse (cons #sekou$ #ret$))
		)
		(list nil nil nil nil nil)
	)
)


;<HOM>*************************************************************************
; <関数名>    : Counter_ZURASHI
; <処理概要>  : ｶｳﾝﾀｰ品番,LRから基点ずらし量を取得
; <戻り値>    : 基点ずらし量(mm) or nil
; <作成>      : 2018/10/18 YM ADD
; <備考>      : なし
;*************************************************************************>MOH<
(defun Counter_ZURASHI (
	&hinban
	&LR
	/
	#QRY$$ #ZURASHI ;2018/11/05 YM ADD
	)

  (setq #QRY$$
    (CFGetDBSQLRec CG_DBSESSION "カウンタ基準点ずらし"
       (list
         (list "品番名称" &hinban 'STR)
				 (list "LR区分"   &LR     'STR)
       )
    )
  )
	(setq #zurashi nil)
	(if (and #QRY$$ (= (length #QRY$$) 1))
		(progn
			(setq #zurashi (nth 3 (car #QRY$$)))
		)
	);_if

	#zurashi
);Counter_ZURASHI

;<HOM>*************************************************************************
; <関数名>    : Counter_ZURASHI_W
; <処理概要>  : ｶｳﾝﾀｰ品番から、反転に使用するW値を取得
; <戻り値>    : W値(mm) or nil
; <作成>      : 2018/10/30 YM ADD
; <備考>      : なし
;*************************************************************************>MOH<
(defun Counter_ZURASHI_W (
	&hinban
	/
	#QRY$$ #zurashi_W ;2018/11/05 YM ADD
	)

  (setq #QRY$$
    (CFGetDBSQLRec CG_DBSESSION "カウンタ基準点ずらし"
       (list
         (list "品番名称" &hinban 'STR)
       )
    )
  )
	(setq #zurashi_W nil)
	(if (and #QRY$$ (= (length #QRY$$) 1))
		(progn
			(setq #zurashi_W (nth 4 (car #QRY$$)))
		)
	);_if

	#zurashi_W
);Counter_ZURASHI_W


;<HOM>*************************************************************************
; <関数名>    : SCF_Pln_GetSym_Kit
; <処理概要>  : 寸法座標獲得  キッチン＆ダイニング
; <戻り値>    : 寸法座標リスト
; <作成>      : 00/03/01
;             : 01/07/13 TM MOD キッチン専用→ダイニングでも使えるように変更
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCF_Pln_GetSym_Kit (
	&ss         ; 選択エンティティ
	&pen$       ; P図形リスト
	&ang        ; 回転角度
	&KorD				; "K" キッチン "D" ダイニング
	/
	#ang #i #en #10 #ed$ #pt$ #pts$ #ptc$ #code$ #pt1 #edl$ #eds$ #angle
	#w #pt2
	#pt1$ #pt2$ #pt3$ #pt4$	; 各段の寸法点列
	#fWideAng   ; 広角度コーナー角度
	#ang2
	#xDin$			; ダイニング用？
	#ftpType
;;;	#frm_flg		; 縦フレーム用のフラグ
;;;	#ptc2$$
	#pttmp #pttmp$
#HINBAN #LR #ZURASHI ;2018/11/05 YM ADD
	)
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	;04/06/16 SK ADD-S 対面プラン対応
	(setq #ftpType (SCFIsTaimenFlatPlan))
	;04/06/16 SK ADD-E 対面プラン対応
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	;座標変換
	(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))

;;; 	; 2017/06/08 KY ADD-S
;;; 	; フレームキッチン対応
;;;	(setq #ptc2$$ nil)
;;; 	; 2017/06/08 KY ADD-E

	(setq #i 0)
	(repeat (sslength &ss)
		(setq #en (ssname &ss #i))
		; 10 定義点? TM
		(setq #10 (cdrassoc 10 (entget #en)))
		; 拡張属性を取得
		(setq #ed$ (CfGetXData #en "G_SKDM"))

		(if (= "W" (nth 1 #ed$))
			(progn ; 正面
				(if (= 0 (nth 3 #ed$))
					(progn
						(setq #pt$  (cons #10 #pt$))
						(setq #pts$ (cons #10 #pts$))
						(setq #ptc$ (cons #10 #ptc$))
					)
				)
				(if (or (= 1 (nth 3 #ed$)) (= 3 (nth 3 #ed$)))
					(progn
						(setq #pt$  (cons #10 #pt$))
						(setq #pts$ (cons #10 #pts$))
						(setq #ptc$ (cons #10 #ptc$))
					)
				)
				(if (= 5 (nth 3 #ed$))
					(setq #pts$ (cons #10 #pts$))
				)
			)
			(progn   ;サイドパネル
				(setq #code$ (CFGetSymSKKCode #en nil))
				(setq #pt1   (cdrassoc 10 (entget #en)))
				(setq #edl$  (CfGetXData #en "G_LSYM"))
				(setq #eds$  (CfGetXData #en "G_SYM"))
				(setq #angle (Angle0to360 (+ #ang (nth 2 #edl$))))

				; 2000/09/06 HT MOD 広角度対応 WIDECAB START
				(if (setq #fWideAng (SCFGetWideCabAng #eds$))
					(progn
					; 広角度の場合
					(setq #ang2 (Angle0to360 (+ (- (* PI 2.0) #fWideAng) (nth 2 #edl$))))
						(if (equal #ang #ang2 0.01)
							(progn
		 					; D方向の角度が回転角度と等しい場合
					 		; (W方向ではなく、D方向がほしい)
								(setq #pt2 (polar #pt1 (+ (- (* PI 2.0) #fWideAng) #angle) (nth 4 #eds$)))
							)
						)
					)
					(progn
						; 一般 (コーナー角度90度の場合)
						(setq #w      (nth 3 #eds$))



						
						;2018/10/16 YM 特定の基準点ずらしｶｳﾝﾀｰの場合、#pt1を補正する(両側ﾄｯﾌﾟ勝ち22.5mm基準点ずらし) @@@@@@@@@@@@@@@@@@@@@  <<<後で消す>>>
						;2018/10/16 YM MOD ｶｳﾝﾀｰの寸法を追加 ﾌﾚｰﾑｷｯﾁﾝのｶｳﾝﾀｰ寸法点追加と同じ処理だが、ｽｲｰｼﾞｨ2018の収納ｶｳﾝﾀｰ寸法表示のために必要
						(if (= 717 (nth 9 #edl$)) ;図形基点ずらしのため、調整が必要
							(progn

								;2018/10/18 YM ADD-S
								(setq #hinban (nth 5 #edl$)) ;品番名称
								(setq #LR     (nth 6 #edl$)) ;LR区分
								(setq #ZURASHI (Counter_ZURASHI #hinban #LR)) ;ｶｳﾝﾀｰ基点ずらし量(22.5mm or 25mm)　ずらしがないとnil
								;2018/10/18 YM ADD-E


								(if #ZURASHI ;ｶｳﾝﾀｰ基点ずらしがあった
									(setq #pt1 (polar #pt1 (+ PI #angle) #ZURASHI)) ;両側ﾄｯﾌﾟ勝ち、片側ﾄｯﾌﾟ勝ちｶｳﾝﾀｰ基点ずれ対応
								);_if
							)
						);_if

						(if (= 1 (nth 8 #eds$))
							(setq #pt2 (polar #pt1       #angle  #w))
							(setq #pt2 (polar #pt1 (+ PI #angle) #w))
						)
					)
				)
				; 2000/09/06 HT MOD 広角度対応 WIDECAB END

				(cond
					;2017/01/25 YM MOD-S
					((and (= CG_SKK_ONE_SID (nth 0 #code$)) (/= CG_SKK_TWO_UPP (nth 1 #code$))  ) ;パネルのうち、アッパーを除外
;;;					((= CG_SKK_ONE_SID (nth 0 #code$))
					;2017/01/25 YM MOD-E

						;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
						; フルフラットでキッチン領域のサイドパネルの平面寸法は不要とする
						(if (and (or (= #ftpType "D105")(= #ftpType "D650")(= #ftpType "D970")(= #ftpType "D900")(= #ftpType "D750")) (= &KorD "K")) ; D750追加 2018/10/03 YM MOD
							(princ)  ;なにもしない
						;else
							(progn
								;2010/11 YM 新ｽｲｰｼﾞｨ 平面SP寸法
								;新ｽｲｰｼﾞｨ対応ﾄｯﾌﾟ勝ち判定を検索
								;CG_GLOBAL$=nilでないときしかﾀﾞﾒ
								;(setq #TOP_F (GetTopFlg))
								;#TOP_F="Y"なら処理を飛ばす
								(setq #pt$  (cons #pt1 #pt$))
								(setq #pt$  (cons #pt2 #pt$))

								;2018/10/11 YM ADD  <<<後で消す>>>
;;;								(command "_circle" #pt1 5.0)
;;;								(command "_circle" #pt2 5.0)
;;;								(command "_REGEN")
								;2018/10/11 YM ADD
							)
						);_if
						;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
					)
					((and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_TWO_BAS (nth 1 #code$)))
						; 2017/06/08 KY MOD-S
						; フレームキッチン対応
						;(setq #ptc$ (cons #pt1 #ptc$))
						;(setq #ptc$ (cons #pt2 #ptc$))
						(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
							(progn
								;ﾌﾚｰﾑｷｯﾁﾝでは縦ﾌﾚｰﾑ,横ﾌﾚｰﾑの寸法を作図したくないから(調理キャビ扱いとしている)
							  nil ;2018/10/16 YM ADD

								; 縦フレームに対する寸法ではなく、カウンターに対する寸法を作図 (2017/07/26)
;;;								(if (= 1 (GetFrameType #eds$ #edl$))
;;;									(progn
;;;										(setq #ptc2$$ (cons (list #pt1 #pt2) #ptc2$$))
;;;									);progn
;;;								);if
								
							);progn
							;else
							(progn
								(setq #ptc$ (cons #pt1 #ptc$))
								(setq #ptc$ (cons #pt2 #ptc$))
							);progn
						);if
						; 2017/06/08 KY MOD-E
					)
				)

				;2018/10/16 YM MOD ｶｳﾝﾀｰの寸法を追加 ﾌﾚｰﾑｷｯﾁﾝのｶｳﾝﾀｰ寸法点追加と同じ処理だが、ｽｲｰｼﾞｨ2018の収納ｶｳﾝﾀｰ寸法表示のために必要
				(if (equal #code$ (list CG_SKK_ONE_CNT CG_SKK_TWO_BAS CG_SKK_THR_DIN) 0.1)
					(progn
						(setq #ptc$ (cons #pt1 #ptc$))
						(setq #ptc$ (cons #pt2 #ptc$))
					);progn
				);if

				; 2017/07/26 KY ADD-S
				; 縦フレームに対する寸法ではなく、カウンターに対する寸法を作図
				(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
					(progn
						(if (equal #code$ (list CG_SKK_ONE_CNT CG_SKK_TWO_BAS CG_SKK_THR_DIN) 0.1)
							(if (IsCounter #eds$ #edl$)
								(progn
									(setq #ptc$ (cons #pt1 #ptc$))
									(setq #ptc$ (cons #pt2 #ptc$))
								);progn
							);if
						);if
					);progn
				);if
				; 2017/07/26 KY ADD-E
			)
		)
		(setq #i (1+ #i))
	)

;;;	; 2017/06/15 KY ADD-S
;;;	; フレームキッチン対応
;;;	;  縦フレームで始点X/終点Xを交互に点列に追加
;;;	;  ※縦フレームのW寸法を作成しないため
;;;	(if #ptc2$$
;;;		(progn
;;;			; 実数値の比較
;;;			;   -1 : 引数1 < 引数2
;;;			;    0 : 引数1 = 引数2
;;;			;    1 : 引数1 > 引数2
;;;			(defun ##comp ( &d1 &d2 / )
;;;				(cond
;;;					((equal &d1 &d2 0.001)
;;;						0
;;;					)
;;;					((< &d1 &d2)
;;;						-1
;;;					)
;;;					(T
;;;						1
;;;					)
;;;				);cond
;;;			);##comp
;;;
;;;			(defun ##PtSortExtra$$ ( &pt$$ / #d1$ #d2$ #pt1s #pt1e #pt2s #pt2e #pt1 #pt2 )
;;;				(defun ###comp ( &pt1 &pt2 )
;;;					(< (+ (* 10 (##comp (nth 0 &pt1) (nth 0 &pt2)))
;;;						(##comp (nth 1 &pt1) (nth 1 &pt2))) 0)
;;;				);###comp
;;;				(vl-sort &pt$$
;;;							'(lambda ( #d1$ #d2$ )
;;;								(setq #pt1s (nth 0 #d1$))
;;;								(setq #pt1e (nth 1 #d1$))
;;;								(setq #pt2s (nth 0 #d2$))
;;;								(setq #pt2e (nth 1 #d2$))
;;;								(setq #pt1 (if (###comp #pt1s #pt1e) #pt1s #pt1e))
;;;								(setq #pt2 (if (###comp #pt2s #pt2e) #pt2s #pt2e))
;;;								(###comp #pt1 #pt2)
;;;							)
;;;				)
;;;			);##PtSortExtra
;;;
;;;			; ソート
;;;			(setq #ptc2$$ (##PtSortExtra$$ #ptc2$$))
;;;
;;;			(setq #frm_flg 0)
;;;			(foreach #pttmp$ #ptc2$$
;;;				(if (= #frm_flg 0)
;;;					  (setq #ptc$ (cons (nth 0 #pttmp$) #ptc$))
;;;					  ;else
;;;					  (setq #ptc$ (cons (nth 1 #pttmp$) #ptc$))
;;;				);if
;;;        (setq #frm_flg (- 1 #frm_flg))
;;;			)
;;;		);progn
;;;	);if
	; 2017/06/15 KY ADD-S

	; 01/07/13 TM MOD-S ダイニング用修正を加える
	(if (= &KorD "K")
		(progn
			(setq #pt1$ (append (nth 2 &pen$) (nth 3 &pen$) #pts$))  ; 上   シンク・コンロ穴
			; #pt2$ はキッチンには不要
			(setq #pt2$ nil)
			(setq #pt3$ (append (nth 1 &pen$) (nth 2 &pen$) #pts$))  ; 下   シンク・コンロ外形
			(setq #pt4$ #pt$)                                        ; 全体 全体＋サイドパネル
		)
		(progn
			; 01/07/25 TM MOD 外側を計算して、キャビネット全体はそれに任せる
			(setq #xDin$ (KCFGetCabLRSidePt (Ss2En$ &ss) &ang))
; 01/07/30 TM MOD 全体寸法とサイドパネルの寸法をキッチンに合わせる
;  		(setq #pt1$ (append                             #pts$ #xDin$))  ; 上 シンク・コンロ穴
;			(setq #pt1$ (append                             #pts$ #xDin$ #pt$))  ; 上 シンク・コンロ穴
;			(setq #pt2$ (append (nth 2 &pen$) (nth 3 &pen$) #ptc$ #xDin$))	; 上 キャビネット全体
			(setq #pt1$ nil)
			(setq #pt2$ (append (nth 2 &pen$) (nth 3 &pen$) #ptc$ #pts$ #xDin$))	; 上 キャビネット全体

									;2018/10/11 YM ADD-S 寸法点に円を書く  <<<後で消す>>>
;;;									(foreach #pt2 #pt2$
;;;										(command "_circle" #pt2 3.0)
;;;									);foreach
;;;									(command "_REGEN")
									;2018/10/11 YM ADD-E

			(setq #pt3$ (append (nth 1 &pen$) (nth 2 &pen$) #pts$))  				; 下 シンク・コンロ外形
; 01/07/30 TM MOD 全体寸法とサイドパネルの寸法をキッチンに合わせる
;  		(setq #pt4$ #pt$)                                        				; 全体 全体＋サイドパネル
			(setq #pt4$ nil)                                        				; 全体 全体＋サイドパネル
			(setq #pt4$ (append #pt1$ #pt2$))
		)
	)
	; 01/07/13 TM MOD-E ダイニング用修正を加える

	(list #pt1$ #pt2$ #pt3$ #pt4$)
); SCF_Pln_GetSym_Kit

;<HOM>*************************************************************************
; <関数名>    : SCF_Pln_GetSym_Din
; <処理概要>  : 寸法座標獲得  ダイニング
; <戻り値>    : 寸法座標リスト
; <作成>      : 00/03/01
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCF_Pln_GetSym_Din (
	&ss         ; 選択エンティティ
	&ang        ; 回転角度
	/
	#ang #en #side$ #en$ #pt1 #edl$ #eds$ #angle #w #pt2 #sidept$ #tpt$ #spt$
	)
	;座標変換
	(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))
	; サイドパネル／キャビネットを分ける
	(foreach #en (Ss2En$ &ss)
		(if (= CG_SKK_TWO_BAS (CFGetSymSKKCode #en 2))
			(if (= CG_SKK_ONE_SID (CFGetSymSKKCode #en 1))
				(progn
					(setq #side$ (cons #en #side$))  ; サイドパネル
				)
				(progn
					; 01/06/25 TM 性格CODE１桁目が 9(==その他or 駆体)のものを外す
					(if (/= CG_SKK_ONE_ETC (CFGetSymSKKCode #en 1))
						(setq #en$   (cons #en #en$))    ; キャビネット
					)
				)
			)
		);_if (= CG_SKK_TWO_BAS (CFGetSymSKKCode #en 2))
	)

	;サイドパネル座標算出
	(if (/= nil #side$)
		(progn
			(foreach #en #side$
				(setq #pt1   (cdrassoc 10 (entget #en)))
				(setq #edl$  (CfGetXData #en "G_LSYM"))
				(setq #eds$  (CfGetXData #en "G_SYM"))
				(setq #angle (Angle0to360 (+ #ang (nth 2 #edl$))))
				(setq #w     (nth 3 #eds$))
				(if (= 1 (nth 8 #eds$))
					(setq #pt2 (polar #pt1       #angle  #w))
					(setq #pt2 (polar #pt1 (+ PI #angle) #w))
				)
				(setq #sidept$ (cons #pt1 #sidept$))
				(setq #sidept$ (cons #pt2 #sidept$))
			)
		)
	)

	;キャビネットの座標の最左と最右の座標を獲得
	(if (/= nil #en$)
		(progn
			(foreach #en #en$
				(setq #pt1   (cdrassoc 10 (entget #en)))
				(setq #edl$  (CfGetXData #en "G_LSYM"))
				(setq #eds$  (CfGetXData #en "G_SYM"))
				(setq #angle (Angle0to360 (+ #ang (nth 2 #edl$))))
				(setq #w     (nth 3 #eds$))
				(if (= 1 (nth 8 #eds$))
					(setq #pt2 (polar #pt1       #angle  #w))
					(setq #pt2 (polar #pt1 (+ PI #angle) #w))
				)
				(setq #tpt$ (cons #pt1 #tpt$))
				(setq #tpt$ (cons #pt2 #tpt$))
			)
			(setq #tpt$ (PtSort #tpt$ (angtof "5") T))
	;      (setq #spt$ (list (car #tpt$) (last #tpt$)))
			(setq #spt$ #tpt$)
			(setq #sidept$ (cons (car  #tpt$) #sidept$))
			(setq #sidept$ (cons (last #tpt$) #sidept$))
		)
	)

	(list #spt$ nil nil #sidept$)
) ; SCF_Pln_GetSym_Din


;<HOM>*************************************************************************
; <関数名>    : KCFGetCabLRSidePt
; <処理概要>  : キャビネットの座標の最左と最右の座標を獲得
; <戻り値>    : 点列
; <作成>      : 01/07/13 TM ADD
; <備考>      :
;*************************************************************************>MOH<
(defun KCFGetCabLRSidePt (
	&en$		; キャビネットの図形リスト
	&ang		; 図形の角度
	/
	#en				; キャビネット図形
	#pt1			; 図形基点
	#edl$			; G_LSYM 拡張データ
	#eds$			; G_SYM 拡張データ
	#angle		; 図形の角度
	#w				; W方向延長
	#sidept$	; 点列
	#tpt$			; 操作変数
	#pt2			;
#HINBAN #LR #SPT$ #ZURASHI ;2018/11/05 YM ADD
	)

	;キャビネットの座標の最左と最右の座標を獲得
	(if (/= nil &en$)
		(progn
			(foreach #en &en$
				(setq #pt1   (cdrassoc 10 (entget #en)))
				(setq #edl$  (CfGetXData #en "G_LSYM"))
				(setq #eds$  (CfGetXData #en "G_SYM"))
				(setq #angle (Angle0to360 (+ (Angle0to360 (- (* 2.0 PI) &ang)) (nth 2 #edl$))))


						;2018/10/16 YM 特定の基準点ずらしｶｳﾝﾀｰの場合、#pt1を補正する(両側ﾄｯﾌﾟ勝ち22.5mm基準点ずらし) @@@@@@@@@@@@@@@@@@@@@  <<<後で消す>>>
						;2018/10/16 YM MOD ｶｳﾝﾀｰの寸法を追加 ﾌﾚｰﾑｷｯﾁﾝのｶｳﾝﾀｰ寸法点追加と同じ処理だが、ｽｲｰｼﾞｨ2018の収納ｶｳﾝﾀｰ寸法表示のために必要
						(if (= 717 (nth 9 #edl$)) ;図形基点ずらしのため、調整が必要
							(progn

								;2018/10/18 YM ADD-S
								(setq #hinban (nth 5 #edl$)) ;品番名称
								(setq #LR     (nth 6 #edl$)) ;LR区分
								(setq #ZURASHI (Counter_ZURASHI #hinban #LR)) ;ｶｳﾝﾀｰ基点ずらし量(22.5mm or 25mm)　ずらしがないとnil
								;2018/10/18 YM ADD-E

								(if #ZURASHI ;ｶｳﾝﾀｰ基点ずらしがあった
									(setq #pt1 (polar #pt1 (+ PI #angle) #ZURASHI)) ;両側ﾄｯﾌﾟ勝ち、片側ﾄｯﾌﾟ勝ちｶｳﾝﾀｰ基点ずれ対応
								);_if

							)
						);_if


				(setq #w     (nth 3 #eds$))
				; キャビネット方向に合わせる
				(if (= 1 (nth 8 #eds$))
					(setq #pt2 (polar #pt1       #angle  #w))
					(setq #pt2 (polar #pt1 (+ PI #angle) #w))
				)
				(setq #tpt$ (cons #pt1 #tpt$))
				(setq #tpt$ (cons #pt2 #tpt$))
			)
			(setq #tpt$ (PtSort #tpt$ (angtof "5") T))
			(setq #spt$ #tpt$)
			(setq #sidept$ (cons (car  #tpt$) #sidept$))
			(setq #sidept$ (cons (last #tpt$) #sidept$))
		)
	)
	#sidept$

) ; KCFGetCabLRSidePt


;<HOM>*************************************************************************
; <関数名>    : DrawDimPtenByPlane
; <処理概要>  : 施工寸法・水栓寸法を作図する
; <戻り値>    : 表示高さ位置 (#iti)
; <作成>      : 01/03/05 TM
; <備考>      : 寸法基点
;               L型・W型           ：コーナーキャビ基点
;               I型                ：コンロキャビ側
;               I型でコンロがない時：左右近いほう
;*************************************************************************>MOH<
(defun DrawDimPtenByPlane (
	&iIti       ; 寸法位置
	&xBase      ; 基準点
	&xSui				; 水栓の座標
	&xSek$      ; 施工寸法点 と属性のリスト
	&rAng				; 作図図形の角度
	/
	#xPten$					; 寸法作図用点＋属性列
	#rBase					;	寸法描画用基準座標
	#rSui						; 寸法描画用寸法点
	#iIti						; 表示位置変数
	#eEn						; 作図図形エンティティ
	)

	; 水栓の寸法が存在する場合
	(if (/= nil &xSui)
		(progn

			; 施行寸法点と一緒にソートして作図するため、施工寸法点と属性のデータを作成する
			; ダミーの寸法図形ID -1 を追加する
			(setq #xPten$ (list (cons &xSui -1)))

		)
	)

	; 施工寸法が存在する場合
	(if (/= nil &xSek$)
		(progn
			; 施工寸法点と属性データを設定(追加)
			(setq #xPten$ (append #xPten$ &xSek$))
		)
	)

	; 水栓寸法と施工寸法を座標順に描画する
	(setq #iIti (DrawDimSekouByPlane &iIti &xBase #xPten$ &rAng))

	#iIti

)

;<HOM>*************************************************************************
; <関数名>    : DrawDimSuisenBGByPlane
; <処理概要>  : 水栓のＢＧからの寸法を作図
; <戻り値>    :
; <作成>      : 00/03/05 TM
; <備考>      :
;*************************************************************************>MOH<
(defun DrawDimSuisenBGByPlane (
	&xSui			; 水栓の座標 と属性
	&xBasePt	; 作図の基準点
	/
	#rBGPt		;
	#xPt			; 計算する点
	)
	(if (/= nil &xSui)
		(progn
			; BGからの水栓寸法を作図する
			; BG 基準点
			(setq #xPt (car (3dto2d &xSui)))
			(setq #rBGPt (inters &xBasePt (polar &xBasePt 0.0 10.0) #xPt (polar #xPt (* PI 0.5) 10.0) nil))
			(SCFDrawDimLin (list #rBGPt #xPt) nil (polar #xPt PI CG_DimOffLen) "V")
		)
		(progn
;			(princ "\nDrawDimSuisenBGByPlane: ")
;			(princ &xSui)
		)
	)

	(princ)
)


;; 01/03/05 TM DEL-S この関数の機能は DrawDim*ByPlane に移しました
;<HOM>*************************************************************************
; <関数名>    : DrawDimSuisenByPlane
; <処理概要>  : 水洗の施工寸法を作図
; <戻り値>    : 位置 (1インクリメントした値)
; <作成>      : 00/02/24
; <備考>      : 寸法基点
;               L型・W型           ：コーナーキャビ基点
;               I型                ：コンロキャビ側
;               I型でコンロがない時：左右近いほう
;*************************************************************************>MOH<
(defun DrawDimSuisenByPlane (
;  &bpt        ; 基準点
;  &ppt        ; 施工寸点
;  &iti        ; 位置
;  /
;  #bpt #ppt #pt
;	#eEn				; 作図図形エンティティ
	)
;  (setq #bpt (car (3dto2d (list &bpt))))
;  (setq #ppt (car (3dto2d (list &ppt))))
;  ;基点からの寸法作図
;  ;(SCFDrawDimLin (list #bpt #ppt) nil (polar #bpt (* PI 0.5) (GetDimHeight 0)) "H") ;2000/09/14 DEL
;	; 01/03/05 TM MOD ZAN 暫定対応 寸法値が一定の値以下の場合は表示しないようにする
;	(if (< CG_DimSDispIgnoreMax (abs (- (car #bpt) (car #ppt))))
;		(SCFDrawDimLin (list #bpt #ppt) nil (polar #bpt (* PI 0.5) (GetDimHeight &iti)) "H") ;2000/09/14 ADD
;	)
;
;  ;BGからの寸法作図
;  (setq #pt (inters #bpt (polar #bpt 0.0 10.0) #ppt (polar #ppt (* PI 0.5) 10.0) nil))
;  (SCFDrawDimLin (list #pt #ppt) nil (polar #ppt PI CG_DimOffLen) "V")
;
;  (1+ &iti)
	(princ "\nDrawDimSuisenByPlane: この関数は現在使われておりません。\n御確かめください。TM")
)
;; 01/03/05 TM DEL-E この関数の機能は DrawDim*nByPlane に移しました

;<HOM>*************************************************************************
; <関数名>    : DrawDimSekouByPlane
; <処理概要>  : 施工寸法・水栓を作図
; <戻り値>    : 位置
; <作成>      : 00/02/24
;							; 01/03/05 TM 水栓寸法作図を統合
; <備考>      : 寸法基点
;               L型・W型           ：コーナーキャビ基点
;               I型                ：コンロキャビ側
;               I型でコンロがない時：左右近いほう
;*************************************************************************>MOH<
(defun DrawDimSekouByPlane (
	&iti        ; 位置
	&bpt        ; 基準点
	&ppt$       ; 施工寸法点 と属性
	&rAng				; 作図図形の角度		: 01/04/24 TM ADD
	/
	#bpt #iti #ppt$ #ppt
	#eEn						; 作図図形エンティティ
	#xSui$					; 水栓寸法点列
	#xSek$					; 施工寸法点列
	#xPten$					; 作図する点列
	#ii	#pp$	#nID	; 操作変数
	#rBGPt					; ＢＧ寸法描画用基準点
	#isRotate				; 寸法作成後回転するか（Ｌ型のみ）
	#isRotateRight	; 寸法作成後右側が回転するか（Ｌ型のみ）
#RDIMANG ;2018/11/05 YM ADD
	)
	(setq #bpt (car (3dto2d (list &bpt))))
	(setq #iti &iti)

	; ソート比較用座標列を作成 TM ADD
	(foreach #ii &ppt$
		; 施工寸法点と水栓寸法点を分ける
		(if (= -1 (cdr #ii))
			(setq #xSui$ (append #xSui$ (list (car #ii))))
			(setq #xSek$ (append #xSek$ (list (car #ii))))
		)
	)

	; 施工寸法点の位置によって、座標順にソートする
	; 01/02/26 TM MOD-S
	;  (if (< (car #bpt) (car (car #ppt$)))
	;    (setq #ppt$ (PtSort #ppt$ 0.0 T))
	;    (setq #ppt$ (PtSort #ppt$ PI  T))
	;  )
	; 01/02/26 TM MOD-M
	; (後で回転移動する) 縦寸法には水栓の寸法は含めない
	(if (< (car #bpt) (car (car (car &ppt$))))
		; 寸法点が基準点の右側にある場合(後で回転移動する)
		(progn
			; 右勝手の場合、シンクが来るので水栓寸法要
			(if (wcmatch CG_KitType "*-RIGHT")
				(progn
					(setq #xPten$ (PtSort (append #xSui$ #xSek$) 0.0 T))
					(DrawDimSuisenBGByPlane #xSui$ #bpt)
				)
				(progn
					(setq #xPten$ (PtSort #xSek$ 0.0 T))
				)
			)
		)
		; 寸法点が基準点の左側にある場合
		(progn
			(if (wcmatch CG_KitType "*-RIGHT")
				(progn
					(setq #xPten$ (PtSort #xSek$ PI T))
				)
				(progn
					(setq #xPten$ (PtSort (append #xSui$ #xSek$) PI  T))
					(DrawDimSuisenBGByPlane #xSui$ #bpt)
				)
			)
		)
	)
	; 01/02/26 TM MOD-E

	; 01/04/24 TM MOD
	; 後で回転移動する横寸法表示かをチェックする
	; L 型の場合、最初にすべての寸法を書いてから、図形ごと９０度回転する。
	; このため、回転後の寸法の左右／上下の位置が逆転する場合があるため、修正する。
	; どの方向に平面寸法が作図されるかをチェックして、
	; (平面図は必ずＡ矢視が上になることから) 修正の有無を決定する

	; 01/04/24 TM ADD 計算用の角度==表示する寸法が出力される向き
	(setq #rDimAng (Angle0to360 (+ (* 0.5 PI) &rAng)))

	; ソートした順番に施工寸法点と属性のリストを並べ替える
	(foreach  #ii #xPten$
		(setq #pp$ (append #pp$ (list (assoc #ii &ppt$))))
	)
	; 01/02/26 TM MOD-E

	(foreach #ppt #pp$
		; 01/02/22 TM MOD 施工寸法点リストのデータ中に図形ID を追加
		; (setq #ppt (car (3dto2d (list #ppt))))
		(setq #nID (cdr #ppt))
		(setq #ppt (car (3dto2d (list (car #ppt)))))
		; 基点からの寸法作図
		; 01/03/04 TM MOD L型の縦向き寸法表示の抑制

		; 01/03/05 TM MOD ZAN 暫定対応 寸法値が一定の値以下の場合は表示しないようにする
		(if (< CG_DimSDispIgnoreMax (abs (- (car #bpt) (car #ppt))))
			(progn
				; 01/04/24 TM ADD 寸法表示角度が裏側（下と右）になる場合、予め表示位置を裏返す
				(if (or (equal #rDimAng 0 0.01) (equal #rDimAng (* 1.5 PI)))
					(progn
						(SCFDrawDimLin (list #bpt #ppt) nil (polar #bpt (* PI 0.5) (GetDimHeight #iti)) "H")
						; 01/05/31 TM MOD 施工寸法文字列が未登録の場合に対応
						(if (SCFUpdDimStr (entlast) #nID)
							(SCFUpdDimStrPlacement (entlast) #ppt "R" (list 0.0 (- CG_DimHeight_1Line) 0.0) T)
						)
					)
					; 左寄せ・線の上（デフォルト）
					(SCFDrawDimLinAddStr (list #bpt #ppt) nil (polar #bpt (* PI 0.5) (GetDimHeight #iti)) "H" #nID)
				)
				(setq #iti (1+ #iti))
			)
		)
	)

	#iti
) ; DrawDimSekouByPlane

;<HOM>*************************************************************************
; <関数名>    : RotateSymDin
; <処理概要>  : ダイニングのモデルを角度で回転
; <戻り値>    : なし
; <作成>      : 00/02/18
;*************************************************************************>MOH<
(defun RotateSymDin (
	&bpt        ; 基点
	&ss         ; ダイニングのシンボルの選択エンティティ
	&ang        ; モデルの回転角度
	&flg        ; 作図フェーズフラグ（"F":作図前 "B":作図後）
	&entlast    ; 作図前のentlast
	/
	#ang #ss #en
	)
	(if (= "F" &flg)
		(progn
			(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))
			(setq #ss &ss)
		)
		(progn
			(setq #ang &ang)
			(setq #ss &ss)
			(setq #en &entlast)
			(if #en ;2011/09/30 YM ADD
				(progn
					(while (setq #en (entnext #en))
						(ssadd #en #ss)
					)
				)
			);_if ;2011/09/30 YM ADD
		)
	)
	(if (/= nil #ss)
		(progn
			(command "_rotate" #ss "" &bpt (angtos #ang (getvar "AUNITS") CG_OUTAUPREC))
		)
	)

	(princ)
) ; GetDiningAngle

;<HOM>*************************************************************************
; <関数名>    : GetBasePtByPlane
; <処理概要>  : 施工寸法の基準点を取得
; <戻り値>    : 基点
; <作成>      : 00/03/02
; <備考>      : L型・W型           ：コーナーキャビ基点
;               I型                ：コンロキャビ側
;               I型でコンロがない時：左右近いほう
;               注）この関数は図形を回転させた後に適用
;*************************************************************************>MOH<
(defun GetBasePtByPlane (
	&ss$        ; 選択エンティティリスト
	&ang        ; 回転角度
	&flg        ; 出力方向フラグ（I型のみ有効）
	/
	#zok$ #kind #ss #en #ed$ #ret #ang #pt$ #pt1 #pt2 #code$ #gas #sang
	#pt3 #ptK$ 
	)


	;<HOM>*************************************************************************
	; <関数名>    : ##Get2PtAng
	; <処理概要>  : シンボルの基点とW方向点を変換する角度で変換して獲得
	; <戻り値>    : ２点座標
	;*************************************************************************>MOH<
	(defun ##Get2PtAng (
		&ang        ; 変換する角度
		&en         ; シンボル図形名
		/
		#pt1 #edl$ #eds$ #angle #w #pt2
		#code$ #bWflg #code$ #fWideAng
		)
		(setq #pt1   (cdrassoc 10 (entget &en)))
		(setq #edl$  (CfGetXData &en "G_LSYM"))
		(setq #eds$  (CfGetXData &en "G_SYM"))
		(setq #angle (Angle0to360 (+ &ang (nth 2 #edl$))))
		(setq #code$ (CFGetSymSKKCode &en nil))
		(setq #bWflg T) ; W寸法取得フラグ T
		; コーナーキャビ
		(if (and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_THR_CNR (nth 2 #code$)))
			(progn
				; 同方向にない場合
				(if (not (equal &ang (nth 2 #edl$) 0.01))
					(progn
						; D寸法取得
						(setq #pt2 (polar #pt1 #angle (nth 4 #eds$)))
						(setq #bWflg nil) ; W寸法取得フラグ nil
					)
				)
			)
		)
		(if (= #bWflg T)
			(progn
			(setq #w     (nth 3 #eds$))
			; キャビネット向きに方向を合わせる
			(if (= 1 (nth 8 #eds$))
				(setq #pt2 (polar #pt1       #angle  #w))
				(setq #pt2 (polar #pt1 (+ PI #angle) #w))
			)
			)
		)
		(list #pt1 #pt2)
	)
	;==============================================================================

	;<HOM>*************************************************************************
	; <関数名>    : ##Pt$XangYmax
	; <処理概要>  : X座標最小(角度0) or X座標最大(角度PI) and  Y座標最大を取得
	; <戻り値>    : 座標
	; <備考>      : 角度X方向の最後端、かつY座標最大の座標を求める(角度=0 or PI)
	;*************************************************************************>MOH<
	(defun ##Pt$XangYmax (
		 &pt$		; 座標列
		 &ang		; 比較基準となる方向
		 /
		 #pt$
		 #Ret
		 )
		 (setq #pt$ (PtSort &pt$ &ang T)) ;★★★　X,Yともに同じ座標の点を省いている　&ang＝０ならX座標が小さいもの順にソート

		 ; 先頭を取得(最小が複数ある場合に対応)
     ; vl-remove-if-not  指定されたリストの要素の中で、テスト関数に合格したすべての要素を返します。
     ; ★★★　点列リストの先頭のX座標と等しい点だけを抽出している
		 (setq #pt$ (vl-remove-if-not '(lambda (#l) (= (car(car #pt$)) (car #l))) #pt$))

		 ; 先頭のうちY方向が最大
		 (setq #Ret (car (PtSort #pt$ (- (/ PI 2.0)) T))); ★★★　Y座標が大きいもの順にソートしている

     ; X座標最小(角度0) or X座標最大(角度PI) and  Y座標最大を取得
		 ; (##Pt$XangYmax (list '(10 2 0) '(10 3 0) '(2 2 0) '(2 3 0) '(33 2 0) '(33 3 0) '(4 2 0) '(4 3 0) ) 0.0)
     ; (2 3 0)
		 #Ret
	)
	;==============================================================================


	;<HOM>*************************************************************************
	; <関数名>    : ##Pt3Dto2D
	; <処理概要>  : (x y z)==>(x y)
	; <戻り値>    : 座標
	; <備考>      : 
	;*************************************************************************>MOH<
	(defun ##Pt3Dto2D (
		 &pt
		 /
			#RET ;2018/11/30 YM ADD-S
		 )
		 (setq #ret (list (nth 0 &pt) (nth 1 &pt)))
		 #ret
	)
	;==============================================================================


	; 09/04/17 T.Ari Mod
	; カウンターの一番後ろを取得
	; 第一条件：コーナーキャビ基点
	(setq #ptK$ nil)
	(foreach #zok$ &ss$
		(setq #kind (car  #zok$))
		(setq #ss   (cadr #zok$))
		(if (= "K" #kind)
			(progn
				(foreach #en (Ss2En$ #ss)
					(setq #ed$ (CfGetXData #en "G_SKDM"))
					(if (= "C" (nth 5 #ed$))
						(setq #ret (cdrassoc 10 (entget #en)))
						(if (= "W" (nth 2 #ed$))
							(setq #ptK$ (cons (cdrassoc 10 (entget #en)) #ptK$))
						)
					)
				); foreach
			)
		)
	); foreach

	; 第二条件：指定方向、またはコンロ側
	(if (= nil #ret)
		(progn
			(cond
				; 左指定
				((= "L" &flg)
					(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))
					(foreach #zok$  &ss$
						(setq #kind (car  #zok$))
						(setq #ss   (cadr #zok$))
						(if (= "K" #kind)
							(foreach #en (Ss2En$ #ss)
								(setq #ed$ (CfGetXData #en "G_SKDM"))
								(if (= "K" (nth 1 #ed$))
									(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
								)
							)
							(foreach #en (Ss2En$ #ss)
								(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
							)
						)
					)
					(setq #ret (##Pt$XangYmax #pt$ 0.0))
				)
				; 右指定
				((= "R" &flg)
					(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))
					(foreach #zok$  &ss$
						(setq #kind (car  #zok$))
						(setq #ss   (cadr #zok$))
						(if (= "K" #kind)
							(foreach #en	(Ss2En$ #ss)
								(setq #ed$ (CfGetXData #en "G_SKDM"))
								(if (= "K" (nth 1 #ed$))
									(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
								)
							)
							(foreach #en (Ss2En$ #ss)
								(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
							)
						)
					)
					(setq #ret (##Pt$XangYmax #pt$ PI))
				)
				; 自動設定(コンロがある場合、コンロ側)
				((= "A" &flg)
					;座標変換
					(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))
					(foreach #zok$ &ss$
						(setq #kind (car  #zok$))
						(setq #ss   (cadr #zok$))
						; キッチンキャビネット
						(if (= "K" #kind)
							(progn
								(foreach #en (Ss2En$ #ss)
									(setq #ed$ (CfGetXData #en "G_SKDM"))
									(cond
										; 基点
										((and (= "W" (nth 1 #ed$)) (= 0 (nth 3 #ed$)))
											(setq #pt1 (cdrassoc 10 (entget #en)))
										)
										; W方向点
										((and (= "W" (nth 1 #ed$)) (= 1 (nth 3 #ed$)))
											(setq #pt2 (cdrassoc 10 (entget #en)))
										)
										; D方向点
										((and (= "W" (nth 1 #ed$)) (= 3 (nth 3 #ed$)))
											(setq #pt2 (cdrassoc 10 (entget #en)))
										)
										; キッチンキャビ
										((= "K" (nth 1 #ed$))
											(setq #code$ (CFGetSymSKKCode #en nil))
											(if (= CG_SKK_ONE_CAB (nth 0 #code$))
												(progn
													; コンロキャビの場合コンロを取得
													(if
													 (and
														 (= CG_SKK_TWO_BAS (nth 1 #code$))
														 (= CG_SKK_THR_GAS (nth 2 #code$))
													 )
													 (setq #gas (cdrassoc 10 (entget #en)))
													)
													; キャビネットの２点を取得
													(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
												)
											)
											; 2000/09/20 HT END
										)
									)
								); foreach

								; 基点の間にコンロがある場合、コンロに近い方からに方向設定する
								(if (/= nil #gas)
									(progn
										(if
											(and
												(< (distance #pt1 #gas) (distance #pt2 #pt1))
												(< (distance #pt2 #gas) (distance #pt2 #pt1))
											)
											(progn
												(if (< (distance #pt1 #gas) (distance #pt2 #gas))
													(progn
														(setq #sang (angle #pt1 #pt2))
													)
													(progn
														(setq #sang (angle #pt2 #pt1))
													)
												) ;if (< (distance #pt1 #gas) (distance #pt2 #gas))

												(setq #ret (##Pt$XangYmax #pt$ #sang))
											)
										); if
									)
								);if (/= nil #gas)
								; 09/04/17 T.Ari Mod カウンター背面のラインを基準点に修正
								(if (and (/= nil #ret) (/= nil #ptK$))
									(setq #ret
										(list
											(nth 0 #ret)
											(nth 1 (car (PtSort (cons #ret #ptK$) (- (/ PI 2.0)) T)))
											(nth 2 #ret)
										)
									)
								)
							)
							(progn
								(foreach #en (Ss2En$ #ss)
										(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
										(setq #code$ (CFGetSymSKKCode #en nil))
										(if
										 (and
											 (= CG_SKK_TWO_BAS (nth 1 #code$))
											 (= CG_SKK_THR_GAS (nth 2 #code$))
										 )
										 (if (= (nth 6 (CfGetXData #en "G_LSYM")) "L")
											 (setq #gas (nth 1 (##Get2PtAng #ang #en)))
											 (setq #gas (cdrassoc 10 (entget #en)))
										 )
										)
									)
								; 06/09/27 T.Ari Mod-S ワークトップがなくコンロキャビがあるプラン対応
									(if #gas
										(progn
											(setq #pt1 (##Pt$XangYmax #pt$ 0.0))
											(setq #pt2 (##Pt$XangYmax #pt$ PI))
											(if
												(and
													(<= (distance (##Pt3Dto2D #pt1) (##Pt3Dto2D #gas)) (distance (##Pt3Dto2D #pt2) (##Pt3Dto2D #pt1)) )
													(<= (distance (##Pt3Dto2D #pt2) (##Pt3Dto2D #gas)) (distance (##Pt3Dto2D #pt2) (##Pt3Dto2D #pt1)) )
												)
												(progn
													(if (< (distance (##Pt3Dto2D #pt1) (##Pt3Dto2D #gas)) (distance (##Pt3Dto2D #pt2) (##Pt3Dto2D #gas)))
														(progn
															(setq #sang (angle #pt1 #pt2))
														)
														(progn
															(setq #sang (angle #pt2 #pt1))
														)
													) ;if (< (distance #pt1 #gas) (distance #pt2 #gas))

													(setq #ret (##Pt$XangYmax #pt$ #sang))
												)
											); if
										)
									);_if
								; 06/09/27 T.Ari Mod-E ワークトップがなくコンロキャビがあるプラン対応
								)
							) ;if (= "K" #kind)
						) ;foreach #zok$ &ss$
					) ;(= "A" &flg)
				);cond
			)
		);if (= nil #ret)

		; 第三条件：左右近いほう
		(if (= nil #ret)
			(progn
				(setq #ret (##Pt$XangYmax #pt$ 0.0))
			)
		)

	#ret
) ; GetBasePtByPlane

;<HOM>*************************************************************************
; <関数名>    : JudgeNaiugaiAng
; <処理概要>  : 角度付き内外判定
; <戻り値>    : T：内   nil：外
; <作成>      : 00/03/02
; <備考>      : なし
;*************************************************************************>MOH<
(defun JudgeNaiugaiAng (
	&pt$        ; 領域座標リスト
	&ang        ; 角度
	&pt         ; 判定座標
	/
	#ang #pt #pt$ #minmax #ryo$
	)
	;領域獲得
	(setq #ang (Angle0to360 (- 0.0 &ang)))
	(mapcar
	 '(lambda ( #pt )
			(setq #pt$ (cons (pt1jihenkan #pt #ang) #pt$))
		)
		&pt$
	)
	;領域座標リスト獲得
	(setq #minmax (GetPtMinMax #pt$))
	(setq #ryo$
		(list
			(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
			(list (car (car  #minmax)) (cadr (car  #minmax)) 0.0)
			(list (car (cadr #minmax)) (cadr (car  #minmax)) 0.0)
			(list (car (cadr #minmax)) (cadr (cadr #minmax)) 0.0)
			(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
		)
	)

	(JudgeNaigai (pt1jihenkan &pt #ang) #ryo$)
)

;<HOM>*************************************************************************
; <関数名>    : GetBasePtDown
; <処理概要>  : I型の下の基点を獲得
; <戻り値>    : 基点
; <作成>      : 00/03/03
; <備考>      : なし
;*************************************************************************>MOH<
(defun GetBasePtDown (
	&ss         ; キッチン選択エンティティ
	/
	#en$ #en #ed$ #ret
	)
	(setq #en$ (Ss2En$ &ss))
	(mapcar
	 '(lambda ( #en )
			(setq #ed$ (CfGetXData #en "G_SKDM"))
			(if
				(and
					(= "W" (nth 1 #ed$))
					(= 2   (nth 3 #ed$))
				)
				(setq #ret (cdrassoc 10 (entget #en)))
			)
		)
		#en$
	)

	#ret
) ; GetBasePtDown

;|
;<HOM>*************************************************************************
; <関数名>    : DrawSideDimPl
; <処理概要>  : 横の寸法線作図
; <戻り値>    : なし
; <作成>      : 00/03/02
; <備考>      : なし
;*************************************************************************>MOH<
(defun DrawSideDimPl (
	&model$     ; 分けたモデルリスト
	/
	#ang$ #ang #ss$ #zok$ #ss #ret$ #pt$ #pp #pt$$ #ra #ran #noang$
	#ang$$ #ang_n$$ #dim$ #dim$$ #dd
	#ssall #bpt #enSym$ #taimen$
	)

	(setq #ssall (ssget "X" '((-3 ("G_SKDM")))))

	(mapcar
	 '(lambda ( #ang$ )
			(setq #ang    (car   #ang$))
			(setq #ss$    (caddr #ang$))

			(setq #bpt (cdrassoc 10 (entget (ssname #ssall 0))))
			(RotateSymDin #bpt #ssall #ang "F" nil)

			(setq #enSym$ nil)
			(foreach #zok$ #ss$
				(foreach #en (Ss2En$ (cadr #zok$))
					(if (/= nil (CFGetXData #en "G_LSYM"))
						(if (equal #ang (nth 2 (CFGetXData #en "G_LSYM")) 0.01)
							(setq #enSym$ (cons #en #enSym$))
						)
					)
				)
			)
			(setq #taimen$ (SCFGetTaimenFlatPlanInfo #enSym$))
			(RotateSymDin #bpt #ssall #ang "B" (entlast))

			(mapcar
			 '(lambda ( #zok$ )
					(if (and (/= #taimen$ nil) (= (car #zok$) "D"))
						(princ)
						(progn
							(setq #ss (cadr #zok$))
							;座標獲得
							(if (= "K" (car #zok$))
								(setq #ret$ (SCF_Sid_GetSym_Kit #ss))  ; キッチン
								(setq #ret$ (SCF_Sid_GetSym_Din #ss))  ; ダイニング
							)
							(setq #pt$ (car #ret$))

							;座標リスト
							(mapcar
							 '(lambda ( #pp )
									(setq #pt$$ (cons #pp #pt$$))
								)
								#pt$
							)
							;角度
							(mapcar
							 '(lambda ( #ra )
									(setq #ran (Angle0to360 (car #ra)))
									(setq #noang (list (angtos #ran) (rtos (cadr #ra) 2 2)))
									(if (not (member #noang #noang$))
										(setq #noang$ (cons #noang #noang$))
									)
								)
								(cadr #ret$)
							)
						)
					)
				)
				#ss$
			)
		)
		&model$
	);_mapcar

	;角度でまとめる
	(setq #ang$$ (CollectAngle #pt$$))

	;方向でまとめる
	(setq #ang$$ (DivAngPt #ang$$))

	;出力してはいけない角度を省く
	(mapcar
	 '(lambda ( #ang$ )
			(setq #noang (list (angtos (car #ang$)) (rtos (cadr #ang$) 2 2)))
			(if (not (member #noang #noang$))
				(progn
					(setq #ang_n$$ (cons #ang$ #ang_n$$))
				)
			)
		)
		#ang$$
	)
	;優先順位決定！
	(mapcar
	 '(lambda ( #pt$ )
			(setq #dim$ (JudgePriority (car #pt$) (caddr #pt$)))
			(setq #dim$$ (cons #dim$ #dim$$))
		)
		#ang_n$$
	)
	;寸法作図
	(mapcar
	 '(lambda ( #dd )
			(SCFDrawDimAlig (car #dd) (cadr #dd))
		)
		#dim$$
	)

	(princ)
) ; DrawSideDimPl
|;
;<HOM>*************************************************************************
; <関数名>    : DrawSideDimPl
; <処理概要>  : 横の寸法線作図
; <戻り値>    : なし
; <作成>      : 00/03/02
; <備考>      : なし
;*************************************************************************>MOH<
(defun DrawSideDimPl (
	&model$     ; 分けたモデルリスト
	/
	#ang$ #ang #ss$ #zok$ #ss #ret$ #pt$ #pp #pt$$ #ra #ran #noang$
	#ang$$ #ang_n$$ #dim$ #dim$$ #dd
	#dd1 #dd2 #cnt
	#pt1$
	#pt2$
	#NOANG
	#lst$
	#minX #minY
	#x #y
	#ang
	#orgDimAng
	#sameAng
	#dimAng
	#ssAll$
	#pt
	#areaIn
	#areaPt$
	#en

	#bpt
	#ssall
	#enSym$
	#taimen$
#MAXX #MAXY ;2018/11/05 YM ADD
	)

	(setq #ssall (ssget "X" '((-3 ("G_SKDM")))))

	(foreach #ang$ &model$
		(setq #ang (car   #ang$))
		(setq #ss$ (caddr #ang$))

		(setq #bpt (cdrassoc 10 (entget (ssname #ssall 0))))
		(RotateSymDin #bpt #ssall #ang "F" nil)

		(setq #enSym$ nil)
		(foreach #zok$ #ss$
			(foreach #en (Ss2En$ (cadr #zok$))
				(if (/= nil (CFGetXData #en "G_LSYM"))
					(if (equal #ang (nth 2 (CFGetXData #en "G_LSYM")) 0.01)
						(setq #enSym$ (cons #en #enSym$))
					)
				)
			)
		)
		(setq #taimen$ (SCFGetTaimenFlatPlanInfo #enSym$))
		(RotateSymDin #bpt #ssall #ang "B" (entlast))

		(foreach #zok$ #ss$
			(if (and (/= #taimen$ nil) (= (car #zok$) "D"))
				(princ)
				(progn
					(setq #ss (cadr #zok$))
					(setq #ssAll$ (cons #ss #ssAll$))
					;座標獲得
					(if (= "K" (car #zok$))
						(setq #ret$ (SCF_Sid_GetSym_Kit #ss))  ; キッチン
						(setq #ret$ (SCF_Sid_GetSym_Din #ss))  ; ダイニング
					)
					(setq #pt$ (car #ret$))
					;座標リスト
					(foreach #pp #pt$
						(setq #pt$$ (cons #pp #pt$$))
					)
					;角度
					(foreach #ra (cadr #ret$)
						(setq #ran (Angle0to360 (car #ra)))
						(setq #noang (list (angtos #ran) (rtos (cadr #ra) 2 2)))
						(if (not (member #noang #noang$))
							(setq #noang$ (cons #noang #noang$))
						)
					)
				)
			)
		)
	)
	;角度でまとめる
	(setq #ang$$ (CollectAngle #pt$$))
	;方向でまとめる
	(setq #ang$$ (DivAngPt #ang$$))
	;出力してはいけない角度を省く
	(foreach #ang$ #ang$$

		(setq #ang (angtos (car #ang$)))
		(setq #noang (list #ang (rtos (cadr #ang$) 2 2)))
		;---------------------------------------------------------------
		;最も端の部材のみを対象として寸法出力情報を取得する
		;（寸法の重なりを除去するため）
		;---------------------------------------------------------------
		(if (not (member #noang #noang$))
			(progn
				; 寸法基点が同じで寸法角度が違うものがないかを調べる
				(setq #orgDimAng nil)
				(setq #sameAng T)
				(foreach #lst$ (caddr #ang$)
					(setq #dimAng (angtos (angle (car (car (cadr #lst$))) (cadr (car (cadr #lst$))))))
					(if (= #orgDimAng nil)
						(setq #orgDimAng #dimAng)
						(progn
							(if (/= #dimAng #orgDimAng)
								(setq #sameAng nil)
							)
						)
					)
				)
				; 寸法角度が同じであれば、一番外側の寸法位置を求める
				(if #sameAng
					(progn
						;各平面での一番端となる寸法対象の情報を検出する
						(setq #maxX 0)
						(setq #maxY 0)
						(setq #minX 100000)
						(setq #minY 100000)

						(foreach #lst$ (caddr #ang$)
							(setq #x (car (car (car (cadr #lst$)))))
							(setq #y (cadr (car (car (cadr #lst$)))))
							(cond
								;Xの最大のものが対象
								((= #ang "0")
									(if (> #x #maxX)
										(progn
											(setq #ang$ (list (car #ang$) (cadr #ang$) (list #lst$)))
											(setq #maxX #x)
										)
									)
								)
								;Yの最大のものが対象
								((= #ang "90")
									(if (> #y #maxY)
										(progn
											(setq #ang$ (list (car #ang$) (cadr #ang$) (list #lst$)))
											(setq #maxY #y)
										)
									)
								)
								;Xの最小のものが対象
								((= #ang "180")
									(if (< #x #minX)
										(progn
											(setq #ang$ (list (car #ang$) (cadr #ang$) (list #lst$)))
											(setq #minX #x)
										)
									)
								)
								;Yの最小のものが対象
								((= #ang "270")
									(if (< #y #minY)
										(progn
											(setq #ang$ (list (car #ang$) (cadr #ang$) (list #lst$)))
											(setq #minY #y)
										)
									)
								)
							)
						)
					)
				)
				(setq #ang_n$$ (cons #ang$ #ang_n$$))
			)
		)
		;---------------------------------------------------------------
	)
	(setq #ss (ssget "X" '((-3 ("G_SYM")))))

	(foreach #pt1$ #ang_n$$

		(setq #ang (car #pt1$))

		(foreach #pt2$ (caddr #pt1$)
			(setq #dim$ (cadr #pt2$))
			(setq #pt$ (car #dim$))
			;----------------------------------------------------------------
			; 全体からキャビネット領域内に存在する点がないかチェックする
			;   （コーナートールキャビ内に寸法が入るケースの寸法除外対応）
			;----------------------------------------------------------------
			(setq #areaIn nil)
			(foreach #en (Ss2En$ #ss)
				(if (and (CFGetXData #en "G_SYM") (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1)))
					(progn
						(setq #areaPt$ (GetSymAreaPt #en))
						(setq #areaPt$ (append #areaPt$ (list (car #areaPt$))))
						(foreach #pt #pt$
							; 少し外側にずらさないと寸法の基準となるキャビで引っ掛かる。
							(if (JudgeNaigai (polar #pt #ang 10) #areaPt$)
								(setq #areaIn T)
							)
						)
					)
				)
			)
			;----------------------------------------------------------------
			;キャビネット領域外であれば作図する
			(if (= #areaIn nil)
				(progn
					;キッチンパネル付きの寸法の場合は奥から順になるよう座標を合わせる
					(if (>= (length #pt$) 3)
						(setq #pt$ (list (last #pt$) (car #pt$) (cadr #pt$)))
					)
					;各部材の奥行き寸法を作図する
					(setq #cnt 0)
					(repeat (1- (length #pt$))
						(setq #dd1 (nth #cnt #pt$))
						(setq #dd2 (nth (1+ #cnt) #pt$))
						(SCFDrawDimAlig (list #dd1 #dd2) (polar #dd1 #ang (GetDimHeight 0)))
						(setq #cnt (1+ #cnt))
					)
					;キッチンパネルを考慮した全体寸法の作図
					(if (>= (length #pt$) 3)
						(progn
							(setq #dd1 (nth 0 #pt$))
							(setq #dd2 (last  #pt$))
							(SCFDrawDimAlig (list #dd1 #dd2) (polar #dd1 #ang (GetDimHeight 1)))
						)
					)
				)
			)
		)
	)
	(princ)
) ; DrawSideDimPl


;<HOM>*************************************************************************
; <関数名>    : SCF_Sid_GetSym_Kit
; <処理概要>  : 横の寸法線の座標と角度獲得  キッチン
; <戻り値>    : 座標と角度獲得
; <作成>      : 00/03/03 ひなまつりです
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCF_Sid_GetSym_Kit (
	&ss         ; 選択エンティティ
	/
	#en$ #en #10 #ed$ #pt0 #flg #pt1 #pt2 #ang #pt$ #rpt$ #noang$ #pt3
	)
	(setq #en$ (Ss2En$ &ss))
	(mapcar
	 '(lambda ( #en )
			(setq #10  (cdrassoc 10 (entget #en)))
			(setq #ed$ (CfGetXData #en "G_SKDM"))
			(if (= "W" (nth 1 #ed$))
				(progn
					(cond
						((= 0 (nth 3 #ed$))
							(setq #pt0 #10)
							(if (= "C" (nth 5 #ed$))
								(setq #flg T)
							)
						)
						((or (= 1 (nth 3 #ed$))(= 3 (nth 3 #ed$)))
							(setq #pt1 #10)
						)
						((or (= 2 (nth 3 #ed$))(= 4 (nth 3 #ed$)))
							(setq #pt2 #10)
						)
					)
				)
			)
		)
		#en$
	)
	(if (and (/= nil #pt0) (/= nil #pt1) (/= nil #pt2))
		(progn
			(setq #ang  (angle #pt0 #pt1))
			; 2000/07/14 HT U型対応のため横の寸法位置を、ずらせて重なりをなくす
			;(setq #pt$  (list (list #pt1 #pt2) (polar #pt1 #ang (GetDimHeight 1))))
			(setq #pt$  (list (list #pt1 #pt2) (polar #pt1 #ang (GetDimHeight 0))))
			(setq #rpt$ (cons (list (Angle0to360 #ang) "K" #pt$) #rpt$))
			(if (/= nil #flg)
				(progn
					(setq #noang$ (cons (list (angle #pt1 #pt0) (GetBByAngPt #pt0 #ang)) #noang$))
					(setq #pt3 (polar #pt0 (angle #pt1 #pt2) (distance #pt1 #pt2)))
					(setq #pt$  (list (list #pt0 #pt3) (polar #pt0 (+ PI #ang) (GetDimHeight 1))))
					(setq #rpt$ (cons (list (Angle0to360 (+ PI #ang)) "K" #pt$) #rpt$))
				)
			)
			(setq #noang$ (cons (list (angle #pt2 #pt1) (GetBByAngPt #pt1 #ang)) #noang$))
		)
	)

	(list #rpt$ #noang$)
) ; SCF_Sid_GetSym_Kit

;<HOM>*************************************************************************
; <関数名>    : SCF_Sid_GetSym_Din
; <処理概要>  : 横の寸法線の座標と角度獲得 ダイニング
; <戻り値>    : 座標と角度獲得
; <作成>      : 00/03/03
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCF_Sid_GetSym_Din (
	&ss         ; 選択エンティティ
	/
	#en$ #en #code$ #ang #pt$ #dw #enpt$ #cnpt$ #spt$ #sptcn$ #spt #ept #pp$ #sang
	#ept$ #eang #pt1$ #pt2$ #noang$
	#cntEn$ #en2$  ;2004/04/12 SK 対面プラン対応
	#baseall$ #tmppt$ #offset #tmppt
	)
	(setq #en$ (Ss2En$ &ss))

	; 2004/04/12 SK ADD-S 対面プラン対応
	; ダイニングカウンターは、キャビネットより優先寸法となるため、
	; 最左、最右になる事を考慮してこの時点でリストの最初にしておく
	; 寸法の優先順位は
	;   サイドパネル ＞　ダイニングカウンター ＞ キャビネット
	(foreach #en #en$
		(setq #code$ (CFGetSymSKKCode #en nil))
		(cond
			((= CG_SKK_ONE_CNT (nth 0 #code$))
				(setq #cntEn$ (cons #en #cntEn$))
			)
			(T
				(setq #en2$ (cons #en #en2$))
			)
		)
	)
	(setq #en$ (append #cntEn$ #en2$))
	; 2004/04/12 SK ADD-E 対面プラン対応

	(mapcar
	 '(lambda ( #en )
			; 2000/07/25 HT + 冷蔵庫追加
			;ベースキャビネットのみ獲得
			(setq #code$ (CFGetSymSKKCode #en nil))
			(if
				(or
					(and
						(= CG_SKK_ONE_CAB (nth 0 #code$))
						(= CG_SKK_TWO_BAS (nth 1 #code$))
					)
					(and ;冷蔵庫&ペニンシュラユニット
						(equal CG_SKK_ONE_ETC (nth 0 #code$))
						(equal CG_SKK_TWO_BAS (nth 1 #code$))
						(equal CG_SKK_THR_NRM (nth 2 #code$))
					)
					; 02/03/26 HN S-ADD カウンター天板とサイドパネルも対象
					(= CG_SKK_ONE_CNT (nth 0 #code$))
					(and
						(= CG_SKK_ONE_SID (nth 0 #code$))
						(= CG_SKK_TWO_BAS (nth 1 #code$))
					)
					; 02/03/26 HN E-ADD カウンター天板とサイドパネルも対象
				)
				(progn
					;角度算出
					(if (= nil #ang)
						(setq #ang (nth 2 (CfGetXData #en "G_LSYM")))
					)
					;座標算出
					(setq #pt$ (GetSym4Pt #en))

					(setq #dw
						(polar
							(nth 1 #pt$)
							(angle    (nth 0 #pt$)(nth 2 #pt$))
							(distance (nth 0 #pt$)(nth 2 #pt$))
						)
					)
; 08/08/13
; エンドパネルは出力寸法から除外するため、寸法の書き出し位置を作るための変数を別に設定
					(setq #baseall$ (cons (nth 0 #pt$) #baseall$))
					(setq #baseall$ (cons (nth 1 #pt$) #baseall$))
					(if (/= CG_SKK_ONE_SID (nth 0 #code$))
						(progn
							; 08/09/17 カウンター寸法を優先させるために別の変数に確保
							(if (= CG_SKK_ONE_CNT (nth 0 #code$))
								(progn
									(setq #cnpt$ (cons (list (nth 0 #pt$) (nth 2 #pt$)) #cnpt$))
									(setq #cnpt$ (cons (list (nth 1 #pt$) #dw         ) #cnpt$))
								)
								(progn
									(setq #enpt$ (cons (list (nth 0 #pt$) (nth 2 #pt$)) #enpt$))
									(setq #enpt$ (cons (list (nth 1 #pt$) #dw         ) #enpt$))
								)
							)
						)
					)
				)
			)
		)
		#en$
	)
	;ソート
	(if (or #enpt$ #cnpt$)
		(progn
			(setq #spt$ (2dto3d (3dto2d (PtSort (mapcar 'car (append #enpt$ #cnpt$)) #ang T))))
			(setq #spt  (car  #spt$))
			(setq #ept  (last #spt$))

			;最左と最右を獲得
			(mapcar
			 '(lambda ( #pp$ )
					(setq #pp$ (2dto3d (3dto2d #pp$)))
					(if (equal 0.0 (distance (car #pp$) #spt) 0.001)
						(setq #spt$ #pp$)
						(setq #sang (Angle0to360 (- (angle (car #pp$) (cadr #pp$)) (* PI 0.5))))
					)
					(if (equal 0.0 (distance (car #pp$) #ept) 0.001)
						(setq #ept$ #pp$)
						(setq #eang (Angle0to360 (+ (angle (car #pp$) (cadr #pp$)) (* PI 0.5))))
					)
				)
				; カウンターを後から評価するので、カウンターが優先される
				(append #enpt$ #cnpt$)
			)
			(setq #baseall$ (PtSort #baseall$ #ang T))
		)
	)
	;３点目獲得
	; 01/02/05 HN S-MOD 引数のnil判定を追加
	(if (or (= nil #sang) (= nil #eang) (= nil (car #spt$)) (= nil (car #ept$)))
		nil
		(progn
; 08/08/13
; エンドパネルが端にあれば、その分寸法書き出し位置をずらしてやる
			(setq #tmppt$ #spt$)
			(setq #offset (distance (car (3dto2d (list (car #baseall$)))) (car (3dto2d (list (car #tmppt$))))))
			(setq #spt$ nil)
			(foreach #tmppt #tmppt$
				(setq #tmppt (polar #tmppt #sang #offset))
				(setq #spt$ (append #spt$ (list #tmppt)))
			)
			(setq #tmppt$ #ept$)
			(setq #offset (distance (car (3dto2d (list (last #baseall$)))) (car (3dto2d (list (car #tmppt$))))))
			(setq #ept$ nil)
			(foreach #tmppt #tmppt$
				(setq #tmppt (polar #tmppt #eang #offset))
				(setq #ept$ (append #ept$ (list #tmppt)))
			)
			(setq #pt1$ (list #sang "D" (list #spt$ (polar (car #spt$) #sang (GetDimHeight 1)))))
			(setq #pt2$ (list #eang "D" (list #ept$ (polar (car #ept$) #eang (GetDimHeight 1)))))
			(setq #noang$ (list (list (angle (cadr #spt$) (car #spt$)) (GetBByAngPt (car #spt$) #sang))))
			(list (list #pt1$ #pt2$) #noang$)
		)
	)
	; 01/02/05 HN E-MOD 引数のnil判定を追加
) ; SCF_Sid_GetSym_Din


;<HOM>*************************************************************************
; <関数名>    : JudgePriority
; <処理概要>  : 左右の寸法の出力する優先順位決定
; <戻り値>    : 寸法リスト
; <作成>      : 00/03/03
; <備考>      : なし
;*************************************************************************>MOH<
(defun JudgePriority (
	&ang        ; 角度
	&pt$        ; 座標リスト
	/
	#kpt$ #pt$ #pt_n$ #p$ #tpt #tv #vec$ #ret
	)
	(if (assoc "K" &pt$)
		(progn
			(setq #kpt$ (cadr (assoc "K" &pt$)))
			(setq #pt$ (mapcar 'cadr &pt$))
			(setq #pt_n$
				(mapcar
				 '(lambda ( #p$ )
						(list (cadr #p$) #p$)
					)
					#pt$
				)
			)
			(setq #tpt (last (PtSort (mapcar 'car #pt_n$) &ang T)))
			(mapcar
			 '(lambda ( #p$ )
					(if (equal 0.0 (distance #tpt (car #p$)) 0.001)
						(progn
							(setq #tv (cadr (cadr #p$)))
						)
					)
				)
				#pt_n$
			)
			(setq #vec$ (mapcar '- #tv (cadr #kpt$)))
			(setq #ret
				(list
					(list
						(mapcar '+ (car  (car #kpt$)) #vec$)
						(mapcar '+ (cadr (car #kpt$)) #vec$)
					)
					(mapcar '+ (cadr #kpt$) #vec$)
				)
			)
		)
		(progn
			(setq #pt$ (mapcar 'cadr &pt$))
			(setq #pt_n$
				(mapcar
				 '(lambda ( #p$ )
						(list (cadr #p$) #p$)
					)
					#pt$
				)
			)
			(setq #tpt (last (PtSort (mapcar 'car #pt_n$) &ang T)))
			(mapcar
			 '(lambda ( #p$ )
					(if (equal 0.0 (distance #tpt (car #p$)) 0.001)
						(progn
							(setq #ret (cadr #p$))
						)
					)
				)
				#pt_n$
			)
		)
	)

	#ret
)
;<HOM>*************************************************************************
; <関数名>    : DivAngPt
; <処理概要>  : 角度と座標リストから、一直線上にあるものをまとめる
; <戻り値>    :
; <作成>      : 00/03/14
; <備考>      : なし
;*************************************************************************>MOH<
(defun DivAngPt (
	&pt$
	/
	#pt$ #ang #elm$ #pt #b #new$ #new$$
	)
	(mapcar
	 '(lambda ( #pt$ )
			(setq #ang (car #pt$))
			(mapcar
			 '(lambda ( #elm$ )
					(setq #pt (car (car (cadr #elm$))))
					(setq #b (GetBByAngPt #pt #ang))
					(setq #new$ (cons (append (list #b) #elm$) #new$))
				)
				(cadr #pt$)
			)
			(setq #new$ (CollectAngle #new$))
			(mapcar
			 '(lambda ( #elm$ )
					(setq #new$$ (cons (cons #ang #elm$) #new$$))
				)
				#new$
			)
			(setq #new$ nil)
		)
		&pt$
	)

	#new$$
)

;<HOM>*************************************************************************
; <関数名>    : GetBByAngPt
; <処理概要>  : 角度と座標から、X=0の時のYの値を獲得
; <戻り値>    : B
; <作成>      : 00/03/14
; <備考>      : なし
;*************************************************************************>MOH<
(defun GetBByAngPt (
	&pt
	&ang
	/
	#pt2 #a #ret #ang
	)
	(setq #ang (Angle0to360 &ang))
	(cond
		((or (equal 0.0 #ang 0.01)(equal PI #ang 0.01))
			;y
			(setq #ret (cadr &pt))
		)
		((or (equal (* 0.5 PI) #ang 0.01) (equal (* 1.5 PI) #ang 0.01))
			;x
			(setq #ret (car &pt))
		)
		(T
			;b
			(setq #pt2 (polar (list (car &pt) (cadr &pt) 0.0) #ang 10))
			(setq #a   (/ (- (cadr #pt2) (cadr &pt)) (- (car #pt2) (car &pt))))
			(setq #ret (- (cadr &pt) (* #a (car &pt))))
		)
	)
	#ret
)
;<HOM>*************************************************************************
; <関数名>    : DivAngPtH
; <処理概要>  : 角度と座標リストから、一直線上にあるものをまとめる
; <戻り値>    : ((角度 B (("K" #ss))))
; <作成>      : 00/03/14
; <備考>      : なし
;*************************************************************************>MOH<
(defun DivAngPtH (
	&pt$    ; ((角度 (("KorD" #ss))) ( )・・・)
	/
	#pt$ #ang #elm$ #en$ #en #pt #code$ #b #new$ #new$$
	)
	(foreach #pt$  &pt$
		(setq #ang (car #pt$))

		(foreach  #elm$	(cadr #pt$)
			(setq #en$ (Ss2En$ (cadr #elm$)))

			(foreach #en #en$
				(if (/= "W" (nth 1 (CfGetXData #en "G_SKDM")))
					(if (= nil #pt)
						(progn
							;ベースキャビネットのみ獲得
							(setq #code$ (CFGetSymSKKCode #en nil))

							(if
								(and
									(= CG_SKK_ONE_CAB (nth 0 #code$))
									(= CG_SKK_TWO_BAS (nth 1 #code$))
								)
								(setq #pt (cdrassoc 10 (entget #en)))
							)
						)
					)
				)
			)
			(setq #b (GetBByAngPt #pt #ang))
			(setq #new$ (cons (append (list #b) #elm$) #new$))
			(setq #pt nil)
		)

		(setq #new$ (CollectAngle #new$))
		(foreach #elm$ #new$
			(setq #new$$ (cons (cons #ang #elm$) #new$$))
		)
		(setq #new$ nil)
	)

	#new$$
)
;DivAngPtH

(defun CFcompact (
	&list$
	/
	#ret$
	#ii
	)

	(foreach #ii &list$
		(if #ii
			(setq #ret$ (cons	#ii #ret$))
		)
	)

	(reverse #ret$)
)



