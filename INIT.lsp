;;;<HOM>************************************************************************
;;; <�t�@�C����>: INIT.LSP
;;; <�V�X�e����>: �E�b�h�����l����)
;;; <�ŏI�X�V��>: 
;;; <���l>      : 
;;;************************************************************************>MOH<
;@@@(princ "\nINIT.fas ��۰�ޒ�...\n")

;;;<HOM>************************************************************************
;;; <�֐���>  : InitKPCAD
;;; <�����T�v>: KPCAD�̏����ݒ�
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun InitKPCAD (
  /
  )
	(princ (strcat "\n�������@�֐�(InitKPCAD)�� ������"))
  ;//�t�H���_���̃O���[�o���ϐ���ݒ�
  (setq CG_SKPATH     CG_SYSPATH) ;�L�b�`���V�X�e��

	(if (= CG_PROGRAM "ACAD")
	  (setq CG_LISPPATH   CG_SYSPATH) ;�v���O����
		;else
	  (setq CG_LISPPATH   CG_KPCAD_SYSTEM_PATH) ;�v���O����
	);_if

	(princ "\n������CG_LISPPATH��")(princ CG_LISPPATH)
	(princ "\n")

  (setq CG_DCLPATH    (strcat CG_SYSPATH    "SUPPORT\\"          ))

	(princ "\n������CG_DCLPATH��")(princ CG_DCLPATH)
	(princ "\n")

  (setq CG_CFGPATH    (strcat CG_SYSPATH    "CFG\\"              ))
  (setq CG_TMPAPATH   (strcat CG_SYSPATH    "TEMPLATE\\DEFAULT\\"))
  (setq CG_TMPHPATH   (strcat CG_SYSPATH    "TEMPLATE\\USER\\"   ))
  (setq CG_BLOCKPATH  (strcat CG_SYSPATH    "BLOCK\\"            ))
  (setq CG_SLDPATH    (strcat CG_SYSPATH    "SLD\\"              ))
  (setq CG_LOGFILE    (strcat CG_LOGPATH    "SKDebug.log"        ))
  (setq CG_DROPENPATH (strcat CG_SKDATAPATH "DROPEN\\"           ))

  ; 02/09/03 YM ADD-S
  (if (= CG_AUTOMODE 2) ; WEB��
    (progn
      ;// ���O�t�@�C���𕨌��ԍ����ɕύX����
      (setq #date (menucmd "M=$(edtime,$(getvar,date),YYYY�NMONTHD��)"))
      ;�� "2008�N8��9��"
      (setq CG_LOGFILE (strcat CG_LOGPATH #date ".LOG"));2008/08/09 YM MOD ���t�̖��O��۸�̧��
      (setq CG_ERRFILE (strcat CG_ERRPATH #date ".LOG"));2008/08/09 YM MOD ���t�̖��O��۸�̧��
;;;     (if (findfile CG_LOGFILE)(vl-file-delete CG_LOGFILE))
;;;     (if (findfile CG_ERRFILE)(vl-file-delete CG_ERRFILE))
    )
  );_if

  ;-------- Dummy XRECORD ����擾���� ------------
  ;  (setq CG_KITTYPE "I-LEFT")
  ;  (setq CG_KITTYPE "W-LEFT")

  (regapp "G_ARW")              ;���̊g���f�[�^�A�v���P�[�V������
  (setvar "PLINEWID" 10)        ;���̐�����

  ;// �v���O�����̃��[�h
	(princ (strcat "\n�������@CmnLoadProgram��call�@������"))
  (CmnLoadProgram)
	
	(princ (strcat "\n�������@LoadProgramKPCAD��call�@������"))
  (LoadProgramKPCAD)

	(princ (strcat "\n�������@�֐�(InitKPCAD)�@�d�m�c�@������"))
  (princ)
);;;InitKPCAD

;;;<HOM>************************************************************************
;;; <�֐���>  : CmnLoadProgram
;;; <�����T�v>: ���ʃv���O�����̃��[�h
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun CmnLoadProgram (
  /
  )
	(princ (strcat "\n�������@�֐�(CmnLoadProgram)�� ---�@������"))
  ;// ARX���[�h
  ;06/06/14 AO MOD OEM�ŁA���i��(�o�[�W�������Ƀ��[�h�t�@�C����ύX)
  (if (= "ACAD" CG_PROGRAM)
    (progn ;���M�����[��
      (princ (strcat "\n�������@�K�v��ARX�̃��[�h���s��"))
	    (cond
	      ;2015/03/17 YM ADD 2014�p
	      ((= "19" CG_ACADVER)
	          (princ (strcat "\n�������@asilispX19.arx ���[�h�@������"))
	          (if (= nil (member "asilispX19.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "asilispX19.arx")) ;asilisp
	          );if

	          (princ (strcat "\n�������@utils19.arx ���[�h�@������"))
	          (if (= nil (member "utils19.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "utils19.arx"  )) ;UTILS
	          );if

	          (princ (strcat "\n�������@SKDisableClose19.arx ���[�h�@������"))
	          (if (= nil (member "SKDisableClose19.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "SKDisableClose19.arx"  )) ;SKDisableClose
	          );if

	          (if (= nil (member "kpdeploy19.arx" (arx)))
	            (if (findfile (strcat CG_LISPPATH "kpdeploy19.arx"))
	              (arxload (strcat CG_LISPPATH "kpdeploy19.arx"  ))
	            );_if
	          )

	          (if (= nil (member "BukkenInfoRewrite19.arx" (arx)))
	            (if (findfile (strcat CG_LISPPATH "BukkenInfoRewrite19.arx"))
	              (arxload (strcat CG_LISPPATH "BukkenInfoRewrite19.arx"  ))
	            );_if
	          )

	          (princ (strcat "\n�������@doslib��LOAD���Ȃ��@������"))
	      )

	      ;2020/01/30 YM ADD 2019�p
	      ((= "23" CG_ACADVER)
	          (princ (strcat "\n�������@asilispX.arx ���[�h(2019)�@������"))
	          (if (= nil (member "asilispX.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "asilispX.arx")) ;asilisp
	          );if

	          (princ (strcat "\n�������@utils.arx ���[�h(2019)�@������"))
	          (if (= nil (member "utils.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "utils.arx"  )) ;UTILS
	          );if

	          (princ (strcat "\n�������@SKDisableClose.arx ���[�h(2019)�@������"))
	          (if (= nil (member "SKDisableClose.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "SKDisableClose.arx"  )) ;SKDisableClose
	          );if

	          (princ (strcat "\n�������@kpdeploy.arx ���[�h(2019)�@������"))
	          (if (= nil (member "kpdeploy.arx" (arx)))
	            (if (findfile (strcat CG_LISPPATH "kpdeploy.arx"))
	              (arxload (strcat CG_LISPPATH "kpdeploy.arx"  ))
	            );_if
	          )

	          (princ (strcat "\n�������@BukkenInfoRewrite.arx ���[�h(2019)�@������"))
	          (if (= nil (member "BukkenInfoRewrite.arx" (arx)))
	            (if (findfile (strcat CG_LISPPATH "BukkenInfoRewrite.arx"))
	              (arxload (strcat CG_LISPPATH "BukkenInfoRewrite.arx"  ))
	            );_if
	          )

	          (princ (strcat "\n�������@doslib��LOAD���Ȃ��@������"))
	      )

				(T
				  nil
			 	)
			);cond
    )
    ;else
    (progn ; AutoCAD 2014 OEM��
      ; ACAD OEM��
      (princ (strcat "\n�������@OEM�łŒʂ�!!!�@������"))

			(princ "\n������CG_LISPPATH��")(princ CG_LISPPATH)
			(princ "\n")

      (princ (strcat "\n�������@asilispX19oem.arx ���[�h�@������"))
      (if (= nil (member "asilispX19oem.arx" (arx)))
        (arxload (strcat CG_LISPPATH "asilispX19oem.arx")) ;asilisp
      );if
      (princ (strcat "\n�������@asilispX19oem.arx ���[�h�y�I���z�@������"))


      (princ (strcat "\n�������@utils19oem.arx ���[�h�@������"))
      (if (= nil (member "utils19oem.arx" (arx)))
        (arxload (strcat CG_LISPPATH "utils19oem.arx"  )) ;UTILS
      );if
      (princ (strcat "\n�������@utils19oem.arx ���[�h�y�I���z�@������"))


      (princ (strcat "\n�������@SKDisableClose19oem.arx ���[�h�@������"))
      (if (= nil (member "SKDisableClose19oem.arx" (arx)))
        (arxload (strcat CG_LISPPATH "SKDisableClose19oem.arx"  )) ;SKDisableClose
      );if
      (princ (strcat "\n�������@SKDisableClose19oem.arx ���[�h�y�I���z�@������"))


      (princ (strcat "\n�������@kpdeploy19oem.arx ���[�h�@������"))
      (if (= nil (member "kpdeploy19oem.arx" (arx)))
        (if (findfile (strcat CG_LISPPATH "kpdeploy19oem.arx"))
          (arxload (strcat CG_LISPPATH "kpdeploy19oem.arx"  ))
        );_if
      )
      (princ (strcat "\n�������@kpdeploy19oem.arx ���[�h�y�I���z�@������"))


      (princ (strcat "\n�������@BukkenInfoRewrite19oem.arx ���[�h�@������"))
      (if (= nil (member "BukkenInfoRewrite19oem.arx" (arx)))
        (if (findfile (strcat CG_LISPPATH "BukkenInfoRewrite19oem.arx"))
          (arxload (strcat CG_LISPPATH "BukkenInfoRewrite19oem.arx"  ))
        );_if
      )
			(princ (strcat "\n�������@BukkenInfoRewrite19oem.arx ���[�h�y�I���z�@������"))


			;2017/06/20 YM ADD-S �t���[���L�b�`���Ή� ���K�\�����������߂ɕK�v
      (princ (strcat "\n�������@acetutil.arx ���[�h�@������"))
      (if (= nil (member "acetutil.arx" (arx)))
        (if (findfile (strcat CG_LISPPATH "acetutil.arx"))
          (arxload (strcat CG_LISPPATH "acetutil.arx"  ))
        );_if
      );_if
      (princ (strcat "\n�������@acetutil.arx ���[�h�y�I���z�@������"))
			;2017/06/20 YM ADD-E �t���[���L�b�`���Ή� ���K�\�����������߂ɕK�v

      (princ (strcat "\n�������@doslib��LOAD���Ȃ��@������"))
    )
  );if

	(princ (strcat "\n�������@DBSQL�ق� LOAD�@������"))

  ;06/06/14 AO ADD ���[�h����t�@�C�������g���q���폜 �� fas�����[�h
  (load (strcat CG_LISPPATH "DBSQL"   ))  ;DB�A�N�Z�X
  (load (strcat CG_LISPPATH "COMMON"  ))  ;����
  (load (strcat CG_LISPPATH "CFOUTSTA"))  ;���O�t�@�C���o��
  (load (strcat CG_LISPPATH "CFCMN"   ))  ;����
  ;***************************************************

	(princ (strcat "\n�������@CmnLoadProgram�@�d�m�c�@������"))
  (princ)
);CmnLoadProgram

;;;<HOM>************************************************************************
;;; <�֐���>  : LoadProgramKPCAD
;;; <�����T�v>: KPCAD�v���O�����̃��[�h
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun LoadProgramKPCAD (
  /
  )
	(princ (strcat "\n�������@LoadProgramKPCAD�@START�@������"))

	(princ (strcat "\n�������@geom3d.crx load�@������"))
  (if (= nil (member "geom3d.arx"   (arx))) (arxload "GEOM3D"));crx�ɕύX 2015/03/18

	(princ (strcat "\n�������@acsolids.crx load�@������"))
  (if (= nil (member "acsolids.arx" (arx))) (arxload "ACSOLIDS"));crx�ɕύX 2015/03/18

  (if (= CG_LoadSK nil)
    (progn
			(princ (strcat "\n�������@Utils.fas load�@������"))
      (load (strcat CG_LISPPATH "Utils")) ;���[�e�B���e�B
			(princ (strcat "\n�������@load.fas load�@������"))
      (load (strcat CG_LISPPATH "load" ))
      (LOADLOAD)
      (setq CG_LoadSK T)
    )
  )
  (princ)
)
;;;LoadProgramKPCAD

;;;<HOM>************************************************************************
;;; <�֐���>  : ReadInputCFG
;;; <�����T�v>: INPUT.CFĢ�ق�Read����
;;; <�߂�l>  : �L�[�ƒl�̃��X�g�Q
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun ReadInputCFG (
  /
  #fp
  #rstr
  #itm$
  #res$$
  #key
  )

  (setq #fp (open "./input.cfg" "r")) ;̧�ٵ����(READ)
  (while (setq #rstr (read-line #fp)) ;̧�ق�ǂݍ���
    (if (= (substr #rstr 1 1) "*")    ;�������������ŋ�؂�
      (progn
        (if (/= #key nil)
          (progn
            (setq #res$$ (append #res$$ (list (cons #key (list #itm$)))))
            (setq #itm$ nil)
          )
        )
        (setq #key #rstr)
      )
      (progn
        (setq #itm$ (append #itm$ (list #rstr)))
      )
    )
  )
  (setq #res$$ (append #res$$ (list (cons #key (list #itm$)))))
  (close #fp)  ;// ̧�ٸ۰��

  ;// ���ʂ�Ԃ�
  #res$$
)
;;;ReadInputCFG

;;;<HOM>************************************************************************
;;; <�֐���>    : ReadIniFile
;;; <�����T�v>  : INI�t�@�C����Read����
;;; <�߂�l>    : �L�[������ƒl�̃��X�g�Q
;;; <���l>      : �Ȃ�
;;;************************************************************************>MOH<
(defun ReadIniFile (
  &inifile
  /
  #fp
  #rstr
  #itm$
  #res$$
  )

  (setq #fp (open &inifile "r"))      ;�t�@�C���I�[�v��(READ)
  (while (setq #rstr (read-line #fp)) ;�t�@�C����ǂݍ���
    (setq #itm$ (strparse #rstr "=")) ;��������f�~���^�ŋ�؂�
    (setq #res$$ (append #res$$ (list #itm$)))
  )
  (close #fp)  ;// �t�@�C���N���[�Y

  ;// ���ʂ�Ԃ�
  #res$$
)
;;;ReadIniFile

;;;<HOM>************************************************************************
;;; <�֐���>  : StrParse
;;; <�����T�v>: ��������w���؂蕶���ŕ�������
;;; <�߂�l>  : ������̃��X�g
;;; <���l>    : Ex.(StrParse " 1,,  2,  3," ",") -> ("1" "2" "3")
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
;;; <�֐���>    : C:SaveQuit
;;; <�����T�v>  : KPCAD�I���R�}���h
;;; <�߂�l>    : �Ȃ�
;;; <���l>      : �}�ʂ�ۑ����āy���f�z����@�����ݸ��ƭ��Ɛ}�ʎQ�Ǝ�
;;;************************************************************************>MOH<
(defun C:SaveQuit (
  /
  )
  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �O����
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  (if (CFYesNoDialog "���݂̃��j���[���I�����܂����H")
  ;(if (CFYesNoDialog "�����Ǘ��ɖ߂�܂����H")
    (progn
      ;// �����ۑ�
      (CFAutoSave)
      ; 01/07/04 YM ADD ���ς��޲�۸ނ�KILL
;;;      (C:arxStartApp (strcat CG_SysPATH "KillMitumo.exe") 0)

      (setvar "PICKFIRST" 1) ;01/08/24 HN ADD �R�}���h�̔��s�O�ɃI�u�W�F�N�g��I��
      (command ".quit")
    )
  )

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �㏈��
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  (princ)
);C:SaveQuit


;;;<HOM>************************************************************************
;;; <�֐���>    : C:SaveQuitFIX
;;; <�����T�v>  : KPCAD�y�m��z�I��
;;; <�߂�l>    : �Ȃ�
;;; <���l>      : �}�ʂ�ۑ����āy�m��z�I������
;;;               �@���ފm�F����ތĂяo��
;;;               �APB�p�t����
;;;               �B�ώZ����UPLOAD
;;;************************************************************************>MOH<
(defun C:SaveQuitFIX (
  /
;-- 2011/10/14 A.Satoh Mod - S
	#end_type
;-- 2011/10/14 A.Satoh Mod - E
  )
  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �O����
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

;-- 2011/10/14 A.Satoh Mod - S
;;;;;  ;�@���ފm�F����ތĂяo��
;;;;;;;; (C:ConfPartsAll)  
;;;;;
;;;;;  (if (CFYesNoDialog "���݂̃��j���[���I�����܂����H")
;;;;;  ;(if (CFYesNoDialog "�����Ǘ��ɖ߂�܂����H")
;;;;;    (progn
;;;;;;-- 2011/10/11 A.Satoh Add - S
;;;;;			(setq #cancel nil)
;;;;;
;;;;;      ; ���݂̔���񓙂�Input.CFG�ɏ�������
;;;;;      (setq #ret (CFOutInputCfg))
;;;;;			(if (= #ret nil)
;;;;;				(setq #cancel T)
;;;;;			)
;;;;;;-- 2011/10/11 A.Satoh Add - E
;;;;;
;;;;;;-- 2011/10/13 A.Satoh Add - S
;;;;;			(if (= #cancel nil)
;;;;;				(if (findfile (strcat CG_SYSPATH "SelectUploadDWG.exe"))
;;;;;					(progn
;;;;;						(C:arxStartApp (strcat CG_SysPATH "SelectUploadDWG.exe") 1)
;;;;;						(setq #planinfo$$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
;;;;;						(if (= #planinfo$$ nil)
;;;;;							(progn
;;;;;								(CFAlertMsg (strcat "PLANINFO.CFG�̓Ǎ��Ɏ��s���܂����B\n" CG_KENMEI_PATH "PLANINFO.CFG"))
;;;;;								(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
;;;;;								(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
;;;;;								(setq #cancel T)
;;;;;							)
;;;;;							(progn
;;;;;								(setq #flag nil)
;;;;;								(foreach #planinfo$ #planinfo$$
;;;;;									(if (= (nth 0 #planinfo$) "[PDF_DXF_TARGET]")
;;;;;										(setq #flag T)
;;;;;									)
;;;;;								)
;;;;;
;;;;;								(if (= #flag nil)
;;;;;									(progn
;;;;;										(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
;;;;;										(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
;;;;;										(setq #cancel T)
;;;;;									)
;;;;;								)
;;;;;							)
;;;;;						)
;;;;;					)
;;;;;					(progn
;;;;;						(CFAlertMsg "UPLOAD�Ώې}�ʑI��Ӽޭ��(SelectUploadDWG.exe)������܂���B")
;;;;;						(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
;;;;;						(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
;;;;;						(setq #cancel T)
;;;;;					)
;;;;;				)
;;;;;			)
;;;;;
;;;;;			(if (= #cancel nil)
;;;;;				(progn
;;;;;;-- 2011/10/13 A.Satoh Add - E
;;;;;
;;;;;      ;// �����ۑ�
;;;;;      (CFAutoSave)
;;;;;      ; 01/07/04 YM ADD ���ς��޲�۸ނ�KILL
;;;;;;;;      (C:arxStartApp (strcat CG_SysPATH "KillMitumo.exe") 0)
;;;;;
;;;;;      (setvar "PICKFIRST" 1) ;01/08/24 HN ADD �R�}���h�̔��s�O�ɃI�u�W�F�N�g��I��
;;;;;      (setvar "GRIPS"1) ;�O���b�v��\��
;;;;;
;;;;;      (command ".quit")
;;;;;;-- 2011/10/13 A.Satoh Add - S
;;;;;				)
;;;;;			)
;;;;;;-- 2011/10/13 A.Satoh Add - E
;;;;;    )
;;;;;  )
	(cond
		((= CG_PROGMODE "PLAN")		; �v�����j���O���j���[
			; ���f�I��/�j���I���I���_�C�A���O����
			(setq #end_type (KPCAD_StopCancelDlg))
			(cond
				((= #end_type 2)	; ���f�I��
					; ���f�I���������s��
					(KPCAD_StopEnd)
				)
				((= #end_type 3)	; �j���I��
					; �j���I���������s��
					(KPCAD_CancelEnd)
				)
			)
;			(if (= #end_type T)
;				; ���f�I���������s��
;				(KPCAD_StopEnd)
;				; �j���I���������s��
;				(KPCAD_CancelEnd)
;			)
		)
		((= CG_PROGMODE "PLOT")		; �o�͊֌W���j���[
			(if (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
				(progn		; �����}��(Model.dwg)
					(setq #end_type (KPCAD_FixEndDlg))
					(cond
						((= #end_type 1)	; �m��I��
							(KPCAD_FixEnd)
						)
						((= #end_type 2)	; ���f�I��
							; ���f�I���������s��
							(KPCAD_StopEnd)
						)
						((= #end_type 3)	; �j���I��
							; �j���I���������s��
							(KPCAD_CancelEnd)
						)
					)
				)
				(progn		; ; �}�ʎQ�Ǝ�
					(setq #end_type (KPCAD_StopCancelDlg))
					(cond
						((= #end_type 2)	; ���f�I��
							; ���f�I���������s��
							(KPCAD_StopEnd)
						)
						((= #end_type 3)	; �j���I��
							; �j���I���������s��
							(KPCAD_CancelEnd)
						)
					)
;					(if (= #end_type T)
;						; ���f�I���������s��
;						(KPCAD_StopEnd)
;						; �j���I���������s��
;						(KPCAD_CancelEnd)
;					)
				)
			)
		)
	)
;-- 2011/10/14 A.Satoh Mod - E

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �㏈��
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  (princ)
);C:SaveQuitFIX

;;;<HOM>************************************************************************
;;; <�֐���>    : C:ChgMenuPlot
;;; <�����T�v>  : ����֘A���j���[�ɐ؂�ւ���
;;; <�߂�l>    : �Ȃ�
;;; <���l>      : ���݂̏�Ԃ�ۑ����Đ؂�ւ���
;;;************************************************************************>MOH<
(defun C:ChgMenuPlot (
  /
  #SS1 #SS2
;-- 2011/09/14 A.Satoh Add - S
  #idx #en$
;-- 2011/09/14 A.Satoh Add - E
	#ename$ #msg  ;-- 2012/01/27 A.Satoh Add
	#DOORINFO #HINBAN #I #QRY_KIHON$$ #SS_LSYM #SYM #TENKAI_TYPE #XD$ ;2012/02/17 YM ADD
	#DEEP_FLG #N #OBUN_FLG #PT$ #PT2$ #QRY$ #SKK #SS #SSWT #TEI #TOKU_KIGO #WT #XDWT$ ;2013/4/5 YM ADD
	#xFlr ;2013/11/20 YM ADD-S �V���̑���
  )

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �O����
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

	;2013/11/20 YM ADD-S �V���̑���
	(setq  CG_EXIST_FILR nil);������
	(setq #xFlr (ssget "X" (list (list -3 (list "G_FILR")))))
	(if (and #xFlr (< 0 (sslength #xFlr)))
		(setq CG_EXIST_FILR T)
	);_if
	;2013/11/20 YM ADD-E �V���̑���

;;;01/09/03YM@MOD  ;// �R�}���h������
;;;01/09/03YM@MOD  (StartCmnErr) --->undoB���Ȃ�

  ;00/07/18 SN MOD ܰ�į�߂������Ă��ƭ��ؑ։Ƃ���B
  ;// ���[�N�g�b�v���i�Ԗ��m��Ȃ玩���m�肷��
  ;(setq #ss1 (ssget "X" '((-3 ("G_WRKT")))))
  ;(setq #ss2 (ssget "X" '((-3 ("G_LSYM")))))
  ;(if (or (= #ss1 nil) (= (sslength #ss1) 0))
  ;  (if (= (sslength #ss2) 1) ; LSYM�P����
  ;    (princ)
  ;    (progn
  ;      (CFAlertErr "���[�N�g�b�v���z�u����Ă��܂���")
  ;      (quit)
  ;    )
  ;  );_if
  ;);_if

  ;// ���[�N�g�b�v���i�Ԗ��m��Ȃ玩���m�肷��
;-- 2011/09/14 A.Satoh Mod - S
;  (PKAutoHinbanKakutei)
  (if (= (PKAutoHinbanKakutei) nil)
    (progn
      (CFAlertErr "�i�Ԗ��m���ܰ�į�߂����݂��܂�")
      (quit)
    )
  )
;-- 2011/09/14 A.Satoh Mod - E

;-- 2011/09/13 A.Satoh Add - S
  (if (= (PKAutoTokuTenban) nil)
    (progn
      (CFAlertErr "�K�i�i�Ƃ��ĕi�Ԋm�肳��Ă������ܰ�į�߂����݂��܂�")
      (quit)
    )
  )
;-- 2011/09/13 A.Satoh Add - E

;-- 2011/09/14 A.Satoh Add - S
  (setq #ss1 (ssget "X" '((-4 . "<OR") (-3 ("G_LSYM")) (-3 ("G_FILR")) (-4 . "OR>"))))
  (if #ss1
    (progn
      (setq #en$ nil)
      (setq #idx 0)
      (repeat (sslength #ss1)
        (if (CFGetXData (ssname #ss1 #idx) "G_ERR")
          (setq #en$ (append #en$ (list (ssname #ss1 #idx))))
        )
        (setq #idx (1+ #idx))
      )

      (if (/= #en$ nil)
        (progn
          (command "_undo" "m")
          (setq #idx 0)
          (repeat (length #en$)
            (GroupInSolidChgCol2 (nth #idx #en$) CG_InfoSymCol)
            (setq #idx (1+ #idx))
          )
          (CFAlertErr "�}�ʏ�ɋ֑��װ���ނ����݂��܂�")
          (command "_undo" "b")
          (quit)
        )
      )
    )
  )
;-- 2011/09/14 A.Satoh Add - E

;-- 2012/01/27 A.Satoh Add - S
	(setq #ename$ (KPCAD_CheckErrBuzai))
	(if #ename$
		(progn
			(setq #idx 0)
			(repeat (length #ename$)
				(GroupInSolidChgCol2 (nth #idx #ename$) CG_InfoSymCol)
				(setq #idx (1+ #idx))
			)
			(setq #msg (strcat "�}�ʏ�ɕs���ȕ��ނ����݂��܂��B"
												"\n�Ώۂ̕��ނ��폜�̏�A������x�쐬�������ĉ������B"
												"\n�s�����ނ̔z�u�ɂ�����ڍׂȎ菇���u���V�X�e�����v�ɂ��񍐉������B"))
			(CFAlertErr #msg)
			(quit)
		)
	)
;-- 2012/01/27 A.Satoh Add - E




;-- 2013/04/05 YM-S
  (setq #ssWT (ssget "X" '((-3 ("G_WRKT")))))
	(if (and #ssWT (<= 1 (sslength #ssWT)))
		(progn
			(setq #n 0)
			(repeat (sslength #ssWT)
				(setq #WT (ssname #ssWT #n))
  			(setq #xdWT$ (CFGetXData #WT "G_WRKT"))
			  (setq #tei (nth 38 #xdWT$))        ; WT��ʐ}�`�����
			  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��
			  (setq #pt2$ (append #pt$ (list (car #pt$)))) ; �I�_�̎��Ɏn�_��ǉ����ė̈���͂�

			  (setq #magu (nth 55 #xdWT$))      ; WT�Ԍ�
			  (setq #mag1 (nth 0 #magu))        ; WT�Ԍ�1
			  (setq #mag2 (nth 1 #magu))        ; WT�Ԍ�2

			  (command "_view" "S" "TEMP_HANTEI")
				(command "vpoint" "0,0,1")
			  ;// �̈�Ɋ܂܂��G_LSYM����������
			  (setq #ss (ssget "CP" #pt2$ (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
			  (command "_view" "R" "TEMP_HANTEI")

			  (setq #i 0)
				(setq #OBUN_FLG nil)
				(setq #DEEP_FLG nil)

			  (if (and #ss (> (sslength #ss) 0))
			    (progn
	          (repeat (sslength #ss)
	            (setq #sym (ssname #ss #i)) ; �̈���̊e�����
	            (setq #xd$ (CFGetXData #sym "G_LSYM"))
							;�i��
							(setq #hinban (nth 5 #xd$))
							;���i����
							(setq #SKK (nth 9 #xd$))

							;;;�E�I�[�u���̔���
							;;;�@���i�R�[�h�P�P�R ���� �����I�[�u���ɑ��݂����ꍇ
							(if (equal #SKK 113 0.001)
								(progn
									;[����OBUN]
								  (setq #qry$
								    (CFGetDBSQLRec CG_DBSESSION "����OBUN"
								      (list
								        (list "�i�Ԗ���" #hinban 'STR)
								      )
								    )
								  )
								  (if #qry$
										(setq #OBUN_FLG T)
									);_if
								)
							);_if

							;;;�E�f�B�[�v�H��̔���
							;;;�@���i�R�[�h�P�P�O ���� �i�Ԋ�{�̓����Ώۂ�"X"�łȂ��ꍇ
							(if (equal #SKK 110 0.001)
								(progn
									;[����OBUN]
								  (setq #qry$
								    (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
								      (list
								        (list "�i�Ԗ���" #hinban 'STR)
								      )
								    )
								  )
								  (if (and #qry$ (= 1 (length #qry$)))
										(progn
											(setq #TOKU_KIGO (nth 10 (car #qry$))) ;�����Ώ�
											(if (/= "X" #TOKU_KIGO)
												(setq #DEEP_FLG T)
											);_if
										)
									);_if
								)
							);_if

	            (setq #i (1+ #i))
	          );(repeat
			    )
			  );_if

				(setq #n (1+ #n))
			)
		)
	);_if

	(if (and #DEEP_FLG #OBUN_FLG)
		(progn
			(if (CFYesNoDialog "\n�I�[�u�������W�ƃf�B�[�v�H��@�͗אڂł��܂���B�z�u���m�F���ĉ������B\n�o�͊֌W�ƭ��Ɉڍs���܂����H")
				;�u�p���v�Ɓu�߂�v
				(progn ;Yes
					nil
				)
				(progn ;No
					(quit)
				)
			);_if
		)
	);_if



;-- 2013/04/05 YM-E



	;2012/02/17 YM ADD-S
	(setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss_LSYM (< 0 (sslength #ss_LSYM)))
    (progn
			(setq #i 0)
			(repeat (sslength #ss_LSYM)
				(setq #sym (ssname #ss_LSYM #i))
				;�y�i�Ԋ�{�z�W�J�^�C�v=0�̂Ƃ�G_LSYM����񂪂Ȃ���ξ�Ă���(CG�Ή��̂���)
				(setq #xd$ (CFGetXData #sym "G_LSYM"))

	      (setq #DoorInfo (nth 7 #xd$)) ; "��ذ��,��װ�L��"
	      (if (or (= nil #DoorInfo)(= #DoorInfo ""))
					(progn
						(setq #hinban (nth 5 #xd$));�i�Ԗ���
						;�W�J���ߎ擾
		        (setq #Qry_kihon$$
		          (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
		            (list (list "�i�Ԗ���"  #hinban 'STR))
		          )
		        )
						(if (and #Qry_kihon$$ (= 1 (length #Qry_kihon$$)))
							(progn
								(setq #tenkai_type (nth 4 (car #Qry_kihon$$)));�W�J����
								(if (equal #tenkai_type 0.0 0.001);�W�J����=0
									(progn ;�����X�V
		                (CFSetXData #sym "G_LSYM"
		                  (CFModList #xd$
		                    (list
		                      (list 7 (strcat CG_DRSeriCode "," CG_DRColCode "," CG_HIKITE))
		                    )
		                  )
		                )
									)
								);_if
							)
						);_if
					)
				);_if

				;2014/04/23 YM ADD-S
				;G_LSYM�̉�]�p�x�𐳋K��
				;(Angle0to360 6.2831999)

				;2016/02/09 YM ADD-S ���CFMOD���čX�V�������e�������Ă��܂��̂�#xd$����蒼��
				(setq #xd$ (CFGetXData #sym "G_LSYM"))
				;2016/02/09 YM ADD-E

				(setq #SetAng (nth 2 #xd$)) ;�z�u�p�x
				(setq #SetAng (Angle0to360 #SetAng));�z�u�p�x�𐳋K��
        (CFSetXData #sym "G_LSYM"
          (CFModList #xd$
            (list
              (list 2 #SetAng)
            )
          )
        )
				;2014/04/23 YM ADD-E

				(setq #i (1+ #i))
			);repeart

		)
	);_if
	;2012/02/17 YM ADD-E


	;2012/08/24 YM MOV-S
	; �}�ʂ̕������̏������� input.cfg�����Ęg������������������
	(if (= 0 CG_SYUTURYOKU_MENU)
		(progn ;�܂���x�����������Ă��Ȃ�

(princ "\n�@�������@(KP_BukkenInfoRewrite)���s�O�@������")
;;;			(KP_BukkenInfoRewrite) ;OEM�œ����Ȃ� 2016/10/18 YM MOD
(Command "BukkenInfoRewrite")  ;OEM�œ����Ȃ� 2016/10/18 YM MOD
(princ "\n�@�������@(KP_BukkenInfoRewrite)���s��@������")
			;�������̏��������L�^
			(setq CG_SYUTURYOKU_MENU (1+ CG_SYUTURYOKU_MENU));�������������"1"�ɂȂ�
		)
	);_if
	;2012/08/24 YM MOV-E


  ;// �����ۑ�
  (CFAutoSave)

  ;00/08/01 SN ADD �ذ�����޲�۸ނ̏I��
  (C:arxStartApp (strcat CG_SysPATH "KillPlan.exe") 2)

  ;01/05/10 YM ADD �����\��ð��ق̍X�V
;;;  (C:arxStartApp (strcat CG_SysPATH "MDBupd.exe") 0) ;2017/07/18 YM DEL �g���Ă��Ȃ�

	(princ)
	
	;2017/07/18 YM ADD
;;;	(command "delay" "2000");1�b�҂�

	; 2017/06/13 KY ADD-S
	; �t���[���L�b�`���Ή�
	; "Hosoku.cfg"�ɋ�����o��(�t���[�����Z�o)

	(if (= BU_CODE_0012 "1")
		(progn
			(if (CFYesNoDialog "\n����̎����ώZ���s���܂����H")
				(OutputKanaguInfo)
				;esle
				(princ)
			);_if
		)
	);if

	; 2017/06/13 KY ADD-E

  ;// ���j���[�̐؂�ւ�
  (setq CG_PROGMODE "PLOT")
  (ChgSystemCADMenu CG_PROGMODE)

  ;// ��֘A�̉�w��\������
  (CFDispYashiLayer)

  ; 01/09/07 YM MOD-S ����Ӱ�ނł͕\�����Ȃ�
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
    nil
    (CFYesDialog "�o�͊֌W���j���[�ɐ؂�ւ��܂���")
  );_if
  ; 01/09/07 YM MOD-E ����Ӱ�ނł͕\�����Ȃ�

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �㏈��
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  (princ)
)
;;;C:ChgMenuPlot

;;;<HOM>************************************************************************
;;; <�֐���>  : C:ChgMenuPlan
;;; <�����T�v>: �v�����j���O���j���[�ɐ؂�ւ���
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : ���݂̏�Ԃ�ۑ����Đ؂�ւ���
;;;************************************************************************>MOH<
(defun C:ChgMenuPlan (
  /
  )
  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �O����
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (StartUndoErr)
  );_if
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  ;// �����ۑ�
  ; 01/09/07 YM MOD-S ����Ӱ�ނł͕ۑ����Ȃ�
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
    nil
    (progn
      (CFAutoSave)
      ; 01/07/03 YM ADD ���ς��޲�۸ނ�KILL
;;;      (C:arxStartApp (strcat CG_SysPATH "KillMitumo.exe") 0)
    )
  );_if
  ; 01/09/07 YM MOD-E ����Ӱ�ނł͕ۑ����Ȃ�

;;;01/09/07YM@MOD  (CFAutoSave)

  ; 01/07/03 YM ADD ���ς��޲�۸ނ�KILL
;;;01/09/07YM@MOD  (C:arxStartApp (strcat CG_SysPATH "KillMitumo.exe") 0)

  ;// ���j���[�̐؂�ւ�
  (setq CG_PROGMODE "PLAN")
  (ChgSystemCADMenu CG_PROGMODE)
  (setvar "GRIPS" 0)

  ;// ��֘A�̉�w���\���ɂ���
  (CFHideYashiLayer)

  ; 01/09/07 YM MOD-S ����Ӱ�ނł͕\�����Ȃ�
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
    nil
    (CFYesDialog "�v�����j���O���j���[�ɐ؂�ւ��܂���")
  );_if
  ; 01/09/07 YM MOD-E ����Ӱ�ނł͕\�����Ȃ�

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �㏈��
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (setq *error* nil)
  );_if
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  (princ)
)
;;;C:ChgMenuPlan

;;;<HOM>************************************************************************
;;; <�֐���>  : C:Quit
;;; <�����T�v>: �{�V�X�e�����I������
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ� �g�p���Ă���?
;;;************************************************************************>MOH<
(defun C:Quit (
  /
  )

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �O����
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  (if (CFYesNoDialog "�����Ǘ��ɖ߂�܂����H")
    (progn
      ;// �����ۑ�
      (CFAutoSave)
      (setvar "PICKFIRST" 1) ;01/08/24 HN ADD �R�}���h�̔��s�O�ɃI�u�W�F�N�g��I��
      (command ".quit")
    )
  )

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �㏈��
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  (princ)
)
;;;C:Quit

(setq C:_Quit C:Quit)

;<HOM>*************************************************************************
; <�֐���>    : WebOutLog
; <�����T�v>  : ۸�̧�قɏ������e���o�͂���(WEB��)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/09/04 YM
; <���l>      : ������۸ނ��o�͂��A�ǂ��ňُ�I�����������������Ɏg�p����
;               WEB��CAD���ް�̂Ƃ��ɂ̂�۸ޏo�͂���
;*************************************************************************>MOH<
(defun WebOutLog (
  &msg ; ������,���l,ؽ�,nil ��
  /
  #F
  )
  ;04/01/04 YM CG_AUTOMODE=4 ��ǉ�
  (if (and CG_LOGFILE (or (= CG_AUTOMODE 2)(= CG_AUTOMODE 4))); WEB�Ż��ްӰ��
    (progn
      ; ۸ނ��߽���ʂ��ĂȂ��Ƃ��͌x���\�������Ă��p�����s����
      (setq #f (open CG_LOGFILE "a"))
      (if #f
        ; ۸ނ��߽���ʂ��Ă���
        (progn
          (if (= 'LIST (type &msg))
            (foreach elm &msg
              (princ "\n" #f)
              (princ elm  #f)
            )
          ; else
            (progn
              (princ "\n" #f)
              (princ &msg #f)
            )
          );_if
          (close #f)
        );_if
        (progn
          (princ (strcat "۸�̧�ق��߽���ʂ��ĂȂ����߁A۸ނ��o�͂ł��܂���B(ini̧�ق����m�F������)"
                              "\n���s����͂Ȃ��̂ŏ������p�����܂��B"))
        )
      );_if
    )
  );_if
  (princ)
);WebOutLog

;<HOM>*************************************************************************
; <�֐���>    : SKAutoError
; <�����T�v>  : �����װ�֐� WEB��CAD���ް�p
;               02/09/06 YM ADD INIT.LSP�݂̂���LOAD���Ă��Ȃ��̂�
;               DBDisConnect�Ȃǂ̊֐����g���Ȃ���(SKAutoError2)�͎g���Ȃ�
;*************************************************************************>MOH<
(defun SKAutoError ( msg / #msg )
  (princ "\n�������C�A�E�g���������f����܂���.")
  ;// �G���[���O�o�͗p������ɒǉ�����
  (if (/= msg CG_ERRMSG)
    (setq CG_ERRMSG (append CG_ERRMSG (list msg)))
  );_if

  ; �װ۸ނɏ�������
  (CFOutErrLog)
  (setq CG_DBSESSION nil)
  (setq CG_CDBSESSION nil)

;;;  (startapp (strcat CG_SYSPATH "WARN.EXE"))
;;;  (if (= CG_AUTOFLAG "1")
    (command "_quit" "y")
;;;  )
  (princ)
);SKAutoError

;<HOM>*************************************************************************
; <�֐���>    : CFOutErrLog
; <�����T�v>  : �G���[�̓��e���G���[���O�t�@�C���ɏ����o��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-06-16
; <���l>      : �{��۸��т͑S�Ď��ȏ����̂��߁A�ُ�I�������Ƃ��̌��������p�ɁA
;               �e������۸ނ�̧�قɂ܂Ƃ߂܂��B
;               ���� msg �̌`���� princ �ŏo�͂����`���ł悢
; 02/09/05 YM ADD WEB�Ő�p
;*************************************************************************>MOH<
(defun CFOutErrLog (
    /
    #f #msg
  )
  (if (and CG_ERRFILE (= CG_AUTOMODE 2)); WEB�Ż��ްӰ��
    (progn
      (setq #f (open CG_ERRFILE "w")) ; �㏑��Ӱ�ނɕύX 02/09/06 YM ADD

      (if #f   
        (progn ; ۸ނ��߽���ʂ��Ă���

;;;         (if CG_SETPLAN_NO ; �������NO
;;;           (progn
;;;             (princ "�������NO: " #f)
;;;             (princ CG_SETPLAN_NO #f)
;;;             (princ "\n" #f)
;;;             (princ "\n  error:\n" #f)
;;;           )
;;;           (progn ; 02/09/10 YM ADD
;;;             (princ "�������NO������܂���" #f)
;;;           )
;;;         );_if
          (foreach #msg CG_ERRMSG
            (princ "    " #f)
            (princ #msg #f)
            (princ "\n" #f)
          )
          (close #f)
        )
        (progn
          (princ (strcat "۸�̧�ق��߽���ʂ��ĂȂ����߁A۸ނ��o�͂ł��܂���B(ini̧�ق����m�F������)"
                        "\n���s����͂Ȃ��̂ŏ������p�����܂��B"))
        )
      );_if
    )
  );_if
  (princ)
);CFOutErrLog

(princ)
