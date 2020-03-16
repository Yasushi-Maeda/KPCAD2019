;<HOM>*************************************************************************
; <�֐���>    : PosKUTAI
; <�����T�v>  : ��̔z�u
; <�߂�l>    :
; <�쐬>      : 2000/11/21 SN
; <���l>      :
;*************************************************************************>MOH<
(defun c:PosKUTAI( 
  /
  #fig$
  #LUPREC #ELEVATION
  #FName #FlogName
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:PosParts ////")
  (CFOutStateLog 1 1 " ")
  ;;; �R�}���h&�G���[�����̏�����
  (StartUndoErr)
  ;;; �ů�ߊ֘A�̏�����(�����̏����ŕύX���Ă����ɖ߂�悤��)
  (CFCmdDefBegin nil)
  ;;;��������L�� PcSetKUTAI���ŕύX������
  (setq #ELEVATION (getvar "ELEVATION"))
  ;;;RTOS�̓V�X�e���ϐ�LUPREC�ɂ���ď������𐧌��ł���B
  (setq #LUPREC (getvar "LUPREC"))
  (setvar "LUPREC" 2)

  ;;; ��̏��̎擾
  (if (not (setq #fig$ (SKY_GetItemInfo)))
    (CFAlertErr "�i�ԏ����擾�ł��܂���ł���"))

  ;;; �L�k������SELPARTS.CFG���������Ă���ׁA�ȍ~�̍�ƂɎx�Ⴊ�ł�B
  ;;; ����č�ƏI���㖼�O��ύX�E�폜����B�ꎞ̧�قȂ̂Ŗ��Ȃ��B
  (setq #FName    (strcat CG_SYSPATH "SELPARTS.CFG"))
  (setq #FlogName (strcat CG_SYSPATH "SELPARTS.LOG"))
  (vl-file-delete  #FlogName)
  (vl-file-rename  #FName #FlogName)
  ;(vl-file-delete #FName)

  ;; ��̂̔z�u
  (PcSetKUTAI #fig$)

  ;;;�ύX�����V�X�e���ϐ������ɖ߂�
  (setvar "LUPREC"    #LUPREC)
  (setvar "ELEVATION" #ELEVATION)
	(command "_.layer" "T" "Z_KUTAI" "") ; 01/03/30 YM ADD

  ;;; �ů�ߊ֘A��߂�(�����̏����ŕύX���Ă����ɖ߂�悤��)
  (CFCmdDefFinish)
  ;;; �װ������߂�
  (setq *error* nil)
  (princ)
)
;<HOM>*************************************************************************
; <�֐���>    : PosKUTAI
; <�����T�v>  : ��̔z�u
; <�߂�l>    :
; <�쐬>      : 2000/11/21 SN
; <���l>      :
;*************************************************************************>MOH<
(defun PcSetKUTAI( 
  &fig$
  /
  #Name #Type
  #sql #qry$
  #Indcd                      ;�w���d�l����
  #Indmsg1 #Indmsg2 #Indmsg3  ;�w���U��ү����
  #IndId1  #IndId2  #IndId3   ;�w���U��ү����ID
  #P1$     #P2$     #P3$      ;�w���_
  #Wname #Dname #Hname #Bname ;���͍���
  #Wcd   #Dcd   #Hcd   #Bcd   ;���ͺ���
  #Wxd   #Dxd   #Hxd   #Bxd   ;���͏����l(XDATA G_SYM)
  #Wset  #Dset  #Hset  #Bset  ;�ŏI�I�ȕ����s����
  #wdhb$ #eawd$
  #msg
  #xdg_sym$
  #fname #ss #eNEW #wBase #dBase #dINS #WAng #DAng
  #wk
  #HaitiMode ; 0:���S�Ɉ�U�z�u
             ; 1:�g�O�Ɉ�U�z�u���z�u���쎞�ɒ��S�Ɉړ�
             ; 2:�g�O�ɔz�u���U�폜���ēxINSERT
  #ii #sOlayer #sNlayer #eget #emod #fHmov #strFLG #orgLYR$
#LASTZ #MSG #OS #OT #SM ; 01/04/09 YM
  )
  (setq #HaitiMode 2)

  ;;; ��̓��͎��̎w���U��ү���ގ擾�֐�
  (defun #getindmsg( &no / #sql #qry$ )
    (setq #sql (strcat "select �w��MSG from ���MSG where MSG_ID=" &no))
    (setq #qry$ (car (DBSqlAutoQuery CG_CDBSession #sql)))
    (if #qry$
      (car #qry$)
      (progn
        (setq msg "  PcSetKUTAI:�w�w��MSG�x��������܂���ł���")
        (CFOutStateLog 0 1 msg)
        (CFOutStateLog 0 1 (strcat "        " #sql))
        (CFAlertMsg #msg)
        nil
      )
    )
  );End

  ;;; ��̓��͎����޲�۸ޖ��̎擾�֐�
  (defun #getitemname( &no / #sql #qry$ )
    (setq #sql (strcat "select ���ږ��� from ��̖��� where ����ID=" &no))
    (setq #qry$ (car (DBSqlAutoQuery CG_CDBSession #sql)))
    (if #qry$
      (car #qry$)
      (progn
        (setq msg "  PcSetKUTAI:�w���ږ��́x��������܂���ł���")
        (CFOutStateLog 0 1 msg)
        (CFOutStateLog 0 1 (strcat "        " #sql))
        (CFAlertMsg #msg)
        nil
      )
    )
  );End

  ;;;��̐}�`�����擾
  (setq #Name (car &fig$))
  (setq #sql (strcat "select * from ��̐}�` where ��̖���='" #Name "'"))
  (setq #qry$ (car (DBSqlAutoQuery CG_CDBSession #sql)))
  (if (= #qry$ nil)
    (progn
      (setq #msg "  PcSetKUTAI:�w��̐}�`�x��������܂���ł���")
      (CFOutStateLog 0 1 #msg)
      (CFOutStateLog 0 1 (strcat "        " #sql))
      (CFAlertMsg #msg)
      (exit)
    )
  )

  ;;; �������
  (setq #Type  (fix(nth 2 #qry$)))
  ;;; ��̔z�u���̎w���d�l����
  (setq #Indcd (fix(nth 3 #qry$)))
  ;;; ��̔z�u���̎w���U��ү����ID�擾
  (setq #IndId1 (fix(nth 4 #qry$)))
  (setq #IndId2 (fix(nth 5 #qry$)))
  (setq #IndId3 (fix(nth 6 #qry$)))
  ;;; ��̔z�u���̎w���U��ү���ގ擾
  (if (/= (nth  4 #qry$) 0) (setq #Indmsg1 (#getindmsg (itoa #IndId1))))
  (if (/= (nth  5 #qry$) 0) (setq #Indmsg2 (#getindmsg (itoa #IndId2))))
  (if (/= (nth  6 #qry$) 0) (setq #Indmsg3 (#getindmsg (itoa #IndId3))))
  ;;; ��̓��͎����޲�۸ޖ��̎擾�֐�
  (if (/= (nth  7 #qry$) 0) (setq #Wname (#getitemname (rtos(nth  7 #qry$)))))
  (if (/= (nth  8 #qry$) 0) (setq #Dname (#getitemname (rtos(nth  8 #qry$)))))
  (if (/= (nth  9 #qry$) 0) (setq #Hname (#getitemname (rtos(nth  9 #qry$)))))
  (if (/= (nth 10 #qry$) 0) (setq #Bname (#getitemname (rtos(nth 10 #qry$)))))
  ;;; ��̓��͎��̺���
  (setq #Wcd (fix(nth 11 #qry$)))
  (setq #Dcd (fix(nth 12 #qry$)))
  (setq #Hcd (fix(nth 13 #qry$)))
  (setq #Bcd (fix(nth 14 #qry$)))
  ;�}�`ID�擾
  (setq #fname (nth 15 #qry$))

  (setq #dBase (getvar "VIEWCTR"))      ;���݂�VIEW�̒��S���擾

  (setq #wBase (list 10000 10000 10000));�͈͊O���z�u�ꏊ
  (if (= #HaitiMode 0) (setq #wBase #dBase));���S�z�u�Ȃ牼�z�u�ꏊ��ύX
  ;;; ����Kcparts.lsp��(Pcsetitem)���甲�o������
  ;;; ���߂Ă̍�}�̉\�������邽�߁A��}�p�̉�w�ݒu
  (MakeLayer "Z_00_00_00_01" 7 "CONTINUOUS")
  (Pc_CheckInsertDwg (strcat #fname ".dwg") CG_MSTDWGPATH) ; 01/02/07 MH ADD
  ;��U�����Ȃ��Ƃ����INSERT��EXPLODE��GROUP�Ŕz�u����B
  (command ".insert" (strcat CG_MSTDWGPATH #fname) #wBase 1 1 0) 
  (command "_explode" (entlast))
  (setq #ss (ssget "P"))
  (SKMkGroup #ss) ;���������}�`�Q�Ŗ��O�̂Ȃ��O���[�v�쐬
  (command "_layer" "u" "N_*" "")
  (setq #eNEW (SearchGroupSym (ssname #ss 0)))
  (setq #wBase (cdr (assoc 10 (entget #eNEW))))
  ;(command "_.layer" "on" "M_*" ""); �S���ʉ�w���� 00/12/22 SN DEL ��̂ɂ͖����̂ŕs�v
  ;;; ����Kcparts.lsp��(Pcsetitem)���甲�o������

  ;;; XData G_SYM ����K�v���擾
  (setq #xdg_sym$ (CFGetXData #eNEW "G_SYM"))
  (setq #Wxd (nth 3 #xdg_sym$))
  (setq #Dxd (nth 4 #xdg_sym$))
  (setq #Hxd (nth 5 #xdg_sym$))
  (setq #Bxd (nth 6 #xdg_sym$))
  (if (= #HaitiMode 2)(progn  ;��INSERT����Ȃ�
    (command "._erase" #ss "");��U�����B
    (setq #ss nil)            ;�I��Ă�ر
  ));End if-progn
  ;;; ���̓R�[�h�ɂ��_�C�A���O�\���l�̕ύX
  (setq #Wset #Wxd)
  (setq #Dset #Dxd)
 
  (cond
    ;��[/���[����(CG_CeilHeight=��[); 01/04/10 MH ADD �V�䂩��ݒu�̏����ǉ�
    ((= (nth 10 #xdg_sym$) -1)
      (setq #Hset #Hxd)
      (setq #Bset CG_CeilHeight)
    )
    ;��[/���[����(��t��=��[)
    ((= #Hcd 1)
      (setq #Hset #Bxd)         ;��[��B�l
      (setq #Bset (- #Bxd #Hxd));���[��B�l-H�l
    )
    ;��[/���[����(��t��=���[)
    ((= #Hcd 2)
      (setq #Hset (+ #Hxd #Bxd));��[��H�l+B�l
      (setq #Bset #Bxd)         ;���[��B�l
    )
    (T
      (setq #Hset #Hxd)
      (setq #Bset #Bxd)
    )
  );End cond

  ;;; ���[�U�}�`�T�C�Y�̕ύX�_�C�A���O
  ;;; �߂�l��(W�l D�l H�l B�l)
  (setq #wdhb$ (kutaidlg #Name #Wname #Dname #Hname #Bname #Wcd #Dcd #Hcd #Bcd #Wset #Dset #Hset #Bset))

  ;;; �_�C�A���O���͒l�̎擾
  (setq #Wset (atof(nth 0 #wdhb$)))
  (setq #Dset (atof(nth 1 #wdhb$)))
  (setq #Hset (atof(nth 2 #wdhb$)))
  (setq #Bset (atof(nth 3 #wdhb$)))
  ;;;���ͺ��ނɂ��WDHB�l�̓���
  (if (= #Wcd 1);���a�̎���D=W
    (setq #Dset #Wset)
  );End if
  (cond
    ;��[/���[����(��t��=��[)
    ((= #Hcd 1)
      (setq #wk #Hset)            ;��t�������ꎞ�ۑ�
      (setq #Hset (- #Hset #Bset));H�l�͏�[-���[
      (setq #Bset #wk)            ;��t�����͏�[
    )
    ;��[/���[����(��t��=���[)
    ((= #Hcd 2)
      (setq #Hset (- #Hset #Bset));H�l�͏�[-���[
    )
  );End cond
 
  (setvar "ELEVATION" #Bset)
  ;;;���z�u���͈͊O or
  ;;;���z�u�����S�Ŋ�������ς��Ă������U������Ƌ�̊�ʒu��ύX
  (if (or (= #HaitiMode 1)
          (and (= #HaitiMode 0) (caddr #dBase) (/= #Bset (caddr #dBase))))(progn
    (setq #dBase (list (car #dBase) (cadr #dBase) #Bset))
    (command "._move" #ss "" #wBase #dBase)
  ));End if-progn
  ;;; ���[�U�}������
  ;;; �߂�l��(ename Angle Wlen Dlen)
  (setq #eawd$ (kutaihaiti #Indcd #Indmsg1 #Indmsg2 #Indmsg3 #Wset #Dset #HaitiMode #ss #eNEW #fname))
  ;;;��}�`�E��_�E�p�x�̎擾���_�w���ɂ��WDHB�l�̓���
  (setq #eNEW (nth 0 #eawd$))
  (setq #dIns (cdr (assoc 10 (entget #eNEW))))
  (setq #WAng (nth 1 #eawd$));��]�p�x
  ;;2�_�ځE3�_�ڂ̈Ӗ����w���d�lCD�ɂ��U�蕪����
  (cond
    ((= #indcd 4);2�_�w��
      (setq #Wset (nth 2 #eawd$))
    )
    ((= #indcd 5);2�_+D����
      (setq #Wset (nth 2 #eawd$))
    )
    ((= #indcd 6);3�_�w��
      (setq #Wset (nth 2 #eawd$))
      (setq #Dset (nth 3 #eawd$))
    )
  );End cond


  ; 01/02/27 YM START
	; �w����t�������ƈႤ�ꍇ�͈ړ�����
	(setq #lastZ (caddr #dIns))
	(if (equal #lastZ #Bset 0.001) ; �����ײݎw�荂���ƈႤ�Ȃ�ړ�����
		nil
		(progn
;;; ���ѕϐ��ݒ� 01/04/09 YM �ꎞ����
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)

			(command "_move" (CFGetSameGroupSS #eNEW) "" '(0 0 0) (list 0 0 (- #Bset #lastZ)))
			(setq #dIns (list (car #dIns)(cadr #dIns) #Bset))

;;; ���ѕϐ��ݒ� 01/04/09 YM
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)

		)
	);_if
	; 01/02/27 YM END

  ;;;XDATA�ݒ�
  (if (= nil (tblsearch "APPID" "G_LSYM")) (regapp "G_LSYM"))
  (CFSetXData #eNew "G_LSYM"
    (list
      #fname                ;1 :�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID
      #dIns                 ;2 :�}���_          :�z�u��_
      #WAng                 ;3 :��]�p�x        :�z�u��]�p�x
      CG_KCode              ;4 :�H��L��        :CG_Kcode
      CG_SeriesCode         ;5 :SERIES�L��    :CG_SeriesCode
      #Name                 ;6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���
      "Z"                   ;7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪
      ""                    ;8 :���}�`ID        :
      ""                    ;9 :���J���}�`ID    :
      999                   ;10:���iCODE      :�w�i�Ԋ�{�x.���iCODE
      0                     ;11:�����t���O      :�O�Œ�i�P�ƕ��ށj
      0                     ;12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
      0                     ;13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�
      #Hxd                  ;14:���@�g          :�w�i�Ԑ}�`�x.���@�g
      0                     ;15:�f�ʎw���̗L��  :�w�v���\���x.�f�ʗL�� 00/07/18 SN MOD
    )
  )
  (if (= nil (tblsearch "APPID" "G_KUTAI")) (regapp "G_KUTAI"))
  (CFSetXData #eNew "G_KUTAI"
    (list
      #Type                 ;1 :�������
    )
  )
  
  ; �L�k�֘A����  01/02/02 MH ADD "G_PRIM" 3D�}�`�����C�N�����ǉ� 
  ;             ��DXF��ύX����entmod���Ă��F�Ȃǔ��f���Ȃ�3D�s��̑΍�
  (CFCmdDefStart 0);�ů�ߊ֌W����
  (setq #strFLG nil)

  ;;;�ύX�̂��������������L�k���Ă���
  (if (not (equal #Wxd #Wset 0.0001))(progn
    (setq #strFLG 'T)
    (SKY_Stretch_Parts #eNEW #Wset #Dxd #Hxd)
    ; �c�L�k�ɂƂ��Ȃ��ʒu�ړ� (W�t���O= -1�̃A�C�e��) 01/02/27 YM ADD
    (if (= -1 (nth 8 #xdg_sym$)) (PcMoveItem #eNEW #dIns))
  )); if progn
  (if (not (equal #Dxd #Dset 0.0001))(progn
    (setq #strFLG 'T)
    (SKY_Stretch_Parts #eNEW #Wset #Dset #Hxd)
    ; �c�L�k�ɂƂ��Ȃ��ʒu�ړ� (D�t���O= -1�̃A�C�e��) 01/02/27 YM ADD
    (if (= -1 (nth 9 #xdg_sym$)) (PcMoveItem #eNEW #dIns))
  )); if progn
  (if (not (equal #Hxd #Hset 0.0001))(progn
    (setq #strFLG 'T)
    (SKY_Stretch_Parts #eNEW #Wset #Dset #Hset)
    ; �c�L�k�ɂƂ��Ȃ��ʒu�ړ� (H�t���O= -1�̃A�C�e��) 01/02/02 MH ADD
    (if (= -1 (nth 10 #xdg_sym$)) (PcMoveItem #eNEW #dIns))
  )); if progn
  
  ; �L�k�����������ꍇ�A�O���[�v����"G_PRIM"������3DSOLID�č\��
  (if (not #strFLG) (setq #eNEW (KcRemakePrimInGroup #eNEW)))
  
  (CFCmdDefEnd);�ů�ߊ֘A��߂�

  ;;;XDATA�ݒ� G_SYM�͐L�k�����œ��e�ύX�����ׁA�L�k��Đݒ肷��B
  (CFSetXData #eNew "G_SYM"
    (list
      (nth  0 #xdg_sym$)   ;�V���{������
      (nth  1 #xdg_sym$)   ;�R�����g�P
      (nth  2 #xdg_sym$)   ;�R�����g�Q
      (nth  3 #xdg_sym$)   ;�V���{����l�v
      (nth  4 #xdg_sym$)   ;�V���{����l�c
      (nth  5 #xdg_sym$)   ;�V���{����l�g
      (nth  6 #xdg_sym$)   ;�V���{����t������
      (nth  7 #xdg_sym$)   ;���͕��@
      (nth  8 #xdg_sym$)   ;�v�����t���O
      (nth  9 #xdg_sym$)   ;�c�����t���O
      (nth 10 #xdg_sym$)   ;�g�����t���O
      ;�L�k�t���O�v
      (if (equal #Wxd #Wset 0.0001)
        (nth 11 #xdg_sym$)
        #Wset
      )
      ;�L�k�t���O�c
      (if (equal #Dxd #Dset 0.0001)
        (nth 12 #xdg_sym$)
        #Dset
      )
      ;�L�k�t���O�g
      (if (equal #Hxd #Hset 0.0001)
        (nth 13 #xdg_sym$)
        #Hset
      )
      (nth 14 #xdg_sym$)   ;�u���[�N���C�����v
      (nth 15 #xdg_sym$)   ;�u���[�N���C�����c
      (nth 16 #xdg_sym$)   ;�u���[�N���C�����g
    )
  )
 
  ;;;��̂̉�w��Z_00_00_00_01����Z_KUTAI�ɕύX����(�L�k��Ƃ̌�ɍs������)
  (MakeLayer "Z_KUTAI" 7 "CONTINUOUS")
  (setq #ii 0)
  (setq #ss (CFGetSameGroupSS #eNEW))
  (repeat (sslength #ss)
    (setq #eget (entget (ssname #ss #ii)(list"*")))
    (setq #orgLYR$ (assoc 8 #eget))
    ; ��wZ_00_00_00_01��̐}�`, �ڒn�}�` ��w M_* ���Ώ�
    (if (and #orgLYR$ (wcmatch (cdr #orgLYR$) "M_*,Z_00_00_00_01")) (progn
      (setq #emod (subst (cons 8 "Z_KUTAI") #orgLYR$  #eget))
      (setq #emod (subst (cons 62 256)      (assoc 62 #emod) #emod))
      (entmod #emod)
    )); if progn
    (setq #ii (1+ #ii))
  );End repeat

  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : KcRemakePrimInGroup
; <�����T�v>  : �O���[�v����"G_PRIM"������3DSOLID�č\��
; <�߂�l>    : 
; <�쐬>      : 01/02/07 MH
; <���l>      : DXF��ύX����entmod���Ă�SOLOD�}�`�ɔ��f����Ȃ��s��̑΍��p
;*************************************************************************>MOH<
(defun KcRemakePrimInGroup (
  &eEN 
  / 
  #eEN #eg$ #lst #eg$  #en2 #eg2$ #gnam 
  )
  (setq #eEN &eEN)
  (setq #eg$ (entget (cdr (assoc 330 (entget #eEN))))) ; �e�}�ʏ����擾
  (foreach #lst #eg$  ;// ��ٰ�����ް�}�`�̎擾
    (if (= 340 (car #lst)) (progn
      (setq #en2 (cdr #lst))
      (setq #eg2$ (entget #en2 '("G_PRIM")))
      (if (and (/= nil #eg2$) (= (cdr (assoc 0 #eg2$)) "3DSOLID")
               (= (cdr (assoc 8 #eg2$)) "Z_00_00_00_01") )
        (if (CFGetXData #en2 "G_PRIM")
          (progn
            (setq #gnam (SKGetGroupName #en2))
            (setq #en2  (SKS_RemakePrim #en2))
            (command "-group" "A" #gnam #en2 "")
          ); progn
          (progn
            (setq #gnam (SKGetGroupName #en2))
            (command "-group" "A" #gnam #en2 "")
          ); progn
        ) ; if
      ); if 
    )); if progn
  ); foreach
  #eEN
); KcRemakePrimInGroup 

;<HOM>*************************************************************************
; <�֐���>    : kutaihaiti
; <�����T�v>  : ��̔z�u����
; <���@��>    : &ind        ��̐}�`DB�̎w���d�lCD
;             : &Msg#       �w���U��ү����
;             : &Wset &Dset �޲�۸ޓ��͕��E���s
;             : &HaitiMode    2:�J�n�_�w������INSERT����B
;             :             /=2:�J�n�_�w�����͑I��Ă�move����B
;             : &ss         ��̑I��� HaitiMode/=2�̎��̂ݗL��
;             : &ebase      ��}�`    HaitiMode/=2�̎��̂ݗL��
;             : &fname      �}���}�`��  HaitiMode =2�̎��̂ݗL��
; <�߂�l>    : (eObj Angle Wlen Dlen)
;             : �l���s�v�ȗv�f��nil
; <�쐬>      : 2000/11/21 SN
; <���l>      :
;*************************************************************************>MOH<
(defun kutaihaiti(
  &indcd
  &Msg1 &Msg2 &Msg3
  &Wset &Dset
  &HaitiMode &ss &ebase &fname
  /
  #ANGBASE #ANGDIR #LASTPOINT
  #Msg1 #Msg2 #Msg3
  #p1 #p2 #p3 #p4
  #wang #dang
  #wlen #dlen
  #ebase
  #ss
  #ii
  )
  ;(getangle)���g�p����ꍇ�̊J�n�p�x�Ɖ�]�����w��
  ;;;;�����w�����K�v�ȏꍇ�ׂ̈�getangle��BASE��������
  (setq #ANGBASE (getvar "ANGBASE"))
  (setq #ANGDIR  (getvar "ANGDIR" ))
  (setvar "ANGBASE" 0.0)
  (setvar "ANGDIR"  0  )

  ;;;ү���ނɉ��s��:��t��
  (if &Msg1 (setq #Msg1 (strcat "\n" &Msg1 ":")))
  (if &Msg2 (setq #Msg2 (strcat "\n" &Msg2 ":")))
  (if &Msg3 (setq #Msg3 (strcat "\n" &Msg3 ":")))

  (if (= #HaitiMode 2)
    (progn
      ;;;�ŏ��̓_�w��(�SӰ�ދ���)
      (princ #Msg1)
      (MakeLayer "Z_KUTAI" 7 "CONTINUOUS")
      (command ".insert" (strcat CG_MSTDWGPATH &fname) pause 1 1 0)
      (command "_explode" (entlast))
      (setq #ss (ssget "P"))
      (SKMkGroup #ss) ;���������}�`�Q�Ŗ��O�̂Ȃ��O���[�v�쐬
      (command "_layer" "u" "N_*" "")
      (setq #ebase (SearchGroupSym (ssname #ss 0)))
      (setq #p1 (cdr(assoc 10 (entget #ebase))))
      ;(command "_.layer" "on" "M_*" ""); �S���ʉ�w���� 00/12/22 SN DEL ��̂ɂ͖����̂ŕs�v
    )
    (progn
      (setq #ebase &ebase)
      (setq #ss &ss)
      ;;;���݂̊�_
      (setq #p1 (cdr(assoc 10 (entget #ebase))))
      ;;;�ŏ��̓_�w��(�SӰ�ދ���)
      (princ #Msg1)
      (command "._move" #ss "" #p1 pause)
    )
  );End if
  (setq #p1 (cdr(assoc 10 (entget #ebase))))
  ;;;�w���d�l�R�[�h�ɂ�镪��
  (cond
    ;1�_
    ((= &indcd 1)
      (setq #wang 0.0)                               ;��]�p�x0
      (setq #wlen &Wset)                             ;W�l
      (setq #dlen &Dset)                             ;D�l
    )
    ;1�_+�����w��
    ((= &indcd 2)
      (princ #Msg2)                                   ;�w���U��ү����
      (setq #p2 (getCommandRotatePoint #ss #p1 &Wset));��]&��]�p��̓_���擾
      (setq #wang (angle #p1 #p2))                    ;��]�p�x
      (setq #wlen &Wset)                              ;W�l
      (setq #dlen &Dset)                              ;D�l
    )
    ;1�_+W����+D����
    ((= &indcd 3)
      ;�Q�_�ڎ擾����
      (princ #Msg2)                                   ;�w���U��ү����
      (setq #p2 (getCommandRotatePoint #ss #p1 &Wset));��]&��]�p��̓_���擾
      (setq #wang (angle #p1 #p2))                    ;��]�p�x
      (setq #wlen &Wset)                              ;W�l
      ;�R�_�ڎ擾����
      (setq #p3 (getpoint #Msg3))                     ;�R�_�ڎ擾
      (if (not #p3)                                   ;���͉��s�Ȃ�
        (setq #dang (+ #wang pi))                     ;D�����Ȃ�
        (setq #dang (angle #p1 #p3))                  ;D�����p�x
      )
      (setq #dlen &Dset)                              ;D�l
      ;;�����ύX�ɂ��␳
      (if (< #dang #wang)                             ;�����o���ׂ�D������傫������B
        (setq #dang (+ #dang (* 2 pi)))
      )
      (if (> pi (- #dang #wang))(progn                ;D�������޸�ق�W�����ɑ΂���0�`�΂Ȃ�
        (setq #p4 (polar #p1 #wang (/ #wlen 2)))      ;��̂̊�_����W�����ւ̒��_
        (command "._rotate" #ss "" #p4 180)           ;180�x��]
        (setq #wang (+ #wang pi))                     ;180�x���Z
      ));End if-progn
    )
    ((= &indcd 4);2�_�w��
      (setq #p2 (getpoint #p1 #Msg2))                 ;�Q�_�ڎ擾
      (if (not #p2)                                   ;���͉��s�Ȃ�
        (progn
          (setq #wang 0.0)                            ;��]�p�x
          (setq #wlen &Wset)                          ;W�l
        )
        (progn
          (setq #wang (angle #p1 #p2))                ;��]�p�x
          (command "._rotate" #ss "" #p1 (rtd #wang)) ;��]
          (setq #wlen (distance #p1 #p2))             ;W�l
        )
      );End if
      (setq #dlen &Dset)                              ;D�l
    )
    ((= &indcd 5);2�_+D����
      ;�Q�_�ڎ擾����
      (setq #p2 (getpoint #p1 #Msg2))                 ;�Q�_�ڎ擾
      (if (not #p2)                                   ;���͉��s�Ȃ�
        (progn
          (setq #wang 0.0)                            ;0�x
          (setq #wlen &Wset)                          ;W�l
        )
        (progn
          (setq #wang (angle #p1 #p2))                ;��]�p�x
          (command "._rotate" #ss "" #p1 (rtd #wang)) ;��]
          (setq #wlen (distance #p1 #p2))             ;W�l
        )
      );End if
      ;�R�_�ڎ擾����
      (setq #p3 (getpoint #Msg3))                     ;�R�_�ڎ擾
      (if (not #p3)                                   ;���͉��s�Ȃ�
        (setq #dang (+ #wang pi))                     ;D�����Ȃ�
        (setq #dang (angle #p1 #p3))                  ;D�����p�x
      );End if
      (setq #dlen &Dset)                              ;D�l
      ;;�����ύX�ɂ��␳
      (if (< #dang #wang)                             ;�����o���ׂ�D������傫������B
        (setq #dang (+ #dang (* 2 pi)))
      )
      (if (> pi (- #dang #wang))(progn                ;D�������޸�ق�W�����ɑ΂���0�`�΂Ȃ�
        (setq #p4 (polar #p1 #wang (/ #wlen 2)))      ;��̂̊�_����W�����ւ̒��_
        (command "._rotate" #ss "" #p4 180)           ;180�x��]
        (setq #wang (+ #wang pi))                     ;180�x���Z
      ));End if-progn
    )
    ;;;3�_�w��
    ((= &indcd 6)
      ;�Q�_�ڎ擾����
      (setq #p2 (getpoint #p1 #Msg2))                 ;�Q�_�ڎ擾
      (if (not #p2)                                   ;���͉��s�Ȃ�
        (progn
          (setq #wang 0.0)                            ;0�x
          (setq #wlen &Wset)                          ;W�l
        )
        (progn
          (setq #wang (angle #p1 #p2))                ;��]�p�x
          (command "._rotate" #ss "" #p1 (rtd #wang)) ;��]
          (setq #wlen (distance #p1 #p2))             ;W�l
        )
      );End if
      ;�R�_�ڎ擾����
      (setq #p3 (getpoint #p1 #Msg3))                 ;�R�_�ڎ擾
      (if (not #p3)                                   ;���͉��s�Ȃ�
        (progn
          (setq #dang (+ #wang pi))                   ;D�����Ȃ�
          (setq #dlen &Dset)                          ;D�l
        )
        (progn
          (setq #dang (angle #p1 #p3))                ;D�����p�x
          (setq #dlen (distance #p1 #p3))             ;D�l
        )
      )
      ;;�����ύX�ɂ��␳
      (if (< #dang #wang)                             ;�����o���ׂ�D������傫������B
        (setq #dang (+ #dang (* 2 pi)))
      );End if
      (if (> pi (- #dang #wang))(progn                ;D�������޸�ق�W�����ɑ΂���0�`�΂Ȃ�
        (setq #p4 (polar #p1 #wang (/ #wlen 2)))      ;��̂̊�_����W�����ւ̒��_
        (command "._rotate" #ss "" #p4 180)           ;180�x��]
        (setq #wang (+ #wang pi))                     ;180�x���Z
      ));End if-progn
    )
  );End cond
  (setq #ss nil)
  ;(getangle)���g�p����ꍇ�̊J�n�p�x�Ɖ�]�����w��
  ;;;;�����w�����K�v�ȏꍇ�ׂ̈�getangle��BASE��������
  (setvar "ANGBASE" #ANGBASE)
  (setvar "ANGDIR"  #ANGDIR )

  (list #ebase #wang #wlen #dlen)
);kutaihaiti
;<HOM>*************************************************************************
; <�֐���>    : kutaidlg
; <�����T�v>  : ��̃_�C�A���O����
; <���@��>    : &?label �e���͍��ږ��� nil�Ȃ�΂��̍��ڂ͓��͕s�ɂ���B
; <�߂�l>    : ("w�l" "d�l" "h�l" "b�l")
; <�쐬>      : 2000/11/21 SN
; <���l>      :
;*************************************************************************>MOH<
(defun kutaidlg( 
  &Name
  &Wlabel &Dlabel &Hlabel &Blabel
  &Wcd    &Dcd    &Hcd    &Bcd
  &W      &D      &H      &B
  /
  #dcl_id
  #ret
  #cnum #cno
  )

  ;;; ��ި���ޯ������ޯ�
  (defun edit_action (#key #val #why)
    (if (= #why 2)
      ;���͒l���������s���܂��B
      (if (not(CheckStrNum #val))(progn
        (alert "���l����͂��Ă��������B")
        (mode_tile #key 2 )
      ));End if-progn
    );End if
  );End edit_action

  ;;; OK���݂������ꂽ���̊֐�
  (defun #action_accept( / #w_id #d_id #h_id #b_id #cno #wk)
    (setq #cno 0)
    ;W�l���͍���
    (if &Wlabel
      (progn
        (setq #cno (1+ #cno))
        (setq #w_id (get_tile (strcat "EDIT" (itoa #cno))))
      )
      (setq #w_id (rtos &W))
    );End if-progn
    ;D�l���͍���
    (if &Dlabel
      (progn
        (setq #cno (1+ #cno))
        (setq #d_id (get_tile (strcat "EDIT" (itoa #cno))))
      )
      (setq #d_id (rtos &D))
    );End if-progn
    ;H�l���͍���
    (if &Hlabel
      (progn
        (setq #cno (1+ #cno))
        (setq #h_id (get_tile (strcat "EDIT" (itoa #cno))))
      )
      (setq #h_id (rtos &H))
    );End if-progn
    ;B�l���͍���
    (if &Blabel
      (progn
        (setq #cno (1+ #cno))
        (setq #b_id (get_tile (strcat "EDIT" (itoa #cno))))
      )
      (setq #b_id (rtos &B))
    );End if-progn
    (list #w_id #d_id #h_id #b_id)
  );End #action_accept

  ;;; �޲�۸ނ̕\�����ق�����Ύ��s
  (if (or &Wlabel &Dlabel &Hlabel &Blabel)
    (progn
      ;;; �\�����ڐ��𐔂���
      (setq #cnum 0)
      (if &Wlabel (setq #cnum (1+ #cnum)))
      (if &Dlabel (setq #cnum (1+ #cnum)))
      (if &Hlabel (setq #cnum (1+ #cnum)))
      (if &Blabel (setq #cnum (1+ #cnum)))
      ;;; �޲�۸ނ�۰�ނƋN��
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCKUTAI.DCL")))
      (if #dcl_id (progn
        (set_tile "TITLE" &Name)
        ;���ڐ��Ɍ��������_�C�A���O
        (if (new_dialog (strcat "GetKUTAIInfoDlg" (itoa #cnum)) #dcl_id) (progn
          (setq #cno 0)
          ;W�l���͍���
          (if &Wlabel (progn
            (setq #cno (1+ #cno))
            (set_tile (strcat "TEXT" (itoa #cno)) &Wlabel)
            (set_tile (strcat "EDIT" (itoa #cno)) (rtos &W))
            (action_tile (strcat "EDIT" (itoa #cno)) "(edit_action $key $value $reason)")
            (if (< #Wcd 0) (mode_tile (strcat "EDIT" (itoa #cno)) 1))
          ));End if-progn
          ;D�l���͍���
          (if &Dlabel (progn
            (setq #cno (1+ #cno))
            (set_tile (strcat "TEXT" (itoa #cno)) &Dlabel)
            (set_tile (strcat "EDIT" (itoa #cno)) (rtos &D))
            (action_tile (strcat "EDIT" (itoa #cno)) "(edit_action $key $value $reason)")
            (if (< #Dcd 0) (mode_tile (strcat "EDIT" (itoa #cno)) 1))
          ));End if-progn
          ;H�l���͍���
          (if &Hlabel (progn
            (setq #cno (1+ #cno))
            (set_tile (strcat "TEXT" (itoa #cno)) &Hlabel)
            (set_tile (strcat "EDIT" (itoa #cno)) (rtos &H))
            (action_tile (strcat "EDIT" (itoa #cno)) "(edit_action $key $value $reason)")
            (if (< #Hcd 0) (mode_tile (strcat "EDIT" (itoa #cno)) 1))
          ));End if-progn
          ;B�l���͍���
          (if &Blabel (progn
            (setq #cno (1+ #cno))
            (set_tile (strcat "TEXT" (itoa #cno)) &Blabel)
            (set_tile (strcat "EDIT" (itoa #cno)) (rtos &B))
            (action_tile (strcat "EDIT" (itoa #cno)) "(edit_action $key $value $reason)")
            (if (< #Bcd 0) (mode_tile (strcat "EDIT" (itoa #cno)) 1))
          ));End if-progn
          (action_tile "accept" "(setq #ret (#action_accept))(done_dialog)")
          (action_tile "cancel" "(setq #ret nil)(done_dialog)")
          (start_dialog)
        ));End if-progn
        (unload_dialog #dcl_id)
      ));End if-progn
    );End progn
    (setq #ret (list &W &D &H &B))
  );End if
  #ret
);kutaidlg

;<HOM>*************************************************************************
; <�֐���>    : CheckStrNum
; <�����T�v>  : ������"0"�`"9"or"."�̍\�����`�F�b�N����B
; <���@��>    : 
; <�߂�l>    : ������"0"�`"9"or"."�̍\���Ȃ�T
;               ����ȊO�Ȃ�nil��Ԃ��B
; <�쐬>      : 2000/11/28 SN
; <���l>      :
;*************************************************************************>MOH<
(defun CheckStrNum( &str / #ii #chr #retflag #dotflag)
  (setq #dotflag nil)
  (setq #retflag T)
  (setq #ii 1)
  (repeat (strlen &str)
    (setq #chr (substr &str #ii 1))
    (cond
      ((= "." #chr)
        (if #dotflag
          (setq #retflag nil);����"."���o�ςȂ�ُ�
          (setq #dotflag T)  ;    "."���o���Ȃ猟�o�ςɁE�E
        )
      )
      ((not(and (<= "0" #chr) (<= #chr "9")))
        (setq #retflag nil);0�`9�ȊO�Ȃ�ُ�
      )
    )
    (setq #ii (1+ #ii))
  )
  #retflag
)
;<HOM>*************************************************************************
; <�֐���>    : getnumLASTPROMPT
; <�����T�v>  : �V�X�e���ϐ�LASTPROMPT�̍Ō���ɂ��鐔�l���擾
; <���@��>    : �Ȃ�
; <�߂�l>    : ����������΂��̐��l��
;               ����ȊO�Ȃ�nil��Ԃ��B
; <�쐬>      : 2000/11/29 SN
; <���l>      :
;*************************************************************************>MOH<
(defun getnumLASTPROMPT( / #lastprompt #chr #numstr #ii #flag)
  (setq #lastprompt (getvar "LASTPROMPT"))
  (setq #ii (strlen #lastprompt))
  (setq #numstr "")
  (setq #flag T)
  (while #flag
    (setq #chr (substr #lastprompt #ii 1))
    (if (or (= "." #chr) (and (<= "0" #chr ) (<= #chr "9")))
      (setq #numstr (strcat #chr #numstr))
      (setq #flag nil)
    );End if
    (setq #ii (1- #ii))
  );End while
  ;�������������nil��Ԃ�
  (if (= #numstr "")
    nil
    (atof #numstr)
  )
);End getnumLASTPROMPT

;<HOM>*************************************************************************
; <�֐���>    : getCommandRotatePoint
; <�����T�v>  : rotate�R�}���h�����s�A���̉�]�p�x�𓾂�ׂ̓_��Ԃ��B
; <���@��>    : &ss    ��]�����޼ު�Ă̑I���
;             : &pbase ��]��_
;             : &len   �߂�l�_�𓾂�ׂ̉�]��_����̋���
; <�߂�l>    : ��]�p�x�𓾂�ׂ̓_
; <�쐬>      : 2000/11/30 SN
; <���l>      :
;*************************************************************************>MOH<
;;; rotate�R�}���h��̎w���_�𓾂�
(defun getCommandRotatePoint( &ss &pbase &len / #lastpt #retpt #ang #dummyP #dummyObj)
  ;;;���ʓ_�擾�p����а�_���쐬
  (setq #dummyP (polar &pbase 0 &len))
  (if (entmake (list (cons 0 "POINT") (cons 10 #dummyP)))(progn
    (setq #dummyObj (entlast))
    (ssadd #dummyObj &ss)
  ));End if
  ;LASTPOINT�ł͎擾�ł��Ȃ����Ƃ�������
  ;;���݂܂ł̍ŏI�_���擾
  ;(setq #lastpt (getvar "LASTPOINT"))
  ;�I��ē��޼ު�Ẳ�]
  (command "._rotate" &ss "" &pbase pause)
  ;;�ŏI�_���擾
  ;(setq #retpt (getvar "LASTPOINT"))
  ;(if (equal #retpt #lastpt)
    ;rotate��_���ς��Ă��Ȃ���Ίp�x�l����͂��ꂽ�Ɖ���
    (if #dummyObj
      (progn
        ;��а�_������΂��̓_�̍��W���擾
        (setq #retpt (cdr(assoc 10 (entget #dummyObj))))
      )
      (progn
        ;��а�_��������Ίp�x0�̓_��Ԃ�
        (setq #retpt #dummyP)
  ;      ;��а�_���Ȃ���Γ��͊p�x������W���Z�o
  ;      ;������Ă���Ō���̐��������
  ;      (setq #ang (getnumLASTPROMPT))
  ;      (setq #retpt (polar &pbase #ang &len))
      );End progn
    );End if
  ;);End if
  ;;;�_�擾�p��а�_���폜
  (if #dummyObj (progn
    (ssdel #dummyObj &ss)
    (entdel #dummyObj)
  ));End if-progn
  #retpt
);End getCommandRotatePoint