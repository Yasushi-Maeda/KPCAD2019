
;;; 2011/10/05YM@MOD;<HOM>*************************************************************************
;;; 2011/10/05YM@MOD; <関数名>    : C:SCFDelYashi
;;; 2011/10/05YM@MOD; <処理概要>  : 矢視設定解除コマンド
;;; 2011/10/05YM@MOD; <戻り値>    : なし
;;; 2011/10/05YM@MOD; <作成>      : 1999-06-17
;;; 2011/10/05YM@MOD; <備考>      : なし
;;; 2011/10/05YM@MOD;*************************************************************************>MOH<
;;; 2011/10/05YM@MOD(defun C:SCFDelYashi (
;;; 2011/10/05YM@MOD  /
;;; 2011/10/05YM@MOD  #xSp #En$ #i #find #Gen$
;;; 2011/10/05YM@MOD	#Ed$
;;; 2011/10/05YM@MOD  )
;;; 2011/10/05YM@MOD  ; 2000/10/06 HT E方向矢視対応に伴い 矢視が複数となるため手動選択とした
;;; 2011/10/05YM@MOD	(SCFStartShori "C:SCFDelYashi")  
;;; 2011/10/05YM@MOD	(StartUndoErr)
;;; 2011/10/05YM@MOD	(setq #xSp (ssget "X" (list (list -3 (list "RECT")))))
;;; 2011/10/05YM@MOD	(if #xSp
;;; 2011/10/05YM@MOD		(progn
;;; 2011/10/05YM@MOD			(setq #En$ T)
;;; 2011/10/05YM@MOD			; 削除矢視選択
;;; 2011/10/05YM@MOD			; 01/05/07 TM ADD 複数回削除可能とした
;;; 2011/10/05YM@MOD			(while (and (setq #xSp (ssget "X" (list (list -3 (list "RECT"))))) (/= nil #En$))
;;; 2011/10/05YM@MOD				(setq #En$ (SKGetPtByEn "削除する矢視を選択してください." "*INSERT*" "矢視" nil))
;;; 2011/10/05YM@MOD				(if (/= nil #En$)
;;; 2011/10/05YM@MOD					(progn
;;; 2011/10/05YM@MOD						(KCFDeleteYashi (caar #En$))
;;; 2011/10/05YM@MOD						; 01/05/07 TM ADD 複数回削除可能とした
;;; 2011/10/05YM@MOD						; (setq #En$ nil)
;;; 2011/10/05YM@MOD					)
;;; 2011/10/05YM@MOD				)
;;; 2011/10/05YM@MOD			)
;;; 2011/10/05YM@MOD    )
;;; 2011/10/05YM@MOD    (CFAlertMsg "矢視は設定されていません")
;;; 2011/10/05YM@MOD  )
;;; 2011/10/05YM@MOD
;;; 2011/10/05YM@MOD  ; 終了処理  2000/09/07 HT
;;; 2011/10/05YM@MOD  (SCFEndShori)
;;; 2011/10/05YM@MOD  (princ)
;;; 2011/10/05YM@MOD
;;; 2011/10/05YM@MOD) ; C:SCFDelYashi

;<HOM>*************************************************************************
; <関数名>    : C:SCFDelYashi
; <処理概要>  : 矢視設定解除コマンド
; <戻り値>    : なし
; <作成>      : 1999-06-17
; <備考>      : なし
;*************************************************************************>MOH<
(defun C:SCFDelYashi (
  /
  #xSp #En$ #i #find #Gen$
	#Ed$
  )
  ; 2000/10/06 HT E方向矢視対応に伴い 矢視が複数となるため手動選択とした
	(SCFStartShori "C:SCFDelYashi")
	(StartUndoErr)

;;	(setq #xSp (ssget "X" (list (list -3 (list "RECT")))))	;;	2005/12/27 G.YK DEL
;;	2005/12/27 G.YK ADD-S
	(setq #xSp (ssget "X" (list (list -3 (list "RECT")))))
	(if (not #xSp)(setq #xSp (ssget "X" (list (list -3 (list "RECTPERS"))))))
;;	2005/12/27 G.YK ADD-E
	(if #xSp
		(progn
			(setq #En$ T)
			; 削除矢視選択
			; 01/05/07 TM ADD 複数回削除可能とした
		;;	(while (and (setq #xSp (ssget "X" (list (list -3 (list "RECT"))))) (/= nil #En$))	;;	2005/12/27 G.YK DEL
		;;	2005/12/27 G.YK ADD-S
			(while (or	(and (setq #xSp (ssget "X" (list (list -3 (list "RECT"))))) (/= nil #En$))
						(and (setq #xSp (ssget "X" (list (list -3 (list "RECTPERS"))))) (/= nil #En$))
					)
		;;	2005/12/27 G.YK ADD-E
				(setq #En$ (SKGetPtByEn "削除する矢視を選択してください." "*INSERT*" "矢視" nil))
				(if (/= nil #En$)
					(progn
						(KCFDeleteYashi (caar #En$))
					)
				)
			)
    )
    (CFAlertMsg "矢視は設定されていません")
  )

  ; 終了処理  2000/09/07 HT
  (SCFEndShori)
  (princ "\n終了")
  (princ)

) ; C:SCFDelYashi

(princ)
