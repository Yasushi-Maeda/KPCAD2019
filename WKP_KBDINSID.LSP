;<HOM>*************************************************************************
; <関数名>    : SBDrawInsideBefore
; <処理概要>  : 内観図を作成するための環境を整える
; <戻り値>    : なし
; <作成>      : 1998-06-16
; <備考>      : テンプレートファイルで新規図面のとき内観図作成
;               図面に名前がある場合
;                 → 上書き保存し、新規図面にする
;               図面に名前はないが図形が存在するとき
;                 → 現在の図面を放棄し、新規図面にする
;*************************************************************************>MOH<
(defun SBDrawInsideBefore (
  /
  #tempdir #tempfile
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawInsideBefore ////")
	(CFOutStateLog 1 1 " ")

  ; テンプレートファイルの格納ディレクトリ
  (setq #tempdir (strcat CG_SYSPATH "template\\bath\\"))

  ; テンプレートファイル名
  (setq #tempfile (strcat #tempdir "SB_内観" CG_SizeCode ".dwt"))
  (if (findfile #tempfile)
    (progn

      (CFOutStateLog 1 1 "テンプレートファイル名 = ")(CFOutStateLog 1 1 #tempfile)
      (if (/= nil CG_OpenMode)
        (progn

          (CFOutStateLog 1 1 "内観図作図")
          (setq CG_OpenMode nil)
          (SBDrawInside)
        )
        (if (equal "DRAWING.DWG" (strcase (getvar "DWGNAME")))
          (progn
            (command "_point" "0,0")

            (CFOutStateLog 1 1 "新規図面にする")
            (setq CG_OpenMode 3)
            (if (= 0 (getvar "DBMOD"))
              ;00/02/03 HN S-MOD (command "_.new")を変更
              ;@@@(command ".new" #tempfile)
              (CfDwgNewByScript #tempfile)
              ;00/02/03 HN E-MOD (command "_.new")を変更
              (progn
                (CFOutStateLog 1 1 "既存図面放棄")
                ;00/02/03 HN S-MOD (command "_.new")を変更
                ;@@@(command ".new" "Y" #tempfile)
                (CfDwgNewByScript #tempfile)
                ;00/02/03 HN E-MOD (command "_.new")を変更
              )
            )

          )
          (progn

            (CFOutStateLog 1 1 "図面に名前が有る")
            (setq CG_OpenMode 3)
            (CFOutStateLog 1 1 "上書き保存")
            (command ".qsave")
            (CFOutStateLog 1 1 "新規図面にする")
            ;00/02/03 HN S-MOD (command "_.new")を変更
            ;@@@(command ".new" #tempfile)
            (CfDwgNewByScript #tempfile)
            ;00/02/03 HN E-MOD (command "_.new")を変更

          )
        ) ; end if
      ) ; end if
    )
    (progn
      (CFOutStateLog 1 1 "内観図のテンプレートファイルが存在しません.")
      (CFOutStateLog 1 1 "テンプレートファイル名 = ")(CFOutStateLog 1 1 #tempfile)
    )
  ) ; end if

  (princ) ; return
) ; SBDrawInsideBefore

;<HOM>*************************************************************************
; <関数名>    : SBDrawInside
; <処理概要>  : 内観図を作成する
; <戻り値>    : なし
; <作成>      : 1998-06-16
; <修正>      : 1999-02-15 （可変寸法線をMASTER図面全てに有効にする）
; <備考>      : この関数では現在内観図用テンプレートで新規図面を開いた状態
;               であることを前提条件とする.
;*************************************************************************>MOH<
(defun SBDrawInside (
  /
  #cfgname #savedir #tlayer #90 #vlayer #dlayer #dsize #wsize #cfg$ #cfgnai$ #cfgequ$
  #bpt #pdata$ #bpt$ #cmdecho #lay$
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawInside ////")
	(CFOutStateLog 1 1 " ")

  ;--------------- 初期設定-----------------
  (setq #cfgname (strcat CG_SBDATAPATH CG_SeriesFolder "\\CFG\\CLASSIFI.CFG"))  ; CFGファイル名
  (setq #savedir CG_SBOUTPATH)
  (setq #tlayer "0_TITLET")                           ; タイトル画層
  (setq #90 90)                                       ; 一般図面境界NO
  (setq #vlayer "#_vardim")                           ; 可変寸法点画層
  (setq #lay$
    (list
      "0"
      "0_frame" "0_titlef"  "0_titlet" "0_dim"  "0_dimtxt" "0_text" "0_draw" "0_sugata" "0_syousai"
      "1_base"  "1_bathtub" "1_tile"   "1_door" "1_parts"  "1_plug"
      "2_base"  "2_bathtub" "2_tile"   "2_door" "2_parts"  "2_plug"
      "3_base"  "3_bathtub" "3_tile"   "3_door" "3_parts"  "3_plug"
      "4_base"  "4_bathtub" "4_tile"   "4_door" "4_parts"  "4_plug"
    )
  )
  ;-----------------------------------------

  ;CFGファイルがあるか
  (if (findfile #cfgname)
    (progn

      (CFOutStateLog 1 1 "W,Dサイズ取得")
      (setq #dsize (* 100 (atof (substr CG_SizeCode 1 2))))
      (setq #wsize (* 100 (atof (substr CG_SizeCode 3 2))))

      (CFOutStateLog 1 1 "UB壁内側領域点を作図する")
      (setq #bpt$
        (SBDrawBasePoint
          CG_WOffset CG_DOffset #wsize #dsize CG_WPanelThk CG_DPanelThk CG_CeilHeight #90
          CG_BaseOffset
        )
      )
      (CFOutStateLog 1 1 "CFGファイルリスト編集")
      (setq #cfg$ (SBModCfgFile #cfgname #90))
      (setq #cfgnai$ (car  #cfg$))
      (setq #cfgequ$ (cadr #cfg$))

      (CFOutStateLog 1 1 "内観図作図")
      (setq #bpt$
        (SBDrawInsideParts
          #cfgnai$ #bpt$ #90 CG_WOffset CG_DOffset #wsize #dsize CG_WPanelThk
          CG_DPanelThk CG_CeilHeight CG_BaseOffset
        )
      )

      (CFOutStateLog 1 1 "寸法線作図")
      (command "_.-LAYER" "T" "*" "ON" "*" "U" "*" "")
      (setq #bpt (nth 2 (nth 0 #bpt$)))
      (setq #pdata$ (SBGetPEntity #vlayer #bpt))
      (SBDrawDImension #bpt #pdata$ CG_WOffset CG_DOffset CG_WPanelThk CG_DPanelThk CG_BaseOffset)

      (CFOutStateLog 1 1 "ドア詳細図、沓摺詳細図作図")
      (setq #bpt$ (SBGetGeneralBasePt #90))
      (SBDrawGeneralPlan #bpt$ #cfgequ$ (strcat CG_SBDATAPATH CG_SeriesFolder "\\"))

      (CFOutStateLog 1 1 "隠線領域")
      (SBModPmenByRegion)

      (CFOutStateLog 1 1 "タイトル作成")
      (SBMakeTitleText
        #tlayer CG_PackName CG_BukkenName CG_SeriesName CG_KoujiKind
        CG_BukkenNo CG_Zno CG_ModelName
      )

      (CFOutStateLog 1 1 "パージ")
      (command "_.-LAYER" "T" "*" "ON" "*" "U" "*" "")
      (setq #cmdecho (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_.PURGE" "A" "*" "Y")
      (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
        (command "Y")
      )
      (command "_.PURGE" "A" "*" "Y")
      (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
        (command "Y")
      )
      (command "_.PURGE" "A" "*" "Y")
      (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
        (command "Y")
      )
      (setvar "CMDECHO" #cmdecho)
      (command  "_.ZOOM"  "A")

      (CFOutStateLog 1 1 "画層表示編集")
      (command "_.-LAYER" "OF" "*" "")
      (command "_.-LAYER")
      (foreach #lay #lay$
        (if (tblsearch "layer" #lay)
          (command "ON" #lay)
        )
      )
      (command "")
      (setvar "CLAYER" "0")

      (CFOutStateLog 1 1 "図面保存")
      (SBSaveas #savedir CG_BukkenNo CG_Zno)
    )
    (progn
      (CFOutStateLog 0 1 "CFGファイルが存在しません")
    )
  ) ; end if

  (setvar "filedia" 1)

  (princ) ; return
) ; SBDrawInside


;<HOM>*************************************************************************
; <関数名>    : SBDrawBasePoint
; <処理概要>  : UB壁内側領域点を作図する
; <戻り値>    : 基準座標リスト
;               (
;                 基準座標リスト   ; 平面図
;                 基準座標リスト   ; 正面図
;                 基準座標リスト   ; 側面図
;                 基準座標リスト   ; 天井伏図
;               )
; <作成>      : 1998-10-15
; <修正>      : 1999-03-01
;*************************************************************************>MOH<
(defun SBDrawBasePoint (
  &offw    ; (REAL)     ユニットオフセット量W
  &offd    ; (REAL)     ユニットオフセット量D
  &sizew   ; (REAL)     Wサイズ
  &sized   ; (REAL)     Dサイズ
  &thickw  ; (REAL)     パネル厚みW
  &thickd  ; (REAL)     パネル厚みD
  &ceil    ; (REAL)     天井高さ
  &90      ; (INT)      区切る数値
  &baseoff ; (REAL)     基準オフセット量
  /
  ##DrawEnXData #player #flayer #slayer #clayer #offw #offd #cclayer #ss #i #en #eg
  #eed$ #8 #pbpt #fbpt #sbpt #cbpt #pbpt$ #fbpt$ #sbpt$ #cbpt$ #dbpt$ #pt$ #pt #equ$ #no
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawBasePoint ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "ユニットオフセット量W           : ")(CFOutStateLog 1 1 &offw   )
  (CFOutStateLog 1 1 "ユニットオフセット量D           : ")(CFOutStateLog 1 1 &offd   )
  (CFOutStateLog 1 1 "Wサイズ                         : ")(CFOutStateLog 1 1 &sizew  )
  (CFOutStateLog 1 1 "Dサイズ                         : ")(CFOutStateLog 1 1 &sized  )
  (CFOutStateLog 1 1 "パネル厚みW                     : ")(CFOutStateLog 1 1 &thickw )
  (CFOutStateLog 1 1 "パネル厚みD                     : ")(CFOutStateLog 1 1 &thickd )
  (CFOutStateLog 1 1 "天井高さ                        : ")(CFOutStateLog 1 1 &ceil   )
  (CFOutStateLog 1 1 "区切る数値                      : ")(CFOutStateLog 1 1 &90     )
  (CFOutStateLog 1 1 "基準オフセット量                : ")(CFOutStateLog 1 1 &baseoff)
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  ;拡張データを点図形に付加する
  (defun ##DrawEnXData (
    &ptno$    ; (LIST) 点図形の座標と格納するNOリスト
    /
    #pt #en #no #eg #eed$
    )
    (setq #pt (car  &ptno$))
    (command "_.POINT" "non" #pt)
    (setq #en (entlast))
    (setq #no (cadr &ptno$))
    (setq #eg   (entget #en))
    (setq #eed$ (list -3 (list "G_WKPT" (cons 1070 #no))))
    (entmod (append #eg (list #eed$)))

    (princ)
  )
  ;--------------- 初期設定-----------------
  ;画層設定
  (setq #player "Z1_POINT")   ; 平面図
  (setq #flayer "Z2_POINT")   ; 正面図
  (setq #slayer "Z3_POINT")   ; 側面図
  (setq #clayer "Z4_POINT")   ; 天井伏図
  ;Wオフセット
  ;---------修正 森本--------------
  ;オフセット量をサイズ1620のみ足す
  (if (equal CG_SIZECODE "1620")
    (setq #offw (+ &baseoff &offw &thickw))
    (setq #offw (+ &baseoff &thickw))
  )
  (setq #offd (+ &offd &thickd))
  ;------------------------------
  ;現在画層
  (setq #cclayer (getvar "CLAYER"))
  ;-----------------------------------------
  ;領域点図形セット
  (setq #ss (ssget "X" '((-3 ("G_WKPT")))))
  (if (/= nil #ss)
    (progn

      (setq #i 0)
      (repeat (sslength #ss)

        (setq #en (ssname #ss #i))
        (setq #eg (entget #en '("*")))
        (setq #eed$ (cdr (assoc -3 #eg)))
        (if (/= nil #eed$)
          (progn

            ;画層
            (setq #8  (cdr (assoc 8 #eg)))
            ;NO
            (setq #no (cdr (cadr (assoc "G_WKPT" #eed$))))
            ;座標取得
            (if (< #no &90)
              (cond
                ((= #player #8)                      ; 平面図
                  (if (= 3 #no)
                    (setq #pbpt (cdr (assoc 10 #eg)))
                  )
                  (setq #pbpt$ (cons (list #no (cdr (assoc 10 #eg))) #pbpt$))
                )
                ((= #flayer #8)                      ; 正面図
                  (if (= 1 #no)
                    (setq #fbpt (cdr (assoc 10 #eg)))
                  )
                  (setq #fbpt$ (cons (list #no (cdr (assoc 10 #eg))) #fbpt$))
                )
                ((= #slayer #8)                      ; 側面図
                  (if (= 2 #no)
                    (setq #sbpt (cdr (assoc 10 #eg)))
                  )
                  (setq #sbpt$ (cons (list #no (cdr (assoc 10 #eg))) #sbpt$))
                )
                ((= #clayer #8)                      ; 天井伏図
                  (if (= 3 #no)
                    (setq #cbpt (cdr (assoc 10 #eg)))
                  )
                  (setq #cbpt$ (cons (list #no (cdr (assoc 10 #eg))) #cbpt$))
                )
              ) ; end cond
            )

          )
        ) ; end if
        (setq #i (1+ #i))

      ) ; end repeat

    )
  ) ; end if

  ;座標とNO GET
  (setq #pbpt$                   ; 平面図
    (list
      (cadr (assoc 4 #pbpt$))
      (cadr (assoc 3 #pbpt$))
      (cadr (assoc 2 #pbpt$))
      (cadr (assoc 1 #pbpt$))
    )
  )
  (setq #fbpt$                   ; 正面図
    (list
      (cadr (assoc 2 #fbpt$))
      (cadr (assoc 1 #fbpt$))
    )
  )
  (setq #sbpt$                   ; 側面図
    (list
      (cadr (assoc 2 #sbpt$))
      (cadr (assoc 1 #sbpt$))
    )
  )
  (setq #cbpt$                   ; 天井伏図
    (list
      (cadr (assoc 4 #cbpt$))
      (cadr (assoc 3 #cbpt$))
      (cadr (assoc 2 #cbpt$))
      (cadr (assoc 1 #cbpt$))
    )
  )

  (CFOutStateLog 1 1 "平面図")
  (setq #pt$ nil)
  ;現在画層
  (setvar "CLAYER" #player)
  ;⑤
  (setq #pt (list (+ (car #pbpt) #offw       ) (- (cadr #pbpt) #offd &sized)))
  (setq #pt$ (cons (list #pt 5) #pt$))
  (setq #pbpt$ (cons #pt #pbpt$))
  ;⑥
  (setq #pt (list (+ (car #pbpt) #offw &sizew) (- (cadr #pbpt) #offd &sized)))
  (setq #pt$ (cons (list #pt 6) #pt$))
  (setq #pbpt$ (cons #pt #pbpt$))
  ;⑦
  (setq #pt (list (+ (car #pbpt) #offw       ) (- (cadr #pbpt) #offd       )))
  (setq #pt$ (cons (list #pt 7) #pt$))
  (setq #pbpt$ (cons #pt #pbpt$))
  ;⑧
  (setq #pt (list (+ (car #pbpt) #offw &sizew) (- (cadr #pbpt) #offd       )))
  (setq #pt$ (cons (list #pt 8) #pt$))
  (setq #pbpt$ (cons #pt #pbpt$))

  ;作図
  (mapcar '##DrawEnXData #pt$)

  (CFOutStateLog 1 1 "正面図")
  (setq #pt$ nil)
  ;現在画層
  (setvar "CLAYER" #flayer)
  ;③
  (setq #pt (list (+ (car #fbpt) #offw       )    (cadr #fbpt)              ))
  (setq #pt$ (cons (list #pt 3) #pt$))
  (setq #fbpt$ (cons #pt #fbpt$))
  ;④
  (setq #pt (list (+ (car #fbpt) #offw &sizew)    (cadr #fbpt)              ))
  (setq #pt$ (cons (list #pt 4) #pt$))
  (setq #fbpt$ (cons #pt #fbpt$))
  ;⑤
  (setq #pt (list (+ (car #fbpt) #offw       ) (+ (cadr #fbpt) &ceil       )))
  (setq #pt$ (cons (list #pt 5) #pt$))
  (setq #fbpt$ (cons #pt #fbpt$))
  ;⑥
  (setq #pt (list (+ (car #fbpt) #offw &sizew) (+ (cadr #fbpt) &ceil       )))
  (setq #pt$ (cons (list #pt 6) #pt$))
  (setq #fbpt$ (cons #pt #fbpt$))

  ;作図
  (mapcar '##DrawEnXData #pt$)

  (CFOutStateLog 1 1 "側面図")
  (setq #pt$ nil)
  ;現在画層
  (setvar "CLAYER" #slayer)
  ;③
  (setq #pt (list (- (car #sbpt) #offd &sized)    (cadr #sbpt)              ))
  (setq #pt$ (cons (list #pt 3) #pt$))
  (setq #sbpt$ (cons #pt #sbpt$))
  ;④
  (setq #pt (list (- (car #sbpt) #offd       )    (cadr #sbpt)              ))
  (setq #pt$ (cons (list #pt 4) #pt$))
  (setq #sbpt$ (cons #pt #sbpt$))
  ;⑤
  (setq #pt (list (- (car #sbpt) #offd &sized) (+ (cadr #sbpt) &ceil       )))
  (setq #pt$ (cons (list #pt 5) #pt$))
  (setq #sbpt$ (cons #pt #sbpt$))
  ;⑥
  (setq #pt (list (- (car #sbpt) #offd       ) (+ (cadr #sbpt) &ceil       )))
  (setq #pt$ (cons (list #pt 6) #pt$))
  (setq #sbpt$ (cons #pt #sbpt$))

  ;作図
  (mapcar '##DrawEnXData #pt$)

  (CFOutStateLog 1 1 "天井伏図")
  (setq #pt$ nil)
  ;現在画層
  (setvar "CLAYER" #clayer)
  ;⑤
  (setq #pt (list (+ (car #cbpt) #offw       ) (- (cadr #cbpt) #offd &sized)))
  (setq #pt$ (cons (list #pt 5) #pt$))
  (setq #cbpt$ (cons #pt #cbpt$))
  ;⑥
  (setq #pt (list (+ (car #cbpt) #offw &sizew) (- (cadr #cbpt) #offd &sized)))
  (setq #pt$ (cons (list #pt 6) #pt$))
  (setq #cbpt$ (cons #pt #cbpt$))
  ;⑦
  (setq #pt (list (+ (car #cbpt) #offw       ) (- (cadr #cbpt) #offd       )))
  (setq #pt$ (cons (list #pt 7) #pt$))
  (setq #cbpt$ (cons #pt #cbpt$))
  ;⑧
  (setq #pt (list (+ (car #cbpt) #offw &sizew) (- (cadr #cbpt) #offd       )))
  (setq #pt$ (cons (list #pt 8) #pt$))
  (setq #cbpt$ (cons #pt #cbpt$))

  ;作図
  (mapcar '##DrawEnXData #pt$)

  ;現在画層
  (setvar "CLAYER" #cclayer)

  (list
    (reverse #pbpt$)
    (reverse #fbpt$)
    (reverse #sbpt$)
    (reverse #cbpt$)
  ) ; return
) ; SBDrawBasePoint

;<HOM>*************************************************************************
; <関数名>    : SBDrawInsideParts
; <処理概要>  : 内観図形をパーツ毎に作図する
; <戻り値>    : なし
; <作成>      : 1998-10-15
;*************************************************************************>MOH<
(defun SBDrawInsideParts (
  &cfg$    ; (LIST)     CFGファイル名リスト
  &bpt$    ; (LIST)     基準点リスト
  &90      ; (INT)      区切る数値
  &offw    ; (REAL)     ユニットオフセット量W
  &offd    ; (REAL)     ユニットオフセット量D
  &sizew   ; (REAL)     Wサイズ
  &sized   ; (REAL)     Dサイズ
  &thickw  ; (REAL)     パネル厚みW
  &thickd  ; (REAL)     パネル厚みD
  &ceil    ; (REAL)     天井高さ
  &baseoff ; (REAL)     基準オフセット量
  /
  #data #fname$ #z #fname #han #nhan$$ #bpt$ #fn$
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawInsideParts ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "CFGファイル名リスト             : ")(CFOutStateLog 1 1 &cfg$   )
  (CFOutStateLog 1 1 "基準点リスト                    : ")(CFOutStateLog 1 1 &bpt$   )
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  ; 反転可図面作図
  (mapcar
   '(lambda ( #data )
      ; ファイル名、表示順序、反転記号取得
      (setq #fname$ (SBGetFnameZ #data (strcat CG_SBDATAPATH CG_SeriesFolder "\\")))
      (setq #z     (car   #fname$))
      (setq #fname (cadr  #fname$))
      (setq #han   (caddr #fname$))

      (CFOutLog 1 nil (strcat "  +挿入ﾌｧｲﾙ名  :" #fname))
      (CFOutLog 1 nil (strcat "    +表示順序:" #z))

      (if (findfile #fname)
        (if (= "A" #han)
          (SBDrawInsert #z #fname &bpt$)
          (setq #nhan$$ (cons (list #z #fname) #nhan$$))
        )
        (progn
          (CFOutStateLog 0 1 "ファイルが存在しません")(CFOutStateLog 0 1 #fname)
        )
      )
    )
    &cfg$
  )
  ; 図形反転
  ;;(if (wcmatch CG_DoorCode "[CDF]"))
  (if (= CG_DoorLR "L")
    (SBMirrorParts &bpt$)
  )
  (setq #bpt$
    (SBGetBasePoint &90 CG_DoorLR &offw &offd &sizew &sized &thickw &thickd &ceil &baseoff)
  )
;  (setq #bpt$ &bpt$)
  ; 反転否図面作図
  (mapcar
   '(lambda ( #fn$ )
      (SBDrawInsert (car #fn$) (cadr #fn$) #bpt$)
    )
    #nhan$$
  )
  ;陰線寸法再作図
  (SBReSetShade)

  #bpt$
) ; SBDrawInsideParts


;<HOM>*************************************************************************
; <関数名>    : SBDrawInsert
; <処理概要>  : パーツをコピーし、作図する
; <戻り値>    : なし
; <作成>      : 1998-10-15
;*************************************************************************>MOH<
(defun SBDrawInsert (
  &z       ; (REAL)     表示順序（Z座標）
  &fname   ; (STR)      パーツファイル名
  &bpt$    ; (LIST)     基準座標リスト
  /
  #inen #en$ #Han$ #enno #pt$ #no #ss #bpt #lpt #mken #eg #5 #Ex$ #lastent #osmode
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawInsert ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "表示順序（Z座標）               : ")(CFOutStateLog 1 1 &z     )
  (CFOutStateLog 1 1 "パーツファイル名                : ")(CFOutStateLog 1 1 &fname )
  (CFOutStateLog 1 1 "基準点リスト                    : ")
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  (CFOutStateLog 1 1 "図形挿入")
  (command "_.INSERT" &fname "0,0" "1" "1" "0")
  (setq #inen (entlast))

  (setq #en$ (SBGetEntityByFname #inen))
  (setq #Han$ nil)

  ; 各図面毎にコピー、移動する
  (mapcar
   '(lambda ( #enno #pt$ )

      (setq #no  (cadr #enno))
      ;図形コピー
      (setq #ss (ssadd))
      (if (/= nil #no)
        (progn
          (setq #bpt (car  #enno))
          (setq #lpt (nth (1- #no) #pt$))
          (setq #lpt (list (car #lpt) (cadr #lpt) (atof &z)))
          (mapcar
           '(lambda ( #mken )
              (setq #eg  (entget #mken '("*")))
              (setq #5   (cdr (assoc 5 #eg)))
              (setq #Ex$ (assoc "G_HDIM" (cdr (assoc -3 #eg))))
              (if (/= nil #Ex$)
                (setq #Han$ (cons (cdr (nth 1 #Ex$)) #Han$))
              )
              (if (= nil (member #5 #Han$))
                (progn
                  (entmake (cdr #eg))
                  (ssadd (entlast) #ss)
                )
              )
            )
            (nth 2 #enno)
          )
        )
      )
      (if (/= 0 (sslength #ss))
        (progn
          ;98/11/24 Modify S.Kawamoto Start
          (if (and #lastent (/= nil (ssmemb #lastent #ss)))
            (ssdel #lastent #ss)
          )
          ;98/11/24 Modify S.Kawamoto End
          ;図形移動
          (setq #osmode (getvar "OSMODE"))
          (setvar "OSMODE" 0)
          (command "_.MOVE" #ss "" #bpt #lpt)
          (setvar "OSMODE" #osmode)
        )
      )
      (setq #lastent (entlast))
      (setq #ss nil)
    )
    #en$ &bpt$
  )
  (entdel #inen)

  (princ) ; repeat
)

;<HOM>*************************************************************************
; <関数名>    : SBGetEntityByFname
; <処理概要>  : 基準座標、NO、図形名リストを各図面毎に格納する
; <戻り値>    : 図形名リスト
;               (
;                 (基準座標 NO 図形名リスト)   ; 平面図
;                 (基準座標 NO 図形名リスト)   ; 正面図
;                 (基準座標 NO 図形名リスト)   ; 側面図
;                 (基準座標 NO 図形名リスト)   ; 天井伏図
;               )
; <作成>      : 1998-10-15
;*************************************************************************>MOH<
(defun SBGetEntityByFname (
  &inen    ; (ENAME)    パーツ図形名
  /
  #en$ #en #eg #8 #eed$ #ppt #pno #pen$ #fpt #fno #fen$ #spt #sno #sen$
  #cpt #cno #cen$
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBGetEntityByFname ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "パーツ図形名                    : ")(CFOutStateLog 1 1 &inen   )
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  (CFOutStateLog 1 1 "図形の構成図面名リスト取得")
  (setq #en$ (SBGetDataByBlock &inen))

  ;(基準座標 NO 図形名リスト)
  (mapcar
   '(lambda ( #en )

      (setq #eg   (entget #en '("*")))
      (setq #8    (cdr (assoc 8 #eg)))
      (setq #eed$ (cdr (assoc -3 #eg)))
      (cond

        ((wcmatch #8 "1_*")            ; 平面図
          (if (assoc "G_SBPT" #eed$)
            (progn
              (setq #ppt (cdr (assoc 10 #eg)))
              (setq #pno (cdr (nth 3 (assoc "G_SBPT" #eed$))))
            )
          )
          (setq #pen$ (cons #en #pen$))
        )

        ((wcmatch #8 "2_*")            ; 正面図
          (if (assoc "G_SBPT" #eed$)
            (progn
              (setq #fpt (cdr (assoc 10 #eg)))
              (setq #fno (cdr (nth 3 (assoc "G_SBPT" #eed$))))
            )
          )
          (setq #fen$ (cons #en #fen$))
        )

        ((wcmatch #8 "3_*")            ; 側面図
          (if (assoc "G_SBPT" #eed$)
            (progn
              (setq #spt (cdr (assoc 10 #eg)))
              (setq #sno (cdr (nth 3 (assoc "G_SBPT" #eed$))))
            )
          )
          (setq #sen$ (cons #en #sen$))
        )

        ((wcmatch #8 "4_*")            ; 天井伏図
          (if (assoc "G_SBPT" #eed$)
            (progn
              (setq #cpt (cdr (assoc 10 #eg)))
              (setq #cno (cdr (nth 3 (assoc "G_SBPT" #eed$))))
            )
          )
          (setq #cen$ (cons #en #cen$))
        )

      ) ; end cond

    )
    #en$
  ) ; end mapcar

  (list
    (list #ppt #pno #pen$)
    (list #fpt #fno #fen$)
    (list #spt #sno #sen$)
    (list #cpt #cno #cen$)
  ) ; return
)

;<HOM>*************************************************************************
; <関数名>    : SBMirrorParts
; <処理概要>  : パーツを図面毎に反転する
; <戻り値>    : なし
; <作成>      : 1998-10-19
;*************************************************************************>MOH<
(defun SBMirrorParts (
  &bpt$    ; (LIST)     基準点リスト
  /
  #ss #ptx1 #ptx2 #ptx #mpt1 #mpt2
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBMirrorParts ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "基準点リスト                    : ")(CFOutStateLog 1 1 &bpt$   )
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  ; 平面図反転
  (setq #ss (ssget "X" (list (cons 8 "1_*"))))
  (if (/= nil #ss)
    (progn
      (setq #ptx1 (car (nth 0 (nth 0 &bpt$))))
      (setq #ptx2 (car (nth 1 (nth 0 &bpt$))))
      (setq #ptx  (+ (* (- #ptx2 #ptx1) 0.5) #ptx1))
      (setq #mpt1 (list #ptx 0.0 0.0))
      (setq #mpt2 (list #ptx 1.0 0.0))
      (command "_.MIRROR" #ss "" "_non" #mpt1 "_non" #mpt2 "Y")
    )
  )
  (setq #ss nil)

  ; 正面図反転
  (setq #ss (ssget "X" (list (cons 8 "2_*"))))
  (if (/= nil #ss)
    (progn
      (setq #ptx1 (car (nth 0 (nth 1 &bpt$))))
      (setq #ptx2 (car (nth 1 (nth 1 &bpt$))))
      (setq #ptx  (+ (* (- #ptx2 #ptx1) 0.5) #ptx1))
      (setq #mpt1 (list #ptx 0.0 0.0))
      (setq #mpt2 (list #ptx 1.0 0.0))
      (command "_.MIRROR" #ss "" "_non" #mpt1 "_non" #mpt2 "Y")
    )
  )
  (setq #ss nil)

  ; 側面図反転
  (setq #ss (ssget "X" (list (cons 8 "3_*"))))
  (if (/= nil #ss)
    (progn
      (setq #ptx1 (car (nth 0 (nth 2 &bpt$))))
      (setq #ptx2 (car (nth 1 (nth 2 &bpt$))))
      (setq #ptx  (+ (* (- #ptx2 #ptx1) 0.5) #ptx1))
      (setq #mpt1 (list #ptx 0.0 0.0))
      (setq #mpt2 (list #ptx 1.0 0.0))
      (command "_.MIRROR" #ss "" "_non" #mpt1 "_non" #mpt2 "Y")
    )
  )
  (setq #ss nil)

  ; 天井伏図反転
  (setq #ss (ssget "X" (list (cons 8 "4_*"))))
  (if (/= nil #ss)
    (progn
      (setq #ptx1 (car (nth 0 (nth 3 &bpt$))))
      (setq #ptx2 (car (nth 1 (nth 3 &bpt$))))
      (setq #ptx  (+ (* (- #ptx2 #ptx1) 0.5) #ptx1))
      (setq #mpt1 (list #ptx 0.0 0.0))
      (setq #mpt2 (list #ptx 1.0 0.0))
      (command "_.MIRROR" #ss "" "_non" #mpt1 "_non" #mpt2 "Y")
    )
  )
  (setq #ss nil)

  (princ) ; return
) ; SBMirrorParts


;<HOM>*************************************************************************
; <関数名>    : SBReSetShade
; <処理概要>  : 陰線寸法を反転処理された図形のみに書き直しを行う
; <戻り値>    : なし
; <作成>      : 1999-07-01
;*************************************************************************>MOH<
(defun SBReSetShade (
  /
  #ss
  )
  ; 平面図
  (setq #ss (ssget "X" (list (cons 0 "DIMENSION") (cons 8 "1_*") (list -3 (list "G_HDIM")))))
  (if (/= nil #ss)
    (SBReSetShadeDimension #ss "1_hide")
  )
  ; 正面図
  (setq #ss (ssget "X" (list (cons 0 "DIMENSION") (cons 8 "2_*") (list -3 (list "G_HDIM")))))
  (if (/= nil #ss)
    (SBReSetShadeDimension #ss "2_hide")
  )
  ; 側面図
  (setq #ss (ssget "X" (list (cons 0 "DIMENSION") (cons 8 "3_*") (list -3 (list "G_HDIM")))))
  (if (/= nil #ss)
    (SBReSetShadeDimension #ss "3_hide")
  )
  ; 天井伏図
  (setq #ss (ssget "X" (list (cons 0 "DIMENSION") (cons 8 "4_*") (list -3 (list "G_HDIM")))))
  (if (/= nil #ss)
    (SBReSetShadeDimension #ss "4_hide")
  )
)

;<HOM>*************************************************************************
; <関数名>    : SBReSetShadeDimension
; <処理概要>  : 陰線寸法を反転処理された図形のみに書き直しを行う
; <戻り値>    : なし
; <作成>      : 1999-06-30
;*************************************************************************>MOH<

(defun SBReSetShadeDimension (
  &xSp        ; 反転処理を行った図形の選択セット
  &sLay       ; 画層名
  /
  #iI #eEn #Ex$ #New$ #ed #pt$ #bpt #pt1 #pt3 #pt2
  #pt4 #ang #3den #5 #eed
  )
  (setq #iI 0)
  (repeat (sslength &xSp)
    (setq #eEn (ssname &xSp #iI))
    (setq #Ex$ (assoc -3 (entget #eEn '("G_HDIM"))))
    (if (/= nil #Ex$)
      (progn
        ;寸法線再作成
        (setq #New$ nil)
        (mapcar
         '(lambda ( #ed )
            (if (/= 2 (car #ed))
              (setq #New$ (cons #ed #New$))
            )
          )
          (entget #eEn '("*"))
        )
        (entmod (reverse #New$))
        ;寸法線の文字列の領域を取得
        (setq #pt$ (GetDimTextPt #eEn))
        (if (/= nil #pt$)
          (progn
            (setq #bpt (nth 0 #pt$))
            (setq #pt1 (list (car (nth 1 #pt$)) (cadr (nth 1 #pt$)) (nth 4 #pt$)))
            (setq #pt3 (list (car (nth 2 #pt$)) (cadr (nth 2 #pt$)) (nth 4 #pt$)))
            (setq #pt2 (list (car #pt3) (cadr #pt1) (nth 4 #pt$)))
            (setq #pt4 (list (car #pt1) (cadr #pt3) (nth 4 #pt$)))
            (setq #ang (angtos (nth 3 #pt$)))
            ; 全ての座標をWCS->UCSに変換
            (setq #bpt (trans #bpt 0 1)
                  #pt1 (trans #pt1 0 1)
                  #pt2 (trans #pt2 0 1)
                  #pt3 (trans #pt3 0 1)
                  #pt4 (trans #pt4 0 1)
            )
            ;3D面作図
            (command "_3dface" "non" #pt1 "non" #pt2 "non" #pt3 "non" #pt4 "")
            (setq #3den (entlast))
            ;3D面回転
            (command "_rotate"  #3den ""  "non" #bpt #ang)
            (entmod (subst (cons 8 &sLay) (assoc 8 (entget #3den)) (entget #3den)))
            (setq #5   (cdr (assoc 5 (entget #3den))))
            ;拡張データ変更
            (setq #eed (list "G_HDIM" (cons 1005 #5)))
            (entmod (append (entget #eEn) (list (list -3 #eed))))
          )
        )
      )
    )
    (setq #iI (1+ #iI))
  )

  (princ)
) ; SBReSetShadeDimension
;<HOM>*************************************************************************
; <関数名>    : GetDimTextPt
; <処理概要>  : 寸法線の文字列の領域を取得する
; <戻り値>    : 領域リスト（中心座標 左下座標 右上座標 回転角度 Z座標）
; <作成>      : 1998-09-09
;*************************************************************************>MOH<
(defun GetDimTextPt (
  &en   ; (ENAME)  寸法図形名
  /
  #deg #10 #42 #43 #50 #71 #dZ #min #max #pt
  )
  (setq #deg (GetDataByDimBlockMtext &en))
  (setq #10  (nth 0 #deg))        ;挿入基点
  (setq #42  (nth 1 #deg))        ;幅
  (setq #43  (nth 2 #deg))        ;高さ
  (setq #50  (nth 3 #deg))        ;回転角度
  (setq #71  (nth 4 #deg))        ;アタッチされる点
  (setq #dZ  (caddr (cdr (assoc 10 (entget &en)))));Z座標
  ;マルチテキストの左下点、右上点を71番のフラグを元に算出する
  (cond
    ((= 1 #71)
      (setq #min (list    (car #10)              (- (cadr #10)        #43 )))
      (setq #max (list (+ (car #10)        #42 )    (cadr #10)             ))
    )
    ((= 2 #71)
      (setq #min (list (- (car #10) (* 0.5 #42)) (- (cadr #10)        #43 )))
      (setq #max (list (+ (car #10) (* 0.5 #42))    (cadr #10)             ))
    )
    ((= 3 #71)
      (setq #min (list (- (car #10)        #42 ) (- (cadr #10) (* 0.5 #43))))
      (setq #max (list    (car #10)                 (cadr #10)             ))
    )
    ((= 4 #71)
      (setq #min (list    (car #10)              (- (cadr #10) (* 0.5 #43))))
      (setq #max (list (+ (car #10)        #42 ) (+ (cadr #10) (* 0.5 #43))))
    )
    ((= 5 #71)
      (setq #min (list (- (car #10) (* 0.5 #42)) (- (cadr #10) (* 0.5 #43))))
      (setq #max (list (+ (car #10) (* 0.5 #42)) (+ (cadr #10) (* 0.5 #43))))
    )
    ((= 6 #71)
      (setq #min (list (- (car #10)        #42 ) (- (cadr #10) (* 0.5 #43))))
      (setq #max (list    (car #10)              (+ (cadr #10) (* 0.5 #43))))
    )
    ((= 7 #71)
      (setq #min (list    (car #10)                 (cadr #10)             ))
      (setq #max (list (+ (car #10)        #42 ) (+ (cadr #10)        #43 )))
    )
    ((= 8 #71)
      (setq #min (list (- (car #10) (* 0.5 #42))    (cadr #10)             ))
      (setq #max (list (+ (car #10) (* 0.5 #42)) (+ (cadr #10)        #43 )))
    )
    ((= 9 #71)
      (setq #min (list (- (car #10)        #42 )    (cadr #10)             ))
      (setq #max (list    (car #10)              (+ (cadr #10)        #43 )))
    )
  )
  (setq #pt (mapcar '* (mapcar '+ #min #max) '(0.5 0.5)))

  (list #pt #min #max #50 #dZ)
)
;<HOM>*************************************************************************
; <関数名>    : GetDataByDimBlockMtext
; <処理概要>  : 寸法線の文字列図形（MTEXT）の必要な値を取得する
; <戻り値>    : 値リスト（挿入基点、幅、高さ、回転角度、アタッチされる点）
; <作成>      : 1998-09-10
;*************************************************************************>MOH<
(defun GetDataByDimBlockMtext (
  &en   ; (ENAME) 寸法図形名
  /
  #eg #2 #deg #en #10 #42 #43 #50 #71
  )
  (setq #eg (entget &en))
  (setq #2  (cdr (assoc 2 #eg)))
  (setq #deg (entget (tblobjname "BLOCK" #2)))
  (setq #en (cdr (assoc -2 #deg)))
  (setq #en (entnext #en))
  (while (/= nil #en)
    (setq #deg (entget #en))
    (if (equal "MTEXT" (cdr (assoc 0 #deg)))
      (progn
        (setq #10  (cdr (assoc 10 #deg)))  ;挿入基点
        (setq #42  (cdr (assoc 42 #deg)))  ;幅
        (setq #43  (cdr (assoc 43 #deg)))  ;高さ
        (setq #50  (cdr (assoc 50 #deg)))  ;回転角度
        (setq #71  (cdr (assoc 71 #deg)))  ;アタッチされる点
      )
    )
    (setq #en (entnext #en))
  )

  (list #10 #42 #43 #50 #71)
)

;<HOM>*************************************************************************
; <関数名>    : SBGetBasePoint
; <処理概要>  : UB壁内側領域点を獲得する
; <戻り値>    : 基準座標リスト
;               (
;                 基準座標リスト   ; 平面図
;                 基準座標リスト   ; 正面図
;                 基準座標リスト   ; 側面図
;                 基準座標リスト   ; 天井伏図
;               )
; <作成>      : 1998-10-15
; <修正>      : 1999-03-01
;*************************************************************************>MOH<
(defun SBGetBasePoint (
  &90      ; (INT)      区切る数値
  &flg     ; (STR)      ドア位置コード（"L"なら左右反転）
  &offw    ; (REAL)     ユニットオフセット量W
  &offd    ; (REAL)     ユニットオフセット量D
  &sizew   ; (REAL)     Wサイズ
  &sized   ; (REAL)     Dサイズ
  &thickw  ; (REAL)     パネル厚みW
  &thickd  ; (REAL)     パネル厚みD
  &ceil    ; (REAL)     天井高さ
  &baseoff ; (REAL)     基準オフセット量
  /
  #player #flayer #slayer #clayer #offw #offd
  #ss #i #en #eg #eed$ #8 #no
  #pbpt$ #fbpt$ #sbpt$ #cbpt$ #pbpt #fbpt #sbpt #cbpt
  )
  ;--------------- 初期設定-----------------
  ;画層設定
  (setq #player "Z1_POINT")   ; 平面図
  (setq #flayer "Z2_POINT")   ; 正面図
  (setq #slayer "Z3_POINT")   ; 側面図
  (setq #clayer "Z4_POINT")   ; 天井伏図
  ;------------------------------
  ;Wオフセット
  ;オフセット量をサイズ1620のみ足す
  (if (equal CG_SIZECODE "1620")
    (setq #offw (+ &baseoff &offw &thickw))
    (setq #offw (+ &baseoff &thickw))
  )
  (setq #offd (+ &offd &thickd))
  ;-----------------------------------------
  ;領域点図形セット
  (setq #ss (ssget "X" '((-3 ("G_WKPT")))))
  (if (/= nil #ss)
    (progn

      (setq #i 0)
      (repeat (sslength #ss)

        (setq #en (ssname #ss #i))
        (setq #eg (entget #en '("*")))
        (setq #eed$ (cdr (assoc -3 #eg)))
        (if (/= nil #eed$)
          (progn

            ;画層
            (setq #8  (cdr (assoc 8 #eg)))
            ;NO
            (setq #no (cdr (cadr (assoc "G_WKPT" #eed$))))
            ;座標取得
            (if (< #no &90)
              (cond
                ((= #player #8)                      ; 平面図
                  (setq #pbpt$ (cons (list #no (cdr (assoc 10 #eg))) #pbpt$))
                )
                ((= #flayer #8)                      ; 正面図
                  (setq #fbpt$ (cons (list #no (cdr (assoc 10 #eg))) #fbpt$))
                )
                ((= #slayer #8)                      ; 側面図
                  (setq #sbpt$ (cons (list #no (cdr (assoc 10 #eg))) #sbpt$))
                )
                ((= #clayer #8)                      ; 天井伏図
                  (setq #cbpt$ (cons (list #no (cdr (assoc 10 #eg))) #cbpt$))
                )
              ) ; end cond
            )

          )
        ) ; end if
        (setq #i (1+ #i))

      ) ; end repeat

    )
  ) ; end if
  (if (/= &flg "L")
    (progn                           ; 普通
      (setq #pbpt$                   ; 平面図
        (list
          (cadr (assoc 1 #pbpt$))
          (cadr (assoc 2 #pbpt$))
          (cadr (assoc 3 #pbpt$))
          (cadr (assoc 4 #pbpt$))
          (cadr (assoc 5 #pbpt$))
          (cadr (assoc 6 #pbpt$))
          (cadr (assoc 7 #pbpt$))
          (cadr (assoc 8 #pbpt$))
        )
      )
      (setq #fbpt$                   ; 正面図
        (list
          (cadr (assoc 1 #fbpt$))
          (cadr (assoc 2 #fbpt$))
          (cadr (assoc 3 #fbpt$))
          (cadr (assoc 4 #fbpt$))
          (cadr (assoc 5 #fbpt$))
          (cadr (assoc 6 #fbpt$))
        )
      )
      (setq #sbpt$                   ; 側面図
        (list
          (cadr (assoc 1 #sbpt$))
          (cadr (assoc 2 #sbpt$))
          (cadr (assoc 3 #sbpt$))
          (cadr (assoc 4 #sbpt$))
          (cadr (assoc 5 #sbpt$))
          (cadr (assoc 6 #sbpt$))
        )
      )
      (setq #cbpt$                   ; 天井伏図
        (list
          (cadr (assoc 1 #cbpt$))
          (cadr (assoc 2 #cbpt$))
          (cadr (assoc 3 #cbpt$))
          (cadr (assoc 4 #cbpt$))
          (cadr (assoc 5 #cbpt$))
          (cadr (assoc 6 #cbpt$))
          (cadr (assoc 7 #cbpt$))
          (cadr (assoc 8 #cbpt$))
        )
      )
    )
    (progn                           ; 反転
      (setq #pbpt (cadr (assoc 4 #pbpt$)))
      (setq #pbpt$                   ; 平面図
        (list
          (cadr (assoc 1 #pbpt$))
          (cadr (assoc 2 #pbpt$))
          (cadr (assoc 3 #pbpt$))
          (cadr (assoc 4 #pbpt$))
          (list (- (car #pbpt) #offw &sizew) (- (cadr #pbpt) #offd &sized))
          (list (- (car #pbpt) #offw       ) (- (cadr #pbpt) #offd &sized))
          (list (- (car #pbpt) #offw &sizew) (- (cadr #pbpt) #offd       ))
          (list (- (car #pbpt) #offw       ) (- (cadr #pbpt) #offd       ))
        )
      )
      (setq #fbpt (cadr (assoc 2 #fbpt$)))
      (setq #fbpt$                   ; 正面図
        (list
          (cadr (assoc 1 #fbpt$))
          (cadr (assoc 2 #fbpt$))
          (list (- (car #fbpt) #offw &sizew)    (cadr #fbpt)              )
          (list (- (car #fbpt) #offw       )    (cadr #fbpt)              )
          (list (- (car #fbpt) #offw &sizew) (+ (cadr #fbpt) &ceil       ))
          (list (- (car #fbpt) #offw       ) (+ (cadr #fbpt) &ceil       ))
        )
      )
      (setq #sbpt (cadr (assoc 1 #sbpt$)))
      (setq #sbpt$                   ; 側面図
        (list
          (cadr (assoc 1 #sbpt$))
          (cadr (assoc 2 #sbpt$))
          (list (+ (car #sbpt) #offd       )    (cadr #sbpt)              )
          (list (+ (car #sbpt) #offd &sized)    (cadr #sbpt)              )
          (list (+ (car #sbpt) #offd       ) (+ (cadr #sbpt) &ceil       ))
          (list (+ (car #sbpt) #offd &sized) (+ (cadr #sbpt) &ceil       ))
        )
      )
      (setq #cbpt (cadr (assoc 4 #cbpt$)))
      (setq #cbpt$                   ; 天井伏図
        (list
          (cadr (assoc 1 #cbpt$))
          (cadr (assoc 2 #cbpt$))
          (cadr (assoc 3 #cbpt$))
          (cadr (assoc 4 #cbpt$))
          (list (- (car #cbpt) #offw &sizew) (- (cadr #cbpt) #offd &sized))
          (list (- (car #cbpt) #offw       ) (- (cadr #cbpt) #offd &sized))
          (list (- (car #cbpt) #offw &sizew) (- (cadr #cbpt) #offd       ))
          (list (- (car #cbpt) #offw       ) (- (cadr #cbpt) #offd       ))
        )
      )
    )
  )

  (list #pbpt$ #fbpt$ #sbpt$ #cbpt$) ; return
)
