
(defun C:uu()
  (command "undo" "b" )
)
(defun C:de1() ; ���ޯ��Ӱ�ނɂ���
  (Setq CG_DEBUG 1)
)
(defun C:de0() ; հ�ްӰ�ނɂ���
  (Setq CG_DEBUG nil)
)

;;---------------------------------------------------------
;;;�֐������p
;;;(defun PK_MakePMEN2 PMEN2���쐬���ļ���ق̸�ٰ�����ް�Ƃ���
;;;(defun PKGetWT$FromMRWT ��ԉEWT==>�E���珇�Ɋ֘AWTؽĂ�Ԃ�
; ��ԉE�̂v�s
;;;(defun PKGetMostRightWT WT�}�`����n���Ĉ�ԉE��WT��Ԃ�
;;;(defun PKGetWTLEN$ 650�~650 �̏ꍇ���Ӑ��@,�Z�Ӑ��@�̏�
;;;                   750�~650,650�~750�̏ꍇ750������
;;;                   ���̑��̏ꍇ���Ӑ��@,�Z�Ӑ��@�̏�

;;;(defun PKFind_HINBAN_AreaCP  �̈�_��ؽ�,�i�Ԗ��̂�n���ė̈���̓��i�Լ���ِ}�`��ؽĂ�Ԃ�
;;;(defun PKSStoMRWT$           WT�I���-->�ŉEWT�}�`ؽĂɕϊ�
;;;(defun PKGetSuisenAna        WT�}�`��n���Đ�������(���S���W,���a,����������)��Ԃ�
; WT�̈淬�ސ��@
;;;(defun PK_GetWTUnderCabDimCP ܰ�į�ߐ}�`�I��Ă�n���āA�̈���ɂ��鷬��ȯĐ��@�v�����Ԃ�
;;;(defun PKWTCabDim_I          ����ȯĐ��@�v�����Ԃ�(I�^)
;;;(defun PKWTCabDim_L          ����ȯĐ��@�v�����Ԃ�(L�^)
;;;(defun PKWTCabDim_U          ����ȯĐ��@�v�����Ԃ�(U�^)
; �֘A�v�s
;;;(defun PKGetWTSSFromWTEN     ܰ�į�ߐ}�`--->�֘AWT�I���
;;;(defun PK_WTSStoPlPt         ܰ�į�ߐ}�`�I��Ă�n���āA���̊O�`�_���߂�
;;;(defun PKDelWkTopONE         ����WT�Ƃ��̼ݸ,����,BG,��ʂ݂̂��폜(�֘AWT�͍폜���Ȃ�)
;;;(defun DelAppXdata           �}�`�� &en �̊g���ް�(APP�� &app)����������
;;;(defun CMN_VAL_MINMAX        �����l�̃��X�g����ő�,�ŏ��l�����߂�  ���g�p
;;;(defun PKGetPMEN_NO          ����ِ}�`,PMEN�ԍ���n����PMEN(&NO)�}�`���𓾂�
;;;(defun PKGetPTEN_NO          ����ِ}�`,PTEN�ԍ���n����PTEN(&NO)�}�`���𓾂�
;;;(defun PKGetWTSymCP          �̈�_��ؽĂ�n���ė̈�Ɋ܂܂��v�s����������
;;;(defun PKGetHinbanSSCP       �̈�_��ؽĂ�n���ė̈�Ɋ܂܂��A�ݸ��߰ļ��т���������
;;;(defun PKGetSinkSuisenSymCP  �̈�_��ؽĂ�n���ė̈�Ɋ܂܂��A�V���N,��������������
;;;(defun PKGetG_WTRCP �̈�_��ؽĂ�n���ė̈�Ɋ܂܂��A"G_WTR"����������
;;;(defun PKGetSinkSymBySinkCabCP �ݸ���ޗ̈�Ɋ܂܂��ݸ����������
;;;(defun PKGetSuisenSymBySinkCabCP �ݸ���ޗ̈�Ɋ܂܂�鐅������������
;;;(defun PKGetGasSymByGasCabCP ��۷��ޗ̈�Ɋ܂܂���ۂ���������
;;;(defun PKGetSymBySKKCodeCP   �̈�_��ؽ�,���i���ނ�n���ė̈���̼���ِ}�`��ؽĂ�Ԃ�
;;;(defun PKGetBaseSymCP        �̈�_��ؽĂ�n���ė̈�����ް�����(11?)����ِ}�`��ؽĂ�Ԃ�
;;;(defun PKGetLowCabSym        ����ِ}�`��ؽĂ�n����۰���޼���ِ}�`��ؽĂ�Ԃ�
;;;(defun StrLisToRealLis       ������ؽĂ������lؽĂɂ���
;;;(defun StrToLisBySpace       �������space�ŋ�؂���ؽĉ�����
;;;(defun StrToLisByBrk         �������#brk�ŋ�؂���ؽĉ�����
;;;(defun GetPtSeries           �������ײ݊O�`�_����A�_�����&base��擪�Ɏ��v����ɂȂ�ׂ�
;;;(defun PCW_ChColWT           ܰ�į�ߐ}�`����n���āA�֘AWT�̐F�ς����s��.
;;;(defun RotatePoint           &pt�����_���S��#rad��]����
;;;(defun FromSSDelEnLis        �I��Ă���}�`��ؽĂɂ���}�`�����O����
;;;(defun MakeTempLayer         �L�k��Ɨp�e���|������w�̍쐬
;;;(defun BackLayer             (<�}�`��> ��w)�����ɁA��w��SKD_TEMP_LAYER���猳�ɖ߂�
;;;(defun Chg_SStoEnLayer       �I���--->(<�}�`��> ��w)��ؽĂ�ؽĂɕϊ�
;;;(defun CMN_select_element    �v�f�𕡐���I��(entsel)���đI���Z�b�g��Ԃ�  ���O�̑I���������\
;;;(defun SetG_LSYM1
;;;(defun SetG_LSYM11
;;;(defun SetG_LSYM2
;;;(defun SetG_LSYM22
;;;(defun SetG_PRIM1
;;;(defun SetG_PRIM11
;;;(defun SetG_PRIM22
;;;(defun SetG_BODY

;;;(defun CMN_ss_to_en  �I���Z�b�g��n���Đ}�`���̃��X�g�𓾂�.
;;;(defun CMN_ssaddss   old�I���Z�b�g��new�I���Z�b�g�ǉ����ĐV�����I���Z�b�g���쐬.
;;;(defun CMN_enlist_to_ss  �}�`���̃��X�g����I���Z�b�g���쐬
;;;(defun CMN_all_en_list   �}�ʏ�̑S�Ă̐}�`���̃��X�g(�Â���)��߂��B
;;;(defun CMN_subs_elem_list ���X�g(&list$)��"&i"(0,1,2...)�Ԗڂ̗v�f��"&element"�ɕύX����.
;;;(defun CMN_search_en_lis  �}�`�����A�}�`�����X�g�̉��Ԗڂɂ��邩.
;;;(defun advance (&val &nick / #ret) &val ��150���݂ɂ��� �� 2325--->2400 �A��0-->0
;;;(defun DBCheck  �c�a�����`�F�b�N����

;;;(defun AddPline
;;;(defun GetLwPolyLineStEnPt   ���C�g�E�F�C�g�|�����C���̎n�_�A�I�_���擾����
;;;(defun MakeLWPL              ����0��LWPOLYLINE������
;;;(defun ListEdit
;;;(defun ListDel               ����1(ؽ�)�������2(ؽ�)�̗v�f���폜
;;;(defun GroupInSolidChgCol2   �}�`��F�ւ�����
;;;(defun GetMinMaxLineToPT$    ���ײ݂̊e�_�Ɛ���(�n�_,�I�_)�Ƃ̋����̍ŏ��l,�ő�l��ؽĂ�Ԃ�
;;;(defun FlagToList (  &int / )    3���̐�����0�����X�g��
;;;(defun PKGetWT_outPT (&WT / #pt$) ܰ�į�ߐ}�`����n���ĊO�`�_���߂� �_��(�n�_�𖖔��ɒǉ��ς�)
;;;(defun AddPtList (&pt$ / )�_��̖����Ɏn�_�������ĕԂ�
;;;(defun NotNil_length ( &lis / #kosu) list��nil�łȂ��v�f����Ԃ�
;;;(defun NilDel_List  ؽĂ���nil������
;;;(defun PKDirectPT  �_��̊e�_���S�Ē����̓������ɂ���� nil
;;;(defun MakeRectanglePT ���S&pt,�ӂ̒���&a*2�̐����`�O�`�_��(�����Ɏn�_��ǉ�)��Ԃ�
;;;(defun KCGetZaiF       �ގ��L������f��F���擾����
;;;(defun c:all �@�@�@�@�@�I�������}�`�̸�ٰ�����ް�̑S�}�`�����߁A����فA�g���ް���\��
;;;(defun c:oya�@�@�@�@�@�I�������}�`�̐e�}�`����\��
;;;(defun C:ALP( / )�@KPCAD �S�Ẳ�w��\��
;;;(defun C:HCOL�@�@�@�}�`����ق����--->���̐}�`���ԂɂȂ�
;;;(defun C:ddd ( / ) KPCAD�@c:alp�̌�ɉ�w�����ɖ߂��R�}���h
;;;(defun c:PTN(�@�@�}�ʏ��"G_PRIM"�̒�ʐ}�`����������Ă���Ă��Ȃ����т̐}�`ID��T��
;;;(defun c:clZ �}�ʂ̃S�~�폜
;;;(defun c:PM2N (�@�@�@�}�ʏ��"G_PMEN"2����Ă���Ă��Ȃ����т̐}�`ID��Ԃ�
;;;(defun c:ChgSKK      �I�����ꂽ�A�C�e���̐��iCODE��ύX����B



;;---------------------------------------------------------

(setq CG_ZMOVEDIST 1000.) ; Z�ړ����� ��̫�Ēl
(setq CG_CABCUT      50.) ; ��ʂ���̷���ȯĶ�Ĉʒu

;;;<HOM>*************************************************************************
;;; <�֐���>     : PKExtendPTAreaRL100mm
;;; <�����T�v>   : PMEN2���쐬���ļ���ق̸�ٰ�����ް�Ƃ���
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 00/06/19 YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun PKExtendPTAreaRL100mm (
  &pt$ ; �O�`�̈�_��(�n�_�𖖔��ɒǉ�����5�_)
  &LR  ; ������
  /
  #P1 #P2 #P3 #PA #PB #PT$ #PTSET
  )
  (setq #pt$ '())

  (if (= &LR "L")
    (progn
;;;p1+----------------+p2
;;;  |
;;;  |
;;;  |
;;;p3+
      (setq #p1 (nth 0 &pt$))
      (setq #p2 (nth 1 &pt$))
      (setq #p3 (last  &pt$))
      (setq #pA (polar #p1 (angle #p2 #p1) 100))
      (setq #pB (polar #p3 (angle #p2 #p1) 100))
      (foreach #pt &pt$
        (cond
          ((< (distance #pt #p1) 0.1)
            (setq #ptset #pA)
          )
          ((< (distance #pt #p3) 0.1)
            (setq #ptset #pB)
          )
          (T
            (setq #ptset #pt)
          )
        );_cond
        (setq #pt$ (append #pt$ (list #ptset)))
      )
    )
  );_if

  (if (= &LR "R")
    (progn
;;;p1+----------------+p2
;;;                   |
;;;                   |
;;;                   |
;;;                   +p3
      (setq #p1 (nth 0 &pt$))
      (setq #p2 (nth 1 &pt$))
      (setq #p3 (nth 2 &pt$))
      (setq #pA (polar #p2 (angle #p1 #p2) 100))
      (setq #pB (polar #p3 (angle #p1 #p2) 100))
      (foreach #pt &pt$
        (cond
          ((< (distance #pt #p2) 0.1)
            (setq #ptset #pA)
          )
          ((< (distance #pt #p3) 0.1)
            (setq #ptset #pB)
          )
          (T
            (setq #ptset #pt)
          )
        );_cond
        (setq #pt$ (append #pt$ (list #ptset)))
      )
    )
  );_if
  #pt$
);PKExtendPTAreaRL100mm

;;;<HOM>*************************************************************************
;;; <�֐���>     : PK_MakePMEN2
;;; <�����T�v>   : PMEN2���쐬���ļ���ق̸�ٰ�����ް�Ƃ���
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 00/06/19 YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun PK_MakePMEN2 (
  &sym ;(ENAME)�ݸ����ِ}�`
  /
  #ANG #D #P1 #P2 #P3 #P4 #PMEN2 #W #GRNAME
  )
  (setq #p1 (cdr (assoc 10 (entget &sym))))      ; ����ي�_���W
  (setq #ang (nth 2 (CFGetXData &sym "G_LSYM"))) ; �z�u�p�x
  (setq #W   (nth 3 (CFGetXData &sym "G_SYM")))  ; ���@W
  (setq #D   (nth 4 (CFGetXData &sym "G_SYM")))  ; ���@D
  (setq #p2 (polar #p1 #ang #W))
  (setq #p3 (polar #p2 (- #ang (dtr 90)) #D))
  (setq #p4 (polar #p1 (- #ang (dtr 90)) #D))
  (setq #GRname (SKGetGroupName &sym))      ; ��ٰ�ߖ��擾

  (setq #pmen2 (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))
  (entmod (subst (cons 8 "Z_01_02_00_02") (assoc 8 (entget #pmen2)) (entget #pmen2)))
  (CFSetXData #pmen2 "G_PMEN" (list 2 0 0)) ; "G_PMEN" 2 �̃Z�b�g
  (command "_.-group" "A" #GRname #pmen2 ""); #pmen2 �� &sym �Ɠ�����ٰ�߂ɂ���

  (setq #pmen2 (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))
  (entmod (subst (cons 8 "Z_01_03_00_12") (assoc 8 (entget #pmen2)) (entget #pmen2)))
  (CFSetXData #pmen2 "G_PMEN" (list 2 0 0)) ; "G_PMEN" 2 �̃Z�b�g
  (command "_.-group" "A" #GRname #pmen2 ""); #pmen2 �� &sym �Ɠ�����ٰ�߂ɂ���

  #pmen2
);PK_MakePMEN2

;;;<HOM>*************************************************************************
;;; <�֐���>     : KP_MakeCornerPMEN2
;;; <�����T�v>   : ��Ű����PMEN2�̒��_�����s���Ȃ�č쐬���ļ���ق̸�ٰ�����ް�Ƃ���
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 01/04/11 YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun KP_MakeCornerPMEN2 (
  &sym ;(ENAME)��Ű���޼���ِ}�`
  /
  #EN #GRNAME #I #LAYER #P1 #P2 #P3 #P4 #P5 #P6 #PMEN$ #PMEN2 #PT$ #SS #XD$ #flg #pmen2$
#LAST ; 02/09/04 YM ADD
  )
  (setq #flg nil)
  (setq #pmen2$ nil)
  (setq #ss (CFGetSameGroupSS &sym))
  (setq #i 0)
  (setq #pmen$ nil)
  (while (< #i (sslength #ss))
    (setq #en (ssname #ss #i)) ; �����ٰ��
    (if (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
      (if (= 2 (car #xd$))
        (setq #pmen$ (append #pmen$ (list #en)))
      );_if
    );_if
    (setq #i (1+ #i))
  )
  (foreach #pmen #pmen$
    (setq #layer (assoc 8 (entget #pmen)))
    (setq #pt$ (GetLWPolyLinePt #pmen)) ; �ݸ����PMEN2 �O�`�̈�
    (if (< 6 (length #pt$)) ; ���_���s��
      (progn
        (setq #p1 (nth 0 #pt$))
        (setq #p2 (nth 1 #pt$))
        (setq #p3 (nth 2 #pt$))
        (setq #p4 (nth 3 #pt$))
        (setq #p5 (nth 4 #pt$))
        (setq #p6 (nth 5 #pt$))

        ; �n�_�I�_������_�̂Ƃ��̂ݏI�_���Ԉ������� 01/05/22 YM ADD
        (setq #last (last #pt$))
        (if (and (= (length #pt$) 7)(< (distance #p1 #last) 0.1))
          (progn
            (setq #GRname (SKGetGroupName &sym))      ; ��ٰ�ߖ��擾
            (setq #pmen2 (MakeLWPL (list #p1 #p2 #p3 #p4 #p5 #p6) 1))
            (setq #pmen2$ (append #pmen2$ (list #pmen2))) ; 01/06/19 YM ADD
            (entmod (subst #layer (assoc 8 (entget #pmen2)) (entget #pmen2)))
            (CFSetXData #pmen2 "G_PMEN" (list 2 0 0)) ; "G_PMEN" 2 �̃Z�b�g
            (command "_.-group" "A" #GRname #pmen2 ""); #pmen2 �� &sym �Ɠ�����ٰ�߂ɂ���
            (entdel #pmen) ; ���_���s��PMEN2���폜
          )
          (setq #flg T)
        );_if
      )
    );_if
  );foreach

  (if #flg
    (princ (strcat "\n�L���r�l�b�g�̊O�`�̈�(PMEN2)�̒��_��������������܂���B"
      "\n���[�N�g�b�v�����������ɕs����������܂��B"))
;;;   (CFAlertMsg (strcat "�L���r�l�b�g�̊O�`�̈�(PMEN2)�̒��_��������������܂���B"
;;;     "\n���[�N�g�b�v�����������ɕs����������܂��B"))
  );_if
  #pmen2$ ; nil or �V�����쐬����PMEN2
);KP_MakeCornerPMEN2

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetWT$FromMRWT
;;; <�����T�v>  : ��ԉEWT==>�E���珇�Ɋ֘AWTؽĂ�Ԃ�
;;; <�߂�l>    : WT�}�`ؽ�
;;; <�쐬>      : 2000.6.21 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKGetWT$FromMRWT (
  &WTMR
  /
  #WT$ #WTL #WTXD$ #WTXD0$
  )
  (setq #WT$ '())
  (setq #WT$ (append #WT$ (list &WTMR)))
  (setq #wtxd$ (CFGetXData &WTMR "G_WRKT"))
  ;;; ��đ��荶
  (setq #WTL (nth 47 #wtxd$))    ; ��WT�}�`�����
  (while (and #WTL (/= #WTL "")) ; ����WT�������
    (setq #WT$ (append #WT$ (list #WTL)))
    (setq #wtxd0$ (CFGetXData #WTL "G_WRKT"))
    (setq #WTL (nth 47 #wtxd0$))     ; �X�ɍ��ɂ��邩
    (if (= #WTL "") (setq #WTL nil)) ; �Ȃ������� nil
  )
  #WT$
);PKGetWT$FromMRWT

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetMostRightWT
;;; <�����T�v>  : WT�}�`����n���Ĉ�ԉE��WT��Ԃ�
;;; <�߂�l>    : (WT�}�`��,�׸� 0:���ڽ or �ڑ��Ȃ� 1:���ڑ�����)
;;; <�쐬>      : 05/23 YM
;;; <���l>      : ���ڽ or ���E�ڑ����Ȃ�WT�̏ꍇ��nil��Ԃ�
;;;*************************************************************************>MOH<
(defun PKGetMostRightWT (
  &WT ; WT�}�`��
  /
  #RET #WTR #WTXD$ #WTXD0$ #FLG
  )
  (setq #wtxd$ (CFGetXData &WT "G_WRKT"))
  (cond
    ((and (= (nth 47 #wtxd$) "")(= (nth 48 #wtxd$) "")); ���E��WT���Ȃ��ꍇ
      (setq #ret &WT)
      (setq #flg 0)
    )
    ((and (/= (setq #WTR (nth 48 #wtxd$)) "") ; �EWT�}�`����ق����݂�
           #WTR)                              ;00/08/07 SN MOD nil�̏ꍇ������B
    ;((/= (setq #WTR (nth 48 #wtxd$)) "") ; �EWT�}�`����ق����݂���
      (setq #flg 1)
      (while (and #WTR (/= #WTR ""))
        (setq #ret #WTR)
        (setq #wtxd0$ (CFGetXData #WTR "G_WRKT"))
        (if (= (nth 48 #wtxd0$) "")
          (setq #WTR nil) ; �����E�ɂȂ��ꍇ
          (setq #WTR (nth 48 #wtxd0$))
        );_if
      );_while
    )
    (T
      (setq #flg 1)
      (setq #ret &WT) ; ����WT����ԉE
    )
  );_cond
  (list #ret #flg)
);PKGetMostRightWT

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetWTLEN$
;;; <�����T�v>  : 650�~650 �̏ꍇ���Ӑ��@,�Z�Ӑ��@�̏�
;;;               750�~650,650�~750�̏ꍇ750������
;;;               ���̑��̏ꍇ���Ӑ��@,�Z�Ӑ��@�̏�
;;; <�߂�l>    : WT����ؽ�
;;; <�쐬>      : 00/06/02 YM
;;; <���l>      : ���ڽL�^��p
;;;*************************************************************************>MOH<
(defun PKGetWTLEN$ (
  &dep1; �ݸ�����s��
  &dep2; ��ۑ����s��
  &WTLEN1; �ݸ��WT����
  &WTLEN2; ��ۑ�WT����
  /
  #WTLEN$
  )
  (cond
    ((and (equal &dep1 650 0.1)(equal &dep2 650 0.1)) ; 650�~650 ����͐�
      (if (>= &WTLEN1 &WTLEN2) ; 650�~650 �̏ꍇ���Ӑ��@,�Z�Ӑ��@�̏��ɂ���
        (setq #WTLEN$ (list &WTLEN1 &WTLEN2))
        (setq #WTLEN$ (list &WTLEN2 &WTLEN1))
      );_if
    )
    ((and (equal &dep1 750 0.1)(equal &dep2 650 0.1)) ; 750�~650 ����͐�
      (setq #WTLEN$ (list &WTLEN1 &WTLEN2))
    )
    ((and (equal &dep1 650 0.1)(equal &dep2 750 0.1)) ; 650�~750 ���̏����H
      (setq #WTLEN$ (list &WTLEN2 &WTLEN1))
    )
    (T
      (if (>= &WTLEN1 &WTLEN2) ; ���Ӑ��@,�Z�Ӑ��@�̏��ɂ���
        (setq #WTLEN$ (list &WTLEN1 &WTLEN2))
        (setq #WTLEN$ (list &WTLEN2 &WTLEN1))
      );_if
    )
  );_cond
  #WTLEN$
);PKGetWTLEN$

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKFind_HINBAN_AreaCP  ;;;KSPX090AB
;;; <�����T�v>  : �̈�_��ؽ�,�i�Ԗ��̂�n���ė̈���̓��i�Լ���ِ}�`��ؽĂ�Ԃ�
;;; <�߂�l>    : ����ِ}�`ؽ�
;;; <�쐬>      : 2000.5.31 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;               ���т̼���ق��̈�����Ɋ܂܂��Ƃ��̂݃J�E���g����
;;;*************************************************************************>MOH<
(defun PKFind_HINBAN_AreaCP (
  &pt$
  &HINBAN
  /
  #HINBAN #I #SS #SYM #SYM$
  )
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; �̈���̊e�����
            (setq #hinban (nth 5 (CFGetXData #sym "G_LSYM")))
            (if (wcmatch #hinban &HINBAN) ; �i�Ԗ���
              (setq #sym$ (append #sym$ (list #sym))) ; �}���_
            )
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if
  #sym$ ; ����ِ}�`ؽ�
);PKFind_HINBAN_AreaCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKSStoMRWT$
;;; <�����T�v>  : WT�I���-->�ŉEWT�}�`ؽĂɕϊ�
;;; <�߂�l>    : �ŉEWT�}�`ؽĂɕϊ�
;;; <�쐬��>    : 00/06/02 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKSStoMRWT$ (
  &wtSS          ;(PICKSET)���[�N�g�b�v�̑I���Z�b�g
  /
  #I #K #MRWT #MRWT$ #RELSS #SSWT #WT
  )

  (setq #MRWT$ '())
  (setq #relSS (ssadd)) ; ��̑I��� �����ς�WT���i�[
  (setq #i 0)
  (repeat (sslength &wtSS)
    (setq #WT (ssname &wtSS #i)) ; �eWT
    (if (= nil (ssmemb #WT #relSS)) ; �����ς݂łȂ�
      (progn
        (setq #ssWT (PKGetWTSSFromWTEN #WT)) ; �֘AWT�I���
        (setq #k 0)
        (repeat (sslength #ssWT)
          (ssadd (ssname #ssWT #k) #relSS) ; �����ς�
          (setq #k (1+ #k))
        )
        (setq #MRWT (car (PKGetMostRightWT #WT))) ; �ł��EWT
        (setq #MRWT$ (append #MRWT$ (list #MRWT)))
      )
    );_if
    (setq #i (1+ #i))
  );_repeat
  #MRWT$
);PKSStoMRWT$

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKOutputWTCT
;;; <�����T�v>  : �}�ʏ�ɁA"G_WTCT","G_WTSET"����Ă��ꂽWT������΁A
;;;               WT�i�Ԃ�"G_WTCT"�̓��e��","�ŋ�؂����������S��&cfg�ɏo�͂���
;;; <�߂�l>    : (T:�o�͂��� or nil:�o�͂��Ȃ�����)
;;; <�쐬>      : 05/24 YM
;;; <���l>      : 00/05/29 HN �������폜
;;;*************************************************************************>MOH<
(defun PKOutputWTCT (
  /
  #sFile #BRK #CTXD$ #ELM #F #I #N #OUTSTR #SS #SS0 #STXD$ #WT #lis$ #FLG
  )
  (setq #sFile (strcat CG_KENMEI_PATH "WorkTop.cfg"))
  (setq #flg nil #lis$ nil)
  (setq #ss (ssget "X" '((-3 ("G_WTCT"))))) ; �}�ʏ�̓���ܰ�į�� "G_WTCT"
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn ; 1�ȏ゠����
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #WT (ssname #ss #i))
            (if (and (CFGetXData #WT "G_WTCT")
                     (CFGetXData #WT "G_WTSET"))
              (setq #lis$ (append #lis$ (list #WT))) ; �o�͑Ώ�WTؽ�
            )
            (setq #i (1+ #i))
          );_repeat

          (if (> (length #lis$) 0)
            (progn ; �o�͂�����̂�1�ȏ゠����
              (setq #f (open #sFile "W")) ; �㏑��Ӱ��̧�ٵ����
              (setq #i 0)
              (foreach #WT #lis$
                (setq #ctxd$ (CFGetXData #WT "G_WTCT"))
                (setq #stxd$ (CFGetXData #WT "G_WTSET"))
                (setq #outstr (nth 1 #stxd$)) ; WT�i��--->�o�͕�����
                (setq #brk ",")
                (setq #n 0)
                (repeat (length #ctxd$)
                  (setq #elm (nth #n #ctxd$)) ; �e�v�f
                  (if (numberp #elm) ; ���� or �������ǂ���
                    (setq #elm (itoa (fix (+ #elm 0.00001)))) ; ������
                  );_if
                  (setq #outstr (strcat #outstr #brk #elm))
                  (setq #n (1+ #n))
                );repeat
                (princ #outstr #f)
                (princ "\n" #f)
                (setq #i (1+ #i))
              );_foreach
              (close #f) ; �㏑������
              (setq #flg T)
            )
          );_if
        )
      );_if
    )
  );_if
  #flg
);PKOutputWTCT

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetSuisenAna
;;; <�����T�v>  : WT�}�`��n���Đ�������(���S���W,���a,����������)��Ԃ�
;;;               ���������Ȃ��� nil��Ԃ�
;;; <�߂�l>    : (���S���W,���a,����������)��ؽ�  ���̌����珇�� --->(���S���W,���a) 05/22 YM
;;; <�쐬>      : 05/20 YM
;;; <���l>      : �I��WT�̗̈�ɂͼݸ���ނ͂P�Ɖ��肵�Ă���
;;;*************************************************************************>MOH<
(defun PKGetSuisenAna (
  &enWT  ;WT�}�`��
  /
  #ANA$ #ANA$$ #ANG #BASEPT #EN #ET #PX #PY #RET$
  #I #KOSU #O #OX #PMEN2 #PT$ #R #SNKCAB #SS #WTRXD$ #X1 #Y1 #ZOKU
  )
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart)
;;; (command "vpoint" "0,0,1")
  (setq #ret$  '())
  (setq #ana$  '())
  (setq #ana$$ '())

  (setq #pt$ (PKGetWT_outPT &enWT 1))                   ; WT�O�`�_��(�n�_�����ǉ�) ; 01/08/10 YM ADD(�����ǉ�)
  (setq #snkCAB (car (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_GAS)))   ; �ݸ���޼���ِ}�` ; 01/08/31 YM MOD 210-->��۰��ى�
  (if #snkCAB
    (progn
      (setq #basePT (cdr (assoc 10 (entget #snkCAB))))  ; �}����_
      (setq #pmen2 (PKGetPMEN_NO #snkCAB 2))            ; �ݸ����PMEN2
      (if (= #pmen2 nil)
        (setq #pmen2 (PK_MakePMEN2 #snkCAB))            ; PMEN2 ���Ȃ���΍쐬
      );_if
      (setq #pt$ (GetLWPolyLinePt #pmen2))              ; �ݸ����PMEN2 �O�`�̈�
      (setq #pt$ (AddPtList #pt$))                      ; �����Ɏn�_��ǉ�����
      (command "_layer" "T" "Z_wtbase" "")
      (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_WTR"))))) ; �̈���� G_WTR
      (command "_layer" "F" "Z_wtbase" "")
      ;;; հ�ް���W�n���p
      (setq #ang (nth 2 (CFGetXData #snkCAB "G_LSYM"))) ; �ݸ���ޔz�u�p�x
      (setq #x1 (polar #basePT #ang 1000))
      (setq #y1 (polar #basePT (+ #ang (dtr 90)) 1000))
      (command "._ucs" "3" #basePT #x1 #y1)             ; հ�ް���W�n

      (if #ss ; "G_WTR" ����������
        (progn
          (setq #kosu (sslength #ss))                   ; ����
          (setq #i 0)
          (repeat #kosu ; "G_WTR" �̐��J��Ԃ�
            (setq #en (ssname #ss #i))
            (setq #wtrxd$ (CFGetXData #en "G_WTR"))
            (setq #zoku (nth 0 #wtrxd$))
            (setq #et (entget #en))
            (if (= (cdr (assoc 0 #et)) "CIRCLE")
              (progn
                (setq #o  (cdr (assoc 10 #et)))         ; ���S���W(trans �s�v)
                (setq #PX (car  (cdr (assoc 10 #et))))  ; ���SX���W(trans �s�v)
                (setq #PY (cadr (cdr (assoc 10 #et))))  ; ���SY���W(trans �s�v)
                (setq #oX (car (trans #o 0 1)))         ; ���Sx���W��հ�ް���W�n�ɕϊ�
                (setq #r (* 2.0 (cdr (assoc 40 #et))))  ; ���a
;;;               (setq #ana$ (list #oX #o #r #zoku))     ; (հ�ް���W�n�ł̌����Sx���W,���S,���a,����)
                (setq #ana$ (list #oX #PX #PY #r))      ; (հ�ް���W�n�ł̌����Sx���W,���SX,Y,���a)
                (setq #ana$$ (append #ana$$ (list #ana$)))
              )
            );_if
            (setq #i (1+ #i))
          );_repeat #kosu
          (setq #ana$$ (CFListSort #ana$$ 0))           ; #oX = (nth 0 �����������̏��ɿ��
          (setq #ana$$ (mapcar 'cdr #ana$$))            ; (���SX,Y,���a)�����ɂ���
          ;;; ؽĂ�ؽ�--->ؽ�
          (foreach #ana$ #ana$$
            (setq #ret$ (append #ret$ #ana$))
          )
        )
      );_if
      (command "._ucs" "P")
    )
  );_if
;;; (command "zoom" "p")
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapEnd);00/08/24 SN MOD
  ;(CFNoSnapStart)
  #ret$ ; �����Ȃ���� nil
);PKGetSuisenAna

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_GetWTUnderCabDimCP
;;; <�����T�v>  : ܰ�į�ߐ}�`��n����,����WT�����ɂ��鷬��ȯĂ������@�v�����Ԃ�
;;; <�߂�l>    : ���@W����ؽ�(������)
;;; <�쐬>      : 00/06/22 YM
;;; <���l>      :
;;;
;;; <I�z��>
;;;  +-------+----+-------+
;;;  |       |    |       |
;;;  |       |    |       |
;;;  |       |    |       |
;;;  +-------+----+-------+
;;;  |   1   |  2 |   3   |
;;;
;;; (�߂�l): (����1���@W,����2���@W,����3���@W)
;;;
;;; <L�z��> ���ڽ�̂�                 <L�z��Ă���ݸ��>      <L�z��Ă����ۑ�>
;;;   |    3    |  4  |5 |              |    1    |  2  |3 |
;;; --+---------+-----+--+            --+---------+-----+--+   --+------------------+
;;;   |��Ű���� |     |  |              |         |     |  |     |                  |
;;; 2 |         |     |  |              |         |     |  |   2 |                  |
;;;   |     +---+-----+--+              |     +---+-----+--+     |     +------------+
;;;   |     |                           |     |                  |     |
;;; --+-----+                           |     |                --+-----+
;;; 1 |     |                           |     |                1 |     |
;;;   |     |                           |     |                  |     |
;;; --+-----+                           +-----+                --+-----+
;;;
;;; �߂�l: (����1���@W,2,3,4,5)      (����1���@W,2,3)        (����1���@W,2)
;;; �֘A�v�s�S�̂̉��ɂ���L���r�l�b�g���@�v�����߂� ===> 06/21 YM ���߂�
;;; ��Ă��ꂽWT�̏ꍇWT�O�`�̒����ɂ���L���r�l�b�g���@�v�����߂�
;;;*************************************************************************>MOH<
(defun PK_GetWTUnderCabDimCP (
  &enWT  ;WT�}�`��
  /
  #BASE$ #CORNER$ #ICOUNT #NUM$ #PT$ #SKK$ #SS
  #LEN #OS #OT #RET$ #SM #FLG #WTXD$ #kosu_pt$ #xdWT$ #ii #WTMR
  )
;;; ���ѕϐ��ݒ�
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)

  ; ���ꂽWT�Ή� 01/07/03 YM ADD PK_WTSStoPlPt�͎g���Ȃ� START
  (setq #WTMR (car (PKGetMostRightWT &enWT))) ; ��ԉE(1����)WT
  (setq #xdWT$ (CFGetXData #WTMR "G_WRKT"))

  (if (and (nth 59 #xdWT$) (/= (nth 59 #xdWT$) "")) ; �V�^"G_WRKT"[60]WT�O�`���� 01/07/04 YM MOD
    (progn
      (setq #pt$ (GetLWPolyLinePt (nth 59 #xdWT$))); �i�������܂�WT�O�`�̈�
      (setq #pt$ (AddPtList #pt$)); �����Ɏn�_��ǉ�����
    )
    (progn
      (setq #ss (PKGetWTSSFromWTEN &enWT)); WT�}�`������WT�I��Ă��擾����
      (setq #pt$ (PK_WTSStoPlPt #ss))     ; WT�O�`�_����擾����(�n�_�𖖔��ɒǉ��ς�)
    )
  );_if

  (setq #base$ (PKGetBaseSymCP #pt$)) ; �̈���ް����޼����ؽ�
; ��Ű���ނ̐� #icount ==>I,L,U�̔���
  (setq #icount 0)
  (foreach #sym #base$
    (setq #skk$ (CFGetSymSKKCode #sym nil))
    (if (= (nth 2 #skk$) CG_SKK_THR_CNR)
      (progn
        (setq #icount (1+ #icount))
        (setq #corner$ (append #corner$ (list #sym))) ; ��Ű���޼���ِ}�`��ؽ�
      )
    )
  )

  (cond ; ��Ű���ނ̐��Ŕ���
    ((= #icount 0) ; I�^�̏ꍇ
      (setq #num$ (PKWTCabDim_I #base$))
    )
    ((= #icount 1) ; L�^�̏ꍇ &enWT �� #flg = 0:�ݸ�� 1:��ۑ� ��n��
      (setq #wtxd$ (CFGetXData &enWT "G_WRKT"))
      (cond
        ((/= (nth 47 #wtxd$) "") ; ��WT�}�`�����
          (setq #flg 0) ; �ݸ�����ސ��@W
        )
        ((/= (nth 48 #wtxd$) "") ; �EWT�}�`�����
          (setq #flg 1) ; ��ۑ����ސ��@W
        )
        (T ; ���ڽL�^
          (setq #flg 999) ; �S���ސ��@W
        )
      );_cond
      (setq #num$ (PKWTCabDim_L #base$ #corner$ #flg))
    )
    ((= #icount 2) ; U�^�̏ꍇ &enWT �� #flg = 0:�ݸ�� 1:��ۑ� 2:���̑��� ��n��
      (setq #wtxd$ (CFGetXData &enWT "G_WRKT"))
      (cond
        ((and (/= (nth 47 #wtxd$) "")(= (nth 48 #wtxd$) "")) ; ��WT�}�`����ق̂ݑ���
          (setq #flg 0) ; �ݸ�����ސ��@W
        )
        ((and (/= (nth 47 #wtxd$) "")(/= (nth 48 #wtxd$) "")) ; ���E��WT������
          (setq #flg 1) ; ��ۑ����ސ��@W
        )
        ((and (= (nth 47 #wtxd$) "")(/= (nth 48 #wtxd$) "")) ; �EWT�}�`����ق̂ݑ���
          (setq #flg 2) ; ���̑����ސ��@W
        )
      );_cond
      (setq #num$ (PKWTCabDim_U #base$ #corner$ #flg))
    )
  );_cond

;;; ���ѕϐ��ݒ�
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)
  #num$
);PK_GetWTUnderCabDimCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKWTCabDim_I
;;; <�����T�v>  : ����ȯĐ��@�v�����Ԃ�(I�^)
;;; <�߂�l>    : ���@����ؽ�(������)�S���܂܂�
;;; <�쐬>      : 05/18 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKWTCabDim_I (
  &Base$    ; �ް����޼���ِ}�`
  /
  #ANG #BASEPT #BASEX #BASEX1 #BASEX2 #BASEXY
  #I #LEN #LST$ #LST$$ #NUM$ #SYM #W #X1 #Y1
  )
;;; ؽĂ̍ŏ��̼���ق����_(0,0)�Ƃ���
  (setq #basePT (cdr (assoc 10 (entget (car &Base$)))))
  (setq #ang (nth 2 (CFGetXData (car &Base$) "G_LSYM"))) ; �z�u�p�x
  (setq #x1 (polar #basePT #ang 1000))
  (setq #y1 (polar #basePT (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #basePT #x1 #y1)
;;; ����ق����W��ؽĂ����߂�
  (setq #i 0)
  (foreach #sym &Base$
    (setq #baseXY (cdr (assoc 10 (entget #sym))))        ; ����ق�x���W
    (setq #baseX  (car (trans #baseXY 0 1)))             ; հ�ް���W�n�ɕϊ�
    (setq #lst$ (list #baseX #sym))
    (setq #lst$$ (append #lst$$ (list #lst$)))
    (setq #i (1+ #i))
  )
  (setq #lst$$ (CFListSort #lst$$ 0))                    ; (nth 0 �����������̏��ɿ��
;;; ������̐��@�v��������߂�
  (setq #i 0)
;;; (setq #LEN 0) ; �S��
  (repeat (length #lst$$)
    (setq #sym (cadr (nth #i #lst$$)))
    (setq #W (nth 3 (CFGetXData #sym "G_SYM"))) ; ���@W
;;;   (setq #LEN (+ #LEN #W))
    (setq #num$ (append #num$ (list #W)))
    (setq #i (1+ #i))
  )
  (command "._ucs" "P")
;;; (list #num$ #LEN)
  #num$
);PKWTCabDim_I

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKWTCabDim_L
;;; <�����T�v>  : ����ȯĐ��@�v�����Ԃ�(L�^)
;;; <�߂�l>    : ���@����ؽ�(������)�S���܂܂�
;;; <�쐬>      : 05/19 YM
;;; <���l>      : WT����Ű���ނ����ɒ����Ă���ꍇ�Ή�
;;;*************************************************************************>MOH<
(defun PKWTCabDim_L (
  &Base$    ; �ް����޼���ِ}�`
  &corner$  ; ��Ű����ؽ�
  &flg      ; 0:�ݸ�� 1:��ۑ� 999:����
  /
  #BASE #BASEL$ #BASER$
  #CORNER
  #LENL #LENR #LR #num$
  #NUML$ #NUMR$ #PMEN2 #PT0$ #RET$ #SKK$ #W1 #W2
  )

  (setq #corner (car &corner$))                       ; ��Ű���޼���ِ}�`
  (setq #base (cdr (assoc 10 (entget #corner))))      ; ����ي�_
;;; PMEN2 ��T��
  (setq #pmen2 (PKGetPMEN_NO #corner 2))              ; PMEN2
  (setq #pt0$ (GetLWPolyLinePt #pmen2))               ; PMEN2 �O�`�̈�
  (setq #pt0$ (GetPtSeries #base #pt0$))              ; #base ��擪�Ɏ��v����

  (if (= (length &Base$)(length &corner$))
    (progn ; ��Ű���ނ����Ȃ� 00/07/19 YM ADD
      (setq #W1 (distance (nth 0 #pt0$) (last  #pt0$)))   ; ��Ű��ۑ����@�v ���_��7 OK!
      (setq #W2 (distance (nth 0 #pt0$) (nth 1 #pt0$)))   ; ��Ű�ݸ�����@�v ���_��7 OK!
      (setq #num$ (list #W1 #W2))
    )
    (progn
      ;;; �ް����ނ��A�ݸ,��ۂ̂ǂ̑����U�蕪����
      (foreach #sym &Base$
        (setq #skk$ (CFGetSymSKKCode #sym nil))
        (if (/= (nth 2 #skk$) CG_SKK_THR_CNR)             ; ��Ű���ނ��ǂ����̔���
          (progn ; ��Ű���ނłȂ�
            (setq #base (cdr (assoc 10 (entget #sym))))   ; ����ي�_
            (setq #lr (CFArea_rl (nth 3 #pt0$) (nth 2 #pt0$) #base)) ; ���_��7 OK!
            (if (= #lr -1) ; �E���ǂ���
              (setq #baseR$ (append #baseR$ (list #sym)))
              (setq #baseL$ (append #baseL$ (list #sym)))
            );_if
          )
        );_if
      )
      (setq #W1 (distance (nth 0 #pt0$) (last  #pt0$)))   ; ��Ű��ۑ����@�v ���_��7 OK!
      (setq #W2 (distance (nth 0 #pt0$) (nth 1 #pt0$)))   ; ��Ű�ݸ�����@�v ���_��7 OK!

      (if #baseR$ ;00/08/25 SN ADD ��Ű����E���������͏������Ȃ�
      (setq #numR$  (PKWTCabDim_I #baseR$))
      )
      (if #baseL$ ;00/08/25 SN ADD ��Ű���獶���������͏������Ȃ�
      (setq #numL$  (PKWTCabDim_I #baseL$))
      )
      (cond
        ((= &flg 0)
          (setq #num$ (append (list #W2) #numL$))
        )
        ((= &flg 1)
          (setq #num$ (append #numR$ (list #W1)))
        )

        ((= &flg 999)
          (setq #num$ (append #numR$ (list #W1 #W2) #numL$))
        )
      );_cond
    )
  );_if

;;; (setq #numR$ (car  #ret$)) ; ���@�v����
;;; (setq #LENR  (cadr #ret$)) ; �S��
;;; (setq #numR$ (append #numR$ (list #W1))) ; �S���Ȃ�
;;; (setq #numL$ (car  #ret$)) ; ���@�v����
;;; (setq #LENL  (cadr #ret$)) ; �S��
;;; (setq #numL$ (append (list #W2) #numL$)) ; �S���Ȃ�
;;; (append #numR$ #numL$ (list #LENR #LENL)) ; �����ɍ����S��,�E���S��
;;; (append #numR$ #numL$)
  #num$
);PKWTCabDim_L

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKWTCabDim_U
;;; <�����T�v>  : ����ȯĐ��@�v�����Ԃ�(U�^)
;;; <�߂�l>    : ���@����ؽ�(������)�S���܂܂�
;;; <�쐬>      : 05/19 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKWTCabDim_U (
  &Base$    ; �ް����޼���ِ}�`
  &corner$  ; ��Ű����ؽ�
  &flg      ; 0:�ݸ�� 1:��ۑ� 2:���̑���
  /
  #BASE #BASE1 #BASE2 #BASEL$ #BASEO$ #BASER$
  #CORNER1 #CORNER2
  #DUM #LENL #LENO #LENR #LR
  #NUML$ #NUMO$ #NUMR$ #PMEN2 #PMEN2-1 #PMEN2-2
  #PT1$ #PT2$ #PT3$ #RET$ #SKK$
  #W1 #W2 #W3 #W4 #num$
  )
  (setq #corner1 (car &corner$))                      ; ��Ű���޼���ِ}�`1(��)
  (setq #base1 (cdr (assoc 10 (entget #corner1))))    ; ����ي�_1
  (setq #pmen2-1 (PKGetPMEN_NO #corner1 2))           ; PMEN2(��Ű1)
  (setq #pt1$ (GetLWPolyLinePt #pmen2-1))             ; PMEN2 �O�`�̈�(��Ű1)
  (setq #pt1$ (GetPtSeries #base1 #pt1$))             ; #base ��擪�Ɏ��v����(��Ű1)

  (setq #corner2 (cadr &corner$))                     ; ��Ű���޼���ِ}�`2(��)
  (setq #base2 (cdr (assoc 10 (entget #corner2))))    ; ����ي�_2
  (setq #pmen2-2 (PKGetPMEN_NO #corner2 2))           ; PMEN2(��Ű2)
  (setq #pt2$ (GetLWPolyLinePt #pmen2-2))             ; PMEN2 �O�`�̈�(��Ű2)
  (setq #pt2$ (GetPtSeries #base2 #pt2$))             ; #base ��擪�Ɏ��v����(��Ű2)

  (setq #lr (CFArea_rl (nth 0 #pt1$) (nth 3 #pt1$) #base2)) ; ��Ű2���A��Ű1�Ίp���̂ǂ��瑤�����f
  (if (= #lr 1)
    (progn ; �����ł������ꍇ�A��Ű����1(��)�����ͺ�Ű����2�������̂ŊO�`�_������ւ�
      (setq #dum #pt1$)
      (setq #pt1$ #pt2$)
      (setq #pt2$ #dum)
    )
  );_if
  (setq #pt3$ (append (list (car #pt2$))(reverse (cdr #pt2$))))

;;; ���̎��_�ź�Ű1,2�m��
;;; �ް����ނ��A�ݸ,���,���̑��̂ǂ̑����U�蕪����
  (foreach #sym &Base$
    (setq #skk$ (CFGetSymSKKCode #sym nil))
    (if (/= (nth 2 #skk$) CG_SKK_THR_CNR)                ; ��Ű���ނ��ǂ����̔���
      (progn ; ��Ű���ނłȂ�
        (setq #base (cdr (assoc 10 (entget #sym))))      ; ����ي�_
        (setq #lr (CFArea_rl (nth 3 #pt1$) (nth 2 #pt1$) #base)) ; ���_7 OK!
        (if (= #lr 1) ; ��
          (setq #baseL$ (append #baseL$ (list #sym)))    ; �����ł������ꍇ �ݸ���ɂ��鷬�ނł���
          (progn ; ����ȊO
            (setq #lr (CFArea_rl (nth 3 #pt3$) (nth 2 #pt3$) #base)) ; ��Ű����2�Ŕ��f ���_7 OK!
            (if (= #lr -1) ; �E
              (setq #baseO$ (append #baseO$ (list #sym))); �E���ł������ꍇ ���̑����ɂ��鷬�ނł���
              (setq #baseR$ (append #baseR$ (list #sym))); �E���ł������ꍇ ��ۑ��ɂ��鷬�ނł���
            );_if
          )
        );_if
      )
    );_if
  )

  (setq #W1 (distance (nth 0 #pt2$) (last  #pt2$))) ; ��Ű2���̑������@�v
  (setq #W2 (distance (nth 0 #pt2$) (nth 1 #pt2$))) ; ��Ű2��ۑ�   ���@�v
  (setq #W3 (distance (nth 0 #pt1$) (last  #pt1$))) ; ��Ű1��ۑ�   ���@�v
  (setq #W4 (distance (nth 0 #pt1$) (nth 1 #pt1$))) ; ��Ű1�ݸ��   ���@�v

  (setq #numO$  (PKWTCabDim_I #baseO$))
  (setq #numR$  (PKWTCabDim_I #baseR$))
  (setq #numL$  (PKWTCabDim_I #baseL$))

  (cond
    ((= &flg 0)
      (setq #num$ (append (list #W4) #numL$))
    )
    ((= &flg 1)
      (setq #num$ (append (list #W2) #numR$ (list #W3)))
    )
    ((= &flg 2)
      (setq #num$ (append #numO$ (list #W1)))
    )
  );_cond

;;; (setq #numO$ (car  #ret$)) ; ���@�v����
;;; (setq #LENO  (cadr #ret$)) ; �S��
;;; (setq #LENO  (+ #LENO #W1))
;;; (setq #numO$ (append #numO$ (list #W1 #LENO))) ; �S���ǉ�
;;; (setq #numO$ (append #numO$ (list #W1))) ; �S���Ȃ�

;;; (setq #numR$ (car  #ret$)) ; ���@�v����
;;; (setq #LENR  (cadr #ret$)) ; �S��
;;; (setq #LENR  (+ #LENR #W2 #W3))
;;; (setq #numR$ (append (list #W2) #numR$ (list #W3 #LENR))) ; �S���ǉ�
;;; (setq #numR$ (append (list #W2) #numR$ (list #W3))) ; �S���Ȃ�

;;; (setq #numL$ (car  #ret$)) ; ���@�v����
;;; (setq #LENL  (cadr #ret$)) ; �S��
;;; (setq #LENL  (+ #LENL #W4))
;;; (setq #numL$ (append (list #W4) #numL$ (list #LENL))) ; �S���ǉ�
;;; (setq #numL$ (append (list #W4) #numL$)) ; �S���Ȃ�

;;; (append #numO$ #numR$ #numL$ (list #LENO #LENR #LENL)) ; �����ɑS��������
;;; (append #numO$ #numR$ #numL$)
  #num$
);PKWTCabDim_U

;<HOM>*************************************************************************
; <�֐���>    : PKGetWTSSFromWTEN
; <�����T�v>  : ܰ�į�ߐ}�`--->�֘AWT�I���
; <�߂�l>    : �I���
; <�쐬>      : 00/05/18 YM
; <���l>      :
;*************************************************************************>MOH<
(defun PKGetWTSSFromWTEN (
  &enWT  ;WT�}�`��
  /
  #SS #WTL #WTR #WTXD$ #WTXD0$
  )
  (setq #ss (ssadd))
  (ssadd &enWT #ss)
  (setq #wtxd$ (CFGetXData &enWT "G_WRKT"))
  (if #wtxd$
    (progn
      ;;; ��đ��荶
      (setq #WTL (nth 47 #wtxd$))    ; ��WT�}�`�����
      (while (and #WTL (/= #WTL "")) ; ����WT�������
        (ssadd #WTL #ss)
        (setq #wtxd0$ (CFGetXData #WTL "G_WRKT"))
        (setq #WTL (nth 47 #wtxd0$))     ; �X�ɍ��ɂ��邩
        (if (= #WTL "") (setq #WTL nil)) ; �Ȃ������� nil
      )
      ;;; ��đ���E
      (setq #WTR (nth 48 #wtxd$))    ; �EWT�}�`�����
      (while (and #WTR (/= #WTR "")) ; �E��WT�������
        (ssadd #WTR #ss)
        (setq #wtxd0$ (CFGetXData #WTR "G_WRKT"))
        (setq #WTR (nth 48 #wtxd0$))     ; �X�ɉE�ɂ��邩
        (if (= #WTR "") (setq #WTR nil)) ; �Ȃ������� nil
      )
    )
    (progn
      (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B\n PKGetWTSSFromWTEN")
      (quit)
    )
  );_if
  #ss
);PKGetWTSSFromWTEN

;<HOM>*************************************************************************
; <�֐���>    : PK_WTSStoPlPt
; <�����T�v>  : ܰ�į�ߐ}�`�I��Ă�n���āA���̊O�`�_���߂�
; <�߂�l>    : �O�`�_��(�����Ɏn�_��ǉ�)
; <�쐬>      : 00/05/16 YM ADD
; <���l>      :
;*************************************************************************>MOH<
(defun PK_WTSStoPlPt (
  &ss  ;WT�I���
  /
  #I #PT$ #R-SS #SS #TEI #WT #XD$
  )
  (setq #i 0)
  (setq #ss (ssadd))
  (repeat (sslength &ss)
    (setq #WT (ssname &ss #i))
    (setq #xd$ (CFGetXData #WT "G_WRKT"))
    (setq #tei (nth 38 #xd$))
    (entmake (entget #tei))
    (command "._region" (entlast) "")
    (ssadd (entlast) #ss)
    (setq #i (1+ #i))
  )
  (if (> (sslength #ss) 1)(command "._union" #ss ""))
  ;// REGION�𕪉����A���������������|�����C��������
  (command "_explode" (entlast))
  (setq #r-ss (ssget "P"))
  (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ���ײ݂̑I�����I��

  (setq #pt$ (GetLWPolyLinePt (entlast)))
  (entdel (entlast))
  (setq #pt$ (append #pt$ (list (car #pt$))))
);PK_WTSStoPlPt

;<HOM>*************************************************************************
; <�֐���>    : PKDelWkTopONE
; <�����T�v>  : ����WT�Ƃ��̼ݸ,����,BG,��ʂ݂̂��폜(�֘AWT�͍폜���Ȃ�)
; <�߂�l>    :
; <�쐬>      : 2000-05-08 YM
; <���l>      :
;*************************************************************************>MOH<
(defun PKDelWkTopONE (
  &wtEn ;(ENAME)ܰ�į�ߐ}�`(�ޯ��ް�ސ}�`�̂��Ƃ�����)
  /
  #SS #WTEN #XD$ #XD_WT
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKDelWkTopONE ////")
  (CFOutStateLog 1 1 " ")
  ;// �F�ւ��m�F
  (setq #ss (PCW_ChColWTItemSSret &wtEn CG_InfoSymCol)) ; �ݸ������Έꏏ�Ɏ�� 04/25 YM
  (command "_.erase" #ss "") ; �폜����
  (princ)
)
;PKDelWkTopONE

; <HOM>***********************************************************************************
; <�֐���>    : DelAppXdata
; <�����T�v>  : �}�`�� &en �̊g���ް�(APP�� &app)����������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2000-05-11
; <�쐬��>    : 05/11 YM
; <���l>      :
; ***********************************************************************************>MOH<
(defun DelAppXdata (
  &en
  &app
  /
  #xd$ #xd0$ #EN #ET
  )

  (setq #xd0$ '())
  (setq #et (entget &en '("*")))
  (setq #xd$ (assoc -3 #et))
  (foreach #elm #xd$
    (if (= (type #elm) 'LIST)
      (progn
        (if (/= (car #elm) &app)
          (setq #xd0$ (append #xd0$ (list #elm)))
          (setq #xd0$ (append #xd0$ (list (list &app))))
        )
      )
      (setq #xd0$ (append #xd0$ (list #elm)))
    );_if
  )
  (entmod (subst #xd0$ #xd$ #et))
  (princ)
);DelAppXdata

;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_VAL_MINMAX
;;; <�����T�v>  : �����l�̃��X�g����ő�,�ŏ��l�����߂�
;;; <����>      : ���X�g
;;; <�߂�l>    : (max,min)
;;; <�쐬>      :     2000.1.25 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun CMN_VAL_MINMAX (
  &lis
  /
  #i #elm #min #max
  )

  (setq #min 1.0e+10)
  (setq #max 1.0e-10)
  (setq #i 0)
  (repeat (length &lis)
    (setq #elm (nth #i &lis))

    (if (<= #elm #min)
        (setq #min #elm)
    )

    (if (>= #elm #max)
        (setq #max #elm)
    )

    (setq #i (1+ #i))
  );_(repeat (length &lis)

  (list #max #min)

)

;<HOM>*************************************************************************
; <�֐���>     : PKGetPMEN_NO
; <�����T�v>   : �ݸ����ِ}�`,PMEN�ԍ���n����PMEN(&NO)�}�`���𓾂�
; <�߂�l>     : PMEN(&NO)�}�`��
; <�쐬>       : 00/05/04 YM
; <���l>       :
;*************************************************************************>MOH<
(defun PKGetPMEN_NO (
  &scab-en   ;(ENAME)���޼���ِ}�`
  &NO        ;PMEN �̔ԍ�
  /
  #EN #I #MSG #PMEN #S-XD$ #SS #XD$ #LOOP #NAME
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
  (setq #loop T #pmen nil)
  (while (and #loop (< #i (sslength #ss)))
    (setq #en (ssname #ss #i)) ; �ݸ���ނ̓����ٰ��
    (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
    (if #xd$
      (progn
        (if (= &NO (car #xd$))
          (progn
            (setq #pmen #en)
            (setq #loop nil)
          )
        );_if
      );_(progn
    );_(if
    (setq #i (1+ #i))
  )
  (if (= #pmen nil)
;-- 2011/09/13 A.Satoh Add - S
    (if (/= &NO 8)
;-- 2011/09/13 A.Satoh Add - E
    (progn
      (setq #s-xd$ (CFGetXData &scab-en "G_LSYM")) ; �ݸ����ȯĊg���ް�
;-- 2011/10/21 A.Satoh Add - S
			(if (/= (nth 9 #s-xd$) 110)
				(progn
;-- 2011/10/21 A.Satoh Add - E
      (setq #msg
        (strcat "�i�Ԗ���: " (nth 5 #s-xd$) " �ɁAP��" (itoa &NO) #NAME "������܂���B")
      )
      (CFOutStateLog 0 5 #msg)
      (CFAlertMsg #msg)
      (if (/= &NO 2) ; PMEN2�̂Ƃ���PMEN2���쐬����̂ŃG���[�ɂ��Ȃ�
        (*error*)
      );_if
;-- 2011/10/21 A.Satoh Add - S
				)
			)
;-- 2011/10/21 A.Satoh Add - E
    )
;-- 2011/09/13 A.Satoh Add - S
    )
;-- 2011/09/13 A.Satoh Add - E
  )
  #pmen ; PMEN ���Ȃ��Ƃ���nil ��Ԃ�
);PKGetPMEN_NO

;<HOM>*************************************************************************
; <�֐���>     : PKGetFstPMEN
; <�����T�v>   : ����ِ}�`,PMEN�ԍ���n���čŏ��Ɍ�������PMEN(&NO)�}�`���擾
;                �Ȃ����nil
; <�߂�l>     : PMEN(&NO)�}�`�� or nil
; <�쐬>       : 01/08/28 YM
; <���l>       :
;*************************************************************************>MOH<
(defun PKGetFstPMEN (
  &sym ;(ENAME)���޼���ِ}�`
  &NO  ;PMEN �̔ԍ�
  /
  #EN #I #LOOP #PMEN #SS #XD$
  )
  (setq #ss (CFGetSameGroupSS &sym))
  (setq #i 0)
  (setq #loop T #pmen nil)
  (while (and #loop (< #i (sslength #ss)))
    (setq #en (ssname #ss #i))
    (if (setq #xd$ (CFGetXData #en "G_PMEN"))
      (if (= &NO (car #xd$))
        (setq #pmen #en #loop nil)
      );_if
    );_if
    (setq #i (1+ #i))
  )
  #pmen ; PMEN ���Ȃ��Ƃ���nil ��Ԃ�
);PKGetFstPMEN

;<HOM>*************************************************************************
; <�֐���>     : PKGetPMEN_NO_ALL
; <�����T�v>   : ����ِ}�`,PMEN�ԍ���n����PMEN(&NO)�}�`��(���ׂ�)�𓾂�
; <�߂�l>     : PMEN(&NO)�}�`��ؽ�
; <�쐬>       : 00/05/04 YM
; <���l>       :
;*************************************************************************>MOH<
(defun PKGetPMEN_NO_ALL (
  &scab-en   ;(ENAME)���޼���ِ}�`
  &NO        ;PMEN �̔ԍ�
  /
  #EN #I #MSG #PMEN$ #S-XD$ #SS #XD$ #LOOP #NAME
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
    (setq #en (ssname #ss #i)) ; �ݸ���ނ̓����ٰ��
    (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
    (if #xd$
      (if (= &NO (car #xd$))
        (setq #pmen$ (append #pmen$ (list #en)))
      );_if
    );_if
    (setq #i (1+ #i))
  )
  (if (= #pmen$ nil)
    (progn
      (setq #s-xd$ (CFGetXData &scab-en "G_LSYM")) ; �ݸ����ȯĊg���ް�
;-- 2011/10/21 A.Satoh Add - S
			(if (/= (nth 9 #s-xd$) 110)
				(progn
;-- 2011/10/21 A.Satoh Add - E
      (setq #msg
        (strcat "�i�Ԗ���: " (nth 5 #s-xd$) " �ɁAP��" (itoa &NO) #NAME "������܂���B")
      )
      (CFOutStateLog 0 5 #msg)
      (CFAlertMsg #msg)
      (if (/= &NO 2) ; PMEN2�̂Ƃ���PMEN2���쐬����̂ŃG���[�ɂ��Ȃ�
        (*error*)
      );_if
;-- 2011/10/21 A.Satoh Add - S
				)
			)
;-- 2011/10/21 A.Satoh Add - E
    )
  )
  #pmen$ ; PMEN ���Ȃ��Ƃ���nil ��Ԃ�
);PKGetPMEN_NO_ALL

;<HOM>*************************************************************************
; <�֐���>     : PKGetPLIN_NO
; <�����T�v>   : ����ِ}�`,PLIN�ԍ���n����PLIN(&NO)�}�`���𓾂�
; <�߂�l>     : PLIN(&NO)�}�`��
; <�쐬>       : 00/12/05 YM
; <���l>       :
;*************************************************************************>MOH<
(defun PKGetPLIN_NO (
  &scab-en   ;(ENAME)���޼���ِ}�`
  &NO        ;PLIN �̔ԍ�
  /
  #EN #I #MSG #PLIN #S-XD$ #SS #XD$ #LOOP
  )

  (setq #ss (CFGetSameGroupSS &scab-en))
  (setq #i 0)
  (setq #loop T #plin nil)
  (while (and #loop (< #i (sslength #ss)))
    (setq #en (ssname #ss #i)) ; ���ނ̓����ٰ��
    (setq #xd$ (CFGetXData #en "G_PLIN")) ; G_PLIN�g���ް�
    (if #xd$
      (progn
        (if (= &NO (car #xd$))
          (progn
            (setq #plin #en)
            (setq #loop nil)
          )
        );_if
      );_(progn
    );_(if
    (setq #i (1+ #i))
  )
;;;01/08/22YM@  (if (= #plin nil)
;;;01/08/22YM@    (progn
;;;01/08/22YM@      (setq #s-xd$ (CFGetXData &scab-en "G_LSYM"))
;;;01/08/22YM@      (setq #msg
;;;01/08/22YM@        (strcat "�L���r�l�b�g �i�Ԗ��� : " (nth 5 #s-xd$) " �ɁA\nP��" (itoa &NO) "������܂���B\nPKGetPLIN_NO"))
;;;01/08/22YM@      (CFOutStateLog 0 5 #msg)
;;;01/08/22YM@      (CFAlertMsg #msg)
;;;01/08/22YM@    )
;;;01/08/22YM@  );_if
  #plin
);PKGetPLIN_NO

;<HOM>*************************************************************************
; <�֐���>     : PKGetPTEN_NO
; <�����T�v>   : �ݸ����ِ}�`,PTEN�ԍ���n����PTEN(&NO)�}�`���𓾂�
; <�߂�l>     : ((PTEN�}�`��,G_PTEN),...) ؽĂ�ؽ�
; <�쐬>       : 00/05/04 YM
; <���l>       :
;*************************************************************************>MOH<
(defun PKGetPTEN_NO (
  &snk-en   ;(ENAME)�ݸ����ِ}�`
  &NO        ;PTEN �̔ԍ�
  /
  #EN #I #MSG #PTEN$ #S-XD$ #SS #XD$
  )

  (setq #ss (CFGetSameGroupSS &snk-en))
  (setq #i 0 #pten$ '())
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i)) ; �ݸ���ނ̓����ٰ��
    (setq #xd$ (CFGetXData #en "G_PTEN")) ; G_TMEN�g���ް�
    (if #xd$
      (progn
        (if (= &NO (car #xd$))   ; CG_PSINKTYPE = 8 �ݸ���t���̈�
          (setq #pten$ (append #pten$ (list (list #en #xd$))))
        )
      );_(progn
    );_(if
    (setq #i (1+ #i))
  )
  (if (= #pten$ nil)
    (progn
      (setq #s-xd$ (CFGetXData &snk-en "G_LSYM")) ; �ݸ����ȯĊg���ް�
      (setq #msg
        (strcat "�L���r�l�b�g �i�Ԗ��� : " (nth 5 #s-xd$) " ��\nP�_" (itoa &NO) "������܂���B\n \nPKGetPTEN_NO"))
      (CFOutStateLog 0 5 #msg)
      (CFAlertMsg #msg)
      (*error*)
    )
  )
  #pten$
);PKGetPTEN_NO

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetWTSymCP
;;; <�����T�v>  : �̈�_��ؽĂ�n���ė̈�Ɋ܂܂��v�s����������
;;; <�߂�l>    : WT�}�`��ؽ�
;;; <�쐬>      : 2000.5.9 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;*************************************************************************>MOH<
(defun PKGetWTSymCP (
  &pt$
  /
  #I #SS #SYM #SYM$
  )
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_WRKT"))))) ; �̈����G_WRKT
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i))                  ; �̈���̊e�����
            (setq #sym$ (append #sym$ (list #sym)))      ; ��ۂ̼���ِ}�`��
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if
  #sym$ ; �ݸ,�������ِ}�`ؽ�
);GetGasSym

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetHinbanSSCP
;;; <�����T�v>  : �̈�_��ؽĂ�n���ė̈�Ɋ܂܂��A�ݸ��߰ļ��т���������
;;; <�߂�l>    : �ݸ��߰ļ��Ѹ�ٰ�ߑI���
;;; <�쐬>      : 2000.5.22 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;*************************************************************************>MOH<
(defun PKGetHinbanSSCP (
  &pt$
  &HINBAN ; ���C���h�J�[�h���������܂ޕi�Ԗ���
  /
  #HIN #I #SS #SYM #RES_SS
  )
  (setq #res_ss nil)
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; �̈���̊e�����
            (setq #hin (nth 5 (CFGetXData #sym "G_LSYM"))) ; �i�Ԑ}�`
            (if (= #hin &HINBAN)
              (setq #res_ss (CFGetSameGroupSS #sym))
            );_if
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if

  #res_ss ; �ݸ��߰ļ��Ѹ�ٰ�ߑI���
);PKGetHinbanSSCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetSinkSuisenSymCP
;;; <�����T�v>  : �̈�_��ؽĂ�n���ė̈�Ɋ܂܂��A�V���N,��������������
;;; <�߂�l>    :
;;; <�쐬>      : 2000.5.9 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;*************************************************************************>MOH<
(defun PKGetSinkSuisenSymCP (
  &pt$
  /
  #I #SS #SYM #SYM$
  )
  (setq #ss    (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; �̈���̊e�����
            (if (or (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_SNK)  ; ���i����1�� CG_SKK_ONE_SNK = 4(�ݸ)
                    (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_WTR)) ; ���i����1�� CG_SKK_ONE_WTR = 5(����)
              (setq #sym$ (append #sym$ (list #sym))) ; �}���_
            );_if
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if
  #sym$
);PKGetSinkSuisenSymCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetG_WTRCP
;;; <�����T�v>  : �̈�_��ؽĂ�n���ė̈�Ɋ܂܂��A"G_WTR"����������
;;; <�߂�l>    :
;;; <�쐬>      : 2000.7.22 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;*************************************************************************>MOH<
(defun PKGetG_WTRCP ( &pt$ / #ss )
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_WTR")))))  ; �̈����G_WTR�}�`
  (CMN_ss_to_en #ss); ������G_WTR�}�`ؽ� or nil
);PKGetG_WTRCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetSinkSymBySinkCabCP
;;; <�����T�v>  : �ݸ���ޗ̈�Ɋ܂܂��ݸ����������
;;; <�߂�l>    : �ݸ����ِ}�`��
;;; <�쐬>      : 2000.6.27 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;*************************************************************************>MOH<
(defun PKGetSinkSymBySinkCabCP (
  &scab-en ; �ݸ���޼���ِ}�`
  /
  #I #PMEN2 #PTA$ #RET #SS #SYM #LOOP
  )
  ;2011/04/07 YM ADD
  (setq #PD (getvar "pdmode"))
  (setq #PDS (getvar "PDSIZE"))
  (setvar "pdmode" 34)
  (setvar "pdsize" 20)


  (setq #pmen2 (PKGetPMEN_NO &scab-en 2))   ; �ݸ����PMEN2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 &scab-en))   ; PMEN2 ���쐬
  );_if
  (setq #ptA$ (GetLWPolyLinePt #pmen2))     ; �ݸ����PMEN2 �O�`�̈�
  (setq #ptA$ (AddPtList #ptA$))            ; �����Ɏn�_��ǉ�����
  (setq #ss (ssget "CP" #ptA$ (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
  (setq #i 0 #loop T #ret nil)
  (if #ss
    (if (> (sslength #ss) 0)
      (while (and #loop (< #i (sslength #ss)))
        (setq #sym (ssname #ss #i)) ; �̈���̊e�����
        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_SNK)  ; ���i����1�� CG_SKK_ONE_SNK = 4(�ݸ)
          (setq #ret #sym #loop nil)
        );_if
        (setq #i (1+ #i))
      )
    );_if
  );_if

  (setvar "pdmode" #PD)
  (setvar "pdsize" #PDS)

  #ret ; �ݸ����ِ}�` or nil
);PKGetSinkSymBySinkCabCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetSuisenSymBySinkCabCP
;;; <�����T�v>  : �ݸ���ޗ̈�Ɋ܂܂�鐅������������
;;; <�߂�l>    : �������ِ}�`��ؽ�
;;; <�쐬>      : 2000.7.6 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;*************************************************************************>MOH<
(defun PKGetSuisenSymBySinkCabCP (
  &scab-en ; �ݸ���޼���ِ}�`
  /
  #PMEN2 #PTA$ #RET$ #SS
  )
  (setq #pmen2 (PKGetPMEN_NO &scab-en 2))   ; �ݸ����PMEN2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 &scab-en))   ; PMEN2 ���쐬
  );_if
  (setq #ptA$ (GetLWPolyLinePt #pmen2))     ; �ݸ����PMEN2 �O�`�̈�
  (setq #ptA$ (AddPtList #ptA$))            ; �����Ɏn�_��ǉ�����
  (setq #ss (ssget "CP" #ptA$ (list (list -3 (list "G_WTR"))))) ; �̈���̼���ِ}�`
  (setq #ret$ (CMN_ss_to_en #ss)); �������ِ}�` or nil
);PKGetSuisenSymBySinkCabCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetGasSymByGasCabCP
;;; <�����T�v>  : ��۷��ޗ̈�Ɋ܂܂���ۂ���������
;;; <�߂�l>    : ��ۼ���ِ}�`��
;;; <�쐬>      : 2000.6.27 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;*************************************************************************>MOH<
(defun PKGetGasSymByGasCabCP (
  &scab-en ; ��۷��޼���ِ}�`
  /
  #I #LOOP #PMEN2 #PTA$ #RET #SS #SYM
  )
  (setq #pmen2 (PKGetPMEN_NO &scab-en 2))   ; ��۷���PMEN2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 &scab-en))   ; PMEN2 ���쐬
  );_if
  (setq #ptA$ (GetLWPolyLinePt #pmen2))     ; ��۷���PMEN2 �O�`�̈�
  (setq #ptA$ (AddPtList #ptA$))            ; �����Ɏn�_��ǉ�����
  (setq #ss (ssget "CP" #ptA$ (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
  (setq #i 0 #loop T #ret nil)
  (if #ss
    (if (> (sslength #ss) 0)
      (while (and #loop (< #i (sslength #ss)))
        (setq #sym (ssname #ss #i)) ; �̈���̊e�����
        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_GAS)  ; ���i����1�� CG_SKK_ONE_GAS = 2(���)
          (setq #ret #sym #loop nil)
        );_if
        (setq #i (1+ #i))
      )
    );_if
  );_if

  #ret ; ��ۼ���ِ}�` or nil
);PKGetGasSymByGasCabCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetSymBySKKCodeCP
;;; <�����T�v>  : �̈�_��ؽ�,���i���ނ�n���ė̈���̼���ِ}�`��ؽĂ�Ԃ�
;;; <�߂�l>    :
;;; <�쐬>      : 2000.5.9 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;*************************************************************************>MOH<
(defun PKGetSymBySKKCodeCP (
  &pt$
  &SKK
  /
  #I #SKK #SS #SYM #SYM$
  )
  ;2011/04/07 YM ADD
  (setq #PD (getvar "pdmode"))
  (setq #PDS (getvar "PDSIZE"))
  (setvar "pdmode" 34)
  (setvar "pdsize" 20)
  (command "_.layer" "ON" "N_SYMBOL" "")

  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; �̈���̊e�����
            (setq #skk (nth 9 (CFGetXData #sym "G_LSYM")))
            (if (= #skk &SKK) ; ���i���� &SKK
              (setq #sym$ (append #sym$ (list #sym))) ; �}���_
            )
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if

  (setvar "pdmode" #PD)
  (setvar "pdsize" #PDS)

  #sym$ ; ����ِ}�`ؽ�
);PKGetSymBySKKCodeCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetSymBySKKCodeCP2
;;; <�����T�v>  : WT�O�`�̈�_��ؽ�(WT����_���n�_�Ƃ��A���v����)��n����
;;;               �̈���̺�۷��ސ}�`��ؽĂ�Ԃ�
;;; <�߂�l>    :
;;; <�쐬>      : 2000.9.6 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;               ��۷��ގ擾��p(PKGetSymBySKKCodeCP���ƒi����۷��ނ����Ă��܂�)
;;;*************************************************************************>MOH<
(defun PKGetSymBySKKCodeCP2 (
  &pt$
  /
  #I #RU_PT #SKK #SS #SYM #SYM$ #SYM_PT
  )
;;; P---+----------------*--------+  * �̒i����۰���ߺ�۷��ނ�
;;; |   |                |        |    �܂߂Ȃ��悤�ɂ���
;;; |   |   ڷޭװ��WT   | �i���� |
;;; |   |                |        |
;;; |   |                |        |
;;; +---+----------------+--------+
  (setq #RU_PT (nth 1 &pt$))
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; �̈���̊e�����
            (setq #sym_PT (cdr (assoc 10 (entget #sym)))) ; ����ٍ��W
            (setq #skk (nth 9 (CFGetXData #sym "G_LSYM")))
            (if (= #skk CG_SKK_INT_GCA) ; ���i���� &SKK ; 01/08/31 YM MOD 113-->��۰��ى�
              (if (< (distance #sym_PT #RU_PT) 0.1)
                (princ) ; WT�O�`�̈�̉E����ƈ�v����ꍇ�͏��O����
                (setq #sym$ (append #sym$ (list #sym))) ; �}���_
              );_if
            );_if
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if
  #sym$ ; ����ِ}�`ؽ�
);PKGetSymBySKKCodeCP2

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetBaseSymCP
;;; <�����T�v>  : �̈�_��ؽĂ�n���ė̈�����ް�����(11?)����ِ}�`��ؽĂ�Ԃ�
;;; <�߂�l>    :
;;; <�쐬>      : 2000.5.18 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;               ���t������=0�̂��̂��擾
;;;*************************************************************************>MOH<
(defun PKGetBaseSymCP (
  &pt$
  /
  #I #SS #SYM #SYM$
  )
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; �̈���̊e�����
            (if (or (and (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)  ; ����
                         (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS)) ; �ް�
                )
              (if (equal (nth 6 (CFGetXData #sym "G_SYM")) 0 0.01) ; ���t������
                (setq #sym$ (append #sym$ (list #sym))) ; �}���_
              );_if
            );_if
            (setq #i (1+ #i))
          );_repeat
        )
      );_if
    )
  );_if
  #sym$ ; ����ِ}�`ؽ�
);PKGetBaseSymCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetBaseSymCP_SYOKUSEN
;;; <�����T�v>  : �̈�_��ؽĂ�n���ė̈�����ް�����(11?)�ŐH��"110"�ȊO��
;;;               ����ِ}�`��ؽĂƐH��"110"��ؽĂ�Ԃ�
;;; <�߂�l>    : ((110�ȊO�����)(110�����))
;;; <�쐬>      : 01/01/31 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;               ���t������=0�̂��̂��擾
;;;*************************************************************************>MOH<
(defun PKGetBaseSymCP_SYOKUSEN (
  &pt$
  /
  #I #SS #SYM #SYM$ #SYM110$
#FIG$ #HIN #SKK #SYM_NEW$ ; 02/01/24 YM ADD
  )
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
  (setq #i 0)
  (if (and #ss (> (sslength #ss) 0))
    (repeat (sslength #ss)
      (setq #sym (ssname #ss #i)) ; �̈���̊e�����
      (if (and (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)  ; ����
               (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS)  ; �ް�
               (/= (CFGetSymSKKCode #sym 3) CG_SKK_THR_DIN)) ; �޲�ݸވȊO
        ; "1" "1" "7�ȊO"�̂Ƃ�
        (if (= (CFGetSymSKKCode #sym 3) CG_SKK_THR_ETC)
          (setq #sym110$ (append #sym110$ (list #sym))) ; "110"
          (setq #sym$    (append #sym$    (list #sym))) ; "110"�ȊO
        );_if
      );_if
      (setq #i (1+ #i))
    );_repeat
  );_if

  ; 02/01/24 YM ADD-S "113"�ŕi�Ԋ�{.�i������=2�̂Ƃ���SET�W�����݂�
  (setq #sym_new$ nil)
  (foreach #sym #sym$
    (setq #hin (nth 5 (CFGetXData #sym "G_LSYM"))) ; �i��
    (setq #skk (nth 9 (CFGetXData #sym "G_LSYM"))) ; ���i����
    (if (= #skk CG_SKK_INT_GCA) ; ���i����113
      (progn ; �i�Ԋ�{
        ;// �i�Ԋ�{�e�[�u����������擾
        (setq #fig$ (car
          (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hin
            (list (list "�i�Ԗ���" #hin 'STR))
        )))
        (if #fig$
          (progn
            (if (equal 2 (nth 4 #fig$) 0.1) ; �i������
              (if (KcCheckSetStd #sym) ; SET�W�����ǂ�������
                (setq #sym_new$ (append #sym_new$ (list #sym))) ; SET�i
                nil                                             ; SET�i�łȂ����珜�O
              );_if
              ; �i�����߂�2�łȂ��Ƃ�����ĕi�����ŐԂ�����
              (setq #sym_new$ (append #sym_new$ (list #sym))) ; SET�i
            );_if
          )
          ; �i�Ԋ�{�ɑ��݂��Ȃ��Ƃ�����ł��Ȃ�����ĕi�����ŐԂ�����
          (setq #sym_new$ (append #sym_new$ (list #sym))) ; SET�i
        );_if
      )
      (progn
        (setq #sym_new$ (append #sym_new$ (list #sym)))
      )
    );_if
  );foreach
  ; 02/01/24 YM ADD-E

;;;  (list #sym$ #sym110$); ����ِ}�`ؽ�  02/01/24 YM MOD
  (list #sym_new$ #sym110$); ����ِ}�`ؽ� 02/01/24 YM MOD
);PKGetBaseSymCP_SYOKUSEN

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetLowCabSym
;;; <�����T�v>  : ����ِ}�`��ؽĂ�n����۰���޼���ِ}�`��ؽĂ�Ԃ�
;;; <�߂�l>    :
;;; <�쐬>      : 2000.5.9 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKGetLowCabSym (
  &BaseSym$   ; �ް����޼���ِ}�`��ؽ�
  /
  #EN_LOW$ #H #THR #SS_DEL
  )

  (setq #en_LOW$ '())
  (foreach #en &BaseSym$
    (setq #thr (CFGetSymSKKCode #en 3))
    (cond
      ;�K�X�L���r�l�b�g
      ((= #thr CG_SKK_THR_GAS)
        (setq #h (fix (nth 5 (CFGetXData #en "G_SYM"))))
        (if (and (> #h 472) (< #h 523)) ; ����۰���߂̺�۷���ȯĂ�����Βi������
          (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ۰���߷���ȯļ���ِ}�`ؽ�
          (ssadd #en #ss_del) ; ��ŏ��O����
        );_if
      )
      ;�ʏ�L���r�l�b�g
      ((= #thr CG_SKK_THR_NRM)
        (setq #h (fix (nth 5 (CFGetXData #en "G_SYM"))))
        (if (and (> #h 676) (< #h 728)) ; ����۰���߂̒ʏ���ȯĂ�����Βi������
          (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ۰���߷���ȯļ���ِ}�`ؽ�
        );_if
      )
    );_cond
  );_(foreach

#en_LOW$
);PKGetLowCabSym

;;;<HOM>*************************************************************************
;;; <�֐���>    : StrLisToRealLis
;;; <�����T�v>  : ������ؽĂ������lؽĂɂ���
;;;               (��) (" 12"   "333" "99 ") ---> (12.0  333.0  99.0)
;;; <�߂�l>    : �����lؽ�
;;; <�쐬>      : 2000.4.30 YM
;;; <���l>      : �װ�����Ȃ�
;;;*************************************************************************>MOH<
(defun StrLisToRealLis (
  &str$ ; ������ؽ�
  /
  #RET$
  )
  (setq #ret$ '())
  (foreach #elm &str$
    (setq #ret$ (append #ret$ (list (atof #elm))))
  )
  #ret$
);StrLisToRealLis

;;;<HOM>*************************************************************************
;;; <�֐���>    : StrtoLisBySpace
;;; <�����T�v>  : �������space�ŋ�؂���ؽĉ�����
;;;               (��) " 12   333 a  99 "--->("12" "333" "a" "99")
;;; <�߂�l>    : ������ؽ�
;;; <�쐬>      : 2000.4.29 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun StrToLisBySpace (
  &str ; ������
  /
  #ret$ #dum #flg #i #str
  )
  (setq #ret$ '())
  (if (= 'STR (type &str))
    (progn
      (setq #i 1 #dum " " #flg nil)
      (repeat (strlen &str)
        (setq #str (substr &str #i 1))
        (cond
          ((/= #str " ")
            (setq #flg T #dum (strcat #dum #str))
          )
          (T ; space
            (if #flg
              (progn
                (setq #dum (substr #dum 2 (1- (strlen #dum))))
                (setq #ret$ (append #ret$ (list #dum)))
                (setq #dum " ")
                (setq #flg nil)
              )
            );_if
          )
        );_cond

        (if (= #i (strlen &str))
          (if (and #flg (/= #dum " "))
            (progn
              (setq #dum (substr #dum 2 (1- (strlen #dum))))
              (setq #ret$ (append #ret$ (list #dum)))
            )
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret$
);StrtoListSpace

;;;<HOM>*************************************************************************
;;; <�֐���>    : StrtoLisByBrk
;;; <�����T�v>  : �������#brk�ŋ�؂���ؽĉ�����
;;;               (��) " 12  , 333, a,  99 "--->("12" "333" "a" "99") space �͖�������
;;; <�߂�l>    : ������ؽ�
;;; <�쐬>      : 2000.4.30 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun StrToLisByBrk (
  &str ; ������
  &brk
  /
  #ret$ #dum #flg #i #str
  )
  (setq #ret$ '())
  (if (= 'STR (type &str))
    (progn
      (setq #i 1 #dum " " #flg nil)
      (repeat (strlen &str)
        (setq #str (substr &str #i 1))
        (cond
          ((and (/= #str " ")(/= #str &brk))
            (setq #flg T #dum (strcat #dum #str))
          )
          ((= #str " ")
            (princ)
          )
          (T ; &brk
            (if #flg
              (progn
                (setq #dum (substr #dum 2 (1- (strlen #dum))))
                (setq #ret$ (append #ret$ (list #dum)))
                (setq #dum " ")
                (setq #flg nil)
              )
            );_if
          )
        );_cond
        (setq #i (1+ #i))
      )
      (setq #dum (substr #dum 2 (1- (strlen #dum))))
      (setq #ret$ (append #ret$ (list #dum)))
    )
  );_if


  #ret$
);StrToLisByBrk

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetPtSeries
;;; <�����T�v>  : �������ײ݊O�`�_����A�_�����&base��擪�Ɏ��v����ɂȂ�ׂ�
;;; <�߂�l>    : �_��
;;; <�쐬>      : 2000.4.27 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun GetPtSeries (
  &Base   ; ��_
  &pt$    ; ���O�O�̊O�`�̈�_��
  /
  #BASEPT #I #KOSU #NO #PT #PT$ #PT$$
  )

  (setq #i 0)
  (setq #kosu (length &pt$))
  (setq #pt$$ (append &pt$ &pt$))
  (repeat #kosu
    (setq #pt (nth #i &pt$))
    (if (< (distance #pt &Base) 0.1)
      (setq #no #i) ; #base ���_���nth ���Ԗڂ�
    );_if
    (setq #i (1+ #i))
  )
;;; (if (= #no nil)
;;;   (progn
;;;     (CFAlertErr "PMEN2�ɃV���{����������܂���ł����B\n GetPtSeries")
;;;     (quit)  ; 00/06/15 YM
;;;   )
;;; );_if

  (setq #pt$ '())
  (if #no
    (progn  ; PMEN2�ɃV���{��������
    ;;; ���בւ���Ű��_���_��̍ŏ�����
      (setq #i #no)
      (repeat #kosu
        (setq #pt$ (append #pt$ (list (nth #i #pt$$))))
        (setq #i (1+ #i))
      )
    ;;; ���v����ɂ���
      (if (= (CFArea_rl (nth 0 #pt$) (nth 1 #pt$) (last #pt$)) 1)   ; -1:�E , 1:��
        (setq #pt$ (append (list (car #pt$)) (reverse (cdr #pt$)))) ; ���v����ɒ���
      );_if
    )
  );_if

#pt$  ; �O�`�_���Ɋ�_���Ȃ������� nil ��Ԃ�
);GetPtSeries

;<HOM>*************************************************************************
; <�֐���>    : PCW_ChColWT
; <�����T�v>  : ܰ�į�ߐ}�`����n���āA�֘AWT�̐F�ς����s��.
;               BG SOLID������΂�����F��ς���
;               &flg=T: �א�WT�S��    &flg=nil: ����WT��BG�̂�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/04/27 YM ADD
; <���l>      :
;*************************************************************************>MOH<
(defun PCW_ChColWT (
  &wten  ;(ENAME)WT�}�`
  &col
  &flg
  /
  #WTL #WTR #XD$ #XD0$ #BGflg #BG1 #BG2 #ZAI
  )

  (setq #BGflg nil)
  (setq #xd$ (CFGetXData &wtEn "G_WRKT"))
  (command "_.change" &wtEn "" "P" "C" &col "") ; ����WT

  ;;; BG��ʂ�"3DSOLID"==>BG�����^
  (if (and (/= (nth 49 #xd$) "")
           (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID")) ; 01/01/19 YM ADD
    (setq #BGflg T)
  );_if

  (if #BGflg ; BG ��SOLID
    (progn
      (setq #BG1 (nth 49 #xd$)) ; BG1
      (setq #BG2 (nth 50 #xd$)) ; BG2
      (if (/= #BG1 "")(command "_.change" #BG1 "" "P" "C" &col ""))
      (if (/= #BG2 "")(command "_.change" #BG2 "" "P" "C" &col ""))
    )
  );_if

  (if &flg
    (progn
      ;;; ��đ��荶
      (setq #WTL (nth 47 #xd$)) ; ��WT�}�`�����
      (while (and #WTL (/= #WTL "")) ; ����WT�������
        (command "_.change" #WTL "" "P" "C" &col "")
        (setq #xd0$ (CFGetXData #WTL "G_WRKT"))
        (if #BGflg ; BG ��SOLID
          (progn
            (setq #BG1 (nth 49 #xd0$)) ; BG1
            (setq #BG2 (nth 50 #xd0$)) ; BG2
            (if (/= #BG1 "")(command "_.change" #BG1 "" "P" "C" &col ""))
            (if (/= #BG2 "")(command "_.change" #BG2 "" "P" "C" &col ""))
          )
        );_if

        (setq #WTL (nth 47 #xd0$)) ; �X�ɍ��ɂ��邩

        (if (= #WTL "") (setq #WTL nil)) ; �Ȃ������� nil
      )

      ;;; ��đ���E
      (setq #WTR (nth 48 #xd$)) ; �EWT�}�`�����
      (while (and #WTR (/= #WTR "")) ; �E��WT�������
        (command "_.change" #WTR "" "P" "C" &col "")
        (setq #xd0$ (CFGetXData #WTR "G_WRKT"))
        (if #BGflg ; BG ��SOLID
          (progn
            (setq #BG1 (nth 49 #xd0$)) ; BG1
            (setq #BG2 (nth 50 #xd0$)) ; BG2
            (if (/= #BG1 "")(command "_.change" #BG1 "" "P" "C" &col ""))
            (if (/= #BG2 "")(command "_.change" #BG2 "" "P" "C" &col ""))
          )
        );_if

        (setq #WTR (nth 48 #xd0$)) ; �X�ɉE�ɂ��邩
        (if (= #WTR "") (setq #WTR nil)) ; �Ȃ������� nil
      )
    )
  )
  (princ)
);PCW_ChColWT

;;;<HOM>*************************************************************************
;;; <�֐���>    : RotatePoint
;;; <�����T�v>  : &pt�����_���S��#rad��]����
;;; <�߂�l>    : #pt
;;; <�쐬>      : 2000.3.23 YM
;;; <���l>      : 2D or 3D �_
;;;*************************************************************************>MOH<
(defun RotatePoint (
  &pt  ; ��]����_ 2D or 3D
  &rad ; ��]�p�x
  /
  #RET #X #XX #Y #YY
  )
  (setq #x (car  &pt) #y (cadr &pt))
  (setq #xx (- (* #x (cos &rad)) (* #y (sin &rad)) ))
  (setq #yy (+ (* #x (sin &rad)) (* #y (cos &rad)) ))
  (if (= (length &pt) 2) (setq #ret (list #xx #yy)) )
  (if (= (length &pt) 3) (setq #ret (list #xx #yy (caddr &pt))) )
  #ret
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : MakeTempLayer
;;; <�����T�v>  : �L�k��Ɨp�e���|������w�̍쐬
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.3.2 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun MakeTempLayer ( / #ss #EN #I)

  (if (tblsearch "LAYER" SKD_TEMP_LAYER)
    (progn                            ; �e���|������w����������
      (setq #ss (ssget "X" (list (cons 8 SKD_TEMP_LAYER))))
      (if (/= #ss nil)
        (progn
          (if (/= (sslength #ss) 0)
            (progn                        ; �e���|������w�ɂ���}�`�̍폜
              (setq #i 0)
              (repeat (sslength #ss)
                (setq #en (ssname #ss #i))
                (entdel #en)
                (setq #i (1+ #i))
              )
            )
          );_if
        )
      );_if
      (command "_layer" "U" SKD_TEMP_LAYER "")  ; �x�����b�Z�[�W�΍��2���ɕ�����  Uۯ�����
      (command "_layer" "T" SKD_TEMP_LAYER "ON" SKD_TEMP_LAYER "")  ; ON�\�� T�ذ�މ���
    )
    (progn                            ; �e���|������w���Ȃ�������
      (command "_layer" "N" SKD_TEMP_LAYER "C" 1 SKD_TEMP_LAYER "L" SKW_AUTO_LAY_LINE SKD_TEMP_LAYER "")
    )
  );_if
  (princ)
);MakeTempLayer

;;;<HOM>*************************************************************************
;;; <�֐���>    : MakeTempLayer2
;;; <�����T�v>  : �L�k��Ɨp�e���|������w�̍쐬
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2001.3.12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun MakeTempLayer2 (
  &layer
  /
  #ss #EN #I
  )
  (if (tblsearch "LAYER" &layer)
    (progn                            ; �e���|������w����������
      (setq #ss (ssget "X" (list (cons 8 &layer))))
      (if (/= #ss nil)
        (progn
          (if (/= (sslength #ss) 0)
            (progn                        ; �e���|������w�ɂ���}�`�̍폜
              (setq #i 0)
              (repeat (sslength #ss)
                (setq #en (ssname #ss #i))
                (entdel #en)
                (setq #i (1+ #i))
              )
            )
          );_if
        )
      );_if
      (command "_layer" "U" &layer "")  ; �x�����b�Z�[�W�΍��2���ɕ�����  Uۯ�����
      (command "_layer" "T" &layer "ON" &layer "")  ; ON�\�� T�ذ�މ���
    )
    (progn                            ; �e���|������w���Ȃ�������
      (command "_layer" "N" &layer "C" 1 &layer "L" SKW_AUTO_LAY_LINE &layer "")
    )
  );_if
  (princ)
);MakeTempLayer2

;;;<HOM>*************************************************************************
;;; <�֐���>    : BackLayer
;;; <�����T�v>  : (<�}�`��> ��w)�����ɁA��w��SKD_TEMP_LAYER���猳�ɖ߂�
;;; <����>      : (<�}�`��> ��w)��ؽĂ�ؽ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.3.2 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun BackLayer (
  &lis$$
  /
  #ELM #EN #I #LAYER
  )
  (setq #i 0)
  (repeat (length &lis$$)
    (setq #elm (nth #i &lis$$))
    (setq #en     (car  #elm))
    (setq #layer  (cadr #elm))
    (command "chprop" #en "" "LA" #layer "")
    (setq #i (1+ #i))
  )
);BackLayer

;;;<HOM>*************************************************************************
;;; <�֐���>    : Chg_SStoEnLayer
;;; <�����T�v>  : �I���--->(<�}�`��> ��w)��ؽĂ�ؽĂɕϊ�
;;; <����>      : ؽĂ�ؽ�
;;; <�߂�l>    : (<�}�`��> ��w)��ؽĂ�ؽ�
;;; <�쐬>      : 2000.3.2 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun Chg_SStoEnLayer (
  &ss
  /
  #ELM #ET #I #LAYER #RET
  )

  (setq #i 0)
  (setq #ret '())
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))
    (setq #et  (entget #elm))
    (setq #layer (cdr (assoc 8 #et)))
    (setq #ret (append #ret (list (list #elm #layer))))
    (setq #i (1+ #i))
  )
  #ret
);Chg_SStoEnLayer

;;;<HOM>*************************************************************************
;;; <�֐���>    : Chg_LISTtoEnLayer
;;; <�����T�v>  : �}�`ؽ�--->(<�}�`��> ��w)��ؽĂ�ؽĂɕϊ�
;;; <����>      : ؽĂ�ؽ�
;;; <�߂�l>    : (<�}�`��> ��w)��ؽĂ�ؽ�
;;; <�쐬>      : 2001.3.12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun Chg_LISTtoEnLayer (
  &lis$
  /
  #ET #LAYER #RET #RET$
  )
  (setq #ret '())
  (foreach #elm &lis$
    (setq #et (entget #elm))
    (setq #layer (cdr (assoc 8 #et)))
    (setq #ret$ (append #ret$ (list (list #elm #layer))))
  )
  #ret$
);Chg_LISTtoEnLayer

;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_select_element
;;; <�����T�v>  : �v�f�𕡐���I��(entsel)���đI���Z�b�g��Ԃ�  ���O�̑I���������\
;;;               ���[�N�g�b�v�ҏW�s�̃��b�Z�[�W
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �I���Z�b�g
;;; <���l>      : YM
;;;*************************************************************************>MOH<
(defun CMN_select_element(
  /
  #en #en0 #ss_lis #ss #i
  )

  (setq EditUndoM 0) ; �I���񐔂���
  (setq EditUndoU 0) ; ����񐔂���
  (setq #i 0)
  (setq #en T)
  (while #en
    (initget "U")
    (setq #en (entsel "\n�A�C�e����I��/U=�߂�/: "))

      (cond
        ((= #en "U")
          (setq EditUndoU (1+ EditUndoU)) ; �I���񐔂���
          (command "_.undo" "b")          ; �F��߂�
         ; �I���Z�b�g���X�g�̃��X�g���璼�O�̂��̂��폜 ;
          (setq #ss_lis (cdr #ss_lis))
        )
        ((= #en nil)

          (if (= #i 0)
            (progn
              (CFAlertErr "���ނ��I������܂���ł���")(quit)
            )
            (princ)
          );_if
        )
        (T
          (setq EditUndoM (1+ EditUndoM)) ; �I���񐔂���
          (setq #en (car #en))
          (cond
            ((CFGetXData #en "G_WRKT"); ���[�N�g�b�v�̏ꍇ
              ; 00/07/13 SN E-MOD ܰ�į�߂��I���\�ɂ���B
              (command "_.undo" "m")
              (GroupInSolidChgCol2 #en CG_ConfSymCol)
              (setq #ss (ssadd))               ;��̑I��č쐬
              (setq #ss (ssadd #en #ss))       ;�V��̨װ�I��č쐬
              (setq #ss_lis (cons #ss #ss_lis));�I���ؽĂɒǉ�
              ;(CFAlertErr "��A�C�e���͕ҏW�ł��܂���")
              ; 00/07/13 SN E-MOD ܰ�į�߂��I���\�ɂ���B
            )
            ((CFGetXData #en "G_FILR") ; �V��t�B���[�̏ꍇ
              ; 00/06/27 SN S-MOD �V��t�B���[���I���ɂ���B
              (command "_.undo" "m")
              (GroupInSolidChgCol2 #en CG_ConfSymCol)
              (setq #ss (ssadd))               ;��̑I��č쐬
              (setq #ss (ssadd #en #ss))       ;�V��̨װ�I��č쐬
              (setq #ss_lis (cons #ss #ss_lis));�I���ؽĂɒǉ�
              ;(CFAlertErr "��A�C�e���͕ҏW�ł��܂���")
              ; 00/06/27 SN E-MOD �V��t�B���[���I���ɂ���B
            )
            ((CFGetXData #en "G_ROOM") ; ???
              (CFYesDialog "�I�������}�`�͊Ԍ��̈�ł��@")
            )
            ((CFGetXData #en "RECT") ; ???
              (CFYesDialog "�I�������}�`�͖�̈�ł��@")
            )
            (T
              (setq #en (CFSearchGroupSym #en)) ; ����ȊO�̕���
              (if #en ; �߂�l�e�}�`��
                (progn
                  (command "_.undo" "m")
                  (setq #ss (CFGetSameGroupSS #en)); �����o�[�}�`�I���Z�b�g
                  (command "_.change" #ss "" "P" "C" CG_ConfSymCol "")
                  (setq #ss_lis (cons #ss #ss_lis))    ; �I���Z�b�g���X�g
                )
              )
            )
          );_(cond
        )
      );_(cond
    (setq #i (1+ #i))
  );_(while #en

  (setq #i 0)
  (setq #ss (ssadd)) ; ��̑I���Z�b�g
  (repeat (length #ss_lis)
    (setq #ss (CMN_ssaddss (nth #i #ss_lis) #ss)) ; �S�I���Z�b�g���P�ɂ܂Ƃ߂�.
  (setq #i (1+ #i))
  );_(repeat (length #ss_ret_lis)
  #ss
);CMN_select_element

;<HOM>*************************************************************************
; <�֐���>    : SetG_WRKT
; <�����T�v>  : "G_WRKT"(WT����_)(WT��t������)�g���f�[�^�̕ύX
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/09/14 YM 01/01/15 YM MOD
; <���l>      : �ړ��n�R�}���h�p
;*************************************************************************>MOH<
(defun SetG_WRKT(
  &MOD ; �ҏWӰ��"MOVE":�ړ������ "Z_MOVE":Z�ړ������
  &ss  ; �I��v�f�S�}�`�I���
  &bpt ; ��_(Z�ړ��̏ꍇ�A�ړ�����)
  &lpt ; �ړI�_ &MOD="ROT"�Ȃ��]�p�x
  /
  #ELM #I #ORG #PLUS #WTPT #XD0 #WTH #XD1
  #DUM_BP #DUM_P1
  )

  (setq #i 0)
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))  ; ���X�g�̊e�v�f�i�}�`���j
    (if (setq #xd0 (CFGetXData #elm "G_WRKT"))
      (progn
        (cond
          ((= &MOD "ROT") ; ��]�����
            (setq #org (nth 32 #xd0)) ; ����WT����_

            (setq #dum_BP (mapcar '- &bpt &bpt))     ; ���s�ړ�����(0,0)�Ƃ���
            (setq #dum_P1 (mapcar '- #org &bpt))     ; ���̍���_�𓯗l�ɕ��s�ړ�
            (setq #dum_P1 (RotatePoint #dum_P1 &lpt)); &lpt��]����
            ; �V����WT����_
            (setq #WTPT (mapcar '+ #dum_P1 &bpt))      ; ���s�ړ����Ė߂�

            ; �g���ް� "G_WRKT" �̾��
            (CFSetXData #elm "G_WRKT"
              (CFModList #xd0
                (list (list 32 #WTPT)) ;33.WT����_���W
              )
            )
          )
          ((= &MOD "MOVE") ; �ړ������
            (setq #org (nth 32 #xd0)) ; ����WT����_
            (setq #plus (mapcar '- &lpt &bpt))
            (setq #WTPT (mapcar '+ #org #plus)) ; �V����WT����_
            ; �g���ް� "G_WRKT" �̾��
            (CFSetXData #elm "G_WRKT"
              (CFModList #xd0
                (list (list 32 #WTPT)) ;33.WT����_���W
              )
            )
          )
          ((= &MOD "Z_MOVE") ; Z�ړ������
            (setq #WTH (nth 8 #xd0))  ; ����WT��t������
            (setq #WTH (+ #WTH &bpt)) ; �V����WT��t������
            ; �g���ް� "G_WRKT" �̾��
            (CFSetXData #elm "G_WRKT"
              (CFModList #xd0
                (list (list 8 #WTH)) ;33.WT��t������
              )
            )
            (if (setq #xd1 (CFGetXData #elm "G_WTSET")) ; �i�Ԋm�肳��Ă���
              ; �g���ް� "G_WTSET" �̾��
              (CFSetXData #elm "G_WTSET"
                (CFModList #xd1
                  (list (list 2 #WTH)) ;WT��t������
                )
              )
            )
          )
        );_cond
      )
    );_if

  (setq #i (1+ #i))
  );_(repeat
  (princ)
);SetG_WRKT

;<HOM>*************************************************************************
; <�֐���>    : PcGetOpNumDlg
; <�����T�v>  : ���[�U�[�ɃI�v�V�����i�̗L�������߂�_�C�A���O
; <�߂�l>    : 1 �� 0
; <�쐬>      : 00/08/04 MH ��������
; <���l>      :
;*************************************************************************>MOH<
(defun PcGetOpNumDlg (
  &sHin       ; �I�v�V�����i��
  &sDefo      ; "Yes" "No" �f�t�H���g�w��
  /
  #sMSG #sNAME #iOP
  )
  (setq #sNAME (PcGetPrintName &sHin))
  (setq #sMSG (if (= "" #sNAME) &sHin (strcat &sHin " �i" #sNAME "�j ")))
  (setq #iOP
    (if (CfYesNoJpDlg (strcat #sMSG "���g�p���܂����H") &sDefo) 1 0)
  )
  #iOP
);PcGetOpNumDlg

;<HOM>*************************************************************************
; <�֐���>    : PFGetLorRDlg
; <�����T�v>  : �����E�����[�U�[�ɑI�΂���
; <�߂�l>    : "L" �� "R" �� nil�i�L�����Z�����ꂽ�ꍇ�j
; <�쐬>      : 00/07/13 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PFGetLorRDlg (
   &sDPATH
   &sDNAME
   &sHIN
   /
   #dcl_id #LR$
  )
  ;;; �_�C�A���O�̎��s��
  (setq #dcl_id (load_dialog &sDPATH))
  (if (= nil (new_dialog &sDNAME #dcl_id)) (exit))
  ;// ��ق�ر���ݐݒ�
  (action_tile "accept"
    "(setq #LR$ (if (= \"1\" (get_tile \"L\")) \"L\" \"R\")) (done_dialog)")
  (action_tile "cancel" "(setq #LR$ nil) (done_dialog)")
  ;;;�f�t�H�l���
  (set_tile "Hin"  (strcat "     �i�� �F " &sHIN))
  (set_tile "Name" (strcat "     �i�� �F " (PcGetPrintName &sHIN)))
  (set_tile "L" "1")
  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; ���ʃ��X�g��Ԃ�
  #LR$
); PFGetLorRDlg

;;;;<HOM>*************************************************************************
;;;; <�֐���>    : SetG_LSYM1
;;;; <�����T�v>  : "G_LSYM" (�}���_)�g���f�[�^�̕ύX
;;;; <�߂�l>    : �Ȃ�
;;;; <�쐬>      : 1999-12-2 YM
;;;; <���l>      : �ړ��n�R�}���h�p
;;;;*************************************************************************>MOH<
;;;(defun SetG_LSYM1(
;;;  &lst    ; �I��v�f�̑S�O���[�v�}�`�����X�g
;;;  /
;;;  #i
;;;  #org ; �}���_
;;;  #elm
;;;  #xd
;;;  #xd0
;;;  )
;;;
;;;  (setq #i 0)
;;;  (repeat (length &lst)
;;;    (setq #elm (nth #i &lst))                                ; ���X�g�̊e�v�f�i�}�`���j
;;;    (setq #xd0 (CFGetXData #elm "G_LSYM"))
;;;    (if #xd0
;;;      (progn
;;;        (setq #org (cdr (assoc 10 (entget #elm))))
;;;        (setq #xd (CMN_subs_elem_list 1 #org #xd0))          ; �ύX��g���f�[�^
;;;        (CFSetXData (nth #i &lst) "G_LSYM" #xd)              ; �ύX��g���f�[�^�̃Z�b�g
;;;      );_(progn
;;;    );_(if xd
;;;  (setq #i (1+ #i))
;;;  );_(repeat
;;;  (princ)
;;;);SetG_LSYM1

;<HOM>*************************************************************************
; <�֐���>    : ChgLSYM1
; <�����T�v>  : "G_LSYM" (�}���_)�g���f�[�^�̕ύX
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-12-2 YM�@01/04/27 YM ������
; <���l>      : �ړ��n�R�}���h�p
;*************************************************************************>MOH<
(defun ChgLSYM1(
  &ss     ; �I��v�f�S�}�`�I���
  /
  #ELM #I #J #ORG #SSDUM #SSGRP #SYM #XD0
  )
  (setq #ssdum (ssadd))
  (setq #i 0)
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))
    (if (not (ssmemb #elm #ssdum))
      ;��ٰ�߱��т̏���
      (if (and (setq #sym (SearchGroupSym #elm))      ; ����ق���
               (setq #ssGrp (CFGetSameGroupSS #sym))) ; ��ٰ�ߑS��
        (progn
          (if (setq #xd0 (CFGetXData #sym "G_LSYM"))
            (progn
              (setq #org (cdr (assoc 10 (entget #sym))))
              ;// �g���f�[�^�̍X�V
              (CFSetXData #sym "G_LSYM"
                (CFModList #xd0
                  (list
                    (list 1 #org) ; �}���_
                  )
                )
              )
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
  );repeat
  (princ)
);ChgLSYM1

;<HOM>*************************************************************************
; <�֐���>    : ChgLSYM12
; <�����T�v>  : "G_LSYM" (�}���_)(��]�p�x)�g���f�[�^�̕ύX
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/04/27 YM ������
; <���l>      : �ړ��n�R�}���h�p
;*************************************************************************>MOH<
(defun ChgLSYM12(
  &ss     ; �I��v�f�S�}�`�I���
  &sa_ang ; ��]�p�x
  /
  #ELM #I #J #ORG #SSDUM #SSGRP #SYM #XD0
#sym$ ;-- 2012/03/07 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή�
  )
  (setq #ssdum (ssadd))
  (setq #i 0)
;-- 2012/03/07 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή� - S
	(setq #sym$ nil)
;-- 2012/03/07 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή� - E
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))
    (if (not (ssmemb #elm #ssdum))
      ;��ٰ�߱��т̏���
      (if (and (setq #sym (SearchGroupSym #elm))      ; ����ق���
               (setq #ssGrp (CFGetSameGroupSS #sym))) ; ��ٰ�ߑS��
        (progn
;-- 2012/03/07 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή� - S
					(if (not (member #sym #sym$))
						(progn
;-- 2012/03/07 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή� - S
          (if (setq #xd0 (CFGetXData #sym "G_LSYM"))
            (progn
              (setq #org (cdr (assoc 10 (entget #sym))))
              ;// �g���f�[�^�̍X�V
              (CFSetXData #sym "G_LSYM"
                (CFModList #xd0
                  (list
                    (list 1 #org) ; �}���_
                    (list 2 (Angle0to360 (+ (nth 2 #xd0) &sa_ang))) ; �z�u�p�x
                  )
                )
              )
;-- 2012/03/07 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή� - S
							(setq #sym$ (append #sym$ (list #sym)))
;-- 2012/03/07 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή� - E
            )
          );_if

          ;��x�T����������ٰ�߂�į����Ă���(�I��Ăɉ��Z)
          (setq #j 0)
          (repeat (sslength #ssGrp)
            (ssadd (ssname #ssGrp #j) #ssdum)
            (setq #j (1+ #j))
          )
          (setq #ssGrp nil)
;-- 2012/03/07 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή� - S
						)
					)
;-- 2012/03/07 A.Satoh Add �z�u�p�x�ݒ�s���̑Ή� - E
        )
      );_if
    );_if
    (setq #i (1+ #i))
  );repeat
  (princ)
);ChgLSYM12

;<HOM>*************************************************************************
; <�֐���>    : ChgLSYM1_copy
; <�����T�v>  : "G_LSYM" (�}���_)�g���f�[�^�̕ύX
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-12-2 YM�@01/05/01 YM ������
; <���l>      : �R�s�[�n�R�}���h�p
;*************************************************************************>MOH<
(defun ChgLSYM1_copy(
  &lst    ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�ύX��
  &lst2   ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�Z�b�g��
  /
  #ELM #I #J #LOOP #NO #ORG #SSDUM #SSGRP #SYM #SYM2 #XD0 #K
  )
  (setq #ssdum (ssadd))
  (setq #i 0)
  (repeat (length &lst)
    (setq #elm (nth #i &lst)) ; ���X�g�̊e�v�f�i�}�`���j
    (if (not (ssmemb #elm #ssdum))
      ;��ٰ�߱��т̏���
      (if (and (setq #sym (SearchGroupSym #elm))      ; ����ق���
               (setq #ssGrp (CFGetSameGroupSS #sym))) ; ��ٰ�ߑS��
        (progn
          (if (setq #xd0 (CFGetXData #sym "G_LSYM"))
            (progn

              ; #sym ��&lst�̉��Ԗڂ�
              (setq #loop T #j 0)
              (while (and #loop (< #j (length &lst)))
                (if (equal (nth #j &lst) #sym)
                  (progn
                    (setq #loop nil)
                    (setq #no #j)
                  )
                );_if
                (setq #j (1+ #j))
              )
              (if #no
                (progn
                  (setq #sym2 (nth #no &lst2))
                  (setq #org (cdr (assoc 10 (entget #sym2))))
                  ;// �g���f�[�^�̍X�V
                  (CFSetXData #sym2 "G_LSYM"
                    (CFModList #xd0
                      (list (list 1 #org)) ; �}���_
                    )
                  )
                )
                (princ "\n�}���_���W�̍X�V���ł��܂���ł����B")
              );_if

            )
          );_if

          ;��x�T����������ٰ�߂�į����Ă���(�I��Ăɉ��Z)
          (setq #k 0)
          (repeat (sslength #ssGrp)
            (ssadd (ssname #ssGrp #k) #ssdum)
            (setq #k (1+ #k))
          )
          (setq #ssGrp nil)
        )
      );_if
    );_if
    (setq #i (1+ #i))
  );repeat
  (princ)
);ChgLSYM1_copy

;;;01/05/01YM@;<HOM>*************************************************************************
;;;01/05/01YM@; <�֐���>    : SetG_LSYM11
;;;01/05/01YM@; <�����T�v>  : "G_LSYM" (�}���_)�g���f�[�^�̕ύX
;;;01/05/01YM@; <�߂�l>    : �Ȃ�
;;;01/05/01YM@; <�쐬>      : 1999-12-2 YM
;;;01/05/01YM@; <���l>      : �R�s�[�n�R�}���h�p
;;;01/05/01YM@;*************************************************************************>MOH<
;;;01/05/01YM@(defun SetG_LSYM11(
;;;01/05/01YM@  &lst    ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�ύX��
;;;01/05/01YM@  &lst2   ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�Z�b�g��
;;;01/05/01YM@  /
;;;01/05/01YM@  #i
;;;01/05/01YM@  #org ; �}���_
;;;01/05/01YM@  #elm
;;;01/05/01YM@  #elm2
;;;01/05/01YM@  #xd
;;;01/05/01YM@  #xd0
;;;01/05/01YM@  )
;;;01/05/01YM@
;;;01/05/01YM@  (setq #i 0)
;;;01/05/01YM@  (repeat (length &lst)
;;;01/05/01YM@    (setq #elm (nth #i &lst))                                       ; ���X�g�̊e�v�f�i�}�`���j
;;;01/05/01YM@    (setq #xd0 (CFGetXData #elm "G_LSYM"))
;;;01/05/01YM@    (if #xd0
;;;01/05/01YM@      (progn
;;;01/05/01YM@        (setq #elm2 (nth #i &lst2))                                 ; ���X�g�̊e�v�f�i�}�`���j
;;;01/05/01YM@        (setq #org (cdr (assoc 10 (entget #elm2))))
;;;01/05/01YM@        (setq #xd (CMN_subs_elem_list 1 #org #xd0))                 ; �ύX��g���f�[�^
;;;01/05/01YM@        (CFSetXData (nth #i &lst2) "G_LSYM" #xd)                    ; �ύX��g���f�[�^�̃Z�b�g
;;;01/05/01YM@      );_(progn
;;;01/05/01YM@    );_(if xd
;;;01/05/01YM@
;;;01/05/01YM@  (setq #i (1+ #i))
;;;01/05/01YM@  );_(repeat
;;;01/05/01YM@  (princ)
;;;01/05/01YM@)

;;;;<HOM>*************************************************************************
;;;; <�֐���>    : SetG_LSYM2
;;;; <�����T�v>  : "G_LSYM" (��]�p�x)�g���f�[�^�̕ύX
;;;; <�߂�l>    : �Ȃ�
;;;; <�쐬>      : 1999-12-2 YM
;;;; <���l>      : �ړ��n�R�}���h�p
;;;;*************************************************************************>MOH<
;;;(defun SetG_LSYM2(
;;;  &lst    ; �I��v�f�̑S�O���[�v�}�`�����X�g
;;;  &sa_ang ; ��]�p�x
;;;  /
;;;  #i
;;;  #elm
;;;  #xd
;;;  #xd0
;;;  #deg
;;;  )
;;;
;;;  (setq #i 0)
;;;  (repeat (length &lst)
;;;    (setq #elm  (nth #i &lst))                                      ; ���X�g�̊e�v�f�i�}�`���j
;;;    (setq #xd0 (CFGetXData #elm "G_LSYM"))
;;;    (if #xd0
;;;      (progn
;;;        (setq #deg (nth 2 #xd0))                                    ; ���̊g���f�[�^��3�Ԗڂ̗v�f(�}���p�x)
;;;        (setq #xd (CMN_subs_elem_list 2 (+ #deg &sa_ang) #xd0))     ; �ύX��g���f�[�^
;;;        (CFSetXData (nth #i &lst) "G_LSYM" #xd)                     ; �ύX��g���f�[�^�̃Z�b�g
;;;      );_(progn
;;;    );_(if xd
;;;
;;;  (setq #i (1+ #i))
;;;  );_(repeat
;;;  (princ)
;;;)

;;;;<HOM>*************************************************************************
;;;; <�֐���>    : SetG_LSYM22
;;;; <�����T�v>  : "G_LSYM" (��]�p�x)�g���f�[�^�̕ύX
;;;; <�߂�l>    : �Ȃ�
;;;; <�쐬>      : 1999-12-2 YM
;;;; <���l>      : �R�s�[�n�R�}���h�p
;;;;*************************************************************************>MOH<
;;;(defun SetG_LSYM22(
;;;  &lst    ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�ύX��
;;;  &lst2   ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�Z�b�g��
;;;  &sa_ang ; ��]�p�x
;;;  /
;;;  #i
;;;  #elm
;;;  #xd
;;;  #xd0
;;;  #deg
;;;  )
;;;
;;;  (setq #i 0)
;;;  (repeat (length &lst)
;;;    (setq #elm  (nth #i &lst))                                      ; ���X�g�̊e�v�f�i�}�`���j
;;;    (setq #xd0 (CFGetXData #elm "G_LSYM"))
;;;    (if #xd0
;;;      (progn
;;;        (setq #deg (nth 2 #xd0))                                    ; ���̊g���f�[�^��3�Ԗڂ̗v�f(�}���p�x)
;;;        (setq #xd (CMN_subs_elem_list 2 (+ #deg &sa_ang) #xd0))     ; �ύX��g���f�[�^
;;;        (CFSetXData (nth #i &lst2) "G_LSYM" #xd)                    ; �ύX��g���f�[�^�̃Z�b�g
;;;      );_(progn
;;;    );_(if xd
;;;    (setq #i (1+ #i))
;;;  );_(repeat
;;;
;;;  (princ)
;;;)

;<HOM>*************************************************************************
; <�֐���>    : ChgLSYM12_copy
; <�����T�v>  : "G_LSYM" (�}���_,��]�p�x)�g���f�[�^�̕ύX
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-12-2 YM�@01/05/01 YM ������
; <���l>      : �R�s�[�n�R�}���h�p
;*************************************************************************>MOH<
(defun ChgLSYM12_copy(
  &lst    ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�ύX��
  &lst2   ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�Z�b�g��
  &sa_ang ; ��]�p�x
  /
  #ELM #I #J #LOOP #NO #ORG #SSDUM #SSGRP #SYM #SYM2 #XD0 #K
  )
  (setq #ssdum (ssadd))
  (setq #i 0)
  (repeat (length &lst)
    (setq #elm (nth #i &lst)) ; ���X�g�̊e�v�f�i�}�`���j
    (if (not (ssmemb #elm #ssdum))
      ;��ٰ�߱��т̏���
      (if (and (setq #sym (SearchGroupSym #elm))      ; ����ق���
               (setq #ssGrp (CFGetSameGroupSS #sym))) ; ��ٰ�ߑS��
        (progn
          (if (setq #xd0 (CFGetXData #sym "G_LSYM"))
            (progn

              ; #sym ��&lst�̉��Ԗڂ�
              (setq #loop T #j 0)
              (while (and #loop (< #j (length &lst)))
                (if (equal (nth #j &lst) #sym)
                  (progn
                    (setq #loop nil)
                    (setq #no #j)
                  )
                );_if
                (setq #j (1+ #j))
              )
              (if #no
                (progn
                  (setq #sym2 (nth #no &lst2))
                  (setq #org (cdr (assoc 10 (entget #sym2))))
                  ;// �g���f�[�^�̍X�V
                  (CFSetXData #sym2 "G_LSYM"
                    (CFModList #xd0
                      (list
                        (list 1 #org) ; �}���_
                        (list 2 (Angle0to360 (+ (nth 2 #xd0) &sa_ang))) ; �z�u�p�x
                      )
                    )
                  )
                )
                (princ "\n�}���_���W�̍X�V���ł��܂���ł����B")
              );_if

            )
          );_if

          ;��x�T����������ٰ�߂�į����Ă���(�I��Ăɉ��Z)
          (setq #k 0)
          (repeat (sslength #ssGrp)
            (ssadd (ssname #ssGrp #k) #ssdum)
            (setq #k (1+ #k))
          )
          (setq #ssGrp nil)
        )
      );_if
    );_if
    (setq #i (1+ #i))
  );repeat
  (princ)
);ChgLSYM12_copy

;<HOM>*************************************************************************
; <�֐���>    : SetG_PRIM1
; <�����T�v>  : "G_PRIM"(���t������)�g���f�[�^�̕ύX
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-12-2 YM
; <���l>      : �ړ��n�R�}���h�p
;*************************************************************************>MOH<
(defun SetG_PRIM1(
  &ss     ; �I��v�f�S�}�`�I���
  /
  #i
  #elm
  #xd
  #xd0
  #high0
  #high
  )
  (setq #i 0)
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))

    (if (setq #xd0 (CFGetXData #elm "G_PRIM"))
      (progn
        (setq #high0 (nth 6 #xd0))                   ; ��������
        (setq #high  (+ #high0 CG_ZMOVEDIST))        ; �ύX��̎��t������
        (setq #xd (CMN_subs_elem_list 6 #high #xd0)) ; �ύX��g���f�[�^
        (CFSetXData (ssname &ss #i) "G_PRIM" #xd)
      )
    );_if
    (setq #i (1+ #i))
  );_(repeat
  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : SetG_PRIM11
; <�����T�v>  : "G_PRIM"(���t������)�g���f�[�^�̕ύX
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-12-2 YM
; <���l>      : �R�s�[�n�R�}���h�p
;*************************************************************************>MOH<
(defun SetG_PRIM11(
  &lst    ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�ύX��
  &lst2   ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�Z�b�g��
  /
  #i
  #elm
  #xd
  #xd0
  #high0
  #high
  )

  (setq #i 0)
  (repeat (length &lst)
    (setq #elm (nth #i &lst))                                 ; ���X�g�̊e�v�f�i�}�`���j
    (setq #xd0 (CFGetXData #elm "G_PRIM"))
    (if #xd0
      (progn
        (setq #high0 (nth 6 #xd0))                            ; ��������
        (setq #high  (+ #high0 CG_ZMOVEDIST))                 ; �ύX��̎��t������
        (setq #xd (CMN_subs_elem_list 6 #high #xd0))          ; �ύX��g���f�[�^
        (CFSetXData (nth #i &lst2) "G_PRIM" #xd)
      );_(progn
    );_(if xd0
  (setq #i (1+ #i))
  );_(repeat
  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : SetG_PRIM22
; <�����T�v>  : "G_PRIM"(��ʐ}�`)�g���f�[�^�̕ύX
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-12-2 YM
; <���l>      : �R�s�[�n�R�}���h�p
;*************************************************************************>MOH<
(defun SetG_PRIM22(
  &lst    ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�ύX��
  &lst2   ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�Z�b�g��
  /
  #i
  #elm
  #xd
  #xd0
  #n1
  #n2
  #en_tei
  #en_tei0 #MSG #SYM #ZUKEI_ID
  )

;;; "G_PRIM" �̈ʒu����+�ύX ;;;
  (setq #i 0)
  (repeat (length &lst)
    (setq #elm (nth #i &lst))                                 ; ���X�g�̊e�v�f�i�}�`���j
    (setq #xd0 (CFGetXData #elm "G_PRIM"))
    ;;; ���X�g��#n1�Ԗڂ�("G_PRIM")�̃n���h�������ڂ��A
    ;;; ���X�g��#n2�Ԗڂ�("G_PRIM")�̐}�`�n���h���ɕύX����.
    (if #xd0
      (progn
        (setq #n1 #i)
        (setq #en_tei0 (nth 10 #xd0))                         ; ��ʐ}�`��
;;; 00/04/08 ���܂ɒ�ʐ}�`��"0"�̂Ƃ�������̂Ń`�F�b�N�ǉ��}�ʏ�̓R�s�[�ł���悤�ɂ���
        (if (or (= #en_tei0 nil) (= #en_tei0 "0"))  ; 00/04/08 YM ADD
          (progn
            (setq #sym (SearchGroupSym #elm)) ; #elm ; SOLID�}�`��
            (setq #ZUKEI_ID (nth 0 (CFGetXData #sym "G_LSYM"))) ; �}�`ID
            (setq #msg
              (strcat "\n�A�C�e����\"G_PRIM\"���s���ł��B\n�쐬���ɘA�����Ă�������.\n�}�`ID="
              #ZUKEI_ID)
            )
            (CFAlertMsg #msg)
          )
          (progn
            (setq #n2 (CMN_search_en_lis #en_tei0 &lst))          ; �����P�������Q�̃��X�g�̉��Ԗڂ̗v�f��
            (setq #en_tei (nth #n2 &lst2))                        ; ��߰���ʐ}�`��
            (setq #xd (CMN_subs_elem_list 10 #en_tei #xd0))
            (CFSetXData (nth #n1 &lst2) "G_PRIM" #xd)
          )
        );_if
      )
    );_if

  (setq #i (1+ #i))
  );_(repeat
  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : AfterCopySetDoorGroup
; <�����T�v>  : ��߰��̔��ٰ�߂�"DoorGroup"������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/08/31 YM
; <���l>      : �R�s�[�n�R�}���h�p
; 01/08/31 �������ނ��߰������̕��ނ��W�J�}�쐬�r���ŗ�����s�����.
; ��߰��̔��̸�ٰ�߂����O�̂Ȃ���ٰ�߂ƂȂ��Ă��܂����ߐl�דI��"DoorGroup"
; ��Ă���̂����̊֐��̖ړI�ł���.
;*************************************************************************>MOH<
(defun AfterCopySetDoorGroup(
  &lst    ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�ύX��
  &lst2   ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�Z�b�g��
  /
  #DOOR$ #ELM #I #K #SSDOOR$ #SSDUM #SSGRP #SYM
  #ENNAME$ #J #LOOP #NO #SLAYER #SSDOOR
#SGRNAME ; 02/09/04 YM ADD
  )
  (setq #ssdum (ssadd))
  (setq #i 0)
  (setq #ssDOOR$ nil)
  (repeat (length &lst)
    (setq #elm (nth #i &lst)) ; ���X�g�̊e�v�f�i�}�`���j
    (if (not (ssmemb #elm #ssdum))
      ;��ٰ�߱��т̏���
      (if (and (setq #sym (SearchGroupSym #elm))     ; ����ق���
               (setq #ssGrp (CFGetSameGroupSS #sym)) ; ��ٰ�ߑS��
               (setq #Door$ (KPGetDoorGroup #sym)))  ;"DoorGroup" "GROUP"�}�`ؽ�
        (progn

          (setq #k 0)
          (repeat (sslength #ssGrp)
            (ssadd (ssname #ssGrp #k) #ssdum)
            (setq #k (1+ #k))
          )

          (foreach #Door #Door$
            (setq #ssDOOR (KP_Get340SSFromDrgroup #Door)) ; ���������ް
            ;��x�T����������ٰ�߂�į����Ă���(�I���#ssdum�ɉ��Z)
            (setq #k 0)
            (repeat (sslength #ssDOOR)
              (ssadd (ssname #ssDOOR #k) #ssdum)
              (setq #k (1+ #k))
            )
            (setq #ssDOOR$ (append #ssDOOR$ (list #ssDOOR))) ; ���}�`���ް�I��Ă�ؽ�
            (setq #ssGrp nil)
          )
        )
      );_if
    );_if
    (setq #i (1+ #i))
  );repeat

  (foreach #ssDOOR #ssDOOR$ ; ��߰���̔����ް�I���
    (setq SKD_GROUP_NO (SCD_GetDoorGroupName)) ; ��ٰ�ߖ��̔ԍ�
    (setq #sLAYER (substr (SKGetGroupName (ssname #ssDOOR 0)) 10 1)) ; ��ٰ�ߖ�-->LAYER�ԍ��擾

    (setq #k 0)
    (setq #enName$ nil) ; ��߰��̔����ް
    (repeat (sslength #ssDOOR)
      ; (ssname #ssDOOR #k) ��&lst�̉��Ԗڂ�(#no)
      (setq #loop T #j 0)
      (while (and #loop (< #j (length &lst)))
        (if (equal (ssname #ssDOOR #k)(nth #j &lst))
          (setq #no #j #loop nil)
        );_if
        (setq #j (1+ #j))
      )
      (setq #enName$ (append #enName$ (list (nth #no &lst2))))
      (setq #k (1+ #k))
    )

    ; ��߰��̔� ���O�̂Ȃ���ٰ�ߖ�
    (setq #sGrName (SKGetGroupName (nth 0 #enName$)))
;;;01/09/18YM@MOD   (command "-group" "E" #sGrName) ; ����

  ;02/01/30 YM ��߰��ɸ�ٰ�߉����͂����A���O�̂Ȃ����ٰ�ߖ���ύX("gruop" "REN")
  ;            ���ĸ�ٰ�߂̐���"DoorGroup"�̒ǉ�(entmod)���s��.

;;;02/01/30YM@DEL   ; 01/09/18 YM ADD-S
;;;02/01/30YM@DEL    (if (/= "ACAD" (strcase (getvar "PROGRAM")))
;;;02/01/30YM@DEL      (command "_.-group" "U" #sGrName)
;;;02/01/30YM@DEL      (command "_.-group" "E" #sGrName)
;;;02/01/30YM@DEL    );_if
;;;02/01/30YM@DEL   ; 01/09/18 YM ADD-E

;;;02/01/30YM@DEL    ; �i�[�����ړ���}�`�̑S�Ă𓯈�̃O���[�v�ɂ���(�O���[�v��)
;;;02/01/30YM@DEL    (command "-group" "C" (strcat SKD_GROUP_HEAD #sLAYER (itoa SKD_GROUP_NO)) SKD_GROUP_INFO) ; "C","���O","����"
;;;02/01/30YM@DEL    (foreach #nn #enName$
;;;02/01/30YM@DEL      (command #nn)
;;;02/01/30YM@DEL    )
;;;02/01/30YM@DEL    (command "")

    ; 02/01/30 YM ADD-S ; ��ٰ�ߖ��ύX "REN","���̖��O","�V�������O"
    (command "-group" "REN" #sGrName (strcat SKD_GROUP_HEAD #sLAYER (itoa SKD_GROUP_NO)))
    ; ��ٰ�߂̐���"DoorGroup"�̒ǉ�
    (KPChgGrpSETUMEI (nth 0 #enName$) SKD_GROUP_INFO) ; (����\�}�`,��ٰ�߂̐���)
    ; 02/01/30 YM ADD-E

  );foreach

  (princ)
);AfterCopySetDoorGroup

;<HOM>*************************************************************************
; <�֐���>    : KPChgGrpSETUMEI
; <�����T�v>  : ��ٰ�߂̐���"DoorGroup"�̒ǉ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/01/30 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KPChgGrpSETUMEI(
  &enDoor
  &sSETUMEI
  /
  #330 #ED #EG$ #ET
  )
  (setq #eg$ (entget &enDoor))
  ; 330�}�`�̂���"GROUP"���擾
  (setq #330 nil)
  (foreach #eg #eg$
    (if (and (= (car #eg) 330)(= "GROUP" (strcase (cdr (assoc 0 (entget (cdr #eg)))))))
      (setq #330 (cdr #eg))
    );_if
  )
  ; 300="" ��ٰ�ߖ��ύX
  (setq #et (entget #330))
  (setq #ed (subst (cons 300 &sSETUMEI) (assoc 300 #et) #et))
  (entmod #ed)
  (princ)
);KPChgGrpSETUMEI

;<HOM>*************************************************************************
; <�֐���>    : SetG_BODY
; <�����T�v>  : "G_BODY"(���}�`)�g���f�[�^�̕ύX
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2000-3-3 YM
; <���l>      : �R�s�[�n�R�}���h�p
;*************************************************************************>MOH<
(defun SetG_BODY(
  &lst    ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�ύX��
  &lst2   ; �I��v�f�̑S�O���[�v�}�`�����X�g,�g���f�[�^�Z�b�g��
  /
  #i
  #elm
  #xd
  #xd0
  #n1
  #n2
  #en_tei
  #en_tei0
  #ANA #ANA0 #K #KOSU
  )

;;; "G_BODY" �̈ʒu����+�ύX ;;;
  (setq #i 0)
  (repeat (length &lst)
    (setq #elm (nth #i &lst))                                 ; ���X�g�̊e�v�f�i�}�`���j
    (setq #xd0 (CFGetXData #elm "G_BODY"))
    ;;; ���X�g��#n1�Ԗڂ�("G_PRIM")�̃n���h�������ڂ��A
    ;;; ���X�g��#n2�Ԗڂ�("G_PRIM")�̐}�`�n���h���ɕύX����.
    (if #xd0
      (progn
        (setq #xd #xd0) ; 01/01/06 YM
        (setq #n1 #i)
        (setq #kosu (nth 1 #xd0))                             ; ���}�`��
        (setq #k 2)
        (repeat #kosu
          (setq #ana0 (nth #k #xd0))                          ; ���}�`�����
          (setq #n2 (CMN_search_en_lis #ana0 &lst))           ; ����1������2�̃��X�g�̉��Ԗڂ̗v�f��
          (setq #ana (nth #n2 &lst2))                         ; ��߰�㌊�}�`��
          (setq #xd (CMN_subs_elem_list #k #ana #xd))         ; ؽĂ̗v�f�ύX ; 01/01/06 YM
          (setq #k (1+ #k))
        )
        (if (= #kosu 0)
;;;01/05/01YM@          (CFSetXData (nth #n1 &lst2) "G_BODY" #xd0) ; 01/01/06 YM MOD
          nil ; �������Ȃ�
          (CFSetXData (nth #n1 &lst2) "G_BODY" #xd ) ; 01/01/06 YM MOD
        );_if
      )
    );_if

  (setq #i (1+ #i))
  );_(repeat
  (princ)
)


;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_ss_to_en
;;; <�����T�v>  : �I���Z�b�g��n���Đ}�`���̃��X�g�𓾂�.
;;; <����>      : �I���Z�b�g
;;; <�߂�l>    : (�}�`��1,2,...,n)
;;; <���l>      : YM
;;;*************************************************************************>MOH<
(defun CMN_ss_to_en(
  &ss     ; �I���Z�b�g
  /
  #en_lis ; (�}�`��1,2,...,n)
  #i
  )
  (setq #i 0 #en_lis nil)
  (if &ss
    (if (> (sslength &ss) 0)
      (repeat (sslength &ss)
        (setq #en_lis (append #en_lis (list (ssname &ss #i)) ))
        (setq #i (1+ #i))
      );_(while (< #i #l)
    );_if
  );_if
  #en_lis
);CMN_ss_to_en()

;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_ssaddss
;;; <�����T�v>  : old�I���Z�b�g��new�I���Z�b�g�ǉ����ĐV�����I���Z�b�g���쐬.
;;; <����>      : new�I���Z�b�g,old�I���Z�b�g
;;; <�߂�l>    : �ǉ���̑I���Z�b�g
;;; <���l>      : YM
;;;*************************************************************************>MOH<
(defun CMN_ssaddss(
  &ss_new ;
  &ss_old ;
  /
  #i      ;
  #kosu
  #lis
  )

  (if (and (= &ss_new nil) (= &ss_old nil)) ; ���������� nil
    (progn
      (princ "\nCMN_ssaddss �������Ⴂ�܂��B [(= &ss_new nil) (= &ss_old nil)]")(quit)
    )
  )

  (cond
   ((= &ss_new nil) &ss_old) ; �Е��� nil
   ((= &ss_old nil) &ss_new) ; �Е��� nil
   (t
      (setq #i 0)
      (setq #lis  (CMN_ss_to_en &ss_new))
      (setq #kosu (length #lis))
      (repeat #kosu
        (ssadd (nth #i #lis) &ss_old)
        (setq #i (1+ #i))
      );_(repeat
      &ss_old
    )
  )


);CMN_ssaddss()

;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_enlist_to_ss
;;; <�����T�v>  : �}�`���̃��X�g����I���Z�b�g���쐬
;;; <����>      : �}�`���̃��X�g
;;; <�߂�l>    : �I���Z�b�g
;;; <���l>      : YM
;;;*************************************************************************>MOH<
(defun CMN_enlist_to_ss(
  &nm_lis  ; �}�`���̃��X�g
  /
  #ss      ; �I���Z�b�g
  #i
  )

  (setq #i 0)
  (setq #ss (ssadd)) ; ��̑I���Z�b�g�쐬

  (while (< #i (length &nm_lis))
    (ssadd (nth #i &nm_lis) #ss)
    (setq #i (1+ #i))
  );_(while
  #ss
);CMN_enlist_to_ss

;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_all_en_list
;;; <�����T�v>  : �}�ʏ�̑S�Ă̐}�`���̃��X�g(�Â���)��߂��B
;;; <����>      : �Ȃ�
;;; <�߂�l>    : (�}�`��1,2,...,n)
;;; <���l>      : visual lisp window �u�\���v�u�}�ʃf�[�^�x�[�X���Q�Ɓv
;;;              �u���ׂĂ̐}�`���Q�Ɓv�ł��݂��BYM
;;;*************************************************************************>MOH<
(defun CMN_all_en_list(
  /
  #zu0
  #zu
  #z_lis
  #i
  )

  (setq #zu nil)
  (setq #zu0 nil)
  (setq #z_lis nil)

  (setq #zu0 (entlast)) ; �Ō�̐}�`
  (setq #zu  (entnext)) ; �ŏ��̐}�`

  (setq #i 0)
  (while #zu
    (setq #z_lis (cons #zu #z_lis)) ; ���X�g�ɒǉ�
    (setq #zu (entnext #zu))
    (setq #i (1+ #i))
  );_(while #zu

;-- 2012/01/05 A.Satoh Mod - S
;;;;;  (cons #i (reverse #z_lis)) ; ���X�g�ɒǉ�
  (cons #i #z_lis) ; ���X�g�ɒǉ�
;-- 2012/01/05 A.Satoh Mod - E

);CMN_all_en_list(

;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_all_en_kosu
;;; <�����T�v>  : �}�ʏ�̑S�Ă̐}�`����߂�.
;;; <����>      : �}�ʏ�̑S�Ă̐}�`��
;;; <�߂�l>    :
;;; <���l>      : 2000.4.1 YM
;;;*************************************************************************>MOH<
(defun CMN_all_en_kosu(
  /
  #zu0
  #zu
  #i
  )

  (setq #zu0 (entlast)) ; �Ō�̐}�`
  (setq #zu  (entnext)) ; �ŏ��̐}�`

  (setq #i 0)
  (while #zu
    (setq #zu (entnext #zu))
    (setq #i (1+ #i))
  );_(while #zu
  #i
);CMN_all_en_kosu(

;<HOM>*************************************************************************
; <�֐���>    : CMN_subs_elem_list
; <�����T�v>  : ���X�g(&list$)��"&i"(0,1,2...)�Ԗڂ̗v�f��"&element"�ɕύX����.
; <����>      : �v�f�ԍ�,�V�����v�f,�ύX�Ώۃ��X�g
; <�߂�l>    : �ύX��̃��X�g
; <�쐬>      : 1999-11-22 YM
; <���l>      :
;*************************************************************************>MOH<
(defun CMN_subs_elem_list(
  &i
  &element
  &list$
  /
  #i
  #element
  #ret$
  )

  (if (= (type &list$) 'LIST) ; ���������X�g���ǂ���
    (progn
      (setq #ret$ '())
      (setq #i 0)
      (repeat (length &list$)
        (setq #element (nth #i &list$))
        (if (= #i &i)
          (progn
            (setq #ret$ (append #ret$ (list &element)))
          );_(progn
          (progn
            (setq #ret$ (append #ret$ (list #element)))
          );_(progn
        );_(if (= #i &i)
      (setq #i (1+ #i))
      );_(repeat (length &list$))
      #ret$
    );_(progn
    (progn
      (princ "\nCMN_subs_elem_list �������Ⴂ�܂��B :")(quit)
    );_(progn
  );_(if

);CMN_subs_elem_list

;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_search_en_lis
;;; <�����T�v>  : �}�`�����A�}�`�����X�g�̉��Ԗڂɂ��邩.
;;; <����>      : �}�`���A  �}�`�����X�g(�d���Ȃ�)
;;; <�߂�l>    : ����(0,1,2,...)
;;; <���l>      : YM
;;;*************************************************************************>MOH<
(defun CMN_search_en_lis(
  &en       ;
  &en_lis   ;
  /
  #i
  #n
  #en
  #flg
  #hdl
  #hdl0
  )

  (if (and (= (type &en) 'ENAME) (= (type &en_lis) 'LIST))
    (progn
      (setq #i 0)
      (setq #n nil)
      (setq #flg T)
      (setq #hdl0  (cdr (assoc 5 (entget &en))))
      (while #flg
        (setq #en (nth #i &en_lis))
        (setq #hdl (cdr (assoc 5 (entget #en))))

        (if (= #hdl0 #hdl)
          (progn
            (setq #n #i)
            (setq #flg nil)
          );_(progn
        );_(if (= #en &en)

        (setq #i (1+ #i))
        (if (= #i (length &en_lis))(setq #flg nil))
      )
      #n
    );_(progn
    (progn
      (princ "\nCMN_search_en_lis �������Ⴂ�܂��B :")(quit)
    );_(progn
  );_(if

);CMN_search_en_lis()

;;;<HOM>*************************************************************************
;;; <�֐���>    : advance
;;; <�����T�v>  : ����(nick)�Ő��l�̌J��グ
;;; <����>      : ���l(val),����(nick)
;;; <�߂�l>    : ���l
;;; <�쐬>      :     2000.1.25 YM
;;; <���l>      : (advance 625 50) --> 650 , (advance 43 6) --> 48
;;;*************************************************************************>MOH<

(defun advance (&val &nick / #ret)
  (if (equal &val 0.0 0.001)
    (setq #ret 0.0)
    (setq #ret (* &nick (+ (fix (/ (- &val 0.001) &nick)) 1)))
  );_if
)

;<HOM>*************************************************************************
; <�֐���>    : DBCheck
; <�����T�v>  : �c�a�����`�F�b�N����
; <�߂�l>    : ں���
; <�쐬>      : 2000.3.16 YM
; <���l>      :
;;; (setq #qry$ (DBCheck #qry$ "�w�v���Ǘ��x" "PFGetCompBase")); 00/03/16 @YM@ ��������
;;; CFGetDBSQLRec ���� Pclosnk.lsp �܂� Pcwktop
;;; 02/09/04 YM ADD WEB�łł͌x���\�����Ȃ�
;*************************************************************************>MOH<
(defun DBCheck (
  &lis$ ; ں���
  &msg1 ; table��
  &msg2 ; �֐���
  /
  #MSG
  )

  (if (= &lis$ nil)
    (progn
      (setq #msg (strcat &msg1 "�Ƀ��R�[�h������܂���B\n" &msg2))
      (CMN_OutMsg #msg)
    )
    (progn
;;;      (CFOutStateLog 1 1 "*** �擾ں��� ***")
;;;      (CFOutStateLog 1 1 &lis$)
      
      (WebOutLog "*** �擾ں��� ***********************************************************************")
      (WebOutLog &lis$)
      (WebOutLog "*************************************************************************************")
      

      (if (= (length &lis$) 1)
        (progn
          (setq &lis$ (car &lis$))
        )
        (progn ; ����˯Ă����Ƃ��ʹװ
          (setq #msg (strcat &msg1 "�Ƀ��R�[�h����������܂���.\n" &msg2))
          (CMN_OutMsg #msg) ; 02/09/05 YM ADD
        )
      );_if
    )
  );_if
  &lis$
)

;<HOM>*************************************************************************
; <�֐���>    : CMN_OutMsg
; <�����T�v>  : �װ����ү���ޏo��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/09/05 YM ADD
; <���l>      : CG_AUTOMODE�ɂ�菈���𕪂���
;*************************************************************************>MOH<
(defun CMN_OutMsg (
  &msg
  /
  #MSG
  )
  (CFOutStateLog 0 1 &msg) ; ���ޯ��Ӱ�ޗp
  (if (= CG_AUTOMODE 2)
    (WebOutLog &msg)  ; WEB�Œʏ�۸�
    (CFAlertMsg &msg) ; �x�����
  )
  (setq CG_ERRMSG (list &msg))
  (*error* CG_ERRMSG)
);CMN_OutMsg

;;;<HOM>*************************************************************************
;;; <�֐���>    : DBCheck2
;;; <�����T�v>  : �c�a�����`�F�b�N
;;; <�߂�l>    :
;;; <�쐬>      : 00/11/04 YM
;;; <���l>      : �װ�ł������Ȃ�
;;;*************************************************************************>MOH<
(defun DBCheck2 (
  &lis$ ; ں���
  &msg1 ; table��
  &msg2 ; key
  /
  #MSG #RET
  )

  (if (= &lis$ nil)
    (progn
      (setq #msg (strcat &msg1 "�Ƀ��R�[�h������܂���" &msg2))
      (CFOutStateLog 0 1 #msg)
      (CFOutLog 1 nil #msg)
      (setq #ret nil)
    )
    (progn
      (CFOutStateLog 1 1 "*** �擾ں��� ***")
      (CFOutStateLog 1 1 &lis$)
      (if (= (length &lis$) 1)
        (progn
          (setq #ret (car &lis$))
        )
        (progn ; ����˯Ă����Ƃ��ʹװ
          (setq #msg (strcat &msg1 "�Ƀ��R�[�h����������܂���" &msg2))
          (CFOutStateLog 0 1 #msg)
          (CFOutLog 1 nil #msg)
          (setq #ret nil)
        )
      );_if
    )
  );_if
  #ret
);_DBCheck2

;;;<HOM>*************************************************************************
;;; <�֐���>    : DBCheck3
;;; <�����T�v>  : �c�a�����`�F�b�N����
;;; <�߂�l>    : ں���
;;; <�쐬>      : 01/01/22 YM
;;; <���l>      : ں��ޕ���==>�������ɺ����ײ݂�ү����(car �Ŏ擾
;;;*************************************************************************>MOH<
(defun DBCheck3 (
  &lis$ ; ں���
  &msg1 ; table��
  &msg2 ; �֐���
  /
  #MSG
  )

  (if (= &lis$ nil)
    (progn
      (setq #msg (strcat &msg1 "�Ƀ��R�[�h������܂���B\n" &msg2))
      (CFOutStateLog 0 1 #msg)
      (CFAlertMsg #msg)
      (*error*)
    )
    (progn
      (CFOutStateLog 1 1 "*** �擾ں��� ***")
      (CFOutStateLog 1 1 &lis$)
      (if (= (length &lis$) 1)
        (progn
          (setq &lis$ (car &lis$))
        )
        (progn ; ����˯Ă����Ƃ��ʹװ
          (setq #msg (strcat "\n" &msg1 "�Ƀ��R�[�h����������܂���.\n"))
          (CFOutStateLog 0 1 #msg)
          (princ #msg) ; �����ײ݂ɕ\��
          (setq &lis$ (car &lis$))
        )
      );_if
    )
  );_if
  &lis$
);DBCheck3

;;;<HOM>*************************************************************************
;;; <�֐���>     : AddPline
;;; <�����T�v>   : ���ײ݂�1�{�� pedit
;;; <����>       : ���ײݐ}�`��ؽ�
;;; <�߂�l>     : 1�{�����ꂽ���ײ�
;;; <�쐬>       : 2000.3.16 YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun AddPline (
  &en_lis ; ���ײݐ}�`��ؽ�
  /
  #EN #I
  )

  (command "pedit")
  (setq #i 0)
  (repeat (length &en_lis)
    (setq #en (nth #i &en_lis))
    (command #en)
    (if (= #i 0) ; �ŏ��̐}�`
      (command "J")
    );if
    (setq #i (1+ #i))
  )
  (command "" "")
  (car &en_lis)
);AddPline

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetLwPolyLineStEnPt
;;; <�����T�v>  : ���C�g�E�F�C�g�|�����C���̎n�_�A�I�_���擾����
;;; <�߂�l>    : (�n�_�A�I�_)
;;; <�쐬>      : 00/03/15 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun GetLwPolyLineStEnPt (
  &en
  /
  #ELM #END #ET #FLG #I #KOSU #START
  )
  (setq #et (entget &en))

  (setq #kosu (length #et))
  (setq #i 0)
  (setq #flg nil)
  (repeat #kosu
    (setq #elm (nth #i #et))
    (if (= (car #elm) 10)
      (progn
        (if (= #flg nil)
          (progn
            (setq #START (cdr #elm))
            (setq #flg T)
          )
        );_if
        (setq #END (cdr #elm))
      )
    );_if
    (setq #i (1+ #i))
  )
  (list #START #END)
);GetLwPolyLineStEnPt

;;;<HOM>*************************************************************************
;;; <�֐���>    : MakeLWPL
;;; <�����T�v>  : ����0��LWPOLYLINE������
;;; <�߂�l>    :
;;; <�쐬>      : 2000.3.27 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun MakeLWPL (
  &pt$       ;�_��
  &flg ; 0:�J�� 1:����
  /
  #i
  )
  (setq #i 0)
  (repeat (length &pt$)
    (if (= #i 0) (command "._PLINE" (nth #i &pt$) "W" "0" "0"))
    (if (> #i 0) (command (nth #i &pt$)))
    (setq #i (1+ #i))
  )
  (if (= &flg 0)
    (command "") ; �J��
    (command "CL") ; ����
  );_if

  (entlast)
);MakeLWPL

;;;<HOM>*************************************************************************
;;; <�֐���>    : ListEdit
;;; <�����T�v>  : ����1(ؽ�)�Ɉ���2(ؽ�)�̗v�f�𑫂��A����3�̗v�f���폜
;;; <�߂�l>    : ؽ�
;;; <�쐬>      : 2000.3.16 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun ListEdit (
  &lis
  &lis2
  &elm
  /
  #AAA #BBB #RET
)
  (setq #RET (append &lis &lis2))
  (setq #aaa (cdr (member &elm #RET)))
  (setq #bbb (cdr (member &elm (reverse #RET))))
  (setq #RET (append #aaa #bbb))
);ListEdit

;;;<HOM>*************************************************************************
;;; <�֐���>    : ListDel
;;; <�����T�v>  : ����1(ؽ�)�������2(�I���)�̗v�f���폜
;;; <�߂�l>    : ؽ�
;;; <�쐬>      : 2000.3.27 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun ListDel (
  &lis1
  &ss   ; �I���
  /
  #ELM #I #RET$ #LIS
)

  (setq #lis (CMN_ss_to_en &ss)) ; �}�`��ؽĂɕς���
  (setq #i 0)
  (repeat (length &lis1)
    (setq #elm (nth #i &lis1))
    (if (= (member #elm #lis) nil)
      (setq #ret$ (append #ret$ (list #elm)))
    )
    (setq #i (1+ #i))
  )
  #ret$
);ListDel

;<HOM>*************************************************************************
; <�֐���>    : GroupInSolidChgCol2
; <�����T�v>  : �}�`��F�ւ�����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-14
; <���l>      :
;*************************************************************************>MOH<
(defun GroupInSolidChgCol2 (
    &sym     ;(ENAME)�}�`
    &col     ;(STR)�F
    /
    #en #en$
    #ss
    #ps
  )

  (setq #ps (getvar "PICKSTYLE"))
  (setvar "PICKSTYLE" 3)
  (if (entget &sym) ; 00/07/03 YM ADD
    ;(command "_change" &sym "" "P" "C" &col "")
    ; 00/10/26 MOD MH "_change" ��UCS �ɕ��s�łȂ��}�`���R��邽��
    (command "_chprop" &sym "" "C" &col "")
  );_if

;;;  (MakeSymAxisArw &sym) ; ������}
  (setvar "PICKSTYLE" #ps)
  (princ)
);GroupInSolidChgCol2

; <HOM>***********************************************************************************
; <�֐���>    : GetMinMaxLineToPT$
; <�����T�v>  : ���ײ݂̊e�_�Ɛ���(�n�_,�I�_)�Ƃ̋����̍ŏ��l,�ő�l��ؽĂ�Ԃ�
; <�߂�l>    : (�����ŏ�,�����ő�)
; <�쐬>      : 2000-04-29  : YM
; <���l>      :
; ***********************************************************************************>MOH<
(defun GetMinMaxLineToPT$ (
  &PT$   ; ���ײ݊O�`�_��
  &LINE$ ; �����_��ؽ�(�n�_,�I�_)
  /
  #DIS #DIS_MAX #DIS_MIN #RET$
  )
  (setq #dis_min 1.0e+10 #dis_max -999999)
  (foreach #pt &PT$
    (setq #dis (distance #pt (CFGetDropPt #pt &LINE$)))
    (if (>= #dis_min #dis)(setq #dis_min #dis))
    (if (<= #dis_max #dis)(setq #dis_max #dis))
  )
  (setq #ret$ (list #dis_min #dis_max))
);GetMinMaxLineToPT$

;;;<HOM>*************************************************************************
;;; <�֐���>    : FlagToList
;;; <�����T�v>  : 3���̐�����0�����X�g��
;;; <����>      : ����
;;; <�߂�l>    : ���X�g
;;;               23 --->(0 2 3) 123--->(1 2 3) 7--->(0 0 7)
;;; <�쐬>      : 2000.3.29 YM
;;;*************************************************************************>MOH<
(defun FlagToList ( &int / )

  (cond
    ((= (strlen (itoa &int)) 1)
        (list 0 0 &int)
    )
    ((= (strlen (itoa &int)) 2)
        (list 0 (atoi (substr (itoa &int) 1 1))
                (atoi (substr (itoa &int) 2 1))
        )
    )
    ((= (strlen (itoa &int)) 3)
        (list (atoi (substr (itoa &int) 1 1))
              (atoi (substr (itoa &int) 2 1))
              (atoi (substr (itoa &int) 3 1))
        )
    )
  );_cond
);FlagToList

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetWT_outPT
;;; <�����T�v>  : ܰ�į�ߐ}�`����n���ĊO�`�_���߂�
;;; <�߂�l>    : �_��(�n�_�𖖔��ɒǉ��ς�)
;;; <�쐬>      : 2000.4.10 YM ; 01/08/10 YM ADD(�����ǉ�)
;;;*************************************************************************>MOH<
(defun PKGetWT_outPT (
  &WT ; WT�}�`��
  &flg; �׸�=T:�n�_�𖖔��ɒǉ�����,nil:���Ȃ� ; 01/08/10 YM ADD(�����ǉ�)
  /
  #pt$
  )
  (setq #pt$ (GetLWPolyLinePt (nth 38 (CFGetXData &WT "G_WRKT")))) ; WT��ʊO�`�̈�_��擾
  (if &flg
    (AddPtList #pt$)
    #pt$
  );_if
);PKGetWT_outPT

;;;<HOM>*************************************************************************
;;; <�֐���>    : AddPtList
;;; <�����T�v>  : �_��̖����Ɏn�_�������ĕԂ�
;;; <�߂�l>    : �_��
;;; <�쐬>      : 2000.4.10 YM
;;;*************************************************************************>MOH<
(defun AddPtList (&pt$ / )
  (append &pt$ (list (car &pt$)))
);AddPtList

;;; <HOM>***********************************************************************************
;;; <�֐���>    : NotNil_length
;;; <�����T�v>  : list��nil�łȂ��v�f����Ԃ�
;;; <�߂�l>    :
;;; <�쐬>      : 2000.7.6�@ YM
;;; <���l>      :
;;; ***********************************************************************************>MOH<
(defun NotNil_length ( &lis / #kosu)
  (setq #kosu 0)
  (foreach #elm &lis
    (if #elm (setq #kosu (1+ #kosu)))
  )
  #kosu
);NotNil_length

;;; <HOM>***********************************************************************************
;;; <�֐���>    : NilDel_List
;;; <�����T�v>  : ؽĂ���nil������
;;; <�߂�l>    : nil��������ؽ�
;;; <�쐬>      : 07/06 YM
;;; <���l>      :
;;; ***********************************************************************************>MOH<
(defun NilDel_List (
  &lis
  /
  #RET$ #elm
  )
  (setq #ret$ '())
  (foreach #elm &lis
    (if #elm (setq #ret$ (append #ret$ (list #elm))))
  )
  #ret$
);NilDel_List

;;; <HOM>***********************************************************************************
;;; <�֐���>    : PKDirectPT
;;; <�����T�v>  : �_��̊e�_���S�Ē����̓������ɂ���� nil
;;; <�߂�l>    :
;;; <�쐬>      : 2000-05-12  : YM
;;; <���l>      :
;;; ***********************************************************************************>MOH<
(defun PKDirectPT (
  &pt$   ; �_��
  &line$ ; �����̎n�_,�I�_ؽ�
  /
  #FLG #LR #LR0
  )

  (setq #flg nil)
  (setq #lr0 (CFArea_rl (car &line$) (cadr &line$) (car &pt$))) ; �ŏ��̓_�̑�
  (foreach #pt &pt$
    (setq #lr (CFArea_rl (car &line$) (cadr &line$) #pt)) ; �E������
    (if (/= #lr #lr0)
      (setq #flg T)
    )
  )
  #flg
);PKDirectPT

;;;<HOM>*************************************************************************
;;; <�֐���>    : MakeRectanglePT
;;; <�����T�v>  : ���S&pt,�ӂ̒���&a*2�̐����`�O�`�_��(�����Ɏn�_��ǉ�)��Ԃ�
;;; <�߂�l>    : �_��
;;; <�쐬>      : 2000.6.7 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun MakeRectanglePT (
  &pt
  &a
  /
  #P1 #P2 #P3 #P4
  )
  (setq #p1 (list (+ (car &pt) &a) (+ (cadr &pt) &a)))
  (setq #p2 (list (- (car &pt) &a) (+ (cadr &pt) &a)))
  (setq #p3 (list (- (car &pt) &a) (- (cadr &pt) &a)))
  (setq #p4 (list (+ (car &pt) &a) (- (cadr &pt) &a)))
  (list #p1 #p2 #p3 #p4 #p1)
);MakeRectanglePT

;;;<HOM>*************************************************************************
;;; <�֐���>     : KCGetZaiF
;;; <�����T�v>   : �ގ��L������f��F���擾����
;;; <�߂�l>     : �f��F(���l)
;;; <�쐬>       : 01/01/15 YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun KCGetZaiF (
  &ZaiCode ; �ގ��L��
  /
  #QRY$ #ZAIF
  )

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "WT�ގ�"
      (list
        (list "�ގ��L��" &ZaiCode 'STR)
      )
    )
  )

  (if (and #qry$ (= (length #qry$) 1))
    (setq #ZaiF (nth 3 (car #qry$))) ; �f��F 0:�l�H�嗝�� 1:���ڽ  ;2008/06/23 YM OK
  ;  else
    (progn ; WEB�Ń_�C�A���O�\�����Ȃ� 03/02/04 YM ADD
      (if (= CG_AUTOMODE 2) ; 02/09/02 YM WEB�Ŏ���Ӱ�ނ͋����I��
        (*error*)
      ; else
        (progn
          (CFAlertMsg (strcat "�ގ��L�����s���ł��B" "\n�ގ��L��: " &ZaiCode))
          (setq #ZaiF nil)
        )
      );_if
    )
  );_if
  #ZaiF
);KCGetZaiF

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPChangeArea$
;;; <�����T�v>  : �O�`�_��̎w�葤���w�軲�ޕ��g��k��
;;; <�߂�l>    : �_��(ؽ�)
;;; <�쐬>      : 01/03/30 YM
;;; <���l>      : �_���PMEN2�O�`���ײ݂���Ƃ�A����وʒu���玞�v�܂��̏�
;�_��(�ʏ���4�_,��Ű����6�_)�ƕύX��������("L","R","U","D")�ƕύX����
;       "U"
;   @----------+
;   | �^�ォ�� |
;"L"|          |"R"
;   |          |
;   +----------+
;      "D"
;;;*************************************************************************>MOH<
(defun KPChangeArea$ (
  &pt$
  &SIDE
  &SIZE
  /
  #KOSU #P1 #P2 #P3 #P4 #P5 #P6 #PT$
  #P11 #P22 #P33 #P44 #P55 #P66
  )
  (setq #kosu (length &pt$))
  (cond
    ((= #kosu 4)
      (setq #p1 (nth 0 &pt$))
      (setq #p2 (nth 1 &pt$))
      (setq #p3 (nth 2 &pt$))
      (setq #p4 (nth 3 &pt$))
      (cond
        ((= &SIDE "L")
          (setq #p11 (polar #p1 (angle #p2 #p1) &SIZE))
          (setq #p44 (polar #p4 (angle #p2 #p1) &SIZE))
          (setq #pt$ (list #p11 #p2 #p3 #p44))
        )
        ((= &SIDE "R")
          (setq #p22 (polar #p2 (angle #p1 #p2) &SIZE))
          (setq #p33 (polar #p3 (angle #p1 #p2) &SIZE))
          (setq #pt$ (list #p1 #p22 #p33 #p4))
        )
        ((= &SIDE "U")
          (setq #p11 (polar #p1 (angle #p3 #p2) &SIZE))
          (setq #p22 (polar #p2 (angle #p3 #p2) &SIZE))
          (setq #pt$ (list #p11 #p22 #p3 #p4))
        )
        ((= &SIDE "D")
          (setq #p33 (polar #p3 (angle #p2 #p3) &SIZE))
          (setq #p44 (polar #p4 (angle #p2 #p3) &SIZE))
          (setq #pt$ (list #p1 #p2 #p33 #p44))
        )
      );_cond
    )
    ((= #kosu 6)
      (setq #p1 (nth 0 &pt$))
      (setq #p2 (nth 1 &pt$))
      (setq #p3 (nth 2 &pt$))
      (setq #p4 (nth 3 &pt$))
      (setq #p5 (nth 4 &pt$))
      (setq #p6 (nth 5 &pt$))
      (cond
        ((= &SIDE "L")
          (setq #p11 (polar #p1 (angle #p2 #p1) &SIZE))
          (setq #p66 (polar #p6 (angle #p2 #p1) &SIZE))
          (setq #pt$ (list #p11 #p2 #p3 #p4 #p5 #p66))
        )
        ((= &SIDE "R")
          (setq #p22 (polar #p2 (angle #p1 #p2) &SIZE))
          (setq #p33 (polar #p3 (angle #p1 #p2) &SIZE))
          (setq #pt$ (list #p1 #p22 #p33 #p4 #p5 #p6))
        )
        ((= &SIDE "U")
          (setq #p11 (polar #p1 (angle #p3 #p2) &SIZE))
          (setq #p22 (polar #p2 (angle #p3 #p2) &SIZE))
          (setq #pt$ (list #p11 #p22 #p3 #p4 #p5 #p6))
        )
        ((= &SIDE "D")
          (setq #p55 (polar #p5 (angle #p2 #p3) &SIZE))
          (setq #p66 (polar #p6 (angle #p2 #p3) &SIZE))
          (setq #pt$ (list #p1 #p2 #p3 #p4 #p55 #p66))
        )
      );_cond
    )
  );_cond
  #pt$
);KPChangeArea$

;;;<HOM>***********************************************************************
;;; <�֐���>    : GetCenterPT3D
;;; <�����T�v>  : 2��̒��_��Ԃ�
;;; <�߂�l>    : 3D���W
;;; <�쐬>      : 01/04/04 YM
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun GetCenterPT (
  &p1
  &p2
  /
  #pt #X #Y #Z
  )
  (setq #pt (mapcar '+ &p1 &p2))
  (setq #x (* (car  #pt) 0.5))
  (setq #y (* (cadr #pt) 0.5))
  (if (caddr #pt)
    (progn
      (setq #z (* (caddr #pt) 0.5))
      (setq #pt (list #x #y #z))
    )
    (setq #pt (list #x #y))
  );_if
  #pt
);GetCenterPT

;;;<HOM>*************************************************************************
;;; <�֐���>     : RemoveSameDirectPT
;;; <�����T�v>   : �_��ؽĂ̔C�ӂׂ̗荇���R�_�����꒼����ɂ���ꍇ�A�_���폜����
;;; <�߂�l>     : �s�v�_�폜��̓_��ؽ�
;;; <�쐬>       : 01/06/26 YM
;;; <���l>       : ���g�p
;;;*************************************************************************>MOH<
(defun RemoveSameDirectPT (
  &pt$ ; WT�O�`�̈�_��
  /
  #ANG1 #ANG2 #I #P1 #P2 #P3 #PT$ #RET_PT$
  )
  (setq #ret_pt$ '())
  (setq #pt$ (append (list (last &pt$)) &pt$ (list (nth 0 &pt$)))) ; �O���2�_�ǉ�����
  (setq #i 0)
  (repeat (length &pt$)
    ; �A������3�_
    (setq #p1 (nth (+ #i 0) #pt$))
    (setq #p2 (nth (+ #i 1) #pt$))
    (setq #p3 (nth (+ #i 2) #pt$))
    (setq #ang1 (angle #p1 #p2))
    (setq #ang2 (angle #p2 #p3))
    (if (equal #ang1 #ang2 0.001)
      nil ; ���꒼����ɂ��邽�ߐ^�񒆂̓_���폜���Ȃ��Ƃ����Ȃ�
      (setq #ret_pt$ (append #ret_pt$ (list #p2))) ; �^�񒆂̓_��ǉ����Ă���
    );_if
    (setq #i (1+ #i))
  )
  #ret_pt$
);RemoveSameDirectPT

;;;<HOM>*************************************************************************
;;; <�֐���>     : RemoveSamePT
;;; <�����T�v>   : �_��ؽĂ̔C�ӂׂ̗荇��2�_������ł���ꍇ�_���폜����
;;; <�߂�l>     : �s�v�_�폜��̓_��ؽ�
;;; <�쐬>       : 01/06/26 YM
;;; <���l>       :
;;;*************************************************************************>MOH<
(defun RemoveSamePT (
  &pt$ ; WT�O�`�̈�_��
  /
  #I #P1 #P2 #PT$ #RET_PT$
  )
  (setq #ret_pt$ '())
  (setq #pt$ (append (list (last &pt$)) &pt$)) ; �O��1�_�ǉ�����
  (setq #i 0)
  (repeat (length &pt$)
    ; �A������2�_
    (setq #p1 (nth (+ #i 0) #pt$))
    (setq #p2 (nth (+ #i 1) #pt$))
    (if (equal (distance #p1 #p2) 0 0.001)
      nil ; ����_�ł��邽�ߓ_���폜
      (setq #ret_pt$ (append #ret_pt$ (list #p2))) ; 2�ڂ̓_��ǉ����Ă���
    );_if
    (setq #i (1+ #i))
  )
  #ret_pt$
);RemoveSamePT

;<HOM>*************************************************************************
; <�֐���>    : KPCheckMiniKitchen
; <�����T�v>  : Lipple �ź�۷��ނ�����=T ����ȊO=nil
; <�߂�l>    : T or nil
; <�쐬>      : 01/06/29 YM
;*************************************************************************>MOH<
(defun KPCheckMiniKitchen (
  &sym$ ; ���@����}����V���{���}�`���i�x�[�X �A�b�p�[���̑��j
  /
  #EXIST
  )
  (setq #EXIST nil) ; �}�ʏ�ɺ�۷��ނ�����
  (foreach #sym &sym$
    (if (and #sym  ; 01/07/19 TM ADD
             (= CG_SKK_ONE_CAB (CFGetSymSKKCode #sym 1))
             (= CG_SKK_TWO_BAS (CFGetSymSKKCode #sym 2))
             (= CG_SKK_THR_GAS (CFGetSymSKKCode #sym 3)))
      (setq #EXIST T) ; �}�ʏ�ɺ�۷���(113)������
    );_if
  )

  (if (and (equal (KPGetSinaType) 2 0.1) #EXIST)
    T
    nil
  );_if
);KPCheckMiniKitchen











;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; �ȉ������p�B�������
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:ppp( / )
  ; 01/09/21 YM �J���p
  (setvar "pickfirst" 1)
  (setvar "pickauto" 1)
  (setvar "GRIPS"     1)
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : c:all
;;; <�����T�v>  : �I�������}�`�̸�ٰ�����ް�̑S�}�`�����߁A����فA�g���ް���\��
;;;             : "G_LSYM"���Ȃ����ނ̊g���ް����\��
;;; <�쐬>      : 99/12/02  00/02/11 �C�� 00/02/24 �C�� YM
;;;*************************************************************************>MOH<
(defun c:all(
  /
  #DATE_TIME #EN #FIL #HAND #I #J #K #KOSU #LIS #NAME1 #NAME2 #SS #SYM
  #TYPE #XD #XD2 #XD_LSYM #XD_SYM #210 #LAYER #ZUKEI
  )

  (princ "���ނ�I��: ")
  (setq #en T)
  (while #en
    (setq #en (car (entsel)))
    (if (= #en nil)
      (progn
        (CFAlertErr "���ނ��I������܂���ł���")
        (setq #en T)
      )
      (progn
        (setq #sym (SearchGroupSym #en))   ; ����ِ}�`�� ; �e�}�`��
        (setq #ZUKEI #en)
        (setq #en nil) ; �����I�����ꂽ
      )
    )
  );while

  ; ̧��OPEN
  (setq #fil (open (strcat CG_SYSPATH "all.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n" #fil)

  (if #sym
    (progn ; ����ِ}�`
      (setq #ss (CFGetSameGroupSS #sym)) ; �S�O���[�v�����o�[�}�`
      (if (or (= #ss nil)(= (sslength #ss) 0))
        (progn
          (CFAlertErr "��ٰ�����ް������܂���")
          (if #fil (close #fil))
          (quit)
        )
      );_if

      (princ "-----------------------------------------------------------------"  #fil)
      (setq #xd_LSYM (car (cdr (assoc -3 (entget #sym '("G_LSYM"))))))
      (setq #xd_SYM  (car (cdr (assoc -3 (entget #sym '("G_SYM"))))))
      (setq #name1
        (list
          ":G_LSYM ����ي�_                       ";0
          ":�{�̐}�`ID    :10�޲�(dwģ�ٖ�)         ";1
          ":�}���_        :�z�u��_ x,y,z            ";2
          ":��]�p�x      :׼ޱ�                     ";3
          ":�H��L��      :2�޲�                     ";4
          ":�ذ�ދL��     :2�޲�                     ";5
          ":�i�Ԗ���      :20�޲�                    ";6
          ":L/R�敪       :Z,L,R                     ";7
          ":���}�`ID      :10�޲�                    ";8
          ":���J���}�`ID  :10�޲�                    ";9
          ":���i����      :�i�ԏ��̐��i����       ";10
          ":�����׸�      :0(�P��),1(����),2(OP����)";11
          ":�z�u���ԍ�    :�z�u���ԍ�(1�`)          ";12
          ":�p�r�ԍ�      :0�`99                    ";13
          ":���@�g        :�i�Ԑ}�`DB�̓o�^H���@�l  ";14
          ":�f�ʎw���L��  :0(�Ȃ�),1(����)          ";15
          ":����          :�L�b�`��(A) or ���[(D)   ";16
      ))
      (setq #name2
        (list
          ":G_SYM                                    "
          ":����ٖ���                                "
          ":���ĂP                                   "
          ":���ĂQ                                   "
          ":����ي�lW                             "
          ":����ي�lD                             "
          ":����ي�lH                             "
          ":����َ�t����                            "
          ":���͕��@                                 "
          ":W�����׸�                                "
          ":D�����׸�                               "
          ":H�����׸�                               "
          ":�L�k�׸�W                               "
          ":�L�k�׸�D                               "
          ":�L�k�׸�H                               "
          ":��ڰ�ײݐ�W                             "
          ":��ڰ�ײݐ�D                             "
          ":��ڰ�ײݐ�H                             "
      ))

      (setq #j 0) ; �g���f�[�^"G_LSYM"
      (repeat (length #xd_LSYM)
        (princ "\n[" #fil)(princ #j #fil)(princ "]" #fil)
        (princ (nth #j #name1) #fil)
        (princ (nth #j #xd_LSYM) #fil)
        (setq #j (1+ #j))
      )
      (princ "\n -----------------------------------------------------------------"  #fil)
      (setq #j 0) ; �g���f�[�^"G_SYM"
      (repeat (length #xd_SYM)
        (princ "\n[" #fil)(princ #j #fil)(princ "]" #fil)
        (princ (nth #j #name2) #fil)
        (princ (nth #j #xd_SYM) #fil)
        (setq #j (1+ #j))
      )
      (princ "\n -----------------------------------------------------------------"  #fil)
      (princ #fil)
    )
    ;else
    (progn  ; "G_LSYM"�Ȃ��̏ꍇ  ܰ�į�߂Ȃ�
      (setq #xd (assoc -3 (entget #ZUKEI '("*"))))
      (setq #xd (cdr #xd))
      (setq #type (cdr (assoc 0 (entget #ZUKEI))))
      (setq #hand (cdr (assoc 5 (entget #ZUKEI)))) ; �}�`�����

      (if #xd
        (progn
          (princ "\n" #fil)
          (princ #ZUKEI #fil)
          (princ "  ����=" #fil) (princ #type #fil)
          (princ "  �����=" #fil)(princ #hand #fil)
          (setq #j 0)
          (repeat (length #xd)
            (setq #xd2 (nth #j #xd))
            (cond
              ((= "G_WRKT" (car #xd2))
                (setq #name1
                  (list
                    ":G_WRKT ܰ�į��                               "
                    ":�H��L��                                     "
                    ":SERIES�L��                                   "
                    ":�ގ��L��                                     "
                    ":�`��^�C�v�P        0:�h�^ 1:�k�^ 2:U�^      "
                    ":�`��^�C�v�Q        F:�t���b�g D:�i��        "
                    ":�����ٌ߰�����=P                             "
                    ":WT�Z�b�g�R�[�h    �אڂ���S�Ă�WT�ɾ��      "
                    ":���E������� 0:�Ȃ�,1:VPK,2:X,3:H,4:�i��      "
                    ":���[��t������   ���[�N�g�b�v���ʂ̈ʒu      "
                    ":������Ă̶�ĕ��� S:�ݸ�� G:��ۑ� ��:������ "
                    ":�J�E���^�[����       ���[�N�g�b�v�̌���      "
                    ":�����g�p��                                   "
                    ":�o�b�N�K�[�h����                             "
                    ":�o�b�N�K�[�h����                             "
                    ":�����g�p��                                   "
                    ":�O���ꍂ��                                   "
                    ":�O�������                                   "
                    ":�O����V�t�g��                               "
                    ":���H���f�[�^��  1�`3                         "
                    ":���H���}�`�n���h���P �ݸ��G_HOLE�����        "
                    ":���H���}�`�n���h���Q                         "
                    ":���H���}�`�n���h���R                         "
                    ":�������f�[�^��  1�`7                         "
                    ":�������}�`�n���h���P������G_HOLE�����        "
                    ":�������}�`�n���h���Q                         "
                    ":�������}�`�n���h���R                         "
                    ":�������}�`�n���h���S                         "
                    ":�������}�`�n���h���T                         "
                    ":�������}�`�n���h���U                         "
                    ":�������}�`�n���h���V                         "
                    ":���E����t���O  L:�� R:�E �s��==>R           "
                    ":���ׯ�,���ׯĔ���p                          "
                    ":�R�[�i�[��_   ���[�N�g�b�v��ʂ̍���_      "
                    ":GSM�}�`��WT�ɕύX�����ꍇ:1 ����ȊO0        "
                    ":GSM�}�`��WT�ɕύX�����ꍇ�̶�����i��         "
                    ":�����g�p��                                   "
                    ":�����g�p��                                   "
                    ":�����g�p��                                   "
                    ":WT��ʐ}�`�n���h��   WT�����o���p���ײ�      "
                    ":�V���N�����s                                 "
                    ":�����g�p��                                   "
                    ":�����g�p��                                   "
                    ":�Ԍ�1 ���,����,�ݸ�ʒu���Ɋ֌W�Ȃ��Ԍ�1      "
                    ":�Ԍ�2 ���,����,�ݸ�ʒu���Ɋ֌W�Ȃ��Ԍ�2      "
                    ":�Ԍ�3 ���,����,�ݸ�ʒu���Ɋ֌W�Ȃ��Ԍ�3      "
                    ":�i�@���@�@                                   "
                    ":���@�l    �@�@                               "
                    ":��đ���WT����ٍ�                             "
                    ":��đ���WT����ىE                             "
                    ":BG SOLID�}�`�����1 BG������BG SOLID1         "
                    ":BG SOLID�}�`�����2 BG������BG SOLID2         "
                    ":FG ��ʐ}�`�����1  FG������ײ������1        "
                    ":FG ��ʐ}�`�����2  FG������ײ������2        "
                    ":�Ԍ��L�k��1                                  "
                    ":�Ԍ��L�k��2                                  "
                    ":WT�̕�   ���ڽL�^�Ή�ؽČ`��(2400 1650)      "
                    ":WT�̐L�k��                                   "
                    ":WT�̉��s ���ڽL�^�Ή�ؽČ`��(750 650)        "
                    ":�����t���O ����:TOKU  �K�i:��              "
                    ":�i���������܂߂�WT�O�`PLINE�����             "
                    ":�J�b�g���C���}�`�n���h��1                    "
                    ":�J�b�g���C���}�`�n���h��2                    "
                    ":�J�b�g���C���}�`�n���h��3   U�^�Ŏg�p        "
                    ":�J�b�g���C���}�`�n���h��4 �@U�^�Ŏg�p        "
                ))

                (setq #k 0) ; �g���f�[�^"G_WRKT"
                (princ "\n -----------------------------------------------------------------"  #fil)
                (repeat (length #xd2)
                  (princ "\n[" #fil)(princ #k #fil)(princ "]" #fil)
                  (princ (nth #k #name1) #fil)
                  (princ (nth #k #xd2) #fil)
                  (setq #k (1+ #k))
                )
              )
              ((= "G_WTSET" (car #xd2))
                (setq #name2
                  (list
                    ":G_WTSET ܰ�į�ߏ��                          "
                    ":�����t���O    0:���� 1:�����ȊO              "
                    ":�i�Ԗ���      WT�i��                         "
                    ":��t����      827�Ȃ�                        "
                    ":���z                                         "
                    ":�i��                                         "
                    ":��                                           "
                    ":����                                         "
                    ":���s                                         "
                    ":�����R�[�h                                   "
                    ":�\���Q                                       "
                    ":�\���R                                       "
                    ":WT�����@����                             "
                    ":�����@1 �����猊�܂ł̐��@1                  "
                    ":�����@2 �����猊�܂ł̐��@2                  "
                    ":�����@3 �����猊�܂ł̐��@3                  "
                    ":�����@4 �����猊�܂ł̐��@4                  "
                    ":�����@5 �����猊�܂ł̐��@5                  "
                    ":�����@6 �����猊�܂ł̐��@6                  "
                    ":�����@7 �����猊�܂ł̐��@7                  "
                    ":�����@8 �����猊�܂ł̐��@8                  "
                    ":�����@8 �����猊�܂ł̐��@8                  "
                    ":�����@9 �����猊�܂ł̐��@9                  "
                    ":                                             "
                    ":                                             "
                    ":                                             "
                    ":                                             "
                ))
                (setq #k 0) ; �g���f�[�^"G_WTSET"
                (princ "\n -----------------------------------------------------------------"  #fil)
                (repeat (length #xd2)
                  (princ "\n[" #fil)(princ #k #fil)(princ "]" #fil)
                  (princ (nth #k #name2) #fil)
                  (princ (nth #k #xd2) #fil)
                  (setq #k (1+ #k))
                )
              )
              (T ; �ʏ�
                (setq #k 0)
                (princ "\n -----------------------------------------------------------------" #fil)
                (repeat (length #xd2)
                  (princ "\n[" #fil)(princ #k #fil)(princ "]" #fil)(princ (nth #k #xd2) #fil)
                  (setq #k (1+ #k))
                )
              )
            );_cond

            (setq #j (1+ #j))
          );repeat
          (princ "\n -----------------------------------------------------------------" #fil)
        )
      );_if
    )
  );_if

  (if (/= #ss nil)
    (progn
;;;      (command "_.change" #ss "" "P" "C" "1" "") ; �F�t��
      (setq #lis (CMN_ss_to_en #ss)) ; �I���-->�}�`��ؽ�
      (setq #kosu (length #lis)) ; ��ٰ�����ް�̑���

      (if #lis ; "G_LSYM"����̏ꍇ
        (progn
          (princ "\n��ٰ�����ް�̑���: " #fil)
          (princ #kosu #fil)
          (princ "\n" #fil)(princ "\n <�g���ް�>" #fil)(princ "\n" #fil)

          (setq #i 0)
          (foreach en #lis ; �S�O���[�v�����o�[�Ώ�
            (setq #xd (assoc -3 (entget en '("*"))))
            (setq #type  (cdr (assoc 0   (entget en)))) ; �}�`����
            (setq #hand  (cdr (assoc 5   (entget en)))) ; �}�`�����
            (setq #layer (cdr (assoc 8   (entget en)))) ; ��w
            (setq #210   (cdr (assoc 210 (entget en)))) ; �����o������

            (if #xd
              (progn
                (princ "\n *** NO." #fil)(princ #i #fil)(princ " ***" #fil)
                (princ en #fil)
                (princ "\n ����� = " #fil)   (princ #hand  #fil)
                (princ " ���� = "    #fil)   (princ #type  #fil)
                (princ " ��w = "    #fil)   (princ #layer #fil)
                (princ " ���o������ = " #fil)(princ #210   #fil)
                (setq #xd (cdr #xd))

                (setq #j 0)
                (repeat (length #xd)
                  (setq #xd2 (nth #j #xd))
                  (setq #k 0)
                  (repeat (length #xd2)
                    (princ "\n[" #fil)(princ #k #fil)(princ "]" #fil)(princ (nth #k #xd2) #fil) ; [12](1070 . 4)
                    (setq #k (1+ #k))
                  )
                  (setq #j (1+ #j))
                )
                (princ "\n -----------------------------------------------------------------" #fil)
              )
            );_if

            (setq #i (1+ #i))
          );_(foreach
        )
      );_if
    )
  );_if

  (if #fil
    (progn
      (close #fil)
      (princ "\ņ�قɏ������݂܂���.")
      (startapp "notepad.exe" (strcat CG_SYSPATH "all.txt"))
    )
  );_if
  (princ)
);c:all

;;;<HOM>*************************************************************************
;;; <�֐���>    : c:SelXd
;;; <�����T�v>  : �I�������}�`�̸�ٰ�����ް�̊g���ް��̂����w�肵�����̂�Ԃ�����
;;; <�쐬>      : 01/08/03 YM
;;;*************************************************************************>MOH<
(defun c:SelXd(
  /
  #APP #APP$ #APP_NO #DUM #EN #J #K #SS #SS_LIS$ #SYM #XD #XD2
  #APP$$ #COL #EG$ #HAND #RET$
  )
  (C:ALP) ; undo "M" �S��w�\��
  (setvar "PDSIZE" 50)
  (princ "����ق������ނ�I��: ")
  (setq #en T)
  (while #en
    (setq #en (car (entsel)))
    (if (= #en nil)
      (progn
        (CFAlertErr "���ނ��I������܂���ł���")
        (setq #en T)
      )
      (progn
        (setq #sym (SearchGroupSym #en)) ; ����ِ}�`��
        (if #sym
          (setq #en nil)
          (progn
            (setq #en T)
            (CFAlertErr "G_SYM������܂���")
          )
        );_if
      )
    )
  );while

  ; �S�O���[�v�����o�[�}�`
  (setq #ss (CFGetSameGroupSS #sym))
  (if (or (= #ss nil)(= (sslength #ss) 0))
    (progn
      (CFAlertErr "��ٰ�����ް������܂���")
      (quit)
    )
  );_if

;;;  (command "chprop" #ss "" "C" "7" "") ; ��

  (setq #ss_lis$ (CMN_ss_to_en #ss)) ; �I���-->�}�`��ؽ�

  (setq #APP$$ nil)
  (foreach en #ss_lis$ ; �S�O���[�v�����o�[�Ώ�
    (setq #eg$ (entget en '("*")))
    (setq #xd (assoc -3 #eg$))
    (if #xd ; Xdata����
      (progn
        (setq #xd (cdr #xd))
        (setq #j 0)
        (repeat (length #xd) ; Xdata�����̂Ƃ�ٰ��
          (setq #xd2 (nth #j #xd))
          (setq #k 0)
          (setq #APP (nth 0 #xd2))
          (if (or (= #APP "G_PMEN")(= #APP "G_PTEN")(= #APP "G_PLIN")(= #APP "G_MEJI"))
            (progn
              (setq #hand (cdr (assoc 5 #eg$)))
              (setq #dum (nth 1 #xd2))
              (if (= (car #dum) 1070)
                (setq #APP_NO (cdr #dum))
                (setq #APP_NO nil)
              );_if
              (setq #APP$$ (append #APP$$ (list (list #APP #APP_NO #hand))))
            )
          )
          (setq #j (1+ #j))
        )
      )
    );_if
  );_(foreach

  (setq #APP$$ (ListSortLevel2 #APP$$ 0 1))

  (setq #ret$ (XdataDlg #APP$$)) ; �_�C�A���O�{�b�N�X�̕\��
  (if (= #ret$ nil)
    (progn
      (command "undo" "b" )
      (quit)
    )
    (progn
      (setq #hand (nth 0 #ret$)) ; �����
      (setq #en (handent #hand))
      (setq #Col  (nth 1 #ret$)) ; �F
      (command "chprop" #en "" "C" #Col "") ; ��
    )
  );_if

  (princ)
);c:SelXd

;;;<HOM>*************************************************************************
;;; <�֐���>    : XdataDlg
;;; <�����T�v>  : Xdata�I���_�C�A���O
;;; <�߂�l>    : (�����,�F����)
;;; <�쐬>      : 01/08/03 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun XdataDlg (
  &APP$$
  /
  #DCL_ID #POP$ #RET$
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #COL #HAND
            )
            (setq #hand (nth (atoi (get_tile "Xdata")) #pop$))
            (cond
              ((= "1" (get_tile "radio1"))(setq #Col "1"))
              ((= "1" (get_tile "radio2"))(setq #Col "2"))
              ((= "1" (get_tile "radio3"))(setq #Col "3"))
              ((= "1" (get_tile "radio4"))(setq #Col "4"))
              ((= "1" (get_tile "radio5"))(setq #Col "5"))
              ((= "1" (get_tile "radio6"))(setq #Col "6"))
            );_cond
            (done_dialog)
            (list #hand #Col)
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �߯�߱���ؽ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( / ) ; �ގ��|�b�v�A�b�v���X�g
            (setq #pop$ '())
            (start_list "Xdata" 3)
            (foreach APP$ &APP$$
              (add_list (strcat (nth 0 APP$) "    " (itoa (nth 1 APP$)) "    " (nth 2 APP$)))
              (setq #pop$ (append #pop$ (list (nth 2 APP$)))) ; ����ق̂ݕۑ�
            )
            (end_list)
            (set_tile "Xdata" "0") ; �ŏ���̫���
            (princ)
          );##Addpop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "XdataDlg" #dcl_id)) (exit))

  ;;; �߯�߱���ؽ�
  (##Addpop)
  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret$
);XdataDlg

;;;<HOM>*************************************************************************
;;; <�֐���>    : c:IID
;;; <�����T�v>  : �I�������}�`�̐}�`ID�\��
;;; <�쐬>      : 06/28 YM
;;;*************************************************************************>MOH<
(defun c:IID(
  /
  #EN #SYM #ZUKEI_ID
  )
  (princ "���ނ�I��: ")
  (setq #en (car (entsel)))
  (if (= #en nil)
    (progn
      (CFAlertErr "���ނ��I������܂���ł���")(quit)
    )
  )

  (setq #sym (SearchGroupSym #en))   ; ����ِ}�`�� ; �e�}�`��
  (if #sym
    (progn
      (setq #ZUKEI_ID (nth 0 (CFGetXData #sym "G_LSYM"))) ; �}�`ID
      (princ "\n�}�`ID= ")(princ #ZUKEI_ID)(terpri)
    );_(progn
    (progn  ; "G_LSYM"�Ȃ��̏ꍇ  ܰ�į�߂Ȃ�
      (CFAlertErr "����ق�����܂���")(quit)
    );_(progn
  );_(if
  (princ)
);c:IID



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; KPCAD XLINE���ٰ�߂ɒǉ�  00/03/01 YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:ADDG(
 /
  #300 #EN2
 )
  (setq #300 (SKGetGroupName (car (entsel "\n��ٰ�߂����ް�}�`��I��: "))))
  (setq #en2 (car (entsel "\n��ٰ�߂ɒǉ���������ڰ�ײ݂�I��: ")))
  (if (= (cdr (assoc 0 (entget #en2))) "XLINE")
    (progn
      (command "-group" "A" #300 #en2 "")
      (CFSetXData #en2 "G_BRK"
        (list 3)
      )
      (princ "\n��ٰ�߂ɒǉ����܂���.")
    )
    (progn
      (princ "\nXLINE�ł͂���܂���B")
    )
  )
  (princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; KPCAD �I��}�`������,�����,�g���ް���\��  00/02/25 YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:et( / #et)
  (setq #et (entget (car (entsel "�}�`��I��: ")) '("*") ))
;;;  (terpri)(princ (assoc 0 #et))
;;;  (terpri)(princ (assoc 5 #et)) ; �����
;;;  (terpri)(princ (assoc -3 #et)) ; �g���ް�
 (terpri)(princ #et)           ; �}�`���
  (princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; KPCAD �S�Ẳ�w��\��  pdmode=34 00/02/25 YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:ALP( / )
  (command "undo" "M") ; ϰ�������
  (command "-layer" "T" "*" "ON" "*" "U" "*" "")
  (command "pdmode" "34")
  (command "regen")
  (princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; "G_PMEN"���ނɐԐF(1)������
;;; "G_PMEN"���ނɐԐF(2)������
;;; "G_BODY"���ނɗΐF(3)������  00/02/25 YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:TEST_PRIM( / #EN #I #SS)

  (command "undo" "M") ; ϰ�������
  (C:ALP)
  (setq #ss (ssget "X"))   ; �}�ʏシ�ׂĂ̐}�`
  (if (= #ss nil)(quit))
  (if (= 0 (sslength #ss))(quit))

  (command "chprop" #ss "" "C" "7" "") ; ��

;;;----------------------------------------------------
  (setq #ss (ssget "X" '((-3 ("G_PMEN")))))
  (if (/= #ss nil)
    (progn
      (if (< 0 (sslength #ss))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            (command "chprop" #en "" "C" "1" "") ; ��
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if

;;;----------------------------------------------------
  (setq #ss (ssget "X" '((-3 ("G_PRIM")))))
  (if (/= #ss nil)
    (progn
      (if (< 0 (sslength #ss))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            (command "chprop" #en "" "C" "2" "") ; ��
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if

;;;----------------------------------------------------
  (setq #ss (ssget "X" '((-3 ("G_BODY")))))
  (if (/= #ss nil)
    (progn
      (if (< 0 (sslength #ss))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            (command "chprop" #en "" "C" "3" "") ; ��
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if

);_defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �}�`����ق����--->���̐}�`���ԂɂȂ�  00/02/28 YM
;;; ���ɖ߂��ɂ�(command "undo" "B")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:HCOL ( / #EN #HAND #SS)

;;;  (princ "\n���΂炭���҂���������...")
  (command "undo" "M") ; ϰ�������
;;;  (C:ALP)
;;;  (setq #ss (ssget "X"))   ; �}�ʏシ�ׂĂ̐}�`
;;;  (if (= #ss nil)(quit))
;;;  (if (= 0 (sslength #ss))(quit))
;;;
;;;  (command "chprop" #ss "" "C" "7" "") ; ��

  (setq #hand (getstring "\n����ٓ���: "))
  (setq #en (handent #hand))

  (command "chprop" #en "" "C" "1" "") ; ��

  (princ "\n///////////////////")
  (princ "\n\"UU\"�Ō��ɖ߂�")
  (princ "\n///////////////////")
  (princ)
);_defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �\����w�̐ݒ�(�v�����������l)  00/03/17 YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:ddd ( / )

;;;03/09/29YM@MOD  ;// �\����w�̐ݒ�
;;;03/09/29YM@MOD  (command "_layer"
;;;03/09/29YM@MOD    "F"   "*"                ;�S�Ẳ�w���t���[�Y
;;;03/09/29YM@MOD    "T"   "Z_00*"            ;  Z_00���̃\���b�h��w�̃t���[�Y����
;;;03/09/29YM@MOD    "T"   "N_*"              ;  N_*�V���{�����_�}�`��w�̃t���[�Y����
;;;03/09/29YM@MOD    "T"   "M_*"              ;  M_*�ڒn�̈�}�`��w�̉���
;;;03/09/29YM@MOD    "T"   "0"                ;  "0"��w�̉���
;;;03/09/29YM@MOD    "ON"  "M_*"              ;  M_*�ڒn�̈�}�`��w�̕\��
;;;03/09/29YM@MOD    "OFF" "N_B*" ""          ;  N_B*�u���[�N���C���}�`�̔�\��
;;;03/09/29YM@MOD  )
;;;03/09/29YM@MOD  (command "_.layer" "T" "Z_KUTAI" "") ; 01/02/20 YM ADD

  (SetLayer);03/09/29 YM MOD

  (command "pdmode" "0")
  (command "regen")
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : c:clZ
;;; <�����T�v>  : �}�ʂ̃S�~�폜
;;;               ����ق𔺂�Ȃ��Ǘ�PMEN�}�`����сA����΂��̸�ٰ�߂��폜
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.16 YM
;;;*************************************************************************>MOH<
(defun c:clZ(
  /
  #ELM #FLG #I #SS #SS_PMEN #SYM #MSGFLG
  )
  (setq #ss_PMEN (ssget "X" '((-3 ("G_PMEN"))))) ; G_PMEN �}�`�I���
  (if (= #ss_PMEN nil) (setq #ss_PMEN (ssadd)))

  (setq #MSGflg nil)
  (setq #i 0)
  (repeat (sslength #ss_PMEN)
    (setq #flg nil)
    (setq #elm (ssname #ss_PMEN #i))
    (setq #sym (SearchGroupSym #elm))
    (if (= #sym nil)
      (progn ; ����ق��Ȃ�
        (setq #ss (CFGetSameGroupSS #elm))
        (if #ss
          (if (> (sslength #ss) 0)
            (progn
              (command "_.erase" #ss "") ; �폜����
              (princ "\n��ꂽ�}�`���폜���܂����B")
              (setq #flg T)
              (setq #MSGflg T)
            )
          );_if
        );_if
        (if (and (entget #elm)(= #flg nil))
          (progn
            (command "_.erase" #elm "") ; �폜����
            (princ "\n��ꂽ�}�`���폜���܂����B")
            (setq #MSGflg T)
          )
        );_if
      )
    );_if
    (setq #i (1+ #i))
  );_(repeat

  (if (= #MSGflg nil)
    (princ "\n��ꂽ�}�`�͂���܂���ł����B")
  );_if

  (princ)
);c:clZ

;;;<HOM>*************************************************************************
;;; <�֐���>    : c:PTN
;;; <�����T�v>  : �}�ʏ��"G_PRIM"�̒�ʐ}�`����������Ă���Ă��Ȃ����т̐}�`ID��T��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.4.8 YM
;;;*************************************************************************>MOH<
(defun c:PTN(
  /
  #ELM #FLG #I #MSG #SS_PRIM #SYM #TEI #XD #ZUKEI_ID
  )
  (princ)
  (princ "\n������...")
  (princ)
  (command "undo" "M") ; ϰ�������
  (C:ALP) ; ��w����
  (setq #ss_PRIM (ssget "X" '((-3 ("G_PRIM"))))) ; G_PRIM �}�`�I���
  (if (= #ss_PRIM nil) (setq #ss_PRIM (ssadd)))
  (setq #i 0 #flg nil)
  (repeat (sslength #ss_PRIM)                    ; "G_LSYM"��������
    (setq #elm (ssname #ss_PRIM #i))
    (setq #tei (nth 10 (CFGetXData #elm "G_PRIM")))  ; ��ʐ}�`��
    (if (or (= #tei nil) (= #tei "0"))   ; �s������
      (progn
        (setq #flg T)
        (setq #sym (SearchGroupSym #elm))        ;  #elm ; SOLID�}�`��
        (setq #ZUKEI_ID (nth 0 (CFGetXData #sym "G_LSYM"))) ; �}�`ID
        (princ (strcat "\n�}�`ID = " #ZUKEI_ID))
      )
    );_if
    (setq #i (1+ #i))
  );_(repeat

  (if #flg
    (setq #msg "\n\"G_PRIM\"�̒�ʐ}�`���s���ȃA�C�e��������܂���.\n�֌˂���ɐ}�`ID��A�����Ă�������.")
    (setq #msg "\n\�}�ʏ��\"G_PRIM\"�͐���ł���.")
  );_if
  (CFAlertMsg #msg)
  (command "undo" "B")
  (princ)
);c:PTN

;;;<HOM>*************************************************************************
;;; <�֐���>    : c:PM2N
;;; <�����T�v>  : �}�ʏ��"G_PMEN"2����Ă���Ă��Ȃ����т̐}�`ID��Ԃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.4.18 YM
;;;*************************************************************************>MOH<
(defun c:PM2N (
  /
  #ELM #FLG #I #MSG #ss_LSYM #SYM #TEI #XD #ZUKEI_ID #msg
  #EN #EN$ #LOOP #ZU_ID #J
  )
  (command "._zoom" "E")
  (princ)
  (princ "\n�x�[�X�L���r��������...")
  (princ)
  (command "undo" "M") ; ϰ�������
  (C:ALP) ; ��w����
  (setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM"))))) ; G_LSYM �}�`�I���

  (if (= #ss_LSYM nil) (setq #ss_LSYM (ssadd)))
  (setq #i 0 #flg nil)
  (repeat (sslength #ss_LSYM)                    ; "G_LSYM"��������
    (setq #sym (ssname #ss_LSYM #i))

    (if (and (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)
             (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS))
      (progn
        (GroupInSolidChgCol2 #sym CG_InfoSymCol) ; �F��ς���
        (setq #en$ (CFGetGroupEnt #sym))   ; �e�ް����ނ̓����ٰ��
        (setq #j 0)
        (setq #loop T)
        (while (and #loop (< #j (length #en$))) ; PMEN2����������
          (setq #en (nth #j #en$))
          (if (= 2 (car (CFGetXData #en "G_PMEN")))
            (setq #loop nil) ; �P�������烋�[�v�𔲂���
          );_if
          (setq #j (1+ #j))
        );_(while

        (if #loop ; PMEN2���Ȃ�
          (progn
            (setq #flg T)
            (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; �}�`ID
            (setq #msg (strcat "\n �}�`ID=" #zu_id "�� PMEN2 ������܂���B"))
            (princ #msg)
          )
        );_if
        (GroupInSolidChgCol2 #sym "BYLAYER")
      )
    );_if

    (setq #i (1+ #i))
  );_(repeat

  (if #flg
    (setq #msg "\nPMEN2���Z�b�g����Ă��Ȃ��A�C�e��������܂���.\n�֌˂���ɐ}�`ID��A�����Ă�������.")
    (setq #msg "\n\�}�ʏ��PMEN2�͑S�Đ���ł���.")
  );_if
  (CFAlertMsg #msg)
  (command "undo" "B")
  (command "._zoom" "P")
  (princ)
);c:PTN

;//////////////////////////////////////////////////////////
;;; ���ײ݂̒��_���߲�Ă�ł��Č�����悤�ɂ��� 07/14 YM
;//////////////////////////////////////////////////////////
(defun c:p000 (
  /
  #EN #ET$
  )
  (command "undo" "M") ; ϰ�������
  (setq #en (car (entsel "\n���ײ݂��w��: ")))
  (setq #et$ (entget #en))
  (foreach #et #et$
    (if (= (car #et) 10)
      (command "point" (cdr #et))
    )
  )
  (setvar "PDSIZE" 20)
  (setvar "PDMODE" 34)
  (command "regen")
  (princ)
);c:p000

;//////////////////////////////////////////////////////////
;;; �}�`�̸�ٰ�ߓ���G_PMEN�̂ݕ\������ 07/14 YM
;//////////////////////////////////////////////////////////
(defun c:p001 (
  /
  #ELM #I #SS #XD$
  )
  (setq #ss (CFGetSameGroupSS (car (entsel "\n �ݸ���w��: "))))

  (setq #i 0)(princ "\n")
  (repeat (sslength #ss)
    (setq #elm (ssname #ss #i))
    (setq #xd$ (CFGetXData #elm "G_PMEN"))
    (if #xd$
      (progn
        (princ "\n i = ")(princ #i)(princ "  ")(princ #xd$)
      )
    );_if
    (setq #i (1+ #i))
  )
  (princ)
);c:p000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �I���Z�b�g�̃n���h����\������ YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun srcSShand (
  &ss
  /
  #ELM #HAND #I
  )

  (setq #i 0)
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))
    (setq #hand (cdr (assoc 5 (entget #elm))))
    (princ #hand)(terpri)
    (setq #i (1+ #i))
  )
);srcSShand

;;;<HOM>*************************************************************************
;;; <�֐���>    : c:ChgSKK
;;; <�����T�v>  : �I�����ꂽ�A�C�e���̐��iCODE��ύX����B
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.08.04 HT
;;;*************************************************************************>MOH<

(defun c:ChgSKK (
  /
  #eEn   ; �}�`��
  #Ed$   ; G_LSYM�g���f�[�^
  #iSKK  ; ���iCODE
  )

  (setq #eEn (CFSearchGroupSym (car (entsel "\n�m�F�����޼ު�Ă�I��: "))))
  (setq #Ed$ (CFGetXData #eEn "G_LSYM"))
  (princ "\n�i�Ԗ���=")
  (princ (nth 5 #Ed$))
  (princ "\n���iCODE=")
  (princ (nth 9 #Ed$))
  (princ "\n�ύX��̐��iCODE����<Enter�I��>:")
  (setq #iSKK (getint))
  (if #iSKK
    (progn
    (setq #Ed$ (CMN_subs_elem_list 9 #iSKK #Ed$))
    (CFSetXData #eEn "G_LSYM" #Ed$)
    )
  )
  (princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �}�X�^(�Œ�)��}������
(defun c:iii0 ( / #DWG #SS_DUM #SYM)

  (setq #dwg "0012001")
  ;// �C���T�[�g
  (princ "\n�}���_: ")
  (command ".insert" (strcat CG_MSTDWGPATH #dwg) pause "" "")
  (princ "\n�z�u�p�x: ")
  (command pause)
  (command "_explode" (entlast))
  (setq #ss_dum (ssget "P"))
  (SKMkGroup #ss_dum)
;;;  (setq #sym (SKC_GetSymInGroup (ssname #ss_dum 0)))
     (setq #sym (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

  ;// �g���f�[�^�̕t��
  (CFSetXData #sym "G_LSYM"
    (list
      #dwg                       ;1 :�{�̐}�`ID  ; �i�Ԑ}�`.�}�`�h�c   OK!
      (list 0 0)                 ;2 :�}���_
      0                          ;3 :��]�p�x
      CG_Kcode                   ;4 :�H��L��
      CG_SeriesCode              ;5 :SERIES�L��
      "dummy"                    ;6 :�i�Ԗ���
      "LR"                       ;7 :L/R �敪
      ""                         ;8 :���}�`ID
      #dwg                       ;9 :���J���}�`ID
      777                        ;10:���iCODE
      0                          ;11:�����t���O
      0                          ;12:���R�[�h�ԍ�
      0                          ;13:�p�r�ԍ�
      777                        ;14:���@H
      0                          ;15:�f�ʎw���̗L��
    )
  )
  (princ)
)



;;;<HOM>*************************************************************************
;;; <�֐���>    : C:DBC11
;;; <�����T�v>  : �v���\����������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 04/08/11 YM
;;; <���l>      : �@�i�Ԑ}�`�ɂ��邩�AID,recno�C����X�v���Ǘ��Ƃ̊Ԍ�������
;;;*************************************************************************>MOH<
(defun C:DBC11 (
  /
  #DATE_TIME #DIRW #DIRW_OLD #DISX #DUM$$ #FIL #FLG #HIN #I #ID #ID$ #ID_OLD #KOSU 
  #LR #MAG2 #MAGU #MSG #OLD_DISX #OLD_FLG #OLD_HIN #QRY$$ #QRY_KANRI$$ #REC #REC_OLD 
  #SUMW #SUM_HIN1 #SUM_HIN2 #TYPE #W0 #WW #WW0 #XX #P-TYPE
  )
  (setq #msg "\n��׍\������o�^����")
  (setq #fil (open (strcat CG_SYSPATH "TMP\\CHK_HIN11-" CG_SeriesCode ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n(C:DBC11)����ނɂ������" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesCode) #fil)
  (princ "\n" #fil)

  (princ "\nDB������[�v���Ǘ�] ����...")

  (setq #qry_KANRI$$
    (CFGetDBSQLRec CG_DBSESSION "�v���Ǘ�"
      (list
        (list "�\���^�C�v"  "1"   'INT)
        (list "order by \"�v����ID\"" nil 'ADDSTR)
      )
    )
  )

  (princ "\nDB������[�v���\��]����...")

  (setq #dum$$ nil)
  ;�eID���Ƃ�recNO����ں��ނ��擾����
  (foreach #qry_KANRI$ #qry_KANRI$$
    (setq #id     (nth 0 #qry_KANRI$))
    (setq #magu   (nth 5 #qry_KANRI$)) ;�ݸ���Ԍ�
    (setq #type   (nth 6 #qry_KANRI$)) ;�z��"Z","K","L","M"
    (setq #p-type (nth 8 #qry_KANRI$)) ;��������
    ;���ׯ�,���ׯĂ͏���
    (if (or (and (= CG_SeriesCode "S")(wcmatch #p-type "F*,G*"))
            (and (= CG_SeriesCode "G")(wcmatch #p-type "F*,G*"))
            (and (= CG_SeriesCode "N")(wcmatch #p-type "F*"))
            (and (= CG_SeriesCode "D")(wcmatch #p-type "F*,G*,S*,T*")))
      nil ; ���ׯĂ͏���
      (progn
        ;����Ԍ��͕ϊ�����
        (cond
          ((= #magu "24A")(setq #magu 240))
          ((= #magu "24B")(setq #magu 240))
          ((= #magu "25A")(setq #magu 255))
          ((= #magu "25B")(setq #magu 255))
          ((= #magu "27A")(setq #magu 270))
          ((= #magu "27B")(setq #magu 270))
          (T (setq #magu (atoi (nth 5 #qry_KANRI$)))) ;�ݸ���Ԍ�
        );_cond

        (setq #qry$$
          (CFGetDBSQLRec CG_DBSESSION "�v���\��"
             (list
               (list "�v����ID" (rtois #id) 'INT)
               (list "order by \"RECNO\"" nil 'ADDSTR)
             )
          )
        )

        (if (= nil #qry$$)
          (princ (strcat "\n[��׍\��]���Ȃ�" "ID=" (itoa (fix #id)) ) #fil)
          ;else
          (progn ;�Ԍ�����������
            (setq #sum_hin1 0.0);�ݸ��
            (setq #sum_hin2 0.0);��ۑ�
            (cond
              ((= #type "Z") ;I�^
                (setq #hin  (nth 2 (last #qry$$)))
                (setq #disX (nth 9 (last #qry$$)));����X
                (setq #W0 (atoi (CFGetNumFromStr_NAS #hin)))
                (if (wcmatch #hin "̰��*,�H��*,�޽*")
                  (setq #W0 (* #W0 1))
                  (setq #W0 (* #W0 10))
                );_if
                (setq #sum_hin1 (/ (+ #disX #W0) 10))
                (if (equal #magu #sum_hin1 0.01)
                  nil;OK!
                  ;else
                  (princ (strcat "\n[���Ԍ��s��-I�^]" "ID=" (itoa (fix #id)) ",��׊Ǘ�=" (itoa #magu) ",��׍\��=" (itoa (fix #sum_hin1))) #fil)
                );_if
              )
              (T
                (cond
                  ((= #type "K")(setq #mag2 1650))
                  ((= #type "L")(setq #mag2 1800))
                  ((= #type "M")(setq #mag2 1950))
                );_cond

                ;��ۑ�
                (setq #hin   (nth 2  (last #qry$$)))
                (setq #disX  (- (nth 10 (last #qry$$))));����Y��ϲŽ�l
                (setq #W0    (atoi (CFGetNumFromStr_NAS #hin)))
                (if (wcmatch #hin "̰��*,�H��*,�޽*")
                  (setq #W0 (* #W0 1))
                  (setq #W0 (* #W0 10))
                );_if
                (setq #sum_hin2 (/ (+ #disX #W0) 10))
                (if (equal (/ #mag2 10) #sum_hin2 0.01)
                  nil;OK!
                  ;else
                  (princ (strcat "\n[���Ԍ��s��-L�^��ۑ�]" "ID=" (itoa (fix #id)) ",�z��=" #type ",��׍\��=" (itoa (fix #sum_hin2))) #fil)
                );_if

                ;�ݸ��
                (setq #old_flg 1.0)
                (foreach #qry$ #qry$$
                  (setq #hin  (nth  2 #qry$))
                  (setq #disX (nth  9 #qry$));����X
                  (setq #flg  (nth 12 #qry$));����W
                  (if (equal #flg #old_flg 0.01)
                    nil
                    ;else �׸ނ��ς��
                    (progn
                      (setq #W0 (atoi (CFGetNumFromStr_NAS #old_hin)))
                      (if (wcmatch #old_hin "̰��*,�H��*,�޽*")
                        (setq #W0 (* #W0 1))
                        (setq #W0 (* #W0 10))
                      );_if
                      (setq #sum_hin1 (/ (+ #old_disX #W0) 10))
                      (if (equal #magu #sum_hin1 0.01)
                        nil;OK!
                        ;else
                        (princ (strcat "\n[���Ԍ��s��-L�^�ݸ��]" "ID=" (itoa (fix #id)) ",��׊Ǘ�=" (itoa #magu) ",��׍\��=" (itoa (fix #sum_hin1))) #fil)
                      );_if
                    )
                  );_if
                  (setq #old_flg #flg)
                  (setq #old_disX #disX)
                  (setq #old_hin #hin)
                )
              )
            );_cond
          )
        );_if

        (if (member #id #id$)
          nil
          ;else
          (setq #dum$$ (append #dum$$ #qry$$))
        );_if
        (setq #id$ (append #id$ (list #id)))
      )
    );_if
  );foreach

  (setq #qry$$ #dum$$)

  ;����@//////////////////////////////////////////////////////////////////////////
  (setq #sumW 0)
  (setq #id_old nil)
  (setq #rec_old nil)
  (setq #i 1) ; ���ėp
  (setq #kosu (length #qry$$))
  (foreach #qry$ #qry$$
    (if (= 0 (rem #i 100))
      (princ (strcat "\n���� " (itoa #i) "/" (itoa #kosu)))
    );_if
    (setq #id   (nth  0 #qry$))
    (setq #rec  (nth  1 #qry$))
    (setq #hin  (nth  2 #qry$))
    (setq #LR   (nth  3 #qry$))
    (setq #XX   (nth  9 #qry$));����X
    (setq #dirW (nth 12 #qry$));����W
    (if (equal #dirW -1 0.001)
      (setq #XX (- (nth 10 #qry$)));����X
    );_if

    (if (equal #rec 1 0.001)
      (progn
        ;04/07/19 YM MOD
        (setq #WW0 (atoi (CFGetNumFromStr_NAS #hin)));L�^�̏ꍇ��Ű�Ԍ�
          
        (if (wcmatch #hin "̰��*,�H��*,�޽*")
          (setq #WW0 (* 1 #WW0))
          (setq #WW0 (* 10 #WW0))
        );_if
      )
    );_if

    ;�����v�Z
    (if (equal #id #id_old 0.001)
      (progn ;ID���Oں��ނƓ���
        (if (equal #XX #sumW 0.001)
          nil ; OK
          ;else
          (progn
            (if (and (equal -1 #dirW 0.001)(equal 1 #dirW_old 0.001))
              (progn ; L�^��ۑ��ŏ�
                ;���ꏈ�� (��Ű����1050�̏ꍇ)
                (if (= #WW0 1050)(setq #WW0 750))
                ;���ꏈ�� (��Ű����800�̏ꍇ)
                (if (= #WW0 800)(setq #WW0 900))
                (setq #sumW #WW0)
                (if (equal #XX #WW0 0.001)
                  nil ; OK
                  ;else
                  ;�����s��
                  (princ (strcat "\n[�����s��]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))) #fil)
                );_if
              )
              (progn
                (princ (strcat "\n[�����s��]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec)) ",�i�Ԗ���=" #HIN ",LR�敪=" #LR) #fil)
              )
            );_if
          )
        );_if
      )
      (progn ;ID���Oں��ނƈႤ
        (setq #sumW 0)
        (if (equal #XX 0 0.001)
          nil ; OK
          ;else
          ;�����s��
          (princ (strcat "\n[�����s��]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec)) ",�i�Ԗ���=" #HIN ",LR�敪=" #LR) #fil)
        );_if
      )
    );_if

    ;������̐������������擾����
    (setq #WW (atoi (CFGetNumFromStr_NAS #hin)))
    (if (wcmatch #hin "̰��*,�H��*,�޽*")
      (setq #WW (* 1 #WW))
      (setq #WW (* 10 #WW))
    );_if
    (if (= "C" (substr #hin 4 1))
      (progn
        ;���ꏈ�� (��Ű����1050�̏ꍇ)
        (if (= #WW 1050)(setq #WW 750))
        ;���ꏈ�� (��Ű����800�̏ꍇ)
        (if (= #WW 800)(setq #WW 900))
      )
    );_if

    (setq #sumW (+ #sumW #WW));�ݐ�

    ;ID,recNO ����
    (if (and #id_old #rec_old)
      (progn
        (if (equal #id #id_old 0.001)
          (progn ;ID���Oں��ނƓ���
            (if (equal (- #rec #rec_old) 1 0.001)
              nil ; OK
              ;else
              (progn
                ;recNO�s����
                (princ (strcat "\n[recNO�s����]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))) #fil)
              )
            );_if
          )
          (progn ;ID���Oں��ނƈႤ
            (if (equal #rec 1 0.001)
              nil ; OK
              ;else
              ;recNO�s����
              (princ (strcat "\n[recNO�s����]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))) #fil)
            );_if
          )
        );_if

      )
    );_if

    ;�i������
    (if (not (wcmatch #hin "̰��*,�H��*,�޽*"))
      (progn
        (setq #qry$$
          (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
            (list
              (list "�i�Ԗ���" #HIN 'STR)
              (list "LR�敪"   #LR  'STR)
            )
          )
        )
        ;�װ�i�ԂȂ�or����
        (if (or (= nil #qry$$)(< 1 (length #qry$$)))
          (princ (strcat "\n[�i�Ԑ}�`�ɂȂ�or����]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))  ",�i�Ԗ���=" #HIN ",LR�敪=" #LR) #fil)
        );_if
      )
    );_if

    (setq #id_old   #id)
    (setq #rec_old  #rec)
    (setq #dirW_old #dirW)
    (setq #i (1+ #i))
  );foreach
  ;����@//////////////////////////////////////////////////////////////////////////

  (princ "\n*** �������� ***" #fil)

  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "TMP\\CHK_HIN11-" CG_SeriesCode ".txt"))
  (princ)
);C:DBC11

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:DBC22
;;; <�����T�v>  : �v���\���݌�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 04/08/23 YM
;;; <���l>      : �@�i�Ԑ}�`�ɂ��邩�AID,recno�B�Ԋu
;         <�菇>
;         [�v���Ǘ�]�Z��500...ں��ގ擾
;         [�v���Ǘ�]����700...ں��ގ擾
;         [�v���Ǘ�]ں��ނ�����[�v���\��]ں��ގ擾
;         [�v���Ǘ�]��[�v���\��]�ŊԌ��̐����������� ���V�K�ǉ�
;;;*************************************************************************>MOH<
(defun C:DBC22 (
  /
  #DATE_TIME #DIRW #DIRW_OLD #DISX #DUM$$ #FIL #FLG #FLG_B #FLG_E #HIN #I #ID #ID$
  #ID_OLD #KOSU #LR #MAG2 #MAGU #MSG #OLD_DISX #OLD_FLG #OLD_HIN #P-TYPE #QRY$$ #QRY500-2$$
  #QRY_KANRI$ #QRY_KANRI500-2$$ #QRY_KANRI700-2$$ #REC #REC_OLD #SUMW #SUM_HIN1 #SUM_HIN2 
  #TYPE #W0 #WW #WW0 #XX
  )
  (setq #msg "\n��׍\���݌˓o�^����")
  (setq #fil (open (strcat CG_SYSPATH "TMP\\CHK_HIN22-" CG_SeriesCode ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n��׍\��ð��ٓo�^�i�ԂŁA�i�Ԑ}�`�ɑ��݂��Ȃ�����" #fil)
  (princ "\n(C:DBC22)����ނɂ������" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesCode) #fil)
  (princ "\n" #fil)

;;;[�v���Ǘ�]�Z��500...ں��ގ擾
  (princ "\nDB������[�v���Ǘ�] �Z��500...")

  (setq #qry_KANRI500-2$$ ;�݌�500mm
    (CFGetDBSQLRec CG_DBSESSION "�v���Ǘ�"
      (list
        (list "�\���^�C�v"  "2"   'INT)
        (list "��t�^�C�v2" "500" 'INT)
        (list "order by \"�v����ID\"" nil 'ADDSTR)
      )
    )
  )

;;;[�v���Ǘ�]����700...ں��ގ擾
  (princ "\nDB������[�v���Ǘ�] ����700...")

  (setq #qry_KANRI700-2$$ ;�݌�700mm
    (CFGetDBSQLRec CG_DBSESSION "�v���Ǘ�"
      (list
        (list "�\���^�C�v"  "2"   'INT)
        (list "��t�^�C�v2" "700" 'INT)
        (list "order by \"�v����ID\"" nil 'ADDSTR)
      )
    )
  )
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (princ "\nDB������[�v���\��](�Z��500)...")

  (setq #dum$$ nil)(setq #id$ nil)
  ;�eID���Ƃ�recNO����ں��ނ��擾����
  (foreach #qry_KANRI500-2$ #qry_KANRI500-2$$
    (setq #id   (nth 0 #qry_KANRI500-2$))
    (setq #magu (nth 5 #qry_KANRI500-2$))   ;�ݸ���Ԍ�
    (setq #type (nth 6 #qry_KANRI500-2$))   ;�z��"Z","K","L","M"
    (setq #p-type (nth 8 #qry_KANRI500-2$)) ;��������

    ;���ׯ�,���ׯĂ͏���
    (if (or (and (= CG_SeriesCode "S")(wcmatch #p-type "F*,G*"))
            (and (= CG_SeriesCode "G")(wcmatch #p-type "F*,G*"))
            (and (= CG_SeriesCode "N")(wcmatch #p-type "F*"))
            (and (= CG_SeriesCode "D")(wcmatch #p-type "F*,G*,S*,T*")))
      nil ; ���ׯĂ͏���
      (progn
        ;����Ԍ��͕ϊ�����
        (cond
          ((= #magu "24A")(setq #magu 240))
          ((= #magu "24B")(setq #magu 240))
          ((= #magu "25A")(setq #magu 255))
          ((= #magu "25B")(setq #magu 255))
          ((= #magu "27A")(setq #magu 270))
          ((= #magu "27B")(setq #magu 270))
          (T (setq #magu (atoi (nth 5 #qry_KANRI500-2$)))) ;�ݸ���Ԍ�
        );_cond

        (setq #qry500-2$$
          (CFGetDBSQLRec CG_DBSESSION "�v���\��"
             (list
               (list "�v����ID" (rtois #id) 'INT)
               (list "order by \"RECNO\"" nil 'ADDSTR)
             )
          )
        )
        (if (= nil #qry_KANRI500-2$$)
          (princ (strcat "\n[��׍\��]���Ȃ�" "ID=" (itoa (fix #id)) ) #fil)
          ;else
          (progn ;�Ԍ�����������
            (setq #sum_hin1 0.0);�ݸ��
            (setq #sum_hin2 0.0);��ۑ�
            (cond
              ((= #type "Z") ;I�^
                (setq #hin  (nth 2 (last #qry500-2$$)))
                (setq #disX (nth 9 (last #qry500-2$$)));����X
                (setq #W0 (atoi (CFGetNumFromStr2 #hin)))
                (if (wcmatch #hin "̰��*")
                  (setq #W0 (* #W0 1))
                  (setq #W0 (* #W0 10))
                );_if
                (setq #sum_hin1 (/ (+ #disX #W0) 10))
                (if (equal #magu #sum_hin1 0.01)
                  nil;OK!
                  ;else
                  (princ (strcat "\n[���Ԍ��s��-I�^]" "ID=" (itoa (fix #id)) ",��׊Ǘ�=" (itoa #magu) ",��׍\��=" (itoa (fix #sum_hin1))) #fil)
                );_if
              )
              (T
                (cond
                  ((= #type "K")(setq #mag2 1650))
                  ((= #type "L")(setq #mag2 1800))
                  ((= #type "M")(setq #mag2 1950))
                );_cond

                ;��ۑ�
                (setq #hin   (nth 2  (last #qry500-2$$)))
                (setq #disX  (- (nth 10 (last #qry500-2$$))));����Y��ϲŽ�l
                (setq #W0    (atoi (CFGetNumFromStr2 #hin)))
                (if (wcmatch #hin "̰��*,�H��*,�޽*")
                  (setq #W0 (* #W0 1))
                  (setq #W0 (* #W0 10))
                );_if
                (setq #sum_hin2 (/ (+ #disX #W0) 10))
                (if (equal (/ #mag2 10) #sum_hin2 0.01)
                  nil;OK!
                  ;else
                  (princ (strcat "\n[���Ԍ��s��-L�^��ۑ�]" "ID=" (itoa (fix #id)) ",�z��=" #type ",��׍\��=" (itoa (fix #sum_hin2))) #fil)
                );_if

;;;               (setq #hin  (nth 2 (last #qry500-2$$)))
;;;               (setq #disX (nth 9 (last #qry500-2$$)));����X
;;;               (setq #W0 (atoi (CFGetNumFromStr2 #hin)))
;;;               (if (wcmatch #hin "̰��*")
;;;                 (setq #W0 (* #W0 1))
;;;                 (setq #W0 (* #W0 10))
;;;               );_if
;;;               (setq #sum_hin2 (/ (+ #disX #W0) 10))
;;;               (if (equal (/ #mag2 10) #sum_hin2 0.01)
;;;                 nil;OK!
;;;                 ;else
;;;                 (princ (strcat "\n[���Ԍ��s��-L�^��ۑ�]" "ID=" (itoa (fix #id)) ",�z��=" #type ",��׍\��=" (itoa (fix #sum_hin2))) #fil)
;;;               );_if

                ;�ݸ��
                (setq #old_flg 1.0)
                (foreach #qry$ #qry500-2$$
                  (setq #hin  (nth  2 #qry$))
                  (setq #disX (nth  9 #qry$));����X
                  (setq #flg  (nth 12 #qry$));����W
                  (if (equal #flg #old_flg 0.01)
                    nil
                    ;else �׸ނ��ς��
                    (progn
                      (setq #W0 (atoi (CFGetNumFromStr2 #old_hin)))
                      (if (wcmatch #old_hin "̰��*,�H��*,�޽*")
                        (setq #W0 (* #W0 1))
                        (setq #W0 (* #W0 10))
                      );_if
                      (setq #sum_hin1 (/ (+ #old_disX #W0) 10))
                      (if (equal #magu #sum_hin1 0.01)
                        nil;OK!
                        ;else
                        (princ (strcat "\n[���Ԍ��s��-L�^�ݸ��]" "ID=" (itoa (fix #id)) ",��׊Ǘ�=" (itoa #magu) ",��׍\��=" (itoa (fix #sum_hin1))) #fil)
                      );_if
                    )
                  );_if
                  (setq #old_flg #flg)
                  (setq #old_disX #disX)
                  (setq #old_hin #hin)
                );foreach

;;;               ;�ݸ��
;;;               (setq #old_flg 1.0)
;;;               (foreach #qry500-2$ #qry500-2$$
;;;                 (setq #hin  (nth  2 #qry500-2$))
;;;                 (setq #disX (nth  9 #qry500-2$));����X
;;;                 (setq #flg  (nth 12 #qry500-2$));����W
;;;                 (if (equal #flg #old_flg 0.01)
;;;                   nil
;;;                   ;else �׸ނ��ς��
;;;                   (progn
;;;                     (setq #W0 (atoi (CFGetNumFromStr2 #old_hin)))
;;;                     (if (wcmatch #old_hin "̰��*")
;;;                       (setq #W0 (* #W0 1))
;;;                       (setq #W0 (* #W0 10))
;;;                     );_if
;;;                     (setq #sum_hin1 (/ (+ #old_disX #W0) 10))
;;;                     (if (equal #magu #sum_hin1 0.01)
;;;                       nil;OK!
;;;                       ;else
;;;                       (princ (strcat "\n[���Ԍ��s��-L�^�ݸ��]" "ID=" (itoa (fix #id)) ",��׊Ǘ�=" (itoa #magu) ",��׍\��=" (itoa (fix #sum_hin1))) #fil)
;;;                     );_if
;;;                   )
;;;                 );_if
;;;                 (setq #old_flg #flg)
;;;                 (setq #old_disX #disX)
;;;                 (setq #old_hin #hin)
;;;               )

              )
            );_cond
          )
        );_if

        (if (member #id #id$)
          nil
          ;else
          (setq #dum$$ (append #dum$$ #qry500-2$$))
        );_if
        (setq #id$ (append #id$ (list #id)))
      )
    );_if
  );foreach
  (setq #qry_KANRI500-2$$ #dum$$)

  ;�݌�500mm�@//////////////////////////////////////////////////////////////////////////
  (princ "\n���Z�ځ�:**********************************************************" #fil)
  (setq #sumW 0)
  (setq #id_old nil)
  (setq #rec_old nil)
  (setq #i 1) ; ���ėp
  (setq #kosu (length #qry500-2$$))
  (foreach #qry500-2$ #qry500-2$$
    (if (= 0 (rem #i 100))
      (princ (strcat "\n�Z�� " (itoa #i) "/" (itoa #kosu)))
    );_if
    (setq #id   (nth  0 #qry500-2$))
    (setq #rec  (nth  1 #qry500-2$))
    (setq #hin  (nth  2 #qry500-2$))
    (setq #LR   (nth  3 #qry500-2$))
    (setq #XX   (nth  9 #qry500-2$));����X
    (setq #dirW (nth 12 #qry500-2$));����W
    (if (equal #dirW -1 0.001)
      (setq #XX (- (nth 10 #qry500-2$)));����X
    );_if

    (if (equal #rec 1 0.001)
      (progn
        ;04/07/19 YM MOD
        (setq #WW0 (atoi (CFGetNumFromStr2 #hin)));L�^�̏ꍇ��Ű�Ԍ�
        (if (wcmatch #hin "̰��*")
          (setq #WW0 (* 1 #WW0))
          (setq #WW0 (* 10 #WW0))
        );_if
      )
    );_if

    ;�����v�Z
    (if (equal #id #id_old 0.001)
      (progn ;ID���Oں��ނƓ���
        (if (equal #XX #sumW 0.001)
          nil ; OK
          ;else
          (progn
            (if (and (equal -1 #dirW 0.001)(equal 1 #dirW_old 0.001))
              (progn ; L�^��ۑ��ŏ�
                ;���ꏈ�� (��Ű����1050�̏ꍇ)
                (if (= #WW0 1050)(setq #WW0 750))
                ;���ꏈ�� (��Ű����800�̏ꍇ)
                (if (= #WW0 800)(setq #WW0 900))
                (setq #sumW #WW0)
                (if (equal #XX #WW0 0.001)
                  nil ; OK
                  ;else
                  ;�����s��
                  (princ (strcat "\n[�����s��]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec)) ",�i�Ԗ���=" #HIN ",LR�敪=" #LR) #fil)
                );_if
              )
              (progn
                (princ (strcat "\n[�����s��]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec)) ",�i�Ԗ���=" #HIN ",LR�敪=" #LR) #fil)
              )
            );_if
          )
        );_if
      )
      (progn ;ID���Oں��ނƈႤ
        (setq #sumW 0)
        (if (equal #XX 0 0.001)
          nil ; OK
          ;else
          ;�����s��
          (princ (strcat "\n[�����s��]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec)) ",�i�Ԗ���=" #HIN ",LR�敪=" #LR) #fil)
        );_if
      )
    );_if

    ;������̐������������擾����
    (setq #WW (atoi (CFGetNumFromStr2 #hin)))
    ;04/07/19 YM MOD
    (if (wcmatch #hin "̰��*")
      (setq #WW (* 1 #WW))
      (setq #WW (* 10 #WW))
    );_if

    (if (= "C" (substr #hin 5 1))
      (progn
        ;���ꏈ�� (��Ű����1050�̏ꍇ)
        (if (= #WW 1050)(setq #WW 750))
        ;���ꏈ�� (��Ű����800�̏ꍇ)
        (if (= #WW 800)(setq #WW 900))
      )
    );_if

    (setq #sumW (+ #sumW #WW));�ݐ�

    ;ID,recNO ����
    (if (and #id_old #rec_old)
      (progn
        (if (equal #id #id_old 0.001)
          (progn ;ID���Oں��ނƓ���
            (if (equal (- #rec #rec_old) 1 0.001)
              nil ; OK
              ;else
              (progn
                ;recNO�s����
                (princ (strcat "\n[recNO�s����]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))) #fil)
              )
            );_if
          )
          (progn ;ID���Oں��ނƈႤ
            (if (equal #rec 1 0.001)
              nil ; OK
              ;else
              ;recNO�s����
              (princ (strcat "\n[recNO�s����]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))) #fil)
            );_if
          )
        );_if

      )
    );_if

    ;�i������
    (if (not (wcmatch #hin "̰��*"))
      (progn
        (setq #qry$$
          (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
            (list
              (list "�i�Ԗ���" #HIN 'STR)
              (list "LR�敪"   #LR  'STR)
            )
          )
        )
        ;�װ�i�ԂȂ�or����
        (if (or (= nil #qry$$)(< 1 (length #qry$$)))
          (princ (strcat "\n[�i�Ԑ}�`�ɂȂ�or����]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))  ",�i�Ԗ���=" #HIN ",LR�敪=" #LR) #fil)
        );_if
      )
    );_if

    (setq #id_old   #id)
    (setq #rec_old  #rec)
    (setq #dirW_old #dirW)
    (setq #i (1+ #i))
  );foreach
  ;�݌�500mm�@//////////////////////////////////////////////////////////////////////////


  (princ "\n*** �������� ***" #fil)

  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "TMP\\CHK_HIN22-" CG_SeriesCode ".txt"))
  (princ)
);C:DBC22


;;;<HOM>*************************************************************************
;;; <�֐���>    : c:GSM
;;; <�����T�v>  : �}�ʏ��"G_PMEN"2����Ă���Ă��Ȃ��ް����ނ̐}�`ID��Ԃ�
;;;             : �}�ʏ��"G_PLIN"2����Ă���Ă��Ȃ���۷��ނ̐}�`ID��Ԃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.12.12 YM
;;;*************************************************************************>MOH<
(defun c:GSM (
  /
  #ANA #ANA0 #EN #EN$ #FLG #I #J #K #KOSU #LOOP #MSG #N2 #PT$ #SS_LSYM #SYM #XD #XD0
  #ZU_ID #name
  )
  (command "._zoom" "E")
  (princ)
  (princ "\n�ް�����(���i����=\"11?\")��������...")
  (princ)
  (command "undo" "M") ; ϰ�������
  (C:ALP) ; ��w����
  (setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM"))))) ; G_LSYM �}�`�I���

  (if (= #ss_LSYM nil) (setq #ss_LSYM (ssadd)))
  (setq #i 0 #flg nil)
  (repeat (sslength #ss_LSYM)                    ; "G_LSYM"��������
    (setq #sym (ssname #ss_LSYM #i))

    (if (and (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)
             (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS))
      (progn ; �ް����ނ�����
        (GroupInSolidChgCol2 #sym CG_InfoSymCol) ; �F��ς���
        (setq #en$ (CFGetGroupEnt #sym))   ; �e�ް����ނ̓����ٰ��
;////////////////////////////////////////////////////////////////////////////////
        (if (= (CFGetSymSKKCode #sym 3) CG_SKK_THR_GAS)
          (progn ; ��۷��ނ�����
            (setq #j 0)
            (setq #loop T)
            (while (and #loop (< #j (length #en$))) ; PMEN2����������
              (setq #en (nth #j #en$))
              (if (= 2 (car (CFGetXData #en "G_PLIN")))
                (setq #loop nil) ; �P�������烋�[�v�𔲂���
              );_if
              (setq #j (1+ #j))
            );_(while

            (if #loop ; PLIN2���Ȃ�
              (progn
                (setq #flg T)
                (setq #name  (nth 8 (CFGetXData #sym "G_LSYM"))) ; �i�Ԗ���
                (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; �}�`ID
                (setq #msg (strcat "\n �}�`ID=" #zu_id "�ɺ�ێ�t����(PLIN2)������܂���B" #name))
                (princ #msg)
              )
            );_if
          )
        );_if
;////////////////////////////////////////////////////////////////////////////////
        (setq #j 0)
        (setq #loop T)
        (while (and #loop (< #j (length #en$))) ; PMEN2����������
          (setq #en (nth #j #en$))
          (if (= 2 (car (CFGetXData #en "G_PMEN")))
            (progn
              (setq #pt$ (GetLWPolyLinePt #en)) ; �O�`�_��
              (setq #loop nil) ; �P�������烋�[�v�𔲂���
              (if (= (CFGetSymSKKCode #sym 3) CG_SKK_THR_CNR) ; ��Ű����
                (setq #kosu 6)
                (setq #kosu 4)
              );_if
              (if (/= (length #pt$) #kosu)
                (progn
                  (setq #name  (nth 8 (CFGetXData #sym "G_LSYM"))) ; �i�Ԗ���
                  (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; �}�`ID
                  (setq #msg (strcat "\n �}�`ID=" #zu_id "�̊O�`�̈�(PMEN2)���_���s���B" #name))
                  (princ #msg)
                )
              );_if
            )
          );_if
          (setq #j (1+ #j))
        );_(while

        (if #loop ; PMEN2���Ȃ�
          (progn
            (setq #flg T)
            (setq #name  (nth 8 (CFGetXData #sym "G_LSYM"))) ; �i�Ԗ���
            (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; �}�`ID
            (setq #msg (strcat "\n �}�`ID=" #zu_id "�ɊO�`�̈�(PMEN2)������܂���B" #name))
            (princ #msg)
          )
        );_if
;////////////////////////////////////////////////////////////////////////////////

; 01/01/09 "G_BODY" ����/////////////////////////////////////////////////////////
        (setq #j 0)(setq #loop nil)
        (while (< #j (length #en$))
          (setq #en (nth #j #en$))
          (if (setq #xd0 (CFGetXData #en "G_BODY"))
            (progn
              (setq #kosu (nth 1 #xd0))    ; ���}�`��
              (setq #k 2)
              (repeat #kosu
                (setq #ana0 (nth #k #xd0)) ; ���}�`�����
                (if (= #ana0 nil)(setq #loop T))
                (setq #k (1+ #k))
              )
            )
          );_if
          (setq #j (1+ #j))
        );_(while

        (if #loop ; "G_BODY"���}�`����ق��s��
          (progn
            (setq #flg T)
            (setq #name  (nth 8 (CFGetXData #sym "G_LSYM"))) ; �i�Ԗ���
            (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; �}�`ID
            (setq #msg (strcat "\n �}�`ID=" #zu_id "���}�`����ق��s���ł��B" #name))
            (princ #msg)
          )
        );_if
;////////////////////////////////////////////////////////////////////////////////

        (GroupInSolidChgCol2 #sym "BYLAYER")
      )
    );_if

    (setq #i (1+ #i))
  );_(repeat

  (if #flg
    (setq #msg "\nPMEN2,PLIN2,G_BODY���������Z�b�g����Ă��Ȃ��A�C�e������܂����B\n�S���҂ɘA�����ĉ������B")
    (setq #msg "\n\�}�ʏ��PMEN2,PLIN2,G_BODY�͑S�Đ���ł���.")
  );_if
  (CFAlertMsg #msg)
  (command "undo" "B")
  (command "._zoom" "P")
  (princ)
);c:GSM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���i���ޕ\��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:skk (
  /
  #SKK #en
  )
  (setq #en T)
  (while #en
    (setq #en (car (entsel "\n���ނ�I��")))
    (setq #skk (nth 9 (CFGetXData (CFSearchGroupSym #en) "G_LSYM")))
    (CFAlertMsg (strcat "���i����: " (itoa #skk)))
  )
  (princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; �g���ް��ꎞ�ύX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:mmm (
  /
  #SYM #XD$
  )
  (setq #sym (c:oya))
  (setq #xd$ (CFGetXData #sym "G_LSYM"))
  (CFSetXData
    #sym
    "G_LSYM"
    (CFModList
      #xd$
      (list (list 13 781))
    )
  )
  (princ)
)

;*****************************************************************************:
; ���i���ޓ���==>�y�i�Ԋ�{�z�ɓo�^����Ă���i�Ԃ�ؽĂ���
; (setq #sFile (strcat CG_SYSPATH "SELPARTS.CFG"))���쐬���A����ȯĂ������z�u
; 01/05/23 YM �����p����ȯĎ����z�u�����
;*****************************************************************************:
(defun C:AutoPut (
  /
  #DUM$$ #EN #HINBAN #I #ii #KOSU #LR #OP #QRY$$ #QRY2$ #SFILE #SKK #ST #KAO$
  #SA
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)

  (setq CG_TESTMODE T) ; ý�Ӱ��
  (setq CG_TESTNO 0)   ; ��
  (setq CG_TEST_X 0)   ; �z�uX
  (setq CG_TEST_Y 0)   ; �z�uY
  (setq #skk (getstring "\n���i���ނ���͂���B"))
  (setq #Qry$$
    (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
      (list (list "���iCODE" #skk    'INT))
    )
  )
  (if (= #Qry$$ nil)
    (progn
      (CFAlertMsg "\nں��ނ�����܂���ł����B")
      (quit)
    )
  );_if
  (setq #i 0 #kosu 0)
  (foreach #dum$ #Qry$$
    (if (equal 1 (nth 1 #dum$) 0.1) ; LR�L������
      (setq #kosu (1+ #kosu))
    );_if
    (setq #i (1+ #i))
  )
  (princ (strcat "\n�y�i�Ԋ�{�z��ں��ނ� " (itoa (length #Qry$$)) " ������܂��B"
                "(LR�L������= " (itoa #kosu) " ��)"))
  (princ "\n�������ڂ��牽���ڂ̕i�Ԃ�z�u���邩�w�聄")
  (setq #st (getint "\nں��ނ̊J�n�ԍ�(0,1,2...)����͂���B"))
  (setq #en (getint "\nں��ނ̏I���ԍ�(0,1,2...)����͂���B"))
  (if (or (> #st #en)(<= (length #Qry$$) #st)(<= (length #Qry$$) #en))
    (progn
      (CFAlertMsg "\n�w��ԍ��s���I")
      (quit)
    )
  );_if

  (setq #i 0 #dum$$ nil)
  (foreach #dum$ #Qry$$
    (if (and (<= #st #i)(>= #en #i))
      (setq #dum$$ (append #dum$$ (list #dum$)))
    );_if
    (setq #i (1+ #i))
  )
  (setq #Qry$$ #dum$$)

  (setq #KAO$ (list "(����)" "(��o��)" "d(-���)" "(>o<)" "(�����)"
                    "( ��_�)" "(���� )" "(o���o)" "(^-^*)" "(;���)"))
    ;////////////////////////////////////////////////////////
    ; ==>INT
    ;////////////////////////////////////////////////////////
    (defun ##int ( &val / )
      (fix (+ &val 0.0001))
    )
    ;////////////////////////////////////////////////////////
    ; SELPARTS.CFG�̍쐬
    ;////////////////////////////////////////////////////////
    (defun ##Write (
      /
      #DIS #STRANG #STRH #ID
      #OP #SA #SFILE
      )
      ;  01 : �K�w�^�C�v
      ;  02 : �i�Ԗ���
      ;  03 : LR�敪
      ;  04 : ��t�^�C�v
      ;  05 : �p�r�ԍ�
      ;  06 : ���@W
      ;  07 : ���@D
      ;  08 : ���@H
      ;  09 : �}�`ID
      ;  10 : �W�JID
      ;  11 : ���͖���
      ;  12 : ���iCODE
      ;  13 : ���̓R�[�h
      ;  20 : �L�k
      (setq #sFile (strcat CG_SYSPATH "SELPARTS.CFG"))
      (setq #op (open #sFile "w"))
      (princ "01=0" #op)(princ "\n" #op)
      (princ "02=" #op) (princ (nth  0 #Qry2$) #op) (princ "\n" #op)         ; �i�Ԗ���
      (princ "03=" #op) (princ (nth  1 #Qry2$) #op) (princ "\n" #op)
      (princ "04=" #op) (princ (##int (nth  2 #Qry2$)) #op) (princ "\n" #op) ; LR�敪
      (princ "05=" #op) (princ (##int (nth  3 #Qry2$)) #op) (princ "\n" #op) ; �p�r�ԍ�
      (princ "06=" #op) (princ (##int (nth  4 #Qry2$)) #op) (princ "\n" #op) ; ���@W
      (princ "07=" #op) (princ (##int (nth  5 #Qry2$)) #op) (princ "\n" #op) ; ���@D
      (princ "08=" #op) (princ (##int (nth  6 #Qry2$)) #op) (princ "\n" #op) ; ���@H
      (princ "09=" #op) (princ (nth  7 #Qry2$) #op) (princ "\n" #op)         ; �}�`ID
      (princ "10=" #op) (princ (nth  8 #Qry2$) #op) (princ "\n" #op)
      (princ "11=" #op) (princ (nth  9 #Qry2$) #op) (princ "\n" #op)
      (princ "12=" #op) (princ #skk #op)            (princ "\n" #op)
      (princ "13=0" #op)(princ "\n" #op)
      (close #op)

      ; �}���_���W�̌v�Z
      (setq CG_TESTNO (1+ CG_TESTNO)) ; ��
      (if (<= (nth  4 #Qry2$) 500)
        (setq CG_TEST_X (+ CG_TEST_X 500 500)) ; W�l�ݐ�
        (setq CG_TEST_X (+ CG_TEST_X 500 (##int (nth  4 #Qry2$)))) ; W�l�ݐ�
      );_if
      (if (and (< 10 CG_TESTNO)(= 1 (rem CG_TESTNO 30)))
        (setq CG_TEST_Y (+ CG_TEST_Y -3000) CG_TEST_X 0) ; �z�uY
      );_if

      ; �}�ʂɏ�����������
      (setq #strH "60")
      (setq #strANG "0")
      (setq #dis 80 #sa 900)
      (command "._TEXT"
        (list CG_TEST_X (- CG_TEST_Y #sa (* #dis 0)) 0) #strH #strANG
        (strcat (nth 0 #Qry2$)(nth 1 #Qry2$))
      )
      (command "._TEXT"
        (list CG_TEST_X (- CG_TEST_Y #sa (* #dis 1)) 0) #strH #strANG
        (strcat "���@W: " (rtos (nth 4 #Qry2$)))
      )
      (command "._TEXT"
        (list CG_TEST_X (- CG_TEST_Y #sa (* #dis 2)) 0) #strH #strANG
        (strcat "���@D: " (rtos (nth 5 #Qry2$)))
      )
      (command "._TEXT"
        (list CG_TEST_X (- CG_TEST_Y #sa (* #dis 3)) 0) #strH #strANG
        (strcat "���@H: " (rtos (nth 6 #Qry2$)))
      )
      (if (nth 7 #Qry2$)
        (setq #ID (nth 7 #Qry2$))
        (setq #ID "�}�`ID���o�^")
      );_if
      (command "._TEXT"
        (list CG_TEST_X (- CG_TEST_Y #sa (* #dis 4)) 0) #strH #strANG
        (strcat "�}�`ID: " #ID)
      )

      (princ)
    );##Write
    ;////////////////////////////////////////////////////////

  ; �i�Ԑ}�`,�i�Ԋ�{������
  (setq #i #st #ii 0)
  (foreach #Qry$ #Qry$$
    (princ (strcat "\n***** " (itoa #i) "�Ԗ� ***** " (nth #ii #KAO$)))
    (setq #hinban (nth 0 #Qry$))
    (setq #skk    (nth 3 #Qry$))
    (if (= 1 (nth 1 #Qry$))
      (setq #LR "R")
      (setq #LR "Z")
    )
    (setq #Qry2$ ; LR���ݕ�������
      (car (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
        (list
          (list "�i�Ԗ���" #HINBAN 'STR)
          (list "LR�敪"   #LR     'STR)
        )
      ))
    )
    (if (equal (nth 11 #Qry$) 0 0.1)
      (progn ; ���ͺ���=0
        ; SELPARTS.CFG�̍쐬
        (##Write)
        ; �z�u
        (C:PosParts)
        (if (= #LR "R")
          (progn ; "R"�Ȃ�"L"���z�u����
            (setq #LR "L")
            (setq #Qry2$ ; LR���ݕ�������
              (car (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
                (list
                  (list "�i�Ԗ���" #HINBAN 'STR)
                  (list "LR�敪"   #LR     'STR)
                )
              ))
            )
            ; SELPARTS.CFG�̍쐬
            (##Write)
            ; �z�u
            (C:PosParts)
          )
        );_if
      )
    );_if
    (setq #i (1+ #i))
    (if (< (- (length #KAO$) 2) #ii)
      (setq #ii 0)
      (setq #ii (1+ #ii))
    );_if
  );_foreach
  (setq CG_TESTMODE nil) ; ý�Ӱ��

  (if (CFYesNoDialog "�}�`�������s���܂����H")(C:GSM))

  (princ "\n�z�u�I���B")
  (princ "�@\"clear\"����ނŐ}�ʏ�̷���ȯĂ����ׂč폜�ł��܂��B")
  (setq *error* nil)
);C:AutoPut

;*****************************************************************************:
; �i�Ԃ�÷��̧��==> ����ȯĂ������z�u
;*****************************************************************************:
(defun C:newAutoPut (
	/
	#ALL$$ #DUM$$ #EN #ERR #HINBAN #I #II #KAISO$$ #KAO$ #KOSU #LIST$$ #LOOP #LR #LR_KOSU
	#QRY$$ #QRY2$ #QRY2$$ #SFILE #SKK #ST #UP_NO
	#SKK2 #SYM #ZZ #GSMW #HINBANW #HINZUKEIW #fil
	)


		;////////////////////////////////////////////////////////
		; SELPARTS.CFG�̍쐬
		;////////////////////////////////////////////////////////
		(defun ##HANTEI (
			/
			#GSMW #HINBANW #HINZUKEIW #MAG 
			)

			(if (or (equal #skk1 1.0 0.001))
				(progn ;����ȯĂȂ�
					(setq #hinzukeiW (nth 3 #Qry2$));[�i�Ԑ}�`]W�l
					(setq #hinzukeiH (nth 5 #Qry2$));[�i�Ԑ}�`]H�l

					(setq #gsmW (nth 3 CG_GSYM$))
					(setq #gsmH (nth 5 CG_GSYM$))

					(setq #mag (substr #HINBAN 3 2));�Ԍ�������
					(cond
						((wcmatch #HINBAN "*90*")
						  (setq #hinbanW 900.0)
					 	)
						((wcmatch #HINBAN "*75*")
						  (setq #hinbanW 750.0)
					 	)
						((wcmatch #HINBAN "*60*")
						  (setq #hinbanW 600.0)
					 	)
						((wcmatch #HINBAN "*45*")
						  (setq #hinbanW 450.0)
					 	)
						((wcmatch #HINBAN "*30*")
						  (setq #hinbanW 300.0)
					 	)
						((wcmatch #HINBAN "*15*")
						  (setq #hinbanW 150.0)
					 	)

						((wcmatch #HINBAN "*A5*")
						  (setq #hinbanW 1050.0)
					 	)
						((wcmatch #HINBAN "*B0*")
						  (setq #hinbanW 1200.0)
					 	)
						((wcmatch #HINBAN "*C5*")
						  (setq #hinbanW 1350.0)
					 	)
						((wcmatch #HINBAN "*D0*")
						  (setq #hinbanW 1500.0)
					 	)
						((wcmatch #HINBAN "*E5*")
						  (setq #hinbanW 1650.0)
					 	)
						((wcmatch #HINBAN "*F0*")
						  (setq #hinbanW 1800.0)
					 	)
						(T
						  nil
					 	)
					);_cond
					
					(princ (strcat "\n" (nth 6 #Qry2$) "," #HINBAN ",") #fil)
					(princ "�i�Ԑ}�`W," #fil)(princ #hinzukeiW #fil)
					(princ ",GSM_W�l," #fil) (princ #gsmW      #fil)
					(princ ",�@�햼W�l," #fil)(princ #hinbanW   #fil)

					(princ "�i�Ԑ}�`H," #fil)(princ #hinzukeiH #fil)
					(princ ",GSM_H�l  ," #fil)(princ #gsmH      #fil)

					;����
					(setq #flg0 nil);NG�Ȃ�T

					(if (and (equal #hinzukeiW #gsmW 0.001)
									 (equal #gsmW #hinbanW 0.001))
						(progn
							nil ;���Ȃ�
						)
						(progn ;��肠��
							(setq #flg0 T);NG�Ȃ�T
						)
					);_if

					(if (equal #hinzukeiH #gsmH 0.001)
						(progn
							nil ;���Ȃ�
						)
						(progn ;��肠��
							(setq #flg0 T);NG�Ȃ�T
						)
					);_if

					(if #flg0
						(princ "���m�f��" #fil)
					);_if

				)
			);_if
			(princ)
		);##HANTEI
		;////////////////////////////////////////////////////////



		;////////////////////////////////////////////////////////
		; SELPARTS.CFG�̍쐬
		;////////////////////////////////////////////////////////
		(defun ##Write (
			/
			#DIS #ID #SA #STRANG #STRH
			)

			; �}�ʂɏ�����������
			(setq #strH "60")
			(setq #strANG "0")
			;2016/11/11 YM MOD-S
;;;			(setq #dis 80 #sa 1500)
			(setq #dis 80 #sa 300)
			;2016/11/11 YM MOD-E

			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 0)) 0) #strH #strANG
			 	(strcat (nth 0 #Qry2$)(nth 1 #Qry2$))
			)
			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 1)) 0) #strH #strANG
			 	(strcat "�i�Ԑ}�`W: " (rtos (nth 3 #Qry2$)))
			)
			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 2)) 0) #strH #strANG
			 	(strcat "�i�Ԑ}�`D: " (rtos (nth 4 #Qry2$)))
			)
			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 3)) 0) #strH #strANG
			 	(strcat "�i�Ԑ}�`H: " (rtos (nth 5 #Qry2$)))
			)

			(if (nth 7 #Qry2$)
				(setq #ID (nth 6 #Qry2$))
				(setq #ID "�}�`ID���o�^")
			);_if

			;2016/11/11 YM ADD-S
			(if #Qry3$
				(if (nth 4 #Qry3$)
					(setq #DRID (strcat "DR" (substr (nth 4 #Qry3$) 1 5 )))
					;else
					(setq #DRID "�}�`ID���o�^")
				);_if
			);_if
			;2016/11/11 YM ADD-E

			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 4)) 0) #strH #strANG
			 	(strcat "�}�`ID: " #ID)
			)

			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 5)) 0) #strH #strANG
			 	(strcat "���}ID: " #DRID)
			)

			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 6)) 0) #strH #strANG
			 	(strcat "���i����: " (itoa (fix #SKK)))
			)


			(command "._TEXT"
				(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 8)) 0) #strH #strANG
			 	(strcat "GSM_W: " (rtos (nth 3 CG_GSYM$)))
			)
			(command "._TEXT"
				(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 9)) 0) #strH #strANG
			 	(strcat "GSM_D: " (rtos (nth 4 CG_GSYM$)))
			)
			(command "._TEXT"
				(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 10)) 0) #strH #strANG
			 	(strcat "GSM_H: " (rtos (nth 5 CG_GSYM$)))
			)

			(princ)
		);##Write
		;////////////////////////////////////////////////////////


  ;// �R�}���h�̏�����
;;;  (StartUndoErr)

	(setq #sFile (getfiled "�@�햼ؽĂ�÷��̧��" CG_SYSPATH "TXT" 4))
	(setq #List$$ (ReadCSVFile #sFile)) ; �V���i�i��

	(setq CG_TESTMODE T) ; ý�Ӱ��
	(setq CG_TESTNO 0)   ; ��
	(setq CG_TEST_X 0)   ; �z�uX
	(setq CG_TEST_Y 0)   ; �z�uY

	(setq #ALL$$ nil)
	(setq #LR_KOSU 0)
	(setq #ERR nil) ; �װ�׸�(÷��̧�ق̕i�Ԃɒǉ����ނ��܂ނ�'T)


	; ̧��OPEN
  (setq #fil (open (strcat CG_SYSPATH "�����z�u.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
	(princ #date_time #fil) ; ���t��������
	(princ "\n" #fil)


	;2014/08/19 YM ADD-S �i�Ԃ̕ς��ɐ}�`ID�ł�OK
	(if (= 'INT (type (read (car (car #List$$)))))
		(progn ;�}�`ID������
			;�i�Ԗ��̂ɕϊ�

			(setq #hin$ nil)
			(foreach #List$ #List$$
				(setq #zukeiID (car #List$))
			  (setq #Qry$$
			    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
			      (list	(list "�}�`ID" #zukeiID 'STR))
			    )
			  )
				(if (= #Qry$$ nil) ; //////////////////////////////////////////////////////////////////
					(progn
						(CFAlertMsg	(strcat "\n�i�Ԑ}�`��ں��ނ��Ȃ�.\n������ " #zukeiID " ������"))
						(setq #ERR T)
					)
					(progn
						;�i�Ԗ���
						(setq #hin (car (car #Qry$$)))
						(setq #hin$ (append #hin$ (list (list #hin))))
					)
				);_if

			);_foreach

			(setq #List$$ #hin$)
		)
	);_if
	;2014/08/19 YM ADD-E �i�Ԃ̕ς��ɐ}�`ID�ł�OK


;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(foreach #List$ #List$$
		(setq #hinban (car #List$))
	  (setq #Qry$$
	    (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
	      (list	(list "�i�Ԗ���" #hinban 'STR))
	    )
	  )
		(if (or (= #Qry$$ nil)(> (length #Qry$$) 1)) ; //////////////////////////////////////////////////////////////////
			(progn
				(CFAlertMsg	(strcat "\n�i�Ԋ�{��ں��ނ��Ȃ����܂��͕�������܂���.\n������ " #hinban " ������"))
				(setq #ERR T)
			)
			(progn
				(setq #ALL$$ (append #ALL$$ (list (car #Qry$$)))) ; �S�Ώ�ں���
;;;				(setq #SKK (nth 3 (car #Qry$$))) ; ���i����
			)
		);_if

		(if (= 1 (nth 1 (car #Qry$$)))
			(setq #LR_KOSU (1+ #LR_KOSU))
		);_if
	);_foreach

	(if #ERR
		(progn
			(CFAlertMsg "�����z�u���I�����܂�.")
			(quit)
		)
	);_if

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq #kosu (length #ALL$$))

	(princ (strcat "\n�Ώەi�Ԃ� " (itoa #kosu) " ������܂�"))
	(princ (strcat "[L/R���݂� " (itoa (+ #kosu #LR_KOSU)) " ��]"))

	; �i�Ԑ}�`,�i�Ԋ�{������
	(foreach #Qry$ #ALL$$

		(setq #hinban (nth 0 #Qry$))
		(setq #skk    (nth 3 #Qry$))
		;2014/07/21 YM ADD
		(setq #skk1 (CFGetSeikakuToSKKCode #skk 1)) ;1����
		(setq #skk2 (CFGetSeikakuToSKKCode #skk 2)) ;2����
		(setq #skk3 (CFGetSeikakuToSKKCode #skk 3)) ;3����
		(if (equal #skk2 2.0 0.001)
			(setq #ZZ 2300)
			;else
			(setq #ZZ 0)
		);_if
		
		(if (equal 1.0 (nth 1 #Qry$) 0.001)
			(setq #LR "R")
			;else
			(setq #LR "Z")
		)
	  (setq #Qry2$$ ; LR���ݕ�������
	    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
	      (list
					(list "�i�Ԗ���" #HINBAN 'STR)
	        (list "LR�敪"   #LR     'STR)
	      )
	    )
	  )
		(if (or (= #Qry2$$ nil)(> (length #Qry2$$) 1)) ; //////////////////////////////////////////////////////////////////
			(progn
				(CFAlertMsg	(strcat "\n�i�Ԑ}�`��ں��ނ��Ȃ����܂��͕�������܂���.\n������ " #hinban " ������"))
			)
			(progn
				(setq #Qry2$ (car #Qry2$$))
			)
		);_if




		;2016/11/11 YM ADD-S
	  (setq #Qry3$$ ; LR���ݕ�������
	    (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
	      (list
					(list "�i�Ԗ���" #HINBAN 'STR)
	        (list "LR�敪"   #LR     'STR)
	      )
	    )
	  )
		(if (= #Qry3$$ nil)
			(progn
				nil ;���Ȃ�
			)
			(progn
				(setq #Qry3$ (car #Qry3$$));�ŏ��Ɍ�����������
			)
		);_if
		;2016/11/11 YM ADD-E


		; �}���_���W�̌v�Z
		(setq CG_TESTNO (1+ CG_TESTNO)) ; ��
		(if (<= (nth  3 #Qry2$) 500)    ;���@W�l
			(setq CG_TEST_X (+ CG_TEST_X 2000)) ; W�l�ݐ�
			(setq CG_TEST_X (+ CG_TEST_X 1000  (nth  3 #Qry2$))) ; W�l�ݐ�
		);_if

		; �z�u
;;;				(C:PosParts)
		(setq #sym (NS_PosParts #HINBAN #LR (list CG_TEST_X CG_TEST_Y #ZZ) 0.0 nil))
		;���\��t��
		(PCD_MakeViewAlignDoor (list #sym) 3 nil)
		(setq CG_GSYM$ (CFGetXData #sym "G_SYM"))  ;G_SYM

		;�}�ʂ�÷�ďo��
;2016/11/11 YM DEL-S
;;;		(command "vpoint" "0,0,1")
;;;		(command "_.ZOOM" "C" (list CG_TEST_X CG_TEST_Y) 2000)
;2016/11/11 YM DEL-E

;UCS���W�n�ύX ;2016/11/11 YM ADD
	  (command "._ucs" "X" 90)
	  (command "._plan" "C")

		(##Write)

;WORLD���W�n ;2016/11/11 YM ADD
	  (command "._ucs" "W" )

		;�������@�햼�ƊԌ��������Ă��邩�H
		(##HANTEI)

		(if (= #LR "R")
			(progn ; "R"�Ȃ�"L"���z�u����
				(setq #LR "L")
			  (setq #Qry2$ ; LR���ݕ�������
			    (car (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
			      (list
							(list "�i�Ԗ���" #HINBAN 'STR)
			        (list "LR�敪"   #LR     'STR)
			      )
			    ))
			  )

				; �}���_���W�̌v�Z
				(setq CG_TESTNO (1+ CG_TESTNO)) ; ��
				(if (<= (nth  3 #Qry2$) 500);���@W�l
					(setq CG_TEST_X (+ CG_TEST_X 2000)) ; W�l�ݐ�
					(setq CG_TEST_X (+ CG_TEST_X 1000  (nth  3 #Qry2$))) ; W�l�ݐ�
				);_if
				(setq #sym (NS_PosParts #HINBAN #LR (list CG_TEST_X CG_TEST_Y #ZZ) 0.0 nil))
				;���\��t��
				(PCD_MakeViewAlignDoor (list #sym) 3 nil)
				(setq CG_GSYM$ (CFGetXData #sym "G_SYM"))  ;G_SYM
				;�}�ʂ�÷�ďo��
;2016/11/11 YM DEL-S
;;;				(command "vpoint" "0,0,1")
;;;				(command "_.ZOOM" "C" (list CG_TEST_X CG_TEST_Y) 2000)
;2016/11/11 YM DEL-E

;UCS���W�n�ύX ;2016/11/11 YM ADD
	  (command "._ucs" "X" 90)
	  (command "._plan" "C")

		(##Write)

;WORLD���W�n ;2016/11/11 YM ADD
	  (command "._ucs" "W" )

				;�������@�햼�ƊԌ��������Ă��邩�H
				(##HANTEI)

			)
		);_if
	
	);_foreach


	(setq CG_TESTMODE nil) ; ý�Ӱ��



	;��۰��ٸر�
	(setq CG_GSYM$ nil)

	(if #fil (close #fil))
	(startapp "notepad.exe" (strcat CG_SYSPATH "�����z�u.txt"))


	(princ "\n--- �z�u�I�� ---")
  (setq *error* nil)
);C:newAutoPut





;*****************************************************************************:
; �i�Ԃ�÷��̧��==> ����ȯĂ������z�u(�A���z�u)
;*****************************************************************************:
(defun C:newAutoPutC (
	/
	#ALL$$ #DUM$$ #EN #ERR #HINBAN #I #II #KAISO$$ #KAO$ #KOSU #LIST$$ #LOOP #LR #LR_KOSU
	#QRY$$ #QRY2$ #QRY2$$ #SFILE #SKK #ST #UP_NO
	#SKK2 #SYM #ZZ #GSMW #HINBANW #HINZUKEIW #fil
	)

		;////////////////////////////////////////////////////////
		; SELPARTS.CFG�̍쐬
		;////////////////////////////////////////////////////////
		(defun ##HANTEI (
			/
			#GSMW #HINBANW #HINZUKEIW #MAG 
			)

			(setq #hinzukeiW (nth 3 #Qry2$));[�i�Ԑ}�`]W�l
			(setq #hinzukeiH (nth 5 #Qry2$));[�i�Ԑ}�`]H�l

			(setq #gsmW (nth 3 CG_GSYM$))
			(setq #gsmH (nth 5 CG_GSYM$))

			(if (or (equal #skk1 1.0 0.001))
				(progn ;����ȯĂȂ�

					(cond
						;2016/12/28 YM ADD-S
						((wcmatch #HINBAN "*87*")
						  (setq #hinbanW 875.0)
					 	)
						((wcmatch #HINBAN "*72*")
						  (setq #hinbanW 725.0)
					 	)
						;2016/12/28 YM ADD-E
						((wcmatch #HINBAN "*90*")
						  (setq #hinbanW 900.0)
					 	)
						((wcmatch #HINBAN "*75*")
						  (setq #hinbanW 750.0)
					 	)
						((wcmatch #HINBAN "*60*")
						  (setq #hinbanW 600.0)
					 	)
						((wcmatch #HINBAN "*45*")
						  (setq #hinbanW 450.0)
					 	)
						((wcmatch #HINBAN "*30*")
						  (setq #hinbanW 300.0)
					 	)
						((wcmatch #HINBAN "*15*")
						  (setq #hinbanW 150.0)
					 	)

						((wcmatch #HINBAN "*A5*")
						  (setq #hinbanW 1050.0)
					 	)
						((wcmatch #HINBAN "*B0*")
						  (setq #hinbanW 1200.0)
					 	)
						((wcmatch #HINBAN "*C5*")
						  (setq #hinbanW 1350.0)
					 	)
						((wcmatch #HINBAN "*D0*")
						  (setq #hinbanW 1500.0)
					 	)
						((wcmatch #HINBAN "*E5*")
						  (setq #hinbanW 1650.0)
					 	)
						((wcmatch #HINBAN "*F0*")
						  (setq #hinbanW 1800.0)
					 	)
						(T
						  nil
					 	)
					);_cond

				)
				(progn ;���ވȊO�@�i�Ԃ���Ԍ��͂킩��Ȃ�
					(setq #hinbanW #hinzukeiW)
				)
			);_if
					
			(princ (strcat "\n'" (nth 6 #Qry2$) "," #HINBAN "," #LR "," ) #fil);�}�`ID,�i��,LR
			(princ "�i�Ԑ}�`W,"  #fil)(princ #hinzukeiW #fil)
			(princ ",GSM_W�l,"   #fil)(princ #gsmW      #fil)
			
			(if (or (equal #skk1 1.0 0.001))
				(progn ;����ȯĂȂ�
					(princ ",�@�햼W�l," #fil)(princ #hinbanW   #fil)
				)
			);_if

			(princ ",�i�Ԑ}�`H," #fil)(princ #hinzukeiH #fil)
			(princ ",GSM_H�l  ," #fil)(princ #gsmH      #fil)

			;����
			(setq #flg0 nil);NG�Ȃ�T

			(if (and (equal #hinzukeiW #gsmW 0.001)
							 (equal #gsmW #hinbanW 0.001))
				(progn
					nil ;���Ȃ�
				)
				(progn ;��肠��
					(setq #flg0 T);NG�Ȃ�T
				)
			);_if

					(if (equal #hinzukeiH #gsmH 0.001)
						(progn
							nil ;���Ȃ�
						)
						(progn ;��肠��
							(setq #flg0 T);NG�Ȃ�T
						)
					);_if

					(if #flg0
						(princ ",���m�f��" #fil)
					);_if


			(princ)
		);##HANTEI
		;////////////////////////////////////////////////////////


  ;// �R�}���h�̏�����
;;;  (StartUndoErr)

	(setq #sFile (getfiled "�@�햼ؽĂ�÷��̧��" CG_SYSPATH "TXT" 4))
	(setq #List$$ (ReadCSVFile #sFile)) ; �V���i�i��

	(setq CG_TESTMODE T) ; ý�Ӱ��
	(setq CG_TESTNO 0)   ; ��
	(setq CG_TEST_X 0)   ; �z�uX
	(setq CG_TEST_Y 0)   ; �z�uY

	(setq #ALL$$ nil)
	(setq #LR_KOSU 0)
	(setq #ERR nil) ; �װ�׸�(÷��̧�ق̕i�Ԃɒǉ����ނ��܂ނ�'T)


	; ̧��OPEN
  (setq #fil (open (strcat CG_SYSPATH "�����z�u.csv") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
	(princ #date_time #fil) ; ���t��������
	(princ "\n" #fil)


	;2014/08/19 YM ADD-S �i�Ԃ̕ς��ɐ}�`ID�ł�OK
	(if (= 'INT (type (read (car (car #List$$)))))
		(progn ;�}�`ID������
			;�i�Ԗ��̂ɕϊ�

			(setq #hin$ nil)
			(foreach #List$ #List$$
				(setq #zukeiID (car #List$))
			  (setq #Qry$$
			    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
			      (list	(list "�}�`ID" #zukeiID 'STR))
			    )
			  )
				(if (= #Qry$$ nil) ; //////////////////////////////////////////////////////////////////
					(progn
						(CFAlertMsg	(strcat "\n�i�Ԑ}�`��ں��ނ��Ȃ�.\n������ " #zukeiID " ������"))
						(setq #ERR T)
					)
					(progn
						;�i�Ԗ���
						(setq #hin (car (car #Qry$$)))
						(setq #hin$ (append #hin$ (list (list #hin))))
					)
				);_if

			);_foreach

			(setq #List$$ #hin$)
		)
	);_if
	;2014/08/19 YM ADD-E �i�Ԃ̕ς��ɐ}�`ID�ł�OK


;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(foreach #List$ #List$$
		(setq #hinban (car #List$))
	  (setq #Qry$$
	    (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
	      (list	(list "�i�Ԗ���" #hinban 'STR))
	    )
	  )
		(if (or (= #Qry$$ nil)(> (length #Qry$$) 1)) ; //////////////////////////////////////////////////////////////////
			(progn
				(CFAlertMsg	(strcat "\n�i�Ԋ�{��ں��ނ��Ȃ����܂��͕�������܂���.\n������ " #hinban " ������"))
				(setq #ERR T)
			)
			(progn
				(setq #Qry$ (car #Qry$$))
				(if (equal 1.0 (nth 1 #Qry$) 0.001)
					(progn
						(setq #LR "L")
						(setq #ALL$$ (append #ALL$$ (list (append #Qry$ (list #LR)))))
						(setq #LR "R")
						(setq #ALL$$ (append #ALL$$ (list (append #Qry$ (list #LR)))))
					)
					;else
					(progn
						(setq #LR "Z")
						(setq #ALL$$ (append #ALL$$ (list (append #Qry$ (list #LR)))))
					)
				);_if


;;;				(setq #SKK (nth 3 (car #Qry$$))) ; ���i����
			)
		);_if

	);_foreach


	(if #ERR
		(progn
			(CFAlertMsg "�����z�u���I�����܂�.")
			(quit)
		)
	);_if

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq #kosu (length #ALL$$))

	; �i�Ԑ}�`,�i�Ԋ�{������
	(foreach #Qry$ #ALL$$

		(setq #hinban (nth  0 #Qry$))
		(setq #skk    (nth  3 #Qry$))
		(setq #LR     (nth 11 #Qry$))

		;2014/07/21 YM ADD
		(setq #skk1 (CFGetSeikakuToSKKCode #skk 1)) ;1����
		(setq #skk2 (CFGetSeikakuToSKKCode #skk 2)) ;2����
		(setq #skk3 (CFGetSeikakuToSKKCode #skk 3)) ;3����
		(if (equal #skk2 2.0 0.001)
			(setq #ZZ 2300)
			;else
			(setq #ZZ 0)
		);_if
		
	  (setq #Qry2$$ ; LR���ݕ�������
	    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
	      (list
					(list "�i�Ԗ���" #HINBAN 'STR)
	        (list "LR�敪"   #LR     'STR)
	      )
	    )
	  )

		(if (or (= #Qry2$$ nil)(> (length #Qry2$$) 1)) ; //////////////////////////////////////////////////////////////////
			(progn
				(CFAlertMsg	(strcat "\n�i�Ԑ}�`��ں��ނ��Ȃ����܂��͕�������܂���.\n������ " #hinban " ������"))
			)
			(progn
				(setq #Qry2$ (car #Qry2$$))
			)
		);_if

		; �}���_���W�̌v�Z
		(setq CG_TESTNO (1+ CG_TESTNO)) ; ��
		; �z�u
		(setq #sym (NS_PosParts #HINBAN #LR (list CG_TEST_X CG_TEST_Y #ZZ) 0.0 nil))
		;���\��t��
		(PCD_MakeViewAlignDoor (list #sym) 3 nil)
		(setq CG_GSYM$ (CFGetXData #sym "G_SYM")) ;G_SYM

		;�������@�햼�ƊԌ��������Ă��邩�H
		(##HANTEI)

		;G_CG����
		(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
		(setq #id  (nth 0 #xd_LSYM$));�}�`ID
		(setq #hin (nth 5 #xd_LSYM$));�i��
		(setq #LR  (nth 6 #xd_LSYM$));LR
		(setq #seikaku (nth 9 #xd_LSYM$));���iCODE

	  (setq #ss (CFGetSameGroupSS #sym));��ٰ�ߐ}�`
	  (setq #i 0)(setq #GCG_FLG nil)
	  (repeat (sslength #ss)
	    (setq #en (ssname #ss #i))
	    (setq #xd$ (CFGetXData #en "G_CG"))
			(if #xd$
				(progn
					(setq #GCG_FLG T)
					(princ "\nG_CG: " #fil)(princ #xd$ #fil)
				)
			);_if
	    (setq #i (1+ #i))
	  );repeat
		(if (= #GCG_FLG nil)
			(princ "\n�������@G_CG���Ȃ�" #fil)
		);_if
		(princ "\n********************************" #fil)

		;GSM��W�l�������̔z�u�ʒu�𑝂₷
		(setq #gsmW (nth 3 CG_GSYM$))
		(setq CG_TEST_X (+ CG_TEST_X #gsmW))
	
	);_foreach


	(setq CG_TESTMODE nil) ; ý�Ӱ��

;;;  (if (CFYesNoDialog "�}�`�������s���܂����H")(C:GSM))

	;��۰��ٸر�
	(setq CG_GSYM$ nil)

	(if #fil (close #fil))
	(startapp "notepad.exe" (strcat CG_SYSPATH "�����z�u.csv"))

	(princ "\n�z�u�I��")

  (setq *error* nil)
);C:newAutoPutC


;<HOM>*************************************************************************
; <�֐���>    : NS_PosParts
; <�����T�v>  : �z�u
; <�߂�l>    :
; <�쐬>      : 2014/06/23 YM ADD
; <���l>      :
;*************************************************************************>MOH<
(defun NS_PosParts (
	&HinBan
	&LR
	&Pos
	&Ang
	&Dan  ;;  �f�ʎw���L��  2005/01/13 G.YK ADD
  /
	#ANG #DWG #FIGUREREOCRD #GLSYM #KIHONREOCRD #POS #SS_DUM #SYM
  )
  (setq #sym nil) ; 04/10/01 G.YK ADD

	;���iCODE�擾�̂���
  (setq #KihonReocrd (car 
	  (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
	    (list
		    (list "�i�Ԗ���" &HinBan 'STR)
		    (list "LR�L��"   (if (= "Z" &LR) "0" "1") 'INT)
	    )
		)
  ))
;;;  (WebOutLog "�i�Ԋ�{:")(WebOutLog #KihonReocrd)
;;(princ "\n#KihonReocrd: ")(princ #KihonReocrd)

	;�}�`ID�擾�̂���
  (setq #FigureReocrd (car 
	  (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
		  (list
		    (list "�i�Ԗ���" &HinBan 'STR)
		    (list "LR�敪"   &LR     'STR)
		  )
		)
  ))



  (setq #dwg (nth 6 #FigureReocrd))

  (if (findfile (strcat CG_MSTDWGPATH #dwg ".dwg"))
    (progn
	    ; ���ނ̑}��
	    (command "_insert" (strcat CG_MSTDWGPATH #dwg) &Pos "1" "" (rtd &Ang))

	    ; �z�u���_�Ɗp�x���m�� LSYM�̐ݒ�̂���
	    (setq #Pos (cdr (assoc 10 (entget (entlast)))))
	    (setq #Ang (cdr (assoc 50 (entget (entlast)))))

	    ; ����&�O���[�v��
	    (command "_explode" (entlast))  ; �C���T�[�g�}�`����
			(setq #ss_dum (ssget "P"))
			(SKMkGroup #ss_dum)
			(setq #sym (PKC_GetSymInGroup #ss_dum))

	    ; LSYM�̐ݒ�
	    (setq #glsym
	      (list
		      #dwg                        ;1 :�{�̐}�`ID  :�w�i�Ԑ}�`�x.�}�`ID
		      #Pos                        ;2 :�}���_    :�z�u��_
		      #Ang                        ;3 :��]�p�x  :�z�u��]�p�x
		      CG_Kcode                    ;4 :�H��L��  :CG_Kcode
		      CG_SeriesCode               ;5 :SERIES�L��  :CG_SeriesCode
		      &HinBan                     ;6 :�i�Ԗ���  :�w�i�Ԑ}�`�x.�i�Ԗ���
		      &LR                         ;7 :L/R�敪   :�w�i�Ԑ}�`�x.����L/R�敪
		      ""                          ;8 :���}�`ID  :
		      ""                          ;9 :���J���}�`ID:
		      (fix (nth 3 #KihonReocrd))  ;10:���iCODE  :�w�i�Ԋ�{�x.���iCODE
		      0                           ;11:�����t���O  :�O�Œ�i�P�ƕ��ށj
		      0                           ;12:�z�u���ԍ�  :�z�u���ԍ�(1�`)
		      (fix (nth 2 #FigureReocrd)) ;13:�p�r�ԍ�  :�w�i�Ԑ}�`�x.�p�r�ԍ�
		      (nth 5 #FigureReocrd)       ;14:���@�g  :�w�i�Ԑ}�`�x.���@�g
		      (if (/= &Dan nil) &Dan 0)   ;15.�f�ʎw���̗L��  :�w�v���\���x.�f�ʗL��  ;;  2005/01/13 G.YK ADD
	      )
	    )
	    (CFSetXData #sym "G_LSYM" #glsym)

	    (KcSetG_OPT #sym)                         ;�Ђ����I�v�V�����i(�}�`�Ȃ�)���Z�b�g����
	    (SetLayer)                                ;���C���[�����̏�Ԃɖ߂�
		)
    (progn
			(CFAlertMsg (strcat "�}�`������܂���.�}�`ID= "  #dwg "  \n�i�Ԗ���= " &HinBan "  LR�敪= "  &LR))
			(quit)
		)
	);_if

	;�߂�l
  #sym
);NS_PosParts





;//////////////////////////////////////////////////////////
; C:AUTO_PLAN , C:IDCheck �Ŏg�p
;//////////////////////////////////////////////////////////
(defun RepeatPlan (&i &loop #case_lis / )
  (repeat &loop     ; �J��Ԃ���
    (setq #case_lis (append #case_lis (list &i)))
    (setq &i (1+ &i))
  )
  #case_lis
);RepeatPlan
;//////////////////////////////////////////////////////////

;//////////////////////////////////////////////////////////
; ���݌�������ý� 00/03/03 YM
; 01/10/11 YM ����
;//////////////////////////////////////////////////////////
(defun C:AUTO_PLAN (
  /
  #CASE_LIS #LOOP #NEND #NO #NSTART
  )
  (setq CG_TESTMODE 1)    ;ý�Ӱ��
  (setq CG_AUTOMODE 0)    ;����Ӱ��
  (setq CG_DEBUG 1)       ;���ޯ��Ӱ��

  ; 01/10/11 YM ADD-S
  (princ "\n�v����������A�����s���܂�")
  (setq #nStart (getint "\n�J�n�ԍ������(5001,7001�Ȃ�): "))
  (setq #nEnd   (getint "\n�I���ԍ������: "))
  (setq #loop (1+ (- #nEnd #nStart)))
  ; 01/10/11 YM ADD-E

  (setq #case_lis '())
  (setq #case_lis (RepeatPlan #nStart #loop #case_lis)) ; �J�n�ԍ�,�J��Ԃ���

  (foreach #i #case_lis
    (setq CG_TESTCASE #i)
    (setq #no (strcat "case" (itoa #i)))

    (setq CG_KENMEI_PATH (strcat CG_KENMEIDATA_PATH #no "\\")) ; \BUKKEN\case?
    (setq S_FILE (strcat CG_KENMEI_PATH "MODEL.DWG")) ; \BUKKEN\case?\DWG���߽

    (if (= (getvar "DWGPREFIX") CG_KENMEI_PATH)
      (progn
        (CFAlertMsg (strcat "\n ̫��ލ폜�ł��Ȃ����߁AýđΏۈȊO����а�����Ɉړ����ĉ�����."
                            "\n(������x�}�ʂ��J�������ĉ�����)"))
        (quit)
      )
    );_if

    ;// case? �t�H���_�폜
    (vl-file-delete (strcat CG_KENMEI_PATH "MODEL.DWG"))
    (vl-file-delete (strcat CG_KENMEI_PATH "MODEL.BAK"))
;;;   (dos_delete (strcat CG_KENMEI_PATH "MODEL.DWG"))                         ; model.dwg
;;;   (dos_delete (strcat CG_KENMEI_PATH "MODEL.BAK"))                         ; model.dwg
;;;   (dos_rmdir (strcat CG_KENMEIDATA_PATH #no)) ; \BUKKEN\case?

    (setq CG_BukkenNo #no)
    (setq CG_BukkenName #no)

    (setq CG_SetXRecord$
      (list
        CG_DBNAME
        CG_SeriesCode
        CG_BrandCode
        CG_DRSeriCode
        CG_DRColCode
        CG_UpCabHeight
        CG_CeilHeight
        CG_RoomW
        CG_RoomD
        "1"                  ;�K�X��
        "5"                  ;�d�C��
      )
    )

    (setq CG_OpenMode 0)
    (command "_point" "0,0")

    ;// �V�K�����쐬
;;;   (dos_mkdir (strcat CG_KENMEIDATA_PATH #no "\\")) ; \BUKKEN\case?

    (vl-file-copy (strcat CG_SYSPATH "ORGMODEL.DWG") S_FILE)
;;;   (dos_copy (strcat CG_SYSPATH "ORGMODEL.DWG") S_FILE)

    (if (/= (getvar "DBMOD") 0)
      (progn
        (command "_qsave")
        (vl-cmdf "._open" S_FILE)
      )
      (progn
        (vl-cmdf "._open" S_FILE)
      )
    );_if

    (S::STARTUP)
    (C:SearchPlan) ; ���݌��� �J�n
    (c:qq) ; �}�ʏ�̷��ޏ�񏑂��o��
    (setq #i (1+ #i))
  );foreach

  ; �ۑ�
  (command "_.QSAVE")

  (setq CG_TESTMODE nil) ;ý�Ӱ��
  (setq CG_AUTOMODE 0)   ;����Ӱ��
  (setq *error* nil)
  (princ)
);C:AUTO_PLAN

;*****************************************************************************:
; cfģ�ٕ����쐬 01/06/18 YM Ž���ڽ-���߼ذ�ޗp
; ��cfģ�ُꏊ�F CG_SYSPATH \TMP
;*****************************************************************************:
(defun C:MakeCFG (
  /
  #FLG #IFILE #IP #K #LINE #NUM #OFILE #OP
  )
  ;�i�X-�Z�X�p All cfg
  (setq #ifile (strcat CG_SYSPATH "TMP\\ALL_CFG_" CG_SeriesDB ".prn"))
  (setq #ip (open #ifile "r"))

  (setq #k 1001)
  (setq #num (itoa #k))
  ; �ŏ���̧�ق��J�� "1001"
  (setq #ofile (strcat CG_SYSPATH "TMP\\makecfg\\" "Srcpln" "_" CG_SeriesDB "_" #num ".cfg"))
  (setq #op (open #ofile "w"))

  (setq #flg T)
  (while (setq #line (read-line #ip))
    (if (and (= #flg nil)(= ";" (substr #line 1 1)))
      (progn
        (close #op)
        (setq #k (1+ #k))
        (setq #num (itoa #k))
        (setq #ofile (strcat CG_SYSPATH "TMP\\makecfg\\" "Srcpln" "_" CG_SeriesDB "_" #num ".cfg"))
        (setq #op (open #ofile "w"))
        (princ (strcat #line "\n") #op)
      )
      (princ (strcat #line "\n") #op)
    );_if
    (setq #flg nil)
  )
  (close #ip)
  (close #op)
  (princ)
);C:MakeCFG

;-------------- ���^"G_LSYM"�ɂ���---------- 01/11/01 YM
(defun c:OLD ( / #I #SS #SYM #XD$)
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #sym (ssname #ss #i))
    (setq #xd$ (CFGetXData #sym "G_LSYM"))
    ;// �g���f�[�^�̍X�V
    (CFSetXData #sym "G_LSYM"
      (CFModList #xd$
        (list (list 7 "Z")(list 8 "Z"))
      )
    )
    (setq #i (1+ #i))
  )
  (princ)
);c:OLD

;*****************************************************************************:
; �����Ǘ�,�����\���e�[�u���쐬�c�[��(NAS ��ۑI�����ǉ�)
; �g�p�ꏊ:CG_SYSPATH \TEMP
; 02/01/21 YM
; ��ۑI����÷��̧��,�����Ǘ�,�����\���̐��`CSV̧�َg�p
;*****************************************************************************:
(defun C:MK_HUKU_GAS (
  /
  #FP1 #FP2 #GAS #GAS_NAME #HINBAN #HUKU_ID #I #IFNAME1 #IFNAME2 #IFNAME3
  #KIGO #KIGO$ #LIST1$$ #LIST2$$ #LIST3$$ #NEWLIST$ #NEWLIST$$ #NEWLIST2$ #NEWLIST2$$
  #OFNAME1 #OFNAME2 #STRLEN
  )

  ; CKS��
;;; (setq #ptn 50) ; ���`�Ɋ܂܂��\�������(40�����߂�50)
  ; CKS��
  (setq #ptn 10) ; ���`�Ɋ܂܂��\�������(8�����߂�10)

    ;/////////////////////////////////////////////////////////////////
    (defun ##ChGasName (
      &ORG ; �ύX��
      &GAS ; ��ەi��
      /
      #no #res
      )
      (setq #strlen (strlen &ORG)) ; �����񒷂�
      (setq #no (vl-string-search "+" &ORG))
      (setq #res (strcat &GAS " " (substr &ORG (1+ #no)(- #strlen #no))))
      #res
    )
    ;/////////////////////////////////////////////////////////////////
    (defun ##OUTPUT (
      &LIS$$ ; �o��ؽ�
      &fp    ; ̧�َ��ʎq
      /
      #I #N
      )
      (setq #n 1)
      (foreach #NewList$ &LIS$$
        (setq #i 1)
        (foreach #NewList #NewList$
          (if (= #i 1)
            (princ #NewList &fp)
            (princ (strcat "," #NewList) &fp)
          );_if
          (setq #i (1+ #i))
        )
        (princ "\n" &fp)
        (setq #n (1+ #n))
      )
      (close &fp)
      (princ)
    )
    ;/////////////////////////////////////////////////////////////////


  ; ��ۋL��
  (setq #kigo$ (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"
                     "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
                     "U" "V" "W" "X" "Y" "Z"))
;;; ;�����Ǘ� CKS
;;; (setq #ifname1 (strcat CG_SYSPATH "TEMP\\S-GAS.txt"))    ; �I����̧��(���̐���۰��)
;;; (setq #ifname2 (strcat CG_SYSPATH "TEMP\\S-GAS-TMP.csv"))  ; ���`�ƂȂ镡���Ǘ�ð��ق�ں���
;;; (setq #ifname3 (strcat CG_SYSPATH "TEMP\\S-GAS-TMP2.csv")) ; ���`�ƂȂ镡���\��ð��ق�ں���
;;; (setq #ofname1 (strcat CG_SYSPATH "TEMP\\S-GAS-OUT.csv"))  ; �o��̧��(�����Ǘ�)
;;; (setq #ofname2 (strcat CG_SYSPATH "TEMP\\S-GAS-OUT2.csv")) ; �o��̧��(�����\��)

  ;�����Ǘ� CKN
  (setq #ifname1 (strcat CG_SYSPATH "TEMP\\N-GAS.txt"))    ; �I����̧��(���̐���۰��)
  (setq #ifname2 (strcat CG_SYSPATH "TEMP\\N-GAS-TMP.csv"))  ; ���`�ƂȂ镡���Ǘ�ð��ق�ں���
  (setq #ifname3 (strcat CG_SYSPATH "TEMP\\N-GAS-TMP2.csv")) ; ���`�ƂȂ镡���\��ð��ق�ں���
  (setq #ofname1 (strcat CG_SYSPATH "TEMP\\N-GAS-OUT.csv"))  ; �o��̧��(�����Ǘ�)
  (setq #ofname2 (strcat CG_SYSPATH "TEMP\\N-GAS-OUT2.csv")) ; �o��̧��(�����\��)

  (setq #fp1 (open #ofname1 "w"))
  (setq #fp2 (open #ofname2 "w"))
  (setq #List1$$ (ReadCSVFile #ifname1)) ; ��ۑI����
  (setq #List2$$ (ReadCSVFile #ifname2)) ; ���`�����Ǘ�
  (setq #List3$$ (ReadCSVFile #ifname3)) ; ���`�����\��

  (setq #NewList1$$ nil); �����Ǘ�
  (setq #NewList2$$ nil); �����\��

  (setq #j 0)
  (foreach #List1$ #List1$$   ; �I������ٰ��
    (setq #GAS (car #List1$)) ; �޽�i��
    (setq #kigo (nth #j #kigo$))
    (setq #k 0) ; �ʂ��ԍ�
    ; *** �����Ǘ� ***
    (foreach #List2$ #List2$$ ; �����Ǘ� ���`ں��ޕ�ٰ��
      (setq #huku_ID (atoi (nth 0 #List2$))) ; ����ID 1�`40�����
      (setq #GAS_NAME (nth 16 #List2$))
      (setq #GAS_NAME (##ChGasName #GAS_NAME #GAS))
      (setq #NewList1$
        (CFModList #List2$
          (list
            (list  0 (itoa (+ #huku_ID (* #ptn #j)))) ; 50�~0,1,2...
            (list  9 #KIGO)                           ; A,B,C,...
            (list 16 #GAS_NAME)                       ; �����햼��
            (list 17 (strcat #kigo (itoa #k)))
          )
        )
      )
      (setq #NewList1$$ (append #NewList1$$ (list #NewList$))) ; �����Ǘ�
      (setq #k (1+ #k))
      (princ "\n")(princ (strcat #kigo (itoa #k)))
    );_foreach

    ; *** �����\�� ***
    (foreach #List3$ #List3$$ ; ���`ں��ޕ�ٰ��(�����\��)
      (setq #huku_ID (atoi (nth 0 #List3$))) ; ����ID
      (setq #hinban (nth 2 #List3$))
      (if (= "" #hinban)
        (setq #hinban #GAS) ; ���`�ŕi��=""�̂Ƃ��ͺ�ەi�Ԃ���
      );_if
      (setq #NewList2$
        (CFModList #List3$
          (list
            (list 0 (itoa (+ #huku_ID (* #ptn #j)))) ; �������
            (list 2 #hinban)
          )
        )
      )
      (setq #NewList2$$ (append #NewList2$$ (list #NewList2$)))
    );_foreach
    (princ "\n*** j ***")(princ #j)
    (setq #j (1+ #j))
  );_foreach

  ; ̧�ُo��(csv�`��)�����Ǘ�
  (##OUTPUT #NewList1$$ #fp1)
  ; ̧�ُo��(csv�`��)�����\��
  (##OUTPUT #NewList2$$ #fp2)

  (princ)
);C:MK_HUKU_GAS

;//////////////////////////////////////////////////////////
; C:Del0door �}�ʏ��"0_DOOR"��w�}�`��S�č폜
;//////////////////////////////////////////////////////////
(defun C:Del0door (
  /
  #ELM #I #SS #LAYER$ #FLG #SS0_DOOR #STR
  )
  (StartUndoErr);// �R�}���h�̏�����

  ; ���ލX�V���K�v���ǂ������肷��
  (setq #flg nil)
  (setq #ss0_door (ssget "X" (list (cons 8 "0_door"))))
  (if (and #ss0_door (/= 0 (sslength #ss0_door)))
    (setq #flg T)
  );_if

  ; �}�ʂ̎c�[���폜
;;; (CFAlertMsg "�}�ʂ̎c�[���폜���܂�")
;;; (princ "�}�ʂ̎c�[���폜���܂�")
  (setq #layer$
    (list "0_door" "0_plane" "0_wall")
  )
  (setq #str "") ; �x����
  (foreach #layer #layer$
    (setq #ss (ssget "X" (list (cons 8 #layer))))
    (if (and #ss (/= 0 (sslength #ss)))
      (progn
        (setq #i 0)
        (repeat (sslength #ss)
          (setq #elm (ssname #ss #i))
          (if (entget #elm)
            (entdel #elm)
          );_if
          (setq #i (1+ #i))
        )
        (setq #str (strcat #str (itoa (sslength #ss)) "��" #layer "\n"))
      )
    );_if
  );foreach

  (if (/= #str "")
    (progn
      (setq #str (strcat #str "\n��w�̐}�`���폜���܂���"))
;;;     (CFAlertMsg #str)
      (princ #str)
    )
    (princ "\n�}�ʂɎc�[������܂���ł���")
  );_if

  (if #flg
    (progn
      (CFAlertMsg "\n�W�J�}�쐬�Ɏ��s�����c�[�����邽�߁A���ނ��Ĕz�u���܂�\n(���͑S�Ē��蒼���܂�)")
      (C:KPRefreshCAB) ; ���ލX�V�����
    )
  );_if

  (setq *error* nil)
;;; (princ "\n***********************")
;;; (princ "\n���}�ʂ̕��������I����")
;;; (princ "\n***********************")
  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : C:DELMEJI
; <�����T�v>  : ����قƂЂ����ĂȂ�G_MEJI���폜����
; <�߂�l>    :
; <�쐬>      : 02/03/04 YM
; <���l>      :
;*************************************************************************>MOH<
(defun C:DELMEJI (
  /
  #I #MEJI #N #SS #XDMEJI$ ; 02/09/04 YM ADD
  )
  (setq #SS (ssget "X" '((-3 ("G_MEJI" (1070 . 1))))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0 #n 0)
      (repeat (sslength #SS)
        (setq #MEJI (ssname #SS #i))
        (setq #xdMEJI$ (CFGetXData #MEJI "G_MEJI"))
        (if (= nil (SKD_GetGroupSymbole (entget #MEJI)))
          (progn
            (setq #n (1+ #n))
            (entdel #MEJI)
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  (princ)
);C:DELMEJI

;<HOM>*************************************************************************
; <�֐���>    : C:qq
; <�����T�v>  : ���݌����i�������p(�}�ʏ�̕i�Ԃ�NOTEPAD�ɏo��)
; <�߂�l>    :
; <�쐬>      : 02/04/03 YM
; <���l>      : ���݂�(0,0)�Ɋp�x=0�Ŕz�u���Ă���̂Ƃ���
;*************************************************************************>MOH<
(defun C:QQ (
  /
  #BASE$$ #FIL #GAS$$ #HINBAN #I #PT #RANGE$$ #SINK$$ #SS_LSYM #SUI$$ #SYM
  #WALL$$ #XD$ #ID #LR #XDLSYM$
  )
  ; file open
;;;  (setq #fil (open (strcat CG_SYSPATH "qq.txt") "W" ))
  (setq #fil (open (strcat CG_SYSPATH "qq.txt") "A" )) ; 02/04/16 YM MOD

  ; LSYM ����(�i��,����وʒu��ؽč쐬)
  (setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM"))))) ; G_LSYM �}�`�I���
  (if (and #ss_LSYM (< 0 (sslength #ss_LSYM)))
    (progn
      (setq #i 0)
      (setq #Base$$ nil #Wall$$ nil)
      (setq #Sink$$ nil #Gas$$  nil #Range$$ nil #Sui$$ nil)
      (repeat (sslength #ss_LSYM)
        (setq #sym (ssname #ss_LSYM #i))
        (setq #pt (cdr (assoc 10 (entget #sym))))   ; ����ٍ��W�ʒu
        (setq #xdLSYM$ (CFGetXData #sym "G_LSYM"))
        (setq #hinban (nth 5 #xdLSYM$))             ; �i��
        (setq #LR     (nth 6 #xdLSYM$))             ; L/R
        (setq #hinban (strcat #hinban "(" #LR ")"))
        (setq #ID     (nth 0 #xdLSYM$))             ; �}�`ID

        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB) ; ���i����1��
          (progn ; ����ȯ�
            (if (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS) ; ���i����2��
              (setq #Base$$ (append #Base$$ (list (list #hinban #ID #pt)))) ; �ް�
            );_if
            (if (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_UPP) ; ���i����2��
              (setq #Wall$$ (append #Wall$$ (list (list #hinban #ID #pt)))) ; �݌�
            );_if
          )
        );_if

        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_SNK) ; �ݸ
          (setq #Sink$$ (append #Sink$$ (list (list #hinban #ID #pt)))) ; �݌�
        );_if

        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_GAS) ; ���
          (setq #Gas$$ (append #Gas$$ (list (list #hinban #ID #pt)))) ; �݌�
        );_if

        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_RNG) ; ̰��
          (setq #Range$$ (append #Range$$ (list (list #hinban #ID #pt)))) ; �݌�
        );_if

        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_WTR) ; ����
          (setq #Sui$$ (append #Sui$$ (list (list #hinban #ID #pt)))) ; �݌�
        );_if

        (setq #i (1+ #i))
      )
    )
  );_if

  ;/////////////////////////////////////////////////////////////////////////////////
  ; ÷�ď����o��
  ;/////////////////////////////////////////////////////////////////////////////////
      (defun ##Write (
        &lis$$
        &str
        /

        )
        (if &lis$$
          (progn
            (princ &str #fil)
            (foreach #lis$ &lis$$
              (princ (strcat "\n " (car #lis$) " , " (cadr #lis$)) #fil) ; �i��,�}�`ID
            )
            (princ "\n" #fil)
          )
        );_if
        (princ)
      );##Write
  ;/////////////////////////////////////////////////////////////////////////////////
  ; ����ȯėp ÷�ď����o��
  ;/////////////////////////////////////////////////////////////////////////////////
      (defun ##WriteCab (
        &lis$$
        &str
        /
        #1$ #GAS$$ #LIS$$ #PT #SNK$$
        )
        (princ &str #fil)
        ; �ݸ��,��ۑ��ɕ�����
        (setq #snk$$ nil) ; �ݸ��
        (setq #gas$$ nil) ; ��ۑ�
        (foreach #lis$ &lis$$
          (setq #pt (caddr #lis$)) ; ����ٍ��W
          (if (equal (distance #pt '(0 0 0)) 0 0.001)
            (progn ; ��Ű
              (setq #1$ (list (list (car #lis$)(cadr #lis$)))) ; 1�Ԗ�(�i��,ID)
            )
            (progn
              (cond
                ((equal (cadr #pt) 0 0.001) ; Y=0
                   ; X���W,�i��,�}�`ID
                  (setq #snk$$ (append #snk$$ (list (list (car #lis$)(cadr #lis$)(car #pt)))))
                )
                ((equal (car #pt) 0 0.001)  ; X=0
                   ; Y���W,�i��,�}�`ID
                  (setq #gas$$ (append #gas$$ (list (list (car #lis$)(cadr #lis$)(cadr #pt)))))
                )
              );_cond
            )
          );_if
        );foreach

        ; ���W�����Ŀ�Ă���
        (setq #snk$$ (CFListSort #snk$$ 2)) ; (nth 2 �����������̏��ɿ��
        (setq #gas$$ (CFListSort #gas$$ 2)) ; (nth 2 �����������̏��ɿ��

        (setq #lis$$ (append #1$ #snk$$ #gas$$))
        (##Write #lis$$ "")

        (princ)
      );##WriteCab
  ;/////////////////////////////////////////////////////////////////////////////////
  (princ "\n************************************************" #fil)
  (if CG_TESTCASE ; 02/04/16 YM
    (princ (strcat "\nCASE = " (itoa CG_TESTCASE)) #fil)
    (princ "\n" #fil)
  )
  (princ "\n���i�Ԉꗗ��" #fil)
  (princ "\n" #fil)
  (##WriteCab #Base$$ "\n<�ް�����>")
  (##WriteCab #Wall$$ "\n<���ٷ���>")
  (##Write #Sink$$ "\n<�ݸ>")
  (princ "\n------------------------------------------------" #fil)
  (##Write #Gas$$ "\n<���>")
  (##Write #Range$$ "\n<̰��>")
  (##Write #Sui$$ "\n<����>")

  (close #fil)
;;; (startapp "notepad.exe" (strcat CG_SYSPATH "qq.txt"))

  (princ)
);C:QQ

(defun c:ccc( )
  (KChkZumenInfo)
  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : KCGetZumenInfo
; <�����T�v>  : �}�ʏ�̐}�`���ݏ󋵂��擾����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/04/22 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KCGetZumenInfo(
  /
  #EN #I #KOSU0 #LAYER #N1 #N10 #N11 #N12 #N2 #N3 #N4 #N5 #N6 #N7 #N8 #N9 #NAME #SS0
  )
;---�}�ʏ�̐}�`�����擾-----------------------------------------------------------------
  (setq #ss0 (ssget "X" ))
  (if (and #ss0 (< 0 (sslength #ss0)))
    (progn
      (setq #kosu0 (sslength #ss0))
      (princ "\n")
      (princ "\n�S�}�`�̌�= ")(princ #kosu0)
      (setq #i 0)
      (setq #n1 0 #n2 0 #n3 0 #n4 0 #n5 0 #n6 0 #n7 0 #n8 0 #n9 0 #n10 0 #n11 0 #n12 0)
      (repeat #kosu0
        (setq #en (ssname #ss0 #i))
        (setq #name  (cdr (assoc 0 (entget #en))))
        (setq #LAYER (cdr (assoc 8 (entget #en))))
        (cond
          ((= #name "LINE")       (setq #n1 (1+ #n1)))
          ((= #name "3DSOLID")    (setq #n2 (1+ #n2)))
          ((= #name "ARC")        (setq #n3 (1+ #n3)))
          ((= #name "SPLINE")     (setq #n4 (1+ #n4)))
          ((= #name "INSERT")
            (setq #n5 (1+ #n5))
            (princ (strcat "\n��w: " #LAYER))
          )
          ((= #name "ELLIPSE")    (setq #n6 (1+ #n6)))
          ((= #name "LWPOLYLINE") (setq #n7 (1+ #n7)))
          ((= #name "POINT")      (setq #n8 (1+ #n8)))
          ((= #name "CIRCLE")     (setq #n9 (1+ #n9)))
          ((= #name "DIMENSION")  (setq #n10 (1+ #n10)))
          ((= #name "VIEWPORT")   (setq #n11 (1+ #n11)))
          (T
            (princ (strcat "\n�}�`����: " #name))
            (setq #n12 (1+ #n12))
          )
        );_cond
        (setq #i (1+ #i))
      )
    )
  );_if

  (princ "\n------------------------------------")
  (princ (strcat "\nLINE:       " (itoa #n1)))
  (princ (strcat "\n3DSOLID:    " (itoa #n2)))
  (princ (strcat "\nARC:        " (itoa #n3)))
  (princ (strcat "\nSPLINE:     " (itoa #n4)))
  (princ (strcat "\nINSERT:     " (itoa #n5)))
  (princ (strcat "\nELLIPSE:    " (itoa #n6)))
  (princ (strcat "\nLWPOLYLINE: " (itoa #n7)))
  (princ (strcat "\nPOINT:      " (itoa #n8)))
  (princ (strcat "\nCIRCLE:     " (itoa #n9)))
  (princ (strcat "\nDIMENSION:  " (itoa #n10)))
  (princ (strcat "\nVIEWPORT:   " (itoa #n11)))
  (princ (strcat "\n���̑�:     " (itoa #n12)))
  (princ "\n------------------------------------")
  (princ (strcat "\n���v:       " (itoa (+ #n1 #n2 #n3 #n4 #n5 #n6 #n7 #n8 #n9 #n10 #n11 #n12))))
  (princ "\n------------------------------------")
  (princ "\n------------------------------------")
  (princ)
);KCGetZumenInfo

;<HOM>*************************************************************************
; <�֐���>    : KCEraseInsert
; <�����T�v>  : GSM���INSERT�}�`��S�č폜����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/04/22 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KCexplode(
  /
  #KOSU #SS
  )
  ; �}�`���ݏ󋵂��m�F
  (KCGetZumenInfo)
;-----------------------------------------------------------------------------------------------------
  (command "_layer" "U" "ASHADE" "") ; ���b�N����

  (setq #ss (ssget "X" (list (cons 0 "INSERT"))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #kosu (sslength #ss))
      (princ "\n")
      (princ "\nINSERT �̌�= ")(princ #kosu)
      (command "_erase" #ss "")
    )
  );_if

  (setq #ss (ssget "X" (list (cons 0 "INSERT"))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (princ "\n��INSERT �̎c��= ")
      (princ (sslength #ss))
    )
    (princ "\n��NSERT �Ȃ���")
  );_if
  (princ)
);KCexplode

;;;<HOM>*************************************************************************
;;; <�֐���>    : DELPMEN
;;; <�����T�v>  : �}�ʏ�ż���قɂЂ����Ă��Ȃ�PMEN2��S�č폜
;;;               �폜����PMEN����LSYM����\������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 02/05/22 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun DELPMEN (
  /
  #ELM #ENSS$ #I #SYM #KOSU #LSYM$ #HINBAN
  )
  (setq #enSS$ (ssget "X" '((-3 ("G_PMEN"))))) ; �}�ʏ�PMEN
  (setq #LSYM$ (ssget "X" '((-3 ("G_LSYM"))))) ; �}�ʏ�LSYM

  (if (and #enSS$ (< 0 (sslength #enSS$)))
    (progn
      (setq #i 0 #kosu 0)
      (repeat (sslength #enSS$)
        (setq #elm (ssname #enSS$ #i))             ; PMEN�}�`
        (setq #sym (CFSearchGroupSym #elm))        ; �e����ِ}�`
        (if (= #sym nil)
          (if (entget #elm)
            (progn
              (entdel #elm)
              (setq #kosu (1+ #kosu))
            )
          );_if
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (if (and #LSYM$ (< 0 (sslength #LSYM$)))
    (progn
      (CFAlertMsg (strcat (itoa (sslength #LSYM$)) "��LSYM�����݂��܂�"))
      (setq #i 0)
      (repeat (sslength #LSYM$)
        (setq #elm (ssname #LSYM$ #i))             ; PMEN�}�`
        (setq #hinban (nth 5 (CFGetXData #elm "G_LSYM")))
        (princ (strcat "\n" #hinban))
        (setq #i (1+ #i))
      )
    )
  );_if
  (CFAlertMsg (strcat (itoa #kosu) "��PMEN���폜���܂���\n(�}�ʏ��LSYM��ؽı���)"))
  (princ)
);DELPMEN

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:COMM01
;;; <�����T�v>  : WT����_��}������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 02/06/04 YM
;;; <���l>      : �J���җp
;;;*************************************************************************>MOH<
(defun C:COMM01 (
  /
  #I #WT #WTPT #WTSS$ #WTXD$ #LAST
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)
  (setvar "pickfirst" 1)

  (setq #wtSS$ (ssget "X" '((-3 ("G_WRKT"))))) ; �}�ʏ�WT
  (if (and #wtSS$ (< 0 (sslength #wtSS$)))
    (progn
      (setq #i 0)
      (repeat (sslength #wtSS$)
        (setq #WT (ssname #wtSS$ #i))          ; WT�}�`
        (setq #wtxd$ (CFGetXData #WT "G_WRKT"))
        ; ��đ��荶
        (setq #WTpt (nth 32 #wtxd$))           ; WT���_
        (command "._circle" #WTpt "50")        ; �~������
        (setq #last (entlast))
        (command "chprop" #last "" "C" "1" "") ; ��

        (command "._line" #WTpt "@100,100" "") ; ��������
        (setq #last (entlast))
        (command "chprop" #last "" "C" "1" "") ; ��
        (setq #i (1+ #i))
      )
    )
  );_if
  (princ)
);C:COMM01

;;;<HOM>************************************************************************
;;; <�֐���>  : C:COMM02
;;; <�����T�v>: PDF�o�͂���
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 02/08/07 YM
;;; <���l>    : �B������� Acrobat5.0Install���O��
;;;************************************************************************>MOH<
(defun C:COMM02  (
  /
  #limmin
  #limmax
  #AREA #CTB #DEVICE #EDIT #ELAYER #ELAYER$ #ILAYER #INI$$ #LAY #OFFX #OFFY #PAPER #RET$ #SCALE #YESNO
  )
  ; 119 01/04/08 HN S-ADD ��w"0_HIDE"�̔�\��������ǉ�
  (setq #eLayer (tblobjname "LAYER" "O_HIDE"))
  (if #eLayer
    (progn
      (setq #eLayer$ (entget #eLayer))
      (setq #iLayer (cdr (assoc 62 #eLayer$)))
      (if (< 0 #iLayer)
        (progn
          (setq #iLayer (* -1 #iLayer))
          (entmod (subst (cons 62 #iLayer) (assoc 62 #eLayer$) #eLayer$))
          (command ".REGEN")
        )
      )
    )
  )
  ; 119 01/04/08 HN E-ADD ��w"0_HIDE"�̔�\��������ǉ�

  (if (= nil (findfile (strcat CG_SYSPATH "SCPLOT.CFG")))
    (CFAlertErr "����ݒ�t�@�C�� <SCPLOT.CFG> ������܂���")
  )
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device "Acrobat Distiller") ;�o�̓f�o�C�X��(PDF)

  (setq #edit     (cadr (assoc "EDIT"  #ini$$)))    ;�G�f�B�^��

  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offx)(setq #offx "0.0"))

  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offy)(setq #offy "0.0"))

  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;����X�^�C���t�@�C����

  ;// �ȈՈ���_�C�A���O
  (setq #ret$ (SCPlainPlotDlg #device))

  (if (/= #ret$ nil)
    (progn
      (setq #paper (car #ret$))
      (setq #scale (cadr #ret$))
      (cond
        ((= #paper "paperA2")
          (setq #paper (cadr (assoc "PAPERA2" #ini$$)))
        )
        ((= #paper "paperA3")
          (setq #paper (cadr (assoc "PAPERA3" #ini$$)))
        )
        ((= #paper "paperA4")
         (setq #paper (cadr (assoc "PAPERA4" #ini$$)))
        )
        ((= #paper "paperB4")
         (setq #paper (cadr (assoc "PAPERB4" #ini$$)))
        )
      );_cond

      (cond
        ((= #scale "scale20")(setq #scale "1:20"))
        ((= #scale "scale30")(setq #scale "1:30"))
        ((= #scale "scale40")(setq #scale "1:40"))
        ((= #scale "scale1")(setq #scale "1:1"))
        (T (setq #scale "F"))
      );_cond

      (if (= 0 (getvar "TILEMODE"))
        (progn
          (setq #area "E")
          (setq #lay  "ڲ���1")
        )
        (progn
          (if (= #scale "F")
            (progn
              (setq #area "E")
              (setq #offx "0.0")
              (setq #offy "0.0")
            )
            (setq #area "E")
          );_if
          (setq #lay  "Model")
        )
      );_if

      (setq #YesNo
        (CFYesNoDialog
          (strcat
            "�o�̓f�o�C�X��: [" #device "]\n"
            "�p���T�C�Y�@�@�@: [" #paper  "]\n"
            "�k�ځ@�@�@�@�@�@�@: [" #scale  "]\n\n"
            "����ň�����Ă���낵���ł����H"
          )
        )
      )

      (if #YesNo ; 01/09/07 YM MOD
        (progn
          ; PLOT����ގ��s(PDF�o�͗p)
          (if (= (getvar "TILEMODE") 0)
            (progn ; �߰�߰��� PDF���޽�į�߂ɏo��
              ;;; S-ADD K.S Omajinai 2002/08/05
              (setq #limmin (getvar "LIMMIN"))
              (setq #limmax (getvar "LIMMAX"))
              (setvar "CLAYER" "0_WAKU")
              (if (= nil (member "rectang.arx" (arx)))
                (arxload "rectang.arx")
              )
              (command "_.RECTANGLE" #limmin #limmax)
              (setvar "CLAYER" "0")
              ;;; E-ADD by K.S Omajinai 2002/08/05
              (command "_.-PLOT"
                 "Y"           ;�ڍׂȈ�����ݒ�
                 #lay
                 #device       ;����f�o�C�X��
                 #paper        ;�p���T�C�Y(�e���v���[�g)
                 "M"           ;�p���P��
                 "L"           ;�}�ʂ̕���
                 "N"           ;�㉺�t���
                 #area         ;����̈� �}�ʔ͈�
                 #scale        ;�k��
                 (strcat #offx "," #offy)   ;����I�t�Z�b�g
                 "Y"           ;����X�^�C�����p�H
                 #ctb          ;����X�^�C����
                 "Y"           ;���̑������g�p�H
                 "N"           ;����ړx���g�p���Đ��̑������ړx�ύX?
                 "N"           ;�߰�߰��Ԃ��Ō�Ɉ��?
                 "Y"           ;�B������
                 "N"           ;�t�@�C�������o��
                 "N"           ;�ύX��ۑ�
                 "Y"           ;����𑱂���H
              );_command "_.-PLOT"
            ) ; �߰�߰���
        ; else
            (progn ; ���ً�� PDF���޽�į�߂ɏo��
              (command "_.-PLOT"
                 "Y"           ;�ڍׂȈ�����ݒ�
                 #lay
                 #device       ;����f�o�C�X��
                 #paper        ;�p���T�C�Y(�e���v���[�g)
                 "M"           ;�p���P��
                 "L"           ;�}�ʂ̕���
                 "N"           ;�㉺�t���
                 #area         ;����̈� �}�ʔ͈�
                 #scale        ;�k��
                 (strcat #offx "," #offy)   ;����I�t�Z�b�g
                 "Y"           ;����X�^�C�����p�H
                 #ctb          ;����X�^�C����
                 "Y"           ;���̑������g�p�H
                 "Y"           ;�B������
                 "N"           ;�t�@�C�������o��
                 "N"           ;�ύX��ۑ�
                 "Y"           ;����𑱂���H
              );_command "_.-PLOT"

            ) ; ���ً��
          );_if
        )
      );_if
    )
  );_if
  (princ)
);C:COMM02

;;;<HOM>************************************************************************
;;; <�֐���>  : C:COMM03
;;; <�����T�v>: �v���[���p�Ƀp�[�X��JPEG�ɏo�͂���
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 03/01/28 YM
;;; <���l>    :
;;;************************************************************************>MOH<
(defun C:COMM03  (
  /
  #SFNAME
  )

  ;// �R�}���h�̏�����
  (StartUndoReOpenModelErr) ;06/07/24 T.Ari MOD �p�[�X�L�����Z���G���[�Ή�

  ; �}�ʎQ��
  (setq #sFName (strcat CG_KENMEI_PATH "Block\\M_0.dwg"))
  (if (= nil (findfile #sFName))
    (progn
      (CFAlertMsg (strcat "�p�[�X������܂���\n�W�J�}�쐬(�ꊇ)���s���Ă�������"))
      (quit)
    )
    (progn

      (command ".qsave")
      (command "_.Open"     #sFName)
      (setq CG_OpenMode 9)
      (S::STARTUP)

    )
  );_if

  (setq *error* nil)
  (princ)
);C:COMM03

;;;<HOM>************************************************************************
;;; <�֐���>  : COMM03sub
;;; <�����T�v>: �v���[���p�Ƀp�[�X��JPEG�ɏo�͂���
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 03/01/28 YM
;;; <���l>    :
;;;************************************************************************>MOH<
(defun COMM03sub  (
  /
  #AREA #CTB #DEVICE #INI$$ #LAY #OFFX #OFFY #OUTPUT #PAPER #SCALE #SFNAME
  )
;;;WebTIFF_OUTPUT
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE2"  #ini$$))) ;�o�̓f�o�C�X��
  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offx)(setq #offx "0.0"))
  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offy)(setq #offy "0.0"))
  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;����X�^�C���t�@�C����
  (setq #paper    (cadr (assoc "SIZE"    #ini$$)))  ;�s�N�Z��
  (setq #scale "F")
  (setq #area  "D") ; �}�ʔ͈�
  (setq #lay  "Model")

  (setvar "DISPSILH" 1)                     ;�V���G�b�gON
  (command "_.ZOOM" "E")

  (princ "\n�����̒������s���ĉ������B")
  (princ "\n")
  (SKChgView "2,-2,1")  ; �E���� ���_�쓌
  (command "_3DORBIT")

;;;  (command "_.VPOINT" "R" "" 8)
;;; (command "_.DVIEW" "ALL" "" "D" 7500 "X") ;�p�[�X�}�ɐ؂�ւ�

  ; 3Dorbit

  ; �o��̧�ٖ� �Œ�
  (if (= CG_AUTOMODE 1);(�����ݸ޼�Ď��s�� 04/09/13 YM MOD)
    (progn
      (setq #output (strcat CG_KENMEI_PATH "BLOCK" "\\PERS.jpg"))
      (if (findfile #output)(vl-file-delete #output))
    )
    (progn
      (setq #output (getfiled "���O��t���ĕۑ�" (strcat CG_KENMEI_PATH "BLOCK\\") "jpg" 1))
      ;04/08/26 YM ADD ����̫���\block ����ύX�������հ�ް�Ɋm�F����
      (setq #flg nil) ; ����̫���\block�̂Ƃ�'T
      (if (wcmatch (strcase #output) (strcase (strcat CG_KENMEI_PATH "BLOCK\\*")) )
        (progn ; �����p�X���܂�ł���
          ;�����߽�������폜
          (setq #dum_path (vl-string-subst "" (strcase (strcat CG_KENMEI_PATH "BLOCK\\")) (strcase #output) ))
          (if (vl-string-search "\\" #dum_path)
            (setq #flg T) ;���ɊK�w���܂�ł���
            ;else
            (setq #flg nil) ;���ɊK�w���܂�ł��Ȃ�
          );_if
        )
        ;else
        (setq #flg T)
      );_if

      (if #flg
        (progn ;����̫��ނƈႤ�ꍇ�͌x����\������
          (CFAlertMsg "�v���[���{�[�h�쐬�@�\���g�p����ꍇ�͕ۑ��ꏊ(\block)��ύX���Ȃ��ł�������")
        )
      );_if
    )
  );_if

  (if #output
    (progn
      ; PLOT����ގ��s(TIFF,JPEG�o�͗p)
      (command "_.-PLOT"
         "Y"           ;�ڍׂȈ�����ݒ�
         #lay
         #device       ;����f�o�C�X��
         #paper        ;�p���T�C�Y(�e���v���[�g)
         "L"           ;�}�ʂ̕���
         "N"           ;�㉺�t���
         #area         ;����̈� �}�ʔ͈�
         #scale        ;�k��
         (strcat #offx "," #offy)   ;����I�t�Z�b�g
         "Y"           ;����X�^�C�����p�H
         #ctb          ;����X�^�C����
         "Y"           ;���̑������g�p�H
         "Y"           ;�B������
    ;;;   (strcat CG_PDFOUTPUTPATH CG_BukkenNo "_DRW1.Tif")
        #output
         "N"           ;�ύX��ۑ�
         "Y"           ;����𑱂���H
      );_command "_.-PLOT"
    )
  );_if
  ; ������I�����Ƃ̐}�ʂɖ߂�
  (setq CG_OpenMode 0)
  (setq #sFname (strcat CG_KENMEI_PATH "MODEL.dwg"))
  (SCFCmnFileOpen #sFName 1)

  ; �o�͐�̕\��
  (if (= CG_AUTOMODE 1);(�����ݸ޼�Ď��s�� 04/09/13 YM MOD)
    (progn
      (command ".qsave");save
      nil ; �����\�����Ȃ�
    )
    (progn
      (CFYesDialog (strcat #output "\n�ɏo�͂��܂���"))
    )
  );_if

  (princ)
);COMM03sub



;;;<HOM>************************************************************************
;;; <�֐���>  : JPG-OUTPUT
;;; <�����T�v>: �����ݸ޼�Ď����߰���JPEG�ɏo�͂���
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 04/09/13 YM
;;; <���l>    :
;;;************************************************************************>MOH<
(defun JPG-OUTPUT  (
  /
  #SFNAME
  )
  ; �}�ʎQ��
  (setq #sFName (strcat CG_KENMEI_PATH "Block\\M_0.dwg"))
  (if (= nil (findfile #sFName))
    (progn
      (CFAlertMsg (strcat "�p�[�X������܂���\n�W�J�}�쐬(�ꊇ)���s���Ă�������"))
      (quit)
    )
    (progn
      (command ".qsave")
      (command "_.Open"     #sFName)
      (setq CG_OpenMode 99)
      (S::STARTUP)
    )
  );_if
  (princ)
);JPG-OUTPUT

;;;<HOM>************************************************************************
;;; <�֐���>  : JPG-OUTPUT_sub
;;; <�����T�v>: �����ݸ޼�Ď����߰���JPEG�ɏo�͂���
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 04/09/13 YM
;;; <���l>    :
;;;************************************************************************>MOH<
(defun JPG-OUTPUT_sub  (
  /
  #SFNAME #AREA #CTB #DEVICE #INI$$ #LAY #OFFX #OFFY #OUTPUT #PAPER #SCALE
  )

;;;WebTIFF_OUTPUT
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE2"  #ini$$))) ;�o�̓f�o�C�X��
  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offx)(setq #offx "0.0"))
  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offy)(setq #offy "0.0"))
  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;����X�^�C���t�@�C����
  (setq #paper    (cadr (assoc "SIZE"    #ini$$)))  ;�s�N�Z��
  (setq #scale "F")
  (setq #area  "D") ; �}�ʔ͈�
  (setq #lay  "Model")

  (setvar "DISPSILH" 1)                     ;�V���G�b�gON
  (command "_.ZOOM" "E")

  (princ "\n�����̒������s���ĉ������B")
  (princ "\n")
  (SKChgView "2,-2,1")  ; �E���� ���_�쓌
  (command "_3DORBIT")

;;;  (command "_.VPOINT" "R" "" 8)
;;; (command "_.DVIEW" "ALL" "" "D" 7500 "X") ;�p�[�X�}�ɐ؂�ւ�

  ; 3Dorbit
  (setq #output (strcat CG_KENMEI_PATH "BLOCK" "\\PERS.jpg"))
  (if (findfile #output)(vl-file-delete #output))
  (if #output
    (progn
      ; PLOT����ގ��s(TIFF,JPEG�o�͗p)
      (command "_.-PLOT"
         "Y"           ;�ڍׂȈ�����ݒ�
         #lay
         #device       ;����f�o�C�X��
         #paper        ;�p���T�C�Y(�e���v���[�g)
         "L"           ;�}�ʂ̕���
         "N"           ;�㉺�t���
         #area         ;����̈� �}�ʔ͈�
         #scale        ;�k��
         (strcat #offx "," #offy)   ;����I�t�Z�b�g
         "Y"           ;����X�^�C�����p�H
         #ctb          ;����X�^�C����
         "Y"           ;���̑������g�p�H
         "Y"           ;�B������
    ;;;   (strcat CG_PDFOUTPUTPATH CG_BukkenNo "_DRW1.Tif")
        #output
         "N"           ;�ύX��ۑ�
         "Y"           ;����𑱂���H
      );_command "_.-PLOT"
    )
  );_if

  ; ������I�����Ƃ̐}�ʂɖ߂�
  (setq CG_OpenMode 0)
  (setq #sFname (strcat CG_KENMEI_PATH "MODEL.dwg"))
  (SCFCmnFileOpen #sFName 1)

  (command ".qsave")
  (princ)
);JPG-OUTPUT_sub



;;;<HOM>*************************************************************************
;;; <�֐���>    : C:mktpt
;;; <�����T�v>  : ����ڰĂ�POINT��}����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 02/06/04 YM
;;; <���l>      : �J���җp ��޼ު�Ĕ͈͂ŊȈՈ������ƑS�̂������Ɋ�邽��
;;;               '(0 0)��POINT����}���đS�̓I�ɒ��S�Ɋ�炷(A3)
;;;               ������A4�̏ꍇ(200 140)�ɍ�}���Ȃ��Ɨp������͂ݏo��
;;;               �߰�A4�̂Ƃ���(200/30 140/30)=(6.7 4.7)�̈ʒu�ɍ�}����
;;;*************************************************************************>MOH<
(defun C:mktpt (
  /

  )
;;; (setq #limmax (getvar "LIMMAX"))
  (setvar "PDMODE" 34)
  (setvar "CLAYER" "0_waku")
  ; ��}
;;; (command "._POINT" '(200 140)) ; A4 Template�p(���̈ȊO)
;;; (command "._POINT" '(0 0)) ; A3 Template�p(���̈ȊO)
;;; (command "._POINT" #limmax)
;;; (command "._POINT" '(12300 8610)) ; A3 Template�p(���̈ȊO)
  (command "._POINT" '(6.7 4.7)) ; A4 Template�p(����)

  (setvar "PDMODE" 0)

  ; "0_waku"��\��
  (command "_-layer" "of" "0_waku" "")
  ; ���݉�w"0"
  (setvar "CLAYER" "0")
  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : KP_DelHinbanKakko
; <�����T�v>  : ������=�i��(*)�̂���(*)�����������������̂�Ԃ�
; <�߂�l>    : ������
; <�쐬>      : 01/12/03 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KP_DelHinbanKakko (
  &str ; ������
  /
  #I #LOOP #NO_E #NO_S #RET #RET1 #RET2
  )
  (setq #i 1 #loop T)
  (setq #no_S nil #no_E nil)
  (while (< #i (1+ (strlen &str)))
    (if (= (substr &str #i 1) "(")(setq #no_S #i)) ; ( �̈ʒu
    (if (= (substr &str #i 1) ")")(setq #no_E #i)) ; ) �̈ʒu
    (setq #i (1+ #i))
  )
  (if (and #no_S #no_E)
    (progn
      (setq #ret1 (substr &str 1 (1- #no_S))) ; ( �̒��O�܂�
      (setq #ret2 (substr &str (1+ #no_E) (strlen &str))) ; ) �̒���`�Ō�܂�
      (setq #ret (strcat #ret1 #ret2))
    )
    (setq #ret &str) ; ()���Ȃ��ꍇ
  );_if
  #ret
);KP_DelHinbanKakko

;<HOM>*************************************************************************
; <�֐���>    : KP_DelDrSeriStr
; <�����T�v>  : ������=�i��[S:AA]�̂���[*]�����������������̂�Ԃ�
; <�߂�l>    : ������
; <�쐬>      : 01/10/10 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KP_DelDrSeriStr (
  &str ; ������
  /
  #I #LOOP #NO #RET #F1 #F2 #F3 #FLG
  )
  ;�����񔻒� 03/08/22 YM ADD-S
  (setq #f1 (vl-string-search "[" &str))
  (setq #f2 (vl-string-search ":" &str))
  (setq #f3 (vl-string-search "]" &str))
  (if (and #f1 #f2 #f3)
    (setq #flg   T)
    (setq #flg nil)
  );_if
  ;�����񔻒� 03/08/22 YM ADD-E

  (if #flg ;�����񔻒� 03/08/22 YM ADD
    (progn
      (setq #i 1 #loop T)
      (setq #no nil)
      (while (and #loop (< #i (1+ (strlen &str))))
        (if (= (substr &str #i 1) "[")
          (progn
            (setq #no #i)
            (setq #loop nil)
          )
        );_if
        (setq #i (1+ #i))
      )
      (if #no
        (setq #ret (substr &str 1 (1- #no)))
        (setq #ret &str)
      );_if
    )
    (progn
      (setq #ret &str)
    )
  );_if

  #ret
);KP_DelDrSeriStr


;<HOM>*************************************************************************
; <�֐���>    : KP_GetSeriStr
; <�����T�v>  : ������=�i��[SS:AA:BB]�ɑ΂���(list SS AA BB)��Ԃ�
; <�߂�l>    : (list SS AA BB) or nil([]���Ȃ��Ƃ�)
; <�쐬>      : 11/04/23 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KP_GetSeriStr (
  &str ; ������
  /
  #F1 #F2 #F3 #FLG #STR #STR$
  )
  ;�����񔻒�
  (setq #f1 (vl-string-search "[" &str))
  (setq #f2 (vl-string-search ":" &str))
  (setq #f3 (vl-string-search "]" &str))
  (if (and #f1 #f2 #f3)
    (setq #flg   T)
    (setq #flg nil)
  );_if

  (if #flg
    (progn
      ;[=14 ]=21
      (setq #str (substr &str (+ #f1 2) (- #f3 #f1 1)))
      (setq #str$ (strparse #str ":"))
    )
    (progn
      (setq #str$ nil);nil��Ԃ�
    )
  );_if

  #str$
);KP_GetSeriStr


;<HOM>*************************************************************************
; <�֐���>    : KP_DelDrSeri
; <�����T�v>  : �i�ԕ�����[S:AG]�̕�����"��װ"�Ƃ���(KPCAD,NSCAD�d�l)
; <�߂�l>    : ��L�ύX�ς�ؽ�
; <�쐬>      : 01/10/30 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KP_DelDrSeri (
  &lis$ ; LIST
  &flg ; 1:[]������""(�Ȃ�) , 2:�i��+" "+��װ  �����ǉ� 01/10/31 YM ADD
  /
  #HIN #NO1 #NO2 #NO3 #RET #RET$ #STR
  )

  (setq #ret$ nil)
  (foreach #lis &lis$
    (setq #str (nth 1 #lis)) ; �i�Ԗ���
    (setq #hin (KP_DelDrSeri_sub #str &flg))
    (setq #ret
      (CFModList #lis
        (list
          (list 1 #hin) ; nth 1 ������ #hin �ɕύX
        )
      )
    )
    (setq #ret$ (append #ret$ (list #ret)))
  );foreach

  #ret$
);KP_DelDrSeri

;<HOM>*************************************************************************
; <�֐���>    : KP_DelDrSeri_sub
; <�����T�v>  : �i�ԕ�����[S:AG]�̕�����"��װ"�Ƃ���(KPCAD,NSCAD�d�l)
; <�߂�l>    : ��L�ύX�ςݕ�����
; <�쐬>      : 02/11/30 YM ��
; <���l>      :  SX�Ή� [P_:XPD:PD2]������݂���
;*************************************************************************>MOH<
(defun KP_DelDrSeri_sub (
  &str ; ������
  &flg ; 1:�i��+L/R []�����폜 , 2:�i��+" "+��װ  �����ǉ� 01/10/31 YM ADD
  /
  #HIN #NO1 #NO2 #NO3 #STR
#DOORKIGO #DRCOL #DRHANDLE #DRINFO #DRINFO$ ; 02/12/07 YM ADD
  )
  (setq #no1 (vl-string-search "[" &str)) ; "[" �����Ԗڂ� or nil �擪=0
  (setq #no2 (vl-string-search "]" &str)) ; "[" �����Ԗڂ� or nil �擪=0

  (if (and #no1 #no2)
    (progn

      (cond
        ((= &flg 1) ; ����&flg�ǉ� 01/10/31 YM ADD
          (setq #hin
            (strcat
              (substr &str 1 #no1) ; ���̕i�ԕ����̂�
              (substr &str (+ #no2 2)(- (strlen &str) (+ #no2 1))) ; LR
            )
          )
        )
        ((= &flg 2) ; ����&flg�ǉ� 01/10/31 YM ADD
          ; []�����̒��g������� [,]�͊܂܂Ȃ�
          (setq #DrInfo (substr &str (+ #no1 2) (- #no2 #no1 1)))
          ; ":"�ŕ�����ؽĉ�����
          (setq #DrInfo$ (StrtoLisByBrk #DrInfo ":"))
          (setq #DrCol    (cadr  #DrInfo$))
          (setq #DrHandle (caddr #DrInfo$))
          (if (= nil #DrHandle)
            (setq #DoorKIGO #DrCol) ; ���F
          ; else
            (setq #DoorKIGO #DrHandle) ; ���
          );_if

          (setq #hin ; �i��+" "+��װ
            (strcat
              (substr &str 1 #no1) ; ���̕i�ԕ����̂�
              ; 01/10/30 YM ��װ�ǉ� KPCAD,NSCAD�d�l
              " " ; ��߰��ǉ�
              #DoorKIGO ; ��װ or ��蕔��
              ; 01/10/29 YM LR�s�v
;;;01/10/29YM@DEL         (substr &str (1+ #no3)(- (strlen &str) #no3)) ; LR
            )
          )
        )
        (T
          (setq #hin (substr &str 1 (1- #no1))) ; ���̕i�ԕ����̂�
        )
      );_cond

    )
    (setq #hin &str) ; ���̂܂�
  );_if

  #hin
);KP_DelDrSeri_sub

;;;02/11/30YM@DEL;<HOM>*************************************************************************
;;;02/11/30YM@DEL; <�֐���>    : KP_DelDrSeri_sub
;;;02/11/30YM@DEL; <�����T�v>  : �i�ԕ�����[S:AG]�̕�����"��װ"�Ƃ���(KPCAD,NSCAD�d�l)
;;;02/11/30YM@DEL; <�߂�l>    : ��L�ύX�ςݕ�����
;;;02/11/30YM@DEL; <�쐬>      : 01/10/31 YM
;;;02/11/30YM@DEL; <���l>      :
;;;02/11/30YM@DEL;*************************************************************************>MOH<
;;;02/11/30YM@DEL(defun KP_DelDrSeri_sub (
;;;02/11/30YM@DEL  &str ; ������
;;;02/11/30YM@DEL &flg ; 1:�i��+L/R , 2:�i��+" "+��װ  �����ǉ� 01/10/31 YM ADD
;;;02/11/30YM@DEL  /
;;;02/11/30YM@DEL #HIN #NO1 #NO2 #NO3 #STR
;;;02/11/30YM@DEL  )
;;;02/11/30YM@DEL
;;;02/11/30YM@DEL   ;/////////////////////////////////////////////////////////////////////////
;;;02/11/30YM@DEL   ; &obj �� &str �̉��Ԃ߂�.�Ȃ����nil��Ԃ�
;;;02/11/30YM@DEL   (defun ##GetIndex (
;;;02/11/30YM@DEL     &str ; STR
;;;02/11/30YM@DEL     &obj ; �Ώە���
;;;02/11/30YM@DEL     /
;;;02/11/30YM@DEL     #I #LOOP #NO #STR
;;;02/11/30YM@DEL     )
;;;02/11/30YM@DEL     (setq #no nil) ; "[" �����Ԗڂ�
;;;02/11/30YM@DEL     (setq #i 1 #loop T)
;;;02/11/30YM@DEL     (while (and #loop (< #i (1+ (strlen &str))))
;;;02/11/30YM@DEL       (if (= (substr &str #i 1) &obj)
;;;02/11/30YM@DEL         (progn
;;;02/11/30YM@DEL           (setq #no #i)
;;;02/11/30YM@DEL           (setq #loop nil)
;;;02/11/30YM@DEL         )
;;;02/11/30YM@DEL       );_if
;;;02/11/30YM@DEL       (setq #i (1+ #i))
;;;02/11/30YM@DEL     )
;;;02/11/30YM@DEL     #no
;;;02/11/30YM@DEL   );##GetIndex
;;;02/11/30YM@DEL   ;/////////////////////////////////////////////////////////////////////////
;;;02/11/30YM@DEL
;;;02/11/30YM@DEL (setq #no1 (##GetIndex &str "[")) ; "[" �����Ԗڂ�
;;;02/11/30YM@DEL (setq #no2 (##GetIndex &str ":")) ; ":" �����Ԗڂ�
;;;02/11/30YM@DEL (setq #no3 (##GetIndex &str "]")) ; "]" �����Ԗڂ�
;;;02/11/30YM@DEL (if (and #no1 #no2 #no3)
;;;02/11/30YM@DEL   (progn
;;;02/11/30YM@DEL
;;;02/11/30YM@DEL     (cond
;;;02/11/30YM@DEL       ((= &flg 1) ; ����&flg�ǉ� 01/10/31 YM ADD
;;;02/11/30YM@DEL         (setq #hin
;;;02/11/30YM@DEL           (strcat
;;;02/11/30YM@DEL             (substr &str 1 (1- #no1)) ; ���̕i�ԕ����̂�
;;;02/11/30YM@DEL             (substr &str (1+ #no3)(- (strlen &str) #no3)) ; LR
;;;02/11/30YM@DEL           )
;;;02/11/30YM@DEL         )
;;;02/11/30YM@DEL       )
;;;02/11/30YM@DEL       ((= &flg 2) ; ����&flg�ǉ� 01/10/31 YM ADD
;;;02/11/30YM@DEL         (setq #hin ; �i��+" "+��װ
;;;02/11/30YM@DEL           (strcat
;;;02/11/30YM@DEL             (substr &str 1 (1- #no1)) ; ���̕i�ԕ���
;;;02/11/30YM@DEL             ; 01/10/30 YM ��װ�ǉ� KPCAD,NSCAD�d�l
;;;02/11/30YM@DEL             " " ; ��߰��ǉ�???
;;;02/11/30YM@DEL             (substr &str (1+ #no2)(- #no3 #no2 1)) ; ��װ���� @@@
;;;02/11/30YM@DEL             ; 01/10/29 YM LR�s�v
;;;02/11/30YM@DEL;;;01/10/29YM@DEL          (substr &str (1+ #no3)(- (strlen &str) #no3)) ; LR
;;;02/11/30YM@DEL           )
;;;02/11/30YM@DEL         )
;;;02/11/30YM@DEL       )
;;;02/11/30YM@DEL       (T
;;;02/11/30YM@DEL         (setq #hin (substr &str 1 (1- #no1))) ; ���̕i�ԕ����̂�
;;;02/11/30YM@DEL       )
;;;02/11/30YM@DEL     );_cond
;;;02/11/30YM@DEL
;;;02/11/30YM@DEL   )
;;;02/11/30YM@DEL   (setq #hin &str) ; ���̂܂�
;;;02/11/30YM@DEL );_if
;;;02/11/30YM@DEL
;;;02/11/30YM@DEL #hin
;;;02/11/30YM@DEL);KP_DelDrSeri_sub

;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_DELSTR
;;; <�����T�v>  : �i�ԕ����񂩂�����̕������폜����
;;; <�߂�l>    :
;;; <�쐬>      : 02/08/24 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun CMN_DELSTR (
  &string ; ������
  &str    ; �폜����(1����)
  /
  #I #RET #S
  )
  (setq #ret "") ; �߂�l
  (if &string
    (progn
      (setq #i 1)
      (repeat (strlen &string)
        (setq #s (substr &string #i 1))
        (if (= #s &str)
          nil
        ;else
          (setq #ret (strcat #ret #s))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CMN_DELSTR

;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_GetNumStr
;;; <�����T�v>  : ������̐��������݂̂�������
;;;               (��) "XM*IBPD-255TR"--->"255"
;;; <�߂�l>    : ������ or ""
;;; <�쐬>      : 02/11/27 YM
;;; <���l>      : ���������������ӏ����邱�Ƃ�z�肵�Ă��Ȃ�
;;;               (��)�̂悤�Ɉ�ӏ��ɘA�����Ă��邱�Ƃ�z��
;;;*************************************************************************>MOH<
(defun CMN_GetNumStr (
  &str ; ������
  /
  #DUM #I #RET #STR
  )
  (setq #ret "")
  (if (= 'STR (type &str))
    (progn
      (setq #i 1)
      (repeat (strlen &str)
        (setq #str (substr &str #i 1))
        (if (= 'INT (type (read #str)))
          (setq #ret (strcat #ret #str))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CMN_GetNumStr

;;;<HOM>*************************************************************************
;;; <�֐���>    : CMN_string-subst
;;; <�����T�v>  : ������(&string)�̕���(&str_old)�𕶎�(&str_new)�ɕύX����
;;; <�߂�l>    :
;;; <�쐬>      : 02/11/30 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun CMN_string-subst (
  &str_old ; ����(1����)
  &str_new ; ����(1����)
  &string  ; ������
  /
  #I #RET #S
  )
  (setq #ret "") ; �߂�l
  (if (= 'STR (type &string))
    (progn
      (setq #i 1)
      (repeat (strlen &string)
        (setq #s (substr &string #i 1))
        (if (= #s &str_old)
          (setq #ret (strcat #ret &str_new))
        ;else
          (setq #ret (strcat #ret #s))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CMN_string-subst

;;;<HOM>*************************************************************************
;;; <�֐���>    : CheckCFG
;;; <�����T�v>  : ������(&string)�̕���(&str_old)�𕶎�(&str_new)�ɕύX����
;;; <�߂�l>    :
;;; <�쐬>      : 02/11/30 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun CheckCFG (
  /
  #5 #CFG$ #CFG_DWG-HIN #CFG_DWG-HIN$ #DWG$ #DWG-HIN #ERR$ #HINBAN #I #ID #IFILE #LIST$$ #OK$$
  #DATE_TIME #FIL #NIL$ #CSV$$ #DUM$ #DUM$$ #ERR$$ #KFILE #NIL$$
  )

  (setq #fil (open (strcat CG_SYSPATH "����.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n" #fil)

  ; ���ʉ��i.xls
  (setq #kfile (strcat CG_SKDATAPATH "CFG-ch\\����.csv"))
  (setq #CSV$$ (ReadCSVFile #kfile))
  ; �A�zؽĂɂ���
  (setq #dum$$ nil)
  (foreach #CSV$ #CSV$$
    (setq #dum$ (cons (nth 0 #CSV$)(nth 1 #CSV$)))
    (setq #dum$$ (append #dum$$ (list #dum$)))
  )
  (setq #CSV$$ #dum$$)
  (princ "\nM_�����i.xls �o�^��= " #fil)(princ (length #CSV$$) #fil)

  ; CFG�ȉ���̧��
  (setq #CFG$ (vl-directory-files (strcat CG_SKDATAPATH "CFG\\") "*.cfg"))

  ; CFG�̐}�`ID�ƕi�Ԃ̈ꗗ
  (setq #CFG_dwg-hin$ nil)
  (foreach CFG #CFG$
    (if (= (strlen CFG) 9)
      (progn
        (setq #5 (substr CFG 1 5))
        (setq #ifile (strcat CG_SKDATAPATH "CFG-ch\\" CFG))
        (setq #List$$ (ReadCSVFile #ifile)) ; CFG�̒��g
        (foreach #List$ #List$$
          (setq #CFG_dwg-hin (cons (strcat #5 (car #List$)) (cadr #List$)))
          (setq #CFG_dwg-hin$ (append #CFG_dwg-hin$ (list #CFG_dwg-hin)))
        )
      )
    );_if
  )

  ; MASTER�ȉ���̧��
  (setq #dwg$ (vl-directory-files CG_MSTDWGPATH "*.dwg"))
  (princ "\nMASTER DWG ��= " #fil)(princ (length #dwg$) #fil)

  (setq #i 1)
  (setq #err$$ nil)   ; DWG�͂���̂�CFG����
  (setq #nil$$ nil)   ; DWG�͂���̂�CFG����
  (setq #OK$$ nil)    ; ����
  (foreach dwg #dwg$  ; �eDWG�ɑ΂���CFG�̕i�Ԃ���������
    (setq #ID (substr dwg 1 7))
    (setq #hinban (cdr (assoc #ID #CFG_dwg-hin$)))
    (cond
      ((= #hinban nil) ; DWG�͂���̂�CFG��Level1�ŋ�
        ; M_�����i.xls ����i�Ԃ��擾
        (setq #hinban (cdr (assoc #ID #CSV$$)))
        (if (= nil #hinban)(setq #hinban "���H"))
        (setq #nil$$ (append #nil$$ (list (list dwg #hinban))))
      )
      ((= #hinban "") ; DWG�͂���̂�CFG��Level2�ŋ�
        ; M_�����i.xls ����i�Ԃ��擾
        (setq #hinban (cdr (assoc #ID #CSV$$)))
        (if (= nil #hinban)(setq #hinban "���H"))
        (setq #err$$ (append #err$$ (list (list dwg #hinban))))
      )
      (progn ; ����
        (setq #OK$$ (append #OK$$ (list (list dwg #hinban))))
      )
    );_if
    (if (= (rem #i 10) 0)
      (princ (strcat "\n" (itoa #i)))
    );_if
    (setq #i (1+ #i))
  )

  (princ "\n----------------------------------" #fil)
  (princ "\n�}�`ID�ꗗ" #fil)
  (princ "\n��DWG�͂���̂�CFG��Level1�ŋ󔒁�" #fil)
  (princ "\n----------------------------------" #fil)

  (foreach #nil$ #nil$$
    (if (= nil (cadr #nil$))
      (princ)
    )
    (princ (strcat "\n" (car #nil$) "," (cadr #nil$)) #fil)
  )

  (princ "\n----------------------------------" #fil)
  (princ "\n�}�`ID�ꗗ" #fil)
  (princ "\n��DWG�͂���̂�CFG��Level2�ŋ󔒁�" #fil)
  (princ "\n----------------------------------" #fil)

  (foreach #err$ #err$$
    (if (= nil (cadr #err$))
      (princ)
    )
    (princ (strcat "\n" (car #err$) "," (cadr #err$)) #fil)
  )
  (princ "\n" #fil)

  (princ "\n----------------------------------" #fil)
  (princ "\n�}�`ID�ꗗ" #fil)
  (princ "\n�����큚" #fil)
  (princ "\n----------------------------------" #fil)

  (foreach #OK$ #OK$$
    (if (= nil (cadr #OK$))
      (princ)
    )
    (princ (strcat "\n" (car #OK$) "," (cadr #OK$)) #fil)
  )

  (startapp "notepad.exe" (strcat CG_SYSPATH "����.txt"))
  (princ)
);CheckCFG


; ////////// ����ݽ�p°� 2003.4.24 YM ADD

;*****************************************************************************:
; �����Ǘ�,�����\���e�[�u���쐬�c�[��(��ۑI����)
; �g�p�ꏊ: CG_SYSPATH \DATA
; 02/01/21 YM
; ��ۑI����÷��̧��,�����Ǘ�,�����\���̐��`CSV̧�َg�p
;*****************************************************************************:
(defun C:GAS (
  /
  #DUM$ #FP1 #FP2 #GAS #GAS_NAME #HINBAN #HUKU_ID #ID$ #IFNAME1 #IFNAME2 #IFNAME3
  #J #K #KIGO #KIGO$ #LIST1$$ #LIST2$$ #LIST3$$ #NEWLIST$ #NEWLIST1$$ #NEWLIST2$
  #NEWLIST2$$ #OFNAME1 #OFNAME2 #PTN #RECNO #GAS-LR #LR
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)

    ;/////////////////////////////////////////////////////////////////
    ; ������5���̕�����ɕϊ����� ��: 9��"00009",12��"00012"
    (defun ##Int5keta (
      &int ; ����
      /
      #ret
      )
      (cond
        ((< &int 10   )(setq #ret (strcat "0000" (itoa &int))))
        ((< &int 100  )(setq #ret (strcat "000"  (itoa &int))))
        ((< &int 1000 )(setq #ret (strcat "00"   (itoa &int))))
        ((< &int 10000)(setq #ret (strcat "0"    (itoa &int))))
        (T             (setq #ret (strcat ""     (itoa &int))))
      );_cond
      #ret
    )
    ;/////////////////////////////////////////////////////////////////
    (defun ##OUTPUT (
      &LIS$$ ; �o��ؽ�
      &fp    ; ̧�َ��ʎq
      /
      #I #N
      )
      (setq #n 1)
      (foreach #NewList$ &LIS$$
        (setq #i 1)
        (foreach #NewList #NewList$
          (if (= #i 1)
            (princ #NewList &fp)
            (princ (strcat "," #NewList) &fp)
          );_if
          (setq #i (1+ #i))
        )
        (princ "\n" &fp)
        (setq #n (1+ #n))
      )
      (close &fp)
      (princ)
    )
    ;/////////////////////////////////////////////////////////////////


  ; ��ۋL�� �S����36��ނ܂ŉ\
  (setq #kigo$ (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"
                     "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
                     "U" "V" "W" "X" "Y" "Z" "1" "2" "3" "4"
                     "5" "6" "7" "8" "9" "0"))
  (setq #ifname1 (strcat CG_SYSPATH "DATA\\" CG_SeriesCode "-GAS.txt"))     ; �I����̧��(���̐���ٰ��)
  (setq #ifname2 (strcat CG_SYSPATH "DATA\\" CG_SeriesCode "-�����Ǘ�.csv")); ���`�ƂȂ镡���Ǘ�ð��ق̑I����"A"�݂̂�ں���
  (setq #ifname3 (strcat CG_SYSPATH "DATA\\" CG_SeriesCode "-�����\��.csv")); ���`�ƂȂ镡���\��ð��ق̑I����"A"�݂̂�ں���
  (setq #ofname1 (strcat CG_SYSPATH "DATA\\" CG_SeriesCode "-�����Ǘ�GAS-OUT.csv")); �o��̧��(�����Ǘ�)
  (setq #ofname2 (strcat CG_SYSPATH "DATA\\" CG_SeriesCode "-�����\��GAS-OUT.csv")); �o��̧��(�����\��)

  (if (= nil (findfile #ifname1))
    (progn
      (CFAlertErr (strcat #ifname1 " ������܂���"))
      (quit)
    )
  );_if
  (if (= nil (findfile #ifname2))
    (progn
      (CFAlertErr (strcat #ifname2 " ������܂���"))
      (quit)
    )
  );_if
  (if (= nil (findfile #ifname3))
    (progn
      (CFAlertErr (strcat #ifname3 " ������܂���"))
      (quit)
    )
  );_if

  (setq #List1$$ (ReadCSVFile #ifname1)) ; ��ۑI����
  (setq #List2$$ (ReadCSVFile #ifname2)) ; ���`�����Ǘ�
  (setq #List3$$ (ReadCSVFile #ifname3)) ; ���`�����\��

  (setq #id$ (mapcar 'car #List3$$))
  (setq #dum$ nil)
  (foreach #id #id$
    (if (= nil (member #id #dum$))
      (setq #dum$ (append #dum$ (list #id)))
    );_if
  )
  ; �����\��������ݐ�(�I����"A"�̂�)
  (setq #ptn (length #dum$))

  (if (< 36 (length #List1$$))
    (progn
      (CFAlertErr "��ۂ̑I�����̐���36���z���Ă��邽��\n��ۋL����2���ɂ��Ȃ��Ƃ����܂���")
      (quit)
    )
  );_if

  (setq #NewList1$$ nil) ; �����Ǘ�
  (setq #NewList2$$ nil) ; �����\��

  (princ "\n")(princ (strcat "�ް��쐬��...")) ; ����ײ�
  (setq #j 0)
  (foreach #List1$ #List1$$                    ; �I������ٰ��
    (setq #GAS    (car  #List1$))              ; �޽�i��
    (setq #GAS-LR (cadr #List1$))              ; �޽LR�敪
    (setq #kigo (nth #j #kigo$))
    (setq #k 0)                                ; �ʂ��ԍ�
    (princ "\n")(princ (strcat "���=" #kigo))  ; ����ײ�
    ; *** �����Ǘ� ***
    (foreach #List2$ #List2$$                  ; �����Ǘ� ���`ں��ޕ�ٰ��
      (setq #huku_ID (atoi (nth 0 #List2$)))   ; �I����"A"��ID
      (setq #huku_ID (itoa (+ #huku_ID (* #ptn #j))))
      (setq #GAS_NAME #GAS)
      (setq #NewList$
        (CFModList #List2$
          (list
            (list  0 #huku_ID)                 ; ����ID(�d���Ȃ�)
            (list  9 #KIGO)                    ; A,B,C,...
            (list 16 #GAS_NAME)                ; �����햼��
            (list 17 (strcat #KIGO (##Int5keta #k))); �ʂ��ԍ�
          )
        )
      )
      (setq #NewList1$$ (append #NewList1$$ (list #NewList$))) ; �����Ǘ�
      (setq #k (1+ #k))
    );_foreach

    ; *** �����\�� ***
    (foreach #List3$ #List3$$                  ; ���`ں��ޕ�ٰ��(�����\��)
      (setq #huku_ID (atoi (nth 0 #List3$)))   ; �I����"A"��ID
      (setq #huku_ID (itoa (+ #huku_ID (* #ptn #j))))
      (setq #recNO    (nth 1 #List3$))         ; recNO
      (if (= "1" #recNO)
        (progn
          (setq #hinban (nth 2 #List3$))         ; ��ۉ�
          (setq #LR     (nth 3 #List3$))         ; ��ۉ�LR
        )
        (progn
          (setq #hinban #GAS)                  ; ��ەi�Ԃ���
          (setq #LR  #GAS-LR)                  ; ���LR����
        )
      );_if

      (setq #NewList2$
        (CFModList #List3$
          (list
            (list 0 #huku_ID)
            (list 2 #hinban)
            (list 3 #LR)
          )
        )
      )
      (setq #NewList2$$ (append #NewList2$$ (list #NewList2$)))
    );_foreach
    (setq #j (1+ #j))
  );_foreach

  (princ "\n")(princ (strcat "�ް��o�͒�...")) ; ����ײ�

  (setq #fp1 (open #ofname1 "w"))
  (setq #fp2 (open #ofname2 "w"))

  (if (or (= nil #fp1)(= nil #fp2))
    (progn
      (CFAlertErr "�o��̧�ق��J���܂���")
      (quit)
    )
  );_if
  ; ̧�ُo��(csv�`��)�����Ǘ�
  (##OUTPUT #NewList1$$  #fp1)
  ; ̧�ُo��(csv�`��)�����\��
  (##OUTPUT #NewList2$$ #fp2)

  (princ "\n*** �o�͏I�� ***")
  (princ "\n")(princ #ofname1)
  (princ "\n")(princ #ofname2)
  (setq *error* nil)
  (princ)
);C:GAS

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AutoMrr
;;; <�����T�v>  : ���ݓo�^�������݂��J����LR���]������ݕۑ�����
;;;               ̧�ٖ��� DKSAAP2180L0.dwg �� DKSAAP2180R0.dwg �ƂȂ�
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/04/28 YM
;;; <���l>      : 03/07/05 YM �V����,�VCKC�p
;;;*************************************************************************>MOH<
(defun C:AutoMrr (
  /
  #DUM$$ #DWG$ #IFNAME1 #PATH
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)

  (setq CG_SAVE-DWG nil)

  ; �Ώ�DWG����ؽĂ����߂�(#path �ɑ��݂���*.DWG�̌�)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\")) ; DB���ɕύX"NK_KSA"
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  ; ٰ�ߏ���
  (foreach #DWG #DWG$
    ; �J��̧�ٖ�
    (setq CG_OPEN-DWG (strcat #path #DWG))
    ;���ݑ}��
    (sub_KP_InBlock CG_OPEN-DWG)

    ; �ۑ�̧�ٖ�  "L"�Ŏ��[���݂������==>R �ɕϊ�����
    (setq CG_SAVE-DWG (strcat #path (substr #DWG 1 10) "R" (substr #DWG 12 6)));DIPLOA
;;;   (setq CG_SAVE-DWG (strcat #path (substr #DWG 1 10) "R" (substr #DWG 12 5)));����

    ; 03/05/07 YM ADD �s�v�ȸ�ٰ�ߒ�`���폜����
    (KP_DelUnusedGroup)
    (command "._zoom" "E")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")
    ;���]����
    (sub_AutoMrr)
    ; ��ٰ�ߕ���
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    ; ���݂�ۑ�(copy)����
    (sub_KP_WrBlock); CG_SAVE-DWG ���g�p����

    (c:clear) ; �}�ʸر�
    ; ��ٰ�ߕ���
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")
  )

  (setq *error* nil)

  (princ)
);C:AutoMrr

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_AutoMrr
;;; <�����T�v>  : ���ݓo�^�������݂��J����LR���]������ݕۑ�����
;;;               ̧�ٖ���CKTDB180P6RG.DWG �� CKTDB180P6LG �ƂȂ�
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/04/28 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun sub_AutoMrr ( / )

  ; 03/05/06 YM ADD-S "R"���݂����̨�Ă��ĕۑ�
  (command "._zoom" "E")
  (command "_zoom" "0.8x") ; ��ʂ��肬�肾�ƈꕔ�}�`����گ��ł��Ȃ��悤�ł���
  ; ��ٰ�ߕ��� 03/07/09 YM ADD
  (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_qsave")
  ; 03/05/06 YM ADD-E

  ; LR���]����
  (sub_MirrorMove)
  (princ)
);sub_AutoMrr

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_DelUnusedGroup
;;; <�����T�v>  : ���g�p�O���[�v���폜����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/07 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_DelUnusedGroup (
  /
  #340 #EG #EG$ #EN #GRPEN #GRPNAME #I #J #LOOP #MEM #MEM$ #COUNT #HAND
  )
  (setq #count 0) ; �폜���̶���
  (setq #eg$ (entget (namedobjdict)))
  (setq #i 0)
  (setq #en nil)
  (while (and (= #en nil) (< #i (length #eg$)))
    (setq #eg (nth #i #eg$))
    (if (and (= 3 (car #eg)) (= "ACAD_GROUP" (cdr #eg)))
      (setq #en (cdr (nth (1+ #i) #eg$)))
    )
    (setq #i (1+ #i))
  );while

  (if #en ; "DICTIONARY"�擾
    (progn
      (setq #eg$ (entget #en))
      (setq #i 0)
      (while (< #i (length #eg$))
        (setq #eg (nth #i #eg$))
        (if (= 3 (car #eg))
          (progn
            (setq #grpname (cdr #eg))                ; ��ٰ�ߖ�
            (setq #grpen   (cdr (nth (1+ #i) #eg$))) ; ��ٰ�ߐ}�`
            (if (and #grpname #grpen)
              (progn
                (setq #mem$ (entget #grpen))
                (setq #340 nil) ; 340�}�`�L���׸� �Ȃ�==>nil ����==>T
                (setq #j 0 #loop T)
                (while (and #loop (< #j (length #mem$)))
                  (setq #mem (nth #j #mem$))
                  (if (= 340 (car #mem))
                    (setq #340 T #loop nil)
                  );_if
                  (setq #j (1+ #j))
                );while

                ;�s�p��ٰ�߂̕���
                (if (= nil #340)
                  (progn ; 340�Ԑ}�`�Ȃ�

;;;                   (setq #del T)  ; ��ٰ�ߕ����\�׸�
;;;                   (foreach #mem #mem$
;;;                     (if (and (= 70 (car #mem))(= 3 (cdr #mem)))
;;;                       ; ��ٰ�߂𕪉��ł��Ȃ�(70 . 3)�͉�?
;;;                       ;  70 "���O�Ȃ�" �t���O: 1 = ���O�Ȃ��A0 = ���O����
;;;                       (setq #del nil)  ; *����*
;;;                     )
;;;                   )
;;;                   (if #del
;;;                     (progn
;;;                       (command "_.-group" "E" #grpname)
;;;                       (if (wcmatch (getvar "CMDNAMES") "*GROUP*")
;;;                         (command)
;;;                       );_if

                        ; "GROUP"�� entdel ����
                        (setq #hand (cdr (assoc 5 #mem$)))
                        ;03/06/25 YM MOD #hand = nil �̂Ƃ�������
                        (if #hand
                          (entdel (handent #hand))
                        );_if

                        (setq #count (1+ #count))
;;;                     )
;;;                   );_if
                  )
                );_if
              )
            );_if
          )
        );_if
        (setq #i (1+ #i))
      );while
    )
  );_if
  (princ "\n")(princ #count)(princ "�̸�ٰ�߂𕪉����܂���")
  (princ)
);KP_DelUnusedGroup

;////////////////////////////////////////////////////////////////
; ���ݒ�`����Ă����ٰ�߂��e�L�X�g�o�͂���
;////////////////////////////////////////////////////////////////
(defun c:ggg ( / DATE_TIME #DELFLG #EG #EG$ #EN #FIL #GRPEN #GRPNAME #HAND #I #MEM$ #DATE_TIME)
  ; ̧��OPEN
  (setq #fil (open (strcat CG_SYSPATH "������ٰ��.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n" #fil)

  (setq #eg$ (entget (namedobjdict)))
  (setq #i 0)
  (setq #en nil)
  (while (and (= #en nil) (< #i (length #eg$)))
    (setq #eg (nth #i #eg$))
    (if (and (= 3 (car #eg)) (= "ACAD_GROUP" (cdr #eg)))
      (setq #en (cdr (nth (1+ #i) #eg$)))
    )
    (setq #i (1+ #i))
  );while

  (if #en ; "DICTIONARY"�擾
    (progn
      (setq #eg$ (entget #en))
      (setq #i 0)
      (while (< #i (length #eg$))
        (setq #eg (nth #i #eg$))
        (if (= 3 (car #eg))
          (progn
            (setq #grpname (cdr #eg))                ; ��ٰ�ߖ�
            (princ "\n" #fil)(princ #grpname #fil)(princ "  " #fil)

            (setq #grpen   (cdr (nth (1+ #i) #eg$))) ; ��ٰ�ߐ}�`
            (setq #mem$ (entget #grpen))
            (setq #delflg nil) ; entdel����
            (foreach #mem #mem$
              (if (and (= 70 (car #mem))(= 3 (cdr #mem)))
                (princ "�폜�ł��Ȃ�" #fil)
              );_if
            )
          )
        );_if
        (setq #i (1+ #i))
      );while
    )
  );_if

  (if #fil
    (progn
      (close #fil)
      (princ "\ņ�قɏ������݂܂���.")
      (startapp "notepad.exe" (strcat CG_SYSPATH "������ٰ��.txt"))
    )
  );_if

  (princ)

)

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AutoView
;;; <�����T�v>  : ���ݓo�^�������݂��J���ĉB���������Č���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/08 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:AutoView (
  /
  #DWG$ #PATH #I #IFNAME1
  )
;;; ; �Ώ�DWG����ؽĂ����߂�(#path �ɑ��݂���*.DWG�̌�)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
;;; (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  (setq #ifname1 (strcat #path CG_SeriesCode "-DWGLIST.txt"))
  (setq #DWG$ (ReadCSVFile #ifname1))
  (setq #DWG$ (mapcar 'car #DWG$))

  ; ٰ�ߏ���
  (setq #i 0)
  (foreach #DWG #DWG$
    (setq CG_DWG #DWG)
    ; �J��̧�ٖ�
    (setq CG_OPEN-DWG (strcat #path #DWG))
    (setq CG_OpenMode 888) ; �� S::STARTUP �� sub_AutoView
    ;�J������
    (if (/= (getvar "DBMOD") 0)
      (progn
        (if (/= 0 #i)
          (progn ; �ŏ�������΂�
            (command "._zoom" "E")
            (if (= "R" (substr CG_OLD_DWG 11 1))
              ; �E-->�쓌
              (SKChgView "2,-2,1")
              ; ��-->�쐼
              (SKChgView "-2,-2,1")
            );_if
            (command "._shademode" "2D") ; �B������
          )
        );_if
        (command "_qsave")
        (vl-cmdf "._open" CG_OPEN-DWG)
        (command "._shademode" "2D") ; �B������
        (CFYesDialog (strcat CG_DWG "\n�O��OK?"))
      )
      (progn
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
    );_if

    (S::STARTUP)
    (setq CG_OLD_DWG #DWG)
    (setq #i (1+ #i))
  )
  (princ)
);C:AutoView

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_AutoView
;;; <�����T�v>  : ���ݓo�^�������݂��B���������Č���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/08 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun sub_AutoView ( / )
  (command "._zoom" "E")
  (SKChgView "-1,1,1") ; �k�����p�}
  (command "._shademode" "H") ; �B������
  (CFYesDialog (strcat CG_DWG "\n����OK?"))
  (princ)
);sub_AutoView

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AutoMove
;;; <�����T�v>  : ���ݓo�^�������݂��J�������݂��ړ����đ}����_��ύX����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/08 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:AutoMove (
  /
  #DWG$ #I #PATH
  )
  ; �Ώ�DWG����ؽĂ����߂�(#path �ɑ��݂���*.DWG�̌�)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  ; ٰ�ߏ���
  (foreach #DWG #DWG$
    (setq CG_DWG #DWG)
    ; �J��̧�ٖ�
    (setq CG_OPEN-DWG (strcat #path #DWG))
    (setq CG_OpenMode 777) ; �� S::STARTUP �� sub_AutoMove
    ;�J������
    (if (/= (getvar "DBMOD") 0)
      (progn
        (command "_qsave")
        ; OPEN
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
      (progn
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
    );_if

    (S::STARTUP) ; �� sub_AutoMove
    (setq CG_OLD_DWG #DWG)
  )
  (command "_qsave")
  (princ)
);C:AutoMove

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_AutoMove
;;; <�����T�v>  : ���ݓo�^�������݂��ړ����đ}����_��ύX����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/08 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun sub_AutoMove ( / #DIR #MPT #SS #SSGRP #WW)
  (command "._zoom" "E")

  ;�ړ�����
  (setq #ww (atoi (substr CG_DWG 6 3)))
  (setq #ww (* #ww 10)) ; 180-->1800mm

  ;�ړ����� L or R
  (setq #dir (substr CG_DWG 11 1))

  (if (= "R" #dir)
    (setq #mpt (list #ww 0 0))
    (setq #mpt (list (- #ww) 0 0))
  );_if

  ;�ړ�
  (setq #ss (ssget "X"))
  (setq #ssGrp (ChangeItemColor #ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) "BYLAYER"))
  (command "_move" #ssGrp "" '(0 0 0) #mpt)
  ; "G_LSYM"(�}���_)�X�V
  (ChgLSYM1 #ssGrp)

  (if (= "R" #dir)
    ; �E-->�쓌
    (SKChgView "2,-2,1")
    ; ��-->�쐼
    (SKChgView "-2,-2,1")
  );_if

  (princ)
);sub_AutoMove

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AutoPlot
;;; <�����T�v>  : ���ݓo�^�������݂��J���Ď{�H�}�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/09 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:AutoPlot (
  /
  #DWG$ #PATH #IFNAME1
  )
  (setq CG_AUTOMODE 1)  ;����Ӱ��(�����ݸ޼�ĂƓ���)
  (setvar "FILEDIA" 0)

;;; ; �Ώ�DWG����ؽĂ����߂�(#path �ɑ��݂���*.DWG�̌�)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
;;; (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  (setq #ifname1 (strcat #path CG_SeriesCode "-DWGLIST.txt"))
  (setq #DWG$ (ReadCSVFile #ifname1))
  (setq #DWG$ (mapcar 'car #DWG$))

  ; ٰ�ߏ���
  (foreach #DWG #DWG$
    (c:clear) ; �}�ʸر�
    (setq CG_DWG #DWG)
    ; �J��̧�ٖ�
    (setq CG_OPEN-DWG (strcat #path #DWG))
    (if (= nil (findfile CG_OPEN-DWG))
      (progn
        (setq #msg (strcat CG_OPEN-DWG " ������܂���"))
        (CFAlertMsg #msg)
      )
    )

    ;�}������
    (KP_InBlock_sub CG_OPEN-DWG)
    (sub_AutoPlot)
  )
  (princ)
);C:AutoPlot

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_AutoPlot
;;; <�����T�v>  : ���ݓo�^�������݂��B���������Č���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/08 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun sub_AutoPlot ( / )

  ;Head.cfg�������o��
  (SKB_WriteHeadList)
  ; �ۑ�
  (command "_.QSAVE")
  ; �߰��
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  ; �W�J�}�쐬
  (C:SCFMakeMaterial)
  ;�}��ڲ���
  (setq CG_AUTOMODE_DIMMK (list (list "1" "1" "A" "Y") (list (list "A3-30-5-I�^��ABD�d" "04"))))
  (C:SCFLayout)
  ;�}�ʎQ��
  (setq CG_AUTOMODE_ZUMEN ; �W�J�}R
    (strcat CG_KENMEI_PATH "OUTPUT\\A3-30-5-I�^��ABD�d_0_04.dwg")
  )
  (C:SCFConf)
  ;�ȈՈ��
  (setq CG_AUTOMODE_PRINT (list "paperA3" "scale30")); �W�J�}
  (C:PlainPlot)
  ; �����ݸ��ƭ�
  (C:ChgMenuPlan)
  ; ���̐}�ʂɖ߂�
  (C:SCFConfEnd)
  (princ)
);sub_AutoPlot

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AutoDoorDel
;;; <�����T�v>  : ���ݓo�^�������݂��J���Ĕ����폜����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/13 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:AutoDoorDel (
  /
  #DWG$ #I #PATH
  )
  ; �Ώ�DWG����ؽĂ����߂�(#path �ɑ��݂���*.DWG�̌�) NAS ���[���p
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  ; ٰ�ߏ���
  (foreach #DWG #DWG$
    (setq CG_DWG #DWG)
    ; �J��̧�ٖ�
    (setq CG_OPEN-DWG (strcat #path #DWG))
    (setq CG_OpenMode 666) ; �� S::STARTUP �� sub_AutoDoorDel
    ;�J������
    (if (/= (getvar "DBMOD") 0)
      (progn
        (command "_qsave")
        ; OPEN
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
      (progn
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
    );_if

    (S::STARTUP) ; �� sub_AutoDoorDel
    (setq CG_OLD_DWG #DWG)
  )
  (command "_qsave")
  (princ)
);C:AutoDoorDel

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_AutoDoorDel
;;; <�����T�v>  : ���ݓo�^�������݂��J���Ĕ����폜����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/08 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun sub_AutoDoorDel (
  /
  #DIR #I #SS #SYM
  )
  (command "._zoom" "E")

;;; (if CG_DWG
;;;   (setq #dir (substr CG_DWG 11 1))
;;; )

  (setq #ss (ssget "X" '((-3 ("G_SYM"))))) ; G_LSYM �}�`�I���
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        ;���폜
        (PKD_EraseDoor #sym)
        (setq #i (1+ #i))
      )
    )
    ;else
    (CFAlertMsg "�}�ʏ�ɕ��ނ�����܂���")
  );_if

;;; (if (= "R" #dir)
;;;   ; �E-->�쓌
;;;   (SKChgView "2,-2,1")
;;;   ; ��-->�쐼
;;;   (SKChgView "-2,-2,1")
;;; );_if

  (princ)
);sub_AutoDoorDel

(defun c:dd ( / )
  (sub_AutoDoorDel)
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AutoSAVE2000
;;; <�����T�v>  : \MASTER,\DRMASTER ��DWG��2000�`���ŕۑ�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/15 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:AutoSAVE2000 (
  /
  #DRMASTER-DWG #DRMASTER-DWG$ #DWG$ #MASTER-DWG #MASTER-DWG$ #OPEN-DWG$ #PATH
  )
  (setvar "CMDECHO" 0)
  ; \MASTER����DWG����ؽĂ����߂�
  (setq #path (strcat CG_SKDATAPATH "MASTER\\"))
  (setq #dwg$ (vl-directory-files #path "*.dwg" 1))
  (setq #MASTER-DWG$ nil)
  (foreach #dwg #dwg$
    (setq #MASTER-DWG (strcat #path #dwg))
    (setq #MASTER-DWG$ (append #MASTER-DWG$ (list #MASTER-DWG)))
  )
  ; \DRMASTER����DWG����ؽĂ����߂�
  (setq #path (strcat CG_SKDATAPATH "DRMASTER\\"))
  (setq #dwg$ (vl-directory-files #path "*.dwg" 1))
  (setq #DRMASTER-DWG$ nil)
  (foreach #dwg #dwg$
    (setq #DRMASTER-DWG (strcat #path #dwg))
    (setq #DRMASTER-DWG$ (append #DRMASTER-DWG$ (list #DRMASTER-DWG)))
  )
  (setq #OPEN-DWG$ (append #MASTER-DWG$ #DRMASTER-DWG$))

  ; ٰ�ߏ���
  (foreach #DWG #OPEN-DWG$
    ; �J��̧�ٖ�
    (setq CG_OPEN-DWG #DWG)
    (setq CG_OpenMode 555) ; �� S::STARTUP �� sub_Auto2000SAVE
    ;�J������
    (if (/= (getvar "DBMOD") 0)
      (progn
        (command "_qsave")
        ; OPEN
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
      (progn
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
    );_if

    (S::STARTUP) ; �� sub_AutoDoorDel
;;;   (setq CG_OLD_DWG #DWG)
  )
  (command "_qsave")
  (princ)
);C:AutoSAVE2000

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_AutoSAVE2000
;;; <�����T�v>  : ���ݓo�^�������݂��ړ����đ}����_��ύX����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/08 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun sub_AutoSAVE2000 ( / )
  (princ)
);sub_AutoSAVE2000

















;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AutoKOUSIN
;;; <�����T�v>  : ���ݓo�^�������݂��J���ĕ��ލX�V���̑����s��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/06/24 YM ���� 04/03/10 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun C:AutoKOUSIN (
  /
  #DWG$ #PATH
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)

  ; �Ώ�DWG����ؽĂ����߂�(#path �ɑ��݂���*.DWG�̌�)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\")) ; DB���ɕύX"NK_KSA"�Ȃ�
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

;;; ; �Ώ�DWG����ؽĂ����߂�
;;; (setq #ifname1 (strcat CG_SYSPATH "plan-" CG_SeriesCode ".txt"))
;;; (setq #DWG$$ (ReadCSVFile #ifname1))
;;; (setq #DWG$ (mapcar 'car #DWG$$)) ; ���߽

  ; ٰ�ߏ���
  (foreach #DWG #DWG$
    ; �J��̧�ٖ�
    (setq CG_OPEN-DWG (strcat #path #DWG))
    ;���ݑ}��
    (sub_KP_InBlock CG_OPEN-DWG)

    ; �ۑ�̧�ٖ�(�������O)
    (setq CG_SAVE-DWG (strcat #path #DWG))

    ; 03/05/07 YM ADD �s�v�ȸ�ٰ�ߒ�`���폜����
    (KP_DelUnusedGroup)
    (command "._zoom" "E")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")

    ;���ލX�V����
    (sub_AutoKOUSIN)

    ; ��ٰ�ߕ���
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    ; ���݂�ۑ�(copy)����
    (sub_KP_WrBlock); CG_SAVE-DWG ���g�p����

    (c:clear) ; �}�ʸر�
    ; ��ٰ�ߕ���
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")
  );foreach

  (setq *error* nil)

  (princ)
);C:AutoKOUSIN

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_AutoKOUSIN
;;; <�����T�v>  : ���ݓo�^�������݂��J���Ĕ����폜����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/08 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun sub_AutoKOUSIN ( / )
  (command "vpoint" "0,0,1")
  (command "._zoom" "E")
  ;���ލX�V
  (C:KPRefreshCAB)
  ;���폜
;;;  (C:dd)
  ;���g�p��ٰ�ߒ�`���폜����
  (KP_DelUnusedGroup)
  ;�߰��
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_.QSAVE")
  ;�ۑ�
;;; (CFAutoSave)
  (princ)
);sub_AutoKOUSIN




;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AutoHINBAN_CHANGE
;;; <�����T�v>  : ���ݓo�^�������݂��J���ĕi�ԏC�����s��(�}�`,�z�񓙂͈�ؕύX�Ȃ����O��)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 06/08/11 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun C:AutoHINBAN_CHANGE (
  /
  #DWG$ #PATH #FIL #OFILE #SFILE
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)

  ; �Ώ�DWG����ؽĂ����߂�(#path �ɑ��݂���*.DWG�̌�)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\"))
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  ;�i�ԕύX��`̧�ق̓ǂݍ���
  (setq #sFile (strcat #path "hinban-henkan-" CG_DBNAME ".txt"))
  (setq CG_List$ (ReadCSVFile #sFile))

  ;۸�̧��OPEN
  (setq #ofile (strcat #path "hinban-henkan-" CG_DBNAME ".log"));���ʏo��̧��
  (setq #fil (open #ofile "W" ))

  ;�ύX�Ώەi��ؽč쐬   �ύX�i�Ԃ̎擾==>(cdr (assoc "SPBT180SCK" #List$$))
  (setq CG_hinban$  (mapcar 'car CG_List$))
          
  ; ٰ�ߏ���
  (foreach #DWG #DWG$
    ; �J��̧�ٖ�
    (setq CG_OPEN-DWG (strcat #path #DWG))
    ;���ݑ}��
    (sub_KP_InBlock CG_OPEN-DWG)

    ; �ۑ�̧�ٖ�(�������O)
    (setq CG_SAVE-DWG (strcat #path #DWG))

    ; 03/05/07 YM ADD �s�v�ȸ�ٰ�ߒ�`���폜����
    (KP_DelUnusedGroup)
    (command "._zoom" "E")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")

    ;�i�ԍX�V����
    (sub_AutoHINBAN_CHANGE)

    ; ��ٰ�ߕ���
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    ; ���݂�ۑ�(copy)����
    (sub_KP_WrBlock); CG_SAVE-DWG ���g�p����

    (c:clear) ; �}�ʸر�
    ; ��ٰ�ߕ���
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")
  );foreach

  (setq *error* nil)
  (if #fil (close #fil))
  (startapp "notepad.exe" #ofile)
  (princ)
);C:AutoHINBAN_CHANGE

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_AutoHINBAN_CHANGE
;;; <�����T�v>  : ���ݓo�^�������݂��J���ĕi�ԏC�����s��(�}�`,�z�񓙂͈�ؕύX�Ȃ����O��)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 06/08/11 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun sub_AutoHINBAN_CHANGE (
  /
  #HIN #I #SS #SYM #XD_LSYM$
  )
  (command "vpoint" "0,0,1")
  (command "._zoom" "E")
  ;�}�ʏ�̑Ώەi�Ԍ���
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #sym (ssname #ss #i))
    (setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
    (setq #hin (nth 5 #xd_LSYM$));�i��

    (if (member #hin CG_hinban$)
      (progn ;�i�ԕύX�Ώ�
        ;�X�V�i��
        (setq #after_hin (car (cdr (assoc #hin CG_List$))))
        (CFSetXData #sym "G_LSYM"
          (CFModList #xd_LSYM$
            (list
              (list 5 #after_hin)
            )
          )
        )
        ;log�o��
        (princ (strcat "\n" #DWG ",�ύX�O:" #hin ",�ύX��:" #after_hin) #fil)
      )
    );_if
    (setq #i (1+ #i))
  )

  ;���g�p��ٰ�ߒ�`���폜����
  (KP_DelUnusedGroup)
  ;�߰��
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_.QSAVE")
  (princ)
);sub_AutoHINBAN_CHANGE



;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AutoHINBAN_EXIST
;;; <�����T�v>  : ���ݓo�^��������dwg���J���ĕi�Ԃ�[�i�Ԋ�{]�ɑ��݂��邩��������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 06/08/14 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun C:AutoHINBAN_EXIST (
  /
  #DWG$ #PATH #FIL #OFILE #SFILE
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)

  ; �Ώ�DWG����ؽĂ����߂�(#path �ɑ��݂���*.DWG�̌�)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\"))
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  ;۸�̧��OPEN
  (setq #ofile (strcat #path "hinban-exist-" CG_DBNAME ".log"));���ʏo��̧��
  (setq #fil (open #ofile "W" ))
          
  ; ٰ�ߏ���
  (foreach #DWG #DWG$
    ; �J��̧�ٖ�
    (setq CG_OPEN-DWG (strcat #path #DWG))
    ;���ݑ}��
    (sub_KP_InBlock CG_OPEN-DWG)

    ; �ۑ�̧�ٖ�(�������O)
    (setq CG_SAVE-DWG (strcat #path #DWG))

    ; 03/05/07 YM ADD �s�v�ȸ�ٰ�ߒ�`���폜����
;;;   (KP_DelUnusedGroup)
;;;   (command "._zoom" "E")
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_qsave")

    ;�i�Ԃ̑��݂���������
    (sub_AutoHINBAN_EXIST)

    ; ��ٰ�ߕ���
;;;   (KP_DelUnusedGroup)
    ; ���݂�ۑ�(copy)����
    (sub_KP_WrBlock); CG_SAVE-DWG ���g�p����

    (c:clear) ; �}�ʸر�
    ; ��ٰ�ߕ���
;;;   (KP_DelUnusedGroup)
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_qsave")
  );foreach

  (setq *error* nil)
  (if #fil (close #fil))
  (startapp "notepad.exe" #ofile)
  (princ)
);C:AutoHINBAN_EXIST

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_AutoHINBAN_EXIST
;;; <�����T�v>  : ���ݓo�^��������dwg���J���ĕi�Ԃ�[�i�Ԋ�{]�ɑ��݂��邩��������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 06/08/11 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun sub_AutoHINBAN_EXIST (
  /
  #HIN #I #SS #SYM #XD_LSYM$
  )
  (command "vpoint" "0,0,1")
  (command "._zoom" "E")

  (princ (strcat "\nDWG��:" #DWG) #fil)

  ;�}�ʏ�̑Ώەi�Ԍ���
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #sym (ssname #ss #i))
    (setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
    (setq #hin (nth 5 #xd_LSYM$));�i��
    ;�i�Ԋ�{�ɑ��݂��邩�ǂ���������
    (setq #KIHON$$
      (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
        (list
          (list "�i�Ԗ���"  #hin 'STR)
        )
      )
    )
    (if (= nil #KIHON$$)
      (princ (strcat "\n�~[�i�Ԋ�{]�ɑ��݂��Ȃ�:" #hin) #fil)
      ;else
      (princ (strcat "\n��[�i�Ԋ�{]�ɑ��݂���:" #hin) #fil)
    );_if
    
    (setq #i (1+ #i))
  )

  ;���g�p��ٰ�ߒ�`���폜����
;;; (KP_DelUnusedGroup)
  ;�߰��
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_.QSAVE")
  (princ)
);sub_AutoHINBAN_EXIST







;;;<HOM>*************************************************************************
;;; <�֐���>    : C:HHH
;;; <�����T�v>  : �}�ʏ�̑S����ȯĂ̕i��,�}�`ID,���@H��÷�ĕ\������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/13 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:HHH (
  /
  #DATE_TIME #FIL #HHH #HIN #I #SS #SYM #XD_LSYM$ #XD_SYM$ #ZID
  )
    ;-----------------------------------------------------------------
    (defun ##moji (
      &str
      &moji
      /
      #LOOP #N #RET
      )
      (setq #ret &str)
      (setq #n (strlen &str)) ; ������
      (setq #loop (- &moji #n))
      (if (< 0 #loop)
        (progn
          (repeat #loop
            (setq #ret (strcat #ret " "))
          )
        )
      );_if
      #ret
    )
    ;-----------------------------------------------------------------

  (setq #fil (open (strcat CG_SYSPATH "CHK_HHH.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n --- �}�ʏ�̷���ȯĂ̐��@H���� ---" #fil)
  (princ "\n" #fil)

  (princ "\n        �i��         , �}�`ID  , ���@H" #fil)

  (setq #ss (ssget "X" '((-3 ("G_SYM"))))) ; G_LSYM �}�`�I���
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        (setq #xd_SYM$ (CFGetXData #sym "G_SYM"))
        (setq #hhh (nth 5 #xd_SYM$)) ; ���@H
        (setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
        (setq #zid (nth 0 #xd_LSYM$)) ; �}�`ID
        (setq #hin (nth 5 #xd_LSYM$)) ; �i��
        (setq #hin (##moji #hin 20)) ; ������20�ɂȂ�܂Ŗ����ɋ󔒂𑫂�
        (princ (strcat "\n" #hin " , " #zid " , " (rtos #hhh)) #fil)
        (setq #i (1+ #i))
      )
    )
    ;else
    (CFAlertMsg "�}�ʏ�ɕ��ނ�����܂���")
  );_if

  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "CHK_HHH.txt"))
  (princ)
)

;<HOM>***********************************************************************
; <�֐���>    : C:GroupHantei
; <�����T�v>  : ��ٰ�߂̔���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 03/05/13 YM
; <���l>      : �J���җpýĺ����
; ����ȯ�1�����ݕۑ����Ă���}������Ɩ��O�̂����ٰ��(��)��A
; ��ٰ�߂̐���"DoorGroup"�������Ă��܂��B����ȯĖ{�̸̂�ٰ�߂�
; ���̸�ٰ�߂̋�ʂ����Ȃ��̂ŉ�w�ňႢ������
;***********************************************************************>HOM<
(defun C:GroupHantei (
  /
  #330 #330$ #340 #340$ #340$$ #EG$ #EG2$ #EN #FIL #LAY #SYM #TYPE
  )
  (setq #fil (open (strcat CG_SYSPATH "CHECK.txt") "W" ))

  (setq #en (car (entsel "\n����ȯĂ�I��: ")))
  (setq #sym (CFSearchGroupSym #en)) ; ����ِ}�`
  (setq #eg$ (entget #sym '("*")))

  (setq #330$ nil)
  (foreach #eg #eg$
    (if (= (car #eg) 330)
      (progn
        (setq #330 (cdr #eg))
        (setq #330$ (append #330$ (list #330)))
      )
    );_if
  )

  (setq #340$$ nil)
  (foreach #330 #330$
    (setq #eg2$ (entget #330))
    (setq #340$ nil)
    (foreach #eg2 #eg2$
      (if (= (car #eg2) 340)
        (progn
          (setq #340 (cdr #eg2))
          (setq #340$ (append #340$ (list #340)))
        )
      );_if
    )
    (setq #340$$ (append #340$$ (list #340$)))
  )

  (princ "\n--- ��w ---" #fil)
  (foreach #340$ #340$$
    (foreach #340 #340$
      (setq #lay (cdr (assoc 8 (entget #340))))
      (princ "\n" #fil)(princ #lay #fil)
    )
    (princ "\n---" #fil)
  )

  (princ "\n--- --- ---" #fil)
  (princ "\n--- �}�`���� ---" #fil)

  (foreach #340$ #340$$
    (foreach #340 #340$
      (setq #type (cdr (assoc 0 (entget #340))))
      (princ "\n" #fil)(princ #type #fil)
    )
    (princ "\n---" #fil)
  )
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "CHECK.txt"))

  (princ)
);C:GroupHantei




;;;<HOM>*************************************************************************
;;; <�֐���>    : C:GetZukeiID
;;; <�����T�v>  : �i�Ԑ}�`ð��قQ�d�o�^�����p
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 00/11/28 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:GetZukeiID (
  /
  #DATE_TIME #FIL #HIN #HIN$ #IFNAME1 #LIST$$ #LIST1$$ #LR #QRY$ #ZUKEI
  )
  (setq #fil (open (strcat CG_SYSPATH "GetZukeiID.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������

  (princ "\n�}�`ID�擾�ꗗ" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesCode) #fil)

  (setq #hin$ nil)
  (setq #ifname1 (strcat CG_SYSPATH "TEMP\\" CG_SeriesCode "-SPLAN.txt"))
  (setq #List1$$ (ReadCSVFile #ifname1)) ; ��ۑI����

  (setq #list$$ nil)
  (foreach #List1$ #List1$$
    (setq #hin (car #List1$))
    (setq #qry$
      (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
        (list
          (list "�i�Ԗ���" #hin 'STR)
        )
      )
    )
    (if (or (= #qry$ nil)(> (length #qry$) 1))
      (progn
        (CFAlertMsg (strcat "�������s�y�i�Ԋ�{�z:" #hin))
        (quit)
      )
      (progn
        (setq #qry$ (car #qry$))
        (setq #LR (nth 1 #qry$))
        (if (= 0 #LR)
          (progn ; "Z"
            ;--------------------------------------------------------------------
            (setq #LR "Z")
            (setq #qry$
              (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
                (list
                  (list "�i�Ԗ���"   #HIN  'STR)
                  (list "LR�敪"     #LR   'STR)
                )
              )
            )
            (if (or (= #qry$ nil)(> (length #qry$) 1))
              (progn
                (CFAlertMsg (strcat "�������s�y�i�Ԑ}�`�z: " #hin "  LR: " #LR))
                (quit)
              )
              (progn ; �}�`ID�擾
                (setq #qry$ (car #qry$))
                (setq #zukei (nth 6 #qry$));2008/06/28 OK!
                (setq #list$$ (append #list$$ (list (list #hin #zukei))))
              )
            );_if
          )
          (progn ; "L","R"
            ;--------------------------------------------------------------------
            (setq #LR "L")
            (setq #qry$
              (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
                (list
                  (list "�i�Ԗ���"   #HIN  'STR)
                  (list "LR�敪"     #LR   'STR)
                )
              )
            )
            (if (or (= #qry$ nil)(> (length #qry$) 1))
              (progn
                (CFAlertMsg (strcat "�������s�y�i�Ԑ}�`�z: " #hin "  LR: " #LR))
                (quit)
              )
              (progn ; �}�`ID�擾
                (setq #qry$ (car #qry$))
                (setq #zukei (nth 6 #qry$));2008/06/28 OK!
                (setq #list$$ (append #list$$ (list (list #hin #zukei))))
              )
            );_if

            ;--------------------------------------------------------------------
            (setq #LR "R")
            (setq #qry$
              (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
                (list
                  (list "�i�Ԗ���"   #HIN  'STR)
                  (list "LR�敪"     #LR   'STR)
                )
              )
            )
            (if (or (= #qry$ nil)(> (length #qry$) 1))
              (progn
                (CFAlertMsg (strcat "�������s�y�i�Ԑ}�`�z: " #hin "  LR: " #LR))
                (quit)
              )
              (progn ; �}�`ID�擾
                (setq #qry$ (car #qry$))
                (setq #zukei (nth 6 #qry$));2008/06/28 OK!
                (setq #list$$ (append #list$$ (list (list #hin #zukei))))
              )
            );_if

          )
        );_if

      )
    );_if

  );foreach

  (foreach #list$ #list$$
    (setq #hin   (car  #list$))
    (setq #zukei (cadr #list$))
    (princ (strcat "\n" #HIN "," #zukei) #fil)
  )

  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "GetZukeiID.txt"))
  (princ)
);C:GetZukeiID

;;;<HOM>*************************************************************************
;;; <�֐���>    : CFGetNumFromStr_NAS
;;; <�����T�v>  : ������̐������������擾����
;;;               (��) "GS-105A"--->"105"
;;; <�߂�l>    : ������
;;; <�쐬>      : 03/06/09 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun CFGetNumFromStr_NAS (
  &str ; ������
  /
  #I #RET #STR #END #KOSU
  )
  (setq #str &str)

  ;04/08/16 YM MOD (�i�Ԗ���"1","2","3"�t�������O����)
  (setq #kosu (strlen #str))
  (setq #end (substr #str #kosu 1));�����̕���
  (if (or (= #end "1")(= #end "2")(= #end "3"))
    (setq #str (substr #str 1 (1- #kosu)));����1�������폜����������
  );_if

  (setq #ret "")
  (if (= 'STR (type #str))
    (progn
      (setq #i 1)
      (repeat (strlen #str)
        (setq #s (substr #str #i 1))
        (if (wcmatch #s "#")
          (setq #ret (strcat #ret #s))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CFGetNumFromStr_NAS

;;;<HOM>*************************************************************************
;;; <�֐���>    : CFGetNumFromStr
;;; <�����T�v>  : ������̐������������擾����
;;;               (��) "GS-105A"--->"105"
;;; <�߂�l>    : ������
;;; <�쐬>      : 03/06/09 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun CFGetNumFromStr (
  &str ; ������
  /
  #I #RET #STR
  )
  (setq #ret "")
  (if (= 'STR (type &str))
    (progn
      (setq #i 1)
      (repeat (strlen &str)
        (setq #str (substr &str #i 1))
        (if (wcmatch #str "#")
          (setq #ret (strcat #ret #str))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CFGetNumFromStr

;;;<HOM>*************************************************************************
;;; <�֐���>    : CFGetNumFromStr2
;;; <�����T�v>  : ������̐������������擾����
;;;               (��) "SAB5S060@@K"--->"060"
;;; <�߂�l>    : ������
;;; <�쐬>      : 03/06/09 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun CFGetNumFromStr2 (
  &str ; ������
  /
  #I #RET #STR
  )
  (setq #str &str)
  (setq #str (substr #str 5 5));�����������5�`9�����܂�
  
  (setq #ret "")
  (if (= 'STR (type #str))
    (progn
      (setq #i 1)
      (repeat (strlen #str)
        (setq #s (substr #str #i 1))
        (if (wcmatch #s "#")
          (setq #ret (strcat #ret #s))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CFGetNumFromStr2

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_BuzaiHaiti
;;; <�����T�v>  : ���ނ�z�u����
;;; <�߂�l>    : �z�u��������ِ}�`
;;; <�쐬>      : 03/06/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_BuzaiHaiti (
  &id     ; �}�`ID  STR "???????"  ".dwg"�ȊO�̕���
  &pt     ; �}���_�@LIST
  &ang    ; �p�x    REAL
  &hinban ; �i�Ԗ���
  &LR     ; LR�敪
  &skk    ; [�i�Ԋ�{].���i����
  &hh     ; [�i�Ԑ}�`].���@�g
  /
  #DWG #ENEW #SS
  )
  ;̧�ٖ�
  (setq #dwg (strcat &id ".dwg"))
  ;dwg�̗L��
  (if (findfile (strcat CG_MSTDWGPATH #dwg))
    nil
    ;else
    (progn
      (CFAlertMsg (strcat "�}�`̧�� " #dwg " ������܂���"))
      (quit)
    )
  );_if

  ; �}��
  (command ".insert" (strcat CG_MSTDWGPATH #dwg) &pt 1 1 (rtd &ang))
  ; ����,��ٰ�߉�
  (command "_explode" (entlast))
  (setq #ss (ssget "P"))
  (SKMkGroup #ss) ;���������}�`�Q�Ŗ��O�̂Ȃ��O���[�v�쐬
  (command "_layer" "u" "N_*" "")
  ; ����ِ}�` #eNEW
  (setq #eNEW (SearchGroupSym (ssname #ss 0)))
  ;Xdata���
  (CFSetXData #eNEW "G_LSYM"
    (list
      &id               ;1 :�{�̐}�`ID
      &pt               ;2 :�}���_          :�z�u��_     POINT
      &ang              ;3 :��]�p�x        :�z�u��]�p�x REAL
      CG_KCode          ;4 :�H��L��        :CG_Kcode     STR
      CG_SeriesCode     ;5 :SERIES�L��      :�ذ�ދL��    STR
      &hinban           ;6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���    STR
      &LR               ;7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪 STR
      ""                ;8 :���}�`ID        :
      &id               ;9 :���J���}�`ID    : STR
      &skk              ;10:[�i�Ԋ�{].���iCODE ����
      0
      0
      0                ;13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ� ����
      &hh              ;14:���@�g          :�w�i�Ԑ}�`�x.���@�g   ����
      0                ;15:�f�ʎw���̗L��  :�w�v���\���x.�f�ʗL�� 00/07/18 SN MOD
    )
  )
  ;��w����
  (command "_layer" "on" "M_*" "")
  (command "_layer" "F" "Y_00*" "")   ; �ذ��
  (command "_layer" "OFF" "Y_00*" "") ; ��\��
  (command "_.layer" "F" "Z_*" "")
  (command "_.layer" "T" "Z_00*" "")
  (command "_.layer" "T" "Z_KUTAI" "") ; 01/02/20 YM ADD

  #eNEW ; �����
);KP_BuzaiHaiti


;;;<HOM>*************************************************************************
;;; <�֐���>    : All_dwg
;;; <�����T�v>  : E:\works\KPCAD\PLAN �ȉ��̑S"DWG"̧�ق����߽ؽĂ����߂�
;;; <�߂�l>    :
;;; <�쐬>      : 03/06/24 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun All_dwg (
  /
  #DATE_TIME #FIL #FULLPATHSG$ #FULLPATHSX$ #SG_PATH #SX_PATH
  )
  ;/////////////////////////////////////////////////////////////////////////////
  (defun ##KENSAKU (
    &path
    /
    #DIR_1$ #DIR_2$ #DWG_1$ #DWG_2$ #FULLPATH #FULLPATH$ #PATH
    )
    ;LEVEL1
    (setq #dir_1$ (vl-directory-files &path nil -1))
    (setq #dir_1$ (cdr (cdr #dir_1$)))
    (foreach #dir_1 #dir_1$
      ;�������ق�DWG������
      (setq #path (strcat &path "\\" #dir_1))
      (setq #dwg_1$ (vl-directory-files #path "*.dwg" 1))
      ;full path �����߂�
      (foreach #dwg_1 #dwg_1$
        (setq #fullpath (strcat &path "\\" #dir_1 "\\" #dwg_1))
        (setq #fullpath$ (append #fullpath$ (list #fullpath)))
      )
      ;��������
      (setq #dir_2$ (vl-directory-files #path nil -1))
      (setq #dir_2$ (cdr (cdr #dir_2$)))
      (foreach #dir_2 #dir_2$
        ;�������ق�DWG������
        (setq #path (strcat &path "\\" #dir_1 "\\" #dir_2))
        (setq #dwg_2$ (vl-directory-files #path "*.dwg" 1))
        ;full path �����߂�
        (foreach #dwg_2 #dwg_2$
          (setq #fullpath (strcat &path "\\" #dir_1 "\\" #dir_2 "\\" #dwg_2))
          (setq #fullpath$ (append #fullpath$ (list #fullpath)))
        )
      )
    )
    #fullpath$
  );##KENSAKU
  ;/////////////////////////////////////////////////////////////////////////////
  (defun ##PRINT ( &fullpath$ / )
    (foreach #fullpath &fullpath$
      (princ (strcat "\n" #fullpath) #fil)
    )
    (princ "\n" #fil)
    (princ)
  )
  ;/////////////////////////////////////////////////////////////////////////////

  ;�����߽
  (setq #SG_path "E:\\works\\KPCAD\\PLAN\\SG")
  (setq #SX_path "E:\\works\\KPCAD\\PLAN\\X")
  (setq #fullpathSG$ nil) ; �X�V�ΏۑS���߽

  ;̧�ٵ����
  (setq #fil (open (strcat CG_SYSPATH "plan.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n" #fil)

  ;����
  (setq #fullpathSG$ (##KENSAKU #SG_path))
  (setq #fullpathSX$ (##KENSAKU #SX_path))

  ;�o��
  (##PRINT #fullpathSG$)
  (##PRINT #fullpathSX$)

  (if #fil
    (progn
      (close #fil)
      (princ "\ņ�قɏ������݂܂���.")
      (startapp "notepad.exe" (strcat CG_SYSPATH "plan.txt"))
    )
  );_if
  (princ)
);All_dwg

;*****************************************************************************:
; �i�Ԃ̕ϊ��c�[��
; �ꏊ�F CG_SYSPATH \TEMP
;*****************************************************************************:
(defun C:Henkan (
  /

  )
  ;// �R�}���h�̏�����
  (StartUndoErr)
;;;CG_SeriesCode

  ;�Sں��ނ��擾
  (setq #rec01$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from SINK�Ǘ�")))
  (setq #rec02$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �v���\OP")))
  (setq #rec03$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �v���\��")))
  (setq #rec04$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �����\��"))) ; nth 2
  (setq #rec05$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �K�w" CG_SeriesCode)))
  (setq #rec06$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �i�ԍŏI")))
;;; (setq #rec1$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �i�ԃV��")))
;;; (setq #rec1$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �i�Ԋ�{")))
;;; (setq #rec1$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �i�Ԑ}�`")))

;;; (setq #ifname (strcat CG_SYSPATH "TEMP\\" CG_SeriesCode "-hinban.txt"))
;;; (setq #hinban$$ (ReadCSVFile #ifname))
;;; (setq #hinban$ (mapcar 'car #hinban$$))

  (setq #CH$$
    (list
      (list "VB-120E"     "VB-120")
      (list "VB-135BLS"   "VB-135B")
      (list "VB-135E"     "VB-135")
      (list "VB-140BLS"   "VB-140B")
      (list "VB-140E"     "VB-140")
      (list "VB-30E"      "VB-30")
      (list "VB-45E"      "VB-45")
    )
  )

  (setq #fp (open #ofile "w"))
  (setq #NewList$$ nil)
  (foreach #List$ #List$$
    (setq #str (nth 2 #List$))
    (if (= (substr #str 1 1) "G") ; �擪����"G"=>"V"
      (progn
        (setq #newstr (strcat "V" (substr #str 2 (1- (strlen #str)))))
        ; �����ϊ�ؽĂɂ�������X�ɕi�ԕϊ�
        (foreach #CH$ #CH$$
          (if (= (car #CH$) #newstr)
            (setq #newstr (cadr #CH$))
          );_if
        )
        (setq #NewList$ (subst #newstr #str #List$))
      )
      (setq #NewList$ #List$)
    );_if
    (setq #NewList$$ (append #NewList$$ (list #NewList$)))
  )

  ; �ǉ�ں��ލ쐬
  (setq #n 1)
  (foreach #NewList$ #NewList$$
    (setq #i 1)
    (foreach #NewList #NewList$
      (if (= #i 1)
        (princ #NewList #fp)
        (princ (strcat "," #NewList) #fp)
      );_if
      (setq #i (1+ #i))
    )
    (princ "\n" #fp)
    (setq #n (1+ #n))
  )

  (close #fp)

  (setq *error* nil)
  (princ)
);C:Henkan

;*****************************************************************************:
; �����\���e�[�u���쐬�c�[��(��ۉ��I����)
; �g�p�ꏊ: CG_SYSPATH \DATA
; 03/09/17 YM
; �ȉ���CSV̧�ق���������

;;;�����L���r.csv
;;;GT-15E,R
;;;GT-15B,R
;;;GT-15K,R
;;;...

;;;�I�[�u��.csv
;;;DR-505E,Z
;;;DR-505C,Z
;;;DR-404E,Z
;;;DR-404ESV,Z
;;;...

;;;�R����.csv
;;;RBG-31A6S-BG,Z
;;;DG3295NQ1,Z
;;;RBG-31A6S-SVG,Z
;;;RBG-31A6FS-B,Z
;;;...

;;;�����\���̐��`CSV̧��(�����\��.csv)
;;;10001,1,����,R,850,0,0,0,0,0
;;;10001,2,�I�[�u��,Z,850,0,1,0,0,0
;;;10001,3,�R����,Z,850,0,2,2,0,0
;;;10002,1,����,R,850,0,0,0,0,0
;;;10002,2,�I�[�u��,Z,850,0,1,0,0,0
;;;10002,3,�R����,Z,850,0,2,2,0,0
;;;10002,4,YT-15S,R,850,0,1,0,0,0

;*****************************************************************************:
(defun C:OBUN (
  /
  #CAB #CAB-KIGO #CAB-LR #DUM$ #FP1 #GAS #GAS-KIGO #GAS-LR #HINBAN #HUKU_ID #I #ID$
  #IFNAME1 #IFNAME2 #IFNAME3 #IFNAME4 #J #K #KIGO$ #LIST1$$ #LIST2$$ #LIST3$$ #LIST4$$
  #LR #N #NEWLIST$ #NEWLIST$$ #OBN #OBN-KIGO #OBN-LR #OFNAME1 #PTN #XXX
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)

        ;/////////////////////////////////////////////////////////////////
        (defun ##OUTPUT (
          &LIS$$ ; �o��ؽ�
          &fp    ; ̧�َ��ʎq
          /
          #I #N
          )
          (setq #n 1)
          (foreach #NewList$ &LIS$$
            (setq #i 1)
            (foreach #NewList #NewList$
              (if (= #i 1)
                (princ #NewList &fp)
                (princ (strcat "," #NewList) &fp)
              );_if
              (setq #i (1+ #i))
            )
            (princ "\n" &fp)
            (setq #n (1+ #n))
          )
          (close &fp)
          (princ)
        )
        ;/////////////////////////////////////////////////////////////////
        (defun ##findfile ( &path / )
          (if (= nil (findfile &path))
            (progn
              (CFAlertErr (strcat &path " ������܂���"))
              (quit)
            )
          );_if
          (princ)
        )
        ;/////////////////////////////////////////////////////////////////

  ; ��ۋL�� �S����36��ނ܂ŉ\
  (setq #kigo$ (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"
                     "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
                     "U" "V" "W" "X" "Y" "Z" "1" "2" "3" "4"
                     "5" "6" "7" "8" "9" "0"))
  (setq #ifname1 (strcat CG_SYSPATH "DATA\\" "�R����.csv"))      ; ��ۑI����̧��(���̐���ٰ��)
  (setq #ifname2 (strcat CG_SYSPATH "DATA\\" "�I�[�u��.csv"))    ; ����ݑI����̧��(���̐���ٰ��)
  (setq #ifname3 (strcat CG_SYSPATH "DATA\\" "�����L���r.csv"))  ; �������ޑI����̧��(���̐���ٰ��)
  (setq #ifname4 (strcat CG_SYSPATH "DATA\\" "�����\��.csv"))    ; ���`�ƂȂ镡���\��ð���ں���
  (setq #ofname1 (strcat CG_SYSPATH "DATA\\" "�����\��-OUT.csv")); �o��̧��(�����\��)
  ;̧�ق̗L������
  (##findfile #ifname1)
  (##findfile #ifname2)
  (##findfile #ifname3)
  (##findfile #ifname4)
  ; CSV۰��
  (setq #List1$$ (ReadCSVFile #ifname1)) ; ��ۑI����̧��
  (setq #List2$$ (ReadCSVFile #ifname2)) ; ����ݑI����̧��
  (setq #List3$$ (ReadCSVFile #ifname3)) ; �������ޑI����̧��
  (setq #List4$$ (ReadCSVFile #ifname4)) ; ���`�����\��
  ; ��ۑI�����̐�����
  (if (< 36 (length #List1$$))
    (progn
      (CFAlertErr "��ۂ̑I�����̐���36���z���Ă��邽��\n��ۋL����2���ɂ��Ȃ��Ƃ����܂���")
      (quit)
    )
  );_if

  (setq #id$ (mapcar 'car #List4$$)) ; ����ID��ؽ�
  (setq #dum$ nil)
  ; ����ID��ؽĂ���d�������O
  (foreach #id #id$
    (if (= nil (member #id #dum$))
      (setq #dum$ (append #dum$ (list #id)))
    );_if
  )
  ; �����\��������ݐ�(�I����"A"�̂�)�����߂�
  (setq #ptn (length #dum$))

  ;�������@Ҳݏ������s�@������
  (setq #NewList$$ nil) ; �����\��(�o�͗pؽ�)
  (princ "\n")(princ (strcat "�ް��쐬��...")) ; ����ײ�
  (setq #i 0)
  (setq #n 0)                                  ; ����ID�p�ԍ�
  ; *** ��� ***
  (foreach #List1$ #List1$$                    ; ��ۑI������ٰ��
    (setq #GAS    (car  #List1$))              ; �޽�i��
    (setq #GAS-LR (cadr #List1$))              ; �޽LR�敪
    (setq #GAS-kigo (nth #i #kigo$))
    (princ "\n")(princ (strcat "���=" #GAS-kigo)); ����ײ�
  ; *** ����� ***
    (setq #j 0)
    (foreach #List2$ #List2$$                  ; ����ݑI������ٰ��
      (setq #OBN    (car  #List2$))            ; ����ݕi��
      (setq #OBN-LR (cadr #List2$))            ; �����LR�敪
      (setq #OBN-kigo (nth #j #kigo$))
      (princ "\n")(princ (strcat "�����=" #OBN-kigo)); ����ײ�
  ; *** �������� ***
      (setq #k 0)
      (foreach #List3$ #List3$$                ; �������ޑI������ٰ��
        (setq #CAB    (car  #List3$))          ; �������ޕi��
        (setq #CAB-LR (cadr #List3$))          ; ��������LR�敪
        (setq #CAB-kigo (nth #k #kigo$))
  ; *** �����\�� ***
        (foreach #List4$ #List4$$                  ; ���`ں��ޕ�ٰ��(�����\��)
          (setq #huku_ID (atoi (nth 0 #List4$)))   ; �I����"A"��ID
          (setq #huku_ID (itoa (+ #huku_ID (* #ptn #n))))
          (setq #XXX (nth 2 #List4$)) ; �i�Ԃ������镔��
          (cond
            ((= "����" #XXX)
              (setq #hinban #CAB)
              (setq #LR #CAB-LR)
            )
            ((= "�I�[�u��" #XXX)
              (setq #hinban #OBN)
              (setq #LR #OBN-LR)
            )
            ((= "�R����" #XXX)
              (setq #hinban #GAS)
              (setq #LR #GAS-LR)
            )
            (T ; ����ȊO�͐G��Ȃ�
              (setq #hinban (nth 2 #List4$))
              (setq #LR     (nth 3 #List4$))
            )
          );_cond

          ; ؽĂ̕i�Ԃ����ւ���
          (setq #NewList$
            (CFModList #List4$
              (list
                (list 0 #huku_ID)
                (list 2 #hinban)
                (list 3 #LR)
              )
            )
          )
          (setq #NewList$$ (append #NewList$$ (list #NewList$)))
        );_foreach
        (setq #n (1+ #n)) ; ����ID�p�ԍ�
        (setq #k (1+ #k))
      );_foreach
      (setq #j (1+ #j))
    );_foreach
    (setq #i (1+ #i))
  );_foreach

  (princ "\n")(princ (strcat "�ް��o�͒�...")) ; ����ײ�

  (setq #fp1 (open #ofname1 "w"))
  (if (= nil #fp1)
    (progn
      (CFAlertErr "�o��̧�ق��J���܂���")
      (quit)
    )
  );_if

  ; ̧�ُo��(csv�`��)�����\��
  (##OUTPUT #NewList$$ #fp1)
  (princ "\n*** �o�͏I�� ***")
  (princ "\n")(princ #ofname1)
  (setq *error* nil)
  (princ)
);C:OBUN


;*****************************************************************************:
; ÷��̧�ق̕i��,LR����}�`ID���擾���Č��ʂ��e�L�X�g�o��
; �g�pfile: CG_SYSPATH \log\Hinban.txt
; 06/09/01 YM
;*****************************************************************************:
(defun C:CheckHinbanZukei (
  /
  #FP #HINBAN #IFNAME1 #J #LIST1$$ #LR #OFNAME1 #QRY$$ #ZUKEIID #DOORID
	#DoorID_out #layer_out
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)

  (setq #ifname1 (strcat CG_SYSPATH "LOG\\" "Hinban.txt"))
  (setq #ofname1 (strcat CG_SYSPATH "LOG\\" "HinbanZukei.txt"))

  (setq #fp (open #ofname1 "w"))

  (if (= nil (findfile #ifname1))
    (progn
      (CFAlertErr (strcat #ifname1 " ������܂���"))
      (quit)
    )
  );_if

  (setq #List1$$ (ReadCSVFile #ifname1));ؽēǂݍ���

  (princ (strcat "\n�i��,LR,�}�`ID,��ID,��w") #fp)
  (setq #j 0)
  (foreach #List1$ #List1$$       ; �i�Ԃ̐�ٰ��
    (setq #Hinban (car  #List1$)) ; �i��
    (setq #LR     (cadr #List1$)) ; LR�敪

    (setq #qry$$
      (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
        (list
          (list "�i�Ԗ���" #Hinban 'STR)
          (list "LR�敪"   #LR     'STR)
        )
      )
    )
    (if (= #qry$$ nil)
      (setq #ZukeiID "-")
      ;else
      (if (= 1 (length #qry$$))
        (progn
          (setq #ZukeiID (nth 6 (car #qry$$)));2008/06/28 OK!
          (if (or (= nil #ZukeiID)(= "" #ZukeiID))
            (setq #ZukeiID "-")
          );_if
        )
        ;else
        (setq #ZukeiID "�����R�[�h������")
      );_if
    );_if

    (setq #qry$$
      (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
        (list
          (list "�i�Ԗ���" #Hinban 'STR)
          (list "LR�敪"   #LR     'STR)
        )
      )
    )
    (if (= #qry$$ nil)
      (setq #DoorID "-")
      ;else
      (if (= 1 (length #qry$$))
        (progn
          (setq #DoorID (nth 4 (car #qry$$)));2008/06/28 OK!
          (if (or (= nil #DoorID)(= "" #DoorID))
            (progn
              (setq #DoorID_out "-")
              (setq #layer_out  "-")
            )
            (progn
              (setq #DoorID_out (substr #DoorID 1 5))
              (setq #layer_out  (substr #DoorID 6 2))
            )
          );_if
        )
        ;else
        (setq #DoorID "�����R�[�h������")
      );_if
    );_if

    (if (= nil #ZukeiID)(setq #ZukeiID "-"))
    (if (= nil #DoorID_out)(setq #DoorID_out "-"))
    (if (= nil #layer_out)(setq #layer_out "-"))
    (princ (strcat "\n" #Hinban "," #LR "," #ZukeiID "," #DoorID_out "," #layer_out) #fp)
    (setq #j (1+ #j))
  );foreach

  (close #fp)  ;// ̧�ٸ۰��
  (princ "\n*** �o�͏I�� ***")
  (startapp "notepad.exe" #ofname1)
  (setq *error* nil)
  (princ)
);C:CheckHinbanZukei


;;;<HOM>*************************************************************************
;;; <�֐���>    : GetZumenZukeiID
;;; <�����T�v>  : �}�ʏ�ɂ��镔�ނ̐}�`ID��÷�ďo��
;;; <�߂�l>    : 
;;; <�쐬>      : 06/06/22 YM ADD
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun C:GetZumenZukeiID (
  /
  #HIN #I #ID #LR #SS #SYM #XD$
	#SKK
  )
  (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; �}�ʏ��G_LSYM
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (princ (strcat "\nG_LSYM�����}�`��:" (itoa (sslength #ss))))
      (repeat (sslength #ss)
        (princ "\n--------------------------")
        (setq #sym (ssname #ss #i))
        (setq #xd$ (CFGetXData #sym "G_LSYM"))
        (setq #id  (nth 0 #xd$))
        (setq #hin (nth 5 #xd$))
        (setq #LR  (nth 6 #xd$))
        (setq #SKK (nth 9 #xd$))
        (princ (strcat "\n�i��:"   #hin))
        (princ (strcat "\nL/R:"    #LR))
        (princ (strcat "\n�}�`ID:" #id))
        (princ (strcat "\n���iCODE:" (itoa #SKK)))
        (setq #i (1+ #i))
      );_repeat

    )
  );_if

  (princ "\n--------------------------")

  (princ)
);PKOutputWTCT


;;;<HOM>*************************************************************************
;;; <�֐���>     : C:slide
;;; <�����T�v>   : [�i�Ԑ}�`]���Q�Ƃ��Ľײ��̧�ق̘R�����������
;;;                �Ώۼذ�ނ́A�`\system\log\slide_seri.txt
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 05/12/21 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun C:slide (
  /
  #CG_SERIESCODE #CG_SERIESDB #CSV$$ #DATE_TIME #DUM$$ #FIL #IFILE #KOSU #MDB
  #N #REC$$ #SERI #SERI$$ #ZUKEIID #ZUKEIID$ #HINBAN #NG-S #NG-Z
  )

    ;;;**********************************************************************
    ;;; ؽĂ̏d�����R�[�h������
    ;;; 05/06/01 YM
    ;;;**********************************************************************
    (defun ##delREC0 (
      &lis$ ; #hin$��ؽČ`��
      /
      #DUM$ #HIN #HIN$ #LIS$ #RET$
      )
      (setq #dum$ nil #hin$ nil)
      (foreach #lis &lis$
        (setq #hin #lis)
        (if (member #hin #hin$)
          nil
          ;else
          (setq #dum$ (cons #lis #dum$))
        );_if
        (setq #hin$ (cons #hin #hin$))
      )
      (setq #ret$ #dum$)
      #ret$
    );##delREC0


  (setq #CG_SeriesDB CG_SeriesDB)
  (setq #CG_SeriesCode CG_SeriesCode)

  (setvar "CMDECHO" 0)
  (C:de0)

  (setq #fil (open (strcat CG_SYSPATH "LOG\\SLIDE-CHECK.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n�ײ��̧��,�}�`̧�ق��Ȃ����̂𒊏o" #fil)
  (princ "\n" #fil)

  ;�Ώۼذ�ޏ��
  (setq #ifile (strcat CG_SYSPATH "LOG\\SLIDE_seri.txt"));�����Ώۼذ�ނ̓ǂݍ���
  (setq #CSV$$ (ReadCSVFile #ifile))
  ;�擪��";"���������珜��
  (setq #dum$$ nil)
  (foreach #CSV$ #CSV$$
    (setq #MDB (nth 0 #CSV$))
    (setq #seri (nth 1 #CSV$))
    (if (= ";" (substr #MDB 1 1))
      nil
      ;else
      (progn
        (setq #dum$$ (append #dum$$ (list (list #MDB #seri))))
      )
    );_if
  );foreach
  (setq #seri$$ #dum$$)


  
  (setq #zukeiID$ nil)
  (foreach #seri$ #seri$$ ; �e�ذ�ނł�loop
    (setq CG_SeriesDB (nth 0 #seri$))
    (setq CG_SeriesCode (nth 1 #seri$))
    (setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))
    (princ (strcat "\n�ذ��:" CG_SeriesDB))
    ;��[�i�Ԑ}�`]��-----------------------------------------------
    (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "�i�Ԑ}�`")))
    (foreach #rec$ #rec$$
      (setq #hinban  (nth 0 #rec$))
      (setq #zukeiID (nth 6 #rec$));2008/06/28 OK!
      (if (or (= #zukeiID nil)(= #zukeiID ""))
        (princ (strcat "\n�}�`ID����`: " #hinban "," CG_SeriesDB) #fil)
        ;else
        (progn
          (setq #zukeiID$ (append #zukeiID$ (list #zukeiID)))
        )
      );_if
    )
  );foreach

  ;�d��ں��ނ�����
  (setq #zukeiID$ (##delREC0 #zukeiID$))


  (setq #n 0)(setq #kosu (length #zukeiID$))
  (princ (strcat "\n��������: " (itoa #kosu)) #fil)
  (princ (strcat "\n��������: " (itoa #kosu)))

  ;�ײ��̧�ق̑�������
  (setq #NG-z 0)
  (setq #NG-s 0)
  (foreach #zukeiID #zukeiID$
    (if (and (/= #n 0)(= 0 (rem #n 100)))
      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
    );_if

    (if (findfile (strcat CG_SKDATAPATH "MASTER\\" #zukeiID ".dwg"))
      nil
      ;else
      (progn
        (setq #NG-z (1+ #NG-z))
        (princ (strcat "\n�}�`̧�ق��Ȃ�: " #zukeiID ".dwg") #fil)
      )
    );_if

    (if (findfile (strcat CG_SKDATAPATH "CRT\\" #zukeiID ".sld"))
      nil
      ;else
      (progn
        (setq #NG-s (1+ #NG-s))
        (princ (strcat "\n�ײ��̧�ق��Ȃ�: " #zukeiID ".sld") #fil)
      )
    );_if

    (setq #n (1+ #n))
  );foreach

  (princ (strcat "\n�}�`NG��: " (itoa #NG-z)) #fil)
  (princ (strcat "\n�}�`NG��: " (itoa #NG-z)))
  (princ (strcat "\n�ײ��NG��: " (itoa #NG-s)) #fil)
  (princ (strcat "\n�ײ��NG��: " (itoa #NG-s)))

  (princ "\n" #fil)
  (princ "\n")

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������

  (princ "\n")
  (princ "\n" #fil)
  (princ "\n�����`�F�b�N�I������")
  (princ "\n�����`�F�b�N�I������" #fil)
  (close #fil)


  ;// ���̃f�[�^�x�[�X�ɐڑ�����
  (setq CG_SeriesDB #CG_SeriesDB)
  (setq CG_SeriesCode #CG_SeriesCode)

  (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))

  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\SLIDE-CHECK.txt"))
  (princ)
);C:slide


;;;<HOM>*************************************************************************
;;; <�֐���>     : C:zokusei_check
;;; <�����T�v>   : �����̕i��,���z,���i����csv��ǂ�ő��݃`�F�b�N
;;;                CG_SYSPATH \LOG\NCA-ZOKUSEI.csv(NCA������mdb��)
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 06/10/10 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun C:zokusei_check (
  /
  #CG_SERIESCODE #CG_SERIESDB #DATE_TIME #FIL #HINBAN #HINMEI #IFNAME #LIST$$ #OFNAME
  #REC_BASE$$ #REC_KAI$$ #REC_SERI$$ #YEN
  )

    ;;;**********************************************************************
    ;;; ؽĂ̏d�����R�[�h������
    ;;; 05/06/01 YM
    ;;;**********************************************************************
    (defun ##delREC0 (
      &lis$ ; #hin$��ؽČ`��
      /
      #DUM$ #HIN #HIN$ #LIS$ #RET$
      )
      (setq #dum$ nil #hin$ nil)
      (foreach #lis &lis$
        (setq #hin #lis)
        (if (member #hin #hin$)
          nil
          ;else
          (setq #dum$ (cons #lis #dum$))
        );_if
        (setq #hin$ (cons #hin #hin$))
      )
      (setq #ret$ #dum$)
      #ret$
    );##delREC0


  (setq #CG_SeriesDB CG_SeriesDB)
  (setq #CG_SeriesCode CG_SeriesCode)

  (setvar "CMDECHO" 0)
  (C:de0)

  (setq #ifname (strcat CG_SYSPATH "LOG\\" CG_SeriesDB "-ZOKUSEI.csv")); ����̧��
  (setq #ofname (strcat CG_SYSPATH "LOG\\" CG_SeriesDB "-ZOKUSEI.out")); �o��̧��

  (setq #fil (open #ofname "w"))
  (setq #List$$ (ReadCSVFile #ifname))

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n*** �����f�[�^�o�^���� ***" #fil)
  (princ "\n" #fil)
  (princ (strcat "\n�ذ��:" CG_SeriesDB) #fil)
  (princ "\n" #fil)

  (foreach #List$ #List$$
    (setq #hinban (nth 0 #List$))
    (setq #yen    (nth 1 #List$))
    (setq #yen    (atof #yen))
    (setq #hinmei (nth 2 #List$))
    ;�K�w�ɑ��݂��邩
    (setq #rec_kai$$
      (CFGetDBSQLRec CG_DBSESSION (strcat "�K�w" CG_SeriesCode)
        (list
          (list "�K�w����"  #hinban 'STR)
        )
      )
    )
    (if (= nil #rec_kai$$)
      (princ (strcat "\n��[�K�w]�o�^�R��: " "�i�Ԗ���=" #hinban) #fil)
    );_if

    ;"���i��"�������Ă邩
    (if #rec_kai$$
      (if (= #hinmei (nth 7 (car #rec_kai$$)))
        nil
        ;else
        (progn
          (princ (strcat "\n��[�K�w]���i���s����: �i�Ԗ���=" #hinban ",�o�^���i��=" (nth 7 (car #rec_kai$$)) ",�������i��=" #hinmei) #fil)
        )
      );_if
    );_if

    ;�i�Ԋ�{�ɑ��݂��邩
    (setq #rec_base$$
      (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
        (list
          (list "�i�Ԗ���"  #hinban 'STR)
        )
      )
    )
    (if (= nil #rec_base$$)
      (princ (strcat "\n��[�i�Ԋ�{]�o�^�R��: " "�i�Ԗ���=" #hinban) #fil)
    );_if

    ;"���z"�������Ă邩
    (if #rec_base$$
      (if (equal #yen (nth 14 (car #rec_base$$)) 0.001);�i�Ԋ�{
        nil
        ;else
        (progn
          ;�i�ԃV���ɑ��݂��邩
          (setq #rec_seri$$
            (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
              (list
                (list "�i�Ԗ���"  #hinban 'STR)
              )
            )
          )

          (if (= nil #rec_seri$$)
            (princ (strcat "\n��[�i�ԃV��]�o�^�R��^��: " "�i�Ԗ���=" #hinban) #fil)
          );_if

          (if #rec_seri$$
            (if (equal #yen (nth 8 (car #rec_seri$$)) 0.001);�i�ԃV��
              nil
              ;else
              (princ (strcat "\n�����z�s����: �i�Ԗ���=" #hinban ",�������z=" #yen) #fil)
            );_if
          );_if

        )
      );_if
    );_if

  );_foreach

  (princ "\n" #fil)
  (princ "\n")
  (princ "\n�����`�F�b�N�I������")
  (princ "\n�����`�F�b�N�I������" #fil)
  (close #fil)

  (startapp "notepad.exe" #ofname)
  (princ)
);C:zokusei_check


;//////////////////////////////////////////////////////////
; ���݌�������ý� 07/05/10 YM
; AP�Ή��V�Ƽݸ�̐}�`����dwg�ۑ�
;//////////////////////////////////////////////////////////
(defun C:AUTO_PLAN_WT_SINK (
  /
  #CASE_LIS #LOOP #NEND #NO #NSTART
  #DWG #EN #HINBAN #RET #SKK #SS #SSMOVE #SSSINK #SSWT #SYM #WT #XD_SYM$ #XD_WTSET$
  )
  (setq CG_TESTMODE 1)    ;ý�Ӱ��
  (setq CG_AUTOMODE 0)    ;����Ӱ��
  (setq CG_DEBUG 0)       ;���ޯ��Ӱ��

  (princ "\n�v����������A�����s���܂�")
  (setq #nStart (getint "\n�J�n�ԍ������(1001�`): "))
  (setq #nEnd   (getint "\n�I���ԍ������: "))
  (setq #loop (1+ (- #nEnd #nStart)))

  (setq #case_lis '())
  (setq #case_lis (RepeatPlan #nStart #loop #case_lis)) ; �J�n�ԍ�,�J��Ԃ���

  (foreach #i #case_lis
    (setq CG_TESTCASE #i)
    (setq #no (strcat "case" (itoa #i)))

    (setq CG_KENMEI_PATH (strcat CG_KENMEIDATA_PATH #no "\\")) ; \BUKKEN\case?
    (setq S_FILE (strcat CG_KENMEI_PATH "MODEL.DWG")) ; \BUKKEN\case?\DWG���߽

    (if (= (getvar "DWGPREFIX") CG_KENMEI_PATH)
      (progn
        (CFAlertMsg (strcat "\n ̫��ލ폜�ł��Ȃ����߁AýđΏۈȊO����а�����Ɉړ����ĉ�����."
                            "\n(������x�}�ʂ��J�������ĉ�����)"))
        (quit)
      )
    );_if

    ;// case? �t�H���_�폜
    (vl-file-delete (strcat CG_KENMEI_PATH "MODEL.DWG"))
    (vl-file-delete (strcat CG_KENMEI_PATH "MODEL.BAK"))

    (setq CG_OpenMode 0)
    (vl-file-copy (strcat CG_SYSPATH "ORGMODEL.DWG") S_FILE)

    (if (/= (getvar "DBMOD") 0)
      (progn
        (command "_qsave")
        (vl-cmdf "._open" S_FILE)
      )
      (progn
        (vl-cmdf "._open" S_FILE)
      )
    );_if

    (S::STARTUP)
    (C:SearchPlan) ; ���݌��� �J�n

    ;07/05/10 YM �V�¼ݸ�ȊO�͍폜����(���ݔz�u�㏈��)
    (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
    (setq #i 0)
    (repeat (sslength #ss)
      (setq #sym (ssname #ss #i))
      (setq #xd_SYM$ (CFGetXData #sym "G_LSYM"))
      (setq #skk (nth 9 #xd_SYM$))
      (if (= #skk 410)
        nil ;�ݸ�̏ꍇ
        (progn
          (command "_erase" (CFGetSameGroupSS #sym) "");���ލ폜
        )
      );_if
      (setq #i (1+ #i))
    );repeat

    ;��w"Z_00","Z_00_00_00_01" �ȊO�S�č폜
    (setq #ss     (ssget "X"))
    (setq #ssWT   (ssget "X" '((8 . "Z_00"))))
    (setq #ssSINK (ssget "X" '((8 . "Z_00_00_00_01"))))

    (setq #i 0)
    (repeat (sslength #ss)
      (setq #en (ssname #ss #i))
      (if (and (= (ssmemb #en #ssWT) nil)
               (= (ssmemb #en #ssSINK) nil))
        (entdel #en)
      );_if
      (setq #i (1+ #i))
    );repeat

    ;�s�v�ȸ�ٰ�ߒ�`���폜����
    (KP_DelUnusedGroup)
    ;�s�v��w,���@����,�������,�������ٍ폜
    (command "_purge" "A" "*" "N")
    ;�V�̈ړ�
    (setq #ssMOVE (ssget "X"))
    (command "_move" #ssMOVE "" "0,0,0" "@0,0,-829") ;�ړ�

    ;���ѕϐ�
    (setvar "SNAPMODE"  0)
    (setvar "GRIDMODE"  0)
    (setvar "ORTHOMODE" 0)
    (setvar "OSMODE"    0)
    (setvar "AUTOSNAP"  0)
    (setvar "GRIPS"     1)
    (setvar "PICKFIRST" 1)
    ;�����ύX
    (command "vpoint" "0,0,1")
    (command "_zoom" "e")

    ;�l��,L�^�̏ꍇ��ۑ��V���폜����
    (if (and (/= (nth 16 CG_GLOBAL$) "Z")(/= (nth 16 CG_GLOBAL$) "SE"));�l��,L�^�̏ꍇ
      (progn
        (setq #ssWT (ssget "C" '(1000 -1000) '(-1000 -1000) (list (list -3 (list "G_WRKT")))))
        (command "_.erase" #ssWT "") ; �폜����
      )
    );_if

    ;WT�i�Ԃ̖��O��dwg�ۑ�
    (setq #ssWT   (ssget "X" '((8 . "Z_00"))));�ēxWT������
    (setq #WT (ssname #ssWT 0))
    (setq #xd_WTSET$ (CFGetXData #WT "G_WTSET"))
    (setq #hinban (nth 1 #xd_WTSET$))
    ;̧�ٖ����H
    (setq #hinban (strcat (substr #hinban 1 2) "__" (substr #hinban 5 5) "_" (substr #hinban 11)))
    (setq #dwg (strcat CG_SYSPATH "TMP\\" #hinban ".dwg"))
    (command "_.QSAVE")
    ;̧�ق����݂�����폜����
    (vl-file-delete #dwg)
    ;̧�ٺ�߰
    (setq #ret (vl-file-copy S_FILE #dwg))
    (setq #i (1+ #i))
  );foreach

  ; �ۑ�
  (command "_.QSAVE")

  (setq CG_TESTMODE nil) ;ý�Ӱ��
  (setq CG_AUTOMODE 0)   ;����Ӱ��
  (setq *error* nil)
  (princ)
);C:AUTO_PLAN_WT_SINK


;//////////////////////////////////////////////////////////
(defun C:APWT (
  /
  )
  (C:AUTO_PLAN_WT_SINK)
  (princ)
)


;-- 2011/11/08 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KAIHUKU
;;; <�����T�v>  : �����I��AutoCAD��̐}�ʂ�"Model.dwg"[�o�͊֌W���j���[]��
;;;             : �߂�
;;; <�쐬>      : 11/11/08  A.Satoh
;;;*************************************************************************>MOH<
(defun C:KAIHUKU (
	/
	#sFname
	)

  (if (/= nil CG_KENMEI_PATH)
    (progn
			; ���C�A�E�g�o�͏������r�����f���Ă���ꍇ�́A�����I�ɖ���������
			(setq CG_OpenMode nil)

			; �����}�ʖ����擾����
			(setq #sFname (strcat CG_KENMEI_PATH "MODEL.dwg"))

			(cond
				((= (strcase (getvar "DWGNAME")) "MODEL.DWG")
					(CFAlertMsg "�����}�ʂ��J����Ă��܂��B�񕜂̕K�v�͂���܂���B")
				)
				(T
		      ; �o�͊֌W���j���[�ɐ؂�ւ���
    		  (ChgSystemCADMenu "PLOT")

					(if (member CG_AUTOMODE '(1 2 3))
						(progn
							(if (= 0 (getvar "DBMOD"))
								(command "_.Open" #sFName)
								(command "_.Open" "Y" #sFName)
							)
							(setq CG_OpenMode nil)
							(S::STARTUP)
						)
						(SCFCmnFileOpen #sFName 1)
					)
				)
			)
		)
		(CFAlertMsg "�������Ăяo����Ă��܂���.")
	)

  (princ)

)
;-- 2011/11/08 A.Satoh Add - E

(princ)