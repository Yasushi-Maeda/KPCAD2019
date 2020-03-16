
;(setq CG_KCFDIV_ANG_EPS (* (/ (* 2.0 PI) 360.0) 2.0)) ; 01/08/08 TM ADD 角度誤差2度
(setq CG_KCFDIV_ANG_EPS 0.4) ; 01/08/08 TM ADD 角度誤差約2度

;<HOM>*************************************************************************
; <関数名>    : SetDummyArea
; <処理概要>  : ダミー領域作成
; <戻り値>    : なし
; <備考>      : 拡張データ
;                 モデルタイプ
;                 モデル番号
;                 シンボルハンドル
; <作成>      : 00/01/15
;*************************************************************************>MOH<
(defun SetDummyArea (
	/
	#clayer #ssSym #ssWt #ss$$ #no #ss$ #pt$ #ss #dpt$ #il #en$ #waku #i #en #cnt #p #waku$
	; 2000/07/06 HT YASHIAC  矢視領域判定変更
	#wtType
	#ssKutai ;00/12/19 SN ADD
	)
	;元あるモデル図形領域を削除する
	(DelDummyArea)
	;拡張データ登録
	(if (not (tblsearch "APPID" "G_SKDM")) (regapp "G_SKDM"))
	;画層
	(setq #clayer (getvar "CLAYER"))
	(if (= 0 (logand 1 (cdr (assoc 70 (tblsearch "LAYER" "0")))))
		(progn
			(setvar "CLAYER" "0")
		)
		(progn
			; 2000/06/22 HT 画層がフリーズされている時、メッセージ終了
			(CFAlertErr "0画層がフリーズされています。")
			(exit)
		)
	)

	;選択セット獲得
	(setq #ssSym (ssget "X" (list (list -3 (list "G_LSYM")))))
	(setq #ssWt  (ssget "X" (list (list -3 (list "G_WRKT")))))
	;00/12/19 SN ADD 躯体を省く
	(setq #ssKutai (ssget "X" (list (list -3 (list "G_KUTAI")))))
	(if #ssKutai (progn
		(setq #i 0)
		(repeat (sslength #ssKutai)
			(ssdel (ssname #ssKutai #i) #ssSym)
			(setq #i (1+ #i))
		)
		(setq #ssKutai nil);躯体選択ｾｯﾄをｸﾘｱ
	));End if-progn

	; 2000/07/06 HT YASHIAC  矢視領域判定変更 START
	; ワークトップ種類が U 型の時 フラグをたてる
	(setq CG_UTypeWT (SCF_IsUType #ssWt))
	; 2000/07/06 HT YASHIAC  矢視領域判定変更 END

	(if (and (/= nil #ssSym) (= 1 (sslength #ssSym)) (= nil #ssWt))
		(progn
			; キャビネット一つでワークトップがない
			(setq #ss$$ (list nil (list (list (GetDiningArea #ssSym) #ssSym))))
		)
		(progn    ; 通常
			; キャビネットが複数存在するか、ワークトップが存在する時
			;モデル毎に選択セットを分ける
			(setq #ss$$ (DivSymByModel #ssSym #ssWt))
		)
	)

; #ss$$のについて
;
; #ss$$ = ( (キッチン) (ダイニング) )
; (キッチン) = ((モデルK1) (モデルK2) ・・・)
; (ダイニング) = ((モデルD1) (モデルD2) ・・・)
;
; (モデルK1) = ((領域の座標始点～始点) モデルに属するシンボル基準点の選択セット
;               (領域のダミー座標) 形状タイプ"I" or "L")
;
;
; (モデルD1) = ((領域の座標始点～始点) モデルに属するシンボル基準点の選択セット)
;
;
	;拡張データ格納
	(setq #no 1)  ; モデル番号
	;キッチン
	(mapcar
	 '(lambda ( #ss$ )
			(setq #pt$  (nth 0 #ss$))  ; 領域の座標始点～始点
			(setq #ss   (nth 1 #ss$))  ; 選択エンティティ
			(setq #dpt$ (nth 2 #ss$))  ; ダミー座標リスト
			(setq #il   (nth 3 #ss$))  ; ワークトップ形状ILフラグ
			(setq #en$ nil)
			;ダミー領域作図
			(MakeLwPolyLine #pt$ 0 0.0)
			(setq #waku (entlast))

			;選択エンティティから図形名リストを獲得
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en  (ssname #ss #i))
				(setq #en$ (cons #en #en$))
				(setq #i    (1+ #i))
			)
			;拡張データ格納
			(CfSetXData #waku "G_SKDM" (append (list "K" (itoa #no)) #en$))
			;ワークトップダミー図形作成
			(if (/= nil (nth 0 #dpt$))
				(progn
					(entmake (list (cons 0 "POINT")(cons 10 (nth 0 #dpt$))))
					(if (= "L" #il)
						(CfSetXData (entlast) "G_SKDM" (list 1 "W" (itoa #no) 0 0.0 "C"))
						(CfSetXData (entlast) "G_SKDM" (list 1 "W" (itoa #no) 0 0.0 ""))
					)
				)
			)
			(setq #cnt 1)
			(mapcar
			 '(lambda ( #p )
					(if (/= nil #p)
						(progn
							(entmake (list (cons 0 "POINT")(cons 10 #p)))
							(CfSetXData (entlast) "G_SKDM" (list 1 "W" (itoa #no) #cnt 0.0 ""))
						)
					)
					(setq #cnt (1+ #cnt))
				)
				(cdr #dpt$) ; <===点列の順番に意味はあるか？規則性??? I型=p1,p2,p3  L型=p1,p2,p3,p6,p5,p2 ??? 01/07/23 YM
			)
			;領域図形獲得
			(setq #waku$ (cons #waku #waku$))
			;モデル番号カウントアップ
			(setq #no (1+ #no))
		)
		(car #ss$$)
	)
	;ダイニング
	(mapcar
	 '(lambda ( #ss$ )
			(setq #pt$ (car  #ss$))  ; 領域図形名
			(setq #ss  (cadr #ss$))  ; 選択エンティティ
			(setq #en$ nil)
			;ダミー領域作図
			(MakeLwPolyLine #pt$ 0 0.0)
			(setq #waku (entlast))
			;選択エンティティから図形名リストを獲得
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #en$ (cons #en #en$))
				(setq #i (1+ #i))
			)
			;拡張データ格納
			(CfSetXData #waku "G_SKDM" (append (list "D" (itoa #no)) #en$))
			;領域図形獲得
			(setq #waku$ (cons #waku #waku$))
			;モデル番号カウントアップ
			(setq #no (1+ #no))
		)
		(cadr #ss$$)
	)
	;サイドパネル編集
	(AddSideToDummyArea #waku$)
	; レンジフード
	(AddRangeHoodToDummyArea #waku$)
	(setvar "CLAYER" #clayer)
	(princ)
) ; SetDummyArea

;<HOM>*************************************************************************
; <関数名>    : SCF_IsUType
; <処理概要>  : ワークトップの形状タイプに U型 があるかどうか判定する
; <戻り値>    : U型含む T    U型含まない nil
; <備考>      :
;*************************************************************************>MOH<
(defun SCF_IsUType (
	&ssWT
	/
	#bUType   ; 戻り値
	#i        ; カウンタ
	#wtType   ; 形状タイプ
	)
	(if &ssWt
		(progn
			(setq #i 0)
			(setq #bUType nil)    ;コの字ワークトップフラグ
			(while (and &ssWt (< #i (sslength &ssWt)))
				(setq #wtType (nth 3 (CFGetXData (ssname &ssWt #i) "G_WRKT")))
				(if (= 2 #wtType)
					(progn
						(setq #bUType T);コの字ワークトップフラグ
						;(setq #ssWt nil)
					)
				)
				(setq #i (1+ #i))
			)
		)
	)
#bUType
)

;;;<HOM>*************************************************************************
;;; <関数名>    : KPGetLDANSA_BUNRIWT
;;; <処理概要>  : L型段差両側接続で分離したI形状WTがあれば返す
;;; <戻り値>    : WT図形名 or nil
;;; <備考>      :
;;; <作成>      : 01/07/23 YM
;;;*************************************************************************>MOH<
(defun KPGetLDANSA_BUNRIWT (
	&ssWT ; ワークトップの選択セット
	/
	#I #RET #WT #XDWT$
	)
	(setq #ret nil)
	(if (and &ssWT (< 0 (sslength &ssWT)))
		(progn
			(setq #i 0)
			(repeat (sslength &ssWT)
				(setq #WT (ssname &ssWT #i))
				(setq #xdWT$ (CfGetXData #WT "G_WRKT"))

				; 02/01/07 YM ADD-S ｽﾃﾝﾚｽL形状WTは除く処理を追加
				(setq #tei   (nth 38 #xdWT$))      ; WT底面図形ﾊﾝﾄﾞﾙ
				(setq #BaseP (nth 32 #xdWT$))      ; WT左上点
				(setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
				; 02/01/07 YM ADD-E ｽﾃﾝﾚｽL形状WTは除く処理を追加

				(if (and (= 1 (nth 3 #xdWT$))(= "D" (nth 4 #xdWT$))   ; L型段差である
								 (= "" (nth 47 #xdWT$))(= "" (nth 48 #xdWT$)) ; 47=WT左,48=WT右 左右隣接WTはない
								 (/= (length #pt$) 6)) ; ｽﾃﾝﾚｽ1枚もの(L形状)WTでない 02/01/07 YM ADD
					(setq #ret #WT)
			 	);_if
				(setq #i (1+ #i))
			)
		)
	);_if
	#ret
);KPGetLDANSA_BUNRIWT

;;;<HOM>*************************************************************************
;;; <関数名>    : DivSymByModel
;;; <処理概要>  : キッチン又はダイニング毎にシンボルを分ける
;;; <戻り値>    : 領域座標リストとシンボルリスト（キッチン ダイニング）
;;; <備考>      :
;;; <作成>      : 1999/11/10
;;; <改訂>      : 2001/02/07 中村博伸
;;; <改訂>      : 01/07/23 YM lambda-->foreach
;;;*************************************************************************>MOH<
(defun DivSymByModel (
	&ss         ; シンボルの選択セット
	&ssw        ; ワークトップの選択セット
	/
	#sst #ssw #en #eed$ #pt$ #ryoiki #dpt$ #il #again$ #sss #sss$
	#ssb #i #ss$ #ss #rect$ #10$ #flg #10 #ssw$
	#enDEL$     ; カットされているワークトップ全体
	#j          ; カウンタ
	#skk$       ; 性格CODE
	#en$        ; 図形名リスト
	#enCnt$     ; 図形名リスト
	)
	(if (/= nil &ss)
		(progn
			(setq #sst &ss)
			;キッチンのシンボルを獲得
			(setq #ssw &ssw)
			(if (/= nil #ssw)
				(progn

					; 01/07/23 YM 実験的導入 START
					; L型段差両側接続時のI形状分離WTを選択ｾｯﾄから削除してみる
					; +------------------------+
					; |                        |
					; |                        |
					; |       +----------------+
					; |       |
					; +-------+
					; |       |
					; |段差部 |
					; |       |
					; +-------+
					; |       |
					; |分離WT |<---このWT
					; |       |
					; +-------+

					(setq #eDAN_WT (KPGetLDANSA_BUNRIWT #ssw))
					(if #eDAN_WT (ssdel #eDAN_WT #ssw))
					; 01/07/23 YM 実験的導入 END

					(setq #i 0)
					; 2000/07/12 HT DEL U型 ワークトップカット対応
					;(repeat (sslength #ssw)
					(while (/= 0 (sslength #ssw))
						(setq #en (ssname #ssw 0))
						(setq #eed$ (CfGetXData #en "G_WRKT"))

						; 2000/07/11 HT カットされていたら右端以外を選択セットから除外する
						(if (or (/= "" (nth 47 #eed$)) (/= "" (nth 48 #eed$))) ; 47=WT左,48=WT右
							(progn
								; 右端のワークトップ図形に置き換える
								(setq #en (car (PKGetMostRightWT #en))) ; 一番右のWT
								; 右端を除くワークトップ図形を選択セットから削除する
								(setq #enDEL$ (PKGetWT$FromMRWT (nth 47 (CfGetXData #en "G_WRKT")))) ; 一番右WT==>右から順に関連WTﾘｽﾄを返す
								(setq #j 0)
								(repeat (length #enDEL$)
									(ssdel (nth #j #enDEL$) #ssw)
									(setq #j (1+ #j))
								)
							)
						);_if

						; ワークトップを選択セットから削除する
						(ssdel #en #ssw)

						;ワークトップの領域を獲得
						(setq #pt$$ (GetWorkTopArea #en))

						; 2000/07/12 HT ADD U型 ワークトップカット対応
;;;01/07/23YM@            (mapcar '(lambda (#pt$)
					 	(foreach #pt$ #pt$$ ; 01/07/23 YM MOD mapcar '(lambda==>foreach
							;領域図形作図
							(setq #ryoiki (nth 0 #pt$))
							(setq #dpt$   (nth 1 #pt$))

							(setq #il     (nth 2 #pt$))
							(setq #pt$ (reverse (car #pt$)))

							; 2000/07/06 HT YASHIAC  矢視領域判定変更 のため CG_UTypeWTで場合分け
							(if (= CG_UTypeWT nil)
								(progn
									;領域内のシンボル図形を獲得する
									(setq #again$ (GetAreaAgain #ryoiki #dpt$ #sst (nth 4 #eed$)))
									(if (/= nil #again$)
										(progn
											(setq #sss    (En$2Ss (nth 0 #again$)))
											(setq #ryoiki (nth 1 #again$))
											(setq #dpt$   (nth 2 #again$))
											;選択セットから除外
											(mapcar
											 '(lambda ( #en )
													(ssdel #en #sst)
												)
												(nth 0 #again$)
											)
										)
										(progn
											; L型のダイニングは存在しないものとする
											(if (= #il "L")
												(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;													(CFAlertMsg " 収納部にL型は扱えません。")
													(princ "\n収納部にL型は扱えません。")
													(princ "\n")
;-- 2012/02/21 A.Satoh Mod - E
;;;		                      (exit) ; 01/07/23 YM DEL @@@ テスト @@@
												)
											)
										)
									)
								)
								; else
								(progn
									; 2000/07/06 HT YASHIAC  矢視領域判定変更
									; U 型 対応
									(setq #again$ (GetAreaAgain #ryoiki #dpt$ #sst (nth 4 #eed$)))
									(setq #ryoiki (nth 1 #again$))  ; 2000/09/20 ADD
									(setq #dpt$   (nth 2 #again$))  ; 2000/09/20 ADD
									(setq #sss    (En$2Ss (nth 0 #again$)))
								)
							);_if

							;選択セットリストに格納
							(if (and (/= nil #sss) (/= 0 (sslength #sss)))
								(setq #sss$ (cons (list #ryoiki #sss #dpt$ #il) #sss$))
							);_if
;;;01/07/23YM@						 	) ; lambda
;;;01/07/23YM@              #pt$$
						) ; mapcar  2000/07/12 HT ADD U型 ワークトップカット対応

						(setq #i (1+ #i))
					) ; repeat
				)
			);_if

			; 2000/07/06 HT YASHIAC  矢視領域判定変更 START
			(if CG_UTypeWT
				(progn
					(foreach #sss #sss$
						(setq #sss (cadr #sss))
						(setq #i 0)
						(repeat (sslength #sss)
							(setq #en (ssname #sss #i))
							(if (ssmemb #en #sst)
								(ssdel #en #sst)
							)
							(setq #i (1+ #i))
						)
					)
					;(setq #sst nil)
				)
			)
			; 2000/07/06 HT YASHIAC  矢視領域判定変更 END

			;ダイニングの選択セット
			(if (and (/= nil #sst) (/= 0 (sslength #sst)))
				(progn
					; 2000/07/25 HT + 冷蔵庫追加
					;ベースキャビネットのみ獲得
					(setq #enCnt$ '() #en$ '())
					(setq #ssb (ssadd))
					(setq #i 0)
					(repeat (sslength #sst)
						(setq #en (ssname #sst #i))
						(setq #skk$ (CfGetSymSKKCode #en nil))
						(if
							(or
								(and
									(equal CG_SKK_ONE_CAB (car #skk$))
									(equal CG_SKK_TWO_BAS (cadr #skk$))
									; 2017/09/28 KY ADD-S
									; フレームキッチンでは食洗(性格コード:110)を除外
									(or
										(not (equal CG_SKK_THR_ETC (caddr #skk$)))
										(/= BU_CODE_0012 "1")
									)
									; 2017/09/28 KY ADD-E
								)
								(and ;冷蔵庫&ペニンシュラユニット
									(equal CG_SKK_ONE_ETC (car   #skk$))
									(equal CG_SKK_TWO_BAS (cadr  #skk$))
									(equal CG_SKK_THR_NRM (caddr #skk$))
								)
							)
							(setq #en$ (cons #en #en$))
						)
						(if (= CG_SKK_ONE_CNT (car #skk$))
							(progn
								(if  (= CG_SKK_TWO_BAS (cadr #skk$))
									(setq #enCnt$ (cons #en #enCnt$))
									(princ "性格CODE710以外が収納領域に含まれています。") ; 2000/09/20
								);_if
							)
						);_if
						(setq #i (1+ #i))
					);repeat

					; 2000/09/12 HT
					; カウンターがあれば最後付加
					; (カウンタからリンクされているものを
					; 探す(DivideSymParts)ようにするため)
					(setq #ssb (En$2Ss (append #en$ #enCnt$)))
					(if #ssb  ; 2000/09/27 HT ADD
						(progn
					;シンボルを分ける
							(setq #ss$ (DivideSymParts #ssb))
;;;01/07/23YM@              (mapcar '(lambda ( #ss )
							(foreach #ss #ss$ ; (mapcar '(lambda --> foreach 01/07/23 YM MOD
									;領域を獲得する
									(setq #rect$ (GetDiningArea #ss))
									;領域図形作図
									(setq #ryoiki #rect$)
									;領域内のシンボル図形を獲得
									(setq #ssw (ssadd))
									(setq #i 0)
									(repeat (sslength #sst)
										(setq #en (ssname #sst #i))
										;構成座標を獲得
										(setq #10$ (GetSym4Pt #en))
										(setq #flg T)
										(mapcar
										 '(lambda ( #10 )
												(setq #10 (list (car #10) (cadr #10) 0.0))
												(if (not (JudgeNaigai #10 #rect$))
													(setq #flg nil)
												)
											)
											(list (nth 0 #10$)(nth 1 #10$)(nth 2 #10$))
										)
										(if (/= nil #flg)
											(ssadd #en #ssw)
										)
										(setq #i (1+ #i))
									)
									(setq #ssw$ (cons (list #ryoiki #ssw) #ssw$))
;;;01/07/23YM@                )
;;;01/07/23YM@                #ss$
							);mapcar-->foreach 01/07/23 YM MOD

						) ; progn
						(progn
							; ウオールのみフロアなしの場合にダミーエリアを取得
							(setq #rect$ (GetDiningArea2 #sst))
							(setq #ssw$ (list (list #rect$ #sst)))
						)
					) ; if #ssb
				)
			)
		)
	)

	(list #sss$ #ssw$)
);DivSymByModel

;;;01/07/23YM@;;; lambda --> foreach 書き換え 01/07/23 YM DEL↓
;;;01/07/23YM@;;;<HOM>*************************************************************************
;;;01/07/23YM@;;; <関数名>    : DivSymByModel
;;;01/07/23YM@;;; <処理概要>  : キッチン又はダイニング毎にシンボルを分ける
;;;01/07/23YM@;;; <戻り値>    : 領域座標リストとシンボルリスト（キッチン ダイニング）
;;;01/07/23YM@;;; <備考>      :
;;;01/07/23YM@;;; <作成>      : 1999/11/10
;;;01/07/23YM@;;; <改訂>      : 2001/02/07 中村博伸
;;;01/07/23YM@;;;*************************************************************************>MOH<
;;;01/07/23YM@(defun DivSymByModel (
;;;01/07/23YM@  &ss         ; シンボルの選択セット
;;;01/07/23YM@  &ssw        ; ワークトップの選択セット
;;;01/07/23YM@  /
;;;01/07/23YM@  #sst #ssw #en #eed$ #pt$ #ryoiki #dpt$ #il #again$ #sss #sss$
;;;01/07/23YM@  #ssb #i #ss$ #ss #rect$ #10$ #flg #10 #ssw$
;;;01/07/23YM@  #enDEL$     ; カットされているワークトップ全体
;;;01/07/23YM@  #j          ; カウンタ
;;;01/07/23YM@  #skk$       ; 性格CODE
;;;01/07/23YM@  #en$        ; 図形名リスト
;;;01/07/23YM@  #enCnt$     ; 図形名リスト
;;;01/07/23YM@  )
;;;01/07/23YM@  (if (/= nil &ss)
;;;01/07/23YM@    (progn
;;;01/07/23YM@      (setq #sst &ss)
;;;01/07/23YM@      ;キッチンのシンボルを獲得
;;;01/07/23YM@      (setq #ssw &ssw)
;;;01/07/23YM@      (if (/= nil #ssw)
;;;01/07/23YM@        (progn
;;;01/07/23YM@          (setq #i 0)
;;;01/07/23YM@          ; 2000/07/12 HT DEL U型 ワークトップカット対応
;;;01/07/23YM@          ;(repeat (sslength #ssw)
;;;01/07/23YM@          (while (/= 0 (sslength #ssw))
;;;01/07/23YM@            (setq #en (ssname #ssw 0))
;;;01/07/23YM@            (setq #eed$ (CfGetXData #en "G_WRKT"))
;;;01/07/23YM@            ;00/05/16 HN S-DEL
;;;01/07/23YM@            ;@@@;カットされていたらもう一方を選択セットから除外する
;;;01/07/23YM@            ;@@@(if (/= 0 (nth 5 #eed$))
;;;01/07/23YM@            ;@@@  (if (= 'ENAME (type (nth 35 #eed$)))
;;;01/07/23YM@            ;@@@    (ssdel (nth 35 #eed$) #ssw)
;;;01/07/23YM@            ;@@@  )
;;;01/07/23YM@            ;@@@)
;;;01/07/23YM@            ;@@@;現在のワークトップを選択セットから除外する
;;;01/07/23YM@            ;@@@(ssdel #en #ssw)
;;;01/07/23YM@            ;00/05/16 HN E-DEL
;;;01/07/23YM@
;;;01/07/23YM@            ; 2000/07/11 HT カットされていたら右端以外を選択セットから除外する
;;;01/07/23YM@            (if (or (/= "" (nth 47 #eed$)) (/= "" (nth 48 #eed$)))
;;;01/07/23YM@              (progn
;;;01/07/23YM@	              ; 右端のワークトップ図形に置き換える
;;;01/07/23YM@	              (setq #en (car (PKGetMostRightWT #en))) ; 一番右のWT
;;;01/07/23YM@	              ; 右端を除くワークトップ図形を選択セットから削除する
;;;01/07/23YM@	              (setq #enDEL$ (PKGetWT$FromMRWT (nth 47 (CfGetXData #en "G_WRKT"))))
;;;01/07/23YM@	              (setq #j 0)
;;;01/07/23YM@	              (repeat (length #enDEL$)
;;;01/07/23YM@	                (ssdel (nth #j #enDEL$) #ssw)
;;;01/07/23YM@	                (setq #j (1+ #j))
;;;01/07/23YM@	              )
;;;01/07/23YM@              )
;;;01/07/23YM@            )
;;;01/07/23YM@            ; ワークトップを選択セットから削除する
;;;01/07/23YM@            (ssdel #en #ssw)
;;;01/07/23YM@
;;;01/07/23YM@            ;ワークトップの領域を獲得
;;;01/07/23YM@            (setq #pt$$ (GetWorkTopArea #en))
;;;01/07/23YM@
;;;01/07/23YM@            ; 2000/07/12 HT ADD U型 ワークトップカット対応
;;;01/07/23YM@            (mapcar '(lambda (#pt$)
;;;01/07/23YM@              ;領域図形作図
;;;01/07/23YM@              (setq #ryoiki (nth 0 #pt$))
;;;01/07/23YM@              (setq #dpt$   (nth 1 #pt$))
;;;01/07/23YM@
;;;01/07/23YM@              (setq #il     (nth 2 #pt$))
;;;01/07/23YM@              (setq #pt$ (reverse (car #pt$)))
;;;01/07/23YM@
;;;01/07/23YM@              ; 2000/07/06 HT YASHIAC  矢視領域判定変更 のため CG_UTypeWTで場合分け
;;;01/07/23YM@              (if (= CG_UTypeWT nil)
;;;01/07/23YM@                (progn
;;;01/07/23YM@	                ;領域内のシンボル図形を獲得する
;;;01/07/23YM@	                (setq #again$ (GetAreaAgain #ryoiki #dpt$ #sst (nth 4 #eed$)))
;;;01/07/23YM@	                (if (/= nil #again$)
;;;01/07/23YM@	                  (progn
;;;01/07/23YM@		                  (setq #sss    (En$2Ss (nth 0 #again$)))
;;;01/07/23YM@		                  (setq #ryoiki (nth 1 #again$))
;;;01/07/23YM@		                  (setq #dpt$   (nth 2 #again$))
;;;01/07/23YM@		                  ;選択セットから除外
;;;01/07/23YM@		                  (mapcar
;;;01/07/23YM@		                   '(lambda ( #en )
;;;01/07/23YM@		                      (ssdel #en #sst)
;;;01/07/23YM@		                    )
;;;01/07/23YM@		                    (nth 0 #again$)
;;;01/07/23YM@		                  )
;;;01/07/23YM@	                  )
;;;01/07/23YM@	                  (progn
;;;01/07/23YM@	                    ; L型のダイニングは存在しないものとする
;;;01/07/23YM@	                    (if (= #il "L")
;;;01/07/23YM@	                      (progn
;;;01/07/23YM@		                      (CFAlertMsg " 収納部にL型は扱えません。")
;;;01/07/23YM@		                      (exit)
;;;01/07/23YM@	                      )
;;;01/07/23YM@	                    )
;;;01/07/23YM@	                  )
;;;01/07/23YM@	                )
;;;01/07/23YM@                )
;;;01/07/23YM@                ; else
;;;01/07/23YM@                (progn
;;;01/07/23YM@	                ; 2000/07/06 HT YASHIAC  矢視領域判定変更
;;;01/07/23YM@	                ; U 型 対応
;;;01/07/23YM@	                (setq #again$ (GetAreaAgain #ryoiki #dpt$ #sst (nth 4 #eed$)))
;;;01/07/23YM@	                (setq #ryoiki (nth 1 #again$))  ; 2000/09/20 ADD
;;;01/07/23YM@	                (setq #dpt$   (nth 2 #again$))  ; 2000/09/20 ADD
;;;01/07/23YM@	                (setq #sss    (En$2Ss (nth 0 #again$)))
;;;01/07/23YM@                )
;;;01/07/23YM@              );_if
;;;01/07/23YM@
;;;01/07/23YM@              ;選択セットリストに格納
;;;01/07/23YM@              (if (and (/= nil #sss) (/= 0 (sslength #sss)))
;;;01/07/23YM@                (setq #sss$ (cons (list #ryoiki #sss #dpt$ #il) #sss$))
;;;01/07/23YM@              );_if
;;;01/07/23YM@						 	) ; lambda
;;;01/07/23YM@              #pt$$
;;;01/07/23YM@            ) ; mapcar  2000/07/12 HT ADD U型 ワークトップカット対応
;;;01/07/23YM@
;;;01/07/23YM@            (setq #i (1+ #i))
;;;01/07/23YM@          ) ; repeat
;;;01/07/23YM@        )
;;;01/07/23YM@      );_if
;;;01/07/23YM@
;;;01/07/23YM@      ; 2000/07/06 HT YASHIAC  矢視領域判定変更 START
;;;01/07/23YM@      (if CG_UTypeWT
;;;01/07/23YM@        (progn
;;;01/07/23YM@          (foreach #sss #sss$
;;;01/07/23YM@            (setq #sss (cadr #sss))
;;;01/07/23YM@            (setq #i 0)
;;;01/07/23YM@            (repeat (sslength #sss)
;;;01/07/23YM@              (setq #en (ssname #sss #i))
;;;01/07/23YM@              (if (ssmemb #en #sst)
;;;01/07/23YM@                (ssdel #en #sst)
;;;01/07/23YM@              )
;;;01/07/23YM@              (setq #i (1+ #i))
;;;01/07/23YM@            )
;;;01/07/23YM@          )
;;;01/07/23YM@          ;(setq #sst nil)
;;;01/07/23YM@        )
;;;01/07/23YM@      )
;;;01/07/23YM@      ; 2000/07/06 HT YASHIAC  矢視領域判定変更 END
;;;01/07/23YM@
;;;01/07/23YM@      ;ダイニングの選択セット
;;;01/07/23YM@      (if (and (/= nil #sst) (/= 0 (sslength #sst)))
;;;01/07/23YM@        (progn
;;;01/07/23YM@          ; 2000/07/25 HT + 冷蔵庫追加
;;;01/07/23YM@          ;ベースキャビネットのみ獲得
;;;01/07/23YM@          (setq #enCnt$ '() #en$ '())
;;;01/07/23YM@          (setq #ssb (ssadd))
;;;01/07/23YM@          (setq #i 0)
;;;01/07/23YM@          (repeat (sslength #sst)
;;;01/07/23YM@            (setq #en (ssname #sst #i))
;;;01/07/23YM@            (setq #skk$ (CfGetSymSKKCode #en nil))
;;;01/07/23YM@            (if
;;;01/07/23YM@              (or
;;;01/07/23YM@                (and
;;;01/07/23YM@                  (equal CG_SKK_ONE_CAB (car #skk$))
;;;01/07/23YM@                  (equal CG_SKK_TWO_BAS (cadr #skk$))
;;;01/07/23YM@                )
;;;01/07/23YM@                (and ;冷蔵庫&ペニンシュラユニット
;;;01/07/23YM@                  (equal CG_SKK_ONE_ETC (car   #skk$))
;;;01/07/23YM@                  (equal CG_SKK_TWO_BAS (cadr  #skk$))
;;;01/07/23YM@                  (equal CG_SKK_THR_NRM (caddr #skk$))
;;;01/07/23YM@                )
;;;01/07/23YM@              )
;;;01/07/23YM@              (setq #en$ (cons #en #en$))
;;;01/07/23YM@            )
;;;01/07/23YM@            (if (= CG_SKK_ONE_CNT (car #skk$))
;;;01/07/23YM@              (progn
;;;01/07/23YM@	              (if  (= CG_SKK_TWO_BAS (cadr #skk$))
;;;01/07/23YM@	                (setq #enCnt$ (cons #en #enCnt$))
;;;01/07/23YM@	                (princ "性格CODE710以外が収納領域に含まれています。") ; 2000/09/20
;;;01/07/23YM@	              );_if
;;;01/07/23YM@              )
;;;01/07/23YM@            );_if
;;;01/07/23YM@            (setq #i (1+ #i))
;;;01/07/23YM@          );repeat
;;;01/07/23YM@
;;;01/07/23YM@          ; 2000/09/12 HT
;;;01/07/23YM@          ; カウンターがあれば最後付加
;;;01/07/23YM@          ; (カウンタからリンクされているものを
;;;01/07/23YM@          ; 探す(DivideSymParts)ようにするため)
;;;01/07/23YM@          (setq #ssb (En$2Ss (append #en$ #enCnt$)))
;;;01/07/23YM@          (if #ssb  ; 2000/09/27 HT ADD
;;;01/07/23YM@            (progn
;;;01/07/23YM@          ;シンボルを分ける
;;;01/07/23YM@              (setq #ss$ (DivideSymParts #ssb))
;;;01/07/23YM@              (mapcar
;;;01/07/23YM@               '(lambda ( #ss )
;;;01/07/23YM@                  ;領域を獲得する
;;;01/07/23YM@                  (setq #rect$ (GetDiningArea #ss))
;;;01/07/23YM@                  ;領域図形作図
;;;01/07/23YM@                  (setq #ryoiki #rect$)
;;;01/07/23YM@                  ;領域内のシンボル図形を獲得
;;;01/07/23YM@                  (setq #ssw (ssadd))
;;;01/07/23YM@                  (setq #i 0)
;;;01/07/23YM@                  (repeat (sslength #sst)
;;;01/07/23YM@                    (setq #en (ssname #sst #i))
;;;01/07/23YM@                    ;構成座標を獲得
;;;01/07/23YM@                    (setq #10$ (GetSym4Pt #en))
;;;01/07/23YM@                    (setq #flg T)
;;;01/07/23YM@                    (mapcar
;;;01/07/23YM@                     '(lambda ( #10 )
;;;01/07/23YM@                        (setq #10 (list (car #10) (cadr #10) 0.0))
;;;01/07/23YM@                        (if (not (JudgeNaigai #10 #rect$))
;;;01/07/23YM@                          (setq #flg nil)
;;;01/07/23YM@                        )
;;;01/07/23YM@                      )
;;;01/07/23YM@                      (list (nth 0 #10$)(nth 1 #10$)(nth 2 #10$))
;;;01/07/23YM@                    )
;;;01/07/23YM@                    (if (/= nil #flg)
;;;01/07/23YM@                      (ssadd #en #ssw)
;;;01/07/23YM@                    )
;;;01/07/23YM@                    (setq #i (1+ #i))
;;;01/07/23YM@                  )
;;;01/07/23YM@                  (setq #ssw$ (cons (list #ryoiki #ssw) #ssw$))
;;;01/07/23YM@                )
;;;01/07/23YM@                #ss$
;;;01/07/23YM@              )
;;;01/07/23YM@            ) ; progn
;;;01/07/23YM@            (progn
;;;01/07/23YM@              ; ウオールのみフロアなしの場合にダミーエリアを取得
;;;01/07/23YM@              (setq #rect$ (GetDiningArea2 #sst))
;;;01/07/23YM@              (setq #ssw$ (list (list #rect$ #sst)))
;;;01/07/23YM@            )
;;;01/07/23YM@          ) ; if #ssb
;;;01/07/23YM@        )
;;;01/07/23YM@      )
;;;01/07/23YM@    )
;;;01/07/23YM@  )
;;;01/07/23YM@
;;;01/07/23YM@  (list #sss$ #ssw$)
;;;01/07/23YM@); lambda --> foreach 書き換え 01/07/23 YM DEL ↑

;<HOM>*************************************************************************
; <関数名>    : DelDummyArea
; <処理概要>  : ダミー領域削除
; <戻り値>    : なし
; <備考>      : なし
; <作成>      : 00/01/15
;*************************************************************************>MOH<
(defun DelDummyArea (
	/
	#ss #i #en
	)
	;ダミーエリア
	(setq #ss (ssget "X" (list (cons 0 "LWPOLYLINE") (list -3 (list "G_SKDM")))))
	(if (/= nil #ss)
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(entdel #en)
				(setq #i (1+ #i))
			)
		)
	)
	;ダミー点
	(setq #ss (ssget "X" (list (cons 0 "POINT") (list -3 (list "G_SKDM")))))
	(if (/= nil #ss)
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(if (/= nil (CfGetXData #en "G_LSYM"))
					(CfSetXData #en "G_SKDM" nil)
					(entdel #en)
				)
				(setq #i (1+ #i))
			)
		)
	)

	(princ)
)

;<HOM>*************************************************************************
; <関数名>    : GetDiningArea
; <処理概要>  : ダイニングのベースキャビネットから
;               領域を獲得する（L型はないものとする）
; <戻り値>    :
; <備考>      :
; <作成>      : 99/12/22
;*************************************************************************>MOH<
(defun GetDiningArea (
	&ss         ; ダイニングベースキャビネット選択エンティティ
	/
	#ss #i #en #ed$ #4pt$ #pt$$ #ang #ang_t #pt_n$$ #pt #minmax #rect$ #skk$
	)
	(if (/= nil &ss)
		(progn
			;ベースキャビネットの部分のみ獲得
			(setq #ss (ssadd))
			(if (= 1 (sslength &ss))
				(progn
					(ssadd (ssname &ss 0) #ss)
				)
				(progn
					(setq #i 0)
					(repeat (sslength &ss)
						(setq #en   (ssname &ss #i))
						(setq #ed$  (CFGetXData #en "G_LSYM"))
						(setq #skk$ (CfGetSymSKKCode #en nil))
						(if
							(or
								(equal CG_SKK_ONE_CNT (car #skk$))
								(and
									(equal CG_SKK_ONE_CAB (car #skk$))
									(equal CG_SKK_TWO_BAS (cadr #skk$))
								)
								(and
									(equal CG_SKK_ONE_ETC (car   #skk$))
									(equal CG_SKK_TWO_BAS (cadr  #skk$))
									(equal CG_SKK_THR_NRM (caddr #skk$))
								)
							)
							(ssadd #en #ss)
						)
						(setq #i (1+ #i))
					)
				)
			)
			;各３点座標を獲得
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #4pt$ (GetSym4Pt #en))
				(setq #pt$$ (cons (list (nth 0 #4pt$) (nth 1 #4pt$) (nth 2 #4pt$)) #pt$$))
				(setq #i (1+ #i))
			)

			; 2000/07/06 HT YASHIAC  矢視領域判定変更
			;領域算出
			; (if (JudgeStraightLine (mapcar 'car #pt$$))
			(if (or CG_UTypeWT (JudgeStraightLine (mapcar 'car #pt$$)))
				(progn
					;角度算出
					(setq #ang (angle (car (nth 0 #pt$$)) (cadr (nth 0 #pt$$))))
					(setq #ang (Angle0to360 #ang))
					(if (or (< 0.0 #ang (* 0.25 PI)) (< (* 1.25 PI) #ang (* 2.0 PI)))
						(setq #ang (+ PI #ang))
					)
					(setq #ang_t (Angle0to360 (- 0.0 #ang)))
					;座標変換
					(setq #pt$$ (apply 'append #pt$$))
					(setq #pt_n$$
						(mapcar
						 '(lambda ( #pt )
								(pt1jiHenkan #pt #ang_t)
							)
							#pt$$
						)
					)
					;領域獲得
					(setq #minmax (GetPtMinMax #pt_n$$))
					;４点に変換
					(setq #rect$
						(list
							(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
							(list (car (car  #minmax)) (cadr (car  #minmax)) 0.0)
							(list (car (cadr #minmax)) (cadr (car  #minmax)) 0.0)
							(list (car (cadr #minmax)) (cadr (cadr #minmax)) 0.0)
						)
					)
					;座標を元に戻す
					(setq #rect$
						(mapcar
						 '(lambda ( #pt )
								(pt1jiHenkan #pt #ang)
							)
							#rect$
						)
					)
					(setq #rect$ (append #rect$ (list (car #rect$))))
				)
			)
		)
	)

	#rect$
)


;<HOM>*************************************************************************
; <関数名>    : GetDiningArea2
; <処理概要>  : ダイニングのアッパーキャビネットから
;               領域を獲得する（L型はないものとする）
; <戻り値>    :
; <備考>      :
; <作成>      : 1999/12/22
; <改訂>      : 2001/02/08 中村博伸 座標のチェック処理を追加
;*************************************************************************>MOH<
(defun GetDiningArea2 (
	&ss         ; ダイニングベースキャビネット選択エンティティ
	/
	#ss #i #en #ed$ #4pt$ #pt$$ #ang #ang_t #pt_n$$ #pt #minmax #rect$ #skk$
	)
	(if (/= nil &ss)
		(progn
			;ベースキャビネットの部分のみ獲得
			(setq #ss (ssadd))
			(setq #i 0)
			(repeat (sslength &ss)
				(setq #en   (ssname &ss #i))
				(setq #skk$ (CfGetSymSKKCode #en nil))
				(setq #ed$  (CFGetXData #en "G_LSYM"))
				(cond
					((or
						(equal CG_SKK_ONE_CAB (car #skk$))
						(equal CG_SKK_ONE_RNG (car #skk$))
					 )
						(ssadd #en #ss)
					)
					((equal CG_SKK_ONE_SID (car #skk$))
						(ssadd #en #ss)
					)
					;(T 2000/10/27 今回のシステムで不要 START
					;  (if (or
					;      (and (= (car #skk$) 9) (= (cadr #skk$) 1) (= (caddr #skk$) 0)) ;キッチンパネル
					;      (and (= (car #skk$) 9) (= (cadr #skk$) 2) (= (caddr #skk$) 0)) ;キッチンパネル
					;      (and (= (car #skk$) 9) (= (cadr #skk$) 3) (= (caddr #skk$) 0)) ;キッチンパネル
					;    )
					;    (ssadd #en #ss)
					;  )
					;) 2000/10/27 今回のシステムで不要 END
				)
				(setq #i (1+ #i))
			)
			;(setq #ss &ss)
			;各３点座標を獲得
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #4pt$ (GetSym4Pt #en))
				(setq #pt$$ (cons (list (nth 0 #4pt$) (nth 1 #4pt$) (nth 2 #4pt$)) #pt$$))
				(setq #i (1+ #i))
			)
			;領域算出
			;- 0703 Delete ---------------------------
			;(if (or CG_UTypeWT (JudgeStraightLine (mapcar 'car #pt$$)))
			;- 0703 Delete ---------------------------
			; 01/02/08 HN ADD 座標の未設定チェックを追加
			(if #pt$$
				(progn
					;角度算出
					(setq #ang (angle (car (nth 0 #pt$$)) (cadr (nth 0 #pt$$))))
					(setq #ang (Angle0to360 #ang))
					(if (or (< 0.0 #ang (* 0.25 PI)) (< (* 1.25 PI) #ang (* 2.0 PI)))
						(setq #ang (+ PI #ang))
					)
					(setq #ang_t (Angle0to360 (- 0.0 #ang)))
					;座標変換
					(setq #pt$$ (apply 'append #pt$$))
					(setq #pt_n$$
						(mapcar
						 '(lambda ( #pt )
								(pt1jiHenkan #pt #ang_t)
							)
							#pt$$
						)
					)
					;領域獲得
					(setq #minmax (GetPtMinMax #pt_n$$))
					;４点に変換
					(setq #rect$
						(list
							(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
							(list (car (car  #minmax)) (cadr (car  #minmax)) 0.0)
							(list (car (cadr #minmax)) (cadr (car  #minmax)) 0.0)
							(list (car (cadr #minmax)) (cadr (cadr #minmax)) 0.0)
						)
					)
					;座標を元に戻す
					(setq #rect$
						(mapcar
						 '(lambda ( #pt )
								(pt1jiHenkan #pt #ang)
							)
							#rect$
						)
					)
					(setq #rect$ (append #rect$ (list (car #rect$))))
				)
			)
		)
	)

	#rect$
)

;<HOM>*************************************************************************
; <関数名>    : GetWorkTopArea
; <処理概要>  : ワークトップ領域の座標を獲得
; <戻り値>    : ; DEL 2000/07/12 ワークトップ領域座標リスト＋ダミー用構成座標＋ILフラグ)
; <戻り値>    : (ワークトップ領域座標リスト＋ダミー用構成座標＋ILフラグ)のリスト
; <作成>      : 99/12/03
; <備考>      : なし
;*************************************************************************>MOH<
(defun GetWorkTopArea (
	&en         ; ワークトップ図形名
	/
	#eed$ #pt$ #dpt$ #flg #tpt$
	#ret$$
	)

	;; 2000/07/12 点列取得方法変更 DEL START
	;;
	;;(setq #eed$ (CfGetXData &en "G_WRKT"))
	;;(if (= 0 (nth 3 #eed$))
	;;  ;I型
	;;  (progn
	;;    ;(if (< 50 (length #eed$))          ;00/04/10 HN MOD NewWT ;00/07/06 HT DEL
	;;      (setq #pt$ (PKGetWT_outPT    &en 1)) ; 01/08/10 YM ADD(引数追加)
	;;    ; (setq #pt$ (GetRyoikiIgata &en))                         ;00/07/06 HT DEL
	;;    ;)                                                          ;00/07/06 HT DEL
	;;    (setq #dpt$ (list (nth 0 #pt$)(nth 1 #pt$)(nth 2 #pt$)))
	;;    (setq #flg "I")
	;;  )
	;;  ;L型
	;;  (progn
	;;    ;(if (< 50 (length #eed$))          ;00/04/10 HN MOD NewWT   ;00/07/06 HT DEL
	;;      (setq #tpt$ (list (PKGetWT_outPT &en 1) nil)) ; 01/08/10 YM ADD(引数追加)
	;;    ;  (setq #tpt$ (GetAreaWrktL &en))                           ;00/07/06 HT DEL
	;;    ;)                                                           ;00/07/06 HT DEL
	;;    (setq #pt$ (car #tpt$))
	;;    (setq #dpt$ (list (nth 0 #pt$)(nth 1 #pt$)(nth 2 #pt$)(nth 5 #pt$)(nth 4 #pt$)(cadr #tpt$)))
	;;    (setq #flg "L")
	;;  )
	;;)
	;;
	;; 2000/07/12 点列取得方法変更 DEL END

	(setq #pt$$ (GetWorkTopArea2 &en))
	(setq #eed$ (CfGetXData &en "G_WRKT"))
	(setq #ret$$ '())

;---------------------------lambda==>foreach 01/07/23 YM DEL START
;;;01/07/23YM@  (mapcar '(lambda (#p$)
;;;01/07/23YM@    (setq #pt$ #p$)
;;;01/07/23YM@    (if (/= 1 (nth 3 #eed$))
;;;01/07/23YM@      ;I U 型
;;;01/07/23YM@      (progn
;;;01/07/23YM@      (setq #dpt$ (list (nth 0 #pt$)(nth 1 #pt$)(nth 2 #pt$)))
;;;01/07/23YM@      (setq #flg "I")
;;;01/07/23YM@      )
;;;01/07/23YM@      ;L型
;;;01/07/23YM@      (progn
;;;01/07/23YM@      (setq #dpt$ (list (nth 0 #pt$)(nth 1 #pt$)(nth 2 #pt$)(nth 5 #pt$)(nth 4 #pt$)(cadr #tpt$)))
;;;01/07/23YM@      (setq #flg "L")
;;;01/07/23YM@      )
;;;01/07/23YM@    )
;;;01/07/23YM@  (setq #ret$$ (append #ret$$ (list (list #pt$ #dpt$ #flg))))
;;;01/07/23YM@
;;;01/07/23YM@  )
;;;01/07/23YM@  #pt$$
;;;01/07/23YM@  );mapcar
;---------------------------lambda==>foreach 01/07/23 YM DEL START

;---------------------------lambda==>foreach 01/07/23 YM MOD START
	(foreach #pt$ #pt$$
		(if (/= 1 (nth 3 #eed$))
			;I U 型
			(progn
				(setq #dpt$ (list (nth 0 #pt$)(nth 1 #pt$)(nth 2 #pt$)))
				(setq #flg "I")
			)
			;L型
			(progn
				; 末尾のnilは不要では？？？ 02/09/27 YM
;;;	      (setq #dpt$ (list (nth 0 #pt$)(nth 1 #pt$)(nth 2 #pt$)(nth 5 #pt$)(nth 4 #pt$) nil)) ; #tpt$は常にnilなので(cadr #tpt$)もnil

				; 02/09/27 YM MOD nil を削除
				(setq #dpt$ (list (nth 0 #pt$)(nth 1 #pt$)(nth 2 #pt$)(nth 5 #pt$)(nth 4 #pt$))) ; #tpt$は常にnilなので(cadr #tpt$)もnil

;;;01/07/23YM@	      (setq #dpt$ (list (nth 0 #pt$)(nth 1 #pt$)(nth 2 #pt$)(nth 5 #pt$)(nth 4 #pt$)(cadr #tpt$))) ; #tpt$は何?入力ミス?
				(setq #flg "L")
			)
		);_if
		(setq #ret$$ (append #ret$$ (list (list #pt$ #dpt$ #flg))))
	)
;---------------------------lambda==>foreach 01/07/23 YM MOD END

	#ret$$
) ; GetWorkTopArea

;<HOM>*************************************************************************
; <関数名>    : GetWorkTopArea2
; <処理概要>  : ワークトップ領域の座標を獲得
; <戻り値>    : ワークトップ領域座標リスト＋ダミー用構成座標＋ILフラグ <---これはウソ？01/07/23 YM
; <作成>      : 00/07/12
; <備考>      : なし
;*************************************************************************>MOH<
(defun GetWorkTopArea2 (
	&en         ;(ENAME)右端のワークトップ図形名
	/
	#ed$
	#wpt$
	#en$        ; ワークトップ図形名リスト
	#ret$       ; 戻り値
	#Apt$       ; 外形点列
	#cpt1       ; 角1 (I型 U型)
	#cpt2       ; 角2 (U型)
	#pt$        ; ワークトップ点列
	#pt2$       ; ワークトップ点列
	#CPT #IPT1 #IPT2 #PT1 #PT2 #PT3 #PT4 #V
	#BASEPT$ #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #X1 #X2 #X3 #X4      ; 01/08/17 YM ADD
	#FG_S #P33 #P44 #P55 #P66 #TNEWSTYLE #X11 #X14 #X22 #X33 #X44 ; 01/08/17 YM ADD
#dum$ ; 02/06/26 YM ADD
	)

	; コーナーの点を取得する関数
	;
	;     PtA  -----------------------------    #bpt
	;          |               |  WorkTop A |
	;          |      ----------------------
	;          |      |
	;          |      |
	;          |      |
	;          |      ----------------------
	;          |               |  WorkTop B |
	;     PtB  -----------------------------    #bpt
	;
	;  &en2に WorkTop Aの図形名を指定すると、点PtAを返す
	;  &en2に WorkTop Bの図形名を指定すると、点PtBを返す
	;
	; あらかじめ関数が呼ばれる前に 外形点列 #Apt$の取得 要
	;
;------------------------------------------------------------------------------------------
				(defun #GetCpt (
					 &wpt$      ; ワークトップ 点列
					 &01flg     ; ワークトップの01方向でみる
					 &rAngEps	; 01/08/08 TM ADD 判定基準となる角度のずれ
					 						; 配置が一直線上になっていない場合に点が取得できるように、
											; 一直線上にない場合も幅を持って判定させる。
					 /
					 #wd$       ; ワークトップデータ
					 #i         ; カウンタ
					 #cpt       ; コーナー原点
					 #ang        ; 角度
					 #ang01     ; 頂点0-1の角度
					 #dpt       ; 外形点列の1点
					 #bpt       ; 判定点
					 #rpt       ; 返り点
					 #rAngEps	; 角度の差
					)
	
					(if &rAngEps
						(setq #rAngEps &rAngEps)
						(setq #rAngEps 0.01)			; デフォルト 0.01
					)

					(if &01flg
						(progn
						; 頂点0-1の角度
						(setq #ang01 (angle (nth 0 &wpt$) (nth 1 &wpt$)))
						(setq #bpt (nth 0 &wpt$))
						)
						(progn
						; 頂点1-0の角度
						(setq #ang01 (angle (nth 1 &wpt$) (nth 0 &wpt$)))
						(setq #bpt (nth 1 &wpt$))
						)
					)

					(setq #i 0)
					(setq #ang -100)
					; (cdr #Apt$) 重複した点は除く
					(repeat (length (cdr #Apt$))
						(setq #dpt (nth #i (cdr #Apt$)))
						; 判定基点と同じでない
						(if (not (equal (distance #bpt #dpt) 0 0.01))
							(progn
							; 頂点1 と 外形の頂点との角度
							(setq #ang (angle #bpt #dpt))
							; 01/08/08 TM MOD 角度判定を可変にする
							;if (equal #ang #ang01 0.01)
							(if (equal #ang #ang01 #rAngEps)
								(progn
									; 一定の角度範囲内にある点がコーナーの点になる
									(setq #rpt #dpt)
								)
							)
							)
						)
						(setq #i (1+ #i))
					) ; while

					#rpt
				);#GetCpt
;------------------------------------------------------------------------------------------

	; 右から順にワークトップの図形名を集める
	(setq #en$ (PKGetWT$FromMRWT &en))

	; 右端のワークトップの拡張データ取得
	(setq #ed$ (CfGetXData &en "G_WRKT"))
;;;01/08/17YM@DEL@	; 01/08/17 YM ADD 前垂れｼﾌﾄ量
;;;01/08/17YM@DEL@	(setq #FG_S (nth 17 #ed$))

	(cond
		((= 0 (nth 3 #ed$))
			; I型の場合
			; ワークトップ数1
			(if (= 1 (length #en$))
				(progn
					; 1個のワークトップの点列
					; コーナー原点
					(setq #cpt (nth 32 #ed$))
;;;01/08/10YM@					(setq #ret$ (list (append (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/10YM@																		(list(list (car (nth 32 #ed$))(cadr (nth 32 #ed$))))) ))

					; 02/06/26 YM ADD 変数化
					(setq #dum$ (GetPtSeries #cpt (PKGetWT_outPT &en nil)))
					; 02/06/26 YM ADD 警告追加
					(if (= nil #dum$)
						(progn
							(CFAlertMsg (strcat "\nﾜｰｸﾄｯﾌﾟが持っている情報に誤りがあり、このまま処理を続けるとｴﾗｰが発生します。\n"
																	"ﾜｰｸﾄｯﾌﾟをもう一度張りなおすと問題が解決する場合があります。"))
							(quit)
						)
					);_if
					; 02/06/26 YM ADD 警告追加

 					; 01/08/10 YM MOD-S
 					; WT外形点列取得(始点を末尾に追加せず)-->#cptから時計周りにする-->始点を末尾に追加
					(setq #ret$
				 		(list (AddPtList #dum$)) ; 01/08/10 YM ADD(引数追加)
					)

					; 02/06/26 YM DEL-S
;;;	        (setq #ret$
;;;				 		(list (AddPtList (GetPtSeries #cpt (PKGetWT_outPT &en nil)))) ; 01/08/10 YM ADD(引数追加)
;;;					)
					; 02/06/26 YM DEL-E

 					; 01/08/10 YM MOD-E
				)
				(progn ; I型でWT複数のとき ///////////////////////////////////////
					; 外形点列の取得
					; 01/07/03 TM MOD WT 拡張データから取得するように変更
					(setq #Apt$ (KCFWTSStoPlPt #ed$))

					; 01/07/03 TM MOD-S 旧データ対応
					(if (not #Apt$)
						(setq #Apt$ (PK_WTSStoPlPt (En$2Ss #en$)))
					)
					; 01/07/03 TM MOD-E 旧データ対応

					; 右端のワークトップの点列 コーナーから右周り
					(setq #pt$ (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1)))) ; 01/08/10 YM ADD(引数追加)

					; 02/06/26 YM ADD 警告追加
					(if (= nil #pt$)
						(progn
							(CFAlertMsg (strcat "\nﾜｰｸﾄｯﾌﾟが持っている情報に誤りがあり、このまま処理を続けるとｴﾗｰが発生します。\n"
																	"ﾜｰｸﾄｯﾌﾟをもう一度張りなおすと問題が解決する場合があります。"))
							(quit)
						)
					);_if
					; 02/06/26 YM ADD 警告追加

					; I型2枚あわせて1枚のI型とみなした時のコーナー原点
					(setq #cpt1 (#GetCpt #pt$ nil nil))
					; 右端のワークトップの点列
					(setq #ret$ (list (append (GetPtSeries #cpt1 (cdr #Apt$)) (list #cpt1))))
				) ; I型でWT複数のとき ////////////////////////////////////////////
			)
		)
		((= 1 (nth 3 #ed$))
			; L型の場合
			; ワークトップ数1
			(if (= 1 (length #en$))
				(progn
					; 1個のワークトップの点列
;;;01/08/10YM@	        (setq #ret$ (list (append (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/10YM@	                                  (list (list (car (nth 32 #ed$))(cadr (nth 32 #ed$))))) ))

					; 02/06/26 YM ADD 変数化
					(setq #dum$ (GetPtSeries (nth 32 #ed$) (PKGetWT_outPT &en nil)))
					; 02/06/26 YM ADD 警告追加
					(if (= nil #dum$)
						(progn
							(CFAlertMsg (strcat "\nﾜｰｸﾄｯﾌﾟが持っている情報に誤りがあり、このまま処理を続けるとｴﾗｰが発生します。\n"
																	"ﾜｰｸﾄｯﾌﾟをもう一度張りなおすと問題が解決する場合があります。"))
							(quit)
						)
					);_if
					; 02/06/26 YM ADD 警告追加

 					; 01/08/10 YM MOD-S
 					; WT外形点列取得(始点を末尾に追加せず)-->#cptから時計周りにする-->始点を末尾に追加
					(setq #ret$
				 		(list (AddPtList #dum$)) ; 01/08/10 YM ADD(引数追加)
					)

					; 02/06/26 YM DEL-S
;;;	        (setq #ret$
;;;				 		(list (AddPtList (GetPtSeries (nth 32 #ed$) (PKGetWT_outPT &en nil)))) ; 01/08/10 YM ADD(引数追加)
;;;					)
					; 02/06/26 YM DEL-E

 					; 01/08/10 YM MOD-E
				)
				(progn
					; 外形点列の取得
					; 01/07/03 TM MOD テスト
					(setq #Apt$ (KCFWTSStoPlPt #ed$))
					; 01/07/03 TM MOD-S 旧データ対応
					(if (not #Apt$)
						(setq #Apt$ (PK_WTSStoPlPt (En$2Ss #en$)))
					)
					; 01/07/03 TM MOD-E 旧データ対応

;;;01/08/17YM@					; 右端のワークトップの点列 コーナーから右周り
;;;01/08/17YM@					(setq #pt$ (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1)))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/17YM@					; L型右端を含んで1枚のL型とみなした時のコーナー原点
;;;01/08/17YM@					(setq #cpt1 (#GetCpt #pt$ nil nil))

					; L形状点列からｺｰﾅｰ基点を求める ; 01/08/17 YM MOD-S
					(setq #cpt1 (PKGetBaseL6 (cdr #Apt$))) ; #GetCpt とは違うﾛｼﾞｯｸ
					; L形状点列からｺｰﾅｰ基点を求める ; 01/08/17 YM MOD-E
					(setq #ret$ (list (append (GetPtSeries #cpt1 (cdr #Apt$)) (list #cpt1))))

				)
			);_if
		); 1
		((= 2 (nth 3 #ed$))
			; U型の場合
			; ワークトップ数1
			(if (= 1 (length #en$))
				(progn ; U型でWTが1枚(ｶｯﾄなし)というのはありえないのでここは通らない? /////////////////////

					; 01/12/12 YM ADD-S U型でWTが1枚のｹｰｽがあるので対応------------------------------
					; 外形点列の取得
					(setq #Apt$ (KCFWTSStoPlPt #ed$))
					(if (not #Apt$)
						(setq #Apt$ (PK_WTSStoPlPt (En$2Ss #en$)))
					)
					; L形状点列からｺｰﾅｰ基点を求める
					(setq #cpt1$ (PKGetBaseU8 (cdr #Apt$))) ; #GetCpt とは違うﾛｼﾞｯｸ PKGetBaseU8
					(setq #cpt1 (car #cpt1$))
					; L形状点列からｺｰﾅｰ基点を求める
					(setq #ret$ (list (append (GetPtSeries #cpt1 (cdr #Apt$)) (list #cpt1))))
					; 01/12/12 YM ADD-E U型でWTが1枚のｹｰｽがあるので対応------------------------------

;;;01/12/12YM@DEL					; 1個のワークトップの点列
;;;01/12/12YM@DEL					; ワークトップの点列 コーナーから右周り
;;;01/12/12YM@DEL					(setq #Apt$ (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1)))) ; 01/08/10 YM ADD(引数追加)
;;;01/12/12YM@DEL					(setq #ipt1 (nth 3 #Apt$))
;;;01/12/12YM@DEL					(setq #v (list (- (car (nth 1 #Apt$)) (car (nth 2 #Apt$)))
;;;01/12/12YM@DEL												 (- (cadr (nth 1 #Apt$)) (cadr (nth 2 #Apt$)))))
;;;01/12/12YM@DEL					(setq #ipt1 (list (+ (car #v) (car #ipt1)) (+ (cadr #v) (cadr #ipt1))))
;;;01/12/12YM@DEL
;;;01/12/12YM@DEL					(setq #v (list (- (car (nth 5 #Apt$)) (car (nth 6 #Apt$)))
;;;01/12/12YM@DEL												 (- (cadr (nth 5 #Apt$)) (cadr (nth 6 #Apt$)))))
;;;01/12/12YM@DEL					(setq #ipt2 (list (+ (car #v) (car (nth 7 #Apt$))) (+ (cadr #v) (cadr (nth 7 #Apt$)))))
;;;01/12/12YM@DEL
;;;01/12/12YM@DEL					(setq #ret$ '())
;;;01/12/12YM@DEL
;;;01/12/12YM@DEL					; I 型-1について 4 頂点を求める
;;;01/12/12YM@DEL					(setq #pt1 (nth 0 #Apt$)
;;;01/12/12YM@DEL								#pt2 (nth 1 #Apt$)
;;;01/12/12YM@DEL								#pt3 (nth 2 #Apt$))
;;;01/12/12YM@DEL					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/12/12YM@DEL					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/12/12YM@DEL					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/12/12YM@DEL					; I 型-2について 4 頂点を求める
;;;01/12/12YM@DEL					(setq #pt1 (nth 7 #Apt$)
;;;01/12/12YM@DEL								#pt2 (nth 0 #Apt$)
;;;01/12/12YM@DEL								#pt3 #ipt1)
;;;01/12/12YM@DEL					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/12/12YM@DEL					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/12/12YM@DEL					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/12/12YM@DEL					; I 型-3について 4 頂点を求める
;;;01/12/12YM@DEL					(setq #pt1 (nth 6 #Apt$)
;;;01/12/12YM@DEL								#pt2 (nth 7 #Apt$)
;;;01/12/12YM@DEL								#pt3 #ipt2)
;;;01/12/12YM@DEL					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/12/12YM@DEL					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/12/12YM@DEL					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/12/12YM@DEL
;;;01/12/12YM@DEL  ;  ((I 型-1 ) (I 型-2 ) (I 型-3 ))
;;;01/12/12YM@DEL  ;
;;;01/12/12YM@DEL  ;                        #ipt1
;;;01/12/12YM@DEL  ; (nth 0 #Apt$)    ----------------------------    (nth 1 #Apt$)
;;;01/12/12YM@DEL  ;                 |           I 型-1           |
;;;01/12/12YM@DEL  ;                 |      ----------------------    (nth 2 #Apt$)
;;;01/12/12YM@DEL  ;                 | I 型 |
;;;01/12/12YM@DEL  ;                 |   |  |
;;;01/12/12YM@DEL  ;                 |   2  |
;;;01/12/12YM@DEL  ;          #ipt2  |      ----------------------    (nth 5 #Apt$)
;;;01/12/12YM@DEL  ;                 |           I 型-3           |
;;;01/12/12YM@DEL  ; (nth 7 #Apt$)   -----------------------------   (nth 6 #Apt$)

				) ; U型でWTが1枚(ｶｯﾄなし)というのはありえないのでここは通らない? /////////////////////
				(progn

					; ワークトップ数 1 <
					; 外形点列の取得
					; 01/07/03 TM MOD テスト
					(setq #Apt$ (KCFWTSStoPlPt #ed$)) ; 段差部分も含めたWT全外形領域(但し前垂れｼﾌﾄ量を含んでいない)

					; 01/07/03 TM MOD-S 旧データ対応
					(setq #tNewStyle nil);段差部分も含めたWT全外形領域(但し前垂れｼﾌﾄ量を含んでいない)を使用する場合'T
					(if (= nil #Apt$)
						(setq #Apt$ (PK_WTSStoPlPt (En$2Ss #en$))) ; 従来の方法
						(setq #tNewStyle T)
					);_if
					; 01/07/03 TM MOD-E 旧データ対応

					; 下の部分を全面的に書き換え ; 01/08/17 YM MOD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #BASEPT$ (PKGetBaseU8 (cdr #Apt$)))
					(setq #cpt1 (car  #BASEPT$)) ; ｺｰﾅｰ基点1
					(setq #cpt2 (cadr #BASEPT$)) ; ｺｰﾅｰ基点2

					; ｺｰﾅｰ基点から時計周りにする ; 前垂れｼﾌﾄ量を考慮する
					(setq #Apt$ (GetPtSeries #cpt1 (cdr #Apt$)))
					(setq #p1 (nth 0 #Apt$))
					(setq #p2 (nth 1 #Apt$))
					(setq #p3 (nth 2 #Apt$))
					(setq #p4 (nth 3 #Apt$))
					(setq #p5 (nth 4 #Apt$))
					(setq #p6 (nth 5 #Apt$))
					(setq #p7 (nth 6 #Apt$))
					(setq #p8 (nth 7 #Apt$))

;;;01/08/17YM@DEL@					(setq #p33 (polar #p3  (angle #p2 #p3) #FG_S))
;;;01/08/17YM@DEL@					(setq #p44 (polar #p4  (angle #p2 #p3) #FG_S))
;;;01/08/17YM@DEL@					(setq #p44 (polar #p44 (angle #p1 #p2) #FG_S))
;;;01/08/17YM@DEL@					(setq #p55 (polar #p5  (angle #p3 #p2) #FG_S))
;;;01/08/17YM@DEL@					(setq #p55 (polar #p55 (angle #p1 #p2) #FG_S))
;;;01/08/17YM@DEL@					(setq #p66 (polar #p6  (angle #p3 #p2) #FG_S))

					;;; 垂線の足を求める #x1,#x2
					(setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
					(setq #x2 (CFGetDropPt #p4 (list #p1 #p8)))
					(setq #x3 (CFGetDropPt #p5 (list #p1 #p8)))
					(setq #x4 (CFGetDropPt #p5 (list #p7 #p8)))

;;;01/08/17YM@DEL@				  (setq #x11 (CFGetDropPt #p44 (list #p1 #p2)))
;;;01/08/17YM@DEL@				  (setq #x22 (CFGetDropPt #p44 (list #p1 #p8)))
;;;01/08/17YM@DEL@				  (setq #x33 (CFGetDropPt #p55 (list #p1 #p8)))
;;;01/08/17YM@DEL@					(setq #x44 (CFGetDropPt #p55 (list #p7 #p8)))

					; cp1=p1    x1
					; +----------++---------------------+p2
					; |          |x11                   |
					; |          |                      |
					; |          |                      |
					; +x2--------+p4--------------------+p3
					; +x22       |+p44------------------+p33
					; |          ||
					; +x33       |+p55------------------+p66
					; +x3--------+p5--------------------+p6
					; |          |                      |
					; |          |                      |
					; |          |x44                   |
					; +----------++---------------------+p7
					; cp2=p8    x4

;;;01/08/17YM@DEL@					(if #tNewStyle
;;;01/08/17YM@DEL@						(setq #ret$ ; 前垂れをあとから考慮
;;;01/08/17YM@DEL@							(list
;;;01/08/17YM@DEL@								(list #p1 #p2 #p33 #x22 #p1)
;;;01/08/17YM@DEL@								(list #p8 #p1 #x11 #x44 #p8)
;;;01/08/17YM@DEL@								(list #p7 #p8 #x33 #p66 #p7)
;;;01/08/17YM@DEL@							)
;;;01/08/17YM@DEL@						)
						(setq #ret$ ; 前垂れを最初からから考慮
							(list
								(list #p1 #p2 #p3 #x2 #p1)
								(list #p8 #p1 #x1 #x4 #p8)
								(list #p7 #p8 #x3 #p6 #p7)
							)
						)
;;;01/08/17YM@DEL@					);_if

					; 下の部分を全面的に書き換え ; 01/08/17 YM MOD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

; 書き換え ; 01/08/17 YM (何がしたいのか知る手がかりとなるため残す) START
;;;01/08/17YM@
;;;01/08/17YM@					; 右端のワークトップの点列 コーナーから右周り
;;;01/08/17YM@					(setq #pt$ (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1)))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/17YM@					; U型右端を含んで1枚のI型とみなした時のコーナー原点
;;;01/08/17YM@					(setq #cpt1 (#GetCpt #pt$ nil nil))
;;;01/08/17YM@					; 01/08/08 TM ADD-S 配置が歪んでいる場合、現在の関数では点が取得できない
;;;01/08/17YM@					(if (not #cpt1)
;;;01/08/17YM@						(progn
;;;01/08/17YM@							(setq #cpt1 (#GetCpt #pt$ nil CG_KCFDIV_ANG_EPS))
;;;01/08/17YM@							(if #cpt1
;;;01/08/17YM@								(progn
;;;01/08/17YM@									(CFAlertMsg "キャビネットの領域形状が特殊です。\n展開図作成を続行しますが、寸法表示が不正になる可能性があります。")
;;;01/08/17YM@								)
;;;01/08/17YM@								(progn
;;;01/08/17YM@									(CFAlertMsg "キャビネットの領域形状が特殊です。\n展開図作成を続行できません。")
;;;01/08/17YM@									(quit)
;;;01/08/17YM@								)
;;;01/08/17YM@							)
;;;01/08/17YM@						)
;;;01/08/17YM@					)
;;;01/08/17YM@					; 01/08/08 TM ADD-E 配置が歪んでいる場合、現在の関数では点が取得できない
;;;01/08/17YM@
;;;01/08/17YM@					(setq #enL (last #en$))
;;;01/08/17YM@					; 右端のワークトップの拡張データ取得
;;;01/08/17YM@					(setq #edL$ (CfGetXData #enL "G_WRKT"))
;;;01/08/17YM@						; 左端のワークトップの点列
;;;01/08/17YM@					(setq #pt2$ (GetPtSeries (nth 32 #edL$) (cdr (PKGetWT_outPT #enL 1)))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/17YM@					; U型左端を含んで1枚のI型とみなした時のコーナー原点
;;;01/08/17YM@					(setq #cpt2 (#GetCpt #pt2$ T nil))
;;;01/08/17YM@					; 01/08/08 TM ADD-S 配置が歪んでいる場合、現在の関数では点が取得できない
;;;01/08/17YM@					(if (not #cpt2)
;;;01/08/17YM@						(progn
;;;01/08/17YM@							(setq #cpt2 (#GetCpt #pt$ T CG_KCFDIV_ANG_EPS))
;;;01/08/17YM@							(princ "\nキャビネットの配置角度が特殊です。")
;;;01/08/17YM@							(if #cpt2
;;;01/08/17YM@								(progn
;;;01/08/17YM@									(CFAlertMsg "キャビネットの領域形状が特殊です。\n展開図作成を続行しますが、寸法表示が不正になる可能性があります。")
;;;01/08/17YM@								)
;;;01/08/17YM@								(progn
;;;01/08/17YM@									(CFAlertMsg "キャビネットの領域形状が特殊です。\n展開図作成を続行できません。")
;;;01/08/17YM@									(quit)
;;;01/08/17YM@								)
;;;01/08/17YM@							)
;;;01/08/17YM@						)
;;;01/08/17YM@					)
;;;01/08/17YM@					; 01/08/08 TM ADD-E 配置が歪んでいる場合、現在の関数では点が取得できない
;;;01/08/17YM@
;;;01/08/17YM@					(setq #enL (last #en$))
;;;01/08/17YM@
;;;01/08/17YM@					; last と last2を求める
;;;01/08/17YM@					(setq #ipt1 (nth 3 (GetPtSeries #cpt1 (cdr #Apt$))))
;;;01/08/17YM@					(setq #v (list (- (car (nth 1 #pt$)) (car (nth 2 #pt$)))
;;;01/08/17YM@												 (- (cadr (nth 1 #pt$)) (cadr (nth 2 #pt$)))))
;;;01/08/17YM@					(setq #ipt1 (list (+ (car #v) (car #ipt1)) (+ (cadr #v) (cadr #ipt1))))
;;;01/08/17YM@
;;;01/08/17YM@					(setq #lpt2 (car (reverse #pt2$)))
;;;01/08/17YM@					(setq #spt (car #pt2$))
;;;01/08/17YM@					(setq #v (list (- (car #lpt2) (car #spt)) (- (cadr #lpt2) (cadr #spt))))
;;;01/08/17YM@					(setq #ipt2 (list (+ (car #v) (car #cpt2)) (+ (cadr #v) (cadr #cpt2))))
;;;01/08/17YM@
;;;01/08/17YM@  ;  ((I 型-1 ) (I 型-2 ) (I 型-3 ))
;;;01/08/17YM@  ;
;;;01/08/17YM@  ;                   #ipt1
;;;01/08/17YM@  ;     #cpt1   ----------------------------    (nth 1 #pt$)
;;;01/08/17YM@  ;            |           I 型-1           |
;;;01/08/17YM@  ;            |      ----------------------    (nth 2 #pt$)
;;;01/08/17YM@  ;            | I 型 |
;;;01/08/17YM@  ;            |   |  |
;;;01/08/17YM@  ;            |   2  |
;;;01/08/17YM@  ;     #ipt2  |      ----------------------    (nth 1 #pt2$)
;;;01/08/17YM@  ;            |           I 型-3           |
;;;01/08/17YM@  ;     #cpt2   -----------------------------   (nth 0 #pt2$)
;;;01/08/17YM@  ;
;;;01/08/17YM@
;;;01/08/17YM@
;;;01/08/17YM@					(setq #ret$ '())
;;;01/08/17YM@					; I 型-1について 4 頂点を求める
;;;01/08/17YM@					(setq #pt1 #cpt1
;;;01/08/17YM@								#pt2 (nth 1 #pt$)
;;;01/08/17YM@								#pt3 (nth 2 #pt$))
;;;01/08/17YM@
;;;01/08/17YM@					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/08/17YM@					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/08/17YM@					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/08/17YM@
;;;01/08/17YM@
;;;01/08/17YM@					; I 型-2について 4 頂点を求める
;;;01/08/17YM@					(setq #pt1 #cpt2
;;;01/08/17YM@								#pt2 #cpt1
;;;01/08/17YM@								#pt3 #ipt1)
;;;01/08/17YM@
;;;01/08/17YM@					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/08/17YM@					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/08/17YM@					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/08/17YM@
;;;01/08/17YM@					; I 型-3について 4 頂点を求める
;;;01/08/17YM@					(setq #pt1 (nth 0 #pt2$)
;;;01/08/17YM@								#pt2 #cpt2
;;;01/08/17YM@								#pt3 #ipt2)
;;;01/08/17YM@
;;;01/08/17YM@					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/08/17YM@					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/08/17YM@					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/08/17YM@
; 書き換え ; 01/08/17 YM (何がしたいのか知る手がかりとなるため残す) END

				)
			)
		)
	)
	#ret$
) ; GetWorkTopArea2

;;;01/08/10YM@;<HOM>*************************************************************************
;;;01/08/10YM@; <関数名>    : GetWorkTopArea2
;;;01/08/10YM@; <処理概要>  : ワークトップ領域の座標を獲得
;;;01/08/10YM@; <戻り値>    : ワークトップ領域座標リスト＋ダミー用構成座標＋ILフラグ <---これはウソ？01/07/23 YM
;;;01/08/10YM@; <作成>      : 00/07/12
;;;01/08/10YM@; <備考>      : なし
;;;01/08/10YM@;*************************************************************************>MOH<
;;;01/08/10YM@(defun GetWorkTopArea2 (
;;;01/08/10YM@  &en         ;(ENAME)右端のワークトップ図形名
;;;01/08/10YM@  /
;;;01/08/10YM@  #ed$
;;;01/08/10YM@  #wpt$
;;;01/08/10YM@  #en$        ; ワークトップ図形名リスト
;;;01/08/10YM@  #ret$       ; 戻り値
;;;01/08/10YM@  #Apt$       ; 外形点列
;;;01/08/10YM@  #cpt1       ; 角1 (I型 U型)
;;;01/08/10YM@  #cpt2       ; 角2 (U型)
;;;01/08/10YM@  #pt$        ; ワークトップ点列
;;;01/08/10YM@  #pt2$       ; ワークトップ点列
;;;01/08/10YM@  )
;;;01/08/10YM@
;;;01/08/10YM@  ; コーナーの点を取得する関数
;;;01/08/10YM@  ;
;;;01/08/10YM@  ;     PtA  -----------------------------    #bpt
;;;01/08/10YM@  ;          |               |  WorkTop A |
;;;01/08/10YM@  ;          |      ----------------------
;;;01/08/10YM@  ;          |      |
;;;01/08/10YM@  ;          |      |
;;;01/08/10YM@  ;          |      |
;;;01/08/10YM@  ;          |      ----------------------
;;;01/08/10YM@  ;          |               |  WorkTop B |
;;;01/08/10YM@  ;     PtB  -----------------------------    #bpt
;;;01/08/10YM@  ;
;;;01/08/10YM@  ;  &en2に WorkTop Aの図形名を指定すると、点PtAを返す
;;;01/08/10YM@  ;  &en2に WorkTop Bの図形名を指定すると、点PtBを返す
;;;01/08/10YM@  ;
;;;01/08/10YM@  ; あらかじめ関数が呼ばれる前に 外形点列 #Apt$の取得 要
;;;01/08/10YM@  ;
;;;01/08/10YM@;------------------------------------------------------------------------------------------
;;;01/08/10YM@			  (defun #GetCpt (
;;;01/08/10YM@			     &wpt$      ; ワークトップ 点列
;;;01/08/10YM@			     &01flg     ; ワークトップの01方向でみる
;;;01/08/10YM@					 &rAngEps	; 01/08/08 TM ADD 判定基準となる角度のずれ
;;;01/08/10YM@					 						; 配置が一直線上になっていない場合に点が取得できるように、
;;;01/08/10YM@											; 一直線上にない場合も幅を持って判定させる。
;;;01/08/10YM@			     /
;;;01/08/10YM@			     #wd$       ; ワークトップデータ
;;;01/08/10YM@			     #i         ; カウンタ
;;;01/08/10YM@			     #cpt       ; コーナー原点
;;;01/08/10YM@			     #ang        ; 角度
;;;01/08/10YM@			     #ang01     ; 頂点0-1の角度
;;;01/08/10YM@			     #dpt       ; 外形点列の1点
;;;01/08/10YM@			     #bpt       ; 判定点
;;;01/08/10YM@			     #rpt       ; 返り点
;;;01/08/10YM@					 #rAngEps	; 角度の差
;;;01/08/10YM@					)
;;;01/08/10YM@	
;;;01/08/10YM@					(if &rAngEps
;;;01/08/10YM@						(setq #rAngEps &rAngEps)
;;;01/08/10YM@						(setq #rAngEps 0.01)			; デフォルト 0.01
;;;01/08/10YM@					)
;;;01/08/10YM@
;;;01/08/10YM@			    (if &01flg
;;;01/08/10YM@			      (progn
;;;01/08/10YM@			      ; 頂点0-1の角度
;;;01/08/10YM@			      (setq #ang01 (angle (nth 0 &wpt$) (nth 1 &wpt$)))
;;;01/08/10YM@			      (setq #bpt (nth 0 &wpt$))
;;;01/08/10YM@			      )
;;;01/08/10YM@			      (progn
;;;01/08/10YM@			      ; 頂点1-0の角度
;;;01/08/10YM@			      (setq #ang01 (angle (nth 1 &wpt$) (nth 0 &wpt$)))
;;;01/08/10YM@			      (setq #bpt (nth 1 &wpt$))
;;;01/08/10YM@			      )
;;;01/08/10YM@			    )
;;;01/08/10YM@
;;;01/08/10YM@			    (setq #i 0)
;;;01/08/10YM@			    (setq #ang -100)
;;;01/08/10YM@			    ; (cdr #Apt$) 重複した点は除く
;;;01/08/10YM@			    (repeat (length (cdr #Apt$))
;;;01/08/10YM@			      (setq #dpt (nth #i (cdr #Apt$)))
;;;01/08/10YM@			      ; 判定基点と同じでない
;;;01/08/10YM@			      (if (not (equal (distance #bpt #dpt) 0 0.01))
;;;01/08/10YM@			        (progn
;;;01/08/10YM@			        ; 頂点1 と 外形の頂点との角度
;;;01/08/10YM@			        (setq #ang (angle #bpt #dpt))
;;;01/08/10YM@							; 01/08/08 TM MOD 角度判定を可変にする
;;;01/08/10YM@			        ;if (equal #ang #ang01 0.01)
;;;01/08/10YM@			        (if (equal #ang #ang01 #rAngEps)
;;;01/08/10YM@			          (progn
;;;01/08/10YM@			          	; 一定の角度範囲内にある点がコーナーの点になる
;;;01/08/10YM@			          	(setq #rpt #dpt)
;;;01/08/10YM@			          )
;;;01/08/10YM@			        )
;;;01/08/10YM@			        )
;;;01/08/10YM@			      )
;;;01/08/10YM@			      (setq #i (1+ #i))
;;;01/08/10YM@			    ) ; while
;;;01/08/10YM@
;;;01/08/10YM@			    #rpt
;;;01/08/10YM@			  );#GetCpt
;;;01/08/10YM@;------------------------------------------------------------------------------------------
;;;01/08/10YM@
;;;01/08/10YM@  ; 右から順にワークトップの図形名を集める
;;;01/08/10YM@  (setq #en$ (PKGetWT$FromMRWT &en))
;;;01/08/10YM@
;;;01/08/10YM@  ; 右端のワークトップの拡張データ取得
;;;01/08/10YM@  (setq #ed$ (CfGetXData &en "G_WRKT"))
;;;01/08/10YM@  (cond
;;;01/08/10YM@    ((= 0 (nth 3 #ed$))
;;;01/08/10YM@      ; I型の場合
;;;01/08/10YM@      ; ワークトップ数1
;;;01/08/10YM@      (if (= 1 (length #en$))
;;;01/08/10YM@        (progn
;;;01/08/10YM@					; 1個のワークトップの点列
;;;01/08/10YM@					; コーナー原点
;;;01/08/10YM@					(setq #cpt (nth 32 #ed$))
;;;01/08/10YM@					(setq #ret$ (list (append (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/10YM@																		(list(list (car (nth 32 #ed$))(cadr (nth 32 #ed$))))) ))
;;;01/08/10YM@					)
;;;01/08/10YM@					(progn
;;;01/08/10YM@					; 外形点列の取得
;;;01/08/10YM@					; 01/07/03 TM MOD WT 拡張データから取得するように変更
;;;01/08/10YM@					(setq #Apt$ (KCFWTSStoPlPt #ed$))
;;;01/08/10YM@
;;;01/08/10YM@					; 01/07/03 TM MOD-S 旧データ対応
;;;01/08/10YM@					(if (not #Apt$)
;;;01/08/10YM@						(setq #Apt$ (PK_WTSStoPlPt (En$2Ss #en$)))
;;;01/08/10YM@					)
;;;01/08/10YM@					; 01/07/03 TM MOD-E 旧データ対応
;;;01/08/10YM@
;;;01/08/10YM@					; 右端のワークトップの点列 コーナーから右周り
;;;01/08/10YM@					(setq #pt$ (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1)))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/10YM@					; I型2枚あわせて1枚のI型とみなした時のコーナー原点
;;;01/08/10YM@					(setq #cpt1 (#GetCpt #pt$ nil nil))
;;;01/08/10YM@					; 右端のワークトップの点列
;;;01/08/10YM@					(setq #ret$ (list (append (GetPtSeries #cpt1 (cdr #Apt$)) (list #cpt1))))
;;;01/08/10YM@				)
;;;01/08/10YM@			)
;;;01/08/10YM@		)
;;;01/08/10YM@		((= 1 (nth 3 #ed$))
;;;01/08/10YM@			; I型の場合
;;;01/08/10YM@			; ワークトップ数1
;;;01/08/10YM@			(if (= 1 (length #en$))
;;;01/08/10YM@				(progn
;;;01/08/10YM@					; 1個のワークトップの点列
;;;01/08/10YM@					(setq #ret$ (list (append (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/10YM@																		(list (list (car (nth 32 #ed$))(cadr (nth 32 #ed$))))) ))
;;;01/08/10YM@					)
;;;01/08/10YM@					(progn
;;;01/08/10YM@					; 外形点列の取得
;;;01/08/10YM@					; 01/07/03 TM MOD テスト
;;;01/08/10YM@					(setq #Apt$ (KCFWTSStoPlPt #ed$))
;;;01/08/10YM@					; 01/07/03 TM MOD-S 旧データ対応
;;;01/08/10YM@					(if (not #Apt$)
;;;01/08/10YM@						(setq #Apt$ (PK_WTSStoPlPt (En$2Ss #en$)))
;;;01/08/10YM@					)
;;;01/08/10YM@					; 01/07/03 TM MOD-E 旧データ対応
;;;01/08/10YM@
;;;01/08/10YM@					; 右端のワークトップの点列 コーナーから右周り
;;;01/08/10YM@					(setq #pt$ (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1)))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/10YM@
;;;01/08/10YM@					; L型右端を含んで1枚のL型とみなした時のコーナー原点
;;;01/08/10YM@					(setq #cpt1 (#GetCpt #pt$ nil nil))
;;;01/08/10YM@
;;;01/08/10YM@        	(setq #ret$ (list (append (GetPtSeries #cpt1 (cdr #Apt$)) (list #cpt1))))
;;;01/08/10YM@        )
;;;01/08/10YM@      )
;;;01/08/10YM@    ); 1
;;;01/08/10YM@    ((= 2 (nth 3 #ed$))
;;;01/08/10YM@      ; U型の場合
;;;01/08/10YM@      ; ワークトップ数1
;;;01/08/10YM@      (if (= 1 (length #en$))
;;;01/08/10YM@        (progn
;;;01/08/10YM@					; 1個のワークトップの点列
;;;01/08/10YM@					; ワークトップの点列 コーナーから右周り
;;;01/08/10YM@					(setq #Apt$ (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1)))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/10YM@
;;;01/08/10YM@					(setq #ipt1 (nth 3 #Apt$))
;;;01/08/10YM@					(setq #v (list (- (car (nth 1 #Apt$)) (car (nth 2 #Apt$)))
;;;01/08/10YM@												 (- (cadr (nth 1 #Apt$)) (cadr (nth 2 #Apt$)))))
;;;01/08/10YM@					(setq #ipt1 (list (+ (car #v) (car #ipt1)) (+ (cadr #v) (cadr #ipt1))))
;;;01/08/10YM@
;;;01/08/10YM@
;;;01/08/10YM@					(setq #v (list (- (car (nth 5 #Apt$)) (car (nth 6 #Apt$)))
;;;01/08/10YM@												 (- (cadr (nth 5 #Apt$)) (cadr (nth 6 #Apt$)))))
;;;01/08/10YM@					(setq #ipt2 (list (+ (car #v) (car (nth 7 #Apt$))) (+ (cadr #v) (cadr (nth 7 #Apt$)))))
;;;01/08/10YM@
;;;01/08/10YM@
;;;01/08/10YM@					(setq #ret$ '())
;;;01/08/10YM@
;;;01/08/10YM@					; I 型-1について 4 頂点を求める
;;;01/08/10YM@					(setq #pt1 (nth 0 #Apt$)
;;;01/08/10YM@								#pt2 (nth 1 #Apt$)
;;;01/08/10YM@								#pt3 (nth 2 #Apt$))
;;;01/08/10YM@
;;;01/08/10YM@					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/08/10YM@					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/08/10YM@					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/08/10YM@
;;;01/08/10YM@					; I 型-2について 4 頂点を求める
;;;01/08/10YM@					(setq #pt1 (nth 7 #Apt$)
;;;01/08/10YM@								#pt2 (nth 0 #Apt$)
;;;01/08/10YM@								#pt3 #ipt1)
;;;01/08/10YM@
;;;01/08/10YM@					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/08/10YM@					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/08/10YM@					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/08/10YM@
;;;01/08/10YM@					; I 型-3について 4 頂点を求める
;;;01/08/10YM@					(setq #pt1 (nth 6 #Apt$)
;;;01/08/10YM@								#pt2 (nth 7 #Apt$)
;;;01/08/10YM@								#pt3 #ipt2)
;;;01/08/10YM@
;;;01/08/10YM@					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/08/10YM@					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/08/10YM@					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/08/10YM@
;;;01/08/10YM@  ;  ((I 型-1 ) (I 型-2 ) (I 型-3 ))
;;;01/08/10YM@  ;
;;;01/08/10YM@  ;                        #ipt1
;;;01/08/10YM@  ; (nth 0 #Apt$)    ----------------------------    (nth 1 #Apt$)
;;;01/08/10YM@  ;                 |           I 型-1           |
;;;01/08/10YM@  ;                 |      ----------------------    (nth 2 #Apt$)
;;;01/08/10YM@  ;                 | I 型 |
;;;01/08/10YM@  ;                 |   |  |
;;;01/08/10YM@  ;                 |   2  |
;;;01/08/10YM@  ;          #ipt2  |      ----------------------    (nth 5 #Apt$)
;;;01/08/10YM@  ;                 |           I 型-3           |
;;;01/08/10YM@  ; (nth 7 #Apt$)   -----------------------------   (nth 6 #Apt$)
;;;01/08/10YM@  ;
;;;01/08/10YM@
;;;01/08/10YM@
;;;01/08/10YM@        )
;;;01/08/10YM@        (progn
;;;01/08/10YM@					; ワークトップ数 1 <
;;;01/08/10YM@					; 外形点列の取得
;;;01/08/10YM@					; 01/07/03 TM MOD テスト
;;;01/08/10YM@					(setq #Apt$ (KCFWTSStoPlPt #ed$))
;;;01/08/10YM@					; 01/07/03 TM MOD-S 旧データ対応
;;;01/08/10YM@					(if (not #Apt$)
;;;01/08/10YM@						(setq #Apt$ (PK_WTSStoPlPt (En$2Ss #en$)))
;;;01/08/10YM@					)
;;;01/08/10YM@					; 01/07/03 TM MOD-E 旧データ対応
;;;01/08/10YM@
;;;01/08/10YM@					; 右端のワークトップの点列 コーナーから右周り
;;;01/08/10YM@					(setq #pt$ (GetPtSeries (nth 32 #ed$) (cdr (PKGetWT_outPT &en 1)))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/10YM@					; U型右端を含んで1枚のI型とみなした時のコーナー原点
;;;01/08/10YM@					(setq #cpt1 (#GetCpt #pt$ nil nil))
;;;01/08/10YM@					; 01/08/08 TM ADD-S 配置が歪んでいる場合、現在の関数では点が取得できない
;;;01/08/10YM@					(if (not #cpt1)
;;;01/08/10YM@						(progn
;;;01/08/10YM@							(setq #cpt1 (#GetCpt #pt$ nil CG_KCFDIV_ANG_EPS))
;;;01/08/10YM@							(if #cpt1
;;;01/08/10YM@								(progn
;;;01/08/10YM@									(CFAlertMsg "キャビネットの領域形状が特殊です。\n展開図作成を続行しますが、寸法表示が不正になる可能性があります。")
;;;01/08/10YM@								)
;;;01/08/10YM@								(progn
;;;01/08/10YM@									(CFAlertMsg "キャビネットの領域形状が特殊です。\n展開図作成を続行できません。")
;;;01/08/10YM@									(quit)
;;;01/08/10YM@								)
;;;01/08/10YM@							)
;;;01/08/10YM@						)
;;;01/08/10YM@					)
;;;01/08/10YM@					; 01/08/08 TM ADD-E 配置が歪んでいる場合、現在の関数では点が取得できない
;;;01/08/10YM@
;;;01/08/10YM@					(setq #enL (last #en$))
;;;01/08/10YM@					; 右端のワークトップの拡張データ取得
;;;01/08/10YM@					(setq #edL$ (CfGetXData #enL "G_WRKT"))
;;;01/08/10YM@						; 左端のワークトップの点列
;;;01/08/10YM@					(setq #pt2$ (GetPtSeries (nth 32 #edL$) (cdr (PKGetWT_outPT #enL 1)))) ; 01/08/10 YM ADD(引数追加)
;;;01/08/10YM@					; U型左端を含んで1枚のI型とみなした時のコーナー原点
;;;01/08/10YM@					(setq #cpt2 (#GetCpt #pt2$ T nil))
;;;01/08/10YM@					; 01/08/08 TM ADD-S 配置が歪んでいる場合、現在の関数では点が取得できない
;;;01/08/10YM@					(if (not #cpt2)
;;;01/08/10YM@						(progn
;;;01/08/10YM@							(setq #cpt2 (#GetCpt #pt$ T CG_KCFDIV_ANG_EPS))
;;;01/08/10YM@							(princ "\nキャビネットの配置角度が特殊です。")
;;;01/08/10YM@							(if #cpt2
;;;01/08/10YM@								(progn
;;;01/08/10YM@									(CFAlertMsg "キャビネットの領域形状が特殊です。\n展開図作成を続行しますが、寸法表示が不正になる可能性があります。")
;;;01/08/10YM@								)
;;;01/08/10YM@								(progn
;;;01/08/10YM@									(CFAlertMsg "キャビネットの領域形状が特殊です。\n展開図作成を続行できません。")
;;;01/08/10YM@									(quit)
;;;01/08/10YM@								)
;;;01/08/10YM@							)
;;;01/08/10YM@						)
;;;01/08/10YM@					)
;;;01/08/10YM@					; 01/08/08 TM ADD-E 配置が歪んでいる場合、現在の関数では点が取得できない
;;;01/08/10YM@
;;;01/08/10YM@					(setq #enL (last #en$))
;;;01/08/10YM@
;;;01/08/10YM@					; last と last2を求める
;;;01/08/10YM@					(setq #ipt1 (nth 3 (GetPtSeries #cpt1 (cdr #Apt$))))
;;;01/08/10YM@					(setq #v (list (- (car (nth 1 #pt$)) (car (nth 2 #pt$)))
;;;01/08/10YM@												 (- (cadr (nth 1 #pt$)) (cadr (nth 2 #pt$)))))
;;;01/08/10YM@					(setq #ipt1 (list (+ (car #v) (car #ipt1)) (+ (cadr #v) (cadr #ipt1))))
;;;01/08/10YM@
;;;01/08/10YM@					(setq #lpt2 (car (reverse #pt2$)))
;;;01/08/10YM@					(setq #spt (car #pt2$))
;;;01/08/10YM@					(setq #v (list (- (car #lpt2) (car #spt)) (- (cadr #lpt2) (cadr #spt))))
;;;01/08/10YM@					(setq #ipt2 (list (+ (car #v) (car #cpt2)) (+ (cadr #v) (cadr #cpt2))))
;;;01/08/10YM@
;;;01/08/10YM@  ;  ((I 型-1 ) (I 型-2 ) (I 型-3 ))
;;;01/08/10YM@  ;
;;;01/08/10YM@  ;                   #ipt1
;;;01/08/10YM@  ;     #cpt1   ----------------------------    (nth 1 #pt$)
;;;01/08/10YM@  ;            |           I 型-1           |
;;;01/08/10YM@  ;            |      ----------------------    (nth 2 #pt$)
;;;01/08/10YM@  ;            | I 型 |
;;;01/08/10YM@  ;            |   |  |
;;;01/08/10YM@  ;            |   2  |
;;;01/08/10YM@  ;     #ipt2  |      ----------------------    (nth 1 #pt2$)
;;;01/08/10YM@  ;            |           I 型-3           |
;;;01/08/10YM@  ;     #cpt2   -----------------------------   (nth 0 #pt2$)
;;;01/08/10YM@  ;
;;;01/08/10YM@
;;;01/08/10YM@
;;;01/08/10YM@					(setq #ret$ '())
;;;01/08/10YM@					; I 型-1について 4 頂点を求める
;;;01/08/10YM@					(setq #pt1 #cpt1
;;;01/08/10YM@								#pt2 (nth 1 #pt$)
;;;01/08/10YM@								#pt3 (nth 2 #pt$))
;;;01/08/10YM@
;;;01/08/10YM@					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/08/10YM@					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/08/10YM@					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/08/10YM@
;;;01/08/10YM@
;;;01/08/10YM@					; I 型-2について 4 頂点を求める
;;;01/08/10YM@					(setq #pt1 #cpt2
;;;01/08/10YM@								#pt2 #cpt1
;;;01/08/10YM@								#pt3 #ipt1)
;;;01/08/10YM@
;;;01/08/10YM@					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/08/10YM@					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/08/10YM@					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/08/10YM@
;;;01/08/10YM@					; I 型-3について 4 頂点を求める
;;;01/08/10YM@					(setq #pt1 (nth 0 #pt2$)
;;;01/08/10YM@								#pt2 #cpt2
;;;01/08/10YM@								#pt3 #ipt2)
;;;01/08/10YM@
;;;01/08/10YM@					(setq #v (list (- (car #pt3) (car #pt2)) (- (cadr #pt3) (cadr #pt2))))
;;;01/08/10YM@					(setq #pt4 (list (+ (car #pt1) (car #v)) (+ (cadr #pt1) (cadr #v))))
;;;01/08/10YM@					(setq #ret$ (append #ret$ (list (list #pt1 #pt2 #pt3 #pt4 #pt1))))
;;;01/08/10YM@
;;;01/08/10YM@        )
;;;01/08/10YM@      )
;;;01/08/10YM@    )
;;;01/08/10YM@  )
;;;01/08/10YM@  #ret$
;;;01/08/10YM@) ; GetWorkTopArea2

;<HOM>*************************************************************************
; <関数名>    : KCFWTSStoPlPt
; <処理概要>  : ワークトップ拡張データから、ワークトップ外形の点列を返す
; <戻り値>    : 外形点列(末尾に始点を追加)
; <作成>      : 01/07/03 TM ADD
; <備考>      : 拡張データはワークトップ図形右端のものであること
;*************************************************************************>MOH<
(defun KCFWTSStoPlPt (
	&ed$  ; ワークトップ拡張図形
	/
	#nPts
	#dPt$
	#nII
	)
;2012/06/08 YM MOD 参照先を変更した(U型のとき段差部分も含めたWT外形がおかしくなる)
;[60]:段差部分も含めたWT外形PLINEﾊﾝﾄﾞﾙ             (1005 . E5C3)
;↓
;[39]:WT底面図形ハンドル   WT押し出し用ﾎﾟﾘﾗｲﾝ      (1005 . E5B1)
;(setq #no 59);2012/06/08 YM MOD
(setq #no 38);2012/06/08 YM MOD

	; 01/07/04 YM MOD "G_WRKT" Xdata変更による修正 STRAT
	(if (and (nth #no &ed$) (/= (nth #no &ed$) "")); 新型"G_WRKT"[60]WT外形あり 01/07/04 YM MOD
		(progn
			(setq #dPt$ (GetLWPolyLinePt (nth #no &ed$))); 段差部も含んだWT外形領域
			(setq #dPt$ (AddPtList #dPt$))              ; 末尾に始点を追加する
		)
		(setq #dPt$ nil)
	);_if
	; 01/07/04 YM MOD "G_WRKT" Xdata変更による修正 END

;;;01/07/04YM@	; 点の数
;;;01/07/04YM@  (setq #nPts (nth 59 &ed$))
;;;01/07/04YM@	(if (< 0 #nPts)
;;;01/07/04YM@		(progn
;;;01/07/04YM@			(setq #nII 60)
;;;01/07/04YM@ 			(setq #dPt$ (list (nth #nII &ed$)))
;;;01/07/04YM@			(repeat (1- #nPts)
;;;01/07/04YM@				(setq #nII (1+ #nII))
;;;01/07/04YM@				(setq #dPt$	(append #dPt$ (list (nth #nII &ed$))))
;;;01/07/04YM@  		)
;;;01/07/04YM@		)
;;;01/07/04YM@	)
;;;01/07/04YM@	(setq #dPt$ (append #dPt$ (list (car #dPt$))))

);KCFWTSStoPlPt

;<HOM>*************************************************************************
; <関数名>    : PKDelWkTopONE
;; 2000/07/06 HT DEL 未使用 START
;;<HOM>*************************************************************************
;; <関数名>    : GetRyoikiIgata
;; <処理概要>  : ワークトップ図形名から領域を獲得する
;; <戻り値>    : 領域座標リスト
;; <作成>      : 99/12/17
;; <備考>      :
;;*************************************************************************>MOH<
;;(defun GetRyoikiIgata (
;;  &en         ;(ENAME)ワークトップ図形名
;;  /
;;  #eed$ #sEn1 #sEn2 #bpt1 #spt1$ #spt2$ #ang #ang_t #pt$ #pt_n$ #pt #minmax #rect$
;;  )
;;  ;拡張データ獲得
;;  (setq #eed$ (CfGetXData &en "G_WRKT"))
;;  ;サイド図形獲得
;;  (setq #sEn1 (nth 28 #eed$))
;;  (setq #sEn2 (nth 29 #eed$))
;;  ;コーナー基点獲得
;;  (setq #bpt1 (nth 32 #eed$))
;;  ;サイド図形の座標獲得
;;  (setq #spt1$ (GetSidePtList #sEn1))
;;  (setq #spt2$ (GetSidePtList #sEn2))
;;  (if (= "R" (nth 30 #eed$))
;;    (setq #ang   (Angle0to360       (nth 33 #eed$) ))
;;    (setq #ang   (Angle0to360 (+ PI (nth 33 #eed$))))
;;  )
;;  (setq #ang_t (Angle0to360 (- 0.0 #ang)))
;;  (setq #pt$ (append #spt1$ #spt2$))
;;  (setq #pt_n$
;;    (mapcar
;;     '(lambda ( #pt )
;;        (pt1jiHenkan #pt #ang_t)
;;      )
;;      #pt$
;;    )
;;  )
;;  ;領域獲得
;;  (setq #minmax (GetPtMinMax #pt_n$))
;;  ;４点に変換
;;  (setq #rect$
;;    (list
;;      (list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
;;      (list (car (cadr #minmax)) (cadr (cadr #minmax)) 0.0)
;;      (list (car (cadr #minmax)) (cadr (car  #minmax)) 0.0)
;;      (list (car (car  #minmax)) (cadr (car  #minmax)) 0.0)
;;      (list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
;;    )
;;  )
;;
;;  ;座標を元に戻す
;;  (mapcar
;;   '(lambda ( #pt )
;;      (pt1jiHenkan #pt #ang)
;;    )
;;    #rect$
;;  )
;;) ; GetRyoikiIgata
;; 2000/07/06 HT DEL 未使用 END


;; 2000/07/06 HT DEL 未使用 START
;;;<HOM>*************************************************************************
;;; <関数名>    : GetAreaWrktL
;;; <処理概要>  : ワークトップ図形名から領域を獲得する（L型）
;;; <戻り値>    : 領域座標リスト
;;; <作成>      : 99/12/18
;;; <備考>      :
;;;*************************************************************************>MOH<
;;(defun GetAreaWrktL (
;;  &en         ; 図形名
;;  /
;;  ##GetWtAreaTmp ##UnionArea #eed$ #Bpt #pt1$ #bpt #cpt #pt2$ #flg #pt$
;;  )
;;  ;仮に領域を作成
;;  (defun ##GetWtAreaTmp (
;;    &bpt        ; 基点
;;    &ang1       ; 角度
;;    &sen        ; サイド図形名
;;    /
;;    #eed$ #dis1 #dis2 #pt2 #spt$ #ang2 #pt3 #pt4 #ang1
;;    )
;;    (setq #eed$ (CfGetXData &sen "G_SIDE"))
;;    (setq #dis1 (nth 3 #eed$))
;;    (setq #dis2 (nth 1 #eed$))
;;    (setq #pt2 (polar &bpt       &ang1  #dis1))
;;    (setq #spt$ (GetSidePtList &sen))
;;    (if (equal 0.0 (distance (car #spt$) #pt2) 0.0001)
;;      (setq #ang2 (angle (car  #spt$) (cadr #spt$)))
;;      (setq #ang2 (angle (cadr #spt$) (car  #spt$)))
;;    )
;;    (setq #pt3 (polar #pt2       #ang2  #dis2))
;;    (setq #pt4 (polar #pt3 (+ PI &ang1) #dis1))
;;
;;    (list &bpt #pt2 #pt3 #pt4)
;;  )
;;  ;仮に作った領域を繋げる
;;  (defun ##UnionArea (
;;    &pt1$       ; ４点座標１
;;    &pt2$       ; ４点座標２
;;    /
;;    #dis #pt4 #pt$
;;    )
;;    ;伸縮長さ獲得
;;    (setq #dis (distance (nth 1 &pt2$) (nth 2 &pt2$)))
;;    ;座標算出
;;    (setq #pt4 (polar (nth 3 &pt1$) (angle (nth 3 &pt1$)(nth 2 &pt1$)) #dis))
;;    ;座標編集
;;    (setq #pt$
;;      (list
;;        (nth 0 &pt1$)
;;        (nth 1 &pt1$)
;;        (nth 2 &pt1$)
;;        #pt4
;;        (nth 2 &pt2$)
;;        (nth 1 &pt2$)
;;        (nth 0 &pt2$)
;;      )
;;    )
;;    #pt$
;;  )
;;  (setq #eed$ (CfGetXData &en "G_WRKT"))
;;  (setq #Bpt (nth 32 #eed$))
;;  (if (and (/= 0 (nth 3 #eed$)) (= 'ENAME (type (nth 35 #eed$))))
;;    (progn
;;      ; 2000/06/06 土屋  WTタイプ シンクガス 一体型 = (0 or -999)対応
;;      (if (or (= 0 (nth 5 #eed$)) (= -999 (nth 5 #eed$)))
;;        (progn
;;          (setq #pt1$ (##GetWtAreaTmp #bpt (nth 33 #eed$) (nth 28 #eed$)))
;;          (if (= 2 (nth 7 #eed$))
;;            (setq #cpt (polar #Bpt (nth 33 #eed$) (nth 31 #eed$)))
;;          )
;;          (setq #eed$ (CfGetXData (nth 35 #eed$) "G_WRKT"))
;;          (if (= 2 (nth 7 #eed$))
;;            (setq #cpt (polar #Bpt (nth 34 #eed$) (nth 31 #eed$)))
;;          )
;;          (setq #pt2$ (##GetWtAreaTmp #bpt (nth 34 #eed$) (nth 28 #eed$)))
;;        )
;;        (progn
;;          (setq #pt1$ (##GetWtAreaTmp #bpt (nth 34 #eed$) (nth 28 #eed$)))
;;          (if (= 2 (nth 7 #eed$))
;;            (setq #cpt (polar #Bpt (nth 34 #eed$) (nth 31 #eed$)))
;;          )
;;          (setq #eed$ (CfGetXData (nth 35 #eed$) "G_WRKT"))
;;          (setq #pt2$ (##GetWtAreaTmp #bpt (nth 33 #eed$) (nth 28 #eed$)))
;;          (if (= 2 (nth 7 #eed$))
;;            (setq #cpt (polar #Bpt (nth 33 #eed$) (nth 31 #eed$)))
;;          )
;;          (setq #flg T)
;;        )
;;      )
;;    )
;;    (progn
;;      (setq #pt1$ (##GetWtAreaTmp #bpt (nth 33 #eed$) (nth 28 #eed$)))
;;      (setq #pt2$ (##GetWtAreaTmp #bpt (nth 34 #eed$) (nth 29 #eed$)))
;;    )
;;  )
;;  (setq #pt$ (##UnionArea #pt1$ #pt2$))
;;  (if (/= nil #flg)
;;    (setq #pt$ (reverse #pt$))
;;  )
;;
;;  (list #pt$ #cpt)
;;)
;; 2000/07/06 HT DEL 未使用 END

; 旧型WT"G_SIDE"用の関数で現在未使用のためｺﾒﾝﾄ 01/07/23 YM DEL ↓
;;;01/07/23YM@;<HOM>*************************************************************************
;;;01/07/23YM@; <関数名>    : GetSidePtList
;;;01/07/23YM@; <処理概要>  : ワークトップ側面図形の座標を獲得
;;;01/07/23YM@; <戻り値>    : 座標リスト
;;;01/07/23YM@; <作成>      : 99/12/18
;;;01/07/23YM@; <備考>      : なし
;;;01/07/23YM@;*************************************************************************>MOH<
;;;01/07/23YM@(defun GetSidePtList (
;;;01/07/23YM@  &en         ; ワークトップ側面図形名
;;;01/07/23YM@  /
;;;01/07/23YM@  #pt$ #ang #tpt$ #bpt #pt
;;;01/07/23YM@  )
;;;01/07/23YM@  (setq #pt$ (3dto2d (mapcar 'car (get_allpt_h &en))))
;;;01/07/23YM@  (setq #ang (angle (car #pt$) (cadr #pt$)))
;;;01/07/23YM@  (setq #tpt$ (list (list 0.0 (car #pt$))))
;;;01/07/23YM@  (setq #bpt (car #pt$))
;;;01/07/23YM@  (mapcar
;;;01/07/23YM@   '(lambda ( #pt )
;;;01/07/23YM@      (if (equal #ang (angle #bpt #pt) 0.01)
;;;01/07/23YM@        (setq #tpt$ (cons (list       (distance #bpt #pt)  #pt) #tpt$))
;;;01/07/23YM@        (setq #tpt$ (cons (list (* -1 (distance #bpt #pt)) #pt) #tpt$))
;;;01/07/23YM@      )
;;;01/07/23YM@    )
;;;01/07/23YM@    (cdr #pt$)
;;;01/07/23YM@  )
;;;01/07/23YM@  (setq #tpt$ (mapcar 'cadr (SCFmg_sort$ 'car #tpt$)))
;;;01/07/23YM@
;;;01/07/23YM@  (list (car #tpt$) (last #tpt$))
;;;01/07/23YM@) ; GetSidePtList
; 旧型WT"G_SIDE"用の関数で現在未使用のためｺﾒﾝﾄ 01/07/23 YM DEL ↑

;<HOM>*************************************************************************
; <関数名>    : AddSideToDummyArea
; <処理概要>  : サイドパネル編集
; <戻り値>    : なし
; <備考>      : なし
; <作成>      : 00/02/12
;*************************************************************************>MOH<
(defun AddSideToDummyArea (
	&en$        ; ダミーエリアの図形名リスト
	/
	#ss #i #en #code #side$ #dum #ed$ #den$ #han #kpt$ #pt0 #pt1 #pt2
	#dpt #pt_t$ #pt #pt$ #side #spt$ #dpt$ #cnt #ed_n$
	)
	(setq #ss (ssget "X" (list (list -3 (list "G_LSYM")))))
	(if (/= nil #ss)
		(progn
			;サイドパネル獲得
			; 性格CODE 部材種類=サイドパネルのもののみ取得する
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #code (CfGetSymSKKCode #en 1))
				(if (= CG_SKK_ONE_SID #code)
					(setq #side$ (cons #en #side$))
				)
				(setq #i (1+ #i))
			)
			; ダミーエリアの編集
			; ダミーエリアのうちキッチンとダイニングのエリア順にソートを行う
			(mapcar
			 '(lambda ( #dum )
					(setq #ed$ (CfGetXData #dum "G_SKDM"))
					(setq #den$ (cons (list (nth 0 #ed$) #dum) #den$))
				)
				&en$
			)
			(setq #den$ (mapcar 'cadr (reverse (SCFmg_sort$ 'car #den$))))
			;サイドパネルの構成座標群を獲得
			;
			;   #pt0 |----------| #pt1
			;        |          |
			;        |          |
			;   #pt2 |----------| #dpt
			;
			(mapcar
			 '(lambda ( #en )
					;ハンドル
					(setq #han (cdr (assoc 5 (entget #en))))
					;構成座標獲得
					(setq #kpt$ (GetSym4Pt #en))
					(setq #pt0  (nth 0 #kpt$))
					(setq #pt1  (nth 1 #kpt$))
					(setq #pt2  (nth 2 #kpt$))
					(setq #dpt (polar #pt1 (angle #pt0 #pt2) (distance #pt0 #pt2)))
					;座標リストをZ座標を0.0にする
					(setq #pt_t$
						(mapcar
						 '(lambda ( #pt )
								(list (car #pt) (cadr #pt) 0.0)
							)
							(list #pt0 #pt1 #dpt #pt2 #pt0)
						)
					)
					;ハンドル 座標リスト
					(setq #pt$ (cons (list #han #pt_t$) #pt$))
				)
				#side$
			)


			;判断
			(mapcar
			 '(lambda ( #side )
					; サイドパネルのハンドル
					(setq #han  (car  #side))
					; サイドパネルの領域頂点
					(setq #spt$ (cadr #side))
					;ダミー領域
					(mapcar
					 '(lambda ( #en )
							; ダミー領域(LWPOLYLINE)の頂点座標取得
							(setq #dpt$ (mapcar 'car (get_allpt_h #en)))
							(setq #dpt$ (PtSort #dpt$ (angtof "5") T))
							;内外判定
							; サイドパネルの領域内にダミー領域の頂点があるかどうか
							(setq #cnt 0)
							(mapcar
							 '(lambda ( #pt )
									(if (JudgeNaigai #pt #spt$)
										(setq #cnt (1+ #cnt))
									)
								)
								#dpt$
							)
							; サイドパネルの領域内にダミー領域の頂点が1つ以上ある時
							(if (< 0 #cnt)
								(progn
									;カウント
									(if (/= nil #han)
										(progn
											(setq #ed$ (CfGetXData #en "G_SKDM"))
											(if (not (member (handent #han) #ed$))
												(progn
													; サイドパネルの図形名がまだ、付加されてされていない時
													; 付け加える
													(setq #ed_n$ (append #ed$ (list (handent #han))))
													(CfSetXData #en "G_SKDM" #ed_n$)
													(setq #han nil)
												)
											)
										)
									)
								)
							)
						)
						#den$
					)
				)
				#pt$
			)
		)
	)

	(princ)
) ; AddSideToDummyArea


;<HOM>*************************************************************************
; <関数名>    : AddRangeHoodToDummyArea
; <処理概要>  : 
; <戻り値>    : なし
; <備考>      : なし
; <作成>      : 09/04/17
;*************************************************************************>MOH<
(defun AddRangeHoodToDummyArea (
	&en$        ; ダミーエリアの図形名リスト
	/
	#ss #i #en #code #range$ #dum #ed$ #den$ #han #kpt$ #pt0 #pt1 #pt2
	#dpt #pt_t$ #pt #pt$ #side #spt$ #dpt$ #cnt #ed_n$
	#kden$
	)
	(setq #ss (ssget "X" (list (list -3 (list "G_LSYM")))))
	(if (/= nil #ss)
		(progn
			;レンジフード獲得
			; 性格CODE 部材種類=レンジフードの"G_SKDM"が設定されていないもののみ取得する
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #code (CfGetSymSKKCode #en 1))
				(if (and (= CG_SKK_ONE_RNG #code) (not (CfGetXData #en "G_SKDM")))
					(setq #range$ (cons #en #range$))
				)
				(setq #i (1+ #i))
			)
			(setq #kden$ nil)
			(foreach #en &en$
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				(if (= (car #ed$) "K")
					(setq #kden$ (cons #en #kden$))
				)
			)
			; ダミーエリアの編集
			; ダミーエリアのうちキッチンのエリア順にソートを行う
			(mapcar
			 '(lambda ( #dum )
					(setq #ed$ (CfGetXData #dum "G_SKDM"))
					(setq #den$ (cons (list (nth 0 #ed$) #dum) #den$))
				)
				#kden$
			)
			(setq #den$ (mapcar 'cadr (reverse (SCFmg_sort$ 'car #den$))))
			;レンジフードの構成座標群を獲得
			;
			;   #pt0 |----------| #pt1
			;        |          |
			;        |          |
			;   #pt2 |----------| #dpt
			;
			(mapcar
			 '(lambda ( #en )
					;ハンドル
					(setq #han (cdr (assoc 5 (entget #en))))
					;構成座標獲得
					(setq #kpt$ (GetSym4Pt #en))
					(setq #pt0  (nth 0 #kpt$))
					(setq #pt1  (nth 1 #kpt$))
					(setq #pt2  (nth 2 #kpt$))
					(setq #dpt (polar #pt1 (angle #pt0 #pt2) (distance #pt0 #pt2)))
					;座標リストをZ座標を0.0にする
					(setq #pt_t$
						(mapcar
						 '(lambda ( #pt )
								(list (car #pt) (cadr #pt) 0.0)
							)
							(list #pt0 #pt1 #dpt #pt2 #pt0)
						)
					)
					;ハンドル 座標リスト
					(setq #pt$ (cons (list #han #pt_t$) #pt$))
				)
				#range$
			)


			;判断
			(mapcar
			 '(lambda ( #range )
					; レンジフードのハンドル
					(setq #han  (car  #range))
					; レンジフードの領域頂点
					(setq #spt$ (cadr #range))
					;ダミー領域
					(mapcar
					 '(lambda ( #en )
							; ダミー領域(LWPOLYLINE)の頂点座標取得
							(setq #dpt$ (mapcar 'car (get_allpt_h #en)))
							(setq #dpt$ (PtSort #dpt$ (angtof "5") T))
							;内外判定
							; サイドパネルの領域内にダミー領域の頂点があるかどうか
							(setq #cnt 0)
							(mapcar
							 '(lambda ( #pt )
									(if (JudgeNaigai #pt #spt$)
										(setq #cnt (1+ #cnt))
									)
								)
								#dpt$
							)
							; レンジフードの領域内にダミー領域の頂点が1つ以上ある時
							(if (< 0 #cnt)
								(progn
									;カウント
									(if (/= nil #han)
										(progn
											(setq #ed$ (CfGetXData #en "G_SKDM"))
											(if (not (member (handent #han) #ed$))
												(progn
													; レンジフードの図形名がまだ、付加されてされていない時
													; 付け加える
													(setq #ed_n$ (append #ed$ (list (handent #han))))
													(CfSetXData #en "G_SKDM" #ed_n$)
													(setq #han nil)
												)
											)
										)
									)
								)
							)
						)
						#den$
					)
				)
				#pt$
			)
		)
	)

	(princ)
) ; AddRangeHoodToDummyArea

;<HOM>*************************************************************************
; <関数名>    : SCFEnINRyoiki
; <処理概要>  : シンボル図形が領域にはいっているかどうか判定する
; <戻り値>    : 領域点列
; <備考>      :
; <作成>      : 00/09/25
;*************************************************************************>MOH<
(defun SCFEnINRyoiki (
	&eEn        ; シンボル図形名
	&ryoiki$    ; 領域
	/
	#10$ #ii #en
	)

	;構成座標を獲得
	(setq #10$ (GetSym4Pt &eEn))
	(setq #ii 0)
	(setq #flg nil)
	(mapcar
		'(lambda ( #10 )
			 (setq #10 (list (car #10) (cadr #10) 0.0))
			 (if (JudgeNaigai #10 &ryoiki$)
				 (progn
				 	(setq #flg T)
				 )
			 );_if
			 (setq #ii (1+ #ii))
		)
			(list (nth 0 #10$)(nth 1 #10$)(nth 2 #10$))
		)
		(if (= #flg T)
			(progn
				(setq #4pt$ (GetMinMaxAng (append #10$ &ryoiki$) (angle (nth 0 &ryoiki$) (nth 1 &ryoiki$))))
				(setq #Ret (append #4pt$ (list (car #4pt$))))
			)
			(progn
				(setq #Ret &ryoiki$)
			)
		);_if
	#Ret
);SCFEnINRyoiki

;<HOM>*************************************************************************
; <関数名>    : GetAreaAgain
; <処理概要>  : ワークトップ領域の再獲得
; <戻り値>    : （図形名リスト ワークトップ領域 システム座標）
; <備考>      :
; <作成>      : 00/03/23
;*************************************************************************>MOH<
(defun GetAreaAgain (
	&wpt$ ; ワークトップ領域
	&dpt$ ; ダミーポイント
	&ss   ; シンボル図形選択エンティティ
	&flg  ; ワークトップ形状タイプ２（"F"：フラット "S"：ステップ）
	/
	#i #en #10$ #flg #10 #enw$ #code #sink #base$ #ret$ #enr$ #ena$ #ang #ang$ #ang1
	#ang2 #dpt$ #path #ap$ #npt$$ #npt$ #npt #no #dis #4pt$ #dum #3 #4 #wpt$ #pt1$ #pt2$ #pt4
	)
	;まずワークトップ領域内のシンボル図形を得
	(if (= CG_UTypeWT nil)
		(progn
			(setq #i 0)
			(repeat (sslength &ss)
				(setq #en (ssname &ss #i))
				;構成座標獲得
				; カウンターの奥行きが狭いと入らない商品があるので、チェックする領域の奥行きを半分に変更
				(setq #10$ (GetSym4PtDHelf #en))
;	      (setq #10$ (GetSym4Pt #en))
				(setq #flg T)
				(mapcar
				 '(lambda ( #10 )
						(setq #10 (list (car #10) (cadr #10) 0.0))
						(if (and (not (JudgeNaigai #10 &wpt$))(not (JudgeNaigai #10 (reverse &wpt$))))
							(setq #flg nil)
						)
					)
					(list (nth 0 #10$) (nth 1 #10$) (nth 2 #10$))
				)
				(if (/= nil #flg)
					(setq #enw$ (cons #en #enw$))
				);_if
				(setq #i (1+ #i))
			);repeat
		)
		(progn
			; U型の時
			(setq #i 0 #eCnt nil)
			(repeat (sslength &ss)
				(setq #Code$ (CfGetSymSKKCode (ssname &ss #i) nil))
				(if (and (= CG_SKK_ONE_CNT (nth 0 #Code$)) (/= CG_SKK_TWO_BAS (nth 1 #Code$)))
					(progn
							(setq #eCnt (ssname &ss #i))
							)
				)
				(setq #i (1+ #i))
			)
			(if #eCnt
				(setq #wpt$ (3DTo2D (SCFEnINRyoiki #eCnt &wpt$)))
				(setq #wpt$ &wpt$)
			)

			(setq #i 0)
			(repeat (sslength &ss)
				(setq #en (ssname &ss #i))
				;構成座標獲得
				(setq #10 (cdr (assoc 10 (entget #en))))
				(setq #10 (list (car #10) (cadr #10)))
				; (if (or (JudgeNaigai #10 &wpt$)(JudgeNaigai #10 (reverse &wpt$)))
				(if (or (JudgeNaigai #10 #wpt$)(JudgeNaigai #10 (reverse #wpt$)))
					(setq #enw$ (cons #en #enw$))
				)
				(setq #i (1+ #i))
			)
		)
	);_if

	(if (/= CG_UTypeWT nil)
		(progn
			; U型の時
			(setq #enw$ (Ss2En$ (En$2Ss #enw$)))
			; (setq #ret$ (list #enw$ &wpt$ &dpt$)) 2000/09/20
			(setq #ret$ (list #enw$ (3DTo2D #wpt$) (list (nth 0 #wpt$) (nth 1 #wpt$) (nth 2 #wpt$))))
		)
		(progn
			; U型以外の時
			;修正 00/04/05
			; (if (or (= "F" &flg) (= "W" &flg) (= "K" &flg))
			; 2000/07/21 ワークトップの形状タイプには、フラットと段差
			(if (= "F" &flg)
				(progn                 ;//フラット
					; フラットの時には、シンクキャビネットの属するベースキャビに隣接する
					; ベースキャビネットが取得できていない場合は取り込む処理をする

					;次にキャビネットの連結からシンボル図形を獲得
					;シンクキャビネット獲得
					(mapcar
					 '(lambda ( #en )
							(setq #code (CFGetSymSKKCode #en 3))
							(if (= CG_SKK_THR_SNK #code)
								(setq #sink #en)
							)
						)
						#enw$
					)

					; 01/04/30 HN S-ADD
					; シンクキャビネットが無い場合は、コーナーキャビネットを基準とする
					(if (= nil #sink)
						(mapcar
						 '(lambda ( #en )
								(setq #code (CFGetSymSKKCode #en 3))
								(if (= CG_SKK_THR_CNR #code)
									(setq #sink #en)
								)
							)
							#enw$
						)
					);_if
					; 01/04/30 HN S-ADD

					;連結情報から、シンボル図形を獲得
					(if (/= nil #sink)
						(progn
							(setq #base$ (SKW_GetLinkBaseCab #sink))
							; 2000/06/13
							(if #base$
								(progn
								(foreach #en #base$
									(setq #code (CFGetSymSKKCode #en nil))
									;// 冷蔵庫及びペニンシュラは除外する
									(if (not
												(and (= (car #skk$) 9) (= (cadr #skk$) 1) (= (caddr #skk$) 1)) ;冷蔵庫、ペニンシュラ
												 )
										(progn
										; 2000/07/25 ハイフロアキャビネットは除外
										; フロアキャビネットの上方向にキャビネットがある場合は除外
										(if (= nil (SCFTallBaseCab #code))
											(progn
											(if (= nil (SCFIsCabOnCab #en))
												(if (= nil (member #en #enw$))
													(setq #enw$ (append #enw$ (list #en)))
												)
											)
											)
										)
										) ; if
								 ) ; if
								 ) ; foreach
								 ;(foreach #en #base$
								 ;  (if (= nil (member #en #enw$))
								 ;    (setq #enw$ (append #enw$ (list #en)))
								 ;  )
								 ;)
								 ;@@@(setq #ret$ (list #base$ &wpt$ &dpt$))
								 (setq #enw$ (Ss2En$ (En$2Ss #enw$)))
								 (setq #ret$ (list #enw$ &wpt$ &dpt$))
								)
							) ; 2000/06/13
						)
					);_if
				)
				(progn                 ;//段差
					; 処理の概要は、
					; 段差の場合は、段差がある部分が取り込めていないので、角度や位置のつながりから
					; モデルの領域を拡張する(段差の領域まで広げる)

					;次にキャビネットの連結からシンボル図形を獲得
					;シンクキャビネット獲得
					(mapcar
					 '(lambda ( #en )
							(setq #code (CFGetSymSKKCode #en 3))
							(if (= CG_SKK_THR_SNK #code)
								(setq #sink #en)
							)
						)
						#enw$
					)
					;連結情報から、シンボル図形を獲得
					(if (/= nil #sink)
						(progn
							(setq #base$ (SKW_GetLinkBaseCab #sink))
							;獲得したシンボル図形のダイニングキャビネットを省く
							(mapcar
							 '(lambda ( #en )
									(setq #code (CFGetSymSKKCode #en 3))
									;--- 000331 Modify S.Kawamoto ---
									;--- 間口調整フィラーも除外 ---
									;(if (/= CG_SKK_THR_DIN #code)
									; 性格CODE3桁め ダイニングでもその他でもない時、取り込む
									; 性格CODE3桁め ダイニングかその他で、性格CODE1桁めサイドパネルでない時は取り込む
									(if (and (/= CG_SKK_THR_DIN #code) (/= CG_SKK_THR_ETC #code))
										(setq #enr$ (cons #en #enr$))
										(if (/= (CFGetSymSKKCode #en 1) CG_SKK_ONE_SID)
											(setq #enr$ (cons #en #enr$))
										)
									)
									;--- 000331 Modify S.Kawamoto ---
								)
								#base$
							)
							;ワークトップのほうでひっかからなかったシンボル図形を獲得
							(mapcar
							 '(lambda ( #en )
									(if (not (member #en #enw$))
										(setq #ena$ (cons #en #ena$))
									)
								)
								#enr$
							)
							;獲得したシンボル図形の２点（bpt wpt）と角度を獲得
							(setq #i 0)
							(mapcar
							 '(lambda ( #en )
									(setq #ang (nth 2 (CfGetXData #en "G_LSYM")))
									(setq #10$ (GetSym4Pt #en))
									(setq #ang$ (cons (list #ang (nth 0 #10$) (nth 1 #10$)) #ang$))
									(setq #i (1+ #i))
								)
								#ena$
							)
							;獲得した角度でまとめる
							(setq #ang$ (CollectAngle #ang$))
							;同一角度内で離れているオブジェクトを分ける
							(setq #ang$ (CollectPos   #ang$))
							;モデルの角度獲得
							(setq #ang1 (angle (nth 0 &dpt$) (nth 1 &dpt$)))
							(if (/= nil (nth 3 &dpt$))
								(setq #ang2 (angle (nth 0 &dpt$) (nth 3 &dpt$)))
							);_if
							;ここからはちょっと頭をひねる。
							(setq #dpt$ &dpt$)

							;
							;         ------------>  #ang1
							; dpt0 |----------| dpt1
							;      |          |
							;      |          |
							;  |   |     |----| dpt2
							;  |   |     |
							;  |   |     |
							;  |   |-----|
							;  V
							;  #ang2
							;


							; 一方の角度
							(if (/= nil #ang1)
								(progn
									(setq #path nil)
									(mapcar
									 '(lambda ( #ap$ )
											(if
												(or
													(equal (Angle0to360 (car #ap$)) (Angle0to360 #ang1) 0.01)
													(equal (Angle0to360 (car #ap$)) (Angle0to360 (+ PI #ang1)) 0.01)
												)
												(progn
													(setq #npt$$ (cons (cadr #ap$) #npt$$))
												)
											)
										)
										#ang$
									)
									(if (/= nil #npt$$)
										(progn
											(mapcar
											 '(lambda ( #npt$ )
													(if (= nil #npt)
														;0か1
														(cond
															((equal 0.0 (distance (car  #npt$) (nth 0 #dpt$)) 0.01)
																(setq #npt (cadr #npt$))
																(setq #no  0)
															)
															((equal 0.0 (distance (car  #npt$) (nth 1 #dpt$)) 0.01)
																(setq #npt (cadr #npt$))
																(setq #no  1)
															)
															((equal 0.0 (distance (cadr #npt$) (nth 0 #dpt$)) 0.01)
																(setq #npt (car #npt$))
																(setq #no  0)
															)
															((equal 0.0 (distance (cadr #npt$) (nth 1 #dpt$)) 0.01)
																(setq #npt (car #npt$))
																(setq #no  1)
															)
														)
													)
												)
												#npt$$
											)
											(if (/= nil #npt)
												(progn
													(setq #ang  (angle    (nth 1 #dpt$) (nth 2 #dpt$)))
													(setq #dis  (distance (nth 1 #dpt$) (nth 2 #dpt$)))
													(setq #npt  (polar #npt #ang #dis))
													(setq #dpt$ (ChangeList #dpt$ #no #npt))
													(setq #4pt$ (GetMinMaxAng #dpt$ #ang1))
													(setq #dpt$
														(append
															(list (nth 0 #4pt$) (nth 1 #4pt$) (nth 2 #4pt$))
															(cdr (cdr (cdr #dpt$)))
														)
													)
													(setq #path T)
												)
											)
										)
									)
								)
							);_if

							(if (/= nil #ang2)
								(progn
									(setq #path nil)
									(setq #npt$$ nil)
									(setq #npt  nil)
									(mapcar
									 '(lambda ( #ap$ )
											(if
												(or
				;;;-------- Modify S.Kawamoto 000331 ------
				;;;                    (equal (car #ap$) #ang2 0.01)
													(equal (Angle0to360 (car #ap$)) (Angle0to360 #ang2) 0.01)
													(equal (Angle0to360 (car #ap$)) (Angle0to360 (+ PI #ang2)) 0.01)
				;;;-------- Modify S.Kawamoto 000331 ------
												)
												(progn
													(setq #npt$$ (cons (cadr #ap$) #npt$$))
												)
											)
										)
										#ang$
									)
									(if (/= nil #npt$$)
										(progn
											(mapcar
											 '(lambda ( #npt$ )
													(if (= nil #npt)
														;3
														(cond
															((equal 0.0 (distance (car  #npt$) (nth 3 #dpt$)) 0.01)
																(setq #npt (cadr #npt$))
																(setq #no  3)
															)
															((equal 0.0 (distance (cadr #npt$) (nth 3 #dpt$)) 0.01)
																(setq #npt (car #npt$))
																(setq #no  4)
															)
														)
													)
												)
												#npt$$
											)
											(if (/= nil #npt)
												(progn
													(setq #dum #npt)
													(setq #ang  (angle    (nth 3 #dpt$) (nth 4 #dpt$)))
													(setq #dis  (distance (nth 3 #dpt$) (nth 4 #dpt$)))
													(setq #npt  (polar #npt #ang #dis))
													(setq #dpt$ (ChangeList #dpt$ #no #npt))
													(if (= 1 (SCFArea_Rl (nth 0 #dpt$) (nth 3 #dpt$) (nth 4 #dpt$)))
														(progn
															(setq #3 2)
															(setq #4 1)
														)
														(progn
															(setq #3 1)
															(setq #4 2)
														)
													)
				;                  (setq #4pt$ (GetMinMaxAng #dpt$ #ang2))
													(setq #dpt$
														(append
															(list (nth 0  #dpt$) (nth 1  #dpt$) (nth 2 #dpt$))
				;;;-------- Modify S.Kawamoto 000331 ---------
				;                      (list (nth #3 #4pt$) (nth #4 #4pt$))
															(list #dum #npt)
				;;;-------- Modify S.Kawamoto 000331 ---------
															(if (nth 5  #dpt$)
																(list (nth 5  #dpt$))
																(list (list 0 0))
															)
														)
													)
													(setq #path T)
												)
											)
										)
									)
								)
							);_if

							;全体の領域を獲得
							(if (= nil (nth 3 #dpt$))
								(progn
									(setq #wpt$ (GetMinMaxAng #dpt$ (angle (nth 0 #dpt$) (nth 1 #dpt$))))
									(setq #wpt$ (append #wpt$ (list (car #wpt$))))
									(setq #path T)
								)
								(progn
									(setq #pt1$ (GetMinMaxAng #dpt$ (angle (nth 0 #dpt$) (nth 1 #dpt$))))
									(setq #pt2$ (GetMinMaxAng #dpt$ (angle (nth 0 #dpt$) (nth 3 #dpt$))))
									;伸縮長さ獲得
									(setq #dis (distance (nth 1 #pt2$) (nth 2 #pt2$)))
									;座標算出
									(setq #pt4 (polar (nth 3 #pt1$) (angle (nth 3 #pt1$)(nth 2 #pt1$)) #dis))
;02/09/27 YM ADD-S
; L型段差左勝手裏にﾀﾞｲｲﾆﾝｸﾞのｹｰｽで #pt4=nil となることがあるので保存
;;;＜以下(障害プラン)はＮＧ＞
;;; +----------------------------------+
;;; |   ダイニング(対面,収納,配膳など) |
;;; |                                  |
;;; +----------------------------------+
;;; |                                  |
;;; |   天板(L型カットなし)            |
;;; |                                  |
;;; +--------------------------+       |
;;;                            |       |
;;;                            +-------+
;;;                            |  段差 |
;;;                            |  あり |
;;;                            |       |
;;;                            +-------+
(setq #pt4_OLD #pt4)
;02/09/27 YM ADD-S

									;座標編集
									(setq #wpt$
										(list
											(nth 0 #pt1$)(nth 1 #pt1$)(nth 2 #pt1$)
											#pt4
											(nth 2 #pt2$)(nth 1 #pt2$)(nth 0 #pt2$)
										)
									)
				;;;-------- Modify S.Kawamoto 000331 ---------
									(setq #pt4
										(inters
											(nth 2 #dpt$)
											(polar (nth 2 #dpt$) (angle (nth 0 #dpt$) (nth 1 #dpt$)) 10)
											(nth 4 #dpt$)
											(polar (nth 4 #dpt$) (angle (nth 0 #dpt$) (nth 3 #dpt$)) 10)
											nil
										)
									)

;02/09/27 YM ADD-S 応急処置
; L型段差左勝手裏にﾀﾞｲｲﾆﾝｸﾞのｹｰｽで #pt4=nil となることがある
(if (= #pt4 nil)
	(setq #pt4 #pt4_OLD)
);_if
;02/09/27 YM ADD-S


									(setq #wpt$
										(list
											(nth 0 #dpt$)(nth 1 #dpt$)(nth 2 #dpt$)
											#pt4
											(nth 4 #dpt$)(nth 3 #dpt$)(nth 0 #dpt$)
										)
									)
									(setq #path T)
				;;;-------- Modify S.Kawamoto 000331 ---------
								)
							);_if

							;ワークトップ領域内のシンボル図形を再獲得
							(setq #enw$ nil)
							(setq #i 0)
							(repeat (sslength &ss)
								(setq #en (ssname &ss #i))
								;構成座標獲得
								; カウンターの奥行きが狭いと入らない商品があるので、チェックする領域の奥行きを半分に変更
								(setq #10$ (GetSym4PtDHelf #en))
;					      (setq #10$ (GetSym4Pt #en))
								(setq #flg T)
								(mapcar
								 '(lambda ( #10 )
										(setq #10 (list (car #10) (cadr #10) 0.0))
										(if (and (not (JudgeNaigai #10 #wpt$)) (not (JudgeNaigai #10 (reverse #wpt$))))
											(setq #flg nil)
										)
									)
									(list (nth 0 #10$) (nth 1 #10$) (nth 2 #10$))
								)
								(if (/= nil #flg)
									(setq #enw$ (cons #en #enw$))
								)
								(setq #i (1+ #i))
							);repeat

							(setq #enw$ (Ss2En$ (En$2Ss #enw$)))
							(setq #ret$ (list #enw$ #wpt$ #dpt$))
						)
					) ; #sink if
				)
			);_if
		) ; progn
	) ; if
	#ret$
);GetAreaAgain

;<HOM>*************************************************************************
; <関数名>    : SCFIsCabOnCab
; <処理概要>  : フロアキャビネットの上下方向に接したキャビネットがあるかどうか判定
; <戻り値>    : キャビネットがある : T   ない : nil
; <備考>      : ワークトップを配置できるフロアキャビネットかどうかをみる
; <作成>      : 2000/07/25
;*************************************************************************>MOH<
(defun SCFIsCabOnCab (
	&en       ; 判定するフロアキャビネット
	/
	#ret      ; 返値
	#en$      ; 上下隣接or重複アイテム

)
 (setq #ret nil)
 ;あるアイテムの隣接図形名リスト検出
 (setq #en$ (PcGetEn$CrossArea &en 0 0 2 2 nil))
 (foreach #n #en$
		; 接しているアイテムが存在する場合
		(if (= 0 (PcChkZdirCross #n &en))
		 (setq #ret T)
		);_if
	)
	#ret
);SCFIsCabOnCab

;<HOM>*************************************************************************
; <関数名>    : SCFTallBaseCab
; <処理概要>  : ハイフロアキャビネットかどうか判定する
; <戻り値>    : ハイフロアキャビネット : T   not : nil
; <備考>      : ハイフロアキャビネットはワークトップを配置できないので収納とする
; <作成>      : 2000/07/25
;*************************************************************************>MOH<
(defun SCFTallBaseCab (
	&skkCode$       ; 判定する性格CODEリスト
	/
	#ret            ; 返り値
)
	; ハイフロアキャビネットの定義は性格CODE

	(if (and (= (nth 0 &skkCode$) CG_SKK_ONE_CAB)
					 (= (nth 1 &skkCode$) CG_SKK_TWO_BAS)
					 (= (nth 2 &skkCode$) CG_SKK_THR_DIN)
			)
			(setq #ret T)
			(setq #ret nil)
	)
	#ret
);SCFTallBaseCab

;<HOM>*************************************************************************
; <関数名>    : CollectPos
; <処理概要>  : 角度と座標リストで、座標リストの連鎖情報から
;               離れている座標を分ける
; <戻り値>    : 角度と座標リスト
; <備考>      :
; <作成>      : 00/04/10
;*************************************************************************>MOH<
(defun CollectPos (
	&ang$       ; 角度と座標リスト
	/
	#ap$ #pt_n$ #ang #ang_t #pt$ #pt1 #pt2 #lp #wp$ #wp$$ #jp$ #pp$ #ret$
	)
	(mapcar
	 '(lambda ( #ap$ )
			(setq #pt_n$ nil)
			(setq #ang (car #ap$))
			;角度を０度にした時の座標に変換する
			(setq #ang_t (Angle0to360 (- (* 2.0 PI) #ang)))
			(mapcar
			 '(lambda ( #pt$ )
					(setq #pt1 (pt1jiHenkan (car  #pt$) #ang_t))
					(setq #pt2 (pt1jiHenkan (cadr #pt$) #ang_t))
					(if (< (car #pt1) (car #pt2))
						(setq #pt_n$ (cons (list #pt1 #pt2) #pt_n$))
						(setq #pt_n$ (cons (list #pt2 #pt1) #pt_n$))
					)
				)
				(cadr #ap$)
			)
			;先頭要素でソート
			(setq #pt_n$ (SCFmg_sort$ 'caar #pt_n$))
			;連鎖でリストを分ける
			(setq #lp (car (nth 0 #pt_n$)))
			(setq #wp$  nil)
			(setq #wp$$ nil)
			(mapcar
			 '(lambda ( #jp$ )
					(if (equal 0.0 (distance #lp (car #jp$)) 0.01)
						(progn
							(setq #wp$ (cons (car  #jp$) #wp$))
							(setq #wp$ (cons (cadr #jp$) #wp$))
							(setq #lp  (cadr #jp$))
						)
						(progn
							(setq #wp$ (reverse #wp$))
							(setq #wp$$ (cons (list (car #wp$)(last #wp$)) #wp$$))
							(setq #wp$ nil)
							(setq #wp$ (cons (car  #jp$) #wp$))
							(setq #wp$ (cons (cadr #jp$) #wp$))
							(setq #lp  (cadr #jp$))
						)
					)
				)
				#pt_n$
			)
			(setq #wp$ (reverse #wp$))
			(setq #wp$$ (cons (list (car #wp$)(last #wp$)) #wp$$))
			;角度を元に戻す
			(setq #pt_n$ nil)
			(mapcar
			 '(lambda ( #pt$ )
					(setq #pt1 (pt1jiHenkan (car  #pt$) #ang))
					(setq #pt2 (pt1jiHenkan (cadr #pt$) #ang))
					(setq #pt_n$ (cons (list #pt1 #pt2) #pt_n$))
				)
				#wp$$
			)
			;角度＋リストって編集
			(mapcar
			 '(lambda ( #pp$ )
					(setq #ret$ (cons (list #ang #pp$) #ret$))
				)
				#pt_n$
			)
		)
		&ang$
	)

	#ret$
);CollectPos

;<HOM>*************************************************************************
; <関数名>    : ChangeList
; <処理概要>  : リスト入れ替え
; <戻り値>    : リスト
; <備考>      :
; <作成>      : 00/03/23
;*************************************************************************>MOH<
(defun ChangeList (
	&list$
	&no
	&newElm
	/
	#i #elm #list$
	)
	(setq #i 0)
	(mapcar
	 '(lambda ( #elm )
			(if (= #i &no)
				(setq #list$ (cons &newElm #list$))
				(setq #list$ (cons #elm    #list$))
			)
			(setq #i (1+ #i))
		)
		&list$
	)

	(reverse #list$)
);ChangeList

;<HOM>*************************************************************************
; <関数名>    : GetMinMaxAng
; <処理概要>  : 座標リストと角度から、領域を獲得
; <戻り値>    : ４点座標リスト
; <備考>      : 0                  1
;                +----------------+
;                |                |
;                |                |
;                +----------------+
;               3                  2
; <作成>      : 00/03/23
;*************************************************************************>MOH<
(defun GetMinMaxAng (
	&pt$        ; 座標リスト
	&ang        ; 角度
	/
	#ang_t #pt_n$ #pt #minmax #rect$
	)
	(setq #ang_t (Angle0to360 (- 0.0 &ang)))
	(setq #pt_n$
		(mapcar
		 '(lambda ( #pt )
				(if (/= #pt nil)
					(pt1jiHenkan #pt #ang_t)
				)
			)
			&pt$
		)
	)
	;領域獲得
	(setq #minmax (GetPtMinMax #pt_n$))

	;４点座標
	(setq #rect$
		(list
			(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
			(list (car (cadr #minmax)) (cadr (cadr #minmax)) 0.0)
			(list (car (cadr #minmax)) (cadr (car  #minmax)) 0.0)
			(list (car (car  #minmax)) (cadr (car  #minmax)) 0.0)
		)
	)
	;座標を元に戻す
	(mapcar
	 '(lambda ( #pt )
			(pt1jiHenkan #pt &ang)
		)
		#rect$
	)
)


;;2000/07/24 HT 使われていない関数のため削除 START
;;;もし、ダミー領域以外に図形がある時、ダミー領域に、
;;;強引にキッチンもしくは、ダイニングのダミー領域に
;;;はみ出た分のシンボル図形を付加する  00/04/06
;;;;;<HOM>*************************************************************************
;;; <関数名>    : SetDummyArea
;;; <処理概要>  : ダミー領域作成
;;; <戻り値>    : なし
;;; <備考>      : 拡張データ
;;;                 モデルタイプ
;;;                 モデル番号
;;;                 シンボルハンドル
;;; <作成>      : 00/01/15
;;;*************************************************************************>MOH<
;;(defun SetDummyArea_t (
;;  /
;;  #clayer #ssSym #ssWt #ss$$ #no #ss$ #pt$ #ss #dpt$ #il #en$ #waku #i #en #cnt #p #waku$
;;  )
;;  ;元あるモデル図形領域を削除する
;;  (DelDummyArea)
;;  ;拡張データ登録
;;  (if (not (tblsearch "APPID" "G_SKDM")) (regapp "G_SKDM"))
;;  ;画層
;;  (setq #clayer (getvar "CLAYER"))
;;  (setvar "CLAYER" "0")
;;  ;選択セット獲得
;;  (setq #ssSym (ssget "X" (list (list -3 (list "G_LSYM")))))
;;  (setq #ssWt  (ssget "X" (list (list -3 (list "G_WRKT")))))
;;
;;  ;モデル毎に選択セットを分ける
;;  (setq #ss$$ (DivSymByModel #ssSym #ssWt))
;;
;;  ;拡張データ格納
;;  (setq #no 1)  ; モデル番号
;;  ;キッチン
;;  (mapcar
;;   '(lambda ( #ss$ )
;;      (setq #pt$  (nth 0 #ss$))  ; 領域図形名
;;      (setq #ss   (nth 1 #ss$))  ; 選択エンティティ
;;      (setq #dpt$ (nth 2 #ss$))  ; ダミー座標リスト
;;      (setq #il   (nth 3 #ss$))  ; ワークトップ形状ILフラグ
;;      (setq #en$ nil)
;;      ;ダミー領域作図
;;      (MakeLwPolyLine #pt$ 0 0.0)
;;
;;      (setq #waku (entlast))
;;      ;選択エンティティから図形名リストを獲得
;;      (setq #i 0)
;;      (repeat (sslength #ss)
;;        (setq #en  (ssname #ss #i))
;;        (setq #en$ (cons #en #en$))
;;        (setq #i    (1+ #i))
;;      )
;;      ;拡張データ格納
;;      (CfSetXData #waku "G_SKDM" (append (list "K" (itoa #no)) #en$))
;;      ;ワークトップダミー図形作成
;;      (if (/= nil (nth 0 #dpt$))
;;        (progn
;;          (entmake (list (cons 0 "POINT")(cons 10 (nth 0 #dpt$))))
;;          (if (= "L" #il)
;;            (CfSetXData (entlast) "G_SKDM" (list 1 "W" (itoa #no) 0 0.0 "C"))
;;            (CfSetXData (entlast) "G_SKDM" (list 1 "W" (itoa #no) 0 0.0 ""))
;;          )
;;        )
;;      )
;;      (setq #cnt 1)
;;      (mapcar
;;       '(lambda ( #p )
;;          (if (/= nil #p)
;;            (progn
;;              (entmake (list (cons 0 "POINT")(cons 10 #p)))
;;              (CfSetXData (entlast) "G_SKDM" (list 1 "W" (itoa #no) #cnt 0.0 ""))
;;            )
;;          )
;;          (setq #cnt (1+ #cnt))
;;        )
;;        (cdr #dpt$)
;;      )
;;      ;領域図形獲得
;;      (setq #waku$ (cons #waku #waku$))
;;      ;モデル番号カウントアップ
;;      (setq #no (1+ #no))
;;    )
;;    (car #ss$$)
;;  )
;;  ;ダイニング
;;  (mapcar
;;   '(lambda ( #ss$ )
;;      (setq #pt$ (car  #ss$))  ; 領域図形名
;;      (setq #ss  (cadr #ss$))  ; 選択エンティティ
;;      (setq #en$ nil)
;;      ;ダミー領域作図
;;      (MakeLwPolyLine #pt$ 0 0.0)
;;      (setq #waku (entlast))
;;      ;選択エンティティから図形名リストを獲得
;;      (setq #i 0)
;;      (repeat (sslength #ss)
;;        (setq #en (ssname #ss #i))
;;        (setq #en$ (cons #en #en$))
;;        (setq #i (1+ #i))
;;      )
;;      ;拡張データ格納
;;      (CfSetXData #waku "G_SKDM" (append (list "D" (itoa #no)) #en$))
;;      ;領域図形獲得
;;      (setq #waku$ (cons #waku #waku$))
;;      ;モデル番号カウントアップ
;;      (setq #no (1+ #no))
;;    )
;;    (cadr #ss$$)
;;  )
;;  ;サイドパネル編集
;;  (AddSideToDummyArea #waku$)
;;
;;  ;その他部材編集
;;  (temp)
;;
;;  (setvar "CLAYER" #clayer)
;;
;;  (princ)
;;) ; SetDummyArea
;;2000/07/24 HT 使われていない関数のため削除 END


;<HOM>*************************************************************************
; <関数名>    : temp
; <処理概要>  :
; <戻り値>    :
; <備考>      :
; <作成>      : 00/04/06
;*************************************************************************>MOH<
(defun temp (
	/
	#ss #sstmp #i #en #ed$ #ken #den #sym #sse #en$ #ed_n$ #flg
	)
	(setq #ss (ssget "X" (list (cons 0 "LWPOLYLINE") (list -3 (list "G_SKDM")))))
	(if (/= nil #ss)
		(progn
			(setq #sstmp (ssadd))
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				(if (and (not #ken) (= "K" (nth 0 #ed$)))
					(setq #ken #en)
				)
				(if (and (not #den) (= "D" (nth 0 #ed$)))
					(setq #den #en)
				)
				(mapcar
				 '(lambda ( #sym )
						(ssadd #sym #sstmp)
					)
					(cdr (cdr #ed$))
				)
				(setq #i (1+ #i))
			)
		)
	)
	(if (and (/= nil #sstmp) (/= 0 (sslength #sstmp)))
		(progn
			(setq #ss (ssget "X" (list (list -3 (list "G_LSYM")))))
			(if (/= nil #ss)
				(progn
					(setq #sse (ssadd))
					(setq #i 0)
					(repeat (sslength #ss)
						(setq #en (ssname #ss #i))
						(if (not (ssmemb #en #sstmp))
							(ssadd #en #sse)
						)
						(setq #i (1+ #i))
					)
				)
			)
		)
	)
	(if (and (/= nil #sse) (/= 0 (sslength #sse))(or #ken #den))
		(progn
			(setq #en$ (Ss2En$ #sse))
			(if #ken
				(progn
					(setq #ed$ (CfGetXData #ken "G_SKDM"))
					(setq #ed_n$ (append #ed$ #en$))
					(CfSetXData #ken "G_SKDM" #ed_n$)
					(setq #flg T)
				)
			)
			(if (and #den (not #flg))
				(progn
					(setq #ed$ (CfGetXData #den "G_SKDM"))
					(setq #ed_n$ (append #ed$ #en$))
					(CfSetXData #den "G_SKDM" #ed_n$)
				)
			)
		)
	)

	(princ)
)


;;2000/07/24 HT 使われていない関数のため削除 START
;; ワークトップのデータが旧バージョンのものも含まれているので
;; この関数を再利用する場合は、注意が必要
;;<HOM>*************************************************************************
;; <関数名>    : DivSymByModel
;; <処理概要>  : キッチン又はダイニング毎にシンボルを分ける
;; <戻り値>    : 領域座標リストとシンボルリスト（キッチン ダイニング）
;; <備考>      :
;; <作成>      : 1999-11-10
;;*************************************************************************>MOH<
;;(defun DivSymByModel_t (
;;  &ss         ; シンボルの選択セット
;;  &ssw        ; ワークトップの選択セット
;;  /
;;  #sst #ssw #en #eed$ #pt$ #ryoiki #dpt$ #il #again$ #sss #sss$ #ssb
;;  #i #ss$ #ss #rect$ #10$ #flg #10 #ssw$
;;  )
;;  (if (/= nil &ss)
;;    (progn
;;      (setq #sst &ss)
;;      ;キッチンのシンボルを獲得
;;      (setq #ssw &ssw)
;;      (if (/= nil #ssw)
;;        (progn
;;          (while (and (/= nil #ssw) (/= 0 (sslength #ssw)))
;;            (setq #en (ssname #ssw 0))
;;            ;カットされていたらもう一方を選択セットから除外する
;;           (setq #eed$ (CfGetXData #en "G_WRKT"))
;;            ; 2000/06/06 土屋  WTタイプ シンクガス 一体型 = (0 or -999)対応
;;            (if (and (/= 0 (nth 5 #eed$)) (/= -999 (nth 5 #eed$)))
;;              (if (= 'ENAME (type (nth 35 #eed$)))
;;                (ssdel (nth 35 #eed$) #ssw)
;;              )
;;            )
;;            ;現在のワークトップを選択セットから除外する
;;            (ssdel #en #ssw)
;;            ;ワークトップの領域を獲得
;;            (setq #pt$ (GetWorkTopArea #en))
;;            ;領域図形作図
;;            (setq #ryoiki (nth 0 #pt$))
;;            (setq #dpt$   (nth 1 #pt$))
;;
;;            (setq #il     (nth 2 #pt$))
;;            (setq #again$ (GetAreaAgain #ryoiki #dpt$ #sst (nth 4 #eed$)))
;;            (setq #sss    (En$2Ss (nth 0 #again$)))
;;            (setq #ryoiki (nth 1 #again$))
;;            (setq #dpt$   (nth 2 #again$))
;;            ;選択セットから除外
;;;            (mapcar
;;;             '(lambda ( #en )
;;;                (ssdel #en #sst)
;;;              )
;;;              (nth 0 #again$)
;;;            )
;;           ;選択セットリストに格納
;;            (if (and (/= nil #sss) (/= 0 (sslength #sss)))
;;              (setq #sss$ (cons (list #ryoiki #sst #dpt$ #il) #sss$))
;;            )
;;            (setq #sst nil)
;;          )
;;        )
;;      )
;;      ;ダイニングの選択セット
;;      (if (and (/= nil #sst) (/= 0 (sslength #sst)))
;;        (progn
;;;          ;ベースキャビネットのみ獲得
;;;          (setq #ssb (ssadd))
;;;          (setq #i 0)
;;;          (repeat (sslength #sst)
;;;            (setq #en (ssname #sst #i))
;;;            (if
;;;              (or
;;;                (equal CG_SKK_ONE_CNT (CfGetSymSKKCode #en 1))
;;;                (and
;;;                  (equal CG_SKK_ONE_CAB (CfGetSymSKKCode #en 1))
;;;                  (equal CG_SKK_TWO_BAS (CfGetSymSKKCode #en 2))
;;;                )
;;;              )
;;;              (ssadd #en #ssb)
;;;            )
;;;            (setq #i (1+ #i))
;;;          )
;;;          ;シンボルを分ける
;;;          (setq #ss$ (DivideSymParts #ssb))
;;;          (mapcar
;;;           '(lambda ( #ss )
;;              ;領域を獲得する
;;              (setq #rect$ (GetDiningArea #sst))
;;              ;領域図形作図
;;              (setq #ryoiki #rect$)
;;              ;領域内のシンボル図形を獲得
;;;              (setq #ssw (ssadd))
;;;              (setq #i 0)
;;;              (repeat (sslength #sst)
;;;                (setq #en (ssname #sst #i))
;;;                ;構成座標を獲得
;;;                (setq #10$ (GetSym4Pt #en))
;;;                (setq #flg T)
;;;                (mapcar
;;;                 '(lambda ( #10 )
;;;                    (setq #10 (list (car #10) (cadr #10) 0.0))
;;;                    (if (not (JudgeNaigai #10 #rect$))
;;;                      (setq #flg nil)
;;;                    )
;;;                  )
;;;                  (list (nth 0 #10$)(nth 1 #10$)(nth 2 #10$))
;;;                )
;;;                (if (/= nil #flg)
;;;                  (ssadd #en #ssw)
;;;                )
;;;                (setq #i (1+ #i))
;;;              )
;;              (setq #ssw$ (cons (list #ryoiki #sst) #ssw$))
;;;            )
;;;            #ss$
;;;          )
;;        )
;;      )
;;    )
;;  )
;;
;;  (list #sss$ #ssw$)
;;)
;;;2000/07/24 HT 使われていない関数のため削除 END



;<HOM>*************************************************************************
; <関数名>    : SetDummyAgain
; <処理概要>  : ダミー領域の再作成
; <戻り値>    : なし
; <備考>      : 矢視領域内のシンボル図形で、ダミー領域外の図形を強引にダミー領域に
;               格納してしまう。
; <作成>      : 00/04/07
;*************************************************************************>MOH<
(defun SetDummyAgain (
	&ssd        ; ダミー領域選択エンティティ
	&yashi      ; 矢視領域図形名
	/
	#sstmp #i #en #ed$ #ken #den #sym #rect$ #ss #ssins #10 #en$ #ed_n$ #flg
	)
	;ダミー領域選択エンティティから、各図形の拡張データに格納されている
	;シンボルハンドルを仮の選択セットに格納
	(if (/= nil &ssd)
		(progn
			(setq #sstmp (ssadd))
			(setq #i 0)
			(repeat (sslength &ssd)
				(setq #en (ssname &ssd #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				(if (and (not #ken) (= "K" (nth 0 #ed$)))
					(setq #ken #en)
				)
				(if (and (not #den) (= "D" (nth 0 #ed$)))
					(setq #den #en)
				)
				(mapcar
				 '(lambda ( #sym )
						(ssadd #sym #sstmp)
					)
					(cdr (cdr #ed$))
				)
				(setq #i (1+ #i))
			)
			;矢視図形名から領域座標を獲得
			(if &yashi
				(setq #rect$ (mapcar 'car (get_allpt_H &yashi)))
			)
			;矢視領域内のダミー領域外のシンボル図形を獲得
			(setq #ss (ssget "X" (list (list -3 (list "G_LSYM")))))
			(if (/= nil #ss)
				(progn
					(setq #ssins (ssadd))
					(setq #i 0)
					(repeat (sslength #ss)
						(setq #en (ssname #ss #i))
						(setq #10 (cdrassoc 10 (entget #en)))
						(if (not (ssmemb #en #sstmp))
							(if (/= nil #rect$)
								(if (JudgeNaigai #10 #rect$)
									(ssadd #en #ssins)
								)
								(progn
									(ssadd #en #ssins)
								)
							)
						)
						(setq #i (1+ #i))
					)
				)
			)
		)
	)
	(if (and (/= nil #ssins) (/= 0 (sslength #ssins))(or #ken #den))
		(progn
			(setq #en$ (Ss2En$ #ssins))
			(if #ken
				(progn
					(setq #ed$ (CfGetXData #ken "G_SKDM"))
					(setq #ed_n$ (append #ed$ #en$))
					(CfSetXData #ken "G_SKDM" #ed_n$)
					(setq #flg T)
				)
			)
			(if (and #den (not #flg))
				(progn
					(setq #ed$ (CfGetXData #den "G_SKDM"))
					(setq #ed_n$ (append #ed$ #en$))
					(CfSetXData #den "G_SKDM" #ed_n$)
				)
			)
		)
	)

	(princ)
)


