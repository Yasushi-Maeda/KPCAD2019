;<HOM>*************************************************************************
; <関数名>    : SBDrawDrainageBefore
; <処理概要>  : 給排水設備図を作成するための環境を整える
; <戻り値>    : なし
; <作成>      : 1998-06-16
; <備考>      : テンプレートファイルで新規図面のとき内観図作成
;               図面に名前がある場合
;                 → 上書き保存し、新規図面にする
;               図面に名前はないが図形が存在するとき
;                 → 現在の図面を放棄し、新規図面にする
;*************************************************************************>MOH<
(defun SBDrawDrainageBefore (
  /
  #tempdir #tempfile
  )
;;;  (CFOutStateLog 1 2 "//// SBDrawDrainageBefore ////")

  ; テンプレートファイルの格納ディレクトリ
  (setq #tempdir (strcat CG_SYSPATH "template\\bath\\"))

  ; テンプレートファイル名
  (setq #tempfile (strcat #tempdir "SB_給排.dwt"))
  (if (findfile #tempfile)
    (progn

;;;      (CFOutStateLog 1 2 "テンプレートファイル名 = ")(CFOutStateLog 1 2 #tempfile)
      (if (/= nil CG_OpenMode)
        (progn

;;;          (CFOutStateLog 1 2 "給排水設備図作図")
          (setq CG_OpenMode nil)
          (SBDrawDrainage)
        )
        (if (equal "DRAWING.DWG" (strcase (getvar "DWGNAME")))
          (progn
            (command "_point" "0,0")

;;;            (CFOutStateLog 1 2 "新規図面にする")
            (setq CG_OpenMode 3)
            (if (= 0 (getvar "DBMOD"))
              ;00/02/03 HN S-MOD (command "_.new")を変更
              ;@@@(command ".new" #tempfile)
              (CfDwgNewByScript #tempfile)
              ;00/02/03 HN E-MOD (command "_.new")を変更
              (progn
;;;                (CFOutStateLog 1 2 "既存図面放棄")
                ;00/02/03 HN S-MOD (command "_.new")を変更
                ;@@@(command ".new" "Y" #tempfile)
                (CfDwgNewByScript #tempfile)
                ;00/02/03 HN E-MOD (command "_.new")を変更
              )
            )
          )
          (progn

;;;            (CFOutStateLog 1 2 "図面に名前が有る")
            (setq CG_OpenMode 3)
;;;            (CFOutStateLog 1 2 "上書き保存")
            (command ".qsave")
;;;            (CFOutStateLog 1 2 "新規図面にする")
            ;00/02/03 HN S-MOD (command "_.new")を変更
            ;@@@(command ".new" #tempfile)
            (CfDwgNewByScript #tempfile)
            ;00/02/03 HN E-MOD (command "_.new")を変更

          )
        ) ; end if
      ) ; end if
    )
    (progn
;;;      (CFOutStateLog 1 2 "給排水設備図のテンプレートファイルが存在しません.")
;;;      (CFOutStateLog 1 2 "テンプレートファイル名 = ")(CFOutStateLog 1 2 #tempfile)
    )
  ) ; end if

  (princ) ; return
) ; SBDrawDrainageBefore

;<HOM>*************************************************************************
; <関数名>    : SBDrawDrainage
; <処理概要>  : 給排水設備図を作成する
; <戻り値>    : なし
; <作成>      : 1998-06-16
; <修正>      : 1999-03-01
; <備考>      : この関数では現在内観図用テンプレートで新規図面を開いた状態
;               であることを前提条件とする.
;*************************************************************************>MOH<
(defun SBDrawDrainage (
  /
  #cfgname #savedir #tlayer #90 #cfgequ$ #bpt$ #cmdecho #dsize #wsize #bpt$ #view #LAY$
  )
;;;  (CFOutStateLog 1 2 "//// SBDrawDrainage ////")

  ;--------------- 初期設定-----------------
  (setq #cfgname (strcat CG_SBDATAPATH CG_SeriesFolder "\\CFG\\CLASSIFI.CFG"))
  (setq #savedir CG_SBOUTPATH)
  (setq #tlayer "0_TITLET")
  (setq #90 90)
  (setq #lay$
    (list
      "0"
      "0_frame" "0_pers" "0_plane" "0_side_a" "0_titlef"  "0_titlet"
    )
  )
  ;-----------------------------------------

  (if (findfile #cfgname)
    (progn
;(dpr '#cfgname)
;;;      (CFOutStateLog 1 2 "CFGファイルリスト編集")
      (setq #cfgequ$ (cadr (SBModCfgFile #cfgname #90)))
;(dpr '#cfgequ$)
;;;      (CFOutStateLog 1 2 "給排水設備図作図")
      (setq #bpt$ (SBGetGeneralBasePt #90))
      (SBDrawGeneralPlan #bpt$ #cfgequ$ (strcat CG_SBDATAPATH CG_SeriesFolder "\\"))

;;;      (CFOutStateLog 1 2 "寸法線編集")
      ;-------修正 森本----------------
      (SBModDimensionSketch CG_WOffset CG_BaseOffset)
      ;-------------------------------

;;;      (CFOutStateLog 1 2 "タイトル作成")
      (SBMakeTitleText
        #tlayer CG_PackName CG_BukkenName CG_SeriesName CG_KoujiKind
        CG_BukkenNo CG_Zno CG_ModelName
      )

;;;      (CFOutStateLog 1 2 "パージ")
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

;;;      (CFOutStateLog 1 1 "画層表示編集")
      (command "_.-LAYER" "OF" "*" "")
      (command "_.-LAYER")
      (foreach #lay #lay$
        (if (tblsearch "layer" #lay)
          (command "ON" #lay)
        )
      )
      (command "")
      (setvar "CLAYER" "0")

;;;      (CFOutStateLog 1 2 "図面保存")
      (SBSaveas #savedir CG_BukkenNo CG_Zno)
    )
    (progn
;;;      (CFOutStateLog 0 1 "CFGファイルが存在しません")
    )
  ) ; end if

  (setvar "filedia" 1)

  (princ) ; return
) ; SBDrawDrainage

