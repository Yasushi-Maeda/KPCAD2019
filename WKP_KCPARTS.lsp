
;; 3/11 �i�Ԑ}�` �����L�[ ���t�����ߍ폜
;;---------------------------------------------------------
;; �R�}���h�ꗗ
;;
;;   1. C:SelectParts       : �ݔ��I���_�C�A���O�\��
;;   2. C:PosParts          : ���ޔz�u
;;   3. C:ChgParts          : ���ޕύX
;;   4. C:BaseParts         : ��A�C�e��
;;   5. C:CntPartsL         : �A���z�u�i���j
;;   6. C:CntPartsR         : �A���z�u�i�E�j
;;   7. C:CntPartsT         : �A���z�u�i��j
;;   8. C:CntPartsD         : �A���z�u�i���j
;;   9. C:BlockParts        : �������ޔz�u
;;  10. C:InsParts          : ���ޑ}��
;;  11. C:InsPartsR         : ���ޑ}���i�E�j
;;  12. C:InsPartsL         : ���ޑ}���i���j
;;  13. C:DelParts          : ���ލ폜
;;  14. C:DelPartsCnt       : ���ލ폜�i�A�����[�h�j
;;  15. C:ConfParts         : ���ފm�F
;;  16. C:ConfWkTop         : ���[�N�g�b�v�m�F
;;  17. C:PtenDsp           : �o�_�̕\��
;;  18. C:StretchCab        : �L���r�l�b�g��L�k
;;---------------------------------------------------------

(setq ST_POS_Y    0)
(setq ST_ANGLE    nil)
(setq ST_BLKSTART nil)

;<HOM>*************************************************************************
; <�֐���>    : SelectParts
; <�����T�v>  : �t���[�v�����ݔ��I���_�C�A���O�̕\��
; <�߂�l>    :
; <�쐬>      : 1999-06-14
; <���l>      :
;*************************************************************************>MOH<
(defun C:SelectParts (
    /
    #XRec$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:SelectParts ////")
  (CFOutStateLog 1 1 " ")

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �O����
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

;;;01/09/03YM@MOD  ;// �R�}���h�̏�����
;;;01/09/03YM@MOD  (StartCmnErr) --- undoB���Ȃ�

  (setq #XRec$ (CFGetXRecord "SERI"))
  (if (= #XRec$ nil)
    (CFAlertErr "��x�����i�ݒ肪����Ă��܂���\n���i�ݒ���s���ĉ�����")
  )
  ;// �f�[�^�x�[�X�ɐڑ�
  (if (= CG_DBSESSION nil)
    (progn
      (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
      (if (= nil (tblsearch "APPID" "G_ARW"))  (regapp "G_ARW")) ;2011/10/04 YM MOV �Ӗ��Ȃ�
      (if (= nil (tblsearch "APPID" "G_LSYM")) (regapp "G_LSYM")) ;2011/10/04 YM MOV �Ӗ��Ȃ�
    )
  )
	;2011/10/04 YM MOV �Ӗ��Ȃ��@�O�ɏo����
	(if (= nil (tblsearch "APPID" "G_ARW"))  (regapp "G_ARW"))
	(if (= nil (tblsearch "APPID" "G_SYM")) (regapp "G_SYM"))
	(if (= nil (tblsearch "APPID" "G_LSYM")) (regapp "G_LSYM"))
	(if (= nil (tblsearch "APPID" "G_OPT")) (regapp "G_OPT"))
	(if (= nil (tblsearch "APPID" "G_TOKU")) (regapp "G_TOKU"))


  ;// ���݂̏��i�����t�@�C���ɏ����o��
  (PC_WriteSeriesInfo #XRec$)

  (MakeLayer "N_Symbol" 4 "CONTINUOUS")
  (MakeLayer "N_BreakD" 6 "CONTINUOUS")
  (MakeLayer "N_BreakW" 6 "CONTINUOUS")
  (MakeLayer "N_BreakH" 6 "CONTINUOUS")

;;;09/21YM  (command "._shademode" "H") ; �B������ (T)PAT-0007 00/04/01 HN ADD

  ;00/10/10 HN S-MOD ���W���[���Ăяo�����@�ύX
  ;@@@(if (= "1" CG_KekomiCode)
  ;@@@  (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 1") 0)
  ;@@@  (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 0") 0)
  ;@@@)
  (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 1") 0)
  ;00/10/10 HN E-MOD ���W���[���Ăяo�����@�ύX

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �㏈��
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  (princ)
)
;C:SelectParts

;<HOM>*************************************************************************
; <�֐���>    : SKY_DivSeikakuCode
; <�����T�v>  : ���iCODE�i���l�j���w��̌��ʒu�̒l���擾����
; <�߂�l>    :
; <�쐬>      : 1999-10-22 �R�c
; <���l>      :
;*************************************************************************>MOH<
(defun SKY_DivSeikakuCode (
    &SeikakuCode    ; ���iCODE�i���l 100�ȏ�999�ȉ��j
    &Keta           ; ���ʒu (1-3)
    /
    #s #s2 #l #n
  )

  (setq #s (itoa &SeikakuCode))
;  (setq #s (strcat "000" #s))
;  (setq #l (strlen #s))
;  (setq #s (substr #s (- #l 2) 3))
  (setq #s2 (substr #s &Keta 1))
  (setq #n (atoi #s2))
  #n
)
;SKY_DivSeikakuCode

;;;<HOM>***********************************************************************
;;; <�֐���>    : SKY_GetItemInfo
;;; <�����T�v>  : �ݔ����t�@�C���ǂݏo��
;;; <�߂�l>    : ��񃊃X�g
;;; <�쐬>      : 2000-02-12 ���� ���L
;;; <���l>      : �O���[�o���ϐ�
;;;                 CG_SYSPATH : �V�X�e�� �t�H���_��
;;;***********************************************************************>MOH<
(defun SKY_GetItemInfo (
  /
  #sFile        ; �t�@�C����
  #sRec$$       ; �t�@�C���Ǎ��݃f�[�^
  #RES$         ; ���ʃ��X�g
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKY_GetItemInfo ////")
  (CFOutStateLog 1 1 " ")

  ; �ݔ����t�@�C�����f�[�^��ǂݍ���
  (setq #sFile (strcat CG_SYSPATH "SELPARTS.CFG"))
  (if (= nil (findfile #sFile))
    (CFAlertErr (strcat "�A�C�e�����t�@�C�� " #sFile " ������܂���."))
  )
  (setq #sRec$$ (ReadIniFile #sFile))

  ; �ǂݍ��񂾃f�[�^����񃊃X�g���쐬����
  (setq #RES$ (list
          (SKY_GetData "02" #sRec$$)  ; 01.�i�Ԗ���
          (SKY_GetData "08" #sRec$$)  ; 02.�}�`ID
    (atoi (SKY_GetData "01" #sRec$$)) ; 03.�K�w�^�C�v
    (atoi (SKY_GetData "04" #sRec$$)) ; 04.�p�r�ԍ�
          (SKY_GetData "03" #sRec$$)  ; 05.L/R�敪
    (atof (SKY_GetData "05" #sRec$$)) ; 06.���@W
    (atof (SKY_GetData "06" #sRec$$)) ; 07.���@D
    (atof (SKY_GetData "07" #sRec$$)) ; 08.���@H
    (atoi (SKY_GetData "10" #sRec$$)) ; 09.���iCODE
          (SKY_GetData "20" #sRec$$)  ; 10.�L�k�t���O
          (SKY_GetData "08" #sRec$$)  ; 11.�W�JID=�}�`ID
          (SKY_GetData "30" #sRec$$)  ; 12.������ or ���[("A" or "D") 2011/07/05 YM ADD
;-- 2011/12/21 A.Satoh Add - S
    (atoi (SKY_GetData "11" #sRec$$)) ; 13.���̓R�[�h
;-- 2011/12/21 A.Satoh Add - E
  ))
  #RES$
)
;;;SKY_GetItemInfo

;;;<HOM>***********************************************************************
;;; <�֐���>    : SKY_GetData
;;; <�����T�v>  : ���X�g���L�[�ɊY�����镶������擾����
;;; <�߂�l>    : �f�[�^������
;;;               "" : �Y���Ȃ�
;;; <�쐬>      : 2000-02-12 ���� ���L
;;; <���l>      :
;;;               (SKY_GetData "2" (("1" "A") ("2" "B") ("3" "C"))) �� "B"
;;;***********************************************************************>MOH<
(defun SKY_GetData (
  &sKey         ; �����L�[
  &sLst$$       ; �f�[�^���X�g
  /
  #sLst$        ; �������X�g
  )

  (setq #sLst$ (assoc &sKey &sLst$$))
  (if (/= nil #sLst$)
    (cadr #sLst$)
    ""
  )
)
;;;SKY_GetData

;<HOM>*************************************************************************
; <�֐���>    : SKY_GetBlockID
; <�����T�v>  :
; <�߂�l>    :
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun SKY_GetBlockID (
    /
    #Result$$ #FName #BlockID #SyouhinType
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKY_GetBlockID ////")
  (CFOutStateLog 1 1 " ")

  (setq #FName (strcat CG_SYSPATH "SELPARTS.CFG"))
  (if (= nil (findfile #FName))
    (CFAlertErr "�A�C�e�����t�@�C��������܂���")
  )
  (setq #Result$$ (ReadIniFile #FName))
  (setq #BlockID  (SKY_GetData "30" #Result$$))      ;�����i��
;  (setq #SyouhinType  (SKY_GetData "31" #Result$$)) ;���i�^�C�v
  (list #BlockID #SyouhinType)
)
;SKY_GetBlockID

;<HOM>*************************************************************************
; <�֐���>    : PosParts
; <�����T�v>  : �ݔ��z�u
; <�߂�l>    :
; <�쐬>      : 1999-06-14 (1999-10-22 �R�c �C��)
; <���l>      :
;*************************************************************************>MOH<
(defun C:PosParts (
  / #fig$
  #SNAPMODE #GRIDMODE #ORTHOMODE #OSMODE ;00/09/06 SN ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:PosParts ////")
  (CFOutStateLog 1 1 " ")

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  ;(CFNoSnapStart) ;00/09/04 SN MOD �z�u�̼��ѕϐ��͓��ꈵ��
  ;// �R�}���h�̏�����
  (StartUndoErr)
  ;;; ��w�����ׂ��ذ�މ��� 00/06/21 YM
;;;  (command "_layer" "T" "*" "") ; 00/06/22 YM
  (CFCmdDefBegin 7);00/09/07 SN MOD �֐���
  ;00/09/06 SN ADD �ů�ߥ��د�ޥ����Ӱ�ނ�ON�OSNAP��OFF����̫�ĂƂ���B
  ;(setq #SNAPMODE  (getvar "SNAPMODE"))
  ;(setq #GRIDMODE  (getvar "GRIDMODE"))
  ;(setq #ORTHOMODE (getvar "ORTHOMODE"))
  ;(setq #OSMODE    (getvar "OSMODE"))
  ;(setvar "SNAPMODE" 1)
  ;(setvar "GRIDMODE" 1)
  ;(setvar "ORTHOMODE" 1)
  ;(setvar "OSMODE"   0)

  (if (not (setq #fig$ (SKY_GetItemInfo)))
    (CFAlertErr "�i�ԏ����擾�ł��܂���ł���"))

;-- 2011/08/03 A.Satoh Add - S
  ; ���O���[�h�ʔz�u�s���ރ`�F�b�N
  (if (= (CheckDoorGradeFree (nth 0 #fig$) CG_DRSeriCode CG_DRColCode) nil)
    (progn
      (CfAlertMsg "�I�������i�Ԃ́A���݂̔��O���[�h�A���F�̂Ƃ��z�u�ł��܂���B")
      (exit)
    )
  )
;-- 2011/08/03 A.Satoh Add - E

  ;2018/07/12 �ؐ�������Ή�
  (setq #fig$ (KcChkWCounterItem$ #fig$))

  (if (not (KcSetUniqueItem "POS" #fig$ nil nil nil)); 01/03/13 MH ADD
    (PcSetItem "POS" nil #fig$ nil nil nil nil)  ;���ꕔ�ވȊO�̕��ނ̏���
  ); if

  (command "_.layer" "F" "Z_01*" "")
  ;2011/09/21 YM ADD-S "M_*"��w�̐F�𔒂ɂ���.���̂�30�Ե�ݼސF�ɂȂ��Ă��܂�
  (command "_.layer" "C" 7 "M_*" "")

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  ;(CFNoSnapEnd) ;00/09/04 SN MOD �z�u�̼��ѕϐ��͓��ꈵ��
  (CFCmdDefFinish);00/09/07 SN MOD �֐���
  ;00/09/06 SN ADD �ů�ߥ��د�ޥ����Ӱ�ނ����ɖ߂��B
  ;(setvar "SNAPMODE"  #SNAPMODE)
  ;(setvar "GRIDMODE"  #GRIDMODE)
  ;(setvar "ORTHOMODE" #ORTHOMODE)
  ;(setvar "OSMODE"    #OSMODE  )

;;; 00/06/20 YM
;;; �\����w�̐ݒ�
;;;  (command "_layer"
;;;    "F"   "*"                ;�S�Ẳ�w���t���[�Y
;;;    "T"   "Z_00*"            ;  Z_00���̃\���b�h��w�̃t���[�Y����
;;;    "T"   "N_*"              ;  N_*�V���{�����_�}�`��w�̃t���[�Y����
;;;    "T"   "M_*"              ;  M_*�ڒn�̈�}�`��w�̉���
;;;    "T"   "0"                ;  "0"��w�̉���
;;;    "ON"  "M_*"              ;  M_*�ڒn�̈�}�`��w�̕\��
;;;    "OFF" "N_B*" ""          ;  N_B*�u���[�N���C���}�`�̔�\��
;;;  )
;;; 00/06/20 YM

  ;04/05/26 YM ADD
  (command "_REGEN")

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

  (setq *error* nil)
  (princ)
)
;C:PosParts

;<HOM>*************************************************************************
; <�֐���>    : KP_GetSekisanF
; <�����T�v>  : �i�Ԗ��̂���i�Ԋ�{.�ώZF����������
; <�߂�l>    : �ώZF=1==>T ����ȊOnil
; <�쐬>      : 01/09/03 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KP_GetSekisanF (
  &HINBAN
  /
  #QRY$ #TSEKISAN
  )
  (setq #tSEKISAN nil)
  (setq #qry$
    (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" &HINBAN
    (list (list "�i�Ԗ���" &HINBAN 'STR))))
  )
  (if (and (/= nil #qry$)(equal 1.0 (nth 10 #qry$) 0.1)) ; 01/09/03 YM MOD �i�Ԋ�{.�ώZF
    (progn ; �ώZF=1������
      (setq #tSEKISAN T)
    )
  );_if
  #tSEKISAN
);KP_GetSekisanF

;<HOM>*************************************************************************
; <�֐���>    : SKY_SetZukeiXData
; <�����T�v>  :
; <�߂�l>    :
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun SKY_SetZukeiXData (
  &fig$
  &en
  &pt
  &ang
  /
  #QRY$ #TSEKISAN ; 01/09/03 YM ADD
  )
  ; 01/09/03 YM ADD-S �����̐ώZF����������
  (setq #tSEKISAN (KP_GetSekisanF (nth 0 &fig$)))
  ; 01/09/03 YM ADD-E �����̐ώZF����������

  (if (= nil &fig$)
    (progn
      (CFAlertMsg "�i�ԏ����擾�ł��܂���ł���")
      (command "_undo" "m")
    )
    (progn
      (SKY_SetXData_ &fig$ &en &pt &ang #tSEKISAN) ; 01/09/03 YM �����ǉ� �ώZF=nil
;;;01/09/03YM@MOD      (SKY_SetXData_ &fig$ &en &pt &ang)
      (command "_layer" "on" "M_*" "")
    )
  )
)
;SKY_SetZukeiXData

;<HOM>*************************************************************************
; <�֐���>    : SKY_SetXData_
; <�����T�v>  : �}�`��񃊃X�g�A��_�A�p�x ����G_LSYM ���Z�b�g����
; <�߂�l>    : �}�`��
; <�쐬>      : 01/04/16 MH �f�ʎw���̗L�������ǉ�
;*************************************************************************>MOH<
(defun SKY_SetXData_ (
  &fig$
  &sym
  &pt
  &ang
  &tSEKISAN ; 01/09/03 YM ADD
  /
  #sec #iskk #UNIT
  )
  (setq #iskk (fix (nth 8 &fig$)))
  (setq #sec 0)   ; �f�t�H���g�Œf�ʎw�� OFF
  (if (or
    (= #iskk CG_SKK_INT_SCA);�V���N�L���r ; 01/08/31 YM MOD 112-->��۰��ى�
    (= #iskk CG_SKK_INT_GCA);�R�����L���r�i���u���I�[�u���j ; 01/08/31 YM MOD 113-->��۰��ى�
;2016/10/20 YM DEL-S
;;;    (= #iskk CG_SKK_INT_CNR);�R�[�i�[�L���r�i�t���A�j ; 01/08/31 YM MOD 115-->��۰��ى�
;;;    (= #iskk 125);�R�[�i�[�L���r�i�E�H�[���j
;2016/10/20 YM DEL-E
    (= #iskk CG_SKK_INT_GAS);�r���g�C���R���� ; 01/08/31 YM MOD 210-->��۰��ى�
    (= #iskk CG_SKK_INT_RNG);�����W�t�[�h ; 01/08/31 YM MOD 320-->��۰��ى�
    (= #iskk CG_SKK_INT_RNG_MT);�����W�t�[�h ; 02/03/27 YM MOD 328-->��۰��ى� ϳ�Č^̰�ޑΉ�
    ; 01/09/06 YM ADD-S
    (= #iskk 710);���ʗp�����
    (= #iskk 717);�����
    ; 01/09/06 YM ADD-E
    (and (= &tSEKISAN nil)(= #iskk CG_SKK_INT_SUI));���� ; 01/08/31 YM MOD 510-->��۰��ى� 01/09/03 YM MOD �ώZF=1�łȂ��Ȃ�
;;;01/09/03YM@MOD  �@(= #iskk CG_SKK_INT_SUI);���� ; 01/08/31 YM MOD 510-->��۰��ى�
    ); or
    (setq #sec 1)
  ); if

  ; 02/07/10 YM ADD-S ����"W"�̐����͒f�ʎx��OFF
  (setq #unit (KPGetUnit)) ; �Ưā����擾
  (if (and (= #iskk CG_SKK_INT_SUI)(= #unit "W"))
    (setq #sec 0)
  );_if

  (CFSetXData &sym "G_LSYM"
    (list
      (cadr &fig$)          ;1 :�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID
      &pt                   ;2 :�}���_          :�z�u��_
      &ang                  ;3 :��]�p�x        :�z�u��]�p�x
      CG_KCode              ;4 :�H��L��        :CG_Kcode
      CG_SeriesCode         ;5 :SERIES�L��    :CG_SeriesCode
      (car &fig$)           ;6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���
      (nth 4 &fig$)         ;7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪
      ""                    ;8 :���}�`ID        :
      (nth 10 &fig$)        ;9 :���J���}�`ID    :
      #iskk                 ;10:���iCODE      :�w�i�Ԋ�{�x.���iCODE
      0                     ;11:�����t���O      :�O�Œ�i�P�ƕ��ށj
      0                     ;12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
      (fix (nth 3 &fig$))   ;13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�
      (fix (nth 7 &fig$))   ;14:���@�g          :�w�i�Ԑ}�`�x.���@�g
      #sec                  ;15:�f�ʎw���̗L��  :�w�v���\���x.�f�ʗL�� 00/07/18 SN MOD
      (if (nth 11 &fig$)    ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
        (nth 11 &fig$)
        ;else
        "A" ;�s���̏ꍇ�ͷ���"A"
      );_if
    )
  )
  (KcSetDanmenSymXRec &sym);  Xrecord ��"DANMENSYM" �ύX 01/04/24 MH
  &sym
);SKY_SetXData_

;<HOM>*************************************************************************
; <�֐���>    : KPGetUnit
; <�����T�v>  : �ƯċL���擾
; <�߂�l>    : �ƯċL��
; <�쐬>      : 02/07/10 YM
; <���l>      : �ƯċL��=K(����),D(�޲�ݸ�),W(����)
;*************************************************************************>MOH<
(defun KPGetUnit (
  /
  #QRY$ #UNIT
  )
  (setq #qry$
    (CFGetDBSQLRecChk CG_CDBSESSION "SERIES" (list (list "SERIES�L��" CG_SeriesCode 'STR)
                                                     (list "SERIES����" CG_SeriesDB   'STR))))

;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #qry$)
;;;		;�ذ�ޕ�DB,����DB�Đڑ�
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E

  (if (= nil #qry$)
    (CFAlertErr "SERIES�e�[�u����������܂���")
  )
  (setq #unit (nth 3 #qry$)) ; �ƯċL��
);KPGetUnit

;<HOM>*************************************************************************
; <�֐���>    : C:ChgParts
; <�����T�v>  : �ݔ��ύX
; <�߂�l>    :
; <�쐬>      : 1999-06-14 (1999-10-25 �R�c �C��)
; <���l>      :
;*************************************************************************>MOH<
(defun C:ChgParts (
  /
  #eCH #en #ps #ss #pt #ang #fig$ #enFL$ #xd$ #old_W #old_D #old_H #BaseFlag
  #eNX #eNEXT$ #selQLY$ #fMOVE
  )

  ;// �R�}���h�̏����� ChgParts��Undo����������Ȃ̂œƎ���Err�����ݸނ��s��
  (defun ChgPartsUndoErr( &msg )
    (command "_undo" "b")
    (CFCmdDefFinish)
    (setq *error* nil)
    (princ)
  )
  (setq *error* ChgPartsUndoErr)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")
  (CFCmdDefBegin 6);00/09/07 SN E-ADD

  (setq CG_BASESYM (CFGetBaseSymXRec))
  (if (not (setq #fig$ (SKY_GetItemInfo))) (progn
    (CFAlertMsg "�i�ԏ����擾�ł��܂���ł���")
    (command "_undo" "m") (exit)
  )); if progn

;-- 2011/08/03 A.Satoh Add - S
  ; ���O���[�h�ʔz�u�s���ރ`�F�b�N
  (if (= (CheckDoorGradeFree (nth 0 #fig$) CG_DRSeriCode CG_DRColCode) nil)
    (progn
      (CfAlertMsg "�I�������i�Ԃ́A���݂̔��O���[�h�A���F�̂Ƃ��z�u�ł��܂���B")
      (exit)
    )
  )
;-- 2011/08/03 A.Satoh Add - E

  (setq #eCH T)
  (while #eCH
    (CFCmdDefEnd)        ;00/09/07 SN ADD ���ߊ֘A��U�߂�
    (command "_undo" "m");00/09/07 SN ADD ��񖈂�Undo
    (CFCmdDefStart 6)    ;00/09/07 SN ADD ���ߊ֘A�ēx�ݒ�
    (setq #eCH (car (entsel "\n���ւ���A�C�e����I��: ")));00/06/27 SN MOD ү���ޕύX
    (if (/= #eCH nil)
      (progn
        ; G_FILR�A�C�e���ύX�s��
        (if (setq #enFL$ (CFGetXData #eCH "G_FILR")) (progn
          (CFAlertErr (strcat (PcGetPrintName (car #enFL$)) "�͓���ւ��ł��܂���"))
        )); if progn
        (setq #eCH (SearchGroupSym #eCH))
        (setq #BaseFlag (equal #eCH CG_BASESYM))  ;��A�C�e���̕ύX�\
        (if (= #eCH nil)
          (progn
            (CFYesDialog "�ύX����A�C�e�����ނ�I�����ĉ����� "
                         "�m�F" (logior MB_OK MB_ICONEXCLAMATION))
            (setq #eCH T)
          )
          (progn
            ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
            ;CHGӰ�ނ�PcSetItem���Ăяo���Γ�����Undo"b"���ĕԂ��Ă���B
            (CFCmdDefEnd)        ;00/09/07 SN ADD ���ߊ֘A��U�߂�
            (command "_undo" "m")
            (CFCmdDefStart 6)    ;00/09/07 SN ADD ���ߊ֘A�ēx�ݒ�

            (setq #xd$ (CFGetXData #eCH "G_LSYM"))
            (setq #pt (cdr (assoc 10 (entget #eCH))))
            (setq #ang (nth 2 #xd$))

            ;2018/07/12 �ؐ�������Ή�
            (setq #fig$ (KcChkWCounterItem$ #fig$))

            (if (not (setq #en (KcSetUniqueItem "CHG" #fig$ nil nil #eCH)))
              ;CHGӰ�ނ�PcSetItem���Ăяo���Γ�����Undo"b"���ĕԂ��Ă���B
              (setq #en (PcSetItem "CHG" nil #FIG$ #pt #ang nil #eCH))
            ); if
            (setq #eCH nil) ; ���ֺ���ނ͌J��Ԃ��Ȃ� 01/04/18 YM ADD
          )
        );_if
      )
    );_if
  );while

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

  (CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  (princ)
)
;C:ChgParts

;<HOM>*************************************************************************
; <�֐���>    : BaseParts
; <�����T�v>  : ��A�C�e��
; <�߂�l>    :
; <�쐬>      : 1999-06-14 (1999-10-22 �R�c ���iCODE���� �C�� / 1999-12-01 �C��)
; <���l>      :
;*************************************************************************>MOH<
(defun C:BaseParts (
    /
    #en #ps #xd$ #pt #Seikaku_1
  )
  ;// �R�}���h�̏�����
  ;(StartCmnErr);00/09/07 SN MOD
  (StartUndoErr);00/09/07 SN MOD Undo�ɕύX
  (CFCmdDefBegin 6);00/09/07 SN ADD
  (setq #en T)
  (while #en
    (setq #en (car (entsel "\n��Ƃ���A�C�e���܂��͉��������A�C�e����I��: ")));00/07/03 SN MOD
    ;(setq #en (car (entsel "\n��A�C�e���Ƃ��镔�ނ�I��: ")));00/07/03 SN MOD
    (if (/= #en nil)
      (progn
        (setq #en (SearchGroupSym #en))
        (if (= #en nil)
          (progn
            (CFAlertMsg "��Ƃ���A�C�e���܂��͉��������A�C�e����I�����ĉ����� ");00/07/03 SN MOD
            ;(CFAlertMsg "��A�C�e���Ƃ��镔�ނ�I�����ĉ����� ");00/07/03 SN MOD
            (setq #en T)
          )
          (progn ; ����ق���
;;;00/04/20 DEL MH ����т̐������O��
;;;            (setq #Seikaku_1 (SKY_DivSeikakuCode (nth 9 (CFGetXData #en "G_LSYM")) 1))
;;;            (if (/= nil (member #Seikaku_1 (list CG_SKK_ONE_GAS CG_SKK_ONE_SNK CG_SKK_ONE_WTR CG_SKK_ONE_CNT)))
;;;              (CFAlertMsg "���̕��ނ͊�A�C�e���ɂł��܂���")
;;;              (progn

                (if (CfGetXData #en "G_KUTAI") ; 01/09/25 YM MOD
;;;01/09/25YM@DEL               (if (or (CfGetXData #en "G_KUTAI")  ; ��̂����� 01/02/20 YM
;;;01/09/25YM@DEL                       (CfGetXData #en "G_WAC")) ; 01/09/18 YM ADD �L�p�x����
                  (progn
                    (setq #en T)
                    (CFAlertMsg "���̕��ނ͊�A�C�e���ɂł��܂���") ; 01/02/20 YM
                  )
                  (progn

                    (command "_undo" "m")
                    (ResetBaseSym)
                    ;;;00/06/16 SN S-MOD
                    ;;;�I���ςݕ��ނ���A�C�e���Ƃ��ꂽ�ꍇ�͊�A�C�e���L�����Z��
                    (if (and (/= CG_BASESYM nil)
                             (= (cdr (assoc 5 (entget CG_BASESYM)))
                                (cdr (assoc 5 (entget #en)))))
                      (progn
                        (if (CFYesNoDialog "���̊�A�C�e�����L�����Z�����Ă�낵���ł����H");00/07/03 SN MOD
                        ;(if (CFYesNoDialog "���̊�A�C�e�����ނ��L�����Z�����Ă�낵���ł����H");00/07/03 SN MOD
                          (progn
                            (command "_undo" "b") ;00/09/07 SN ADD
                            (ResetBaseSym)        ;00/09/07 SN ADD
                            (CFSetXRecord "BASESYM" nil)
                            (setq CG_BASESYM nil)
                            (setq #en nil)
                          )
                          (command "_undo" "b")
                        )
                      )
                      (progn
                        ; 00/06/16 SN S-Original Program
                        (GroupInSolidChgCol #en CG_BaseSymCol)
                        (if (CFYesNoDialog "���̃A�C�e������Ƃ��Ă�낵���ł����H");00/07/03 SN MOD
                        ;(if (CFYesNoDialog "���̕��ނ���A�C�e���Ƃ��Ă�낵���ł����H");00/07/03 SN MOD
                          (progn
                            (command "_undo" "b") ;00/09/07 SN ADD
                            (ResetBaseSym)        ;00/09/07 SN ADD
                            (GroupInSolidChgCol #en CG_BaseSymCol);00/09/07 SN ADD
                            (CFSetBaseSymXRec #en)
                            (setq #en nil)
                          )
                          (command "_undo" "b")
                        )
                        ; 00/06/16 SN E-Original Program
                      )
                    );_if

                  )
                );_if  01/02/20 YM

;;;00/06/16 SN E-MOD
;;;              )
;;;            )
          )
        )
      )
    );_if
  );while

  (CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  (princ)
)
;C:BaseParts

(defun C:CntPartsR () (CntParts "R"))
(defun C:CntPartsL () (CntParts "L"))
(defun C:CntPartsT () (CntParts "T"))
(defun C:CntPartsD () (CntParts "D"))

;06/04/26 YM ADD �A���O�z�u
(defun C:CntPartsF () (CntParts "F"))

;<HOM>*************************************************************************
; <�֐���>    : CntParts
; <�����T�v>  : �A���z�u
; <�߂�l>    :
; <�쐬>      : 1999-06-14 (1999-10-25 �R�c �C��)
; <���l>      :
;*************************************************************************>MOH<
(defun CntParts (
  &type           ;����  "L" "R" "T" "D"
  /
  #xd$ #fig$ #w #d #h #w2 #d2 #h2 #P&A$ #pt #ang
  #sCd        ; ���iCODE
  )
;;;01/09/03YM@MOD  ;// �R�}���h�̏�����
;;;01/09/03YM@MOD  (StartCmnErr)

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �O����
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  ;;; ��w�����ׂ��ذ�މ��� 00/06/21 YM
;;;  (command "_layer" "T" "*" "") ; 00/06/22 YM

  (setq CG_BASESYM (CFGetBaseSymXRec))
  (if (not CG_BASESYM)
    (CFAlertMsg "��A�C�e��������܂���.��A�C�e����I�����ĉ�����"))
  (setq #xd$ (CFGetXData CG_BASESYM "G_SYM"))
  (setq #pt (cdr (assoc 10 (entget CG_BASESYM))))
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #h (nth 5 #xd$))

  (setq #xd$ (CFGetXData CG_BASESYM "G_LSYM"))
  (if (setq #fig$ (SKY_GetItemInfo))
    (progn
      (setq #w2  (fix (nth 5 #fig$)))
      (setq #d2  (fix (nth 6 #fig$)))
      (setq #h2  (fix (nth 7 #fig$)))
      (setq #sCd (fix (nth 8 #fig$))) ; 01/06/17 HN ADD
    )
    (CFAlertErr "�i�ԏ����擾�ł��܂���ł���")
  );_if

;-- 2011/08/03 A.Satoh Add - S
  ; ���O���[�h�ʔz�u�s���ރ`�F�b�N
  (if (= (CheckDoorGradeFree (nth 0 #fig$) CG_DRSeriCode CG_DRColCode) nil)
    (progn
      (CfAlertMsg "�I�������i�Ԃ́A���݂̔��O���[�h�A���F�̂Ƃ��z�u�ł��܂���B")
      (exit)
    )
  )
;-- 2011/08/03 A.Satoh Add - E

  ;// �}����_�Ƒ}���p�x�����߂�  00/07/17 MH �֐���
  ; 01/06/17 HN MOD �z�u�A�C�e���̐��iCODE��ǉ�
  ;@MOD@(setq #P&A$
  ;@MOD@  (PcArrangeInsPnt #pt &type #fig$ CG_BASESYM #xd$ (list #w #d #h) (list #w2 #d2 #h2)))
  (setq #P&A$
    (PcArrangeInsPnt #pt &type #fig$ CG_BASESYM #xd$ (list #w #d #h) (list #w2 #d2 #h2) #sCd))
  (setq #pt  (car  #P&A$))
  (setq #ang (cadr #P&A$))

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart) ; 00/02/07 @YM@ �ǉ�

  ;2018/07/12 �ؐ�������Ή�
  (setq #fig$ (KcChkWCounterItem$ #fig$))

  (if (not (KcSetUniqueItem "CNT" #fig$ CG_BASESYM &type nil))
    ;;;���ꕔ�ވȊO�̕��ނ̏���
    (PcSetItem "CNT" &type #fig$ #pt #ang CG_BASESYM nil)
  ); end of if

  (CFNoSnapEnd)  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�

;;; 00/06/20 YM
;;; �\����w�̐ݒ�
;;;  (command "_layer"
;;;    "F"   "*"                ;�S�Ẳ�w���t���[�Y
;;;    "T"   "Z_00*"            ;  Z_00���̃\���b�h��w�̃t���[�Y����
;;;    "T"   "N_*"              ;  N_*�V���{�����_�}�`��w�̃t���[�Y����
;;;    "T"   "M_*"              ;  M_*�ڒn�̈�}�`��w�̉���
;;;    "T"   "0"                ;  "0"��w�̉���
;;;    "ON"  "M_*"              ;  M_*�ڒn�̈�}�`��w�̕\��
;;;    "OFF" "N_B*" ""          ;  N_B*�u���[�N���C���}�`�̔�\��
;;;  )
;;; 00/06/20 YM

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

  (setq *error* nil)
  (princ)
);CntParts

;<HOM>*************************************************************************
; <�֐���>    : PcArrangeInsPnt
; <�����T�v>  : �A�����[�h�̕����ő}����_���ړ�������
; <�߂�l>    : �ړ���������̓_���W �� �}���p�x�̃��X�g
; <�쐬>      : 00/07/17 MH
; <����>      : 01/06/17 HN �A���R�����z�u�C��
; <���l>      : �R�����ȊO��"T"��"D"�� ��A�C�e����H�����t���O�Ƒ}���}�`��
;             : H�����t���O�ɂ��}�`�ړ��ŏ������邽�ߑ}���_�̈ړ��͂Ȃ��B
;*************************************************************************>MOH<
(defun PcArrangeInsPnt (
  &dPT        ; ��_
  &sDIR       ; ���� "L" "R" "T" "D"
  &FIG$       ; �}������}�`�̃��X�g
  &eBASESYM   ; ��ƂȂ�}�`
  &XL$        ; ��}�`��LSYM
  &bsWDH$     ; ��}�`��WDH���X�g
  &insWDH$    ; �V�ݐ}�`��WDH���X�g
  &sCd        ; �V�ݐ}�`�̐��iCODE  ;01/06/17 HN ADD
  /
  #dPT #fANG #iSKK #chk4P$ #i #ss #en #eg #dSP #dEP
#ANG1 #ANG2 #BASE #P1 #P2 #P3 #P4 #P5 #P6 #PMEN2 #PT$ ; 01/09/25 YM ADD
#DIST #HEIGHT #LAST #ZZ
  )

        ;--------------------------------------------------------------------
        (defun ##DelLastPT (
          &pt$ ; �_��
          /

          )
          (setq #st (nth 0 &pt$))
          (setq #ed (last  &pt$))
          (if (< (distance #st #ed) 0.1)
            (setq #ret$ (reverse (cdr (reverse &pt$)))) ; �n�_=�I�_�Ȃ�I�_�폜
            (setq #ret$ &pt$)
          );_if
          #ret$
        )
        ;--------------------------------------------------------------------
  (setq #dPT &dPT)
  ; 02/03/27 YM ADD ��_Z���W����׽
  (setq #ZZ (nth 2 #dPT))

  (setq #fANG (nth 2 &XL$)) ;��}�`�̊p�x(�����l)
  (setq #iSKK (nth 9 &XL$)) ;��}�`�̐��iCODE
  (cond
    ((= &sDIR "L")
      ;// �R�[�i�[�L���r����̏ꍇ�͓��ʏ���
      (if (= (SKY_DivSeikakuCode #iSKK 3) CG_SKK_THR_CNR)
        (progn

          ; 01/09/25 YM �L�p�x��Ű���ޑΉ� MOD-S
          ; ��Ű����
          ; p1          p2
          ; +-----------+
          ; |           |
          ; |           |
          ; |     +-----+
          ; |     |p4   p3
          ; |     |
          ; +-----+
          ; p6    p5
          (setq #pmen2 (PKGetPMEN_NO &eBASESYM 2))   ; PMEN2
          (setq #pt$ (GetLWPolyLinePt #pmen2))  ; PMEN2 �O�`�̈�
          ; �n�_=�I�_�̏ꍇ�I�_���������� 02/02/14 YM ADD
          (setq #pt$ (##DelLastPT #pt$))

          ; 5�p�`�Ή� 02/02/14 YM ADD
          (if (= 5 (length #pt$))
            (progn
              (setq #base (cdr (assoc 10 (entget &eBASESYM)))); ��Ű��_���W
            )
            (progn ; �]��ۼޯ�
              (setq #base (PKGetBaseL6 #pt$))       ; ��Ű��_�����߂�(����ق����Ȃ�)
            )
          );_if

          (setq #pt$ (GetPtSeries #base #pt$)); #base ��擪�Ɏ��v����
          (setq #p1 (nth 0 #pt$))
          (setq #p2 (nth 1 #pt$))
          (setq #p3 (nth 2 #pt$))
          (setq #p4 (nth 3 #pt$))
          (setq #p5 (nth 4 #pt$))

;;;02/02/14YM@MOD         (setq #p6 (nth 5 #pt$))
          (setq #last (last #pt$)) ; 02/02/14 YM ADD

          (setq #ang1 (angle #p1 #p2))

;;;02/02/14YM@MOD         (setq #ang2 (angle #p1 #p6))
          (setq #ang2 (angle #p1 #last)) ; 02/02/14 YM ADD

          (setq #ang1 (Angle0to360 #ang1)) ; 0�`360�x�̒l�ɂ���
          (setq #ang2 (Angle0to360 #ang2)) ; 0�`360�x�̒l�ɂ���

          (setq #fANG (+ #fANG (- (- #ang2 #ang1)(* 2 PI))))
          ; 01/09/25 YM �L�p�x��Ű���ޑΉ� MOD-E

;;;01/09/25YM@DEL          (setq #fANG (+ #fANG (DTR -90)))
          (setq #dPT (polar #dPT #fANG (+ (cadr &bsWDH$) (car &insWDH$))))
          (setq #fANG (+ #fANG (DTR 180)))
        )
        ; �R�[�i�[�L���r�ȊO�̃A�C�e��
        (setq #dPT (polar #dPT (+ pi #fANG) (car &insWDH$)))
      )
    ); "L"

    ((= &sDIR "R")
      ;// �R�[�i�[�L���r���}������A�C�e���̏ꍇ�͓��ʏ���
      (if (= (SKY_DivSeikakuCode (fix (nth 8 &FIG$)) 3) CG_SKK_THR_CNR)
        (progn
          (setq #dPT (polar #dPT #fANG (+ (car &bsWDH$) (cadr &insWDH$))))
          (setq #fANG (- #fANG (DTR 90)))
        )
        ; �R�[�i�[�L���r�ȊO�̃A�C�e��
        (setq #dPT (polar #dPT #fANG (car &bsWDH$)))
      )
    ); "R"


    ;06/04/26 YM ADD-S �A���O�z�u
    ((= &sDIR "F")
      (setq #dPT (polar #dPT (- #fANG (/ pi 2)) (nth 1 &bsWDH$)))

      ;06/08/14 YM MOD-S ү���ޒǉ�
      (if (= (SKY_DivSeikakuCode (nth 8 &FIG$) 2) CG_SKK_TWO_UPP)
        (setq #height CG_UpCabHeight)
        (setq #height 0)
      );_if
      (setq #dist (getdist (strcat "\n�ݒu����<" (itoa #height) ">: ")))
      (if (=  #dist nil) (setq #dist #height))
      (setq #dPT (list (car #dPT) (cadr #dPT) #dist))
      ;06/08/14 YM MOD-E ү���ޒǉ�

    ); "R"


; �R�[�i�[�R�����Ή� 01/08/22 YM MOD-S ---------------------------------------------------------
    ; �R������A����z�u�̂Ƃ�PLIN�����݂����PLIN���킹,�Ȃ���Ί�_���킹.(���iCODE�݂͂Ȃ�)
    ((and (= &sDIR "T") (= CG_SKK_INT_GAS &sCd)); �A����z�u�ŏオ"210"��ۂ̂Ƃ� ; 01/08/31 YM MOD 210-->��۰��ى�
      (setq #en (PKGetPLIN_NO &eBASESYM 2)) ; PLIN2�}�`(LINE)
      (if #en
        (progn
          (setq #dSP (cdr (assoc 10 (entget #en))))
          (setq #dEP (cdr (assoc 11 (entget #en))))
          (setq #fANG (angle #dSP #dEP)) ; PLIN�p�x
          (setq #dPT (list (car #dSP) (cadr #dSP) (caddr &dPT))) ; 02/03/28 YM MOD ��֑Ή�
        )
        (setq #dPT nil)
      );_if

      (if (not #dPT)
        (setq #dPT &dPT) ; �R�������t������������Ȃ��Ƃ��͊�L���r�̊�_�Ƃ���(�G���[�Ƃ��Ȃ�) 01/07/06 YM MOD
      );_if
    ); "T" �ŃK�X�R����������
; �R�[�i�[�R�����Ή� 01/08/22 YM MOD-E ---------------------------------------------------------

; �R�[�i�[�R�����Ή� 01/08/22 YM DEL-S ---------------------------------------------------------
;;;01/08/22YM@    ;// "T"�K�X�R�����͎��t�����ɍ��킹��
;;;01/08/22YM@    ; 01/06/17 HN MOD �z�u�V���{�����R�������ǂ��������ǉ�
;;;01/08/22YM@    ;@@@((and (= &sDIR "T") (= (SKY_DivSeikakuCode #iSKK 3) CG_SKK_THR_GAS))
;;;01/08/22YM@    ((and (= &sDIR "T") (= (SKY_DivSeikakuCode #iSKK 3) CG_SKK_THR_GAS) (= CG_SKK_INT_GAS &sCd)) ; 01/08/31 YM MOD 210-->��۰��ى�
;;;01/08/22YM@; �A����z�u�ŉ���"113"��۷��ޏオ"210"��ۂ̂Ƃ�
;;;01/08/22YM@
;;;01/08/22YM@      ; 00/04/26 MH �̈攻��Ɏg����A�C�e��4�_�i10cm�L�������j
;;;01/08/22YM@      (setq #chk4P$ (PcGetItem4P$ &eBASESYM 100 100 100 100))
;;;01/08/22YM@      (setq #ss (ssget "X" '((-3 ("G_PLIN"))))) ; <---�ύX���������A���z�u�Ŏ��_���^�ォ��ɂȂ邪���Ȃ̂ł��̂܂�
;;;01/08/22YM@      (if (/= #ss nil)
;;;01/08/22YM@        (progn
;;;01/08/22YM@          (setq #i 0)
;;;01/08/22YM@          (setq #dPT nil)
;;;01/08/22YM@          (repeat (sslength #ss)
;;;01/08/22YM@            (setq #en (ssname #ss #i))
;;;01/08/22YM@            (setq #eg (entget #en))
;;;01/08/22YM@            (if (and (= #dPT nil)
;;;01/08/22YM@                     (= (cdr (assoc 0 #eg)) "LINE")
;;;01/08/22YM@                     (= 2 (car (CFGetXData #en "G_PLIN"))))
;;;01/08/22YM@              (progn
;;;01/08/22YM@                ; 00/11/13 MH MOD  �A���z�u-��ŃR������t����ɃR������z�u����
;;;01/08/22YM@                ; �ꍇ�A�R�������t������̎n�_���R�����̊�_�Ƃ��A
;;;01/08/22YM@                ; �n�_���I�_��z�u�����Ƃ��Ĕz�u�p�x�����߂�
;;;01/08/22YM@                (setq #dSP (cdr (assoc 10 (entget #en))))
;;;01/08/22YM@                (setq #dEP (cdr (assoc 11 (entget #en))))
;;;01/08/22YM@                ;;; 00/04/26 MH MOD �̈�O�ł���� nil ���
;;;01/08/22YM@                (if (JudgeNaigai #dSP (append #chk4P$ (list (car #chk4P$))))
;;;01/08/22YM@                  (progn
;;;01/08/22YM@                    (setq #fANG (angle #dSP #dEP))
;;;01/08/22YM@                    (setq #dPT (list (car #dSP) (cadr #dSP) 0))
;;;01/08/22YM@  ;;;01/07/02YM@                  (setq #dPT (list (car #dSP) (cadr #dSP) (caddr &bsWDH$)))
;;;01/08/22YM@                  ); progn
;;;01/08/22YM@                  (setq #dPT nil)
;;;01/08/22YM@                );if
;;;01/08/22YM@              )
;;;01/08/22YM@            ); if
;;;01/08/22YM@            (setq #i (1+ #i))
;;;01/08/22YM@          ); repeat
;;;01/08/22YM@        )
;;;01/08/22YM@      );_if progn
;;;01/08/22YM@      (if (not #dPT)
;;;01/08/22YM@        (progn
;;;01/08/22YM@          (setq #dPT &dPT) ; �R�������t������������Ȃ��Ƃ��͊�L���r�̊�_�Ƃ���(�G���[�Ƃ��Ȃ�) 01/07/06 YM MOD
;;;01/08/22YM@;;;01/07/06YM@          (CFAlertMsg
;;;01/08/22YM@;;;01/07/06YM@            "�ݒu�͈͂ɃR�������t������������Ȃ�����\n \n�R�����}����_�����܂�܂���")
;;;01/08/22YM@;;;01/07/06YM@          (princ)
;;;01/08/22YM@;;;01/07/06YM@          (*error*)
;;;01/08/22YM@        )
;;;01/08/22YM@      );if progn
;;;01/08/22YM@      (if (> 150 (distance (list 0 0) (list (car #dPT) (cadr #dPT))))
;;;01/08/22YM@        (progn
;;;01/08/22YM@          (if (CFPosOKDialog "�K�X�R�����͕ǂ���150mm �ȏ㗣���K�v������܂��B")
;;;01/08/22YM@            (princ)
;;;01/08/22YM@            (*error*)
;;;01/08/22YM@          )
;;;01/08/22YM@        )
;;;01/08/22YM@      );_if
;;;01/08/22YM@    ); "T" �ŃK�X�R����������
;;;01/08/22YM@
; �R�[�i�[�R�����Ή� 01/08/22 YM DEL-S ---------------------------------------------------------

    (t nil)
  ); cond

  ;@DEBUG@(princ "\nPcArrangeInsPnt")
  ;@DEBUG@(princ "\n#dPT: " )(princ #dPT )
  ;@DEBUG@(princ "\n#fANG: ")(princ #fANG)
  (list #dPT #fANG)
); PcArrangeInsPnt

;<HOM>*************************************************************************
; <�֐���>    : SKY_Stretch_Parts
; <�����T�v>  : �L�k
; <�߂�l>    :
; <�쐬>      : 1999-11-08 �R�c
; <���l>      :
;*************************************************************************>MOH<
(defun SKY_Stretch_Parts (
  &sym      ;�V���{���}�`
  &val_w    ;���@�v
  &val_d    ;���@�c
  &val_h    ;���@�g
  /
  #fANG #dPT #ORG$ #rtFLG #TMP$ #i #A #OS #SM
  #xd$ #xld$ #val_w #val_d #val_h #MSG #QLY$ #VIEWEN
#LIST$ #NCODE #QLY$$ ; 03/03/28 YM ADD
  )
  ; Win98�p�x180,270�Őݒu�ʒu�������s��ւ̑Ώ�
  (setq #os (getvar "OSMODE"))   ;O�X�i�b�v
  (setq #sm (getvar "SNAPMODE")) ;�X�i�b�v
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)

  (setq #viewEn (MakeWorkView)) ; 00/02/29 YM ADD
  (if (= nil &sym)
    (CFAlertMsg "�A�C�e���ł͂���܂���")
    (progn
      ;// �O���[�v�̐}�`��F�ւ�
      (if (or CG_TOKU CG_WAC) ; 01/09/18 YM MOD
        nil ; �������޺���ޒ�
        (progn
          (command "_undo" "m")
          (GroupInSolidChgCol &sym CG_InfoSymCol)
        )
      );_if

      (setq #xd$ (CFGetXData &sym "G_SYM"))
      (setq #xld$ (CFGetXData &sym "G_LSYM"))

      ; 03/03/28 YM MOD-S �i�Ԋ�{����
      (setq #List$ (list (list "�i�Ԗ���" (nth 5 #xld$) 'STR)))
      (setq #QLY$$ (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{" #List$))
      (if (and #QLY$$ (= 1 (length #QLY$$)))
        (setq #nCODE (nth 7 (car #QLY$$)))
        (setq #nCODE -1) ; ���̓R�[�h
      );_if
      ; 03/03/28 YM MOD-E �i�Ԋ�{����

      ;;; 00/06/20 MH MOD �L�k��r�̑Ώےl�� DB �� G_SYM �ɕ��򔻒f
      (cond
        ; SelParts.cfg ���L��A�����̓R�[�h�� 0 �ȏ�Ȃ碕i�Ԑ}�`���WDH�l�ō������o
        ((and (not KEKOMI_COM)(not CG_TOKU) ; ��АL�k,�������޺���ނłȂ�
              (findfile (strcat CG_SYSPATH "SELPARTS.CFG"))
              (< 0 #nCODE)) ; 03/03/28 YM MOD
;;; 03/03/28 YM "SELPARTS.CFG"�����݂��āA��АL�k����װ���]������ݸ���i�Ԋ�{�ɂȂ��̂�
;;;              �����I�����Ă��܂��̂�PcGetPartQLY$�͎g���Ȃ�
;;;              (< 0 (nth 11 (PcGetPartQLY$  "�i�Ԋ�{" (nth 5 #xld$) nil nil))))

          (setq #QLY$ (PcGetPartQLY$  "�i�Ԑ}�`" (nth 5 #xld$) (nth 6 #xld$) (nth 12 #xld$)))
;-- 2011/09/13 A.Satoh Mod - S
;          (setq #val_w (if (/= (nth 4 #QLY$) &val_w) &val_w 0))
;          (setq #val_d (if (/= (nth 5 #QLY$) &val_d) &val_d 0))
;          (setq #val_h (if (/= (nth 6 #QLY$) &val_h) &val_h 0))
          (setq #val_w (if (/= (nth 3 #QLY$) &val_w) &val_w 0))
          (setq #val_d (if (/= (nth 4 #QLY$) &val_d) &val_d 0))
          (setq #val_h (if (/= (nth 5 #QLY$) &val_h) &val_h 0))
;-- 2011/09/13 A.Satoh Mod - E
        )
        ;����ȊO�͑Ώې}�`��G_SYM��WDH�l�ō������o
        (t (setq #val_w (if (/= (nth 3 #xd$) &val_w) &val_w 0))
           (setq #val_d (if (/= (nth 4 #xd$) &val_d) &val_d 0))
           (setq #val_h (if (/= (nth 5 #xd$) &val_h) &val_h 0)) )
      ); cond
      ;;; 00/06/20 MH MOD �ύX�����܂�

      (if (or CG_TOKU CG_WAC) ; 01/09/18 YM MOD
        nil ; �������޺���ޒ�
        (progn
          (command "_undo" "b")
        )
      );_if

      ;;; 00/07/19 MH ADD
      ; �Ώې}�`��0�x�܂���90�x�ȊO�̏ꍇ�A��]����0�x��
      (setq #fANG (nth 2 #xld$))
      (if (or (equal 0 (RTD #fANG) 0.1) (equal 90 (RTD #fANG) 0.1))
        (setq #rtFLG nil)
        ; �A�C�e����], LSYM �}���p�x�ύX, #xld$�Đݒ�
        (progn
          (setq #rtFLG 'T)
          (setq #dPT (cdr (assoc 10 (entget &sym))))
          (command "_rotate" (CFGetSameGroupSS &sym) "" #dPT "R" (RTD #fANG) 0)
          (setq #i 0)
          (setq #TMP$ nil)
          (setq #ORG$ #xld$)
          (foreach #A #xld$
            (setq #TMP$ (append #TMP$  (if (= 2 #i) '(0) (list #A))))
            (setq #i (1+ #i))
          ); foreach
          (CFSetXData &sym "G_LSYM" #TMP$)
          (setq #xld$ (CFGetXData &sym "G_LSYM"))
        ); progn
      ); if

      ;// ���ނ̊g���ް��̻��ނ��X�V
      (CFSetXData &sym "G_SYM"
        (list
          (nth 0 #xd$)    ;�V���{������
          (nth 1 #xd$)    ;�R�����g�P
          (nth 2 #xd$)    ;�R�����g�Q
          (nth 3 #xd$)    ;�V���{����l�v
          (nth 4 #xd$)    ;�V���{����l�c
          (nth 5 #xd$)    ;�V���{����l�g
          (nth 6 #xd$)    ;�V���{����t������
          (nth 7 #xd$)    ;���͕��@
          (nth 8 #xd$)    ;�v�����t���O
          (nth 9 #xd$)    ;�c�����t���O
          (nth 10 #xd$)   ;�g�����t���O
          #val_w          ;�L�k�t���O�v
          #val_d          ;�L�k�t���O�c
          #val_h          ;�L�k�t���O�g
          (nth 14 #xd$)   ;�u���[�N���C�����v
          (nth 15 #xd$)   ;�u���[�N���C�����c
          (nth 16 #xd$)   ;�u���[�N���C�����g
        )
      )

      (command "_view" "S" "TEMP")
      ;(setvar "PICKSTYLE" 1)
      (StretchPartsSub &sym)

      ;;; 00/07/19 MH ADD
      ; �t���O�m�F �Ώې}�`���L�k�����O�ɉ�]����Ă����Ȃ猳�̊p�x�ɖ߂�
      (if #rtFLG (progn
        (setq #dPT (cdr (assoc 10 (entget &sym))))
        (command "_rotate" (CFGetSameGroupSS &sym) "" #dPT "R" 0 (RTD #fANG))
        (CFSetXData &sym "G_LSYM" #ORG$)
      )); if&progn
      (command "_view" "R" "TEMP")
    )
  )

  (if (/= #viewEn nil) (entdel #viewEn)) ; 00/02/29 YM ADD
  ;// �V�X�e���ϐ������ɖ߂�
  (setvar "OSMODE"   #os)
  (setvar "SNAPMODE" #sm)
  (princ)
)
;SKY_Stretch_Parts

;<HOM>*************************************************************************
; <�֐���>    : StretchParamDlg
; <�����T�v>  : �v�f�ύX�޲�۸�
; <�߂�l>    :
; <�쐬>      : 1998-05-08 (1999-11-09 �R�c �����ǉ�)
; <���l>      :
;*************************************************************************>MOH<
(defun StretchParamDlg (
    &w
    &d
    &h
    &InputCode
    /
    #dcl_id
    #xd$
    #res$
  )
  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMain.DCL")))
  (if (not (new_dialog "StretchParamDlg" #dcl_id)) (exit))
  (set_tile "w" (itoa (fix &w)))
  (set_tile "d" (itoa (fix &d)))
  (set_tile "h" (itoa (fix &h)))
  (mode_tile "w" 0)
  (mode_tile "d" 0)
  (mode_tile "h" 0)
  (if (< &InputCode 4) (mode_tile "w" 1))
  (if (or (= &InputCode 1) (= &InputCode 4) (= &InputCode 5)) (mode_tile "d" 1))
  (if (or (= &InputCode 2) (= &InputCode 4) (= &InputCode 6)) (mode_tile "h" 1))
  (mode_tile (substr "hddwwww" &InputCode 1) 2)

  (action_tile "accept" "(setq #res$ (StretchParamDlgOK))")
  (action_tile "cancel" "(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #res$
)
;StretchParamDlg

;<HOM>*************************************************************************
; <�֐���>    : NRPrimDlgOK
; <�����T�v>  : �v�f�����޲�۸�OK
; <�߂�l>    :
; <�쐬>      : 1998-05-08
; <���l>      :
;*************************************************************************>MOH<
(defun StretchParamDlgOK (
    /
    #h #th #ang #ptp #rtp
    #D #W
  )
  (setq #w (get_tile "w"))
  (setq #d (get_tile "d"))
  (setq #h (get_tile "h"))

  ;// ��������
  (if (and
    (or (equal 'INT (type (read #w)))(equal 'REAL (type (read #w))))
    (or (equal 'INT (type (read #d)))(equal 'REAL (type (read #d))))
    (or (equal 'INT (type (read #h)))(equal 'REAL (type (read #h))))
    )
    (progn
      (setq #w (atof #w))
      (setq #d (atof #d))
      (setq #h (atof #h))
      (done_dialog)
      (list #w #d #h)
    )
  ;else
    (progn
      (c:msgbox "�L���Ȓl��ݒ肵�Ă�������." "�x��" MB_ICONEXCLAMATION)
      nil
    )
  )
)
;StretchParamDlgOK

;<HOM>*************************************************************************
; <�֐���>    : StretchPartsSUB
; <�����T�v>  : �v�f�}�`�̊g���f�[�^��񂩂�v�f���č쐬����
; <�߂�l>    :
; <�쐬>      : 1998-07-30 �� 00/06/22 MH MOD
; <���l>      : Pcstretch.lsp��SKS_StretchPartsSub�ƑS���������e���Ǝv�� YM
;*************************************************************************>MOH<
(defun StretchPartsSUB (
    &sym
    /
    #ss #i #en #eg #300 #330 #sym #xd$ #gnam
    #EG$ #EG2$ #EN2 #H #XD_LSYM$
    #OSMODE #SNAPMODE
#BASE #CORNERD1 #CORNERD2 #P1 #P2 #P3 #P4 #P5 #P6 #PMEN2 #PT$ ; 01/09/25 YM ADD
  )
  (setvar "PICKSTYLE" 0)
  ; �L�k���Ȃ��Ƃ� CG_NO_STRETCH=T (���ލX�V���Ɏg�p����)
  (setq CG_NO_STRETCH nil) ; 02/03/26 YM ADD

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̏�
  ;00/07/27 SN MOD CFNoSnapStart�͊O���ϐ��ɒl���i�[����́A
  ;                �d���Ăяo�����s���ƌ��̒l���j�������B
  (setq #OSMODE   (getvar "OSMODE"))
  (setq #SNAPMODE (getvar "SNAPMODE"))
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)
  ;(CFNoSnapStart); 00/02/07 @YM@ �ǉ�

  (setq #en &sym)
  (setq #xd$ (CFGetXData #en "G_SYM"))


; 01/05/31 YM ���ꏈ�� 01/09/25 YM ADD ��Ű���ނ̔��ړ������ǉ� ------------------------------
(if CG_TOKU
  (if (= (CFGetSymSKKCode #en 3) CG_SKK_THR_CNR)
    (progn ; ��Ű����
      ; p1          p2
      ; +-----------+
      ; |           |
      ; |           |
      ; |     +-----+
      ; |     |p4   p3
      ; |     |
      ; +-----+
      ; p6    p5
      (setq #pmen2 (PKGetPMEN_NO #en 2))    ; PMEN2
      (setq #pt$ (GetLWPolyLinePt #pmen2))  ; PMEN2 �O�`�̈�
      (setq #base (PKGetBaseL6 #pt$))       ; ��Ű��_�����߂�(����ق����Ȃ�)
      (setq #pt$ (GetPtSeries #base #pt$))  ; #base ��擪�Ɏ��v����
      (setq #p1 (nth 0 #pt$))
      (setq #p2 (nth 1 #pt$))
      (setq #p3 (nth 2 #pt$))
      (setq #p4 (nth 3 #pt$))
      (setq #p5 (nth 4 #pt$))
      (setq #p6 (nth 5 #pt$))
      (setq #cornerD1 (distance #p2 #p3))
      (setq #cornerD2 (distance #p5 #p6))

      (if (and CG_TOKU_BW (/= (nth 11 #xd$) 0); �������޺����W�����L�k���A����W�����Ɉړ������(�E����)
               (< CG_TOKU_BW #cornerD2))
        ; +-|-------+
        ; | |       |
        ; | | +-----+
        ; | | |
        ; +-|-+
        ; ��:���@���޸�ٕ���(�������󂪏o��)
        (setq CG_DOOR_MOVE06 (- (nth 11 #xd$)(nth 3 #xd$))) ; 01/09/25 W�����L�k��
      );_if

      (if (and CG_TOKU_BD (/= (nth 12 #xd$) 0); �������޺����D�����L�k���A����D�����Ɉړ������
               (< CG_TOKU_BD #cornerD1))
        ; +---------+
        ;------------
        ; |   +-----+
        ; |   |
        ; +---+
        ; ��:���@���޸�ٕ���(�������󂪏o��)
        (setq CG_DOOR_MOVE03 (- (nth 12 #xd$)(nth 4 #xd$))) ; 01/05/31 D�����L�k��
      );_if

;;;     (if (and (/= (nth 12 #xd$) 0); �������޺����D�����L�k���A����D�����Ɉړ������
;;;              (>= CG_TOKU_BD #cornerD1))
;;;       (progn
;;;       ; +---------+
;;;       ; |         |
;;;       ; |   +-----+
;;;       ; ------
;;;       ; +---+   �E���ʔ������Ɉړ�����(���ꏈ��)
;;;       ; ��:���@���޸�ٕ���(�������󂪏o��)
;;;         (setq CG_DOOR_MOVE06 (- (nth 12 #xd$)(nth 4 #xd$))) ; 01/05/31 D�����L�k��
;;;;;;          (setq CG_DOOR_MOVE_RIGHT T) ; 01/09/25 ���ړ����������ʂł͂Ȃ��A�������ĉE����
;;;       )
;;;     );_if

    )
    (progn ; ��Ű���ވȊO(���܂łǂ���)
      (if (/= (nth 12 #xd$) 0); �������޺����D�����L�k���A����D�����Ɉړ������
        ; ��:���@���޸�ٕ���(�������󂪏o��)
        (setq CG_DOOR_MOVE03 (- (nth 12 #xd$)(nth 4 #xd$))) ; 01/05/31 D�����L�k��
      );_if
    )
  );_if
);_if
; 01/05/31 YM ���ꏈ�� 01/09/25 YM ADD ��Ű���ނ̔��ړ������ǉ� ------------------------------

  (if (or (/= 0 (fix (nth 11 #xd$))) (/= 0 (fix (nth 12 #xd$))) (/= 0 (fix (nth 13 #xd$))))
    (progn
      ;// �Q�c�}�`�̐L�k
      ;(command "_layer" "T" "*" "")
      (SCEExpansion #en)
      ;// �R�c�}�`�̐L�k
      (setq #eg$ (entget (cdr (assoc 330 (entget #en)))))  ;// �e�}�ʏ����擾
      (foreach #lst #eg$  ;// ��ٰ�����ް�}�`�̎擾
        (if (= 340 (car #lst))
          (progn
            (setq #en2 (cdr #lst))
            (setq #eg2$ (entget #en2 '("G_PRIM")))
            (if (and (/= nil #eg2$) (= (cdr (assoc 0 #eg2$)) "3DSOLID")
                     (= (cdr (assoc 8 #eg2$)) "Z_00_00_00_01") )
              ;00/06/22 MH"G_PRIM"�֘A�}�`����"G_PRIM"�f�[�^�Ȃ�����SKS_RemakePrim�Ə�
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
              )
            )
          )
        )
      )
      (if (/= (nth 13 #xd$) 0)
        (setq #H (nth 13 #xd$))
        (setq #H (nth  5 #xd$)) ;�V���{����l�g
      )
      ;;; �o�͐��@�ɔ��f���邽��(��АL�k)
      (setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
      (CFSetXData #en "G_LSYM"
        (CFModList #xd_LSYM$
;-- 2012/02/17 A.Satoh Mod CG�Ή� - S
;;;;;          (list (list 13 #H))
					(if (/= CG_SizeH nil)
	          (list (list 13 CG_SizeH))
  	        (list (list 13 #H))
					)
;-- 2012/02/17 A.Satoh Mod CG�Ή� - E
        )
      )

      ; �L�k���Ȃ�������X�V���Ȃ� 02/03/26 YM ADD
      (if CG_NO_STRETCH ; 02/03/26 YM ADD
        nil ; 02/03/26 YM ADD
        ; else ���܂łǂ���
        (CFSetXData #en "G_SYM"
          (list
            (nth 0 #xd$)    ;�V���{������
            (nth 1 #xd$)    ;�R�����g�P
            (nth 2 #xd$)    ;�R�����g�Q
            (if (/= (nth 11 #xd$) 0)
              (nth 11 #xd$)
              (nth 3 #xd$)    ;�V���{����l�v
            )
            (if (/= (nth 12 #xd$) 0)
              (nth 12 #xd$)
              (nth 4 #xd$)    ;�V���{����l�c
            )
            #H
            (nth 6 #xd$)    ;�V���{����t������
            (nth 7 #xd$)    ;���͕��@
            (nth 8 #xd$)    ;�v�����t���O
            (nth 9 #xd$)    ;�c�����t���O
            (nth 10 #xd$)   ;�g�����t���O
            (nth 11 #xd$)   ;�L�k�t���O�v
            (nth 12 #xd$)
            (nth 13 #xd$)
            (nth 14 #xd$)   ;�u���[�N���C�����v
            (nth 15 #xd$)   ;�u���[�N���C�����c
            (nth 16 #xd$)   ;�u���[�N���C�����g
          )
        )
      );_if
    )
  );_if

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  ;00/07/27 SN MOD CFNoSnapStart�͊O���ϐ��ɒl���i�[����́A
  ;                �d���Ăяo�����s���ƌ��̒l���j�������B
  (setvar "OSMODE"   #OSMODE)
  (setvar "SNAPMODE" #SNAPMODE)
  ;(CFNoSnapEnd); 00/02/07 @YM@ �ǉ�

  ; �L�k���Ȃ��Ƃ� CG_NO_STRETCH=T (���ލX�V���Ɏg�p����)
  (setq CG_NO_STRETCH nil) ; 02/03/26 YM ADD

  (command "_vpoint" "0,0,1")
  (command "_ucs" "w")
);StretchPartsSUB

;<HOM>*************************************************************************
; <�֐���>    : PcGetAllItemBetween2Pnt
; <�����T�v>  : 4�_�ŕ\�����CP�͈͒��Ɉʒu���邷�ׂẴA�C�e���擾
; <�߂�l>    : �I���Z�b�g (������� Nil)
; <�쐬>      : 00/06/26 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcGetAllItemBetween2Pnt (
  &PLIST
  /
  #PLIST #view$ #Sset #Sset2 #I #MOV
  #pdsize;00/07/12 SN ADD
  )
  (setq #PLIST (AddPtList &PLIST)) ; �����Ɏn�_��ǉ�����
  (setq #pdsize (getvar "PDSIZE"));00/07/12 SN ADD
  (setvar "PDSIZE" 1)             ;00/07/12 SN ADD
  (setvar "PICKSTYLE" 0)
  (command "_vpoint" '(0 0 1))
  (setq #Sset (ssget "CP" #PLIST '((-3 ("G_LSYM")))))
  (command "zoom" "p")
  (setvar "PDSIZE" #pdsize);00/07/12 SN ADD

  ;; �擾�}�`�����p�F��
;;;(if #Sset (progn (setq #MOV nil)(setq #i 0)
;;;  (while (< #i (sslength #Sset))
;;;   (setq #MOV (cons (ssname #Sset #i) #MOV))
;;;   (setq #i (1+ #i))
;;;)))
(foreach ## #MOV (GroupInSolidChgCol2 ## 1))

#Sset
); PcGetAllItemBetween2Pnt

;<HOM>*************************************************************************
; <�֐���>    : PcGetAllItemBetween2PntWT
; <�����T�v>  : 4�_�ŕ\�����CP�͈͒��Ɉʒu���邷�ׂẴ��[�N�g�b�v�擾
; <�߂�l>    : �I���Z�b�g (������� Nil)
; <�쐬>      : 00/07/24 SN
; <���l>      : �{�֐���PcGetAllItemBetween2Pnt�Ɠ������Ń��[�N�g�b�v�݂̂��擾����B
;*************************************************************************>MOH<
(defun PcGetAllItemBetween2PntWT (&PLIST / #PLIST #view$ #Sset
  #pdsize;00/07/12 SN ADD
  #wss #wi;00/07/24 SN ADD
  )
  (setq #PLIST &PLIST)

  (setq #pdsize (getvar "PDSIZE"));00/07/12 SN ADD
  (setvar "PDSIZE" 1)             ;00/07/12 SN ADD
  (setvar "PICKSTYLE" 0)
  (setq #view$ (getvar "VIEWDIR"));;; �v���_����

  (command "_vpoint" '(0 0 1))
  (setq #Sset (ssget "CP" #PLIST '((-3 ("G_WRKT")))))
  (command "_vpoint" #view$)
  (setvar "PDSIZE" #pdsize);00/07/12 SN ADD
  #Sset
); PcGetAllItemBetween2PntWT

;<HOM>*************************************************************************
; <�֐���>    : PcGetSameAreaItem$
; <�����T�v>  : �͈͑S�}�`�̂Ȃ�����#eNEXT$�̊e�A�C�e���Ɠ��͈� �������̂��̂�I��
; <�߂�l>    : �}�`�����X�g �Ȃ�= nil
; <�쐬>      : 00/06/26 MH
; <���l>      : �R�����⑫�������@��E�o����̂��ړI
;*************************************************************************>MOH<
(defun PcGetSameAreaItem$ (
  &ss         ; �͈͑S�}�`�̑I���Z�b�g
  &eNEXT$     ; �אڃL���r�̖��O���X�g
  /
  #eRES$ #i #eALL$ #eAL #$ #TEMP$ #FLG #eNT
  )
  ; �I���Z�b�g����}�`�����X�g#eALL$ �쐬
  (if &ss (progn
    (setq #i 0)
    (while (< #i (sslength &ss))
      (setq #eALL$ (cons (ssname &ss #i) #eALL$))
      (setq #i (1+ #i))
    ); while
  )); if
  ; #eALL$ ������אڃL���r�̖��O������
  (if (and #eALL$ &eNEXT$) (progn
    (setq #TEMP$ nil)
    (foreach #eAL #eALL$
      (if (not (member #eAL &eNEXT$)) (setq #TEMP$ (cons #eAL #TEMP$)))
    ); foreach
    (setq #eALL$ #TEMP$)
  )); if progn
  (if (and #eALL$ &eNEXT$) (progn
    ; #eALL$ �̐}�`�� &eNEXT$ �̐}�`�Ɠ����Ŕ͈͂ɂ������#eRES$�Ɏ擾������B
    (setq #eRES$ nil)
    (foreach #eAL #eALL$
      (setq #i 0)
      (setq #FLG 'T)
      (while (and #FLG (setq #eNT (nth #i &eNEXT$)))
        (if (and (/= (CFGetSymSKKCode #eAL 1) CG_SKK_ONE_SID)
                 (= (CFGetSymSKKCode #eAL 2)(CFGetSymSKKCode #eNT 2))
                 (PcJudgeCrossArea #eNT #eAL)
            )
          (progn
            (setq #eRES$ (cons #eAL #eRES$))
            (setq #FLG nil)
          ); progn
        ); if
        (setq #i (1+ #i))
      ); while
    ); foreach
  )); if progn
  #eRES$
); PcAddSameAreaItem

;<HOM>*************************************************************************
; <�֐���>    : PcJudgeCrossArea
; <�����T�v>  : &eONE (��) �̐}�`�͈͓̔��� &eTWO (��) ���ʒu���邩�H
; <�߂�l>    : T or nil
; <�쐬>      : 00/06/26 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcJudgeCrossArea (
  &eONE       ; �}�`(��)
  &eTWO       ; �}�`(��)
  /
  #RES #1P$ #2P$ #dCK
  )
  ; �`�F�b�N������4�_(2�����_)���o��
  (setq #1P$ (PcGetItem4P$ &eONE 0 0 0 0))
  (setq #1P$ (append #1P$ (list (car #1P$))))
  (setq #2P$ (PcGetItem4P$ &eTWO 0 0 0 0))
  (setq #RES nil)
  (foreach #dCK #2P$
    (if (JudgeNaigai #dCK #1P$) (setq #RES 'T))
  ); foreach
  #RES
); PcJudgeCrossArea

;<HOM>*************************************************************************
; <�֐���>    : PcGetNextItemSameLevel
; <�����T�v>  : �w��}�`�ɗאڂ��邠��������̃A�C�e�����擾
; <�߂�l>    : �}�`�����X�g �����̐}�`���Ȃ���� Nil
; <�쐬>      : 00/06/24 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcGetNextItemSameLevel (
  &eITEM      ; �Ώې}�`��
  &iCODE      ; ���iCODE2�P�^��
  /
  #NEXT$ #eNT #RES$
  )
  (setq #NEXT$ (PcGetEn$CrossArea &eITEM 0 0 0 0 'T))
  (foreach #eNT #NEXT$
    (if (equal (CFGetSymSKKCode #eNT 2) &iCODE 0.01) (setq #RES$ (cons #eNT #RES$)))
  ); foreach
  #RES$
); PcGetNextItemSameLevel

;<HOM>*************************************************************************
; <�֐���>    : PcGetItemInAreaSameLevel
; <�����T�v>  : �^����ꂽ�����N�}�`�̗̈�Ɋ|���铯�����̃A�C�e�����擾
; <�߂�l>    : �}�`�����X�g �����̐}�`���Ȃ���� Nil
; <�쐬>      : 00/06/26 MH
; <���l>      : �����N�}�`�ƃ_�u��Ȃ�����(�R�����A���������@�Ȃ�)
;*************************************************************************>MOH<
(defun PcGetItemInAreaSameLevel (
  &eITEM$     ; �����N�}�`�����X�g
  &iCODE      ; ���iCODE2�P�^��
  /
  #view$ #OutPLine #pt$ #ss #i #eCHK #RES$
  )
  (setq #view$ (getvar "VIEWDIR"));;; �v���_����
  (setq #OutPLine (PKW_MakeSKOutLine &eITEM$ nil))
  (setq #pt$ (GetLWPolyLinePt #OutPline))
  (entdel #OutPline)
  (command "_vpoint" '(0 0 1))
  ; �̈���̃A�C�e���E�o("G_LSYM")
  (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_LSYM")))))
  (command "_vpoint" #view$)
  ; �擾���ꂽ�Z�b�g���獂���̈Ⴄ�A�C�e���Ɗ�ɂȂ��������N�}�`�A�C�e�������O
  (if #ss (progn
    (setq #i 0)
    (while (< #i (sslength #ss))
      (setq #eCHK (ssname #ss #i))
      (if (and (not (member #eCHK &eITEM$)) ; ��̐}�`���ƈႤ
               (= &iCODE (CFGetSymSKKCode #eCHK 2))) ; ����������
        (setq #RES$ (cons #eCHK #RES$))
      ); if
      (setq #i (1+ #i))
    ); while
  )); if progn
  #RES$
); PcGetItemInAreaSameLevel

;<HOM>*************************************************************************
; <�֐���>    : PcGetLinkMoveItems
; <�����T�v>  : �w��}�`�ɗאڂ���w�荂���̈ړ��̉\���̂���A�C�e�����擾
; <�߂�l>    : �}�`�����X�g
; <�쐬>      : 00/06/23 MH
; <���l>      : �ċA�ɂ�� �אڂ����V���{����CG_LinkSym�Ɋi�[����
;*************************************************************************>MOH<
(defun PcGetLinkMoveItems (
    &en       ;(ENAME)�C�ӂ̐}�`
    &code     ;(INT)�x�[�X�A�A�b�p�[�̐��iCODE(CG_SKK_TWO_BAS,CG_SKK_TWO_UPP)
    /
    #enSS$
    #enS1
    #xd$
    #skk$
    #ss #i
    #ename
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PcGetLinkMoveItems ////")
  (CFOutStateLog 1 1 " ")
  (setq CG_LinkSym nil)
  ;��V���{������������
  (setq #enS1 (CFSearchGroupSym &en))
  ;2000/06/13  HT ��V���{�����������s�̓G���[���b�Z�[�W
  (if #enS1 (progn
    (if (= &code (CFGetSymSKKCode #enS1 2)) (progn
      (setq #enSS$ (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (setq #ss (ssadd))                 ; �ǉ� �i�荞�� 00/03/10 MOD YM
      ; 00/06/23 MH �C���e���A�p�l���A�E�H�[���n���K�[�A�A�C���x���n���K�[�ȊO�S�Ώ�
      (repeat (sslength #enSS$)
        (setq #skk$ (CFGetSymSKKCode (ssname #enSS$ #i) nil))
        ; ��L�̂��̂́A(cadr #skk$) = 0 �Ȃ̂ŁA��������B
        ;(if (= (cadr #skk$) &code)  ; &code �̂��߯�����    ;00/07/17 SN MOD
        (setq #ename (CFGetXData (ssname #enSS$ #i) "G_LSYM"))
        (if (or (= (cadr #skk$) &code)
                (and (= CG_SKK_TWO_BAS &code) ))
            (ssadd (ssname #enSS$ #i) #ss)
        );_if
        (setq #i (1+ #i))
      );_(repeat (sslength #ss)                         ; 00/03/10 ADD YM
      ;// �ċA�ɂ��אڂ���x�[�X�L���r���������� ---> CG_LinkSym �ɓ����
      ;(SKW_SearchLinkBaseSym #ss #enS1)
      (PcSearchLinkItem #ss #enS1)  ; 00/07/06 MOD MH
      ;// �אڂ���L���r�̊�V���{���}�`��Ԃ�
      CG_LinkSym
    ); progn
    nil
    ); if
  ) ; progn
  (progn
    ;2000/06/13  HT ��V���{�����������s�̓G���[���b�Z�[�W
    (princ "\n��V���{�����������sG_SYM(0)=")
    (princ (nth 0 (CfGetXData &en "G_SYM")))
    nil
  )
  )
)
; PcGetLinkMoveItems

;<HOM>*************************************************************************
; <�֐���>    : PcSearchLinkItem
; <�����T�v>  : �w��}�`�ɗאڂ���A�C�e�����擾����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/07/06
; <���l>      : SKW_SearchLinkBaseSym����쐬�B�אڂ̒�` = ����ӂ̗L��
;*************************************************************************>MOH<
(defun PcSearchLinkItem (
  &enSS$     ;(PICKSET)�x�[�X�L���r�l�b�g�̃��X�g
  &enS1      ;(ENAME)�L���r�l�b�g�P
  /
  #ANG #D #ENS2 #H #I
  #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #PT$ #PT0$ #UPPER #W #XD$
  #XDL ;00/08/28 SN ADD
  )
  ; �A�b�p�[���ǂ����̃t���O �i�n�C�~�h���̏����j
  (if (= CG_SKK_TWO_UPP (CFGetSymSKKCode &enS1 2)) (setq #Upper 'T))

  (setq #xd$ (CFGetXData &enS1 "G_SYM"))
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #h (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &enS1 "G_LSYM")))
  ;// ��`�̈�����߂�
  (setq #p1 (cdr (assoc 10 (entget &enS1))))
  ; 00/05/08 ADD MH �A�b�p�[�Ȃ�2�����_�ɕϊ�(�����Ⴄ�t�[�h�΍�)
  (if #Upper (setq #p1 (list (car #p1) (cadr #p1))))
  (setq #p2 (polar #p1 #ang #w))
  (setq #p3 (polar #p2 (- #ang (dtr 90)) #d))
  (setq #p4 (polar #p1 (- #ang (dtr 90)) #d))
  (setq #pt0$ (list #p1 #p2 #p3 #p4))

  (setq #i 0)
  (repeat (sslength &enSS$)
    (setq #enS2 (ssname &enSS$ #i))
    (setq #xd$ (CFGetXData #enS2 "G_SYM"))
    (setq #w (nth 3 #xd$))
    (setq #d (nth 4 #xd$))
    (setq #h (nth 5 #xd$))
    (setq #XDL (CFGetXData #enS2 "G_LSYM"))         ;00/08/28 SN MOD
    (setq #ang (nth 2 #XDL))                        ;
    ;(setq #ang (nth 2 (CFGetXData #enS2 "G_LSYM")));00/08/28 SN MOD

    ;// ��`�̈�����߂�
    (setq #p5 (cdr (assoc 10 (entget #enS2))))
    ; 00/05/08 ADD MH �A�b�p�[�Ȃ�2�����_�ɕϊ�(�����Ⴄ�t�[�h�΍�)
    (if #Upper (setq #p5 (list (car #p5) (cadr #p5))))
    (setq #p6 (polar #p5 #ang #w))
    (setq #p7 (polar #p6 (- #ang (dtr 90)) #d))
    (setq #p8 (polar #p5 (- #ang (dtr 90)) #d))
    (setq #pt$ (list #p5 #p6 #p7 #p8))

    (if (PcJudgeCrossing #pt0$ #pt$)
    ;00/09/04 MH MOD �H���̈ړ��s�͐��iCODE�̂����B��������ɂ��ǂ���
      (if (= nil (member #enS2 CG_LinkSym))
        (progn
          (setq CG_LinkSym (cons #enS2 CG_LinkSym))
          (PcSearchLinkItem &enSS$ #enS2)
        )
      )
    )
    (setq #i (1+ #i))
  );_repeat
);PcSearchLinkItem

;<HOM>*************************************************************************
; <�֐���>    : PcSearchLinkItem2
; <�����T�v>  : �w��}�`�ɗאڂ���A�C�e�����擾����(�����͌��Ȃ�)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/07/06 MH
; <���l>      : �אڂ̒�` = ����ӂ̗L��
;*************************************************************************>MOH<
(defun PcSearchLinkItem2  (
  &eSEL$      ; �אڂ�T���ΏۂƂȂ郊�X�g
  &eONE       ; ��̃A�C�e��
  /
  #dCHK$ #i #eTWO
  )
  (setq #dCHK$ (PcGetItem4P$ &eONE 0 0 0 0))
  (setq #i 0)
  (repeat (sslength &eSEL$)
    (setq #eTWO (ssname &eSEL$ #i))
    (if (PcJudgeCrossing #dCHK$ (PcGetItem4P$ #eTWO 0 0 0 0))
      (if (= nil (member #eTWO CG_LinkSym))
        (progn
          (setq CG_LinkSym (cons #eTWO CG_LinkSym))
          (PcSearchLinkItem #eTWO &eSEL$)
        )
      )
    )
    (setq #i (1+ #i))
  );_repeat
);PcSearchLinkItem

;******************************************************************************
(defun C:InsParts ()
  (StartUndoErr)
  (SKY_InsertPartsSel nil)
) ; 01/01/29 YM "L"==>nil==>հ�ް��L/R�I��
;******************************************************************************
(defun C:InsPartsR () (KcInsParts "R"))
(defun C:InsPartsL () (KcInsParts "L"))

;<HOM>*************************************************************************
; <�֐���>    : KcInsParts
; <�����T�v>  : �A�C�e������A�C�e���̎w�������ɑ}���A���Ӑ}�`�ړ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/02/21 MH
; <���l>      :
;*************************************************************************>MOH<
(defun KcInsParts (
  &sDIR       ; �}������  "L" "R"
  /
  #eBASE #sDIR
  )
  (StartUndoErr)
  (CFCmdDefBegin 6)

  (setq #sDIR &sDIR)
  ; ��A�C�e�����w������ĂȂ���΃_�C�A���O
  (setq CG_BASESYM (CFGetBaseSymXRec))
  (if (not CG_BASESYM)
    (CFAlertMsg "��A�C�e��������܂���.��A�C�e����I�����ĉ�����"))
  ; �}�����s
  (SKY_InsPartsIN #sDIR CG_BASESYM)

  (CFCmdDefFinish)
  (princ)
); KcInsParts

;<HOM>*************************************************************************
; <�֐���>    : SKY_InsertPartsSel
; <�����T�v>  : �ݔ��}�� �A�C�e����I�����đ}��
; <�߂�l>    :
; <�쐬>      : 2000-06-23 ����
; <���l>      :
;*************************************************************************>MOH<
(defun SKY_InsertPartsSel(
  &type ;����  "L" "R" ;//"T" "D"     ;���݂�"L"�̂ݑΉ�==>nil(01/01/29 YM MOD)
  /
  #en
  #Gen
  #ret #type
  )
  (setq #type &type)
  (StartUndoErr);00/09/07 SN ADD
  (CFCmdDefBegin 6);00/09/07 SN ADD
  ;(command "_undo" "m");00/09/07 SN MOD

  (setq #en nil)
  (while (not #en)
    (setq #en (car (entsel "\n�}����A�C�e�����w��:")))
    (cond
      (#en
        (setq #Gen (CFSearchGroupSym #en))
        (GroupInSolidChgCol2 #Gen CG_InfoSymCol)
        (setq #ret (CFYesNoCancelDialog "����ł�낵���ł����H "))
          (cond
            ((= #ret IDYES)
;;;              (command "_undo" "b")
              ;(SKY_InsPartsIN "R" #Gen) 00/07/17 MH MOD

              ; 01/01/29 YM ADD START
              (if (= #type nil)
                (progn
                  (initget 1 "L R")
                  (setq #type (getkword "\n�}��������� /L=��/R=�E/:  "))
                )
              );_if
              ; 01/01/29 YM ADD END

              (command "_undo" "b") ; 01/02/05 �����ֈړ�
              (SKY_InsPartsIN #type #Gen)
              (setq #en T)
            )
            ((= #ret IDNO)
              (command "_undo" "b")
              (setq #en nil)
            )
            (T
              (*error*)
            )
          )
      )
    )
  )
  (CFCmdDefFinish);00/09/07 SN ADD
  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : SKY_InsPartsIN
; <�����T�v>  : �ݔ��}��
; <�߂�l>    :
; <�쐬>      : 00/06/23 SN
; <���l>      : KSY_InsParts��ėp�֐��ɉ���
;*************************************************************************>MOH<
(defun SKY_InsPartsIN (
  &type     ;����  "L" "R" ;//"T" "D"     ;���݂�"L"�̂ݑΉ�
  &basesym  ;00/06/23 ADD SN
  /
  #xd$ #fig$ #w #d #h #w2 #d2 #h2 #P&A$ #pt #ang
  #sCd        ; ���iCODE
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKY_InsParts ////")
  (CFOutStateLog 1 1 " ")

  ;00/06/23 SN S-MOD
  ;(setq CG_BASESYM (CFGetBaseSymXRec))
  ;(if (= CG_BASESYM nil)
  ;  (progn
  ;    (CFAlertErr "��A�C�e��������܂���.��A�C�e����I�����ĉ�����")
  ;  )
  ;)
  ;(setq #xd$ (CFGetXData CG_BASESYM "G_SYM"))
  ;(setq #pt (cdr (assoc 10 (entget CG_BASESYM))))
  (setq #xd$ (CFGetXData &basesym "G_SYM"))
  (setq #pt (cdr (assoc 10 (entget &basesym))))
  ;00/06/23 SN S-MOD

;  (setq #w (if (= (nth 11 #xd$) 0) (nth 3 #xd$) (nth 11 #xd$)))
;  (setq #d (if (= (nth 12 #xd$) 0) (nth 4 #xd$) (nth 12 #xd$)))
;  (setq #h (if (= (nth 13 #xd$) 0) (nth 5 #xd$) (nth 13 #xd$)))
  ;;; �ύX 00/05/23 MH MOD �L�k�t���O�̒�`���ς���Ă��邽��
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #h (nth 5 #xd$))

  ;(setq #xd$ (CFGetXData CG_BASESYM "G_LSYM"))  00/06/23 SN MOD
  (setq #xd$ (CFGetXData &basesym "G_LSYM"))    ;00/06/23 SN MOD

  (if (setq #fig$ (SKY_GetItemInfo))
    (progn
      (setq #w2  (fix (nth 5 #fig$)))
      (setq #d2  (fix (nth 6 #fig$)))
      (setq #h2  (fix (nth 7 #fig$)))
      (setq #sCd (fix (nth 8 #fig$))) ; 01/06/17 HN ADD
    )
    (CFAlertErr "�i�ԏ����擾�ł��܂���ł���")
  )


;-- 2011/08/03 A.Satoh Add - S
  ; ���O���[�h�ʔz�u�s���ރ`�F�b�N
  (if (= (CheckDoorGradeFree (nth 0 #fig$) CG_DRSeriCode CG_DRColCode) nil)
    (progn
      (CfAlertMsg "�I�������i�Ԃ́A���݂̔��O���[�h�A���F�̂Ƃ��z�u�ł��܂���B")
      (exit)
    )
  )
;-- 2011/08/03 A.Satoh Add - E

  ;// �}����_�Ƒ}���p�x�����߂�  00/07/17 MH �֐���
  ; 01/06/17 HN MOD �z�u�A�C�e���̐��iCODE��ǉ�
  ;@MOD@(setq #P&A$
  ;@MOD@  (PcArrangeInsPnt #pt &type #fig$ &basesym #xd$ (list #w #d #h) (list #w2 #d2 #h2)))
  (setq #P&A$
    (PcArrangeInsPnt #pt &type #fig$ &basesym #xd$ (list #w #d #h) (list #w2 #d2 #h2) #sCd))
  (setq #pt  (car  #P&A$))
  (setq #ang (cadr #P&A$))

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart); 00/02/07 @YM@ �ǉ�

  ;2018/07/12 �ؐ�������Ή�
  (setq #fig$ (KcChkWCounterItem$ #fig$))

  (if (not (KcSetUniqueItem "INS" #fig$ &basesym &type nil))
    ;;;���ꕔ�ވȊO�̕��ނ̏���
    (PcSetItem "INS" &type #FIG$ #pt #ang &basesym nil)
  ); end of if

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  (CFNoSnapEnd); 00/02/07 @YM@ �ǉ�

  (setq *error* nil)
  (princ)
  ; #en;00/06/23 SN ADD ����тȂ�A�C�e������Ԃ��B00/07/13 MH DEL ��ڍs�͕ʊ֐���
);SKY_InsPartsIN

;<HOM>*************************************************************************
; <�֐���>    : BaseCheck
; <�����T�v>  : ��A�C�e���ݒ�`�F�b�N
; <�߂�l>    :
; <�쐬>      : 1999-11-29 �R�c
; <���l>      :
;*************************************************************************>MOH<
(defun C:BaseCheck ( / #f )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:BaseCheck ////")
  (CFOutStateLog 1 1 " ")

  ;// �R�}���h�̏�����
  (StartCmnErr)

  (setq CG_BASESYM (CFGetBaseSymXRec))

  (if (= CG_BASESYM nil)
    (progn
      (setq #f (open (strcat CG_SYSPATH "Config.cfg") "w"))
      (write-line "BaseParts NG" #f)
      (close #f)
      (CFAlertErr "��A�C�e�����ݒ肳��Ă��܂���")
    )
    (progn
      (setq #f (open (strcat CG_SYSPATH "Config.cfg") "w"))
      (write-line "BaseParts OK" #f)
      (close #f)
    )
  )
  (setq *error* nil)
  (princ)
)
;C:BaseCheck

;<HOM>*************************************************************************
; <�֐���>    : C:PtenDisp
; <�����T�v>  : ���_�\��
; <�߂�l>    :
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun C:PtenDisp (
  /
  #ss
  #i
  #pt
  #p1 #p2
  #CCOL #P #OFF
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PC_SearchPlanNewDWG ////")
  (CFOutStateLog 1 1 " ")

  ;// �R�}���h�̏�����
  (StartUndoErr)
  (if (= nil (tblsearch "APPID" "G_PDSP"))
    (regapp "G_PDSP")
  )
  (setq #ss (ssget "X" '((-3 ("G_PDSP")))))
  (if (/= #ss nil)
    (command "_erase" #ss "")
  )
  (setq #ccol (getvar "CECOLOR"))
  (setvar "CECOLOR" "2")
  (setq #off 30)
  (setq #ss (ssget "X" '((-3 ("G_PTEN")))))
  (setq #i 0)

  (repeat (sslength #ss)
    (setq #pt (cdr (assoc 10 (entget (ssname #ss #i)))))
    (setq #p1 (mapcar '(lambda (#p) (- #p #off)) #pt))
    (setq #p2 (mapcar '(lambda (#p) (+ #p #off)) #pt))
    (MakeLwPolyLine (list #p1 #p2) 0 0)
    (CFSetXData (entlast) "G_PDSP" (list 1))
    (setq #pt #p1)
    (setq #p1 (list (car #p1) (cadr #p2)))
    (setq #p2 (list (car #p2) (cadr #pt)))
    (MakeLwPolyLine (list #p1 #p2) 0 0)
    (CFSetXData (entlast) "G_PDSP" (list 1))
    (setq #i (1+ #i))
  )
  (setvar "CECOLOR" #ccol)
  (setq *error* nil)
  (princ)
)
;C:PtenDisp

;<HOM>*************************************************************************
; <�֐���>    : C:PtenDel
; <�����T�v>  : ���_�\��
; <�߂�l>    :
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun C:PtenDel (
    /
    #ss
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:PtenDel ////")
  (CFOutStateLog 1 1 " ")

  ;// �R�}���h�̏�����
  (StartUndoErr)
  (setq #ss (ssget "X" '((-3 ("G_PDSP")))))
  (if (/= #ss nil)
    (command "_erase" #ss "")
  )
  (setq *error* nil)
  (princ)
)
;C:PtenDel

;<HOM>*************************************************************************
; <�֐���>    : C:HideSS
; <�����T�v>  : �I���Z�b�g��\��
; <�߂�l>    :
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun C:HideSS (
    /
    #ss
    #i
    #pt
    #EG
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:HideSS ////")
  (CFOutStateLog 1 1 " ")

  ;// �R�}���h�̏�����
  (StartCmnErr)
  (if (= nil (tblsearch "LAYER" "HIDE"))
    (command
      "_layer"
      "N" "HIDE" "F" "HIDE" ""
    )
  )
  (setq #ss (ssget))
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #eg (entget (ssname #ss #i)))
    (entmod (subst (cons 8 "HIDE") (assoc 8 #eg) #eg))
    (setq #i (1+ #i))
  )
  (setq *error* nil)
  (princ)
)
;C:HideSS

;<HOM>*************************************************************************
; <�֐���>    : C:dispHideSS
; <�����T�v>  : ��\���I���Z�b�g�\��
; <�߂�l>    :
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun C:dispHideSS (
    /
    #ss
    #i
    #pt
    #EG
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:dispHideSS ////")
  (CFOutStateLog 1 1 " ")

  ;// �R�}���h�̏�����
  (StartCmnErr)

  (setq #ss (ssget "X" '((8 . "HIDE"))))
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #eg (entget (ssname #ss #i)))
    (entmod (subst (cons 8 "BYLAYER") (assoc 8 #eg) #eg))
    (setq #i (1+ #i))
  )
  (setq *error* nil)
  (princ)
)
;C:dispHideSS

;<HOM>*************************************************************************
; <�֐���>    : Pc_CheckInsertDwg
; <�����T�v>  : �}������}�`̧�ق����݂��邩�ǂ����̃`�F�b�N
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/03/15 MH
; <���l>      : �������݂��Ȃ��Ȃ�A���b�Z�[�W��o
;*************************************************************************>MOH<
(defun Pc_CheckInsertDwg (
  &sFILE      ; �t�@�C����
  &sDIR       ; �f�B���N�g���[��
  /
  )
  (if (not (findfile (strcat CG_MSTDWGPATH &sFILE)))
    (progn
      (CFAlertMsg (strcat "�}������}�`̧�� " &sFILE " ���w���ިڸ�ذ \n"
       CG_MSTDWGPATH " ���ɔ����ł��܂���B"))(exit)
    ); progn
  ); end of if
);Pc_CheckInsertDwg

;;;<HOM>***********************************************************************
;;; <�֐���>    : SCEExpansion
;;; <�����T�v>  : �V���{���ɑ����� 2D �}�`��S�ĐL�k����
;;; <�߂�l>    : �����F T�@�@�@���s�Fnil
;;; <�쐬>      : 1998/08/05, 1998/08/17 -> 1998/08/17   ���� �����Y
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun SCEExpansion
  (
    &enSym      ; �L�k���s���V���{���}�`��
  /
    #SymData$   ; �V���{���f�[�^�i�[�p
    #enGroup    ; �V���{���̏�������O���[�v���i�[�p
    #GrpData$   ; �O���[�v�\���}�`��(�O���[�v�̃f�[�^)�i�[�p
    #expData$   ; �L�k�������s���}�`�f�[�^���i�[�p

    #iRad       ; �V���{���̉�]�p�x�i�[�p
    #SymPos$    ; �V���{���̑}���_�i�[�p

    #ViewZ$     ; �����o�������i�[�p

    #iHSize     ; ���݂� H �����̃T�C�Y�i�[�p
    #iWSize     ; ���݂� W �����̃T�C�Y�i�[�p
    #iDSize     ; ���݂� D �����̃T�C�Y�i�[�p

    #iHExp      ; H �����̐L�k���i�[�p
    #iWExp      ; W �����̐L�k���i�[�p
    #iDExp      ; D �����̐L�k���i�[�p

    #BrkH$      ; H �����̃u���[�N���C�����i�[�p
    #BrkW$      ; W �����̃u���[�N���C�����i�[�p
    #BrkD$      ; D �����̃u���[�N���C�����i�[�p

    #bCabFlag   ; �L���r�l�b�g�t���O(�A�b�p�[�L���r�l�b�g:1 ����ȊO:0)

    #Pos$       ; �L�k�Ώ̐}�`�̋�`�̈���W�i�[�p

    #iExpSize   ; �L�k���s���T�C�Y�i�[�p

    #iLoop      ; ���[�v�p
    #nn         ; foreach �p

    #strLayer   ; ��w���i�[�p
    #Temp$      ; �e���|�������X�g

    ;; ���[�J���萔�i�[�p
    Exp_F_View  ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
    Exp_FM_View ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
    Exp_FP_View ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p
    Exp_S_View  ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
    Exp_SM_View ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
    Exp_SP_View ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p

    Exp_Temp_Layer; �L�k��Ɨp��w���i�[�p
    Upper_Cab_Code ; �O���[�o���萔�p
    #LSYMDATA$
  )
	(setq CG_ORG_Layer$ nil);2017/04/17 YM ADD

  ;; �L�k�����J�n
  (CFOutStateLog 1 7 "      SKEExpansion=Start")
  ;T    ; return;
  ;;======================================================================
  ;; ���[�J���萔�̏�����(�����l���)
  ;;======================================================================
  (setq Upper_Cab_Code CG_SEIKAKU_UPPER)    ; �A�b�p�[�L���r�l�b�g���f�p���iCODE�ꗗ
  ;(setq Upper_Cab_Code '(4 12 13 51 57))   ; �A�b�p�[�L���r�l�b�g���f�p���iCODE�ꗗ

  (setq Exp_F_View '(0 -1 0))   ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_FM_View '(-1 0 0))  ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_FP_View '(1 0 0))   ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_S_View '(-1 0 0))   ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_SM_View '(0 1 0))   ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_SP_View '(0 -1 0))  ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p

  (setq Exp_Temp_Layer  "EXP_TEMP_LAYER") ; �L�k��Ɨp��w��

  ;; �L�k��Ɨp�e���|������w�̍쐬
  ; 00/12/22 SN MOD �e���|������w�����`�F�b�N
  (if (tblsearch "layer" Exp_Temp_Layer)
    (command "_layer"                    "C" 1 Exp_Temp_Layer "L" SKW_AUTO_LAY_LINE Exp_Temp_Layer "")
    (command "_layer" "N" Exp_Temp_Layer "C" 1 Exp_Temp_Layer "L" SKW_AUTO_LAY_LINE Exp_Temp_Layer "")
  )

  (setq #bCabFlag 0)

  ;;======================================================================
  ;; �V���{���� "G_LSYM" �g���f�[�^���擾����
  ;;======================================================================
  (setq #LSymData$ (CFGetXData &enSym "G_LSYM"))
  ;; "G_LSYM" �f�[�^���擾�ł������ǂ����̃`�F�b�N
  (if (/= #LSymData$ nil)
    (progn    ; �擾�ł���
      ;; �擾�����g���f�[�^�����]�p�x(nth 2)���擾����
      (setq #iRad (nth 2 #LSymData$))
      ;; �擾�����g���f�[�^����}���_(nth 1)���擾����
      ;; (setq #SymPos$ (nth 1 #LSymData$))
      (setq #SymPos$ (cdr (assoc 10 (entget &enSym)))) ;00/04/12 MOD MH

      ;;======================================================================
      ;; �V���{���� "G_SYM" �g���f�[�^���擾����
      ;;======================================================================
      (setq #SymData$ (CFGetXData &enSym "G_SYM"))

; 01/02/27 YM �̂��炠�����׸� #bCabFlag �𐳂�����Ă���ƐL�k���H�����Ɉړ����Ȃ��Ă������悤�ł���
  (if (and (/= (nth 9 #LSymData$) CG_SKK_INT_SNK)(= -1 (nth 10 #SymData$))) ; 01/03/01 YM DEL ; 01/08/31 YM MOD 410-->��۰��ى�
    (setq #bCabFlag 1) ; ���_
  );_if

      ;; "G_SYM" �f�[�^���擾�ł������ǂ����̃`�F�b�N
      (if (/= #SymData$ nil)
        (progn    ; �擾�ł���
          ;; �擾�����g���f�[�^���猻�݂� H �T�C�Y(nth 5)���擾����
          (setq #iHSize (nth 5 #SymData$))
          ;; �擾�����g���f�[�^���猻�݂� W �T�C�Y(nth 3)���擾����
          (setq #iWSize (nth 3 #SymData$))
          ;; �擾�����g���f�[�^���猻�݂� D �T�C�Y(nth 4)���擾����
          (setq #iDSize (nth 4 #SymData$))
          ;; �擾�����g���f�[�^���� H ����(nth 13)�̐L�k�����擾����
          (setq #iHExp (nth 13 #SymData$))
          ;; �擾�����g���f�[�^���� W ����(nth 11)�̐L�k�����擾����
          (setq #iWExp (nth 11 #SymData$))
          ;; �擾�����g���f�[�^���� D ����(nth 12)�̐L�k�����擾����
          (setq #iDExp (nth 12 #SymData$))
          ;;======================================================================
          ;; �V���{���̃f�[�^���擾����
          ;;======================================================================
          (setq #SymData$ (entget &enSym))
          ;; �V���{���̃O���[�v�����擾����
          (setq #enGroup (cdr (assoc 330 #SymData$)))

          ;;======================================================================
          ;; �O���[�v���f�[�^(�O���[�v�����X�g)���擾����
          ;;======================================================================
          (setq #GrpData$ (entget #enGroup))

          ;;======================================================================
          ;; 2D �}�`�ŐL�k�������s���f�[�^���i�荞�ށB�u���[�N���C���𒊏o����
          ;;======================================================================
          (foreach #nn #GrpData$
            ;; �O���[�v�\���}�`�����ǂ����̃`�F�b�N
            (if (= (car #nn) 340)
              (progn    ; �O���[�v�\���}�`��������
                ;; �O���[�v�\���}�`���̃f�[�^���擾����
                (setq #Temp$ (entget (cdr #nn)))
                ;; �O���[�v�\���}�`���\���b�h�f�[�^(0 . "3DSOLID")�ȊO���ǂ����̃`�F�b�N
;;                (if (and (/= (cdr (assoc 0 #Temp$)) "3DSOLID") (/= (cdr (assoc 0 #Temp$)) "XLINE"))
                (if (/= (cdr (assoc 0 #Temp$)) "XLINE")
                  (progn    ; �\���b�h�f�[�^�ł͂Ȃ�����
                    ;; ��w���̎擾
                    (setq #strLayer (cdr (assoc 8 #Temp$)))
                    ;; �}�`���Ɖ�w����1���X�g�ɂ��Ċi�[����(�}�`�� ��w��)
                    (setq #expData$ (cons (list (cdr #nn) #strLayer) #expData$))


                    ;;======================================================================
                    ;; �L�k�Ώ̐}�`��L�k������w�Ɉړ�����
                    ;;======================================================================
                    (entmod
                      (subst (cons 8 Exp_Temp_Layer) (assoc 8 #Temp$) #Temp$)
                    )
                  )
                )
                ;; �O���[�v�\���}�`���u���[�N���C�����ǂ����̃`�F�b�N
                (if (= (cdr (assoc 0 #Temp$)) "XLINE")
                  (progn    ; �u���[�N���C��������
                    ;; �u���[�N���C���̊g���f�[�^���擾
                    (setq #Temp$ (CFGetXData (cdr #nn) "G_BRK"))
                    ;; �g���f�[�^�����݂��邩�ǂ����̃`�F�b�N
                    (if (/= #Temp$ nil)
                      (progn    ; �g���f�[�^�����݂���
                        ;; H,W,D �e�u���[�N���C���̎�ޖ��ɐ}�`�����i�[����
                        (cond
                          ;; H �����u���[�N���C��������
                          ((= (nth 0 #Temp$) 3) (setq #BrkH$ (cons (cdr #nn ) #BrkH$)))
                          ;; W �����u���[�N���C��������
                          ((= (nth 0 #Temp$) 1) (setq #BrkW$ (cons (cdr #nn ) #BrkW$)))
                          ;; D �����u���[�N���C��������
                          ((= (nth 0 #Temp$) 2) (setq #BrkD$ (cons (cdr #nn ) #BrkD$)))
                        )
                      )
                    )
                  )
                )
              )
            )
          );foreach

					;��۰��ٕϐ��Ɋi�[
					(setq CG_ORG_Layer$ #expData$);���̉�w�i�[ 2017/04/17 YM ADD

          (if (and (= #BrkH$ nil) (= #BrkW$ nil) (= #BrkD$ nil))
            (progn
;;;             (CFAlertErr "���̃A�C�e���ɂ͐L�k���C��������܂���ł���") ; ���L�k���Ȃ�
              (princ "\n���̃A�C�e���ɂ͐L�k���C��������܂���ł���") ; ���L�k���Ȃ�
              (setq CG_NO_STRETCH T)
            )
          );_if

          ;;======================================================================
          ;; �L�k����
          ;;======================================================================
          ;; �����o�������̔��f
;04/12/01 YM ADD-S 10��ϲŽ16��̌덷����
          (cond
            ((equal #iRad 0 0.001) (setq #ViewZ$ Exp_F_View))
            ((< #iRad 0) (setq #ViewZ$ Exp_FM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_FP_View))
          )
;;;          (cond
;;;            ((= #iRad 0) (setq #ViewZ$ Exp_F_View))
;;;            ((< #iRad 0) (setq #ViewZ$ Exp_FM_View))
;;;            ((> #iRad 0) (setq #ViewZ$ Exp_FP_View))
;;;          )
;04/12/01 YM ADD-E

          ;; �L�k���s���T�C�Y�̃`�F�b�N(�A�b�p�[�L���r�l�b�g�̏ꍇ�� +- ���t�])
          (if (and (= #bCabFlag 1) (/= #iHExp 0))
            (progn
              ;// Modify S.Kawamoto
              ;(setq #iExpSize (list 1 (* (- #iHExp #iHSize) -1) 2))
              (setq #iExpSize (list 1 (- #iHExp #iHSize) 2))
            )
            ;; else
            (progn
              (setq #iExpSize (list 0 (- #iHExp #iHSize) 1))
            )
          )
          (if (and (/= #BrkH$ nil) (/= #iHExp 0))
            (progn
              ;; �u���[�N���C������_���牓�����Ƀ\�[�g����
              (setq #BrkH$ (SKESortBreakLine (list 2 #BrkH$) #SymPos$))
              ;; H �����̐L�k����
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkH$ #iExpSize)
              ;; ����I��
              (CFOutStateLog 1 7 "        SKEExpansion=H�u���[�N OK")
            )
            ;; else
            (progn
              ;; ����I��
              (CFOutStateLog 1 7 "        SKEExpansion=H�u���[�N�Ȃ�")
            )
          )

          (if (and (/= #BrkW$ nil) (/= #iWExp 0))
            (progn
              ;; �u���[�N���C������_���牓�����Ƀ\�[�g����
              (setq #BrkW$ (SKESortBreakLine (list 0 #BrkW$) #SymPos$))
              ;; W �����̐L�k����
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkW$ (list 2 (- #iWExp #iWSize)))
              ;; ����I��
              (CFOutStateLog 1 7 "        SKEExpansion=W�u���[�N OK")
            )
            ;; else
            (progn
              ;; ����I��
              (CFOutStateLog 1 7 "        SKEExpansion=W�u���[�N�Ȃ�")
            )
          )

          ;; �����o�������̔��f
          (cond
            ((= #iRad 0) (setq #ViewZ$ Exp_S_View))
            ((< #iRad 0) (setq #ViewZ$ Exp_SM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_SP_View))
          )
          (if (and (/= #BrkD$ nil) (/= #iDExp 0))
            (progn
              ;; �u���[�N���C������_���牓�����Ƀ\�[�g����
              (setq #BrkD$ (SKESortBreakLine (list 1 #BrkD$) #SymPos$))
              ;; D �����̐L�k����

              ; �����ʂ��猩�ĉE�����ɐL�k����̂ż���وʒu�͂����
;;;              (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 3 (- #iDExp #iDSize))) ; �ʂ邱�Ƃ͂Ȃ�
              ; �����ʂ��猩�č������ɐL�k����̂ż���وʒu�͂����
;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU T)
;--2011/07/21 A.Satoh Add - E
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 2 (- #iDExp #iDSize)))
;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU nil)
;--2011/07/21 A.Satoh Add - E
              ;; ����I��
              (CFOutStateLog 1 7 "        SKEExpansion=D�u���[�N OK")
            )
            ;; else
            (progn
              ;; ����I��
              (CFOutStateLog 1 7 "        SKEExpansion=D�u���[�N�Ȃ�")
            )
          )

          ;;======================================================================
          ;; �L�k��Ɖ�w���猳�̉�w�ɐ}�`�f�[�^���ړ�����
          ;;======================================================================
;-- 2011/07/21 A.Satoh Add - S
          ; �L�k���s���}�`���X�g���X�V����
          (if (/= nil CG_EXPDATA$)
            (foreach #nn #expData$
              (if (equal (nth 0 #nn) (nth 0 CG_EXPDATA$))
                (setq #expData$ (subst (list (nth 1 CG_EXPDATA$) (nth 1 #nn)) (list (nth 0 CG_EXPDATA$) (nth 1 #nn)) #expData$))
              )
            )
            (setq CG_EXPDATA$ nil)
          )
;-- 2011/07/21 A.Satoh Add - E

          (foreach #nn #expData$
            (setq #Temp$ (entget (nth 0 #nn) '("*")))
            (entmod
              (subst (cons 8 (nth 1 #nn)) (cons 8 Exp_Temp_Layer) #Temp$)
            )
          )
          ;; ����I��
          (CFOutStateLog 1 7 "      SKEExpansion=OK End")
          T   ; return;
        )
        ;; else
        (progn    ; �V���{���̊g���f�[�^���擾�ł��Ȃ�����
          ;; �ُ�I��
          (CFOutStateLog 0 7 "      SKEExpansion=\"G_SYM\"�g���f�[�^���擾�ł��܂���ł��� error End")
          nil   ; return;
        )
      )
    )
    ;; else
    (progn    ; �g���f�[�^���擾�ł��Ȃ�����
      ;; �ُ�I��
      (CFOutStateLog 0 7 "      SKEExpansion=\"G_LSYM\"�g���f�[�^���擾�ł��܂���ł��� error End")
      nil   ; return;
    )
  )
); SCEExpansion

;<HOM>*************************************************************************
; <�֐���>    : KP_TOKU_GROBAL_RESET
; <�����T�v>  : �������޺���ނ̈ꕔ��۰��ق�ر�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/09/25 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KP_TOKU_GROBAL_RESET ( / )
  (setq CG_DOOR_MOVE03 nil) ; 01/09/25 YM ADD
  (setq CG_DOOR_MOVE06 nil) ; 01/09/25 YM ADD
;;; (setq CG_DOOR_MOVE_RIGHT nil) ; 01/09/25 ���ړ����������ʂł͂Ȃ��A�������ĉE����
  (princ)
);KP_TOKU_GROBAL_RESET

;<HOM>*************************************************************************
; <�֐���>    : KPGetPrice
; <�����T�v>  : �i��,LR��n���Č��̉��i���������Ă�
; <�߂�l>    : ���i(������)
; <�쐬>      : 01/04/03 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KPGetPrice (
  &HINBAN ; �i��
  &LR     ; LR�敪
  /
  #HINBAN #LR #NAME1 #NAME2 #ORG_PRICE #QRY$ #SQL
  )
  (setq #HINBAN &HINBAN #LR &LR)
  (setq #sql (strcat "select * from �K�w where �K�w����='" #HINBAN "'"))
  (setq #qry$ (car (DBSqlAutoQuery CG_DBSESSION #sql)))
  (if (/= nil #qry$)
    (progn
      (setq #name1 (nth 5 #qry$)) ; ���i��
;-- 2011/08/18 A.Satoh Add - S
      (if (= #name1 nil)
        (setq #name1 "")
      )
;-- 2011/08/18 A.Satoh Add - E
      (setq #name2 (nth 6 #qry$)) ; ���l
;-- 2011/08/18 A.Satoh Add - S
      (if (= #name2 nil)
        (setq #name2 "")
      )
;-- 2011/08/18 A.Satoh Add - E
    )
    (progn
      (setq #name1 "")
      (setq #name2 "")
    )
  );_if

  (setq #ORG_price "0");���z�擾�͂܂��������Ă��Ȃ�

  (list #ORG_price #name1 #name2) ; ���i,�i��,���l
);KPGetPrice

;<HOM>*************************************************************************
; <�֐���>    : KPGetLastHinban
; <�����T�v>  : �i��,LR��n���čŏI�i�Ԃ��������Ă�
; <�߂�l>    : �ŏI�i��(������) or nil
; <�쐬>      : 02/03/21 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KPGetLastHinban (
  &HINBAN ; �i��
  &LR     ; LR�敪
  /
  #QRY$ #RET #HINBAN
  )
  ; 03/01/25 YM ADD-S
  ; &HINBAN ����[]���O���Ȃ����۱̨װ�̂Ƃ�MX�F������������Ȃ�
  (setq #HINBAN (KP_DelDrSeriStr &HINBAN))
  ; 03/01/25 YM ADD-E

  (setq #Qry$
    (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
      (list
        (list "�i�Ԗ���"   #HINBAN       'STR)
        (list "LR�敪"     &LR           'STR)
        (list "���V���L��" CG_DRSeriCode 'STR)
        (list "���J���L��" CG_DRColCode  'STR)
      )
    )
  )
  (if (and #Qry$ (= 1 (length #Qry$)))
    (setq #ret (nth 18 (car #Qry$)))
  );_if

  #ret
);KPGetLastHinban

;<HOM>*************************************************************************
; <�֐���>    : PcChkIntersect
; <�����T�v>  : ��̃\���b�h�}�`�ɏd�����镔�������邩�ǂ������f
; <�߂�l>    : T (�d���L��) or nil
; <�쐬>      : 00/04/20 MH
; <���l>      : �R�s�[�}�`���쐬���AIntersect���s&����
;*************************************************************************>MOH<
(defun PcChkIntersect (
  &e1 &e2     ; �}�`1 �}�`2
  /
  #eCPY1 #eCPY2 #en_kosu1 #en_kosu2 #RES
  )
  (setq #eCPY1 (entmakex (entget &e1)))
  (setq #eCPY2 (entmakex (entget &e2)))

  (setq #en_kosu1 (CMN_all_en_kosu)) ; �}�ʏ�ɂ���}�`�̑���
  ;;; �R�s�[���ꂽ�}�`�ǂ�����intersect���s
  (command "._intersect" #eCPY1 #eCPY2 "")
  (setq #en_kosu2 (CMN_all_en_kosu)) ; �}�ʏ�ɂ���}�`�̑���

  ;;; ������-1==>���ʕ�������   ������-2==>���ʕ����Ȃ�
  (if (= (- #en_kosu1 #en_kosu2) 2)
    (setq #RES nil)
    (progn
      (setq #RES 'T)
      (entdel (entlast))
    )
  );_if
  (setq #RES #RES)
); PcChkIntersect

;<HOM>*************************************************************************
; <�֐���>    : PcMakeFig$ByQLY
; <�����T�v>  : "�i�Ԑ}�`"��"�i�Ԋ�{"����I��}�`�f�[�^�̌`���̃��X�g���쐬����
; <�߂�l>    : ���X�g
; <�쐬>      : 00/05/30 MH
;*************************************************************************>MOH<
(defun PcMakeFig$ByQLY (
  &Z_QLY$ &K_QLY$ &iKAISO &stretch
  /
  #sID #RES$
  )
  ; �n���ꂽ�f�[�^����񃊃X�g���쐬����
  (setq #sID (nth 7 &Z_QLY$))
  (if (not #sID) (setq #sID ""))
  (setq #RES$
    (list
      (nth 0 &Z_QLY$) ; 01.�i�Ԗ���
      #sID            ; 02.�}�`ID
      &iKAISO         ; 03.�K�w�^�C�v
      (nth 3 &Z_QLY$) ; 04.�p�r�ԍ�
      (nth 1 &Z_QLY$) ; 05.L/R�敪
      (nth 4 &Z_QLY$) ; 06.���@W
      (nth 5 &Z_QLY$) ; 07.���@D
      (nth 6 &Z_QLY$) ; 08.���@H
      (fix (nth 3 &K_QLY$)) ; 09.���iCODE
      &stretch        ; 10.�L�k�t���O
      (nth 8 &Z_QLY$) ; 11.�W�JID
    )
  )
  #RES$
); PcMakeFig$ByQLY

;<HOM>*************************************************************************
; <�֐���>    : PcFig$Stretch
; <�����T�v>  : �I��}�`�f�[�^�̌`���̃��X�g��L�k�ɕύX
; <�߂�l>    : ���X�g
; <�쐬>      : 00/07/24 MH
;*************************************************************************>MOH<
(defun PcFig$Stretch (&FIG$ &W &D &H / #RES$)
  ; �l��nil�̕����͕ω����Ȃ�
  (setq #RES$
    (list
      (nth 0 &FIG$)   ; 01.�i�Ԗ���
      (nth 1 &FIG$)   ; 02.�}�`ID
      (nth 2 &FIG$)   ; 03.�K�w�^�C�v
      (nth 3 &FIG$)   ; 04.�p�r�ԍ�
      (nth 4 &FIG$)   ; 05.L/R�敪
      (if &W &W (nth 5 &FIG$))  ; 06.���@W
      (if &D &D (nth 6 &FIG$))  ; 07.���@D
      (if &H &H (nth 7 &FIG$))  ; 08.���@H
      (nth 8 &FIG$)   ; 09.���iCODE
      "Yes"           ; 10.�L�k�t���O
      (nth 10 &FIG$)  ; 11.�W�JID
    )
  )
  #RES$
); PcFig$Stretch

;<HOM>*************************************************************************
; <�֐���>    : PcJudgeItemSide
; <�����T�v>  : �^����ꂽ�A�C�e������ "L" "R" ����&�␳
; <�߂�l>    : "L" "R" nil
; <�쐬>      : 00/07/25 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcJudgeItemSide (
  &eBASE      ; ��A�C�e���}�`�� "CNT" "INS" �ȊO�ł�nil������
  &basePT$    ; ��A�C�e���̏�� (G_LSYM)
  &sMODE      ; "POS" "CNT" "INS" "CHG"  �g�p���̊֐��t���O
  &sLR        ; "L" "R" "T" "D"   "CNT"�ȊO�ł�nil������
  /
  #Lflg #Rflg #LRflg
  )
  ;;; "CNT" "INS" �̏ꍇ�A"L" "R"�̎w�����K�؂��ǂ������肳����
  ;;; LR���ʁA�ݒu�ʒu�͋󂢂Ă��邩�ǂ����`�F�b�N
  (setq #Lflg (PcChkItemNext &eBASE 1 0 0 0))
  (setq #Rflg (PcChkItemNext &eBASE 0 1 0 0))
  (cond
    ;;; �����ʂɐ}�`�����݂���Ȃ狭���I��
    ((and #Lflg #Rflg)
      (CFAlertMsg "�ݒu��̃A�C�e���͍��E�����ʂɑ��̃A�C�e�����אڂ��Ă��܂�")
      (exit)
    )
    ;;; �����E�̕Б��̂݋󂢂Ă���ꍇ�A���ꂪ�ݒ肳���B
    ((and #Lflg (not #Rflg)) (setq #LRflg "R"))
    ((and #Rflg (not #Lflg)) (setq #LRflg "L"))
    ;;; ���E���J���Ă���"CNT"��"L" "R"�Ȃ� #sLR�̕ύX�Ȃ�
    ((and (not #Lflg) (not #Rflg) (= "CNT" &sMODE) (or (= "L" &sLR) (= "R" &sLR)))
      (setq #LRflg &sLR)
    )
    (t (setq #LRflg "D"))
  ); cond
  #LRflg
); PcJudgeItemSide

;<HOM>*************************************************************************
; <�֐���>    : KcSetUniqueItem
; <�����T�v>  : �ݒu���ꏈ���A�C�e���ݒu
; <�߂�l>    : �ݒu�����}�`���B���ꏈ���ɓ��Ă͂܂鍀�ڂ��Ȃ����nil��Ԃ�
; <�쐬>      : 01-03-13 MH
; <���l>      : �����������̂� PcChk&SetUniqueItem �̎ʂ��Ŏg�p����\���L�邩��
;*************************************************************************>MOH<
(defun KcSetUniqueItem (
  &sMODE      ; "POS" "CNT" "INS" "CHG" �g�p���̊֐��t���O
  &FIG$       ; SELPARTS.CFG �̓��e���X�g
  &eBASE      ; ��}�` ("CNT" "INS" �ȊO�� nil)
  &sDIR       ; "L" "R" "D" "T"  ("CNT" "INS" �ȊO�ł� nil)
  &eCHG       ; "CHG"���[�h��p �ύX���}�`
  /
  #en #HINBAN #SKK
  #fig$ ; �ؐ�������Ή�
  )

  (setq #hinban (nth 0 &FIG$))
  (setq #skk    (nth 8 &FIG$))

  (cond
    ;;;���� ���� ���iCODE510
    ((and (= "POS" &sMODE) (= CG_SKK_INT_SUI #skk)) ; 01/08/31 YM MOD 510-->��۰��ى�
      (setq #en (PcSetWaterTap &FIG$))
      ; �g���ް� "G_OPT" �Z�b�g 2017/09/08 YM ADD
      (KcSetG_OPT #en)
    )
    ;2011/007/19 YM ADD ������
    ((and (= "POS" &sMODE) (CheckSpSetBuzai #hinban "�����z�u���") )
      (setq #en (PcSetSpBuzai &FIG$ 11))
      ; �g���ް� "G_OPT" �Z�b�g 2017/09/08 YM ADD
      (KcSetG_OPT #en)
    )
    ;2011/007/19 YM ADD ��׽�߰è���
    ((and (= "POS" &sMODE) (CheckSpSetBuzai #hinban "�K���X�z�u���") )
			(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
				(progn
					nil ;�������Ȃ�
				)
				(progn
					(CFAlertMsg "�G���W�j�A�h�X�g�[���ŃK���X�p�[�e�[�V���������t������A\n�V������i�Ԃɂ��Ă��������B")
				)
			);_if
      (setq #en (PcSetSpBuzai &FIG$ 12))
      ; �g���ް� "G_OPT" �Z�b�g 2017/09/08 YM ADD
      (KcSetG_OPT #en)
    )
    (t
      (setq #en nil)
    )
  );cond

;;;2011/07/19YM@DEL  (setq #en (cond
;;;2011/07/19YM@DEL    ;;;���� ���� ���iCODE510
;;;2011/07/19YM@DEL    ((and (= "POS" &sMODE) (= CG_SKK_INT_SUI (nth 8 &FIG$))) ; 01/08/31 YM MOD 510-->��۰��ى�
;;;2011/07/19YM@DEL      (PcSetWaterTap &FIG$)
;;;2011/07/19YM@DEL    )
;;;2011/07/19YM@DEL    (t nil)
;;;2011/07/19YM@DEL  )); setq cond

  #en
);KcSetUniqueItem

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcSetSpBuzai
;;; <�����T�v>  : ��׽�߰è��ݐݒu����
;;; <�߂�l>    : �ݒu�����}�`��
;;; <�쐬>      : 2011/07/19 YM ADD
;;; <���l>      : P�_ 12 ��׽�߰è��ݔz�u�_�ɐԁ{���\�����X�i�b�v����
;;;*************************************************************************>MOH<
(defun PcSetSpBuzai (
  &selPT$     ; �ݔ����ނ̏��
  &pten_no    ; �z�u�Ώۂo�_�ԍ�(11:����,12:��׽�߰è���)
  /
  #DIS #DPT #EN #FH #I #II #LOOP #O #O1 #O2 #O3 #O4 #OK #OMD #PTEN$ #RET$ #SH #SNAP
  #TSEKISAN #UNIT #WORKP$ #XD_PTEN$
  )
  (setq #workP$ nil #pten$ nil #xd_pten$ nil)
  ;// �R�}���h�̏�����
  (StartUndoErr)

  ; ���݂�O�X�i�b�v�A�_���[�h�A �_�T�C�Y �擾
  (setq #oMD (getvar "OSMODE"))

  (setq #ret$ (KPGetPTEN &pten_no));����=P�_�ԍ�
  (setq #pten$    (car  #ret$))    ; PTEN?�}�`ؽ�
  (setq #xd_pten$ (cadr #ret$))    ; "G_PTEN"ؽ�

  ; �擾���ꂽP�_�̍��W�ɉ��_��ł�
  (foreach #pten #pten$
    (setq #o (cdr (assoc 10 (entget #pten))))

    ;2011/07/19 YM MOD �_�̍�}�ł͂Ȃ���
    (setq #ret$ (GetPlusLinePT #o)); #o�𒆐S�Ɂ{�̐��������Ƃ��̎n�_�A�I�_��Ԃ�
    (setq #o1 (nth 0 #ret$))
    (setq #o2 (nth 1 #ret$))
    (setq #o3 (nth 2 #ret$))
    (setq #o4 (nth 3 #ret$))

    (entmake
      (list
        (cons   0 "LINE")
        (cons 100 "AcDbEntity")
        (cons 100 "AcDbPoint")
        (cons  10 #o1)
        (cons  11 #o2)
        (cons  62 1)
      )
    )
    (setq #workP$ (append #workP$ (list (entlast)))) ; ���_�}�`ؽ�(��ō폜�����)

    (entmake
      (list
        (cons   0 "LINE")
        (cons 100 "AcDbEntity")
        (cons 100 "AcDbPoint")
        (cons  10 #o3)
        (cons  11 #o4)
        (cons  62 1)
      )
    )
    (setq #workP$ (append #workP$ (list (entlast)))) ; ���_�}�`ؽ�(��ō폜�����)
  );_foreach

  (setvar "OSMODE" 32)

;;; �z�u�_�擾(���[�U�[�ɐ}���o�����Ċp�x��t��������)
  (setq #OK T #loop T)

  ; 02/07/10 YM ADD-S �ů��Ӱ��OFF
  (setq #snap (getvar "SNAPMODE"))
  (setvar "SNAPMODE" 0)

  (while #OK

    (setq #dPT (getpoint "\n�ݒu�_���w��: \n"));հ�ް�w��_

    (setq #i 0)
    (while (and #loop (< #i (length #pten$)))
      (setq #o (cdr (assoc 10 (entget (nth #i #pten$)))))
      (setq #dis (distance #o #dPT))
      (if (< #dis 0.1)
        (setq #ii #i #OK nil #loop nil) ; ���Ԗڂ�PTEN5���H
      );_if
      (setq #i (1+ #i))
    );_foreach

    (if #OK ; PTEN���I�����Ȃ�����
      (progn

        (CFAlertMsg "���_�ȊO�̈ʒu�ɐݒu���܂�.")

        (setq #sH (KCFGetWTHeight))
        (if (= #sH nil)(setq #sH "0")) ; 01/06/26 YM ADD �}�ʂɉ����Ȃ��Ƃ�#sH=nil�ŗ�����
        (setq #fH (getreal (strcat "����<" #sH ">: ")))
        (if (= nil #fH)
          (setq #fH (atof #sH))
        )
        (setq #dPT (list (car #dPT) (cadr #dPT) #fH))
        (setq #OK nil)
      )
    );_if

  );while

  ; 02/07/10 YM ADD-S �ů��Ӱ��OFF
  (setvar "SNAPMODE" #snap)

  ;;; ���X�g�̓_�폜
  (foreach #P #workP$ (entdel #P))

  ; �ݒu���s
  (setq #en (PcInsSuisen&SetX #dPT &selPT$ #tSEKISAN))

  ; O�X�i�b�v�A�_���[�h�A �_�T�C�Y �����ɖ߂�
  (setvar "OSMODE" #oMD)
  (setq *error* nil)

  (if (= #unit "T");�u�Ƌ�v�������ꍇ ;06/08/23 YM
    (princ "\n�����z�u���܂����B")
    (princ "\n������z�u���܂����B")
  );_if

  #en
);PcSetSpBuzai


;<HOM>*************************************************************************
; <�֐���>    : CheckSpSetBuzai
; <�����T�v>  : �����̕i�Ԃ���׽�߰è��� or �������ǂ������肷��
; <�߂�l>    : T or nil
; <�쐬>      : 2011/07/19 YM ADD
; <���l>      : �Q��ð��� = "�K���X�z�u���","�����z�u���"
;               �ذ���ݔz�u�����ꏈ��
;*************************************************************************>MOH<
(defun CheckSpSetBuzai (
  &hinban
  &table
  /
  #HINBAN #QRY$ #RET
  )
  (setq #ret nil)
  
  (setq #Qry$
    (CFGetDBSQLRec CG_DBSESSION &table
      (list
        (list "�i�Ԗ���"   &hinban       'STR)
      )
    )
  )
  (if #Qry$
    (setq #ret T)
    ;else
    (setq #ret nil)
  );_if

  #ret
);CheckSpSetBuzai

;;;<HOM>***********************************************************************
;;; <�֐���>    : PcChgG_LSYMPntData
;;; <�����T�v>  : G_SYM�̍��W���X�g��ύX
;;; <�߂�l>    : ��_�}�`��
;;; <�쐬>      : 00-12-21 MH
;;; <���l>      :
;;;***********************************************************************>MOH<
(defun PcChgG_LSYMPntData (
  &eEN          ; G_SYM�}�`��
  &dNEW$        ; �_ �X�V���e���X�g
  /
  #xd$ #i #xd #newLSYM$
  )
  ; �g���f�[�^"G_LSYM"���̍��W�l��ύX
  (setq #xd$ (CFGetXData &eEN "G_LSYM"))
  (setq #i 0)
  (foreach #xd #xd$
    (if (= #i 1)
      (setq #newLSYM$ (append #newLSYM$ (list &dNEW$)))
      (setq #newLSYM$ (append #newLSYM$ (list #xd)))
    ); if
    (setq #i (1+ #i))
  ); foreach
  (CFSetXData &eEN "G_LSYM" #newLSYM$)
  &eEN
); PcChgG_LSYMPntData

;<HOM>*************************************************************************
; <�֐���>    : PcMoveItem
; <�����T�v>  : �A�C�e��������_����w�肳�ꂽ���W�Ɉړ��G_LSYM���̍��W�l��ύX
; <�߂�l>    : �}�`��
; <�쐬>      : 01/01/26 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcMoveItem (
  &eEN        ; G_LSYM �����}�`��
  &dMOV$      ; �ړ���_���W
  /
  #eEN #dORG$ #dNEW$)
  (setq #eEN &eEN)
  (setq #dORG$ (cdr (assoc 10 (entget #eEN))))
  (if (= 'LIST (type &dMOV$)) (progn
    (command "_move" (CFGetSameGroupSS #eEN) "" #dORG$ &dMOV$)
    (setq #dNEW$ (cdr (assoc 10 (entget #eEN))))
    (PcChgG_LSYMPntData #eEN #dNEW$)
  )); if progn
  #eEN
);PcMoveItem

;<HOM>*************************************************************************
; <�֐���>    : PcMoveItem2P
; <�����T�v>  : �A�C�e�����Q�_�Ԃňړ�������ړ������� G_LSYM���̍��W�l��ύX
; <�߂�l>    : �}�`��
; <�쐬>      : 01/01/26 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcMoveItem2P (
  &eEN        ; G_LSYM �����}�`��
  &dORG$      ; �ړ�����_���W
  &dMOV$      ; �ړ����_���W
  / #eEN #dNEW$)
  (setq #eEN &eEN)
  (if (and (= 'LIST (type &dORG$))(= 'LIST (type &dMOV$)))
    (progn
      (command "_move" (CFGetSameGroupSS #eEN) "" &dORG$ &dMOV$)
      (setq #dNEW$ (cdr (assoc 10 (entget #eEN))))
      (PcChgG_LSYMPntData #eEN #dNEW$)
    ); progn
  ); if
  #eEN
);PcMoveItem

;<HOM>*************************************************************************
; <�֐���>    : KcMoveToSGCabinet
; <�����T�v>  : �A�C�e�����̑��ʐ}�ړ����K�v���ǂ������肵�Ď��s
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/04/06 MH
; <���l>      : ����̓R�������������A�������s���\���͂���B
;*************************************************************************>MOH<
(defun KcMoveToSGCabinet (&eEN / #XL$ #FLG #enD$ #enD #cabXL$)
  ;; �R�������ʈړ� �z�u���ꂽ�̂��R�����Ŕ͈͂Ƀh���b�v�C���L���r�����݂���ꍇ
  (if (and (= 'ENAME (type &eEN)) (setq #XL$ (CFGetXData &eEN "G_LSYM")))(progn
    (cond
      ; �A�C�e�����R�����������ꍇ
      ((= (SKY_DivSeikakuCode (nth 9 #XL$) 1) CG_SKK_ONE_GAS)
        (setq #FLG 'T)
        (setq #enD$ (PcGetEn$CrossArea &eEN 0 0 0 0 'T))
        ;; �͈͂Ƀh���b�v�C���L���r�l�b�g�͂��邩�H
        (while (and #FLG (setq #enD (car #enD$)))
          (setq #cabXL$ (CFGetXData #enD "G_LSYM"))
          (if (and (= (SKY_DivSeikakuCode (nth 9 #cabXL$) 3) CG_SKK_THR_GAS)
                   (equal (read (angtos (nth 2 #cabXL$) 0 3))
                          (read (angtos (nth 2 #XL$) 0 3)) 0.01)
              )(progn
            (PKC_MoveToSGCabinetSub &eEN #enD)
            (setq #FLG nil)
          )); progn if
          (setq #enD$ (cdr #enD$));if progn
        ); while
      )
    ); cond
  )); if progn
  (princ)
); KcMoveToSGCabinet

;;;<HOM>***********************************************************************
;;; <�֐���>    : KcChgG_LSYMSecNo
;;; <�����T�v>  : G_LSYM���̒f�ʂ̗L���l��ύX Xrecord ��"DANMENSYM"�ɔ��f
;;; <�߂�l>    : ��_�}�`��
;;; <�쐬>      : 01/04/16  MH
;;; <���l>      :
;;;***********************************************************************>MOH<
(defun KcChgG_LSYMSecNo (
  &eEN          ; G_SYM�}�`��
  &iSEC         ; �f�ʂ̗L�� 0 or 1
  /
  #xld$ #i #xl #newLSYM$
  )
  ; �g���f�[�^"G_LSYM"���̒f�ʂ̗L���l��ύX
  (setq #xld$ (CFGetXData &eEN "G_LSYM"))
  (setq #i 0)
  (foreach #xl #xld$
    (if (= #i 14)
      (setq #newLSYM$ (append #newLSYM$ (list &iSEC)))
      (setq #newLSYM$ (append #newLSYM$ (list #xl)))
    ); if
    (setq #i (1+ #i))
  ); foreach
  (CFSetXData &eEN "G_LSYM" #newLSYM$)
  (KcSetDanmenSymXRec &eEN);  Xrecord ��"DANMENSYM" �ύX 01/04/24 MH
  &eEN
); KcChgG_LSYMSecNo

;;;<HOM>***********************************************************************
;;; <�֐���>    : KcSetDanmenSymXRec
;;; <�����T�v>  : G_LSYM���̒f�ʂ̗L���ɉ����� Xrecord��"DANMENSYM" �ύX
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/04/24 MH
;;; <���l>      :
;;;***********************************************************************>MOH<
(defun KcSetDanmenSymXRec (
  &eEN          ; G_SYM�}�`��
  /
  #xld$ #HDL$ #HD #iSEC #TEMP$
  )
  ; "G_LSYM"���̒f�ʂ̗L���l���擾
  (setq #xld$ (CFGetXData &eEN "G_LSYM"))
  (if #xld$ (setq #iSEC (nth 14 #xld$)))
  ; Xrecord �Ǘ�
  (setq #HDL$ (CFGetXRecord "DANMENSYM"))
  (setq #HD (cdr (assoc 5 (entget &eEN))))
  (cond
    ; �f�ʂ̗L��= 1 ,������ Xrecord "DANMENSYM"�ɖ����ꍇ�͒ǉ�
    ((and (= 1 #iSEC) (not (member #HD #HDL$)))
      (setq #HDL$ (cons #HD #HDL$))
      (CFSetXRecord "DANMENSYM" #HDL$)
    )
    ; �f�ʂ̗L��= 0 ,������ Xrecord "DANMENSYM"�ɂ���ꍇ�͏���
    ((and (= 0 #iSEC) (member #HD #HDL$))
      (setq #TEMP$ nil)
      (foreach #CHK #HDL$ (if (not (equal #CHK #HD)) (setq #TEMP$ (cons #CHK #TEMP$))))
      (setq #HDL$ #TEMP$)
      (CFSetXRecord "DANMENSYM" #HDL$)
    )
  ); cond
  (princ)
); KcSetDanmenSymXRec

;<HOM>*************************************************************************
; <�֐���>    : PcGetNumOfUcab
; <�����T�v>  : �}���̃E�H�[���L���r�̐����Z�o
; <�߂�l>    : �����l
; <�쐬>      : 00/05/29 MH ADD
;*************************************************************************>MOH<
(defun PcGetNumOfUcab ( / #ss #i #iSE #iRES)
  (setq #iRES 0)
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if #ss (progn
    (setq #i 0)
    (repeat (sslength #ss)
      (setq #iSE (nth 9 (CFGetXData (ssname #ss #i) "G_LSYM")))
      (if (and (= (SKY_DivSeikakuCode #iSE 1) CG_SKK_ONE_CAB)
               (= (SKY_DivSeikakuCode #iSE 2) CG_SKK_TWO_UPP))
        (setq #iRES (1+ #iRES))
      )
      (setq #i (1+ #i))
    ); end of repeat
  )); if progn
  #iRES
); PcGetNumOfUcab

;<HOM>*************************************************************************
; <�֐���>    : PcSetItem
; <�����T�v>  : PcParts.lsp �����ʂ̃A�C�e���ݒu
; <�߂�l>    : �ݒu���ꂽ�}�`��
; <�쐬>      : 00/06/30 MH
; <���ʕ�>   �@���փ��[�h�Ȃ�΁A���T�C�Y�擾�A�אڎ擾�A���}�`�폜
;            �A�ݒu���[�h�Ȃ�ΐݒu�����ݒ�
;            �BH800�����p�Ƀt���O�ݒ�
;            �C�}�`�}���A�����A�O���[�v���A�f�[�^�Z�b�g
;            �D�}�����[�h�̏ꍇ�ADB��GSYM��W���̕␳ �ړ�
;            �E�K�v�Ȃ�WDH�L�k
;            �F���ʏ���
;            �GH800�̍�����������
;            �H���Ӑ}�`�ړ�
;            �I�g���f�[�^"G_OPT"�Z�b�g
;            �J��A�C�e���ڍs
;*************************************************************************>MOH<
(defun PcSetItem (
  &sMODE      ; "POS" "CNT" "INS" "CHG" "SET" �g�p���̊֐��t���O
  &sDIR       ; "L" "R" "D" "T"  ("CNT" "INS" �ȊO�ł� nil)
  &FIG$       ; SELPARTS.CFG �̓��e���X�g
  &dINS       ; �}���_                    ("POS"�Ȃ�nil)
  &fANG       ; �}���p�x(���W�A��)        ("POS"�Ȃ�nil)
  &eBASE      ; ��}�`                  ("CNT" "INS" �ȊO�� nil)
  &eCHG       ; ����ւ����}�`            ("CHG"�݂̂Ŏg�p)
  /
  #FIG$ #xd$ #baseWDH$ #chgWDH$ #eNEXT$ #sHIN #fname #flg #elv #elv2 #height
  #posZ #fANG #dINS #ss #eNEW #MOV #QLY$ #ss_H800 #en_lis_#ss #B_Hflag #F_Hflag
  #newH #basH #cntZ #fMOVE #mov #eBASE #gsymxd$ #bpt #type #fHmov
  #LASTPT #LASTZ #HMOVEFLG #OS #OT #SM #chgSEC
  #sCd        ; ���iCODE
;-- 2011/10/03 A.Satoh Add - S
  #en_syoku #move #dep #qry$$ #oku
;-- 2011/10/03 A.Satoh Add - E
;-- 2011/10/31 A.Satoh Add - S
#LXD$ #pt #ANG #gnam #eDelBRK_W$ #eDelBRK_D$ #eDelBRK_H$
#XLINE_W #XLINE_D #XLINE_H #eD #BrkW #BrkD #BrkH
;-- 2011/10/31 A.Satoh Add - E
#STR_FLG	;-- 2011/11/24 A.Satoh Add
#alert_f #msg_str #BrkW_str #BrkD_str #BrkH_str ;--2011/12/19 A.Satoh Add
;-- 2012/02/16 A.Satoh Add CG�Ή� - S
#hinban #qry$ #org_size$ #BrkW2 #BrkD2 #BrkH2 #XLINE_W$ #XLINE_D$ #XLINE_H$
#idx #dist #BRKLINED$ #BRKLINEH$ #BRKLINEW$
;-- 2012/02/16 A.Satoh Add CG�Ή� - E
#W_f #D_f #H_f #chk  ;-- 2012/02/22 A.Satoh Add
  )
  (setq #sCd (fix (nth 8 &fig$))) ; 01/06/17 HN ADD

  (setq #FIG$ &FIG$)
  (setq #sHIN (car &FIG$))
  (setq #dINS &dINS)
  (setq #fANG &fANG)
  (setq #eBASE &eBASE)
  (if (or (= &sMODE "CNT") (= &sMODE "INS")) (progn
    (setq #xd$ (CFGetXData #eBASE "G_SYM"))
    (setq #baseWDH$ (list (nth 3 #xd$) (nth 4 #xd$) (nth 5 #xd$)))
  )); if progn

;-- 2011/11/09 A.Satoh Add - S
		; �O���[�o���ϐ������ɖ߂�
		(setq CG_BASE_UPPER nil)
;-- 2011/11/09 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
		; �O���[�o���ϐ������ɖ߂�
		(setq #STR_FLG nil)
		(setq CG_POS_STR nil)
		(setq CG_TOKU nil)
;-- 2011/11/24 A.Satoh Add - E

;-- 2012/02/22 A.Satoh Add - S
	(setq #chk (list nil nil nil))
	(setq #W_f nil)
	(setq #D_f nil)
	(setq #H_f nil)
;-- 2012/02/22 A.Satoh Add - E

  ; �@���փ��[�h�̏ꍇ  ���ւ����T�C�Y�擾�A�אڎ擾�A���}�`�폜
  (if (= &sMODE "CHG") (progn
    (setq #xd$ (CFGetXData &eCHG "G_SYM"))
    (setq #chgWDH$ (list (nth 3 #xd$) (nth 4 #xd$) (nth 5 #xd$)))
    (setq #chgSEC (nth 14 (CFGetXData &eCHG "G_LSYM"))); 01/04/16 MH ADD
    ;;; ���}�`���ɗא�(�Ȃ���ΉE)����}�`����}�`�Ƃ��Ď擾
    (setq #eBASE (car (PcChkItemNext &eCHG 1 0 0 0))) ; ���א�
    (if (not #eBASE) (setq #eBASE (car (PcChkItemNext &eCHG 0 1 0 0)))) ; �E�א�
    ;;; �ړ��Ώې}�`�̃��X�g�i���}�`�ɗאڂ���j���擾������
    (setq #eNEXT$ (PcGetNextMoveItem$ &eCHG nil))
;;;01/02/05YM@    ;;; ���}�`�폜���s
;;;01/02/05YM@    (command "_erase" (CFGetSameGroupSS &eCHG) "") ; ���}�` &eCHG
    ;;; ���}�`=��A�C�e���������Ƃ��̑΍�(���̂��Ȃ���΂w���R�[�h��������)
    (if (and (CFGetBaseSymXRec) (not (entget (CFGetBaseSymXRec))))
      (ResetBaseSym))               ;00/09/25 SN MOD
      ;(CFSetXRecord "BASESYM" nil));00/09/25 SN MOD
  )); if progn

  ; �A�ݒu���[�h�Ȃ�ΐݒu�����ݒ�
  ; "POS" �̂ݍ����ݒ�  00/07/31 MOD MH �����w�菈�����ŏ��̏����Ɉړ�
  (if (= &sMODE "POS") (progn
    ; "POS"�͏��߂Ă̍�}�̉\�������邽�߁A��}�p�̉�w�ݒu
    (MakeLayer "Z_00_00_00_01" 7 "CONTINUOUS") ; 05/12 MH ADD

    (setq #elv (getvar "ELEVATION"))
    (cond
      ((= (SKY_DivSeikakuCode (nth 8 #FIG$) 2) CG_SKK_TWO_UPP)
        (setvar "ELEVATION" CG_UpCabHeight)
      )
      (t (setvar "ELEVATION" 0))
    )
    (setq #elv2 (getvar "ELEVATION"))

    (if CG_TESTMODE ; 01/05/23 YM �����z�uýĒ�
      (setq #height 0.0)
      (setq #height (getreal (strcat "����<" (itoa (fix #elv2)) ">: ")));00/06/27 SN MOD
    );_if

    (if (= #height nil)
      (progn (setvar "ELEVATION" #elv2)
             (setq #posZ #elv2))
      (progn (setvar "ELEVATION" #height)
             (setq #posZ #height))
    ); if
  )); if progn

  ; �BH800�����p�Ƀt���O�ݒ�
  (setq #flg nil) ; 01/01/12 YM

  ; �C�}�`�}��
  (setq #fname (strcat (cadr #FIG$) ".dwg"))
  (Pc_CheckInsertDwg #fname CG_MSTDWGPATH); �}���\���ID�t�@�C�����쐬&�`�F�b�N
  (if (= &sMODE "POS")
    ; "POS" �̂ݑ}���_���[�U���w��
    (progn

    (if CG_TESTMODE
      (progn ; 01/05/23 YM �����z�uýĒ�
        (command ".insert" (strcat CG_MSTDWGPATH #fname) (list CG_TEST_X CG_TEST_Y 0) 1 1 0) ; 2009
        (setq #fANG 0)
        (setq #lastpt '(0 0 0))
      )
      (progn ; �ʏ�
        (princ "\n�}���_: ")                                          ; 01/01/29 YM DEL
        (command ".insert" (strcat CG_MSTDWGPATH #fname) pause) ; 2009
          (command 1 1);2009

        ; 01/01/29 YM ADD START
  ;;;     (setq #bpt (getpoint "\n�}���_: "))
  ;;;     (setq #bpt (list (car #bpt)(cadr #bpt) #posZ))
  ;;;      (command ".insert" (strcat CG_MSTDWGPATH #fname) #bpt "" "")
        ; 01/01/29 YM ADD END
        (princ "\n�z�u�p�x<0>: ")
        (command pause)
        (setq #fANG (cdr (assoc 50 (entget (entlast)))))

        ; 01/02/08 YM START
        (setq #lastpt (getvar "LASTPOINT"))
      )
    );_if

      (setq #lastZ (caddr #lastpt))
      (if (equal #lastZ #posZ 0.001) ; �����ײݎw�荂���ƈႤ�Ȃ�ړ�����
        (princ)
        (progn
;;; ���ѕϐ��ݒ� 01/04/09 YM �ꎞ����
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
          (command "_move" (entlast) "" '(0 0 0) (list 0 0 (- #posZ #lastZ)))
;;; ���ѕϐ��ݒ� 01/04/09 YM
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)

        )
      );_if
      ; 01/02/08 YM END

      ; �����������ɐL�k�̂���}�`�������ꍇ�A�L�k���ړ�
      (if (and #HmoveFLG (/= 0 (setq #mov (- (nth 7 &FIG$) (nth 7 #FIG$)))))
        (command "_move" (entlast) "" '(0 0 0) (list 0 0 #mov))
      )
    ); progn
    ; "POS" �ȊO�͈����̓_�ŏo��
    (command "_insert" (strcat CG_MSTDWGPATH #fname) #dINS 1 1 (rtd #fANG));2009
  ); if

;-- 2011/10/03 A.Satoh Add - S
  ; �A����z�u�ŐH��ł���ꍇ
  (if (and (= &sMODE "CNT") (= &sDIR "T"))
    (progn
      (setq #en_syoku (entlast))
      (if (= #sCd 110)
        (if (= BU_CODE_0009 "1")
          (if (= "Q" (substr (nth 5 (CFGetXData &eBASE "G_LSYM")) 9 1))
            (progn
              (setq #move "0,-50,0")
              (command "_.MOVE" #en_syoku "" "0,0,0" #move)
            )
          )
          (progn
            (setq #dep (nth 4 (CFGetXData &eBASE "G_SYM")))
            (setq #qry$$
              (CFGetDBSQLRec CG_DBSESSION "���s"
                (list
                  (list "���s" (itoa (fix (+ #dep 0.01))) 'INT)
                )
              )
            )
            (if (and #qry$$ (= 1 (length #qry$$)))
              (setq #oku (nth 1 (nth 0 #qry$$)))
              (setq #oku "?")
            )
            (if (or (= #oku "D900") (= #oku "D700"))
              (progn
                (setq #move "0,-50,0")
                (command "_.MOVE" #en_syoku "" "0,0,0" #move)
              )
            )
          )
        )
      )
    )
  )
;-- 2011/10/03 A.Satoh Add - E

  ; HOPE-0313 00/12/07 MH MOD (���s�ʒu�ύX) �{�H������������̂�h��
;;;  (command "._shademode" "H") ; 01/01/29 YM ADD
  (command "_.layer" "F" "Z_*" "") ; 01/01/29 YM ADD
  (command "_.layer" "T" "Z_00*" "") ; 01/01/29 YM ADD
  (command "_.layer" "T" "Z_KUTAI" "") ; 01/02/20 YM ADD

  ; �C�}�` �����A�O���[�v���A�f�[�^�Z�b�g
  (command "_explode" (entlast))
  (setq #ss (ssget "P"))
  ; "CHG"���[�h�Ń��[�U���ύX��No�Ȃ炱����Undo�I��
  (if (= &sMODE "CHG") (command "_change" #ss "" "P" "C" "RED" ""))
;-- 2011/12/05 A.Satoh Mod - S
;;;;;  (if (and (= &sMODE "CHG") (not (CFYesNoDialog "�ύX���Ă�낵���ł����H")))
  (if (and (= &sMODE "CHG") (= CG_REGULAR nil) (not (CFYesNoDialog "�ύX���Ă�낵���ł����H")))
;-- 2011/12/05 A.Satoh Mod - E
    (command "_undo" "b")
  ; �ȉ�CHG"���[�h �����ȊO
    (progn
;;;01/02/05YM@      (if (= &sMODE "CHG") (command "_change" #ss "" "P" "C" "BYLAYER" ""))
      (SKMkGroup #ss) ;���������}�`�Q�Ŗ��O�̂Ȃ��O���[�v�쐬
      (command "_layer" "u" "N_*" "")

      (setq #eNEW (SearchGroupSym (ssname #ss 0))) ; ����ِ}�` #eNEW
      ; "POS" �͂����ŏ��߂đ}���_���W������
      (if (= &sMODE "POS") (setq #dINS (cdr (assoc 10 (entget #eNEW)))))
      (SKY_SetZukeiXData #FIG$ #eNEW #dINS #fANG)
;;;01/09/03M@DEL      (if (= 1 #chgSEC)(KcChgG_LSYMSecNo #eNEW 1)); 01/04/16 MH MOD ���ւ�����2�d�ɾ�Ă��邱�ƂɂȂ�! �����ł�G_LSYM��Ă��Ȃ�

;;; @@@ ��Ű����"115"��PMEN2�̒��_������������ 01/04/11 YM ADD START
      (if (CheckSKK$ #eNEW (list (itoa CG_SKK_ONE_CAB) "?" (itoa CG_SKK_THR_CNR))) ; ��Ű���� ; 01/08/31 YM MOD ��۰��ى�
        (KP_MakeCornerPMEN2 #eNEW)
      );_if
;;; @@@ ��Ű����"115"��PMEN2�̒��_������������ 01/04/11 YM ADD END

; 02/01/09 �D�ƇE�̏��Ԃ����ւ����āA�␳�ړ��͓��̓R�[�h�Ɋւ�炸�s�� ---------------------------------------------------------------------------

;;;02/01/09YM@MOD      ; �D�}�����[�h�̏ꍇ�ADB��G_SYM�̍�����␳
;;;02/01/09YM@MOD      ;   00/06/21MH ADD SelParts.cfg����L�k��Ƃ��s���ꍇ�␳�����Ȃ�
;;;02/01/09YM@MOD      (if (and (wcmatch &sMODE "CNT,INS,CHG")
;;;02/01/09YM@MOD            (not (and (findfile (strcat CG_SYSPATH "SELPARTS.CFG"))
;;;02/01/09YM@MOD                      (< 0 (nth 11 (PcGetPartQLY$  "�i�Ԋ�{" #sHIN nil nil))); ���ͺ���
;;;02/01/09YM@MOD          ))); if����
;;;02/01/09YM@MOD        (progn
;;;02/01/09YM@MOD          ; ��ʂv���� �␳ ; "L" �����}���ŁAW�l�ɍ���������
;;;02/01/09YM@MOD          (if (and (= &sDIR "L")
;;;02/01/09YM@MOD            (/= 0 (setq #MOV (- (nth 5 #FIG$) (nth 3 (CFGetXData #eNEW "G_SYM")))))) ; W ���m��r
;;;02/01/09YM@MOD            (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS (Pcpolar #dINS #fANG #MOV))
;;;02/01/09YM@MOD          );if
;;;02/01/09YM@MOD          ; ���p�L���r "R" �����}���ŁAD�l�ɍ��������� ���ꏈ��
;;;02/01/09YM@MOD          (if (and (= (CFGetSymSKKCode #eNEW 3) CG_SKK_THR_CNR)
;;;02/01/09YM@MOD                   (= &sDIR "R")
;;;02/01/09YM@MOD                   (/= 0 (setq #MOV (- (nth 6 #FIG$) (nth 4 (CFGetXData #eNEW "G_SYM")))))) ; D ���m��r
;;;02/01/09YM@MOD            (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS
;;;02/01/09YM@MOD               (Pcpolar #dINS (- #fANG (dtr 90)) #MOV))
;;;02/01/09YM@MOD          ); if
;;;02/01/09YM@MOD        ); progn
;;;02/01/09YM@MOD      ); if
;;;02/01/09YM@MOD
;;;02/01/09YM@MOD      (command "_.layer" "on" "M_*" ""); �S���ʉ�w����
;;;02/01/09YM@MOD      ; �E�K�v�Ȃ�WDH�L�k
;;;02/01/09YM@MOD      (setq #fHmov 0) ; ���_�ŐL�k����̏ꍇ�̈ړ��l
;;;02/01/09YM@MOD      (if (= (nth 9 #FIG$) "Yes")(progn ; �X�g���b�`�t���O
;;;02/01/09YM@MOD        ;00/08/31 SN MOD �L�k�������ɏ������s��
;;;02/01/09YM@MOD        (setq #gsymxd$ (CFGetXData #eNEW "G_SYM"))
;;;02/01/09YM@MOD        ; �L�k���s�O�ɇH�}�`�ړ��p�ɍ����̍����擾���Ă��� 01/02/02 MH MOD
;;;02/01/09YM@MOD        (setq #fHmov (- (nth 7 #FIG$) (nth 5 #gsymxd$)))
;;;02/01/09YM@MOD        (if (not (equal (nth 5 #FIG$) (nth 3 #gsymxd$) 0.0001))
;;;02/01/09YM@MOD          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 4 #gsymxd$) (nth 5 #gsymxd$))
;;;02/01/09YM@MOD        )
;;;02/01/09YM@MOD        (if (not (equal (nth 6 #FIG$) (nth 4 #gsymxd$) 0.0001))
;;;02/01/09YM@MOD          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 5 #gsymxd$))
;;;02/01/09YM@MOD        )
;;;02/01/09YM@MOD        (if (not (equal (nth 7 #FIG$) (nth 5 #gsymxd$) 0.0001))
;;;02/01/09YM@MOD          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$))
;;;02/01/09YM@MOD        )
;;;02/01/09YM@MOD        ;(SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$))
;;;02/01/09YM@MOD      ))



      (command "_.layer" "on" "M_*" ""); �S���ʉ�w����
      ; �E�K�v�Ȃ�WDH�L�k
      (setq #fHmov 0) ; ���_�ŐL�k����̏ꍇ�̈ړ��l
      (if (= (nth 9 #FIG$) "Yes")(progn ; �X�g���b�`�t���O
        ;00/08/31 SN MOD �L�k�������ɏ������s��
        (setq #gsymxd$ (CFGetXData #eNEW "G_SYM"))
;-- 2012/02/21 A.Satoh Add CG�Ή� - S
;;;;;;-- 2012/02/17 A.Satoh Add CG�Ή� - S
;;;;;				(setq CG_SizeH (nth 5 #gsymxd$))
;;;;;;-- 2012/02/17 A.Satoh Add CG�Ή� - E
;-- 2012/02/21 A.Satoh Add CG�Ή� - E
;-- 2011/10/31 A.Satoh Add - S
				(setq #LXD$ (CFGetXData #eNEW "G_LSYM"))
				(setq #pt  (cdr (assoc 10 (entget #eNEW))))      ; ����ي�_
				(setq #ANG (nth 2 #LXD$))                       ; ����ٔz�u�p�x
				(setq #gnam (SKGetGroupName #eNEW))              ; ��ٰ�ߖ�
;-- 2012/02/21 A.Satoh Add CG�Ή� - S
				(setq CG_SizeH (nth 13 #LXD$))
;-- 2012/02/21 A.Satoh Add CG�Ή� - E
;-- 2011/11/28 A.Satoh Del - S
;;;;;  			(setq #eDelBRK_W$ (PcRemoveBreakLine #eNEW "W")) ; W�����u���[�N����
;;;;;			  (setq #eDelBRK_D$ (PcRemoveBreakLine #eNEW "D")) ; D�����u���[�N����
;;;;;			  (setq #eDelBRK_H$ (PcRemoveBreakLine #eNEW "H")) ; H�����u���[�N����
;-- 2011/11/28 A.Satoh Del - E
;-- 2012/02/16 A.Satoh Add CG�Ή� - S
				(setq #org_size$
					(list
						(nth 3 #gsymxd$)	; ��
						(nth 4 #gsymxd$)	; ���s
						(nth 5 #gsymxd$)	; ����
					)
				)
;-- 2012/02/16 A.Satoh Add CG�Ή� - E

;-- 2011/12/19 A.Satoh Mod - S
				(setq #BrkW nil)
				(setq #BrkD nil)
				(setq #BrkH nil)
				(setq #alert_f nil)
				(setq #msg_str "�}�`��")
;-- 2012/02/16 A.Satoh Add CG�Ή� - S
				(setq #BrkW2 nil)
				(setq #BrkD2 nil)
				(setq #BrkH2 nil)
				(setq #XLINE_W$ nil)
				(setq #XLINE_D$ nil)
				(setq #XLINE_H$ nil)
;-- 2012/02/16 A.Satoh Add CG�Ή� - E

;-- 2011/12/21 A.Satoh Add - S
				(if (>= (nth 12 #FIG$) 4)
;-- 2011/12/21 A.Satoh Add - E
				; W�����u���[�N���C���̑��݃`�F�b�N
;-- 2012/02/16 A.Satoh Mod CG�Ή� - S
;;;;;				(if (= (PCSetItem_CheckBreakLineExist #eNew "W") nil)
					(progn
						(setq #BrkLineW$ (PCSetItem_CheckBreakLineExist #eNew "W" #pt #ANG))
						(if (= #BrkLineW$ nil)
;-- 2012/02/16 A.Satoh Mod CG�Ή� - S
							(progn
								(setq #BrkW_str "�y�������z")
								(setq #BrkW (fix (* (fix (nth 3 #gsymxd$)) 0.5)))
							)
							(setq #BrkW_str "")
						)
;-- 2012/02/16 A.Satoh Add CG�Ή� - S
					)
;-- 2012/02/16 A.Satoh Add CG�Ή� - E
;-- 2011/12/21 A.Satoh Add - S
					(setq #BrkW_str "")
				)
;-- 2011/12/21 A.Satoh Add - E

;-- 2011/12/21 A.Satoh Add - S
				(if (or (= (nth 12 #FIG$) 2) (= (nth 12 #FIG$) 3) (= (nth 12 #FIG$) 6) (= (nth 12 #FIG$) 7))
;-- 2011/12/21 A.Satoh Add - E
				; D�����u���[�N���C���̑��݃`�F�b�N
;-- 2012/02/16 A.Satoh Mod CG�Ή� - S
;;;;;				(if (= (PCSetItem_CheckBreakLineExist #eNew "D") nil)
					(progn
						(setq #BrkLineD$ (PCSetItem_CheckBreakLineExist #eNew "D" #pt #ANG))
						(if (= #BrkLineD$ nil)
;-- 2012/02/16 A.Satoh Mod CG�Ή� - E
							(progn
								(setq #BrkD_str "�y���s�����z")
								(setq #BrkD (fix (* (fix (nth 4 #gsymxd$)) 0.5)))
							)
							(setq #BrkD_str "")
;-- 2012/02/16 A.Satoh Mod CG�Ή� - E
						)
;-- 2012/02/16 A.Satoh Mod CG�Ή� - S
					)
;-- 2012/02/16 A.Satoh Mod CG�Ή� - E
;-- 2011/12/21 A.Satoh Add - S
					(setq #BrkD_str "")
				)
;-- 2011/12/21 A.Satoh Add - E

;-- 2011/12/21 A.Satoh Add - S
				(if (or (= (nth 12 #FIG$) 1) (= (nth 12 #FIG$) 3) (= (nth 12 #FIG$) 5) (= (nth 12 #FIG$) 7))
;-- 2011/12/21 A.Satoh Add - E
				; H�����u���[�N���C���̑��݃`�F�b�N
;-- 2012/02/16 A.Satoh Mod CG�Ή� - S
;;;;;				(if (= (PCSetItem_CheckBreakLineExist #eNew "H") nil)
					(progn
						(setq #BrkLineH$ (PCSetItem_CheckBreakLineExist #eNew "H" #pt #ANG))
						(if (= #BrkLineH$ nil)
;-- 2012/02/16 A.Satoh Mod CG�Ή� - E
							(progn
								(setq #BrkH_str "�y���������z")
								(if (> 0 (nth 10 #gsymxd$))
									(setq #BrkH (- (+ (fix (* (fix (nth 5 #gsymxd$)) 0.5)) (caddr #pt)) (nth 5 #gsymxd$)))
									(setq #BrkH (fix (* (fix (nth 5 #gsymxd$)) 0.5)))
								)
							)
							(setq #BrkH_str "")
						)
;-- 2012/02/16 A.Satoh Mod CG�Ή� - S
					)
;-- 2012/02/16 A.Satoh Mod CG�Ή� - E
;-- 2011/12/21 A.Satoh Add - S
					(setq #BrkH_str "")
				)
;-- 2011/12/21 A.Satoh Add - E

;-- 2011/12/21 A.Satoh Add - S
				(if (> (nth 12 #FIG$) 0)
;-- 2011/12/21 A.Satoh Add - E
				(if (or (/= #BrkW nil) (/= #BrkD nil) (/= #BrkH nil))
					(progn
		        (if (and (not (equal (nth 5 #FIG$) (nth 3 #gsymxd$) 0.0001))
										 (/= #BrkW nil))
							(progn
								(setq #alert_f T)
								(setq #msg_str (strcat #msg_str #BrkW_str))
							)
						)
		        (if (and (not (equal (nth 6 #FIG$) (nth 4 #gsymxd$) 0.0001))
										 (/= #BrkD nil))
							(progn
								(setq #alert_f T)
								(setq #msg_str (strcat #msg_str #BrkD_str))
							)
						)
		        (if (and (not (equal (nth 7 #FIG$) (nth 5 #gsymxd$) 0.0001))
										 (/= #BrkH nil))
							(progn
								(setq #alert_f T)
								(setq #msg_str (strcat #msg_str #BrkH_str))
							)
						)

						(if (= #alert_f T)
							(progn
								(setq #msg_str (strcat #msg_str "�̃u���[�N���C�����Ȃ����߁A�����ʒu�Ɏ����I�ɐݒu���܂��B"))
								(CFAlertMsg #msg_str)
							)
						)
					)
				)
;-- 2011/12/21 A.Satoh Add - S
				)
;-- 2011/12/21 A.Satoh Add - E

;;;;;				(setq #BrkW (fix (* (fix (nth 3 #gsymxd$)) 0.5)))
;;;;;				(setq #BrkD (fix (* (fix (nth 4 #gsymxd$)) 0.5)))
;;;;;				(if (> 0 (nth 10 #gsymxd$))
;;;;;					(setq CG_BASE_UPPER T)
;;;;;				)
;;;;;				(if CG_BASE_UPPER
;;;;;					(setq #BrkH (- (+ (fix (* (fix (nth 5 #gsymxd$)) 0.5)) (caddr #pt)) (nth 5 #gsymxd$)))
;;;;;					(setq #BrkH (fix (* (fix (nth 5 #gsymxd$)) 0.5)))
;;;;;				)
;-- 2011/12/19 A.Satoh Mod - E
;-- 2011/11/28 A.Satoh Del - S
;;;;;				(setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))
;;;;;				(setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))
;;;;;				(setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))
;;;;;				(CFSetXData #XLINE_W "G_BRK" (list 1))
;;;;;				(CFSetXData #XLINE_D "G_BRK" (list 2))
;;;;;				(CFSetXData #XLINE_H "G_BRK" (list 3))
;;;;;				;;; ��ڰ�ײ̸݂�ٰ�߉�
;;;;;				(command "-group" "A" #gnam #XLINE_W "")
;;;;;				(command "-group" "A" #gnam #XLINE_D "")
;;;;;				(command "-group" "A" #gnam #XLINE_H "")
;-- 2011/11/28 A.Satoh Del - E
;-- 2011/10/31 A.Satoh Add - E
        ; �L�k���s�O�ɇH�}�`�ړ��p�ɍ����̍����擾���Ă��� 01/02/02 MH MOD
        (setq #fHmov (- (nth 7 #FIG$) (nth 5 #gsymxd$)))
        (if (not (equal (nth 5 #FIG$) (nth 3 #gsymxd$) 0.0001))
;-- 2011/10/31 A.Satoh Mod - S
;          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 4 #gsymxd$) (nth 5 #gsymxd$))
					(progn
;-- 2011/12/19 A.Satoh Mod - S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;						(setq CG_POS_STR T)
;;;;;						(setq CG_TOKU T)
;;;;;						(setq #STR_FLG T)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;						(setq #eDelBRK_W$ (PcRemoveBreakLine #eNEW "W")) ; W�����u���[�N����
;;;;;						(setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))
;;;;;						(CFSetXData #XLINE_W "G_BRK" (list 1))
;;;;;						;;; ��ڰ�ײ̸݂�ٰ�߉�
;;;;;						(command "-group" "A" #gnam #XLINE_W "")
;;;;;;-- 2011/11/28 A.Satoh Add - E
;;;;;	          (setq CG_TOKU_BW #BrkW)
;;;;;;-- 2011/11/28 A.Satoh Del - S
;;;;;;;;;;  	        (setq CG_TOKU_BD nil)
;;;;;;;;;;    	      (setq CG_TOKU_BH nil)
;;;;;;-- 2011/11/28 A.Satoh Del - E
						(if #BrkW
							(progn
								(setq #eDelBRK_W$ (PcRemoveBreakLine #eNEW "W")) ; W�����u���[�N����
								(setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))
								(CFSetXData #XLINE_W "G_BRK" (list 1))
								;;; ��ڰ�ײ̸݂�ٰ�߉�
								(command "-group" "A" #gnam #XLINE_W "")
			          (setq CG_TOKU_BW #BrkW)
;-- 2012/02/16 A.Satoh Add CG�Ή� - S
								(setq #XLINE_W$ (list #BrkW nil))
;-- 2012/02/16 A.Satoh Add CG�Ή� - E
							)
;-- 2012/02/16 A.Satoh Add CG�Ή� - S
							(progn
								(setq #idx 0)
								(repeat (length #BrkLineW$)
									(if (> 2 #idx)
										(progn
											(setq #dist (PCSetItem_GetBreakLineDist (nth #idx #BrkLineW$) "W" #pt #ANG))
											(setq #XLINE_W$ (append #XLINE_W$ (list #dist)))
										)
									)
									(setq #idx (1+ #idx))
								)
							)
;-- 2012/02/16 A.Satoh Add CG�Ή� - E
						)
;-- 2011/12/19 A.Satoh Mod - E

;-- 2012/02/22 A.Satoh Add - S
						(setq #W_f T)
;-- 2012/02/22 A.Satoh Add - S

						; �������L�k����
	          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 4 #gsymxd$) (nth 5 #gsymxd$))

;-- 2011/12/19 A.Satoh Mod - S
;;;;;            ;;; �ꎞ��ڰ�ײݍ폜
;;;;;            (entdel #XLINE_W)
;;;;;            ;;; ������ڰ�ײݕ���
;;;;;            (foreach #eD #eDelBRK_W$
;;;;;              (if (= (entget #eD) nil) (entdel #eD)) ;W�����u���[�N����
;;;;;            );for
;;;;;
;;;;;;-- 2011/11/28 A.Satoh Del - S
;;;;;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;;;;;;			      (if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))
;;;;;;;;;;-- 2011/11/24 A.Satoh Add - E
;;;;;;-- 2011/11/28 A.Satoh Del - S
						(if #BrkW
							(progn
		            ;;; �ꎞ��ڰ�ײݍ폜
    		        (entdel #XLINE_W)
        		    ;;; ������ڰ�ײݕ���
            		(foreach #eD #eDelBRK_W$
		              (if (= (entget #eD) nil) (entdel #eD)) ;W�����u���[�N����
    		        )
							)
						)
;-- 2011/12/19 A.Satoh Mod - E
					)
;-- 2011/12/19 A.Satoh Del - S
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;					(progn
;;;;;						(setq CG_POS_STR T)
;;;;;						(setq CG_TOKU T)
;;;;;						(setq #STR_FLG T)
;;;;;	          (setq CG_TOKU_BW #BrkW)
;;;;;					)
;;;;;-- 2011/11/28 A.Satoh Add - E
;-- 2011/12/19 A.Satoh Mod - E
;-- 2011/10/31 A.Satoh Mod - E
        )
        (if (not (equal (nth 6 #FIG$) (nth 4 #gsymxd$) 0.0001))
;-- 2011/10/31 A.Satoh Mod - S
;          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 5 #gsymxd$))
					(progn
;-- 2011/12/19 A.Satoh Mod - S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;;-- 2011/11/28 A.Satoh Mod - S
;;;;;						(if #STR_FLG
;;;;;							(progn
;;;;;								(setq CG_POS_STR nil)
;;;;;							)
;;;;;						(if (= #STR_FLG nil)
;;;;;;-- 2011/11/28 A.Satoh Mod - E
;;;;;							(progn
;;;;;								(setq CG_POS_STR T)
;;;;;								(setq #STR_FLG T)
;;;;;								(setq CG_TOKU T)
;;;;;							)
;;;;;						)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;						(setq #eDelBRK_D$ (PcRemoveBreakLine #eNEW "D")) ; D�����u���[�N����
;;;;;						(setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))
;;;;;						(CFSetXData #XLINE_D "G_BRK" (list 2))
;;;;;						;;; ��ڰ�ײ̸݂�ٰ�߉�
;;;;;						(command "-group" "A" #gnam #XLINE_D "")
;;;;;;-- 2011/11/28 A.Satoh Add - E
;;;;;  	        (setq CG_TOKU_BD #BrkD)
;;;;;;-- 2011/11/28 A.Satoh Del - S
;;;;;;;;;;	          (setq CG_TOKU_BW nil)
;;;;;;;;;;    	      (setq CG_TOKU_BH nil)
;;;;;;-- 2011/11/28 A.Satoh Del - E
						(if #BrkD
							(progn
								(setq #eDelBRK_D$ (PcRemoveBreakLine #eNEW "D")) ; D�����u���[�N����
								(setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))
								(CFSetXData #XLINE_D "G_BRK" (list 2))
								;;; ��ڰ�ײ̸݂�ٰ�߉�
								(command "-group" "A" #gnam #XLINE_D "")
  			        (setq CG_TOKU_BD #BrkD)
;-- 2012/02/16 A.Satoh Add CG�Ή� - S
								(setq #XLINE_D$ (list #BrkD nil))
;-- 2012/02/16 A.Satoh Add CG�Ή� - E
							)
;-- 2012/02/16 A.Satoh Add CG�Ή� - S
							(progn
								(setq #idx 0)
								(repeat (length #BrkLineD$)
									(if (> 2 #idx)
										(progn
											(setq #dist (PCSetItem_GetBreakLineDist (nth #idx #BrkLineD$) "D" #pt #ANG))
											(setq #XLINE_D$ (append #XLINE_D$ (list #dist)))
										)
									)
									(setq #idx (1+ #idx))
								)
							)
;-- 2012/02/16 A.Satoh Add CG�Ή� - E
						)
;-- 2011/12/19 A.Satoh Mod - E

;-- 2012/02/22 A.Satoh Add - S
						(setq #D_f T)
;-- 2012/02/22 A.Satoh Add - S

						; ���s�����L�k����
	          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 5 #gsymxd$))

;-- 2011/12/19 A.Satoh Mod - S
;;;;;            ;;; �ꎞ��ڰ�ײݍ폜
;;;;;            (entdel #XLINE_D)
;;;;;            ;;; ������ڰ�ײݕ���
;;;;;            (foreach #eD #eDelBRK_D$
;;;;;              (if (= (entget #eD) nil) (entdel #eD)) ;D�����u���[�N����
;;;;;            );for
;;;;;
						(if #BrkD
							(progn
		            ;;; �ꎞ��ڰ�ײݍ폜
    		        (entdel #XLINE_D)
        		    ;;; ������ڰ�ײݕ���
            		(foreach #eD #eDelBRK_D$
		              (if (= (entget #eD) nil) (entdel #eD)) ;D�����u���[�N����
    		        )
							)
						)
;-- 2011/12/19 A.Satoh Mod - E
;-- 2011/11/28 A.Satoh Del - S
;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;			      (if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))
;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/11/28 A.Satoh Del - E
					)
;-- 2011/12/19 A.Satoh Del - S
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;					(progn
;;;;;						(if (= #STR_FLG nil)
;;;;;							(progn
;;;;;								(setq CG_POS_STR T)
;;;;;								(setq #STR_FLG T)
;;;;;								(setq CG_TOKU T)
;;;;;							)
;;;;;						)
;;;;;  	        (setq CG_TOKU_BD #BrkD)
;;;;;					)
;;;;;-- 2011/11/28 A.Satoh Add - E
;;;;;-- 2011/10/31 A.Satoh Mod - E
;-- 2011/12/19 A.Satoh Del - E
        )
        (if (not (equal (nth 7 #FIG$) (nth 5 #gsymxd$) 0.0001))
;-- 2011/10/31 A.Satoh Mod - S
;          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$))
					(progn
;-- 2011/12/19 A.Satoh Mod - S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;;-- 2011/11/28 A.Satoh Mod - S
;;;;;;;;;;						(if #STR_FLG
;;;;;;;;;;							(progn
;;;;;;;;;;								(setq CG_POS_STR nil)
;;;;;;;;;;							)
;;;;;						(if (= #STR_FLG nil)
;;;;;;-- 2011/11/28 A.Satoh Mod - E
;;;;;							(progn
;;;;;								(setq CG_POS_STR T)
;;;;;								(setq #STR_FLG T)
;;;;;								(setq CG_TOKU T)
;;;;;							)
;;;;;						)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;						(setq #eDelBRK_H$ (PcRemoveBreakLine #eNEW "H")) ; H�����u���[�N����
;;;;;						(setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))
;;;;;						(CFSetXData #XLINE_H "G_BRK" (list 3))
;;;;;						;;; ��ڰ�ײ̸݂�ٰ�߉�
;;;;;						(command "-group" "A" #gnam #XLINE_H "")
;;;;;;-- 2011/11/28 A.Satoh Add - E
;;;;;    	      (setq CG_TOKU_BH #BrkH)
						(if #BrkH
							(progn
								(setq #eDelBRK_H$ (PcRemoveBreakLine #eNEW "H")) ; H�����u���[�N����
								(setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))
								(CFSetXData #XLINE_H "G_BRK" (list 3))
								;;; ��ڰ�ײ̸݂�ٰ�߉�
								(command "-group" "A" #gnam #XLINE_H "")
    			      (setq CG_TOKU_BH #BrkH)
;-- 2012/02/16 A.Satoh Add CG�Ή� - S
								(setq #XLINE_H$ (list #BrkH nil))
;-- 2012/02/16 A.Satoh Add CG�Ή� - E
							)
;-- 2012/02/16 A.Satoh Add CG�Ή� - S
							(progn
								(setq #idx 0)
								(repeat (length #BrkLineH$)
									(if (> 2 #idx)
										(progn
											(setq #dist (PCSetItem_GetBreakLineDist (nth #idx #BrkLineH$) "H" #pt #ANG))
											(setq #XLINE_H$ (append #XLINE_H$ (list #dist)))
										)
									)
									(setq #idx (1+ #idx))
								)
							)
;-- 2012/02/16 A.Satoh Add CG�Ή� - E
						)
;-- 2011/12/19 A.Satoh Mod - E
;-- 2011/11/28 A.Satoh Del - S
;;;;;	          (setq CG_TOKU_BW nil)
;;;;;  	        (setq CG_TOKU_BD nil)
;-- 2011/11/28 A.Satoh Del - E

;-- 2012/02/22 A.Satoh Add - S
						(setq #H_f T)
;-- 2012/02/22 A.Satoh Add - S

						; ���������L�k����
	          (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$))

;-- 2011/12/19 A.Satoh Mod - S
;;;;;            ;;; �ꎞ��ڰ�ײݍ폜
;;;;;            (entdel #XLINE_H)
;;;;;            ;;; ������ڰ�ײݕ���
;;;;;            (foreach #eD #eDelBRK_H$
;;;;;              (if (= (entget #eD) nil) (entdel #eD)) ;H�����u���[�N����
;;;;;            );for
;;;;;
						(if #BrkH
							(progn
		            ;;; �ꎞ��ڰ�ײݍ폜
    		        (entdel #XLINE_H)
        		    ;;; ������ڰ�ײݕ���
            		(foreach #eD #eDelBRK_H$
		              (if (= (entget #eD) nil) (entdel #eD)) ;H�����u���[�N����
    		        )
							)
						)
;-- 2011/12/19 A.Satoh Mod - E
;-- 2011/11/28 A.Satoh Del - S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;			      (if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))
;;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/11/28 A.Satoh Del - E
					)
;-- 2011/12/19 A.Satoh Del - S
;;;;;;-- 2011/11/28 A.Satoh Add - S
;;;;;					(progn
;;;;;						(setq CG_BASE_UPPER nil)
;;;;;						(if (= #STR_FLG nil)
;;;;;							(progn
;;;;;								(setq CG_POS_STR T)
;;;;;								(setq #STR_FLG T)
;;;;;								(setq CG_TOKU T)
;;;;;							)
;;;;;						)
;;;;;    	      (setq CG_TOKU_BH #BrkH)
;;;;;					)
;;;;;;-- 2011/11/28 A.Satoh Add - E
;-- 2011/12/19 A.Satoh Del - E
;-- 2011/10/31 A.Satoh Mod - E
        )
        ;(SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$))
;-- 2011/12/19 A.Satoh Add - S
				(setq CG_BASE_UPPER nil)
;-- 2011/12/19 A.Satoh Add - E

;-- 2012/02/22 A.Satoh Add - S
				(setq #chk (list #W_f #D_f #H_f))
;-- 2012/02/22 A.Satoh Add - E

;-- 2012/02/16 A.Satoh Add CG�Ή� - S
				(if (= nil (tblsearch "APPID" "G_REG")) (regapp "G_REG"))
				(InputGRegData #eNEW #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ #chk nil nil)
;-- 2012/02/16 A.Satoh Add CG�Ή� - E
;-- 2012/02/17 A.Satoh Add CG�Ή� - S
				(setq CG_SizeH nil)
;-- 2012/02/17 A.Satoh Add CG�Ή� - E
      ))


      ; �D�}�����[�h�̏ꍇ�ADB��G_SYM�̍�����␳
      ;   00/06/21MH ADD SelParts.cfg����L�k��Ƃ��s���ꍇ�␳�����Ȃ�
;;;02/01/09YM@MOD      (if (and (wcmatch &sMODE "CNT,INS,CHG")
;;;02/01/09YM@MOD            (not (and (findfile (strcat CG_SYSPATH "SELPARTS.CFG"))
;;;02/01/09YM@MOD                      (< 0 (nth 11 (PcGetPartQLY$  "�i�Ԋ�{" #sHIN nil nil))); ���ͺ���
;;;02/01/09YM@MOD          ))); if����

      (if (and (wcmatch &sMODE "CNT,INS,CHG")); if���� �L�k��ƂɊւ�炸�␳������
        (progn
          ; ��ʂv���� �␳ ; "L" �����}���ŁAW�l�ɍ���������
          (if (and (= &sDIR "L")
            (/= 0 (setq #MOV (- (nth 5 #FIG$) (nth 3 (CFGetXData #eNEW "G_SYM")))))) ; W ���m��r
            (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS (Pcpolar #dINS #fANG #MOV))
          );if
          ; ���p�L���r "R" �����}���ŁAD�l�ɍ��������� ���ꏈ��
          (if (and (= (CFGetSymSKKCode #eNEW 3) CG_SKK_THR_CNR)
                   (= &sDIR "R")
                   (/= 0 (setq #MOV (- (nth 6 #FIG$) (nth 4 (CFGetXData #eNEW "G_SYM")))))) ; D ���m��r
            (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS
               (Pcpolar #dINS (- #fANG (dtr 90)) #MOV))
          ); if
        ); progn
      ); if

; 02/01/09 �D�ƇE�̏��Ԃ����ւ� ---------------------------------------------------------------------------

;-- 2011/11/28 A.Satoh Del - S
;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;			(if (= CG_TOKU nil)
;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/11/28 A.Satoh Del - E
      ; �F���ʏ���
      (if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))
;-- 2011/11/28 A.Satoh Del - S
;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;			)
;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/11/28 A.Satoh Del - E

      ; �GH800�̍�����������
;;;01/01/12YM@      (if (and (= #flg "-1")
;;;01/01/12YM@            (or (and (= (CFGetSymSKKCode #eNEW 1) CG_SKK_ONE_CAB) ; ����
;;;01/01/12YM@                     (= (CFGetSymSKKCode #eNEW 2) CG_SKK_TWO_BAS)); �ް�
;;;01/01/12YM@                ;(wcmatch #sHIN "KH-S230P*");İٗp��߰��
;;;01/01/12YM@            )   ;(wcmatch #sHIN "KB-F15AP*"));�۱�p̨װ
;;;01/01/12YM@          ); and
;;;01/01/12YM@        (progn
;;;01/01/12YM@          ; 00/08/29 SN MOD ��������850�����Ή��Ŏ��O�ɍs���Ă���̂ł����ł͂��Ȃ��B
;;;01/01/12YM@          ; 00/08/22 MH İٗp��߰���̂ݓ��ꏈ�� ������2300�ɂ���i2248�ɂȂ�̂�h�����߁j
;;;01/01/12YM@          ;(if (wcmatch #sHIN "KH-S230P*")
;;;01/01/12YM@          ;  (SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) 2300))
;;;01/01/12YM@          (PcCabCutCall #eNEW) ; ����ȯĂ̐L�k����
;;;01/01/12YM@          ; "POS"�̂� Z�ړ����K�v�B�����ݒ肪0�ȊO�������Ƃ��̂���
;;;01/01/12YM@          (if (= &sMODE "POS")(progn
;;;01/01/12YM@            ;;; Z�ړ�
;;;01/01/12YM@            (setq #ss_H800 (CFGetSameGroupSS #eNEW))   ; �O���[�v�S�}�`�I���Z�b�g
;;;01/01/12YM@            (command "._MOVE" #ss_H800 "" "0,0,0" (strcat "0,0," (rtos #posZ)))
;;;01/01/12YM@            (setq #en_lis_#ss  (CMN_ss_to_en  #ss_H800)) ; �I���Z�b�g�n���}�`�����X�g����
;;;01/01/12YM@            (SetG_LSYM1 #en_lis_#ss)  ; "G_LSYM"(�}���_)�g���f�[�^�̕ύX
;;;01/01/12YM@            (SetG_PRIM1 #en_lis_#ss)  ; "G_PRIM" (���t������)�g���f�[�^�̕ύX
;;;01/01/12YM@          ));if progn
;;;01/01/12YM@      )); if progn

;;;01/02/27YM@      ; ���_��H�����L�k�̂������A�C�e���͐L�k��H�����Ɉړ� 01/02/02 MH ADD
;;;01/02/27YM@      (if (and (not (equal 0 #fHmov 0.1)) (= -1 (nth 10 (CFGetXData #eNEW "G_SYM"))))
;;;01/02/27YM@        (progn
;;;01/02/27YM@          ; �ړ���_��Z�l���擾
;;;01/02/27YM@          (setq #cntZ (- (caddr #dINS) #fHmov))
;;;01/02/27YM@          (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS
;;;01/02/27YM@            (list (car #dINS) (cadr #dINS) #cntZ))
;;;01/02/27YM@        ); progn
;;;01/02/27YM@      ); if

      ; "CNT" �c�����̑}���ł������ꍇ�A��A�C�e����H�����t���O��
      ;       �}���}�`��H�����t���O�Ŕ��f���đ}���}�`���ړ������� (�K�X�R�����ȊO)
      ; 01/06/17 HN S-MOD �z�u�}�`���R�����ȊO�͒ʏ�ɂy�l���擾����悤�ɔ����ύX
      ;@MOD@(if (and (= &sMODE "CNT") (or (= &sDIR "T") (= &sDIR "D"))
      ;@MOD@  (/= (CFGetSymSKKCode CG_BASESYM 3) CG_SKK_THR_GAS))
      (if
        (and
          (= &sMODE "CNT")
          (or (= &sDIR "T") (= &sDIR "D"))
;;;          (/= CG_SKK_INT_GAS #sCd) ; 01/08/31 YM MOD 210-->��۰��ى�
        )
      ; 01/06/17 HN E-MOD �z�u�}�`���R�����ȊO�͒ʏ�ɂy�l���擾����悤�ɔ����ύX
        (progn
          (setq #B_Hflag (nth 10 (CFGetXData CG_BASESYM "G_SYM")));��}�`��H�����t���O
          (setq #F_Hflag (nth 10 (CFGetXData #eNEW "G_SYM")));�}���}�`��H�����t���O
;;;01/05/31YM@          (setq #newH (fix (nth 7 #FIG$)))
          (setq #newH (nth 5 (CFGetXData #eNEW "G_SYM"))) ; ;01/05/31 YM

          (setq #basH (caddr #baseWDH$))
          ; �ړ���_��Z�l���擾
          (setq #cntZ
            (cond
              ((and (= &sDIR "T") (= 1 #B_Hflag) (= 1 #F_Hflag))
                (+ #basH (caddr #dINS))
              )
              ((and (= &sDIR "T") (= 1 #B_Hflag) (= -1 #F_Hflag))
                (+ #basH #newH (caddr #dINS))
              )
              ((and (= &sDIR "T") (= -1 #B_Hflag) (= 1 #F_Hflag))
                (caddr #dINS)
              )
              ((and (= &sDIR "T") (= -1 #B_Hflag) (= -1 #F_Hflag))
                (+ #newH (caddr #dINS))
              )
              ((and (= &sDIR "D") (= 1 #B_Hflag) (= 1 #F_Hflag))
                (- (caddr #dINS) #newH)
              )
              ((and (= &sDIR "D") (= 1 #B_Hflag) (= -1 #F_Hflag))
                (caddr #dINS)
              )
              ((and (= &sDIR "D") (= -1 #B_Hflag) (= 1 #F_Hflag))
                (- (caddr #dINS) #basH #newH)
              )
              ((and (= &sDIR "D") (= -1 #B_Hflag) (= -1 #F_Hflag))
                (- (caddr #dINS) #basH)
              )
            ); end of cond
          ); end of setq
          ; �ړ����s
          (if (not (equal (caddr #dINS) #cntZ 0.0001))
            (command "_move" (CFGetSameGroupSS #eNEW) "" #dINS
              (list (car #dINS) (cadr #dINS) #cntZ))
          ); end of if
        ); end of progn
      ); end of if

      ; �H���Ӑ}�`�ړ�
      (cond
        ((and (= &sMODE "CNT") (or (= &sDIR "R") (= &sDIR "L")))
          ;00/09/25 SN MOD �A��Ӱ�ނ̍��E�ͱ��т̈ړ��͂����A�ׂ̱��тɏd�˂�B
          ;(PcMoveItemAround "CNT" #eNEW #eBASE #sDIR (nth 3 (CFGetXData #eNEW "G_SYM")) nil)
        )
        ((= &sMODE "INS")
          (KcMoveItemAround_INS #eNEW #eBASE &sDIR (nth 3 (CFGetXData #eNEW "G_SYM")))
;;;       (PcMoveItemAround "INS" #eNEW #eBASE #type (nth 3 (CFGetXData #eNEW "G_SYM")) nil) ; �}�����w��YM
        )
        ((= &sMODE "CHG")
          (if (/= 0 (setq #fMOVE (- (nth 3 (CFGetXData #eNEW "G_SYM")) (car #chgWDH$))))
            (progn
;-- 2011/12/08 A.Satoh Add - S
							(if (= CG_REGULAR nil)
								(progn
;-- 2011/12/08 A.Satoh Add - E
              ; 01/01/29 YM ADD
              (initget "L R") ; 01/03/14 YM
              (setq #type (getkword "\n�ړ�������� [��(L)/�E(R)] <�ړ��Ȃ�>:  ")); ��̫��Enter 01/03/14 YM
;-- 2011/12/08 A.Satoh Add - S
								)
								(setq #type nil)
							)
;-- 2011/12/08 A.Satoh Add - E


              (command "_change" #ss "" "P" "C" "BYLAYER" "") ; �����ŐF��߂�
    ;;;         (if (> #fMOVE 0)
    ;;;           (setq #type (getkword "\n�ړ�������� /L=��/R=�E/:  "))
    ;;;           (setq #type (getkword "\n�ړ�������� /L=��/R=�E/:  "))
    ;;;         );_if
              ; 01/01/29 YM ADD

              ; �V�}�`,���}�`,�ړ�����,�ړ���
              (if #type
                (KcMoveItemAround_CHG #eNEW &eCHG #type #fMOVE) ; 01/02/05 YM MOD
                (command "_erase" (CFGetSameGroupSS &eCHG) "")  ; ���}�`�폜���s 01/03/14 YM
              );_if
    ;;;          (PcMoveItemAround "CHG" #eNEW nil "R" #fMOVE #eNEXT$) ; 01/02/05 YM MOD
            )
            (progn
              ;;; ���}�`�폜���s
              (command "_erase" (CFGetSameGroupSS &eCHG) "") ; ���}�` &eCHG
              (command "_change" #ss "" "P" "C" "BYLAYER" "") ; �����ŐF��߂�
            )
          );_if
        )
        (t nil)
      ); cond

      ; �I�g���ް� "G_OPT" �Z�b�g
      (KcSetG_OPT #eNEW)

      ; �J��A�C�e���ڍs
(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
	(progn ;2017/09/12 YM ADD
		(setq CG_SKK_ONE_CNT 0) ;�ꎞ�I�ɶ�������i���ޕύX 7==>0
	)
);_if

      (if (or ; 01/06/18 YM ADD ����шڍs���Ȃ�--�������ǉ�
            (and (wcmatch &sMODE "POS,CHG")
                 (or (not (CFGetBaseSymXRec))(not (entget (CFGetBaseSymXRec))))
                     (and (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_GAS)
                          (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_WTR)
                          (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_CNT) ; 01/08/22 YM ADD ������ǉ�
                          (/= CG_SKK_INT_SAK (nth 8 #FIG$))) ; 02/05/31 HN ADD �H��􂢊����@
            ); and
            ; �A�����[�h�ŐV�}�`���R�����ȊO������
            (and (= &sMODE "CNT")
                     (and (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_GAS)
                          (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_WTR)
                          (/= (SKY_DivSeikakuCode (nth 8 #FIG$) 1) CG_SKK_ONE_CNT) ; 01/08/22 YM ADD ������ǉ�
                          (/= CG_SKK_INT_SAK (nth 8 #FIG$))) ; 02/05/31 HN ADD �H��􂢊����@
            ); and
          ); or
        (progn
          (ResetBaseSym) ; ����Ѽ���ق�����ΐF�����ɖ߂�
          (CFSetBaseSymXRec #eNEW) ; XRecord�Ɋ�A�C�e���V���{���}�`����ݒ肷��
          (GroupInSolidChgCol #eNEW CG_BaseSymCol) ; �F������
      )); if progn


(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
	(progn ;2017/09/12 YM ADD
		(setq CG_SKK_ONE_CNT 7) ;�ꎞ�I�ɶ�������i���ޕύX
	)
);_if

    ; 01/04/06 MH ADD �V�A�C�e�����̑��ʐ}�ړ����K�v���ǂ������肵�Ď��s (�R����)
    (KcMoveToSGCabinet #eNEW)

    (command "_.layer" "F" "Z_01*" "")

    ; 02/11/18 YM ADD-S
    (command "_layer" "F" "Y_00*" "")   ; �ذ��
    (command "_layer" "OFF" "Y_00*" "") ; ��\��
    ; 02/11/18 YM ADD-E

    ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
    (CFNoSnapEnd)

;-- 2011/11/09 A.Satoh Add - S
		; �O���[�o���ϐ������ɖ߂�
		(setq CG_BASE_UPPER nil)
		(setq CG_TOKU_BW nil)
		(setq CG_TOKU_BD nil)
		(setq CG_TOKU_BH nil)
;-- 2011/11/09 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
		(setq CG_POS_STR nil)
		(setq CG_TOKU nil)
;-- 2011/11/24 A.Satoh Add - E

    (if (= &sMODE "POS")
      (progn
        (command "_.layer" "F" "Z_*" "")
        (command "_.layer" "T" "Z_00*" "")
        (command "_.layer" "T" "Z_KUTAI" "") ; 01/02/20 YM ADD
        (setvar "ELEVATION" #elv) ; ���̍����ɖ߂� 05/30 MH ADD
      )
    ); if progn
  )); if progn "CHG"���[�h �̏����ȊO

  #eNEW ; �}�`����Ԃ�
) ;PcSetItem


;-- 2011/12/17 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : PCSetItem_CheckBreakLineExist
; <�����T�v>  : �w�肳�ꂽ�����̃u���[�N���C���}�`�����߂�
; <�߂�l>    : �u���[�N���C���}�`���X�g or nil
; <�쐬>      : 11/12/17 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun PCSetItem_CheckBreakLineExist (
	&eEN          ; �}�`��
	&sFLG         ; ���݃`�F�b�N���s���u���[�N���C���̎�� "H" "W" "D"
	&pt						; �V���{����_
	&ang					; �z�u�p�x�i���W�A���j
	/
	#ret$ #BrkW$ #BrkD$ #BrkH$ #group$$ #group$ #Temp$
	)

	(setq #BrkW$ nil)
	(setq #BrkD$ nil)
	(setq #BrkH$ nil)
	(setq #ret$ nl)

	(if (= 'ENAME (type &eEN))
		(progn
			(setq #group$$ (entget (cdr (assoc 330 (entget &eEN)))))
			(foreach #group$ #group$$
				;; �O���[�v�\���}�`���u���[�N���C�����ǂ����̃`�F�b�N
				(if (and (= (car #group$) 340)
								 (= (cdr (assoc 0 (entget (cdr #group$)))) "XLINE")
								 (setq #Temp$ (CFGetXData (cdr #group$) "G_BRK")))
					(cond
						((= (nth 0 #Temp$) 1) ; W �����u���[�N���C��
							(setq #BrkW$ (cons (cdr #group$) #BrkW$))
						)
						((= (nth 0 #Temp$) 2) ; D �����u���[�N���C��
							(setq #BrkD$ (cons (cdr #group$) #BrkD$))
						)
						((= (nth 0 #Temp$) 3) ; H �����u���[�N���C��
							(setq #BrkH$ (cons (cdr #group$) #BrkH$))
						)
					)
				)
			)

			(cond
				((= "W" &sFLG)
					(setq #ret$ #BrkW$)
				)
	      ((= "D" &sFLG)
					(setq #ret$ #BrkD$)
				)
	      ((= "H" &sFLG)
					(setq #ret$ #BrkH$)
				)
				(T
					(setq #ret$ nil)
				)
			)
		)
	)

	#ret$

) ;PCSetItem_CheckBreakLineExist
;-- 2011/12/17 A.Satoh Add - E


;-- 2012/02/16 A.Satoh Add CG�Ή� - S
;<HOM>*************************************************************************
; <�֐���>    : PCSetItem_GetBreakLineDist
; <�����T�v>  : �w�肳�ꂽ�u���[�N���C���̈ʒu(��_����̋���)�����߂�
; <�߂�l>    : �u���[�N���C���ʒu
; <�쐬>      : 12/02/16 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun PCSetItem_GetBreakLineDist (
	&eEN          ; �u���[�N���C���̐}�`��
	&sFLG         ; ���݃`�F�b�N���s���u���[�N���C���̎�� "H" "W" "D"
	&pt$					; �V���{����_
	&ang					; �z�u�p�x�i���W�A���j
	/
	#pnt$ #ang #base_pnt$ #bl_pnt$ #dist
	)

	; �u���[�N���C���}�`�̒��_���擾
	(setq #pnt$ (cdr (assoc 10 (entget &eEN))))

	; ���W�A�����p�x�ɕϊ�
	(setq #ang (fix (rtd &ang)))

	; ���_�̌�����ύX
	(if (= &sFLG "D")
		(progn
			(cond
				((= #ang 90)
					(C:ChgViewBack)
				)
				((= #ang 180)
					(C:ChgViewSideL)
				)
				((= #ang 270)
					(C:ChgViewFront)
				)
				(T
					(C:ChgViewSideR)
				)
			)
		)
		(progn
			(cond
				((= #ang 90)
					(C:ChgViewSideR)
				)
				((= #ang 180)
					(C:ChgViewBack)
				)
				((= #ang 270)
					(C:ChgViewSideL)
				)
				(T
					(C:ChgViewFront)
				)
			)
		)
	)

	; ���_�̌����ɍ����A���W�n��ύX
	(command "_.UCS" "V")

	; ���W�ϊ� WCS �� UCS
	(setq #base_pnt$ (trans &pt$ 0 1))  ; �V���{����_
	(setq #bl_pnt$   (trans #pnt$ 0 1)) ; �u���[�N���C����_

	(cond
		((= "W" &sFLG)
			(setq #dist (abs (fix (- (car #bl_pnt$) (car #base_pnt$)))))
		)
	  ((= "D" &sFLG)
			(setq #dist (abs (fix (- (car #bl_pnt$) (car #base_pnt$)))))
		)
	  ((= "H" &sFLG)
			(setq #dist (abs (fix (- (cadr #bl_pnt$) (cadr #base_pnt$)))))
		)
		(T
			(setq #dist 0)
		)
	)

	; ���_��߂�
	(command "_.UCS" "W")
	(command "_zoom" "P")

	#dist

) ;PCSetItem_GetBreakLineDist
;-- 2012/02/16 A.Satoh Add CG�Ή� - E


;<HOM>*************************************************************************
; <�֐���>    : PcMoveItemAround
; <�����T�v>  : �̈�ƕ����w���ɂ����͂̐}�`�̈ړ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/07/06 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcMoveItemAround (
    &sMODE    ; "CNT" "INS" "CHG" "DEL" �g�p���̊֐��t���O
    &eNEW     ; �V�݃A�C�e��("DEL" �̏ꍇ�A��������A�C�e��������)
    &eBASE    ; ��A�C�e��("DEL" �̏ꍇ nil)
    &fDIR     ; �A���z�u�^�C�v�@"L"���A"R"�E
    &fMOV     ; �ړ���
    &eNEXT$   ; "CHG"�p���X�g�B"CHG"�ȊO��nil
    /
    #osmode #snapmode #XLD$ #WTflg #ss #eNEXT$ #TEMP$ #eNT #eADD$ #eNEXT$
    #fANG #dMOV #i #ss2 #EN
  )
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̏�
  ;CFNoSnapStart�͊O���ϐ��ɒl���m�ۂ���ד�d�Ăяo�Ō��̒l�������B�����͓����ōs��
  (setq #osmode   (getvar "OSMODE"))   ;00/07/21 SN ADD
  (setq #snapmode (getvar "SNAPMODE")) ;00/07/21 SN ADD
  (setvar "OSMODE"   0)                ;00/07/21 SN MOD
  (setvar "SNAPMODE" 0)                ;00/07/21 SN MOD

  (setq #XLD$ (CFGetXData &eNEW "G_LSYM"))

  ; �ړ��Ώ۔͈͂̑S�}�`�擾
  ; SN ADD İٗp��߰��̎���ܰ�į�߂��I��Ăɉ��Z00/07/24
  (setq #WTflg nil);(if (wcmatch (nth 5 #XLD$) "KH-S230P*") 'T nil))
  (setq #ss (PcGetSSAroundItem &sMODE &eNEW &fDIR &fMOV #WTflg))

  ; �Ώې}�`�̗אڐ}�`���擾
  (setq #eNEXT$ (if (not &eNEXT$) (PcGetNextMoveItem$ &eNEW nil) (cons &eNEW &eNEXT$)))

  (cond
    ; �A�����[�h  ��}�`�ƐV�}�`�͈ړ����Ȃ��̂�#ss #eNEXT$ ���甲��
    ((= &sMODE "CNT")
      (if (and #ss (/= (sslength #ss) 0)) (ssdel &eBASE #ss))
      (if (and #ss (/= (sslength #ss) 0)) (ssdel &eNEW #ss))
      (setq #TEMP$ nil)
      (foreach #eNT #eNEXT$
        (if (and (not (equal #eNT &eNEW)) (not (equal #eNT &eBASE)))
          (setq #TEMP$ (cons #eNT #TEMP$))
        );_if
      )
      (setq #eNEXT$ #TEMP$)
    )
    ; �}�����[�h ��}�`�ƐV�}�`�͈ړ�����̂łȂ��ꍇ #ss #eNEXT$ �ɒǉ�
    ((= &sMODE "INS")
      (if (not #ss) (setq #ss (ssadd)))
      (ssadd &eBASE #ss)
      (ssadd &eNEW #ss)
      (if (not (member &eBASE #eNEXT$)) (setq #eNEXT$ (cons &eBASE #eNEXT$)))
      (setq #eNEXT$ (cons &eNEW #eNEXT$))
    )
  ); cond

  ; �͈͑S�}�`�̂Ȃ�����#eNEXT$�̊e�A�C�e���Ɠ��͈� �������̂��̂�I��
  (setq #eADD$ (PcGetSameAreaItem$ #ss #eNEXT$))
  (setq #eNEXT$ (append #eADD$ #eNEXT$)) ; �אږ����X�g�ɒǉ�
  (if (and #ss (/= (sslength #ss) 0)) (progn
    (command "_zoom" "e");; ZOOM
    (setq #fANG (nth 2 #XLD$))
    (if (= &fDIR "L") (setq #fANG (+ pi #fANG)))
    (setq #dMOV (Pcpolar '(0 0 0) #fANG &fMOV)) ;�ړ���_
    ; �폜���[�h�̍ۂ�&eNEW�i�폜�}�`�j���ړ�����
    (if (or (= &sMODE "INS")(= &sMODE "DEL")) (ssadd &eNEW #ss) (ssdel &eNEW #ss))
    (if (and #ss (/= (sslength #ss) 0))(progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        ; �אڐ}�`���X�g�Ƌ��ʂ̂��̂������ړ�
        (if (member #en #eNEXT$)
          (progn
            (setq #ss2 (CFGetSameGroupSS (ssname #ss #i)))
            (command "_move" #ss2 "" '(0 0 0) #dMOV)
          ); progn
          ;00/07/24 SN ADD ܰ�į�߂̎��͂��̂܂܈ړ�(İٗp��߰��̎��̂�ܰ�į��ߗL)
          (if (CFGetXData #en "G_WRKT")
            (command "_move" #en "" '(0 0 0) #dMOV)
          ); if
        ); if
        (setq #i (1+ #i))
      ); repeat
      ;00/07/27 SN ADD ����т����݂���ꍇ�͊���т��ĕ\��
      (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
        (progn
          (setq CG_BASESYM (CFGetBaseSymXRec))
          (ResetBaseSym)
          (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
        ); progn
        (setq CG_BASESYM nil)
      )
     )); if progn
     (command "_zoom" "p");; ZOOM
   )); if progn
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  ;CFNoSnapStart�͊O���ϐ��ɒl���m�ۂ���ד�d�Ăяo�Ō��̒l�������B�����͓����ōs��
  (setvar "OSMODE"   #osmode)          ;00/07/21 SN ADD
  (setvar "SNAPMODE" #snapmode)        ;00/07/21 SN ADD
) ;PcMoveItemAround

;<HOM>*************************************************************************
; <�֐���>    : KcMoveItemAround_INS
; <�����T�v>  : �̈�ƕ����w���ɂ����͂̐}�`�̈ړ�(�}����p)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/01/29 YM "INS" ��p
; <���l>      :
;*************************************************************************>MOH<
(defun KcMoveItemAround_INS (
  &eNEW     ; �V�݃A�C�e��
  &eBASE    ; ��A�C�e��
  &fDIR     ; �A���z�u�^�C�v�@"L"���A"R"�E
  &fMOV     ; �ړ���
  /
  #DMOV #EADD$ #EN #ENEXT$ #FANG #I #OSMODE #SNAPMODE #SS #SS2 #TEMP$ #XLD$
  )
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̏�
  ;CFNoSnapStart�͊O���ϐ��ɒl���m�ۂ���ד�d�Ăяo�Ō��̒l�������B�����͓����ōs��
  (setq #osmode   (getvar "OSMODE"))   ;00/07/21 SN ADD
  (setq #snapmode (getvar "SNAPMODE")) ;00/07/21 SN ADD
  (setvar "OSMODE"   0)                ;00/07/21 SN MOD
  (setvar "SNAPMODE" 0)                ;00/07/21 SN MOD

  (setq #XLD$ (CFGetXData &eNEW "G_LSYM"))

  ; �ړ��Ώ۔͈͂̑S�}�`�擾
  (setq #ss (KcGetSSAroundItem_INS &eNEW &fDIR &fMOV))
  ; �Ώې}�`�̗אڐ}�`���擾
  (setq #eNEXT$ (PcGetNextMoveItem$ &eNEW nil))

;;;    ; �A�����[�h  ��}�`�ƐV�}�`�͈ړ����Ȃ��̂�#ss #eNEXT$ ���甲��
;;;    ((= &sMODE "CNT")
  (if (and #ss (/= (sslength #ss) 0))
    (progn
      (ssdel &eBASE #ss)
      (ssdel &eNEW #ss)
    )
  );_if

  (setq #TEMP$ nil)
  (foreach #eNT #eNEXT$
    (if (and (not (equal #eNT &eNEW)) (not (equal #eNT &eBASE)))
      (setq #TEMP$ (cons #eNT #TEMP$))
    )
  )
  (setq #eNEXT$ #TEMP$)

  ; �͈͑S�}�`�̂Ȃ�����#eNEXT$�̊e�A�C�e���Ɠ��͈� �������̂��̂�I��
  (setq #eADD$ (PcGetSameAreaItem$ #ss #eNEXT$))
  (setq #eNEXT$ (append #eADD$ #eNEXT$)) ; �אږ����X�g�ɒǉ�
  (if (and #ss (/= (sslength #ss) 0))
    (progn
      (command "_zoom" "e");; ZOOM
      (setq #fANG (nth 2 #XLD$))
      (if (= &fDIR "L") (setq #fANG (+ pi #fANG)))
      (setq #dMOV (Pcpolar '(0 0 0) #fANG &fMOV)) ;�ړ���_

      (if (and #ss (/= (sslength #ss) 0))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            ; �אڐ}�`���X�g�Ƌ��ʂ̂��̂������ړ�
            (if (member #en #eNEXT$)
              (progn
                (setq #ss2 (CFGetSameGroupSS (ssname #ss #i)))
                (command "_move" #ss2 "" '(0 0 0) #dMOV)
              ); progn
              ;00/07/24 SN ADD ܰ�į�߂̎��͂��̂܂܈ړ�(İٗp��߰��̎��̂�ܰ�į��ߗL)
              (if (CFGetXData #en "G_WRKT")
                (command "_move" #en "" '(0 0 0) #dMOV)
              ); if
            ); if
            (setq #i (1+ #i))
          ); repeat
          ;00/07/27 SN ADD ����т����݂���ꍇ�͊���т��ĕ\��
          (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
            (progn
              (setq CG_BASESYM (CFGetBaseSymXRec))
              (ResetBaseSym)
              (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
            ); progn
            (setq CG_BASESYM nil)
          );_if
        )
      ); if
      (command "_zoom" "p");; ZOOM
    )
  ); if
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  ;CFNoSnapStart�͊O���ϐ��ɒl���m�ۂ���ד�d�Ăяo�Ō��̒l�������B�����͓����ōs��
  (setvar "OSMODE"   #osmode)          ;00/07/21 SN ADD
  (setvar "SNAPMODE" #snapmode)        ;00/07/21 SN ADD
) ;KcMoveItemAround_INS

;<HOM>*************************************************************************
; <�֐���>    : KcMoveItemAround_CHG
; <�����T�v>  : �̈�ƕ����w���ɂ����͂̐}�`�̈ړ�(���֐�p)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/01/29 YM "CHG" ��p
; <���l>      : (KcMoveItemAround_CHG #eNEW #type #fMOVE)
;*************************************************************************>MOH<
(defun KcMoveItemAround_CHG (
  &eNEW     ; �V�݃A�C�e��
  &eCHG     ; �폜�������}�`
  &fDIR     ; �A���z�u�^�C�v�@"L"���A"R"�E
  &fMOV     ; �ړ���
  /
  #DMOV #EADD$ #EN #ENEXT$ #FANG #I #OSMODE #SNAPMODE #SS #SS2 #TEMP$ #XLD$
  #DEL_flg #MOV_flg #OLD_FLG #RET$
  )
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̏�
  ;CFNoSnapStart�͊O���ϐ��ɒl���m�ۂ���ד�d�Ăяo�Ō��̒l�������B�����͓����ōs��
  (setq #osmode   (getvar "OSMODE"))   ;00/07/21 SN ADD
  (setq #snapmode (getvar "SNAPMODE")) ;00/07/21 SN ADD
  (setvar "OSMODE"   0)                ;00/07/21 SN MOD
  (setvar "SNAPMODE" 0)                ;00/07/21 SN MOD

  (setq #XLD$ (CFGetXData &eNEW "G_LSYM"))

  ; �ړ��Ώ۔͈͂̑S�}�`�擾
  (setq #ret$ (KcGetSSAroundItem_CHG &eNEW &fDIR &fMOV))
  (setq #ss      (nth 0 #ret$))
  (setq #DEL_flg (nth 1 #ret$)) ; #DEL_flg = 'T ==>�}���}�`���ړ�
  (setq #MOV_flg (nth 2 #ret$)) ; #DEL_flg = 'T ==>�ړ������Ƀ}�C�i�X������
  (setq #OLD_flg (nth 3 #ret$))
  ; �Ώې}�`�̗אڐ}�`���擾
  ; &eCHG �폜�������}�`���Q�Ƃ���
  (setq #eNEXT$ (PcGetNextMoveItem$ &eCHG nil)) ; ���ւ��㷬�ނ�����菬�����ꍇ
  ;;; ���}�`�폜���s
  (command "_erase" (CFGetSameGroupSS &eCHG) "") ; ���}�` &eCHG
  (if (and #ss (> (sslength #ss) 0))(ssdel &eCHG #ss)) ; 01/02/13 YM ADD
  (setq #TEMP$ nil)
  (foreach #eNT #eNEXT$ ; 01/02/13 YM ADD
    (if (equal #eNT &eCHG)
      nil
      (setq #TEMP$ (cons #eNT #TEMP$))
    )
  )
  (setq #eNEXT$ #TEMP$)

  (if #DEL_flg ; #DEL_flg = 'T ==>�V�}�`�͈ړ����Ȃ��̂�#ss #eNEXT$ ���甲��
    (progn
      (if (and #ss (/= (sslength #ss) 0))
        (ssdel &eNEW #ss)
      );_if

      (setq #TEMP$ nil)
      (foreach #eNT #eNEXT$
        (if (equal #eNT &eNEW)
          nil
          (setq #TEMP$ (cons #eNT #TEMP$))
        )
      )
      (setq #eNEXT$ #TEMP$)
    )
  );_if

  ; �͈͑S�}�`�̂Ȃ�����#eNEXT$�̊e�A�C�e���Ɠ��͈� �������̂��̂�I��
  (setq #eADD$ (PcGetSameAreaItem$ #ss #eNEXT$))

  (setq #eNEXT$ (append #eADD$ #eNEXT$)) ; �אږ����X�g�ɒǉ�
  (if (and #ss (/= (sslength #ss) 0))
    (progn
      (command "_zoom" "e");; ZOOM
      (setq #fANG (nth 2 #XLD$))
      (if (= &fDIR "L") (setq #fANG (+ pi #fANG)))
      (if #MOV_flg
        (setq #dMOV (Pcpolar '(0 0 0) #fANG (- &fMOV))) ;�ړ���_
        (setq #dMOV (Pcpolar '(0 0 0) #fANG &fMOV)) ;�ړ���_
      );_if
      (if (and #ss (/= (sslength #ss) 0))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            ; �אڐ}�`���X�g�Ƌ��ʂ̂��̂������ړ�
            (if (member #en #eNEXT$)
              (progn
                (setq #ss2 (CFGetSameGroupSS (ssname #ss #i)))
                (command "_move" #ss2 "" '(0 0 0) #dMOV)
              ); progn
              ;00/07/24 SN ADD ܰ�į�߂̎��͂��̂܂܈ړ�(İٗp��߰��̎��̂�ܰ�į��ߗL)
              (if (CFGetXData #en "G_WRKT")
                (command "_move" #en "" '(0 0 0) #dMOV)
              ); if
            ); if
            (setq #i (1+ #i))
          ); repeat
          ;00/07/27 SN ADD ����т����݂���ꍇ�͊���т��ĕ\��
          (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
            (progn
              (setq CG_BASESYM (CFGetBaseSymXRec))
              (ResetBaseSym)
              (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
            ); progn
            (setq CG_BASESYM nil)
          );_if
        )
      ); if
      (command "_zoom" "p");; ZOOM
    )
  ); if

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  ;CFNoSnapStart�͊O���ϐ��ɒl���m�ۂ���ד�d�Ăяo�Ō��̒l�������B�����͓����ōs��
  (setvar "OSMODE"   #osmode)          ;00/07/21 SN ADD
  (setvar "SNAPMODE" #snapmode)        ;00/07/21 SN ADD
) ;KcMoveItemAround_CHG

;<HOM>*************************************************************************
; <�֐���>    : PcMakeItemSpaceAround
; <�����T�v>  : ��A�C�e�����͂̐}�`���ړ������A�}�`�z�u�̃X�y�[�X������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/08/22 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcMakeItemSpaceAround (
    &sMODE    ; "CNT" "INS" �g�p���̊֐��t���O
    &eBASE    ; ��A�C�e��
    &iAREA$   ; �ړ�������A�C�e�������w�����X�g��= '(CG_SKK_TWO_BAS CG_SKK_TWO_UPP)
    &fDIR     ; �ړ������@"L"���A"R"�E
    &fMOV     ; �ړ���
    &WTflg    ; ���[�N�g�b�v�����������H nil �� T
    /
    #osmode #snapmode #fDIR #ss #eNEXT$ #TEMP$ #eNT #eADD$ #fANG #dMOV #i #en #ss2
  )

  ;;; �n�X�i�b�v�֘A�V�X�e���ϐ�����
  (setq #osmode   (getvar "OSMODE"))
  (setq #snapmode (getvar "SNAPMODE"))
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)
  ;;; �}�����[�h�ƁA�ύX���[�h�́A���ӈړ���"R"���߂���
  (setq #fDIR &fDIR)
  (if (or (= &sMODE "INS")(= &sMODE "CHG")) (setq #fDIR "R"))

  ; �ړ��Ώ۔͈͂̑S�}�`�擾
  (setq #ss (PcGetSSAroundItem &sMODE &eBASE #fDIR  &fMOV &WTflg))

  ; �Ώې}�`�̗אڐ}�`���擾
  (setq #eNEXT$ (PcGetNextMoveItem$ &eBASE &iAREA$))

  (cond
    ; �A�����[�h�Ɛݒu���[�h ��}�`�͈ړ����Ȃ��̂�#ss #eNEXT$ ���甲���Ă���
    ((or (= &sMODE "POS") (= &sMODE "CNT"))
      (if (and #ss (/= (sslength #ss) 0)) (ssdel &eBASE #ss))
      (setq #TEMP$ nil)
      (foreach #eNT #eNEXT$ (if (/= #eNT &eBASE) (setq #TEMP$ (cons #eNT #TEMP$))))
      (setq #eNEXT$ #TEMP$)
    )
    ; �}�����[�h�̏ꍇ�A��}�`�͈ړ�����̂Ŗ����ꍇ #ss #eNEXT$ �ɒǉ�
    ((= &sMODE "INS")
      (if (not #ss) (setq #ss (ssadd)))
      (ssadd &eBASE #ss)
      (if (not (member &eBASE #eNEXT$)) (setq #eNEXT$ (cons &eBASE #eNEXT$)))
    )
  ); cond

  ; �͈͑S�}�`�̂Ȃ�����#eNEXT$�̊e�A�C�e���Ɠ��͈� �������̂��̂�I��
  (setq #eADD$ (PcGetSameAreaItem$ #ss #eNEXT$))
  (setq #eNEXT$ (append #eADD$ #eNEXT$)) ; �אږ����X�g�ɒǉ�

  (if (and #ss (/= (sslength #ss) 0)) (progn
    (command "_zoom" "e");; ZOOM
    (setq #fANG (nth 2 (CFGetXData &eBASE "G_LSYM")))
    (if (= #fDIR "L") (setq #fANG (+ pi #fANG)))
    (setq #dMOV (Pcpolar '(0 0 0) #fANG &fMOV)) ;�ړ���_
    (if (and #ss (/= (sslength #ss) 0))(progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        ; �אڐ}�`���X�g�Ƌ��ʂ̂��̂������ړ�
        (if (member #en #eNEXT$)
          (progn
            (setq #ss2 (CFGetSameGroupSS (ssname #ss #i)))
            (command "_move" #ss2 "" '(0 0 0) #dMOV)
          ); progn
          ; ܰ�į�߂̎��͂��̂܂܈ړ�
          (if (CFGetXData #en "G_WRKT")
            (command "_move" #en "" '(0 0 0) #dMOV)
          ); if
        ); if
        (setq #i (1+ #i))
      ); repeat
      ;00/07/27 SN ADD ����т����݂���ꍇ�͊���т��ĕ\��
      (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
        (progn
          (setq CG_BASESYM (CFGetBaseSymXRec))
          (ResetBaseSym)
          (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
        ); progn
        (setq CG_BASESYM nil)
      )
     )); if progn
     (command "_zoom" "p");; ZOOM
   )); if progn

  ; �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  (setvar "OSMODE"   #osmode)
  (setvar "SNAPMODE" #snapmode)
) ;PcMakeItemSpaceAround

;<HOM>*************************************************************************
; <�֐���>    : PcGetSSAroundItem
; <�����T�v>  : ��A�C�e�����͂̈ړ��Ώ۔͈͂̑S�}�`�擾
; <�߂�l>    : �I���Z�b�g�� nil
; <�쐬>      : 00/08/22 MH
; <���l>      : &WTflg �� T �Ȃ�͈͒��̃��[�N�g�b�v���擾
;*************************************************************************>MOH<
(defun PcGetSSAroundItem (
    &sMODE    ; "CNT" "INS" "CHG" "DEL" �g�p���̊֐��t���O
    &eITEM    ; ��Ƃ���A�C�e��
    &fDIR     ; �ړ������@"L" "R"
    &fMOV     ; �ړ���("CHG"���[�h�̂ݎg�p)
    &WTflg    ; �͈͒��̃��[�N�g�b�v���l�����邩�H
    /
    #fDIR #dP #xd$ #W #D #H #ang #dAREA #fANG #p1 #p2 #p3 #p4 #ss #wss #i
  )
  ;;; �}�����[�h�ƁA�ύX���[�h�́A���ӈړ���"R"���߂���
  (setq #fDIR &fDIR)
  (if (or (= &sMODE "INS")(= &sMODE "CHG")) (setq #fDIR "R"))

  (setq #dP (cdr (assoc 10 (entget &eITEM))))
  (setq #xd$ (CFGetXData &eITEM "G_SYM"))
  (setq #W (nth 3 #xd$))
  (setq #D (nth 4 #xd$))
  (setq #H (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &eITEM "G_LSYM")))

  ;;; �ړ�������}�`�͈̔͂�����4�_�����߂�
  (setq #dAREA
    (cond
      ((= &sMODE "INS") (Pcpolar #dP #ang #W))
      ((= &sMODE "CHG") (Pcpolar #dP #ang (- #W &fMOV)))
      ; �����߂��Ă��Ȃ��Ɨ]���ȃA�C�e���܂őI���Z�b�g�Ɋ܂܂��
      ((= #fDIR "L") (Pcpolar #dP #ang (- #W 5)))
      (t #dP)
  )); setq cond
  (setq #fANG (if (= #fDIR "L") (+ pi #ang) #ang))
  (setq #p1 (polar #dAREA (+ #ang (* 0.5 pi)) 150))
  (setq #p2 (polar #dAREA (+ #ang (* -0.5 pi)) (+ 150 #D)))
  (setq #p3 (polar #p2 #fANG 5000))
  (setq #p4 (polar #p1 #fANG 5000))
  ; �͈̓`�F�b�N�p��
  ;(command "_PLINE" #p1 #p2 #p3 #p4 "c")
  ;(command "_change" (entlast) "" "P" "C" "CYAN" "")

  (setvar "PICKSTYLE" 0)
  ; �ړ��Ώ۔͈͂̑S�}�`�擾
  (setq #ss (PcGetAllItemBetween2Pnt (list #p1 #p2 #p3 #p4)))
  (setq #ss (PcGetRidOfSink #ss)); �͈͒��̃V���N������ 01/03/08 MH ADD
  ; �t���O���݂Ĕ͈͓����[�N�g�b�v������
  (if &WTflg (progn
    (setq #wss (PcGetAllItemBetween2PntWT (list #p1 #p2 #p3 #p4)))
    (if (and #wss (> (sslength #wss) 0)) (progn
      (setq #i 0)
      (repeat (sslength #wss)
        (ssadd (ssname #wss #i) #ss)
        (setq #i (1+ #i))
      ); repeat
    ));if progn
  ));if progn
  #ss
) ;PcGetSSAroundItem

;<HOM>*************************************************************************
; <�֐���>    : KcGetSSAroundItem_INS
; <�����T�v>  : ��A�C�e�����͂̈ړ��Ώ۔͈͂̑S�}�`�擾
; <�߂�l>    : �I���Z�b�g�� nil
; <�쐬>      : 00/08/22 MH 01/01/29 YM ����
; <���l>      :
;*************************************************************************>MOH<
(defun KcGetSSAroundItem_INS (
  &eITEM    ; ��Ƃ���A�C�e��
  &fDIR     ; �ړ������@"L" "R"
  &fMOV     ; �ړ���
  /
  #fDIR #dP #xd$ #W #D #H #ang #dAREA #fANG #p1 #p2 #p3 #p4 #ss #wss #i
  #PP1 #PP2
  )
  (setq #fDIR &fDIR)
  (setq #xd$ (CFGetXData &eITEM "G_SYM"))
  (setq #W (nth 3 #xd$))
  (setq #D (nth 4 #xd$))
  (setq #H (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &eITEM "G_LSYM")))

  ;;; �ړ�������}�`�͈̔͂�����4�_�����߂�
  (setq #pp1 (cdr (assoc 10 (entget &eITEM))))
  (setq #pp2 (Pcpolar #pp1 #ang #W))

  (cond
    ((= #fDIR "L")
      (setq #fANG (+ pi #ang))
      (setq #p1 (polar #pp2 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp2 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
    )
    ((= #fDIR "R")
      (setq #fANG #ang)
      (setq #p1 (polar #pp1 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp1 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
    )
  );_cond

  ; �͈̓`�F�b�N�p��
;;;(command "_PLINE" #p1 #p2 #p3 #p4 "c")
;;;(command "_change" (entlast) "" "P" "C" "CYAN" "")

  (setvar "PICKSTYLE" 0)
  ; �ړ��Ώ۔͈͂̑S�}�`�擾
  (setq #ss (PcGetAllItemBetween2Pnt (list #p1 #p2 #p3 #p4)))
  (setq #ss (PcGetRidOfSink #ss)); �͈͒��̃V���N������ 01/03/08 MH ADD
  #ss
);KcGetSSAroundItem_INS

;<HOM>*************************************************************************
; <�֐���>    : PcGetRidOfSink
; <�����T�v>  : �I���Z�b�g����V���N�}�`�Ɛ���������
; <�߂�l>    : �I���Z�b�g
; <�쐬>      : 01/03/08 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcGetRidOfSink ( &SS / #i #skk #resSS)
  (setq #i 0)
  (setq #resSS (ssadd))
  (repeat (sslength &SS)
    (setq #skk (fix (nth 9 (CFGetXData (ssname &SS #i) "G_LSYM"))))
    (if (not (or (= CG_SKK_INT_SNK #skk) (= CG_SKK_INT_SUI #skk))) ; 01/08/31 YM MOD 510-->��۰��ى� ; 01/08/31 YM MOD 410-->��۰��ى�
      (ssadd (ssname &SS #i) #resSS))
    (setq #i (1+ #i))
  ); repeat
  #resSS
); PcGetRidOfSink

;<HOM>*************************************************************************
; <�֐���>    : KcGetSSAroundItem_CHG
; <�����T�v>  : ��A�C�e�����͂̈ړ��Ώ۔͈͂̑S�}�`�擾
; <�߂�l>    : �I���Z�b�g�� nil
; <�쐬>      : 00/08/22 MH 01/01/29 YM ����
; <���l>      :
;*************************************************************************>MOH<
(defun KcGetSSAroundItem_CHG (
  &eITEM    ; ��Ƃ���A�C�e��
  &fDIR     ; �ړ������@"L" "R"
  &fMOV     ; �ړ���
  /
  #fDIR #dP #xd$ #W #D #H #ang #dAREA #fANG #p1 #p2 #p3 #p4 #ss #wss #i
  #PP1 #PP2
  #DEL_flg ; ����ւ������ނ��ړ��ΏۂɊ܂߂Ȃ�===>T
  #MOV_flg ; �ړ�������ϲŽ������
  )
  (setq #fDIR &fDIR)
  (setq #xd$ (CFGetXData &eITEM "G_SYM"))
  (setq #W (nth 3 #xd$))
  (setq #D (nth 4 #xd$))
  (setq #H (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &eITEM "G_LSYM")))

  ;;; �ړ�������}�`�͈̔͂�����4�_�����߂�
  (setq #pp1 (cdr (assoc 10 (entget &eITEM))))
  (setq #pp2 (Pcpolar #pp1 #ang #W))

  (cond
    ((and (> &fMOV 0)(= #fDIR "L")) ; ����蕝�L�����ނō��Ɉړ�
      (setq #fANG (+ pi #ang)) ; �}�����ꂽ���ނ͈ړ�����
      (setq #p1 (polar #pp1 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp1 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
      (setq #DEL_flg nil)
    )
    ((and (> &fMOV 0)(= #fDIR "R")) ; ����蕝�L�����ނŉE�Ɉړ�
      (setq #fANG #ang) ; �}�����ꂽ���ނ͈ړ����Ȃ�
      (setq #p1 (polar #pp1 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp1 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
      (setq #DEL_flg T)
    )
    ((and (< &fMOV 0)(= #fDIR "R")) ; ����蕝�������ނŉE�Ɉړ�
      (setq #fANG (+ pi #ang)) ; �}�����ꂽ���ނ͈ړ�����
      (setq #p1 (polar #pp1 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp1 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
      (setq #DEL_flg nil)
      (setq #MOV_flg T)
    )
    ((and (< &fMOV 0)(= #fDIR "L")) ; ����蕝�������ނō��Ɉړ�
      (setq #fANG #ang) ; �}�����ꂽ���ނ͈ړ����Ȃ�
      (setq #p1 (polar #pp2 (+ #ang (* 0.5 pi)) 150))
      (setq #p2 (polar #pp2 (+ #ang (* -0.5 pi)) (+ 150 #D)))
      (setq #p3 (polar #p2 #fANG 5000))
      (setq #p4 (polar #p1 #fANG 5000))
      (setq #DEL_flg T)
      (setq #MOV_flg T)
    )
  );_cond

  ; �͈̓`�F�b�N�p��
;;;(command "_PLINE" #p1 #p2 #p3 #p4 "c")
;;;(command "_change" (entlast) "" "P" "C" "CYAN" "")

  (setvar "PICKSTYLE" 0)
  ; �ړ��Ώ۔͈͂̑S�}�`�擾
  (setq #ss (PcGetAllItemBetween2Pnt (list #p1 #p2 #p3 #p4)))
  ;03/03/28 YM ADD-S �G���[����
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #ss (PcGetRidOfSink #ss)); �͈͒��̃V���N������ 01/03/08 MH ADD
    )
    (progn
      (CFAlertErr "�ړ����镔�ނ�����܂���")
    )
  );_if
  (list #ss #DEL_flg #MOV_flg)
);KcGetSSAroundItem_CHG

;<HOM>*************************************************************************
; <�֐���>    : PcGetNextMoveItem$
; <�����T�v>  : �w��}�`�ɗאڂ��Ĉړ��̉\���̂���A�C�e���̃��X�g���쐬
; <�߂�l>    : �}�`�����X�g �����̐}�`���Ȃ���� Nil
; <�쐬>      : 00/08/22 MH
; <���l>      : �A�C�e�������w�����X�g��nil�Ȃ�A&eSYM����͈͂����܂�
;*************************************************************************>MOH<
(defun PcGetNextMoveItem$ (
  &eSYM       ; �Ώې}�`��
  &iAREA$     ; �ړ�������A�C�e�������w�����X�g ��= '(CG_SKK_TWO_BAS CG_SKK_TWO_UPP)
  /
  #sHIN #eNEXT$ #FLG$
  )
  (defun #AddNextItem$ (&NXT$ &eITEM &iAREA / #eNX #eNXT$)
    (setq #eNX (car (PcGetNextItemSameLevel &eITEM &iAREA)))
    (if #eNX (setq #eNXT$ (PcGetLinkMoveItems #eNX (CFGetSymSKKCode #eNX 2))))
    (append &NXT$ #eNXT$)
  ) ; #AddNextItem$

  (if (= 'LIST &iAREA$)
    (setq #FLG$ &iAREA$)
    (progn
      ; �i���Ŕ��f���ē���P�[�X����
      (setq #sHIN (nth 5 (CFGetXData &eSYM "G_LSYM")))
      (setq #FLG$ (list (CFGetSymSKKCode &eSYM 2)))
    )
  ); if progn

;-- 2011/09/21 A.Satoh Mod - S
;;;;;  ;06/09/07 YM ADD �Ƌ�Ή� ���i����=900���Ώۂɂ���
;;;;;  ;�ƯċL���擾 ;06/08/23 YM ADD-S
;;;;;  (setq #unit (KPGetUnit))
;;;;;  (if (= #unit "T");�u�Ƌ�v�������ꍇ
;;;;;    (progn ;�S���ꏏ�ɓ�����
;;;;;      (setq #eNEXT1$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_BAS));; �אڃt���A
;;;;;      (setq #eNEXT2$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_UPP));; �אڃE�H�[��
;;;;;      (setq #eNEXT3$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_MID));; �אڃ~�h��
;;;;;      (setq #eNEXT4$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_ETC));; �אڂ��̑�(900)
;;;;;      (setq #eNEXT$ (append #eNEXT1$ #eNEXT2$ #eNEXT3$ #eNEXT4$))
;;;;;    )
;;;;;    (progn ;�]��ۼޯ�(�Ƌ�ȊO)
;;;;;
;;;;;      (if (member CG_SKK_TWO_BAS #FLG$)
;;;;;        (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_BAS)));; �אڃt���A
;;;;;      (if (member CG_SKK_TWO_UPP #FLG$)
;;;;;        (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_UPP)));; �אڃE�H�[��
;;;;;      (if (member CG_SKK_TWO_MID #FLG$)
;;;;;        (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_MID)));; �אڃ~�h��
;;;;;      (if (member CG_SKK_TWO_EYE #FLG$)
;;;;;        (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_EYE)));; �אڃA�C���x��
;;;;;    )
;;;;;  );_if
  (if (member CG_SKK_TWO_BAS #FLG$)
    (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_BAS)));; �אڃt���A
  (if (member CG_SKK_TWO_UPP #FLG$)
    (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_UPP)));; �אڃE�H�[��
  (if (member CG_SKK_TWO_MID #FLG$)
    (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_MID)));; �אڃ~�h��
  (if (member CG_SKK_TWO_EYE #FLG$)
    (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_EYE)));; �אڃA�C���x��
  (if (member CG_SKK_TWO_ETC #FLG$)
    (setq #eNEXT$ (#AddNextItem$ #eNEXT$ &eSYM CG_SKK_TWO_ETC)));; �אڂ��̑�
;-- 2011/09/21 A.Satoh Mod - S

  #eNEXT$
); PcGetNextMoveItem$

;;<HOM>***********************************************************************
;;; <�֐���>    : PcChgH800HinbanInList
;;; <�����T�v>  : �n���ꂽ���X�g�̎w��̈ʒu�̕i�Ԃ�H800���� ��K�w����2� �ł����
;;;             : �u�K�w���́v�̕i�Ԃɕϊ�
;;; <�߂�l>    : ���X�g
;;; <�쐬>      : 2000-07-14 MH
;;; <���l>      : H850��H800�ŕi�Ԃ̕ς��A�C�e���ւ̑΍�Ɏg�p
;;;***********************************************************************>MOH<
(defun PcChgH800HinbanInList (
  &ORG$         ; �Ώۃ��X�g
  &i            ; nth �֐��łǂ̈ʒu��ύX���邩�H
  &sCODE        ; SERIES�L��
  /
  #sHIN #RES$ #A #i
  )
  (setq #sHIN (PcChgH800Hin (nth &i &ORG$) &sCODE))
  (setq #i 0)
  (foreach #A &ORG$
    (setq #RES$ (append #RES$ (list (if (= #i &i) #sHIN #A))))
    (setq #i (1+ #i))
  ); foreach
  #RES$
); PcChgH800HinbanInList

;;;<HOM>***********************************************************************
;;; <�֐���>    : PcChgH800Hin
;;; <�����T�v>  : �n���ꂽ�i�ԂŢ�K�w����2����������B�q�b�g�����ꍇ��K�w���̣
;;;             : �̕i�ԁA�q�b�g���Ȃ������ꍇ�A���̕i�Ԃ�Ԃ�
;;; <�߂�l>    : �i�ԕ�����
;;; <�쐬>      : 2000-07-14 MH
;;;***********************************************************************>MOH<
(defun PcChgH800Hin (
  &sHIN         ; �Ώەi��
  &sCODE        ; SERIES�L��
  /
  #QLY$ #sRESHIN
  )
  (setq #QLY$
    (CFGetDBSQLRec CG_DBSESSION (strcat "�K�w" &sCODE)
      (list (list "�K�w����2" &sHIN 'STR))
  ))
  (if #QLY$
    (setq #sRESHIN (nth 2 (car #QLY$)))
    (setq #sRESHIN &sHIN)
  )
  #sRESHIN
);PcChgH800Hin

;<HOM>*************************************************************************
; <�֐���>    : PcChk750CentrItemD
; <�����T�v>  : ���s�l�Z�o�F750�p�L���r���Z���^�[���킹�L���r�Ȃ��_�̃Y�����␳
; <�߂�l>    : �␳�ς݉��s�l (�}�`���s���Ȃ�nil)
; <�쐬>      : 00/07/28 MH
; <���l>      : �A���z�u�A�}���Ȃǂ̊�A�C�e�����s���擾���Ŏg�p
;*************************************************************************>MOH<
(defun PcChk750CentrItemD (&eITEM / #D #resD #sHIN #iSP)
  (setq #sHIN (PcChgH800Hin (nth 5 (CFGetXData &eITEM "G_LSYM")) CG_SeriesCode))
  (setq #resD
    (cond
      ((/= 'ENAME (type &eITEM)) nil)
      ((not #sHIN) nil)
      ((not (setq #D (nth 4 (CFGetXData &eITEM "G_SYM")))) nil)
      (t #D) ;����ȊO
    ); cond
  ); setq
  #resD
); PcChk750CentrItemD
; 00/08/30 SN ADD
; ����т���Ű���ނ̎��͎��t��������ɂ����
; ���Ɖ��s���O�`����݂���擾����B
(defun GetCornerCabWD( &eBase &sDIR
  /
  #lxd
  #xd
  #plpt$
  #plent
  )
  (setq #lxd (CFGetXData &eBase "G_LSYM"))
  (if (= CG_SKK_INT_CNR (nth 9 #lxd)) ; 01/08/31 YM MOD 115-->��۰��ى�
    (progn
      (setq #plent (PKGetPMEN_NO &eBase 2));�O�`���ײ݂̎擾
      (setq #plpt$ (GetLwPolyLinePt #plent));���ײ݂̓_�擾
      (setq #plpt$ (GetPtSeries (cdr (assoc 10 (entget &eBase))) #plpt$));�_�̎��v���萮��
      (if (= "R" &sDIR)
        (list
          (distance (nth 0 #plpt$) (nth 1 #plpt$));��
          (distance (nth 1 #plpt$) (nth 2 #plpt$));���s
        )
        (list
          (distance (nth 5 #plpt$) (nth 0 #plpt$));��
          (distance (nth 4 #plpt$) (nth 5 #plpt$));���s
        )
      )
    );progn
    (progn
      (setq #xd (CFGetXData &eBase "G_SYM"))
      (list (nth 3 #xd) (nth 4 #xd))
    )
  );end if
);GetCornerCabWD

;;;<HOM>*************************************************************************
;;; <�֐���>    : KcSetG_OPT
;;; <�����T�v>  : �A�C�e���Ɋg���ް� "G_OPT"��ǉ��Z�b�g����B
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/02/04 MH 01/04/27 MH ��-1�_�C�A���O�����ύX
;;; <���l>      : �Z�b�g����OPT�Ɛ��̔���̓e�[�u��"�i��OP"�Ŕ���
;;;*************************************************************************>MOH<
(defun KcSetG_OPT (
  &eSYM   ; ����ِ}�`
  /
  #sHIN #QRY$ #QR #sOPT #iHIN #i #iOP #addOP$ #DLG$ #iDN #Dnum$ #FLR$
#QRY2$ ; 02/06/18 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KcSetG_OPT////")
  (CFOutStateLog 1 1 " ")

  (setq #QRY2$ nil) ; 02/06/21 YM ADD ������
  (setq #QRY$ nil)  ; 02/06/21 YM ADD ������

  ; �V��t�B���[�ɂ�OPT�ݒu�\  01/04/03 MH MOD
  (if (setq #FLR$ (CFGetXData &eSYM "G_FILR"))
    (setq #sHIN (car #FLR$))
    (setq #sHIN (nth 5 (CFGetXData &eSYM "G_LSYM"))) ; "�i�Ԗ���"
  ); if

  ;02/06/18 YM ADD-S CG_CeilHeight ; �V�䍂��
  ;�i��OP2�Ƀ��R�[�h������ε�߼�ݕi�Ƃ��ľ�Ă���
  (if (= 'INT (type CG_CeilHeight))
    (progn
      ; 06/09/25 T.Ari Mod �i��OP2�̌����폜
      (setq #QRY2$ nil)
;     (setq #QRY2$ ; ����HIT��
;       (CFGetDBSQLRec CG_DBSESSION "�i��OP2"
;          (list
;            (list "�i�Ԗ���" #sHIN 'STR)
;            (list "�V�䍂��" (itoa CG_CeilHeight) 'INT)
;          )
;       )
;     )
    )
  );_if
  ;02/06/18 YM ADD-E

  (setq #QRY$ ; ����HIT��
    (CFGetDBSQLRec CG_DBSESSION "�i��OP"
       (list (list "�i�Ԗ���" #sHIN 'STR))
    )
  )

  ; 02/06/18 YM ADD-S
  (if #QRY2$
    (setq #QRY$ #QRY2$)
  );_if

  ; 02/06/18 YM ADD-E

  (if #QRY$
    (progn
      (setq #DLG$ nil)
      (setq #addOP$ nil) ; 02/05/13 YM ADD
      (setq #iHIN 0) ; �i�Ԍ�

    ; 02/05/13 YM DEL-S
;;;    (setq #i 0)
;;;    (repeat (length #QRY$)   ; ں��ސ���J��Ԃ�
;;;      (setq #QR (nth #i #QRY$)) ; �eں���
;;;      (setq #sOPT (nth 1 #QR))
;;;      ; #QR�̃I�v�V�����i�� 0 �ȉ��Ȃ�_�C�A���O�������X�g�쐬
;;;      (if (> 0 (nth 3 #QR))
;;;        (setq #DLG$ (append #DLG$ (list #QR)))
;;;        (setq #iOP (fix (nth 3 #QR)))
;;;      ); end of if
;;;      ; �����܂łŃI�v�V�����i����1�ȏ�Ȃ�OPT�ݒu���X�g�Ɏ擾
;;;      (if (<= 1 #iOP) (progn
;;;        (setq #addOP$ (append #addOP$ (list #sOPT #iOP))) ; �i�Ԃƌ�
;;;        (setq #iHIN (1+ #iHIN))
;;;      )); end of if&progn
;;;      (setq #i (1+ #i))
;;;    ); repeat
    ; 02/05/13 YM DEL-E

      ; 02/05/13 YM MOD-S
      (setq #i 0)
      (repeat (length #QRY$)   ; ں��ސ���J��Ԃ�
        (setq #QR (nth #i #QRY$)) ; �eں���
        (setq #sOPT (nth 1 #QR))
        (setq #iOP (fix (nth 3 #QR)))

        ; #QR�̃I�v�V�����i�� 0 �ȉ��Ȃ�_�C�A���O�������X�g�쐬
        (if (> 0 #iOP)
          (setq #DLG$ (append #DLG$ (list #QR)))
        );_if

        ; �I�v�V�����i����1�ȏ�Ȃ�OPT�ݒu���X�g�Ɏ擾
        (if (<= 1 #iOP)
          (progn
            (setq #addOP$ (append #addOP$ (list #sOPT #iOP))) ; �i�Ԃƌ�
            (setq #iHIN (1+ #iHIN))
          )
        );_if
        (setq #i (1+ #i))
      ); repeat
      ; 02/05/13 YM MOD-E

      ; ��-1 �̃��X�g���擾����Ă���΁A�_�C�A���O����
      (if #DLG$
        (progn
          (if (= "Cancel" (setq #Dnum$ (KcOPTDlg #DLG$)))
            (progn
    ;;;01/05/09YM@          (command "_undo" "b")(exit)
              (exit) ; 01/05/09 YM undo�̂��߂�?
            )
          );_if
          (setq #i 0)
          ; �_�C�A���O�̌��ʃ��X�g��̌���1�ȏ�Ȃ�OPT�ݒu���X�g�Ɏ擾
          (foreach #iDN #Dnum$
            (if (< 0 #iDN) (progn
              (setq #sOPT (nth 1 (nth #i #DLG$)))
              (setq #addOP$ (append #addOP$ (list #sOPT #iDN))) ; �i�Ԃƌ�
              (setq #iHIN (1+ #iHIN))
            )); if progn
            (setq #i (1+ #i))
          );foreach
        )
      );_if

      ; �ŏI�I�ɕi�Ԍ���0�Ȃ猋�ʃ��X�gnil��� 1�ȏ�Ȃ�i�Ԍ���OPT�ݒu���X�g�t��
      (setq #addOP$ (if (< 0 #iHIN) (cons #iHIN #addOP$) nil))

      ; �A�C�e����OPT�t�����s
      (if #addOP$
        (progn
          (if (= (tblsearch "APPID" "G_OPT") nil)
            (regapp "G_OPT");�A�v���P�[�V�������o�^
          );_if
          (CFSetXData &eSYM "G_OPT" #addOP$)
        )
      );_if
    )
  );_if

  (princ)
); KcSetG_OPT

;<HOM>*************************************************************************
; <�֐���>    : KcOPTDlg
; <�����T�v>  : ���X�g�̕i�Ԃ�\���B���̕��L���̃��X�g���擾
; <�߂�l>    : 1= �L, 0= ��, �̃��X�g�� "Cancel"
; <�쐬>      : 01/04/27 MH
; <���l>      : �\������i�Ԃ̐���4�܂őΉ�
;*************************************************************************>MOH<
(defun KcOPTDlg ( &QLY$ / #iQLY #sDLG #dcl_id #RES$ #i #Q$ #BIKOU
  )
  (defun ##GetRes$ ( / #i #RES$)
    (setq #i 1)
    (setq #RES$ nil)
    (repeat #iQLY
      (setq #RES$ (append #RES$ (list (atoi (get_tile (strcat "RES" (itoa #i)))))))
      (setq #i (1+ #i))
    ); repeat
    #RES$
  ); ##GetRes$

  (setq #iQLY (length &QLY$))
  (setq #sDLG (strcat "GetKcOPTDlg" (itoa (if (< 4 #iQLY) 4 #iQLY))))
  ;;; �_�C�A���O�̎��s�� (���X�g�̓��e���Ń_�C�A���O���ω�)
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog #sDLG #dcl_id)) (exit))
  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #RES$ (##GetRes$)) (done_dialog)")
  (action_tile "cancel" "(setq #RES$ \"Cancel\") (done_dialog)")
  ;;;�f�t�H�l���
  (setq #i 0)
  (repeat #iQLY
    (setq #Q$ (nth #i &QLY$))

    ; 02/06/17 YM MOD-S
    (setq #BIKOU (nth 5 #Q$))
    (if (/= #BIKOU nil)
      (set_tile (strcat "STR" (itoa (1+ #i))) (strcat (nth 1 #Q$) " �i" #BIKOU "�j"))
      (set_tile (strcat "STR" (itoa (1+ #i))) (strcat (nth 1 #Q$) ))
    );_if
;;;    (set_tile (strcat "STR" (itoa (1+ #i))) (strcat (nth 1 #Q$) " �i" (nth 5 #Q$) "�j"))
    ; 02/06/17 YM MOD-E

    (setq #i (1+ #i))
  ); repeat
  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; ���ʃ��X�g��Ԃ�
  #RES$
); KcOPTDlg

;<HOM>*************************************************************************
; <�֐���>    : PcGetOpNumDlg
; <�����T�v>  : ���[�U�[�ɃI�v�V�����i�̗L�������߂�_�C�A���O
; <�߂�l>    : 1 �� 0
; <�쐬>      : 00/11/24 MH �_�C�A���O�ύX�ɂƂ��Ȃ���������
; <���l>      :
;*************************************************************************>MOH<
(defun PcGetOpNumDlg (
  &sHin       ; �I�v�V�����i��
  &sDefo      ; "Yes" "No" �f�t�H���g�w��
  /
  #sNAME #iOP #sYN
  )
  (setq #sNAME (PcGetPrintName &sHin))
  (if (= "" #sNAME) (setq #sNAME (strcat "�i�ԁF" &sHin)))
  (setq #sYN (if (= "Yes" &sDefo) "36" "294"))
  (setq #iOP
    (if (= "6" (CfMsgBox (strcat #sNAME "���g�p���܂����H") "�m�F" #sYN)) 1 0)
  )
  #iOP
);PcGetOpNumDlg

;<HOM>*************************************************************************
; <�֐���>    : C:SelectParts_otherseries
; <�����T�v>  : ���̼ذ�ނ��ذ���ݐ݌v���J��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/10/22 YM
; <���l>      : ���Ă�ƭ���ׯ��̒݌˂�z�u���������̗v�]�ɓ����邽��
;*************************************************************************>MOH<
(defun C:SelectParts_otherseries (
  /
  #XRec$ #QRY$ #RET$ #XREC_BEFORE$ #QLY$$
  )
  ; �O����
  (StartUndoErr)

  (setq CG_SERI_HENKOU T)
  ; �ذ���ݐ݌v��ʂ����
  (C:arxStartApp (strcat CG_SysPATH "KillPlan.exe") 0)

  (setq #XRec$ (CFGetXRecord "SERI"))
  (if (= #XRec$ nil)
    (progn
      (CFAlertErr "��x�����i�ݒ肪����Ă��܂���\n���i�ݒ���s���ĉ�����")
      (quit)
    )
  )
  ; ����ۊǂ��Ă���
  (setq #XRec_before$ #XRec$)

  ; DB�������
;;; (setq CG_DBNAME (getstring "\nDB������͂���B(NK_CKN�Ȃ�)"))
  ; "SERIES"����
  (setq #QLY$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "select * from SERIES")))

  (setq #ret$ (KP_ChSeriDlg2 #QLY$$))
  (if #ret$
    (progn
      (setq CG_SeriesDB     (nth 0 #ret$))
      (setq CG_DBNAME       (nth 1 #ret$))
      (setq CG_SeriesCode   (nth 2 #ret$))
    )
    (quit)
  );_if

;;;  &Title        ;(STR)�_�C�A���O�^�C�g��
;;;  &DBName       ;(STR)�Ώۃf�[�^�x�[�X��
;;;  &SeriCode     ;(STR)SERIES�L��   �����D�� nil==>Xrecord 01/05/09 YM
;;;  &DrSeriCode   ;(STR)��SERIES�L�� �����D�� nil�\ 01/05/09 YM
;;;  &DrColCode    ;(STR)��COLOR�L��   �����D�� nil�\ 01/05/09 YM

  ;// ���ʑI���_�C�A���O
  (setq #ret$
    (SRSelectDoorSeriesDlg
      "��ذ�ޑI��"
      CG_DBNAME      ; �Ώۃf�[�^�x�[�X��
      CG_SeriesCode  ; SERIES�L��
      nil            ; ��SERIES�L��
      nil            ; ��COLOR�L��
    )
  )
  (if (/= #ret$ nil)
    (progn
      (setq CG_DRSeriCode (car #ret$))  ;��SERIES�L��(���[�U�[�I����V��)
      (setq CG_DRColCode  (cadr #ret$)) ;��COLOR�L��(���[�U�[�I����J��)
    )
    (quit)
  );_if

  ; Xrecord�ݒ�
  (setq CG_SetXRecord$
    (list
      CG_DBNAME       ; 1.DB���́�
      CG_SeriesCode   ; 2.SERIES�L����
      CG_BrandCode    ; 3.�u�����h�L��
      CG_DRSeriCode   ; 4.��SERIES�L����
      CG_DRColCode    ; 5.��COLOR�L����
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
  (CFSetXRecord "SERI" CG_SetXRecord$)

  ;// �f�[�^�x�[�X�ɐڑ�
  (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  (if (= nil (tblsearch "APPID" "G_ARW"))  (regapp "G_ARW"))
  (if (= nil (tblsearch "APPID" "G_LSYM")) (regapp "G_LSYM"))

  ;// ���݂̏��i�����t�@�C���ɏ����o��
  (PC_WriteSeriesInfo CG_SetXRecord$)

  (MakeLayer "N_Symbol" 4 "CONTINUOUS")
  (MakeLayer "N_BreakD" 6 "CONTINUOUS")
  (MakeLayer "N_BreakW" 6 "CONTINUOUS")
  (MakeLayer "N_BreakH" 6 "CONTINUOUS")

  ; �ذ���ݐ݌v
  (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 1") 0)

  ; ��ʍ����̼ذ�ނƔ�װ
  ;2011/04/22 YM MOD
  (setvar "MODEMACRO"
    (strcat "�ذ��: " CG_SeriesDB " / ���ڰ��: " CG_DRSeriCode " / ��װ: " CG_DRColCode " / ����: " CG_HIKITE)
  )

  ; �㏈��
  (setq *error* nil)
  (setq CG_SERI_HENKOU T) ; �ذ�ޕύX���׸�
  (princ)
);C:SelectParts_otherseries





;<HOM>*************************************************************************
; <�֐���>    : TK_PosParts
; <�����T�v>  : �z�u
; <�߂�l>    :
; <�쐬>      : 2004/09/10 G.YK
; <���l>      :
;*************************************************************************>MOH<
(defun TK_PosParts (
  &HinBan &LR &Pos &Ang
  &Dan  ;;  �f�ʎw���L��  2005/01/13 G.YK ADD
  &Bunrui ;2011/07/04 YM ADD ����A" or ���["D"
  /
  #LR #KihonReocrd #FigureReocrd #SeriesRecord
  #dwg #ssP #elm #sym
  #n #k #Pos #Ang
  #xd #w #d #h #glsym #gsym #DoorId
#MSG #TENKAI_TYPE
#KIHONRECORD #ONE
  )

  (setq #sym nil)
  (setq #LR (if (or (= &LR nil)(= &LR "")) "Z" &LR))

  (setq #KihonReocrd
    (car (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
      (list
        (list "�i�Ԗ���" &HinBan 'STR)
        (list "LR�L��"   (if (= "Z" #LR) "0" "1") 'INT)
      )
    ))
  )

  (setq #FigureReocrd
    (car (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
      (list
        (list "�i�Ԗ���" &HinBan 'STR)
        (list "LR�敪"   #LR     'STR)
      )
    ))
  )

  (if (and (/= #KihonReocrd nil)(/= #FigureReocrd nil))
    (progn
      ;���i����1�� 2011/04/25 YM ADD
      (setq #one (fix (* 0.01 (nth 3 #KihonReocrd))))
      
      (setq #dwg (nth 6 #FigureReocrd));�}�`ID OK

      (if (and (/= #dwg nil)(/= #dwg ""))
        (progn






;2011/06/14 YM MOD-S EP�ɂ�������Ă��Ȃ���CG�����܂������Ȃ�
;;;         (setq #SeriesRecord
;;;           (car (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
;;;             (list
;;;               (list "�i�Ԗ���" &HinBan 'STR)
;;;               (list "LR�敪"   #LR     'STR)
;;;             )
;;;           ))
;;;         )
;;;         
;;;         (if (/= #SeriesRecord nil)
;;;           (progn
;;;             (setq #DoorId (strcat
;;;                     (if (/= CG_DRSeriCode nil) CG_DRSeriCode "") ","
;;;                     (if (/= CG_DRColCode  nil) CG_DRColCode  "") ","
;;;                     (if (/= CG_HIKITE     nil) CG_HIKITE     "")))
;;;           )
;;;           (progn
;;;             (setq #DoorId "")
;;;           )
;;;         );_if

;�i�Լ؂̑��݂Ō���̂͂܂���[�i�Ԋ�{]�W�J����=0�Ŕ��f����

          (setq #KihonRecord
            (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
              (list
                (list "�i�Ԗ���" &HinBan 'STR)
              )
            )
          )
          (if (and #KihonRecord (= 1 (length #KihonRecord)))
            (progn

              (setq #tenkai_type (nth 4 (car #KihonRecord)));�W�J����
              (if (equal #tenkai_type 0.0 0.001)
                (progn
                  (setq #DoorId (strcat
                          (if (/= CG_DRSeriCode nil) CG_DRSeriCode "") ","
                          (if (/= CG_DRColCode  nil) CG_DRColCode  "") ","
                          (if (/= CG_HIKITE     nil) CG_HIKITE     "")))
                )
                (progn
                  (setq #DoorId "")
                )
              );_if

            )
          );_if

;2011/06/14 YM MOD-E





          ;2011/06/03 YM ADD-S
          (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg)))
            (progn
              (setq #msg (strcat "\n(TK_PosParts)�}�` : ID= " #dwg " ������܂���"))
              (WebOutLog #msg)
            )
          )

          ; ���ނ̑}��
          (command "_insert" (strcat CG_MSTDWGPATH #dwg) &Pos 1 1 &Ang);2009

          ; GSM���ذ�ށAۯ�����Ă���\�������邽�߉�������
          (command "_layer" "T" "*" "") ; �S��w�t���[�Y����
          (command "_layer" "U" "*" "") ; �S��w���b�N����

          ; �z�u���_�Ɗp�x���m��
          (setq #Pos (cdr (assoc 10 (entget (entlast)))))
          (setq #Ang (cdr (assoc 50 (entget (entlast)))))

          ; ����&�O���[�v��
          (command "_explode" (entlast))  ; �C���T�[�g�}�`����
          (SKMkGroup (ssget "P"))
          (setq #ssP (ssget "P" '((0 . "POINT")))) ; ���O�ɍ��ꂽ�I��Ă̒������߲�Ă΂��肠�߂�
          (setq #n 0 #k 0)
          (repeat (sslength #ssP)
            (setq #elm (ssname #ssP #n))
            (if (CFGetXData #elm "G_SYM")
              (progn
                (setq #sym #elm)
                (setq #k (1+ #k))
                (if (>= #k 2)
                  (progn
                    (WebOutLog (strcat "\n������}�`��\"G_SYM\"����������܂��B\n" #dwg))
                  )
                );_if
              )
            );_if
            (setq #n (1+ #n))
          );repeat

          ; LSYM�̐ݒ�
          (setq #glsym
            (list
            #dwg            ;1 :�{�̐}�`ID  :�w�i�Ԑ}�`�x.�}�`ID
            #Pos            ;2 :�}���_    :�z�u��_
            #Ang            ;3 :��]�p�x  :�z�u��]�p�x
            CG_Kcode        ;4 :�H��L��  :CG_Kcode
            CG_SeriesCode   ;5 :SERIES�L��  :CG_SeriesCode
            &HinBan         ;6 :�i�Ԗ���  :�w�i�Ԑ}�`�x.�i�Ԗ���
            #LR             ;7 :L/R�敪   :�w�i�Ԑ}�`�x.����L/R�敪
            #DoorId         ;8 :���}�`ID  :
            ""              ;9 :���J���}�`ID:
            (fix (nth 3 #KihonReocrd))  ;10:���iCODE  :�w�i�Ԋ�{�x.���iCODE
            0               ;11:�����t���O  :�O�Œ�i�P�ƕ��ށj
            0               ;12:�z�u���ԍ�  :�z�u���ԍ�(1�`)
            (fix (nth 2 #FigureReocrd)) ;13:�p�r�ԍ�  :�w�i�Ԑ}�`�x.�p�r�ԍ���OK
            (nth 5 #FigureReocrd)   ;14:���@�g  :�w�i�Ԑ}�`�x.���@�g ��OK
            (if (/= &Dan nil) &Dan 0) ;15.�f�ʎw���̗L��  :�w�v���\���x.�f�ʗL��
            &Bunrui         ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
            )
          )
          (CFSetXData #sym "G_LSYM" #glsym)

          ; G_SYM�̐ݒ�
          (setq #xd (CFGetXData #sym "G_SYM"))
          (setq #w (nth 3 #FigureReocrd)) ; �v ��OK
          (setq #d (nth 4 #FigureReocrd)) ; �c ��OK
          (setq #h (nth 5 #FigureReocrd)) ; �g ��OK


;;;         (if (> (nth 11 #KihonReocrd) 0)
;;;           (progn
;;;             (SKY_Stretch_Parts #sym #w #d #h)
;;;           )
;;;           (progn

              (setq #gsym
                (list
                  (if (nth 0 #xd)(nth 0 #xd) "")  ;�V���{������
                  (nth 1 #xd)           ;�R�����g�P
                  (nth 2 #xd)           ;�R�����g�Q
                  (if (= #w 0)(nth 4 #xd) #w)   ;�V���{����l�v
                  (if (= #d 0)(nth 5 #xd) #d)   ;�V���{����l�c
                  (if (= #h 0)(nth 6 #xd) #h)   ;�V���{����l�g
                  (nth 6 #xd)           ;�V���{����t������
                  (nth 7 #xd)           ;���͕��@
                  (nth 8 #xd)           ;�v�����t���O
                  (nth 9 #xd)           ;�c�����t���O
                  (nth 10 #xd)          ;�g�����t���O
                  0               ;�L�k�t���O�v
                  0               ;�L�k�t���O�c
                  0               ;�L�k�t���O�g
                  (nth 14 #xd)          ;�u���[�N���C�����v
                  (nth 15 #xd)          ;�u���[�N���C�����c
                  (nth 16 #xd)          ;�u���[�N���C�����g
                )
              )
              (CFSetXData #sym "G_SYM" #gsym)
              
;;;           )
;;;         );_if

          (PCD_MakeViewAlignDoor (list #sym) 3 nil) ;����\��t����
          (KcSetG_OPT #sym)                         ;�Ђ����I�v�V�����i(�}�`�Ȃ�)���Z�b�g����
          (SetLayer)                                ;���C���[�����̏�Ԃɖ߂�

        )
        (progn

        (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")));2008/06/28 OK!
          (progn
            (setq #msg (strcat "\n�i�Ԑ}�`�ɐ}�`ID���o�^����Ă��܂���: �i��= " &HinBan ))
            (WebOutLog #msg)
          )
        )

        )
      );_if
      
    )
  );_if

  #sym
);TK_PosParts

;-- 2011/12/22 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : TK_PosParts2
; <�����T�v>  : �z�u
; <�߂�l>    :
; <�쐬>      : 2011/12/22 A.Satoh
; <���l>      :TK_PosParts ���R�s�[���ĉ���
;             : TK_PosParts�̔���\��Ȃ��o�[�W����
;*************************************************************************>MOH<
(defun TK_PosParts2 (
	&HinBan
	&LR
	&Pos
	&Ang
	&Dan  		; �f�ʎw���L��  2005/01/13 G.YK ADD
	&Bunrui 	; ����A" or ���["D"
	/
	#sym #LR #KihonReocrd
	#FigureReocrd
	#one #dwg #KihonRecord #tenkai_type #DoorId
	#msg #dwg
	#pos #ang
	#ssP #n #k #elm
	#xd #w #d #h #glsym #gsym
	)

	(setq #sym nil)
	(setq #LR (if (or (= &LR nil)(= &LR "")) "Z" &LR))

	(setq #KihonReocrd
		(car (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
			(list
				(list "�i�Ԗ���" &HinBan 'STR)
				(list "LR�L��"   (if (= "Z" #LR) "0" "1") 'INT)
			)
		))
	)

	(setq #FigureReocrd
		(car (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
			(list
				(list "�i�Ԗ���" &HinBan 'STR)
				(list "LR�敪"   #LR     'STR)
			)
		))
	)

	(if (and (/= #KihonReocrd nil)(/= #FigureReocrd nil))
		(progn
			; ���i����1��
			(setq #one (fix (* 0.01 (nth 3 #KihonReocrd))))

			(setq #dwg (nth 6 #FigureReocrd))	; �}�`ID

			(if (and (/= #dwg nil)(/= #dwg ""))
				(progn
					;�i�Լ؂̑��݂Ō���̂͂܂���[�i�Ԋ�{]�W�J����=0�Ŕ��f����
					(setq #KihonRecord
						(CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
							(list
								(list "�i�Ԗ���" &HinBan 'STR)
							)
						)
					)
					(if (and #KihonRecord (= 1 (length #KihonRecord)))
						(progn
							(setq #tenkai_type (nth 4 (car #KihonRecord))) ; �W�J����
							(if (equal #tenkai_type 0.0 0.001)
								(progn
									(setq #DoorId
										(strcat
											(if (/= CG_DRSeriCode nil) CG_DRSeriCode "") ","
											(if (/= CG_DRColCode  nil) CG_DRColCode  "") ","
											(if (/= CG_HIKITE     nil) CG_HIKITE     "")
										)
									)
								)
								(progn
									(setq #DoorId "")
								)
							)
						)
					)

					(if (= nil (findfile (strcat CG_MSTDWGPATH #dwg)))
						(progn
							(setq #msg (strcat "\n(TK_PosParts)�}�` : ID= " #dwg " ������܂���"))
							(WebOutLog #msg)
						)
					)

					; ���ނ̑}��
					(command "_insert" (strcat CG_MSTDWGPATH #dwg) &Pos 1 1 &Ang);2009

					; GSM���ذ�ށAۯ�����Ă���\�������邽�߉�������
					(command "_layer" "T" "*" "") ; �S��w�t���[�Y����
					(command "_layer" "U" "*" "") ; �S��w���b�N����

					; �z�u���_�Ɗp�x���m��
					(setq #Pos (cdr (assoc 10 (entget (entlast)))))
					(setq #Ang (cdr (assoc 50 (entget (entlast)))))

					; ����&�O���[�v��
					(command "_explode" (entlast))  ; �C���T�[�g�}�`����
					(SKMkGroup (ssget "P"))

					; ���O�ɍ��ꂽ�I��Ă̒������߲�Ă΂��肠�߂�
					(setq #ssP (ssget "P" '((0 . "POINT"))))
					(setq #n 0 #k 0)
					(repeat (sslength #ssP)
						(setq #elm (ssname #ssP #n))
						(if (CFGetXData #elm "G_SYM")
							(progn
								(setq #sym #elm)
								(setq #k (1+ #k))
								(if (>= #k 2)
									(progn
										(WebOutLog (strcat "\n������}�`��\"G_SYM\"����������܂��B\n" #dwg))
									)
								);_if
							)
						);_if
						(setq #n (1+ #n))
					);repeat

					; LSYM�̐ݒ�
					(setq #glsym
						(list
							#dwg													;1 :�{�̐}�`ID  :�w�i�Ԑ}�`�x.�}�`ID
							#pos													;2 :�}���_    :�z�u��_
							#ang													;3 :��]�p�x  :�z�u��]�p�x
							CG_Kcode											;4 :�H��L��  :CG_Kcode
							CG_SeriesCode									;5 :SERIES�L��  :CG_SeriesCode
							&HinBan												;6 :�i�Ԗ���  :�w�i�Ԑ}�`�x.�i�Ԗ���
							#LR														;7 :L/R�敪   :�w�i�Ԑ}�`�x.����L/R�敪
							#DoorId												;8 :���}�`ID  :
							""														;9 :���J���}�`ID:
							(fix (nth 3 #KihonReocrd))		;10:���iCODE  :�w�i�Ԋ�{�x.���iCODE
							0															;11:�����t���O  :�O�Œ�i�P�ƕ��ށj
							0															;12:�z�u���ԍ�  :�z�u���ԍ�(1�`)
							(fix (nth 2 #FigureReocrd))		;13:�p�r�ԍ�  :�w�i�Ԑ}�`�x.�p�r�ԍ���OK
							(nth 5 #FigureReocrd)					;14:���@�g  :�w�i�Ԑ}�`�x.���@�g ��OK
							(if (/= &Dan nil) &Dan 0)			;15.�f�ʎw���̗L��  :�w�v���\���x.�f�ʗL��
							&Bunrui												;16:����(����"A" or ���["D")
						)
					)
					(CFSetXData #sym "G_LSYM" #glsym)

					; G_SYM�̐ݒ�
					(setq #xd (CFGetXData #sym "G_SYM"))
					(setq #w (nth 3 #FigureReocrd)) ; �v ��OK
					(setq #d (nth 4 #FigureReocrd)) ; �c ��OK
					(setq #h (nth 5 #FigureReocrd)) ; �g ��OK

					(setq #gsym
						(list
							(if (nth 0 #xd)(nth 0 #xd) "")	; �V���{������
							(nth 1 #xd)											; �R�����g�P
							(nth 2 #xd)											; �R�����g�Q
							(if (= #w 0)(nth 4 #xd) #w)			; �V���{����l�v
							(if (= #d 0)(nth 5 #xd) #d)			; �V���{����l�c
							(if (= #h 0)(nth 6 #xd) #h)			; �V���{����l�g
							(nth 6 #xd)											; �V���{����t������
							(nth 7 #xd)											; ���͕��@
							(nth 8 #xd)											; �v�����t���O
							(nth 9 #xd)											; �c�����t���O
							(nth 10 #xd)										; �g�����t���O
							0																; �L�k�t���O�v
							0																; �L�k�t���O�c
							0																; �L�k�t���O�g
							(nth 14 #xd)										; �u���[�N���C�����v
							(nth 15 #xd)										; �u���[�N���C�����c
							(nth 16 #xd)										; �u���[�N���C�����g
						)
					)
					(CFSetXData #sym "G_SYM" #gsym)

					(KcSetG_OPT #sym) ; �Ђ����I�v�V�����i(�}�`�Ȃ�)���Z�b�g����
					(SetLayer)				;���C���[�����̏�Ԃɖ߂�
				)
				(progn
					(if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")))
						(progn
							(setq #msg (strcat "\n�i�Ԑ}�`�ɐ}�`ID���o�^����Ă��܂���: �i��= " &HinBan ))
							(WebOutLog #msg)
						)
					)
				)
			)
		)
	)

  #sym

);TK_PosParts
;-- 2011/12/22 A.Satoh Add - E

;-- 2011/08/03 A.Satoh Add - S
;;;<HOM>***********************************************************************
;;; <�֐���>    : CheckDoorGradeFree
;;; <�����T�v>  : ���O���[�h�ʔz�u�s���ރ`�F�b�N
;;;             :   ����̕i�Ԗ��̂��w�肳�ꂽ���̃O���[�h�A�F�ł���ꍇ��
;;;             :   ���݂ł��Ȃ����ǂ������`�F�b�N����
;;; <�߂�l>    : T   �� ���݉�
;;;             : nil �� ���ݕs��
;;; <�쐬>      : 11/08/03 A.Satoh
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun CheckDoorGradeFree (
  &hinban   ; �i�Ԗ���
  &DrSeries ; ���V���[�Y�L��
  &DrColor  ; ���F�L��
  /
  #ret #idx #qry$$ #qry$ #ser_lst$ #col_lst$ #ser #col
	#flag
  )

  (setq #ret T)

  ; �i�Ԗ��̎擾
  ; ���V���ʔ�Ώە��ނ�����𒊏o����
  (setq #qry$$ (CFGetDBSQLRec CG_DBSESSION "���V���ʔ�Ή�����" (list (list "�i�Ԗ���" &hinban 'STR))))

  ; ���V���[�Y��Ώە��ރ`�F�b�N
  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #qry$ (nth 0 #qry$$))
      (setq #ser (nth 2 #qry$))
      (if (/= #ser "ALL")
        (setq #ser_lst$ (StrParse #ser ","))
      )
      (setq #col (nth 3 #qry$))
      (if (/= #col "ALL")
        (setq #col_lst$ (StrParse #col ","))
      )
      (setq #flag (nth 4 #qry$))

      (cond
        ((and (= #ser "ALL") (= #col "ALL"))
          (if (= #flag "NG")
            (setq #ret nil)
          )
        )
        ((and (/= #ser "ALL") (= #col "ALL"))
          (if (/= (member &DrSeries #ser_lst$) nil)
            (if (= #flag "NG")
              (setq #ret nil)
            )
            (if (= #flag "OK")
              (setq #ret nil)
            )
          )
        )
        ((and (= #ser "ALL") (/= #col "ALL"))
          (if (/= (member &DrColor #col_lst$) nil)
            (if (= #flag "NG")
              (setq #ret nil)
            )
            (if (= #flag "OK")
              (setq #ret nil)
            )
          )
        )
        (T
          (if (and (/= (member &DrSeries #ser_lst$) nil)
                   (/= (member &DrColor  #col_lst$) nil))
            (if (= #flag "NG")
              (setq #ret nil)
            )
            (if (= #flag "OK")
              (setq #ret nil)
            )
          )
        )
      )
    )
  )

  #ret

);CheckDoorGradeFree
;-- 2011/08/03 A.Satoh Add - E

; �ȉ��A�t���[���L�b�`���Ή�
;<HOM>*************************************************************************
; <�֐���>    : OutputKanaguInfo
; <�����T�v>  : �t���[���L�b�`���̏ꍇ"HOSOKU.cfg"�ɋ�����o��(�t���[�����Z�o)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2017/06/13 KY
; <���l>      :
;*************************************************************************>MOH<
(defun OutputKanaguInfo (
	/
	#masterKanaguList$$ ; ����Z�b�g�̕i��/����/ID/1�Z�b�g��������̃��X�g			���[�J���ϐ��錾(�����l nil)
	#frames$$ ; �t���[�����
	#frameHinbans$ ; �t���[���̕i�Ԃ̃��X�g
	#kanaguRem
	#kanaguCnt
	#kanaguInfo$
	#kanaguInfo$$ ; ��������
	#kanaguInfoOrg$$ ; ��������(�����ώZ�O)
	#kanaguInfo
	#needSaveCfg
	#hinbanK
	#nameK
	#countK
	#idK
	#qpsK
	)

	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn
			(setq #needSaveCfg nil)
			(setq #frames$$ (GetFrameInfo$$ T nil))
			(princ (strcat "\n�t���[���̌�=" (itoa (length (nth 0 #frames$$))))) ; debug�p
			(setq #frameHinbans$ (mapcar 'caddr (nth 0 #frames$$)))					;| ���X�g�� 1 �Ԗڂ̗v�f�� 3 �Ԗڂ̗v�f(�t���[���̕i��) #frameHinbans$�ɑ�� |;
			(setq #masterKanaguList$$ (GetMasterKanaguList$$))
			(setq #kanaguInfoOrg$$ (GetKanaguCnt$$ #masterKanaguList$$)) ; �i��/����/��/����/ID/1�Z�b�g��������̃��X�g

			(if (< 0 (apply '+ (mapcar 'caddr #kanaguInfoOrg$$)))
				; ���ݒ�ς݂ł���Ύ����ώZ���Ȃ�
				(setq #kanaguInfo$$ (mapcar
					'(lambda (#kanaguInfo$) (append #kanaguInfo$ (list nil)))
					#kanaguInfoOrg$$))
				;else
				(progn
					(setq #kanaguCnt (IntegrateKanaguCnt #frameHinbans$)) ; ����̌�

					(setq #kanaguInfo$$ nil)
					(foreach #kanaguInfo$ #kanaguInfoOrg$$										;| ����Z�b�g�i�Ԃ̃��R�[�h�����[�v(ID��) |;
						(setq #hinbanK (nth 0 #kanaguInfo$))
						(setq #nameK (nth 1 #kanaguInfo$))
						(setq #countK (nth 2 #kanaguInfo$))
						(setq #idK (nth 4 #kanaguInfo$))										;| ����Z�b�g�i��.ID |;
						(setq #qpsK (nth 5 #kanaguInfo$))										;| ����Z�b�g�i��.���鐔 |;

						(if (< 0 #kanaguCnt)
							(progn
								(setq #kanaguRem (+ #kanaguCnt 1))
								(setq #kanaguCnt (- (rem #kanaguRem #qpsK) 1))
								(setq #kanaguRem (fix (/ #kanaguRem #qpsK)))
								(princ (strcat "\n����Z�b�g[" #hinbanK "]�̌��̐ώZ: " (itoa #kanaguRem))) ; debug
								(if (> #kanaguRem 0) ; 1�ȏ�ŐώZ�ł����ꍇ
									(progn
										(setq #kanaguInfo$ (append (list-put-nth #kanaguRem #kanaguInfo$ 2) (list T)))
										;;;;(setq #kanaguInfo$ (list-put-nth #kanaguRem #kanaguInfo$ 2))
										(setq #needSaveCfg T)
									);progn
									;else
									(setq #kanaguInfo$ (append #kanaguInfo$ (list nil)))
								);if
							);progn
						);if
;|
						(if (= 0 #countK) ; ����Z�b�g�̌������ݒ�(0)�̏ꍇ
							(progn
								(setq #kanaguCnt (IntegrateKanaguCnt #frameHinbans$ #hinbanK #idK #qpsK)) ; ���̐ώZ
								(princ (strcat "\n����Z�b�g[" #hinbanK "]�̌��̐ώZ: " (itoa #kanaguCnt))) ; debug
								(if (> #kanaguCnt 0) ; 1�ȏ�ŐώZ�ł����ꍇ
									(progn
										;(setq #kanaguInfo$ (list #hinbanK #nameK #kanaguCnt (nth 3 #kanaguInfo$) T))
										(setq #kanaguInfo$ (append (list-put-nth #kanaguCnt #kanaguInfo$ 2) (list T)))
										(setq #needSaveCfg T)
									);progn
									;else
									(setq #kanaguInfo$ (append #kanaguInfo$ (list nil)))
								);if
							);progn
							;else
							(progn
								(princ (strcat "\n����Z�b�g[" #hinbanK "]�̌��ݒ�ς�: " (itoa #countK))) ; debug
							);progn
						);if
|;
						(setq #kanaguInfo$$ (append #kanaguInfo$$ (list #kanaguInfo$)))
					);foreach
				);progn
			);if

			(setq #kanaguInfo "")
			(foreach #kanaguInfo$ #kanaguInfo$$
				(setq #hinbanK (nth 0 #kanaguInfo$))
				(setq #nameK (nth 1 #kanaguInfo$))
				(setq #countK (nth 2 #kanaguInfo$))
				(setq #kanaguInfo (strcat #kanaguInfo " " #nameK "\t" #hinbanK "\t" (itoa #countK) "��\n"))
			);foreach

			(CFYesDialog (strcat "�ώZ��(�����ώZ�Ώ�)\n" #kanaguInfo "���y�ǉ����ށz�Ō����C���ł��܂��B"))

			(if #needSaveCfg
				(SaveKanaguCnt #kanaguInfo$$)
			);if
		);progn
	);if

	(princ)
);OutputKanaguInfo

;<HOM>*************************************************************************
; <�֐���>    : GetFrameInfo$$
; <�����T�v>  : �t���[�����̎擾(�t���[���L�b�`���̂ݗL��)
; <�߂�l>    : �t���[����� ((�}�`�� (X���W Y���W Z���W) �i�� (W D H) (����W ����D ����H) ��]�p�x �c=1/��=2) �c)
;               �J�E���^�[��� ((�}�`�� (X���W Y���W Z���W) �i�� (W D H) (����W ����D ����H) ��]�p�x) �c)
; <�쐬>      : 2017/06/13 KY
; <���l>      :
;*************************************************************************>MOH<
(defun GetFrameInfo$$ (
	&frames   ; (BOOL)�t���[�����擾
	&counters ; (BOOL)�J�E���^�[���擾
	/
	#frames$$ ; �t���[�����
	#counters$$ ; �J�E���^�[���
	#code$
	#ss
	#idx
	#en
	#pt
	#xd$
	#xdl$
	#hinban
	#dimW #dimD #dimH #dimH2
	#dirW #dirD #dirH
	#ang
	#ft
	#d1$ #d2$ #pt1 #pt2
	)

	; �����l�̔�r
	;   -1 : ����1 < ����2
	;    0 : ����1 = ����2
	;    1 : ����1 > ����2
	(defun ##comp ( &d1 &d2 / )
		(cond
			((equal &d1 &d2 0.001)
				0
			)
			((< &d1 &d2)
				-1
			)
			(T
				1
			)
		);cond
	);##comp

	(setq #frames$$ nil)
	(setq #counters$$ nil)

	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn
			(setq #ss (ssget "X" '((-3 ("G_SYM")))))
			(if #ss
				(progn
					(setq #idx 0)
					(repeat (sslength #ss)
						(setq #en (ssname #ss #idx))
						(setq #code$ (CFGetSymSKKCode #en nil))
						(cond
							; �c�t���[���E���t���[���̏ꍇ
							((and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_TWO_BAS (nth 1 #code$)))
								(if &frames
									(progn
										(setq #xd$ (CfGetXData #en "G_SYM"))
										(setq #xdl$ (CfGetXData #en "G_LSYM"))
										(setq #hinban (nth 5 #xdl$)) ; �i��
										(setq #dimW (nth 3 #xd$)) ; G_SYM�̼���ي�lW (����)
										(setq #dimD (nth 4 #xd$)) ; G_SYM�̼���ي�lD (����)
										(setq #dimH (nth 5 #xd$)) ; G_SYM�̼���ي�lH (����)
										(setq #dimH2 (nth 13 #xdl$)) ; G_LSYM�̐��@H (����)
									 	(setq #ang (nth 2 #xdl$)) ; ��]�p�x(���W�A��)
										(setq #dirW (nth 8 #xd$)) ; G_SYM��W�����׸�
										(setq #dirD (nth 9 #xd$)) ; G_SYM��D�����׸�
										(setq #dirH (nth 10 #xd$)) ; G_SYM��H�����׸�
										(setq #ft (GetFrameType #xd$ #xdl$))
										(if (or (= #ft 1) (= #ft 2))
											(progn
												(setq #pt (cdrassoc 10 (entget #en)))
												(setq #frames$$ (append #frames$$
													(list (list #en #pt #hinban (list #dimW #dimD #dimH2) (list #dirW #dirD #dirH) #ang #ft))))
											);progn
										);if
									);progn
								);if
							)
							; �J�E���^�[�̏ꍇ
							((equal #code$ (list CG_SKK_ONE_CNT CG_SKK_TWO_BAS CG_SKK_THR_DIN) 0.1)
								(if &counters
									(progn
										(setq #xd$ (CfGetXData #en "G_SYM"))
										(setq #xdl$ (CfGetXData #en "G_LSYM"))
										(setq #hinban (nth 5 #xdl$)) ; �i��
										(setq #dimW (nth 3 #xd$)) ; G_SYM�̼���ي�lW (����)
										(setq #dimD (nth 4 #xd$)) ; G_SYM�̼���ي�lD (����)
										(setq #dimH (nth 5 #xd$)) ; G_SYM�̼���ي�lH (����)
										(setq #ang (nth 2 #xdl$)) ; ��]�p�x(���W�A��)
										(setq #dirW (nth 8 #xd$)) ; G_SYM��W�����׸�
										(setq #dirD (nth 9 #xd$)) ; G_SYM��D�����׸�
										(setq #dirH (nth 10 #xd$)) ; G_SYM��H�����׸�
										(if (IsCounter #xd$ #xdl$)
											(progn
												(setq #pt (cdrassoc 10 (entget #en)))
												(setq #counters$$ (append #counters$$
													(list (list #en #pt #hinban (list #dimW #dimD #dimH) (list #dirW #dirD #dirH) #ang))))
											);progn
										);if
									);progn
								);if
							)
						);cond
						(setq #idx (1+ #idx))
					);repeat
				);progn
			);if
		);progn
	);if

	(if #frames$$
		; �t���[��������A���K�v�ȏꍇ
		(progn
			; ���W�Ń\�[�g
			(setq #frames$$ (vl-sort #frames$$
																'(lambda ( #d1$ #d2$ )
																	(setq #pt1 (nth 1 #d1$)
																				#pt2 (nth 1 #d2$))
																	(< (+ (* 10 (##comp (nth 0 #pt1) (nth 0 #pt2)))
																		(##comp (nth 1 #pt1) (nth 1 #pt2))) 0)
																)
															))
		);progn
	);if

	(if #counters$$
		; �J�E���^�[������A���K�v�ȏꍇ
		(progn
			; ���W�Ń\�[�g
			(setq #counters$$ (vl-sort #counters$$
																'(lambda ( #d1$ #d2$ )
																	(setq #pt1 (nth 1 #d1$)
																				#pt2 (nth 1 #d2$))
																	(< (+ (* 10 (##comp (nth 0 #pt1) (nth 0 #pt2)))
																		(##comp (nth 1 #pt1) (nth 1 #pt2))) 0)
																)
															))
		);progn
	);if

	(list #frames$$ #counters$$)
);GetFrameInfo$$

;<HOM>*************************************************************************
; <�֐���>    : GetMasterKanaguList$$
; <�����T�v>  : ����Z�b�g�������ă}�X�^�������Z�b�g�̕i�ԂƖ��̂̃��X�g�̎擾
; <�߂�l>    : (LIST)����Z�b�g�̕i�ԂƖ��̂�ID��1�Z�b�g��������̃��X�g
; <�쐬>      : 2017/06/16 KY
; <���l>      :
;*************************************************************************>MOH<
(defun GetMasterKanaguList$$ (
	/
	#rec$$
	#d$
	)

	(setq #rec$$
		(DBSqlAutoQuery CG_DBSESSION
			"SELECT DISTINCT ks.����i�Ԗ���, t.���l2, ks.ID, ks.���鐔 FROM ����Z�b�g�i�� ks, �K�w t WHERE ks.����i�Ԗ���=t.�K�w���� ORDER BY ks.ID"))

	(mapcar '(lambda (#d$) (list (nth 0 #d$) (nth 1 #d$) (fix (nth 2 #d$)) (fix (nth 3 #d$)))) #rec$$)
);GetMasterKanaguList$$

;<HOM>*************************************************************************
; <�֐���>    : IntegrateKanaguCnt
; <�����T�v>  : ����Z�b�g�������ă}�X�^�������̌��̐ώZ
; <�߂�l>    : (INT)����̌�
; <�쐬>      : 2017/06/19 KY
; <���l>      :
;*************************************************************************>MOH<
(defun IntegrateKanaguCnt (
	&frameHinbans$ ; �t���[���̕i�Ԃ̃��X�g
;	&kanaguHinban ; ����Z�b�g�̕i��
;	&kanaguId ; ����Z�b�g��ID
;	&kanaguCntPerSet ; ����Z�b�g��1�Z�b�g������̌�
	/
	#rec$$
	#rec$
	#frameHinban
	#cnt
	#addType
	#addFlg
	;#div
	#div2
	#ret
	)

;	(princ "\n------------")
;	(princ (strcat "\n���ώZ�J�n���@���ﾯĕi��: " &kanaguHinban))
;	(princ "\n------------")
	(setq #ret 0)

	(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
;			(strcat "SELECT �i�Ԗ���,��,���Z�^�C�v FROM ����Z�b�g WHERE ����i��ID="
;							(itoa &kanaguId)
;							" ORDER BY ID")))
			(strcat "SELECT �i�Ԗ���,��,���Z�^�C�v FROM ����Z�b�g ORDER BY ID")))
	(if #rec$$
		(progn
			;(setq #div2 nil)
;			(setq #div2 &kanaguCntPerSet)
			(foreach #rec$ #rec$$
				(setq #addFlg nil) ; 1��݂̂̏ꍇ�̉��Z�ς݃t���O(���R�[�h�P��)
				(setq #cnt (fix (nth 1 #rec$)))				;| ���̐��������� #cnt �ɑ�� |;
				(setq #addType (fix (nth 2 #rec$)))			;| ���Z�^�C�v�̐��������� #addType �ɑ�� |;
				;(setq #div (nth 2 #rec$))
				(foreach #frameHinban &frameHinbans$
					(princ (strcat "\n�i��: " #frameHinban ))
					(if (= 1 (acet-str-find (nth 0 #rec$) #frameHinban nil T))	;| �t���[���i�Ԃ��i�Ԗ���(���K�\��)�Ńq�b�g�����ꍇ |;
						(progn
							(cond
								((= #addType 0) ; 1��̂݉��Z
									(if (not #addFlg)
										(progn
											(princ "\n����1��̂݉��Z")
											(setq #ret (+ #ret #cnt))
										);progn
										;else
										(princ "\n�������Z�ς݂ŃX�L�b�v")
									);if
									(setq #addFlg T)
								)
								((= #addType 1) ; ��ɉ��Z
									(princ "\n������ɉ��Z")
									(setq #ret (+ #ret #cnt))
								)
							);cond
							;(setq #ret (+ #ret #cnt))
							(princ (strcat "�y�{�ǉ��z , �ݐ�: "))(princ #ret)
							;(setq #div2 #div)
						);progn
					);if
				);foreach
			);foreach
;			(if (/= nil #div2)
;				(setq #ret (fix (/ (+ #ret (- #div2 1)) #div2))) ; �[���؂�グ
;				;else
;				(setq #ret 0)
;			);if
		);progn
	);if

;;;	(princ (strcat "\n���ﾯĕi��: " &kanaguHinban))(princ "��: ")(princ  #ret)
	#ret
);IntegrateKanaguCnt

;<HOM>*************************************************************************
; <�֐���>    : ReadHosokuCfg$$
; <�����T�v>  : "HOSOKU.cfg"�̓��e�̎擾
; <�߂�l>    : (LIST)�i��/����/��/���ނ̃��X�g
; <�쐬>      : 2017/06/20 KY
; <���l>      :
;*************************************************************************>MOH<
(defun ReadHosokuCfg$$ (
	&funcChk ; �Ώۂ̑I�ʂ̃R�[���o�b�N�֐�
	&funcOpt
	/
	#fname
	#temp
	#data$$	#data$ #hinban #cnt #name #bunrui
	#add
#DATA2$$ ;2017/07/13 YM ADD
	)

	(setq #data2$$ nil)
	(setq #fname (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
	(if (findfile #fname)
		(progn
			(setq #data$$ (ReadCSVFile #fname))
			(princ "\n #data$$= ")(princ #data$$)

			(if #data$$
				(progn
					(foreach #data$ #data$$
						(setq #temp (StrParse (nth 0 #data$) "="))
						(setq #hinban (nth 0 #temp))
						(setq #cnt (atoi (nth 1 #temp)))
						(setq #name (nth 1 #data$))
						(setq #bunrui (nth 2 #data$)) ; A(�L�b�`��)�̂�
						(if (/= nil &funcChk)
							(setq #add (eval (&funcChk #hinban &funcOpt)))
							;else
							(setq #add T)
						);if
						(if (and #add (> #cnt 0))
							(setq #data2$$ (append #data2$$ (list (list #hinban #name #cnt #bunrui))))
						);if
					);foreach
				);progn
			);if
		);progn
	);if

	#data2$$
);ReadHosokuCfg$$

;<HOM>*************************************************************************
; <�֐���>    : WriteHosokuCfg
; <�����T�v>  : "HOSOKU.cfg"�̏o��(�㏑��)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2017/06/21 KY
; <���l>      :
;*************************************************************************>MOH<
(defun WriteHosokuCfg (
	&data$$ ; �o�̓f�[�^
	/
	#fname #fnameTmp #fd #canRen
	#err #errMsg
	)

	; CFG�t�@�C�������o��
	(defun ##outputCfg (
		&afd &adata$$
		/
		#data$
		#hinban #name #cnt #bunrui
		)
		;;;;�t�@�C�������o��
		(foreach #data$ &adata$$
			(setq #hinban (nth 0 #data$))
			(setq #name (nth 1 #data$))
			(setq #cnt (nth 2 #data$))
			(setq #bunrui (nth 3 #data$))
			(write-line (strcat #hinban "=" (itoa #cnt) "," #name "," #bunrui) &afd)
		);foreach
		nil
	);##outputCfg

	(setq #fname (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
	(setq #fnameTmp (strcat #fname ".tmp"))
	;;;;�t�@�C���I�[�v��
	(setq #fd (open #fnameTmp "w"))
	(if #fd
		(progn ; �I�[�v������
			;;;;�t�@�C�������o��
			(setq #err (vl-catch-all-apply '##outputCfg (list #fd &data$$)))
			;;;;�t�@�C���N���[�Y
			(close #fd)
			(if (vl-catch-all-error-p #err)
				(progn ; �ُ펞
					(setq #errMsg (vl-catch-all-error-message #err))
					(princ (strcat "\ņ�قɏo�͂ł��܂���ł���(\"" #fnameTmp "\")\n" #errMsg "\n"))
					;;;;�t�@�C���폜
					(if (not (vl-file-delete #fnameTmp))
						(princ (strcat "\ņ�ق��폜�ł��܂���ł���(\"" #fnameTmp "\")\n"))
					);if
				);progn
				;else
				(progn ; ���펞
					(setq #canRen T)
					(if (findfile #fname)
						;;;;�t�@�C���폜
						(if (not (setq #canRen (vl-file-delete #fname)))
							(princ (strcat "\ņ�ق��폜�ł��܂���ł���(\"" #fname "\")\n"))
						);if
					);if
					(if #canRen
						;;;;�t�@�C���R�s�[
						(if (not (vl-file-rename #fnameTmp #fname))
							(princ (strcat "\ņ�ق��ϖ��ł��܂���ł���(\"" #fnameTmp "\" �� \"" #fname "\")\n"))
						);if
					);if
				);progn
			);if
		);progn
		;else
		(progn ; �I�[�v�����s
			(princ (strcat "\ņ�ق��J���܂���ł���(\"" #fnameTmp "\")\n"))
		);progn
	);if

	(princ)
);WriteHosokuCfg

;<HOM>*************************************************************************
; <�֐���>    : GetKanaguCnt$$
; <�����T�v>  : �t���[���L�b�`���̏ꍇ"HOSOKU.cfg"�ɏo�͂���Ă������Z�b�g�̌������擾
; <�߂�l>    : (LIST)����Z�b�g�̕i��/����/��/����/ID/1�Z�b�g��������̃��X�g
; <�쐬>      : 2017/06/13 KY
; <���l>      :
;*************************************************************************>MOH<
(defun GetKanaguCnt$$ (
	&masterKanaguList$$ ; ����Z�b�g�̕i��/����/ID/1�Z�b�g��������̃��X�g
	/
	#data$ #hinban #opt #id #qps
	#datatmp$
	#data$$
	#ret$$
	)

	(setq #data$$ (ReadHosokuCfg$$
				(lambda (#hinban #opt)
					(/= nil (assoc #hinban #opt))
				) &masterKanaguList$$))
	(princ "\nHOSOKU.cfg�̋���̓��e: ")(prin1 #data$$) ; debug�p

	(setq #ret$$ nil)
	(foreach #data$ &masterKanaguList$$
		(setq #id (nth 2 #data$))
		(setq #qps (nth 3 #data$))
		(setq #data$ (list-remove-nth 3 #data$)) ; 1�Z�b�g��������̏���
		(setq #data$ (list-remove-nth 2 #data$)) ; ID�̏���
		(if #data$$
			(setq #datatmp$ (assoc (nth 0 #data$) #data$$))
			;else
			(setq #datatmp$ nil)
		);if
		(if #datatmp$
			(setq #ret$$ (append #ret$$ (list (append #datatmp$ (list #id #qps)))))
			;else
			(setq #ret$$ (append #ret$$ (list (append #data$ (list 0 "A" #id #qps))))) ; A(�L�b�`��)�̂�
		);if
	);foreach

	#ret$$
);GetKanaguCnt$$

;<HOM>*************************************************************************
; <�֐���>    : SaveKanaguCnt
; <�����T�v>  : �t���[���L�b�`���̏ꍇ"HOSOKU.cfg"�ɋ���Z�b�g�̌������o��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2017/06/19 KY
; <���l>      :
;*************************************************************************>MOH<
(defun SaveKanaguCnt (
	&kanaguInfo$$ ; ����Z�b�g�̌����(�����ώZ�t���O�t)
	/
	#data$ #data2$ #data$$ #dataAdd$$
	#kanaguInfo$
	)

	(setq #data$$ (ReadHosokuCfg$$ nil nil))
	(setq #dataAdd$$ nil)
	(foreach #kanaguInfo$ &kanaguInfo$$
		(if (nth 6 #kanaguInfo$) ; ����Z�b�g�̌��̔��f�K�v(�����ώZ��)
			(progn
				(setq #data$ (assoc (nth 0 #kanaguInfo$) #data$$))
				(if #data$
					(progn ; ���ύX(����0�łȂ����̂̎����ώZ�͂��肦�Ȃ����O�̂���)
						(setq #data2$ (list-put-nth (nth 2 #kanaguInfo$) #data$ 2)) ; �Q�Ԗڂ̗v�f(��)�̐ݒ�
						(setq #data$$ (subst #data2$ #data$ #data$$)) ; ���X�g�ւ̏����߂�
					);progn
					;else
					(progn ; �ǉ�
						(setq #data$ #kanaguInfo$)
						(setq #data$ (list-remove-nth 5 #data$)) ; �T�Ԗڂ̗v�f(1�Z�b�g�������)�̏���
						(setq #data$ (list-remove-nth 4 #data$)) ; �S�Ԗڂ̗v�f(ID)�̏���
						(setq #dataAdd$$ (append #dataAdd$$ (list #data$)))
					);progn
				);if
			);progn
		);if
	);foreach

	(WriteHosokuCfg (append #data$$ #dataAdd$$))

	(princ)
);SaveKanaguCnt

;<HOM>*************************************************************************
; <�֐���>    : GetFrameType
; <�����T�v>  : (�t���[���L�b�`���p)�t���[���̎�ނ̎擾
; <�߂�l>    : (INT)�c�t���[��=1/���t���[��=2/��=0/�t���[���L�b�`���łȂ�=-1
; <�쐬>      : 2017/06/16 KY
; <���l>      :
;*************************************************************************>MOH<
(defun GetFrameType (
	&xd$ ; �g���f�[�^(G_SYM)
	&xdl$ ; �g���f�[�^(G_LSYM)
	/
	#hinban
	#dimW
	#dimH2
	#ft
	#ret
	#errmsg_ini
	#hinbanPtn_TF #hinbanPtn_YF
	)

	(setq #ret -1)
	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn
			(setq #errmsg_ini (strcat CG_SYSPATH "ERRMSG.INI"))
			(setq #hinbanPtn_TF (CFgetini "HINBAN_PTN" "TATEFRM" #errmsg_ini))
			(setq #hinbanPtn_YF (CFgetini "HINBAN_PTN" "YOKOFRM" #errmsg_ini))
			; �i�ԂŔ��f
			(setq #hinban (nth 5 &xdl$)) ; G_LSYM�̕i�Ԗ���
			(cond
				((= 1 (acet-str-find #hinbanPtn_TF #hinban nil T))
					(setq #ret 1)
				)
				((= 1 (acet-str-find #hinbanPtn_YF #hinban nil T))
					(setq #ret 2)
				)
				(T
					(setq #ret 0)
				)
			);cond

			(if (= #ret 0)
				(progn
					; �T�C�Y�Ŕ��f
					(setq #dimW (nth 3 &xd$)) ; G_SYM�̼���ي�lW (����)
					(setq #dimH2 (nth 13 &xdl$)) ; G_LSYM�̐��@H (����)
					(setq #ft 0)
					(if (< #dimW 50.0) ; �c�t���[��
						(setq #ft (logior #ft 1))
					);if
					(if (< #dimH2 50) ; ���t���[��
						(setq #ft (logior #ft 2))
					);if
					(cond
						((= #ft 1)
						 (setq #ret 1)
						)
						((= #ft 2)
						 (setq #ret 2)
						)
						(T
						 (setq #ret 0)
						)
					);cond
				);progn
			);if
		);progn
	);if

	#ret
);GetFrameType

;<HOM>*************************************************************************
; <�֐���>    : IsCounter
; <�����T�v>  : (�t���[���L�b�`���p)�J�E���^�[���ǂ���
; <�߂�l>    : (BOOL)�J�E���^�[=T/�J�E���^�[�łȂ�=nil
; <�쐬>      : 2017/06/21 KY
; <���l>      :
;*************************************************************************>MOH<
(defun IsCounter (
	&xd$ ; �g���f�[�^(G_SYM)
	&xdl$ ; �g���f�[�^(G_LSYM)
	/
	#hinban
	#dimH
	#ret
	#errmsg_ini
	#hinbanPtn_CT
#XD$ ;2017/07/13 YM ADD
	)

	(setq #ret nil)
	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn
			(setq #errmsg_ini (strcat CG_SYSPATH "ERRMSG.INI"))
			(setq #hinbanPtn_CT (CFgetini "HINBAN_PTN" "COUNTER" #errmsg_ini))
			; �i�ԂŔ��f
			(setq #hinban (nth 5 &xdl$)) ; G_LSYM�̕i�Ԗ���
			(if (= 1 (acet-str-find #hinbanPtn_CT #hinban nil T))
				(setq #ret T)
			);if

			(if (= #ret nil)
				(progn
					; �T�C�Y�Ŕ��f
					(setq #dimH (nth 5 &xd$)) ; G_SYM�̼���ي�lH (����)
					(if (< #dimH 50.0)
						(setq #ret T)
					);if
				);progn
			);if
		);progn
	);if

	#ret
);IsCounter

;<HOM>*************************************************************************
; <�֐���>    : list-put-nth
; <�����T�v>  : ���X�g�̗v�f�̓���ւ�(�C���f�b�N�X�w��)
; <�߂�l>    : (LIST)����ւ���̃��X�g
; <�쐬>      : 2017/06/20 KY
; <���l>      :
;*************************************************************************>MOH<
(defun list-put-nth (
	&newVal ; �V�����v�f
	&data$ ; ���X�g
	&idx ; �C���f�b�N�X
	/
	#len
	#i
	#ret$
#RET #VAL ;2017/07/13 YM ADD
	)

	(setq #ret$ nil)
	(setq #len (length &data$))
	(setq #i 0)
	(while (< #i #len)
		(if (/= #i &idx)
			(setq #val (nth #i &data$))
			;else
			(setq #val &newVal)
		);if
		(setq #ret$ (append #ret$ (list #val)))
		(setq #i (1+ #i))
	);while
	#ret$
	;(acet-list-put-nth &newVal &data$ &idx)
);list-put-nth

;<HOM>*************************************************************************
; <�֐���>    : list-remove-nth
; <�����T�v>  : ���X�g�̗v�f�̍폜(�C���f�b�N�X�w��)
; <�߂�l>    : (LIST)�폜��̃��X�g
; <�쐬>      : 2017/06/20 KY
; <���l>      :
;*************************************************************************>MOH<
(defun list-remove-nth (
	&idx ; �C���f�b�N�X
	&data$ ; ���X�g
	/
	#len
	#i
	#ret$
#RET ;2017/07/13 YM ADD
	)

	(setq #ret$ nil)
	(setq #len (length &data$))
	(setq #i 0)
	(while (< #i #len)
		(if (/= #i &idx)
			(setq #ret$ (append #ret$ (list (nth #i &data$))))
		);if
		(setq #i (1+ #i))
	);while
	#ret$
	;(acet-list-remove-nth &idx &data$)
);list-remove-nth


;2018/07/12 �ؐ�������Ή�
(defun FixWCounterHinban (
  &hinban
  /
  #dcl_id #wcclr$$ #wcclr$ #hinban
  )

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##GetDlgItem (
    /
    #wcclrStr
    )

    (setq #wcclrStr (get_tile "wcclr"))
    (if (= #wcclrStr "")
      (progn
        (CFAlertMsg "������F��I�����ĉ������B")
        (princ)
      );progn
      ;else
      (progn
        (done_dialog)
        (nth (atoi #wcclrStr) #wcclr$$)
      );progn
    );if
  );##GetDlgItem
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##SetWcClrList (
    /
    )

    (setq #wcclr$$ (DBSqlAutoQuery CG_DBSESSION
        "SELECT ��ʑI��������, [6����], [12����] FROM �ؐ��J�E���^�F ORDER BY ID"))
    (start_list "wcclr" 3)
    (foreach #wcclr$ #wcclr$$
      (add_list (nth 0 #wcclr$))
    );foreach
    (end_list)
    (princ)
  );##SetWcClrList
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "WCounterColorDlg" #dcl_id)) (exit))
  (##SetWcClrList)

  (setq #wcclr$ nil)
  (action_tile "accept" "(setq #wcclr$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #wcclr$ nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)

  (setq #hinban &hinban)
  (setq #hinban (vl-string-subst (nth 1 #wcclr$) "N$" #hinban))
  (setq #hinban (vl-string-subst (nth 2 #wcclr$) "@@" #hinban))
	(princ (strcat "* �ؐ�������̕i��(�ϊ���)=" #hinban "\n"))

  #hinban
);FixWCounterHinban

;<HOM>*************************************************************************
; <�֐���>    : KcChkWCounterItem$
; <�����T�v>  : �ؐ�������ݒu
; <�߂�l>    : �i�Ԃ�ϊ�������� SELPARTS.CFG �̓��e���X�g
; <�쐬>      : 2018/07/12
; <���l>      : �Ώۂ̕i�ԂłȂ���� $FIG$ �����̂܂ܕԂ�
;*************************************************************************>MOH<
(defun KcChkWCounterItem$ (
  &FIG$       ; SELPARTS.CFG �̓��e���X�g
  /
  #hinban
  )

	(setq #hinban (nth 0 &FIG$))
  (if (CheckSpSetBuzai #hinban "�ؐ��J�E���^�i��")
    (progn
      ;�i�Ԃ̕ϊ�(�����̒u��)
      (cons (FixWCounterHinban #hinban) (cdr &FIG$))
    );progn
    ;else
    &FIG$
  );if
);KcSetWCounterItem

(princ)
