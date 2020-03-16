;;; �֐������p
;;;(defun PKStartCOMMAND ( / )
;;;(defun PKEndCOMMAND ( &lst / )

; �ҏW�R�}���h
;;;(defun C:MoveParts
;;;(defun Move
;;;(defun C:SurfaceMoveParts
;;;(defun SurfaceMove
;;;(defun C:RotateParts
;;;(defun Rotate
;;;(defun C:CopyParts
;;;(defun Copy
;;;(defun C:CopyRotateParts
;;;(defun CopyRotate
;;;(defun C:Z_MoveParts
;;;(defun Z_Move
;;;(defun C:Z_CopyParts
;;;(defun Z_Copy

; <�֐���>    : C:RotateCAB ���̏�ŷ���ȯĂ���]������(���ʁA�w�ʂ�����ւ��)
; <�֐���>    : PcCabCutCall �I����������ȯĕ��ނ̒���J�b�g����R�}���h(�Ăяo���p)


; H800 �L�k����

;;;(defun PcCabCutSub
;;;(defun PcRemakePrim_CabCut
;;;(defun PcSlice_Down

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKStartCOMMAND
;;; <�����T�v>  : ���ѕϐ��̐ݒ�
;;; <����>      : �Ȃ�
;;; <�߂�l>    : ���ѕϐ�ؽ�
;;; <�쐬>      : 2000.6.9 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKStartCOMMAND ( / #sm)

;;; ���ѕϐ��ݒ�
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (setq #sm (getvar "SNAPMODE" ))
  (setvar "SNAPMODE"  0)
  (list #sm)
);PKStartCOMMAND

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKEndCOMMAND
;;; <�����T�v>  : ���ѕϐ��̐ݒ��߂�
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.9 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKEndCOMMAND ( &lst / #sm)
;;; ���ѕϐ��ݒ��߂�
  (setq #sm (nth 0 &lst))
  (setvar "SNAPMODE" #sm)
  (princ)
);PKEndCOMMAND

;<HOM>*************************************************************************
; <�֐���>    : C:MoveParts
; <�����T�v>  : �ݔ��ړ��R�}���h
; <�߂�l>    :
; <�쐬>      : 1999-12-2
; <���l>      :
;*************************************************************************>MOH<
(defun C:MoveParts(
  /
  #ss             ; �I���������ׂẴO���[�v�̑I���Z�b�g(�ړ��Ώ�)
#SYS$ #RET$
  )
  (StartUndoErr);00/10/02 SN MOD UNDO�����֐��ύX
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  ;00/09/22 SN MOD ���ёI���֐���ύX
  (setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_ConfSymCol))
  ;00/09/22 SN MOD �I��Ă̵�޼ު�Đ�����������B
  (if (> (sslength #ss) 0)
		(progn
	    (setq #ret$ (Move #ss))                         ; �v�f�̈ړ� ��_,�ړI�_ؽ�
			; "G_LSYM"(�}���_)�X�V 01/04/27 YM ������
	    (ChgLSYM1 #ss)
	    (SetG_WRKT "MOVE" #ss (car #ret$)(cadr #ret$)) ; "G_WRKT"(WT����_)�g���f�[�^�̕ύX
  	)
	);_if
  (setq *error* nil)                              ; �㏈��
  (setq EditFlag nil)
  (CFCmdDefFinish);00/09/13 SN ADD
  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
	(princ "\n�ړ����܂����B")
  (princ)
);C:MoveParts

;<HOM>*************************************************************************
; <�֐���>    : Move
; <�����T�v>  : �ݔ��ړ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-12-2
; <���l>      :
;*************************************************************************>MOH<
(defun Move(
  &ss
  /
  #bpt            ; �ړ��̊�_
  #lpt            ; �ړ��_
  #org            ; ���̑}���_
  #os #SS
  )

  (setq #bpt (getpoint "\n��_ : "))
  (princ "\n�ړI�_: ")

  ;00/09/22 SN MOD �F�߂������ʊ֐�
  (ChangeItemColor &ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; �F��߂�
  ;)

  (setq EditFlag 1)
        ;;; 06/21 SN MOD ����і����̎��ړ��s�̕s���
  (if (and (CFGetXRecord "BASESYM")                          ; ����т����ݒ�
      (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss)) ; ����т� &ss �ɓ����Ă���
  ;;; 06/10 YM ADD ����т̏ꍇ�����ړ�
  ;(if (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss) ; ����т� &ss �ɓ����Ă���
    (progn
      (setq #ss (ssget "X" '((-3 ("G_ARW"))))) ; �����ړ�����
      (CMN_ssaddss #ss &ss)
    )
  );_if

  (command ".MOVE" &ss "" #bpt PAUSE)
  (setq #lpt (getvar "LASTPOINT"))
  (if (= nil (equal (caddr #lpt) (caddr #bpt) 0.0001))
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command ".MOVE" &ss "" "0,0,0" (list 0 0 (- (caddr #bpt) (caddr #lpt))))
      (setvar "OSMODE" #os)
    );_progn
  );_if
  (list #bpt #lpt) ; ��_,�ړI�_ؽ�
)

;<HOM>*************************************************************************
; <�֐���>    : C:SurfaceMoveParts
; <�����T�v>  : �ݔ��ʍ��킹�ړ��R�}���h
; <�߂�l>    :
; <�쐬>      : 1999-12-2 YM
; <���l>      :
;*************************************************************************>MOH<
(defun C:SurfaceMoveParts(
  /
  #v_angbase
  #v_angdir
  #ss             ; �I���������ׂẴO���[�v�̑I���Z�b�g(�ړ��Ώ�)
  #sa_ang         ; ��]�p�x
#SYS$
  )
  (StartUndoErr);00/10/02 SN MOD UNDO�����֐��ύX
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  (setq #v_angbase (getvar "ANGBASE"))
  (setvar "ANGBASE" 0)                         ; ANGBASE�̃f�t�H���g��
  (setq #v_angdir (getvar "ANGDIR"))
  (setvar "ANGDIR" 0)                          ; ANGDIR�̃f�t�H���g��
  ;00/09/22 SN MOD ���ёI���֐���ύX
  (setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
  ;00/09/22 SN MOD �I��Ă̵�޼ު�Đ�����������B
  (if (> (sslength #ss) 0)
		(progn
	    (setq #sa_ang (SurfaceMove #ss))             ; �v�f�̈ړ�
 			; "G_LSYM"(�}���_,��]�p�x)�X�V 01/04/27 YM
	    (ChgLSYM12 #ss #sa_ang) ; ������

	    (setvar "ANGBASE" #v_angbase)                ; ANGBASE��߂�
	    (setvar "ANGDIR" #v_angdir)                  ; ANGDIR��߂�
  	)
	);end if - progn
  (setq *error* nil)                           ; �㏈��
  (setq EditFlag nil)
  (CFCmdDefFinish);00/09/13 SN ADD
  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
	(princ "\n�ʍ��킹���܂����B")
  (princ)

);_(defun

;<HOM>*************************************************************************
; <�֐���>    : SurfaceMove
; <�����T�v>  : �ݔ��ʍ��킹�ړ�
; <�߂�l>    : ��]�p�x
; <�쐬>      : 1999-12-2 YM
; <���l>      :
;*************************************************************************>MOH<
(defun SurfaceMove(
  &ss
  /
  #sa_ang         ; ��]�p�x
  #bpt            ; �ړ��̊�_(1)
  #rpt            ; �ړ����ʍ��킹����(2)
  #rptn           ; #rpt�ɑΉ�����_
  #lpt            ; �ړ����_(3)
  #os
  #pt1            ; ��]�O�Q�Ɠ_
  #pt2            ; ��]��Q�Ɠ_
  #en_cf #SS
  #bsym           ; 00/08/22 SN ADD �����
#hand #sym ;-- 2012/03/08 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή�
  )

  (initget 1)
  (setq #bpt (getpoint "\n�ړ�����_: "))            ; (1)
  (initget 1)
  (setq #rpt (getpoint #bpt "\n�ړ����ʍ��킹����: ")) ; (2) #bpt���烉�o�[�o���h������.
  (princ "\n�ړ����_: ")

  ;00/09/22 SN MOD �F�߂������ʊ֐�
  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; �F��߂�
  ;)
  (setq EditFlag 1)
  ;;; 06/10 YM ADD ����т̏ꍇ������
  ; 00/08/22 SN MOD ����т̑��݂����O����
  (if (and (setq #bsym (car (CFGetXRecord "BASESYM"))); ����ѐݒ肠�� ����
      (ssmemb (handent #bsym) &ss))                   ; ����т� &ss �ɓ����Ă���
;  (if (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss) ; ����т� &ss �ɓ����Ă���
    (progn
      (setq #ss (ssget "X" '((-3 ("G_ARW"))))) ; �����ړ�����
      (CMN_ssaddss #ss &ss)
    )
  );_if

  (command ".MOVE" &ss "" #bpt PAUSE)
  (setq #lpt (getvar "LASTPOINT"))                      ; (3)

  (if (= nil (equal (caddr #lpt) (caddr #bpt) 0.0001))
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command ".MOVE" &ss "" "0,0,0" (list 0 0 (- (caddr #bpt) (caddr #lpt)))) ; ��_�̂����W�ɍ��킹��.
      (setvar "OSMODE" #os)
    ); _progn
  );_if

  (setq #rptn (mapcar '+ #rpt (mapcar '- #lpt #bpt)))

  (princ "\n�ړ���ʍ��킹����: ")
  ;;; ��]�O�Q�Ɠ_ ;;;
;-- 2012/03/08 A.Satoh Mod �z�u�p�x�ݒ�s���̑Ή� - S
;;;;;  (setq #pt1 (cdr (assoc 10 (entget (SearchGroupSym (ssname &ss 0))))))
	(setq #sym (SearchGroupSym (ssname &ss 0)))
  (setq #pt1 (cdr (assoc 10 (entget #sym))))
  (setq #hand (cdr (assoc 5 (entget #sym))))
;-- 2012/03/08 A.Satoh Mod �z�u�p�x�ݒ�s���̑Ή� - E
  (setq #en_cf nil)
  (if (< (distance #pt1 #lpt) 0.1)                                        ; ��_���e�}�`�_�Ɠ����ꍇ
    (progn
      (setq #pt1 (mapcar '+ #pt1 '(50.0 50.0 0.0)))                       ; �Q�Ɠ_�̕��s�ړ�
      (entmake (list (cons 0 "POINT") (cons 62 2) (list 10 (car #pt1) (cadr #pt1) (caddr #pt1)) )) ; �Q�Ɠ_��}�ʂɍ쐬
      (setq #en_cf (entlast))
      (setq &ss (ssadd #en_cf &ss)) ; �쐬�����Q�Ɠ_���ꏏ�ɉ�]����.
    );_(progn
  );if

  (command ".ROTATE" &ss "" #lpt "R" #lpt #rptn PAUSE)
  ;;; ��]��Q�Ɠ_ ;;;
;-- 2012/03/08 A.Satoh Mod �z�u�p�x�ݒ�s���̑Ή� - S
;;;;;  (setq #pt2 (cdr (assoc 10 (entget (SearchGroupSym (ssname &ss 0))))))
	(if (= (handent #hand) nil)
		(setq #pt2 (cdr (assoc 10 (entget (SearchGroupSym (ssname &ss 0))))))
  	(setq #pt2 (cdr (assoc 10 (entget (handent #hand)))))
	)
;-- 2012/03/08 A.Satoh Mod �z�u�p�x�ݒ�s���̑Ή� - E
  (if #en_cf
    (progn
      (setq #pt2 (cdr (assoc 10 (entget #en_cf))))
      (entdel #en_cf) ; �Q�Ɠ_���폜
    );_(progn
  );if

  (setq #sa_ang (- (angle #lpt #pt2) (angle #lpt #pt1))) ; ��]�O�Q�Ɠ_,��]��Q�Ɠ_�̊p�x��

)

;<HOM>*************************************************************************
; <�֐���>    : C:RotateParts
; <�����T�v>  : �ݔ���]�R�}���h
; <�߂�l>    :
; <�쐬>      : 1999-12-2 YM
; <���l>      :
;*************************************************************************>MOH<
(defun C:RotateParts(
  /
  #v_angbase
  #v_angdir
  #ss             ; �I���������ׂẴO���[�v�̑I���Z�b�g(��]�Ώ�)
  #sa_ang         ; ��]�p�x
#sys$ #BPT #RET$
  )
  (StartUndoErr);00/10/02 SN MOD UNDO�����֐��ύX
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  (setq #v_angbase (getvar "ANGBASE"))
  (setvar "ANGBASE" 0)                         ; ANGBASE�̃f�t�H���g��
  (setq #v_angdir (getvar "ANGDIR"))
  (setvar "ANGDIR" 0)                          ; ANGDIR�̃f�t�H���g��
  ;00/09/22 SN MOD ���ёI���֐���ύX
  (setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_ConfSymCol)) ; WT���Ώ� 01/04/27 YM MOD
  ;00/09/22 SN MOD �I��Ă̵�޼ު�Đ�����������B
  (if (> (sslength #ss) 0)
		(progn
	    (setq #ret$ (Rotate #ss))  ; �v�f�̉�]
	    (setq #bpt    (car  #ret$)) ; ��_
	    (setq #sa_ang (cadr #ret$)) ; �p�x
 			; "G_LSYM"(�}���_,��]�p�x)�X�V 01/04/27 YM
	    (ChgLSYM12 #ss #sa_ang) ; ������

	    (SetG_WRKT "ROT" #ss (car #ret$)(cadr #ret$)) ; "G_WRKT"(WT����_)�g���f�[�^�̕ύX

	    (setvar "ANGBASE" #v_angbase)                ; ANGBASE��߂�
	    (setvar "ANGDIR" #v_angdir)                  ; ANGDIR��߂�
  	)
	);end if - progn
  (setq *error* nil)                           ; �㏈��
  (setq EditFlag nil)
  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
  (CFCmdDefFinish);00/09/13 SN ADD
	(princ "\n��]���܂����B")
  (princ)
);C:RotateParts

;<HOM>*************************************************************************
; <�֐���>    : Rotate
; <�����T�v>  : �ݔ���]
; <�߂�l>    : ��]�p�x
; <�쐬>      : 1999-12-2 YM
; <���l>      :
;*************************************************************************>MOH<
(defun Rotate(
  &ss
  /
  #sa_ang         ; ��]�p�x
  #bpt            ; ��_
  #pt1            ; ��]�O�Q�Ɠ_
  #pt2            ; ��]��Q�Ɠ_
  #en_cf #ss #num #I #LOOP #SYM
#hand ;-- 2012/03/08 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή�
  )

  ;;; ��]�O�Q�Ɠ_ ;;;
	(setq #i 0 #loop T)
	(while (and #loop (< #i (sslength &ss)))
		(if (setq #sym (SearchGroupSym (ssname &ss #i)))
			(progn
		  	(setq #pt1 (cdr (assoc 10 (entget #sym))))
;-- 2012/03/08 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή� - S
				(setq #hand (cdr (assoc 5 (entget #sym))))
;-- 2012/03/08 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή� - E
				(setq #loop nil)
				(setq #num #i)
			)
		);_if
		(setq #i (1+ #i))
	)
	(if #loop
		(progn
			(CFAlertMsg "�L���r�l�b�g���܂܂�Ă��Ȃ��̂ŉ�]�ł��܂���B")
			(quit)
		)
	);_if

  (setq #bpt (getpoint "\n��_: "))
	(princ "\n��]�p�x: ") ; 01/05/10 YM ADD

  ;00/09/22 SN MOD �F�߂������ʊ֐�
;;;01/04/27YM@  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
  (ChangeItemColor &ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; �F��߂�
  ;)
  (setq EditFlag 1)
  (setq #en_cf nil)
  (if (< (distance #pt1 #bpt) 0.1)                                        ; ��_���e�}�`�_�Ɠ����ꍇ
    (progn
      (setq #pt1 (mapcar '+ #pt1 '(50.0 50.0 0.0)))                       ; �Q�Ɠ_�̕��s�ړ�
      (entmake (list (cons 0 "POINT") (cons 62 2) (list 10 (car #pt1) (cadr #pt1) (caddr #pt1)) )) ; �Q�Ɠ_��}�ʂɍ쐬
      (setq #en_cf (entlast))
      (setq &ss (ssadd #en_cf &ss)) ; �쐬�����Q�Ɠ_���ꏏ�ɉ�]����.
    );_(progn
  );if

  ;;; 06/21 SN MOD ����і����̎��ړ��s�̕s���
  (if (and (CFGetXRecord "BASESYM")                          ; ����т����ݒ�
      (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss)) ; ����т� &ss �ɓ����Ă���
    (progn
      (setq #ss (ssget "X" '((-3 ("G_ARW"))))) ; �����ړ�����
      (CMN_ssaddss #ss &ss)
    )
  );_if

  (command ".ROTATE" &ss "" #bpt PAUSE)
  ;;; ��]��Q�Ɠ_ ;;;
;-- 2012/03/08 A.Satoh Mod �z�u�p�x�ݒ�s���̑Ή� - S
;;;;;  (setq #pt2 (cdr (assoc 10 (entget (SearchGroupSym (ssname &ss #num))))))
	(if (= (handent #hand) nil)
		(setq #pt2 (cdr (assoc 10 (entget (SearchGroupSym (ssname &ss #num))))))
  	(setq #pt2 (cdr (assoc 10 (entget (handent #hand)))))
	)
;-- 2012/03/08 A.Satoh Mod �z�u�p�x�ݒ�s���̑Ή� - E
  (if #en_cf
    (progn
      (setq #pt2 (cdr (assoc 10 (entget #en_cf))))
      (entdel #en_cf) ; �Q�Ɠ_���폜
    );_(progn
  );if

  (setq #sa_ang (- (angle #bpt #pt2) (angle #bpt #pt1)))      ; ��]�O�Q�Ɠ_,��]��Q�Ɠ_�̊p�x��
	(list #bpt #sa_ang) ; ��_,�p�x
);Rotate


;-- 2012/03/19 A.Satoh Mod �R�s�[�R�}���h�G���[�Ή� - S
;;;;;;<HOM>*************************************************************************
;;;;;; <�֐���>    : C:CopyParts
;;;;;; <�����T�v>  : �ݔ��R�s�[�R�}���h
;;;;;; <�߂�l>    :
;;;;;; <�쐬>      : 1999-12-2 YM
;;;;;; <���l>      :
;;;;;;*************************************************************************>MOH<
;;;;;(defun C:CopyParts(
;;;;;  /
;;;;;  #ss             ; �I���������ׂẴO���[�v�̑I���Z�b�g(�R�s�[�Ώ�)
;;;;;  #ss2            ; �R�s�[�����}�`�̑I���Z�b�g
;;;;;  #en_lis_#ss     ; �R�s�[�O�}�`�����X�g
;;;;;  #en_lis_#ss2    ; �R�s�[��}�`�����X�g
;;;;;#sys$
;;;;;  )
;;;;;
;;;;;  (StartUndoErr);00/10/02 SN MOD UNDO�����֐��ύX
;;;;;  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
;;;;;  (CFCmdDefBegin 6);00/09/13 SN ADD
;;;;;  ;00/09/22 SN MOD ���ёI���֐���ύX
;;;;;  (setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
;;;;;;;;  (setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_ConfSymCol))
;;;;;  ;00/09/22 SN MOD �I��Ă̵�޼ު�Đ�����������B
;;;;;  (if (> (sslength #ss) 0)
;;;;;		(progn
;;;;;	    (setq #ss2 (Copy #ss))                       ; �v�f�̃R�s�[
;;;;;	    (setq #en_lis_#ss  (CMN_ss_to_en  #ss))      ; �R�s�[�O�I���Z�b�g��n���Đ}�`���̃��X�g�𓾂�.
;;;;;	    (setq #en_lis_#ss2 (CMN_ss_to_en #ss2))      ; �R�s�[��I���Z�b�g��n���Đ}�`���̃��X�g�𓾂�.
;;;;;	    (SetG_PRIM22 #en_lis_#ss #en_lis_#ss2)       ; "G_PRIM"(��ʐ}�`)�g���f�[�^�̕ύX
;;;;;	    (SetG_BODY   #en_lis_#ss #en_lis_#ss2)       ; "G_BODY"(���}�`)�g���f�[�^�̕ύX
;;;;;;;;01/05/01YM@	    (SetG_LSYM11 #en_lis_#ss #en_lis_#ss2)       ; "G_LSYM"(�}���_)�g���f�[�^�̕ύX
;;;;;	    (ChgLSYM1_copy #en_lis_#ss #en_lis_#ss2)       ; "G_LSYM"(�}���_)�g���f�[�^�̕ύX 01/05/01 YM ������
;;;;;			(AfterCopySetDoorGroup #en_lis_#ss #en_lis_#ss2) ; 01/08/31 YM "ADD DoorGroup" �̾��
;;;;;
;;;;;  	)
;;;;;	);end if - progn
;;;;;  (setq *error* nil)                           ; �㏈��
;;;;;  (setq EditFlag nil)
;;;;;  (CFCmdDefFinish);00/09/13 SN ADD
;;;;;  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
;;;;;	(princ "\n�R�s�[���܂����B")
;;;;;  (princ)
;;;;;
;;;;;);_(defun
;;;;;
;;;;;
;<HOM>*************************************************************************
; <�֐���>    : C:CopyParts
; <�����T�v>  : �ݔ��R�s�[�R�}���h
; <�߂�l>    :
; <�쐬>      : 2012/03/15 A.Satoh
; <���l>      : ���R�s�[�R�}���h�ł́A�������̓��e�ɂ�萳��ɃR�s�[
;             : �ł��Ȃ����ނ�����ׁA�V�K�ɍ�蒼��
;*************************************************************************>MOH<
(defun C:CopyParts(
  /
	#cmdecho #osmode #pickstyle #sys$ #ss #cp_list$ #idx #sym$ #sym #fig$ #en
	#ItemInfo$ #ins_pt$ #ang #w_brk$ #d_brk$ #h_brk$
	)

	;****************************************************
	; �G���[����
	;****************************************************
	(defun CopyPartsUndoErr( &msg )
		(command "_undo" "b")
		(CFCmdDefFinish)
		(setq *error* nil)
		(princ)
	)
	;****************************************************

	(setq *error* CopyPartsUndoErr)
	(setq #cmdecho (getvar "CMDECHO"))
	(setq #osmode (getvar "OSMODE"))
	(setq #pickstyle (getvar "PICKSTYLE"))
	(setvar "CMDECHO" 0)
	(setvar "OSMODE" 0)
	(setvar "PICKSTYLE" 0)
	(command "_undo" "M")
	(command "_undo" "a" "off")

	(setq #sys$ (PKStartCOMMAND))
	(CFCmdDefBegin 6)

	; �R�s�[����A�C�e���̑I��
	(setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
	(if (> (sslength #ss) 0)
		(progn
			; �I��}�`�̃R�s�[�������s��
			; �@�z�u��_�����߂�ׂɐ}�`�����쐬����B
			; �@���쐬�����}�`�́A�z�u��_�擾��ɍ폜����B
			; �Ԃ�l�F�R�s�[��񃊃X�g
			;   ((��_���W���X�g "G_LSYM"��񃊃X�g) () () �E�E�E)
			(setq #cp_list$ (CopyParts_Copy #ss))

			; �I�������A�C�e������V���{����_���X�g���쐬����
			(setq #idx 0)
			(setq #sym$ nil)
			(repeat (sslength #ss)
				(if (CFGetXData (ssname #ss #idx) "G_LSYM")
					(if (not (member (ssname #ss #idx) #sym$))
						(setq #sym$ (append #sym$ (list (ssname #ss #idx))))
					)
				)
				(setq #idx (1+ #idx))
			)

			(setq #idx 0)
			(repeat (length #sym$)
				; �R�s�[���}�`�̃O���[�v�V���{�������o��
				(setq #sym (nth #idx #sym$))

				; �i�ԏ����쐬����
				(setq #ItemInfo$ (CopyParts_GetItemInfo #sym #cp_list$))

				; �V���{���z�u
				(setq #fig$    (nth 0 #ItemInfo$))
				(setq #ins_pt$ (nth 1 #ItemInfo$))
				(setq #ang     (nth 2 #ItemInfo$))
				(setq #w_brk$  (nth 3 #ItemInfo$))
				(setq #d_brk$  (nth 4 #ItemInfo$))
				(setq #h_brk$  (nth 5 #ItemInfo$))

				; �V���{���̔z�u���s��
				(CopyParts_PcSetItem #fig$ #ins_pt$ #ang #sym #w_brk$ #d_brk$ #h_brk$)

				(setq #idx (1+ #idx))
			)
		)
	)

	; �I������
	(CFCmdDefFinish)
	(PKEndCOMMAND #sys$)
	(setvar "CMDECHO" #cmdecho)
	(setvar "OSMODE" #osmode)
  (setvar "PICKSTYLE" #pickstyle)
	(setq *error* nil)
	(princ "\n�R�s�[���܂����B")
	(princ)

) ; C:CopyParts
;-- 2012/03/15 A.Satoh Mod �R�s�[�R�}���h�G���[�Ή� - E


;-- 2012/03/15 A.Satoh Add �R�s�[�R�}���h�G���[�Ή� - S
;<HOM>*************************************************************************
; <�֐���>    : CopyParts_Copy
; <�����T�v>  : ���ނ̃R�s�[�������s���A�R�s�[�}�`�̃V���{����_���W�y��
;             : "G_LSYM"����Ԃ�
; <�߂�l>    : �R�s�[��񃊃X�g
;             :   ((��_���W���X�g "G_LSYM"��񃊃X�g) () () �E�E�E)
; <�쐬>      : 2012/03/15 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun CopyParts_Copy (
	&ss   ; �R�s�[�Ώە��ނ̑I���Z�b�g
	/
	#idx #bpt #sym #ss_old #ss_new #ss #BaseEn #old_list$ #new_list$ #cp_list$
	#ret$ #pt$ #xd_LSYM$
	)

	; �R�s�[�O�̐}�ʂ���"G_LSYM"�����}�`�����o��
	(setq #ss_old (ssget "X" '((-3 ("G_LSYM")))))
	(setq #old_list$ nil)
	(setq #idx 0)
	(repeat (sslength #ss_old)
		(setq #old_list$ (append #old_list$ (list (ssname #ss_old #idx))))
		(setq #idx (1+ #idx))
	)

	; �R�s�[�������s��
	(setq #bpt (getpoint "\n��_: "))
	(princ "\n�ړI�_: ")

	; �F�߂�����
	(ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)

	(setq #BaseEn nil)
	(if (and
				(CFGetXRecord "BASESYM")                          ; ����т����� ����
				(ssmemb (setq #BaseEn (handent (car (CFGetXRecord "BASESYM")))) &ss)) ; ����т� &ss �ɓ����Ă���
		(GroupInSolidChgCol2 #BaseEn "BYLAYER")   ;BYLAYER�F�ɕύX
	)

	(command ".COPY" &ss "" #bpt PAUSE)

	; �R�s�[��̐}�ʂ���"G_LSYM"�����}�`�����o��
	(setq #ss_new (ssget "X" '((-3 ("G_LSYM")))))
	(setq #new_list$ nil)
	(setq #idx 0)
	(repeat (sslength #ss_new)
		(setq #new_list$ (append #new_list$ (list (ssname #ss_new #idx))))
		(setq #idx (1+ #idx))
	)

	; �R�s�[�}�`�݂̂̃��X�g���쐬����
	(setq #cp_list$ nil)
	(setq #idx 0)
	(repeat (length #new_list$)
		(setq #sym (nth #idx #new_list$))
		(if (not (member #sym #old_list$))
			(setq #cp_list$ (append #cp_list$ (list #sym)))
		)
		(setq #idx (1+ #idx))
	)

	; �V���{����_�y��"G_LSYM"�����擾
	(setq #ret$ nil)
	(setq #idx 0)
	(repeat (length #cp_list$)
		(setq #pt$ (cdr (assoc 10 (entget (nth #idx #cp_list$)))))
		(setq #xd_LSYM$ (CFGetXData (nth #idx #cp_list$) "G_LSYM"))
		(setq #ret$ (append #ret$ (list (list #pt$ #xd_LSYM$))))
		(setq #idx (1+ #idx))
	)

	(if #BaseEn
		(GroupInSolidChgCol #BaseEn CG_BaseSymCol) ;����ѐF�ɕύX
	)

	; �R�s�[�����Ŕz�u�����}�`���폜
	(setq #idx 0)
	(repeat (length #cp_list$)
		(setq #sym (nth #idx #cp_list$))
		(setq #ss (CFGetSameGroupSS #sym))
		(command "_.ERASE" #ss "")
		(setq #idx (1+ #idx))
	)

	#ret$

) ;CopyParts_Copy


;<HOM>*************************************************************************
; <�֐���>    : CopyParts_GetItemInfo
; <�����T�v>  : �i�ԏ�񃊃X�g���쐬����
; <�߂�l>    : �i�ԏ�񃊃X�g
;               (�i�ԏ�񃊃X�g �}���_ �z�u�p�x(���W�A��) W�u���[�N���C�� D�u���[�N���C�� H�u���[�N���C��)
; <�쐬>      : 2012/03/15 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun CopyParts_GetItemInfo (
	&sym       ; �R�s�[���O���[�v�V���{���}�`��
	&cp_list$  ; �R�s�[��񃊃X�g
	/
	#idx #width #depth #height #str_flg #xd_LSYM$ #xd_SYM$ #xd_TOKU$ #xd_REG$
	#new_LSYM$ #pt$ #w_brk$ #d_brk$ #h_brk$ #fig$ #ret$ #ang #doorID
	)

	(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
	(setq #xd_SYM$  (CFGetXData &sym "G_SYM"))
	(setq #xd_TOKU$ (CFGetXData &sym "G_TOKU"))
	(setq #xd_REG$  (CFGetXData &sym "G_REG"))

	; �}���_�i�z�u�ʒu�j���W
	(setq #idx 0)
	(repeat (length &cp_list$)
		(setq #new_LSYM$ (cadr (nth #idx &cp_list$)))
		(if (and (equal (nth  0 #new_LSYM$) (nth  0 #xd_LSYM$))   ; �}�`ID
						 (equal (nth  1 #new_LSYM$) (nth  1 #xd_LSYM$))   ; �}���_
						 (equal (nth  2 #new_LSYM$) (nth  2 #xd_LSYM$))   ; ��]�p�x
						 (equal (nth  6 #new_LSYM$) (nth  6 #xd_LSYM$))   ; �i�Ԗ���
						 (equal (nth  7 #new_LSYM$) (nth  7 #xd_LSYM$))   ; L/R�敪
						 (equal (nth 10 #new_LSYM$) (nth 10 #xd_LSYM$)))  ; ���i�R�[�h
			(setq #pt$ (car (nth #idx &cp_list$)))
		)
		(setq #idx (1+ #idx))
	)

	; �z�u�p�x
	(setq #ang (nth  2 #xd_LSYM$))

	; �T�C�Y
	(setq #width  (nth 3 #xd_SYM$))
	(setq #depth  (nth 4 #xd_SYM$))
	(setq #height (nth 5 #xd_SYM$))

	; �������ނł���ꍇ�i"G_TOKU" "G_REG"�j
	; �L�k�t���O�A�u���[�N���C���ʒu�̎擾
	(setq #str_flg "")
	(setq #w_brk$ nil)
	(setq #d_brk$ nil)
	(setq #h_brk$ nil)
	(if (/= #xd_TOKU$ nil)
		(progn
			(setq #str_flg "Yes")
			(setq #w_brk$ (nth 20 #xd_TOKU$))
			(setq #d_brk$ (nth 21 #xd_TOKU$))
			(setq #h_brk$ (nth 22 #xd_TOKU$))
		)
	)
	(if (/= #xd_REG$ nil)
		(progn
			(setq #str_flg "Yes")
			(setq #w_brk$ (nth 20 #xd_REG$))
			(setq #d_brk$ (nth 21 #xd_REG$))
			(setq #h_brk$ (nth 22 #xd_REG$))
		)
	)

	; �i�ԏ�񃊃X�g�̍쐬
	(setq #fig$
		(list
			(nth  5 #xd_LSYM$)    ; �i�Ԗ���
			(nth  0 #xd_LSYM$)    ; �}�`ID
			0                     ; �K�w�^�C�v
			(nth 12 #xd_LSYM$)    ; �p�r�ԍ�
			(nth  6 #xd_LSYM$)    ; L/R�敪
			#width                ; ���@W
			#depth                ; ���@D
			#height               ; ���@H
			(nth  9 #xd_LSYM$)    ; ���iCODE
			#str_flg              ; �L�k
			(nth  8 #xd_LSYM$)    ; �W�JID=�}�`ID
			(nth 15 #xd_LSYM$)    ; ���� or ���[
			"0"                   ; ���̓R�[�h
		)
	)

	(setq #ret$ (list #fig$ #pt$ #ang #w_brk$ #d_brk$ #h_brk$))

	#ret$

) ; CopyParts_GetItemInfo


;<HOM>*************************************************************************
; <�֐���>    : CopyParts_PcSetItem
; <�����T�v>  : �R�s�[�R�}���h�p���ޔz�u����
; <�߂�l>    : �ݒu���ꂽ�}�`��
; <�쐬>      : 2012/03/15 A.Satoh
; <���l>      : PCSetItem������
;             : ������PCSetItem�͏�����g�p�o���Ȃ��ׁA�V�K�֐��Ƃ��č쐬
;             : �R�s�[�R�}���h�ɓ��������֐��ł���ׁA���R�}���h�ł͎g�p�s��
;*************************************************************************>MOH<
(defun CopyParts_PcSetItem (
	&FIG$       ; �i�ԏ�񃊃X�g
	&dINS       ; �}���_
	&fANG       ; �}���p�x(���W�A��)
	&sym        ; �R�s�[���}�`�O���[�v�V���{���}�`��
	&w_brk$     ; ���u���[�N���C���ʒu���X�g
	&d_brk$     ; ���s���u���[�N���C���ʒu���X�g
	&h_brk$     ; �����u���[�N���C���ʒu���X�g
  /
	#door$ #DRSeriCode #DRColCode #Hikite #FIG$ #elv #elv2 #posZ #fname #ss #eNEW
	#xd_SYM$ #xd_LSYM$ #xd_TOKU$ #xd_REG$ #pt #ang #idx #cab_size$ #sabun #eD
	#BrkW #XLINE_W$ #XLINE_W #BrkD #XLINE_D$ #XLINE_D #BrkH #XLINE_H$ #XLINE_H
	#eDelBRK_W$ #eDelBRK_D$ #eDelBRK_H$
#xd_LSYM_OLD$ #xd_SYM_OLD$  ;-- 2012/03/23 A.Satoh Add
  )

	; �O���[�o���ϐ��̏�����
	(setq CG_BASE_UPPER nil)
	(setq CG_POS_STR nil)
	(setq CG_TOKU nil)
  (KP_TOKU_GROBAL_RESET)

	; ���݂̔������R�s�[���}�`�̔��}�`ID�̓��e�ɕύX����
	(setq #door$ (StrParse (nth 7 (CFGetXData &sym "G_LSYM")) ","))

	; �������o�b�N�A�b�v
	(setq #DRSeriCode CG_DRSeriCode)
	(setq #DRColCode  CG_DRColCode)
	(setq #Hikite     CG_HIKITE)

	; ������ύX
	(setq CG_DRSeriCode (car   #door$))
	(setq CG_DRColCode  (cadr  #door$))
	(setq CG_HIKITE     (caddr #door$))

	(setq #FIG$ &FIG$)

	; ��}�p�̉�w�ݒu
	(MakeLayer "Z_00_00_00_01" 7 "CONTINUOUS")

	; �ݒu�����ݒ�
	(setq #elv (getvar "ELEVATION"))
	(cond
		((= (SKY_DivSeikakuCode (nth 8 #FIG$) 2) CG_SKK_TWO_UPP)
			(setvar "ELEVATION" CG_UpCabHeight)
		)
		(T
			(setvar "ELEVATION" 0)
		)
	)
	(setq #elv2 (getvar "ELEVATION"))

	(setvar "ELEVATION" #elv2)
	(setq #posZ #elv2)

	; �}�`�t�@�C����
	(setq #fname (strcat (cadr #FIG$) ".dwg"))

	; �}���\���ID�t�@�C�����쐬&�`�F�b�N
	(Pc_CheckInsertDwg #fname CG_MSTDWGPATH)

	; �}�`�}��
	(command "_insert" (strcat CG_MSTDWGPATH #fname) &dINS 1 1 (rtd &fANG))

  ; (���s�ʒu�ύX) �{�H������������̂�h��
	(command "_.layer" "F" "Z_*" "")
	(command "_.layer" "T" "Z_00*" "")
	(command "_.layer" "T" "Z_KUTAI" "")

	; �}�` �����A�O���[�v���A�f�[�^�Z�b�g
	(command "_explode" (entlast))
	(setq #ss (ssget "P"))

	; ���������}�`�Q�Ŗ��O�̂Ȃ��O���[�v�쐬
	(SKMkGroup #ss)
	(command "_layer" "u" "N_*" "")

	; �O���[�v�V���{���}�`�̎擾
	(setq #eNEW (SearchGroupSym (ssname #ss 0)))

	; "G_LSYM"����ݒ肷��
;-- 2012/03/23 A.Satoh Mod - S
;;;;;	(SKY_SetZukeiXData #FIG$ #eNEW &dINS &fANG)
	(setq #xd_LSYM_OLD$ (CFGetXData &sym "G_LSYM"))
	(CFSetXData #eNew "G_LSYM" (CFModList #xd_LSYM_OLD$ (list (list 1 &dINS))))
	(KcSetDanmenSymXRec #eNew)
;-- 2012/03/23 A.Satoh Mod - E

	; ��Ű����"115"��PMEN2�̒��_������������
	(if (CheckSKK$ #eNEW (list (itoa CG_SKK_ONE_CAB) "?" (itoa CG_SKK_THR_CNR)))
		(KP_MakeCornerPMEN2 #eNEW)
	)

	; �S���ʉ�w����
	(command "_.layer" "on" "M_*" "")

	; ���ʓ\��t��
	(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

	; �����L�k�㕔�ނ̏ꍇ�́A�z�u��ɐL�k�������s��
	; �����L���r�R�}���h�Ɠ��ꏈ��
	(if (= (nth 9 #FIG$) "Yes")
		(progn
			; �A���������ɔ��̐L�k���s���B
�@�@�@; �����I�Ƀ��C���t���[���\���ɕύX����B
			(C:2DWire)

;-- 2012/03/23 A.Satoh Add - S
			(setq #xd_SYM_OLD$ (CFGetXData &sym "G_SYM"))
;-- 2012/03/23 A.Satoh Add - E
			(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM"))
			(setq #xd_LSYM$ (CFGetXData #eNEW "G_LSYM"))
			(setq #pt  (cdr (assoc 10 (entget #eNEW))))
			(setq #ang (nth 2 #xd_LSYM$))
			(setq CG_SizeH (nth 13 #xd_LSYM$))
			; ���_�t���O��L���ɐݒ�
			(if (> 0 (nth 10 #xd_SYM$))
				(setq CG_BASE_UPPER T)
			)
			(setq CG_TOKU T)

			; �R�s�[���}�`����"G_TOKU"����"G_REG"�����擾����
			(setq #xd_TOKU$ (CFGetXData &sym "G_TOKU"))
			(setq #xd_REG$ (CFGetXData &sym "G_REG"))

			; �u���[�N���C���֘A�ϐ��̏�����
			(setq #BrkW nil)
			(setq #XLINE_W$ nil)
			(setq #BrkD nil)
			(setq #XLINE_D$ nil)
			(setq #BrkH nil)
			(setq #XLINE_H$ nil)

			; �����̃u���[�N���C�����폜����
			(setq #eDelBRK_W$ (PcRemoveBreakLine #eNEW "W")) ; W�����u���[�N����
			(setq #eDelBRK_D$ (PcRemoveBreakLine #eNEW "D")) ; D�����u���[�N����
			(setq #eDelBRK_H$ (PcRemoveBreakLine #eNEW "H")) ; H�����u���[�N����

			; �u���[�N���C���ʒu���擾
			;;; ���u���[�N���C��
			(if &w_brk$
				(progn
					(setq #idx 0)
					(repeat (length &w_brk$)
						(if (> (nth #idx &w_brk$) 0.0)
							(setq #XLINE_W$ (append #XLINE_W$ (list (nth #idx &w_brk$))))
						)
						(setq #idx (1+ #idx))
					)
				)
				(setq #XLINE_W$ nil)
			)

			;;; ���s�u���[�N���C��
			(if &d_brk$
				(progn
					(setq #idx 0)
					(repeat (length &d_brk$)
						(if (> (nth #idx &d_brk$) 0.0)
							(setq #XLINE_D$ (append #XLINE_D$ (list (nth #idx &d_brk$))))
						)
						(setq #idx (1+ #idx))
					)
				)
				(setq #XLINE_D$ nil)
			)

			;;; �����u���[�N���C��
			(if &h_brk$
				(progn
					(setq #idx 0)
					(repeat (length &h_brk$)
						(if (> (nth #idx &h_brk$) 0.0)
							(setq #XLINE_H$ (append #XLINE_H$ (list (nth #idx &h_brk$))))
						)
						(setq #idx (1+ #idx))
					)
				)
			)

			; �L�k����
			(if (= CG_SKK_THR_CNR (CFGetSymSKKCode &sym 3))
				(progn    ; �R�[�i�[�L���r
					; �L�k�ʂ̎擾
					(setq #cab_size$ (CopyParts_GetCabSize #xd_TOKU$ #xd_REG$))

					; [A]�L�k��
					(if (and #XLINE_W$ (not (equal (nth 0 #cab_size$) 0.0 0.0001)))
						(if (not (equal (nth 3 #cab_size$) 0.0 0.0001))
							(progn
								; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
								(if (= (length #XLINE_W$) 2)
									(setq #BrkW (nth 1 #XLINE_W$))
									(setq #BrkW (nth 0 #XLINE_W$))
								)
								(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
								(CFSetXData #XLINE_W "G_BRK" (list 1))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_W "")	; �u���[�N���C���̃O���[�v��
       		  		(setq CG_TOKU_BW #BrkW)
		 	        	(setq CG_TOKU_BD nil)
	  		 	      (setq CG_TOKU_BH nil)

								; �ŐV�����g�p����
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

								; �L���r�l�b�g�{�̂̐L�k���s��
    			      (SKY_Stretch_Parts #eNEW (+ (nth 3 #xd_SYM$) (nth 0 #cab_size$)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

								; �ꎞ��ڰ�ײݍ폜
								(entdel #XLINE_W)

								; ���}�`�̐L�k
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
							(progn
								(setq #sabun (/ (nth 0 #cab_size$) (length #XLINE_W$)))

								(foreach #BrkW #XLINE_W$
									; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
									(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
									(CFSetXData #XLINE_W "G_BRK" (list 1))
									(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_W "")	; �u���[�N���C���̃O���[�v��
       					  (setq CG_TOKU_BW #BrkW)
		 	        		(setq CG_TOKU_BD nil)
	  		 	      	(setq CG_TOKU_BH nil)

									; �ŐV�����g�p����
									(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

									; �L���r�l�b�g�{�̂̐L�k���s��
  			  	      (SKY_Stretch_Parts #eNEW (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

									; �ꎞ��ڰ�ײݍ폜
									(entdel #XLINE_W)

									; ���}�`�̐L�k
									(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

									(KP_TOKU_GROBAL_RESET)
								)
							)
						)
    		  )

					; [B]�L�k��
					(if (and #XLINE_D$ (not (equal (nth 1 #cab_size$) 0.0 0.0001))) ; W2(D)
						(if (not (equal (nth 2 #cab_size$) 0.0 0.0001))
							(progn
								; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
								(if (= (length #XLINE_D$) 2)
									(setq #BrkD (nth 1 #XLINE_D$))
									(setq #BrkD (nth 0 #XLINE_D$))
								)
								(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
								(CFSetXData #XLINE_D "G_BRK" (list 2))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_D "")
		       	  	(setq CG_TOKU_BW nil)
	 			        (setq CG_TOKU_BD #BrkD)
  	 	  		    (setq CG_TOKU_BH nil)

								; �ŐV�����g�p����
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

								; �L���r�l�b�g�{�̂̐L�k���s��
								(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) (nth 1 #cab_size$)) (nth 5 #xd_SYM$))

								; �ꎞ��ڰ�ײݍ폜
								(entdel #XLINE_D)

								; ���}�`�̐L�k
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
							(progn
								(setq #sabun (/ (nth 1 #cab_size$) (length #XLINE_D$)))

								(foreach #BrkD #XLINE_D$
									; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
									(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
									(CFSetXData #XLINE_D "G_BRK" (list 2))
									(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_D "")
    		   		  	(setq CG_TOKU_BW nil)
	 	    		  	  (setq CG_TOKU_BD #BrkD)
  	 	      			(setq CG_TOKU_BH nil)

									; �ŐV�����g�p����
									(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

									; �L���r�l�b�g�{�̂̐L�k���s��
									(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

									; �ꎞ��ڰ�ײݍ폜
									(entdel #XLINE_D)

									; ���}�`�̐L�k
									(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

									(KP_TOKU_GROBAL_RESET)
								)
							)
						)
					)

					; [C]�L�k��
					(if (and #XLINE_D$ (not (equal (nth 2 #cab_size$) 0.0 0.0001))) ; D1(D)
						(if (not (equal (nth 1 #cab_size$) 0.0 0.0001))
							(progn
								; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
								(setq #BrkD (nth 0 #XLINE_D$))
								(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
								(CFSetXData #XLINE_D "G_BRK" (list 2))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_D "")
    	   	  		(setq CG_TOKU_BW nil)
		 	    	    (setq CG_TOKU_BD #BrkD)
   			    	  (setq CG_TOKU_BH nil)

								; �ŐV�����g�p����
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

								; �L���r�l�b�g�{�̂̐L�k���s��
								(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) (nth 2 #cab_size$)) (nth 5 #xd_SYM$))

								; �ꎞ��ڰ�ײݍ폜
								(entdel #XLINE_D)

								; ���}�`�̐L�k
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
							(progn
								(setq #sabun (/ (nth 2 #cab_size$) (length #XLINE_D$)))

								(foreach #BrkD #XLINE_D$
									; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
									(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
									(CFSetXData #XLINE_D "G_BRK" (list 2))
									(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_D "")
    			  	 	  (setq CG_TOKU_BW nil)
 	    			  	  (setq CG_TOKU_BD #BrkD)
   	    	  			(setq CG_TOKU_BH nil)

									; �ŐV�����g�p����
									(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

									; �L���r�l�b�g�{�̂̐L�k���s��
									(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

									; �ꎞ��ڰ�ײݍ폜
									(entdel #XLINE_D)

									; ���}�`�̐L�k
									(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

									(KP_TOKU_GROBAL_RESET)
								)
							)
						)
					)

					; [D]�L�k��
					(if (and #XLINE_W$ (not (equal (nth 3 #cab_size$) 0.0 0.0001))) ; D2(W)
						(if (not (equal (nth 0 #cab_size$) 0.0 0.0001))
							(progn
								; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
								(setq #BrkW (nth 0 #XLINE_W$))
								(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
								(CFSetXData #XLINE_W "G_BRK" (list 1))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_W "")
  	     	  		(setq CG_TOKU_BW #BrkW)
		 	  	      (setq CG_TOKU_BD nil)
   			  	    (setq CG_TOKU_BH nil)

								; �ŐV�����g�p����
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

								; �L���r�l�b�g�{�̂̐L�k���s��
  			        (SKY_Stretch_Parts #eNEW (+ (nth 3 #xd_SYM$) (nth 3 #cab_size$)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

								; �ꎞ��ڰ�ײݍ폜
								(entdel #XLINE_W)

								; ���}�`�̐L�k
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
							(progn
								(setq #sabun (/ (nth 3 #cab_size$) (length #XLINE_W$)))

								(foreach #BrkW #XLINE_W$
									; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
									(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
									(CFSetXData #XLINE_W "G_BRK" (list 1))
									(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_W "")
  	  	   			  (setq CG_TOKU_BW #BrkW)
		 	  	  	    (setq CG_TOKU_BD nil)
   			  	  	  (setq CG_TOKU_BH nil)

									; �ŐV�����g�p����
									(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

									; �L���r�l�b�g�{�̂̐L�k���s��
  				        (SKY_Stretch_Parts #eNEW (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

									; �ꎞ��ڰ�ײݍ폜
									(entdel #XLINE_W)

									; ���}�`�̐L�k
									(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

									(KP_TOKU_GROBAL_RESET)
								)
							)
    		    )
		      )

					; �����L�k��
					(if (and #XLINE_H$ (not (equal (nth 4 #cab_size$) 0.0 0.0001))) ; H
						(progn
							(setq CG_SizeH (+ CG_SizeH (nth 4 #cab_size$)))
							(setq #sabun (/ (nth 4 #cab_size$) (length #XLINE_H$)))
							(foreach #BrkH #XLINE_H$
								; �݌˂̏ꍇ�̍����ϊ�
								(if CG_BASE_UPPER
									(setq #BrkH (- (caddr #pt) #BrkH))
								)

								; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
								(setq #XLINE_H (PK_MakeBreakH #pt #BrkH))
								(CFSetXData #XLINE_H "G_BRK" (list 3))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_H "")
								(setq CG_TOKU_BW nil)
								(setq CG_TOKU_BD nil)
								(setq CG_TOKU_BH #BrkH)

								; �ŐV�����g�p����
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

								; �L���r�l�b�g�{�̂̐L�k���s��
								(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (nth 4 #xd_SYM$) (+ (nth 5 #xd_SYM$) #sabun))

;-- 2012/03/23 A.Satoh Del - S
;;;;;								; ���@H�̍X�V
;;;;;			    		  (CFSetXData #eNEW "G_LSYM" (CFModList #xd_LSYM$ (list (list 13 CG_SizeH))))
;-- 2012/03/23 A.Satoh Del - E

								; �ꎞ��ڰ�ײݍ폜
								(entdel #XLINE_H)

								; ���}�`�̐L�k
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
						)
					)

;-- 2012/03/23 A.Satoh Add - S
					(setq #xd_LSYM$ (CFGetXData #eNEW "G_LSYM"))
					(CFSetXData #eNew "G_LSYM" (CFModList #xd_LSYM$ (list (list 13 (nth 13 #xd_LSYM_OLD$)))))

					; G_SYM�̐L�k�t���O���R�s�[���}�`�ɍ��킹��
					(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))
					(CFSetXData #eNEW "G_SYM"
						(CFModList #xd_SYM$
							(list
								(list 11 (nth 11 #xd_SYM_OLD$))
								(list 12 (nth 12 #xd_SYM_OLD$))
								(list 13 (nth 13 #xd_SYM_OLD$))
							)
						)
					)
;-- 2012/03/23 A.Satoh Add - E
				)
				(progn    ; �R�[�i�[�L���r�ȊO
					; ������
					(if (and #XLINE_W$ (not (equal (nth 5 #FIG$) (nth 3 #xd_SYM$) 0.0001)))
						(progn
							(setq #sabun (/ (- (nth 5 #FIG$) (nth 3 #xd_SYM$)) (length #XLINE_W$)))
							(foreach #BrkW #XLINE_W$
								; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
								(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
								(CFSetXData #XLINE_W "G_BRK" (list 1))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_W "")
		       		  (setq CG_TOKU_BW #BrkW)
 	  		      	(setq CG_TOKU_BD nil)
	   	  		    (setq CG_TOKU_BH nil)

								; �L���r�l�b�g�{�̂̐L�k���s��
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))
								(SKY_Stretch_Parts #eNEW (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

								; �ꎞ��ڰ�ײݍ폜
								(entdel #XLINE_W)

								; ���}�`�̐L�k
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
						)
					)

					; ���s����
					(if (and #XLINE_D$ (not (equal (nth 6 #FIG$) (nth 4 #xd_SYM$) 0.0001)))
						(progn
							(setq #sabun (/ (- (nth 6 #FIG$) (nth 4 #xd_SYM$)) (length #XLINE_D$)))
							(foreach #BrkD #XLINE_D$
								; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
								(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
								(CFSetXData #XLINE_D "G_BRK" (list 2))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_D "")
       			  	(setq CG_TOKU_BW nil)
	 	        		(setq CG_TOKU_BD #BrkD)
		  	 	      (setq CG_TOKU_BH nil)

								; �L���r�l�b�g�{�̂̐L�k���s��
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))
								(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

								; �ꎞ��ڰ�ײݍ폜
								(entdel #XLINE_D)

								; ���}�`�̐L�k
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
						)
					)

					; ��������
					(if (and #XLINE_H$ (not (equal (nth 7 #FIG$) (nth 5 #xd_SYM$) 0.0001)))
						(progn
							(setq #sabun (/ (- (nth 7 #FIG$) (nth 5 #xd_SYM$)) (length #XLINE_H$)))
							(foreach #BrkH #XLINE_H$
								; �݌˂̏ꍇ�̍����ϊ�
								(if CG_BASE_UPPER
									(setq #BrkH (- (caddr #pt) #BrkH))
								)
								; �u���[�N���C���̍쐬���O���[�o���ϐ��ɐݒ�
								(setq #XLINE_H (PK_MakeBreakH #pt #BrkH))
								(CFSetXData #XLINE_H "G_BRK" (list 3))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_H "")
    		   	  	(setq CG_TOKU_BW nil)
	 	    		    (setq CG_TOKU_BD nil)
  	 	      		(setq CG_TOKU_BH #BrkH)

								; �L���r�l�b�g�{�̂̐L�k���s��
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))
								(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (nth 4 #xd_SYM$) (+ (nth 5 #xd_SYM$) #sabun))

								; �ꎞ��ڰ�ײݍ폜
								(entdel #XLINE_H)

								; ���}�`�̐L�k
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
						)
					)

;-- 2012/03/23 A.Satoh Add - S
					(setq #xd_LSYM$ (CFGetXData #eNEW "G_LSYM"))
					(CFSetXData #eNew "G_LSYM" (CFModList #xd_LSYM$ (list (list 13 (nth 13 #xd_LSYM_OLD$)))))

					; G_SYM�̐L�k�t���O���R�s�[���}�`�ɍ��킹��
					(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))
					(CFSetXData #eNEW "G_SYM"
						(CFModList #xd_SYM$
							(list
								(list 11 (nth 11 #xd_SYM_OLD$))
								(list 12 (nth 12 #xd_SYM_OLD$))
								(list 13 (nth 13 #xd_SYM_OLD$))
							)
						)
					)
;-- 2012/03/23 A.Satoh Add - E
				)
			)

			; ������ڰ�ײݕ���
			; W����
			(foreach #eD #eDelBRK_W$ (if (= (entget #eD) nil) (entdel #eD)))
			; D����
			(foreach #eD #eDelBRK_D$ (if (= (entget #eD) nil) (entdel #eD)))
			; H����
			(foreach #eD #eDelBRK_H$ (if (= (entget #eD) nil) (entdel #eD)))

			; �������̓o�^
			(if #xd_TOKU$
				(CFSetXData #eNEW "G_TOKU" #xd_TOKU$)
			)
			(if #xd_REG$
				(CFSetXData #eNEW "G_REG" #xd_REG$)
			)
		)
	)

	; �g���ް� "G_OPT" �Z�b�g
	(KcSetG_OPT #eNEW)

	; �V�A�C�e�����̑��ʐ}�ړ����K�v���ǂ������肵�Ď��s (�R����)
	(KcMoveToSGCabinet #eNEW)

	(command "_.layer" "F" "Z_01*" "")
	(command "_layer" "F" "Y_00*" "")
	(command "_layer" "OFF" "Y_00*" "")

	; �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
	(CFNoSnapEnd)

	; �O���[�o���ϐ������ɖ߂�
	(setq CG_BASE_UPPER nil)
	(setq CG_TOKU_BW nil)
	(setq CG_TOKU_BD nil)
	(setq CG_TOKU_BH nil)
	(setq CG_POS_STR nil)
	(setq CG_TOKU nil)
	(setq CG_DRSeriCode #DRSeriCode)
	(setq CG_DRColCode #DRColCode)
	(setq CG_HIKITE #Hikite)

	(command "_.layer" "F" "Z_*" "")
	(command "_.layer" "T" "Z_00*" "")
	(command "_.layer" "T" "Z_KUTAI" "")

	; ���̍����ɖ߂�
	(setvar "ELEVATION" #elv)

  #eNEW

) ; CopyParts_PcSetItem


;<HOM>*************************************************************************
; <�֐���>    : CopyParts_GetCabSize
; <�����T�v>  : �R�[�i�[�L���r�̐L�k�ʂ��擾����
; <�߂�l>    : �L�k�ʃ��X�g
;               ([A]�L�k�� [B]�L�k�� [C]�L�k�� [D]�L�k�� �����L�k��)
; <�쐬>      : 2012/03/16 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun CopyParts_GetCabSize (
	&xd_TOKU$  ; �������
	&xd_REG$   ; �����K�i�i���
	/
	#err_flag #xd_TOKUTYU$ #ret$ #str_a #str_b #str_c #str_d #str_h
	#org_width #org_depth #org_height #new_width #new_depth #new_height
	)

	(setq #err_flag nil)
	(setq #xd_TOKUTYU$ nil)

	(if &xd_TOKU$
		(setq #xd_TOKUTYU$ &xd_TOKU$)
		(if &xd_REG$
			(setq #xd_TOKUTYU$ &xd_REG$)
		)
	)

	; ������񂪑��݂��Ȃ��ꍇ�́A�L�k�ʂ�S��0.0�ŕԂ�
	(if (= #xd_TOKUTYU$ nil)
		(progn
			(setq #ret$ (list 0.0 0.0 0.0 0.0 0.0))
			(setq #err_flag T)
		)
	)

	(if (= #err_flag nil)
		(progn
			; �T�C�Y�����擾
			(setq #org_width  (nth 12 #xd_TOKUTYU$))
			(setq #org_depth  (nth 13 #xd_TOKUTYU$))
			(setq #org_height (nth 14 #xd_TOKUTYU$))
			(setq #str_d      (nth 15 #xd_TOKUTYU$))
			(setq #str_c      (nth 16 #xd_TOKUTYU$))
			(setq #new_width  (nth 17 #xd_TOKUTYU$))
			(setq #new_depth  (nth 18 #xd_TOKUTYU$))
			(setq #new_height (nth 19 #xd_TOKUTYU$))

			; [A]�A[B]�A�����̐L�k�ʂ��Z�o
			(setq #str_a (- (- #new_width #org_width) #str_d))
			(setq #str_b (- (- #new_depth #org_depth) #str_c))
			(setq #str_h (- #new_height #org_height))

			(setq #ret$ (list #str_a #str_b #str_c #str_d #str_h))
		)
	)

	#ret$

) ; CopyParts_GetCabSize
;-- 2012/03/15 A.Satoh Mod �R�s�[�R�}���h�G���[�Ή� - E


;<HOM>*************************************************************************
; <�֐���>    : Copy
; <�����T�v>  : �ݔ��R�s�[
; <�߂�l>    : �R�s�[��̑I���Z�b�g
; <�쐬>      : 1999-12-2 YM
; <���l>      :
;*************************************************************************>MOH<
(defun Copy(
  &ss
  /
  #i
  #ss2            ; �R�s�[�����}�`�̑I���Z�b�g
  #old_lis        ; �R�s�[�O�̐}�ʏ�S�}�`���X�g
  #new_lis        ; �R�s�[��̐}�ʏ�S�}�`���X�g
  #bpt            ; �R�s�[�̊�_
  #lpt            ; �ړI�_
  #os
  #baseen #basess;00/10/04 SN ADD
#idx #old_list$ #new_list$ #flag #en_new  ;-- 2012/03/14 A.Satoh Add �R�s�[�R�}���h�C��
  )

  (setq #old_lis (CMN_all_en_list))            ; (�}�ʏ�̑S�Ă̐}�`�����X�g(<�}�`��1>,2,3,...,n)
  (setq #bpt (getpoint "\n��_: "))
  (princ "\n�ړI�_: ")

  ;00/09/22 SN MOD �F�߂������ʊ֐�
  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
;;;  (ChangeItemColor &ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; �F��߂�
  ;)

  ;00/10/04 SN ADD ����т͈�UBylaer�ɂ���B
  (setq #baseen nil)
  (if (and (CFGetXRecord "BASESYM")                          ; ����т����� ����
      (ssmemb (setq #baseen (handent (car (CFGetXRecord "BASESYM")))) &ss)) ; ����т� &ss �ɓ����Ă���
      (GroupInSolidChgCol2 #baseen "BYLAYER")   ;BYLAYER�F�ɕύX
  );_if

  (setq EditFlag 1)
  (command ".COPY" &ss "" #bpt PAUSE)
  (setq #lpt (getvar "LASTPOINT"))
  (setq #new_lis (CMN_all_en_list))            ; (�}�ʏ�̑S�Ă̐}�`�����X�g(<�}�`��1>,2,3,...,n)

;;; �R�s�[��̑I���Z�b�g#ss2 ;;;
  (setq #ss2 (ssadd))
  (setq #i (+ (car #old_lis) 1))
  (while (<= #i (car #new_lis))
    (setq #ss2 (ssadd (nth #i #new_lis) #ss2))
    (setq #i (1+ #i))
  );_(while

  ;00/10/04 SN ADD ����т͈�U�F��Bylayer�ɂ��Ă���̂ŁA��F�ɂ���B
  (if #baseen (progn
    (GroupInSolidChgCol #baseen CG_BaseSymCol) ;����ѐF�ɕύX
    ;basereset�ɂ����͍č�}����邪�ΏۊO�ɂ���B
    (setq #basess (ssget "X" '((-3 ("G_ARW")))))
    (setq #i 0)
    (repeat (sslength #basess)
      (ssdel (ssname #basess #i) #ss2)
      (setq #i (1+ #i))
    )
  ))

  (if (= nil (equal (caddr #lpt) (caddr #bpt) 0.0001))
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command ".MOVE" #ss2 "" "0,0,0" (list 0 0 (- (caddr #bpt) (caddr #lpt))))
      (setvar "OSMODE" #os)
    );_progn
  );_if

  #ss2

);_defun

;<HOM>*************************************************************************
; <�֐���>    : C:CopyRotateParts
; <�����T�v>  : �����R�s�[�R�}���h
; <�߂�l>    :
; <�쐬>      : 1999-12-2 YM
; <���l>      :
;*************************************************************************>MOH<
(defun C:CopyRotateParts(
  /
  #v_angbase
  #v_angdir
  #i
  #ss             ; �I���������ׂẴO���[�v�̑I���Z�b�g(�R�s�[�Ώ�)
  #ss2            ; �R�s�[�����}�`�̑I���Z�b�g
  #ret
  #sa_ang         ; ��]�p�x
  #en_lis_#ss     ; �R�s�[�O�}�`�����X�g
  #en_lis_#ss2    ; �R�s�[��}�`�����X�g
#sys$
  )
  (StartUndoErr);00/10/02 SN MOD UNDO�����֐��ύX
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  (setq #v_angbase (getvar "ANGBASE"))
  (setvar "ANGBASE" 0)                                 ; ANGBASE�̃f�t�H���g��
  (setq #v_angdir (getvar "ANGDIR"))
  (setvar "ANGDIR" 0)                                  ; ANGDIR�̃f�t�H���g��
  ;00/09/22 SN MOD ���ёI���֐���ύX
  (setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
;;;  (setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_ConfSymCol))
  ;00/09/22 SN MOD �I��Ă̵�޼ު�Đ�����������B
  (if (> (sslength #ss) 0)
		(progn
	    (setq #ret (CopyRotate #ss))                         ; �v�f�̕����R�s�[
	    (setq #ss2    (car  #ret))
	    (setq #sa_ang (cadr #ret))
	    (setq #en_lis_#ss  (CMN_ss_to_en #ss ))              ; �R�s�[�O�I���Z�b�g��n���Đ}�`���̃��X�g�𓾂�.
	    (setq #en_lis_#ss2 (CMN_ss_to_en #ss2))              ; �R�s�[��I���Z�b�g��n���Đ}�`���̃��X�g�𓾂�.
	    (SetG_PRIM22 #en_lis_#ss  #en_lis_#ss2)              ; "G_PRIM"(��ʐ}�`)�g���f�[�^�̕ύX
	    (SetG_BODY   #en_lis_#ss #en_lis_#ss2)               ; "G_BODY"(���}�`)�g���f�[�^�̕ύX

;;;01/05/01YM@	    (SetG_LSYM11 #en_lis_#ss  #en_lis_#ss2)              ; "G_LSYM"(�}���_)�g���f�[�^�̕ύX
;;;01/05/01YM@	    (SetG_LSYM22 #en_lis_#ss2 #en_lis_#ss2 #sa_ang)      ; "G_LSYM"(��]�p�x)�g���f�[�^�̕ύX

	    (ChgLSYM12_copy #en_lis_#ss #en_lis_#ss2 #sa_ang) ; "G_LSYM"(�}���_,��]�p�x)�g���f�[�^�̕ύX 01/05/01 YM ������

			(AfterCopySetDoorGroup #en_lis_#ss #en_lis_#ss2) ; 01/09/10 YM "ADD DoorGroup" �̾��

	    (setvar "ANGBASE" #v_angbase)                        ; ANGBASE��߂�
	    (setvar "ANGDIR" #v_angdir)                          ; ANGDIR��߂�
	  )
	);_if
  (setq *error* nil)                                   ; �㏈��
  (setq EditFlag nil)
  (CFCmdDefFinish);00/09/13 SN ADD
  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
	(princ "\n�����R�s�[���܂����B")
  (princ)
);_(defun

;<HOM>*************************************************************************
; <�֐���>    : CopyRotate
; <�����T�v>  : �����R�s�[
; <�߂�l>    : (�R�s�[��̑I���Z�b�g,��]�p�x)
; <�쐬>      : 1999-12-2 YM
; <���l>      :
;*************************************************************************>MOH<
(defun CopyRotate(
  &ss
  /
  #i
  #ss2            ; �R�s�[�����}�`�̑I���Z�b�g
  #old_lis        ; �R�s�[�O�̐}�ʏ�S�}�`���X�g
  #new_lis        ; �R�s�[��̐}�ʏ�S�}�`���X�g
  #bpt            ; �R�s�[�̊�_
  #lpt            ; �ړI�_
  #os
  #rpt
  #rptn
  #pt1
  #pt2
  #sa_ang         ; ��]�p�x
  #en_cf
  #baseen #basess;00/10/04 SN ADD
  )

  (setq #old_lis (CMN_all_en_list)) ; (�}�ʏ�̑S�Ă̐}�`�����X�g(<�}�`��1>,2,3,...,n)
  (initget 1)
  (setq #bpt (getpoint "\n�R�s�[����_: "))            ; (1)
  (initget 1)
  (setq #rpt (getpoint #bpt "\n�R�s�[���ʍ��킹����: ")) ; (2) #bpt���烉�o�[�o���h������.
  (princ "\n�R�s�[���_: ")

  ;00/09/22 SN MOD �F�߂������ʊ֐�
  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; �F��߂�
  ;)
  ;00/10/04 SN ADD ����т͈�UBylaer�ɂ���B
  (setq #baseen nil)
  (if (and (CFGetXRecord "BASESYM")                          ; ����т����� ����
      (ssmemb (setq #baseen (handent (car (CFGetXRecord "BASESYM")))) &ss)) ; ����т� &ss �ɓ����Ă���
      (GroupInSolidChgCol2 #baseen "BYLAYER")   ;BYLAYER�F�ɕύX
  );_if

  (setq EditFlag 1)
  (command ".COPY" &ss "" #bpt PAUSE)
  (setq #lpt (getvar "LASTPOINT"))                      ; (3)

  (setq #rptn (mapcar '+ #rpt (mapcar '- #lpt #bpt)))
  (setq #new_lis (CMN_all_en_list)) ; (�}�ʏ�̑S�Ă̐}�`�����X�g(<�}�`��1>,2,3,...,n)

;;; �R�s�[��̑I���Z�b�g#ss2 ;;;
  (setq #ss2 (ssadd))
  (setq #i (+ (car #old_lis) 1))
  (while (<= #i (car #new_lis))
    (setq #ss2 (ssadd (nth #i #new_lis) #ss2))
    (setq #i (1+ #i))
  );_(while

  ;00/10/04 SN ADD ����т͈�U�F��Bylayer�ɂ��Ă���̂ŁA��F�ɂ���B
  (if #baseen (progn
    (GroupInSolidChgCol #baseen CG_BaseSymCol) ;����ѐF�ɕύX
    ;basereset�ɂ����͍č�}����邪�ΏۊO�ɂ���B
    (setq #basess (ssget "X" '((-3 ("G_ARW")))))
    (setq #i 0)
    (repeat (sslength #basess)
      (ssdel (ssname #basess #i) #ss2)
      (setq #i (1+ #i))
    )
  ))

  (if (= nil (equal (caddr #lpt) (caddr #bpt) 0.0001))
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command ".MOVE" #ss2 "" "0,0,0" (list 0 0 (- (caddr #bpt) (caddr #lpt))))
      (setvar "OSMODE" #os)
    ); _progn
  );_if

  (princ "\n�R�s�[��ʍ��킹����: ")
  ;;; ��]�O�Q�Ɠ_ in #ss2 ;;;
  (setq #pt1 (cdr (assoc 10 (entget (SearchGroupSym (ssname #ss2 0)))))) ; #ss2�̒���1�̐e�}�`�̓_
  (setq #en_cf nil)
  (if (< (distance #pt1 #lpt) 0.1)                                        ; ��_���e�}�`�_�Ɠ����ꍇ
    (progn
      (setq #pt1 (mapcar '+ #pt1 '(50.0 50.0 0.0)))                       ; �Q�Ɠ_�̕��s�ړ�
      (entmake (list (cons 0 "POINT") (cons 62 2) (list 10 (car #pt1) (cadr #pt1) (caddr #pt1)) )) ; �Q�Ɠ_��}�ʂɍ쐬
      (setq #en_cf (entlast))
      (setq #ss2 (ssadd #en_cf &ss)) ; �쐬�����Q�Ɠ_���ꏏ�ɉ�]����.
    );_(progn
  );if

  (command ".ROTATE" #ss2 "" #lpt "R" #lpt #rptn PAUSE)
  ;;; ��]��Q�Ɠ_ in #ss2 ;;;
  (setq #pt2 (cdr (assoc 10 (entget (SearchGroupSym (ssname #ss2 0)))))) ; #ss2�̒���1�̐e�}�`�̓_
  (if #en_cf
    (progn
      (setq #pt2 (cdr (assoc 10 (entget #en_cf))))
      (entdel #en_cf) ; �Q�Ɠ_���폜
    );_(progn
  );if

  (setq #sa_ang (- (angle #lpt #pt2) (angle #lpt #pt1)))                 ; ��]�O�Q�Ɠ_,��]��Q�Ɠ_�̊p�x��
  (list #ss2 #sa_ang)

);_defun

;<HOM>*************************************************************************
; <�֐���>    : C:Z_MoveParts
; <�����T�v>  : �ݔ�Z�ړ��R�}���h
; <�߂�l>    :
; <�쐬>      : 1999-12-2 YM
; <���l>      :
;*************************************************************************>MOH<
(defun C:Z_MoveParts(
  /
  #ss             ; �I��v�f�������o�[�ɂ��O���[�v�́A�S�}�`�̑I���Z�b�g(�ړ��Ώ�)
	#SYS$ #dist
  )
  (StartUndoErr);00/10/02 SN MOD UNDO�����֐��ύX
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  ;00/09/22 SN MOD ���ёI���֐���ύX
;;;  (setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
  (setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_ConfSymCol))
  ;00/09/22 SN MOD �I��Ă̵�޼ު�Đ�����������B
  (if (> (sslength #ss) 0)
		(progn
	    (setq #dist (Z_Move #ss))                                 ; �v�f�̈ړ�
			; "G_LSYM"(�}���_)�X�V 01/04/27 YM ������
	    (ChgLSYM1 #ss)
	    (SetG_PRIM1 #ss)  ; "G_PRIM" (���t������)�g���f�[�^�̕ύX
	    (SetG_WRKT "Z_MOVE" #ss #dist nil)   ; "G_WRKT"(WT��t������)�g���f�[�^�̕ύX
	  )
	);end if - progn
  (setq *error* nil)                           ; �㏈��
  (setq EditFlag nil)
  (CFCmdDefFinish);00/09/13 SN ADD
  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
	(princ "\n�y�ړ����܂����B")
  (princ)

);_(defun

;<HOM>*************************************************************************
; <�֐���>    : Z_Move
; <�����T�v>  : �ݔ�Z�ړ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-12-2 YM
; <���l>      :
;*************************************************************************>MOH<
(defun Z_Move(
  &ss
  /
  #os
  #buf            ; ���ړ����΍��W�̕�����
  #dist #SS
  )

; 00/09/27 SN MOD OSMODE��OFF��Command MOVE �̒��O�ɍs��
; 00/06/26 SN MOD OSMODE�͋������͑O��OFF����B
;  (setq #os (getvar "OSMODE"))
;  (setvar "OSMODE" 0)
  ;// ���������
  (setq #dist (getdist (strcat "\n����<" (itoa (fix CG_ZMOVEDIST)) ">: ")));00/06/27 SN MOD ү���ޕύX
  ;(setq #dist (getdist (strcat "\n���������<" (rtos CG_ZMOVEDIST) ">:")));00/06/27 SN MOD
  (if (/= #dist nil) (setq CG_ZMOVEDIST #dist))  ; �O���[�o���ϐ��ŋL��
	(if (=  #dist nil) (setq #dist CG_ZMOVEDIST))  ; 02/08/28 YM ADD

; 00/06/26 SN MOD OSMODE�͋������͑O��OFF����B
;  (setq #os (getvar "OSMODE"))
;  (setvar "OSMODE" 0)
  (setq #buf (strcat "0,0," (rtos CG_ZMOVEDIST))) ; �������ړ����΍��W

  ;00/09/22 SN MOD �F�߂������ʊ֐�
;;;  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
  (ChangeItemColor &ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; �F��߂�
  ;)
  (setq EditFlag 1)
  ;;; 06/10 YM ADD ����т̏ꍇ������
        ;00/06/27 SN MOD ����т��������̕s��C��
  (if (and (CFGetXRecord "BASESYM")                          ; ����т����� ����
      (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss)) ; ����т� &ss �ɓ����Ă���
; (if (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss) ; ����т� &ss �ɓ����Ă���
    (progn
      (setq #ss (ssget "X" '((-3 ("G_ARW"))))) ; �����ړ�����
      (CMN_ssaddss #ss &ss)
    )
  );_if

  (setq #os (getvar "OSMODE"));00/09/27 SN ADD
  (setvar "OSMODE" 0)         ;00/09/27 SN ADD
  (command "._MOVE" &ss "" "0,0,0" #buf)
  (setvar "OSMODE" #os)
  #dist
)

;<HOM>*************************************************************************
; <�֐���>    : C:Z_CopyParts
; <�����T�v>  : �ݔ��y�R�s�[�R�}���h
; <�߂�l>    :
; <�쐬>      : 1999-12-2 YM
; <���l>      : �g���f�[�^"G_LSYM","G_PRIM"�̂ݕύX.
;*************************************************************************>MOH<
(defun C:Z_CopyParts(
  /
  #ss             ; �I���������ׂẴO���[�v�̑I���Z�b�g(�ړ��Ώ�)
  #ss2            ; �R�s�[�����}�`�̑I���Z�b�g
  #en_lis_#ss     ; �R�s�[�O�}�`�����X�g
  #en_lis_#ss2    ; �R�s�[��}�`�����X�g
#sys$
  )
  (StartUndoErr);00/10/02 SN MOD UNDO�����֐��ύX
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  ;00/09/22 SN MOD ���ёI���֐���ύX
  (setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
  ;00/09/22 SN MOD �I��Ă̵�޼ު�Đ�����������B
  (if (> (sslength #ss) 0)
		(progn
	    (setq #ss2 (Z_Copy #ss))                     ; �v�f��Z�R�s�[
	    (setq #en_lis_#ss  (CMN_ss_to_en #ss ))      ; �R�s�[�O�I���Z�b�g��n���Đ}�`���̃��X�g�𓾂�.
	    (setq #en_lis_#ss2 (CMN_ss_to_en #ss2))      ; �R�s�[��I���Z�b�g��n���Đ}�`���̃��X�g�𓾂�.
;;;01/05/01YM@	    (SetG_LSYM11 #en_lis_#ss  #en_lis_#ss2)      ; "G_LSYM"(�}���_)�g���f�[�^�̕ύX

	    (ChgLSYM1_copy #en_lis_#ss #en_lis_#ss2)     ; "G_LSYM"(�}���_)�g���f�[�^�̕ύX 01/05/01 YM ������
			(AfterCopySetDoorGroup #en_lis_#ss #en_lis_#ss2) ; 01/09/10 YM "ADD DoorGroup" �̾��
	    (SetG_PRIM22 #en_lis_#ss  #en_lis_#ss2)      ; "G_PRIM"(��ʐ}�`)�g���f�[�^�̕ύX
	    (SetG_PRIM11 #en_lis_#ss2 #en_lis_#ss2)      ; "G_PRIM"(���t������)�g���f�[�^�̕ύX
	    (SetG_BODY   #en_lis_#ss #en_lis_#ss2)       ; "G_BODY"(���}�`)�g���f�[�^�̕ύX
  	)
	);_if
  (setq *error* nil)                           ; �㏈��
  (setq EditFlag nil)
  (CFCmdDefFinish);00/09/13 SN ADD
  (PKEndCOMMAND #sys$); 00/08/25 SN ADD
	(princ "\n�y�R�s�[���܂����B")
  (princ)

);_(defun

;<HOM>*************************************************************************
; <�֐���>    : Z_Copy
; <�����T�v>  : �ݔ��y�R�s�[
; <�߂�l>    : �R�s�[��̑I���Z�b�g
; <�쐬>      : 1999-12-2 YM
; <���l>      :
;*************************************************************************>MOH<
(defun Z_Copy(
  &ss
  /
  #i
  #ss2            ; �R�s�[�����}�`�̑I���Z�b�g
  #old_lis        ; �R�s�[�O�̐}�ʏ�S�}�`���X�g
  #new_lis        ; �R�s�[��̐}�ʏ�S�}�`���X�g
  #os
  #dist
  #buf            ; ���ړ����΍��W�̕�����
  #baseen #basess;00/10/04 SN ADD
  )

; 00/09/27 SN MOD OSMODE��OFF��Command Copy ���O�ɍs��
; 00/06/26 SN MOD OSMODE�͋������͑O��OFF����B
;  (setq #os (getvar "OSMODE"))
;  (setvar "OSMODE" 0)
  (setq #old_lis (CMN_all_en_list))                  ; (�}�ʏ�̑S�Ă̐}�`�����X�g(<�}�`��1>,2,3,...,n)
  ;// ���������
  (setq #dist (getdist (strcat "\n����<" (itoa (fix CG_ZMOVEDIST)) ">: ")));00/06/27 SN MOD ү���ޕύX
  ;(setq #dist (getdist (strcat "\n���������<" (rtos CG_ZMOVEDIST) ">:")));00/06/27 SN MOD ү���ޕύX
  (if (/= #dist nil) (setq CG_ZMOVEDIST #dist))      ; �O���[�o���ϐ��ŋL��
	(if (=  #dist nil) (setq #dist CG_ZMOVEDIST))  ; 02/08/28 YM ADD

; 00/06/26 SN MOD OSMODE�͋������͑O��OFF����B
;  (setq #os (getvar "OSMODE"))
;  (setvar "OSMODE" 0)
  (setq #buf (strcat "0,0," (rtos CG_ZMOVEDIST)))    ; �������ړ����΍��W

  ;00/09/22 SN MOD �F�߂������ʊ֐�
  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; �F��߂�
  ;)
  ;00/10/04 SN ADD ����т͈�UBylaer�ɂ���B
  (setq #baseen nil)
  (if (and (CFGetXRecord "BASESYM")                          ; ����т����� ����
      (ssmemb (setq #baseen (handent (car (CFGetXRecord "BASESYM")))) &ss)) ; ����т� &ss �ɓ����Ă���
      (GroupInSolidChgCol2 #baseen "BYLAYER")   ;BYLAYER�F�ɕύX
  );_if

  (setq EditFlag 1)
  (setq #os (getvar "OSMODE"));00/09/27 SN ADD
  (setvar "OSMODE" 0)         ;00/09/27 SN ADD
  (command "._COPY" &ss "" "0,0,0" #buf)
  (setvar "OSMODE" #os)

  (setq #new_lis (CMN_all_en_list))                  ; (�}�ʏ�̑S�Ă̐}�`�����X�g(<�}�`��1>,2,3,...,n)

;;; �R�s�[��̑I���Z�b�g#ss2 ;;;
  (setq #ss2 (ssadd))
  (setq #i (+ (car #old_lis) 1))
  (while (<= #i (car #new_lis))
    (setq #ss2 (ssadd (nth #i #new_lis) #ss2))
    (setq #i (1+ #i))
  );_(while

  ;00/10/04 SN ADD ����т͈�U�F��Bylayer�ɂ��Ă���̂ŁA��F�ɂ���B
  (if #baseen (progn
    (GroupInSolidChgCol #baseen CG_BaseSymCol) ;����ѐF�ɕύX
    ;basereset�ɂ����͍č�}����邪�ΏۊO�ɂ���B
    (setq #basess (ssget "X" '((-3 ("G_ARW")))))
    (setq #i 0)
    (repeat (sslength #basess)
      (ssdel (ssname #basess #i) #ss2)
      (setq #i (1+ #i))
    )
  ))

  #ss2

);_defun

;///////////////////////////////////////////////
(defun C:rrr ( / )
	(C:RotateCAB)
)
;<HOM>*************************************************************************
; <�֐���>    : C:RotateCAB
; <�����T�v>  : ���̏�ŷ���ȯĂ���]������(���ʁA�w�ʂ�����ւ��)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/03/16 YM
; <���l>      : ��]+�ړ��̂�(G_LSYM��]�p�x�̂�)
;*************************************************************************>MOH<
(defun C:RotateCAB (
  /
	#ANG #CAB-EN #D #DIST #DUM1 #ENGRP #LOOP #LPT #LU_PT #MIN #O #PMEN2 #PT$
	#SNKCAB #SS #SYM #SYS$ #W #XD$_LSYM #XD$_SYM
	#EG$ #ELM #FIG$ #I #SSARW #SSSYM #GR #OS #OT #SM
  )
  (StartUndoErr);00/10/02 SN MOD UNDO�����֐��ύX
  (setq #os (getvar "OSMODE"))
  (setq #sm (getvar "SNAPMODE"))
  (setq #gr (getvar "GRIDMODE"))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"     0)
  (setvar "SNAPMODE"   0)
  (setvar "GRIDMODE"   0)
  (setvar "ORTHOMODE"  0)

  (setq CG_BASESYM (CFGetBaseSymXRec))

  ;// �V���N�L���r�l�b�g���w��������
  (setq #loop T)
  (while #loop
    (setq #cab-en (car (entsel "\n�A�C�e����I��: ")))
    (if #cab-en
      (progn ; �����I�΂ꂽ
        (setq #sym (CFSearchGroupSym #cab-en)) ; ����ِ}�`��
				(if (and #sym (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB) "?" "?"))) ; 01/08/31 YM MOD ��۰��ى�
					(progn
						(GroupInSolidChgCol2 #sym CG_InfoSymCol)    ; �F��Ԃ�����
						(setq #xd$_LSYM (CFGetXData #sym "G_LSYM")) ; �g���ް�"G_LSYM"�擾
						(setq #xd$_SYM  (CFGetXData #sym "G_SYM"))  ; �g���ް�"G_SYM" �擾
						(setq #ang (nth 2 #xd$_LSYM)) ; ��]�p�x

					  (setq #fig$
					    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
					      (list
					        (list "�i�Ԗ���" (nth 5 #xd$_LSYM)         'STR)
					        (list "LR�敪"   (nth 6 #xd$_LSYM)         'STR)
					        (list "�p�r�ԍ�" (itoa (nth 12 #xd$_LSYM)) 'INT)
					      )
					    )
					  )
					  (setq #fig$ (DBCheck #fig$ "�w�i�Ԑ}�`�x" "C:RotateCAB"))
			      (setq #w (nth 3 #fig$));2008/06/28 YM OK!
			      (setq #d (nth 4 #fig$));2008/06/28 YM OK!

;;;						(setq #W   (nth 3 #xd$_SYM))  ; ���@D
;;;						(setq #D   (nth 4 #xd$_SYM))  ; ���@W
						(setq #O (cdr (assoc 10 (entget #sym)))) ; ����ي�_
						(setq #pmen2 (PKGetPMEN_NO #sym 2))      ; ����PMEN2
			      (setq #pt$ (GetLWPolyLinePt #pmen2))     ; ����PMEN2 �O�`�̈�
;  p1               p2
;  +----------------+
;  *�����           |
;  |                |
;  |                |
;  |                |
;  +----------------+
;  p4               p3
						; ����قƂ̍ŒZ�����ƈ�ԋ߂��_
						(setq #min 1.0e+10)
						(foreach pt #pt$
							(setq #dist (distance pt #O))
							(if (< #dist #min)
								(progn
									(setq #min #dist)
									(if (equal #min 0 0.001)(setq #min 0))
;;;									(setq #LU_PT pt)
								)
							);_if
						)
;;;						(setq #pt$ (GetPtSeries #LU_PT #pt$))
          	(setq #loop nil)
					)
        	(CFAlertMsg "���̕��ނ̓L���r�l�b�g�ł͂���܂���B")
        );_if
      )
      (CFAlertMsg "���ނ�I�����Ă��������B")
    );_if
  );_while

	(setq #ss (CFGetSameGroupSS #sym)) ; ����O���[�v���̑S�}�`�I���Z�b�g

	(if (equal CG_BASESYM #sym);�����
		(progn
		  (setq #ssARW (ssget "X" '((-3 ("G_ARW"))))) ; �����ړ�����
		  (CMN_ssaddss #ssARW #ss)
		)
	);_if

;;;	; �����ِ}�`�𔲂����
;;;	(setq #ssSYM (ssadd))
;;;	(setq #i 0)
;;;	(repeat (sslength #ss)
;;;		(setq #elm (ssname #ss #i))
;;;		(setq #eg$ (entget #elm))
;;;		(if (and (= (cdr (assoc 0 #eg$)) "POINT")
;;;						 (< (distance #O (cdr (assoc 10 #eg$))) 0.1))
;;;			(ssadd #elm #ssSYM)
;;;		);_if
;;;		(setq #i (1+ #i))
;;;	)

	(if (and #ss (< 0 (sslength #ss)))
		(progn
			; ��]����
			(command "._rotate" #ss "" #O 180) ;��]
			; �ړ�����
			(setq #dum1 (polar #O #ang #W))
			(setq #lpt  (polar #dum1 (+ #ang (dtr -90)) (- #D (* 2 #min))))
			(command "_.MOVE" #ss "" #O #lpt)
		)
	);_if

;;;	;;; ����ي�_���ړ�����
;;;	(command "_.MOVE" #ssSYM "" #lpt #O)

  ;// �F��߂�
	(if (equal CG_BASESYM #sym);�����
	  (GroupInSolidChgCol2 #sym CG_BaseSymCol) ; ������}���Ȃ��ŐF��ύX
	  (GroupInSolidChgCol2 #sym "BYLAYER")
	);_if

;;;	(setq #ss (CMN_enlist_to_ss #elm$)) ; �}�`ؽ�--->�I���

;;;  ;// �g���f�[�^�̍X�V
  (CFSetXData #sym "G_LSYM"
    (CFModList #xd$_LSYM
      (list (list 2 (Angle0to360 (+ #ang (dtr 180))))) ; �z�u�p�x
    )
  )

  (setq *error* nil)   ; �㏈��
  (setq EditFlag nil)
  (setvar "OSMODE"     #os)
  (setvar "SNAPMODE"   #sm)
  (setvar "GRIDMODE"   #gr)
  (setvar "ORTHOMODE"  #ot)
  (princ)
);C:RotateCAB

;<HOM>*************************************************************************
; <�֐���>    : PcCabCutCall
; <�����T�v>  : �I����������ȯĕ��ނ̒���J�b�g����R�}���h(�Ăяo���p)
; <����>      :�Ȃ�
; <�߂�l>    :�Ȃ�
; <�쐬>      : 00/03/17 YM
; <���l>      :
;*************************************************************************>MOH<
(defun PcCabCutCall
  (
  &sym ; ����ȯļ���ِ}�`
  /
  #GR #OS #OT #SEIKAKU1 #SEIKAKU2 #SM #SYM #UF #UV #XD$ #clayer
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PcCabCutCall ////")
  (CFOutStateLog 1 1 " ")
;;;09/21YM  (command "._shademode" "3D") ; �B������ ����(��߰�ޱ���)07/07 YM ADD
	(setq #clayer (getvar "CLAYER"   )) ; ���݂̉�w���L�[�v ; 00/09/22 YM ADD
  (setq #os (getvar "OSMODE"))
  (setq #sm (getvar "SNAPMODE"))
  (setq #uf (getvar "UCSFOLLOW"))
  (setq #uv (getvar "UCSVIEW"))
  (setq #gr (getvar "GRIDMODE"))
  (setq #ot (getvar "ORTHOMODE"))
;;;  (setq #wv (getvar "WORLDVIEW"))
  (setvar "OSMODE"     0)
  (setvar "SNAPMODE"   0)
  (setvar "UCSFOLLOW"  1)
  (setvar "UCSVIEW"    0)
  (setvar "GRIDMODE"   0)
  (setvar "ORTHOMODE"  0)
;;;  (setvar "WORLDVIEW"  0)

  (command "_view" "S" "TEMP")
  (PcCabCutSub &sym)        ; ��ď�������ъg���ް��̾�Ă��s��
  (command "_layer" "F" SKD_TEMP_LAYER "") ; �����ذ��w���ذ��

  (setvar "OSMODE"     #os)
  (setvar "SNAPMODE"   #sm)
  (setvar "UCSFOLLOW"  #uf)
  (setvar "UCSVIEW"    #uv)
  (setvar "GRIDMODE"   #gr)
  (setvar "ORTHOMODE"  #ot)
;;; (setvar "WORLDVIEW"  #wv)
	(setvar "CLAYER" #clayer)   ; ���̉�w�ɖ߂� ; 00/09/22 YM ADD
;;;09/21YM  (command "._shademode" "H") ; �B������ ����(��߰�ޱ���)07/07 YM ADD
  (setq *error* nil)
  (princ)
)
;PcCabCutCall

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcCabCutSub
;;; <�����T�v>  : ����ȯĕ��ނ̒���J�b�g
;;; <����>      :
;;; <�߂�l>    :
;;; <�쐬>      : 2000.2.28 YM
;;; <���l>      :
;;;             : �O�c�N�u
;;;*************************************************************************>MOH<
(defun PcCabCutSub (
  &sym ; ���޼���ِ}�`
  /
  #BASEPT
  #BRK #BRK_LINE
  #DD
  #DUM_BP #DUM_P0 #DUM_P1
  #ELM #EN_LAYER_LIS
  #ET #GNAM #H #T
  #I #LOOP
  #LST$$
  #MSG
  #P0 #P1 #P2
  #PT$
  #RAD
  #SS #SS2 #SS_3D #SS_NO3D
  #SYM
  #XD$_BRK #XD$_LSYM #XD$_PMEN #XD$_SYM
  #YOBIX #YOBIY
  #210 #HH #TEI #TT #XD$_PRIM #zu_id #LIS_DIM
  )

;;; �r���[�����ɕۑ�����
  (command "_view" "S" "TEMP")

  (setq #sym &sym)
  (setq #xd$_BRK nil)
  (setq #xd$_LSYM (CFGetXData #sym "G_LSYM"))        ; �g���ް�"G_LSYM"�擾
  (setq #BasePt (nth 1 #xd$_LSYM))                   ; �}���_
  (setq #rad    (nth 2 #xd$_LSYM))                   ; ��]�p�x radian
  (setq #xd$_SYM (CFGetXData #sym "G_SYM"))          ; �g���ް� "G_SYM"�擾
  (setq #H   (nth 5 #xd$_SYM))                       ; ����ي�lH
  (setq #T   (nth 6 #xd$_SYM))                       ; ����َ�t������

  (setq #ss (CFGetSameGroupSS #sym))                 ; ����O���[�v���̑S�}�`�I���Z�b�g

;;; 3DSOLID �Ƃ���ȊO�𕪂���
  (setq #i 0)
  (setq #ss_3D   (ssadd))
  (setq #ss_NO3D (ssadd)); �ړ��̂�
  (setq #lis_DIM '())
  (setq #loop T)
  (repeat (sslength #ss) ; ����O���[�v���̑S�}�`
    (setq #elm (ssname #ss #i)) ; �e�v�f
    (setq #et  (entget #elm))
    (if (= (cdr (assoc 0 #et)) "3DSOLID") ; 3DSOLID   ;----------------------------------------
      (progn
        (ssadd #elm #ss_3D) ; SOLID�̏W�܂�
      )
      (progn                              ; 3DSOLID�ȊO;---------------------------------------
        (if (/= (cdr (assoc 0 #et)) "DIMENSION") ; ���@�ȊO 00/03/22 YM ADD
          (ssadd #elm #ss_NO3D) ; 2D�}�`�̏W�܂�
          (setq #lis_DIM (append #lis_DIM (list #elm))) ; DIMENSION�}�`�̏W�܂�ؽ�
        );_if
;;;       (if (and (= (cdr (assoc 0 #et)) "XLINE") (= (cdr (assoc 8 #et)) "C_BREAKH"))  ; 00/03/23 BL �Ȃ� �ۗ���
;;;         (progn                                         ; XLINE�Ȃ�
;;;           (setq #brk #elm)                             ; �}�`��
;;;           (setq #xd$_BRK (CFGetXData #brk "G_BRK"))    ; �g���ް�"G_BRK"�擾
;;;         )
;;;       );_if
        ;;; PMEN 2 �̈�_��̎擾
        (setq #xd$_PMEN (CFGetXData #elm "G_PMEN"))
        (if (and #xd$_PMEN #loop)
          (progn
            (if (= 2 (car #xd$_PMEN))
              (progn
                (setq #pt$ (GetLWPolyLinePt #elm))                  ; �L���r�l�b�g�̂o�ʂQ�O�`�̈�_������߂�
                (foreach #pt #pt$                                   ; ��_������W�̉������Ƀ\�[�g����
                  (setq #dd (distance #BasePt #pt))
                  (setq #lst$$ (cons (list #pt #dd) #lst$$))
                )
                (setq #lst$$ (reverse (CFListSort #lst$$ 1)))
                (setq #p1 (append (car (nth 0 #lst$$)) (list #T)) ) ; BP����1�ԉ����_ ---> 3D�_
                (setq #loop nil)
              );_progn
            );_if
          );_progn
        );_if
      )
    );_if
    (setq #i (1+ #i))
  );_(repeat

  (if #loop ; 00/03/21 YM ADD
    (progn
      (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; �}�`ID
      (setq #msg (strcat "�}�`ID=" #zu_id "�� PMEN2 ������܂���B\nPcCabCutSub"))
      (CFOutStateLog 0 1 #msg)
      (CFAlertMsg #msg)
      (*error*)
    )
  );_if     ; 00/03/21 YM ADD

;;; #BasePt , #p1 ���� #p0�����߂�stretch�Ɏg�p   ; 03/23 MOD YM
  (setq #dum_BP (mapcar '- #BasePt #BasePt))     ; ���s�ړ�
  (setq #dum_P1 (mapcar '- #p1 #BasePt))         ; ���s�ړ�
  (setq #dum_P1 (RotatePoint #dum_P1 (- #rad)))  ; ��]
  (setq #dum_P0 (list (car #dum_BP) (cadr #dum_P1) (caddr #dum_P1)))
  (setq #dum_P0 (RotatePoint #dum_P0 #rad))  ; ��]
  (setq #p0 (mapcar '+ #dum_P0 #BasePt))     ; ���s�ړ�
  (setq #p2 (list (car #p0) (cadr #p0) #H))

  (setq #en_Layer_lis (Chg_SStoEnLayer #ss_NO3D))       ; �I���--->(<�}�`��> ��w)��ؽĂ�ؽĂɕϊ�
  (MakeTempLayer)                                       ; �L�k��Ɨp�e���|������w�̍쐬
  (command "chprop" #ss_NO3D "" "LA" SKD_TEMP_LAYER "") ; �Ώ۷���ȯ�(3DSOLID����)�S�̂������ذ��w�ֈړ�

;;; 3DSOLID�ȊO�̏���
;;; ���ނ𐳖ʂ���݂č��������_�Ƃ���ucs�쐬
;;; ��ʕ���ssget--->stretch(3DSOLID�ذ�ނ��ď���)
  (command "_.ucs" "3"                           ; #p1 �͒�ʏ�ő}���_�����ԉ����_
    #p0 ; ���_
    #p1 ; x����
    #p2 ; y����
  )

  (if (and #xd$_BRK (= 3 (car #xd$_BRK)) )
    (progn
      (setq #brk_line (caddr (cdr (assoc 10 (entget #brk)))) )
    )
    (progn
;;;     (CFAlertErr "���̃A�C�e���ɂ͐L�k���C��������܂���ł���")(*error*)   ; 00/03/19 �Վ�
      (princ "\n���̃A�C�e���ɂ͐L�k���C��������܂���ł���.")   ; 00/03/19 �Վ�
      (setq #brk_line 100) ; 00/03/19 �Վ�
    )
  );_if

;;; ��گ� �����L�߂ɑI������
  (setq #yobix 1000.0)
  (setq #yobiy 1.0)

  (command "_.stretch"
    (ssget "C"
      (list (+ (distance #p1 #p0) #yobix) (+ #brk_line #yobiy))
      (list (- #yobiy) (- #yobiy))
      (list (cons 8 SKD_TEMP_LAYER)) ; �����ذ��w
    )
    ""
    '(1 -1)
    (strcat "@" "0," (rtos CG_CabCut))
  )

  (setq #ss2 (ssget "X" (list (cons 8 SKD_TEMP_LAYER))))
;;; (command "chprop" #ss2 "" "C" "2" "") ; ���F
;;; (command "_.move" #ss2 "" "0,0" (list 0 (- CG_CabCut))) ; stretch�ňړ����Ă��܂����e�}�`�̈ړ�
  (BackLayer #en_Layer_lis) ; ��w�����ɖ߂�
  (command "_.ucs" "P")

;;; 3DSOLID�̏��� ��ʂ��܂߂�2D�}�`��L�k�������3DSOLID�č쐬(�v����)
  (setq #i 0)
  (setq #gnam (SKGetGroupName (ssname #ss_3D 0))) ; ��ٰ�ߖ�
  (command "._UCS" "W")

  (repeat (sslength #ss_3D)
    (setq #elm (ssname #ss_3D #i))  ; �eSOLID
;;;    (setq #xd$_PRIM (entget #elm '("G_PRIM")))
;;;    (setq #gnam (SKGetGroupName #elm)) ; ��ٰ�ߖ�
;;;   (command "._UCS" "W")
;;;    (setq #elm (SKS_RemakePrim #elm)) ; #elm  "G_PRIM"��������"3DSOLID"�ŁA��w"Z_00_00_00_01"
    (setq #elm (PcRemakePrim_CabCut #elm)) ; #elm  "G_PRIM"��������"3DSOLID"�ŁA��w"Z_00_00_00_01"
;;;   (command "._UCS" "P")
    (command "-group" "A" #gnam #elm "") ; �O���[�v�ɓ����
    (setq #i (1+ #i))
  )

;;; ���̎��_�ł�Z=50�̈ʒu�ɃL���r�l�b�g������
;;; (1)�����o��'(0 0 1) and ���t������0����������o�� or ���t������0<�����������o��
  (setq #ss (CFGetSameGroupSS #sym))  ; ����O���[�v���̑S�}�`�I���Z�b�g
;;; #ss_DIM ������

  (setq #i 0)
  (repeat (length #lis_DIM)
    (setq #elm (nth #i #lis_DIM))
    (ssdel #elm #ss)
    (setq #i (1+ #i))
  )

;;; (setq #i 0)
;;; (setq #ss_3D  (ssadd))
;;; (repeat (sslength #ss)                             ; ����O���[�v���̑S�}�`
;;;   (setq #elm (ssname #ss #i))
;;;   (setq #et  (entget #elm))
;;;   (if (= (cdr (assoc 0 #et)) "3DSOLID")            ; SOLID
;;;     (progn
;;;       (setq #xd$_PRIM (CFGetXData #elm "G_PRIM"))  ; �g���ް�"G_PRIM"�擾
;;;       (setq #TEI (nth 10 #xd$_PRIM))               ; ��ʐ}�`
;;;       (setq #210 (cdr (assoc 210 (entget #TEI))))  ; �����o������
;;;       (if (equal #210 '(0 0 1))                    ; ��ʉ����o��'(0 0 1)
;;;         (progn
;;;           (setq #HH  (nth  6 #xd$_PRIM)) ; ���t������
;;;           (setq #TT  (nth  7 #xd$_PRIM)) ; �v�f����
;;;           (if (or (and (< (abs (- #HH 0.0)) 0.1) (> #TT CG_CabCut)) ; ���t������0.0 �v�f����>50.0
;;;                   (and (> #HH CG_CabCut) (<= #TT (- #HH))))         ; ���t������>50.0 �v�f����<-���t������
;;;             (progn
;;;               (ssadd #elm #ss_3D) ; �Y��SOLID
;;;             )
;;;           );_if
;;;         )
;;;       );_if
;;;     )
;;;   );_if
;;;   (setq #i (1+ #i))
;;; )
  (command "_.move" #ss "" "0,0" (list 0 0 (- CG_CabCut))) ; "DIMENSION"�͏���

;;; (PcSlice_Down #BasePt #ss_3D CG_CabCut)

;;; ����ي�lH�̍X�V
  (CFSetXData #sym "G_SYM"
    (list
      (nth  0 #xd$_SYM)
      (nth  1 #xd$_SYM)
      (nth  2 #xd$_SYM)
      (nth  3 #xd$_SYM)
      (nth  4 #xd$_SYM)
      (- (nth  5 #xd$_SYM) CG_CabCut) ; ����ي�lH 50 �������Ȃ�
      (nth  6 #xd$_SYM)
      (nth  7 #xd$_SYM)
      (nth  8 #xd$_SYM)
      (nth  9 #xd$_SYM)
      (nth 10 #xd$_SYM)
      (nth 11 #xd$_SYM)
      (nth 12 #xd$_SYM)
      (- (nth  5 #xd$_SYM) CG_CabCut) ; ����ي�lH 50 �������Ȃ� 00/07/10 MH MOD
      ;(nth  5 #xd$_SYM) ; �L�k�g --- ���̼���ي�l�g���c�� 00/03/23 YM MOD
      (nth 14 #xd$_SYM)
      (nth 15 #xd$_SYM)
      (nth 16 #xd$_SYM)
    )
  )

;;; �r���[�����ɖ߂�
  (command "_view" "R" "TEMP")

  (setq *error* nil)
  (princ)
);PcCabCutSub


;<HOM>*************************************************************************
; <�֐���>    : PcRemakePrim_CabCut
; <�����T�v>  : �v�f�}�`�̊g���f�[�^��񂩂�v�f���č쐬����(H800 PcCabCutSub��p)
; <�q�L�X�E>  : �}�`��"G_PRIM"��������"3DSOLID"�ŁA��w"Z_00_00_00_01"�ɂ������
; <�쐬��>    : 1998-07-30 S.Kawamoto ��2000.4.1 YM MOD��2000.8.17 MH MOD
; <���l>      : �v�f�}�`(G_PRIM)�A�v�f��ʐ}�`(G_BODY)�A�v�f����ʐ}�`(G_ANA)��
;               �������ɍč쐬����
;               04/01 YM �����o�������̔��f��t������
;               08/17 MH ��ʗ̈悪XY���ʂŌ��l��CG_CabCut��菬�̃P�[�X�̏����ǉ�
;*************************************************************************>MOH<
(defun PcRemakePrim_CabCut (
  &prm        ;(ENAME)�v�f��èè��   "G_PRIM"��������"3DSOLID"�ŁA��w"Z_00_00_00_01"
  /
  #prxd$ #dn #eg$ #prm #bdxd$ #ana$ #i #ana #anxd$ #typ
  #38 #EN_KOSU1 #EN_KOSU2 #teimen #NEW_SOLID #pt$ #FLG #chkZ
  #NEW_INTER #NEW_INTER_HAND #NEW_SOLID_HAND
  #210 #ELM_T #EN #HH #TT
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PcRemakePrim_CabCut ////")
  (CFOutStateLog 1 1 " ")

  (command "vpoint" "1,-1,1")
  ;// ����è�ނ̊g���ް����擾
  (setq #prxd$ (CFGetXData &prm "G_PRIM"))
  (setq #dn (nth 10 #prxd$))   ;// 3DSOLID�̒�ʗ̈�}�`��(�|�����C��)
  (if (/= #dn nil)
    (progn
      ;// ��ʗ̈�̺�߰��د�ނɓW�J����
      (setq #eg$ (entget #dn)) ; ��ʗ̈�}�`(�|�����C��)���
      (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER = "Z_00_00_00_01"
      (setq #teimen (entlast))
      (setq #eg$ (entget #teimen)); �R�s�[������ʗ̈�}�`���(��w�͓����ł�����ق͕ς��) ---> (entlast)
      (setvar "CLAYER" SG_PCLAYER)  ; ���݂̉�w��SG_PCLAYER�ɐݒ�
      ;// �v�f�̍č쐬
      (if (/= (car #prxd$) 3) ; "G_PRIM" ���߂��P��ʂłȂ� ���ݕt�� or ������
        (progn
					;2020/01/08 YM MOD AutoCAD2009�Ή�
          (command "_extrude" #teimen "" "T" (nth 9 #prxd$) (nth 7 #prxd$))  ;// ����"7"��ð�ߊp�x"9"�ŉ��o��
;;;          (command "_extrude" #teimen "" (nth 7 #prxd$) (nth 9 #prxd$))  ;// ����"7"��ð�ߊp�x"9"�ŉ��o��
          (setq #new_SOLID (entlast))
          (setq #new_SOLID_HAND (cdr (assoc 5 (entget #new_SOLID))))

          ;;; 00/08/17 MH ADD
          ;;; ��ʗ̈�}�`��XY���ʂŌ��ݒl���X�g���b�`�ړ���CG_CabCut��菬�̏ꍇ
          ;;; ����O�ɃI���W�i��3DSOLID���ړ�������
          ;(setq #FLG nil)
          ;(if (>= CG_CabCut (nth 7 #prxd$)) (progn
          ;  (setq #pt$ (GetLWPolyLinePt #teimen))
          ;  (setq #FLG 'T)
          ;  (setq #chkZ (caddr (car #pt$)))
          ;  ;;; �|�����C�����\������_��Z�l�����ꂾ����= XY���ʐ}�`
          ;  (foreach #pt #pt$
          ;    (if (not (equal #ChkZ (caddr #pt) 0.001)) (setq #FLG nil))
          ;  ) ; foreach
          ;  ;;; �I���W�i��3DSOLID���ړ�
          ;  (if #FLG (command "_move" &prm "" '(0 0 0) (list 0 0 CG_CabCut) ""))
          ;)); if progn

          ;;; ���̎��_�ŐV����SOLID�ƌÂ�SOLID�̗�������
          (setq #en_kosu1 (CMN_all_en_kosu)) ; �}�ʏ�ɂ���}�`�̑���
          ;;; �V����SOLID�ƌÂ�SOLID�̋��ʕ���
          (command "._intersect" #new_SOLID &prm "") ; ���ʕ��������邩�ǂ���
          ;(if (and #FLG (entget &prm))
          ;  (command "_move" &prm "" (list 0 0 CG_CabCut) '(0 0 0) ""))
          ;;; #new_SOLID &prm �̏��ԏd�v #new_SOLID �� &prm �̏ꍇ
          ;;; #new_SOLID���c��A&prm��������
          (setq #en_kosu2 (CMN_all_en_kosu)) ; �}�ʏ�ɂ���}�`�̑���
          (setq #new_INTER (entlast))
          (setq #prm (entlast)) ; "3DSOLID" #new_SOLID �� &prm �̏ꍇ
          (setq #new_INTER_HAND (cdr (assoc 5 (entget #new_INTER))))

          ;;; ������-1==>���ʕ�������   ������-2==>���ʕ����Ȃ�
          (if (= (- #en_kosu1 #en_kosu2) 2) ; OK!
            (progn
              ;;; �����o�����������΂������̂Ŕ��Ε����ɉ��߂č쐬
              (entmake #eg$) ; SG_PCLAYER = "Z_00_00_00_01"
              (setq #teimen (entlast))
              ;00/08/23 SN MOD
              ;��ʉ����o���̌��݂��������v�f�͔��΂ɂ��Ȃ�
              (setq #HH  (nth  6 #prxd$)) ; ���t������
              (setq #TT  (nth  7 #prxd$)) ; �v�f����
              (setq #210 (cdr (assoc 210 (entget #dn))))  ; �����o������
              (if (and (equal #210 '(0 0 1))              ; ��ʉ����o��'(0 0 1)
                       (< #TT CG_CabCut))                 ; �v�f����<50.0
                #TT
                (setq #TT (- #TT))
              )
              (command "_extrude" #teimen "" #TT (nth 9 #prxd$))
              ;(command "_extrude" #teimen "" (- (nth 7 #prxd$)) (nth 9 #prxd$))
              (setq #prm (entlast)) ; "3DSOLID"
            )
          );_if

          (if (= (- #en_kosu1 #en_kosu2) 1) ; �Â�SOLID���V����SOLID���V����SOLID
            (progn ; G_PRIM�X�V
              (if (equal #new_INTER_HAND #new_SOLID_HAND) ; ����ق�����
                (progn
                  (setq #210 (cdr (assoc 210 (entget #dn))))  ; �����o������
                  (if (equal #210 '(0 0 1))                    ; ��ʉ����o��'(0 0 1)
                    (progn
                      (setq #HH  (nth  6 #prxd$)) ; ���t������
                      (setq #TT  (nth  7 #prxd$)) ; �v�f����
                      (if (or (and (< (abs (- #HH 0.0)) 0.1) (> #TT CG_CabCut)) ; ���t������0.0 �v�f����>50.0
                              (and (> #HH CG_CabCut) (<= #TT (- #HH))))         ; ���t������>50.0 �v�f����<-���t������
                        (progn
                          (if (< #TT 0.0)
                            (setq #elm_T (+ #TT CG_CabCut))  ; �v�f���� ���̏ꍇ �����o�������{
                            (setq #elm_T (- #TT CG_CabCut))  ; �v�f���� ���̏ꍇ �����o�������|
                          );_if
                          (setq #prxd$ (CFModList #prxd$ (list (list 7 #elm_T))))
                        )
                      );_if
                    )
                  );_if
                )
                (progn
                  (entdel (entlast)) ; ���ʕ���SOLID�폜 �Â�SOLID���V����SOLID���V����SOLID
                  ;;; �����������̂ł�����x�쐬
                  (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER = "Z_00_00_00_01"
                  (setq #teimen (entlast))
									;2010/01/08 YM MOD AutoCAD2009�Ή�
                  (command "_extrude" #teimen "" "T" (nth 9 #prxd$) (nth 7 #prxd$))  ;// ����"7"��ð�ߊp�x"9"�ŉ��o��
;;;                  (command "_extrude" #teimen "" (nth 7 #prxd$) (nth 9 #prxd$))  ;// ����"7"��ð�ߊp�x"9"�ŉ��o��
                  (setq #prm (entlast)) ; "3DSOLID"
                )
              );_if
            )
          );_if


          ;// ��������è�ނ��폜
;;;          (entdel &prm) ; ���� 3DSOLID
          (CFSetXData #prm "G_PRIM" #prxd$) ; �����o���د�ނɊg���ް�"G_PRIM"���
          ;// ���̍�蒼��
          (setq #bdxd$ (CFGetXData #dn "G_BODY")); ��ʐ}�`(�|�����C��)��"G_BODY" : PLINE ��� or ��ʂɕt��������
          (if (/= #bdxd$ nil)
            (progn
              (setq #ana$ nil)
              (setq #i 2)
              (repeat (nth 1 #bdxd$)        ; ���ް������J��Ԃ�
                (setq #ana (nth #i #bdxd$)) ; ���}�`�� #i=2
                (setq #anxd$ (CFGetXData #ana "G_ANA"))
                (setq #eg$ (entget #ana)) ; ���}�`���
                ;// ���̉��o��
                (setq #typ (nth 1 #anxd$)) ; ���[������

;;;                (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; 00/02/29 YM ADD ; ���}�`�̺�߰SG_PCLAYER="Z_00_00_00_01"
                (cond
                  ((= #typ 0)  ;// �ђʌ�
                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$))       ; ���}�`�̺�߰  SG_PCLAYER="Z_00_00_00_01"
										;2010/01/08 YM MOD AutoCAD2009�Ή�
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) (nth 7 #prxd$)) ; ���̉����o�� nth 7����  nth 3ð�ߊp�x
;;;                    (command "_extrude" (entlast) "" (nth 7 #prxd$) (nth 3 #anxd$)) ; ���̉����o�� nth 7����  nth 3ð�ߊp�x
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 0 (nth 2 #anxd$) (nth 3 #anxd$))) ; ���[������ 0 �ђʌ�
                  )
                  ((= #typ 1)  ;// ��ʂ���т�
                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER="Z_00_00_00_01"
										;2010/01/08 YM MOD AutoCAD2009�Ή�
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) (nth 2 #anxd$)) ; ���̉����o�� nth 2���[��  nth 3ð�ߊp�x
;;;                    (command "_extrude" (entlast) "" (nth 2 #anxd$) (nth 3 #anxd$)) ; ���̉����o�� nth 2���[��  nth 3ð�ߊp�x
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 1 (nth 2 #anxd$) (nth 3 #anxd$))) ; ���[������ 1 ��ʂ���т�
                  )
                  ((= #typ 2)  ;// ��ʂ���т�
                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER="Z_00_00_00_01"
										;2010/01/08 YM MOD AutoCAD2009�Ή�
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) (nth 2 #anxd$)) ; ���̉����o�� nth 2���[��  nth 3ð�ߊp�x
;;;                    (command "_extrude" (entlast) "" (nth 2 #anxd$) (nth 3 #anxd$)) ; ���̉����o�� nth 2���[��  nth 3ð�ߊp�x
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 2 (nth 2 #anxd$) (nth 3 #anxd$))) ; ���[������ 2 �ђʌ�
                  )
                )

                ;// �v�f�Ƃ̍����Ƃ�
                (command "_subtract" #prm "" (entlast) "")
                (setq #i (1+ #i))
              );_(repeat
            )
          );_if
          #prm ; �߂�l
        );_progn ; "G_PRIM" ���߂��P��ʂłȂ� ���ݕt�� or ������
      ;else
        nil      ; "G_PRIM" ���߂��P��ʂ̂Ƃ�
      );_if
    )
  )
)
; PcRemakePrim_CabCut

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcSlice_Down
;;; <�����T�v>  : ���ނ̽ײ�+�����ړ�(�O�ʂ̔�)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.2.28 YM 3/22����
;;; <���l>      :
;;;             : �O�c�N�u
;;;*************************************************************************>MOH<
(defun PcSlice_Down (
  &pt   ; �~��̒��S�_
  &ss   ; �ײ��OSOLID�I���
  &dist ; �ײ��ʂ̒�ʂ���̋���
  /
  #CIR #CUT #EN #EN2 #I #NEW_LIS #OLD_LIS #XD$_PRIM #KOSU #tei #ELM_T #TT
  )
  (if (and &ss (> (sslength &ss) 0))
    (progn
      (command "._circle" &pt "1000")         ; ���S���}���_�A���a1000�̉~
      (setq #cir (entlast))
      (command "._region" #cir "")            ; �~--->region(�ײ������̖��)
      (setq #cut (entlast))
      (command "._move" #cut "" (list 0 0 0) (list 0 0 &dist))   ; ���Ĉʒu�Ɉړ�
      (setq #old_lis (CMN_all_en_list))       ; (�}�ʏ�̑S�Ă̐}�`�����X�g(<�}�`��1>,2,3,...,n)
      (command "._slice" &ss "" "O" #cut "B") ; �ײ��� &en���
      (setq #new_lis (CMN_all_en_list))       ; (�}�ʏ�̑S�Ă̐}�`�����X�g(<�}�`��1>,2,3,...,n) #old_lis���1����

      (setq #i (+ (car #old_lis) 1))
      (setq #kosu (- (length (cdr #new_lis)) (length (cdr #old_lis))))
      (repeat #kosu
        (setq #en2 (nth #i #new_lis))           ; �ײ���ǉ��د�� #en2
        (entdel #en2) ; �ײ��������̂��폜
        (setq #i (1+ #i))
      )
      (entdel #cut) ; ��폜
      (command "._move" &ss "" "0,0,0" (list 0 0 (- &dist))) ; �ײ������ړ�

    ;;; �v�f���݂̕ύX(�e���̂���SOLID�̂�) 00/03/22 YM MOD
    ;;; ��ʗ̈�� stretch �}�`����ٕω��Ȃ�
      (setq #i 0)
      (setq #kosu (sslength &ss))
      (repeat #kosu
        (setq #en (ssname &ss #i))                  ; �e�د�� #en
        (setq #xd$_PRIM (CFGetXData #en "G_PRIM"))  ; �g���ް�"G_PRIM"�擾
        (setq #TT (nth  7 #xd$_PRIM))               ; �v�f����
        (if (< #TT 0.0)
          (setq #elm_T (+ (nth  7 #xd$_PRIM) &dist))  ; �v�f���� ���̏ꍇ �����o�������{
          (setq #elm_T (- (nth  7 #xd$_PRIM) &dist))  ; �v�f���� ���̏ꍇ �����o�������|
        );_if

        (CFSetXData #en "G_PRIM"                    ; "G_PRIM"���t�������̍X�V   ; �������v�ύX
          (list
            (nth  0 #xd$_PRIM)
            (nth  1 #xd$_PRIM)
            (nth  2 #xd$_PRIM)
            (nth  3 #xd$_PRIM)
            (nth  4 #xd$_PRIM)
            (nth  5 #xd$_PRIM)
            (nth  6 #xd$_PRIM)
            #elm_T             ; �v�f���� ; �������v�ύX
            (nth  8 #xd$_PRIM) ; �X�Ίp�x
            (nth  9 #xd$_PRIM)
            (nth 10 #xd$_PRIM) ; ��ʐ}�`
          )
        )
        (setq #i (1+ #i))
      );_(repeat
    )
  );_if

  (princ)
);PcSlice_Down

;<HOM>*************************************************************************
; <�֐���>    : ItemSelKEKOMI
; <�����T�v>  : ���ёI���֐�
;               �w��_���ɱ��т�����ꍇ�ͱ��ёI��
;               �w��_���ɱ��т��Ȃ��ꍇ
;               �@������E���F�͈͓��ɑS�ē����Ă��鱲�т�I��
;               �@�E���獶���F�͈͓��Ɉꕔ�ł������Ă��鱲�т�I��
; <����>      : &XDataLst$$ �I��Ώ۱��т�XDATA�Q
;               (("G_WRKT" "G_FILR")("G_LSYM")) nth 1�͸�ٰ�ߏ����p
;               &iCol �I���ѕ\���F
; <�߂�l>    : �I���
; <�쐬>      : 00/09/06 SN ADD 01/01/18 YM ����
; <���l>      :(��АL�k����ޗp)
;*************************************************************************>MOH<
(defun ItemSelKEKOMI(
	&XDataLst$$
	&iCol
	&SKK$ ; ���i����ؽ� �۱����("1" "1" "?"),�ݸ����("1" "1" "2")
  /
  #enp #pp1 #pp2 #en
  #ssRet #ss #sswork
  #gmsg #i #ii #setflag
  #engrp #ssgrp
  #xd$ #ENR #RET$
  )

  ;*********************************************
  ; �J��Ԃ����т̑I��
  ;*********************************************
  (setq #ssRet (ssadd))
  (setq #pp1 T)
  (while #pp1
    ;---------------------------------------------
    ; ���ш��I���̏���
    ;---------------------------------------------
    (setq org*error* *error*)   ;ItemSel���ꏈ�� ���X��*error*�֐����L��
    (setq *error* cancel*error*);ItemSel���ꏈ�� *error*�֐���ItemSel�p�̊֐���킹��
    (setq #enp (entselpoint "\n�A�C�e����I��:"))
    (setq *error* org*error*)   ;ItemSel���ꏈ�� ���X��*error*�֐��ɖ߂�
    (setq #pp1 (cadr #enp))
    ;�����݉���
    (if #pp1 (progn
      (setq #en #enp)
      ;�I��_�ɵ�޼ު�Ă���
      (if (car #en)
        (progn;then
          ;�I���޼ު�Ă�I��Ăɉ��Z
          (setq #ss (ssadd))
          (ssadd (car #en) #ss)
        );end progn
        (progn;else
          ;���w�菈��
          (setq #pp2 nil)
          (setq #gmsg " ��������̺�Ű���w��:")
          (while (not #pp2);��Ű���I�������܂�ٰ��
            (setq #pp2 (getcorner #pp1 #gmsg))
            (if #pp2
              ;�����݉���
              (progn
                (if (< (car (trans #pp1 0 2)) (car (trans #pp2 0 2)))
                  ;�����E�I��
                  (progn;then
                    (setq #sswork (ssget "W" #pp1 #pp2))
                    (setq #ss (ItemSurplus #sswork &XDataLst$$))
                    (setq #sswork  nil)
                  );end progn
                  ;�E����
                  (progn;else
                    (setq #ss (ssget "C" #pp1 #pp2))
                  );end progn
                );end if
              );end progn
              ;�E���݉���
              (progn
                (princ "\n���̎w�肪�����ł�.")
                (setq #gmsg "\n�A�C�e����I��: ��������̺�Ű���w��:")
              )
            );end if
          );end while
        );end progn
      );end if
    ));end if - progn
    ;---------------------------------------------
    ;�I���A�C�e���̐F��ς���
    ;---------------------------------------------
    (if #ss (progn
      (setq #ret$ (ChangeItemColorKEKOMI #ss &iCol &SKK$))
      (setq #ssGrp (car  #ret$))
      ;�F��ς������т�߂�l�I��Ă։��Z
      (setq #i 0)
      (repeat (sslength #ssGrp)
        (ssadd (ssname #ssGrp #i) #ssRet)
        (setq #i (1+ #i))
      )
      ;�I��Ă��芎�F�ύX�����A�C�e���������ꍇ�A�I��s�̃A�C�e���Ƃ݂Ȃ��B
      (if (and (> (sslength #ss) 0) (<= (sslength #ssGrp) 0))
        (CFAlertErr "���̃A�C�e���͑I���ł��܂���B")
;;;        (CFAlertErr "�V���{�����܂܂�Ă��܂���B")
      )
      (setq #ss nil)
      (setq #ssGrp nil)
    ));end if - progn
  );end while

  ;*********************************************
  ; �Ώۏ������ёI��
  ;*********************************************
  (setq #enR 'T)
  ;�E���݉���or�߂�l�I��Ă��Ȃ��Ȃ�����I��
  (while (and #enR (> (sslength #ssRet) 0))
    (setq #enR (car (entsel "\n�Ώۂ��珜���A�C�e����I��:")))
    ;�߂�l�I��Ă����ް�̂ݏ�������B
    (if (and #enR (ssmemb #enR #ssRet))(progn
      ;�ꎞ�I�ɑI��Ă��쐬
      (setq #sswork (ssadd))
      (ssadd #enR #sswork)
      ;�I���т̐F��߂�
      (setq #ret$ (ChangeItemColorKEKOMI #sswork nil &SKK$))
      (setq #ssGrp (car  #ret$))
;;;      (setq #ssGrp (ChangeItemColor #sswork &XDataLst$$ nil))
      ;�F��߂������т�߂�l�I��Ă��珜��
      (setq #i 0)
      (repeat (sslength #ssGrp)
        (ssdel (ssname #ssGrp #i) #ssRet)
        (setq #i (1+ #i))
      )
      (setq #sswork nil)
      (setq #ssGrp nil)
    ));end if - progn
  ); while

  #ssRet
);ItemSelKEKOMI

;<HOM>*************************************************************************
; <�֐���>    : ChangeItemColorKEKOMI
; <�����T�v>  : �I��ĂɊ܂܂�鱲�т̐F��ς���
;             : �I��ĂɈꕔ�ł��܂܂�Ă���Ƃ��̸�ٰ�߂�T�������B
;             :
; <�߂�l>    : (�F��ς����S�Ă̵�޼ު�Ă��܂ޑI���,�����ؽ�)
;             :
; <�쐬>      : 00/09/22 SN ADD 01/01/17 YM ����
; <���l>      : &iCol=nil�� �Ȃɂ��I�����Ă��Ȃ���Ԃɖ߂��B
;               ���i����"11?"�̂ݐF��ς���(��АL�k����ޗp)
;               �ݸ,����,��ۂ��I���\(���@�L�k+�y�ړ����邽��)
;*************************************************************************>MOH<
(defun ChangeItemColorKEKOMI(
	&ss
	&iCol
	&SKK$ ; ���i����ؽ� �۱����("1" "1" "?"),�ݸ����("1" "1" "2")
  /
	#ENGRP #ENR #I #II #J #SSGRP #SSRET #ssdum #engrp$
  )
  (setq #i 0)
	(setq #engrp$ nil)
  (setq #ssRet (ssadd))
  (setq #ssdum (ssadd))

  (setq CG_BASESYM (CFGetBaseSymXRec))
  (repeat (sslength &ss)
;;;		(princ "\n#i = ")(princ #i)
    (setq #enR (ssname &ss #i))
    (if (not (ssmemb #enR #ssdum))
      ;��ٰ�߱��т̏���
      (if (and (setq #engrp (SearchGroupSym #enR))      ; ����ق���
							 (setq #ssGrp (CFGetSameGroupSS #engrp))) ; ��ٰ�ߑS��
		 		(progn
;;;					(if (CheckFloorCAB #engrp) ; "11?"
;;;					(if (CheckSKK$ #engrp &SKK$) ; &SKK$="11?"�� 01/02/22 YM
					(if (or (CheckSKK$ #engrp &SKK$)
									(CheckSKK$ #engrp (list (itoa CG_SKK_ONE_GAS)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_ETC)))  ; ��� ; 01/08/31 YM MOD ��۰��ى�
									(CheckSKK$ #engrp (list (itoa CG_SKK_ONE_SNK)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_ETC)))  ; �ݸ ; 01/08/31 YM MOD ��۰��ى�
									(CheckSKK$ #engrp (list (itoa CG_SKK_ONE_WTR)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_ETC)))) ; ����; 01/08/31 YM MOD ��۰��ى�
						(progn
							(setq #engrp$ (cons #engrp #engrp$)) ; �����ؽ�
			        (if &iCol;�F�ύX�w��
			          (GroupInSolidChgCol2 #engrp &iCol)
			          (if (equal CG_BASESYM #engrp);�����
			            (GroupInSolidChgCol #engrp CG_BaseSymCol)
			            (GroupInSolidChgCol2 #engrp "BYLAYER")
			          )
			        );_if
		          ;�߂�l�I��Ăɉ��Z
		          (setq #ii 0)
		          (repeat (sslength #ssGrp)
		            (ssadd (ssname #ssGrp #ii) #ssRet)
		            (setq #ii (1+ #ii))
		          );end repeat
						)
					);_if

					;��x�T����������ٰ�߂�į����Ă���(�I��Ăɉ��Z)
          (setq #j 0)
          (repeat (sslength #ssGrp)
            (ssadd (ssname #ssGrp #j) #ssdum)
            (setq #j (1+ #j))
          )
          (setq #ssGrp nil)
        )
      );_if
    );_if
    (setq #i (1+ #i))
  );end repeat
  (list #ssRet #engrp$)
);ChangeItemColorKEKOMI

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:H800
;;; <�����T�v>  : ��Е�����հ�ް�w�蒷���L�k��������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/01/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:H800 (
  /
	#210$ #410$ #510$ #BASE #BASEPT #BASESYM #DUM$ #DUMPT$ #I #PT$ #RET$ #SKK #SS
	#SSDUM #SSWT #SYM$ #SYS$ #WT #WTH #XDWT$ #XDWTSET$ #pdsize #pd
  )

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
		  (defun TempErr ( msg / #msg )
				(setq KEKOMI_COM nil) ; ��АL�k��
				(setq KEKOMI_BRK nil)
			  (command "_undo" "b")
				(setvar "pdmode" #PD)
			  (setvar "PDSIZE" #pdsize)
		    (setq *error* nil)
		    (princ)
		  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

;///////////////////////////////////////////////////////////////////////////////////
; �����==>PMEN2�O�`�̈�
;///////////////////////////////////////////////////////////////////////////////////
			(defun ##GetPMEN_PT$ (
				&sym
			  /
				#PMEN2 #PT$
			  )
	      (setq #pmen2 (PKGetPMEN_NO &sym 2))  ; PMEN2
	      (if (= #pmen2 nil)
	        (setq #pmen2 (PK_MakePMEN2 &sym))  ; PMEN2 ���Ȃ���΍쐬
	      );_if
	      (setq #pt$ (GetLWPolyLinePt #pmen2)) ; PMEN2 �O�`�̈�

				#pt$
			)
;///////////////////////////////////////////////////////////////////////////////////

	; �O����
  (setq *error* TempErr)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")
;;;	(StartUndoErr)

	; 01/10/25 YM ADD-S
	(setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "PDSIZE" 10)
	(setvar "pdmode" 34)
	; 01/10/25 YM ADD-E

; 01/06/28 YM ADD ����ނ̐��� Lipple
; 02/04/23 YM Lipple�ł��g������
;;;02/04/23YM@DEL(if (equal (KPGetSinaType) 2 0.1)
;;;02/04/23YM@DEL	(progn
;;;02/04/23YM@DEL    (CFAlertMsg msg8)
;;;02/04/23YM@DEL    (quit)
;;;02/04/23YM@DEL	)
;;;02/04/23YM@DEL	(progn


	(setq KEKOMI_COM T) ; ��АL�k��
	(setq KEKOMI_BRK nil)
	(setq #ssWT (ssadd))
  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
	(setq #BASESYM (CFGetBaseSymXRec)) ; �����

	;;; ��АL�k�p�۱���ނ̂ݐԐF�ɂ���
	(setq #ss (ItemSelKEKOMI '(("DUMMY")("G_LSYM")) CG_InfoSymCol '("1" "1" "?")))
	; �F��߂�
	(setq #sym$ (cadr (ChangeItemColorKEKOMI #ss nil '("1" "1" "?"))))
;;;	(foreach sym #sym$
;;;    (if (equal CG_BASESYM sym);�����
;;;      (GroupInSolidChgCol sym CG_BaseSymCol)
;;;      (GroupInSolidChgCol2 sym "BYLAYER")
;;;    );_if
;;;	)

	(command "vpoint" "0,0,1"); ���_��^�ォ��
	; �ݸ����,��۷��ނɼݸ,����,��ۂ�����Βǉ�����(2�d�ǉ����Ȃ��悤�ɂ���)
	(setq #dum$ #sym$)
	(setq #210$ nil #410$ nil #510$ nil)
	(foreach #sym #sym$
		(if (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB) (itoa CG_SKK_TWO_BAS) "?")) ; �۱���� ; 01/08/31 YM MOD ��۰��ى�
			(progn
				(setq #pt$ (##GetPMEN_PT$ #sym)) ; ���ފO�`�_��
				(setq #base (cdr (assoc 10 (entget #sym)))) ; ����وʒu
        (setq #dumpt$ (GetPtSeries #base #pt$))     ; #base ��擪�Ɏ��v����
				(if #dumpt$
					(setq #pt$ #dumpt$) ; nil �łȂ�
					(progn ; �O�`�_���ɼ���ق��Ȃ��ꍇ
						(setq #BASEPT (PKGetBaseI4 #pt$ (list #sym))) ; �_��Ƽ���ي�_�P��
						(setq #pt$ (GetPtSeries #BASEPT #pt$))        ; #base ��擪�Ɏ��v����
					)
				);_if
				;�_��(�ʏ���4�_,��Ű����6�_)�ƕύX��������("L","R","U","D")�ƕύX����
				;       "U"
				;   @----------+
				;   | �^�ォ�� |
				;"L"|          |"R"
				;   |          |
				;   +----------+
				;      "D"
				(setq #pt$ (KPChangeArea$ #pt$ "L" -5)) ; ���ފO�`�_��5mm���߂�
				(setq #pt$ (KPChangeArea$ #pt$ "R" -5)) ; ���ފO�`�_��E5mm���߂�
	      (setq #pt$ (AddPtList #pt$))            ; �����Ɏn�_��ǉ�����

				; WT��T��
			  (setq #ssDUM (ssget "CP" #pt$ (list (list -3 (list "G_WRKT"))))) ; �̈����WT�}�`
			  (if (and #ssDUM (> (sslength #ssDUM) 0))
					(progn
						(setq #i 0)
						(repeat (sslength #ssDUM)
							(ssadd (ssname #ssDUM #i) #ssWT)
							(setq #i (1+ #i))
						)
					)
				);_if
			)
		);_if

		(setq #SKK (nth 9 (CFGetXData #sym "G_LSYM")))
		(cond
			((= #SKK CG_SKK_INT_SCA) ; �ݸ���� ; 01/08/31 YM MOD 210-->��۰��ى�
				(setq #410$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SNK)) ; �̈��ݸ ; 01/08/31 YM MOD 410-->��۰��ى�
				(setq #510$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; �̈������ ; 01/08/31 YM MOD 510-->��۰��ى�
			)
			((= #SKK CG_SKK_INT_GCA) ; ��۷��� ; 01/08/31 YM MOD 113-->��۰��ى�
				(setq #210$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_GAS)) ; �̈���� ; 01/08/31 YM MOD 210-->��۰��ى�
			)
		);_cond
	);foreach
	(command "zoom" "p") ; ���_��߂�

	(foreach #dum (append #210$ #410$ #510$)
		(if (member #dum #sym$)
			nil ; ���ɑI������Ă���
			(setq #sym$ (cons #dum #sym$))
		);_if
	);foreach

	; �L�k����
	(if #sym$
		(progn
			;;; �޲�۸ޕ\��
			(setq #ret$ (PcGetStretchKEKOMISizeDlg))
			(setq KEKOMI_COM  (car  #ret$))
			(setq KEKOMI_BRK  (cadr #ret$))

			(if (> (abs KEKOMI_COM) 0.1) ; 0�̂Ƃ�����
				(foreach #sym #sym$
					(PcCabCutCall2 #sym KEKOMI_COM KEKOMI_BRK)
					(PCD_MakeViewAlignDoor (list #sym) 3 T)
					(if (equal #sym #BASESYM)
						(GroupInSolidChgCol #sym CG_BaseSymCol) ; �����قȂ�ΐF������
					);_if
				)
				(CFAlertMsg "\n�L�k���܂���ł����B")
			);_if
		)
		(CFAlertMsg "\n�L�k�Ώۂ̐}�`������܂���B")
	);_if

	; WT�ړ�
  (if (and #ssWT (> (sslength #ssWT) 0))
		(progn
			(setq #i 0)
			(repeat (sslength #ssWT)
				(setq #WT (ssname #ssWT #i))
				(command "_move" #WT "" '(0 0 0) (strcat "@0,0," (rtos (- KEKOMI_COM))))
				(setq #xdWT$    (CFGetXData #WT "G_WRKT"))
				(setq #xdWTSET$ (CFGetXData #WT "G_WTSET"))
				(setq #WTH (- (nth 8 #xdWT$) KEKOMI_COM))
				(if #xdWT$
			    (CFSetXData #WT "G_WRKT"
			      (CFModList #xdWT$
			        (list (list 8 #WTH)) ; WT���t������
			      )
			    )
				);_if
				(if #xdWT$
			    (CFSetXData #WT "G_WTSET"
			      (CFModList #xdWTSET$
			        (list (list 2 #WTH)) ; WT���t������
			      )
			    )
				);_if

				(setq #i (1+ #i))
			)
		)
	);_if

;;;02/04/23YM@DEL	); 01/06/28 YM ADD ����ނ̐��� Lipple
;;;02/04/23YM@DEL);_if

	; �㏈��
  (setq *error* nil)
  (CFCmdDefFinish)
  (PKEndCOMMAND #sys$)
	(setq KEKOMI_COM nil)
	(setq KEKOMI_BRK nil)

	; 01/10/25 YM ADD-S
	(setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)
	; 01/10/25 YM ADD-E

	(princ)

);C:H800

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPCallKekomi
;;; <�����T�v>  : ���������ؽĂ�АL�k �֐�call�p
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/03/22 YM
;;; <���l>      : �ݸ,��ۂ������ɂȂ��Ă����݂���Ύ����L�k
;;;               �װ���]��call�p
;;;*************************************************************************>MOH<
(defun KPCallKekomi (
	&sym$ ; �����ؽ�
  /
	#210$ #410$ #510$ #BASESYM #DUM$ #I #PT$ #SKK #SSDUM #SSWT #SYM$
  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
		  (defun TempErr ( msg / )
				(setq KEKOMI_COM nil) ; ��АL�k��
				(setq KEKOMI_BRK nil)
			  (command "_undo" "b")
		    (setq *error* nil)
		    (princ)
		  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

;///////////////////////////////////////////////////////////////////////////////////
; �����==>PMEN2�O�`�̈�
;///////////////////////////////////////////////////////////////////////////////////
			(defun ##GetPMEN_PT$ (
				&sym
			  /
				#PMEN2 #PT$
			  )
	      (setq #pmen2 (PKGetPMEN_NO &sym 2))  ; PMEN2
	      (if (= #pmen2 nil)
	        (setq #pmen2 (PK_MakePMEN2 &sym))  ; PMEN2 ���Ȃ���΍쐬
	      );_if
	      (setq #pt$ (GetLWPolyLinePt #pmen2)) ; PMEN2 �O�`�̈�
	      (setq #pt$ (AddPtList #pt$))         ; �����Ɏn�_��ǉ�����
				#pt$
			)
;///////////////////////////////////////////////////////////////////////////////////

	(setq #sym$ &sym$)
	; �O����
  (setq *error* TempErr)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")
;;;	(StartUndoErr)
;;;	(setq KEKOMI_BRK nil)
;;;	(setq KEKOMI_COM T)
	(setq #ssWT (ssadd))
	(setq #BASESYM (CFGetBaseSymXRec)) ; �����

;;;	;;; ��АL�k�p�۱���ނ̂ݐԐF�ɂ���
;;;	(setq #ss (ItemSelKEKOMI '(("DUMMY")("G_LSYM")) CG_InfoSymCol '("1" "1" "?")))
;;;	; �F��߂�
;;;	(setq #sym$ (cadr (ChangeItemColorKEKOMI #ss nil '("1" "1" "?"))))

	(command "vpoint" "0,0,1"); ���_��^�ォ��
	; �ݸ����,��۷��ނɼݸ,����,��ۂ�����Βǉ�����(2�d�ǉ����Ȃ��悤�ɂ���)
	(setq #dum$ #sym$)
	(setq #210$ nil #410$ nil #510$ nil)
	(foreach #sym #sym$
		(if (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB) (itoa CG_SKK_TWO_BAS) "?")) ; �۱���� ; 01/08/31 YM MOD ��۰��ى�
			(progn
				(setq #pt$ (##GetPMEN_PT$ #sym)) ; ���ފO�`�_��
;;;				; WT��T��
;;;			  (setq #ssDUM (ssget "CP" #pt$ (list (list -3 (list "G_WRKT"))))) ; �̈����WT�}�`
;;;			  (if (and #ssDUM (> (sslength #ssDUM) 0))
;;;					(progn
;;;						(setq #i 0)
;;;						(repeat (sslength #ssDUM)
;;;							(ssadd (ssname #ssDUM #i) #ssWT)
;;;							(setq #i (1+ #i))
;;;						)
;;;					)
;;;				);_if
			)
		);_if

		(setq #SKK (nth 9 (CFGetXData #sym "G_LSYM")))
		(cond
			((= #SKK CG_SKK_INT_SCA) ; �ݸ���� ; 01/08/31 YM MOD 112-->��۰��ى�
				(setq #410$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SNK)) ; �̈��ݸ ; 01/08/31 YM MOD 410-->��۰��ى�
				(setq #510$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; �̈������ ; 01/08/31 YM MOD 510-->��۰��ى�
			)
			((= #SKK CG_SKK_INT_GCA) ; ��۷��� ; 01/08/31 YM MOD 113-->��۰��ى�
				(setq #210$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_GAS)) ; �̈���� ; 01/08/31 YM MOD 210-->��۰��ى�
			)
		);_cond
	);foreach
	(command "zoom" "p") ; ���_��߂�

	; ���炩���ߐL�k�ʕ����Ε����Ɉړ����Ă���(2��L�k���������ɂȂ��Ă��܂�����)
	(foreach #dum (append #210$ #410$ #510$)
		(setq #ssdum (CFGetSameGroupSS #dum)) ; ����O���[�v���̑S�}�`�I���Z�b�g
		(command "_move" #ssdum "" '(0 0 0) (strcat "@0,0," (rtos KEKOMI_COM)))
	);foreach

	(foreach #dum (append #210$ #410$ #510$)
		(if (member #dum #sym$)
			nil ; ���ɑI������Ă���
			(setq #sym$ (cons #dum #sym$))
		);_if
	);foreach

	; �L�k����
	(if #sym$
		(progn
;;;			;;; �޲�۸ޕ\��
;;;			(setq #ret$ (PcGetStretchKEKOMISizeDlg))
;;;			(setq KEKOMI_COM  (car  #ret$))
;;;			(setq KEKOMI_BRK  (cadr #ret$))

;;;	KEKOMI_COM
;;;	KEKOMI_BRK

			(if (> (abs KEKOMI_COM) 0.1) ; 0�̂Ƃ�����
				(foreach #sym #sym$
					(PcCabCutCall2 #sym KEKOMI_COM KEKOMI_BRK)
					(PCD_MakeViewAlignDoor (list #sym) 3 T)
					(if (equal #sym #BASESYM)
						(GroupInSolidChgCol #sym CG_BaseSymCol) ; �����قȂ�ΐF������
					);_if
				)
				(CFAlertMsg "\n�L�k���܂���ł����B")
			);_if
		)
		(CFAlertMsg "\n�L�k�Ώۂ̐}�`������܂���B")
	);_if

;;;	; WT�ړ�
;;;  (if (and #ssWT (> (sslength #ssWT) 0))
;;;		(progn
;;;			(setq #i 0)
;;;			(repeat (sslength #ssWT)
;;;				(setq #WT (ssname #ssWT #i))
;;;				(command "_move" #WT "" '(0 0 0) (strcat "@0,0," (rtos (- KEKOMI_COM))))
;;;				(setq #xdWT$    (CFGetXData #WT "G_WRKT"))
;;;				(setq #xdWTSET$ (CFGetXData #WT "G_WTSET"))
;;;				(setq #WTH (- (nth 8 #xdWT$) KEKOMI_COM))
;;;				(if #xdWT$
;;;			    (CFSetXData #WT "G_WRKT"
;;;			      (CFModList #xdWT$
;;;			        (list (list 8 #WTH)) ; WT���t������
;;;			      )
;;;			    )
;;;				);_if
;;;				(if #xdWT$
;;;			    (CFSetXData #WT "G_WTSET"
;;;			      (CFModList #xdWTSET$
;;;			        (list (list 2 #WTH)) ; WT���t������
;;;			      )
;;;			    )
;;;				);_if
;;;
;;;				(setq #i (1+ #i))
;;;			)
;;;		)
;;;	);_if

	; �㏈��
  (setq *error* nil)
	(setq KEKOMI_COM nil)
	(setq KEKOMI_BRK nil)
	(princ)
);KPCallKekomi

;<HOM>*************************************************************************
; <�֐���>    : PcGetStretchKEKOMISizeDlg
; <�����T�v>  : ��Е�����հ�ް�w�蒷���l��
; <�߂�l>    : ����(����)
; <�쐬>      : 01/01/12 YM
; <���l>      :
;*************************************************************************>MOH<
(defun PcGetStretchKEKOMISizeDlg (
  /
  #dcl_id #iH #RES #IB
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		(defun ##GetDlgItem ( / #H #B); �޲�۸ނ̌��ʂ��擾����
			(setq #H (atoi (get_tile "H")))
			(setq #B (atoi (get_tile "B")))
  		(done_dialog)
			(list #H #B)
		);##GetDlgItem

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���p���l���ǂ��� ;;; �K�{���ڂ�����
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CHK_edit (
		&sKEY ; key
		&DEF  ; ��̫�Ēl
		&flg  ; �����׸� 0:���p���l , 1:���p���l>0 , 2:nil�łȂ�������
		/
		#val
		)
		(setq #val (read (get_tile &sKEY)))
		(cond
			((and (= &flg 2)(= #val nil))
        (alert "���������͂��ĉ������B")
        (set_tile &sKEY &DEF)
        (mode_tile &sKEY 2)
			)
			((= &flg 0)
		    (if (or (= (type #val) 'INT)
								(= (type #val) 'REAL))
					(princ) ; ���p����������
					(progn
		        (alert "���p�����l����͂��ĉ������B")
		        (set_tile &sKEY &DEF)
		        (mode_tile &sKEY 2)
					)
				);_if
			)
			((= &flg 1)
		    (if (and (or (= (type #val) 'INT)
										 (= (type #val) 'REAL))
								 (> #val 0.001)) ; �X�ɐ����ǂ������ׂ�(0�͕s��)
					(princ) ; OK
					(progn
		        (alert "0���傫�Ȕ��p�����l����͂��ĉ������B")
		        (set_tile &sKEY &DEF)
		        (mode_tile &sKEY 2)
					)
				);_if
		 	)
    );_cond
		(princ)
  );##CHK_edit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; �_�C�A���O�̎��s��
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (not (new_dialog "GetStretchKEKOMISizeDlg" #dcl_id)) (exit))

  ;;; ��̫�Ēl�̐ݒ�
  (setq #iH 50)
  (setq #iB 30)
  (set_tile "H" (itoa #iH))
  (set_tile "B" (itoa #iB))

  ;;; �^�C���̃��A�N�V�����ݒ�
;;;  (action_tile "H" "(PcCheckIntStrSetDefo $key #iH)")
	(action_tile "H" "(##CHK_edit \"H\" #iH 0)")
	(action_tile "B" "(##CHK_edit \"B\" #iB 0)")
;;;  (action_tile "accept" "(setq #RES (##StretchCabSizeData))")
;;;  (action_tile "cancel" "(setq #RES nil)(done_dialog)")
  (action_tile "accept" "(setq #RES (##GetDlgItem))")   ; OK
  (action_tile "cancel" "(setq #RES nil)(done_dialog)") ; cancel

  (start_dialog)
  (unload_dialog #dcl_id)
  #RES
); PcGetStretchKEKOMISizeDlg

;;;01/01/27YM@;;;<HOM>*************************************************************************
;;;01/01/27YM@;;; <�֐���>    : C:StretchCab
;;;01/01/27YM@;;; <�����T�v>  : �������޺����
;;;01/01/27YM@;;; <�߂�l>    : �Ȃ�
;;;01/01/27YM@;;; <�쐬>      : 01/01/26 YM
;;;01/01/27YM@;;; <���l>      :
;;;01/01/27YM@;;;*************************************************************************>MOH<
;;;01/01/27YM@(defun C:StretchCab (
;;;01/01/27YM@  /
;;;01/01/27YM@	#DIST #SS #SYS$ #sym$ #i #elm #ret$ #Brk #BASESYM
;;;01/01/27YM@  )
;;;01/01/27YM@	; �O����
;;;01/01/27YM@	(StartUndoErr)
;;;01/01/27YM@  (setq #sys$ (PKStartCOMMAND))
;;;01/01/27YM@  (CFCmdDefBegin 6)
;;;01/01/27YM@	(setq #BASESYM (CFGetBaseSymXRec)) ; �����
;;;01/01/27YM@	(setq TOKU_COM T)   ; �������޺���ޒ��׸�
;;;01/01/27YM@	(setq CG_TOKU_W nil); �������޺���ޒ�
;;;01/01/27YM@	(setq CG_TOKU_D nil); �������޺���ޒ�
;;;01/01/27YM@	(setq CG_TOKU_H nil); �������޺���ޒ�
;;;01/01/27YM@
;;;01/01/27YM@	;;; �������޺���ޗp(����ȯĐ��i����'("1" "?" "?")�̂ݐԐF�ɂ���)
;;;01/01/27YM@	(setq #ss (ItemSelKEKOMI '(("DUMMY")("G_LSYM")) CG_InfoSymCol '("1" "?" "?")))
;;;01/01/27YM@	; �F��߂�
;;;01/01/27YM@	(setq #sym$ (cadr (ChangeItemColorKEKOMI #ss nil '("1" "?" "?"))))
;;;01/01/27YM@
;;;01/01/27YM@	; �L�k����
;;;01/01/27YM@	(if #sym$
;;;01/01/27YM@		(progn
;;;01/01/27YM@			;;; �޲�۸ޕ\��
;;;01/01/27YM@			(setq #ret$ (PcGetStretchTOKUSizeDlg))
;;;01/01/27YM@			(setq #distW (nth 0 #ret$))
;;;01/01/27YM@			(setq #distD (nth 1 #ret$))
;;;01/01/27YM@			(setq #distH (nth 2 #ret$))
;;;01/01/27YM@			(setq #BrkW  (nth 3 #ret$))
;;;01/01/27YM@			(setq #BrkD  (nth 4 #ret$))
;;;01/01/27YM@			(setq #BrkH  (nth 5 #ret$))
;;;01/01/27YM@
;;;01/01/27YM@			(foreach #sym #sym$
;;;01/01/27YM@				(PcCabCutCall3 #sym #distW #distD #distH #BrkW #BrkD #BrkH)
;;;01/01/27YM@				(PCD_MakeViewAlignDoor (list #sym) 3 T)
;;;01/01/27YM@				(if (equal #sym #BASESYM)
;;;01/01/27YM@					(GroupInSolidChgCol #sym CG_BaseSymCol) ; �����قȂ�ΐF������
;;;01/01/27YM@				);_if
;;;01/01/27YM@			)
;;;01/01/27YM@		)
;;;01/01/27YM@		(CFAlertMsg "\n�L�k�Ώۂ̐}�`������܂���B")
;;;01/01/27YM@	);_if
;;;01/01/27YM@	; �㏈��
;;;01/01/27YM@  (setq *error* nil)
;;;01/01/27YM@  (setq EditFlag nil)
;;;01/01/27YM@  (CFCmdDefFinish)
;;;01/01/27YM@  (PKEndCOMMAND #sys$)
;;;01/01/27YM@	(setq TOKU_COM nil)    ; �������޺���ޒ��׸�
;;;01/01/27YM@	(setq CG_TOKU_W nil)
;;;01/01/27YM@	(setq CG_TOKU_D nil)
;;;01/01/27YM@	(setq CG_TOKU_H nil)
;;;01/01/27YM@	(princ)
;;;01/01/27YM@);C:StretchCab
;;;01/01/27YM@
;;;01/01/27YM@;<HOM>*************************************************************************
;;;01/01/27YM@; <�֐���>    : PcGetStretchTOKUSizeDlg
;;;01/01/27YM@; <�����T�v>  : �������ސL�k���擾�޲�۸ޕ\��
;;;01/01/27YM@; <�߂�l>    : W,D,H ��ڰ�ײ݈ʒuW,D,H
;;;01/01/27YM@; <�쐬>      : 01/01/26 YM
;;;01/01/27YM@; <���l>      :
;;;01/01/27YM@;*************************************************************************>MOH<
;;;01/01/27YM@(defun PcGetStretchTOKUSizeDlg (
;;;01/01/27YM@  /
;;;01/01/27YM@  #BD #BH #BW #D #DCL_ID #H #IB #IBD #IBH #IBW #ID #IH #IW #RES #W
;;;01/01/27YM@  )
;;;01/01/27YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/01/27YM@		(defun ##GetDlgItem ( / #RES); �޲�۸ނ̌��ʂ��擾����
;;;01/01/27YM@			(setq #W  (atoi (get_tile "W" )))
;;;01/01/27YM@			(setq #BW (atoi (get_tile "BW")))
;;;01/01/27YM@			(setq #D  (atoi (get_tile "D" )))
;;;01/01/27YM@			(setq #BD (atoi (get_tile "BD")))
;;;01/01/27YM@			(setq #H  (atoi (get_tile "H" )))
;;;01/01/27YM@			(setq #BH (atoi (get_tile "BH")))
;;;01/01/27YM@  		(done_dialog)
;;;01/01/27YM@			(list #W #D #H #BW #BD #BH)
;;;01/01/27YM@		); �K�{���ڂ�����
;;;01/01/27YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/01/27YM@	  (defun ##CHK_edit (&sKEY / #val #ret)
;;;01/01/27YM@	    (setq #ret nil)
;;;01/01/27YM@			(setq #val (read (get_tile &sKEY)))
;;;01/01/27YM@	    (if (or (= (type (read (get_tile &sKEY))) 'INT)
;;;01/01/27YM@							(= (type (read (get_tile &sKEY))) 'REAL))
;;;01/01/27YM@				(princ) ; OK!
;;;01/01/27YM@				(progn
;;;01/01/27YM@	        (alert "���p�̎����l����͂��ĉ������B")
;;;01/01/27YM@	        (set_tile &sKEY "")
;;;01/01/27YM@	        (mode_tile &sKEY 2)
;;;01/01/27YM@				)
;;;01/01/27YM@	    );_if
;;;01/01/27YM@			#ret
;;;01/01/27YM@	  );##CHK_edit
;;;01/01/27YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/01/27YM@;;;01/01/12YM@	  (defun ##StretchCabSizeData ( / #RES$ #DUMMY$)
;;;01/01/27YM@;;;01/01/12YM@	    ; �K�{���ڂ����Ƀ`�F�b�N�B�����͂ł���΃��b�Z�[�W���o���A���̗��Ƀt�H�[�J�X��߂��B
;;;01/01/27YM@;;;01/01/12YM@	    (cond
;;;01/01/27YM@;;;01/01/12YM@	      ((or (= "" (get_tile "H")) (= "0" (get_tile "H")))
;;;01/01/27YM@;;;01/01/12YM@	        (PcRequireInput "H" "�L���r�l�b�g�̍����l"
;;;01/01/27YM@;;;01/01/12YM@	                               "\n 0 �ȏ�̐��l����͂��ĉ�����")
;;;01/01/27YM@;;;01/01/12YM@			 	)
;;;01/01/27YM@;;;01/01/12YM@	      (t  ;;;�K�{���͊m�F�ł�����A���ʃ��X�g�쐬�B
;;;01/01/27YM@;;;01/01/12YM@	        (setq #RES (atoi (get_tile "H")))
;;;01/01/27YM@;;;01/01/12YM@	        (done_dialog)
;;;01/01/27YM@;;;01/01/12YM@	      )
;;;01/01/27YM@;;;01/01/12YM@	    )
;;;01/01/27YM@;;;01/01/12YM@	    #RES
;;;01/01/27YM@;;;01/01/12YM@	  )
;;;01/01/27YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/01/27YM@  ;;; �_�C�A���O�̎��s��
;;;01/01/27YM@  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
;;;01/01/27YM@  (if (not (new_dialog "GetStretchTOKUSizeDlg" #dcl_id)) (exit))
;;;01/01/27YM@
;;;01/01/27YM@  ;;; �^�C���̃��A�N�V�����ݒ�
;;;01/01/27YM@;;;  (action_tile "H" "(PcCheckIntStrSetDefo $key #iH)")
;;;01/01/27YM@	(action_tile "W"  "(##CHK_edit \"W\") ")
;;;01/01/27YM@	(action_tile "BW" "(##CHK_edit \"BW\")")
;;;01/01/27YM@	(action_tile "D"  "(##CHK_edit \"D\") ")
;;;01/01/27YM@	(action_tile "BD" "(##CHK_edit \"BD\")")
;;;01/01/27YM@	(action_tile "H"  "(##CHK_edit \"H\") ")
;;;01/01/27YM@	(action_tile "BH" "(##CHK_edit \"BH\")")
;;;01/01/27YM@;;;  (action_tile "accept" "(setq #RES (##StretchCabSizeData))")
;;;01/01/27YM@;;;  (action_tile "cancel" "(setq #RES nil)(done_dialog)")
;;;01/01/27YM@  (action_tile "accept" "(setq #RES (##GetDlgItem))")   ; OK
;;;01/01/27YM@  (action_tile "cancel" "(setq #RES nil)(done_dialog)") ; cancel
;;;01/01/27YM@
;;;01/01/27YM@  ;;; ��̫�Ēl�̐ݒ�
;;;01/01/27YM@  (setq #iW  0)
;;;01/01/27YM@  (setq #iBW 20)
;;;01/01/27YM@  (setq #iD  0)
;;;01/01/27YM@  (setq #iBD 20)
;;;01/01/27YM@  (setq #iH  0)
;;;01/01/27YM@  (setq #iBH 20)
;;;01/01/27YM@  (set_tile "W"  (itoa #iW ))
;;;01/01/27YM@  (set_tile "BW" (itoa #iBW))
;;;01/01/27YM@  (set_tile "D"  (itoa #iD ))
;;;01/01/27YM@  (set_tile "BD" (itoa #iBD))
;;;01/01/27YM@  (set_tile "H"  (itoa #iH ))
;;;01/01/27YM@  (set_tile "BH" (itoa #iBH))
;;;01/01/27YM@  (start_dialog)
;;;01/01/27YM@  (unload_dialog #dcl_id)
;;;01/01/27YM@  #RES
;;;01/01/27YM@); PcGetStretchTOKUSizeDlg

;<HOM>*************************************************************************
; <�֐���>    : PKGetSS_SYMFromSS
; <�����T�v>  : �I���==>"11?"�̼���ِ}�`ؽ�
; <�߂�l>    : "11?"�̼���ِ}�`ؽ�
; <�쐬>      : 01/01/17 YM
; <���l>      : ��АL�k�p
;*************************************************************************>MOH<
(defun PKGetSS_SYMFromSS (
	&ss
  /
	#I #SS #RET$ #XD$
  )
	(setq #i 0 #RET$ nil)
	(repeat (sslength &ss)
		(if (setq #xd$ (CFGetXData (ssname &ss #i) "G_LSYM"))
			(if (and (>= (nth 9 #xd$) 110)(<= (nth 9 #xd$) 119))
				(setq #RET$ (cons (ssname &ss #i) #RET$))
			);_if
		);_if
		(setq #i (1+ #i))
	);_repeat
	#RET$
);PKGetSS_SYMFromSS

;;;<HOM>*************************************************************************
;;; <�֐���>    : CheckSS_FloorCAB
;;; <�����T�v>  : �I��ē����۱����(���i���ނ�"11?")�̂��̂𔲂��o��
;;; <�߂�l>    : �I���
;;; <�쐬>      : 01/01/17 YM
;;; <���l>      : CheckSKK$ ��������
;;;*************************************************************************>MOH<
(defun CheckSS_FloorCAB (
	&SS
	/
	#I #SS #XD$
	)
	(setq #ss (ssadd))
	(if (and &SS (> (sslength &SS) 0))
		(progn
			(setq #i 0)
			(repeat (sslength &SS)
;;;				(princ "\n #i = ")(princ #i)
				(if (setq #xd$ (CFGetXData (ssname &ss #i) "G_LSYM"))
					(if (and (>= (nth 9 #xd$) 110)(<= (nth 9 #xd$) 119))
						(ssadd (ssname &ss #i) #ss)
					);_if
				);_if
				(setq #i (1+ #i))
			)
		)
		(setq #ss nil)
	);_if
	#ss
);CheckSS_FloorCAB

;;;<HOM>*************************************************************************
;;; <�֐���>    : CheckSKK$
;;; <�����T�v>  : ����� &SYM �̐��i���ނ� &SKK$ �ƍ����Ă�Ȃ�T
;;;             : �����Ă��Ȃ��Ȃ�nil��Ԃ�
;;; <�߂�l>    : T or nil
;;; <�쐬>      : 01/01/17 YM
;;; <���l>      : ���i����ؽ� &SKK$ '("2" "1" "0") '("1" "1" "?") �Ȃǂ��w��
;;;*************************************************************************>MOH<
(defun CheckSKK$ (
	&SYM
	&SKK$
	/
	#ONE #RET #SKKONE #SKKTHR #SKKTWO #THR #TWO #XD$
	)
	(setq #RET nil)
	(if (CFGetXData &sym "G_LSYM")
		(progn
			(setq #RET T)
			(setq #one (itoa (CfGetSymSKKCode &SYM 1))) ; 'STR
			(setq #two (itoa (CfGetSymSKKCode &SYM 2))) ; 'STR
			(setq #thr (itoa (CfGetSymSKKCode &SYM 3))) ; 'STR
			(setq #SKKone (nth 0 &SKK$)) ; 'STR
			(setq #SKKtwo (nth 1 &SKK$)) ; 'STR
			(setq #SKKthr (nth 2 &SKK$)) ; 'STR

			(if (or (= #one #SKKone)(= #SKKone "?"))
				(princ)
				(setq #RET nil)
			);_if
			(if (or (= #two #SKKtwo)(= #SKKtwo "?"))
				(princ)
				(setq #RET nil)
			);_if
			(if (or (= #thr #SKKthr)(= #SKKthr "?"))
				(princ)
				(setq #RET nil)
			);_if
		)
	);_if
	#ret
);CheckSKK$

;;;<HOM>*************************************************************************
;;; <�֐���>    : CheckFloorCAB
;;; <�����T�v>  : &sym ���۱����(���i���ނ�"11?")���ǂ�������
;;; <�߂�l>    : T or nil
;;; <�쐬>      : 01/01/17 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun CheckFloorCAB (
	&sym
	/
	#RET #XD$
	)
	(setq #ret nil)
	(if (setq #xd$ (CFGetXData &sym "G_LSYM")) ; ����ق�
		(if (and (>= (nth 9 #xd$) 110)(<= (nth 9 #xd$) 119)) ; "11?"��
			(setq #ret T)
		);_if
	);_if
	#ret
);CheckFloorCAB

;<HOM>*************************************************************************
; <�֐���>    : PcCabCutCall3
; <�����T�v>  : �I����������ȯĕ��ނ�L�k����R�}���h
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/01/26 YM
; <���l>      : ���ނ��Ώ�
;               W,D,H������ڰ�ײ݂���̏ꍇ�ꎞ�I�ɏ���
;*************************************************************************>MOH<
(defun PcCabCutCall3 (
	&sym
  &distW
  &distD
  &distH
  &BrkW
  &BrkD
  &BrkH
  /
	#EDELBRK_D$ #EDELBRK_H$ #EDELBRK_W$ #GNAM #PT #XD_SYM$ #XLINE #XLINE_D #XLINE_H #XLINE_W
	#ANG
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PcCabCutCall3 ////")
  (CFOutStateLog 1 1 " ")

;;;  (command "._shademode" "3D") ; �B������ ����(��߰�ޱ���)07/07 YM ADD
  (setq #eDelBRK_W$ (PcRemoveBreakLine &sym "W")) ; W�����u���[�N����
  (setq #eDelBRK_D$ (PcRemoveBreakLine &sym "D")) ; D�����u���[�N����
  (setq #eDelBRK_H$ (PcRemoveBreakLine &sym "H")) ; H�����u���[�N����
	(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
	(setq #pt  (cdr (assoc 10 (entget &sym)))) ; ����ي�_
	(setq #ANG (nth 2 (CFGetXData &sym "G_LSYM")))
	(setq	#gnam (SKGetGroupName &sym))

	;;; �L�k����_W
	(if (> (abs &distW) 0.1)
		(progn
			(setq CG_TOKU_W &distW)
			;;; ��ڰ�ײ݂̍�}
			(setq #XLINE_W (PK_MakeBreakW #pt #ANG &BrkW))
			(CFSetXData #XLINE_W "G_BRK" (list 1))
			;;; ��ڰ�ײ̸݂�ٰ�߉�
			(command "-group" "A" #gnam #XLINE_W "")
			(SKY_Stretch_Parts &sym (- (nth 3 #xd_SYM$) &distW)(nth 4 #xd_SYM$)(nth 5 #xd_SYM$))
			(entdel #XLINE_W)
		)
	);_if
	;;; �L�k����_D
	(if (> (abs &distD) 0.1)
		(progn
			(setq CG_TOKU_D &distD)
			;;; ��ڰ�ײ݂̍�}
			(setq #XLINE_D (PK_MakeBreakD #pt #ANG &BrkD))
			(CFSetXData #XLINE_D "G_BRK" (list 2))
			;;; ��ڰ�ײ̸݂�ٰ�߉�
			(command "-group" "A" #gnam #XLINE_D "")
			(SKY_Stretch_Parts &sym (nth 3 #xd_SYM$)(- (nth 4 #xd_SYM$) &distD)(nth 5 #xd_SYM$))
			(entdel #XLINE_D)
		)
	);_if
	;;; �L�k����_H
	(if (> (abs &distH) 0.1)
		(progn
			(setq CG_TOKU_H &distH)
			;;; ��ڰ�ײ݂̍�}
			(setq #XLINE_H (PK_MakeBreakH #pt &BrkH))
			(CFSetXData #XLINE_H "G_BRK" (list 3))
			;;; ��ڰ�ײ̸݂�ٰ�߉�
			(command "-group" "A" #gnam #XLINE_H "")
			(SKY_Stretch_Parts &sym (nth 3 #xd_SYM$)(nth 4 #xd_SYM$)(- (nth 5 #xd_SYM$) &distH))
			(entdel #XLINE_H)
		)
	);_if
  (foreach #eD #eDelBRK_W$ (entdel #eD)) ; W�����u���[�N����
  (foreach #eD #eDelBRK_D$ (entdel #eD)) ; D�����u���[�N����
  (foreach #eD #eDelBRK_H$ (entdel #eD)) ; H�����u���[�N����
;;;  (command "._shademode" "H") ; �B������ ����(��߰�ޱ���)07/07 YM ADD
  (princ)
);PcCabCutCall3

;<HOM>*************************************************************************
; <�֐���>    : PcCabCutCall2
; <�����T�v>  : �I����������ȯĕ��ނ̹�Е�����50mm�J�b�g����R�}���h(�Ăяo���p)
; <����>      : ����ِ}�`
; <�߂�l>    :�Ȃ�
; <�쐬>      : 2000/11�� YM
; <���l>      : �۱���ނ��Ώۂ�H������ڰ�ײ݂Ȃ���z��
;               H������ڰ�ײ݂���̏ꍇ�ꎞ�I�ɏ���(00/12/22 ADD MH)
;
;;;���d�l�ڍׁ@SG/SN�P�R�~UP��
;;;���P�R�~UP�̏ꍇ�Ɍ��艺��͋K�i�i�̂܂܂ŕt��ւ��Ђ����悤�ɂ���
;;;�@(�}�`�I�ȐL�k�����͏]���ʂ�s��)
;;;03/06/12 �d�l�ύX����SPLAN�Ɍ�����ۂɑ�ւ�z�u����Z�ړ�����
;;;         ���50mmUP�ȊO�̂Ƃ��͑�֎��̂̐L�k������
;;;���t��ւ͑S��\8,000
;;;���t��ւ́u�ǉ����ށv�ɂ��o�^
;;;�����䂪�S�Ȃ�t��ւ��S�Ђ����遨�Ђ������Ɏ��ۂɔz�u
;;;������̕i�Ԃ�"�`045�`"�Ȃ�t��ւ̕i�Ԃ�"�`045�`"�ƂȂ� OK
;;;��+50mmUP�̏ꍇ�̂ݕt��ւ͋K�i�i�����ŁA����ȊO(+30mm�Ȃ�)�̃P�R�~UP
;;;�@�̂Ƃ��͕t��ւ�"�g�N)"�t���̓����i�ƂȂ�BOK
;;;���t���(���݃R�[�h�Ȃ�)��SET�i���ς�̑ΏۂɂȂ�OK
;;;�������t��ւ�SET�i���ς�̑ΏۂɂȂ�BOK
;;;��S-PLAN�̂Ƃ��Ɍ���A�t��ւƃL���r�Ƃ̋��E����\�����遨�\�����Ȃ�(���������)
;;;�@��GSM�ło�ʂX(�t��֋��E��)��ǉ����ASPLAN����݂̂ɒǉ��B
;;;�@�@�p�[�X�}�A�W�J�}�ło�ʂX�}�`���y�ړ����ĉ���w�ɕύX���遨���Ȃ�
;;;�@�@�p�[�X�}"0_PURS"�ł́A�o�ʐ}�`�͖�������"0_HIDE"��w�ɕύX����
;;;�@�@�����Ȃ��悤�ɂ��Ă������A�V�K�o�ʂX�͗�O�I��"0_PURS"�̂܂܂Ƃ���
;;; 2003/06/12 YM PMEN9��SPLAN�ɂ̂ݾ�Ă���.SPLAN���ǂ����̋�ʂɎg������
;;;�����DOWN�̏ꍇ�͏]���ʂ�(\8,000��׽)�Ƃ���
;;;���L�b�`���J�t�F�̑Ζ�(118)��_�C�j���O(117)��
;;;�@�]���ʂ�g�N�t��(\8,000��׽)�Ƃ���
;*************************************************************************>MOH<
(defun PcCabCutCall2 (
  &sym  ; ����ȯļ���ِ}�`
	&dist ; �L�k����(��:�k�� ��:�L�΂�)
	&Brk  ; ��ڰ�ײݍ���
  /
  #PT #SS #SYM #XD_LSYM$ #XD_SYM$ #XLINE #GNAM #eD #eDelBRK$
	#HINBAN #LR #PRICE #QRY$ #KEKOMI_PLUS #ORG_PRICE
	#DAIWA #DAIWAREC$ #DAIWAREC$$ #DOORHANDLE #DRINFO #DRINFO$ #DUM #DUM$ #I
	#KEKOMI_HINBAN #KOSU #LIS$ #MAGNUM #OPT_OLD$ #SET$ #XD$_OPT
	#DAIWAHINBAN #EG$ #EN #LOOP #PMEN9 #SYURUI #XD$ #skk #CNR #SPLAN #OS #SSGRP
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PcCabCutCall2 ////")
  (CFOutStateLog 1 1 " ")

  (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))

	; ���擾
	(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
	(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
	; 03/06/10 YM ADD
	(setq #skk (nth 9 #xd_LSYM$)) ; ���i����

	(setq #HINBAN (nth 5 #xd_LSYM$))
	(setq #LR     (nth 6 #xd_LSYM$))
	; 03/06/04 YM ADD-S
	(setq #DrInfo (nth 7 #xd_LSYM$))
	(setq #DrInfo$ (strparse #DrInfo ","))
	(setq #DoorHandle (nth 2 #DrInfo$))
	; 03/06/04 YM ADD-E
	
	; 03/09/09 YM ADD-S
	(if (= nil #DoorHandle)(setq #DoorHandle ""))
	; 03/09/09 YM ADD-E

 	; �۱���ނŐH��łȂ��ꍇ���z�ȂǓ������� 01/02/27 YM ADD ; 01/08/31 YM MOD ��۰��ى�
	(if (and (CheckSKK$ &sym (list (itoa CG_SKK_ONE_CAB) (itoa CG_SKK_TWO_BAS) "?")) ; 01/08/31 YM MOD ��۰��ى�
					 (not (CheckSKK$ &sym (list (itoa CG_SKK_ONE_CAB) (itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_ETC)))))
		(progn
;;;01/05/30YM@			; �ݸ�����ۈȊO�̂Ƃ��A���މ��i������
;;;01/05/30YM@		  (setq #Qry$
;;;01/05/30YM@		    (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
;;;01/05/30YM@		      (list
;;;01/05/30YM@		        (list "�i�Ԗ���"     #HINBAN       'STR)
;;;01/05/30YM@		        (list "LR�敪"       #LR           'STR)
;;;01/05/30YM@		        (list "�c��L��"     CG_DoorGrip   'STR)
;;;01/05/30YM@		        (list "���V���L��"   CG_DRSeriCode 'STR)
;;;01/05/30YM@		      )
;;;01/05/30YM@		    )
;;;01/05/30YM@		  )
;;;01/05/30YM@			(if (and #Qry$ (= (length #Qry$) 1))
;;;01/05/30YM@				(setq #ORG_price (nth 8 (car #Qry$)))
;;;01/05/30YM@				(progn
;;;01/05/30YM@					(CFAlertErr (strcat "�L���r�l�b�g�̉��i�����܂�܂���B\n�y�i�ԃV���z��" #HINBAN "�̃��R�[�h������܂���B"))
;;;01/05/30YM@					(setq #ORG_price 0) ; ں��ނȂ�or����
;;;01/05/30YM@				)
;;;01/05/30YM@			);_if

			(setq #KEKOMI_Plus (CFgetini "KEKOMI" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
;;;01/05/30YM@			(if #KEKOMI_Plus
;;;01/05/30YM@				(if (> #ORG_price 0)
;;;01/05/30YM@					(setq #price (+ #ORG_price (atoi #KEKOMI_Plus)))
;;;01/05/30YM@					(setq #price 0)
;;;01/05/30YM@				);_if
;;;01/05/30YM@				(setq #price 0)
;;;01/05/30YM@			);_if


			; 03/06/04 YM ADD
 			(if (equal (KPGetSinaType) 3 0.1)
				(progn ; SX �ذ�ނ͹��UP,DOWN�Ƃ�+8000���Ȃ�

					;/// �L�k����(���UP��SPLAN�̂Ƃ��͐L�k���Ȃ�) ////
					(KP_KekomiStretch &sym &Brk #xd_SYM$ &dist)

					; ��Ћ��z
		  		(setq #price 0.0)
					; ��АL�k�i��
					(if (equal KEKOMI_COM -50 0.01)
						(progn ;+50UP�Ɍ���
							(if (= #LR "Z") ; 01/06/27 YM ADD LR�ǉ�
								(setq #kekomi_hinban (strcat "ĸ�" #HINBAN     " " #DoorHandle " H900ֳ"))
								(setq #kekomi_hinban (strcat "ĸ�" #HINBAN #LR " " #DoorHandle " H900ֳ"))
							);_if
						)
						(progn ; �]���ʂ�
							(if (= #LR "Z") ; 01/06/27 YM ADD LR�ǉ�
								(setq #kekomi_hinban (strcat "ĸ" #HINBAN))     ; �i��
								(setq #kekomi_hinban (strcat "ĸ" #HINBAN #LR)) ; �i��
							);_if
						)
					);_if

					; ��АL�k��̕i�Ԃ���()�����
					(setq #kekomi_hinban (KP_DelHinbanKakko #kekomi_hinban)) ; 03/06/18 YM ADD

					; G_TOKU �̾��
				  (CFSetXData &sym "G_TOKU"
				    (list
							#kekomi_hinban
				      #price     ; SX�ȊO��+8000�~���i
							(list (nth 3 #xd_SYM$)(nth 4 #xd_SYM$)(- (nth 5 #xd_SYM$) &dist))
							0 ; 1:�������޺���� 0:��АL�k 2:�����į��
				      KEKOMI_BRK ; ��ڰ�ײ݈ʒu
				      KEKOMI_COM ; �L�k��
							#HINBAN    ; ���̕i��
				    )
				  )

				)
;---------------------------------------------------------------------------------
				(progn ; ���̑��ذ��(SG/SN)

					(if (and (> 0.0 KEKOMI_COM) ; ���Ȃ繺�UP
									 (not (equal #skk CG_SKK_INT_DNG 0.1)) ; �޲�ݸ�117�łȂ�
									 (not (equal #skk CG_SKK_INT_OTR 0.1)));�Ζ�118�łȂ�

						(progn ;���UP  SPLAN�ˋK�i�iZ�ړ�+¹�޲ܔz�u  ����ȊO�ːL�k,G_OPT���

							; SPLAN ����(PMEN 9������)
							(setq #pmen9 (Pmen9Hantei &sym)) ; P��9
							(if #pmen9
								(setq #SPLAN "1") ; SPLAN
								(setq #SPLAN "0") ; ����ȊO
							);_if

							(if #pmen9
								nil ; �L�k���Ȃ�
								;else
								(progn ; SPLAN�ł͂Ȃ��Ȃ�L�k
									;/// �L�k����(���UP��SPLAN�̂Ƃ��͐L�k���Ȃ�) ////
									(KP_KekomiStretch &sym &Brk #xd_SYM$ &dist)
								)
							);_if

							(if (equal CG_SKK_INT_CNR #skk 0.1)
								(setq #cnr "1") ; ��Ű���ނ�����
								(setq #cnr "0")
							);_if

							; #HINBAN ����Ԍ�����(���l)�̕�������擾����
							(setq #magnum (CFGetNumFromStr #HINBAN))

							(if (equal KEKOMI_COM -50 0.01);+50UP�Ɍ���t��ւ͋K�i�i
								(setq #daiwa "0") ; �K�i�i
								(setq #daiwa "1") ; �����i
							);_if

							; �Ђ�����(SPLAN�͔z�u����)�t��֕i�Ԃ��擾����
							(setq #daiwaHINBAN (KP_GetDaiwaHinban #magnum #daiwa #SPLAN #cnr #HINBAN))

							(if #pmen9
								(progn ; SPLAN Z�ړ�+�޲ܔz�u(�K�v�Ȃ�L�k)
									;��ւ̔z�u,�L�k
									(if #daiwaHINBAN (KPPutDaiwa #daiwaHINBAN "Z" &sym #daiwa)) ; #daiwa:����="1"

									; &sym Z�ړ�
									(setq #ssGRP (CFGetSameGroupSS &sym)); ����O���[�v���̑S�}�`�I���Z�b�g
								  (if (and (CFGetXRecord "BASESYM") ; ����т����� ����
								    			 (ssmemb (handent (car (CFGetXRecord "BASESYM"))) #ssGRP)) ; ����т� #ssGRP �ɓ����Ă���
								    (progn
								      (setq #ss (ssget "X" '((-3 ("G_ARW"))))) ; �����ړ�����
								      (CMN_ssaddss #ss #ssGRP)
								    )
								  );_if

								  (setq #os (getvar "OSMODE"))
								  (setvar "OSMODE" 0)
								  (command "._MOVE" #ssGRP "" "0,0,0" (strcat "@0,0," (rtos (abs KEKOMI_COM))))
								  (setvar "OSMODE" #os)

									;03/06/13 YM ADD-S "G_TOKU"�����Ȃ����UP�̕��ނɂ���
									(if (= (tblsearch "APPID" "G_KUP") nil) (regapp "G_KUP"))
		  						(CFSetXData &sym "G_KUP" (list 1)) ; SLPAN�� 1
									;03/06/13 YM ADD-E

								)
								(progn
									;�Ђ���(SLPAN�ȊO)
									(KP_SetDaiwaG_OPT &sym #daiwaHINBAN)
									;03/06/13 YM ADD-S "G_TOKU"�����Ȃ����UP�̕��ނɂ���
									(if (= (tblsearch "APPID" "G_KUP") nil) (regapp "G_KUP"))
		  						(CFSetXData &sym "G_KUP" (list 0)) ; SLPAN�ȊO�� 0
									;03/06/13 YM ADD-E
								)
							);_if

; 03/06/12 YM �d�l�ύX ���E���̕\���͂��Ȃ�(���������)
;;;							; SPLAN (PMEN 9�����݂���)��������t��֋��E����\������
;;;							(if #pmen9
;;;								(progn
;;;									; ����w���߰��}�ɕ\���ł����w(SG_PCLAYER)�֕ύX����
;;;									(setq #eg$ (entget #pmen9))
;;;									(entmod (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)); SG_PCLAYER="Z_00_00_00_01"
;;;									(command "chprop" #pmen9 "" "C" "WHITE" "")
;;;									; �L�k�ʂɉ����Ĉړ�����
;;;									(command "_move" #pmen9 "" '(0 0 0) (strcat "@0,0," (rtos (abs KEKOMI_COM))))
;;;								)
;;;							);_if

						)
						;else
						(progn ; DOWN �]���ʂ�
							;/// �L�k����(���UP��SPLAN�̂Ƃ��͐L�k���Ȃ�) ////
							(KP_KekomiStretch &sym &Brk #xd_SYM$ &dist)

							(setq #price (atof #KEKOMI_Plus)) ; 01/05/30 YM ADD ���i�͏�悹���z������
							(if (= #LR "Z") ; 01/06/27 YM ADD LR�ǉ�
								(setq #kekomi_hinban (strcat "ĸ" #HINBAN))     ; �i��
								(setq #kekomi_hinban (strcat "ĸ" #HINBAN #LR)) ; �i��
							);_if

							; ��АL�k��̕i�Ԃ���()�����
							(setq #kekomi_hinban (KP_DelHinbanKakko #kekomi_hinban)) ; 03/06/18 YM ADD

							; G_TOKU �̾��
						  (CFSetXData &sym "G_TOKU"
						    (list
									#kekomi_hinban
						      #price     ; SX�ȊO��+8000�~���i
									(list (nth 3 #xd_SYM$)(nth 4 #xd_SYM$)(- (nth 5 #xd_SYM$) &dist))
									0 ; 1:�������޺���� 0:��АL�k 2:�����į��
						      KEKOMI_BRK ; ��ڰ�ײ݈ʒu
						      KEKOMI_COM ; �L�k��
									#HINBAN    ; ���̕i��
						    )
						  )

						)
					);_if

				)
			);_if

		)
		;else ���,�����ȂǐL�k(Z�ړ�)����(G_TOKU�͂��Ȃ�)
		(progn
			;/// �L�k����(���UP��SPLAN�̂Ƃ��͐L�k���Ȃ�) ////
			(KP_KekomiStretch &sym &Brk #xd_SYM$ &dist)
		)
	);_if

  (princ)
);PcCabCutCall2

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPPutDaiwa
;;; <�����T�v>  : ���ނ�z�u����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/06/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KPPutDaiwa (
	&DaiwaHinban ; ��֕i�Ԗ���
	&LR          ; ���LR ("Z")
	&sym         ; �ް����޼���ِ}�`
	&daiwa       ; ����:"1" �K�i:"0"
	/
	#ANG #FIG$ #FIG$$ #FIGBASE$ #FIGBASE$$ #HH #ID #PT #SKK
	#D #DAIWAREC$ #DAIWAREC$$ #H #KIKAKU_DAIWA #SYM #TOKU_DAIWA #W #XD_SYM$
#LR #ORG_PRICE #RET$
	)
	; ������ւ̏ꍇ�K�i�i�i�Ԃ��擾
	(if (= "1" &daiwa)
		(progn ; ����
		  (setq #daiwaREC$$
		    (CFGetDBSQLRec CG_DBSESSION "�t���"
		      (list
						(list "�i�Ԗ���"  &DaiwaHinban  'STR)
		      )
		    )
		  )
			(if (and #daiwaREC$$ (= 1 (length #daiwaREC$$)))
				(progn
					(setq #daiwaREC$ (car #daiwaREC$$))
					(setq #Kikaku_daiwa (nth 6 #daiwaREC$)) ; �K�i�i�i��
					(setq #Toku_daiwa   &DaiwaHinban)       ; �����i�i��
				)
				(progn
					(CFAlertMsg (strcat "�t��ւ�ں��ނ��Ȃ����܂��͕������݂��܂�"
															"\n" &DaiwaHinban))
					(setq #Kikaku_daiwa nil) ; �K�i�i�i��
					(setq #Toku_daiwa   nil) ; �����i�i��
				)
			);_if
		)
		(progn
			(setq #Kikaku_daiwa &DaiwaHinban) ; �K�i�i�i��
			(setq #Toku_daiwa   nil)          ; �����i�i��
		)
	);_if

	;���擾
	; �ް����ޑ}���_,�p�x
	(if &sym
		(progn
			(setq #pt (cdr (assoc 10 (entget &sym))))
			(setq #ang (nth 2 (CFGetXData &sym "G_LSYM"))) ; ��]�p�x
		)
		;else
		(setq #pt nil #ang nil)
	);_if

	;�i�Ԋ�{ -----------------------------------------------
  (setq #figBase$$
    (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
       (list
         (list "�i�Ԗ���" #Kikaku_daiwa 'STR)
       )
    )
  )
	(if (and #figBase$$ (= 1 (length #figBase$$)))
		(progn ; �i�Ԋ�{OK
			(setq #figBase$ (car #figBase$$))
			(setq #skk (fix (nth 3 #figBase$))) ; ���i����
		)
		(progn
			(CFAlertMsg (strcat "�i�Ԋ�{��ں��ނ��Ȃ����܂��͕������݂��܂�"
													"\n" #Kikaku_daiwa))
			(setq #skk nil)
		)
	);_if

	;�i�Ԑ}�` -----------------------------------------------
  (setq #fig$$
    (CFGetDBSQLHinbanTable "�i�Ԑ}�`"
       #Kikaku_daiwa ;�i�Ԗ���
       (list
         (list "�i�Ԗ���"  #Kikaku_daiwa 'STR)
         (list "LR�敪"    &LR     'STR)
         (list "�p�r�ԍ�"  "0"     'INT)
       )
    )
  )
	(if (and #fig$$ (= 1 (length #fig$$)))
		(progn ; �i�Ԋ�{OK
			(setq #fig$ (car #fig$$))
			(setq #hh (fix (nth 5 #fig$))) ; ���@H   ;2008/06/28 YM OK!
			(setq #id (nth 6 #fig$))       ; �}�`ID  ;2008/06/28 YM OK!
		)
		(progn
			(CFAlertMsg (strcat "�i�Ԑ}�`��ں��ނ��Ȃ����܂��͕������݂��܂�"
													"\n" #Kikaku_daiwa))
			(setq #hh nil)
			(setq #id nil)
		)
	);_if

	; #daiwaHINBAN �z�u
;;;	&id     ; �}�`ID  STR "???????"  ".dwg"�ȊO�̕���
;;;	&pt     ; �}���_�@LIST
;;;	&ang    ; �p�x    REAL
;;;	&hinban ; �i�Ԗ���
;;;	&LR     ; LR�敪
;;;	&skk    ; [�i�Ԋ�{].���i����
;;; &hh     ; [�i�Ԑ}�`].���@�g
	(if (and #id #pt #ang #Kikaku_daiwa &LR #skk #hh)
		(setq #sym (KP_BuzaiHaiti #id #pt #ang #Kikaku_daiwa &LR #skk #hh))
	);_if

	; #daiwaHINBAN �L�k
	(if (= "1" &daiwa)
		(progn ; ����
			(setq #xd_SYM$ (CFGetXData #sym "G_SYM"))
			(setq #W (nth 3 #xd_SYM$))
			(setq #D (nth 4 #xd_SYM$))
			(setq #H (nth 5 #xd_SYM$))
			;;; ��ւ���ڰ�ײ݂����邱�Ƃ�O��ɐL�k
			(SKY_Stretch_Parts #sym #W #D (abs KEKOMI_COM))
			; ��������
		  (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))

			; �K�i�i���i
			(setq #ret$ (KPGetPrice #Kikaku_daiwa #LR))
			(setq #ORG_price (nth 0 #ret$))

		  (CFSetXData #sym "G_TOKU"
		    (list
					#Toku_daiwa          ; �����i��
		      (atof #ORG_price)    ; ���i ����
		      (list 0 0 0)
					1  ; 1:�������޺���� 0:��АL�k
					1  ; W ��ڰ�ײ݈ʒu
					1  ; D ��ڰ�ײ݈ʒu
					50 ; H ��ڰ�ײ݈ʒu
					#Kikaku_daiwa ; �i��
		    )
		  )
		)
	);_if

	(princ)
);KPPutDaiwa

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_SetDaiwaG_OPT
;;; <�����T�v>  : �t��֕i�Ԃ�G_OPT�ɾ�Ă���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/06/12 YM
;;; <���l>      : ���UP��SPLAN�łȂ��ꍇ(�A�����i����117,118������)
;;;*************************************************************************>MOH<
(defun KP_SetDaiwaG_OPT (
	&sym         ; �e����
	&daiwaHINBAN ; �t��֕i��
  /
	#DUM #DUM$ #I #LIS$ #OPT_OLD$ #SET$ #SYURUI #XD$_OPT
#DAIWAREC$$ ; 03/06/13 YM ADD
  )
	(if (= (tblsearch "APPID" "G_OPT") nil) (regapp "G_OPT"))
	(setq #xd$_OPT  (CFGetXData &sym "G_OPT"))

	(if &daiwaHINBAN
		(progn
			(if #xd$_OPT
				(progn ; ������߼�݂ɒǉ�����
					(setq #syurui (car #xd$_OPT)) ; OPTION ��ނ̐�
					(setq #lis$ (cdr #xd$_OPT)) ; �i��1,��1,�i��2,��2,...��ؽ�
					(setq #opt_old$ nil)        ; (�i��1,��1)(�i��2,��2),...
					(setq #i 0)
					(foreach #lis #lis$
						; �i��,��,�i��,��,...�̏���
						(if (= 0 (rem #i 2))
							(progn
								(setq #dum #lis) ; �i��
								;03/06/13 YM ADD-S �t���TB�ɑ��݂��邩
							  (setq #daiwaREC$$
							    (CFGetDBSQLRec CG_DBSESSION "�t���"
							      (list (list "�i�Ԗ���"  #dum  'STR))
							    )
							  )
								(if #daiwaREC$$
									(progn ; �������݂�����"G_OPT"����폜���邽�߁A#dum=nil�Ƃ���
										(setq #dum nil)
										(setq #syurui (1- #syurui)) ; ��߼�ݕi�̌���1���炷
									)
								);_if
							)
							;else
							(progn
								(if #dum ; �t��ւł͂Ȃ�
									(setq #opt_old$ (append #opt_old$ (list #dum #lis)))
								);_if
							)
						);_if
						(setq #i (1+ #i))
					);foreach

					(setq #Set$ (append (list (1+ #syurui)) #opt_old$ (list &daiwaHINBAN 1))) ; �����ɒǉ�

				)
				(progn ; �V�K���(1��)
					(setq #Set$ (list 1 &daiwaHINBAN 1))
				)
			);_if

			; G_OPT�ɾ�Ă���
		  (if #Set$ (CFSetXData &sym "G_OPT" #Set$))

		)
	);_if
	(princ)
);KP_SetDaiwaG_OPT

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_GetDaiwaHinban
;;; <�����T�v>  : �t��֕i�Ԃ��擾����
;;; <�߂�l>    : �t��֕i��
;;; <�쐬>      : 03/06/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_GetDaiwaHinban (
	&magnum &daiwa &SPLAN &cnr &HINBAN
  /
	#DAIWAHINBAN #DAIWAREC$ #DAIWAREC$$
  )
  (setq #daiwaREC$$
    (CFGetDBSQLRec CG_DBSESSION "�t���"
      (list
        (list "�Ԍ�"  &magnum 'INT)
        (list "����"  &daiwa  'INT)
				(list "SPLAN" &SPLAN  'INT)
				(list "���p"  &cnr  'INT)
      )
    )
  )
  (if #daiwaREC$$
		(progn
			(if (= 1 (length #daiwaREC$$))
				(progn
					(setq #daiwaREC$ (car #daiwaREC$$))
					(setq #daiwaHINBAN (nth 5 #daiwaREC$))
				)
				;else
				(progn ; ����HIT������հ�ް�ɑI��������
					(setq #daiwaHINBAN (GetDaiwa_Dlg #daiwaREC$$ &HINBAN)) ; ��֑I����,����i��
					(if (= nil #daiwaHINBAN)(quit))
				)
			);_if
		)
		(progn
			(CFAlertMsg "�t���ð��ق�ں��ނ�����܂���")
			(setq #daiwaHINBAN nil)
		)
	);_if
	#daiwaHINBAN
);KP_GetDaiwaHinban

;;;<HOM>*************************************************************************
;;; <�֐���>    : Pmen9Hantei
;;; <�����T�v>  : PMEN9�����݂��邩����(SPLAN���ǂ���)
;;; <�߂�l>    : T(����) or nil
;;; <�쐬>      : 03/06/12 YM
;;; <���l>      : SPLAN����PMEN9�����݂���
;;;*************************************************************************>MOH<
(defun Pmen9Hantei (
	&sym
  /
	#EN #I #LOOP #PMEN9 #SS #XD$
  )
	(setq #pmen9 nil) ; P��9
	(setq #ss (CFGetSameGroupSS &sym))
	(setq #i 0)
	(setq #loop T)
	(while (and #loop (< #i (sslength #ss)))
	  (setq #en (ssname #ss #i)) ; �ݸ���ނ̓����ٰ��
	  (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
	  (if #xd$
	    (progn
	      (if (= 9 (car #xd$))
	        (progn
	          (setq #pmen9 #en) ; P��9
	          (setq #loop nil)
	        )
	      );_if
	    )
	  );_if
	  (setq #i (1+ #i))
	)
	#pmen9
);Pmen9Hantei

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_KekomiStretch
;;; <�����T�v>  : ��АL�k�������܂Ƃ߂Ċ֐���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/06/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_KekomiStretch (
	&sym &Brk &xd_SYM$ &dist
  /
	#EDELBRK$ #GNAM #PT #XLINE
  )
;;;  (command "._shademode" "3D") ; �B������ ����(��߰�ޱ���)07/07 YM ADD
  (setq #eDelBRK$ (PcRemoveBreakLine &sym "H")) ; 00/12/22 ADD MH H�����u���[�N����
	;;; ��ڰ�ײ݂̍�}
	(setq #pt (cdr (assoc 10 (entget &sym)))) ; ����ي�_
	(setq #XLINE (PK_MakeBreakH #pt &Brk))

	(CFSetXData #XLINE "G_BRK" (list 3))
	(setq	#gnam (SKGetGroupName &sym))
	;;; ��ڰ�ײ̸݂�ٰ�߉�
	(command "-group" "A" #gnam #XLINE "")
	;;; �L�k
	(SKY_Stretch_Parts &sym (nth 3 &xd_SYM$)(nth 4 &xd_SYM$)(- (nth 5 &xd_SYM$) &dist))

	(entdel #XLINE)
  (foreach #eD #eDelBRK$ (entdel #eD)) ; 00/12/22 ADD MH H�����u���[�N����
	(princ)
);KP_KekomiStretch

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetDaiwa_Dlg
;;; <�����T�v>  : �t��ւ�I�������ʂ�\������
;;; <�߂�l>    : �t��֕i��
;;; <�쐬>      : 03/06/09 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun GetDaiwa_Dlg (
	&lis$   ; �t��֑I����
	&HINBAN ; ��ɔz�u���鉺��
  /
	#DCL_ID #MSG #POP$ #RET
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #ret
            )
            (setq #ret (nth (atoi (get_tile "daiwa")) #pop$)) ; �t��֕i��
						(done_dialog)
            #ret
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �߯�߱���ؽ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( /	#hin) ; �ް�����߯�߱���ؽ�
						(setq #pop$ '())
					  (start_list "daiwa" 3)
					  (foreach #lis &lis$
							(setq #hin (nth 5 #lis))
					    (add_list #hin)
							(setq #pop$ (append #pop$ (list #hin)))
					  )
					  (end_list)
						(set_tile "daiwa" "0") ; �ŏ���̫���
						(princ)
          );##Addpop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "Daiwa_Dlg" #dcl_id)) (exit))

	; ���b�Z�[�W��\��
	(setq #msg1 (strcat "�i�� �� " &HINBAN))
	(set_tile "text1" #msg1)
	(setq #msg2 "�Ɏ�t����t��ւ�I�����Ă�������")
	(set_tile "text2" #msg2)

	;;; �߯�߱���ؽ�
	(##Addpop)

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #ret (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret
);GetDaiwa_Dlg

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_MakeBreakH
;;; <�����T�v>  : H800�����p�Ɉꎞ�I��H������ڰ�ײ݂���}
;;; <�߂�l>    : XLINE �}�`��
;;; <�쐬>      : 00/11/21 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PK_MakeBreakH (
	&SYM_PT ; ����ي�_�ʒu���W
	&Brk    ; ��ڰ�ײݍ���
  /
	#pt
  )
	(setq #pt (list (car &SYM_PT) (cadr &SYM_PT) &Brk))
	(entmake
		(list
			(cons 0 "XLINE")
			(cons 100 "AcDbEntity")
			(cons 67 0)
			(cons 8 "N_BREAKH")
			(cons 100 "AcDbXline")
			(cons 10 #pt) ; �ʉߓ_
			(cons 11 (list 0.5 0.5 0.0)) ; ����
		)
	)
	(entlast)
);PK_MakeBreakH

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_MakeBreakW
;;; <�����T�v>  : �������޺���ޗp�Ɉꎞ�I��W������ڰ�ײ݂���}
;;; <�߂�l>    : XLINE �}�`��
;;; <�쐬>      : 01/01/26 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PK_MakeBreakW (
	&SYM_PT ; ����ي�_�ʒu���W
	&ANG    ; ����ٔz�u�p�x
	&Brk    ; ��ڰ�ײ݈ʒu
  /
	#pt
  )
	(setq #pt (polar &SYM_PT &ANG &Brk))
	(entmake
		(list
			(cons 0 "XLINE")
			(cons 100 "AcDbEntity")
			(cons 67 0)
			(cons 8 "N_BREAKH")
			(cons 100 "AcDbXline")
			(cons 10 #pt) ; �ʉߓ_
			(cons 11 (list 0 1 1)) ; ����
		)
	)
	(entlast)
);PK_MakeBreakW

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_MakeBreakD
;;; <�����T�v>  : �������޺���ޗp�Ɉꎞ�I��D������ڰ�ײ݂���}
;;; <�߂�l>    : XLINE �}�`��
;;; <�쐬>      : 01/01/26 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PK_MakeBreakD (
	&SYM_PT ; ����ي�_�ʒu���W
	&ANG    ; ����ٔz�u�p�x
	&Brk    ; ��ڰ�ײ݈ʒu
  /
	#pt
  )
	(setq #pt (polar &SYM_PT (- &ANG (dtr 90)) &Brk))
	(entmake
		(list
			(cons 0 "XLINE")
			(cons 100 "AcDbEntity")
			(cons 67 0)
			(cons 8 "N_BREAKH")
			(cons 100 "AcDbXline")
			(cons 10 #pt) ; �ʉߓ_
			(cons 11 (list 1 0 -1)) ; ����
		)
	)
	(entlast)
);PK_MakeBreakD

;;;<HOM>***********************************************************************
;;; <�֐���>    : PcRemoveBreakLine
;;; <�����T�v>  : �O���[�v����u���[�N���C���������A�����p�ɐ}�`�����X�g��o
;;; <�߂�l>    : ���������}�`�����X�g
;;; <�쐬>      : 00-12-22 MH
;;; <���l>      :
;;;***********************************************************************>MOH<
(defun PcRemoveBreakLine (
  &eEN          ; �}�`��
  &sFLG         ; �폜������u���[�N���C���̎�� "H" "W" "D"
  /
  #G$ #GRP$ #Temp$ #BrkW$ #BrkD$ #BrkH$ #eD #eDEL$
  )
  (if (= 'ENAME (type &eEN)) ; G_SYM�ł�������폜 01/02/09 YM
		(progn
	    (setq #GRP$ (entget (cdr (assoc 330 (entget &eEN)))))
	    (foreach #G$ #GRP$
	      ;; �O���[�v�\���}�`���u���[�N���C�����ǂ����̃`�F�b�N
	      (if (and (= (car #G$) 340)
	               (= (cdr (assoc 0 (entget (cdr #G$)))) "XLINE")
	               (setq #Temp$ (CFGetXData (cdr #G$) "G_BRK"))
	          ); and
	          ;; H,W,D �e�u���[�N���C���̎�ޖ��ɐ}�`�����i�[����
	        (cond
	          ;; W �����u���[�N���C��������
	          ((= (nth 0 #Temp$) 1) (setq #BrkW$ (cons (cdr #G$) #BrkW$)))
	          ;; D �����u���[�N���C��������
	          ((= (nth 0 #Temp$) 2) (setq #BrkD$ (cons (cdr #G$) #BrkD$)))
	          ;; H �����u���[�N���C��������
	          ((= (nth 0 #Temp$) 3) (setq #BrkH$ (cons (cdr #G$) #BrkH$)))
	        ); cond
	      ); if
	    ); foreach
	    (cond
	      ((= "W" &sFLG) (setq #eDEL$ #BrkW$))
	      ((= "D" &sFLG) (setq #eDEL$ #BrkD$))
	      ((= "H" &sFLG) (setq #eDEL$ #BrkH$))
	    ); cond
	    ; �擾���ꂽ�u���[�N���C���폜
	    (foreach #eD #eDEL$ (entdel #eD))
  	)
	); if progn
  #eDEL$
); PcRemoveBreakLine

;;;<HOM>***********************************************************************
;;; <�֐���>    : ChgDrCALL
;;; <�����T�v>  : ���ʂ̕ύX(Genic==>Notil�ذ�ޕϊ����Ɏg�p����)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/04/03 YM
;;; <���l>      :
;;;***********************************************************************>MOH<
(defun ChgDrCALL (
	&seri$
  /
	#EN$ #I #RET$ #SS #SYMNORMAL$ #SYMTOKU$ #TOKU #TOKU$ #XREC$
  )
  ;// ���݂̏��i�����擾����
  (setq #XRec$ &seri$)

	; ���ʈꊇ�ύX
;;;      CG_DRSeriCode ; 4.��SERIES�L��
;;;      CG_DRColCode  ; 5.��COLOR�L��
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
	(if (and #ss (< 0 (sslength #ss)))
		(progn

		  (setq #i 0)
		  (repeat (sslength #ss)
		    (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode (ssname #ss #i) 1))
		      (setq #en$ (cons (ssname #ss #i) #en$))
		    )
		    (setq #i (1+ #i))
		  )
			; 01/03/12 YM ADD �������ނƈ�ʷ��ނ𕪂���
			(setq #symTOKU$ nil #symNORMAL$ nil #TOKU nil)
			(foreach en #en$
				(if (and (setq #TOKU$ (CFGetXData en "G_TOKU"))
								 (= (nth 3 #TOKU$) 1))
					(progn
						(setq #TOKU T) ; �������ނ�������
						(setq #symTOKU$ (append #symTOKU$ (list en))) ; �������޺���ނ��g�p
					)
					(setq #symNORMAL$ (append #symNORMAL$ (list en)))
				);_if
			)
			(if #TOKU ; 01/03/22 YM ADD
				(CFAlertErr "�����L���r�l�b�g�͔��ʂ̕ύX���s���܂���B")
			);_if

		  ;// ���ʂ̓\��t��(�����ȊO�̏ꍇ)
			(if #symNORMAL$
		  	(PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
			);_if

		  ;00/08/25 SN ADD ����т����݂���ꍇ�͊���т��ĕ\��
		  (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
		    (progn
		      (setq CG_BASESYM (CFGetBaseSymXRec))
		      (ResetBaseSym)
		      (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
		    ); progn
		  )
		  (princ "\n���ʂ�SERIES��ύX���܂����B")

		)
	);_if
	(princ)
);ChgDrCALL

;///////////////////////////////////////////////
(defun C:ccc ( / )
	(C:KPChangeSeries)
)

;;;<HOM>***********************************************************************
;;; <�֐���>    : KP_CheckGtoN
;;; <�����T�v>  : �ذ�ޕύX�ۂ�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/04/05 YM
;;; <���l>      : Genic<==>Notil�̂݉\
;;;               01/05/09 YM �C�� CAD��żذ�ޕύX���A
;;;               Xrecord��PlanInfo.cfg���X�V����
;;;***********************************************************************>MOH<
(defun KP_CheckGtoN (
  /
  #MSG1 #MSG2 #MSG3 #MSG4 #SERI$
	#FP #PLANINFO$ #QRY$ #RET$ #SFNAME #QLY$$
  )

	; ���݂̼ذ�ދL�����擾
	(setq #msg1 "SERIES�L�����擾�ł��܂���ł����B")
	(setq #msg2 "���݂�SERIES��ύX�ł��܂���B")
	(setq #msg3 "SERIES��Genic�ɕύX���܂����H")
	(setq #msg4 "SERIES��Notil�ɕύX���܂����H")

  (if (setq #seri$ (CFGetXRecord "SERI"))
		(progn
			; �ύX�O�̂���
      (setq CG_SeriesCode  (nth 1 #seri$)) ; 2.SERIES�L��

			(cond
				((= CG_SeriesCode "SG"); Genic==>Noitl
          (if (CFYesNoDialog #msg4)
						(progn
						 	(setq Ch_Seri "GN"); ��۰��ِݒ�
							(setq CG_SeriesCode "N") ; 2.SERIES�L��
						)
						(*error*)
          );_if
			 	)
				((= CG_SeriesCode "N") ; Noitl==>Genic
          (if (CFYesNoDialog #msg3)
						(progn
					 		(setq Ch_Seri "NG"); ��۰��ِݒ�
							(setq CG_SeriesCode "SG") ; 2.SERIES�L��
						)
						(*error*)
          );_if
			 	)
				(T
					(CFAlertErr #msg2)
					(princ #msg2)
					(*error*)
			 	)
			);_cond
		)
		(progn
			(CFAlertErr #msg1)
			(princ #msg1)
			(*error*)
		)
  );_if

  ;// ���ʃf�[�^�x�[�X�ւ̐ڑ�
  (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
	; 01/11/04 HN MOD SERIES�����L�[��ǉ�
  ;@MOD@(setq #qry$ (CFGetDBSQLRecChk CG_CDBSESSION "SERIES"
	;@MOD@	(list (list "SERIES�L��" CG_SeriesCode 'STR)))
	;@MOD@)
;;;01/11/27YM@MOD	(setq #qry$	(CFGetDBSQLRecChk CG_CDBSESSION "SERIES" (list (list "����" CG_DBNAME 'STR))))

	; ����HIT���� 02/03/21 YM MOD
  (setq #QLY$$
    (CFGetDBSQLRec CG_CDBSESSION "SERIES"
      (list (list "SERIES�L��" CG_SeriesCode 'STR))
  	)
	)

;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #QLY$$)
;;;		;�ذ�ޕ�DB,����DB�Đڑ�
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E

;;;  (setq #qry$ (CFGetDBSQLRecChk CG_CDBSESSION "SERIES"
;;;		(list (list "SERIES�L��" CG_SeriesCode 'STR)))
;;;	)

  (if (= nil #QLY$$)
		(progn
    	(CFAlertErr "SERIES�e�[�u����������܂���")
			(*error*)
		)
  );_if

	; �ذ�ޖ��̑I���޲�۸� �ذ��DB�X�V�Ή� SGA,SGB,SGC,... or SNA,SNB,SNC,...
	; ���Ƃ���Genic-->Notil�̏ꍇ MK_SNA,MK_SNB,MK_SNC�̂ǂ���Q�Ƃ��邩հ�ް�ɑI��������
	; 02/03/21 YM ADD-S
	(setq #ret$ (KP_ChSeriDlg #QLY$$))
	(setq CG_SeriesDB (nth 0 #ret$))
	(setq CG_DBNAME   (nth 1 #ret$))

	; 02/03/21 YM ADD-E

;;;	(setq CG_SeriesDB (nth 0 #qry$))
;;;	(setq CG_DBNAME   (nth 7 #qry$))

	; ���L��,�װ�̑I��
  (setq #ret$
    (SRSelectDoorSeriesDlg
      "���ʕύX"
      CG_DBNAME     ; �ύX��
      CG_SeriesCode
      nil ; �߯�߱���ؽĂ���̫�Ă͈�ԏ�
      nil ; �߯�߱���ؽĂ���̫�Ă͈�ԏ�
    )
  )
	; ��ݾّΉ� 01/07/23 YM ADD
	(if (= nil #ret$)
		(progn
			(princ"\n����ނ�ݾق��܂����B") ; ��ݾَ� 01/07/23 YM
			(*error*)
		)
	);_if

	; �ذ�ޕύX����L���װ
  (setq CG_DRSeriCode (car #ret$))  ;��SERIES�L��
  (setq CG_DRColCode  (cadr #ret$)) ;��COLOR�L��

	; Xrecord�X�V �ذ�ޕύX��̂���
  (setq #seri$
    (list
      CG_DBNAME       ; 1.DB����
      CG_SeriesCode   ; 2.SERIES�L��
      CG_BrandCode    ; 3.�u�����h�L��
      CG_DRSeriCode   ; 4.��SERIES�L��
      CG_DRColCode    ; 5.��COLOR�L��
      CG_UpCabHeight  ; 6.��t����
      CG_CeilHeight   ; 7.�V�䍂��
      CG_RoomW        ; 8.�Ԍ�
      CG_RoomD        ; 9.���s
      CG_GasType      ;10.�K�X��
      CG_ElecType     ;11.�d�C��
      CG_KikiColor    ;12.�@��F
      CG_KekomiCode   ;13.�P�R�~����
    )
  )
	(CFSetXRecord "SERI" #seri$)
	; PlanInfo.cfg���X�V
  ;// ���݂̃v�������(PLANINFO.CFG)��ǂݍ���
  (setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
	; ���ڂ̍X�V
	(setq #PLANINFO$ (subst (list "SeriesDB"       CG_SeriesDB)   (assoc "SeriesDB"       #PLANINFO$) #PLANINFO$))
	(setq #PLANINFO$ (subst (list "SeriesCode"     CG_SeriesCode) (assoc "SeriesCode"     #PLANINFO$) #PLANINFO$))
	(setq #PLANINFO$ (subst (list "DoorSeriesCode" CG_DRSeriCode) (assoc "DoorSeriesCode" #PLANINFO$) #PLANINFO$))
	(setq #PLANINFO$ (subst (list "DoorColorCode"  CG_DRColCode)  (assoc "DoorColorCode"  #PLANINFO$) #PLANINFO$))

  (setq #sFname (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
  (setq #fp  (open #sFname "w"))
  (if (/= nil #fp)
    (progn
      (foreach #elm #PLANINFO$
        (if (= ";" (substr (car #elm) 1 1))
          (princ (car #elm) #fp)
          ;else
          (progn
            (if (= (car #elm) "") ; if������ 03/07/22 YM ADD
              nil ; ��s(���������Ȃ�)
							;else
							(progn
								(if (= (cadr #elm) nil) ; if������ 2011/10/14 YM ADD
									(princ (car #elm) #fp)
									;else
            			(princ (strcat (car #elm) "=" (cadr #elm)) #fp)
								);_if
							)
            );_if
          )
        );_if
        (princ "\n" #fp)
      );foreach
	  	(close #fp)
		)
		(progn
			(CFAlertMsg "PLANINFO.CFG�ւ̏������݂Ɏ��s���܂����B")
			(*error*)
		)
	);_if
	#seri$
);KP_CheckGtoN

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_ChSeriDlg
;;; <�����T�v>  : �ذ�ޕύX���̃_�C�A���O
;;; <�߂�l>    : MK_SGA,MK_SGB...�Ȃǂ̎Q��DB��
;;; <�쐬>      : 02/03/21 YM
;;; <���l>      : �ذ�ޕύX���ذ�ޕ�DB�������゠�����Ƃ��̑Ή�
;;;*************************************************************************>MOH<
(defun KP_ChSeriDlg (
	&QLY$$ ; �ذ��TBں���
  /
	#DB #DCL_ID #DUM$$ #POP1$ #POP2$ #QRY$$ #ret$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KP_ChSeriDlg ////")
  (CFOutStateLog 1 1 " ")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #DB
            )
            (setq #SERI(nth (atoi (get_tile "seri")) #pop1$)) ; �ذ�ޖ���
            (setq #DB  (nth (atoi (get_tile "seri")) #pop2$)) ; ����(DB��)
            (done_dialog)
						(list #SERI #DB)
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �߯�߱���ؽ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( /	) ; �ذ��ؽ��ޯ��
						(setq #pop1$ '() #pop2$ '()) ; �ذ�ޖ���,����
					  (start_list "seri" 3)
					  (foreach #Qry$ #Qry$$
					    (add_list (strcat (nth 0 #Qry$) " : " (nth 6 #Qry$))) ; SGA : Genic �Ȃ�
							(setq #pop1$ (append #pop1$ (list (nth 0 #Qry$))))    ; �ذ�ޖ��̂�ۑ�
							(setq #pop2$ (append #pop2$ (list (nth 7 #Qry$))))    ; ���̂�ۑ�
					  )
					  (end_list)
						(set_tile "seri" "0")                                   ; �ŏ���̫���
						(princ)
          );##Addpop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; �p��F��1�łȂ�����
	(setq #dum$$ nil)
  (foreach #Qry$ &QLY$$
		(if (/= 1 (nth 10 #Qry$))
			(setq #dum$$ (append #dum$$ (list #Qry$)))
		);_if
  )
	(setq #Qry$$ #dum$$)

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "ChSeriDlg" #dcl_id)) (exit))

	;;; �߯�߱���ؽ�
	(##Addpop)

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret$
);KP_ChSeriDlg

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_ChSeriDlg2
;;; <�����T�v>  : �ذ�ޕύX���̃_�C�A���O
;;; <�߂�l>    : MK_SGA,MK_SGB...�Ȃǂ̎Q��DB��
;;; <�쐬>      : 02/03/21 YM
;;; <���l>      : �ذ�ޕύX���ذ�ޕ�DB�������゠�����Ƃ��̑Ή�
;;;               �ذ�ދL�����Ԃ�
;;;*************************************************************************>MOH<
(defun KP_ChSeriDlg2 (
	&QLY$$ ; �ذ��TBں���
  /
	#DB #DCL_ID #DUM$$ #POP1$ #POP2$ #QRY$$ #ret$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KP_ChSeriDlg2 ////")
  (CFOutStateLog 1 1 " ")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #DB
            )
            (setq #SERI (nth (atoi (get_tile "seri")) #pop1$)) ; �ذ�ޖ���
            (setq #DB   (nth (atoi (get_tile "seri")) #pop2$)) ; ����(DB��)
						(setq #KIGO (nth (atoi (get_tile "seri")) #pop3$)) ; �ذ�ދL��
            (done_dialog)
						(list #SERI #DB #KIGO)
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �߯�߱���ؽ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( /	) ; �ذ��ؽ��ޯ��
						(setq #pop1$ '() #pop2$ '() #pop3$ '()) ; �ذ�ޖ���,����,�ذ�ދL��
					  (start_list "seri" 3)
						(setq #n 0 #focus 0)
					  (foreach #Qry$ #Qry$$
					    (add_list (strcat (nth 4 #Qry$) " : " (nth 0 #Qry$) " : " (nth 6 #Qry$))) ; SG : SGA : Genic �Ȃ�
							(setq #pop1$ (append #pop1$ (list (nth 0 #Qry$))))    ; �ذ�ޖ��̂�ۑ�
							(setq #pop2$ (append #pop2$ (list (nth 7 #Qry$))))    ; ���̂�ۑ�
							(setq #pop3$ (append #pop3$ (list (nth 4 #Qry$))))    ; �ذ�ދL����ۑ�
							(if (= CG_SeriesCode (nth 4 #Qry$))
								(setq #focus #n)
							);_if
							(setq #n (1+ #n))
					  )
					  (end_list)
						(set_tile "seri" (itoa #focus))                                   ; �ŏ���̫���
						(princ)
          );##Addpop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; �p��F��1�łȂ�����
	(setq #dum$$ nil)
  (foreach #Qry$ &QLY$$
		(if (/= 1 (nth 10 #Qry$))
			(setq #dum$$ (append #dum$$ (list #Qry$)))
		);_if
  )
	(setq #Qry$$ #dum$$)

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "ChSeriDlg" #dcl_id)) (exit))

	;;; �߯�߱���ؽ�
	(##Addpop)

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret$
);KP_ChSeriDlg2

;;;<HOM>***********************************************************************
;;; <�֐���>    : C:KPChangeSeries
;;; <�����T�v>  : �}�ʏ�̷��ނ�Notil�i�Ԃɂ���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/04/03 YM
;;; <���l>      : Genic==>Notil�̂݉\
;;;***********************************************************************>MOH<
(defun C:KPChangeSeries (
  /
  #CG_DRCOLCODE #SERI$ #SERIESCODE #SS #I #SYM #WT
	#SSFILR #STR #ssTOKU #flgTOKU #TOKU$
	NG$ ; �i�Ԗ��ύXؽ�
#ssLSYM #CNT_EXIST #CODE$ #XD_LSYM$ ; 02/08/29 YM ADD
  )
	(setq Ch_Seri nil NG$ nil)
  (StartUndoErr);00/10/02 SN MOD UNDO�����֐��ύX

;;;          (setq #DBNAME (nth  0 #seri$)) ; 1.DB����
;;;          ;// SERIES�ʃf�[�^�x�[�X�ւ̐ڑ�
;;;          (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))

	(setq #ssTOKU (ssget "X" '((-3 ("G_TOKU")))))

	; 02/08/29 YM ADD-S ܰ�į�߉����Ă��Ȃ������������Όx���\������
	(setq #ssLSYM (ssget "X" '((-3 ("G_LSYM")))))
	(if (and #ssLSYM (< 0 (sslength #ssLSYM)))
		(progn
			(setq #i 0)
			(setq #CNT_exist nil) ; ����������݂���
			(repeat (sslength #ssLSYM)
				(setq #sym (ssname #ssLSYM #i))
    		(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
			 	(if #xd_LSYM$
					(progn ; LSYM����
						(setq #code$ (CFGetSymSKKCode #sym nil))    ; ���i����
  					(if (and (= CG_SKK_ONE_CNT (nth 0 #code$))
										 (= CG_SKK_THR_CNT (nth 2 #code$))) ; 7?9(�������������)
							(setq #CNT_exist T) ; ����������݂���
						);_if
					)
				);_if
				(setq #i (1+ #i))
			);repeat

			(if #CNT_exist
				(progn
					(CFAlertMsg (strcat "�}�ʏ�Ƀ��[�N�g�b�v������Ă��Ȃ��J�E���^�[�����݂��܂��B"
															"\n���[�N�g�b�v�����Ă���SERIES�ύX���Ă��������B"))
					(quit)
				)
			);_if
		)
	);_if
	; 02/08/29 YM ADD-E

	(setq #flgTOKU nil)
	(if (and #ssTOKU (< 0 (sslength #ssTOKU)))
		(progn ; ��������(��АL�k�łȂ�)�����݂���ƏI�� 01/05/15 YM ADD
			; 01/08/28 YM ADD-S ���̫�Â�"SV","SK"�Ȃ̂żذ�ޕύX�͂��肦�Ȃ����ǉ�
			(setq #i 0)
			(repeat (sslength #ssTOKU)
				(if (and (setq #TOKU$ (CFGetXData (ssname #ssTOKU #i) "G_TOKU"))
								 (/= (nth 3 #TOKU$) 2)) ; ������ȊO(��АL�k or ����)
					(setq #flgTOKU T)
				);_if
				(setq #i (1+ #i))
			)
			; 01/08/28 YM ADD-E

;;;01/08/28YM@DEL			(setq #flgTOKU T)
			(if #flgTOKU
				(progn
					(CFAlertErr "�}�ʏ�ɓ����L���r�l�b�g�����݂��邽�߁ASERIES�ύX�ł��܂���B")
					(*error*)
				)
			);_if
		)
	);_if

	; ����ގ��s�ۂ�����
	(setq #seri$ (KP_CheckGtoN))

	; �}�ʏ��G_FILR���擾�`�i�ԕύX
  (setq #ssFILR (ssget "X" '((-3 ("G_FILR")))))

	(if (and #ssFILR (< 0 (sslength #ssFILR)))
		(progn
			(setq #i 0)
			(repeat (sslength #ssFILR)
				(setq #sym (ssname #ssFILR #i))
				(KPChSeriFILR #sym Ch_Seri) ; �i�ԕύX�g���ް��X�V
				(setq #i (1+ #i))
			)
		)
	);_if


	; �}�ʏ��LSYM���擾�`�i�ԕύX
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))

	(if (and #ss (< 0 (sslength #ss)))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #sym (ssname #ss #i))
				(KPChSeriHin #sym Ch_Seri) ; �i�ԕύX�g���ް��X�V
				(setq #i (1+ #i))
			)
		)
	);_if

	; �x���\��
	(if NG$
		(progn
			(setq #i 0)
			(foreach NG NG$
				(if (= #i 0)
					(setq #STR NG)
					(setq #STR (strcat #STR "," NG))
				);_if
				(setq #i (1+ #i))
			)
			(CFAlertErr (strcat "�i�Ԗ��́F\"" #STR "\"�̓f�[�^�x�[�X�ɂ��i�ԕύX���s�����Ƃ��ł��܂���ł����B"))
		)
	);_if

	; �}�ʏ��WRKT���擾�`�g���ް��X�V
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
	(if (and #ss (< 0 (sslength #ss)))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #WT (ssname #ss #i))
				(KPChSeriWT #WT Ch_Seri) ; �i�ԕύX�g���ް��X�V
				(setq #i (1+ #i))
			)
		)
	);_if

	; ���ύX Genic==>Notil
	(ChgDrCALL #seri$)
  (command "_purge" "BL" "*" "N") ; 01/05/14 YM ADD

	;2011/04/22 YM MOD
	(setvar "MODEMACRO"
		(strcat "�ذ��: " CG_SeriesDB " / ���ڰ��: " CG_DRSeriCode " / ��װ: " CG_DRColCode " / ����: " CG_HIKITE)
	)

	; 01/05/18 YM ADD �ذ���ݐ݌v�޲�۸ނ��I������
	(C:arxStartApp (strcat CG_SysPATH "KillPlan.exe") 0)
	(princ)

	(setq Ch_Seri nil NG$ nil)
  (setq *error* nil)
	(princ)
); C:KPChangeSeries

;;;<HOM>***********************************************************************
;;; <�֐���>    : KPChSeriG_OPT
;;; <�����T�v>  : G_OPT�i�Ԃ�Notil or Genic �i�Ԃɕϊ�����
;;; <�߂�l>    : G_OPT��ėpؽ� #Set$
;;; <�쐬>      : 01/04/12 YM �K�w??���Q�Ƃ���
;;; <���l>      :
;;;***********************************************************************>MOH<
(defun KPChSeriG_OPT (
	&xd$_OPT
  /
	#HINKOSU #HINNAME #I #KOSU #NEWHINNAME #QLY$ #SET$ #XD$_OPT
  )
	(setq #xd$_OPT &xd$_OPT)
	(setq #i 1)
	(setq #kosu (nth 0 #xd$_OPT))
	(setq #Set$ (list #kosu))
	(repeat #kosu
		(setq #HINname (nth #i #xd$_OPT))      ; OPT�i�Ԗ���
		(setq #HINkosu (nth (1+ #i) #xd$_OPT)) ; OPT�i��

	  (setq #QLY$
	    (CFGetDBSQLRec CG_DBSESSION (strcat "�K�w" CG_SeriesCode)
	      (list (list "�K�w����2" #HINname 'STR))
	  	)
		)
		(if (and #QLY$ (= (length #QLY$) 1)
						 (nth 2 (car #QLY$))
						 (/= "" (nth 2 (car #QLY$))))
			(setq #newHINname (nth 2 (car #QLY$))) ; �ϊ���̕i��
			(progn ; �ϊ���̕i�Ԃ����܂�Ȃ�
				(setq #newHINname #HINname) ; ���̂܂�
				(princ (strcat "\n�i��\"" #HINname "\"�͖��ύX�ł��B"))
				(setq NG$ (append NG$ (list #HINname)))
			)
		);_if
		(setq #Set$ (append #Set$ (list #newHINname #HINkosu)))
		(setq #i (+ #i 2))
	);repeat
	#Set$
);KPChSeriG_OPT

;;;<HOM>***********************************************************************
;;; <�֐���>    : KPChSeriFILR
;;; <�����T�v>  : G_FILR�i�Ԃ�Notil or Genic �i�Ԃɕϊ�����
;;; <�߂�l>    : G_FILR�}�`
;;; <�쐬>      : 01/04/12 YM �K�w??���Q�Ƃ��� G_OPT���ϊ�����
;;; <���l>      :
;;;***********************************************************************>MOH<
(defun KPChSeriFILR (
	&sym
	&Ch_Seri
  /
	#HINKOSU #HINNAME #I #KOSU #NEWHINNAME #QLY$ #SERIES #SET$ #SYM #XD$_FILR #XD$_OPT
  )
	(if (= &Ch_Seri "GN")(setq #series "N" ))
	(if (= &Ch_Seri "NG")(setq #series "SG"))

	(setq #sym &sym)
	(setq #xd$_OPT  (CFGetXData #sym "G_OPT"))  ; �g���ް�"G_OPT"�擾
	(setq #xd$_FILR  (CFGetXData #sym "G_FILR"))  ; �g���ް�"G_FILR" �擾
	(setq #HINname (nth 0 #xd$_FILR)) ; �i�Ԗ���

  (setq #QLY$
    (CFGetDBSQLRec CG_DBSESSION (strcat "�K�w" CG_SeriesCode)
      (list (list "�K�w����2" #HINname 'STR))
  	)
	)
	(if (and #QLY$ (= (length #QLY$) 1)
					 (nth 2 (car #QLY$))
					 (/= "" (nth 2 (car #QLY$))))
		(progn
			(setq #newHINname (nth 2 (car #QLY$))) ; �ϊ���̕i��
		  ;// �g���f�[�^�̍X�V
		  (CFSetXData #sym "G_FILR"
		    (CFModList #xd$_FILR
		      (list (list 0 #newHINname))
		    )
		  )
		)
		(progn ; �ϊ���̕i�Ԃ����܂�Ȃ�
			(setq #newHINname #HINname) ; ���̂܂�
			(princ (strcat "\n�i��\"" #HINname "\"�͖��ύX�ł��B"))
			(setq NG$ (append NG$ (list #HINname)))
		)
	);_if

;;;��"G_OPT"��
;;; 1. ��߼�ݕi�Ԃ̎�ސ�
;;; 2. OP�i�Ԗ���
;;; 3. ��
;;; �ȉ�1.��ސ���2.3.���J��Ԃ�

	; ��߼�ݕi������Εϊ�����
	(if #xd$_OPT
		(progn
			(setq #Set$ (KPChSeriG_OPT #xd$_OPT))
		  ;// �g���f�[�^�̍X�V
		  (CFSetXData #sym "G_OPT" #Set$)
		)
	);_if

	#sym
);KPChSeriFILR

;;;<HOM>***********************************************************************
;;; <�֐���>    : KPChSeriHin
;;; <�����T�v>  : ���ނ�G_SYM,G_LSYM��Notil or Genic �i�Ԃɂ���
;;; <�߂�l>    : ����ِ}�`
;;; <�쐬>      : 01/04/03 YM
;;; <���l>      : 01/04/11 YM �K�w??���Q�Ƃ��� G_OPT���ϊ�����
;;;***********************************************************************>MOH<
(defun KPChSeriHin (
	&sym
	&Ch_Seri
  /
  #HINNAME #LR #NEWHINNAME #QLY$$ #SYM #XD$_LSYM #XD$_SYM #series #SKK
	#HINKOSU #I #KOSU #SET$ #XD$_OPT #XD$_KUTAI
  )
		;///////////////////////////////////////////////////////////////////////////
		; 01/12/12 YM ADD �K�wTB�������ʂ̂�����ʊK�wID<0�̂��̂�����
		;///////////////////////////////////////////////////////////////////////////
		(defun ##DelRec (
			&Rec$$
		  /
			#RET
		  )
			(setq #ret nil) ; �߂�l
			(if &Rec$$
				(foreach #Rec$ &Rec$$
;;;01/12/26YM@MOD					(if (< (nth 1 #Rec$) 0) ; ��ʊK�wID<0
					(if (or (> (nth 1 #Rec$) 9000)(< (nth 1 #Rec$) 0)) ; ��ʊK�wID<0 or >9000
						nil
						(setq #ret (append #ret (list #Rec$)))
					);_if
				)
				(setq #ret nil)
			);_if
			#ret
		)
		;///////////////////////////////////////////////////////////////////////////

	(setq #sym &sym)
	(setq #xd$_KUTAI(CFGetXData #sym "G_KUTAI")); �g���ް�"G_KUTAI"�擾
	(if #xd$_KUTAI
		nil
		(progn ; ��͖̂��� 01/05/10 YM ADD

			(if (= &Ch_Seri "GN")(setq #series "N" ))
			(if (= &Ch_Seri "NG")(setq #series "SG"))

			(setq #xd$_OPT  (CFGetXData #sym "G_OPT"))  ; �g���ް�"G_OPT"�擾
			(setq #xd$_SYM  (CFGetXData #sym "G_SYM"))  ; �g���ް�"G_SYM" �擾
		;;;	(setq #SYMname (nth 0 #xd$_SYM)) ; ����ٖ���
			(setq #xd$_LSYM (CFGetXData #sym "G_LSYM")) ; �g���ް�"G_LSYM"�擾
			(setq #HINname (nth 5 #xd$_LSYM)) ; �i�Ԗ���
		;;;	(setq #LR      (nth 6 #xd$_LSYM)) ; LR�敪
			(setq #SKK     (nth 9 #xd$_LSYM)) ; ���i����

		  (setq #QLY$$
		    (CFGetDBSQLRec CG_DBSESSION (strcat "�K�w" CG_SeriesCode)
		      (list (list "�K�w����2" #HINname 'STR))
		  	)
			)
			; 01/12/12 YM ADD-S
			; #QLY$$�������̏ꍇ��ʊK�wID<0�͏���
			(setq #QLY$$ (##DelRec #QLY$$))
			; 01/12/12 YM ADD-E

			(if (and #QLY$$ (= (length #QLY$$) 1)
							 (nth 2 (car #QLY$$))
							 (/= "" (nth 2 (car #QLY$$))))
				(progn
					(setq #newHINname (nth 2 (car #QLY$$))) ; �ϊ���̕i��
				  ;// �g���f�[�^�̍X�V
				  (CFSetXData #sym "G_LSYM"
				    (CFModList #xd$_LSYM
				      (list
								(list 4 #series)
								(list 5 #newHINname)
							)
				    )
				  )
				)
				(progn ; �ϊ���̕i�Ԃ����܂�Ȃ�
					(setq #newHINname #HINname) ; ���̂܂�
					(if (equal #SKK CG_SKK_INT_SNK) ; �ݸ�Ȃ� ; 01/08/31 YM MOD 410-->��۰��ى�
						(progn ; �ݸ�ͼذ�ދL�������X�V����
						  ;// �g���f�[�^�̍X�V
						  (CFSetXData #sym "G_LSYM"
						    (CFModList #xd$_LSYM
						      (list	(list 4 #series))
						    )
						  )
						)
						(progn
							(princ (strcat "\n�i��\"" #HINname "\"�͖��ύX�ł��B"))
							(setq NG$ (append NG$ (list #HINname)))
						)
					);_if
				)
			);_if

		;;;��"G_OPT"��
		;;; 1. ��߼�ݕi�Ԃ̎�ސ�
		;;; 2. OP�i�Ԗ���
		;;; 3. ��
		;;; �ȉ�1.��ސ���2.3.���J��Ԃ�

			; ��߼�ݕi������Εϊ�����
			(if #xd$_OPT
				(progn
					(setq #Set$ (KPChSeriG_OPT #xd$_OPT))
				  ;// �g���f�[�^�̍X�V
				  (CFSetXData #sym "G_OPT" #Set$)
				)
			);_if

		)
	);_if
	(princ)
);KPChSeriHin

;;;<HOM>***********************************************************************
;;; <�֐���>    : KPChSeriWT
;;; <�����T�v>  : WT�̼ذ��,�ގ���Notil�ɕύX����
;;; <�߂�l>    : WT�}�`
;;; <�쐬>      : 01/04/03 YM
;;; <���l>      : Genic==>Notil�̂݉\
;;;***********************************************************************>MOH<
(defun KPChSeriWT (
	&WT
	&Ch_Seri
  /
  #DLOG$ #NWT_PRI #SERIES #SWT_ID #WT #WTSET$ #XD$_WT #XD$_WTSET #ZAICODE #ZAIF
#QRY$
  )
	(setq #WT &WT)
  (PCW_ChColWT #WT "MAGENTA" nil) ; 01/07/06 YM ADD
	(setq #xd$_WT    (CFGetXData #WT "G_WRKT"))
	(setq #xd$_WTSET (CFGetXData #WT "G_WTSET"))

	(setq #series  (nth 1 #xd$_WT)) ; �ذ��
	(setq #ZaiCode (nth 2 #xd$_WT)) ; �ގ��L��

  (setq #qry$
	  (CFGetDBSQLRec CG_DBSESSION "WT�ގ�"
	    (list (list "�ގ��L��" #ZaiCode 'STR))
	  )
	)

	(if (and #qry$ (= (length #qry$) 1))
		(setq #ZaiF (nth 4 (car #qry$))) ; �f��F 0:�l�H�嗝�� 1:���ڽ
		(setq #ZaiF 0) ; DB�ɂȂ�������l�刵��
	);_if

	(if (= &Ch_Seri "GN")
		(if (= #series "SG")(setq #series "N"))
	);_if

	(if (= &Ch_Seri "NG")
		(if (= #series "N")(setq #series "SG"))
	);_if

  ;// �ގ��L���̑I��(�޲�۸ނ̕\��)
	(if (equal #ZaiF 1 0.1)
		nil ; ���ڽ�͂��̂܂�
		(progn
  		(setq #ZaiCode (PKW_ZaiDlg nil)) ; #ZAI0
			; ��ݾّΉ� 01/07/23 YM ADD
			(if (= nil #ZaiCode)
				(progn
					(princ"\n����ނ�ݾق��܂����B") ; ��ݾَ� 01/07/23 YM
					(*error*)
				)
			);_if
		)
	);_if

  (CFSetXData #WT "G_WRKT"
    (CFModList #xd$_WT
      (list
				(list 1 #series)
				(list 2 #ZaiCode)
			)
    )
  )

	; �i�Ԋm�肳��Ă�����
	(if #xd$_WTSET
		(progn
			(setq #xd$_WT (CFGetXData #WT "G_WRKT"))
			; �޲�۸ޕ\�� �i��,���i�����
		  (setq #DLOG$
;;; 				(KPW_GetWorkTopInfoDlg
				(KPW_GetWorkTopInfoDlg_ChSeri ; 01/04/05 YM
					#xd$_WT
					(nth 1 #xd$_WTSET)
					(fix (+ (nth 3 #xd$_WTSET) 0.001))
				) ; G_WRKT,�i��,���i
			)
		  (if (= 'LIST (type #DLOG$))
		    (progn
		      (setq #sWT_ID (car #DLOG$))           ; �i�ԕ�����

					; �S�p��߰��𔼊p��߰��ɒu�������� 01/06/27 YM ADD
					(setq #sWT_ID (vl-string-subst "  " "�@" #sWT_ID)) ; հ�ް���͕i��

		      (setq #nWT_PRI (float (cadr #DLOG$))) ; ���i���ʎ���
		    )
				(progn
					(princ"\n����ނ�ݾق��܂����B") ; ��ݾَ� 01/07/23 YM
		    ; ؽĂ����Ȃ������ꍇ�A��ݾق��ꂽ�Ɣ��f�Bquit
		    	(*error*) ; ��ݾَ� 01/07/23 YM
				)
		  );_if

		  (CFSetXData #WT "G_WTSET"
		    (CFModList #xd$_WTSET
		      (list
						(list 1 #sWT_ID)
						(list 3 #nWT_PRI)
					)
		    )
		  )
		)
	);_if

  ; ���[�N�g�b�v�̐F���m��F�ɕς��� ; 01/07/06 YM ADD
  (if #xd$_WTSET
  	(command "_.change" #WT "" "P" "C" CG_WorkTopCol "")
		(command "_.change" #WT "" "P" "C" "BYLAYER" "")
	);_if
	#WT
);KPChSeriWT

;;;01/04/11YM@;;;<HOM>***********************************************************************
;;;01/04/11YM@;;; <�֐���>    : KPChSeriHin
;;;01/04/11YM@;;; <�����T�v>  : ���ނ�G_SYM,G_LSYM��Notil�i�Ԃɂ���
;;;01/04/11YM@;;; <�߂�l>    : ����ِ}�`
;;;01/04/11YM@;;; <�쐬>      : 01/04/03 YM
;;;01/04/11YM@;;; <���l>      : Genic==>Notil�̂݉\
;;;01/04/11YM@;;;***********************************************************************>MOH<
;;;01/04/11YM@(defun KPChSeriHin (
;;;01/04/11YM@	&sym
;;;01/04/11YM@	&Ch_Seri
;;;01/04/11YM@  /
;;;01/04/11YM@  #HINNAME #SYM #SYMNAME #XD$_LSYM #XD$_SYM
;;;01/04/11YM@  )
;;;01/04/11YM@
;;;01/04/11YM@;;; CG_SeriesCode
;;;01/04/11YM@
;;;01/04/11YM@		;///////////////////////////////////////////////////////////////////
;;;01/04/11YM@		(defun ##HINBANGtoN (	&HIN / )
;;;01/04/11YM@			(setq &HIN (strcat "N" (substr &HIN 2 (1- (strlen &HIN)))))
;;;01/04/11YM@		)
;;;01/04/11YM@		;///////////////////////////////////////////////////////////////////
;;;01/04/11YM@		(defun ##HINBANNtoG (	&HIN / )
;;;01/04/11YM@			(setq &HIN (strcat "G" (substr &HIN 2 (1- (strlen &HIN)))))
;;;01/04/11YM@		)
;;;01/04/11YM@		;///////////////////////////////////////////////////////////////////
;;;01/04/11YM@
;;;01/04/11YM@	(setq #sym &sym)
;;;01/04/11YM@	(setq #xd$_LSYM (CFGetXData #sym "G_LSYM")) ; �g���ް�"G_LSYM"�擾
;;;01/04/11YM@	(setq #HINname (nth 5 #xd$_LSYM)) ; �i�Ԗ���
;;;01/04/11YM@
;;;01/04/11YM@	(if (= &Ch_Seri "GN")
;;;01/04/11YM@		(progn
;;;01/04/11YM@			; �i�Ԑ擪��"G"==>"N"
;;;01/04/11YM@			(if (= (substr #HINname 1 1) "G")
;;;01/04/11YM@				(setq #HINname (##HINBANGtoN #HINname))
;;;01/04/11YM@			);_if
;;;01/04/11YM@			(setq #xd$_SYM  (CFGetXData #sym "G_SYM"))  ; �g���ް�"G_SYM" �擾
;;;01/04/11YM@			(setq #SYMname (nth 0 #xd$_SYM)) ; ����ٖ���
;;;01/04/11YM@			; �i�Ԑ擪��"G"==>"N"
;;;01/04/11YM@			(if (= (substr #SYMname 1 1) "G")
;;;01/04/11YM@				(setq #SYMname (##HINBANGtoN #SYMname))
;;;01/04/11YM@			);_if
;;;01/04/11YM@		)
;;;01/04/11YM@	);_if
;;;01/04/11YM@
;;;01/04/11YM@	(if (= &Ch_Seri "NG")
;;;01/04/11YM@		(progn
;;;01/04/11YM@			; �i�Ԑ擪��"N"==>"G"
;;;01/04/11YM@			(if (= (substr #HINname 1 1) "N")
;;;01/04/11YM@				(setq #HINname (##HINBANNtoG #HINname))
;;;01/04/11YM@			);_if
;;;01/04/11YM@			(setq #xd$_SYM  (CFGetXData #sym "G_SYM"))  ; �g���ް�"G_SYM" �擾
;;;01/04/11YM@			(setq #SYMname (nth 0 #xd$_SYM)) ; ����ٖ���
;;;01/04/11YM@			; �i�Ԑ擪��"N"==>"G"
;;;01/04/11YM@			(if (= (substr #SYMname 1 1) "N")
;;;01/04/11YM@				(setq #SYMname (##HINBANNtoG #SYMname))
;;;01/04/11YM@			);_if
;;;01/04/11YM@		)
;;;01/04/11YM@	);_if
;;;01/04/11YM@
;;;01/04/11YM@  ;// �g���f�[�^�̍X�V
;;;01/04/11YM@  (CFSetXData #sym "G_LSYM"
;;;01/04/11YM@    (CFModList #xd$_LSYM
;;;01/04/11YM@      (list (list 5 #HINname))
;;;01/04/11YM@    )
;;;01/04/11YM@  )
;;;01/04/11YM@  (CFSetXData #sym "G_SYM"
;;;01/04/11YM@    (CFModList #xd$_SYM
;;;01/04/11YM@      (list (list 0 #SYMname))
;;;01/04/11YM@    )
;;;01/04/11YM@  )
;;;01/04/11YM@	#sym
;;;01/04/11YM@);KPChSeriHin

;;;01/04/25YM@;;;<HOM>*************************************************************************
;;;01/04/25YM@;;; <�֐���>    : C:KP_WrBlock
;;;01/04/25YM@;;; <�����T�v>  : �޲�ݸ����݂���ۯ���ۑ�����
;;;01/04/25YM@;;; <����>      :
;;;01/04/25YM@;;; <�߂�l>    :
;;;01/04/25YM@;;; <�쐬>      : 01/04/25 YM
;;;01/04/25YM@;;; <���l>      :
;;;01/04/25YM@;;;*************************************************************************>MOH<
;;;01/04/25YM@(defun C:KP_WrBlock (
;;;01/04/25YM@	/
;;;01/04/25YM@	#BASE #I #P1 #P2 #SFNAME #SS #SSSYM #SYM
;;;01/04/25YM@	)
;;;01/04/25YM@
;;;01/04/25YM@  (StartUndoErr);// �R�}���h�̏�����
;;;01/04/25YM@;;;  (CFCmdDefBegin 6)
;;;01/04/25YM@;;;  (CFNoSnapReset)
;;;01/04/25YM@
;;;01/04/25YM@	(command "vpoint" "0,0,1"); ���_��^�ォ��
;;;01/04/25YM@  (setq #p1 (getpoint  "\n��_�ڂ��w��: "))
;;;01/04/25YM@  (setq #p2 (getcorner #p1 "\n��_�ڂ��w��: "))
;;;01/04/25YM@  (setq #ssSYM (ssget "C" #p1 #p2 '((-3 ("G_LSYM"))))) ; ���I��
;;;01/04/25YM@	(command "zoom" "p") ; ���_��߂�
;;;01/04/25YM@  (setq #base (getpoint  "\n�}����_���w��: "))
;;;01/04/25YM@
;;;01/04/25YM@	(if (and #ssSYM (> (sslength #ssSYM) 0))
;;;01/04/25YM@		(progn
;;;01/04/25YM@			(setq #i 0 #ss$ nil)
;;;01/04/25YM@			(repeat (sslength #ssSYM)
;;;01/04/25YM@				(setq #sym (ssname #ssSYM #i))
;;;01/04/25YM@;;;        (GroupInSolidChgCol2 #sym CG_InfoSymCol) ; �F��ς���
;;;01/04/25YM@				(setq #ss (CFGetSameGroupSS #sym)); �����ٰ�ߓ��̑S�}�`�I���
;;;01/04/25YM@				(setq #ss$ (append #ss$ (list #ss)))
;;;01/04/25YM@				(setq #i (1+ #i))
;;;01/04/25YM@			)
;;;01/04/25YM@		)
;;;01/04/25YM@	);_if
;;;01/04/25YM@
;;;01/04/25YM@	; �I��Ă�ؽ�==>�I���
;;;01/04/25YM@	(setq #ssALL (ssadd))
;;;01/04/25YM@	(foreach #ss #ss$
;;;01/04/25YM@		(setq #i 0)
;;;01/04/25YM@		(repeat (sslength #ss)
;;;01/04/25YM@			(setq #elm (ssname #ss #i))
;;;01/04/25YM@			(ssadd #elm #ssALL)
;;;01/04/25YM@			(setq #i (1+ #i))
;;;01/04/25YM@		)
;;;01/04/25YM@	)
;;;01/04/25YM@
;;;01/04/25YM@
;;;01/04/25YM@	; ̧�َw��
;;;01/04/25YM@	(setq #sFname (getfiled "�u���b�N�ۑ�" (strcat CG_SYSPATH "tmp\\") "dwg" 1))
;;;01/04/25YM@	(if (and #sFname #base #ssALL (> (sslength #ssALL) 0))
;;;01/04/25YM@		(progn
;;;01/04/25YM@			; ��ۯ��ۑ�
;;;01/04/25YM@			(setvar "FILEDIA" 0)
;;;01/04/25YM@			(command "._wblock" #sFname "" #base #ssALL "")
;;;01/04/25YM@			(command "._oops") ; �}�`����
;;;01/04/25YM@		)
;;;01/04/25YM@		(progn
;;;01/04/25YM@			(CFAlertMsg "\n�u���b�N�̕ۑ��Ɏ��s���܂����B")
;;;01/04/25YM@			(quit)
;;;01/04/25YM@		)
;;;01/04/25YM@	);_if
;;;01/04/25YM@
;;;01/04/25YM@  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
;;;01/04/25YM@;;;  (CFNoSnapStart)
;;;01/04/25YM@  (setq *error* nil)
;;;01/04/25YM@;;;  (CFCmdDefFinish)
;;;01/04/25YM@	(princ "\n�u���b�N���`���܂����B")
;;;01/04/25YM@);C:KP_WrBlock

;;;<HOM>*************************************************************************
;;; <�֐���>    : c:clear
;;; <�����T�v>  : �}�ʸر������(�����}�ʏ�Ԃɖ߂�)
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/05/15 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun c:clear (
	/
	#I #SS #SS0 #SSALL #MSG #SSROOM
	)
  (StartUndoErr);// �R�}���h�̏�����

;;;	(setq #msg "�}�ʂ��N���A�[���܂����H")
;;;  (if (CFYesNoDialog #msg)
;;;		(progn

			(setvar "CLAYER" "0") ; ���݉�w"0"
			(C:ALP);�S��w�\��
		  (setq #ssROOM (ssget "X" '((-3 ("G_ROOM"))))) ; �c������
			(setq #ssALL (ssget "X")) ; �S�}�`
			(setq #i 0)
			(repeat (sslength #ssROOM)
				(ssdel (ssname #ssROOM #i) #ssALL)
				(setq #i (1+ #i))
			)
			(command "_.erase" #ssALL "") ; �}�`�폜
			; ��ۯ��߰��
			(command "_purge" "A" "*" "N")

		  (if (not (tblsearch "LAYER" "N_SYMBOL"))
		    (command "_layer" "N" "N_SYMBOL" "C" 4 "N_SYMBOL" "L" SKW_AUTO_LAY_LINE "N_SYMBOL" "")
		  );_if
		  (if (not (tblsearch "LAYER" "N_BREAKW"))
		    (command "_layer" "N" "N_BREAKW" "C" -6 "N_BREAKW" "L" SKW_AUTO_LAY_LINE "N_BREAKW" "")
		  );_if
		  (if (not (tblsearch "LAYER" "N_BREAKD"))
		    (command "_layer" "N" "N_BREAKD" "C" -6 "N_BREAKD" "L" SKW_AUTO_LAY_LINE "N_BREAKD" "")
		  );_if
		  (if (not (tblsearch "LAYER" "N_BREAKH"))
		    (command "_layer" "N" "N_BREAKH" "C" -6 "N_BREAKH" "L" SKW_AUTO_LAY_LINE "N_BREAKH" "")
		  );_if
		  (if (not (tblsearch "LAYER" "Z_KUTAI"))
		    (command "_layer" "N" "Z_KUTAI" "C" 55 "Z_KUTAI" "L" SKW_AUTO_LAY_LINE "Z_KUTAI" "")
		  );_if

			(CFSetXRecord "BASESYM" nil) ; ����т̸ر� 01/05/16 YM ADD

;;;  (setq #APPname$ '())
;;;  (setq #APPdata (tblnext "APPID" T))
;;;  (while #APPdata
;;;    (setq #APPname$ (append #APPname$ (list (cdr (assoc 2 #APPdata)))))
;;;    (setq #APPdata (tblnext "APPID" nil))
;;;  )
;;;	; "ACAD","G_ARW","G_LSYM","G_ROOM"�ȊO�̱��ع���ݖ��͕s�v

;;;		)
;;;		(*error*)
;;;  );_if

  (command "pdmode" "0")
  (setq *error* nil)
	(princ)
);c:clear

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:CabHide
;;; <�����T�v>  : �I����ȯĂ��\���ɂ���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/01/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:CabHide (
  /
	#ELM #I #LAY #SS #SSSELECT #SYM$
	#LAYERDATA #LAYERNAME$ #EED #EG$
  )
	; �O����
	(StartUndoErr)
  (CFCmdDefBegin 6)

;;;01/06/01YM@  ;���ݎg�p���̉�w�ꗗ���擾
;;;01/06/01YM@  ;�ذ��or��\����Ԃ̉�w�͏Ȃ�
;;;01/06/01YM@  (setq #layername$ '())
;;;01/06/01YM@  (setq #layerdata (tblnext "LAYER" T))
;;;01/06/01YM@  (while #layerdata
;;;01/06/01YM@    (if (and (=  (cdr (assoc 70 #layerdata)) 0) ;��w���ذ�ނł͂Ȃ�
;;;01/06/01YM@             (>= (cdr (assoc 62 #layerdata)) 0));��\���ł��Ȃ�
;;;01/06/01YM@      (setq #layername$ (append #layername$ (list (cdr (assoc 2 #layerdata)))))
;;;01/06/01YM@    )
;;;01/06/01YM@    (setq #layerdata (tblnext "LAYER" nil))
;;;01/06/01YM@  )

	;;; �I���ނ̂ݐԐF�ɂ���
;;;	(setq #ssSELECT (ItemSelKEKOMI '(("DUMMY")("G_LSYM")) CG_InfoSymCol '("?" "?" "?")))
	(setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_InfoSymCol))
	; �F��߂�
;;;	(setq #sym$ (cadr (ChangeItemColorKEKOMI #ssSELECT nil '("?" "?" "?"))))
  (ChangeItemColor #ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil)

;;;  (setvar "PICKAUTO" 1) ; 1:���\��
;;;  (setvar "PICKSTYLE" 0) ; ��ٰ�߂��I��

	(if (= (tblsearch "APPID" "G_HIDELAY") nil) (regapp "G_HIDELAY"))

  ; ��\���p��w�̍쐬
  (if (= nil (tblsearch "LAYER" SKW_TMP_HIDE))
    (command "_.layer" "N" "HIDE" "F" "HIDE" "")
  )
	(if (and #ss (> (sslength #ss) 0))
		(progn
			(princ "\n��\���� ... \n")
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #eg$ (entget (ssname #ss #i)))
				(setq #lay (cdr (assoc 8 #eg$)))
	      (setq #eed (list "G_HIDELAY" (cons 1000 #lay)))
;;;				(if (member #lay #layername$);��޼ު�ĉ�w�����ݎg�p��
;;;					(progn
			      (entmod
							(append
								(subst (cons 8 SKW_TMP_HIDE) (cons 8 #lay) #eg$) ; ��w�ύX
								(list (list -3 #eed))
							)
						)
;;;					)
;;;				);_if
				(setq #i (1+ #i))
			)
		)
		(princ "\n��\���ɂ��镔�ނ͂���܂���B\n")
	);_if

	; �㏈��
  (setq *error* nil)
  (CFCmdDefFinish)
	(princ)
);C:CabHide

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:CabShow
;;; <�����T�v>  : �I����ȯĂ��\���ɂ���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/01/12 YM
;;; <���l>      : 01/09/03 YM ��v�����֐���
;                 �ʂ̏ꏊ����undo�������܂܂Ȃ�������call�ł���悤�ɂ���
;;;*************************************************************************>MOH<
(defun C:CabShow (
  /
  )
	; �O����
	(StartUndoErr)

	(CabShow_sub) ; 01/09/03 YM MOD �֐���

	; �㏈��
  (setq *error* nil)
	(princ)
);C:CabShow

;;;<HOM>*************************************************************************
;;; <�֐���>    : CabShow_sub
;;; <�����T�v>  : �I����ȯĂ��\���ɂ���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/09/03 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun CabShow_sub (
  /
	#EG$ #I #LAY #SS #EG #HAND #HAND$ #J #SHAND
  )
	(setq #ss (ssget "X" '((8 . "HIDE"))))
	(if (and #ss (> (sslength #ss) 0))
		(progn
			(princ "\n�\���� ... \n")
			(setq #i 0)
			(setq #hand$ nil)
			(repeat (sslength #ss)
				(setq #eg$ (entget (ssname #ss #i)))
				(if (setq #lay (CFGetXData (ssname #ss #i) "G_HIDELAY")) ; nil�̏ꍇ�Ή� 01/08/24 YM ADD
					(progn
						(setq #lay (car #lay))
						(entmod (subst (cons 8 #lay) (assoc 8 #eg$) #eg$)) ; ��w�����ɖ߂�
						; �g���ް����폜
		        (CFSetXData (ssname #ss #i) "G_HIDELAY" nil)
					)
					(progn
						(setq #hand (cdr (assoc 5 (entget (ssname #ss #i))))) ; �}�`�����
						(setq #hand$ (append #hand$ (list #hand)))
					)
				);_if

				(setq #i (1+ #i))
			);repeat

			(if #hand$
				(progn
					(setq #sHAND "")
					(setq #j 0)
					(foreach hand #hand$
						(if (= #j 0)
							(setq #sHAND (strcat #sHAND hand))
							(setq #sHAND (strcat #sHAND "," hand))
						);_if
						(setq #j (1+ #j))
					)
					(princ (strcat "\n���̐}�`�͌��̉�w���s���ł��B���݂̉�w��\"HIDE\"�ł��B\n" #sHAND)) ; 01/11/28 YM MOD
;;;01/11/28YM@MDO					(CFAlertMsg (strcat "���̐}�`�͌��̉�w���s���ł��B���݂̉�w��\"HIDE\"�ł��B\n" #sHAND))
				)
			);_if

		)
		(princ "\n��\���̃L���r�l�b�g�͂���܂���B\n")
	);_if

	(princ)
);CabShow_sub

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KP_TOKUCabShow
;;; <�����T�v>  : �����L���r�ɐF�����ĕ\������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/09/26 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KP_TOKUCabShow (
  /
	#ELM #I #SS #SYM
  )
	; �O����
	(StartUndoErr)

	(setq #ss (ssget "X" '((-3 ("G_TOKU")))))
	(if (and #ss (< 0 (sslength #ss)))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #sym (ssname #ss #i))
				(GroupInSolidChgCol2 #sym "Yellow") ; ��,��,���F�ȊO
				(setq #i (1+ #i))
			)
		)
		(progn
			(CFAlertMsg "�}�ʏ�ɓ����L���r�l�b�g�͑��݂��܂���B")
		)
	);_if

	; �㏈��
  (setq *error* nil)
	(princ)
);C:KP_TOKUCabShow

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KP_TOKUCabHide
;;; <�����T�v>  : �����L���r�̐F�����ɖ߂�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/09/26 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KP_TOKUCabHide (
  /
	#I #SS #SYM
  )
	; �O����
	(StartUndoErr)

	(setq #ss (ssget "X" '((-3 ("G_TOKU")))))
	(if (and #ss (< 0 (sslength #ss)))
		(progn
			(setq CG_BASESYM (CFGetBaseSymXRec)) ; �����
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #sym (ssname #ss #i))
				; �F��߂�
				(if (equal CG_BASESYM #sym) ;�����
				  (GroupInSolidChgCol #sym CG_BaseSymCol)
				  (GroupInSolidChgCol2 #sym "BYLAYER")
				);_if
				(setq #i (1+ #i))
			)
		)
		(progn
			(CFAlertMsg "�}�ʏ�ɓ����L���r�l�b�g�͑��݂��܂���B")
		)
	);_if

	; �㏈��
  (setq *error* nil)
	(princ)
);C:KP_TOKUCabHide

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KP_ChLogo
;;; <�����T�v>  : �o�͐}�ʂ̃��S�����ւ���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/09/27 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KP_ChLogo (
  /
	#P1 #P2 #POS #SFNAME #SS #ANG #SCLX #SCLY #DEFSCLX #DEFSCLY #OS #OT #SM #PS
	#EN #I #SS0 #SS1 #SSP
  )
	; �O����
	(StartUndoErr)
	; ���ѕϐ��ݒ�
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"    1)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
;;;	(command "_zoom" "e")

  ;// �O���[�v�I�����[�h�ɂ��ăO���[�v�S�̂��擾����
  (setq #ps (getvar "PICKSTYLE"))
  (setvar "PICKSTYLE" 3)

	; ۺލ폜�͈�
	(princ "\n���S�g���l�p�ň͂��ĉ�����")
	(setq #p1 (getpoint))
	(setq #p2 (getcorner #p1))

	; #p1,#p2���݂���5mm�߂Â���(ۺޘg�������Ȃ�����)
	(setq #p1 (polar #p1 (angle #p1 #p2) 5))
	(setq #p2 (polar #p2 (angle #p2 #p1) 5))
  (setvar "OSMODE"    0)
;;;	(command "rectang" #p1 #p2)

	; ۺޑ}���_
;;;	(setq #pos '( 720 450))
	(setq #ang 0.0)

	; ۺނ�ްт���(�ްт��Ȃ���ۺޘg��������)
	(command "_.zoom" "W" #p1 #p2)

	(princ "\n���S���폜��...")

;;;	(setq #ss (ssget "C" #p1 #p2))

	; �O���[�v�I���ō폜
	(command "_.erase" (ssget "C" #p1 #p2) "") ; ����ۺނ̍폜

	; �ްёO�ɖ߂�
	(command "_.zoom" "P")

	; ۺނ̑I��
	(setq #sFname (getfiled "���S�}�ʂ̑I��" (strcat CG_SYSPATH "TEMPLATE\\LOGO\\") "dwg" 8))

	(if (= nil #sFname)(quit)) ; 01/10/15 YM

	; �ړx�����
	(setq #defSCLX "1.0") ; ��̫�Ľ���
	(setq #defSCLY "1.0") ; ��̫�Ľ���

  (setq #sclX (getreal (strcat "\nX�����̔{��<" #defSCLX ">: ")))
	(if (= #sclX nil)
		(setq #sclX (atof #defSCLX))
	); if

  (setq #sclY (getreal (strcat "\nY�����̔{��<" #defSCLY ">: ")))
	(if (= #sclY nil)
		(setq #sclY (atof #defSCLY))
	); if

	(princ "\n�}���_���w��: ")
	(command "_.INSERT" #sFname PAUSE #sclX #sclY #ang)

  ;����&�O���[�v��
  (command "_explode" (entlast)) ;�C���T�[�g�}�`����
	(setq #ss0 (ssget "P"))
	(setq #i 0)
	(repeat (sslength #ss0)
		(setq #en (ssname #ss0 #i))
		(if (= "INSERT" (cdr (assoc 0 (entget #en))))
			(progn
			  (command "_explode" #en) ;�C���T�[�g�}�`����
				(setq #ss1 (ssget "P"))
			)
		);_if
		(setq #i (1+ #i))
	)

	(command "_purge" "bl" "*" "N")
	(command "_purge" "bl" "*" "N")

	; ss1,ss0�����킹��
  (setq #ssP (ssadd)) ; ��̑I���Z�b�g
  (setq #ssP (CMN_ssaddss #ss0 #ss1)) ; �S�I���Z�b�g���P�ɂ܂Ƃ߂�.


	; �g����݂͂ł�ۺނ��폜����Ƃ��̂��߸�ٰ�߉����Ă���
	; 01/10/12 YM ��ٰ�߉�������ꕔ���������ɂȂ�
;;;01/10/12YM@DEL	(command "-group" "C" "LOGO" "LOGO" #ssP "")   ;���������}�`�Q�ŃO���[�v��
;;;  (SKMkGroup #ss1)

	; �㏈��
  (setq *error* nil)
	; ���ѕϐ��ݒ��߂�
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)
  (setvar "PICKSTYLE" #ps)

	(princ)
);C:KP_ChLogo

;<HOM>*************************************************************************
; <�֐���>    : C:KP_COPYCLIP
; <�����T�v>  : COPYCLIP�R�}���h
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/02/01 YM
; <���l>      :
;*************************************************************************>MOH<
(defun C:SK_COPYCLIP(
  /
	#pickauto #PICKFIRST
  )
	; �R�}���h�̏�����
  (StartUndoErr)
	(setq #PICKAUTO (getvar "PICKAUTO"))
	(setq #PICKFIRST (getvar "PICKFIRST"))
	(setvar "PICKAUTO" 1)
	(setvar "PICKFIRST" 1)

	(command "._COPYCLIP")

	(setvar "PICKAUTO" #pickauto)
	(setvar "PICKFIRST" #PICKFIRST)
  (setq *error* nil)
  (princ)
);C:SK_COPYCLIP

;<HOM>*************************************************************************
; <�֐���>    : C:KP_PASTECLIP
; <�����T�v>  : PASTECLIP�R�}���h
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/02/01 YM
; <���l>      :
;*************************************************************************>MOH<
(defun C:SK_PASTECLIP(
  /
	#pickauto #PICKFIRST
  )
	; �R�}���h�̏�����
	(setq #PICKAUTO (getvar "PICKAUTO"))
	(setq #PICKFIRST (getvar "PICKFIRST"))
	(setvar "PICKAUTO" 1)
	(setvar "PICKFIRST" 1)

	(command "._PASTECLIP")

	(princ "\n�\��t���܂���.")
	(setvar "PICKAUTO" #pickauto)
	(setvar "PICKFIRST" #PICKFIRST)
  (setq *error* nil)
  (princ)
);C:SK_PASTECLIP

(princ)
