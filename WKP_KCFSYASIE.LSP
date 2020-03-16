;��ǉ��̎��
(setq CG_ADDYASHI_LIST (list "E" "F" "G" "H" "I" "J"))

;;;<HOM>************************************************************************
;;; <�֐���>  : C:SCFSetYashiE
;;; <�����T�v>: �E�ݒ�
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 2000-10-06
;;; <����>    : 2001-04-17 HN �̈�ݒ��ǉ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun C:SCFSetYashiE (
  /
  #sCECOLOR     ; ���݂̐}�`�̐F�ԍ�
  #sPLineWid    ; ���݂̃|�����C���̕�
  #xSp          ; �����`�F�b�N�p
  #nYesNo       ; �����`�F�b�N�p
  #sYashi       ; �ݒ肷��
  #eYen         ; ��̈�}�`
;-- 2011/09/26 A.Satoh Add - S
  #iOrthomode
;-- 2011/09/26 A.Satoh Add - E
  )
  (SCFStartShori "SCFSetYashiE")
  (StartUndoErr)

  ; �}�`�F�ԍ��^�|�����C�������̑ޔ�
  (setq #rPLineWid (getvar "PLINEWID"))
  (setq #sCECOLOR (getvar "CECOLOR"))
;-- 2011/09/26 A.Satoh Add - S
  (setq #iOrthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)
;-- 2011/09/26 A.Satoh Add - E

	;�^�ォ����ޭ��ɂ��� 2011/09/26 YM ADD-S
  ;// �r���[��o�^
  (command "_view" "S" "TEMP_SYE")
	(command "_.VPOINT" "0,0,1")
	;2011/09/26 YM ADD-E

  ; 01/05/10 TM DEL �F�E���C�����̕ύX���`�a�b�c��ɍ��킹��
  ;(setvar "CECOLOR" "60")
  (setvar "PLINEWID" 0.0)
  (setvar "CLAYER" "0")

  ; �s�b�N�`���̕ύX�H
  (setvar "PICKSTYLE" 3)

;2011/07/15 YM MOD-S ���"J"�܂Œǉ��ł���悤�ɂ���B������CG�p���߰������w����s��(P1,P2)

;;;  ; �쐬�ςݖ�}�`���擾
;;;  (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))

;;;  ; E����������邩
;;;  (if (setq #xSp (SCFIsYashiType #xSp "*E*"))
;;;   ; ���ɂ���ꍇ�͒ǉ����邩�A��蒼�����������˂�
;;;   (progn
;;;     (setq #nYesNo (CFYesNoCancelDialog "���ɖE�͐ݒ肳��Ă��܂��B\n�F�Ƃ��Ēǉ����܂���?"))
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

  ;�z�u������I������
  (setq #sYashi (SCFSelAddYasiDlg))

;2011/07/15 YM MOD-E

  (if #sYashi
    (progn
      ; ���ǉ�
      (SCFSetAddYashi #sYashi T)
    )
  )

  ; �}�`�F�ԍ��^�|�����C�������̕���
  (setvar "CECOLOR" #sCECOLOR)
  (setvar "PLINEWID" #rPLineWid)
;-- 2011/09/26 A.Satoh Add - S
  (setvar "ORTHOMODE" #iOrthomode)
;-- 2011/09/26 A.Satoh Add - E

  ;// �r���[��߂� 2011/09/26 YM ADD-S
  (command "_view" "R" "TEMP_SYE")
	;2011/09/26 YM ADD-E

  ; �I������ 2000/09/07 HT
  (SCFEndShori)

  (princ "\n�I��")
  (princ)
) ; C:SCFSetYashiE

;;;<HOM>************************************************************************
;;; <�֐���>  : C:SCFSetYashiF
;;; <�����T�v>: �F�ݒ�
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 01/05/25 TM C:SCFSetYashiE ����R�s�[���ύX
;;; <���l>    : �Ă��Ɨp
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
;;; <�֐���>  : SCFSetAddYashi
;;; <�����T�v>: �ǉ���ݒ�(����^�`�F�b�N�L���w��)
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 01/05.25 TM 
;;; <���l>    : �ǉ���͂P�łP�����݂̂��w�肷��
;;;************************************************************************>MOH<
(defun SCFSetAddYashi (
  &sYashi     ; �ǉ������̖��O
  &ChkExist   ; �����̖���`�F�b�N���邩�ۂ�(T=����,nil=�������ɋ�����폜)
  /
  #sCECOLOR     ; ���݂̐}�`�̐F�ԍ�
  #sPLineWid    ; ���݂̃|�����C���̕�
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

  ; �}�`�F�ԍ��^�|�����C�������̑ޔ�
  (setq #rPLineWid (getvar "PLINEWID"))
  (setq #sCECOLOR (getvar "CECOLOR"))
;-- 2011/09/26 A.Satoh Add - S
  (setq #iOrthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)
;-- 2011/09/26 A.Satoh Add - E
  ; 01/05/10 TM DEL �F�E���C�����̕ύX���`�a�b�c��ɍ��킹��
  ;(setvar "CECOLOR" "60")
  (setvar "PLINEWID" 0.0)

  ; �s�b�N�`���̕ύX�H
  (setvar "PICKSTYLE" 3)

  ; �쐬�ςݖ�}�`���擾
  (setq #xSp (ssget "X" (list (list -3 (list "RECT,RECTPERS")))))

  ; �w������̖�����邩�̃`�F�b�N
  (if &ChkExist
    (if (setq #xSp (SCFIsYashiType #xSp (strcat "*" &sYashi "*")))
      (if (CFYesNoDialog (strcat "���ɖ" &sYashi "�͐ݒ肳��Ă��܂��B\n�폜���܂���?"))
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

  ; ��̈�̐ݒ�
  (if (member &sYashi (list "P1" "P2" "P3"))
    (setq #eYen (KCFPlaceYashiPers (list 0 &sYashi &sYashi)))
    (setq #eYen (KCFPlaceYashi (list 0 &sYashi &sYashi)))
  )
  ; �}�`�F�ԍ��^�|�����C�������̕���
  (setvar "CECOLOR" #sCECOLOR)
  (setvar "PLINEWID" #rPLineWid)
;-- 2011/09/26 A.Satoh Add - S
  (setvar "ORTHOMODE" #iOrthomode)
;-- 2011/09/26 A.Satoh Add - E

  ; �I������ 2000/09/07 HT
  (SCFEndShori)

  (princ)
) ; SCFSetAddYashi


;;;<HOM>************************************************************************
;;; <�֐���>  : SCFIsYashiType
;;; <�����T�v>: ������̗L������
;;; <�߂�l>  : ������I���Z�b�g �Ȃ� : nil
;;; <�쐬>    : 2000-10-06 HT
;;; <����>    : 2001-04-17 HN �S�ʉ���
;;; <���l>    : ABCD� �� "E"�
;;;************************************************************************>MOH<
(defun SCFIsYashiType
  (
  &xYashi     ; ��̑I���Z�b�g
  &sYashi     ; �������  "E", "*[ABCD]*"
  /
  #iCnt       ; �J�E���^
  #eYashi     ; ��̐}�`��
  #ed$        ; ��̊g���f�[�^
  #xYashi     ; ��̑I���Z�b�g(�߂�l)
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
;;; <�֐���>  : SCFSelAddYasiDlg
;;; <�����T�v>: ���[�U�[�ɖ�ǉ��L����I��������
;;; <�߂�l>  :
;;;       STR : �I�����ꂽ��L��("E" �` "J")
;;;       nil : �L�����Z������і��I��
;;; <�쐬��>  : 04/09/13 SK
;;; <���l>    :
;;;************************************************************************>MOH<
(defun SCFSelAddYasiDlg (
  /
  #dcl_id
  #ss
  #en
  #mrk #mrk$
  )
  ; ���W�I�{�^�� �I�� �̍��ڂ̃t�@�C������Ԃ�
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
      ; �{�^�������I���Ȃ烁�b�Z�[�W��\��
      (t (CFAlertMsg "���ڂ�I�����Ă�������.") nil)
    ); cond
  ); #GetRes

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "CSFsy.DCL")))
  (if (not (new_dialog "SelAddYasiDlg" #dcl_id)) (exit))

  ;��ǉ��̊��z�u�̂��̂���������
  (setq #ss (ssget "X" '((-3 ("RECT")))))
  (foreach #en (Ss2En$ #ss)
    (setq #mrk (nth 2 (CFGetXData #en "RECT")))
    (if (member #mrk CG_ADDYASHI_LIST)
      (mode_tile #mrk 1)
    )
  )
  ;�p�[�X��ǉ��̊��z�u�̂��̂���������
  (setq #ss (ssget "X" '((-3 ("RECTPERS")))))
  (foreach #en (Ss2En$ #ss)
    (setq #mrk (nth 2 (CFGetXData #en "RECTPERS")))
;;;    (if (member #mrk (list "P1" "P2" "P3"))
    (if (member #mrk (list "P1" "P2"))
      (mode_tile #mrk 1)
    )
  )

  ; �^�C���쓮�ݒ�
  (action_tile "accept" "(if (setq #mrk (#GetRes)) (done_dialog))")
  (action_tile "cancel" "(setq #mrk nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)

  ;�߂�l
  #mrk
)
;SCFSelAddYasiDlg

;;;END OF FILE