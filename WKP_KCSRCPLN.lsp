;|
aaaa
bbb
ccc
����
|;

;;;(SKY_Stretch_Parts #eNEW (nth 5 #FIG$) (nth 6 #FIG$) (nth 7 #FIG$)))
;;;(W,D,H)=(20,450,2000)

;;; <�֐������p>
;;;(defun C:KP_AutoEXEC (      : �v������������}�ʏo�͂܂ōs��(�����ݸ޼��)
;;;(defun C:KPLocalAutoEXEC (  : WEB��LOCAL CAD�[���p�������s
;;;(defun C:Web_AutoEXEC (     : �v������������}�ʏo�͂܂ōs��.Web��CAD���ް����ڲ���
;;;(defun WEBclear (           : �}�ʸر�(�����}�ʏ�Ԃɖ߂�) �����g�p
;;;(defun NS_ChPlanInfo (      : PlanInfo.cfg���X�V����(�ʏ�Ӱ��)

;;;(defun C:SearchPlan �L�b�`���v��������
;;;(defun PK_ClearGlobal ( / ) ��۰��ٕϐ��̸ر�
;;;(defun PC_WriteSeriesInfo ���݂�SERIES�����t�@�C���ɏ����o��
;;;(defun PC_SearchPlanNewDWG �v���������p�̐V�K�}�ʂ��J��
;;;(defun C:PC_LayoutPlan �v�����������������s
;;;(defun C:PC_InsertPlan �v�����������ꂽ�}�ʂ�}������
;;;(defun PC_LayoutPlanExec �v�����������������s
;;;(defun PK_StartLayout �L�b�`��������ڲ��Ă���
;;;(defun PD_StartLayout �_�C�j���O������ڲ��Ă���
;;;(defun CPrint_Time ( / #date_time) ����(nick)�Ő��l�̌J��グ
;;;(defun PKG_SetFamilyCode   �L�b�`���p���͏����O���[�o���t�@�~���[�i��
;;;(defun PcPrintLog ( / )    �O���[�o�������O�ɂ����o��
;;;(defun SDG_SetFamilyCode �_�C�j���O�p���͏����O���[�o���t�@�~���[�i��
;;;(defun SKG_GetOptionHinban �I�v�V�����i�̕i�Ԃ��擾����

;;;(defun PKC_ModelLayout        �L�b�`���\�����ގ����z�u
;;;(defun PDC_ModelLayout        �_�C�j���O�\�����ގ����z�u
;;;(defun PKC_GetPlan            �v�����\�����擾
;;;(defun PDC_GetPln             �v�����\�����擾
;;;(defun PKC_MoveToSGCabinet    ���ʂk�A�q�̐}�`�݂̂��w��}�`�̑��ʂɈړ�������
;;;(defun PKC_MoveToSGCabinetSub ���ʂk�A�q�̐}�`�݂̂��w��}�`�̑��ʂɈړ�������
;;;(defun PFGetCompBase          �\�����ގ擾(�\���^�C�v=1) CG_UnitBase="1"

;;;(defun PKC_LayoutParts        �v�����\�����ޔz�u
;;;(defun PK_Stretch_SidePanel   ���݌������[���������ِL�k
;;;(defun PKC_LayoutOneParts     �P�ƕ��ޔz�u
;;;(defun PKC_InsertParts        ���ނ�z�u����
;;;(defun PKGetSQL_HUKU_KANRI    �����Ǘ�������SQL�����߂�


(setq ST_BLKSTART nil) ; <��۰��ْ�`>



  ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ; �S�����Ή���۰��ٕϐ� 01/10/02 YM ADD-S

  ; �W�J�}��ʑI���޲�۸ނ̖߂�l ����Ӱ�� 01/09/07 YM ADD
  (setq CG_AUTOMODE_TENKAI (list (list 1 1 1)(list "0")))

  ; ����ڰđI���޲�۸ނ̖߂�l ����Ӱ�� 01/09/07 YM ADD
;;; (setq CG_AUTOMODE_TEMPLT_L (list (list (list "SK_A3_��" "") (list "SK_A3_L�W" "")) "0" 1))
;;; (setq CG_AUTOMODE_TEMPLT_R (list (list (list "SK_A3_��" "") (list "SK_A3_R�W" "")) "0" 1))

;04/04/13 YM ADD WEB DIPLOA�Ζʁ@����������
;;;(setq CG_AUTOMODE_TEMPLT_L_TAIMEN
;;; (list (list (list "SK_A3_�Ζʗ�2" "") (list "SK_A3_�Ζ�AE�d" "") (list "SK_A3_�Ζ�B��D" "")) "0" 1))
;;;(setq CG_AUTOMODE_TEMPLT_R_TAIMEN
;;; (list (list (list "SK_A3_�Ζʗ�2" "") (list "SK_A3_�Ζ�AE�d" "") (list "SK_A3_�Ζ�B��D" "")) "0" 1))

;;; (setq CG_AUTOMODE_TEMPLT_JPG (list (list (list "JPG����" "")) "0" 1)) ; 03/02/22 YM ADD

  ; ���@�쐬�����޲�۸ނ̖߂�l ����Ӱ�� 01/09/07 YM ADD
;;; (setq CG_AUTOMODE_DIMMK_L (list (list "1" "1" "A" "Y") (list (list "SK_A3_��" "04") (list "SK_A3_L�W" "04"))))
;;; (setq CG_AUTOMODE_DIMMK_R (list (list "1" "1" "A" "Y") (list (list "SK_A3_��" "04") (list "SK_A3_R�W" "04"))))

;04/04/13 YM ADD WEB DIPLOA�Ζʁ@����������
;;;(setq CG_AUTOMODE_DIMMK_L_TAIMEN
;;; (list (list "1" "1" "A" "Y") (list (list "SK_A3_�Ζʗ�2" "04") (list "SK_A3_�Ζ�AE�d" "04") (list "SK_A3_�Ζ�B��D" "04"))))
;;;(setq CG_AUTOMODE_DIMMK_R_TAIMEN
;;; (list (list "1" "1" "A" "Y") (list (list "SK_A3_�Ζʗ�2" "04") (list "SK_A3_�Ζ�AE�d" "04") (list "SK_A3_�Ζ�B��D" "04"))))

;;; (setq CG_AUTOMODE_DIMMK_JPG (list (list "1" "1" "A" "Y") (list (list "JPG����" "04")))) ; 03/02/22 YM ADD

  ; �ȈՈ���޲�۸ނ̖߂�l ����Ӱ�� 01/09/07 YM ADD
  (setq CG_AUTOMODE_PRINT1 (list "paperA3" "scale1")) ; ���̐}
  (setq CG_AUTOMODE_PRINT2 (list "paperA3" "scale30")); �W�J�}
  (setq CG_AUTOMODE_PRINT3 (list "paperA3" "scale30")); �W�J�} DIPLOA 3���� 04/04/14 YM ADD
  (setq CG_AUTOMODE_PRINT4 (list "paperA3" "scale40")); �W�J�}

  ; �S�����Ή���۰��ٕϐ� 01/10/02 YM ADD-E
  ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

(setq ST_BLKSTART nil) ; <��۰��ْ�`>


;;;<HOM>*************************************************************************
;;; <�֐���>    : WebGetTemplate
;;; <�����T�v>  : WEB������ڰĖ����擾����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2008/08/04 YM ADD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun WebGetTemplate (
  &outid
  /
  #QRY$$ #TEMPLATE_NAME
#TEMPLATE_NAME$ #LR ;2009/01/17 YM ADD
  )

  (cond
    ((= CG_UnitCode "K")
      ;����
      (setq #qry$$
        (CFGetDBSQLRec CG_CDBSESSION "�}�ʃ��C�A�E�g"
          (list
            (list "OUTID"    &outid              'STR);1:�߰�,2:���i�},4:�{�H�}
            (list "�`��"     (nth 5 CG_GLOBAL$)  'STR)
            (list "���E����" (nth 11 CG_GLOBAL$) 'STR)
          )
        )
      )
    )
    ((= CG_UnitCode "D")

      (cond
        ;((= CG_SeriesDB "SDA") ;2011/02/01 YM MOD�yPG����z
        ((= BU_CODE_0003 "1")
          (setq #LR (nth 56 CG_GLOBAL$))
        )
        ;((= CG_SeriesDB "SDB") ;2011/02/01 YM MOD�yPG����z
        ((= BU_CODE_0003 "2")

          (setq #LR (nth 60 CG_GLOBAL$));���E�
          (cond
            ((= #LR "LL")
              (setq #LR "L")
            )
            ((= #LR "RR")
              (setq #LR "R")
            )
            (T
              (setq #LR "L")
            )
          );_cond

        )
        (T ;__OTHER

          (setq #LR (nth 60 CG_GLOBAL$));���E�
          (cond
            ((= #LR "LL")
              (setq #LR "L")
            )
            ((= #LR "RR")
              (setq #LR "R")
            )
            (T
              (setq #LR "L")
            )
          );_cond

        )
      );_cond
        
     
      ;���[
      (setq #qry$$
        (CFGetDBSQLRec CG_CDBSESSION "�}�ʃ��C�A�E�g"
          (list
            (list "OUTID"    &outid    'STR);1:�߰�,2:���i�},4:�{�H�}
            (list "�`��"     "D"       'STR)
            (list "���E����" #LR       'STR)
          )
        )
      )

    )
  );_if

  ;2009/01/17 YM MOD �������肦��
;;;  (if (and #qry$$ (= 1 (length #qry$$)))
;;;   (progn
;;;     (setq #Template_name (nth 5 (car #qry$$)))
;;;   )
;;;   ;else
;;;   (progn
;;;     (princ "\n�}�ʃ��C�A�E�g������܂���")
;;;   )
;;;  );_if

  ;2009/01/17 YM MOD �������肦��
  (setq #Template_name$ nil)
  (if #qry$$
    (progn
      (foreach #qry$ #qry$$
        (setq #Template_name (nth 5 #qry$))
        (setq #Template_name$ (append #Template_name$ (list #Template_name)))
      )
    )
    ;else
    (progn
      (princ "\n�}�ʃ��C�A�E�g������܂���")
    )
  );_if

  #Template_name$
);WebGetTemplate

;;;<HOM>*************************************************************************
;;; <�֐���>    : WebDefErrFunc
;;; <�����T�v>  : WEB�Ŵװ�֐����`����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 02/09/11 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun WebDefErrFunc ( / )
  ; 02/09/03 YM MOD �װ�֐��̕���g������ �����ōĒ�`���Ȃ��Ƃ����Ȃ�
  (cond
    ((= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* TempErr)
      );_if
    )
    ((= CG_AUTOMODE 1)
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError1)
      );_if
    )
    ((= CG_AUTOMODE 2)
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

  ;03/05/12 YM ADD-S
  (if (= 1 CG_DEBUG)(setq *error* nil))
  ;03/05/12 YM ADD-E
  (princ)
);WebDefErrFunc



(defun C:OK ( / )
  (C:Web_AutoEXEC)
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:Web_AutoEXEC
;;; <�����T�v>  : �v������������}�ʏo�͂܂ōs��.Web��CAD���ް����ڲ���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 02/07/29 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:Web_AutoEXEC (
  /
  #DATE_TIME #IFILEDIA #TEMPLATE_NAME #BLOCK$ #DWG$ #DXF$
  #TEMPLATE_NAME$ ;2009/0/1/17 YM ADD
  #NN #NN_DWG #NUMBER$
#BASE_FLG #ENSS$ #I #SKK$ #SS #UPPER_FLG ;2010/01/08 YM ADD
  )

  ; ���ޯ��Ӱ�ނ�ǉ� 03/04/23 YM ADD-S
  (cond
    ((= 1 CG_STOP)
      (princ "\n������ �����I�� ������")
      (setq CG_STOP 2)
      (CFAlertMsg "\n--- ���ޯ�Ӱ�� (C:OK) �ōĊJ---")
      (princ "\n������ OK �ōĊJ ������")
      (quit) ;�����I��
    )
    ((= 2 CG_STOP) ; �Ď��s��
      (if (CFYesNoDialog "�f�o�b�N���[�h�Ŏ��s���܂����H\n(�u�������v�Ȃ�����ײݏo�͂��Ȃ��̂ő���)")
        (setq CG_DEBUG 1)
        (setq CG_DEBUG 0)
      );_if
    )
  )
  ; ���ޯ��Ӱ�ނ�ǉ� 03/04/23 YM ADD-E

  (setq CG_AUTOMODE 2) ;����Ӱ��
  (setq CG_ZUMEN_FLG nil);���i�}���{�H�}����ʂ���

  ; 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (WebOutLog "//////////////////////////////////////////////////////////////////")
  (WebOutLog "����ڲ��Ă��J�n���܂�(C:Web_AutoEXEC)")
  ; 02/09/04 YM ADD ۸ޏo�͉�

  ; 02/09/03 YM ADD �װ�֐���`
  ; ���ޯ��Ӱ�ނ�ǉ� 03/04/23 YM ADD-S
  (if (= 2 CG_STOP)
    (progn
      (setvar "CMDECHO" 1)
      (setq *error* nil) ; ���ޯ�Ӱ�ނʹװ�֐����`���Ȃ�
    )
  ;else
    (progn
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError2)
      );_if
    )
  );_if

  (setq #iFILEDIA (getvar "FILEDIA"))
  (setvar "FILEDIA" 0)


  ; ���݌���
  (WebOutLog "���݌������J�n(C:SearchPlan)")
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))
  (WebOutLog "****************************")
  (WebOutLog #date_time)
  (WebOutLog "****************************")

  (C:SearchPlan)        ;���݌��� �J�n
  (WebOutLog "���݌������I�����܂���")            ; 02/09/04 YM ADD ۸ޏo�͒ǉ�



  ;2008/08/26 YM ADD �ꕔ�s�v�Ȏ{�H�}��w�̐}�`���폜����
  (ST_DelLayer)


  ;  *.dat�̒ǉ����ޏ���"Hosoku.cfg"�ɏo��
;;; (DL_HosokuOut) ;2008/08/04 YM DEL


;;;(makeERR "C:SearchPlan��") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B
  ;WorkTop.cfg�������o�� 01/10/03 YM ADD-S
  (WebOutLog "WorkTop.cfg �����o���܂�(PKOutputWT_Info)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (PKOutputWT_Info)

  ; Acaddoc�ł����s���ĂȂ�������������,�c�ƒS��,�v�����S�������m��Ȃ̂ōēx�s��
  (setq CG_KENMEIINFO$ CG_INPUTINFO$)

  ; Head.cfg�������o��
  (WebOutLog "Head.cfg �����o���܂�(SKB_WriteHeadList)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (SKB_WriteHeadList)

  ; �ۑ�
  (WebOutLog "�ۑ�,�߰�ނ��܂�"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (command "_.QSAVE")
  ; �߰��
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")


;�߰��}��}����==>"1"
;;; CG_PERS_OUT_FLG
;���i�}��}����==>1
;;; CG_SYOHIN_OUT_FLG
;�{�H�}��}����==>1
;;; CG_SEKOU_OUT_FLG


  ;��ۯ��폜
  (setq #block$ (vl-directory-files (strcat CG_KENMEI_PATH "BLOCK\\") "*.dwg"))
  (if #block$
    (foreach #block #block$
      (if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" #block))
        (vl-file-delete (strcat CG_KENMEI_PATH "BLOCK\\" #block))
      );_if
    )
  );_if

  ;\output dwg�폜 2008/08/16 YM ADD
  (setq #dwg$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT\\") "*.dwg"))
  (if #dwg$
    (foreach #dwg #dwg$
      (if (findfile (strcat CG_KENMEI_PATH "OUTPUT\\" #dwg))
        (vl-file-delete (strcat CG_KENMEI_PATH "OUTPUT\\" #dwg))
      );_if
    )
  );_if

  ;\output dxf�폜 2008/08/16 YM ADD
  (setq #dxf$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT\\") "*.dxf"))
  (if #dxf$
    (foreach #dxf #dxf$
      (if (findfile (strcat CG_KENMEI_PATH "OUTPUT\\" #dxf))
        (vl-file-delete (strcat CG_KENMEI_PATH "OUTPUT\\" #dxf))
      );_if
    )
  );_if


  ;ARX�Ή��œW�J�}�쐬�œ��삳���邩�ǂ���
;;; (if (= CG_UnitCode "K")
    (setq CG_KPDEPLOY_ARX_LOAD T)

    ;2010/01/08 YM ADD ���[�݌˂݂̂̂Ƃ��͓W�J�}�쐬�O����а�̉����z�u����
    (if (= CG_UnitCode "D");���[�̂Ƃ�
      (progn
        
        (setq #BASE_FLG nil) ;���䂪����� T
        (setq #UPPER_FLG nil);��䂪����� T

        (setq #enSS$ (ssget "X" '((-3 ("G_LSYM")))))
        (setq #i 0)
        (setq #ss (ssadd))
        (repeat (sslength #enSS$)
          (setq #skk$ (CFGetSymSKKCode (ssname #enSS$ #i) nil))
          (if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) CG_SKK_TWO_BAS))
            (setq #BASE_FLG T) ;���䂪����� T
          );_if
          (if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) CG_SKK_TWO_UPP))
            (setq #UPPER_FLG T);��䂪����� T
          );_if
          (setq #i (1+ #i))
        );repeat

        ;������䂪�����ĉ��䂪�Ȃ����
        (if (and (= nil #BASE_FLG)(= T #UPPER_FLG))
          (setq CG_KPDEPLOY_ARX_LOAD nil)
        );_if
      )
    );_if

  
    ;2011/06/08 YM ADD-S ���[�݌ˉ�OPEN BOX����̂Ƃ��V�䍂��-200mm
    (setq #dum_open_box (cadr (assoc "PLAN59" CG_INPUTINFO$)))
    (if (and (/= #dum_open_box nil)(/= #dum_open_box "N"))
      (progn
        (setq CG_CeilHeight (- CG_CeilHeight CG_WallUnderOpenBox))
        (princ "\nOPEN BOX�Ȃ̂�200ϲŽ")
      )
    );_if
    ;2011/06/08 YM ADD-E


  ; �W�J�}�쐬
  (WebOutLog "�W�J�}�쐬���s���܂�")
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))
  (WebOutLog "*** �W�J�}�쐬�J�n ***")
  (WebOutLog #date_time)
  (WebOutLog "*** �W�J�}�쐬�J�n ***")

  (C:SCFMakeMaterial)

  (WebOutLog "�W�J�}�쐬���I�����܂���")
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))
  (WebOutLog "*** �W�J�}�쐬�I�� ***")
  (WebOutLog #date_time)
  (WebOutLog "*** �W�J�}�쐬�I�� ***")


  ;2008/08/14 YM MOD �K���W�J�}�쐬����
;;; (cond
;;;   ; �߰��̂ݍ쐬
;;;   ((or (and (= "1" CG_PERS_PDF_FLG)(= "0" CG_SYOHIN_PDF_FLG)(= "0" CG_SEKOU_PDF_FLG)) ; �W�J�~,�߰���
;;;        (and (= "1" CG_PERS_DWG_FLG)(= "0" CG_SYOHIN_DWG_FLG)(= "0" CG_SEKOU_DWG_FLG)))
;;;     (KP_MakePrs)
;;;   )
;;;   ; ���i�} or �{�H�}�́APDF or dwg��}���K�v
;;;   ((or (= "1" CG_SYOHIN_PDF_FLG)(= "1" CG_SEKOU_PDF_FLG)
;;;        (= "1" CG_SYOHIN_DWG_FLG)(= "1" CG_SEKOU_DWG_FLG))
;;;     ;���i�},�{�H�}�̂ǂꂩ����}����
;;;
;;;     ; �W�J�}�쐬
;;;     (WebOutLog "�W�J�}�쐬���s���܂�")
;;;     (C:SCFMakeMaterial)
;;;     (WebOutLog "�W�J�}�쐬���I�����܂���")
;;;   )
;;; );_cond


      ;����ڰĖ������߂�
;;;     (WebGetTemplate "1");�߰�
;;;     (WebGetTemplate "2");���i�}
;;;     (WebGetTemplate "4");�{�H�}


  ; ����PDF̧�ق̍폜
  (WebOutLog "����PDF̧�ق̍폜���s���܂�")
  (DeleteFiles)


;̧�ٖ��̖���
;Z0000001_01_PERS.dwg(dxf) �p�[�X
;Z0000001_01_SYOHIN.dwg(dxf) ���i�}
;Z0000001_01_SEKOU.dwg(dxf) �{�H�}

;Z0000001_01_01.pdf �p�[�X
;Z0000001_01_02.pdf ���i�}
;Z0000001_01_03.pdf �{�H�}

;;;����No.+�ǔ�

  ;2009/01/17 YM MOD
  (setq #number$ (list "01" "02" "03" "04" "05"))
  ;�A�ԏ�����
  (setq #NN 0)

  ;���p�[�X�}�̏o�� ================================================================================
  (if (or (= "1" CG_PERS_PDF_FLG)(= "1" CG_PERS_DWG_FLG)
          (/= "" PB_TEMPLATE_TYPE));2009/02/23 YM ADD �����l�������Ă�����
;PB_TEMPLATE_TYPE
    (progn

      ;2009/01/17 YM MOD-S �߂�l=ؽ�
;;;     (setq #Template_name (WebGetTemplate "1"))
      (setq #Template_name$ (WebGetTemplate "1"))
      ;2009/01/17 YM MOD-E

      ;2009/01/19 YM MOD �A�Ԃ�Ɨ�������
      ;�A�ԏ�����
      (setq #NN_dwg 0)
      (foreach #Template_name #Template_name$ ;2009/01/17 YM

        ;���@�쐬�����޲�۸ނ̖߂�l
        (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "04") )))
        ;����ڰđI���޲�۸ނ̖߂�l
        (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))

        ; �}��ڲ��� & PDF�o��
        (WebOutLog "�}��ڲ��� & PDF�o�͂��s���܂�")
        (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
        (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_PERS_" (nth #NN_dwg #number$) ".dwg"))
        (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_PERS_" (nth #NN_dwg #number$) ".dxf"))

        (setq CG_ZUMEN_FLG nil)
        (C:SCFLayout)
        (WebOutLog "�}��ڲ��� & PDF�o�͂��I�����܂���")

        ;2009/01/19 YM MOD �A�Ԃ�Ɨ�������
        (setq #NN_dwg (1+ #NN_dwg))
        (setq #NN (1+ #NN))
      );foreach ;2009/01/17 YM
    )
  );_if

  ;�����i�}�̏o�� ================================================================================
  (if (or (= "1" CG_SYOHIN_PDF_FLG)(= "1" CG_SYOHIN_DWG_FLG))
    (progn
      ;2009/01/17 YM MOD-S �߂�l=ؽ�
;;;     (setq #Template_name (WebGetTemplate "2"))
      (setq #Template_name$ (WebGetTemplate "2"))
      ;2009/01/17 YM MOD-E

      ;2009/01/19 YM MOD �A�Ԃ�Ɨ�������
      ;�A�ԏ�����
      (setq #NN_dwg 0)
      (foreach #Template_name #Template_name$ ;2009/01/17 YM

        ;���@�쐬�����޲�۸ނ̖߂�l
        (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "02") )))
        ;����ڰđI���޲�۸ނ̖߂�l
        (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))

        ; �}��ڲ��� & PDF�o��
        (WebOutLog "�}��ڲ��� & PDF�o�͂��s���܂�")
        (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
        ;2008/09/05 YM ADD �{�H�}�����ɕʎ�(���߂���PDF�}��)��t���� �����[�̂Ƃ��͏��i�}�ɏڍא}��Y�t���遄
        (setq CG_PDF_SYOUSAI  (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_99.pdf"))
        (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SYOHIN_" (nth #NN_dwg #number$) ".dwg"))
        (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SYOHIN_" (nth #NN_dwg #number$) ".dxf"))

        (setq CG_ZUMEN_FLG "02")
        (C:SCFLayout)
        (WebOutLog "�}��ڲ��� & PDF�o�͂��I�����܂���")

        ;2009/01/19 YM MOD �A�Ԃ�Ɨ�������
        (setq #NN_dwg (1+ #NN_dwg))
        (setq #NN (1+ #NN))
      );foreach ;2009/01/17 YM
    )
  );_if

  ;���{�H�}�̏o�� ================================================================================
  (if (or (= "1" CG_SEKOU_PDF_FLG)(= "1" CG_SEKOU_DWG_FLG))
    (progn
      ;2009/01/17 YM MOD-S �߂�l=ؽ�
;;;     (setq #Template_name (WebGetTemplate "4"))
      (setq #Template_name$ (WebGetTemplate "4"))
      ;2009/01/17 YM MOD-E

      ;2009/01/19 YM MOD �A�Ԃ�Ɨ�������
      ;�A�ԏ�����
      (setq #NN_dwg 0)
      (foreach #Template_name #Template_name$ ;2009/01/17 YM

        ;���@�쐬�����޲�۸ނ̖߂�l
        (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "04") )))
        ;����ڰđI���޲�۸ނ̖߂�l
        (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))

        ; �}��ڲ��� & PDF�o�́��޽�į��
        (WebOutLog "�}��ڲ��� & PDF�o�͂��s���܂�")
        (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
        ;2008/09/05 YM ADD �{�H�}�����ɕʎ�(���߂���PDF�}��)��t����
        (setq CG_PDF_SYOUSAI  (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_99.pdf"))
        (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SEKOU_" (nth #NN_dwg #number$) ".dwg"))
        (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SEKOU_" (nth #NN_dwg #number$) ".dxf"))

        (setq CG_ZUMEN_FLG "04")
        (C:SCFLayout)
        (WebOutLog "�}��ڲ��� & PDF�o�͂��I�����܂���")

        ;2009/01/19 YM MOD �A�Ԃ�Ɨ�������
        (setq #NN_dwg (1+ #NN_dwg))
        (setq #NN (1+ #NN))
      );foreach ;2009/01/17 YM
    )
  );_if

  ; CAD�I��
  (setq CG_ZUMEN_FLG nil)
  (WebOutLog "������ CAD���I�����܂�")    ; 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))
  (WebOutLog #date_time)

;;;(makeERR "�I���O") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ �I���O

  (setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD

  ;04/04/13 YM ADD �������߸�۰��ٸر�DIPLOA�̎��ɕʼذ�ނ����s����ƑΖ����݂̒l���c��
  (setq CG_Type1Code nil);��������

  (setq *error* nil)
  (WebOutLog "@@@ quit���O @@@")
  (WebOutLog "--- C:Web_AutoEXEC �I���I ---")
  (WebOutLog "�������@������}�@�I���@������")

  (if (= CG_DEBUG 1)
    nil ;�f�o�b�N���[�h��CAD����Ȃ�
    ;else
    (command "._quit" "Y");2008/08/11 YM MOD
;;; (command "._quit" "N");2008/08/11 YM MOD
  );_if

  (princ)
);C:Web_AutoEXEC


;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AGAIN
;;; <�����T�v>  : CAD���ް������}�œW�J�}�쐬�ȍ~������������x���s����
;;; <�߂�l>    : 
;;; <�쐬>      : 
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun C:AGAIN (
  /
  #DATE_TIME #IFILEDIA #TEMPLATE_NAME #BLOCK$ #DWG$ #DXF$
  #TEMPLATE_NAME$ ;2009/0/1/17 YM ADD
  #NN #NN_DWG #NUMBER$
#BASE_FLG #ENSS$ #I #SKK$ #SS #UPPER_FLG ;2010/01/08 YM ADD
  )

  (setq CG_DEBUG 1)

  (setq CG_AUTOMODE 2) ;����Ӱ��
  (setq CG_ZUMEN_FLG nil);���i�}���{�H�}����ʂ���

  (setvar "CMDECHO" 1)
  (setq *error* nil) ; ���ޯ�Ӱ�ނʹװ�֐����`���Ȃ�
  (setq #iFILEDIA (getvar "FILEDIA"))
  (setvar "FILEDIA" 0)

;;; ; ���݌���
;;; ;��ۯ��폜
;;; (setq #block$ (vl-directory-files (strcat CG_KENMEI_PATH "BLOCK\\") "*.dwg"))
;;; (if #block$
;;;   (foreach #block #block$
;;;     (if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" #block))
;;;       (vl-file-delete (strcat CG_KENMEI_PATH "BLOCK\\" #block))
;;;     );_if
;;;   )
;;; );_if
;;;
;;; ;\output dwg�폜 2008/08/16 YM ADD
;;; (setq #dwg$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT\\") "*.dwg"))
;;; (if #dwg$
;;;   (foreach #dwg #dwg$
;;;     (if (findfile (strcat CG_KENMEI_PATH "OUTPUT\\" #dwg))
;;;       (vl-file-delete (strcat CG_KENMEI_PATH "OUTPUT\\" #dwg))
;;;     );_if
;;;   )
;;; );_if
;;;
;;; ;\output dxf�폜 2008/08/16 YM ADD
;;; (setq #dxf$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT\\") "*.dxf"))
;;; (if #dxf$
;;;   (foreach #dxf #dxf$
;;;     (if (findfile (strcat CG_KENMEI_PATH "OUTPUT\\" #dxf))
;;;       (vl-file-delete (strcat CG_KENMEI_PATH "OUTPUT\\" #dxf))
;;;     );_if
;;;   )
;;; );_if
;;;

  ;ARX�Ή��œW�J�}�쐬�œ��삳���邩�ǂ���
    (setq CG_KPDEPLOY_ARX_LOAD T)

;;;   ;2010/01/08 YM ADD ���[�݌˂݂̂̂Ƃ��͓W�J�}�쐬�O����а�̉����z�u����
;;;   (if (= CG_UnitCode "D");���[�̂Ƃ�
;;;     (progn
;;;       
;;;       (setq #BASE_FLG nil) ;���䂪����� T
;;;       (setq #UPPER_FLG nil);��䂪����� T
;;;
;;;       (setq #enSS$ (ssget "X" '((-3 ("G_LSYM")))))
;;;       (setq #i 0)
;;;       (setq #ss (ssadd))
;;;       (repeat (sslength #enSS$)
;;;         (setq #skk$ (CFGetSymSKKCode (ssname #enSS$ #i) nil))
;;;         (if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) CG_SKK_TWO_BAS))
;;;           (setq #BASE_FLG T) ;���䂪����� T
;;;         );_if
;;;         (if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) CG_SKK_TWO_UPP))
;;;           (setq #UPPER_FLG T);��䂪����� T
;;;         );_if
;;;         (setq #i (1+ #i))
;;;       );repeat
;;;
;;;       ;������䂪�����ĉ��䂪�Ȃ����
;;;       (if (and (= nil #BASE_FLG)(= T #UPPER_FLG))
;;;         (setq CG_KPDEPLOY_ARX_LOAD nil)
;;;       );_if
;;;     )
;;;   );_if

  

  ; �W�J�}�쐬
;;; (C:SCFMakeMaterial)

  ; ����PDF̧�ق̍폜
  (WebOutLog "����PDF̧�ق̍폜���s���܂�")
  (DeleteFiles)

  (setq #number$ (list "01" "02" "03" "04" "05"))
  ;�A�ԏ�����
  (setq #NN 0)

;;; ;���p�[�X�}�̏o�� ================================================================================
;;; (if (or (= "1" CG_PERS_PDF_FLG)(= "1" CG_PERS_DWG_FLG)
;;;         (/= "" PB_TEMPLATE_TYPE));2009/02/23 YM ADD �����l�������Ă�����
;;;
;;;   (progn
;;;     (setq #Template_name$ (WebGetTemplate "1"))
;;;     ;2009/01/17 YM MOD-E
;;;
;;;     ;2009/01/19 YM MOD �A�Ԃ�Ɨ�������
;;;     ;�A�ԏ�����
;;;     (setq #NN_dwg 0)
;;;     (foreach #Template_name #Template_name$ ;2009/01/17 YM
;;;
;;;       ;���@�쐬�����޲�۸ނ̖߂�l
;;;       (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "04") )))
;;;       ;����ڰđI���޲�۸ނ̖߂�l
;;;       (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))
;;;
;;;       ; �}��ڲ��� & PDF�o��
;;;       (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
;;;       (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_PERS_" (nth #NN_dwg #number$) ".dwg"))
;;;       (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_PERS_" (nth #NN_dwg #number$) ".dxf"))
;;;
;;;       (setq CG_ZUMEN_FLG nil)
;;;       (C:SCFLayout)
;;;
;;;       (setq #NN_dwg (1+ #NN_dwg))
;;;       (setq #NN (1+ #NN))
;;;     );foreach ;2009/01/17 YM
;;;   )
;;; );_if
;;;
;;; ;�����i�}�̏o�� ================================================================================
;;; (if (or (= "1" CG_SYOHIN_PDF_FLG)(= "1" CG_SYOHIN_DWG_FLG))
;;;   (progn
;;;     ;2009/01/17 YM MOD-S �߂�l=ؽ�
;;;;;;      (setq #Template_name (WebGetTemplate "2"))
;;;     (setq #Template_name$ (WebGetTemplate "2"))
;;;     ;2009/01/17 YM MOD-E
;;;
;;;     ;2009/01/19 YM MOD �A�Ԃ�Ɨ�������
;;;     ;�A�ԏ�����
;;;     (setq #NN_dwg 0)
;;;     (foreach #Template_name #Template_name$ ;2009/01/17 YM
;;;
;;;       ;���@�쐬�����޲�۸ނ̖߂�l
;;;       (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "02") )))
;;;       ;����ڰđI���޲�۸ނ̖߂�l
;;;       (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))
;;;
;;;       ; �}��ڲ��� & PDF�o��
;;;       (WebOutLog "�}��ڲ��� & PDF�o�͂��s���܂�")
;;;       (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
;;;       ;2008/09/05 YM ADD �{�H�}�����ɕʎ�(���߂���PDF�}��)��t���� �����[�̂Ƃ��͏��i�}�ɏڍא}��Y�t���遄
;;;       (setq CG_PDF_SYOUSAI  (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_99.pdf"))
;;;       (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SYOHIN_" (nth #NN_dwg #number$) ".dwg"))
;;;       (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SYOHIN_" (nth #NN_dwg #number$) ".dxf"))
;;;
;;;       (setq CG_ZUMEN_FLG "02")
;;;       (C:SCFLayout)
;;;
;;;       (setq #NN_dwg (1+ #NN_dwg))
;;;       (setq #NN (1+ #NN))
;;;     );foreach ;2009/01/17 YM
;;;   )
;;; );_if

  ;���{�H�}�̏o�� ================================================================================
  (if (or (= "1" CG_SEKOU_PDF_FLG)(= "1" CG_SEKOU_DWG_FLG))
    (progn
      (setq #Template_name$ (WebGetTemplate "4"))

      (setq #NN_dwg 0)
      (foreach #Template_name #Template_name$ ;2009/01/17 YM

        ;���@�쐬�����޲�۸ނ̖߂�l
        (setq CG_AUTOMODE_DIMMK  (list (list "1" "1" "A" "Y") (list (list #Template_name "04") )))
        ;����ڰđI���޲�۸ނ̖߂�l
        (setq CG_AUTOMODE_TEMPLT (list (list (list #Template_name "")) "0" 1))

        ; �}��ڲ��� & PDF�o�́��޽�į��
        (WebOutLog "�}��ڲ��� & PDF�o�͂��s���܂�")
        (setq CG_PDF_FILENAME (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_" (nth #NN #number$) ".pdf"))
        ;2008/09/05 YM ADD �{�H�}�����ɕʎ�(���߂���PDF�}��)��t����
        (setq CG_PDF_SYOUSAI  (strcat CG_PDFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_99.pdf"))
        (setq CG_DWG_FILENAME (strcat CG_DWGOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SEKOU_" (nth #NN_dwg #number$) ".dwg"))
        (setq CG_DXF_FILENAME (strcat CG_DXFOUTPUTPATH CG_PlanNo "_" CG_VERSION_NO "_SEKOU_" (nth #NN_dwg #number$) ".dxf"))

        (setq CG_ZUMEN_FLG "04")
        (C:SCFLayout)
        (WebOutLog "�}��ڲ��� & PDF�o�͂��I�����܂���")

        ;2009/01/19 YM MOD �A�Ԃ�Ɨ�������
        (setq #NN_dwg (1+ #NN_dwg))
        (setq #NN (1+ #NN))
      );foreach ;2009/01/17 YM
    )
  );_if

  ; CAD�I��
  (setq CG_ZUMEN_FLG nil)

  (setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD

  (setq CG_Type1Code nil);��������

  (setq *error* nil)

  (if (= CG_DEBUG 1)
    nil ;�f�o�b�N���[�h��CAD����Ȃ�
    ;else
    (command "._quit" "Y");2008/08/11 YM MOD
  );_if

  (princ)
);C:AGAIN

;;;<HOM>*************************************************************************
;;; <�֐���>    : ST_DelLayer
;;; <�����T�v>  : �ꕔ�s�v�Ȏ{�H�}��w�̐}�`���폜����
;;; <�߂�l>    : �Ȃ�
;;; <����>      : ��w��ؽ�(ܲ��޶���OK)
;;; <�쐬>      : 2008/08/26 YM ADD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun ST_DelLayer (
  /
  #EN #I #LAYER #LAYER$ #NUM #REC$$ #SS #VALUE #RET$
  )
  (setq #layer$ nil)
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "ST�{�H�\��")))
  (foreach #rec$ #rec$$
    (setq #layer     (nth 0 #rec$))
    (setq #num (atoi (nth 1 #rec$)))
    (setq #value     (nth 2 #rec$))
    (if (wcmatch (nth #num CG_GLOBAL$) #value) ;�ϊ��l�������ƈ�v����ƁA��w���폜�ΏۂɂȂ�
      (progn
        ;","��؂�l��
        (setq #ret$ (StrParse #layer ","));��w��ؽ�
        (setq #layer$ (append #layer$ #ret$))
      )
    );_if
  )

  ;����̉�w�̐}�`���폜
  (foreach #layer #layer$
    (setq #ss (ssget "X" (list (cons 8 #layer))))
    (if (and #ss (/= 0 (sslength #ss)))
      (progn
        (setq #i 0)
        (repeat (sslength #ss)
          (setq #en (ssname #ss #i))
          (if (entget #en)
            (entdel #en)
          );_if
          (setq #i (1+ #i))
        );repeat
      )
    );_if
  );foreach
  
  (princ)
);ST_DelLayer


;;;<HOM>*************************************************************************
;;; <�֐���>    : DeleteFiles
;;; <�����T�v>  : ������PDF,DWG,DXF̧�ق��폜����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2008/08/07 YM ADD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun DXF_OUT (  /  )
  ;dxf�o��
  (command "_saveas" "dxf" "V" "R12" "16" CG_DXF_FILENAME)
  (princ)
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : DeleteFiles
;;; <�����T�v>  : ������PDF,DWG,DXF̧�ق��폜����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2008/08/07 YM ADD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun DeleteFiles (
  /
  #DWG$ #DXF$ #PDF$
  )
  (setq #PDF$ (vl-directory-files CG_PDFOUTPUTPATH "*.pdf"))
  (if #PDF$
    (foreach #PDF #PDF$
      (if (findfile (strcat CG_PDFOUTPUTPATH #PDF))
        (vl-file-delete (strcat CG_PDFOUTPUTPATH #PDF))
      );_if
    )
  );_if
      
  (setq #DWG$ (vl-directory-files CG_DWGOUTPUTPATH "*.dwg"))
  (if #DWG$
    (foreach #DWG #DWG$
      (if (findfile (strcat CG_DWGOUTPUTPATH #DWG))
        (vl-file-delete (strcat CG_DWGOUTPUTPATH #DWG))
      );_if
    )
  );_if

  (setq #DXF$ (vl-directory-files CG_DXFOUTPUTPATH "*.dxf"))
  (if #DXF$
    (foreach #DXF #DXF$
      (if (findfile (strcat CG_DXFOUTPUTPATH #DXF))
        (vl-file-delete (strcat CG_DXFOUTPUTPATH #DXF))
      );_if
    )
  );_if

  (setq #DWG$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT\\") "*.dwg"))
  (if #DWG$
    (foreach #DWG #DWG$
      (if (findfile (strcat CG_KENMEI_PATH "OUTPUT\\" #DWG))
        (vl-file-delete (strcat CG_KENMEI_PATH "OUTPUT\\" #DWG))
      );_if
    )
  );_if



  (princ)
);DeleteFiles

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KP_AutoEXEC
;;; <�����T�v>  : �v������������}�ʏo�͂܂ōs��(�����ݸ޼��)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/09/07 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KP_AutoEXEC (
  /
  #XRec$ #fp #msg
  #iFILEDIA #TAIMEN
  )
  (setq CG_AUTOMODE 1)  ;����Ӱ��
;;; (setq CG_ZumenPRINT 1)
;;; (setq CG_MitumoriPRINT 1)

  ; ���ޯ��Ӱ�ނ�ǉ� 03/04/28 YM ADD-S
  (cond
    ((= 1 CG_STOP)
      (princ "\n�������@�����I��(�����ݸ޼��)�@������")
      (setq CG_STOP 2)
      (CFAlertMsg "\n--- ���ޯ�Ӱ�� (C:KP_AutoEXEC) �ōĊJ---")
      (princ "\n--- ���ޯ�Ӱ�� (C:KP_AutoEXEC) �ōĊJ---")
      (quit) ;�����I��
    )
    ((= 2 CG_STOP) ; �Ď��s��
      (setq CG_DEBUG 1)
    )
  )
  ; ���ޯ��Ӱ�ނ�ǉ� 03/04/28 YM ADD-E


  ; ���ޯ��Ӱ�ނ�ǉ� 03/04/28 YM ADD-S
  (if (= 2 CG_STOP)
    (progn
      (setvar "CMDECHO" 1)
      (setq *error* nil) ; ���ޯ�Ӱ�ނʹװ�֐����`���Ȃ�
    )
  ;else
    (progn
      ; 02/09/03 YM ADD �װ�֐���`
      (setq *error* SKAutoError1)
    )
  );_if

  (setq #iFILEDIA (getvar "FILEDIA")) ; 01/11/22 HN ADD
  (setvar "FILEDIA" 0)

  ; ���݌���
  (C:SearchPlan)        ;���݌��� �J�n

  ; 01/10/04 YM ADD-S Kenmei.cfg ��ǂݍ���Ÿ�۰��پ��
  ; Acaddoc�ł����s���ĂȂ�������������,�c�ƒS��,�v�����S�������m��Ȃ̂ōēx�s��
  (setq CG_KENMEIINFO$ (ReadIniFile (strcat CG_SYSPATH "KENMEI.CFG")))
  ; 01/10/04 YM ADD-S

  ; 01/10/18 YM ADD Head.cfg�������o��
  (SKB_WriteHeadList)

  ; �ۑ�
  (command "_.QSAVE")
  ; �߰��
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")

  (if (CFYesNoDialog "���i�̓��֥�ǉ����s���܂����H")
    (progn
      (setq CG_AUTOMODE 0) ;����Ӱ�ޏI��
      ; 01/10/18 YM ADD-S PlanIno.cfg �X�V(�ʏ�Ӱ��)
      (NS_ChPlanInfo)
      ; 01/10/18 YM ADD-E PlanIno.cfg �X�V(�ʏ�Ӱ��)
      (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 1") 0) ; �ذ���ݐ݌v�޲�۸ޕ\��
    )
    (progn ; �����p��
;;;     (C:ChgMenuPlot)       ; �o���ƭ�

      ; �W�J�}�쐬
      (C:SCFMakeMaterial)

      ; //////////////////// �������v���[���p������////////////////////
      (setq CG_AUTOMODE 5) ; JPG�o��Ӱ��
      ; JPG�p�߰��}��ڲ��Ă���(��p����ڰĂ���) 03/02/22 YM MOD-S
      (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_JPG)
      (C:SCFLayout) ; JPG�o�͗p�߰��}�ʍ쐬  �쐬�シ��JPG�o��(WebTIFF_OUTPUT)
      ; JPG�p�߰��}��ڲ��Ă���(��p����ڰĂ���)
      ; //////////////////// �������v���[���p������////////////////////
      (setq CG_AUTOMODE 1);���ɖ߂�



      ;04/10/05 YM MOD �Ζ����݂��������ߋL���擾�Ɣ���ɼذ�ދL����ǉ�

      (setq #TAIMEN (CFgetini (strcat "TAIMEN-" CG_SeriesCode) "0001" (strcat CG_SKPATH "ERRMSG.INI")))
      ;2011/05/21 YM MOD
;;;     (if (or (= "IPA" (nth  5 CG_GLOBAL$))(= "G*" (nth  5 CG_GLOBAL$))) ;�Ζ����݂��ǂ���
      (if (or (wcmatch (nth  5 CG_GLOBAL$) "IP*" )(wcmatch (nth  5 CG_GLOBAL$) "G*" )) ;�Ζ����݂��ǂ���
        (progn ;�Ζ�����
          (if (= (nth 11 CG_GLOBAL$) "R")

;;;(("1" "1" "A" "Y") (("SK_A3_�Ζʗ�2" "04") ("SK_A3_�Ζ�AE�d" "04") ("SK_A3_�Ζ�B��D" "04")))

            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_R_TAIMEN)
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_L_TAIMEN)
          );_if
        )
        (progn
          ;�]��(�ΖʈȊO)
          (if (= (nth 11 CG_GLOBAL$) "R")

;;;(("1" "1" "A" "Y") (("SK_A3_��" "04") ("SK_A3_R�W" "04")))

            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_R)
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_L)
          );_if
        )
      );_if

      (setq CG_Zumen_Count 0);���������

      (C:SCFLayout)         ; �}��ڲ���

      (PKOutputWT_Info)

      ; ���ς�
      (C:arxStartApp (strcat CG_SysPATH "MITUMORI.EXE /Child") 1)
      (command "._quit" "N")
    )
  );_if

  (setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD
  (setq CG_AUTOMODE 0) ;����Ӱ��
  (setq CG_ZumenPRINT 0)
  (setq CG_MitumoriPRINT 0)

  (setq CG_Zumen_Count nil);���������
  (setq CG_Type1Code nil);��������

  (setq *error* nil)
  (princ)
);C:KP_AutoEXEC

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KPLocalAutoEXEC
;;; <�����T�v>  : WEB��LOCAL CAD�[���p�������s
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 02/08/05 YM
;;; <���l>      : Input.cfg��ǂ�������ݸ޼�Ď��s
;;;*************************************************************************>MOH<
(defun C:KPLocalAutoEXEC (
  /
  #XRec$ #fp #msg
  #iFILEDIA #TAIMEN
  )
  (setq CG_AUTOMODE 3)  ;����Ӱ��

  ; ���ޯ��Ӱ�ނ�ǉ� 03/04/28 YM ADD-S
  (cond
    ((= 1 CG_STOP)
      (princ "\n�������@�����I��(DL�Q��)�@������")
      (setq CG_STOP 2)
      (CFAlertMsg "\n--- ���ޯ�Ӱ�� (C:KPLocalAutoEXEC) �ōĊJ---")
      (princ "\n--- ���ޯ�Ӱ�� (C:KPLocalAutoEXEC) �ōĊJ---")
      (quit) ;�����I��
    )
    ((= 2 CG_STOP) ; �Ď��s��
      (setq CG_DEBUG 1)
    )
  )
  ; ���ޯ��Ӱ�ނ�ǉ� 03/04/28 YM ADD-E


  ; ���ޯ��Ӱ�ނ�ǉ� 03/04/28 YM ADD-S
  (if (= 2 CG_STOP)
    (progn
      (setvar "CMDECHO" 1)
      (setq *error* nil) ; ���ޯ�Ӱ�ނʹװ�֐����`���Ȃ�
    )
  ;else
    (progn
      ; 02/09/03 YM ADD �װ�֐���`
      (setq *error* SKAutoError1)
    )
  );_if

  (setq #iFILEDIA (getvar "FILEDIA")) ; 01/11/22 HN ADD
  (setvar "FILEDIA" 0)

  ; ���݌���
  (C:SearchPlan)        ;���݌��� �J�n

  ; 03/04/28 YM ADD-S *.dat�̒ǉ����ޏ���"Hosoku.cfg"�ɏo��
  (DL_HosokuOut)
  ; 03/04/28 YM ADD-E

  ; 01/10/04 YM ADD-S Kenmei.cfg ��ǂݍ���Ÿ�۰��پ��
  ; Acaddoc�ł����s���ĂȂ�������������,�c�ƒS��,�v�����S�������m��Ȃ̂ōēx�s��
  (setq CG_KENMEIINFO$ (ReadIniFile (strcat CG_SYSPATH "KENMEI.CFG")))
  ; 01/10/04 YM ADD-S

  ; 01/10/18 YM ADD Head.cfg�������o��
  (SKB_WriteHeadList)

  ; �ۑ�
  (command "_.QSAVE")
  ; �߰��
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")

  (if (CFYesNoDialog "���i�̓��֥�ǉ����s���܂����H")
    (progn
      (setq CG_AUTOMODE 0) ;����Ӱ�ޏI��
      ; 01/10/18 YM ADD-S PlanIno.cfg �X�V(�ʏ�Ӱ��)
      (NS_ChPlanInfo)
      ; 01/10/18 YM ADD-E PlanIno.cfg �X�V(�ʏ�Ӱ��)
      (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 1") 0) ; �ذ���ݐ݌v�޲�۸ޕ\��
    )
    (progn ; �����p��
;;;     (C:ChgMenuPlot)       ; �o���ƭ�

      ; �W�J�}�쐬
      (C:SCFMakeMaterial)

;;;04/04/13YM@DEL     ; �}��ڲ���
;;;04/04/13YM@DEL     (if (= (nth 11 CG_GLOBAL$) "R")
;;;04/04/13YM@DEL       (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_R)
;;;04/04/13YM@DEL       (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_L)
;;;04/04/13YM@DEL     );_if

      ;04/04/13 YM ADD �Ζ����݂��������ߋL���擾�Ɣ���
      ;04/10/05 YM MOD �Ζ����݂��������ߋL���擾�Ɣ���ɼذ�ދL����ǉ�
      (setq #TAIMEN (CFgetini (strcat "TAIMEN-" CG_SeriesCode) "0001" (strcat CG_SKPATH "ERRMSG.INI")))
      (if (or (wcmatch CG_Type1Code #TAIMEN));�Ζ����݂��ǂ���
        (progn;04/04/13 YM ADD �Ζ����݂��������ߋL���擾�Ɣ���
          (if (= (nth 11 CG_GLOBAL$) "R")
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_R_TAIMEN)
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_L_TAIMEN)
          );_if
        )
        (progn
          ;�]��(�ΖʈȊO)
          (if (= (nth 11 CG_GLOBAL$) "R")
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_R)
            (setq CG_AUTOMODE_DIMMK CG_AUTOMODE_DIMMK_L)
          );_if
        )
      );_if


      ;04/04/14 YM ADD
      (setq CG_Zumen_Count 0);���������

      (C:SCFLayout)         ; �}��ڲ���


      ;WorkTop.cfg�������o�� 01/10/03 YM ADD-S
      (PKOutputWT_Info)
      ;WorkTop.cfg�������o�� 01/10/03 YM ADD-E

      ; ���ς�
      (C:arxStartApp (strcat CG_SysPATH "MITUMORI.EXE /Child") 1)
      (command "._quit" "N")
    )
  );_if
  ; 01/09/21 YM ADD-E

  (setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD
  (setq CG_AUTOMODE 0) ;����Ӱ��
  (setq CG_ZumenPRINT 0)
  (setq CG_MitumoriPRINT 0)

  ;04/04/13 YM ADD �������߸�۰��ٸر�DIPLOA�̎��ɕʼذ�ނ����s����ƑΖ����݂̒l���c��
  (setq CG_Type1Code nil);��������

  (setq *error* nil)
  (princ)
);C:KPLocalAutoEXEC

;;;<HOM>*************************************************************************
;;; <�֐���>    : DL_HosokuOut
;;; <�����T�v>  : *.dat�̒ǉ����ޏ���"Hosoku.cfg"�ɏo��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/04/28 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun DL_HosokuOut (
  /
  #FLG #FP #HINBAN #INFO #SFNAME #WRITE$$
  )
  ;"HOSOKU.cfg"�ɏo�͂���
  (setq #sFname (strcat CG_KENMEI_PATH "HOSOKU.cfg"))
  ;03/05/27 YM ADD �����̏ꍇ�폜����
  (if (findfile #sFname)(vl-file-delete #sFname))

  ;[HOSOKU.cfg]�ȍ~�̍s���擾���� CG_INPUTINFO$
  ;(("KENMEICD" "X0S03040022")("BUKKENNAME" "�P�P �䒆")...
  ; ("[HOSOKU.cfg]") ("DP0405" "1,����ݗp̨װ")...)
  (setq #write$$ nil #flg nil) ; HOSOKU���,����׸�
  (foreach #elm$ CG_INPUTINFO$
    (if #flg ; HOSOKU���
      (setq #write$$ (append #write$$ (list #elm$)))
    );_if
    (if (= "[HOSOKU.CFG]" (strcase (car #elm$))) ; �啶���ɂ��Ă����r
      (setq #flg T)
    );_if
  )

  (setq #fp  (open #sFname "a")) ; �ǉ��L��Ӱ��
  (if (/= nil #fp)
    (progn
      (foreach #elm$ #write$$ ; �ǉ����ޏ��
        (setq #hinban (car  #elm$))
        (setq #info   (cadr #elm$))
        (if (and #hinban #info (/= "" #hinban))
          (princ (strcat #hinban "=" #info) #fp)
        );_if
        (princ "\n" #fp)
      )
      (close #fp)
    )
    (progn
      ;03/05/27 YM DEL
;;;     (CFAlertMsg "HOSOKU.cfg�ւ̏������݂Ɏ��s���܂����B")
      (*error*)
    )
  );_if
  (princ)
);DL_HosokuOut


;;;<HOM>*************************************************************************
;;; <�֐���>    : WEBclear
;;; <�����T�v>  : �}�ʸر�(�����}�ʏ�Ԃɖ߂�)
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 02/07/29 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun WEBclear (
  /
  #I #SSALL #SSROOM
  )
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
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  ; ��w�߰��
  (command "_purge" "LA" "*" "N") ; �g���Ă��Ȃ���w���폜����.
  (command "_purge" "LA" "*" "N") ; �g���Ă��Ȃ���w���폜����.
  (command "_purge" "LA" "*" "N") ; �g���Ă��Ȃ���w���폜����.

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
  (command "pdmode" "0")
  (command "_.QSAVE") ; �㏑���ۑ�
  (princ)
);WEBclear

;;;<HOM>***********************************************************************
;;; <�֐���>    : NS_ChPlanInfo
;;; <�����T�v>  : PlanInfo.cfg���X�V����(�ʏ�Ӱ��)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/10/18 YM
;;; <���l>      :
;;;***********************************************************************>MOH<
(defun NS_ChPlanInfo (
  /
  #FP #PLANINFO$ #SERI$ #SFNAME
  )
  ; PlanInfo.cfg���X�V
  ;// ���݂̃v�������(PLANINFO.CFG)��ǂݍ���
  (setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
  ; ���ڂ̍X�V
  (if (assoc "AUTOMODE"      #PLANINFO$)
    (setq #PLANINFO$ (subst (list "AUTOMODE"      "0")(assoc "AUTOMODE"      #PLANINFO$) #PLANINFO$))
  );_if
  (if (assoc "ZumenPRINT"    #PLANINFO$)
    (setq #PLANINFO$ (subst (list "ZumenPRINT"    "0")(assoc "ZumenPRINT"    #PLANINFO$) #PLANINFO$))
  );_if
  (if (assoc "MitumoriPRINT" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "MitumoriPRINT" "0")(assoc "MitumoriPRINT" #PLANINFO$) #PLANINFO$))
  );_if

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
      (quit)
    )
  );_if
  #seri$
);NS_ChPlanInfo

;;;<HOF>************************************************************************
;;; <�t�@�C����>: Pcsrcpln.LSP
;;; <�V�X�e����>: KPCAD�V�X�e��
;;; <�ŏI�X�V��>: 00/07/27 YM �V�d�l���݌������ݕ�
;;; <���l>      :
;;;************************************************************************>FOH<

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:SearchPlan
;;; <�����T�v>  : �L�b�`���v��������
;;; <�߂�l>    :
;;; <�쐬>      : 2000.1�C��KPCAD
;;; <���l>      :
;;;               �v���������̏����̗���
;;;                1.������ʂɂ�����(C:SearchPlan)�i���{�������j
;;;                2.�V�K�}�ʂ��J��(PC_SearchPlanNewDwg)
;;;                3.ACAD.LSP����C:PC_LayoutPlan���R�[��
;;;                4.�v�������������s��PLAN.DWG�Ƃ��ĕۑ�(C:PC_LayoutPlan)
;;;                5.���݂̕����ɖ߂�
;;;                6.ACAD.LSP����PLAN.DWG��}�����鏈�������s(C:PC_InsertPlan)
;;;*************************************************************************>MOH<
(defun C:SearchPlan (
  /
  #XRec$ #fp #msg
  )
  (CPrint_Time) ; ���t���������O�ɏ������� 00/02/17 YM ADD
  (setq CG_Srcpln T) ; �v�����������s����'T�ɂȂ� 00/08/02

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
  (defun TempErr (msg / #msg)
    (setq CG_Srcpln nil)
    (setq CG_OpenMode nil)
    (setq CG_TESTMODE nil)      ;ý�Ӱ��
    (setq CG_AUTOMODE 0)        ;����Ӱ�� 01/09/07 YM ADD ����܂�
    (setq *error* nil)
    ;;; ��۰��ٕϐ��̸ر� 00/09/08 YM
    (PK_ClearGlobal)
    (princ)
  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

  (if (or (= CG_AUTOMODE 0)(= CG_AUTOMODE nil)) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (setq *error* TempErr)
  );_if


  (if (= CG_AUTOMODE 0) ; ����Ӱ�ނł͎��s���Ȃ�
    (C:arxStartApp (strcat CG_SysPATH "KillPlan.exe") 0)
  );_if

  (setq #XRec$ (CFGetXRecord "SERI"))

  (if (= #XRec$ nil)
    (progn
      ; 02/09/02 YM WEB�Ŏ���Ӱ�ނ͋����I��
      (if (= CG_AUTOMODE 2)
        (*error*) ; 02/09/02 YM
      );_if

      (setq #msg "�}�ʏ��Ɍ�肪����܂�(XRecord���Ȃ�)")
      (CFAlertErr #msg)
      (setq *error* CmnErr) ; �������Ȃ��G���[
      (if (or (= CG_TESTMODE 1)(= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; ����Ӱ��,Web��,LOCAL�[��
        (setq *error* nil)
      )
      (quit) ; @YM@ �ǉ� 00/01/31 �װ: quit / exit �ɂ�钆�~
    )
  );_if

    (WebOutLog "���݂̏��i���������o���܂�(SERIES.CFG)")
    (PC_WriteSeriesInfo #XRec$);// ���݂̏��i�����t�@�C���ɏ����o�� ---> SERIES.CFG


    ;// �v���������_�C�A���O�̕\�� �e�L�X�g�t�@�C���ɂ����o��--->"srcpln.cfg"
    (WebOutLog "CAD���ް�����݌�����ʂ�\�����Ȃ�")

    (cond
      ((or (= 2 CG_AUTOMODE)(= 3 CG_AUTOMODE)) ; Web��CAD���ްӰ��,LOCAL CAD�[��Ӱ�ނ̂Ƃ� 02/08/05 YM
        ;���݌�����ʂ�\�����Ȃ�
        nil
      )
      ((= 1 CG_AUTOMODE); ����Ӱ�ނ̂Ƃ�
        (CFYesDialog "������}���J�n���܂�")
        (C:arxStartApp (strcat CG_SysPATH "SKPlan.exe /Auto") 1)
      )
      (T
        ; �ʏ�
        (if (= CG_TESTMODE 1)
          (progn ; ý�Ӱ��
            (princ)  ; ���݌�����ʂ��o���Ȃ�
          )
          (progn ; �ʏ�Ӱ�� & ����Ӱ��
            (C:arxStartApp (strcat CG_SysPATH "SKPLAN.EXE 0") 1)
          )
        );_if
      )
    );_cond


    (CPrint_Time) ; ���t���������O�ɏ������� 00/02/17 YM ADD


    (if (or (= CG_TESTMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3))
      (progn ; ý�Ӱ�� or Web��CAD���ްӰ��
        (WebOutLog "--- (PC_SearchPlanNewDWG) ---")
        (PC_SearchPlanNewDWG)
      )
      (progn ; �ʏ�Ӱ��
        (if (ReadIniFile (strcat CG_SYSPATH "SRCPLN.CFG"))
          (PC_SearchPlanNewDWG)
        ; else
          (*error*)
        );_if
      )
    );_if

  (command "_REGEN")

  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (setq *error* nil)
  );_if
  
  (setq CG_Srcpln nil) ; �v�����������s����'T�ɂȂ� 00/08/02
  (if (= CG_EyeLevelColCode nil)
    (setq CG_EyeLevelColCode "")
  );_if
  (PcSetKikiColor CG_EyeLevelColCode) ; 08/21 YM ADD
  ;;; ��۰��ٕϐ��̸ر� 00/09/07 YM
  (WebOutLog "��۰��ٕϐ���ر����܂�(PK_ClearGlobal)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (PK_ClearGlobal)

  ;2010/01/07 YM ADD KPCAD�����݌����̂Ƃ��͕ϐ���ر @@@@@@@@@@@@@@@@@
  (if (= CG_AUTOMODE 0)
    (setq CG_GLOBAL$ nil)
  );_if
  
;;;(makeERR "B") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B
  (princ "\n--- �I�� ---")
  (princ)

);C:SearchPlan

;;;<HOM>*************************************************************************
;;; <�֐���>  : PK_ClearGlobal
;;; <�����T�v>: ��۰��ٕϐ��̸ر�
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : 00/09/07 YM
;;;*************************************************************************>MOH<
(defun PK_ClearGlobal ( / )

  ;03/12/23 YM ADD-S
  (setq CG_PREV_SYMSS nil)
  (setq CG_PREV_WTSS nil)
  (setq CG_AFTER_WTSS nil)
  (setq CG_AFTER_SYMSS nil)
  ;03/12/23 YM ADD-E

  (setq CG_SinkCode         nil) ;�ݸ�L��
  (setq CG_CRCode           nil) ;���
  (setq CG_NPCode           nil) ;�H��@���
  (setq CG_RangeCode        nil) ;�ݼ�
  (setq CG_WtrHoleTypeCode  nil) ;������
  (setq CG_WtrHoleCode      nil) ;����

  (setq CG_BASEPT1 nil)
  (setq CG_BASEPT2 nil)
  (setq CG_MAG1 nil)
  (setq CG_MAG2 nil)
  (setq CG_MAG3 nil)
  ; 01/12/17 YM ADD-S
  (setq CG_OPTID nil)
  (setq CG_RECNO$ nil)
  ; 01/12/17 YM ADD-E

  ;03/05/12 YM ADD
  (setq CG_FAMILYCODE nil)

  ;03/11/24 YM ADD
  (setq CG_Counter nil)     ;������F

  ;04/04/28 YM ADD ���݌����̂Ƃ������ر�����
  (if (= CG_AUTOMODE 0)
    (setq CG_Type1Code nil);��������
  );_if

  ;2011/03/25 YM ADD-S
  (setq CG_DIST_YY nil)
  (setq CG_NO_BOX_FLG nil)
  (setq CG_SYOKUSEN_CAB nil)
  ;2011/03/25 YM ADD-E

  (setq CG_DRSeriCode_D nil)
  (setq CG_DRColCode_D  nil)
  (setq CG_Hikite_D     nil)
  (setq CG_DRSeriCode_M nil)
  (setq CG_DRColCode_M  nil)
  (setq CG_Hikite_M     nil)
  (setq CG_DRSeriCode_U nil)
  (setq CG_DRColCode_U  nil)
  (setq  CG_Hikite_U    nil)

;;;  (setq CG_WT_T nil) ; WT�̌���
;;;  (setq CG_BG_H nil) ; BG�̍���
;;;  (setq CG_BG_T nil) ; BG�̌���
;;;  (setq CG_FG_H nil) ; FG�̍���
;;;  (setq CG_FG_T nil) ; FG�̌���
;;;  (setq CG_FG_S nil) ; �O����V�t�g��
;;;(makeERR "PK_ClearGlobal") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (princ)
);PK_ClearGlobal

;;;<HOM>*************************************************************************
;;; <�֐���>  : PC_WriteSeriesInfo
;;; <�����T�v>: ���݂�SERIES�����t�@�C���ɏ����o��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : SERIES.CFG�ɏ����o��
;;;*************************************************************************>MOH<
(defun PC_WriteSeriesInfo (
  &XRec$
  /
  #fp #XRec$
  )

  (setq #XRec$ &XRec$)
  (setq  #fp (open (strcat CG_SYSPATH "SERIES.CFG") "w"))
  (princ ";-----------------------------------------" #fp)
  (princ "\n; �v���������_�C�A���O�Ɉ����n�������" #fp)
  (princ "\n;"                                        #fp)
  (princ "\n;    00.�c�a�L��"                         #fp)
  (princ "\n;    01.SERIES�L��"                       #fp)
  (princ "\n;    02.�u�����h�L���~"                   #fp)
  (princ "\n;    03.�H��L��    �~"                   #fp)

  (princ "\n;    12.��SERIES�L��"                     #fp)
  (princ "\n;    13.��COLOR�L��"                      #fp)
  (princ "\n;    14.�q�L�e�L��"                       #fp)

  (princ "\n;    15.���b�N�t���O�~"                   #fp)
  (princ "\n;    31.��t�^�C�v  �~"                   #fp)
  (princ "\n;---------------------------------------" #fp)
  (princ (strcat "\n00=" (substr (nth 0 #XRec$) 4 9)) #fp) ;�c�a�L��
  (princ (strcat "\n01="         (nth 1 #XRec$)     ) #fp) ;SERIES�L��
  (princ         "\n02=N"                             #fp) ;�u�����h�L��
  (princ         "\n03=K"                             #fp) ;�H��L��
  (princ (strcat "\n12="         (nth 3 #XRec$)     ) #fp) ;12.��SERIES�L��
  (princ (strcat "\n13="         (nth 4 #XRec$)     ) #fp) ;13.��COLOR�L��
  (princ (strcat "\n14="         (nth 5 #XRec$)     ) #fp) ;14.�q�L�e�L��
  (princ         "\n15=S"                             #fp) ;���b�N�t���O
  (princ         "\n31=850"                           #fp) ;��t�^�C�v
  (princ         "\n"                                 #fp)
  (close #fp)

  (princ)
) ; PC_WriteSeriesInfo

;;;<HOM>*************************************************************************
;;; <�֐���>    : PC_SearchPlanNewDWG
;;; <�����T�v>  : �v���������p�̐V�K�}�ʂ��J��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.1.19�C��KPCAD
;;; <���l>      :
;;;               �v���������̏����̗���
;;;                1.������ʂɂ�����(C:SearchPlan)
;;;                2.�V�K�}�ʂ��J��(PC_SearchPlanNewDwg)�i���{�������j
;;;                3.ACAD.LSP����C:PC_LayoutPlan���R�[��
;;;                4.�v�������������s��PLAN.DWG�Ƃ��ĕۑ�(C:PC_LayoutPlan)
;;;                5.���݂̕����ɖ߂�
;;;                6.ACAD.LSP����PLAN.DWG��}�����鏈�������s(C:PC_InsertPlan)
;;;
;;;*************************************************************************>MOH<
(defun PC_SearchPlanNewDWG ( / )

  ;// �����ۑ�
  (CFAutoSave)
;;;(makeERR "5") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5
  (setq CG_OPENMODE 1) ;�L�b�`�� �� (C:PC_LayoutPlan)

  (WebOutLog (strcat "CG_OPENMODE= " (itoa CG_OPENMODE)))

  (if (/= (getvar "DBMOD") 0)
    (progn
      (command "_qsave")
      (vl-cmdf "._new" ".")
    )
    (progn
      (vl-cmdf "._new" ".")
    )
  );_if

  ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
  (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

(WebOutLog (strcat "�V�K�}�ʃI�[�v����AAcaddoc.lsp ����v��������(PC_LayoutPlan)���s��"))

  (S::STARTUP)
  ;// �V�K�}�ʃI�[�v����AAcad.lsp ����v��������(PC_LayoutPlan��)���s��
);PC_SearchPlanNewDWG

;;;<HOM>*************************************************************************
;;; <�֐���>    : PC_LayoutPlan
;;; <�����T�v>  : �v�����������������s
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      :
;;; <���l>      :
;;;               �{�����͐V�K�}�ʂōs���Aplan.dwg�Ƃ��ĕۑ������
;;;               ��������������ƕ�����model.dwg�ɖ߂��Ă���
;;;               �v���������̏����̗���
;;;                1.������ʂɂ�����(C:SearchPlan)
;;;                2.�V�K�}�ʂ��J��(PC_SearchPlanNewDwg)
;;;                3.ACAD.LSP����C:PC_LayoutPlan���R�[���i���{�������j
;;;                4.�v�������������s��PLAN.DWG�Ƃ��ĕۑ�(C:PC_LayoutPlan)
;;;                5.���݂̕����ɖ߂�
;;;                6.ACAD.LSP����PLAN.DWG��}�����鏈�������s(C:PC_InsertPlan)
;;;*************************************************************************>MOH<
(defun C:PC_LayoutPlan (
  /
  #pt #Obj$ #res$
  )

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
  (defun TempErr ( msg / #msg )
    (if (= CG_DEBUG 1) ; �f�o�b�O���[�h
      (progn
        (setq #msg (strcat "�G���[���F\n C:PC_LayoutPlan �ȍ~ \n" msg))
      )
      (progn
        (setq #msg "�v���������Ɏ��s���܂���.\n")
        (setq #msg (strcat #msg "�ҏW���̕����ɖ߂�܂��B"))
        (CfDwgOpenByScript (strcat CG_KENMEI_PATH "model.dwg"))
      )
    );_if
    (CFAlertMsg #msg)
    (setq CG_OpenMode nil)      ; �����Ӱ��=nil
    (setq CG_TESTMODE nil)      ;ý�Ӱ��
    (setq CG_AUTOMODE 0)        ;����Ӱ�� 01/09/07 YM ADD ����܂�
    (setq *error* nil)
    ;;; ��۰��ٕϐ��̸ر�
    (PK_ClearGlobal)
    (princ)
  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

  (WebOutLog "�װ�֐� SKAutoError2 ���`���܂�(C:PC_LayoutPlan)")
  (WebDefErrFunc) ; �װ�֐���`(02/09/11 YM �֐���)

  (setvar "OSMODE" 0)
  (if (or (= "23" CG_ACADVER)(= "19" CG_ACADVER)(= "18" CG_ACADVER));2020/01/29 YM ADD
		(progn
	    (setvar "3DOSMODE"  1) ;2011/06/30 YM ADD
			(setvar "UCSDETECT" 0) ;�_�C�i�~�b�N UCS ���A�N�e�B�u�ɂ��Ȃ� 2011/10/11 YM ADD
		)
  );_if
  (WebOutLog "���݌����������������s���܂�(PC_LayoutPlanExec)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  ;// ���݌�����������
  (PC_LayoutPlanExec)

  ;// ڲ��Ă���������ΐ}�ʂ�ۑ����A�����ɖ߂� SKA,SDA�̂Ƃ�����
;;; (if (or (wcmatch CG_SeriesDB "SK*")(= CG_SeriesDB "SDA"))
;;;   (progn
      (command "_saveas" "" (strcat CG_SYSPATH "plan.dwg"))
;;;   )
;;;   ;else
;;;   (progn ;���[�g��
;;;     ;plan1�`5.dwg��ۑ��ς�
;;;     nil
;;;   )
;;; );_if

  (setq CG_OPENMODE 2)
  (command "_.open" (strcat CG_KENMEI_PATH "model.dwg"))
;;; (command "._style" "standard" "�l�r ����" "" "" "" "" "") ; �ݸ���ނ�"????"���Ȃ���07/07 YM
  ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
  (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

(WebOutLog (strcat "�����}�ʃI�[�v����AAcaddoc.lsp ���羯�����dwg��Insert(PC_InsertPlan)"))

  (S::STARTUP) ; 00/03/03 YM ADD
  ;// �����}�ʃI�[�v����AAcad.lsp ���烌�C�A�E�g�}�ʂ�Insert (PC_InsertPlan)
);C:PC_LayoutPlan

;;;<HOM>*************************************************************************
;;; <�֐���>    : PC_InsertPlan
;;; <�����T�v>  : �v�����������ꂽ�}�ʂ�}������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      :
;;; <���l>      :
;;;               �{������ACAD.LSP����R�[�������
;;;               �v���������̏����̗���
;;;                1.������ʂɂ�����(C:SearchPlan)
;;;                2.�V�K�}�ʂ��J��(PC_SearchPlanNewDwg)
;;;                3.ACAD.LSP����C:PC_LayoutPlan���R�[��
;;;                4.�v�������������s��PLAN.DWG�Ƃ��ĕۑ�(C:PC_LayoutPlan)
;;;                5.���݂̕����ɖ߂�
;;;                6.ACAD.LSP����PLAN.DWG��}�����鏈�������s(C:PC_InsertPlan)�i���{�������j
;;;*************************************************************************>MOH<
(defun C:PC_InsertPlan (
  /
  #ANG #EN #FAMILY$$ #I #INSPT #SETANG #SETPT #UNDOMARKS #WTBASE #XD$ #XREC$
  #BRK #DIM #ELM #K #SSWT #STRANG #STRH #WT_HINBAN #WT_PRICE #XDWTSET$ #en$
#PLAN$ #PLAN$$ #FP #SFNAME ; 03/12/23 YM ADD
#ss_P_ALL
;-- 2011/10/20 A.Satoh Add - S
#WTInfo$ #oku$ #handle$
;-- 2011/10/20 A.Satoh Add - E
#osmode		;-- 2011/11/02 A.Satoh Add
  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
  (defun TempErr (msg)
    (princ "\n�v�����̔z�u���s���܂���ł����B")
    (setq *error* nil)
    (setq CG_OpenMode nil)
    (setq CG_TESTMODE nil)      ;ý�Ӱ��
    (setq CG_AUTOMODE 0)        ;����Ӱ�� 01/09/07 YM ADD ����܂�
    ;;; ��۰��ٕϐ��̸ر� 00/09/08 YM
    (PK_ClearGlobal)
    (command "_undo" "b") ; 01/05/16 YM
    (setq *error* nil) ; 01/05/16 YM

    (princ)
  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

  (WebDefErrFunc) ; �װ�֐���`(02/09/11 YM �֐���)
  (WebOutLog "�װ�֐� SKAutoError2 ���`���܂���(C:PC_InsertPlan)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�

;;;(makeERR "10") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@10

  (setq CG_OpenMode nil)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")

  ;// ���݂̃V���{���}�`�����߂�
  (setq CG_PREV_SYMSS (ssget "X" '((-3 ("G_LSYM")))))
  (setq CG_PREV_WTSS (ssget "X" '((-3 ("G_WRKT")))))
  (if (= nil CG_PREV_SYMSS) (setq CG_PREV_SYMSS (ssadd)))
  (if (= nil CG_PREV_WTSS) (setq CG_PREV_WTSS (ssadd)))

  (CPrint_Time) ; ���t���������O�ɏ������� 00/02/17 YM ADD

  ;00/09/13 SN S-ADD
  ;���݌����������p�ɁA�z�u�O��Undo��ϰ���ݒ肷��B
  ;����������������Ԃł�ϰ����ݒ�o���Ȃ��H�̂�
  ;ϰ����ݒ�o����܂ŌJ��Ԃ��B
  (setq #undomarks (getvar "UNDOMARKS"))
  (while (< (getvar "UNDOMARKS") #undomarks) ;2011/02/01 YM ����ٰ��
    (command "_undo" "m")
  )
  ;00/09/13 SN E-ADD

  (if (= CG_AUTOMODE 2)
    nil  ; Web��CAD���ްӰ��
    (progn
;-- 2011/11/02 A.Satoh Mod - S
;      (SKChgView "0,0,1")
;      (command "_.vpoint" "2,-2,1")
;      (command "_zoom" "e")
      (command "_.vpoint" "0,0,1")
      (command "_zoom" "e")
;-- 2011/11/02 A.Satoh Del - E
    )
  );_if

  (WebOutLog "���݂�}�����܂�(C:PC_InsertPlan)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�

  (if CG_TESTMODE
    (progn
;-- 2011/11/02 A.Satoh Mod - S
;;;;;      (command "_Insert" (strcat CG_SYSPATH "plan.dwg") '(0 0 0) 1 1 "0") ; �z�u�ʒu�Œ�
			(setq #osmode (getvar "OSMODE"))
			(setvar "OSMODE" 1)

      (princ "\n�z�u�_: ")
			(command "_Insert" (strcat CG_SYSPATH "plan.dwg") PAUSE "" "")
			(princ "\n�p�x: ")
			(command PAUSE)
;-- 2011/11/02 A.Satoh Mod - E
    )
    (progn ; CG_TESTMODE =T �ȊO
      
      (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; ����Ӱ��
        (progn ; ���_�Ɏ����z�u����

;;;         (if (or (wcmatch CG_SeriesDB "*K*")(= CG_SeriesDB "SDA")) ;2011/02/01 YM MOD�yPG����z
;;;           (progn
          (cond
            ((= BU_CODE_0005 "1") 

              (if (= (nth 11 CG_GLOBAL$) "R")
                (progn ; �E����
                  (command "_Insert" (strcat CG_SYSPATH "plan.dwg") '(0 0 0) 1 1 "0") ; �z�u�ʒu�Œ�
                  (if (= CG_AUTOMODE 2)
                    nil  ; Web��CAD���ްӰ��
                    (progn
                      (SKChgView "2,-2,1") ; 00/02/23 YM ADD ���_��
                    )
                  );_if
                )
                (progn ; ������
                  (command "_Insert" (strcat CG_SYSPATH "plan.dwg") '(3600 0 0) 1 1 "0") ; �z�u�ʒu�Œ�
                  (if (= CG_AUTOMODE 2)
                    nil  ; Web��CAD���ްӰ��
                    (progn
                      (SKChgView "-2,-2,1") ; ���_�쐼
                    )
                  );_if
                )
              );_if

              (setq #insPt (getvar "LASTPOINT"))
              (setq #ang 0.0)
              (command "_explode" (entlast))

            )
            ((= BU_CODE_0005 "2") 
            ;(progn ;���[�g�� CAD���ް������} �������������������� ;2011/02/01 YM MOD�yPG����z

              (setq #ang 0.0)
              ;���E� LL or RR
              (cond
                ((= "LL" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_LL);5��}���֐�(���)
                )
                ((= "RR" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_RR);5��}���֐�(�E�)
                )
                (T
                  (SD_EXTEND_INSERT_LL);5��}���֐�(���)
                )
              );_cond

              ;������ڑ� 2009/12/1 YM ADD ���[�g��
              (JOIN_COUNTER)
              ;������ڑ� 2009/12/1 YM ADD ���[�g��

            )
            (T ;__OTHER
              (setq #ang 0.0)
              ;���E� LL or RR
              (cond
                ((= "LL" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_LL);5��}���֐�(���)
                )
                ((= "RR" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_RR);5��}���֐�(�E�)
                )
                (T
                  (SD_EXTEND_INSERT_LL);5��}���֐�(���)
                )
              );_cond

              ;������ڑ� 2009/12/1 YM ADD ���[�g��
              (JOIN_COUNTER)
              ;������ڑ� 2009/12/1 YM ADD ���[�g��
            )
          );_cond




        )
        (progn
          ;2010/03/11 YM MOD MJ2�Ή�

;;;         (if (or (wcmatch CG_SeriesDB "*K*")(= CG_SeriesDB "SDA")) ;2011/02/01 YM MOD�yPG����z
;;;           (progn ;�]��
          (cond
            ((= BU_CODE_0005 "1") 

;-- 2011/11/02 A.Satoh Mod - S
;;;;;              (command "_Insert" (strcat CG_SYSPATH "plan.dwg") '(0 0 0) 1 1 0)
							(setq #osmode (getvar "OSMODE"))
							(setvar "OSMODE" 1)

        			(princ "\n�z�u�_: ")
							(command "_Insert" (strcat CG_SYSPATH "plan.dwg") PAUSE "" "")
							(princ "\n�p�x: ")
							(command PAUSE)
;-- 2011/11/02 A.Satoh Mod - E

              (setq #insPt (getvar "LASTPOINT"))
              (setq #ang (cdr (assoc 50 (entget (entlast)))))
              (command "_explode" (entlast))

            )
            ((= BU_CODE_0005 "2") 
            ;(progn ;���[�g�� ���݌��� ��������������������
              (setq #ang 0.0)
              ;���E� LL or RR
              (cond
                ((= "LL" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_LL);5��}���֐�(���)
                )
                ((= "RR" (nth 60 CG_GLOBAL$))
                  (SD_EXTEND_INSERT_RR);5��}���֐�(�E�)
                )
                (T
                  (SD_EXTEND_INSERT_LL);5��}���֐�(���)
                )
              );_cond

              ;������ڑ� 2009/12/1 YM ADD ���[�g��
              (JOIN_COUNTER)
              ;������ڑ� 2009/12/1 YM ADD ���[�g��

            )
          );_cond

        )
      );_if


    )
  );_if

;-- 2011/11/02 A.Satoh Add - S
	(setvar "OSMODE" #osmode)
  (if (= CG_AUTOMODE 2)
    nil  ; Web��CAD���ްӰ��
    (progn
      (SKChgView "0,0,1")
      (command "_.vpoint" "2,-2,1")
      (command "_zoom" "e")
    )
  );_if
;-- 2011/11/02 A.Satoh Add - E


  (KcDelNoExistXRec "DANMENSYM"); Xrecord �̍��ڂ���}�ʂɂȂ��n���h���폜


  (cond
    ((= CG_AUTOMODE 0)
      (setq CG_WorkTop "??")
    )
    ((= CG_AUTOMODE 2);WEB��CAD���ް����
      (if (nth 16 CG_GLOBAL$) (setq CG_WorkTop (substr (nth 16 CG_GLOBAL$) 2 1))) ; �F���O���[�o���ݒ�
    )
  );_cond

;;;  (setq #insPt (getvar "LASTPOINT"))
;;;  (setq #ang (cdr (assoc 50 (entget (entlast)))))
;;;
;;;  (command "_explode" (entlast))

  ;// �z�u������V���{��G_LSYM �̔z�u�_�A�z�u�p�x��u��������
  ;// ���݂̃V���{���}�`�����߂�
  (setq CG_AFTER_SYMSS (ssget "X" '((-3 ("G_LSYM")))))

  ;// �V���ɒǉ����ꂽ�V���{���}�`�����߂�
  (setq #i 0 #en$ nil)
  ;03/12/23 YM ADD ���݌����\����ؽĉ�����
  (setq #plan$$ nil)

  (repeat (sslength CG_AFTER_SYMSS)
    (setq #en (ssname CG_AFTER_SYMSS #i))
    (if (= nil (ssmemb #en CG_PREV_SYMSS))
      (progn
        ; 03/08/25 YM ADD �t�[�h�ɂ�����\��
        ; ��Ŕ���\����� #en$ 01/05/14 YM ADD
        (setq #en$ (cons #en #en$))

        (setq #setpt (cdr (assoc 10 (entget #en))))

        (setq #xd$ (CFGetXData #en "G_LSYM"))
        (setq #setang (+ #ang (nth 2 #xd$)))

        ;// �g���f�[�^�̍X�V
        (CFSetXData #en "G_LSYM"
          (list
            (nth  0 #xd$)  ;1 :�{�̐}�`ID      :
            #setpt         ;2 :�}���_          :  �X�V
            #setang        ;3 :��]�p�x        :  �X�V
            (nth  3 #xd$)  ;4 :�H��L��        :
            (nth  4 #xd$)  ;5 :SERIES�L��    :
            (nth  5 #xd$)  ;6 :�i�Ԗ���        :
            (nth  6 #xd$)  ;7 :L/R�敪         :
            (nth  7 #xd$)  ;8 :���}�`ID        :
            (nth  8 #xd$)  ;9 :���J���}�`ID    :
            (nth  9 #xd$)  ;10:���iCODE      :
            (nth 10 #xd$)  ;11:�����t���O      :
            (nth 11 #xd$)  ;12:�z�u���ԍ�      :
            (nth 12 #xd$)  ;13:�p�r�ԍ�        :
            (nth 13 #xd$)  ;14:���@�g          :
            (nth 14 #xd$)  ;15.�f�ʎw���̗L��  :
            (nth 15 #xd$)  ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
          )
        )
        ;03/12/23 YM ADD-S
        (setq #plan$
          (list
            (nth  5 #xd$)  ;6 :�i�Ԗ���
            (nth  6 #xd$)  ;7 :L/R�敪
            (nth  9 #xd$)  ;10:���iCODE
          )
        )
        (setq #plan$$ (cons #plan$ #plan$$))
        ;03/12/23 YM ADD-E
      )
    );_if

    (KcSetDanmenSymXRec #en); Xrecord ��"DANMENSYM" �ύX 01/04/24 MH
    (setq #i (1+ #i))
  )

;;;(makeERR "14") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@14

  ;// �ŐV�̃��[�N�g�b�v���擾����
  ;// �z�u������V���{��G_LSYM �̔z�u�_�A�z�u�p�x��u��������
  ;// ���݂̃V���{���}�`�����߂�
  (setq CG_AFTER_WTSS (ssget "X" '((-3 ("G_WRKT")))))
  (if (/= CG_AFTER_WTSS nil)
    (progn
      ;// �V���ɒǉ����ꂽ�V���{���}�`�����߂�
      (setq #i 0)
      (repeat (sslength CG_AFTER_WTSS)
        (setq #en (ssname CG_AFTER_WTSS #i))
        (if (= nil (ssmemb #en CG_PREV_WTSS))
          (progn
            (setq #xd$ (CFGetXData #en "G_WRKT"))
            
            (setq #xdWTSET$ (CFGetXData #en "G_WTSET"))
            (if #xdWTSET$
              (setq #WT_HINBAN (nth  1 #xdWTSET$))
              ;else
              (setq #WT_HINBAN "ERROR")
            );_if

            (setq #plan$
              (list
                #WT_HINBAN  ;WT�i��
                ""
                ""
              )
            )
            (setq #plan$$ (cons #plan$ #plan$$))
            ;03/12/23 YM ADD-E ���݌��� ܰ�į�ߕi�Ԃ��擾����

            (setq #WTbase (PKGetWTLeftUpPT #insPt #ang (nth 32 #xd$)))
            ;// �g���f�[�^�̍X�V
            (CFSetXData #en "G_WRKT"
              (CFModList #xd$
                (list (list 32 #WTbase))
              )
            )

;-- 2011/10/20 A.Satoh Add - S
						(setq #WTInfo$
							(list
								(nth  8 #xd$)	; WT�̎�t����
								(nth 10 #xd$)	; WT�̌���
								(nth 12 #xd$)	; BG�̍���
								(nth 13 #xd$)	; BG�̌���
								(nth 15 #xd$)	; FG�̌���
								(nth 16 #xd$)	; FG�̌���
								(nth 17 #xd$)	; �O����V�t�g��
								""
								""
							)
						)
						(setq #oku$ (nth 57 #xd$))
						(cond
							((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (> (nth 2 #oku$) 0.0))
								(setq #handle$ (AddWTCutLineU #en #WTInfo$ 1))
								(if (/= #handle$ nil)
									(CFSetXData #en "G_WRKT" (CFModList #xd$
										(list
											(list  9 (nth 4 #handle$))
											(list 60 (nth 0 #handle$))
											(list 61 (nth 1 #handle$))
											(list 62 (nth 2 #handle$))
											(list 63 (nth 3 #handle$))
										)
									))
								)
							)
							((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (= (nth 2 #oku$) 0.0))
								;2014/12/15 YM MOD-S ----------------------------------------------------------------
										  ;������߂����߂� (J,N,X,S)
										  (setq #Cut$$
										    (CFGetDBSQLRec CG_DBSESSION "WT�ގ�"
										      (list
										        (list "�ގ��L��" (nth 16 CG_GLOBAL$) 'STR)
										      )
										    )
										  )
										  (if (and #Cut$$ (= 1 (length #Cut$$)))
										    (setq #CutType (nth 6 (car #Cut$$))); ��ӂɌ��܂����ꍇ(X or J)
										    ;else ����ł��Ȃ��ꍇ
										    (setq #CutType "N");��ĂȂ�
										  );_if

										  ;J��Ă̏ꍇ��ĕ��������߂�
											(setq #CutDirect "")
										  (if (= #CutType "J")
										    (progn
										      (setq #CutDir$$
										        (CFGetDBSQLRec CG_DBSESSION "WT�J�b�g����"
										          (list
										            (list "�V���N���Ԍ�" (nth  4 CG_GLOBAL$) 'STR)
										            (list "�`��"         (nth  5 CG_GLOBAL$) 'STR)
										            (list "�V���N�ʒu"   (nth  2 CG_GLOBAL$) 'STR)
										          )
										        )
										      )
										      (if (and #CutDir$$ (= 1 (length #CutDir$$)))
										        (progn
										          (setq #CutDirect (nth 4 (car #CutDir$$))); ��ӂɌ��܂����ꍇ(S or G)
										        )
										        ;else ����ł��Ȃ��ꍇ
										        (progn
										          (setq #CutType "N");��ĂȂ�
										        )
										      );_if
										    )
										  );_if

;(J,N,X,S)==>; �J�b�gID�@0:�J�b�g���� 1:�΂߃J�b�g 2:�����J�b�g 3:�������
							 (cond
								 ((= #CutType "N") (setq #CutID 0) )
								 ((= #CutType "X") (setq #CutID 1) )
								 ((= #CutType "J") (setq #CutID 2) )
								 ((= #CutType "S") (setq #CutID 3) )
								 (T                (setq #CutID 0) )
							 );_cond

;;;								(setq #handle$ (AddWTCutLineL #en #WTInfo$ 1));�΂߶�ČŒ�
								(setq #handle$ (AddWTCutLineL_AUTO #en #WTInfo$ #CutID #CutDirect));��Ď��:#CutID ����:#CutDirect�ǉ�

;;;(defun AddWTCutLineL (
;;;  &WT       ; �V�}�`
;;;  &WTInfo   ; WT��ė�
;;;  &CutID    ; �J�b�gID�@0:�J�b�g���� 1:�΂߃J�b�g 2:�����J�b�g
;;;  /


								;2014/12/15 YM MOD-E

								(if (/= #handle$ nil)
									(CFSetXData #en "G_WRKT" (CFModList #xd$
										(list
											(list  9 (nth 4 #handle$))
											(list 60 (nth 0 #handle$))
											(list 61 (nth 1 #handle$))
											(list 62 (nth 2 #handle$))
											(list 63 (nth 3 #handle$))
										)
									))
								);_if
							)
						);_cond
;-- 2011/10/20 A.Satoh Add - E




          )
        );_if
        (setq #i (1+ #i))
      );(repeat
    )
  );_if

  ;// �C���T�[�g�����u���b�N��`���p�[�W����
  (command "_purge" "BL" "PLAN" "N")

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

	;2013/11/19 YM MOD-S
  ;// �K�X��A�d�C����X�V����
;;;  (if (/= CG_GasType nil)
;;;    (progn
;;;      (setq #XRec$ (CFGetXRecord "SERI"))
;;;      (CFSetXRecord "SERI"
;;;        (CFModList #XRec$
;;;          (list
;;;            (list 9  CG_GasType) ;�K�X�� ; CG_GusCode��CG_GasType ; 02/07/31 YM MOD
;;;            (list 10 CG_HzCode)  ;�d�C��
;;;          )
;;;        )
;;;      )
;;;    )
;;;  );_if

  ; �}�ʂ̊g���f�[�^���X�V����
  (setq #seri$
    (list
      CG_DBNAME       ; DB����
      CG_SeriesCode   ; SERIES�L��
      CG_BrandCode    ; �u�����h�L��
      CG_DRSeriCode   ; ��SERIES�L��
      CG_DRColCode    ; ��COLOR�L��
      CG_HIKITE       ; �q�L�e�L��
      CG_UpCabHeight  ; ��t����
      CG_CeilHeight   ; �V�䍂��
      CG_RoomW        ; �Ԍ�
      CG_RoomD        ; ���s
      CG_GasType      ; �K�X��
      CG_ElecType     ; �d�C��
      CG_KikiColor    ; �@��F
      CG_KekomiCode   ; �P�R�~����
    )
  )
  (CFSetXRecord "SERI" #seri$)

	;2013/11/19 YM MOD-E

  ; ���͂����Ŏn�߂ē\�����悤�ɕύX
  ; ���ٰ�ߖ������O�̂Ȃ���ٰ�߂ɂȂ�Ȃ��悤�ɂ��邽��

  ;//---------------------------------------------------------
  ;// ���ʂ̓\�t
  ;//---------------------------------------------------------
  (WebOutLog "���ʂ̓\�t���s���܂�(PCD_MakeViewAlignDoor)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�

  (cond
    ((= BU_CODE_0011 "1")
      ;// ���ʂ̓\��t��(SDC����,����,���Ŏw��𕪂���)�@��2011/04/22 YM ADD ���̐w�}�Ή�
      ;2011/05/27 YM ADD �����ݗ��̐w�}�Ή� ��������ʂ�
      (if (= CG_MKDOOR T)
        (progn
          (Door_Down_Mid_Up #en$  3 T)
        )
      );_if
    )
    (T ;�]���ꊇ�����ւ�
      (if (= CG_MKDOOR T)
;-- 2011/12/22 A.Satoh Add - S
;;;;;        (PCD_MakeViewAlignDoor #en$ 3 nil)
        (PCD_MakeViewAlignDoor #en$ 3 T)
;-- 2011/12/22 A.Satoh Add - E
      );_if
    )
  );_cond




  (if CG_TESTMODE
    (progn
      nil
    )
    (progn
      (setq #sFname (strcat CG_KENMEI_PATH "PLAN.CFG"))
      (if (findfile #sFname)(vl-file-delete #sFname))
      (setq #fp  (open #sFname "w"))
      (if (and #plan$$ (/= nil #fp))
        (progn
          (foreach #elm #plan$$
            (princ (nth 0 #elm) #fp);�i��
            (princ ","  #fp)
            (princ (nth 1 #elm) #fp);LR
            (princ ","  #fp)
            (princ (nth 2 #elm) #fp);���i����
            (princ "\n" #fp)
          )
          (close #fp)
        )
        (progn
          (princ)
        )
      );_if

    )
  );_if


  (if (= CG_AUTOMODE 0)
    (setq *error* nil)
  );_if
  (CPrint_Time) ; ���t���������O�ɏ������� 00/02/17 YM ADD
  (WebOutLog "���݂�}�����܂���"); 02/09/04 YM ADD ۸ޏo�͒ǉ�

  ;2009/02/06 YM ADD-S CG�Ή��ŖʂɐF�ǉ��������A"bylayer"�ɖ߂�
  (setq #ss_P_ALL (ssget "X" (list (cons 8 "Z_00_00_00_01"))))
  (command "_chprop" #ss_P_ALL "" "C" "BYLAYER" "")
  ;2009/02/06 YM ADD-E CG�Ή��ŖʂɐF�ǉ��������A"bylayer"�ɖ߂�

  (setq CG_PREV_SYMSS nil)
  (setq CG_PREV_WTSS nil)
  (setq CG_AFTER_WTSS nil)
  (setq CG_AFTER_SYMSS nil)

  (princ)
);PC_InsertPlan



;<HOM>*************************************************************************
; <�֐���>    : Door_Down_Mid_Up
; <�����T�v>  : ���ʂ̓\��t��(SDC����,����,���Ŏw��𕪂���)
; <�߂�l>    : �쐬���ꂽ����
; <���l>      :
; <�쐬>      : ��2011/04/22 YM ADD ���̐w�}�Ή�
;*************************************************************************>MOH<
(defun Door_Down_Mid_Up (
  &en$ ;����ؽ�
  &iFlg ;3
  &Flg  ;T
  /
  #12 #13 #14 #HIN #QRY$$ #XD$
  )

  (foreach #en &en$
    (setq #xd$ (CFGetXData #en "G_LSYM"))
    (setq #hin (nth 5 #xd$))
    ;"()"���O��
    (setq #hin (KP_DelHinbanKakko #hin))
    ;��,��,��̔���[�㒆�����E��]
    (setq #qry$$
      (CFGetDBSQLRec CG_DBSESSION "�㒆�����E��"
        (list (list "�i�Ԗ���" #hin 'STR))
      )
    )
    (if (and #qry$$ (= 1 (length #qry$$)))
      (progn
        (setq #12 (atoi (nth 2 (car #qry$$))));���V��
        (setq #13 (atoi (nth 3 (car #qry$$))));���F
        (setq #14 (atoi (nth 4 (car #qry$$))));����
        (if CG_GLOBAL$
          (progn ;CAD���ް������}
            ;�ꎞ�I�Ɍ��݂̔���ύX
            (setq CG_DRSeriCode   (nth #12 CG_GLOBAL$))
            (setq CG_DRColCode    (nth #13 CG_GLOBAL$))
            (setq CG_Hikite       (nth #14 CG_GLOBAL$))

            (if (= nil CG_DRSeriCode)(setq CG_DRSeriCode   CG_DRSeriCode_D))
            (if (= nil CG_DRColCode) (setq CG_DRColCode    CG_DRColCode_D))
            (if (= nil CG_Hikite)    (setq CG_Hikite       CG_Hikite_D))

          )
          (progn ;KPCAD
;;; (setq CG_DRSeriCode_D (nth 62 CG_GLOBAL$));����
;;; (setq CG_DRColCode_D  (nth 63 CG_GLOBAL$));����
;;; (setq CG_Hikite_D     (nth 64 CG_GLOBAL$));����
;;;
;;; (setq CG_DRSeriCode_M (nth 82 CG_GLOBAL$));����
;;; (setq CG_DRColCode_M  (nth 83 CG_GLOBAL$));����
;;; (setq CG_Hikite_M     (nth 84 CG_GLOBAL$));����
;;;
;;; (setq CG_DRSeriCode_U (nth 92 CG_GLOBAL$));���
;;; (setq CG_DRColCode_U  (nth 93 CG_GLOBAL$));���
;;; (setq CG_Hikite_U     (nth 94 CG_GLOBAL$));���

            (cond
              ((= #12 62)
                (setq CG_DRSeriCode   CG_DRSeriCode_D)
                (setq CG_DRColCode    CG_DRColCode_D)
                (setq CG_Hikite       CG_Hikite_D)
              )
              ((= #12 82)
                (setq CG_DRSeriCode   CG_DRSeriCode_M)
                (setq CG_DRColCode    CG_DRColCode_M)
                (setq CG_Hikite       CG_Hikite_M)
              )
              ((= #12 92)
                (setq CG_DRSeriCode   CG_DRSeriCode_U)
                (setq CG_DRColCode    CG_DRColCode_U)
                (setq CG_Hikite       CG_Hikite_U)
              )
              ;2011/05/27 YM ADD-S �����ݗ��̐w�}�Ή�
              ((= #12 12)
                (setq CG_DRSeriCode   CG_DRSeriCode_D)
                (setq CG_DRColCode    CG_DRColCode_D)
                (setq CG_Hikite       CG_Hikite_D)
              )
              ((= #12 112)
                (setq CG_DRSeriCode   CG_DRSeriCode_U)
                (setq CG_DRColCode    CG_DRColCode_U)
                (setq CG_Hikite       CG_Hikite_U)
              )
              ;2011/05/27 YM ADD-E �����ݗ��̐w�}�Ή�
              (T
                (setq CG_DRSeriCode   CG_DRSeriCode_D)
                (setq CG_DRColCode    CG_DRColCode_D)
                (setq CG_Hikite       CG_Hikite_D)
              )
            );_cond

          )
        )
      )
      (progn
        ;����(�)���g��
        (setq CG_DRSeriCode   CG_DRSeriCode_D)
        (setq CG_DRColCode    CG_DRColCode_D)
        (setq CG_Hikite       CG_Hikite_D)
      )
    );_if
    ;�ʂɔ����ւ�
    (PCD_MakeViewAlignDoor (list #en) &iFlg &Flg)
  );(foreach

  ;�������ɖ߂�
  (setq CG_DRSeriCode   CG_DRSeriCode_D)
  (setq CG_DRColCode    CG_DRColCode_D)
  (setq CG_Hikite       CG_Hikite_D)

  (princ)
);_Door_Down_Mid_Up

;;;<HOM>*************************************************************************
;;; <�֐���>    : JOIN_COUNTER
;;; <�����T�v>  : ���[�g�嶳����ڑ�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2009/12/1 YM ADD
;;;
;;;�J�E���^�ڑ�����
;;;�@���s��������
;;;�A��{�\��(����)������
;;;�B�p�l�������܂Ȃ�
;;;�C���v�Ԍ�2700mm�ȉ�
;;;*************************************************************************>MOH<
(defun JOIN_COUNTER (
  /
  #GROUP_1$$ #GROUP_11$$ #GROUP_2$$ #GROUP_22$$ #GROUP_3$$ #GROUP_4$$ #I
  #INFO$ #INFO$$ #RET$$ #SS #SYM #GROUP_A$$ #GROUP_B$$ #GROUP_C$$ #GROUP_D$$
  #GROUP_111$$ #GROUP_222$$
  )
  ;�����ɖ��ߍ��܂ꂽ�����擾(Xdata"G_COUNTER")
  (setq #ss (ssget "X" '((-3 ("G_COUNTER")))));����������W

  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (setq #info$$ nil)
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        (setq #info$ (CFGetXData #sym "G_COUNTER"))
        (setq #info$$ (append #info$$ (list #info$)))
        (setq #i (1+ #i))
      )
      ;�񏇂ſ��
      (setq #info$$ (CFListSort #info$$ 0)) ; (nth 1 �����������̏��ɿ��

      ;������ڑ�����1 ��ԍ����A�������ٰ�߂ɕ�����(5��Ȃ̂ōő�2��ٰ��)
      (setq #GROUP_1$$ nil #GROUP_2$$ nil)
      (setq #ret$$ (JOIN_COUNTER_HANTEI1 #info$$))
      (setq #GROUP_1$$ (nth 0 #ret$$))
      (setq #GROUP_2$$ (nth 1 #ret$$))

      ;������ڑ�����2 ���s��,����(���)�����������ق��Ȃ�("N")�ꍇ�����ɍi��
      (setq #GROUP_A$$ nil #GROUP_B$$ nil #GROUP_C$$ nil #GROUP_D$$ nil)
      (if #GROUP_1$$
        (progn

          ;2011/02/22 YM MOD ������ڑ���������
          (cond
            ((= BU_CODE_0007 "1") 
              (setq #ret$$ (JOIN_COUNTER_HANTEI2 #GROUP_1$$))
            )
            ((= BU_CODE_0007 "2")
              ; �V����ި���[�Ͷ�����F�������ɒǉ�
              (setq #ret$$ (JOIN_COUNTER_HANTEI2_2 #GROUP_1$$))
            )
            (T
              (setq #ret$$ (JOIN_COUNTER_HANTEI2_2 #GROUP_1$$))
            )
          );_cond

          (setq #GROUP_A$$ (nth 0 #ret$$))
          (setq #GROUP_B$$ (nth 1 #ret$$))
        )
      );_if
      (if #GROUP_2$$
        (progn

          ;2011/02/22 YM MOD ������ڑ���������
          (cond
            ((= BU_CODE_0007 "1") 
              (setq #ret$$ (JOIN_COUNTER_HANTEI2 #GROUP_2$$))
            )
            ((= BU_CODE_0007 "2")
              ; �V����ި���[�Ͷ�����F�������ɒǉ�
              (setq #ret$$ (JOIN_COUNTER_HANTEI2_2 #GROUP_2$$))
            )
            (T
              (setq #ret$$ (JOIN_COUNTER_HANTEI2_2 #GROUP_2$$))
            )
          );_cond
          
          (setq #GROUP_C$$ (nth 0 #ret$$))
          (setq #GROUP_D$$ (nth 1 #ret$$))
        )
      );_if

      ;�ő�2��ٰ��
      (setq #GROUP_11$$ nil #GROUP_22$$ nil)
      (foreach #GROUP$$ (list #GROUP_A$$ #GROUP_B$$ #GROUP_C$$ #GROUP_D$$)
        (if (/= nil #GROUP$$)
          (progn
            (if (= nil #GROUP_11$$)
              (setq #GROUP_11$$ #GROUP$$)
              ;else
              (setq #GROUP_22$$ #GROUP$$)
            );_if
          )
        );_if
      );foreach

      ;������ڑ�����3 �Ԍ����v2700mm�܂łŕ����� 2009/12/02
      (setq #GROUP_1$$ nil #GROUP_2$$ nil #GROUP_3$$ nil #GROUP_4$$ nil)
      (if #GROUP_11$$
        (progn
          (setq #ret$$ (JOIN_COUNTER_HANTEI3 #GROUP_11$$))
          (setq #GROUP_1$$ (nth 0 #ret$$))
          (setq #GROUP_2$$ (nth 1 #ret$$))
        )
      );_if
      (if #GROUP_22$$
        (progn
          (setq #ret$$ (JOIN_COUNTER_HANTEI3 #GROUP_22$$))
          (setq #GROUP_3$$ (nth 0 #ret$$))
          (setq #GROUP_4$$ (nth 1 #ret$$))
        )
      );_if


      ;�ő�2��ٰ��
      (setq #GROUP_111$$ nil #GROUP_222$$ nil)
      (foreach #GROUP$$ (list #GROUP_1$$ #GROUP_2$$ #GROUP_3$$ #GROUP_4$$)
        (if (/= nil #GROUP$$)
          (progn
            (if (= nil #GROUP_111$$)
              (setq #GROUP_111$$ #GROUP$$)
              ;else
              (setq #GROUP_222$$ #GROUP$$)
            );_if
          )
        );_if
      );foreach

      ;������ڑ��������s��
      (Put_JoinCouter #GROUP_111$$ #GROUP_222$$)
        
    )
  );_if
  (princ)
);JOIN_COUNTER

;;;<HOM>*************************************************************************
;;; <�֐���>    : Put_JoinCouter
;;; <�����T�v>  : ���[�g�嶳����z�u����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2009/12/2 YM ADD
;;;*************************************************************************>MOH<
(defun Put_JoinCouter (
  &GROUP_11$$
  &GROUP_22$$
  /
  #AB #ANG #CT_HINBAN #DD #GROUP_11$$ #GROUP_22$$ #LLRR #LR #PT #QRY$ #SWW #SYM$ #WW #WW_ALL
  #PT$ #SYM #COL
  )
  (foreach #GROUP$$ (list &GROUP_11$$ &GROUP_22$$)
    (if #GROUP$$
      (progn
        (setq #WW_ALL 0);���v�Ԍ�
        (setq #sym$ nil);�폜����ِ}�`
        (setq #pt$  nil);�폜����وʒu���W
        (foreach #GROUP$ #GROUP$$
          (setq #sWW (nth 3 #GROUP$));�Ԍ�
          (setq #qry$
            (CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
              (list (list "�Ԍ��L��" #sWW 'STR))
            )
          )
          (setq #WW (nth 2 (car #qry$)));�Ԍ�(mm)
          (setq #WW_ALL (+ #WW_ALL #WW));�Ԍ���ݐς�����

          ;�폜���������ِ}�`�̗ݐ�
          (setq #sym (nth 5 #GROUP$))
          (setq #sym$ (append #sym$ (list (nth 5 #GROUP$))))
          (setq #pt (cdr (assoc 10 (entget #sym))))
          (setq #pt$ (append #pt$ (list #pt)))
        );foreach


        ;������}�`�̍폜
        (foreach #sym #sym$
          (command "_erase" (CFGetSameGroupSS #sym) "")
        )

        ;�ڑ��㶳��������߂�
        ;���s
        (setq #DD (nth 1 (car #GROUP$$)));���s��
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "���s"
            (list (list "���s�L��" #DD 'STR))
          )
        )
        (setq #DD (nth 2 (car #qry$)));���s(mm)
        (setq #DD (itoa (fix #DD)));���s(mm)
        ;���
        (setq #AB (nth 2 (car #GROUP$$)))
        ;�Ԍ�
        (setq #WW_ALL (itoa (fix #WW_ALL)))

        ;2011/03/02 YM ADD-S "�J�E���^�F"
        (setq #COL (nth 7 (car #GROUP$$)))
        ;2011/03/02 YM ADD-E "�J�E���^�F"
        
        ;2011/03/02 YM ADD "�J�E���^�F"��KEY�ɒǉ����� SDC�����łȂ��ASDB�ɑk��̂�PG����Ȃ�
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "C�J�E���^�u��"
            (list
              (list "���CODE"    #AB     'STR)
              (list "���[�Ԍ�"    #WW_ALL 'INT)
              (list "���s��"      #DD     'INT)
              (list "�J�E���^�F"  #COL    'STR);;2011/03/02 YM ADD
            )
          )
        )
        (setq #qry$ (DBCheck #qry$ "�wC�J�E���^�u���x" "JOIN_COUNTER"))
        (setq #CT_hinban (nth 4 #qry$))
        (setq #LR        (nth 5 #qry$))

        ;������}����_�����߂�
        (setq #LLRR (nth 60 CG_GLOBAL$));���E� 
        (cond
          ((= #LLRR "LL")
            (setq #PT (car #pt$));����͍ŏ��̶������_
          )
          ((= #LLRR "RR")
            (setq #PT (last #pt$));�E��͍Ō�̶������_
          )
          (T
            (setq #PT (car #pt$))
          )
        );_cond

        ;������}������
        (setq #ANG 0.0)

        ;2011/07/27 YM MOD-S
        (TK_PosParts #CT_hinban #LR #PT #ANG 1 "D")
;;;       (TK_PosParts #CT_hinban #LR #PT #ANG nil "D")
        ;2011/07/27 YM MOD-E

      )
    );_if

  );foreach
  (princ)
);Put_JoinCouter

;;;<HOM>*************************************************************************
;;; <�֐���>    : JOIN_COUNTER_HANTEI3
;;; <�����T�v>  : ���[�g�嶳����ڑ�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2009/12/02 YM ADD
;;;������ڑ�����3 �Ԍ����v2700mm�܂łŕ�����
;;;*************************************************************************>MOH<
(defun JOIN_COUNTER_HANTEI3 (
  &info$$
  /
  #GROUP$$ #GROUP_1$$ #GROUP_2$$ #I #QRY$ #SWW #WW #WW_ALL #MAX
#COL
  )

  ;2011/02/22 YM MOD ������ڑ��Ή�
  ;�]��
  ;������Ԍ�KEY=MAX
;;;  (setq #qry$
;;;   (CFGetDBSQLRec CG_DBSESSION "C�J�E���^�ő�Ԍ�"
;;;     (list (list "KEY" "MAX" 'STR))
;;;   )
;;; )

  ;SDC �V����ި���[ (SDB���k����SDC�Ƃ��킹�� "MAX"�̑����"SW"��o�^)
  (setq #COL (nth 7 (car &info$$))) ;������F
  ;������Ԍ�KEY=�ގ��L��
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "C�J�E���^�ő�Ԍ�"
      (list (list "KEY" #COL 'STR))
    )
  )


  (setq #MAX (nth 1 (car #qry$)));�ő�Ԍ�(mm)
  ;(setq #MAX 1800.0);@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
  (setq #GROUP$$ nil);���i�[�p
  (setq #GROUP_1$$ nil);�ڑ��������ٰ��1
  (setq #GROUP_2$$ nil);�ڑ��������ٰ��2
  (if (< 1 (length &info$$))
    (progn
      (setq #i 0)
      (setq #WW_ALL 0);�ݐϊԌ�

      (foreach #info$ &info$$ ;��������
        (setq #sWW (nth 3 #info$));�Ԍ�
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
            (list (list "�Ԍ��L��" #sWW 'STR))
          )
        )
        (setq #WW (nth 2 (car #qry$)));�Ԍ�(mm)

        (if (= 0 #WW_ALL)
          (progn ;����
            (setq #GROUP$$ (append #GROUP$$ (list #info$)))
            (setq #WW_ALL (+ #WW_ALL #WW));�Ԍ���ݐς�����
          )
          (progn ;2��ڈȍ~ 2700mm�ȉ��Ȃ�ǉ�
            (setq #WW_ALL (+ #WW_ALL #WW));�Ԍ���ݐς�����

            (if (> (+ #MAX 1.0) #WW_ALL) ;2700mm�ȉ��Ȃ�ǉ�
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
              )
              (progn ;2700mm���ް
                (if (> 2 (length #GROUP$$))
                  (progn
                    (setq #GROUP$$ nil);�ر
                    (setq #WW_ALL 0)   ;�ݐϊԌ��ر
                    (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                    (setq #WW_ALL (+ #WW_ALL #WW));�Ԍ���ݐς�����
                  )
                  (progn ;����2�ȏソ�܂��Ă���
                    (if (= nil #GROUP_1$$)
                      (setq #GROUP_1$$ #GROUP$$)
                      ;else
                      (setq #GROUP_2$$ #GROUP$$)
                    );_if
                    (setq #GROUP$$ nil);�ر
                    (setq #WW_ALL 0)   ;�ݐϊԌ��ر
                    (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                    (setq #WW_ALL (+ #WW_ALL #WW));�Ԍ���ݐς�����
                  )
                );_if

              )
            );_if
          )
        );_if
        
        (setq #i (1+ #i))
      );foreach
      
      (if (< 1 (length #GROUP$$))
        (progn ;2�ȏソ�܂��Ă���
          (if (= nil #GROUP_1$$)
            (setq #GROUP_1$$ #GROUP$$)
            ;else
            (setq #GROUP_2$$ #GROUP$$)
          );_if
        )
      );_if

    )
  );_if

  ;�߂�l
  (list #GROUP_1$$ #GROUP_2$$)
);JOIN_COUNTER_HANTEI3

;;;<HOM>*************************************************************************
;;; <�֐���>    : JOIN_COUNTER_HANTEI2
;;; <�����T�v>  : ���[�g�嶳����ڑ�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2009/12/1 YM ADD
;;;������ڑ�����2 ���s��,����(���)�����������ق��Ȃ�("N")�ꍇ�����ɍi��
;;;*************************************************************************>MOH<
(defun JOIN_COUNTER_HANTEI2 (
  &info$$
  /
  #DD #DD_OLD #EP #GROUP$$ #GROUP_1$$ #GROUP_2$$ #HH #HH_OLD #I
#EP_OLD
  )
  (setq #GROUP$$ nil);���i�[�p
  (setq #GROUP_1$$ nil);�ڑ��������ٰ��1
  (setq #GROUP_2$$ nil);�ڑ��������ٰ��2
  (if (< 1 (length &info$$))
    (progn
      (setq #i 0)
      (setq #DD_old nil);�O��̉��s��
      (setq #HH_old nil);�O��̍���(���)
      (setq #EP_old nil);�������ٗL��

      (foreach #info$ &info$$ ;��������
        (setq #DD (nth 1 #info$));���s��
        (setq #HH (nth 2 #info$));����(���)
        (setq #EP (nth 4 #info$));�������ٗL��

        (if (= nil #DD_old)
          (progn ;����
            (if (= #EP "N");����"Y"�͏���
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                (setq #DD_old #DD);�O��̉��s��
                (setq #HH_old #HH);�O��̍���(���)
                (setq #EP_old #EP);�O���EP�L��
              )
            );_if
          )
          (progn ;2��ڈȍ~
            (if (and (= #DD #DD_old) ;�O��Ɖ��s��������
                     (= #HH #HH_old) ;�O��ƍ���(���)������
                     (= #EP_old "N"));�������قȂ� �O��"Y"�͏���
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                (setq #DD_old #DD);�O��̉��s��
                (setq #HH_old #HH);�O��̍���(���)
                (setq #EP_old #EP);�O���EP�L��
              )
              (progn
                (if (> 2 (length #GROUP$$))
                  (progn
                    (setq #GROUP$$ nil);�ر
                    (if (= #EP "N")
                      (progn
                        (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                        (setq #DD_old #DD);�O��̉��s��
                        (setq #HH_old #HH);�O��̍���(���)
                        (setq #EP_old #EP);�O���EP�L��
                      )
                    );_if
                  )
                  (progn ;����2�ȏソ�܂��Ă���
                    (if (= nil #GROUP_1$$)
                      (setq #GROUP_1$$ #GROUP$$)
                      ;else
                      (setq #GROUP_2$$ #GROUP$$)
                    );_if
                    (setq #GROUP$$ nil);�ر
                    (if (= #EP "N")
                      (progn
                        (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                        (setq #DD_old #DD);�O��̉��s��
                        (setq #HH_old #HH);�O��̍���(���)
                        (setq #EP_old #EP);�O���EP�L��
                      )
                    );_if
                  )
                );_if

              )
            );_if
          )
        );_if
        
        (setq #i (1+ #i))
      );foreach
      
      (if (< 1 (length #GROUP$$))
        (progn ;2�ȏソ�܂��Ă���
          (if (= nil #GROUP_1$$)
            (setq #GROUP_1$$ #GROUP$$)
            ;else
            (setq #GROUP_2$$ #GROUP$$)
          );_if
        )
      );_if

    )
  );_if

  ;�߂�l
  (list #GROUP_1$$ #GROUP_2$$)
);JOIN_COUNTER_HANTEI2

;;;<HOM>*************************************************************************
;;; <�֐���>    : JOIN_COUNTER_HANTEI2_2
;;; <�����T�v>  : ���[�g�嶳����ڑ�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2011/02/22 YM ADD
;;;������ڑ�����2 ���s��,����(���)�����������ق��Ȃ�("N")�ꍇ�����ɍi��
;;;�������ɶ�����F���ǉ���
;;;*************************************************************************>MOH<
(defun JOIN_COUNTER_HANTEI2_2 (
  &info$$
  /
  #DD #DD_OLD #EP #GROUP$$ #GROUP_1$$ #GROUP_2$$ #HH #HH_OLD #I
#EP_OLD #CO #CO_OLD
  )
  (setq #GROUP$$ nil);���i�[�p
  (setq #GROUP_1$$ nil);�ڑ��������ٰ��1
  (setq #GROUP_2$$ nil);�ڑ��������ٰ��2
  (if (< 1 (length &info$$))
    (progn
      (setq #i 0)
      (setq #DD_old nil);�O��̉��s��
      (setq #HH_old nil);�O��̍���(���)
      (setq #EP_old nil);�������ٗL��
      (setq #CO_old nil);���O��̶�����F��

      (foreach #info$ &info$$ ;��������
        (setq #DD (nth 1 #info$));���s��
        (setq #HH (nth 2 #info$));����(���)
        (setq #EP (nth 4 #info$));�������ٗL��
        (setq #CO (nth 7 #info$));���O��̶�����F��

        (if (= nil #DD_old)
          (progn ;����
            (if (= #EP "N");����"Y"�͏���
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                (setq #DD_old #DD);�O��̉��s��
                (setq #HH_old #HH);�O��̍���(���)
                (setq #EP_old #EP);�O���EP�L��
                (setq #CO_old #CO);���O��̶�����F��
              )
            );_if
          )
          (progn ;2��ڈȍ~
            (if (and (= #DD #DD_old) ;�O��Ɖ��s��������
                     (= #HH #HH_old) ;�O��ƍ���(���)������
                     (= #EP_old "N") ;�������قȂ� �O��"Y"�͏���
                     (= #CO #CO_old));�O��Ɓ�������F��������
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                (setq #DD_old #DD);�O��̉��s��
                (setq #HH_old #HH);�O��̍���(���)
                (setq #EP_old #EP);�O���EP�L��
                (setq #CO_old #CO);���O��̶�����F��
              )
              (progn
                (if (> 2 (length #GROUP$$))
                  (progn
                    (setq #GROUP$$ nil);�ر
                    (if (= #EP "N")
                      (progn
                        (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                        (setq #DD_old #DD);�O��̉��s��
                        (setq #HH_old #HH);�O��̍���(���)
                        (setq #EP_old #EP);�O���EP�L��
                        (setq #CO_old #CO);���O��̶�����F��
                      )
                    );_if
                  )
                  (progn ;����2�ȏソ�܂��Ă���
                    (if (= nil #GROUP_1$$)
                      (setq #GROUP_1$$ #GROUP$$)
                      ;else
                      (setq #GROUP_2$$ #GROUP$$)
                    );_if
                    (setq #GROUP$$ nil);�ر
                    (if (= #EP "N")
                      (progn
                        (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                        (setq #DD_old #DD);�O��̉��s��
                        (setq #HH_old #HH);�O��̍���(���)
                        (setq #EP_old #EP);�O���EP�L��
                        (setq #CO_old #CO);���O��̶�����F��
                      )
                    );_if
                  )
                );_if

              )
            );_if
          )
        );_if
        
        (setq #i (1+ #i))
      );foreach
      
      (if (< 1 (length #GROUP$$))
        (progn ;2�ȏソ�܂��Ă���
          (if (= nil #GROUP_1$$)
            (setq #GROUP_1$$ #GROUP$$)
            ;else
            (setq #GROUP_2$$ #GROUP$$)
          );_if
        )
      );_if

    )
  );_if

  ;�߂�l
  (list #GROUP_1$$ #GROUP_2$$)
);JOIN_COUNTER_HANTEI2_2

;;;<HOM>*************************************************************************
;;; <�֐���>    : JOIN_COUNTER_HANTEI1
;;; <�����T�v>  : ���[�g�嶳����ڑ�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2009/12/1 YM ADD
;;;������ڑ�����1 ��ԍ����A�������ٰ�߂ɕ�����(�ő�5��Ȃ̂ōő�2��ٰ��)
;;;�� (1,"A")(2,"A")(4,"A")(5,"A")===>�@((1,"A")(2,"A")), �A((4,"A")(5,"A"))
;;;�� (1,"A")(3,"A")(4,"A")(5,"A")===>�@((3,"A")(4,"A")(5,"A")), �A(nil)
;;;�� (1,"A")(3,"A")(5,"A")       ===>�@(nil)           , �A(nil)
;;;*************************************************************************>MOH<
(defun JOIN_COUNTER_HANTEI1 (
  &info$$
  /
  #GROUP$$ #GROUP_1$$ #GROUP_2$$ #I #NUM #NUM_OLD
  )
  (setq #GROUP$$ nil);���i�[�p
  (setq #GROUP_1$$ nil);�ڑ��������ٰ��1
  (setq #GROUP_2$$ nil);�ڑ��������ٰ��2
  (if (< 1 (length &info$$))
    (progn
      (setq #i 0)
      (setq #num_old nil);�O��̗�ԍ�
      (foreach #info$ &info$$ ;��������
        (setq #num (nth 0 #info$));��ԍ�
        (if (= nil #num_old)
          (progn ;����
            (setq #GROUP$$ (append #GROUP$$ (list #info$)))
          )
          (progn ;2��ڈȍ~
            (if (= #num (1+ #num_old))
              (progn
                (setq #GROUP$$ (append #GROUP$$ (list #info$)))
              )
              (progn
                (if (> 2 (length #GROUP$$))
                  (progn
                    (setq #GROUP$$ nil);�ر
                    (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                  )
                  (progn ;����2�ȏソ�܂��Ă���
                    (if (= nil #GROUP_1$$)
                      (setq #GROUP_1$$ #GROUP$$)
                      ;else
                      (setq #GROUP_2$$ #GROUP$$)
                    );_if
                    (setq #GROUP$$ nil);�ر
                    (setq #GROUP$$ (append #GROUP$$ (list #info$)))
                  )
                );_if

              )
            );_if
          )
        );_if
        
        (setq #num_old #num);�O��ԍ�
        (setq #i (1+ #i))
      );foreach
      
      (if (< 1 (length #GROUP$$))
        (progn ;2�ȏソ�܂��Ă���
          (if (= nil #GROUP_1$$)
            (setq #GROUP_1$$ #GROUP$$)
            ;else
            (setq #GROUP_2$$ #GROUP$$)
          );_if
        )
      );_if

    )
  );_if

  ;�߂�l
  (list #GROUP_1$$ #GROUP_2$$)
);JOIN_COUNTER_HANTEI1



;;;<HOM>*************************************************************************
;;; <�֐���>    : SD_EXTEND_INSERT_LL
;;; <�����T�v>  : ���[�g��v�����}��(���)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2009/11/21 YM ADD
;;; <���l>      : �z�u�����@��
;;;*************************************************************************>MOH<
(defun SD_EXTEND_INSERT_LL (
  /
  #MAGU #QRY$ #WW #XX_ALL
  #I #OPEN_BOX_ANG #OPEN_BOX_HIN #OPEN_BOX_LR #OPEN_BOX_X #OPEN_BOX_Y #OPEN_BOX_Z
   #PT #QRY$$ #TURITO_UNDER_OPEN_BOX_FLG #TURITO_UNDER_OPEN_BOX_PT #TURITO_UNDER_OPEN_BOX_X #XX
  )
  ;2009/11/21 YM MOD ���[�g��
  ;���E� LL or RR
  ;;;(nth 60 CG_GLOBAL$)
  ;2�`5��ڊԌ�
  ;;;(nth (+ (* 100 #i) 55) CG_GLOBAL$)
  ;2�`5��ڗL��
  ;;;(nth (+ (* 100 #i) 1) CG_GLOBAL$)
  ;2�`5���EP�L��
  ;;;(nth (+ (* 100 #i) 71) CG_GLOBAL$)
  ;�ŏIEP�L��
  ;;;(nth 71 CG_GLOBAL$)

  ;�@��ځ@EP�������Ă��Ȃ��Ă�(0,0,0)�ɔz�u
  (command "_Insert" (strcat CG_SYSPATH "plan1.dwg") '(0 0 0) 1 1 0)
  (command "_explode" (entlast))

  ;2011/05/09 YM ADD-S 1��ڂ𔻒�@������������������
  (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
    (progn
      (setq #Turito_Under_Open_Box_FLG nil);�g�[���A��^���[�ȊO��������� T
      ;���\���@1��� PLAN161="X"
      (if (/= (nth 161 CG_GLOBAL$) "X")
        (progn
          (setq #Turito_Under_Open_Box_FLG T);�g�[���A��^���[�ȊO��������� T
          (setq #Turito_Under_Open_Box_X 0);�m��
        )
      );_if
    )
  );_if
  ;2011/05/09 YM ADD-E 1��ڂ𔻒�@������������������

  ;�A�`�D��ځ@��O�̗�̊Ԍ�������X�����ɂ��炵�Ĕz�u����
  (setq #XX_ALL 0);�ݐ�X���W
  (foreach #i (list 2 3 4 5)
    (if (and (= "Y" (nth (+ (* 100 #i) 1) CG_GLOBAL$))
             (findfile (strcat CG_SYSPATH "plan" (itoa #i) ".dwg")))
      (progn
        (setq #magu (nth (+ (* 100 (1- #i)) 55) CG_GLOBAL$));���ڊԌ�
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
            (list (list "�Ԍ��L��" #magu 'STR))
          )
        )
        (setq #WW (nth 2 (car #qry$)))
        (setq #XX_ALL (+ #XX_ALL #WW));�Ԍ���X���W��ݐς�����

        (if (and (/="N" (nth (+ (* 100 (1- #i)) 71) CG_GLOBAL$)) ;�O�̗��EP�Ȃ��łȂ��Ƃ�
                 (/="X" (nth (+ (* 100 (1- #i)) 71) CG_GLOBAL$)))
          (setq #XX_ALL (+ #XX_ALL CG_EP_THICKNESS));EP����(��ذ�ނɈˑ�)
        );_if
        (command "_Insert" (strcat CG_SYSPATH "plan" (itoa #i) ".dwg") (list #XX_ALL 0 0) 1 1 0)
        (command "_explode" (entlast))

        ;2011/05/09 YM ADD-S�@������������������
        (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
          ;���\���@PLAN?61="X"
          (if (= nil #Turito_Under_Open_Box_FLG)
            (if (/= (nth (+ (* 100 #i) 61) CG_GLOBAL$) "X")
              (progn
                (setq #Turito_Under_Open_Box_FLG T);�g�[���A��^���[�ȊO��������� T
                (setq #Turito_Under_Open_Box_X #XX_ALL);�m��
              )
            );_if
          );_if
        );_if

        ;2011/05/09 YM ADD-E�@������������������
      )
    );_if
    (setq #i (1+ #i))
  );foreach

  ;2011/05/09 YM ADD-S�@�݌ˉ�OPEN_BOX��z�u�@������������������
  (if (and #Turito_Under_Open_Box_X (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
    (progn
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "�݌ˉ�OPEN_BOX�\��"
          (list (list "PLAN59" (nth 59 CG_GLOBAL$) 'STR))
        )
      )
      (if #qry$$
        (progn
          ;(setq #XX #Turito_Under_Open_Box_X)
          (foreach #qry$ #qry$$
            (setq #Open_Box_hin (nth 3 #qry$))
            (setq #Open_Box_LR  (nth 4 #qry$))
            (setq #Open_Box_X   (nth 5 #qry$))
            (setq #Open_Box_Y   (nth 6 #qry$))
            (setq #Open_Box_Z   (nth 7 #qry$))
            (setq #Open_Box_ANG (nth 8 #qry$))
            ;(setq #XX (+ #XX #Open_Box_X));X���W
            (setq #XX (+ #Turito_Under_Open_Box_X #Open_Box_X));X���W
            (setq #PT (list #XX #Open_Box_Y #Open_Box_Z))
            (TK_PosParts #Open_Box_hin #Open_Box_LR #PT #Open_Box_ANG nil "D")
          )
        )
      );_if
    )
  );_if
  ;2011/05/09 YM ADD-E�@�݌ˉ�OPEN_BOX��z�u�@������������������

  (princ)
);SD_EXTEND_INSERT_LL

;;;<HOM>*************************************************************************
;;; <�֐���>    : SD_EXTEND_INSERT_RR
;;; <�����T�v>  : ���[�g��v�����}��(�E�)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2009/11/23 YM ADD
;;; <���l>      : �z�u�����@��
;;;*************************************************************************>MOH<
(defun SD_EXTEND_INSERT_RR (
  /
  #MAGU #QRY$ #WW #XX_ALL
  #OPEN_BOX_ANG #OPEN_BOX_HIN #OPEN_BOX_LR #OPEN_BOX_X #OPEN_BOX_Y #OPEN_BOX_Z
  #PT #QRY$$ #QRY_MAGU$ #QRY_ZUKEI$ #TURITO_UNDER_OPEN_BOX_FLG #TURITO_UNDER_OPEN_BOX_X #XX
  )
  ;2009/11/21 YM MOD ���[�g��
  ;���E� LL or RR
  ;;;(nth 60 CG_GLOBAL$)
  ;2�`5��ڊԌ�
  ;;;(nth (+ (* 100 #i) 55) CG_GLOBAL$)
  ;2�`5��ڗL��
  ;;;(nth (+ (* 100 #i) 1) CG_GLOBAL$)
  ;2�`5���EP�L��
  ;;;(nth (+ (* 100 #i) 71) CG_GLOBAL$)
  ;�ŏIEP�L��
  ;;;(nth 71 CG_GLOBAL$)

  ;�@��� �Ԍ������ɂ��炷
  (setq #XX_ALL 0);�ݐ�X���W
  (setq #magu (nth (+ (* 100 1) 55) CG_GLOBAL$));�Ԍ�
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
      (list (list "�Ԍ��L��" #magu 'STR))
    )
  )
  (setq #WW (nth 2 (car #qry$)))
  (setq #XX_ALL (- #XX_ALL #WW));�Ԍ���X���W��ݐς�����

  (command "_Insert" (strcat CG_SYSPATH "plan1.dwg") (list #XX_ALL 0 0) 1 1 0)
  (command "_explode" (entlast))

  ;2011/05/09 YM ADD-S 1��ڂ𔻒�@������������������
  (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
    (progn
      (setq #Turito_Under_Open_Box_FLG nil);�g�[���A��^���[�ȊO��������� T
      ;���\���@1��� PLAN161="X"
      (if (/= (nth 161 CG_GLOBAL$) "X")
        (progn
          (setq #Turito_Under_Open_Box_FLG T);1��ڂŃg�[���A��^���[�ȊO��������� T
          (setq #Turito_Under_Open_Box_X 0);�m��
        )
      );_if
    )
  );_if
  ;2011/05/09 YM ADD-E 1��ڂ𔻒�@������������������


  ;�A�`�D��ځ@�Ԍ�������X��ϲŽ�����ɂ��炵�Ĕz�u����
  (foreach #i (list 2 3 4 5)
    (if (and (= "Y" (nth (+ (* 100 #i) 1) CG_GLOBAL$))
             (findfile (strcat CG_SYSPATH "plan" (itoa #i) ".dwg")))
      (progn
        (setq #magu (nth (+ (* 100 #i) 55) CG_GLOBAL$));�Ԍ�
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
            (list (list "�Ԍ��L��" #magu 'STR))
          )
        )
        (setq #WW (nth 2 (car #qry$)))
        (setq #XX_ALL (- #XX_ALL #WW));�Ԍ���X���W��ݐς�����

        (if (and (/="N" (nth (+ (* 100 (1- #i)) 71) CG_GLOBAL$));EP�Ȃ��łȂ��Ƃ�
                 (/="X" (nth (+ (* 100 (1- #i)) 71) CG_GLOBAL$)))
          (setq #XX_ALL (- #XX_ALL CG_EP_THICKNESS));EP����(��ذ�ނɈˑ�)
        );_if
        (command "_Insert" (strcat CG_SYSPATH "plan" (itoa #i) ".dwg") (list #XX_ALL 0 0) 1 1 0)
        (command "_explode" (entlast))

        ;2011/05/09 YM ADD-S�@������������������
        (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
          ;���\���@PLAN?61="X"
          (if (= nil #Turito_Under_Open_Box_FLG)
            (if (/= (nth (+ (* 100 #i) 61) CG_GLOBAL$) "X")
              (progn
                (setq #Turito_Under_Open_Box_FLG T);�g�[���A��^���[�ȊO��������� T
                (setq #Turito_Under_Open_Box_X (+ #XX_ALL #WW ));�m��E�[�_(�Ԍ����͈����߂��Ȃ̂ŉ�����)
              )
            );_if
          );_if
        );_if
        ;2011/05/09 YM ADD-E�@������������������

      )
    );_if
    (setq #i (1+ #i))
  );foreach

  ;2011/05/09 YM ADD-S�@�݌ˉ�OPEN_BOX��z�u�@������������������
  (if (and #Turito_Under_Open_Box_X (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
    (progn
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "�݌ˉ�OPEN_BOX�\��"
          (list (list "PLAN59" (nth 59 CG_GLOBAL$) 'STR))
        )
      )
      (if #qry$$
        (progn
          (setq #XX #Turito_Under_Open_Box_X);�E�[�_
          (foreach #qry$ #qry$$
            (setq #Open_Box_hin (nth 3 #qry$))
            (setq #Open_Box_LR  (nth 4 #qry$))
            (setq #Open_Box_X   (nth 5 #qry$))
            (setq #Open_Box_Y   (nth 6 #qry$))
            (setq #Open_Box_Z   (nth 7 #qry$))
            (setq #Open_Box_ANG (nth 8 #qry$))

            (setq #qry_zukei$
              (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
                (list (list "�i�Ԗ���" #Open_Box_hin 'STR))
              )
            )
            (setq #WW (nth 3 (car #qry_zukei$)));W�l

            (setq #XX (- #XX #WW));X���W
            (setq #PT (list #XX #Open_Box_Y #Open_Box_Z))
            (TK_PosParts #Open_Box_hin #Open_Box_LR #PT #Open_Box_ANG nil "D")
          )
        )
      );_if
    )
  );_if
  ;2011/05/09 YM ADD-E�@�݌ˉ�OPEN_BOX��z�u�@������������������

  (princ)
);SD_EXTEND_INSERT_RR

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetWTLeftUpPT
;;; <�����T�v>  : �}����̃v��������WT����_�����߂�
;;; <�߂�l>    : WT����_���W
;;; <�쐬>      : 00/09/06 YM 09/11 MOD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKGetWTLeftUpPT (
  &inspt ; �}���_
  &ang   ; �}���p�x
  &WTPT  ; ���ݍ쐬����WT����_
  /
  #ANG #DIST #PT
  )
;;; ���[�� *:�}���_�ʒu(0,0)
;;;        P:WT����_(&WTPT)
;;;   +-----------P--------------------------+
;;;   *-----------+--------------------------+
;;;   |           |                          |
;;;   |           |                          |
;;;   |           |                          |
;;;   +-----------+--------------------------+

  (setq #dist (distance '(0 0) &WTPT)) ; ����
  (setq #ang  (angle '(0 0) &WTPT))    ; �p�x
  (setq #pt   (polar &inspt (+ &ang #ang) #dist)) ; �V����WT����_
  #pt
);PKGetWTLeftUpPT

;;;<HOM>*************************************************************************
;;; <�֐���>    : PC_LayoutPlanExec
;;; <�����T�v>  : �v�����������������s
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      :
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PC_LayoutPlanExec (
  /
  #family$$ #NEW_SYM_PT
  )

  ;//---------------------------------------------------------
  ;// ��}��ʂ̊e��ݒ�
  ;//---------------------------------------------------------
  (command "_zoom" "w" (list -3000 -2000) (list 3000 0))
  (command "VIEW" "S" "INIT")

  ;// �g���f�[�^�A�v���P�[�V��������o�^
  (princ "\n---�g���f�[�^�A�v���P�[�V��������o�^---")
  (regapp "G_SYM")
  (regapp "G_LSYM")
  ;2009/11/30 YM ADD
  (regapp "G_COUNTER")
  (princ "\n---11111�g���f�[�^�A�v���P�[�V��������o�^---")
  (regapp "G_ARW")
  (princ "\n---22222�g���f�[�^�A�v���P�[�V��������o�^---")
  (regapp "G_OPT")
  (princ "\n---33333�g���f�[�^�A�v���P�[�V��������o�^---")
;;;(makeERR "8-1") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8-1
  ;// ���ѕϐ�������
  (princ "\n--- ���ѕϐ�������---")
  (setvar "LISPINIT"  0)     ;Lisp�ϐ������������Ȃ�
  (setvar "CMDECHO"   0)     ;����޴��OFF
  (setvar "EXPERT"    4)     ;�㏑���m�F�̐���
  (if (= "ACAD" CG_PROGRAM)
    (setvar "MENUCTL"   0)     ;�ƭ����۰�
  )
  ;(setvar "PDMODE"    34)    ;�_�\��Ӱ��
  (setvar "PDMODE"    0)     ;�_�\��Ӱ��
  (setvar "HPSCALE"   10)    ;ʯ�ݸ޽���
  (setvar "LTSCALE"   15)    ;������
  (setvar "PICKSTYLE" 0)     ;�O���[�v�I�����[�hOFF
  (setvar "OSMODE"    0)
  (if (or (= "18" CG_ACADVER)(= "19" CG_ACADVER)(= "23" CG_ACADVER));2020/01/29 YM ADD
		(progn
	    (setvar "3DOSMODE"  1) ;2011/06/30 YM ADD
			(setvar "UCSDETECT" 0) ;�_�C�i�~�b�N UCS ���A�N�e�B�u�ɂ��Ȃ� 2011/10/11 YM ADD
		)
  );_if
  (setvar "SNAPMODE"  0)

  ;// �v���������_�C�A���O�ɂďo�͂��ꂽ�����擾����
  (princ "\n--- �v���������_�C�A���O�ɂďo�͂��ꂽ�����擾����---")
  (cond
    ((= CG_AUTOMODE 3) ; Web��LOCAL CAD�[��Ӱ�� #family$$="Input.cfg"�Ƃ���; 02/08/05 YM ADD-S
      (setq CG_DATFILE      (cadr (assoc "DATFILE" CG_PLANINFO$)))     ; DAŢ�ٖ�(Input.cfg) Planinfo.dfg
      (setq CG_DOWNLOADPATH (cadr (assoc "DOWNLOADPATH" CG_INIINFO$))) ; ���ʂc�a���� KS ADD Kenmei.cfg
      (setq CG_INPUTINFO$ (ReadIniFile (strcat CG_DOWNLOADPATH CG_DATFILE)))
      (WebSetGlobal)   ; ̧�ذ���ނ������݌����ɕK�v�ȸ�۰��ق�Ă��� CG_PlanType �����肷��
      (setq #family$$ CG_INPUTINFO$)
    )
    ((= CG_AUTOMODE 2) ; Web��CAD���ްӰ�� #family$$="Input.cfg"�Ƃ���
      (setq #family$$ CG_INPUTINFO$) ; 02/07/31 YM DEL ���� CG_PlanType ������
      (princ "\n---���̎��_�Ÿ�۰��پ�čς�---")
      nil ; ���̎��_�Ÿ�۰��پ�čς�
    )
    ;������ "SRCPLN.CFG" Read
    (T 
      ; ���܂�(�ʏ� or �����ݸ޼��)
      (if (= CG_TESTMODE 1)
        (progn ; ý�Ӱ��
          (setq #family$$ (ReadIniFile (strcat CG_SYSPATH "Srcpln" "_" CG_SeriesDB "_" (itoa CG_TESTCASE) ".cfg")));07/05/11 YM ADD
        )
        (progn ; �ʏ�Ӱ�� & ����Ӱ��
          (setq #family$$ (ReadIniFile (strcat CG_SYSPATH "SRCPLN.CFG")))
        )
      );_if

      (setq CG_PlanType (cadr (assoc "PLANTYPE" #family$$))) ; "SK","SD"

    )
  );_cond

  (princ "\n---�װ�֐���`---")
  (WebDefErrFunc) ; �װ�֐���`(02/09/11 YM �֐���)
  (WebOutLog "�װ�֐� SKAutoError2 ���`���܂���(PC_LayoutPlanExec)")
  (WebOutLog " ")
  (WebOutLog "SK==>PK_StartLayout or SD==>PD_StartLayout �Ȃǂŕ���(PC_LayoutPlanExec)")

  (cond
    ((= CG_PlanType "SK") ; WEB�ŃL�b�`���͂�����ʂ�
      (princ "\nWEB�ŃL�b�`���͂�����ʂ�---")
      (PK_StartLayout #family$$)
    )
    ((= CG_PlanType "SD") ; WEB�Ŏ��[���͂�����ʂ�
      (cond
        ;((= CG_SeriesDB "SDA") ;2011/02/01 YM MOD�yPG����z
        ((= BU_CODE_0004 "1")
          (princ "\nSDA �]�����[ۼޯ�---")
          (PD_StartLayout        #family$$);SDA �]�����[ۼޯ�
        )
        ;((= CG_SeriesDB "SDB") ;2011/02/01 YM MOD�yPG����z
        ((= BU_CODE_0004 "2")
          ;2009/11/18 YM ���[�g��
          (princ "\nSDB ���[�g��---")
          (PD_StartLayout_EXTEND #family$$);SDB
        )
        (T ;SDC�ȍ~
          (PD_StartLayout_EXTEND #family$$);SDB�ȍ~
        )
      );_cond
        
    )
    ((= CG_PlanType "WF")
      (WF_StartLayout #family$$)
    )
    (T ; CG_PlanType=nil
      (setq CG_PlanType "SK")
      (PK_StartLayout #family$$)
    )
  );_cond


  (WebOutLog "�ޭ���߂��ĕ\����w�̐ݒ���s���܂�"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  ;// �r���[�����ɖ߂�
  (princ "\n�r���[�����ɖ߂� START")
  (command "VIEW" "R" "INIT")
  (princ "\n�r���[�����ɖ߂� END")
  ;// �\����w�̐ݒ�
  (princ "\n�\����w�̐ݒ�")
  (SetLayer);03/09/29 YM MOD

  (princ)
);PC_LayoutPlanExec

;<HOM>*************************************************************************
; <�֐���>     : PKGetPMEN_NO_LIST
; <�����T�v>   : �ݸ����ِ}�`,PMEN�ԍ���n����PMEN(&NO)�}�`���𓾂�
; <�߂�l>     : PMEN(&NO)�}�`��
; <�쐬>       : 00/05/04 YM
; <���l>       : 2017/10/04 YM ADD PMEN��S���Ԃ�
;*************************************************************************>MOH<
(defun PKGetPMEN_NO_LIST (
  &scab-en   ;(ENAME)���޼���ِ}�`
  &NO        ;PMEN �̔ԍ�
  /
  #EN #I #MSG #pmen$ #S-XD$ #SS #XD$ #LOOP #NAME
  )
  (cond
    ((= &NO 1)(setq #NAME "(�B���̈�)"))
    ((= &NO 2)(setq #NAME "(�O�`�̈�)"))
    ((= &NO 3)(setq #NAME "(���궳����̈�)"))
    ((= &NO 4)(setq #NAME "(�ݸ���̈�)"))
    ((= &NO 5)(setq #NAME "(��ی��̈�)"))
    ((= &NO 6)(setq #NAME "(���������̈�)"))
    ((= &NO 7)(setq #NAME "(���ʗp���̈�)"))
    ((= &NO 8)(setq #NAME "(�ݸ��t�̈�)"))
    (T (setq #NAME ""))
  );_cond
  (setq #ss (CFGetSameGroupSS &scab-en))
  (setq #i 0)
  (setq #pmen$ nil)
  (while (< #i (sslength #ss))
    (setq #en (ssname #ss #i))
    (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
    (if #xd$
      (progn
        (if (= &NO (car #xd$))
          (progn
            (setq #pmen$ (append #pmen$ (list #en)))
          )
        );_if
      )
    );_(if
    (setq #i (1+ #i))
  )
  #pmen$
);PKGetPMEN_NO_LIST

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetCounterGaikeiPT
;;; <�����T�v>  : ��������ʊO�`�̈�̓_����擾
;;; <�߂�l>    : �_�񃊃X�g
;;; <�쐬>      : 2017/10/04 YM ADD
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PKGetCounterGaikeiPT (
  /
	#I #LAYER #PMEN1 #PTA$ #SS #SYM #pmen1$
  )
	(setq #ptALL$ nil)
	(setq #ptRET$ nil);�߂�l

	(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
	(setq #i 0)
	(if (and #ss (< 0 (sslength #ss)))
    (while (< #i (sslength #ss))
      (setq #sym (ssname #ss #i))
      (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CNT) ; ���i����1��=7 �����
				(progn
					(setq #pmen1$ (PKGetPMEN_NO_LIST #sym 1)) ;�����
					(setq #loop T)
					(foreach #pmen1 #pmen1$
						(setq #layer (cdr (assoc 8 (entget #pmen1))));��w
						(if (and #loop (= (substr #layer 1 4) "Z_01")) ;���ʉ�w
							(progn
							  (setq #pt$ (GetLWPolyLinePt #pmen1))     ; PMEN1 �B���̈�_������ׂėݐς�����
								(setq #ptALL$ (append #ptALL$ #pt$))
								(setq #loop nil)
							)
						);_if
					);foreach
				)
      );_if
      (setq #i (1+ #i))
    );while
	);_if

	(setq #XMIN 999999)
	(setq #YMIN 999999)
	(setq #XMAX -999999)
	(setq #YMAX -999999)
	(foreach #pt #ptALL$
		(setq #XX (nth 0 #pt))
		(setq #YY (nth 1 #pt))
		(if (<= #XX #XMIN)(setq #XMIN #XX))
		(if (>= #XX #XMAX)(setq #XMAX #XX))
		(if (<= #YY #YMIN)(setq #YMIN #YY))
		(if (>= #YY #YMAX)(setq #YMAX #YY))
	)
	(setq #ptRET$ (list (list #XMIN #YMAX)(list #XMAX #YMAX)(list #XMAX #YMIN)(list #XMIN #YMIN) ))
	#ptRET$
);PKGetCounterGaikeiPT


;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_StartLayout
;;; <�����T�v>  : �L�b�`��������ڲ��Ă���
;;; <�߂�l>    :
;;; <�쐬>      : 2000.1.19�C��KPCAD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PK_StartLayout (
  &family$$
  /
  #EN$ #I #SS #VIEWEN #QRY$ #SINA_TYPE
  #DDD #LR #P1 #P2 #P3 #P4 #PE #PS #PT$ #SS_P_HOOD #WT #WWW #XD_P_HOOD$ ;2010/11/10 YM ADD
  #IP_HOOD_DIST #PP_HOOD_DIST ;2010/11/10 YM ADD
  )
  (WebOutLog "���݂�����ڲ��Ă��܂�(PK_StartLayout)")

  (WebDefErrFunc) ; �װ�֐���`(02/09/11 YM �֐���)
  (WebOutLog "�װ�֐� SKAutoError2 ���`���܂���(PK_StartLayout)")

  (setq CG_PROGMSG "�����l�̎擾��")

  (if (or (= CG_AUTOMODE 2)(= CG_AUTOMODE 3))
    (progn ; WEB��CAD���ް&LOCAL�[��
      nil
;;;     ; �V��̨װ,��������
;;;     (WEB_SetFilPanelCode) ; Web��CAD���ްӰ��
      (WebOutLog "CAD���ް������}�͸�۰��ٕϐ��̾�Ă����Ȃ�(PK_StartLayout)")
    )
    (progn
      ;�O���[�o���ϐ��̃Z�b�g
      (PKG_SetFamilyCode &family$$) ; <Pcsetfam.lsp>
      (SKChgView "2,-2,1")
      (command "_zoom" "e")
    )
  );_if

  ;//---------------------------------------------------------
  ;// �\�����ގ����z�u
  ;//    �{�������ŃL���r�l�b�g���̃��C�A�E�g���s��
  ;//---------------------------------------------------------
  (setq CG_PROGMSG "���ނ̎����W�J��")

  (WebOutLog "--- (PKC_ModelLayout)���Ă� ---")

  (PKC_ModelLayout)
  (command "_layer" "T" "*" "")

  (WebDefErrFunc) ; �װ�֐���`(02/09/11 YM �֐���)


  ;// �V��������
	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn ;2017/09/07 YM ADD
			nil
		)
		(progn
		  (WebOutLog "--- �V��������(PKW_WorkTop)���Ă� ---")
		  (setq #WT (PKW_WorkTop));2010/11/10 YM ADD WT�}�`��Ԃ�
		)
	);_if

	;2017/10/11 YM ADD-S �����̔z�u
  (if (= "N" (nth 18 CG_GLOBAL$));�������Ȃ��ł͂Ȃ��Ƃ�
    (progn
      ;2009/02/06 YM ADD
      (princ "�������Ȃ��̂��߁A������z�u���܂���ł���")
    )
    (progn ; �]��ۼޯ� [�吅���̔z�u]

			(FK_PosWTR_plan);            (nth 19
		)
	);_if


  (if (and (=  "B" (nth 18 CG_GLOBAL$)) ;����2���̂Ƃ�
           (/= "_" (nth 19 CG_GLOBAL$)));����2������
    (progn ; [����2���̔z�u]
			(FK_PosWTR_plan2);�򐅊�z�u (nth 22
		)
	);_if
	;2017/10/11 YM ADD-E �����̔z�u


  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;2010/11/10 YM ADD-S �V����ި �Ζ�̰�ޔz�u�ʒu�������I�ɋ��߂�
  ;�V�O�ʂ���Ȃ̂œV��}�܂Ŋm��ł��Ȃ�(0,0)�ɔz�u����̰�ނ𐳂����ړ�����

  ;I�^����P�^�t�[�h�z�u��� 
  ; �ꗥ�F40mm�i�V�O�ʂ���̋����j

  ;P�^����P�^�t�[�h�z�u��� 
  ; �ꗥ�F20mm�i�V�O�ʂ���̋����j

  (if (and CG_HOOD_FLG CG_P_HOOD_SYM)
    (progn ;P�^̰�ނ͂Ƃ肠�������_�z�u���Ă���
      ;P�^HOOD�ʒu�𐳂����ړ�����
      
      ;P�^��P�^̰�ޓV�O�ʂ���̋���
      (setq #PP_HOOD_DIST 20.0)
      ;I�^��P�^̰�ޓV�O�ʂ���̋���
;;;     (setq #IP_HOOD_DIST 40.0)
      (setq #IP_HOOD_DIST 20.0)

			
			(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
				(progn ;2017/09/07 YM ADD
					(setq #pt$ (PKGetCounterGaikeiPT))
				)
				(progn
		      ;�V�O�`�_����擾
		      (setq #pt$ (GetWT_MigiShitaPt #WT))
				)
			);_if

      (setq #p1 (nth 0 #pt$));����
      (setq #p2 (nth 1 #pt$));�E��
      (setq #p3 (nth 2 #pt$));�E��
      (setq #p4 (nth 3 #pt$));����

			;2017/07/04 YM ADD L�^�ɕK�v
      (setq #p5 (nth 4 #pt$))
      (setq #p6 (nth 5 #pt$))

      ;P�^̰�ނ̊�_�ʒu
      (setq #PS (cdr (assoc 10 (entget CG_P_HOOD_SYM))))
      (setq #PE nil)
       
      ;P�^̰�ނ̻��� CG_P_HOOD_SYM(���]������ω�����)
      (setq #xd_P_HOOD$ (CFGetXData CG_P_HOOD_SYM "G_SYM"))
      (setq #WWW (nth 3 #xd_P_HOOD$));W
      (setq #DDD (nth 4 #xd_P_HOOD$));D

      ;P�^̰�ޑS�}�`
      (setq #ss_P_HOOD (CFGetSameGroupSS CG_P_HOOD_SYM))

      ;���E����
      (setq #LR (nth 11 CG_GLOBAL$))
      (cond
        ((= #LR "L");������

          (cond
            ((= CG_HOOD_FLG "PI")
              ;�ް����ނƓ���ײ݂Ɉړ�
              (setq #PE
                (list
                  (- (nth 0 #p3) #WWW)
                  0.0
                  (nth 2 #PS) ;̰�ނ�Z���W
                )
              )
            )
            ((= CG_HOOD_FLG "PP")
              ;WT�E��(��O)����Y������20mm�{(̰�ސ��@W�l��)�̈ʒu�Ɉړ�
              (setq #PE
                (list
                  (nth 0 #p3)
                  (+ (nth 1 #p3) #PP_HOOD_DIST #WWW)
                  (nth 2 #PS) ;̰�ނ�Z���W
                )
              )
            )
            ((= CG_HOOD_FLG "IP")
              ;WT�E��(��O)����Y������40mm�{(̰�ސ��@W�l��)�̈ʒu�Ɉړ�
              (setq #PE
                (list
                  (nth 0 #p3)
                  (+ (nth 1 #p3) #IP_HOOD_DIST #WWW)
                  (nth 2 #PS) ;̰�ނ�Z���W
                )
              )
            )

						;2017/07/05 YM ADD-S
;   -----------------+ p1
;                    |
;                    |
;          --+       |
;            |       |
;            |       |
;            |       |
;            |       |
;         p3 +-------+ p2

            ((= CG_HOOD_FLG "LP") ;L�^
              ;WT�E��(��O)����Y������40mm�{(̰�ސ��@W�l��)�̈ʒu�Ɉړ�
              (setq #PE
                (list
                  (nth 0 #p2)
                  (nth 1 #p2)
                  (nth 2 #PS) ;̰�ނ�Z���W
                )
              )
            )
						;2017/07/05 YM ADD-E

          );_cond

        )
        ((= #LR "R");�E����

          (cond
            ((= CG_HOOD_FLG "PI")
              ;�ް����ނƓ���ײ݂Ɉړ�
              (setq #PE
                (list
                  (nth 0 #p4)
                  0.0
                  (nth 2 #PS) ;̰�ނ�Z���W
                )
              )
            )
            ((= CG_HOOD_FLG "PP")
              ;WT����(��O)����Y������20mm�̈ʒu�Ɉړ�
              (setq #PE
                (list
                  (nth 0 #p4)
                  (+ (nth 1 #p4) #PP_HOOD_DIST)
                  (nth 2 #PS) ;̰�ނ�Z���W
                )
              )
            )
            ((= CG_HOOD_FLG "IP")
              ;WT����(��O)����Y������40mm�̈ʒu�Ɉړ�
              (setq #PE
                (list
                  (nth 0 #p4)
                  (+ (nth 1 #p4) #IP_HOOD_DIST)
                  (nth 2 #PS) ;̰�ނ�Z���W
                )
              )
            )

						;2017/07/05 YM ADD-S
;            +-----------------+ p1
;            |                 |
;            |                 |
;            |       +---------+ p2
;            |       |
;            |       |
;            |       |
;           @+-------+
;          p5        p4

            ((= CG_HOOD_FLG "LP") ;L�^
              ;WT�E��(��O)����Y������40mm�{(̰�ސ��@W�l��)�̈ʒu�Ɉړ�
              (setq #PE
                (list
                  (nth 0 #p5)
                  (nth 1 #p5)
                  (nth 2 #PS) ;̰�ނ�Z���W
                )
              )
            )

						;2017/07/05 YM ADD-E

          );_cond

        )
      );_cond


      (if #PE
				(progn
        	(command "_move" #ss_P_HOOD "" #PS #PE)
					;2014/10/21 YM ADD �ړ������̂�Xdata���X�V
					(setq #xdLSYM$ (CFGetXData CG_P_HOOD_SYM "G_LSYM"))
					(CFSetXData CG_P_HOOD_SYM "G_LSYM"
						(CFModList #xdLSYM$
							(list
								(list 1 #PE)
							)
						)
					)
					;2014/10/21 YM ADD �ړ������̂�Xdata���X�V
				)
      );_if


    )
  );_if

;;; (setq CG_HOOD_FLG nil) ;��̈�̎����쐬���׸ނ��K�v 2010/11/18 YM DEL
  (setq CG_P_HOOD_SYM nil)
  ;2010/11/10 YM ADD-E �V����ި
  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


  
  ;// �V��̨װ�̍쐬
  (if (and (/= (nth 46 CG_GLOBAL$) "N")(/= (nth 46 CG_GLOBAL$) "X"));�V��̨װ��t����
    (progn
      (WebOutLog "--- �V��̨װ�̍쐬(PKW_UpperFiller)���Ă� ---")
      ;2009/11/21 YM ADD ���݂͑O����
      (setq SKW_FILLER_LSIDE 0)
      (setq SKW_FILLER_RSIDE 0)
      (setq SKW_FILLER_BSIDE 0)

      (PKW_UpperFiller);���ݓV��̨װ="A"�̂�
    )
  );_if



  ;2011/03/25 YM ADD-S OP�u���̎d�g�݂𓱓�
  ;����"GO"=�����A���o���Ư�ܺ�݂̔z�u�L���A"STOP"=�����A���o���Ư�ܺ�݂̔z�u���� ��ǉ�
  (KP_ChgCab)  ;�Vۼޯ� ���i���ނɈˑ����Ȃ�
  (WebOutLog "--- (PK_StartLayout)����o�� ---")

  (princ)
);PK_StartLayout


;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_ChgCab
;;; <�����T�v>  : �yOP�u�����[�z�Vۼޯ�
;;; <�߂�l>    :
;;; <�쐬>      : 2011/03/25 YM ADD
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun KP_ChgCab  (
  /
  #EN #I #INSEN #INSHIN #INSLR #INSPOINT #INSRAD #J #JOKEN #LST$ #N #OPQRY$ #QRY$
  #QRYJOKEN$$ #QRYZU$ #RECNO #SKK #SQL$ #SS #SYM #WIDE #XD$ #XD$1 #XD_NEW$
#sRad ; 2011/04/06 YM ADD
  )


  ;[OP�u�����[����]�̑S����
  (setq #qryJOKEN$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "OP�u������")))

  ;CAD�}�ʏ�̑S�}�`������
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
    
  (if (/= #ss nil)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #sql$ nil #qry$ nil #lst$ nil)
        (setq #en (ssname #ss #i))
        ;// �g���f�[�^���擾
        (setq #xd$ (CFGetXData #en "G_LSYM"))
        ;// ���i�R�[�h
        (setq #SKK (nth 9 #xd$))
        (setq #recno (nth 11 #xd$))
      
        (setq #xd$1 (CFGetXData #en "G_SYM"))
        (setq #Wide     (nth 3 #xd$1))
        (setq #InsEN    #en)            ;�L���r�l�b�g�}�`
        (setq #InsPoint (nth 1 #xd$))   ;�L���r�l�b�g�}���N�_
        (setq #InsRad   (nth 2 #xd$))   ;�L���r�l�b�g�}���p�x
        (setq #InsHin   (nth 5 #xd$))   ;�L���r�l�b�g�i��
        (setq #InsLR    (nth 6 #xd$))   ;�L���r�l�b�gLR�敪

        ;�e��������݂Ō���
        (setq #j 1)
        (foreach #qryJOKEN$ #qryJOKEN$$


          (setq #sql$
            (list
              (list "�Ώەi��"   #InsHin          'STR)
              (list "�Ώەi��LR" #InsLR           'STR)
            )
          )

          (setq #n 1)

          (repeat 7
            (setq #joken (nth #n #qryJOKEN$))

            (if (/= #joken "SK___")
              (progn ;���������݂���Βǉ����Ă���

;;;2016/04/18 YM MOD-S
(setq #tokusei (nth (atoi (substr #joken 5 4)) CG_GLOBAL$));nil������邽��
(if (= #tokusei nil)(setq #tokusei ""))

                (setq #sql$
                  (append #sql$
                    (list
                      (list (strcat "����ID" (itoa #n))  #joken    'STR)
                      (list (strcat "�����l" (itoa #n))  #tokusei  'STR)
                    )
                  )
                )
              )
            );_if
            (setq #n (1+ #n))
          );repeat



          ;sql������[OP�u�����[]����
          (setq #OPqry$ (CFGetDBSQLRec CG_DBSESSION "OP�u��" #sql$))

          
          ;��������
          (if (= (length #OPqry$) 1)
            (progn  ;�������ʂ�1���̏ꍇ�̂ݏ����p��
              (setq #OPqry$ (car #OPqry$))
              (setq #lst$ (list (nth 3 #OPqry$) (nth 4 #OPqry$)))
            )
            (progn
              (setq #lst$ nil)
            )
          );_if


          ; �����ލ폜/���֕��ޔz�u����
          (if (/= #lst$ nil)
            (progn
              (SCY_DelParts #InsEN nil)

              (setq #sql$
                (list
                  (list "�i�Ԗ���" (car  #lst$) 'STR)
                  (list "LR�敪"   (cadr #lst$) 'STR)
                )
              );_setq

              (setq #qryZU$ (CFGetDBSQLHinbanTable "�i�Ԑ}�`" (car  #lst$) #sql$))

              (if (= (length #qryZU$) 1);�������ʂ�1���̏ꍇ�������s
                (progn
                  (setq #qryZU$ (car #qryZU$))

                  ;�z�u
                  ;2011/04/06 YM ADD
                  (setq #sRad (angtos #InsRad (getvar "AUNITS") CG_OUTAUPREC))
;-- 2011/12/22 A.Satoh Mod - S
;;;;;                  (setq #sym (TK_PosParts (nth 0 #qryZU$) (nth 1 #qryZU$) #InsPoint #sRad nil (GetBunruiAorD)));2011/07/04 YM ADD ���ޒǉ�
                  (setq #sym (TK_PosParts2 (nth 0 #qryZU$) (nth 1 #qryZU$) #InsPoint #sRad nil (GetBunruiAorD)));2011/07/04 YM ADD ���ޒǉ�
;-- 2011/12/22 A.Satoh Mod - E
                  
                  ;2010/06/28 YM ADD-S �������ޓ��֎���"G_LSYM"[12]�̓��e��������̂ň����o���ƯĂɕύX�ł��Ȃ�
                  ;[12]:�z�u���ԍ�    :�z�u���ԍ�(1�`)           (1070 . 19)
                  ;(setq #recno (nth 11 #xd$))�𔽉f����
                  ;// �g���f�[�^���擾
                  (setq #xd_new$ (CFGetXData #sym "G_LSYM"))
                  (setq #xd_new$
                    (CFModList #xd_new$
                      (list
                        (list 11 #recno)
                      )
                    )
                  )
                  (CFSetXData #sym "G_LSYM" #xd_new$)
                  ;2010/06/28 YM ADD-E �������ޓ��֎���"G_LSYM"[12]�̓��e��������̂ň����o���ƯĂɕύX�ł��Ȃ�


                  ;;�g���ް�"G_OPT"���
                  (KcSetG_OPT #sym)
                )
              );if
            )
          );_if

        
;-- 2011/12/22 A.Satoh Del - S
;          ;���\�t��
;          (if (and (/= #lst$ nil) (/= #sym nil))
;              (PCD_MakeViewAlignDoor (list #sym) 3 nil)
;          );_if
;-- 2011/12/22 A.Satoh Add - E


          (setq #j (1+ #j));��������݂�ٰ��
        );foreach


        (setq #i (1+ #i));���ނ�ٰ��
      );repeat
    )
  );if

  (princ "\nEND")
  (princ)
);KP_ChgCab


;;;<HOM>*************************************************************************
;;; <�֐���>    : GetBunruiAorD
;;; <�����T�v>  : ���݌������ɷ���"A" or ���["D"���擾����
;;; <�߂�l>    :"A" or "D"
;;; <�쐬>      : 2011/07/04 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun GetBunruiAorD ( / #BUNRUI)
  (setq #bunrui "")
  (cond
    ((= CG_PlanType "SK")
      (setq #bunrui "A")
    )
    ((= CG_PlanType "SD")
      (setq #bunrui "D")
    )
    (T
     (setq #bunrui "")
    )
  );_cond
  #bunrui
);GetBunruiAorD

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_GLASS_PARTISYON
;;; <�����T�v>  : ��׽�߰è��݂̔z�u
;;; <�߂�l>    :
;;; <�쐬>      : 2009/10/26 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKW_GLASS_PARTISYON (
  /
  #ANG #GLASS$$ #HNO #LR #XX #YY #ZZ #glass
  )
  ;2009/12/11 YM ADD nil�ŗ�����΍�
  (setq #glass (nth 44 CG_GLOBAL$))
  (if (= nil #glass)(setq #glass ""))
  
  ;[�K���X�p�e�B�V����]������
  (setq #GLASS$$
    (CFGetDBSQLRec CG_DBSESSION "�K���X�p�e�B�V����"
       (list
        (list "�L��"          #glass              'STR);��׽�߰è��݋L��
        (list "�V���N���Ԍ�"  (nth  4 CG_GLOBAL$) 'STR)
        (list "���s��"        (nth  7 CG_GLOBAL$) 'STR)
        (list "�V����"      (nth 31 CG_GLOBAL$) 'STR)
        (list "�V���N�L��"    (nth 17 CG_GLOBAL$) 'STR)
       )
    )
  )
  (if (and #GLASS$$ (= 1 (length #GLASS$$)) )
    (progn ;1��HIT����
      (setq #GLASS$$ (car #GLASS$$))
      (setq #HNO (nth  5 #GLASS$$));�i�Ԗ���
      (setq #LR  (nth  6 #GLASS$$));LR�敪
      (setq #XX  (nth  7 #GLASS$$))
      (setq #YY  (nth  8 #GLASS$$))
      (setq #ZZ  (nth  9 #GLASS$$))
      (setq #ANG (nth 10 #GLASS$$))
      ;�z�u
      (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
    )
    (progn
      nil ;�������Ȃ�
    )
  );_if
  (princ)
);PKW_GLASS_PARTISYON


;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_PutEndPanel
;;; <�����T�v>  : ���݌����������َ�t�� <���ݗp>
;;; <�߂�l>    :
;;; <�쐬>      : 2008/072/26 YM �֐���
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_PutEndPanel (
  /
  #ANG #BLK$ #DB_NAME1 #DB_NAME2 #HNO #HUKU_ID #LIST$$ #LR #PANEL_QRY$$ #QRY$
  #T$ #T$$ #TTT #XX #YY #ZZ #RECNO
#TOP_F ;2010/11/08 YM ADD
  )

;(nth 45 CG_GLOBAL$);��������

;;;X  -----
;;;N  ��t���Ȃ�
;;;A  �V���N���̂�
;;;B  �R�������̂�
;;;C  ������t��

  ;2008/09/24 YM MOD [�p�l���Ǘ�][�p�l���\��]ð��ٍ\���ύX �i�Ԃ̂ݎ擾�B�z�u�ʒu��PG�v�Z
  (if (or (= (nth 45 CG_GLOBAL$) "A")(= (nth 45 CG_GLOBAL$) "B")(= (nth 45 CG_GLOBAL$) "C"))
    (progn
      
      (setq #DB_NAME1 "�p�l���Ǘ�")
      (setq #DB_NAME2 "�p�l���\��")

      (setq #T$$ ; I�^,L�^�̂Ƃ�
        (CFGetDBSQLRec CG_DBSESSION "�p�l������"
          (list
            (list "���V���L��"     (nth 12 CG_GLOBAL$) 'STR)
            (list "���J���L��"     (nth 13 CG_GLOBAL$) 'STR)
          )
        )
      )
      (setq #T$ (DBCheck #T$$ "�w�p�l�����݁x" "KP_PutEndPanel"))
      (setq #TTT (nth 2 #T$));EP����


      ;2010/11/08 YM ADD-S
      ;�V����ި�Ή�į�ߏ������������
      ;CG_GLOBAL$=nil�łȂ��Ƃ��������
      (setq #TOP_F (GetTopFlg))
      ;2010/11/08 YM ADD-E

      
      (setq #LIST$$
        (list
    ;;;     (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR);2008/09/24 YM DEL
    ;;;     (list "�`��"               (nth  5 CG_GLOBAL$) 'STR);2008/09/24 YM DEL
    ;;;     (list "���i�^�C�v"         "6"                 'INT);2008/09/24 YM DEL
          (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
          (list "�V����"           (nth 31 CG_GLOBAL$) 'STR)
          (list "����"               #TTT                'STR)
          (list "�G���h�p�l��"       "A"                 'STR);2008/09/24 YM MOD
          (list "�݌ˍ���"           (nth 32 CG_GLOBAL$) 'STR)
          (list "�g�b�v����"         #TOP_F              'STR);2010/11/08 YM ADD
        )
      )
      (setq #qry$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME1 #LIST$$)
      )

      (setq #qry$ (DBCheck #qry$ "�w�p�l���Ǘ��x" "KP_PutEndPanel")) ; ��������WEB��۸ޏo��

      ; ID
      (setq #huku_id (nth 0 #qry$))

      ;�p�l���\��
      (setq #panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "ID"  #huku_id  'STR)
            (list "order by \"RECNO\"" nil  'ADDSTR)
          )
        )
      )

      (foreach #panel_qry$ #panel_qry$$
        (setq #RECNO (nth 1 #panel_qry$))  ;recno
        (setq #HNO   (nth 2 #panel_qry$))  ;�i�Ԗ���
        (setq #LR    (nth 3 #panel_qry$))  ;LR�敪

        (if (equal #RECNO 1.0 0.001)
          (progn ;����

;;;	;2017/01/10 YM ADD-S �ŏ��ɔz�u���镔�ނ�X���W��ۑ�
;;;	(setq CG_FIRST_BASE_X (nth 9 (car #qry1$$)))
;;;	(setq CG_FIRST_WALL_X (nth 9 (car #qry2$$)))
;;;	;2017/01/10 YM ADD-E �ŏ��ɔz�u���镔�ނ�X���W��ۑ�

            (cond
              ((= (nth 45 CG_GLOBAL$) "A")
                ;�ݸ��(I�^,L�^)

								;2017/01/10 YM ADD-S �ŏ��ɔz�u���镔�ނ�X���W
;;;								(setq #XX  CG_FIRST_BASE_X)
;;;                (setq #XX  (+ #XX (- (atoi (substr #TTT 2 3))) ))
								;2017/01/10 YM ADD-E �ŏ��ɔz�u���镔�ނ�X���W
                (setq #XX  (- (atoi (substr #TTT 2 3))));�]���ǂ���

                (setq #YY  0)
                (setq #ZZ  0)
                (setq #ANG 0.0)
                ;�z�u
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
              )
              ((= (nth 45 CG_GLOBAL$) "B")
                (if (= "I" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;��ۑ�(I�^)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (setq #YY  0)
                    (setq #ZZ  0)
                    (setq #ANG 0.0)
                  )
                );_if

                (if (= "L" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;��ۑ�(L�^)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (cond
                      ((= (nth  5 CG_GLOBAL$) "L16")
                        (setq #YY -1650)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L18")
                        (setq #YY -1800)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L19")
                        (setq #YY -1950)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L21")
                        (setq #YY -2100)
                      )
                    );_cond
                    (setq #ZZ  0)
;;;                   (setq #ANG (- (* 0.5 PI)))
                    (setq #ANG -90)
                  )
                );_if

                ;�z�u
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
              )
              ((= (nth 45 CG_GLOBAL$) "C")
                ;���� "A"��"B"�̏����𗼕��s��

                ;�ݸ��(I�^,L�^)
                (setq #XX  (- (atoi (substr #TTT 2 3))))
                (setq #YY  0)
                (setq #ZZ  0)
                (setq #ANG 0.0)
                ;�z�u
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")


                (if (= "I" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;��ۑ�(I�^)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (setq #YY  0)
                    (setq #ZZ  0)
                    (setq #ANG 0.0)
                  )
                );_if

                (if (= "L" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;��ۑ�(L�^)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (cond
                      ((= (nth  5 CG_GLOBAL$) "L16")
                        (setq #YY -1650)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L18")
                        (setq #YY -1800)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L19")
                        (setq #YY -1950)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L21")
                        (setq #YY -2100)
                      )
                    );_cond
                    (setq #ZZ  0)
;;;                   (setq #ANG (- (* 0.5 PI)))
                    (setq #ANG -90)
                  )
                );_if

                ;�z�u
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")

              )
            )
          ) ;����
        );_if


        (if (equal #RECNO 21.0 0.001)
          (progn ;�݌�

;;;	;2017/01/10 YM ADD-S �ŏ��ɔz�u���镔�ނ�X���W��ۑ�
;;;	(setq CG_FIRST_BASE_X (nth 9 (car #qry1$$)))
;;;	(setq CG_FIRST_WALL_X (nth 9 (car #qry2$$)))
;;;	;2017/01/10 YM ADD-E �ŏ��ɔz�u���镔�ނ�X���W��ۑ�

            (cond
              ((= (nth 45 CG_GLOBAL$) "A")
                ;�ݸ��(I�^,L�^)

								;2017/01/10 YM MOD-S �ŏ��ɔz�u���镔�ނ�X���W
								(setq #XX  CG_FIRST_WALL_X)
                (setq #XX  (+ #XX (- (atoi (substr #TTT 2 3))) ))
								;2017/01/10 YM MOD-E �ŏ��ɔz�u���镔�ނ�X���W

                (setq #YY  0)
                (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
                (setq #ANG 0.0)
                ;�z�u
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
              )
              ((= (nth 45 CG_GLOBAL$) "B")
                (if (= "I" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;��ۑ�(I�^)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (setq #YY  0)
                    (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
                    (setq #ANG 0.0)
                  )
                );_if

                (if (= "L" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;��ۑ�(L�^)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (cond
                      ((= (nth  5 CG_GLOBAL$) "L16")
                        (setq #YY -1650)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L18")
                        (setq #YY -1800)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L19")
                        (setq #YY -1950)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L21")
                        (setq #YY -2100)
                      )
                    );_cond
                    (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
;;;                   (setq #ANG (- (* 0.5 PI)))
                    (setq #ANG -90)
                  )
                );_if

                ;�z�u
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
              )
              ((= (nth 45 CG_GLOBAL$) "C")
                ;���� "A"��"B"�̏����𗼕��s��

                ;�ݸ��(I�^,L�^)
                (setq #XX  (- (atoi (substr #TTT 2 3))))
                (setq #YY  0)
                (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
                (setq #ANG 0.0)
                ;�z�u
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")


                (if (= "I" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;��ۑ�(I�^)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (setq #YY  0)
                    (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
                    (setq #ANG 0.0)
                  )
                );_if

                (if (= "L" (substr (nth  5 CG_GLOBAL$) 1 1))
                  (progn
                    ;��ۑ�(L�^)
                    (setq #XX  (* 10 (atoi (substr (nth  4 CG_GLOBAL$) 2 10))))
                    (cond
                      ((= (nth  5 CG_GLOBAL$) "L16")
                        (setq #YY -1650)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L18")
                        (setq #YY -1800)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L19")
                        (setq #YY -1950)
                      )
                      ((= (nth  5 CG_GLOBAL$) "L21")
                        (setq #YY -2100)
                      )
                    );_cond

                    (setq #ZZ  CG_UpCabHeight);2013/11/30 YM ADD
;;;                   (setq #ANG (- (* 0.5 PI)))
                    (setq #ANG -90)
                  )
                );_if

                ;�z�u
                (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")

              )
            )
          ) ;�݌�
        );_if


      );foreach

  
    )
  );_if
  (princ)
);KP_PutEndPanel

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_PutEndPanel_FK
;;; <�����T�v>  : ���݌����������َ�t�� <�ڰѷ��ݗp>
;;; <�߂�l>    :
;;; <�쐬>      : 2017/10/02 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_PutEndPanel_FK (
  /
  #ANG #BLK$ #DB_NAME1 #DB_NAME2 #HNO #HUKU_ID #LIST$$ #LR #PANEL_QRY$$ #QRY$
  #T$ #T$$ #TTT #XX #YY #ZZ #RECNO
#TOP_F ;2010/11/08 YM ADD
  )

;(nth 45 CG_GLOBAL$);��������

;;;X  -----
;;;N  ��t���Ȃ�
;;;A  �V���N���̂�
;;;B  �R�������̂�
;;;C  ������t��

  ;2008/09/24 YM MOD [�p�l���Ǘ�][�p�l���\��]ð��ٍ\���ύX �i�Ԃ̂ݎ擾�B�z�u�ʒu��PG�v�Z
  (if (or (= (nth 45 CG_GLOBAL$) "A")(= (nth 45 CG_GLOBAL$) "B")(= (nth 45 CG_GLOBAL$) "C"))
    (progn
      
      (setq #DB_NAME1 "�p�l���Ǘ�FK")
      (setq #DB_NAME2 "�p�l���\��FK")

      (setq #LIST$$
        (list
          (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
          (list "�V����"           (nth 31 CG_GLOBAL$) 'STR)
          (list "�G���h�p�l��"       "A"                 'STR)
        )
      )
      (setq #qry$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME1 #LIST$$)
      )

      (setq #qry$ (DBCheck #qry$ "�w�p�l���Ǘ�FK�x" "KP_PutEndPanel")) ; ��������WEB��۸ޏo��

      ; ID
      (setq #huku_id (nth 0 #qry$))

      ;�p�l���\��
      (setq #panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "ID"  #huku_id  'STR)
            (list "order by \"RECNO\"" nil  'ADDSTR)
          )
        )
      )

      (foreach #panel_qry$ #panel_qry$$
        (setq #RECNO (nth 1 #panel_qry$))  ;recno
        (setq #HNO   (nth 2 #panel_qry$))  ;�i�Ԗ���
        (setq #LR    (nth 3 #panel_qry$))  ;LR�敪
        (setq #XX    (nth 4 #panel_qry$))
        (setq #YY    (nth 5 #panel_qry$))
        (setq #ZZ    (nth 6 #panel_qry$))
        (setq #ANG   (nth 7 #panel_qry$))
        ;�z�u
        (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A") ;G_OPT�����܂�
      );foreach
    )
  );_if
  (princ)
);KP_PutEndPanel_FK

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetTopFlg
;;; <�����T�v>  : [į�ߏ�������]�������ʂ�Ԃ�
;;; <�߂�l>    : "Y" or "N"
;;; <�쐬>      : 2010/11/08 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun GetTopFlg (
  /
  #TOP_F #OK1 #QRY$ #QRY$$
  )
  ;������
  (setq #TOP_F "N");į�ߏ����łȂ�

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION "�g�b�v��������"
       (list
         (list "�ގ��L��"   (nth 16 CG_GLOBAL$) 'STR)
         (list "�V���N�L��" (nth 17 CG_GLOBAL$) 'STR)
         (list "�`��"       (nth  5 CG_GLOBAL$) 'STR)
       )
     )
  )

  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #qry$ (car #qry$$))
      ;1��HIT�����ꍇ�A�Ԍ��𔻒肷��
      (setq #Ok1 nil)
      (foreach #dbVal (strparse (nth  4 #qry$) ",")
        (if (= (nth  4 CG_GLOBAL$) #dbVal) (setq #Ok1 T));�Ԍ�����v�����ꍇ
      )
      ;�Ԍ�����v���Ȃ��Ƃ�"ALL"�Ȃ�^
      (if (= "ALL" (nth 4 #qry$)) (setq #Ok1 T))
      (if #Ok1 (setq #TOP_F "Y"))
    )
    ;else
    nil ;ں��ނ����݂��Ȃ���į�ߏ����ł͂Ȃ��Ƃ݂Ȃ�
  );_if
  #TOP_F
);GetTopFlg

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_PutEndPanel_D
;;; <�����T�v>  : ���݌����������َ�t�� <���[�p>
;;; <�߂�l>    :
;;; <�쐬>      : 2008/072/26 YM �֐���
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_PutEndPanel_D (
  /
  #T$ #T$$ #TTT
  )

;(nth 71 CG_GLOBAL$);��������

;;;N  ��t���Ȃ�
;;;L  �����̂�
;;;R  �E���̂�
;;;B  ������t��

  (setq #T$$ ; ���[�p
    (CFGetDBSQLRec CG_DBSESSION "�p�l������"
      (list
        (list "���V���L��"     (nth 62 CG_GLOBAL$) 'STR)
        (list "���J���L��"     (nth 63 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #T$ (DBCheck #T$$ "�w�p�l�����݁x" "KP_PutEndPanel_D"))
  (setq #TTT (nth 2 #T$));EP����

  (cond
    ((= (nth 71 CG_GLOBAL$) "L")
      ;2009/10/07 YM ADD-S ���� PLAN56 �Ŕ��f
      (cond
        ((= (nth 56 CG_GLOBAL$) "N");����Ȃ�
          (PutEP_D_sub #TTT "L");���̂܂�
        )
        ((= (nth 56 CG_GLOBAL$) "L");����L
          (PutEP_D_sub #TTT "L");���̂܂�
        )
        ((= (nth 56 CG_GLOBAL$) "R");����R
          (PutEP_D_sub #TTT "R");��Ŕ��]����̂ŋt�]���Ă���
        )
        (T
          (PutEP_D_sub #TTT "L");���̂܂�
        )
      );_cond
      ;2009/10/07 YM ADD-E ���� PLAN56 �Ŕ��f
    )
    ((= (nth 71 CG_GLOBAL$) "R")
      ;2009/10/07 YM ADD-S ���� PLAN56 �Ŕ��f
      (cond
        ((= (nth 56 CG_GLOBAL$) "N");����Ȃ�
          (PutEP_D_sub #TTT "R");���̂܂�
        )
        ((= (nth 56 CG_GLOBAL$) "L");����L
          (PutEP_D_sub #TTT "R");���̂܂�
        )
        ((= (nth 56 CG_GLOBAL$) "R");����R
          (PutEP_D_sub #TTT "L");��Ŕ��]����̂ŋt�]���Ă���
        )
        (T
          (PutEP_D_sub #TTT "R");���̂܂�
        )
      );_cond
      ;2009/10/07 YM ADD-E ���� PLAN56 �Ŕ��f
      
    )
    ((= (nth 71 CG_GLOBAL$) "B")
      (PutEP_D_sub #TTT "L")
      (PutEP_D_sub #TTT "R")
    )
  );_cond

  (princ)
);KP_PutEndPanel_D


;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_PutEndPanel_D_EXTEND
;;; <�����T�v>  : ���݌����������َ�t�� <���[�g��SDB�p>
;;; <�߂�l>    :
;;; <�쐬>      : 2009/11/23 YM �֐���
;;; <���l>      : ����̏ꍇ�A�e���݂̏I���(�E�[)��EP��z�u����
;;;*************************************************************************>MOH<
(defun KP_PutEndPanel_D_EXTEND (
  /
  #T$ #T$$ #TTT
  )
;(nth 71 CG_GLOBAL$);��������
;;;N  ����
;;;TA3  İ����� D340mm
;;;TA4  İ����� D440mm
;;;TA5  İ����� D590mm
;;;EP ��������

;;;PLAN60
;;;LL ���==>���ݒu
;;;RR �E�==>�E�ݒu

  (setq #T$$ ; ���[�p
    (CFGetDBSQLRec CG_DBSESSION "�p�l������"
      (list
        (list "���V���L��"     (nth 62 CG_GLOBAL$) 'STR)
        (list "���J���L��"     (nth 63 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #T$ (DBCheck #T$$ "�w�p�l�����݁x" "KP_PutEndPanel_D"))
  (setq #TTT (nth 2 #T$));EP����
  (setq CG_EP_THICKNESS (atof (substr #TTT 2 3)));EP����(��۰��ٕϐ�)

  (cond
    ((= (nth 60 CG_GLOBAL$) "LL");���
      (PutEP_D_sub_EXTEND CG_D_EXTEND_KAI #TTT "R")
    )
    ((= (nth 60 CG_GLOBAL$) "RR");�E�
      (PutEP_D_sub_EXTEND CG_D_EXTEND_KAI #TTT "L")
    )
    (T
      (PutEP_D_sub_EXTEND CG_D_EXTEND_KAI #TTT "R")
    )
  );_cond

  (princ)
);KP_PutEndPanel_D_EXTEND

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_PutEndPanel_D_EXTEND_START
;;; <�����T�v>  : ���݌����ŏI�������َ�t�� <���[�g��SDB�p>
;;; <�߂�l>    :
;;; <�쐬>      : 2009/11/23 YM �֐���
;;; <���l>      : ����̏ꍇ�A�e���݂̏I���(�E�[)��EP��z�u����
;;;*************************************************************************>MOH<
(defun KP_PutEndPanel_D_EXTEND_START (
  /
  #T$ #T$$ #TTT
  )
  (setq #T$$ ; ���[�p
    (CFGetDBSQLRec CG_DBSESSION "�p�l������"
      (list
        (list "���V���L��"     (nth 62 CG_GLOBAL$) 'STR)
        (list "���J���L��"     (nth 63 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #T$ (DBCheck #T$$ "�w�p�l�����݁x" "KP_PutEndPanel_D"))
  (setq #TTT (nth 2 #T$));EP����

  (cond
    ((= (nth 60 CG_GLOBAL$) "LL");���
      (PutEP_D_sub_EXTEND_START #TTT "L");���������Ⴄ
    )
    ((= (nth 60 CG_GLOBAL$) "RR");�E�
      (PutEP_D_sub_EXTEND_START #TTT "R");���������Ⴄ
    )
    (T
      (PutEP_D_sub_EXTEND_START #TTT "L")
    )
  );_cond

  (princ)
);KP_PutEndPanel_D_EXTEND_START

;<HOM>*************************************************************************
; <�֐���>    : PutEP_D_sub
; <�����T�v>  : ���ق�z�u����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 03/05/12 YM
; <���l>      :
;*************************************************************************>MOH<
(defun PutEP_D_sub (
  &TTT ;EP����
  &side
  /
  #ANG #HNO #HUKU_ID #LIST$$ #LR #PANEL_QRY$$ #QRY$ #SIDE #TTT #XX #YY #ZZ
  )
  (setq #TTT   &TTT);EP����
  (setq #side &side);EP�z�u��

  (setq #LIST$$
    (list
      (list "���s��"         (nth 53 CG_GLOBAL$) 'STR)
      (list "�^�C�v"         (nth 54 CG_GLOBAL$) 'STR)
      (list "���[�Ԍ�"       (nth 55 CG_GLOBAL$) 'STR)
      (list "���i�^�C�v"     "6"                 'INT)
      (list "����"           #TTT                'STR)
      (list "�G���h�p�l��"   #side               'STR)

    )
  )
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "�p�l���Ǘ�D" #LIST$$)
  )
  (setq #qry$ (DBCheck #qry$ "�w�p�l���Ǘ�D�x" "KP_PutEndPanel")) ; ��������WEB��۸ޏo��

  ; ID
  (setq #huku_id (nth 0 #qry$))

  ;�p�l���\��
  (setq #panel_qry$$
    (CFGetDBSQLRec CG_DBSESSION "�p�l���\��"
      (list
        (list "ID"  #huku_id  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  (foreach #panel_qry$ #panel_qry$$
    (setq #HNO (nth 2 #panel_qry$))  ;�i�Ԗ���
    (setq #LR  (nth 3 #panel_qry$))  ;LR�敪
    (setq #XX  (nth 4 #panel_qry$))
    (setq #YY  (nth 5 #panel_qry$))
    (setq #ZZ  (nth 6 #panel_qry$))
    (setq #ANG (nth 7 #panel_qry$))
    ;�z�u
    (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "D")
  )
  (princ)
);PutEP_D_sub


;<HOM>*************************************************************************
; <�֐���>    : PutEP_D_sub_EXTEND
; <�����T�v>  : ���ق�z�u����(���[�g��)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2009/11/23 YM
; <���l>      :
;*************************************************************************>MOH<
(defun PutEP_D_sub_EXTEND (
  &kai  ;���
  &TTT  ;EP����
  &side ;�z�u�� "L"=�� "R"=�E
  /
  #ANG #HNO #LOW_ID #LOW_PANEL_QRY$$ #LR #MAGU #PANEL_QRY$$ #QRY$ #QRY$$ #TTT
  #UPPER_ID #UPPER_PANEL_QRY$$ #XX #YY #ZZ
  )
  (setq #panel_qry$$ nil)
  (setq #LOW_panel_qry$$ nil)
  (setq #UPPER_panel_qry$$ nil)

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION "�p�l���Ǘ�EX"
      (list
        (list "�ϊ��l" (nth (+ (* 100 &kai) 71) CG_GLOBAL$) 'STR)
      )
    )
  )
  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #LOW_id   (nth 2 (car #qry$$)));����EP�L��
      (setq #UPPER_id (nth 3 (car #qry$$)));���EP�L��
      ;�p�l���\��
      (setq #LOW_panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION "�p�l���\��EX"
          (list
            (list "EP�L��"  #LOW_id  'STR)
            (list "EP����"  &TTT     'STR)
          )
        )
      )
      (setq #UPPER_panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION "�p�l���\��EX"
          (list
            (list "EP�L��"  #UPPER_id  'STR)
            (list "EP����"  &TTT     'STR)
          )
        )
      )
    )
  );_if

  (setq #panel_qry$$ (append #LOW_panel_qry$$ #UPPER_panel_qry$$))

  (cond
    ((= &side "L") ;���z�u
      (setq #TTT (atof (substr &TTT 2 3)))
      (setq #XX (- #TTT))
    )
    ((= &side "R") ;�E�z�u
      (setq #magu (nth (+ (* 100 &kai) 55) CG_GLOBAL$))
      (setq #qry$
        (CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
          (list (list "�Ԍ��L��" #magu 'STR))
        )
      )
      (setq #XX (nth 2 (car #qry$)))
    )
    (T
      (setq #TTT (atof (substr &TTT 2 3)))
      (setq #XX (- #TTT))
    )
  );_cond

  (foreach #panel_qry$ #panel_qry$$
    (setq #HNO   (nth 3 #panel_qry$))  ;�i�Ԗ���
    (setq #LR    (nth 4 #panel_qry$))  ;LR�敪
    (setq #ZZ    (nth 5 #panel_qry$))  ;Z���W
    ;Y���W
    (setq #YY 0.0)
    ;�z�u�p�x
    (setq #ANG 0.0)
    ;�z�u����
    (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "D")
  )
  (princ)
);PutEP_D_sub_EXTEND

;<HOM>*************************************************************************
; <�֐���>    : PutEP_D_sub_EXTEND_START
; <�����T�v>  : ���ق�z�u����(���[�g��)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2009/11/30 YM
; <���l>      : �ŏ��̊J�n��������
;*************************************************************************>MOH<
(defun PutEP_D_sub_EXTEND_START (
  &TTT  ;EP����
  &side ;�z�u�� "L"=�� "R"=�E
  /
  #ANG #HNO #LOW_ID #LOW_PANEL_QRY$$ #LR #MAGU #PANEL_QRY$$ #QRY$ #QRY$$ #TTT
  #UPPER_ID #UPPER_PANEL_QRY$$ #XX #YY #ZZ
  )
  (setq #panel_qry$$ nil)
  (setq #LOW_panel_qry$$ nil)
  (setq #UPPER_panel_qry$$ nil)

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION "�p�l���Ǘ�EX"
      (list
        (list "�ϊ��l"   (nth 71 CG_GLOBAL$) 'STR)
      )
    )
  )
  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #LOW_id   (nth 2 (car #qry$$)));����EP�L��
      (setq #UPPER_id (nth 3 (car #qry$$)));���EP�L��
      ;�p�l���\��
      (setq #LOW_panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION "�p�l���\��EX"
          (list
            (list "EP�L��"  #LOW_id  'STR)
            (list "EP����"  &TTT     'STR)
          )
        )
      )
      (setq #UPPER_panel_qry$$
        (CFGetDBSQLRec CG_DBSESSION "�p�l���\��EX"
          (list
            (list "EP�L��"  #UPPER_id  'STR)
            (list "EP����"  &TTT     'STR)
          )
        )
      )
    )
  );_if

  (setq #panel_qry$$ (append #LOW_panel_qry$$ #UPPER_panel_qry$$))

  (cond
    ((= &side "L") ;���z�u
      (setq #TTT (atof (substr &TTT 2 3)))
      (setq #XX (- #TTT))
    )
    ((= &side "R") ;�E�z�u
      (setq #magu (nth (+ (* 100 1) 55) CG_GLOBAL$))
      (setq #qry$
        (CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
          (list (list "�Ԍ��L��" #magu 'STR))
        )
      )
      (setq #XX (nth 2 (car #qry$)))
    )
    (T
      (setq #TTT (atof (substr &TTT 2 3)))
      (setq #XX (- #TTT))
    )
  );_cond

  (foreach #panel_qry$ #panel_qry$$
    (setq #HNO   (nth 3 #panel_qry$))  ;�i�Ԗ���
    (setq #LR    (nth 4 #panel_qry$))  ;LR�敪
    (setq #ZZ    (nth 5 #panel_qry$))  ;Z���W

    ;2011/05/21 YM MOD �݌ˉ�OPEN_BOX�̂Ƃ�Z=2150mm�ɕ␳����
    (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
      (if (<= 2000 #ZZ) ;���p
        (setq #ZZ CG_WallUnderOpenBoxHeight)
      );_if
    );_if

    ;Y���W
    (setq #YY 0.0)
    ;�z�u�p�x
    (setq #ANG 0.0)
    ;�z�u����
    (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "D")
  )
  (princ)
);PutEP_D_sub_EXTEND_START

;<HOM>*************************************************************************
; <�֐���>    : PD_StartLayout
; <�����T�v>  : �_�C�j���O������ڲ��Ă���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 03/05/12 YM
; <���l>      : WK_SDA�p
;*************************************************************************>MOH<
(defun PD_StartLayout (
  &family$$
  /

  )
  (WebOutLog "���݂�����ڲ��Ă��܂�(PD_StartLayout)")

  (WebDefErrFunc) ; �װ�֐���`
  (WebOutLog "�װ�֐� SKAutoError2 ���`���܂���(PD_StartLayout)")

  (WebOutLog "++++++++++++++++++++++++++++")
  (WebOutLog "*error*�֐�")
  (WebOutLog *error*)
  (WebOutLog "++++++++++++++++++++++++++++")

  (if (or (= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/08/01 YM ADD ; 02/08/05 YM ADD
    (progn ; WEB��CAD���ް&LOCAL�[��
      ; �V��̨װ,��������
;;; 2008/09/11YM@DEL      (WEB_SetFilPanelCode)  ; Web��CAD���ްӰ��
      nil
    )
    (progn
      (SDG_SetFamilyCode &family$$)
      (SKChgView "2,-2,1") ; ���ޯ�ޗp���_�쓌����
      (command "_zoom" "e")
    )
  );_if


  ;//---------------------------------------------------------
  ;// �\�����ގ����z�u
  ;//    �{�������ŃL���r�l�b�g���̃��C�A�E�g���s��
  ;//---------------------------------------------------------
  (WebOutLog "���[���ނ������z�u���܂�(PDC_ModelLayout)")

  ;���[���݂̑}��
  (PDC_ModelLayout)
  (command "_layer" "T" "*" "")

  (WebDefErrFunc) ; �װ�֐���`(02/09/11 YM �֐���)

  ;// �V��̨װ�̍쐬
  (if (and (/= (nth 72 CG_GLOBAL$) "N")(/= (nth 72 CG_GLOBAL$) "X"));�V��̨װ��t����
    (progn
      (WebOutLog "--- �V��̨װ�̍쐬(PKW_UpperFiller)���Ă� ---")
      ;2009/11/21 YM ADD ���[SDA�͑O����
      (setq SKW_FILLER_LSIDE 1)
      (setq SKW_FILLER_RSIDE 1)
      (setq SKW_FILLER_BSIDE 0)
      (PKW_UpperFiller);���ݓV��̨װ="A"�̂�
    )
  );_if

  (WebOutLog "--- (PD_StartLayout)����o�� ---")

  (princ)
);PD_StartLayout

;<HOM>*************************************************************************
; <�֐���>    : PD_StartLayout_EXTEND
; <�����T�v>  : �_�C�j���O������ڲ��Ă���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2009/11/18 YM
; <���l>      : ���[�g�� WK_SDB��pۼޯ��ő�5����ׂ�
;*************************************************************************>MOH<
(defun PD_StartLayout_EXTEND (
  &family$$
  /

  )
  (setq CG_EP_THICKNESS 0)     ;�������ٌ��ݏ�����
;;; (setq CG_COUNTER_INFO$$ nil) ;������z�u���(������ڑ��Ɏg�p)
  (setq CG_D_EXTEND_KAI nil)   ;��

  (princ "\n���[�g�������ڲ��Ă��܂�(PD_StartLayout_EXTEND)")
  (WebOutLog "���[�g�������ڲ��Ă��܂�(PD_StartLayout_EXTEND)")

  (WebDefErrFunc) ; �װ�֐���`
  (princ "\n�װ�֐� SKAutoError2 ���`���܂���(PD_StartLayout)")
  (WebOutLog "�װ�֐� SKAutoError2 ���`���܂���(PD_StartLayout)")

  (if (or (= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/08/01 YM ADD ; 02/08/05 YM ADD
    (progn ; WEB��CAD���ް&LOCAL�[��
      (princ "\nWEB��CAD���ް&LOCAL�[��")
    )
    (progn
      ;��۰��ٕϐ��ɒl���
      (SDG_SetFamilyCode &family$$)
      (SKChgView "2,-2,1") ; ���ޯ�ޗp���_�쓌����
      (command "_zoom" "e")
    )
  );_if


  ;//---------------------------------------------------------
  ;// �\�����ގ����z�u
  ;//    �{�������ŃL���r�l�b�g���̃��C�A�E�g���s��
  ;//---------------------------------------------------------
  (WebOutLog "���[���ނ������z�u���܂�(PDC_ModelLayout_EXTEND)")

  ;����������������������������������������������������������������������������������������������������
  ;���[���ɑ΂��A�\�����ޔz�u���������ٔz�u�����]�������V��̨װ�̍쐬���\����w�̐ݒ���s��
  ;����������������������������������������������������������������������������������������������������

  ;����dwg�̍폜
  (princ "\n����dwg�̍폜")
  (if (findfile (strcat CG_SYSPATH "plan.dwg"))
    (vl-file-delete (strcat CG_SYSPATH "plan.dwg"))
  );_if

  (foreach #i (list "1" "2" "3" "4" "5")
    (if (findfile (strcat CG_SYSPATH "plan" #i ".dwg"))
      (vl-file-delete (strcat CG_SYSPATH "plan" #i ".dwg"))
    );_if
  )

;���E� LL or RR
;;;(nth 60 CG_GLOBAL$)
;2�`5��ڊԌ�
;;;(nth (+ (* 100 #i) 55) CG_GLOBAL$)
;2�`5��ڗL��
;;;(nth (+ (* 100 #i) 1) CG_GLOBAL$)
;2�`5���EP�L��
;;;(nth (+ (* 100 #i) 71) CG_GLOBAL$)
;�ŏIEP�L��
;;;(nth 71 CG_GLOBAL$)

  ;�ŏI������߂�
  (princ "\n�ŏI������߂�")
  (setq CG_LAST 5);�ŏI��
  (foreach #i (list 5 4 3 2)
    (if (/= "Y" (nth (+ (* 100 #i) 1) CG_GLOBAL$))
      (progn ;"N"
        (setq CG_LAST (1- #i))
      )
    );_if
    (setq #i (1+ #i))
  );foreach

  ;�@�`�D�� �\���z�u,EP�z�u plan?.dwg�ɕۑ�
  (foreach #i (list 1 2 3 4 5)
    (setq CG_D_EXTEND_KAI #i);��۰��ٕϐ�(����ڂ��i�[)
    (if (= "Y" (nth (+ (* 100 #i) 1) CG_GLOBAL$))
      (progn
        (princ (strcat "\n(plan_clear)" (itoa #i)))
        (WebOutLog "(plan_clear)�O")
        (plan_clear)
        (WebOutLog "(plan_clear)��")
        (PDC_ModelLayout_EXTEND);���==>����EP�A�E�==>�E��EP
      )
    );_if
    (setq #i (1+ #i))
  );foreach

  ;�������o���� PC_LayoutPlanExec ���o�Ă��� plan.dwg�@�̖��O�ŕۑ�
  ;(command "_saveas" "" (strcat CG_SYSPATH "plan.dwg"))

  (WebOutLog "--- (PD_StartLayout)����o�� ---")
  (princ)
);PD_StartLayout_EXTEND

;;;<HOM>*************************************************************************
;;; <�֐���>    : plan_clear
;;; <�����T�v>  : �}�ʸر�(plan.dwg��)
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2009/11/21 YM ADD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun plan_clear (
  /
  #SSALL
  )
  (setvar "CLAYER" "0") ; ���݉�w"0"
  (WebOutLog "(C:ALP)�O")
  (C:ALP);�S��w�\��
  (WebOutLog "(C:ALP)��")
  (setq #ssALL (ssget "X")) ; �S�}�`
  (if (and #ssALL (< 0 (sslength #ssALL)))
    (command "_.erase" #ssALL "") ; �}�`�폜
  );_if
  ; �߰��
  (command "_purge" "A" "*" "N")
  (command "pdmode" "0")
  (princ)
);plan_clear

;<HOM>*************************************************************************
; <�֐���>    : WF_StartLayout
; <�����T�v>  : �V�X�e�����ʂ��������C�A�E�g����
; <�߂�l>    :
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun WF_StartLayout (
    &family$$
    /
    #ss #i #en$ #viewEn
  )
  ;// ̧�ذ�i�Ը�۰��ق̐ݒ�
  ;//
  (setq CG_PROGMSG "�����l�̎擾��")
;;;  (CFOutLog 1 nil (strcat "*** " CG_PROGMSG " ***"))
  (WFG_SetFamilyCode &family$$)

  ;// 1-1.�\�����ގ����z�u�i��{�j
  ;//
  ;//    �{�������ŷ���ȯē���ڲ��Ă��s��
  (setq CG_PROGMSG "���ނ̎����W�J��")
;;;  (CFOutLog 1 nil (strcat "*** " CG_PROGMSG " ***"))
  (WFC_ModelLayout)
  (command "_.layer" "T" "*" "")

  ;// �����̔z�u




  ;// �I�v�V�����̔z�u




  ;// �g�[���L���r�̔z�u



  (if (= CG_MKDOOR T)
    (progn
      (setq CG_PROGMSG "���ʂ̓\�t��")
;;;      (CFOutLog 1 nil (strcat "*** " CG_PROGMSG " ***"))

      ;// �����������ׁ̈A��w�t���[�Y����
      (command "_.layer" "F"  "Z_*"   "")
      (command "_.layer" "F"  "P*"    "")
      (command "_.layer" "OF" "N_B*"  "")
      (command "_.layer" "T"  "Z_00*" "")

      ;// ���ʂ̓\��t��
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (repeat (sslength #ss)
        (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode (ssname #ss #i) 1))
          (setq #en$ (cons (ssname #ss #i) #en$))
        )
        (setq #i (1+ #i))
      )
      (SCD_MakeViewAlignDoor #en$ 3 nil)
    )
  )
  (princ)
);WF_StartLayout

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_ChkUpperBaseSYM
;;; <�����T�v>  : �ް�����ِ}�`��n���āA��ɐ��i����"14?"�̼���ق������'T��Ԃ�
;;; <�߂�l>    : T or nil
;;; <�쐬>      : 00/08/14 YM
;;; <���l>      : vpoint '(0 0 1) ���K�v
;;;*************************************************************************>MOH<
(defun PK_ChkBaseSYM (
  &BaseSym
  /
  #ELM #HNDL #I #P1 #P2 #P3 #P4 #PT #PT$ #RET #SKK$ #SS
  )
  (setq #pt   (cdr (assoc 10 (entget &BaseSym)))) ; ����ٍ��W
  (setq #hndl (cdr (assoc  5 (entget &BaseSym)))) ; ����������
  (setq #ret nil)
  (setq #p1 (polar #pt (dtr   45) 10))
  (setq #p2 (polar #pt (dtr  135) 10))
  (setq #p3 (polar #pt (dtr -135) 10))
  (setq #p4 (polar #pt (dtr  -45) 10))
  (setq #pt$ (list #p1 #p2 #p3 #p4 #p1))
  (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_LSYM")))))
  (if #ss
    (if (> (sslength #ss) 0)
      (progn
        (setq #i 0)
        (repeat (sslength #ss)
          (setq #elm (ssname #ss #i))
          (if (equal #hndl (cdr (assoc 5 (entget #elm))))
            (princ)
            (progn ; �����̼���قƂ͈قȂ�
              (setq #skk$ (CFGetSymSKKCode #elm nil))
              (if (and (= (car #skk$)  CG_SKK_ONE_CAB)  ; 1
                       (= (cadr #skk$) CG_SKK_TWO_MID)) ; 4 ����
                (setq #ret T) ; ���ٷ��ވȊO������� T
              );_if
            )
          );_if
          (setq #i (1+ #i))
        );_repeat
      )
    );_if
  );_if
  #RET
);PK_ChkBaseSYM

;;;<HOM>*************************************************************************
;;; <�֐���>    : CPrint_Time
;;; <�����T�v>  : ����(nick)�Ő��l�̌J��グ
;;; <����>      : �Ȃ�
;;; <�߂�l>    : ���t�����̕���������O�ɏ�������
;;; <�쐬>      : 2000.2.17 @YM@
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun CPrint_Time ( / #date_time)
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))
)

;;;<HOM>************************************************************************
;;; <�֐���>  : PcPrintLog
;;; <�����T�v>: �O���[�o�������O�ɂ����o�� 03/24 YM
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun PcPrintLog ( / )
;;; DEBUG�p
   (CFOutStateLog 1 1 (strcat "  +�����ԍ�       :" CG_BukkenNo))
   (CFOutStateLog 1 1 (strcat "  +�ذ��          :" CG_SeriesCode))     ;[1]
   (CFOutStateLog 1 1 (strcat "  +�Ư�           :" CG_UnitCode))       ;[3] K,D
   (CFOutStateLog 1 1 (strcat "  +�Ԍ�1          :" CG_W1Code))         ;[4] 180,195,210,225,240,255,260,270,285,300
   (CFOutStateLog 1 1 (strcat "  +�Ԍ�2          :" CG_W2CODE))         ;[5] Z,K(�޽��1650),L(�޽��1800)
   (CFOutStateLog 1 1 (strcat "  +����1          :" CG_Type1Code))      ;[6] S(�W������),W(�H����@����)
   (CFOutStateLog 1 1 (strcat "  +����2          :" CG_Type2Code))      ;[7] F(�ׯ�����),D(�i������)
   (CFOutStateLog 1 1 (strcat "  +�ݸ���d�l      :" CG_SinkUnderCode))  ;[8] S(�W���d�l),L(�ײ�ގd�l),N(ư��߰��d�l)
   (CFOutStateLog 1 1 (strcat "  +LR             :" (nth 11 CG_GLOBAL$)))         ;[11] L(�E����),R(������)
   (CFOutStateLog 1 1 (strcat "  +�ޱ��          :" CG_DRSeriCode))     ;[12]
   (CFOutStateLog 1 1 (strcat "  +�ޱ�F          :" CG_DRColCode))      ;[13]
   (CFOutStateLog 1 1 (strcat "  +����޳�        :" CG_SoftDownCode))   ;[14] 0(�Ȃ�),1(����)
   (CFOutStateLog 1 1 (strcat "  +ۯ�            :" CG_LockCode))       ;[15] V(�ϐkۯ��Ȃ�),S(����)
   (CFOutStateLog 1 1 (strcat "  +WT�f��         :" CG_WTZaiCode))      ;[16]
   (CFOutStateLog 1 1 (strcat "  +�ݸ            :" CG_SinkCode))       ;[17]
   (CFOutStateLog 1 1 (strcat "  +������         :" CG_WtrHoleTypeCode));[18] 1(�K�v),0(�s�v),2(�����򐅋@���v)
   (CFOutStateLog 1 1 (strcat "  +����           :" CG_WtrHoleCode))    ;[19] 0(�Ȃ�),1(�W��),2,3,4,5,6
   (CFOutStateLog 1 1 (strcat "  +���            :" CG_CRCode))         ;[20]
   (CFOutStateLog 1 1 (strcat "  +��ۉ�          :" CG_CRUnderCode))    ;[21]
;;;   (CFOutStateLog 1 1 (strcat "  +��ۘe          :" CG_CRWakiCode))     ;[22] ��ۘe
   (CFOutStateLog 1 1 (strcat "  +�ݼ�           :" CG_RangeCode))      ;[23] 0(�Ȃ�),A,B,C
   (CFOutStateLog 1 1 (strcat "  +�۱ ��t����1  :" CG_BaseCabHeight))  ;[31] A(850),B(800)
   (CFOutStateLog 1 1 (strcat "  +���َ�t����2  :" CG_UpperCabHeight)) ;[32] S(500),C(600),M(700)
   (CFOutStateLog 1 1 (strcat "  +�@��F         :" CG_KikiColor))      ;[33] K(��),S(��)
   (CFOutStateLog 1 1 (strcat "  +�H��L��       :" CG_NPCode))         ;[42]�H��L��

;;; 07/27 YM �V�K�ǉ�����
   (CFOutStateLog 1 1 (strcat "  +�۱�z�u�׸�    :" CG_UnitBase))       ;[UNITBASE]
   (CFOutStateLog 1 1 (strcat "  +���ٔz�u�׸�   :" CG_UnitUpper))      ;[UNITUPPER]
   (CFOutStateLog 1 1 (strcat "  +ܰ�į�ߔz�u�׸�:" CG_UnitTop))        ;[UNITTOP]

  (if CG_FilerCode
   (CFOutStateLog 1 1 (strcat "  +�V��̨װ       :" CG_FilerCode))      ;[SKOPT04]
  )
  (if CG_KekomiCode
   (CFOutStateLog 1 1 (strcat "  +��Џ���        :" CG_KekomiCode))     ;[SKOPT05]
  )
   (CFOutStateLog 1 1 "")
  (PRINC)
);PcPrintLog

;<HOM>*************************************************************************
; <�֐���>    : SDG_SetFamilyCode
; <�����T�v>  : �_�C�j���O�p���͏����O���[�o���t�@�~���[�i��
; <�߂�l>    :
; <�쐬>      : 08/09/11 YM
; <���l>      : WOODONE���[���Ɏg�p����
;*************************************************************************>MOH<
(defun SDG_SetFamilyCode (
  &family$$ ;(LIST)�v����������ʂ̓��͏��
  /
  #HINBAN$ #KEY
  #DRCOL$ #DRCOL$$ #DRSERI$ #DRSERI$$ #SIZE_COL #SIZE_SERI #STR_COL #STR_SERI ; 03/12/17 YM ADD
  #UNIT #I #NUM
  )

  (setq #key      (strcat CG_SeriesCode "D"))
  (setq CG_Kcode  "K") ; �H��L��(���g�p)

  ;//---------------------------------------------------------------------
  ;// �����l��񂩂�p�����[�^��ݒ肷��
  (setq CG_FamilyCode      (cadr (assoc "FamilyCode" &family$$)))

  ;2008/09/11 YM MOD
  ;������ ��۰��ٕϐ��̾��(0�`99�܂�) [SK����].PLAN??�Œ�`����Ă��Ȃ����̂�nil�l ������
  (setq #i 0)
  (setq CG_GLOBAL$ nil)
  ;2009/11/18 ���[�g��p
;;; (repeat 100
  (repeat 600 ;����ID=PLAN600�܂őΉ�
    (if (< #i 10)
      (setq #num (strcat "0" (itoa #i)))
      (setq #num (itoa #i))
    );_if

    (setq CG_GLOBAL$ (append CG_GLOBAL$ (list (cadr (assoc (strcat #key #num) &family$$)))))
    (setq #i (1+ #i))
  );repeat

  ;�y�b��[�u�z����L���̃Z�b�g
  (setq CG_DRSeriCode   (nth 62 CG_GLOBAL$));����
  (setq CG_DRColCode    (nth 63 CG_GLOBAL$));����
  (setq CG_Hikite       (nth 64 CG_GLOBAL$));����

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

;;;    SD51      :���j�b�g
;;;    SD52      :�V���[�Y
;;;    SD62      :��ذ��  ��
;;;    SD63      :���J���[ ��
;;;    SD64      :���     ��
;;;    SD53      :���s��
;;;    SD54      :�^�C�v
;;;    SD55      :���[�Ԍ�
;;;    SD56      :���E����
;;;    SD57      :������F
;;;    SD58      :��ĸ۰��
;;;    SD59      :��Иg��׽
;;;    SD71      :��������
;;;    SD72      :�V��̨װ

  (princ)
);SDG_SetFamilyCode

;<HOM>*************************************************************************
; <�֐���>    : WFG_SetFamilyCode
; <�����T�v>  : �V�X�e�����ʗp���͏����O���[�o���t�@�~���[�i��
; <�߂�l>    :
; <�쐬>      : 1998-06-16
; <���l>      :
;*************************************************************************>MOH<
(defun WFG_SetFamilyCode (
  &family$$    ;(LIST)�v����������ʂ̓��͏��
  /
  #KEY #REC$$ #TYP
  )
  (setq #key      (strcat CG_SeriesCode "W"))

  ;//---------------------------------------------------------------------
  ;// �����l��񂩂�p�����[�^��ݒ肷��
  (setq CG_Kcode           "W")
  (setq CG_FamilyCode      (cadr (assoc "FamilyCode" &family$$)))
  (setq CG_SeriesCode      (cadr (assoc (strcat #key "01") &family$$)))
  (setq CG_BrandCode       (cadr (assoc (strcat #key "02") &family$$)))

  ;(setq CG_UnitCode        (cadr (assoc (strcat #key "03") &family$$)))
  (setq CG_UnitCode        "D")
  (setq CG_W1Code          (cadr (assoc (strcat #key "05") &family$$))) ;�Ԍ�
  (setq CG_W2CODE          (cadr (assoc (strcat #key "04") &family$$))) ;�`��
  (setq #typ               (cadr (assoc (strcat #key "06") &family$$))) ;�^�C�v
  (setq CG_Type1Code       (substr #typ 1 1))                           ;�^�C�v
  (setq CG_Type2Code       (substr #typ 2 1))                           ;�^�C�v

  (setq CG_DRColCode          (cadr (assoc (strcat #key "09") &family$$))) ;����
  (setq CG_DRSeriCode      (cadr (assoc (strcat #key "12") &family$$))) ;��SERIES
  (setq CG_DRColCode       (cadr (assoc (strcat #key "13") &family$$))) ;��COLOR
  (setq CG_UpCabCode       (cadr (assoc (strcat #key "07") &family$$))) ;�v����
  (setq CG_LockCode        (cadr (assoc (strcat #key "08") &family$$))) ;�~���[
  (setq CG_WTZaiCode       nil)
  (setq CG_FILERCode       nil)
  (setq CG_SidePanelCode   nil)
;;;  (setq CG_GusCode         nil) ; 02/07/31 YM MOD
  (setq CG_GasType         nil) ; CG_GusCode��CG_GasType ; 02/07/31 YM MOD
  (setq CG_HzCode          nil)

  (setq CG_UnitBase  nil)  ;�x�[�X�z�u
  (setq CG_UnitUpper nil)  ;�A�b�p�[�z�u
  (setq CG_UnitTop   nil)  ;�J�E���^�[�z�u

;;;  (CFOutLog 1 nil (strcat "  +�ذ��:" CG_SeriesCode))
;;;  (CFOutLog 1 nil (strcat "  +�Ư�:"  CG_UnitCode))
;;;  (CFOutLog 1 nil (strcat "  +�Ԍ�1:" CG_W1Code))
;;;  (CFOutLog 1 nil (strcat "  +�`��:"  CG_W2CODE))
;;;  (CFOutLog 1 nil (strcat "  +����1:" CG_Type1Code))
;;;  (CFOutLog 1 nil (strcat "  +����2:" CG_Type2Code))
;;;  (CFOutLog 1 nil (strcat "  +LR:"    CG_DRColCode))
;;;  (CFOutLog 1 nil (strcat "  +�ޱ��:" CG_DRSeriCode))
;;;  (CFOutLog 1 nil (strcat "  +�ޱ�F:" CG_DRColCode))
;;;  (CFOutLog 1 nil (strcat "  +����:"  CG_UpCabCode))
;;;  (CFOutLog 1 nil (strcat "  +�װ:"   CG_LockCode))

;;;  (CFOutLog 1 nil "")

  ;//----------------------------------------------
  ;// �ް��ް��ւ̐ڑ�
  (if (/= CG_DBSESSION nil)
    (progn
      (dbDisconnect CG_DBSESSION)
      (setq CG_DBSESSION nil)
    )
  )
  (setq CG_DBSession (DBConnect CG_DBName "" ""))
  (if (= CG_DBSESSION nil)
    (progn
      (CFAlertErr "ODBC���������ݒ肳��Ă��邩�m�F���ĉ�����")
      (quit)
    )
  )

  ;//-------------------------------------------------------
  ;// �I�v�V�����i�̕i�Ԃ��擾����
  ;//   1.����
  ;//   2.�I�v�V�����i
  ;//   3.�g�[���L���r
  ;//
  ;// �����̎擾
  (setq #key (cadr (assoc (strcat #key "15") &family$$)))
  (setq CG_OPTWTR$$ (SKG_GetOptionHinban  #key nil nil nil))

  ;// �I�v�V�����i
  (setq #key (cadr (assoc (strcat #key "16") &family$$)))
  (setq #rec$$ (SKG_GetOptionHinban  #key "L" nil nil))
  (setq CG_OPTPTS$$ (cons #rec$$ (list (SKG_GetOptionHinban  #key "R" nil nil))))

  ;// �g�[���L���r
  (setq #key (cadr (assoc (strcat #key "18") &family$$)))
  (setq #rec$$ (SKG_GetOptionHinban  #key "L" nil nil))
  (setq CG_OPTTOL$$ (cons #rec$$ (list (SKG_GetOptionHinban  #key "R" nil nil))))
);WFG_SetFamilyCode

;<HOM>*************************************************************************
; <�֐���>    : SKG_GetOptionHinban
; <�����T�v>  : �I�v�V�����i�̕i�Ԃ��擾����
; <�߂�l>    :
;        LIST : �I�v�V�����i�Ԃ̕i�Ԗ��̃��X�g
; <�쐬>      : 1999-10-27
; <���l>      :
;*************************************************************************>MOH<
(defun SKG_GetOptionHinban (
  &type ;(INT) �I�v�V�����i�^�C�v(1:�򐅊� 2:�V��̨װ 3:�T�C�h�p�l��)
  &key1 ;(STR) �򐅊�̏ꍇ--------���􌊉��H�̃R�[�h
        ;      �V��̨װ�̏ꍇ------�V��̨װ�̎��t���R�[�h (Y,N)
        ;      �T�C�h�p�l���̏ꍇ--�T�C�h�p�l���̎��t���R�[�h
  &key2 ;(INT) �T�C�h�p�l���̏ꍇ--�V�䍂��
  &key3 ;(STR) �_�C�j���O�A�T�C�h�p�l���̏ꍇ-�^�C�v�P�R�[�h
  &key4 ;(STR) �_�C�j���O�A�T�C�h�p�l���̏ꍇ-�^�C�v�Q�R�[�h
  /
  #HINBAN$ #LISTCODE #MSG #OPT$$ #QRY$ #SQL #SQL$
  )
  ;// �I�v�V�����i�^�C�v�ɂ��I�v�V�����i�Ǘ��c�a����������
  (setq #listCode nil)
  (setq #sql$
    (list
      (list "SERIES�L��" CG_SeriesCode 'STR)
      (list "���j�b�g�L��" CG_UnitCode   'STR)
      (list "OP�i�敪"     (itoa &type)  'INT)
    )
  )
  (if (/= &key1 nil)
    (setq #sql$
      (append #sql$
        (list
          (list "����KEY1" &key1 'STR)
        )
      )
    )
  )
  (if (/= &key2 nil)
    (setq #sql$
      (append #sql$
        (list
          (list "����KEY2" &key2 'STR)
        )
      )
    )
  )
  (if (/= &key3 nil)
    (setq #sql$
      (append #sql$
        (list
          (list "����KEY3" &key3 'STR)
        )
      )
    )
  )
  (if (/= &key4 nil)
    (setq #sql$
      (append #sql$
        (list
          (list "����KEY4" &key4 'STR)
        )
      )
    )
  )
  ;// �v����OP�e�[�u������������
;;;  (setq #qry$ (car (CFGetDBSQLRec CG_DBSESSION "�v����OP" #sql$))) ; 00/02/16 @YM@ �������� ADD ; 01/11/26 YM MOD
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "�v����OP" #sql$)) ; 00/02/16 @YM@ �������� ADD  ; 01/11/26 YM MOD

  (if (= #qry$ nil)
    (progn
      (setq #msg (strcat "�w�v����OP�x�Ƀ��R�[�h������܂���B\nSKG_GetOptionHinban")) ; 01/11/26 YM MOD
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    (progn
      (setq #qry$ (car #qry$))

      (setq #sql (strcat "select * from �v���\OP where \"OPTID\"=")) ; 01/11/26 YM MOD
      (setq #sql (strcat #sql (rtois (car #qry$))))    ;�I�v�V�����Ǘ��h�c�Ō���
      (setq #sql (strcat #sql " order by \"RECNO\""))  ;���R�[�h�ԍ��ŏ���

      ;// �I�v�V�����Ǘ�ID�Ńv���\OP�e�[�u������������
      (setq #opt$$
        (CFGetDBSQLRec CG_DBSESSION "�v���\OP"    ;"VISUAL LISP�̕\������������ ; 01/11/26 YM MOD
          (list
            (list "OPTID" (rtois (car #qry$)) 'INT)
          )
        )
      );_(setq

      (if (= #opt$$ nil)
        (progn
          (setq #msg (strcat "�w�v���\OP�x�Ƀ��R�[�h������܂���B\nSKG_GetOptionHinban")) ; 01/11/26 YM MOD
          (CMN_OutMsg #msg) ; 02/09/05 YM ADD
        )
      );_if

      (foreach #opt$ #opt$$
        (setq #hinban$ (append #hinban$ (list (caddr #opt$))))
      )
      ;// �i�Ԃ̃��X�g��Ԃ�
      #hinban$
    )
  );_if
);SKG_GetOptionHinban

;<HOM>*************************************************************************
; <�֐���>    : SKG_GetOptionHinbanFIRL
; <�����T�v>  : �I�v�V�����i�̕i�Ԃ��擾����(�V��̨װ�p)
; <�߂�l>    : �i�Ԃ̃��X�g
; <�쐬>      : 01/12/18 YM
; <���l>      : SKG_GetOptionHinban���g���񂵂ł��Ȃ��̂ŐV�K�쐬
;*************************************************************************>MOH<
(defun SKG_GetOptionHinbanFIRL (
  &key1 ;(STR) �V��̨װ�̏ꍇ------�V��̨װ�̎��t���R�[�h
  /
  #HINBAN$ #LISTCODE #MSG #OPT$$ #QRY$ #SQL #SQL$
  )
  ; �I�v�V�����i�Ǘ��c�a����������
  (setq #listCode nil)
  (setq #sql$
    (list
      (list "SERIES�L��" CG_SeriesCode 'STR)
      (list "���j�b�g�L��" CG_UnitCode   'STR)
      (list "OP�i�敪"     "2"  'INT) ; 2 �Œ�
      (list "����KEY1" &key1 'STR)
    )
  )
  ;// �v����OP�e�[�u������������
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "�v����OP" #sql$))

  (if (= #qry$ nil)
    (progn
      (setq #msg (strcat "�w�v����OP�x�Ƀ��R�[�h������܂���B\SKG_GetOptionHinbanFIRL"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    (progn
      (setq #qry$ (car #qry$))
      (setq #sql (strcat "select * from �v���\OP where \"OPTID\"=")) ; 01/11/26 YM MOD
      (setq #sql (strcat #sql (rtois (car #qry$))))    ;�I�v�V�����Ǘ��h�c�Ō���
      (setq #sql (strcat #sql " order by \"RECNO\""))  ;���R�[�h�ԍ��ŏ���

      (setq CG_OPTID (rtois (car  #qry$))) ; �I�v�V�����Ǘ�ID��۰��ْǉ�

      ;// �I�v�V�����Ǘ�ID�Ńv���\OP�e�[�u������������
      (setq #opt$$
        (CFGetDBSQLRec CG_DBSESSION "�v���\OP"    ;"VISUAL LISP�̕\������������ ; 01/11/26 YM MOD
          (list
            (list "OPTID" CG_OPTID 'INT)
          )
        )
      )

      (if (= #opt$$ nil)
        (progn
          (setq #msg (strcat "�w�v���\OP�x�Ƀ��R�[�h������܂���B\SKG_GetOptionHinbanFIRL"))
          (CMN_OutMsg #msg) ; 02/09/05 YM ADD
        )
      );_if

      (foreach #opt$ #opt$$
        (setq #hinban$ (append #hinban$ (list (caddr #opt$))))
        (setq CG_RECNO$ (append CG_RECNO$ (list (rtois (cadr #opt$))))) ; RECNO��۰��ْǉ�
      )
      ;// �i�Ԃ̃��X�g��Ԃ�
      #hinban$
    )
  );_if
);SKG_GetOptionHinbanFIRL

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKC_ModelLayout
;;; <�����T�v>  : �L�b�`���\�����ގ����z�u
;;; <�߂�l>    :
;;; <�쐬>      : 2000.1.�C��KPCAD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKC_ModelLayout (
  /
  #pln$$ #res #wtrno #i #SNK_OK #loop #ss #SYM
  )
  (regapp "G_SYM")
  (regapp "G_LSYM")

  (WebOutLog "(PKC_ModelLayout)�̒�")

  ;// �t�@�~���[�i�ԕ�������v�����\�������擾
  (WebOutLog "[��׊Ǘ�][��׍\��]�̌���(PKC_GetPlan)")
  (setq #pln$$ (PKC_GetPlan))   ;�v�����\���e�[�u���̃��X�g

  (PKC_LayoutParts #pln$$)

  ;// �v���������y�V���N�����z�u�z

	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn ;2017/09/07 YM ADD

		  ;// �������ق̎�t��
		  (if (and (/= (nth 45 CG_GLOBAL$) "N")(/= (nth 45 CG_GLOBAL$) "X"));�������َ�t����
		    (KP_PutEndPanel_FK) ;�ڰѷ���
		  );_if

		)
		(progn
			
		  (setq #SNK_OK nil) ; �ݸ�z�u���s�� = T
		  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
		  (if (and #ss (> (sslength #ss) 0))
		    (progn
		      (setq #i 0 #loop T)
		      (while (and #loop (< #i (sslength #ss)))
		        (setq #sym (ssname #ss #i))
		        (if (and (= CG_SKK_ONE_CAB (CFGetSymSKKCode #sym 1))
		                 (= CG_SKK_TWO_BAS (CFGetSymSKKCode #sym 2))
		                 (= CG_SKK_THR_SNK (CFGetSymSKKCode #sym 3)))
		          (setq #SNK_OK T #loop nil) ; �}�ʏ�ɼݸ���ނ�����
		        );_if
		        (setq #i (1+ #i))
		      )
		      (if #SNK_OK
		        (progn
		          (PKC_LayoutSink);;// �v���������y�V���N�����z�u�z
		        )
		      ) ; <pclosnk.lsp>
		    );while
		  );_if

		  ;// �������ق̎�t��
		  (if (and (/= (nth 45 CG_GLOBAL$) "N")(/= (nth 45 CG_GLOBAL$) "X"));�������َ�t����
		    (KP_PutEndPanel)
		  );_if

		) ;2017/09/07 YM ADD
	);_if


  ;// ��׽�߰è��݂̔z�u 2009/10/26 YM ADD
  (WebOutLog "--- ��׽�߰è��݂̔z�u ---")
  (PKW_GLASS_PARTISYON)



  ;//�y�~���[���]�z;2008/06/23 YM MOD
  (if (/= (nth 11 CG_GLOBAL$) "L");�����l������
    (PKC_MirrorParts)
  );_if


;�������
;;;(defun PK_Yuttari_Plan (

	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn ;2017/09/07 YM ADD
			nil
		)
		(progn
			
		  ;����ݸ�̷���ȯĶ�ď��� 2008/07/28 YM ADD
		  (MultiCabCut)

		) ;2017/09/07 YM ADD
	);_if

  ;// �V���N�A�K�X�֘A�@��̑��ʐ}�����ꂼ��V���N�L���r�A
  ;// �K�X�L���r�ɂ̊�_�Ɉړ�������
  ;//   �{�����̓V���N�i�K�X�j�L���r���̒f�ʎw���ɂ��V���N�i�K�X�j��
  ;//   �B�������ŉB��Ă��܂��̂�h�����߂ł���

;2008/06/23 YM DEL
  (PKC_MoveToSGCabinet)


  (princ)
);PKC_ModelLayout

;<HOM>*************************************************************************
; <�֐���>    : PDC_ModelLayout
; <�����T�v>  : ���[���ގ����z�u
; <�߂�l>    :
; <�쐬>      : 08/09/11 YM
; <���l>      :
;*************************************************************************>MOH<
(defun PDC_ModelLayout (
  /
  #PLN$$
  )
  (regapp "G_SYM")
  (regapp "G_LSYM")

  (WebOutLog "(PDC_ModelLayout)�̒�")

  ;// �t�@�~���[�i�ԕ�������v�����\�������擾
  (WebOutLog "[��׊Ǘ�][��׍\��]�̌���(PDC_GetPlan)")
  (setq #pln$$ (PDC_GetPlan))   ;�v�����\���e�[�u���̃��X�g

  (PKC_LayoutParts #pln$$)

  ;// �������ق̎�t��
;;;; (setq CG_UpCabHeight 2350)

  (if (and (/= (nth 71 CG_GLOBAL$) "N")(/= (nth 71 CG_GLOBAL$) "X"));�������َ�t����
    (KP_PutEndPanel_D);���[ �������ق̎�t��
  );_if

  ;//�y�~���[���]�z;2008/06/23 YM MOD
  (if (= (nth 56 CG_GLOBAL$) "R");�����l������ or "N"�̂Ƃ�������B"R"�̂Ƃ��ɔ��]����
    (PKC_MirrorParts)
  );_if

  (princ)
);PDC_ModelLayout

;<HOM>*************************************************************************
; <�֐���>    : PDC_ModelLayout_EXTEND
; <�����T�v>  : ���[���ގ����z�u
; <�߂�l>    :
; <�쐬>      : 2009/11/18 YM
; <���l>      : ���[�g�� WK_SDB�p
;*************************************************************************>MOH<
(defun PDC_ModelLayout_EXTEND (
  /
  #PLN$$
  )
  (regapp "G_SYM")
  (regapp "G_LSYM")

  (WebOutLog "(PDC_ModelLayout_EXTEND)�̒�")

  ;// �t�@�~���[�i�ԕ�������v�����\�������擾
  (WebOutLog "[��׊Ǘ�][��׍\��]�̌���(PDC_GetPlan_EXTEND)")
  (setq #pln$$ (PDC_GetPlan_EXTEND))   ;�v�����\���e�[�u���̃��X�g

  ;���ނ�[��׍\��]�ʂ�ɔz�u ����+���
  (PKC_LayoutParts #pln$$)

  ;//�y�~���[���]�z;2008/06/23 YM MOD
  (if (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "R");�����l������ or "N"�̂Ƃ�������B"R"�̂Ƃ��ɔ��]����
    (progn
      (PKC_MirrorParts)
      (PKC_MoveParts)
    )
  );_if


  ;�������ق̎�t��
;;; (setq CG_UpCabHeight 2350)

  (if (and (/= (nth (+ (* 100 CG_D_EXTEND_KAI) 71) CG_GLOBAL$) "N")
           (/= (nth (+ (* 100 CG_D_EXTEND_KAI) 71) CG_GLOBAL$) "X"));�������َ�t����
    (KP_PutEndPanel_D_EXTEND);���[ �������ق̎�t��
  );_if

  ;����̂� �J�n�������ق̎�t��
  (if (= CG_D_EXTEND_KAI 1)
    (progn
      (if (and (/= (nth 71 CG_GLOBAL$) "N")
               (/= (nth 71 CG_GLOBAL$) "X")) ;�J�n�������َ�t����
        (KP_PutEndPanel_D_EXTEND_START) ;���[ �J�n�������ق̎�t��
      );_if
    )
  );_if

  ;;---------------------------------------------------------------------------------
  ;; PDC_ModelLayout_EXTEND �̊O���璆�ɏ������ړ�
  ;;---------------------------------------------------------------------------------
  (command "_layer" "T" "*" "")
  (WebDefErrFunc) ; �װ�֐���`(02/09/11 YM �֐���)

  ;// �V��̨װ�̍쐬
  (if (and (/= (nth 72 CG_GLOBAL$) "N")(/= (nth 72 CG_GLOBAL$) "X"));�V��̨װ��t����
    (progn
      (WebOutLog "--- �V��̨װ�̍쐬(PKW_UpperFiller)���Ă� ---")

      ;2009/11/21 YM ADD ���[�g�� SDB��̨װ���E����
      (setq SKW_FILLER_LSIDE 1)
      (setq SKW_FILLER_RSIDE 1)
      (setq SKW_FILLER_BSIDE 0)
      (PKW_UpperFiller);���ݓV��̨װ="A"�̂�
    )
  );_if



  ;2011/04/22 YM ADD-S OP�u���̎d�g�݂𓱓�
  ;�݌ˎ�|���肠��/�Ȃ�
  (KP_ChgCab)  ;�Vۼޯ� ���i���ނɈˑ����Ȃ�


  ;// �\����w�̐ݒ�
  (SetLayer)

  ;dwg�ۑ�
  (command "_saveas" "" (strcat CG_SYSPATH "plan" (itoa CG_D_EXTEND_KAI) ".dwg"))

  (princ)
);PDC_ModelLayout_EXTEND

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKC_GetPlan
;;; <�����T�v>  : �v�����\�����擾
;;; <�߂�l>    :
;;;        LIST : �\�[�g���ꂽ�w�v���\���x��񃊃X�g(���R�[�h�̃��X�g)
;;; <�쐬>      : 2000.1.19�C��KPCAD
;;; <���l>      : �Ȃ�
;;;*************************************************************************>MOH<
(defun PKC_GetPlan (
  /
  #QRY$$ #QRY1$$ #QRY2$$ #QRY1$ #RET$
  )
  (setq #qry1$$ '())
  (setq #qry2$$ '())

;;; �\���^�C�v=1  (�t���A�z�u�Ƀt���O)
(WebOutLog "--- (PFGetCompBase)���Ă� ---")

  (setq #ret$ (PFGetCompBase))
  (setq #qry1$  (car  #ret$));�v���Ǘ�
  (setq #qry1$$ (cadr #ret$));�v���\��

(WebOutLog "[��׊Ǘ�]")
(WebOutLog #qry1$)
(WebOutLog "[��׍\��]")
(WebOutLog #qry1$$)


;;; �\���^�C�v=2  (�E�H�[���z�u�t���O�Ƀt���O)

  (if (/= "N" (nth 32 CG_GLOBAL$))
    (progn ;�݌˂Ȃ��ȊO
      (WebOutLog "--- (PFGetCompUpper)���Ă� ---")
      (setq #qry2$$ (PFGetCompUpper #qry1$))
      (WebOutLog #qry2$$)
    )
  )

  (setq #qry$$ (append #qry1$$ #qry2$$))
  #qry$$ ; �߂�l
);PKC_GetPlan


;;;<HOM>*************************************************************************
;;; <�֐���>    : PDC_GetPlan
;;; <�����T�v>  : �v�����\�����擾(���[)
;;; <�߂�l>    :
;;;        LIST : �\�[�g���ꂽ�w�v���\���x��񃊃X�g(���R�[�h�̃��X�g)
;;; <�쐬>      : 2008/09/11 YM
;;; <���l>      : WK_SDA�p
;;;*************************************************************************>MOH<
(defun PDC_GetPlan (
  /
  #DB_NAME #LIST$$ #MSG #PLAN_ID #QRY$ #QRY$$ #QRY1$$ #QRY2$$
  )
  (setq #qry1$$ '())
  (setq #qry2$$ '())

  (WebOutLog "--- [��׊Ǘ�][��׍\��]������ ---")

  ;[�v���Ǘ�]
  (setq #LIST$$
    (list
      (list "���j�b�g�L��"   (nth 51 CG_GLOBAL$) 'STR)
      (list "���s��"         (nth 53 CG_GLOBAL$) 'STR)
      (list "�^�C�v"         (nth 54 CG_GLOBAL$) 'STR)
      (list "���[�Ԍ�"       (nth 55 CG_GLOBAL$) 'STR)
      (list "�J�E���^�[�F"   (nth 57 CG_GLOBAL$) 'STR)
      (list "SOFT_CLOSE"     (nth 58 CG_GLOBAL$) 'STR)
      (list "�A���~�g�K���X" (nth 59 CG_GLOBAL$) 'STR)
    )
  )
  (setq #DB_NAME "�v���Ǘ�")
  (WebOutLog (strcat "����DB��= "  #DB_NAME))

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$)
  )

  (setq #qry$ (DBCheck #qry$ "�w�v���Ǘ��x" "PDC_GetPlan")) ; ��������WEB��۸ޏo��

  ; �v����ID
  (setq #plan_id (nth 0 #qry$))

  ;[�v���\��]
  (setq #DB_NAME "�v���\��")
  (WebOutLog (strcat "����DB��= "  #DB_NAME))

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME
      (list
        (list "�v����ID"  #plan_id  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  (if (= #qry$$ nil)
    (progn
      (setq #msg (strcat "�w�v���\���x�Ƀ��R�[�h������܂���B\PDC_GetPlan"))
      (cond
        ((or (= CG_AUTOMODE 0)(= CG_AUTOMODE 1)) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
          (CMN_OutMsg #msg)
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog #msg)
          (quit)
        )
      );_cond
    )
  );_if

  (WebOutLog "[��׊Ǘ�]")
  (WebOutLog #qry$)
  (WebOutLog "[��׍\��]")
  (WebOutLog #qry$$)

  #qry$$ ; �߂�l

);PDC_GetPlan


;;;<HOM>*************************************************************************
;;; <�֐���>    : PDC_GetPlan_EXTEND
;;; <�����T�v>  : �v�����\�����擾(���[)
;;; <�߂�l>    :
;;;        LIST : �\�[�g���ꂽ�w�v���\���x��񃊃X�g(���R�[�h�̃��X�g)
;;; <�쐬>      : 2008/09/11 YM
;;; <���l>      : WK_SDA�p
;;;*************************************************************************>MOH<
(defun PDC_GetPlan_EXTEND (
  /
  #PLAN_ID_BASE #PLAN_ID_UPPER #QRY1$$ #QRY2$$ #QRY_BASE$ #QRY_BASE$$ #QRY_UPPER$
  #QRY_UPPER$$ #RET
  )
  (setq #qry1$$ '())
  (setq #qry2$$ '())

  (WebOutLog "--- [��׊Ǘ�][��׍\��]������ ---")

  ;������������������������������������������������������������������������
  ;[�v���Ǘ�]����\�� �\������=1
  (setq #qry_BASE$ ;nil�̏ꍇ(���̂�)������
    (CFGetDBSQLRec CG_DBSESSION "�v���Ǘ�"
      (list
        (list "���j�b�g�L��"   (nth  51 CG_GLOBAL$) 'STR);����
        (list "��{�\��"       (nth (+ (* 100 CG_D_EXTEND_KAI) 54) CG_GLOBAL$) 'STR)
        (list "�\���^�C�v"     "1"                  'INT)
        (list "���[�Ԍ�"       (nth (+ (* 100 CG_D_EXTEND_KAI) 55) CG_GLOBAL$) 'STR)
        (list "���s��"         (nth (+ (* 100 CG_D_EXTEND_KAI) 53) CG_GLOBAL$) 'STR)
        (list "SOFT_CLOSE"     (nth  58 CG_GLOBAL$) 'STR);����
        (list "�A���~�g�K���X" (nth (+ (* 100 CG_D_EXTEND_KAI) 59) CG_GLOBAL$) 'STR);����
        (list "�J�E���^�[�F"   (nth (+ (* 100 CG_D_EXTEND_KAI) 57) CG_GLOBAL$) 'STR)
      )
    )
  )
  (if #qry_BASE$
    (progn ;ں��ނ���
      (setq #qry_BASE$ (DBCheck #qry_BASE$ "�w�v���Ǘ��x" "PDC_GetPlan_EXTEND")) ; ��������WEB��۸ޏo��
      ; �v����ID
      (setq #plan_id_BASE (nth 0 #qry_BASE$))
    )
    (progn ;ں��ނȂ�
      (setq #plan_id_BASE "")
    )
  );if

  ;[�v���\��]����\�� �\������=1
  (setq #qry_BASE$$ ;nil�̏ꍇ(���̂�)������
    (CFGetDBSQLRec CG_DBSESSION "�v���\��"
      (list
        (list "�v����ID"  #plan_id_BASE  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  ;������������������������������������������������������������������������
  ;[�v���Ǘ�]���\�� �\������=2
  (setq #qry_UPPER$ ;nil�̏ꍇ(����̂�)������
    (CFGetDBSQLRec CG_DBSESSION "�v���Ǘ�"
      (list
        (list "���j�b�g�L��"   (nth  51 CG_GLOBAL$) 'STR)
        (list "���\��"       (nth (+ (* 100 CG_D_EXTEND_KAI) 61) CG_GLOBAL$) 'STR)
        (list "�\���^�C�v"     "2"                  'INT)
        (list "���[�Ԍ�"       (nth (+ (* 100 CG_D_EXTEND_KAI) 55) CG_GLOBAL$) 'STR)
        (list "SOFT_CLOSE"     (nth  58 CG_GLOBAL$) 'STR);����
      )
    )
  )
  (if #qry_UPPER$
    (progn ;ں��ނ���
      (setq #qry_UPPER$ (DBCheck #qry_UPPER$ "�w�v���Ǘ��x" "PDC_GetPlan_EXTEND")) ; ��������WEB��۸ޏo��
      ; �v����ID
      (setq #plan_id_UPPER (nth 0 #qry_UPPER$))
    )
    (progn ;ں��ނȂ�
      (setq #plan_id_UPPER "")
    )
  );if

  ;[�v���\��]����\�� �\������=1
  (setq #qry_UPPER$$ ;nil�̏ꍇ(���̂�)������
    (CFGetDBSQLRec CG_DBSESSION "�v���\��"
      (list
        (list "�v����ID"  #plan_id_UPPER  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  (WebOutLog "[��׊Ǘ�]����\��")
  (WebOutLog #qry_BASE$)
  (WebOutLog "[��׍\��]����\��")
  (WebOutLog #qry_BASE$$)

  (WebOutLog "[��׊Ǘ�]���\��")
  (WebOutLog #qry_UPPER$)
  (WebOutLog "[��׍\��]���\��")
  (WebOutLog #qry_UPPER$$)

  (setq #ret (append #qry_BASE$$ #qry_UPPER$$)) ; �߂�l
  #ret ;����{���̍\��
);PDC_GetPlan_EXTEND

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKC_MoveToSGCabinet
;;; <�����T�v>  : ���ʂk�A�q�̐}�`�݂̂��w��}�`�̑��ʂɈړ�������
;;; <�߂�l>    :
;;; <�쐬>      : 1999-04-20
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKC_MoveToSGCabinet (
  /
  #ss #i #en #xd$ #skk
  )
	(setq CG_SnkSym nil)
	(setq CG_GasSym nil)
	
  (setq #ss (ssget "X" '((-3 ("G_SYM")))))
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i))
    (setq #skk (CFGetSymSKKCode #en 3)) ; �w�蕔�ނ̐��iCODE���擾����

    (cond
      ((= #skk CG_SKK_THR_SNK)          ;�V���N�L���r�l�b�g�̏ꍇ  CG_SKK_THR_SNK = 2
        (setq CG_SnkSym #en)
      )
      ((= #skk CG_SKK_THR_GAS)          ;�K�X�L���r�l�b�g�̏ꍇ  CG_SKK_THR_GAS = 3
        (setq CG_GasSym #en)
      )
    )
    (setq #i (1+ #i))
  )

  (setq #i 0)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i))
    (setq #skk (CFGetSymSKKCode #en 1)) ; �w�蕔�ނ̐��iCODE���擾����
    (cond
      ((or (= #skk CG_SKK_ONE_WTR) (= #skk CG_SKK_ONE_SNK))     ;�V���N�֘A�@��̏ꍇ 5,4
        (PKC_MoveToSGCabinetSub #en CG_SnkSym)
      )
      ((= #skk CG_SKK_ONE_GAS)     ;�K�X�֘A�@��̏ꍇ
        (PKC_MoveToSGCabinetSub #en CG_GasSym)
      )
    )
    (setq #i (1+ #i))
  )
);PKC_MoveToSGCabinet

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKC_MoveToSGCabinetSub
;;; <�����T�v>  : ���ʂk�A�q�̐}�`�݂̂��w��}�`�̑��ʂɈړ�������
;;; <�߂�l>    :
;;; <�쐬>      : 1999-04-20
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKC_MoveToSGCabinetSub (
  &sym1        ;�ړ�������V���{���i�V���N�A�����A�K�X�R�����j
  &sym2        ;�ړ���ƂȂ�V���{���i�V���N�L���r�A�K�X�L���r�j
  /
  #en$ #i #ss #lay #p1 #p2 #dst #ang #DUMPT #P11
  )

  ;// ����̃O���[�v�̐}�`�����o��
  (setq #en$ (CFGetGroupEnt &sym1))
  ;// ���ʂ̐}�`�̂ݔ����o��
  (setq #i 0)
  (setq #ss (ssadd))
  (foreach #en #en$
    (setq #lay (cdr (assoc 8 (entget #en))))
;;;    (if (wcmatch #lay "Z_05*,Z_06*")         @YM@ 00/01/27 )
    (if #lay
      (if (wcmatch #lay "Z_05*,Z_06*")
        (ssadd #en #ss)
      )
    );_if
    (setq #i (1+ #i))
  )

  ;// ���ʂ̃f�[�^���ړ�������
  (setq #p1 (cdr (assoc 10 (entget &sym1))))
  (setq #p1 (list (car #p1) (cadr #p1)))
  (setq #p2 (cdr (assoc 10 (entget &sym2))))
  (setq #p2 (list (car #p2) (cadr #p2)))
  (setq #ang (nth 2 (CFGetXData &sym2 "G_LSYM")))
  ; ���z�_
  (setq #dumPT (polar #p2 #ang 1000))
  (setq #p11 (CFGetDropPt #p1 (list #dumPT #p2)))

  ; 2000/09/01 HT 90�x�P�ʂ̕����ȊO�ɑΉ� MOD START
  ;(if (equal #ang 0.0 0.0000001)
  ;  (setq #ang pi)
  ;)
  ;���������߂�
  ;(setq #dp1 (polar #p1 (* -1 #ang) 1))
  ;(setq #dp2 (polar #p2 (+ #ang (dtr 90)) 1))
  ;(setq #cp (inters #p1 #dp1 #p2 #dp2 nil))
  ;(setq #cp (list (car #cp) (cadr #cp)))
  ;(setq #dst (distance #p1 #cp))
  ;(command "move" #ss "" #p1 #cp)
  (setq #dst (distance #p11 #p2))
  ; �V���N(�K�X)���V���N(�K�X)�L���r�l�b�g�����ֈړ�
  (if (/= (sslength #ss) 0)  ; 2000/10/19 HT
    (command "move" #ss "" (list (* #dst (- (cos #ang))) (* #dst (- (sin #ang)))) "")
    (princ "�ړ�����V���Nor�K�X�}�`������܂���B")
  );_if

	(setq CG_SnkSym nil)
	(setq CG_GasSym nil)

  (princ)
  ; 2000/09/01 HT 90�x�P�ʂ̕����ȊO�ɑΉ� MOD END
);PKC_MoveToSGCabinetSub

;;;<HOM>*************************************************************************
;;; <�֐���>     : PKC_LayoutParts
;;; <�����T�v>   : �v�����\�����ޔz�u
;;; <�߂�l>     :
;;; <�쐬>       : 2000.1.18�C�� YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun PKC_LayoutParts (
  &pln$$   ;(LIST)�w�v���\���x��񃊃X�g
  /
  #I #RNO #SD #SH #SW #SYM #XD$ #XD2$ #ret$ #pmen2 #PMEN2$
  )

  (WebOutLog "--- (PKC_LayoutParts)�̒� ---")

  ;// ���R�[�h���Ɉȉ��̏������s��
  (setq #rno 1) ; record Number

  (foreach #pln$ &pln$$ ; ���ޔz�u�̃��[�v

    (if (= CG_AUTOMODE 2)
      nil  ; Web��CAD���ްӰ��
      ;else
      (progn
        (command "_zoom" "e")
      )
    );_if

    ;// �w�v���\���x.���i�^�C�v���O�̏ꍇ�͒P�Ɛ}�`�A����ȊO�͕����}�`�Ƃ���
    (if (= (fix (nth 6 #pln$)) 0)  ; ���i�^�C�v���O  �P�Ɛ}�`
      (progn
        (princ "####################################")
        (princ (strcat "�P�ƕ���=[" (nth 2 #pln$) "]"))
        (princ "####################################")

        (WebOutLog "####################################")
        (WebOutLog (strcat "�P�ƕ���=[" (nth 2 #pln$) "]"))
        (WebOutLog "####################################")

        ;// �P�ƕ��ޔz�u
        (setq #ret$ (PKC_LayoutOneParts #pln$ #rno)) ; �g���f�[�^��Ԃ�
        (setq #xd$ (car  #ret$))
        (setq #sym (cadr #ret$))

        (if (/= #xd$ nil)
          (progn

            (setq #xd2$ (CFGetXData #sym "G_SYM"))
            (setq #sw (fix (nth 14 #pln$))) ; �L�k�v OK!
            (setq #sd (fix (nth 15 #pln$))) ; �L�k�c OK!
            (setq #sh (fix (nth 16 #pln$))) ; �L�k�g OK!

            ;// ���ނ̊g���ް��̻��ނ��X�V
            (WebOutLog "�g���ް� G_SYM ���X�V���܂�") ; 02/09/04 YM ADD
            (CFSetXData #sym "G_SYM"
              (list
;;;                (nth 0 #xd2$)    ;�V���{������
                ;2009/04/14 YM MOD
                "DUM"    ;�V���{������

                (nth 1 #xd2$)    ;�R�����g�P
                (nth 2 #xd2$)    ;�R�����g�Q
                (if (= #sw 0) (nth 3 #xd2$) #sw)   ;�V���{����l�v
                (if (= #sd 0) (nth 4 #xd2$) #sd)   ;�V���{����l�c
                (if (= #sh 0) (nth 5 #xd2$) #sh)   ;�V���{����l�g
                (nth 6 #xd2$)    ;�V���{����t������
                (nth 7 #xd2$)    ;���͕��@
                (nth 8 #xd2$)    ;�v�����t���O
                (nth 9 #xd2$)    ;�c�����t���O
                (nth 10 #xd2$)   ;�g�����t���O
                (nth 14 #pln$)   ;�L�k�t���O�v OK!
                (nth 15 #pln$)   ;�L�k�t���O�c OK!
                (nth 16 #pln$)   ;�L�k�t���O�g OK!
                (nth 14 #xd2$)   ;�u���[�N���C�����v
                (nth 15 #xd2$)   ;�u���[�N���C�����c
                (nth 16 #xd2$)   ;�u���[�N���C�����g
              )
            )
            (CFSetXData #sym "G_LSYM" #xd$) ; PKC_LayoutOneParts �̖߂�l

            ; @@@ ��Ű����"115"��PMEN2�̒��_������������ 01/06/19 YM ADD START
            (if (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_CNR))) ; ��Ű�����ް� ; 01/08/31 YM MOD ��۰��ى�
              (KP_MakeCornerPMEN2 #sym)
            );_if
            (if (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB)(itoa CG_SKK_TWO_UPP)(itoa CG_SKK_THR_CNR))) ; ��Ű���ޱ��߰ ; 01/08/31 YM MOD ��۰��ى�
              (progn
                (setq #pmen2$ (KP_MakeCornerPMEN2 #sym))
                (if #pmen2$
                  (foreach #pmen2 #pmen2$
                    (command "_move" #pmen2 "" '(0 0 0)
                      (strcat "@0,0," (rtos (nth 6 #xd2$))) ; �V���{����t������
                    )
                  )
                );_if
              )
            );_if
            ; @@@ ��Ű����"115"��PMEN2�̒��_������������ 01/06/19 YM ADD END


            ;2011/02/01 YM MOD ����������ɏ�ɾ��
            (KcSetG_OPT #sym) ; �g���ް�"G_OPT"���


;;; 2011/02/01YM@DEL            ;;; ������(�װ���]�K�v)�̂Ƃ��� PKC_MirrorPartsSub �ž�Ă���
;;; 2011/02/01YM@DEL            ;;; �E����(�װ���]�s�v)�̂Ƃ��ɂ����ž�Ă���
;;; 2011/02/01YM@DEL
;;; 2011/02/01YM@DEL            (if (= CG_PlanType "SK")
;;; 2011/02/01YM@DEL              (progn
;;; 2011/02/01YM@DEL                ;���ݗp���� ;2008/09/14 YM ADD
;;; 2011/02/01YM@DEL                (if (= (nth 11 CG_GLOBAL$) "L");�f�t�H���g������̏ꍇ
;;; 2011/02/01YM@DEL                  (KcSetG_OPT #sym) ; �g���ް�"G_OPT"���
;;; 2011/02/01YM@DEL                );_if
;;; 2011/02/01YM@DEL              )
;;; 2011/02/01YM@DEL              (progn
;;; 2011/02/01YM@DEL              
;;; 2011/02/01YM@DEL                (cond
;;; 2011/02/01YM@DEL                  ((= CG_SeriesDB "SDA")
;;; 2011/02/01YM@DEL                    ;���[�p���� ;2008/09/14 YM ADD
;;; 2011/02/01YM@DEL                    (if (or (= (nth 56 CG_GLOBAL$) "L")(= (nth 56 CG_GLOBAL$) "N"))
;;; 2011/02/01YM@DEL                      (KcSetG_OPT #sym) ; �g���ް�"G_OPT"���
;;; 2011/02/01YM@DEL                    );_if
;;; 2011/02/01YM@DEL                  )
;;; 2011/02/01YM@DEL                  ((= CG_SeriesDB "SDB");2009/12/1 YM ADD ���[�g��
;;; 2011/02/01YM@DEL                    (if (or (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "L")
;;; 2011/02/01YM@DEL                            (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "N")
;;; 2011/02/01YM@DEL                            (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "Z"))
;;; 2011/02/01YM@DEL                      (KcSetG_OPT #sym) ; �g���ް�"G_OPT"���
;;; 2011/02/01YM@DEL                    );_if
;;; 2011/02/01YM@DEL                  )
;;; 2011/02/01YM@DEL                  (T
;;; 2011/02/01YM@DEL                    (if (or (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "L")
;;; 2011/02/01YM@DEL                            (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "N")
;;; 2011/02/01YM@DEL                            (= (nth (+ (* 100 CG_D_EXTEND_KAI) 56) CG_GLOBAL$) "Z"))
;;; 2011/02/01YM@DEL                      (KcSetG_OPT #sym) ; �g���ް�"G_OPT"���
;;; 2011/02/01YM@DEL                    );_if
;;; 2011/02/01YM@DEL                  )
;;; 2011/02/01YM@DEL                );_cond
;;; 2011/02/01YM@DEL
;;; 2011/02/01YM@DEL              )
;;; 2011/02/01YM@DEL            );_if



          )
        )
      )
    ;else
      (progn                 ;�����}�`
        (princ "####################################")
        (princ (strcat "��������=[" (nth 2 #pln$) "]"))
        (princ "####################################")

        (WebOutLog "####################################")
        (WebOutLog (strcat "��������=[" (nth 2 #pln$) "]"))
        (WebOutLog "####################################")

        ;// �����_�~�[�}�`�����z�u���Ă���
        (PKC_LayoutBlockParts #pln$ #rno)
      )
    )
    (setq #rno (1+ #rno))

  );foreach

  (princ)
);PKC_LayoutParts

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_Stretch_SidePanel
;;; <�����T�v>  : ���݌������[���������ِL�k
;;; <�߂�l>    :
;;; <�쐬>      : 2000.8.15 YM
;;; <���l>      : ׯ�ڰفF(735,180,40) ���艏�F(1350,53,29)
;;;*************************************************************************>MOH<
(defun PK_Stretch_SidePanel (
  &sym      ;�V���{���}�`
  &val_w    ;���@�v
  &val_d    ;���@�c
  &val_h    ;���@�g
  /
  #VAL_D #VAL_H #VAL_W #XD$ #xld$
  #DPT #FANG #I #ORG$ #RTFLG #TMP$
  )

  (setq #xd$  (CFGetXData &sym "G_SYM"))
  (setq #xld$ (CFGetXData &sym "G_LSYM"))
  (setq #val_w (if (/= (nth 3 #xd$) &val_w) &val_w 0))
  (setq #val_d (if (/= (nth 4 #xd$) &val_d) &val_d 0))
  (setq #val_h (if (/= (nth 5 #xd$) &val_h) &val_h 0))

  ; �Ώې}�`��0�x�܂���90�x�ȊO�̏ꍇ�A��]����0�x��
  (setq #fANG (nth 2 #xld$))
  (if (or (equal 0 (RTD #fANG) 0.1) (equal 90 (RTD #fANG) 0.001))
    (setq #rtFLG nil)
    ; �A�C�e����], LSYM �}���p�x�ύX, #xld$�Đݒ�
    (progn
      (setq #rtFLG 'T)
      (setq #dPT (cdr (assoc 10 (entget &sym))))
      (command "_rotate" (CFGetSameGroupSS &sym) "" #dPT "R" (RTD #fANG) 0 "")
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
  (StretchPartsSub &sym)
  ; �t���O�m�F �Ώې}�`���L�k�����O�ɉ�]����Ă����Ȃ猳�̊p�x�ɖ߂�
  (if #rtFLG (progn
    (setq #dPT (cdr (assoc 10 (entget &sym))))
    (command "_rotate" (CFGetSameGroupSS &sym) "" #dPT "R" 0 (RTD #fANG) "")
    (CFSetXData &sym "G_LSYM" #ORG$)
  )); if&progn

  (princ)
);PK_Stretch_SidePanel

;;;<HOM>*************************************************************************
;;; <�֐���>     : PKC_LayoutOneParts
;;; <�����T�v>   : �P�ƕ��ޔz�u
;;; <�߂�l>     : �g���f�[�^��Ԃ�
;;;         LIST : ���C�A�E�g���ɐݒ肳���g���f�[�^
;;;                  1 :�{�̐}�`ID      :
;;;                  2 :�}���_          :
;;;                  3 :��]�p�x        :
;;;                  4 :�H��L��        :
;;;                  5 :SERIES�L��    :
;;;                  6 :�i�Ԗ���        :
;;;                  7 :L/R�敪         :
;;;                  8 :���}�`ID        :
;;;                  9 :���J���}�`ID    :
;;;                  10:���iCODE      :
;;;                  11:�����t���O      :
;;;                  12:�z�u���ԍ�      :
;;;                  13:�p�r�ԍ�        :
;;; <�쐬>       : 2000.1.18 YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun PKC_LayoutOneParts (
  &pln$  ;(LIST)�w�v���\���x���  17 elements
  &recno ;(INT) �z�u�ԍ� integer
  /
  #FIG$ #FLG #HNO #LR #LSYM #POS$ #QRY$ #SEIKAKU #SYM #TWO #YNO #LIST$$
  #BASE_CODE #BASE_CODE$ #COUNTER$ #DD #EP_EXIST #EP_EXIST$ #PT #WW #HAND_SYM ;2009/11/30 YM ADD
  #CT_COL #HINBAN ;209/12/02 YM ADD
  )

  (setq #HNO (nth 2 &pln$))  ;�i�Ԗ���   OK!
  (setq #LR  (nth 3 &pln$))  ;LR�敪     OK!
  (setq #YNO (nth 5 &pln$))  ;�p�r�ԍ�   OK!

  (setq #LIST$$
    (list
      (list "�i�Ԗ���"      #HNO           'STR) ; OK!
      (list "LR�敪"        #LR            'STR) ; OK!
      (list "�p�r�ԍ�"      (rtois #YNO)   'INT) ; OK!
    )
  )

  (setq #fig$  ;  "�i�Ԑ}�`"���R�[�h
    (CFGetDBSQLHinbanTable "�i�Ԑ}�`" #HNO ;�i�Ԗ���
      #LIST$$
    )
  )

  (WebOutLog "�i�Ԑ}�`  ��������:")
  (setq #fig$ (DBCheck #fig$ "�w�i�Ԑ}�`�x" "PKC_LayoutOneParts"))

  (setq #LIST$$
    (list
      (list "�i�Ԗ���" #HNO 'STR)
    )
  )

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{" #LIST$$)
  )
  (setq #qry$ (DBCheck #qry$ "�w�i�Ԋ�{�x" "PKC_LayoutOneParts"))

  (setq #seikaku (fix (nth 3 #qry$))) ; ���iCODE
  (setq #two (CFGetSeikakuToSKKCode #seikaku 2))
  (setq #Flg T)
  (cond
;2008/07/26 YM DEL
;;;    ((= #two CG_SKK_TWO_BAS)  ;���iCODE���x�[�X
;;;      (if (/= CG_UnitBase "1")
;;;        (setq #Flg nil)
;;;      )
;;;    )
    ((= #two CG_SKK_TWO_UPP)  ;���iCODE���A�b�p�[
      (if (= (nth 32 CG_GLOBAL$) "N")
        (setq #Flg nil)
      )
    )
    (T
      (setq #Flg T)
    )
  );_cond

  (if (= #Flg nil)
    (progn
      nil
    )
  ;else
    (progn
  ;// �v�����\�����̔z�u���� X/Y�A���_����̋��� X/Y/Z�A���ޔz�u���� W/D�A
  ;// ����ѐL�k�l X/Y/Z ���Q�Ƃ��āA�Y������}�`�����f����ԏ�ɔz�u����
  ;// �w�v���\���x�z�u���� X/Y :
  ;// �w�v���\���x���_����̋��� X/Y/Z :
  ;// �w�v���\���x���ޔz�u���� W/D :
  ;// �w�v���\���x�L�k�l W/D/H :
  ;// �w�v���\���x�f�ʎw���̗L�� :
      (setq #pos$ (PKC_InsertParts &pln$ #fig$ #seikaku)) ; ���ޑ}��,����,��ٰ�ߍ쐬 �߂�l=(�z�u���_,�p�x)
      (setq #sym (caddr #pos$))

      (setq #LSYM
        (list
          (nth 6 #fig$)         ;1 :�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID         ;2008/06/23 YM MOD
          (car   #pos$)         ;2 :�}���_          :�z�u��_
          (cadr  #pos$)         ;3 :��]�p�x        :�z�u��]�p�x
          CG_Kcode              ;4 :�H��L��        :CG_Kcode
          CG_SeriesCode         ;5 :SERIES�L��      :CG_SeriesCode
          (nth 0  #fig$)        ;6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���       ;2008/06/23 YM MOD
          (nth 1  #fig$)        ;7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪    ;2008/06/23 YM MOD
          ""                    ;8 :���}�`ID        :                            OK!
          ""                    ;9 :���J���}�`ID    :                            OK!
          (fix #seikaku)        ;10:���iCODE        :�w�i�Ԋ�{�x.���iCODE
          0                     ;11:�����t���O      :�O�Œ�i�P�ƕ��ށj
          &recno                ;12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
          (fix (nth 2 #fig$))   ;13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�       ;2008/06/23 YM MOD
          (fix (nth 5 #fig$))   ;14:���@�g          :�w�i�Ԑ}�`�x.���@�g         ;2008/06/23 YM MOD
          (fix (nth 17 &pln$))  ;15.�f�ʎw���̗L��  :�w�v���\���x.�f�ʗL��       OK!
          (GetBunruiAorD)       ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
        );_list
      )
    )
  );_if

  ;������ ���[�g�� ������
  ;2009/11/30 YM ADD ���[�g��̂Ƃ�������z�u�����c��
;;; (if (and (= "SD" CG_PlanType)
;;;          (/= CG_SeriesDB "SDA")) ;2011/02/01 YM MOD�yPG����z
  (if (= BU_CODE_0006 "1") 
    (progn ;���[��SDA�ȊO�̂Ƃ�

      (if (= 717 #seikaku)
        (progn ;���[�g��Ŷ�����Ȃ�
          ;;;<ؽČ`��>
          ;;;1 ��ԍ�(1,2,3,..)
          ; CG_D_EXTEND_KAI
          ;;;2 ���s
          (setq #DD (nth (+ (* 100 CG_D_EXTEND_KAI) 53) CG_GLOBAL$))
          ;;;3 ��{�\�� ���CODE(A or B)
          (setq #BASE_CODE$
            (CFGetDBSQLRec CG_DBSESSION "C�J�E���^���"
               (list
                 (list "��{�\��" (nth (+ (* 100 CG_D_EXTEND_KAI) 54) CG_GLOBAL$) 'STR)
               )
            )
          )
          (setq #BASE_CODE$ (DBCheck #BASE_CODE$ "�wC�J�E���^��ށx" "\n PKC_LayoutOneParts"))
          (setq #BASE_CODE (nth 2 #BASE_CODE$))
          ;;;4 �Ԍ�
          (setq #WW (nth (+ (* 100 CG_D_EXTEND_KAI) 55) CG_GLOBAL$))
          ;;;5 EP�L��(Y or N)
          (setq #EP_EXIST$
            (CFGetDBSQLRec CG_DBSESSION "C�G���h�p�l���L��"
               (list
                 (list "�G���h�p�l��" (nth (+ (* 100 CG_D_EXTEND_KAI) 71) CG_GLOBAL$) 'STR)
               )
            )
          )
          (setq #EP_EXIST$ (DBCheck #EP_EXIST$ "�wC�G���h�p�l���L���x" "\n PKC_LayoutOneParts"))
          (setq #EP_EXIST (nth 2 #EP_EXIST$))
          (if (= CG_LAST CG_D_EXTEND_KAI);�ŏI���"N"���������قȂ������Ƃ���(������ڑ�����ɉe��)
            (setq #EP_EXIST "N")
          );_if
          ;;;6 �}�`�}����_
          (setq #PT (car   #pos$))
          ;;;7 �V���{���}�`�����
;;;         (setq #hand_sym (cdr (assoc 5 (entget #sym))))

          ;8 �i�Ԗ���
          (setq #hinban (nth 0  #fig$))
          ;9 ������F
          (setq #CT_COL (nth (+ (* 100 CG_D_EXTEND_KAI) 57) CG_GLOBAL$))

          (setq #counter$
            (list
              CG_D_EXTEND_KAI ;1 ��ԍ�(1,2,3,..)
              #DD             ;2 ���s
              #BASE_CODE      ;3 ��{�\�� ���CODE(A or B)
              #WW             ;4 �Ԍ�
              #EP_EXIST       ;5 EP�L��(Y or N)
              #sym            ;6 �V���{���}�`�������
              #hinban         ;7 �i�Ԗ���
              #CT_COL         ;8 ������F
            )
          )
          ;Xdata�ɏ����i�[
          (CFSetXData #sym "G_COUNTER" #counter$)
;;;         (setq CG_COUNTER_INFO$$ (append CG_COUNTER_INFO$$ (list #counter$ )))
        )
      );_if

    )
  );_if
  ;�������@���[�g��@������

  (list #LSYM #sym)
);PKC_LayoutOneParts

;;;<HOM>*************************************************************************
;;; <�֐���>     : PKC_InsertParts
;;; <�����T�v>   : ���ނ�z�u����
;;; <�߂�l>     :   ;// �z�u���_�Ɗp�x��Ԃ�  (list #pos #ang)
;;;         LIST : (�z�u���_ �z�u�p�x)
;;; <�쐬>       : 2000.1.18�C�� YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun PKC_InsertParts (
  &pln$  ;(LIST)�w�v���\���x���
  &fig$  ;(LIST)�w�i�Ԑ}�`�x���
  &seikaku ; ���iCODE
  /
  #vct-x    ;�z�u���� X
  #vct-y    ;�z�u���� Y
  #op-x     ;���_����̋��� X
  #op-y     ;���_����̋��� Y
  #op-z     ;���_����̋��� Z
  #pts-w    ;���ނ̌��� W
  #pts-d    ;���ނ̌��� D
  #dim-w    ;���@ W
  #ANG #ANG2 #DWG #ELM #N #POS #SSP #SYM #K #MSG
  )
  (setq #vct-x (nth 7 &pln$))  ; ������
  (setq #vct-y (nth 8 &pln$))  ; ������
  (setq #op-x  (nth 9 &pln$))  ; ������
  (setq #op-y  (nth 10 &pln$)) ; ������

  ;2011/03/24 YM ADD-S NZ�׽�͒���BOX�����邪�ASA�׽�͒���BOX���Ȃ��̂ŋ���Y���߂Ȃ��Ƃ����Ȃ�
  (if CG_NO_BOX_FLG
    (setq #op-y (- #op-y CG_DIST_YY))
  );_if



  ;// �A�b�p�[�L���r�̔���       CG_SKK_TWO_UPP=2;�A�b�p�[(defined at GLOBAL.LSP)
;;;2008/09/11YM@DEL  (if (= CG_SKK_TWO_UPP (CFGetSeikakuToSKKCode &seikaku 2)) ; ���iCODE�̂Q���ڂ��Ƃ�
;;;2008/09/11YM@DEL    (setq #op-z CG_UpCabHeight)   ;Yes
    (setq #op-z  (nth 11 &pln$))  ;No  ; ������
;;;2008/09/11YM@DEL  );_if


  ;2011/05/09 YM ADD-S �݌ˉ��I�[�v��BOX�̔z�u�ɔ����݌ˍ����ύX
  ;����1:�݌ˉ��I�[�v��BOX����@PLAN59="N"�ȊO
  (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
    ;����2:���\���@PLAN?61="X"�ȊO  
    (if (/= (nth (+ (* 100 CG_D_EXTEND_KAI) 61) CG_GLOBAL$) "X")
      ;����3:�A�b�p�[�L���r
      (if (= CG_SKK_TWO_UPP (CFGetSeikakuToSKKCode &seikaku 2)) ; ���iCODE�̂Q���ڂ��Ƃ�
        (setq #op-z CG_WallUnderOpenBoxHeight) ;2150�Œ�
      );_if
    );_if
  );_if
  ;2011/05/09 YM ADD-E �݌ˉ��I�[�v��BOX�̔z�u�ɔ����݌ˍ����ύX

  ;2011/08/12 YM ADD KPCAD���݂Œ݌˂̏ꍇ�A�݌������ɔz�u����
  (if (and (= CG_PlanType "SK")(= CG_AUTOMODE 0)(= CG_SKK_TWO_UPP (CFGetSeikakuToSKKCode &seikaku 2)))
    (setq #op-z CG_UpCabHeight)
  );_if

  (setq #pts-w (fix (nth 12 &pln$))) ; �����v
  (setq #pts-d (fix (nth 13 &pln$))) ; �����c
  (setq #dim-w (advance (nth 3 &fig$) 10))  ; ���@�v ;2008/06/23 YM MOD

  (setq #ang (angle (list 0 0) (list #vct-x #vct-y)))
  (cond
    ((and (= #pts-w -1) (= #pts-d 1))
      (setq #ang2 (angle (list #vct-x #vct-y) (list 0. 0.)))
      (setq #pos (polar '(0 0) #ang2 (distance '(0 0) (list #op-x #op-y))))
      (setq #pos (polar #pos #ang2 #dim-w))
    )
    (T
      (setq #pos (list #op-x #op-y #op-z))
    )
  )
  (setq #pos (list (car #pos) (cadr #pos) #op-z))
  (setq #dwg (nth 6 &fig$)) ; �}�`�h�c ;2008/06/23 YM MOD

  (if (= #dwg nil) ; 00/11/14 YM ADD
    (progn
      (setq #msg (strcat "\n�w�i�Ԑ}�`�x�ɐ}�`ID�����o�^�ł��B\n" (nth 0 &fig$)));2008/06/23 YM MOD
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_if


  (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")))
    (progn
      (setq #msg (strcat "�}�`ID: [" #dwg "] ������܂���"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  ;else
    (progn
      ;���ނ̑}��
      (command "_insert" (strcat CG_MSTDWGPATH #dwg) #pos 1 1 (rtd #ang))

      ;GSM���ذ�ށAۯ�����Ă���\�������邽�߉�������
      (command "_layer" "T" "*" "")                   ;�S��w�t���[�Y����
      (command "_layer" "U" "*" "")                   ;�S��w���b�N����

      ;�z�u���_�Ɗp�x���m��
      (setq #pos (cdr (assoc 10 (entget (entlast)))))
      (setq #ang (cdr (assoc 50 (entget (entlast)))))

      ;����&�O���[�v��
      (command "_explode" (entlast))                    ;�C���T�[�g�}�`����
;;; <SKMkGroup>
;;; ���������}�`�Q�Ŗ��O�̂Ȃ��O���[�v�쐬
;;; ��O���t�B�J���}�` entmakex "GROUP"
;;; (dictadd (namedobjdict) "ACAD_GROUP" �}�`��)

      (SKMkGroup (ssget "P"))

      (setq #ssP (ssget "P" '((0 . "POINT")))) ; ���O�ɍ��ꂽ�I��Ă̒������߲�Ă΂��肠�߂�
      (setq #n 0 #k 0)

      (if #ssP ;04/01/24 YM ADD #ssP=nil�̏ꍇ
        (repeat (sslength #ssP)
          (setq #elm (ssname #ssP #n))
          (if (CFGetXData #elm "G_SYM")
            (progn
              (setq #sym #elm)
              (setq #k (1+ #k))
              (if (>= #k 2)
                (progn
                  (setq #msg (strcat "\n������}�`��\"G_SYM\"����������܂��B\n" #dwg))
                  (if (= CG_AUTOMODE 2) ; 02/09/04 YM ADD
                    (WebOutLog #msg)    ; 02/09/04 YM ADD
                    (CFAlertMsg #msg)
                  )
                )
              );_if
            )
          );_if
          (setq #n (1+ #n))
        );repeat
      );_if
    )
  );_if

  ;04/01/26 YM ADD-S �݌˂�INSERT���ʂ����̂����������Ȃ�
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  ;04/01/26 YM ADD-E ���̏�������ꂽ�璼����

  (WebOutLog "�P�ƕ��ނ�z�u���܂���")
  ;// �z�u���_�Ɗp�x,����ق�Ԃ�
  (list #pos #ang #sym)
);PKC_InsertParts

;;;<HOM>*************************************************************************
;;; <�֐���>     : PKC_LayoutBlockParts
;;; <�����T�v>   : �����\�����ޔz�u
;;; <�߂�l>     :
;;; <�C��>       : 2000.1�C�� YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun PKC_LayoutBlockParts (
  &pln$  ;(LIST)�w�v���\���x���
  &recno ;(INT) �z�u�ԍ�
  /
  #BLK$$ #FIGBASE$ #FLG #HNO #I #LR #MSG #QRY$ #SEIKAKU #SQL #STYP #TWO #YNO
  #DWG #LIST$$ #Kiki$ #GAS$ #GAS$$ #Sum_W
  #ANG #HIN_TYP #RET$ #XX #YY #ZZ #DAN
  #IPA_HOOD$ #IPA_HOOD$$ #XXX #YYY #ZZZ
  #DIRY #OBUN$ #OBUN$$ #YOKOMAKU$ #YOKOMAKU$$ #SYM
#RECNO
#ADDXX #ADDYY #ADDZZ #ORGXX #ORGYY #ORGZZ ;2017/10/05 YM ADD
  )
  (setq #styp (nth 6 &pln$)) ;���i�^�C�v ;2008/06/23 YM MOD

  (if CG_NO_BOX_FLG
    ;���i����5
    (if (equal #styp 5.0 0.001);��������
      ;����Y���۰��قŎc��
      (setq CG_DIST_YY (nth 10 &pln$))
    );_if
  );_if

  ;2008/11/15 YM ADD-S ̰�ނ̂ݑΉ�
  ;���i����=6
  (if (equal #styp 6.0 0.001);ֺϸ��
    (progn ;̰�ނ̂ݑΉ��̓��� �����Ŕz�u�������s��

      ;[����������]������
      (setq #YOKOMAKU$$
        (CFGetDBSQLRec CG_DBSESSION "����������"
           (list
             (list "�L��"     (nth 23 CG_GLOBAL$) 'STR)
             (list "�݌ˍ���" (nth 32 CG_GLOBAL$) 'STR)
           )
        )
      )
      ;2009/11/24 YM MOD
      (setq #YOKOMAKU$ (DBCheck2 #YOKOMAKU$$ "�w���������x" "\n PKC_LayoutBlockParts"))
      (if #YOKOMAKU$
        (progn
          (setq #HNO (nth  2 #YOKOMAKU$));�i�Ԗ���
          (setq #LR  (nth  3 #YOKOMAKU$));LR�敪
          (setq #XX  (nth  9 &pln$))
          (setq #YY  (nth 10 &pln$))
					(setq #ZZ  CG_UpCabHeight)

          (setq #dirY (nth 8 &pln$)) ;����Y=0(I�^),-1(L�^)
          (cond
            ((equal #dirY 0.0 0.001);I�^
              (setq #ANG 0.0);�x
            )
            ((equal #dirY -1.0 0.001);L�^
              (setq #ANG -90.0);�x
            )
          );_cond

          ;�z�u
          (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
        )
      );_if

    )
    (progn ;�]���ǂ���̓���
      (setq #ret$ (PKGetSQL_HUKU_KANRI &pln$ #styp)) ; �����Ǘ����� SQL�����߂�
      (setq #qry$  (nth 0 #ret$))
      (setq #blk$$ (nth 1 #ret$))
    )
  );_if

  (cond
    ;���i����=1,5,7
    ((or (equal #styp  1.0 0.001) ;��������
         (equal #styp  5.0 0.001) ;��������
         (equal #styp 11.0 0.001) ;�ڰѷ��ݶ���
         (equal #styp  7.0 0.001));����BOX 2010/10/13 YM ADD

      (foreach #blk$ #blk$$
        (setq #HNO (nth 2 #blk$))  ;�i�Ԗ���
        (setq #LR  (nth 3 #blk$))  ;LR�敪
        (setq #XX  (nth 4 #blk$))
        (setq #YY  (nth 5 #blk$))
        ;2011/03/24 YM ADD-S NZ�׽�͒���BOX�����邪�ASA�׽�͒���BOX���Ȃ��̂ŋ���Y���߂Ȃ��Ƃ����Ȃ�
        (if CG_NO_BOX_FLG
          (setq #YY (- #YY CG_DIST_YY))
        );_if
        (setq #ZZ  (nth 6 #blk$))
        (setq #ANG (nth 7 #blk$))
        ;�z�u
        (TK_PosParts #HNO #LR (list #XX #YY #ZZ) #ANG nil "A")
      );foreach
    );���i����=1,5,7,11


    ;���i����=12,14
    ((or (equal #styp 12.0 0.001)(equal #styp 14.0 0.001)) ;(�������,�����H��)

		 	;���΍��W�ɔz�u�y�v���\���z�̍��W
      (setq #orgXX  (nth  9 &pln$))
      (setq #orgYY  (nth 10 &pln$))
      (setq #orgZZ  (nth 11 &pln$))

      (foreach #blk$ #blk$$
        (setq #HNO (nth 2 #blk$))  ;�i�Ԗ���
        (setq #LR  (nth 3 #blk$))  ;LR�敪
        (setq #XX  (nth 4 #blk$))
        (setq #YY  (nth 5 #blk$))
        (setq #ZZ  (nth 6 #blk$))
        (setq #ANG (nth 7 #blk$))

	      (setq #addXX  (+ #orgXX #XX))
	      (setq #addYY  (+ #orgYY #YY))
	      (setq #addZZ  (+ #orgZZ #ZZ))

        ;�z�u
        (TK_PosParts #HNO #LR (list #addXX #addYY #addZZ) #ANG nil "A")
      );foreach


	 	)

    ;���i����=2,3,4
    ((or (equal #styp 2.0 0.001)(equal #styp 3.0 0.001)(equal #styp 4.0 0.001));�]��ۼޯ�(���,�H��,̰��)

      ;// �v�����\���ɂĂ��łɔz�u�ς݂̐}�`���A����̊J�n��A�C�e���ԍ������}�`����ɂ���
      ;// �ݔ��ԍ���=0�̏ꍇ�͐擪�������}�`�̂���(0,0,0)�_�ɕ����}�`�̍ŏ��̕��ނ�
      ;// �z�u�����̐}�`�����ɘA���z�u���s��
      ;// �w�����\���x.�J�n��A�C�e���ԍ�
      ;// �w�����\���x�̃��R�[�h�����A��������
      (setq ST_BLKSTART T)
      (foreach #blk$ #blk$$
        (setq #recno (nth 1 #blk$))  ;recno
        (setq #HNO (nth 2 #blk$))    ;�i�Ԗ��� ;2008/06/23 YM MOD
        (setq #LR  (nth 3 #blk$))    ;LR�敪   ;2008/06/23 YM MOD
        (setq #YNO (nth 4 #blk$))    ;�p�r�ԍ� ;2008/06/23 YM MOD
        (setq #HIN_TYP (nth 9 #blk$));�i������(1:GAS , 2:OBUN , 3;SYOKUSEN , 3:�ׯėpHOOD )

        ;2011/03/31 YM ADD �H���p���ނ̕i�Ԃ��K�v
        (if (and (equal #styp 4.0 0.001)(equal #recno 1.0 0.001))
          (setq CG_SYOKUSEN_CAB #HNO)
        );_if

        (cond
          ((= #HIN_TYP "1")
            ;�y����GAS�z����������/////////////////////////////////////////////////////////////
            (setq #GAS$$
              (CFGetDBSQLRec CG_DBSESSION "����GAS"
                 (list
                   (list "�L��" (nth 20 CG_GLOBAL$) 'STR)
                 )
              )
            )
            (setq #GAS$ (DBCheck #GAS$$ "�w����GAS�x" "\n PKC_LayoutBlockParts"))
            (setq #HNO (nth 1 #GAS$));�i�Ԗ��� ;2008/06/23 YM MOD
            (setq #LR  (nth 2 #GAS$));LR�敪   ;2008/06/23 YM MOD
          )
          ((= #HIN_TYP "2")

            (setq #OBUN$$
              (CFGetDBSQLRec CG_DBSESSION "����OBUN"
                 (list
                   (list "�L��"       (nth 21 CG_GLOBAL$) 'STR)
                   (list "���s��"     (nth  7 CG_GLOBAL$) 'STR)
                   (list "�V����"   (nth 31 CG_GLOBAL$) 'STR)
                   (list "�V���N�L��" (nth 17 CG_GLOBAL$) 'STR);2013/12/26 YM ADD
                 )
              )
            )
            (setq #OBUN$ (DBCheck #OBUN$$ "�w����OBUN�x" "\n PKC_LayoutBlockParts"))
;2013/12/26 YM MOD-S
;;;            (setq #HNO (nth 3 #OBUN$));�i�Ԗ���
;;;            (setq #LR  (nth 4 #OBUN$));LR�敪
            (setq #HNO (nth 4 #OBUN$));�i�Ԗ���
            (setq #LR  (nth 5 #OBUN$));LR�敪
;2013/12/26 YM MOD-E
          )

          ((= #HIN_TYP "3")
            ;�y����HOOD�\���z����������/////////////////////////////////////////////////////////////
            (setq #IPA_HOOD$$
              (CFGetDBSQLRec CG_DBSESSION "����HOOD�\��"
                (list
                  (list "�V���N���Ԍ�"  (nth  4 CG_GLOBAL$) 'STR)
                  (list "���s��"        (nth  7 CG_GLOBAL$) 'STR)
                  (list "�i�Ԗ���"      #HNO                'STR)
                  (list "LR�敪"        #LR                 'STR)
                )
              )
            )
            (setq #IPA_HOOD$ (DBCheck #IPA_HOOD$$ "�w����HOOD�\���x" "\n PKC_LayoutBlockParts"))
            ;���W�Ɗp�x���擾
            (setq #xxx (nth 4 #IPA_HOOD$));X
            (setq #yyy (nth 5 #IPA_HOOD$));Y
            ;2011/08/18 YM MOD-S
            ;(setq #zzz (nth 6 #IPA_HOOD$));Z
            (setq #zzz CG_UpCabHeight);Z
            ;2011/08/18 YM MOD-E
            (setq #ang (nth 7 #IPA_HOOD$));ANG
          )

          (T
            nil
          )
        );_cond

        ;/////////////////////////////////////////////////////////////


        (setq #LIST$$
          (list
            (list "�i�Ԗ���"      #HNO           'STR)
            (list "LR�敪"        #LR            'STR)
            (list "�p�r�ԍ�"      (rtois #YNO)   'INT)
          )
        )

        (setq #qry$
          (CFGetDBSQLHinbanTable "�i�Ԑ}�`" #HNO ;�i�Ԗ���
            #LIST$$
          )
        )
        (WebOutLog "�i�Ԑ}�`�@��������:")
        (setq #qry$ (DBCheck #qry$ "�w�i�Ԑ}�`�x" "\n PKC_LayoutBlockParts"))

        (setq #LIST$$
          (list
            (list "�i�Ԗ���" (nth 0 #qry$) 'STR);2008/06/23 YM MOD
          )
        )


        (setq #figBase$
          (CFGetDBSQLHinbanTable "�i�Ԋ�{" (nth 0 #qry$) ;2008/06/23 YM MOD
            #LIST$$
          )
        )
        (setq #figBase$ (DBCheck #figBase$ "�w�i�Ԋ�{�x" "\n PKC_LayoutBlockParts"))

        (setq #seikaku (fix (nth 3 #figBase$))) ;2008/06/23 YM MOD
        (setq #two (CFGetSeikakuToSKKCode #seikaku 2)) ; ���iCODE��2����=1

        (setq #Flg T)
        (cond
;;;         ((= #two CG_SKK_TWO_BAS)   ; ���iCODE��1==>�x�[�X   CG_SKK_TWO_BAS=1
;;;           (if (/= CG_UnitBase "1") ; CG_UnitBase="1" �t���A�z�u�t���O
;;;             (setq #Flg nil)
;;;           )
;;;         )
          ((= #two CG_SKK_TWO_UPP)   ; ���iCODE��2==>�A�b�p�[ CG_SKK_TWO_BAS=2
            (if (= (nth 32 CG_GLOBAL$) "N"); CG_UnitUpper="1" �E�H�[���z�u�t���O
              (setq #Flg nil)
            )
          )
          (T
            (setq #Flg T)            ; �x�[�X�A�A�b�p�[�ȊO
          )
        );_cond

        (if #Flg
          (progn
            (setq #dwg (nth 6 #qry$)) ; �}�`ID ;2008/06/23 YM MOD

            (if (= #dwg nil)
              (progn
                (setq #msg (strcat "\n�w�i�Ԑ}�`�x�ɐ}�`ID�����o�^�ł��B\n" (nth 0 #qry$)))
                (CMN_OutMsg #msg)
              )
            );_if


            ;// �����\�����̔z�u�����t���O�ɂ��A�A���z�u���s��
            ;//  ��=0
            ;//  �t=1
            ;//  ��=2
            ;//  ��=3
            ;//  �P��=4
            ;//  �R������t��=5
            ;//  �����_=6


;2010/11/09 YM MOD-S
;;;           (if (= #HIN_TYP "3")
;;;             (progn ;�Ζʗp̰�ނ̏ꍇ ;2010/11/09 ���� SKA P�^̰��
;;;               ;�z�u
;;;               (TK_PosParts #HNO #LR (list #xxx #yyy #zzz) #ANG 1)
;;;             )
;;;             (progn ;2010/11/09 ����I�^̰�ނ͂������ʂ�
;;;               (PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
;;;             )
;;;           );_if

            (setq CG_P_HOOD_SYM nil);������
            (setq CG_HOOD_FLG   nil);������
            (cond
              ((= #HIN_TYP "3")
                ;��ۼޯ��Ζʗp̰�ނ̏ꍇ[����HOOD�\��]������W�����߂� ;2010/11/09 ���� �]��SKA P�^̰��
                (TK_PosParts #HNO #LR (list #xxx #yyy #zzz) #ANG 1 "A")
                (setq CG_HOOD_FLG "PP");P�^��P�^̰��
              )
              ((and (= "I00" (nth  5 CG_GLOBAL$))
                    (= #HIN_TYP "4"))
                ;2010/11/09 I�^��I�^̰�ނ͂������ʂ�
                (PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
                (setq CG_HOOD_FLG "II");I�^��I�^̰��
              )
              ((and (= "I00" (nth  5 CG_GLOBAL$))(= #HIN_TYP "33"))
                ;2010/11/09 �yI�^��P�^̰�ށz(�z�u�ʒu�����v�Z) ��U���_�ɔz�u���Č�ňړ�����
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 270.0 1 "A"))
                (setq CG_HOOD_FLG "IP");I�^��P�^̰��
              )
              ;2011/05/21 YM MOD
;;;             ((or (and (= "IPA" (nth  5 CG_GLOBAL$))(= #HIN_TYP "33"))
              ((or (and (wcmatch (nth  5 CG_GLOBAL$) "IP*" )(= #HIN_TYP "33"))
                   (and (wcmatch (nth  5 CG_GLOBAL$) "G*" )(= #HIN_TYP "33")))
                ;2010/11/09 �yP�^��P�^̰�ށz(�z�u�ʒu�����v�Z) ��U���_�ɔz�u���Č�ňړ�����
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 270.0 1 "A"))
                (setq CG_HOOD_FLG "PP");P�^��P�^̰��
              )
              ;2011/05/21 YM MOD
;;;             ((or (and (= "IPA" (nth  5 CG_GLOBAL$))(= #HIN_TYP  "4"))
              ((or (and (wcmatch (nth  5 CG_GLOBAL$) "IP*" )(= #HIN_TYP  "4"))
                   (and (wcmatch (nth  5 CG_GLOBAL$) "G*" )(= #HIN_TYP  "4")))
                ;2010/11/09 �yP�^��I�^̰�ށz(�z�u�ʒu�����v�Z) ��U���_�ɔz�u���Č�ňړ�����
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 000.0 1 "A"))
                (setq CG_HOOD_FLG "PI");P�^��I�^̰��
              )
              (T ;�]���i������=0��̰�ނ͂�����ʂ�
                (PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
              )
            );_cond

;2010/11/09 YM MOD-E


          )
        );_(if #Flg

        (setq ST_BLKSTART nil)
      );_(foreach #blk$ #blk$$

    );���i����=2,3,4


    ;2011/01/26 YM ADD
    ;���i����=9 �V��
    ((equal #styp 9.0 0.001);�����Ǘ����g��Ȃ�̰�ވ�����

      (setq ST_BLKSTART T)
      (foreach #blk$ #blk$$
        (setq #HNO (nth 3 #blk$))    ;�i�Ԗ���
        (setq #LR  (nth 4 #blk$))    ;LR�敪
        (setq #YNO 0.0)              ;�p�r�ԍ�
        (setq #HIN_TYP (nth 5 #blk$));�i������( 4:I�^HOOD , 33:�ׯėpHOOD )

        (setq #LIST$$
          (list
            (list "�i�Ԗ���"      #HNO           'STR)
            (list "LR�敪"        #LR            'STR)
            (list "�p�r�ԍ�"      (rtois #YNO)   'INT)
          )
        )

        (setq #qry$
          (CFGetDBSQLHinbanTable "�i�Ԑ}�`" #HNO ;�i�Ԗ���
            #LIST$$
          )
        )
        (WebOutLog "�i�Ԑ}�` ��������:")
        (setq #qry$ (DBCheck #qry$ "�w�i�Ԑ}�`�x" "\n PKC_LayoutBlockParts"))

        (setq #LIST$$
          (list
            (list "�i�Ԗ���" (nth 0 #qry$) 'STR)
          )
        )

        (setq #figBase$
          (CFGetDBSQLHinbanTable "�i�Ԋ�{" (nth 0 #qry$)
            #LIST$$
          )
        )
        (setq #figBase$ (DBCheck #figBase$ "�w�i�Ԋ�{�x" "\n PKC_LayoutBlockParts"))

        (setq #seikaku (fix (nth 3 #figBase$)))
        (setq #two (CFGetSeikakuToSKKCode #seikaku 2)) ; ���iCODE��2����=1

        (setq #Flg T)
        (cond
          ((= #two CG_SKK_TWO_UPP)   ; ���iCODE��2==>�A�b�p�[ CG_SKK_TWO_BAS=2
            (if (= (nth 32 CG_GLOBAL$) "N"); CG_UnitUpper="1" �E�H�[���z�u�t���O
              (setq #Flg nil)
            )
          )
          (T
            (setq #Flg T)            ; �x�[�X�A�A�b�p�[�ȊO
          )
        );_cond

        (if #Flg
          (progn
            (setq #dwg (nth 6 #qry$)) ; �}�`ID

            (if (= #dwg nil)
              (progn
                (setq #msg (strcat "\n�w�i�Ԑ}�`�x�ɐ}�`ID�����o�^�ł��B\n" (nth 0 #qry$)))
                (CMN_OutMsg #msg)
              )
            );_if

            (setq CG_P_HOOD_SYM nil);������
            (setq CG_HOOD_FLG   nil);������
            (cond
              ((= #HIN_TYP "3") ;�����͒ʂ�Ȃ�
                ;��ۼޯ��Ζʗp̰�ނ̏ꍇ[����HOOD�\��]������W�����߂� ;2010/11/09 ���� �]��SKA P�^̰��
                (TK_PosParts #HNO #LR (list #xxx #yyy #zzz) #ANG 1 "A")
                (setq CG_HOOD_FLG "PP");P�^��P�^̰��
              )
              ((and (= "I00" (nth  5 CG_GLOBAL$))
                    (= #HIN_TYP "4"))
                ;2010/11/09 I�^��I�^̰�ނ͂������ʂ�
                (PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
                (setq CG_HOOD_FLG "II");I�^��I�^̰��
              )
              ((and (= "I00" (nth  5 CG_GLOBAL$))(= #HIN_TYP "33"))
                ;2010/11/09 �yI�^��P�^̰�ށz(�z�u�ʒu�����v�Z) ��U���_�ɔz�u���Č�ňړ�����
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 270.0 1 "A"))
                (setq CG_HOOD_FLG "IP");I�^��P�^̰��
              )
              ;2011/05/21 YM MOD
;;;             ((or (and (= "IPA" (nth  5 CG_GLOBAL$))(= #HIN_TYP "33"))
              ((or (and (wcmatch (nth  5 CG_GLOBAL$) "IP*" )(= #HIN_TYP "33"))
                   (and (wcmatch (nth  5 CG_GLOBAL$) "G*" )(= #HIN_TYP "33")))
                ;2010/11/09 �yP�^��P�^̰�ށz(�z�u�ʒu�����v�Z) ��U���_�ɔz�u���Č�ňړ�����
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 270.0 1 "A"))
                (setq CG_HOOD_FLG "PP");P�^��P�^̰��
              )
              ;2011/05/21 YM MOD
;;;             ((or (and (= "IPA" (nth  5 CG_GLOBAL$))(= #HIN_TYP  "4"))
              ((or (and (wcmatch (nth  5 CG_GLOBAL$) "IP*" )(= #HIN_TYP  "4"))
                   (and (wcmatch (nth  5 CG_GLOBAL$) "G*" )(= #HIN_TYP  "4")))
                ;2010/11/09 �yP�^��I�^̰�ށz(�z�u�ʒu�����v�Z) ��U���_�ɔz�u���Č�ňړ�����
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 000.0 1 "A"))
                (setq CG_HOOD_FLG "PI");P�^��I�^̰��
              )

              ((and (wcmatch (nth  5 CG_GLOBAL$) "L*" )(= #HIN_TYP "33"));L�^P�t�[�h
                ;2017/07/04 �yL�^��P�^̰�ށz(�z�u�ʒu�����v�Z) ��U���_�ɔz�u���Č�ňړ�����
                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 180.0 1 "A"))
                (setq CG_HOOD_FLG "LP");L�^��P�^̰��
              )
              ((and (wcmatch (nth  5 CG_GLOBAL$) "L*" )(= #HIN_TYP "4"));L�^I�t�[�h
                ;2017/07/04 �yL�^��I�^̰�ށz(�z�u�ʒu�����v�Z) ��U���_�ɔz�u���Č�ňړ�����
;;;                (setq CG_P_HOOD_SYM (TK_PosParts #HNO #LR (list 0.0 0.0 CG_UpCabHeight) 270.0 1 "A"))
;;;                (setq CG_HOOD_FLG "LI");L�^��I�^̰��
								(PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
              )


              (T ;�]���i������=0��̰�ނ͂�����ʂ�
                (PKC_PosBlkByType &pln$ #blk$ #qry$ #figBase$ &recno)
              )
            );_cond

          )
        );_(if #Flg

        (setq ST_BLKSTART nil)
      );_(foreach #blk$ #blk$$

    );���i����=9 �V��


  );_cond

  (WebOutLog "�������ނ�z�u���܂���")
  (princ)
);PKC_LayoutBlockParts


;<HOM>*************************************************************************
; <�֐���>    : KPGetSinaType
; <�����T�v>  : ���i���ߎ擾
; <�߂�l>    : ���i����(�����l)
; <�쐬>      : 01/06/27 YM
; <���l>      : ���i����=2(�Ʒ���)
;*************************************************************************>MOH<
(defun KPGetSinaType (
  /
  #QRY$ #SINA_TYPE
  )

;;;(if CG_SeriesCode
;;; (princ (strcat "\n CG_SeriesCode = " CG_SeriesCode))
;;; (princ (strcat "\n CG_SeriesCode = nil"))
;;;);_if
;;;(if CG_SeriesDB
;;; (princ (strcat "\n CG_SeriesDB = " CG_SeriesDB))
;;; (princ (strcat "\n CG_SeriesDB = nil"))
;;;);_if

  (setq #qry$
    (CFGetDBSQLRecChk CG_CDBSESSION "SERIES" (list (list "SERIES�L��" CG_SeriesCode 'STR)
                                                     (list "SERIES����" CG_SeriesDB   'STR)))) ; 02/03/18 YM ADD CG_SeriesDB�ǉ�

;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #qry$)
;;;		;�ذ�ޕ�DB,����DB�Đڑ�
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E


  (if (= nil #qry$)
    (CFAlertErr "SERIES�e�[�u����������܂���")
  )
  (setq #SINA_Type (nth 9 #qry$)) ; ���i����
);KPGetSinaType

;------------------------------------------------------------------------
; 02/09/03 YM ADD �l�H�I�ɴװ�𔭐�������
(defun makeERR ( &STR / )
  (princ (strcat "\n0����l�H�G���[" &STR))
  (setq err (/ 0 0))
;;; (princ)
)
;------------------------------------------------------------------------

;;;<HOM>*************************************************************************
;;; <�֐���>    : timer
;;; <�����T�v>  : ����(�b)������҂�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 02/10/11 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun timer (
  &sec
  /
  #MIN #ST
  )
  (setq #min 1) ; �҂�����(��)
  (setq #st (* 86400 (getvar "TDINDWG"))) ; ��(�J�n��)
  (while (<= (- (* 86400 (getvar "TDINDWG")) #st) &sec)
    nil
  )
  (princ)
);timer




;;;<HOM>************************************************************************
;;; <�֐���>  : PKG_SetFamilyCode
;;; <�����T�v>: �L�b�`���p���͏����O���[�o���t�@�~���[�i��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun PKG_SetFamilyCode (
  &family$$    ;(LIST)�v����������ʂ̓��͏��
  /
  #key #hinban$ #str #height
  #SSIDEPANELTYPE #num #i
	#sa_H #ERR ;2011/12/19 YM ADD
  )
  (setq #key (strcat CG_SeriesCode "K"))
  (setq CG_Kcode  "K") ; �H��L��(���g�p)

  ;//---------------------------------------------------------------------
  ;// �����l��񂩂�p�����[�^��ݒ肷��
  (setq CG_FamilyCode (cadr (assoc "FamilyCode" &family$$)))

  ;2008/06/21 YM MOD
  ;�������@��۰��ٕϐ��̾��(0�`49�܂�) [SK����].PLAN??�Œ�`����Ă��Ȃ����̂�nil�l�@������
  (setq #i 0)
  (setq CG_GLOBAL$ nil)
  (repeat 150
    (if (< #i 10)
      (setq #num (strcat "0" (itoa #i)))
      (setq #num (itoa #i))
    );_if
    
    (setq CG_GLOBAL$ (append CG_GLOBAL$ (list (cadr (assoc (strcat #key #num) &family$$)))))
    (setq #i (1+ #i))
  );repeat

	;2013/11/19 YM ADD-S
	(setq CG_CeilHeight  (atoi (substr (nth 48 CG_GLOBAL$) 3 10))) ;�V�䍂��
	(setq CG_UpCabHeight (atoi (substr (nth 49 CG_GLOBAL$) 3 10))) ;��t����

  ; PlanInfo.cfg�̕ύX �^�C�~���O����������Ō�Ɉړ�
;;;  (ChangePlanInfo);2014/05/29 YM MOV

	;2013/11/19 YM ADD-E

;2011/12/19 YM ADD-S �V������
;����ID	�\����	�����l	�����l��
;PLAN46	1	X	-----
;PLAN46	2	N	��t���Ȃ�
	(if (and CG_GLOBAL$ (nth 46 CG_GLOBAL$) (/= (nth 46 CG_GLOBAL$) "N")(/= (nth 46 CG_GLOBAL$) "X"))
		(progn ;�V�䍂��,�݌��������� CG_CeilHeight , CG_UpCabHeight
			(setq #sa_H (- CG_CeilHeight CG_UpCabHeight))
			(setq #ERR nil)
			(cond
				((= "A" (nth 46 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 100.0) 0.01))
					(if (and (< -0.001 (- 100.0 #sa_H ))(> 100.001 (- 100.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
				((= "B" (nth 46 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 200.0) 0.01))
					(if (and (< -0.001 (- 200.0 #sa_H ))(> 100.001 (- 200.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
				((= "C" (nth 46 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 300.0) 0.01))
					(if (and (< -0.001 (- 300.0 #sa_H ))(> 100.001 (- 300.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
			);_cond
		)
	);_if

	(if (and CG_GLOBAL$ (nth 72 CG_GLOBAL$) (/= (nth 72 CG_GLOBAL$) "N")(/= (nth 72 CG_GLOBAL$) "X"))
		(progn ;�V�䍂��,�݌��������� CG_CeilHeight , CG_UpCabHeight
			(setq #sa_H (- CG_CeilHeight CG_UpCabHeight))
			(setq #ERR nil)
			(cond
				((= "A" (nth 72 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 100.0) 0.01))
					(if (and (< -0.001 (- 100.0 #sa_H ))(> 100.001 (- 100.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
				((= "B" (nth 72 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 200.0) 0.01))
					(if (and (< -0.001 (- 200.0 #sa_H ))(> 100.001 (- 200.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
				((= "C" (nth 72 CG_GLOBAL$))
				 	;2013/11/19 YM MOD-S
;;;					(if (< 0.0001 (+ (- #sa_H 300.0) 0.01))
					(if (and (< -0.001 (- 300.0 #sa_H ))(> 100.001 (- 300.0 #sa_H )))
				 	;2013/11/19 YM MOD-E
						nil ;OK
					 	;else
					 	(setq #ERR T)
				 	);_if
			 	)
			);_cond
		)
	);_if

	(if #ERR
		(progn
      (CFAlertMsg "\n�V�䖋���쐬�ł��܂���B�V�䍂���ƒ݌������̍������m�F�������B")
      (quit) ;�����I��
		)
	)

;2011/12/19 YM ADD-E �V������

  ;�y�b��[�u�z����L���̃Z�b�g
  (setq CG_DRSeriCode (nth 12 CG_GLOBAL$))
  (setq CG_DRColCode  (nth 13 CG_GLOBAL$))
  (setq CG_Hikite     (nth 14 CG_GLOBAL$))
  (setq CG_GasType    (nth 24 CG_GLOBAL$))  ;�K�X��

  ;2011/05/27 YM ADD �����ݗ��̐w�}�Ή�
  (setq CG_DRSeriCode_D (nth 12 CG_GLOBAL$));����
  (setq CG_DRColCode_D  (nth 13 CG_GLOBAL$));����
  (setq CG_Hikite_D     (nth 14 CG_GLOBAL$));����

  (setq CG_DRSeriCode_U (nth 112 CG_GLOBAL$));���
  (setq CG_DRColCode_U  (nth 113 CG_GLOBAL$));���
  (setq CG_Hikite_U     (nth 114 CG_GLOBAL$));���


  ; PlanInfo.cfg�̕ύX �^�C�~���O���������炱���Ɉړ�
  (ChangePlanInfo);2014/05/29 YM MOV


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

;;;  (setq CG_FilerCode       (cadr (assoc "SKOP04"           &family$$))) ;�V��̨װ
;;;  (setq CG_SidePanelCode   (cadr (assoc "SKOP05"           &family$$))) ;�������� ; 01/07/11 YM
;;;  (setq CG_UnitBase        (cadr (assoc "UNITBASE"         &family$$))) ;�۱�z�u�׸�
;;;  (setq CG_UnitUpper       (cadr (assoc "UNITUPPER"        &family$$))) ;���ٔz�u�׸�
;;;  (setq CG_UnitTop         (cadr (assoc "UNITTOP"          &family$$))) ;ܰ�į�ߔz�u�׸�

  ;2008/06/21 YM ���O�ɏo�͂��Ȃ�(�Q�Ƃ��邱�Ƃ͂Ȃ��A���΂��΃G���[�����ɂȂ�)
;;;  (PcPrintLog)

  (if (= CG_DBSESSION nil)
    (CFAlertErr "ODBC���������ݒ肳��Ă��邩�m�F���ĉ�����\n PKG_SetFamilyCode")
  )

;;;   ;// 2.�V��t�B���[�i�Ԃ̎擾
;;;   (if (= CG_FilerCode "N")
;;;     (progn
;;;       ;// �V��t�B���[�Ȃ�
;;;       (setq CG_FilerCode nil)
;;;     )
;;;     (progn
;;;       ;// �V��t�B���[�i�Ԃ̎擾
;;;       (setq #hinban$ (SKG_GetOptionHinbanFIRL CG_FilerCode)) ; 01/12/18 YM MOD ̨װ��p��ׁ�OP�����֐�
;;;       (setq CG_FilerCode (car #hinban$))
;;;     )
;;;   )

;;;  ;// 3.�T�C�h�p�l���i�ԁi��������j�̎擾 ; 01/07/11 YM ADD
;;;  (if (or (= CG_SidePanelCode "")(= CG_SidePanelCode nil))
;;;   (setq CG_SidePanel$ nil)         ;�T�C�h�p�l��
;;;   ;else
;;;    (progn
;;;      (if (> CG_CeilHeight 2400)
;;;        (setq #height (itoa 2700))
;;;        (setq #height (itoa 2400))
;;;      );_if
;;;
;;;     (if (and CG_SidePanelCode (/= CG_SidePanelCode "N"))
;;;       (progn
;;;         ; �V�䍂���Ƴ��ٷ��ލ������l�����Ĕz�u���黲���������߂����߂� 01/12/19 YM ADD-S
;;;         (setq #sSidePanelType (NP_DesideSidePanelType))
;;;         ; ���َ��t�������ǉ�-->01/12/19 500 or 700 ��"H" or "L"�ɕύX(�����ǉ�)
;;;         (setq #hinban$ (SKG_GetSidePanelHinban 3 CG_SidePanelCode #height #sSidePanelType))
;;;       )
;;;     );_if
;;;
;;;      (setq CG_SidePanel$ #hinban$)
;;;    )
;;;  );_if

  (princ)
);PKG_SetFamilyCode

;<HOM>*************************************************************************
; <�֐���>    : SKG_GetSidePanelHinban
; <�����T�v>  : �������ق̕i�Ԃ��擾����
; <�߂�l>    : (�������ق̕i��,L/R)ؽ�
; <�쐬>      : 2003/12/03
; <���l>      : ���̿���ͻ������ق�L/R���Ȃ����Ƃ�O�񂾂���������(�������)�ɂ����L/R�����鹰��ɑΉ�
;               ([��COLOR]�Ɂu����LR�v̨���ޒǉ�)
;               ��DIPLOA�̻������ق͍ŏ�����L/R������A��(F*)�ɂ���ċ@�킪�ς��L/R�Ȃ�������
;               �ɂȂ鹰����łĂ�������[��׊�OP]�͂��̂܂܂�[��׍\OP]�̌����������C��
;*************************************************************************>MOH<
(defun SKG_GetSidePanelHinban (
  &type ;OP�i�敪
  &key1 ;(STR) �������ّI�����L��"A","D"�Ȃ�
  &key2 ;(INT) �������ق̏ꍇ--�V�䍂��
  &key3 ;(STR) �޲�ݸ�,�������ق̏ꍇ-����1����
  /
  #HINBAN$$ #LISTCODE #MSG #OPT$$ #QRY$ #SQL$
#HINBAN #LR_EXIST ; 03/12/17 YM ADD
  )

  ;// �I�v�V�����i�^�C�v�ɂ��I�v�V�����i�Ǘ��c�a����������
  ;�y��׊�OP�z�̌��������͍��܂łƓ��� 2003/12/3 =======================================��������������
  (setq #listCode nil)
  (setq #sql$
    (list
      (list "SERIES�L��" CG_SeriesCode  'STR)
      (list "���j�b�g�L��" CG_UnitCode  'STR)
      (list "OP�i�敪"     (itoa &type) 'INT)
    )
  )
  (if (/= &key1 nil)
    (setq #sql$
      (append #sql$
        (list (list "����KEY1" &key1 'STR))
      )
    )
  );_if
  (if (/= &key2 nil)
    (setq #sql$
      (append #sql$
        (list (list "����KEY2" &key2 'STR))
      )
    )
  );_if
  (if (/= &key3 nil)
    (setq #sql$
      (append #sql$
        (list (list "����KEY3" &key3 'STR))
      )
    )
  );_if
  ;// �v����OP�e�[�u������������
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "�v����OP" #sql$))
  (if (= #qry$ nil)
    (progn
      (setq #msg (strcat "�w�v����OP�x�Ƀ��R�[�h������܂���B\nSKG_GetOptionHinban"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    (progn
      (setq #qry$ (car #qry$))
      ;�y��׊�OP�z�̌��������͍��܂łƓ��� 2003/12/3 =======================================�����������܂�

      ;03/12/3 YM MOD �y��׍\OP�z���y�������فz������
      ;// �I�v�V�����Ǘ�ID�Ńv���\OP�e�[�u������������
      (setq #opt$$
        (CFGetDBSQLRec CG_DBSESSION "�T�C�h�p�l��"
          (list
            (list "OPTID" (rtois (car #qry$)) 'INT)
            (list "���V���L��" CG_DRSeriCode  'STR)
          )
        )
      )

      (if (= #opt$$ nil)
        (progn
          (setq #msg (strcat "�w�v���\OP�x�Ƀ��R�[�h������܂���B\nSKG_GetOptionHinban"))
          (CMN_OutMsg #msg)
        )
      );_if
      (foreach #opt$ #opt$$
        (setq #hinban   (nth 4 #opt$))
        (setq #LR_exist (nth 5 #opt$))
        (setq #hinban$$ (append #hinban$$ (list (list #hinban #LR_exist))))
      )
      ;// �i�Ԃ̃��X�g��Ԃ�
      #hinban$$
    )
  );_if
);SKG_GetSidePanelHinban

;;;<HOM>************************************************************************
;;; <�֐���>  : WEB_SetFilPanelCode
;;; <�����T�v>: �V��̨װ,�������ي֘A��۰��ِݒ�
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 02/08/02 YM
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun WEB_SetFilPanelCode (
  /
  #HEIGHT #HINBAN$ #SSIDEPANELTYPE
  )
  ; 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (WebOutLog "�V��̨װ,�������ي֘A��۰��ق�ݒ肵�܂�(WEB_SetFilPanelCode)")

  ;// 2.�V��t�B���[�i�Ԃ̎擾
  (if (or (= "N" CG_FilerCode)(= nil CG_FilerCode)(= "" CG_FilerCode)) ; 03/05/12 YM MOD
;;; (if (= CG_FilerCode "N")
   (progn
     ;// �V��t�B���[�Ȃ�
     (setq CG_FilerCode nil)
   )
   (progn
     (setq #hinban$ (SKG_GetOptionHinbanFIRL CG_FilerCode)) ; 01/12/18 YM MOD ̨װ��p��ׁ�OP�����֐�
     (setq CG_FilerCode (car #hinban$))
   )
  );_if

  ;// 3.�T�C�h�p�l���i�ԁi��������j�̎擾 ; 01/07/11 YM ADD
  (if (or (= CG_SidePanelCode "")(= CG_SidePanelCode nil))
    (setq CG_SidePanel$ nil)         ;�T�C�h�p�l��
    (progn
      (if (> CG_CeilHeight 2400)
        (setq #height (itoa 2700))
        (setq #height (itoa 2400))
      );_if

      (if (and CG_SidePanelCode (/= CG_SidePanelCode "N"))
        (progn
          ; �V�䍂���Ƴ��ٷ��ލ������l�����Ĕz�u���黲���������߂����߂� 01/12/19 YM ADD-S
          (setq #sSidePanelType (NP_DesideSidePanelType))
;;;04/04/15YM@DEL         ; ���َ��t�������ǉ�-->01/12/19 500 or 700 ��"H" or "L"�ɕύX(�����ǉ�)
;;;04/04/15YM@DEL         (setq #hinban$ (SKG_GetOptionHinban 3 CG_SidePanelCode #height #sSidePanelType nil)) ; 01/12/19 YM MOD

          ;04/04/15 YM MOD-S WEB�łɍX�V�R��
          ; ���َ��t�������ǉ�-->01/12/19 500 or 700 ��"H" or "L"�ɕύX(�����ǉ�)
          (setq #hinban$ (SKG_GetSidePanelHinban 3 CG_SidePanelCode #height #sSidePanelType))
          ;04/04/15 YM MOD-E WEB�łɍX�V�R��
        )
      );_if
      (setq CG_SidePanel$ #hinban$)
    )
  );_if

  ; 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (WebOutLog "�V��̨װ���� CG_FilerCode=")
  (WebOutLog CG_FilerCode)
  (WebOutLog "�������ٺ��� CG_SidePanelCode=")
  (WebOutLog CG_SidePanelCode)
  (WebOutLog " ")
  ; 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (princ)
);WEB_SetFilPanelCode

;;;<HOM>*************************************************************************
;;; <�֐���>    : NP_DesideSidePanelType
;;; <�����T�v>  : �V�䍂���Ƴ��ٷ��ލ������l�����Ĕz�u���黲���������߂����߂�
;;; <�߂�l>    : ������������ "H"==>����1000mm "L"==>����700mm
;;; <�쐬>      : 01/12/19 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun NP_DesideSidePanelType (
  /
  #DTYPE #FILH #ISIDEH
  )
  ; �V�䂩��̋󌄂ƕ��ނ̍�����r�B
  (setq #filH (- CG_CeilHeight CG_UpCabHeight)) ; ̨װ����
  ; CG_UpperCabHeight ; "500" "700"
  (setq #iSideH (+ #filH (atoi CG_UpperCabHeight))) ; ̨װ����+���ٍ���

;;;(setq CG_SidePanelLarge 1000) ; �������ّ�̐��@H
;;;(setq CG_SidePanelMidle  700) ; �������ْ��̐��@H
;;;(setq CG_SidePanelSmall  500) ; �������ُ��̐��@H
;;;CG_FloorSidePanel
  
  (cond
    ((and (> #iSideH (+ CG_SidePanelMidle 0.001))(< #iSideH (+ CG_SidePanelLarge 0.001))) ; 700���傫��1000��菬����
      (setq #dType "H") ; 1000mm�̻�������(��)��ʲ�����
    )
    ((and (> #iSideH (+ CG_SidePanelSmall 0.001))(<= #iSideH (+ CG_SidePanelMidle 0.001))) ; 500���傫��700��菬����
      (setq #dType "M") ; 700mm�̻�������(��)��ʲ�����
    )
    ((<= #iSideH (+ CG_SidePanelSmall 0.001)) ; 500�ȉ�
      (setq #dType "L") ; 500mm�̻�������(��)��ʲ�����
    )
    (T
      (CFAlertErr "�V�䍂�������m�F��������.�K�؂Ȼ������ق�����܂���.")
      (quit)
    )
  );_cond

  ; 01/12/26 YM ADD-S H875�ȏ�̂Ƃ��㉺�����۱�������ق�930mm�̕i�Ԃ̂��̂��g�p����
  (if (<= (- CG_FloorSidePanel 0.001) (atoi CG_BaseCabHeight)) ; �۱������875�ȏ�Ȃ�"+"�ǉ�
    (setq #dType (strcat #dType "+"))
  );_if
  ; 01/12/26 YM ADD-E

  #dType
);NP_DesideSidePanelType

;;;<HOM>*************************************************************************
;;; <�֐���>    : PFGetCompUpper
;;; <�����T�v>  : �\�����ގ擾(�\���^�C�v=2) CG_UnitUpper="1"
;;; <�߂�l>    : �v���\���x���̃��X�g
;;; <�쐬>      : 2000.1.19�C��KPCAD
;;; <���l>      : �A�b�p�[
;;;*************************************************************************>MOH<
(defun PFGetCompUpper (
  &qry$ ; �u�v���Ǘ��vں���
  /
  #I #MSG #QRY$ #QRY$$ #LIST$$ #DB_NAME #PLAN_ID
  )
  (setq #LIST$$
    (list
      (list "���j�b�g�L��"       (nth  3 CG_GLOBAL$) 'STR)
      (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
      (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
      (list "�\���^�C�v"         "2"                 'INT)
      (list "SOFT_CLOSE"         (nth  8 CG_GLOBAL$) 'STR)
      (list "�V��_�݌ˍ���"      (nth 32 CG_GLOBAL$) 'STR)
    )
  )

  (setq #DB_NAME "�v���Ǘ�")

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$)
  )

  (setq #qry$ (DBCheck #qry$ "�w�v���Ǘ��x" "PFGetCompUpper"))

  (if (= CG_TESTMODE 1) ; ý�Ӱ��
    (setq P_wallID (strcat "����ID(����)= [" (rtois (car #qry$)) "]"))
  );_if

  ; �v����ID
  (setq #plan_id (nth 0 #qry$))

  ;;;// �w�v���\���x�������A
  (setq #DB_NAME "�v���\��")

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME
      (list
        (list "�v����ID"  #plan_id  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  (if (= #qry$$ nil)
    (progn
      (setq #msg (strcat "�w�v���\���x�Ƀ��R�[�h������܂���B\nPFGetCompUpper"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_if


  #qry$$
);PFGetCompUpper

;;;<HOM>*************************************************************************
;;; <�֐���>     : PKGetSQL_HUKU_KANRI
;;; <�����T�v>   : �����Ǘ�������SQL�����߂�
;;; <�߂�l>     : SQLؽ�
;;; <�C��>       : 2000.6.27 YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun PKGetSQL_HUKU_KANRI (
  &pln$  ;(LIST)�w�v���\���x���
  &styp  ; ���i����
  /
  #HEI #LISTCODE #SQL #ZAIF #DB_NAME1 #DB_NAME2 #HUKU_ID #LIST$$ #MSG #PLAN_ID #QRY$ #QRY$$
  #T$ #T$$ #TTT #UNDER_GAS
  #PANEL_DB_NAME ;2009/04/14 YM ADD
  #HOOD_H ;2011/01/26 YM ADD
  )
  
  (cond

    ;// ��������
    ((= &styp 1)
      (setq #DB_NAME1 "�����p�l���Ǘ�")
      (setq #DB_NAME2 "�����p�l���\��")

      ;2009/04/14 YM ADD-S
      (if (wcmatch (nth  5 CG_GLOBAL$) "G*" )
        (setq #PANEL_DB_NAME "�p�l������_GATE");�ް�����
        ;else
        (setq #PANEL_DB_NAME "�p�l������");�ް����߈ȊO
      );_if
      ;2009/04/14 YM ADD-E

      (setq #T$$
        (CFGetDBSQLRec CG_DBSESSION #PANEL_DB_NAME
          (list
            (list "���V���L��"     (nth 12 CG_GLOBAL$) 'STR)
            (list "���J���L��"     (nth 13 CG_GLOBAL$) 'STR)
          )
        )
      )

      (setq #T$ (DBCheck #T$$ "�w�p�l�����݁x" "PKGetSQL_HUKU_KANRI"))
      (setq #TTT (nth 3 #T$));SP����
      (setq #LIST$$
        (list
          (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
          (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
          (list "���i�^�C�v"         "1"                 'INT)
          (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
          (list "�V����"           (nth 31 CG_GLOBAL$) 'STR)
          (list "�V���N�L��"         (nth 17 CG_GLOBAL$) 'STR);2008/09/20 YM ADD
          (list "����"               #TTT                'STR)
        )
      )

    )

    ;// ��������
    ((= &styp 5)
      (setq #DB_NAME1 "�����p�l���Ǘ�")
      (setq #DB_NAME2 "�����p�l���\��")

      ;2009/04/14 YM ADD-S
      (if (wcmatch (nth  5 CG_GLOBAL$) "G*" )
        (setq #PANEL_DB_NAME "�p�l������_GATE");�ް�����
        ;else
        (setq #PANEL_DB_NAME "�p�l������");�ް����߈ȊO
      );_if
      ;2009/04/14 YM ADD-E

      (setq #T$$
        (CFGetDBSQLRec CG_DBSESSION #PANEL_DB_NAME
          (list
            (list "���V���L��"     (nth 12 CG_GLOBAL$) 'STR)
            (list "���J���L��"     (nth 13 CG_GLOBAL$) 'STR)
          )
        )
      )
      (setq #T$ (DBCheck #T$$ "�w�p�l�����݁x" "PKGetSQL_HUKU_KANRI"))
      (setq #TTT (nth 4 #T$));FP����

      ;2011/03/29 YM ADD-S �V����ި�Ή� �ꍇ�킯
      (cond
        ((= BU_CODE_0008 "1") 
          ;SKB �ݸ�L����KEY�ɒǉ�
          (setq #LIST$$
            (list
              (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
              (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
              (list "���i�^�C�v"         "5"                 'INT)
              (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
              (list "�V����"           (nth 31 CG_GLOBAL$) 'STR)
              (list "����"               #TTT                'STR)
              (list "�V���N�L��"         (nth 17 CG_GLOBAL$) 'STR);2011/03/29 YM ADD
            )
          )
        )
        (T
          ;�]��
          (setq #LIST$$
            (list
              (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
              (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
              (list "���i�^�C�v"         "5"                 'INT)
              (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
              (list "�V����"           (nth 31 CG_GLOBAL$) 'STR)
              (list "����"               #TTT                'STR)
            )
          )
        )
      );_cond

    )

    ;2010/10/13 YM ADD-S
    ;// ����BOX
    ((= &styp 7)
      (setq #DB_NAME1 "��������BOX�Ǘ�")
      (setq #DB_NAME2 "��������BOX�\��")

      (setq #LIST$$
        (list
          (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
          (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
          (list "���i�^�C�v"         "7"                 'INT)
          (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
          (list "�V����"           (nth 31 CG_GLOBAL$) 'STR)
          (list "���V���L��"         (nth 12 CG_GLOBAL$) 'STR)
        )
      )
    )
    ;2010/10/13 YM ADD-E

    ;2017/09/07 YM ADD-S
    ;// �����J�E���^ ���i�^�C�v=11
    ((= &styp 11)
      (setq #DB_NAME1 "�����J�E���^�Ǘ�")
      (setq #DB_NAME2 "�����J�E���^�\��")

      (setq #LIST$$
        (list
          (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
          (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
          (list "�t���A�L���r�^�C�v" (nth  6 CG_GLOBAL$) 'STR) ;2017/10/05 YM ADD
          (list "���i�^�C�v"         "11"                'INT)
          (list "�H��ʒu"           (nth 10 CG_GLOBAL$) 'STR) ;2017/10/23 YM ADD
          (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
          (list "�J�E���^�ގ�"       (nth 16 CG_GLOBAL$) 'STR)
        )
      )
    )
    ;2017/09/07 YM ADD-E


    ;2017/09/07 YM ADD-S
    ;// �����R�����Ǘ� ���i�^�C�v=12 �ǉ����R�F�ڰѷ��݁u�޽�v�ŊC�O���Ɖ��ڰт��ω��A���قȂ������ĽدĕK�v�\�����ω�
    ((= &styp 12) ; 2017/10/05 YM ADD FK�Ή�
      (setq #DB_NAME1 "�����R�����Ǘ�")
      (setq #DB_NAME2 "�����R�����\��")

      (setq #LIST$$
        (list
          (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
          (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
          (list "���i�^�C�v"         "12"                'INT)
          (list "�t���A�L���r�^�C�v" (nth  6 CG_GLOBAL$) 'STR) ;2017/10/05 YM ADD
          (list "�V���N�ʒu"         (nth  2 CG_GLOBAL$) 'STR)
          (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
          (list "�V����"           (nth 31 CG_GLOBAL$) 'STR)
          (list "�R�����L��"         (nth 20 CG_GLOBAL$) 'STR)
        )
      )
    )
    ;2017/09/07 YM ADD-E


    ;2017/09/07 YM ADD-S
    ;// �����H��Ǘ� ���i�^�C�v=14 �ǉ����R�F�ڰѷ��݁u�H��450�v��аڐH���o�^����ƒI���s�v�ɂȂ��č\�����ω����邩��
    ((= &styp 14) ; 2017/10/05 YM ADD FK�Ή�
      (setq #DB_NAME1 "�����H��Ǘ�")
      (setq #DB_NAME2 "�����H��\��")

      (setq #LIST$$
        (list
          (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
          (list "���i�^�C�v"         "14"                'INT)
          (list "�H��ʒu"           (nth 10 CG_GLOBAL$) 'STR) ;2017/10/13 YM ADD
          (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
          (list "�V����"           (nth 31 CG_GLOBAL$) 'STR)
          (list "�H��L��"           (nth 42 CG_GLOBAL$) 'STR)
        )
      )
    )
    ;2017/09/07 YM ADD-E


    ;// �R����
    ((= &styp 2)
      (setq #DB_NAME1 "�����Ǘ�")
      (setq #DB_NAME2 "�����\��")

      ;2009/02/10 YM ADD-S
      (if (/= "B" (nth 21 CG_GLOBAL$))
        (setq #under_GAS "O");��۷��ނłȂ��ꍇ(�����)
        ;else
        (setq #under_GAS "B");��۷���
      );_if
     
      (setq #LIST$$
        (list
          (list "���j�b�g�L��"       (nth  3 CG_GLOBAL$) 'STR)
          (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
          (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
          (list "���i�^�C�v"         "2"                 'INT)
          (list "�t���A�L���r�^�C�v" (nth  6 CG_GLOBAL$) 'STR)
          (list "�V���N�ʒu"         (nth  2 CG_GLOBAL$) 'STR)
          (list "�R�����ʒu"         (nth  9 CG_GLOBAL$) 'STR)
          (list "�H��ʒu"           (nth 10 CG_GLOBAL$) 'STR)
          (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
          (list "�V���N�L��"         (nth 17 CG_GLOBAL$) 'STR);2008/09/17 YM ADD
          ;2009/02/10 YM ADD-S
;;;         (list "�R�������ݒu"       (nth 21 CG_GLOBAL$) 'STR)
          (list "�R�������ݒu"       #under_GAS          'STR)
          ;2009/02/10 YM ADD-E
          (list "SOFT_CLOSE"         (nth  8 CG_GLOBAL$) 'STR)
          (list "�V��_�݌ˍ���"      (nth 31 CG_GLOBAL$) 'STR)
          (list "�R�����e����"                       "_" 'STR);2009/02/06 YM MOD ���߂����Ή����鍀�ڂ����݂͂Ȃ�
        )
      )
    )

    ;// �����W�t�[�h
    ((= &styp 3)
      (setq #DB_NAME1 "�����Ǘ�")
      (setq #DB_NAME2 "�����\��")

      (setq #LIST$$
        (list
          (list "���j�b�g�L��"       (nth  3 CG_GLOBAL$) 'STR)
          (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
          (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
          (list "���i�^�C�v"         "3"                 'INT)
          (list "�V��_�݌ˍ���"      (nth 32 CG_GLOBAL$) 'STR)
          (list "HOOD�L��"           (nth 23 CG_GLOBAL$) 'STR)
        )
      )
    )

    
    ;�����W�t�[�h(SKB��p) 2011/01/26 YM ADD
    ((= &styp 9)
      (setq #DB_NAME1 "HOOD����")
      (setq #DB_NAME2 "����HOOD")

      ;̰�ނ̍��������߂�
      (setq #LIST$$
        (list
          (list "PLAN32"      (nth 32 CG_GLOBAL$) 'STR)
        )
      )
    )

    ;// �H��@��
    ((= &styp 4)
      (setq #DB_NAME1 "�����Ǘ�")
      (setq #DB_NAME2 "�����\��")

      (setq #LIST$$
        (list
          (list "���j�b�g�L��"       (nth  3 CG_GLOBAL$) 'STR)
          (list "���i�^�C�v"         "4"                 'INT)
          (list "�t���A�L���r�^�C�v" (nth  6 CG_GLOBAL$) 'STR)
          (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
          (list "�V���N�L��"         (nth 17 CG_GLOBAL$) 'STR);2008/10/06 YM ADD
          (list "SOFT_CLOSE"         (nth  8 CG_GLOBAL$) 'STR)
          (list "�V��_�݌ˍ���"      (nth 31 CG_GLOBAL$) 'STR)
          (list "�H��L��"           (nth 42 CG_GLOBAL$) 'STR)
        )
      )
    )

  );_cond



  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME1 #LIST$$)
  )

  ;2011/03/24 YM ADD-S
  (if (equal &styp 7.0 0.001)
    (progn
      ;[��������BOX�Ǘ�]��ں��ނ��Ȃ��������U�肳����
      ;�׸ނ𗧂ĂČ㑱����������,��t�����Y���W�����炷�K�v������
      (if (= nil #qry$)
        (setq CG_NO_BOX_FLG T)
        ;else
        (progn
          (setq CG_NO_BOX_FLG nil)
          (setq #qry$ (DBCheck #qry$ "�w����**�Ǘ��x" "PKGetSQL_HUKU_KANRI"))
        )
      );_if
    )
    (progn
      (setq #qry$ (DBCheck #qry$ "�w����**�Ǘ��x" "PKGetSQL_HUKU_KANRI")) ; ��������WEB��۸ޏo��
    )
  );_if

  ;�����\���@�܂��́@�y����HOOD�z
  (cond
    ;2010/10/13 YM MOD &styp=7 �ǉ�==> 2011/03/24 YM MOD &styp=7����
    ((or (equal &styp 1.0 0.001)(equal &styp 5.0 0.001))
      ; ����ID or ID
      (setq #huku_id (nth 0 #qry$))
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "ID"  #huku_id  'STR)
            (list "order by \"RECNO\"" nil  'ADDSTR)
          )
        )
      )
    )
    ;2010/10/13 YM MOD &styp=7 �ǉ�
    ((equal &styp 7.0 0.001)

      ; ����ID or ID
      (if CG_NO_BOX_FLG
        (progn
          nil ;[��������BOX�Ǘ�]��ں��ނ��Ȃ���U��
          (setq #qry$$ nil)
        )
        (progn
          (setq #huku_id (nth 0 #qry$))
          (setq #qry$$
            (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
              (list
                (list "ID"  #huku_id  'STR)
                (list "order by \"RECNO\"" nil  'ADDSTR)
              )
            )
          )
        )
      );_if

    )

    ;2017/09/07 YM ADD &styp=11 �ǉ�
    ((or (equal &styp 11.0 0.001)(equal &styp 12.0 0.001)(equal &styp 14.0 0.001)) ;�y�����J�E���^�\���z�y�����H��\���z�y�����R�����\���z2017/10/05 YM ADD FK�Ή�

  		; ����ID or ID
      (setq #huku_id (nth 0 #qry$))
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "ID"  #huku_id  'STR)
            (list "order by \"RECNO\"" nil  'ADDSTR)
          )
        )
      )

    )


    ((or (equal &styp 2.0 0.001)(equal &styp 3.0 0.001)(equal &styp 4.0 0.001) )

      ; ����ID or ID
      (setq #huku_id (nth 0 #qry$))

      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "����ID"  #huku_id  'STR)
            (list "order by \"RECNO\"" nil  'ADDSTR)
          )
        )
      )
    )

    ;2011/01/26 YM ADD �y�����Ǘ��z���g�킸��̰�ނ��������Ă�d�g��
    ((equal &styp 9.0 0.001)

      ; ̰�ލ���
      (setq #HOOD_H (nth 1 #qry$))

;  &pln$  ;(LIST)�w�v���\���x���
;  &styp  ; ���i����

      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION #DB_NAME2
          (list
            (list "PLAN23"   (nth 23 CG_GLOBAL$) 'STR)
            (list "�Ԍ�"     (nth  2 &pln$)      'STR);"HOOD750","HOOD900"��z��
            (list "����"     #HOOD_H             'STR)
          )
        )
      )
    )

    
  );_cond

  (if CG_NO_BOX_FLG
    nil
    ;else
    (if (= #qry$$ nil)
      (progn
        (setq #msg (strcat "�w����**�\���x�Ƀ��R�[�h������܂���B\nPKGetSQL_HUKU_KANRI"))
        (CMN_OutMsg #msg)
      )
    );_if
  );_if
  
  (list #qry$ #qry$$)
);PKGetSQL_HUKU_KANRI

;;;<HOM>*************************************************************************
;;; <�֐���>    : FK_PosWTR_plan
;;; <�����T�v>  : ������z�u����(�ڰѷ��݁@�v��������)
;;; <�߂�l>    :
;;;        LIST : ������(G_WTR)�}�`�̃��X�g
;;; <�쐬>      : 2017/10/11 YM ADD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun FK_PosWTR_plan (
  /
	#ANA_LAYER #ANG #DB_NAME #DUM_EN #DWG #EN #FIG-QRY$ #HH #HINBAN #I #II #K #KEI 
	#LIST$$ #LOOP #LR #MSG #O #OS #PTEN5 #PTEN5$ #PTEN5$$ #QRY$ #RET$ #SA #SM #SS_DUM 
	#SS_SYOMEN #SUI-QRY$ #WTRHOLEEN$ #XD_PTEN$ #XD_PTEN5$ #ZOKU #ZOKUP #ZOKUP$ #ZZ	
  )

  ;// �V�X�e���ϐ��ۊ�
  (setq #os (getvar "OSMODE"))   ;O�X�i�b�v
  (setq #sm (getvar "SNAPMODE")) ;�X�i�b�v
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)

  (if (not (tblsearch "APPID" "G_WTR")) (regapp "G_WTR"))

  (setq #pten5$$ nil)

  (setq #ret$ (KPGetPTEN 5)) ; 01/06/27 YM �֐���
  (setq #pten5$    (car  #ret$)) ; PTEN5�}�`ؽ�
  (setq #xd_pten5$ (cadr #ret$)) ; "G_PTEN"ؽ�
  (setq #i 0)
  (repeat (length #pten5$) ; ؽĂ����킹��
    (setq #pten5$$ (append #pten5$$ (list (list (nth #i #pten5$)(nth #i #xd_pten5$)))))
    (setq #i (1+ #i))
  )

  ;������������i�Ԃ��擾����
  (setq #DB_NAME "��������")
  (setq #LIST$$ (list (list "�L��" (nth 19 CG_GLOBAL$)'STR)));�����̎��
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$))
  (setq #qry$ (DBCheck #qry$ "�w���������x" "PKW_WorkTop"))
  (setq #hinban (nth 1 #qry$))       ; �i�Ԗ���
  (setq #LR     (nth 2 #qry$))       ; LR�敪

  (setq #fig-qry$
    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
      (list
        (list "�i�Ԗ���" #hinban  'STR)
        (list "LR�敪"   #LR      'STR)
      )
    )
  )
  (setq #fig-qry$ (DBCheck #fig-qry$ "�w�i�Ԑ}�`�x" (strcat "�i�Ԗ���=" #hinban)))
  ;����}�`ID
  (setq #dwg (nth 6 #fig-qry$));2008/06/28 OK!

  ;[�����ʒu]���������Ĕz�u�ʒu�̐��������������߂�
  (setq #sui-qry$
    (CFGetDBSQLRec CG_DBSESSION "�����ʒu"
      (list
        (list "�V���N�L��" (nth 17 CG_GLOBAL$) 'STR)
        (list "�V���N����" (nth 11 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #sui-qry$ (DBCheck #sui-qry$ "�w�����ʒu�x" (strcat "�V���N=" (nth 17 CG_GLOBAL$))))

  (setq #zoku (nth 3 #sui-qry$))   ; ����1�̔z�u�ʒu����

  ;2009/02/06 YM ADD-S ����2���Ή�
  ;�������Q���I������Ă��Ă���������ݸ�Ȃ�吅���̈ʒu���ς��
  (if (and (= "B" (nth 18 CG_GLOBAL$))(wcmatch (nth 17 CG_GLOBAL$) "G*" ))
    (progn
      (setq #zoku (nth 4 #sui-qry$))   ; ����1�̔z�u�ʒu����
    )
  );_if
  ;2009/02/06 YM ADD-E ����2���Ή�

  (setq #k 0)
  (setq #zokuP$ '())
  (foreach #pten5$ #pten5$$
    (setq #xd_PTEN$ (cadr #pten5$))    ; �g���ް�"G_PTEN"
    (setq #zokuP (nth 2 #xd_PTEN$))    ; ����
    (if (and (= #zokuP #zoku)               ; �����������Ȃ琅��z�u
             (= (member #zokuP #zokuP$) nil))
      (progn
        (setq #zokuP$ (append #zokuP$ (list #zokuP))) ; PTEN5�}�`��
        (setq #pten5 (car  #pten5$))   ; PTEN5�}�`��
        (setq #kei (nth 1 #xd_PTEN$))  ; ���a
        (setq #o (cdr (assoc 10 (entget #pten5)))) ; ���S�_���W
        ; ��������Łu�����v�Ȃ��̏ꍇ 01/01/15 YM ADD
        ;;;  (setq #ANA_layer "Z_00_00_00_01" ) ; �ڂɌ�����
        (setq #ANA_layer SKW_AUTO_SECTION) ; �ڂɌ����Ȃ�
;-- 2011/09/09 A.Satoh Del - S
;        (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"�̉~���쐬����
;
;
;        ;// �������g���f�[�^��ݒ�
;        (CFSetXData #dum "G_WTR" (list #zokuP))
;        (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; �������}�`��
;-- 2011/09/09 A.Satoh Del - E
        ;// ��������̔z�u

        (setq #ang 0.0) ; �ݸ�����݂��Ȃ��Ƃ��z�u�p�x0�Œ�



        ;;; �}�`�����݂��邩�m�F
        (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")));2008/06/28 OK!
          (progn
            (setq #msg (strcat "����}�` : ID=" #dwg " ������܂���"));2008/06/28 OK!
            (CMN_OutMsg #msg) ; 02/09/05 YM ADD
          )
        )

        ;// �C���T�[�g
        (WebOutLog "������}�����܂�(PKW_PosWTR_plan)")
        (command "_insert"
          (strcat CG_MSTDWGPATH #dwg) ; �i�Ԑ}�`.�}�`ID ;2008/06/28 OK!
          #o
          1
          1
          (rtd #ang)
        )
        (command "_explode" (entlast))
        (setq #ss_dum (ssget "P"))

        ;2008/09/01 YM ADD-S ���ʐ}�������o����
        (setq #ss_syomen (ssget "P" (list (cons 8 "Z_03_04_*"))));���ʎ{�H�}�̉�w
        ;2008/09/01 YM ADD-E ���ʐ}�������o����


        (SKMkGroup #ss_dum)

        ;04/01/24 YM ADD-S (ssname #ss_dum 0)�̐}�`���s���ȏꍇ�̉��
        (setq #ii 0 #loop T)
        (while (and #loop (< #ii 10))
          (setq #dum_en (ssname #ss_dum #ii))
          (if (and (= 'ENAME (type #dum_en))(entget #dum_en))
            (setq #loop nil)
          );_if
          (setq #ii (1+ #ii))
        )
        ;04/01/24 YM ADD-E (ssname #ss_dum 0)�̐}�`���s���ȏꍇ�̉��
        
;;;        (setq #en (SKC_GetSymInGroup #dum_en));04/01/24 YM MOD
         (setq #en (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

        ;// �g���f�[�^�̕t��
        (WebOutLog "�g���ް� G_LSYM ��ݒ肵�܂�(PKW_PosWTR_plan)")
        (CFSetXData #en "G_LSYM"
          (list
            (nth 6 #fig-qry$)          ;1 :�{�̐}�`ID  ; �i�Ԑ}�`.�}�`�h�c ;2008/06/28 OK!
            #o                         ;2 :�}���_
            0.0                        ;3 :��]�p�x
            CG_Kcode                   ;4 :�H��L��
            CG_SeriesCode              ;5 :SERIES�L��
            (nth 0 #fig-qry$)          ;6 :�i�Ԗ���
            "Z"                        ;7 :L/R �敪
            ""                         ;8 :���}�`ID
            ""                         ;9 :���J���}�`ID
            CG_SKK_INT_SUI             ;10:���iCODE ; 01/08/31 YM MOD 510-->��۰��ى�
            2                          ;11:�����t���O
            0                          ;12:���R�[�h�ԍ�
            (fix (nth 2 #fig-qry$))    ;13:�p�r�ԍ� ;2008/06/28 OK!
            0.0                        ;14:���@H
            1                          ;15:�f�ʎw���̗L��
            "A"                        ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
          )
        );_CFSetXData

				;2019/04/26 YM ADD
				(KcSetG_OPT #en) ; �g���ް�"G_OPT"���

      )
    );_if
  );_foreach

  ;2008/09/01 YM ADD ���𐳖ʕǂ����̊G�̍�����V�����ɉ����Ē�������
  ;�V����
  (setq #HH (atoi (substr (nth 31 CG_GLOBAL$) 2 3)));H850,H900,H800
  ;����z�u����
  (setq #ZZ (nth 2 #o))
  (setq #SA (- #HH #ZZ))
  ;������������ꍇ�ɐ��ʐ}�����ړ�����
  (if (< 0.1 (abs #sa))
    (command "._MOVE" #ss_syomen "" "0,0,0" (strcat "@0,0," (rtos #SA)) ) ; �}�`�ړ�
  );_if

  ;// �V�X�e���ϐ������ɖ߂�
  (setvar "OSMODE"   #os)
  (setvar "SNAPMODE" #sm)

  #WtrHoleEn$  ;// ������(G_WTR)��ʐ}�`��Ԃ�
);FK_PosWTR_plan

;;;<HOM>*************************************************************************
;;; <�֐���>    : FK_PosWTR_plan
;;; <�����T�v>  : ������z�u����(�ڰѷ��݁@�v��������)
;;; <�߂�l>    :
;;;        LIST : ������(G_WTR)�}�`�̃��X�g
;;; <�쐬>      : 2017/10/11 YM ADD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun FK_PosWTR_plan2 (
  /
	#ANA_LAYER #ANG #DB_NAME #DUM_EN #DWG #EN #FIG-QRY$ #HH #HINBAN #I #II #K #KEI 
	#LIST$$ #LOOP #LR #MSG #O #OS #PTEN5 #PTEN5$ #PTEN5$$ #QRY$ #RET$ #SA #SM #SS_DUM 
	#SS_SYOMEN #SUI-QRY$ #WTRHOLEEN$ #XD_PTEN$ #XD_PTEN5$ #ZOKU #ZOKUP #ZOKUP$ #ZZ	
  )

  ;// �V�X�e���ϐ��ۊ�
  (setq #os (getvar "OSMODE"))   ;O�X�i�b�v
  (setq #sm (getvar "SNAPMODE")) ;�X�i�b�v
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)

  (if (not (tblsearch "APPID" "G_WTR")) (regapp "G_WTR"))

  (setq #pten5$$ nil)

  (setq #ret$ (KPGetPTEN 5)) ; 01/06/27 YM �֐���
  (setq #pten5$    (car  #ret$)) ; PTEN5�}�`ؽ�
  (setq #xd_pten5$ (cadr #ret$)) ; "G_PTEN"ؽ�
  (setq #i 0)
  (repeat (length #pten5$) ; ؽĂ����킹��
    (setq #pten5$$ (append #pten5$$ (list (list (nth #i #pten5$)(nth #i #xd_pten5$)))))
    (setq #i (1+ #i))
  )

  ;������������i�Ԃ��擾����
  (setq #DB_NAME "��������")
  (setq #LIST$$ (list (list "�L��" (nth 22 CG_GLOBAL$)'STR)));�����̎��
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$))
  (setq #qry$ (DBCheck #qry$ "�w���������x" "PKW_WorkTop"))
  (setq #hinban (nth 1 #qry$))       ; �i�Ԗ���
  (setq #LR     (nth 2 #qry$))       ; LR�敪

  (setq #fig-qry$
    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
      (list
        (list "�i�Ԗ���" #hinban  'STR)
        (list "LR�敪"   #LR      'STR)
      )
    )
  )
  (setq #fig-qry$ (DBCheck #fig-qry$ "�w�i�Ԑ}�`�x" (strcat "�i�Ԗ���=" #hinban)))
  ;����}�`ID
  (setq #dwg (nth 6 #fig-qry$));2008/06/28 OK!

  ;[�����ʒu]���������Ĕz�u�ʒu�̐��������������߂�
  (setq #sui-qry$
    (CFGetDBSQLRec CG_DBSESSION "�����ʒu"
      (list
        (list "�V���N�L��" (nth 17 CG_GLOBAL$) 'STR)
        (list "�V���N����" (nth 11 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #sui-qry$ (DBCheck #sui-qry$ "�w�����ʒu�x" (strcat "�V���N=" (nth 17 CG_GLOBAL$))))

  (setq #zoku (nth 5 #sui-qry$))   ; ����1�̔z�u�ʒu����

  ;2009/02/06 YM ADD-S ����2���Ή�
  ;�������Q���I������Ă��Ă���������ݸ�Ȃ�吅���̈ʒu���ς��
  (if (and (= "B" (nth 18 CG_GLOBAL$))(wcmatch (nth 17 CG_GLOBAL$) "G*" ))
    (progn
      (setq #zoku (nth 4 #sui-qry$))   ; ����1�̔z�u�ʒu����
    )
  );_if
  ;2009/02/06 YM ADD-E ����2���Ή�

  (setq #k 0)
  (setq #zokuP$ '())
  (foreach #pten5$ #pten5$$
    (setq #xd_PTEN$ (cadr #pten5$))    ; �g���ް�"G_PTEN"
    (setq #zokuP (nth 2 #xd_PTEN$))    ; ����
    (if (and (= #zokuP #zoku)               ; �����������Ȃ琅��z�u
             (= (member #zokuP #zokuP$) nil))
      (progn
        (setq #zokuP$ (append #zokuP$ (list #zokuP))) ; PTEN5�}�`��
        (setq #pten5 (car  #pten5$))   ; PTEN5�}�`��
        (setq #kei (nth 1 #xd_PTEN$))  ; ���a
        (setq #o (cdr (assoc 10 (entget #pten5)))) ; ���S�_���W
        ; ��������Łu�����v�Ȃ��̏ꍇ 01/01/15 YM ADD
        ;;;  (setq #ANA_layer "Z_00_00_00_01" ) ; �ڂɌ�����
        (setq #ANA_layer SKW_AUTO_SECTION) ; �ڂɌ����Ȃ�
;-- 2011/09/09 A.Satoh Del - S
;        (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"�̉~���쐬����
;
;
;        ;// �������g���f�[�^��ݒ�
;        (CFSetXData #dum "G_WTR" (list #zokuP))
;        (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; �������}�`��
;-- 2011/09/09 A.Satoh Del - E
        ;// ��������̔z�u

        (setq #ang 0.0) ; �ݸ�����݂��Ȃ��Ƃ��z�u�p�x0�Œ�



        ;;; �}�`�����݂��邩�m�F
        (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")));2008/06/28 OK!
          (progn
            (setq #msg (strcat "����}�` : ID=" #dwg " ������܂���"));2008/06/28 OK!
            (CMN_OutMsg #msg) ; 02/09/05 YM ADD
          )
        )

        ;// �C���T�[�g
        (WebOutLog "������}�����܂�(PKW_PosWTR_plan)")
        (command "_insert"
          (strcat CG_MSTDWGPATH #dwg) ; �i�Ԑ}�`.�}�`ID ;2008/06/28 OK!
          #o
          1
          1
          (rtd #ang)
        )
        (command "_explode" (entlast))
        (setq #ss_dum (ssget "P"))

        ;2008/09/01 YM ADD-S ���ʐ}�������o����
        (setq #ss_syomen (ssget "P" (list (cons 8 "Z_03_04_*"))));���ʎ{�H�}�̉�w
        ;2008/09/01 YM ADD-E ���ʐ}�������o����


        (SKMkGroup #ss_dum)

        ;04/01/24 YM ADD-S (ssname #ss_dum 0)�̐}�`���s���ȏꍇ�̉��
        (setq #ii 0 #loop T)
        (while (and #loop (< #ii 10))
          (setq #dum_en (ssname #ss_dum #ii))
          (if (and (= 'ENAME (type #dum_en))(entget #dum_en))
            (setq #loop nil)
          );_if
          (setq #ii (1+ #ii))
        )
        ;04/01/24 YM ADD-E (ssname #ss_dum 0)�̐}�`���s���ȏꍇ�̉��
        
;;;        (setq #en (SKC_GetSymInGroup #dum_en));04/01/24 YM MOD
         (setq #en (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

        ;// �g���f�[�^�̕t��
        (WebOutLog "�g���ް� G_LSYM ��ݒ肵�܂�(PKW_PosWTR_plan)")
        (CFSetXData #en "G_LSYM"
          (list
            (nth 6 #fig-qry$)          ;1 :�{�̐}�`ID  ; �i�Ԑ}�`.�}�`�h�c ;2008/06/28 OK!
            #o                         ;2 :�}���_
            0.0                        ;3 :��]�p�x
            CG_Kcode                   ;4 :�H��L��
            CG_SeriesCode              ;5 :SERIES�L��
            (nth 0 #fig-qry$)          ;6 :�i�Ԗ���
            "Z"                        ;7 :L/R �敪
            ""                         ;8 :���}�`ID
            ""                         ;9 :���J���}�`ID
            CG_SKK_INT_SUI             ;10:���iCODE ; 01/08/31 YM MOD 510-->��۰��ى�
            2                          ;11:�����t���O
            0                          ;12:���R�[�h�ԍ�
            (fix (nth 2 #fig-qry$))    ;13:�p�r�ԍ� ;2008/06/28 OK!
            0.0                        ;14:���@H
            1                          ;15:�f�ʎw���̗L��
            "A"                        ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
          )
        );_CFSetXData
      )
    );_if
  );_foreach

  ;2008/09/01 YM ADD ���𐳖ʕǂ����̊G�̍�����V�����ɉ����Ē�������
  ;�V����
  (setq #HH (atoi (substr (nth 31 CG_GLOBAL$) 2 3)));H850,H900,H800
  ;����z�u����
  (setq #ZZ (nth 2 #o))
  (setq #SA (- #HH #ZZ))
  ;������������ꍇ�ɐ��ʐ}�����ړ�����
  (if (< 0.1 (abs #sa))
    (command "._MOVE" #ss_syomen "" "0,0,0" (strcat "@0,0," (rtos #SA)) ) ; �}�`�ړ�
  );_if

  ;// �V�X�e���ϐ������ɖ߂�
  (setvar "OSMODE"   #os)
  (setvar "SNAPMODE" #sm)

  #WtrHoleEn$  ;// ������(G_WTR)��ʐ}�`��Ԃ�
);FK_PosWTR_plan2

;<HOM>*************************************************************************
; <�֐���>    : PKW_WorkTop
; <�����T�v>  : �i�v���������p�j���[�N�g�b�v�𐶐�����
; <����>      : �Ȃ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-12-20 ��{���� 2000.1 �C��YM 04/10 �C�� �V��WT
;               00/07/27 YM MOD �V���݌������ݕ�
; <���l>      :
;               (�v�����m�莞�ɐݒ�)
;                 CG_Type1Code
;                 CG_Type2Code
;                 CG_KCode
;                 CG_SeriesCode
;                 CG_WTZaiCode
;                 (nth 11 CG_GLOBAL$)
;                 CG_SinkCode
;               (���C�A�E�g���ɐݒ�)
;                 CG_SINK_ENT     ;�V���N�}�`
;                 CG_GAS_ENT      ;�K�X�R�����}�`
;*************************************************************************>MOH<
(defun PKW_WorkTop ( ; �v����������
  /
  #BASEPT #BASESYM$ #EN_LOW$ #G_WTR$ #I #OUTPL #OUTPL_LOW #PT$ #PT_LOW$ #QRY$ #QRY$$
  #SETXD$ #SKK$ #SS #STEP #W-XD$ #WT #WTINFO$ #WT_SOLID$ #XD_SYM$ #ZAIF
  #H #THR #SINA_Type #FLAG #WTBASE #OUTPL$ #LIST$$ #DB_NAME
;-- 2011/10/20 A.Satoh Del - S
;;;;;;-- 2011/09/21 A.Satoh Add - S
;;;;;  #handle$ #WT_SOLID
;;;;;;-- 2011/09/21 A.Satoh Add - E
;-- 2011/10/20 A.Satoh Del - E
  )
  (setvar "pdmode" 34)
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart);  00/02/07 1/31����R�s�[

  ; ���i���ߎ擾 01/06/27 YM ADD
  (setq #SINA_Type (KPGetSinaType))
  (if (equal #SINA_Type 2 0.1)  ; ���i����=2(�Ʒ���)�Ȃ�WT�����������Ȃ�
    (setq #FLAG nil) ; ���ꏈ��
    (setq #FLAG T)   ; �ʏ폈��
  );_if

  (if #FLAG  ; �Ʒ��݂ł͂Ȃ��Ƃ�
    (progn

      ;// �v�����������̊�_�� (0 0 0)�Œ�
      (setq #BasePt (list 0 0 0))
      (command "vpoint" "0,0,1") ;  "LWPOLYLINE"  ��w: "Z_wtbase"
      ;// �x�[�X�L���r�l�b�g������
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #skk$ (CFGetSymSKKCode (ssname #ss #i) nil))
        (setq #xd_SYM$ (CFGetXData (ssname #ss #i) "G_SYM"))
        ;03/11/15 YM MOD-S �ި��۱�Ή� "117"�͏��O����

        (if (and (= (car #skk$) CG_SKK_ONE_CAB) (= (cadr #skk$) CG_SKK_TWO_BAS)
                 (/= (caddr #skk$) CG_SKK_THR_DIN));03/11/15 YM
          (if (equal (nth 6 #xd_SYM$) 0 0.01)
            (if (PK_ChkBaseSYM (ssname #ss #i)) ; ��ɷ���ȯĂ�����
              (princ)
              (setq #BaseSym$ (cons (ssname #ss #i) #BaseSym$)) ; �x�[�X�L���r�l�b�g�΂��� ���i����=11?

            );_if
          );_if
        );_if

        (cond
          ((= (car #skk$) 4)
            (setq CG_SINK_ENT (ssname #ss #i)) ; �ݸ�}�`��
          )
          ((= (car #skk$) 2)
            (setq CG_GAS_ENT (ssname #ss #i))  ; �޽�}�`��
          )
        );_cond
        (setq #i (1+ #i))
      );_(repeat (sslength #ss)

      (setq #step nil)

      (if #BaseSym$
        (progn
          (foreach #BaseSym #BaseSym$
            (KPMovePmen2_Z_0 #BaseSym) ; ����وʒuZ��0�łȂ��Ƃ��APMEN2�̍�����Z=0�ɂ���
          )
        )
      );_if

      ;// �x�[�X�L���r���烏�[�N�g�b�v�̃_�~�[�̊O�`�̈���쐬����
      (setq #outpl (PKW_MakeSKOutLine #BaseSym$ #step)) ; ����; �x�[�X�L���r�l�b�g�΂��� ���i����=11?  #outpl �ް�������ײ�  ; 00/03/13 ADD step �i��

      (setq #pt$ (GetLWPolyLinePt #outpl)) ; ���O�O�̊O�`�_��
      (setq #outpl$ (PKW_MakeSKOutLine3 #BaseSym$))    ; ���ޏ��O�O�̊O�`�̈�����߂�
      (setq CG_GAIKEI (GetLWPolyLinePt (car #outpl$))) ; ���O�O�̊O�`�_��
      ; �O�`�_������PLINE�ɂ��Ă���"G_WRKT"�ɾ�Ă���i�������܂񂾑S�O�`�_��
      ; (���̎��_�ł͑O�����WT���s���g�����܂�ł��Ȃ������Ƃōl������)

      (setq #pt$ (GetLWPolyLinePt #outpl))    ; ���O�O�̊O�`�_��

  ;;;   (PKW_SetGlobalFromBaseCab2 #BaseSym$)   ; �Ԍ��Q�L���̔���

      ;// ۰���ޕ��� nil�Œ�
      (setq #en_LOW$ '())

      ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
      (CFNoSnapStart)

      ;;; WT��� WT�f�ނ̌���
      (setq #WTInfo$ (PKGetWTInfo_plan #pt$ (list #pt$) #BaseSym$ #BaseSym$ #outpl_LOW)) ; (list #WTInfo #retWT_BG_FG$ #SetXd$ #CUT_KIGO$ #CG_WtDepth)
      ;// ���[�N�g�b�v�̐��� U�^�Ή�
      (setq #WT_SOLID$ (PK_MakeWorktop3 #WTInfo$ #en_LOW$ #pt_LOW$))

      ;// �_�~�[�̊O�`�̈���폜
      (entdel #outpl)

      (entdel (car #outpl$))

    )
  );_if

;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ;2008/06/23 YM DEL �y����z�u�����v�C���z
  (princ "������z�u���܂�")

  ;2009/02/06 YM ADD �u�������Ȃ��v�Ή� if���ǉ�
  (if (= "N" (nth 18 CG_GLOBAL$));�������Ȃ��ł͂Ȃ��Ƃ�
    (progn
      ;2009/02/06 YM ADD
      (princ "�������Ȃ��̂��߁A������z�u���܂���ł���")
    )
    (progn ; �]��ۼޯ� [�吅���̔z�u]
      
      (setq #g_wtr$
        (PKW_PosWTR_plan
          CG_KCode        ;(STR)�H��L��
          CG_SeriesCode   ;(STR)SERIES�L��
          CG_SINK_ENT     ;(ENAME)�V���N��}�`
          (nth 17 CG_GLOBAL$)     ;(STR)�V���N�L��
          #qry$$          ;�����\��ں��ނ�ؽ� nil ����<---���̈��������ݸ�z�u����ނƈႤ
        )
      )
      (princ "������z�u���܂���")

    )
  );_if


  ;2009/02/06 YM ADD ����2���Ή�
  (if (and (=  "B" (nth 18 CG_GLOBAL$)) ;����2���̂Ƃ�
           (/= "_" (nth 19 CG_GLOBAL$)));����2������
    (progn ; [����2���̔z�u]
      
      (setq #g_wtr$
        (PKW_PosWTR_plan_2
          CG_KCode        ;(STR)�H��L��
          CG_SeriesCode   ;(STR)SERIES�L��
          CG_SINK_ENT     ;(ENAME)�V���N��}�`
          (nth 17 CG_GLOBAL$)     ;(STR)�V���N�L��
          #qry$$          ;�����\��ں��ނ�ؽ� nil ����<---���̈��������ݸ�z�u����ނƈႤ
        )
      )
      (princ "����2����z�u���܂���")
    )
  );_if




;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  ;2008/06/23 YM DEL �y����z�u�����v�C���z
;;; (if #FLAG ; �Ʒ��݂ł͂Ȃ��Ƃ�
;;;   (progn
;;;
;;;       ;// �����֘A�̊g���f�[�^���Đݒ�
;;;       (setq #setxd$ (list (list 22 (length #g_wtr$))))
;;;       (setq #i 23)
;;;       (foreach #en #g_wtr$
;;;         (setq #setxd$ (append #setxd$ (list (list #i #en))))
;;;         (setq #i (1+ #i))
;;;       )
;;;
;;;       (setq #ZaiF (KCGetZaiF (nth 16 CG_GLOBAL$))) ; �f��F 0:�l�H�嗝�� 1:���ڽ
;;;       ;// ���[�N�g�b�v�g���f�[�^�̍X�V
;;;
;;;       (cond ; 01/05/02 YM ADD �����莞�ɕs�
;;;         ; �l��,������,L�^
;;;         ((and (or (= #ZaiF 0)(= #ZaiF -1))(= (nth  5 CG_GLOBAL$) "L")(= (nth 11 CG_GLOBAL$) "L"))
;;;           (setq #WT (cadr #WT_SOLID$))
;;;         )
;;;         ; ����ȊO
;;;         (T (setq #WT (car #WT_SOLID$))) ; �ʏ�(���܂�)
;;;       );_cond
;;;
;;;       (setq #w-xd$ (CFGetXData #WT "G_WRKT"))
;;;       (CFSetXData #WT "G_WRKT"
;;;         (CFModList #w-xd$ #setxd$)
;;;       )
;;;   )
;;; );_if




;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ;2008/06/23 YM DEL �yܰ�į�ߕi�Ԋm�菈���v�C���z
  (if #FLAG  ; �Ʒ��݂ł͂Ȃ��Ƃ�
    (progn
      (setq #WT (car  #WT_SOLID$))

      ;D1050�Ȃ��R���ޏ��� 2008/09/27 YM ADD
      (if (= "D105" (nth  7 CG_GLOBAL$))
        (setq #WT (subKPRendWT #WT)) ;�߂�l=�V�}�`��
      );_if

      ;// �i�Ԃ̊m�菈��
      (KPW_DesideWorkTop3 #WT)

;-- 2011/10/20 A.Satoh Del - S
;;;;;      ;L�^�̏ꍇ�V�ɶ�Ă����� 2008/09/27 YM ADD
;;;;;      ;[WT�ގ�]�Ŷ�����ߎ擾 X(�΂�) or J(�������)
;;;;;      ;������Ă̏ꍇ��[WT��ĕ���]����������擾
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;      (if (wcmatch (nth  5 CG_GLOBAL$) "L*")
;;;;;;;;;;        (progn ; L�^
;;;;;;;;;;          (AddWorkTopCutLine #WT)
;;;;;;;;;;        )
;;;;;;;;;;      );_if
;;;;;      (if (wcmatch (nth  5 CG_GLOBAL$) "L*")
;;;;;        (progn ; L�^
;;;;;          (setq #handle$ (AddWorkTopCutLine #WT))
;;;;;          (if (/= #handle$ nil)
;;;;;            (foreach #WT_SOLID #WT_SOLID$
;;;;;              (setq #SetXd$ (CFGetXData #WT_SOLID "G_WRKT"))
;;;;;              (CFSetXData #WT_SOLID "G_WRKT" (CFModList #SetXd$
;;;;;                (list
;;;;;                  (list  9 (nth 4 #handle$))
;;;;;                  (list 60 (nth 0 #handle$))
;;;;;                  (list 61 (nth 1 #handle$))
;;;;;                  (list 62 (nth 2 #handle$))
;;;;;                  (list 63 (nth 3 #handle$))
;;;;;                )
;;;;;              ))
;;;;;            )
;;;;;          )
;;;;;        )
;;;;;      );_if
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;-- 2011/10/20 A.Satoh Del - E
    )
  );_if


;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  (setvar "pdmode" 0)
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  (CFNoSnapEnd) ; 00/02/07 @YM@�ǉ�

  (princ "ܰ�į�߂������������܂���")
  #WT ;2010/11/10 YM ADD WT�}�`��Ԃ�
);PKW_WorkTop


;-- 2011/10/20 A.Satoh Del - S
;;;;;;;;<HOM>*************************************************************************
;;;;;;;; <�֐���>    : AddWorkTopCutLine
;;;;;;;; <�����T�v>  : L�^�̏ꍇ�V�ɶ��ײ݂�����
;;;;;;;; <�߂�l>    : 
;;;;;;;; <�쐬>      : 2008/09/27 YM
;;;;;;;; <���l>      :
;;;;;;;;*************************************************************************>MOH<
;;;;;(defun AddWorkTopCutLine (
;;;;;  &WT ;�V�}�`
;;;;;  /
;;;;;  #BASEP #CUT$$ #CUTDIR$$ #CUTDIRECT #CUTTYPE #DUMPT #P1 #P2 #P3 #P4 #P5 #P6
;;;;;  #PT$ #TEI #X1 #X2 #XD$ #CLAYER #HH #Y1 #Y2
;;;;;;-- 2011/09/21 A.Satoh Add - S
;;;;;#handle$ #en #handle1 #handle2 #wt_hand #dirt
;;;;;;-- 2011/09/21 A.Satoh Add - E
;;;;;  )
;;;;;  ;������߂����߂�
;;;;;  (setq #Cut$$
;;;;;    (CFGetDBSQLRec CG_DBSESSION "WT�ގ�"
;;;;;      (list
;;;;;        (list "�ގ��L��" (nth 16 CG_GLOBAL$) 'STR)
;;;;;      )
;;;;;    )
;;;;;  )
;;;;;  (if (and #Cut$$ (= 1 (length #Cut$$)))
;;;;;    (setq #CutType (nth 6 (car #Cut$$))); ��ӂɌ��܂����ꍇ(X or J)
;;;;;    ;else ����ł��Ȃ��ꍇ
;;;;;    (setq #CutType "N");��ĂȂ�
;;;;;  );_if
;;;;;
;;;;;  ;J��Ă̏ꍇ��ĕ��������߂�
;;;;;  (if (= #CutType "J")
;;;;;    (progn
;;;;;      (setq #CutDir$$
;;;;;        (CFGetDBSQLRec CG_DBSESSION "WT�J�b�g����"
;;;;;          (list
;;;;;            (list "�V���N���Ԍ�" (nth  4 CG_GLOBAL$) 'STR)
;;;;;            (list "�`��"         (nth  5 CG_GLOBAL$) 'STR)
;;;;;            (list "�V���N�ʒu"   (nth  2 CG_GLOBAL$) 'STR)
;;;;;          )
;;;;;        )
;;;;;      )
;;;;;      (if (and #CutDir$$ (= 1 (length #CutDir$$)))
;;;;;        (progn
;;;;;          (setq #CutDirect (nth 4 (car #CutDir$$))); ��ӂɌ��܂����ꍇ(S or G)
;;;;;        )
;;;;;        ;else ����ł��Ȃ��ꍇ
;;;;;        (progn
;;;;;          (setq #CutType "N");��ĂȂ�
;;;;;        )
;;;;;      );_if
;;;;;    )
;;;;;  );_if
;;;;;  
;;;;;;;; p1+----------+--LEN2-------------+p2
;;;;;;;;   |          x1                  |
;;;;;;;;   |          |     �̈�2         |
;;;;;;;;   |          p4                  |
;;;;;;;;   +x2------- +-------------------+p3
;;;;;;;;   |          |
;;;;;;;;   |          |
;;;;;;;;   |  �̈�1   |
;;;;;;;;LEN1          |
;;;;;;;;   |          |
;;;;;;;;   |  +----+  |
;;;;;;;;   |  | S  |  |
;;;;;;;;   |  +----+  |
;;;;;;;;   |          |
;;;;;;;;   |          |
;;;;;;;; p6+----------+p5
;;;;;
;;;;;  ;�V����
;;;;;  (setq #HH (atoi (substr (nth 31 CG_GLOBAL$) 2 3)));H850,H900,H800
;;;;;
;;;;;  (setq #xd$ (CFGetXData &WT "G_WRKT"))
;;;;;  (setq #tei   (nth 38 #xd$))        ; WT��ʐ}�`�����
;;;;;  (setq #BaseP (nth 32 #xd$))        ; WT����_
;;;;;  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��
;;;;;;;; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
;;;;;  (setq #pt$ (GetPtSeries #BaseP #pt$))
;;;;;  (setq #p1 (nth 0 #pt$))
;;;;;  (setq #p2 (nth 1 #pt$))
;;;;;  (setq #p3 (nth 2 #pt$))
;;;;;  (setq #p4 (nth 3 #pt$))
;;;;;  (setq #p5 (nth 4 #pt$))
;;;;;  (setq #p6 (nth 5 #pt$))
;;;;;
;;;;;  (setq #p1 (list (car #p1)(cadr #p1) #HH))
;;;;;  (setq #p2 (list (car #p2)(cadr #p2) #HH))
;;;;;  (setq #p3 (list (car #p3)(cadr #p3) #HH))
;;;;;  (setq #p4 (list (car #p4)(cadr #p4) #HH))
;;;;;  (setq #p5 (list (car #p5)(cadr #p5) #HH))
;;;;;  (setq #p6 (list (car #p6)(cadr #p6) #HH))
;;;;;
;;;;;  ;ײݍ�}
;;;;;  (if (/= "N" #CutType)
;;;;;    (progn
;;;;;      
;;;;;      (setq #CLAYER (getvar "CLAYER"))
;;;;;      (setvar "CLAYER" SKW_AUTO_SOLID)
;;;;;
;;;;;      ; T.Ari Add ���ʐ}
;;;;;      (defun AddWorkTopPlaneCutLine (
;;;;;        &WT ;�V�}�`
;;;;;        &pt$
;;;;;        /
;;;;;        #i #j
;;;;;        #layer
;;;;;        #sstmp #ss
;;;;;        )
;;;;;        (setq #ss (ssadd))
;;;;;        (foreach #i (list 1 2)
;;;;;          (setq #sstmp (ssadd))
;;;;;          (setq #layer (if (= #i 1) "Z_01_02_00_00" "Z_01_04_00_00"))
;;;;;          (MakeLayer #layer 7 "CONTINUOUS")
;;;;;          (setq #j 0)
;;;;;          (repeat (- (length &pt$) 1)
;;;;;            (command "_.line" (nth #j &pt$) (nth (+ #j 1) &pt$) "")
;;;;;            (ssadd (entlast) #ss)
;;;;;            (ssadd (entlast) #sstmp)
;;;;;            (setq #j (+ #j 1))
;;;;;          )
;;;;;          (command "chprop" #sstmp "" "LA" #layer "")
;;;;;        )
;;;;;        (ssadd &WT #ss)
;;;;;        (SKMkGroup #ss)
;;;;;      )
;;;;;      (cond
;;;;;        ((= #CutType "X")
;;;;;          ;�΂߶��
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;          (setq #dumpt (polar #p1 (angle #p1 #p2) 20))
;;;;;;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p3) 20))
;;;;;;;;;;          (setq #y1 (list (car #dumpt)(cadr #dumpt) (+ #HH 50)));BG�����ǉ�
;;;;;;;;;;          (setq #y2 (list (car #p1)(cadr #p1) (+ #HH 50)))
;;;;;;;;;;          (command "_.line" #p4 #dumpt #y1 #y2 "")
;;;;;;;;;;          ; T.Ari Add ���ʐ}
;;;;;;;;;;          (AddWorkTopPlaneCutLine &WT (list #p4 #dumpt #y1 #y2))
;;;;;          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))
;;;;;          (command "_.3DPOLY" #p4 #p1 "")
;;;;;          (setq #en (entlast))
;;;;;          (setq #handle1 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "X"))
;;;;;
;;;;;          (setq #handle2 "")
;;;;;
;;;;;          (setq #handle$ (list #handle1 "" "" "" ""))
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;;;;;        )
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;        ((or (and (= "R" (nth 11 CG_GLOBAL$))(= #CutType "J")(= #CutDirect "S")) ;�����
;;;;;;;;;;             (and (= "L" (nth 11 CG_GLOBAL$))(= #CutType "J")(= #CutDirect "G")))
;;;;;;;;;;          ;�E����żݸ����� or ������ź�ۑ����
;;;;;;;;;;          (setq #dumpt (polar #p4 (angle #p3 #p2) 50))
;;;;;;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p1) 50))
;;;;;;;;;;          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
;;;;;;;;;;          (setq #x1 (polar #x1 (angle #p2 #p3) 20))
;;;;;;;;;;          (setq #y1 (list (car #x1)(cadr #x1) (+ #HH 50)));BG�����ǉ�
;;;;;;;;;;          (setq #y2 (polar #y1 (angle #p3 #p2) 20))
;;;;;;;;;;          (command "_.line" #p4 #dumpt #x1 #y1 #y2 "")
;;;;;;;;;;          ; T.Ari Add ���ʐ}
;;;;;;;;;;          (AddWorkTopPlaneCutLine &WT (list #p4 #dumpt #x1 #y1 #y2))
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;;;;;        ((or (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "S")) ;�����
;;;;;             (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "S")))
;;;;;          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))
;;;;;
;;;;;          ;�E����żݸ����� or ������ź�ۑ����
;;;;;          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")
;;;;;
;;;;;          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
;;;;;          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x1 "")
;;;;;          (setq #en (entlast))
;;;;;
;;;;;          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
;;;;;          (command "_.LAYER" "F" "WTCUT_HIDE" "")
;;;;;
;;;;;          (setq #handle1 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x2 "")
;;;;;          (setq #en (entlast))
;;;;;
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (setq #handle2 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (if (and (= "L" #lr_flg) (= #CutDirect "S"))
;;;;;            (setq #dirt "S")
;;;;;            (setq #dirt "G")
;;;;;          )
;;;;;          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
;;;;;        )
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;        ((or (and (= "L" (nth 11 CG_GLOBAL$))(= #CutType "J")(= #CutDirect "S")) ;������
;;;;;;;;;;             (and (= "R" (nth 11 CG_GLOBAL$))(= #CutType "J")(= #CutDirect "G")))
;;;;;;;;;;          ;������żݸ����� or �E����ź�ۑ����
;;;;;;;;;;          (setq #dumpt (polar #p4 (angle #p3 #p2) 50))
;;;;;;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p1) 50))
;;;;;;;;;;          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
;;;;;;;;;;          (setq #x2 (polar #x2 (angle #p6 #p5) 20))
;;;;;;;;;;          (setq #y1 (list (car #x2)(cadr #x2) (+ #HH 50)));BG�����ǉ�
;;;;;;;;;;          (setq #y2 (polar #y1 (angle #p5 #p6) 20))
;;;;;;;;;;          (command "_.line" #p4 #dumpt #x2 #y1 #y2 "")
;;;;;;;;;;          ; T.Ari Add ���ʐ}
;;;;;;;;;;          (AddWorkTopPlaneCutLine &WT (list #p4 #dumpt #x2 #y1 #y2))
;;;;;        ((or (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "G")) ;������
;;;;;             (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "G")))
;;;;;          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))
;;;;;
;;;;;          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")
;;;;;
;;;;;          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
;;;;;          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x1 "")
;;;;;          (setq #en (entlast))
;;;;;          (setq #handle1 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x2 "")
;;;;;          (setq #en (entlast))
;;;;;
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
;;;;;          (command "_.LAYER" "F" "WTCUT_HIDE" "")
;;;;;
;;;;;          (setq #handle2 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
;;;;;            (setq #dirt "G")
;;;;;            (setq #dirt "S")
;;;;;          )
;;;;;          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;;;;;        )
;;;;;        (T
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;          (princ)
;;;;;          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))
;;;;;
;;;;;          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")
;;;;;
;;;;;          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
;;;;;          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
;;;;;          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x1 "")
;;;;;          (setq #en (entlast))
;;;;;
;;;;;          (if (= #CutDirect "S")
;;;;;            (progn
;;;;;              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
;;;;;              (command "_.LAYER" "F" "WTCUT_HIDE" "")
;;;;;            )
;;;;;          )
;;;;;
;;;;;          (setq #handle1 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
;;;;;          (command "_.3DPOLY" #p4 #dumpt #x2 "")
;;;;;          (setq #en (entlast))
;;;;;
;;;;;          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))
;;;;;
;;;;;          (if (= #CutDirect "G")
;;;;;            (progn
;;;;;              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
;;;;;              (command "_.LAYER" "F" "WTCUT_HIDE" "")
;;;;;            )
;;;;;          )
;;;;;
;;;;;          (setq #handle2 (cdr (assoc 5 (entget #en))))
;;;;;
;;;;;          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
;;;;;            (setq #dirt "G")
;;;;;            (setq #dirt "S")
;;;;;          )
;;;;;          (setq #handle$ (list #handle1 #handle2 "" "" ""))
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;;;;;        )
;;;;;      );_cond
;;;;;
;;;;;      (setvar "CLAYER" #CLAYER)
;;;;;    )
;;;;;;-- 2011/09/21 A.Satoh Add - S
;;;;;    (setq #handle$ nil)
;;;;;;-- 2011/09/21 A.Satoh Add - E
;;;;;  );_if
;;;;;
;;;;;;-- 2011/09/21 A.Satoh Mod - S
;;;;;;;;;;  (princ)
;;;;;  #handle$
;;;;;
;;;;;;-- 2011/09/21 A.Satoh Mod - E
;;;;;);AddWorkTopCutLine
;-- 2011/10/20 A.Satoh Del - E

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetWTInfo_plan
;;; <�����T�v>  : WT�f�ނ̌��� <--- �v���������p
;;; <�߂�l>    :
;;;               (list (cons "WT����" #WT_H) (cons "WT����" #WT_T)
;;;                     (cons "BG����" #BG_H) (cons "BG����" #BG_T)
;;;                     (cons "FG����" #FG_H) (cons "FG����" #FG_T)
;;;               ))
;;; <�쐬>      : 2000.4.13 YM
;;; <���l>      :
;;; #CG_WtDepth = 0 �����Ȃ�
;;; #CG_WtDepth = 1 �V���N���̂�
;;; #CG_WtDepth = 10 �R�������̂�
;;; #CG_WtDepth = 100 ���̑�
;;;*************************************************************************>MOH<
(defun PKGetWTInfo_plan (
  &pt$       ; ���̊O�`�_��
  &pt$$      ; WT�O�`���ײݓ_��
  &base$     ; �ް����޼���ِ}�`
  &base_new$ ; �ް����޼���ِ}�`���O��
  &outpl_LOW ; ۰���߷��ފO�`���ײ�
  /
  #BG_H #BG_T #CG_WTDEPTH #CUTID #CUT_KIGO$ #FG_H #FG_S #FG_T #IHEIGHT$
  #RET$ #RETWT_BG_FG$ #SETXD$ #WTINFO #WT_H #WT_T
  #QRY$ #WTINFO1 #WTINFO2 #WTINFO3 #ZAIF #TYPE1
  #BG_S #BG_SEP #BG_TYPE #DANMENID #DDAN$$ #FG_TYPE #OFFSET #TOP_FLG
  #OFFSETL #OFFSETR
  )

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart) ; 00/02/07 @YM@�ǉ�

  (PKGetBASEPT_L &pt$ &base$) ; 00/09/29 YM ADD �ް���۰��ق����߂�

  (setq #CG_WTDEPTH 0)
  (cond
    ((wcmatch (nth  5 CG_GLOBAL$) "I*") ; I�^
      (setq #type1 "0")
    )
    ;2009/04/14 YM ADD-S
    ((wcmatch (nth  5 CG_GLOBAL$) "G*" ) ; GATE�^
      (setq #type1 "0")
    )
    ;2009/04/14 YM ADD-E
    ((wcmatch (nth  5 CG_GLOBAL$) "L*") ; L�^
      (setq #type1 "1")
    )
    ((wcmatch (nth  5 CG_GLOBAL$) "U*") ; U�^
      (setq #type1 "2")
    )
  );_cond

  (setq #CUT_KIGO$ '()) ; nil���肦��

  ;// ���[�N�g�b�v�̎��t�����������߂�
  (foreach #en &base$
    (setq #iHeight$ (cons (nth 5 (CFGetXData #en "G_SYM")) #iHeight$)) ; �V���{����l�g (825.0 825.0 630.0 825.0) 630�޽
  )
  (setq #WT_H (apply 'max #iHeight$)) ; ���t�������̍ő�l


  ;�֐��� 2010/10/27 YM ADD
  (setq #qry$ (GetWtDanmen))

  (if (= nil #qry$)
    (progn
      (CFAlertMsg "\n[WT�f�ʌ���]���E���Ȃ�")
      (quit)
    )
  );_if

  (setq #WT_T    (nth  2 #qry$)) ; WT�̌���
  (setq #BG_Type (nth  3 #qry$)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #BG_H    (nth  4 #qry$)) ; BG�̍���
  (setq #BG_T    (nth  5 #qry$)) ; BG�̌���
  (setq #FG_Type (nth  6 #qry$)) ; FG���� 1:�Б� 2:����
  (setq #FG_H    (nth  7 #qry$)) ; FG�̍���
  (setq #FG_T    (nth  8 #qry$)) ; FG�̌���
  (setq #FG_S    (nth  9 #qry$)) ; �O����V�t�g��
  (setq #BG_S    (nth 10 #qry$)) ; �㐂��V�t�g��
  (setq #BG_Sep  (nth 11 #qry$)) ; �ޯ��ް�ޕ���
  ; ���ٓV���׸�
  ;0:�W�� 1:BG�����E�ɉ�荞�� 2:�O���ꂪ�����ʔw�ʂɉ�肱�� 3:�O���ꂪ�E���ʔw�ʂɉ�肱��
  (setq #TOP_FLG (nth 12 #qry$)) ; ���ٓV���׸�
  (setq #offsetL  (nth 13 #qry$)) ; �������ٕ����(�V������)
  (setq #offsetR  (nth 14 #qry$)) ; �������ٕ����(�V������)

  (setq #WTInfo  (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))

  (setq #WTInfo1 (list #BG_S #BG_Type #FG_Type #offsetL #offsetR))
  (setq #WTInfo2 #WTInfo1)
  (setq #WTInfo3 #WTInfo1)

;;;  (setq #CutId 0) ; �J�b�g�Ȃ�
;;;  (setq #CutId 1) ; �J�b�g�̎��=�΂�
;;;  (setq #CutId 2) ; �J�b�g�̎��=����

  (setq #ZaiF (KCGetZaiF (nth 16 CG_GLOBAL$))) ; �f��F 0:�l�H�嗝�� 1:���ڽ

  ;2009/12/15 YM MOD-S [WT�J�b�g]�p�~
;;;  (setq #qry$
;;;   (CFGetDBSQLRec CG_DBSESSION "WT�J�b�g"
;;;     (list
;;;       (list "�`��" (nth  5 CG_GLOBAL$) 'STR)
;;;       (list "�f��F"  (rtos (FIX #ZaiF))  'INT)
;;;     )
;;;   )
;;; )
;;; (setq #qry$ (DBCheck #qry$ "�wWT�J�b�g�x" "PKGetWTInfo_plan"))
;;;  (setq #CutId (nth 3 #qry$)) ; WT�������

  (setq #CutId 0.0) ; WT������� 0�Œ�
  ;2009/12/15 YM MOD-E [WT�J�b�g]�p�~

;;; ���[�N�g�b�v�p��w�̍쐬
  (command "_layer" "N" SKW_AUTO_SECTION "C" 2 SKW_AUTO_SECTION "L" SKW_AUTO_LAY_LINE SKW_AUTO_SECTION "")
  (command "_layer" "N" SKW_AUTO_SOLID   "C" 7 SKW_AUTO_SOLID   "L" SKW_AUTO_LAY_LINE SKW_AUTO_SOLID   "")
  (command "_layer" "T" SKW_AUTO_SECTION "") ; ��w����
  (command "_layer" "T" SKW_AUTO_SOLID   "") ; ��w����


;;;DB�œ�����񂩂�BG,FG������ײ݂����߂�.
;;;WT��ėʕ�WT��ʗ̈���C������

  (setq #retWT_BG_FG$
    (PKMakeWT_BG_FG_Pline
      &pt$$
      &base_new$
      #CG_WtDepth
      #WTInfo  ; ���ʏ��
      #WTInfo1 ; 1����
      #WTInfo2 ; 2����
      #WTInfo3 ; 3����
      #CutId
      &outpl_LOW
      (nth 16 CG_GLOBAL$)
    )
  )

;;; <�߂�l>    : ((#wt_en1  #bg_en1  #fg_en1  #cut_type1  #dep1  #WT_LEN1 ����_ ),...)
;;;               ((WT��ʐ}�`��,BG��ʐ}�`��,FG��ʐ}�`��,�������)...)

  (if (= nil (tblsearch "APPID" "G_WRKT")) (regapp "G_WRKT"))
  (if (= nil (tblsearch "APPID" "G_BKGD")) (regapp "G_BKGD"))
  (if (= nil (tblsearch "APPID" "G_OPT" )) (regapp "G_OPT" ))

;;; "G_WRKT" *** ���ʍ��ڐݒ� ***

(if (= CG_MAG1 nil)(setq CG_MAG1 0))
(if (= CG_MAG2 nil)(setq CG_MAG2 0))
(if (= CG_MAG3 nil)(setq CG_MAG3 0))

  (setq #SetXd$                ; ���ݒ荀�ڂ�-999 or "-999"
    (list "K"                  ;1. �H��L��
          (nth  1 CG_GLOBAL$)  ;2. SERIES�L��
          (nth 16 CG_GLOBAL$)  ;3. �ގ��L��
          (atoi #type1)        ;4. �`��^�C�v�P          0,1,2(I,L,U) ���̎��_�Ŗ����� 00/09/25 YM
;-- 2011/09/21 A.Satoh Mod - S
;;;;;          ""                   ;5. ���g�p
;;;;;          0                    ;6. ���g�p
          ""                   ;5. �`��^�C�v�Q
          ""                   ;6. ���g�p
;-- 2011/09/21 A.Satoh Mod - E
          ""                   ;7. ���g�p
          ""                   ;8. �J�b�g�^�C�v�ԍ�      0:�Ȃ�,1:VPK,2:X,3:H ���E
          #WT_H                ;9..���[��t������        827
;-- 2011/09/21 A.Satoh Mod - S
;          "��WT���s��"         ;10.���g�p
          ""                   ;10.���g�p
;-- 2011/09/21 A.Satoh Mod - E
          #WT_T                ;11.�J�E���^�[����        23
          1                    ;12.���g�p
          #BG_H                ;13.�o�b�N�K�[�h�̍���    50
          #BG_T                ;14.�o�b�N�K�[�h����      20
          1                    ;15.���g�p
          #FG_H                ;16.�O���ꍂ��            40
          #FG_T                ;17.�O�������            20
          #FG_S                ;18.�O����V�t�g��         7
          0 "" "" ""           ;19.�ݸ�����H
          0 "" "" "" "" "" "" "" ;23.�������f�[�^��  �������}�`�n���h��1�`5
          (nth 11 CG_GLOBAL$)            ;31.�k�q����t���O        ?       U�^�Ή� --->�p�~? ��
;-- 2011/09/21 A.Satoh Mod - S
;;;;;          0.0                  ;32.���g�p
          ""                   ;32.���g�p
;-- 2011/09/21 A.Satoh Mod - E
          ""                   ;33.�R�[�i�[���_          U�^�Ή� --->2�� --->�p�~ ���ɒǉ���
          ""                   ;34.���g�p
          ""                   ;35.���g�p
;-- 2011/09/21 A.Satoh Mod - S
;;;;;          "����đ��������"     ;36.���g�p
          ""                   ;36.���g�p
;-- 2011/09/21 A.Satoh Mod - E
          ""                   ;37.�J�b�g��
          ""                   ;38.�J�b�g�E
          ""                   ;[39]WT��ʐ}�`�����
          0.0                  ;[40]���g�p
          0.0                  ;[41]���g�p
          0.0                  ;[42]���g�p
          CG_MAG1              ;[43]���g�p
          CG_MAG2              ;[44]���g�p
          CG_MAG3              ;[45]���g�p
          ""                   ;[46]���g�p
          ""                   ;[47]���g�p
          ""                   ;[48]�J�b�g����WT����ٍ�
          ""                   ;[49]�J�b�g����WT����ىE
          ""                   ;[50]BG��ʐ}�`�����1
          ""                   ;[51]BG��ʐ}�`�����2
          ""                   ;[52]FG��ʐ}�`�����
          ""                   ;[53]�f��ID
          0.0                  ;[54]�Ԍ��L�k��1 �ݸ�� (��"G_SIDE"������L�k��) �i�Ԋm��ɕK�v
          0.0                  ;[55]�Ԍ��L�k��2 ��ۑ� (��"G_SIDE"������L�k��) �i�Ԋm��ɕK�v
          '(0.0 0.0)           ;[56]���݂�WT�̕� (��"G_SIDE"����������o��) �i�Ԋm��ɕK�v WT�g���O�A��đO�̺�Ű��_����p�܂�
          0.0                  ;[57]���݂�WT�̐L�k��
          '(0.0 0.0)           ;[58]���݂�WT�̉��s��
          ""                   ;[59]��ʍa���H�̗L��    "A" ��ʍa���H�Ȃ� or "B" ��ʍa���H����
;-- 2011/09/21 A.Satoh Add - S
          ""                   ;[60]�i���������܂߂�WT�O�`PLINE�n���h��
          ""                   ;[61]�J�b�g���C���n���h��1
          ""                   ;[62]�J�b�g���C���n���h��2
          ""                   ;[63]�J�b�g���C���n���h��3
          ""                   ;[64]�J�b�g���C���n���h��4
;-- 2011/09/21 A.Satoh Add - E
    )
  )

  (setq #ret$ (list #WTInfo #retWT_BG_FG$ #SetXd$ #CUT_KIGO$ #CG_WtDepth #CutId))
  #ret$
);PKGetWTInfo_plan

;;;<HOM>*************************************************************************
;;; <�֐���>     : GetWtDanmen
;;; <�����T�v>   : [WT�f��]����������
;;; <�߂�l>     : ں���
;;; <�쐬>       : 2010/10/27 YM ADD
;;; <���l>       : �V���N�z�u������������̂Ŋ֐�������
;;;*************************************************************************>MOH<
(defun GetWtDanmen (
  /
  #DANMENID #DDAN$$ #QRY$
  #TOP_F ;2010/11/08 YM ADD
  )

  ;2010/11/08 YM ADD-S
  ;�V����ި�Ή�į�ߏ������������
  (setq #TOP_F (GetTopFlg))
  ;2010/11/08 YM ADD-E

  ;�f��ID�����߂� [WT�f�ʌ���]
  (setq #DDan$$
    (CFGetDBSQLRec CG_DBSESSION "WT�f�ʌ���"
      (list
        (list "�`��"       (nth  5 CG_GLOBAL$) 'STR)
        (list "���s"       (nth  7 CG_GLOBAL$) 'STR)
        (list "���E����"   (nth 11 CG_GLOBAL$) 'STR)
        (list "�V���N�L��" (nth 17 CG_GLOBAL$) 'STR);2008/09/20 YM ADD
        (list "�g�b�v����" #TOP_F              'STR);2010/11/08 YM ADD
      )
    )
  )
  (if (and #DDan$$ (= 1 (length #DDan$$)))
    (setq #DanmenID (car (car #DDan$$))); ��ӂɌ��܂����ꍇ
    ;else �f�ʂ�����ł��Ȃ��ꍇ
    (setq #DanmenID "STD");�W��
  );_if


  (setq #qry$
    (car (CFGetDBSQLRec CG_DBSESSION "WT�f��"
      (list
        (list "�f��ID" #DanmenID 'STR)
      )
    ))
  )

  #qry$
);GetWtDanmen

;;;<HOM>*************************************************************************
;;; <�֐���>     : PKC_PosBlkByType
;;; <�����T�v>   : �z�u�����ɂ�蕡�����ނ�z�u����
;;; <�߂�l>     :
;;; <�쐬>       : 2000.1.�C�� YM
;;; <���l>       :
;;;                ��������ނ̔z�u�����m�ۂ��Ă���
;;;                  ST_BLKPOS  :��_
;;;                  ST_BLKANG  :�z�u�p�x
;;;                  ST_BLKWID  :�v���@
;;;                  ST_BLKNO   :�z�u���ԍ�
;;;*************************************************************************>MOH<
(defun PKC_PosBlkByType (
  &pln$     ;(LIST)�w�v���\���x���
  &blk$     ;(INT) �w�����\���x���
  &fig$     ;(LIST)�w�i�Ԑ}�`�x���
  &figBase$ ;(LIST)�w�i�Ԋ�{�x���
  &recno    ;(INT)  �z�u�ԍ�
  /
  #ANG2 #B-H #B-WID #BRK-D #BRK-H #BRK-W #DIM-W #DWG #EG #EN #H #I #MOVE
  #MSG #OP-X #OP-Y #OP-Z #POS #PT #PTS-D #PTS-W #SEIKAKU #SS #SYM #TMP$ #TYP
  #VCT-X #VCT-Y #XD$ #SYM_ORG
  #boukaF #D_KyuhaiF #DIR$ #iCODE #HaikiDir #D_KyuDir #D_HaiDir #fig$
#DANMEN #RECNO ;2011/01/26 YM ADD
  )
  (setq #fig$ &fig$)
  (setq #seikaku (fix (nth 3 &figBase$))) ; �i�Ԋ�{ ���iCODE OK
  (if (= #seikaku nil)
    (setq #seikaku -1)
  );_if

  (if (equal (nth 6 &pln$) 9.0 0.001) ;2011/01/26 YM ADD ���i����=9
    (progn
      (setq ST_BLKSTART T) ; Yes ��A�C�e��=0
    )
    (progn
      (if (= (fix (nth 5 &blk$)) 0) ; ��A�C�e�� ;2008/06/23 OK
        (progn
          (setq ST_BLKSTART T) ; Yes ��A�C�e��=0
          (setq ST_BLK$$ nil)  ; No  ��A�C�e�� 0�ȊO
        )
      );_if
    )
  );_if

  (setq #dwg (nth 6 #fig$)) ; �i�Ԑ}�` ;2008/06/23 OK

  (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")))
    (progn
      (setq #msg (strcat "�}�`ID=" (nth 6 #fig$) "�̃}�X�^�[�}�ʂ�����܂���B"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    (progn
      (cond
        ((= ST_BLKSTART T)

          (setq #vct-x (nth  7 &pln$)) ; ����y OK!
          (setq #vct-y (nth  8 &pln$)) ; ����x OK!
          (setq #op-x  (nth  9 &pln$)) ; ����y OK!
          (setq #op-y  (nth 10 &pln$)) ; ����x OK!
          ;// �����W�t�[�h�̏ꍇ�͓V�䍂���́A���͏��̃A�b�p�[�L���r�l�b�g������p����
          ;2011/09/06 YM ADD ���i�^�C�v=9
          (if (or (= (nth 6 &pln$) 3)(= (nth 6 &pln$) 9)) ; ���i�^�C�v OK!
            (setq #op-z  CG_UpCabHeight) ; Yes        �����W�t�[�h�̏ꍇ     OK!
            (setq #op-z  (nth 11 &pln$)) ; No  ����z  �����W�t�[�h�ȊO�̏ꍇ OK!
          )

          (setq #pts-w (fix (nth 12 &pln$))) ; ����w OK!
          (setq #pts-d (fix (nth 13 &pln$))) ; ����d OK!
          (setq #brk-w (nth 14 &pln$))       ; �L�kw OK!
          (setq #brk-d (nth 15 &pln$))       ; �L�kd OK!
          (setq #brk-h (nth 16 &pln$))       ; �L�kh OK!
          (setq #dim-w (advance (nth 3 #fig$) 10))        ; �i�Ԑ}�` ���@w ;2008/06/23 OK
          (setq ST_BLKANG (angle (list 0 0) (list #vct-x #vct-y)))

          (cond
            ((and (= #pts-w -1) (= #pts-d 1))
              (setq #ang2 (angle (list #vct-x #vct-y) (list 0. 0.)))
              (setq #pos (polar '(0 0) #ang2 (distance '(0 0) (list #op-x #op-y))))
              (setq #pos (polar #pos #ang2 #dim-w))
            )
            (T
              ; 04/08/08 YM MOD �����o�^���E�����z�聨�������z��
;;;              (setq #pos (polar '(0 0) ST_BLKANG (distance '(0 0) (list #op-x #op-y))));04/08/08 YM MOD
;             (setq #pos (polar (list #op-x 0) ST_BLKANG (distance (list #op-x 0) (list #op-x #op-y))));04/08/08 YM MOD
              (setq #pos (list #op-x #op-y #op-z)) ; 05/07/12 T.Ari Mod
            )
          )

          (setq ST_BLKWID (advance (nth 3 #fig$) 10))  ;�v���@ ;2008/06/23 OK
          (setq ST_BLKNO &recno)          ;�z�u���ԍ�
          (setq ST_BLKPOS (list (car #pos) (cadr #pos) #op-z))
          (setq #SYM_ORG ST_BLKPOS)

          (command "_insert" (strcat CG_MSTDWGPATH #dwg) #SYM_ORG 1 1 (rtd ST_BLKANG))
        )
        (T
          (setq #tmp$ (assoc (nth 5 &blk$) ST_BLK$$)) ; ��A�C�e�� ;2008/06/23 OK
          (setq ST_BLKWID (nth 3 #tmp$)) ; ??? 600.0
          (setq ST_BLKPOS (nth 2 #tmp$)) ; ??? 150,0,0
          (setq ST_BLKSYM (nth 1 #tmp$)) ; ??? �}�`��

          ;// �A���z�u���ށi��A�C�e���T�u���j�z�u
          (setq #typ (fix (nth 6 &blk$))) ; �����\�� ���� ;2008/06/23 OK

          (cond
            ((= #typ 0)  ;���i���j
              ;// ��A�C�e���̐ڑ��_�i��_�{�v���@�̈ʒu�̓_�j�����
              ;// ��t��������ɂv�����ɕ��ׂĔz�u
              (princ "���i���j")
              (setq #pos (polar ST_BLKPOS ST_BLKANG ST_BLKWID))
              (command "_insert" (strcat CG_MSTDWGPATH #dwg) #pos 1 1 (rtd ST_BLKANG))
            )
            ((= #typ 1)  ;�t�i�E�j
              ;// ��A�C�e���̊�_�i����ю�t�����j����ɂv�t�����ɕ��ׂĔz�u
              ;;;(setq #pos (polar ST_BLKPOS (* -1 ST_BLKANG) ST_BLKWID))
              (princ "�t�i�E�j")
              (setq #pos ST_BLKPOS)
              (command "_insert" (strcat CG_MSTDWGPATH #dwg) #pos 1 1 (rtd ST_BLKANG))
            )
            ((or (= #typ 2) (= #typ 3) (= #typ 4) (= #typ 6)) ;��/��/�P��/�����_
              ;// ��A�C�e���̊�_�i����ю�t�����j�Ƃg�����t���O����ɕ��ׂĔz�u
              (command "_insert" (strcat CG_MSTDWGPATH #dwg) ST_BLKPOS 1 1 (rtd ST_BLKANG))
            )
            ((= #typ 5)  ;�R������t��
              ;// ��A�C�e���̃R������t���ɉ����Ĕz�u
              (princ "�R������t����")
              (setq #ss (ssget "X" '((-3 ("G_PLIN")))))
              (if (/= #ss nil)
                (progn
                  (setq #i 0)
                  (setq #pos nil)
                  (repeat (sslength #ss)
                    (setq #en (ssname #ss #i))
                    (setq #eg (entget #en))
                    (if (and (= #pos nil) (= (cdr (assoc 0 #eg)) "LINE") (= 2 (car (CFGetXData #en "G_PLIN"))))
                      (progn
                        (setq #pos (cdr (assoc 10 (entget #en))))
                        ;2009/03/04 YM MOD-S
                        ;Y���W��0�ɂ���
                        (setq #pos (list (nth 0 #pos) (nth 1 #pos) 0))
                        ;2009/03/04 YM MOD-E
                        (command "_insert" (strcat CG_MSTDWGPATH #dwg) #pos 1 1 (rtd ST_BLKANG))
                      )
                    )
                    (setq #i (1+ #i))
                  )
                  (if (= #pos nil)
                    (progn
                      (setq #msg "�R������t������������܂���")
                      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
                    )
                  )
                )
                (progn    ; G_PLIN ���Ȃ� �`�F�b�N���� 00/03/11 YM ADD
                  (setq #msg "�R������t������������܂���B\nPKC_PosBlkByType")
                  (CMN_OutMsg #msg) ; 02/09/05 YM ADD
                )        ; G_PLIN ���Ȃ� �`�F�b�N���� 00/03/11 YM ADD
              );_if
            )
          );_cond

          ;// �z�u���ԍ����J�E���g�A�b�v
          (setq ST_BLKNO (1+ ST_BLKNO))
        )
      );_(cond

      (command "_layer" "T" "*" "")                     ;�S��w�t���[�Y����
      (command "_layer" "U" "*" "")                     ;�S��w���b�N����
      (command "_explode" (entlast))                    ;�C���T�[�g�}�`����
      (setq #ss (ssget "P"))
      ;(command "-group" "c" #grp #grp #ss "")   ;���������}�`�Q�ŃO���[�v��
      (SKMkGroup #ss)          ;���������}�`�Q�Ŗ��O�̂Ȃ��O���[�v�쐬

      ;// �O���[�v�̒������_�}�`�����߂�
;;;      (setq #sym (SKC_GetSymInGroup (ssname #ss (- (sslength #ss) 1)))) ; #sym �e�}�`
         (setq #sym (PKC_GetSymInGroup #ss))      ;;  2005/08/03 G.YK ADD

      (if (= ST_BLKSTART T)
        (setq ST_BLKSYM #sym)
      )

      (if (= ST_BLKSTART T)
        (setq ST_BLKNO 0)
      ;else
        (progn
          ;// �Ō��"G_SYM"�̎�t�����𒲐�����
          ;// �t���O�� 2 �܂��� 3 �̏ꍇ�͂g�����t���O�����ɒ�������
          ;//
          (setq #typ (fix (nth 6 &blk$))) ; �����\�� ���� ;2008/06/23 OK
          (setq #xd$  (CFGetXData ST_BLKSYM "G_SYM"))

          (setq #pt (cdr (assoc 10 (entget ST_BLKSYM))))
          (setq #h     (nth 6 #xd$))
          (setq #h     (caddr #pt))
          (setq #b-wid (nth 3 #xd$))
          (setq #b-h   (nth 5 #xd$))
          (cond
            ((= #typ 0)    ;���i���j
              ;(setq #move (strcat "0,0," (rtos #h)))
              ;(command "_move" (ssget "P") "" "0,0,0" #move)
            )
            ((= #typ 1)    ;�t�i�E�j
              (setq #xd$  (CFGetXData #sym "G_SYM"))
              (setq #b-wid (nth 3 #xd$))
              (if (/= ST_BLKANG 0.0)
                (setq #pos (polar ST_BLKPOS (* -1 ST_BLKANG) #b-wid))
                (setq #pos (polar ST_BLKPOS pi #b-wid))
              )
              (command "_move" (ssget "P") "" "@" #pos)

              ;(setq #move (strcat "0,0," (rtos #h)))
              ;(command "_move" (ssget "P") "" "0,0,0" #move)
            )
            ((= #typ 2)    ;��
              ;(setq #move (strcat "0,0," (rtos #h)))
              (setq #move (strcat "0,0," (rtos #b-h)))
              (command "_move" (ssget "P") "" "0,0,0" #move)
              ;2008/08/20 YM ADD ���s�������ĐH�������Ɉړ�����
              (if (= #seikaku 110);DEEP�H�� 111�͏��O�����
                (progn ;�H��̂Ƃ�
                  ;2011/03/31 YM MOD-S SKB��D1050�̂Ƃ����H���p���ނ�D700�p�ɂȂ邱�Ƃ�����̂�
                  ;�H�����ނ̕i��9����="Q"���ǂ�����50mm���炷���ǂ����𔻒f����

                  ;2011/03/31 YM ADD-S �V����ި�Ή� �ꍇ�킯
                  (cond
                    ((= BU_CODE_0009 "1") 
                      ;SKB�̏ꍇ�@;DEEP�H�� 111�͏��O�����
                      (if (= "Q" (substr CG_SYOKUSEN_CAB 9 1))
                        (progn
                          ;�H�����O��50mm�ړ�����
                          (setq #move (strcat "0,-50,0"))
                          (command "_move" (ssget "P") "" "0,0,0" #move)
                        )
                      );_if
                    )
                    (T
                      ;�]���ǂ���
                      (cond
                        ((or (= "D900" (nth  7 CG_GLOBAL$))(= "D700" (nth  7 CG_GLOBAL$)));���s��
                          ;�H�����O��50mm�ړ�����
                          (setq #move (strcat "0,-50,0"))
                          (command "_move" (ssget "P") "" "0,0,0" #move)
                        )
            ;;;                   ;2008/09/19 YM DEL D600��p�H��̂Ƃ��͈ړ��s�v
            ;;;;;;                    ((= "D600" (nth  7 CG_GLOBAL$));���s��
            ;;;;;;                      ;�H�������50mm�ړ�����
            ;;;;;;                      (setq #move (strcat "0,50,0"))
            ;;;;;;                      (command "_move" (ssget "P") "" "0,0,0" #move)
            ;;;;;;                    )
                        (T
                          nil
                        )
                      );_cond
                    )
                  );_cond

                )
              );_if


            )
            ((= #typ 3)    ;��
              (if (= (nth 1 (FlagToList #seikaku)) 1)      ;  �ް��̂Ƃ� 00/03/31 YM ADD
                (progn
                  (setq #xd$  (CFGetXData #sym "G_SYM"))   ;  �ް��̂Ƃ�
                  (setq #b-h   (nth 5 #xd$))
                )
              );_if                                        ; 00/03/31 YM ADD
              (setq #move (strcat "0,0," (rtos (* -1 #b-h))))
              (command "_move" (ssget "P") "" "0,0,0" #move)
            )
            ((= #typ 4)    ;�P��
              (princ)
            )
            ((= #typ 5)    ;�R������t��
              ;;;(setq #move (strcat "0,0," (rtos #h)))
              (setq #move (strcat "0,0," (rtos #b-h)))
              (command "_move" (ssget "P") "" "0,0,0" #move)
            )
            ((= #typ 6)    ;�����_
              (princ)
            )
          )
        )
      )
      ;// �z�u�}�`�ɑ������Ƃ��ă��R�[�h�ԍ�����������
      ;// �i�A���z�u���̊J�n��A�C�e���ԍ��Ƃ��ĎQ�Ƃ���邽�߁j
      ;//
      ;// �V���{����_�g���f�[�^"G_LSYM"�̐ݒ�
      ;//  1 :�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID
      ;//  2 :�}���_          :�z�u��_
      ;//  3 :��]�p�x        :�z�u��]�p�x
      ;//  4 :�H��L��        :CG_Kcode
      ;//  5 :SERIES�L��    :CG_SeriesCode
      ;//  6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���
      ;//  7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪
      ;//  8 :���}�`ID        :
      ;//  9 :���J���}�`ID    :
      ;//  10:���iCODE      :�w�i�Ԋ�{�x.���iCODE
      ;//  11:�����t���O      :�P�Œ�i�������ށj
      ;//  12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
      ;//  13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�
      ;//  14:���@�g          :�w�i�Ԑ}�`�x.���@�g
      ;//  15:�f�ʗL��        :�w�v���\���x.�f�ʗL��

      (setq ST_BLKPOS (cdr (assoc 10 (entget #sym))))
      (setq ST_BLKWID (advance (nth 3 #fig$) 10))  ; �i�Ԑ}�` �v���@ ;2008/06/23 OK


      (if (equal (nth 6 &pln$) 9.0 0.001) ;2011/01/26 YM ADD ���i����=9
        (progn
          ;&blk$�@���y�����\���z�̌`���ł͂Ȃ�
          ; �����\�� recno
          (setq #recno 1.0)
          ;�f�ʎw���̗L��
          (setq #danmen 1)
        )
        (progn
          ; �����\�� recno
          (setq #recno (nth 1 &blk$))
          ;�f�ʎw���̗L��
          (setq #danmen (fix (nth 8 &blk$)))
        )
      );_if

      (setq ST_BLK$$
        (append ST_BLK$$ (list
          (list
            ;(nth 1 &blk$) ; �����\�� recno ;2011/01/26 YM MOD
            #recno ;2011/01/26 YM MOD
            #sym
            ST_BLKPOS
            ST_BLKWID
          )
        ))
      )

      (setq #xd$
        (list
          (nth 6 #fig$)         ;1 :�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID    ;2008/06/23 OK
          ST_BLKPOS             ;2 :�}���_          :�z�u��_
          ST_BLKANG             ;3 :��]�p�x        :�z�u��]�p�x
          CG_Kcode              ;4 :�H��L��        :CG_Kcode
          CG_SeriesCode         ;5 :SERIES�L��    :CG_SeriesCode
          (nth 0  #fig$)        ;6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���  OK!
          (nth 1  #fig$)        ;7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪 OK!

          ""         ;8 :���}�`ID        :                            OK!
          ""         ;9 :���J���}�`ID    :                            OK!

          (fix #seikaku)        ;10:���iCODE      :�w�i�Ԋ�{�x.���iCODE
          1                     ;11:�����t���O      :1:�Œ�i�������ށj
          ST_BLKNO              ;12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
          (fix (nth 2 #fig$))   ;13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�
          (fix (nth 5 #fig$))   ;14:���@�g          :�w�i�Ԑ}�`�x.���@�g

          ;(fix (nth 8 &blk$))   ;15.�f�ʎw���̗L��  :�w�����\���x.�f�ʗL��  ;2011/01/26 YM MOD
          #danmen ;2011/01/26 YM MOD
          (GetBunruiAorD)       ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
        )
      );_(setq #xd$

      (CFSetXData #sym "G_LSYM" #xd$)
      (KcSetG_OPT #sym) ; �g���ް�"G_OPT"��� 01/02/16 MH ADD

    );_(progn
  );_if

  (princ)
);PKC_PosBlkByType

;;;<HOM>*************************************************************************
;;; <�֐���>    : PFGetCompBase
;;; <�����T�v>  : �\�����ގ擾(�\���^�C�v=1) CG_UnitBase="1"
;;; <�߂�l>    : �v���\���x���̃��X�g
;;; <�쐬>      : 2000.1.19�C��KPCAD
;;; <���l>      : �x�[�X
;;;*************************************************************************>MOH<
(defun PFGetCompBase (
  /
  #I #MSG #QRY$ #QRY$$ #LIST$$ #DB_NAME #PLAN_ID
  )

;;;	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
;;;		(progn
;;;
;;;		  ;2017/09/07 YM MOD �ڰѷ���
;;;		  (setq #LIST$$
;;;		    (list
;;;		      (list "���j�b�g�L��"       (nth  3 CG_GLOBAL$) 'STR)
;;;		      (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
;;;		      (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
;;;		      (list "�\���^�C�v"         "1"                 'INT)
;;;		      (list "�t���A�L���r�^�C�v" (nth  6 CG_GLOBAL$) 'STR)
;;;		      (list "�V���N�ʒu"         (nth  2 CG_GLOBAL$) 'STR)
;;;		      (list "�R�����ʒu"         (nth  9 CG_GLOBAL$) 'STR)
;;;		      (list "�H��ʒu"           (nth 10 CG_GLOBAL$) 'STR)
;;;		      (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
;;;		      (list "�V���N�L��"         (nth 17 CG_GLOBAL$) 'STR)
;;;		      (list "SOFT_CLOSE"         (nth  8 CG_GLOBAL$) 'STR)
;;;		      (list "�V��_�݌ˍ���"      (nth 31 CG_GLOBAL$) 'STR)
;;;		      (list "�J�E���^�ގ�"       (nth 16 CG_GLOBAL$) 'STR) ;�ǉ�
;;;		    )
;;;		  )
;;;
;;;		)
;;;		(progn

		  ;2008/06/21 YM MOD [�v���Ǘ�]���������
		  (setq #LIST$$
		    (list
		      (list "���j�b�g�L��"       (nth  3 CG_GLOBAL$) 'STR)
		      (list "�V���N���Ԍ�"       (nth  4 CG_GLOBAL$) 'STR)
		      (list "�`��"               (nth  5 CG_GLOBAL$) 'STR)
		      (list "�\���^�C�v"         "1"                 'INT)
		      (list "�t���A�L���r�^�C�v" (nth  6 CG_GLOBAL$) 'STR)
		      (list "�V���N�ʒu"         (nth  2 CG_GLOBAL$) 'STR)
		      (list "�R�����ʒu"         (nth  9 CG_GLOBAL$) 'STR)
		      (list "�H��ʒu"           (nth 10 CG_GLOBAL$) 'STR)
		      (list "���s��"             (nth  7 CG_GLOBAL$) 'STR)
		      (list "�V���N�L��"         (nth 17 CG_GLOBAL$) 'STR)
		      (list "SOFT_CLOSE"         (nth  8 CG_GLOBAL$) 'STR)
		      (list "�V��_�݌ˍ���"      (nth 31 CG_GLOBAL$) 'STR)
		    )
		  )

;;;		)
;;;	);_if


  (setq #DB_NAME "�v���Ǘ�")

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$)
  )

  (setq #qry$ (DBCheck #qry$ "�w�v���Ǘ��x" "PFGetCompBase")) ; ��������WEB��۸ޏo��

  (if (= CG_TESTMODE 1) ; ý�Ӱ��
    (setq P_baseID (strcat "����ID(�۱)= [" (rtois (car #qry$)) "]"))
  );_if

  ; �v����ID
  (setq #plan_id (nth 0 #qry$))
  ; �V���N�ʒu�I�t�Z�b�g�ʂ��m��
  (setq CG_WSnkOf (nth 11 #qry$))

  ;;;// �w�v���\���x�������A
  (setq #DB_NAME "�v���\��")
  (WebOutLog (strcat "����DB��= "  #DB_NAME))

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME
      (list
        (list "�v����ID"  #plan_id  'STR)
        (list "order by \"RECNO\"" nil  'ADDSTR)
      )
    )
  )

  (if (= #qry$$ nil)
    (progn
      (setq #msg (strcat "�w�v���\���x�Ƀ��R�[�h������܂���B\nPFGetCompBase"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
      (quit)
    )
  );_if
  (list #qry$ #qry$$)
);PFGetCompBase

(princ)
