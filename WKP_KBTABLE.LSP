;<HOM>*************************************************************************
; <関数名>    : SBDrawTableBefore
; <処理概要>  : 仕様表を作成するための環境を整える
; <戻り値>    : なし
; <作成>      : 1998-11-10
; <備考>      : テンプレートファイルで新規図面のとき展開図作成
;               図面に名前がある場合
;                 → 上書き保存し、新規図面にする
;               図面に名前はないが図形が存在するとき
;                 → 現在の図面を放棄し、新規図面にする
;*************************************************************************>MOH<
(defun SBDrawTableBefore (
  /
  #tempdir #view #tempfile
  )
  (CFOutStateLog 1 51 "//// SBDrawTableBefore ////")


  ; テンプレートファイル名
  (setq #tempfile (strcat CG_SYSPATH "template\\bath\\SB_仕様表.dwt"))
  (if (findfile #tempfile)
    (progn

      (CFOutStateLog 1 51 "テンプレートファイル名 = ")(CFOutStateLog 1 51 #tempfile)
      (if (/= nil CG_OpenMode)
        (progn

          (CFOutStateLog 1 51 "仕様表作図")
          (setq CG_OpenMode nil)
          (SBDrawTable)

        )
        (if (equal "DRAWING.DWG" (strcase (getvar "DWGNAME")))
          (progn
            (command "_point" "0,0")

            (CFOutStateLog 1 51 "新規図面にする")
            (setq CG_OpenMode 3)
            (if (= 0 (getvar "DBMOD"))
              ;00/02/03 HN S-MOD (command "_.new")を変更
              ;@@@(command "_.NEW" #tempfile)
              (CfDwgNewByScript #tempfile)
              ;00/02/03 HN E-MOD (command "_.new")を変更
              (progn
                (CFOutStateLog 1 51 "既存図面放棄")
                ;00/02/03 HN S-MOD (command "_.new")を変更
                ;@@@(command "_.NEW" "Y" #tempfile)
                (CfDwgNewByScript #tempfile)
                ;00/02/03 HN E-MOD (command "_.new")を変更
              )
            )

          )
          (progn

            (CFOutStateLog 1 51 "図面に名前が有る")
            (setq CG_OpenMode 3)
            (CFOutStateLog 1 51 "上書き保存")
            (command "_.QSAVE")
            (CFOutStateLog 1 51 "新規図面にする")
            ;00/02/03 HN S-MOD (command "_.new")を変更
            ;@@@(command "_.NEW" #tempfile)
            (CfDwgNewByScript #tempfile)
            ;00/02/03 HN E-MOD (command "_.new")を変更

          )
        ) ; end if

      ) ; end if

    )
    (progn
      (CFOutStateLog 0 42 "仕様表のテンプレートファイルが存在しません.")
      (CFOutStateLog 0 42 "テンプレートファイル名 = ")(CFOutStateLog 0 42 #tempfile)
    )
  ) ; end if

  (princ) ; return
) ; SKFDrawTableBefore

;<HOM>*************************************************************************
; <関数名>    : SBDrawTable
; <処理概要>  : 仕様表を作成する
; <戻り値>    : なし
; <作成>      : 1998-11-10
; <修正>      : 1999-02-15 （図面範囲は変更しないようにする）
; <備考>      : なし
;*************************************************************************>MOH<
(defun SBDrawTable (
  /
  #savedir #limmin #limmax #mlayer #tlayer #dbname #str$ #title$ #value$ #off$
  )
  (CFOutStateLog 1 51 "//// SKFDrawTable ////")


  ;--------------- 初期設定-----------------
  (setq #savedir CG_SBOUTPATH)

  ;図形範囲設定
;  (setq #limmin '(   0.0    0.0))                ; 図形範囲左下点
;  (setq #limmax '(8550.0 6000.0))                ; 図形範囲右上点
;  (setvar "LIMMIN" #limmin)
;  (setvar "LIMMAX" #limmax)

  ;画層
  (setq #mlayer "0_TEXT")                        ; 文字列画層
  (setq #tlayer "0_TITLET")                      ; タイトル画層
  ;-----------------------------------------

  (CFOutStateLog 1 1 "タイトル作成")
  (SBMakeTitleText
    #tlayer CG_PackName CG_BukkenName CG_SeriesName CG_KoujiKind
    CG_BukkenNo CG_Zno CG_ModelName
  )

  (CFOutStateLog 1 51 "仕様表作成のためのデータベース取得")
  ;;(setq #dbname (SBGetDbname))
  (setq #dbname CG_DBName)

  (CFOutStateLog 1 51 "データベースから文字列リスト取得")
  (setq #str$ (SBGetDBList #dbname))

  (setq #title$ (car  #str$))                     ; タイトル文字列
  (setq #value$ (cadr #str$))                     ; 仕様文字列

  (CFOutStateLog 1 51 "仕様表の文字列作図")
  (setq #off$ (SBDrawTableText #title$ #value$))

  (CFOutStateLog 1 51 "仕様表の罫線")
  (SBDrawTableLine #off$)

  (CFOutStateLog 1 41 "パージ")
  (command "_.-LAYER" "T" "*" "ON" "*" "U" "*" "")
  (command  "_.PURGE" "A" "*" "N")
  (command  "_.PURGE" "A" "*" "N")
  (command  "_.PURGE" "A" "*" "N")

  (CFOutStateLog 1 51 "図面範囲ZOOM")
  (command "_.ZOOM"   "A")

  (CFOutStateLog 1 1 "図面保存")
  (SBSaveas #savedir CG_BukkenNo CG_Zno)


  (princ) ; return
) ; SKFDrawPlanLayout

;<HOM>*************************************************************************
; <関数名>    : SBDrawTableText
; <処理概要>  : 仕様表の文字列作図
; <戻り値>    : 距離リスト
; <作成>      : 1998-11-10
; <備考>      : なし
;*************************************************************************>MOH<
(defun SBDrawTableText (
  &title$
  &value$
  /
  #title1 #title2 #value #ss #i #en #eg #1 #y2 #title110 #title111 #value10 #value11
  #dis #off #st #sv$ #10_n #11_n #subst #str #off$
  )
  (CFOutStateLog 1 51 "//// SKFDrawTableText ////")

  (setq
    #title1 "S^TITLE1"
    #title2 "S^TITLE2"
    #value  "S^VALUE"
  )
  (setq #ss (ssget "X" (list (cons 0 "TEXT")(cons 8 "0_TEXT")(cons 1 "S^*"))))
  (if (/= nil #ss)
    (progn

      ;図形データ取得
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #eg (entget #en))
        (setq #1  (cdr (assoc 1 #eg)))
        (cond
          ((equal #title2   #1)  (setq #y2    (cadr (cdr (assoc 10 #eg)))))
          ((equal #title1   #1)
            (setq #title1      #eg)
            (setq #title110   (cdr (assoc 10 #eg)))
            (setq #title111   (cdr (assoc 11 #eg)))
          )
          ((equal #value #1)
            (setq #value    #eg)
            (setq #value10 (cdr (assoc 10 #eg)))
            (setq #value11 (cdr (assoc 11 #eg)))
          )
          (T                 nil)
        )
        (entdel #en)
        (setq #i (1+ #i))
      )
      ;y軸方向の距離
      (setq #dis (abs (- #y2 (cadr (cdr (assoc 10 #title1))))))
      (setq #off 0)
      ;作図
      (mapcar
       '(lambda ( #st #sv$ )

          (setq #10_n (list (car #title110) (- (cadr #title110) #off) (caddr #title110)))
          (setq #11_n (list (car #title111) (- (cadr #title111) #off) (caddr #title111)))
          (setq #subst (subst (cons 10 #10_n) (assoc 10 #title1) #title1))
          (setq #subst (subst (cons 11 #11_n) (assoc 11 #subst) #subst))
          (setq #subst (subst (cons 1  #st)  (assoc  1 #subst) #subst))
          (entmake (cdr #subst))

          (mapcar
           '(lambda ( #str )

              (setq #10_n (list (car #value10) (- (cadr #value10) #off) (caddr #value10)))
              (setq #11_n (list (car #value11) (- (cadr #value11) #off) (caddr #value11)))
              (setq #subst (subst (cons 10 #10_n) (assoc 10 #value) #value))
              (setq #subst (subst (cons 11 #11_n) (assoc 11 #subst) #subst))
              (setq #subst (subst (cons 1  #str)  (assoc  1 #subst) #subst))
              (entmake (cdr #subst))

              (setq #off (+ #dis #off))
            )
            #sv$
          )
          (setq #off$ (cons #off #off$))
        )
        &title$ &value$
      )
    )
    (progn
      (CFOutStateLog 0 51 "SAMPLE文字列がありません")
    )
  ) ; end if

  (reverse #off$)
) ; SKFDrawTableText

;<HOM>*************************************************************************
; <関数名>    : SBDrawTableLine
; <処理概要>  : 仕様表の罫線作図
; <戻り値>    : なし
; <作成>      : 1998-11-10
; <備考>      : なし
;*************************************************************************>MOH<
(defun SBDrawTableLine (
  &off$     ; (REAL)     距離リスト
  /
  #ssv #ssh #eg #10 #11 #off #10_n #11_n #subst #y #i #en #dis10 #dis11 #pt
  )
  (CFOutStateLog 1 51 "//// SBDrawTableLine ////")
  (CFOutStateLog 1 51 "--------------------引数 START-----------------")
  (CFOutStateLog 1 51 "距離リスト                            : ")(CFOutStateLog 1 51 &off$   )
  (CFOutStateLog 1 51 "--------------------引数 END-------------------")

  (setq #ssv (ssget "X" (list (list -3 (list "G_VLINE")))))
  (setq #ssh (ssget "X" (list (list -3 (list "G_HLINE")))))
  (setq #eg (entget (ssname #ssh 0)))
  (setq #10 (cdr (assoc 10 #eg)))
  (setq #11 (cdr (assoc 11 #eg)))
  (mapcar
   '(lambda ( #off )
      (setq #10_n (list (car #10) (- (cadr #10) #off) (caddr #10)))
      (setq #11_n (list (car #11) (- (cadr #11) #off) (caddr #11)))
      (setq #subst (subst (cons 10 #10_n) (assoc 10 #eg) #eg))
      (setq #subst (subst (cons 11 #11_n) (assoc 11 #subst) #subst))
      (entmake (cdr #subst))
    )
    &off$
  )
  (setq #y (cadr #10_n))
  (setq #i 0)
  (repeat (sslength #ssv)
    (setq #en (ssname #ssv #i))
    (setq #eg (entget #en '("*")))
    (setq #10 (cdr (assoc 10 #eg)))
    (setq #11 (cdr (assoc 11 #eg)))
    (setq #dis10 (abs (- #y (cadr #10))))
    (setq #dis11 (abs (- #y (cadr #11))))
    (if (< #dis10 #dis11)
      (progn
        (setq #pt (list (car #10) #y (caddr #10)))
        (setq #subst (subst (cons 10 #pt) (cons 10 #10) #eg))
      )
      (progn
        (setq #pt (list (car #11) #y (caddr #11)))
        (setq #subst (subst (cons 11 #pt) (cons 11 #11) #eg))
      )
    )
    (entmod #subst)
    (setq #i (1+ #i))
  )

  (princ)
)


;<HOM>*************************************************************************
; <関数名>    : SBGetDbname
; <処理概要>  : データベース名称取得
; <戻り値>    : データベース名称
; <作成>      : 1998-11-10
; <備考>      : なし
;*************************************************************************>MOH<
(defun SBGetDbname (
  /
  #cfg$ #series$ #i #dbname_d #flg #dbname #s
  )
  (setq #cfg$    (SBreadCSV (strcat CG_SBDATAPATH "Manage\\series.cfg")))
  (setq #series$ (mapcar 'caddr #cfg$))
  (setq #i 0)
  (repeat (length #series$)
    (if (= 'STR (type (nth #i #series$)))
      (if (wcmatch (nth #i #series$) (strcat "*" CG_SeriesCode "*"))
        (setq #dbname_d (nth 3 (nth #i #cfg$)))
      )
    )
    (setq #i (1+ #i))
  )
  (setq #i 1)
  (setq #flg T)
  (setq #dbname "")
  (repeat (strlen #dbname_d)
    (setq #s (substr #dbname_d #i 1))
    (if (/= nil #flg)
      (if (equal "." #s)
        (setq #flg nil)
        (setq #dbname (strcat #dbname #s))
      )
    )
    (setq #i (1+ #i))
  )

  #dbname
)

;<HOM>*************************************************************************
; <関数名>    : SBGetDBList
; <処理概要>  : 仕様表作成のためのリスト取得
; <戻り値>    : 仕様表リスト
; <作成>      : 1998-11-10
; <備考>      : なし
;*************************************************************************>MOH<
(defun SBGetDBList (
  &dbname  ; (STR)  データベース名
  /
  #session #sql$ #tname #title #dlen #and #i #key #val #str #str$ #str_n #sqlstr #sql2$
  #value$ #title$$ #value$$
	#msg
  )
  (setq #session (DBConnect &dbname "" ""))
  (setq #sql$ (DBSqlAutoQuery #session "select * from 名称定義 order by 記述順"))
  (mapcar
   '(lambda ( #list$ )
      (setq #str$ nil)
      (setq #value$ nil)
      (setq #tname (CBCutSpc (nth 1 #list$)))  ; テーブル名
      (setq #title (CBCutSpc (nth 2 #list$)))  ; 表示名
      (setq #dlen  (fix      (nth 3 #list$)))  ; 検索数

      ; 検索文字列取得
      (setq #and "")
      (setq #i 4)
      (repeat #dlen
        (setq #key (CBCutSpc (nth #i #list$)))
        (if (= nil #key) (setq #key ""))
        (setq #val (SBGetKeyByAbbreviation #key))
        (if (= nil #val) (setq #val ""))
        (setq #str (strcat #and #key "=" "\'" #val "\'"))
        (setq #str$ (cons #str #str$))
        (setq #and " and ")
        (setq #i (1+ #i))
      )
      (setq #str_n (apply 'strcat (reverse #str$)))
      ; SQL分に編集
      (setq #sqlstr (strcat "select * from " #tname " where " #str_n))
      ; 仕様表表示リスト取得
;;;      (setq #sql2$ (car (DBSqlAutoQuery #session #sqlstr))) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
      (setq #sql2$ (DBSqlAutoQuery #session #sqlstr)) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD

      (if (/= nil #sql2$)
        (progn
					(CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
					(CFOutStateLog 1 1 #sql2$)

					(if (= (length #sql2$) 1) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
						(progn
					  	(setq #sql2$ (car #sql2$))
						)
				    (progn ; 複数ﾋｯﾄしたときはｴﾗｰ
							(setq #msg (strcat #sqlstr "にレコードが複数ありました.\nSBGetDBList"))
				      (CFOutStateLog 0 1 #msg)
							(CFAlertMsg #msg)
				      (*error*)
				    )
					);_if                    ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD

          (setq #i (1+ #dlen))
          (repeat (fix (nth #dlen #sql2$))
            (setq #value$ (cons (CBCutSpc (nth #i #sql2$)) #value$))
            (setq #i (1+ #i))
          )

          ; リストに格納
          (setq #title$$ (cons #title  #title$$))
          (setq #value$$ (cons (reverse #value$) #value$$))
        )
      ;else
        (progn
          ; リストに格納
          (setq #title$$ (cons #title  #title$$))
          (setq #value$$ (cons (list "") #value$$))
        )
      )
    )
    #sql$
  )

  (DBDisConnect #session)   ; データベース接続解除
  (list (reverse #title$$) (reverse #value$$))
)

;<HOM>*************************************************************************
; <関数名>    : SBGetKeyByAbbreviation
; <処理概要>  : 略称からCG_FamilyInfo$$の項目を検索し、値を取得する
; <戻り値>    : 値
; <作成>      : 1998-11-10
; <備考>      : なし
;*************************************************************************>MOH<
(defun SBGetKeyByAbbreviation (
  &keyname ; (STR)  略称
  /
  #cfgname #cfg$ #i #sno #val
  )
  (setq #i 0)
  (repeat (length CG_FamilyInfo$$)
    (if (= 'STR (type (last (nth #i CG_FamilyInfo$$))))
      (if (equal (last (nth #i CG_FamilyInfo$$)) &keyname)
        (setq #val (nth 1 (nth #i CG_FamilyInfo$$)))
      )
    )
    (setq #i (1+ #i))
  )
  #val
)

;<HOM>*************************************************************************
;
; <関数名>    : CBCutSpc
;
; <処理概要>  : 文字列の後ろスペースを削除する
;
; <戻り値>    :
;         STR : 削除後の文字列
;
; <作成>      : 97-09-13 中村博伸
;
; <備考>      : なし
;
; <外部変数>  : なし
;
; <ファイル>  : なし
;
;*************************************************************************>MOH<
(defun CBCutSpc (
  &str        ; (STR) 文字列
  /
  #str        ; (STR) 削除後の文字列
  #i          ; (INT) カウンタ
  #wk         ; (STR) ワーク文字
  )

  (setq #i (strlen &str))               ; 文字列ポインタ
  (setq #str &str)                      ; 仮戻値

  (while (> #i 0)
    (setq #wk (substr #str #i 1))
    (cond
      ((= (ascii #wk) 32)               ; 半角スペース
        (setq #str (substr #str 1 (1- #i)))
        (setq #i (1- #i))
      )
      ((= (ascii #wk) 64)               ; 全角スペース
        (if (= (ascii (substr #str (1- #i) 1)) -127)
          (progn
            (setq #str (substr #str 1 (- #i 2)))
            (setq #i (- #i 2))
          )
          (progn
            (setq #i 0)
          )
        )
      )
      (T
        (setq #i 0)
      )
    )
  )

  #str
)
