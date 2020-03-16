;<HOM>*************************************************************************
; <�֐���>    : C:SCFDanMen
; <�����T�v>  : �f�ʎw���^����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999/06/17 �� 01/04/18 MH �S�ʏ���
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun C:SCFDanMen ( / #iColSet #iColCan #eBASE #eSYN #LXD$ #HD #HDL$)

  (SCFStartShori "SCFDanMen") ; 2000/09/08 HT ADD
  (StartUndoErr)

  (if (not CG_KENMEI_PATH) (progn 
    (CFAlertMsg "�������Ăяo����Ă��܂���B") (command "_undo" "b") (exit)))
  (setq #iColSet 4)        ; �ݒ�F
  (setq #iColCan "BYLAYER"); �����F
  
  (setq #eBASE (CFGetBaseSymXRec)) ; ��A�C�e���l��
  (if #eBASE (ResetBaseSym)) ; ��A�C�e���̐F���Z�b�g
  
  (KcChk&SetAllDanmenXRec); Xrecord �����݂��Ȃ��}�ʂł�������}�ʂ𑖍����Đݒ�
  (setq #HDL$ (KcDelNoExistXRec "DANMENSYM")); Xrecord ����}�ʂɑ��݂��Ȃ�����ٍ폜
  ; �}�ʒ��A�f�ʎw������Ă���A�C�e����ݒ�F�ɕϐF
  (foreach #HD #HDL$ 
    (command "_.chprop" (CFGetSameGroupSS (handent #HD)) "" "C" #iColSet ""))

  (setq #eSYN 'T)
  (while #eSYN
    (cond
      ((not (setq #eSYN (car (entsel "\n�A�C�e����I���F")))))
      ((or (not (setq #eSYN (CFSearchGroupSym #eSYN)))
           (not (setq #LXD$ (CfGetXData #eSYN "G_LSYM"))))
        (CFAlertMsg "\n�A�C�e���ł͂���܂���B")
        (setq #eSYN 'T)
      )
      ((= 1 (nth 14 #LXD$))
        (command "_.chprop" (CFGetSameGroupSS #eSYN) "" "C" #iColCan ""); �F�ϐF
        (KcChgG_LSYMSecNo #eSYN 0); LSYM�̒f�ʎw���l��ύX
        (princ "\n�f�ʎw�����������܂���.")
      )
      ((= 0 (nth 14 #LXD$))
        (command "_.chprop" (CFGetSameGroupSS #eSYN) "" "C" #iColSet ""); �F�ϐF
        (KcChgG_LSYMSecNo #eSYN 1); LSYM�̒f�ʎw���l��ύX
        (princ "\n�f�ʎw����ݒ肵�܂���.")
      )
    ); cond
  ); while

  (setq #HDL$ (CFGetXRecord "DANMENSYM")) ; �ύX���Xrecord �f��ON ���X�g�擾
  ; �}�ʒ��A�f�ʎw������Ă���A�C�e����ݒ�F�ɕϐF
  (foreach #HD #HDL$ 
    (command "_.chprop" (CFGetSameGroupSS (handent #HD)) "" "C" #iColCan ""))

  (if #eBASE (GroupInSolidChgCol #eBASE CG_BaseSymCol)) ; ��A�C�e���̐F��߂�

  (SCFEndShori) ; �I������  2000/09/07 HT
  (princ)
); C:SCFDanMen

;;<HOM>*************************************************************************
; <�֐���>    : KcChk&SetAllDanmenXRec
; <�����T�v>  : �}�ʂ𑖍����Ēf�ʎw������Ă���S�A�C�e����Xrecord�Ɏ擾
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/04/26 MH
; <���l>      : 
;*************************************************************************>MOH<
(defun KcChk&SetAllDanmenXRec ( 
  / 
  #SS #i #eSYN #iDan #HDL$
  )
  ; "DANMENSYM" �����݂��Ȃ��ꍇ�Ɏ��s
  ; 01/05/28 HN S-MOD �f�ʎw�����ނ͓s�x��������悤�ɕύX
  ;@DEL@(if (not (CFGetXRecord "DANMENSYM"))(progn
    (setq #SS (ssget "X" (list (list -3 (list "G_LSYM")))))
    (if (and #SS (< 0 (sslength #SS))) (progn
      (setq #i 0)
      (repeat (sslength #SS)
        (setq #eSYN (ssname #SS #i))
        (setq #iDan (nth 14 (CfGetXData #eSYN "G_LSYM")))
        ; G_LSYM�������A�f�ʎw��=1�̃A�C�e���̃n���h�������X�g��
        (if (= 1 #iDan) (setq #HDL$ (cons (cdr (assoc 5 (entget #eSYN))) #HDL$)))
        (setq #i (1+ #i))
      );repeat
    )); if progn
    (CFSetXRecord "DANMENSYM" #HDL$)
  ;@DEL@)); if progn
  ; 01/05/28 HN E-MOD �f�ʎw�����ނ͓s�x��������悤�ɕύX
  (princ)
) ; KcChk&SetAllDanmenXRec

;;010426MH;;<HOM>*************************************************************************
;;010426MH;; <�֐���>    : SCFDanMenColChg
;;010426MH;; <�����T�v>  : Xrecord�Q�Ƃ��Đ}�ʒ��A�f�ʎw������Ă���A�C�e�����w��F�ɕύX
;;010426MH;; <�߂�l>    : �Ȃ�
;;010426MH;; <�쐬>      : 01/04/25 MH ��������
;;010426MH;; <���l>      : 
;;010426MH;;*************************************************************************>MOH<
;;010426MH;(defun SCFDanMenColChg ( 
;;010426MH;  &iCol ; �F�ԍ�
;;010426MH;  / 
;;010426MH;  #HD #HDL$ #eSYN
;;010426MH;  )
;;010426MH;  (setq #HDL$ (CFGetXRecord "DANMENSYM")) ; Xrecord �f��ON ���X�g�擾
;;010426MH;  (foreach #HD #HDL$
;;010426MH;    (if (and (setq #eSYN (handent #HD)) (entget #eSYN))
;;010426MH;      (command "_.chprop" (CFGetSameGroupSS #eSYN) "" "C" &iCol "")
;;010426MH;    ); if
;;010426MH;  )
;;010426MH;  (princ)
;;010426MH;) ; SCFDanMenColChg

;;010425MH;;<HOM>*************************************************************************
;;010425MH; <�֐���>    : SCFDanMenColChg
;;010425MH; <�����T�v>  : �}�ʒ��Œf�ʎw������Ă���A�C�e�����w��̐F�ɑւ���
;;010425MH; <�߂�l>    : �Ȃ�
;;010425MH; <�쐬>      : 01/04/18 MH ��������
;;010425MH; <���l>      : 
;;010425MH;*************************************************************************>MOH<
;;010425MH(defun SCFDanMenColChg ( 
;;010425MH  &iCol ; �F�ԍ�
;;010425MH  / 
;;010425MH  #SS #i #eSYN #iDan 
;;010425MH  )
;;010425MH  (setq #SS (ssget "X" (list (list -3 (list "G_LSYM")))))
;;010425MH  (if (and #SS (< 0 (sslength #SS))) (progn
;;010425MH    (setq #i 0)
;;010425MH    (repeat (sslength #SS)
;;010425MH      (setq #eSYN (ssname #SS #i))
;;010425MH      (setq #iDan (nth 14 (CfGetXData #eSYN "G_LSYM")))
;;010425MH      ; G_LSYM�������A�f�ʎw��=1�̃A�C�e���̂ݎw��̐F�ɕϐF
;;010425MH      (if (= 1 #iDan) (command "_.chprop" (CFGetSameGroupSS #eSYN) "" "C" &iCol ""))
;;010425MH      (setq #i (1+ #i))
;;010425MH    );repeat
;;010425MH  )); if progn
;;010425MH  (princ)
;;010425MH) ; SCFDanMenColChg

;;010419MH;<HOM>*************************************************************************
;;010419MH; <�֐���>    : C:SCFDanMen
;;010419MH; <�����T�v>  : �f�ʎw���^����
;;010419MH; <�߂�l>    : �Ȃ�
;;010419MH; <�쐬>      : 1999-06-17
;;010419MH; <���l>      : �Ȃ�
;;010419MH;*************************************************************************>MOH<
;;010419MH(defun C:SCFDanMen (
;;010419MH  /
;;010419MH  #iColSet #iColCan #eBen #En$ #eEn #ps #ss #iI #eGen #Ex$
;;010419MH  #eSym #iDan #iCol #sMsg #Ex_n$ #eSYm
;;010419MH  )
;;010419MH
;;010419MH  (SCFStartShori "SCFDanMen")  ; 2000/09/08 HT ADD
;;010419MH  (StartUndoErr)
;;010419MH
;;010419MH  (if (/= nil CG_KENMEI_PATH)
;;010419MH    (progn
;;010419MH      (setq #ps (getvar "PICKSTYLE"))
;;010419MH      (setvar "PICKSTYLE" 3)
;;010419MH      ;�F�ݒ�
;;010419MH      (setq #iColSet 4)   ; �ݒ�
;;010419MH      (setq #iColCan 7)   ; ����
;;010419MH      ;��A�C�e���l��
;;010419MH      (setq #eBen (CFGetBaseSymXRec))
;;010419MH      ;��A�C�e��������ꍇ�A���̐F�ɖ߂�
;;010419MH      (if (/= nil #eBen)
;;010419MH        (ResetBaseSym)
;;010419MH      )
;;010419MH      (command "_-layer" "on" "n_symbol" "")
;;010419MH      (SCFDanMenColChg #iColSet)
;;010419MH      (setq #En$ T)
;;010419MH      (while #En$
;;010419MH        ;�폜��I��
;;010419MH        ; 2000/07/17 HT �u�ݔ��v�͎g��Ȃ� �u�A�C�e���v���g��
;;010419MH        ; (setq #En$ (SKGetPtByEn "�ݔ���I�����Ă�������." "3DSOLID" "�ݔ�" nil))
;;010419MH        (setq #En$ (SKGetPtByEn "�A�C�e����I��" "3DSOLID" "�A�C�e��" nil))
;;010419MH        (if (/= nil #En$)
;;010419MH          (progn
;;010419MH            ;�w�肳�ꂽ�}�`�̃O���[�v���l��
;;010419MH            (setq #eEn (car (car #En$)))
;;010419MH            (command "_select" #eEn "")
;;010419MH            (setq #ss (ssget "P"))
;;010419MH
;;010419MH            ;�V���{���}�`�l��
;;010419MH            (setq #iI 0)
;;010419MH            (repeat (sslength #ss)
;;010419MH              (setq #eGen (ssname #ss #iI))
;;010419MH              (setq #Ex$ (CfGetXData #eGen "G_LSYM"))
;;010419MH              (if (/= nil #Ex$)
;;010419MH                (progn
;;010419MH                  (setq #eSym #eGen)
;;010419MH                  (setq #iDan (nth 14 #Ex$))
;;010419MH                )
;;010419MH              )
;;010419MH              (setq #iI (1+ #iI))
;;010419MH            )
;;010419MH            (command "_select" #eSym "")
;;010419MH            (setq #ss (ssget "P"))
;;010419MH
;;010419MH            (if (/= nil #iDan)
;;010419MH              (progn
;;010419MH                ;�F�A�f���׸ށA�\��ү���ސݒ�
;;010419MH                (if (= 1 #iDan)
;;010419MH                  (progn         ; �f�ʎw������Ă���Ƃ�����
;;010419MH                    (setq #iCol #iColCan)
;;010419MH                    (setq #iDan 0)
;;010419MH                    (setq #sMsg "\n�f�ʎw�����������܂���.")
;;010419MH                  )
;;010419MH                  (progn         ; �f�ʎw������Ă��Ȃ��Ƃ��ݒ�
;;010419MH                    (setq #iCol #iColSet)
;;010419MH                    (setq #iDan 1)
;;010419MH                    (setq #sMsg "\n�f�ʎw����ݒ肵�܂���.")
;;010419MH                  )
;;010419MH                )
;;010419MH                ;�F�ύX
;;010419MH                ;(command "_change" #ss "" "P" "C" #iCol "")
;;010419MH                (command "_change" (ssname #ss 0) "" "P" "C" #iCol "")
;;010419MH                ;�g���ް��X�V
;;010419MH                (setq #Ex_n$
;;010419MH                  (append (reverse (cdr (reverse (CfGetXData #eSYm "G_LSYM")))) (list #iDan))
;;010419MH                )
;;010419MH                (CfSetXData #eSym "G_LSYM" #Ex_n$)
;;010419MH                ;ү���ޕ\��
;;010419MH                (princ #sMsg)
;;010419MH              )
;;010419MH              (progn
;;010419MH                ; 2000/07/17 HT �u�ݔ��v�͎g��Ȃ� �u�A�C�e���v���g��
;;010419MH                ;(CFAlertMsg "\n�ݔ��ł͂���܂���.")
;;010419MH                (CFAlertMsg "\n�A�C�e���ł͂���܂���.")
;;010419MH              )
;;010419MH            )
;;010419MH          )
;;010419MH        )
;;010419MH      )
;;010419MH      (if (/= nil #eBen)
;;010419MH        (GroupInSolidChgCol #eBen CG_BaseSymCol)
;;010419MH      )
;;010419MH      (SCFDanMenColChg #iColCan)
;;010419MH      (setvar "PICKSTYLE" #ps)
;;010419MH    )
;;010419MH    (progn
;;010419MH      (CFAlertMsg "�������Ăяo����Ă��܂���.")
;;010419MH    )
;;010419MH  )
;;010419MH  ; �I������  2000/09/07 HT
;;010419MH  (SCFEndShori)
;;010419MH  
;;010419MH  (princ)
;;010419MH) ; C:SCFDanMen
;;010419MH
;;010419MH
;;010419MH;<HOM>*************************************************************************
;;010419MH; <�֐���>    : SCFDanMenColChg
;;010419MH; <�����T�v>  : �f�ʎw������Ă���ݔ����w��̐F�ɂ���
;;010419MH; <�߂�l>    : �Ȃ�
;;010419MH; <�쐬>      : 1999-06-30
;;010419MH; <���l>      : �Ȃ�
;;010419MH;*************************************************************************>MOH<
;;010419MH(defun SCFDanMenColChg (
;;010419MH  &iCol       ; �F�ԍ�
;;010419MH  /
;;010419MH  #ps #xSp #iI #eSym #Ex$ #iDan #ss #en
;;010419MH  )
;;010419MH  (setq #ps (getvar "PICKSTYLE"))
;;010419MH  (setvar "PICKSTYLE" 3)
;;010419MH  (setq #xSp (ssget "X" (list (list -3 (list "G_LSYM")))))
;;010419MH  (if (/= nil #xSp)
;;010419MH    (progn
;;010419MH      (setq #iI 0)
;;010419MH      (repeat (sslength #xSp)
;;010419MH        (setq #eSym (ssname #xSp #iI))
;;010419MH        (setq #Ex$ (CfGetXData #eSym "G_LSYM"))
;;010419MH        (setq #iDan (nth 14 #Ex$))
;;010419MH        (if (/= nil #iDan)
;;010419MH          (progn
;;010419MH            (if (= 1 #iDan)
;;010419MH              (progn
;;010419MH                (command "_select" #eSym "")
;;010419MH                (setq #ss (ssget "P"))
;;010419MH                ;�F�ύX
;;010419MH                ;(command "_change" #ss "" "P" "C" &iCol "")
;;010419MH                (command "_change" (ssname #ss 0) "" "P" "C" &iCol "")
;;010419MH
;;010419MH              )
;;010419MH            )
;;010419MH          )
;;010419MH        )
;;010419MH        (setq #iI (1+ #iI))
;;010419MH      )
;;010419MH    )
;;010419MH  )
;;010419MH  (setvar "PICKSTYLE" #ps)
;;010419MH
;;010419MH  (princ)
;;010419MH) ; SCFDanMenColChg
