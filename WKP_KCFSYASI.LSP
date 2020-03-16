;矢視関連画層の定義
(setq CG_YASHI_LAYER                "N_YASHI")                ;矢視画層
(setq CG_YASHI_AREA_LAYER           "N_YASHI_AREA")           ;矢視領域画層
(setq CG_YASHI_PERS_LAYER           "N_YASHI_PERS")           ;パース矢視画層
(setq CG_YASHI_PERS_HIDE_AREA_LAYER "N_YASHI_PERS_HIDE_AREA") ;パース矢視領域画層
(setq CG_YASHI_COL        50)                      ;矢視の色
(setq CG_YASHI_AREA_COL   60)                      ;矢視領域の色

(setq CG_PERS_HIDE_AREA "N_PERS_HIDE_AREA")  ;パース非表示領域画層

(setq CG_PERS_VIEW_HD   "TKR_視線")             ;パースビューの頭文字

;<HOM>*************************************************************************
; <関数名>    : C:SCFSetYashi
; <処理概要>  : 矢視設定
; <戻り値>    : なし
; <作成>      : 1999-06-16
; <備考>      : なし
;*************************************************************************>MOH<
(defun C:SCFSetYashi (
  /
  #plinewid #cecolor #entlast #xSp #iI #ed$ #j #No$ #DclRet$ #Rec$
  #eRec #flg #inspt #eNo #Ed$ #en$ #dY #iOrthomode #dA #sAng #eYen #eEn #del$ #en
  )

  (SCFStartShori "SCFSetYashi")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  ; 現在のライン幅、色を記憶しておく
  (setvar "CLAYER" "0")
  (setq #plinewid (getvar "PLINEWID"))  ; ポリラインの幅
  (setvar "PLINEWID" 0.0)
  (setq #cecolor (getvar "CECOLOR"))    ; 現在色

;-- 2011/09/26 A.Satoh Add - S
  (setq #iOrthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)
;-- 2011/09/26 A.Satoh Add - E

	;真上からのﾋﾞｭｰにする 2011/09/26 YM ADD-S
  ;// ビューを登録
  (command "_view" "S" "TEMP_SY")
	(command "_.VPOINT" "0,0,1")
	;2011/09/26 YM ADD-E

  ; 01/05/10 TM DEL 不要
  ;(setq #entlast (entlast))

  (if (/= nil CG_KENMEI_PATH)
    (progn
      (setvar "PICKSTYLE" 3)
      ;現在存在する作図領域番号を獲得
      (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))

      ; ABCD方向矢視があるか
      (if (setq #xSp (SCFIsYashiType #xSp "*[ABCD]*"))
        (if (CFYesNoDialog "既に矢視が設定されています\n削除しますか?")
          (progn
            (KCFDeleteYashi (ssname #xSp 0))
          )
          (progn
            (quit)
          )
        )
      )      
      
      ; 矢視方向設定ダイアログ
      (setq #DclRet$ (SCFSetYashiDlg #No$))
      (if (/= nil #DclRet$)
        ; 矢視位置と矢視領域を指定する
        (progn
          (setq #eYen (KCFPlaceYashi #DclRet$))
        )
        ;else
        (*error* "矢視設定中止")
      )
    )
    (progn
      (CFAlertMsg "物件が呼び出されていません.")
    )
  )

  (setvar "CECOLOR" #cecolor)
  (setvar "PLINEWID" #plinewid)
;-- 2011/09/26 A.Satoh Add - S
  (setvar "ORTHOMODE" #iOrthomode)
;-- 2011/09/26 A.Satoh Add - E

  ;// ビューを戻す 2011/09/26 YM ADD-S
  (command "_view" "R" "TEMP_SY")
	;2011/09/26 YM ADD-E

  ; 終了処理 2000/09/07 HT
  (SCFEndShori)

  (princ "\n終了")

  ; DEBUG (princ "\n矢視データ: ")
  ; DEBUG (princ (entget #eYen))
  (princ)
) ; C:SCFYashiSet

;<HOM>*************************************************************************
; <関数名>    : SCFSetYashiDlgOkClick
; <処理概要>  : 矢視設定ダイアログ
; <戻り値>    : 矢視記号ﾘｽﾄ
;        LIST : （領域番号 矢視記号 作図領域指定有無リスト）
; <作成>      : 01/04/27 TM ADD 外に出した
; <備考>      : なし
;*************************************************************************>MOH<
(defun KCFSetYashiDlgOkClick(
    /
;    #flg ; 矢視設定チェック
    )

    (if (not  (or 
                (= "1" (get_tile "tglA"))(= "1" (get_tile "tglB"))
                (= "1" (get_tile "tglC"))(= "1" (get_tile "tglD"))
              )
        )
        (CFAlertMsg "矢視を指定してください.")
        (done_dialog 1)
    )

) ;_ KCFSetYashiDlgOkClick

;<HOM>*************************************************************************
; <関数名>    : SCFSetYashiDlg
; <処理概要>  : 矢視設定ダイアログ
; <戻り値>    : 矢視記号ﾘｽﾄ
;        LIST : （領域番号 矢視記号 矢視領域設定する矢視記号）
; <作成>      : 1999-06-16 -> 99/11/25
; <備考>      : 01/04/27 TM MOD 矢視ごとに矢視領域を設定可能に変更
;*************************************************************************>MOH<
(defun SCFSetYashiDlg (
  &No$        ; 既に存在する矢視番号リスト
  /
  #sYashi #dYashi #iId #iRet #sNo #iType
  #sYsReg   ; 矢視領域設定する矢視文字列
#S ;2011/07/16 YM ADD
  )

  ;============================================================================
  ; 矢視有無のトグル変更時に呼び出される関数
  (defun ##Chg_Image(
    &sKey     ; (STR)変更する矢視記号 "" 
              ; "" の場合変更しない
    /
    #iI       ; 操作変数
    #Yashi$   ; 矢視方向リスト
    #Yashi_n$ ; 操作変数
    #YasReg$  ; 矢視領域リスト
    #s        ; 操作変数
    #sFname 
    #fX #fY
    )
    ; 01/04/27 TM ADD-S 矢視領域の再追加
    ; 各矢視の有無を切り替えた際に、矢視領域有無の設定を有効／無効にする
    (cond
      ((= "1" (get_tile (strcat "tgl" &sKey)))
        (mode_tile (strcat "tglReg" &sKey) 0)
      )
      ((= "0" (get_tile (strcat "tgl" &sKey)))
        (mode_tile (strcat "tglReg" &sKey) 1)
      )
    )
    ; 01/04/27 TM ADD-E 矢視領域の再追加

    ; 矢視方向指定の有無をチェック
    (setq #Yashi_n$
      (mapcar
       '(lambda ( #s )
          (if (/= "0" (get_tile (strcat "tgl" #s))) #s "")
        )
        '("A" "B" "C" "D")
      )
    )
    (setq #Yashi$ (acad_strlsort #Yashi_n$))
    ; DEBUG (princ "\n矢視方向: ")
    ; DEBUG (princ #Yashi$)

    ; 矢視方向に対応する矢視領域の有無をチェック
    (setq #Yashi_n$ 
      (mapcar 
        '(lambda ( #s ) 
          (if (/= "0" (get_tile (strcat "tglReg" #s))) #s "")
        )
        #Yashi$
      )
    )
    (setq #YasReg$ #Yashi_n$)
    ; DEBUG (princ "\n領域設定: ")
    ; DEBUG (princ #YasReg$)

    ; リストを連結して文字列に戻す
    (setq #sYsReg (apply 'strcat #YasReg$))   ; 矢視領域有無
    (setq #sYashi (apply 'strcat #Yashi$))    ; 矢視有無

    (if (/= "" #sYashi)
      (setq #sFname #sYashi)
      (setq #sFname "no")
    )

    ; 矢視モデル図の大きさを取得
    (setq #fX (dimx_tile "imgYashi"))
    (setq #fY (dimy_tile "imgYashi"))

    ; 新しい矢視モデル図に差し替える
    (start_image "imgYashi")
    (fill_image  0 0 #fX #fY -0)
    (slide_image 0 0 #fX #fY (strcat CG_SLDPATH #sFname ".sld"))
    (end_image)

  )
  ;============================================================================

  (setq #sYashi "")
  (setq #sYsReg "")

  ;ﾀﾞｲｱﾛｸﾞ表示
  (setq #iId (GetDlgID "CSFsy"))
  (if (not (new_dialog "setyashi" #iId))(exit))

    (##Chg_Image "")

    (action_tile "tglA"   "(##Chg_Image \"A\")")
    (action_tile "tglB"   "(##Chg_Image \"B\")")
    (action_tile "tglC"   "(##Chg_Image \"C\")")
    (action_tile "tglD"   "(##Chg_Image \"D\")")
    (action_tile "tglRegA"   "(##Chg_Image \"\")")
    (action_tile "tglRegB"   "(##Chg_Image \"\")")
    (action_tile "tglRegC"   "(##Chg_Image \"\")")
    (action_tile "tglRegD"   "(##Chg_Image \"\")")
    ; 01/04/27 TM MOD 外に出した
    ; (action_tile "accept" "(##OK_Click)")
    (action_tile "accept" "(KCFSetYashiDlgOkClick)")
    (action_tile "cancel" "(done_dialog 0)")

    (setq #iRet (start_dialog))
    (unload_dialog #iId)

    (if (= #iRet 1) ;OKボタン押下
      (progn
        ; 01/04/27 TM MOD 矢視領域有無設定を追加
        ;(list #sNo #sYashi #iType)
        ; DEBUG (princ "\n矢視設定: ")
        ; DEBUG (princ #sYashi)
        ; DEBUG (princ "\n矢視領域設定: ")
        ; DEBUG (princ #sYsReg)
        (list #sNo #sYashi #sYsReg)
      )
    )
) ; SKSetYashiDlg

;<HOM>*************************************************************************
; <関数名>    : SCFDrawYashi
; <処理概要>  : 矢視作図
; <戻り値>    : 作成図形名ﾘｽﾄ
; <作成>      : 1999-06-17
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCFDrawYashi (
  &sYashi     ; 表示矢視文字列（AとB -> "AB"）
  &dY         ; 矢視配置座標
  &sAng       ; A方向角度
  &lay        ; 配置画層
  /
  #En$ #iI #xSa #sS #sAng #xSp #iJ #eEn #ePt #dPt
#CLAY #LASTEN #SFLG #STRLEN
  )
  ;// 矢視の画層を作成する
	;2012/01/17 YM ADD-S
  (MakeLayer CG_YASHI_LAYER                CG_YASHI_COL      "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_LAYER           CG_YASHI_COL      "CONTINUOUS")
  (MakeLayer CG_YASHI_AREA_LAYER           CG_YASHI_AREA_COL "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")
	;2012/01/17 YM ADD-E

  ; 現在画層の変更
  (setq #cLay (getvar "CLAYER"))
  (setvar "CLAYER" &lay)

  (setq #xSa (ssadd))
  ;中心円作図
  (entmake (list (cons 0 "CIRCLE")(cons 10 &dY)(cons 40 40)))
  (ssadd (entlast) #xSa)
  (if (= (substr &sYashi 1 1) "P")
    (setq #strLen 1)
    (setq #strLen (strlen &sYashi))
  )
  ;矢視作図
  (setq #iI 1)
  (repeat #strLen
    ;矢視獲得
    (setq #sS (substr &sYashi #iI 1))
    ;追加角度
    (cond
      ((equal "A" (strcase #sS))
        (setq #sAng (angtos (+ 0          (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
      ((equal "B" (strcase #sS))
        (setq #sAng (angtos (+ (* 1.5 PI) (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
      ((equal "C" (strcase #sS))
        (setq #sAng (angtos (+ (* 1.0 PI) (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
      ((equal "D" (strcase #sS))
        (setq #sAng (angtos (+ (* 0.5 PI) (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
      ; 矢視追加 は矢視B の方向と同様に扱う
      ((member (strcase #sS) CG_ADDYASHI_LIST)
        (setq #sAng (angtos (+ (* 1.5 PI) (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
      ;パース矢視
      (T
        (setq #sS &sYashi)
        (setq #sAng (angtos (+ 0          (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
    )
    ;矢視挿入
    (setq #sflg "")
    (command "_insert" (strcat #sflg CG_BLOCKPATH "YASHI.DWG") "_non" &dY 1 1 #sAng)
    (command "_explode" (entlast))
    ;POINT図形獲得
    (setq #xSp (ssget "P"))
    (setq #iJ 0)
    (repeat (sslength #xSp)
      (setq #eEn (ssname #xSp #iJ))
      (if (equal "POINT" (cdr (assoc 0 (entget #eEn))))
        (setq #ePt #eEn)
        (ssadd #eEn #xSa)
      )
      (setq #iJ (1+ #iJ))
    )
    (setq #dPt (cdr (assoc 10 (entget #ePt))))
    (entdel #ePt)

    ;矢視種別作図
    (setq #lastEn (MakeText #sS #dPt 100 1 2 "STANDARD"))

    (ssadd #lastEn #xSa)
    (setq #iI (1+ #iI))
  )
  ;再ブロック化
  (SKUblock &dY #xSa)

  ;現在画層を元に戻す
  (setvar "CLAYER" #cLay)
  (entlast)
) ; SCFDrawYashi

;;;<HOM>*************************************************************************
;;; <関数名>    : KCFDeleteYashi
;;; <処理概要>  : 矢視削除
;;; <戻り値>    : なし
;;; <作成>      : 01/05/01 TM 
;;; <備考>      : 矢視についている領域図形も削除する（はず）
;;;*************************************************************************>MOH<
(defun KCFDeleteYashi (
  &eEn    ; 矢視図形の図形名
  /
  #eXd$   ; 矢視図形の拡張データ
  #nII    ; 操作変数
  #eYas$  ; 矢視領域のエンティティリスト
  #eYas   ; 操作変数
  )

  (setq #eXd$ (CFGetXData &eEn "RECT"))
  (if (= #eXd$ nil)
    (setq #eXd$ (CFGetXData &eEn "RECTPERS"))
  )
  ; 拡張データが矢視ではない場合
  ; DEBUG (princ "\n#eXd$: ")
  ; DEBUG (princ #eXd$)
  (if (not #eXd$)
    (progn
      (CFAlertMsg "矢視図形ではありません。")
    )
    (progn
      ; 拡張データの4番目以降が領域図形ハンドル
      (setq #nII 4)
      (while (<= #nII (length #eXd$))
        (if (and (nth (1- #nII) #eXd$) (/= "" (nth (1- #nII) #eXd$)))
          (progn
            ; 領域図形のグループ(名称は"Yashi[ABCDEF}")に含まれる図形を検索してすべて削除
            (setq #eYas$ (CFGetGroupEnt (handent (nth (1- #nII) #eXd$))))
            (foreach #eYas #eYas$
              (command "_.ERASE" #eYas "")
            )
          )
        )
        (setq #nII (1+ #nII))
      )
      (command "_.ERASE" &eEn "")
    )
  )

  (princ)

)

;;;<HOM>************************************************************************
;;; <関数名>  : KCFPlaceYashi
;;; <処理概要>: 矢視位置設定
;;; <戻り値>  : 設定した矢視図形名
;;; <作成>    : 2001-05-01 TM
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun KCFPlaceYashi (
  &DclRet$    ; (領域番号 設定する矢視文字列の連続 設定する矢視領域文字列の連続)
  /
  #sCECOLOR     ; 変更前の図形の色番号
;-- 2011/09/26 A.Satoh Del - S
;;;;;  #iOrthomode   ; 変更前の直交モード
;-- 2011/09/26 A.Satoh Del - S
  #dY           ; 矢視記号基点
  #dA           ; 矢視記号角度
  #sAng         ; 矢視記号角度
  #eYen         ; 矢視図形名
  #eXd$         ; 矢視拡張データ
  #hArea$       ; 矢視領域図形グループ名
  #nII          ; 操作変数
  #sAorE        ; 基準となる矢視方向
  #sYas         ; 矢視文字列
  #sYasDir$     ; 矢視方向指定文字列
  )

;;;  ; 図形色番号の変更
;;;  (setq #sCECOLOR (getvar "CECOLOR"))
;;;  (setvar "CECOLOR" "60")

  ; ピック形式の変更？
  (setvar "PICKSTYLE" 3)

  ; データがない場合は実行しない
  (if (= nil &DclRet$)
    (progn
      (princ "\n矢視データなし")
      (quit)
    )
  ) 
  (cond
    ; 通常の矢視
    ((wcmatch (nth 1 &DclRet$) "*[ABCD]*")
      (setq #sAorE "A")
    )
    ; その他の矢視
    (t (setq #sAorE (nth 1 &DclRet$)))
  )
; 01/05/25 TM MOD 矢視F追加

;;; ;現在色変更
;;; (setvar "CECOLOR" "50")  ; 展開図

  ;矢視設定
  (setq #dY (getpoint "\n矢視記号作図位置を指定してください: "))
  (if (/= nil #dY)
    (progn
;-- 2011/09/26 A.Satoh Del - S
;;;;;      (setq #iOrthomode (getvar "ORTHOMODE"))
;;;;;      (setvar "ORTHOMODE" 1)
;-- 2011/09/26 A.Satoh Del - E
      (setq #dA (getangle #dY (strcat "\n" #sAorE "方向を指定してください: ")))
;-- 2011/09/26 A.Satoh Del - S
;;;;;      (setvar "ORTHOMODE" #iOrthomode)
;-- 2011/09/26 A.Satoh Del - E
      (if (/= nil #dA)
        (progn
    
          ;矢視作図
          (if (/= #sAorE "A")
            (progn
              ; E/F方向はB方向に作図角度を読み替える
              (setq #dA (+ #dA (/ pi 2.0)))
            )
          )
          ; 配置した際の向きと合わない ZAN 01/05/25 TM NOTE
          (setq #sAng (angtos #dA (getvar "AUNITS") CG_OUTAUPREC))
          (setq #eXd$ (list "0" #sAng (nth 1 &DclRet$)))
          (setq #eYen (SCFDrawYashi (nth 1 &DclRet$) #dY #sAng CG_YASHI_LAYER))

          ; 矢視領域指定のある矢視のみ領域指定を行う
          (if (nth 2 &DclRet$) ; 矢視領域指定(３番目)
            (progn
              ; 矢視方向文字列→文字の配列に変換
              (setq #nII 1)
              (setq #sYasDir$ '())
              (repeat (strlen (nth 1 &DclRet$)) ; 矢視方向指定の数
                (setq #sYasDir$ (cons (substr (nth 1 &DclRet$) #nII 1) #sYasDir$))
                (setq #nII (1+ #nII))
              )
              (setq #sYasDir$ (reverse #sYasDir$))
                      
              ; 矢視方向文字列と同じ順序で矢視領域図形ハンドルを配置する
              (setq #nII 1)
              (setq #hArea '())
              (foreach #sYas #sYasDir$
                (if (= #sYas (substr (nth 2 &DclRet$) #nII 1))
                  (progn
                    (princ "\n")
                    (princ (substr (nth 2 &DclRet$) #nII 1))
                    (princ " 方向の矢視領域を指定してください。")
                    (setq #hArea$ (cons (KCFSetYashiReg (substr (nth 2 &DclRet$) #nII 1)) #hArea$))
                    (setq #nII (1+ #nII))
                  )
                  (progn
                    (setq #hArea$ (cons "" #hArea$))
                  )
                )
              );_foreach #sYas #sYasDir$
              (setq #hArea$ (reverse #hArea$))
            )
          );_if (nth 2 &DclRet$)

          ; 矢視領域グループ名がある場合、拡張属性に追加
          (if #hArea$
            (progn
              (setq #eXd$ (append #eXd$ #hArea$))
            )
          )

          ; 拡張属性を矢視図形に組み込む
          (if (not (tblsearch "APPID" "RECT")) (regapp "RECT"))
          (CFSetXData #eYen "RECT" #eXd$)
        )
        (progn
          (*error* "矢視領域位置指定キャンセル")
        )
      );_if (/= nil #dA)
    )
    (*error* "矢視記号位置指定キャンセル")
  );_if (/= nil #dY)

;;;  ; システム変数を元に戻す
;;;  (setvar "CECOLOR" #sCECOLOR)

  #eYen

) ;_ KCFPlaceYashi


;;;<HOM>************************************************************************
;;; <関数名>  : KCFPlaceYashiPers
;;; <処理概要>: パース矢視位置設定
;;; <戻り値>  : 設定した矢視図形名
;;; <作成>    : 2005-02-06 SK
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun KCFPlaceYashiPers (
  &DclRet$    ; (領域番号 設定する矢視文字列の連続 設定する矢視領域文字列の連続)
  /
  #iOrthomode    ; 変更前の直交モード
  #dY            ; 矢視記号基点
  #dA            ; 矢視記号角度
  #sAng          ; 矢視記号角度
  #eYen          ; 矢視図形名
  #eXd$          ; 矢視拡張データ
  #hArea$        ; 矢視領域図形グループ名
  #nII          ; 操作変数
  #sAorE        ; 基準となる矢視方向
  #sYas          ; 矢視文字列
  #sYasDir$      ; 矢視方向指定文字列
  )

  ; ピック形式の変更？
  (setvar "PICKSTYLE" 3)

  ; データがない場合は実行しない
  (if (= nil &DclRet$)
    (progn
      (princ "\n矢視データなし")
      (quit)
    )
  )
  (setq #sAorE (nth 1 &DclRet$))

  ;現在色変更
  ;(setvar "CECOLOR" "50")  ; 展開図

  ;矢視設定
  (setq #dY (getpoint "\n矢視記号作図位置を指定してください: "))
  (if (/= nil #dY)
    (progn
      (setq #iOrthomode (getvar "ORTHOMODE"))
      (setvar "ORTHOMODE" 0)
      (setq #dA (getangle #dY (strcat "\n" #sAorE "方向を指定してください: ")))
      (setvar "ORTHOMODE" #iOrthomode)
      (if (/= nil #dA)
        (progn

          ; 配置した際の向きと合わない ZAN 01/05/25 TM NOTE
          (setq #sAng (angtos #dA (getvar "AUNITS") CG_OUTAUPREC))

          (setq #eXd$ (list "0" #sAng (nth 1 &DclRet$)))
          (setq #eYen (SCFDrawYashi (nth 1 &DclRet$) #dY #sAng CG_YASHI_PERS_LAYER))

          ; 矢視領域指定のある矢視のみ領域指定を行う
          (if (nth 2 &DclRet$) ; 矢視領域指定(３番目)
            (progn
              (princ "\n")
              ;(princ (nth 2 &DclRet$))
              ;(princ " 方向の矢視領域を指定してください。")
              (princ "\nパースの領域外を指定してください: ")
              (setq #hArea$ (cons (KCFSetYashiReg (nth 2 &DclRet$)) #hArea$))
              (setq #hArea$ (reverse #hArea$))
            )
          );_if (nth 2 &DclRet$)

          ; 矢視領域グループ名がある場合、拡張属性に追加
          (if #hArea$
            (progn
              (setq #eXd$ (append #eXd$ #hArea$))
            )
          )

          ; 拡張属性を矢視図形に組み込む
          (if (not (tblsearch "APPID" "RECTPERS")) (regapp "RECTPERS"))
          (CFSetXData #eYen "RECTPERS" #eXd$)
        )
        (progn
          (*error* "矢視領域位置指定キャンセル")
        )
      );_if (/= nil #dA)
    )
    (*error* "矢視記号位置指定キャンセル")
  );_if (/= nil #dY)
  #eYen

) ;_ KCFPlaceYashiPers

;;;<HOM>************************************************************************
;;; <関数名>  : KCFSetYashiReg
;;; <処理概要>: 矢視領域設定
;;; <戻り値>  : 設定した領域図形のハンドル
;;; <作成>    : 2001-05-01 TM
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun KCFSetYashiReg (
  &sYas    ; 領域設定する矢視 "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"　:展開図矢視
           ;                  "P1" "P2" "P3" : パース矢視
  /
  #xSp          ; 矢視図形
  #sType        ; 領域タイプ
  #iType        ; 領域タイプ
  #inspt        ; 矢視名表示基点
  #Rec$          ; 矢視領域点列
  #eRec          ; 矢視領域図形名
  #eNam          ; 矢視領域名の図形名
  #sArea        ; 矢視領域図形グループ名
  #hArea        ; 矢視領域図形ハンドル
  #Ed$          ; 矢視拡張データ
  #sYasGrpNam    ; 矢視領域グループ名
  #cLay         ; 現在画層
  #areaLay
  )
  ; 現在画層の変更
  (setq #cLay (getvar "CLAYER"))
  ; ピック形式の変更？
  (setvar "PICKSTYLE" 3)

  ;// 矢視の画層を作成する
  (cond
    ((= (substr &sYas 1 1) "P")
      (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")
      (setq #areaLay CG_YASHI_PERS_HIDE_AREA_LAYER)

      ; 対象領域図形の種類を選択
;-- 2011/09/22 A.Satoh Mod - S
;;;;;      (initget "1 2 3")
;;;;;      (setq #sType (getkword "\n矩形(1)/領域(2)/領域なし(3)/<1>: "))
;;;;;      (if (= nil #sType)
;;;;;        (setq #sType "1")
;;;;;      )
      (setq #sType "1")
;-- 2011/09/22 A.Satoh Mod - E
      (setq #iType (atoi #sType))
    )
    (T
      (MakeLayer CG_YASHI_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")
      (setq #areaLay CG_YASHI_AREA_LAYER)

      ; 対象領域図形の種類を選択
;-- 2011/09/22 A.Satoh Mod - S
;;;;;      (initget "1 2")
;;;;;      (setq #sType (getkword "\n矩形(1)/領域(2)<1>: "))
;;;;;      (if (= nil #sType)
;;;;;        (setq #sType "1")
;;;;;      )
      (setq #sType "1")
;-- 2011/09/22 A.Satoh Mod - E
      (setq #iType (atoi #sType))
    )
  )
  (setvar "CLAYER" #areaLay)

  ; 矢視領域の作成
  (if (/= 3 #iType)
    (progn
      ; 領域選択・作図
      (setq #Rec$ (CFDrawRectOrRegionTransUcs #iType))
      (setq #eRec (entlast))

      ; 領域番号作図
      ;@DEL@(setq #inspt (list (car (car #Rec$)) (cadr (car #Rec$)) 0.0))
      ;@DEL@(MakeText "E" #inspt 100 2 3 "STANDARD")

      ; 矢視名作図

      (setq #inspt (list (- (car (car #Rec$)) 25) (- (cadr (car #Rec$)) 25) 0.0))
      (setq #eNam (MakeText &sYas #inspt 100 2 3 "STANDARD"))
      (command "_.CHANGE" #eNam "" "P" "LA" #areaLay "")
      ; 領域と名称をグループ化する
      (setq #sArea (strcat "Yashi" &sYas))
      (command "-group" "C" #sArea #sArea #eRec #eNam "")

      ; 領域図形のハンドルを取得
      (setq #hArea (cdr (assoc 5 (entget #eRec))))
    )
    (setq #hArea "")
  )

  ; システム変数を元に戻す
  (setvar "CLAYER" #cLay)

  #hArea
) ;_ KCFSetYashiReg

;;;<HOM>*************************************************************************
;;; <関数名>    : KCFAutoMakeSKViewYashi
;;; <処理概要>  : 矢視の自動作図（パース以外）
;;; <戻り値>    :
;;;           T : 正常に矢視を作図した
;;;         nil : 矢視を作図していない
;;; <作成>      : 2004-09-29 SK
;;; <備考>      : Input.cfg の SK_VIEWセクションを元に矢視を自動作図する
;*************************************************************************>MOH<
(defun KCFAutoMakeSKViewYashi (
  &NormYashi &cArea ;;  2005/12/07 G.YK ADD
  /
  #view$$ #view$
  #rstr
  #itm$
  #abcdItm$
  #pt$$
  #abcdPt$$
  #ang
  #dum$ #dum
  #tArea #AreaList  ;;  2005/11/30 G.YK ADD
  )
  (WebOutLog "Input.cfg の情報を元に自動で矢視を作成します")

  (if (= CG_SKViewList nil)
    (WebOutLog "Input.cfg にSK_VIEW セクションがありません")
  ;else
    (progn
      ;// なければ矢視の画層を作成する
      (MakeLayer CG_YASHI_LAYER       CG_YASHI_COL "CONTINUOUS")
      (MakeLayer CG_YASHI_PERS_LAYER  CG_YASHI_COL "CONTINUOUS")

      ;// なければ矢視領域の画層を作成する
      (MakeLayer CG_YASHI_AREA_LAYER           CG_YASHI_AREA_COL "CONTINUOUS")
      (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")

      (if (= (tblsearch "APPID" "RECT")     nil) (regapp "RECT"))
      (if (= (tblsearch "APPID" "RECTPERS") nil) (regapp "RECTPERS"))

;      (setq #pt (list 1250 -2000))
      (setq #rstr "")
      (foreach #dum$ CG_SKViewList
        (setq #itm$ nil)
        (foreach #dum #dum$
          (if (= #dum nil)
            (setq #itm$ (append #itm$ (list "")))
            (setq #itm$ (append #itm$ (list #dum)))
          )
        )
        (cond
          ;ABCD矢視の場合
          ((member (car #itm$) (list "A" "B" "C" "D"))
            (setq #abcdItm$ (append #abcdItm$ (list (car #itm$))))
          ;;  2005/11/30 G.YK ADD-S
            (setq #tArea (list
                  (list (atof (nth 1 #itm$)) (atof (nth 2 #itm$)))
                  (list (atof (nth 3 #itm$)) (atof (nth 4 #itm$)))
            ))
            (setq #AreaList (&NormYashi &cArea #tArea))
            (setq &cArea (car #AreaList))
            (setq #tArea (cadr #AreaList))
            (setq #abcdPt$$ (append #abcdPt$$ (list #tArea)))
          ;;  2005/11/30 G.YK ADD-E
          ;|  2005/11/30 G.YK DEL-S
            (setq #abcdPt$$ (append #abcdPt$$
                        (list (list
                          (list (atof (nth 1 #itm$)) (atof (nth 2 #itm$)))
                          (list (atof (nth 3 #itm$)) (atof (nth 4 #itm$)))
                        )))
            )
              2005/11/30 G.YK DEL-E |;
          )
          ;パース矢視の場合（なにもしない）
          ((= "P" (substr (car #itm$) 1 1))
            (princ)
          )
          ;矢視追加の場合
          (T
          ;;  2005/12/07 G.YK ADD-S
            (setq #tArea (list
                  (list (atof (nth 1 #itm$)) (atof (nth 2 #itm$)))
                  (list (atof (nth 3 #itm$)) (atof (nth 4 #itm$)))
            ))
            (setq #AreaList (&NormYashi &cArea #tArea))
            (setq &cArea (car #AreaList))
            (setq #tArea (cadr #AreaList))
            (setq #pt$$ (list #tArea))
          ;;  2005/12/07 G.YK ADD-E
          ;|  2005/12/07 G.YK DEL-S
            (setq #pt$$ (list (list
                          (list (atof (nth 1 #itm$)) (atof (nth 2 #itm$)))
                          (list (atof (nth 3 #itm$)) (atof (nth 4 #itm$)))
                        ))
            )
              2005/12/07 G.YK DEL-E |;
            (cond
              ((= (nth 5 #itm$) "A") (setq #ang "180"))
              ((= (nth 5 #itm$) "B") (setq #ang "270"))
              ((= (nth 5 #itm$) "C") (setq #ang "0"))
              ((= (nth 5 #itm$) "D") (setq #ang "90"))
            )
            (WebOutLog "矢視追加の作図")
            ;矢視追加と領域の作図
            (KCFMakeKSKViewYashi "RECT" (list (car #itm$)) (nth 5 #itm$) #pt$$ #ang)
          )
        )
      )
      ;ABCD矢視と領域の作図
      (WebOutLog "ABCD矢視の作図")

      (KCFMakeKSKViewYashi "RECT" #abcdItm$ (car #abcdItm$) #abcdPt$$ "90")
    )
  )
;|  2005/12/07 G.YK DEL-S
  (if CG_SKViewList
    T
  ;else
    nil
  )
  2005/12/07 G.YK DEL-S |;
  &cArea  ;;  2005/12/07 G.YK ADD
)
;KCFAutoMakeSKViewYashi

;;;<HOM>*************************************************************************
;;; <関数名>    : KCFAutoMakeSKViewYashiPers
;;; <処理概要>  : パース矢視の自動作図
;;; <戻り値>    :
;;;           T : 正常に矢視を作図した
;;;         nil : 矢視を作図していない
;;; <作成>      : 2004-09-29 SK
;;; <備考>      : Input.cfg の SK_VIEWセクションを元に矢視を自動作図する
;*************************************************************************>MOH<
(defun KCFAutoMakeSKViewYashiPers (
  &NormYashi &cArea ;;  2005/12/07 G.YK ADD
  /
  #rstr
  #itm$
  #pt$$
  #ang
  #dum$ #dum
  #tArea #AreaList  ;;  2005/12/07 G.YK ADD
  )
  (WebOutLog "Input.cfg の情報を元に自動で矢視を作成します")

  (if (= CG_SKViewList nil)
    (WebOutLog "Input.cfg にSK_VIEW セクションがありません")
  ;else
    (progn
      ;// なければ矢視の画層を作成する
      (MakeLayer CG_YASHI_LAYER       CG_YASHI_COL "CONTINUOUS")
      (MakeLayer CG_YASHI_PERS_LAYER  CG_YASHI_COL "CONTINUOUS")

      ;// なければ矢視領域の画層を作成する
      (MakeLayer CG_YASHI_AREA_LAYER           CG_YASHI_AREA_COL "CONTINUOUS")
      (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")


      (if (= (tblsearch "APPID" "RECT")     nil) (regapp "RECT"))
      (if (= (tblsearch "APPID" "RECTPERS") nil) (regapp "RECTPERS"))

      (setq #rstr "")
      (foreach #dum$ CG_SKViewList
        (setq #itm$ nil)
        (foreach #dum #dum$
          (if (= #dum nil)
            (setq #itm$ (append #itm$ (list "")))
            (setq #itm$ (append #itm$ (list #dum)))
          )
        )
        (cond
          ;パース矢視の場合
          ((= "P" (substr (car #itm$) 1 1))
          ;;  2005/12/07 G.YK ADD-S
            (if (and (/= (nth 6 #itm$) "")(/= (nth 7 #itm$) "")
                     (/= (nth 8 #itm$) "")(/= (nth 9 #itm$) ""))(progn
              (setq #tArea (list
                    (list (atof (nth 6 #itm$)) (atof (nth 7 #itm$)))
                    (list (atof (nth 8 #itm$)) (atof (nth 9 #itm$)))
              ))
              (setq #AreaList (&NormYashi &cArea #tArea))
              (setq &cArea (car #AreaList))
              (setq #tArea (cadr #AreaList))
              (setq #pt$$ (list #tArea))
            )(progn
              (setq #pt$$ (list (list
                            (list (atof (nth 6 #itm$)) (atof (nth 7 #itm$)))
                            (list (atof (nth 8 #itm$)) (atof (nth 9 #itm$)))
                          ))
              )
            ))
          ;;  2005/12/07 G.YK ADD-E
          ;|  2005/12/07 G.YK DEL-S
            (setq #pt$$ (list (list
                          (list (atof (nth 6 #itm$)) (atof (nth 7 #itm$)))
                          (list (atof (nth 8 #itm$)) (atof (nth 9 #itm$)))
                        ))
            )
              2005/12/07 G.YK DEL-E |;
            (WebOutLog "パース矢視の作図")
            ;矢視追加と領域の作図
            (KCFMakeKSKViewYashi "RECTPERS" (list (car #itm$)) "" #pt$$ (nth 10 #itm$))
          )
        )
      )
    )
  )
;|  2005/12/07 G.YK DEL-S
  (if CG_SKViewList
    T
  ;else
    nil
  )
  2005/12/07 G.YK DEL-E |;
  &cArea  ;;  2005/12/07 G.YK ADD
)
;KCFAutoMakeSKViewYashi

;;;<HOM>*************************************************************************
;;; <関数名>    : KCFMakeKSKViewYashi
;;; <処理概要>  : 矢視の自動作図
;;; <戻り値>    : なし
;;; <作成>      : 2004-09-29 SK
;;; <備考>      : なし
;*************************************************************************>MOH<
(defun KCFMakeKSKViewYashi (
  &appName    ;(STR) 設定アプリケーション名
  &yashiMrk$  ;(STR) 矢視記号リスト
  &baseMrk    ;(STR) 矢視基準記号
  &ptLst$      ;(LIST)矢視に対する領域の２点座標リスト
  &ang        ;(STR) 矢視の角度
  /
  #mrk
  #mrkStr
  #cLay
  #area
  #areaEn$
  #inspt
  #eNam
  #sArea
  #xd$
  #en
  #yashiEn
  #p1 #p2 #p3 #p4
  #pt #pt$
#CUT_BD #B_LIS$ #D_LIS$ #D_X_L #D_X_R ;2010/10/23 YM ADD
  )
  ;矢視記号の画層と矢視領域の画層を決定する
  (cond
    ((= &appName "RECT")
      (setq #mrkLay  CG_YASHI_LAYER)
      (setq #areaLay CG_YASHI_AREA_LAYER)
    )
    ((= &appName "RECTPERS")
      (setq #mrkLay  CG_YASHI_PERS_LAYER)
      (setq #areaLay CG_YASHI_PERS_HIDE_AREA_LAYER)
    )
  )

  ;現在画層を保存
  (setq #cLay (getvar "CLAYER"))

  (setq #mrkStr "")
  ;矢視記号を連結した文字列にする
  (foreach #mrk &yashiMrk$
    (setq #mrkStr (strcat #mrkStr #mrk))
  )
  ;点列を左下から右回りとする
  (setq #area (car &ptLst$))
  (setq #pt$ #area)
  (setq #pt$ (append #pt$ (list (list (car (car #area)) (cadr (cadr #area))))))
  (setq #pt$ (append #pt$ (list (list (car (cadr #area)) (cadr (car #area))))))
  (setq #p1 (list (apply 'min (mapcar 'car #pt$)) (apply 'min (mapcar 'cadr #pt$))))
  (setq #p2 (list (apply 'max (mapcar 'car #pt$)) (apply 'min (mapcar 'cadr #pt$))))
  (setq #p3 (list (apply 'max (mapcar 'car #pt$)) (apply 'max (mapcar 'cadr #pt$))))
  (setq #p4 (list (apply 'min (mapcar 'car #pt$)) (apply 'max (mapcar 'cadr #pt$))))

  ;矢視の配置位置を求める
  (cond
    ((= &baseMrk "A")
      (setq #pt (polar #p1 (angle #p1 #p2) (/ (distance #p1 #p2) 2.)))
    )
    ((= &baseMrk "B")
      (setq #pt (polar #p2 (angle #p2 #p3) (/ (distance #p2 #p3) 2.)))
    )
    ((= &baseMrk "C")
      (setq #pt (polar #p3 (angle #p3 #p4) (/ (distance #p3 #p4) 2.)))
    )
    ((= &baseMrk "D")
      (setq #pt (polar #p4 (angle #p4 #p1) (/ (distance #p4 #p1) 2.)))
    )
    ;パースの時
    (T
      (setq #pt (list 0 0))
    )
  )
  ;--------------------------------------------
  ;矢視記号の作図
  ;--------------------------------------------
  (SCFDrawYashi #mrkStr #pt &ang #mrkLay)
  (setq #yashiEn (entlast))

  ;現在画層を矢視領域画層とする
  (setvar "CLAYER" #areaLay)

  ;2010/10/23 YM ADD-S 【SK_2010/11月】宅建機能改善　周辺のみ
  (if (and (= CG_KITCHEN_SKIP "SK__Y")(= &baseMrk "A")(= (car &yashiMrk$) "A"))
    (progn
      ;D領域のX座標が小さい順ﾆｿｰﾄする
      (setq #D_lis$ (CFListSort (nth 2 &ptLst$) 0))

      ;D領域
      (setq #D_lis$
        (list
          (nth 0 #D_lis$);左側
          (list CG_SYUHEN_NOMI_D_CUT_X (nth 1 (nth 1 #D_lis$)));右側は、左端+900mm
        )
      )

      ;B領域のX座標が小さい順ﾆｿｰﾄする
      (setq #B_lis$ (CFListSort (nth 1 &ptLst$) 0))

      ;B領域
      (setq #B_lis$
        (list
          (list CG_SYUHEN_NOMI_B_CUT_X (nth 1 (nth 0 #B_lis$))) ;左側
          (nth 1 #B_lis$);右側
        )
      )

      (setq &ptLst$
        (list
          (nth 0 &ptLst$);A
          #B_lis$        ;B
          #D_lis$        ;D
          (nth 3 &ptLst$);C
        )
      )
    )
  );_if
  ;2010/10/23 YM ADD-E 【SK_2010/11月】宅建機能改善　周辺のみ

  ;--------------------------------------------
  ;矢視領域を作図
  ;--------------------------------------------
  (mapcar
    '(lambda ( #mrk #area )
;      (if (= nil (equal (car #area) (cadr #area)))
;        (progn
          (command "_.RECTANGLE" (car #area) (cadr #area))
          (setq #areaEn$ (append #areaEn$ (list (entlast))))

          ;矢視文字を作図する
          (setq #inspt (list (- (car (car #area)) 25) (- (cadr (car #area)) 25) 0.0))
          (setq #eNam (MakeText #mrk #inspt 100 2 3 "STANDARD"))
          (command "_.CHANGE" (entlast) "" "P" "LA" #areaLay "")

          ; 領域と名称をグループ化する
          (setq #sArea (strcat "Yashi" #mrk))
          (command "-group" "C" #sArea #sArea (last #areaEn$) #eNam "")
;        )
;      )
    )
    &yashiMrk$
    &ptLst$
  )
  ;--------------------------------------------
  ;矢視記号図形に拡張データを付加する
  ;--------------------------------------------
  (setq #xd$ (list "0" &ang #mrkStr))
  (foreach #en #areaEn$
    (setq #xd$ (append #xd$ (list (cdr (assoc 5 (entget #en))))))
  )
  (CFSetXData #yashiEn &appName #xd$)

  ;画層を元に戻す
  (setvar "CLAYER" #cLay)
)
;KCFMakeKSKViewYashi

;;;<HOM>*************************************************************************
;;; <関数名>    : KCFDeletePersYashi
;;; <処理概要>  : パース矢視と領域を削除する
;;; <戻り値>    : なし
;;; <作成>      : 2004-09-29 SK
;;; <備考>      : なし
;*************************************************************************>MOH<
(defun KCFDeletePersYashi (
  )
  (setq #ss$
    (list
      (ssget "X" (list (cons 8 CG_YASHI_PERS_LAYER)))
      (ssget "X" (list (cons 8 CG_YASHI_PERS_HIDE_AREA_LAYER)))
    )
  )
  (foreach #ss #ss$
    (command "_.ERASE" #ss "")
  )
)
;KCFDeletePersYashi

;;;<HOM>*************************************************************************
;;; <関数名>    : KCFMakeModelPersView
;;; <処理概要>  : パースビュー矢視とを作成する
;;; <戻り値>    : なし
;;; <作成>      : 2004-11-24 SK
;;; <備考>      : なし
;*************************************************************************>MOH<
(defun KCFMakeModelPersView (
  /
  #dum$ #dum
  #pName
  #itm$ #itm
  #p1 #p2
  #ang
  )
  (WebOutLog "パース矢視ビューの作成")

  (foreach #itm$ CG_SKViewList
    (cond
      ;パース矢視の場合
      ((= "P" (substr (car #itm$) 1 1))
        ;パースビューの名前
        (setq #pName (strcat CG_PERS_VIEW_HD (nth 0 #itm$)))
        (if (= (nth 10 #itm$) nil)
          (setq #ang 60.)
          (setq #ang (nth 10 #itm$))
        )
        ;角度の設定
        (setq #p1 (list 0 0 0))
        (setq #p2 (polar #p1 (dtr (atoi #ang)) 100))
        (setq #p2 (list (car #p2) (cadr #p2) -50))
        (command "_.VPOINT" "0,0,1")

        (command "_.ZOOM" "E")
        (command "_.ZOOM" "0.1X")
        (command "_.DVIEW" "ALL" "" "PO" #p2 #p1 "X")
        (command "_.ZOOM" "E")

        ;ビューの作成
        (command "_.VIEW" "S" #pName)
      )
    )
  )
  (command "_.VPOINT" "0,0,1")
)
;KCFMakeModelPersView
