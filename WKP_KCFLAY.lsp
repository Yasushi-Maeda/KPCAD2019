(setq CG_FigureScale 34.0)
(setq CG_LayTitleH 2)        ; �}�ʘg�\��ړx�P�̎��̕���������2
(setq CG_LayTitleTag "T^")   ; �}�ʘg�\��̃^�O
;;;(setq CG_DWG_VERSION "2007") ; DWG�ۑ����̃o�[�W���� 2008/09/24 YM MOD
(setq CG_DWG_VERSION "2000") ; DWG�ۑ����̃o�[�W���� 2008/09/24 YM MOD
;-- 2011/10/21 A.Satoh Mod - S
;;;;;(setq CG_DXF_VERSION "R12")  ; DWG�ۑ����̃o�[�W����
(setq CG_DXF_VERSION "2000")  ; DWG�ۑ����̃o�[�W����
;-- 2011/10/21 A.Satoh Mod - S

(setq CG_OUTAUPREC 5)        ; �p�x�̐��x


; �{�H�}�̉�w
  ; �}�ʎ�� �{�H�}�̉�w    03 : ���z���n�} 04 : �ݔ��z�ǐ}
  ; �}�ʎ�� ���i�}�̉�w    02 : ���i�}
  (setq CG_OUTSHOHINZU "02")
  (setq CG_OUTSEKOUZU  "04")

;�}�ʕۑ��t�@�C���^�C�v
(setq CG_SAVE_OUTPUT_FILE_TYPE "DXF")



;;;<HOM>************************************************************************
;;; <�֐���>  : PersHantei
;;; <�����T�v>: ��������ڰĊ܂ނ�����
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun PersHantei (
	&Pat$
  /
	#DUM_STR
  )
	(setq CG_PERS nil)
  (foreach #Pat &Pat$
    (setq #dum_STR (car #Pat))
      (if (vl-string-search "����" #dum_STR)
        (setq CG_PERS T)
      );_if
  );foreach
	(princ)
);PersHantei


;;;<HOM>************************************************************************
;;; <�֐���>  : C:SCFLayout
;;; <�����T�v>: �}�ʃ��C�A�E�g
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun C:SCFLayout (
  /
  #iOk #Txt$ #PatRet$ #Pat$ #sNo #iAuto #sType #DIM$ #STMP
  #dimpat$  ; ((�L���r�l�b�g���@ �{�H���@ �����E���E�E �c��) (�p�^�[�� �p�^�[���E�E�E))
#TAIMEN ; 04/04/13 YM ADD
#ver #sFname2 ;-- 2011/10/06 A.Satoh Add
#VER$$ #Input$	;-- 2011/10/21 A.Satoh Add
  )

  (WebOutLog "�װ�֐� SKAutoError2 ���`���܂�(C:SCFLayout)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  ; 02/09/03 YM MOD �װ�֐���`
  (cond
    ((= CG_AUTOMODE 1)
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError1)
      );_if
    )
    ((member CG_AUTOMODE '(2 4 5))
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError2)
      );_if
    )
    ((= CG_AUTOMODE 3)
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError1)
      );_if
    )
  );_cond
  ; 02/09/03 YM MOD �װ�֐��̕���g������ �����ōĒ�`���Ȃ��Ƃ����Ȃ�

  ; 02/01/19 HN E-ADD �p�[�X�}�̃J�������_���V���N�L���r�l�b�g�̔z�u�p�x�Ŕ��f
  (setq CG_AngSinkCab (SCFGetAngSinkCab))

  (SCFStartShori "SCFLayout")
  ; �O����
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (StartUndoErr)
  );_if
;-- 2011/10/05 A.Satoh Add - S
  (setq CG_OSMODE_BAK (getvar "OSMODE"))
  (setq CG_SNAPMODE_BAK (getvar "SNAPMODE"))
  (setq CG_ORTHOMODE_BAK (getvar "ORTHOMODE"))
  (setq CG_GRIDMODE_BAK (getvar "GRIDMODE"))
;-- 2011/10/05 A.Satoh Add - E
;-- 2012/03/27 A.Satoh Add - S
	(setq CG_PlanType nil)
;-- 2012/03/27 A.Satoh Add - E

;;;(WebOutLog "(1)�װ�֐�="); 02/09/04 YM ADD ۸ޏo�͒ǉ�
;;;(WebOutLog *error*); 02/09/04 YM ADD ۸ޏo�͒ǉ�
;;;(makeERR "ڲ���1") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ڲ���1


  (if (/= nil CG_KENMEI_PATH)
    (progn

;;;(makeERR "ڲ���2") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ڲ���2

      (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
        nil
        (progn
          ;�ۑ��m�F
          (setq #iOk (CFYesNoDialog "�}�ʂ���x�ۑ����܂����H"))
          (if (= T #iOK)
            (progn
;-- 2011/10/06 A.Satoh Add - S
;;;;;              (command "_.QSAVE")
              (setq #sFname2 (strcat (getvar "dwgprefix") (getvar "dwgname")))
              (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
                      (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
                (setq #ver CG_DWG_VER_MODEL)
                (setq #ver CG_DWG_VER_SEKOU)
              )
              (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/06 A.Satoh Add - E
            )
          );_if
        )
      );_if
      ; 01/09/07 YM MOD-E ����Ӱ�ނł͕ۑ��m�F���Ȃ�

      (setq CG_DwgName (findfile (strcat CG_KENMEI_PATH (getvar "DWGNAME"))))
      ;�o�̓p�^�[���w��_�C�A���O
      (setq #Txt$     (SKOutPatReadScv (strcat CG_SKPATH "outpat.cfg")))
      (if (/= nil #Txt$)
        (progn
          (if (member CG_AUTOMODE (list 1 2 3 4 5))
            (progn
              (if (member CG_AUTOMODE (list 4 5));JPG�o��Ӱ��;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
                (progn
                  (setq #PatRet$ CG_AUTOMODE_TEMPLT_JPG) ; JPG�p
                )
                ;else
                (progn
                  (setq #PatRet$ CG_AUTOMODE_TEMPLT)
                )
              );_if
            )
            ;else
            (setq #PatRet$ (SCFGetPatDlg #Txt$))
          );_if
          ; 01/09/07 YM MOD-E ����Ӱ�ނł��޲�۸ޕ\�����Ȃ�

          (if (/= nil #PatRet$)
            (progn
              (setq #Pat$     (nth 0 #PatRet$))   ;�p�^�[�����X�g
              (setq #sNo      (nth 1 #PatRet$))   ;�̈�NO
              (setq #iAuto    (nth 2 #PatRet$))   ;AUTO�t���O

							;2017/09/15 YM ADD-S
;;;							(PersHantei #Pat$) ; ��������ڰĊ܂ނ�����  ;�p�[�X���肵�Ȃ� 2017/09/21 YM MOD

              ;�L�b�`���^�C�v�l��
              (setq #sType    (SKGetKichenType #sNo)) ;�ڰѷ��݂̏ꍇ�p�[�X�}��L/R�����[�U�[�ɕ����Ă���
;;;							(setq CG_PERS nil);��۰��ٕϐ��ر
							;2017/09/15 YM ADD-E

              (if (/= nil #sType)
                (progn
                  ;����(STANDARD)�̂Ƃ��̐}�ʎ�ޑI���_�C�A���O
                  (if (= 0 #iAuto)
                    (progn  ;���͏�� #iAuto=1 �Ȃ̂ł����͒ʂ�Ȃ�
                      ; �ꊇ ���ʐ} �W�J�} �d�l�}��I������
                      ; STAMDARD�̎�
                      (setq #Pat$ (SCFGetPatDlgAuto #Pat$ #sType))
                      (setq CG_TMPPATH CG_TMPAPATH)
                    )
                    (progn
                      (setq CG_TMPPATH CG_TMPHPATH)
                    )
                  );_if

                  (if (/= nil #Pat$)
                    (progn
                      ; ���@�쐬����_�C�A���O��\������
                      ; 2000/07/04 HT MOD ���i�} �{�H�}�I�����s���悤�ɕύX
                  ; �A���ASTANDARD���I������Ă��鎞�͑I���Ȃ�
                      ; (setq #dim$ (SCFGetOutDimAuto))

;2011/07/22 YM MOD-S ���@�쐬����_�C�A���O��\�����Ȃ�
;;;                     ; 01/09/07 YM MOD-S ����Ӱ�ނł��޲�۸ޕ\�����Ȃ�;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
;;;                     (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
;;;                       (setq #dimpat$ CG_AUTOMODE_DIMMK);(setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "02") )))
;;;                       ;else
;;;                       (setq #dimpat$ (SCFGetOutDimAuto #Pat$ #iAuto))  ; #dimpat$ = (#dim$ #Pat$)
;;;                     );_if
;;;                     ; 01/09/07 YM MOD-E ����Ӱ�ނł��޲�۸ޕ\�����Ȃ�

                      ;#Pat$����#dimpat$�����
                      ;(setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "02") )))
                      (setq #dum$ nil)
                      (setq #dum$$ nil)
                      (foreach #Pat #Pat$
                        (setq #dum_STR (car #Pat))
                        (cond
                          ((vl-string-search "02" #dum_STR)
                            (setq #dum$ (list #dum_STR "02"))
                          )
                          ((vl-string-search "04" #dum_STR)
                            (setq #dum$ (list #dum_STR "04"))
                          )
                          ((vl-string-search "����" #dum_STR)
                            (setq #dum$ (list #dum_STR "00"))
                          )
                          (T
                            (setq #dum$ (list #dum_STR "02"))
                          )
                        );_cond
                        (setq #dum$$ (append #dum$$ (list #dum$)))
                      );foreach

                      (setq #dimpat$ 
                        (list
                          (list "1" "1" "A" "Y")
                          #dum$$
                        )
                      )

;2011/07/22 YM MOD-S ���@�쐬����_�C�A���O��\�����Ȃ�

                      ;"����","�d�l"�̕����񂪂��邩�ǂ����Ŕ��肷��
;;;2011/07/22YM@DEL                     (if (/= 0 #iAuto)
;;;2011/07/22YM@DEL                       (progn
;;;2011/07/22YM@DEL                         (setq #dum_STR (car (car (cadr #dimpat$))))
;;;2011/07/22YM@DEL                         (if (or (vl-string-search "����" #dum_STR)
;;;2011/07/22YM@DEL                                 (vl-string-search "�d�l" #dum_STR))
;;;2011/07/22YM@DEL                           (progn
;;;2011/07/22YM@DEL                             (setq #car  (list "0" "0" "A" "Y"))
;;;2011/07/22YM@DEL                             (setq #cadr (list (list #dum_STR "02")))
;;;2011/07/22YM@DEL                             (setq #dimpat$ (list #car #cadr))
;;;2011/07/22YM@DEL                           )
;;;2011/07/22YM@DEL                         );_if
;;;2011/07/22YM@DEL                       )
;;;2011/07/22YM@DEL                     );_if
                      ; �߰�or�d�l�\�̂�����ڰĂ̏ꍇ#dimpat$���C�����i�}�̂ݍ�} 01/05/10 YM END ----------

                      (if (/= 0 #iAuto)
                        (progn
                        ; STANDARD���I������Ă��Ȃ��Ƃ�
                          (setq #Pat$ (cadr #dimpat$))
                        )
                      )
                      (setq #dim$ (car #dimpat$))
                      (if (/= nil #dim$)
                        (progn

                          ;00/08/22 SN S-ADD
                          ;XRecord"SERI"�̏����O���ϐ��ɏo��

                          ;2008/08/13 YM DEL XRECORD������߂ĸ�۰��ٕϐ���Ă͕s�v
;;;                          (SCFSetXRecGbl)

                          ;�p�^�[�����X�g�W
                          ; �e���v���[�g�t�@�C�������X�g
                          (setq CG_Pattern (SCFEditPattarn #Pat$))
                          ; �e���v���[�g�t�@�C�������X�g�̗v�f�ԍ�
                          (setq CG_PatNo 0)
                          ; �̈�No
                          (setq CG_RyoNo #sNo)
                          ; �L�b�`���^�C�v ex) I-RIGHT�Ȃ�
                          (setq CG_KitType #sType)
                          ; �}�ʘg�\��
                          (if (= CG_AUTOMODE 2);CAD���ް
                            (progn
                              (setq CG_TitleStr (SCFGetTitleStr))
                            )
                            ;else KPCAD
;-- 2011/10/21 A.Satoh Mod - S
;;;;;                            (setq CG_TitleStr 
;;;;;                              (list
;;;;;                                "���������́�"
;;;;;                                "���v�����ԍ���"
;;;;;                                "���v�������́�"
;;;;;                                "���ǔԁ�"
;;;;;                                "���c�Ə�����"
;;;;;                                "���c�ƒS����"
;;;;;                                "�����ϒS����"
;;;;;                                "���o�[�W������"
;;;;;                                ""                                                    ; �v������
;;;;;                                ""                                                    ; �����R�[�h
;;;;;                                ""                                                    ; �戵�X��
;;;;;                                ""                                                    ; �}�ʓ��L����
;;;;;                                ""                                                    ; �n��
;;;;;                                ""                                                    ; ��
;;;;;                                ""                                                    ; ���[�N�g�b�v
;;;;;                                ""                                                    ; ���[�N�g�b�v2(�����)
;;;;;                                ""                                                    ; �V�X�e����    ���g�p
;;;;;                                ""                                                    ; ��Ж�        ���g�p
;;;;;                              )
;;;;;                            )
														(progn
															(setq #VER$$ (ReadIniFile (strcat CG_SYSPATH  "Version.ini")))
															(setq #Input$$ (ReadIniFile (strcat CG_SYSPATH  "Input.cfg")))
	                            (setq CG_TitleStr 
  	                            (list
    	                            (cadr (assoc "ART_NAME"             #Input$$))	; ���������́�
      	                          (cadr (assoc "PLANNING_NO"          #Input$$))	; ���v�����ԍ���
        	                        (cadr (assoc "PLAN_NAME"            #Input$$))	; ���v�������́�
          	                      (cadr (assoc "VERSION_NO"           #Input$$))	; ���ǔԁ�
            	                    (cadr (assoc "BASE_BRANCH_NAME"     #Input$$))	; ���c�Ə�����
              	                  (cadr (assoc "BASE_CHARGE_NAME"     #Input$$))	; ���c�ƒS����
                	                (cadr (assoc "ADDITION_CHARGE_NAME" #Input$$))	; �����ϒS����
                  	              (cadr (assoc "VERNO"                #VER$$))		; ���o�[�W������
                    	            ""                                                    ; �v������
                      	          ""                                                    ; �����R�[�h
                        	        ""                                                    ; �戵�X��
                          	      ""                                                    ; �}�ʓ��L����
                            	    ""                                                    ; �n��
                              	  ""                                                    ; ��
                                	""                                                    ; ���[�N�g�b�v
	                                ""                                                    ; ���[�N�g�b�v2(�����)
  	                              ""                                                    ; �V�X�e����    ���g�p
    	                            ""                                                    ; ��Ж�        ���g�p
      	                        )
        	                    )
														)
;-- 2011/10/21 A.Satoh Mod - E
                          );_if

                          ; (�L���r�l�b�g���@ �{�H���@ �����E���E�E �c��)
                          ;  �L���r�l�b�g���@ ON : "1"    OFF : "0"
                          ;  �{�H���@         ON : "1"    OFF : "0"
                          ;  ���� : A  �� : L  �E : R
                          ;  �c : T  �� : Y
                          (setq CG_DimPat #dim$)

                          ;�e���v���[�g���ɐ}�ʍ�}
                          (if (nth CG_PatNo CG_Pattern)
                            (progn
                              (setq #sTmp  (car  (nth CG_PatNo CG_Pattern)))   ;�e���v���[�g�t�@�C����
                              ;;(if (findfile (strcat CG_TMPPATH #sTmp ".dwt"))
                                ;;(progn
                                  ; �}�ʃ��C�A�E�g���[�h�ŃI�[�v������
                                  ; �I�[�v����ɁA(SCFLayoutDrawBefore)���Ă΂��

                                  (WebOutLog "�����Ӱ��=4 �ōĵ���݂��܂�(C:SCFLayout)")  ; 02/09/04 YM ADD ۸ޏo�͒ǉ�
                                  (WebOutLog "����݌��(SCFLayoutDrawBefore)�����s���܂�"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
                                  (setq CG_OpenMode 4)

                                  ; 01/09/07 YM MOD-S ����Ӱ�ނł�SCFCmnFileOpen�������Ȃ�;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
;;;                                 (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"�ǉ� 03/02/22 JPGڲ���Ӱ��
                                  (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
                                    (progn
;;;                                     (command ".qsave");2008/08/09 YM MOD qsave==>saveas
;-- 2011/10/06 A.Satoh Mod - S
;;;;;                                      (command "_SAVEAS" CG_DWG_VERSION CG_DwgName);2008/08/09 YM MOD
                                      (command "_SAVEAS" CG_DWG_VER_MODEL CG_DwgName);2008/08/09 YM MOD
;-- 2011/10/06 A.Satoh Mod - E
                                      (command "_.Open" (strcat CG_TMPPATH #sTmp ".dwt"))
                                      (S::STARTUP)
                                    )
                                    ; 2000/10/19 HT �֐���
                                    (SCFCmnFileOpen (strcat CG_TMPPATH #sTmp ".dwt") 0)
                                  );_if
                                  ; 01/09/07 YM MOD-E ����Ӱ�ނł�SCFCmnFileOpen�������Ȃ�

                            )
                            (CFAlertMsg "�p�^�[�������͂���Ă��܂���")
                          )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
    (progn
      (CFAlertMsg "�������Ăяo����Ă��܂���.")
    )
  )
  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �㏈��
;-- 2012/03/27 A.Satoh Add - S
	(setq CG_PlanType nil)
;-- 2012/03/27 A.Satoh Add - E
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (setq *error* nil)
  );_if
  ; 01/09/03 YM ADD-E UNDO�����ǉ�
;;;(makeERR "ڲ���6") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ڲ���6
;;;(WebOutLog "(2)�װ�֐�="); 02/09/04 YM ADD ۸ޏo�͒ǉ�
;;;(WebOutLog *error*); 02/09/04 YM ADD ۸ޏo�͒ǉ�

  (princ)
) ; C:SCFLayout


;;;<HOM>************************************************************************
;;; <�֐���>  : SCFSetXRecGbl
;;; <�����T�v>: XRecord"SERI"�̏����O���ϐ��ɏo��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : 2000/10/10 HT �֐���
;;;************************************************************************>MOH<
(defun SCFSetXRecGbl (
  /
  #serix$
  )

  (setq #serix$ (CFGetXRecord "SERI"))
  (if (> (length #serix$)  0) (setq CG_DBNAME      (nth  0 #serix$)) (setq CG_DBNAME     "") ); 1.DB����
  (if (> (length #serix$)  1) (setq CG_SeriesCode  (nth  1 #serix$)) (setq CG_SeriesCode "") ); 2.SERIES�L��
  (if (> (length #serix$)  2) (setq CG_BrandCode   (nth  2 #serix$)) (setq CG_BrandCode  "") ); 3.�u�����h�L��
  (if (> (length #serix$)  3) (setq CG_DRSeriCode  (nth  3 #serix$)) (setq CG_DRSeriCode "") ); 4.��SERIES�L��
  (if (> (length #serix$)  4) (setq CG_DRColCode   (nth  4 #serix$)) (setq CG_DRColCode  "") ); 5.��COLOR�L��
  (if (> (length #serix$)  5) (setq CG_UpCabHeight (nth  5 #serix$)) (setq CG_UpCabHeight 0) ); 6.��t����
  (if (> (length #serix$)  6) (setq CG_CeilHeight  (nth  6 #serix$)) (setq CG_CeilHeight  0) ); 7.�V�䍂��
  (if (> (length #serix$)  7) (setq CG_RoomW       (nth  7 #serix$)) (setq CG_RoomW       0) ); 8.�Ԍ�
  (if (> (length #serix$)  8) (setq CG_RoomD       (nth  8 #serix$)) (setq CG_RoomD       0) ); 9.���s
  (if (> (length #serix$)  9) (setq CG_GasType     (nth  9 #serix$)) (setq CG_GasType    "") );10.�K�X��
  (if (> (length #serix$) 10) (setq CG_ElecType    (nth 10 #serix$)) (setq CG_ElecType   "") );11.�d�C��
  (if (> (length #serix$) 11) (setq CG_KikiColor   (nth 11 #serix$)) (setq CG_KikiColor  "") );12.�@��F
  (if (> (length #serix$) 12) (setq CG_KekomiCode  (nth 12 #serix$)) (setq CG_KekomiCode "") );13.�P�R�~����
; 02/12/10 YM DEL-S [14]��SX���L�������Ă��邽�ߍ폜
;;;  (if (> (length #serix$) 13) (setq CG_DRSeriCodeRV(nth 13 #serix$)) (setq CG_DRSeriCodeRV nil) ); 14.���o�[�V�u���p��SERIES�L�� 00/10/13 SN ADD 00/10/24 SN MOD �����l��nil�ɕύX
;;;  (if (> (length #serix$) 14) (setq CG_DRColCodeRv (nth 14 #serix$)) (setq CG_DRColCodeRV  nil ) ); 15.���o�[�V�u���p��COLOR�L��   00/10/13 SN ADD 00/10/24 SN MOD �����l��nil�ɕύX
; 02/12/10 YM DEL-E [14]��SX���L�������Ă��邽�ߍ폜
)


;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetPatDlg
;;; <�����T�v>: �}�ʃ��C�A�E�g�o�̓p�^�[���I���_�C�A���O
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SCFGetPatDlg (
  &Txt$       ; �o�������ؽ�
  /
  #xSp #iI #No$ #iMode #sNo #Pat$ #iId ##SetList ##OK_Click #iRet #Ret$
  )
  (defun ##OK_Click(
    /
    #Pop$
    )
    (setq #sPat (nth (atoi (get_tile "lstPat")) #Pat$))
    (setq #Pop$ (assoc #sPat &Txt$))
    (if (= nil #sNo)
      (progn
        ; 2000/07/06 HT YASHIAC  ��̈攻��ύX
  ; �̈�͏��"0"
        ; (setq #sNo (nth (atoi (get_tile "popRyo")) #No$))
        (setq #sNo "0")
        (if (= "0" (get_tile "lstPat"))
          (progn
            (setq #sAng (cadr (assoc #sNo #sAng$)))
            (if (/= "90" #sAng)
              (progn
                (CFAlertMsg "����ŁA��ݒ肳�ꂽ��Ԃł�\nSTANDARD�p�^�[���̑I���͂ł��܂���.")
              )
              (progn
                (setq #Ret$ (list (cdr (cdr #Pop$)) #sNo (cadr #Pop$)))
                (done_dialog 1)
              )
            )
          )
          (progn
            (setq #Ret$ (list (cdr (cdr #Pop$)) #sNo (cadr #Pop$)))
            (done_dialog 1)
          )
        )
      )
      (progn
        (setq #Ret$ (list (cdr (cdr #Pop$)) #sNo (cadr #Pop$)))
        (done_dialog 1)
      )
    )
  )
  ;���X�g�{�b�N�X�ɒl��\������
  (defun ##SetList ( &SCFey &List$ / #vAl )
    (start_list &SCFey)
    (foreach #vAl &List$
      (add_list #vAl)
    )
    (end_list)
  )

  ; 2000/07/06 HT YASHIAC  ��̈攻��X
  ; �̈�͏��"0"
  ;;�̈�NO�l��
  ;(setq #xSp (ssget "X" (list (list -3 (list "RECT")))))
  ;(if (/= nil #xSp)
  ;  (progn
  ;    (setq #iI 0)
  ;    (repeat (sslength #xSp)
  ;      (setq #Ex$ (CfGetXData (ssname #xSp #iI) "RECT"))
  ;      (setq #No$ (cons (nth 0 #Ex$) #No$))
  ;      (setq #sAng$ (cons (list (nth 0 #Ex$)(nth 1 #Ex$)) #sAng$))
  ;      (setq #iI (1+ #iI))
  ;    )
  ;    (setq #No$ (acad_strlsort #No$))
  ;    (setq #No$ (ExceptToList #No$))
  ;    (setq #iMode 0)
  ;  )
  ;  (progn
      (setq #sNo "0")
      (setq #iMode 1)
  ;  )
  ;)

  ;�p�^�[�����X�g�l��
  (setq #Pat$ (mapcar 'car &Txt$))

  ;�_�C�A���O�\��
  (setq #iId (GetDlgID "CSFlay"))
  (if (not (new_dialog "GetPat" #iId))(exit))

    (##SetList "lstPat" #Pat$)
    ; 2000/07/06 HT YASHIAC  ��̈攻��X
    ;(##SetList "popRyo" #No$)
    ;(mode_tile "popRyo" #iMode)
    ;(set_tile  "lstPat" "1")
    (set_tile  "lstPat" "0");2011/07/22 YM MOD ��ԏ�ɂ���
    ;(set_tile  "popRyo" "1") 2000/07/06

    (action_tile "accept" "(##OK_Click)")
    (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OK�{�^������
    #Ret$
    nil
  )
) ; SCFGetPatDlg

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetPatDlgAuto
;;; <�����T�v>: �����I���̂Ƃ��̐}�ʃ��C�A�E�g�o�͐}�ʑI���_�C�A���O
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SCFGetPatDlgAuto (
  &Pat$       ; �o�̓p�^�[�����X�g
  &sType      ; �L�b�`���^�C�v
  /
  #iId ##OK_Click #iRet #Ret$
  )
  (defun ##OK_Click(
    /
    #Ret$ #view #sTempfile #Sret$
    )
    (if (= "1" (get_tile "Z00"))   ;���ʐ}
      (setq #Ret$ (cons (list "SK_����" "00") #Ret$))
    )
    (if (= "1" (get_tile "P02"))   ;���ʐ}
      (setq #Ret$ (cons (list "SK_����" CG_OUTSHOHINZU) #Ret$)) ; 2000/09/25 HT MOD (setq #Ret$ (cons (list "SK_����" "02") #Ret$))
    )
    (if
      (or                       ;�W�J�}
        (= "1" (get_tile "T02"))
        (= "1" (get_tile "T03"))
      )
      (progn
        (cond
          ((or (equal &sType "I-RIGHT") (equal &sType "I-LEFT"))
            (setq #sTempfile "SK_BAD�W�J")
          )
          ((or (equal &sType "D-RIGHT") (equal &sType "D-LEFT"))
            (setq #sTempfile "SK_BAD�W�J")
          )
          ((or (equal &sType "L-RIGHT") (equal &sType "W-LEFT"))
            (setq #sTempfile "SK_AD�W�J")
          )
          ((or (equal &sType "L-LEFT") (equal &sType "W-RIGHT"))
            (setq #sTempfile "SK_BA�W�J")
          )
        )
        (if (= "1" (get_tile "T02"))  (setq #Sret$ (cons CG_OUTSHOHINZU #Sret$))) ; 2000/09/25 HT MOD (setq #Sret$ (cons "02" #Sret$)))
        (if (= "1" (get_tile "T03"))  (setq #Sret$ (cons CG_OUTSEKOUZU #Sret$))) ; 2000/09/25 HT MOD (setq #Sret$ (cons "03" #Sret$)))
        (setq #Ret$ (cons (cons #sTempfile (reverse #Sret$)) #Ret$))
      )
    )
    (if (= "1" (get_tile "Shiyo")) ;�d�l�}
      (setq #Ret$ (cons (list "SK_�d�l�\" "") #Ret$)) ;"
    )
    (if (/= nil #Ret$)
      (progn
        (setq #Ret$ (reverse #Ret$))
        (done_dialog 1)
      )
      (CFAlertMsg "�����I������Ă��܂���.")
    )
    #Ret$
  )

  ;�_�C�A���O�\��
  (setq #iId (GetDlgID "CSFlay"))
  (if (not (new_dialog "GetPlanAuto" #iId))(exit))

    (action_tile "accept" "(setq #Ret$ (##OK_Click))")
    (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OK�{�^������
    #Ret$
    nil
  )
) ; SCFGetPatDlgAuto


;<HOM>************************************************************************
; <�֐���>  : SCFGetOutDimAuto
; <�����T�v>: ���@���쐬����_�C�A���O
; <�߂�l>  : �_�C�A���O�Ԃ�l
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun SCFGetOutDimAuto (
   &Pat$   ;
   &iAuto  ; �����t���O (STANDARD�̎�1)
  /
  #iId ##radio_mode #Ret$ ##OK_Click #iRet
  )

  (defun ##OK_Click (
    /
    #rdi #san
    #dim$  ; (�L���r�l�b�g���@ �{�H���@ �����E���E�E �c��)
    #Pat$  ; �e���v���[�g�� + �}�ʎ�ރ��X�g
    #sPat
    #lst$
    #lst2$
    #i
    #sPat2$
    )

    ; 02/07/22 YM ADD-S �u���ʐ}�ɐ��@�������Ȃ��v�Ƀ`�F�b�N���O���[�o���ݒ�
    (setq CG_PLANE_DIM nil)
    (if (= "1" (get_tile "tglpl"))
      (setq CG_PLANE_DIM T) ; ���ʐ}�ɐ��@�������Ȃ�
    );_if
    ; 02/07/22 YM ADD-E

    (cond
      ((= "1" (get_tile "rdia"))  (setq #rdi "A"))
      ((= "1" (get_tile "rdil"))  (setq #rdi "L"))
      ((= "1" (get_tile "rdir"))  (setq #rdi "R"))
    )
    (cond
      ((= "1" (get_tile "yoko"))  (setq #san "Y"))
      ((= "1" (get_tile "tate"))  (setq #san "T"))
    )
    ; 2000/07/04 �{�H�}�̃`�F�b�N�{�^����ON�̎��̂�
    ; ���@���(�{�H���@�ƃL���r�l�b�g���@)���I���ł���悤�ɂ���
    ; ���i�}�̎��̓L���r�l�b�g���@�̂�(�d�l�ύX�Ȃ�)
    ; 2000/07/04 HT DEL (list (get_tile "tglK") (get_tile "tglS") #rdi #san)
    (if (or (= "1" (get_tile "tglSet")) (= &iAuto 0))
      (progn
      (setq #dim$ (list (get_tile "tglK") (get_tile "tglS") #rdi #san))
      )
      (progn
      (setq #dim$ (list "0" "0" #rdi #san))
      )
    )
    ; �Ԃ�l�Ńp�^�[���ҏW("02" "03"��t������)
    (if (= &iAuto 0)
      (progn
        ; STANDARD���I�΂�Ă��鎞�́A���Ɏ����Őݒ肳��Ă���
        (setq #sPat2$ nil)
      )
      (progn
        (setq #sPat2$ '())

        (setq #lst$ '())
        ; ���i�}�̃`�F�b�N��ON�̎�
        (if (= "1" (get_tile "tglRay")) (progn
          (setq #lst$ (append #lst$ (list CG_OUTSHOHINZU))) ; 2000/09/26 HT MOD (setq #lst$ (append #lst$ (list "02")))
        ))
        ; �{�H�}�̃`�F�b�N��ON�̎�
        (if (= "1" (get_tile "tglSet")) (progn
          (setq #lst$ (append #lst$ (list CG_OUTSEKOUZU))) ; 2000/09/26 HT MOD  (setq #lst$ (append #lst$ (list "03")))
        ))
        (mapcar '(lambda (#sPat)
          (setq #i 1 #lst2$ '())
          (repeat (1- (length #sPat))
            ; �e���v���[�g���̌�� "02" "03"�ȊO�����Ă���ƕۑ����Ă���
              ; (if (= (member (nth #i #sPat) '("02" "03")) nil)  2000/09/26 HT MOD
              (if (= (member (nth #i #sPat) '(CG_OUTSHOHINZU CG_OUTSEKOUZU)) nil)
                (progn
              (setq #lst2$ (append #lst2$ (list (nth #i #sPat))))
              )
            )
            (setq #i (1+ #i))
          )
          ; �p�^�[�����X�g�ҏW
          ; ��) ((�e���v���[�g�� "02" "03") (�e���v���[�g�� "02" "03") �E�E�E)
          (if #lst$
            (setq #sPat2$ (append #sPat2$ (list (append (list (car #sPat)) #lst$))))
            (if #lst2$
              (setq #sPat2$ (append #sPat2$ (list (append (list (car #sPat)) #lst2$))))
              (setq #sPat2$ (append #sPat2$ (list (append (list (car #sPat)) (list "")))))
            );_if
          );_if
          )
          &Pat$
        ) ; mapcar
      )
    ) ; if
    (list #dim$ #sPat2$)
  );##OK_Click

  ; �{�H���@�̃`�F�b�N�{�^����ON�̎��ɌĂ΂��֐�
  (defun ##radio_mode (
    /
    )
    (if (= "1" (get_tile "tglS"))
      (progn
        (mode_tile "rdi" 0)
        (mode_tile "rdt" 0)
      )
      (progn
        (mode_tile "rdi" 1)
        (mode_tile "rdt" 1)
      )
    )
  )

  ; �{�H�}�̃`�F�b�N�{�^����ON�̎��ɌĂ΂��֐�
  (defun ##radio_mode2 (
    /
    )
    (if (= "1" (get_tile "tglSet"))
      (progn
        (mode_tile "rdi" 0)
        (mode_tile "rdt" 0)
        (mode_tile "tglK" 0)
        (mode_tile "tglS" 0)
      )
      (progn
        (mode_tile "rdi" 1)
        (mode_tile "rdt" 1)
        (mode_tile "tglK" 1)
        (mode_tile "tglS" 1)
      )
    )
  )


  ;�޲�۸ޕ\��
  (setq #iId (GetDlgID "CSFlay"))
  (if (not (new_dialog "GetOutDim" #iId))(exit))
    (##radio_mode)
    (action_tile "tglS"   "(##radio_mode)")
    ; 2000/07/04 �{�H�}�̃`�F�b�N�{�^����ON�̎��̂�
    ; ���@���(�{�H���@�ƃL���r�l�b�g���@)���I���ł���悤�ɂ���
    ; ���i�}�̎��̓L���r�l�b�g���@�̂�(�d�l�ύX�Ȃ�)
    (if (= &iAuto 0)
      (progn
      (mode_tile "tglRay" 1)
      (mode_tile "tglSet" 1)
      )
      (progn
      (##radio_mode2)
      (action_tile "tglSet"   "(##radio_mode2)")
      )
    )
    (action_tile "accept" "(setq #Ret$ (##OK_Click))(done_dialog 1)")
    (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OK�{�^������
    #Ret$
    nil
  )
) ; SCFGetPatDlgAuto


;<HOM>************************************************************************
; <�֐���>  : SCFEditPattarn
; <�����T�v>: �o�̓p�^�[�����X�g�ҏW
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun SCFEditPattarn (
  &Pat$       ; �p�^�[�����X�g
  /
  #Tmp$ #sTmp #sType #Ret$
  )
  (mapcar
   '(lambda ( #Tmp$ )
      (setq #sTmp (car #Tmp$))
      (mapcar
       '(lambda ( #sType )
          (if (or (= "" #sType)(= nil #sType))
            (setq #Ret$ (cons (list #sTmp "")     #Ret$))
            (setq #Ret$ (cons (list #sTmp #sType) #Ret$))
          )
        )
        (cdr #Tmp$)
      )
    )
    &Pat$
  )

  (reverse #Ret$)
) ; SCFEditPattarn


;<HOM>************************************************************************
; <�֐���>  : SCFLayoutDrawBefore
; <�����T�v>: ���C�A�E�g�o��
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<
(defun SCFLayoutDrawBefore (
  /
  #sTmp #sView #xSp #iI #eEn #sType #sMfile #sFname
  #bTblDrw  ; �d�l�}�����邩�Ȃ����̃t���O 2000/08/08 HT
  #BFLG #STITLE #n
#sFname2 #ver    ;-- 2011/10/06 A.Satoh Add
#FTYPE #RET #SM1FILE #SM2FILE ;2012/01/28 YM ADD
  )

;;;(makeERR "ڲ���7") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ڲ���7
;;;(WebOutLog "(3)�װ�֐�="); 02/09/04 YM ADD ۸ޏo�͒ǉ�
;;;(WebOutLog *error*); 02/09/04 YM ADD ۸ޏo�͒ǉ�

  ; 02/06/17 YM ADD-S "0_WAKU"��w���\���ɂ���
  (command "_layer" "of" "0_WAKU" "")
  ; 02/06/17 YM ADD-E

  ;�����X�^�C����ݒ肷��(��Q�����܂ŃJ�o�[�j
  (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" ""); 2011/05/30 YM MOD
  (command "._style" "KANJI_M" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

  (setq #sTmp  (car  (nth CG_PatNo CG_Pattern)))   ;�e���v���[�g�t�@�C����
  (setq #sView (cadr (nth CG_PatNo CG_Pattern)))   ;�}�ʎ��
  (setq #bTblDrw nil)    ; 2000/08/08 HT ADD
  ;�}�ʓ��̃��C�A�E�g�p�^�[�����l��

  ;2008/08/09 YM ADD as TS
  ;��DXF�ۑ��Ή���
;;;  (setq #sFname (strcat CG_KENMEI_PATH "OUTPUT\\" #sTmp "_" CG_RyoNo "_" #sView "." CG_SAVE_OUTPUT_FILE_TYPE))
;;;  (SCFSaveOutputFileType #sFname)


  (SCF_LayFreezeOff (list "0_WAKU"))
  (setq #xSp (ssget "X" (list (cons 8 "0_WAKU") (list -3 (list "FRAME")))))


;;; ; 01/05/10 YM ADD "FRAME"���d�l�\�̂݃p�[�X�݂̂ł��邩�ǂ������肷�� START ------------------
;;;  (setq #n 0 #kosu_P 0 #kosu_D 0 #kosu 0) ; �p�[�X�g,�d�l�\�g,����ȊO�̌�
;;;  (repeat (sslength #xSp)
;;;    (setq #dum_Type (car (CfGetXData (ssname #xSp #n) "FRAME")))
;;;   (cond
;;;     ((= #dum_Type "P")(setq #kosu_P (1+ #kosu_P)))
;;;     ((= #dum_Type "D")(setq #kosu_D (1+ #kosu_D)))
;;;     (T (setq #kosu (1+ #kosu)))
;;;   );_cond
;;;   (setq #n (1+ #n))
;;; );repeat
;;;
;;; (if (or (and (= #kosu 0)(> #kosu_P 0))  ; �߰��̂�
;;;         (and (= #kosu 0)(> #kosu_D 0))) ; �d�l�\�̂�
;;;   (setq #SYOHIN_ONLY T)
;;;   (setq #SYOHIN_ONLY nil)
;;; );_if
;;; ; 01/05/10 YM ADD "FRAME"���d�l�\�̂݃p�[�X�݂̂ł��邩�ǂ������肷�� START ------------------


  (if (/= nil #xSp)
    (progn ; "0_WAKU"������ꍇ
      (setq #iI 0)
      ;03/07/26 YM ADD-S POINT��}
      (KP_MakeDummyPoint)
      ;03/07/26 YM ADD-E POINT��}


			;****************************************************************************************
			; 2013/09/11 YM ADD ���ߕ�����ǉ����� Errmsg.ini�Q��
			(NS_AddTableMoji #sTmp);�p�[�X�}�ȊO���i�},�{�H�}�Œ��߂��o�͂���1/30�1/20,1/40�͍��W�ϊ�
			;****************************************************************************************

      (repeat (sslength #xSp)

;;;(makeERR "ڲ���8") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ڲ���8
;;;(WebOutLog "(4)�װ�֐�="); 02/09/04 YM ADD ۸ޏo�͒ǉ�
;;;(WebOutLog *error*); 02/09/04 YM ADD ۸ޏo�͒ǉ�

        (setq #eEn (ssname #xSp #iI))
        ;�}�ʃ^�C�v
        (setq #sType (car (CfGetXData #eEn "FRAME")))
        ; ���i����=2(�Ʒ���,���ʂ̑��ʐ}---�W�JB,D---�̎{�H���@�͎����Ƃ��邽��
        (setq CG_sType (car (CfGetXData #eEn "FRAME"))) ; ��۰��ى� 02/07/11 YM ADD
        ;�W�J���}��
        (setq #sMfile (strcat CG_KENMEI_PATH "BLOCK\\" #sType "_" CG_RyoNo ".dwg"))

        (cond
          ; ((= "P" #sType)                ;���ʐ}
          ((and (= "P" #sType) (/= #sView ""))    ;���ʐ} 2000/08/08
            ;�W�J���}��
            (setq #sMfile (strcat CG_KENMEI_PATH "BLOCK\\" #sType "_" CG_RyoNo ".dwg"))
            (if (findfile #sMfile)
              (SCFDrawPlanLayout   #sMfile #eEn CG_KitType #sView)
            )
          )
          ; ((= "S" (substr #sType 1 1))   ;�W�J�}
          ((and (= "S" (substr #sType 1 1)) (/= #sView ""))   ;�W�J�} 2000/08/08
            ;�W�J���}��
            (setq #sMfile (strcat CG_KENMEI_PATH "BLOCK\\" #sType "_" CG_RyoNo ".dwg"))
            (if (findfile #sMfile)
              (SCFDrawExpandLayout #sMfile #eEn CG_KitType #sView)
            )
          )
          ((= "D" #sType)                ;�d�l�}
            ;�W�J���}��
            (setq #sMfile (strcat CG_KENMEI_PATH "Table.cfg"))
            (if (findfile #sMfile)
              (progn
              (SCFDrawTableLayout  #sMfile #eEn)
              (setq #bTblDrw T)    ; 2000/08/08 HT ADD
              )
            )
          )
        )
        ;�V���{���}�`�폜  ; 2000/09/13 DEBUG�p
        (if DelSymEntity
          (DelSymEntity)
        )
        (setq #iI (1+ #iI))
      ) ;_repeat

      ; ���i�}�o�́E�{�H�}�o�� OFF ���� �d�l�}���쐬����Ă��Ȃ����A
      ; �}�ʕۑ����Ȃ��悤�ɂ����B 2000/08/08 HT
      (if (not (and (= #bTblDrw nil) (= #sView "")))
        (progn
          ;�p�}�z�u
          (DispFigure)

          ;P�}�`���\���ɂ���
          (SKFSetHidePLayer)

          ;�n�b�`���O�X�V
          (CFRefreshHatchEnt) ;00/05/09 HN DEL �Ƃ肠�����R�����g��

          ;��w
          ; 119 01/04/08 HN MOD ��w"0_HIDE"�̔�\��������ǉ�
          ;MOD(command "_.-layer" "of" "O_hide" "")
          (command "_.-LAYER" "ON" "O_HIDE" "")

          ;�^�C�g����}
          (cond
            ((= CG_OUTSHOHINZU #sView) (setq #sTitle "���i�}")) ; 2000/09/26 HT MOD ((= "02" #sView) (setq #sTitle "���i�}"))
            ((= CG_OUTSEKOUZU  #sView) (setq #sTitle "�{�H�}")) ; 2000/09/26 HT MOD ((= "03" #sView) (setq #sTitle "�{�H�}"))
            ;@@@((= "04" #sView) (setq #sTitle "�ݔ��z�ǐ}"))
          )
          (SCFMakeTitleText #sTitle)

          ;�p�[�W
          (PurgeBlock)

          ;ZOOM
          (command "_.ZOOM" "A")

          ;00/10/24 SN S-ADD XRECORD�o�^LIST�����O�ɍ쐬
          (setq CG_SetXRecord$
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

          ;�ݒ肪����Όォ��ǉ�����B
          (if CG_DRSeriCodeRV (setq CG_SetXRecord$ (append CG_SetXRecord$ (list CG_DRSeriCodeRV))))
          (if CG_DRColCodeRV  (setq CG_SetXRecord$ (append CG_SetXRecord$ (list CG_DRColCodeRV ))))
          ;00/10/24 SN E-ADD

          ;00/08/22 SN S-ADD
          ; XRecord"SERI"�������
          ; SCFLayout�Őݒ肵���O���ϐ��̒l��XRcord�㏑��
          (if (CFGetXRecord "SERI")
            (CFSetXRecord "SERI"
              ;00/10/24 SN MOD ���O�ɍ쐬����LIST���g�p����B
              CG_SetXRecord$
              ;(list
              ;  CG_DBNAME       ; 1.DB����
              ;  CG_SeriesCode   ; 2.SERIES�L��
              ;  CG_BrandCode    ; 3.�u�����h�L��
              ;  CG_DRSeriCode   ; 4.��SERIES�L��
              ;  CG_DRColCode    ; 5.��COLOR�L��
              ;  CG_UpCabHeight  ; 6.��t����
              ;  CG_CeilHeight   ; 7.�V�䍂��
              ;  CG_RoomW        ; 8.�Ԍ�
              ;  CG_RoomD        ; 9.���s
              ;  CG_GasType      ;10.�K�X��
              ;  CG_ElecType     ;11.�d�C��
              ;  CG_KikiColor    ;12.�@��F
              ;  CG_KekomiCode   ;13.�P�R�~����
              ;  CG_DRSeriCodeRV ;14.��SERIES�L�� 00/10/12 SN ADD
              ;  CG_DRColCodeRV  ;15.��COLOR�L��   00/10/12 SN ADD
              ;)
            )
          ) ;_if
          ;00/08/22 SN E-ADD

          ; 02/03/28 HN S-ADD �}�ʎ�ނ�ݒ�
          (CFSetXRecord "DRAWTYPE" (list #sView))
          ; 02/03/28 HN E-ADD �}�ʎ�ނ�ݒ�

          ;�}�ʕۑ�
;2008/08/09 YM DEL DXF�ۑ��Ή�
          (setq #sFname (strcat CG_KENMEI_PATH "OUTPUT\\" #sTmp "_" CG_RyoNo "_" #sView ".dwg"))

          ;06/06/16 AO MOD �ۑ��`����2004�ɕύX
          ;(command "_SAVEAS" "2000" #sFname)
          (command "_SAVEAS" CG_DWG_VERSION #sFname)

          ; 02/08/01 YM Web��CAD���ްӰ�ޏꍇ����
          (if (= CG_AUTOMODE 2) ; ���̂܂�PDF�ۑ�
            (progn

              (cond
                ((= "02" CG_ZUMEN_FLG)
                  (if (= "1" CG_SYOHIN_PDF_FLG)
                    (progn ;���i�}PDF�o�͎w������
                      (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT2) ; �W�J�}
                      ;2009/10/24 YM ����L�^�̂Ƃ�1/40�ɕύX
                      (if (and (= CG_UnitCode "K")(= "L" (substr (nth  5 CG_GLOBAL$) 1 1)))
                        (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT4) ; �W�J�}
                      );_if

                      ;2008/12/24 YM ADD-S �݌ˉ�w��\��
                      (command "_.-layer" "of" "O_hide" "")
                      (command "_.-layer" "of" "0_WALL" "")
                      ;2008/12/24 YM ADD-E �݌ˉ�w��\��
                      (WebPDF_OUTPUT)
                      ;(timer 1)

                      ;2008/09/05 YM ADD �{�H�}�����ɕʎ�(���߂���PDF�}��)��t����
                      ;2008/09/17 YM ADD ����,���[�ŕʎ��𕪂�����
                      (if (= CG_UnitCode "K")
                        nil ;����
                        ;else
                        ;���[���i�}
                        (setq #ret (vl-file-copy (strcat CG_TMPAPATH "�ʎ�D.pdf") CG_PDF_SYOUSAI))
                      );_if

                    )
                  );_if

                  (if (= "1" CG_SYOHIN_DWG_FLG)
                    (progn ;�߰�DWG,dxf�o�͎w������
                      ;̧�ٺ�߰
                      (setq #ret (vl-file-copy #sFname CG_DWG_FILENAME))
                      ;dxf�o��
                      (command "_saveas" "dxf" "V" CG_DXF_VERSION "16" CG_DXF_FILENAME)
                    )
                  );_if

                )
                ((= "04" CG_ZUMEN_FLG)
                  (if (= "1" CG_SEKOU_PDF_FLG)
                    (progn ;���i�}PDF�o�͎w������
                      (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT2) ; �W�J�}
                      ;2009/10/24 YM L�^�̂Ƃ�1/40�ɕύX
                      (if (and (= CG_UnitCode "K")(= "L" (substr (nth  5 CG_GLOBAL$) 1 1)))
                        (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT4) ; �W�J�}
                      );_if

                      ;2008/12/24 YM ADD-S �݌ˉ�w��\��
                      (command "_.-layer" "of" "O_hide" "")
                      (command "_.-layer" "of" "0_WALL" "")
                      ;2008/12/24 YM ADD-E �݌ˉ�w��\��
                      (WebPDF_OUTPUT)
                      ;(timer 1)

                      ;2008/09/05 YM ADD �{�H�}�����ɕʎ�(���߂���PDF�}��)��t����
                      ;2008/09/17 YM ADD ����,���[�ŕʎ��𕪂�����
                      (if (= CG_UnitCode "K")
                        ;���ݎ{�H�}
                        (setq #ret (vl-file-copy (strcat CG_TMPAPATH "�ʎ�A.pdf") CG_PDF_SYOUSAI))
                        ;else
;;; 2008/10/01YM@DEL                        (setq #ret (vl-file-copy (strcat CG_TMPAPATH "�ʎ�D.pdf") CG_PDF_SYOUSAI))
                      );_if

                    )
                  );_if

                  (if (= "1" CG_SEKOU_DWG_FLG)
                    (progn ;�߰�DWG�o�͎w������
                      ;̧�ٺ�߰
                      (setq #ret (vl-file-copy #sFname CG_DWG_FILENAME))
                      ;dxf�o��
                      (command "_saveas" "dxf" "V" CG_DXF_VERSION "16" CG_DXF_FILENAME)
                    )
                  );_if
                )
              );_cond

            )
          );_if

          ;04/04/14 YM �}�ʎQ�Ƃ��Ȃ� @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;         (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 3)) ; ���̂܂܈��(����Ƹ޼��,DL�Q��)
          (if (member CG_AUTOMODE '(1 3));2008/08/05 YM MOD
            (progn
              (setq CG_Zumen_Count (1+ CG_Zumen_Count));2����=2
              ; *** 2���� ***
              (if (= 2 CG_Zumen_Count)
                (progn
                  (if (= CG_ZumenPRINT 1);������邩�ǂ������׸�
                    (progn
                      ; �ȈՈ�� ���̐}
                      (if (CFYesNoDialog "������s���܂����H")
                        (progn
                          (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT2) ; ���̐}
                          (C:PlainPlot) ; Yes
                        )
                        ;else
                        nil             ; No
                      );_if
                    )
                  );_if
                )
              );_if

              ; *** 3���� ***
              (if (= 3 CG_Zumen_Count)
                (progn
                  (if (= CG_ZumenPRINT 1)
                    (progn
                      ; �ȈՈ�� �W�J�}
                      (if (CFYesNoDialog "������s���܂����H")
                        (progn
                          (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT3)
                          (C:PlainPlot) ; Yes
                        )
                        ;else
                        nil             ; No
                      );_if
                    )
                  );_if
                )
              );_if
            )
          );_if
          ;04/04/14 YM �}�ʎQ�Ƃ��Ȃ� @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


        ) ;_progn
      ) ;_if
    ) ;_progn
    (progn ; 0_WAKU���Ȃ��ꍇ�@�߰��p����ڰĈ������ذ������ڰ�

      (setq #xSp (ssget "X" (list (cons 0 "VIEWPORT"))))

      ; �ޭ��߰Ă̗L���Ŕ��f����͎̂~�߂�
      ; �ذ�߰��}������ނ̂����ذ������ڰĂɂ��ޭ��߰Ă�ǉ�
      (if (and (/= nil #xSp)(= nil (tblsearch "layer" "FREE"))) ; 03/01/21 YM MOD
;;;      (if (/= nil #xSp) ; 03/01/21 YM MOD
        (progn ; �ذ����ڰĂł͂Ȃ�
          (setq #bFlg nil)
          (setq #iI 0)
          (repeat (sslength #xSp)
            (if (< 1 (cdr (assoc 69 (entget (ssname #xSp #iI)))))
              (setq #bFlg T)
            )
            (setq #iI (1+ #iI))
          )
          (if (/= nil #bFlg)
            (progn    ; �p�[�X�}��}
              (setq #sMfile (strcat CG_KENMEI_PATH "BLOCK\\M_0.dwg"))
							;2012/01/17 YM MOD-S
							(if (findfile #sMfile)
								(progn
									;2012/01/28 YM MOD M_1,M_2�����Ȃ���΋��֐���ʂ�
									(setq #sM1file (strcat CG_KENMEI_PATH "BLOCK\\M_1.dwg"))
									(setq #sM2file (strcat CG_KENMEI_PATH "BLOCK\\M_2.dwg"))
									(if (and (= (findfile #sM1file) nil)(= (findfile #sM2file) nil))
										(progn ;����nil �߰��P1,P2�Ƃ��ɐݒ肪�Ȃ�
              				(SCFDrawPersLayout #sMfile CG_KitType)
										)
										(progn
											(SCFDrawPersLayout2 CG_KitType)
										)
									);_if
								)
							);_if

							;2012/01/17 YM MOD-E

              ;�^�C�g����}
              (SCFMakeTitleText "�p�[�X�}") ;00/05/28 HN DEL �Ƃ肠�����R�����g��

              ;P�}�`���\���ɂ���
              (SKFSetHidePLayer)

              ; 01/05/29 HN DEL �p�[�X�}�̃n�b�`���O�������폜
              ;@DEL@;�n�b�`���O�X�V
              ;@DEL@(CFRefreshHatchEnt)

              ;�p�[�W
;;;              (PurgeBlock)

              ;�}�ʕۑ�
              (setq #sFname (strcat CG_KENMEI_PATH "OUTPUT\\" #sTmp "_" CG_RyoNo "_00.dwg"))

              ;06/06/16 AO MOD �ۑ��`����2004�ɕύX
              ;(command "_SAVEAS" "2000" #sFname)
;-- 2011/10/06 A.Satoh Mod - S
;;;;;              (command "_SAVEAS" CG_DWG_VERSION #sFname)
              (command "_SAVEAS" CG_DWG_VER_MODEL #sFname)
;-- 2011/10/06 A.Satoh Mod - S

              ;2008/08/11 YM ADD
;;;             (setvar "SDI"  0);�����t�@�C���\�@����ɂ��Ȃ����߰��}��dxf�o�͂ł��Ȃ�

              ; 02/08/01 YM Web��CAD���ްӰ�ޏꍇ����
              (if (= CG_AUTOMODE 2) ; ���̂܂�PDF�ۑ� "4"�̂Ƃ�JPG�o�͗p�߰��쐬
                (progn

                  (if (= "1" CG_PERS_PDF_FLG)
                    (progn ;�߰�PDF�o�͎w������
                      (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT1) ; �p�[�X�}
                      (WebPDF_OUTPUT)
                      ;(timer 1)
                    )
                  );_if

                  (if (or (= "1" CG_PERS_DWG_FLG)
                          (/= "" PB_TEMPLATE_TYPE));2009/02/23 YM ADD 
                    (progn ;�߰�DWG�o�͎w������
                      ;̧�ٺ�߰
                      (setq #ret (vl-file-copy #sFname CG_DWG_FILENAME));��ھ��CG�׸ނ����̂Ƃ������s

                      (if (= "1" CG_PERS_DWG_FLG);dxf���׸ނ���̂Ƃ��̂�
                        (command "_saveas" "dxf" "V" CG_DXF_VERSION "16" CG_DXF_FILENAME)
                      );_if
                    )
                  );_if

                )
              );_if

              ; 03/02/22 YM Web��CAD���ްӰ�ޏꍇ����
              (if (= CG_AUTOMODE 4) ; "4"�̂Ƃ�JPG�o�͗p�߰��쐬
                (WebTIFF_OUTPUT)
              );_if

              (if (= CG_AUTOMODE 5) ; "5"�̂Ƃ������ݸ޼��JPG�o��
                (WebJPG_OUTPUT)
              );_if

              ;04/04/14 YM �}�ʎQ�Ƃ��Ȃ� @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;             (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 3)) ; ���̂܂܈��(����Ƹ޼��,DL�Q��)
              (if (member CG_AUTOMODE '(1 3));2008/08/05 YM MOD
                (progn
                  (setq CG_Zumen_Count (1+ CG_Zumen_Count));1����=1
                  ; *** 1���� ***
                  (if (= 1 CG_Zumen_Count)
                    (progn
                      (if (= CG_ZumenPRINT 1)
                        (progn
                          ; �ȈՈ�� ���̐}
                          (if (CFYesNoDialog "������s���܂����H")
                            (progn
                              (setq CG_AUTOMODE_PRINT CG_AUTOMODE_PRINT1) ; ���̐}
                              (C:PlainPlot) ; Yes
                            )
                            ;else
                            nil             ; No
                          );_if
                        )
                      );_if
                    )
                  );_if
                )
              );_if
              ;04/04/14 YM �}�ʎQ�Ƃ��Ȃ� @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

            ) ;_progn
            ; 01/05/04 HN S-ADD
            (progn
              ;@DEL@(CFAlertMsg "����ڰĐ}�ʓ��ɐ}�`�\���̈�g�����݂��܂���.") ;01/05/09 HN DEL
              (SCFLayoutFree)
            )
            ; 01/05/04 HN E-ADD
          ) ;_if
        ) ;_progn
        ; 01/05/04 HN S-MOD
        ;@MOD@(CFAlertMsg "����ڰĐ}�ʓ��ɐ}�`�\���̈�g�����݂��܂���.")
        (progn ; �ذ����ڰĂł���
          ;@DEL@(CFAlertMsg "����ڰĐ}�ʓ��ɐ}�`�\���̈�g�����݂��܂���.") ;01/05/09 HN DEL

					;****************************************************************************************
					; 2013/09/11 YM ADD ���ߕ�����ǉ����� Errmsg.ini�Q��
					(NS_AddTableMoji #sTmp);�p�[�X�}�ȊO���i�}�{�H�}�Œ��߂��o�͂���1/30�1/20,1/40�͍��W�ϊ�
					;****************************************************************************************

          (SCFLayoutFree)

        )
        ; 01/05/04 HN E-MOD
      ) ;_if
    ) ;_progn
  ) ;_if
  ; 01/05/22 HN S-MOD �����}�ʑΉ�
  ;@MOD@(setq CG_PatNo (1+ CG_PatNo))
  (if (= nil CG_LayoutFreeContinue)
    (setq CG_PatNo (1+ CG_PatNo))
  )
  ; 01/05/22 HN S-MOD �����}�ʑΉ�
  (setq #sTmp  (car  (nth CG_PatNo CG_Pattern)))   ;����ڰ�̧�ٖ�
  (if (and (/= nil #sTmp)(findfile (strcat CG_TMPPATH #sTmp ".dwt")))
    (progn

      ; 01/10/02 YM MOD-S ����Ӱ�ނł�SCFCmnFileOpen�������Ȃ�;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
;;;     (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"�ǉ� 03/02/22 JPGڲ���Ӱ��
      (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
        (progn
;-- 2011/10/06 A.Satoh Mod - S
;;;;;          (command ".qsave")
          (setq #sFname2 (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
          (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
                  (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
            (setq #ver CG_DWG_VER_MODEL)
            (setq #ver CG_DWG_VER_SEKOU)
          )
(princ #sFname2)
          (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/06 A.Satoh Mod - E

          (command "_.Open" (strcat CG_TMPPATH #sTmp ".dwt")) ; D:\\WORKS\\NAS\\BUKKEN\\NPS0003\\05\\MODEL.DWG"

          (S::STARTUP)
        )
        (SCFCmnFileOpen (strcat CG_TMPPATH #sTmp ".dwt") 0) ; 2000/10/19 HT �֐���
      );_if
      ; 01/10/02 YM MOD-E ����Ӱ�ނł�SCFCmnFileOpen�������Ȃ�

    )
    (progn
      ; ����ȏ�J���e���v���[�g���Ȃ��̂ŁA�R�}���h���I��������B
      (setq CG_OpenMode nil)

      ;�}�ʂ̕ۑ�
;;;      (CFQSave)

      ; 01/09/07 YM MOD-S ����Ӱ�ނł�SCFCmnFileOpen�������Ȃ�;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
;;;     (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"�ǉ� 03/02/22 JPGڲ���Ӱ��
      (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
        (progn
          (setq #fType  (strcase (vl-filename-extension (getvar "DWGNAME"))))
          (cond
            ((= #fType ".DXF")
              (command "_SAVEAS" "DXF" "V" CG_DXF_VERSION "16" (strcat CG_KENMEI_PATH "OUTPUT\\" (getvar "dwgname")));2008/08/11 YM MOD
            )
            ((= #fType ".DWG")
;-- 2011/10/06 A.Satoh Mod - S
;;;;;              (command "_SAVEAS" CG_DWG_VERSION (strcat CG_KENMEI_PATH "OUTPUT\\" (getvar "dwgname")));2008/08/11 YM MOD
              (progn
                (setq #sFname2 (strcat CG_KENMEI_PATH "OUTPUT\\" (getvar "DWGNAME")))
                (if (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME"))
                  (setq #ver CG_DWG_VER_MODEL)
                  (setq #ver CG_DWG_VER_SEKOU)
                )
(princ #sFname2)
                (command "_.SAVEAS" #ver #sFName2)
              )
;-- 2011/10/06 A.Satoh Mod - E
            )
          );_cond

;;;         (command ".qsave");2008/08/11 YM MOD

          (command "_.Open" CG_DwgName) ; D:\\WORKS\\NAS\\BUKKEN\\NPS0003\\05\\MODEL.DWG"
          (S::STARTUP)
        )

        (SCFCmnFileOpen CG_DwgName 1)
      );_if

    )
  )

;;;(makeERR "ڲ���12") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ڲ���12

  (princ)
) ; SCFLayoutDrawBefore

;;;<HOM>************************************************************************
;;; <�֐���>  : CFQSave
;;; <�����T�v>: �g�� QSave
;;; <�߂�l>  : �Ȃ�
;;; <����>    : 04/11/30
;;; <���l>    : �ʏ��(command "_.QSAVE")�����ł́A�}�ʕۑ����Ɋm�F���K�v��
;;;             �Ȃ�P�[�X�����邽�߁A�I�v�V�����̓��͂Ȃ��ɕۑ��ł���悤�ɉ���
;;;             �iDWG �� Qsave �̌�� DXF�� Qsave �����s�����Ƃ��Ȃǁj
;;;************************************************************************>MOH<
(defun CFQSave (
  /
  #fType
  )
  (setq #fType  (strcase (vl-filename-extension (getvar "DWGNAME"))))

  (command "_.QSAVE")
  (if (wcmatch (getvar "CMDNAMES") "*QSAVE*")
    (cond
      ((= #fType ".DXF")
        (command "DXF" "V" CG_DXF_VERSION "16" "")
      )
      (T
        (command CG_DWG_VERSION "")
      )
    )
  )
  (princ)
);CFQSave

;<HOM>*************************************************************************
; <�֐���>    : SCFSaveOutputFileType
; <�����T�v>  : �n�t�s�o�t�s�}�ʂ�ۑ�����
; <�߂�l>    : �Ȃ�
; <���l>      : CG_SAVE_OUTPUT_FILE_TYPE �̐}�ʎ�ނɂ���ĕۑ��`����ύX����
;*************************************************************************>MOH<
(defun SCFSaveOutputFileType (
  &sFname
  )
  (cond
    ((= CG_SAVE_OUTPUT_FILE_TYPE "DXF")
;;;      (command "_SAVEAS" "DXF" "V" "2004" "16" &sFname)
      (command "_saveas" "dxf" "V" CG_DXF_VERSION "16" CG_DXF_FILENAME)
    )
    (T
      (command "_SAVEAS" CG_DWG_VERSION &sFname)
    )
  )
)
;SCFSaveOutputFileType

;;;<HOM>************************************************************************
;;; <�֐���>  : CHG_TENBAN_LAYER
;;; <�����T�v>: �V��w�ύX����(�V�̉�w��"0"�ɂȂ��Đ��@�����܂��o�Ȃ�)
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : 2015/05/20 YM ADD
;;;************************************************************************>MOH<
(defun CHG_TENBAN_LAYER(
  &ss
  &lay
  /
	#EEN #EG$ #I #SWT$
  )
  (setq #i 0)
  (repeat (sslength &ss)
    (setq #eEn (ssname &ss #i))
		(setq #sWT$ (CfGetXData #eEn "G_WRKT"))
		(if #sWT$ ;�V������
			(progn
				;��w�̕ύX
				(setq #eg$ (entget #eEn))
				(entmod (subst (cons 8 &lay) (assoc 8 #eg$) #eg$))
			)
		);_if
    (setq #i (1+ #i))
  );repeat
	(princ)
);CHG_TENBAN_LAYER

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFDrawPlanLayout
;;; <�����T�v>: ���C�A�E�g�}�쐬  ���ʐ}
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SCFDrawPlanLayout
  (
  &sMfile     ; �W�J���}�t�@�C����
  &eEn        ; �̈�}�`��
  &sType      ; �L�b�`���^�C�v
  &SCFind     ; �}�ʎ��
  /
  #high #zmove #xSp #iI #eEn #sName #eEx #Del$ #xSe #layer #Pt$ #dMin #dMax #dVm
  #sHnd       ; �}������̐}�`�n���h��
  #d1         ; �ذ�z�u�͈̔�1�_��
  #d2         ; �ذ�z�u�͈̔�2�_��
  #psLast     ; �{�֐����ō쐬�����}�`�I���Z�b�g
  #sGroup     ; �O���[�v��
	#ss
  )
  (princ "\n SCFDrawPlanLayout ")

  
  (setq #high  0.01)          ; �B���̈�y�ђP��v���~�e�B�u�̉����o������
  (setq #zmove 5000)          ; �f�ʎw��}�`�y�уo���[��������Z���W�ړ���

  ;01/05/04 HN S-ADD
  ;@TEST@(if (= nil &eEn)
  ;@TEST@  (progn
  ;@TEST@    (setq #d1 (getpoint "\n1�_��:"))
  ;@TEST@    (setq #d2 (getcorner #d1 "\n2�_��:"))
  ;@TEST@    (command "_.RECTANG" #d1 #d2)
  ;@TEST@    (setq &eEn (entlast))
  ;@TEST@  )
  ;@TEST@)
  ;01/05/04 HN E-ADD

  ;�W�J���}�}��
  ; 01/05/04 HN S-MOD �̈�}�`�̔����ǉ�
  ;@MOD@(command "_.INSERT" &sMfile "0,0" "1" "1" "0")
  (if &eEn
    (progn
      (command "_.INSERT" &sMfile "0,0" 1 1 "0")
    )
    (progn
      (prompt "\n�}���ʒu���w��: ")
      (command "_.regenall")
      (command "_.INSERT" &sMfile PAUSE 1 1 "0")
    )
  );_if
  ; 01/05/04 HN E-MOD �̈�}�`�̔����ǉ�
  (setq #sHnd (cdr (assoc 5 (entget (entlast))))) ; 01/05/09 HN ADD
  (command "_.EXPLODE" (entlast))
  ;�K�v�Ȑ}�ʎ�ނ��l��
  (setq #xSp (ssget "P"))

  (setq #iI 0)
  (repeat (sslength #xSp)
    (setq #eEn (ssname #xSp #iI))
    (setq #sName (cdr (assoc 2 (entget #eEn))))
    (if (equal (substr #sName 2) &SCFind)
      (setq #eEx #eEn)
      (setq #Del$ (cons #eEn #Del$))
    )
    (setq #iI (1+ #iI))
  )
  (mapcar 'entdel #Del$)
  (command "_.EXPLODE" #eEx)
  (setq #xSe (ssget "P"))

	;2015/05/20 YM ADD �V��w�ύX����(�V�̉�w��"0"�ɂȂ��Đ��@�����܂��o�Ȃ�)
	(CHG_TENBAN_LAYER #xSe "0_PLANE")

  (if (/= nil #xSe)
    (progn
			; 2017/09/14 KY ADD-S
			; �t���[���L�b�`���Ή�
			(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
				(progn
					(setq #ss (ssget "X" '((-3 ("G_DEL")))))
					(if #ss
						(progn
							(command "_.ERASE" #ss "")
							(setq #ss nil)
						);progn
					);if
				);progn
			);if
			; 2017/09/14 KY ADD-E

      ;��w�l��
      (setq #layer "0_PLANE")
      (if &eEn      ; 01/05/04 HN ADD �̈�}�`�̔����ǉ�
        (progn
          ;�̈撆�S�ʒu�l��
          (setq #Pt$  (mapcar 'car (get_allpt_H &eEn)))
          (setq #dMin (list (apply 'min (mapcar 'car #Pt$)) (apply 'min (mapcar 'cadr #Pt$))))
          (setq #dMax (list (apply 'max (mapcar 'car #Pt$)) (apply 'max (mapcar 'cadr #Pt$))))
          (setq #dVm  (mapcar '* '(0.5 0.5 1.0) (mapcar '+ #dMin #dMax)))
          ;�}�ʈړ�
          (SCFMoveEntityLimmid #dVm #xSe #layer "P")
        )
      )             ; 01/05/04 HN ADD �̈�}�`�̔����ǉ�

      ; 01/05/24 HN ADD ���@���̊p�x�ƍ����̕ύX������ǉ�
      ; (SCFMoveEntityLimmid)�����֐������Ĉړ�
      (KCFChgDimAngHigh #xSe)

      ;�B���̈�y�ђP��ʃv���~�e�B�u���\���b�h������
      (SCFPlanePmenTanSlid #xSe #high)
      ;�o���[���쐬
      ; 01/12/06 HN MOD �萔���O���[�o����
      ;@MOD@(DrawBaloon #xSe #layer 15000)
      (DrawBaloon #xSe #layer CG_LAYOUT_DIM_Z)
      ;���@����}
      ; 2000/07/10 ���i�} �{�H�}�̐}�ʎ�ނ������ɑ��₵��
      ; (SCFDrawDimensionPl CG_DimPat)

;;;02/07/22YM@DEL     (SCFDrawDimensionPl CG_DimPat &SCFind)

      ; 02/07/22 YM ADD-S
      (if CG_PLANE_DIM
        nil ; ���@�������Ȃ�
        (SCFDrawDimensionPl CG_DimPat &SCFind)
      );_if
      ; 02/07/22 YM ADD-E

      ; 01/05/06 HN S-ADD �W�J�}���}�Ɛ��@���̃O���[�v��������ǉ�
      (setq #psLast (SCFGetEntsLast #sHnd))

      (setq #sGroup "0_PLANE")
      ; 02/01/22 HN ADD �O���[�v���̂̃`�F�b�N������ǉ�
      (setq #sGroup (SCFGetGroupName #sGroup))
      (command
        "-GROUP"    ; �I�u�W�F�N�g �O���[�v�ݒ�
        "C"         ; �쐬
        #sGroup     ; �O���[�v��
        #sGroup     ; �O���[�v��

        #psLast     ; �I�u�W�F�N�g
        ""
      )
      ; 01/05/06 HN E-ADD �W�J�}���}�Ɛ��@���̃O���[�v��������ǉ�
    )
  ) ;_if

  (princ)
) ;_SCFDrawPlanLayout

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFDrawExpandLayout
;;; <�����T�v>: ���C�A�E�g�}�쐬  �W�J�}
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SCFDrawExpandLayout
  (
  &sMfile     ; �W�J���}�t�@�C����
  &eEn        ; �̈�}�`��
  &sType      ; �L�b�`���^�C�v
  &SCFind     ; �}�ʎ��
  /
  #high #zmove #xSp #iI #eEn #sName #sView #eEx #Del$ #xSe #Pt$ #dMin #dMax #dVm
  #LAYER
  #sHnd       ; �}������̐}�`�n���h��
  #d1         ; ���R�z�u�͈̔�1�_��  �����g�p
  #d2         ; ���R�z�u�͈̔�2�_��  �����g�p
  #psLast     ; �{�֐����ō쐬�����}�`�I���Z�b�g
  #sGroup     ; �O���[�v��
	#ss
  )
  (setq #high  0.01)          ; �B���̈�y�ђP��v���~�e�B�u�̉����o������
  (setq #zmove 5000)          ; �f�ʎw��}�`�y�уo���[��������Z���W�ړ���

  ;01/05/04 HN S-ADD
  ;@TEST@(if (= nil &eEn)
  ;@TEST@  (progn
  ;@TEST@    (setq #d1 (getpoint "\n1�_��:"))
  ;@TEST@    (setq #d2 (getcorner #d1 "\n2�_��:"))
  ;@TEST@    (command "_.RECTANG" #d1 #d2)
  ;@TEST@    (setq &eEn (entlast))
  ;@TEST@  )
  ;@TEST@)
  ;01/05/04 HN E-ADD

  ;�W�J���}�}��
(princ "\n�}���O��������������������������������������������������������������")
  ; 01/05/04 HN S-MOD �̈�}�`�̔����ǉ�
  ;@MOD@(command "_.INSERT" &sMfile "0,0" "1" "1" "0")
  (if &eEn
    (progn
;;;      (command "_.INSERT" &sMfile "0,0" 1 1 "0");2020/03/13 YM MOD
      (command "_.INSERT" &sMfile '(0 0 0) 1 1 0) ;2020/03/13 YM MOD
    )
    (progn
      (prompt "\n�}���ʒu���w��: ")

(princ "\n�}�����O�@��������������������������������������������������������������")

;;;      (command "_.INSERT" &sMfile PAUSE 1 1 "0")
      (command "_.INSERT" &sMfile PAUSE 1 1 0)

(princ "\n�}����@�@��������������������������������������������������������������")

    )
  )
  ; 01/05/04 HN E-MOD �̈�}�`�̔����ǉ�
  (setq #sHnd (cdr (assoc 5 (entget (entlast))))) ; 01/05/09 HN ADD
  (command "_.EXPLODE" (entlast))
  ;�K�v�Ȑ}�ʎ�ނ��l��
  (setq #xSp (ssget "P"))

  (setq #iI 0)
  (repeat (sslength #xSp)
    (setq #eEn (ssname #xSp #iI))
    (setq #sName (cdr (assoc 2 (entget #eEn))))
    (if (equal (substr #sName 2) &SCFind)
      (progn
        (setq #sView (substr #sName 1 1))
        (setq #eEx #eEn)
      )
      (setq #Del$ (cons #eEn #Del$))
    )
    (setq #iI (1+ #iI))
  )
  (mapcar 'entdel #Del$)
  (command "_.EXPLODE" #eEx)
  (setq #xSe (ssget "P"))

	;2015/05/20 YM ADD �V��w�ύX����(�V�̉�w��"0"�ɂȂ��Đ��@�����܂��o�Ȃ�)
;;;	(setq #TENKAI (substr str (- (strlen &sMfile) 6) 1));"D"�Ȃ�
;;;	(cond
;;;		((= #TENKAI "A")
;;;		 	(setq #TENKAI_LAYER "")

	(CHG_TENBAN_LAYER #xSe (strcat "0_SIDE_" #sView))

  (if (/= nil #xSe)
    (progn
			; 2017/09/20 KY ADD-S
			; �t���[���L�b�`���Ή�
			(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
				(if (or (= #sView "B") (= #sView "D")) ; �W�JB�}�ƓW�JD�}�͑��ʂ̂��߃R�s�[�����}�`���ɍ폜����
					(progn
						(setq #ss (ssget "X" '((-3 ("G_DEL")))))
						(if #ss
							(progn
								(command "_.ERASE" #ss "")
								(setq #ss nil)
							);progn
						);if
					);progn
				);if
			);if
			; 2017/09/20 KY ADD-E
      ;��w�l��
      (setq #layer (strcat "0_SIDE_" #sView))
      (if &eEn      ; 01/05/04 HN ADD �̈�}�`�̔����ǉ�
        (progn
          ;�̈�̒��S���l��
          (setq #Pt$  (mapcar 'car (get_allpt_H &eEn)))
          (setq #dMin (list (apply 'min (mapcar 'car #Pt$)) (apply 'min (mapcar 'cadr #Pt$))))
          (setq #dMax (list (apply 'max (mapcar 'car #Pt$)) (apply 'max (mapcar 'cadr #Pt$))))
          (setq #dVm  (mapcar '* '(0.5 0.5 1.0) (mapcar '+ #dMin #dMax)))
          ;�}�ʈړ�
          (SCFMoveEntityLimmid #dVm #xSe #layer #sView)
        )
      )             ; 01/05/04 HN ADD �̈�}�`�̔����ǉ�

      ; 01/05/24 HN ADD ���@���̊p�x�ƍ����̕ύX������ǉ�
      ; (SCFMoveEntityLimmid)�����֐������Ĉړ�
      (KCFChgDimAngHigh #xSe)

      ;�B���̈�y�ђP��ʃv���~�e�B�u���\���b�h������
      (SCFPlanePmenTanSlid #xSe #high)
      ;�o���[���쐬
      ; 01/12/06 HN MOD �萔���O���[�o����
      ;@MOD@(DrawBaloon #xSe #layer 15000)
      (DrawBaloon #xSe #layer CG_LAYOUT_DIM_Z)
      ;���@����}
      ; 2000/07/04 ���i�} �{�H�}�̐}�ʎ�ނ������ɑ��₵��
      ; SCFDrawDimensionEx #sView CG_DimPat)
      (SCFDrawDimensionEx #sView CG_DimPat &SCFind)

			; 2017/09/14 KY ADD-S
			; �t���[���L�b�`���Ή�
			(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
				(progn
					(setq #ss (ssget "X" '((-3 ("G_DEL")))))
					(if #ss
						(progn
							(command "_.ERASE" #ss "")
							(setq #ss nil)
						);progn
					);if
				);progn
			);if
			; 2017/09/14 KY ADD-E

      ; 01/05/06 HN S-ADD �W�J�}���}�Ɛ��@���̃O���[�v��������ǉ�
      (setq #psLast (SCFGetEntsLast #sHnd))

      (setq #sGroup (strcat "0_SIDE_" #sView))
      ; 02/01/22 HN ADD �O���[�v���̂̃`�F�b�N������ǉ�
      (setq #sGroup (SCFGetGroupName #sGroup))
      (command
        "-GROUP"    ; �I�u�W�F�N�g �O���[�v�ݒ�
        "C"         ; �쐬
        #sGroup     ; �O���[�v��
        #sGroup     ; �O���[�v����
        #psLast     ; �I�u�W�F�N�g
        ""
      )
      ; 01/05/06 HN E-ADD �W�J�}���}�Ɛ��@���̃O���[�v��������ǉ�
    )
  )

  (princ)
) ;_SCFDrawExpandLayout

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetWakuScale
;;; <�����T�v>: �}�ʘg�̕\�蕶����������ړx�����߂�
;;; <�߂�l>  : �ړx
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<

(defun SCFGetWakuScale (
  /
  #xSs
  #iScale
  #Eg$
  #dTxtSize
  #ii
)

  (if (= nil (setq #xSs (ssget "X" (list '(-4 . "<AND")
                               (cons '8 "0_TITLET")
                               (cons '0 "TEXT")
                               '(-4 . "AND>")))))
    (progn
    (princ "�\�荀�ڂ̕����������擾�ł��܂���.�ړx��30�Ƃ��Ďd�l�}��}�����܂�.")
    (setq #iScale 30)
    )
    (progn
    (setq #ii 0)

    (repeat (sslength #xSs)
      (setq #Eg$ (entget (ssname #xSs #ii)))
      (if (= (substr (cdr (assoc '1 #Eg$)) 1 2) CG_LayTitleTag)
        (progn
        (setq #dTxtSize (cdr (assoc '40 #Eg$)))
        )
      )
      (setq #ii (1+ #ii))
    )
    (setq #iScale (/ #dTxtSize CG_LayTitleH))
    )
  )
#iScale
)


;<HOM>************************************************************************
; <�֐���>  : SCFMoveEntityLimmid
; <�����T�v>: �}�`��}�ʘg�̒��S�Ɉړ�
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun SCFMoveEntityLimmid (
  &viewmid    ; (LIST)     �}�ʗ̈�̒��S�_
  &sspln      ; (PICKSET)  �}�`�̑I���G���e�B�e�B
  &layer      ; (STR)      �ړ��}�`�̉�w��
  &ztype      ; (STR)      �}�ʃ^�C�v
  /
  #ss #ss$ #ext$ #extmin #extmax #minmax #sym$ #pt$ #edl$
  #eds$ #spt #h #pth #extmid #viewmid #i #en
#orthomode #osmode ;-- 2012/03/07 A.Satoh ADD ���ʐ}�̃Y���Ή�
  )

;-- 2012/03/07 A.Satoh ADD-S ���ʐ}�̃Y���Ή�
  ; ���s���[�h�̐ݒ�
	(setq #orthomode (getvar "ORTHOMODE"))
	(setvar "ORTHOMODE" 0)
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
;-- 2012/03/07 A.Satoh ADD-E ���ʐ}�̃Y���Ή�

  ; �L�b�`�� �_�C�j���O�ʂɐ}�`�𕪂���
  (setq #ss$ (DivSymByLayoutEx &layer))
  (if (= "P" &ztype)
    ; �}�ʎ�ނ����ʂ̎�
    ; �E�I�[���L���r�l�b�g�ƃt���A�L���r�l�b�g�̗������Ȃ����A
    ; (0, 0)�ʒu
    (progn
      (setq #ext$ (GetRangePlane #ss$))
      (setq #extmin (car  #ext$))
      (setq #extmax (cadr #ext$))
    )
    (progn
      (if (/= nil #ss$)
        ; �ړ��}�`�̑I���Z�b�g���擾����Ă���ꍇ
        (progn
          (setq #ext$ (GetRangeUpBas #ss$))
          ; 01/04/05 TM MOD-S �x�[�X�܂��̓A�b�p�[�}�`���Ȃ��ꍇ�̏�����ύX
          (if (or (car #ext$) (cadr #ext$))
            ; �x�[�X�}�`�܂��̓A�b�p�[�}�`�����݂���ꍇ
            (progn
              (setq #tmp$ '())
              ; �x�[�X�}�`������ꍇ
              (if (car #ext$)
                (setq #tmp$ (append #tmp$ (car #ext$)))
                ; 01/04/05 ADD �}�`���Ȃ��ꍇ�����E�����̈ʒu(0,0) �ɐݒ肷��
                (progn
                  (if (/= nil (cadr #ext$))
                    (setq #tmp$ (append #tmp$ (list (list (car (car (cadr #ext$))) 0)
                                                    (list (car (cadr (cadr #ext$))) 0))))
                  )
                )
              )
;-- 2012/03/05 A.Satoh Mod ���ʐ}�̃Y������ - S
;;;;;              ; �A�b�p�[�}�`������ꍇ
;;;;;              (if (cadr #ext$)
;;;;;                (setq #tmp$ (append #tmp$ (cadr #ext$)))
;;;;;                ; 01/04/05 ADD �}�`���Ȃ��ꍇ�����E�����̈ʒu�i0, �V�䍂���j�ɐݒ肷��
;;;;;                (setq #tmp$ (append #tmp$ (list (list (car (car (car #ext$))) CG_CeilHeight)
;;;;;                                                (list (car (cadr (car #ext$))) CG_CeilHeight))))
;;;;;              )
;-- 2012/03/30 A.Satoh Mod ���i�}�쐬�G���[ - S
;;;;;							(setq #tmp$ (append #tmp$ (list (list (car (car (car #ext$))) CG_CeilHeight)
;;;;;
;;;;;																					(list (car (cadr (car #ext$))) CG_CeilHeight))))
							(if (cadr #ext$)
								(progn
									(setq #tmp$ (append #tmp$ (list (list (car (car (cadr #ext$))) CG_CeilHeight)
																									(list (car (cadr (cadr #ext$))) CG_CeilHeight))))
								)
								(progn
									(if (car #ext$)
										(setq #tmp$ (append #tmp$ (list (list (car (car (car #ext$))) CG_CeilHeight)
																										(list (car (cadr (car #ext$))) CG_CeilHeight))))
										(setq #tmp$ (append #tmp$ (list (list 0 CG_CeilHeight) (list 0 CG_CeilHeight))))
									)
								)
							)
;-- 2012/03/30 A.Satoh Mod ���i�}�쐬�G���[ - E
;-- 2012/03/05 A.Satoh Mod ���ʐ}�̃Y������ - E
              (setq #ext$ #tmp$)
            )
          )
          ; 01/04/05 TM MOD-S �x�[�X�܂��̓A�b�p�[�}�`���Ȃ��ꍇ�̏�����ύX
          ;(setq #ext$ (apply 'append #ext$))
          (setq #minmax (GetPtMinMax #ext$))
          (setq #extmin (car  #minmax))
          (setq #extmax (cadr #minmax))
        )
        ; ���Ȃ��ꍇ
        (progn
          (setq #ss (ssget "X" (list (list -3 (list "G_SKDM")) (cons 8 &layer))))
          (setq #sym$ (SCF_B_GetSym #ss))
          (if (/= (car #sym$) nil)
            (progn
              ;(setq #pt$ (Get2PointByLay (car #sym$)))
              (setq #pt$ (Get2PointByLay (car #sym$) 1))
              (setq #edl$ (CfGetXData (car #sym$) "G_LSYM"))
              (setq #eds$ (CfGetXData (car #sym$) "G_SYM"))
              (setq #spt  (cdrassoc 10 (entget (car #sym$))))
              (setq #h    (nth 5 #eds$))
              (if (= 1 (nth 9  #eds$))
                (setq #pth (polar #spt (* 0.5 PI) #h))
                (setq #pth (polar #spt (* 1.5 PI) #h))
              )
              (setq #pt$ (cons #pth #pt$))
            )
          )
          (if (/= (caadr #sym$) nil)
            (progn
              ;(setq #pt$ (append #pt$ (Get2PointByLay (cadr #sym$))))
              (setq #pt$ (append #pt$ (Get2PointByLay (cadr #sym$) 1)))
              ; 2000/06/11 HT �b��Ή�  �A�b�p�[�͕����擾�ł��邪�P�߂��g��
        ;   (setq #edl$ (CfGetXData (cadr #sym$) "G_LSYM"))
              ;(setq #eds$ (CfGetXData (cadr #sym$) "G_SYM"))
              ;(setq #eds$ (CfGetXData (car(cadr #sym$)) "G_SYM"))
              ; 2000/06/20 HT �A�b�p�[�͕����擾�ł���̂ŁA���ׂĂ̍����Ŕ�r����(06/11�̎b��Ή�����)
              (mapcar '(lambda (#ss2)
                (setq #eds$ (CfGetXData #ss2 "G_SYM"))
                (setq #spt  (cdrassoc 10 (entget (car(cadr #sym$)))))
                (setq #h    (nth 5 #eds$))
                (if (= 1 (nth 9  #eds$))
                  (setq #pth (polar #spt (* 0.5 PI) #h))
                  (setq #pth (polar #spt (* 1.5 PI) #h))
                )
                (setq #pt$ (cons #pth #pt$))
                )
                (cadr #sym$)
              ) ;mapcar
            )
          )

          (setq #minmax (GetPtMinMax #pt$))
          (setq #extmin (car  #minmax))
          (setq #extmax (cadr #minmax))
        )
      )
    )
  )

  (setq #extmid (mapcar '+ #extmin (mapcar '* (list 0.5 0.5) (mapcar '- #extmax #extmin))))

  ;���ʐ}�}�`�̈ړ�
  (setq #extmid  (list (car #extmid)  (cadr #extmid)))
  (setq #viewmid (list (car &viewmid) (cadr &viewmid)))
  (command "_move" &sspln "" #extmid #viewmid)

  ; 01/05/24 HN S-DEL �֐���(KCFChgDimAngHigh)���Ė{�֐��̊O��
  ;@DEL@;���@��������Ή�]�p�x���O�ɂ���
  ;@DEL@;���@��������΍�����10000�ɂ���
  ;@DEL@(setq #i 0)
  ;@DEL@(repeat (sslength &sspln)
  ;@DEL@  (setq #en (ssname &sspln #i))
  ;@DEL@  (if (equal "DIMENSION" (cdr (assoc 0 (entget #en))))
  ;@DEL@    (progn
  ;@DEL@      (SCFEntmodFindDimension #en)
  ;@DEL@      (princ)
  ;@DEL@    )
  ;@DEL@  )
  ;@DEL@  (setq #i (1+ #i))
  ;@DEL@)
  ; 01/05/24 HN E-DEL �֐���(KCFChgDimAngHigh)���Ė{�֐��̊O��

;-- 2012/03/07 A.Satoh ADD-S ���ʐ}�̃Y���Ή�
  ; ���s���[�h��߂�
	(setvar "ORTHOMODE" #orthomode)
	(setvar "OSMODE" #osmode)
;-- 2012/03/07 A.Satoh ADD-E ���ʐ}�̃Y���Ή�

  (princ)
) ; SCFMoveEntityLimmid

;<HOM>************************************************************************
; <�֐���>  : SCFEntmodFindDimension
; <�����T�v>: �e�W�J�}�Ɋ����̐��@�}�`�����[���h���W�n�ŕ\������
; <�߂�l>  : �Ȃ�
; <���l>    : ������15000�ɂ���
;************************************************************************>MOH<

(defun SCFEntmodFindDimension (
  &en         ; (ENAME)    �����̐��@�}�`��
  /
  #eg #subst #no #pt #pt_n
  )
  (setq #eg (entget &en '("*")))
  ; ��]�p�x
  (if (assoc 51 #eg)
    (setq #subst (subst (cons 51 0.0) (assoc 51 #eg) #eg))
    (setq #subst (append #eg (list (cons 51 0.0))))
  )

  ;�����o������
  (setq #subst (subst (cons 210 '(0.0 0.0 1.0)) (assoc 210 #subst) #subst))

  ;�R�����g�A�E�g00/03/14
  ;������15000�ɂ���
;  (mapcar
;   '(lambda ( #no )
;      (setq #pt (cdrassoc #no #subst))
;      (if (/= nil #pt)
;        (progn
;          (setq #pt_n (list (car #pt) (cadr #pt) 15000.0))
;          (setq #subst (subst (cons #no #pt_n) (assoc #no #subst) #subst))
;        )
;      )
;    )
;   '(10 11 12 13 14)
;  )
  ; �}�`�X�V
  (entmod #subst)

  ; 01/01/30 HN DEL ���@���̕����������폜
  ;DEL;�����̐��@�͉B���Ή�����悤�ɕ����Ɍ��݂������� 99/0423 S.Kawamoto
  ;DEL(SCFSetThickDimText &en)

  (princ)
) ; SCFEntmodFindDimension


;<HOM>************************************************************************
; <�֐���>  : SCFSetThickDimText
; <�����T�v>: ���@���𕪉����A�܂܂�镶���Ɍ��݂�����B�i�B���p�j
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun SCFSetThickDimText (
  &en
  /
  #ss #i #eg #en
  )
  (command "_explode" &en)
  (setq #ss (ssget "P"))
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i))
    (setq #eg (entget #en))
    (if (= "MTEXT" (cdr (assoc 0 #eg)))
      (progn
        (command "_explode" (ssname #ss #i))
        (setq #en (ssname (ssget "P") 0))
        (command "_change" #en "" "P" "T" 1 "")
      )
      (progn
        (command "_change" #en "" "P" "C" "CYAN" "")
      )
    )
    (setq #i (1+ #i))
  )
) ; SCFSetThickDimText


;<HOM>************************************************************************
; <�֐���>  : SCFPlanePmenTanSlid
; <�����T�v>: �B���̈�y�ђP�������è�ނ�د�މ�����
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun SCFPlanePmenTanSlid (
  &sspln      ; (PICKSET)�Ώې}�`�̑I���èè
  &high       ; (REAL)   �����o������
  /
  ##CopyExtrude #i #en #eed$
  )
  ;�}�`�����o��
  ;   +==================================================================+
  ;   |   �}�`�������o������ƕʐ}�`�ɂȂ�̂ŉ�w�A�F�A���킪���ꂼ��   |
  ;   |   "0","BYLAYER","BYLAYER"�ɕς���Ă��܂�                        |
  ;   |   ���̂��ߌ��̑����ɍĐݒ肵�Ă��Ȃ��Ă͂����Ȃ�               |
  ;   +==================================================================+
  (defun ##CopyExtrude (
    &en   ; (ENAME) �����o���}�`��
    &high ; (REAL)  �����o������
    /
    #eg #8 #6 #62 #exen #exeg #subst
    )
    (setq #eg (entget #en '("*")))
    (setq #8  (cdr (assoc 8  #eg)))
    (setq #6  (cdr (assoc 6  #eg)))
    (setq #62 (cdr (assoc 62 #eg)))
    (if (= nil #62)
      (setq #62 256)
    )
    (entmake #eg)
    (setq #exen (entlast))
    ;�����o��
;;;    (command "_extrude" #exen "" &high "0");2008/08/06 YM ADD
    (command "_extrude" #exen "" &high );2008/08/06 YM ADD
    (setq #exen (entlast))
    (setq #exeg (entget #exen))
    ;; �B���̈�͔�\���Ƃ���
    (setq #subst (subst (cons 8 "O_HIDE")(assoc 8 #exeg)#exeg))
    ;����ύX
    (if (/= nil #6)
      (if (assoc 6 #exeg)
        (setq #subst (subst (cons 6 #6)(assoc 6 #subst)#subst))
        (setq #subst (append #subst (list (cons 6 #6))))
      )
    )
    ;�F�ύX
    (if (assoc 62 #exeg)
      (setq #subst (subst (cons 62 #62)(assoc 62 #subst)#subst))
      (setq #subst (append #subst (list (cons 62 #62))))
    )
    (entmod #subst)
  )

  (setq #i 0)
  (repeat (sslength &sspln)
    (setq #en (ssname &sspln #i))
    (setq #eed$ (cdr (assoc -3 (entget #en '("*")))))
    (if (and (/= nil #eed$) (listp #eed$))
      (cond
        ((assoc "G_PMEN" #eed$)
          (setq #eed$ (assoc "G_PMEN" #eed$))
          (if (= 1 (cdr (nth 1 #eed$)))
            (##CopyExtrude #en &high)
          )
        )
        ((assoc "G_PRIM" #eed$)
          (setq #eed$ (assoc "G_PRIM" #eed$))
          (if (and (= 3 (cdr (nth 1 #eed$))) (= 1 (cdr (nth 4 #eed$))))
            (##CopyExtrude #en &high)
          )
        )
        (T     nil)
      )
    )
    (setq #i (1+ #i))
  )

  (princ) ; return
) ; SCFPlanePmenTanSlid


;;;<HOM>************************************************************************
;;; <�֐���>  : SCFMakeTitleText
;;; <�����T�v>: �}�ʘg�̃^�C�g������}����
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : ��w"0_TITLET"�̕����}�`���������ĕύX���܂��B
;;;             01/11/30 HN �S�ʉ��� ���ʂȕϐ��Ə������o�b�T���폜
;;;             02/03/17 HN <NAS>�{�H�X�ƍ\�����l��ǉ�
;;;************************************************************************>MOH<
(defun SCFMakeTitleText
  (
  &sTitle     ; �}�ʘg�p�^�C�g��  "���i�}"�^"�{�H�}"�^"�p�[�X�}"  �����g�p��
  /
  #sTitle$    ; �^�C�g����������
  #sTitle$$   ; �L�[������ƃ^�C�g��������̏��
  #iCnt       ; �J�E���^
  #psTitle    ; �}�ʓ��̃^�C�g�������}�`�̑I���Z�b�g
  #ent$       ; �}�`���
  #sKey$      ; �L�[������
  #sKey       ; �L�[������
  #sTitle     ; �^�C�g��������
#plan_name ;2010/12/13 YM ADD
  )
  ; �^�C�g��������l��
  (setq #sTitle$ CG_TitleStr)

;2010/12/10 YM MOD-S
;;; (setq CG_TitleStr 
;;;   (list
;;;     "���������́�" (0)
;;;     "���v�����ԍ���"
;;;     "���v�������́�"<===�ǉ�(2)
;;;     "���ǔԁ�"
;;;     "���c�Ə�����"   (3)-->(4)
;;;     "���c�ƒS����"   (4)-->(5)
;;;     "�����ϒS����"   (5)-->(6)
;;;     "���o�[�W������" (6)-->(7)

  ;2010/12/13 YM ADD-S
  (setq #plan_name (nth  2 #sTitle$))
  (if (= nil #plan_name)(setq #plan_name ""))
  ;2010/12/13 YM ADD-E

  (setq #sTitle$$
    (list
      (list "T^�쐬��"        (menucmd "M=$(edtime,$(getvar,date),YYYY.MO.DD)"));�������쐬��
      (list "T^�}��"          (strcat (nth  1 #sTitle$)(nth  3 #sTitle$)))      ; ���v�����ԍ���&���ǔԁ�
      (list "T^��������"      (strcat (nth  0 #sTitle$) "�^" #plan_name) )      ;��������������
      (list "T^�v������"      "")
      (list "T^�����R�[�h"    "")
      (list "T^����"          "")
      (list "T^�n��"          "")
      (list "T^���[�N�g�b�v"  "")
      (list "T^��"            "")
      (list "T^�c�ƒS��"      (nth  5 #sTitle$));�������c�ƒS��
      (list "T^���ϒS��"      (nth  6 #sTitle$));����������(�ώZ)�S��
      (list "T^�o�[�W����"    (nth  7 #sTitle$))
      (list "T^���[�N�g�b�v2" "")
      (list "T^�V�X�e����"    "")
      (list "T^��Ж�"        "")
      (list "T^�݌v�v����"    "")
      (list "T^�c�Ə�"        (nth 4 #sTitle$));�������c�Ə�
      (list "T^�{�H�X"        "")
      (list "T^�\�����l"      "")
    );_list
;2010/12/10 YM MOD-E

;;;  (setq #sTitle$$
;;;    (list
;;;      (list "T^�쐬��"        (menucmd "M=$(edtime,$(getvar,date),YYYY.MO.DD)"));�������쐬��
;;;      (list "T^�}��"          (strcat (nth  1 #sTitle$)(nth  2 #sTitle$)))      ; ���v�����ԍ���&���ǔԁ�
;;;      (list "T^��������"      (nth  0 #sTitle$));��������������
;;;      (list "T^�v������"      "")
;;;      (list "T^�����R�[�h"    "")
;;;      (list "T^����"          "")
;;;      (list "T^�n��"          "")
;;;      (list "T^���[�N�g�b�v"  "")
;;;      (list "T^��"            "")
;;;      (list "T^�c�ƒS��"      (nth  4 #sTitle$));�������c�ƒS��
;;;      (list "T^���ϒS��"      (nth  5 #sTitle$));����������(�ώZ)�S��
;;;      (list "T^�o�[�W����"    (nth  6 #sTitle$))
;;;      (list "T^���[�N�g�b�v2" "")
;;;      (list "T^�V�X�e����"    "")
;;;      (list "T^��Ж�"        "")
;;;      (list "T^�݌v�v����"    "")
;;;      (list "T^�c�Ə�"        (nth 3 #sTitle$));�������c�Ə�
;;;      (list "T^�{�H�X"        "")
;;;      (list "T^�\�����l"      "")
;;;    );_list


  );_setq
  ;@DEBUG@(princ "\n�v�����S��: ")(princ (nth  8 #sTitle$)) ; 01/12/25 HN
  ;@DEBUG@(getstring "\ncheck: ")

  ; �}�ʓ��̃^�C�g��������ύX
;-- 2011/09/21 A.Satoh Add - S
  (if (= nil (tblsearch "APPID" "G_ZUWAKU")) (regapp "G_ZUWAKU"))
;-- 2011/09/21 A.Satoh Add - E
  (setq #iCnt 0)
  (setq #psTitle (ssget "X" (list (cons 8 "0_TITLET") (cons 0 "TEXT"))))
  (if #psTitle
    (repeat (sslength #psTitle)
      (setq #ent$   (entget (ssname #psTitle #iCnt)))
      (setq #sKey$  (assoc 1 #ent$))
      ; 02/01/08 HN MOD �����ύX
      ;@MOD@(setq #sTitle (cadr (assoc (cdr #sKey$) #sTitle$$)))
      (setq #sKey   (cdr #sKey$))
      (setq #sTitle (cadr (assoc #sKey #sTitle$$)))
      (if (= nil #sTitle) (setq #sTitle ""))      ; 01/12/25 HN ADD
      ; 02/01/08 HN MOD �����ύX
      ;@MOD@(if (= 'STR (type #sTitle))
;-- 2011/09/21 A.Satoh Mod - S
;;;;;      (if (and (= 'STR (type #sTitle)) (= "T^" (substr #sKey 1 2)))
;;;;;        (entmod (subst (cons 1 #sTitle) #sKey$ #ent$))
;;;;;      )
      (if (and (= 'STR (type #sTitle)) (= "T^" (substr #sKey 1 2)))
        (progn
          (cond
            ((= #sKey "T^�}��")
              (entmod (append (subst (cons 1 #sTitle) #sKey$ #ent$) (list (list -3 (list "G_ZUWAKU" (cons 1000 "MITSUN"))))))
            )
            ((= #sKey "T^��������")
              (entmod (append (subst (cons 1 #sTitle) #sKey$ #ent$) (list (list -3 (list "G_ZUWAKU" (cons 1000 "BUKKEN"))))))
            )
            ((= #sKey "T^�c�ƒS��")
              (entmod (append (subst (cons 1 #sTitle) #sKey$ #ent$) (list (list -3 (list "G_ZUWAKU" (cons 1000 "EIGYOT"))))))
            )
            ((= #sKey "T^���ϒS��")
              (entmod (append (subst (cons 1 #sTitle) #sKey$ #ent$) (list (list -3 (list "G_ZUWAKU" (cons 1000 "MITSUT"))))))
            )
            ((= #sKey "T^�c�Ə�")
              (entmod (append (subst (cons 1 #sTitle) #sKey$ #ent$) (list (list -3 (list "G_ZUWAKU" (cons 1000 "EIGYOS"))))))
            )
            (T
              (entmod (subst (cons 1 #sTitle) #sKey$ #ent$))
            )
          )
        )
      )
;-- 2011/09/21 A.Satoh Mod - E
      (setq #iCnt (1+ #iCnt))
    );_repeat
  );_if

  (princ)
);_defun


;<HOM>************************************************************************
; <�֐���>  : ExceptToList
; <�����T�v>: ���X�g���̓����v�f�����O����
; <�߂�l>  : ���O�������X�g
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun ExceptToList (
  &list$      ; ���X�g
  /
  #work$ #elm #list_new$
  )
  (setq #work$ nil)
  (mapcar
   '(lambda ( #elm )
      (if (not (member #elm #work$))
        (progn
          (setq #list_new$ (cons #elm #list_new$))
          (setq #work$     (cons #elm #work$))
        )
      )
    )
    &list$
  )

  (reverse #list_new$)
) ; ExceptToList

;<HOM>************************************************************************
; <�֐���>  : DEL_DOOR_PLIN3
; <�����T�v>: �߰��}����A�������(G_PLIN 3)���폜
; <�߂�l>  : �Ȃ�
;             06/04/03 YM �֐���
; <���l>    : �Ȃ�
;************************************************************************>MOH<
(defun DEL_DOOR_PLIN3 (
  /
  #I #SS
  )
  (setq #ss (ssget "X" (list (list -3 (list "G_PLIN")))))
  (if #ss
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (if (= (nth 0 (CFGetXData (ssname #ss #i)  "G_PLIN")) 3)
          (entdel (ssname #ss #i))
        )
        (setq #i (1+ #i))
      )
    )
  )
  (princ)
);DEL_DOOR_PLIN3

;<HOM>************************************************************************
; <�֐���>  : SCFDrawPersLayout
; <�����T�v>: ���C�A�E�g�}�쐬  �p�[�X�}
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun SCFDrawPersLayout (
  &sFname     ; �W�J���}�t�@�C����
  &sView      ; ���_��
  /
  #layer #deg #deg2
  #8 #DEGZ #DIST #EG$ #I #INI$$ #SSVIEW #TAIMEN_FLG #VID69L #VID69R #XDEG #ZDEG
	#ORTHOMODE #OSMODE ;2012/02/15 YM ADD
  )

	;2012/02/15 YM ADD-S ��׈ʒu�ƖڕW�_�̊֌W���s�K�؂ł�
  ; ���s���[�h�̐ݒ�
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 0)
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	;2012/02/15 YM ADD-E

  (if (findfile &sFname)
    (progn
      ;���f����ԂɈړ�
      (setvar "TILEMODE" 1)
      ;���f���}�ʑ}��
			;2015/03/25 YM MOD-S
;;;      (command "_.INSERT" &sFname "0,0,0" 1 1 "0")
      (command "_.INSERT" &sFname "0,0,0" "1" "1" "0")
			;2015/03/25 YM MOD-E

      (command "_.explode" (entlast))
      ;�������f����ԂɈړ�
      (setvar "TILEMODE" 0)
      (command "_.MSPACE")

      ;2009/01/20 YM ADD-S
      (DEL_DOOR_PLIN3);�߰��}�̏ꍇ�A���J����"G_PLIN"3���폜����
      ;2009/01/20 YM ADD-E

			;2015/03/25 YM ADD-S DVIEW�Ńt���[�Y���Ă��܂��̂Ŗ͗l���������t���[�Y
;;;			(command "_.layer" "F" "0_PERS" "")
			(command "_regen")

      (if (/= nil &sView)
        (progn
          ;���_�Ăяo��
          ;---  �ҏW 99/12/01 ---
          ;(command "_.VIEW" "R" &sView)

          ;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
;;;         (if (or (= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; JPG�o��Ӱ�ޒǉ� 03/02/22 YM ADD


          ; �����������Ұ���scplot.cfg����擾��
          (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
          (if #ini$$
            (progn
              (setq #XDEG (cadr (assoc "XDEG" #ini$$))) ;X������̊p�x
              (setq #ZDEG (cadr (assoc "ZDEG" #ini$$))) ;XY���ʂ���̊p�x
              (setq #DIST1 (cadr (assoc "DIST1" #ini$$))) ;�ڕW����̋���<�ΖʈȊO>
              (setq #DIST2 (cadr (assoc "DIST2" #ini$$))) ;�ڕW����̋���<�Ζ�>
            )
          );_if

          ; ���Ұ����擾�ł��Ȃ��ꍇ�͏����l
          (if (= nil #XDEG)(setq #XDEG   "0.0"))
          (if (= nil #ZDEG)(setq #ZDEG   "0.0"))
          (if (= nil #DIST1)(setq #DIST1 "0.0"))
          (if (= nil #DIST2)(setq #DIST2 "0.0"))


          (if (member CG_AUTOMODE '(4 5));2008/08/05 YM MOD
            (progn ;�����͂Ƃ���Ȃ�

              (if (or (equal "L-LEFT" &sView) (equal "W-RIGHT" &sView))
                (setq #deg (+ -110 (atof #XDEG))) ; ������
                (setq #deg  (- -70 (atof #XDEG))) ; �E����
              );_if

              (setq #degZ (+ 15 (atof #ZDEG)))   ;XY���ʂ���̊p�x
              (setq #dist (+ 5500 (atof #dist))) ;�ڕW����̋���
            )
            ; else
            (progn

              ;2008/08/14 YM ADD ��"TEXT"�̑��݂��߰��ʒu������邽�ߍ폜����
              (Textdel)

              (cond
                ((or (equal "L-LEFT" &sView)(equal "I-LEFT" &sView))
                  (setq #deg  (+ -130 (atof #XDEG))) ; I�^������
                  (setq #deg2 (-  130 (atof #XDEG))) ; I�^������ �Ζʂ����ݸޑ�
                )
                ((or (equal "L-RIGHT" &sView)(equal "I-RIGHT" &sView))
                  (setq #deg  (- -50 (atof #XDEG))) ; I�^�E����
                  (setq #deg2 (+  50 (atof #XDEG))) ; I�^�E���� �Ζʂ����ݸޑ�
                )
                (T
                  (setq #deg (+ -130 (atof #XDEG))) ; ?������
                )
              );_cond

            )

          );_if

          ; 02/01/19 HN ADD �p�[�X�}�̃J�������_���V���N�L���r�l�b�g�̔z�u�p�x�Ŕ��f
          (setq #deg (+ #deg CG_AngSinkCab))

          ; 02/01/21 HN ADD
          (cond
            ((<  900 #deg) (setq #deg (- #deg 1080))); 03/07/03 YM ADD-S
            ((<  720 #deg) (setq #deg (- #deg 900))); 03/07/03 YM ADD-S
            ((<  540 #deg) (setq #deg (- #deg 720))); 03/07/03 YM ADD-S
            ((<  360 #deg) (setq #deg (- #deg 540))); 03/07/03 YM ADD-S
            ((<  180 #deg) (setq #deg (- #deg 360)))
            ((> -900 #deg) (setq #deg (+ #deg 1080))); 03/07/03 YM ADD-E
            ((> -720 #deg) (setq #deg (+ #deg 900))); 03/07/03 YM ADD-E
            ((> -540 #deg) (setq #deg (+ #deg 720))); 03/07/03 YM ADD-E
            ((> -360 #deg) (setq #deg (+ #deg 540))); 03/07/03 YM ADD-E
            ((> -180 #deg) (setq #deg (+ #deg 360)))
          )

;;;(setvar "cmdecho" 1) ; ����ײ�
          ;(command "_.DVIEW" "ALL" "" "O" "X")

          ; ����Ŵװ���o�Ȃ��Ȃ�̂ŗl�q������;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
;;;         (if (or (= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; JPG�o��Ӱ�ޒǉ� 03/02/22 YM ADD
          (if (member CG_AUTOMODE '(4 5));2008/08/05 YM MOD
            (progn ;�����͂Ƃ���Ȃ�
              ;04/04/14 YM MOVE-S if���̒��Ɉړ�
              (command "_vpoint" "0,0,1")
              (command "_.ZOOM" "E")
              (command "_.ZOOM" "0.1X")
              ;04/04/14 YM MOVE-E if���̒��Ɉړ�
              (command "_.DVIEW" "ALL" "" "PO" "0,0,0" "1000,-1000,0" "CA" #degZ #deg "X") ; 03/02/22 YM MOD
              (command "_.ZOOM" "E")
              (command "_.DVIEW" "ALL" "" "D" #dist "X")
            )
            (progn
              ;04/04/14 YM ADD-S �Ζʗp2�ޭ��߰����������Ή�
              ;�Ζʗp�ޭ��߰Ă����邩�ǂ�������
              (setq #ssVIEW (ssget "X" '((0 . "VIEWPORT"))))
              (setq #i 0)
              (setq #TAIMEN_FLG nil)
              (if (and #ssVIEW (< 0 (sslength #ssVIEW)))
                (progn
                  (repeat (sslength #ssVIEW)
                    (setq #eg$ (entget (ssname #ssVIEW #i)))
                    (setq #8 (cdr (assoc  8 #eg$)));��w
                    (if (= #8 "VIEWL");�Ζʗp����ڰĂ��ޭ��߰ĉ�w(��������)
                      (progn
                        (setq #TAIMEN_FLG T);�Ζʗp������
                        (setq #VID69L (cdr (assoc 69 #eg$))) ; VIEWPORT ID
                      )
                    );_if
                    (if (= #8 "VIEWR");�Ζʗp����ڰĂ��ޭ��߰ĉ�w(�E�����ݸ�)
                      (progn
                        (setq #TAIMEN_FLG T);�Ζʗp������
                        (setq #VID69R (cdr (assoc 69 #eg$))) ; VIEWPORT ID
                      )
                    );_if
                    (setq #i (1+ #i))
                  )
                )
              );_if




              (if #TAIMEN_FLG
                (progn ;�Ζ�

                  (setq #degZ (+ 15 (atof #ZDEG)))    ;XY���ʂ���̊p�x
                  (setq #dist (+ 7000 (atof #DIST2))) ;�ڕW����̋���

                  (setvar "CVPORT" #VID69L); �ޭ��߰�ID (��������)�ɐ؂�ւ����ޭ��̒���
                  (command "_vpoint" "0,0,1")
                  (command "_.ZOOM" "E")
                  (command "_.ZOOM" "0.1X")
                  (command "_.DVIEW" "ALL" "" "PO" "0,0,0" "-1000,-1000,0" "CA" #degZ #deg "X")
                  (command "_.ZOOM" "E")
                  (command "_.DVIEW" "ALL" "" "D" #dist "X")
                  ;2008/09/05 YM ADD �߂����ς��Y�[������
                  (command "_.ZOOM" "E")


                  (setvar "CVPORT" #VID69R); �ޭ��߰�ID (�E�����ݸ�)�ɐ؂�ւ����ޭ��̒���
                  (command "_vpoint" "0,0,1")
                  (command "_.ZOOM" "E")
                  (command "_.ZOOM" "0.1X")
                  (command "_.DVIEW" "ALL" "" "PO" "0,0,0" "-1000,1000,0" "CA" #degZ #deg2 "X")
                  (command "_.ZOOM" "E")
                  (command "_.DVIEW" "ALL" "" "D" #dist "X")
                  ;2008/09/05 YM ADD �߂����ς��Y�[������
                  (command "_.ZOOM" "E")

                )
                (progn ;�ΖʈȊO

                  (setq #degZ (+ 15 (atof #ZDEG)))     ;XY���ʂ���̊p�x
                  (setq #dist (+ 10000 (atof #DIST1))) ;�ڕW����̋���

                  ;�ʏ�(���܂�)
                  ;04/04/14 YM MOVE-S �ȉ��O�����߰
                  (command "_vpoint" "0,0,1")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 001")

                  (command "_.ZOOM" "E")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 002")

                  (command "_.ZOOM" "0.1X")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 003")

                  ;04/04/14 YM MOVE-E �ȉ��O�����߰
                  (command "_.DVIEW" "ALL" "" "PO" "0,0,0" "1000,-1000,0" "CA" #degZ #deg "X") ; 02/04/25 YM MOD ORG
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 004")

                  (command "_.ZOOM" "E")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 005")

                  (command "_.DVIEW" "ALL" "" "D" #dist "X")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 006")

                  ;2008/09/05 YM ADD �߂����ς��Y�[������
                  (command "_.ZOOM" "E")
									(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 007")

                )
              );_if
            )
          );_if

          ;---  �ҏW 99/12/01 ---
          ;�y�[�p�[��ԂɈړ�
          (command "_.PSPACE")
        )
      );_if

			;2015/03/25 YM ADD-S DVIEW�Ńt���[�Y���Ă��܂��̂Ŗ͗l���������t���[�Y
;;;			(command "_.layer" "T" "0_PERS" "");�t���[�Y����
			(command "_regen")


    )
  );_if

	;2012/02/15 YM ADD-S ��׈ʒu�ƖڕW�_�̊֌W���s�K�؂ł�
  ; ���s���[�h��߂�
  (setvar "ORTHOMODE" #orthomode)
	(setvar "OSMODE" #osmode)
	;2012/02/15 YM ADD-E

  (princ)
) ; SCFDrawPersLayout

;<HOM>************************************************************************
; <�֐���>  : SCFDrawPersLayout2
; <�����T�v>: ���C�A�E�g�}�쐬  �p�[�X�}
; <�߂�l>  : T  :�}������
;             nil:�}�����Ă��Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<
(defun SCFDrawPersLayout2 (
	&kitType    ;(STR)���_������`(L-LEFT,W-RIGHT��)
	/
	#ssView
	#enView
	#file
	#enLay
	#viewId
	#p1 #p2
	#ss
	#ang
	#extmin #extmax
	#dist
	#ang #dist #layView #no
	#en #eg
	#drawFlg
	#vs$
	#fileL$ #fileL$$
	#i
#orthomode #osmode ;-- 2012/02/28 A.Satoh Add
	)
	;���C�A�E�g��Ԃɐ؂�ւ���
	(setvar "TILEMODE" 0)

	;2012/02/28 A.Satoh ADD-S ��׈ʒu�ƖڕW�_�̊֌W���s�K�؂ł�
  ; ���s���[�h�̐ݒ�
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 0)
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	;2012/02/28 A.Satoh ADD-E ��׈ʒu�ƖڕW�_�̊֌W���s�K�؂ł�

	;VIEWPORT�}�`���擾����
	(setq #ssView (ssget "X" '((0 . "VIEWPORT"))))
	;VIEWPORT�}�`�����������s��
	(foreach #enView (Ss2En$ #ssView)
		(setq #layView (cdr (assoc 8 (entget #enView))))
		;��w��VIEW�Ŏn�܂�ꍇ
		(if (= (substr #layView 1 4) "VIEW")
			(progn
				;��w��VIEW�̔ԍ����擾����
				(setq #no (substr #layView 5 1))
				;�����݂�"VIEWL","VIEWR"
				(if (= #no "L")(setq #no "1"))
				(if (= #no "R")(setq #no "2"))

				;���̔ԍ������ɃC���T�[�g����}�`�̉�w���쐬����
				(MakeLayer (strcat "0_PERS_" #no) 7 "CONTINUOUS")
				;��w���X�g���o���Ă���
				(setq #enLay (strcat "0_PERS_" #no))
				;VIEWPORT��ID���X�g���o���Ă���
				(setq #viewId (cdr (assoc 69 (entget #enView))))

				;�}������p�[�X�}�`�t�@�C�������X�g���o���Ă���
				(setq #file nil)
				(if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" "M_" #no ".dwg"))
					(setq #file (strcat CG_KENMEI_PATH "BLOCK\\" "M_" #no ".dwg"))
					(progn
						(if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" "M_0.dwg"))
							(setq #file (strcat CG_KENMEI_PATH "BLOCK\\" "M_0.dwg"))
						)
					)
				)
				(setq #fileL$$ (cons (list #enView #enLay #viewId #file) #fileL$$))
			)
		)
	)
	;VIEWPORT�}�`�������[�v����
;(dpr '#enView$)
;(dpr '#enLay$)
;(dpr '#viewId$)
;(dpr '#file$)
	(foreach #fileL$ #fileL$$
		(setq #enView (nth 0 #fileL$))
		(setq #enLay (nth 1 #fileL$))
		(setq #viewId (nth 2 #fileL$))
		(setq #file (nth 3 #fileL$))
		;��w��VIEW�Ŏn�܂�}�`�̏ꍇ�ɏ������s��
		(if (and #file (findfile #file))
			(progn
				(WebOutLog "�p�[�X�̐}�`��}�����܂�")
				(princ "\n�p�[�X�̐}�`��}�����܂�")

				(command "_.MSPACE")
				(setvar "CVPORT" #viewId)    ;VIEW�̐؂�ւ�

				;���ɔz�u����Ă���Έ�U�폜����
				(foreach #en (Ss2En$ (ssget "X" (list (cons 8 #enLay))))
					(entdel #en)
				)
				;�p�[�X�}�`�t�@�C����}������
				(command "_.INSERT" #file "0,0,0" "1" "1" "0")
				(command "_.explode" (entlast))
				(WebOutLog "�p�[�X�̐}�`����w�̕ύX���܂�")
				(princ "\n�p�[�X�̐}�`����w�̕ύX���܂�")

				;��w�̕ύX
				(foreach #en (Ss2En$ (ssget "P"))
					(setq #eg (entget #en))
					(entmod (subst (cons 8 #enLay) (assoc 8 #eg) #eg))
				)

				;06/04/03 YM MOD �֐���
				(DEL_DOOR_PLIN3)


;06/04/03 YM DEL-S �֐���
;;;        (setq #ss (ssget "X" (list (list -3 (list "G_PLIN")))))
;;;        (if #ss
;;;          (progn
;;;            (setq #i 0)
;;;            (repeat (sslength #ss)
;;;              (if (= (nth 0 (CFGetXData (ssname #ss #i)  "G_PLIN")) 3)
;;;                (entdel (ssname #ss #i))
;;;              )
;;;              (setq #i (1+ #i))
;;;            )
;;;          )
;;;        )
;06/04/03 YM DEL-E �֐���

				;�r���[�|�[�g���ő}��������w�ȊO�̓t���[�Y����
				(command "_.VPLAYER" "F" "*" "C" "")
				(command "_.VPLAYER" "T" #enLay "C" "")

				;�p�[�X����王�_�p�x�����擾���č폜����
				(setq #ss (ssget "X" '((-3 ("RECTPERS")))))
				(if (and #ss (= (sslength #ss) 1))
					(progn
						(setq #ang (nth 1 (CFGetXData (ssname #ss 0) "RECTPERS")))
						;�p�[�X��͗v��Ȃ��̂ō폜���Ă���
						(entdel (ssname #ss 0))
					)
				;else
					(progn
						(if (or (equal "L-LEFT" &kitType) (equal "W-RIGHT" &kitType))
							(setq #ang  50) ; ������
							(setq #ang 130) ; �E����
						)
						;�p�[�X�}�̃J�������_���V���N�L���r�l�b�g�̔z�u�p�x�Ŕ��f
						(setq #ang (rtos (+ #ang CG_AngSinkCab)))
					)
				)

				(command "_.LAYER" "F" "0_PERS*" "")
				(command "_.LAYER" "T" #enLay "")

				(command "_.REGEN")   ;�t���[�Y���EXTMIN,MAX��L���ɂ��邽��
				(setq #extmin (getvar "EXTMIN"))
				(setq #extmax (getvar "EXTMAX"))

				;�r���[�T�C�Y���擾����
				(setq #vs$ (GetViewSize))

				;�r���[�̏c���䗦�ɂ��A�����𒲐�����
				(if (> (- (cadr #vs$) (car #vs$)) (- (nth 3 #vs$) (nth 2 #vs$)))
					;�����r���[�̎�
					(setq #dist (* 2.2 (distance #extmin #extmax)))
					;�c���r���[�̎�
					(setq #dist (* 2.4 (distance #extmin #extmax)))
				)

				(cond
					;���Ր}�̎�
					((= "0" (substr #enLay (strlen #enLay) 1))
						(WebOutLog "���Ր}�̎�����ύX���܂�")
						(princ "\n���Ր}�̎�����ύX���܂�")
            (setq #p1 (polar #extmin (angle #extmin #extmax) (* 0.5 (distance #extmin #extmax))))
					  (setq #p1 (list (car #p1) (cadr #p1) 50000.))
					  (setq #p2 (list (car #p1) (cadr #p1) 0.))
					  (command "_.VPOINT" "0,0,1")
					  (command "_.DVIEW" "ALL" "" "PO" #p2 #p1 "D" #dist "PA" "0,0" "400,230" "X")
					)
					;����ȊO�̃p�[�X�̎�
					(T
						;���_�p�x��ݒ肷��
						(WebOutLog "�p�[�X�}�̎�����ύX���܂�")
						(princ "\n�p�[�X�}�̎�����ύX���܂�")
						(setq #p1 (list 0 0 0))
						(setq #p2 (polar #p1 (dtr (atoi #ang)) 100))
						(setq #p2 (list (car #p2) (cadr #p2) -30))
						(command "_.VPOINT" "0,0,1")
						(command "_.DVIEW" "ALL" "" "PO" #p2 #p1 "X")
						(command "_.ZOOM" "E")
						(command "_.DVIEW" "ALL" "" "D" #dist "X")
					)
				)
				(command "_.LAYER" "T" "0_PERS*" "") ;���ɖ߂�
				(command "_.REGEN")
				(setvar "ELEVATION" 0)

				(WebOutLog "�p�[�X�}������")
				(princ "\n�p�[�X�}������")

				(setq #drawFlg T)
			)
		;else
			(progn
				(command "_.MSPACE")
				(setvar "CVPORT" #viewId)
				(command "_.VPLAYER" "F" "*" "C" "")
			)
		)
	)

	(command "_.PSPACE")
	(command "_.LAYER" "OF" "VIEW*" "")
;  (WebOutLog "�p�[�X�g�}�`�̉�w�̐}�`���\���ɂ��܂���")

;-- 2012/02/28 A.Satoh ADD-S ��׈ʒu�ƖڕW�_�̊֌W���s�K�؂ł�
  ; ���s���[�h��߂�
  (setvar "ORTHOMODE" #orthomode)
	(setvar "OSMODE" #osmode)
;-- 2012/02/28 A.Satoh ADD-E ��׈ʒu�ƖڕW�_�̊֌W���s�K�؂ł�

	;�߂�l
	#drawFlg
)
; SCFDrawPersLayout2

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetTitleStr
;;; <�����T�v>: ;�󔒕�����"TEXT"�̑��݂��߰��ʒu������邽�ߍ폜����
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : ;2008/08/14 YM ADD
;;;************************************************************************>MOH<
(defun Textdel
  (
  /
  #1 #EG$ #EN #I #SS
  )
  ;��÷�Ă��폜����
  (setq #ss (ssget "X" (list (cons 0 "TEXT"))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #eg$ (entget #en))
        (setq #1 (cdr (assoc 1 #eg$)))
        (if (or (= #1 "")(= #1 " ")(= #1 "�@"))
          (command "_.ERASE" #en "")
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

);Textdel

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetTitleStr
;;; <�����T�v>: �}�ʘg�̃^�C�g����������l������
;;; <�߂�l>  : �^�C�g�������񃊃X�g
;;;              1. ������
;;;              2. �v������
;;;              3. �����R�[�h
;;;              4. ����No.
;;;              5. �n��
;;;              6. ���[�N�g�b�v
;;;              7. ��
;;;              8. �c�ƒS��
;;;              9. �v�����S��
;;;             10. �o�[�W����
;;;             11. ���[�N�g�b�v2
;;;             12. �V�X�e����
;;;             13. ��Ж�
;;;             14. �݌v�v����No.
;;;             15. ���ۖ�
;;;             16. �戵�X��
;;;             17. �}�ʓ��L����
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SCFGetTitleStr
  (
  /
  #HEAD$$
  #VER$$
  #sWT
  #sDoor
  #sWt2
  #INFO$
  #SystemName
  #JisyaName
  )

  ;// �w�b�_�[����ǂݍ���
;;;  (setq #HEAD$$ (ReadIniFile (strcat CG_KENMEI_PATH "HEAD.CFG")))
  (setq #VER$$  (ReadIniFile (strcat CG_SYSPATH  "Version.ini")))

  (setq #sWt  nil)
  (setq #sWt2 nil)


  ;// �߂�l��Ԃ�
;;;  (list
;;;    (cadr (assoc "BUKKENNAME" CG_KENMEIINFO$))    ; ������
;;;    (cadr (assoc "PLANNAME"   CG_KENMEIINFO$))    ; �v������
;;;    (cadr (assoc "KENMEICD"   CG_KENMEIINFO$))    ; �����R�[�h
;;;    (cadr (assoc "ORDERNO"    CG_KENMEIINFO$))    ; ����No.
;;;    (cadr (assoc "Series"     #HEAD$$))           ; �n��
;;;    (cadr (assoc "WT_zai"     #HEAD$$))           ; ���[�N�g�b�v  01/01/31 HN MOD
;;;    #sDoor                                        ; ��            01/02/28 HT MOD
;;;    (cadr (assoc "SALECHARGE" CG_KENMEIINFO$))    ; �c�ƒS��
;;;    (cadr (assoc "PLANCHARGE" CG_KENMEIINFO$))    ; �v�����S��
;;;    (cadr (assoc "VERNO"      #VER$$))            ; �o�[�W����
;;;    #sWt2                                         ; ���[�N�g�b�v2 00/09/25 HT MOD
;;;    #SystemName                                   ; �V�X�e����    ���g�p
;;;    #JisyaName                                    ; ��Ж�        ���g�p
;;;   (cadr (assoc "DESIGNNO"   CG_KENMEIINFO$))    ; �݌v�v����No. 01/11/30 HN ADD
;;;   (cadr (assoc "SHOPNAME"   CG_KENMEIINFO$))    ; ���ۖ�        01/11/30 HN ADD
;;;   (cadr (assoc "OFFICE"     CG_KENMEIINFO$))    ; �戵�X��      02/03/17 HN ADD
;;;   (cadr (assoc "NEWS"       CG_KENMEIINFO$))    ; �}�ʓ��L����  02/03/17 HN ADD
;;; )

  (list
    (cadr (assoc "ART_NAME"             CG_KENMEIINFO$))  ; ���������́�
    (cadr (assoc "PLANNING_NO"          CG_KENMEIINFO$))  ; ���v�����ԍ���
    ;2010/12/10 YM ADD-S
    (cadr (assoc "PLAN_NAME"            CG_KENMEIINFO$))  ; ���v��������
    ;2010/12/10 YM ADD-E
    (cadr (assoc "VERSION_NO"           CG_KENMEIINFO$))  ; ���ǔԁ�
    (cadr (assoc "BASE_BRANCH_NAME"     CG_KENMEIINFO$))  ; ���c�Ə�����
    (cadr (assoc "BASE_CHARGE_NAME"     CG_KENMEIINFO$))  ; ���c�ƒS����
    (cadr (assoc "ADDITION_CHARGE_NAME" CG_KENMEIINFO$))  ; ������(�ώZ�S��)��
    (cadr (assoc "VERNO"      #VER$$))                    ; ���o�[�W������
    ""                                                    ; �v������
    ""                                                    ; �����R�[�h
    ""                                                    ; �戵�X��
    ""                                                    ; �}�ʓ��L����
    ""                                                    ; �n��
    ""                                                    ; ��
    ""                                                    ; ���[�N�g�b�v
    ""                                                    ; ���[�N�g�b�v2(�����)
    ""                                                    ; �V�X�e����    ���g�p
    ""                                                    ; ��Ж�        ���g�p
  )


)
;;;SCFGetTitleStr


;<HOM>************************************************************************
; <�֐���>  : DrawBaloon
; <�����T�v>: �o���[����}
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun DrawBaloon (
  &ss         ; �ΏۑI���Z�b�g
  &layer      ; �o���[����}��w
  &high       ; �o���[����}����
  /
  #ss #i #en #del$ #table #spec$ #assoc$ #list$ #10 #ed$ #hin #no
  )

  ;�g���f�[�^�o�^
  (if (not (tblsearch "APPID" "G_REF")) (regapp "G_REF"))

  ;�W�J�ԍ�P�_�l��
  (setq #ss (ssget "X" (list (cons 8 &layer) (list -3 (list "G_PTEN")))))
  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (if (not (and (= 7 (car (CfGetXData #en "G_PTEN")))
                  ; �덷���܂ނ悤�ɏC��
                      ;(equal '(0.0 0.0 1.0) (cdrassoc 210 (entget #en)))
                      (equal 0.0 (nth 0 (cdrassoc 210 (entget #en))) 0.001)
                      (equal 0.0 (nth 1 (cdrassoc 210 (entget #en))) 0.001)
                      (equal 1.0 (nth 2 (cdrassoc 210 (entget #en))) 0.001)
                      (ssmemb #en &ss)))
          (setq #del$ (cons #en #del$))
        );_if
        (setq #i (1+ #i))
      )
      (mapcar
       '(lambda ( #en )
          (ssdel #en #ss)
        )
        #del$
      )
    )
  )

  ;�d�l�\�t�@�C�����l��
  (setq #table (strcat CG_KENMEI_PATH "Table.cfg"))

  (if (and (/= nil #ss) (findfile #table))
    (progn
      ;�d�l�\�Ǎ���
      (setq #spec$ (ReadCSVFile #table))
      ;�������ނ͕i��+@���i�ŋ�ʂ��� 01/03/10 YM ADD START lambda mapcar �͎g�p���Ȃ�
      (setq #assoc$ nil)
      (foreach spec #spec$
        ;2011/06/18 YM MOD-S �V�Ƀo�����ԍ�����}���Ȃ�
;-- 2011/12/12 A.Satoh Mod - S
;;;;;        (setq #set_hin (nth 11 spec))
        (setq #set_hin (nth 13 spec))
;-- 2011/12/12 A.Satoh Mod - E
        (setq #assoc$ (append #assoc$ (list
          (list
            #set_hin
            (nth 0 spec) ; �ԍ�
          )
        )))
;;;       ;2011/04/25 YM MOD-S ���ʎw��Ή�
;;;       (setq #CAD_HIN    (nth  9 spec))
;;;       (setq #DR_CAD_HIN (nth 11 spec))
;;;       (if (= #DR_CAD_HIN "")
;;;         (setq #set_hin #CAD_HIN)
;;;         ;else
;;;         (setq #set_hin #DR_CAD_HIN)
;;;       );_if
;;;       ;2011/04/25 YM MOD-E ���ʎw��Ή�
;;;
;;;       (setq #assoc$ (append #assoc$ (list
;;;         (list
;;;           #set_hin ;2011/04/25 MOD
;;;           (nth 0 spec) ; �ԍ�
;;;         )
;;;       )))
      );foreach

      (setq #i 0)
      (repeat (sslength #ss)
        ;�}�`��
        (setq #en  (ssname #ss #i))
        (setq #10  (cdrassoc 10 (entget #en)))
        ;�i�Ԋl��
        (setq #ed$ (CfGetXData #en "G_PTEN"))
        (setq #hin (cadr #ed$))

        ;2011/04/25 YM DEL-S ���ʎw��Ή�
;;;       (setq #hin (KP_DelDrSeriStr #hin))
        ;2011/04/25 YM DEL-E ���ʎw��Ή�

        ;�W�J�}�ԍ��l��
        (setq #no  (cadr (assoc #hin #assoc$)))
;;;       ; �������ނ���ٰ݂����Ȃ��s��̑Ή� 01/03/01 YM ADD
;;;       (if (and (= nil #no)(= 'STR (type #hin))) ; #hin=0 �̂Ƃ������邽�� 01/03/10 YM
;;;         (setq #no (cadr (assoc (strcat "ĸ" #hin) #assoc$)))
;;;       );_if

        (if (/= nil #no)
          (progn
            ;�W�J�}�ԍ���}
            (MakeBalNo #10 #no &high)
            ;�g���f�[�^�i�[
            (CfSetXData (entlast) "G_REF" (list #no))
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
  (princ)
) ; DrawBaloon


;<HOM>************************************************************************
; <�֐���>  : MakeBalNo
; <�����T�v>: �o���[���ԍ����쐬�z�u����
; <�߂�l>  :
; <���l>    :
;************************************************************************>MOH<
(defun MakeBalNo (
  &pt         ;(ENAME)���W
  &no         ;(STR)�\������
  &high       ; �o���[����}����
  /
  #clayer #ss #eg #pt1
#Freeze #LAY_INFO$ ; 01/12/12 YM ADD
  )
  (setq #clayer (getvar "CLAYER"))
  (setq #ss (ssadd))

  (setq #pt1 (list (car &pt) (cadr &pt) &high))

  (if (not (tblsearch "LAYER" "0_REFNO")) (MakeLayer "0_REFNO" 7 "CONTINUOUS"))
  ; 01/12/12 YM ADD-S �\����������ݔԍ����ذ�ނ���Ă����痎����̉��
  (setq #Freeze nil)
  (setq #lay_info$ (tblsearch "LAYER" "0_REFNO"))
  (if (= (cdr (assoc 70 #lay_info$)) 1)
    (progn ; ���ݔԍ����ذ�ނ���Ă���
      (setq #Freeze T)
      (command "_layer" "T" "0_REFNO" "") ; �ذ�މ���
    )
  );_if

  ; 01/12/12 YM ADD-S �\����������ݔԍ����ذ�ނ���Ă����痎����̉��
  (setvar "CLAYER" "0_REFNO")
  ;�~��}
  (command "_circle" "_non" #pt1 CG_REF_SIZE)
  (setq #ss (ssadd (entlast) #ss))
  ;�e�L�X�g��}
  (MakeText &no #pt1 60.0 1 2 "REF_NO")
  (setq #ss (ssadd (entlast) #ss))

  ;// �u���b�N��
  (CFublock #pt1 #ss)
  (setvar "CLAYER" #clayer)

  ; 01/12/12 YM ADD-S
  (if #Freeze
    (command "_layer" "F" "0_REFNO" "") ; ���ذ��
  );_if
  ; 01/12/12 YM ADD-E
  (princ)
) ; MakeBalNo

;<HOM>************************************************************************
; <�֐���>  : MakeBalNoSizeCH
; <�����T�v>: �o���[���ԍ����쐬�z�u����
; <�߂�l>  : �Ȃ�
; <���l>    : MakeBalNo�Ŕ��a�ƕ��������������ɒǉ������֐� 01/12/21 YM
;************************************************************************>MOH<
(defun MakeBalNoSizeCH (
  &pt         ;(ENAME)���W
  &no         ;(STR)�\������
  &high       ; �o���[����}����
  &rr         ; �~�̔��a
  &HH         ; ��������
  /
  #CLAYER #FREEZE #LAY_INFO$ #PT1 #SS
  )
  (setq #clayer (getvar "CLAYER"))
  (setq #ss (ssadd))

  (setq #pt1 (list (car &pt) (cadr &pt) &high))

  (if (not (tblsearch "LAYER" "0_REFNO")) (MakeLayer "0_REFNO" 7 "CONTINUOUS"))
  ; 01/12/12 YM ADD-S �\����������ݔԍ����ذ�ނ���Ă����痎����̉��
  (setq #Freeze nil)
  (setq #lay_info$ (tblsearch "LAYER" "0_REFNO"))
  (if (= (cdr (assoc 70 #lay_info$)) 1)
    (progn ; ���ݔԍ����ذ�ނ���Ă���
      (setq #Freeze T)
      (command "_layer" "T" "0_REFNO" "") ; �ذ�މ���
    )
  );_if

  ; 01/12/12 YM ADD-S �\����������ݔԍ����ذ�ނ���Ă����痎����̉��
  (setvar "CLAYER" "0_REFNO")
  ;�~��}
  (command "_circle" "_non" #pt1 &rr)
  (setq #ss (ssadd (entlast) #ss))
  ;�e�L�X�g��}
  (MakeText &no #pt1 &HH 1 2 "REF_NO")
  (setq #ss (ssadd (entlast) #ss))

  ;// �u���b�N��
  (CFublock #pt1 #ss)
  (setvar "CLAYER" #clayer)

  ; 01/12/12 YM ADD-S
  (if #Freeze
    (command "_layer" "F" "0_REFNO" "") ; ���ذ��
  );_if
  ; 01/12/12 YM ADD-E
  (princ)
); MakeBalNoSizeCH

;<HOM>************************************************************************
; <�֐���>  : C:KPMakeBaloon
; <�����T�v>: �o���[���ԍ����쐬�z�u����
; <�߂�l>  : ���ύ��ԍ쐬�����
; <���l>    : 01/12/17 YM MakeBalNo�̺���މ�
;************************************************************************>MOH<
(defun C:KPMakeBaloon (
  /
  #CLAYER #FREEZE #HIGH #LAY_INFO$ #NO #PT #PT1 #SS #cmdecho
  )
  (StartUndoErr)

  ; 01/12/25 YM ADD-S
  (setq #cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  ; 01/12/25 YM ADD-E

  ; 01/12/20 YM ADD-S 01/12/25 YM ADD if���ǉ�
  (if (= (getvar "TILEMODE") 0)
    (command "_.MSPACE")
  );_if
  ; 01/12/20 YM ADD-E

  (setq #lay_info$ (tblsearch "LAYER" "0_REFNO"))
  (if (= (cdr (assoc 70 #lay_info$)) 1)
    (progn ; ���ݔԍ����ذ�ނ���Ă���
      (CFAlertMsg "\n�\������R�}���h�Ŏd�l�\�ԍ���\�����Ă��������B")
      (quit)
    )
  );_if

  ;�g���f�[�^�o�^
  (if (not (tblsearch "APPID" "G_REF")) (regapp "G_REF"))

  (setq #iNO (getint "\n�ԍ������: "))
  (setq #sNO (itoa #iNO)) ; ������

  ; 01/12/21 YM ADD-S
  ; �~�̔��a�ƕ������������
  (setq #defrr (rtos CG_REF_SIZE)) ; ��̫�Ľ���
;;;01/12/25YM@MOD (setq #defhh (rtos CG_REF_SIZE)) ; ��̫�Ľ���

  (setq #rr (getreal (strcat "\n�~�̔��a<" #defrr ">: ")))
  (if (= #rr nil)
    (setq #rr (atof #defrr))
  ); if

;;;01/12/25YM@MOD  (setq #hh (getreal (strcat "\nY�����̍���<" #defhh  ">: ")))
;;;01/12/25YM@MOD (if (= #hh nil)
;;;01/12/25YM@MOD   (setq #hh (atof #defhh))
;;;01/12/25YM@MOD ); if
  ; 01/12/21 YM ADD-E

  (setq #pt (getpoint "\n�}���ʒu���w��: "))
  (setq #high CG_LAYOUT_DIM_Z) ; �o���[����}����

  ; ���ݍ�}
;;;01/12/21YM@MOD (MakeBalNo #pt #sNO #high)
  (MakeBalNoSizeCH #pt #sNO #high #rr #rr) ; 01/12/25 YM ���������͐q�˂Ȃ�
;;;01/12/25YM@MOD (MakeBalNoSizeCH #pt #sNO #high #rr #hh)

  ;�g���f�[�^�i�[
  (CfSetXData (entlast) "G_REF" (list #sNO))
  (princ "\n���ύ��Ԃ��쐬���܂����B")

  ; 01/12/25 YM ADD-S
  (setvar "CMDECHO" #cmdecho)
  ; 01/12/25 YM ADD-E

  (setq *error* nil)
  (princ)
); C:KPMakeBaloon

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KPInsertSymbol
;;; <�����T�v>  : �����̃v������}�����čė��p����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : C:PC_InsertPlan �����ɍ쐬 01/04/25 YM
;;; <���l>      : �}�����G_ARW , G_ROOM���폜
;;;*************************************************************************>MOH<
(defun C:KPInsertSymbol (
  /
  #ANG #INSPT #PURGE #SFNAME #CMDECHO
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPInsertSymbol ////")
  (CFOutStateLog 1 1 " ")
  (StartUndoErr);// �R�}���h�̏�����

  ; 01/12/25 YM ADD-S
  (setq #cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  ; 01/12/25 YM ADD-E

  ; 01/12/20 YM ADD-S 01/12/25 YM ADD if���ǉ�
  (if (= (getvar "TILEMODE") 0)
    (command "_.MSPACE")
  );_if
  ; 01/12/20 YM ADD-E

  ; ����dwg�̌���
  (if (vl-directory-files (strcat CG_SYSPATH "SYMBOL\\") "*.dwg")
    (progn
      ; ̧�َw��
      (setq #sFname (getfiled "�L���z�u" (strcat CG_SYSPATH "SYMBOL\\") "dwg" 8))
      (if #sFname
        (progn

          ; 01/12/25 YM ADD-S
          ; �ړx�����(X,Y���ɐq�˂���1�񂾂�)
          (setq #defSCL "1.0") ; ��̫�Ľ���

          (setq #scl (getreal (strcat "\n�{��<" #defSCL ">: ")))
          (if (= #scl nil)
            (setq #scl (atof #defSCL))
          ); if
          ; 01/12/25 YM ADD-E

;;;01/12/25YM@MOD         ; 01/12/21 YM ADD-S
;;;01/12/25YM@MOD         ; �ړx�����
;;;01/12/25YM@MOD         (setq #defSCLX "1.0") ; ��̫�Ľ���
;;;01/12/25YM@MOD         (setq #defSCLY "1.0") ; ��̫�Ľ���

;;;01/12/25YM@MOD         (setq #sclX (getreal (strcat "\nX�����̔{��<" #defSCLX ">: ")))
;;;01/12/25YM@MOD         (if (= #sclX nil)
;;;01/12/25YM@MOD           (setq #sclX (atof #defSCLX))
;;;01/12/25YM@MOD         ); if
;;;01/12/25YM@MOD
;;;01/12/25YM@MOD         (setq #sclY (getreal (strcat "\nY�����̔{��<" #defSCLY ">: ")))
;;;01/12/25YM@MOD         (if (= #sclY nil)
;;;01/12/25YM@MOD           (setq #sclY (atof #defSCLY))
;;;01/12/25YM@MOD         ); if

          ; 01/12/21 YM ADD-E

;;;01/12/21YM@DEL         (command "vpoint" "0,0,1"); ���_��^�ォ��
          (princ "\n�z�u�_: ")
          (command "_Insert" #sFname pause #scl #scl) ; 01/12/25 YM MOD
;;;01/12/25YM@MOD         (command "_Insert" #sFname pause #sclX #sclY)
          (princ "\n�p�x: ")
          (command pause)

          (setq #insPt (getvar "LASTPOINT"))
          (setq #ang (cdr (assoc 50 (entget (entlast)))))

          (command "_explode" (entlast))
          ;// �C���T�[�g�����u���b�N��`���p�[�W����
;;;01/12/21YM@MOD         (command "_purge" "BL" #purge "N")
          (command "_purge" "BL" "*" "N")
          (princ "\n�L����z�u���܂����B")
        )
      );_if
    )
    (progn
      (CFAlertMsg "�}������L�����o�^����Ă��܂���B")
      (quit)
    )
  );_if

  ; 01/12/25 YM ADD-S
  (setvar "CMDECHO" #cmdecho)
  ; 01/12/25 YM ADD-E

  (setq *error* nil)
  (princ)
);C:KPInsertSymbol

;<HOM>*************************************************************************
; <�֐���>    : C:DanmenSelect
; <�����T�v>  : �f�ʒ��o�����(������)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2011/07/27 A.Satoh
; <���l>      : 2�_�w��==>GSM�̍��E���ʂ𒊏o����
;               dwg��:"���i�}_�E����.dwg","�{�H�}_�E����.dwg"
;                    :"���i�}_������.dwg","�{�H�}_������.dwg"
;*************************************************************************>MOH<
(defun C:DanmenSelect (
  /
  #orthomode #pp1 #pp2
  #layer$ #layer #layerdata #layername #freez #disp
  #ss #0502_ss #0504_ss #0602_ss #0604_ss
  #idx #sym$ #sym #zukei$ #zukei #en #edata$
  #fpath #fname_0602 #fname_0502 #fname_0604 #fname_0504 
#osmode ;-- 2011/11/21 A.Satoh Add
  )

;**********************************
    ;; �G���[����
    (defun DanmenSelectErr ( msg / )
      (command "_.UNDO" "B")
      (setq *error* nil)
      (princ)
    )
;**********************************

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:DanmenSelect ////")
  (CFOutStateLog 1 1 " ")

  (setq *error* DanmenSelectErr)
  (command "_.UNDO" "M")
  (command "_.UNDO" "A" "OFF")

  ; ���݂̃r���[����ۑ�����
  (command "_.VIEW" "S" "TEMP_MRR")

  ; ���s���[�h�̐ݒ�
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)
;-- 2011/11/21 A.Satoh Add - S
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
;-- 2011/11/21 A.Satoh Add - E

  (command "_.VPOINT" (list 0 0 1))
  (command "_.ZOOM" "0.8x")

  ; �f�ʐ��̍쐬
  (setq #pp1 (getpoint "\n1�_�ڂ��w��:> "))
  (setq #pp2 (getpoint "\n2�_�ڂ��w��:> " #pp1))
  (if (= #pp2 nil)
    (exit)
  )

  ; �f�ʐ��쐬�`�F�b�N
  (if (and (not (equal (nth 0 #pp1) (nth 0 #pp2) 0.001))
           (not (equal (nth 1 #pp1) (nth 1 #pp2) 0.001)))
    (progn
      (alert "�f�ʂ̎w�����Ԉ���Ă��܂�")
      (exit)
    )
  )

  ; �f�ʐ}�`��w�̃t���[�Y��Ԋm�F
  (setq #layer$ nil)
  (setq #layerdata (tblnext "LAYER" T))
  (while #layerdata
    (if (or (= (substr (cdr (assoc 2 #layerdata)) 1 8) "Z_05_02_")
            (= (substr (cdr (assoc 2 #layerdata)) 1 8) "Z_05_04_")
            (= (substr (cdr (assoc 2 #layerdata)) 1 8) "Z_06_02_")
            (= (substr (cdr (assoc 2 #layerdata)) 1 8) "Z_06_04_"))
      (progn
        (setq #layername (cdr (assoc 2 #layerdata)))
        (if (= (cdr (assoc 70 #layerdata)) 0)
          (setq #freez nil)
          (setq #freez T)
        )
        (if (>= (cdr (assoc 62 #layerdata)) 0)
          (setq #disp nil)
          (setq #disp T)
        )
        (setq #layer$ (append #layer$ (list (list #layername #freez #disp))))
      )
    )
    (setq #layerdata (tblnext "LAYER" nil))
  )

  ; �f�ʐ}�`��w�̕\���A�t���[�Y����
  (foreach #layer #layer$
    (command "_.LAYER" "T" (car #layer) "ON" (car #layer) "")
  )

  ; �f�ʐ��Ɍ�������}�`(�I���Z�b�g)���擾����
  (setq #ss (ssget "F" (list #pp1 #pp2)))
  (if (= #ss nil)
    (progn
      (alert "�Y������f�ʂ͑��݂��܂���")
      (exit)
    )
  )

  ; �V���{���}�`�����X�g�y�ѐ}�`�����X�g���쐬����
  (setq #idx 0)
  (setq #sym$ nil)
  (setq #zukei$ nil)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #idx))
    (setq #sym (SearchGroupSym #en))
    (setq #zukei #en)
    (if #sym
      (progn
        (if (= (member #sym #sym$) nil)
          (setq #sym$ (append #sym$ (list #sym)))
        )
      )
      (progn
        (if (= (member #zukei #zukei$) nil)
          (setq #zukei$ (append #zukei$ (list #zukei)))
        )
      )
    )
    (setq #idx (1+ #idx))
  )

  ; �V���{���}�`����f�ʐ}�`���擾����
  (setq #0502_ss (ssadd))
  (setq #0504_ss (ssadd))
  (setq #0602_ss (ssadd))
  (setq #0604_ss (ssadd))
  (foreach #sym #sym$
    ; �S�O���[�v�����o�[�}�`���擾����
    (setq #ss (CFGetSameGroupSS #sym))

    (setq #idx 0)
    (repeat (sslength #ss)
      (setq #en (ssname #ss #idx))
      (setq #layer (cdr (assoc 8 (entget #en))))
      (cond
        ((= (substr #layer 1 8) "Z_05_02_")
          (setq #0502_ss (ssadd #en #0502_ss))
        )
        ((= (substr #layer 1 8) "Z_05_04_")
          (setq #0504_ss (ssadd #en #0504_ss))
        )
        ((= (substr #layer 1 8) "Z_06_02_")
          (setq #0602_ss (ssadd #en #0602_ss))
        )
        ((= (substr #layer 1 8) "Z_06_04_")
          (setq #0604_ss (ssadd #en #0604_ss))
        )
      )
      (setq #idx (1+ #idx))
    )
  )

  ; ���[�N�g�b�v�A�V��t�B���[���擾
  (foreach #zukei #zukei$
    (setq #edata$ (entget #zukei '("*")))
    (setq #edata$ (cdr (assoc -3 #edata$)))
    (if (/= #edata$ nil)
      (if (= (nth 0 (car #edata$)) "G_WTSET")
        (progn
          (setq #0502_ss (ssadd #zukei #0502_ss))
          (setq #0504_ss (ssadd #zukei #0504_ss))
          (setq #0602_ss (ssadd #zukei #0602_ss))
          (setq #0604_ss (ssadd #zukei #0604_ss))
        )
        (if (= (nth 0 (car #edata$)) "G_WRKT")
          (progn
            (setq #0502_ss (ssadd #zukei #0502_ss))
            (setq #0504_ss (ssadd #zukei #0504_ss))
            (setq #0602_ss (ssadd #zukei #0602_ss))
            (setq #0604_ss (ssadd #zukei #0604_ss))
          )
          (if (= (nth 0 (car #edata$)) "G_FILR")
            (progn
              (setq #0502_ss (ssadd #zukei #0502_ss))
              (setq #0504_ss (ssadd #zukei #0504_ss))
              (setq #0602_ss (ssadd #zukei #0602_ss))
              (setq #0604_ss (ssadd #zukei #0604_ss))
            )
          )
        )
      )
    )
  )

  ; �t�@�C����
  (setq #fpath (strcat CG_SYSPATH "SYMBOL\\"))

  (setq #fname_0602 "���i�}_�E����.dwg")
  (setq #fname_0502 "���i�}_������.dwg")
  (setq #fname_0604 "�{�H�}_�E����.dwg")
  (setq #fname_0504 "�{�H�}_������.dwg")

  ; �r���[�ύX(���_�������ɕύX)
  (command "_.VPOINT" (list -1 0 0))
  (command "_.UCS" "ZA" "" "-1,0,0")

  ; �f�ʐ}�`���V���{���}�`��
  ;; ���i�}_�����}
  (command "_.WBLOCK" (strcat #fpath #fname_0502) "" "0,0,0" #0502_ss "")
  (command "_.OOPS")

  ;; �{�H�}_�����}
  (command "_.WBLOCK" (strcat #fpath #fname_0504) "" "0,0,0" #0504_ss "")
  (command "_.OOPS")

  (command "_.UCS" "P")

  ; �r���[�ύX(���_�������ɕύX)
  (command "_.VPOINT" (list 1 0 0))
  (command "_.UCS" "ZA" "" "1,0,0")

  ; �f�ʐ}�`���V���{���}�`��
  ;; ���i�}_�E���}
  (command "_.WBLOCK" (strcat #fpath #fname_0602) "" "0,0,0" #0602_ss "")
  (command "_.OOPS")

  ;; �{�H�}_�E���}
  (command "_.WBLOCK" (strcat #fpath #fname_0604) "" "0,0,0" #0604_ss "")
  (command "_.OOPS")

  (command "ucs" "P")


  ; �f�ʐ}�`��w���t���[�Y��Ԃ����ɖ߂�
  (foreach #layer #layer$
    (if (= (nth 1 #layer) T)
      (command "_.LAYER" "F" (car #layer) "")
    )
    (if (= (nth 2 #layer) T)
      (command "_.LAYER" "OF" (car #layer) "")
    )
  )

  ; ���s���[�h��߂�
  (setvar "ORTHOMODE" #orthomode)
;-- 2011/11/21 A.Satoh Add - S
	(setvar "OSMODE" #osmode)
;-- 2011/11/21 A.Satoh Add - E

  ; �r���[�����ɖ߂�
  (command "_.ZOOM" "P")
  (command "_.VIEW" "R" "TEMP_MRR")
; (command "ucs" "")

  (alert (strcat "�f�ʐ}���ȉ��̖��O�ŕۑ����܂����B\n�@" #fname_0502 "\n�@" #fname_0504 "\n�@" #fname_0602 "\n�@" #fname_0604))

  (setq *error* nil)

  (princ)

;  (alert "�������@�H�����@������")

);C:DanmenSelect

;<HOM>************************************************************************
; <�֐���>  : ChangeYashi
; <�����T�v>: ���ύX����ɕύX
; <�߂�l>  : ���
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun ChangeYashi (
  &yashi      ; �V�
  &flg        ; �t���O�i"N"�V��ɕύX  "O"����ɕύX�j
  /
  )
  (if (= "N" &flg)
    (cond
      ((= "P" &yashi) "P")
      ((= "A" &yashi) "A")
      ((= "B" &yashi) "D")
      ((= "C" &yashi) "B")
      ((= "D" &yashi) "C")
    )
    (cond
      ((= "P" &yashi) "P")
      ((= "A" &yashi) "A")
      ((= "B" &yashi) "C")
      ((= "C" &yashi) "D")
      ((= "D" &yashi) "B")
    )
  )
)


;<HOM>************************************************************************
; <�֐���>  : CdrAssoc
; <�����T�v>: �}�`�f�[�^��������key�̃f�[�^���l��
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun CdrAssoc (
  &key        ; �����L�[���[�h
  &eg         ; �}�`�f�[�^
  /
  #ed #d #ret
  )
  (setq #ed (assoc &key &eg))
  (if (/= nil #ed)
    (progn
      (mapcar
       '(lambda ( #d )
          (if (and (= 'REAL (type #d))(equal 0.0 #d 0.00001))
            (setq #ret (cons 0.0 #ret))
            (setq #ret (cons #d  #ret))
          )
        )
        #ed
      )
      (setq #ret (cdr (reverse #ret)))
    )
  )
  #ret
) ; CdrAssoc


;<HOM>************************************************************************
; <�֐���>  : PurgeBlock
; <�����T�v>: �u���b�N���p�[�W
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun PurgeBlock (
  /
  #cmdecho
  )

  (setq #cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command "_.PURGE" "bl" "*" "Y")
  (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
    (command "Y")
  )
  (command "_.PURGE" "bl" "*" "Y")
  (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
    (command "Y")
  )
  (command "_.PURGE" "bl" "*" "Y")
  (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
    (command "Y")
  )
  (setvar "CMDECHO" #cmdecho)

  (princ)
)


;<HOM>************************************************************************
; <�֐���>  : DelSymEntity
; <�����T�v>: �V���{���}�`���폜����
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun DelSymEntity (
  /
  #ss #i #en
  )
  (setq #ss (ssget "X" (list (list -3 (list "G_SKDM")))))
  (if (/= nil #ss)
    (progn
      (mapcar
       '(lambda ( #en )
          (entdel #en)
        )
        (Ss2En$ #ss)
      )
    )
  )
  (princ)
) ; DelSymEntity


;<HOM>************************************************************************
; <�֐���>  : DispFigure
; <�����T�v>: �p�}�z�u
; <�߂�l>  : �Ȃ�
; <���l>    : �Ȃ�
;************************************************************************>MOH<

(defun DispFigure (
  /
  #high #ss #i #en #ed$ #fr$ #no$ #table #spec$ #elm$ #hin #list$ #new$
  #assoc$ #sp$ #no #fname #fn$ #fpt$ #scale #pt$ #ins #baloon
  )
  ; 01/12/06 HN MOD �萔���O���[�o����
  ;@MOD@(setq #high 15000)   ; �o���[����}����
  (setq #high CG_LAYOUT_DIM_Z)   ; �o���[����}����
  (setq #ss (ssget "X" (list (list -3 (list "FRAME")))))
  (if (/= nil #ss)
    (progn
      ;�p�}�̈�l��
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #ed$ (CfGetXData #en "FRAME"))
        (if (= "F" (substr (car #ed$) 1 1))
          (setq #fr$ (cons (list (substr (car #ed$) 2) #en) #fr$))
        )
        (setq #i (1+ #i))
      )
      (setq #fr$ (mapcar 'cadr (SCFmg_sort$ 'car #fr$)))

      ;�W�J�ԍ��l��
      (setq #ss (ssget "X" (list (list -3 (list "G_REF")))))
      (if (/= nil #ss)
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            (setq #ed$ (CfGetXData #en "G_REF"))
            (setq #no$ (cons (car #ed$) #no$))
            (setq #i (1+ #i))
          )
        )
      )
      ;Table.cfg�t�@�C���Ǎ���
      (setq #table (strcat CG_KENMEI_PATH "Table.cfg"))
      (if (findfile #table)
        (progn
          ;�d�l�\�Ǎ���
          (setq #spec$ (ReadCSVFile #table))
          ; 02/09/04 YM ADD ۸ޏo�͒ǉ�
          (WebOutLog "**************")
          (WebOutLog "Table.cfg")
          (WebOutLog "**************")
          (WebOutLog #spec$)
          (WebOutLog " ")
          ; 02/09/04 YM ADD ۸ޏo�͒ǉ�
          (mapcar
           '(lambda ( #elm$ )
              (if (= "1" (substr (nth 3 #elm$) 1 1))
                ;���E���肠��
                (setq #hin$ (list (substr (nth 1 #elm$) 1 (1- (strlen (nth 1 #elm$)))) "R"))
                ;���E����Ȃ�
                (setq #hin$ (list (nth 1 #elm$) "Z"))
              )
              (if (assoc #hin$ #list$)
                (progn
                  (setq #new$ (list #hin$ (cons (nth 0 #elm$) (cadr (assoc #hin$ #list$)))))
                  (setq #list$ (subst #new$ (assoc #hin$ #list$) #list$))
                )
                (progn
                  (setq #list$ (cons (list #hin$ (list (nth 0 #elm$))) #list$))
                )
              )
            )
            #spec$
          )
          (mapcar
           '(lambda ( #elm$ )
              (setq #assoc$ (cons (cons (car (SCFmg_sort$ 'eval (cadr #elm$))) #elm$) #assoc$))
            )
            #list$
          )
        )
      )
    )
  )
  (if (and #fr$ #no$ #assoc$)
    (progn
      ;�p�}�\�����l��
      (mapcar
       '(lambda ( #sp$ )
          (setq #no   (nth 0 #sp$))
          (setq #hin$ (nth 1 #sp$))
          (setq #n$   (SCFmg_sort$ 'eval (nth 2 #sp$)))
          (if (member #no #no$)
            (progn
              ;�i�Ԗ��̂�LR�敪����A�i�Ԑ}�`�e�[�u���ɃN�G���[���A����ID���l��
              (setq #fname (GetFnameFigure #hin$))
              (if (and (/= nil #fname)(findfile #fname))
                (setq #fn$   (cons (list #no #fname #n$) #fn$))
              )
            )
          )
        )
        #assoc$
      )
      (setq #fn$ (reverse #fn$))

      ; �p�}�����鎞�̂� 2000/08/24 HT ADD
      (if #fn$
  (progn
        ;�p�}�z�u
        (setq #i 0)
        (mapcar
         '(lambda ( #en )
            (setq #fpt$ (GetInsertPtScale #en))
            (setq #scale (car #fpt$))
            (mapcar
             '(lambda ( #pt$ )
                (if (nth #i #fn$)
                  (progn
                  (setq #ins    (car  #pt$))           ; �p�}�t�@�C���}����_
                  (setq #baloon (cadr #pt$))           ; �o���[���}����_
                  (setq #fname  (nth 1 (nth #i #fn$))) ; �p�}�t�@�C����
                  (setq #no$    (nth 2 (nth #i #fn$))) ; �o���[���ԍ����X�g
                  ;�p�}�}��
                  (command "_.insert" #fname "_non" #ins #scale "" "0")
                  ;�o���[����}
                  (mapcar
                   '(lambda ( #no )
                      (MakeBalNo #baloon #no #high)
                      (setq #baloon (mapcar '+ #baloon (list (* 2.0 CG_REF_SIZE) 0.0 0.0)))
                    )
                    #no$
                  )
                  (setq #i (1+ #i))
                  )
                  )
                )
                (cadr #fpt$)
                )
             )
            #fr$
          )
        )
      )
    )
  )
  (princ)
) ; DispFigure


;<HOM>************************************************************************
; <�֐���>  : GetFnameFigure
; <�����T�v>: �i�Ԗ��̂�LR�敪����A�i�Ԑ}�`�e�[�u���ɃN�G���[���A����ID���l��
; <�߂�l>  : ����ID�i�p�}�t�@�C�����j
; <���l>    : �t�@�C�����̓t���p�X
;************************************************************************>MOH<
(defun GetFnameFigure (
  &hin$       ; �i�i�Ԗ��� LR�敪�j
  /
  #seri$ #qry$ #fn #ret
  )
  ;// ���݂̏��i����ݒ肷��
  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DBNAME      (nth 0 #seri$))  ;DB����
      (setq CG_SeriesCode  (nth 1 #seri$))  ;SERIES�L��
      (setq CG_BrandCode   (nth 2 #seri$))  ;�u�����h�L��
    )
  )
  ;// SERIES�ʃf�[�^�x�[�X�ւ̐ڑ�
  (if (= CG_DBSESSION nil)
    (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  )

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
      (list
        (list "�i�Ԗ���" (car  &hin$)  'STR)
        (list "LR�敪"   (cadr &hin$)  'STR)
      )
    )
  )
  (if (/= nil #qry$)
    (progn
      (setq #fn "")
      ; 01/10/01 YM ADD-S �װ����
      (if (= #fn nil)
        (progn
          (CFAlertMsg (strcat "�i�Ԑ}�`�̓W�JID�����o�^�ł�." "\n�i��= " (car  &hin$)))
          (setq #ret nil)
        )
      ; 01/10/01 YM ADD-E �װ����
        (setq #ret (strcat CG_FIGUREDWGPATH #fn ".dwg"))
      );_if
    )
  );_if

  #ret
) ; GetFnameFigure


;<HOM>************************************************************************
; <�֐���>  : GetInsertPtScale
; <�����T�v>: �̈�}�`������A�}���ړx�Ƒ}����_���X�g���l������
; <�߂�l>  : �ړx�Ƒ}����_���X�g
; <���l>    : CG_FigureScale  =  �}���}�`�̍���
;             CG_REF_SIZE     =  �o���[�����a
;************************************************************************>MOH<

(defun GetInsertPtScale (
  &en         ; �̈�}�`��
  /
  #space #pt$ #minmax #xlen #ylen #vect #tpt #pt #loop #bv #bl #scale
  )
  ;�X�y�[�X
  (setq #space 0)
  ;�̈���W�l��
  (setq #pt$ (mapcar 'car (get_allpt_H &en)))
  (setq #minmax (GetPtMinMax #pt$))
  (setq #xlen (abs (- (car  (car #minmax)) (car  (cadr #minmax)))))
  (setq #ylen (abs (- (cadr (car #minmax)) (cadr (cadr #minmax)))))
  ;�c������
  (if (< #xlen #ylen)
    (progn
      ;�ψʒl
      (setq #vect (list 0.0 (* -1 (+ #space #xlen)) 0.0))
      ;��_
      (setq #tpt  (list (car (car #minmax)) (cadr (cadr #minmax)) 0.0))
      (setq #pt   (mapcar '+ #tpt #vect))
      ;LOOP��
      (setq #loop (1- (fix (/ #ylen #xlen))))
      ;�o���[���ʒu�ψʒl
      (setq #bv   (list CG_REF_SIZE (- #xlen CG_REF_SIZE) 0.0))
    )
    (progn
      ;�ψʒl
      (setq #vect (list (+ #space #ylen) 0.0 0.0))
      ;��_
      (setq #pt   (car #minmax))
      ;LOOP��
      (setq #loop (1- (fix (/ #xlen #ylen))))
      ;�o���[���ʒu�ψʒl
      (setq #bv   (list CG_REF_SIZE (- #ylen CG_REF_SIZE) 0.0))
    )
  )
  ;��_���X�g�l��
  (setq #pt$ nil)
  (setq #bl  (mapcar '+ #pt #bv))
  (setq #pt$ (cons (list #pt #bl) #pt$))
  (repeat #loop
    (setq #pt  (mapcar '+ #pt #vect))
    (setq #bl  (mapcar '+ #pt #bv))
    (setq #pt$ (cons (list #pt #bl) #pt$))
  )
  (setq #pt$ (reverse #pt$))
  ;�ړx�Z�o
  (setq #scale (/ (distance '(0 0 0) #vect) CG_FigureScale))

  (list #scale #pt$)
) ; GetInsertPtScale

; 01/05/04 HN ADD
;;;<HOM>************************************************************************
;;; <�֐���>  : KCFSelTenkai
;;; <�����T�v>: ���[�U�[�ɓW�J���}��I��������
;;; <�߂�l>  : �I�����ꂽ���ڂɑΉ�����t�@�C�����i�t���p�X�j
;;; <�쐬>    : 01/05/02 MH
;;; <����>    : 01/05/22 HN
;;;             01/06/21 HN ��۰��َQ�Ƃ��Ȃ���
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun KCFSelTenkai
  (
  &sType      ; �}�ʎ��
  &sPathT     ; �W�J���}�̃t�@�C���p�X 01/06/21 HN ADD
  /
  #sPath      ; ���� (�t���p�X������ �� nil�l)
  ;@DEL@#sPathT     ; �W�J���}�̃t�@�C���p�X
  #sPathP     ; ���ʐ}�t�@�C���p�X
  #sPathA     ; �W�J�`�}�t�@�C���p�X
  #sPathB     ; �W�J�a�}�t�@�C���p�X
  #sPathC     ; �W�J�b�}�t�@�C���p�X
  #sPathD     ; �W�J�c�}�t�@�C���p�X
  #sPathE     ; �W�J�d�}�t�@�C���p�X
  ;2011/07/15 YM ADD
  #sPathF     ; �W�J�e�}�t�@�C���p�X
  #sPathG     ; �W�J�f�}�t�@�C���p�X
  #sPathH     ; �W�J�g�}�t�@�C���p�X
  #sPathI     ; �W�J�h�}�t�@�C���p�X
  #sPathJ     ; �W�J�i�}�t�@�C���p�X
  )
  (setq #sPath nil)

  ; 01/06/21 HN DEL
  ;@DEL@; �W�J�}��PATH�ݒ�
  ;@DEL@(setq #sPathT (strcat CG_KENMEI_PATH "Block\\"))

  ; ��}�f�B���N�g���[���̊e�W�J���}�t���p�X�擾�B(����=nil)
  ; 01/06/21 HN MOD
  ;@MOD@(setq #sPathP (findfile (strcat #sPathT "P_0.dwg" )))
  ;@MOD@(setq #sPathA (findfile (strcat #sPathT "SA_0.dwg")))
  ;@MOD@(setq #sPathB (findfile (strcat #sPathT "SB_0.dwg")))
  ;@MOD@(setq #sPathC (findfile (strcat #sPathT "SC_0.dwg")))
  ;@MOD@(setq #sPathD (findfile (strcat #sPathT "SD_0.dwg")))
  ;@MOD@(setq #sPathE (findfile (strcat #sPathT "SE_0.dwg")))
  ;@MOD@(setq #sPathF (findfile (strcat #sPathT "SF_0.dwg")))
  (setq #sPathP (findfile (strcat &sPathT "P_0.dwg" )))
  (setq #sPathA (findfile (strcat &sPathT "SA_0.dwg")))
  (setq #sPathB (findfile (strcat &sPathT "SB_0.dwg")))
  (setq #sPathC (findfile (strcat &sPathT "SC_0.dwg")))
  (setq #sPathD (findfile (strcat &sPathT "SD_0.dwg")))
  (setq #sPathE (findfile (strcat &sPathT "SE_0.dwg")))
  (setq #sPathF (findfile (strcat &sPathT "SF_0.dwg")))
  ;2011/07/15 YM ADD-S
  (setq #sPathG (findfile (strcat &sPathT "SG_0.dwg")))
  (setq #sPathH (findfile (strcat &sPathT "SH_0.dwg")))
  (setq #sPathI (findfile (strcat &sPathT "SI_0.dwg")))
  (setq #sPathJ (findfile (strcat &sPathT "SJ_0.dwg")))

  (if (or #sPathP #sPathA #sPathB #sPathC #sPathD #sPathE #sPathF #sPathG #sPathH #sPathI #sPathJ)
    ; �����ꂩ�̓W�J���}�����݂���
    (setq #sPath
       (KCFSelTenkaiDlg
         &sType
         #sPathP
         #sPathA #sPathB #sPathC #sPathD #sPathE #sPathF #sPathG #sPathH #sPathI #sPathJ
       )
    )
    ; ���ׂđ��݂��Ȃ������烁�b�Z�[�W��
    (CFAlertMsg "�W�J���}���쐬����Ă��܂���.")
  ) ;_if

  #sPath
) ;_KCFSelTenkai

;;;<HOM>************************************************************************
;;; <�֐���>  : KCFSelTenkaiDlg
;;; <�����T�v>: ���[�U�[�ɓW�J���}��I��������
;;; <�߂�l>  : �I�����ꂽ���ڂɑΉ�����t�@�C����
;;;                "table" : �d�l�\
;;;             "continue" : �V�K�}�ʂő��s
;;;                 "undo" : �z�u�������}���P���߂�
;;;               "cancel" : ���ݐ}�ʂ�ۑ����Đ}�ʃ��C�A�E�g�R�}���h���I��
;;;                    nil : �L�����Z������і��I��
;;; <�쐬��>  : 01/05/02 MH
;;; <������>  : 01/05/22 HN
;;;             01/06/23 HN �W�J���}�}���R�}���h�Ή�
;;;             01/12/09 HN UNDO�^�L�����Z���Ή�
;;; <���l>    : CG_PatNo=nil�̏ꍇ�A�W�J���}�}���R�}���h����Ăяo���ꂽ�Ɣ���
;;; <��۰���> : CG_PatNo        : �e���v���[�g�t�@�C�������X�g�̗v�f�ԍ�
;;;             CG_FreeLayoutNo : ���i�}�^�{�H�}�̌��ݐ}�ʖ���
;;;************************************************************************>MOH<
(defun KCFSelTenkaiDlg
  (
  &sType      ; �}�ʎ��
  &sPathP     ; ���ʐ}�t�@�C���p�X
  &sPathA     ; �W�J�`�}�t�@�C���p�X
  &sPathB     ; �W�J�a�}�t�@�C���p�X
  &sPathC     ; �W�J�b�}�t�@�C���p�X
  &sPathD     ; �W�J�c�}�t�@�C���p�X
  &sPathE     ; �W�J�d�}�t�@�C���p�X
  &sPathF     ; �W�J�e�}�t�@�C���p�X
  ;2011/07/15 YM ADD
  &sPathG     ; �W�J�f�}�t�@�C���p�X
  &sPathH     ; �W�J�g�}�t�@�C���p�X
  &sPathI     ; �W�J�h�}�t�@�C���p�X
  &sPathJ     ; �W�J�i�}�t�@�C���p�X
  /
  #dcl_id
  #sPath
  #GetRes
  #sContinue
  #sNo
  #sLayout
  #sBack
  #sCancel
  )
  (setq #sContinue "continue") ;01/05/22 HN ADD
  (setq #sUndo     "undo"    ) ;01/12/09 HN ADD
  (setq #sCancel   "cancel"  ) ;01/12/09 HN ADD

;--------------------------------------------------------------------------------------
    ; ���W�I�{�^�� �I�� �̍��ڂ̃t�@�C������Ԃ�
    (defun #GetRes ( / )
      (cond
        ((= "1" (get_tile "P")) &sPathP)
        ((= "1" (get_tile "A")) &sPathA)
        ((= "1" (get_tile "B")) &sPathB)
        ((= "1" (get_tile "C")) &sPathC)
        ((= "1" (get_tile "D")) &sPathD)
        ((= "1" (get_tile "E")) &sPathE)
        ((= "1" (get_tile "F")) &sPathF)
        ;2011/07/15 YM ADD-S
        ((= "1" (get_tile "G")) &sPathG)
        ((= "1" (get_tile "H")) &sPathH)
        ((= "1" (get_tile "I")) &sPathI)
        ((= "1" (get_tile "J")) &sPathJ)
        ;2011/07/15 YM ADD-E
        ((= "1" (get_tile "S")) "Table") ; �d�l�\
        ; �{�^�������I���Ȃ烁�b�Z�[�W��\��
        (t (CFAlertMsg "���ڂ�I�����Ă�������.") nil)
      ); cond
    ); #GetRes
;--------------------------------------------------------------------------------------
    ; �}�ʏ�Ɏd�l�\������=T,�Ȃ�=nil 01/07/23 YM ADD �d�l�\�������Ȃ�I��s�ɂ�����
    (defun KPSrcHLINE ( / #ss)
      (setq #ss (ssget "X" '((-3 ("G_HLINE")))))
      (if (and #ss (< 0 (sslength #ss)))
        T
        nil
      );_if
    ); #GetRes
;--------------------------------------------------------------------------------------

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "CSFlay.DCL")))
  (if (not (new_dialog "SelTenkaiDlg" #dcl_id)) (exit))

  ; 01/06/23 HN S-MOD �W�J���}�}���R�}���h�Ή�
  ;@MOD@; 01/05/22 HN S-ADD �����}�ʑΉ�
  ;@MOD@(if CG_FreeLayoutNo
  ;@MOD@  (setq #sNo (itoa (1+ CG_FreeLayoutNo)))
  ;@MOD@  (setq #sNo "1")
  ;@MOD@)
  ;@MOD@(cond
  ;@MOD@  ((= CG_OUTSHOHINZU &sType) (set_tile "type" (strcat "���i�}  " #sNo " ����")))
  ;@MOD@  ((= CG_OUTSEKOUZU  &sType) (set_tile "type" (strcat "�{�H�}  " #sNo " ����")))
  ;@MOD@)
  ;@MOD@; 01/05/22 HN E-ADD �����}�ʑΉ�
  (if CG_PatNo
    (progn
      (if CG_FreeLayoutNo
        (setq #sNo (itoa (1+ CG_FreeLayoutNo)))
        (setq #sNo "1")
      )
      (setq #sNo (strcat #sNo " ����"))
    )
    (progn
      (setq #sNo "")
      (mode_tile "continue" 1)
    )
  )
  (cond
    ((= CG_OUTSHOHINZU &sType) (set_tile "type" (strcat "���i�}  " #sNo)))
    ((= CG_OUTSEKOUZU  &sType) (set_tile "type" (strcat "�{�H�}  " #sNo)))
  )
  ; 01/06/23 HN E-MOD �W�J���}�}���R�}���h�Ή�

  ; �t�@�C�����Ȃ����ڂ̓O���C�A�E�g
  (if (not &sPathP) (mode_tile "P" 1))
  (if (not &sPathA) (mode_tile "A" 1))
  (if (not &sPathB) (mode_tile "B" 1))
  (if (not &sPathC) (mode_tile "C" 1))
  (if (not &sPathD) (mode_tile "D" 1))
  (if (not &sPathE) (mode_tile "E" 1))
  (if (not &sPathF) (mode_tile "F" 1))
  ;2011/07/15 YM ADD-S
  (if (not &sPathG) (mode_tile "G" 1))
  (if (not &sPathH) (mode_tile "H" 1))
  (if (not &sPathI) (mode_tile "I" 1))
  (if (not &sPathJ) (mode_tile "J" 1))
  ;2011/07/15 YM ADD-E

  ; �d�l�\�����ɂ���Ƃ��͸�ڲ���
  (if (KPSrcHLINE) (mode_tile "S" 1))

  ; 01/05/23 HN S-ADD �z�u�ς݂̌��}�͑I��s��
  ;@MOD@(if (member "P" CG_LAYOUT$) (mode_tile "P" 1))
  ;@MOD@(if (member "A" CG_LAYOUT$) (mode_tile "A" 1))
  ;@MOD@(if (member "B" CG_LAYOUT$) (mode_tile "B" 1))
  ;@MOD@(if (member "C" CG_LAYOUT$) (mode_tile "C" 1))
  ;@MOD@(if (member "D" CG_LAYOUT$) (mode_tile "D" 1))
  ;@MOD@(if (member "E" CG_LAYOUT$) (mode_tile "E" 1))
  ;@MOD@(if (member "S" CG_LAYOUT$) (mode_tile "S" 1))
  (foreach #sLayout CG_LAYOUT$
    (mode_tile #sLayout 1)
  )
  ; 01/05/23 HN E-ADD �z�u�ς݂̌��}�͑I��s��

  ; �^�C���쓮�ݒ�
  (action_tile "accept" "(if (setq #sPath (#GetRes)) (done_dialog))")
  ; 01/05/22 HN S-MOD �����}�ʑΉ�
  ;@MOD@(action_tile "cancel" "(setq #fRES nil)(done_dialog)")
  (action_tile "continue" "(setq #sPath #sContinue)(done_dialog)")
  (action_tile "end" "(setq #sPath nil)(done_dialog)")
  ; 01/05/22 HN E-MOD �����}�ʑΉ�
  ; 01/12/09 HN S-ADD UNDO�^�L�����Z���Ή�
  (action_tile "undo" "(setq #sPath #sUndo)(done_dialog)")
  (action_tile "cancel" "(setq #sPath #sCancel)(done_dialog)")
  ; 01/12/09 HN E-ADD UNDO�^�L�����Z���Ή�
  (start_dialog)
  (unload_dialog #dcl_id)

  ; ���ʂ�Ԃ�
  #sPath
) ;_KCFSelTenkaiDlg

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFLayoutFree
;;; <�����T�v>: �t���[���C�A�E�g�o��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �e���v���[�g�t�@�C���͊J������ԂƂ���B
;;;             �p�[�X�}�E�p�}�͑Ή����܂���B
;;; <��۰���> :
;;;             CG_KENMEI_PATH  : �v�����t�H���_�̃p�X��
;;;             CG_Pattern      : �e���v���[�g�t�@�C�������X�g
;;;             CG_PatNo        : �e���v���[�g�t�@�C�������X�g�̗v�f�ԍ�
;;;             CG_KitType      : �L�b�`���^�C�v  ex. "I-LEFT" "I-RIGHT"
;;;             CG_LAYOUT$      : �z�u�ςݓW�J���}�L���̃��X�g
;;;                               "P" ���ʐ}
;;;                               "A" �W�J�`�}
;;;                               "B" �W�J�a�}
;;;                               "C" �W�J�b�}
;;;                               "D" �W�J�c�}
;;;                               "E" �W�J�d�}
;;;                               "F" �W�J�e�}
;;;                               "S" �d�l�\
;;; <�쐬>    : 01/05/04 HN
;;;************************************************************************>MOH<
(defun SCFLayoutFree
  (
  /
  #sPathB     ; �W�J���}�p�X��
  #sFileB     ; �W�J���}�t�@�C����(�t���p�X)
  #sFileT     ; �e���v���[�g�t�@�C����
  #sType      ; �}�ʎ��  "02":���i�}  "04":�{�H�}
  #sFileS     ; �d�l�\���}�ʃt�@�C����(�t���p�X)
  #sView      ; ���_���  "P":����  "S":����  "D":�d�l�\  "M":���f��(�p�[�X)
  #sView2     ; ���ʎ��  "A" "B" "C" "D" "E" "F"
  #sFileD     ; �ۑ��}�ʃt�@�C����(�t���p�X)
  )
  (setq #sPathB (strcat CG_KENMEI_PATH "BLOCK\\"))
  (setq #sFileT (car  (nth CG_PatNo CG_Pattern)))
  (setq #sType  (cadr (nth CG_PatNo CG_Pattern)))
  (setq #sFileS (strcat CG_KENMEI_PATH "Table.cfg"))  ; 01/05/09 HN ADD
  (setq CG_LAYOUT$ nil)                               ; 01/05/23 HN ADD

  ;; ���i�}�^�{�H�}���쐬����ꍇ
  ;; �_�C�A���O����W�J���}��I�����Ĕz�u
  ;; �L�����Z��(nil)�ŏI��
  (if (/= "" #sType)
    ;@@@(while (setq #sFileB (getfiled "�W�J���}��I��" #sPathB "dwg" 2))
    ; 01/05/22 HN MOD
    ;@MOD@(while (setq #sFileB (KCFSelTenkai))
    ; 01/06/21 HN MOD
    ;@MOD@(while (and (setq #sFileB (KCFSelTenkai #sType)) (/= "continue" #sFileB))
    ; 01/12/09 HN MOD UNDO�^�L�����Z��������ǉ�
    ;@MOD@(while (and (setq #sFileB (KCFSelTenkai #sType #sPathB)) (/= "continue" #sFileB))
    (while (and (setq #sFileB (KCFSelTenkai #sType #sPathB)) (/= "continue" #sFileB) (/= "cancel" #sFileB))

      ; 01/12/09 HN S-ADD UNDO�^�L�����Z��������ǉ�
      ;@MOD@; �W�J���}���_
      ;@MOD@(setq #sView  (substr #sFileB (+ 1 (strlen #sPathB)) 1))
      ;@MOD@(setq #sView2 (substr #sFileB (+ 2 (strlen #sPathB)) 1)) ; 01/05/23 HN ADD
      ;@MOD@
      ;@MOD@(cond
      ;@MOD@  ;; ���ʐ}
      ;@MOD@  ((= "P" #sView)
      ;@MOD@    (SCFDrawPlanLayout #sFileB nil CG_KitType #sType)
      ;@MOD@    (setq CG_LAYOUT$ (cons "P" CG_LAYOUT$)) ; 01/05/23 HN ADD
      ;@MOD@  )
      ;@MOD@  ;; ���ʐ}
      ;@MOD@  ((= "S" #sView)
      ;@MOD@    (SCFDrawExpandLayout #sFileB nil CG_KitType #sType)
      ;@MOD@    (setq CG_LAYOUT$ (cons #sView2 CG_LAYOUT$)) ; 01/05/23 HN ADD
      ;@MOD@  )
      ;@MOD@  ;; �d�l�}  01/05/09 HN ADD
      ;@MOD@  ((= "Table" #sFileB)
      ;@MOD@    (SCFDrawTableLayout #sFileS nil)
      ;@MOD@    (setq CG_LAYOUT$ (cons "S" CG_LAYOUT$)) ; 01/05/23 HN ADD
      ;@MOD@  )
      ;@MOD@) ;_cond
      ;@MOD@
      ;@MOD@;�V���{���}�`�폜
      ;@MOD@(if DelSymEntity (DelSymEntity))
      (cond
        ; �z�u�P�񕪂�߂�
        ((= "undo" #sFileB)
          (if CG_LAYOUT$
            (progn
              (command "_.UNDO" "1")
              (setq CG_LAYOUT$ (cdr CG_LAYOUT$))
            )
            (alert "�߂����}�����݂��܂���.")
          )
        )

        ; �I�����ꂽ�W�J���}��z�u
        (T
          (command "_.UNDO" "BE")

          ; �W�J���}���_
          (setq #sView  (substr #sFileB (+ 1 (strlen #sPathB)) 1))
          (setq #sView2 (substr #sFileB (+ 2 (strlen #sPathB)) 1)) ; 01/05/23 HN ADD

          (cond
            ;; ���ʐ}
            ((= "P" #sView)
              (SCFDrawPlanLayout #sFileB nil CG_KitType #sType)
              (setq CG_LAYOUT$ (cons "P" CG_LAYOUT$)) ; 01/05/23 HN ADD
            )
            ;; ���ʐ}
            ((= "S" #sView)
              (SCFDrawExpandLayout #sFileB nil CG_KitType #sType)
              (setq CG_LAYOUT$ (cons #sView2 CG_LAYOUT$)) ; 01/05/23 HN ADD
            )
            ;; �d�l�}  01/05/09 HN ADD
            ((= "Table" #sFileB)
              (SCFDrawTableLayout #sFileS nil)
              (setq CG_LAYOUT$ (cons "S" CG_LAYOUT$)) ; 01/05/23 HN ADD
            )
          ) ;_cond

          ;�V���{���}�`�폜
          (if DelSymEntity (DelSymEntity))
          (command "_.UNDO" "E")
        )
      ) ;_cond
      ; 01/12/09 HN E-ADD UNDO�^�L�����Z��������ǉ�

    ) ;_while
  ) ;_if

  ;; �p�}�z�u  ���Ή�
  ;;(DispFigure)

  (if (/= "" #sType)
    (progn
      ;�o�}�`���\��
      (SKFSetHidePLayer)

      ;�n�b�`���O�X�V
      (CFRefreshHatchEnt)

      ; �B���ʉ�w���\��
      (command "_.-LAYER" "ON" "O_HIDE" "")

      ;�^�C�g����}
      (cond
        ((= CG_OUTSHOHINZU #sType) (SCFMakeTitleText "���i�}"))
        ((= CG_OUTSEKOUZU  #sType) (SCFMakeTitleText "�{�H�}"))
      )

      ;�p�[�W
      (PurgeBlock)

      ;�Y�[��(�}�ʑS��)
      (command "_.ZOOM" "A")

      ;�}�ʕۑ�
      ; 01/05/22 HN S-MOD �����}�ʑΉ�
      ;MOD(setq #sFileD (strcat CG_KENMEI_PATH "OUTPUT\\" #sFileT "_" CG_RyoNo "_" #sType ".dwg"))
      (if CG_FreeLayoutNo
        (setq CG_FreeLayoutNo (1+ CG_FreeLayoutNo))
        (setq CG_FreeLayoutNo 1)
      )
      (setq #sFileD (strcat CG_KENMEI_PATH "OUTPUT\\" #sFileT "_" (itoa CG_FreeLayoutNo) "_" #sType ".dwg"))
      ; 01/05/22 HN E-MOD �����}�ʑΉ�
      (command "_.SAVEAS" "2000" #sFileD)

      ; 01/05/22 HN S-MOD �����}�ʑΉ�
      (cond
        ; 01/12/09 HN S-ADD �L�����Z��������ǉ�
        ((= "cancel" #sFileB)
          (setq CG_FreeLayoutNo       nil)
          (setq CG_LayoutFreeContinue nil)
          (setq CG_PatNo              999)
        )
        ; 01/12/09 HN E-ADD �L�����Z��������ǉ�
        ((= "continue" #sFileB)
          (setq CG_LayoutFreeContinue T)
          ;;;;(setq CG_OpenMode 4)
          ;;;;(SCFCmnFileOpen (strcat CG_TMPPATH (car (nth CG_PatNo CG_Pattern)) ".dwt") 0)
        )
        ((= nil #sFileB)
          (setq CG_FreeLayoutNo       nil)
          (setq CG_LayoutFreeContinue nil)
        )
      );_cond
      ; 01/05/22 HN E-MOD �����}�ʑΉ�
    ) ;_progn
  ) ;_if

  (princ)
) ;_SCFLayoutFree

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetEntsLast
;;; <�����T�v>: �w�肵���}�`����ɍ쐬���ꂽ�}�`���擾����
;;; <�߂�l>  : �I���Z�b�g
;;; <���l>    : �w�肵���}�`��߂�l�Ɋ܂܂Ȃ��B
;;; <�쐬>    : 01/05/04 HN
;;;************************************************************************>MOH<
(defun SCFGetEntsLast
  (
  &sHnd       ; �}�`�n���h��
  /
  #psLast     ; �I���Z�b�g(�߂�l)
  #sHndL      ; �w��}�`�̐}�`�n���h��
  #iCnt       ; �J�E���^
  #sHnd       ; �}�`�n���h��
  #psX        ; �S�}�`�̑I���Z�b�g
  #ent        ; �}�`��
  )
  (setq #psLast (ssadd))
  (setq #sHndL &sHnd)
  (while (> 5 (strlen #sHndL))
    (setq #sHndL (strcat "0" #sHndL))
  ) ;_while

  (setq #iCnt 0)
  (if (setq #psX (ssget "X"))
    (repeat (sslength #psX)
      (setq #ent (ssname #psX #iCnt))
      (setq #sHnd (cdr (assoc 5 (entget #ent))))
      (while (> 5 (strlen #sHnd))
        (setq #sHnd (strcat "0" #sHnd))
      ) ;_while
      (if (< #sHndL #sHnd)
        (setq #psLast (ssadd #ent #psLast))
      )
      (setq #iCnt (1+ #iCnt))
    ) ;_repeat
  ) ;_if

  (if (< 0 (sslength #psLast))
    #psLast
    nil
  )
) ;_SCFGetEntsLast

;;;<HOM>************************************************************************
;;; <�֐���>  : C:PickStyleOn
;;; <�����T�v>: �O���[�v���I�������悤�ɂ��܂��B
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun C:PickStyleOn
  (
  /
  )
  (cond
    ((= 0 (getvar "PICKSTYLE")) (setvar "PICKSTYLE" 1))
    ((= 2 (getvar "PICKSTYLE")) (setvar "PICKSTYLE" 3))
  )
  (princ "\n��ٰ�߂��I������܂�.")

  (princ)
) ;_C:PickStyleOn

;;;<HOM>************************************************************************
;;; <�֐���>  : C:PickStyleOff
;;; <�����T�v>: �O���[�v���I�������悤�ɂ��܂��B
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun C:PickStyleOff
  (
  /
  )
  (cond
    ((= 1 (getvar "PICKSTYLE")) (setvar "PICKSTYLE" 0))
    ((= 3 (getvar "PICKSTYLE")) (setvar "PICKSTYLE" 2))
  )
  (princ "\n��ٰ�߂��I������܂���.")

  (princ)
) ;_C:PickStyleOff

;;;<HOM>************************************************************************
;;; <�֐���>  : KCFChgDimAngHigh
;;; <�����T�v>: ���@���̉�]�p�x�ƍ�����ύX
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : ��]�p�x���O�ɕύX
;;;             ������10000 �ɕύX
;;;************************************************************************>MOH<
(defun KCFChgDimAngHigh
  (
  &psDim      ; �I���Z�b�g
  /
  #iCnt       ; �J�E���^
  #eDim       ; �}�`��
  )

  (setq #iCnt 0)
  (repeat (sslength &psDim)
    (setq #eDim (ssname &psDim #iCnt))
    (if (equal "DIMENSION" (cdr (assoc 0 (entget #eDim))))
      (progn
        (SCFEntmodFindDimension #eDim)
      )
    )
    (setq #iCnt (1+ #iCnt))
  )

  (princ)
) ;_KCFChgDimAngHigh

;;;<HOM>************************************************************************
;;; <�֐���>  : KCFGetKichenType
;;; <�����T�v>: ���[�N�g�b�v����L�b�`���^�C�v���l������
;;; <�߂�l>  : �L�b�`���^�C�v
;;;             "I-LEFT"
;;;             "I-RIGHT"
;;;             "L-LEFT"
;;;             "L-RIGHT"
;;;             "D-RIGHT"
;;; <���l>    : �֐�(SKGetKichenType)�̕ύX��
;;; <�쐬>    : 2001/06/23 HN
;;;************************************************************************>MOH<
(defun KCFGetKichenType
  (
  /
  #eWT        ; ���[�N�g�b�v�̐}�`��
  #sWT$       ; ���[�N�g�b�v�̊g���f�[�^
  #iType      ; �`��^�C�v
  #sKitchen   ; ���E����
  #sView      ; �L�b�`���^�C�v
  )

  ; ���[�N�g�b�v�}�`�����擾
  (setq #eWT (car (SCFGetWkTopXData)))
  (if #eWT
    (progn
      (setq #sWT$ (CfGetXData #eWT "G_WRKT"))
      (setq #iType    (nth  3 #sWT$))
      (setq #sKitchen (nth 30 #sWT$))
    )
  ) ;_if

  (cond
    ; �h�^
    ((and (= 0 #iType)(= "L" #sKitchen))  (setq #sView "I-LEFT" ))
    ((and (= 0 #iType)(= "R" #sKitchen))  (setq #sView "I-RIGHT"))
    ; �k�^
    ((and (= 1 #iType)(= "L" #sKitchen))  (setq #sView "L-LEFT" ))
    ((and (= 1 #iType)(= "R" #sKitchen))  (setq #sView "L-RIGHT"))
    ; �t�^
    ((and (= 2 #iType)(= "L" #sKitchen))  (setq #sView "I-LEFT" ))
    ((and (= 2 #iType)(= "R" #sKitchen))  (setq #sView "I-RIGHT"))
    ; ���̑�
    (T (setq #sView "D-RIGHT"))
  ) ;_cond

  #sView
) ;_KCFGetKichenType

;;;<HOM>************************************************************************
;;; <�֐���>  : C:KPInsertBlockT
;;; <�����T�v>: �W�J���}�}���R�}���h
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : ���C�A�E�g�}�ʂ͊J������ԂƂ���B
;;;             �p�[�X�}�E�p�}�͑Ή����܂���B
;;; <��۰���> :
;;;             CG_KENMEI_PATH  : �v�����t�H���_�̃p�X��
;;;             CG_Pattern      : �e���v���[�g�t�@�C�������X�g
;;;             CG_PatNo        : �e���v���[�g�t�@�C�������X�g�̗v�f�ԍ�
;;;             CG_KitType      : �L�b�`���^�C�v  ex. "I-LEFT" "I-RIGHT"
;;;             CG_LAYOUT$      : �z�u�ςݓW�J���}�L���̃��X�g
;;;                               "P" ���ʐ}
;;;                               "A" �W�J�`�}
;;;                               "B" �W�J�a�}
;;;                               "C" �W�J�b�}
;;;                               "D" �W�J�c�}
;;;                               "E" �W�J�d�}
;;;                               "F" �W�J�e�}
;;;                               "S" �d�l�\
;;; <�쐬>    : 01/06/23 HN
;;;************************************************************************>MOH<
(defun C:KPInsertBlockT
  (
  /
  #sPathB     ; �W�J���}�p�X��
  #sFileB     ; �W�J���}�t�@�C����(�t���p�X)
  #sFileS     ; �d�l�\���}�ʃt�@�C����(�t���p�X)
  #sFileD     ; ���ݐ}�ʃt�@�C����
  #sType      ; �}�ʎ��  "02":���i�}  "04":�{�H�}77
  #sView      ; ���_���  "P":����  "S":����  "D":�d�l�\  "M":���f��(�p�[�X)
  #sView2     ; ���ʎ��  "A" "B" "C" "D" "E" "F"
  )
  ; �R�}���h�̏�����
  (StartUndoErr)

  ; 02/01/22 HN ADD ���ݍ��x��0.0�ɐݒ�
  (setvar "ELEVATION" 0.0)

  ; �{�@�\�Ŏg�p���Ȃ��O���[�o���ϐ���������
  (setq CG_PatNo   nil)
  (setq CG_Pattern nil)

  ; 02/04/25 YM ADD-S
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  ; 02/04/25 YM ADD-E

  ; 01/06/25 HN S-ADD �W�J���}
  (setq
    CG_DimPat
    (list
      "1"   ; �L���r�l�b�g���@ "1":ON  "0":OFF
      "1"   ; �{�H���@         "1":ON  "0":OFF
      "A"   ; "A":����  "L":��  "R":�E
      "Y"   ; "T":�c    "Y":��
    )
  )

  ; �t�H���_�E�t�@�C�����ݒ�
  (setq #sPathB (strcat CG_KENMEI_PATH "BLOCK\\"  ))
  (setq #sFileS (strcat CG_KENMEI_PATH "Table.cfg"))

  ; �L�b�`���^�C�v�擾
  (setq CG_KitType (KCFGetKichenType))

  ; ���ݐ}�ʖ��̉��Q������}�ʎ�ނ��擾
  (setq #sFileD (getvar "DWGNAME"))
  (setq #sType  (substr #sFileD (- (strlen #sFileD) 5) 2))

  ; 02/03/28 HN S-ADD �}�ʎ�ނ��擾
  (if
    (and
      (/= CG_OUTSHOHINZU #sType)
      (/= CG_OUTSEKOUZU  #sType)
    )
    (setq #sType (car (CfGetXrecord "DRAWTYPE")))
  );_if
  (if
    (and
      (/= CG_OUTSHOHINZU #sType)
      (/= CG_OUTSEKOUZU  #sType)
    )
    (progn
      (alert "̧�ٖ����ύX����Đ}�ʎ�ނ����f�ł��܂���.\n�{�H�}�Ƃ��ď������܂�.")
      (setq #sType CG_OUTSEKOUZU)
    )
  );_if
  ; 02/03/28 HN E-ADD �}�ʎ�ނ��擾

  (setq CG_LAYOUT$ nil)
  (command "_.UNDO" "M")

  ;; �_�C�A���O����W�J���}��I�����Ĕz�u
  ;; �L�����Z��(nil)�ŏI��
  (if (/= "" #sType)
    ; 01/12/09 HN S-MOD UNDO�^�L�����Z��������ǉ�
    ;@MOD@(while (and (setq #sFileB (KCFSelTenkai #sType #sPathB)))
    ;@MOD@
    ;@MOD@  ; �W�J���}���_
    ;@MOD@  (setq #sView  (substr #sFileB (+ 1 (strlen #sPathB)) 1))
    ;@MOD@  (setq #sView2 (substr #sFileB (+ 2 (strlen #sPathB)) 1))
    ;@MOD@
    ;@MOD@  (cond
    ;@MOD@    ;; ���ʐ}
    ;@MOD@    ((= "P" #sView)
    ;@MOD@      (SCFDrawPlanLayout #sFileB nil CG_KitType #sType)
    ;@MOD@      (setq CG_LAYOUT$ (cons "P" CG_LAYOUT$))
    ;@MOD@    )
    ;@MOD@    ;; ���ʐ}
    ;@MOD@    ((= "S" #sView)
    ;@MOD@      (SCFDrawExpandLayout #sFileB nil CG_KitType #sType)
    ;@MOD@      (setq CG_LAYOUT$ (cons #sView2 CG_LAYOUT$))
    ;@MOD@    )
    ;@MOD@    ;; �d�l�}
    ;@MOD@    ((= "Table" #sFileB)
    ;@MOD@      (SCFDrawTableLayout #sFileS nil)
    ;@MOD@      (setq CG_LAYOUT$ (cons "S" CG_LAYOUT$))
    ;@MOD@    )
    ;@MOD@  ) ;_cond
    ;@MOD@
    ;@MOD@  ;�V���{���}�`�폜
    ;@MOD@  (if DelSymEntity (DelSymEntity))
    ;@MOD@) ;_while
    (while (and (setq #sFileB (KCFSelTenkai #sType #sPathB)) (/= "cancel" #sFileB))
      (cond
        ; �z�u�P�񕪂�߂�
        ((= "undo" #sFileB)
          (if CG_LAYOUT$
            (progn
              (command "_.UNDO" "1")
              (setq CG_LAYOUT$ (cdr CG_LAYOUT$))
            )
            (alert "�߂����}�����݂��܂���.")
          )
        )

        ; �I�����ꂽ�W�J���}��z�u
        (T
          (command "_.UNDO" "BE")

          ; �W�J���}���_
          (setq #sView  (substr #sFileB (+ 1 (strlen #sPathB)) 1))
          (setq #sView2 (substr #sFileB (+ 2 (strlen #sPathB)) 1))

          (cond
            ;; ���ʐ}
            ((= "P" #sView)
              (SCFDrawPlanLayout #sFileB nil CG_KitType #sType)
              (setq CG_LAYOUT$ (cons "P" CG_LAYOUT$))
            )
            ;; ���ʐ}
            ((= "S" #sView)
              (SCFDrawExpandLayout #sFileB nil CG_KitType #sType)
              (setq CG_LAYOUT$ (cons #sView2 CG_LAYOUT$))
            )
            ;; �d�l�}
            ((= "Table" #sFileB)
              (SCFDrawTableLayout #sFileS nil)
              (setq CG_LAYOUT$ (cons "S" CG_LAYOUT$))
            )
          ) ;_cond

          ;�V���{���}�`�폜
          (if DelSymEntity (DelSymEntity))

          (command "_.UNDO" "E")
        )
      ) ;_cond
    ) ;_while

    ; 01/12/09 HN E-MOD UNDO�^�L�����Z��������ǉ�
  ) ;_if

  ; 01/12/09 HN S-ADD �L�����Z��������ǉ�
  (if (= "cancel" #sFileB)
    (repeat (length CG_LAYOUT$)
      (command "_.UNDO" "1")
    )
  ) ;_if
  ; 01/12/09 HN E-ADD �L�����Z��������ǉ�

  ; 02/01/22 HN ADD ���ݍ��x��15000�ɐݒ�
  (setvar "ELEVATION" CG_LAYOUT_DIM_Z)

;�n�b�`���O�X�V ���t���V�̃n�b�`���O���h��Ԃ��ɂȂ�̂��������
(CFRefreshHatchEnt) ;06/03/15 YM ADD

  ;03/11/12 YM ADD
  (SCAutoFDispOnOff)

  (setq *error* nil)
  (princ)
) ; C:KPInsertBlockT

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetGroupName
;;; <�����T�v>: �O���[�v���̂��w�肳��Ă��邩���肷��
;;; <�߂�l>  : �g�p����Ă��Ȃ��O���[�v����
;;;             ������"1"�`"999"�Ȃǔԍ�������t������
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SCFGetGroupName
  (
  &sGroup     ; �O���[�v����
  /
  #sGroup     ; �O���[�v����(�߂�l)
  #vDict$     ; �f�B�N�V���i�����̍��ړ��e
  #iCnt       ; �J�E���^
  )
  (setq #sGroup &sGroup)
  (setq #vDict$ (dictsearch (namedobjdict) "ACAD_GROUP"))
  (setq #iCnt 1)

  (while (member (cons 3 #sGroup) #vDict$)
    (setq #sGroup (strcat &sGroup "_" (itoa #iCnt)))
    (setq #iCnt (1+ #iCnt)) ; 02/03/04 YM ADD
  )

  #sGroup
);_defun

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFDrawTableLayout
;;; <�����T�v>: ���C�A�E�g�}�쐬 �d�l�\
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;; <����>    : 01/06/23 HN �z�u�ʒu�w��̏ꍇ�AMOVE����BLOCK-INSERT�ɕύX
;;;************************************************************************>MOH<
(defun SCFDrawTableLayout
  (
  &sMfile     ; �W�J���}�t�@�C����
  &eEn        ; �̈�}�`��
  /
  #lasten #CG_SpecList$$ #ss_b #n1 #n2 #code #name #kind #ss #i #en #eg
  #1 #y2 #n110y #n111y #code10y #code11y #name10y #name11y #kind10y #kind11y
  #eg$ #10y$ #11y$ #dis #off #str$ #str #10y #11y #10 #11 #10_n #11_n #subst
  #ssv #ssh #y #dis10 #dis11 #pt #xSp #xSl #iI #eEn #dMin #dMax #dEm #Pt$ #dVm
  #dRScale
  #sBlock     ; �u���b�N�� 01/06/23 HN ADD
  )
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart) ; 02/06/11 YM ADD

  (setq #lasten (entlast))
  ;�d�l�\�Ǎ���
  (setq #CG_SpecList$$ (ReadCSVFile &sMfile))

  ;�d�l�\���}�`�}��
  (command "_insert" (strcat CG_BLOCKPATH "Table.dwg") "0,0,0" 1 1 "0")
  (command "_explode" (entlast))
  (setq #ss_b (ssget "P"))
  (setq
    #n1       "S^N1"
    #n2       "S^N2"
    #LAST_HIN "S^�ŏI�i��"
    #WWW      "S^��"
    #HHH      "S^����"
    #DDD      "S^���s"
    #HINMEI   "S^�i��"
  )
  (setq #ss (ssget "X" (list (cons 0 "TEXT")(cons 8 "0_TEXT")(cons 1 "S^*"))))
  (if (/= nil #ss)
    (progn
      ;�}�`�f�[�^�擾
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #eg (entget #en))
        (setq #1  (cdr (assoc 1 #eg)))
        (cond
          ((equal #n2   #1)  (setq #y2    (cadr (cdr (assoc 10 #eg)))))
          ((equal #n1   #1)
            (setq #n1      #eg)
            (setq #n110y   (cadr (cdr (assoc 10 #eg))))
            (setq #n111y   (cadr (cdr (assoc 11 #eg))))
          )
          ((equal #LAST_HIN #1)
            (setq #LAST_HIN    #eg)
            (setq #LAST_HIN10y (cadr (cdr (assoc 10 #eg))))
            (setq #LAST_HIN11y (cadr (cdr (assoc 11 #eg))))
          )
          ((equal #WWW #1)
            (setq #WWW    #eg)
            (setq #WWW10y (cadr (cdr (assoc 10 #eg))))
            (setq #WWW11y (cadr (cdr (assoc 11 #eg))))
          )
          ((equal #HHH #1)
            (setq #HHH    #eg)
            (setq #HHH10y (cadr (cdr (assoc 10 #eg))))
            (setq #HHH11y (cadr (cdr (assoc 11 #eg))))
          )
          ((equal #DDD #1)
            (setq #DDD    #eg)
            (setq #DDD10y (cadr (cdr (assoc 10 #eg))))
            (setq #DDD11y (cadr (cdr (assoc 11 #eg))))
          )
          ((equal #HINMEI #1)
            (setq #HINMEI    #eg)
            (setq #HINMEI10y (cadr (cdr (assoc 10 #eg))))
            (setq #HINMEI11y (cadr (cdr (assoc 11 #eg))))
          )
          (T                 nil)
        )
        (entdel #en)
        (setq #i (1+ #i))
      )
      (setq #eg$  (list #n1    #LAST_HIN    #WWW    #HHH    #DDD    #HINMEI   ))
      (setq #10y$ (list #n110y #LAST_HIN10y #WWW10y #HHH10y #DDD10y #HINMEI10y))
      (setq #11y$ (list #n111y #LAST_HIN11y #WWW11y #HHH11y #DDD11y #HINMEI11y))
      ;y�������̋���
      (setq #dis (abs (- #y2 (cadr (cdr (assoc 10 #n1))))))
      (setq #off 0)

      ; 01/10/30 YM ADD-S ������[S:AG]-->""�Ƃ���
;;;01/12/07YM@MOD     (setq #CG_SpecList$$ (KP_DelDrSeri #CG_SpecList$$ 2)) ; ��װ�����ނ�s��C��
      ; 01/10/30 YM ADD-E

      ;�������}

      (mapcar
       '(lambda ( #str$ )
          (setq #i 0)
          (mapcar
           '(lambda ( #str #eg #10y #11y)

;;;              (if (= 3 #i)
;;;                (setq #str (substr #str 2))
;;;              )

;;;             ; 01/06/20 YM ADD NAS �Ǝ����� START
;;;              (if (= 1 #i)
;;;               (progn
;;;                 (setq #LR (NPGetLR #str))
;;;                 (setq #str (NPAddHinDrCol2 #str #LR))
;;;
;;;               )
;;;              );_if
;;;             ; 01/06/20 YM ADD NAS �Ǝ����� END

              (setq #10 (cdr (assoc 10 #eg)))
              (setq #11 (cdr (assoc 11 #eg)))
              (setq #10_n (list (car #10) (- #10y #off) (caddr #10)))
              (setq #11_n (list (car #11) (- #11y #off) (caddr #11)))
              (setq #subst (subst (cons 10 #10_n) (assoc 10 #eg) #eg))
              (setq #subst (subst (cons 11 #11_n) (assoc 11 #subst) #subst))
              (setq #subst (subst (cons 1  #str)  (assoc  1 #subst) #subst))
              (entmake (cdr #subst))
              (ssadd (entlast) #ss_b)
              (setq #i (1+ #i))

            )
            #str$ #eg$ #10y$ #11y$
          )
          (setq #off (+ #dis #off))
        )
        #CG_SpecList$$
      )

    )
    (progn
      (CFOutStateLog 0 51 "SAMPLE�����񂪂���܂���")
    )
  )

  ;������}
  (setq #ssv (ssget "X" (list (list -3 (list "G_VLINE")))))
  (setq #ssh (ssget "X" (list (list -3 (list "G_HLINE")))))
  (setq #eg (entget (ssname #ssh 0)))
  (setq #10 (cdr (assoc 10 #eg)))
  (setq #11 (cdr (assoc 11 #eg)))
  (setq #off #dis)
  (repeat (length #CG_SpecList$$)
    (setq #10_n (list (car #10) (- (cadr #10) #off) (caddr #10)))
    (setq #11_n (list (car #11) (- (cadr #11) #off) (caddr #11)))
    (setq #subst (subst (cons 10 #10_n) (assoc 10 #eg) #eg))
    (setq #subst (subst (cons 11 #11_n) (assoc 11 #subst) #subst))
    (entmake (cdr #subst))
    (ssadd (entlast) #ss_b)
    (setq #off (+ #dis #off))
  )
  (setq #y (cadr #10_n))

	; 2013/09/11 YM ADD ���ߕ�����ǉ����� Errmsg.ini�Q��
;	(NS_AddTableMoji) ;�ړ�

  (setq #i 0)
  (repeat (sslength #ssv)
    (setq #en (ssname #ssv #i))
    (setq #eg (entget #en '("*")))
    (setq #10 (cdr (assoc 10 #eg)))
    (setq #11 (cdr (assoc 11 #eg)))
    (setq #dis10 (abs (- #y (cadr #10))))
    (setq #dis11 (abs (- #y (cadr #11))))
    (if (< #dis10 #dis11)
      (progn
        (setq #pt (list (car #10) #y (caddr #10)))
        (setq #subst (subst (cons 10 #pt) (cons 10 #10) #eg))
      )
      (progn
        (setq #pt (list (car #11) #y (caddr #11)))
        (setq #subst (subst (cons 11 #pt) (cons 11 #11) #eg))
      )
    )
    (entmod #subst)
    (setq #i (1+ #i))
  )

  ;�d�l�\�}�`�l��
  (setq #xSp (ssadd))
  (while (setq #lasten (entnext #lasten))
    (ssadd #lasten #xSp)
  )

  ; 2000/05/30 �y�� �̈�}����_�𒆐S����E��ɕύX ���� �ړx��������
  ;�}�`���_�l��
  ;(setq #xSl (ssget "X" (list (list -3 (list "G_VLINE")))))
  ;(setq #iI 0)
  ;(repeat (sslength #xSl)
  ;  (setq #eEn (ssname #xSl #iI))
  ;  (cond
  ;    ((= 0 (nth 0 (CfGetXData #eEn "G_VLINE")))
  ;      (setq #dMin (cdr (assoc 11 (entget #eEn))))
  ;    )
  ;    ((= 4 (nth 0 (CfGetXData #eEn "G_VLINE")))
  ;      (setq #dMax (cdr (assoc 10 (entget #eEn))))
  ;    )
  ;    (T
  ;      nil
  ;    )
  ;  )
  ;  (setq #iI (1+ #iI))
  ;)
  ;(setq #dEm (mapcar '* '(0.5 0.5 1.0) (mapcar '+ #dMin #dMax)))
  ;;�̈撆�_�l��
  ;(setq #Pt$  (mapcar 'car (get_allpt_H &eEn)))
  ;(setq #dMin (list (apply 'min (mapcar 'car #Pt$)) (apply 'min (mapcar 'cadr #Pt$))))
  ;(setq #dMax (list (apply 'max (mapcar 'car #Pt$)) (apply 'max (mapcar 'cadr #Pt$))))
  ;(setq #dVm  (mapcar '* '(0.5 0.5 1.0) (mapcar '+ #dMin #dMax)))

  ;�}�`�E��_�l��
  (setq #xSl (ssget "X" (list (list -3 (list "G_VLINE")))))
  (setq #iI 0)
  (repeat (sslength #xSl)
    (setq #eEn (ssname #xSl #iI))
    (cond
      ((= 0 (nth 0 (CfGetXData #eEn "G_VLINE")))
        (setq #dMin (cdr (assoc 11 (entget #eEn))))
      )
      ((= 4 (nth 0 (CfGetXData #eEn "G_VLINE")))
        (setq #dMax (cdr (assoc 10 (entget #eEn))))
      )
      (T
        nil
      )
    )
    (setq #iI (1+ #iI))
  )
  (setq #dEm #dMax)
  ;�̈�E��_�l��
  (setq #Pt$  (mapcar 'car (get_allpt_H &eEn)))
  (setq #dMax (list (apply 'max (mapcar 'car #Pt$)) (apply 'max (mapcar 'cadr #Pt$))))
  (setq #dVm #dMax)

  ; 01/03/02 HN S-DEL �ړx�ύX�������폜
  ;DEL;�ړx��ύX���� (Table.dwg ��30�ō쐬)   2000/05/29 �y���ύX
  ;DEL(setq #dRScale (/ (SCFGetWakuScale) 30.))
  ;DEL(command "._scale" #xSp "" #dEm #dRScale)
  ; 01/03/02 HN E-DEL �ړx�ύX�������폜

  ;�}�`�ړ�
  ; 01/06/23 HN S-MOD �t���[�z�u�̈ړ����@��ύX
  ;@MOD@; 01/05/09 HN MOD �t���[�e���v���[�g�̏ꍇ�A�ړ���w���ɕύX
  ;@MOD@;@MOD@(command "_move" #xSp "" #dEm #dVm)
  ;@MOD@(if &eEn
  ;@MOD@  (command "_MOVE" #xSp "" #dEm #dVm )
  ;@MOD@  (command "_MOVE" #xSp "" #dEm PAUSE)
  ;@MOD@)
  (if &eEn
    (progn
      (command "_MOVE" #xSp "" #dEm #dVm)
    )
    (progn
      (setq #sBlock "TableB")
      (command "_BLOCK"  #sBlock #dEm #xSp "")
      (command "_INSERT" #sBlock PAUSE 1 1 "0")
      (command "_explode" (entlast))
      (setq #xSp (ssget "P"))
    )
  ) ;_if
  ; 01/06/23 HN S-MOD �t���[�e���v���[�g�̈ړ����@��ύX

  ; 01/05/09 HN S-ADD �d�l�\�̃O���[�v��������ǉ�
  (setq #sGroup "TABLE")
  ; 02/01/22 HN ADD �O���[�v���̂̃`�F�b�N������ǉ�
  (setq #sGroup (SCFGetGroupName #sGroup))
  (command
    "-GROUP"    ; �I�u�W�F�N�g �O���[�v�ݒ�
    "C"         ; �쐬
    #sGroup     ; �O���[�v��
    #sGroup     ; �O���[�v����
    #xSp     ; �I�u�W�F�N�g
    ""
  )
  ; 01/05/09 HN E-ADD �d�l�\�̃O���[�v��������ǉ�


  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  (CFNoSnapEnd) ; 02/06/11 YM ADD

  (princ)
) ; SCFDrawTableLayout

;;;<HOM>************************************************************************
;;; <�֐���>  : NS_AddTableMoji
;;; <�����T�v>: ���C�A�E�g�}�쐬 �d�l�\�̉��ɒ��ߕ���ǉ�����
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : Errmsg.ini���Q�Ƃ���
;;;************************************************************************>MOH<
(defun NS_AddTableMoji (
;  &y  ; �����o���ʒu(Y���W)
	&sTmp ;�e���v���[�g�� �ړx�����߂�̎g�p
  /
  #I #KOSU #STR #Y #clayer #info_HIKITE #info_TEXT #info_POS
  #HEIGHT #INFO_HHH #RET$ #X #os
	#INFO_H_20 #INFO_H_30 #INFO_H_40 #INFO_POS_20 #INFO_POS_30 #INFO_POS_40
  )

  (setq #info_HIKITE (CFgetini "NOTES" "HIKITE"   (strcat CG_SKPATH "ERRMSG.INI")))

	;2020/01/07 YM MOD ������L���J���}��؂�Ή�  #info_HIKITE = "X,ZA,ZB"
;;;	(if (= CG_HIKITE #info_HIKITE)
	(if (wcmatch CG_HIKITE #info_HIKITE)
		(progn
			;OSNAP����
		  (setq #os (getvar "OSMODE"))
		  (setvar "OSMODE" 0)

		  (setq #info_TEXT   (CFgetini "NOTES" "TEXT"     (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_POS_20 (CFgetini "NOTES" "POS_1_20" (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_POS_30 (CFgetini "NOTES" "POS_1_30" (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_POS_40 (CFgetini "NOTES" "POS_1_40" (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_H_20   (CFgetini "NOTES" "H_1_20"   (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_H_30   (CFgetini "NOTES" "H_1_30"   (strcat CG_SKPATH "ERRMSG.INI")))
		  (setq #info_H_40   (CFgetini "NOTES" "H_1_40"   (strcat CG_SKPATH "ERRMSG.INI")))

		  (if (and #info_HIKITE #info_TEXT)
		    (progn
		      ;�ꎞ�I��"0"��w�ɂ���
		      (setq #clayer (getvar "CLAYER")); ���݂̉�w���L�[�v
		      (command "_layer" "S" "0" ""   ); ���݉�w�̕ύX

					;�ړx�ɂ���č��W��ϊ�
					(cond
						((vl-string-search "-20-" &sTmp)
				      (setq #ret$ (StrParse #info_POS_20 ","))
				      (setq #X (atof (car   #ret$)))
				      (setq #Y (atof (cadr  #ret$)))
							(setq #Height (atof #info_H_20));��������
					 	)
						((vl-string-search "-30-" &sTmp)
				      (setq #ret$ (StrParse #info_POS_30 ","))
				      (setq #X (atof (car   #ret$)))
				      (setq #Y (atof (cadr  #ret$)))
							(setq #Height (atof #info_H_30));��������
					 	)
						((vl-string-search "-40-" &sTmp)
				      (setq #ret$ (StrParse #info_POS_40 ","))
				      (setq #X (atof (car   #ret$)))
				      (setq #Y (atof (cadr  #ret$)))
							(setq #Height (atof #info_H_40));��������
					 	)
						(T
							nil ;	���W�͂��̂܂�
					 	)
					);_cond

					;������}
		      (command "._TEXT" "S" "STANDARD" (list #X #Y) #Height 0.0  #info_TEXT) ; ��������,�p�x

		      ; �ꎞ�I��"0"��w�ɂ���
		      (setvar "CLAYER" #clayer) ; ���̉�w�ɖ߂�
		    )
		  );_if

		  (setvar "OSMODE" #os)
    )
  );_if
  (princ)
);NS_AddTableMoji

; 02/01/19 HN S-ADD �p�[�X�}�̃J�������_���V���N�L���r�l�b�g�̔z�u�p�x�Ŕ��f
;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetAngSinkCab
;;; <�����T�v>: �V���N�L���r�l�b�g(���iCODE=112)�̔z�u�p�x���擾
;;; <�߂�l>  : �p�x(-180�`+180)
;;; <�쐬>    : 2002/01/18 HN
;;; <���l>    : �������݂���ꍇ�́A�Ō�Ɍ��������V���N�L���r�l�b�g�̔z�u�p�x
;;;             �p�x��-180�`+180��
;;;************************************************************************>MOH<
(defun SCFGetAngSinkCab
  (
  /
  #rAng       ; �z�u�p�x
  #iSinkCab   ; �V���N�L���r�l�b�g�̐��iCODE
  #iCnt       ; �J�E���^
  #psLSYM     ; ���ނ̑I���Z�b�g
  #vLSYM$     ; ���ނ̃V���{�����
  )
  (setq #rAng     0.0)
  (setq #iSinkCab 112)
  (setq #iCnt       0)

  (setq #psLSYM (ssget "X" (list (list -3 (list "G_LSYM")))))
  (if #psLSYM
    (repeat (sslength #psLSYM)
      (if (setq #vLSYM$ (CFGetXData (ssname #psLSYM #iCnt) "G_LSYM"))
        (if (= #iSinkCab (nth 9 #vLSYM$))
          (setq #rAng (* 180.0 (/ (nth 2 #vLSYM$) PI)))
        );_if
      );_if
      (setq #iCnt (1+ #iCnt))
    );_repeat
  );_if

  (if (< 180 #rAng)
    (setq #rAng (- #rAng 360))
  )

  #rAng
);_defun
; 02/01/19 HN E-ADD �p�[�X�}�̃J�������_���V���N�L���r�l�b�g�̔z�u�p�x�Ŕ��f

;;;<HOM>************************************************************************
;;; <�֐���>  : C:SCFConf
;;; <�����T�v>: �}�ʊm�F ---->�}�ʎQ��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun C:SCFConf (
  /
  #iOk #sFname
#sFname2 #ver ;-- 2011/10/06 A.SAtoh Add
  )
  (setq CG_SCFConf T) ; 02/03/04 YM

  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �O����
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (StartUndoErr)
  )
	;_if
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

;;;01/09/03YM@MOD  (StartCmnErr)
;;;(makeERR "�}�ʎQ��-1") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ �}�ʎQ��-1
  (if (/= nil CG_KENMEI_PATH)
    (progn

      ;�ۑ��m�F

      ; 01/09/07 YM MOD-S ����Ӱ�ނł͕ۑ����Ȃ� ;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
;;;     (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"�ǉ� 03/02/22 JPGڲ���Ӱ��
      (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
    ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
        (setq #iOk nil)
        (setq #iOk (CFYesNoDialog "�}�ʂ���x�ۑ����܂����H"))
      );_if
      ; 01/09/07 YM MOD-S ����Ӱ�ނł͕ۑ����Ȃ�

      (if (= T #iOK)
        (progn
          (SKB_WriteColorList);00/06/27 SN ADD
;;;03/04/18YM@MOD          (command "_.save" (strcat (getvar "dwgprefix") (getvar "dwgname")));00/06/21 SN MOD
          ;(command "qsave");00/06/21 SN MOD
;-- 2011/10/06 A.Satoh Add - S
;;;;;          (command "_.QSAVE")
;;;;;          (if (wcmatch (getvar "CMDNAMES") "*QSAVE*")
;;;;;            (command "2000" "")
;;;;;          )
          (setq #sFname2 (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
          (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
                  (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
            (setq #ver CG_DWG_VER_MODEL)
            (setq #ver CG_DWG_VER_SEKOU)
          )
          (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/06 A.Satoh Add - E
        )
      )
      ; ���݂̌�����OUTPAT�t�H���_���f�t�H���g�\������

      ; 01/09/07 YM MOD-S ����Ӱ�ނł͐}�ʎQ�Ƃ��Ȃ�;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
;;;     (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"�ǉ� 03/02/22 JPGڲ���Ӱ��
      (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
    ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
        (setq #sFname CG_AUTOMODE_ZUMEN)
        (setq #sFname (getfiled "�}�ʎQ��" (strcat CG_KENMEI_PATH "OUTPUT\\") "dwg" 2))
      );_if
      ; 01/09/07 YM MOD-E ����Ӱ�ނł͐}�ʎQ�Ƃ��Ȃ�

      (if (/= nil #sFname)
        (progn

          ;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
;;;         (if (or (= CG_AUTOMODE 2)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/31 YM ADD "4"�ǉ� 03/02/22 JPGڲ���Ӱ��
          (if (member CG_AUTOMODE '(2 4 5));2008/08/05 YM MOD
            nil ; WEB��CAD���ްӰ�ނ͐؂�ւ��Ȃ� "4" JPG�o��Ӱ�ނ����l
            ;// �ҏW���j���[�ɐ؂�ւ���
            (ChgSystemCADMenu "")
          );_if

          ; 01/09/07 YM MOD-S ����Ӱ�ނł�SCFCmnFileOpen�������Ȃ�;����Ƹ޼��JPG�o��04/09/13 YM ADD CG_AUTOMODE=5�ǉ�
;;;         (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)(= CG_AUTOMODE 4)(= CG_AUTOMODE 5)) ; 02/07/29 YM ADD 02/08/05 YM ADD "4"�ǉ� 03/02/22 JPGڲ���Ӱ��
          (if (member CG_AUTOMODE '(1 2 3 4 5));2008/08/05 YM MOD
        ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
            (progn
;-- 2011/10/06 A.Satoh Mod - S
;;;;;              (command ".qsave")
              (setq #sFname2 (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
              (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
                      (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
                (setq #ver CG_DWG_VER_MODEL)
                (setq #ver CG_DWG_VER_SEKOU)
              )
              (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/06 A.Satoh Mod - S
              (command "_.Open"     #sFName)

              (S::STARTUP)

            )
            (progn
              ; 2000/10/19 HT �֐���
              ;2011/08/12 YM ADD �}�ʎQ�Ƃ̂Ƃ������׸ނ𗧂Ă�
;;;             (setq CG_SCFConf T)
              (SCFCmnFileOpen #sFName 1) ; 2000/10/19 HT �֐���
;;;             (setq CG_SCFConf nil)
            )
          );_if
          ; 01/09/07 YM MOD-E ����Ӱ�ނł�SCFCmnFileOpen�������Ȃ�

        )
      )
    )
    (progn
      (CFAlertMsg "�������Ăяo����Ă��܂���.")
    )
  )
    
  ; 01/09/03 YM ADD-S UNDO�����ǉ�
  ; �㏈��
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (setq *error* nil)
  );_if
  ; 01/09/03 YM ADD-E UNDO�����ǉ�

  (princ)
);C:SCFConf



;;;<HOM>************************************************************************
;;; <�֐���>  : subSCFConf
;;; <�����T�v>: �}�ʎQ�ƂŊJ�����߰��}���߰��ޭ��̐ݒu���s��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : 2011/08/12 YM ADD
;;;************************************************************************>MOH<
(defun subSCFConf (
  /
  #8 #EG$ #I #SSVIEW #VID69L #VID69R
  )
  (setvar "pdmode" 0) ;2011/09/30 YM ADD

  (if CG_SCFConf
    (progn ;�}�ʎQ�Ƃ̂Ƃ�
      (setq CG_SCFConf nil)

      ;2011/08/11 YM ADD-S �߰��}�̂Ƃ����s���e�}�ɂȂ��Ă��܂�
      (if (vl-string-search "1-����" (strcase (getvar "DWGNAME")))
        (progn
          ;�������f����ԂɈړ�
          (setvar "TILEMODE" 0)
          (command "_.MSPACE")
          (setvar "PERSPECTIVE" 1)
;;;          (command "_.ZOOM" "E")
          (setvar "pdmode" 0) ;2011/09/30 YM ADD
          (command "_.PSPACE");2011/09/30 YM ADD
          (command "_REGEN");2011/09/30 YM ADD
        )
      );_if


      (if (vl-string-search "2-����" (strcase (getvar "DWGNAME")))
        (progn
          (setvar "TILEMODE" 0)
          (command "_.MSPACE")

          ;�Ζʗp2�ޭ��߰����������Ή�
          ;�Ζʗp�ޭ��߰Ă����邩�ǂ�������
          (setq #ssVIEW (ssget "X" '((0 . "VIEWPORT"))))
          (setq #i 0)
          (if (and #ssVIEW (< 0 (sslength #ssVIEW)))
            (progn
              (repeat (sslength #ssVIEW)
                (setq #eg$ (entget (ssname #ssVIEW #i)))
                (setq #8 (cdr (assoc  8 #eg$)));��w
                (if (= #8 "VIEWL");�Ζʗp����ڰĂ��ޭ��߰ĉ�w(��������)
                  (progn
                    (setq #VID69L (cdr (assoc 69 #eg$))) ; VIEWPORT ID
                  )
                );_if
                (if (= #8 "VIEWR");�Ζʗp����ڰĂ��ޭ��߰ĉ�w(�E�����ݸ�)
                  (progn
                    (setq #VID69R (cdr (assoc 69 #eg$))) ; VIEWPORT ID
                  )
                );_if
                (setq #i (1+ #i))
              )
            )
          );_if

          (setvar "CVPORT" #VID69L); �ޭ��߰�ID (��������)�ɐ؂�ւ����ޭ��̒���
;;;          (command "_.MSPACE")
          (setvar "PERSPECTIVE" 1)
;;;          (command "_.ZOOM" "E")
          (setvar "pdmode" 0) ;2011/09/30 YM ADD
;;;          (command "_.PSPACE");2011/09/30 YM ADD
          (command "_REGEN");2011/09/30 YM ADD

          (setvar "CVPORT" #VID69R); �ޭ��߰�ID (�E�����ݸ�)�ɐ؂�ւ����ޭ��̒���
;;;          (command "_.MSPACE")
          (setvar "PERSPECTIVE" 1)
;;;          (command "_.ZOOM" "E")
          (setvar "pdmode" 0) ;2011/09/30 YM ADD
          (command "_.PSPACE");2011/09/30 YM ADD
          (command "_REGEN");2011/09/30 YM ADD
        )
      );_if

      ;2011/08/11 YM ADD-E �߰��}�̂Ƃ����s���e�}�ɂȂ��Ă��܂�

    )
  );_if

  (princ)
);subSCFConf

;;;<HOM>************************************************************************
;;; <�֐���>    : C:SCFConfEnd
;;; <�����T�v>  : �����ɖ߂�
;;; <�߂�l>    : �Ȃ�
;;; <���l>      : �Ȃ�
;;;************************************************************************>MOH<
(defun C:SCFConfEnd (
  /
  #iOk #sFname
#DWGNAME #KAKUTYO #MSG #QUIT_FLG #STRLEN ; 02/10/18 YM ADD
#sFname2 #ver ;-- 2011/10/06 A.Satoh Add
  )
  ; 02/10/18 YM ADD-S
  (setq #quit_flg nil) ; T==>�������������ɂ��I������t���O
  ; 02/10/18 YM ADD-E

  (if (/= nil CG_KENMEI_PATH)
    (progn
      ;�ۑ��m�F

      ; 01/09/07 YM MOD-S ����Ӱ�ނł͕ۑ����Ȃ�
;;;     (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
      (if (member CG_AUTOMODE '(1 2 3));2008/08/05 YM MOD
    ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
        (setq #iOk T)
        ; 02/10/18 YM MOD-S DXF�`���ŕۑ�������͍ēx�ۑ������Ȃ�
        (progn
          ; ���݂̐}�ʂ̊g���q�ŕ��򂷂�
          (setq #dwgname (getvar "dwgname"))
          (setq #strlen (strlen #dwgname))
          (setq #kakutyo (substr #dwgname (- #strlen 2) 3))
          (if (= #kakutyo "dwg") ; �ʏ�̏ꍇ
            (progn
              (setq #iOk (CFYesNoDialog "�}�ʂ���x�ۑ����܂����H"))
            )
            (progn ; ����ȊO"dwt",dxf"
              (if (= #kakutyo "dwt")
                (setq #msg (strcat "�}�ʂ͕ۑ�����܂��񂪂�낵���ł����H"
                            "\n����ڰĂ̕ۑ��ɂ͕K���A[հ�ް����ڰ�][հ�ް����ڰĕۑ�]�����g����������"))
              ; else
                (setq #msg "�}�ʂ͕ۑ�����܂��񂪂�낵���ł����H")
              );_if

              (if (CFYesNoDialog #msg)
                (setq #iOk nil)    ; �}�ʂ�ۑ������ɏI��
              ; else
                (setq #quit_flg T) ; �������������ɂ��I��
              );_if
            )
          );_if

        )
      );_if


      (if #quit_flg ; 02/10/18 YM ADD #quit_flg�ŕ��򂷂�悤�ɏC��
        nil ; �������Ȃ�
      ; else
        (progn

          (if (= T #iOK)
            (progn
;;;03/04/18YM@MOD             (command "_.save" (strcat (getvar "dwgprefix") (getvar "dwgname")));00/06/21 SN MOD
;-- 2011/10/05 A.Satoh Add - S
;;;;;              ; 03/04/18 YM MOD-S
;;;;;              (command "_.QSAVE")
;;;;;              (if (wcmatch (getvar "CMDNAMES") "*QSAVE*")
;;;;;                (command "2000" "")
;;;;;              )
;;;;;              ; 03/04/18 YM MOD-E
;;;;;
;;;;;              ;(command "qsave");00/06/21 SN MOD
              (setq #sFname2 (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
              (if (or (= (strcase (getvar "DWGNAME")) "MODEL.dwg")
                      (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
                (setq #ver CG_DWG_VER_MODEL)
                (setq #ver CG_DWG_VER_SEKOU)
              )
              (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/05 A.Satoh Add - E
            )
          );_if

          (setq #sFname (strcat CG_KENMEI_PATH "MODEL.dwg"))
          ;// �ҏW���j���[�ɐ؂�ւ���
          (ChgSystemCADMenu CG_PROGMODE)

          ; 01/09/07 YM MOD-S ����Ӱ�ނł�SCFCmnFileOpen�������Ȃ�
;;;         (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
          (if (member CG_AUTOMODE '(1 2 3));2008/08/05 YM MOD
            (progn
;-- 2011/10/06 A.Satoh Mod - S
;;;;;              (command ".qsave")
              (setq #sFname2 (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
              (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
                      (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
                (setq #ver CG_DWG_VER_MODEL)
                (setq #ver CG_DWG_VER_SEKOU)
              )
              (command "_.SAVEAS" #ver #sFName2)
;-- 2011/10/06 A.Satoh Mod - E
              (command "_.Open" #sFName)
              (setq CG_OpenMode nil)
              (S::STARTUP)
            )
            ; 2000/10/19 HT �֐���
            (SCFCmnFileOpen #sFName 1) ; 2000/10/19 HT �֐���
          );_if
          ; 01/09/07 YM MOD-E ����Ӱ�ނł�SCFCmnFileOpen�������Ȃ�


        )
      );_if

    )
    (progn
      (CFAlertMsg "�������Ăяo����Ă��܂���.")
    )
  );_if

  ; 02/10/18 YM ADD-S
  (setq #quit_flg nil) ; T==>�������������ɂ��I������t���O
  ; 02/10/18 YM ADD-E

  (princ)
);C:SCFConfEnd

(princ)
;;;End of File
