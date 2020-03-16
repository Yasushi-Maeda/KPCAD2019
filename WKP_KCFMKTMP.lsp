;;;<HOF>************************************************************************
;;; <ファイル名>: KCFmktmp.LSP
;;; <システム名>: KitchenPlanシステム
;;; <最終更新日>: 01/04/08 中村博伸
;;; <備考>      : なし
;;;************************************************************************>FOH<
;@@@(princ "\nSCFmktmp.fas をﾛｰﾄﾞ中...\n")

;<HOM>*************************************************************************
; <関数名>    : C:SCFMkTplRead
; <処理概要>  : ﾕｰｻﾞﾃﾝﾌﾟﾚｰﾄの作成 -> ﾃﾝﾌﾟﾚｰﾄ読込み
; <戻り値>    : なし
; <作成>      : 1999-06-28
; <備考>      : なし
;*************************************************************************>MOH<
(defun C:SCFMkTplRead (
  /
  #sFname #iOk
  )

  (SCFStartShori "SCFMkTplRead")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  (setq #iOk (CFYesNoDialog "図面を一度保存しますか？"))
  (setq #sFname (getfiled "ﾃﾝﾌﾟﾚｰﾄ読込み" CG_TMPHPATH "dwt" 6))
  (if (/= nil #sFname)
    (progn
      (if (= T #iOk)
        (progn
          ; 01/03/02 HN S-MOD 領域枠の非表示処理を追加
          ; テンプレート図面の場合、領域枠を非表示とする
          (if (JudgeModeMkTpl)
            (progn
              (command "_.layer" "of" "0_waku" "")
              (setvar "CLAYER" "0")
            )
          )
          ; 01/03/02 HN E-MOD 領域枠の非表示処理を追加
;;;03/04/18YM@MOD          (command "_.save" (strcat (getvar "dwgprefix") (getvar "dwgname")))
					; 03/04/18 YM MOD-S
				  (command "_.QSAVE")
				  (if (wcmatch (getvar "CMDNAMES") "*QSAVE*")
				    (command "2000" "")
				  )
					; 03/04/18 YM MOD-E

        )
      )
      (setq CG_OpenMode 5)
      ;メニュー切り替え
      (ChgSystemCADMenu "")
      (CfDwgOpenByScript #sFname)
    )
  )
;;;	(CFAlertMsg "！注意：ﾃﾝﾌﾟﾚｰﾄの保存には必ず、[ﾕｰｻﾞｰﾃﾝﾌﾟﾚｰﾄ][ﾕｰｻﾞｰﾃﾝﾌﾟﾚｰﾄ保存]をお使いください。")

  ; 終了処理 2000/09/07 HT
  (SCFEndShori)

  (princ)
) ; C:SCFMkTplRead

;<HOM>*************************************************************************
; <関数名>    : SCFMkTplBefore
; <処理概要>  : ﾕｰｻﾞﾃﾝﾌﾟﾚｰﾄ編集前の処理
; <戻り値>    : なし
; <作成>      : 00/01/28
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCFMkTplBefore (
  /
  )
  ;画層作成
  (if (not (tblsearch "LAYER" "0_WAKU")) (SKFMakeLayer "0_WAKU" 8 "CONTINUOUS"))

  ; 領域図形の存在する画層を表示にする 2000/09/26 HT MOD START
  (SCFWakuLayerON)
  ;;画層ON
  ;(command "-layer" "on" "0_WAKU" "")
  ;;現在画層に設定
  ;(setvar "CLAYER" "0_WAKU")
  ; 領域図形の存在する画層を表示にする 2000/09/26 HT MOD END


  ;ZOOM
  (command "_.ZOOM" "A")
  ;グループ
  (setvar "PICKSTYLE" 3)
  ;オープンモード
  (setq CG_OpenMode nil)

  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : C:SCFMkTplRect
; <処理概要>  : ﾕｰｻﾞﾃﾝﾌﾟﾚｰﾄの作成 -> 領域作成
; <戻り値>    : なし
; <作成>      : 1999-06-18
; <備考>      : なし
;*************************************************************************>MOH<
(defun C:SCFMkTplRect (
  /
  #sClayer #Pt$ #eR #sVcode #sTxt #dMin #dMax #dPt #eT #xSp #eEn
  )

  (SCFStartShori "SCFMkTplRect")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  (if (JudgeModeMkTpl)
    (progn
      ;画層作成
      (setvar "PICKSTYLE" 3)
      (setq #sClayer (getvar "CLAYER"))
      ; 領域図形の存在する画層を表示にする 2000/09/26 HT ADD
      (SCFWakuLayerON)
      ;(setvar "CLAYER" "0_WAKU")
      (setq #Pt$ (CFDrawRectOrRegionTransUcs 1))
      (if (/= nil #Pt$)
        (progn
          (setq #eR (entlast))
          (setq #sVcode (SCFMkTplRectDlg "P"))
          (if (/= nil #sVcode)
            (progn
              ;拡張ﾃﾞｰﾀ付加
              (if (not (tblsearch "APPID" "FRAME")) (regapp "FRAME"))
              (CfSetXData #eR "FRAME" (list #sVcode))
              ;テキスト表示
              (cond
                ((= "P"  #sVcode) (setq #sTxt "平面図"))
                ((= "SA" #sVcode) (setq #sTxt "展開Ａ図"))
                ((= "SB" #sVcode) (setq #sTxt "展開Ｂ図"))
                ((= "SC" #sVcode) (setq #sTxt "展開Ｃ図"))
                ((= "SD" #sVcode) (setq #sTxt "展開Ｄ図"))
                ((= "SE" #sVcode) (setq #sTxt "展開Ｅ図"))  ; 2000/10/06 HT
                ((= "D"  #sVcode) (setq #sTxt "仕様図"))
                ((= "F" (substr #sVcode 1 1))
                  (setq #sTxt (strcat "姿図" (substr #sVcode 2)))
                )
              )
              (setq #dMin (list (apply 'min (mapcar 'car #Pt$))(apply 'min (mapcar 'cadr #Pt$))))
              (setq #dMax (list (apply 'max (mapcar 'car #Pt$))(apply 'max (mapcar 'cadr #Pt$))))
              (setq #dPt  (mapcar '* '(0.5 0.5) (mapcar '+ #dMin #dMax)))
              (setq #dPt  (list (car #dPt) (cadr #dPt) 0.0))
              (entmake
                (list
                  (cons 0 "TEXT")
                  (cons 1 #sTxt)
                  (cons 10 #dPt)
                  (cons 11 #dPt)
                  (cons 40 200)      ; 文字高さ
                  (cons 72 1)        ; 水平位置合わせ
                  (cons 73 2)        ; 垂直位置合わせ
                  (cons 50 0)        ; 回転角度
                )
              )
              (setq #eT (entlast))
              ;グループ化
              (setq #xSp (ssadd))
              (ssadd #eR #xSp)
              (ssadd #eT #xSp)
              (SKMkGroup #xSp)
            )
            (entdel #eEn)
          )
        )
      )
      (setvar "CLAYER" #sClayer)
    )
    (progn
      (CFAlertMsg "テンプレートを開いていません")
    )
  )

  ; 終了処理 2000/09/07 HT
  (SCFEndShori)
  (princ)
) ; C:SCFMkTplRect

;<HOM>*************************************************************************
; <関数名>    : C:SCFMkTplDel
; <処理概要>  : ﾕｰｻﾞﾃﾝﾌﾟﾚｰﾄの作成 -> 領域削除
; <戻り値>    : なし
; <作成>      : 1999-06-18
; <備考>      : なし
;*************************************************************************>MOH<
(defun C:SCFMkTplDel (
  /
  #xSp #En$ #Ex$ #eEn #Gen$ #eGen #eRect #iOk
  )
  (SCFStartShori "SCFMkTplDel")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  ; 領域図形の存在する画層を表示にする 2000/09/26 HT ADD
  (SCFWakuLayerON)

  (if (JudgeModeMkTpl)
    (progn
      (setq #xSp (ssget "X" (list (list -3 (list "FRAME")))))
      (if (/= nil #xSp)
        (progn
          (setq #En$ T)
          (while (/= nil #En$)
            (setq #En$ (SKGetPtByEn "削除する領域を選択してください." "*" "領域" nil))
            (if (/= nil #En$)
              (progn
                ;指定された図形のグループを獲得
                (setq #Gen$ (SKFGetGroupEnt (car (car #En$))))
                (mapcar
                 '(lambda ( #eGen )
                    (setq #Ex$ (CfGetXData #eGen "FRAME"))
                    (if (/= nil #Ex$)
                      (progn
                        (setq #eEn #eGen)
                        (setq #En$ nil)
                      )
                    )
                  )
                  #Gen$
                )
                (if (= nil #eEn)
                  (setq #En$ T)
                )
              )
            )
          )
          (if (/= nil #eEn)
            (progn
              ;グループをハイライト
              (mapcar
               '(lambda ( #eGen )
                  (if (assoc -3 (entget #eGen '("RECT")))
                    (setq #eRect #eGen)
                  )
                  (redraw #eGen 3)
                )
                #Gen$
              )
              ;確認ダイアログ
              (setq #iOk (CFYesNoDialog "この領域を削除します\nよろしいですか？"))
              (mapcar
               '(lambda ( #eGen )
                  (redraw #eGen 4)
                )
                #Gen$
              )
              (if (= T #iOk)
                (progn
                  ;ｸﾞﾙｰﾌﾟ分解
                  (setq #sName (SKGetGroupName (car #Gen$)))
                  ;113 01/04/08 HN MOD OEM版の判定方法を変更
                  ;MOD(if (= "OEM" CG_ACAD_VER)
                  (if (/= "ACAD" (strcase (getvar "PROGRAM")))
                    (command "_.-group" "U" #sName)
                    (command "_.-group" "E" #sName)
                  )
                  ;矢視削除
                  (mapcar
                   '(lambda ( #eGen )
                      (entdel #eGen)
                    )
                    #Gen$
                  )
                )
              )
            )
          )
        )
        (progn
          (CFAlertMsg "領域図形が図面内に存在しません")
        )
      )
    )
    (progn
      (CFAlertMsg "テンプレートを開いていません")
    )
  )

  ; 終了処理 2000/09/07 HT
  (SCFEndShori)
  (princ)
) ; C:SCFMkTplDel

;<HOM>*************************************************************************
; <関数名>    : C:SCFMkTplEdit
; <処理概要>  : ﾕｰｻﾞﾃﾝﾌﾟﾚｰﾄの作成 -> 属性変更
; <戻り値>    : なし
; <作成>      : 1999-06-18
; <備考>      : なし
;*************************************************************************>MOH<
(defun C:SCFMkTplEdit (
  /
  #xSp #En$ #Ex$ #eEn #sVcode #Gen$ #eG #eT #sTxt
  )

  (SCFStartShori "SCFMkTplEdit")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  ; 領域図形の存在する画層を表示にする 2000/09/26 HT ADD
  (SCFWakuLayerON)

  (if (JudgeModeMkTpl)
    (progn
      (setq #xSp (ssget "X" (list (list -3 (list "FRAME")))))
      (if (/= nil #xSp)
        (progn
          (setq #En$ T)
          (while (/= nil #En$)
            (setq #En$ (SKGetPtByEn "属性変更する領域を選択してください." "*" "領域" nil))
            (if (/= nil #En$)
              (progn
                ;指定された図形のグループを獲得
                (setq #Gen$ (SKFGetGroupEnt (car (car #En$))))
                (mapcar
                 '(lambda ( #eGen )
                    (setq #Ex$ (CfGetXData #eGen "FRAME"))
                    (if (/= nil #Ex$)
                      (progn
                        (setq #eEn #eGen)
                        (setq #sVcode (car (CfGetXData #eEn "FRAME")))
                        (setq #En$ nil)
                      )
                    )
                  )
                  #Gen$
                )
                (if (= nil #eEn)
                  (setq #En$ T)
                )
              )
            )
          )
          (if (/= nil #eEn)
            (progn
              (setq #sVcode (SCFMkTplRectDlg #sVcode))
              (if (/= nil #sVcode)
                (progn
                  ;拡張ﾃﾞｰﾀ変更
                  (CfSetXData #eEn "FRAME" (list #sVcode))
                  ;指定された図形のグループを獲得
                  (setq #Gen$ (SKFGetGroupEnt #eEn))
                  (mapcar
                   '(lambda ( #eG )
                      (if (equal "TEXT" (cdr (assoc 0 (entget #eG))))
                        (setq #eT #eG)
                      )
                    )
                    #Gen$
                  )
                  ;テキスト表示
                  (cond
                    ((= "P"  #sVcode) (setq #sTxt "平面図"))
                    ((= "SA" #sVcode) (setq #sTxt "展開Ａ図"))
                    ((= "SB" #sVcode) (setq #sTxt "展開Ｂ図"))
                    ((= "SC" #sVcode) (setq #sTxt "展開Ｃ図"))
                    ((= "SD" #sVcode) (setq #sTxt "展開Ｄ図"))
                    ((= "SE" #sVcode) (setq #sTxt "展開Ｅ図"))  ; 2000/10/06 HT ADD
                    ((= "D"  #sVcode) (setq #sTxt "仕様図"))
                    ((= "F"  (substr #sVcode 1 1))
                      (setq #sTxt (strcat "姿図" (substr #sVcode 2)))
                    )
                  )
                  (entmod (subst (cons 1 #sTxt) (assoc 1 (entget #eT)) (entget #eT)))
                )
              )
            )
          )
        )
        (progn
          (CFAlertMsg "領域図形が図面内に存在しません")
        )
      )
    )
    (progn
      (CFAlertMsg "テンプレートを開いていません")
    )
  )

  ; 終了処理 2000/09/07 HT
  (SCFEndShori)
  (princ)
) ; C:SCFMkTplEdit

;<HOM>*************************************************************************
; <関数名>    : C:SCFMkTplSave
; <処理概要>  : ﾕｰｻﾞﾃﾝﾌﾟﾚｰﾄの作成 -> 保存
; <戻り値>    : なし
; <作成>      : 1999-06-18
; <備考>      : なし
;*************************************************************************>MOH<
(defun C:SCFMkTplSave
  (
  /
  #sFname #dfname
  )

  (SCFStartShori "SCFMkTplSave")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  (if (JudgeModeMkTpl)
    (progn
      (command "_-layer" "of" "0_waku" "")
      (setvar "CLAYER" "0")
      (setq #iRet nil)

      (while (= #iRet nil)
        (setq #sFname (getfiled "ﾃﾝﾌﾟﾚｰﾄ保存" CG_TMPHPATH "dwt" 1))
        (if (/= nil #sFname)
          (progn
            ; テンプレートファイル名が命名規則にあっているかどうかの確認
            ; 2000/08/08 HT
            (setq #iRet (SCFDWTFNameCheck #sFname))
            (if (= #iRet nil)
              (progn
                ; 命名規則にあっていない時、保存するかどうか確認する。
                ; 命名規則にあっていない場合、パターン詳細設定のフィルタの
                ; 対象にならない。が、他に影響はない。
                (setq #iRet
                  (CFYesNoDialog
                    (strcat
                      "テンプレート名が命名規則にあっていません。"
                      "\n   保存してよろしいですか？\n"
                      "\n    [命名規則] "
                      "\n     (1-2桁用紙サイズ = A4 A3 A2 B4)"
                      "\n     (4-5桁尺度 = 40 30 20 01)"
                      "\n       例.) A3-30-1-IU型平面.dwt"
                    )
                  )
                )
              )
            )
            (if (= #iRet T)
              (progn
                (setq #dfname (strcat CG_TMPAPATH "dummy.dwg"))
                (command "_.saveas" "2000" #dfname)

								;2020/03/06 YM MOD-S
;;;                (command "_.saveas" "t" #sFname )
                (command "_.saveas" "t" #sFname "m" "");単位メートル、テンプレートの説明
								;2020/03/06 YM MOD-E

                (if (findfile #dfname)
                  (vl-file-delete #dfname)
                )
              )
            )  ; 確認メッセージ
          ) ; progn
          (progn
            ; ファイルダイアログでキャンセルされた時はループを抜ける
            (setq #iRet T)
          )
        ) ; ファイルダイアログ
      ) ; while
    )
    (progn
      (CFAlertMsg "テンプレートを開いていません。")
    )
  )

  ; 終了処理 2000/09/07 HT
  (SCFEndShori)
  (princ)
) ; C:SCFMkTplSave


;<HOM>*************************************************************************
; <関数名>    : SCFDWTFNameCheck
; <処理概要>  : テンプレートファイル名が命名規則にあっているかどうかの確認
; <戻り値>    : あっている : T    not : nil
; <作成>      : 2000/08/08
; <備考>      : パターン詳細設定ダイアログでのフィルターで使用可能かどうか
;*************************************************************************>MOH<
(defun SCFDWTFNameCheck (
  &sDWTFileName     ; テンプレートファイル名
  /
  #sPaperSize$      ; 用紙サイズ
  #sScale$	    ; 尺度
  #bRet             ; 返り値
  #sFileName        ; ディレクトリパスと拡張子を除いたファイル名

  )
  (setq #bRet T)
  (setq #sFileName (vl-filename-base &sDWTFileName))
  (setq #sPaperSize$ (list "A4" "A3" "A2" "B4"))
  (setq #sScale$ (list "40" "30" "20" "01"))
  (if (or
    (= nil (member (substr #sFileName 1 2) #sPaperSize$))
    (= nil (member (substr #sFileName 4 2) #sScale$))
    )
    (progn
    (setq #bRet nil)
    )
  )
#bRet
)

;<HOM>*************************************************************************
; <関数名>    : SCFMkTplRectDlg
; <処理概要>  : ﾕｰｻﾞﾃﾝﾌﾟﾚｰﾄの作成ﾀﾞｲｱﾛｸﾞ
; <戻り値>    : なし
; <作成>      : 1999-06-18
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCFMkTplRectDlg (
  &sVcode     ; ﾀﾞｲｱﾛｸﾞ表示初期値
  /
  #ss #i #en #ed$ #fno$ #iId #sRet ##OK_Click #iRet
  )

  (defun ##OK_Click(
    /
    #sDrw #sRet #fs
    )
    (setq #sDrw (get_tile "rdoDrw"))
    (cond
      ((= "rdoPl" #sDrw) (setq #sRet "P"))
      ((= "rdoEx" #sDrw)
        (cond
          ((= "rdoA" (get_tile "rdoDrc")) (setq #sRet "SA"))
          ((= "rdoB" (get_tile "rdoDrc")) (setq #sRet "SB"))
          ((= "rdoC" (get_tile "rdoDrc")) (setq #sRet "SC"))
          ((= "rdoD" (get_tile "rdoDrc")) (setq #sRet "SD"))
          ((= "rdoE" (get_tile "rdoDrc")) (setq #sRet "SE"))  ; 2000/10/06 HT ADD
        )
      )
      ((= "rdoDn" #sDrw) (setq #sRet "D"))
;2011/07/25 YM DEL-S
;;;      ((= "rdoFg" #sDrw)
;;;        (cond
;;;          ((/= 'INT (type (read (get_tile "edtfig"))))
;;;            (CFAlertMsg "整数を指定してください")
;;;          )
;;;          ((minusp (read (get_tile "edtfig")))
;;;            (CFAlertMsg "正の値を指定してください")
;;;          )
;;;          ((member (get_tile "edtfig") #fno$)
;;;            (CFAlertMsg "その値は既に存在します")
;;;          )
;;;          (T
;;;            (setq #fs (get_tile "edtfig"))
;;;            (setq #sRet (strcat "F" #fs))
;;;          )
;;;        )
;;;      )
;2011/07/25 YM DEL-E
    )
    (if (/= nil #sRet)
      (done_dialog 1)
    )

    #sRet
  )
  (defun ##Chg_Image(
    /
    #sPlan #sFname #fX #fY
    )
    ;展開矢視方向イメージ
    (setq #sPlan (get_tile "rdoDrw"))
    (if (= #sPlan "rdoEx")
      (progn
        (setq #sFname "abcd")
        (mode_tile "rdoDrc" 0)
      )
      (progn
        (setq #sFname "no")
        (mode_tile "rdoDrc" 1)
      )
    )
    (setq #fX (dimx_tile "imgYashi"))
    (setq #fY (dimy_tile "imgYashi"))
    (start_image "imgYashi")
    (fill_image  0 0 #fX #fY -0)
    (slide_image 0 0 #fX #fY (strcat CG_SLDPATH #sFname ".sld"))
    (end_image)

    ;姿図番号
;2011/07/25 YM DEL-S
;;;    (if (= #sPlan "rdoFg")
;;;      (progn
;;;        (mode_tile "edtfig" 0)
;;;        (mode_tile "edtfig" 2)
;;;      )
;;;      (mode_tile "edtfig" 1)
;;;    );_if
;2011/07/25 YM DEL-E

  )

  ;既存の姿図番号獲得
  (setq #ss (ssget "X" (list (list -3 (list "FRAME")))))
  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #ed$ (CfGetXData #en "FRAME"))
        (if (= "F" (substr (car #ed$) 1 1))
          (setq #fno$ (cons (substr (car #ed$) 2) #fno$))
        )
        (setq #i (1+ #i))
      )
    )
  )

  ;ﾀﾞｲｱﾛｸﾞ表示
  (setq #iId (GetDlgID "CSFmktmp"))
  (if (not (new_dialog "mktpl" #iId))(exit))

    (cond
      ((= "P"  &sVcode) (set_tile "rdoPl" "1")(set_tile "rdoA" "1"))
      ((= "SA" &sVcode) (set_tile "rdoEx" "1")(set_tile "rdoA" "1"))
      ((= "SB" &sVcode) (set_tile "rdoEx" "1")(set_tile "rdoB" "1"))
      ((= "SC" &sVcode) (set_tile "rdoEx" "1")(set_tile "rdoC" "1"))
      ((= "SD" &sVcode) (set_tile "rdoEx" "1")(set_tile "rdoD" "1"))
      ((= "SE" &sVcode) (set_tile "rdoEx" "1")(set_tile "rdoE" "1")) ; 2000/10/06 HT ADD
      ((= "D"  &sVcode) (set_tile "rdoDn" "1")(set_tile "rdoA" "1"))
;2011/07/25 YM DEL-S
;;;      ((= "F"  (substr &sVcode 1 1))
;;;        (set_tile "rdoFg" "1")
;;;        (set_tile "edtfig" (substr &sVcode 2))
;;;      )
;2011/07/25 YM DEL-E
    )
    (##Chg_Image)

    (action_tile "rdoDrw" "(##Chg_Image)")
    (action_tile "accept" "(setq #sRet (##OK_Click))")
    (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OKボタン押下
    #sRet
    nil
  )
) ; SCFMkTplRectDlg

;<HOM>*************************************************************************
; <関数名>    : JudgeModeMkTpl
; <処理概要>  : ユーザテンプレートの作成モードか判断
; <戻り値>    : なし
; <作成>      : 00/01/31
; <備考>      : なし
;*************************************************************************>MOH<
(defun JudgeModeMkTpl (
  /
  #sFname
  )
  (setq #sFname (getvar "DWGNAME"))
  (if (equal (strcase #sFname) "MODEL.DWG")
    nil
    T
  )

) ; JudgeModeMkTpl


;<HOM>*************************************************************************
; <関数名>    : SCFWakuLayerON
; <処理概要>  : 0_WAKU 画層 ON  + 現在画層に
; <戻り値>    : なし
; <作成>      : 00/09/26
; <備考>      : 領域図形の存在する画層を表示にする
;*************************************************************************>MOH<
(defun SCFWakuLayerON (
  /
  )
  ;画層作成
  (if (not (tblsearch "LAYER" "0_WAKU")) (SKFMakeLayer "0_WAKU" 8 "CONTINUOUS"))
  ;画層ON
  (SCF_LayDispOn (list "0_WAKU"))
  ;現在画層に設定
  (setvar "CLAYER" "0_WAKU")
)


