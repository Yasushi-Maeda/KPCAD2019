;矢視追加の種類
(setq CG_ADDYASHI_LIST (list "E" "F" "G" "H" "I" "J"))

;;;<HOM>************************************************************************
;;; <関数名>  : C:SCFSetYashiE
;;; <処理概要>: 矢視E設定
;;; <戻り値>  : なし
;;; <作成>    : 2000-10-06
;;; <改訂>    : 2001-04-17 HN 領域設定を追加
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun C:SCFSetYashiE (
  /
  #sCECOLOR     ; 現在の図形の色番号
  #sPLineWid    ; 現在のポリラインの幅
  #xSp          ; 既存チェック用
  #nYesNo       ; 既存チェック用
  #sYashi       ; 設定する矢視
  #eYen         ; 矢視領域図形
;-- 2011/09/26 A.Satoh Add - S
  #iOrthomode
;-- 2011/09/26 A.Satoh Add - E
  )
  (SCFStartShori "SCFSetYashiE")
  (StartUndoErr)

  ; 図形色番号／ポリライン線幅の退避
  (setq #rPLineWid (getvar "PLINEWID"))
  (setq #sCECOLOR (getvar "CECOLOR"))
;-- 2011/09/26 A.Satoh Add - S
  (setq #iOrthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)
;-- 2011/09/26 A.Satoh Add - E

	;真上からのﾋﾞｭｰにする 2011/09/26 YM ADD-S
  ;// ビューを登録
  (command "_view" "S" "TEMP_SYE")
	(command "_.VPOINT" "0,0,1")
	;2011/09/26 YM ADD-E

  ; 01/05/10 TM DEL 色・ライン幅の変更をＡＢＣＤ矢視に合わせる
  ;(setvar "CECOLOR" "60")
  (setvar "PLINEWID" 0.0)
  (setvar "CLAYER" "0")

  ; ピック形式の変更？
  (setvar "PICKSTYLE" 3)

;2011/07/15 YM MOD-S 矢視を"J"まで追加できるようにする。同時にCG用のﾊﾟｰｽ向き指定も行う(P1,P2)

;;;  ; 作成済み矢視図形を取得
;;;  (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))

;;;  ; E方向矢視があるか
;;;  (if (setq #xSp (SCFIsYashiType #xSp "*E*"))
;;;   ; 既にある場合は追加するか、作り直すかをたずねる
;;;   (progn
;;;     (setq #nYesNo (CFYesNoCancelDialog "既に矢視Eは設定されています。\n矢視Fとして追加しますか?"))
;;;     (cond 
;;;       ((= IDYES #nYesNo)
;;;         (setq #sYashi "F")
;;;       )
;;;       ((= IDNO #nYesNo)
;;;         (setq #sYashi "E")
;;;       )
;;;       (t nil)
;;;     )
;;;    )
;;;   (setq #sYashi "E")
;;;  )      

  ;配置する矢視を選択する
  (setq #sYashi (SCFSelAddYasiDlg))

;2011/07/15 YM MOD-E

  (if #sYashi
    (progn
      ; 矢視を追加
      (SCFSetAddYashi #sYashi T)
    )
  )

  ; 図形色番号／ポリライン線幅の復活
  (setvar "CECOLOR" #sCECOLOR)
  (setvar "PLINEWID" #rPLineWid)
;-- 2011/09/26 A.Satoh Add - S
  (setvar "ORTHOMODE" #iOrthomode)
;-- 2011/09/26 A.Satoh Add - E

  ;// ビューを戻す 2011/09/26 YM ADD-S
  (command "_view" "R" "TEMP_SYE")
	;2011/09/26 YM ADD-E

  ; 終了処理 2000/09/07 HT
  (SCFEndShori)

  (princ "\n終了")
  (princ)
) ; C:SCFSetYashiE

;;;<HOM>************************************************************************
;;; <関数名>  : C:SCFSetYashiF
;;; <処理概要>: 矢視F設定
;;; <戻り値>  : なし
;;; <作成>    : 01/05/25 TM C:SCFSetYashiE からコピー＆変更
;;; <備考>    : てすと用
;;;************************************************************************>MOH<
(defun C:SCFSetYashiF (
  /
  )
  (SCFStartShori "SCFSetYashiF")
  (StartUndoErr)
  
  (SCFSetAddYashi "F" T)

  (SCFEndShori)

  (princ)
) ; C:SCFSetYashiF

;;;<HOM>************************************************************************
;;; <関数名>  : SCFSetAddYashi
;;; <処理概要>: 追加矢視設定(矢視名／チェック有無指定)
;;; <戻り値>  : なし
;;; <作成>    : 01/05.25 TM 
;;; <備考>    : 追加矢視は１つで１方向のみを指定する
;;;************************************************************************>MOH<
(defun SCFSetAddYashi (
  &sYashi     ; 追加する矢視の名前
  &ChkExist   ; 既存の矢視をチェックするか否か(T=する,nil=無条件に旧矢視を削除)
  /
  #sCECOLOR     ; 現在の図形の色番号
  #sPLineWid    ; 現在のポリラインの幅
  #xSp
  #iI
  #ed$
  #flg
  #Ed$
  #dY
  #iOrthomode
  #dA
  #sAng
  #eYen
  #eEn
  #en
  )
  (SCFStartShori "SCFSetAddYashi")
  (StartUndoErr)

  ; 図形色番号／ポリライン線幅の退避
  (setq #rPLineWid (getvar "PLINEWID"))
  (setq #sCECOLOR (getvar "CECOLOR"))
;-- 2011/09/26 A.Satoh Add - S
  (setq #iOrthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)
;-- 2011/09/26 A.Satoh Add - E
  ; 01/05/10 TM DEL 色・ライン幅の変更をＡＢＣＤ矢視に合わせる
  ;(setvar "CECOLOR" "60")
  (setvar "PLINEWID" 0.0)

  ; ピック形式の変更？
  (setvar "PICKSTYLE" 3)

  ; 作成済み矢視図形を取得
  (setq #xSp (ssget "X" (list (list -3 (list "RECT,RECTPERS")))))

  ; 指定方向の矢視があるかのチェック
  (if &ChkExist
    (if (setq #xSp (SCFIsYashiType #xSp (strcat "*" &sYashi "*")))
      (if (CFYesNoDialog (strcat "既に矢視" &sYashi "は設定されています。\n削除しますか?"))
        (progn
          (KCFDeleteYashi (ssname #xSp 0))
        )
        (quit)
      )
    )
    (if (setq #xSp (SCFIsYashiType #xSp (strcat "*" &sYashi "*")))
      (KCFDeleteYashi (ssname #xSp 0))
    )
  )

  ; 矢視領域の設定
  (if (member &sYashi (list "P1" "P2" "P3"))
    (setq #eYen (KCFPlaceYashiPers (list 0 &sYashi &sYashi)))
    (setq #eYen (KCFPlaceYashi (list 0 &sYashi &sYashi)))
  )
  ; 図形色番号／ポリライン線幅の復活
  (setvar "CECOLOR" #sCECOLOR)
  (setvar "PLINEWID" #rPLineWid)
;-- 2011/09/26 A.Satoh Add - S
  (setvar "ORTHOMODE" #iOrthomode)
;-- 2011/09/26 A.Satoh Add - E

  ; 終了処理 2000/09/07 HT
  (SCFEndShori)

  (princ)
) ; SCFSetAddYashi


;;;<HOM>************************************************************************
;;; <関数名>  : SCFIsYashiType
;;; <処理概要>: 既存矢視の有無判定
;;; <戻り値>  : 既存矢視選択セット なし : nil
;;; <作成>    : 2000-10-06 HT
;;; <改訂>    : 2001-04-17 HN 全面改訂
;;; <備考>    : ABCD矢視 と "E"矢視
;;;************************************************************************>MOH<
(defun SCFIsYashiType
  (
  &xYashi     ; 矢視の選択セット
  &sYashi     ; 矢視文字列  "E", "*[ABCD]*"
  /
  #iCnt       ; カウンタ
  #eYashi     ; 矢視の図形名
  #ed$        ; 矢視の拡張データ
  #xYashi     ; 矢視の選択セット(戻り値)
  )
  (setq #xYashi (ssadd))
  (setq #iCnt   0)

  (if &xYashi
    (repeat (sslength &xYashi)
      (setq #eYashi (ssname &xYashi #iCnt))
      (setq #ed$ (CfGetXData #eYashi "RECT"))
      (if (and #ed$ (wcmatch (nth 2 #ed$) &sYashi))
        (setq #xYashi (ssadd #eYashi #xYashi))
        (progn
          (setq #ed$ (CfGetXData #eYashi "RECTPERS"))
          (if (and #ed$ (wcmatch (nth 2 #ed$) &sYashi))
            (setq #xYashi (ssadd #eYashi #xYashi))
          )
        )
      )
      (setq #iCnt (1+ #iCnt))
    )
  )

  (if (< 0 (sslength #xYashi))
    #xYashi
    nil
  )
) ;_SCFIsYashiType

;;;<HOM>************************************************************************
;;; <関数名>  : SCFSelAddYasiDlg
;;; <処理概要>: ユーザーに矢視追加記号を選択させる
;;; <戻り値>  :
;;;       STR : 選択された矢視記号("E" ～ "J")
;;;       nil : キャンセルおよび無選択
;;; <作成日>  : 04/09/13 SK
;;; <備考>    :
;;;************************************************************************>MOH<
(defun SCFSelAddYasiDlg (
  /
  #dcl_id
  #ss
  #en
  #mrk #mrk$
  )
  ; ラジオボタン オン の項目のファイル名を返す
  (defun #GetRes ( / )
    (cond
      ((= "1" (get_tile "E")) "E")
      ((= "1" (get_tile "F")) "F")
      ((= "1" (get_tile "G")) "G")
      ((= "1" (get_tile "H")) "H")
      ((= "1" (get_tile "I")) "I")
      ((= "1" (get_tile "J")) "J")
      ((= "1" (get_tile "P1")) "P1")
      ((= "1" (get_tile "P2")) "P2")
;;;     ((= "1" (get_tile "P3")) "P3")
      ; ボタンが未選択ならメッセージを表示
      (t (CFAlertMsg "項目を選択してください.") nil)
    ); cond
  ); #GetRes

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "CSFsy.DCL")))
  (if (not (new_dialog "SelAddYasiDlg" #dcl_id)) (exit))

  ;矢視追加の既配置のものを検索する
  (setq #ss (ssget "X" '((-3 ("RECT")))))
  (foreach #en (Ss2En$ #ss)
    (setq #mrk (nth 2 (CFGetXData #en "RECT")))
    (if (member #mrk CG_ADDYASHI_LIST)
      (mode_tile #mrk 1)
    )
  )
  ;パース矢視追加の既配置のものを検索する
  (setq #ss (ssget "X" '((-3 ("RECTPERS")))))
  (foreach #en (Ss2En$ #ss)
    (setq #mrk (nth 2 (CFGetXData #en "RECTPERS")))
;;;    (if (member #mrk (list "P1" "P2" "P3"))
    (if (member #mrk (list "P1" "P2"))
      (mode_tile #mrk 1)
    )
  )

  ; タイル作動設定
  (action_tile "accept" "(if (setq #mrk (#GetRes)) (done_dialog))")
  (action_tile "cancel" "(setq #mrk nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)

  ;戻り値
  #mrk
)
;SCFSelAddYasiDlg

;;;END OF FILE
