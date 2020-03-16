;<HOM>*************************************************************************
; <関数名>    : SBModCfgFile
; <処理概要>  : CFGファイルの内容をリストに格納し、90番で分ける
; <戻り値>    : CFGリスト
;               ---CFGファイル---           ---リスト---
;
;               01,躯体部             (
;               02,浴槽                 (("01" "躯体部")("02" "浴槽")("03" "目地類(壁+床)"))
;               03,目地類(壁+床)   →   (("90" "沓摺詳細図")("91" "ドア姿図"))
;               90,沓摺詳細図         )
;               91,ドア姿図
;
; <作成>      : 1998-10-30
;*************************************************************************>MOH<
(defun SBModCfgFile (
  &cfgname ; (STR)      CFGファイル名
  &90      ; (INT)      区切る数値
  /
  ;@@@#data$ #dt #no #nai$ #equ$ #DT #EQU$ #NAI$ #NO ;00/01/30 HN MOD 重複変数宣言を修正
  #data$ #dt #no #nai$ #equ$
  )
  (CFOutStateLog 1 0 "//// SBModCfgFile ////")
  (CFOutStateLog 1 0 "--------------------引数 START-----------------")
  (CFOutStateLog 1 0 "CFGファイル名                   : ")(CFOutStateLog 1 0 &cfgname)
  (CFOutStateLog 1 0 "区切る数値                      : ")(CFOutStateLog 1 0 &90     )
  (CFOutStateLog 1 0 "--------------------引数 END-------------------")

  ; 図形分類定義データ取得
  (setq #data$ (SBreadCSV &cfgname))

  (mapcar
   '(lambda ( #dt )

      (setq #no (atoi (car #dt)))
      (if (< #no &90)
        (setq #nai$ (cons #dt #nai$))
        (setq #equ$ (cons #dt #equ$))
      ) ; end if

    )
    #data$
  ) ; end mapcar

  (list #nai$ #equ$) ; return
) ; SBModCfgFile

;***********************************************************************
;  SBreadCSV
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
(defun SBreadCSV (
    &fName
    /
    #fp #csv #lst #str #dblQuo #c #i #buf
    )
  (setq #fp  (open &fName "r"))
  (if (/= nil #fp)
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

;<HOM>*************************************************************************
; <関数名>    : SBMakeTitleText
; <処理概要>  : 図面枠のタイトルを作図する
; <戻り値>    : なし
; <作成>      : 1998-06-19
; <備考>      : 画層は "0_TITLET" とする
;               タイトル文字は既に作図されているものとする。
;*************************************************************************>MOH<
(defun SBMakeTitleText (
  &tlayer  ; (STR)      タイトル文字画層
  &fcode   ; (STR)      パッケージ番号
  &bukken  ; (STR)      物件名称
  &series  ; (STR)      SERIES
  &kname   ; (STR)      工事種類
  &bcode   ; (STR)      物件番号
  &zno     ; (STR)      図面通し番号
  &form    ; (STR)      型式
  /
  #title$ #title$$ #sstit #i #en #eg #str #str_n #subst #ken
  )
  (CFOutStateLog 1 40 "//// SKFMakeTitleText ////")
  (CFOutStateLog 1 40 "--------------------引数 START-----------------")
  (CFOutStateLog 1 40 "タイトル文字画層                : ")(CFOutStateLog 1 40 &tlayer )
  (CFOutStateLog 1 40 "パッケージ番号                  : ")(CFOutStateLog 1 40 &fcode  )
  (CFOutStateLog 1 40 "物件名称                        : ")(CFOutStateLog 1 40 &bukken )
  (CFOutStateLog 1 40 "SERIES                        : ")(CFOutStateLog 1 40 &series )
  (CFOutStateLog 1 40 "工事種類                        : ")(CFOutStateLog 1 40 &kname  )
  (CFOutStateLog 1 40 "物件番号                        : ")(CFOutStateLog 1 40 &bcode  )
  (CFOutStateLog 1 40 "図面通し番号                    : ")(CFOutStateLog 1 40 &zno    )
  (CFOutStateLog 1 40 "型式                            : ")(CFOutStateLog 1 40 &form   )
  (CFOutStateLog 1 40 "--------------------引数 END-------------------")
  (CFOutLog 1 nil (strcat ""))
  (CFOutLog 1 nil (strcat "ﾀｲﾄﾙを出力します"))
  (CFOutLog 1 nil (strcat "  +タイトル文字画層: " &tlayer ))
  (CFOutLog 1 nil (strcat "  +パッケージ番号  : " &fcode  ))
  (CFOutLog 1 nil (strcat "  +物件名称        : " &bukken ))
  (CFOutLog 1 nil (strcat "  +SERIES        : " &series ))
  (CFOutLog 1 nil (strcat "  +工事種類        : " &kname  ))
  (CFOutLog 1 nil (strcat "  +物件番号        : " &bcode  ))
  (CFOutLog 1 nil (strcat "  +図面通し番号    : " &zno    ))
  (CFOutLog 1 nil (strcat "  +型式            : " &form   ))
  ;タイトル文字
  (if
    (and
      (not (equal "" &bcode))(= 'STR (type &bcode))
      (not (equal "" &zno))  (= 'STR (type &zno))
    )
    (setq #title$
      (list &bukken &kname &fcode &series (strcat &bcode &zno) &form
            (menucmd "M=$(edtime,$(getvar,date),YYYY.MO.DD)")
      )
    )
    (progn

      (setq #title$
        (list &bukken &kname &fcode &series (strcat &bcode &zno) &form
              (menucmd "M=$(edtime,$(getvar,date),YYYY.MO.DD)")
        )
      )
      (CFOutStateLog 2 40 "図番:無効なデータ = ")
      (CFOutStateLog 2 40 "物件番号     : &bcode  = ")(CFOutStateLog 2 40 &bcode)
      (CFOutStateLog 2 40 "図面通し番号 : &zno  = ")  (CFOutStateLog 2 40 &zno)

    )
  ) ; end if

  (setq #title$$
    (list
      (list "T^物件名称"       (nth 0 #title$))
      (list "T^工事種類"       (nth 1 #title$))
      (list "T^パッケージ番号" (nth 2 #title$))
      (list "T^SERIES"       (nth 3 #title$))
      (list "T^図番"           (nth 4 #title$))
      (list "T^型式"           (nth 5 #title$))
      (list "T^作成日"         (nth 6 #title$))
    )
  )
  ;-----------------------------------------
  ;タイトル文字取得
  (setq #sstit (ssget "X" (list (cons 8 &tlayer))))
  ;文字作成
  (if (/= nil #sstit)
    (progn

      (setq #i 0)
      (repeat (sslength #sstit)

        (setq #en    (ssname #sstit #i))
        (setq #eg    (entget #en))
        (setq #str   (assoc 1 #eg))
        (setq #ken (assoc (cdr #str) #title$$))
        (if (/= nil #ken)
          (progn
            (setq #str_n (cadr #ken))
            (if (and (/= "" #str_n) (/= nil #str_n) (= 'str (type #str_n)))
              (progn

                (setq #subst (subst (cons 1 #str_n) #str #eg))
                (entmod #subst)

              )
              (progn

                (setq #subst (subst (cons 1 "") #str #eg))
                (entmod #subst)
                (CFOutStateLog 2 40 "タイトル:無効なデータ = ")
                (CFOutStateLog 2 40 #str_n)
              )
            ) ; end if

          )
        ) ; end if

        (setq #i (1+ #i))
      ) ; end repeat

    )
  ) ; end if

  (princ) ; return
) ; SKFMakeTitleText

;<HOM>*************************************************************************
; <関数名>    : SBModPmenByRegion
; <処理概要>  : 隠線領域をリージョン化する
; <戻り値>    : なし
; <作成>      : 1998-06-18
;*************************************************************************>MOH<
(defun SBModPmenByRegion (
  /
  ;@@@##ModRegion #ss #i #en #eed$ #EN ;00/01/30 HN MOD 重複変数宣言を修正
  ##ModRegion #ss #i #en #eed$
  )
  (CFOutStateLog 1 40 "//// SBModPmenByRegion ////")

  ;図形押し出し
  ;   +==================================================================+
  ;   |   図形を押し出しすると別図形になるので画層、色、線種がそれぞれ   |
  ;   |   "0","BYLAYER","BYLAYER"に変わってしまう                        |
  ;   |   そのため元の属性に再設定してやらなくてはいけない               |
  ;   +==================================================================+
  (defun ##ModRegion (
    &en   ; (ENAME) リージョン化図形名
    /
    ;@@@#eg #8 #6 #62 #exen #exeg #subst #en
    #eg #8 #6 #62 #exen #exeg #subst ;00/01/30 HN MOD 重複変数宣言を修正
    )
    (CFOutStateLog 1 0 "図形拡張データ = ")
    (setq #eg (entget #en '("*")))
    (CFOutStateLog 1 0 (last #eg))
    (setq #8  (cdr (assoc 8  #eg)))
    (setq #6  (cdr (assoc 6  #eg)))
    (setq #62 (cdr (assoc 62 #eg)))
    (if (= nil #62)
      (setq #62 256)
    ) ; end if
    ;リージョン化
    (command "_.region" &en "")
    (setq #exen (entlast))
    (setq #exeg (entget #exen))

    ;画層変更
    (setq #subst (subst (cons 8 #8)(assoc 8 #exeg)#exeg))

    ;線種変更
    (if (/= nil #6)
      (if (assoc 6 #exeg)
        (setq #subst (subst (cons 6 #6)(assoc 6 #subst)#subst))
        (setq #subst (append #subst (list (cons 6 #6))))
      ) ; end if
    ) ; end if

    ;色変更
    (if (assoc 62 #exeg)
      (setq #subst (subst (cons 62 #62)(assoc 62 #subst)#subst))
      (setq #subst (append #subst (list (cons 62 #62))))
    ) ; end if

    (entmod #subst) ; return

  ) ; end defun

  (setq #ss (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_PMEN")))))
  (if (/= nil #ss)
    (progn

      (setq #i 0)
      (repeat (sslength #ss)

        (setq #en (ssname #ss #i))
        (setq #eed$ (cadr (assoc -3 (entget #en '("G_PMEN")))))

        (if (and (/= nil #eed$) (listp #eed$))
          (if (= 1 (cdr (nth 1 #eed$)))
            (##ModRegion #en)
          )
        )

        (setq #i (1+ #i))

      ) ; end repeat

    )
  ) ; end if

  (princ) ; return
) ; SBModPmenByRegion


;<HOM>*************************************************************************
; <関数名>    : SBSaveas
; <処理概要>  : 物件番号＋通番名で図面を保存する
; <戻り値>    : なし
; <作成>      : 1998-07-14
;*************************************************************************>MOH<
(defun SBSaveas (
  &dir     ; (STR)      保存先のディレクトリ
  &bcode   ; (STR)      物件番号
  &zcode   ; (STR)      通番
  /
  #fname
  )
  (CFOutStateLog 1 40 "//// SBSaveas ////")
  (CFOutStateLog 1 40 "--------------------引数 START-----------------")
  (CFOutStateLog 1 40 "保存先のディレクトリ            : ")(CFOutStateLog 1 40 &dir    )
  (CFOutStateLog 1 40 "物件番号                        : ")(CFOutStateLog 1 40 &bcode  )
  (CFOutStateLog 1 40 "通番                            : ")(CFOutStateLog 1 40 &zcode  )
  (CFOutStateLog 1 40 "--------------------引数 END-------------------")

  (if (= nil (dos_mkdir &dir))
    (if
      (and
        (/= nil &bcode) (not (equal "" &bcode)) (= 'STR (type &bcode))
        (/= nil &zcode) (not (equal "" &zcode)) (= 'STR (type &zcode))
      )
      (progn
        (CFOutStateLog 1 40  (strcat "図面名  : " &bcode CG_Hinmoku CG_INCNO &zcode))
        (if (= CG_OUTPUTTYPE "DWG")
          (progn
            (setq #fname (strcat &dir &bcode CG_Hinmoku CG_INCNO &zcode ".dwg"))
            (if (findfile #fname)
              (CFOutStateLog 2 40 "ﾌｧｲﾙ既存 -> 上書き")
            )
            (command "_saveas" "" #fname) ;00/02/17 HN MOD R14→2000
          )
          (progn
            ;(setq #fname (strcat &dir &bcode CG_Hinmoku CG_INCNO &zcode ".tif"))
            (setq #fname (strcat &dir &bcode CG_Hinmoku CG_INCNO &zcode))
            ;// TIFF ファイルに出力する
            ;(if (findfile #fname)
            ;  (command "_plot" "L" 0 "N" #fname "Y")
              (command "_plot" "L" 0 "N" #fname)
            ;)
          )
        )
      )
      (progn

        (CFOutStateLog 0 40  "図面名:無効なﾃﾞｰﾀ = ")
        (CFOutStateLog 0 40  &bcode)
        (CFOutStateLog 0 40  &zcode)

      )
    ) ; end if
    (progn

      (CFOutStateLog 0 40  "図面保存ディレクトリ:無効なデータ = ")
      (CFOutStateLog 0 40  &dir)
      (dos_rmdir &dir)

    )
  ) ; end if

  (princ) ; return
) ; SBSaveas

;<HOM>*************************************************************************
; <関数名>    : SBGetDataByBlock
; <処理概要>  : ブロックで構成される図形を取得する
; <戻り値>    : 図形名リスト
; <作成>      : 1998-09-10
;*************************************************************************>MOH<
(defun SBGetDataByBlock (
  &en      ; (ENAME)    INSERT図面名
  /
  #eg #2 #deg #en #en$
  )
  (CFOutStateLog 1 41 "//// SBGetDataByBlock ////")
  (CFOutStateLog 1 41 "--------------------引数 START-----------------")
  (CFOutStateLog 1 41 "INSERT図面名                    : ")(CFOutStateLog 1 41 &en     )
  (CFOutStateLog 1 41 "--------------------引数 END-------------------")

  (CFOutStateLog 1 41 "INSETRT図形データ取得")
  (setq #eg (entget &en))

  (CFOutStateLog 1 41 "BLOCK名取得")
  (setq #2  (cdr (assoc 2 #eg)))

  (CFOutStateLog 1 41 "BLOCK図形データ取得")
  (setq #deg (entget (tblobjname "BLOCK" #2)))

  (CFOutStateLog 1 41 "BLOCK構成図形名取得")
  (setq #en (cdr (assoc -2 #deg)))

  (while (/= nil #en)
    (setq #en$ (cons #en #en$))
    (setq #en (entnext #en))
  ) ; end while

  #en$ ; return
) ; SBGetDataByBlock
;<HOM>*************************************************************************
; <関数名>    : SBDrawGeneralPlan
; <処理概要>  : 一般図面（ドア姿図、沓摺詳細図、給排水設備図）作図
; <戻り値>    : なし
; <作成>      : 1998-11-06
;*************************************************************************>MOH<
(defun SBDrawGeneralPlan (
  &bpt$    ; (LIST)     基準点座標リスト
  &cfgequ$ ; (LIST)     CFGファイルリスト
  &srzdir  ; (STR)      SERIESディレクトリ
  /
  #data #lpt$ #fname$ #z #fname #lpt #ss #bpt #i #en #eg #eed$ #bpt #osmode
  )
  (CFOutStateLog 1 0 "//// SBDrawGeneralPlan ////")
  (CFOutStateLog 1 0 "--------------------引数 START-----------------")
  (CFOutStateLog 1 0 "基準点座標リスト                : ")(CFOutStateLog 1 0 &bpt$   )
  (CFOutStateLog 1 0 "CFGファイルリスト               : ")(CFOutStateLog 1 0 &cfgequ$)
  (CFOutStateLog 1 0 "SERIESディレクトリ            : ")(CFOutStateLog 1 0 &srzdir )
  (CFOutStateLog 1 0 "--------------------引数 END-------------------")

  (mapcar
   '(lambda ( #data )
      (setq #lpt$ nil)
      ; 基準座標リスト取得
      (setq #lpt$ (assoc (atoi (car #data)) &bpt$))
      (if (/= nil #lpt$)
        (progn
          ; ファイル名取得
          (setq #fname$ (SBGetFnameZ #data &srzdir))
          ; 表示順序
          (setq #z     (car  #fname$))
          ; ファイル名
          (setq #fname (cadr #fname$))

          (CFOutLog 1 nil (strcat "  +挿入ﾌｧｲﾙ名  :" #fname))
          (CFOutLog 1 nil (strcat "    +表示順序:" #z))

          ; テンプレート基準座標
          (setq #lpt (cadr #lpt$))
          (setq #lpt (list (car #lpt) (cadr #lpt) (distof #z)))
          (if (findfile #fname)
            (progn

              (CFOutStateLog 1 1 "図形挿入")
              (command "_.INSERT" #fname "0,0,0" 1 1 "0")
              (command "_.EXPLODE" (entlast))
              (setq #ss (ssget "P"))
              ; 基準座標取得
              (if (/= nil #ss)
                (progn
                  ; 基準座標取得
                  (setq #bpt nil)
                  (setq #i 0)
                  (repeat (sslength #ss)
                    (setq #en (ssname #ss #i))
                    (setq #eg   (entget #en '("*")))
                    (setq #eed$ (cdr (assoc -3 #eg)))
                    (if (assoc "G_SBPT" #eed$)
                      (setq #bpt (cdr (assoc 10 #eg)))
                    )
                    (setq #i (1+ #i))
                  )
                  ;図形移動
                  (setq #osmode (getvar "OSMODE"))
                  (setvar "OSMODE" 0)
                  (command "_.MOVE" #ss "" #bpt #lpt)
                  (setvar "OSMODE" #osmode)
                )
                (progn
                  (CFOutStateLog 0 1 "図形の中身が存在しません")(CFOutStateLog 0 1 #fname)
                )
              )

            )
            (progn
              (CFOutStateLog 0 1 "ファイルが存在しません")(CFOutStateLog 0 1 #fname)
            )
          )

        )
      ) ; end if
    )
    &cfgequ$
  )
)

;<HOM>*************************************************************************
; <関数名>    : SBGetGeneralBasePt
; <処理概要>  : 一般図面（ドア姿図、沓摺詳細図、給排水設備図）
;               の基準点座標取得
; <戻り値>    : 基準点座標リスト
; <作成>      : 1998-11-06
;*************************************************************************>MOH<
(defun SBGetGeneralBasePt (
  &90      ; (INT)      区切る数値
  /
  #ss #i #en #eg #eed$ #no #bpt$
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBGetGeneralBasePt ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "区切る数値                      : ")(CFOutStateLog 1 1 &90     )
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  ;領域点図形セット
  (setq #ss (ssget "X" '((-3 ("G_WKPT")))))
  (if (/= nil #ss)
    (progn

      (setq #i 0)
      (repeat (sslength #ss)

        (setq #en (ssname #ss #i))
        (setq #eg (entget #en '("G_WKPT")))
        (setq #eed$ (cdr (assoc -3 #eg)))
        (if (/= nil #eed$)
          (progn

            ;NO
            (setq #no (cdr (cadr (assoc "G_WKPT" #eed$))))
            ;座標取得
            (if (> #no (- &90 1))
              (setq #bpt$ (cons (list #no (cdr (assoc 10 #eg))) #bpt$))
            )
          )
        )
        (setq #i (1+ #i))
      )
    )
  )

  #bpt$ ; return
)
;<HOM>*************************************************************************
; <関数名>    : SBGetFnameZ
; <処理概要>  : パーツのファイル名と表示順と反転記号リストを獲得する
; <戻り値>    : 反転否のときのデータリスト
;               (表示順序 ファイル名 反転記号)
; <作成>      : 1998-10-15
;*************************************************************************>MOH<
(defun SBGetFnameZ (
  &data$   ; (LIST)     パーツデータリスト
  &srzdir  ; (STR)      SERIESディレクトリ
  /
  #no #han #z #key$ #cfgdir #keyname #s$ #han #cdata$ #cdata #fname #key #s
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBGetFnameZ ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------引数 START-----------------")
  (CFOutStateLog 1 1 "パーツデータリスト              : ")(CFOutStateLog 1 1 &data$  )
  (CFOutStateLog 1 1 "SERIESディレクトリ            : ")(CFOutStateLog 1 1 &srzdir )
  (CFOutStateLog 1 1 "--------------------引数 END-------------------")

  (setq #no   (nth 0 &data$))          ; 管理番号
  (setq #han  (nth 3 &data$))          ; 反転可否
  (setq #z    (nth 4 &data$))          ; 表示順
  (setq #key$ (cdr (cddddr &data$)))   ; 検索項目記号
  (setq #cfgdir (strcat &srzdir "CFG/"))
  ;キー名
  (setq #keyname "")
  (mapcar
   '(lambda ( #key )
      (setq #s$ (assoc (strcat CG_SeriesCode "B" #key) CG_FamilyInfo$$))
      (if (and (/= nil #s$) (/= "" #s$))
        (progn
          (setq #s (cadr #s$))
          (setq #keyname (strcat #keyname #s))
        )
      )
    )
    #key$
  )
  ;反転記号
  (if (= "0" #han)
    (setq #han "A")
    (setq #han CG_DoorLR)
    ;;(if (wcmatch CG_DoorLR "[ABE/]")
    ;;  (setq #han "R")
    ;;  (setq #han "L")
    ;;)
  )
  ;ファイル名取得
  ;共通ファイル
  (setq #cdata$ (SBreadCSV (strcat #cfgdir #no ".CFG")))
  (mapcar
   '(lambda ( #cdata )
      (if
        (and
          (equal (nth 0 #cdata) #han)
          (equal (nth 1 #cdata) #keyname)
          (equal (nth 2 #cdata) "1")
        )
        (setq #fname (strcat &srzdir "CMASTER/" (nth 3 #cdata) ".DWG"))
      )
    )
    #cdata$
  )
  ;単独ファイル
  (if (or (= nil #fname)(= "" #fname))
    (setq #fname (strcat &srzdir "MASTER/" #no #han #keyname ".DWG"))
  )

  (list #z #fname #han) ; return
) ; SBGetFnameZ
