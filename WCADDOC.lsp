;;;�������@KPCAD�A�g�p�@������
;;;�������@KPCAD�A�g�p�@������
;;;�������@KPCAD�A�g�p�@������

;AutoCAD2014���M�����[�Ł@�E�b�h�����p

;|
aaaa
bbb
ccc
����
|;

;;;<HOF>************************************************************************
;;; <�t�@�C����>: ACADDOC.LSP
;;; <�V�X�e����>: KitchenPlan�V�X�e��(�E�b�h�����l����)
;;; <�ŏI�X�V��>: 2011/10/04 YM 
;;; <���l>      : �Ȃ�
;;;************************************************************************>FOH<

; ��۰��ٕϐ�(���d�v) 02/07/30 YM ADD
; �ʏ�            :CG_AUTOMODE=0
; �����ݸ޼��     :CG_AUTOMODE=1
; WEB��CAD���ް   :CG_AUTOMODE=2 -->�N������"Input.cfg"��Ǎ���-->���݌����`���ς�܂�
;                                \Layout̫��ޓ��ōs��
; WEB��LOCAL KPCAD:CG_AUTOMODE=3 -->�N������"Input.cfg"��Ǎ���-->���݌����`���ς�܂�
;                                �ʏ��\BUKKEN̫��ޓ��ōs��
;;;<HOM>************************************************************************
;;; <�֐���>  : S::STARTUP
;;; <�����T�v>: KPCAD�V�X�e���N������
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun S::STARTUP (
  /
  #seri$      ; SERIES���
#NO #QRY$ #SDUM #SFNAME #date_time #rstr$ #FP #MSG #RSTR
#ALERTMSG #CDATE #CDATE_NOW #DUM_TENJO #SA #UNIT ;2010/01/08 YM ADD
#FIRST$ #PLANINFO$ ; 2011/01/04 YM ADD
  )
  ;CG_ACAD_INIT�@�́Aacad.lsp�ŏ��������Ă���
(princ "\n����������������������")
(princ "\n������S::STARTUP������")
(princ "\n����������������������")
(princ "\n")

	(princ "\n�������@_FILETABCLOSE�@������")	
	(princ "\n")

	(command "_FILETABCLOSE")

(setq #DWGPREFIX (getvar "DWGPREFIX"))
(princ "\n������DWGPREFIX= ")(princ #DWGPREFIX)
(princ "\n")

(setq #DWGNAME (getvar "DWGNAME"))
(princ "\n������DWGNAME= ")(princ #DWGNAME)
(princ "\n")

(princ "\n�����N�����V�X�e���ϐ��̐ݒ�@�J�n������")
(princ "\n")

	;2012/08/24 YM ADD-S �o�͊֌W�ƭ������s�����񐔂��L�^����
	;�������̏��������񐔂��L�^����
	(if (= CG_SYUTURYOKU_MENU nil)
		(setq CG_SYUTURYOKU_MENU 0)
	);_if
	;2012/08/24 YM ADD-E

  (setvar "CMDECHO"      0) ;�v�����v�g�ƃ��[�U���͂��G�R�[�o�b�N��\��
  (setvar "SHORTCUTMENU" 2) ;�ҏW���[�h�̃V���[�g�J�b�g ���j���[���g�p  01/06/08 HN ADD
  (setvar "PICKFIRST"    0) ;�R�}���h�̔��s��ɃI�u�W�F�N�g��I��       01/08/24 HN ADD
  (setvar "GRIPS"        0) ;�O���b�v���\��                           01/09/09 HN ADD
  (setvar "DELOBJ"       1) ;extrude�Ō��̵�޼ު�Ă��폜����            02/06/17 YM ADD
  (setvar "PLINETYPE"    2) ;0:�ȑO�̌`�������ײ݂��쐬����WT���͂�Ȃ� 03/02/13 YM ADD
  (setvar "MBUTTONPAN"   1) ;�}�E�X�z�C�[����ʈړ��\ 03/03/28 YM ADD
	(setvar "3DOSMODE"     1) ;���ׂĂ� 3D �I�u�W�F�N�g �X�i�b�v�𖳌��ɂ���
  (setvar "DYNMODE"      0) ;�޲�Я����͂��g�p���Ȃ�
  (setvar "XREFNOTIFY"   0) ;�O���Q�Ƃ̒ʒm�𖳌��ɂ��܂�
  (setvar "SDI"          1) ;�����t�@�C���Ђ炩�Ȃ�
  (setvar "MENUBAR"      1) ;�]���ƭ���\�� 2010/01/06 YM ADD
  (setvar "UCSDETECT"    0) ;�_�C�i�~�b�N UCS ���A�N�e�B�u�ɂ��Ȃ� 2011/10/11 YM ADD
  (setvar "CLAYER"     "0") ;���݂̉�w
;-- 2012/01/18 A.Satoh Add - S
  (setvar "SOLIDHIST"    0) ;�\���b�h�I�u�W�F�N�g�̗����v���p�e�B�ݒ�F�Ȃ�
														; �V��R�G���h���H�̓W�J�}�쐬�p
;-- 2012/01/18 A.Satoh Add - E

	;2012/03/27 YM ADD-S
  (setvar "SELECTIONCYCLING" 0) ;�I���̏z�������I��OFF�ɂ���
	;2012/03/27 YM ADD-E

	;��SECURELOAD=0(�M������ꏊ�Ƀp�X��ʂ��Ȃ��Ă����[�h���邩�����Ă��Ȃ�)���`���Ă��A
	;�@����N�����Ɍ����Ȃ��̂Ŗ��ʂ�����`���Ă�����
	;2015/03/17 YM ADD-S
	(setvar "SECURELOAD" 0)

(princ "\n�����N�����V�X�e���ϐ��̐ݒ�@�I��������")
(princ "\n")

  (if (= CG_ACAD_INIT nil) ; ����}�ʃI�[�v���� -------------------------------------------------------
    (progn
			(princ "\n����������}�ʵ���ݎ��̂ݒʉ߁������@CG_ACAD_INIT=nil")
			(princ "\n")

      ;// ���ѕϐ�������
      (setvar "LISPINIT"  0)                 ;�}�ʃI�[�v����Lisp�ϐ������������Ȃ�

			;2015/03/25 YM ADD-S ���W�X�g������SYSPATH���擾������𓾂Ȃ�   \KPCAD_WOODONE\SYSTEM
			(setq CG_SYSPATH (vl-registry-read "HKEY_CURRENT_USER\\Software\\Apptec\\WOCAD\\AppInfo\\" "KPSysDir"))
			;2015/03/25 YM ADD �p�X��ǉ�

			;KPCAD�A�g.ini  AutoCADWorkDir=C:\Program Files\Apptec\WOCAD 2014\Support\
			;2019/09/26 YM MOD-S "DWGPREFIX"����߂�
;;;			(setq CG_SUPPORT_PATH (getvar "DWGPREFIX"));C:\Program Files\Apptec\WOCAD 2014\Support
				(setq CG_SUPPORT_PATH (getRenkei_ini))
;(setq CG_INPUTINFO$ (ReadIniFile (strcat CG_SYSPATH "INPUT.CFG")))



			(princ "\n���������W�X�g������SYSPATH���擾�������@CG_SYSPATH=")(princ CG_SYSPATH)
			(princ "\n")

			(princ "\n������ <2019/09/26 �N����PG�ŘA�gini���狁�߂�>CG_SUPPORT_PATH��")(princ CG_SUPPORT_PATH)
			(princ "\n")

			(setq #strlen (strlen CG_SUPPORT_PATH))
			(setq CG_WOCAD_PATH (substr CG_SUPPORT_PATH 1 (- #strlen 8))) ;C:\Program Files\Apptec\WOCAD 2014\

			(princ "\n������CG_WOCAD_PATH��")(princ CG_WOCAD_PATH)
			(princ "\n")

			(setq CG_KPCAD_SYSTEM_PATH (strcat CG_WOCAD_PATH "KPCAD_SYSTEM\\")) ;C:\Program Files\Apptec\WOCAD 2014\KPCAD_SYSTEM

			(princ "\n������CG_KPCAD_SYSTEM_PATH��")(princ CG_KPCAD_SYSTEM_PATH)
			(princ "\n")

;;;			(setq CG_SYSPATH (getvar "DWGPREFIX")) ;�{���т̼����߽
			;2015/03/25 YM ADD-E ���W�X�g������SYSPATH���擾������𓾂Ȃ�

			;�����ݒ�̂��߂̿��̧�ق�۰�ނ���
			;***************************************************
      (setq CG_PROGRAM (strcase (getvar "PROGRAM")))
      
      ;ACAD�̃o�[�W�������擾
      (setq CG_ACADVER (substr (GETVAR "ACADVER") 1 2));2009==>17

			(princ "\n������CAD�v���O���������擾�������@CG_PROGRAM=")(princ CG_PROGRAM)
			(princ "\n")

			(princ "\n������CAD�o�[�W�������擾�������@CG_ACADVER=")(princ CG_ACADVER)
			(princ "\n")
      
			;���ϲ���ƭ�(CUI̧��)��۰��
			(princ "\n������KPCAD.cuix��۰�� Suppot�����ɂ���������")
			(princ "\n")

			(command "Menu" (strcat CG_SYSPATH "KPCAD")) ;2015/02/18 YM KPCAD.cuix��۰��

			(princ "\n������CommandLine�����\��������")
			(princ "\n")
			(command "CommandLine")


			(princ "\n����INIT,GLOBAL��۰�ށ�����")
			(princ "\n")

			(if (= CG_PROGRAM "ACAD")
				(progn
					(load (strcat CG_SYSPATH "INIT"  )) ;��۸���۰��
					(load (strcat CG_SYSPATH "GLOBAL")) ;��۰��پ��
				)
				;else
				(progn
					(load (strcat CG_KPCAD_SYSTEM_PATH "INIT"  )) ;��۸���۰��
					(load (strcat CG_KPCAD_SYSTEM_PATH "GLOBAL")) ;��۰��پ��
				)
			);_if
			;***************************************************

      ; �����ŕ��� WEB��CAD���ް�ł̎���ڲ��Ď��s
      ; Layout.ini �̗L���Ŕ��f

;;;2011/10/04YM@DEL      (setq CG_WEB_LAYOUT (WEB_Check_InputCFG)) ; WEB�Ŏ���ڲ���==>T,����ȊOnil

          ; (�ʏ�KPCAD or WEB��LOCAL CAD�[��)
          (princ "\n********* �ʏ� or KPCAD�[�� *************************")
          (princ "\n�������@KPCAD�A�g�N���@������")
          (setq CG_AUTOMODE 0)
          (princ "\nCG_AUTOMODE = ")(princ CG_AUTOMODE)

          (princ "\n�������@INPUT.CFG�@��۰�ށ@������")
          ;������ INPUT.CFG ����������������������������������������������������������������������������
          ;// ���݂̌������(INPUT.CFG)��ǂݍ���
          (setq CG_INPUTINFO$ (ReadIniFile (strcat CG_SYSPATH "INPUT.CFG")))

          (setq CG_BukkenName (cadr (assoc "ART_NAME" CG_INPUTINFO$)))           ;���������́�
          (princ "\n�������@�������́@������")
          (princ "\n�������� = ")(princ CG_BukkenName)

          (setq CG_BukkenNo "")                                                  ;�����ԍ�

          (setq CG_EigyosyoName (cadr (assoc "BASE_BRANCH_NAME" CG_INPUTINFO$))) ;���c�Ə�����
          (princ "\n�������@�c�Ə����@������")
          (princ "\n�c�Ə��� = ")(princ CG_EigyosyoName)

          (setq CG_PlanName "")                                                  ;�v��������

          (setq CG_PlanNo (cadr (assoc "PLANNING_NO" CG_INPUTINFO$)))            ;���v�����ԍ���
          (princ "\n�������@�v�����ԍ��@������")
          (princ "\n�v�����ԍ� = ")(princ CG_PlanNo)

          (setq CG_VERSION_NO (cadr (assoc "VERSION_NO" CG_INPUTINFO$)))         ;���ǔԁ�
          (princ "\n�������@�ǔԁ@������")
          (princ "\n�ǔ� = ")(princ CG_VERSION_NO)


          (setq CG_BASE_CHARGE_NAME (cadr (assoc "BASE_CHARGE_NAME" CG_INPUTINFO$)))         ;���c�ƒS����
          (princ "\n�������@�c�ƒS���@������")
          (princ "\n�c�ƒS�� = ")(princ CG_BASE_CHARGE_NAME)

          (setq CG_ADDITION_CHARGE_NAME (cadr (assoc "ADDITION_CHARGE_NAME" CG_INPUTINFO$))) ;������(�ώZ�S��)��
          (princ "\n�������@����(�ώZ�S��)�@������")
          (princ "\n����(�ώZ�S��) = ")(princ CG_ADDITION_CHARGE_NAME)
          ;������ INPUT.CFG ����������������������������������������������������������������������������


          ;// �����ݒ���(KPCAD.INI)��ǂݍ���
          (princ "\n�������@KPCAD.INI�@��۰�ށ@������")

          (setq CG_INIINFO$    (ReadIniFile (strcat CG_SYSPATH "KPCAD.INI"))) ;00/03/05 HN MOD SYSCAD��KPCAD

          ;// ���݂̌������(KENMEI.CFG)��ǂݍ���
;;;          (setq CG_KENMEIINFO$ (ReadIniFile (strcat CG_SYSPATH "KENMEI.CFG"))) ; �����ݸ޼�Ď�(C:KP_AutoEXEC)�ɍēx�ǂݍ���

          ;//�t�H���_���̐ݒ�
          (setq CG_SKDATAPATH      (cadr (assoc "SKDATAPATH"     CG_INIINFO$))) ;�L�b�`�� �f�[�^
          (setq CG_MSTDWGPATH      (strcat CG_SKDATAPATH "MASTER\\"  ))         ;���ރ}�X�^�[�}��
          (setq CG_DRMSTDWGPATH    (strcat CG_SKDATAPATH "DRMASTER\\"))         ;���ʃ}�X�^�[�}��
          (setq CG_LOGPATH         (cadr (assoc "LOGPATH"        CG_INIINFO$))) ;���O�o�̓t�@�C��
          (setq CG_KENMEIDATA_PATH (cadr (assoc "KENMEIDATAPATH" CG_INIINFO$))) ;�����f�[�^
          (setq CG_KENMEI_PATH CG_KENMEIDATA_PATH) ; \KPCAD_WOODONE\WORK

          (setq CG_CDBNAME         (cadr (assoc "Common_DSName"  CG_INIINFO$))) ;���ʂc�a���� KS ADD

          (setq CG_DEBUG (cadr (assoc "DEBUG" CG_INIINFO$))) ;�f�o�b�O���[�h
          (if (= "1" CG_DEBUG) ; DL�Q�Ǝ��ɂ����ޯ�Ӱ�ނ�ǉ�
            (setq CG_DEBUG   1 CG_STOP   1 *error* nil)
            ;else
            (setq CG_DEBUG nil CG_STOP nil)
          );_if

          ;�������̐ݒ��ǉ�
          (setq CG_PROGMODE "PLAN")
          (setq CG_BrandCode "N")        ;�u�����h�L��

          ;// KPCAD������ ������������ASILISP16�����[�h���遚����
          (princ "\n�������@��۰��ق̐ݒ�EARX,LISP��۰��(InitKPCAD)�@������")
          (InitKPCAD) ; ۸�,�װ۸�̧�ٖ������Œ�`

          (princ "\n�������@input.cfg�@��۰��(KPCADSetFamilyCode)�@������")
          ;��۰��ٕϐ��̾��
          (KPCADSetFamilyCode)

          (princ "\n�������@running.flg�@�̏������݁@������")
          (setq #sFname (strcat CG_KENMEI_PATH "running.flg"))
          (setq #fp  (open #sFname "w"))
          (princ "running.flg" #fp);��������
          (close #fp)
          

          (princ "\n�������@PLANINFO.CFG�@�̏o�́@������")
          (princ "\n���@CG_SeriesDB���@")   (princ CG_SeriesDB   )
          (princ "\n���@CG_SeriesCode���@") (princ CG_SeriesCode )
          (princ "\n���@CG_DRSeriCode���@") (princ CG_DRSeriCode )
          (princ "\n���@CG_DRColCode���@")  (princ CG_DRColCode  )
          (princ "\n���@CG_HIKITE���@")     (princ CG_HIKITE     )
          (princ "\n���@CG_CeilHeight���@") (princ CG_CeilHeight )
          (princ "\n���@CG_UpCabHeight���@")(princ CG_UpCabHeight)

          ; PlanInfo.cfg�o��
          (setq #PLANINFO$
            (list
              (list "SeriesDB"        CG_SeriesDB   );�V���[�YDB��
              (list "SeriesCode"      CG_SeriesCode );�V���[�Y�L��
              (list "DoorSeriesCode"  CG_DRSeriCode );���V���[�Y�L��
              (list "DoorColorCode"   CG_DRColCode  );���J���[�L��
              (list "DoorHandle"      CG_HIKITE     );����L��
              (list "ElecType"        CG_ElecType   );�d�C��
              (list "GasType"         CG_GasType    );�K�X��
              (list "WorkTopHeight"   CG_WTHeight   );���[�N�g�b�v����
              (list "Width"           (itoa (fix CG_RoomW))      );�Ԍ�
              (list "Depth"           (itoa (fix CG_RoomD))      );���s
              (list "CeilingHeight"   (itoa (fix CG_CeilHeight)) );�V�䍂��
              (list "SetHeight"       (itoa (fix CG_UpCabHeight)));��t����
            )
          )

          (setq #sFname (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
          (setq #fp  (open #sFname "w"))
          (if (/= nil #fp)
            (progn
							(princ "\n[KPCAD]\n" #fp);2011/10/14 YM ADD ����ݒǉ�
              (foreach #elm #PLANINFO$
                (if (= ";" (substr (car #elm) 1 1))
                  (princ (car #elm) #fp)
                  (princ (strcat (car #elm) "=" (cadr #elm)) #fp)
                );_if
                (princ "\n" #fp)
              )
              (close #fp)
            )
            (progn
              (CFAlertMsg "PLANINFO.CFG�ւ̏������݂Ɏ��s���܂����B")
              (*error*)
            )
          );_if

;-- 2011/10/21 A.Satoh Add - S
					; �}�ʂ̕������̏�������
;;;					(KP_BukkenInfoRewrite) ;�o�͊֌W�ƭ��Ɉړ�
;-- 2011/10/21 A.Satoh Add - E
; --- �������狤�� ---

(princ (strcat "\n�������@--- �������狤�� ---�@������"))

;;;(princ (strcat "\n�������@CG_BukkenNo = " CG_BukkenNo))
;;;(princ (strcat "\n�������@CG_BukkenName = " CG_BukkenName))
;;;(princ (strcat "\n�������@CG_PlanNo = " CG_PlanNo))
;;;(princ (strcat "\n�������@CG_PlanName = " CG_PlanName))
;;;(princ (strcat "\n�������@CG_PROGMODE = " CG_PROGMODE))
;;;(princ (strcat "\n�������@CG_KENMEI_PATH = " CG_KENMEI_PATH))
;;;(princ (strcat "\n�������@CG_SeriesDB = " CG_SeriesDB))
;;;(princ (strcat "\n�������@CG_SeriesCode = " CG_SeriesCode))
;;;(princ (strcat "\n�������@CG_DRSeriCode = " CG_DRSeriCode))
;;;(princ (strcat "\n�������@CG_DRColCode = " CG_DRColCode))
;;;(princ (strcat "\n�������@CG_HIKITE = " CG_HIKITE))
      
;;;(princ "\n********* --- �������狤�� --- *************************")
;;;      (ChgSystemCADMenu CG_PROGMODE) WEB�ł͕K�v�Ȃ�
;;;(princ "\n���������狤�ʁ�")


      (if CG_BukkenNo
        (progn
          (if (tblsearch "LAYER" "Z_00_00_00_01")
            (command "_layer" "T" "Z_00_00_00_01" "ON" "Z_00_00_00_01" "")
            (MakeLayer "Z_00_00_00_01" 7 "CONTINUOUS")
          )
          ;2011/04/22 YM MOD
          (setvar "MODEMACRO"
            (strcat "�ذ��: " CG_SeriesDB " / ���ڰ��: " CG_DRSeriCode " / ��װ: " CG_DRColCode " / ����: " CG_HIKITE)
          )
          (MakeLayer "N_Symbol" 4 "CONTINUOUS")
          (MakeLayer "N_BreakD" 6 "CONTINUOUS")
          (MakeLayer "N_BreakW" 6 "CONTINUOUS")
          (MakeLayer "N_BreakH" 6 "CONTINUOUS")
          (command "_layer" "of" "N_B*" "")
        )
      );_if


      (setq CG_ACAD_INIT T)   ;AutoCAD�����ݒ芮��(����̐}�ʃI�[�v���ŏ�L�����ݒ���s��Ȃ��j


;2011/02/01 YM ADD �yPG����z�ǉ�
(if (= BU_CODE_0001 nil) (PKC_PG_BUNKI))

      (setq CG_SetXRecord$
        (list
          CG_DBNAME       ; 0.DB����
          CG_SeriesCode   ; 1.SERIES�L��
          CG_BrandCode    ; 2.�u�����h�L��
          CG_DRSeriCode   ; 3.��SERIES�L��
          CG_DRColCode    ; 4.��COLOR�L��
          CG_HIKITE       ; 5.�q�L�e�L��
          CG_UpCabHeight  ; 6.��t����
          CG_CeilHeight   ; 7.�V�䍂��
          CG_RoomW        ; 8.�����Ԍ�
          CG_RoomD        ; 9.�������s
          CG_GasType      ;10.�K�X��
          CG_ElecType     ;11.�d�C��
          CG_KikiColor    ;12.�@��F
          CG_KekomiCode   ;13.�P�R�~����
        )
      )

      (cond
        ((= CG_AUTOMODE 0)
          (setq CG_OpenMode 0)  ; �ʏ�
        )
        ((= CG_AUTOMODE 1)
          (setq CG_OpenMode -1) ; �����ݸ޼��
        )
        ((= CG_AUTOMODE 2)
          (setq CG_OpenMode -2) ; WEB��CAD���ް
        )
        ((= CG_AUTOMODE 3)
          (setq CG_OpenMode -3) ; WEB��LOCAL CAD�[��
        )
      );_cond

(princ (strcat "\n�������@CG_AUTOMODE = " ))(princ CG_AUTOMODE)
(princ (strcat "\n�������@CG_OpenMode = " ))(princ CG_OpenMode)

      (command "_point" "0,0")

			(setq #DWGNAME (getvar "DWGNAME"))
			(princ "\n������DWGNAME= ")(princ #DWGNAME)

			(setq #DWGPREFIX (getvar "DWGPREFIX"))
			(princ "\n������DWGPREFIX= ")(princ #DWGPREFIX)


;;;(princ "\n������������������������������������������������")
;;;(princ (strcat "\n�������@CG_KENMEI_PATH = " CG_KENMEI_PATH))
;;;(princ (strcat "\n�������@������̧�ق��g�p���� MODEL.DWG ���J���܂�(CfDwgOpenByScript)"))
;;;(princ "\n������������������������������������������������")

      ;// �I�����ꂽ�����̐}�ʂ��J��
;2015/03/17 YM ADD
;;;      (CfDwgOpenByScript (strcat CG_KENMEI_PATH "MODEL.DWG"))

      ;04/12/10 YM �ォ��ړ�
     (ChgSystemCADMenu CG_PROGMODE) ; WEB�ł͕K�v�Ȃ�

    )
  );_if  ; ����}�ʃI�[�v���� -------------------------------------------------------

(princ (strcat "\n�������@����}�ʃI�[�v���������I��!�@������"))

(princ "\n")

  (if (= CG_AUTOMODE 2)
    nil
    ;else
    (princ (strcat "\n����No:[" CG_PlanNo "-" CG_VERSION_NO "]�̐}�ʂ��J���Ă��܂�..."))
  );_if
	(princ "\n")

  ;// �}�ʂ̊g�����R�[�h���O���[�o���ɐݒ�
  (if (= nil CG_DBNAME)
    (progn
      (setq #seri$ (CFGetXRecord "SERI"))
      (if #seri$
        (progn
          (setq CG_DBNAME      (nth  0 #seri$)) ; 1.DB����
          (setq CG_SeriesCode  (nth  1 #seri$)) ; 2.SERIES�L��
          (setq CG_BrandCode               "N") ; 3.�u�����h�L��
          (setq CG_DRSeriCode  (nth  2 #seri$)) ; 2.��SERIES�L����
          (setq CG_DRColCode   (nth  3 #seri$)) ; 3.��COLOR�L����
          (setq CG_HIKITE      (nth  4 #seri$)) ; 4.�q�L�e�L����
          (setq CG_UpCabHeight (nth  5 #seri$)) ; 6.��t����
          (setq CG_CeilHeight  (nth  5 #seri$)) ; 7.�V�䍂��
          (setq CG_RoomW       (nth  6 #seri$)) ; 8.�����Ԍ�
          (setq CG_RoomD       (nth  7 #seri$)) ; 9.�������s
          (setq CG_GasType     (nth  8 #seri$)) ;10.�K�X��
;;;          (setq CG_ElecType    (nth 10 #seri$)) ;11.�d�C��
;;;          (setq CG_KikiColor   (nth 11 #seri$)) ;12.�@��F
;;;          (setq CG_KekomiCode  (nth 12 #seri$)) ;13.�P�R�~����

          ;// SERIES�ʃf�[�^�x�[�X�ւ̐ڑ�
          (if (= CG_DBSESSION nil)
            (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
          );_if
        )
      );_if
    )
  );_if


;;;  (if (= nil CG_KikiColor)
;;;    (setq CG_KikiColor "5")
;;;  )

  (if CG_SCFConf ; 02/03/04 YM �}�ʎQ�Ǝ��Ȃ�
    (progn
      (command "_.ZOOM" "E")
      ;2011/08/12 YM ADD �}�ʎQ��
      ;�߰��}�̏ꍇ�߰��ޭ��ɂ�����
      (subSCFConf)
      (setq CG_SCFConf nil)

			;2011/10/11 YM ADD-S
			(defun c:p0( / )(setvar "pickfirst" 0))
			(defun c:p1( / )(setvar "pickfirst" 1))
			(defun c:g0( / )(setvar "GRIPS"     0))
			(defun c:g1( / )(setvar "GRIPS"     1))
			;2011/10/11 YM ADD-E
    )
    (progn ; ����ȊO 02/03/18 YM ADD-S

			;2011/10/11 YM ADD-S
			(defun c:p0( / )(princ "\n���̺���ނ͐}�ʎQ�Ƃł����g���܂���")(princ))
			(defun c:p1( / )(princ "\n���̺���ނ͐}�ʎQ�Ƃł����g���܂���")(princ))
			(defun c:g0( / )(princ "\n���̺���ނ͐}�ʎQ�Ƃł����g���܂���")(princ))
			(defun c:g1( / )(princ "\n���̺���ނ͐}�ʎQ�Ƃł����g���܂���")(princ))
			;2011/10/11 YM ADD-E

      (if (/= CG_OpenMode 5)  ; 02/04/10 YM ADD
        (setvar "TILEMODE" 1) ; ������ނɂ���
      );_if                   ; 02/04/10 YM ADD
    ) ; ����ȊO 02/03/18 YM ADD-E
  );_if


  ;00/09/06 SN ADD XRECORD�pList�ɒl��ݒ肷��B
  (setq CG_SetXRecord$
    (list
      CG_DBNAME       ; 0.DB����
      CG_SeriesCode   ; 1.SERIES�L��
      CG_BrandCode    ; 3.�u�����h�L��
      CG_DRSeriCode   ; 2.��SERIES�L��
      CG_DRColCode    ; 3.��COLOR�L��
      CG_HIKITE       ; 4.�q�L�e�L��
      CG_UpCabHeight  ; 6.��t����
      CG_CeilHeight   ; 5.�V�䍂��
      CG_RoomW        ; 6.�����Ԍ�
      CG_RoomD        ; 7.�������s
      CG_GasType      ; 8.�K�X��
;;;      CG_ElecType     ;11.�d�C��
;;;      CG_KikiColor    ;12.�@��F
;;;      CG_KekomiCode   ;13.�P�R�~����
    )
  )
  ;2011/04/22 YM MOD
  (setvar "MODEMACRO"
    (strcat "�ذ��: " CG_SeriesDB " / ���ڰ��: " CG_DRSeriCode " / ��װ: " CG_DRColCode " / ����: " CG_HIKITE)
  )

  (setvar "EXPERT" 4)               ;�m�F�v�����v�gOFF
  (command "_UCSICON" "A" "OF")     ;UCS�A�C�R���̔�\��

  (cond
    ; 02/08/05 YM ADD-S
    ((= CG_OpenMode -3) ; WEB��LOCAL CAD�[��
      (if (= "MODEL.DWG" (strcase (getvar "DWGNAME")))
        (progn

          ;(setq CG_OpenMode nil)
          (CFSetXRecord "SERI" CG_SetXRecord$)
          ;// �Ԍ��̈�̍X�V
          (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)

          (if (= CG_DBSESSION  nil) (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" "")))
          (if (= CG_CDBSESSION nil) (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" "")))
          (princ (strcat "\n" CG_BukkenNo ":" CG_BukkenName "�ɐݒ肳��܂���"))
          ;2011/04/22 YM MOD
          (setvar "MODEMACRO"
            (strcat "�ذ��: " CG_SeriesDB " / ���ڰ��: " CG_DRSeriCode " / ��װ: " CG_DRColCode " / ����: " CG_HIKITE)
          )
          ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
          (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

          ; ���݌�������W�J�},ڲ���,���ς�܂Ŏ������s(�A�������)
          ; CG_ZumenPRINT , CG_MitumoriPRINT ��1�̂Ƃ��ɍs���B
          (setq CG_OpenMode 0) ; ����(S::STARTUP)��ʂ�Ƃ��̂���
          (C:KPLocalAutoEXEC)
        )
      );_if
    )
    ; 02/08/05 YM ADD-E

    ; 02/07/29 YM ADD-S Web��CAD���ް����ڲ���
    ((= CG_OpenMode -2)

      (if (= "MODEL.DWG" (strcase (getvar "DWGNAME")))
        (progn
          ;(setq CG_OpenMode nil)
          (CFSetXRecord "SERI" CG_SetXRecord$)
          ;// �Ԍ��̈�̍X�V
          (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)

          (if (= CG_DBSESSION  nil) (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" "")))
          (if (= CG_CDBSESSION nil) (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" "")))
          (princ (strcat "\n" CG_BukkenNo ":" CG_BukkenName "�ɐݒ肳��܂���"))
          ;2011/04/22 YM MOD
          (setvar "MODEMACRO"
            (strcat "�ذ��: " CG_SeriesDB " / ���ڰ��: " CG_DRSeriCode " / ��װ: " CG_DRColCode " / ����: " CG_HIKITE)
          )
          ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
          (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

          ; ���݌�������W�J�},ڲ���,���ς�܂Ŏ������s(�A�������)
          ; CG_ZumenPRINT , CG_MitumoriPRINT ��1�̂Ƃ��ɍs���B
          (setq CG_OpenMode 0) ; ����(S::STARTUP)��ʂ�Ƃ��̂���
          (C:Web_AutoEXEC)
        )
      );_if

    )

    ; 01/09/11 YM ADD-S
    ((= CG_OpenMode -1) ; �����ݸ޼��
      (if (= "MODEL.DWG" (strcase (getvar "DWGNAME")))
        (progn
          ;(setq CG_OpenMode nil)
          (CFSetXRecord "SERI" CG_SetXRecord$)
          ;// �Ԍ��̈�̍X�V
          (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)

          (if (= CG_DBSESSION  nil) (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" "")))
          (if (= CG_CDBSESSION nil) (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" "")))
          (princ (strcat "\n" CG_BukkenNo ":" CG_BukkenName "�ɐݒ肳��܂���"))
          ;2011/04/22 YM MOD
          (setvar "MODEMACRO"
            (strcat "�ذ��: " CG_SeriesDB " / ���ڰ��: " CG_DRSeriCode " / ��װ: " CG_DRColCode " / ����: " CG_HIKITE)
          )
          ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
          (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

          ; ���݌�������W�J�},ڲ���,���ς�܂Ŏ������s(�A�������)
          ; CG_ZumenPRINT , CG_MitumoriPRINT ��1�̂Ƃ��ɍs���B
          (setq CG_OpenMode 0) ; ����(S::STARTUP)��ʂ�Ƃ��̂���
          (C:KP_AutoEXEC)
        )
      );_if
    )
    ; 01/09/11 YM ADD-E
    ((= CG_OpenMode 1)      ;�L�b�`���A�_�C�j���O�̃v�������������s����
      (C:PC_LayoutPlan)     ;00/02/03 MOD SC_LayoutPlan �� PC_LayoutPlan
    )
    ((= CG_OpenMode 2)      ;�����}�ʂɖ߂�v�������������}�ʂ�Insert������
      (C:PC_InsertPlan)     ;00/02/03 MOD SC_InsertPlan �� PC_InsertPlan
     )
    ((= CG_OpenMode 3)
      (C:SB_LayoutPlan)     ;�V�X�e���o�X�̃v�������������s����
    )
    ;00/02/20 HN MOD �}�ʃ��C�A�E�g�����ύX
    ((= CG_OpenMode 4)      ;�}�ʃ��C�A�E�g�p
      (setvar "CMDECHO" 0)
      (SCFLayoutDrawBefore)
    )
    ((= CG_OpenMode 5)      ;�e���v���[�g�쐬�p
      (SCFMkTplBefore)
    )
    ;;; 00/09/01 YM ADD ;;;
    ((= CG_OpenMode 6)      ;�L�p�x����ȯĔz�u
      (PKPutWideCab)
    )
    ((= CG_OpenMode 7)      ;�L�p�x����ȯđ}��
      (PKInsertWideCab)
    )
    ;;; 00/09/01 YM ADD ;;;
    ((= CG_OpenMode 8)      ;01/03/05 YM ADD �W�J�}�쐬��

			; 2017/09/14 KY ADD-S
			; �t���[���L�b�`���Ή�
			(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
				(progn
					(setq #ss (ssget "X" '((-3 ("G_DEL")))))
					(if #ss
						(progn
							(command "_.ERASE" #ss "")
							(setq #ss nil)
							(CfAutoSave)
						);progn
					);if
				);progn
			);if
			; 2017/09/14 KY ADD-E

      (if CG_TENKAI_OK
        (progn
          ;;; SET�i�֘A�C�� 01/02/07 YM STRAT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (setq #NO nil)
          (if (KcCheckSetMITUMORI) ; ��ĕi���ς肪�L��(G_WTSET����)
            (if (CFYesNoDialog msg7)
              (progn ; SET���ς�հ�ްYes
                (SKChgView "2,-2,1") ; 01/05/16 YM ADD ���_�쓌
                (C:SetHINCheck) ; ��ĕi���l������Table.cfg�o��
                (command "._zoom" "P") ; ���_�����ɖ߂� 01/05/28 YM
                (setq #NO "1") ; �����ł�Table.cfg�X�V�Ȃ�
              )
              (setq #NO "2") ; SET���ς�հ�ްNo �����ł͑��݂��Ȃ��Ȃ�Table.cfg�X�V
            );_if
            (setq #NO "3")   ; ��ĕi���ς肪����  �����ł�Table.cfg�����X�V
          );_if

          (cond
            ((= #NO "1")
              (princ) ; OLD_TABLE.CFG�o�͂��Ȃ�
            )
            ((= #NO "2")
              (setq #sFname (strcat CG_KENMEI_PATH "TABLE.CFG"))
              (if (= (findfile #sFname) nil)
                (SCFMakeBlockTable);Table.cfg������������Ώ����o���B
              );_if
            )
            ((= #NO "3")
              (if CG_TABLE ; �W�J�}�쐬����ނŏo�͍ς�
                (princ)
                (SCFMakeBlockTable) ; �o�͍ς݂łȂ��Ƃ������X�V
              )
            )
            (T
              (SCFMakeBlockTable) ; �����X�V
            )
          );_cond
          (setq CG_TABLE nil)
          ;;; SET�i�֘A�C�� 01/02/07 YM END   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        )
      );_if
      (setq CG_TENKAI_OK nil CG_OpenMode 0) ; 01/03/08 YM ADD
    )
    ((= CG_OpenMode 0)  ;00/02/20 HN MOD 4��0 �����N���p
      (if (= "MODEL.DWG" (strcase (getvar "DWGNAME")))
        (progn
          ;(setq CG_OpenMode nil)
          (CFSetXRecord "SERI" CG_SetXRecord$)
          ;// �Ԍ��̈�̍X�V
          (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)

          (if (= CG_DBSESSION  nil) (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" "")))
          (if (= CG_CDBSESSION nil) (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" "")))
          (princ (strcat "\n" CG_BukkenNo ":" CG_BukkenName "�ɐݒ肳��܂���"))
          ;2011/04/22 YM MOD
          (setvar "MODEMACRO"
            (strcat "�ذ��: " CG_SeriesDB " / ���ڰ��: " CG_DRSeriCode " / ��װ: " CG_DRColCode " / ����: " CG_HIKITE)
          )

      ;;; (command "._style" "standard" "�l�r ����" "" "" "" "" "") ; �ݸ���ނ�"????"���Ȃ���07/07 YM
          ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
          (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

;;;01/09/03YM@MOD         (C:CabShow) ; ��\�����ނ�\������ 01/05/31 YM ADD
          (CabShow_sub) ; 01/09/03 YM MOD �֐���

          ; 02/06/06 YM ADD
          (C:Del0door) ; �����}�ʏC���@�\("0_door" "0_plane" "0_wall"��w�폜�A"0_door"���݁����ލX�V)

(princ "\nCG_OpenMode = 0 (PKAutoHinbanKakutei)���O")
          ;// ���[�N�g�b�v���i�Ԗ��m��Ȃ玩���m�肷��
          (PKAutoHinbanKakutei) ; 06/26 YM ADD
(princ "\nCG_OpenMode = 0 (PKAutoHinbanKakutei)����")

(princ "\nCG_OpenMode = 0 (PKAutoTokuTenban)���O")
;-- 2011/09/13 A.Satoh Add - S
          ; ���[�N�g�b�v���K�i�i�ł���A������1�łȂ��ꍇ�́A�V���������s��
          (PKAutoTokuTenban)
(princ "\nCG_OpenMode = 0 (PKAutoTokuTenban)����")
;-- 2011/09/13 A.Satoh Add - E

          ;(command "_qsave")
        )
        ;01/09/16 HN S-DEL �֐��Ō�Ɉړ�
        ;@DEL@;01/09/09 HN S-ADD Model.dwg�ȊO�́A�I�u�W�F�N�g�I����ύX
        ;@DEL@(progn
        ;@DEL@  (setvar "PICKFIRST" 1)    ; �R�}���h�̔��s�O�ɃI�u�W�F�N�g��I��
        ;@DEL@  (setvar "GRIPS"     1)    ; �O���b�v��\��            01/09/09 HN ADD
        ;@DEL@)
        ;@DEL@;01/09/09 HN E-ADD Model.dwg�ȊO�́A�I�u�W�F�N�g�I����ύX
        ;01/09/16 HN E-DEL �֐��Ō�Ɉړ�
      );_if
    )

    ((= CG_OpenMode 9) ;�v���[���p�p�[�X(JPEG)���
      (COMM03sub)
    )
    ((= CG_OpenMode 10) ;dxf�o��
      (DXF_OUT)
    )
    ((= CG_OpenMode 99) ;�v���[���p�p�[�X(JPEG)���
      (JPG-OUTPUT_sub)
    )

    ; 03/04/28 YM ADD
    ((= CG_OpenMode 999) ;���ݓo�^LR���]�����p(C:AutoMrr)
      (sub_AutoMrr)
    )

    ; 03/05/08 YM ADD
    ((= CG_OpenMode 888) ;���ݓo�^�\�������p(C:AutoView)
      (sub_AutoView)
    )

    ; 03/05/08 YM ADD
    ((= CG_OpenMode 777) ;���ݓo�^�}����_�ύX�p(C:Automove)
      (sub_Automove)
    )

    ; 03/05/13 YM ADD
    ((= CG_OpenMode 666) ;���ݓo�^���폜�p(C:AutoDoorDel)
      (sub_AutoDoorDel)
    )

    ; 03/05/13 YM ADD
    ((= CG_OpenMode 555) ;MASTER,DRMASTER 2000�`����
      (sub_AutoSAVE2000)
    )

    ; 03/06/24 YM ADD
    ((= CG_OpenMode 444) ;���ݓo�^ ���ލX�V�A���폜�A��ٰ�ߍ폜�p(C:AutoKOUSIN)
      (sub_AutoKOUSIN)
    )
  );_cond

	(princ "\n�������@CG_OpenMode �ɂ��cond���I��")

  ;00/01/27 HN S-ADD �f�o�b�O�p�o�͂�ǉ�
  (setvar "LISPINIT"     0)
  ;@@@(setvar "ACADLSPASDOC" 1)  ;00/05/22 HN DEL OEM�Ή��ō폜
  (setvar "CMDECHO"      0)
  ;@DEBUG@(princ "\n LISPINIT: "    )(princ (getvar "LISPINIT"    ))
  ;@DEBUG@(princ "\n ACADLSPASDOC: ")(princ (getvar "ACADLSPASDOC"))
  ;@DEBUG@(princ "\n CMDECHO: "     )(princ (getvar "CMDECHO"     ))
  ;00/01/27 HN E-ADD �f�o�b�O�p�o�͂�ǉ�

  ;01/09/16 HN S-ADD �I�u�W�F�N�g�I��ύX��UNDO �R�}���h�������
  (if (and (/= "MODEL.DWG" (strcase (getvar "DWGNAME")))
           (/= "M_0.DWG" (strcase (getvar "DWGNAME")))
					 (/= "M_1.DWG" (strcase (getvar "DWGNAME"))) ;2012/01/17 YM ADD
					 (/= "M_2.DWG" (strcase (getvar "DWGNAME"))));2012/01/17 YM ADD
    (progn
      (setvar "PICKFIRST" 1)      ; �R�}���h�̔��s�O�ɃI�u�W�F�N�g��I��
      (setvar "GRIPS"     1)      ; �O���b�v��\��
      (command ".UNDO" "C" "N")   ; UNDO �R�}���h�������
      (command ".UNDO"     "A")   ; UNDO �R�}���h�����ׂăI��
      
      (setvar "FILEDIA" 1)        ; �}�ʎQ�Ƃł͏�Ƀ_�C�A���O�\��
      (if (/= ".dwt" (vl-filename-extension (getvar "DWGNAME")))
        (progn
          ; �}�ʎQ�Ƃł͌��݂̍��x�����15000
          (setvar "ELEVATION" CG_LAYOUT_DIM_Z)
          (princ "\nELEVATION :")(princ (getvar "ELEVATION"))
        )
      );_if

      ;2011/07/25 YM ADD-S
      ;������ݎ�Xrecord"FIRST"��Ă���
      ;Xrecord"FIRST"���Ȃ���΋�̂��\���ɂ���
      (setq #first$ (CFGetXRecord "FIRST"))
;-- 2011/11/15 A.Satoh Mod - S *** �b�菈��
;;;;;      (if #first$
;;;;;        (progn
;;;;;          nil
;;;;;        )
;;;;;        (progn
;;;;;          ;��̔�\��
;;;;;          (command "_.LAYER" "F" "0_KUTAI" "")
;;;;;          (CFSetXRecord "FIRST" (list 1))
;;;;;        )
;;;;;      );_if
			(if (= #first$ nil)
        (progn
          ;��̔�\��
          (command "_.LAYER" "F" "0_KUTAI" "")

					;2013/10/03 YM ADD �����{�H�}�Ȃ�
					(if (wcmatch (strcase (getvar "DWGNAME")) "*_04*.DWG" )
	          (command "_.LAYER" "F" "0_door" "");2013/09/17 YM ADD ���͗l���ŏ���\���ɂ���
					);_if

          (CFSetXRecord "FIRST" (list 2))
        )
				(if (= (nth 0 #first$) 1)
					(progn
	          ;��̔�\��
  	        (command "_.LAYER" "F" "0_KUTAI" "")

						;2013/10/03 YM ADD �����{�H�}�Ȃ�
						(if (wcmatch (strcase (getvar "DWGNAME")) "*_04*.DWG" )
          		(command "_.LAYER" "F" "0_door" "");2013/09/17 YM ADD ���͗l���ŏ���\���ɂ���
						);_if

    	      (CFSetXRecord "FIRST" (list 2))
					)
					nil
				)
			)
;-- 2011/11/15 A.Satoh Mod - E *** �b�菈��
      ;2011/07/25 YM ADD-E
    )
    ;2011/07/15 YM ADD TS�����߰
    (progn

			(princ "\n�������@Model.dwg�̏ꍇ")

;-- 2011/10/05 A.Satoh Add - S
      (if (/= CG_OSMODE_BAK nil)
        (progn
          (setvar "OSMODE" CG_OSMODE_BAK)
          (setq CG_OSMODE_BAK nil)
        )
      )
      (if (/= CG_SNAPMODE_BAK nil)
        (progn
          (setvar "SNAPMODE" CG_SNAPMODE_BAK)
          (setq CG_SNAPMODE_BAK nil)
        )
      )
      (if (/= CG_ORTHOMODE_BAK nil)
        (progn
          (setvar "ORTHOMODE" CG_ORTHOMODE_BAK)
          (setq CG_ORTHOMODE_BAK nil)
        )
      )
      (if (/= CG_GRIDMODE_BAK nil)
        (progn
          (setvar "GRIDMODE" CG_GRIDMODE_BAK)
          (setq CG_GRIDMODE_BAK nil)
        )
      )

			(princ "\n�������@Model.dwg�̏ꍇ ���w�̐��� before")
;-- 2011/10/05 A.Satoh Add - E
      ;���w�̐���
      (cond
        ((= CG_PROGMODE "PLAN")
          ;��֘A�}�`���\���Ƃ���
          (CFHideYashiLayer)
        )
        ((= CG_PROGMODE "PLOT")
          ;��֘A�}�`��\������
          (CFDispYashiLayer)
        )
      )
			(princ "\n�������@Model.dwg�̏ꍇ ���w�̐��� after")

    )

  );_if
  ;01/09/16 HN E-ADD �I�u�W�F�N�g�I��ύX��UNDO �R�}���h�������

;@@@ ���ޯ�ޗp����ײ� 02/07/29 YM ADD @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;; (close #fp)

	(command "_RIBBONCLOSE")
	(princ "\n�������@S::STARTUP�@�I���@������")	
	(princ "\n")

  (princ)
);;;S::STARTUP

;;;<HOM>************************************************************************
;;; <�֐���>    : WEB_Check_InputCFG
;;; <�����T�v>  : "Layout.ini" �̗L���𔻒� CG_SYSPATH=(getvar "DWGPREFIX")��
;;; <�߂�l>    : T(����) or nil(�Ȃ�)
;;; <�쐬>      : 02/07/26 YM
;;; <���l>      : �߂�l=T�Ȃ�CAD���ް��̓���(����ڲ���)���s��
;;;************************************************************************>MOH<
(defun WEB_Check_InputCFG (
  /
  #RET
  )
  (setq #ret nil)
  (setq CG_SYSPATH (getvar "DWGPREFIX")) ;�{�V�X�e���̃V�X�e���p�X
  (if (findfile (strcat CG_SYSPATH "Layout.ini"))
    (progn
      (setq #ret T)
      (princ "\n --- ����ڲ��Ă��s���܂� ---")
    )
  );_if
  #ret
);WEB_Check_InputCFG

;;;<HOM>************************************************************************
;;; <�֐���>    : getRenkei_ini
;;; <�����T�v>  : INI�t�@�C����Read����
;;; <�߂�l>    : �L�[������ƒl�̃��X�g�Q
;;; <���l>      : �Ȃ�
;;;************************************************************************>MOH<
(defun getRenkei_ini (
  /
  #fp
  #rstr
  #itm$
  #res$$
#ret
  )
	; CG_SYSPATH
	; "C:\\KPCAD_WOODONE\\SYSTEM\\"
  ;  C:\KPCAD_WOODONE\execute

	(setq #renkei_path (substr CG_SYSPATH 1 (- (strlen CG_SYSPATH) 7))) ; "C:\\KPCAD_WOODONE\\"
	(setq #renkei_path (strcat #renkei_path "execute\\KPCAD�A�g.ini")); "C:\\KPCAD_WOODONE\\execute\\KPCAD�A�g.ini"

  (setq #fp (open #renkei_path "r"))      ;�t�@�C���I�[�v��(READ)
  (while (setq #rstr (read-line #fp)) ;�t�@�C����ǂݍ���
    (setq #itm$ (strparse #rstr "=")) ;��������f�~���^�ŋ�؂�
    (setq #res$$ (append #res$$ (list #itm$)))
  )
  (close #fp)  ;// �t�@�C���N���[�Y

  ;// ���ʂ�Ԃ�
  (setq #ret (cadr (assoc "AutoCADWorkDir" #res$$)))
)
;;;getRenkei_ini


;;;<HOM>************************************************************************
;;; <�֐���>  : StrParse
;;; <�����T�v>: ��������w���؂蕶���ŕ�������
;;; <�߂�l>  : ������̃��X�g
;;; <���l>    : Ex.(StrParse " 1,,  2,  3," ",") -> ("1" "2" "3")
;;; �����֐���init.lsp�ɂ�����B�N�����ɂ܂����[�h���Ă��Ȃ����ǎg������
;;;************************************************************************>MOH<
(defun StrParse (
  &strng
  &chs
  /
  #len
  #c
  #l
  #s
  #chsl
  #cnt
  )

  ;// S-�����֐��錾
  (defun StrTol ( &s / #lst #c )
    (repeat (setq #c (strlen &s))
      (setq #lst (cons (substr &s #c 1) #lst))
      (setq #c   (1- #c))
    )
    #lst
  )
  ;// E-�����֐��錾

  (setq #chsl (StrTol &chs))
  (setq #len  (strlen &strng) #s "" #cnt (1+ #len))
  (while (> (setq #cnt (1- #cnt)) 0)
    (setq #c (substr &strng #cnt 1))
    (if (member #c #chsl)
      (setq #l (cons #s #l) #s "")
      (setq #s (strcat #c #s))
    )
  )

  (cons #s #l)
)
;;;StrParse



;;;<HOM>************************************************************************
;;; <�֐���>    : ChgSystemCADMenu
;;; <�����T�v>  : ���j���[��؂�ւ���
;;; <�߂�l>    : �Ȃ�
;;; <���l>      : ���݂̏�Ԃ�ۑ����Đ؂�ւ���
;;;************************************************************************>MOH<
(defun ChgSystemCADMenu (
  &mode
  /
  )
    ;///////////////////////////////////////////////////////////////////
    (defun ##TOOLBAR1 ( / )
      (command "toolbar" "KPCAD.TB_ZOOM"           "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT2"   "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT"    "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR"  "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR2" "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR3" "h"); 01/05/10 YM ADD

      (command "toolbar" "KPCAD.TB_SKVIEWPOINT2"   "s"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT"    "s"); 01/05/10 YM ADD
;;;     (command "toolbar" "KPCAD.TB_ZOOM"           "s"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR"  "s"); 01/05/10 YM ADD
      (princ)
    );##TOOLBAR
    ;///////////////////////////////////////////////////////////////////

    (defun ##TOOLBAR2 ( / )
      (command "toolbar" "KPCAD.TB_ZOOM"           "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT2"   "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT"    "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR"  "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR2" "h"); 01/05/10 YM ADD

      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR2" "s"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT2"   "s"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT"    "s"); 01/05/10 YM ADD
;;;     (command "toolbar" "KPCAD.TB_ZOOM"           "s"); 01/05/10 YM ADD
      (princ)
    );##TOOLBAR
    ;///////////////////////////////////////////////////////////////////

  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (cond
    ((= &mode "PLAN")
      (##TOOLBAR1) ; 01/05/10 YM ADD
;;;2011/09/29YM@MOD      (menucmd "P1=+KPCAD.KPCAD0")
;;;2011/09/29YM@MOD      (menucmd "P2=+KPCAD.KPCAD1")
;;;2011/09/29YM@MOD      (menucmd "P3=+KPCAD.HELP")
      ;2011/09/29YM@MOD

			; 11/10/08 YM ADD
      (command "toolbar" "KPCAD.TB_WOCAD_TOOLBAR"  "s")

      (menucmd "P1=+KPCAD.KPCAD0")
      (menucmd "P2=+KPCAD.KPCAD1")
      (menucmd "P3=+KPCAD.KPCAD11");�ҏW�ƭ�
      (menucmd "P4=+KPCAD.HELP")

      ;@DEL@(setvar "GRIPS" 0) ;01/09/09 HN DEL
      ;@DEL@(setvar "PICKFIRST" 0) ;01/08/24 HN ADD �R�}���h�̔��s��ɃI�u�W�F�N�g��I�� ;01/09/09 HN DEL
    )
    ((= &mode "PLOT")
			; 11/10/08 YM ADD
      (command "toolbar" "KPCAD.TB_WOCAD_TOOLBAR"  "h")
      (##TOOLBAR1) ; 01/05/10 YM ADD
      (menucmd "P1=+KPCAD.KPCAD5")
      ;(menucmd "P1=+KPCAD.KPCAD0")
      (menucmd "P2=+KPCAD.KPCAD2")
      (menucmd "P3=+KPCAD.KPCAD3")
      (menucmd "P4=+KPCAD.HELP")
      (menucmd "P5=+KPCAD.HELP")
      ;@DEL@(setvar "GRIPS" 0) ;01/09/09 HN DEL
      ;@DEL@(setvar "PICKFIRST" 0) ;01/08/24 HN ADD �R�}���h�̔��s��ɃI�u�W�F�N�g��I�� ;01/09/09 HN DEL
    )
    (T ; �}�ʎQ�Ǝ�
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR3" "s"); 2011/12/13 YM ADD 2D°��ް

      (##TOOLBAR2) ; 01/05/10 YM ADD
      (menucmd "P1=+KPCAD.KPCAD4")
      ;(menucmd "P1=+KPCAD.KPCAD0")
      (menucmd "P2=+KPCAD.KPCAD3")
      (menucmd "P3=+KPCAD.FILE")
      (menucmd "P4=+KPCAD.DRAW")
      (menucmd "P5=+KPCAD.EDIT");2011/11/04 YM ADD �ҏW�ƭ��ǉ�
      (menucmd "P6=+KPCAD.DIMENSION")
      (menucmd "P7=+KPCAD.MODIFY")
      (menucmd "P8=+KPCAD.HELP")  ;00/07/05 SN MOD
      ;(menucmd "P7=+KPCAD.TOOLS");00/07/05 SN MOD
      ;(menucmd "P8=+KPCAD.HELP") ;00/07/05 SN MOD
      (setvar "GRIPS" 1)
      ;@DEL@(setvar "PICKFIRST" 1) ;01/08/24 HN ADD �R�}���h�̔��s�O�ɃI�u�W�F�N�g��I�� ;01/09/09 HN DEL
      (setvar "FILEDIA"   1)  ; 01/11/22 HN ADD �}�ʕۑ��R�}���h�ŏ�Ƀ_�C�A���O�\��
    )
  )
)
;;;ChgSystemCADMenu


;;;<HOM>************************************************************************
;;; <�֐���>  : WebSetFamilyCode
;;; <�����T�v>: ���݌����ɕK�v�ȸ�۰��ق�Ă����ʃf�[�^�x�[�X�֐ڑ�
;;;              PlanInfo.cfg���ڂ������Ŏ擾����
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 02/07/30 YM
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun WebSetFamilyCode (
  /
  #HEIGHT #HINBAN$ #QRY$ #SSIDEPANELTYPE
#DUM #I #MSG #NUM ;2010/01/08 YM ADD
  )

  ;2008/07/30 YM MOD
  ;input.cfg ��LOAD
  ;�������@��۰��ٕϐ��̾��(0�`99�܂�) [SK����].PLAN??�Œ�`����Ă��Ȃ����̂�nil�l�@������
  (princ (strcat "\n�������@��۰��ٕϐ��̾��(0�`99�܂�)�@������ : "))

  (setq #i 0)
  (setq CG_GLOBAL$ nil)
  ;2009/11/18 ���[�g��p
;;; (repeat 100
  (repeat 600 ;����ID=PLAN600�܂őΉ�
    (if (< #i 10)
      (setq #num (strcat "0" (itoa #i)))
      (setq #num (itoa #i))
    );_if
    (setq #dum (CFGet_Input_cfg "SET_INFORMATION" (strcat "PLAN" #num) (strcat CG_SYSPATH "input.cfg")))
    (setq CG_GLOBAL$ (append CG_GLOBAL$ (list #dum)))
    (princ (strcat "\n PLAN" #num "=" ))(princ #dum)
    (setq #i (1+ #i))
  );repeat

  (if (= "K" (nth 3 CG_GLOBAL$))
    (progn
      (setq CG_UnitCode "K");����
      (setq CG_PlanType "SK")
      (setq CG_SeriesDB (nth 1 CG_GLOBAL$))
      ;�y�b��[�u�z����L���̃Z�b�g
      (setq CG_DRSeriCode (nth 12 CG_GLOBAL$))
      (setq CG_DRColCode (nth 13 CG_GLOBAL$))
      (setq CG_Hikite (nth 14 CG_GLOBAL$))

      ;2011/05/27 YM ADD �����ݗ��̐w�}�Ή�
      (setq CG_DRSeriCode_D (nth 12 CG_GLOBAL$));����
      (setq CG_DRColCode_D  (nth 13 CG_GLOBAL$));����
      (setq CG_Hikite_D     (nth 14 CG_GLOBAL$));����

      (setq CG_DRSeriCode_U (nth 112 CG_GLOBAL$));���
      (setq CG_DRColCode_U  (nth 113 CG_GLOBAL$));���
      (setq CG_Hikite_U     (nth 114 CG_GLOBAL$));���

    )
    (progn ;���[
      (setq CG_UnitCode "D");���[
      (setq CG_PlanType "SD")
      (setq CG_SeriesDB (nth 52 CG_GLOBAL$))
      ;�y�b��[�u�z����L���̃Z�b�g
      (setq CG_DRSeriCode (nth 62 CG_GLOBAL$))
      (setq CG_DRColCode  (nth 63 CG_GLOBAL$))
      (setq CG_Hikite     (nth 64 CG_GLOBAL$))

      ;2011/04/22 YM ADD ���̐w�}�Ή�
      (setq CG_DRSeriCode_D (nth 62 CG_GLOBAL$));����
      (setq CG_DRColCode_D  (nth 63 CG_GLOBAL$));����
      (setq CG_Hikite_D     (nth 64 CG_GLOBAL$));����

      (setq CG_DRSeriCode_M (nth 82 CG_GLOBAL$));����
      (setq CG_DRColCode_M  (nth 83 CG_GLOBAL$));����
      (setq CG_Hikite_M     (nth 84 CG_GLOBAL$));����

      (setq CG_DRSeriCode_U (nth 92 CG_GLOBAL$));���
      (setq CG_DRColCode_U  (nth 93 CG_GLOBAL$));���
      (setq CG_Hikite_U     (nth 94 CG_GLOBAL$));���
    )
  );_if

;;;SK01      :�V���[�Y    CG_SeriesCode ==> (nth  1 CG_GLOBAL$)
;;;SK02      :����ȯ�����
;;;SK03      :���j�b�g
;;;SK04      :���݊Ԍ�
;;;SK05      :�`��        CG_W2CODE    ==> (nth  5 CG_GLOBAL$)
;;;SK06      :�۱��������
;;;SK07      :���s��
;;;SK08      :��ĸ۰��
;;;SK09      :��ۈʒu
;;;SK10      :�H��ʒu
;;;SK11      :���E����    CG_LRCode    ==> (nth 11 CG_GLOBAL$)
;;;SK12      :��ذ��
;;;SK13      :���J���[
;;;SK14      :���
;;;SK16      :ܰ�į�ߍގ� CG_WTZaiCode ==> (nth 16 CG_GLOBAL$)
;;;SK17      :�V���N      CG_SinkCode  ==> (nth 17 CG_GLOBAL$)
;;;SK18      :���������H
;;;SK19      :�����@��
;;;SK20      :��ۋ@��
;;;SK21      :�R������
;;;SK22      :�����@�� 2��
;;;SK23      :�ݼ�̰�ދ@��
;;;SK24      :�K�X��
;;;SK25      :��ێ��(Ұ��)
;;;SK31      :ܰ�į�ߍ���
;;;SK32      :�݌ˍ���
;;;SK40      :�����d�l
;;;SK42      :�H��@��
;;;SK44      :��׽�߰è��� ������
;;;SK45      :��������
;;;SK46      :�V��̨װ

;;;    SD51      :���j�b�g
;;;    SD52      :�V���[�Y
;;;    SD62      :��ذ��  ��
;;;    SD63      :���J���[ ��
;;;    SD64      :���@�@ ��
;;;    SD53      :���s��
;;;    SD54      :�^�C�v
;;;    SD55      :���[�Ԍ�
;;;    SD56      :���E����
;;;    SD57      :������F
;;;    SD58      :��ĸ۰��
;;;    SD59      :��Иg��׽
;;;    SD71      :��������
;;;    SD72      :�V��̨װ



  ;// ���ʃf�[�^�x�[�X�ւ̐ڑ�

  (if (= CG_CDBSESSION nil)
    (progn
      (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))

      ; 02/09/06 YM MOD-S WEB�Ŵװ�����ǉ�
      (setq #qry$
        (CFGetDBSQLRec CG_CDBSESSION "SERIES"
          (if (= CG_UnitCode "K")
            (list (list "SERIES����" (nth  1 CG_GLOBAL$) 'STR));SKA
            ;else
            (list (list "SERIES����" (nth 52 CG_GLOBAL$) 'STR));SDA
          );_if
        )
      );setq
      (if (= nil #qry$)
        (progn
          (setq #msg "SERIES�e�[�u����������܂���")
          (c:msgbox #msg "�x��" (logior MB_OK MB_ICONEXCLAMATION)) ; �x�����
          (setq CG_ERRMSG (list #msg))
          (*error* CG_ERRMSG)
        )
        (progn
          (if (= (length #qry$) 1)
            (setq CG_SeriesCode (nth 4 (car #qry$))) ; �ذ�ދL��

          ; else
            (progn
              (setq #msg "SERIES�e�[�u����ں��ނ���������܂���")
              ; 02/09/06 YM MOD-S
              (c:msgbox #msg "�x��" (logior MB_OK MB_ICONEXCLAMATION)) ; �x�����
              (setq CG_ERRMSG (list #msg))
              (*error* CG_ERRMSG)
              ; 02/09/06 YM MOD-E
            )
          );_if
        )
      );_if
      ; 02/09/06 YM MOD-E
    )
  );_if
  (princ)
);WebSetFamilyCode


;;;<HOM>************************************************************************
;;; <�֐���>  : KPCADSetFamilyCode
;;; <�����T�v>: KPCAD�N���ɕK�v�ȸ�۰��ق�Ă����ʃf�[�^�x�[�X�֐ڑ�
;;;              PlanInfo.cfg���ڂ������Ŏ擾����
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 2011/10/04 YM ADD
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun KPCADSetFamilyCode (
  /
  #DUM #I #MSG #NUM #QRY$
#inp_flg   ;-- 2011/10/06 A.Satoh Add
#planinfo$ #planinfo$$	;-- 2011/10/18 A.Satoh Add
  )
  (princ (strcat "\n�������@��۰��ٕϐ��̾��(0�`99�܂�)�@������ : "))
;-- 2011/10/06 A.Satoh Add - S
  (setq #inp_flg nil)
;-- 2011/10/06 A.Satoh Add - E
  (setq #i 0)
  (setq CG_KP_GLOBAL$ nil)
  (repeat 600 ;����ID=PLAN600�܂őΉ�
    (if (< #i 10)
      (setq #num (strcat "0" (itoa #i)))
      (setq #num (itoa #i))
    );_if
    (setq #dum (CFGet_Input_cfg "SET_INFORMATION" (strcat "PLAN" #num) (strcat CG_SYSPATH "input.cfg")))
    (setq CG_KP_GLOBAL$ (append CG_KP_GLOBAL$ (list #dum)))
;;;    (princ (strcat "\n PLAN" #num "=" ))(princ #dum)
    (setq #i (1+ #i))
  );repeat

  ;���ذ��
  (setq CG_SeriesDB   (nth  1 CG_KP_GLOBAL$))
  (if (= CG_SeriesDB nil)
    (setq CG_SeriesDB   (nth 52 CG_KP_GLOBAL$));�m�肷��͂�
  );_if

;;; (if (= CG_SeriesDB nil)
;;;   (setq CG_SeriesDB "PSKB")
;;; );_if

  ;�����ڰ��
  (setq CG_DRSeriCode (nth 12 CG_KP_GLOBAL$))
  (if (= CG_DRSeriCode nil)
    (setq CG_DRSeriCode (nth 62 CG_KP_GLOBAL$))
  );_if

  (if (= CG_DRSeriCode nil)
;-- 2011/10/06 A.Satoh Mod - S
;;;;;    ;�y�b��z���߂���
;;;;;    (setq CG_DRSeriCode "RM");�����l
    (setq #inp_flg T)
;-- 2011/10/06 A.Satoh Mod - E
  );_if

  ;����װ
  (setq CG_DRColCode  (nth 13 CG_KP_GLOBAL$))
  (if (= CG_DRColCode nil)
    (setq CG_DRColCode (nth 63 CG_KP_GLOBAL$))
  );_if

  (if (= CG_DRColCode nil)
;-- 2011/10/06 A.Satoh Mod - S
;;;;;    ;�y�b��z���߂���
;;;;;    (setq CG_DRColCode  "H" );�����l
    (setq #inp_flg T)
;-- 2011/10/06 A.Satoh Mod - E
  );_if

  ;������L��
  (setq CG_Hikite     (nth 14 CG_KP_GLOBAL$))
  (if (= CG_Hikite nil)
    (setq CG_Hikite (nth 64 CG_KP_GLOBAL$))
  );_if

  (if (= CG_Hikite nil)
;-- 2011/10/06 A.Satoh Mod - S
;;;;;    ;�y�b��z���߂���
;;;;;    (setq CG_Hikite     "H" );�����l
    (setq #inp_flg T)
;-- 2011/10/06 A.Satoh Mod - E
  );_if

  ;���޽��
  (setq CG_GasType     (nth 24 CG_KP_GLOBAL$))
	;2014/08/01 YM MOD-S
  (if (or (= CG_GasType nil)(= CG_GasType "N")(= CG_GasType ""))
;;;  (if (= CG_GasType nil)
	;2014/08/01 YM MOD-E

;-- 2011/10/06 A.Satoh Mod - S
;;;;;    ;�y�b��z���߂���
;;;;;    (setq CG_GasType "13A");�����l
;-- 2011/10/21 A.Satoh Mod - S
;;;;;    (setq #inp_flg T)
		(setq CG_GasType (CFgetini "INITIAL" "GasType" (strcat CG_SKPATH "ERRMSG.INI")))
;-- 2011/10/06 A.Satoh Mod - E
  );_if

  ;���g�p
  (setq CG_ElecType        "");�d�C��
  (setq CG_WTHeight    "H850");���[�N�g�b�v����

  ;�����l
;-- 2011/10/18 A.Satoh Mod - S
;;;;;  (setq CG_RoomW        3600);�Ԍ�
;;;;;  (setq CG_RoomD        3600);���s
;;;;;  (setq CG_CeilHeight   2450);�V�䍂��
;;;;;  (setq CG_UpCabHeight  2350);��t����
	(if (findfile (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
		(progn
			(setq #planinfo$$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
			(foreach #planinfo$ #planinfo$$
				(cond
					((= (nth 0 #planinfo$) "Width")
						(setq CG_RoomW       (atoi (nth 1 #planinfo$)))	; �Ԍ�
					)
					((= (nth 0 #planinfo$) "Depth")
						(setq CG_RoomD       (atoi (nth 1 #planinfo$)))	; ���s
					)
					((= (nth 0 #planinfo$) "CeilingHeight")
						(setq CG_CeilHeight  (atoi (nth 1 #planinfo$)))	; �V�䍂��
					)
					((= (nth 0 #planinfo$) "SetHeight")
						(setq CG_UpCabHeight (atoi (nth 1 #planinfo$)))	; ��t����
					)
				)
			)
		)
		(progn
			(setq CG_RoomW        3600)	; �Ԍ�
			(setq CG_RoomD        3600)	; ���s

			;2013/10/21 YM MOD-S �V�䍂��,�݌������w��\
;;;			(setq CG_CeilHeight   2450)	; �V�䍂��
;;;			(setq CG_UpCabHeight  2350)	; ��t����

			(setq CG_CeilHeight  (cadr (assoc "PLAN48" CG_INPUTINFO$))) ;�V�䍂��
			(setq CG_UpCabHeight (cadr (assoc "PLAN49" CG_INPUTINFO$))) ;��t����

			(if CG_CeilHeight
				(setq CG_CeilHeight (atoi (substr CG_CeilHeight 3 10))) ;�V�䍂��
			);_if

			(if CG_UpCabHeight
				(setq CG_UpCabHeight (atoi (substr CG_UpCabHeight 3 10))) ;��t����
			);_if

			(if (= CG_CeilHeight 0)(setq CG_CeilHeight nil)) ;�V�䍂��
			(if (= CG_UpCabHeight 0)(setq CG_UpCabHeight nil)) ;��t����

			(if (or (= nil CG_CeilHeight)(= nil CG_UpCabHeight))
				(progn ;�l�������Ă��Ȃ�������]��ۼޯ�
					(setq CG_CeilHeight   2450)	; �V�䍂��
					(setq CG_UpCabHeight  2350)	; ��t����
				)
			);_if
			;2013/10/21 YM MOD-E �V�䍂��,�݌������w��\

		)
	)
;-- 2011/10/18 A.Satoh Mod - E

  ;// ���ʃf�[�^�x�[�X�ւ̐ڑ�
  (princ "\n�������@�����ް��ް��ւ̐ڑ��@������ :")
  (princ "\n�������@CG_CDBSESSION�@������ :")(princ CG_CDBSESSION)
  (princ (strcat "\n�������@CG_CDBNAME = " CG_CDBNAME))
  (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  ;DB�ڑ��ł��Ȃ��Ȃ�����Đڑ�
  (if (= nil CG_CDBSESSION)
    (progn
      (princ (strcat "\n�������@������x�Z�b�V�����擾�`�������W�@������"))
      (princ (strcat "\n�������@asilisp.arx���A�����[�h���čă��[�h����DB��CONNECT�@������"))

      (cond
        ((= "19" CG_ACADVER)
          (arxunload "asilispX19.arx")
          (arxload "asilispX19.arx")
        )
        ((= "18" CG_ACADVER)
          (arxunload "asilispX18.arx")
          (arxload "asilispX18.arx")
        )

        ((= "17" CG_ACADVER)
          (arxunload "asilispX17.arx")
          (arxload "asilispX17.arx")
        )
        ((= "16" CG_ACADVER)
          (arxunload "asilisp16.arx")
          (arxload "asilisp16.arx")
        )
      );_cond

      (setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
      (princ (strcat "\n�������@�`�������W���ʁ������@CG_CDBSESSION = "))(princ CG_CDBSESSION)
    )
  );_if

  (princ "\n�������@CG_CDBSESSION�@������ :")(princ CG_CDBSESSION)

;;; (if (= CG_SeriesDB nil)
;;;   (setq CG_SeriesDB "PSKB")
;;; );_if

  ;SKB or SDC or LDA ��ϊ�����
  (if CG_SeriesDB
    (progn
      (setq #qry_mdb$$
        (CFGetDBSQLRec CG_CDBSESSION "MDB�ϊ�"
          (list
            (list "�ϊ��O" CG_SeriesDB   'STR)
          )
        )
      )
      (if #qry_mdb$$
        (setq CG_SeriesDB (nth 2 (car #qry_mdb$$)))
      );_if
    )
    (progn
      (setq #msg "SERIES��mdb����������܂���BPSKC�Ƃ��܂��B")
      (c:msgbox #msg "�x��" (logior MB_OK MB_ICONEXCLAMATION)) ; �x�����
      (setq CG_SeriesDB "PSKC")
    )
  );_if




  ; 02/09/06 YM MOD-S WEB�Ŵװ�����ǉ�
  (setq #qry$
    (CFGetDBSQLRec CG_CDBSESSION "SERIES"
      (list
        (list "SERIES����" CG_SeriesDB   'STR)
      )
    )
  )

  (if (= nil #qry$)
    (progn
      (setq #msg "SERIES�e�[�u����������܂���")
      (c:msgbox #msg "�x��" (logior MB_OK MB_ICONEXCLAMATION)) ; �x�����
      (setq CG_ERRMSG (list #msg))
      (*error* CG_ERRMSG)
    )
    (progn
      (if (= (length #qry$) 1)
        (progn
          (setq CG_SeriesCode (nth 4 (car #qry$))) ; �ذ�ދL��
          (setq CG_DBNAME (nth 7 (car #qry$))) ; ��������! �ذ��DB�ڑ��\

;-- 2011/10/06 A.Satoh Add - S
          (if (= #inp_flg T)
            (progn
              ; �����l���̓_�C�A���O����
              (setq #planInfo$ (InputInitInfoDlg))
              (if #planInfo$
                (progn
                  (setq CG_DRSeriCode  (nth 0 #planInfo$))     ; ���O���[�h
                  (setq CG_DRColCode   (nth 1 #planInfo$))     ; ���F
                  (setq CG_Hikite      (nth 2 #planInfo$))     ; ����
                  (setq CG_RoomW       (nth 3 #planInfo$))     ; �Ԍ�
                  (setq CG_RoomD       (nth 4 #planInfo$))     ; ���s
                  (setq CG_CeilHeight  (nth 5 #planInfo$))     ; �V�䍂��
                  (setq CG_UpCabHeight (nth 6 #planInfo$))     ; ��t����
                  (setq CG_GasType     (nth 7 #planInfo$))     ; �K�X��
                )
              )
            )
          )
(princ "\n���������ڰ��(CG_DRSeriCode)  = ") (princ CG_DRSeriCode)
(princ "\n��������װ(CG_DRColCode)      = ") (princ CG_DRColCode)
(princ "\n����������L��(CG_Hikite)      = ") (princ CG_Hikite)
(princ "\n�����������g�w(CG_RoomW)       = ") (princ CG_RoomW)
(princ "\n�����������g�x(CG_RoomD)       = ") (princ CG_RoomD)
(princ "\n�������V�䍂��(CG_CeilHeight)  = ") (princ CG_CeilHeight)
(princ "\n��������t����(CG_UpCabHeight) = ") (princ CG_UpCabHeight)
(princ "\n�������K�X��(CG_GasType)       = ") (princ CG_GasType)
;-- 2011/10/06 A.Satoh Add - E
        )
      ; else
        (progn
          (setq #msg "SERIES�e�[�u����ں��ނ���������܂���")
          (c:msgbox #msg "�x��" (logior MB_OK MB_ICONEXCLAMATION)) ; �x�����
          (setq CG_ERRMSG (list #msg))
          (*error* CG_ERRMSG)
          ; 02/09/06 YM MOD-E
        )
      );_if
    )
  );_if

  (princ)
);KPCADSetFamilyCode


;;;2008/07/30YM@DEL;;;<HOM>************************************************************************
;;;2008/07/30YM@DEL;;; <�֐���>  : WebSetGlobal
;;;2008/07/30YM@DEL;;; <�����T�v>: ̧�ذ���ނ������݌����ɕK�v�ȸ�۰��ق�Ă���
;;;2008/07/30YM@DEL;;; <�߂�l>  : �Ȃ�
;;;2008/07/30YM@DEL;;; <�쐬>    : 02/08/05 YM
;;;2008/07/30YM@DEL;;; <���l>    : INPUT.CFG �Ǎ��ݍς݂�O��(CG_INPUTINFO$)
;;;2008/07/30YM@DEL;;;************************************************************************>MOH<
;;;2008/07/30YM@DEL(defun WebSetGlobal ( / )
;;;2008/07/30YM@DEL  ;// �������(̧�ذ�i��)NO�擾����(srcpln.cfg)
;;;2008/07/30YM@DEL ; SETPLAN_NO=KCKSWLW-ZR25ASEFD1B-0A1A-AM0A-B-SSK
;;;2008/07/30YM@DEL ; SETPLAN_NO=KCKSBBA-ZR25ASEFD1B-08501A-A7000A-B-SSK
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ; 03/05/12 YM ADD-S
;;;2008/07/30YM@DEL  (setq CG_PlanType (cadr (assoc "PLANTYPE" CG_INPUTINFO$))) ; "SK","SD"
;;;2008/07/30YM@DEL  (setq CG_SETPLAN_NO (cadr (assoc "SETPLAN_NO" CG_INPUTINFO$))) ;�������NO
;;;2008/07/30YM@DEL (if CG_SETPLAN_NO
;;;2008/07/30YM@DEL   (progn
;;;2008/07/30YM@DEL     (cond
;;;2008/07/30YM@DEL       ((= CG_PlanType "SK") ; WEB�ŃL�b�`���͂�����ʂ� ; 03/05/12 YM
;;;2008/07/30YM@DEL;;;          (##SetGlobal_SK) ; ���֐��̒��g��ύX��CALL�ʒu��ذ�ޕ�DB�ڑ���ɕύX
;;;2008/07/30YM@DEL         (##SetGlobal_SK_DB) ; 03/09/03 YM MOD
;;;2008/07/30YM@DEL       )
;;;2008/07/30YM@DEL       ((= CG_PlanType "SD") ; WEB�Ŏ��[���͂�����ʂ�   ; 03/05/12 YM 
;;;2008/07/30YM@DEL;;;          (##SetGlobal_SD) ; ���֐��̒��g��ύX��CALL�ʒu��ذ�ޕ�DB�ڑ���ɕύX
;;;2008/07/30YM@DEL         (##SetGlobal_SD_DB) ; 03/09/03 YM MOD
;;;2008/07/30YM@DEL       )
;;;2008/07/30YM@DEL       (T
;;;2008/07/30YM@DEL         (setq CG_PlanType "SK")
;;;2008/07/30YM@DEL         (##SetGlobal_SK_DB)
;;;2008/07/30YM@DEL       )
;;;2008/07/30YM@DEL     );_cond
;;;2008/07/30YM@DEL   )
;;;2008/07/30YM@DEL ; else
;;;2008/07/30YM@DEL   (progn
;;;2008/07/30YM@DEL     (*error*)
;;;2008/07/30YM@DEL   )
;;;2008/07/30YM@DEL );_if
;;;2008/07/30YM@DEL ; 03/05/12 YM ADD-E
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (princ)
;;;2008/07/30YM@DEL);WebSetGlobal
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL   ;/////////////////////////////
;;;2008/07/30YM@DEL   ; �����l�̌������擾����
;;;2008/07/30YM@DEL   ; nil�����l������
;;;2008/07/30YM@DEL   ;/////////////////////////////
;;;2008/07/30YM@DEL   (defun ##GET_KETA ( &str &num / #LIS #RET)
;;;2008/07/30YM@DEL     (setq #lis (assoc &str #dum$$));nil����
;;;2008/07/30YM@DEL     (if #lis
;;;2008/07/30YM@DEL       (setq #ret (fix (+ (nth &num #lis) 0.0001)))
;;;2008/07/30YM@DEL       ;else
;;;2008/07/30YM@DEL       (setq #ret nil)
;;;2008/07/30YM@DEL     );_if
;;;2008/07/30YM@DEL     #ret
;;;2008/07/30YM@DEL   )
;;;2008/07/30YM@DEL   ;/////////////////////////////
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;;;<HOM>************************************************************************
;;;2008/07/30YM@DEL;;; <�֐���>  : ##SetGlobal_SK
;;;2008/07/30YM@DEL;;; <�����T�v>: ̧�ذ���ނ������݌����ɕK�v�ȸ�۰��ق�Ă���(SK)
;;;2008/07/30YM@DEL;;; <�߂�l>  : �Ȃ�
;;;2008/07/30YM@DEL;;; <�쐬>    : 03/05/12 YM ���ٰ�݉�
;;;2008/07/30YM@DEL;;; <���l>    : INPUT.CFG �Ǎ��ݍς݂�O��(CG_INPUTINFO$)
;;;2008/07/30YM@DEL;;;             ��������[SK����]����ǎ�� 03/09/03 YM
;;;2008/07/30YM@DEL;;;             04/03/25 YM MOD �Â��ذ��(DIPLOA�Œǉ�����PLAN44���Ȃ�)�������悤��
;;;2008/07/30YM@DEL;;;************************************************************************>MOH<
;;;2008/07/30YM@DEL(defun ##SetGlobal_SK_DB ( / )
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;04/03/25 YM DEL �O���֐��ɂ���
;;;2008/07/30YM@DEL;;;    ;/////////////////////////////
;;;2008/07/30YM@DEL;;;    (defun ##GET_KETA ( &str &num / )
;;;2008/07/30YM@DEL;;;      (fix (+ (nth &num (assoc &str #dum$$)) 0.0001))
;;;2008/07/30YM@DEL;;;    )
;;;2008/07/30YM@DEL;;;    ;/////////////////////////////
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ;04/03/25 YM ADD
;;;2008/07/30YM@DEL (setq #Qry$$ nil)
;;;2008/07/30YM@DEL  (setq #Qry$$
;;;2008/07/30YM@DEL    (DBSqlAutoQuery CG_DBSESSION
;;;2008/07/30YM@DEL;;;      (strcat "select * from SK����");04/03/25 YM MOD ����ID="?K??"(����)�����擾
;;;2008/07/30YM@DEL     (strcat "select * from SK���� where ����ID like " "'" CG_SeriesCode "K__'" "order by \"ID\"");04/03/25 YM MOD
;;;2008/07/30YM@DEL   )
;;;2008/07/30YM@DEL  )
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ;04/03/25 YM ADD-S "DIVMARK" ��"�����ʒu"=0�͏��O����
;;;2008/07/30YM@DEL (setq #dum$$ nil)
;;;2008/07/30YM@DEL (foreach #Qry$ #Qry$$
;;;2008/07/30YM@DEL   (if (or (equal (nth 3 #Qry$) 0.0 0.001)
;;;2008/07/30YM@DEL           (= (nth 4 #Qry$) "DIVMARK"))
;;;2008/07/30YM@DEL     (progn
;;;2008/07/30YM@DEL       nil ; ���O����
;;;2008/07/30YM@DEL     )
;;;2008/07/30YM@DEL     (progn
;;;2008/07/30YM@DEL       (setq #dum$$ (append #dum$$ (list #Qry$)))
;;;2008/07/30YM@DEL     )
;;;2008/07/30YM@DEL   );_if
;;;2008/07/30YM@DEL )
;;;2008/07/30YM@DEL (setq #Qry$$ #dum$$)
;;;2008/07/30YM@DEL ;04/03/25 YM ADD-E "DIVMARK" ��"�����ʒu"=0�͏��O����
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ;����ID(PLAN44�Ȃ�)��ؽĂ̐擪�Ɏ����Ă���(ASSOC���g����������)
;;;2008/07/30YM@DEL (setq #dum$ nil #dum$$ nil)
;;;2008/07/30YM@DEL (foreach #Qry$ #Qry$$
;;;2008/07/30YM@DEL   (setq #dum$ (cons (nth 4 #Qry$) #Qry$))
;;;2008/07/30YM@DEL   (setq #dum$$ (append #dum$$ (list #dum$)))
;;;2008/07/30YM@DEL )
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN03" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN03" 8))
;;;2008/07/30YM@DEL (setq CG_UnitCode        (substr CG_SETPLAN_NO  #num1 #num2)) ;���j�b�g�L��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;;;  (setq CG_SeriesDB        (substr CG_SETPLAN_NO  2 3)) ;SERIESDB��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN12" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN12" 8))
;;;2008/07/30YM@DEL (setq CG_DRSeriCode      (substr CG_SETPLAN_NO #num1 #num2)) ;��SERIES�L��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN13" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN13" 8))
;;;2008/07/30YM@DEL (setq CG_DRColCode       (substr CG_SETPLAN_NO #num1 #num2)) ;��COLOR�L��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN05" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN05" 8))
;;;2008/07/30YM@DEL  (setq CG_W2Code          (substr CG_SETPLAN_NO #num1 #num2)) ;�Ԍ�2
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN11" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN11" 8))
;;;2008/07/30YM@DEL  (setq CG_LRCode          (substr CG_SETPLAN_NO #num1 #num2)) ;LR�敪
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN04" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN04" 8))
;;;2008/07/30YM@DEL (setq CG_W1Code          (substr CG_SETPLAN_NO #num1 #num2)) ;�Ԍ�1
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN16" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN16" 8))
;;;2008/07/30YM@DEL  (setq CG_WTZaiCode       (substr CG_SETPLAN_NO #num1 #num2)) ;�ގ��L��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN07" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN07" 8))
;;;2008/07/30YM@DEL  (setq CG_Type2Code       (substr CG_SETPLAN_NO #num1 #num2)) ;�^�C�v2 �ׯ�,�i��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN06" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN06" 8))
;;;2008/07/30YM@DEL  (setq CG_Type1Code       (substr CG_SETPLAN_NO #num1 #num2)) ;�^�C�v1 "P1","S1"
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN17" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN17" 8))
;;;2008/07/30YM@DEL  (setq CG_SinkCode        (substr CG_SETPLAN_NO #num1 #num2)) ;�ݸ�L��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN42" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN42" 8))
;;;2008/07/30YM@DEL  (setq CG_NPCode          (substr CG_SETPLAN_NO #num1 #num2)) ;�H��@���
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ;04/03/12 YM ADD-S WEB��DIPLOA������װ
;;;2008/07/30YM@DEL;;;(princ "\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN44" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN44" 8))
;;;2008/07/30YM@DEL ;04/03/25 YM MOD-S
;;;2008/07/30YM@DEL ;���ذ�ނł�"PLAN44"���Ȃ���CG_Counter = "0"
;;;2008/07/30YM@DEL (if (or (= nil #num1)(= nil #num2))
;;;2008/07/30YM@DEL   (setq CG_Counter                                "0") ;������F(��׊Ǘ�.����޳�)
;;;2008/07/30YM@DEL   (setq CG_Counter (substr CG_SETPLAN_NO #num1 #num2)) ;������F(��׊Ǘ�.����޳�)
;;;2008/07/30YM@DEL );_if
;;;2008/07/30YM@DEL ;04/03/25 YM MOD-E
;;;2008/07/30YM@DEL;;;(princ "\nBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB")
;;;2008/07/30YM@DEL ;04/03/12 YM ADD-E WEB��DIPLOA������װ
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN31" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN31" 8))
;;;2008/07/30YM@DEL  (setq CG_BaseCabHeight   (substr CG_SETPLAN_NO #num1 #num2)) ;�۱  ��t�^�C�v1
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN18" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN18" 8))
;;;2008/07/30YM@DEL  (setq CG_WtrHoleTypeCode (substr CG_SETPLAN_NO #num1 #num2)) ;������ 0:�Ȃ�  1:����
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN19" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN19" 8))
;;;2008/07/30YM@DEL  (setq CG_WtrHoleCode     (substr CG_SETPLAN_NO #num1 #num2)) ;����   0:�����Ȃ� 1:�W�� 2:����n
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN20" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN20" 8))
;;;2008/07/30YM@DEL  (setq CG_CRCode          (substr CG_SETPLAN_NO #num1 #num2)) ;���
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN32" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN32" 8))
;;;2008/07/30YM@DEL  (setq CG_UpperCabHeight  (substr CG_SETPLAN_NO #num1 #num2)) ;���� ��t�^�C�v2
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN14" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN14" 8))
;;;2008/07/30YM@DEL  (setq CG_SoftDownCode    (substr CG_SETPLAN_NO #num1 #num2)) ;����޳�
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN23" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN23" 8))
;;;2008/07/30YM@DEL  (setq CG_RangeCode       (substr CG_SETPLAN_NO #num1 #num2)) ;�ݼ�
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN21" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN21" 8))
;;;2008/07/30YM@DEL  (setq CG_CRUnderCode     (substr CG_SETPLAN_NO #num1 #num2)) ;��ۉ�
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN08" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN08" 8))
;;;2008/07/30YM@DEL  (setq CG_SinkUnderCode   (substr CG_SETPLAN_NO #num1 #num2)) ;�ݸ���d�l �^�C�v3
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ;��NAS�̓v���������őϐk���b�NCG_DoorGrip�ɑ��(Planinfo.cfg����Ƃ�Ȃ�)
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN15" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN15" 8))
;;;2008/07/30YM@DEL  (setq CG_DoorGrip        (substr CG_SETPLAN_NO #num1 #num2)) ;�ϐkۯ� �ϐk���b�N
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN33" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN33" 8))
;;;2008/07/30YM@DEL  (setq CG_KikiColor       (substr CG_SETPLAN_NO #num1 #num2)) ;�@��F
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;2008/07/26 YM DEL
;;;2008/07/30YM@DEL;;;  (setq CG_UnitBase  "1") ;�۱�z�u�׸�
;;;2008/07/30YM@DEL;;;  (setq CG_UnitUpper "1") ;���ٔz�u�׸�
;;;2008/07/30YM@DEL;;;  (setq CG_UnitTop   "1") ;ܰ�į�ߔz�u�׸�
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL  (setq CG_FilerCode     (cadr (assoc "SKOP04" CG_INPUTINFO$)))  ;�V��̨װ
;;;2008/07/30YM@DEL  (setq CG_SidePanelCode (cadr (assoc "SKOP05" CG_INPUTINFO$)))  ;��������
;;;2008/07/30YM@DEL  (setq CG_Kcode  "K")     ; �H��L��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (princ)
;;;2008/07/30YM@DEL);##SetGlobal_SK
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;;;<HOM>************************************************************************
;;;2008/07/30YM@DEL;;; <�֐���>  : ##SetGlobal_SD
;;;2008/07/30YM@DEL;;; <�����T�v>: ̧�ذ���ނ������݌����ɕK�v�ȸ�۰��ق�Ă���(SD)
;;;2008/07/30YM@DEL;;; <�߂�l>  : �Ȃ�
;;;2008/07/30YM@DEL;;; <�쐬>    : 03/05/12 YM ���ٰ�݉�
;;;2008/07/30YM@DEL;;; <���l>    : INPUT.CFG �Ǎ��ݍς݂�O��(CG_INPUTINFO$)
;;;2008/07/30YM@DEL;;;             ��������[SK����]����ǎ�� 03/09/03 YM
;;;2008/07/30YM@DEL;;;************************************************************************>MOH<
;;;2008/07/30YM@DEL(defun ##SetGlobal_SD_DB ( / )
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;04/03/25 YM DEL �O���֐��ɂ���
;;;2008/07/30YM@DEL;;;    ;/////////////////////////////
;;;2008/07/30YM@DEL;;;    (defun ##GET_KETA ( &str &num / )
;;;2008/07/30YM@DEL;;;      (fix (+ (nth &num (assoc &str #dum$$)) 0.0001))
;;;2008/07/30YM@DEL;;;    )
;;;2008/07/30YM@DEL;;;    ;/////////////////////////////
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #Qry$$ nil)
;;;2008/07/30YM@DEL  (setq #Qry$$
;;;2008/07/30YM@DEL    (DBSqlAutoQuery CG_DBSESSION
;;;2008/07/30YM@DEL     (strcat "select * from SK����")
;;;2008/07/30YM@DEL   )
;;;2008/07/30YM@DEL  )
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL(princ #Qry$$)
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #dum$ nil #dum$$ nil)
;;;2008/07/30YM@DEL (foreach #Qry$ #Qry$$
;;;2008/07/30YM@DEL   (setq #dum$ (cons (nth 4 #Qry$) #Qry$))
;;;2008/07/30YM@DEL   (setq #dum$$ (append #dum$$ (list #dum$)))
;;;2008/07/30YM@DEL )
;;;2008/07/30YM@DEL;;;"DCKC???A120P3L0"
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN51" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN51" 8))
;;;2008/07/30YM@DEL (setq CG_UnitCode        (substr CG_SETPLAN_NO #num1 #num2)) ;���j�b�g�L��
;;;2008/07/30YM@DEL;;;  (setq CG_SeriesDB   (substr CG_SETPLAN_NO  2 3)) ;SERIESDB��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN12" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN12" 8))
;;;2008/07/30YM@DEL (setq CG_DRSeriCode (substr CG_SETPLAN_NO #num1 #num2)) ;��SERIES�L��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN13" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN13" 8))
;;;2008/07/30YM@DEL (setq CG_DRColCode  (substr CG_SETPLAN_NO #num1 #num2)) ;��COLOR�L��
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN56" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN56" 8))
;;;2008/07/30YM@DEL (setq CG_LRCode     (substr CG_SETPLAN_NO #num1 #num2)) ;LR�敪
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL  (setq CG_DoorGrip   "S") ;�ϐkۯ� �ϐk���b�N
;;;2008/07/30YM@DEL  (setq CG_KikiColor  "K") ;�@��F
;;;2008/07/30YM@DEL;;;  (setq CG_UnitBase  "1") ;�۱�z�u�׸�
;;;2008/07/30YM@DEL;;;  (setq CG_UnitUpper "1") ;���ٔz�u�׸�
;;;2008/07/30YM@DEL;;;  (setq CG_UnitTop   "1") ;ܰ�į�ߔz�u�׸�
;;;2008/07/30YM@DEL;;;  (setq CG_FilerCode     (cadr (assoc "SDOP04" CG_INPUTINFO$)))  ;�V��̨װ
;;;2008/07/30YM@DEL;;;  (setq CG_SidePanelCode (cadr (assoc "SDOP05" CG_INPUTINFO$)))  ;��������
;;;2008/07/30YM@DEL  (setq CG_Kcode  "K")     ; �H��L��
;;;2008/07/30YM@DEL ;���L���𔲂�
;;;2008/07/30YM@DEL ;04/03/15 YM ADD ��ؔ�׋L���̌������擾
;;;2008/07/30YM@DEL (setq #strlen_door (strlen (strcat CG_DRSeriCode CG_DRColCode)))
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq CG_FamilyCode (strcat (substr CG_SETPLAN_NO 1 4)(substr CG_SETPLAN_NO (+ 5 #strlen_door) 50))) ; DWG��
;;;2008/07/30YM@DEL (princ)
;;;2008/07/30YM@DEL);##SetGlobal_SD
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL


;<HOM>*************************************************************************
; <�֐���>    : CFGet_Input_cfg
; <�����T�v>  : ini �t�@�C���̓��e��ǂݍ���
; <�߂�l>    :
;         STR : �ǂݍ��񂾍��ڕ���
;             ; �ǂݍ��߂Ȃ������ꍇ nil
; <���l>      : CFgetini�Ɠ�������nil�̂Ƃ��x���Ȃ��ł��̂܂ܒl��Ԃ�
;*************************************************************************>MOH<
(defun CFGet_Input_cfg (
   &sSection  ; [�Z�N�V����]
   &sEntry  ; �G���g���[=
   &sFilename ; \\�t�@�C���� (�t���p�X�Ŏw��)
   /
   #pRet  ; �t�@�C�����ʎq
   #sLine ; ���ݓǂݍ��ݍs
   #sSection  ; ���݃Z�N�V����
   #sEntry  ; ���݃G���g��
   #sEntStr ;
   #sTmp  ;
   #iColumn ;
   #sRet  ;
#END_FLG
   )
;///////////////////////////////////////////////////////////////////////
    ;; �R�����g���Ȃ���������ɂ���
  ;; �Ȃ������ʈӖ��̂Ȃ��s�ɂȂ�ꍇ�� nil ��Ԃ�
    (defun Comment_Omit (
      &sLine
      /
       #iIDX  ;
      )
      ; �R�����g�s
        ; XXX �����͂���ł������H�H
      (setq #iIDX (vl-string-position (ascii ";") &sLine))
      (if (/= #iIDX nil)
        (progn
          (setq &sLine (substr &sLine 1 #iIDX)) 
         )
      );_if

        ; �Ӗ��̂���s�ɂ� = �� [ ] ���܂܂��͂�
      (if (or (vl-string-position  (ascii "=") &sLine)
         (and (vl-string-position  (ascii "[") &sLine)
              (vl-string-position  (ascii "]") &sLine)))
          &sLine
          nil
      );_if
  );Comment_Omit
;///////////////////////////////////////////////////////////////////////
    ; �t�@�C�����I�[�v��
  (setq #END_FLG T) ; �擾������I��� 01/02/06 YM ADD

  (setq #pRet (open &sFilename "r"))
  (if (/= #pRet nil)
    (progn
      (setq #sLine (read-line #pRet))
      ; 1�s���ǂݍ���
      (while (and #END_FLG (/= #sLine nil))
        ; �R�����g�s���Ȃ�
        (setq #sLine (Comment_Omit #sLine))
        ; �L���ȍs�������ꍇ
        (if (/= #sLine nil)
          (progn 
          ; ���ݍs�̃Z�N�V���������擾����
            (setq #sTmp (vl-string-right-trim " \t\n" (vl-string-left-trim "[" #sLine)))
            (if (/= #sTmp #sLine)
              (setq #sSection (substr #sLine 2 (- (strlen #sTmp) 1)))
            );_if
        
            ; ���ݍs�̃Z�N�V�������Ǝw�肵���Z�N�V���������������ꍇ
            ; �G���g������������
            (if (= &sSection #sSection)
              (progn 
                (setq #sLine (read-line #pRet))
                (while (and #END_FLG (/= #sLine nil))
                  ; �R�����g�s���Ȃ�
                  (setq #sLine (Comment_Omit #sLine))
                  ; �L���ȍs�������ꍇ
                  (if (/= #sLine nil)
                  ; �G���g�����擾����
                  ; XXX �G���g���͍ŏ��̃J��������n�܂�A�X�y�[�X,=���܂܂Ȃ��A�Ƃ��Ă悢���H
                    (progn 
                      (setq #sEntry (car (strparse #sLine "=")))
                      (setq #sEntStr (cadr (strparse #sLine "=")))
                      ; �擾�����L���ȃG���g���Ǝw�肵���G���g�����r����
                      (if  (and (/= #sEntry nil) (= #sEntry &sEntry))
                        (progn
                          (setq #sRet #sEntStr)
                          (setq #END_FLG nil) ; �擾������I��� 01/02/06 YM ADD
                          ;;; \\n ��\n�ɒu������
                          (while (vl-string-search "\\n" #sRet) ; "\\n"�����邩?
                            (setq #sRet (vl-string-subst "\n" "\\n" #sRet)) ; �ŏ���1�u��
                          )
                        )
                      );_if
                    )
                  ) ; (if (/= #sLine nil)
                  (setq #sLine (read-line #pRet))
                ) ; (while (/= #sLine nil)
              ) ; progn
            ) ; if (= &sSection #sSection)
          )
        );_if
        (setq #sLine (read-line #pRet))
      ); while (/= #sLine nil)
    )
    (progn
    ; �t�@�C���I�[�v���G���[  
      (print (strcat "�t�@�C�����Ȃ�:" &sFilename))
      nil
    )
  );_if

  #sRet
);CFGet_Input_cfg


;;;<HOM>*************************************************************************
;;; <�֐���>    : PKC_PG_BUNKI
;;; <�����T�v>  : �V���[�Y�y�уo�[�W�����ɂ��PG���򐧌�p�R�[�h�̎擾
;;; <�߂�l>    :
;;; <�쐬>      :
;;; <���l>      : �Ȃ�
;;;*************************************************************************>MOH<
(defun PKC_PG_BUNKI (
  /
  )
  (setq BU_CODE_0001 (PKC_PG_BUNKI_sub "BU_CODE_0001"))
  (setq BU_CODE_0002 (PKC_PG_BUNKI_sub "BU_CODE_0002"))
  (setq BU_CODE_0003 (PKC_PG_BUNKI_sub "BU_CODE_0003"))
  (setq BU_CODE_0004 (PKC_PG_BUNKI_sub "BU_CODE_0004"))
  (setq BU_CODE_0005 (PKC_PG_BUNKI_sub "BU_CODE_0005"))
  (setq BU_CODE_0006 (PKC_PG_BUNKI_sub "BU_CODE_0006"))
  (setq BU_CODE_0007 (PKC_PG_BUNKI_sub "BU_CODE_0007"))
  (setq BU_CODE_0008 (PKC_PG_BUNKI_sub "BU_CODE_0008"))
  (setq BU_CODE_0009 (PKC_PG_BUNKI_sub "BU_CODE_0009"))
  (setq BU_CODE_0010 (PKC_PG_BUNKI_sub "BU_CODE_0010"))
  (setq BU_CODE_0011 (PKC_PG_BUNKI_sub "BU_CODE_0011"))
  (setq BU_CODE_0012 (PKC_PG_BUNKI_sub "BU_CODE_0012"))
  (setq BU_CODE_0013 (PKC_PG_BUNKI_sub "BU_CODE_0013"))
  (setq BU_CODE_0014 (PKC_PG_BUNKI_sub "BU_CODE_0014"))
  (setq BU_CODE_0015 (PKC_PG_BUNKI_sub "BU_CODE_0015"))
  (setq BU_CODE_0016 (PKC_PG_BUNKI_sub "BU_CODE_0016"))
  (setq BU_CODE_0017 (PKC_PG_BUNKI_sub "BU_CODE_0017"))
  (setq BU_CODE_0018 (PKC_PG_BUNKI_sub "BU_CODE_0018"))
  (setq BU_CODE_0019 (PKC_PG_BUNKI_sub "BU_CODE_0019"))
  (setq BU_CODE_0020 (PKC_PG_BUNKI_sub "BU_CODE_0020"))
  (princ)
)

(defun PKC_PG_BUNKI_sub (
  &bunki_code
  /
  #Record
  )
  (setq #Record
    (car
      (CFGetDBSQLRec CG_CDBSESSION "�J�X�^��PG����"
        (list
          (list "����CODE" &bunki_code 'STR)
          (list "SIRIES"   CG_SeriesDB 'STR)
        )
      )
    )
  )
  (if (= #Record nil)
    (progn
      (setq #Record
        (car
          (CFGetDBSQLRec CG_CDBSESSION "�J�X�^��PG����"
            (list
              (list "����CODE" &bunki_code 'STR)
              (list "SIRIES"   "__OTHER" 'STR)
            )
          )
        )
      )
    )
  )
  (if #Record (nth 3 #Record) "")
)

(princ)
