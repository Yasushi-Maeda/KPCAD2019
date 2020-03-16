;<HOM>*************************************************************************
; <�֐���>    : ResetBaseSym
; <�����T�v>  : ��A�C�e���V���{���̐F�����ɖ߂��B
; <�߂�l>    :
; <�쐬>      : 98-04-28
; <���l>      :
;*************************************************************************>MOH<
(defun ResetBaseSym (
    /
    #ps #ss
  )
  ;// ��A�C�e���V���{���}�`���擾
  (setq CG_BASESYM (CFGetBaseSymXRec))
  (if (/= CG_BASESYM nil)
    (progn
      (setq #ps (getvar "PICKSTYLE"))
      (setvar "PICKSTYLE" 3)
;;;01/04/04YM@      (command "_select" CG_BASESYM "")
;;;01/04/04YM@      (setq #ss (ssget "P"))

      ;01/04/04 YM �x���̂ŕύX START
      (if (entget CG_BASESYM)
        (command "_chprop" CG_BASESYM "" "C" "BYLAYER" "")
      );_if
      ;01/04/04 YM �x���̂ŕύX END

      (setvar "PICKSTYLE" #ps)
      (setq #ss (ssget "X" '((-3 ("G_ARW")))))
      (command-s "_erase" #ss "")
    )
  )
)
;ResetBaseSym

;�B������
; 00/06/04 HN �B��������ύX
;@@@(defun C:SCHide  () (setvar "DISPSILH" 1) (command "_hide") (setvar "DISPSILH" 0))
(defun C:SCHide  () (command-s "_shademode" "H") (princ))
;�V�F�[�h
; 00/06/05 HN �V�F�[�h�����̍Ō��(princ)��ǉ�
(defun C:SCShade () (setvar "SHADEDGE" 1) (command-s "_shade") (setvar "SHADEDGE" 3) (princ))

;00/06/29 SN S-ADD
;2Dܲ԰�ڰ�
(defun C:2DWire()
  (if (and (eq (getvar "tilemode") 0) (eq (getvar "cvport") 1))
    (command-s "shademode" "")
    (command-s "shademode" "2D")
  )
  (princ)
)
;�ׯļ���ިݸ޴���
(defun C:FlatEdge()
  (if (and (eq (getvar "tilemode") 0)(eq (getvar "cvport") 1))
    (command-s "_shademode" "")
    (command-s "_shademode" "L")
  )
  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : C:UndoB
; <�����T�v>  : UNDO�}�[�L���O���ꂽ�ʒu�܂Ŗ߂�
; <�߂�l>    : �Ȃ�
; <���l>      : �}�[�L���O���Ȃ��ꍇ�̓��b�Z�[�W��\������
;*************************************************************************>MOH<
(defun C:UndoB ()
  ;00/09/02 HN S-MOD �}�[�L���O���Ȃ��ꍇ�̓��b�Z�[�W��\��
  ;@@@(command "_undo" "b")
  (if (< 0 (getvar "UNDOMARKS"))
    (command-s "_undo" "b")
    (prompt "\n���ׂĂ̑��삪��������܂���.")
  )
  ;00/09/02 HN E-MOD �}�[�L���O���Ȃ��ꍇ�̓��b�Z�[�W��\��
  (princ)
)
;C:UndoB

;<HOM>*************************************************************************
; <�֐���>    : C:KP_ST_Fillet
; <�����T�v>  : "Fillet"����ޑO����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/09/07 YM
; <���l>      : KPCAD.MNU "Fillet"����ނŎg�p
;*************************************************************************>MOH<
(defun C:KP_ST_Fillet ()
  (setvar "FILLETRAD" 150) ; ̨گĔ��a
  (CFNoSnapStart)
  (StartUndoErr)
  (princ)
)
;C:KP_ST_Fillet

;<HOM>*************************************************************************
; <�֐���>    : C:KP_ED_Fillet
; <�����T�v>  : "Fillet"����ތ㏈��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/09/07 YM
; <���l>      : KPCAD.MNU "Fillet"����ނŎg�p
;*************************************************************************>MOH<
(defun C:KP_ED_Fillet ()
  (CFNoSnapEnd)
  (setq *error* nil)
  (princ)
)
;C:KP_ED_Fillet

;<HOM>*************************************************************************
; <�֐���>    : StartCmnErr
; <�����T�v>  : ���ʃG���[��`
; <�߂�l>    :
; <�쐬>      : 99-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun StartCmnErr ()
  ;@@@(setq *error* CmnErr) ;00/01/30 ���� MOD CG_DEBUG�����ǉ�
  (if (= CG_DEBUG nil)
    (setq *error* CmnErr)
    (setq *error* nil)
  )
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command-s "_undo" "M")
  (command-s "_undo" "a" "off")
)
;StartCmnErr

;<HOM>*************************************************************************
; <�֐���>    : StartUndoErr
; <�����T�v>  : Undo�G���[��`
; <�߂�l>    :
; <�쐬>      : 99-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun StartUndoErr ()
  ;@@@(setq *error* UndoErr) ;00/01/30 ���� MOD CG_DEBUG�����ǉ�
  (if (= CG_DEBUG nil)
    (setq *error* UndoErr)
    (setq *error* nil)
  )
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (if (or (= "23" CG_ACADVER)(= "19" CG_ACADVER)(= "18" CG_ACADVER)); 2020/02/17 YM MOD
		(progn
	    (setvar "3DOSMODE"  1) ;2011/06/30 YM ADD ���݂̒�� 3D �I�u�W�F�N�g �X�i�b�v�𖳌��ɂ��܂��B
			(setvar "UCSDETECT" 0) ;�_�C�i�~�b�N UCS ���A�N�e�B�u�ɂ��Ȃ� 2011/10/11 YM ADD
		)
  );_if

	; 2020/02/17 YM MOD command --> command-s
  (command-s "_undo" "M")
  (command-s "_undo" "a" "off"); �������[�h�I�t
	; 2020/02/17 YM MOD
)
;StartUndoErr

;06/07/24 T.Ari ADD-S �p�[�X�L�����Z���G���[�Ή�
;<HOM>*************************************************************************
; <�֐���>    : StartUndoReOpenModelErr
; <�����T�v>  : Undo�G���[��`
; <�߂�l>    :
; <�쐬>      : 99-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun StartUndoReOpenModelErr ()
  (if (= CG_DEBUG nil)
    (setq *error* UndoReOpenModelErr)
    (setq *error* nil)
  )
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command-s "_undo" "M")
  (command-s "_undo" "a" "off")
)
;StartUndoReOpenModelErr
;06/07/24 T.Ari ADD-E �p�[�X�L�����Z���G���[�Ή�

;<HOM>*************************************************************************
; <�֐���>    : CmnErr
; <�����T�v>  : ���ʃG���[�R�[���o�b�N�֐�
; <�߂�l>    :
; <�쐬>      : 99-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun CmnErr ( &msg )
  ;(setq SCF_OpenMode nil) 2000/08/23 HT DEL ���ݖ��g�p
  ; �O���[�o���ϐ���nil�ɂ��� 2000/09/08 HT ADD
  (CmnClearGlobal)
  (setq *error* nil)
  (princ)
)
;CmnErr


;<HOM>*************************************************************************
; <�֐���>    : CmnClearGlobal
; <�����T�v>  : �O���[�o���ϐ����N���A����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2000/09/08
; <���l>      :
;*************************************************************************>MOH<
(defun CmnClearGlobal (
  /
  )
  ; �O���[�o���ϐ���nil�ɂ���
  ; �o�͊֌W�̃O���[�o��nil
  (SCF_ClearGlobal)

) ;CmnClearGlobal


;<HOM>*************************************************************************
; <�֐���>    : UndoErr
; <�����T�v>  : Undo�G���[�R�[���o�b�N�֐�
; <�߂�l>    :
; <�쐬>      : 99-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun UndoErr ( &msg )
;(defun UndoErr ()
  (command-s "_undo" "b");2020/02/17 YM MOD
  ; (setq SCF_OpenMode nil)  2000/08/23 HT DEL ���ݖ��g�p
  (setq *error* nil)
  (princ)
)
;UndoErr

;<HOM>*************************************************************************
; <�֐���>    : UndoOpenModelErr
; <�����T�v>  : Undo�G���[�R�[���o�b�N�֐�
; <�߂�l>    :
; <�쐬>      : 06-07-24
; <���l>      :
;*************************************************************************>MOH<
(defun UndoReOpenModelErr ( &msg )
  (setq CG_OpenMode 0)
  (setq #sFname (strcat CG_KENMEI_PATH "MODEL.dwg"))
  (SCFCmnFileOpen #sFName 1)
  (command-s "_undo" "b")
  (setq *error* nil)
  (princ)
)
;UndoReOpenModelErr

;<HOM>*************************************************************************
; <�֐���>    : GetViewSize
; <�����T�v>  : ���݂̃r���[�|�[�g�̃T�C�Y���擾����
; <�߂�l>    :
;      ���X�g : (x�ŏ����W x�ő���W y�ŏ����W y�ő���W)
; <�쐬>      : 98-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun GetViewSize (
    /
    #vctr #vsize #ssize #x #xmin #xmax #ymin #ymax
  )
  (setq #vctr  (getvar "VIEWCTR"))
  (setq #vsize (getvar "VIEWSIZE"))
  (setq #ssize (getvar "SCREENSIZE"))
  (setq #x (/ (* #vsize (car #ssize)) (cadr #ssize)))
  (setq #xmin (- (car #vctr) (/ #x 2)))
  (setq #xmax (+ (car #vctr) (/ #x 2)))
  (setq #ymin (- (cadr #vctr) (/ #vsize 2)))
  (setq #ymax (+ (cadr #vctr) (/ #vsize 2)))

  (list #xmin #xmax #ymin #ymax)
)
;GetViewSize

;<HOM>*************************************************************************
; <�֐���>    : SetListToTile
; <�����T�v>  : DCL��`�̃|�b�v�A�b�v�Ƀ��X�g�̓��e��ݒ肷��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-14
; <���l>      :
;*************************************************************************>MOH<
(defun SetListToTile (
  &key               ;DCL��`�̃|�b�v�A�b�v�i�v���_�E���j�̃L�[����
  &lst$$             ;���X�g�̃��X�g (("01" "���e1")("02" "���e2")...)
  /
  #lst$
  )
  (start_list &key 3)
  (foreach #lst$ &lst$$
    (add_list (strcat (car #lst$) "�F" (cadr #lst$)))
    ;(add_list (cadr #lst$))
  )
  (end_list)
)
;SetListToTile

;<HOM>*************************************************************************
; <�֐���>    : SetCodeToTile
; <�����T�v>  : DCL��`�̃|�b�v�A�b�v�Ɏw�荀�ڂ𔽓]�\��������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-10-05
; <���l>      : �w�荀�ڂ̓��X�g�̃��X�g�̂P�Ԗڂ̗v�f�Ƃ���
;*************************************************************************>MOH<
(defun SetCodeToTile (
    &key               ;DCL��`�̃|�b�v�A�b�v�i�v���_�E���j�̃L�[����
    &code              ;���]������w��R�[�h
    &lst$$             ;���X�g�̃��X�g (("01" "���e1")("02" "���e2")...)
    /
    #i
    #loop
    #lst$
  )
  (if (/= nil &lst$$)
    (progn
      (setq #i 0)
      (setq #loop T)
      (while (and #loop (< #i (length &lst$$)))
        (setq #lst$ (nth #i &lst$$))
        (if (= (car #lst$) &code)
          (progn
            (set_tile &key (itoa #i))
            (setq #loop nil)
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
)
;SetCodeToTile

;<HOM>*************************************************************************
; <�֐���>    : SetCodeToTile2
; <�����T�v>  : DCL��`�̃|�b�v�A�b�v�Ɏw�荀�ڂ𔽓]�\��������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun SetCodeToTile2 (
    &key                ;DCL��`�̃|�b�v�A�b�v�i�v���_�E���j�̃L�[����
    &code$              ;���]������w��R�[�h
    &lst$$              ;���X�g�̃��X�g (("01" "���e1" "���e11")("02" "���e2" "���e22")...)
    /
    #i #j
    #loop
    #lst$
  )
  (if (/= nil &lst$$)
    (progn
      (setq #i 0)
      (setq #j 0)
      (setq #loop T)
      (while (and #loop (< #i (length &lst$$)))
        (setq #lst$ (nth #i &lst$$))
        (if (= (caddr #lst$) (cadr &code$))
          (progn
            (if (= (car #lst$) (car &code$))
              (progn
                (set_tile &key (itoa #j))
                (setq #loop nil)
              )
            )
            (setq #j (1+ #j))
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
)
;SetCodeToTile2

;<HOM>*************************************************************************
; <�֐���>    : GroupInSolidChgCol
; <�����T�v>  : ��_�V���{���Ɠ��O���[�v�̐}�`��F�ւ�����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-14
; <���l>      :
;*************************************************************************>MOH<
(defun GroupInSolidChgCol (
    &sym     ;(ENAME)�V���{���}�`
    &col     ;(STR)�F
    /
    #en #en$
    #ss
    #ps
  )
  ;// �O���[�v�I�����[�h�ɂ��ăO���[�v�S�̂�F�ւ�����
  (setq #ps (getvar "PICKSTYLE"))
  (setvar "PICKSTYLE" 3)
;  (command "_select" &sym "")
;  (setq #ss (ssget "P"))

  ;// �F�ւ� "_change" ��UCS �ɕ��s�łȂ��}�`���R���̂�"_chprop"�g�p
  (command-s "_chprop" &sym "" "C" &col "")

  ;// ������}
  (MakeSymAxisArw &sym)
  (setvar "PICKSTYLE" #ps)
  (princ)
)
;GroupInSolidChgCol

;<HOM>*************************************************************************
; <�֐���>    : SKChgView
; <�����T�v>  : �w�莋�_�ɕύX��A�y��������0.9x����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun SKChgView ( &view / #os)

  (setq #os (getvar "OSMODE")) ; 00/02/28 YM ADD
  (setvar "OSMODE" 0)          ; 00/02/28 YM ADD

  ;04/05/26 YM ADD
  (command-s "_REGEN")

  (command-s "_vpoint" &view)
;;;  (command "_zoom" "0.9x") ; 06/05 YM

  (setvar "OSMODE" #os)        ; 00/02/28 YM ADD

  (princ)
);SKChgView

;00/06/29 SN S-ADD
; 02/03/28 HN S-MOD �������Ή�
;@MOD@(defun C:ChgViewPlaneUp() (SKChgView "0,0,1")) ;���ʏ�
(defun C:ChgViewPlaneUp() (SKChgView "0,0,1")(command-s "_.dview" "all" "" "ca" "" 0.0 "X")) ;���ʏ�
; 02/03/28 HN E-MOD �������Ή�
(defun C:ChgViewPlaneUd() (SKChgView "0,0,-1"));���ʉ�
(defun C:ChgViewSideL() (SKChgView "-1,0,0"))  ;���ʍ�
(defun C:ChgViewSideR() (SKChgView "1,0,0"))   ;���ʉE
(defun C:ChgViewFront() (SKChgView "0,-1,0"))  ;����
(defun C:ChgViewBack() (SKChgView "0,1,0"))    ;�w��
(defun C:ChgViewSW() (SKChgView "-2,-2,1"))    ;�쐼
(defun C:ChgViewSE() (SKChgView "2,-2,1"))     ;�쓌
;;;01/05/11YM@(defun C:ChgViewNE() (SKChgView "1,1,1"))      ;�k��
;;;01/05/11YM@(defun C:ChgViewNW() (SKChgView "-1,1,1"))     ;�k��
(defun C:ChgViewNE() (SKChgView "2,2,1"))      ;�k�� ; 01/05/11 YM
(defun C:ChgViewNW() (SKChgView "-2,2,1"))     ;�k�� ; 01/05/11 YM

;00/06/29 SN E-ADD

;<HOM>*************************************************************************
; <�֐���>    : CFGetBaseSymXRec
; <�����T�v>  : XRecord�����A�C�e���V���{������������
; <�߂�l>    :
;       ENAME : ��A�C�e���V���{���}�`��
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun CFGetBaseSymXRec ( / #hnd )
  (setq #hnd (car (CFGetXRecord "BASESYM")))
  (if (/= #hnd nil)
    (handent #hnd)
  )
)
;CFGetBaseSymXRec

;<HOM>*************************************************************************
; <�֐���>    : CFGetBaseSymXRec
; <�����T�v>  : XRecord�Ɋ�A�C�e���V���{���}�`����ݒ肷��
; <�߂�l>    :
;       ENAME : ��A�C�e���V���{���}�`��
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun CFSetBaseSymXRec ( &en / #hnd )
  (setq #hnd (cdr (assoc 5 (entget &en))))
  (CFSetXRecord "BASESYM" (list #hnd))
)
;CFSetBaseSymXRec

;;;<HOM>***********************************************************************
;;; <�֐���>    : KcDelNoExistXRec
;;; <�����T�v>  : Xrecord�̎w��̍��ڂ̓��e�������A�}�ʂɂȂ�=�����σn���h���폜
;;; <�߂�l>    : Xrecord�Ɏ��[�������A�����ς̃��X�g
;;; <�쐬>      : 01/04/25 MH
;;; <���l>      :
;;;***********************************************************************>MOH<
(defun KcDelNoExistXRec (
  &sOBDIC       ; XRecord �̍��ځi�I�u�W�F�N�g�f�B�N�V���i���[�j������
  /
  #HDL$ #TEMP$ #CHK #eCH #HDL$
  )
  ;�}�ʒ��̍폜���ꂽ�n���h���͏���
  (setq #HDL$ (CFGetXRecord &sOBDIC))
  (setq #TEMP$ nil)
  (foreach #CHK #HDL$
    (if (and (setq #eCH (handent #CHK)) (entget #eCH)) (setq #TEMP$ (cons #CHK #TEMP$)))
  ); foreach
  (setq #HDL$ #TEMP$)
  (CFSetXRecord &sOBDIC #HDL$)
  #HDL$
); KcDelNoExistXRec

;<HOM>*************************************************************************
; <�֐���>    : CFPosOKDialog
; <�����T�v>  : �z�u�m�F�_�C�A���O
; <�߂�l>    :
;             :    T:(OK)
;             :  nil:(NO)
;             :
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun CFPosOKDialog (
    &msg        ;�m�F���b�Z�[�W
    /
    #dcl_id
    #ret
  )
  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "COMMON.DCL")))
  (if (not (new_dialog "PosOKDlg" #dcl_id)) (exit))
  (set_tile "msg" &msg)
  (action_tile "accept" "(setq #ret T)  (done_dialog)")
  (action_tile "cancel" "(setq #ret nil)(done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)

  ;// ���ʂ�Ԃ�
  #ret
)
;CFPosOKDialog

;<HOM>*************************************************************************
; <�O���[�o����`> :
; <���l>           :
;*************************************************************************>MOH<
(setq CG_XROTATE_ANG 10.0)    ;�w������]�p�x
(setq CG_YROTATE_ANG 10.0)    ;�x������]�p�x
(setq CG_ZoomUp      "1.2x")  ;�ްѱ��߻���
(setq CG_ZoomDn      "0.8x")  ;�ް��޳ݻ���

;;;<HOM>************************************************************************
;;; <�֐���>  : SKXRotatePlus
;;; <�����T�v>: �r���[���_�������E��]
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKXRotatePlus ( / #os)
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (SKXRotate CG_XROTATE_ANG)
  (setvar "OSMODE" #os)
  (princ)
);SKXRotatePlus
(defun C:XRotatePlusVp (/) (SKXRotatePlus))

;;;<HOM>************************************************************************
;;; <�֐���>  : SKXRotateMinus
;;; <�����T�v>: �r���[���_����������]
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKXRotateMinus ( / #os)
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (SKXRotate (* -1.0 CG_XROTATE_ANG))
  (setvar "OSMODE" #os)
  (princ)
);SKXRotateMinus
(defun C:XRotateMinusVp (/) (SKXRotateMinus))

;;;<HOM>************************************************************************
;;; <�֐���>  : SKYRotatePlus
;;; <�����T�v>: �r���[���_���������]
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKYRotatePlus ( / #os)
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (SKYRotate CG_YROTATE_ANG)
  (setvar "OSMODE" #os)
  (princ)
);SKYRotatePlus
(defun C:YRotatePlusVp () (SKYRotatePlus))

;;;<HOM>*************************************************************************
;;; <�֐���>    : SKYRotateMinus
;;; <�����T�v>  : �r���[���_����������]
;;; <���l>      : �Ȃ�
;;;*************************************************************************>MOH<
(defun SKYRotateMinus ( / #os)
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (SKYRotate (* -1 CG_YROTATE_ANG))
  (setvar "OSMODE" #os)
  (princ)
);SKYRotateMinus
(defun C:YRotateMinusVp () (SKYRotateMinus))

;<HOM>*************************************************************************
; <�֐���>    : SKFitVp
; <�����T�v>  : ���݂̃r���[�̕\�����œK������
; <���l>      :
;*************************************************************************>MOH<
(defun SKFitVp ()
  (command-s "_zoom" "e")
;;;  (command "_zoom" "0.9x") ; 06/05 YM
  (princ)
)
;SKFitVp
(defun C:FitVp ()(SKFitVp));00/06/29 SN ADD

;<HOM>*************************************************************************
; <�֐���>    : SKZoomUp
; <�����T�v>  : �r���[�������g�傷��
; <���l>      :
;*************************************************************************>MOH<
(defun SKZoomUp (
  )
  (command-s "_zoom" CG_ZoomUp)
  (princ)
)
;SKZoomUp
(defun C:ZoomUp ()(SKZoomUp));00/06/29 SN ADD

;<HOM>*************************************************************************
; <�֐���>    : SKZoomDn
; <�����T�v>  : �r���[�������k������
; <���l>      :
;*************************************************************************>MOH<
(defun SKZoomDn (
  )
  (command-s "_zoom" CG_ZoomDn)
  (princ)
)
;SKZoomDn
(defun C:ZoomDn ()(SKZoomDn));00/06/29 SN ADD

;<HOM>*************************************************************************
; <�֐���>    : SKResetVp
; <�����T�v>  : �S�Ẵr���[�|�[�g�̕\�����œK������
; <���l>      :
;*************************************************************************>MOH<
(defun SKResetVp (
    /
    #vid #os
  )
  (command-s "_vports" "SI")
  (command-s "_vpoint" "0,0,1")
  (princ)
)
;SKResetVp
(defun C:ResetVp()(SKResetVp));00/06/29 SN ADD


;<HOM>*************************************************************************
; <�֐���>    : CFGetDBSQLRec
; <�����T�v>  : �w��e�[�u�������������ɂ�茟������
; <�߂�l>    :
; <�쐬>      : 1999-10-19
; <���l>      :
;*************************************************************************>MOH<
(defun CFGetDBSQLRec (
    &session     ;�Z�b�V����
    &tbl         ;(STR)�e�[�u������
    &list$       ;(LIST)��������
    /
    #listCode
    #sql
    #nn
    #i
  )

  (setq #sql (strcat "select * from " &tbl " where"))
  (setq #i 0)

  (foreach #lst &list$

    (if (= (nth 2 #lst) 'ADDSTR)
      (progn
        (setq #sql (strcat #sql " " (car #lst)))
      )
      (progn
        (if (/= #i 0)
          (progn ; �ŏ��ȊO
            (setq #sql (strcat #sql " and "))
          )
          (progn ; �ŏ�����
            (setq #sql (strcat #sql " "))
          )
        )
        (cond
          ((= (nth 2 #lst) 'INT)
            (setq #sql (strcat #sql (car #lst) "=" (cadr #lst)))
          )
          ((= (nth 2 #lst) 'STR)
            (setq #sql (strcat #sql (car #lst) "='" (cadr #lst) "'"))
          )
        )
      )
    )
    (setq #i (1+ #i))
;;;   (princ #i)(terpri)
  )

  (if (= CG_DEBUG 1)
    (progn
      (princ "\n== CFGetDBSQLRec =============================================")
      (princ "\n #sql =")(princ #sql)
      (princ "\n==============================================================")
    )
  )

  ;// �N�G���[�̎��s���ʂ�Ԃ�
  (DBSqlAutoQuery &session #sql)
)
;CFGetDBSQLRec

;<HOM>*************************************************************************
; <�֐���>    : CFGetSymSKKCode
; <�����T�v>  : �w�蕔�ނ̐��iCODE���擾����
; <�߂�l>    :
;     FLG=nil :
;        LIST : (�ꌅ�� �񌅖� �O����)
;    FLG/=nil :
;         INT : �w��̌��ڂ̒l��Ԃ�
;
; <�쐬>      : 1999-10-19
; <���l>      :
;*************************************************************************>MOH<
(defun CFGetSymSKKCode (
    &enS         ;(ENAME)��V���{��
    &flg         ;(INT)�擾�t���O
                 ;      1:�ꌅ��
                 ;      2:�ꌅ��
                 ;      3:�ꌅ��
                 ;    nil:�S��
    /
    #seikaku
    #LSYM$       ; �g���f�[�^
    #Ret         ; �Ԃ�l  �i�G���[�̎�nil)
  )
  (setq #LSYM$ (CFGetXData &enS "G_LSYM"))
  (if (= #LSYM$ nil)
    (progn
    (princ "\n�g���f�[�^���擾�ł��܂���ł����B(G_LSYM)")
    (princ "\n�}�`�f�[�^ �F")
    (princ (cdr (cadr (assoc -3 (entget &enS '("*"))))))
    (setq #Ret nil)
    (princ "\n")
    )
    (progn
    (setq #seikaku (nth 9 #LSYM$))
    (setq #Ret (CFGetSeikakuToSKKCode #seikaku &flg))
    )
  )
  ; 2000/06/07 �y�� �}�`�g���f�[�^�s���̏ꍇ�G���[���b�Z�[�W+  nil��Ԃ��悤�ɕύX
  ; (setq #seikaku (nth 9 (CFGetXData &enS "G_LSYM")))
  ; (CFGetSeikakuToSKKCode #seikaku &flg)
  #Ret
)
;CFGetSymSKKCode

;<HOM>*************************************************************************
; <�֐���>    : CFGetSeikakuToSKKCode
; <�����T�v>  : �w�蕔�ނ̐��iCODE���擾����
; <�߂�l>    :
;     FLG=nil :
;        LIST : (�ꌅ�� �񌅖� �O����)
;    FLG/=nil :
;         INT : �w��̌��ڂ̒l��Ԃ�
;
; <�쐬>      : 1999-10-19
; <���l>      :
;*************************************************************************>MOH<
(defun CFGetSeikakuToSKKCode (
    &seikaku     ;(INT)3���̐��iCODE  111
    &flg         ;(INT)�擾�t���O
                 ;      1:1����
                 ;      2:2����
                 ;      3:3����
                 ;    nil:�S��
    /
  )
  (setq &seikaku (itoa (fix &seikaku)))
  (if &flg
    (progn
      (atoi (substr &seikaku &flg 1))
    )
    (progn ; &flg=nil
      (list (atoi (substr &seikaku 1 1))
            (atoi (substr &seikaku 2 1))
            (atoi (substr &seikaku 3 1))
      )
    )
  )
)
;CFGetSymSKKCode

;<HOM>***********************************************************************
; <�֐���>    : MakeArrow
; <�����T�v>  : �n�_���ɉ~�A�I�_���ɖ��������̕`��
; <�߂�l>    : ���̍\���v�f�S�ẴG���e�B�e�B���X�g
; <�쐬>      : 1998/05/29 -> 1998/05/29  ���� �����Y
; <���l>      : ����"0"��w�ɂ��� 00/08/01 YM
;***********************************************************************>HOM<
(defun MakeArrow
  (
    &pos1     ; �n�_
    &pos2     ; �I�_
    &recH     ; �n�_�~�̔��a
    &Arlngh   ; �����̒���
    &Arrec    ; ���̓��a�p
    &color    ; �`��F
    /
    #cir
    #line
    #Aln1
    #Aln2
    #TempColor
    #os #clayer
  )
  (setq #clayer (getvar "CLAYER"   ))         ; ���݂̉�w���L�[�v 00/08/01 YM
  (command-s "_layer" "T" "0" "")  ; �ذ�މ���
  (command-s "_layer" "ON" "0" "") ; ��wON
  (command-s "_layer" "U" "0" "")  ; ۯ�����
  (command-s "_layer" "S" "0" "")  ; ���݉�w�̕ύX     00/08/01 YM

  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (setq #TempColor (getvar "CECOLOR"))
  (setvar "CECOLOR" (itoa &color))
  (command-s "_circle" &pos1 &recH)
  (setq #cir (entlast))

  (command-s "_pline" &pos1 &pos2 "")
  (setq #line (entlast))

  (command-s
    "_pline"
    &pos2
    (strcat
      "@"
      (rtos &Arlngh)
      "<"
      (rtos
        (+
          &Arrec
          (+
            180
            (/ (* (angle &pos1 &pos2) 180) pi)
          )
        )
      )
    )
    ""
  )
  (setq #Aln1 (entlast))

  (command-s
    "_pline"
    &pos2
    (strcat
      "@"
      (rtos &Arlngh)
      "<"
      (rtos
        (+
          (* &Arrec -1)
          (+
            180
            (/ (* (angle &pos1 &pos2) 180) pi)
          )
        )
      )
    )
    ""
  )
  (setq #Aln2 (entlast))
  (setvar "CECOLOR" #TempColor)
  (setvar "OSMODE" #os)

  (CFSetXData #cir  "G_ARW" (list 0))
  (CFSetXData #line "G_ARW" (list 0))
  (CFSetXData #Aln1 "G_ARW" (list 0))
  (CFSetXData #Aln2 "G_ARW" (list 0))
  (setvar "CLAYER" #clayer) ; ���̉�w�ɖ߂� 00/08/01 YM
  (list #cir #line #Aln1 #Aln2)
)
;MakeArrow

;<HOM>*************************************************************************
; <�֐���>    : NRMakePrimAxisArw
; <�����T�v>  : �v�f�}�`�̎������쐬����
; <�߂�l>    :
;        LIST : �쐬�����̍\���}�`���X�g
; <�쐬>      : 1999-12-20
; <���l>      :
;*************************************************************************>MOH<
(defun MakeSymAxisArw (
    &sym    ;(ENAME)�V���{���}�`��
    /
    #w #ang #en$ #pt1 #pt2
  )
  (setq #w   (nth 3 (CFGetXData &sym "G_SYM")))
  (setq #ang (nth 2 (CFGetXData &sym "G_LSYM")))
  (setq #pt1 (cdr (assoc 10 (entget &sym))))
  (setq #pt2 (polar #pt1 #ang #w))

  ;// �����쐬����
  (setq #en$ (MakeArrow #pt1 #pt2 CG_AXISARWRAD CG_AXISARWLEN CG_AXISARWANG CG_AXISARWCOLOR))

  #en$
)
;MakeSymAxisArw

;<HOM>*************************************************************************
; <�֐���>    : GetDlgID
; <�����T�v>  : �޲�۸�ID�l��
; <�߂�l>    : �޲�۸�ID
; <�쐬>      : �X�{
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun GetDlgID (
  &sFname     ; �޲�۸�̧�ٖ��i�g���q�Ȃ��j
  /
  )
  (load_dialog (strcat CG_DCLPATH &sFname ".dcl"))
)
;GetDlgID

;<HOM>*************************************************************************
; <�֐���>    : MakeCmLwPolyLine
; <�����T�v>  : �_�񂩂�ײĳ������ײ݂��쐬����
; <�߂�l>    :
;       ENAME : �쐬����ײĳ������ײݴ�èè��
; <�쐬>      : 98-03-25 ��{����
; <���l>      : ����ފ֐����g�p
;*************************************************************************>MOH<
(defun MakeCmLwPolyLine (
    &pt$  ;(LIST)�\�����W�_ؽ�
    &cls  ;(INT) "C" : �|�����C�������
          ;       "" : �|�����C������Ȃ�
    /
    #vn #eg #pt #os #ret
  )
  (setq #ret nil)
  (if (< 1 (length &pt$))
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command "_PLINE" (car &pt$))
      (foreach #pt (cdr &pt$)
        (command #pt)
      )
      (command &cls)
      (setvar "OSMODE" #os)
      (entlast)
    )
  ;else
    nil
  )
)
;MakeCmLwPolyLine

;<HOM>*************************************************************************
; <�֐���>    : PKAutoHinbanKakutei
; <�����T�v>  : �����i�Ԋm��(հ�ް���f)
; <�߂�l>    :
; <�쐬>      : 01/06/?? YM
; <���l>      :
;*************************************************************************>MOH<
(defun PKAutoHinbanKakutei (
  /
  #I #SS #WT$
;-- 2011/09/14 A.Satoh Add - S
  #set_cnt
;-- 2011/09/14 A.Satoh Add - E
  )
;-- 2011/09/14 A.Satoh Add - S
  (setq #set_cnt 0)
;-- 2011/09/14 A.Satoh Add - E
  (setq #WT$ '())
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (and #ss (> (sslength #ss) 0))
    (progn ; WT����
      (setq #i 0 #WT$ '()) ; �i�Ԋm�肵�Ă��Ȃ��v�s�𒲂ׂ�
      (repeat (sslength #ss)
        (if (= nil (CFGetXData (ssname #ss #i) "G_WTSET"))
          (setq #WT$ (append #WT$ (list (ssname #ss #i)))) ; �i�Ԋm�肵�Ă��Ȃ��v�sؽ�
        );_if
        (setq #i (1+ #i))
      );_repeat

      (if #WT$
;-- 2011/08/31 A.Satoh Mod - S
;        (if (CFYesNoDialog "���[�N�g�b�v�̕i�Ԋm����s���܂��B�y�H�����z")
        (if (CFYesNoDialog "���[�N�g�b�v�̕i�Ԋm����s���܂��B")
;-- 2011/08/31 A.Satoh Mod - E
          (progn
            (CFCmdDefBegin 0); 04/06/28 YM ADD
            (CFNoSnapReset)
            (foreach #WT #WT$
              (PCW_ChColWT #WT "MAGENTA" nil)
;;;              (KPW_DesideWorkTop3 #WT) ; �ݸ�A��ە����Ή�
;-- 2011/09/14 A.Satoh Mod - S
;              (KPW_DesideWorkTop_FREE #WT);2011/08/12 YM ADD
              (if (= (KPW_DesideWorkTop_FREE #WT) nil)
                (setq #set_cnt (1+ #set_cnt))
              )
;-- 2011/09/14 A.Satoh Mod - E
            )
            (CFNoSnapFinish); 04/06/28 YM ADD
            (CFCmdDefFinish)
          )
;-- 2011/09/14 A.Satoh Mod - S
;          ;else
;          (princ) ; No
          (setq #set_cnt (1+ #set_cnt))
;-- 2011/09/14 A.Satoh Mod - E
        );_if
      );_if
    )
  );_if

;-- 2011/09/14 A.Satoh Mod - S
;  (princ)
  (if (= #set_cnt 0)
    (setq #ret T)
    (setq #ret nil)
  )
  #ret
;-- 2011/09/14 A.Satoh Mod - E
);PKAutoHinbanKakutei

;<HOM>*************************************************************************
; <�֐���>    : KPAutoCT_HINKakutei
; <�����T�v>  : ���ʶ����į�ߎ����i�Ԋm��(հ�ް���f)
; <�߂�l>    :
; <�쐬>      : 01/08/28 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KPAutoCT_HINKakutei (
  /
  #CT$ #I #SKK$ #SS
  )
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss (> (sslength #ss) 0))
    (progn
      (setq #i 0) ; �����į�߂𒲂ׂ�
      (setq #CT$ nil)
      (repeat (sslength #ss)
        (setq #skk$ (CFGetSymSKKCode (ssname #ss #i) nil))
        (if (and (= (car   #skk$) CG_SKK_ONE_CNT) ; ����� =7 ; 01/08/29 YM MOD
                 (= (cadr  #skk$) CG_SKK_TWO_BAS) ; �ް�  =1 ; 01/08/29 YM MOD
                 (= (caddr #skk$) CG_SKK_THR_ETC)); ���̑�=0 ; 01/08/29 YM MOD
          (progn ; ���ʶ����������  ; 01/08/29 YM MOD PMEN4�̗L�������Ȃ�
            (if (= nil (CFGetXData (ssname #ss #i) "G_TOKU"))
              (setq #CT$ (append #CT$ (list (ssname #ss #i)))) ; �i�Ԋm�肵�Ă��Ȃ������į��ؽ�
            );_if
          )
        );_if
        (setq #i (1+ #i))
      );_repeat

      (if #CT$
        (if (CFYesNoDialog "���ʃJ�E���^�[�g�b�v�̕i�Ԋm����s���܂��B")
          (foreach #CT #CT$
            (GroupInSolidChgCol2 #CT CG_InfoSymCol) ; �F��ς���
            (KP_DesideCTTop #CT); ���ʶ�����̕i�Ԃ��m��&�m�F&"G_TOKU"���
            (GroupInSolidChgCol2 #CT "BYLAYER")     ; �F��ς���
          )
          (princ) ; հ�ް��No
        )
      );_if
    )
  );_if
  (princ)
);KPAutoCT_HINKakutei

;;;<HOM>************************************************************************
;;; <�֐���>  : CFAutoSave
;;; <�����T�v>: �����ۑ�����
;;; <�߂�l>  : �Ȃ�
;;; <����>    : 01/05/23
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun CFAutoSave
  (
  /
  #sFname     ; �t�@�C����
  )
  (setvar "ELEVATION" 0); 01/02/13 MH ADD

  (if (or (= CG_TESTMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3))
    nil
  ; else
    ; WEB�ňȊO
    (if (= "MODEL.DWG" (strcase (getvar "DWGNAME")))
      (progn ; 01/03/09 YM ����ڰēǂݍ��݌�o���ƭ��I������Ƃ��͏������΂��Ȃ��Ɨ�����

        (C:DELMEJI) ; ����قɂЂ����Ă��Ȃ�G_MEJI���폜

        (C:Del0door) ; �����}�ʏC���@�\("0_door" "0_plane" "0_wall"��w�폜�A"0_door"���݁����ލX�V)

        ; �ۑ����Ƀw�b�_�[��񏑏o��������ǉ�
        (SKB_WriteHeadList);2008/06/24 YM DEL

        ; �ۑ�����COLOR.CFG�������o���B
        (SKB_WriteColorList);2008/06/24 YM DEL

        (CabShow_sub) ; 01/09/03 YM MOD �֐���

        ;// ���[�N�g�b�v���i�Ԗ��m��Ȃ玩���m�肷��
;;;       (PKAutoHinbanKakutei);2008/06/24 YM DEL

        ;// �J�E���^�[�g�b�v���i�Ԗ��m��Ȃ玩���m�肷��
;;;       (KPAutoCT_HINKakutei);2008/06/24 YM DEL

        ; 03/05/07 YM ���g�p��ٰ�ߒ�`���폜����
        (KP_DelUnusedGroup)
      )
    );_if
  );_if

  (command-s "_purge" "bl" "*" "N")
  (command-s "_purge" "bl" "*" "N")
  (command-s "_purge" "bl" "*" "N")
  (command-s "_purge" "bl" "*" "N")

  ; 01/05/23 HN E-MOD �ۑ�������ύX
  ;@MOD@;;; @YM@ ST00/01/27  ���� (command "new" ".")��"new"���t�@�C�����Ƃ��ĔF�����Ȃ�����
  ;@MOD@;;;     (command "_.QSAVE")
  ;@MOD@    ;(command "_.SAVE" "") ; @YM@ 00/02/01 ;00/06/20 SN MOD
  ;@MOD@(command "_.save" (strcat (getvar "dwgprefix") (getvar "dwgname")));00/06/20 SN MOD
;-- 2011/10/06 A.Satoh Mod - S
;;;;;  (command "_.QSAVE")
;;;;;
;;;;;  (if (wcmatch (getvar "CMDNAMES") "*QSAVE*")
;;;;;    (command "2000" "")
;;;;;  );_if
  (setq #sFname (strcat (getvar "dwgprefix") (getvar "dwgname")))
  (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
          (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
    (setq #ver CG_DWG_VER_MODEL)
    (setq #ver CG_DWG_VER_SEKOU)
  )
(princ #sFname)
  (command-s "_.SAVEAS" #ver #sFName)
;-- 2011/10/06 A.Satoh Mod - E

  (princ)
) ;_CFAutoSave

;<HOM>*************************************************************************
; <�֐���>    : C:AutoSave
; <�����T�v>  : �ۑ��R�}���h
; <�߂�l>    : �Ȃ�
; <�쐬>      : ???
; <�C��>      : 01/09/03 YM
; <���l>      : (�����i�Ԋm�莸�s����ƶ�����̐F���߂�Ȃ����ߴװ������ǉ�����)
;*************************************************************************>MOH<
(defun C:AutoSave()

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �O����
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  (CFAutoSave)

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �㏈��
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

);00/06/29 SN ADD

;<HOM>*************************************************************************
; <�֐���>    : CFGetDBSQLHinbanTable
; <�����T�v>  : �i�Ԋ֘A�e�[�u����������
; <�߂�l>    :
;        LIST : �i�Ԋ֘A�e�[�u���̃��R�[�h���e���X�g
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun CFGetDBSQLHinbanTable (
    &tblName           ;(STR)�e�[�u������
                       ;      1:�i�Ԑ}�`
                       ;      2:�i�Ԋ�{
                       ;      3:�i�ԍŏI
    &hinban            ;(STR)�i�Ԗ���
    &sql$              ;(LIST)��������
    /
    #qry$ #qry$$ #dbSession
  )

;;; (princ "\n &tblName=")(princ &tblName)
;;; (princ "\n &hinban=") (princ &hinban)
;;; (princ "\n &sql$=")   (princ &sql$)

  ;// �i�Ԗ��̂ŏ��i�K�w�e�[�u�����������A�f�[�^�x�[�X�����肷��
  ;(setq #qry$
  ;  (car (CFGetDBSQLRec CG_DBSESSION "���i�K�w"
  ;          (list
  ;            (list "�K�w����"     &hinban          'STR)
  ;          )
  ;       )
  ;  )
  ;)
  (setq #qry$ nil)
  (if (= #qry$ nil)
    (progn
      ;(princ "\n---------------------------------------------")
      ;(princ "\n���i�K�w�e�[�u���ɊY������i�Ԃ�����܂���.")
      ;(princ "\n�����I�ɋ���DB,SERIES��DB���������܂�.")
      ;(princ "\n�i��:[")
      ;(princ &hinban)
      ;(princ "]")
      ;(princ "\n---------------------------------------------")
      ;// �i�Ԋ֘A�̃e�[�u�����������A��v���郌�R�[�h��Ԃ�
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION &tblName
           &sql$
        )
      )
      (if (= #qry$$ nil)
        (setq #qry$$
          (CFGetDBSQLRec CG_CDBSESSION &tblName
             &sql$
          )
        )
      )
    )
    (progn
      (if (= (fix (nth 3 #qry$)) 0)  ;SERIES�ʕi��
        (progn
          (setq #dbSession CG_DBSESSION)
          ;(princ "\nSERIES�ʕi��:")
          ;(princ &hinban)
          ;(princ "]")
        )
        (progn
          (setq #dbSession CG_CDBSESSION)
          ;(princ "\n���ʕi��:[")
          ;(princ &hinban)
          ;(princ "]")
        )
      )
      ;// �i�Ԋ֘A�̃e�[�u�����������A��v���郌�R�[�h��Ԃ�
      (setq #qry$$
        (CFGetDBSQLRec #dbSession &tblName
          &sql$
        )
      )
    )
  )
  #qry$$
)
;CFGetDBSQLHinbanTable

;;;<HOM>************************************************************************
;;; <�֐���>  : SKXRotate
;;; <�����T�v>: �r���[���_���������E��]
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKXRotate (
  &ang        ;(INT) 1:�v���X���� 2:�}�C�i�X����
  /
  #vp
  #angX
  )

  (if (/= "MODEL.DWG" (strcase (getvar "DWGNAME")))
    (if (= (getvar "TILEMODE") 0)
      (command-s "_.MSPACE")
      (CFAlertErr "�}�ʎQ�Ǝ��͉�]�ł��܂���")
    )
  )
  (setq #vp  (getvar "VIEWDIR"))
  (if (and (equal (car #vp) 0 0.0001)(equal (cadr #vp) 0 0.0001))
    (progn ; �^��A�^�����猩�Ă���Ƃ�
      (command-s "._ucs" "V")
      (setvar "ucsfollow" 1)
      (command-s "._ucs" "Z" &ang)
      (setvar "ucsfollow" 0)
      (command-s "._ucs" "W")
    )
    (progn
      (setq #angX (rtd (angle (list 0.0 0.0 0.0) (list (car #vp) (cadr #vp)))))
      (setq #angX (+ #angX &ang))
      (if (> #angX  180.0) (setq #angX (* -1.0 (- 360.0 #angX))))
      (if (< #angX -180.0) (setq #angX         (+ 360.0 #angX) ))

;;;     (princ "\n angX =")(princ #angX )(terpri)
      (command-s "_.dview" "all" "" "ca" "" #angX "X")
    )
  );_if

  (if (/= "MODEL.DWG" (strcase (getvar "DWGNAME")))
    (if (= (getvar "TILEMODE") 0)
      (command-s "_.PSPACE")
    )
  )
  (princ)
)
;;;SKXRotate

;<HOM>*************************************************************************
; <�֐���>    : SKYRotate
; <�����T�v>  : �r���[���_�������㉺��]
; <���l>      :
;*************************************************************************>MOH<
(defun SKYRotate (
  &ang  ;(INT) 1:�v���X���� 2:�}�C�i�X����
  /
  #vp #angX #angXY #sqrt
  )
  (if (/= "MODEL.DWG" (strcase (getvar "DWGNAME")))
    (if (= (getvar "TILEMODE") 0)
      (command-s "_.MSPACE")
      (CFAlertErr "�}�ʎQ�Ǝ��͉�]�ł��܂���")
    )
  )
  (setq #vp (getvar "VIEWDIR"))
  (setq #sqrt (sqrt (+ (* (car #vp) (car #vp)) (* (cadr #vp) (cadr #vp)))))
  ;(if (/= (atof (rtos #sqrt 2 2)) 0.0)
    (progn
      (setq #angXY (rtd (atan (/ (caddr #vp) #sqrt))))
      (setq #angXY (+ #angXY &ang))
      (if (>= #angXY  89.99999) (setq #angXY  90.0))
      (if (<= #angXY -89.99999) (setq #angXY -90.0))

;;;      (if (> #angXY  90) (setq #angXY  89.99999))
;;;      (if (< #angXY -90) (setq #angXY -89.99999))

      (setq #angX (rtd (angle (list 0.0 0.0 0.0) (list (car #vp) (cadr #vp)))))
      (if (> #angX  180.0) (setq #angX (* -1.0 (- 360.0 #angX))))
      (if (< #angX -180.0) (setq #angX         (+ 360.0 #angX) ))

;;;     (princ "\n angXY=")(princ #angXY)(terpri)
;;;     (princ "\n angX =")(princ #angX )(terpri)
      (command-s "_.dview" "all" "" "ca" #angXY #angX "")

;;;      (command "_.dview" "all" "" "ca" "XY" #ang "" "")
;;;      (command "_.dview" "all" "" "ca" #ang "" "X")
    )
  ;)
  (if (/= "MODEL.DWG" (strcase (getvar "DWGNAME")))
    (if (= (getvar "TILEMODE") 0)
      (command-s "_.PSPACE")
    )
  )
)
;SKYRotate

;-- 2011/09/13 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : PKAutoTokuTenban
; <�����T�v>  : �����V������(հ�ް���f)
; <�߂�l>    : T  :2�������̋K�i�V�����݂��Ȃ��i�����������s�j
;             : nil:2�������̋K�i�V�����݂���i���������L�����Z���j
; <�쐬>      : 11/09/13 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
;(defun C:qqq (
(defun PKAutoTokuTenban (
  /
  #set_cnt #ss #wt$ #wt #i
  #wt_en #xd$ #tei #toku #pt$ #pt2$ #sym$ #sym #sui_cnt
  #wt_xd$ #hinban_dat$ #BG1 #BG2 #ret
  )

  (setq #set_cnt 0)

  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (and #ss (> (sslength #ss) 0))
    (progn
      (command-s "vpoint" "0,0,1")

;-- 2011/12/26 A.Satoh Add - S
			(command-s "_ZOOM" "E")
			(command-s "_ZOOM" "0.8x")
;-- 2011/12/26 A.Satoh Add - E

      (setq #wt$ '())
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #wt_en (ssname #ss #i))
        (setq #xd$ (CFGetXData #wt_en "G_WRKT"))
        (setq #wt_xd$ (CFGetXData #wt_en "G_WTSET"))
        (setq #tei (nth 38 #xd$))          ; WT��ʐ}�`�����
        (setq #toku (nth 58 #xd$))         ; �����t���O�@"":�K�i�V�@"TOKU":�����V��
        (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��
        (setq #pt2$ (append #pt$ (list (car #pt$)))) ; �I�_�̎��Ɏn�_��ǉ����ė̈���͂�
        ; �̈�Ɋ܂܂��A�V���N,��������������
        (setq #sym$ (PKGetSinkSuisenSymCP #pt2$))

        ; ���������V���N�A�������X�g���琅���̌������߂�
        (setq #sui_cnt 0)
        (foreach #sym #sym$
          (if (= (nth 9 (CFGetXData #sym "G_LSYM")) CG_SKK_INT_SUI)   ; ����}�`
            (setq #sui_cnt (1+ #sui_cnt))
          )
        )

;-- 2012/01/13 A.Satoh Add - S
(princ "\n������G_WTSET �F") (princ #wt_xd$)
(princ "\n�����������t���O�F") (princ #toku)
;-- 2012/01/13 A.Satoh Add - E
;-- 2011/12/26 A.Satoh Add - S
(princ "\n�����������̐��F") (princ #sui_cnt)
;-- 2011/12/26 A.Satoh Add - E

        (if (and #wt_xd$ (= #toku "") (/= #sui_cnt 1))
          (progn
            (setq #wt$ (append #wt$ (list #wt_en))) ; �K�i�V�Ő�����1�łȂ��v�sؽ�
          )
        )

        (setq #i (1+ #i))
      );_repeat

;-- 2011/12/26 A.Satoh Add - S
      (command-s "zoom" "p")
      (command-s "zoom" "p")
;-- 2011/12/26 A.Satoh Add - E
      (command-s "zoom" "p")

;-- 2012/01/13 A.Satoh Add - S
(princ "\n�������������ΏۓV�F") (princ #wt$)


;-- 2012/01/13 A.Satoh Add - E
      (if #wt$
        (if (CFYesDialog "���[�N�g�b�v�̓��������s���܂��B")
          (progn

						; 2019/03/04 YM MOD �ꍇ�킯
						(cond
							((= BU_CODE_0013 "1") ; PSKC�̏ꍇ
								(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
							)
							((= BU_CODE_0013 "2") ; PSKD�̏ꍇ
								(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
							)
							(T ;����ȊO
								(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
							)
						);_if
						; 2019/03/04 YM MOD �ꍇ�킯

            (CFCmdDefBegin 0)
            (CFNoSnapReset)
            (foreach #wt #wt$
              (setq #xd$ (CFGetXData #wt "G_WRKT"))
              (setq #wt_xd$ (CFGetXData #wt "G_WTSET"))
              (PCW_ChColWT #wt "MAGENTA" nil)
              (setq #hinban_dat$
                (list
                  0                  ; �����t���O
;;;                  "ZZ6500"           ; �i��
                  #CG_TOKU_HINBAN     ; �i�� 2016/08/30 YM ADD (1)�V�Ȃ̂ŋ@��ȊO 2019/03/04 YM MOD �ꍇ�킯
                  "0"                ; ���z
                  (nth 5 #wt_xd$)    ; ��
                  (nth 6 #wt_xd$)    ; ����
                  (nth 7 #wt_xd$)    ; ���s

                  (nth 4 #wt_xd$)    ; �i�� 2016/10/31 YM MOD ���������ɖ߂��� EASY�Ƃ̘A�g
;;;									CG_TOKU_HINMEI     ; �i�� 2016/08/30 YM ADD�@�����������́A�����I�ɁA����ɂ��Ă͂����Ȃ�

                  (nth 8 #wt_xd$)    ; �����R�[�h
                )
              )

              ; �V�i���m��_�C�A���O����
;-- 2011/12/12 A.Satoh Mod - S
;;;;;              (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$))
              (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$ (nth 3 #xd$)))
;-- 2011/12/12 A.Satoh Mod - S
              (if (/= #hinban_dat$ nil)
                (progn
                  (CFSetXData #wt "G_WTSET" (CFModList #wt_xd$
                      (list
                        (list 0 (nth 0 #hinban_dat$))
                        (list 1 (nth 1 #hinban_dat$))
                        (list 3 (nth 2 #hinban_dat$))
                        (list 4 (nth 6 #hinban_dat$))
                        (list 5 (nth 3 #hinban_dat$))
                        (list 6 (nth 4 #hinban_dat$))
                        (list 7 (nth 5 #hinban_dat$))
                        (list 8 (nth 7 #hinban_dat$))
                      ))
                  )
                  (CFSetXData #wt "G_WRKT" (CFModList #xd$ (list (list 58 "TOKU"))))

                  (command-s "_.change" #wt "" "P" "C" CG_WorkTopCol "")
                  ;;; BG,FG���ꏏ�ɐF�ւ�����
                  (setq #BG1 (nth 49 #xd$))
                  (setq #BG2 (nth 50 #xd$))
                  (if (/= #BG1 "")
                    (progn
                      (if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
                        (command-s "_.change" #BG1 "" "P" "C" CG_WorkTopCol "")
                      )
                    )
                  );_if
                  (if (/= #BG2 "")
                    (progn
                      (if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
                        (command-s "_.change" #BG2 "" "P" "C" CG_WorkTopCol "")
                      )
                    )
                  );_if
                )
                (progn
                  (PCW_ChColWT #wt CG_WorkTopCol nil)
                  (setq #set_cnt (1+ #set_cnt))
                )
              )
            )
            (CFNoSnapFinish)
            (CFCmdDefFinish)
          )
        )
      );_if
    )
  )

  (if (= #set_cnt 0)
    (setq #ret T)
    (setq #ret nil)
  )

  #ret

);PKAutoTokuTenban
;-- 2011/09/13 A.Satoh Add - E

;-- 2011/10/14 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : KPCAD_StopCancelDlg
; <�����T�v>  : ���f�I��/�j���I���̑I���_�C�A���O�������s��
; <�߂�l>    : T  : ���f�I��
;             : nil: �j���I��
; <�쐬>      : 2011/10/14 (A.Satoh)
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KPCAD_StopCancelDlg (
  /
  #dcl_id #ret
  )

  ; DCL���[�h
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kscmain.dcl")))
  (if (not (new_dialog "KPCAD_StopOrCancelDlg" #dcl_id)) (exit))

  ; �{�^����������
  (action_tile "accept" "(setq #ret 2) (done_dialog)")
  (action_tile "haki"   "(setq #ret 3) (done_dialog)")
  (action_tile "cancel" "(setq #ret 0) (done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)

  #ret

) ;KPCAD_StopCancelDlg


;<HOM>*************************************************************************
; <�֐���>    : KPCAD_FixEndDlg
; <�����T�v>  : KPCAD�I���_�C�A���O�������s��
; <�߂�l>    : 1: �m��I��
;             : 2: ���f�I��
;             : 3: �j���I��
;             : 0: �L�����Z��
; <�쐬>      : 2011/10/14 (A.Satoh)
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KPCAD_FixEndDlg (
  /
  #dcl_id #ret
  )

  ; DCL���[�h
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kscmain.dcl")))
  (if (not (new_dialog "KPCAD_FixEndDlg" #dcl_id)) (exit))

  ; �{�^����������
  (action_tile "accept" "(setq #ret 1) (done_dialog)")
  (action_tile "stop"   "(setq #ret 2) (done_dialog)")
  (action_tile "haki"   "(setq #ret 3) (done_dialog)")
  (action_tile "cancel" "(setq #ret 0) (done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)

  #ret

) ;KPCAD_FixEndDlg


;<HOM>*************************************************************************
; <�֐���>    : KPCAD_FixEnd
; <�����T�v>  : �m��I���������s��
; <�߂�l>    : T  : ����I��
;             : nil: �ُ�I��
; <�쐬>      : 2011/10/14 (A.Satoh)
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KPCAD_FixEnd (
  /
	#cancel #ret #planinfo$$ #planinfo$ #flag
#err_flag
  )

	; ���ވꊇ�m�F��ʂ�\������
	(C:ConfPartsAll)

	(setq #cancel nil)
	(setq #err_flag nil)

  ; ���݂̔���񓙂�Input.CFG�ɏ�������
	(setq #ret (CFOutInputCfg T))
	(if (= #ret nil)
		(progn
			(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
				(progn
					(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
					(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
				)
			)
			(setq #cancel T)
		)
	)

	(if (not (wcmatch CG_KENMEI_PATH "*BUKKEN*"))
		(progn
			(if (= #cancel nil)
				(if (findfile (strcat CG_SYSPATH "SelectUploadDWG.exe"))
					(progn
						(C:arxStartApp (strcat CG_SysPATH "SelectUploadDWG.exe") 1)
						(setq #planinfo$$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
						(if (= #planinfo$$ nil)
							(progn
								(princ (strcat "PLANINFO.CFG�̓Ǎ��Ɏ��s���܂����B\n" CG_KENMEI_PATH "PLANINFO.CFG"))
								(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
									(progn
										(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
										(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
									)
								)
								(setq #err_flag T)
							)
							(progn
								(setq #flag nil)
								(foreach #planinfo$ #planinfo$$
									(if (= (nth 0 #planinfo$) "[PDF_DXF_TARGET]")
										(setq #flag T)
									)
								)

								(if (= #flag nil)
									(progn
										(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
											(progn
												(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
												(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
											)
										)
										(setq #cancel T)
									)
								)
							)
						)
					)
					(progn
						(princ "UPLOAD�Ώې}�ʑI��Ӽޭ��(SelectUploadDWG.exe)������܂���B")
						(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
							(progn
								(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
								(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
							)
						)
						(setq #err_flag T)
					)
				)
			)
		)
	)

	(if (= #cancel nil)
		(progn
			(if (= #err_flag T)
				(CFAlertMsg "KPCAD�I�������ŃG���[���������܂����B�����I�����܂��B\n�}�ʂ͌���̏�Ԃ��ێ�����܂��B")
			)

			; running.flg���폜����
			(if (findfile (strcat CG_KENMEI_PATH "running.flg"))
				(vl-file-delete (strcat CG_KENMEI_PATH "running.flg"))
			)

			; input0.cfg���폜����
			(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
				(vl-file-delete (strcat CG_SYSPATH "Input0.cfg"))
			)

      ;// �����ۑ�
      (CFAutoSave)

      (setvar "PICKFIRST" 1) ;01/08/24 HN ADD �R�}���h�̔��s�O�ɃI�u�W�F�N�g��I��
      (setvar "GRIPS"1) ;�O���b�v��\��

      (command-s ".quit")
		)
	)

) ;KPCAD_FixEnd


;<HOM>*************************************************************************
; <�֐���>    : KPCAD_StopEnd
; <�����T�v>  : ���f�I���������s��
; <�߂�l>    : T  : ����I��
;             : nil: �ُ�I��
; <�쐬>      : 2011/10/14 (A.Satoh)
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KPCAD_StopEnd (
  /
	#cancel #ret
  )

	(setq #cancel nil)

  ; ���݂̔���񓙂�Input.CFG�ɏ�������
	(setq #ret (CFOutInputCfg nil))
	(if (= #ret nil)
		(progn
			(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
				(progn
					(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
					(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
				)
			)
			(setq #cancel T)
		)
	)

	(if (= #cancel nil)
		(progn
			; input0.cfg���폜����
			(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
				(vl-file-delete (strcat CG_SYSPATH "Input0.cfg"))
			)

      ;// �����ۑ�
      (CFAutoSave)

      (setvar "PICKFIRST" 1) ;01/08/24 HN ADD �R�}���h�̔��s�O�ɃI�u�W�F�N�g��I��
      (setvar "GRIPS"1) ;�O���b�v��\��

      (command-s ".quit")
		)
	)

) ;KPCAD_StopEnd


;<HOM>*************************************************************************
; <�֐���>    : KPCAD_CancelEnd
; <�����T�v>  : �j���I���������s��
; <�߂�l>    : T  : ���f�I��
;             : nil: �j���I��
; <�쐬>      : 2011/10/14 (A.Satoh)
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KPCAD_CancelEnd (
  /
  #fid
  )

	(if (CFYesNoDialog "�}�ʈꎮ���j������܂��B�{���ɂ�낵���ł����H")
		(progn
			(setq #fid (open (strcat CG_KENMEI_PATH "Cancel.flg") "W"))
			(if #fid
				(progn
					(princ "Cancel.flg\n" #fid)
					(close #fid)

					(command-s ".quit" "Y")
				)
				(progn
					(CFAlertMsg "Cancel.flg�̍쐬�Ɏ��s���܂����B")
				)
			)
		)
	)

) ;KPCAD_CancelEnd
;-- 2011/10/14 A.Satoh Add - E


;-- 2012/01/27 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : KPCAD_CheckErrBuzai
; <�����T�v>  : �}�ʏ��G_LSYM���s���ɐݒ肳�ꂽ�}�`�������ނ�
;             : ���݂��邩�ۂ��̃`�F�b�N���s��
; <�߂�l>    : �G���[���ރV���{���}�`���X�g
;             : nil:�G���[���ނȂ�
; <�쐬>      : 2012/01/27 A.Satoh
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KPCAD_CheckErrBuzai (
  /
	#ename$ #ss #idx #en #xd_SYM$ #sym
  )

	(setq #ename$ nil)

	; G_LSYM�����}�`����������
	(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
	(if (/= #ss nil)
		(progn
			(setq #idx 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #idx))
				(setq #xd_SYM$ (CFGetXData #en "G_SYM"))
				(if (= #xd_SYM$ nil)
					(progn
						(setq #sym (SearchGroupSym #en))
						(setq #ename$ (append #ename$ (list #sym)))
					)
				)
				(setq #idx (1+ #idx))
			)
		)
	)

	#ename$

) ;KPCAD_CheckErrBuzai
;-- 2012/01/27 A.Satoh Add - E

;|

;<HOM>*************************************************************************
; <�֐���>    : SearchGroupSym
; <�����T�v>  : �w��}�`�̃O���[�v�̐e�}�`����������
; <�߂�l>    :
;       ENAME : �e�}�`��
; <�쐬>      : 1999-06-14
; <���l>      : &en ��nil�Ȃ痎����-->&en ��nil�Ȃ�nil��Ԃ�. 00/02/06 @YM@
;*************************************************************************>MOH<
(defun SearchGroupSym (
    &en
    /
;-- 2011/06/27 A.Satoh Mod - S
;    #en #330 #eg #eg$ #lsym #loop #i
    #lsym #eg1$ #eg1 #eg2$ #eg2 #i1 #i2 #loop1 #loop2 #330 #en
;-- 2011/06/27 A.Satoh Mod - E
  )

;-- 2011/06/27 A.Satoh Mod - S
  (setq #lsym nil)
  (if &en
    (progn
      (setq #eg1$ (entget &en))
      (setq #i1 0)
      (setq #loop1 T)
      (while (and #loop1 (< #i1 (length #eg1$)))
        (setq #eg1 (nth #i1 #eg1$))
        (if (= (car #eg1) 330)
          (progn
            (setq #330 (cdr #eg1))
            (if (/= #330 nil)
              (progn
                (setq #eg2$ (entget #330))
                (setq #i2 0)
                (setq #loop2 T)
                (while (and #loop2 (< #i2 (length #eg2$)))
                  (setq #eg2 (nth #i2 #eg2$))
                  (if (= (car #eg2) 340)
                    (progn
                      (setq #en (cdr #eg2))
                      (if (CFGetXData #en "G_SYM")
                        (progn
                          (setq #lsym #en)
                          (setq #loop1 nil)
                          (setq #loop2 nil)
                        )
                      )
                    )
                  )
                  (setq #i2 (1+ #i2))
                )
              )
            )
          )
        )
        (setq #i1 (1+ #i1))
      )
    )
  )

  #lsym

;  (if &en        ; 00/02/06 @YM@ ADD
;    (progn       ; 00/02/06 @YM@ ADD
;      (setq #330 (cdr (assoc 330 (entget &en))))
;      (if (/= #330 nil)
;        (progn
;          (setq #eg$ (entget #330))
;          (setq #i 0)
;          (setq #loop T)
;          (while (and #loop (< #i (length #eg$)))
;            (setq #eg (nth #i #eg$))
;            (if (= (car #eg) 340)
;              (progn
;                (setq #en (cdr #eg))
;                (if (CFGetXData #en "G_SYM")
;                  (progn
;                    (setq #lsym #en)
;                    (setq #loop nil)
;                  )
;                )
;              )
;            )
;            (setq #i (1+ #i))
;          )
;          #lsym
;        )
;        (progn   ; 00/02/06 @YM@ ADD
;          nil    ; 00/02/06 @YM@ ADD
;        )        ; 00/02/06 @YM@ ADD
;      );_(if     ; 00/02/06 @YM@ ADD
;    );_(progn    ; 00/02/06 @YM@ ADD
;    (progn       ; 00/02/06 @YM@ ADD
;      nil        ; 00/02/06 @YM@ ADD
;    );_(progn    ; 00/02/06 @YM@ ADD
;  );_(if &en     ; 00/02/06 @YM@ ADD
;-- 2011/06/27 A.Satoh Mod - E

)
;SearchGroupSym

;-- 2011/06/23 A.Satoh Mod - S
;(setq CFSearchGroupSym SearchGroupSym)
;<HOM>*************************************************************************
; <�֐���>    : CFSearchGroupSym
; <�����T�v>  : �w��}�`�̃O���[�v�̐e�}�`����������
; <�߂�l>    :
;       ENAME : �e�}�`��
; <�쐬>      : 1999-06-14
; <���l>      : &en ��nil�Ȃ痎����-->&en ��nil�Ȃ�nil��Ԃ�. 00/02/06 @YM@
;             : 2011/06/23 SearchGroupSym�̃R�s�[�ɂ��쐬
;             : (setq CFSearchGroupSym SearchGroupSym)�̑��
;*************************************************************************>MOH<
(defun CFSearchGroupSym (
    &en
    /
;-- 2011/06/27 A.Satoh Mod - S
;    #en #330 #eg #eg$ #lsym #loop #i
    #lsym #eg1$ #eg1 #eg2$ #eg2 #i1 #i2 #loop1 #loop2 #330 #en
;-- 2011/06/27 A.Satoh Mod - E
  )

;-- 2011/06/27 A.Satoh Mod - S
  (setq #lsym nil)
  (if &en
    (progn
      (setq #eg1$ (entget &en))
      (setq #i1 0)
      (setq #loop1 T)
      (while (and #loop1 (< #i1 (length #eg1$)))
        (setq #eg1 (nth #i1 #eg1$))
        (if (= (car #eg1) 330)
          (progn
            (setq #330 (cdr #eg1))
            (if (/= #330 nil)
              (progn
                (setq #eg2$ (entget #330))
                (setq #i2 0)
                (setq #loop2 T)
                (while (and #loop2 (< #i2 (length #eg2$)))
                  (setq #eg2 (nth #i2 #eg2$))
                  (if (= (car #eg2) 340)
                    (progn
                      (setq #en (cdr #eg2))
                      (if (CFGetXData #en "G_SYM")
                        (progn
                          (setq #lsym #en)
                          (setq #loop1 nil)
                          (setq #loop2 nil)
                        )
                      )
                    )
                  )
                  (setq #i2 (1+ #i2))
                )
              )
            )
          )
        )
        (setq #i1 (1+ #i1))
      )
    )
  )

  #lsym

;  (if &en        ; 00/02/06 @YM@ ADD
;    (progn       ; 00/02/06 @YM@ ADD
;      (setq #330 (cdr (assoc 330 (entget &en))))
;      (if (/= #330 nil)
;        (progn
;          (setq #eg$ (entget #330))
;          (setq #i 0)
;          (setq #loop T)
;          (while (and #loop (< #i (length #eg$)))
;            (setq #eg (nth #i #eg$))
;            (if (= (car #eg) 340)
;              (progn
;                (setq #en (cdr #eg))
;                (if (CFGetXData #en "G_SYM")
;                  (progn
;                    (setq #lsym #en)
;                    (setq #loop nil)
;                  )
;                )
;              )
;            )
;            (setq #i (1+ #i))
;          )
;          #lsym
;        )
;        (progn   ; 00/02/06 @YM@ ADD
;          nil    ; 00/02/06 @YM@ ADD
;        )        ; 00/02/06 @YM@ ADD
;      );_(if     ; 00/02/06 @YM@ ADD
;    );_(progn    ; 00/02/06 @YM@ ADD
;    (progn       ; 00/02/06 @YM@ ADD
;      nil        ; 00/02/06 @YM@ ADD
;    );_(progn    ; 00/02/06 @YM@ ADD
;  );_(if &en     ; 00/02/06 @YM@ ADD
;-- 2011/06/27 A.Satoh Mod - E

)
;SearchGroupSym
;-- 2011/06/23 A.Satoh Mod - E

;<HOM>*************************************************************************
; <�֐���>    : SKC_GetSymInGroup
; <�����T�v>  : �O���[�v�}�`�̒�����V���{����_�}�`�𔲂��o��
; <�߂�l>    : �}�`��
; <�쐬>      : 1998-06-15
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SKC_GetSymInGroup (
    &en   ;(ENAME)�O���[�v�̎q�}�`��
    /
    #eg$
    #lst
    #en$
    #en
    #i
    #loop
  )
  (setq #eg$ (entget (cdr (assoc 330 (entget &en)))))  ;// �e�}�ʏ����擾

  (setq #i 0)
  (setq #loop T)
  (while (and #loop (< #i (length #eg$)))
  ;(foreach #lst #eg$  ;// ��ٰ�����ް�}�`�̎擾
    (setq #lst (nth #i #eg$))
    (if (= 340 (car #lst))
      (progn
        (if (or
          (/= nil (assoc -3 (entget (cdr #lst) '("G_SYM"))))
          (/= nil (assoc -3 (entget (cdr #lst) '("G_WRKT"))))
          (/= nil (assoc -3 (entget (cdr #lst) '("G_FILR"))))
          )
          (progn
            (setq #en (cdr #lst))
            (setq #loop nil)
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
  ;// �}�`����Ԃ�
  #en
)
;SKC_GetSymInGroup

|;

;<HOM>*************************************************************************
; <�֐���>    : SKC_GetSymInGroup
; <�����T�v>  : �O���[�v�}�`�̒�����V���{����_�}�`�𔲂��o��
; <�߂�l>    : �}�`��
; <�쐬>      : 1998-06-15
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SKC_GetSymInGroup (
    &en   ;(ENAME)�O���[�v�̎q�}�`��
    /
    #eg$
    #lst
    #en$
    #en
    #i
    #loop
  )
;|
  2014.02.06 ���[�ɂ̂b�f�쐬�ł��Ȃ���
             G_SYM�擾�s�� �i�ŏ��̃f�[�^���A�n�b�`���O�̏ꍇ�擾�o���Ȃ�
  (setq #eg$ (entget (cdr (assoc 330 (entget &en)))))  ;// �e�}�ʏ����擾
|;
; 
  (setq #eg$ (entget &en))
  (setq #i 0)
  (setq #loop T)
  (while (and #loop (< #i (length #eg$)))
    (setq #lst (nth #i #eg$))
    (if (= 330 (car #lst))
      (progn
        (if (= (cdr (assoc 0 (entget (cdr #lst)))) "GROUP")
          (progn
            (setq #eg$ (entget (cdr #lst)))
            (setq #loop nil)
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
  (setq #i 0)
  (setq #loop T)
  (while (and #loop (< #i (length #eg$)))
  ;(foreach #lst #eg$  ;// ��ٰ�����ް�}�`�̎擾
    (setq #lst (nth #i #eg$))
    (if (= 340 (car #lst))
      (progn
        (if (or
          (/= nil (assoc -3 (entget (cdr #lst) '("G_SYM"))))
          (/= nil (assoc -3 (entget (cdr #lst) '("G_WRKT"))))
          (/= nil (assoc -3 (entget (cdr #lst) '("G_FILR"))))
          )
          (progn
            (setq #en (cdr #lst))
            (setq #loop nil)
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
  ;// �}�`����Ԃ�
  #en
)
;SKC_GetSymInGroup

;2014/02/10 YM MDO-S 3�̊֐��𒆐g����
(setq CFSearchGroupSym SKC_GetSymInGroup)
(setq SearchGroupSym   SKC_GetSymInGroup)
;2014/02/10 YM MDO-E 3�̊֐��𒆐g����

(princ)
