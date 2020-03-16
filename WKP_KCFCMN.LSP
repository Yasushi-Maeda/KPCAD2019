(setq CG_DimHeight_1Line 120)				; 01/03/02 TM ADD  寸法文字列１行分の高さ
(setq CG_DimHeight_Offset 300)			; 01/03/02 TM ADD  対象図形からもっとも内側の寸法文字列までの高さ

;<HOM>*************************************************************************
; <関数名>    : SKUblock
; <処理概要>  : 名前のない複合図形作成
; <戻り値>    : なし
; <作成>      : 1999-06-17
; <備考>      : なし
;*************************************************************************>MOH<
(defun SKUblock (
	&pt
	&ss
	/
	#ByBlock$ #i #eg #name
	)
	(setq #ByBlock$ (list (cons 6 "byblock")(cons 62 0)))
	(entmake (append (list '(0 . "BLOCK")'(2 . "*Uxx")'(70 . 1)(cons 10 &pt)) #ByBlock$))
	(setq #i 0)
	(repeat (sslength &ss)
		(setq #eg (entget (ssname &ss #i) '("*")))
		(entmake  (append (cdr #eg) #ByBlock$))
		(setq #i  (1+ #i))
	)
	(setq #name (entmake '((0 . "ENDBLK"))))
	(setq #i 0)
	(repeat (sslength &ss)
		(entdel (ssname &ss #i))
		(setq #i (1+ #i))
	)
	(entmake (list '(0 . "INSERT")(cons 2 #name)(cons 10 &pt)))
)

;<HOM>*************************************************************************
; <関数名>    : SKGetPtByEn
; <処理概要>  : entselで図形を獲得し、構成ﾘｽﾄを返す
; <戻り値>    :
;        LIST : （（図形名 座標）（ｸﾞﾙｰﾌﾟｺｰﾄﾞ PT） ...）
; <備考>      :
;*************************************************************************>MOH<
(defun SKGetPtByEn (
	&sMsg       ; 図形獲得ﾒｯｾｰｼﾞ
	&sFil       ; 図形獲得ﾌｨﾙﾀｰ
	&sName      ; 図形名称
	&bDim       ; 3次元ﾌﾗｸﾞ（３次元座標を無効とするときTを設定）
	/
	#Loop       ; ﾙｰﾌﾟﾌﾗｸﾞ
	#bLoop2     ; 3次元ﾌﾗｸﾞ
	#eEn        ; 図形名
	#sType      ; 図形ﾀｲﾌﾟ
	#Ed$        ; 図形ﾃﾞｰﾀ
	#Pt$        ; 構成座標ﾘｽﾄ
	#En$        ; 返り値
#LAYER        ; "Z_KUTAI"なら無視する 01/02/20 YM ADD
	)
	(setq #Loop T)
	(while #Loop
		(setq #eEn (entsel (strcat "\n" &sMsg ": ")))
		(if #eEn
			(progn
				(setq #LAYER (cdr (assoc 8 (entget (car #eEn)))))
				(if (= "Z_KUTAI" #LAYER) ; 01/02/20 YM ADD
					(progn ; 01/02/20 YM ADD
						; #eEn = nil のときと同じ処理
						(if (= (getvar "ERRNO") 52)
							(setq #Loop nil)
						);_if
						(if (= (getvar "ERRNO") 7)
							(princ "\n図形を選択してください.")
						);_if

					)
					(progn ; 通常ﾙｰﾄ

						(setq #sType (cdr (assoc 0 (entget (car #eEn)))))
						(if (wcmatch #sType (strcase &sFil))
							(progn
								(setq #bLoop2 T)
								(mapcar
								 '(lambda ( #Ed$ )
										(if (<= 10 (car #Ed$) 18)
											(progn
												(if (/= nil &bDim)
													(progn
														(if (not (equal 0.0 (caddr (cdr #Ed$)) 0.0001))
															(setq #bLoop2 nil)
														)
													)
												)
												(setq #Pt$ (cons #Ed$ #Pt$))
											)
										)
									)
									(entget (car #eEn))
								)


								(if (/= nil #bLoop2)
									(progn
										(setq #En$ (cons #eEn (reverse #Pt$)))
										(setq #Loop nil)
									)
									(progn
										(princ "\n3次元図形は無効です")
									)
								);_if

							)
							(progn
								(princ (strcat "\n" &sName "図形ではありません."))
							)
						);_if
					)
				);_if ; 01/02/20 YM ADD

			)
			(progn
				(if (= (getvar "ERRNO") 52)
					(setq #Loop nil)
				);_if
				(if (= (getvar "ERRNO") 7)
					(princ "\n図形を選択してください.")
				);_if
			)
		)
	)

	#En$
) ; SKGetPtByEn

;<HOM>*************************************************************************
; <関数名>    : SKFGetGroupEnt
; <処理概要>  : 同一ｸﾞﾙｰﾌﾟのﾒﾝﾊﾞｰｴﾝﾃｨﾃｨを取出す
; <戻り値>    :
;        LIST : ﾒﾝﾊﾞｰｴﾝﾃｨﾃｨのﾘｽﾄ (ENAME ENAME ...)
; <作成>      : 98-03-25 川本成二
; <修正>      : 98-07-29 森本かおり
; <備考>      : なし
;*************************************************************************>MOH<
(defun SKFGetGroupEnt (
	&en      ; (ENAME)    シンボル図形名
	/
	#en$ #eg$ #eg #gen #geg$ #en_n$ #en #flg #en_n
	)

	(setq #en$ nil)
	(setq #eg$ (entget &en))
	(foreach #eg #eg$
		(if (= 330 (car #eg))
			(progn
				(setq #gen  (cdr #eg))
				(setq #geg$ (entget #gen))
				(foreach #geg #geg$
					(if (= 340 (car #geg))
						(progn
;// CG_ACAD_VER NOT "R14" START
							(if (assoc 8 (entget (cdr #geg)))
								(setq #en$ (cons (cdr #geg) #en$))
							)
;// CG_ACAD_VER NOT "R14" END
						)
					)
				)
			)
		)
	)
	(setq #en_n$ nil)
	(mapcar
	 '(lambda ( #en )
			(if (/= nil #en_n$)
				(progn
					(setq #flg T)
					(mapcar
					 '(lambda ( #en_n )
							(if (equal #en_n #en)
								(setq #flg nil)
							)
						)
						#en_n$
					)
					(if (/= nil #flg)
						(setq #en_n$ (cons #en #en_n$))
					)
				)
				(setq #en_n$ (cons #en #en_n$))
			)
		)
		#en$
	)

	#en_n$ ; return
) ; SKFGetGroupEnt

;<HOM>*************************************************************************
; <関数名>    : SKFMakeLayer
; <処理概要>  : 画層を作成する
; <戻り値>    : なし
; <作成>      : 1998-06-17
; <備考>      : なし
;*************************************************************************>MOH<
(defun SKFMakeLayer (
	&str     ; (STR)      画層名
	&color   ; (INT)      色コード
	&ltype   ; (STR)      線種
	/
	)
	;画層作成
	(entmake
		(list
			(cons 0 "LAYER")
			(cons 100 "AcDbSymbolTableRecord")
			(cons 100 "AcDbLayerTableRecord")
			(cons 2 &str)
			(cons 70 0)
			(cons 62 &color)
			(cons 6 &ltype)
		)
	)

	(princ) ; return
) ; SKFMakeLayer


;;;<HOM>*************************************************************************
;;; <関数名>    : SKGetKichenType
;;; <処理概要>  : ワークトップからキッチンタイプを獲得する
;;; <戻り値>    : キッチンタイプ
;;; <備考>      : データが無いときnil
;;; <作成>      : 1999-06-21
;;;*************************************************************************>MOH<
;;(defun SKGetKichenType (
;;  &sNo        ; 領域番号
;;  /
;;  #xSp #iI #eEn #Ex$ #Pt$ #ss #i #en #ed$ #pt #sMsg #iType1 #sKatte
;;  Ex1$ #Ex2$ #sView #sssym #flg
;;  )
;;  ; ワークトップ図形取得
;;  (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))
;;  (if (/= nil #xSp)
;;    (progn
;;      ;指定された領域の座標リストを獲得する
;;      (setq #iI 0)
;;      (repeat (sslength #xSp)
;;        (setq #eEn (ssname #xSp #iI))
;;        (setq #Ex$ (CfGetXData #eEn "RECT"))
;;        (if (= &sNo (car #Ex$))
;;          (progn
;;            (setq #Pt$ (mapcar 'car (get_allpt_H #eEn)))
;;            (setq #Pt$ (append #Pt$ (list (car #Pt$))))
;;          )
;;        )
;;        (setq #iI (1+ #iI))
;;      )
;;      ;領域内のワークトップを獲得する
;;      (setq #xSp (ssadd))
;;      (setq #ss (ssget "X" (list (list -3 (list "G_WRKT")))))
;;      (if (/= nil #ss)
;;        (progn
;;          (setq #i 0)
;;          (repeat (sslength #ss)
;;            (setq #en (ssname #ss #i))
;;            (setq #ed$ (CfGetXData #en "G_WRKT"))
;;            (setq #pt  (nth 32 #ed$))
;;            (if (JudgeNaigai #pt #Pt$)
;;              (ssadd #en #xSp)
;;            )
;;            (setq #i (1+ #i))
;;          )
;;        )
;;      )
;;      (if (or (= nil #xSp) (= 0 (sslength #xSp)))
;;        (setq #xSp nil)
;;      )
;;      (setq #sMsg "\n領域を正確に設定してください")
;;    )
;;    (progn
;;      (setq #xSp (ssget "X" (list (list -3 (list "G_WRKT")))))
;;      (setq #sMsg "\n矢視設定を行ってください.")
;;    )
;;  )
;;  (if (/= nil #xSp)
;;    (progn
;;      (cond
;;        ((= 1 (sslength #xSp))
;;          (setq #eEn (ssname #xSp 0))
;;          (setq #Ex$ (CfGetXData (ssname #xSp 0) "G_WRKT"))
;;          (setq #iType1 (nth 3  #Ex$))
;;          (setq #sKatte (nth 30 #Ex$))
;;        )
;;        ((= 2 (sslength #xSp))
;;          (setq #Ex1$ (CfGetXData (ssname #xSp 0) "G_WRKT"))
;;          (setq #Ex2$ (CfGetXData (ssname #xSp 1) "G_WRKT"))
;;          (if
;;            (and
;;              (/= (nth 7 #Ex1$))
;;              (= (nth 3 #Ex1$) (nth 3 #Ex2$))
;;              (= (nth 30 #Ex1$) (nth 30 #Ex2$))
;;            )
;;            (progn
;;              (setq #iType1 (nth 3  #Ex1$))
;;              (setq #sKatte (nth 30 #Ex1$))
;;            )
;;            (progn
;;              (CFAlertMsg (strcat "ﾓﾃﾞﾙ図形の数が多すぎます" #sMsg))
;;            )
;;          )
;;        )
;;        ((< 2 (sslength #xSp))
;;          (CFAlertMsg (strcat "ﾓﾃﾞﾙ図形の数が多すぎます" #sMsg))
;;        )
;;      )
;;      (if (/= nil #iType1)
;;        (progn
;;          (setq CG_UnitCode "K")
;;          (cond
;;            ((and (= 0 #iType1)(= "L" #sKatte)) (setq #sView "I-LEFT"))
;;            ((and (= 0 #iType1)(= "R" #sKatte)) (setq #sView "I-RIGHT"))
;;            ((and (= 1 #iType1)(= "L" #sKatte)) (setq #sView "L-LEFT"))
;;            ((and (= 1 #iType1)(= "R" #sKatte)) (setq #sView "L-RIGHT"))
;;            ((and (= 2 #iType1)(= "L" #sKatte)) (setq #sView "W-LEFT"))
;;            ((and (= 2 #iType1)(= "R" #sKatte)) (setq #sView "W-RIGHT"))
;;          )
;;        )
;;      )
;;    )
;;    (progn
;;      (setq #ss (ssget "X" (list (list -3 (list "G_LSYM")))))
;;      (if (/= nil #ss)
;;        (progn
;;          (if (/= nil #Pt$)
;;            (progn
;;              (setq #i 0)
;;              (setq #sssym (ssadd))
;;              (repeat (sslength #ss)
;;                (setq #en (ssname #ss #i))
;;                (setq #pt (cdr (assoc 10 (entget #en))))
;;                (if (JudgeNaigai #pt #Pt$)
;;                  (ssadd #en #sssym)
;;                )
;;                (setq #i (1+ #i))
;;              )
;;              (if (or (= nil #sssym) (= 0 (sslength #sssym)))
;;                (setq #sssym nil)
;;              )
;;            )
;;            (setq #sssym #ss)
;;          )
;;          (setq #flg nil)
;;          (setq #i 0)
;;          (repeat (sslength #sssym)
;;            (if (equal CG_SKK_THR_DIN (CFGetSymSKKCode (ssname #ss #i) 3))
;;              (setq #flg T)
;;            )
;;            (setq #i (1+ #i))
;;          )
;;          (if (and (= nil #flg) (= 1 (sslength #sssym)))
;;            (setq #flg T)
;;          )
;;          (if (/= nil #flg)
;;            (progn
;;              (setq #sView "D-RIGHT")
;;              (setq CG_UnitCode "D")
;;            )
;;            (CFAlertMsg "ﾓﾃﾞﾙ図形が存在しません")
;;          )
;;        )
;;        (CFAlertMsg "ﾓﾃﾞﾙ図形が存在しません")
;;      )
;;    )
;;
;;  ) ; end if
;;
;;  #sView
;;)
;;


;<HOM>*************************************************************************
; <関数名>    : SKGetKichenType
; <処理概要>  : ワークトップからキッチンタイプを獲得する
; <戻り値>    : キッチンタイプ
; <備考>      :
; <作成>      : 2000/08/21 HT 加工穴のあるワークトップで判断するように変更
;               ｼﾝｸ穴加工有無を"G_WRKT"で判断する 00/11/28 YM
;*************************************************************************>MOH<
(defun SKGetKichenType (
	&sNo        ; 領域番号
	/
	#Ex$    ; ワークトップの拡張データ
	#ss     ; アイテムの選択セット
	#sMsg   ; メッセージ
	#iType1 ; 形状タイプ1 I L U 型 (ワークトップから取得)
	#sKatte ; 左右勝手
	#sView  ; キッチンタイプ I-LEFT I-RIGHT(IU型) L-LEFT L-RIGHT(L型) D-RIGHT(WTなし)
#En$ ;2017/09/15 YM ADD
	)
;;;	(setq CG_FK_LP nil);ﾌﾚｰﾑｷｯﾁﾝ左右勝手ユーザーから取得 2017/09/21 YM ADD

	; 加工穴のあるワークトップ図形名リスト取得
	; 加工穴のあるワークトップが存在しない時の扱いは保留。
	(setq #En$ (SCFGetWkTopXData))

	(if (= CG_OUTCMDNAME "SCFMakeMaterial")
		(setq #sMsg "\n矢視設定を行ってください.")
		(setq #sMsg "")
	);_if

	(setq #iType1 nil)
	(if (/= #En$ nil)
		(progn ; ワークトップが存在する時 (加工穴ありなしのチェックはしない)
			; U型でｼﾝｸ２つｺﾝﾛ１つの場合にSTOPしないようにする 01/05/02 YM MOD 客先要望
			(setq #Ex$ (CfGetXData (nth 0 #En$) "G_WRKT"))
			(setq #iType1 (nth 3  #Ex$)) ; 01/01/19 YM WT-TYPE1
			(setq #sKatte (nth 30 #Ex$))

			; 01/09/06 YM ADD-S 勝手="?"の暫定対応
			(if (and (/= #sKatte "R")(/= #sKatte "L"))
				(progn
					(setq #sKatte "R")
					(princ "\n勝手が不明のため右勝手と判断しました。")
				)
			);_if
			; 01/09/06 YM ADD-E 勝手="?"の暫定対応

;;;01/05/02YM@	    (if (= 1 (length #En$))
;;;01/05/02YM@	      (progn
;;;01/05/02YM@		      ; 加工穴のあるワークトップ図形1の時
;;;01/05/02YM@		      (setq #Ex$ (CfGetXData (nth 0 #En$) "G_WRKT"))
;;;01/05/02YM@		      (setq #iType1 (nth 3  #Ex$)) ; 01/01/19 YM WT-TYPE1
;;;01/05/02YM@		      (setq #sKatte (nth 30 #Ex$))
;;;01/05/02YM@	      )
;;;01/05/02YM@	      (progn ; 加工穴のあるワークトップ図形複数の時 00/11/28 YM ADD "progn"を追加
;;;01/05/02YM@		      (CFAlertMsg (strcat "ﾜｰｸﾄｯﾌﾟが多すぎます" #sMsg))
;;;01/05/02YM@	      )
;;;01/05/02YM@	    );_if

		)
		(progn ; ワークトップが存在しない時で、アイテムが存在する時は"D-RIGHT"

			(setq #ss (ssget "X" (list (list -3 (list "G_LSYM")))))
			(if (/= nil #ss)
				(progn ; アイテムが存在する時は、常に"D-RIGHT"
					(setq #sView "D-RIGHT")
					(setq CG_UnitCode "D")
				)
				(CFAlertMsg "ﾓﾃﾞﾙ図形が存在しません")
			);_if

			;ﾌﾚｰﾑｷｯﾁﾝ(天板がない) L/Rはユーザーに聞く
			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
				(progn

					(setq #iType1 0) ;I型

					;2017/09/21 YM DEL-S
;;;					(if CG_PERS ;パースがあれば 2017/09/21 YM MOD パース判定しない
;;;						(progn
;;;							;2017/09/14 YM ADD-S
;;;				      (initget 1 "L R")
;;;				      (setq #sKatte (getkword "\n左右勝手を指示 /L=左勝手/R=右勝手/:  "))
;;;							(setq CG_FK_LP #sKatte);2017/09/21 YM ADD ﾌﾚｰﾑｷｯﾁﾝ左右勝手
;;;							;2017/09/14 YM ADD-E
;;;						)
;;;					);_if
					;2017/09/21 YM DEL-E

					(setq #sKatte CG_FK_LP) ;2017/09/21 YM ADD ﾌﾚｰﾑｷｯﾁﾝ左右勝手

				)
			);_if


		)
	);_if

	(if (/= nil #iType1)
		(progn ; キッチンが存在する場合
			(setq CG_UnitCode "K")
			(cond
				; I 型
				((and (= 0 #iType1)(= "L" #sKatte)) (setq #sView "I-LEFT"))
				((and (= 0 #iType1)(= "R" #sKatte)) (setq #sView "I-RIGHT"))
				; L 型
				((and (= 1 #iType1)(= "L" #sKatte)) (setq #sView "L-LEFT"))
				((and (= 1 #iType1)(= "R" #sKatte)) (setq #sView "L-RIGHT"))
				; U 型
				((and (= 2 #iType1)(= "L" #sKatte)) (setq #sView "I-LEFT"))
				((and (= 2 #iType1)(= "R" #sKatte)) (setq #sView "I-RIGHT"))
			);_cond
		)
	);_if
	#sView
);SKGetKichenType

;<HOM>*************************************************************************
; <関数名>    : SKOutPatReadScv
; <処理概要>  : 出力パターン設定ファイル読込み
; <戻り値>    : なし
; <作成>      : 1999-06-17
; <備考>      : なし
;*************************************************************************>MOH<
(defun SKOutPatReadScv (
	&sFname     ; ﾌｧｲﾙ名
	/
	#Flist$ #Str$ #Clist$ #Ret$ #sPat
	)
	(setq #Flist$ (SKreadCSV &sFname))
	(mapcar
	 '(lambda ( #Str$ )
			(if (equal "*" (substr (car #Str$) 1 1))
				(progn
					(if (/= nil #Clist$)
						(setq #Ret$ (cons (append (list #sPat #iAuto) (reverse #Clist$)) #Ret$))
					)
					(setq #sPat  (substr (car #Str$) 2))
					(setq #iAuto (atoi (cadr #Str$)))
					(setq #Clist$ nil)
				)
				(if (/= nil #sPat)
					(setq #Clist$ (cons #Str$ #Clist$))
				)
			)
		)
		#Flist$
	)
;  (if (/= nil #Clist$)
		(setq #Ret$ (cons (append (list #sPat #iAuto) (reverse #Clist$)) #Ret$))
;  )
	(reverse #Ret$)
)

;***********************************************************************
;  SKreadCSV
;
;  ＣＳＶファイルの読み込み
;
;1,電気,アロー電子,表示器,シグナルタワー,ETTW-100-3DK
;2,電気,和泉電気,表示器,パイロットランプ,"APN""126""DN 20V"
;3,電気,ＮＩＳＳ,制御,"PU(Φ3,200V,1/120)",G3LE28L120020
;
;(("1" "電気" "アロー電子" "表示器" "シグナルタワー"     "ETTW-100-3DK"  )
; ("2" "電気" "和泉電気"   "表示器" "パイロットランプ"   "APN"126"DN 20V")
; ("3" "電気" "ＮＩＳＳ"   "制御"   "PU(Φ3,200V,1/120)" "G3LE28L120020" ))
;
;***********************************************************************
(defun SKreadCSV (
		&fName
		/
		#fp #csv #lst #str #dblQuo #c #i
		)
	(setq #fp  (open &fName "r"))
	(if(/= nil #fp)
		(progn
			(setq #csv nil)
			(setq #buf T)
			(while(/= nil #buf)
				(setq #buf (read-line #fp))
				(if(/= nil #buf)
					(progn
						(setq #lst nil)
						(setq #str "")
						(setq #dblQuo nil)
						(setq #i 1)
						(repeat (strlen #buf)
							(setq #c (substr #buf #i 1))
							(cond
								((and(=  nil #dblQuo)(=  "," #c))
									(setq #lst (cons #str #lst))
									(setq #str "")
								)
								((and(=  nil #dblQuo)(=  "\"" #c))
									(setq #dblQuo T)
								)
								((and(= T    #dblQuo)(=  "\"" #c))
									(if(and(< #i (strlen #buf))(= "\"" (substr #buf (1+ #i) 1)))
										(progn
											(setq #str (strcat #str "\""))
											(setq #i (1+ #i))
										)
										(progn
											(setq #lst (cons #str #lst))
											(setq #dblQuo nil)
											(setq #str "")
											(setq #i (1+ #i))
										)
									)
								)
								(T
									(setq #str (strcat #str #c))
								)
							)
							(setq #i (1+ #i))
						)
						(setq #lst (cons #str #lst))
						(setq #csv (cons (reverse #lst) #csv))
					)
				)
			)
			(setq #csv (reverse #csv))
			(close #fp)
		)
	)
	#csv
)

;****************************************************
;  get_allpt_H
;
;  ﾎﾟﾘﾗｲﾝ全座標とふくらみの取得
;  LEADERの全座標の取得 /H9.11.19追加
;
;  返値 : 始点からの(座標+ふくらみ)ﾘｽﾄ
;****************************************************
(defun get_allpt_H(
	&en
	/
	#plst #typ #en #pt #huku #plstH #eg #i #38 #pth$ #pth_n$ #plstH_n #x
	)

	(setq #plst '())
	(if(= 'ENAME (type &en))
		(progn
			(setq #typ(cdr(assoc 0(entget &en))))
			(cond
				((= "POLYLINE" #typ)
					(setq #en(entnext &en))
					(setq #typ(cdr(assoc 0(entget #en))))
					(while(/= #typ "SEQEND")
						(setq #pt    (cdr(assoc 10(entget #en))))
						(setq #huku  (cdr(assoc 42(entget #en))))
						(setq #plstH (cons (list #pt #huku) #plstH))
						(setq #en    (entnext #en))
						(setq #typ   (cdr(assoc 0(entget #en))))
					)
				)
				((= "LWPOLYLINE" #typ)
					(setq #eg (entget &en))
					(setq #i 0)
					(while(< #i (length #eg))
						(if(= 10 (car (nth #i #eg)))
							(progn
								(setq #plstH
									(cons
										(list
											(append (cdr (nth    #i    #eg)) '(0.0))
											(cdr (nth (+ #i 3) #eg))
										)
										#plstH
									)
								)
								(setq #i (+ #i 4))
							)
							(progn
								(setq #i (1+ #i))
							)
						)
					)
					;変換
					(setq #38 (cdr (assoc 38 #eg)))
					(if (= nil #38)
						(setq #38 0.0)
					)
					(mapcar
					 '(lambda ( #pth$ )
							(setq #pth_n$ (list (car (car #pth$)) (cadr (car #pth$)) #38))
							(setq #plstH_n (cons (list (trans #pth_n$ &en 1) (cadr #pth$)) #plstH_n))
						)
						#plstH
					)
					(setq #plstH (reverse #plstH_n))
				)
				((= "LEADER" #typ)
					(setq #eg (entget &en))
					(mapcar
					 '(lambda(#x)
							(if(= 10 (car #x))
								(setq #plstH(cons (cdr #x) #plstH))
							)
						)
						#eg
					)
				)
			)
		)
	)
	(reverse #plstH)
)

;<HOM>*************************************************************************
; <関数名>    : SkFReBlock
; <処理概要>  : ブロックの構成されている図形の画層を全て更新する
;               未更新だと表示されないため
; <戻り値>    : 更新後の図形名
; <作成>      : 1998-10-01
;*************************************************************************>MOH<
(defun SkFReBlock (
	&en      ; (ENAME)    INSERT図形名
	/
	#eg #layer #bname #beg #en #ret #ieg
	)

	;図形データ取得
	(setq #eg (entget &en '("*")))
	;INSERT図形画層
	(setq #layer (cdr (assoc 8 #eg)))
	;ブロック名
	(setq #bname (cdr (assoc 2 #eg)))
	;ブロック図形名
	(setq #beg (entget (tblobjname "BLOCK" #bname)))
	;ブロック図形画層更新
	(entmod (subst (cons 8 #layer) (assoc 8 #beg) #beg))
	;ブロック構成図形名
	(setq #en (cdr (assoc -2 #beg)))

	(while #en

		;図形データ取得
		(setq #ieg (entget #en '("*")))
		;画層更新
		(entmod (subst (cons 8 #layer) (assoc 8 #ieg) #ieg))
		;次のブロック構成図形名取得
		(setq #en (entnext #en))

	) ; end while

	;INSERT図形名取得
	(setq #ret (cdr (assoc -1 #eg)))
	;アップデート
	(entupd #ret)

	#ret ; return
) ; SkFReBlock

;--2011/06/27 A.Satoh Mod - S
;;<HOM>*************************************************************************
;; <関数名>    : SKMkGroup
;; <処理概要>  : 名前のないグループ作成
;; <戻り値>    : なし
;; <作成>      : 00/02/29
;; <備考>      : 06/06/14 AO 関数内処理をARX(Utisl.arx)化
;;*************************************************************************>MOH<
(defun SKMkGroup ( &xSp / ) (C:MakeGroup &xSp) (princ))
;<HOM>*************************************************************************
; <関数名>    : SKMkGroup
; <処理概要>  : 名前のないグループ作成
; <戻り値>    : なし
; <作成>      : 00/02/29
; <備考>      : 06/06/14 AO 関数内処理をARX(Utisl.arx)化
;             : 11/06/27 A.Satoh 関数内処理をARXからLispへ変更
;*************************************************************************>MOH<
;(defun SKMkGroup (
;  &xSp        ; 選択ｾｯﾄ
;  /
;  #Eg$ #eXen #Sub$ #Eg$$ #sName #sTmp
;  )
;  (setq #Eg$
;    (append
;      (list
;        (cons 0 "GROUP")
;        (cons 102 "{ACAD_REACTORS")
;        (cons 330 (cdr (assoc 350 (entget (namedobjdict)))))
;        (cons 102 "}")
;        (cons 100 "AcDbGroup")
;        (cons 300 "")
;        (cons 70 1)
;        (cons 71 1)
;      )
;    )
;  )
;  (setq #eXen (entmakex #Eg$))
;  (dictadd (namedobjdict) "ACAD_GROUP" #eXen)
;  (setq #Sub$ (entget (cdr (assoc 350 (entget (namedobjdict))))))
;  (entmod (append #Sub$ (list (cons 3 "*Axx")(cons 350 #eXen))))
;  (setq #Eg$$ (entget (cdr (assoc 350 (entget (namedobjdict))))))
;  (mapcar
;   '(lambda ( #Eg$ )
;      (if (equal #eXen (cdr #Eg$))
;        (setq #sName #sTmp)
;      )
;      (setq #sTmp (cdr #Eg$))
;    )
;    #Eg$$
;  )
;  (command "_.-group" "A" #sName &xSp "")
;
;  (princ)
;)
;--2011/06/27 A.Satoh Mod - E

;; 06/06/14 AO DEL ;<HOM>*************************************************************************
;; 06/06/14 AO DEL ; <関数名>    : SKMkGroup
;; 06/06/14 AO DEL ; <処理概要>  : 名前のないグループ作成
;; 06/06/14 AO DEL ; <戻り値>    : なし
;; 06/06/14 AO DEL ; <作成>      : 00/02/29
;; 06/06/14 AO DEL ; <備考>      : なし
;; 06/06/14 AO DEL ;*************************************************************************>MOH<
;; 06/06/14 AO DEL (defun SKMkGroup (
;; 06/06/14 AO DEL   &xSp        ; 選択ｾｯﾄ
;; 06/06/14 AO DEL   /
;; 06/06/14 AO DEL   #Eg$ #eXen #Sub$ #Eg$$ #sName #sTmp
;; 06/06/14 AO DEL   )
;; 06/06/14 AO DEL   (setq #Eg$
;; 06/06/14 AO DEL     (append
;; 06/06/14 AO DEL       (list
;; 06/06/14 AO DEL         (cons 0 "GROUP")
;; 06/06/14 AO DEL         (cons 102 "{ACAD_REACTORS")
;; 06/06/14 AO DEL         (cons 330 (cdr (assoc 350 (entget (namedobjdict)))))
;; 06/06/14 AO DEL         (cons 102 "}")
;; 06/06/14 AO DEL         (cons 100 "AcDbGroup")
;; 06/06/14 AO DEL         (cons 300 "")
;; 06/06/14 AO DEL         (cons 70 1)
;; 06/06/14 AO DEL         (cons 71 1)
;; 06/06/14 AO DEL       )
;; 06/06/14 AO DEL     )
;; 06/06/14 AO DEL   )
;; 06/06/14 AO DEL   (setq #eXen (entmakex #Eg$))
;; 06/06/14 AO DEL   (dictadd (namedobjdict) "ACAD_GROUP" #eXen)
;; 06/06/14 AO DEL   (setq #Sub$ (entget (cdr (assoc 350 (entget (namedobjdict))))))
;; 06/06/14 AO DEL   (entmod (append #Sub$ (list (cons 3 "*Axx")(cons 350 #eXen))))
;; 06/06/14 AO DEL   (setq #Eg$$ (entget (cdr (assoc 350 (entget (namedobjdict))))))
;; 06/06/14 AO DEL   (mapcar
;; 06/06/14 AO DEL    '(lambda ( #Eg$ )
;; 06/06/14 AO DEL       (if (equal #eXen (cdr #Eg$))
;; 06/06/14 AO DEL         (setq #sName #sTmp)
;; 06/06/14 AO DEL       )
;; 06/06/14 AO DEL       (setq #sTmp (cdr #Eg$))
;; 06/06/14 AO DEL     )
;; 06/06/14 AO DEL     #Eg$$
;; 06/06/14 AO DEL   )
;; 06/06/14 AO DEL   (command "_.-group" "A" #sName &xSp "")
;; 06/06/14 AO DEL
;; 06/06/14 AO DEL   (princ)
;; 06/06/14 AO DEL )

;<HOM>*************************************************************************
; <関数名>    : SKGetGroupName
; <処理概要>  : グループ名獲得
; <戻り値>    : グループ名獲得
; <作成>      : 00/02/29
; <備考>      : なし
;*************************************************************************>MOH<
(defun SKGetGroupName (
	&eEn        ; 図形名
	/
	#ed #330$ #dic #eg #ePt #eSf #Eg$ #sName #sTmp
	)
	(mapcar
	 '(lambda ( #ed )
			(if (= 330 (car #ed))
				(setq #330$ (cons (cdr #ed) #330$))
			)
		)
		(entget &eEn)
	)
	(mapcar
	 '(lambda ( #dic )
			(setq #eg (entget #dic))
			(if (equal "GROUP" (strcase (cdr (assoc 0 #eg))))
				(setq #ePt #dic)
			)
		)
		#330$
	)
	(if (/= nil #ePt)
		(progn
			(setq #330$ nil)
			(mapcar
			 '(lambda ( #ed )
					(if (and (= 330 (car #ed)) (entget (cdr #ed)))
						(setq #eSf (cdr #ed))
					)
				)
				(entget #ePt)
			)
			(mapcar
			 '(lambda ( #Eg$ )
					(if (equal (cdr #Eg$) #ePt)
						(setq #sName #sTmp)
					)
					(setq #sTmp (cdr #Eg$))
				)
				(entget #eSf)
			)
		)
	)

	#sName
)

;*<HOM>***********************************************************************
; * <関数名>      : JudgeNaigai
; * <機能概要>    : 注目点に対する多角形の内外判定を行う。
; * <戻り値>      : T:ON_LINE or INSIDE nil:OUTSIDE
; * <作成者>      : T.MURATA (BY C)
; * <作成日付>    : 94/05/25
; * <引数>        :
; *           lNX : 注目点Ｘ座標
; *           lNY : 注目点Ｙ座標
; *          *lHX : 多角形Ｘ座標ポインタ
; *          *lHY : 多角形Ｙ座標ポインタ
; *         iNpnt : 多角形頂点数
; * <備考>        : 最終点は始点と同じ座標の点とすること。
;************************************************************************>MOH<*/
(defun JudgeNaigai (
	&pt         ; 注目点
	&plst$      ; 多角形の座標リスト
	/
	#cnt #eps #x2 #y2 #i #ret #x1 #y1 #dis #ang #aa #bb #cc #dd #dx #dy
	)

; 02/12/13 YM ADD-S
(setq #dumPT$ nil)
(foreach pt &plst$
	(setq #dumPT (list (car pt)(cadr pt)))
	(setq #dumPT$ (append #dumPT$ (list #dumPT)))
)
(setq &plst$ #dumPT$) ; 2D化
; 02/12/13 YM ADD-E

	;初期化
	(setq #cnt 0)
	(setq #eps 0.000001)
	;注目点から引いた反直線上の交点をカウントする
	(setq #x2 (car (car &plst$)))
	(setq #y2 (cadr(car &plst$)))
	(setq #i 1)
	(setq #ret nil)
	(while (and(< #i (length &plst$)) (= nil #ret))

		(setq #x1 #x2                    ; １点目X座標
					#y1 #y2                    ; １点目Y座標
					#x2 (car (nth #i &plst$))  ; ２点目X座標
					#y2 (cadr(nth #i &plst$))  ; ２点目Y座標
		)

		;追加  99/12/22
		(setq #dis (distance (list #x1 #y1)(list #x2 #y2)))
		(setq #ang (angle    (list #x1 #y1)(list #x2 #y2)))

		;多角形の頂点上の場合
		(if (equal 0.0 (distance &pt (list #x1 #y1)) #eps)
			 (setq #ret 0)
		)

		(if (= nil #ret)
			(progn
				(setq #aa (- #y1 #y2)
							#bb (- #x2 #x1)
							#cc (- (* #aa #x1 -1)(* #bb #y1))
							#dd (+ (* #aa #aa)   (* #bb #bb))
							#dx (/ (- (* #bb #bb (car  &pt))
												(* #aa #bb (cadr &pt))
												(* #aa #cc           )
										 )
										 #dd
									)
							#dy (/ (+ (* #aa #bb (car  &pt) -1)
												(* #aa #aa (cadr &pt))
												(* #bb #cc -1)
										 )
										 #dd
									)
				)
				(if
					(and
						(or
							(<= (* (- #dx #x1)(- #dx #x2) 0.0))
							(= #bb 0.0)
						)
						(or
							(<= (* (- #dy #y1)(- #dy #y2) 0.0))
							(= #aa 0.0)
						)
						(<
							(+
								(* (- #dx (car  &pt))(- #dx (car  &pt)))
								(* (- #dy (cadr &pt))(- #dy (cadr &pt)))
							)
							#eps
						)
						;追加  99/12/22
						(and
							(equal (angle (list #x1 #y1) &pt) #ang #eps)
							(< (distance  (list #x1 #y1) &pt) #dis)
						)
					)
					(setq #ret 0)
				)
			)
		)
		(if
			(and
				(or(and(<= #y1 (cadr &pt))(<(cadr &pt) #y2))
					 (and(<= #y2 (cadr &pt))(<(cadr &pt) #y1))
				)
				(= nil #ret)
			)
			(if (> (/ (*(- #x2 #x1) (-(cadr &pt) #y1)) (- #y2 #y1)) (- (car  &pt) #x1))
				(setq #cnt (1+ #cnt))
			)
		)

		;カウントアップ
		(setq #i (1+ #i))
	)
	(if(= nil #ret)
		(setq #ret (1-(* 2(rem #cnt 2))))
	)

	(if (or (= 1 #ret) (= 0 #ret))
		T
		nil
	)
)

;<HOM>*************************************************************************
; <関数名>    : DivideSymParts
; <処理概要>  : キッチン又はダイニング毎にシンボルを分ける
; <戻り値>    : シンボルリスト
; <備考>      :
; <作成>      : 99/11/18
;*************************************************************************>MOH<
(defun DivideSymParts (
	&ss         ; ダイニングのシンボル選択セット
	/
	#i #en$ #sym$ #sym$$ #work$ #ee #ss #en #ss$
	)
	;選択セット -> 図形名リスト
	(setq #i 0)
	(repeat (sslength &ss)
		(setq #en$ (cons (ssname &ss #i) #en$))
		(setq #i (1+ #i))
	)

	;シンボルを分ける
	(while #en$
		(setq #sym$ (SKW_GetLinkBaseCab2 (car #en$) &ss))
		(setq #sym$$ (cons #sym$ #sym$$))
		(setq #work$ nil)
		(mapcar
		 '(lambda ( #ee )
				(if (not (member #ee #sym$))
					(setq #work$ (cons #ee #work$))
				)
			)
			#en$
		)
		(setq #en$ #work$)
	)

	;図形名リスト -> 選択セットリスト
	(mapcar
	 '(lambda ( #en$ )
			(setq #ss (ssadd))
			(mapcar
			 '(lambda  ( #en )
					(ssadd #en #ss)
				)
				#en$
			)
			(setq #ss$ (cons #ss #ss$))
		)
		#sym$$
	)

	#ss$
) ; DivideSymDining

;<HOM>*************************************************************************
; <関数名>    : SKW_GetLinkBaseCab2
; <処理概要>  : 指定図形の属するベースキャビに隣接するベースキャビネットを取得する
; <戻り値>    : なし
; <作成>      : 1999-10-19  -> 1999-11-11
; <備考>      : 再帰により 隣接する基準シンボルを
;                 CG_LinkSym
;               に格納する
;
;               川本さんの関数の基準シンボルを獲得を省く
;*************************************************************************>MOH<
(defun SKW_GetLinkBaseCab2 (
	&en       ;(ENAME)  任意のシンボル図形
	&ss       ;(PICKSET)判断するシンボルの選択セットx
	/
	#enS1
	)

	(setq CG_LinkSym nil)

	;基準シンボルを検索する
	(setq #enS1 &en)
	;// ベースキャビかどうかの判定
	(if (= CG_SKK_TWO_BAS (CFGetSymSKKCode #enS1 2))
		(progn
			;// 再帰により隣接するベースキャビを検索する
			(SKW_SearchLinkBaseSym &ss #enS1)
			;// 隣接するキャビの基準シンボル図形を返す
			CG_LinkSym
		)
		nil
	)
)

;<HOM>*************************************************************************
;
; <関数名>    : Angle0to360
; <処理概要>  : 指定した角度を０から３６０度の間に変換する
; <戻り値>    : 変換後の角度
; <作成>      : 99-09-17 森本
; <備考>      ; なし
;
;*************************************************************************>MOH<

(defun Angle0to360 (
	&angle      ; 変換前の角度
	/
	#ang
	)
	(setq #ang &angle)
	(while (> 0.0 #ang)
		(setq #ang (+ #ang (* 2.0 PI)))
	)
	(while (< (* 2.0 PI) #ang)
		(setq #ang (- #ang (* 2.0 PI)))
	)
	(if (equal (* 2.0 PI) #ang 0.0001)
		(setq #ang 0.0)
	)

	#ang
) ; Angle0to360

;<HOM>*************************************************************************
; <関数名>    : chkHan
; <処理概要>  : 文字列が半角か判断
; <戻り値>    : 半角：T
; <作成>      : 99/12/02
; <備考>      :
;*************************************************************************>MOH<
(defun chkHan(
	&str
	/
	#ret #i #is
	)
	(setq #ret T)
	(setq #i 0)
	(while (and (= T #ret) (< #i (strlen &str)))
		(setq #is (ascii (substr &str (1+ #i) 1)))
		(if (not (or (<= 48 #is 57)(<= 65 #is 90)(<= 97 #is 122)))
			(setq #ret nil)
		)
		(setq #i (1+ #i))
	)
	#ret
)

;<HOM>*************************************************************************
; <関数名>    : MakeText
; <処理概要>  : 文字列作図
; <戻り値>    : 図形名
; <作成>      : 99/12/14
; <備考>      : 回転角度は0.0とする
;               図面内に指定の文字スタイルが存在しないときは、STANDARDを適用
;*************************************************************************>MOH<
(defun MakeText (
	&1          ; 文字列
	&10         ; 挿入基点
	&40         ; 文字列高さ
	&72         ; 水平方向位置
	&73         ; 垂直方向位置
	&style      ; 文字スタイル
	/
	#style
	)

	(if (tblsearch "STYLE" &style)
		(setq #style &style)
		(setq #style "STANDARD")
	)

	(entmake
		(list
			(cons 0 "TEXT")            ; TEXT
			(cons 100 "AcDbEntity")    ; サブクラスマーカー
			(cons 67 0)                ; 空間
			(cons 8 "0")               ; 画層
			(cons 100 "AcDbText")      ; サブクラスマーカー
			(cons 10 &10)              ; 挿入基点
			(cons 40 &40)              ; 文字列高さ
			(cons 1 &1)                ; 文字列
			(cons 50 0.0)              ; 回転角度
			(cons 41 1.0)              ; 相対尺度
			(cons 51 0.0)              ; 傾斜角度
			(cons 7 #style)            ; 文字スタイル
			(cons 71 0)                ; 文字生成フラグ
			(cons 72 &72)              ; 水平方向位置合わせ
			(cons 11 &10)              ; 挿入基点
			(cons 210 '(0.0 0.0 1.0))  ; 押し出し方向
			(cons 100 "AcDbText")      ; サブクラスマーカー
			(cons 73 &73)              ; 垂直方向位置合わせ
		)
	)

	(entlast)
) ; MakeText

;<HOM>*************************************************************************
; <関数名>    : DelFrontLastSpace
; <処理概要>  : 前と後のスペースを除外する
; <戻り値>    : 除外後の文字列
; <作成>      : 99/12/09
; <備考>      : なし
;*************************************************************************>MOH<

(defun DelFrontLastSpace (
	&str        ; 文字列
	/
	#str
	)
	(if (/= nil &str)
		(progn
			(setq #str &str)
			(while (and (/= 0 (strlen #str))(= 32 (ascii (substr #str 1 1))))
				(setq #str (substr #str 2))
			)
			(while (and (/= 0 (strlen #str))(= 32 (ascii (substr #str (strlen #str) 1))))
				(setq #str (substr #str 1 (1- (strlen #str))))
			)
		)
	)

	#str
) ; DelFrontLastSpace

;<HOM>*************************************************************************
; <関数名>    : JudgeStraightLine
; <処理概要>  : 座標が１直線上に存在するか判断
; <戻り値>    : true : T  false : nil
; <作成>      : 99/12/22
;*************************************************************************>MOH<
(defun JudgeStraightLine (
	&pt$        ; 座標リスト
	/
	#bpt #pt #ang$
	)
	(cond
		((= nil &pt$) nil)
		((= 1 (length &pt$)) T)
		(T
			;１直線上にあるか判断
			(setq #bpt (polar (nth 0 &pt$) (+ PI (angle (car &pt$)(cadr &pt$))) 10000))
			(mapcar
			 '(lambda ( #pt )
					(setq #ang$ (cons (angle #bpt #pt) #ang$))
				)
				&pt$
			)
			(if (apply '= (mapcar 'angtof (mapcar 'angtos #ang$)))
				T
				nil
			)
		)
	)
) ; JudgeStraightLine

;***************************************************************************
;  pt1jiHenkan
;
;  一次変換後の座標の取得
;
;  返値 : 変換後の座標
;***************************************************************************
(defun pt1jiHenkan(
		&ptOp ; 変換する座標(0 0)ベース
		&ang  ; 角度
		)

	(list
		(-(* (car  &ptOp)(cos &ang))(* (cadr &ptOp)(sin &ang)))
		(+(* (car  &ptOp)(sin &ang))(* (cadr &ptOp)(cos &ang)))
		0.
	)
)

;***************************************************************************
;  pt1jiHenkanB
;
;  基点座標付き
;  一次変換後の座標の取得
;
;  返値 : 変換後の座標
;***************************************************************************
(defun pt1jiHenkanB(
		&ptB  ; (LIST)  基点座標
		&ptOp ; 変換する座標
		&ang  ; 角度
		/
		#pt #pt_n
		)

	(setq #pt (mapcar '- &ptOp &ptB))
	(setq #pt_n
		(list
			(-(* (car  #pt)(cos &ang))(* (cadr #pt)(sin &ang)))
			(+(* (car  #pt)(sin &ang))(* (cadr #pt)(cos &ang)))
			0.
		)
	)
	(mapcar '+ &ptB #pt_n)
)

;<HOM>*************************************************************************
; <関数名>    : En$2Ss
; <処理概要>  : 図形名リストを選択セットにする
; <戻り値>    : 選択セット
; <備考>      :
; <作成>      : 00/01/05
;*************************************************************************>MOH<
(defun En$2Ss (
	&en$        ; 図形名リスト
	/
	#ss #en
	)
	(setq #ss (ssadd))
	(mapcar
	 '(lambda ( #en )
			(cond
				((and (= 'ENAME (type #en)) (entget #en))
					(ssadd #en #ss)
				)
				((and (= 'STR   (type #en)) (handent #en) (entget #en))
					(ssadd (handent #en) #ss)
				)
			)
		)
		&en$
	)

	(if (/= 0 (sslength #ss))
		#ss
		nil
	)
) ; En$2Ss

;<HOM>*************************************************************************
; <関数名>    : Ss2En$
; <処理概要>  : 選択セットを図形名リストにする
; <戻り値>    : 図形名リスト
; <備考>      :
; <作成>      : 00/01/05
;*************************************************************************>MOH<
(defun Ss2En$ (
	&ss         ; 選択セット
	/
	#i #en$
	)
	(if (/= nil &ss)
		(progn
			(setq #i 0)
			(repeat (sslength &ss)
				(setq #en$ (cons (ssname &ss #i) #en$))
				(setq #i (1+ #i))
			)
		)
	)

	#en$
) ; Ss2En$

;<HOM>*************************************************************************
; <関数名>    : 3dto2d
; <処理概要>  : リスト内の要素を０番目と１番目のみに変換
; <戻り値>    : リスト
; <作成>      : 99/12/08
; <備考>      : ３次元座標リストを２次元に変換する
;*************************************************************************>MOH<
(defun 3dto2d (
	&list$
	/
	)

	(mapcar
	 '(lambda ( &elm$ )
			(list (nth 0 &elm$)(nth 1 &elm$))
		)
		&list$
	)
)

;<HOM>*************************************************************************
; <関数名>    : 2dto3d
; <処理概要>  : リスト内の要素の３番目に0.0を追加する
; <戻り値>    : リスト
; <作成>      : 2000/08/17
; <備考>      : ２次元座標リストを３次元に変換する
;*************************************************************************>MOH<
(defun 2dto3d (
	&list$
	/
	)

	(mapcar
	 '(lambda ( &elm$ )
			(list (nth 0 &elm$)(nth 1 &elm$) 0.0)
		)
		&list$
	)
)

;<HOM>*************************************************************************
; <関数名>    : GetSym4Pt
; <処理概要>  : シンボル図形から、構成座標を返す
; <戻り値>    : 構成座標リスト
;               (シンボルの座標 W方向の座標 D方向の座標 H方向の座標)
; <備考>      : なし
; <作成>      : 00/02/14
;*************************************************************************>MOH<
(defun GetSym4Pt (
	&en         ; シンボル図形名
	/
	#edl$ #eds$ #spt #ang #w #d #h #ptw #ptd #pth
	#fWideAng   ; 広角度コーナー角度
	)
	(setq #edl$ (CfGetXData &en "G_LSYM"))
	(setq #eds$ (CfGetXData &en "G_SYM"))
	(setq #spt  (cdrassoc 10 (entget &en)))
	(setq #ang  (nth 2 #edl$))
	(setq #w    (nth 3 #eds$))
	(setq #d    (nth 4 #eds$))
; 02/12/13 YM ADD-S
	(if (> -0.0001 #d)
		(setq #d (- #d))
	);_if
; 02/12/13 YM ADD-E

	(setq #h    (nth 5 #eds$))
	;W
	(if (= 1 (nth 8  #eds$))
		(setq #ptw (polar #spt       #ang  #w))
		(setq #ptw (polar #spt (+ PI #ang) #w))
	)

 ; 2000/09/06 HT MOD 広角度対応 WIDECAB START
 ;;;D
 ;; (if (= 1 (nth 9  #eds$))
 ;;   (setq #ptd (polar #spt (+ (* 1.5 PI) #ang) #d))
 ;;   (setq #ptd (polar #spt (+ (* 0.5 PI) #ang) #d))
 ;; )

 ;D
	(if (setq #fWideAng (SCFGetWideCabAng #eds$))
		(progn
		; 広角度の場合
			(setq #ptd (polar #spt (+ (- (* PI 2.0) #fWideAng) #ang) #d))
		)
		(progn
		; 一般 (コーナー角度90度の場合)
		(if (= 1 (nth 9  #eds$))
			(setq #ptd (polar #spt (+ (* 1.5 PI) #ang) #d))
			(setq #ptd (polar #spt (+ (* 0.5 PI) #ang) #d))
		)
		(setq #ang (Angle0to360 (+ (* PI 1.5) (nth 2 #edl$))))
		)
	)
 ; 2000/09/06 HT MOD 広角度対応 WIDECAB END

	;H
	(if (= 1 (nth 10 #eds$))
		(setq #pth (list (car #spt) (cadr #spt) (+ (caddr #spt) #h)))
		(setq #pth (list (car #spt) (cadr #spt) (- (caddr #spt) #h)))
	)
	(list #spt #ptw #ptd #pth)
)

;<HOM>*************************************************************************
; <関数名>    : GetSym4PtDHelf
; <処理概要>  : シンボル図形から、構成座標を返す (奥行は半分)
; <戻り値>    : 構成座標リスト
;               (シンボルの座標 W方向の座標 D方向の座標 H方向の座標)
; <備考>      : なし
; <作成>      : 00/02/14
;*************************************************************************>MOH<
(defun GetSym4PtDHelf (
	&en         ; シンボル図形名
	/
	#edl$ #eds$ #spt #ang #w #d #h #ptw #ptd #pth
	#fWideAng   ; 広角度コーナー角度
	)
	(setq #edl$ (CfGetXData &en "G_LSYM"))
	(setq #eds$ (CfGetXData &en "G_SYM"))
	(setq #spt  (cdrassoc 10 (entget &en)))
	(setq #ang  (nth 2 #edl$))
	(setq #w    (nth 3 #eds$))
	(setq #d    (/ (nth 4 #eds$) 2))

	;キッチンパネルは幅Ｗが０になっているので、ダミーの値を設定する
	;(幅Ｗは通常の部材でありえない）
	(if (equal #w 0.0 0.001)
		(setq #w CG_DummyW)
	)
; 02/12/13 YM ADD-S
	(if (> -0.0001 #d)
		(setq #d (- #d))
	);_if
; 02/12/13 YM ADD-E

	(setq #h    (nth 5 #eds$))
	;W
	(if (= 1 (nth 8  #eds$))
		(setq #ptw (polar #spt       #ang  #w))
		(setq #ptw (polar #spt (+ PI #ang) #w))
	)
 ; 2000/09/06 HT MOD 広角度対応 WIDECAB START
 ;;;D
 ;; (if (= 1 (nth 9  #eds$))
 ;;   (setq #ptd (polar #spt (+ (* 1.5 PI) #ang) #d))
 ;;   (setq #ptd (polar #spt (+ (* 0.5 PI) #ang) #d))
 ;; )

 ;D
	(if (setq #fWideAng (SCFGetWideCabAng #eds$))
		(progn
		; 広角度の場合
			(setq #ptd (polar #spt (+ (- (* PI 2.0) #fWideAng) #ang) #d))
		)
		(progn
		; 一般 (コーナー角度90度の場合)
		(if (= 1 (nth 9  #eds$))
			(setq #ptd (polar #spt (+ (* 1.5 PI) #ang) #d))
			(setq #ptd (polar #spt (+ (* 0.5 PI) #ang) #d))
		)
		(setq #ang (Angle0to360 (+ (* PI 1.5) (nth 2 #edl$))))
		)
	)
 ; 2000/09/06 HT MOD 広角度対応 WIDECAB END

	;H
	(if (= 1 (nth 10 #eds$))
		(setq #pth (list (car #spt) (cadr #spt) (+ (caddr #spt) #h)))
		(setq #pth (list (car #spt) (cadr #spt) (- (caddr #spt) #h)))
	)
	(list #spt #ptw #ptd #pth)
)

;<HOM>*************************************************************************
; <関数名>    : GetSymAreaPt
; <処理概要>  : シンボル図形から、平面上の４点構成座標を返す
; <戻り値>    : 構成座標リスト
;               (シンボルの座標 W方向の座標 WD方向の座標 D方向の座標)
; <備考>      : なし
; <作成>      : 05/04/13
;*************************************************************************>MOH<
(defun GetSymAreaPt (
	&en         ; シンボル図形名
	/
	#edl$ #eds$ #spt #ang #w #d #h #ptw #ptd #pth
	#fWideAng   ; 広角度コーナー角度
	)
	(setq #edl$ (CfGetXData &en "G_LSYM"))
	(setq #eds$ (CfGetXData &en "G_SYM"))
	(setq #spt  (cdrassoc 10 (entget &en)))
	(setq #ang  (nth 2 #edl$))
	(setq #w    (nth 3 #eds$))
	(setq #d    (nth 4 #eds$))

	;W
	(if (= 1 (nth 8  #eds$))
		(setq #ptw (polar #spt       #ang  #w))
		(setq #ptw (polar #spt (+ PI #ang) #w))
	)
	;D,WD
	(if (= 1 (nth 9  #eds$))
		(progn
			(setq #ptd  (polar #spt (+ (* 1.5 PI) #ang) #d))
			(setq #ptwd (polar #ptw (+ (* 1.5 PI) #ang) #d))
		)
		(progn
			(setq #ptd  (polar #spt (+ (* 0.5 PI) #ang) #d))
			(setq #ptwd (polar #ptw (+ (* 0.5 PI) #ang) #d))
		)
	)
	(list #spt #ptw #ptwd #ptd)
)

;;;<HOM>************************************************************************
;;; <関数名>  : GetPtMinMax
;;; <処理概要>: 座標リストの最大と最小を獲得する
;;; <戻り値>  : 座標リスト
;;; <備考>    : なし
;;; <作成>    : 00/02/14
;;; <改訂>    : 01/06/17 HN 引数チェックを追加
;;;************************************************************************>MOH<
(defun GetPtMinMax
	(
	&pt$        ; 座標リスト
	/
	#min #max
	#dPt$       ; 座標値リスト
	#dPt        ; 座標値
	)
	; 01/06/17 HN S-MOD 座標値=nilをはじく処理を追加
	;@MOD@(setq #min (list (apply 'min (mapcar 'car &pt$)) (apply 'min (mapcar 'cadr &pt$))))
	;@MOD@(setq #max (list (apply 'max (mapcar 'car &pt$)) (apply 'max (mapcar 'cadr &pt$))))

	(foreach #dPt &pt$
		(if #dPt
			(setq #dPt$ (cons #dPt #dPt$))
		)
	)
	(if #dPt$
		(progn
			(setq #min (list (apply 'min (mapcar 'car #dPt$)) (apply 'min (mapcar 'cadr #dPt$))))
			(setq #max (list (apply 'max (mapcar 'car #dPt$)) (apply 'max (mapcar 'cadr #dPt$))))
			(list #min #max)
		)
		(progn
			(princ "\nGetPtMinMax 座標値異常!")
;			(setq #min (list 0.0 0.0))
;			(setq #max (list 0.0 0.0))
			nil
		)
	)
	; 01/06/17 HN E-MOD 座標値=nilをはじく処理を追加

;  (list #min #max)
) ;_GetPtMinMax

;<HOM>*************************************************************************
; <関数名>    : PtSort
; <処理概要>  : 座標と角度から、ソートする
; <戻り値>    : 座標リスト
; <作成>      : 00/01/22
; <備考>      : X座標の小さいもの順にソートする(角度=0指定)
; <備考>      : X座標の大きいもの順にソートする(角度=PI指定)
;               Y座標の大きいもの順にソートする(- (/ PI 2.0))
;               Y座標の小さいもの順にソートする   (/ PI 2.0)
;*************************************************************************>MOH<
(defun PtSort (
	&pt$        ; 座標リスト
	&angle      ; 角度
	&flg        ; 省くフラグ（T:同じ座標があればそれを省く nil:そのまま）
	/
	#pt #pth #pt$ #tmp #pt_n$
	)
	;変換座標とオリジナル座標のリストを作成する
	(mapcar
	 '(lambda ( #pt )
			(if (and (/= nil #pt)(= 'LIST (type #pt))(or (= 2 (length #pt))(= 3 (length #pt))))
				(progn
					(setq #pth (car (pt1jiHenkan #pt (Angle0to360 (- 0.0 &angle)))))
					(setq #pt$ (cons (list #pth #pt) #pt$))
				)
			)
		)
		&pt$
	)
	;ソート
	(setq #pt$ (SCFmg_sort$ 'car #pt$))
	;オリジナル座標を獲得
	(setq #pt$ (mapcar 'cadr #pt$))
	(if (/= nil &flg)
		(progn
			(setq #tmp (car #pt$))
			(setq #pt_n$ (cons (car #pt$) #pt_n$))
			;省く
			(mapcar
			 '(lambda ( #pt )
					(if (not (equal 0.0 (distance #tmp #pt) 0.0001))
						(progn
							(setq #pt_n$ (cons #pt #pt_n$))
							(setq #tmp #pt)
						)
					)
				)
				#pt$
			)
			(setq #pt$ (reverse #pt_n$))
		)
	)

	#pt$
)

;<HOM>************************************************************************
;
; <関数名>    : SCFArea_Rl
;
; <処理概要>  : 点のベクトルに対する左右の判定
;
; <戻り値>    : 1:左 -1:右 0:延長線上
;
; <備考>      : pp が sp -> ep の左右どちらにあるか判定する
;
;                                           pp( 1)
;
;                 sp =============> ep      pp( 0)
;
;                                           pp(-1)
;
;************************************************************************>MOH<
(defun SCFArea_Rl( &sp &ep &pp / #RL)
	(setq #RL(- (* (-(car &ep)(car &sp))(-(cadr &pp)(cadr &sp)))
							(* (-(car &pp)(car &sp))(-(cadr &ep)(cadr &sp)))
					 )
	)
	(cond ((> #RL 0) 1)
				((< #RL 0)-1)
				(T        0)
	)
) ; SCFArea_Rl

;<HOM>************************************************************************
;
; <関数名>    : SCFGetPerDist
;
; <処理概要>  : 点座標と２点の座標から垂線の距離を求める
;
; <戻り値>    : 距離
;
; <備考>      :          *---
;                        |  ↑
;                        |  ｜dist
;                        |  ↓
;                   *-------------------*
;************************************************************************>MOH<
(defun SCFGetPerDist (
	&pt   ; (LIST) 点座標
	&spt  ; (LIST) 線分１点目
	&ept  ; (LIST) 線分２点目
	/
	#ang #int
	)
	(setq #ang (angle &spt &ept))
	(setq #int (inters &spt &ept &pt (polar &pt (+ (* 0.5 PI) #ang) 10) nil))

	(distance &pt #int)
) ; SCFGetPerDist

;<HOM>************************************************************************
;
; <関数名>    : SCFmg_sort$
;
; <処理概要>  : 条件付きリストのリストのマージソートを行う
;
; <戻り値>    : ソートされたリスト
;
;
; <作成>      : 96-11-01 中村 靖
;
; <備考>      : (SCFmg_sort$ 'cadr '((6 5 4 3)(8 7 1 2)(1 2 3 4)(2 3 4 5)))
;
;************************************************************************>MOH<
(defun SCFmg_sort$(
		&func ; 比較関数
		&L1$  ;ソートを行うリスト
		/
		#i1 #Ltmp$ #L2$ #itmp #flg #ret$ #ret #ret$$
		)

	(if (and(= 'LIST(type &L1$))(/= 0 (length &L1$)))
		(progn
			(setq #i1 1)                                  ;#i1     &L1$$ｶｳﾝﾀ
			(setq #Ltmp$ '())                             ;#Ltmp$ 一時比較用ﾘｽﾄ
			(setq #L2$   '())                             ;#Ltmp$   一時比較用ｶｳﾝﾀ
			(setq #Ltmp$ (cons (nth 0 &L1$) #Ltmp$))      ;#L2$   結果ﾘｽﾄ(返値)
			(setq #L2$   #Ltmp$)                          ;#flg    挿入前 nil  挿入後 T
			(while (< #i1 (length  &L1$))
				(setq #Ltmp$ (reverse #L2$))
				(setq #L2$ '())
				(setq #itmp  0)
				(setq #flg nil)
				(while (< #itmp (length #Ltmp$))
					(cond
						((> (apply &func (list(nth #i1   &L1$  )))                     ;比較値より小
								(apply &func (list(nth #itmp #Ltmp$)))
						 )
							(setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
						)
						((and (= #flg nil)
									(<= (apply &func (list(nth #i1 &L1$)))                   ;比較値より大
											(apply &func (list(nth #itmp #Ltmp$)))
									)
						 )
							(setq #L2$ (cons (nth #i1   &L1$  ) #L2$))
							(setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
							(setq #flg T)
						)
						(T                                                        ;代入後
							(setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
						)
					)
					(setq #itmp (1+ #itmp))
				)
				(if (= #flg nil)                                              ;比較値が最大
					(setq #L2$ (cons (nth #i1   &L1$  ) #L2$))
				)
				(setq #i1 (1+ #i1))
			)
			(setq #ret$ (reverse #L2$))
		)
	)
	(mapcar
	 '(lambda ( #ret )
			(if (/= nil #ret)
				(setq #ret$$ (cons #ret #ret$$))
			)
		)
		#ret$
	)

	(reverse #ret$$)
) ; SCFmg_sort$

;<HOM>*************************************************************************
; <関数名>    : GetDimHeight
; <処理概要>  : 寸法線の高さを獲得
; <戻り値>    : 高さ
; <作成>      : 00/01/22
; <改訂>      : 01/05/28
; <備考>      :
;*************************************************************************>MOH<
(defun GetDimHeight (
	&iti        ; ０～
	/
	#plus
	)
	; 01/05/28 HN S-MOD 引数=nilの場合は１行分加算
	;@MOD@(setq #plus (* CG_DimHeight_1Line &iti))
	(if &iti
		(setq #plus (* CG_DimHeight_1Line &iti))
		(setq #plus (* CG_DimHeight_1Line    1))
	)
	(+ CG_DimHeight_Offset #plus)
	; 01/05/28 HN E-MOD 引数=nilの場合は１行分加算
)

;<HOM>*************************************************************************
; <関数名>    : SCFGetWrktXdata
; <処理概要>  : ワークトップ図形の拡張データ取得
; <戻り値>    : 拡張データリスト
;               （
;                 （ＷＴ奥行き ＷＴ厚さ ＢＧの有無 ＢＧ高さ）  ; シンク側、一体型
;                 （ＷＴ奥行き ＷＴ厚さ ＢＧの有無 ＢＧ高さ）  ; コンロ側
;                   ...
;               ）
; <備考>      : データが無いときnil
;               現状ではデータ数は２個
; <作成>      : 1998-07-06
;*************************************************************************>MOH<
(defun SCFGetWrktXdata (
	&layer   ; (STR)      ワークトップが有る画層
	/
	#ss #i #en #eg #eed$ #data$ #wtdt$ #gasu$
	)
	; ワークトップ図形取得
	(setq #ss (ssget "X" (list (cons 8 &layer) (list -3 (list "G_WRKT")))))
	(if (/= nil #ss)
		(progn
			(setq #i 0)
			(repeat (sslength #ss)

				; 図形名取得
				(setq #en    (ssname #ss #i))
				; 図形データ取得
				(setq #eg    (entget #en '("G_WRKT")))

				; 拡張データ取得
				(setq #eed$  (cadr (assoc -3 #eg)))
				; 拡張データ属性取得
				(setq #data$ (mapcar 'cdr (cdr #eed$)))

				(if (< 11 (length #data$))
					(cond
			; 2000/06/06 土屋 カットタイプ番号は文字タイプコーディングミス修正
			; 2000/06/06 土屋  WTタイプ シンクガス 一体型 = (0 or -999)対応
						;((or (=  0 (nth 7 #data$)) (and (/= 0 (nth 7 #data$))(= 0 (nth 5 #data$))))
						((or (=  "00" (nth 7 #data$))
								 (and (/= "00" (nth 7 #data$))(or (= 0 (nth 5 #data$)) (= -999 (nth 5 #data$))
																									(= "" (nth 5 #data$)))));03/11/28 YM ADD
						 ; 2000/06/30 HT 下端取りつけ高さも利用するため付加
			 ;(setq #wtdt$ (list (nth 9 #data$)(nth 10 #data$)(nth 11 #data$)(nth 12 #data$)))
							(setq #wtdt$ (list (nth 9 #data$)(nth 10 #data$)(nth 11 #data$)(nth 12 #data$)(nth 8 #data$)))
						)

						;((and (/= 0 (nth 7 #data$))(= 1 (nth 5 #data$)))
						((and (/= "00" (nth 7 #data$))(= 1 (nth 5 #data$)))
							(setq #gasu$ (list (nth 9 #data$)(nth 10 #data$)(nth 11 #data$)(nth 12 #data$)))
						)
					)
				)
				(setq #i (1+ #i))

			) ; end repeat
			;// 990405 S.Kawamoto Modify
			;// ワークＬでカットなしの場合はワークスペース側のワークトップ奥行き拡張データを設定する
			; ワークＬなし。
			; CG_Type2Code = "W"　となることはなし。(プラン検索以外では使わない変数)
			;(if (and (= CG_Type2Code "W") (= 1 (sslength #ss)))
			;  (progn
			;    (setq #gasu$ (list (nth 30 #data$) (nth 10 #data$)(nth 11 #data$)(nth 12 #data$)))
			;  )
			;)
		)

	)

	(list #wtdt$ #gasu$)
) ; SCFGetWrktXdata


;<HOM>*************************************************************************
; <関数名>    : GetPolyVertex
; <処理概要>  : ポリラインの頂点を取得する
; <戻り値>    :
; <作成>      : 2000-06-09
; <備考>      :
;*************************************************************************>MOH<

(defun GetPolyVertex( &en / #typ #num$ #eg #i)
	(setq #typ (cdr (assoc 0 (entget &en))))
	(cond
		((= "LWPOLYLINE" #typ) ;R14対応
			(setq #eg (entget &en))
			(setq #i 0)
			(while (< #i (length #eg))
				(if (= 10 (car (nth #i #eg)))
				(progn
					(setq #num$ (append #num$ (list (cdr (nth #i #eg)))))
					(setq #i (+ #i 4))
				)
				;else
				(progn
					(setq #i (1+ #i))
				)
				)
			)
		)
		((= "POLYLINE" #typ)
			(setq &en   (entnext &en) #num$ '())
			(while &en
				(setq #eg(entget &en))
				(if(= "VERTEX" (cdr(assoc 0 #eg))) ;ポリラインの頂点の場合
					(setq #num$ (cons (list (nth 0 (cdr (assoc 10 #eg)))
																	(nth 1 (cdr (assoc 10 #eg)))) #num$))
				)
				(setq &en (entnext &en))
			)
		)
		( T
			(princ "\nポリラインではありません。")
		)
	)
	#num$
)


;<HOM>*************************************************************************
; <関数名>    : SCFGetWkTopXData
; <処理概要>  : シンク・コンロの配置された(=品番にシンク穴加工なし)
;             : ワークトップの図形名を取得する
; <戻り値>    : (#en #en ・・・) or ワークトップ存在しない時 nil
; <作成>      : 2000/08/17
; <備考>      : ワークトップ1つの時は、品番にシンク穴加工なし条件をいれない
;*************************************************************************>MOH<

(defun SCFGetWkTopXData (
	/
	#i           ; カウンタ
	#xSs         ; "G_WRKT"の選択セット
	#Ret$        ; 戻り値
	#eEn$        ; ワークトップ図形名
	#Ed$         ; XData
	#sSinkkakou  ; シンク穴加工
	#sHinban     ; 品番
	)
	(setq #Ret$ nil #eEn$ nil)
	(setq #xSs (ssget "X" (list (list -3 (list "G_WRKT")))))
	(if (/= #xSs nil)
		(progn
			(if (= (sslength #xSs) 1)
				(progn
					(setq #eEn$ (list (ssname #xSs 0)))
				)
				(progn
					(setq #i 0)
					(repeat (sslength #xSs)
						(setq #Ed$ (CfGetXData (ssname #xSs #i) "G_WRKT")) ; 00/11/28 YM MOD
						(setq #ANA (nth 18 #Ed$)) ; ｼﾝｸ穴の数 ; 00/11/28 YM MOD
						; 品番にシンク穴加工なしでない場合は数える
						(if (> #ANA 0) ; 00/11/28 YM MOD
							(setq #eEn$ (append #eEn$ (list (ssname #xSs #i))))
						)
;;;11/28YM@		        (setq #Ed$ (CfGetXData (ssname #xSs #i) "G_WTSET"))
;;;11/28YM@			; 品番を取得
;;;11/28YM@		        (setq #sHinban (nth 1 #Ed$))
;;;11/28YM@		        (setq #sSinkkakou nil)
;;;11/28YM@		        (if (> (strlen #sHinban) 8)
;;;11/28YM@		          (setq #sSinkkakou (substr #sHinban 8 1))
;;;11/28YM@		          (princ "ワークトップの品番が不正です。")
;;;11/28YM@		        )
;;;11/28YM@		        ; 品番にシンク穴加工なしでない場合は数える
;;;11/28YM@		        (if (/= #sSinkkakou "A")
;;;11/28YM@		          (progn
;;;11/28YM@		          	(setq #eEn$ (append #eEn$ (list (ssname #xSs #i))))
;;;11/28YM@		          )
;;;11/28YM@		        )
						(setq #i (1+ #i))
					);repeat
				)
			)
		)
	)
#eEn$
)


;<HOM>*************************************************************************
; <関数名>    : SCFGetDummyWPt
; <処理概要>  : ダミー点(G_SKDM "W")を取得する
; <戻り値>    : ((XData #10) (XData #10) ・・・)
; <作成>      : 2000/08/17
; <備考>      :
;*************************************************************************>MOH<

(defun SCFGetDummyWPt (
	/
	#i     ; カウンタ
	#xSs   ; "G_SKDM"の選択セット
	#Lst$  ; ((G_SKDMのXData + #10)(G_SKDMのXData + #10) ・・・)
	#eEn   ; "G_SKDM"図形名
	#Ed$   ; XData
	#10    ; 座標
	)
	(setq #Lst$ '())
	(setq #xSs (ssget "X" (list (list -3 (list "G_SKDM")))))
	(if (/= nil #xSs)
		(progn
			(setq #i 0)
			(repeat (sslength #xSs)
				(setq #eEn  (ssname #xSs #i))
				(setq #Ed$ (CfGetXData #eEn "G_SKDM"))
				(if (= (nth 1 #Ed$) "W")
	 			 (progn
					(setq #10  (cdrassoc 10 (entget #eEn)))
					(setq #Lst$ (append #Lst$ (list (append #Ed$ (list #10)))))
					)
				)
				(setq #i (1+ #i))
			)

			(setq #Lst$ (CFListSort #Lst$ 2))
		)
	)
)


;<HOM>*************************************************************************
; <関数名>    : SCFGetDummyWPtSort
; <処理概要>  : ダミー点(G_SKDM "W")をモデル番号順リストで返す
; <戻り値>    : ((#pt #pt #pt) (#pt #pt #pt) ・・・)
; <作成>      : 2000/08/17
; <備考>      :
;*************************************************************************>MOH<

(defun SCFGetDummyWPtSort (
	/
	#Lst$      ; ((G_SKDMのXData + #10)(G_SKDMのXData + #10) ・・・)
	#OldNo     ; モデル番号
	#iCnt      ; 個数
	#W$        ; 戻り値
	#1ModelW$  ; モデル番号同一のもの
	)
	; ダミー点(G_SKDM "W")の拡張データを取得する (モデル番号順にソートされている)
	; ((XData #10) (XData #10) ・・・)
	(setq #Lst$ (SCFGetDummyWPt))

	(if #Lst$
		(progn
			(setq #iCnt 1)
			(setq #OldNo (nth 2 (car #Lst$)))
			(setq #W$ '())
			(setq #1ModelW$ '())
			; モデル番号毎にリストにまとめる。
			(mapcar '(lambda (#L$)
				(if (/= (nth 2 #L$) #OldNo)
					(progn
						; 頂点番号順にソートする
						(setq #1ModelW$ (CFListSort #1ModelW$ 3))
						; 頂点のみ抽出してリストに追加する
						; ((#pt #pt #pt) (#pt #pt #pt) ・・・)
						(setq #W$ (append #W$ (list (mapcar 'last #1ModelW$))))
						(if (/= #iCnt (length #Lst$))
							(progn
							; 最後以外は、クリア
							(setq #1ModelW$ '())
							)
						)
					)
				)
				; モデル番号の同じものをため込む
				(setq #1ModelW$ (append #1ModelW$ (list #L$)))
				; モデル番号保存
				(setq #OldNo (nth 2 #L$))
				(setq #iCnt (1+ #iCnt))
				)
				#Lst$
			)
			; 最後のモデル番号のものをリストに加える
			(setq #1ModelW$ (CFListSort #1ModelW$ 3))
			; 戻り値 #W$
			(setq #W$ (append #W$ (list (mapcar 'last #1ModelW$))))
		)
	)
	#W$
)


;<HOM>*************************************************************************
; <関数名>    : SCFGetGasCab10
; <処理概要>  : ガスキャビネットの座標を返す
; <戻り値>    : (#pt #pt #pt)
; <作成>      : 2000/08/17
; <備考>      :  (図面内に１つであることが保証されていること)
;*************************************************************************>MOH<

(defun SCFGetGasCab10 (
	/
	#i     ; カウンタ
	#xSs   ; "G_SKDM"の選択セット
	#eEn   ; "G_SKDM"図形名
	#Ed$   ; XData
	#10    ; 座標
	#code$ ; 性格CODE
	#pt$
)

	; 06/09/27 T.Ari Mod-S ワークトップがなくコンロキャビがあるプラン対応
	(setq #xSs (ssget "X" (list (list -3 (list "G_LSYM")))))
	(if (/= nil #xSs)
		(progn
			(setq #i 0)
			(repeat (sslength #xSs)
				(setq #eEn	(ssname #xSs #i))
				(setq #code$ (CFGetSymSKKCode #eEn nil))
				(if (and #code$
							 (CfGetXData #eEn "G_SKDM")
							 (= CG_SKK_ONE_CAB (nth 0 #code$))
							 (= CG_SKK_TWO_BAS (nth 1 #code$))
							 (= CG_SKK_THR_GAS (nth 2 #code$)))
					(progn
						(setq #10 (cdrassoc 10 (entget #eEn)))
						(if (and
									(= (nth 5 (CfGetXData #eEn "G_SKDM")) "W")
									(= (nth 1 (CfGetXData #eEn "G_SKDM")) "D")
									(= (nth 6 (CfGetXData #eEn "G_LSYM")) "L")
								)
							(progn
								(setq #pt$ (Get2PointByLay #eEn 1))
								(if (< (distance (nth 0 #pt$) #10) (distance (nth 1 #pt$) #10))
									(setq #10 (nth 1 #pt$))
									(setq #10 (nth 0 #pt$))
								)
							)
						)
					)
				)
				(setq #i (1+ #i))
			)
		)
	)
	#10
	; 06/09/27 T.Ari Mod-E ワークトップがなくコンロキャビがあるプラン対応
)

;<HOM>*************************************************************************
; <関数名>    : SCFGetMeWorkTopEn$
; <処理概要>  : 図面に存在するメラミンワークトップの図形名を取得
; <戻り値>    : (#en #en ・・・)   存在しない時 : nil
; <備考>      :
; <作成>      : 2000/08/      HT
;*************************************************************************>MOH<

(defun SCFGetMeWorkTopEn$ (
	/
	#eEn   ; 図形名
	#Ed$   ; G_LSYM拡張データ
	#iSKK  ; 性格CODE
	#xSs   ; "G_LSYM"選択セット
	#i
	#Lst$  ; 戻り値 図形名リスト ないとき nil
	)

	; シンボル基準点取得
	(setq #xSs (ssget "X" (list (cons 0 "POINT")(list -3 (list "G_LSYM") ))))
	(if (= #xSs nil)(setq #xSs (ssadd))) ; 00/09/19 YM ADD
	(setq #i 0)
	(setq #Lst$ '())
	(repeat (sslength #xSs)
		(setq #XD$ (CfGetXData (ssname #xSs #i) "G_LSYM"))
		; 性格CODE=CG_SKK_ONE_CNT CG_SKK_TWO_BAS CG_SKK_THR_ETC
		(if (= (+ (* CG_SKK_ONE_CNT 100) (* CG_SKK_TWO_BAS 10) CG_SKK_THR_ETC) (nth 9 #XD$))
			(progn
			; メラニンワークトップなら図形名をリストにためる
			(setq #Lst$ (append #Lst$ (list (ssname #xSs #i))))
			)
		)
		(setq #i (1+ #i))
	)
#Lst$
)


;<HOM>*************************************************************************
; <関数名>    : SCFCmnXYSortByX
; <処理概要>  : X座標Y座標の順でソートする
; <戻り値>    : (((X1 Y1)(X1 Y2)(X1 Y3)・・)((X2 Y1)(X2 Y2)(X2 Y3)・・・))
; <作成>      : 2000/08/17
; <備考>      :
;*************************************************************************>MOH<

(defun SCFCmnXYSortByX (
	&pt$
	/
	#pt$      ; X座標でソート
	#newpt$   ; X座標でソート
	#i        ; カウンタ
	#tmp$     ; tmp
	#pold     ; １つ手前の座標
	)
	(setq #pt$ &pt$)
	; 2000/07/12 X座標Y座標の順でソートする
	; ((X1 Y1)(X1 Y2)(X1 Y3)・・(X2 Y1)(X2 Y2)(X2 Y3)・・・)
	(setq #pt$ (SCFmg_sort$ 'car #pt$))
	(setq #newpt$ '() #i 1 #pold (car (nth 0 #pt$)))
	(foreach #p #pt$
		(if (= #i (length #pt$))
			(progn
				(setq #tmp$ (append #tmp$ (list #p)))
				(setq #tmp$ (SCFmg_sort$ 'cadr #tmp$))

				(setq #newpt$ (append #newpt$ (list #tmp$)))
			)
			(progn
				(if (not (equal (car #p) #pold 0.1))
					(progn
						(setq #pold (car #p))
						(setq #tmp$ (SCFmg_sort$ 'cadr #tmp$))

						(setq #newpt$ (append #newpt$ (list #tmp$)))
						(setq #tmp$ '())
						(setq #tmp$ (append #tmp$ (list #p)))
					)
					(progn
						(setq #tmp$ (append #tmp$ (list #p)))
					)
				)
			)
		)
		(setq #i (1+ #i))
	)
	#newpt$
)


;<HOM>*************************************************************************
; <関数名>    : SCFGetWideCabAng
; <処理概要>  : 広角度のコーナーキャビネットの角度を取得する
; <戻り値>    : コーナーキャビネットの角度
;             : 広角度のコーナーキャビネットでない場合 : nil
; <備考>      :
; <作成>      : 2000/09/06 HT MOD 広角度対応 WIDECAB
;*************************************************************************>MOH<

(defun SCFGetWideCabAng (
	&Xdata$ ; キャビネットのシンボル基準点のXData (G_SYM)
	/
	#ang   ; コーナー角度
	#fRet  ; 戻り値
	)

	; コーナー角度取得
	(setq #ang (nth 2 &Xdata$))
	(if (= #ang "")
		(progn
		; XDataにデータがセットされていない場合は一般のキャビネット
		(setq #fRet nil)
		)
		(progn
			(if (equal (atof #ang) 0.0 0.1)
				(setq #fRet nil)
				(setq #fRet (dtr (atof #ang)))  ; 広角度キャビネットの場合
			)
		)
	)

#fRet
)


;<HOM>*************************************************************************
; <関数名>    : SCF_ClearGlobal
; <処理概要>  : 出力関連のグローバル初期化
; <戻り値>    : なし
; <備考>      :
; <作成>      : 2000/09/07 HT
;*************************************************************************>MOH<

(defun SCF_ClearGlobal ( / )
	(if CG_OUTCMDNAME
		(progn
		(setq CG_OUTCMDNAME      nil) ; コマンド名格納 (展開図作成コマンド"SCFMakeMaterial")
		(setq CG_DimOffLen        nil) ; 施工寸法関連
		(setq CG_KitType          nil) ; キッチンタイプ I型 U型    "I-LEFT" "I-RIGHT"
																	 ;  L型        "L-LEFT" "L-RIGHT"
																	 ;  ダイニング "D-RIGHT"
		(setq CG_UTypeWT          nil) ; ワークトップの形状タイプ=U型がある場合 T
		;;; CG_FigureScale      挿入図形の高さ (定数定義なので初期化禁止)
		;;; CG_LayTitleH        図面枠表題尺度１の時の文字高さを2 (定数定義なので初期化禁止)
		;;;                     (これを基準に尺度が求められる)
		;;; CG_LayTitleTag      図面枠表題のタグ (定数定義なので初期化禁止)
		(setq CG_Pattern          nil) ; テンプレートファイル名リスト ※
		(setq CG_PatNo            nil) ; テンプレートファイル名リストの要素番号 ※
		(setq CG_RyoNo            nil) ; 領域No ※
		(setq CG_KitType          nil) ; キッチンタイプ ex) I-RIGHTなど ※
		(setq CG_TitleStr         nil) ; 図面枠表題 ※
			;※ レイアウトコマンドで、テンプレートをopenして処理を行うためグローバルに情報保存する
		(setq CG_DimPat           nil) ; 寸法制御設定
		(setq CG_DOORLST          nil) ; 扉模様図形と基準点シンボルの関連 (定数定義なので初期化禁止)
		)
	)
	(princ)
)


;<HOM>*************************************************************************
; <関数名>    : SCFEndShori
; <処理概要>  : コマンド終了処理
; <戻り値>    : なし
; <備考>      :
; <作成>      : 2000/09/07 HT
;*************************************************************************>MOH<

(defun SCFEndShori ( / )
	; 出力関連のグローバル nil
	(SCF_ClearGlobal)

;;;	(if (/= CG_AUTOMODE 1) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
;;;  	(setq *error* nil)
;;;	);_if

	; 02/09/04 YM MOD-S
	(if (= CG_AUTOMODE 0) ; ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ,WEB版ではｴﾗｰ関数を初期化しない
		(setq *error* nil)
	);_if
	; 02/09/04 YM MOD-E

	(princ)
)

;<HOM>*************************************************************************
; <関数名>    : SCFStartShori
; <処理概要>  : コマンド開始処理
; <戻り値>    : なし
; <備考>      :
; <作成>      : 2000/09/08 HT
;*************************************************************************>MOH<

(defun SCFStartShori (
	&CommandName
	/
	)
	(setq CG_OUTCMDNAME &CommandName)

;;;	(if (/= CG_AUTOMODE 1) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
;;;  	(setq *error* nil)
;;;	);_if

	; 02/09/04 YM MOD-S
	(if (= CG_AUTOMODE 0) ; ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ,WEB版ではｴﾗｰ関数を初期化しない
		(setq *error* nil)
	);_if
	; 02/09/04 YM MOD-E

	(princ)
)


;<HOM>*************************************************************************
; <関数名>    : OmitAssocNo
; <処理概要>  : 図形データから、要らないものを省く
; <戻り値>    : 図形データ
; <作成>      : 00/04/12
; <備考>      : なし
;*************************************************************************>MOH<

(defun OmitAssocNo (
	&eg         ; 図形データ
	&no$        ; 要らないグループ番号
	/
	#ed #list$
	)
	(mapcar
	 '(lambda ( #ed )
			(if (not (member (car #ed) &no$))
				(setq #list$ (cons #ed #list$))
			)
		)
		&eg
	)
	(reverse #list$)
) ; OmitAssocNo


;<HOM>***********************************************************************
; <関数名>    : SCF_GroupCopyLayer
; <処理概要>  : 指定した画層にグループの図形をコピーする
; <戻り値>    : コピーした図形名リスト
; <備考>      : 2000/06/22 HT成
;             : ブレークライン(XData=G_BRK)はコピーしない
;***********************************************************************>HOM<

(defun SCF_GroupCopyLayer (
		&enGroup    ; グループ化したグループのグループ名
		&strLayer   ; 移動先画層名
		/
		#Name$      ; グループ内の図形名格納用
		#Data$      ; グループ内の図形データのデータリスト格納用

		#nn         ; foreach用
		#lst$       ; 図形名リスト
	)
	(setq #Name$ (entget &enGroup))
	(setq #lst$ '())
	;; データリスト数分ループ
	(foreach #nn #Name$
		;; グループ構成図形名データかどうかのチェック
		(if (= (car #nn) 340)
			(progn    ; 図形名データだった
				;; その図形のデータを取得する
				(setq #Data$ (entget (cdr #nn) '("*")))
				(if (= (CFGetXData (cdr #nn) "G_BRK") nil)
					(progn
						;; 図形内の画層情報を書き換える(画層の移動)
						(entmake (subst (cons 8 &strLayer) (assoc 8 #Data$) #Data$))
				(setq #lst$ (append #lst$ (list (entlast))))
					)
				)
			)
		)
	)
	#lst$
) ; SCF_GroupCopyLayer


;<HOM>***********************************************************************
; <関数名>    : SCF_CopyLayer
; <処理概要>  : 指定した画層に図形をコピーする
; <戻り値>    : コピーした図形名リスト
; <備考>      : 2000/06/22 HT作成
;             : ブレークライン(XData=G_BRK)はコピーしない
;***********************************************************************>HOM<

(defun SCF_CopyLayer (
		&en$        ; 図形名リスト
		&strLayer   ; 移動先画層名
		/
		#Name$      ; グループ内の図形名格納用
		#Data$      ; グループ内の図形データのデータリスト格納用

		#nn         ; foreach用
		#lst$       ; 図形名リスト
	)
	(setq #lst$ '())
	;; データリスト数分ループ
	(foreach #nn &en$
		;; グループ構成図形名データかどうかのチェック
		;; その図形のデータを取得する
		(setq #Data$ (entget #nn '("*")))
		;; 図形内の画層情報を書き換える(画層の移動)
		(if (= (CFGetXData #nn "G_BRK") nil)
			(progn
			(entmake (subst (cons 8 &strLayer) (assoc 8 #Data$) #Data$))
			(setq #lst$ (append #lst$ (list (entlast))))
			)
		)
	)
	#lst$
)
;SCF_CopyLayer


;<HOM>***********************************************************************
; <関数名>    : SCF_LayDispOn
; <処理概要>  : 非表示orフリーズorロック解除する
; <戻り値>    : なし
; <備考>      : 2000/06/30 HT作成
;***********************************************************************>HOM<

(defun SCF_LayDispOn (
	&lay$  ; 画層リスト
	/
	#lay   ; 画層図形名
	)
	(setq #i 0)
	(repeat (length &lay$)
		(if (setq #Eg$ (tblsearch "LAYER" (setq #lay (nth #i &lay$))))
			(progn
			(if (or (/= (cdr (assoc 70 #Eg$)) 0) (< (cdr (assoc 62 #Eg$)) 0))
				(command "-LAYER" "T" #lay "U" #lay "ON" #lay "")
			)
			)
		)
		(setq #i (1+ #i))
	)
) ; SCF_LayDispOn

;<HOM>***********************************************************************
; <関数名>    : KCF_LayMake
; <処理概要>  : 画層がなかったら作成する
; <戻り値>    : なし
; <備考>      : 02/04/08 YM
;***********************************************************************>HOM<
(defun KCF_LayMake (
	&lay$  ; 画層リスト
	/
	#I
	)
	(setq #i 0)
	(foreach lay &lay$
		; 画層の作成
		(if (tblsearch "LAYER" lay)
			(progn
				(command "_layer" "U" lay "")  ; 警告メッセージ対策で2文に分けた  Uﾛｯｸ解除
				(command "_layer" "ON" lay "T" lay "")  ; ON表示 Tﾌﾘｰｽﾞ解除
			 )
			(command "_layer" "N" lay "C" 7 lay "L" SKW_AUTO_LAY_LINE lay "")
		);_if
	);foreach
	(princ)
); KCF_LayMake

;<HOM>***********************************************************************
; <関数名>    : SCF_LayFreezeOff
; <処理概要>  : フリーズ解除する
; <戻り値>    : なし
; <備考>      : 2000/10/23 HT作成
;***********************************************************************>HOM<

(defun SCF_LayFreezeOff (
	&lay$  ; 画層リスト
	/
	#lay   ; 画層図形名
	)
	(setq #i 0)
	(repeat (length &lay$)
		(if (setq #Eg$ (tblsearch "LAYER" (setq #lay (nth #i &lay$))))
			(progn
			(if (or (/= (cdr (assoc 70 #Eg$)) 0))
				(command "-LAYER" "T" #lay "")
			)
			)
		)
		(setq #i (1+ #i))
	)
) ; SCF_LayFreezeOff


;<HOM>***********************************************************************
; <関数名>    : SCF_LayFreezeOn
; <処理概要>  : 非表示andフリーズする
; <戻り値>    : なし
; <備考>      : 2000/10/23 HT作成
;***********************************************************************>HOM<

(defun SCF_LayFreezeOn (
	&lay$  ; 画層リスト
	/
	#lay   ; 画層図形名
	)
	(setq #i 0)
	(repeat (length &lay$)
		(if (setq #Eg$ (tblsearch "LAYER" (setq #lay (nth #i &lay$))))
			(progn
			; フリーズされていなければフリーズにする
			(if (= (cdr (assoc 70 #Eg$)) 0)
				(command "-LAYER" "F" #lay "OF" #lay "")
			)
			; 非表示でなければ非表示にする
			(if (< (cdr (assoc 62 #Eg$)) 0)
				(command "-LAYER" "OF" #lay "")
			)
			)
		)
		(setq #i (1+ #i))
	)
) ; SCF_LayFreezeOn


;<HOM>************************************************************************
; <関数名>  : CFScriptDwgOpen
; <処理概要>: スクリプトにより図面をオープンする
; <戻り値>  :
; <備考>    :
;************************************************************************>MOH<

(defun CFScriptDwgOpen (
	&mode       ;(INT) 0: 新規図面(new)  1:既存図面(open)
	&fname      ;(STR)ファイル名称またはテンプレート名称
	/
	#sm #com
	)
	(cond
		((= &mode 0) (setq #com "_.NEW"))
		(T           (setq #com "_.OPEN"))
	)

	(if (/= CG_ACAD_VER "14")
		(progn
			;// スクリプト処理のみ、なぜか DBMOD が 0 でも 4になるため、
			;// ここで強制的に 4にしておく
			;// DBMOD の値を替える
			(setq #sm (getvar "SNAPMODE"))
			(setvar "SNAPMODE" #sm)
			;(if (= (getvar "DBMOD") 0)
			;  (CFScriptCommand (list #com &fname))

			(CFScriptCommand (list #com "Y" &fname))

; 2011/08/12 YM DEL ==>subSCFConf に移動
;;;			;2011/08/11 YM ADD-S ﾊﾟｰｽ図のとき平行投影図になってしまう
;;;			(if (and CG_SCFConf (vl-string-search "立体" &fname))
;;;				(progn
;;;					(CFScriptCommand (list #com "Y" &fname "TILEMODE" "0" "_.MSPACE" "PERSPECTIVE" "1"))
;;;				)
;;;				(progn
;;;					(CFScriptCommand (list #com "Y" &fname))
;;;				)
;;;			);_if
;;;			;2011/08/11 YM ADD-E ﾊﾟｰｽ図のとき平行投影図になってしまう

		)
	;else
		(progn
			(if (= 0 (getvar "DBMOD"))
				(command #com &fname)
				(command #com "Y" &fname)
			)
		)
	)
) ;CFScriptDwgOpen

;;;<HOM>************************************************************************
;;; <関数名>  : ZUMENLayerInfo
;;; <処理概要>: 図面上の画層情報をﾘｽﾄで戻す
;;; <作成>    : 01/06/11 YM
;;; <戻り値>  : 画層情報ﾘｽﾄ
;;;************************************************************************>MOH<
(defun ZUMENLayerInfo (
	/
	#LAYERDATA #LAYERDATA$
	)
	;現在使用中の画層一覧を取得
	(setq #layerdata$ '())
	(setq #layerdata (tblnext "LAYER" T))
	(while #layerdata
		(setq #layerdata$ (append #layerdata$ (list #layerdata)))
		(setq #layerdata (tblnext "LAYER" nil))
	)
	#layerdata$
);ZUMENLayerInfo

;<HOM>************************************************************************
; <関数名>    : CFScriptCommand
; <処理概要>  : スクリプトコマンドを実行する
; <戻り値>    :
; <備考>      : (CFScriptCommand (list "_open" #fname)) 等
;;;************************************************************************>MOH<
(defun CFScriptCommand (
	&com$         ; (LIST)コマンドに引き渡すリスト
	/
	#opfn
	#com
	)
	;; スクリプトファイルを開き、openコマンドとファイル名を"u_open.scr"に記述
	(setq #opfn  (open (strcat CG_SYSPATH "script.scr") "w"))
	(foreach #com &com$
		(write-line #com #opfn)
	)
	(close #opfn)
	;; スクリプトファイル "u_open.scr" を実行
	(command "script" (strcat CG_SYSPATH "script.scr"))

	(princ)
) ;CFScriptCommand


;<HOM>***********************************************************************
; <関数名>    : SCFCmnFileOpen
; <処理概要>  : 図面ファイルをオープンする
; <戻り値>    : 成功 T 失敗 nil
; <備考>      : 2000/10/19 HT作成
;***********************************************************************>HOM<

(defun SCFCmnFileOpen (
	&sFileName  ; フルパスファイル名
	&iMode      ; 0: 新規図面(new)  1:既存図面(open)
	/
	#bRet       ; 成功 T 失敗 nil
	)
					; スクリプトファイルで図面オープンを元に戻す
					;;図面open
					;;(if (= "14" CG_ACAD_VER)
					;;  (progn
					;;    (if (= 0 (getvar "DBMOD"))
					;;      (command "_.Open"     #sFname)
					;;      (command "_.Open" "Y" #sFname)
					;;    )
					;;  )
					;;  (CFScriptDwgOpen 1 #sFname)
					;;)


	(setq #bRet nil)
	(if (findfile &sFileName)
		(progn
		; 図面の変更状況
		(CFScriptDwgOpen &iMode &sFileName)
		)
		(progn
		(CfAlertMsg (strcat "ファイル" &sFileName "がありません。"))
		)
	)
#bRet
) ; SCF_CmnFileOpen


;<HOM>*************************************************************************
; <関数名>    : SCFSystemInfo
; <処理概要>  : システム名・自社名を返す （現在未使用）
; <戻り値>    : 常にnil
; <備考>      :
; <作成>      : 2000/09/25 HT
;*************************************************************************>MOH<

(defun SCFSystemInfo (
	/
	)
;(list "KPCAD SYSTEM" "株式会社")
nil
)

;;;<HOM>************************************************************************
;;; <関数名>  : KCFGetWTHeight
;;; <処理概要>: 図面上WTを検索して最後に見つかったWT高さ文字列を返す
;;; <戻り値>  : 高さ"850"など or nil
;;; <備考>    :
;;;************************************************************************>MOH<
(defun KCFGetWTHeight (
	/
	#I #RET #SS #WT #XD$
	)
	(setq #ret nil)
	(setq #ss (ssget "X" '((-3 ("G_WRKT"))))) ; 図面上のWTを検索
	(if (and #ss (< 0 (sslength #ss)))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #WT (ssname #ss #i))
				(setq #xd$ (CFGetXData #WT "G_WRKT"))
				(setq #ret (+ (nth 8 #xd$)(nth 10 #xd$)))
				(setq #i (1+ #i))
			)
		)
	);_if
	(if (= (type #ret) 'REAL)
		(setq #ret (itoa (fix (+ #ret 0.001))))
		(setq #ret nil)
	);_if
	#RET
);KCFGetWTHeight

;;; <HOM>***********************************************************************
;;; <関数名>  : PcRequireInput
;;; <処理概要>: 必須項目の入力をユーザーに要求してフォーカスを戻す
;;; <戻り値>  : なし
;;; <備考>    : なし
;;; ***********************************************************************>MOH<
(defun PcRequireInput
	(
	&sKey       ; 対象タイルのキー名前
	&sNAM       ; 名前
	&sMSG       ; 要求メッセージの後半部
	/
	)
	(CFAlertMsg (strcat "必須入力項目 「" &sNAM "」 が未入力です。" &sMSG))
	(mode_tile &sKey 2)
	(princ)
); end of defun

;;; <HOM>***********************************************************************
;;; <関数名>  : PcCheckIntStr
;;; <処理概要>: ダイアログ中整数の部分の入力値をチェックする
;;; <戻り値>  : なし
;;; <作成>    : 00/03/11 MH
;;; <備考>    : 欄に入力があった場合、値が実数であるかチェック
;;; ***********************************************************************>MOH<
(defun PcCheckIntStr
	(
	&sKEY       ; 選択されたタイルキー
	/
	#sVAL       ; ユーザ入力された値
	)
	; 値が入力されていて、整数以外の値の場合、メッセージを出し、値を消し、フォーカスを戻す。
	(setq #sVAL (get_tile &sKEY))
	(cond
		((or (= "0" #sVAL) (= "" #sVAL)) nil)
		((and (= 'INT (type (read #sVAL))) (< 0 (read #sVAL))) nil)
		(t
			(progn
				(CFAlertMsg (strcat "値には 0～9 の半角数字以外は使用できません"))
				(set_tile &sKEY "0")
				(mode_tile &sKEY 2)
			);end of progn
		)
	); end of cond
	(princ)
); end of defun

;;; <HOM>***********************************************************************
;;; <関数名>  : PcCheckIntStrSetDefo
;;; <処理概要>: ダイアログ中整数部分の入力値をチェック条件外ならデフォ値をセット
;;; <戻り値>  : なし
;;; <作成>    : 00/03/11 MH
;;; <備考>    : 欄に入力があった場合、値が実数であるかチェック
;;; ***********************************************************************>MOH<
(defun PcCheckIntStrSetDefo
	(
	&sKEY       ; 選択されたタイルキー
	&fDefo
	/
	#sVAL       ; ユーザ入力された値
	)
	; 値が入力されていて、整数以外の値の場合、メッセージを出し、値を消し、フォーカスを戻す。
	(setq #sVAL (get_tile &sKEY))
	(cond
		((or (= "0" #sVAL) (= "" #sVAL)) nil)
		((and (= 'INT (type (read #sVAL))) (< 0 (read #sVAL))) nil)
		(t
			(progn
				(CFAlertMsg (strcat "値には 0～9 の半角数字以外は使用できません"))
				(set_tile &sKEY (itoa (fix &fDefo)))
				(mode_tile &sKEY 2)
			);end of progn
		)
	); end of cond
	(princ)
); end of defun

;;; <HOM>***********************************************************************
;;; <関数名>  : PcSetKikiColor
;;; <処理概要>: 機器色の設定
;;; <戻り値>  : なし
;;; <作成>    : 00/08/16
;;; <備考>    : なし
;;; ***********************************************************************>MOH<
(defun PcSetKikiColor
	(
	&sKikiColor
	/
	#xrec$
	)
	(setq CG_KikiColor &sKikiColor)
	(setq #xrec$ (CFGetXRecord "SERI"))
	(CFSetXRecord
		"SERI"
		(list
			(nth  0 #xrec$)
			(nth  1 #xrec$)
			(nth  2 #xrec$)
			(nth  3 #xrec$)
			(nth  4 #xrec$)
			(nth  5 #xrec$)
			(nth  6 #xrec$)
			(nth  7 #xrec$)
			(nth  8 #xrec$)
			(nth  9 #xrec$)
			(nth 10 #xrec$)
			CG_KikiColor
			(nth 12 #xrec$)
		)
	)
	(princ)
); end of defun

;;; <HOM>***********************************************************************
;;; <関数名>  : PcGetPartQLY$
;;; <処理概要>: 指定のテーブルから、品番名称をキーにクエリー取得
;;; <戻り値>  : 獲得された１つのリスト
;;; <作成>    : 00/03/17 MH
;;; <備考>    : レコードが無かった場合や複数取得の場合は、エラー出し強制終了
;;; ***********************************************************************>MOH<
(defun PcGetPartQLY$
	(
	&sTABLE
	&sHINBAN
	&sLR
	&iUSE       ; 用途番号
	/
	#QLY$
	#sMSG
	#List$
	)
	(setq #List$ (list (list "品番名称" &sHINBAN 'STR))); end of list
	(if &sLR (setq #List$ (cons (list "LR区分" &sLR 'STR) #List$)))
	(if (numberp &iUSE) (setq #List$ (cons (list "用途番号" (itoa (fix &iUSE)) 'INT) #List$)))
	(setq #QLY$ (CFGetDBSQLRec CG_DBSESSION &sTABLE #List$)); end of setq
	(cond
		((not #QLY$)
			(setq #sMSG (strcat "【" &sTABLE "】ﾃｰﾌﾞﾙに品番名称 " &sHINBAN " のレコードが"
				"\n発見できませんでした。"))
			(CFAlertMsg #sMSG) (exit)
		)
		((< 1 (length #QLY$))
			(setq #sMSG (strcat "【" &sTABLE "】ﾃｰﾌﾞﾙで品番名称 " &sHINBAN " のレコードが"
				"\n複数検出されました。"))
			(CFAlertMsg #sMSG) (exit)
		)
		(t (car #QLY$))
	); end of cond
); PcGetPartQLY$

;;; <HOM>***********************************************************************
;;; <関数名>  : PcGetPrintName
;;; <処理概要>: 品番名称を渡すと ｢階層+SERIES名｣ テーブルから出力名称を返す
;;; <戻り値>  : 出力名称文字列 （検索失敗なら空文字列）
;;; <作成>    : 00/04/28 MH
;;; <備考>    : 複数取得の場合は最初に検出のもの
;;; ***********************************************************************>MOH<
(defun PcGetPrintName
	(
	&sHINBAN    ; 品番名称
	/
	#sTABLE
	#QLY$
	#sNAME
	)
	; ｢階層+SERIES名｣ テーブル名作成
	(setq #sTABLE (strcat "階層" CG_SeriesCode))
	;クエリ取得
	(setq #QLY$
		(car
			(CFGetDBSQLRec
				CG_DBSESSION
				#sTABLE
				(list
					(list "階層名称" &sHINBAN 'STR)
				); end of list
			)
		)
	); end of setq
	(if (< 6 (length #QLY$)) (setq #sNAME (nth 7 #QLY$)))
	(if (/= 'STR (type #sNAME)) (setq #sNAME ""))
	#sNAME
); PcGetPrintName

;;; <HOM>***********************************************************************
;;; <関数名>  : PKGetWTbySYM$
;;; <処理概要>: アイテムの基点,設置角度,"G_SYM"で、範囲内のＷＴ情報を取得
;;; <戻り値>  : "G_WRKT"リスト  または  nil
;;; <作成>    : 00/05/31 MH
;;; ***********************************************************************>MOH<
(defun PKGetWTbySYM$
	(
	&bP
	&fANG
	&xd$
	/
	#dCH1
	#dCH2
	#pt$
	#view$
	#WT
	#xdWT$
	#FANG
	)
	; ﾜｰｸﾄｯﾌﾟの取得
	(setq #dCH1 (list (car &bP)(cadr &bP)))
	(setq #dCH2 (Pcpolar #dCH1 (+ (* -0.5 pi) &fANG) (nth 4 &xd$)))
	(setq #pt$  (list #dCH1 (pcpolar #dCH1 &fANG (nth 3 &xd$))
													(pcpolar #dCH2 &fANG (nth 3 &xd$)) #dCH2 #dCH1))
	(setq #view$ (getvar "VIEWDIR")) ; PKGetWTSymCP 要視点操作
	(command "_vpoint" '(0 0 1))
	(if (setq #WT (PKGetWTSymCP #pt$))
		(setq #xdWT$ (CFGetXData (car #WT) "G_WRKT"))
	); if
	(command "_vpoint" #view$)
	; ﾜｰｸﾄｯﾌﾟの取得ここまで
	#xdWT$
); PKGetWTbySYM$

(princ)
