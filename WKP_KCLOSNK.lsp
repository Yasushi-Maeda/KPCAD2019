;;; �����p
;;;(defun C:PosSink  �@�@�@�@      �V���N�E�����̔z�u�R�}���h
;;;(defun SKW_OpPosSink2           �V���N�E�����̔z�u�֐�(�z�u�A�ύX�p)
;;;(defun SKW_GetSinkInfoN         �V���N���A���������A������ޏ����擾����
;;;(defun KPSelectSinkDlg          �V���N�I���_�C�A���O
;;;(defun PK_MakeG_WTR             �~"G_WTR"���쐬����
;;;(defun PKW_PosWTR               ������z�u����
;;;(defun PKWTSinkAnaEmbed         WT�}�`,�ݸ����ِ}�`��n����WT�̌��𖄂߂�
;;;(defun SKW_GetSnkCabAreaSym     �V���N�L���r�l�b�g�̗̈�Ɋ܂܂��V���{���}�`����������

;;;(defun SKC_ConfSinkChkErr
;;;(defun SKC_GetTopRightBaseCabPt �x�[�X�L���r�l�b�g�̍ŉE�̍��W�����߂�
;;;(defun SKW_DelSink              �V���N�E�����̍폜 �ݸ�ύX���A�폜�Ɏg�p
;;;(defun C:ChgSink                �V���N�E�����̕ύX�R�}���h
;;;(defun PKC_GetSuisenAnaPt       �V���N���̐���(PTEN5����0)�ʒu���W�̃��X�g

;;;(defun PK_CheckExistSuisen      ���������݂����T��Ԃ��Ȃ����nil
;;;(defun PK_GetWTunderSuisen      ��������WT��Ԃ�
;;;(defun PK_GetPTEN5byPT          ��������WT��Ԃ�
;;;(defun PcSetWaterTap            ����ݒu����
;;;(defun PcInsSuisen&SetX         �}�`��}���A�g���f�[�^�ݒu(���t�@�C������)

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:PosSink
;;; <�����T�v>  : �V���N�E�����̔z�u�R�}���h
;;; <�߂�l>    :
;;; <�쐬>      : 1999-10-12
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:PosSink (
  /
  #SFLG #sys$ #PD #pdsize
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:PosSink ////")
  (CFOutStateLog 1 1 " ")

  ;// �R�}���h�̏�����

  (StartUndoErr)
  (CFCmdDefBegin 6);00/09/26 SN ADD

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

  (setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "PDSIZE" 10)
  (setvar "pdmode" 34)

; 01/06/28 YM ADD ����ނ̐��� Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn


  ;// �V���N�̔z�u
  (SKW_OpPosSink2 0)

;;;03/09/29YM@MOD  ;// �\����w�̐ݒ� ; 00/09/18 YM ADD
;;;03/09/29YM@MOD  (command "_layer"
;;;03/09/29YM@MOD    "F"   "*"                ;�S�Ẳ�w���t���[�Y
;;;03/09/29YM@MOD    "T"   "Z_00*"            ;  Z_00���̃\���b�h��w�̃t���[�Y����
;;;03/09/29YM@MOD    "T"   "N_*"              ;  N_*�V���{�����_�}�`��w�̃t���[�Y����
;;;03/09/29YM@MOD    "T"   "M_*"              ;  M_*�ڒn�̈�}�`��w�̉���
;;;03/09/29YM@MOD    "T"   "0"                ;  "0"��w�̉���
;;;03/09/29YM@MOD    "ON"  "M_*"              ;  M_*�ڒn�̈�}�`��w�̕\��
;;;03/09/29YM@MOD    "OFF" "N_B*" ""          ;  N_B*�u���[�N���C���}�`�̔�\��
;;;03/09/29YM@MOD  )
;;;03/09/29YM@MOD  (command "_.layer" "T" "Z_KUTAI" "") ; 01/04/23 YM ADD
  (SetLayer);03/09/29 YM MOD

  (princ "\n�V���N��z�u���܂���.") ;00/01/30 HN ADD ���b�Z�[�W�\����ǉ�

  ); 01/06/28 YM ADD ����ނ̐��� Lipple
);_if

  (CFCmdDefFinish);00/09/26 SN ADD
  (setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)
  (setq *error* nil)
  (princ)

);C:PosSink

;;;<HOM>*************************************************************************
;;; <�֐���>    : SKW_OpPosSink2
;;; <�����T�v>  : �V���N�E�����̔z�u
;;; <�߂�l>    :
;;; <�쐬>      : 1999-10-12 04/10 YM �C�� 00/05/02 YM �C��
;;; <���l>      : �V���N�z�u�A�V���N�ύX�R�}���h��DelFlg�ɂ��敪���Ă���
;;;               &DelFlg=0(�V���N�z�u)  &DelFlg=1(�V���N�ύX)
;;;*************************************************************************>MOH<
(defun SKW_OpPosSink2 (
  &DelFlg ;(INT)���̃V���N�A�������폜���邩�ǂ����̃t���O ; 0:�폜���Ȃ� 1:�폜����
  /
  #ANG #BASEPT #DUM$ #DUMPT$ #G_WTR$ #HDL_SNK #I #KOSU #LOOP #LR #NAME$
  #P1 #P2 #P3 #P4 #PLIS$ #PMEN2 #PTA$ #PTB$ #QRY$ #RET$ #SCAB-EN #SETXD$
  #SINK$ #SKK$ #SNK-EN #SNK_DIM #SPT #SS #SUI$ #SYM$ #W-EN #W-XD$
  #WSFLG #ZAICODE #ZAIF #POCKET
  #WTRSYM$ #retWTR$
;-- 2011/09/16 A.Satoh Add - S
  #width #kikaku_f #toku
;-- 2011/09/16 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKW_OpPosSink2 ////")
  (CFOutStateLog 1 1 " ")

  ;// ���[�N�g�b�v�̎w��
  (setq #loop T)
  (while #loop
    (setq #w-en (car (entsel "\n���[�N�g�b�v��I��: ")))
    (if #w-en
      (progn
        (setq #w-xd$ (CFGetXData #w-en "G_WRKT"))
        (if (= #w-xd$ nil)
          (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
          (progn ; WT�̏ꍇ
            (if (CFGetXData #w-en "G_WTSET")
              (progn ; �i�Ԋm��ς݂̏ꍇ
                (if (CFYesNoDialog "���[�N�g�b�v�͊��ɕi�Ԋm�肳��Ă��܂��B\n�����𑱂��܂����H")
                  (progn ; YES �Ȃ� WT�����ߏ���
                  ;;; "G_WTSET"������
                    (DelAppXdata #w-en "G_WTSET")
                    (setq #WSflg T) ; �����ߕK�v
                  )
                  (quit) ; NO
                );_if
              )
            );_if
            (setq #loop nil)
          )
        );_if
      )
      (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
    );_if
  )

  ;// �ꎞ�I�ɐF��ς���
  (PCW_ChColWT #w-en "MAGENTA" nil)
  ;// �V���N�L���r�l�b�g���w��������
  (setq #loop T)
  (while #loop
    (setq #scab-en (car (entsel "\n�V���N�L���r�l�b�g��I��: ")))
    (if #scab-en
      (progn
        (setq #scab-en (CFSearchGroupSym #scab-en)) ; �ݸ����ِ}�`��
        (if #scab-en
          (progn
            ;// ���������L���r�l�b�g�̐��iCODE���擾����
            (setq #skk$ (CFGetSymSKKCode #scab-en nil))
            ;�V���N�L���r�l�b�g
            (if (= (caddr #skk$) CG_SKK_THR_SNK) ;  CG_SKK_THR_SNK defined in GROBAL
              (progn ; �ݸ���ނ�����
                (setq #loop nil)
              )
              (CFAlertMsg "�V���N�L���r�l�b�g�ł͂���܂���")
            );_if
          )
          (CFAlertMsg "�V���N�L���r�l�b�g�ł͂���܂���")
        );_if
      )
      (CFAlertMsg "�V���N�L���r�l�b�g�ł͂���܂���")
    );_if
  );_while

  ;// �F��߂�
  (PCW_ChColWT #w-en "BYLAYER" nil)
;;; �����̼ݸ�����邩�ǂ�������
  (command "vpoint" "0,0,1")
  (setq #sym$ '())
  ;;; �ݸ�����l�� 06/27 YM
  (setq #pmen2 (PKGetPMEN_NO #scab-en 2))   ; �ݸ����PMEN2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 #scab-en))   ; PMEN2 ���쐬
  );_if
  (setq #spt (cdr (assoc 10 (entget #scab-en)))) ; ����ي�_
  (setq #ptA$ (GetLWPolyLinePt #pmen2))     ; �ݸ����PMEN2 �O�`�̈�
  (setq #dumpt$ (GetPtSeries #spt #ptA$))   ; #BASEPT ��擪�Ɏ��v���� (00/05/20 YM)
  (if #dumpt$
    (setq #ptA$ #dumpt$) ; nil �łȂ�
    (progn ; �O�`�_���ɼ���ق��Ȃ��ꍇ
      (setq #BASEPT (PKGetBaseI4 #ptA$ (list #scab-en))) ; �_��Ƽ���ي�_�P�� (00/05/20 YM)
      (setq #ptA$ (GetPtSeries #BASEPT #ptA$))           ; #BASEPT ��擪�Ɏ��v���� (00/05/20 YM)
    )
  );_if

  (setq #p1 (nth 0 #ptA$))
  (setq #p2 (nth 1 #ptA$))
  (setq #p3 (nth 2 #ptA$))
  (setq #p4 (nth 3 #ptA$))
  ;;; D750 WT�Ή�100mm����Ɋg�� 00/07/03 YM ADD
  (setq #ang (nth 2 (CFGetXData #scab-en "G_LSYM"))) ; �z�u�p�x
  (setq #p1 (polar #p1 (+ #ang (dtr 90)) 100))
  (setq #p2 (polar #p2 (+ #ang (dtr 90)) 100))
  (setq #ptB$ (list #p1 #p2 #p3 #p4 #p1))
  (setq #hdl_SNK (PKGetSinkSymBySinkCabCP #scab-en)) ; �ݸ���ޗ̈�Ɋ܂܂��ݸ����������
  (setq #sym$ (PKGetSinkSuisenSymCP #ptB$))          ; �ݸ,�������ِ}�`��ؽ�

  (if (= &DelFlg 0)
    (if (> (length #sym$) 0) ; �ݸ+����

;;;01/03/23YM@      (if (CFYesNoDialog "�����̃V���N���폜���܂����H")
;;;01/03/23YM@        (progn
;;;01/03/23YM@          (if #WSflg         ; �����ߕK�v
;;;01/03/23YM@            (PKWTSinkAnaEmbed #w-en #hdl_SNK T) ; WT�}�`,�ݸ����ِ}�`��n����WT�̌��𖄂߂�
;;;01/03/23YM@          );_if
;;;01/03/23YM@
;;;01/03/23YM@          (foreach #sym #sym$
;;;01/03/23YM@            (setq #ss (CFGetSameGroupSS #sym))
;;;01/03/23YM@            (command "_erase" #ss "")    ; �ݸ�A�������폜����
;;;01/03/23YM@          )
;;;01/03/23YM@        ;;; �̈�Ɋ܂܂�鐅����"G_WTR"ؽ�
;;;01/03/23YM@          (setq #G_WTR$ (PKGetG_WTRCP #ptB$))
;;;01/03/23YM@          (foreach #G_WTR #G_WTR$
;;;01/03/23YM@            (command "_erase" #G_WTR "") ; "G_WTR"���폜����
;;;01/03/23YM@          )
;;;01/03/23YM@        )
;;;01/03/23YM@        (progn
;;;01/03/23YM@          (CFAlertMsg "�V���N�����ɑ��݂��邽�ߔz�u���܂���ł����B")
;;;01/03/23YM@          (*error*)
;;;01/03/23YM@        )
;;;01/03/23YM@      );_if
      (progn
        (CFAlertMsg "�V���N�����݂��܂��B")
        (*error*)
      )
    );_if
  );_if

  (if (= &DelFlg 1)
    (progn
      (SKW_DelSink #WSflg #scab-en #w-en #w-xd$) ; �������׸�,�ݸ���޼���ِ}�`��,WT�}�`��,"G_WRKT"
      ;;; �̈�Ɋ܂܂�鐅����"G_WTR"ؽ�
      (setq #G_WTR$ (PKGetG_WTRCP #ptB$))
      (foreach #G_WTR #G_WTR$
        (command "_erase" #G_WTR "") ; "G_WTR"���폜����
      )
    )
  );_if

  (command "zoom" "p")
  (setq #ZaiCode   (nth 2 #w-xd$))  ;�ގ��L��
  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ
  ;// WT�V���N��ں��ނ��擾���� �ݸ,�������
;-- 2012/04/20 A.Satoh Add �V���N�z�u�s��Ή� - S
;;;;;  (setq #ret$ (SKW_GetSinkInfoN #w-xd$ #scab-en #ZaiCode #ZaiF))

;;;	(CFAlertMsg "���i�P�j�� ��PG���C�� SKW_GetSinkInfoN�y�V���N���i���݁zERRMSG.INI�����ɍs��") ;2017/01/19 YM ADD

  (setq #ret$ (SKW_GetSinkInfoN #w-xd$ #scab-en #ZaiCode #ZaiF #w-en))
;-- 2012/04/20 A.Satoh Mod �V���N�z�u�s��Ή� - E
  (if (= #ret$ nil)
    (*error*) ; cancel�̏ꍇ
    (progn
      (setq #sink$   (nth 0 #ret$)) ; 0:�I�����ꂽ"SINK�ʒu" ں���
      (setq #name$   (nth 1 #ret$)) ; 1:�I�����ꂽ"WT�V���N" ں���
      (setq #SNK_DIM (nth 2 #ret$)) ; 2:�I�����ꂽ�ݸ�e���@
      (setq #LR      (nth 3 #ret$)) ; 3:�I�����ꂽ�ݸ����LRZ
      (setq #sui$    (nth 4 #ret$)) ; 4:�I�����ꂽ"WT������" ں���
      (setq #plis$   (nth 5 #ret$)) ; 5:�I�����ꂽ"WT������" ں��� (���� -2,-1,0,1,2 �̏�) nil ����
      (setq #pocket  (nth 6 #ret$)) ; 6:�ݸ�߹�ėL��"Y" or "N"
;-- 2011/09/17 A.Satoh Add - S
      (setq #width   (nth 7 #ret$)) ; �ݸ���޾����ʒu�ύX�O
;-- 2011/09/17 A.Satoh Add - E
      ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
      (CFNoSnapStart)
      ;// �I�����ꂽ�������ɃV���N�y�ѐ����A�򐅊�Ȃǂ�z�u����
      (setq #snk-en            ;(ENAME)�V���N��_�}�`
        (KPW_PosSink2
          #name$
          #scab-en             ;(ENAME)�ݸ���ފ�_�}�`
          #w-xd$               ;(LIST)WT�g���f�[�^
          #SNK_DIM             ;(REAL)�v�����̾��(�ݸ�e���@)
          #LR                  ;�ݸ����LRZ
          #ZaiF                ;�f��F
          #pocket              ;�ݸ�߹�ėL��"Y" or "N"
;-- 2011/09/17 A.Satoh Add - S
          #width               ;�ݸ���޾����ʒu�ύX�O
;-- 2011/09/17 A.Satoh Add - E
        )
      ); end of setq
      ;;; �ݸ�̔z�u�I��

;2014/08/11 YM ADD-S
(KcSetSinkG_OPT_KPCAD #snk-en #ZaiCode (nth 1 #name$)) ; �g���ް�"G_OPT"���
;2014/08/11 YM ADD-E

      (if (not (tblsearch "APPID" "G_SINK")) (regapp "G_SINK"))

; 01/07/17 YM ADD PKW_PosWTR�̖߂�l�ǉ�
;;;(list #WtrHoleEn$ #WTRSYM$) (������(G_WTR)��ʐ}�`,����SYM)

      ;// �����֘A�̔z�u
      (setq #retWTR$
        (PKW_PosWTR
          (nth 0 #w-xd$)       ;(STR)�H��L�� "K"
          (nth 1 #w-xd$)       ;(STR)SERIES�L��
          #snk-en              ;(ENAME)�V���N�}�`
          (nth 1 #name$)       ;(STR)�V���N�L�� "K"
          #plis$               ;�I�����ꂽ"WT������" ں��� (���� -2,-1,0,1,2 �̏�) nil ����
;-- 2011/09/18 A.Satoh Add - S
          #scab-en             ;(ENAME)�ݸ���ފ�_�}�`
          (nth 9 #name$)       ; �K�i������
;-- 2011/09/18 A.Satoh Add - E
        )
      )

      (setq #g_wtr$  (car  #retWTR$)) ; �߂�l "G_WTR"
      (setq #WTRSYM$ (cadr #retWTR$)) ; �߂�l ����SYMؽ�
;-- 2011/09/17 A.Satoh Add - S
      (setq #kikaku_f (caddr #retWTR$))
;-- 2011/09/17 A.Satoh Add - E

;;;00/12/20YM@      ;;; �V���N���L�����������A"G_SINK"�ɓ����
;;;00/12/20YM@      (setq #SNKANA_rec$ ; �P��������
;;;00/12/20YM@        (CFGetDBSQLRec CG_DBSESSION "SINK���L"
;;;00/12/20YM@          (list
;;;00/12/20YM@            (list "�V���N�L��" (nth 1 #name$) 'STR)
;;;00/12/20YM@            (list "�������L��" (nth 1 #sui$)  'STR)
;;;00/12/20YM@          )
;;;00/12/20YM@        )
;;;00/12/20YM@      );_(setq
;;;00/12/20YM@      (setq #SNKANA_rec$ (DBCheck #SNKANA_rec$ "�w�V���N���L�x" "SKW_OpPosSink2")) ; nil or ������ �װ

      (CFSetXData #snk-en "G_SINK"
        (list
          (nth 1 #name$)  ; �V���N�L��
;-- 2011/06/29 A.Satoh Mod - S
;          (nth 1 #sui$)   ; �������L��
          (if #sui$
            (nth 1 #sui$)   ; �������L��
            ""
          )
;-- 2011/06/29 A.Satoh Mod - E
          (if (= #pocket "Y")
            1             ; �ݸ�߹�Ă̗L 1
            0             ; �ݸ�߹�Ă̖� 0
          );_if
          ""              ; �V���N���}�`�n���h��(�i�Ԋm�莞)
        )
      );_CFSetXData

      ;;; �ݸ���ʐ}�`�̈ړ� 01/02/16 YM
      (PKC_MoveToSGCabinetSub #snk-en #scab-en) ; (�ݸ or ���� , �ݸ����)

      ; �����͈ړ����Ȃ�
;;;     ; 01/07/17 YM ADD ���������ʐ}�ړ� START
;;;     (foreach #WTRSYM #WTRSYM$
;;;       (PKC_MoveToSGCabinetSub #WTRSYM #scab-en) ; (�ݸ or ���� , �ݸ����)
;;;     )
      ; 01/07/17 YM ADD ���������ʐ}�ړ� END

      ;// �������֘A�̊g���f�[�^���X�V�ݒ肷�� 07/06 YM �폜���ĂȂ��������͎c��������ǉ�
      (setq #w-xd$ (CFGetXData #w-en "G_WRKT"))
;-- 2011/09/09 A.Satoh Del - S
;      (setq #i 23)
;      (repeat (nth 22 #w-xd$)
;        (if (/= (nth #i #w-xd$) "")
;          (if (entget (nth #i #w-xd$)); �����Ȑ}�`���łȂ�
;            (setq #dum$ (append #dum$ (list (nth #i #w-xd$)))) ; �폜���Ă��Ȃ��̂Ŏc��"G_WTR"
;          );_if
;        );_if
;        (setq #i (1+ #i))
;      )
;
;      (if (> (length #g_wtr$) 0) ; �V�����z�u�����������̐�
;        (foreach #en #g_wtr$
;          (setq #dum$ (append #dum$ (list #en)))
;        )
;      );_if
;      (setq #kosu (length #dum$))
;      (if (> 7 (length #dum$))
;        (repeat (- 7 (length #dum$)) (setq #dum$ (append #dum$ (list ""))))
;      );_if
;-- 2011/09/09 A.Satoh Del - E

;-- 2011/09/17 A.Satoh Add - S
      (if (= #kikaku_f T)
        (setq #toku "")
        (setq #toku "TOKU")
      )
;-- 2011/09/17 A.Satoh Add - E
      (setq #setxd$
        (list
;-- 2011/09/09 A.Satoh Mod - S
;          (list 22 #kosu)
;          (list 23 (nth 0 #dum$))
;          (list 24 (nth 1 #dum$))
;          (list 25 (nth 2 #dum$))
;          (list 26 (nth 3 #dum$))
;          (list 27 (nth 4 #dum$))
;          (list 28 (nth 5 #dum$))
;          (list 29 (nth 6 #dum$))
          (list 22 0)
          (list 23 "")
          (list 24 "")
          (list 25 "")
          (list 26 "")
          (list 27 "")
          (list 28 "")
          (list 29 "")
;-- 2011/09/09 A.Satoh Mod - E
;-- 2011/09/17 A.Satoh Add - S
          (list 58 #toku)
;-- 2011/09/17 A.Satoh Add - E
        )
      )
      ;// ���[�N�g�b�v�g���f�[�^�̍X�V
      (setq #w-xd$ (CFGetXData #w-en "G_WRKT"))
      (CFSetXData #w-en "G_WRKT"
        (CFModList #w-xd$ #setxd$)
      )
      (CFNoSnapFinish)
    )
  );_if
  (princ)
);SKW_OpPosSink2

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KP_SrcWTcolTbl
;;; <�����T�v>  : WT�װð��ق��������A�u�ގ��v���擾����
;;; <�߂�l>    : �u�ގ��v="G"
;;; <�쐬>      : 01/07/03 YM SK�ذ�ޗp
;;; <���l>      :
;;; ***********************************************************************************>MOH<
(defun KP_SrcWTcolTbl ( &ZAICODE / #QRY$)
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "WTCOLOR"
      (list (list "�ގ��L��" &ZAICODE 'STR))
    )
  )
  (if #qry$
    (nth 2 (car #qry$))
    "F"
  );_if
);KP_SrcWTcolTbl

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPSelectSinkDlg
;;; <�����T�v>  : �V���N�I���_�C�A���O
;;; <�߂�l>    : (list #sink$ #name$ #SNK_DIM #LR)
;;;                 "SINK�ʒu","WT�V���N",�ݸ�e���@,�ݸLRZ
;;; <�쐬>      : 2000.5.2 YM �V�K�쐬 00/09/21 �W����
;;; <���l>      : DB�ύX �ݸ���ނɂ��ݸ���i�荞�݁A�ݸ�����܂�ƈʒu���i���
;;;  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;  !!! �q���� �֐��@defun ��`���Alocal�ϐ�����` or ��`�͏d�v   �ύX�͗v���� !!!
;;;  !!! #sui$$ �̏����� #sui$,#snk �̒l�d�v                                     !!!
;;;  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;; 07/22 plis1,2,3 �u��������v�Ő��������ׂāu�Ȃ��v�̏ꍇ�A999���Z�b�g
;;;*************************************************************************>MOH<
(defun KPSelectSinkDlg (
  &XD_WRKT   ; "G_WRKT"
  &ZAIF      ; �f��F
  &SNKCAB_LR ; �ݸ����LR�敪 ; 0/12/14 YM MOD
  &sink$     ;(LIST)SINK�ʒu�e�[�u���̓��e����2011/09/14 �ݸ�L���݂̂�ؽĂɕύX
  &name$$    ;(LIST)WT�V���N�e�[�u���̓��e
;-- 2011/09/15 A.Satoh Add - S
  &CAB       ; �V���N�L���r�l�b�g�}�`��
;-- 2011/09/15 A.Satoh Add - E
  /
  #DCL_ID #DIM #I #J #RET$ #lst
  #HINBAN$$
  #POP1 #POP2 #POP3 #POP4 #POP5
  #plis1$ #plis2$ #plis3$ #plis4$ #plis5$
  #RET$ #SNK #sui$ #sui$$ #dimST #dimRP
  #dum$$ #i0 #dum #i1 #i2
  #DIMA #DIMST$ #dimRP$ #FOCUS #NMAG1 #NMAG2 #WT_TYPE #ZAIF #dimA$
  #POP1FLG #POP2FLG #POP3FLG #POP4FLG #POP5FLG ; 01/03/30YM ADD
;-- 2011/09/16 A.Satoh Add - S
#xd_G_LSYM$ #hinban #LR #youto #qry$$ #width #mode_f$
;-- 2011/09/16 A.Satoh Add - E
#umu_LR  ;-- 2012/05/18 A.Satoh Add LR�L������s��
#WIDTH_CAB #WIDTH_SP ;2017/01/19 YM ADD
  )

  ;2011/09/14 YM ADD-S
  (setq #SNK_KATTE (nth 30 &XD_WRKT));�ݸ����
  ;2011/09/14 YM ADD-S

;;; (if (equal &ZAIF 1 0.1) ; �f��F
;;;   (setq #i0 3)  ; ���ڽ
;;;   (setq #i0 13) ; �l��
;;; );_if
;;; (setq #i0 3)  ; ���ڽ
  (setq #i1 2)  ; ���ڽ
  (setq #i2 12) ; �l��


  (setq #nMAG1 (itoa (fix (+ (car  (nth 55 &XD_WRKT)) 0.1))))
  (setq #nMAG2 (itoa (fix (+ (cadr (nth 55 &XD_WRKT)) 0.1))))

  (setq #ZaiF (itoa (fix &ZaiF)))
  (cond
    ((= (nth 3 &XD_WRKT) 0)(setq #WT_type "I")) ; I�^
    ((= (nth 3 &XD_WRKT) 1)
      (setq #WT_type "L")
    ) ; L�^
    ((= (nth 3 &XD_WRKT) 2)(setq #WT_type "U")) ; U�^
    (T (setq #WT_type nil))
  );_cond

;;;2011/09/14YM@DEL    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;2011/09/14YM@DEL    ; �W���ݸ�e���@�����߂�
;;;2011/09/14YM@DEL    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;2011/09/14YM@DEL    (defun ##GetDimA (
;;;2011/09/14YM@DEL      &snk  ; �ݸ�L��
;;;2011/09/14YM@DEL      /
;;;2011/09/14YM@DEL      #qry$ #DimA
;;;2011/09/14YM@DEL      )
;;;2011/09/14YM@DEL      (setq #DimA nil)
;;;2011/09/14YM@DEL      (setq #qry$
;;;2011/09/14YM@DEL        (CFGetDBSQLRec CG_DBSESSION "�W��WT���@"
;;;2011/09/14YM@DEL          (list
;;;2011/09/14YM@DEL            (list "�Ԍ�1"      #nMAG1   'INT)
;;;2011/09/14YM@DEL            (list "�Ԍ�2"      #nMAG2   'INT)
;;;2011/09/14YM@DEL            (list "WT�`��"     #WT_type 'STR)
;;;2011/09/14YM@DEL;;;           (list "�^�C�v"     (nth 4 &XD_WRKT) 'STR)
;;;2011/09/14YM@DEL            (list "�f��F"      #ZaiF    'INT)
;;;2011/09/14YM@DEL            (list "�V���N�L��" &snk     'STR)
;;;2011/09/14YM@DEL          )
;;;2011/09/14YM@DEL        )
;;;2011/09/14YM@DEL      )
;;;2011/09/14YM@DEL      (if #qry$
;;;2011/09/14YM@DEL        (progn
;;;2011/09/14YM@DEL          ; 02/08/30 YM ADD-S ж��R�t�V�Ή�
;;;2011/09/14YM@DEL          ; �Ԍ�2400mm�̂Ƃ���������("ISC")�ð������("IAR")�ŋK�i�i�̼ݸ�e���قȂ�
;;;2011/09/14YM@DEL          (if (= 1 (nth 33 &XD_WRKT))
;;;2011/09/14YM@DEL            (progn ; R�t���V������
;;;2011/09/14YM@DEL              ; 02/11/27 YM MOD �ذ�ދL���ގ��L���̌���=1,2���ɑΉ�
;;;2011/09/14YM@DEL;;;             (setq #Rtype (substr (nth 34 &XD_WRKT) 1 7)) ; WT�i�Ԃ���WT��ނ��擾
;;;2011/09/14YM@DEL
;;;2011/09/14YM@DEL              ; 02/11/27 YM MOD-S
;;;2011/09/14YM@DEL              (setq #num1 (strlen CG_SeriesCode))    ; �ذ�ދL��������
;;;2011/09/14YM@DEL              (setq #num2 (strlen (nth 2 &XD_WRKT))) ; �ގ��L��������
;;;2011/09/14YM@DEL              (setq #Rtype (substr (nth 34 &XD_WRKT) 1 (+ #num1 #num2 3))) ; WT�i�Ԃ���WT��ނ��擾
;;;2011/09/14YM@DEL              ; 02/11/27 YM MOD-E
;;;2011/09/14YM@DEL
;;;2011/09/14YM@DEL              (setq #dum$ nil)
;;;2011/09/14YM@DEL              (foreach qry #qry$
;;;2011/09/14YM@DEL                (if (= (nth 4 qry) #Rtype)
;;;2011/09/14YM@DEL                  (setq #dum$ (append #dum$ (list qry))) ; WT���߂������ł���ں��ނɍi��
;;;2011/09/14YM@DEL                );_if
;;;2011/09/14YM@DEL              )
;;;2011/09/14YM@DEL              (setq #qry$ #dum$) ; �i�荞�񂾂��̂ɒu������
;;;2011/09/14YM@DEL            )
;;;2011/09/14YM@DEL          );_if
;;;2011/09/14YM@DEL          ; 02/08/30 YM ADD-E ж��R�t�V�Ή�
;;;2011/09/14YM@DEL
;;;2011/09/14YM@DEL          ; 02/11/15 YM ADD �������߂œ����Ԍ��̂Ƃ��ذ�ނ���
;;;2011/09/14YM@DEL          ; #qry$=nil�Ȃ�#DimA=nil��Ԃ�
;;;2011/09/14YM@DEL          (if (/= nil #qry$)
;;;2011/09/14YM@DEL            (setq #DimA (nth 7 (car #qry$))) ; ���@A
;;;2011/09/14YM@DEL            (setq #DimA nil)                 ; ���@A
;;;2011/09/14YM@DEL          );_if
;;;2011/09/14YM@DEL        )
;;;2011/09/14YM@DEL      );_if
;;;2011/09/14YM@DEL      #DimA
;;;2011/09/14YM@DEL    );##GetDimA


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/09/17 A.Satoh Del - E
;;;;;(defun ##SUISENpop ( ; ; ����i��ؽĂ̕ύX
;;;;;;;; &snk  ; �ݸ�L��
;;;;;;;; &sui$ ; WT������N ں���
;;;;;;;; #sui$ #snk #plis?$ ��۰�ٕϐ���`���Ă͂Ȃ��
;;;;;  /
;;;;;  #i #dim #HINBAN$$ #HINBAN$ #plis #lis$
;;;;;  #DIMDR #HINBANDR$$ #HINBANDR$ #LAB
;;;;;  )
;;;;;;---------------------------------------------------
;;;;;; �������15�����ɂ��낦��(�����ɋ󔒂�ǉ�����)
;;;;;;---------------------------------------------------
;;;;;  (defun ##Len15 ( &str / #LEN #ret)
;;;;;
;;;;;    ;07/08/22 YM ADD "()"���O��
;;;;;    (setq &str (KP_DelHinbanKakko &str))
;;;;;
;;;;;    (setq #len (strlen &str) #ret &str)
;;;;;    (repeat (- 15 #len)
;;;;;      (setq #ret (strcat #ret " "))
;;;;;    )
;;;;;    #ret
;;;;;  );##Len15
;;;;;;--------------------------------------------
;;;;;
;;;;;  (setq #i 3)
;;;;;  (setq #POP1 nil #POP2 nil #POP3 nil #POP4 nil #POP5 nil)
;;;;;  (setq #plis1$ '() #plis2$ '() #plis3$ '() #plis4$ '() #plis5$ '())
;;;;;
;;;;;  (repeat 10
;;;;;    (setq #dim (nth #i #sui$)) ; ��1,2,...10
;;;;;    (if (/= #dim nil) ; -2,-1,0,1,2
;;;;;      (progn
;;;;;        (setq #HINBAN$$ ; ������������
;;;;;          (CFGetDBSQLRec CG_DBSESSION "WT������"
;;;;;            (list
;;;;;              (list "����������" (itoa (fix #dim)) 'INT)
;;;;;              (list "�V���N�L��" #snk 'STR) ; �����V���N�L��
;;;;;            )
;;;;;          )
;;;;;        );_(setq
;;;;;
;;;;;        (if #HINBAN$$
;;;;;          (progn
;;;;;            ;;; ������ -1 ;;;
;;;;;            (cond
;;;;;              ((equal #dim -1  0.001)
;;;;;                (setq #lab "suiL")
;;;;;                (start_list #lab 3)
;;;;;                (add_list "�ȁ@��")
;;;;;                (foreach #HINBAN$ #HINBAN$$
;;;;;                  (setq #plis (strcat (##Len15 (nth 3 #HINBAN$)) (nth 4 #HINBAN$) " "))
;;;;;                  (setq #plis1$ (append #plis1$ (list #HINBAN$)))
;;;;;                  (add_list #plis)
;;;;;                )
;;;;;                (end_list)
;;;;;                (setq #pop1 T)
;;;;;              )
;;;;;              ;;; �����E -2 ;;;
;;;;;              ((equal #dim -2 0.001)
;;;;;                (setq #lab "suiR") ; �ʏ�
;;;;;                (start_list #lab 3)
;;;;;                (add_list "�ȁ@��")
;;;;;                (foreach #HINBAN$ #HINBAN$$
;;;;;                  (setq #plis (strcat (##Len15 (nth 3 #HINBAN$)) (nth 4 #HINBAN$) " "))
;;;;;                  (setq #plis2$ (append #plis2$ (list #HINBAN$)))
;;;;;                  (add_list #plis)
;;;;;                )
;;;;;                (end_list)
;;;;;                (setq #pop2 T)
;;;;;              )
;;;;;              ;;; ���� 0 ;;;
;;;;;              ((equal #dim 0  0.001)
;;;;;                (start_list "sui" 3)
;;;;;                (add_list "�ȁ@��")
;;;;;                (foreach #HINBAN$ #HINBAN$$
;;;;;                  (setq #plis (strcat (##Len15 (nth 3 #HINBAN$)) (nth 4 #HINBAN$) " "))
;;;;;                  (setq #plis3$ (append #plis3$ (list #HINBAN$)))
;;;;;                  (add_list #plis)
;;;;;                )
;;;;;                (end_list)
;;;;;                (setq #pop3 T)
;;;;;              )
;;;;;              ;;; ��߼�ݍ� 1 ;;;
;;;;;              ((equal #dim 1  0.001)
;;;;;                (start_list "opL" 3)
;;;;;                (add_list "�ȁ@��")
;;;;;                (foreach #HINBAN$ #HINBAN$$
;;;;;                  (setq #plis (strcat (##Len15 (nth 3 #HINBAN$)) (nth 4 #HINBAN$)))
;;;;;                  (setq #plis4$ (append #plis4$ (list #HINBAN$)))
;;;;;                  (add_list #plis)
;;;;;                )
;;;;;                (end_list)
;;;;;                (setq #pop4 T)
;;;;;              )
;;;;;              ;;; ��߼�݉E 2 ;;;
;;;;;              ((equal #dim 2  0.001)
;;;;;                (start_list "opR" 3)
;;;;;                (add_list "�ȁ@��")
;;;;;                (foreach #HINBAN$ #HINBAN$$
;;;;;                  (setq #plis (strcat (##Len15 (nth 3 #HINBAN$)) (nth 4 #HINBAN$)))
;;;;;                  (setq #plis5$ (append #plis5$ (list #HINBAN$)))
;;;;;                  (add_list #plis)
;;;;;                )
;;;;;                (end_list)
;;;;;                (setq #pop5 T)
;;;;;              )
;;;;;            );_cond
;;;;;          )
;;;;;        );_if
;;;;;
;;;;;      )
;;;;;    );_if
;;;;;    (setq #i (1+ #i))
;;;;;  );_repeat
;;;;;
;;;;;  (set_tile  "suiL" "0")
;;;;;  (set_tile  "suiR" "0")
;;;;;  (set_tile  "sui" "0")
;;;;;  (set_tile  "opL" "0")
;;;;;  (set_tile  "opR" "0")
;;;;;
;;;;;;;;01/07/06YM@  (if (= #pop1 nil) ; -1
;;;;;;;;01/07/06YM@    (mode_tile "suiL" 1) ; �g�p�s��
;;;;;;;;01/07/06YM@    (mode_tile "suiL" 0) ; �g�p��
;;;;;;;;01/07/06YM@  )
;;;;;;;;01/07/06YM@  (if (= #pop2 nil) ; -2
;;;;;;;;01/07/06YM@    (mode_tile "suiR" 1) ; �g�p�s��
;;;;;;;;01/07/06YM@    (mode_tile "suiR" 0)   ; �g�p��
;;;;;;;;01/07/06YM@  )
;;;;;;;;01/07/06YM@  (if (= #pop3 nil) ; 0
;;;;;;;;01/07/06YM@    (mode_tile "sui" 1) ; �g�p�s��
;;;;;;;;01/07/06YM@    (mode_tile "sui" 0)   ; �g�p��
;;;;;;;;01/07/06YM@  )
;;;;;;;;01/07/06YM@  (if (= #pop4 nil) ; 1
;;;;;;;;01/07/06YM@    (mode_tile "opL" 1) ; �g�p�s��
;;;;;;;;01/07/06YM@    (mode_tile "opL" 0)   ; �g�p��
;;;;;;;;01/07/06YM@  )
;;;;;;;;01/07/06YM@  (if (= #pop5 nil) ; 2
;;;;;;;;01/07/06YM@    (mode_tile "opR" 1) ; �g�p�s��
;;;;;;;;01/07/06YM@    (mode_tile "opR" 0)   ; �g�p��
;;;;;;;;01/07/06YM@  )
;;;;;
;;;;;  (if (= #pop1 nil) ; -1
;;;;;    (progn
;;;;;      (if #pop1flg
;;;;;        (progn
;;;;;          (start_list "suiL" 1 0) ;���X�g�� 1 �Ԗڂ̍��ڂ�ύX���܂��B
;;;;;          (add_list "")
;;;;;          (end_list)
;;;;;        )
;;;;;      );_if
;;;;;      (mode_tile "suiL" 1) ; �g�p�s��
;;;;;    )
;;;;;    (progn
;;;;;      (mode_tile "suiL" 0) ; �g�p��
;;;;;      (setq #pop1flg T)
;;;;;    )
;;;;;  );_if
;;;;;  (if (= #pop2 nil) ; -2
;;;;;    (progn
;;;;;      (if #pop2flg
;;;;;        (progn
;;;;;          (start_list "suiR" 1 0) ;���X�g�� 1 �Ԗڂ̍��ڂ�ύX���܂��B
;;;;;          (add_list "")
;;;;;          (end_list)
;;;;;        )
;;;;;      );_if
;;;;;      (mode_tile "suiR" 1) ; �g�p�s��
;;;;;    )
;;;;;    (progn
;;;;;      (mode_tile "suiR" 0)   ; �g�p��
;;;;;      (setq #pop2flg T)
;;;;;    )
;;;;;  );_if
;;;;;  (if (= #pop3 nil) ; 0
;;;;;    (progn
;;;;;      (if #pop3flg
;;;;;        (progn
;;;;;          (start_list "sui" 1 0) ;���X�g�� 1 �Ԗڂ̍��ڂ�ύX���܂��B
;;;;;          (add_list "")
;;;;;          (end_list)
;;;;;        )
;;;;;      );_if
;;;;;      (mode_tile "sui" 1) ; �g�p�s��
;;;;;    )
;;;;;    (progn
;;;;;      (mode_tile "sui" 0)   ; �g�p��
;;;;;      (setq #pop3flg T)
;;;;;    )
;;;;;  );_if
;;;;;  (if (= #pop4 nil) ; 1
;;;;;    (progn
;;;;;      (if #pop4flg
;;;;;        (progn
;;;;;          (start_list "opL" 1 0) ;���X�g�� 1 �Ԗڂ̍��ڂ�ύX���܂��B
;;;;;          (add_list "")
;;;;;          (end_list)
;;;;;        )
;;;;;      );_if
;;;;;      (mode_tile "opL" 1) ; �g�p�s��
;;;;;    )
;;;;;    (progn
;;;;;      (mode_tile "opL" 0)   ; �g�p��
;;;;;      (setq #pop4flg T)
;;;;;    )
;;;;;  );_if
;;;;;  (if (= #pop5 nil) ; 2
;;;;;    (progn
;;;;;      (if #pop5flg
;;;;;        (progn
;;;;;          (start_list "opR" 1 0) ;���X�g�� 1 �Ԗڂ̍��ڂ�ύX���܂��B
;;;;;          (add_list "")
;;;;;          (end_list)
;;;;;        )
;;;;;      );_if
;;;;;      (mode_tile "opR" 1) ; �g�p�s��
;;;;;    )
;;;;;    (progn
;;;;;      (mode_tile "opR" 0)   ; �g�p��
;;;;;      (setq #pop5flg T)
;;;;;    )
;;;;;  );_if
;;;;;
;;;;;  (princ)
;;;;;);##SUISENpop
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; #sui$$ #sui$��۰�ٕϐ���`���Ă͂Ȃ��
;;;;;;;;2011/09/14YM@DEL(defun ##CHG_sinkPOCKET ( / #NO); "radioPOCKET" key �ɱ���݂���
;;;;;;;;2011/09/14YM@DEL  (if (= (get_tile "radioPY") "1") ; �ݸ�߹�Ă���
;;;;;;;;2011/09/14YM@DEL    (mode_tile "radio" 0) ; �g�p��
;;;;;;;;2011/09/14YM@DEL    (progn
;;;;;;;;2011/09/14YM@DEL      (setq #no (atoi (get_tile "sink"))) ; #name$$ �̉��Ԗڂ�
;;;;;;;;2011/09/14YM@DEL      ; 01/12/14 YM MOD-S
;;;;;;;;2011/09/14YM@DEL      (set_tile "radioR" "1") ; ��̫��"R"
;;;;;;;;2011/09/14YM@DEL      (mode_tile "radio" 0)   ; LR�L���I���\
;;;;;;;;2011/09/14YM@DEL      ; 01/12/14 YM MOD-E
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD     (if (equal (nth 9 (nth #no &name$$)) 0.0 0.1) ; ���݂̼ݸ��LR�L��
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD       (progn
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD         (set_tile "radioR" "1")
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD         (mode_tile "radio" 1) ; LR�L���Ȃ� ; �g�p�s��
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD       )
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD       (mode_tile "radio" 0) ; LR�L������ ; �g�p��
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD     );_if
;;;;;;;;2011/09/14YM@DEL
;;;;;;;;2011/09/14YM@DEL    )
;;;;;;;;2011/09/14YM@DEL  );_if
;;;;;;;;2011/09/14YM@DEL  (princ)
;;;;;;;;2011/09/14YM@DEL);##CHG_sinkPOCKET
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; #sui$$ #sui$��۰�ٕϐ���`���Ă͂Ȃ��
;;;;;(defun ##CHG_sinkLR ( / ); "radio" key �ɱ���݂���
;;;;;  (set_tile "text2" "WT�[����̃V���N�ʒu")
;;;;;;;;00/12/04YM@  (if (= (get_tile "radioR") "1")
;;;;;;;;00/12/04YM@    (set_tile "text2" "�E�[����̃V���N�ʒu")
;;;;;;;;00/12/04YM@    (set_tile "text2" "���[����̃V���N�ʒu")
;;;;;;;;00/12/04YM@  );_if
;;;;;  (princ)
;;;;;);##CHG_sinkLR
;;;;;
;-- 2011/09/17 A.Satoh Del - E
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; #sui$$ #sui$��۰�ٕϐ���`���Ă͂Ȃ��
;-- 2011/09/17 A.Satoh Mod - S
;;;;;(defun ##CHG_sink ( ; "sink" key �ɱ���݂���
;;;;;  /
;;;;;  #no #dim #i #j
;;;;;  #pop1 #pop2 #pop3 #pop4 #pop5
;;;;;  #plis #dimST #dimRP #LR_EXIST #dum
;;;;;  #dimST$ #dimRP$ #focus #DIMA #dimA$
;;;;;
;;;;;  )
;;;;;
;;;;;  (setq #no (atoi (get_tile "sink"))) ; #name$$ �̉��Ԗڂ�
;;;;;;;; �ݸ�L��
;;;;;  (setq #snk (nth 1 (nth #no &name$$)))      ; �ݸ�L��
;;;;;;;;01/12/14YM@MOD  (setq #LR_EXIST (nth 9 (nth #no &name$$))) ; �ݸLR�L��
;;;;;
;;;;;
;;;;;;;;2011/09/14YM@DEL;;; �ݸ�e���@ؽĂ̕ύX
;;;;;;;;2011/09/14YM@DEL  (setq #dimST$ nil #dimRP$ nil) ; �ݸ�ʒuؽē��e
;;;;;;;;2011/09/14YM@DEL  (if &sink$$
;;;;;;;;2011/09/14YM@DEL    (progn
;;;;;;;;2011/09/14YM@DEL      (start_list "sinkpos" 3)
;;;;;;;;2011/09/14YM@DEL      (setq #i #i1)
;;;;;;;;2011/09/14YM@DEL      (setq #j #i2)
;;;;;;;;2011/09/14YM@DEL      (repeat 10
;;;;;;;;2011/09/14YM@DEL        (setq #dimST (nth #i (nth #no &sink$$))) ; SINK�ʒu.�e���@1,2,3���  (&sink$$�̍ŏ��̂���)
;;;;;;;;2011/09/14YM@DEL        (setq #dimRP (nth #j (nth #no &sink$$))) ; SINK�ʒu.�e���@1,2,3��߽ (&sink$$�̍ŏ��̂���)
;;;;;;;;2011/09/14YM@DEL        (if (> #dimST 0.1)
;;;;;;;;2011/09/14YM@DEL          (progn
;;;;;;;;2011/09/14YM@DEL            (add_list (strcat (itoa (fix (+ #dimST 0.001))) " ("
;;;;;;;;2011/09/14YM@DEL                              (itoa (fix (+ #dimRP 0.001))) ")"))
;;;;;;;;2011/09/14YM@DEL            (Setq #dimST$ (append #dimST$ (list #dimST)))
;;;;;;;;2011/09/14YM@DEL            (Setq #dimRP$ (append #dimRP$ (list #dimRP)))
;;;;;;;;2011/09/14YM@DEL          )
;;;;;;;;2011/09/14YM@DEL        )
;;;;;;;;2011/09/14YM@DEL        (setq #i (1+ #i))
;;;;;;;;2011/09/14YM@DEL        (setq #j (1+ #j))
;;;;;;;;2011/09/14YM@DEL;;;01/01/11YM@        (setq #dum (nth #i (nth #no &sink$$)))
;;;;;;;;2011/09/14YM@DEL;;;01/01/11YM@        (if (> #dum 0.1)
;;;;;;;;2011/09/14YM@DEL;;;01/01/11YM@          (add_list (itoa (fix (+ #dum 0.001))))
;;;;;;;;2011/09/14YM@DEL;;;01/01/11YM@        );_if
;;;;;;;;2011/09/14YM@DEL;;;01/01/11YM@        (setq #i (1+ #i))
;;;;;;;;2011/09/14YM@DEL      )
;;;;;;;;2011/09/14YM@DEL      (end_list)
;;;;;;;;2011/09/14YM@DEL    )
;;;;;;;;2011/09/14YM@DEL    (progn
;;;;;;;;2011/09/14YM@DEL      (princ) ; 00/11/30 YM ADD
;;;;;;;;2011/09/14YM@DEL    )
;;;;;;;;2011/09/14YM@DEL  );_if
;;;;;;;;2011/09/14YM@DEL  (setq #DimA (##GetDimA #snk)) ; �����\���ݸ�ɑ΂���W�����@
;;;;;;;;2011/09/14YM@DEL  (setq #i 0 #focus 0) ; 02/11/15 YM MOD
;;;;;;;;2011/09/14YM@DEL;;; (setq #i 0 #focus nil) ; 02/11/15 YM MOD
;;;;;;;;2011/09/14YM@DEL  (if (= #ZaiF "1")
;;;;;;;;2011/09/14YM@DEL    (setq #dimA$ #dimST$)
;;;;;;;;2011/09/14YM@DEL    (setq #dimA$ #dimRP$)
;;;;;;;;2011/09/14YM@DEL  );_if
;;;;;;;;2011/09/14YM@DEL  (foreach dimA #dimA$
;;;;;;;;2011/09/14YM@DEL    (if (equal dimA #DimA 0.1)
;;;;;;;;2011/09/14YM@DEL      (setq #focus #i)
;;;;;;;;2011/09/14YM@DEL    );_if
;;;;;;;;2011/09/14YM@DEL    (setq #i (1+ #i))
;;;;;;;;2011/09/14YM@DEL  )
;;;;;;;;2011/09/14YM@DEL  (if #focus
;;;;;;;;2011/09/14YM@DEL    (set_tile "sinkpos" (itoa #focus)) ; �����͍ŏ��̍��ڂ�\�� 01/03/08 YM MOD �W�����@��̫���
;;;;;;;;2011/09/14YM@DEL    (set_tile "sinkpos" "0") ; �I�������ݸ�e���@
;;;;;;;;2011/09/14YM@DEL  );_if
;;;;;
;;;;;
;;;;;  (##CHG_sinkpos) ; �ݸ�ʒu��ި���ޯ���ύX
;;;;;;;;  (set_tile "edit_sinkpos"
;;;;;;;;   (rtos (nth (+ (atoi (get_tile "sinkpos")) #i0) (nth #no &sink$$)) 2 0) ; �\�i����0
;;;;;;;; )
;;;;;;;; ���������ؽĂ̕ύX
;;;;;;-- 2011/06/29 A.Satoh Mod -S
;;;;;; �������� 6/29���_�ł̎b�菈��
;;;;;; �������� �d�l�m���ɑΉ�
;;;;;;|
;;;;;  (start_list "hole" 3)
;;;;;  (setq #sui$$ '())
;;;;;  (setq #i 10)
;;;;;  (repeat 5
;;;;;    (setq #dim (nth #i (nth #no &name$$)))
;;;;;    (if (> #dim 0.1)
;;;;;      (progn
;;;;;        (setq #sui$ ; �P��������
;;;;;          (CFGetDBSQLRec CG_DBSESSION "WT������"
;;;;;            (list (list "������ID" (itoa (fix (+ #dim 0.001))) 'INT))
;;;;;          )
;;;;;        );_(setq
;;;;;        (setq #sui$ (DBCheck #sui$ "�wWT�������x" "KPSelectSinkDlg")) ; nil or ������ �װ
;;;;;        (setq #sui$$ (append #sui$$ (list #sui$)))
;;;;;        (add_list (nth 2 #sui$))
;;;;;      )
;;;;;    );_if
;;;;;    (setq #i (1+ #i))
;;;;;  )
;;;;;  (end_list)
;;;;;  (set_tile "hole" "0")
;;;;;;;; �����߯�߱���ؽ�
;;;;;  (setq #sui$ (car #sui$$))
;;;;;  (##SUISENpop)
;;;;;|;
;;;;;  (mode_tile "hole" 1)
;;;;;  (mode_tile "suiL" 1)
;;;;;  (mode_tile "suiR" 1)
;;;;;  (mode_tile "sui"  1)
;;;;;  (mode_tile "opL"  1)
;;;;;  (mode_tile "opR"  1)
;;;;;;-- 2011/06/29 A.Satoh Mod -E
;;;;;
;;;;;  ;;; �ݸLR�I��
;;;;;  ;2011/09/14 YM ADD-S
;;;;;  (cond
;;;;;    ((= #SNK_KATTE "R")
;;;;;      (set_tile "radioR" "1") ; "R"
;;;;;    )
;;;;;    ((= #SNK_KATTE "L")
;;;;;      (set_tile "radioL" "1") ; "L"
;;;;;    )
;;;;;    (T
;;;;;      (set_tile "radioR" "1") ; "R"
;;;;;    )
;;;;;  );_cond
;;;;;  (mode_tile "radio" 0)   ; LR�L���I���\
;;;;;  ;2011/09/14 YM ADD-E
;;;;;
;;;;;;;;01/12/14YM@MOD (if (equal #LR_EXIST 0.0 0.1) ; LR�L�� 00/10/25 YM ADD
;;;;;;;;01/12/14YM@MOD   (if (= (get_tile "radioPY") "1") ; LR�L���Ȃ�
;;;;;;;;01/12/14YM@MOD     (mode_tile "radio" 0) ; �g�p��
;;;;;;;;01/12/14YM@MOD     (progn
;;;;;;;;01/12/14YM@MOD       (set_tile "radioR" "1")
;;;;;;;;01/12/14YM@MOD       (mode_tile "radio" 1) ; �g�p�s��
;;;;;;;;01/12/14YM@MOD     )
;;;;;;;;01/12/14YM@MOD   );_if
;;;;;;;;01/12/14YM@MOD   (mode_tile "radio" 0); LR�L������ ; �g�p��
;;;;;;;;01/12/14YM@MOD );_if
;;;;;
;;;;;  (set_tile "text2" "WT�[����̃V���N�ʒu")
;;;;;;;; (set_tile "text2" "�E�[����̃V���N�ʒu")
;;;;;
;;;;;;;;2011/09/14YM@DEL  (cond
;;;;;;;;2011/09/14YM@DEL    ((= (nth 16 (nth #no &name$$)) "P")
;;;;;;;;2011/09/14YM@DEL      (mode_tile "radioPOCKET" 0) ; �g�p�\
;;;;;;;;2011/09/14YM@DEL    )
;;;;;;;;2011/09/14YM@DEL    (T
;;;;;;;;2011/09/14YM@DEL      (set_tile "radioPN" "1")
;;;;;;;;2011/09/14YM@DEL      (mode_tile "radioPOCKET" 1) ; �g�p�s�\
;;;;;;;;2011/09/14YM@DEL    )
;;;;;;;;2011/09/14YM@DEL  );_cond
;;;;;  ;;; �ݸLR�I��
;;;;;  ;2011/09/14 YM ADD-S
;;;;;
;;;;;  (princ)
;;;;;);##CHG_sink
(defun ##CHG_sink ( ; "sink" key �ɱ���݂���
  /
  #no #LR_umu
  #ana_type #type #kikaku #selno
  #idx #def_no #lst
  )

  (setq #no (atoi (get_tile "sink"))) ; #name$$ �̉��Ԗڂ�

  (setq #LR_umu (nth 4 (nth #no &name$$)))  ; LR�L��
  (if (= #LR_umu 0)
    (progn
      (set_tile "radioR" "0") ; "R"
      (set_tile "radioL" "0") ; "R"
      (mode_tile "radio" 1)   ; LR�L���I��s��
    )
    (progn
;-- 2011/11/21 A.Satoh Mod - S
;;;;;      (cond
;;;;;        ((= #SNK_KATTE "R")
;;;;;          (set_tile "radioR" "1") ; "R"
;;;;;        )
;;;;;        ((= #SNK_KATTE "L")
;;;;;          (set_tile "radioL" "1") ; "L"
;;;;;        )
;;;;;        (T
;;;;;          (set_tile "radioR" "1") ; "R"
;;;;;        )
;;;;;      )
;;;;;      (mode_tile "radio" 0)   ; LR�L���I���\
      (cond
        ((= #SNK_KATTE "R")
          (set_tile "radioR" "1") ; "R"
		      (mode_tile "radio" 1)   ; LR�L���I��s��
        )
        ((= #SNK_KATTE "L")
          (set_tile "radioL" "1") ; "L"
		      (mode_tile "radio" 1)   ; LR�L���I��s��
        )
        (T
          (set_tile "radioL" "1") ; "L"
		      (mode_tile "radio" 0)   ; LR�L���I���\
        )
      )
;-- 2011/11/21 A.Satoh Mod - E
    )
  )

  ;;; �����|�b�v�A�b�v���X�g�����ݒ�
  (setq #ana_type (nth 7 (nth #no #name$$)))
  (setq #type     (nth 8 (nth #no #name$$)))
  (setq #kikaku   (nth 9 (nth #no #name$$)))

  ;(setq #selno (atoi (get_tile "hole")))

  ; �yWT�������z���琅�����������o��
  (setq #sui_ana$$
    (CFGetDBSQLRec CG_DBSESSION "WT������"
      (list (list "�������^�C�v���" #ana_type 'STR))
    )
  )
  (if #sui_ana$$
    (progn
      (setq #sui_ana$$ (CFListSort #sui_ana$$ 0))
      (setq #idx 0)
      (setq #def_no1 0)
      (repeat (length #sui_ana$$)
        (if (= 1 (nth 8 (nth #idx #sui_ana$$)))
          (setq #def_no #idx)
        )
        (setq #idx (1+ #idx))
      )
    )
    (progn
      (setq #msg (strcat "�wWT�������x��ں��ނ�����܂���B\n�������^�C�v���=" #ana_type))
      (CFAlertMsg #msg)
      (quit)
    )
  )

  ; ���������X�g�ɃA�C�e����ݒ�
  (start_list "hole" 3)
  (foreach #lst #sui_ana$$
    (add_list (nth 2 #lst))
  )
  (end_list)
  (set_tile "hole" (itoa #def_no))

  ; �ySINK�����Ǘ��z���琅���������o��
  (setq #suisen$$
    (CFGetDBSQLRec CG_DBSESSION "WT������"
      (list (list "�I�������" #type 'STR))
    )
  )
  (if #suisen$$
    (progn
      (setq #suisen$$ (CFListSort #suisen$$ 0))
    )
    (progn
      (setq #msg (strcat "�wWT�����ǁx��ں��ނ�����܂���B\n�I�������=" #type))
      (CFAlertMsg #msg)
      (quit)
    )
  )

;  (##SetEnableList (nth #selno #sui_ana$$))
  (##SetEnableList (nth #def_no #sui_ana$$))

	;�V���N��ʂŃV���N��ύX�����Ƃ��̑Ή�
	;2017/01/19 YM ADD �ǉ��@��������R�s�[(Errmsg.ini) ��������������������������
	; #snk
	(setq #snk (nth 1 (nth #no &name$$)))

	(setq #iii 0)
	(setq #width_SP nil);�ر�
	(foreach #sSINK #sSINK$
		(if (= #sSINK #snk)
			(progn ;�Y���̼ݸ������
				(setq #width_SP (atof (nth #iii #sDIST$)))
			)
		);_if
		(setq #iii (1+ #iii))
	);foreach

;;;	(CFAlertMsg "���i�S�j�� ��PG���C�� ERRMSG.INI�����ɍs����") ;2017/01/19 YM ADD

	;2017/01/19 YM ADD �ǉ��@��������R�s�[(Errmsg.ini) ��������������������������

	(if #width_SP
		(progn
	  	(set_tile "edit_sinkpos" (rtos #width_SP 2 1));P�V���N�ȂǓ���
;;;			(setq #width #width_SP);�߂�l 2017/01/20 DEL
		)
		;else
		(progn
	  	(set_tile "edit_sinkpos" (rtos #width_CAB 2 1));�ݸ���޾���
;;;			(setq #width #width_CAB);�߂�l 2017/01/20 DEL
		)
	);_if



  (princ)
);##CHG_sink
;-- 2011/09/17 A.Satoh Mod - E
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/09/17 A.Satoh Del - S
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; #sui$$ #sui$��۰�ٕϐ���`���Ă͂Ȃ��
;;;;;(defun ##CHG_sinkpos ( ; "sinkpos" key �ɱ���݂���
;;;;;  /
;;;;;  #NO
;;;;;  )
;;;;;  (setq #no (atoi (get_tile "sink"))) ; #name$$ �̉��Ԗڂ�
;;;;;  ; �I�������ݸ�e���@
;;;;;  (set_tile "edit_sinkpos"
;;;;;;;;2011/09/14YM@DEL    (rtos (nth (+ (atoi (get_tile "sinkpos")) #i1) (nth #no &sink$$)) 2 0) ; �\�i����0
;;;;;    (rtos 777.7 2 1) ; �\�i����0 �y�b��z
;;;;;  )
;;;;;  (princ)
;;;;;);##CHG_sinkpos
;-- 2011/09/17 A.Satoh Del - E
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defun ##CHK_edit (&sKEY / #val #ret)
    (setq #ret nil)
    (setq #val (read (get_tile &sKEY)))
    (if (or (= (type (read (get_tile &sKEY))) 'INT)
            (= (type (read (get_tile &sKEY))) 'REAL))
      (princ) ; OK!
      (progn
        (alert "���p�̎����l����͂��ĉ������B")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  );##CHK_edit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; #sui$$ #sui$��۰�ٕϐ���`���Ă͂Ȃ��
(defun ##CHG_hole ( ; ���������߂ɱ���݂���
  &sVAL
  /
  )
;-- 2011/09/17 A.Satoh Mod - S
;;;;;  (setq #sui$ (nth (atoi &sVAL) #sui$$))
;;;;;;;; �����߯�߱���ؽ�
;;;;;;-- 2011/06/29 A.Satoh Mod -S
;;;;;; �������� 6/29���_�ł̎b�菈��
;;;;;; �������� �d�l�m���ɑΉ�
;;;;;;|
;;;;;  (##SUISENpop)
;;;;;|;
;;;;;  (mode_tile "suiL" 1)
;;;;;  (mode_tile "suiR" 1)
;;;;;  (mode_tile "sui"  1)
;;;;;  (mode_tile "opL"  1)
;;;;;  (mode_tile "opR"  1)
;;;;;;-- 2011/06/29 A.Satoh Mod -E
  (##SetEnableList (nth (atoi &sVal) #sui_ana$$))
;-- 2011/09/17 A.Satoh Mod - E
  (princ)
);##CHG_hole
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/09/17 A.Satoh Mod - S
;;;;;(defun ##GetDlgItem ( / ; �޲�۸ނ̌��ʂ��擾����
;;;;;  #ret1 #ret2 #ret3 #ret4 #ret5
;;;;;  #ret6 #ret7 #ret8 #ret9 #ret0
;;;;;  #plis1 #plis2 #plis3 #plis4 #plis5
;;;;;  #sink$ #name$ #SNK_DIM #LR #sui$ #plis$
;;;;;  )
;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;    (defun Getplis ( &lis$ &ret &flg / #plis)
;;;;;      (if &lis$
;;;;;        (progn
;;;;;          (if &flg ; "��  ��"�͂Ȃ�
;;;;;            (progn
;;;;;              (if (/= &ret "")
;;;;;                (setq #plis (nth (atoi &ret) &lis$))
;;;;;                (setq #plis nil)
;;;;;              )
;;;;;            )
;;;;;            (progn ; "0"��"��  ��"
;;;;;              (if (and (/= &ret "") (/= &ret "0"))
;;;;;                (setq #plis (nth (1- (atoi &ret)) &lis$))
;;;;;                (setq #plis nil)
;;;;;              )
;;;;;            )
;;;;;          );_if
;;;;;        )
;;;;;        (setq #plis nil)
;;;;;      );_if
;;;;;      #plis
;;;;;    )
;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;;  (setq #ret1 (get_tile "sink"))    ; �ݸ����
;;;;;  (setq #ret2 (get_tile "edit_sinkpos")) ; �ݸ�e���@
;;;;;  (setq #ret3 (get_tile "radioR"))  ; �ݸLR
;;;;;;;;2011/09/14YM@DEL  (setq #ret4 (get_tile "radioPY")) ; �ݸ�߹�Ă���
;;;;;
;;;;;;-- 2011/06/29 A.Satoh Mod -S
;;;;;; �������� 6/29���_�ł̎b�菈��
;;;;;; �������� �d�l�m���ɑΉ�
;;;;;;|
;;;;;  (setq #ret5 (get_tile "hole"))    ; ����������
;;;;;
;;;;;  (setq #ret6 (get_tile "suiL"))    ; ������
;;;;;  (setq #ret7 (get_tile "suiR"))    ; �����E
;;;;;  (setq #ret8 (get_tile "sui"))     ; ����
;;;;;  (setq #ret9 (get_tile "opL"))     ; �I�v�V�����E
;;;;;  (setq #ret0 (get_tile "opR"))     ; �I�v�V������
;;;;;
;;;;;  (setq #plis1 (Getplis #plis1$ #ret6 nil)) ; ����������-1 �i�Ԗ���,���l
;;;;;  (setq #plis2 (Getplis #plis2$ #ret7 nil)) ; ����������-2 �i�Ԗ���,���l
;;;;;  (setq #plis3 (Getplis #plis3$ #ret8 nil)) ; ���������� 0 �i�Ԗ���,���l
;;;;;  (setq #plis4 (Getplis #plis4$ #ret9 nil)) ; ���������� 1 �i�Ԗ���,���l
;;;;;  (setq #plis5 (Getplis #plis5$ #ret0 nil)) ; ���������� 2 �i�Ԗ���,���l
;;;;;
;;;;;  ;;; 07/22 YM ADD �����P�@�����E���u�Ȃ��v�̂悤�ȏꍇ
;;;;;  (if (and #pop1 (= #plis1 nil))
;;;;;    (setq #plis1 "-1")
;;;;;  );_if
;;;;;  (if (and #pop2 (= #plis2 nil))
;;;;;    (setq #plis2 "-2")
;;;;;  );_if
;;;;;  (if (and #pop3 (= #plis3 nil))
;;;;;    (setq #plis3 "0")
;;;;;  );_if
;;;;;  (if (and #pop4 (= #plis4 nil))
;;;;;    (setq #plis4 "1")
;;;;;  );_if
;;;;;  (if (and #pop5 (= #plis5 nil))
;;;;;    (setq #plis5 "2")
;;;;;  );_if
;;;;;|;
;;;;;  (setq #plis1 nil)
;;;;;  (setq #plis2 nil)
;;;;;  (setq #plis3 nil)
;;;;;  (setq #plis4 nil)
;;;;;  (setq #plis5 nil)
;;;;;;-- 2011/06/29 A.Satoh Mod -E
;;;;;
;;;;;;-- 2011/06/29 A.Satoh Mod - S
;;;;;;  (setq #sui$ (nth (atoi #ret5) #sui$$))                  ; WT������N�I��ں���
;;;;;  (if #sui$$
;;;;;    (setq #sui$ (nth (atoi #ret5) #sui$$))                ; WT������N�I��ں���
;;;;;    (setq #sui$ nil)                                      ; WT������N�I��ں���
;;;;;  )
;;;;;;-- 2011/06/29 A.Satoh Mod - E
;;;;;  (if &sink$$
;;;;;    (setq #sink$ (nth (atoi #ret1) &sink$$))              ; sink�ʒu�̑I��ں���
;;;;;    (setq #sink$ nil)                                     ; sink�ʒu�̑I��ں���
;;;;;  );_if
;;;;;  (setq #name$ (nth (atoi #ret1) &name$$))                ; WT�ݸ�̑I��ں���
;;;;;  (setq #SNK_DIM (atof #ret2)) ; �I�������ݸ�e���@(��ި���ޯ��) "200(320)"==>200.0
;;;;;  (setq #plis$ (list #plis1 #plis2 #plis3 #plis4 #plis5)) ; �I����������i�Ԗ���ؽ�
;;;;;
;;;;;  ;;; �ݸLR�I��
;;;;;  (if (= #ret3 "1") ; �I�������ݸLR����
;;;;;    (setq #LR "R")
;;;;;    (setq #LR "L")
;;;;;  );_if
;;;;;
;;;;;;;;01/07/30YM@  (if (and (= #ret4 "0")(equal (nth 9 #name$) 0.0 0.1)) ; LR�L�� �����߹�ĂȂ�
;;;;;;;;01/07/30YM@    (setq #LR "Z")
;;;;;;;;01/07/30YM@  );_if
;;;;;;;;
;;;;;;;;2011/09/14YM@DEL  (if (= #ret4 "1") ; �I�������ݸ�߹��
;;;;;;;;2011/09/14YM@DEL    (setq #POCKET "Y")
;;;;;;;;2011/09/14YM@DEL    (setq #POCKET "N")
;;;;;;;;2011/09/14YM@DEL  );_if
;;;;;
;;;;;  (done_dialog)
;;;;;  (list #sink$ #name$ #SNK_DIM #LR #sui$ #plis$ #POCKET)
;;;;;);##GetDlgItem
(defun ##GetDlgItem ( / ; �޲�۸ނ̌��ʂ��擾����
  #ret1 #ret2 #ret3 #ret4 #ret5
  #ret6 #ret7 #ret8 #ret9 #ret10
  #name$ #SNK_DIM #plis$ #LR #sink$ #sui$ 
  )

  (setq #ret1 (get_tile "sink"))    ; �ݸ����
  (setq #ret2 (get_tile "edit_sinkpos")) ; �ݸ�e���@
  (setq #ret3 (get_tile "radioR"))  ; �ݸLR
  (setq #ret4 (get_tile "radioL"))  ; �ݸLR

  (if #sui$$
    (setq #sui$ (nth (atoi #ret5) #sui$$))                ; WT������N�I��ں���
    (setq #sui$ nil)                                      ; WT������N�I��ں���
  )

  (if &sink$$
    (setq #sink$ (nth (atoi #ret1) &sink$$))              ; sink�ʒu�̑I��ں���
    (setq #sink$ nil)                                     ; sink�ʒu�̑I��ں���
  )

  (setq #name$ (nth (atoi #ret1) &name$$))                ; WT�ݸ�̑I��ں���
  (setq #SNK_DIM (atof #ret2)) ; �I�������ݸ�e���@(��ި���ޯ��) "200(320)"==>200.0

  (setq #plis$ nil)
  (setq #ret5 (get_tile "hole"))    ; ����������
  (if (= #ret5 "0")
    (progn
      (setq #plis$ (list nil nil nil nil nil))
    )
    (progn
      (setq #ret6  (get_tile "opR"))     ; �I�v�V������
      (setq #ret7  (get_tile "suiL"))    ; ������
      (setq #ret8  (get_tile "sui"))     ; ����
      (setq #ret9  (get_tile "suiR"))    ; �����E
      (setq #ret10 (get_tile "opL"))     ; �I�v�V�����E

      (if (/= #ret6 "")
        (if (= (nth 0 #mode_f$) 1)
          (if (= #ret6 "0")
            (setq #plis$ (append #plis$ (list nil)))
            (setq #plis$ (append #plis$ (list (nth 3 (nth (atoi #ret6) #suisen$$)))))
          )
        )
      )
      (if (/= #ret7 "")
        (if (= (nth 1 #mode_f$) 1)
          (if (= #ret7 "0")
            (setq #plis$ (append #plis$ (list nil)))
            (setq #plis$ (append #plis$ (list (nth 3 (nth (atoi #ret7) #suisen$$)))))
          )
        )
      )
      (if (/= #ret8 "")
        (if (= (nth 2 #mode_f$) 1)
          (if (= #ret8 "0")
            (setq #plis$ (append #plis$ (list nil)))
            (setq #plis$ (append #plis$ (list (nth 3 (nth (atoi #ret8) #suisen$$)))))
          )
        )
      )
      (if (/= #ret9 "")
        (if (= (nth 3 #mode_f$) 1)
          (if (= #ret9 "0")
            (setq #plis$ (append #plis$ (list nil)))
            (setq #plis$ (append #plis$ (list (nth 3 (nth (atoi #ret9) #suisen$$)))))
          )
        )
      )
      (if (/= #ret10 "")
        (if (= (nth 4 #mode_f$) 1)
          (if (= #ret10 "0")
            (setq #plis$ (append #plis$ (list nil)))
            (setq #plis$ (append #plis$ (list (nth 3 (nth (atoi #ret10) #suisen$$)))))
          )
        )
      )
    )
  )

  ;;; �ݸLR�I��
  (if (= #ret3 "1") ; �I�������ݸLR����
    (setq #LR "R")
    (if (= #ret4 "1")
      (setq #LR "L")
      (setq #LR "Z")
    )
  )

  (done_dialog)
  (list #sink$ #name$ #SNK_DIM #LR #sui$ #plis$ "N")

);##GetDlgItem
;-- 2011/09/17 A.Satoh Mod - S

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-- 2011/09/17 A.Satoh Add - S
(defun ##SetEnableList (
  &sui_ana$
  /
  #analst$ #idx #flg1 #flg2 #flg3 #flg4 #flg5
  )

  (setq #sui_type (nth 1 &sui_ana$))
  (setq #analst$ nil)
  (setq #idx 3)
  (repeat 5
    (if (/= (nth #idx &sui_ana$) nil)
      (setq #analst$ (append #analst$ (list (nth #idx &sui_ana$))))
    )
    (setq #idx (1+ #idx))
  )

  ; �e���X�g����U�N���A����
  (setq #flg1 0 #flg2 0 #flg3 0 #flg4 0 #flg5 0)
  (mode_tile "opL"  1)
  (start_list "opL" 3)
  (add_list "")
  (end_list)
  (mode_tile "suiL" 1)
  (start_list "suiL" 3)
  (add_list "")
  (end_list)
  (mode_tile "sui"  1)
  (start_list "sui" 3)
  (add_list "")
  (end_list)
  (mode_tile "suiR" 1)
  (start_list "suiR" 3)
  (add_list "")
  (end_list)
  (mode_tile "opR"  1)
  (start_list "opR" 3)
  (add_list "")
  (end_list)

  ; WT��������񂩂�L��/�����t���O���X�g���擾����
  ; �� ��1=2 ��2=4 ��3�`��5=nil�ł���ꍇ��(2 4 0 0 0)
  (if #analst$
    (progn
      (setq #idx 0)
      (repeat (length #analst$)
        (cond
          ((= (nth #idx #analst$) 1)
            (mode_tile "opL" 0)

            (start_list "opL" 3)
            (foreach #lst #suisen$$
              (add_list (nth 2 #lst))
            )
            (end_list)
            (set_tile "opL" (itoa #def_no2))
            (setq #flg1 1)
          )
          ((= (nth #idx #analst$) 2)
            (mode_tile "suiL" 0)

            (start_list "suiL" 3)
            (foreach #lst #suisen$$
              (add_list (nth 2 #lst))
            )
            (end_list)
            (set_tile "suiL" (itoa #def_no2))
            (setq #flg2 1)
          )
          ((= (nth #idx #analst$) 3)
            (mode_tile "sui" 0)

            (start_list "sui" 3)
            (foreach #lst #suisen$$
              (add_list (nth 2 #lst))
            )
            (end_list)
            (set_tile "sui" (itoa #def_no2))
            (setq #flg3 1)
          )
          ((= (nth #idx #analst$) 4)
            (mode_tile "suiR" 0)

            (start_list "suiR" 3)
            (foreach #lst #suisen$$
              (add_list (nth 2 #lst))
            )
            (end_list)
            (set_tile "suiR" (itoa #def_no2))
            (setq #flg4 1)
          )
          ((= (nth #idx #analst$) 5)
            (mode_tile "opR" 0)

            (start_list "opR" 3)
            (foreach #lst #suisen$$
              (add_list (nth 2 #lst))
            )
            (end_list)
            (set_tile "opR" (itoa #def_no2))
            (setq #flg5 1)
          )
        )
        (setq #idx (1+ #idx))
      )
    )
  )

  (setq #mode_f$ (list #flg1 #flg2 #flg3 #flg4 #flg5))

  (princ)
)
;-- 2011/09/17 A.Satoh Add - E


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  ; 2012/08/02 YM ADD�@÷�ĕ\��
;;;  (defun ##SHOW_TEXT ( / #text_file)
;;;
;;;		(setq #text_file  (strcat CG_SYSPATH "SINK.txt"));�ݸ�ʒu̧��
;;;		(startapp "notepad.exe" #text_file)
;;;
;;;		(princ)
;;;  );##SHOW_TEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;  &sink$$   ;(LIST)SINK�ʒu�e�[�u���̓��e
;;;  &name$$   ;(LIST)WT�V���N�e�[�u���̓��e

  ;;; �޲�۸ނ̕\��
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "SelectSinkDlg" #dcl_id)) (exit))
  ;;; �����ݸ����ؽ�
  (start_list "sink" 3)

  (foreach #lst &name$$ ; WT�V���N
    (add_list (nth 2 #lst)) ; WT�ݸ.�ݸ�L��,�ݸ����
  )
  (end_list)
  ;;; ��ق̏����ݒ�
  (set_tile "sink" "0")
  ;;; �����ݸ�L��
  (setq #snk (nth 1 (car &name$$)))

;-- 2011/09/18 A.Satoh Add - S
  (setq #mode_f$ '(0 0 0 0 0))
;-- 2011/09/18 A.Satoh Add - E

;-- 2011/09/16 A.Satoh Del - S
;;;;;;; �����ݸ�e���@ؽ�
;;;;;  (setq #dimST$ nil #dimRP$ nil) ; �ݸ�ʒuؽē��e
;-- 2011/09/16 A.Satoh Del - S
;;;2011/09/14YM@DEL  (if &sink$$
;;;2011/09/14YM@DEL    (progn
;;;2011/09/14YM@DEL      (start_list "sinkpos" 3)
;;;2011/09/14YM@DEL;;;     (setq #i #i0)
;;;2011/09/14YM@DEL      (setq #i #i1)
;;;2011/09/14YM@DEL      (setq #j #i2)
;;;2011/09/14YM@DEL      (repeat 10
;;;2011/09/14YM@DEL        (setq #dimST (nth #i (car &sink$$))) ; SINK�ʒu.�e���@1,2,3���  (&sink$$�̍ŏ��̂���)
;;;2011/09/14YM@DEL        (setq #dimRP (nth #j (car &sink$$))) ; SINK�ʒu.�e���@1,2,3��߽ (&sink$$�̍ŏ��̂���)
;;;2011/09/14YM@DEL        (if (> #dimST 0.1)
;;;2011/09/14YM@DEL          (progn
;;;2011/09/14YM@DEL            (add_list (strcat (itoa (fix (+ #dimST 0.001))) " ("
;;;2011/09/14YM@DEL                              (itoa (fix (+ #dimRP 0.001))) ")"))
;;;2011/09/14YM@DEL            (Setq #dimST$ (append #dimST$ (list #dimST)))
;;;2011/09/14YM@DEL            (Setq #dimRP$ (append #dimRP$ (list #dimRP)))
;;;2011/09/14YM@DEL          )
;;;2011/09/14YM@DEL        )
;;;2011/09/14YM@DEL        (setq #i (1+ #i))
;;;2011/09/14YM@DEL        (setq #j (1+ #j))
;;;2011/09/14YM@DEL;;;01/01/11YM@        (setq #dum (nth #i (car &sink$$))) ; SINK�ʒu
;;;2011/09/14YM@DEL;;;01/01/11YM@        (if (> #dum 0.1)
;;;2011/09/14YM@DEL;;;01/01/11YM@          (add_list (itoa (fix (+ #dum 0.001))))
;;;2011/09/14YM@DEL;;;01/01/11YM@        );_if
;;;2011/09/14YM@DEL;;;01/01/11YM@        (setq #i (1+ #i))
;;;2011/09/14YM@DEL      )
;;;2011/09/14YM@DEL      (end_list)
;;;2011/09/14YM@DEL    )
;;;2011/09/14YM@DEL    (progn
;;;2011/09/14YM@DEL      (princ) ; 00/11/30 YM ADD
;;;2011/09/14YM@DEL    )
;;;2011/09/14YM@DEL  );_if
;;;2011/09/14YM@DEL  (setq #DimA (##GetDimA #snk)) ; �����\���ݸ�ɑ΂���W�����@
;;;2011/09/14YM@DEL  (if (= #ZaiF "1")
;;;2011/09/14YM@DEL    (setq #dimA$ #dimST$)
;;;2011/09/14YM@DEL    (setq #dimA$ #dimRP$)
;;;2011/09/14YM@DEL  );_if
;;;2011/09/14YM@DEL
;;;2011/09/14YM@DEL;;; (setq #i 0 #focus nil) ; 02/11/15 YM MOD
;;;2011/09/14YM@DEL  (setq #i 0 #focus 0) ; 02/11/15 YM MOD
;;;2011/09/14YM@DEL  (foreach dimA #dimA$
;;;2011/09/14YM@DEL    (if (equal dimA #DimA 0.1)
;;;2011/09/14YM@DEL      (setq #focus #i)
;;;2011/09/14YM@DEL    );_if
;;;2011/09/14YM@DEL    (setq #i (1+ #i))
;;;2011/09/14YM@DEL  )
;;;2011/09/14YM@DEL
;;;2011/09/14YM@DEL;;; ��ق̏����ݒ�
;;;2011/09/14YM@DEL;;;  (set_tile "sinkpos" "0") ; �����͍ŏ��̍��ڂ�\��
;;;2011/09/14YM@DEL  (if #focus
;;;2011/09/14YM@DEL    (set_tile "sinkpos" (itoa #focus)) ; �����͍ŏ��̍��ڂ�\�� 01/03/08 YM MOD �W�����@��̫���
;;;2011/09/14YM@DEL    (set_tile "sinkpos" "0") ; �I�������ݸ�e���@
;;;2011/09/14YM@DEL  );_if
;-- 2011/09/16 A.Satoh Mod - S
;;;;;
;;;;;  ; �I�������ݸ�e���@
;;;;;  (set_tile "edit_sinkpos"
;;;;;;;;2011/09/14YM@DEL    (rtos (nth (+ (atoi (get_tile "sinkpos")) #i1) (car &sink$$)) 2 0) ; �\�i����0
;;;;;    (rtos 777.7 2 1) ; �\�i����0 �y�b��z
;;;;;  )
  (setq #xd_G_LSYM$ (CFGetXData &CAB "G_LSYM"))
  (if #xd_G_LSYM$
    (progn
      (setq #hinban (nth  5 #xd_G_LSYM$))
      (setq #LR     (nth  6 #xd_G_LSYM$))
      (setq #youto  (itoa (nth 12 #xd_G_LSYM$)))
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
          (list
            (list "�i�Ԗ���" #hinban 'STR)
            (list "LR�敪"   #LR     'STR)
            (list "�p�r�ԍ�" #youto  'INT)
          )
        )
      )
      (if (and #qry$$ (= 1 (length #qry$$)))
        (setq #width_CAB (/ (nth 3 (car #qry$$)) 2))
				;else
        (setq #width_CAB 0.0)
      )
    )
		;else
    (setq #width_CAB 0.0)
  )

	;2017/01/11 YM ADD-S
	; Errmsg.ini ����̼ݸ�ͼݸ�e���߂����@�����ꏈ����

;;;	(CFAlertMsg "���i�R�j�� ��PG���C�� ERRMSG.INI�����ɍs��") ;2017/01/19 YM ADD

	(setq #sSINK$ (CFgetini "SINK_WAKI" "SINK" (strcat CG_SKPATH "ERRMSG.INI")))
	(setq #sDIST$ (CFgetini "SINK_WAKI" "DIST" (strcat CG_SKPATH "ERRMSG.INI")))

  (if (strp #sSINK$) (setq #sSINK$ (strparse #sSINK$ ",")))
  (if (strp #sDIST$) (setq #sDIST$ (strparse #sDIST$ ",")))
	; #snk
	(setq #iii 0)
	(setq #width_SP nil) 
	(foreach #sSINK #sSINK$
		(if (= #sSINK #snk)
			(progn ;�Y���̼ݸ������
				(setq #width_SP (atof (nth #iii #sDIST$)))
			)
		);_if
		(setq #iii (1+ #iii))
	);foreach

;;;	(CFAlertMsg "���i�S�j�� ��PG���C�� ERRMSG.INI�����ɍs����") ;2017/01/19 YM ADD

	;2017/01/11 YM ADD-E


	(if #width_SP
		(progn
	  	(set_tile "edit_sinkpos" (rtos #width_SP 2 1));P�V���N�ȂǓ���
;;;			(setq #width #width_SP);�߂�l 2017/01/20 YM DEL
		)
		;else
		(progn
	  	(set_tile "edit_sinkpos" (rtos #width_CAB 2 1));�ݸ���޾���
;;;			(setq #width #width_CAB);�߂�l 2017/01/20 YM DEL
		)
	);_if

;-- 2011/09/16 A.Satoh Mod - E

;-- 2011/09/17 A.Satoh Del - S
;;;;;;;; �������������ؽ�
;;;;;;-- 2011/06/29 A.Satoh Mod -S
;;;;;; �������� 6/29���_�ł̎b�菈��
;;;;;; �������� �d�l�m���ɑΉ�
;;;;;;|
;;;;;  (setq #sui$$ '())
;;;;;  (start_list "hole" 3)
;;;;;  (setq #i 10)
;;;;;  (repeat 5
;;;;;    (setq #dim (nth #i (car &name$$))) ; WT�ݸ.������ID 1,2,3,4,5 (&name$$�̍ŏ��̂���)
;;;;;    (if (> #dim 0.1)
;;;;;      (progn
;;;;;        (setq #sui$ ; �P�������� ������ID���琅�����^�C�v��������
;;;;;          (CFGetDBSQLRec CG_DBSESSION "WT������"
;;;;;            (list (list "������ID" (itoa (fix (+ #dim 0.001))) 'INT))
;;;;;          )
;;;;;        );_(setq
;;;;;        (setq #sui$ (DBCheck #sui$ "�wWT�������x" "KPSelectSinkDlg")) ; nil or ������ �װ
;;;;;        (setq #sui$$ (append #sui$$ (list #sui$))) ; ***
;;;;;        (add_list (nth 2 #sui$)) ; WT������N.�������^�C�v
;;;;;      )
;;;;;    );_if
;;;;;    (setq #i (1+ #i))
;;;;;  )
;;;;;  (end_list)
;;;;;
;;;;;;;; ��ق̏����ݒ�
;;;;;  (set_tile "hole" "0")    ; �����͍ŏ��̍��ڂ�\��
;;;;;|;
;;;;;  (mode_tile "hole" 1)
;;;;;;-- 2011/06/29 A.Satoh Mod -E
;-- 2011/09/17 A.Satoh Del - E

  ;;; �ݸLR�I��
;-- 2012/05/18 A.Satoh Mod LR�L������s�� - S
;;;;;;-- 2011/11/21 A.Satoh Mod - S
;;;;;;;;;;  ;2011/09/14 YM ADD-S
;;;;;;;;;;  (cond
;;;;;;;;;;    ((= #SNK_KATTE "R")
;;;;;;;;;;      (set_tile "radioR" "1") ; "R"
;;;;;;;;;;    )
;;;;;;;;;;    ((= #SNK_KATTE "L")
;;;;;;;;;;      (set_tile "radioL" "1") ; "L"
;;;;;;;;;;    )
;;;;;;;;;;    (T
;;;;;;;;;;      (set_tile "radioR" "1") ; "R"
;;;;;;;;;;    )
;;;;;;;;;;  );_cond
;;;;;;;;;;  (mode_tile "radio" 0)   ; LR�L���I���\
;;;;;;;;;;  ;2011/09/14 YM ADD-E
;;;;;	(cond
;;;;;		((= #SNK_KATTE "R")
;;;;;			(set_tile "radioR" "1") ; "R"
;;;;;			(mode_tile "radio" 1)   ; LR�L���I��s��
;;;;;		)
;;;;;		((= #SNK_KATTE "L")
;;;;;			(set_tile "radioL" "1") ; "L"
;;;;;			(mode_tile "radio" 1)   ; LR�L���I��s��
;;;;;		)
;;;;;		(T
;;;;;			(set_tile "radioL" "1") ; "L"
;;;;;			(mode_tile "radio" 0)   ; LR�L���I���\
;;;;;		)
;;;;;	)
  (setq #umu_LR (nth 4 (nth 0 &name$$)))  ; LR�L��
  (if (= #umu_LR 0)
    (progn
      (set_tile "radioR" "0") ; "R"
      (set_tile "radioL" "0") ; "R"
      (mode_tile "radio" 1)   ; LR�L���I��s��
    )
    (progn
      (cond
        ((= #SNK_KATTE "R")
          (set_tile "radioR" "1") ; "R"
		      (mode_tile "radio" 1)   ; LR�L���I��s��
        )
        ((= #SNK_KATTE "L")
          (set_tile "radioL" "1") ; "L"
		      (mode_tile "radio" 1)   ; LR�L���I��s��
        )
        (T
          (set_tile "radioL" "1") ; "L"
		      (mode_tile "radio" 0)   ; LR�L���I���\
        )
      )
    )
  )
;;;;;;-- 2011/11/21 A.Satoh Mod - E
;-- 2012/05/18 A.Satoh Add LR�L������s�� - E

;-- 2011/09/16 A.Satoh Mod - S
;;;;;;;01/12/14YM@MOD  (set_tile "radioR" "1")
;;;;;;;01/12/14YM@MOD (if (equal (nth 9 (car &name$$)) 0.0 0.1) ; LR�L�� 00/10/25 YM ADD
;;;;;;;01/12/14YM@MOD   (mode_tile "radio" 1) ; LR�L���Ȃ� ; �g�p�s��
;;;;;;;01/12/14YM@MOD   (mode_tile "radio" 0) ; LR�L������ ; �g�p��
;;;;;;;01/12/14YM@MOD );_if
;;;;  (set_tile "text2" "WT�[����̃V���N�ʒu")
;;;;;;; (set_tile "text2" "�E�[����̃V���N�ʒu")
;;;;
;;;;2011/09/14YM@DEL; �ݸ�߹�ĕt��׼޵���� 01/02/09 YM ADD
;;;;2011/09/14YM@DEL  (cond
;;;;2011/09/14YM@DEL    ((= (nth 16 (car &name$$)) "P")
;;;;2011/09/14YM@DEL      (mode_tile "radioPOCKET" 0) ; �g�p�\
;;;;2011/09/14YM@DEL    )
;;;;2011/09/14YM@DEL    (T
;;;;2011/09/14YM@DEL      (set_tile "radioPN" "1")
;;;;2011/09/14YM@DEL      (mode_tile "radioPOCKET" 1) ; �g�p�s�\
;;;;2011/09/14YM@DEL    )
;;;;2011/09/14YM@DEL  );_cond
  (set_tile "text2" "�ݸ���޾����ʒu")
;-- 2011/09/16 A.Satoh Mod - E

;-- 2011/09/17 A.Satoh Mod - S
;;;;;;;; ���������߯�߱���ؽ�
;;;;;;-- 2011/06/29 A.Satoh Mod -S
;;;;;; �������� 6/29���_�ł̎b�菈��
;;;;;; �������� �d�l�m���ɑΉ�
;;;;;;|
;;;;;  (setq #sui$ (car #sui$$))
;;;;;  (##SUISENpop) ; �ݸ�L��,WT������Nں��� #snk #sui$ ���g�p����
;;;;;|;
;;;;;  (mode_tile "suiL" 1)
;;;;;  (mode_tile "suiR" 1)
;;;;;  (mode_tile "sui"  1)
;;;;;  (mode_tile "opL"  1)
;;;;;  (mode_tile "opR"  1)
;;;;;;-- 2011/06/29 A.Satoh Mod -E
  ;;; �����|�b�v�A�b�v���X�g�����ݒ�
  (setq #ana_type (nth 7 (car #name$$)))
  (setq #type     (nth 8 (car #name$$)))
  (setq #kikaku   (nth 9 (car #name$$)))

  ; �yWT�������z���琅�����������o��
  (setq #sui_ana$$
    (CFGetDBSQLRec CG_DBSESSION "WT������"
      (list (list "�������^�C�v���" #ana_type 'STR))
    )
  )
  (if #sui_ana$$
    (progn
      (setq #sui_ana$$ (CFListSort #sui_ana$$ 0))
      (setq #idx 0)
      (setq #def_no1 0)
      (repeat (length #sui_ana$$)
        (if (= 1 (nth 8 (nth #idx #sui_ana$$)))
          (setq #def_no1 #idx)
        )
        (setq #idx (1+ #idx))
      )
    )
    (progn
      (setq #msg (strcat "�wWT�������x��ں��ނ�����܂���B\n�������^�C�v���=" #ana_type))
      (CFAlertMsg #msg)
      (quit)
    )
  )

  ; ���������X�g�ɃA�C�e����ݒ�
  (start_list "hole" 3)
  (foreach #lst #sui_ana$$
    (add_list (nth 2 #lst))
  )
  (end_list)
  (set_tile "hole" (itoa #def_no1))

  ; �ySINK�����Ǘ��z���琅���������o��
  (setq #suisen$$
    (CFGetDBSQLRec CG_DBSESSION "WT������"
      (list (list "�I�������" #type 'STR))
    )
  )
  (if #suisen$$
    (progn
      (setq #suisen$$ (CFListSort #suisen$$ 0))
      (setq #def_no2 0)
      (setq #idx 0)
      (repeat (length #suisen$)
        (if (= 1 (nth 5 (nth #idx #sui_ana$$)))
          (setq #def_no2 #idx)
        )
        (setq #idx (1+ #idx))
      )
    )
    (progn
      (setq #msg (strcat "�wWT�����ǁx��ں��ނ�����܂���B\n�I�������=" #type))
      (CFAlertMsg #msg)
      (quit)
    )
  )

  (##SetEnableList (nth #def_no1 #sui_ana$$))
;-- 2011/09/17 A.Satoh Mod - E

;;;09/22YM@;;; ���a�̏����ݒ�
;;;09/22YM@  (set_tile "kei1" "36")
;;;09/22YM@  (set_tile "kei2" "-")

  ;// ��ق�ر���ݐݒ�
;;;;;  (action_tile "radio" "(##CHG_sinkLR)")                 ; �ݸLR���ς���
;;;;;;;;2011/09/14YM@DEL  (action_tile "radioPOCKET" "(##CHG_sinkPOCKET)")       ; �ݸ�߹�ėL�����ς���
  (action_tile "sink" "(##CHG_sink)")                    ; �ݸ���ς���
;;;;;;;;2011/09/14YM@DEL  (action_tile "sinkpos" "(##CHG_sinkpos)")              ; �ݸ�ʒu���ς��� edit_sinkpos
  (action_tile "edit_sinkpos" "(##CHK_edit \"edit_sinkpos\")"); �ݸ�ʒu�ʒu��ި���ޯ������
  (action_tile "hole" "(##CHG_hole $value)")             ; ���������ς���

;;;	;2012/08/02 YM ADD-S
;;;	(action_tile "BUTTON"  "(##SHOW_TEXT)")
;;;	;2012/08/02 YM ADD-E

  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")   ; OK
  (action_tile "cancel" "(setq #ret$ nil)(done_dialog)") ; cancel
  (start_dialog)
  (unload_dialog #dcl_id)
;-- 2011/09/17 A.Satoh Add - S
  (if #ret$
    (setq #ret$ (append #ret$ (list #width_CAB)))
  )
;-- 2011/09/17 A.Satoh Add - E
  #ret$
);KPSelectSinkDlg


;;;01/01/15/YM@;;;<HOM>*************************************************************************
;;;01/01/15/YM@;;; <�֐���>    : PK_MakeG_WTR
;;;01/01/15/YM@;;; <�����T�v>  : �~"G_WTR"���쐬����
;;;01/01/15/YM@;;; <�߂�l>    : �~�}�`��
;;;01/01/15/YM@;;; <�쐬>      : 00/07/22 YM
;;;01/01/15/YM@;;; <���l>      :
;;;01/01/15/YM@;;;*************************************************************************>MOH<
;;;01/01/15/YM@(defun PK_MakeG_WTR (
;;;01/01/15/YM@  &kei ; ���a
;;;01/01/15/YM@  &o   ; ���S���W
;;;01/01/15/YM@  /
;;;01/01/15/YM@  )
;;;01/01/15/YM@  (entmake ; ���S�_�Ɣ��a�𗘗p���ă\���b�h�̌��ƂȂ�~�����
;;;01/01/15/YM@    (list
;;;01/01/15/YM@      '(0 . "CIRCLE")
;;;01/01/15/YM@      '(100 . "AcDbEntity")
;;;01/01/15/YM@      '(67 . 0)
;;;01/01/15/YM@      (cons 8 SKW_AUTO_SECTION)
;;;01/01/15/YM@      '(62 . 2)
;;;01/01/15/YM@      '(100 . "AcDbCircle")
;;;01/01/15/YM@      (cons 10 &o) ; ���S�_
;;;01/01/15/YM@      (cons 40 (/ &kei 2))
;;;01/01/15/YM@      '(210 0.0 0.0 1.0)
;;;01/01/15/YM@    )
;;;01/01/15/YM@  )
;;;01/01/15/YM@  (entlast)
;;;01/01/15/YM@);PK_MakeG_WTR

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_PosWTR
;;; <�����T�v>  : ������z�u����
;;; <�߂�l>    :
;;;        LIST : ������(G_WTR)�}�`�̃��X�g
;;; <�쐬>      : 1999-10-21
;;; <���l>      : ��������Łu�����v�Ȃ��̏ꍇ 01/01/15 YM ADD
;;;*************************************************************************>MOH<
(defun PKW_PosWTR (
  &KCode        ;(STR)�H��L��
  &SeriCode     ;(STR)SERIES�L��
  &snk-en       ;(ENAME)�V���N��}�`
  &snk-cd       ;(STR)�V���N�L��
;-- 2011/09/18 A.Satoh Mod(�R�����g�ύX) - S
;  &plis$        ;�I�����ꂽ"WT������" ں��� (���� -2,-1,0,1,2 �̏�) nil ����
  &plis$        ;�I�����ꂽWT�����Ǖi�ԃ��X�g (nil �i�� nil �i�� nil)
  &scab-en      ;(ENAME)�ݸ���ފ�_�}�`
  &kikaku_zok   ; �K�i������
;-- 2011/09/18 A.Satoh Mod(�R�����g�ύX) - E
  /
;-- 2011/09/18 A.Satoh Mod - S
;;;;;  #ANG #EN #FIG-QRY$ #HINBAN
;;;;;  #I #K #KEI #ANA_LAYER
;;;;;  #O #OS #PLIS
;;;;;  #PT #PTEN5 #PTEN5$ #PTEN5$$
;;;;;  #SM #WtrHoleEn$ #XD_PTEN$ #msg
;;;;;;-- 2011/09/09 A.Satoh Mod - S
;;;;;;  #ZOKU #ZOKUP #ZOKUP$ #dum #FLG #SS_DUM
;;;;;  #ZOKU #ZOKUP #ZOKUP$ #FLG #SS_DUM
;;;;;;-- 2011/09/09 A.Satoh Mod - E
;;;;;  #ANG0 #LR #WTRSYM$
  #kikaku_f #fig #WtrHoleEn$ #plis #flg #ANA_layer
  #os #sm #pten5$$ #xd_G_LSYM$ #basePnt #idx #idx2 #wk_pten5$$
  #pten5$ #dist #pten_pnt #plis_len #hinban #fig-qry$
  #xd_PTEN$ #pten5 #zokuP #o #ang #ang0 #LR #msg
  #ss_dum #en #WTRSYM$ #cnt #skip
;-- 2011/09/18 A.Satoh Mod - S
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_PosWTR ////")
  (CFOutStateLog 1 1 " ")

;-- 2011/09/12 A.Satoh Add - S
  ;;; �K�i����t���O T:�K�i�i nil:�����i
  (setq #kikaku_f T)
;-- 2011/09/12 A.Satoh Add - E
  (setq #flg nil #WtrHoleEn$ '())
  (foreach #plis &plis$
    (if #plis
      (setq #flg T)
    )
  )
; ��������Łu�����v�Ȃ��̏ꍇ 01/01/15 YM ADD
;;;  (setq #ANA_layer "Z_00_00_00_01" ) ; �ڂɌ�����
  (setq #ANA_layer SKW_AUTO_SECTION) ; �ڂɌ����Ȃ�

  (setq #cnt 0)
  (if #flg
    (progn
      ;// �V�X�e���ϐ��ۊ�
      (setq #os (getvar "OSMODE"))   ;O�X�i�b�v
      (setq #sm (getvar "SNAPMODE")) ;�X�i�b�v
      (setvar "OSMODE"   0)
      (setvar "SNAPMODE" 0)

      (if (not (tblsearch "APPID" "G_WTR")) (regapp "G_WTR"))

      ;// �V���N�ɐݒ肳��Ă��鐅����t���_�i�o�_=�T�j�̏����擾����
      (setq #pten5$$ (PKGetPTEN_NO &snk-en 5)) ; �߂�l(PTEN�}�`,G_PTEN)��ؽĂ�ؽ�

;-- 2011/09/18 A.Satou Mod - S
      ; �V���N�L���r�̍����_���擾����
      (setq #xd_G_LSYM$ (CFGetXData &scab-en "G_LSYM"))
      (setq #basePnt (nth 1 #xd_G_LSYM$))

      ; �擾����P�_5�}�`���V���N�L���r��_�Ƃ̋����ɂ��\�[�g����
      (setq #idx 0)
      (setq #wk_pten5$$ nil)
      (setq #dist 0.0)
      (repeat (length #pten5$$)
        (setq #pten_pnt (cdr (assoc 10 (entget (car (nth #idx #pten5$$))))))
        (setq #dist (distance #basePnt #pten_pnt))
        (setq #wk_pten5$$ (append #wk_pten5$$ (list (cons #dist (nth #idx #pten5$$)))))
        (setq #idx (1+ #idx))
      )
      (setq #pten5$$ (CFListSort #wk_pten5$$ 0))

;-- 2011/10/04 A.Satoh Mod - S
      (setq #plis_len (length &plis$))
      (setq #idx 0)
      (setq #idx2 0)
      (repeat (length #pten5$$)
        (setq #skip nil)
        (setq #pten5$ (nth #idx #pten5$$))

        (setq #xd_PTEN$ (nth 2 #pten5$))
        (setq #pten5    (nth 1 #pten5$))
        (setq #zokuP (nth 2 #xd_PTEN$))    ; ����
        (cond
          ((= #plis_len 1)
            (if (or (= #zokuP 1) (= #zokuP -1))
              (setq #skip T)
            )
          )
          ((= #plis_len 2)
            (if (= #zokuP 0)
              (setq #skip T)
            )
          )
        )

        (if (= #skip nil)
          (progn
            (if (/= (nth #idx2 &plis$) nil)
              (progn
                (setq #cnt (1+ #cnt))
                (setq #hinban (nth #idx2 &plis$))

                (setq #fig-qry$ ; ��������̕i�Ԃ��P��������
                  (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
                    (list (list "�i�Ԗ���" #hinban 'STR))
                  )
                )
                (setq #fig-qry$ (DBCheck #fig-qry$ "�w�i�Ԑ}�`�x" (strcat "�i�Ԗ���:" #hinban)))

                (if (/= &kikaku_zok #zokuP)
                  (setq #kikaku_f nil)
                )
                (setq #o (cdr (assoc 10 (entget #pten5)))) ; ���S�_���W

                ; ��������̔z�u
                (setq #ang (nth 2 (CFGetXData &snk-en "G_LSYM"))) ; �z�u�p�x
                (setq #LR  (nth 6 (CFGetXData &snk-en "G_LSYM"))) ; LR����

                ; �}�`�����݂��邩�m�F
                (if (= nil (findfile (strcat CG_MSTDWGPATH (nth 6 #fig-qry$) ".dwg")))
                  (progn
                    (setq #msg (strcat "����}�` : ID=" (nth 6 #fig-qry$) " ������܂���"))
                    (CFAlertMsg #msg)
                    (*error*)
                  )
                )
                (setq #ang0 #ang)

                ; �C���T�[�g
                (command "_insert"
                  (strcat CG_MSTDWGPATH (nth 6 #fig-qry$)) ; �i�Ԑ}�`.�}�`ID
                  #o 1 1 (rtd #ang0)
                )
                (command "_purge" "bl" "*" "N")
                (command "_purge" "bl" "*" "N")
                (command "_purge" "bl" "*" "N")
                (command "_purge" "bl" "*" "N")

                (command "_explode" (entlast))
                (setq #ss_dum (ssget "P"))
                (SKMkGroup #ss_dum)
                (setq #en (PKC_GetSymInGroup #ss_dum))

                ; �g���f�[�^�̕t��
                (CFSetXData #en "G_LSYM"
                  (list
                    (nth 6 #fig-qry$)          ;1 :�{�̐}�`ID  ; �i�Ԑ}�`.�}�`�h�c
                    #o                         ;2 :�}���_
                    #ang0                      ;3 :��]�p�x
                    &KCode                     ;4 :�H��L��
                    &SeriCode                  ;5 :SERIES�L��
                    (nth 0 #fig-qry$)          ;6 :�i�Ԗ���
                    "Z"                        ;7 :L/R �敪
                    ""                         ;8 :���}�`ID
                    ""                         ;9 :���J���}�`ID
                    CG_SKK_INT_SUI             ;10:���iCODE
                    2                          ;11:�����t���O
                    0                          ;12:���R�[�h�ԍ�
                    (fix (nth 2 #fig-qry$))    ;13:�p�r�ԍ�
                    0.0                        ;14:���@H
                    1                          ;15:�f�ʎw���̗L��
                    "A"                        ;16:����(����"A" or ���["D")
                  )
                );_CFSetXData
                (KcSetG_OPT #en) ; �g���ް�"G_OPT"���
                (setq #WTRSYM$ (append #WTRSYM$ (list #en)))
              )
            )
            (setq #idx2 (1+ #idx2))
          )
        )
        (setq #idx (1+ #idx))
      )
;;;;;      (setq #plis_len (length &plis$))
;;;;;      (setq #idx 0)
;;;;;      (repeat (length &plis$)
;;;;;        (if (/= (nth #idx &plis$) nil)
;;;;;          (progn
;;;;;            (setq #cnt (1+ #cnt))
;;;;;            (setq #hinban (nth #idx &plis$))
;;;;;
;;;;;            (setq #fig-qry$ ; ��������̕i�Ԃ��P��������
;;;;;              (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
;;;;;                (list (list "�i�Ԗ���" #hinban 'STR))
;;;;;              )
;;;;;            )
;;;;;            (setq #fig-qry$ (DBCheck #fig-qry$ "�w�i�Ԑ}�`�x" (strcat "�i�Ԗ���:" #hinban)))
;;;;;
;;;;;;            (if (or (= &snk-cd "S_") (= &snk-cd "L1_"))
;;;;;            (if (or (= &snk-cd "S_") (= &snk-cd "L_"))
;;;;;              (setq #pten5$ (nth 1 #pten5$$))
;;;;;              (setq #pten5$ (nth #idx #pten5$$))
;;;;;            )
;;;;;
;;;;;            (setq #xd_PTEN$ (nth 2 #pten5$))
;;;;;            (setq #pten5    (nth 1 #pten5$))
;;;;;            (setq #zokuP (nth 2 #xd_PTEN$))    ; ����
;;;;;            (if (/= &kikaku_zok #zokuP)
;;;;;              (setq #kikaku_f nil)
;;;;;            )
;;;;;            (setq #o (cdr (assoc 10 (entget #pten5)))) ; ���S�_���W
;;;;;
;;;;;            ; ��������̔z�u
;;;;;            (setq #ang (nth 2 (CFGetXData &snk-en "G_LSYM"))) ; �z�u�p�x
;;;;;            (setq #LR  (nth 6 (CFGetXData &snk-en "G_LSYM"))) ; LR����
;;;;;
;;;;;            ; �}�`�����݂��邩�m�F
;;;;;            (if (= nil (findfile (strcat CG_MSTDWGPATH (nth 6 #fig-qry$) ".dwg")))
;;;;;              (progn
;;;;;                (setq #msg (strcat "����}�` : ID=" (nth 6 #fig-qry$) " ������܂���"))
;;;;;                (CFAlertMsg #msg)
;;;;;                (*error*)
;;;;;              )
;;;;;            )
;;;;;            (setq #ang0 #ang)
;;;;;
;;;;;            ; �C���T�[�g
;;;;;            (command "_insert"
;;;;;              (strcat CG_MSTDWGPATH (nth 6 #fig-qry$)) ; �i�Ԑ}�`.�}�`ID
;;;;;              #o 1 1 (rtd #ang0)
;;;;;            )
;;;;;            (command "_purge" "bl" "*" "N")
;;;;;            (command "_purge" "bl" "*" "N")
;;;;;            (command "_purge" "bl" "*" "N")
;;;;;            (command "_purge" "bl" "*" "N")
;;;;;
;;;;;            (command "_explode" (entlast))
;;;;;            (setq #ss_dum (ssget "P"))
;;;;;            (SKMkGroup #ss_dum)
;;;;;            (setq #en (PKC_GetSymInGroup #ss_dum))
;;;;;
;;;;;            ; �g���f�[�^�̕t��
;;;;;            (CFSetXData #en "G_LSYM"
;;;;;              (list
;;;;;                (nth 6 #fig-qry$)          ;1 :�{�̐}�`ID  ; �i�Ԑ}�`.�}�`�h�c
;;;;;                #o                         ;2 :�}���_
;;;;;                #ang0                      ;3 :��]�p�x
;;;;;                &KCode                     ;4 :�H��L��
;;;;;                &SeriCode                  ;5 :SERIES�L��
;;;;;                (nth 0 #fig-qry$)          ;6 :�i�Ԗ���
;;;;;                "Z"                        ;7 :L/R �敪
;;;;;                ""                         ;8 :���}�`ID
;;;;;                ""                         ;9 :���J���}�`ID
;;;;;                CG_SKK_INT_SUI             ;10:���iCODE
;;;;;                2                          ;11:�����t���O
;;;;;                0                          ;12:���R�[�h�ԍ�
;;;;;                (fix (nth 2 #fig-qry$))    ;13:�p�r�ԍ�
;;;;;                0.0                        ;14:���@H
;;;;;                1                          ;15:�f�ʎw���̗L��
;;;;;                "A"                        ;16:����(����"A" or ���["D")
;;;;;              )
;;;;;            );_CFSetXData
;;;;;            (KcSetG_OPT #en) ; �g���ް�"G_OPT"���
;;;;;            (setq #WTRSYM$ (append #WTRSYM$ (list #en)))
;;;;;          )
;;;;;        )
;;;;;        (setq #idx (1+ #idx))
;;;;;      )
;-- 2011/10/04 A.Satoh Mod - E
;;;;;      (setq #i 0)
;;;;;      ; 01/07/17 YM ADD
;;;;;      (setq #WTRSYM$ nil)
;;;;;      (repeat (length &plis$)
;;;;;        (setq #plis (nth #i &plis$))
;;;;;;;; #plis=num �̏ꍇ
;;;;;        (if (and #plis (not (listp #plis))) ; ؽĂłȂ��ꍇ�������Ȃ��������J����ꍇ 00/09/19 YM MOD
;;;;;          (progn
;;;;;            (setq #zoku (atoi #plis))
;;;;;            (setq #k 0)
;;;;;            (setq #zokuP$ '())
;;;;;            (foreach #pten5$ #pten5$$
;;;;;              (setq #xd_PTEN$ (cadr #pten5$))    ; �g���ް�"G_PTEN"
;;;;;              (setq #zokuP (nth 2 #xd_PTEN$))    ; ����
;;;;;              (if (and (= #zokuP #zoku)               ; �����������Ȃ琅��z�u
;;;;;                       (= (member #zokuP #zokuP$) nil))
;;;;;                (progn
;;;;;                  (setq #zokuP$ (append #zokuP$ (list #zokuP))) ; PTEN5�}�`��
;;;;;                  (setq #pten5 (car  #pten5$))   ; PTEN5�}�`��
;;;;;                  (setq #kei (nth 1 #xd_PTEN$))  ; ���a
;;;;;                  (setq #o (cdr (assoc 10 (entget #pten5)))) ; ���S�_���W
;;;;;;-- 2011/09/09 A.Satoh Del - S
;;;;;;                  (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"�̉~���쐬����
;;;;;;                  ;// �������g���f�[�^��ݒ�
;;;;;;                  (CFSetXData #dum "G_WTR" (list #zokuP))
;;;;;;                  (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; �������}�`��
;;;;;;-- 2011/09/09 A.Satoh Del - E
;;;;;                )
;;;;;              );_if
;;;;;            );_foreach
;;;;;          )
;;;;;        );_if
;;;;;;;; #plis='(LIST) �̏ꍇ
;;;;;        (if (and #plis (listp #plis)) ; ����������ꍇ
;;;;;          (progn
;;;;;            (setq #zoku (fix (nth 2 #plis)))   ; ����
;;;;;            (setq #hinban (nth 3 #plis))       ; �i�Ԗ���
;;;;;            (setq #fig-qry$ ; ��������̕i�Ԃ��P��������
;;;;;              (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
;;;;;                (list (list "�i�Ԗ���" #hinban 'STR))
;;;;;              )
;;;;;            );_(setq
;;;;;            (setq #fig-qry$ (DBCheck #fig-qry$ "�w�i�Ԑ}�`�x" (strcat "�i�Ԗ���:" #hinban)))
;;;;;
;;;;;            (setq #k 0)
;;;;;            (setq #zokuP$ '())
;;;;;            (foreach #pten5$ #pten5$$
;;;;;              (setq #xd_PTEN$ (cadr #pten5$))    ; �g���ް�"G_PTEN"
;;;;;              (setq #zokuP (nth 2 #xd_PTEN$))    ; ����
;;;;;              (if (and (= #zokuP #zoku)               ; �����������Ȃ琅��z�u
;;;;;                       (= (member #zokuP #zokuP$) nil))
;;;;;                (progn
;;;;;                  (setq #zokuP$ (append #zokuP$ (list #zokuP))) ; PTEN5�}�`��
;;;;;                  (setq #pten5 (car  #pten5$))   ; PTEN5�}�`��
;;;;;                  (setq #kei (nth 1 #xd_PTEN$))  ; ���a
;;;;;                  (setq #o (cdr (assoc 10 (entget #pten5)))) ; ���S�_���W
;;;;;;-- 2011/09/09 A.Satoh Del - S
;;;;;;                  (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"�̉~���쐬����
;;;;;;                  ;// �������g���f�[�^��ݒ�
;;;;;;                  (CFSetXData #dum "G_WTR" (list #zokuP))
;;;;;;                  (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; �������}�`��
;;;;;;-- 2011/09/09 A.Satoh Del - E
;;;;;                  ;// ��������̔z�u
;;;;;                  (setq #ang (nth 2 (CFGetXData &snk-en "G_LSYM"))) ; �z�u�p�x
;;;;;                  (setq #LR  (nth 6 (CFGetXData &snk-en "G_LSYM"))) ; LR����
;;;;;
;;;;;                  ;;; �}�`�����݂��邩�m�F
;;;;;                  (if (= nil (findfile (strcat CG_MSTDWGPATH (nth 6 #fig-qry$) ".dwg")));2008/06/28 YM OK!
;;;;;                    (progn
;;;;;                      (setq #msg (strcat "����}�` : ID=" (nth 6 #fig-qry$) " ������܂���"));2008/06/28 YM OK!
;;;;;;;;                      (CFOutLog 0 nil #msg)
;;;;;;;;                      (CFOutLog 0 nil (strcat "  +�i�Ԗ���:" (nth 0 #fig-qry$)))
;;;;;                      (CFAlertMsg #msg)
;;;;;                      (*error*)
;;;;;                    )
;;;;;                  )
;;;;;                  (setq #ang0 #ang)
;;;;;                  ;// �C���T�[�g
;;;;;                  (command "_insert"
;;;;;                    (strcat CG_MSTDWGPATH (nth 6 #fig-qry$)) ; �i�Ԑ}�`.�}�`ID ;2008/06/28 YM OK!
;;;;;                    #o
;;;;;                    1
;;;;;                    1
;;;;;                    (rtd #ang0)
;;;;;                  )
;;;;;                  (command "_purge" "bl" "*" "N") ; 00/10/17 YM ADD
;;;;;                  (command "_purge" "bl" "*" "N") ; 00/10/17 YM ADD
;;;;;                  (command "_purge" "bl" "*" "N") ; 00/10/17 YM ADD
;;;;;                  (command "_purge" "bl" "*" "N") ; 00/10/17 YM ADD
;;;;;
;;;;;                  (command "_explode" (entlast))
;;;;;                  (setq #ss_dum (ssget "P"))
;;;;;                  (SKMkGroup #ss_dum)
;;;;;                ;;(setq #en (SKC_GetSymInGroup (ssname #ss_dum 0))) ;;  2005/08/03 G.YK DEL
;;;;;                  (setq #en (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD
;;;;;
;;;;;                  ;// �g���f�[�^�̕t��
;;;;;                  (CFSetXData #en "G_LSYM"
;;;;;                    (list
;;;;;                      (nth 6 #fig-qry$)          ;1 :�{�̐}�`ID  ; �i�Ԑ}�`.�}�`�h�c ;2008/06/28 YM OK!
;;;;;                      #o                         ;2 :�}���_
;;;;;                      #ang0                      ;3 :��]�p�x
;;;;;                      &KCode                     ;4 :�H��L��
;;;;;                      &SeriCode                  ;5 :SERIES�L��
;;;;;                      (nth 0 #fig-qry$)          ;6 :�i�Ԗ���                          OK!
;;;;;                      "Z"                        ;7 :L/R �敪
;;;;;                      ""                         ;8 :���}�`ID
;;;;;                      ""                         ;9 :���J���}�`ID
;;;;;                      CG_SKK_INT_SUI             ;10:���iCODE ; 01/08/31 YM MOD 510-->��۰��ى�
;;;;;                      2                          ;11:�����t���O
;;;;;                      0                          ;12:���R�[�h�ԍ�
;;;;;                      (fix (nth 2 #fig-qry$))    ;13:�p�r�ԍ�                          OK!
;;;;;                      0.0                        ;14:���@H
;;;;;                      1                          ;15:�f�ʎw���̗L��
;;;;;                      "A"                        ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
;;;;;                    )
;;;;;                  );_CFSetXData
;;;;;                  (KcSetG_OPT #en) ; �g���ް�"G_OPT"��� 01/02/16 MH ADD
;;;;;                  ; 01/07/17 YM ADD
;;;;;                  (setq #WTRSYM$ (append #WTRSYM$ (list #en)))
;;;;;                )
;;;;;              );_if
;;;;;            );_foreach
;;;;;          )
;;;;;        );_if
;;;;;        (setq #i (1+ #i))
;;;;;      );_repeat
;-- 2011/09/18 A.Satou Mod - E

      ;// �V�X�e���ϐ������ɖ߂�
      (setvar "OSMODE"   #os)
      (setvar "SNAPMODE" #sm)
    )
  );_if
;-- 2011/09/17 A.Satoh Mod - S
;;;;;  (list #WtrHoleEn$ #WTRSYM$) ;// ������(G_WTR)��ʐ}�`,����SYM��Ԃ�

  (if (and (= #kikaku_f T) (/= #cnt 1))
    (setq #kikaku_f nil)
  )

  (list #WtrHoleEn$ #WTRSYM$ #kikaku_f) ;// ������(G_WTR)��ʐ}�`,����SYM��Ԃ�
;-- 2011/09/17 A.Satoh Mod - E
);PKW_PosWTR


;;;<HOM>*************************************************************************
;;; <�֐���>    : PKWTSinkAnaEmbed
;;; <�����T�v>  : WT�}�`,�ݸ����ِ}�`��n����WT�̌��𖄂߂�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000-05-12
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKWTSinkAnaEmbed (
  &WT  ; WT�}�`��
  &SNK ; sink����ِ}�`��
  &flg ; �g���ް��̐��������폜='T
  /
  #HOLE #SNK-XD$ #WT-XD$ #WT_T #setxd$
  #EG #I #WTXD$
#CT_FLG ;2017/01/19 YM ADD
  )

  (setq #SNK-xd$ (CFGetXData &SNK "G_SINK"))
  (setq #hole (nth 3 #SNK-xd$)) ; �ݸ���̈�
  (if (= #hole "")
    (progn
      (CFAlertMsg "\n�V���N��������܂���B")(quit)
    )
    (progn
      (setq #WT-xd$ (CFGetXData &WT "G_WRKT"))
      (setq #WT_T (nth 10 #WT-xd$)) ; WT����

      ; 02/12/06 YM ADD-S ���ݶ̪�Ȃ����19mm��40mm �ݸ�������܂��ĂȂ��悤�ɂ݂���
      (setq #CT_flg    (nth 33 #WT-xd$)) ; ��������׸�(�������ܰ�į�߂ɕύX:1)
      (if (= 1 #CT_flg) ; R�t��������ǂ����ŕ���
        (setq #WT_T 40) ; WT����=40
      );_if
      ; 02/12/06 YM ADD-E ���ݶ̪�Ȃ����19mm��40mm �ݸ�������܂��ĂȂ��悤�ɂ݂���

      ;2008/07/28 YM MOD 2009�Ή�
      (command "_extrude" #hole "" (- #WT_T) ) ;�����o��
;;;     (command "_extrude" #hole "" (- #WT_T) "") ;�����o��
      (command "_union" &WT (entlast) "")        ;�a���Z

      ;// �������̈����������
      (setq #i 23)
      (repeat (nth 22 #WT-xd$) ; �������̌�

        ; 02/04/16 YM MOD-S if���ŕ���
        (if &flg ; ���������ް����폜����
          (progn
            ; #hole��extrude�̂Ƃ�������
            (setq #hole (nth #i #WT-xd$)) ; 02/04/16 YM MOD
          )
          (progn
            (setq #eg (entget (nth #i #WT-xd$)))
            (setq #eg (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (cdr #eg)) (cdr #eg)))
            (setq #eg (subst (cons 62 2) (assoc 62 #eg) #eg))
            (entmake #eg) ; ������а�쐬
            ; #hole��extrude�̂Ƃ������邪�A���̌��}�`�͎c��
            (setq #hole (entlast))
          )
        );_if
        ; 02/04/16 YM MOD-E


        ;2008/07/28 YM MOD 2009�Ή�
        (command "_extrude" #hole "" (- #WT_T) ) ;�����o��
;;;       (command "_extrude" #hole "" (- #WT_T) "") ;�����o��
        (command "_union" &WT (entlast) "")        ;�a���Z
        (setq #i (1+ #i))
      )
      (if &flg
        (progn
          ;;; ���������Ȃ��Ȃ�������
          (setq #setxd$
            (list
              (list 18 0)
              (list 19 "")
              (list 20 "")
              (list 21 "")
              (list 22 0)
              (list 23 "")
              (list 24 "")
              (list 25 "")
              (list 26 "")
              (list 27 "")
              (list 28 "")
              (list 29 "")
            )
          )
          ;// ���[�N�g�b�v�g���f�[�^�̍X�V
          (CFSetXData &WT "G_WRKT"
            (CFModList #WT-xd$ #setxd$)
          )
        )
      );_if
    )
  );_if
  (princ)
);PKWTSinkAnaEmbed

;;;<HOM>*************************************************************************
;;; <�֐���>    : SKW_GetSnkCabAreaSym
;;; <�����T�v>  : �V���N�L���r�l�b�g�̗̈�Ɋ܂܂��V���{���}�`����������
;;; <�߂�l>    :
;;;        LIST : �����A�V���N�}�`�̃��X�g
;;; <�쐬>      : 99-10-19
;;; <���l>      : 00/02/22 YM ���̊֐��́A�ݸ�����������Ă��悢
;;;*************************************************************************>MOH<
(defun SKW_GetSnkCabAreaSym (
  &snkEn          ;(ENAME)�V���N�L���r�l�b�g�}�`��
;;; &w-en           ; WT�}�`��
;;; &w-xd$          ; WT�g���f�[�^
  /
  #pt
  #ang #wid #dep
  #xd$
  #p1 #p2 #p3 #p4
  #one
  #ss
  #retEn$
  #i #SETXD$ #SS_WTR
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKW_GetSnkCabAreaSym ////")
  (CFOutStateLog 1 1 " ")
  (command "vpoint" "0,0,1")  ; 00/04/25 YM
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))

  ;// �g���f�[�^���擾
  (setq #ang (nth 2 (CFGetXData &snkEn "G_LSYM"))) ; �ݸ���ސ}�`���Ɋ֘A YM
  (setq #xd$ (CFGetXData &snkEn "G_SYM"))          ; �ݸ���ސ}�`���Ɋ֘A YM
  (setq #wid (nth 3 #xd$))                         ; �ݸ���ސ}�`���Ɋ֘A YM
  (setq #dep (nth 4 #xd$))                         ; �ݸ���ސ}�`���Ɋ֘A YM

  (setq #p1 (cdr (assoc 10 (entget &snkEn))))      ; �ݸ���ސ}�`���Ɋ֘A YM
  (setq #p2 (polar #p1 #ang #wid))                 ; �ݸ���ސ}�`���Ɋ֘A YM
  (setq #p3 (polar #p2 (- #ang (dtr 90)) #dep))    ; �ݸ���ސ}�`���Ɋ֘A YM
  (setq #p4 (polar #p1 (- #ang (dtr 90)) #dep))    ; �ݸ���ސ}�`���Ɋ֘A YM

  ;// �̈�Ɋ܂܂��A�V���N�A��������������
  (setq #i 0)
  (repeat (sslength #ss) ; #ss �}�ʏシ�ׂĂ� "G_LSYM"�𒲂ׂ�͖̂��ʂ����ݸ�����������Ă��悢 YM
    (setq #pt (cdr (assoc 10 (entget (ssname #ss #i)))))
    (setq #pt (list (car #pt) (cadr #pt))) ; 2D�_�ɕϊ� YM
    (setq #one (CFGetSymSKKCode (ssname #ss #i) 1)) ; ���i���ނP���� YM

    ;// �V���N�A����
    (if (or (= #one CG_SKK_ONE_SNK) (= #one CG_SKK_ONE_WTR)) ; CG_SKK_ONE_SNK=4 , CG_SKK_ONE_WTR=5
      (progn
        ;// �̈�����`�F�b�N
        (if (IsPtInPolygon #pt (list #p1 #p2 #p3 #p4 #p1))
          (setq #retEn$ (cons (ssname #ss #i) #retEn$))
        )
      )
    )
    (setq #i (1+ #i))
  )
  (command "zoom" "p")
  #retEn$
)
;SKW_GetSnkCabAreaSym

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun SKC_ConfSinkChkErr (
    &area1$
    &area2$
    /
    #en$
    #cc
    #pw
  )
  (setq #pw (getvar "PLINEWID"))
  (setq #cc (getvar "CECOLOR"))
  (setvar "PLINEWID" 10)
  (setvar "CECOLOR" "2")
  (MakeLwPolyLine &area1$ 1 0)
  (setq #en$ (cons (entlast) #en$))
  (setvar "CECOLOR" "6")
  (MakeLwPolyLine &area2$ 1 0)
  (command "_.redraw")
  (setvar "PLINEWID" #pw)
  (setvar "CECOLOR" #cc)
  (setq #en$ (cons (entlast) #en$))
)

;;;<HOM>*************************************************************************
;;; <�֐���>     : SKC_GetTopRightBaseCabPt
;;; <�����T�v>   : �x�[�X�L���r�l�b�g�̍ŉE�̍��W�����߂�
;;; <�߂�l>     :
;;; <�쐬>       : 2000.1.24�C��KPCAD
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun SKC_GetTopRightBaseCabPt (
    &scab-en ; �ݸ���ސ}�`��
    /
    #max #ss #i #xd$ #max #maxen #pt #en
    #BASE$ #EN$ #THR
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKC_GetTopRightBaseCabPt ////")
  (CFOutStateLog 1 1 " ")

      (setq #max 0.)

      (if (= &scab-en nil)
        (progn
          (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; "G_LSYM" �����I���Z�b�g�擾  ; ��������Ƃ܂��� 00/02/22 YM
        )
        (progn
        ;// �w�肵���L���r�l�b�g�ɗאڂ���x�[�X�L���r����������         ; ��������Ƃ܂��� 00/02/22 YM ADD
          (setq #en$ (SKW_GetLinkBaseCab &scab-en))                      ; ��������Ƃ܂��� 00/02/22 YM ADD
          ;// �_�C�j���O���ނ��Ȃ�
          (foreach #en #en$                                              ; ��������Ƃ܂��� 00/02/22 YM ADD
            (setq #thr (CFGetSymSKKCode #en 3))                          ; ��������Ƃ܂��� 00/02/22 YM ADD
            (if (and (/= CG_SKK_THR_ETC #thr) (/= CG_SKK_THR_DIN #thr))  ; ��������Ƃ܂��� 00/02/22 YM ADD
              (setq #base$ (cons #en #base$)) ; �}�`��ؽ�                ; ��������Ƃ܂��� 00/02/22 YM ADD
            )
          )                                                              ; ��������Ƃ܂��� 00/02/22 YM ADD
          (setq #ss (CMN_enlist_to_ss #base$)) ; �}�`��-->�I���Z�b�g     ; ��������Ƃ܂��� 00/02/22 YM ADD
        )
      );_if

      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i)) ; �e�}�`��
        (setq #xd$ (CFGetXData #en "G_LSYM")) ; �g���f�[�^�̃f�[�^�����̂�

        ;03/11/15 �޲�ݸނ͏���
;;;        (if (= CG_SKK_TWO_BAS (CFGetSeikakuToSKKCode (nth 9 #xd$) 2)) ; ���iCODE2����=1 --> �ް�
        (if (and (/= CG_SKK_ONE_SID (CFGetSeikakuToSKKCode (nth 9 #xd$) 1)) ;03/11/15 �������ق͏���
                 (=  CG_SKK_TWO_BAS (CFGetSeikakuToSKKCode (nth 9 #xd$) 2)) ; ���iCODE2����=1 --> �ް�
                 (/= CG_SKK_THR_DIN (CFGetSeikakuToSKKCode (nth 9 #xd$) 3)));03/11/15 �޲�ݸނ͏���
          (progn
            (setq #pt (cdr (assoc 10 (entget #en))))
            (if (< #max (car #pt))
              (progn
                (setq #max (car #pt))
                (setq #maxen #en)
              )
            )
          )
        )
        (setq #i (1+ #i))
      )

      (cond
        (T                     ;�k�^
          (setq #xd$ (CFGetXData #maxen "G_SYM"))
          (+ #max (nth 3 #xd$)) ; �V���{����l�v
        )
      );_(cond

);SKC_GetTopRightBaseCabPt

;;;<HOM>*************************************************************************
;;; <�֐���>    : SKW_DelSink
;;; <�����T�v>  : �V���N�E�����̍폜
;;; <�߂�l>    :
;;; <�쐬>      : 1999-10-12
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun SKW_DelSink (
  &WSflg   ; WT�������׸�
  &scab-en ; �ݸ���޼���ِ}�`��
  &w-en    ; WT�}�`��
  &w-xd$   ; "G_WRKT"
  /
  #relEn$
  #en
  #ss #SETXD$
	#EANA #I #WTXD$ ;2017/01/19 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKW_DelSink ////")
  (CFOutStateLog 1 1 " ")

  ;// �V���N�L���r�̗̈�Ɏ��܂��Ă��鐅�������߂�
  (setq #relEn$ (SKW_GetSnkCabAreaSym &scab-en))
;;;  (setq #relEn$ (SKW_GetSnkCabAreaSym &scab-en &w-en &w-xd$))

  (foreach #en #relEn$
    (setq #ss (CFGetSameGroupSS #en))

    (if &WSflg ; �����ߕK�v
      (progn
        (if (= (nth 9 (CFGetXData #en "G_LSYM")) CG_SKK_INT_SNK) ; 01/08/31 YM MOD 410-->��۰��ى�
          (PKWTSinkAnaEmbed &w-en #en T) ; WT�}�`,�ݸ����ِ}�`��n����WT�̌��𖄂߂�
        );_if
      )
      (progn ; �������폜�ɔ���G_WRKT�̏�������

        ; 02/04/17 YM ADD-S �������}�`�n���h�����폜����
        (setq #wtXd$ (CFGetXData &w-en "G_WRKT"))
        (setq #i 23)
        (repeat (nth 22 #wtXd$) ; �������̌�
          (setq #eANA (nth #i #wtXd$))
          (if (/= nil (entget #eANA))
            (entdel #eANA)
          );_if
          (setq #i (1+ #i))
        )
        ; 02/04/17 YM ADD-E

;;;      �ݸ�̈���̐������͑S�č폜--->"G_WRKT"�̕ύX���K�v
        ;// �������֘A�̊g���f�[�^���X�V�ݒ肷��
        (setq #setxd$
          (list
            (list 22 0)
            (list 23 "")
            (list 24 "")
            (list 25 "")
            (list 26 "")
            (list 27 "")
          )
        )
        ;// ���[�N�g�b�v�g���f�[�^�̍X�V
        (CFSetXData
          &w-en
          "G_WRKT"
          (CFModList
            &w-xd$
            #setxd$
          )
        )
      )
    );_if

    (command "_erase" #ss "")
  )
)
;SKW_DelSink

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ChgSink
;;; <�����T�v>  : �V���N�E�����̕ύX
;;; <�߂�l>    :
;;; <�쐬>      : 1999-10-12
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:ChgSink (
  /
  #PD #pdsize
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ChgSink ////")
  (CFOutStateLog 1 1 " ")

  ;// �R�}���h�̏�����
  (StartUndoErr)

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

; 01/06/28 YM ADD ����ނ̐��� Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn

  (CFCmdDefBegin 6);00/09/26 SN ADD
  (setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "PDSIZE" 10)
  (setvar "pdmode" 34)

  ;// �V���N�̔z�u(���̃V���N�A�����͍폜����)
;;;  (SKW_OpPosSink 1) ; 00/04/28 YM
  (SKW_OpPosSink2 1) ; 00/04/28 YM

;;;03/09/29YM@MOD  ;// �\����w�̐ݒ� ; 00/09/18 YM ADD
;;;03/09/29YM@MOD  (command "_layer"
;;;03/09/29YM@MOD    "F"   "*"                ;�S�Ẳ�w���t���[�Y
;;;03/09/29YM@MOD    "T"   "Z_00*"            ;  Z_00���̃\���b�h��w�̃t���[�Y����
;;;03/09/29YM@MOD    "T"   "N_*"              ;  N_*�V���{�����_�}�`��w�̃t���[�Y����
;;;03/09/29YM@MOD    "T"   "M_*"              ;  M_*�ڒn�̈�}�`��w�̉���
;;;03/09/29YM@MOD    "T"   "0"                ;  "0"��w�̉���
;;;03/09/29YM@MOD    "ON"  "M_*"              ;  M_*�ڒn�̈�}�`��w�̕\��
;;;03/09/29YM@MOD    "OFF" "N_B*" ""          ;  N_B*�u���[�N���C���}�`�̔�\��
;;;03/09/29YM@MOD  )
;;;03/09/29YM@MOD  (command "_.layer" "T" "Z_KUTAI" "") ; 01/04/23 YM ADD
  (SetLayer);03/09/29 YM MOD

  (CFCmdDefFinish);00/09/26 SN ADD
  (setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)

  ); 01/06/28 YM ADD ����ނ̐��� Lipple
);_if

  (setq *error* nil)
  (princ)

)
;C:ChgSink

;;;<HOM>*************************************************************************
;;; <�֐���>     : PKC_GetSuisenAnaPt
;;; <�����T�v>   : �ݸ�ɂ��鐅�����̍��WؽĂ����߂�
;;; <�߂�l>     : ���Wؽ�
;;; <�쐬>       : 2000.1.26 YM 00/05/04 &sym �ǉ��C��
;;; <���l>       : 00/10/05 ���� PTEN���ް �ǉ�
;;;*************************************************************************>MOH<
(defun PKC_GetSuisenAnaPt (
  &sym ; �ݸ����ِ}�`��
  &No  ; PTEN���ް
  /
  #EN #I #PT #PT_LIS #SS #XD$ #msg #S-XD$
  )
  (setq #pt_lis '())
  (setq #ss (CFGetSameGroupSS &sym)) ; �ݸ��ٰ�ߐ}�`�I���
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i)) ; �ݸ���ނ̓����ٰ�߂̊e�v�f
    (setq #xd$ (CFGetXData #en "G_PTEN")) ; G_TMEN�g���ް�
    (if #xd$
      (progn ; PTEN������ꍇ
        (if (= (nth 0 #xd$) &No)  ; PTEN?
          (progn ; ���􌊂̏ꍇ
            (setq #pt (cdr (assoc 10 (entget #en))))
            (setq #pt_lis (append #pt_lis (list #pt) ))  ; point�͕��������Ă��c�����̈ʒu�͓���
          );_progn
        );_if
      )
    );_if
    (setq #i (1+ #i))
  );_repeat
  (if (= #pt_lis nil)
    (progn
      (setq #s-xd$ (CFGetXData &sym "G_LSYM")) ; �ݸ����ȯĊg���ް�
      (setq #msg
        (strcat "�V���N �i�Ԗ��� : " (nth 5 #s-xd$) " ��"
        "�r����(P�_)������܂���B\n \nPKGetPTEN_NO"))
      (CFOutStateLog 0 5 #msg)
      (CFAlertMsg #msg)
      (*error*)
    )
  )
  #pt_lis
); PKC_GetSuisenAnaPt

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_CheckExistSuisen
;;; <�����T�v>  : ���������݂����T��Ԃ��Ȃ����nil
;;; <�߂�l>    : T or nil
;;; <�쐬>      : 00/07/17 YM
;;; <���l>      : (ssget "CP" ���g�p���Ă���� vpoint '(0 0 1)���K�v
;;;*************************************************************************>MOH<
(defun PK_CheckExistSuisen (
  &pt ; �߲��
  /
  #I #ONE #P1 #P2 #P3 #P4 #PT$ #RET #SS
  )
  (setq #ret nil)
  (setq #p1 (polar &pt (dtr   45) 1))
  (setq #p2 (polar &pt (dtr  135) 1))
  (setq #p3 (polar &pt (dtr -135) 1))
  (setq #p4 (polar &pt (dtr  -45) 1))
  (setq #pt$ (list #p1 #p2 #p3 #p4 #p1))
  (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_LSYM")))))
  (if #ss
    (if (> (sslength #ss) 0)
      (progn
        (setq #i 0)
        (repeat (sslength #ss)
          (if (= CG_SKK_ONE_WTR (CFGetSymSKKCode (ssname #ss #i) 1)) ; ���i���ނP����
            (setq #ret T)
          );_if
          (setq #i (1+ #i))
        )
      )
    );_if
  );_if
  #RET
);PK_CheckExistSuisen

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_GetWTunderSuisen
;;; <�����T�v>  : ��������WT��Ԃ�
;;; <�߂�l>    : WT�}�`��
;;; <�쐬>      : 00/07/17 YM
;;; <���l>      : (ssget "CP" ���g�p���Ă���� vpoint '(0 0 1)���K�v
;;;*************************************************************************>MOH<
(defun PK_GetWTunderSuisen (
  &pt ; �߲��
  /
  #I #LOOP #PTWT$ #RET #SS #WT #PT
  )
  (setq #pt (list (car &pt) (cadr &pt)))
  (setq #ret nil)
  (setq #ss (ssget "X" (list (list -3 (list "G_WRKT"))))) ; �}�ʏ�S�v�s
  (if (and #ss (> (sslength #ss) 0))
    (progn
      (setq #i 0 #loop T)
      (while (and #loop (< #i (sslength #ss)))
        (setq #WT (ssname #ss #i))
        (setq #ptWT$ (PKGetWT_outPT #WT 1)) ; WT�O�`�_�� ; 01/08/10 YM ADD(�����ǉ�)
        (if (IsPtInPolygon #pt #ptWT$)    ; ���O����
          (setq #ret #WT #loop nil)
        );_if
        (setq #i (1+ #i)) ; 01/04/06 YM ADD ����ٰ�߉���
      )
    )
  );_if
  #ret
);PK_GetWTunderSuisen

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_GetPTEN5byPT
;;; <�����T�v>  : �_�ߖT��PTEN��Ԃ� ����=point���W
;;; <�߂�l>    : PTEN�}�`��(�P�����Ԃ�)
;;; <�쐬>      : 00/07/18 YM
;;; <���l>      : (ssget "CP" ���g�p���Ă���� vpoint '(0 0 1)���K�v
;;;*************************************************************************>MOH<
(defun PK_GetPTEN5byPT (
  &pt ; �߲��
  /
  #I #P1 #P2 #P3 #P4 #PT$ #PTEN #RET #SS #PT #XD$
  )
  (command "_.vpoint" (list 0 0 1))
  (command "_layer" "T" "Z_01*" "")
  (setq #pt (list (car &pt) (cadr &pt))) ; 2D��
  (setq #ret nil)
  (setq #p1 (polar #pt (dtr   45) 4))
  (setq #p2 (polar #pt (dtr  135) 4))
  (setq #p3 (polar #pt (dtr -135) 4))
  (setq #p4 (polar #pt (dtr  -45) 4))
  (setq #pt$ (list #p1 #p2 #p3 #p4 #p1))
  (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_PTEN")))))
  (if #ss
    (if (> (sslength #ss) 0)
      (progn
        (setq #i 0)
        (repeat (sslength #ss)
          (setq #pten (ssname #ss #i))
          (setq #xd$ (CFGetXData #pten "G_PTEN"))
          (if (= 5 (car #xd$))
            (setq #ret (list #pten #xd$))
          );_if
          (setq #i (1+ #i))
        )
      )
    );_if
  );_if
  (command "_layer" "F" "Z_01*" "")
  #RET
);PK_GetPTEN5byPT

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetPlusLinePT
;;; <�����T�v>  : &o�𒆐S�Ɂ{�̐��������Ƃ��̎n�_�A�I�_��Ԃ�
;;; <�߂�l>    : t�_���Wؽ�
;;; <�쐬>      : 2011/07/19 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun GetPlusLinePT (
  &o ; 3D�߲��
  /
  #O1 #O2 #O3 #O4 #X #Y #Z
  )
  (setq #x (nth 0 &o))
  (setq #y (nth 1 &o))
  (setq #z (nth 2 &o))
  (setq #o1 (list (- #x 50) #y #z))
  (setq #o2 (list (+ #x 50) #y #z))
  (setq #o3 (list #x (+ #y 50) #z))
  (setq #o4 (list #x (- #y 50) #z)) 
  (list #o1 #o2 #o3 #o4)
);GetPlusLinePT

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcSetWaterTap
;;; <�����T�v>  : ����ݒu����
;;; <�߂�l>    : �ݒu�����}�`��
;;; <�쐬>      : 00/06/01 MH
;;;               00/07/17 YM ADD "G_WTR"�ǉ��Ȃ�
;;; <���l>      : ���􌊈ʒu�ɕW�_�\�����X�i�b�v����
;;;*************************************************************************>MOH<
(defun PcSetWaterTap (
  &selPT$     ; �ݔ����ނ̏��
  /
  #DIS #DPT #DUM$ #EN #ENS #ENSNK$ #I #II #KEI #O #OK #OMD #PMD #PSZ
  #PT$ #PTEN5 #PTEN5$ #SNK_ANA #SS #SSWT
  #WORKP$ #XD_PTEN5 #XD_PTEN5$ #ZOKUP #loop #WT
;-- 2011/09/09 A.Satoh Mod - S
;  #ANA #KOSU #SETXD$ #W-XD$ #ANA_layer #ret$
  #KOSU #SETXD$ #W-XD$ #ANA_layer #ret$
;-- 2011/09/09 A.Satoh Mod - E
  #sH         ; ����������
  #fH         ; ����
  #tSEKISAN   ; �ώZF=1==>T 01/09/03 YM ADD
#O1 #O2 #O3 #O4 #SNAP #UNIT ;2017/01/19 YM ADD
  )
  (setq #enSNK$ nil #workP$ nil #pten5$ nil #xd_pten5$ nil)
  ;// �R�}���h�̏�����
  (StartUndoErr)

  ; 01/09/03 YM ADD-S �����̐ώZF����������
  (setq #tSEKISAN (KP_GetSekisanF (nth 0 &selPT$)))
  ; 01/09/03 YM ADD-E �����̐ώZF����������

  ;�ƯċL���擾 ;06/08/23 YM ADD-S
  (setq #unit (KPGetUnit))
  ;�ƯċL���擾 ;06/08/23 YM ADD-E

  ; ���݂�O�X�i�b�v�A�_���[�h�A �_�T�C�Y �擾
  (setq #oMD (getvar "OSMODE"))
;;;2011/07/19YM@DEL  (setq #pSZ (getvar "PDSIZE"))
;;;2011/07/19YM@DEL  (setq #pMD (getvar "PDMODE"))

;;;01/06/26YM@  ; �S�V���N�}�`�擾
;;;01/06/26YM@  (setq #ss (ssget "X" '((-3 ("G_SINK")))))
;;;01/06/26YM@
;;;01/06/26YM@  (if (or (= #ss nil)(= (sslength #ss) 0))
;;;01/06/26YM@    (progn
;;;01/06/26YM@      (CFAlertMsg "�}�ʏ�ɃV���N������܂���B")
;;;01/06/26YM@      (quit)
;;;01/06/26YM@    )
;;;01/06/26YM@  );_if

  (setq #ret$ (KPGetPTEN 5)) ; 01/06/27 YM �֐���
  (setq #pten5$    (car  #ret$)) ; PTEN5�}�`ؽ�
  (setq #xd_pten5$ (cadr #ret$)) ; "G_PTEN"ؽ�


;;;01/06/26YM@  ;// �V���N�ɐݒ肳��Ă��鐅����t���_�i�o�_=�T�j�̏����擾����
;;;01/06/26YM@  (setq #i 0)
;;;01/06/26YM@  (repeat (sslength #ss)
;;;01/06/26YM@    (setq #enS (ssname #ss #i))
;;;01/06/26YM@    (setq #dum$ (PKGetPTEN_NO #enS 5)) ; �߂�l(PTEN�}�`,G_PTEN)��ؽĂ�ؽ�
;;;01/06/26YM@    (setq #pten5$    (append #pten5$    (mapcar 'car  #dum$))) ; PTEN5�}�`
;;;01/06/26YM@    (setq #xd_pten5$ (append #xd_pten5$ (mapcar 'cadr #dum$))) ; "G_PTEN"
;;;01/06/26YM@    (setq #i (1+ #i))
;;;01/06/26YM@  )

;;; �擾���ꂽP�_�̍��W�ɉ��_��ł�
  (foreach #pten5 #pten5$
    (setq #o (cdr (assoc 10 (entget #Pten5))))

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
;;;    (entmake
;;;      (list
;;;        (cons   0 "POINT")
;;;        (cons 100 "AcDbEntity")
;;;        (cons 100 "AcDbPoint")
;;;        (cons  10 #o)
;;;        (cons  62 1)
;;;      )
;;;    )

;;;    (setq #workP$ (append #workP$ (list (entlast)))) ; ���_�}�`ؽ�(��ō폜�����)
  );_foreach

    (setvar "OSMODE" 32)
;;;2011/07/19YM@DEL  (setvar "OSMODE"   8)
;;;2011/07/19YM@DEL  (setvar "PDSIZE" 100)
;;;2011/07/19YM@DEL  (setvar "PDMODE"  35)

;;; �z�u�_�擾(���[�U�[�ɐ}���o�����Ċp�x��t��������)
  (setq #OK T #loop T)

  ; 02/07/10 YM ADD-S �ů��Ӱ��OFF
  (setq #snap (getvar "SNAPMODE"))
  (setvar "SNAPMODE" 0)

  (while #OK

    (if (= #unit "T");�u�Ƌ�v�������ꍇ ;06/08/23 YM
      (setq #dPT (getpoint "\n����̐ݒu�_���w��: \n"))
      (setq #dPT (getpoint "\n�����̐ݒu�_���w��: \n"))
    );_if

    (setq #i 0)
    (while (and #loop (< #i (length #pten5$)))
      (setq #o (cdr (assoc 10 (entget (nth #i #Pten5$)))))
      (setq #dis (distance #o #dPT))
      (if (< #dis 0.1)
        (setq #ii #i #OK nil #loop nil) ; ���Ԗڂ�PTEN5���H
      );_if
      (setq #i (1+ #i))
    );_foreach

    ; 01/05/24 HN S-MOD �������ȊO�ɂ��z�u�\�ɕύX
    ;@MOD@(if #OK ; PTEN���I�����Ȃ�����
    ;@MOD@  (progn
    ;@MOD@    (setq #loop T) ; ���蒼��
    ;@MOD@    (CFAlertMsg "�o�_��ɔz�u���ĉ������B")
    ;@MOD@  )
    ;@MOD@);_if
    (if #OK ; PTEN���I�����Ȃ�����
      (progn

        (if (= #unit "T");�u�Ƌ�v�������ꍇ ;06/08/23 YM
          (CFAlertMsg "����z�u�����Ȃ��ʒu�ɐݒu���܂�.")
          (CFAlertMsg "���������Ȃ��ʒu�ɐݒu���܂�.")
        );_if

        ; ���[�N�g�b�v������z�u�ʒu�̂y�l�Ƃ���
        ; 01/06/12 HN S-MOD �����擾������ύX
        ;@MOD@(setq #rec$
        ;@MOD@  (CFGetDBSQLRecChk CG_DBSESSION "SK�����l"
        ;@MOD@    (list
        ;@MOD@      (list "����ID" "PLAN31"    'STR)
        ;@MOD@      (list "�����l" CG_WTHeight 'STR)
        ;@MOD@    )
        ;@MOD@  )
        ;@MOD@)
        ;@MOD@(setq #fH (getreal (strcat "����<" (nth 4 #rec$) ">: ")))
        ;@MOD@(if (= nil #fH)
        ;@MOD@  (setq #fH (atof (nth 4 #rec$)))
        ;@MOD@)
        (setq #sH (KCFGetWTHeight))
        (if (= #sH nil)(setq #sH "0")) ; 01/06/26 YM ADD �}�ʂɉ����Ȃ��Ƃ�#sH=nil�ŗ�����
        (setq #fH (getreal (strcat "����<" #sH ">: ")))
        (if (= nil #fH)
          (setq #fH (atof #sH))
        )
        ; 01/06/12 HN E-MOD �����擾������ύX

        (setq #dPT (list (car #dPT) (cadr #dPT) #fH))
        (setq #OK nil)
      )
    );_if
    ; 01/05/24 HN E-MOD �������ȊO�ɂ��z�u�\�ɕύX

    (if (= #OK nil) ; �o�_���I�������ꍇ
      (if (setq #OK (PK_CheckExistSuisen #dPT)) ; ���������݂����T��Ԃ�
        (progn
          (setq #loop T) ; ���蒼��

          (if (= #unit "T");�u�Ƌ�v�������ꍇ ;06/08/23 YM
            (CFAlertMsg "���Ɉ��肪���݂��܂��B")
            (CFAlertMsg "���ɐ��������݂��܂��B")
          );_if

        )
      );_if
    );_if
  )

  ; 02/07/10 YM ADD-S �ů��Ӱ��OFF
  (setvar "SNAPMODE" #snap)

  ;;; ���X�g�̓_�폜
  (foreach #P #workP$ (entdel #P))

  (if #ii     ; 01/05/24 HN MOD �������ȊO�ɂ��z�u�\�ɕύX
    (progn
      ; ���쐬 & "G_WTR"�̾��
      (setq #xd_pten5 (nth #ii #xd_pten5$)) ; "G_PTEN"
      (setq #kei      (nth   1 #xd_pten5 )) ; ���a
      (setq #zokuP    (nth   2 #xd_pten5 )) ; ����
      (setq #pten5    (nth #ii #pten5$   )) ; PTEN5
      (setq #o (cdr (assoc 10 (entget #pten5))))

      ; ��������Łu�����v�Ȃ��̏ꍇ 01/01/15 YM ADD
      ;;;  (setq #ANA_layer "Z_00_00_00_01" ) ; �ڂɌ�����
      (setq #ANA_layer SKW_AUTO_SECTION) ; �ڂɌ����Ȃ�

;-- 2011/09/09 A.Satoh Del - S
;;;;01/09/03YM@MOD      (setq #ana (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"�̉~���쐬����
;
;
;     ; 01/09/03 YM MOD-S
;;;;      (if #tSEKISAN ;06/08/23 YM MOD
;     (if (or #tSEKISAN (= #unit "T"));�ώZF=1�܂��́u�Ƌ�v�������ꍇ
;       nil ; �ώZF=1�Ȃ琅��������}���Ȃ�
;       (setq #ana (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"�̉~���쐬����
;     );_if
;     ; 0/09/03 YM MOD-E
;
;-- 2011/09/09 A.Satoh Del - E
    )
  ) ;_if 01/05/24 HN MOD �������ȊO�ɂ��z�u�\�ɕύX

  ; ����ݒu���s
  (setq #en (PcInsSuisen&SetX #dPT &selPT$ #tSEKISAN)) ; �ݒu��������}�`�� 01/09/03 YM MOD ����#ana�폜,�ώZF#tSEKISAN�ǉ�
;;;01/09/03YM@MOD  (setq #en (PcInsSuisen&SetX #dPT #ana &selPT$)) ; �ݒu��������}�`��

  (if #ii     ; 01/05/24 HN MOD �������ȊO�ɂ��z�u�\�ɕύX
    (progn
      ;;; PTEN5 �̐e�}�`(=�ݸ�}�`)���擾
      ;;; (setq #SNK (SearchGroupSym #pten5))

      (command "vpoint" "0,0,1")            ; �K�v���� 01/03/13 YM
      (setq #WT (PK_GetWTunderSuisen #dPT)) ; �������̂v�s��Ԃ�
      (command "zoom" "p")                  ; �K�v���� 01/03/13 YM

      ; 01/03/13 MH DEL �m���WT�ݒu��
      ;(if (CFGetXData #WT "G_WTSET")
      ;  (progn
      ;    (CFAlertMsg "���[�N�g�b�v���i�Ԋm�肳��Ă��܂��B\n������z�u�ł��܂���B")
      ;    (quit)
      ;  )
      ;);_if

;;;01/09/03YM@MOD     (if #WT ; 01/06/26 YM ADD WT���Ȃ��Ƃ�������
      (if (and #WT (= #tSEKISAN nil)) ; 01/09/03 YM MOD
        (progn ; WT�����݂��Đ������ώZF=1�łȂ��Ƃ�
;-- 2011/09/09 A.Satoh Del - S
;
;         ;// �������g���f�[�^��ݒ�
;         ;;;  (CFSetXData #ana "G_WTR" (list #zokuP #WT #SNK)) ; 07/17 YM WT�}�`��,�ݸ�}�`����ADD
;         (regapp "G_WTR") ; 00/08/09 MH ADD
;         (CFSetXData #ana "G_WTR" (list #zokuP))
;         ;;; #ana ��"G_WRKT"�ɒǉ�����
;-- 2011/09/09 A.Satoh Del - E
         (setq #w-xd$ (CFGetXData #WT "G_WRKT"))
;-- 2011/09/09 A.Satoh Del - S
;         (setq #i 23 #dum$ nil)
;         (repeat (nth 22 #w-xd$)
;           (if (/= (nth #i #w-xd$) "")
;             (if (entget (nth #i #w-xd$)); �����Ȑ}�`���łȂ�
;               (setq #dum$ (append #dum$ (list (nth #i #w-xd$))))
;             ) ;_if
;           ) ;_if
;           (setq #i (1+ #i))
;         ) ;_repeat
;
;         (setq #kosu (1+ (length #dum$)))        ; 1���₷
;         (setq #dum$ (append #dum$ (list #ana))) ; �z�u����������ǉ�
;
;         (if (> 7 (length #dum$))                ; �������͂V�܂�
;           (repeat (- 7 (length #dum$)) (setq #dum$ (append #dum$ (list ""))))
;         ) ;_if
;-- 2011/09/09 A.Satoh Del - E

          (setq #setxd$
            (list
;-- 2011/09/09 A.Satoh Mod - S
;             (list 22 #kosu)
;             (list 23 (nth 0 #dum$))
;             (list 24 (nth 1 #dum$))
;             (list 25 (nth 2 #dum$))
;             (list 26 (nth 3 #dum$))
;             (list 27 (nth 4 #dum$))
;             (list 28 (nth 5 #dum$))
;             (list 29 (nth 6 #dum$))
              (list 22 0)
              (list 23 "")
              (list 24 "")
              (list 25 "")
              (list 26 "")
              (list 27 "")
              (list 28 "")
              (list 29 "")
;-- 2011/09/09 A.Satoh Mod - E
            )
          )
          ;// ���[�N�g�b�v�g���f�[�^�̍X�V
          (CFSetXData #WT "G_WRKT"
            (CFModList #w-xd$ #setxd$)
          )
          ; �i�Ԋm�肳��Ă����琅�����J������ 01/03/14 YM ADD
          (if (CFGetXData #WT "G_WTSET")
            (PKW_MakeHoleWorkTop2 #WT nil nil)
          ) ;_if

        ) ; 01/06/26 YM ADD WT���Ȃ��Ƃ�������
;-- 2011/09/09 A.Satoh Del - S
;
;       ; 02/07/10 YM ADD-S
;       (progn
;         (if (and #ana (entget #ana))
;           (entdel #ana)
;         );_if
;       )
;       ; 02/07/10 YM ADD-E
;
;-- 2011/09/09 A.Satoh Del - E
      );_if

    )
  ) ;_if  01/05/24 HN MOD �������ȊO�ɂ��z�u�\�ɕύX

  ; O�X�i�b�v�A�_���[�h�A �_�T�C�Y �����ɖ߂�
  (setvar "OSMODE" #oMD)
;;;2011/07/19YM@DEL  (setvar "PDSIZE" #pSZ)
;;;2011/07/19YM@DEL  (setvar "PDMODE" #pMD)
  (setq *error* nil)

  (if (= #unit "T");�u�Ƌ�v�������ꍇ ;06/08/23 YM
    (princ "\n�����z�u���܂����B")
    (princ "\n������z�u���܂����B")
  );_if

  #en
) ;_PcSetWaterTap

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPGetPTEN
;;; <�����T�v>  : �}�ʏ�ɑ��݂���A�����̔ԍ���PTEN���擾
;;; <�߂�l>    : (PTEN�}�`ؽ�,PTEN Xdataؽ�)
;;; <�쐬>      : 2011/07/19 YM ADD
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KPGetPTEN (
  &pten_no ;INT
  /
  #DUM$ #I #PTEN #PTEN$ #SSPTEN #XD_PTEN$
  )
  ; 01/06/26 YM �ݸ�����݂��Ȃ��Ă�����z�u�\�ɂ���
  (setq #ssPTEN (ssget "X" '((-3 ("G_PTEN")))))
  
  (if (and #ssPTEN (< 0 (sslength #ssPTEN)))
    (progn ; �}�ʏ��PTEN�������
      (setq #i 0)
      (repeat (sslength #ssPTEN)
        (setq #PTEN (ssname #ssPTEN #i))
        (setq #dum$ (CFGetXData #PTEN "G_PTEN"))
        (if (= (car #dum$) &pten_no)
          (progn
            (setq #pten$    (append #pten$    (list #PTEN))) ; PTEN�}�`
            (setq #xd_pten$ (append #xd_pten$ (list #dum$))) ; "G_PTEN"
          )
        );_if
        (setq #i (1+ #i))
      );repeat
    )
  );_if
  (list #pten$ #xd_pten$)
);KPGetPTEN

;;;<HOM>************************************************************************
;;; <�֐���>  : PcInsSuisen&SetX
;;; <�����T�v>: �}�`��}���A�g���f�[�^�ݒu�i���t�@�C�����ʁj
;;; <�߂�l>  : #en
;;; <�쐬>    : 00/03/27 MH
;;; <���l>    : �p�x��nil�l�œn���Ă�����A�����Ń��[�U�[�ɓ��͂�����B
;;;************************************************************************>MOH<
(defun PcInsSuisen&SetX (
  &bPT
;;;01/09/03YM@MOD  &ana    ; "G_WTR" ������(�����̸�ٰ�߂ɓ����)
  &selPT$
  &tSEKISAN ; �ώZF=1===>T ����ȊOnil 01/09/03 YM ADD �����ǉ�
  /
  #EN #FANG #OS #S #SFNAME #SS
  )
  (setq #s  (getvar "SNAPMODE"))
  (setvar "SNAPMODE" 0)
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)

  ;;; �}���}�`�I��
  (setq #sFNAME (strcat (cadr &selPT$) ".dwg"))
  (Pc_CheckInsertDwg #sFNAME CG_MSTDWGPATH)
  (command "_insert" (strcat CG_MSTDWGPATH #sFNAME) &bPT 1 1)
  (princ "\n�z�u�p�x: ")
  (command pause)
  (setq #fANG (cdr (assoc 50 (entget (entlast)))))

  ;;; ����
  (command "_explode" (entlast))
  (setq #ss (ssget "P"))
;;;  (ssadd &ana #ss) ; "G_WTR" ������(�����̸�ٰ�߂ɓ����)
  (SKMkGroup #ss)  ;���������}�`�Q�Ŗ��O�̂Ȃ��O���[�v�쐬
  (setq #en (SearchGroupSym (ssname #ss 0)))
  (SKY_SetXData_ &selPT$ #en &bPT #fANG &tSEKISAN) ; 01/09/03 YM ADD
  (PcChgH_GSYM #en &bPT)
  (command "_layer" "on" "M_*" "")
  (setvar "SNAPMODE" #s)
  (setvar "OSMODE" #os)
  #en
);PcInsSuisen&SetX


;;;<HOM>*************************************************************************
;;; <�֐���>    : SKW_GetSinkInfoN
;;; <�����T�v>  : �V���N���A���������A������ޏ����擾���� �ݸ�̑I���޲�۸�
;;; <�߂�l>    :
;;;      (LIST) : 1.WT�V���N���R�[�h
;;;               2.WT���������R�[�h
;;;               3.SK�����l���R�[�h(����)
;;; <�쐬>      : 00/05/02 YM �C�� 00/12/02 YM SINK�Ǘ�,SINK�ʒu������
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun SKW_GetSinkInfoN (
  &XD_WRKT ; "G_WRKT"�g���ް�
  &CAB     ; ����ȯĐ}�`��
  &ZaiCode ; �ގ�
  &ZaiF    ; �f��F
	&w-en    ;-- 2012/04/20 A.Satoh Add �V���N�z�u�s��Ή�
  /
;-- 2011/09/15 A.Satoh Mod - S
;  #ERRFLG #FLG #I #MSG #NAME$ #NAME$$ #RET$ #SCAB_HIN #SINK$ #SINK$$
;  #SINK_KAN$$ #SNK_K #SNK_KG #SNK_LR #SNK_SYM #SQL #TYPE1CODE #XD_SNK$ #ZAICODE
;  #QRY$ #dum$
  #Errflg #msg #SNK_sym #xd_SNK$ #SCAB_HIN #SNK_LR
  #sink$ #OKU #idx #sink #name$$ #name$ #ret$
  #sink_KAN1$$ #sink_KAN1$ #sink_KAN1 #sink1$
  #sink_KAN2$$ #sink_KAN2$ #sink_KAN2 #sink2$
  #sink_KAN3$$ #sink_KAN3$ #sink_KAN3 #sink3$
  #qry$$ #qry$
;-- 2011/09/15 A.Satoh Mod - E
#SNK_DEP #SQL ;2017/01/19 YM ADD
  )

;-- 2011/09/15 A.Satoh Mod - S
;  (setq #Errflg nil #sink_KAN$$ nil #sink$$ nil #name$$ nil)
  (setq #Errflg nil
        #sink_KAN1$$ nil
        #sink_KAN2$$ nil
        #sink_KAN3$$ nil
        #name$$      nil
        #sink$       nil
        #sink1$      nil
        #sink2$      nil
        #sink3$      nil
  )
;-- 2011/09/15 A.Satoh Mod - E

  (setq #SNK_sym (SearchGroupSym &CAB)) ; �ݸ����ȯĐe�}�`��
  (setq #xd_SNK$ (CFGetXData #SNK_sym "G_LSYM"))
  (setq #SCAB_HIN (nth 5 #xd_SNK$)) ; �i�Ԗ���
  (setq #SNK_LR   (nth 6 #xd_SNK$)) ; LR�敪(�ݸ����ȯ�)

;2011/09/14 YM
;----------------------------------------------------------------------------------------------------
;;; �ݸ���ޕi�Ԃ���ySINKCAB�Ǘ��z����
  (setq #sink_KAN1$$
    (CFGetDBSQLRec CG_DBSESSION "SINKCAB�Ǘ�"
			;2012/05/28 YM MOD-S
;;;      (list (list "�i�Ԗ���" (KP_DelHinbanKakko #SCAB_HIN) 'STR)) ; �i�Ԃ�()���O��
      (list (list "�i�Ԗ���" #SCAB_HIN 'STR)) ; �i�Ԃ�()���O��
			;2012/05/28 YM MOD-E
    )
  )
  ;;; �װ����
  (if (and #sink_KAN1$$ (= 1 (length #sink_KAN1$$)))
    (progn
      (setq #sink_KAN1$ (car #sink_KAN1$$))
      (setq #sink_KAN1 (nth 2 #sink_KAN1$))
      (setq #sink1$ (strparse #sink_KAN1 ","))
    )
    (progn
      (setq #msg (strcat "�wSINKCAB�Ǘ��x��ں��ނ�����܂���B\n�ݸ����ȯĕi�Ԗ���=" #SCAB_HIN ))
      (CFAlertMsg #msg)
      (setq #Errflg T)
    )
  );_if
;----------------------------------------------------------------------------------------------------
;;; �ގ�����ySINK�ގ��Ǘ��z����
;;;  (setq #sink_KAN2$$
;-- 2011/09/15 A.Satoh Add - S
  (if (= #Errflg nil)
    (progn
      (setq #sink_KAN2$$
        (CFGetDBSQLRec CG_DBSESSION "SINK�ގ��Ǘ�"
          (list (list "�ގ��L��" &ZaiCode 'STR))
        )
      )

      (if (and #sink_KAN2$$ (= 1 (length #sink_KAN2$$)))
        (progn
          (setq #sink_KAN2$ (car #sink_KAN2$$))
          (setq #sink_KAN2 (nth 3 #sink_KAN2$))
          (setq #sink2$ (strparse #sink_KAN2 ","))
        )
        (progn
          ; �װ����
          (setq #msg (strcat "�wSINK�ގ��Ǘ��x��ں��ނ�����܂���B\n�ގ��L��=" &ZaiCode))
          (CFAlertMsg #msg)
          (setq #Errflg T)
        )
      )
    )
  )
;-- 2011/09/15 A.Satoh Add - E
;----------------------------------------------------------------------------------------------------
;;; ���s����ySINK���s�Ǘ��z����
;;;  (setq #sink_KAN3$$
;-- 2011/09/15 A.Satoh Add - S
  (if (= #Errflg nil)
    (progn
      ; ���s�������߂�
;-- 2012/04/20 A.Satoh Mod �V���N�z�u�s��Ή� - S
;;;;;      (setq #qry$$
;;;;;        (CFGetDBSQLRec CG_DBSESSION "���s"
;;;;;          (list
;;;;;            (list "���s" (itoa (fix (+ (car (nth 57 &XD_WRKT)) 0.01))) 'INT)
;;;;;          )
;;;;;        )
;;;;;      )
			(setq #snk_dep (nth 39 &XD_WRKT))
			(if (or (= #snk_dep 0.0) (= #snk_dep nil))
				(progn
					(setq #snk_dep (getSinkDep &w-en))
					(if (or (= #snk_dep 0.0) (= #snk_dep nil))
						(setq #snk_dep 0.0)
					)
				)
			)
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "���s"
          (list
            (list "���s" (itoa (fix (+ #snk_dep 0.01))) 'INT)
          )
        )
      )
;;(princ "\n#snk_dep = ")(princ #snk_dep)
;;(princ "\n#qry$$ = ")(princ #qry$$)(princ)
;-- 2012/04/20 A.Satoh Mod �V���N�z�u�s��Ή� - E
      (if (and #qry$$ (= 1 (length #qry$$)))
        (progn
          (setq #qry$ (nth 0 #qry$$))
          (setq #OKU (nth 1 #qry$))
        )
        (setq #OKU "?")
      )

      (setq #sink_KAN3$$
        (CFGetDBSQLRec CG_DBSESSION "SINK���s�Ǘ�"
          (list (list "���s" #OKU 'STR))
        )
      )

      (if (and #sink_KAN3$$ (= 1 (length #sink_KAN3$$)))
        (progn
          (setq #sink_KAN3$ (car #sink_KAN3$$))
          (setq #sink_KAN3 (nth 2 #sink_KAN3$))
          (setq #sink3$ (strparse #sink_KAN3 ","))
        )
        (progn
          ; �װ����
          (setq #msg (strcat "�wSINK���s�Ǘ��x��ں��ނ�����܂���B\n���s=" #OKU))
          (CFAlertMsg #msg)
          (setq #Errflg T)
        )
      )
    )
  )
;-- 2011/09/15 A.Satoh Add - E
;----------------------------------------------------------------------------------------------------

;-- 2011/09/15 A.Satoh Mod - S
;(setq #sink$ #sink1$);�b��ݸ�L��ؽ�
  ; �ySINKCAB�Ǘ��z�ySINK�ގ��Ǘ��z�ySINK���s�Ǘ��z���璊�o�����V���N���X�g�ɂ��
  ; �S�Ẵe�[�u���ɑ��݂���V���N�̃��X�g���쐬����
  (if (= #Errflg nil)
    (progn
      (setq #idx 0)
      (repeat (length #sink1$)
        (setq #sink (nth #idx #sink1$))
        (if (and (member #sink #sink2$) (member #sink #sink3$))
          (setq #sink$ (append #sink$ (list #sink)))
        )
        (setq #idx (1+ #idx))
      )
    )
  )
;-- 2011/09/15 A.Satoh Mod - E

;2011/09/14 YM
;���ݸ�e���ؽĂ��v��Ȃ��̂ŁySINK�ʒu�zð��ق͕s�v
;���ݸ���ނ̒��S�ɼݸ��z�u����̂ŁA�t�ɼݸ�e�����߂ĕ\�����Aհ�ް����C���ł���悤�ɂ���

;;; 2011/09/14YM@DEL  (if (= #Errflg nil)
;;; 2011/09/14YM@DEL    (progn
;;; 2011/09/14YM@DEL      (setq #i 2 #flg T)
;;; 2011/09/14YM@DEL      (while (and #flg (< #i 15));04/06/16 YM MDO
;;; 2011/09/14YM@DEL        (setq #snk_K (nth #i (car #sink_KAN$$))) ; �ݸ�L��
;;; 2011/09/14YM@DEL        (if (= #snk_K nil)
;;; 2011/09/14YM@DEL          (setq #flg nil)
;;; 2011/09/14YM@DEL          (progn
;;; 2011/09/14YM@DEL            ;;; SINK�ʒu����
;;; 2011/09/14YM@DEL            (setq #sink$
;;; 2011/09/14YM@DEL              (CFGetDBSQLRec CG_DBSESSION "SINK�ʒu"
;;; 2011/09/14YM@DEL                (list
;;; 2011/09/14YM@DEL                  (list "�V���N�L��" #snk_K 'STR)
;;; 2011/09/14YM@DEL                )
;;; 2011/09/14YM@DEL              )
;;; 2011/09/14YM@DEL            )
;;; 2011/09/14YM@DEL            (setq #sink$ (DBCheck #sink$ "�wSINK�ʒu�x" (strcat "\n�ݸ�L��=" #snk_K))) ; nil or ������ �װ
;;; 2011/09/14YM@DEL            (setq #sink$$ (append #sink$$ (list #sink$)))
;;; 2011/09/14YM@DEL          )
;;; 2011/09/14YM@DEL        );_if
;;; 2011/09/14YM@DEL        (setq #i (1+ #i))
;;; 2011/09/14YM@DEL      );_while
;;; 2011/09/14YM@DEL    )
;;; 2011/09/14YM@DEL    (progn ; "SINK�Ǘ�" �����װ
;;; 2011/09/14YM@DEL      ;;; SINK�ʒu����(�Sں��ގ擾)
;;; 2011/09/14YM@DEL      (setq #sql "select * from SINK�ʒu")
;;; 2011/09/14YM@DEL      (setq #sink$$ (DBSqlAutoQuery CG_DBSession #sql))
;;; 2011/09/14YM@DEL    )
;;; 2011/09/14YM@DEL  );_if

;2011/09/14 YM
;��#sink_KAN1$$�`#sink_KAN3$$�@�ōi�荞��,�ݸ�L����ؽ� = #sink$ ��ٰ�߂��āyWT�V���N�z����������
  (if #sink$
    (progn
      (foreach #sink #sink$
        (setq #name$
          (CFGetDBSQLRec CG_DBSESSION "WT�V���N"
            (list
              (list "�V���N�L��" #sink 'STR)
            )
          )
        )
        (setq #name$ (DBCheck #name$ "�wWT�V���N�x" (strcat "�V���N�L��=" #sink))) ; nil or ������ �װ
        (setq #name$$ (append #name$$ (list #name$))) ; WT�V���N���R�[�h���� ؽĕ\���p
      )
    )
    (progn
;2016/02/18 YM ADD �װ���S���\��
      (setq #msg (strcat "SINK��₪����܂���B" "�SSINK��\�����܂��B" ))

;2016/02/18 YM ADD �װ���S���\��
      (CFAlertMsg #msg)
;;;      (quit)
			(setq #sql (strcat "select * from WT�V���N"))
		  (setq #name$$ (DBSqlAutoQuery CG_DBSESSION #sql))
    )
  );_if

;;; �ݸ�̑I���޲�۸�
;-- 2011/09/14 A.Satoh Mod - S
;;;;; ;2011/09/14 YM MOD-S
;;;;;;;;  (setq #ret$ (KPSelectSinkDlg &XD_WRKT &ZaiF #SNK_LR #sink$$ #name$$))
;;;;;  (setq #ret$ (KPSelectSinkDlg &XD_WRKT &ZaiF #SNK_LR #sink$ #name$$));��#sink$$�̑����#sink$(�ݸ�L���̂�)
;;;;; ;2011/09/14 YM MOD-E

;;;	(CFAlertMsg "���i�Q�j�� ��PG���C�� KPSelectSinkDlg�y�V���N�I����ʁzERRMSG.INI�����ɍs��") ;2017/01/19 YM ADD

  (setq #ret$ (KPSelectSinkDlg &XD_WRKT &ZaiF #SNK_LR #sink$ #name$$ &CAB))
;-- 2011/09/14 A.Satoh Mod - E

;;;  �߂�l #ret$ (list #sink$ #name$ #SNK_DIM #LR #sui$ #plis$)
;;; 0:�I�����ꂽ"SINK�ʒu" ں���
;;; 1:�I�����ꂽ"WT�V���N" ں���
;;; 2:�I�����ꂽ�ݸ�e���@
;;; 3:�I�����ꂽ�ݸ����LRZ
;;; 4:�I�����ꂽ"WT������" ں���
;;; 5:�I�����ꂽ"WT������" ں��� (���� -2,-1,0,1,2 �̏�) nil ����
  #ret$
);SKW_GetSinkInfoN

;;;<HOM>*************************************************************************
;;; <�֐���>     : PKC_LayoutSink
;;; <�����T�v>   : �v���������y�V���N�����z�u�z
;;; <�߂�l>     : 
;;; <�쐬>       : 2000.1.27 @YM@
;;; <���l>       :  ����WT�̐S�z ���݌����Ȃ̂� OK!
;;;*************************************************************************>MOH<
(defun PKC_LayoutSink (
  /
  #ANAQRY$ #ANG #AREA$ #D-OFF #D-VCT #DIMW2 #DWG #EN #EN$ 
  #FIG$ #FIG1$ #FIGID #GRP #H #H-NO #HINBAN #I #LISTCODE #LOOP #LR #LR_EXIST 
  #M1-WID #MOVE #P-EN1 #P-EN2 #P-SS #POS #PT #PT$ #PT_LIS #PT_SUISEN #QRY$ #RET 
  #SEIKAKU #SNK-EN #SS #SS_DUM #SS_SNK #SYM #W-OFF #WK-THK #WTRHOLECODE #XD$ #Y_SUISEN #ZAIF
  #SPLAN #YNO #HH #LIST$$ #MSG #QRY_CHG$ #QRY_CHG$$ #QRY_OFF$ #QRY_OFF$$ #sink_hinban
  )
  (setq CG_SINK nil)

  (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; ���݌����Ȃ̂� OK!
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i))
    (setq #xd$ (CFGetXData #en "G_LSYM"))
    (if (= CG_SKK_THR_SNK (CFGetSeikakuToSKKCode (nth 9 #xd$) 3)) ; ���iCODE��3����=2 �ݸ����ȯ�
      (setq #snk-en #en) ; �ݸ����ȯĐ}�`��
    )
    (setq #i (1+ #i))
  )
  (setq #xd$ (CFGetXData #snk-en "G_LSYM")) ; �ݸ����ȯĊg���ް�

  (setq #HH (nth 5 (CFGetXData #snk-en "G_SYM"))) ; G_SYM���@H
  (setq #ang (nth 2 #xd$))  ; ��]�p�x
  (setq #HINBAN (nth 5 #xd$))


;;; (setq #LIST$$
;;;    (list
;;;      (list "BG�L��" "1" 'INT) ; BG����
;;;      (list "BG����" "0" 'INT) ; BG��̌^
;;;    )
;;; )
;;;  (setq #qry$
;;;   (CFGetDBSQLRec CG_DBSESSION "WT�f��" #LIST$$)
;;; )
;;;  (setq #wk-thk (nth 2 (car #qry$)))


  ;2010/10/26 YM MOD-E �V��}���Ă��Ȃ��̂ɓV�̌��݂��m�肽��
  ;�֐��� 2010/10/27 YM ADD
  (setq #qry$ (GetWtDanmen))

  (if (= nil #qry$)
    (progn
      (CFAlertMsg "\n[WT�f�ʌ���]���E���Ȃ�")
      (quit)
    )
  );_if

  (setq #wk-thk (nth  2 #qry$)) ; WT�̌���
;;;  (setq #wk-thk 19)


  ;2011/04/11 YM ADD-S �V����ި�Ή� �ꍇ�킯
  (cond
    ((= BU_CODE_0010 "1") 
      ;SKB�̏ꍇ
      (cond
        ((= "Q" (substr #HINBAN 9 1))
          (setq #m1-wid 700)  ; ���s��
        )
        ((= "J" (substr #HINBAN 9 1))
          (setq #m1-wid 650)  ; ���s��
        )
        ((= "C" (substr #HINBAN 9 1))
          (setq #m1-wid 600)  ; ���s��
        )
        (T ;�z��O
          (setq #m1-wid 650)  ; ���s��
        )
      );_cond
    )
    ;�]��ۼޯ�
    (T
      (setq #m1-wid 650)  ; ���s��
    )
  );_cond
  ;2011/04/11 YM ADD-E




  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "WT�V���N"
      (list
        (list "�V���N�L��"  (nth 17 CG_GLOBAL$) 'STR)
      )
    )
  );_(setq #qry$

  (setq #qry$ (DBCheck #qry$ "�wWT�V���N�x" "PKC_LayoutSink"))

  ;//   �v�����F�w�v���Ǘ��x  .�V���N�ʒu�I�t�Z�b�g��
  ;//   �c�����F�w�v�s�V���N�x.�V���N�I�t�Z�b�g����
  ;//           �w�v�s�V���N�x.�V���N�I�t�Z�b�g��
  (setq #w-off CG_WSnkOf)           ; CG_WSnkOf [�v���Ǘ�]����擾
  (setq #d-vct 1) ; WT�V���N.�I�t�Z���� ==>1�Œ� ;2008/06/23 YM OK

  (setq #ZaiF (KCGetZaiF (nth 16 CG_GLOBAL$)))
  ; �p�r�ԍ�����
  (if (= #ZaiF 1) ; ���ڽ��
    (setq #YNO 0)
    (setq #YNO 1)
  )

  ; �l��,���ڽ�ŵ̾�ʂ��ς��
  (if (= #ZaiF 1) ; WT�O�ʂ���r����PTEN4 �܂ł̋���
    (setq #d-off (nth 5 #qry$)) ;(INT)�wWT�ݸ�x.�ݸ�̾�ė�(���ڽ) ;2008/06/23 YM OK
    (setq #d-off (nth 6 #qry$)) ;(INT)�wWT�ݸ�x.�ݸ�̾�ė�(�l��)  ;2008/06/23 YM OK
  );_if

  ;2008/08/22 YM ADD-S ����̉��s���ŵ̾�ʂ��ς�邽�ߕ␳����
  ;[WT�V���N�I�t�Z�ʕ␳]
  (setq #qry_off$$
    (CFGetDBSQLRec CG_DBSESSION "WT�V���N�I�t�Z�ʕ␳"
      (list
        (list "�`��"       (nth  5 CG_GLOBAL$) 'STR)
        (list "���s��"     (nth  7 CG_GLOBAL$) 'STR)
        (list "�V���N�L��" (nth 17 CG_GLOBAL$) 'STR)
      )
    )
  )
  (if #qry_off$$
    (progn
      (setq #qry_off$ (car #qry_off$$))
      (if (= #ZaiF 1) ; WT�O�ʂ���r����PTEN4 �܂ł̋�����␳����l
        (setq #d-off (+ #d-off (nth 3 #qry_off$))) ;�ݸ�̾�ėʕ␳(���ڽ) ;2008/08/22 YM
        ;else
        (setq #d-off (+ #d-off (nth 4 #qry_off$))) ;�ݸ�̾�ėʕ␳(�l��)  ;2008/08/22 YM
      );_if

    )
  );_if
  ;2008/08/22 YM ADD-S ����̉��s���ŵ̾�ʂ��ς�邽�ߕ␳����


  (setq #LR_EXIST (nth 4 #qry$))    ; WT�V���N.LR�L��    ;2008/06/23 YM OK
  (setq #h-no     (nth 3 #qry$))    ; WT�V���N.�i�Ԗ���  ;2008/06/23 YM OK

  ;// �H��L���ESERIES�L������уV���N�̕i�Ԗ��̂��i�Ԑ}�`���w�i�Ԑ}�`�x���������A
  ;// �V���N�̐}�`ID�w�i�Ԑ}�`�x.�}�`ID���擾����

  (setq #listCode nil)
  (if (equal #LR_EXIST 0.0 0.1) ; LR�L���Ȃ�
    (setq #LR "Z")
    (setq #LR "L");�v���������̓f�t�H���g������Ȃ̂�"L"���߂���
  );_if

  (setq #YNO (itoa #YNO)) ; �p�r�ԍ�

  (setq #LIST$$
    (list
      (list "�i�Ԗ���"   (nth 3 #qry$)  'STR);2008/06/23 YM OK
      (list "LR�敪"     #LR    'STR)
      (list "�p�r�ԍ�"   #YNO   'INT)
    )
  )

  (setq #fig$
    (CFGetDBSQLHinbanTable "�i�Ԑ}�`" (nth 3 #qry$) #LIST$$);2008/06/23 YM OK
  )
  (setq #fig$ (DBCheck #fig$ "�w�i�Ԑ}�`�x" "PKC_LayoutSink"))

  ; #fig$ ����
  (setq #dimW2 (* 0.5 (nth 3 #fig$)));W�l     ;2008/06/23 YM OK
  (setq #figID (nth 6 #fig$))        ;�}�`ID  ;2008/06/23 YM OK

  (setq #sink_hinban (nth 0  #fig$));2008/08/26 �ݸ�i��

  (if (= #figID nil);�ݸ�}�`ID
    (progn
      (setq #msg (strcat "\n�w�i�Ԑ}�`�x�ɐ}�`ID�����o�^�ł��B\n" (nth 0 #fig$)))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_if

  ;�Ζʂ̂Ƃ��Ɏ{�H�}�̊֌W�ŁA�z�u����ݸ�}�`ID��ύX����K�v����
  ;2008/08/26 YM ADD-S
  ;[OP�u���V���N]
  (setq #qry_chg$$
    (CFGetDBSQLRec CG_DBSESSION "OP�u���V���N"
      (list
        (list "�`��"         (nth  5 CG_GLOBAL$) 'STR)
        (list "���s��"       (nth  7 CG_GLOBAL$) 'STR)
        (list "�V���N�L��"   (nth 17 CG_GLOBAL$) 'STR)
;;;        (list "���E����"     (nth 11 CG_GLOBAL$) 'STR);���]�������邩��KEY�ɂł��Ȃ�
        (list "�u���O�}�`ID" #figID              'STR);����KEY���L��
      )
    )
  )
  (if (and #qry_chg$$ (= 1 (length #qry_chg$$)))
    (progn
      (setq #qry_chg$ (car #qry_chg$$))
      (setq #figID (nth 4 #qry_chg$))   ;�u����}�`ID
      (setq #sink_hinban (nth 5 #qry_chg$));2008/08/26 �ݸ�i�� ���]�����̂��߂ɕK�v
    )
  );_if
  ;2008/08/26 YM ADD-E



;;; �x�[�X�L���r�l�b�g�̍ŉE�̍��W�����߂�
;;;��WOODONE����̫�Ă�������Ȃ̂�WT���[����ݸ��z�u����;08/06/23 YM MOD
  (setq #pt
    (list
      (+ CG_WSnkOf (/ (nth 3 #fig$) 2));X���W=�ݸ�e+�ݸ�̕���1/2 ;2008/06/23 YM OK
      (* -1 #m1-wid)
    )
  )

  ;// �V���N�}�`���ďo���A�V���N�}�`�z�u��_�ɔz�u����
  (setq #pt (polar #pt (+ (dtr  90) #ang) #d-off)) ; #ang : G_LSYM�̂R�Ԗ�.��]�p�x(rad) �ʏ킱����

  (setq #pt (list (car #pt) (cadr #pt) #HH)) ; #HH��"G_SYM"���@H����
  (if (= nil (findfile (strcat CG_MSTDWGPATH #figID ".dwg"))) ; �i�Ԑ}�`�A�}�`�h�c OK!
    (progn
      (setq #msg (strcat "�ݸ���ސ}�`:" #figID "������܂���"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  )

  (command "_insert" (strcat CG_MSTDWGPATH #figID) #pt 1 1 (rtd #ang)) ; �i�Ԑ}�`�A�}�`�h�c OK!
  (command "_move" (entlast) "" "0,0,0" (list 0 0 #wk-thk))  ; ���[�N�g�b�v���ݕ� z�������Ɉړ�

  ;// �z�u���_�Ɗp�x���m��
  (setq #pos (cdr (assoc 10 (entget (entlast))))) ; "INSERT" �}���_
  (setq #ang (cdr (assoc 50 (entget (entlast))))) ; "INSERT" ��]�p�x
  (setq #grp (nth 6 #fig$)) ; ;�}�`ID  ;2008/06/23 YM OK
  (command "_explode" (entlast))                    ;�C���T�[�g�}�`����
  (setq #ss_dum (ssget "P"))
  (SKMkGroup #ss_dum)
;;;  (setq #sym (SKC_GetSymInGroup (ssname #ss_dum 0))) ; �O���[�v�}�`�̒�����V���{����_�}�`�𔲂��o��
     (setq #sym (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

  ;// �w�i�Ԋ�{�x���琫�iCODE���擾����
  (setq #seikaku CG_SKK_INT_SNK) ; �V���N ; 01/08/31 YM MOD 410-->��۰��ى�

  (WebOutLog "�g���ް� G_LSYM ��Ă��܂�"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (CFSetXData #sym "G_LSYM"
    (list
      #figID                ;1 :�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID  ;2008/06/23 YM OK     2011/04/07 YM ADD
      #pos                  ;2 :�}���_          :�z�u��_
      #ang                  ;3 :��]�p�x        :�z�u��]�p�x
      CG_Kcode              ;4 :�H��L��        :CG_Kcode
      CG_SeriesCode         ;5 :SERIES�L��    :CG_SeriesCode
      #sink_hinban          ;6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���   ; �i�Ԑ}�`�A�i�Ԗ��� OK!
      (nth 1  #fig$)        ;7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪  ; �i�Ԑ}�`�ALR�敪 'STR OK!
      ""         ;8 :���}�`ID        :
      ""         ;9 :���J���}�`ID    :
      (fix #seikaku)        ;10:���iCODE      :�w�i�Ԋ�{�x.���iCODE
      0                     ;11:�����t���O      :�O�Œ�i�P�ƕ��ށj
      0                     ;12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
      (fix (nth 2 #fig$))   ;13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�   ;2008/06/23 YM OK
      (fix (nth 5 #fig$))   ;14:���@�g          :�w�i�Ԑ}�`�x.���@�g     ;2008/06/23 YM OK
      1                     ;15:�f�ʗL��
      "A"                   ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
    )
  )

  (KcSetG_OPT #sym) ; �g���ް�"G_OPT"���

  ;2010/10/13 YM ADD-S [�ݸOP]�e�[�u���Q�ƂŕR�t��
  (KcSetSinkG_OPT #sym) ; �g���ް�"G_OPT"���
  ;2010/10/13 YM ADD-E


;-- 2011/09/17 A.Satoh Mod - S
;;;;;;;; �V�K 07/27 YM ������ID(key) ����uWT�������v."�������L��"�����߂�
;;;;;  (setq #ANAqry$ ; �P��������
;;;;;    (CFGetDBSQLRec CG_DBSESSION "WT������"
;;;;;      (list
;;;;;        (list "������ID" "1" 'INT)
;;;;;      )
;;;;;    )
;;;;;  );_(setq
;;;;;  (setq #ANAqry$ (DBCheck #ANAqry$ "�wWT�������x" "PKC_LayoutSink")) ; nil or ������ �װ
;;;;;  (setq #WtrHoleCode (cadr #ANAqry$))
  (setq #WtrHoleCode "0");2011/09/17 YM ADD ���߂����g�p���Ȃ�
;-- 2011/09/17 A.Satoh Mod - E

  (if (not (tblsearch "APPID" "G_SINK")) (regapp "G_SINK"))

  ;// �g���f�[�^�̕t��
  (WebOutLog "�g���ް� G_SINK ��Ă��܂�"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (CFSetXData #sym "G_SINK"
    (list
      (nth 17 CG_GLOBAL$)  ; �V���N�L��
      #WtrHoleCode ; �������L��
      0            ; �ݸ�߹�Ă̖� 0
      ""           ; �V���N���}�`�n���h��
    )
  );_CFSetXData

;;; �����ɂ��ď��߂Đ��iCODE"410" "G_PTEN" ���􌊂�����
  (setq #pt_lis (PKC_GetSuisenAnaPt #sym 4)) ; �V���N���̐��􌊈ʒu���W�̃��X�g element 4��
  (setq #pt_SUISEN (car #pt_lis))
  (setq #y_SUISEN  (cadr #pt_SUISEN))
  (setq #move (- #y_SUISEN (cadr #pos)))

;;;;;; �V���N�I�t�Z�b�g�� (WT�O�ʂ���V���N�e�}�`)�Ŕz�u�����̂�KPCAD�p(WT�O�ʂ��琅�����ʒu)�ɏC���ړ�����.
  (setq #ss_SNK (CFGetSameGroupSS #sym))   ; �V���{���}�`����n���đI���Z�b�g(330�}�`����340�}�`��)�𓾂�.

;;; 3D�v�f�ҏW�̈ړ�
  (command "_.move" #ss_SNK "" "0,0,0" (list 0 (- #move) 0))    ; �v�f�̈ړ�
  (ChgLSYM1 #ss_SNK)

  (setq #i 0)
  (while (and #loop (< #i (length #pt$)))
    (setq #pt (nth #i #pt$))
    (if (= -1 (setq #ret (CFAreaInPt #pt (AddPtList #area$))))
      (setq #loop nil)
    )
    (setq #i (1+ #i))
  )


  (princ)
);PKC_LayoutSink

;;;<HOM>*************************************************************************
;;; <�֐���>    : KcSetSinkG_OPT
;;; <�����T�v>  : �A�C�e���Ɋg���ް� "G_OPT"��ǉ��Z�b�g����B[�ݸOP]�Q��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2010/10/13 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun KcSetSinkG_OPT (
  &eSYM   ; ����ِ}�`
  /
  #ADDOP$ #IHIN #IOP #QRY$$ #SHIN #SOPT
  )
  (setq #QRY$$ nil)  ; ������
  (setq #sHIN (nth 5 (CFGetXData &eSYM "G_LSYM"))) ; "�i�Ԗ���"

  (setq #QRY$$ ; ����HIT��
    (CFGetDBSQLRec CG_DBSESSION "�V���NOP"
      (list
        (list "�ގ��L��"   (nth 16 CG_GLOBAL$) 'STR)
        (list "�V���N�L��" (nth 17 CG_GLOBAL$) 'STR)
      )
    )
  )
  (if #QRY$$
    (progn
      (setq #addOP$ nil)
      (setq #iHIN 0) ; ��߼�ݕi�Ԏ�ސ�

      (foreach #QRY$ #QRY$$
        (setq #sOPT (nth 2 #QRY$))     ;��߼�ݕi�Ԗ���
        (setq #iOP (fix (nth 3 #QRY$)));��
        ; �I�v�V�����i����1�ȏ�Ȃ�OPT�ݒu���X�g�Ɏ擾
        (if (<= 1 #iOP)
          (progn
            (setq #addOP$ (append #addOP$ (list #sOPT #iOP))) ; �i�Ԃƌ�
            (setq #iHIN (1+ #iHIN))
          )
        );_if

      ); foreach

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
); KcSetSinkG_OPT

;;;<HOM>*************************************************************************
;;; <�֐���>    : KcSetSinkG_OPT_KPCAD
;;; <�����T�v>  : �A�C�e���Ɋg���ް� "G_OPT"��ǉ��Z�b�g����B[�ݸOP]�Q�� 
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2010/10/13 YM
;;; <���l>      : KPCAD�p�Ɉ������K�v
;;;*************************************************************************>MOH<
(defun KcSetSinkG_OPT_KPCAD (
  &eSYM   ; ����ِ}�`
	&zai
	&snk
  /
  #ADDOP$ #IHIN #IOP #QRY$$ #SHIN #SOPT
  )
  (setq #QRY$$ nil)  ; ������
  (setq #sHIN (nth 5 (CFGetXData &eSYM "G_LSYM"))) ; "�i�Ԗ���"

  (setq #QRY$$ ; ����HIT��
    (CFGetDBSQLRec CG_DBSESSION "�V���NOP"
      (list
        (list "�ގ��L��"   &zai 'STR)
        (list "�V���N�L��" &snk 'STR)
      )
    )
  )
  (if #QRY$$
    (progn
      (setq #addOP$ nil)
      (setq #iHIN 0) ; ��߼�ݕi�Ԏ�ސ�

      (foreach #QRY$ #QRY$$
        (setq #sOPT (nth 2 #QRY$))     ;��߼�ݕi�Ԗ���
        (setq #iOP (fix (nth 3 #QRY$)));��
        ; �I�v�V�����i����1�ȏ�Ȃ�OPT�ݒu���X�g�Ɏ擾
        (if (<= 1 #iOP)
          (progn
            (setq #addOP$ (append #addOP$ (list #sOPT #iOP))) ; �i�Ԃƌ�
            (setq #iHIN (1+ #iHIN))
          )
        );_if

      ); foreach

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
); KcSetSinkG_OPT_KPCAD

;;;<HOM>*************************************************************************
;;; <�֐���>     : MultiCabCut
;;; <�����T�v>   : ����ݸ���A����ȯĈꕔ���
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 08/07/28 YM ADD
;;; <���l>       : "BLUE"��"3DSOLID","POINT"�����炩��������ݸ�}�`�ɖ��ߍ���ł���
;;;              : 
;;;*************************************************************************>MOH<
(defun MultiCabCut (
  /
  #EN #I #P1 #P1X #P2 #P2X #POINT1 #POINT2 #SEIKAKU #SINK #SSC
  #SS_BLUE_POINT #SS_BLUE_SOLID #SYM #XD-LSYM$
  #DEL_SOLID #LAST #SINK$
  )
  (setq #ss_BLUE_SOLID (ssget "X" (list (cons 0 "3DSOLID") (cons 8 "Z_00_00_00_01") (cons 62 5))))
  (setq #ss_BLUE_POINT (ssget "X" (list (cons 0 "POINT")   (cons 8 "Z_00_00_00_01") (cons 62 5))))
  
  (if (and #ss_BLUE_SOLID #ss_BLUE_POINT (< 0 (sslength #ss_BLUE_SOLID))(< 0 (sslength #ss_BLUE_POINT)))
    (progn

      ;��菜��3DSOLID�}�`
      (setq #DEL_SOLID (ssname #ss_BLUE_SOLID 0))

      ;�߲�Ă�X���W���r
      (setq #p1 (cdr (assoc 10 (entget (ssname #ss_BLUE_POINT 0)))))
      (setq #p1X (car #p1))
      (setq #p2 (cdr (assoc 10 (entget (ssname #ss_BLUE_POINT 1)))))
      (setq #p2X (car #p2))

      (if (< #p1X #p2X)
        (progn ;X���W���傫������#point1
          (setq #point1 #p2)
          (setq #point2 #p1)
        )
        (progn
          (setq #point1 #p1)
          (setq #point2 #p2)
        )
      );_if

      ;�̈����"3DSOLID"
      (command "vpoint" "0,0,1")
      (setq #ssC (ssget "C" #point1 #point2 (list (cons 0 "3DSOLID") (cons 8 "Z_00_00_00_01"))))
      ;�V���N�}�`�͎�菜��
      (setq #i 0)(setq #SINK$ nil)
      (repeat (sslength #ssC)
        (setq #en (ssname #ssC #i))
        (setq #sym (SearchGroupSym (ssname #ssC #i)))
        (setq #xd-lsym$ (CFGetXData #sym "G_LSYM"))
        (setq #seikaku  (nth 9 #xd-lsym$)) ;���iCODE
        (if (= #seikaku CG_SKK_INT_SNK)
          (setq #SINK$ (append #SINK$ (list #en)))
        );_if
        (setq #i (1+ #i))
      )
      (foreach #SINK #SINK$
        (ssdel #SINK #ssC)     ;��Ă����߰�(�ݸ�}�`������)
      )

      ;��ď������s��
      (command "vpoint" "1,-1,1")

      (setq #i 0)
      (repeat (sslength #ssC)
        (setq #en (ssname #ssC #i))
        (command "._COPY" #DEL_SOLID "" "0,0,0" "0,0,0")
        (setq #last (entlast))
        (command "_.subtract" #en "" #last "")
        (command "_REGEN")
        (setq #i (1+ #i))
      );repeat

      ;���}�`���폜����
      (command "_.ERASE" #DEL_SOLID "")
      (command "_.ERASE" #ss_BLUE_POINT "")
    )
  );_if

  (princ)
);MultiCabCut


;;;<HOM>*************************************************************************
;;; <�֐���>     : KPW_PosSink2
;;; <�����T�v>   : �V���N��z�u����
;;; <�߂�l>     : �V���N�}�`��
;;; <�쐬>       : 00/02/17  MH ADD
;;; <���l>       : 00/04/07 YM �C�� U�^�Ή� �V�^WT�p
;;;              : 00/05/04 �ݸ�z�umatrix�Ή�
;;;                00/10/05 YM MOD �ݸ�̾�ė� WT�O�ʂ���r����PTEN4 �܂ł̋���
;;;                �ݸ�ʒu��WT�̒[����(I�^,L�^�Ή�) 00/12/02 YM MOD
;;;                I�^�̏ꍇ�F�ݸR,Z==>WT�E�[����,�ݸL==>WT���[����
;;;                L�^�̏ꍇ�F�ݸ�̂��鑤�̺�Ű�łȂ�WT�[����
;;;*************************************************************************>MOH<
(defun KPW_PosSink2 (
  &name$
  &scab-en   ;(ENAME)�V���N�L���r��_�}�`
  &w-xd$     ;(LIST)���[�N�g�b�v�g���f�[�^
  &w-off     ;(REAL)�v�����I�t�Z�b�g(�ݸ�e���@)
  &LR        ; �ݸ����LRZ
  &ZaiF      ;�f��F
  &pocket    ;�ݸ�߹�ėL��"Y" or "N"
;-- 2011/09/17 A.Satoh Add - S
  &width     ;�ݸ���޾����ʒu
;-- 2011/09/17 A.Satoh Add - E
  /
;-- 2011/09/17 A.Satoh Mod - S
;;;;;  #ANAPT #ANG #AREA$ #BASEP #BASEPT #D-OFF #DIMW2 #DUMPT$ #EN$ #FGSHIFT #FIG$ #FIGID 
;;;;;  #FSNKANG #FSNK_H #H-NO #I #IWTTHK #LOOP #LR #LR_EXIST #MOVE_Y #MSG1 #MSG2 #NAME$ #ORG_LR 
;;;;;  #P-SS #P3 #P4 #PMEN2 #PMEN6 #PMEN8 #POS #PT #PT$ #PT_LIS #RET #S-XD$ #SNK #SPLAN #SS_DUM 
;;;;;  #SS_SNK #SYM #TEI #TYPE1 #WTCUT #WTL #WTP1 #WTP2 #WTP3 #WTP4 #WTP5 #WTP6 #WTP7 #WTP8 
;;;;;  #WTPT #WTPT$ #WTR #WT_LR #X #XP #YNO
;;;;;#WTPLAST ; 02/09/04 YM ADD
  #name$ #SNK #h-no #d-off #LR #fSNK_H #iWTthk #FGSHIFT #s-xd$ #fSNKang #offset
  #pmen8 #pmen2 #pt$ #BASEPT #dumpt$ #dMin #dMax #dVm #p3 #p4 #YNO #SPLAN #fig$
  #figID #pt #pos #ang #ss_dum #sym #XP #pt_lis #AnaPt #move_Y #ss_SNK #p-ss #pmen6
  #area$ #loop #i #Msg1 #Msg2 #en$
;-- 2011/09/17 A.Satoh Mod - E
#p2 #XP1 #XP2 #move_X	;-- 2011/10/25 A.Satoh Add
#RET ;2017/01/19 YM ADD
  )

  (setq #name$ &name$)
;-- 2011/09/17 A.Satoh Mod - S
;;;;;;-- 2011/06/29 A.Satoh Mod - S
;;;;;;|
;;;;;  (setq #SNK      (nth 1 #name$)) ; �ݸ�L��
;;;;;  (setq #LR_EXIST (nth 9 #name$)) ; LR�L��
;;;;;  (setq #h-no     (nth 5 #name$)) ;(STR)�wWT�ݸ�x.�i�Ԗ���
;;;;;  (if (= &ZaiF 1) ; WT�O�ʂ���r����PTEN4 �܂ł̋��� 00/10/05 YM MOD
;;;;;    (setq #d-off (nth  8 #name$)) ;(INT)�wWT�ݸ�x.�ݸ�̾�ė�(���ڽ)
;;;;;    (setq #d-off (nth 15 #name$)) ;(INT)�wWT�ݸ�x.�ݸ�̾�ė�(�l��)
;;;;;  );_if
;;;;;|;
;;;;;  (setq #SNK      (nth 1 #name$)) ; �ݸ�L��
;;;;;  (setq #LR_EXIST (nth 4 #name$)) ; LR�L��
;;;;;  (setq #h-no     (nth 3 #name$)) ;(STR)�wWT�ݸ�x.�i�Ԗ���
;;;;;  (if (= &ZaiF 1) ; WT�O�ʂ���r����PTEN4 �܂ł̋��� 00/10/05 YM MOD
;;;;;    (setq #d-off (nth 5 #name$)) ;(INT)�wWT�ݸ�x.�ݸ�̾�ė�(���ڽ)
;;;;;    (setq #d-off (nth 6 #name$)) ;(INT)�wWT�ݸ�x.�ݸ�̾�ė�(�l��)
;;;;;  );_if
;;;;;;-- 2011/06/29 A.Satoh Mod - E
;;;;;
;;;;;  (setq #LR &LR) ; �ݸ����LRZ
;;;;;  (setq #type1   (nth  3 &w-xd$))  ;WT�`������0,1,2
;;;;;  (setq #WTcut   (nth  7 &w-xd$))  ;WT�������
;;;;;  (setq #fSNK_H  (nth  8 &w-xd$))  ;WT���t������
;;;;;  (setq #iWTthk  (nth 10 &w-xd$))  ;WT���� 23
;;;;;  (setq #FGSHIFT (nth 17 &w-xd$))  ;WT�O�����ė�
;;;;;  (setq #WT_LR   (nth 30 &w-xd$))  ;WT����
;;;;;  (setq #BaseP   (nth 32 &w-xd$))  ;WT����_
;;;;;  (setq #tei     (nth 38 &w-xd$))  ;WT��ʐ}�`�����
;;;;;  (setq #WTL     (nth 47 &w-xd$))  ;WT��
;;;;;  (setq #WTR     (nth 48 &w-xd$))  ;WT�E

	;2017/01/20 YM ADD �V�̏���ł��炷�����𔻒f����
	(setq #WT_LR   (nth 30 &w-xd$))  ;WT����
	(cond
		((= #WT_LR "L")
			;���̂܂ܼݸ���ޔz�u����
			(setq #DirecFLG "L")
	 	)
		((= #WT_LR "R")
			;�ݸ���ޔz�u�����Ƃ͋t����
			(setq #DirecFLG "R")
	 	)
		(T
	    (initget 1 "L R")
	    (setq #DirecFLG (getkword "\n�ݸ������w�� /L=���ݸ /R=�E�ݸ /:  "))
	 	)
	);_cond

  (setq #SNK      (nth 1 #name$)) ; �ݸ�L��
  (setq #h-no     (nth 3 #name$)) ;(STR)�wWT�ݸ�x.�i�Ԗ���
  (if (= &ZaiF 1) ; WT�O�ʂ���r����PTEN4 �܂ł̋���
    (setq #d-off (nth 5 #name$)) ;(INT)�wWT�ݸ�x.�ݸ�̾�ė�(���ڽ)
    (setq #d-off (nth 6 #name$)) ;(INT)�wWT�ݸ�x.�ݸ�̾�ė�(�l��)
  )

  (setq #LR &LR) ; �ݸ����LRZ
  (setq #fSNK_H  (nth  8 &w-xd$))  ;WT���t������
  (setq #iWTthk  (nth 10 &w-xd$))  ;WT���� 23
  (setq #FGSHIFT (nth 17 &w-xd$))  ;WT�O�����ė�
;-- 2011/09/17 A.Satoh Mod - E

  ;// �V���N�L���r�̊g���f�[�^�����o��
  (setq #s-xd$ (CFGetXData &scab-en "G_LSYM")) ; �ݸ����ȯĊg���ް�
  (setq #fSNKang (nth 2 #s-xd$))     ; ��]�p�x
;-- 2011/09/17 A.Satoh Add - S
  (setq #offset (- &w-off &width))
;-- 2011/09/17 A.Satoh Add - E

  ;// �V���N�L���r�l�b�g�ɐݒ肳��Ă���V���N��t���̈�PMEN8,�O�`�̈�PMEN2���擾
  (setq #pmen8 (PKGetPMEN_NO &scab-en 8)) ; &scab-en ����ِ}�`�� �ݸ���t���̈� #pmen8
  (setq #pmen2 (PKGetPMEN_NO &scab-en 2)) ; &scab-en ����ِ}�`�� �ݸ���ފO�`�̈� #pmen2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 &scab-en))   ; PMEN2 ���쐬
  );_if

;;; WT�̔z�u�p�x�Ƽݸ���ނ̔z�u�p�x�������Ă��邩
;;; �א�WT�����邩�ǂ���
;;;+-----------------------+  +-------------------------+  +----------------+
;;;|                       |  |          +------+       |  |                |
;;;|     +---------+       |  |          |      |       |  |                |
;;;|     |�ݸ      |<----->|  |          |      |<----->�[ |         +------+
;;;|     |         |       |  |          +------+       |  |  +----+ |
;;;|     +---------+       |  |     +-------------------+  |  |    | |
;;;+-----------------------+  |     |                      |  |    | |
;;;                           |     |                      |  |    | |
;;;                           +-----+                      |  +----+ |
;;;                                                        |         |
;;;                                                        +----�[---+
;;;<I�^>
;;;  p1                 pt             p2
;;;   +-----------------*--------------+
;;;   |     �ݸPMEN6                   | <--WT�O�`�̈�
;;;   |       +-------------------+ R�̏ꍇ�ݸ�e���@ &w-off
;;;   |       |                   |<-->|
;;;   |       |          PTEN4    |    |
;;;   |       |            *----------------------+
;;;   |       |          �����    |    |          |
;;;   |       +---------@---------+    |        �I�t�Z�� #d-off
;;;   |                                |          |
;;;   +--------WT�O��------------------+----------*
;;;  p4                                p3

;;; �ݸ����ق́AW�����Ɋւ��ļݸ�̐^�񒆂ɂ���Ɖ���
  (setq #pt$ (GetLWPolyLinePt #pmen2)) ; �ݸ���ފO�`�̈�_��
  (setq #BASEPT (cdr (assoc 10 (entget &scab-en)))) ; ����ي�_
  (setq #dumpt$ (GetPtSeries #BASEPT #pt$)) ; �_�����#BASEPT��擪�Ɏ��v����ɂ���
;-- 2011/09/17 A.Satoh Add - S
  ; �ݸ���ފO�`�̈�̾������W�����߂�
  (setq #dMin (list (apply 'min (mapcar 'car #pt$)) (apply 'min (mapcar 'cadr #pt$)) 0.0))
  (setq #dMax (list (apply 'max (mapcar 'car #pt$)) (apply 'max (mapcar 'cadr #pt$)) 0.0))
  (setq #dVm  (mapcar '* '(0.5 0.5 1.0) (mapcar '+ #dMin #dMax)))�@; ���_�Z�o

  ; �V���N�z�u��ʏ�Őݒ肵���V���N�L���r�����ʒu�ɍ��W�����킹��
;-- 2011/11/25 A.Satoh Mod - S
;  (setq #dVm  (list (+ (car #dVm) #offset) (cadr #dVm) (caddr #dVm)))

	;2017/01/20 YM ADD #DirecFLG
	(setq #p1 (nth 0 #dumpt$))
	(setq #p2 (nth 1 #dumpt$))
	(cond
		((= #DirecFLG "L")
;;;(setq #dPT1 (polar #p2 (angle #p2 #p1)(atoi CG_R)))
  		(setq #dVm (polar #dVm #fSNKang #offset))
	 	)
		((= #DirecFLG "R");�t����
  		(setq #dVm (polar #dVm (angle #p2 #p1) #offset))
	 	)
		(T
  		(setq #dVm (polar #dVm #fSNKang #offset))
	 	)
	);_cond

;-- 2011/11/25 A.Satoh Mod - E
;-- 2011/09/17 A.Satoh Add - E

  (if #dumpt$ ; 06/26 YM ADD
    (setq #pt$ #dumpt$) ; nil �łȂ�
    (progn ; �O�`�_���ɼ���ق��Ȃ��ꍇ
      (setq #BASEPT (PKGetBaseI4 #pt$ (list &scab-en))) ; �_��Ƽ���ي�_�P�� (00/05/20 YM)
      (setq #pt$ (GetPtSeries #BASEPT #pt$))            ; #BASEPT ��擪�Ɏ��v���� (00/05/20 YM)
    )
  );_if
;-- 2011/10/25 A.Satoh Add - S
	(setq #p2 (nth 1 #pt$))
;-- 2011/10/25 A.Satoh Add - E
  (setq #p3 (nth 2 #pt$)) ; PMEN2�O�`�̑O��(��})
  (setq #p4 (nth 3 #pt$)) ; PMEN2�O�`�̑O��(��})

;;; �p�r�ԍ�
;;;  0: �W��(�X�e��)
;;;  1: �l��V���N
;;;  2: �|�P�b�g�t�V���N
;;;  3: �|�P�b�g�t�l��V���N
;;; 10: S�v�����V���N
;;; 11: S�v�����l��V���N
;;; 12: S�v����P�t�V���N
;;; 13: S�v����P�t�l��V���N

;;; &ZaiF      ;�f��F
;;; &pocket    ;�ݸ�߹�ėL��"Y" or "N"
;;; (nth 5 #s-xd$)) ; �ݸ���ޕi�Ԗ���
;;; #SNK       ; �ݸ�L��

  ; �p�r�ԍ����� 01/02/10 YM
  (if (= &ZaiF 1) ; ���ڽ��
    (setq #YNO 0)
    (setq #YNO 1)
  )
  (if (= &pocket "Y") ; �߹�ĕt����
    (setq #YNO (+ 2 #YNO))
  )
  (setq #SPLAN (CFgetini "SPLAN" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
  (if (and (= #SNK "SA")(wcmatch (nth 5 #s-xd$) #SPLAN))
    (setq #YNO (+ 10 #YNO)) ; S���ݐ�p�ެ��޼ݸ�̏ꍇ
  );_if
  (setq #YNO (itoa #YNO)) ; �p�r�ԍ�

;-- 2011/09/17 A.Satoh Del - S
;;;;;  (if (equal #LR_EXIST 0 0.1)
;;;;;    (setq #ORG_LR "Z")
;;;;;    (setq #ORG_LR #LR)
;;;;;  );_if
;-- 2011/09/17 A.Satoh Del - E

  (setq #fig$
    (CFGetDBSQLHinbanTable "�i�Ԑ}�`" #h-no
      (list
        (list "�i�Ԗ���"   #h-no  'STR)
        (list "LR�敪"     #LR    'STR)
;-- 2011/06/29 A.Satoh Mod - S
; ���������� �p�r�ԍ����������X�g�ɕ���
;;;        (list "�p�r�ԍ�"   #YNO   'INT)
        (list "�p�r�ԍ�"   #YNO   'INT)
;-- 2011/06/29 A.Satoh Mod - E
      )
    )
  )
  (if (and #fig$ (= (length #fig$) 1))
    (setq #fig$ (car #fig$))
    (progn
      (CFAlertMsg 
        (strcat "\n�p�r�ԍ�=" #YNO "��ں��ނ��i�Ԑ}�`�ɂȂ����A�܂��͕������݂��܂��B"
        "\n�i��: " #h-no " LR: " #LR)
      )
      (quit)
    )
  );_if

  ; #fig$ ����
;  (setq #dimW2 (* 0.5 (nth 3 #fig$)));2008/06/28 YM OK!
  (setq #figID (nth 6 #fig$));2008/06/28 YM OK!
  (if (= #figID nil) ; 00/11/14 YM ADD
    (progn
      (CFAlertMsg (strcat "\n�w�i�Ԑ}�`�x�ɐ}�`ID�����o�^�ł��B\n" (nth 0 #fig$)))
      (quit)
    )
  );_if

;-- 2011/09/17 A.Satoh Del - S
;;;;;;|
;;;;;  (setq #wtpt$ (GetLWPolyLinePt #tei)); �O�`�_��
;;;;;;;; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
;;;;;  (setq #wtpt$ (GetPtSeries #BaseP #wtpt$))
;;;;;  (setq #wtp1 (nth 0 #wtpt$))
;;;;;  (setq #wtp2 (nth 1 #wtpt$))
;;;;;  (setq #wtp3 (nth 2 #wtpt$))
;;;;;  (setq #wtp4 (nth 3 #wtpt$))
;;;;;  (setq #wtp5 (nth 4 #wtpt$))
;;;;;  (setq #wtp6 (nth 5 #wtpt$))
;;;;;  (setq #wtp7 (nth 6 #wtpt$))
;;;;;  (setq #wtp8 (nth 7 #wtpt$))
;;;;;  (setq #wtpLast (last #wtpt$)) ; 02/04/05 YMA ADD
;;;;;
;;;;;  ; �ݸ�}���_#pt�����߂�
;;;;;  (cond
;;;;;    ; L�^��ĂȂ�
;;;;;    ; 1---------2
;;;;;    ; |         |
;;;;;    ; 4---------3
;;;;;    ((and (= #type1 0)(or (= #WTcut "00")(= #WTcut "04")(= #WTcut "40")))
;;;;;      (cond ; ��ĂȂ�
;;;;;        ((= #WT_LR "R") ; WT�̏�����݂�
;;;;;          (setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off))) ; �E�[����
;;;;;        )
;;;;;        ((= #WT_LR "L") ; WT�̏�����݂�
;;;;;          (setq #pt (polar #wtp1 (angle #wtp1 #wtp2) (+ #dimW2 &w-off))) ; ���[����
;;;;;        )
;;;;;        (T ; WT�̏��肪�s���̂Ƃ��E����
;;;;;          (initget 1 "Left Right")
;;;;;          (setq #x (getkword "\n�z�u�����w�� /L=��/R=�E/:  "))
;;;;;          (cond
;;;;;            ((= #x "Right")(setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off)))) ; �E�[����
;;;;;            ((= #x "Left") (setq #pt (polar #wtp1 (angle #wtp1 #wtp2) (+ #dimW2 &w-off)))) ; ���[����
;;;;;          );_cond
;;;;;        )
;;;;;      );_cond
;;;;;    )
;;;;;    ; L�^��ĂȂ�
;;;;;    ; 1---------2
;;;;;    ; |         |
;;;;;    ; |   4-----3
;;;;;    ; |   |
;;;;;    ; 6---5
;;;;;    ((and (= #type1 1)(or (= #WTcut "00")(= #WTcut "04")(= #WTcut "40")))
;;;;;      (if (= (CFArea_rl #wtp1 #wtp4 #BASEPT) -1)
;;;;;        ; �E��(��ۑ�)
;;;;;        (setq #pt (polar #wtp6 (angle #wtp6 #wtp1) (+ #dimW2 &w-off))) ; �[����
;;;;;        ; else
;;;;;        ; ����(�ݸ��)
;;;;;        (setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off))) ; �[����
;;;;;      );_if
;;;;;    )
;;;;;    ; U�^��ĂȂ�
;;;;;    ; 1---------2
;;;;;    ; |         |
;;;;;    ; |   4-----3
;;;;;    ; |   |
;;;;;    ; |   5-----6
;;;;;    ; |         |
;;;;;    ; 8---------7
;;;;;    ((and (= #type1 2)(or (= #WTcut "00")(= #WTcut "04")(= #WTcut "40")))
;;;;;      (cond
;;;;;        ((equal (Angle0to360 (angle #wtp1 #wtp2)) (Angle0to360 #fSNKang) 0.001) ; 1����WT�ɼݸ�z�u����
;;;;;          (setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off)))          ; �E�[����
;;;;;        )
;;;;;        ((equal (Angle0to360 (angle #wtp8 #wtp1)) (Angle0to360 #fSNKang) 0.001) ; 2����WT�ɼݸ�z�u����
;;;;;          (initget 1 "Left Right")
;;;;;          (setq #x (getkword "\n�z�u�����w�� /L=��/R=�E/:  "))
;;;;;          (cond
;;;;;            ((= #x "Right")(setq #pt (polar #wtp1 (angle #wtp1 #wtp8) (+ #dimW2 &w-off)))) ; �E�[����
;;;;;            ((= #x "Left") (setq #pt (polar #wtp8 (angle #wtp8 #wtp1) (+ #dimW2 &w-off)))) ; ���[����
;;;;;          );_cond
;;;;;        )
;;;;;        ((equal (Angle0to360 (angle #wtp7 #wtp8)) (Angle0to360 #fSNKang) 0.001) ; 3����WT�ɼݸ�z�u����
;;;;;          (setq #pt (polar #wtp7 (angle #wtp7 #wtp8) (+ #dimW2 &w-off)))          ; ���[����
;;;;;        )
;;;;;        (T ; ���̑�(���肦�Ȃ�)
;;;;;          (setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off)))
;;;;;        )
;;;;;      );_cond
;;;;;    )
;;;;;; else ��Ă���΂߶�� or J��� or I�^��ĂȂ�
;;;;;    (T
;;;;;      (cond
;;;;;        ((and (/= #WTR "")(= #WTL "")) ; �E�F����A���F�Ȃ�
;;;;;          (setq #pt (polar #wtp1 (angle #wtp1 #wtp2) (+ #dimW2 &w-off))) ; ���[����
;;;;;        )
;;;;;        ((and (/= #WTL "")(= #WTR "")) ; �E�F�Ȃ��A���F����
;;;;;          (setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off))) ; �E�[����
;;;;;        )
;;;;;        (T ; �������
;;;;;          ; 01/12/26 YM ADD-S
;;;;;          (initget 1 "Left Right")
;;;;;          (setq #x (getkword "\n�z�u�����w�� /L=��/R=�E/:  "))
;;;;;          (cond
;;;;;            ((= #x "Right")(setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off)))) ; �E�[����
;;;;;            ((= #x "Left") (setq #pt (polar #wtp1 (angle #wtp1 #wtp2) (+ #dimW2 &w-off)))) ; ���[����
;;;;;          );_cond
;;;;;          ; 01/12/26 YM ADD-E
;;;;;        )
;;;;;      );_cond
;;;;;    )
;;;;;  );_cond
;;;;;|;
;-- 2011/09/17 A.Satoh Del - E

  ; �ݸ���ސ��@H + WT���ݕ� Z�����Ɉړ�
;-- 2011/09/17 A.Satoh Mod - S
;  (setq #pt (list (car #pt) (cadr #pt) (+ #fSNK_H #iWTthk)))
  (setq #pt (list (car #dVm) (cadr #dVm) (+ #fSNK_H #iWTthk)))
;-- 2011/09/17 A.Satoh Mod - S

  ;;; �}�`�����݂��邩�m�F
  (if (= nil (findfile (strcat CG_MSTDWGPATH #figID ".dwg")))
    (progn
;;;      (CFOutLog 0 nil (strcat "�ݸ���ސ}�`:" #figID "������܂���"))
;;;      (CFOutLog 0 nil (strcat "  +�i�Ԗ���:" (nth 0 #fig$)))
      (*error*)
    )
  )
  ;;;�}�`�}�����s
  (command "_insert" (strcat CG_MSTDWGPATH #figID) #pt 1 1 (rtd #fSNKang))

  ;// �z�u���_�Ɗp�x���m��
  (setq #pos (cdr (assoc 10 (entget (entlast))))) ; "INSERT" �}���_
  (setq #ang (cdr (assoc 50 (entget (entlast))))) ; "INSERT" ��]�p�x

  (command "_explode" (entlast))                    ;�C���T�[�g�}�`����
  (setq #ss_dum (ssget "P"))
  (SKMkGroup #ss_dum)
;;;  (setq #sym (SKC_GetSymInGroup (ssname #ss_dum 0))) ; �O���[�v�}�`�̒�����V���{����_�}�`�𔲂��o��
  (setq #sym (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

  (CFSetXData #sym "G_LSYM"
    (list
      #figID                ;1 :�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID  ; �i�Ԑ}�`�A�}�`�h�c OK!
      #pos                  ;2 :�}���_          :�z�u��_
      #ang                  ;3 :��]�p�x        :�z�u��]�p�x
      (nth 0 &w-xd$)        ;4 :�H��L��        :CG_Kcode
      (nth 1 &w-xd$)        ;5 :SERIES�L��    :CG_SeriesCode
      (nth 0 #fig$)         ;6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���   ; �i�Ԑ}�`�A�i�Ԗ��� OK!
      (nth 1 #fig$)         ;7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪  ; �i�Ԑ}�`�ALR�敪 'STR OK!
      ""         ;8 :���}�`ID        :                                   OK!
      ""         ;9 :���J���}�`ID    :                                   OK!
      (fix CG_SKK_INT_SNK)  ;10:���iCODE      :�w�i�Ԋ�{�x.���iCODE ; 01/08/31 YM MOD 410-->��۰��ى�
      0                     ;11:�����t���O      :�O�Œ�i�P�ƕ��ށj
      0                     ;12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
      (fix (nth 2 #fig$))   ;13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�           ;2008/06/28 YM OK!
      (fix (nth 5 #fig$))   ;14:���@�g          :�w�i�Ԑ}�`�x.���@�g             ;2008/06/28 YM OK!
      1                     ;15:�f�ʗL��
      "A"                   ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
    )
  )
  
(KcSetG_OPT #sym)


;;; �ŏ��ɔz�u�����Ƃ���  ��x�z�u���Ȃ��Ɛ�����(*��)���W���Ƃ�Ȃ�
;;; W�����̂ݍ��킹�Ĕz�u�B��żݸ���ړ�����D�������C������B
;;;           +-------------------+
;;;           |   #AnaPt          |
;;;        sink    *  PTEN4       |
;;;           |    |             PMEN6
;;;           |    |     �����    |
;;;   +-------+---------*---------+----+p2
;;;  p1            |    #pos=#pt       |
;;;   |                                |
;;;   |            |                   |
;;;   |                                |
;;;   |            |                   |
;;;   |                                |<--�ݸ����
;;;   |            |                   |
;;;   |            |                   |
;;;   +------------XP------------------+
;;;   +-------------------- WT�O�� ----+

;-- 2011/09/17 A.Satoh Mod - S
;  ;;; PTEN4 �ʒu���W���擾
;  (setq #pt_lis (PKC_GetSuisenAnaPt #sym 4)) ; �V���N���̔r����(PTEN4����0)�ʒu���W�̃��X�g 00/10/05 ����"4"�ǉ�
;  (setq #AnaPt (car #pt_lis))                ; �r�����ǂꂩ�P��
;  (setq #XP (CFGetDropPt #AnaPt (list #p3 #p4)))
;  (setq #move_Y (- #d-off (+ (distance #XP #AnaPt) #FGSHIFT)))
;  ;;;�V���N�}�` �C���ړ�����.(WT�O�ʂ���r�����ʒu)
;  (setq #ss_SNK (CFGetSameGroupSS #sym))
;  (command "_.move" #ss_SNK "" "0,0,0" (polar '(0 0 0) (+ (dtr 90) #fSNKang) #move_Y))

  (if (wcmatch #SNK "K_*")
    (progn
      (setq #ss_SNK (CFGetSameGroupSS #sym))
    )
    (progn
      ;;; PTEN4 �ʒu���W���擾
      (setq #pt_lis (PKC_GetSuisenAnaPt #sym 4)) ; �V���N���̔r����(PTEN4����0)�ʒu���W�̃��X�g
      (setq #AnaPt (car #pt_lis))                ; �r�����ǂꂩ�P��

;  (setq #move_Y (- (nth 1 #AnaPt) (nth 1 #pos)))
;#pos�@�ݸ��_�@ #AnaPt P�_4

;-- 2011/09/20 A.Satoh �R�����g�𕜊� - S
      (setq #XP (CFGetDropPt #AnaPt (list #p3 #p4)))
      (setq #move_Y (- #d-off (+ (distance #XP #AnaPt) #FGSHIFT)))
;-- 2011/09/20 A.Satoh �R�����g�𕜊� - E
      ;;;�V���N�}�` �C���ړ�����.(WT�O�ʂ���r�����ʒu)
      (setq #ss_SNK (CFGetSameGroupSS #sym))
;;;      (command "_.move" #ss_SNK "" "0,0,0" (polar '(0 0 0) (+ (dtr 90) #fSNKang) #move_Y))
;;;      (command "_.move" #ss_SNK "" #AnaPt #pos )
;-- 2011/10/25 A.Satoh Mod - S
      ;X���������l�����Ĉړ�����
;;;;;      (command "_.move" #ss_SNK "" #AnaPt (list (nth 0 #pos) (nth 1 #AnaPt) (nth 2 #AnaPt) ))
			(setq #XP1 (CFGetDropPt #AnaPt (list #p2 #p3)))
			(setq #XP2 (CFGetDropPt #pos (list #p2 #p3)))
			(setq #move_X (- (distance #XP1 #AnaPt) (distance #XP2 #pos)))

		  (if (wcmatch #SNK "B_*") ;2013/04/15 YM ADD-S ����ǉ�
				nil ;B�V���N�͈ʒu�������Ȃ�
				;else
	      (command "_.move" #ss_SNK "" "0,0,0" (polar '(0 0 0) #fSNKang #move_X))
			);_if

;-- 2011/10/25 A.Satoh Mod - E

;-- 2011/09/20 A.Satoh Add - S
			; Y����(�I�t�Z�b�g�ʕ�)�Ɉړ�����
      (command "_.move" #ss_SNK "" "0,0,0" (polar '(0 0 0) (+ (dtr 90) #fSNKang) #move_Y))
;-- 2011/09/20 A.Satoh Add - E
    )
  )
;-- 2011/09/17 A.Satoh Mod - E
;;;01/05/01YM@  ; �I���Z�b�g��n���Đ}�`���̃��X�g�𓾂�.
;;;01/05/01YM@  (setq #en_lis_#ss_SNK  (CMN_ss_to_en #ss_SNK ))
;;;01/05/01YM@  ; "G_LSYM" (�}���_)�g���f�[�^�̕ύX
;;;01/05/01YM@  (SetG_LSYM1 #en_lis_#ss_SNK)

  ; "G_LSYM"(�}���_)�X�V 01/05/01 YM ������
  (ChgLSYM1 #ss_SNK)


  ;// �V���N�}�`�ɐݒ肳��Ă���o�ʁi=�U:���`�F�b�N�̈�j�̏����擾����
  ;// �V���N�L���r�l�b�g�ɐݒ肳��Ă���V���N��t���̈�i�o��=�W�j�̏����擾����
  ;//
  ;//   ---> ��`�̈�}�`:LwPolyLine
;;;  (setq #p-ss (ssget "X" '((-3 ("G_PMEN"))))) ; 00/02/22 YM ��������Ƃ܂���
;;; (setq #p-ss (CFGetSameGroupSS &scab-en)); �����o�[�}�`�I���Z�b�g ��������Ƃ܂��� 00/02/22 YM ADD P��6�ͼݸ�������Ă��邩�炱�̍s�͂���

  (setq #p-ss #ss_SNK) ;  00/02/22 YM ADD ��ňړ������}���ݸ��ٰ�ߑI���
  (setq #pmen6 (PKGetPMEN_NO #sym 6)) ; #sym �ݸ����ِ}�`�� #pmen6

;-- 2011/09/13 A.Satoh Mod - S
;  (setq #area$ (GetLwPolylinePt #pmen8))
  (if (= #pmen8 nil)
    (setq #area$ nil)
    (setq #area$ (GetLwPolylinePt #pmen8))
  )
;-- 2011/09/13 A.Satoh Mod - E
  (setq #pt$   (GetLwPolylinePt #pmen6))
  (setq #loop T)

  ;// �V���N�̊��`�F�b�N�̈悪�V���N�L���r�̃V���N��t���̈���Ɏ��܂��Ă��邩�𕽖ʏ�
  ;// �Ń`�F�b�N����B

;-- 2011/09/13 A.Satoh Mod - S
;  (setq #i 0)
;  (while (and #loop (< #i (length #pt$)))
;    (setq #pt (nth #i #pt$))
;    (if (= -1 (setq #ret (CFAreaInPt #pt (AddPtList #area$))))
;      (setq #loop nil)
;    )
;    (setq #i (1+ #i))
;  )
  (if (/= #area$ nil)
    (progn
      (setq #i 0)
      (while (and #loop (< #i (length #pt$)))
        (setq #pt (nth #i #pt$))
        (if (= -1 (setq #ret (CFAreaInPt #pt (AddPtList #area$))))
          (setq #loop nil)
        )
        (setq #i (1+ #i))
      )
    )
  )
;-- 2011/09/13 A.Satoh Mod - E

  (if (= #loop nil)
    (progn
      (if (or (not #pt$) (not #area$))
        (progn
          (setq #Msg1 "  KPW_PosSink2:���`�F�b�N�̈�̎擾�Ɏ��s���܂���")
          (setq #Msg2
            (strcat "�V���N�L���r�l�b�g�̎�t�̈�̊��`�F�b�N���ł��܂���ł���"
                    "\n�����I�ɔz�u���܂���?")
          )
        ); progn
        (progn
          (setq #Msg1 "  KPW_PosSink2:���`�F�b�N�̈悪�V���N��t�̈�͈̔͂𒴂��Ă��܂�")
          (setq #Msg2 "�V���N�L���r�l�b�g�̎�t�̈�Ɏ��܂�܂���\n�����I�ɔz�u���܂���?")
        ); progn
      )

      (setq #en$ (SKC_ConfSinkChkErr #pt$ #area$))

      ;2008/03/31 YM MOD
;;;      (if (CFYesNoDialog #Msg2)
;;;        (mapcar 'entdel #en$)
;;;        (quit)
;;;      )

      ;2008/03/31 YM MOD
      (mapcar 'entdel #en$)

    ); progn
  ); if

;;; �V���N�}�`����Ԃ�
  #sym
);KPW_PosSink2

;-- 2011/09/09 A.Satoh Del - S
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PK_MakeG_WTR
;;;; <�����T�v>  : �~"G_WTR"���쐬����
;;;; <�߂�l>    : �~�}�`��
;;;; <�쐬>      : 00/07/22 YM
;;;; <���l>      : ��w������ "Z_00_00_00_01" or SKW_AUTO_SECTION 00/09/27 YM
;;;;               NAS-->���}�`��"G_WTHL",MICADO-->�����Ȃ�
;;;;*************************************************************************>MOH<
;(defun PK_MakeG_WTR (
;  &kei   ; ���a
;  &o     ; ���S���W
;  &layer ; ��������w
;  /
;#ELAST ; 02/09/04 YM ADD
;  )
; ; 01/08/07 YM ADD START �a=0�Ή�
; (if (equal &kei 0 0.1)
;   (progn
;     (CFAlertMsg "\n�������̒��a��0mm�ł��B������P�_(����1)�ɒ��a>0��ݒ肵�ĉ������B\n���a30mm�Ƃ��Đ��������쐬���܂��B")
;     (setq &kei 30)
;   )
; );_if
;
;  (entmake ; ���S�_�Ɣ��a�𗘗p���ă\���b�h�̌��ƂȂ�~�����
;    (list
;      '(0 . "CIRCLE")
;      '(100 . "AcDbEntity")
;      '(67 . 0)
;      (cons 8 &layer) ; �ݸ�د�ނƓ����ɂ��� 00/09/19 YM ADD
;;;;      (cons 8 "Z_00_00_00_01") ; �ݸ�د�ނƓ����ɂ��� 00/09/19 YM ADD
;;;;      (cons 8 SKW_AUTO_SECTION) ; "Z_wtbase" 00/09/19 YM DEL
;;;;      '(62 . 2) ; ���F
;;;;      '(62 . 1) ; �ԐF
;      '(62 . 7) ; ���F
;      '(100 . "AcDbCircle")
;      (cons 10 &o) ; ���S�_
;      (cons 40 (/ &kei 2))
;      '(210 0.0 0.0 1.0)
;    )
;  )
; ; 01/11/30 YM ADD-S �������}�`�쐬���Ɋg���f�[�^��t�� Xdata="G_WTHL" (WorkTop HoLe�̗�)
; (setq #eLast (entlast))
; (if (not (tblsearch "APPID" "G_WTHL")) (regapp "G_WTHL"))
;  (CFSetXData #eLast "G_WTHL"
;   (list 0 0 0)
; )
; ; 01/11/30 YM ADD-E �������}�`�쐬���Ɋg���f�[�^��t�� Xdata="G_WTHL" (WorkTop HoLe�̗�)
;
;  #eLast
;);PK_MakeG_WTR
;-- 2011/09/09 A.Satoh Del - E

(princ)