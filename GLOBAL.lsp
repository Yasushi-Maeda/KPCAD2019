;<HOM>*************************************************************************
; <��۰���>   : �O���[�o���ϐ���`
; <�����T�v>  :
;*************************************************************************>MOH<

;;;J	NZ class
;;;B*	NZ������ �F���� J
;;;N*	NZ�y�g �F���� D,F,K
;;;
;;;C	SA class
;;;M*	�؎��� �F���� D,F,K,W
;;;A*	�P�F�E���ە� CA�F���� D,F,K
;;;S*	�P�F�E���ە� �F���� D,F,K,W

;;;		      (setq CG_DRSeriCode  "J")  ;��SERIES�L��
;;;		      (setq CG_DRColCode  "N*")  ;��COLOR�L��
;;;		      (setq CG_HIKITE      "D")  ;HIKITE�L��

;2009/11 ���[�g��
;;;	(setq CG_EP_THICKNESS 0)     ;�������ٌ��ݏ�����
;;;	(setq CG_COUNTER_INFO$$ nil) ;������z�u���(������ڑ��Ɏg�p)---���g�p==>Xdata "G_COUNTER"
;;; CG_LAST ;�ŏI��

;PC_LayoutPlanExec ����SDA,SDB����
;��
;PD_StartLayout_EXTEND
;��
;(PDC_ModelLayout_EXTEND) ���T��J��Ԃ�

;;;PDC_ModelLayout_EXTEND ��
;�������ق̎�t��
;�y�~���[���]�z
;�V��̨װ�̍쐬 (PKW_UpperFiller)

;PKC_LayoutOneParts ������ڑ�(������z�u����)

;���ݑ}��
;(defun C:PC_InsertPlan (
;������ڑ�

;������ڑ� 2009/12/1 YM ADD ���[�g��
;(JOIN_COUNTER)

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
;;;SK45      :��������
;;;SK46      :�V��̨װ

;    SD51      :���j�b�g
;    SD52      :�V���[�Y
;    SD62      :��ذ��
;    SD63      :���J���[
;    SD64      :���
;    SD53      :���s��
;    SD54      :�^�C�v
;    SD55      :���[�Ԍ�
;    SD56      :���E����
;    SD57      :������F
;    SD58      :��ĸ۰��
;    SD59      :��Иg��׽
;    SD71      :��������
;    SD72      :�V��̨װ

;�g�p���Ȃ�
;;;  (setq CG_UnitBase  "1") ;�۱�z�u�׸�
;;;  (setq CG_UnitUpper "1") ;���ٔz�u�׸�
;;;  (setq CG_UnitTop   "1") ;ܰ�į�ߔz�u�׸�
;;;  (setq CG_FilerCode       (cadr (assoc "SKOP04" &family$$))) ;�V��̨װ
;;;  (setq CG_SidePanelCode   (cadr (assoc "SKOP05" &family$$))) ;�������� ; 01/07/11 YM

;<�擾���@>
;(nth 17 CG_GLOBAL$)     ;(STR)�V���N�L��

;�y��v�֐��z
;�v��������
;;;(defun C:SearchPlan (

;�v���������@��۰��ٕϐ����
;;;(defun PKG_SetFamilyCode (

;�v���������@���䌟��
;;;(defun PFGetCompBase (

;�v���������@�݌ˌ���
;;;(defun PFGetCompUpper (

;�v���������@�\�����ޔz�u
;;;(defun PKC_LayoutParts (

;�v���������@�����\�����ޔz�u
;;;(defun PKC_LayoutBlockParts (

;�v���������@[�����Ǘ�][�����\��]����
;;;(defun PKGetSQL_HUKU_KANRI (

;�v���������@�ݸ�z�u
;;;(defun PKC_LayoutSink (

;;;  ;// ��׽�߰è��݂̔z�u 2009/10/26 YM ADD
;;;	(PKW_GLASS_PARTISYON)

;;;  ;// �������ق̎�t��
;;;	(KP_PutEndPanel)

;�v���������@MIRROR���]
;;;(defun PKC_MirrorParts (

;�v���������@�V���������A�V��t�B���[�̍쐬
;;;(defun PK_StartLayout (

;  ;// �V��̨װ�̍쐬
;	(PKW_UpperFiller);���ݓV��̨װ="A"�̂�

;�������ق̎�t��
;;;(defun KP_PutEndPanel (

;�v���������@WT��������
;;;(defun PKW_WorkTop (

;;; ������z�u����(�v��������)
;;;(defun PKW_PosWTR_plan (

;�v���������@WT�������� ��ʐ݌v
;;;(defun PKMakeTeimenPline_I (

;�yܰ�į�ߕi�Ԋm�菈���v�C���z
;;;(defun KPW_DesideWorkTop3 (

;��̈��}
;;;(defun GetMaterialData (

;;; <�����T�v>: �z�u���ނ̎d�l�\����ݒ肷��
;;;(defun SKB_SetSpecList (

;;; <�����T�v>: �d�l�\�ڍ׏����擾����
;;;(defun SKB_GetSpecInfo (

;;; <�����T�v>: �}�ʃ��C�A�E�g
;;;(defun C:SCFLayout (

;;; <�����T�v>: �}�ʘg�̃^�C�g����������l������
;;;(defun SCFGetTitleStr

; <�����T�v>: ���C�A�E�g�o��
;;;(defun SCFLayoutDrawBefore (

; <�����T�v>: ���C�A�E�g�}�쐬  �p�[�X�}
;;;(defun SCFDrawPersLayout (

;;; <�����T�v>: �}�ʘg�̃^�C�g������}����
;;;(defun SCFMakeTitleText

;;;  (list
;;;    (cadr (assoc "ART_NAME"             CG_KENMEIINFO$))  ; ���������́� 0
;;;		(cadr (assoc "PLANNING_NO"          CG_KENMEIINFO$))  ; ���v�����ԍ���1
;;;    (cadr (assoc "VERSION_NO"           CG_KENMEIINFO$))  ; ���ǔԁ�     2
;;;		(cadr (assoc "BASE_BRANCH_NAME"     CG_KENMEIINFO$))  ; ���c�Ə�����  3
;;;    (cadr (assoc "BASE_CHARGE_NAME"     CG_KENMEIINFO$))  ; ���c�ƒS���� 4
;;;    (cadr (assoc "ADDITION_CHARGE_NAME" CG_KENMEIINFO$))  ; ������(�ώZ�S��)��5
;;;    (cadr (assoc "VERNO"      #VER$$))                    ; ���o�[�W������6
;;;    ""                                                    ; �v������
;;;    ""                                                    ; �����R�[�h
;;;		""                                                    ; �戵�X��
;;;		""                                                    ; �}�ʓ��L����
;;;    ""                                                    ; �n��
;;;    ""                                                    ; ��
;;;    ""                                                    ; ���[�N�g�b�v
;;;    ""                                                    ; ���[�N�g�b�v2(�����)
;;;    ""                                                    ; �V�X�e����    ���g�p
;;;    ""                                                    ; ��Ж�        ���g�p
;;;	)


; <�����T�v>  : Table.cfg�̍쐬
;;;(defun SCFMakeBlockTable ( ���@Skb_SetSpecList�@���@SKB_GetSpecInfo�@���@SKB_GetSpecList

;�VTable.cfg
;;;             #i              ; 1.�\�[�g�L�[
;;;             #LAST_HIN       ; 2.�ŏI�i��
;;;							#WWW            ; 3.��
;;;							#HHH            ; 4.����
;;;							#DDD            ; 5.���s
;;;							#HINMEI         ; 6.�i��
;;;             1               ; 7.��
;;;             #KAKAKU         ; 8.���z
;;;             "A10"           ; 9.�W��ID  �V��,������͂��߂���"A10"
;;;             (list #hnd)     ;10.�}�`�n���h��


;;; <�����T�v>: ���C�A�E�g�}�쐬 �d�l�\
;;;(defun SCFDrawTableLayout

; <�����T�v>: �o���[����}
;;;(defun DrawBaloon (


; <�����T�v>  : �W�J�}�̐��@��������
;;;(defun SCFDrawDimensionEx (

;��̈掩���ݒ�
;;;    	(KCFAutoMakeTaimenPlanYashi);P�^�Ȃ��̈掩���ݒ�
;;;			;2008/12/22 YM ADD
;;;			(KCFAutoMakeIgataPlanYashi);I�^�Ȃ��̈掩���ݒ�
;;;			;2008/12/23 YM ADD
;;;			(KCFAutoMakeDiningPlanYashi);���[I�z��Ȃ��̈掩���ݒ�


;;; <�����T�v>: �Q�_�̍��W�Ƃo�_���X�g���琡�@������}���A�������ǉ�����
;;;(defun SCFDrawDimLinAddStr (


;----------------------------------------------------------------------
;�t�@�~���[�i�Ԋ֘A
;----------------------------------------------------------------------
;;;(setq CG_SeriesCode       "PI" )   ;SERIES     HB
;;;(setq CG_BrandCode        "NR" )   ;�u�����h     NR
;;;(setq CG_UnitCode         "K"  )   ;���j�b�g     K
;;;(setq CG_W1Code           "255")   ;�Ԍ�1       180
;;;(setq CG_W2Code           "B"  )   ;�Ԍ�2        A
;;;(setq CG_Type1Code        "S"  )   ;�^�C�v1      S
;;;(setq CG_Type2Code        "F"  )   ;�^�C�v2      F
;;;(setq CG_LRCode           "R"  )   ;LR�敪       L
;;;(setq CG_DRSeriCode       "41" )   ;��SERIES   41
;;;(setq CG_DRColCode        "B"  )   ;��COLOR     Z
;;;(setq CG_UpCabCode        "M"  )   ;UP�L���r�d�l M
;;;(setq CG_LockCOde         "0"  )   ;���b�N�R�[�h 0
;;;(setq CG_WTZaiCode        "SB" )   ;WT�ގ�       SE
;;;
;;;(setq CG_CRCode           "A"  )   ;�R����       1
;;;(setq CG_CRUnderCode      "A"  )   ;�R������     1
;;;(setq CG_RangeCode        "A"  )   ;�����W�t�[�h 0
(setq CG_KCode "K")                ;�H��L��

;;;(setq CG_CeilHeight  2450)         ;�V�䍂��
;;;(setq CG_UpCabHeight 2350)         ;�A�b�p�[�L���r���� ;2013/10/21 YM DEL
(setq CG_WallUnderOpenBoxHeight 2150);�݌ˉ�OPEN BOX�ݒu����
(setq CG_WallUnderOpenBox 200)       ;�݌ˉ�OPEN BOX�̏ꍇ�݌�������������l

(setq CG_BaseSymCol "GREEN")       ;��A�C�e���̐F
(setq CG_InfoSymCol "RED")         ;�ݔ��̊m�F�F
(setq CG_ConfSymCol "MAGENTA")     ;�ݔ��̊m�F�F
(setq CG_WorkTopCol "40")          ;���[�N�g�b�v�i�Ԋm��F

;----------------------------------------------------------------------
;�e�@��̐��iCODE
;----------------------------------------------------------------------
;���iCODE�ꌅ��
(setq CG_SKK_ONE_CAB 1)            ;�L���r�l�b�g
(setq CG_SKK_ONE_GAS 2)            ;�K�X�R����
(setq CG_SKK_ONE_RNG 3)            ;�����W�t�[�h
(setq CG_SKK_ONE_SNK 4)            ;�V���N
(setq CG_SKK_ONE_WTR 5)            ;�����E�򐅊�
(setq CG_SKK_ONE_SID 6)            ;�T�C�h�p�l��
(setq CG_SKK_ONE_CNT 7)            ;�J�E���^�[�V��
(setq CG_SKK_ONE_FIG 8)            ;�}�̂�
(setq CG_SKK_ONE_ETC 9)            ;���̑�
(setq CG_SKK_ONE_KUT 9)            ;���(���@�쐬�ΏۊO) 01/05/15 TM ADD

;���iCODE�񌅖�
(setq CG_SKK_TWO_ETC 0)            ;���̑�
(setq CG_SKK_TWO_BAS 1)            ;�x�[�X
(setq CG_SKK_TWO_UPP 2)            ;�A�b�p�[
(setq CG_SKK_TWO_EYE 3)            ;�A�C���x��
(setq CG_SKK_TWO_MID 4)            ;�~�h��
(setq CG_SKK_TWO_KUT 9)            ;���(���@�쐬�ΏۊO) 01/05/15 TM ADD

;���iCODE�O����
(setq CG_SKK_THR_ETC 0)            ;���̑�
(setq CG_SKK_THR_NRM 1)            ;�ʏ�L���r�l�b�g
(setq CG_SKK_THR_SNK 2)            ;�V���N�L���r�l�b�g
(setq CG_SKK_THR_GAS 3)            ;�K�X�L���r�l�b�g
(setq CG_SKK_THR_TOL 4)            ;�g�[���L���r�l�b�g
(setq CG_SKK_THR_CNR 5)            ;�R�[�i�[�L���r�l�b�g
(setq CG_SKK_THR_HUN 6)            ;�s�R�L���r�l�b�g
(setq CG_SKK_THR_DIN 7)            ;�_�C�j���O�p
(setq CG_SKK_THR_KUT 9)            ;���(���@�쐬�ΏۊO) 01/05/15 TM ADD
; 01/08/31 YM ADD-S
(setq CG_SKK_INT_SUI 510)            ;�����E�򐅊�
(setq CG_SKK_INT_GAS 210)            ;�K�X�R����
(setq CG_SKK_INT_SNK 410)            ;�V���N
(setq CG_SKK_INT_RNG 320)            ;�����W�t�[�h
(setq CG_SKK_INT_RNG_MT 328)         ;�}�E���g�^�����W�t�[�h 02/03/27 YM ADD
(setq CG_SKK_INT_SCA 112)            ;�V���N�L���r
(setq CG_SKK_INT_GCA 113)            ;�R�����L���r
(setq CG_SKK_INT_CNR 115)            ;�R�[�i�[�L���r
(setq CG_SKK_INT_SAK 939)            ;�H��􂢊����@ HN ADD 02/05/31 HN MOD 02/06/05
(setq CG_SKK_INT_KUT 999)            ;��� 03/03/29 YM ADD
; 01/08/31 YM ADD-E
;----------------------------------------------------------------------
;�o�ʗ̈�֘A
;----------------------------------------------------------------------
(setq CG_PSINKTYPE 8)  ; �o�ʃV���N�^�C�v
(setq CG_PSINKCHK  6)  ; �o�ʊ��`�F�b�N

;----------------------------------------------------------------------
;���[�N�g�b�v�֘A
;----------------------------------------------------------------------
(setq CG_WorkLPos nil)                ;���[�N�k�x�[�X�R�[�i�[�L���r�l�b�g�̌��_
(setq CG_BASEPT   nil)                ;���[�N�g�b�v�̊�_

(setq CG_WT_T 23) ; WT�̌���
(setq CG_BG_H 50) ; BG�̍���
(setq CG_BG_T 20) ; BG�̌���
(setq CG_FG_H 40) ; FG�̍���
(setq CG_FG_T 20) ; FG�̌���
(setq CG_FG_S  7) ; �O����V�t�g��

;; �V��t�B���[�p�O���[�o���ϐ�
(setq SKW_FILLER_FRONT 46)            ;�O�����]��
(setq SKW_FILLER_THICK 20)            ;�t�B���[����

(setq SKW_AUTO_SOLID    "Z_00")       ;���������\���b�h�`���w
(setq SKW_TMP_HIDE      "HIDE")       ;��\���p��w 01/05/31 YM ADD
(setq SKW_AUTO_SECTION  "Z_wtbase")   ;���������\���b�h�쐬�p�f�ʐ}�`�`���w
(setq SKW_AUTO_LAY_LINE "CONTINUOUS") ;���������I�u�W�F�N�g�`���w�̐���
(setq SKW_PANEL_LAYER   "Z_01_01_*")  ;���ʓ��͐}�̉�w��
(setq SKW_OPTION_PARTS  nil)          ;�I�v�V�������i���i�[�O���[�o���ϐ�
(setq SKW_UPPER_SYMBOL_HEIGHT nil)    ;�A�b�p�[�L���r�l�b�g�̍����i�[�p�O���[�o���ϐ�

;; ���[�N�g�b�v�^�C�v
;;;(setq SKW_WK_TYPE_SINK    0)          ;�V���N�E�K�X��̑�
;;;(setq SKW_WK_TYPE_GUS     1)          ;�K�X��
;;;(setq SKW_WK_TYPE_OPENGUS 2)          ;�K�X�J����

(setq SKW_SINK_HOLE_CODE  4)          ;�V���N���̈�R�[�h�ԍ�
(setq SKW_COOK_HOLE_CODE  5)          ;�R�������̈�R�[�h�ԍ�
(setq SKW_WATER_HOLE_CODE 5)          ;�������̈�R�[�h�ԍ�
(setq SKW_PMEN_OUT 2)                 ;�e�X�g�p�O�`�̈�ID
(setq SKW_GROUP_CODE "WtOpt_")        ;�O���[�v�����̃w�b�_
(setq SKW_GROUP_NO 0)                 ;�O���[�v�����̃C���f�b�N�X�ԍ�

;; �W�J�}�ԍ��ʒu�̔z�u����
(setq SKW_DEV_X 1)
(setq SKW_DEV_Y 2)

;; �W�J�}�ԍ�LR�敪
(setq SKW_DEV_L 1)
(setq SKW_DEV_R 2)

; ���ς薾�׎���WT����
; 01/09/11 YM ADD-S
;;;(setq SKW_WT_NAME "���[�N�g�b�v")
(setq SKW_WT_NAME "ܰ�į��")
; 01/09/11 YM ADD-E

;----------------------------------------------------------------------
;���ʊ֘A
;----------------------------------------------------------------------
(setq SKD_DOOR_CODE        "DR")          ;���}�`�f�t�H���g������
(setq SKD_DOOR_FILE_EXT    ".DWG")        ;���}�`�f�t�H���g�t�@�C���g���q
(setq SKD_DOOR_VIEW_LAYER1 "Q_")          ;���ʃf�t�H���g�\����w����
(setq SKD_DOOR_VIEW_LAYER2 "_99_")        ;���ʃf�t�H���g�\����w����
(setq SKD_DOOR_VIEW_LAYER3 "_##")         ;���ʃf�t�H���g�\����w����

(setq SKD_GROUP_HEAD  "DoorGroup")        ;�O���[�v���擪������
(setq SKD_GROUP_INFO  "DoorGroup")        ;�O���[�v��������
(setq SKD_MATCH_LAYER "Q_00_99_##_")      ;�f�t�H���g�}�b�`��w��
(setq SKD_BREAK_LINE  "N_BREAK@")         ;�u���[�N���C�����ʃR�[�h
(setq SKD_EXP_APP     "G_DOOR")           ;���}�`�p�A�v���P�[�V�����R�[�h
(setq SKD_TEMP_LAYER  "SKD_TEMP_LAYER")   ;�L�k��Ɨp�e���|������w��
(setq SKD_TEMP_LAYER_0 "SKD_TEMP_LAYER_0");�L�k��Ɨp�e���|������w��(���J��������p)
(setq SKD_TEMP_LAYER_4 "SKD_TEMP_LAYER_4");�L�k��Ɨp�e���|������w��(���J��������p)
(setq SKD_TEMP_LAYER_6 "SKD_TEMP_LAYER_6");�L�k��Ɨp�e���|������w��(���J��������p)
(setq DOOR_OPEN "DOOR_OPEN")              ;���J�������(����)�̉�w
(setq DOOR_OPEN_04 "DOOR_OPEN_04")        ;���J�������(�w��)�̉�w
(setq DOOR_OPEN_06 "DOOR_OPEN_06")        ;���J�������(�E����)�̉�w

(setq SKD_GROUP_NO 0)                     ;�O���[�v���A��

(setq CG_AutoAlignDoor T)                 ;�ݔ��z�u�֘A�R�}���h�ɂĎ������\��t��

;----------------------------------------------------------------------
;�T�C�h�p�l���֘A
;----------------------------------------------------------------------

;02/06/18 YM MOD-S
(setq CG_PanelThk     17.)                ;�T�C�h�p�l���̌��� ; 02/06/18 YM
;;;(setq CG_PanelThk     20.)                ;�T�C�h�p�l���̌��� ; 01/08/01 YM
;02/06/18 YM MOD-E

;;;01/08/01YM@(setq CG_PanelThk     19.)                ;�T�C�h�p�l���̌���
(setq CG_PANEL_OFFSET 0.0)                ;�p�l���I�t�Z�b�g 18mm-->0mm
;;;01/12/17YM@MOD(setq CG_PANEL_OFFSET 18.)                ;�p�l���I�t�Z�b�g

;----------------------------------------------------------------------
;�d�l�\�o���[���֘A
;----------------------------------------------------------------------
(setq CG_REF_SIZE   60.)                  ;�o���[���~���a
(setq CG_BALOONTYPE 7)                    ;�o���[�������o�_�^�C�v

;----------------------------------------------------------------------
;��A�C�e���Ȃǂ̖��y�ѐF��`
;----------------------------------------------------------------------
(setq CG_AXISCOLOR       1)      ;���̐F
(setq CG_AXISARWCOLOR    6)      ;�����̐F
(setq CG_AXISARWCOLOR2   4)      ;�����̐F
(setq CG_AXISARWLEN    100)      ;�����̐�[����
(setq CG_AXISARWANG     30)      ;�����̐�[����
(setq CG_AXISARWRAD     50)      ;�����_�̔��a

(setq CG_SAXISCOLOR      4)      ;���̐F
(setq CG_SAXISARWCOLOR   4)      ;�����̐F
(setq CG_SAXISARWCOLOR2  4)      ;�����̐F
(setq CG_SAXISARWLEN    60)      ;�����̐�[����
(setq CG_SAXISARWANG    30)      ;�����̐�[����
(setq CG_SAXISARWRAD    30)      ;�����_�̔��a

;--------------------------------------------------------------------------
;�e��O���[�o���ݒ�
;--------------------------------------------------------------------------
(setq CG_LOGDSP     nil)         ;���O����ʕ\�����邩
(setq CG_STRETCH    T)           ;���ސL�k�����邩
(setq CG_MKWORKTOP  T)           ;���[�N�g�b�v�E�t�B���[�������邩
(setq CG_MKDOOR     T)           ;���\�t�����������邩
(setq CG_MKBALOON   T)           ;�o���[�������z�u���������邩
(setq CG_TENKAI     T)           ;�W�J���������邩

;-- 2011/10/19 A.Satoh Add - S
(setq CG_PARSU_DWG_STR "����")  ; �p�[�X�}�ʎ��ʕ���
(setq CG_DWG_VER_MODEL "2007")  ; �}�ʕۑ�����DWG�o�[�W����
(setq CG_DWG_VER_SEKOU "2000")  ; �}�ʕۑ�����DWG�o�[�W����
;-- 2011/10/19 A.Satoh Add - E

;--------------------------------------------------------------------------
; �V���N�ʒu�f�t�H���g
(setq CG_WSnkOf 65)
;--------------------------------------------------------------------------

;2016/08/30 YM ADD-S
;�����i��
;;;(setq CG_TOKU_HINBAN "ZZ6500")
;;;(setq CG_TOKU_HINBAN "ZZ6500-Dĸ����޻޲(D)")
(setq CG_TOKU_HINBAN      "ZZ6500-D");�@��ȊO
(setq CG_TOKU_HINBAN_PSKC "ZZ6500-D");�@��ȊO PSKC ;2018/0727 YM ADD
(setq CG_TOKU_HINBAN_PSKD "ZZ6500-E");�@��ȊO PSKD ;2018/0727 YM ADD
(setq CG_TOKU_HINBAN_LWCT "ZZ6500-E");�t���[���L�b�`���̏W���J�E���^�[
(setq CG_TOKU_HINBAN_KIKI "ZZ6500-H");�@��̂� 2016/10/06 YM ADD
;;;(setq CG_TOKU_HINMEI "�������ށi�c�j")
;;;(setq CG_TOKU_HINMEI "ĸ����޻޲(D)")
(setq CG_TOKU_HINMEI "ĸ(D)")
;2016/08/30 YM ADD-E

;2017/07/10 �t���[���L�b�`�����b�Z�[�W
(setq CG_FK_MSG1 "���݂̼ذ�ނł��̺���ނ͎g�p�ł��܂���.")

(princ)

