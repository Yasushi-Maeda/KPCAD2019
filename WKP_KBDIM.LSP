;<HOM>*************************************************************************
; <関数名>    : SBGetPEntity
; <処理概要>  : 指定文字列寸法位置Ｐ図形取得
; <戻り値>    : Ｐ図形リスト
;               （
;                 （
;                   （検索文字 PT1 PT2）            水平
;                   （検索文字 PT1 PT2）...
;                 ）
;                 （
;                   （検索文字 PT1 PT2）            垂直
;                   （検索文字 PT1 PT2）...
;                 ）
;               ）
; <備考>      : 基準座標に近いほうをPT1とする
; <作成>      : 1998-10-16
;*************************************************************************>MOH<
(defun SBGetPEntity (
  &layer   ; (STR)      内観図画層名
  &bpt     ; (LIST)     基準座標
  /
  #ss #i #en #eg #eed$ #data$ #pt #lstx1$ #lstx2$ #lsty1$ #lsty2$ #lst1 #dd$
  #fpt #lpt #lstx_n$ #lsty_n$
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBGetPEntity ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "内観図画層名                    : ")(CFOutStateLog 1 1 &layer  )
  (CFOutStateLog 1 1 "基準座標                        : ")(CFOutStateLog 1 1 &bpt    )
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  (CFOutStateLog 1 1 "Ｐ図形取得")
  (setq #ss (ssget "X" (list (cons 8 &layer)(list -3 (list "G_PTEN")))))

  (CFOutStateLog 1 1 "各データ獲得")
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
        ; 属性データ取得
        (setq #data$ (mapcar 'cdr (cdr #eed$)))

        ; 点図形の座標取得
        (setq #pt  (cdr (assoc 10 #eg)))

        (if (= 11 (car #data$))                  ;指定文字寸法位置
          (cond
            ((= 0 (nth 1 #data$))               ;水平
              (if (assoc (nth 2 #data$) #lstx1$)
                (setq #lstx2$ (cons (list (nth 2 #data$) #pt) #lstx2$))
                (setq #lstx1$ (cons (list (nth 2 #data$) #pt) #lstx1$))
              )
            )
            ((= 1 (nth 1 #data$))               ;垂直
              (if (assoc (nth 2 #data$) #lsty1$)
                (setq #lsty2$ (cons (list (nth 2 #data$) #pt) #lsty2$))
                (setq #lsty1$ (cons (list (nth 2 #data$) #pt) #lsty1$))
              )
            )
          )
        )

        (setq #i (1+ #i))

      ) ; end repeat

      ;リスト編集
      ;水平
      (mapcar
       '(lambda ( #lst1 )
          (setq #dd$ (assoc (car #lst1) #lstx2$))
          (if (/= nil #dd$)
            (progn
              (if (< (distance &bpt (cadr #lst1)) (distance &bpt (cadr #dd$)))
                (setq #fpt (cadr #lst1) #lpt (cadr  #dd$))
                (setq #fpt (cadr  #dd$) #lpt (cadr #lst1))
              )
              (setq #lstx_n$ (cons (list (car #lst1) #fpt #lpt) #lstx_n$))
            )
          )
        )
        #lstx1$
      )
      (mapcar
       '(lambda ( #lst1 )
          (setq #dd$ (assoc (car #lst1) #lsty2$))
          (if (/= nil #dd$)
            (progn
              (if (< (distance &bpt (cadr #lst1)) (distance &bpt (cadr #dd$)))
                (setq #fpt (cadr #lst1) #lpt (cadr  #dd$))
                (setq #fpt (cadr  #dd$) #lpt (cadr #lst1))
              )
              (setq #lsty_n$ (cons (list (car #lst1) #fpt #lpt) #lsty_n$))
            )
          )
        )
        #lsty1$
      )

    )
  ) ; end if

  (list #lstx_n$ #lsty_n$)
) ; SBGetPEntity


;<HOM>*************************************************************************
; <関数名>    : SBDrawDImension
; <処理概要>  : 寸法線作図
; <戻り値>    : なし
; <作成>      : 1998-10-16
;*************************************************************************>MOH<
(defun SBDrawDImension (
  &bpt     ; (LIST)     基準座標
  &pdata$  ; (LIST)     P点データ
  &offw    ; (REAL)     ユニットオフセット量W
  &offd    ; (REAL)     ユニットオフセット量D
  &thickw  ; (REAL)     パネル厚みW
  &thickd  ; (REAL)     パネル厚みD
  &baseoff ; (REAL)     基準オフセット量
  /
  #ss #pdata$ #offh$ #offv$ #i #en #eg #str$ #lsth$ #lstv$ #j #lsth #off #pdata #lstv
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawDImension ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "基準座標                        : ")(CFOutStateLog 1 1 &bpt    )
  (CFOutStateLog 1 1 "P点データ                       : ")(CFOutStateLog 1 1 &pdata$ )
  (CFOutStateLog 1 1 "ユニットオフセット量W           : ")(CFOutStateLog 1 1 &offw   )
  (CFOutStateLog 1 1 "ユニットオフセット量D           : ")(CFOutStateLog 1 1 &offd   )
  (CFOutStateLog 1 1 "パネル厚みW                     : ")(CFOutStateLog 1 1 &thickw )
  (CFOutStateLog 1 1 "パネル厚みD                     : ")(CFOutStateLog 1 1 &thickd )
  (CFOutStateLog 1 1 "基準オフセット量                : ")(CFOutStateLog 1 1 &baseoff)
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  (CFOutStateLog 1 1 "寸法図形取得")
  (setq #ss (ssget "X" (list (cons 0 "DIMENSION"))))

  (setq #pdata$ &pdata$)
;(dpr '&offw)
;(dpr '&thickw)

  (CFOutStateLog 1 1 "各データ獲得")
  (if (/= nil #ss)
    (progn

      ; オフセット量リスト作成
      (if (equal CG_SIZECODE "1620")
        (setq #offh$ (list (+ &baseoff &offw &thickw) (+ &baseoff &offw)))   ; 水平
        (setq #offh$ (list (+ &baseoff &thickw) &baseoff))                   ; 水平
      )
      (setq #offv$ (list (+ &offd &thickd) &offd))                           ; 垂直

      ; 寸法文字列取得
      (setq #i 0)
      (repeat (sslength #ss)

        ; 図形名取得
        (setq #en    (ssname #ss #i))
        ; 図形データ取得
        (setq #eg    (entget #en '("*")))
        ; 寸法文字列データ取得
        (setq #str$  (SBGetDataByDimBlock &bpt #en))
        ; リストに格納
        (if (= "H" (car #str$))
          (setq #lsth$ (cons (cdr #str$) #lsth$))
          (setq #lstv$ (cons (cdr #str$) #lstv$))
        )

        (setq #i (1+ #i))
      ) ; end repeat

      (setq #lsth$ (SBmg_sort$ 'cadadr #lsth$))
      (setq #lstv$ (SBmg_sort$ 'caadr  #lstv$))

      ;水平寸法作図
      (setq #i 0)
      (setq #j 0)
      (repeat (length #lsth$)
        (setq #lsth (nth #i #lsth$))
        (setq #off  (nth #j #offh$))
        (mapcar
         '(lambda ( #pdata )
            (if (wcmatch (car #lsth) (strcat "*" (car #pdata) "*"))
              (progn
                (SBDrawDim (nth 1 #lsth) (nth 1 #pdata) (nth 2 #pdata) (nth 2 #lsth) #off "H")
                (setq #j (1+ #j))
              )
            )
          )
          (car &pdata$)
        )
        (setq #i (1+ #i))
      )

      ;垂直寸法作図
      (setq #i 0)
      (setq #j 0)
      (repeat (length #lstv$)
        (setq #lstv (nth #i #lstv$))
        (setq #off  (nth #j #offv$))
        (mapcar
         '(lambda ( #pdata )
            (if (wcmatch (car #lstv) (strcat "*" (car #pdata) "*"))
              (progn
                (SBDrawDim (nth 1 #lstv) (nth 1 #pdata) (nth 2 #pdata) (nth 2 #lstv) #off "V")
                (setq #j (1+ #j))
              )
            )
          )
          (cadr &pdata$)
        )
        (setq #i (1+ #i))
      )
    )
  ) ; end if

  ; (princ)
) ; SBDrawDImension
;<HOM>*************************************************************************
; <関数名>    : SBGetDataByDimBlock
; <処理概要>  : 寸法線の文字列図形（MTEXT）の文字列を取得する
; <戻り値>    : 値リスト（水平垂直フラグ、文字列、挿入基点、寸法図形名）
; <作成>      : 1998-10-16
;*************************************************************************>MOH<
(defun SBGetDataByDimBlock (
  &bpt     ; (LIST)     基準座標
  &en      ; (ENAME)    寸法図形名
  /
  #eg #13 #14 #50 #flg #pt #2 #deg #en #str
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBGetDataByDimBlock ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "基準座標                        : ")(CFOutStateLog 1 1 &bpt    )
  (CFOutStateLog 1 1 "寸法図形名                      : ")(CFOutStateLog 1 1 &en     )
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  ;図形データ取得
  (setq #eg (entget &en))
  (setq #13 (cdr (assoc 13 #eg)))
  (setq #14 (cdr (assoc 14 #eg)))
  (setq #50 (cdr (assoc 50 #eg)))

  ;水平垂直フラグ取得
  (if (equal 0.0 #50 0.0001)
    (setq #flg "H")
    (setq #flg "V")
  )

  ;基準座標に近い寸法定義座標を取得
  (if (< (distance &bpt #13)(distance &bpt #14))
    (setq #pt #13)
    (setq #pt #14)
  ) ; end if

  ;寸法文字列取得
  (setq #2  (cdr (assoc 2 #eg)))
  (setq #deg (entget (tblobjname "BLOCK" #2)))
  (setq #en (cdr (assoc -2 #deg)))
  (while (/= nil #en)

    (setq #deg (entget #en))
    (if (equal "MTEXT" (cdr (assoc 0 #deg)))

      (setq #str  (cdr (assoc 1 #deg)))           ;寸法文字列

    ) ; end if
    (setq #en (entnext #en))

  ) ; end while

  (list #flg #str #pt &en) ; return
) ; SBGetDataByDimBlock

;<HOM>*************************************************************************
; <関数名>    : SBDrawDim
; <処理概要>  : 座標リストと基点座標と寸法位置座標から寸法線を作図する
; <戻り値>    : なし
; <作成>      : 1998-10-16
; <修正>      : 1999-02-15 （オフセットに応じて寸法線を移動するのをやめる）
; <備考>      : なし
;*************************************************************************>MOH<
(defun SBDrawDim (
  &bpt     ; (LIST)     基点座標
  &pt1     ; (LIST)     P点座標１（基準点に近いほう）
  &pt2     ; (LIST)     P点座標２
  &en      ; (LIST)     基準寸法線図形名
  &off     ; (REAL)     近いほうからのオフセット量
  &flg     ; (STR)      水平垂直フラグ
  /
  #layer #osmode #dimse1 #dimse2 #clayer #off #ang #dis #pt1n #eg #10 #13 #14 #pt2n
  #dm
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawDim ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "基準座標                        : ")(CFOutStateLog 1 1 &bpt    )
  (CFOutStateLog 1 1 "P点座標１                       : ")(CFOutStateLog 1 1 &pt1    )
  (CFOutStateLog 1 1 "P点座標２                       : ")(CFOutStateLog 1 1 &pt2    )
  (CFOutStateLog 1 1 "基準寸法線図形名                : ")(CFOutStateLog 1 1 &en     )
  (CFOutStateLog 1 1 "近いほうからのオフセット量      : ")(CFOutStateLog 1 1 &off    )
  (CFOutStateLog 1 1 "水平垂直フラグ                  : ")(CFOutStateLog 1 1 &flg    )
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  ;画層設定
  (setq #layer (cdr (assoc 8 (entget &en))))
  ;システム変数格納
  (setq #osmode (getvar "OSMODE"))
  (setq #dimse1 (getvar "DIMSE1"))
  (setq #dimse2 (getvar "DIMSE2"))
  (setq #clayer (getvar "CLAYER"))
  ;システム変数設定
  (setvar "OSMODE" 0)
;  (setvar "DIMSE1" 1)
;  (setvar "DIMSE2" 1)
  (setvar "CLAYER" #layer)

  (setq #eg (entget &en '("*")))
  (setq #10 (cdr (assoc 10 #eg)))
  (setq #13 (cdr (assoc 13 #eg)))
  (setq #14 (cdr (assoc 14 #eg)))

  (if (/= nil &off)
    (setq #off &off)
    (setq #off 0.0)
  )

  (if (> (distance #13 &pt1) (distance #14 &pt1))
    (progn
      (setq #dm #13)
      (setq #13 #14)
      (setq #14 #dm)
    )
  )

  ;---Modify S.Kawamoto Start
  (setq #ang  (angle &pt1 #13))
  (if (= &flg "H")
    (if (< (* PI 0.5) #ang (* PI 1.5))
      (setq #ang 0.0)
      (setq #ang PI)
    )
    (if (< 0.0 #ang PI)
      (setq #ang (* PI 0.5))
      (setq #ang (* PI 1.5))
    )
  )
  ;---Modify S.Kawamoto End
;  (if (= nil (equal #dis #off))
;    (progn
;      (CFOutStateLog 1 1 "図形移動")
;      (command "_.MOVE" &en "" &bpt #pt1n)
;    )
;  )

  (command "_dimlinear" #13 &pt1 &flg #10)
  (command "_dimlinear" #14 &pt2 &flg #10)

  ;システム変数戻す
  (setvar "OSMODE" #osmode)
;  (setvar "DIMSE1" #dimse1)
;  (setvar "DIMSE2" #dimse2)
  (setvar "CLAYER" #clayer)

  (princ) ; return
) ; SBDrawDim


;<HOM>************************************************************************
;
; <関数名>    : SBmg_sort$
;
; <処理概要>  : 条件付きリストのリストのマージソートを行う
;
; <戻り値>    : ソートされたリスト
;
;
; <作成>      : 96-11-01 中村 靖
;
; <備考>      : (SKFmg_sort$ 'cadr '((6 5 4 3)(8 7 1 2)(1 2 3 4)(2 3 4 5)))
;
;************************************************************************>MOH<
(defun SBmg_sort$(
    &func ; 比較関数
    &L1$  ;ソートを行うリスト
    /
    #i1 #Ltmp$ #L2$ #flg #itmp #ret$ #ret #ret$$
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
) ; SBmg_sort$

;<HOM>*************************************************************************
; <関数名>    : SBModDimensionSketch
; <処理概要>  : 給排水設備図の寸法線の文字列にオフセット量を足す
; <戻り値>    : なし
; <作成>      : 1998-11-05
; <修正>      : 1999-03-01
;*************************************************************************>MOH<
(defun SBModDimensionSketch (
  &offw    ; (REAL)     ユニットオフセット量W
  &baseoff ; (REAL)     基準オフセット量
  /
  #ss #i #en #eg #len #str #subst #off
  )
  (CFOutStateLog 1 2 "//// SBModDimensionSketch ////")
  (CFOutStateLog 1 2 "--------------------引数 START-----------------")
  (CFOutStateLog 1 2 "ユニットオフセット量W           : ")(CFOutStateLog 1 2 &offw   )
  (CFOutStateLog 1 2 "基準オフセット量                : ")(CFOutStateLog 1 2 &baseoff)
  (CFOutStateLog 1 2 "--------------------引数 END-------------------")
;(dpr '&offw)
  (CFOutStateLog 1 2 "寸法図形取得")
  (setq #ss (ssget "X" (list (cons 1 "*`#*")(cons 0 "DIMENSION"))))

  ;-----------修正 森本------------
  (if (equal CG_SIZECODE "1620")
    (setq #off (+ &offw &baseoff))
    (setq #off &baseoff)
  )

  (CFOutStateLog 1 2 "各データ獲得")
  (if (/= nil #ss)
    (progn

      (setq #i 0)
      (repeat (sslength #ss)

        ; 図形名取得
        (setq #en    (ssname #ss #i))
        ; 図形データ取得
        (setq #eg    (entget #en '("*")))
        ; 寸法線長さ取得
        (setq #len (SBDIM_LEN #en))
        ; 寸法値編集
        (setq #str (rtos (+ #len #off)))
        ; 寸法線編集
        (setq #subst (subst (cons 1 #str) (assoc 1 #eg) #eg))
        (entmod #subst)
        (entupd #en)

        (setq #i (1+ #i))
      )

    )
  ) ; end if

  (princ)
)

;********************************************************
;  SBDIM_LEN
;
;  寸法図形の寸法値を取得する
;
;  引数 &en 寸法図形のｴﾝﾃｨﾃｨ名
;
;  返値 正確な寸法値(異常の場合は0.0を返す)
;********************************************************
(defun SBdim_len(
    &en
    /
    #0 #10 #13 #14 #15 #16 #50 #64 #70 #70flg #ang #ang10 #ang13 #ang14 #ang16
    #eg #int #int14 #len #vec10 #vec14 #vec15 #vec16
    )

  ;--------------------------------------------------------
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
  ;--------------------------------------------------------
  (setq #len 0.0)
  (setq #eg  (entget &en       ))
  (setq #0   (cdr(assoc  0 #eg)))
  (if(= "DIMENSION" #0)
    (progn
      (setq #70    (assoc 70 #eg) )
      (if(/= nil #70)
        (progn
          (setq #70(cdr      #70     ))
          (setq #70flg (boole 1 #70 7))  ;0～6
        )
        (progn
          (setq #70    0)
          (setq #70flg 0)
        )
      )
      (cond
        ((= 0 #70flg)
          (setq #50(cdr(assoc 50 #eg)))
          (setq #13(cdr(assoc 13 #eg)))
          (setq #14(cdr(assoc 14 #eg)))
          (cond
            ((equal 0.0       #50 0.0001)          ;水平
              (setq #len (abs(- (car  #13)(car  #14))))
            )
            ((equal (/ PI 2.) #50 0.0001)          ;垂直
              (setq #len (abs(- (cadr #13)(cadr #14))))
            )
            (T                                     ;角度
              (setq #int14 (inters #13 (polar #13 #50 1) #14 (polar #14 (+ #50 (* 0.5 PI)) 1) nil))
              (setq #len   (distance #13 #int14))
            )
          )
        )
    ((= 1 #70flg)                              ;平行
          (setq #13  (cdr(assoc 13 #eg)))
          (setq #14  (cdr(assoc 14 #eg)))
          (setq #len (distance #13 #14))
        )
    ((= 2 #70flg)                              ;角度
          (setq #10  (cdr(assoc 10 #eg)))
          (setq #13  (cdr(assoc 13 #eg)))
          (setq #14  (cdr(assoc 14 #eg)))
          (setq #15  (cdr(assoc 15 #eg)))
          (setq #16  (cdr(assoc 16 #eg)))
          (setq #ang14 (angle #14 #13))
          (setq #vec15 (mapcar '- #15 #10))
          (setq #int   (inters #10 #15 #13 #14 nil))
          (setq #vec16 (mapcar '- #16 #int))
          (setq #ang   (angle '(0 0 0) (pt1jiHenkan #vec15 (* -1 #ang14))))
          (setq #ang16 (angle '(0 0 0) (pt1jiHenkan #vec16 (* -1 #ang14))))
          (setq #ang16 (rem #ang16 PI))
          (if(> #ang16 #ang)
            (setq #ang (- PI #ang))
          )
          (setq #len   (* 180 (/ #ang PI)))
        )
    ((= 3 #70flg)                              ;直径
          (setq #10  (cdr(assoc 10 #eg)))
          (setq #15  (cdr(assoc 15 #eg)))
          (setq #len (distance #10 #15))
        )
    ((= 4 #70flg)                              ;半径
          (setq #10  (cdr(assoc 10 #eg)))
          (setq #15  (cdr(assoc 15 #eg)))
          (setq #len (distance #10 #15))
        )
    ((= 5 #70flg)                              ;角度３点
          (setq #10  (cdr(assoc 10 #eg)))
          (setq #13  (cdr(assoc 13 #eg)))
          (setq #14  (cdr(assoc 14 #eg)))
          (setq #15  (cdr(assoc 15 #eg)))
          (setq #ang13 (angle #15 #13))
          (setq #vec14 (mapcar '- #14 #15))
          (setq #vec10 (mapcar '- #10 #15))
          (setq #ang   (angle '(0 0 0) (pt1jiHenkan #vec14 (* -1 #ang13))))
          (setq #ang10 (angle '(0 0 0) (pt1jiHenkan #vec10 (* -1 #ang13))))
          (if(or(< #ang10 0.0)(> #ang10 #ang))
            (setq #ang (- (* 2 PI) #ang))
          )
          (setq #len   (* 180 (/ #ang PI)))
        )
    ((= 6 #70flg)                              ;座標寸法
      (setq #64  (boole 1 #70 64))
          (setq #10  (cdr(assoc 10 #eg)))
          (setq #13  (cdr(assoc 13 #eg)))
          (if(= 0 #64)
            (setq #len (-(cadr #13)(cadr #10)))
            (setq #len (-(car  #13)(car  #10)))
          )
        )
        (T
          (setq #len 0.0)
        )
      )
    )
  )
  #len
)
