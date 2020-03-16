(setq CG_Dim1CharWidth 72)	; TM ADD 寸法文字の１文字分の幅(暫定版)

(setq CG_SEKOU_DIMSTR_L_OFFSET 50.)  ;施工寸法文字の寸法左からのオフセット


;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetTopMaterial
;;; <処理概要>: カウンタートップの素材を取得する
;;; <戻り値>  : トップ素材フラグ
;;;               0:人造大理石  1:ステンレス  nil:トップなし
;;; <備考>    : トップが複数存在する場合、任意のトップ素材を返します。
;;; <作成>    : 2001-03-27 HN
;;;************************************************************************>MOH<
(defun SCFGetTopMaterial
	(
	&sLayer     ; 対象とする画層名
	/
	#psWRKT     ; トップの選択セット
	#WRKT$      ; トップの拡張データ
	#iTop       ; トップの素材フラグ
	)

	(setq #psWRKT (ssget "X" (list (cons 8 &layer) (list -3 (list "G_WRKT")))))
	
	(if #psWRKT
		(progn
			(setq #WRKT$ (CFGetXData (ssname #psWRKT 0) "G_WRKT"))
			(if #WRKT$
				(setq #iTop (KCGetZaiF (nth 2 #WRKT$)))
			)
		)
	)

	#iTop
) ;_SCFGetTopMaterial


;<HOM>*************************************************************************
; <関数名>    : SCFGetPEntity
; <処理概要>  : Ｐ図形取得
; <戻り値>    : Ｐ図形リスト
;               （
;                 （
;                   （属性値 座標１ ）...         Ｐ点
;                 ）
;                 （
;                   （属性値 座標１ 座標２）...   Ｐ面
;                 ）
;               ）
; <備考>      : ・座標
;                   Ｐ点                Ｐ面
;                   座標１：点座標      座標１：左下点
;                                       座標２：右上点
;               ・必要なデータ
;                   P点
;                    水栓穴中心点  属性２
;                    施工胴縁位置
;                    施工寸法位置  属性１ 属性２
;                   P面
;                    外形領域
;                    シンク穴領域
;                    コンロ穴領域
; <作成>      : 1998-07-02
;*************************************************************************>MOH<
(defun SCFGetPEntity (
	&layer   ; (STR)      展開図画層名
	/
	#ss #i #en #eg #eed$ #app #data$ #pt1 #sui$ #dou$ #sun$ #pt$ #pt2
	#ins$ #gai$ #sin$ #gas$ #ten$ #men$
	; 01/03/27 HN S-ADD ローカル変数を追加
	#iTop       ; トップの素材フラグ
	#sink0$     ; シンク穴領域（人造大理石）
	#sink1$     ; シンク穴領域（ステンレス）
	; 01/03/27 HN E-ADD ローカル変数を追加
	)

	;01/03/27 HN ADD トップ素材取得処理を追加
	;@DEBUG@(princ "\n&layer: ")(princ &layer) ;01/08/28 HN ADD デバッグ用
	(setq #iTop (SCFGetTopMaterial &layer))

	(setq #ss (ssget "X" (list (cons 8 &layer)(list -3 (list "G_PTEN,G_PMEN")))))

	(if (/= nil #ss)
		(progn

			(setq #i 0)
			(repeat (sslength #ss)

				; 図形名取得
				(setq #en    (ssname #ss #i))
				; 図形データ取得
				(setq #eg    (entget #en '("*")))
				; 拡張データ取得
				(setq #eed$  (cadr (assoc -3 #eg)))
				; アプリケーション名取得
				(setq #app   (car #eed$))
				; 属性データ取得
				(setq #data$ (mapcar 'cdr (cdr #eed$)))
				(cond
					((equal "G_PTEN" #app)                   ;Ｐ点
						; 点図形の座標取得
						(setq #pt1 (cdr (assoc 10 #eg)))

						(cond
; 01/03/14 TM DEL-S 水栓穴は施工寸法点として寸法表示するように変更
;              ((= 5 (car #data$))                  ;水栓穴中心点
;                (if (= 0 (caddr #data$))
;                  (setq #sui$ (cons (list nil #pt1) #sui$))
;                )
;              )
; 01/03/14 TM DEL-S 水栓穴は施工寸法点として寸法表示するように変更
							((= 8 (car #data$))                  ;施工胴縁位置
									; 01/04/13 TM ADD DEBUG
									; (princ "\n#data$: ")(princ #data$)
									; (princ " ")(princ #pt1)
								(setq #dou$ (cons (list (list (cadr #data$) (caddr #data$)) #pt1 #en) #dou$))
							)
							((= 9 (car #data$))                  ;施工寸法位置
;@@@05/18DEBUG(princ "\n#data$: ")(princ (car #data$))
								(if (and (= 'INT (type (cadr #data$)))(= 'INT (type (caddr #data$))))
									(progn
										(setq #sun$ (cons (list (list (cadr #data$) (caddr #data$)) #pt1) #sun$))
									)
								)
							)
						)
					)
					((equal "G_PMEN" #app)                ;Ｐ面
						; 図形の左下、右上座標取得
						(setq #pt$ (mapcar 'car (get_allpt_H #en)))
						(setq #pt1
							(list
								(apply 'min (mapcar 'car  #pt$))
								(apply 'min (mapcar 'cadr #pt$))
							)
						)
						(setq #pt2
							(list
								(apply 'max (mapcar 'car  #pt$))
								(apply 'max (mapcar 'cadr #pt$))
							)
						)
						(cond
							((= 2 (car #data$))                  ;外形領域（ガス）
								(if (= 1 (cadr #data$))
									(setq #gai$ (cons (list nil #pt1 #pt2) #gai$))
								)
							)
							((= 4 (car #data$))                  ;シンク穴領域

								; 2017/09/20 YM MOD
								; フレームキッチン対応
								(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
									(progn
										nil ;何もしない
									)
									(progn

										; 01/03/27 HN S-ADD 属性１によるシンク穴振り分け処理に変更
										;MOD(setq #sin$ (cons (list nil #pt1 #pt2) #sin$))
										;@@@(princ "\nシンク穴 属性1: ")(princ (cadr #data$)) ;DEBUG
										(cond
											((= 0 (cadr #data$))  ; 人造大理石
												(setq #sink0$ (cons (list nil #pt1 #pt2) #sink0$))
												;@DEBUG@(princ "\n<人造大理石> pt1: ")(princ #pt1)(princ "  pt2: ")(princ #pt2) ;01/08/28 HN ADD デバッグ用
											)
											((= 1 (cadr #data$))  ; ステンレス
												(setq #sink1$ (cons (list nil #pt1 #pt2) #sink1$))
												;@DEBUG@(princ "\n<ステンレス> pt1: ")(princ #pt1)(princ "  pt2: ")(princ #pt2) ;01/08/28 HN ADD デバッグ用
											)
										)
										; 01/03/27 HN E-ADD 属性１によるシンク穴振り分け処理に変更

									)
								);_if

							)
							((= 5 (car #data$))                  ;コンロ穴領域

								; 2017/09/20 YM MOD
								; フレームキッチン対応
								(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
									(progn
										nil ;何もしない
									)
									(progn

										(setq #gas$ (cons (list nil #pt1 #pt2) #gas$))

									)
								);_if
									
							)
						) ; end cond

					)
					(T
						nil
					)
				)
				(setq #i (1+ #i))
			)
		)
	)

	; 01/03/27 HN S-ADD 属性１によるシンク穴振り分け処理を追加
	;@DEBUG@(princ "\n#iTop: ")(princ #iTop) ;01/08/28 HN ADD デバッグ用
	(cond
		; 01/08/28 HN MOD ニューマーブルを追加
		;@MOD@((= 0 #iTop)    ; 人造大理石
		((or (= 0 #iTop) (= -1 #iTop))   ; 人造大理石・ニューマーブル
			(if #sink0$
				(setq #sin$ #sink0$)
				(setq #sin$ #sink1$)
			)
		)
		((= 1 #iTop)    ; ステンレス
			(if #sink1$
				(setq #sin$ #sink1$)
				(setq #sin$ #sink0$)
			)
		)
		; 01/07/13 TM トップなしでもシンク穴がある場合に対応(Lipple対応)
		(T         ; トップなし(とりあえず人造大理石を優先)
			;@DEL@(princ "\nｼﾝｸ穴判定ｴﾗｰ 材質F: ")(princ #iTop) ; 01/08/28 HN ADD エラー表示  02/03/26 HN DEL
			(if #sink1$
				(setq #sin$ #sink1$)
				(setq #sin$ #sink0$)
			)
	 		; (princ "　トップなし: ")
			; (princ #sin$)
		)
	)
	; 01/03/27 HN E-ADD 属性１によるシンク穴振り分け処理を追加

	(setq #ten$ (list #sui$ #dou$ #sun$))
	; (princ "\n#ten$: ")
	; (princ #ten$)
	(setq #men$ (list #gai$ #sin$ #gas$))
	; (princ "\n#men$: ")
	; (princ #men$)

	(list #ten$ #men$)
) ; SCFGetPEntity

;<HOM>*************************************************************************
; <関数名>    : C:GetPTEN
; <処理概要>  : P点図形を取得／表示する
; <戻り値>    : 
; <作成>      : デバッグ用？ 01/02/28 TM 
;*************************************************************************>MOH<
(defun C:GetPTEN (
	/
	#ss
	#i
	#en
	#eg
	#eed$
	#app
	#data$
	)

	(if (setq #ss (ssget "X" (list (list -3 (list "G_PTEN")))))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en    (ssname #ss #i))             ; 図形名取得
				(setq #eg    (entget #en '("*")))         ; 図形データ取得
				(setq #eed$  (cadr (assoc -3 #eg)))       ; 拡張データ取得
				(setq #app   (car #eed$))                 ; アプリケーション名取得
				(setq #data$ (mapcar 'cdr (cdr #eed$)))   ; 属性データ取得
				(cond
					((equal "G_PTEN" #app)                  ; Ｐ点
						(if (or (= 8 (car #data$)) (= 9 (car #data$)))
							(progn
								(princ "\nP点ｺｰﾄﾞ: ")(princ #data$)(princ "  画層: ")(princ (cdr (assoc 8 #eg)))
								(princ (cdrassoc 10 #eg))
								(entmod (subst (cons 62 3) (assoc 62 #eg) #eg))
							)
						)
					)
				)
				(setq #i (1+ #i))
			)
		)
		(princ "\nG_PTENの図形はありません.")
	)
	(princ)
)

;; 01/04/13 TM DEL-S 使用していないので削除
;;<HOM>*************************************************************************
;; <関数名>    : SCFDrawDimDoubuti
;; <処理概要>  : 施工胴縁寸法線を作図する
;; <戻り値>    : 位置リスト（上 下 左 右）
;; <作成>      : 00/03/27
;;*************************************************************************>MOH<
;(defun SCFDrawDimDoubuti (
;  &pdpt$      ; 施工胴縁座標リスト
;  &ryo$       ; ベースとアッパーの領域座標リスト
;  &iti$       ; 寸法位置NO
;  &flg        ; 縦横フラグ（"Y":横  "T":縦）
;  /
;  #iti$ #data #pt1$ #pt0$ #minx #maxx #y #ss #i #en #ed$ #pt0 #pt1 #base #ang #iti
;  #tmp$        #flg
;  )
;;@@@(princ "\n&pdpt$: ")(princ &pdpt$)
;
;  ;<HOM>************************************************************************
;  ; <関数名>  : ##DrawDoubuti
;  ; <処理概要>: 施工胴縁寸法を縦と横に分けて出力
;  ; <戻り値>  : iti
;  ;************************************************************************>MOH<
;  (defun ##DrawDoubuti (
;    &bpt      ; 基点
;    &ceil     ; 天井高さ
;    &pt$      ; 施工胴縁点座標リスト
;    &flg      ; 縦横フラグ（"Y":横  "T":縦）
;    &iti      ; 位置
;    &ang      ; 出力寸法角度
;    /
;    #cpt
;    #wt$
;    #wt
;    #pt
;    #ptp
;    #pt$
;    #i
;    #pt_n$
;    #iti
;    #dpt
;
;
;    #pold
;    #tmp$
;    #newpt$
;
;    )
;    (setq #cpt (polar &bpt (* 0.5 PI) &ceil))
;    (setq #pt$ &pt$)
;    ; 2000/07/12 X座標Y座標の順でソートする
;    ; ((X1 Y1)(X1 Y2)(X1 Y3)・・(X2 Y1)(X2 Y2)(X2 Y3)・・・)
;    (setq #pt$ (SCFmg_sort$ 'car #pt$))
;    (setq #newpt$ '() #i 1 #pold (car (nth 0 #pt$)))
;    (mapcar '(lambda (#p)
;      (if (= #i (length #pt$))
;        (progn
;        (setq #tmp$ (append #tmp$ (list #p)))
;        (setq #tmp$ (SCFmg_sort$ 'cadr #tmp$))
;        (setq #newpt$ (append #newpt$ #tmp$))
;        )
;        (progn
;        (if (not (equal (car #p) #pold 0.1))
;          (progn
;            (setq #pold (car #p))
;          (setq #tmp$ (SCFmg_sort$ 'cadr #tmp$))
;          (setq #newpt$ (append #newpt$ #tmp$))
;          (setq #tmp$ '())
;          (setq #tmp$ (append #tmp$ (list #p)))
;          )
;          (progn
;          (setq #tmp$ (append #tmp$ (list #p)))
;          )
;        )
;        )
;      )
;      (setq #i (1+ #i))
;      ) ; lambda
;      #pt$
;    )
;    ; ソート終わり
;    (setq #wt$ #newpt$)
;
;
;    ; 00/05/28 HN S-ADD XY座標でマージする処理を追加
;    ;@@@(setq #pt$ (PtSort &pt$ (* 0.5 PI) T))
;;    (setq #wt$ (PtSort &pt$ (* 0.5 PI) T))
;
;    (setq #i 0 #pt$ '())
;    (setq #ptp (list -9999.9 -9999.9 0.0))
;    (repeat (length #wt$)
;      (setq #wt (nth #i #wt$))
;      (setq #pt (list (car #wt) (cadr #wt) 0.0))
;      (if
;        (or
;          (not (equal (car  #ptp) (car  #pt) 0.1))
;          (not (equal (cadr #ptp) (cadr #pt) 0.1))
;        )
;        (progn
;          (setq #pt$ (cons #pt #pt$))
;          ; (setq #ptp #pt)
;        )
;      )
;      (setq #ptp #pt)
;      (setq #i (1+ #i))
;    )
;    (setq #pt$ (reverse #pt$))
;    ; 00/05/28 HN E-ADD XY座標でマージする処理を追加
;
;    ; X座標が異なる場合(I型2列の場合など、側面が2つある場合におこる???)の
;    ; 対応は行わないことにする。つまり同じ寸法が同じ方向に作成されても
;    ; かまわないものとする。(社内打ち合わせ)
;
;;@debug@(setq #i 0)
;;@debug@(repeat (length #pt$)
;;@debug@  (princ "\nNo.")(princ #i)(princ ": ")(princ (nth #i #pt$))
;;@debug@  (setq #i (1+ #i))
;;@debug@)
;
;    (if (= "Y" &flg)
;      ; 横方向
;      (progn
;        ;奇数のときは一つ省く
;        (if (/= 0 (rem (length #pt$) 2))
;          (setq #pt$ (reverse (cdr (reverse #pt$))))
;        )
;        (setq #i 0)
;        (repeat (/ (length #pt$) 2)
;          (setq #pt_n$ (cons (list &bpt (nth #i #pt$) (nth (1+ #i) #pt$)) #pt_n$))
;;(princ "\n")(princ (car #pt_n$))
;          (setq #i (+ 2 #i))
;        )
;        ; 2000/06/28 HT 障害16 寸法表示が重なる => 表示なしとした
;        ;;最後の要素には天井位置座標も加える 2000/06/28 HT DEL
;        ; (setq #pt_n$ (append (list (cons #cpt (car #pt_n$))) (cdr #pt_n$))) ; 2000/06/28 HT DEL
;        (setq #pt_n$ (reverse #pt_n$))
;      )
;      ; 縦方向
;      (progn
;        ; 2000/06/28 HT 障害16 寸法表示が重なる => 表示なしとした
;        ; (setq #pt_n$ (list (append (list &bpt) #pt$ (list #cpt))))
;        (setq #pt_n$ (list (append (list &bpt) #pt$)))
;      )
;    )
;    (setq #iti &iti)
;
;    (foreach #pt$ #pt_n$
;      (setq #dpt (polar &bpt &ang (GetDimHeight #iti)))
;      (SCFDrawDimLin #pt$ &bpt #dpt "V")
;      (setq #iti (1+ #iti))
;    )
;    #iti
;  ); defun ##DrawDoubuti
;  ;******************************************************************************
;
;  (setq #iti$ &iti$)
;
;  ;正面と側面を分ける
;  (foreach #data &pdpt$
;    (if (= 1 (car #data))
;      (setq #pt1$ (cons (cadr #data) #pt1$))  ; 正面
;      (setq #pt0$ (cons (cadr #data) #pt0$))  ; 側面
;    )
;  )
;  ; Z座標を0.0にする
;  (setq #pt1$ (2dto3d (3dto2d #pt1$)))  ; 正面
;  (setq #pt0$ (2dto3d (3dto2d #pt0$)))  ; 側面
;
;
;  ;アッパーキャビネットのX座標獲得
;  (setq #minx (car  (car  (car &ryo$))))
;  (setq #maxx (car  (cadr (car &ryo$))))
;  (setq #y    (cadr (car  (car &ryo$))))
;  ;ダミー点取得
;  (setq #ss (ssget "X" (list (list -3 (list "G_SKDM")))))
;  (if (/= nil #ss)
;    (progn
;      (setq #i 0)
;      (repeat (sslength #ss)
;        (setq #en (ssname #ss #i))
;        (setq #ed$ (CfGetXData #en "G_SKDM"))
;
;				; ワークトップダミー図形
;        (if (= "W" (nth 1 #ed$))
;          (cond
;						; モデル内頂点番号 0 側面？
;            ((= 0 (nth 3 #ed$))
;              ;(princ #pt0)
;            )
;						; モデル内頂点番号 1 正面？
;            ((= 1 (nth 3 #ed$))
;              ;(princ #pt1)
;            )
;          )
;        )
;        (setq #i (1+ #i))
;      )
;
;      ; 2000/06/20 HT 側面で正面と同じ寸法値のものは、作図しない
;      ; L型での不具合修正のため
;      (setq #tmp$ #pt0$)
;      (setq #pt0$ '())
;      (setq #i 0)
;      (repeat (/ (length #tmp$) 2)
;
;				(setq #flg nil #j 0)
;				(repeat (length #pt1$)
;					(if (equal (distance (nth #j #pt1$) (nth #i #tmp$)) 0 0.1)
;						(progn
;							(setq #flg T)
;						)
;					)
;					(setq #j (1+ #j))
;				)
;
;				(if #flg
;					(progn
;						(setq #flg nil #j 0)
;						(repeat (length #pt1$)
;							(if (equal (distance (nth #j #pt1$) (nth (1+ #i) #tmp$)) 0 0.1)
;								(progn
;									(setq #flg T)
;								)
;							)
;							(setq #j (1+ #j))
;						)
;					)
;				)
;
;        (if (= #flg nil)
;          (progn
;						(setq #pt0$ (append #pt0$ (list (nth #i #tmp$))))
;						(setq #pt0$ (append #pt0$ (list (nth (1+ #i) #tmp$))))
;          )
;        )
;        (setq #i (+ #i 2))
;      )
;      ; 2000/06/20 HT 側面で正面と同じ寸法値のものは、作図しない
;
;      ;正面方向作図
;      (if (/= nil #pt1$)
;        (progn
;					; 寸法の向きを指定
;          ; 2000/06/28 HT ワークトップで判定せず、P点とした
;          ;_if (< (abs (- #minx (car #pt1))) (abs (- #maxx (car #pt1))))
;          (if (< (abs (- #minx (car (nth 0 #pt1$)))) (abs (- #maxx (car (nth 0 #pt1$)))))
;            (progn
;              (setq #base (list #minx #y 0.0))
;              (setq #ang  PI)
;              (setq #iti (nth 2 #iti$))
;            )
;            (progn
;              (setq #base (list #maxx #y 0.0))
;              (setq #ang  0.0)
;              (setq #iti (nth 3 #iti$))
;            )
;          )
;          (setq #iti (##DrawDoubuti #base CG_CeilHeight #pt1$ &flg #iti #ang))
;          (if (/= 0.0 #ang)
;            (setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) #iti (nth 3 #iti$)))
;            (setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) (nth 2 #iti$) #iti))
;          )
;        )
;      )
;      ;側面方向作図
;      (if (/= nil #pt0$)
;        (progn
;          (if (< (abs (- #minx (car (nth 0 #pt0$)))) (abs (- #maxx (car (nth 0 #pt0$)))))
;            (progn
;              (setq #base (list #minx #y 0.0))
;              (setq #ang  PI)
;              (setq #iti (nth 2 #iti$))
;            )
;            (progn
;              (setq #base (list #maxx #y 0.0))
;              (setq #ang  0.0)
;              (setq #iti (nth 3 #iti$))
;            )
;          )
;          (setq #iti (##DrawDoubuti #base CG_CeilHeight #pt0$ &flg #iti #ang))
;          (if (/= 0.0 #ang)
;            (setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) #iti (nth 3 #iti$)))
;            (setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) (nth 2 #iti$) #iti))
;          )
;        )
;      )
;    )
;  )
;
;  #iti$
;) ; SCFDrawDimDoubuti
; 01/04/13 TM DEL-E 使用していないので削除

;<HOM>*************************************************************************
; <関数名>    : SCFDrawDimDoubuti2Exec
; <処理概要>: 施工胴縁寸法を縦と横に分けて出力
; <戻り値>    : 位置
; <作成>      : 00/03/27  00/08
;             : 側面で正面と同じ寸法値のものは、作図しない。
;             : P点のZ座標は無視
;             : P点X位置により、アイテム全体の領域の左右に作図するよう変更
;*************************************************************************>MOH<
(defun KCFDrawDimDoubuti2Exec (
	&bpt      ; 基点
	&ceil     ; 天井高さ
	&pt$      ; 施工胴縁点座標リスト
	&flg      ; 縦横フラグ（"Y":横  "T":縦）
	&iti      ; 位置
	&ang      ; 出力寸法角度
	/
	#cpt			; 天井高さの点
	#wt$			; 
	#wt				; 施工同縁点座標
	#pt				; 操作変数
	#ptp
	#pt$ #i		; 操作用変数
	#pt_n$
	#iti			; 表示位置
	#dpt			; 寸法点
	)
	(setq #cpt (polar &bpt (* 0.5 PI) &ceil))
	(setq #wt$ &pt$)

	; 01/05/28 HN ADD 位置=nilの場合は０を設定
	(if (= nil &iti)
		(setq &iti 0)
	)
	
	; 00/05/28 HN S-ADD XY座標でマージする処理を追加
	;@@@(setq #pt$ (PtSort &pt$ (* 0.5 PI) T))
	;    (setq #wt$ (PtSort &pt$ (* 0.5 PI) T))

	(setq #i 0 #pt$ '())
	(setq #ptp (list -9999.9 -9999.9 0.0))				; 参照点
	(repeat (length #wt$)
		(setq #wt (nth #i #wt$))										; 胴縁寸法点
		(setq #pt (list (car #wt) (cadr #wt) 0.0))	; ２次元化した点
		; X Y 座標が等しい場合にマージ対象とみなす
		(if (or (not (equal (car  #ptp) (car  #pt) 0.1))
						(not (equal (cadr #ptp) (cadr #pt) 0.1)))
			(progn
				(setq #pt$ (cons #pt #pt$))
				; (setq #ptp #pt)
			)
		)
		(setq #ptp #pt)
		(setq #i (1+ #i))
	)
	(setq #pt$ (reverse #pt$))
	; 00/05/28 HN E-ADD XY座標でマージする処理を追加

	; 01/04/13 TM ADD DEBUG ZAN
	; DEBUG (princ "\n作図する点の数(前): ")(princ (length #pt$))
	;	DEBUG (setq #i 0)
	; DEBUG	(repeat (length #pt$)
	; DEBUG		(princ "\nNo.")(princ #i)(princ ": ")(princ (nth #i #pt$))
	; DEBUG		(setq #i (1+ #i))
	; DEBUG	)

	(if (= "Y" &flg)
		; 横方向
		(progn
			;奇数のときは一つ省く
			; 01/04/15 TM MOD ZAN 胴縁寸法の仕様考慮要 ２個ごとに表示→全て連続に暫定変更中
			; (if (/= 0 (rem (length #pt$) 2))
			; 	(setq #pt$ (reverse (cdr (reverse #pt$))))
			; )
			;(setq #i 0)
			; 01/04/15 TM MOD ZAN 胴縁寸法の仕様考慮要 ２個ごとに表示→全て連続に暫定変更中
			;(repeat (/ (length #pt$) 2)
			;	(setq #pt_n$ (cons (list &bpt (nth #i #pt$) (nth (1+ #i) #pt$)) #pt_n$))
			;	(setq #i (+ 2 #i))
			;)
			; 01/04/15 TM MOD ZAN 胴縁寸法の仕様考慮要 ２個ごとに表示→全て連続に暫定変更中
			(setq #pt_n$ (list &bpt) #pt nil)
			(foreach #pt #pt$
				(setq #pt_n$ (append (list #pt) #pt_n$))
			)
;			(princ "\nてんてん")
;			(princ #pt_n$)
			; 2000/06/28 HT 障害16 寸法表示が重なる => 表示なしとした
			;;最後の要素には天井位置座標も加える 2000/06/28 HT DEL
			; (setq #pt_n$ (append (list (cons #cpt (car #pt_n$))) (cdr #pt_n$))) ; 2000/06/28 HT DEL
			(setq #pt_n$ (reverse #pt_n$))

		)
		; 縦方向
		(progn
			; 2000/06/28 HT 障害16 寸法表示が重なる => 表示なしとした
			; (setq #pt_n$ (list (append (list &bpt) #pt$ (list #cpt))))
			; 01/04/23 HN  MOD
			;@MOD@(setq #pt_n$ (list (append (list &bpt) #pt$)))
			(setq #pt_n$ (append (list &bpt) #pt$))
		)
	)
	; 01/04/13 TM ADD DEBUG ZAN
	; DEBUG (princ "\n作図する点の数: ")(princ (length #pt_n$))
	; DEBUG (setq #i 0)
	; DEBUG (repeat (length #pt_n$)
	; DEBUG 	(princ "\nNo.")(princ #i)(princ ": ")(princ (nth #i #pt_n$))
	; DEBUG 	(setq #i (1+ #i))
	; DEBUG )

; 01/04/15 TM MOD-S ZAN 同縁寸法の仕様考慮要 ２個ごとに表示→全て連続に暫定変更中
;	(setq #iti &iti)
;	(foreach #pt$ #pt_n
;		(setq #dpt (polar &bpt &ang (GetDimHeight #iti)))
;		(SCFDrawDimLin #pt$ &bpt #dpt "V")
;		(setq #iti (1+ #iti))
;	)
; 01/04/15 TM MOD-E ZAN 同縁寸法の仕様考慮要 ２個ごとに表示→全て連続に暫定変更中

	(SCFDrawDimLin #pt_n$ &bpt (polar &bpt &ang (GetDimHeight &iti)) "V")
	(SCFDrawDimLinAddStr #pt_n$ &bpt (polar &bpt &ang (GetDimHeight &iti)) "V" #dimId)
	(setq #iti (1+ &iti))

	#iti

) ;_defun KCFDrawDimDoubuti2Exec


;<HOM>*************************************************************************
; <関数名>    : SCFDrawDimDoubuti2
; <処理概要>  : 施工胴縁寸法線を作図する
; <戻り値>    : 位置リスト（上 下 左 右）
; <作成>      : 00/03/27  00/08
;             : 側面で正面と同じ寸法値のものは、作図しない。
;             : P点のZ座標は無視
;             : P点X位置により、アイテム全体の領域の左右に作図するよう変更
;*************************************************************************>MOH<
(defun SCFDrawDimDoubuti2 (
	&pdpt$      ; 施工胴縁座標リスト
	&ryo$       ; ベースとアッパーの領域座標リスト
	&iti$       ; 寸法位置NO
	&flg        ; 縦横フラグ（"Y":横  "T":縦）
	/
	#iti$ #data #pt1$ #pt0$ #minx #maxx #y #ss #i #j #en #ed$ #pt0 #pt1 #base #ang #iti
	#tmp$        #flg
	#pt0$
	#pt1$
	#pt0L$$ #pt0R$$ #pt1L$$ #pt1R$$ 
	)

;01/04/15 TM MOD-S KCFDrawDimDoubuti2Exec として外に出した
;  ;<HOM>************************************************************************
;  ; <関数名>  : ##DrawDoubuti
;  ; <処理概要>: 施工胴縁寸法を縦と横に分けて出力
;  ; <戻り値>  : iti
;  ;************************************************************************>MOH<
;  (defun ##DrawDoubuti (
;    &bpt      ; 基点
;    &ceil     ; 天井高さ
;    &pt$      ; 施工胴縁点座標リスト
;    &flg      ; 縦横フラグ（"Y":横  "T":縦）
;    &iti      ; 位置
;    &ang      ; 出力寸法角度
;    /
;    )
;  )
;  ;******************************************************************************
;01/04/15 TM MOD-E KCFDrawDimDoubuti2Exec として外に出した

	(setq #iti$ &iti$)

	;DEBUG (princ "\n &pdpt$: ")
	;DEBUG (princ &pdpt$)

	;正面と側面を分ける
	(foreach #data &pdpt$
		; 同一平面上に点を移す
		(setq #data (list (car #data) (caadr #data) (cadadr #data) 0.0))

		;DEBUG (princ "\n #data: ")
		;DEBUG (princ #data)

		(if (= 1 (car #data))
			(setq #pt1$ (cons (cdr #data) #pt1$))  ; 正面
			(setq #pt0$ (cons (cdr #data) #pt0$))  ; 側面
		)
	)
	;DEBUG (princ "\n#pt1$ #pt0$:")(princ #pt1$)(princ " ")(princ #pt0$)

	;アッパーキャビネットのX座標獲得
	(setq #minx (car  (car  (car &ryo$))))
	;アッパーキャビネットのX座標獲得
	; 01/04/05 TM ADD-S アッパーキャビネットの存在をチェックし、ない場合はベースキャビネットを使用する
	(if (car &ryo$)
		(progn
			(setq #minx (car  (car  (car &ryo$))))
			(setq #maxx (car  (cadr (car &ryo$))))
			(setq #y    (cadr (car  (car &ryo$))))
		)
		(progn
			(setq #minx (car  (car  (cadr &ryo$))))
			(setq #maxx (car  (cadr (cadr &ryo$))))
			(setq #y    (cadr (car  (cadr &ryo$))))
		)
	)
	; 01/04/05 TM ADD-S アッパーキャビネットの存在をチェックし、ない場合はベースキャビネットを使用する

	;ダミー点取得
	(setq #ss (ssget "X" (list (list -3 (list "G_SKDM")))))
	(if (/= nil #ss)
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				; ワークトップダミー点
				(if (= "W" (nth 1 #ed$))
					(cond
						((= 0 (nth 3 #ed$))
							(setq #pt0 (cdrassoc 10 (entget #en)))
						)
						((= 1 (nth 3 #ed$))
							(setq #pt1 (cdrassoc 10 (entget #en)))
						)
					)
				)
				(setq #i (1+ #i))
			)

			; DEBUG (princ "\n#pt1$ #pt0$:")(princ #pt1$)(princ "\n")(princ #pt0$)

			; 01/04/15 TM MOD-S Ｌ型の場合のみに適用するように変更
			(if (wcmatch CG_KitType "L-*")
				(progn
					; 2000/06/20 HT 側面で正面と同じ寸法値のものは、作図しないようにした。
					; L型での不具合修正のため
					(setq #tmp$ #pt0$)
					(setq #pt0$ '())
					(setq #i 0)
					(repeat (/ (length #tmp$) 2)

						(setq #flg nil #j 0)
						(repeat (length #pt1$)
							(if (equal (distance (nth #j #pt1$) (nth #i #tmp$)) 0 0.1)
								(progn
									(setq #flg T)
								)
							)
							(setq #j (1+ #j))
						)
						(if #flg
							(progn
								(setq #flg nil #j 0)
								(repeat (length #pt1$)
									(if (equal (distance (nth #j #pt1$) (nth (1+ #i) #tmp$)) 0 0.1)
										(progn
											(setq #flg T)
										)
									)
									(setq #j (1+ #j))
								)
							)
						)

						(if (= #flg nil)
							(progn
								(setq #pt0$ (append #pt0$ (list (nth #i #tmp$))))
								(setq #pt0$ (append #pt0$ (list (nth (1+ #i) #tmp$))))
							)
						)
						(setq #i (+ #i 2))
					)
				)
			);_ if (wcmatch CG_KitType "L-*")
			; 01/04/15 TM MOD-E Ｌ型の場合のみに適用するように変更
; 06/07/14 T.Ari ADD-S 点列マージ処理追加
			; 他の点列にY座標が全て含まれる点列を削除
			(defun ##MergeDoubutiPt ( &ptMarge$$ / )
				; 他の点列にY座標が全て含まれる点列を削除(一方向で逆順リスト変換)
				(defun ##MergeDoubutiPtSub1 ( &ptMarge$$ / )
					; 点列のY座標リストが他の点列に含まれていなければ点列を返す
					(defun ##MergeDoubutiPtSub2 ( &ptMarge1$ &ptMarge2$$ / )
						; Y座標リストが他の点列のY座標に全て含まれるかチェック
						(defun ##MergeDoubutiPtSub3 ( &y1$ &ptMarge2$$ / #y2$ )
							(if &ptMarge2$$
								(progn
									(setq #y2$ (mapcar 'cadr (car &ptMarge2$$)))
									; &l1$リストの中の値が全て&l2$リストにあればT
									(defun ##ListCheck ( &l1$ &l2$ / )
										(if &l1$ 
											(if (member (car &l1$) &l2$) (##ListCheck (cdr &l1$) &l2$) nil )
											T
										)
									)
									(if (##ListCheck &y1$ #y2$)
										nil
										(##MergeDoubutiPtSub3 &y1$ (cdr &ptMarge2$$))
									)
								)
								T
							)
						)
						(if &ptMarge2$$
							; チェック点列の全てY座標が他の点列にあるかをチェック
							(if (##MergeDoubutiPtSub3 (mapcar 'cadr &ptMarge1$) &ptMarge2$$)
								;なければ他の点列も同様にチェック(再帰)し、チェック結果に自分を含めて返却
								(append (##MergeDoubutiPtSub2 (car &ptMarge2$$) (cdr &ptMarge2$$)) (list &ptMarge1$))
								;あれば他の点列も同様にチェック(再帰)し、そのチェック結果を返却
								(##MergeDoubutiPtSub2 (car &ptMarge2$$) (cdr &ptMarge2$$))
							)
							; チェック対象の点列がないのでこの点列のY座標が他の点列に含まれることはない
							; ので返却
							(list &ptMarge1$)
						)
					)
					(##MergeDoubutiPtSub2 (car &ptMarge$$) (cdr &ptMarge$$))
				)
				(if &ptMarge$$
					(##MergeDoubutiPtSub1 (##MergeDoubutiPtSub1 &ptMarge$$))
					nil
				)
			)
; 06/07/14 T.Ari ADD-E 点列マージ処理追加
			
			(if (/= nil #pt1$)
				;正面方向作図
				(progn
			
					; 同じX座標で分ける X座標等しいものはリストでくくる Y座標はソート清 2000/08 HT
					(setq #pt1$$ (SCFCmnXYSortByX #pt1$))
					; 同じX座標毎に、アイテム全体の領域の左方向or右方向に寸法を作図するか決める
; 06/07/14 T.Ari MOD-S 点列マージ処理追加
					(foreach  #pt1$ #pt1$$
						; 2000/06/28 HT ワークトップ→P点で判別
						;_if (< (abs (- #minx (car #pt1))) (abs (- #maxx (car #pt1))))
						(if (< (abs (- #minx (car (nth 0 #pt1$)))) (abs (- #maxx (car (nth 0 #pt1$)))))
							(setq #pt1L$$ (append #pt1L$$ (list #pt1$)))
							(setq #pt1R$$ (append #pt1R$$ (list #pt1$)))
						)
					)
					(setq #pt1L$$ (##MergeDoubutiPt #pt1L$$))
					(setq #pt1R$$ (##MergeDoubutiPt #pt1R$$))
					(foreach  #pt1$ (append #pt1L$$ #pt1R$$)
; 06/07/14 T.Ari MOD-E 点列マージ処理追加
						; 2000/06/28 HT ワークトップ→P点で判別
						;_if (< (abs (- #minx (car #pt1))) (abs (- #maxx (car #pt1))))
						(if (< (abs (- #minx (car (nth 0 #pt1$)))) (abs (- #maxx (car (nth 0 #pt1$)))))
							(progn
								(setq #base (list #minx #y 0.0))
								(setq #ang  PI)
								(setq #iti (nth 2 #iti$))
							)
							(progn
								(setq #base (list #maxx #y 0.0))
								(setq #ang  0.0)
								(setq #iti (nth 3 #iti$))
							)
						)
						; DEBUG (princ "\n正面 ")
						; DEBUG (princ #pt1$)
						; DEBUG (princ "\n")
						; DEBUG (princ #base)
						; DEBUG (princ "\n")
						; DEBUG (princ &flg)
						; DEBUG (princ "\n")
						; DEBUG (princ #ang)
						; 01/04/13 TM MOD 外に出した
						;(setq #iti (##DrawDoubuti #base CG_CeilHeight #pt1$ &flg #iti #ang))
						(setq #iti (KCFDrawDimDoubuti2Exec #base CG_CeilHeight #pt1$ &flg #iti #ang))
						(if (/= 0.0 #ang)
							(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) #iti (nth 3 #iti$)))
							(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) (nth 2 #iti$) #iti))
						)
					)
				)
				;側面方向作図
				(if (/= nil #pt0$)
					(progn

						; 同じX座標で分ける X座標等しいものはリストでくくる Y座標はソート清 2000/08 HT
						(setq #pt0$$ (SCFCmnXYSortByX #pt0$))
						; 同じX座標毎に、アイテム全体の領域の左方向or右方向に寸法を作図するか決める
; 06/07/14 T.Ari MOD-S 点列マージ処理追加
						(foreach #pt0$ #pt0$$
							(if (< (abs (- #minx (car (nth 0 #pt0$)))) (abs (- #maxx (car (nth 0 #pt0$)))))
								(setq #pt0L$$ (append #pt0L$$ (list #pt0$)))
								(setq #pt0R$$ (append #pt0R$$ (list #pt0$)))
							)
						)
						(setq #pt0L$$ (##MergeDoubutiPt #pt0L$$))
						(setq #pt0R$$ (##MergeDoubutiPt #pt0R$$))
						(foreach  #pt0$ (append #pt0L$$ #pt0R$$)
; 06/07/14 T.Ari MOD-E 点列マージ処理追加
							(if (< (abs (- #minx (car (nth 0 #pt0$)))) (abs (- #maxx (car (nth 0 #pt0$)))))
								(progn
									(setq #base (list #minx #y 0.0))
									(setq #ang  PI)
									(setq #iti (nth 2 #iti$))
								)
								(progn
									(setq #base (list #maxx #y 0.0))
									(setq #ang  0.0)
									(setq #iti (nth 3 #iti$))
								)
							)
							; DEBUG (princ "\n側面 ")
							; DEBUG (princ #pt0$)
							; DEBUG (princ "\n")
							; DEBUG (princ #base)
							; DEBUG (princ "\n")
							; DEBUG (princ &flg)
							; DEBUG (princ "\n")
							; DEBUG (princ #ang)
							; 施工同縁寸法作図
							; 01/04/13 TM MOD 外に出した
							;(setq #iti (##DrawDoubuti #base CG_CeilHeight #pt0$ &flg #iti #ang))
							(setq #iti (KCFDrawDimDoubuti2Exec #base CG_CeilHeight #pt0$ &flg #iti #ang))
							(if (/= 0.0 #ang)
								(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) #iti (nth 3 #iti$)))
								(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) (nth 2 #iti$) #iti))
							)
						)
					)
				);_if (/= nil #pt0$)
			)
		)
	)

	#iti$
) ; SCFDrawDimDoubuti2


;<HOM>*************************************************************************
; <関数名>    : SCFDrawDimDoubuti3Exec
; <処理概要>: 施工胴縁寸法を縦と横に分けて出力
; <戻り値>    : 位置
; <作成>      : 08/12/17
;             : 側面で正面と同じ寸法値のものは、作図しない。
;             : P点のZ座標は無視
;             : P点X位置により、アイテム全体の領域の左右に作図するよう変更
;*************************************************************************>MOH<
(defun KCFDrawDimDoubuti3Exec (
	&bpt      ; 基点
	&ceil     ; 天井高さ
	&pt$      ; 施工胴縁点座標リスト
	&flg      ; 縦横フラグ（"Y":横  "T":縦）
	&iti      ; 位置
	&ang      ; 出力寸法角度
	&dimId		; 寸法文字ID
	/
	#cpt			; 天井高さの点
	#wt$			; 
	#wt				; 施工同縁点座標
	#pt				; 操作変数
	#ptp
	#pt$ #i		; 操作用変数
	#pt_n$
	#iti			; 表示位置
	#dpt			; 寸法点
	)
	(setq #cpt (polar &bpt (* 0.5 PI) &ceil))
	(setq #wt$ &pt$)

	(if (= nil &iti)
		(setq &iti 0)
	)
	
	(setq #i 0 #pt$ '())
	(setq #ptp (list -9999.9 -9999.9 0.0))				; 参照点
	(repeat (length #wt$)
		(setq #wt (nth #i #wt$))										; 胴縁寸法点
		(setq #pt (list (car #wt) (cadr #wt) 0.0))	; ２次元化した点
		; X Y 座標が等しい場合にマージ対象とみなす
		(if (or (not (equal (car  #ptp) (car  #pt) 0.1))
						(not (equal (cadr #ptp) (cadr #pt) 0.1)))
			(progn
				(setq #pt$ (cons #pt #pt$))
			)
		)
		(setq #ptp #pt)
		(setq #i (1+ #i))
	)
	(setq #pt$ (reverse #pt$))

	(if (= "Y" &flg)
		; 横方向
		(progn
			(setq #pt_n$ (list &bpt) #pt nil)
			(foreach #pt #pt$
				(setq #pt_n$ (append (list #pt) #pt_n$))
			)
			(setq #pt_n$ (reverse #pt_n$))

		)
		; 縦方向
		(progn
			(setq #pt_n$ (append (list &bpt) #pt$))
		)
	)
	(SCFDrawDimLinAddStr (list (car #pt_n$) (cadr #pt_n$)) &bpt (polar &bpt &ang (GetDimHeight &iti)) "V" &dimId)
	(if (cdr #pt_n$)
		(SCFDrawDimLinAddStr (cdr #pt_n$) &bpt (polar &bpt &ang (GetDimHeight &iti)) "V" 0)
	)
	(setq #iti (1+ &iti))

	#iti

) ;_defun KCFDrawDimDoubuti3Exec

;<HOM>*************************************************************************
; <関数名>    : SCFDrawDimDoubuti3
; <処理概要>  : 施工胴縁寸法線を作図する
; <戻り値>    : 位置リスト（上 下 左 右）
; <作成>      : 08/12/17
;             : 側面で正面と同じ寸法値のものは、作図しない。
;             : P点のZ座標は無視
;             : P点X位置により、アイテム全体の領域の左右に作図するよう変更
;*************************************************************************>MOH<
(defun SCFDrawDimDoubuti3 (
	&pdpt$      ; 施工胴縁座標リスト
	&ryo$       ; ベースとアッパーの領域座標リスト
	&iti$       ; 寸法位置NO
	&flg        ; 縦横フラグ（"Y":横  "T":縦）
	/
	#iti$ #data #pt1$ #pt0$ #minx #maxx #y #ss #i #j #en #ed$ #pt0 #pt1 #base #ang #iti
	#tmp$        #flg
	#pt0$
	#pt1$
	#pt0L$$ #pt0R$$ #pt1L$$ #pt1R$$
	#pdpt$
	#pdpt$$ #pdptadd$ #pdpttmp$
	#pdpt$ #pdpt2$ #pdpt3$
	#pdpt2add$ #datatmp #pdpttmp$
	#pdpt3tmp$
	#pt$$
	#pdpt3$ #pdpt3f$ #pdpt3s$ #pdpt3u$ #pdpt3r$ #pdpt3add$ #pdpt3tmp$
	#pdpt3 #pdpt3f #pdpt3s #pdpt3u #pdpt3r #pdpt3tmp #pdpt3stmp
	#pdpt4$ #pdpt4
	#pdpt4L$ #pdpt4L
	#pdpt4R$ #pdpt4R
	)

	(setq #iti$ &iti$)


	;アッパーキャビネットのX座標獲得
	(setq #minx (car  (car  (car &ryo$))))
	;アッパーキャビネットのX座標獲得
	(if (car &ryo$)
		(progn
			(setq #minx (car  (car  (car &ryo$))))
			(setq #maxx (car  (cadr (car &ryo$))))
			(setq #y    (cadr (car  (car &ryo$))))
		)
		(progn
			(setq #minx (car  (car  (cadr &ryo$))))
			(setq #maxx (car  (cadr (cadr &ryo$))))
			(setq #y    (cadr (car  (cadr &ryo$))))
		)
	)
	(setq #pdpt$$ nil)
	(setq #pdpt$ &pdpt$)
	(while (setq #data (car #pdpt$))
		(setq #pdptadd$ (list #data))
		(setq #pdpt$ (cdr #pdpt$))
		(setq #pdpttmp$ nil)
		(while (setq #datatmp (car #pdpt$))
			(setq #pdpt$ (cdr #pdpt$))
			(if (= (caar #data) (caar #datatmp))
				(setq #pdptadd$ (append #pdptadd$ (list #datatmp)))
				(setq #pdpttmp$ (append #pdpttmp$ (list #datatmp)))
			)
		)
		(setq #pdpt$ #pdpttmp$)
		(setq #pdpt$$ (append #pdpt$$ (list #pdptadd$)))
	)
	
	(setq #pdpt3f$ nil)
	(setq #pdpt3s$ nil)
	(setq #pdpt3u$ nil)
	(setq #pdpt3r$ nil)
	(foreach #pdpt$ #pdpt$$

		(setq #pdpt2$ nil)
		(while (setq #data (car #pdpt$))
			(setq #pdpt$ (cdr #pdpt$))
			(setq #pdpt2add$ (list (cadr #data)))
			(setq #pdpttmp$ nil)
			(while (setq #datatmp (car #pdpt$))
				(setq #pdpt$ (cdr #pdpt$))
				(if (= (cadar #data) (cadar #datatmp))
					(setq #pdpt2add$ (append #pdpt2add$ (list (cadr #datatmp))))
					(setq #pdpttmp$ (append #pdpttmp$ (list #datatmp)))
				)
			)
			(setq #pdpt$ #pdpttmp$)
			(setq #pdpt2$ (append #pdpt2$ (list (list (car #data) #pdpt2add$))))
		)
		
		; 側面図形のXZ座標を入れ替える
		(foreach #data #pdpt2$
			(if (>= (caar #data) 10)
				(setq #data (list (car #data)
						(mapcar '(lambda (#pt)
								(list (caddr #pt) (cadr #pt) (car #pt))
							)
							(cadr #data)
						)
					)
				)
			)
			; 各X座標に存在する点が偶数でないとダメな作りなので、同じデータを2つ利用して正しくソート出来るようにする。
			(setq #pt$$ (SCFCmnXYSortByX (append (cadr #data) (cadr #data))))
			; 同一点が2つずつあるので、1つずつ省いてやる。
			; ついでに側面図形のXZ座標を元に戻す
			(setq #pt$$ 
				(mapcar '(lambda (#pt$ / #ret$)
						(setq #ret$ nil)
						(while (setq #pt (car #pt$))
							(setq #ret$ (append #ret$ 
								(list (if (< (caar #data) 10) #pt (list (caddr #pt) (cadr #pt) (car #pt))))
							))
							(setq #pt$ (cddr #pt$))
						)
						#ret$
					)
					#pt$$
				)
			)
			(foreach #pt$ #pt$$
				(setq #pdpt3add$ nil)
				(while (setq #pt (car #pt$))
					(setq #pdpt3add$ (append #pdpt3add$ (list #pt)))
					(while (and (equal (car #pt) (caar #pt$) 0.1) (equal (cadr #pt) (cadar #pt$) 0.1))
						(setq #pt$ (cdr #pt$))
					)
				)
				(cond
					; 正面図
					((< (caar #data) 10)
						(setq #pdpt3f$ (append #pdpt3f$ (list (list (car #data) (caar #pdpt3add$) #pdpt3add$))))
					)
					; 上台側面
					((= (caar #data) 10)
						(setq #pdpt3u$ (append #pdpt3u$ (list (list (car #data) (caar #pdpt3add$) #pdpt3add$))))
					)
					; レンジフード
					((= (caar #data) 13)
						(setq #pdpt3r$ (append #pdpt3r$ (list (list (car #data) (caar #pdpt3add$) #pdpt3add$))))
					)
					; その他(中台、下台)
					(T
						(setq #pdpt3s$ (append #pdpt3s$ (list (list (car #data) (caar #pdpt3add$) #pdpt3add$))))
					)
				)
			)
		)
	)
	; 側面はレンジフード優先
	(if #pdpt3r$
		(foreach #pdpt3u #pdpt3u$
			(setq #flg T)
			(foreach #pdpt3r #pdpt3r$
				(if (and 
							(= (cadar #pdpt3r) (cadar #pdpt3u))
							(equal (cadr #pdpt3r) (cadr #pdpt3u) 0.1))
					(setq #flg nil)
				)
			)
			(if #flg
				(setq #pdpt3s$ (append #pdpt3s$ (list #pdpt3u)))
			)
		)
		(setq #pdpt3s$ (append #pdpt3s$ #pdpt3u$))
	)
	(setq #pdpt3s$ (append #pdpt3s$ #pdpt3r$))
	; 側面まとめ
	(setq #pdpt3tmp$ nil)
	(while (setq #pdpt3s (car #pdpt3s$))
		(setq #pdpt3tmp$ (append #pdpt3tmp$ (list #pdpt3s)))
		(setq #pdpt3s$ (cdr #pdpt3s$))
		(setq #pdpt3stmp$ nil)
		(while (setq #pdpt3stmp (car #pdpt3s$))
			(setq #pdpt3s$ (cdr #pdpt3s$))
			(setq #flg T)
			(if (and (= (cadar #pdpt3s) (cadar #pdpt3stmp)) (= (length (caddr #pdpt3s)) (length (caddr #pdpt3stmp))))
				(progn
					(setq #i 0)
					(while 
						(and 
							(< #i (length (caddr #pdpt3s))) 
							(equal (car (nth #i (caddr #pdpt3s))) (car (nth #i (caddr #pdpt3stmp))) 0.1)
							(equal (cadr (nth #i (caddr #pdpt3s))) (cadr (nth #i (caddr #pdpt3stmp))) 0.1)
						)
						(setq #i (1+ #i))
					)
					(if (= #i (length (caddr #pdpt3s)))
						(setq #flg nil)
					)
				)
			)
			(if #flg
				(setq #pdpt3stmp$ (append #pdpt3stmp$ (list #pdpt3stmp)))
			)
		)
		(setq #pdpt3s$ #pdpt3stmp$)
	)
	(setq #pdpt3s$ #pdpt3tmp$)
	
	; Yが全て同じ寸法をまとめ、X座標の平均を取る。
	; 側面側に寸法の発生を優先させるため、平均を求める時に重みを3倍にしている。
	(setq #pdpt4$ nil)
	(setq #pdpt3$ (append #pdpt3f$ #pdpt3s$))
	(while (setq #pdpt3 (car #pdpt3$))
		(setq #xx (* (cadr #pdpt3) (if (< (caar #pdpt3) 10) 1 3)))
		(setq #j (if (< (caar #pdpt3) 10) 1 3))
		(setq #pdpt3$ (cdr #pdpt3$))
		(setq #pdpt3tmp$ nil)
		(while (setq #pdpt3tmp (car #pdpt3$))
			(setq #pdpt3$ (cdr #pdpt3$))
			(setq #flg nil)
			(if (and (= (cadar #pdpt3) (cadar #pdpt3tmp)) (= (length (caddr #pdpt3)) (length (caddr #pdpt3tmp))))
				(progn
					(setq #i 0)
					(while 
						(and 
							(< #i (length (caddr #pdpt3))) 
							(equal (cadr (nth #i (caddr #pdpt3))) (cadr (nth #i (caddr #pdpt3tmp))) 0.1)
						)
						(setq #i (1+ #i))
					)
					(if (= #i (length (caddr #pdpt3)))
						(setq #flg T)
					)
				)
			)
			(if #flg
				(progn
					(setq #xx (+ #xx (* (cadr #pdpt3tmp) (if (< (caar #pdpt3tmp) 10) 1 3))))
					(setq #j (+ #j (if (< (caar #pdpt3tmp) 10) 1 3)))
				)
				(setq #pdpt3tmp$ (append #pdpt3tmp$ (list #pdpt3tmp)))
			)
		)
		(setq #pdpt3$ #pdpt3tmp$)
		(setq #pdpt4$ (append #pdpt4$ (list (list (car #pdpt3) (/ #xx #j) (caddr #pdpt3)))))
	)

	(setq #pdpt4L$ nil #pdpt4R$ nil)
	(foreach #pdpt4 #pdpt4$
		(defun ##SortMinPdpt4 ( &Pdpt4 &Pdpt4$ / )
			(if (or (not &Pdpt4$) (< (cadr (caaddr #pdpt4)) (cadr (caaddr (car &Pdpt4$)))))
				(append (list #pdpt4) &Pdpt4$)
				(append (list (car &Pdpt4$)) (##SortMinPdpt4 #pdpt4 (cdr &Pdpt4$)))
			)
		)
		(if (< (abs (- #minx (cadr #pdpt4))) (abs (- #maxx (cadr #pdpt4))))
			(setq #pdpt4L$ (##SortMinPdpt4 #pdpt4 #pdpt4L$))
			(setq #pdpt4R$ (##SortMinPdpt4 #pdpt4 #pdpt4R$))
		)
	)
	(foreach #pdpt4 #pdpt4L$
		(setq #iti (KCFDrawDimDoubuti3Exec (list #minx #y 0.0) CG_CeilHeight (caddr #pdpt4) &flg (nth 2 #iti$) PI (cadar #pdpt4)))
		(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) #iti (nth 3 #iti$)))
	)
	(foreach #pdpt4 #pdpt4R$
		(setq #iti (KCFDrawDimDoubuti3Exec (list #maxx #y 0.0) CG_CeilHeight (caddr #pdpt4) &flg (nth 3 #iti$) 0.0 (cadar #pdpt4)))
		(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) (nth 2 #iti$) #iti))
	)
	
	
	#iti$
) ; SCFDrawDimDoubuti3


;;;<HOM>************************************************************************
;;; <関数名>  : SCFDrawDimSekou
;;; <処理概要>: 施工寸法を作図する
;;; <戻り値>  : 位置リスト（上 下 左 右）
;;; <作成>    : 1998-07-07
;;; <備考>    : 00/05/09 HN MOD 施工寸法に施工情報追加予定
;;;************************************************************************>MOH<
(defun SCFDrawDimSekou (
	&attr$     ; (LIST) 属性と座標リスト
	&appa$     ; (LIST) アッパーキャビネット座標リスト
	&base$     ; (LIST) ベースキャビネット座標リスト
	&off       ; (REAL) 指定寸法寸法線補助線長さ
	&bpt$      ; (LIST) 基準点リスト（アッパー ベース）
	/
	#appa$ #ap$ #ajp$ #i #pt1 #pt2 #iti #aiti$ #base$ #bp$
	#bjp$ #biti$ #iti$ #aiti #biti
	)

	; アッパー／ベース領域の４点座標取得
	(if &appa$
		(setq #appa$
			(list
				(car &appa$)
				(list (car (cadr &appa$))(cadr (car &appa$)))
				(cadr &appa$)
				(list (car (car &appa$))(cadr (cadr &appa$)))
			)
		)
	)
	(if &base$
		(setq #base$
			(list
				(car &base$)
				(list (car (cadr &base$))(cadr (car &base$)))
				(cadr &base$)
				(list (car (car &base$))(cadr (cadr &base$)))
			)
		)
	)

	;//////////////////アッパーキャビネット//////////////////
	; 01/04/05 TM MOD-S アッパーキャビネットが存在しない場合は無視
	(if &appa$
		(progn
			;自動上下左右、指定に分ける
			(setq #ap$ (SCFGetPtenBy4Dire (list #appa$ #base$) &attr$ "A"))
			(setq #ajp$ (car #ap$))
			;並べ替え
			(setq #ajp$ (list (nth 1 #ajp$)(nth 3 #ajp$)(nth 0 #ajp$)(nth 2 #ajp$)))

			;自動の寸法線を作図
			(setq #i 0)
			(repeat (length #appa$)
				(setq #pt1 (nth #i #appa$))
				(if (/= nil (nth (1+ #i) #appa$))
					(setq #pt2 (nth (1+ #i) #appa$))
					(setq #pt2 (car #appa$))
				)
				(if (/= nil (nth #i #ajp$))
					(progn
						(if (> (car #pt1) (car #pt2))
							(setq #iti (SCFDrawDimByPpt2Pt (list #pt1 #pt2) (nth #i #ajp$) (car  &bpt$)))
							(setq #iti (SCFDrawDimByPpt2Pt (list #pt2 #pt1) (nth #i #ajp$) (car  &bpt$)))
						)
					)
					(setq #iti 0)
				)
				(setq #aiti$ (cons #iti #aiti$))
				(setq #i (1+ #i))
			)
			; 01/04/11 TM MOD 該当の方向に単独寸法がある場合、寸法記入位置をずらす
			(if (= 1 (car (car (cadr #ap$))))
				(setq #aiti$ (list (nth 0 #aiti$) (1+ (nth 1 #aiti$)) (nth 2 #aiti$) (nth 3 #aiti$)))
			)

			;単独寸法作図
			(SCFDrawDimTandoku #appa$ (cadr #ap$) &off "U")
		)
		(progn
			(setq #aiti$ '(0 0 0 0))
		)
	)
	; 01/04/05 TM MOD-E アッパーキャビネットが存在しない場合は無視

	;//////////////////ベースキャビネット//////////////////
	; 01/04/05 TM MOD-S ベースキャビネットが存在しない場合は無視
	(if &base$
		(progn
			;自動上下左右、指定に分ける
			(setq #bp$ (SCFGetPtenBy4Dire (list #appa$ #base$) &attr$ "B"))
			(setq #bjp$ (car #bp$))
			;並べ替え
			(setq #bjp$ (list (nth 1 #bjp$)(nth 3 #bjp$)(nth 0 #bjp$)(nth 2 #bjp$)))

			;自動の寸法線を作図
			(setq #i 0)
			(repeat (length #base$)
				(setq #pt1 (nth #i #base$))
				(if (/= nil (nth (1+ #i) #base$))
					(setq #pt2 (nth (1+ #i) #base$))
					(setq #pt2 (car #base$))
				)

				(if (/= nil (nth #i #bjp$))
					(progn
						(if (> (car #pt1) (car #pt2))
							(setq #iti
								(SCFDrawDimByPpt2Pt (list #pt2 #pt1) (nth #i #bjp$) (cadr &bpt$))
							)
							(setq #iti
								(SCFDrawDimByPpt2Pt (list #pt1 #pt2) (nth #i #bjp$) (cadr &bpt$))
							)
						)
					)
					(setq #iti 0)
				)
				(setq #biti$ (cons #iti #biti$))
				(setq #i (1+ #i))
			)
			; 01/04/11 TM MOD 該当の方向に単独寸法がある場合、寸法記入位置をずらす
			(if (= 2 (car (car (cadr #ap$))))
				(setq #biti$ (list (nth 0 #biti$) (nth 1 #biti$) (1+ (nth 2 #biti$)) (nth 3 #biti$)))
			)
			;単独寸法作図
			(SCFDrawDimTandoku #base$ (cadr #bp$) &off "B")
		)
		(progn
			(setq #biti$ '(0))
		)
	)
	; 01/04/05 TM MOD-E ベースキャビネットが存在しない場合は無視

	;寸法位置獲得
	(setq #iti$ (mapcar '(lambda ( #aiti #biti ) (max #aiti #biti)) #aiti$ #biti$))
	;並べ替え
	(setq #iti$ (list (nth 1 #iti$)(nth 3 #iti$)(nth 0 #iti$)(nth 2 #iti$)))

	#iti$
) ; SCFDrawDimSekou

; 01/04/11 TM-MOD-E 外に出して名称変更
;<HOM>************************************************************************
;
; <関数名>    : KCFIsInArea
;
; <処理概要>  : 現在の領域に存在するか
;
; <戻り値>    : T=する, nil=しない
;
; <備考>      : チェックしているのは高さのみ
;************************************************************************>MOH<
; 領域外 の点も考慮するように変更関数作成 00/10/31 HT START
(defun KCFIsInArea (
	&dPt		; 対象となる点
	&dArea$		; ベース側４点座標
	&sUorB		; アッパー="A" ベース="B"
	/
	#Ret			; 戻り値
	#rBorder	; 座標境界値
	)

	; 01/04/12 TM ADD 天井高さ／２で区別するように変更
	(setq #rBorder (+ (/ CG_CeilHeight 2.0) (apply 'min (mapcar 'cadr &dArea$))))

	(if (= &sUorB "A")
		(progn
; 01/04/12 TM DEL 天井高さ／２で区別するように変更
;			; アッパーキャビの一番下よりも上の場合はアッパー
;			(setq #rBorder (apply 'min (mapcar 'cadr &dArea$)))
;			(if (>= (cadr (cadr &dPt)) #rBorder)
			(if (> (cadr (cadr &dPt)) #rBorder)
				(setq #Ret T)
			)
		)
		(progn
; 01/04/12 TM DEL 天井高さ／２で区別するように変更
;			; ベースキャビの一番上よりも下の場合はベース
;			(setq #rBorder (apply 'max (mapcar 'cadr &dArea$)))
			(if (<= (cadr (cadr &dPt)) #rBorder)
				(setq #Ret T)
			)
		)
	)

	#Ret
)
; 領域外 の点も考慮するように変更 00/10/31 HT END
; 01/04/11 TM-MOD-E 外に出して名称変更

;<HOM>************************************************************************
;
; <関数名>    : SCFGetPtenBy4Dire
;
; <処理概要>  : キャビネット４点座標リストからＰ点を方向ごとに分ける
;
; <戻り値>    : Ｐ点リスト
;               （（上 下 左 右）単独）
; <備考>      : アッパーキャビネットは 下 を
;               ベースキャビネットは   上 を省略する
;************************************************************************>MOH<
(defun SCFGetPtenBy4Dire (
	&pt$    ; (LIST) ４点座標リスト ((アッパー) (ベース))
	&p$     ; (LIST) Ｐ点の属性と座標のリスト
	&flg    ; (STR)  キャビネットフラグ（"A"=アッパー "B"=ベース）
	/
	#flg #p$ #min #zoku1 #i #pt1 #pt2 #pp #dis #cond #dn$ #rt$ #up$ #lt$ #tandoku$
	#isIn	; 該当領域にあるか
	#pt$	; 現在の４点座標
	)

; 01/04/11 TM MOD-S 条件を変更するとともに外に出した
; KCFIsInArea 参照
;  ; 領域外 の点も考慮するように変更関数作成 00/10/31 HT START
;  ; アッパー領域より上=アッパー
;  ; ベース領域より下=ベース
;	(defun ##IsUpperArea (
;		&Ppt		; 対象となる点
;		&up$		; 領域の４点
;		/
;  )
;  ; 領域外 の点も考慮するように変更 00/10/31 HT END
; 01/04/11 TM MOD-E 条件を変更するとともに外に出した

	; 初期設定
	(if (= "A" &flg)
		(progn
			(setq #flg 0)
			(setq #pt$ (car &pt$))
		)
		(progn
			(setq #flg 2)
			(setq #pt$ (cadr &pt$))
		)
	)

	(foreach #p$ &p$
		(setq #min nil)
		(setq #zoku1 (car  (car #p$)))

		;; 内外判定関数変更
		; if (IsPtInPolygon (cadr #p$) &pt$)
		; 領域外 の点も考慮するように変更 00/10/31 HT
		; アッパー領域より上=アッパー
		; ベース領域より下=ベース
		;if (##IsUpperArea #p$ (car &pt$) (cadr &pt$))
		; 指定された領域内に収まっているか
		(if (KCFIsInArea #p$ (cadr &pt$) &flg)
			(progn
				(cond
					((= 0 #zoku1)                  ;自動
						(setq #i 0)
						(repeat (length #pt$)
							(setq #pt1 (nth #i #pt$))
							(if (/= nil (nth (1+ #i) #pt$))
								(setq #pt2 (nth (1+ #i) #pt$))
								(setq #pt2 (car #pt$))
							)
							(if (/= #i #flg)
								(progn
									(setq #pp (cadr #p$))
									(setq #dis (SCFGetPerDist #pp #pt1 #pt2))
									(if (or (= nil #min) (> #min #dis))
										(setq #min #dis #cond #i)
									)
								)
							)
							(setq #i (1+ #i))
						)
						(if (= &flg "A") (setq #cond 2))
						(if (= &flg "B") (setq #cond 0));00/12/27 SN ADD
						(cond
							((= 0 #cond) (setq #dn$ (cons #p$ #dn$)))
							((= 1 #cond) (setq #rt$ (cons #p$ #rt$)))
							((= 2 #cond) (setq #up$ (cons #p$ #up$)))
							((= 3 #cond) (setq #lt$ (cons #p$ #lt$)))
							(T                                   nil)
						)
					)
					((or (= 1 #zoku1) (= 2 #zoku1) (= 3 #zoku1) (= 4 #zoku1))
						(setq #tandoku$ (cons #p$ #tandoku$))
					)
					(T
						nil
					)
				)
			)
		)
	)

	(list (list #up$ #dn$ #lt$ #rt$) #tandoku$)
) ;SCFGetPtenBy4Dire

;;;<HOM>************************************************************************
;;; <関数名>  : SCFDrawDimLinAddStr
;;; <処理概要>: ２点の座標とＰ点リストから寸法線を作図し、文字列を追加する
;;; <戻り値>  : 寸法線位置
;;; <備考>    : 00/05/18 HN 施工寸法に施工情報を追加
;;; 				  : 01/02/15 TM 関数内にあるのを外に出した
;;;************************************************************************>MOH<
(defun SCFDrawDimLinAddStr (
	&pt$    ; (LIST) 寸法位置座標リスト
	&bpt    ; (LIST) 基点座標      （nilのとき&pt$の値をそのまま使用）
	&dpt    ; (LIST) 寸法位置座標
	&flg    ; (STR)  寸法方向フラグ（水平:"H" 垂直:"V"）
	&iDimID ; 寸法文字ID
	/
	#bRet   ; 寸法図形作成フラグ
	#eEn    ; 寸法図形名
	#xPt$		; 寸法描画点
	)
;	(princ "\n&pt$") (princ &pt$)
;	(princ "\n&bpt") (princ &bpt)
;	(princ "\n&dpt") (princ &dpt)
;	(princ "\n&flg") (princ &flg)
;	(princ "\n&iDimID") (princ &iDimID)
	
	(if (setq #bRet (SCFDrawDimLin &pt$ &bpt &dpt &flg))
		(progn
			; 01/03/04 水平寸法の場合のみ文字列を追加する
			;if (< 0 &iDimID)
			(if (< 0 &iDimID)
;			(if (and (< 0 &iDimID) (eq &flg "H"))
				(progn
					(setq #eEn (entlast))               ; 寸法図形
;	01/03/08 TM MOD
;					(SCFUpdDimStr #eEn &iDimID)
					(if (SCFUpdDimStr #eEn &iDimID)
						; 寸法文字列を基点側に寄せる
						(SCFUpdDimStrPlacement #eEn (nth 0 &pt$) "L" '(0.0 0.0 0.0) (eq &flg "H"))
					)

				)
			)
		)
		(progn
			(if (< 0 &iDimID)
				(progn
					(princ "\n 施工情報付き寸法の図形が作成されませんでした。") 
				)
			)
		)
	)
	#bRet
)

;;;<HOM>************************************************************************
;;; <関数名>  : SCFDrawDimPptTanRen
;;; <処理概要>: Ｐ点リストから寸法を単独と連続に分ける
;;; <戻り値>  : (単独点リスト 連続点リスト)
;;; <備考>    : 01/02/28 TM
;;;************************************************************************>MOH<
(defun SCFDrawDimPptTanRen (
	&p$		; Ｐ点リスト
	/
	#p$		; Ｐ点データ操作変数 
	#tan$	; 単独寸法データ
	#ren$	; 連続寸法データ
	)

	; Ｐ点ごとに単独寸法と連続寸法に分ける
	(mapcar
	 '(lambda ( #p$ )
			(cond
				; 属性の2番目の項目が 0 か、最初が0で2番目が正  01/02/23 TM
				((or
					(= 0 (cadr (car #p$)))
					(and (< 0 (cadr (car #p$))) (= 0 (car (car #p$))))
				 )
					(setq #tan$ (cons #p$ #tan$))   ;単独寸法
				)
				; 属性の2番目の項目が1  01/02/23 TM
				((= 1 (cadr (car #p$)))
					(setq #ren$ (cons #p$ #ren$))   ;連続寸法
				)
				(T
					nil
				)
			)
		)
		&p$
	)
	(list #tan$ #ren$)

) ;_defun SCFDrawDimPptTanRen


;;;<HOM>************************************************************************
;;; <関数名>  : SCFDrawLineSortPzAttr
;;; <処理概要>: X座標順にソートする
;;; <戻り値>  : (((x y z) (x y z) ・・・) (属性 属性・・・))
;;; <備考>    : 
;;;************************************************************************>MOH<
(defun SCFDrawLineSortPzAttr (
	&tan$		; 単独寸法リスト  ((属性 x y z) ...
	/
	#t$			; ((x y z) (x y z) ・・・)
	#tmp$		; 寸法リスト一時変数
	#tmp2$	; P点 施工寸法位置 属性2 (0 115 ・・・)
	#dPt		; マージ処理用
	#dPtW		; マージ処理用
	)
	(setq #tmp$ '())
	; 属性と座標をソート関数の形式に合わせてひっくり返す
	(mapcar '(lambda (#x)
		(setq #tmp$ (append #tmp$ (list (append (cadr #x) (list (car #x))))))
		)
		&tan$
	)
	(setq #tmp$ (SCFmg_sort$ 'car #tmp$))

	; 01/02/06 HN S-ADD X座標でのマージ処理を追加
	(setq #dPtW  nil)
	(setq #tmp2$ nil)
	(foreach #dPt #tmp$
		; 01/04/05 TM MOD-S 寸法座標のマージ条件を変更（位置が同一でも属性が異なる場合は別にする）
		;if (not (equal (car  #dPtW) (car  #dPt)))
;;;		(if (not (equal (car  #dPtW) (car  #dPt))) ; 03/07/14 YM MOD
		(if (not (equal (car  #dPtW) (car  #dPt) 0.01) ) ; 03/07/14 YM MOD
			(progn
				(setq #tmp2$ (cons #dPt #tmp2$))
			)
			(progn
;;;				(if (not (equal (SCFGetDimStr  (cadr (last #dPtW))) (SCFGetDimStr (cadr (last  #dPt))))) ; 03/07/14 YM MOD
				(if (not (equal (SCFGetDimStr  (cadr (last #dPtW))) (SCFGetDimStr (cadr (last  #dPt))) 0.01) ) ; 03/07/14 YM MOD
					(setq #tmp2$ (cons #dPt #tmp2$))
				)
			)
		)
		; 01/04/05 TM MOD-E 寸法座標のマージ条件を変更（位置が同一でも属性が異なる場合は別にする）
		(setq #dPtW #dPt)
	)
	(setq #tmp$ (reverse #tmp2$))
	; (princ "\n#tmp$: ")(princ #tmp$)
	; (getstring "\n##SortPzAttr() Enter Key !!")
	; 01/02/06 HN E-ADD X座標でのマージ処理を追加

	(setq #tmp2$ '() #t$ '())
	(mapcar '(lambda (#x)
		(setq #tmp2$ (append #tmp2$ (list (cadr (nth 3 #x)))))
		(setq #t$ (append #t$ (list (list (nth 0 #x) (nth 1 #x) (nth 2 #x)))))
		)
		#tmp$
	)
	(list #t$ #tmp2$)

) ;defun SCFDrawLineSortPzAttr

;;;<HOM>************************************************************************
;;; <関数名>  : SCFDrawDimByPpt2Pt
;;; <処理概要>: ２点の座標とＰ点リストから寸法線を作図する
;;; <戻り値>  : 寸法線位置
;;; <備考>    : 00/05/18 HN 施工寸法に施工情報を追加
;;;************************************************************************>MOH<
(defun SCFDrawDimByPpt2Pt (
	&pt$    ; (LIST) ２点座標
	&p$     ; (LIST) Ｐ点の属性と座標リスト
	&basePt ; (LIST) 基準点
	/
	#ang 		; 寸法線のなす角度
	#dang 	; 寸法線の法線の角度
	#ty 
	#bpt$ 
	#iti1 
	#iti2 
	#p$ 
	#tan$ 
	#tan
	#ren$ 
	#p 
	#pt$ 
	#dpt 
	#dis 
	#flg 
	#iDimID		; P図形ID
	#eDim
	#sSQL			; 寸法文字列を取得するSQL
	#qry$			; クエリー
	#sDimStr	; 寸法文字列
	#ed
	#ret
	#Attr$
	#basept		; 01/02/27 TM ADD 足切り用基準点
	#ret$			; 操作変数 01/02/28 TM 
	)

; 01/02/28 TM DEL-S 関数を外に出した  SCFDrawLineAddStr を参照
;	 (SCFDrawDimLin)後、文字列を追加する
;  (defun ##DrawDimLin (
;  ) ;defun ##DrawDimLin
	;-----------------------------------------------------------------
; 01/02/28 TM DEL-E 関数を外に出した

; 01/02/28 TM DEL-S 関数を外に出した  SCFDrawLineSortPzAttr を参照
;	(defun ##SortPzAttr (
;  ) ;defun ##SortPzAttr
	;-----------------------------------------------------------------
; 01/02/28 TM DEL-E 関数を外に出した  SCFDrawLineSortPzAttr を参照

	; 初期設定
	(setq #ang  (angle (car &pt$) (cadr &pt$)))			; 角度
	(setq #dang (- #ang (* 0.5 PI)))								; 寸法角度
	; ソート方向、方向文字を角度から計算する
	(if (or (equal 0.0 #ang 0.01) (equal PI #ang 0.01))
		(setq #ty "X" #bpt$ (SCFmg_sort$ 'car  &pt$))
		(setq #ty "Y" #bpt$ (SCFmg_sort$ 'cadr &pt$))
	)
	(setq #iti1 0)
	(setq #iti2 0)

	; Ｐ点データから、寸法を単独寸法と連続寸法に分ける
	(setq #ret$ (SCFDrawDimPptTanRen &p$))
	(setq #tan$ (car #ret$))
	(setq #ren$ (cadr #ret$))

; #tan$ 正常時
;;;(
;;; ((0 14) (10485.0 1845.0 12150.0))
;;; ((0 131) (10415.0 1845.0 12150.0))
;;; ((0 131) (10415.0 1845.0 1850.0))
;;; ((0 131) (10415.0 1845.0 11250.0))
;;; ((0 131) (10415.0 1845.0 1100.0))
;;;) 

	; 横寸法  TM
	(if (= #ty "X")
		(progn                              ;上 下
			;単独寸法
			(if (/= nil #tan$)
				(progn
					; X座標順にソートする 00/10/30 START
;          (setq #ret (##SortPzAttr #tan$)) ; 01/02/28 TM MOD ソート関数を外に出した
					(setq #ret (SCFDrawLineSortPzAttr #tan$))
					(setq #tan$ (car #ret) ; 正常時 ((10415.0 1845.0 1100.0) (10485.0 1845.0 12150.0))
								#Attr$ (cadr #ret))
					;(setq #tan$ (SCFmg_sort$ 'car  (mapcar 'cadr #tan$)))
					; X座標順にソートする 00/10/30 END

					(if (/= nil &basePt)
						; 基準点あり  TM
						(progn
							; 基準点より左側の場合、順序を逆にする TM
							(if (< (car (car #tan$)) (car &basept))
								(progn
									(setq #tan$ (reverse #tan$))
									(setq #Attr$ (reverse #Attr$))
								)
							)
							; すべての寸法について線を引く  TM
							(mapcar
							 '(lambda ( #p #a )
									(setq #pt$ (list &basePt #p))
									(setq #dpt (polar &basePt #dang (GetDimHeight #iti1)))
									; (SCFDrawDimLin #pt$ nil #dpt "H") 00/10/30 HT mod
									;(##DrawDimLin #pt$ nil #dpt "H" #a) 01/02/28 TM 関数を外に出した
									(SCFDrawDimLinAddStr  #pt$ nil #dpt "H" #a)
									(setq #iti1 (1+ #iti1))
								)
								#tan$ #Attr$
							)
						)
						; 基準点なし  TM
						(progn
							; #dis 二つの座標の中点からのX方向の差  TM
							(setq #dis  (* 0.5 (- (car (cadr #bpt$)) (car (car #bpt$)))))
							; #flg 中点より右側に寸法端点がある場合 nil  TM
							(setq #flg T)
							(if (> (- (car (car #tan$)) (car (car #bpt$))) #dis)
								(setq #flg nil)
							)
							; 中点より左側にあるものを処理
							(while #flg

								; #pt$ 基点と単独寸法
								(setq #pt$ (list (car #bpt$) (car #tan$)))
								; #dpt 寸法数字の基点
								(setq #dpt (polar (car #bpt$) #dang (GetDimHeight #iti1)))
								;(SCFDrawDimLin #pt$ nil #dpt "H") 00/10/30 HT mod
								;(##DrawDimLin #pt$ nil #dpt "H" (car #Attr$)) 01/02/28 TM 関数を外に出した
								(SCFDrawDimLinAddStr  #pt$ nil #dpt "H" (car #Attr$))

								; 端点と属性のリストの先頭を削除
								(setq #tan$ (cdr #tan$))
								(setq #Attr$ (cdr #Attr$)) ;00/10/30 ADD
								; 端点リストがなくなったら終了
								(if (= 0 (length #tan$))
									(setq #flg nil)
									(if (> (- (car (car #tan$)) (car (car #bpt$))) #dis)
										(setq #flg nil)
									)
								)
								(setq #iti1 (1+ #iti1))

							)
							; 中点より右側にあるものを処理
							(mapcar
							 '(lambda ( #tan #a )
									(setq #pt$ (list (cadr #bpt$) #tan))
									(setq #dpt (polar (car #bpt$) #dang (GetDimHeight #iti2)))
									;(SCFDrawDimLin #pt$ nil #dpt "H") 00/10/30 HT mod
									;(##DrawDimLin #pt$ nil #dpt "H" #a) ; 01/02/28 TM 関数を外に出した
									(SCFDrawDimLinAddStr #pt$ nil #dpt "H" #a)
									(setq #iti2 (1+ #iti2))
								)
								(reverse #tan$) (reverse #Attr$) ; 00/10/30 (reverse #tan$)
							)
						)
					)
				)
			)
			
			;連続寸法
			(if (/= nil #ren$)
				(progn
					(setq #ren$ (SCFmg_sort$ 'car  (mapcar 'cadr #ren$)))
					(setq #pt$ (append (list (car  #bpt$)) #ren$ (list (cadr #bpt$))))
					(setq #dpt (polar (car #bpt$) #dang (GetDimHeight (max #iti1 #iti2))))
					(SCFDrawDimLin #pt$ #nil #dpt "H")
					(setq #iti1 (1+ (max #iti1 #iti2)))
				)
			)
		)
		(progn                              ;左 右
			(if (/= nil #tan$)
				(progn
					;単独寸法
					; X座標順にソートする 00/10/30 START
					;(setq #ret (##SortPzAttr #tan$)) 01/02/28 TM 関数を外に出した
					(setq #ret (SCFDrawLineSortPzAttr #tan$))
					(setq #tan$ (car #ret)
								#Attr$ (cadr #ret))
					; (setq #tan$ (SCFmg_sort$ 'cadr (mapcar 'cadr #tan$)))
					; X座標順にソートする 00/10/30 END
					(setq #dis  (* 0.5 (- (cadr (cadr #bpt$)) (cadr (car #bpt$)))))
					(setq #flg T)
					(if (> (- (cadr (car #tan$)) (cadr (car #bpt$))) #dis)
						(setq #flg nil)
					)
					;上
					(while #flg
						(setq #pt$ (list (car #bpt$) (car #tan$)))
						(setq #basept (list (caar #bpt$) (+ (DimGetHeight #iti1) (caadr #bpt$)) (caaddr #bpt$)))
;            (setq #dpt (polar (car #bpt$) #dang (GetDimHeight #iti1)))
						(setq #dpt (polar (car #bpt$) #dang (GetDimHeight -1)))
						; (SCFDrawDimLin #pt$ nil #dpt "V") 00/10/30 HT mod
;            (##DrawDimLin #pt$ nil #dpt "V" (car #Attr$)) ; 01/02/28 TM 関数を外に出した
						(SCFDrawDimLinAddStr #pt$ #basept #dpt "V" (car #Attr$))
						(setq #tan$ (cdr #tan$))
						(setq #Attr$ (cdr #Attr$)) ;00/10/30 ADD
						(if (= 0 (length #tan$))
							(setq #flg nil)
							(if (> (- (cadr (car #tan$)) (cadr (car #bpt$))) #dis)
								(setq #flg nil)
							)
						)
						(setq #iti1 (1+ #iti1))
					)
					;下
					(mapcar
					 '(lambda ( #tan #a )
							(setq #pt$ (list (cadr #bpt$) #tan))
							(setq #dpt (polar (car #bpt$) #dang (GetDimHeight #iti2)))
							; (SCFDrawDimLin #pt$ nil #dpt "V") 00/10/30 HT mod
							; (##DrawDimLin #pt$ nil #dpt "V" #a) ; 01/02/28 TM 関数を外に出した
;							01/03/04 TM 
;            	(SCFDrawDimLinAddStr #pt$ nil #dpt "V" #a)
							(SCFDrawDimLin #pt$ nil #dpt "V" #a)
							(setq #iti2 (1+ #iti2))
						)
						(reverse #tan$) (reverse #Attr$) ; 00/10/30 HT (reverse #tan$)
					)
				)
			)
			(if (/= nil #ren$)
				(progn
					;連続寸法
					(setq #ren$ (SCFmg_sort$ 'car  (mapcar 'cadr #ren$)))
					(setq #pt$ (append (list (car #bpt$)) #ren$ (list (cadr #bpt$))))
					(setq #dpt (polar (car #bpt$) #dang (GetDimHeight (max #iti1 #iti2))))
					(SCFDrawDimLin #pt$ nil #dpt "V")
					(setq #iti1 (1+ (max #iti1 #iti2)))
				)
			)
		)
	)

	(max #iti1 #iti2)

) ; SCFDrawDimByPpt2Pt


;;;<HOM>************************************************************************
;;; <関数名>  : SCFDrawDimTandoku
;;; <処理概要>: 単独寸法作図
;;; <戻り値>  : なし
;;; <備考>    : 2001/10/18 HN 引数&sFlag追加
;;;             左右の場合は、アッパーは上から、ベースは下から寸法線を引く。
;;;             2001/12/07 HN 左右上下の寸法補助線の長さを変更
;;;             引数&offは無効とする
;;;             #rDimOffLenUL= 50.0 上／左
;;;             #rDimOffLenBR=120.0 下／右
;;;************************************************************************>MOH<
(defun SCFDrawDimTandoku
	(
	&pt$        ; (LIST) 領域座標リスト
	&tanp$      ; (LIST) 単独寸法リスト
	&off        ; (REAL) 寸法補助線の長さ
	&sFlag      ; (STR)  "U":アッパー  "B":ベース
	/
	#disx #disy #p$ #zoku$ #pten #pt$ #dpt #flg1 #flg2
	#rOffUL ; 上／左  01/12/07 HN ADD
	#rOffBR ; 下／右  01/12/07 HN ADD
	)
	(setq #rOffUL  50.0)  ; 01/12/07 HN ADD
	(setq #rOffBR 120.0)  ; 01/12/07 HN ADD

	; 基準点間の距離
	(setq #disx (distance (nth 0 &pt$) (nth 1 &pt$)))
	(setq #disy (distance (nth 1 &pt$) (nth 2 &pt$)))
	(mapcar
	 '(lambda ( #p$ )
			(setq #zoku$ (car  #p$))    ;属性リスト
			(setq #pten  (cadr #p$))    ;座標
			;寸法線座標取得
			(cond
				((and (= 1 (car #zoku$)) (<= 0 (cadr #zoku$)))     ;上 単独 (and (= 1 (car #zoku$))(= 0 (cadr #zoku$)))
					(if (< (- (car #pten) (car (nth 0 &pt$))) (* 0.5 #disx))
						(setq #pt$ (list (list (car (nth 1 &pt$)) (cadr #pten)) #pten)) ;左
						(setq #pt$ (list (list (car (nth 0 &pt$)) (cadr #pten)) #pten)) ;右
					)
				 	; 01/12/07 HN MOD 左右上下の寸法補助線の長さを変更
					;@MOD@(setq #dpt (list (car #pten) (+ (cadr #pten) &off)))
					(setq #dpt (list (car #pten) (+ (cadr #pten) #rOffUL)))
					(setq #flg1 nil)
					(setq #flg2 "H")
				)
				((and (= 2 (car #zoku$))(<= 0 (cadr #zoku$)))     ;下 単独 (and (= 2 (car #zoku$))(= 0 (cadr #zoku$)))
					(if (< (- (car #pten) (car (nth 0 &pt$))) (* 0.5 #disx))
						(setq #pt$ (list (list (car (nth 1 &pt$)) (cadr #pten)) #pten)) ;左 01/07/12 HN MOD "0" → "1"
						(setq #pt$ (list (list (car (nth 0 &pt$)) (cadr #pten)) #pten)) ;右 01/07/12 HN MOD "1" → "0"
					)
				 	; 01/12/07 HN MOD 左右上下の寸法補助線の長さを変更
					;@MOD@(setq #dpt (list (car #pten) (- (cadr #pten) &off)))
					(setq #dpt (list (car #pten) (- (cadr #pten) #rOffBR)))
					(setq #flg1 nil)
					(setq #flg2 "H")
				)
				((and (= 3 (car #zoku$))(<= 0 (cadr #zoku$)))     ;左 単独 (and (= 3 (car #zoku$))(= 0 (cadr #zoku$)))
					; 01/10/18 HN S-MOD アッパー／ベースで寸法位置を変更
					;@MOD@; 01/07/12 HN DEL 下からのみとする
					;@MOD@;@DEL@(if (< (- (cadr #pten)(cadr (nth 0 &pt$))) (* 0.5 #disy))
					;@MOD@  (setq #pt$ (list (list (car #pten) (cadr (nth 0 &pt$))) #pten)) ;下
					;@MOD@;@DEL@  (setq #pt$ (list (list (car #pten) (cadr (nth 2 &pt$))) #pten)) ;上
					;@MOD@;@DEL@)
					(if (= "U" &sFlag)
						(setq #pt$ (list (list (car #pten) (cadr (nth 2 &pt$))) #pten)) ; アッパーは上
						(setq #pt$ (list (list (car #pten) (cadr (nth 0 &pt$))) #pten)) ; ベース  は下
					)
					; 01/10/18 HN E-MOD アッパー／ベースで寸法位置を変更
				 	; 01/12/07 HN MOD 左右上下の寸法補助線の長さを変更
					;@MOD@(setq #dpt (list (- (car #pten) &off) (cadr #pten)))  ; 01/07/12 HN MOD "+" → "-"
					(setq #dpt (list (- (car #pten) #rOffUL) (cadr #pten)))
					(setq #flg1 nil)
					(setq #flg2 "V")
				)
				((and (= 4 (car #zoku$))(<= 0 (cadr #zoku$)))     ;右 単独 (and (= 4 (car #zoku$))(= 0 (cadr #zoku$)))
					; 01/10/18 HN S-MOD アッパー／ベースで寸法位置を変更
					; 01/07/12 HN DEL 下からのみとする
					;@DEL@(if (< (- (cadr #pten) (cadr (nth 0 &pt$))) (* 0.5 #disy))
						(setq #pt$ (list (list (car #pten) (cadr (nth 0 &pt$))) #pten)) ;下
					;@DEL@  (setq #pt$ (list (list (car #pten) (cadr (nth 2 &pt$))) #pten)) ;上
					;@DEL@)
					(if (= "U" &sFlag)
						(setq #pt$ (list (list (car #pten) (cadr (nth 2 &pt$))) #pten)) ; アッパーは上
						(setq #pt$ (list (list (car #pten) (cadr (nth 0 &pt$))) #pten)) ; ベース  は下
					)
					; 01/10/18 HN E-MOD アッパー／ベースで寸法位置を変更
				 	; 01/12/07 HN MOD 左右上下の寸法補助線の長さを変更
					;@MOD@(setq #dpt (list (+ (car #pten) &off) (cadr #pten)))  ; 01/07/12 HN MOD "-" → "+"
					(setq #dpt (list (+ (car #pten) #rOffBR) (cadr #pten)))
					(setq #flg1 nil)
					(setq #flg2 "V")
				)
				; 00/05/18 HN MOD 連続タイプの判定変更 1 → -1
				((and (= 1 (car #zoku$))(= -1 (cadr #zoku$)))     ;上 連続
					(setq #pt$ (list (nth 0 &pt$) #pten (nth 1 &pt$)))
				 	; 01/12/07 HN MOD 左右上下の寸法補助線の長さを変更
					;@MOD@(setq #dpt (list (car #pten) (+ (cadr #pten) &off)))
					(setq #dpt (list (car #pten) (+ (cadr #pten) #OffUL)))
					(setq #flg1 #pten)
					(setq #flg2 "H")
				)
				; 00/05/18 HN MOD 連続タイプの判定変更 1 → -1
				((and (= 2 (car #zoku$))(= -1 (cadr #zoku$)))     ;下 連続
					(setq #pt$ (list (nth 0 &pt$) #pten (nth 1 &pt$)))
				 	; 01/12/07 HN MOD 左右上下の寸法補助線の長さを変更
					;@MOD@(setq #dpt (list (car #pten) (- (cadr #pten) &off)))
					(setq #dpt (list (car #pten) (- (cadr #pten) #rOffBR)))
					(setq #flg1 #pten)
					(setq #flg2 "H")
				)
				; 00/05/18 HN MOD 連続タイプの判定変更 1 → -1
				((and (= 3 (car #zoku$))(= -1 (cadr #zoku$)))     ;左 連続
					(setq #pt$ (list (nth 0 &pt$) #pten (nth 2 &pt$)))
				 	; 01/12/07 HN MOD 左右上下の寸法補助線の長さを変更
					;@MOD@(setq #dpt (list (- (car #pten) &off) (cadr #pten)))
					(setq #dpt (list (- (car #pten) #rOffUL) (cadr #pten)))
					(setq #flg1 #pten)
					(setq #flg2 "V")
				)
				; 00/05/18 HN MOD 連続タイプの判定変更 1 → -1
				((and (= 4 (car #zoku$))(= -1 (cadr #zoku$)))     ;右 連続
					(setq #pt$ (list (nth 0 &pt$) #pten (nth 2 &pt$)))
				 	; 01/12/07 HN MOD 左右上下の寸法補助線の長さを変更
					;@MOD@(setq #dpt (list (+ (car #pten) &off) (cadr #pten)))
					(setq #dpt (list (+ (car #pten) #rOffBR) (cadr #pten)))
					(setq #flg1 #pten)
					(setq #flg2 "V")
				)
			)
			;寸法線作図
;@@@(princ "\n#pt$: " )(princ #pt$ )
;@@@(princ "\n#flg1: ")(princ #flg1)
;@@@(princ "\n#dpt: " )(princ #dpt )
;@@@(princ "\n#flg2: ")(princ #flg2)
;@@@(getstring "\ndebug: ")
			(if (SCFDrawDimLin #pt$ #flg1 #dpt #flg2)
				(progn
				; 寸法線作成成功した時
				; P点位置や属性が正しくないとき、寸法線作成できない
				;@@@(getstring "\nSCFDrawDimLin END: ")

				;00/05/18 HN S-ADD 寸法に施工情報文字を付加
				(setq #iDimID (cadr #zoku$))         ; 寸法文字ID
				(setq #eDim (entlast))               ; 寸法図形
				; 01/03/04 TM MOD 水平寸法の場合のみ文字列を追加する
				(if (< 0 #iDimID)
;				(if (and (< 0 #iDimID) (or (= 1 (car #zoku$)) (= 2 (car #zoku$))))
					(progn
						; 施工寸法文字列を追加
						; 01/05/31 TM MOD 施工寸法文字列が存在しない場合を考慮
						(if (SCFUpdDimStr #eDim #iDimID)
							; 基点側に寄せる
							(SCFUpdDimStrPlacement #eDim #dpt "L" '(0 0 0) (or (= 1 (car #zoku$)) (= 2 (car #zoku$))))
						)
					)
				)
			) ; progn
			(progn
				(setq #iDimID (cadr #zoku$))         ; 寸法文字ID
				(if (< 0 #iDimID)
					(progn
					(princ "\n 施工情報付き寸法の図形が作成されませんでした。P点座標:") (princ #pten)
					)
				)
			)
			) ; 寸法作成成功
		;00/05/18 HN E-ADD 寸法に施工情報文字を付加
		)
	&tanp$
	)

	(princ)
) ; SCFDrawDimTandoku


;;;<HOM>************************************************************************
;;; <関数名>  : SCFUpdDimStr
;;; <処理概要>: 寸法文字列修正
;;; <戻り値>  : nil=寸法文字列修正失敗(文字列がない)
;;; <備考>    : CG_CDBSession OK 01/04/05 TM ADD
;;;************************************************************************>MOH<
(defun SCFUpdDimStr (
	&eEn        ; 図形名
	&iID        ; 図形ID
;	&xBasePt		; 寸法基点 ; 01/04/17 TM DEL ここでは動かさない仕様に変更
	/
	#sDimStr    ; 寸法文字列
	)

	; 寸法文字列を取得する
	(setq #sDimStr (SCFGetDimStr &iID))
	; 01/05/31 TM MOD 文字列がない場合を考慮
	(cond 
		((or (= nil #sDimStr) (= "" #sDimStr))
			; 01/05/31 TM ADD 施工寸法文字列がない場合に警告する
			;(princ (strcat "\n施工寸法文字列が未登録です: 文字ID=" (itoa &iID)))

;;;			(CFAlertMsg (strcat "\n施工寸法文字列が未登録です:文字ID=" (itoa &iID)))
 			(WebOutLog (strcat "\n施工寸法文字列が未登録です:文字ID=" (itoa &iID)))
			nil
		)
		(t
			(setq #sDimStr (strcat "<> " #sDimStr))
			(setq #ed$ (entget &eEn))
			(setq #ed$ (subst (cons 1 #sDimStr) (assoc 1 #ed$) #ed$))
			(entmod #ed$)
		)
	);_cond
); SCFUpdDimStr

;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetDimStr
;;; <処理概要>: 寸法文字列取得
;;; <戻り値>  : 寸法文字列
;;; <備考>    : CG_CDBSession OK
;;;************************************************************************>MOH<
(defun SCFGetDimStr (
	&iID        ; 図形ID
	/
	#sSQL       ; SQL文
	#qry$       ; クエリー
	)

	(if (= &iID 0)
		(progn
			nil	
		)
		(progn
			(setq #sSQL (strcat "select * from 寸法文字 where 文字ID=" (rtois &iID)))
			(setq #qry$ (car (DBSqlAutoQuery CG_CDBSession #sSQL)))
		)
	)

	(cadr #qry$)

)

;;;<HOM>************************************************************************
;;; <関数名>  : SCFDispDimStr
;;; <処理概要>: 寸法文字列の座標表示
;;; <戻り値>  : なし
;;; <備考>    : 01/02/26 TM 新規追加  水平な場合のみ有効
;;;************************************************************************>MOH<
(defun SCFDispDimStr (
	&eEn			; 図形名
	/
	#ed$				; 図形エンティティ
	#xLtHogPos	; W
	#nn					; 操作変数
	)

	; 図形エンティティ取得
	(setq #ed$ (entget &eEn))

	(foreach #nn '(10 11 12 13 14)

		(princ "\n寸法文字座標 (")
		(princ #nn)
		(princ "): ")
		; 寸法文字列の基準座標
		(if (/= nil (assoc #nn #ed$))
			(progn
				(setq #xLtHogPos (assoc #nn #ed$))
				(princ #xLtHogPos)
			)
			; 01/02/23 TM ADD 属性がない場合
			(progn
				(princ "属性なし")
			)
		)
	)
	(princ)

)

;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetStrWidth
;;; <処理概要>: 寸法文字列の幅を計算する
;;; <戻り値>  : 文字列の幅
;;; <備考>    : 01/02/26 TM 新規追加  水平な場合のみ有効
;;;************************************************************************>MOH<
(defun SCFGetStrWidth (
	&eEn				; 寸法図形名
	/
	#ed$				; 図形エンティティ
	#etmp$			; 作業用エンティティ
	#sDimStr		; 1 寸法文字列
	#rStrW			; 文字列幅
	)

	; 図形エンティティ取得
	(setq #ed$ (entget &eEn))

	(setq #etmp$ nil)
	; 文字列本体	   
	(if (/= nil (assoc 1 #ed$))
		(progn 
			(setq #etmp$ (list (assoc 1 #ed$)))
			(setq #etmp$ (cons (cons 0 "TEXT") #etmp$))
			; 文字のデフォルトサイズが分からん ZAN  TM 01/02/28
			(setq #etmp$ (cons (cons 40 CG_Dim1CharWidth) #etmp$))
		)
		(progn
			(princ "\n寸法文字列がない")
			nil
		)
	)

	(setq #xDiag (textbox #etmp$))
;	(princ "\n文字列:")	(princ #xDiag)
	
	(if #xDiag
		(progn
			(setq #rStrW (abs (- (caar #xDiag) (caadr #xDiag))))
;			(princ "\n文字列幅:")	(princ #rStrW)
			#rStrW
		)
		0
	)
)

;;;<HOM>************************************************************************
;;; <関数名>  : SCFCoodToStr
;;; <処理概要>: 座標リストを文字列に変換する
;;; <戻り値>  : 座標のカンマ区切り文字列  "XXXX.XX,YYYY.YY,ZZZZ.ZZ"
;;; <備考>    : 01/02/26 TM 新規追加
;;;************************************************************************>MOH<
(defun SCFCoodToStr (
	&cood$			; ３次元座標
	/
	#cood_str		; 座標文字列
	#rr					; 操作変数(座標)
	)
	
	(setq #cood_str nil)
	(if (/= 3 (length &cood$))
		(progn
			(princ "\n座標が異常: ")
			(princ &cood$)
			nil
		)
	)

	(foreach #rr &cood$
		(if (/= nil #cood_str) 
			(progn 
				(setq #cood_str (strcat #cood_str "," (rtos #rr)))
			)
			(progn
				(setq #cood_str (rtos #rr))
			)
		)
	)
	#cood_str
)

;;;<HOM>************************************************************************
;;; <関数名>  : SCFGetDimStrCood
;;; <処理概要>: 寸法文字列を置く座標を計算する
;;; <戻り値>  : 座標
;;; <備考>    : 01/02/26 TM 新規追加
;;; 					: デフォルトでは左寄せする
;;; 					: 水平の場合しか考慮していない
;;;************************************************************************>MOH<
(defun SCFDimStrCood (
	&xBase		; 基準座標
	&xCent		; 文字列中心
	&xDim			; 寸法座標
	&rWidth		; 文字列の幅
	&xBase0		; 寸法の基点
	&sLR			; 左右寄せの指定 "R" 右寄せ それ以外は左寄せ
	/
	#sLR			; 左右フラグ
	#rOffset	; ずらし幅
	#xDest		; 戻り値座標
	#xBase0Pt	; 寸法基準点
	#xBasePt	; 移動対象となる基準点
	#xDimPt		; 移動対象となる寸法点
	)

	(setq #rOffSet 0.0)

	; 寸法基準点
	(setq #xBase0Pt &xBase0)

	; 01/04/17 TM ADD 左右指定を追加
	(if &sLR
		(setq #sLR &sLR)
		(setq #sLR "L")
	)

	;DEBUG (princ "\n寸法寄せ指定:")
	;DEBUG (princ #sLR)

	; 基点座標との距離が近いほうが原点 ....仕様１
;	(if (> (distance &xBase &xBase0) (distance &xDim &xBase0))
;		(progn
;			(setq #xBasePt &xBase)
;			(setq #xDimPt &xDim)
;		)
;		(progn
;			(setq #xBasePt &xDim)
;			(setq #xDimPt &xBase)
;		)
;	)

	; 01/04/17 TM MOD X 座標の大きい方を基点とする ... 仕様２（左寄せ専用）
	(if (< (car &xBase) (car &xDim))
		(progn
			(setq #xBasePt &xDim)
			(setq #xDimPt &xBase)
		)
		(progn
			(setq #xBasePt &xBase)
			(setq #xDimPt &xDim)
		)
	)

	; 基点と寸法の座標の大小で右寄せか左寄せかを判定する
	;(if (< (car #xBasePt) (car #xDimPt))
	;	(setq #sLR "R")
	;	(setq #sLR "L")
	;)

	; Ｘ座標のオフセット
	(cond 
		((eq #sLR "R")
			; l<-width------>|
			; 888.8 寸法文字列
			;      +---------+
			;      |    ^    |
			;      Dim Cent Base
			;
			; dest-x    =  B - w / 2         
			; default-x =  B - (B - D) / 2    = c  -
			; offset    =  (B - D - w) / 2
			(setq #rOffset (/ (- (car #xBasePt) &rWidth (car #xDimPt)) 2)))

		((eq #sLR "L")
		 	; l<----- w ----->|
		 	;  888.8 寸法文字列
		 	; +---------+
		 	; |    ^    |
		 	; D    C    B
		 	;
		 	; dest-x    =  D + w / 2         
		 	; default-x =  (B + D) / 2    = C  -
		 	; offset    =  (D + w - B) / 2
		 	(setq #rOffset (/ (- (+ (car #xDimPt) &rWidth) (car #xBasePt)) 2))
		)

		(t (princ "\n異常な左右判定") (setq #rOffset 0.0))
	)

	; オフセットを反映
	(if (/= #rOffset 0.0)
		(setq #xDest (polar &xCent 0.0 #rOffset))
		(setq #xDest &xCent)
	)

	#xDest

)

;;;<HOM>************************************************************************
;;; <関数名>  : SCFUpdDimStrPlacement
;;; <処理概要>: 寸法文字列座標修正
;;; <戻り値>  : なし
;;; <備考>    : 01/02/06 TM 新規追加
;;;************************************************************************>MOH<
(defun SCFUpdDimStrPlacement (
	&eEn        ; 図形名
	&xBasePt		; 寸法基点
	&sLR				; 右／左寄せ "R" 右寄せ それ以外は左
	&dOffs			; 移動オフセット
	&fH			; 水平の場合T
	/
	#ed$				; 図形属性
	#nYdir			; 70 寸法表示方向
	#rStrW			; 寸法文字列幅
	#nLtPosTyp	; 72 寸法文字の横方向基準位置指定 (0=左 1=中心 2=右 3=両端 4=中央 5=フィット)
	#xLtBasPos	; 10 基準位置座標
	#xLtCtrPos	; 11 文字列中央位置座標
	#xLtOthPos	; 13 寸法端座標
	#ii
	#xPos				; 計算された座標
	#ptH$
	#dist
	#ang
#kpdeploy ; 2011/12/15 YM ADD
	)

	; エンティティを取得
	(setq #ed$ (entget &eEn))

	; 方向   TM
	; 垂直の場合=1 水平の場合=0
	(if &fH
		(setq #nYDir 0)
		(setq #nYDir 1)
	)
;|
	(if (/= nil (assoc 70 #ed$))
		(progn
			(setq #nYDir (rem (lsh (cdr (assoc 70 #ed$)) -8) 2))
		)
		; 01/02/23 TM ADD 属性がない場合デフォルトは水平寸法と考える
		(progn
			(setq #nYDir 0)
		)
	)
|;

	; 寸法の基準座標 
	(if (/= nil (assoc 10 #ed$))
		(progn
			(setq #xLtBasPos$ (cdr (assoc 10 #ed$)))
		)
		(progn
			(princ "寸法表示基準座標がない 10")
		)
	)

	; 寸法文字列の配置座標
	(if (/= nil (assoc 11 #ed$))
		(progn
			(setq #xLtCtrPos$ (cdr (assoc 11 #ed$)))
		)
		(progn
			(princ "寸法文字表示位置がない 11")
		)
	)

	; 寸法の座標 
	(if (/= nil (assoc 13 #ed$))
		(progn
			(setq #xLtOthPos$ (cdr (assoc 13 #ed$)))
		)
		(progn
			(princ "寸法表示座標がない 13")
		)
	)

	; 寸法文字列の幅 ZAN 寸法数字本体の幅の考慮が不足
	; ZAN 現状 "<> 寸法文字列" の幅になっているため、
	; ZAN 大きい数字の寸法だと"<>" と実際の寸法の数字の幅の差だけずれる
	; ZAN e.g. "129.3 銅鑼型水栓" だと約３文字分(プロポーショナル文字のため、正確には異なる）
	; 08/09/16 タカラの文字幅取得処理

	;2016/01/13 YM DEL-S
;;;	;2011/12/15 YM ADD-S
;;;  (cond
;;;    ((= "17" CG_ACADVER)
;;;   		(setq #kpdeploy "kpdeploy17.arx")
;;;	 	)
;;;    ((= "18" CG_ACADVER)
;;;   		(setq #kpdeploy "kpdeploy18.arx")
;;;	 	)
;;;    ((= "19" CG_ACADVER)
;;;   		(setq #kpdeploy "kpdeploy19.arx")
;;;	 	)
;;;    (T
;;;			(CFAlertMsg "\nARXのバージョンが対応していません(kpdeploy18.arx)")
;;;	 	)
;;;	);_cond
;;;	;2011/12/15 YM ADD-E
	;2016/01/13 YM DEL-E

	;2016/01/13 YM DEL-S
;;;	(if (= nil (member #kpdeploy (arx)))	;2011/12/15 YM ADD-S ACADバージョンによって区別
;;;		(setq #rStrW (SCFGetStrWidth &eEn))
;;;	;else
;;;		(progn

			;// 寸法文字の幅を取得する
			(setq #hnd (cdr (assoc 5 (entget &eEn))))
			(command "SCFGetDimTextWidth" #hnd)
			(setq #rStrW (+ CG_DIMTEXTW CG_SEKOU_DIMSTR_L_OFFSET))

;;;		)
;;;	)
	;2016/01/13 YM DEL-E

	; 水平方向、かつ寸法数字以外に文字列がある場合のみ、文字列を追加／寄せる
	(command ".-osnap" "") ; 01/04/10 TM ADD 寸法がOSNAP でずれるので、強制的にOFF にする
	(if (and (/= 1 #nYDir) (/= "<>" #sDimStr))
		(progn
			(command "_.dimtedit" &eEn  
				(SCFCoodToStr (mapcar '+ (SCFDimStrCood #xLtBasPos$ #xLtCtrPos$ #xLtOthPos$ #rStrW &xBasePt &sLR)
																	&dOffs
											)
				)
			)
		)
		(progn
			; T.Ari Mod
			; 垂直の場合座標を回転して求める
;			(command "_.dimtedit" &eEn  (SCFCoodToStr (mapcar '+ &dOffs #xLtBasPos$) &xBasePt &sLR))
			(setq #ptH$
				(mapcar '+ (SCFDimStrCood #xLtBasPos$ #xLtCtrPos$ #xLtOthPos$ #rStrW &xBasePt &sLR) &dOffs)
			)
			(setq #ang (+ (angle #xLtCtrPos$ #ptH$) (* 0.5 PI)))
			(setq #dist (distance #xLtCtrPos$ #ptH$))
			(command "_.dimtedit" &eEn  (SCFCoodToStr (polar #xLtCtrPos$ #ang #dist)))
		)
	)
	(princ)
) ; _defun SCFUpdDimStrPlacement

