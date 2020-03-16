(setq CG_SUBPARTS "HOSOKU")   ; �⑫���ޗp�g�����R�[�h�̃L�[��

(defun C:SubParts () (SKH_HosokuBuzai))

;<HOM>*************************************************************************
; <�֐���>     : SKH_HosokuBuzaiCnvList1
; <�����T�v>   : �⑫���� ���R�[�h�f�[�^ �ϊ�(��d���P��)
; <�߂�l>     : �P�ꃊ�X�g
; <�쐬>       : 1999-11-25  �R�c
; <���l>       :
;*************************************************************************>MOH<
(defun SKH_HosokuBuzaiCnvList1 (
    &lst$$    ; ��d���X�g
    /
    #Result$
    #nn$
  )
  (setq #Result$ nil)
  (foreach #nn$ &lst$$
    (setq #Result$ (append #Result$ #nn$))
  )
  #Result$
)

;<HOM>*************************************************************************
; <�֐���>     : SKH_HosokuBuzaiCnvList2
; <�����T�v>   : �⑫���� ���R�[�h�f�[�^ �ϊ�(�P�ꁨ��d)
; <�߂�l>     : ��d���X�g
; <�쐬>       : 1999-11-25  �R�c
; <���l>       :
;*************************************************************************>MOH<
(defun SKH_HosokuBuzaiCnvList2 (
    &lst$   ; �P�ꃊ�X�g
    /
    #Result$$
    #nn$
    #Len
    #i
  )
  (setq #Result$$ nil)
  (setq #Len (length &lst$))
  (setq #i 0)
  (while (< #i #Len)
    (setq #nn$ (list (nth #i &lst$) (nth (+ #i 1) &lst$)))
    (setq #Result$$ (append #Result$$ (list #nn$)))
    (setq #i (+ #i 2))
  )
  #Result$$
)

;<HOM>*************************************************************************
; <�֐���>     : SKH_HosokuBuzai
; <�����T�v>   : �⑫���� ���́E�m�F
; <�߂�l>     :
; <�쐬>       : 1999-11-25  �R�c (1999-12-08 �_�C�A���O DLL���ɂ��C��)
; <���l>       :
;*************************************************************************>MOH<
(defun SKH_HosokuBuzai (
    /
    #XRecord$$
    #nn$
    #s #ss #name #value
    #f
    #i
    #loop
  )

	; 01/09/03 YM ADD-S UNDO�����ǉ�
	; �O����
	(StartUndoErr)
	; 01/09/03 YM ADD-E UNDO�����ǉ�

;;;01/09/03YM@MOD  (StartCmnErr)

  (setq #XRecord$$ (SKH_HosokuBuzaiCnvList2 (CFGetXRecord CG_SUBPARTS)))
  (setq #f (open ".\XRecord.cfg" "w"))
  (if (/= nil #f)
    (progn
      (write-line ";-----------------------------------------------------------------------" #f)
      (write-line "; �⑫���� �g�����R�[�h" #f)
      (write-line ";" #f)
      (write-line "; <�i��>=<��>" #f)
      (write-line ";-----------------------------------------------------------------------" #f)
      (foreach #nn$ #XRecord$$
        (setq #s (strcat (nth 0 #nn$) "=" (nth 1 #nn$)))
        (write-line #s #f)
      )
      (close #f)
    )
  )

  ;00/10/10 HN E-MOD ���W���[���Ăяo�����@�ύX
  ;@@@(C:arxStartApp (strcat CG_SysPATH "HOSOKU.EXE") 1)
  (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 3") 0)
  ;00/10/10 HN E-MOD ���W���[���Ăяo�����@�ύX

  (setq #f (open ".\XRecord.cfg" "r"))
  (if (/= nil #f)
    (progn
      (setq #XRecord$$ nil)
      (setq #loop T)
      (while #loop
        (setq #s (read-line #f))
        (if (= nil #s) (setq #loop nil)
          (if (wcmatch #s "?*=?*")
            (progn
              (setq #i 2)
              (while (<= #i (strlen #s))
                (setq #name nil #value nil)
                (setq #ss (substr #s #i 1))
                (if (= #ss "=")
                  (progn
                    (setq #name (substr #s 1 (1- #i)))
                    (setq #value (substr #s (1+ #i) (strlen #s)))
                  )
                  (setq #i (1+ #i))
                )
                (if (and (/= #name nil) (/= #value nil))
                  (setq #i (1+ (strlen #s)))
                )
              )
              (setq #XRecord$$ (append #XRecord$$ (list (list #name #value))))
            )
          )
        )
      )
    )
    (close #f)
  )

  (CFSetXRecord CG_SUBPARTS (SKH_HosokuBuzaiCnvList1 #XRecord$$))

	; 01/09/03 YM ADD-S UNDO�����ǉ�
	; �㏈��
  (setq *error* nil)
	; 01/09/03 YM ADD-E UNDO�����ǉ�

  (princ)
)

(princ)