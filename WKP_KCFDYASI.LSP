
;;; 2011/10/05YM@MOD;<HOM>*************************************************************************
;;; 2011/10/05YM@MOD; <�֐���>    : C:SCFDelYashi
;;; 2011/10/05YM@MOD; <�����T�v>  : ��ݒ�����R�}���h
;;; 2011/10/05YM@MOD; <�߂�l>    : �Ȃ�
;;; 2011/10/05YM@MOD; <�쐬>      : 1999-06-17
;;; 2011/10/05YM@MOD; <���l>      : �Ȃ�
;;; 2011/10/05YM@MOD;*************************************************************************>MOH<
;;; 2011/10/05YM@MOD(defun C:SCFDelYashi (
;;; 2011/10/05YM@MOD  /
;;; 2011/10/05YM@MOD  #xSp #En$ #i #find #Gen$
;;; 2011/10/05YM@MOD	#Ed$
;;; 2011/10/05YM@MOD  )
;;; 2011/10/05YM@MOD  ; 2000/10/06 HT E������Ή��ɔ��� ��������ƂȂ邽�ߎ蓮�I���Ƃ���
;;; 2011/10/05YM@MOD	(SCFStartShori "C:SCFDelYashi")  
;;; 2011/10/05YM@MOD	(StartUndoErr)
;;; 2011/10/05YM@MOD	(setq #xSp (ssget "X" (list (list -3 (list "RECT")))))
;;; 2011/10/05YM@MOD	(if #xSp
;;; 2011/10/05YM@MOD		(progn
;;; 2011/10/05YM@MOD			(setq #En$ T)
;;; 2011/10/05YM@MOD			; �폜��I��
;;; 2011/10/05YM@MOD			; 01/05/07 TM ADD ������폜�\�Ƃ���
;;; 2011/10/05YM@MOD			(while (and (setq #xSp (ssget "X" (list (list -3 (list "RECT"))))) (/= nil #En$))
;;; 2011/10/05YM@MOD				(setq #En$ (SKGetPtByEn "�폜������I�����Ă�������." "*INSERT*" "�" nil))
;;; 2011/10/05YM@MOD				(if (/= nil #En$)
;;; 2011/10/05YM@MOD					(progn
;;; 2011/10/05YM@MOD						(KCFDeleteYashi (caar #En$))
;;; 2011/10/05YM@MOD						; 01/05/07 TM ADD ������폜�\�Ƃ���
;;; 2011/10/05YM@MOD						; (setq #En$ nil)
;;; 2011/10/05YM@MOD					)
;;; 2011/10/05YM@MOD				)
;;; 2011/10/05YM@MOD			)
;;; 2011/10/05YM@MOD    )
;;; 2011/10/05YM@MOD    (CFAlertMsg "��͐ݒ肳��Ă��܂���")
;;; 2011/10/05YM@MOD  )
;;; 2011/10/05YM@MOD
;;; 2011/10/05YM@MOD  ; �I������  2000/09/07 HT
;;; 2011/10/05YM@MOD  (SCFEndShori)
;;; 2011/10/05YM@MOD  (princ)
;;; 2011/10/05YM@MOD
;;; 2011/10/05YM@MOD) ; C:SCFDelYashi

;<HOM>*************************************************************************
; <�֐���>    : C:SCFDelYashi
; <�����T�v>  : ��ݒ�����R�}���h
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-17
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun C:SCFDelYashi (
  /
  #xSp #En$ #i #find #Gen$
	#Ed$
  )
  ; 2000/10/06 HT E������Ή��ɔ��� ��������ƂȂ邽�ߎ蓮�I���Ƃ���
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
			; �폜��I��
			; 01/05/07 TM ADD ������폜�\�Ƃ���
		;;	(while (and (setq #xSp (ssget "X" (list (list -3 (list "RECT"))))) (/= nil #En$))	;;	2005/12/27 G.YK DEL
		;;	2005/12/27 G.YK ADD-S
			(while (or	(and (setq #xSp (ssget "X" (list (list -3 (list "RECT"))))) (/= nil #En$))
						(and (setq #xSp (ssget "X" (list (list -3 (list "RECTPERS"))))) (/= nil #En$))
					)
		;;	2005/12/27 G.YK ADD-E
				(setq #En$ (SKGetPtByEn "�폜������I�����Ă�������." "*INSERT*" "�" nil))
				(if (/= nil #En$)
					(progn
						(KCFDeleteYashi (caar #En$))
					)
				)
			)
    )
    (CFAlertMsg "��͐ݒ肳��Ă��܂���")
  )

  ; �I������  2000/09/07 HT
  (SCFEndShori)
  (princ "\n�I��")
  (princ)

) ; C:SCFDelYashi

(princ)