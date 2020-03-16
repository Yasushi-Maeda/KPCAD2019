;;; ****************************************************
;;; ** �d�v:WT�����������̍��W�ʒu(�ϐ�����"#"�͏ȗ�) **
;;; ****************************************************
; BG����=p2,p22�̋���
; FG����=p33,p333�̋���
;;; ��I�^��
;;;                        ptA<--D��ėp
;;;  BASE=p4----------+-----+-+-----+p2   <---BG�w��(PMEN2�̒��_�ʒu)
;;;  |                |     | |     |
;;;  +p44             | ptAA+ |     +p22  <---BG�O��
;;;  |                |     | |     |
;;;  |                | ����| |     |
;;;  +p333            | ptBB+ |     +p111 <---FG�w��
;;;  |                |     | |     |
;;;  +p3              |     | |     +p1   <---PMEN2�̒��_�ʒu
;;;  +p33-------------+-----+-+-----+p11  <---FG�O��(�O�����ė���׽)
;;;                        ptB<--D��ėp

;;; ��L�^��            x11  x1            (D��Ĉʒu)
;;; p1+---+-------------*---*------------A--------+p2   <---BG�w��(PMEN2�̒��_�ʒu)
;;;   |   end1          |   |            |        |
;;;   +   +p11----------|dum|------------AA-------+p22  <---BG�O��
;;; end2  |             |   |            |        |
;;;   |   |             |   |            |        | x1,x2 x11,x22�͂���ς�邩������Ȃ�
;;;   |   |             |   |            |        |
;;;   |   |     +p444---|---|------------BB-------+p333 <---FG�w��
;;;   |   |     |       |   |            |        |
;;;x22*---dum---------- *sp1|            |        |
;;;   |   |     |           |            |        |
;;;   |   |     |       p4+-|- - - - - - | - - - -+p3   <---PMEN2�̒��_�ʒu
;;; x2*-------------------- *p44---------B--------+p33  <---FG�O��(�O�����ė���׽)
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   A---AA----BB--------|-B(D��Ĉʒu)
;;;   |   |     |           |
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55

;;; ��U�^��
;;;       end1     x11 x1
;;; p1+(BASE1)-----*---*------------------------+p2   <---BG�w��(PMEN2�̒��_�ʒu)
;;;   |   |        |   |                        |
;;; end2--+p11-----dum1|------------------------+p22  <---BG�O��
;;;   |   |        |   |                        |
;;;   |   |     +p444--|------------------------+p333 <---FG�w��
;;;   |   |     |  |   |                        |
;;;x22* - dum2- - -*sp1|             �ݸ��      | x1,x2 x11,x22�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp1��J��Ď��̕���_
;;;   |   |     |      |                        |
;;;   |   |     |    +p4------------------------+p3   <---PMEN2�̒��_�ʒu
;;; x2* - - - - - - - -+------------------------+p33  <---FG�O��(�O�����ė���׽)
;;;   |   |     |    | |p44
;;;   |   |     |    | |
;;;   |   |��ۑ�|    | |
;;;   |   |     |    | |
;;;   |   |     |    | |
;;; x3* - - - - - - - -+p55----------------------+p66  <---FG�O��(�O�����ė���׽)
;;;   |   |     |    +p5-------------------------+p6   <---PMEN2�̒��_�ʒu
;;;   |   |     |      |                         |
;;;x33* - dum3- - -*sp2|          ���̑�         | x3,x4 x33,x44�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp2��J��Ď��̕���_
;;;   |   |     |  |   |                         |
;;;   |   |     +p555--|-------------------------+p666 <---FG�w��
;;;   |   |        |   |                         |
;;; end3--+p88-----dum4|-------------------------+p77  <---BG�O��
;;;   |   |        |   |                         |
;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG�w��(PMEN2�̒��_�ʒu)
;;;       end4    x44 x4

;;; <�����p�֐��ꗗ>
; WT�����֘A
;;;(defun C:PosWKTOP              ���[�N�g�b�v���������i�C�Ӕz�u�j
;;;(defun C:MakeWKTOP �i�C�Ӕz�u�j���[�N�g�b�v�ʐ��� I�^�̂ݑΉ�
;;;(defun PKStartWKTOP            ��۰���,���ѕϐ��̐ݒ�Ȃ�
;;;(defun PKEndWKTOP              ��۰���,���ѕϐ��̐ݒ�Ȃǂ�߂�
;;;(defun PKCheckBaseCab          entsel�}�`���ް����ނ�����
;;;(defun PKExistWTDel            ����WT�����邩�ǂ������ׂ� ��������폜���邩�ǂ�������
;;;(defun PKExistWTDelSmallArea   ����WT�����邩�ǂ������ׂ�  ��������폜���邩�ǂ�������
; �אڷ��ނ̌���
;;;(defun SKW_GetLinkBaseCab
;;;(defun SKW_GetLinkUpperCab
;;;(defun SKW_GetLinkCab
;;;(defun SKW_SearchLinkBaseSym
;;;(defun SKW_IsExistPRectCross
; �O�`�̈�擾
;;;(defun PKW_MakeSKOutLine2      �L�b�`���̊O�`�̈�����ԃ|�����C����Ԃ�
;;;(defun PKW_MakeSKOutLine3      �L�b�`���̊O�`�̈�����ԃ|�����C����Ԃ� ���s���Ⴂ�Ή�
;;;(defun PKDepDiffDecide         �۱���޼���ِ}�`ؽĂ�n���ĉ��s���Ⴂ���ނ̗L���𔻒�
;;;(defun PKDDD_I                 �۱���޼���ِ}�`ؽĂ�n���ĉ��s���Ⴂ���ނ̗L���𔻒� (I�^�p)
;;;(defun PKDDD_L                 �۱���޼���ِ}�`ؽĂ�n���ĉ��s���Ⴂ���ނ̗L���𔻒� (L�^�p)
;;;(defun PKDDD_U                 �۱���޼���ِ}�`ؽĂ�n���ĉ��s���Ⴂ���ނ̗L���𔻒� (U�^�p)
;;;(defun PKGetBaseI4             ���_��4��I�^�`��O�`���ײ݂̺�Ű��_�����߂�(����ق��Q�l�ɂ���)
;;;(defun PKGetBaseL6             ���_��6��L�^�`��O�`���ײ݂̺�Ű��_�����߂�(����ق��݂Ȃ�)
;;;(defun PKGetBaseU8             ���_��8��U�^�`��O�`���ײ݂̺�Ű��_�����߂�(����ق��݂Ȃ�)
; �Ԍ��Q�L��
;;;(defun PKW_SetGlobalFromBaseCab2    �Ԍ��Q�L��,���E����̔���
;;;(defun PKGetWTInfo                  WT���𓾂�
;;;(defun PKGetBASEPT_L                CG_BASEPT1,2 ��Ű��_1,2 �����߂�

; ܰ�į�߂̐���
;;;(defun PK_MakeWorktop3              ܰ�į�߂̐���
; WT�f�ʃ_�C�A���O
;;;(defun PKW_DanmenDlg
; �ގ��I���_�C�A���O
;;;(defun PKW_ZaisituDlg
; WT���_�C�A���O
;;;(defun PKWT_INFO_Dlg
;;;(defun MakeTEIMEN (  &pt$ /  )   �_���X�g-->������ײݐ}�`����Ԃ�
;;;(defun PKSLOWPLCP       �_�̂܂���۰���߷��ފO�`���ײ݂�����  �i��:KSPX090ABR(or L)-H������

; *** ��ʍ쐬 ***
;;;(defun PKMakeWT_BG_FG_Pline   WT,BG,FG������ײ݂̍쐬
;;;(defun PKMakeTeimenPline_I
; <L�^>
;;;(defun PKMakeTeimenPline_L
;;;(defun PKLcut0  WT,BG,FG������ײ݂̍쐬  L�^��ĂȂ�(ID=0)
;;;(defun PKLcut1                            L�^�΂߶��(ID=1)
;;;(defun PKLcut2                            L�^�������(ID=2)
;;;(defun PKLcut2-1                          L�^�������(ID=2) �����1
;;;(defun PKLcut2-2                          L�^�������(ID=2) �����2
; <U�^>
;;;(defun PKMakeTeimenPline_U
;;;(defun PKUcut0   WT,BG,FG������ײ݂̍쐬 U�^��ĂȂ�(ID=0) �g�p���邱�Ƃ͂Ȃ�
;;;(defun PKUcut1                            U�^�΂߶��(ID=1)
;;;(defun PKUcut2                            U�^�������(ID=2)
;;;(defun PKGetBG_TEIMEN BG������ײݍ쐬
;;;(defun PKGetFG_TEIMEN FG������ײݍ쐬
;;;(defun PKUcut2-1                          U�^�������(ID=2) �����1
;;;(defun PKUcut2-2                          U�^�������(ID=2) �����2
;;;(defun PKUcut2-3                          U�^�������(ID=2) �����3
;;;(defun PKUcut2-4                          U�^�������(ID=2) �����4

;;;(defun PKDecideLRCODE       LR����������޲�۸ނ�\��
;;;(defun GetBGLEN             BG��ʐ}�`--->BG����(BG��ʕӂ̒����̍ő�l)

; "G_BKGD"�̾��
;;;(defun PKSetBGXData     �g���ް� G_BKGD�̾��
;;;(defun PKGetBGPrice     BG�i�Ԃ���BG���i�����߂�
;;;(defun PKMoveTempLayer
;;;(defun PKMKWT           ܰ�į�߂̐��� Z�����ړ�
;;;(defun PKMKFG2          ���Ķް�ނ̐��� Z�����ړ�
;;;(defun PKMKBG2          �ޯ��ް�ނ̐��� Z�����ړ�
;;;(defun Make_Region2

; �v��������
;;;(defun PKW_WorkTop      �v����������
;;;(defun PKGetWTInfo_plan
;;;(defun PKW_MakeSKOutLine �L�b�`���̊O�`�̈�����ԃ|�����C����Ԃ�
;;;(defun SKW_ReGetBasePt   �X�e�b�v�^�C�v�̏ꍇ�A��_���Đݒ肷��
;;;(defun SKW_ChkStepType   �X�e�b�v�^�C�v�����ׂ�
;;;(defun PKW_GetLinkBaseCab �w��}�`�̑�����L���r�ɗאڂ����ް����ނ��擾����
;;;(defun PKW_SLinkBaseSym �w��}�`�̑�����x�[�X�L���r�ɗאڂ���x�[�X�L���r�l�b�g���擾����
;;;(defun C:kosu (/ #ss) �������ް�̐}�`����\������

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:PosWKTOP
;;; <�����T�v>  : �i�C�Ӕz�u�j���[�N�g�b�v�������� I�^,L�^,U�^�Ή�,D��đΉ�
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:PosWKTOP (
  /
  #BASE$ #BASE_NEW$ #CLAYER #DEL #DUM$ #EN #EN$ #ENWT$ #EN_LOW$ #FFLG #HND #HNDB #K #LOOP
  #OUTPL$ #OUTPL_LOW #PT$ #PT$$ #PT_LOW$ #SS_DEL #SYM #THR #WTINFO$ #XD_SYM$ #H
  #WTBASE
#RET_DANSA$ ; 02/09/04 YM ADD
  )

  (StartUndoErr);// �R�}���h�̏�����
  (CFCmdDefBegin 6);00/09/26 SN ADD
  (CFNoSnapReset);00/08/24 SN ADD

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)


; 01/06/28 YM ADD ����ނ̐��� Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:PosWKTOP ////")
  (CFOutStateLog 1 1 " ")

  ;// �r���[��o�^ 01/07/26 YMA ADD
  (command "_view" "S" "TEMP_WT")

  (setq #hndB (car (CFGetXRecord "BASESYM"))) ; �����
  (PKStartWKTOP)                              ; ���ѕϐ�,��۰��ق̐ݒ�Ȃ�
  (MakeTempLayer)                             ; ��Ɨp�����؉�w�̍쐬
  (setq #clayer (getvar "CLAYER"   ))         ; ���݂̉�w���L�[�v
  (command "_layer" "S" SKD_TEMP_LAYER "")    ; ���݉�w�̕ύX

  (setq #base$  '())
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #en (car (entsel "\n�t���A�L���r�l�b�g��I��: ")))
    (setq #dum$ (PKCheckBaseCab #en))
    (setq #fflg (car  #dum$))
    (setq #sym  (cadr #dum$))
    (if (= #fflg nil) ; �����Ɉ���������Ȃ������ꍇ
      (progn
        (command "vpoint" "0,0,1")  ; 00/04/17 YM �i�Ԋm��Ō�������
        (setq #en$ (PKW_GetLinkBaseCab #sym))
        ;;; �_�C�j���O���ނ��Ȃ�
        (foreach #en #en$
          (setq #thr (CFGetSymSKKCode #en 3))
          (setq #xd_SYM$ (CFGetXData #en "G_SYM"))
          ; 01/08/09 YM MOD "117"�ł�"118"�ł��Ȃ�
          (if (and (/= CG_SKK_THR_DIN #thr) ; 3���� 7�łȂ����̂��W�߂�
                   (/= 8 #thr)) ; 01/07/30 YM ADD 118���O
;;;           (equal (nth 6 #xd_SYM$) 0 0.01))
            (progn
              (GroupInSolidChgCol2 #en CG_InfoSymCol) ; �F��ς���
              (setq #base$ (cons #en #base$))         ; �޲�ݸވȊO�̼����
              ; 01/09/27 YM ADD-S �L�p�x���ނ�T��
              (if (and (= #thr CG_SKK_THR_CNR)(= (nth 0 #xd_SYM$) "WIDE-ANG-F-CAB"))
                (setq CG_WIDECAB_EXIST T)
              );_if
              ; 01/09/27 YM ADD-E �L�p�x���ނ�T��
            )
          );_if
        )

        (if #base$
          (progn
            (foreach base #base$
              (KPMovePmen2_Z_0 base) ; ����وʒuZ��0�łȂ��Ƃ��APMEN2�̍�����Z=0�ɂ���
            )
            (setq #outpl$ (PKW_MakeSKOutLine3 #base$)) ; ���ޏ��O�O�̊O�`�̈�����߂�
          )
          (progn
            (CFAlertMsg "���[�N�g�b�v�𐶐�����t���A�L���r�l�b�g������܂���B")
            (quit)
          )
        );_if

;;;01/08/27YM@DEL       ; 01/07/04 YM ADD START
;;;01/08/27YM@DEL        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget (car #outpl$))) (entget (car #outpl$))))
;;;01/08/27YM@DEL        (setq #WTBASE (entlast)) ; �c��(�i�������܂�WT�O�`)
        (setq #pt$ (GetLWPolyLinePt (car #outpl$))) ; ���O�O�̊O�`�_��
        ; 01/07/03 YM ADD L+I�^�^�񒆒i�����ݗp���ꏈ��

        ; �O�`�_������PLINE�ɂ��Ă���"G_WRKT"�ɾ�Ă���i�������܂񂾑S�O�`�_��
        ; (���̎��_�ł͑O�����WT���s���g�����܂�ł��Ȃ������Ƃōl������)
        (setq CG_GAIKEI #pt$) ; 01/08/24 YM MOD
        ; 01/07/04 YM ADD END

        ;;; ����WT�����邩�ǂ������ׂ�  ��������폜���邩�ǂ�������
        (PKExistWTDel #pt$)
        (PKW_SetGlobalFromBaseCab2 #base$) ; �Ԍ��Q�L�� CG_W2CODE �̔���  �k�q�敪 (nth 11 CG_GLOBAL$) ����

        ; 02/06/04 YM MOD �ȉ����[�J�[���Ƃɕ��򂷂� MOD-S
        (setq #Ret_Dansa$ (KP_DansaHantei #base$)) ; �i���L���r����
        (setq #ss_del   (car #Ret_Dansa$))
        (setq #en_LOW$ (cadr #Ret_Dansa$))
        ; 02/06/04 YM MOD �ȉ����[�J�[���Ƃɕ��򂷂� MOD-E

        ; 02/06/04 YM MOD �ȉ����[�J�[���Ƃɕ��򂷂� DEL-S
;;;        (setq #ss_del (ssadd))
;;;       ;;; ۰���ޕ��ނ������I�ɏ��O(���@H�����Ă���)
;;;        (foreach #en #base$
;;;          (setq #thr (CFGetSymSKKCode #en 3))
;;;          (cond
;;;           ; 02/03/287 YM MOD-S
;;;            ((or (= #thr CG_SKK_THR_GAS)(= #thr CG_SKK_THR_NRM))
;;;              (setq #h (nth 5 (CFGetXData #en "G_SYM")))
;;;              (if (and (> #h 450) (< #h 550)) ; ����۰���߂̷���ȯĂ�����Βi������
;;;                (progn ; �i�����ޏ��O
;;;                  (setq CG_Type2Code "D") ; "F","D"
;;;                  (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ۰���߷���ȯļ���ِ}�`ؽ�
;;;                 ;;; ����тȂ��
;;;                 (setq #hnd  (cdr (assoc 5 (entget #en))))
;;;                 (if (equal #hnd #hndB)
;;;                   (GroupInSolidChgCol #en CG_BaseSymCol) ; ��
;;;                   (GroupInSolidChgCol2 #en "BYLAYER") ; �F��߂�
;;;                 );_if
;;;                  (ssadd #en #ss_del) ; ��ŏ��O����
;;;                )
;;;              );_if
;;;            )
;;;           ; 02/03/287 YM MOD-E
;;;
;;;;;;02/03/28YM@MOD            ;�K�X�L���r�l�b�g
;;;;;;02/03/28YM@MOD            ((= #thr CG_SKK_THR_GAS)
;;;;;;02/03/28YM@MOD              (setq #h (nth 5 (CFGetXData #en "G_SYM")))
;;;;;;02/03/28YM@MOD              (if (and (> #h 450) (< #h 550)) ; ����۰���߂̺�۷���ȯĂ�����Βi������
;;;;;;02/03/28YM@MOD                (progn ; �i�����ޏ��O
;;;;;;02/03/28YM@MOD                  (setq CG_Type2Code "D") ; "F","D"
;;;;;;02/03/28YM@MOD                  (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ۰���߷���ȯļ���ِ}�`ؽ�
;;;;;;02/03/28YM@MOD                  ;;; ����тȂ��
;;;;;;02/03/28YM@MOD                  (setq #hnd  (cdr (assoc 5 (entget #en))))
;;;;;;02/03/28YM@MOD                  (if (equal #hnd #hndB)
;;;;;;02/03/28YM@MOD                    (GroupInSolidChgCol #en CG_BaseSymCol) ; ��
;;;;;;02/03/28YM@MOD                    (GroupInSolidChgCol2 #en "BYLAYER") ; �F��߂�
;;;;;;02/03/28YM@MOD                  );_if
;;;;;;02/03/28YM@MOD                  (ssadd #en #ss_del) ; ��ŏ��O����
;;;;;;02/03/28YM@MOD                )
;;;;;;02/03/28YM@MOD              );_if
;;;;;;02/03/28YM@MOD            )
;;;;;;02/03/28YM@MOD            ;�ʏ�L���r�l�b�g
;;;;;;02/03/28YM@MOD            ((= #thr CG_SKK_THR_NRM)
;;;;;;02/03/28YM@MOD              (setq #h (fix (nth 5 (CFGetXData #en "G_SYM"))))
;;;;;;02/03/28YM@MOD              (if (and (> #h 650) (< #h 750)) ; ����۰���߂̒ʏ���ȯĂ�����Βi������
;;;;;;02/03/28YM@MOD                (progn ; �i�����ޏ��O
;;;;;;02/03/28YM@MOD                  (setq CG_Type2Code "D") ; "F","D"
;;;;;;02/03/28YM@MOD                  (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ۰���߷���ȯļ���ِ}�`ؽ�
;;;;;;02/03/28YM@MOD                  ;;; ����тȂ��
;;;;;;02/03/28YM@MOD                  (setq #hnd  (cdr (assoc 5 (entget #en))))
;;;;;;02/03/28YM@MOD                  (if (equal #hnd #hndB)
;;;;;;02/03/28YM@MOD                    (GroupInSolidChgCol #en CG_BaseSymCol) ; ��
;;;;;;02/03/28YM@MOD                    (GroupInSolidChgCol2 #en "BYLAYER") ; �F��߂�
;;;;;;02/03/28YM@MOD                  );_if
;;;;;;02/03/28YM@MOD                  (ssadd #en #ss_del) ; ��ŏ��O����
;;;;;;02/03/28YM@MOD                )
;;;;;;02/03/28YM@MOD              );_if
;;;;;;02/03/28YM@MOD            )
;;;          );_cond
;;;        );_(foreach #en #en$   ;// ۰���ޕ��ނ��Ȃ�
        ; 02/06/04 YM MOD �ȉ����[�J�[���Ƃɕ��򂷂� DEL-E

;;; �i�����ނ��Ȃ���.  *** ���̎��_�Œi���v�������ǂ����������� ***

        (command "zoom" "p") ; ���_�����ɖ߂�
        (setq #del T) ; WT�𒣂肽���Ȃ����ނ��J��Ԃ��I��
        (setq #del (car (entsel "\n���O����t���A�L���r�l�b�g��I��: "))) ; Return�������܂ŌJ��Ԃ�
        (while #del
          (setq #fflg nil)
          (setq #sym (CFSearchGroupSym #del)) ; ����ِ}�`
          (if (= #sym nil)
            (progn
              (CFAlertMsg "�t���A�L���r�l�b�g�ł͂���܂���B") ; �I�΂��܂ŌJ��Ԃ�
              (setq #fflg T)
            )
            (progn ; #sym �� nil �łȂ�
              (if (or (/= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)  ; ���ނłȂ�
                      (/= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS)) ; �ް��łȂ�
                (progn
                  (CFAlertMsg "�t���A�L���r�l�b�g�ł͂���܂���B") ; �I�΂��܂ŌJ��Ԃ�
                  (setq #fflg T)
                )
              )
            )
          );_if

          (if (= #fflg nil) ; �����Ɉ���������Ȃ������ꍇ
            (progn
              (setq #sym (CFSearchGroupSym #del))
              ;;; ����тȂ��
              (setq #hnd  (cdr (assoc 5 (entget #sym))))
              (if (equal #hnd #hndB)
                (GroupInSolidChgCol #sym CG_BaseSymCol) ; ��
                (GroupInSolidChgCol2 #sym "BYLAYER") ; �F��߂�
              );_if
              (ssadd #sym #ss_del) ; ��ŏ��O����
            )
          );_if
          (setq #del (car (entsel "\n���O����t���A�L���r�l�b�g��I��: ")))
        );_while #del

        (setq #base_new$ '())
        (if (and (/= #ss_del nil) (/= (sslength #ss_del) 0))
          (progn
            (setq #base_new$ (ListDel #base$ #ss_del)) ; ���O������̼���ِ}�`ؽ� #base_new$
            (entdel (car #outpl$))
          )
        ) ; ؽ�1����I��Ă̗v�f���Ƃ�

        (if (and (>= (sslength #ss_del)(length #base$))
                 (= #base_new$ nil))
          (progn
            (CFAlertMsg "���[�N�g�b�v�𐶐�����t���A�L���r�l�b�g������܂���B")
            (quit)
          )
        );_if

        ;// �x�[�X�L���r�̊O�`�̈�̑g�ݍ��킹�|�����C�������߂�
        (princ "\n�L�b�`���̍\�����m�F���Ă��܂�...")

        (if #base_new$ ; nil�Ȃ�ŏ���#outpl$���g�p����
          (setq #outpl$ (PKW_MakeSKOutLine3 #base_new$)) ; �O�`�̈�����߂�.�����̏ꍇ����
          (setq #base_new$ #base$)                       ; ���O������̼���ِ}�`ؽ� #base_new$
        );_if

        ;;; ۰���߷��ނ������
        (if #en_LOW$ ; ۰���߷��޼���ِ}�`��ؽ�
          (progn
            (setq #outpl_LOW (car (PKW_MakeSKOutLine2 #en_LOW$))) ; ۰���߷��ފO�`�̈�����߂�
            (setq #pt_LOW$ (GetLWPolyLinePt #outpl_LOW))          ; ۰���߷��ފO�`�_��
          )
        );_if

        (setq #k 0)
        (repeat (length #outpl$)
          (setq #pt$$ (append #pt$$ (list (GetLWPolyLinePt (nth #k #outpl$))))) ; �O�`�_�� (@@@)
          (entdel (nth #k #outpl$))
          (setq #k (1+ #k))
        )
        (setq #loop nil)
      )
    );_if
  );_while

  (setvar "CLAYER" #clayer) ; ���̉�w�ɖ߂�

  (foreach #en #base$
    ;;; ����тȂ��
    (setq #hnd  (cdr (assoc 5 (entget #en))))
    (if (equal #hnd #hndB)
      (GroupInSolidChgCol #en CG_BaseSymCol) ; ��
      (GroupInSolidChgCol2 #en "BYLAYER")    ; �F��߂�
    );_if
  )

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart)

;;; WT���
  (setq #WTInfo$ (PKGetWTInfo #pt$ #pt$$ #base$ #base_new$ #outpl_LOW #en_LOW$))
  ;// ���[�N�g�b�v�̐��� U�^�Ή�,D��đΉ� Z�����ɉ����o��
  (setq #enWT$
    (PK_MakeWorktop3
      #WTInfo$  ; (list #WTInfo #retWT_BG_FG$ #SetXd$ #CUT_KIGO$)
      #en_LOW$  ; ۰���߷���ؽ�
      #pt_LOW$  ; ۰���߷��ފO�`�_��
    )
  )
;;; ;2011/09/18 YM ADD-S
;;; ;D1050�Ȃ��R���ޏ���   ��R���ޑ����E��������Ȃ��̂ŗ����遚
;;; (if (= 1 (length #enWT$))
;;;   (progn
;;;     (setq #oku$ (nth 4 (car (nth 1 #WTInfo$))));���s��ؽ�
;;;     (if (and (equal (car #oku$) 1050.0 0.001)(equal (cadr #oku$) 0.0 0.001))
;;;       ;IPA D1050
;;;       (setq #WT (subKPRendWT (car #enWT$))) ;�߂�l=�V�}�`��
;;;     );_if
;;;   )
;;; );_if
;;; ;2011/09/18 YM ADD-E

;;; ۰���߷��ފO�`���ײ݂��폜
  (if #en_LOW$
    (entdel #outpl_LOW)
  );_if

  (princ "\n���[�N�g�b�v�������������܂����B")
  ;// �r���[��߂�
  (command "_view" "R" "TEMP_WT")

  (setq CG_WorkTop (substr (nth 2 (nth 2 #WTInfo$)) 2 1)) ; �F���O���[�o���ݒ�

  ); 01/06/28 YM ADD ����ނ̐��� Lipple
);_if

  (setq *error* nil)
  (PKEndWKTOP)
  (CFCmdDefFinish);00/09/26 SN ADD
  (princ)
);C:PosWKTOP

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:MakeWKTOP
;;; <�����T�v>  : �i�C�Ӕz�u�j���[�N�g�b�v�ʐ��� I�^�̂ݑΉ�
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      : �P��or�אڂ��������̷��ނ��P���I������
;;;*************************************************************************>MOH<
(defun C:MakeWKTOP (
  /
  #BASE$ #CLAYER #DUM$ #EN #ENWT$ #EN_LOW$ #FFLG #H #HND #HNDB #I #OUTPL$ #OUTPL$$ #PT$ #PT_LOW$ #SYM #SYM_LIS
  #THR #WTINFO$ #XD_SYM$
  )

  ; �R�}���h�̏�����
  (StartUndoErr)
  (CFCmdDefBegin 6);00/09/26 SN ADD
  (CFNoSnapReset)

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

; 01/06/28 YM ADD ����ނ̐��� Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:MakeWKTOP ////")
  (CFOutStateLog 1 1 " ")

  (setq #hndB (car (CFGetXRecord "BASESYM"))) ; �����
  (PKStartWKTOP)                              ; ���ѕϐ�,��۰��ق̐ݒ�Ȃ�
  (MakeTempLayer)                             ; ��Ɨp�����؉�w�̍쐬 05/31 YM ADD
  (setq #clayer (getvar "CLAYER"   ))         ; ���݂̉�w���L�[�v
  (command "_layer" "S" SKD_TEMP_LAYER "")    ; ���݉�w�̕ύX

;;; ����ȯĂ𕡐��I������
  (setq #base$ '())
  (setq #i 0)
  (setq #en T)
  (while #en
    (initget "U")
    (setq #en (entsel "\n�t���A�L���r�l�b�g��I��: "))
    (cond
      ((= #en "U")
        ;;; ����тȂ��
        (if (> (length #sym_lis) 0)
          (progn
            (setq #hnd (cdr (assoc 5 (entget (car #sym_lis)))))
            (if (equal #hnd #hndB)
              (GroupInSolidChgCol (car #sym_lis) CG_BaseSymCol) ; ��
              (GroupInSolidChgCol2 (car #sym_lis) "BYLAYER")    ; �F��߂�
            );_if
           ; ���X�g���璼�O�̂��̂��폜 ;
            (setq #sym_lis (cdr #sym_lis))
          )
        );_if
      )
      ((= #en nil)
        (if (= (length #sym_lis) 0)
          (progn
            (CFAlertErr "�t���A�L���r�l�b�g���I������Ă��܂���B")
            (setq #en T)
          )
        );_if
      )
      (T
        (setq #dum$ (PKCheckBaseCab (car #en))) ; �۱���ނ��ǂ�������
        (setq #fflg (car  #dum$))
        (setq #sym  (cadr #dum$))

        (if #sym
          (progn
            (setq #thr (CFGetSymSKKCode #sym 3))
            (setq #h (fix (nth 5 (CFGetXData #sym "G_SYM"))))
            (if (= #fflg nil) ; �����Ɉ���������Ȃ������ꍇ
              (if #sym
                (if (= (member #sym #sym_lis) nil)
                  (if (= CG_SKK_THR_DIN (CFGetSymSKKCode #sym 3))
                    (if (CFYesNoDialog "�_�C�j���O�ł������[�N�g�b�v�𐶐����܂����H")
                      (progn
                        (GroupInSolidChgCol2 #sym CG_InfoSymCol) ; �F��ς���
                        (setq #sym_lis (cons #sym #sym_lis))
                        (setq #i (1+ #i))
                      )
                    );_if
                    (progn  ; �޲�ݸވȊO�̏ꍇ
                      (GroupInSolidChgCol2 #sym CG_InfoSymCol) ; �F��ς���
                      (setq #sym_lis (cons #sym #sym_lis))
                      (setq #i (1+ #i))
                    )
                  );_if
                );_if
              );_if
            );_if
          )
        );_if
      );T
    );_cond
  );_while #en

  (setq #base$ #sym_lis)

  ; 01/08/01 YM ADD PMEN2�̍��x��0�ɂ���(Be-Free�Ή�) START
  (if #base$
    (progn
      (foreach base #base$
        (KPMovePmen2_Z_0 base) ; ����وʒuZ��0�łȂ��Ƃ��APMEN2�̍�����Z=0�ɂ���
      )
      (setq #outpl$$ (PKW_MakeSKOutLine3 #base$))  ; �O�`�̈�����߂�
    )
  );_if
  ; 01/08/01 YM ADD PMEN2�̍��x��0�ɂ���(Be-Free�Ή�) END

;;;  (setq #outpl$$ (PKW_MakeSKOutLine3 #base$))  ; �O�`�̈�����߂�
  (if (= (length #outpl$$) 1)
    (setq #outpl$ (car #outpl$$))
    (progn ; �O�`�������̏ꍇ
      (CFAlertErr "�ʂɃ��[�N�g�b�v���쐬���Ă��������B")
      (quit)
    )
  )
  (setq #pt$ (GetLWPolyLinePt #outpl$)) ; �O�`�_��

  (setq CG_GAIKEI #pt$) ; 01/08/27 YM MOD

  ;;; ����WT�����邩�ǂ������ׂ�  ��������폜���邩�ǂ�������
  (command "vpoint" "0,0,1") ;  "LWPOLYLINE"  ��w: "Z_wtbase"

;;; ����WT�����邩�ǂ������ׂ�  ��������폜���邩�ǂ�������
  (PKExistWTDelSmallArea #pt$) ; �����폜
;;;01/08/27TM@DEL (PKExistWTDelSmallArea #pt$ #base$)

  ; 01/08/27 YM ADD CG_W2CODE�̂��߂����Ȃ���
  (PKW_SetGlobalFromBaseCab2 #base$) ; �Ԍ��Q�L�� CG_W2CODE �̔���  �k�q�敪 (nth 11 CG_GLOBAL$) ����

  (command "zoom" "p")

  ; �x�[�X�L���r�̊O�`�̈�̑g�ݍ��킹�|�����C�������߂�
  (princ "\n�L�b�`���̍\�����m�F���Ă��܂�...")

  (setvar "CLAYER" #clayer) ; ���̉�w�ɖ߂�

  (foreach #en #base$
    ;;; ����тȂ��
    (setq #hnd  (cdr (assoc 5 (entget #en))))
    (if (equal #hnd #hndB)
      (GroupInSolidChgCol #en CG_BaseSymCol) ; ��
      (GroupInSolidChgCol2 #en "BYLAYER") ; �F��߂�
    );_if
  )
  ; �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart)
;;; WT���
  (setq #WTInfo$ (PKGetWTInfo #pt$ (list #pt$) #base$ #base$ nil nil))
  (setq #enWT$
    (PK_MakeWorktop3
      #WTInfo$  ; (list #WTInfo #retWT_BG_FG$ #SetXd$ #CUT_KIGO$)
      #en_LOW$  ; ۰���߷���ؽ�
      #pt_LOW$  ; ۰���߷��ފO�`�_��
    )
  )

    (princ "\n���[�N�g�b�v�𐶐����܂����B")
    (setq CG_WorkTop (substr (nth 2 (nth 2 #WTInfo$)) 2 1)) ; �F���O���[�o���ݒ�

  ); 01/06/28 YM ADD ����ނ̐��� Lipple
);_if

  (setq *error* nil)
  (entdel #outpl$)
  (PKEndWKTOP)
  (CFCmdDefFinish);00/09/26 SN ADD
  (princ)

);C:MakeWKTOP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKStartWKTOP
;;; <�����T�v>  : ��۰���,���ѕϐ��̐ݒ�Ȃ�
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.6 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKStartWKTOP ( / )
  (setq CG_Type2Code "F") ; "F","D"  ��̫��=�ׯ�
  (setq CG_BASEPT1 nil)
  (setq CG_BASEPT2 nil)
  (setq CG_MAG1 nil)
  (setq CG_MAG2 nil)
  (setq CG_MAG3 nil)
  (setq CG_GAIKEI nil)        ; 01/07/04 YM ADD
  (setq CG_WIDECAB_EXIST nil) ; ��Ű���ނɍL�p�x���܂�ł���==>T 01/09/27 YM ADD

;;; ���ѕϐ��ݒ�
  (setq os (getvar "OSMODE"   ))
  (setq sm (getvar "SNAPMODE" ))
  (setq ot (getvar "ORTHOMODE"))
  (setq uf (getvar "UCSFOLLOW")) ; 05/24 YM ADD UCS�ύX view�ɉe�����Ȃ�
  (setq el (getvar "ELEVATION"))

  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "UCSFOLLOW" 0)
  (setvar "ELEVATION" 0.0)
  (setvar "pdmode" 34)         ; 06/12 YM
  (setvar "pdsize" 5)
  (princ)
);PKStartWKTOP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKEndWKTOP
;;; <�����T�v>  : ��۰���,���ѕϐ��̐ݒ�Ȃǂ�߂�
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.6 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKEndWKTOP ( / )
;;; ���ѕϐ��ݒ��߂�
  (setvar "OSMODE"    os)
  (setvar "SNAPMODE"  sm)
  (setvar "ORTHOMODE" ot)
  (setvar "UCSFOLLOW" uf) ; 05/24 YM ADD UCS�ύX view�ɉe�����Ȃ�
  (setvar "ELEVATION" el)
  (setvar "pdmode" 0)    ; 06/12 YM

  (setq CG_Type2Code nil) ; "F","D"  ��̫��=�ׯ�
  (setq CG_BASEPT1 nil)
  (setq CG_BASEPT2 nil)
  (setq CG_MAG1 nil)
  (setq CG_MAG2 nil)
  (setq CG_MAG3 nil)
  (setq CG_GAIKEI nil) ; 01/07/04 YM ADD
  (setq CG_WIDECAB_EXIST nil) ; ��Ű���ނɍL�p�x���܂�ł���==>T 01/09/27 YM ADD
  (setq os nil sm nil ot nil uf nil el nil)

  (princ)
);PKEndWKTOP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKCheckBaseCab
;;; <�����T�v>  : entsel�}�`���ް����ނ�����
;;; <����>      : entsel�}�`
;;; <�߂�l>    : �_��==>T OK==>nil
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKCheckBaseCab (
  &en ; entsel�}�`��
  /
  #FFLG #SYM
  )
  (setq #fflg nil)
  (if (= &en nil)
    (progn
      (CFAlertMsg "�t���A�L���r�l�b�g�ł͂���܂���B") ; �I�΂��܂ŌJ��Ԃ�
      (setq #fflg T)
    )
  ;else
    (progn ; &en �� nil �łȂ�
      (setq #sym (CFSearchGroupSym &en)) ; ����ِ}�`
      (if (= #sym nil)
        (progn
          (CFAlertMsg "�t���A�L���r�l�b�g�ł͂���܂���B") ; �I�΂��܂ŌJ��Ԃ�
          (setq #fflg T)
        )
        (progn ; #sym �� nil �łȂ�
          (if (= (nth 9 (CFGetXData #sym "G_LSYM")) 118)
            (progn
              (CFAlertMsg "�t���A�L���r�l�b�g�ł͂���܂���B") ; �I�΂��܂ŌJ��Ԃ�
              (setq #fflg T)
            )
            (if (or (/= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)  ; ���ނłȂ�
                    (/= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS)) ; �ް��łȂ�
                (progn
                  (CFAlertMsg "�t���A�L���r�l�b�g�ł͂���܂���B") ; �I�΂��܂ŌJ��Ԃ�
                  (setq #fflg T)
                )
              ;);_if
            );_if
          );_if
        )
      );_if
    )
  );_if
  (list #fflg #sym)
);PKCheckBaseCab

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKExistWTDel
;;; <�����T�v>  : ����WT�����邩�ǂ������ׂ� ��������폜���邩�ǂ�������
;;; <�߂�l>    : (���ؽ�,��۷���ؽ�)
;;; <�쐬>      : 2000.6.6 YM
;;; <���l>      : (��ە����Ή� 00/06/27 YM)
;;;*************************************************************************>MOH<
(defun PKExistWTDel (
  &pt$ ; ���O�O�̊O�`�_��
  /
  #DUM1$ #DUM2$ #DUM3$ #DUM4$ #KK #PTA$ #PTWT$ #SSWT #SS_DUM #WT
  )
  (setq #ptA$ (AddPtList &pt$)) ; �����Ɏn�_��ǉ�����
  (setq #ssWT (ssget "CP" #ptA$ (list (list -3 (list "G_WRKT"))))) ; �̈����WT�}�`

  (if #ssWT
    (if (> (sslength #ssWT) 0)
      (if (CFYesNoDialog "�����̃��[�N�g�b�v���폜���܂����H")
        (progn
          (setq #kk 0)
          (repeat (sslength #ssWT)
            (setq #WT (ssname #ssWT #kk))
            ;;; WT�O�`�_������߂�
            (setq #ptWT$ (PKGetWT_outPT #WT 1)) ; 01/08/10 YM ADD(�����ǉ�)
            (PKDelWkTopONE (ssname #ssWT #kk)) ; �폜����ގ��׸�=1(�m�Fү���ނ�\��) 0:�\���Ȃ�
            (setq #kk (1+ #kk))
          );_repeat
        )
        (progn
          (CFAlertMsg "���[�N�g�b�v�����ɑ��݂��邽�ߎ����������s���܂���ł����B")
          (*error*)
        )
      );_if
    );_if
  );_if
  (princ)
);PKExistWTDel

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKExistWTDelSmallArea
;;; <�����T�v>  : ����WT�����邩�ǂ������ׂ�  ��������폜���邩�ǂ�������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.8 YM
;;; <���l>      : �̈�O�`�_��4�_�������������ėא�WT���܂܂Ȃ��悤�ɂ���
;;;               �O�`�_���I�`��̂�
;;; <�C��>        01/08/27 ����WT�폜���邩�ǂ�����հ�ް�̔��f�Ɉς˂�
;;;*************************************************************************>MOH<
(defun PKExistWTDelSmallArea (
  &pt$   ; ���O�O�̊O�`�_��
;;;01/08/27TM@DEL &base$ ; �����ؽ� ; �����폜
  /
  #BPT #O #P1 #P2 #P3 #P4 #PTA$ #SSWT #KK #PTWT$ #WT
  )
;;;01/08/27TM@DEL ;;; �O�`�_�񍶏��_�����߂�
;;;01/08/27TM@DEL (foreach #sym &base$
;;;01/08/27TM@DEL   (setq #BPT (cdr (assoc 10 (entget #sym))))
;;;01/08/27TM@DEL   (foreach #pt &pt$
;;;01/08/27TM@DEL     (if (< (distance #BPT #pt) 0.01)
;;;01/08/27TM@DEL       (setq #O #pt)
;;;01/08/27TM@DEL     );_if
;;;01/08/27TM@DEL   )
;;;01/08/27TM@DEL )
;;;01/08/27TM@DEL;;; 1+----------+2
;;;01/08/27TM@DEL;;;  |          |
;;;01/08/27TM@DEL;;;  |          |
;;;01/08/27TM@DEL;;; 4+----------+3
;;;01/08/27TM@DEL;;;  (setq #ptA$ (AddPtList &pt$))       ; �����Ɏn�_��ǉ�����
;;;01/08/27TM@DEL;;; �̈�4�_�������������ėא�WT����������
;;;01/08/27TM@DEL (setq #ptA$ (GetPtSeries #O &pt$)) ; �擪�Ɏ��v����
;;;01/08/27TM@DEL (setq #p1 (nth 0 #ptA$))
;;;01/08/27TM@DEL (setq #p2 (nth 1 #ptA$))
;;;01/08/27TM@DEL (setq #p3 (nth 2 #ptA$))
;;;01/08/27TM@DEL (setq #p4 (nth 3 #ptA$))
;;;01/08/27TM@DEL (setq #p1 (polar #p1 (angle #p4 #p3) 30))
;;;01/08/27TM@DEL (setq #p2 (polar #p2 (angle #p3 #p4) 30))
;;;01/08/27TM@DEL (setq #p3 (polar #p3 (angle #p2 #p1) 30))
;;;01/08/27TM@DEL (setq #p4 (polar #p4 (angle #p1 #p2) 30))
;;;01/08/27TM@DEL (setq #ptA$ (list #p1 #p2 #p3 #p4 #p1))
;;;01/08/27TM@DEL  (setq #ssWT (ssget "CP" #ptA$ (list (list -3 (list "G_WRKT"))))); �̈����WT�}�`
  (setq #ssWT (ssget "CP" &pt$ (list (list -3 (list "G_WRKT"))))); �̈����WT�}�` ; 01/08/27 YM MOD

  (if #ssWT
    (if (> (sslength #ssWT) 0)
      (if (CFYesNoDialog "�����̃��[�N�g�b�v���폜���܂����H")
        (progn
          (setq #kk 0)
          (repeat (sslength #ssWT)
            (setq #WT (ssname #ssWT #kk))
            ;;; WT�O�`�_������߂�
            (setq #ptWT$ (PKGetWT_outPT #WT 1)) ; 01/08/10 YM ADD(�����ǉ�)
            (PKDelWkTopONE (ssname #ssWT #kk)) ; �폜����ގ��׸�=1(�m�Fү���ނ�\��) 0:�\���Ȃ�
            (setq #kk (1+ #kk))
          );_repeat
        )
;;;01/08/27TM@DEL        (progn
;;;01/08/27TM@DEL          (CFAlertMsg "���[�N�g�b�v�����ɑ��݂��邽�ߎ����������s���܂���ł����B")
;;;01/08/27TM@DEL          (*error*)
;;;01/08/27TM@DEL        )
      );_if
    );_if
  );_if

;;;01/03/23YM@  (if #ssWT
;;;01/03/23YM@    (if (> (sslength #ssWT) 0) ; 1�ȏ゠�����ꍇ
;;;01/03/23YM@      (progn
;;;01/03/23YM@        (CFAlertMsg "���[�N�g�b�v�����ɑ��݂��܂��B")
;;;01/03/23YM@        (quit)
;;;01/03/23YM@      )
;;;01/03/23YM@    );_if
;;;01/03/23YM@  );_if

  (princ)
);PKExistWTDelSmallArea

;<HOM>*************************************************************************
; <�֐���>    : SKW_GetLinkBaseCab
; <�����T�v>  : �w��}�`�̑�����x�[�X�L���r�ɗאڂ���x�[�X�L���r�l�b�g���擾����
; <�߂�l>    : �L���r�l�b�g�}�`(G_LSYM)�̃��X�g
; <�쐬>      : 1999-10-19
; <���l>      : �ċA�ɂ�� �אڂ����V���{����
;                 CG_LinkSym
;               �Ɋi�[����
;*************************************************************************>MOH<
(defun SKW_GetLinkBaseCab (
    &en       ;(ENAME)�C�ӂ̐}�`
  )
  (SKW_GetLinkCab &en CG_SKK_TWO_BAS)
)
;SKW_GetLinkBaseCab

;<HOM>*************************************************************************
; <�֐���>    : SKW_GetLinkUpperCab
; <�����T�v>  : �w��}�`�̑�����A�b�p�[�L���r�ɗאڂ���A�b�p�[�L���r�l�b�g���擾����
; <�߂�l>    : �L���r�l�b�g�}�`(G_LSYM)�̃��X�g
; <�쐬>      : 1999-10-19
; <���l>      : �ċA�ɂ�� �אڂ����V���{����
;                 CG_LinkSym
;               �Ɋi�[����
;*************************************************************************>MOH<
(defun SKW_GetLinkUpperCab (
    &en       ;(ENAME)�C�ӂ̐}�`
  )
  (SKW_GetLinkCab &en CG_SKK_TWO_UPP)
)
;SKW_GetLinkBaseCab

;<HOM>*************************************************************************
; <�֐���>    : SKW_GetLinkCab
; <�����T�v>  : �w��}�`�̑�����L���r�ɗאڂ���x�[�X�L���r�l�b�g���擾����
; <�߂�l>    : �L���r�l�b�g�}�`(G_LSYM)�̃��X�g
; <�쐬>      : 1999-10-19
; <���l>      : �ċA�ɂ�� �אڂ����V���{����
;                 CG_LinkSym
;               �Ɋi�[����
;*************************************************************************>MOH<
(defun SKW_GetLinkCab (
    &en       ;(ENAME)�C�ӂ̐}�`
    &code     ;(INT)�x�[�X�A�A�b�p�[�̐��iCODE(CG_SKK_TWO_BAS,CG_SKK_TWO_UPP)
    /
    #enSS$
    #enS1
    #xd$
    #skk$
    #ss #i
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKW_GetLinkCab ////")
  (CFOutStateLog 1 1 " ")

  (setq CG_LinkSym nil)

  ;��V���{������������
  (setq #enS1 (CFSearchGroupSym &en))

  ;2000/06/13  HT ��V���{�����������s�̓G���[���b�Z�[�W
  (if #enS1
    (progn
  ;// �L���r���ǂ����̔���
  (if (= &code (CFGetSymSKKCode #enS1 2))
    (progn
      (setq #enSS$ (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (setq #ss (ssadd))                 ; �ǉ� �i�荞�� 00/03/10 MOD YM
      (repeat (sslength #enSS$)          ; 00/03/10 ADD YM
        (setq #skk$ (CFGetSymSKKCode (ssname #enSS$ #i) nil))
        ; 00/06/23 SN MOD �����W�t�[�h���ΏۂƂ���B
        (if (and (or (= (car #skk$) CG_SKK_ONE_CAB)(= (car #skk$) CG_SKK_ONE_RNG))(= (cadr #skk$) &code))  ; &code �̂��߯�����
        ;(if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) &code))  ; &code �̂��߯�����
          (progn
            (ssadd (ssname #enSS$ #i) #ss) ; �x�[�X�L���r�l�b�g�΂��� ���i����=11?
          )
        );_if
        (setq #i (1+ #i))
      );_(repeat (sslength #ss)                         ; 00/03/10 ADD YM

      ;// �ċA�ɂ��אڂ���x�[�X�L���r���������� ---> CG_LinkSym �ɓ����
      (SKW_SearchLinkBaseSym #ss #enS1)

      ;// �אڂ���L���r�̊�V���{���}�`��Ԃ�
      CG_LinkSym
    )
    nil
  )
  ) ; progn
  (progn
    ;2000/06/13  HT ��V���{�����������s�̓G���[���b�Z�[�W
    (princ "\n��V���{�����������sG_SYM(0)=")
    (princ (nth 5 (CfGetXData &en "G_LSYM")))
    nil
  )
  )
)
;SKW_GetLinkCab

;<HOM>*************************************************************************
; <�֐���>    : SKW_SearchLinkBaseSym
; <�����T�v>  : �w��}�`�̑�����x�[�X�L���r�ɗאڂ���x�[�X�L���r�l�b�g���擾����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-04-13
; <���l>      : 00/05/08�A�b�p�[�̏ꍇ��Z�l�Ȃ���2�����_�ł̔���Ƃ���(�t�[�h�΍�)
;             :
;*************************************************************************>MOH<
(defun SKW_SearchLinkBaseSym (
  &enSS$     ;(PICKSET)�x�[�X�L���r�l�b�g�̃��X�g
  &enS1      ;(ENAME)�L���r�l�b�g�P
  /
  #ANG #D #ENS2 #H #I #CODE$
  #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #PT$ #PT0$ #UPPER #W #XD$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKW_SearchLinkBaseSym ////")
  (CFOutStateLog 1 1 " ")

  ; 00/05/08 ADD MH �A�b�p�[���ǂ����̃t���O 00/07/03 ADD �n�C�~�h���̏���
  (if (or (= CG_SKK_TWO_UPP (CFGetSymSKKCode &enS1 2))
      )   ;(wcmatch (nth 5 (CFGetXData &enS1 "G_LSYM")) "KH###PC*"))
   (setq #Upper 'T))

  ; 2000/09/11 HT �n�C�~�h���̏����Ɠ��l�����~�����[�N�g�b�v���Q������r�Ƃ��� START
  (setq #code$ (CFGetSymSKKCode &enS1 nil))
  ; 2006/09/19 HT �J�E���^�[�Ƃ̔�r����肭�����Ȃ����ߑS��2�����Ŕ��f����B
  (if T
; (if (and (= CG_SKK_ONE_CNT (nth 0 #code$)) (= CG_SKK_TWO_BAS (nth 1 #code$)))
    (progn
    (setq #Upper 'T)
    )
  )
  ; 2000/09/11 HT �n�C�~�h���̏����Ɠ��l�����~�����[�N�g�b�v���Q������r�Ƃ��� END

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
    (setq #ang (nth 2 (CFGetXData #enS2 "G_LSYM")))

    ;// ��`�̈�����߂�
    (setq #p5 (cdr (assoc 10 (entget #enS2))))
    ; 00/05/08 ADD MH �A�b�p�[�Ȃ�2�����_�ɕϊ�(�����Ⴄ�t�[�h�΍�)
    (if #Upper (setq #p5 (list (car #p5) (cadr #p5))))
    (setq #p6 (polar #p5 #ang #w))
    (setq #p7 (polar #p6 (- #ang (dtr 90)) #d))
    (setq #p8 (polar #p5 (- #ang (dtr 90)) #d))
    (setq #pt$ (list #p5 #p6 #p7 #p8))

;;; �אڂ��邩�ǂ����̔��f�����߂� 00/05/10 YM
;;;    (if (or (SKW_IsExistPRectCross    (list #p1 #p2 #p3 #p4)     (list #p5 #p6 #p7 #p8))  ; �]������
;;;           (SKW_IsExistPRectCross2CP (list #p1 #p2 #p3 #p4 #p1) (list #p5 #p6 #p7 #p8))  ; �ǉ�����00/05/10 YM
;;;           (SKW_IsExistPRectCross2CP (list #p5 #p6 #p7 #p8 #p5) (list #p1 #p2 #p3 #p4))) ; �ǉ�����00/05/10 YM

    (if (SKW_IsExistPRectCross #pt0$ #pt$)  ; �]������
      (progn
        (if (= nil (member #enS2 CG_LinkSym))
          (progn
            (setq CG_LinkSym (cons #enS2 CG_LinkSym))
            (SKW_SearchLinkBaseSym &enSS$ #enS2)
          )
        )
      )
    )
    (setq #i (1+ #i))
  );_repeat
)
;SKW_SearchLinkBaseSym

;<HOM>*************************************************************************
; <�֐���>    : SKW_IsExistPRectCross
; <�����T�v>  : �Q�̓_���X�g�ɓ���_�����邩���ׂ�
; <�߂�l>    :
;           T : ����
;         nil : �Ȃ�
; <�쐬>      : 99-10-19
; <���l>      :
;*************************************************************************>MOH<
(defun SKW_IsExistPRectCross (
    &pl1$      ;(LIST) ���W���X�g�P
    &pl2$      ;(LIST) ���W���X�g�Q
    /
    #i #j #pl1 #pl2 #loop1 #loop2
  )

  (setq #loop1 T)
  (setq #i 0)
  (while (and #loop1 (< #i (length &pl1$)))
    (setq #pl1 (nth #i &pl1$))
    (setq #loop2 T)
    (setq #j 0)
    (while (and #loop2 (< #j (length &pl2$)))
      (setq #pl2 (nth #j &pl2$))
      (if (< (distance #pl1 #pl2) 7.01) ; ���e�덷 7mm
        (progn
          (setq #loop2 nil)
          (setq #loop1 nil)
        )
      );_if
      (setq #j (1+ #j))
    );_while
    (setq #i (1+ #i))
  ) ; while
  (if #loop2
    nil
    T
  )
);SKW_IsExistPRectCross

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_MakeSKOutLine2
;;; <�����T�v>  : �L�b�`���̊O�`�̈�����ԃ|�����C����Ԃ�
;;; <�߂�l>    :
;;;       ENAME : �L�b�`���̊O�`�̈�|�����C��
;;; <�쐬>      : 2000.3.27 YM �C��
;;; <���l>      : �����Ȃ��̈悪�����ł���ꍇ��z��
;;;               ���O���ލl��
;;;
;;; +-------+     +-------+
;;; |       |�i�� |       |
;;; |   +---+     +---+   |
;;; |   |             |   |
;;; |   |             |   |
;;; +---+             +---+
;;;
;;; ���s���Ⴂ���l��
;;;*************************************************************************>MOH<
(defun PKW_MakeSKOutLine2 (
    &BaseSym$
    /
    #sym #qry$ #en #p-en$ #p-en
    #r-pl #r-ss #i #pt #pt$ #spt
    #dist$ #lst$ #lst #loop #p2 #p3
    #r-width #r-depth
    #38 #210 #en$ #xd$ #ang #hand #msg
    #ELM #R-SS0 #RET #RET$ #zu_id
    #skk$ #D_MAX #PMEN2
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_MakeSKOutLine2 ////")
  (CFOutStateLog 1 1 " ")

  ;// ���[�N�g�b�v�̊O�`�̈�(P��=2)����������

  (foreach #sym &BaseSym$
    (setq #pmen2 (PKGetPMEN_NO #sym 2)) ; PMEN2
    (if (= #pmen2 nil)
      (setq #pmen2 (PK_MakePMEN2 #sym)) ; PMEN2 ���쐬
    );_if
    (setq #lst$ (cons (list #sym #pmen2) #lst$)) ; �ް����ނ�PMEN2�̃��X�g
  )

  ;// ���߂��O�`�̈�̃N���[����REGION�Ƃ��č쐬����
  ;// �O�`�̈���S�_��REGION�ɕϊ�����
  (setq #r-ss (ssadd))
  (foreach #lst #lst$
    (setq #sym  (car #lst))  ; �ް�����
    (setq #p-en (cadr #lst)) ; PMEN=2,�����o������ 0,0,1�����ײ�
    (setq #38  (cdr (assoc 38 (entget #p-en)))) ; #38 ���x
    (setq #spt (cdr (assoc 10 (entget #sym )))) ; �e�}�`�}����_
    (setq #xd$ (CFGetXData #sym "G_LSYM"))
    (setq #ang (nth 2 #xd$)) ; ��]�p�x

    ;// �R�[�i�[�L���r�͂��̂܂܂̊O�`��
    (cond
      ((= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3)) ; CG_SKK_THR_CNR = 5 �R�[�i�[�L���r
        (entmake (cdr (entget #p-en)))
      )
      (T
        (if (= CG_SKK_ONE_RNG (CFGetSeikakuToSKKCode (nth 9 #xd$) 1)) ; CG_SKK_ONE_RNG=3 �ݼ�̰��
          (progn
            (setq #p2 (polar #spt #ang #r-width))
            (setq #p3 (polar #spt (- #ang (dtr 90)) #r-depth))
            (setq #pt (polar #p3 #ang #r-width))
          )
          (progn
            (setq #pt$ (GetLWPolyLinePt #p-en)) ; <--- �ʏ�
            (setq #dist$ nil)
            (foreach #pt #pt$
              (setq #dist$ (cons (list #pt (distance #spt #pt)) #dist$)); ����ي�_����̋���
            )
            (setq #dist$ (CFListSort #dist$ 1))

            ;// ��ԉ����_
            (setq #pt (car (last #dist$))) ; ���X�g�̍Ō�̗v�f��Ԃ��܂��B����ي�_�����ԉ����_

            (setq #p2 (CFGetDropPt #spt (list #pt (polar #pt (- #ang (dtr 90)) 10))))
            (setq #p3 (CFGetDropPt #spt (list #pt (polar #pt #ang 10))))
          )
        )
        (MakeLwPolyLine (list #spt #p2 #pt #p3) 1 0)
;;;    MakeLwPolyLine
;;;    &pt$  ;(LIST)�\�����W�_ؽ�
;;;    &cls  ;(INT) 0=�J��/1=����
;;;    &elv  ;(REAL)���x
        (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
      )
    );_(cond

    (command "_region" (entlast) "")
    (ssadd (entlast) #r-ss)
  );_(foreach #lst #lst$

  ;// �쐬����REGION��UNION�ŘA������REGION�Ƃ���
  (command "_union" #r-ss "") ; �����Ȃ��̈�ł��n�j�I

  ;// REGION�𕪉����A���������������|�����C��������
  (command "_explode" (entlast))
  (setq #r-ss (ssget "P"))

;;;�����Ȃ��̈�̏ꍇ��region���΂�΂�ɂȂ�           ; 00/03/28 YM ADD
  (if (= "REGION" (cdr (assoc 0 (entget (ssname #r-ss 0)))))
    (progn
      (setq #i 0)
      (setq #ret$ '())
      (repeat (sslength #r-ss)
        (setq #elm (ssname #r-ss #i)) ; �eregion
        (command "_explode" #elm); region����
        (setq #r-ss0 (ssget "P"))
        (command "_pedit" (entlast) "Y" "J" #r-ss0 "" "X") ; "X" ���ײ݂̑I�����I��
        (setq #ret (entlast))
        (setq #ret$ (append #ret$ (list #ret))) ; PLINE��ؽ�
        (setq #i (1+ #i))
      )
      #ret$ ; PLINE �}�`��ؽĂ�Ԃ�
    )                                                     ; 00/03/28 YM ADD
    (progn ; ���܂łǂ���(�ʏ�)
      (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ���ײ݂̑I�����I��
      (list (entlast)) ; �ʏ� ;// �O�`�|�����C���}�`��ؽĂ�Ԃ�
    )
  );_if

);PKW_MakeSKOutLine2

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_MakeSKOutLine3
;;; <�����T�v>  : �L�b�`���̊O�`�̈�����ԃ|�����C����Ԃ�@@@<���s���Ⴂ�Ή�>@@@
;;; <�߂�l>    : ENAME �L�b�`���̊O�`�̈�|�����C��
;;; <�쐬>      : 2000.3.27 YM �C�� 00/05/10 YM �C��
;;; <���l>      : �����Ȃ��̈悪�����ł���ꍇ��z��
;;;               ���O���ލl��
;;;
;;; +-------+     +-------+
;;; |       |�i�� |       |
;;; |   +---+     +---+   |
;;; |   |             |   |
;;; |   |             |   |
;;; +---+             +---+
;;;
;;; ���s���Ⴂ���l��  WT�O�ʂł炪�����Ă���ꍇ
;;;*************************************************************************>MOH<
(defun PKW_MakeSKOutLine3 (
  &BaseSym$
  /
  #38 #ANG #BASE #BASEPT #CORNERD1 #CORNERD2 #DEP_MAXL #DEP_MAXO #DEP_MAXR
  #DUMPT$ #ELM #I #ICOUNT #LST$ #OKU$ #OKU1_DIFF #OKU2_DIFF #OKU3_DIFF
  #P-EN #P1 #P2 #P3 #P4 #P5 #P6 #PFLG #PT$ #R-SS #R-SS0 #RET #RET$ #SPT #SYM #XD$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_MakeSKOutLine3 ////")
  (CFOutStateLog 1 1 " ")

  (setq #oku$ (PKDepDiffDecide &BaseSym$)) ; �߂�l
; ��Ű���ތ�,�ݸ�����s�Ⴂ(T or nil),���s���ő�,
;              ��ۑ����s�Ⴂ(T or nil),���s���ő�,(SYM PMEN2)
  (setq #icount    (nth 0 #oku$)) ; ��Ű���ތ�
  (setq #oku1_diff (nth 1 #oku$)) ; �ݸ�����s�Ⴂ(T or nil)
  (setq #dep_maxL  (nth 2 #oku$)) ; ���s���ő�
  (setq #oku2_diff (nth 3 #oku$)) ; ��ۑ����s�Ⴂ(T or nil)
  (setq #dep_maxR  (nth 4 #oku$)) ; ���s���ő�
  (setq #oku3_diff (nth 5 #oku$)) ; ��ۑ����s�Ⴂ(T or nil)
  (setq #dep_maxO  (nth 6 #oku$)) ; ���s���ő�
  (setq #lst$      (nth 7 #oku$)) ; (SYM PMEN2)ؽ�

  ;// ���߂��O�`�̈�̃N���[����REGION�Ƃ��č쐬����
  ;// �O�`�̈���S�_��REGION�ɕϊ�����
  (setq #r-ss (ssadd))
  (foreach #lst #lst$
    (setq #sym  (car   #lst)) ; �ް�����
    (setq #p-en (cadr  #lst)) ; PMEN=2,�����o������ 0,0,1�����ײ�
    (setq #pflg (caddr #lst)) ; 0:�ʒu��ʂȂ� 1:�ݸ������  2:��ۑ�����  3:���̑�������
    (setq #38  (cdr (assoc 38 (entget #p-en)))) ; #38 ���x
    (setq #spt (cdr (assoc 10 (entget #sym )))) ; �e�}�`�}����_
    (setq #xd$ (CFGetXData #sym "G_LSYM"))
    (setq #ang (nth 2 #xd$)) ; ��]�p�x

    (if (= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3)) ; CG_SKK_THR_CNR = 5 �R�[�i�[�L���r
      (progn
        (setq #pt$ (GetLWPolyLinePt #p-en))    ; PMEN2  <--- �ʏ�̏ꍇ
        (setq #base (PKGetBaseL6 #pt$))        ; ��Ű��_�����߂�(����ق����Ȃ�)
        (setq #pt$ (GetPtSeries #base #pt$))   ; #base ��擪�Ɏ��v����
;;;        (setq #pt$ (GetPtSeries #spt #pt$))    ; #spt ��擪�Ɏ��v����
        (setq #p1 (nth 0 #pt$))
        (setq #p2 (nth 1 #pt$))
        (setq #p3 (nth 2 #pt$))
        (setq #p4 (nth 3 #pt$))
        (setq #p5 (nth 4 #pt$))
        (setq #p6 (nth 5 #pt$))

        (setq #cornerD1 (distance #p2 #p3))
        (setq #cornerD2 (distance #p5 #p6))
;;; 1       2
;;; +-------+
;;; |   4   | �R�[�i�[�L���r�̏ꍇ
;;; |   +---+
;;; |   |   3
;;; +---+
;;; 6   5

        (if (and (= #pflg 12)(= #icount 2)) ; U�^�̺�Ű2
          (progn
            (cond
              ((and (= #oku2_diff nil)(= #oku3_diff nil))
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; ���̂܂�
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
              )
              ((and (= #oku2_diff T)(= #oku3_diff nil)) ; �ݸ���̂݉��s���Ⴂ L
                (if (> #dep_maxR #cornerD1) ; ���s���ő�l>��Ű���޼ݸ�����s���̏ꍇ
                  (progn ; #p1 #p2 ��������
                    (setq #p2 (polar #p3 (angle #p5 #p4) #dep_maxR))
                    (setq #p1 (CFGetDropPt #p2 (list #p1 #p6)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; ���̂܂�
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
              )
              ((and (= #oku2_diff nil)(= #oku3_diff T)) ; ��ۑ��̂݉��s���Ⴂ
                (if (> #dep_maxO #cornerD2) ; ���s���ő�l>��Ű���޺�ۑ����s���̏ꍇ
                  (progn ; #p1 #p6 ��������
                    (setq #p6 (polar #p5 (angle #p3 #p4) #dep_maxR))
                    (setq #p1 (CFGetDropPt #p6 (list #p1 #p2)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; ���̂܂�
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
              )
              ((and (= #oku2_diff T)(= #oku3_diff T)) ; �ݸ��,��ۑ� ���s���Ⴂ
                (if (> #dep_maxO #cornerD1) ; ���s���ő�l>��Ű���޼ݸ�����s���̏ꍇ
                  (progn ; #p1 #p2 ��������
                    (setq #p2 (polar #p3 (angle #p5 #p4) #dep_maxO))
                    (setq #p1 (CFGetDropPt #p2 (list #p1 #p6)))
                  )
                );_if
                (if (> #dep_maxO #cornerD2) ; ���s���ő�l>��Ű���޺�ۑ����s���̏ꍇ
                  (progn ; #p1 #p6 ��������
                    (setq #p6 (polar #p5 (angle #p3 #p4) #dep_maxO))
                    (setq #p1 (CFGetDropPt #p6 (list #p1 #p2)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; ���̂܂�
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
              )
            );_cond
          )
        );_if

        (if (or (= #icount 1)                    ; L�^�̺�Ű��������
                (and (= #pflg 11)(= #icount 2))) ; U�^�̺�Ű1
          (progn
            (cond
              ((and (= #oku1_diff nil)(= #oku2_diff nil))
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; ���̂܂�
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
              )
              ((and (= #oku1_diff T)(= #oku2_diff nil)) ; �ݸ���̂݉��s���Ⴂ L
                (if (> #dep_maxL #cornerD1) ; ���s���ő�l>��Ű���޼ݸ�����s���̏ꍇ
                  (progn ; #p1 #p2 ��������
                    (setq #p2 (polar #p3 (angle #p5 #p4) #dep_maxL))
                    (setq #p1 (CFGetDropPt #p2 (list #p1 #p6)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; ���̂܂�
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
              )
              ((and (= #oku1_diff nil)(= #oku2_diff T)) ; ��ۑ��̂݉��s���Ⴂ
                (if (> #dep_maxR #cornerD2) ; ���s���ő�l>��Ű���޺�ۑ����s���̏ꍇ
                  (progn ; #p1 #p6 ��������
                    (setq #p6 (polar #p5 (angle #p3 #p4) #dep_maxR))
                    (setq #p1 (CFGetDropPt #p6 (list #p1 #p2)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; ���̂܂�
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
              )
              ((and (= #oku1_diff T)(= #oku2_diff T)) ; �ݸ��,��ۑ� ���s���Ⴂ
                (if (> #dep_maxL #cornerD1) ; ���s���ő�l>��Ű���޼ݸ�����s���̏ꍇ
                  (progn ; #p1 #p2 ��������
                    (setq #p2 (polar #p3 (angle #p5 #p4) #dep_maxL))
                    (setq #p1 (CFGetDropPt #p2 (list #p1 #p6)))
                  )
                );_if
                (if (> #dep_maxR #cornerD2) ; ���s���ő�l>��Ű���޺�ۑ����s���̏ꍇ
                  (progn ; #p1 #p6 ��������
                    (setq #p6 (polar #p5 (angle #p3 #p4) #dep_maxR))
                    (setq #p1 (CFGetDropPt #p6 (list #p1 #p2)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; ���̂܂�
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
              )
            );_cond
          )
        );_if

      )
;;; else
      (progn ; ��Ű���ވȊO(�ʏ���)
;;; spt       p2
;;;  +--------+
;;;  |        |
;;;  |        |
;;;  +--------+
;;; p3        pt

;;; ���s���Ⴂ�Ȃ��̏ꍇ
        (setq #pt$ (GetLWPolyLinePt #p-en))               ; PMEN2  <--- �ʏ�̏ꍇ
        (setq #dumpt$ (GetPtSeries #spt #pt$))            ; #BASEPT ��擪�Ɏ��v���� (00/05/20 YM)
        (if #dumpt$
          (setq #pt$ #dumpt$) ; nil �łȂ�
          (progn ; �O�`�_���ɼ���ق��Ȃ��ꍇ
            (setq #BASEPT (PKGetBaseI4 #pt$ (list #sym))) ; �_��Ƽ���ي�_�P�� (00/05/20 YM)
            (setq #pt$ (GetPtSeries #BASEPT #pt$))        ; #BASEPT ��擪�Ɏ��v���� (00/05/20 YM)
          )
        );_if
        (setq #p1 (nth 0 #pt$))
        (setq #p2 (nth 1 #pt$))
        (setq #p3 (nth 2 #pt$))
        (setq #p4 (nth 3 #pt$))

        (cond
          ((and (or (= #pflg 1)(= #pflg 0))
                (= #oku1_diff T)) ; �ݸ�����s���Ⴂ
            (setq #p2 (polar #p3 (+ #ang (dtr 90)) #dep_maxL))
            (setq #p1 (polar #p4 (+ #ang (dtr 90)) #dep_maxL))
          )
          ((and (= #pflg 2)(= #oku2_diff T)) ; ��ۑ����s���Ⴂ
            (setq #p2 (polar #p3 (+ #ang (dtr 90)) #dep_maxR))
            (setq #p1 (polar #p4 (+ #ang (dtr 90)) #dep_maxR))
          )
          ((and (= #pflg 3)(= #oku3_diff T)) ; ���̑������s���Ⴂ
            (setq #p2 (polar #p3 (+ #ang (dtr 90)) #dep_maxO))
            (setq #p1 (polar #p4 (+ #ang (dtr 90)) #dep_maxO))
          )
        );_cond

;;;    MakeLwPolyLine
;;;    &pt$  ;(LIST)�\�����W�_ؽ�
;;;    &cls  ;(INT) 0=�J��/1=����
;;;    &elv  ;(REAL)���x

        (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0)
        (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
      )
    );_if

    (command "_region" (entlast) "")
    (ssadd (entlast) #r-ss)
  );_(foreach #lst #lst$

  ;// �쐬����REGION��UNION�ŘA������REGION�Ƃ���
  (command "_union" #r-ss "") ; �����Ȃ��̈�ł��n�j�I

  ;// REGION�𕪉����A���������������|�����C��������
  (command "_explode" (entlast))
  (setq #r-ss (ssget "P"))

;;;�����Ȃ��̈�̏ꍇ��region���΂�΂�ɂȂ�
  (if (= "REGION" (cdr (assoc 0 (entget (ssname #r-ss 0)))))
    (progn
      (setq #i 0)
      (setq #ret$ '())
      (repeat (sslength #r-ss)
        (setq #elm (ssname #r-ss #i)) ; �eregion
        (command "_explode" #elm); region����
        (setq #r-ss0 (ssget "P"))
        (command "_pedit" (entlast) "Y" "J" #r-ss0 "" "X") ; "X" ���ײ݂̑I�����I��
        (setq #ret (entlast))
        (setq #ret$ (append #ret$ (list #ret))) ; PLINE��ؽ�
        (setq #i (1+ #i))
      )
      #ret$ ; PLINE �}�`��ؽĂ�Ԃ�
    )                                                     ; 00/03/28 YM ADD
    (progn ; ���܂łǂ���(�ʏ�)
      (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ���ײ݂̑I�����I��
      (setq #ret$ (list (entlast))) ; �ʏ� ;// �O�`�|�����C���}�`��ؽĂ�Ԃ�
    )
  );_if

  #ret$ ; PLINE �}�`��ؽĂ�Ԃ�

);PKW_MakeSKOutLine3

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKDepDiffDecide
;;; <�����T�v>  : �۱���޼���ِ}�`ؽĂ�n���ĉ��s���Ⴂ���ނ̗L���𔻒�
;;; <�߂�l>    : ���s���ő�,���s���L���Ȃ�(�ڍׂ͊֐��̖���)
;;; <�쐬>      : 2000.5.10 YM I,L�^�Ή� 05/17 U�^�Ή�
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKDepDiffDecide (
  &BaseSym$
  /
  #BASE #BASE1 #BASE2
  #CORNER #CORNER1 #CORNER2
  #DEP #DEP_MAXL #DEP_MAXO #DEP_MAXR #DEP_MINL #DEP_MINO #DEP_MINR
  #DUM #ICOUNT #LR #LST$
  #OKU1_DIFF #OKU2_DIFF #OKU3_DIFF
  #PMEN2 #PMEN2-1 #PMEN2-2
  #PT$ #PT1$ #PT2$ #SKK$ #corner$ #ret$
  )

; ��Ű���ނ̐����J�E���g
  (setq #icount 0) ; ��Ű���ނ̌�
  (foreach #sym &BaseSym$
    (setq #skk$ (CFGetSymSKKCode #sym nil))
    (if (= (nth 2 #skk$) CG_SKK_THR_CNR)    ; �R�[�i�[�L���r���ǂ����̔���
      (progn
        (setq #icount (1+ #icount))
        (setq #corner$ (append #corner$ (list #sym))) ; ��Ű���޼���ِ}�`��ؽ�
      )
    )
  )
; ���s���Ⴂ����
  (cond
    ((= #icount 0) ; I�^�̏ꍇ
      (setq #ret$ (PKDDD_I &BaseSym$))
    )
    ((= #icount 1) ; L�^�̏ꍇ
      (setq #ret$ (PKDDD_L &BaseSym$ #corner$))
    )
    ((= #icount 2) ; U�^�̏ꍇ
      (setq #ret$ (PKDDD_U &BaseSym$ #corner$))
    )
  );_cond

; ��Ű���ތ�,�ݸ��   ���s�Ⴂ(T or nil),���s���ő�,��Ű���޼ݸ��   ���s��,
;              ��ۑ�   ���s�Ⴂ(T or nil),���s���ő�,��Ű���޺�ۑ�   ���s��,
;              ���̑������s�Ⴂ(T or nil),���s���ő�,��Ű���ނ��̑������s��,(SYM PMEN2)
;;; (list #icount #oku1_diff #dep_maxL #oku2_diff #dep_maxR #oku3_diff #dep_maxO #lst$)
  (cons #icount #ret$)
);PKDepDiffDecide

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKDDD_I
;;; <�����T�v>  : �۱���޼���ِ}�`ؽĂ�n���ĉ��s���Ⴂ���ނ̗L���𔻒� (I�^�p)
;;; <�߂�l>    : ���s���ő�,���s���L���Ȃ�(�ڍׂ͊֐��̖���)
;;; <�쐬>      : 05/17 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKDDD_I (
  &BaseSym$ ; �ް����޼���ِ}�`
  /
  #BASE #DEP #DEP_MAXL #DEP_MAXO #DEP_MAXR #DEP_MINL #DEP_MINO #DEP_MINR
  #LST$ #OKU1_DIFF #OKU2_DIFF #OKU3_DIFF #PMEN2 #PT$ #BASEPT #DUMPT$
  )
  (setq #dep_maxL -99999)
  (setq #dep_minL  99999)
  (setq #dep_maxR -99999)
  (setq #dep_minR  99999)
  (setq #dep_maxO -99999)
  (setq #dep_minO  99999)

  (setq #oku1_diff nil)
  (setq #oku2_diff nil)
  (setq #oku3_diff nil)
  (setq #lst$ nil)

  (foreach #sym &BaseSym$
    (setq #pmen2 (PKGetPMEN_NO #sym 2))             ; PMEN2
    (if (= #pmen2 nil)
;-- 2011/10/21 A.Satoh Mod - S
;;;;;      (setq #pmen2 (PK_MakePMEN2 #sym))   ; PMEN2 ���쐬
			(if (/= (nth 9 (CFGetXData #sym "G_LSYM")) 110)
      	(setq #pmen2 (PK_MakePMEN2 #sym))   ; PMEN2 ���쐬
			)
;-- 2011/10/21 A.Satoh Mod - E
    );_if
;-- 2011/10/21 A.Satoh Add - S
    (if (/= #pmen2 nil)
			(progn
;-- 2011/10/21 A.Satoh Add - E
    (setq #lst$ (cons (list #sym #pmen2 0) #lst$))  ; �ް�����,PMEN2,���׸ނ̃��X�g
    (setq #base (cdr (assoc 10 (entget #sym))))     ; ����ي�_
    (setq #pt$  (GetLWPolyLinePt #pmen2))           ; PMEN2 �O�`�̈�
    (setq #dumpt$ (GetPtSeries #base #pt$))         ; #base ��擪�Ɏ��v����     (00/05/20 YM)
    (if #dumpt$
      (setq #pt$ #dumpt$) ; nil �łȂ�
      (progn ; �O�`�_���ɼ���ق��Ȃ��ꍇ
        (setq #basePT (PKGetBaseI4 #pt$ (list #sym))) ; PMEN2����ɼ���ق��Ȃ��Ă��� (00/05/20 YM)
        (setq #pt$  (GetPtSeries #basePT #pt$))       ; #base ��擪�Ɏ��v����       (00/05/20 YM)
      )
    );_if

    (setq #dep  (distance (nth 1 #pt$)(nth 2 #pt$))); �^�̉��s��(���@D�͑ʖ�)

    (if (<= #dep_maxL #dep)
      (setq #dep_maxL #dep) ; ���s���̍ő�l�����߂�
    );_if
    (if (>= #dep_minL #dep)
      (setq #dep_minL #dep) ; ���s���̍ŏ��l�����߂�
    );_if
;-- 2011/10/21 A.Satoh Add - S
			)
		)
;-- 2011/10/21 A.Satoh Add - E
  )
  (if (= nil (equal #dep_maxL #dep_minL 0.01))
    (setq #oku1_diff T) ; ���s���Ⴂ����
  );_if

  (list #oku1_diff #dep_maxL #oku2_diff #dep_maxR #oku3_diff #dep_maxO #lst$)
);PKDDD_I

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKDDD_L
;;; <�����T�v>  : �۱���޼���ِ}�`ؽĂ�n���ĉ��s���Ⴂ���ނ̗L���𔻒� (L�^�p)
;;; <�߂�l>    : ���s���ő�,���s���L���Ȃ�(�ڍׂ͊֐��̖���)
;;; <�쐬>      : 05/17 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKDDD_L (
  &BaseSym$ ; �ް����޼���ِ}�`
  &corner$  ; ��Ű����ؽ�
  /
  #BASE #CORNER #CORNER$
  #DEP #DEP1 #DEP2 #DEP_MAXL #DEP_MAXO #DEP_MAXR #DEP_MINL #DEP_MINO #DEP_MINR
  #LR #LST$ #BASEPT #PT0$ #DUMPT$
  #OKU1_DIFF #OKU2_DIFF #OKU3_DIFF #PMEN2 #PT$ #SKK$
  )
  (setq #dep_maxL -99999)
  (setq #dep_minL  99999)
  (setq #dep_maxR -99999)
  (setq #dep_minR  99999)
  (setq #dep_maxO -99999)
  (setq #dep_minO  99999)

  (setq #oku1_diff nil)
  (setq #oku2_diff nil)
  (setq #oku3_diff nil)
  (setq #lst$ nil)
  (setq #corner$ &corner$)

;;; p1����p4�֌������޸�ق̍����ɉ��s���Ⴂ�������#oku1_diff=T
;;; p1����p4�֌������޸�ق̉E���ɉ��s���Ⴂ�������#oku2_diff=T
;;;  p1             p2
;;;  +--------------+------------+
;;;  |              |            |
;;;  | ��Ű����     | #oku1_diff |
;;;  |         p4   |            |
;;;  |          +---+------------+
;;;  |          |  p3
;;;p6+----------+p5
;;;  |          |
;;;  |          |
;;;  |#oku2_diff|
;;;  |          |
;;;  +----------+

  (setq #corner (car #corner$)); ��Ű���޼���ِ}�`
;;; PMEN2 ��T��
  (setq #pmen2 (PKGetPMEN_NO #corner 2))            ; PMEN2
  (setq #lst$ (cons (list #corner #pmen2 0) #lst$)) ; �ް�����,PMEN2,���׸ނ̃��X�g
;;;  (setq #base (cdr (assoc 10 (entget #corner))))    ; ����ي�_
  (setq #pt0$ (GetLWPolyLinePt #pmen2))             ; PMEN2 �O�`�̈�
  (setq #base (PKGetBaseL6 #pt0$))                  ; ��Ű��_�����߂�(����ق����Ȃ�)
  (setq #pt0$ (GetPtSeries #base #pt0$))            ; #base ��擪�Ɏ��v����

  (setq #dep1 (distance (nth 1 #pt0$) (nth 2 #pt0$)))
  (setq #dep2 (distance (nth 4 #pt0$) (nth 5 #pt0$)))

  (if (<= #dep_maxL #dep1)
    (setq #dep_maxL #dep1) ; �ݸ�����s���̍ő�l�����߂�
  );_if
  (if (>= #dep_minL #dep1)
    (setq #dep_minL #dep1) ; �ݸ�����s���̍ŏ��l�����߂�
  );_if

  (if (<= #dep_maxR #dep2)
    (setq #dep_maxR #dep2) ; ��ۑ����s���̍ő�l�����߂�
  );_if
  (if (>= #dep_minR #dep2)
    (setq #dep_minR #dep2) ; ��ۑ����s���̍ŏ��l�����߂�
  );_if

  (foreach #sym &BaseSym$
    (setq #skk$ (CFGetSymSKKCode #sym nil))
    (if (/= (nth 2 #skk$) CG_SKK_THR_CNR)               ; ��Ű���ނ��ǂ����̔���
      (progn ; ��Ű���ނłȂ�
        (setq #pmen2 (PKGetPMEN_NO #sym 2))             ; PMEN2
        (if (= #pmen2 nil)
;-- 2011/10/21 A.Satoh Mod - S
;;;;;          (setq #pmen2 (PK_MakePMEN2 #sym))             ; PMEN2 ���쐬
					(if (/= (nth 9 (CFGetXData #sym "G_LSYM")) 110)
      			(setq #pmen2 (PK_MakePMEN2 #sym))   ; PMEN2 ���쐬
					)
;-- 2011/10/21 A.Satoh Mod - E
        );_if
;-- 2011/10/21 A.Satoh Add - S
		    (if (/= #pmen2 nil)
					(progn
;-- 2011/10/21 A.Satoh Add - E
        (setq #base (cdr (assoc 10 (entget #sym))))     ; ����ي�_
        (setq #pt$ (GetLWPolyLinePt #pmen2))            ; PMEN2 �O�`�̈�
        (setq #dumpt$ (GetPtSeries #base #pt$))         ; #basePT ��擪�Ɏ��v���� (00/05/20 YM)
        (if #dumpt$
          (setq #pt$ #dumpt$) ; nil �łȂ�
          (progn ; �O�`�_���ɼ���ق��Ȃ��ꍇ
            (setq #BASEPT (PKGetBaseI4 #pt$ (list #sym))) ; �_��Ƽ���ي�_�P��      (00/05/20 YM)
            (setq #pt$ (GetPtSeries #BASEPT #pt$))        ; #basePT ��擪�Ɏ��v���� (00/05/20 YM)
          )
        );_if

        (setq #dep (distance (nth 1 #pt$)(nth 2 #pt$))) ; �^�̉��s��(���@D�͑ʖ�)

        (setq #lr (CFArea_rl (nth 0 #pt0$) (nth 3 #pt0$) #base))
        (if (= #lr -1)
          (progn ; �E���ł������ꍇ
            (setq #lst$ (cons (list #sym #pmen2 2) #lst$)) ; �ް�����,PMEN2,���׸�(��ۑ�=2)�̃��X�g
            (if (<= #dep_maxR #dep)
              (setq #dep_maxR #dep) ; ��ۑ����s���̍ő�l�����߂�
            );_if
            (if (>= #dep_minR #dep)
              (setq #dep_minR #dep) ; ��ۑ����s���̍ŏ��l�����߂�
            );_if
          )
          (progn ; �����ł������ꍇ
            (setq #lst$ (cons (list #sym #pmen2 1) #lst$)) ; �ް�����,PMEN2,���׸�(�ݸ��=1)�̃��X�g
            (if (<= #dep_maxL #dep)
              (setq #dep_maxL #dep) ; �ݸ�����s���̍ő�l�����߂�
            );_if
            (if (>= #dep_minL #dep)
              (setq #dep_minL #dep) ; �ݸ�����s���̍ŏ��l�����߂�
            );_if
          )
        );_if
;-- 2011/10/21 A.Satoh Add - S
					)
				)
;-- 2011/10/21 A.Satoh Add - E
      )
    );_if
  )
  (if (= nil (equal #dep_maxL #dep_minL 0.01))
    (setq #oku1_diff T) ; ���s���Ⴂ����
  );_if
  (if (= nil (equal #dep_maxR #dep_minR 0.01))
    (setq #oku2_diff T) ; ���s���Ⴂ����
  );_if

  (list #oku1_diff #dep_maxL #oku2_diff #dep_maxR #oku3_diff #dep_maxO #lst$)
);PKDDD_L

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKDDD_U
;;; <�����T�v>  : �۱���޼���ِ}�`ؽĂ�n���ĉ��s���Ⴂ���ނ̗L���𔻒� (U�^�p)
;;; <�߂�l>    : ���s���ő�,���s���L���Ȃ�(�ڍׂ͊֐��̖���)
;;; <�쐬>      : 05/17 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKDDD_U (
  &BaseSym$ ; �ް����޼���ِ}�`
  &corner$  ; ��Ű����ؽ�
  /
  #BASE #BASEPT #BASE1 #BASE2 #CORNER$ #CORNER1 #CORNER2
  #DEP #DEP1 #DEP2 #DEP3 #DEP4 #DEP_MAXL #DEP_MAXO #DEP_MAXR #DEP_MINL
  #DEP_MINO #DEP_MINR #DUMPT$
  #DUM #LR #LR2 #LST$ #OKU1_DIFF #OKU2_DIFF #OKU3_DIFF
  #PMEN2 #PMEN2-1 #PMEN2-2 #PT$ #PT1$ #PT2$ #SKK$ PKDDD_U
  )
  (setq #dep_maxL -99999)
  (setq #dep_minL  99999)
  (setq #dep_maxR -99999)
  (setq #dep_minR  99999)
  (setq #dep_maxO -99999)
  (setq #dep_minO  99999)

  (setq #oku1_diff nil)
  (setq #oku2_diff nil)
  (setq #oku3_diff nil)
  (setq #lst$ nil)
  (setq #corner$ &corner$)

;;; p1����p4�֌������޸�ق̂ǂ��瑤�ɺ�Ű����2�����邩

;;;  p1
;;;  +--------------+------------+
;;;  |              |            |
;;;  | ��Ű����1    | #oku1_diff |
;;;  |              |            |
;;;  |          +---+------------+
;;;  |          |p4
;;;  +----------+
;;;  |          |
;;;  |#oku2_diff|
;;;  |          |
;;;  +----------+
;;;  |          |
;;;  |          +---+------------+
;;;  |              |            |
;;;  | ��Ű����2    | #oku3_diff |
;;;  |              |            |
;;;  +--------------+------------+

  (setq #corner1 (car  #corner$)); ��Ű���޼���ِ}�`1(��)
  (setq #base1 (cdr (assoc 10 (entget #corner1))))    ; ����ي�_1
  (setq #pmen2-1 (PKGetPMEN_NO #corner1 2))           ; PMEN2(��Ű1)
  (setq #pt1$ (GetLWPolyLinePt #pmen2-1))             ; PMEN2 �O�`�̈�(��Ű1)
  (setq #pt1$ (GetPtSeries #base1 #pt1$))             ; #base ��擪�Ɏ��v����(��Ű1)

  (setq #corner2 (cadr #corner$)); ��Ű���޼���ِ}�`2(��)
  (setq #base2 (cdr (assoc 10 (entget #corner2))))    ; ����ي�_2
  (setq #pmen2-2 (PKGetPMEN_NO #corner2 2))           ; PMEN2(��Ű2)
  (setq #pt2$ (GetLWPolyLinePt #pmen2-2))             ; PMEN2 �O�`�̈�(��Ű2)
  (setq #pt2$ (GetPtSeries #base2 #pt2$))             ; #base ��擪�Ɏ��v����(��Ű2)

  (setq #lr (CFArea_rl (nth 0 #pt1$) (nth 3 #pt1$) #base2)) ; ��Ű2���A��Ű1�Ίp���̂ǂ��炩���f

  (if (= #lr 1)
    (progn ; �����ł������ꍇ�A��Ű����1(��)�����ͺ�Ű����2�������̂ŊO�`�_������ւ�
      (setq #dum #pt1$)
      (setq #pt1$ #pt2$)
      (setq #pt2$ #dum)
      (setq #lst$ (cons (list #corner1 #pmen2-1 12) #lst$)) ; �ް�����,PMEN2,���׸ނ̃��X�g
      (setq #lst$ (cons (list #corner2 #pmen2-2 11) #lst$)) ; �ް�����,PMEN2,���׸ނ̃��X�g
    )
    (progn
      (setq #lst$ (cons (list #corner1 #pmen2-1 11) #lst$)) ; �ް�����,PMEN2,���׸ނ̃��X�g
      (setq #lst$ (cons (list #corner2 #pmen2-2 12) #lst$)) ; �ް�����,PMEN2,���׸ނ̃��X�g
    )
  );_if

  (setq #dep1 (distance (nth 1 #pt1$) (nth 2 #pt1$))) ; ��Ű1�ݸ�����s��
  (setq #dep2 (distance (nth 4 #pt1$) (nth 5 #pt1$))) ; ��Ű1��ۑ����s��
  (setq #dep3 (distance (nth 1 #pt2$) (nth 2 #pt2$))) ; ��Ű2��ۑ����s��
  (setq #dep4 (distance (nth 4 #pt2$) (nth 5 #pt2$))) ; ��Ű2���̑������s��

  (if (<= #dep_maxL #dep1)
    (setq #dep_maxL #dep1) ; �ݸ�����s���̍ő�l�����߂�
  );_if
  (if (>= #dep_minL #dep1)
    (setq #dep_minL #dep1) ; �ݸ�����s���̍ŏ��l�����߂�
  );_if

  (if (<= #dep_maxR #dep2)
    (setq #dep_maxR #dep2) ; ��ۑ����s���̍ő�l�����߂�
  );_if
  (if (>= #dep_minR #dep2)
    (setq #dep_minR #dep2) ; ��ۑ����s���̍ŏ��l�����߂�
  );_if

  (if (<= #dep_maxR #dep3)
    (setq #dep_maxR #dep3) ; ��ۑ����s���̍ő�l�����߂�
  );_if
  (if (>= #dep_minR #dep3)
    (setq #dep_minR #dep3) ; ��ۑ����s���̍ŏ��l�����߂�
  );_if

  (if (<= #dep_maxO #dep4)
    (setq #dep_maxO #dep4) ; ���̑������s���̍ő�l�����߂�
  );_if
  (if (>= #dep_minO #dep4)
    (setq #dep_minO #dep4) ; ���̑������s���̍ŏ��l�����߂�
  );_if

  (foreach #sym &BaseSym$
    (setq #skk$ (CFGetSymSKKCode #sym nil))
    (if (/= (nth 2 #skk$) CG_SKK_THR_CNR)               ; ��Ű���ނ��ǂ����̔���
      (progn ; ��Ű���ނłȂ�
        (setq #pmen2 (PKGetPMEN_NO #sym 2))             ; �ePMEN2(��Ű���ވȊO)
        (if (= #pmen2 nil)
;-- 2011/10/21 A.Satoh Mod - S
;;;;;          (setq #pmen2 (PK_MakePMEN2 #sym))   ; PMEN2 ���쐬
					(if (/= (nth 9 (CFGetXData #sym "G_LSYM")) 110)
      			(setq #pmen2 (PK_MakePMEN2 #sym))   ; PMEN2 ���쐬
					)
;-- 2011/10/21 A.Satoh Mod - E
        );_if
;-- 2011/10/21 A.Satoh Add - S
		    (if (/= #pmen2 nil)
					(progn
;-- 2011/10/21 A.Satoh Add - E
        (setq #base (cdr (assoc 10 (entget #sym))))     ; ����ي�_
        (setq #pt$ (GetLWPolyLinePt #pmen2))            ; PMEN2 �O�`�̈�
        (setq #dumpt$ (GetPtSeries #base #pt$))         ; #base ��擪�Ɏ��v����
        (if #dumpt$
          (setq #pt$ #dumpt$) ; nil �łȂ�
          (progn ; �O�`�_���ɼ���ق��Ȃ��ꍇ
            (setq #BASEPT (PKGetBaseI4 #pt$ (list #sym))) ; �_��Ƽ���ي�_�P��    (00/05/20 YM)
            (setq #pt$ (GetPtSeries #BASEPT #pt$))        ; #base ��擪�Ɏ��v���� (00/05/20 YM)
          )
        );_if

        (setq #dep (distance (nth 1 #pt$)(nth 2 #pt$))) ; �^�̉��s��(���@D�͑ʖ�)

        (setq #lr (CFArea_rl (nth 3 #pt1$) (nth 2 #pt1$) #base))
        (if (= #lr 1) ; ��
          (progn ; �����ł������ꍇ �ݸ���ɂ��鷬�ނł���
            (setq #lst$ (cons (list #sym #pmen2 1) #lst$)) ; �ް�����,PMEN2,���׸�(�ݸ��=1)�̃��X�g
            (if (<= #dep_maxL #dep)
              (setq #dep_maxL #dep) ; �ݸ�����s���̍ő�l�����߂�
            );_if
            (if (>= #dep_minL #dep)
              (setq #dep_minL #dep) ; �ݸ�����s���̍ŏ��l�����߂�
            );_if
          )
          (progn ; ����ȊO
            (setq #lr (CFArea_rl (nth 3 #pt2$) (nth 4 #pt2$) #base)) ; ��Ű����2�Ŕ��f
            (if (= #lr -1) ; �E
              (progn ; �E���ł������ꍇ ���̑����ɂ��鷬�ނł���
                (setq #lst$ (cons (list #sym #pmen2 3) #lst$)) ; �ް�����,PMEN2,���׸�(���̑���=3)�̃��X�g
                (if (<= #dep_maxO #dep)
                  (setq #dep_maxO #dep) ; ���̑������s���̍ő�l�����߂�
                );_if
                (if (>= #dep_minO #dep)
                  (setq #dep_minO #dep) ; ���̑������s���̍ŏ��l�����߂�
                );_if
              )
              (progn ; ����ȊO ��ۑ����ނł���
                (setq #lst$ (cons (list #sym #pmen2 2) #lst$)) ; �ް�����,PMEN2,���׸�(��ۑ�=2)�̃��X�g
                (if (<= #dep_maxR #dep)
                  (setq #dep_maxR #dep) ; ��ۑ����s���̍ő�l�����߂�
                );_if
                (if (>= #dep_minR #dep)
                  (setq #dep_minR #dep) ; ��ۑ����s���̍ŏ��l�����߂�
                );_if
              )
            );_if

          )
        );_if
;-- 2011/10/21 A.Satoh Add - S
					)
				)
;-- 2011/10/21 A.Satoh Add - E
      )
    );_if
  )
  (if (= nil (equal #dep_maxL #dep_minL 0.01))
    (setq #oku1_diff T) ; ���s���Ⴂ����
  );_if
  (if (= nil (equal #dep_maxR #dep_minR 0.01))
    (setq #oku2_diff T) ; ���s���Ⴂ����
  );_if
  (if (= nil (equal #dep_maxO #dep_minO 0.01))
    (setq #oku3_diff T) ; ���s���Ⴂ����
  );_if

  (list #oku1_diff #dep_maxL #oku2_diff #dep_maxR #oku3_diff #dep_maxO #lst$)
);PKDDD_U

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetBaseI4
;;; <�����T�v>  : ���_��4��I�^�`��O�`���ײ݂̺�Ű��_�����߂�(����ِ}�`ؽĂ��n��)
;;; <�߂�l>    : ��Ű��_���W
;;; <�쐬>      : 2000.5.19 YM
;;; <���l>      :
;;;               ���ޑ}���p�x�݂͂Ȃ�(׼ޱ݂�2*PI�𒴂�����ϲŽ��0.0�t�߂̊p�x�̏������߂�ǂ�)
;;;
;;; ���߂麰Ű
;;;  *----@-----@----+
;;;  |    |     |    | ���s���Ⴂ�v�s(@�ͼ���ي�_)
;;;  @----+     |    @----+
;;;  |    |     |    |    |
;;;  |    |     |    |    |
;;;  +----+-----+----+----+
;;;
;;; (car #vect1)*------>*(cadr #vect1) ����ȯĔz�u�p�x�̕����޸��
;;;
;;; (car #vect2)*------>*(cadr #vect2)
;;;*************************************************************************>MOH<
(defun PKGetBaseI4 (
  &pt$   ; �O�`�_��
  &Base$ ; ����ي�_ؽ�
  /
  #ANG #BASE #BASEPT #BASEX #BASEXY #DIST #I #LST$ #LST$$ #SYM #X1 #Y1
  )
  (setq #lst$$ '())
;;; ؽĂ̍ŏ��̼���ق����_(0,0)�Ƃ���
  (setq #basePT (cdr (assoc 10 (entget (car &Base$)))))
  (setq #ang (nth 2 (CFGetXData (car &Base$) "G_LSYM"))) ; �z�u�p�x
  (setq #x1 (polar #basePT #ang 1000))
  (setq #y1 (polar #basePT (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #basePT #x1 #y1)
;;; ����ق����W��ؽĂ����߂�
  (setq #i 0)
  (foreach #sym &Base$
    (setq #baseXY (cdr (assoc 10 (entget #sym)))) ; ����ق�x���W
    (setq #baseX (car (trans #baseXY 0 1)))       ; հ�ް���W�n�ɕϊ�
    (setq #lst$ (list #baseX #sym))
    (setq #lst$$ (append #lst$$ (list #lst$)))
    (setq #i (1+ #i))
  )
  (command "._ucs" "P")
  (setq #lst$$ (CFListSort #lst$$ 0)) ; (nth 0 �����������̏��ɿ��
;;; ��ԍ��̼����
  (setq #sym (cadr (car #lst$$)))
  (setq #baseXY (cdr (assoc 10 (entget #sym))))
;;; �O�`�_��Ƽ���ق̋�����ؽĂ����߂�
  (setq #i 0)
  (setq #lst$$ '())
  (foreach #pt &pt$
    (setq #dist (distance #pt #baseXY))
    (setq #lst$ (list #dist #pt))
    (setq #lst$$ (append #lst$$ (list #lst$)))
    (setq #i (1+ #i))
  )
  (setq #lst$$ (CFListSort #lst$$ 0)) ; (nth 0 �����������̏��ɿ��
  (setq #base (cadr (car #lst$$)))
  #base ; I�^��Ű��_
);PKGetBaseI4

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetBaseL6
;;; <�����T�v>  : ���_��6��L�^�`��O�`���ײ݂̺�Ű��_�����߂�(����ق��݂Ȃ�)
;;; <�߂�l>    : point
;;; <�쐬>      : 2000.5.15 YM
;;; <���l>      :
;;;
;;; ��Ű
;;;  *-------------+
;;;  |             |
;;;  |    +--------+
;;;  |    |
;;;  |    |
;;;  +----+
;;;
;;; a*------>*b
;;;
;;;          *c : #a����#b�֌������x�N�g���̉E
;;; <����>
;;; �A������3�_����A���E�̂ǂ���ɋȂ����Ă��邩���݂�
;;; ���v����Ɍ��Ă������ꍇ�A�����R�[�i�[�̂ݍ��Ȃ���ƂȂ�B
;;; ��������3�ڂ̓_�����߂�R�[�i�[��_
;;;*************************************************************************>MOH<
(defun PKGetBaseL6 (
  &pt0$ ; �O�`�_��
  /
  #A #B #C #FLG #FLG$ #I #PT$ #BASE #NO$ #SUM X #MSG
  )
;;;  (setq #pt0$ (GetLWPolyLinePt &OutPline)) ; �O�`�_��
  (setq #pt$ (append &pt0$ &pt0$))
  (if (= (length #pt$) 12)
    (progn
      (setq #i 1)
      (setq #flg$ '())
      ;;; #c��#a����#b�֌������x�N�g���̉E������
      (repeat 10
        (setq #a (nth (1- #i) #pt$)) ; �O�̓_
        (setq #b (nth #i      #pt$)) ; ���݂̓_
        (setq #c (nth (1+ #i) #pt$)) ; ���̓_
        (setq #flg (CFArea_rl #a #b #c)) ; -1:�E , 1:��
        (setq #flg$ (append #flg$ (list #flg)))
        (setq #i (1+ #i))
      )
    )
    (progn
      (setq #msg "�O�`�̈����ײ݂̒��_�̐����U�ł͂���܂���B")
      (if (= CG_AUTOMODE 2) ; 02/09/04 YM ADD
        (WebOutLog #msg)    ; 02/09/04 YM ADD
        (CFAlertMsg #msg)
      )
    )
  );_if

  (setq #sum 0)
  (foreach #flg #flg$  ; ؽĂ̘a
    (setq #sum (+ #sum #flg))
  )

  (if (< #sum 0)
    (setq #flg$ (mapcar '(lambda (x) (* x -1)) #flg$)) ; ���v���Ȃ�
  );_if

  (setq #i 0)
  (foreach #flg #flg$
    (if (= #flg -1)
      (setq #no$ (append #no$ (list #i))) ; -1�����Ԗڂ�
    )
    (setq #i (1+ #i))
  )

  (if (> (- (car #no$) 2) 0)
    (setq #base (nth (- (car  #no$) 2) #pt$))
    (setq #base (nth (- (cadr #no$) 2) #pt$))
  );_if
  #base ; L�^��Ű��_
);PKGetBaseL6

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetBaseU8
;;; <�����T�v>  : ���_��8��U�^�`��O�`���ײ݂̺�Ű��_�����߂�(����ق��݂Ȃ�)
;;; <�߂�l>    : point list(��Ű1 , ��Ű2)
;;; <�쐬>      : 2000.5.16 YM
;;; <���l>      :
;;;
;;; ��Ű1
;;;  *-------------+
;;;  |             |
;;;  |    +--------+
;;;  |    |
;;;  |    |
;;;  |    +------+
;;;  |           |
;;;  *-----------+
;;; ��Ű2
;;;
;;; a*------>*b
;;;
;;;          *c : #a����#b�֌������x�N�g���̉E
;;;*************************************************************************>MOH<
(defun PKGetBaseU8 (
  &pt0$ ; �O�`�_��
  /
  #A #B #BASE$ #C #FLG #FLG$ #I #NO #NO$ #PT$ #SUM #TIME_DIR X #MSG
  )
;;;  (setq #pt0$ (GetLWPolyLinePt &OutPline)) ; �O�`�_��
  (setq #pt$ (append &pt0$ &pt0$))
  (if (= (length #pt$) 16)
    (progn
      (setq #i 1)
      (setq #flg$ '())
      ;;; #c��#a����#b�֌������x�N�g���̉E������
      (repeat 14
        (setq #a (nth (1- #i) #pt$)) ; �O�̓_
        (setq #b (nth #i      #pt$)) ; ���݂̓_
        (setq #c (nth (1+ #i) #pt$)) ; ���̓_
        (setq #flg (CFArea_rl #a #b #c)) ; -1:�E , 1:��
        (setq #flg$ (append #flg$ (list #flg)))
        (setq #i (1+ #i))
      )
    )
    (progn
      (setq #msg "���[�N�g�b�v�O�`�̈悪�擾�ł��܂���ł����B")
      (if (= CG_AUTOMODE 2) ; 02/09/04 YM ADD
        (WebOutLog #msg)    ; 02/09/04 YM ADD
        (CFAlertMsg #msg)
      )
    )
  );_if

  (setq #sum 0)
  (foreach #flg #flg$  ; ؽĂ̘a
    (setq #sum (+ #sum #flg))
  )

  (if (< #sum 0)
    (progn
      (setq #flg$ (mapcar '(lambda (x) (* x -1)) #flg$)) ; ���v���Ȃ�
      (setq #time_dir T) ; ���v����
    )
  );_if

  (setq #i 0)
  (foreach #flg #flg$
    (if (= #flg -1)
      (setq #no$ (append #no$ (list #i))) ; -1�����Ԗڂ�
    )
    (setq #i (1+ #i))
  )

  (if (> (length #no$) 2)
    (progn
      (cond
        ((> (- (nth 1 #no$) (nth 0 #no$)) 6)
          (setq #no (nth 0 #no$))
        )
        ((> (- (nth 2 #no$) (nth 1 #no$)) 6)
          (setq #no (nth 1 #no$))
        )
        (T
          (setq #no (nth 2 #no$))
        )
      );_cond
    )
  );_if

  (if (= (length #no$) 2)
    (setq #no (nth 1 #no$))
  );_if

  (if #time_dir
    (setq #base$ (list (nth (+ #no 5) #pt$) (nth (+ #no 4) #pt$))) ; ���v����
    (setq #base$ (list (nth (+ #no 4) #pt$) (nth (+ #no 5) #pt$))) ; �����v����
  );_if

  #base$ ; U�^��Ű��_ؽ�

);PKGetBaseU8

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_SetGlobalFromBaseCab2
;;; <�����T�v>  : �Ԍ��Q�L���̔���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : �C�� 00/03/24 YM
;;; <���l>      : �ݒ肳���O���[�o���ϐ�
;;;                 (nth 11 CG_GLOBAL$)     :�k�q�敪�R�[�h("L" "R")           ����s�\����݂���
;;;                 CG_Type2Code  :�`��^�C�v�Q("F" "D")             ��ۂ���O��
;;;                 CG_W2Code     :�Ԍ��Q�L��                        ��Ű���ތ�  0:I , 1:L , 2:U <--- �Œ�ł�����
;;;                 �ݸ�A��۷��ނ����邱�Ƃ��O�� --->�Ȃ��Ă�WT��\��
;;;                 ���E�̏���������Ō��߂Ă��܂� �s��==>�E����
;;;                 �ݸ����,��ە������l�� 00/06/27 YM
;;;*************************************************************************>MOH<
(defun PKW_SetGlobalFromBaseCab2 (
    &Base$       ;(LIST)�x�[�X�L���r�̊�V���{�����X�g
    /
  #BASEPT$ #COUNT #DUM1 #DUM2 #S-EN #SKK$ #SNK_PT #H #en_LOW$ #basept
  #G-ANG #G-EN #G-PT #G-XD$ #G_KOSU #LR #S_KOSU #MSG
  )
  (setq CG_LRCODE    "?") ; "L" "R" "Z":�Ȃ� 01/08/31 YM MOD
  (setq CG_W2CODE    "Z")    ; "I","L","U"

  ;// �Ԍ��Q�L���̔���   ��Ű���ނ̌���I,L,U�^�𔻒肷��
  (setq #g_kosu 0 #s_kosu 0)
  (setq #count 0) ; ��Ű���ނ̐�

  ; 01/08/31 YM MOD-S ۼޯ��ύX
  (foreach #en &Base$ ; �e�ް�����
    (setq #skk$ (CFGetSymSKKCode #en nil)) ; ���������L���r�l�b�g�̐��iCODE���擾����
    (cond
      ; �R�[�i�[�L���r
      ((= (nth 2 #skk$) CG_SKK_THR_CNR) ; �R�[�i�[�L���r���ǂ����̔���
        (setq #count (1+ #count)) ; ��Ű���ނ̐�
      )
      ;�K�X�L���r�l�b�g
      ((= (nth 2 #skk$) CG_SKK_THR_GAS)
        (setq #g-en #en) ; �޽���ނ��� �����̏ꍇ����ٰ�߂̍Ō�
        (setq #g_kosu (1+ #g_kosu)) ; �޽���ތ�
      )
      ;�V���N�L���r�l�b�g
      ((= (nth 2 #skk$) CG_SKK_THR_SNK)
        (setq #s-en #en) ; �ݸ���ނ��� �����̏ꍇ����ٰ�߂̍Ō�
        (setq #s_kosu (1+ #s_kosu)) ; �ݸ���ތ�
      )
    );_cond
  );foreach

  ; �Ԍ��Q�L��
  (cond
    ((= 0 #count)(setq CG_W2CODE "Z"))
    ((= 1 #count)(setq CG_W2CODE "L"))
    ((= 2 #count)(setq CG_W2CODE "U"))
    (T
      (setq #msg "���̃L�b�`���\���͑Ή����Ă��܂���")
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_cond

  ; 01/08/31 YM MOD-E ۼޯ��ύX

  ; ��Ű���ނ̐��m��

  ;//----------------------------------
  ;// �k�q�敪�̔��� I,L II�^U�^�͔���s�\
  ;//   �K�X�L���r�̂c�����x�N�g����
  ;//     1.�����ɃV���N������ΉE����
  ;//     2.�E���ɃV���N������΍�����
  ;//----------------------------------

;;; �E����A�����肪���܂�Ȃ��ꍇ ===>  �ݸ����,��۷��ނ��Ȃ����������݂���ꍇ
  (if (or (= CG_W2CODE "U")(= #s_kosu 0)(= #g_kosu 0)(> #s_kosu 1)(> #s_kosu 1))
;-- 2011/06/28 A.Satoh Mod - S
    (setq CG_LRCODE "Z");2011/09/23 YM MOD
;-- 2011/06/28 A.Satoh Mod - E
    (progn ; �ݸ���ނƺ�۷��ނ�1�� ; I�^ �� L�^
      (setq #g-xd$ (CFGetXData #g-en "G_LSYM"))
      (setq #g-ang (nth 2 #g-xd$))
      (setq #g-pt (cdr (assoc 10 (entget #g-en))))
      (setq #lr ; INT : 1:�� -1:�E 0:��������
        (CFArea_rl
          #g-pt
          (polar #g-pt (- #g-ang (dtr 90)) 10)
          (cdr (assoc 10 (entget #s-en)))
        )
      )
      (if (= #lr 1)  ;�K�XD�x�N�g���̍����ł������ꍇ
        (setq CG_LRCODE "R") ; �E���� ;2011/09/23 YM MOD
        (setq CG_LRCODE "L")          ;2011/09/23 YM MOD
      )
    )
  );_if

);PKW_SetGlobalFromBaseCab2

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetWTInfo �v���������ȊO�p
;;; <�����T�v>  : �ގ��L���I���޲�۸�   WT���_�C�A���O�m�F�\��
;;;               �s�v�����폜  WT�f�ނ̌����͂��Ȃ�
;;; <�߂�l>    : #WTInfo : (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S) WT���
;;;               #retWT_BG_FG$ : PKMakeWT_BG_FG_Pline �̖߂�l
;;;               #SetXd$ : G_WRKT �̐��`
;;;               #CUT_KIGO$ : ���E��ċL��
;;;               #CG_WtDepth : WT750�g���׸�
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      :
;;; #CG_WtDepth = 0 �����Ȃ� --- �Œ�
;;; #CG_WtDepth = 1 �V���N���̂�
;;; #CG_WtDepth = 10 �R�������̂�
;;; #CG_WtDepth = 100 ���̑�
;;;*************************************************************************>MOH<
(defun PKGetWTInfo (
  &pt$       ; ���̷���ȯĊO�`���ײ݂̓_��
  &pt$$      ; WT�O�`���ײ݂̓_��
  &base$     ; �ް����޼���ِ}�`��ؽ�
  &base_new$ ; �ް����޼���ِ}�`��ؽ�(����ȯĂ̏��O��)
  &outpl_LOW ; ۰���߷��ފO�`���ײݐ}�`��
  &en_LOW$   ; ۰���߷��޼���ِ}�`��ؽ�
  /
  #BG_H #BG_S #BG_SEP #BG_T #BG_TYPE #CG_WTDEPTH #CUTID #DAN$$ #DAN$ #FG_H #FG_S #FG_T #FG_TYPE #type1
  #IHEIGHT$ #RET$ #RETWT_BG_FG$ #SETXD$ #WTINFO #WTINFO1 #WTINFO2 #WTINFO3 #WT_H #WT_T #ZAI$ #ZAICODE
#RH #RZ ; 01/08/24 YM ADD
#TOP_FLG ;03/10/14 YM ADD
;-- 2011/08/25 A.Satoh Add - S
#qry$ #offsetL #offsetR
;-- 2011/08/25 A.Satoh Add - E
  )
  (PKGetBASEPT_L &pt$ &base$) ; 00/09/29 YM ADD �ް���۰��ق����߂�

  (cond
    ((= CG_W2CODE "Z") ; I�^
      (setq #type1 "0")
    )
    ((= CG_W2CODE "L") ; L�^
      (setq #type1 "1")
    )
    ((= CG_W2CODE "U") ; U�^
      (setq #type1 "2")
    )
  );_cond

  ; 01/06/25 YM ������ړ� START
  ;// �ގ��L���̑I��
  (setq #zai$ (PKW_ZaisituDlg)) ; �_�C�A���O�{�b�N�X�̕\��
  (if (= #zai$ nil)
    (*error*)
  )
  (setq #ZaiCode (nth 0 #zai$)) ; �ގ��L��
  (setq #CutId   (nth 1 #zai$)) ; �J�b�g�L��
  ; 01/06/25 YM ������ړ� END

  ;// ���[�N�g�b�v�̎��t�����������߂� 01/07/30 YM MOD ���@H==>���@H+����ي�_Z���W�ɕύX
  (foreach #en &base$
    (setq #rZ (caddr (cdr (assoc 10 (entget #en))))) ; �����Z���W
    (setq #rH (+ #rZ (nth 5 (CFGetXData #en "G_SYM"))))
    (setq #iHeight$ (cons #rH #iHeight$)) ; �V���{����l�g (825.0 825.0 630.0 825.0) 630�޽
  )
  (setq #WT_H (apply 'max #iHeight$)) ; ���t�������̍ő�l

  ;// �f�ʂ̑I��
  (setq #dan$$ (PKW_DanmenDlg #ZaiCode #CutId))  ; �_�C�A���O�{�b�N�X�̕\��
  (if (= #dan$$ nil)
    (*error*)
  )
  (setq #dan$    (nth 0 #dan$$))
  (setq #WTInfo1 (nth 1 #dan$$))
  (setq #WTInfo2 (nth 2 #dan$$))
  (setq #WTInfo3 (nth 3 #dan$$))

; #WTInfo1 1���ړV��
;���s�������� 
;BG�L�� 0 or 1
;FG�L�� 0 or 1 or 2
;�V�����ʍ�
;�V�����ʉE


;-- 2011/08/25 A.Satoh Add - S
  ; �f�ʏ��P(#WTInfo1)�ɃT�C�h�V�t�g���A�T�C�h�V�t�g�E��ǉ�����
  (setq #qry$
    (DBSqlAutoQuery CG_DBSESSION (strcat "select * from WT�f�� where �f��ID='" (nth 0 #dan$) "'"))
  )

  (if #qry$
    (progn
      (setq #offsetL (nth 13 (car #qry$)))
      (setq #offsetR (nth 14 (car #qry$)))
    )
    (progn
      (setq #offsetL 0)
      (setq #offsetR 0)
    )
  )
  (setq #WTInfo1 (append #WTInfo1 (list #offsetL #offsetR)))


  (setq #WT_T    (nth  2 #dan$)) ; WT�̌���
  (setq #BG_H    (nth  4 #dan$)) ; BG�̍���
  (setq #BG_T    (nth  5 #dan$)) ; BG�̌���
  (setq #FG_H    (nth  7 #dan$)) ; FG�̍���
  (setq #FG_T    (nth  8 #dan$)) ; FG�̌���
  (setq #FG_S    (nth  9 #dan$)) ; �O����V�t�g��
  (setq #BG_S    (nth 10 #dan$)) ; �㐂��V�t�g��
  ;03/09/22 YM ADD ���ٓV���׸�
  ;0:�W�� 1:BG�����E�ɉ�荞�� 2:�O���ꂪ�����ʔw�ʂɉ�肱�� 3:�O���ꂪ�E���ʔw�ʂɉ�肱��
  (setq #TOP_FLG (nth 12 #dan$)) ; ���ٓV���׸�
  ;03/10/14 YM ADD

;;;  (setq #BG_Type (nth  3 #dan$)) ; BG�L��
;;;  (setq #FG_Type (nth  6 #dan$)) ; �O��������
  (setq #BG_Sep  (nth 11 #dan$)) ; �ޯ��ް�ޕ���
;-- 2011/08/25 A.Satoh Mod - S
;  (setq #WTInfo  (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))

;2016/02/23 YM MOD-S #LR�͎g�p���Ȃ�
;;;  (setq #WTInfo  (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG #LR))
  (setq #WTInfo  (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG ))
;2016/02/23 YM MOD-E #LR�͎g�p���Ȃ�

;-- 2011/08/25 A.Satoh Mod - E
;;;  (setq #WTInfo1 (list #BG_S #BG_Type #FG_Type))

  (setq #CG_WtDepth 0)
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart)

;;;09/21YM  (setq #WTInfo (PKWT_INFO_Dlg)) ; �_�C�A���O�m�F�\��
;;;09/21YM  (if (= #WTInfo nil)
;;;09/21YM    (*error*) ; cancel�̏ꍇ
;;;09/21YM    (progn
;;;09/21YM      (setq #WT_T (nth 0 #WTInfo)) ; WT�̌���
;;;09/21YM      (setq #BG_H (nth 1 #WTInfo)) ; BG�̍���
;;;09/21YM      (setq #BG_T (nth 2 #WTInfo)) ; BG�̌���
;;;09/21YM      (setq #FG_H (nth 3 #WTInfo)) ; FG�̍���
;;;09/21YM      (setq #FG_T (nth 4 #WTInfo)) ; FG�̌���
;;;09/21YM      (setq #FG_S (nth 5 #WTInfo)) ; �O����V�t�g��
;;;09/21YM      (setq #WTInfo (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S))
;;;09/21YM    )
;;;09/21YM  );_if

;;; ���[�N�g�b�v�p��w�̍쐬
  (command "_layer" "N" SKW_AUTO_SECTION "C" 2 SKW_AUTO_SECTION "L" SKW_AUTO_LAY_LINE SKW_AUTO_SECTION "")
  (command "_layer" "N" SKW_AUTO_SOLID   "C" 7 SKW_AUTO_SOLID   "L" SKW_AUTO_LAY_LINE SKW_AUTO_SOLID   "")
  (command "_layer" "T" SKW_AUTO_SECTION "") ; ��w����
  (command "_layer" "T" SKW_AUTO_SOLID   "") ; ��w����

;;;DB�œ�����񂩂�WT,BG,FG������ײ݂����߂�.
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
      #ZaiCode
    )
  )

  (if (= nil (tblsearch "APPID" "G_WRKT")) (regapp "G_WRKT"))
  (if (= nil (tblsearch "APPID" "G_BKGD")) (regapp "G_BKGD"))
  (if (= nil (tblsearch "APPID" "G_OPT" )) (regapp "G_OPT" ))

;;; "G_WRKT" *** ���ʍ��ڐݒ� *** nil ��Ăł��Ȃ����� "" �ɏC��

(if (= CG_MAG1 nil)(setq CG_MAG1 0))
(if (= CG_MAG2 nil)(setq CG_MAG2 0))
(if (= CG_MAG3 nil)(setq CG_MAG3 0))

;;; �VG_WRKT �̐��` ���i�K�œ��͉\�Ȃ��̂̂�
  (setq #SetXd$                ; ���ݒ荀�ڂ�-999 or "-999"
    (list "K"                  ;1. �H��L��
;-- 2011/06/16 A.Satoh Mod - S
          ;CG_SeriesCode        ;2. SERIES�L��
          CG_SeriesDB          ;2. SERIES����
;-- 2011/06/16 A.Satoh Mod - E
          #ZaiCode             ;3. �ގ��L��
          (atoi #type1)        ;4. �`��^�C�v�P          0,1,2(I,L,U) ���̎��_�Ŗ�����
          CG_Type2Code         ;5. �`��^�C�v�Q          F,D
;-- 2011/06/16 A.Satoh Mod - S
;          0                    ;6. ���g�p
          ""                   ;6. ���g�p
;-- 2011/06/16 A.Satoh Mod - E
          ""                   ;7. ���g�p
          ""                   ;8. �J�b�g�^�C�v�ԍ�      0:�Ȃ�,1:VPK,2:X,3:H ���E
          #WT_H                ;9. ���[��t������        827
;-- 2011/06/16 A.Satoh Mod - S
;          "��WT���s��"         ;10.���g�p
          ""                   ;10.���g�p
;-- 2011/06/16 A.Satoh Mod - E
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
;-- 2011/06/28 A.Satoh Mod - S
;         (if (= nil CG_GLOBAL$);2010/01/07 YM MOD
;           "L"
;           (nth 11 CG_GLOBAL$)  ;31.�k�q����t���O
;         );_if
          CG_LRCODE ;2011/09/23 YM MODE
;-- 2011/06/28 A.Satoh Mod - E
;-- 2011/06/16 A.Satoh Mod - S
;;;;;          0.0                  ;32.���g�p
          ""                   ;32.���g�p
;-- 2011/06/16 A.Satoh Mod - E
          ""                   ;33.WT����_
          ""                   ;34.���g�p
          ""                   ;35.���g�p
;-- 2011/06/16 A.Satoh Mod - S
;          "����đ��������"     ;36.���g�p
          ""                   ;36.�J�b�g���C���}�`�n���h��
;-- 2011/06/16 A.Satoh Mod - E
          ""                   ;37.�J�b�g���C���}�`�n���h���Q
          ""                   ;38.�J�b�g�E(���g�p)
          ""                   ;[39]WT��ʐ}�`�����
          0.0                  ;[40]���g�p
          0.0                  ;[41]���g�p
          0.0                  ;[42]���g�p
          CG_MAG1              ;[43]�Ԍ�1 1����WT
          CG_MAG2              ;[44]�Ԍ�2 2����WT
          CG_MAG3              ;[45]�Ԍ�3 3����WT
          ""                   ;[46]�i��
          ""                   ;[47]���l
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
          ""                   ;[60]�i���������܂߂�WT�O�`PLINE�n���h��
          ""                   ;[61]�J�b�g���C���n���h��1
          ""                   ;[62]�J�b�g���C���n���h��2
          ""                   ;[63]�J�b�g���C���n���h��3
          ""                   ;[64]�J�b�g���C���n���h��4
    )
  )

  (setq #ret$ (list #WTInfo #retWT_BG_FG$ #SetXd$ nil #CG_WtDepth #CutId))
  #ret$
);PKGetWTInfo

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetBASEPT_L
;;; <�����T�v>  : CG_BASEPT1,2 ��Ű��_1,2 �����߂�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 00/09/29 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKGetBASEPT_L (
  &pt$        ; ���O�O�̊O�`�̈�_��
  &base$      ; ���O�O�̊O�`�̈���ް����޼����
  /
  #BASEPT #BASEPT$ #KOSU
  )
  ;;; �O�`�_�� #pt$ ���牜�s�������߂�
  (setq #kosu (length &pt$))

  (cond
    ((= #kosu 4) ; I�^
      (setq #BASEPT (PKGetBaseI4 &pt$ &base$)) ; �_��Ƽ���ي�_�P��
      (setq CG_BASEPT1 #BASEPT)    ; ��Ű��_1
      (setq CG_BASEPT2 "")         ; ��Ű��_2
    )
    ((= #kosu 6) ; L�^
      ;;; �Vۼޯ� 05/15 YM �O�`�_��-->��Ű��_ PKGetBaseL6
      (setq #BASEPT (PKGetBaseL6 &pt$))
      (setq CG_BASEPT1 #BASEPT)    ; ��Ű��_1
      (setq CG_BASEPT2 "")         ; ��Ű��_2
    )
    ((= #kosu 8) ; U�^
      ;;; �Vۼޯ� 05/15 YM �O�`�_��-->��Ű��_ PKGetBaseL6
      (setq #BASEPT$ (PKGetBaseU8 &pt$))
      (setq CG_BASEPT1 (car  #BASEPT$)) ; ��Ű��_1
      (setq CG_BASEPT2 (cadr #BASEPT$)) ; ��Ű��_2
    )
  );_cond
  (princ)
);PKGetDep123F

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_MakeWorktop3
;;; <�����T�v>  : ܰ�į�߂̐��� Z������ extrude
;;; <�߂�l>    : WT SOLID�}�`��ؽ�
;;; <�쐬>      : 2000.3.15 YM  �C�� 2000.4.4 ��čςݗ̈��n��
;;; <���l>      : KPCAD I�^,L�^,U�^�Ή�
;;;               ���� Z=0 ��ɂ�����̂Ƃ���.
;;;               BG,FG��WT�ƕʍ쐬�A�K�v�Ȃ�UNION���Ƃ�
;;;               ��ċL����DB�ɗ��炸�Ƃ��悢
;;;*************************************************************************>MOH<
(defun PK_MakeWorktop3 (
  &WTInfo$  ; (list #WTInfo  #retWT_BG_FG$  #SetXd$  #CUT_KIGO$  #CG_WtDepth)
  &en_LOW$  ; ۰���߷���ؽ�
  &pt_LOW$  ; ۰���߷��ފO�`�_��
  /
  #BG$ #BG0$ #BG01 #BG02 #BG1 #BG2 #BG_ALL_LEN #BG_H #BG_LEN #BG_REGION #BG_SEP
  #BG_SOLID #BG_SOLID$ #BG_SOLID1 #BG_SOLID2 #BG_T #BG_TEI1 #BG_TEI2 #CG_WTDEPTH
  #CL #CR #CUTID #CUTL #CUTR #CUTTYPE #CUT_KIGO$ #CUT_LEN$ #CUT_LENL #CUT_LENR #DEP$
  #ED #FG$ #FG0$ #FG01 #FG02 #FG1 #FG2 #FG_H #FG_REGION #FG_S #DANFLG
  #FG_SOLID #FG_SOLID$ #FG_SOLID1 #FG_SOLID2 #FG_T #FG_TEI1 #FG_TEI2 #I #KOSU #MSGD
  #OS #OT #RAPDANWT #RETWT_BG_FG$ #SERI #SETXD$ #SM #SS #TCUTL #TCUTR #WT #WT0 #WT0$
  #WTINFO #WTL #WTR #WT_BASE #WT_H #WT_LEN$ #WT_REGION #WT_SOLID #WT_SOLID$ #WT_T #ZAICODE
  #ii #EWT_GAIKEI ;#SYSTEM_POLE -- 2011/06/16 A.Satoh '#SYSTEM_POLE Delete
;-- 2011/07/28 A.Satoh Add - S
  #Keijo #handle$ #oku$
;-- 2011/07/28 A.Satoh Add - S
;-- 2011/10/21 A.Satoh Add - S
#WT_FlatType
;-- 2011/10/21 A.Satoh Add - E
#snk_dep ;-- 2012/04/20 A.Satoh Add �V���N�z�u�s��Ή�
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (defun ##NiltoStr ( &dum / )
      (if (= &dum nil)
        (setq &dum "")
      )
      &dum
    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #msgD "�i�����̃v���������m�F���������B")
;;; ���ѕϐ��ݒ�
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setq #ed (getvar "EDGEMODE" ))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "EDGEMODE"  0)

  (setq #BG_SOLID nil #BG_SOLID$ '())
  (setq #FG_SOLID nil #FG_SOLID$ '())
  (setq #WT_SOLID nil #WT_SOLID$ '())
  (setq #WT0$ '())
  (setq #BG0$ '())
  (setq #FG0$ '())
  (setq #BG_LEN 0)

  (setq #WTInfo       (nth 0 &WTInfo$))
  (setq #retWT_BG_FG$ (nth 1 &WTInfo$))
  (setq #SetXd$       (nth 2 &WTInfo$))
  (setq #CUT_KIGO$    (nth 3 &WTInfo$)) ; nil �L�蓾��
  (setq #CG_WtDepth   (nth 4 &WTInfo$))
  (setq #CutID        (nth 5 &WTInfo$))

;;;(setq #WTInfo  (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep))
  (setq #WT_H   (nth 0 #WTInfo)) ; WT����
  (setq #WT_T   (nth 1 #WTInfo)) ; WT����
  (setq #BG_H   (nth 2 #WTInfo)) ; BG����
  (setq #BG_T   (nth 3 #WTInfo)) ; BG����
  (setq #FG_H   (nth 4 #WTInfo)) ; FG����
  (setq #FG_T   (nth 5 #WTInfo)) ; FG����
  (setq #FG_S   (nth 6 #WTInfo)) ; FG��ė�
  (setq #BG_Sep (nth 7 #WTInfo)) ; �ޯ��ް�ޕ���

  (setq #seri    (nth  1 #SetXd$)) ; SERIES�L��
  (setq #ZaiCode (nth  2 #SetXd$)) ; �ގ�
;-- 2011/09/30 A.Satoh Del - S
;;;;;;-- 2011/07/28 A.Satoh Add - S
;;;;;  (setq #Keijo   (nth  3 #SetXd$)) ; �`�� 0:I�^�@1:L�^�@2:U�^
;;;;;;-- 2011/07/28 A.Satoh Add - E
;-- 2011/09/30 A.Satoh Del - S

  (setq #i 0)
  (setq #kosu (length #retWT_BG_FG$))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1��ڂ�ٰ��SOLID���쐬���� ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (repeat #kosu
    (setq #WT  (nth 0 (nth #i #retWT_BG_FG$))) ; WT���
    (setq #BG$ (nth 1 (nth #i #retWT_BG_FG$))) ; BG���
    (setq #BG1 (car  #BG$)) ; BG���1
    (setq #BG2 (cadr #BG$)) ; BG���2
    (setq #FG$ (nth 2 (nth #i #retWT_BG_FG$))) ; FG���
    (setq #FG1 (car  #FG$)) ; FG���1
    (setq #FG2 (cadr #FG$)) ; FG���2
;;; WT�����o������+�ړ�
    (if #WT
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #WT)) (entget #WT)))
        (setq #WT0 (entlast)) ; �c��
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT)) (entget #WT))) ; WT��p�̉�w
        (setq #WT0$ (append #WT0$ (list #WT0)))
        (setq #WT_region (Make_Region2 #WT))
        (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
        (setq #WT_SOLID$ (append #WT_SOLID$ (list #WT_SOLID)))
      )
    );_if

;;; BG1 �����o������+�ړ� 1��ܰ�į�߂��ޯ��ް�ނ�2�L�蓾���ؽĉ� 00/04/21 YM
    (setq #BG01 nil #BG_SOLID1 nil)
    (if #BG1
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG1)) (entget #BG1)))
        (setq #BG01 (entlast)) ; �c�� BG���
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG1)) (entget #BG1))) ; WT��p�̉�w
        (setq #BG_region (Make_Region2 #BG1))
        (setq #BG_SOLID1 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
      )
    );_if

;;; BG2 �����o������+�ړ�
    (setq #BG02 nil #BG_SOLID2 nil)
    (if #BG2
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG2)) (entget #BG2)))
        (setq #BG02 (entlast)) ; �c�� BG���
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG2)) (entget #BG2))) ; WT��p�̉�w
        (setq #BG_region (Make_Region2 #BG2))
        (setq #BG_SOLID2 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
      )
    );_if

    (setq #BG_SOLID$ (append #BG_SOLID$ (list (list #BG_SOLID1 #BG_SOLID2))))
    (setq #BG0$ (append #BG0$ (list (list #BG01 #BG02))))

;;; �O����1�����o������+�ړ�
    (setq #FG01 nil #FG_SOLID1 nil)
    (if #FG1
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG1)) (entget #FG1)))
        (setq #FG01 (entlast)) ; �c��
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG1)) (entget #FG1))) ; WT��p�̉�w
        (setq #FG_region (Make_Region2 #FG1))
        (setq #FG_SOLID1 (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
      )
    );_if

;;; �O����2�����o������+�ړ�
    (setq #FG02 nil #FG_SOLID2 nil)
    (if #FG2
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG2)) (entget #FG2)))
        (setq #FG02 (entlast)) ; �c��
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG2)) (entget #FG2))) ; WT��p�̉�w
        (setq #FG_region (Make_Region2 #FG2))
        (setq #FG_SOLID2 (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
      )
    );_if

    (setq #FG_SOLID$ (append #FG_SOLID$ (list (list #FG_SOLID1 #FG_SOLID2))))
    (setq #FG0$ (append #FG0$ (list (list #FG01 #FG02))))

    (setq #i (1+ #i))
  );_repeat

  (setq #i 0 #DANFLG nil)
  (setq #TCUTL nil #TCUTR nil) ; ���������K�v(WT�Ԍ��L�k��)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2��ڂ�ٰ�߶�ċL���@�@�@�@ ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (repeat #kosu
    (setq #RAPDANWT nil) ; ��߽�i��WT
    (setq #WTL  nil)
    (setq #WTR  nil)
    (setq #cutL nil)
    (setq #cutR nil)
    (setq #CUT_LENL 0.0)
    (setq #CUT_LENR 0.0)

    (setq #CutType (nth 3 (nth #i #retWT_BG_FG$))) ; �������
    (setq #dep$    (nth 4 (nth #i #retWT_BG_FG$))) ; ���s��
    (setq #WT_LEN$ (nth 5 (nth #i #retWT_BG_FG$))) ; WT����
    (setq #WT_BASE (nth 6 (nth #i #retWT_BG_FG$))) ; WT����_���W
;;;    (setq #TYPE    (nth 7 (nth #i #retWT_BG_FG$))) ; WT�`�� 0:I,1:L,2:U ���g�p0�Œ�

    (setq #WT0 (nth #i #WT0$))           ; WT���
    (setq #BG01 (car  (nth #i #BG0$)))   ; BG��������1
    (setq #BG02 (cadr (nth #i #BG0$)))   ; BG���2 nil ����
    (setq #BG01 (##NiltoStr #BG01))
    (setq #BG02 (##NiltoStr #BG02))

    (setq #FG01 (car  (nth #i #FG0$)))   ; FG1���
    (setq #FG02 (cadr (nth #i #FG0$)))   ; FG2���
    (setq #FG01 (##NiltoStr #FG01))
    (setq #FG02 (##NiltoStr #FG02))

    (setq #WT_SOLID (nth #i #WT_SOLID$))

    (setq #BG_SOLID1 (car  (nth #i #BG_SOLID$)))
    (setq #BG_SOLID2 (cadr (nth #i #BG_SOLID$))) ; nil ����
    (setq #BG_SOLID1 (##NiltoStr #BG_SOLID1))
    (setq #BG_SOLID2 (##NiltoStr #BG_SOLID2))

    (setq #FG_SOLID1 (car  (nth #i #FG_SOLID$)))
    (setq #FG_SOLID2 (cadr (nth #i #FG_SOLID$)))
    (setq #FG_SOLID1 (##NiltoStr #FG_SOLID1))
    (setq #FG_SOLID2 (##NiltoStr #FG_SOLID2))

    (setq #ss (ssadd))
    (ssadd #WT_SOLID #ss)
    (if (/= #FG_SOLID1 "")
      (ssadd #FG_SOLID1 #ss)
    )
    (if (/= #FG_SOLID2 "")
      (ssadd #FG_SOLID2 #ss)
    )

    (setq #FG_tei1 #FG01)
    (setq #FG_tei2 #FG02)

    (if (equal #BG_Sep 1 0.1)
      (progn ; �ޯ��ް�ޕ����^
        (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
        (setq #BG_tei1 #BG_SOLID1)
        (setq #BG_tei2 #BG_SOLID2)
      )
      (progn ; �ޯ��ް�ޕ����^�ȊO
        (if (and #BG_SOLID1 (/= #BG_SOLID1 ""))
          (ssadd #BG_SOLID1 #ss)
        )
        (if (and #BG_SOLID2 (/= #BG_SOLID2 "")) ; 01/07/26 YM ADD
          (ssadd #BG_SOLID2 #ss)
        )
        (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
        (setq #BG_tei1 #BG01)
        (setq #BG_tei2 #BG02)
      )
    );_if

;;;    (GroupInSolidChgCol2 #WT_SOLID CG_InfoSymCol) ; �ꎞ�I��WT�̐F��ς���

;;; ��ċL���̾��
    (setq #CL (substr #CutType 1 1))
    (setq #CR (substr #CutType 2 1))
;;;   (CFAlertMsg #msg)
;LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
    (cond
      ((= #CL "0")
        (setq #cutL "0")
      )
      ((= #CL "1")
        (setq #WTL (nth (1+ #i) #WT_SOLID$))
        (setq #cutL "1")
      )
      ((= #CL "2")
        (setq #WTL (nth (1+ #i) #WT_SOLID$))
        (setq #cutL "2")
      )
      ((= #CL "3")
        (setq #WTL (nth (1+ #i) #WT_SOLID$))
        (setq #cutL "3")
      )
      ((= #CL "4") ; �i���Ή�
        (setq #TCUTL CG_TCUT)
;;;01/03/22YM@        (if #DANFLG
;;;01/03/22YM@          (progn
;;;01/03/22YM@            (setq #TCUTL 20)              ; �i���������ς�
;;;01/03/22YM@          )
;;;01/03/22YM@          (progn
;;;01/03/22YM@            (setq #TCUTL 20)              ; �i���������ς�
;;;01/03/22YM@            (KP_PutDansaSWT &en_LOW$ "R") ; �i�������ڽ
;;;01/03/22YM@            (setq #DANFLG T)
;;;01/03/22YM@          )
;;;01/03/22YM@        );_if
        (setq #cutL "4")
      )
      ((= #CL "5") ; �L�p�x
        (setq #WTL (nth (1+ #i) #WT_SOLID$))
        (setq #cutL "5")
      )
      ((= #CL "6") ; ���د�D���
        (setq #WTL (nth (1+ #i) #WT_SOLID$))
        (setq #cutL "6")
      )
    );_cond
;RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
    (cond
      ((= #CR "0")
        (setq #cutR "0")
      )
      ((= #CR "1")
        (setq #WTR (nth (1- #i) #WT_SOLID$))
        (setq #cutR "1")
      )
      ((= #CR "2")
        (setq #WTR (nth (1- #i) #WT_SOLID$))
        (setq #cutR "2")
      )
      ((= #CR "3")
        (setq #WTR (nth (1- #i) #WT_SOLID$))
        (setq #cutR "3")
      )
      ((= #CR "4") ; �i���Ή�
        (setq #TCUTR CG_TCUT)
        (setq #cutR "4")
      )
      ((= #CR "5") ; �L�p�x
        (setq #WTR (nth (1- #i) #WT_SOLID$))
        (setq #cutR "5")
      )
      ((= #CR "6") ; ���د�D���
        (setq #WTR (nth (1- #i) #WT_SOLID$))
        (setq #cutR "6")
      )
    );_cond

    (setq #WT0  (##NiltoStr #WT0))
    (setq #WTL  (##NiltoStr #WTL))
    (setq #WTR  (##NiltoStr #WTR))
    (setq #cutL (##NiltoStr #cutL))
    (setq #cutR (##NiltoStr #cutR))
    (setq #dep$ (##NiltoStr #dep$))
    (setq #CUT_LEN$ (list #CUT_LENL #CUT_LENR))

    ;04/04/09 YM ADD-S ���ׯ�,���ׯĔ���
    ;2009/04/17 YM DEL �����݂͖��g�p
;;;   (setq #WT_FlatType (FullSemiFlatHantei #dep$))

;-- 2011/06/16 A.Satoh Del - S
; ;2009/04/17 YM ADD-S
; (setq #WT_FlatType "")
;
; ;2010/01/07 YM MOD
; (if (= nil CG_GLOBAL$)
;   (progn
;     (setq #WT_FlatType "")
;   )
;   (progn
;     
;     (cond
;       ((= "D105" (nth 7 CG_GLOBAL$))
;         (setq #WT_FlatType "D105");P�^
;       )
;       ((= "D970" (nth 7 CG_GLOBAL$))
;         (setq #WT_FlatType "D970");P�^
;       )
;       ((= "D900" (nth 7 CG_GLOBAL$))
;         (setq #WT_FlatType "D900");P�^
;       )
;       (T
;         ;2009/04/17 YM ADD-S �ް�����
;         (if (wcmatch (nth  5 CG_GLOBAL$) "G*" )
;           (setq #WT_FlatType "D650"); �ް�����;P�^
;         );_if
;         ;2009/04/17 YM ADD-E
;
;       )
;     );_cond
;     ;2009/04/17 YM ADD-E
;
;   )
; );_if
;-- 2011/06/16 A.Satoh Del - E

;;; �g���ް� "G_WRKT" �̾��
    (CFSetXData #WT_SOLID "G_WRKT"
      (CFModList #SetXd$
        (list
;--2011/06/16 A.Satoh Del - S
;          (list  5 #SYSTEM_POLE) ;6. ���g�p==>�ݸ�ٌ߰�����̂Ƃ�"P"
;--2011/06/16 A.Satoh Del - E
          (list  7 #CutType) ;8. �J�b�g�^�C�v�ԍ�      0:�Ȃ�,1:VPK,2:X,3:H ���E "20"�Ȃ�
;--2011/06/16 A.Satoh Del - S
;          (list 31 #WT_FlatType) ;32."SF"�F���ׯ�,"FF"�F���ׯ�
;--2011/06/16 A.Satoh Del - E
          (list 32 #WT_BASE) ;33.WT����_���W
;--2011/08/26 A.Satoh Del - S
;          (list 36 #cutL)    ;37.�J�b�g�� I,H,X,P,K,L,V,S,Z
;          (list 37 #cutR)    ;38.�J�b�g�E
;--2011/08/26 A.Satoh Del - E
          (list 38 #WT0)     ;[39]WT��ʐ}�`�����
          (list 47 #WTL)     ;[48]�J�b�g����WT����ٍ�
          (list 48 #WTR)     ;[49]�J�b�g����WT����ىE
          (list 49 #BG_tei1) ;[50]�����^�̏ꍇBG SOLID�}�`�����1  ����ȊO�͒�ʐ}�`�����1
          (list 50 #BG_tei2) ;[51]�����^�̏ꍇBG SOLID�}�`�����2  ����ȊO�͒�ʐ}�`�����2
          (list 51 #FG_tei1) ;[52]FG ��ʐ}�`�����
          (list 52 #FG_tei2) ;[53]FG ��ʐ}�`�����
          (list 55 #WT_LEN$) ;[56]���݂�WT�̉����o������(��"G_SIDE"����������o��)
          (list 57 #dep$)    ;[58]���݂�WT�̉��s��
        )
      )
    )

;;; �g���ް� G_BKGD�̾��
    (if (equal #BG_Sep 1 0.1)
      (progn ; �ޯ��ް�ޕ����^
        (setq #BG_ALL_LEN 0)
        (if (and #BG_SOLID1 (/= #BG_SOLID1 ""))
          (setq #BG_ALL_LEN
            (PKSetBGXData
              (list #BG_SOLID1 #BG_SOLID2)
              #cutL #cutR #ZaiCode
              (list #BG01 #BG02)
              #WT_SOLID nil
            )
          )
        )
        (setq #BG_LEN (+ #BG_LEN #BG_ALL_LEN))
      )
      (setq #BG_LEN 0)
    );_if
;;;    (GroupInSolidChgCol2 #WT_SOLID "BYLAYER") ; WT�̐F��߂�
;;; �i���ڑ����Ԍ��L�k
    (if #TCUTL
      (progn
        (setq #WT_SOLID (SubStretchWkTop #WT_SOLID "L" #TCUTL))     ; �߂�l �L�k���WT
        (setq #WT_SOLID$ (CFModList #WT_SOLID$ (list (list #i #WT_SOLID)))) ; �V����WT�ɓ���ւ���
      )
    );_if
    (if #TCUTR
      (progn
        (setq #WT_SOLID (SubStretchWkTop #WT_SOLID "R" #TCUTR))     ; �߂�l �L�k���WT
        (setq #WT_SOLID$ (CFModList #WT_SOLID$ (list (list #i #WT_SOLID)))) ; �V����WT�ɓ���ւ���
      )
    );_if
    (setq #TCUTL nil #TCUTR nil) ; ���������K�v
    (setq #i (1+ #i))
  );_repeat

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ loop�I��


  (setq #eWT_GAIKEI (MakeTEIMEN CG_GAIKEI)) ; �O�`PLINE
  (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #eWT_GAIKEI)) (entget #eWT_GAIKEI)))

  (foreach WT_SOLID #WT_SOLID$
    (setq #setxd$ (CFGetXData WT_SOLID "G_WRKT"))
;-- 2011/09/30 A.Satoh Mod - S
;;;;;;-- 2011/09/09 A.Satoh Mod - S
;;;;;;    (setq #setxd$ (append #setxd$ (list #eWT_GAIKEI))) ; 01/08/24 YM MOD
;;;;;;    (CFSetXData WT_SOLID "G_WRKT" #setxd$)
;;;;;    (CFSetXData WT_SOLID "G_WRKT" (CFModList #SetXd$ (list (list 59 #eWT_GAIKEI))))
;;;;;;-- 2011/09/09 A.Satoh Mod - E
    (setq #oku$ (nth 57 #Setxd$))        ; ���s��
    (cond
      ; U�^
      ((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (> (nth 2 #oku$) 0.0))
        (setq #Keijo 2)
      )
      ; L�^
      ((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (= (nth 2 #oku$) 0.0))
        (setq #Keijo 1)
      )
      ; I�^
      (T
        (setq #Keijo 0)
      )
    )

    (CFSetXData WT_SOLID "G_WRKT"
      (CFModList #SetXd$
        (list
          (list  3 #Keijo)
          (list 59 #eWT_GAIKEI)
        )
      )
    )
;-- 2011/09/30 A.Satoh Mod - E
  )

;-- 2011/09/22 A.Satoh Mod - S
;;;;;;-- 2011/07/28 A.Satoh Add - S
;;;;;  ; �J�b�g����}
;;;;;  (if (= #Keijo 1)  ; L�^�ł���ꍇ
;;;;;    (progn
;;;;;      (setq #handle$ (AddWTCutLineL (car #WT_SOLID$) #WTInfo #CutID))
;;;;;      (if (/= #handle$ nil)
;;;;;        (foreach #WT_SOLID #WT_SOLID$
;;;;;          (setq #setxd$ (CFGetXData #WT_SOLID "G_WRKT"))
;;;;;          (CFSetXData #WT_SOLID "G_WRKT" (CFModList #SetXd$
;;;;;            (list
;;;;;              (list  9 (nth 4 #handle$))
;;;;;              (list 60 (nth 0 #handle$))
;;;;;              (list 61 (nth 1 #handle$))
;;;;;              (list 62 (nth 2 #handle$))
;;;;;              (list 63 (nth 3 #handle$))
;;;;;            )
;;;;;          ))
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;;-- 2011/08/25 A.Satoh Add - S
;;;;;    (if (= #Keijo 2) ; U�^�ł���ꍇ
;;;;;      (progn
;;;;;        (setq #handle$ (AddWTCutLineU (car #WT_SOLID$) #WTInfo #CutID))
;;;;;        (if (/= #handle$ nil)
;;;;;          (foreach #WT_SOLID #WT_SOLID$
;;;;;            (setq #setxd$ (CFGetXData #WT_SOLID "G_WRKT"))
;;;;;            (CFSetXData #WT_SOLID "G_WRKT" (CFModList #SetXd$
;;;;;              (list
;;;;;                (list  9 (nth 4 #handle$))
;;;;;                (list 60 (nth 0 #handle$))
;;;;;                (list 61 (nth 1 #handle$))
;;;;;                (list 62 (nth 2 #handle$))
;;;;;                (list 63 (nth 3 #handle$))
;;;;;              )
;;;;;            ))
;;;;;          )
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;;-- 2011/08/25 A.Satoh Add - E
;;;;;  )
;;;;;;-- 2011/07/28 A.Satoh Add - E
  ; �J�b�g����}
  (foreach WT_SOLID #WT_SOLID$
    (setq #Setxd$ (CFGetXData WT_SOLID "G_WRKT"))
    (setq #oku$ (nth 57 #Setxd$))        ; ���s��
    (cond
      ((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (> (nth 2 #oku$) 0.0))
        (setq #handle$ (AddWTCutLineU WT_SOLID #WTInfo #CutID))
        (if (/= #handle$ nil)
          (progn
            (CFSetXData WT_SOLID "G_WRKT" (CFModList #SetXd$
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
      )
      ((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (= (nth 2 #oku$) 0.0))
        (setq #handle$ (AddWTCutLineL WT_SOLID #WTInfo #CutID))
        (if (/= #handle$ nil)
          (progn
            (CFSetXData WT_SOLID "G_WRKT" (CFModList #SetXd$
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
      )
    )
  )
;-- 2011/09/22 A.Satoh Mod - E

;-- 2012/04/20 A.Satoh Add �V���N�z�u�s��Ή� - S
  (foreach WT_SOLID #WT_SOLID$
		(setq #Setxd$ (CFGetXData WT_SOLID "G_WRKT"))
		(setq #snk_dep (getSinkDep WT_SOLID))
		(if (= #snk_dep nil)
			(setq #snk_dep 0.0)
		)

		(CFSetXData WT_SOLID "G_WRKT" (CFModList #SetXd$ (list (list 39 #snk_dep))))
	)
;-- 2012/04/20 A.Satoh Add �V���N�z�u�s��Ή� - E

  ;// ��w�̃t���[�Y ��ʉ�w
  (command "_layer" "F" SKW_AUTO_SECTION "")

;;; ���ѕϐ��ݒ�
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)
  (setvar "EDGEMODE"  #ed)
  #WT_SOLID$
);PK_MakeWorktop3

;-- 2011/07/28 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <�֐���>    : AddWTCutLineL
;;; <�����T�v>  : L�^�̏ꍇ�V�ɶ��ײ݂�����(WT�����쐬�p)
;;; <�߂�l>    : �J�b�g���C���}�`�n���h��
;;; <�쐬>      : 2011/07/28 A.Satoh
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun AddWTCutLineL (
  &WT       ; �V�}�`
  &WTInfo   ; WT��ė�
  &CutID    ; �J�b�gID�@0:�J�b�g���� 1:�΂߃J�b�g 2:�����J�b�g
  /
  #xd$ #hh #lr_flg #tei #BaseP #pt$ #p1 #p2 #p3 #p4 #p5 #p6 #p33 #p44 #p55
  #ddd1 #ddd2 #clayer #dumpt #x1 #x2 #y1 #y2 #CutDirect #BG_Width #BG_Height
  #wt_hand #handle1 #handle2 #handle$ #en #en_dum1 #en_dum2 #CutPt
  #BG_Type #dirt
  )

;;; p1+----------+--LEN2-------------+p2
;;;   |          x1                  |
;;;   |          |     �̈�2         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |          |
;;;   |  �̈�1   |
;;;LEN1          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   |          |
;;; p6+----------+p5

  (setq #handle$ nil)

  (setq #xd$ (CFGetXData &WT "G_WRKT"))
  (setq #hh     (nth  8 #xd$))        ; �V����(���[��t����)
  (setq #hh (+ #hh (nth 10 #xd$)))    ; �V�����ɓV���݂����Z
  (setq #lr_flg (nth 30 #xd$))        ; ���E����t���O
  (setq #tei    (nth 38 #xd$))        ; WT��ʐ}�`�����
  (setq #BaseP  (nth 32 #xd$))        ; WT����_
  (setq #BG_Height (nth 12 #xd$))     ; �o�b�N�K�[�h����
  (setq #BG_Width (nth 13 #xd$))      ; �o�b�N�K�[�h����
  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��

  ; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))

  (setq #p1 (list (car #p1) (cadr #p1) #hh))
  (setq #p2 (list (car #p2) (cadr #p2) #hh))
  (setq #p3 (list (car #p3) (cadr #p3) #hh))
  (setq #p4 (list (car #p4) (cadr #p4) #hh))
  (setq #p5 (list (car #p5) (cadr #p5) #hh))
  (setq #p6 (list (car #p6) (cadr #p6) #hh))

  (setq #p33  (polar #p3   (angle #p2 #p3) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #p55  (polar #p5   (angle #p6 #p5) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #ddd1 (polar #p4   (angle #p2 #p3) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #ddd2 (polar #p4   (angle #p6 #p5) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #p44  (inters #p33 #ddd1 #p55 #ddd2 nil))

  ;;; �����̑������߂� #x1,#x2
  (setq #x1 (CFGetDropPt #p44 (list #p1 #p2)))
  (setq #x2 (CFGetDropPt #p44 (list #p1 #p6)))

  ; �����J�b�g�ł���ꍇ�A�J�b�g���������߂�
  (if (or (= &CutID 2)(= &CutID 3));2014/10/16 ������Ă������w��
    (progn
      ; ���݂̃r���[����ۑ�����
      (command "_.VIEW" "S" "TEMP_MRR")

      (command "_.VPOINT" (list 0 0 1))

      ; ��ĕ����w������
      (MakeLWPL (list #p44 (polar #x1 (angle #p6 #p1) 100)) 0)
      (setq #en_dum1 (entlast))
      (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; �F��ς���

      (MakeLWPL (list #p44 (polar #x2 (angle #p2 #p1) 100)) 0)
      (setq #en_dum2 (entlast))
      (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; �F��ς���

      (setq #CutPt (getpoint "\n��ĕ������w��:> "))
      (entdel #en_dum1)
      (entdel #en_dum2)

      (command "_.VIEW" "R" "TEMP_MRR")

      (if (< (distance #CutPt #x1) (distance #CutPt #x2))
        (setq #CutDirect "G")
        (setq #CutDirect "S")
      )
    )
    (setq #CutDirect "")
  )

  ;ײݍ�}
  (if (/= 0 &CutID)
    (progn
      (setq #clayer (getvar "CLAYER"))
      (setvar "CLAYER" SKW_AUTO_SOLID)

;      ; ���ʐ}
;      ;**************************************************************************
;      (defun AddWorkTopPlaneCutLine (
;        &WT ;�V�}�`
;        &pt$
;        /
;        #i #j #layer #sstmp #ss
;        )
;        (setq #ss (ssadd))
;        (foreach #i (list 1 2)
;          (setq #sstmp (ssadd))
;          (setq #layer (if (= #i 1) "Z_01_02_00_00" "Z_01_04_00_00"))
;          (MakeLayer #layer 7 "CONTINUOUS")
;          (setq #j 0)
;          (repeat (- (length &pt$) 1)
;            (command "_.line" (nth #j &pt$) (nth (+ #j 1) &pt$) "")
;            (ssadd (entlast) #ss)
;            (ssadd (entlast) #sstmp)
;            (setq #j (+ #j 1))
;          )
;          (command "chprop" #sstmp "" "LA" #layer "")
;        )
;        (ssadd &WT #ss)
;        (SKMkGroup #ss)
;      )
;      ;**************************************************************************
;
;(alert (strcat "#CutDirect = " #CutDirect "\n#lr_flg = " #lr_flg))
      (cond
        ((= &CutID 1)
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;�΂߶��
          (command "_.3DPOLY" #p4 #p1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "X"))

          (setq #handle2 "")

          (setq #handle$ (list #handle1 "" "" "" ""))
;
;          ; ���ʐ}
;          (AddWorkTopPlaneCutLine &WT (list #p4 #p1))
        )

        ((or (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "S")) ;�����
             (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "S")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;�E����żݸ����� or ������ź�ۑ����
          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #dumpt #x1 "")
          (setq #en (entlast))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #dumpt #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (if (and (= "L" #lr_flg) (= #CutDirect "S"))
            (setq #dirt "S")
            (setq #dirt "G")
          )
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
;          (setq #handle$ (list #handle1 #handle2 "" ""))
;
;          ; ���ʐ}
;          (AddWorkTopPlaneCutLine &WT (list #p4 #dumpt #x1))
        )
        ((or (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "G")) ;������
             (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "G")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #dumpt #x1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #dumpt #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
            (setq #dirt "G")
            (setq #dirt "S")
          )
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
;
;          ; ���ʐ}
;          (AddWorkTopPlaneCutLine &WT (list #p4 #dumpt #x2))
        )

				;2014/10/16 YM ADD �����J�b�g�ǉ�

;;; p1+----------+--LEN2-------------+p2
;;;   |          x1                  |
;;;   |          |     �̈�2         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |          |
;;;   |  �̈�1   |
;;;LEN1          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   |          |
;;; p6+----------+p5

        ((or (and (= "R" #lr_flg) (= &CutID 3) (= #CutDirect "S")) ;�����
             (and (= "L" #lr_flg) (= &CutID 3) (= #CutDirect "S")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;�E����żݸ����� or ������ź�ۑ����
          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #x1 "")
          (setq #en (entlast))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (setq #x2 (CFGetDropPt #p4 (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (if (and (= "L" #lr_flg) (= #CutDirect "S"))
            (setq #dirt "S")
            (setq #dirt "G")
          )
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))

        )
;;; p1+----------+--LEN2-------------+p2
;;;   |          x1                  |
;;;   |          |     �̈�2         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |          |
;;;   |  �̈�1   |
;;;LEN1          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   |          |
;;; p6+----------+p5

        ((or (and (= "L" #lr_flg) (= &CutID 3) (= #CutDirect "G")) ;������
             (and (= "R" #lr_flg) (= &CutID 3) (= #CutDirect "G")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #x1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (setq #x2 (CFGetDropPt #p4 (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
            (setq #dirt "G")
            (setq #dirt "S")
          )
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))

        )


        (T
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #dumpt #x1 "")
          (setq #en (entlast))

          (if (= #CutDirect "S")
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #dumpt #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (= #CutDirect "G")
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
            (setq #dirt "G")
            (setq #dirt "S")
          )
          (setq #handle$ (list #handle1 #handle2 "" "" ""))
;          (setq #handle$ nil)
        )
      );_cond

      (setvar "CLAYER" #clayer)
    )
    (setq #handle$ nil)
  );_if

  #handle$

);AddWTCutLineL
;-- 2011/07/28 A.Satoh Add - E



;;;<HOM>*************************************************************************
;;; <�֐���>    : AddWTCutLineL
;;; <�����T�v>  : L�^�̏ꍇ�V�ɶ��ײ݂�����(WT�����쐬�p)
;;; <�߂�l>    : �J�b�g���C���}�`�n���h��
;;; <�쐬>      : 2011/07/28 A.Satoh
;;; <���l>      : ������2015/01/09 EASY����R�s�[���Ċ֐����ύX�i�������l�Ⴄ�j������_AUTO �v���������p
;;;*************************************************************************>MOH<
(defun AddWTCutLineL_AUTO (
  &WT        ; �V�}�`
  &WTInfo    ; WT��ė�
  &CutID     ; �J�b�gID�@0:�J�b�g���� 1:�΂߃J�b�g 2:�����J�b�g 3:�������
	&CutDirect ; �J�b�g����(J��Ď��̂�)
  /
  #xd$ #hh #lr_flg #tei #BaseP #pt$ #p1 #p2 #p3 #p4 #p5 #p6 #p33 #p44 #p55
  #ddd1 #ddd2 #clayer #dumpt #x1 #x2 #y1 #y2 #CutDirect #BG_Width #BG_Height
  #wt_hand #handle1 #handle2 #handle$ #en_dum1 #en_dum2 #CutPt
  #BG_Type #dirt #en
  )

;;; p1+----------+--LEN2-------------+p2
;;;   |          x1                  |
;;;   |          |     �̈�2         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |          |
;;;   |  �̈�1   |
;;;LEN1          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   |          |
;;; p6+----------+p5

  (setq #handle$ nil)

  (setq #xd$ (CFGetXData &WT "G_WRKT"))
  (setq #hh     (nth  8 #xd$))        ; �V����(���[��t����)
  (setq #hh (+ #hh (nth 10 #xd$)))    ; �V�����ɓV���݂����Z
  (setq #lr_flg (nth 30 #xd$))        ; ���E����t���O
  (setq #tei    (nth 38 #xd$))        ; WT��ʐ}�`�����
  (setq #BaseP  (nth 32 #xd$))        ; WT����_
  (setq #BG_Height (nth 12 #xd$))     ; �o�b�N�K�[�h����
  (setq #BG_Width (nth 13 #xd$))      ; �o�b�N�K�[�h����
  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��

  ; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))

  (setq #p1 (list (car #p1) (cadr #p1) #hh))
  (setq #p2 (list (car #p2) (cadr #p2) #hh))
  (setq #p3 (list (car #p3) (cadr #p3) #hh))
  (setq #p4 (list (car #p4) (cadr #p4) #hh))
  (setq #p5 (list (car #p5) (cadr #p5) #hh))
  (setq #p6 (list (car #p6) (cadr #p6) #hh))

  (setq #p33  (polar #p3   (angle #p2 #p3) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #p55  (polar #p5   (angle #p6 #p5) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #ddd1 (polar #p4   (angle #p2 #p3) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #ddd2 (polar #p4   (angle #p6 #p5) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #p44  (inters #p33 #ddd1 #p55 #ddd2 nil))

  ;;; �����̑������߂� #x1,#x2
  (setq #x1 (CFGetDropPt #p44 (list #p1 #p2)))
  (setq #x2 (CFGetDropPt #p44 (list #p1 #p6)))

	;2014/12/15 YM DEL-S �����œn��
;;;  ; �����J�b�g�ł���ꍇ�A�J�b�g���������߂�
  (if (= &CutID 2) ;2014/10/16 ������Ă������w��
    (progn
        (setq #CutDirect &CutDirect);����
;;;      ; ���݂̃r���[����ۑ�����
;;;      (command "_.VIEW" "S" "TEMP_MRR")
;;;
;;;      (command "_.VPOINT" (list 0 0 1))
;;;
;;;      ; ��ĕ����w������
;;;      (MakeLWPL (list #p44 (polar #x1 (angle #p6 #p1) 100)) 0)
;;;      (setq #en_dum1 (entlast))
;;;      (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;;;      (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; �F��ς���
;;;
;;;      (MakeLWPL (list #p44 (polar #x2 (angle #p2 #p1) 100)) 0)
;;;      (setq #en_dum2 (entlast))
;;;      (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;;;      (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; �F��ς���
;;;
;;;      (setq #CutPt (getpoint "\n��ĕ������w��:> "))
;;;      (entdel #en_dum1)
;;;      (entdel #en_dum2)
;;;
;;;      (command "_.VIEW" "R" "TEMP_MRR")
;;;
;;;      (if (< (distance #CutPt #x1) (distance #CutPt #x2))
;;;        (setq #CutDirect "G")
;;;        (setq #CutDirect "S")
;;;      )
    )
		;else
    (setq #CutDirect "")
  );_if

  (if (= &CutID 3) ;2014/10/16 ������Ăͼݸ���Œ�
    (setq #CutDirect "S");�ݸ��
	);_if
	;2014/12/15 YM DEL-E �����œn��


  ;ײݍ�}
  (if (/= 0 &CutID)
    (progn
      (setq #clayer (getvar "CLAYER"))
      (setvar "CLAYER" SKW_AUTO_SOLID)

      (cond
        ((= &CutID 1);�΂߶��
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;�΂߶��
          (command "_.3DPOLY" #p4 #p1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "X"))

          (setq #handle2 "")

          (setq #handle$ (list #handle1 "" "" "" ""))
        )

;;; p1+----------+--LEN2-------------+p2
;;;   |          x1                  |
;;;   |          |     �̈�2         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |          |
;;;   |  �̈�1   |
;;;LEN1          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   |          |
;;; p6+----------+p5

        ((or (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "S")) ;�����(J���)
             (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "G")))

          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;�E����żݸ����� or ������ź�ۑ����
          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS");�ذ�ނ��鶯�ײ݉�w

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))

          (command "_.3DPOLY" #p4 #dumpt #x1 "");�㑤���ײ�(�ذ�ނ��Ȃ�)
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))
          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))


          (command "_.3DPOLY" #p4 #dumpt #x2 "");�������ײ�
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "");��w���ذ�މ�w�ɕύX
          (command "_.LAYER" "F" "WTCUT_HIDE" "");��w���ذ��

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))


				 ;2015/01/09 YM MOD-S
				 (setq #dirt #CutDirect)
;;;          (if (and (= "L" #lr_flg) (= #CutDirect "S"))
;;;            (setq #dirt "S")
;;;            (setq #dirt "G")
;;;          )
				 ;2015/01/09 YM MOD-E
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
        )

        ((or (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "S")) ;������(J���)
             (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "G")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))

          (command "_.3DPOLY" #p4 #dumpt #x1 "");�㑤���ײ�(�ذ�ނ���)
          (setq #en (entlast))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle1 (cdr (assoc 5 (entget #en))))
          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))


          (command "_.3DPOLY" #p4 #dumpt #x2 "")
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

				 ;2015/01/09 YM MOD-S
				 (setq #dirt #CutDirect)
;;;          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
;;;            (setq #dirt "G")
;;;            (setq #dirt "S")
;;;          )
				 ;2015/01/09 YM MOD-E
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
        )


				;2014/10/16 YM ADD �����J�b�g�ǉ�

;;; p1+----------+--LEN2-------------+p2
;;;   |          x1                  |
;;;   |          |     �̈�2         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |          |
;;;   |  �̈�1   |
;;;LEN1          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   |          |
;;; p6+----------+p5

        ((or (and (= "R" #lr_flg) (= &CutID 3) (= #CutDirect "S")) ;�����(�������)
             (and (= "L" #lr_flg) (= &CutID 3) (= #CutDirect "G")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;�E����żݸ����� or ������ź�ۑ����
          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #x1 "")
          (setq #en (entlast))

          (setq #handle1 (cdr (assoc 5 (entget #en))))
          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (setq #x2 (CFGetDropPt #p4 (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #x2 "")
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

				 ;2015/01/09 YM MOD-S
				 (setq #dirt #CutDirect)
;;;          (if (and (= "L" #lr_flg) (= #CutDirect "S"))
;;;            (setq #dirt "S")
;;;            (setq #dirt "G")
;;;          )
				 ;2015/01/09 YM MOD-E
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))

        )
;;; p1+----------+--LEN2-------------+p2
;;;   |          x1                  |
;;;   |          |     �̈�2         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |          |
;;;   |  �̈�1   |
;;;LEN1          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   |          |
;;; p6+----------+p5

        ((or (and (= "L" #lr_flg) (= &CutID 3) (= #CutDirect "S")) ;������(�������)
             (and (= "R" #lr_flg) (= &CutID 3) (= #CutDirect "G")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #x1 "")
          (setq #en (entlast))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (setq #x2 (CFGetDropPt #p4 (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #x2 "")
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

				 ;2015/01/09 YM MOD-S
				 (setq #dirt #CutDirect)
;;;          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
;;;            (setq #dirt "G")
;;;            (setq #dirt "S")
;;;          )
				 ;2015/01/09 YM MOD-E
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))

        )


        (T
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #dumpt #x1 "")
          (setq #en (entlast))

          (if (= #CutDirect "S")
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #dumpt #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (= #CutDirect "G")
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #handle2 (cdr (assoc 5 (entget #en))))

;;;          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
;;;            (setq #dirt "G")
;;;            (setq #dirt "S")
;;;          )
          (setq #handle$ (list #handle1 #handle2 "" "" ""))
        )
      )

      (setvar "CLAYER" #clayer)
    )
    (setq #handle$ nil)
  )

  #handle$

);AddWTCutLineL


;-- 2011/08/25 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <�֐���>    : AddWTCutLineU
;;; <�����T�v>  : U�^�̏ꍇ�V�ɶ��ײ݂�����(WT�����쐬�p)
;;; <�߂�l>    : �J�b�g���C���}�`�n���h�����X�g
;;; <�쐬>      : 2011/08/25 A.Satoh
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun AddWTCutLineU (
  &WT       ; �V�}�`
  &WTInfo   ; WT��ė�
  &CutID    ; �J�b�gID�@0:�J�b�g���� 1:�΂߃J�b�g 2:�����J�b�g
  /
  #handle$ #CutPt1 #CutPt2 #en_dum1 #en_dum2
  #xd$ #hh #lr_flg #tei #BaseP #BG_Height #BG_Width #pt$
  #pt$ #p1 #p2 #p3 #p4 #p5 #p6 #p7 #p8
  #p33 #p44 #p55 #p66 #ddd #ddd1 #ddd2 #ddd3 #ddd4 #ang #x1 #x2 #x3 #x4
  #ptn #clayer #wt_hand #en #handle1 #handle2
  )

  (setq #handle$ nil)

;;; p1+----------+-------------------+p2
;;;   |          x1     +----+       |
;;;   |          |      | S  |       |
;;;   |          |      +----+       |
;;;   +x2--------+-------------------+p3
;;;   |          |p4
;;;   |          |
;;;   |          |
;;;   |          |p5
;;;   +x3--------+-------------------+p6
;;;   |          |                   |
;;;   |          |                   |
;;;   |          x4                  |
;;; p8+----------+-------------------+p7

  (setq #xd$ (CFGetXData &WT "G_WRKT"))
  (setq #hh     (nth  8 #xd$))        ; �V����(���[��t����)
  (setq #hh (+ #hh (nth 10 #xd$)))    ; �V�����ɓV���݂����Z
  (setq #lr_flg (nth 30 #xd$))        ; ���E����t���O
  (setq #tei    (nth 38 #xd$))        ; WT��ʐ}�`�����
  (setq #BaseP  (nth 32 #xd$))        ; WT����_
  (setq #BG_Height (nth 12 #xd$))     ; �o�b�N�K�[�h����
  (setq #BG_Width (nth 13 #xd$))      ; �o�b�N�K�[�h����
  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��

  ; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))
  (setq #p7 (nth 6 #pt$))
  (setq #p8 (nth 7 #pt$))

  (setq #p1 (list (car #p1) (cadr #p1) #hh))
  (setq #p2 (list (car #p2) (cadr #p2) #hh))
  (setq #p3 (list (car #p3) (cadr #p3) #hh))
  (setq #p4 (list (car #p4) (cadr #p4) #hh))
  (setq #p5 (list (car #p5) (cadr #p5) #hh))
  (setq #p6 (list (car #p6) (cadr #p6) #hh))
  (setq #p7 (list (car #p7) (cadr #p7) #hh))
  (setq #p8 (list (car #p8) (cadr #p8) #hh))

  (setq #p33  (polar #p3   (angle #p2 #p3) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #p66  (polar #p6   (angle #p7 #p6) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #ddd (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #ang (angle #ddd #p4))
  (setq #ddd1 (polar #p4   (angle #p2 #p3) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #ddd2 (polar #p4   #ang            (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #ddd3 (polar #p5   #ang            (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #ddd4 (polar #p5   (angle #p7 #p6) (nth 6 &WTInfo))) ; WT��ėʕ�
  (setq #p44  (inters #p33 #ddd1 #ddd2 #ddd3 nil))
  (setq #p55  (inters #ddd2 #ddd3 #p66 #ddd4 nil))

  ;;; �����̑������߂� #x1,#x2
  (setq #x1 (CFGetDropPt #p44 (list #p1 #p2)))
  (setq #x2 (CFGetDropPt #p44 (list #p1 #p8)))
  (setq #x3 (CFGetDropPt #p55 (list #p1 #p8)))
  (setq #x4 (CFGetDropPt #p55 (list #p7 #p8)))

  ; �����J�b�g�ł���ꍇ�A�J�b�g���������߂�
  (if (= &CutID 2)
    (progn
      ; ���݂̃r���[����ۑ�����
      (command "_.VIEW" "S" "TEMP_MRR")

      (command "_.VPOINT" (list 0 0 1))

      ;;; հ�ް�ɶ�ĕ������w��
      (setq #CutPt1 nil)
      (setq #CutPt2 nil)

      (MakeLWPL (list #p44 (polar #x1 (angle #p8 #p1) 100)) 0) ; 01/06/25 YM MOD
      (setq #en_dum1 (entlast))
      (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; �F��ς���

      (MakeLWPL (list #p44 (polar #x2 (angle #p2 #p1) 100)) 0) ; 01/06/25 YM MOD
      (setq #en_dum2 (entlast))
      (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; �F��ς���

      (setq #CutPt1 (getpoint "\n�J�b�g�������w��: "))
      (entdel #en_dum1)
      (entdel #en_dum2)

      (MakeLWPL (list #p55 (polar #x3 (angle #p2 #p1) 100)) 0) ; 01/06/25 YM MOD
      (setq #en_dum1 (entlast))
      (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; �F��ς���

      (MakeLWPL (list #p55 (polar #x4 (angle #p1 #p8) 100)) 0) ; 01/06/25 YM MOD
      (setq #en_dum2 (entlast))
      (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; �F��ς���

      (setq #CutPt2 (getpoint "\n�J�b�g�������w��: "))
      (entdel #en_dum1)
      (entdel #en_dum2)

      (command "_.VIEW" "R" "TEMP_MRR")

;;; X��Ă̕����w�� U�z��̏ꍇ�A�����w����2��s��
;;;   +--------(1)-----------------+
;;;   |         |                  |
;;;   |         |                  |
;;;  (2)--------+------------------+
;;;   |         | ����� (1)��(3)=>#ptn=1
;;;   |         |       (1)��(4)=>#ptn=2
;;;   |         |       (2)��(3)=>#ptn=3
;;;   |         |       (2)��(4)=>#ptn=4
;;;  (3)--------+------------------+
;;;   |         |                  |
;;;   |         |                  |
;;;   +--------(4)-----------------+

      (if (< (distance #CutPt1 #x1) (distance #CutPt1 #x2))
        (progn
          (if (< (distance #CutPt2 #x3) (distance #CutPt2 #x4))
            (setq #ptn 1)
            (setq #ptn 2)
          )
        )
        (progn
          (if (< (distance #CutPt2 #x3) (distance #CutPt2 #x4))
            (setq #ptn 3)
            (setq #ptn 4)
          )
        )
      );_if
    )
  )

  ;ײݍ�}
  (if (/= 0 &CutID)
    (progn
      (setq #clayer (getvar "CLAYER"))
      (setvar "CLAYER" SKW_AUTO_SOLID)

      (cond
        ((= &CutID 1)
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ; �΂߶��
          (setq #wt_hand (cdr (assoc 5 (entget &WT))))

          (command "_.3DPOLY" #p4 #p1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "X"))

          (command "_.3DPOLY" #p5 #p8 "")
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "X"))

          (setq #handle$ (list #handle1 "" #handle2 "" ""))
        )
        ((= &CutID 2)
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")
          (setq #wt_hand (cdr (assoc 5 (entget &WT))))

          (setq #sp1 (polar #p44 (angle #p8 #p1) #BG_Height))
          (setq #sp1 (polar #sp1 (angle #p2 #p1) #BG_Height))
          (setq #sp2 (polar #p55 (angle #p2 #p1) #BG_Height))
          (setq #sp2 (polar #sp2 (angle #p1 #p8) #BG_Height))

          (setq #x1 (CFGetDropPt #sp1 (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #sp1 #x1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (or (= #ptn 3) (= #ptn 4))
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #x2 (CFGetDropPt #sp1 (list #p1 #p8)))
          (command "_.3DPOLY" #p4 #sp1 #x2 "")
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (or (= #ptn 1) (= #ptn 2))
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #x3 (CFGetDropPt #sp2 (list #p1 #p8)))
          (command "_.3DPOLY" #p5 #sp2 #x3 "")
          (setq #en (entlast))
          (setq #handle3 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (or (= #ptn 2) (= #ptn 4))
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #x4 (CFGetDropPt #sp2 (list #p7 #p8)))
          (command "_.3DPOLY" #p5 #sp2 #x4 "")
          (setq #en (entlast))
          (setq #handle4 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (or (= #ptn 1) (= #ptn 3))
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #handle$ (list #handle1 #handle2 #handle3 #handle4 ""))

        )
        (T
          (setq #handle$ nil)
        )
      );_cond

      (setvar "CLAYER" #clayer)
    )
    (setq #handle$ nil)
  );_if

  #handle$

);AddWTCutLineU
;-- 2011/08/25 A.Satoh Add - E

;<HOM>*************************************************************************
; <�֐���>    : FullSemiFlatHantei
; <�����T�v>  : ���ׯ�,���ׯĔ���
; <�߂�l>    : "SF"�F���ׯ�,"FF"�F���ׯ�,""�F����ȊO
; <�쐬>      : 04/04/09 YM
; <���l>      : Errmsg.ini�Q��
;               �������@2009/04/17 YM ���g�p������
;*************************************************************************>MOH<
(defun FullSemiFlatHantei (
  &dep$ ; WT���s��
  /
  #FULLFLAT #RET #SEMIFLAT
  )
  (setq #ret "")
  (cond
    ((= "D105" (nth 7 CG_GLOBAL$))
      (setq #ret "D105")
    )
    ((= "D970" (nth 7 CG_GLOBAL$))
      (setq #ret "D970")
    )
    ((= "D900" (nth 7 CG_GLOBAL$))
      (setq #ret "D900")
    )
    (T
      (setq #ret "")
    )
  );_cond

  #ret
);FullSemiFlatHantei

;<HOM>*************************************************************************
; <�֐���>    : KPGetLowCabDimW
; <�����T�v>  : ۰���ނ̊Ԍ���Ԃ�
; <�߂�l>    : ۰���ނ̊Ԍ�(����)
; <�쐬>      : 01/03/23 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KPGetLowCabDimW (
  &en_LOW$ ; ۰���޼���ِ}�`ؽ�
  /
  #RET
  )
  (setq #ret 0)
  (foreach en &en_LOW$
    (setq #ret (+ #ret (nth 3 (CFGetXData en "G_SYM"))))
  )
  #ret
);KPGetLowCabDimW


;<HOM>*************************************************************************
; <�֐���>    : PKWT_INFO_Dlg
; <�����T�v>  : WT���_�C�A���O
;               WT�f�ތ����Ń��R�[�h���Ƃ�Ȃ������Ƃ��ɕ\������
; <�쐬>      : 2000.3.29  YM
;*************************************************************************>MOH<
(defun PKWT_INFO_Dlg (
  /
  #WTInfo #dcl_id ##GetDlgItem
  )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( /
            #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #WTInfo
            #BG_SEP #WT_H)

            (cond
              ((##Check "WT_H" (get_tile "WT_H") "ܰ�į�ߍ���")   nil)
              ((##Check "WT_T" (get_tile "WT_T") "ܰ�į�ߌ���")   nil)
              ((##Check "BG_H" (get_tile "BG_H") "�ޯ��ް�ލ���") nil)
              ((##Check "BG_T" (get_tile "BG_T") "�ޯ��ް�ތ���") nil)
              ((##Check "FG_H" (get_tile "FG_H") "�O���ꍂ��")    nil)
              ((##Check "FG_T" (get_tile "FG_T") "�O�������")    nil)
              ((##Check "FG_S" (get_tile "FG_S") "�O������")     nil)
              (t ; �װ���Ȃ��ꍇ
                  (setq #WT_H (atoi (get_tile "WT_H"))) ; WT�̍���
                  (setq #WT_T (atoi (get_tile "WT_T"))) ; WT�̌���
                  (setq #BG_H (atoi (get_tile "BG_H"))) ; BG�̍���
                  (setq #BG_T (atoi (get_tile "BG_T"))) ; BG�̌���
                  (setq #FG_H (atoi (get_tile "FG_H"))) ; FG�̍���
                  (setq #FG_T (atoi (get_tile "FG_T"))) ; FG�̌���
                  (setq #FG_S (atoi (get_tile "FG_S"))) ; �O�����ė�
                  (if (= (get_tile "BG_Sep") "1") ; �ޯ��ް�ޕ���
                    (setq #BG_Sep "Y" )
                    (setq #BG_Sep "N" )
                  );_if
                  (setq #WTInfo (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep))
                (done_dialog)
              )
            );_cond
            #WTInfo
          )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Check (&sKEY &sVAL &sNAME / )
            (if (= nil (and (numberp (read &sVAL)) (< 0 (read &sVAL))))
              (progn
                (alert (strcat &sNAME "����" "\n ���l����͂��Ă������� (1�`9 �̔��p����)"))
                (mode_tile &sKEY 2)
                (eval 'T) ; �װ����
              );end of progn
            ); end of if
          ); end of ##Check
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "WT_INFO_Dlg" #dcl_id)) (exit))

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #WTInfo (##GetDlgItem))")
  (action_tile "cancel" "(setq #WTInfo nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #WTInfo
);PKWT_INFO_Dlg

;;;<HOM>*************************************************************************
;;; <�֐���>    : MakeTEIMEN
;;; <�����T�v>  : �_���X�g-->����������ײݐ}�`����Ԃ�
;;; <�߂�l>    : �}�`��
;;; <�쐬>      : 2000.4.20 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun MakeTEIMEN ( &pt$ /  )
  (MakeLWPL &pt$ 1)
  (entlast)
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKSLOWPLCP
;;; <�����T�v>  : �_ &pt �̂܂���&outpl_LOW(۰���߷��ފO�`���ײ�)�������  #res1=T �Ȃ���� nil
;;; <�߂�l>    : T or nil
;;; <�쐬>      : 2000.4.13 YM ��ċL��"T","L"�Ή� 4.17�C��
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;;*************************************************************************>MOH<
(defun PKSLOWPLCP (
  &pt
  &outpl
  /
  #ELM
  #HAND #HAND0
  #I #P0$
  #P01 #P02 #P03 #P04
  #RET1 #RET2 #SS00
  #HINBAN #SYM
  )

  (setq #hand0 (cdr (assoc 5 (entget &outpl))))       ; ���ײ������
  (setq #p01 (list (- (car &pt) 1) (+ (cadr &pt)   1))) ; ����
  (setq #p02 (list (- (car &pt) 1) (- (cadr &pt) 101))) ; ����
  (setq #p03 (list (+ (car &pt) 1) (- (cadr &pt) 101))) ; �E��
  (setq #p04 (list (+ (car &pt) 1) (+ (cadr &pt)   1))) ; �E��

  (setq #p0$ (list #p01 #p02 #p03 #p04 #p01))

  (setq #ss00 (ssget "CP" #p0$))

  (setq #i 0 #ret1 nil)
  (while (< #i (sslength #ss00))
    (setq #elm (ssname #ss00 #i))
    (setq #hand (cdr (assoc 5 (entget #elm))))
    (if (equal #hand0 #hand) ; ۰���߷��ފO�`���ײ݂ƈ�v������
      (setq #ret1 T)
    );_if
    (setq #i (1+ #i))
  )
  #ret1 ; 00/04/17 YM �i�Ԋm��Ō�������
);PKSLOWPLCP

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMakeWT_BG_FG_Pline
;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬
;;; <�߂�l>    : ((WT��ʐ}�`��,BG��ʐ}�`��,FG��ʐ}�`��,cut type),...)
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKMakeWT_BG_FG_Pline (
  &pt$$        ; WT��\��O�`PLINE�_���ؽ�
  &base_new$   ; �ް����޼����
  &CG_WtDepth  ; 0,1,10,100 WT�g���t���O
  &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
  &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
  &WTInfo2     ; WT���2  (#BG_S2 #BG_Type2 #FG_Type2)
  &WTInfo3     ; WT���3  (#BG_S3 #BG_Type3 #FG_Type3)
  &CutId       ; ���ID 0,1,2 �Ȃ�,�΂�H,�����w��
  &outpl_LOW   ;
  &ZaiCode     ; �ގ��L��
  /
  #FLG #K #KOSU #LIS$
  #PT$ #RET$ #RET0$
  #DEP #dep$ #RAPIS #MSG
  #BASE_NEW$ #I #SSLSYM ; 01/08/20 YM ADD
  )
  (command "vpoint" "0,0,1")
  (setq #lis$ (FlagToList &CG_WtDepth)) ; WT�g���׸ނ�ؽĉ� (? ? ?)
  (setq #k 0)
  (setq #ret$ '() #flg nil)
  (repeat (length &pt$$)       ; �O�`�̈�̐������J��Ԃ�
    (setq #pt$ (nth #k &pt$$)) ; PLINE�_�� (@@@)
    (setq #kosu (length #pt$))
;;;****************************************************************************
    (cond
      ((= #kosu 4) ; I�`��
        ; 01/08/20 BG�����������s��Ή� START --------------
        (if (< 1 (length &pt$$)) ; 01/08/27 YM MOD
          (progn ; WT�����̂Ƃ�
            (setq #ssLSYM (ssget "CP" (AddPtList #pt$) (list (list -3 (list "G_LSYM"))))) ; �̈���̼���ِ}�`
            (if (and #ssLSYM (> (sslength #ssLSYM) 0))
              (progn ; &base_new$ �̒��� #ssLSYM �ƈ�v������̂��擾
                (setq #base_new$ nil)
                (foreach base_new &base_new$
                  (setq #i 0)
                  (repeat (sslength #ssLSYM)
                    (if (equal base_new (ssname #ssLSYM #i))
                      (setq #base_new$ (append #base_new$ (list base_new)))
                    );_if
                    (setq #i (1+ #i))
                  )
                );foreach
              )
              (setq #base_new$ &base_new$)
            );_if
          )
          (setq #base_new$ &base_new$) ; ���܂Œʂ�WT1������
        );_if
        ; 01/08/20 BG�����������s��Ή� END -----------------

        (setq #ret0$
          (PKMakeTeimenPline_I
            #pt$
;;;01/08/20YM@            &base_new$   ; �ް����޼����   I�̂�
            #base_new$   ; �ް����޼����   I�̂� ; 01/08/20 YM BG�����������s��Ή�
;;;            #lis$        ; WT�g���t���O ; 01/08/27 YM DEL
            &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
            &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
            &outpl_LOW   ;
            &ZaiCode     ; �ގ��L��
          )
        )
      )
      ((= #kosu 6) ; L�`��
        (setq #ret0$
          (PKMakeTeimenPline_L
            #pt$
;;;            #lis$        ; WT�g���t���O ; 01/08/27 YM DEL
            &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
            &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
            &WTInfo2     ; WT���2  (#BG_S2 #BG_Type2 #FG_Type2)
            &WTInfo3     ; WT���3  (#BG_S3 #BG_Type3 #FG_Type3)
            &CutId       ; ���ID 0,1,2 �Ȃ�,�΂�H,�����w��  L,U�̂�
            &outpl_LOW   ;
            &ZaiCode     ; �ގ��L��
          )
        )
      )
      ((= #kosu 8) ; U�`��
        (setq #ret0$
          (PKMakeTeimenPline_U
            #pt$
;;;            #lis$        ; WT�g���t���O ; 01/08/27 YM DEL
            &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
            &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
            &WTInfo2     ; WT���2  (#BG_S2 #BG_Type2 #FG_Type2)
            &WTInfo3     ; WT���3  (#BG_S3 #BG_Type3 #FG_Type3)
            &CutId       ; ���ID 0,1,2 �Ȃ�,�΂�H,�����w��  L,U�̂�
            &outpl_LOW   ;
            &ZaiCode     ; �ގ��L��
          )
        )
      )
      (T
        (setq #msg "����ȯĂ̑O�ʂ������Ă��Ȃ����A�O�`�̈悪����������܂���")
        (CMN_OutMsg #msg) ; 02/09/05 YM ADD
;-- 2011/09/09 A.Satoh Add - S
        (exit)
;-- 2011/09/09 A.Satoh Add - E
      )
    );_cond
;;;****************************************************************************
    (setq #ret$ (append #ret$ #ret0$)) ; #ret$ �� #ret0$ ��ǉ�����
    (setq #k (1+ #k))
  );_repeat

  ; �i�������܂߂�WT�O�`�_��ɑO����,WT���s���g�����l������ 01/08/24 YM ADD-S
    (setq #kosu (length CG_GAIKEI)) ; �_���
    (cond
      ((= #kosu 4) ; I�`��
        nil ; �������Ȃ�
      )
      ((= #kosu 6) ; L�`��
        (PKMakeTeimenPline_L_ALL
          &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
          &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
          &WTInfo2     ; WT���2  (#BG_S2 #BG_Type2 #FG_Type2)
        )
      )
      ((= #kosu 8) ; U�`��
        (PKMakeTeimenPline_U_ALL
          &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
          &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
          &WTInfo2     ; WT���2  (#BG_S2 #BG_Type2 #FG_Type2)
          &WTInfo3     ; WT���3  (#BG_S3 #BG_Type3 #FG_Type3)
        )
      )
      (T
        nil ; �������Ȃ�
      )
    );_cond
;;;****************************************************************************


  ; �i�������܂߂�WT�O�`�ɑO����,WT���s���g�����l������ 01/08/24 YM ADD-E

  (command "zoom" "p")
  #ret$
);PKMakeWT_BG_FG_Pline

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_GetBG_FG_Teimen
;;; <�����T�v>  : BG,FG�׸ނ���BG,FG������ײ݂����߂�
;;; <�߂�l>    : (BGؽ�,FGؽ�)
;;; <�쐬>      : 00/09/25 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PK_GetBG_FG_Teimen (
  &bg_en$  ;BGؽ�
  &fg_en$  ;FGؽ�
  &BG_Type ;BG�L�� 0:�Ȃ�,1:����
  &FG_Type ;FG���� 1:�w��,2:����
  /
  #BG_EN$ #FG_EN$ #FG_EN2
  )
  (if (equal &FG_Type 2 0.1)
    (progn ; FG����
      (setq #fg_en2 (car &bg_en$))
      (setq #fg_en$ (list (car &fg_en$) #fg_en2))
    )
    (setq #fg_en$ &fg_en$) ; FG�ʏ�
  );_if

  (if (equal &BG_Type 0 0.1)
    (setq #bg_en$ nil)     ; BG�Ȃ�
    (setq #bg_en$ &bg_en$) ; BG����
  );_if

  (list #bg_en$ #fg_en$)
);PK_GetBG_FG_Teimen

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMakeTeimenPline_I
;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬
;;; <�߂�l>    :
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKMakeTeimenPline_I (
  &pt$         ; �eWT�O�`�_�� 4,6,8�_�̂�
  &base_new$   ; �ް����޼����   I�̂�
;;;  &lis$        ; WT�g���t���O ; 01/08/27 YM DEL
;;;  &WTInfo      ; WT���(#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S)
  &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
  &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
  &outpl_LOW   ;
  &ZaiCode     ; �ގ��L��
  /
	#BASEPT #BG_EN$ #BG_EN1 #BG_EN2 #BG_S #BG_T #BG_TYPE #CUT_TYPE #DEP
	#DUMPT1 #DUMPT2 #FG_EN$ #FG_EN1 #FG_EN2 #FG_S #FG_T #FG_TYPE #OFFSETL #OFFSETR
	#P1 #P11 #P111 #P111WTR #P11WTR #P1WTR
	#P2 #P22                #P22WTR #P2WTR
	#P3 #P33 #P333 #P333WTL #P33WTL #P3WTL
	#P4 #P44                #P44WTL #P4WTL
	#PA #PAFGR
	#PB #PBFGR
	#PC #PCFGL
	#PD #PDFGL
	#PE #PEFGR
	#PF #PFFGL
	#PGFGR
	#PHFGL
	#PT$ #RET #RET$ #SA #TOP_FLG #WT_BASE #WT_EN #WT_LEN
  )
  (setq #pt$ &pt$)
  (setq #BG_T    (nth 3 &WTInfo )) ; BG�̌��� <<<12mm>>>
  (setq #FG_T    (nth 5 &WTInfo )) ; FG�̌��� <<<20mm>>>

	;2016/02/23 ����BG����=0�Ȃ�O������݂̒l�������Ă����@#BG_Type=1�̂Ƃ��g�p
	(if (equal #BG_T 0.0 0.1)
		(if (equal #FG_T 0.0 0.1)
			(setq #BG_T 20);�_�~�[������̂�h�~
			;else
			(setq #BG_T #FG_T)
		);_if
	);_if ;2016/02/16 YM ADD

  (setq #FG_S    (nth 6 &WTInfo )) ; �O����V�t�g��
  (setq #TOP_FLG (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
  (setq #BG_S    (nth 0 &WTInfo1)) ; �㐂��V�t�g��

  (setq #BG_Type (nth 1 &WTInfo1)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #FG_Type (nth 2 &WTInfo1)) ; FG���� 1:FG�O�� 2:FG����

  (setq #offsetL  (nth 3 &WTInfo1)) ; �����莞�ݸ��(����)�̾�Ēl
  (setq #offsetR  (nth 4 &WTInfo1)) ; �����莞��ۑ�(�E��)�̾�Ēl
  

  ;;; �Vۼޯ� �O�`�_��-->��Ű��_ PKGetBaseL6
  (setq #BASEPT (PKGetBaseI4 #pt$ &base_new$)) ; �_��Ƽ����ؽ�(����قƺ�Ű��_�͕K��������v���Ȃ�)
  ;;; �O�`�_������߂�.I�^
  (setq #pt$ (GetPtSeries #BASEPT #pt$)) ; �_�����#BASEPT��擪�Ɏ��v����ɂ���
  (setq #p4 (nth 0 #pt$)) ; #p1,2,3,4 ���Ԓ���
  (setq #p2 (nth 1 #pt$))
  (setq #p1 (nth 2 #pt$))
  (setq #p3 (nth 3 #pt$))
  ;;; WT�g���Ή� �K�v�Ȃ�#p2 #p4�����ߒ���
  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL (if (> #BG_S 0.1)
;;;02/01/21YM@DEL    (progn

;;; ��I�^�����s�������ʂ��l��
;;;  BASE=p4------------------------+p2   <---BG�w��
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  +p3----------------------------+p1
      (setq #sa #BG_S);���s��������
      (setq #p2 (polar #p2 (angle #p1 #p2) #sa))
      (setq #p4 (polar #p4 (angle #p3 #p4) #sa))
;;;02/01/21YM@DEL    )
;;;02/01/21YM@DEL  );_if



  ;;; WT,BG,FG ��ʊO�`�̊e�_�����߂�
;-- 2011/10/25 A.Satoh Mod(���ɖ߂�) - S
;;;;;-- 2011/09/30 A.Satoh Mod - S

;;; ��I�^��
;;;  BASE=p4------------------------+p2   <---BG�w��
;;;  |                              |
;;;  +p44                           +p22  <---BG�O��
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  +p3----------------------------+p1
;��2016/02/16 YM #BG_T ��L����
	(if (equal #BG_Type 1 0.1) ; BG����
		(progn
		  (setq #p22  (polar #p2  (angle #p2 #p1) #BG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
		  (setq #p44  (polar #p4  (angle #p4 #p3) #BG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
		)
		(progn ;BG�Ȃ��@�O�����荞�݂Ɏg���_
		  (setq #p22  (polar #p2  (angle #p2 #p1) #FG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
		  (setq #p44  (polar #p4  (angle #p4 #p3) #FG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
		)
	);_if
;��2016/02/16 YM #BG_T ��L����
;;;;;;-- 2011/09/30 A.Satoh Mod - E
;-- 2011/10/25 A.Satoh Mod(���ɖ߂�) - E

;;; ��I�^��
;;;  BASE=p4------------------------+p2   <---BG�w��
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  +p333                          +p111 <---FG�w��
;;;  |                              |
;;;  +p3                            +p1  <--�V�O�`���Ƃ̈ʒu
;;;  +p33---------------------------+p11  <---FG�O��

  (setq #p11  (polar #p1  (angle #p2 #p1) #FG_S)) ; �O����V�t�g�ʕ��O�Ɉړ�
  (setq #p33  (polar #p3  (angle #p4 #p3) #FG_S)) ; �O����V�t�g�ʕ��O�Ɉړ�
  (setq #p333 (polar #p33 (angle #p3 #p4) #FG_T)) ; FG���ݕ����Ɉړ�
  (setq #p111 (polar #p11 (angle #p1 #p2) #FG_T)) ; FG���ݕ����Ɉړ�

  ;03/09/22 YM ADD ����į���׸ޑΉ�
;-- 2011/10/25 A.Satoh Mod(���ɖ߂�) - S
;;;;;;-- 2011/09/30 A.Satoh Mod - S

;;; ��I�^�� �yBG��荞�ݗp�̓_pA,pB,pC,pD��ǉ��z
;;;  BASE=p4------------------------------+p2   <---BG�w��
;;;  |                                    |
;;;  +p44    +pC                    pB+   +p22  <---BG�O��
;;;  |                                    |
;;;  |                                    |
;;;  +p333   +pF                    pE+   +p111 <---FG�w��
;;;  |                                    |
;;;  +p3                                  +p1
;;;  +p33----+pD--------------------pA+---+p11  <---FG�O��

			;2016/02/24 YM BG��荞�݂ɂ����g��Ȃ��ϐ�
		  (setq #pA (polar #p11  (angle #p2 #p4) #BG_T))
		  (setq #pB (polar #p22  (angle #p2 #p4) #BG_T))
		  (setq #pC (polar #p44  (angle #p4 #p2) #BG_T))
		  (setq #pD (polar #p33  (angle #p4 #p2) #BG_T))
		  (setq #pE (polar #p111 (angle #p2 #p4) #BG_T))
		  (setq #pF (polar #p333 (angle #p4 #p2) #BG_T))

;;; ��I�^�� �y�V�����z
;;;     p4WTL *<--- BASE=p4--------------------+p2---->*p2WTR
;;;           |     |                          |       |
;;;    p44WTL *<--- +p44                       +p22--->*p22WTR
;;;           |     |                          |       |
;;;           |     |                          |       |
;;;   p333WTL *<--- +p333                      +p111-->*p111WTR
;;;           |     |                          |       |
;;;     p3WTL |     +p3                        +p1     *p1WTR
;;;    p33WTL *<--- +p33-----------------------+p11--->*p11WTR

					;���V�������� 2016/02/24 YM  �ϐ����̕ύX ffL=>WTR ffR=>WTL
          (setq #p2WTR   (polar #p2   (angle #p4 #p2) #offsetR));�E���V����
          (setq #p22WTR  (polar #p22  (angle #p4 #p2) #offsetR))
          (setq #p111WTR (polar #p111 (angle #p4 #p2) #offsetR))
          (setq #p1WTR   (polar #p1   (angle #p4 #p2) #offsetR))
          (setq #p11WTR  (polar #p11  (angle #p4 #p2) #offsetR))

          (setq #p4WTL   (polar #p4   (angle #p2 #p4) #offsetL));�����V����
          (setq #p44WTL  (polar #p44  (angle #p2 #p4) #offsetL))
          (setq #p333WTL (polar #p333 (angle #p2 #p4) #offsetL))
          (setq #p3WTL   (polar #p3   (angle #p2 #p4) #offsetL))
          (setq #p33WTL  (polar #p33  (angle #p2 #p4) #offsetL))



  ;03/09/22 YM ADD ����į���׸ޑΉ�
;��2016/02/16 YM #BG_T ��L����

;;; ��I�^��
;;;     p4WTL *---- p4----+HFGL-----------------GFGR+--+p2-----*p2WTR
;;;           |     |                                  |       |
;;;    p44WTL *---- +p44  +CFGL                 BFGR+  +p22----*p22WTR
;;;           |     |                                  |       |
;;;           |     |                                  |       |
;;;   p333WTL *---- +p333 +FFGL                 EFGR+  +p111---*p111WTR
;;;           |     |                                  |       |
;;;     p3WTL |     +p3                                +p1     *p1WTR
;;;    p33WTL *---- +p33--+DFGL-----------------AFGR+--+p11----*p11WTR

			;2016/02/24 YM �O�����荞�ݓ_�ϐ��ύX ffL==>FGR ffR==>FGL
		  (setq #pAFGR (polar #p11WTR  (angle #p2 #p4) #FG_T))
		  (setq #pBFGR (polar #p22WTR  (angle #p2 #p4) #FG_T))
		  (setq #pCFGL (polar #p44WTL  (angle #p4 #p2) #FG_T))
		  (setq #pDFGL (polar #p33WTL  (angle #p4 #p2) #FG_T))
		  (setq #pEFGR (polar #p111WTR (angle #p2 #p4) #FG_T))
		  (setq #pFFGL (polar #p333WTL (angle #p4 #p2) #FG_T))
		  (setq #pGFGR (polar #p2WTR   (angle #p2 #p4) #FG_T))
		  (setq #pHFGL (polar #p4WTL   (angle #p4 #p2) #FG_T))

  ;BG��ʍ�} ��������������������������������������������������������������������
  (cond
    ((equal #BG_Type 1 0.1) ; BG����
      (cond       
        ((equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
          (setq #bg_en1 (MakeTEIMEN (list #p4 #p2 #p11 #pA #pB #pC #pD #p33))); �ޯ��ް�ޒ��
        )
        ((or (equal #TOP_FLG  2 0.1)(equal #TOP_FLG  3 0.1));�ׯđΖ�
          (setq #bg_en1 nil); �ޯ��ް�ނȂ�
        )
        ;2010/10/27 YM ADD-S �V�X�C�[�W�B��ٓV��I�^�̑O���ꉡ������荞�݁@BG����
 				;2016/02/24 �ϐ��ύX ffL=>WTR ffR=>WTL
        ((or (equal #TOP_FLG 4 0.1)(equal #TOP_FLG 5 0.1));���E���苤��
          (setq #bg_en1 (MakeTEIMEN (list #p4WTL #p2WTR #p22WTR #p44WTL))); BG���
        )
        ;2010/10/27 YM ADD-E �V�X�C�[�W�B��ٓV��I�^�̑O���ꉡ������荞�݂Ł@BG����
        (T ;�ʏ�
          (setq #bg_en1 (MakeTEIMEN (list #p4 #p2 #p22 #p44))); �ޯ��ް�ޒ��
        )
      );_cond
      (setq #bg_en2 nil)
      (setq #bg_en$ (list #bg_en1 #bg_en2))
    )
    ((equal #BG_Type 0 0.1) ; BG�Ȃ�
      (setq #bg_en$ (list nil nil))
    )
    (T
      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
    )
  );_cond

  ;FG��ʍ�} ��������������������������������������������������������������������

;;; ��I�^���@�Â��ϐ��̐}
;;;     p4ffR *---- p4----+HffR--------------------GffL+--+p2-----*p2ffL
;;;           |     |                                     |       |
;;;    p44ffR *---- +p44  +CffR                    BffL+  +p22----*p22ffL
;;;           |     |                                     |       |
;;;           |     |                                     |       |
;;;   p333ffR *---- +p333 +FffR                    EffL+  +p111---*p111ffL  �O����V�t�g����O������݂��������ʒu
;;;           |     |                                     |       |
;;;     p3ffR |     +p3                                   +p1     *p1ffL�@  ���̊O�`�ʒu
;;;    p33ffR *---- +p33--+DffR--------------------AffL+--+p11----*p11ffL   �O����V�t�g


;;; ��I�^�� 2016/02/24 YM �ϐ��ύX�@�V�����ϐ��̐}
;;;     p4WTL *---- p4----+HFGL-----------------GFGR+--+p2-----*p2WTR
;;;           |     |                                  |       |
;;;    p44WTL *---- +p44  +CFGL                 BFGR+  +p22----*p22WTR
;;;           |     |                                  |       |
;;;           |     |                                  |       |
;;;   p333WTL *---- +p333 +FFGL                 EFGR+  +p111---*p111WTR
;;;           |     |                                  |       |
;;;     p3WTL |     +p3                                +p1     *p1WTR
;;;    p33WTL *---- +p33--+DFGL-----------------AFGR+--+p11----*p11WTR

  (cond
    ((equal #FG_Type 1 0.1) ; �ʏ�Б�
      (cond ;�ϐ��ύX ffL==>WTR ffR==>WTL    [ABCDEFG]ffL==>FGR ffR==>FGL
        ((or (equal #TOP_FLG 2 0.1));������
          (setq #fg_en1 (MakeTEIMEN (list #p2WTR #p4WTL #p33WTL #p11WTR #p111WTR #pFFGL #pCFGL #p22WTR))); �O������ �R�̎�
        )
        ((or (equal #TOP_FLG 3 0.1));�E����
          (setq #fg_en1 (MakeTEIMEN (list #p4WTL #p2WTR #p11WTR #p33WTL #p333WTL #pEFGR #pBFGR #p44WTL))); �O������ �t�R�̎�
        )

        ;2010/10/27 YM ADD-S �V�X�C�[�W�B��ٓV��I�^�̑O���ꉡ������荞��
        ((or (equal #TOP_FLG 4 0.1));�����荶�̂݉�肱�� 2016/02/24 YM MOD
;;;          (setq #fg_en1 (MakeTEIMEN (list #p4ffR #p33ffR #p11ffL #p111ffL #pFffR #pHffR))); �O������
          (setq #fg_en1 (MakeTEIMEN (list #p4WTL #p33WTL #p11WTR #p111WTR #pFFGL #pHFGL))); �O������  �k�̎�
        )
        ((or (equal #TOP_FLG 5 0.1));�E����E�̂݉�肱�� 2016/02/24 YM MOD
;;;          (setq #fg_en1 (MakeTEIMEN (list #p2ffL #p11ffL #p33ffR #p333ffR #pEffL #pGffL))); �O������
          (setq #fg_en1 (MakeTEIMEN (list #p2WTR #p11WTR #p33WTL #p333WTL #pEFGR #pGFGR))); �O������  �t�k�̎�
        )
        ;2010/10/27 YM ADD-E �V�X�C�[�W�B��ٓV��I�^�̑O���ꉡ������荞��

        (T ;�ʏ�
          (setq #fg_en1 (MakeTEIMEN (list #p11 #p33 #p333 #p111)))  ; �O������
        )
      );_cond
      (setq #fg_en2 nil)
    )
    ((equal #FG_Type 2 0.1) ; FG�O��
      (setq #fg_en1 (MakeTEIMEN (list #p11 #p33 #p333 #p111)))  ; �O������
      (setq #fg_en2 (MakeTEIMEN (list #p4 #p2 #p22 #p44))) ; �O���ꗼ��
    )
    ((equal #FG_Type 3 0.1) ; FG�O��E
      (setq #dumPT1 (polar #p111 (angle #p2 #p4) #FG_T))
      (setq #dumPT2 (polar #p22  (angle #p2 #p4) #FG_T))
      (setq #fg_en1 (MakeTEIMEN (list #p4 #p2 #p11 #p33 #p333 #dumPT1 #dumPT2 #p44)))
      (setq #fg_en2 nil)
    )
    ((equal #FG_Type 4 0.1) ; FG�O�㍶
      (setq #dumPT1 (polar #p333 (angle #p4 #p2) #FG_T))
      (setq #dumPT2 (polar #p44  (angle #p4 #p2) #FG_T))
      (setq #fg_en1 (MakeTEIMEN (list #p2 #p4 #p33 #p11 #p111 #dumPT1 #dumPT2 #p22)))
      (setq #fg_en2 nil)
    )
    (T
      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
    )
  );_cond

  (setq #fg_en$ (list #fg_en1 #fg_en2))

;;; ��I�^�� ���ׯėp��23mm(#offset)�����_�ǉ�
;;;     p4ffR *----------- BASE=p4------------------------+p2------------*p2ffL
;;;           |            |                              |              |
;;;    p44ffR *----*CffR-- +p44 +C                    B+  +p22---*BffL---*p22ffL
;;;           |            |                              |              |
;;;           |            |                              |              |
;;;   p333ffR *----*FffR-- +p333+F                    E+  +p111--*EffL---*p111ffL
;;;           |            |                              |              |
;;;     p3ffR |            +p3                            +p1            *p1ffL
;;;    p33ffR *----------- +p33-+D--------------------A+--+p11-----------*p11ffL


;;; ��I�^�� 2016/02/24 YM �ϐ��ύX�@�V�����ϐ��̐}
;;;     p4WTL *---- p4----+HFGL-----------------GFGR+--+p2-----*p2WTR
;;;           |     |                                  |       |
;;;    p44WTL *---- +p44  +CFGL                 BFGR+  +p22----*p22WTR
;;;           |     |                                  |       |
;;;           |     |                                  |       |
;;;   p333WTL *---- +p333 +FFGL                 EFGR+  +p111---*p111WTR
;;;           |     |                                  |       |
;;;     p3WTL |     +p3                                +p1     *p1WTR
;;;    p33WTL *---- +p33--+DFGL-----------------AFGR+--+p11----*p11WTR

  ; ܰ�į�ߒ�� ��������������������������������������������������������������������
  (cond
    ((or (equal #TOP_FLG 2 0.1)(equal #TOP_FLG 4 0.1));�ׯđΖ�(������) 2010/10/27 YM ADD BG����O�����荞�ݒǉ�
      (setq #wt_en (MakeTEIMEN (list #p4WTL #p2WTR #p11WTR #p33WTL)))
      (setq #WT_LEN (distance #p4WTL #p2WTR))
      (setq #WT_base #p4WTL);WT����_
    )
    ((or (equal #TOP_FLG 3 0.1)(equal #TOP_FLG 5 0.1));�ׯđΖ�(�E����) 2010/10/27 YM ADD BG����O�����荞�ݒǉ�
      (setq #wt_en (MakeTEIMEN (list #p4WTL #p2WTR #p11WTR #p33WTL)))
      (setq #WT_LEN (distance #p4WTL #p2WTR))
      (setq #WT_base #p4WTL);WT����_
    )
    (T ;�ʏ�
      (setq #wt_en (MakeTEIMEN (list #p4 #p2 #p11 #p33)))
      (setq #WT_LEN (distance #p4 #p2))
      (setq #WT_base #p4);WT����_
    )
  );_cond

;;;  (setq #WT_LEN (distance #p4 #p2)) ;03/10/14 ��Ɉړ�
  (setq CG_MAG1 #WT_LEN)
  (setq #cut_type "00")
  (if (= CG_Type2Code "D") ; ۰���ނ̌���
    (progn
      ;;; ���� #p4 �̂܂���&outpl_LOW�������T �Ȃ���� nil
      (if (PKSLOWPLCP #p4 &outpl_LOW) ; T or nil
        (setq #cut_type "40")        ; �i��������
      );_if
      (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
        (setq #cut_type "04")        ; �i��������
      );_if
    )
  );_if
  (setq #dep (distance #p11 #p2))
  ;03/10/14 YM ADD WT����_ #WT_base ���ׯđΉ�
  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #WT_base 0))
;;;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p4 0))
  (setq #ret$ (append #ret$ (list #ret)))

  #ret$
);PKMakeTeimenPline_I



;;; 2016/02/16YM MOD �O������݂łȂ��a�f���݂��g��
;;; 2016/02/16YM MOD;;;<HOM>*************************************************************************
;;; 2016/02/16YM MOD;;; <�֐���>    : PKMakeTeimenPline_I
;;; 2016/02/16YM MOD;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬
;;; 2016/02/16YM MOD;;; <�߂�l>    :
;;; 2016/02/16YM MOD;;; <�쐬>      : 00/09/21 YM �W����
;;; 2016/02/16YM MOD;;; <���l>      :
;;; 2016/02/16YM MOD;;;*************************************************************************>MOH<
;;; 2016/02/16YM MOD(defun PKMakeTeimenPline_I (
;;; 2016/02/16YM MOD  &pt$         ; �eWT�O�`�_�� 4,6,8�_�̂�
;;; 2016/02/16YM MOD  &base_new$   ; �ް����޼����   I�̂�
;;; 2016/02/16YM MOD;;;  &lis$        ; WT�g���t���O ; 01/08/27 YM DEL
;;; 2016/02/16YM MOD;;;  &WTInfo      ; WT���(#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S)
;;; 2016/02/16YM MOD  &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
;;; 2016/02/16YM MOD  &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
;;; 2016/02/16YM MOD  &outpl_LOW   ;
;;; 2016/02/16YM MOD  &ZaiCode     ; �ގ��L��
;;; 2016/02/16YM MOD  /
;;; 2016/02/16YM MOD  #BASEPT #BG_EN$ #BG_EN #CUT_TYPE #DEP
;;; 2016/02/16YM MOD  #FG_EN$ #FG_EN #LIS$ #BG_EN1 #BG_EN2 #FG_EN1 #FG_EN2
;;; 2016/02/16YM MOD  #P1 #P11 #P111 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #PT$
;;; 2016/02/16YM MOD  #RET$ #RET #SA #wt_en #WT_LEN #BGFG$
;;; 2016/02/16YM MOD  #BG_S #BG_T #BG_TYPE #FG_S #FG_T #FG_TYPE
;;; 2016/02/16YM MOD  #DUMPT1 #DUMPT2
;;; 2016/02/16YM MOD  #P111FFL #P11FFL #P1FFL #P22FFL #P2FFL #P333FFL #P333FFR #P33FFL #P33FFR #P3FFL
;;; 2016/02/16YM MOD  #P44FFL #P44FFR #P4FFL #P4FFR #PA #PB #PC #PD #PE #PF #TOP_FLG
;;; 2016/02/16YM MOD#P3FFR #PAFFL #PBFFL #PCFFR #PDFFR #PEFFL #PFFFR #WT_BASE
;;; 2016/02/16YM MOD#OFFSET #P111EYEL #P11EYEL #P1EYEL #P22EYEL #P2EYEL #P333EYER #P33EYER #P3EYER 
;;; 2016/02/16YM MOD#P44EYER #P4EYER #PAEYEL #PBEYEL #PCEYER #PDEYER #PEEYEL #PFEYER
;;; 2016/02/16YM MOD#OFFSETL #OFFSETR ;2010/01/08 YM ADD
;;; 2016/02/16YM MOD#PLLL #PRRR       ;2010/11/08 YM ADD
;;; 2016/02/16YM MOD  )
;;; 2016/02/16YM MOD  (setq #pt$ &pt$)
;;; 2016/02/16YM MOD  (setq #BG_T    (nth 3 &WTInfo )) ; BG�̌���
;;; 2016/02/16YM MOD  (setq #FG_T    (nth 5 &WTInfo )) ; FG�̌���
;;; 2016/02/16YM MOD  (setq #FG_S    (nth 6 &WTInfo )) ; �O����V�t�g��
;;; 2016/02/16YM MOD  (setq #TOP_FLG (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;;; 2016/02/16YM MOD  (setq #BG_S    (nth 0 &WTInfo1)) ; �㐂��V�t�g��
;;; 2016/02/16YM MOD  (setq #BG_Type (nth 1 &WTInfo1)) ; BG�L�� 1:���� 0:�Ȃ�
;;; 2016/02/16YM MOD  (setq #FG_Type (nth 2 &WTInfo1)) ; FG���� 1:FG�O�� 2:FG����
;;; 2016/02/16YM MOD  (setq #offsetL  (nth 3 &WTInfo1)) ; �����莞�ݸ��(����)�̾�Ēl
;;; 2016/02/16YM MOD  (setq #offsetR  (nth 4 &WTInfo1)) ; �����莞��ۑ�(�E��)�̾�Ēl
;;; 2016/02/16YM MOD  
;;; 2016/02/16YM MOD;;; ��I�^�� BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
;;; 2016/02/16YM MOD;;;  BASE=p4------------------------+p2   <---BG�w��
;;; 2016/02/16YM MOD;;;  |                              |
;;; 2016/02/16YM MOD;;;  +p44 +C                    B+  +p22  <---BG�O��
;;; 2016/02/16YM MOD;;;  |                              |
;;; 2016/02/16YM MOD;;;  |                              |
;;; 2016/02/16YM MOD;;;  +p333+F                    E+  +p111 <---FG�w��
;;; 2016/02/16YM MOD;;;  |                              |
;;; 2016/02/16YM MOD;;;  +p3                            +p1
;;; 2016/02/16YM MOD;;;  +p33-+D--------------------A+--+p11  <---FG�O��
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;;; �Vۼޯ� �O�`�_��-->��Ű��_ PKGetBaseL6
;;; 2016/02/16YM MOD  (setq #BASEPT (PKGetBaseI4 #pt$ &base_new$)) ; �_��Ƽ����ؽ�(����قƺ�Ű��_�͕K��������v���Ȃ�)
;;; 2016/02/16YM MOD  ;;; �O�`�_������߂�.I�^
;;; 2016/02/16YM MOD  (setq #pt$ (GetPtSeries #BASEPT #pt$)) ; �_�����#BASEPT��擪�Ɏ��v����ɂ���
;;; 2016/02/16YM MOD  (setq #p4 (nth 0 #pt$)) ; #p1,2,3,4 ���Ԓ���
;;; 2016/02/16YM MOD  (setq #p2 (nth 1 #pt$))
;;; 2016/02/16YM MOD  (setq #p1 (nth 2 #pt$))
;;; 2016/02/16YM MOD  (setq #p3 (nth 3 #pt$))
;;; 2016/02/16YM MOD  ;;; WT�g���Ή� �K�v�Ȃ�#p2 #p4�����ߒ���
;;; 2016/02/16YM MOD  ; 02/01/21 YM ���s���g��<0������
;;; 2016/02/16YM MOD;;;02/01/21YM@DEL (if (> #BG_S 0.1)
;;; 2016/02/16YM MOD;;;02/01/21YM@DEL    (progn
;;; 2016/02/16YM MOD      (setq #sa #BG_S)
;;; 2016/02/16YM MOD      (setq #p2 (polar #p2 (angle #p1 #p2) #sa))
;;; 2016/02/16YM MOD      (setq #p4 (polar #p4 (angle #p3 #p4) #sa))
;;; 2016/02/16YM MOD;;;02/01/21YM@DEL    )
;;; 2016/02/16YM MOD;;;02/01/21YM@DEL  );_if
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;;; WT,BG,FG ��ʊO�`�̊e�_�����߂�
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(���ɖ߂�) - S
;;; 2016/02/16YM MOD;;;;;-- 2011/09/30 A.Satoh Mod - S
;;; 2016/02/16YM MOD  (setq #p22  (polar #p2  (angle #p2 #p1) #FG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD  (setq #p44  (polar #p4  (angle #p4 #p3) #FG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #p22  (polar #p2  (angle #p2 #p1) #BG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #p44  (polar #p4  (angle #p4 #p3) #BG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;;-- 2011/09/30 A.Satoh Mod - E
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(���ɖ߂�) - E
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  (setq #p11  (polar #p1  (angle #p2 #p1) #FG_S)) ; WT��ėʕ�
;;; 2016/02/16YM MOD  (setq #p33  (polar #p3  (angle #p4 #p3) #FG_S)) ; WT��ėʕ�
;;; 2016/02/16YM MOD  (setq #p333 (polar #p33 (angle #p3 #p4) #FG_T)) ; FG���ݕ�
;;; 2016/02/16YM MOD  (setq #p111 (polar #p11 (angle #p1 #p2) #FG_T)) ; FG���ݕ�
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;03/09/22 YM ADD ����į���׸ޑΉ�
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(���ɖ߂�) - S
;;; 2016/02/16YM MOD;;;;;;-- 2011/09/30 A.Satoh Mod - S
;;; 2016/02/16YM MOD  (setq #pA (polar #p11  (angle #p2 #p4) #FG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD  (setq #pB (polar #p22  (angle #p2 #p4) #FG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD  (setq #pC (polar #p44  (angle #p4 #p2) #FG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD  (setq #pD (polar #p33  (angle #p4 #p2) #FG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #pA (polar #p11  (angle #p2 #p4) #BG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #pB (polar #p22  (angle #p2 #p4) #BG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #pC (polar #p44  (angle #p4 #p2) #BG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #pD (polar #p33  (angle #p4 #p2) #BG_T)) ; BG���ݕ�==>FG����2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;;-- 2011/09/30 A.Satoh Mod - E
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(���ɖ߂�) - E
;;; 2016/02/16YM MOD  (setq #pE (polar #p111 (angle #p2 #p4) #FG_T)) ; FG���ݕ�
;;; 2016/02/16YM MOD  (setq #pF (polar #p333 (angle #p4 #p2) #FG_T)) ; FG���ݕ�
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;;; ��I�^�� ���ׯėp��23mm�����_�ǉ�
;;; 2016/02/16YM MOD;;;     p4ffR *---- BASE=p4------------------------+p2-----*p2ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;    p44ffR *---- +p44 +C                    B+  +p22----*p22ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;   p333ffR *---- +p333+F                    E+  +p111---*p111ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;     p3ffR |     +p3                            +p1     *p1ffL
;;; 2016/02/16YM MOD;;;    p33ffR *---- +p33-+D--------------------A+--+p11----*p11ffL
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;(nth 11 CG_GLOBAL$)����
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;2010/01/07 YM MOD
;;; 2016/02/16YM MOD  (if (= nil CG_GLOBAL$)
;;; 2016/02/16YM MOD    (progn ;KPCAD�̏ꍇ
;;; 2016/02/16YM MOD;-- 2011/08/25 A.Satoh Mod - S
;;; 2016/02/16YM MOD;      (setq #offsetR 0 #offsetL 0)
;;; 2016/02/16YM MOD;      (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD;      (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD;      (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD;      (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD;      (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD;
;;; 2016/02/16YM MOD;      (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD;      (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD;      (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD;      (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD;      (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD      (if (= "L" (nth 9 &WTInfo))
;;; 2016/02/16YM MOD        (progn ;������
;;; 2016/02/16YM MOD          (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD          (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      )
;;; 2016/02/16YM MOD      (if (= "R" (nth 9 &WTInfo))
;;; 2016/02/16YM MOD        (progn ;�E����
;;; 2016/02/16YM MOD          (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD          (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      )
;;; 2016/02/16YM MOD      (if (= "Z" (nth 9 &WTInfo))
;;; 2016/02/16YM MOD        (progn
;;; 2016/02/16YM MOD          (setq #offsetR 0 #offsetL 0)
;;; 2016/02/16YM MOD          (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD          (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      )
;;; 2016/02/16YM MOD;-- 2011/08/25 A.Satoh Mod - E
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    (progn ;������}�̏ꍇ
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD      (if (= "L" (nth 11 CG_GLOBAL$))
;;; 2016/02/16YM MOD        (progn ;������
;;; 2016/02/16YM MOD          (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD          (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        (progn ;�E����
;;; 2016/02/16YM MOD          (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD          (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetL));�������ٕ�(��ۑ�)
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD          (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD          (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetR));�������ٕ�(�ݸ��)
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      );_if
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD  );_if
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;03/09/22 YM ADD ����į���׸ޑΉ�
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(���ɖ߂�) - S
;;; 2016/02/16YM MOD;;;;;;-- 2011/09/30 A.Satoh Mod - S
;;; 2016/02/16YM MOD  (setq #pAffL (polar #p11ffL  (angle #p2 #p4) #FG_T)) ; FG���ݕ� 2010/10/27 YM MOD BG==>FG
;;; 2016/02/16YM MOD  (setq #pBffL (polar #p22ffL  (angle #p2 #p4) #FG_T)) ; FG���ݕ� 2010/10/27 YM MOD BG==>FG ���g�p
;;; 2016/02/16YM MOD  (setq #pCffR (polar #p44ffR  (angle #p4 #p2) #FG_T)) ; FG���ݕ� 2010/10/27 YM MOD BG==>FG ���g�p
;;; 2016/02/16YM MOD  (setq #pDffR (polar #p33ffR  (angle #p4 #p2) #FG_T)) ; FG���ݕ� 2010/10/27 YM MOD BG==>FG
;;; 2016/02/16YM MOD;;;;;  (setq #pAffL (polar #p11ffL  (angle #p2 #p4) #BG_T)) ; FG���ݕ� 2010/10/27 YM MOD BG==>FG
;;; 2016/02/16YM MOD;;;;;  (setq #pBffL (polar #p22ffL  (angle #p2 #p4) #BG_T)) ; FG���ݕ� 2010/10/27 YM MOD BG==>FG ���g�p
;;; 2016/02/16YM MOD;;;;;  (setq #pCffR (polar #p44ffR  (angle #p4 #p2) #BG_T)) ; FG���ݕ� 2010/10/27 YM MOD BG==>FG ���g�p
;;; 2016/02/16YM MOD;;;;;  (setq #pDffR (polar #p33ffR  (angle #p4 #p2) #BG_T)) ; FG���ݕ� 2010/10/27 YM MOD BG==>FG
;;; 2016/02/16YM MOD;;;;;;-- 2011/09/30 A.Satoh Mod - E
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(���ɖ߂�) - E
;;; 2016/02/16YM MOD  (setq #pEffL (polar #p111ffL (angle #p2 #p4) #FG_T)) ; FG���ݕ� ���g�p
;;; 2016/02/16YM MOD  (setq #pFffR (polar #p333ffR (angle #p4 #p2) #FG_T)) ; FG���ݕ� ���g�p
;;; 2016/02/16YM MOD  ;2010/10/27 YM ADD-S �V�X�C�[�W�B��ٓV��I�^�̑O���ꉡ������荞��
;;; 2016/02/16YM MOD  (setq #pLLL (polar #p4ffR    (angle #p4 #p2) #FG_T)) ; FG���ݕ� ���g�p
;;; 2016/02/16YM MOD  (setq #pRRR (polar #p2ffL    (angle #p2 #p4) #FG_T)) ; FG���ݕ� ���g�p
;;; 2016/02/16YM MOD  ;2010/10/27 YM ADD-E �V�X�C�[�W�B��ٓV��I�^�̑O���ꉡ������荞��
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;;; ��I�^�� ���ׯėp��23mm�����_�ǉ�
;;; 2016/02/16YM MOD;;;     p4ffR *---- BASE=p4------------------------+p2-----*p2ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;    p44ffR *---- +p44 +C                    B+  +p22----*p22ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;   p333ffR *---- +p333+F                    E+  +p111---*p111ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;     p3ffR |     +p3                            +p1     *p1ffL
;;; 2016/02/16YM MOD;;;    p33ffR *---- +p33-+D--------------------A+--+p11----*p11ffL
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;BG��ʍ�}
;;; 2016/02/16YM MOD  (cond
;;; 2016/02/16YM MOD    ((equal #BG_Type 1 0.1) ; BG����
;;; 2016/02/16YM MOD      (cond       
;;; 2016/02/16YM MOD        ((equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;;; 2016/02/16YM MOD          (setq #bg_en1 (MakeTEIMEN (list #p4 #p2 #p11 #pA #pB #pC #pD #p33))); �ޯ��ް�ޒ��
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG  2 0.1)(equal #TOP_FLG  3 0.1));�ׯđΖ�
;;; 2016/02/16YM MOD          (setq #bg_en1 nil); �ޯ��ް�ނȂ�
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ;2010/10/27 YM ADD-S �V�X�C�[�W�B��ٓV��I�^�̑O���ꉡ������荞�݁@BG����
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG 4 0.1)(equal #TOP_FLG 5 0.1));���E���苤��
;;; 2016/02/16YM MOD          (setq #bg_en1 (MakeTEIMEN (list #p4ffR #p2ffL #p22ffL #p44ffR))); BG���
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ;2010/10/27 YM ADD-E �V�X�C�[�W�B��ٓV��I�^�̑O���ꉡ������荞�݂Ł@BG����
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD        (T ;�ʏ�
;;; 2016/02/16YM MOD          (setq #bg_en1 (MakeTEIMEN (list #p4 #p2 #p22 #p44))); �ޯ��ް�ޒ��
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      );_cond
;;; 2016/02/16YM MOD      (setq #bg_en2 nil)
;;; 2016/02/16YM MOD      (setq #bg_en$ (list #bg_en1 #bg_en2))
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    ((equal #BG_Type 0 0.1) ; BG�Ȃ�
;;; 2016/02/16YM MOD      (setq #bg_en$ (list nil nil))
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    (T
;;; 2016/02/16YM MOD      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD  );_cond
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;FG��ʍ�}
;;; 2016/02/16YM MOD;;; ��I�^�� ���ׯėp��23mm(#offset)�����_�ǉ�
;;; 2016/02/16YM MOD;;;     p4ffR *----@LLL--- BASE=p4------------------------+p2----@RRR----*p2ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;    p44ffR *----*CffR-- +p44 +C                    B+  +p22---*BffL---*p22ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;   p333ffR *----*FffR-- +p333+F                    E+  +p111--*EffL---*p111ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;     p3ffR |            +p3                            +p1            *p1ffL
;;; 2016/02/16YM MOD;;;    p33ffR *----------- +p33-+D--------------------A+--+p11-----------*p11ffL
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  (cond
;;; 2016/02/16YM MOD    ((equal #FG_Type 1 0.1) ; �ʏ�Б�
;;; 2016/02/16YM MOD      (cond
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG 2 0.1));������
;;; 2016/02/16YM MOD          (setq #fg_en1 (MakeTEIMEN (list #p2ffL #p4ffR #p33ffR #p11ffL #p111ffL #pFffR #pCffR #p22ffL))); �O������
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG 3 0.1));�E����
;;; 2016/02/16YM MOD          (setq #fg_en1 (MakeTEIMEN (list #p4ffR #p2ffL #p11ffL #p33ffR #p333ffR #pEffL #pBffL #p44ffR))); �O������
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD        ;2010/10/27 YM ADD-S �V�X�C�[�W�B��ٓV��I�^�̑O���ꉡ������荞��
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG 4 0.1));������
;;; 2016/02/16YM MOD          (setq #fg_en1 (MakeTEIMEN (list #p4ffR #p33ffR #p11ffL #p111ffL #pFffR #pLLL))); �O������
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG 5 0.1));�E����
;;; 2016/02/16YM MOD          (setq #fg_en1 (MakeTEIMEN (list #p2ffL #p11ffL #p33ffR #p333ffR #pEffL #pRRR))); �O������
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ;2010/10/27 YM ADD-E �V�X�C�[�W�B��ٓV��I�^�̑O���ꉡ������荞��
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD        (T ;�ʏ�
;;; 2016/02/16YM MOD          (setq #fg_en1 (MakeTEIMEN (list #p11 #p33 #p333 #p111)))  ; �O������
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      );_cond
;;; 2016/02/16YM MOD      (setq #fg_en2 nil)
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    ((equal #FG_Type 2 0.1) ; FG�O��
;;; 2016/02/16YM MOD      (setq #fg_en1 (MakeTEIMEN (list #p11 #p33 #p333 #p111)))  ; �O������
;;; 2016/02/16YM MOD      (setq #fg_en2 (MakeTEIMEN (list #p4 #p2 #p22 #p44))) ; �O���ꗼ��
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    ((equal #FG_Type 3 0.1) ; FG�O��E
;;; 2016/02/16YM MOD      (setq #dumPT1 (polar #p111 (angle #p2 #p4) #FG_T))
;;; 2016/02/16YM MOD      (setq #dumPT2 (polar #p22  (angle #p2 #p4) #FG_T))
;;; 2016/02/16YM MOD      (setq #fg_en1 (MakeTEIMEN (list #p4 #p2 #p11 #p33 #p333 #dumPT1 #dumPT2 #p44)))
;;; 2016/02/16YM MOD      (setq #fg_en2 nil)
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    ((equal #FG_Type 4 0.1) ; FG�O�㍶
;;; 2016/02/16YM MOD      (setq #dumPT1 (polar #p333 (angle #p4 #p2) #FG_T))
;;; 2016/02/16YM MOD      (setq #dumPT2 (polar #p44  (angle #p4 #p2) #FG_T))
;;; 2016/02/16YM MOD      (setq #fg_en1 (MakeTEIMEN (list #p2 #p4 #p33 #p11 #p111 #dumPT1 #dumPT2 #p22)))
;;; 2016/02/16YM MOD      (setq #fg_en2 nil)
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    (T
;;; 2016/02/16YM MOD      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD  );_cond
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  (setq #fg_en$ (list #fg_en1 #fg_en2))
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;;; ��I�^�� ���ׯėp��23mm(#offset)�����_�ǉ�
;;; 2016/02/16YM MOD;;;     p4ffR *----------- BASE=p4------------------------+p2------------*p2ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;    p44ffR *----*CffR-- +p44 +C                    B+  +p22---*BffL---*p22ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;   p333ffR *----*FffR-- +p333+F                    E+  +p111--*EffL---*p111ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;     p3ffR |            +p3                            +p1            *p1ffL
;;; 2016/02/16YM MOD;;;    p33ffR *----------- +p33-+D--------------------A+--+p11-----------*p11ffL
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ; ܰ�į�ߒ��
;;; 2016/02/16YM MOD  (cond
;;; 2016/02/16YM MOD    ((or (equal #TOP_FLG 2 0.1)(equal #TOP_FLG 4 0.1));�ׯđΖ�(������) 2010/10/27 YM ADD BG����O�����荞�ݒǉ�
;;; 2016/02/16YM MOD      (setq #wt_en (MakeTEIMEN (list #p4ffR #p2ffL #p11ffL #p33ffR)))
;;; 2016/02/16YM MOD      (setq #WT_LEN (distance #p4ffR #p2ffL))
;;; 2016/02/16YM MOD      (setq #WT_base #p4ffR);WT����_
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    ((or (equal #TOP_FLG 3 0.1)(equal #TOP_FLG 5 0.1));�ׯđΖ�(�E����) 2010/10/27 YM ADD BG����O�����荞�ݒǉ�
;;; 2016/02/16YM MOD      (setq #wt_en (MakeTEIMEN (list #p4ffR #p2ffL #p11ffL #p33ffR)))
;;; 2016/02/16YM MOD      (setq #WT_LEN (distance #p4ffR #p2ffL))
;;; 2016/02/16YM MOD      (setq #WT_base #p4ffR);WT����_
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    (T ;�ʏ�
;;; 2016/02/16YM MOD      (setq #wt_en (MakeTEIMEN (list #p4 #p2 #p11 #p33)))
;;; 2016/02/16YM MOD      (setq #WT_LEN (distance #p4 #p2))
;;; 2016/02/16YM MOD      (setq #WT_base #p4);WT����_
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD  );_cond
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;;;  (setq #WT_LEN (distance #p4 #p2)) ;03/10/14 ��Ɉړ�
;;; 2016/02/16YM MOD  (setq CG_MAG1 #WT_LEN)
;;; 2016/02/16YM MOD  (setq #cut_type "00")
;;; 2016/02/16YM MOD  (if (= CG_Type2Code "D") ; ۰���ނ̌���
;;; 2016/02/16YM MOD    (progn
;;; 2016/02/16YM MOD      ;;; ���� #p4 �̂܂���&outpl_LOW�������T �Ȃ���� nil
;;; 2016/02/16YM MOD      (if (PKSLOWPLCP #p4 &outpl_LOW) ; T or nil
;;; 2016/02/16YM MOD        (setq #cut_type "40")        ; �i��������
;;; 2016/02/16YM MOD      );_if
;;; 2016/02/16YM MOD      (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;;; 2016/02/16YM MOD        (setq #cut_type "04")        ; �i��������
;;; 2016/02/16YM MOD      );_if
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD  );_if
;;; 2016/02/16YM MOD  (setq #dep (distance #p11 #p2))
;;; 2016/02/16YM MOD  ;03/10/14 YM ADD WT����_ #WT_base ���ׯđΉ�
;;; 2016/02/16YM MOD  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #WT_base 0))
;;; 2016/02/16YM MOD;;;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p4 0))
;;; 2016/02/16YM MOD  (setq #ret$ (append #ret$ (list #ret)))
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  #ret$
;;; 2016/02/16YM MOD);PKMakeTeimenPline_I



;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMakeTeimenPline_L
;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬
;;; <�߂�l>    :
;;; <�쐬>      : 00/09/26 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKMakeTeimenPline_L (
  &pt$         ; �eWT�O�`�_�� 4,6,8�_�̂�
;;;  &lis$        ; WT�g���t���O ; 01/08/27 YM DEL
  &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
  &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
  &WTInfo2     ; WT���2  (#BG_S2 #BG_Type2 #FG_Type2)
  &WTInfo3     ; WT���3  (#BG_S3 #BG_Type3 #FG_Type3)
  &CutId       ; ���ID 0:�Ȃ� 1:�΂�H,W 2:�����w��  L,U�̂�
  &outpl_LOW   ;
  &ZaiCode     ; �ގ��L��
  /
  #BASEPT #BGFG_INFO #BG_S1 #BG_S2 #BG_S3 #BG_T #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #ddd1 #ddd2
  #FG_S #FG_T #FG_TYPE1 #FG_TYPE2 #FG_TYPE3 #LIS$
  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #POINT$ #PT$ #RET$
  #BG_SEP #MSG #TOP_FLG
  )
  (setq #pt$ &pt$)

  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�

	;2014/07/09 YM ADD
  (setq #offset  (nth 3 &WTInfo1)) ; �ݸ����荞�ݵ̾�Ēl


  ;03/09/22 YM ADD ����į�ߑΉ� FG�O�㍶(�ި��۱)
  (if (or (equal #TOP_FLG 2 0.1)(equal #TOP_FLG 3 0.1)(equal #TOP_FLG 22 0.1)(equal #TOP_FLG 33 0.1))
    (progn
      ;2008/08/18 YM ADD �޲�۸ނ��\�����ꂽ�܂܂ɂȂ�
      (cond
        ((= CG_AUTOMODE 0)
          (CFAlertMsg "���̔z������ׯēV�ɑΉ����Ă��܂���")
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog "���̔z������ׯēV�ɑΉ����Ă��܂���")
          (quit)
        )
      );_cond
    )
  );_if

  (setq #BG_S1    (nth 0 &WTInfo1)) ; �㐂��V�t�g��
  (setq #BG_Type1 (nth 1 &WTInfo1)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #FG_Type1 (nth 2 &WTInfo1)) ; FG���� 1:�Б� 2:����

  (setq #BG_S2    (nth 0 &WTInfo2)) ; �㐂��V�t�g��
  (setq #BG_Type2 (nth 1 &WTInfo2)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #FG_Type2 (nth 2 &WTInfo2)) ; FG���� 1:�Б� 2:����

  (setq #BG_S3    (nth 0 &WTInfo3)) ; �㐂��V�t�g��
  (setq #BG_Type3 (nth 1 &WTInfo3)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #FG_Type3 (nth 2 &WTInfo3)) ; FG���� 1:�Б� 2:����

;;; ��L�^��            x11  x1
;;; p1+---end1---------*---*---------------------+p2   <---BG�w��
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|---------------------+p22  <---BG�O��
;;;   |   |             |   |                     |
;;;   |   |             |   |  �ݸ��              | x11,x22�Ͷ�Ďw�������ɂ��
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333 <---FG�w��
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44------------------+p33  <---FG�O��
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ��ۑ�   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55

;;; �Vۼޯ� �O�`�_��-->��Ű��_ PKGetBaseL6
  (setq #BASEPT (PKGetBaseL6 #pt$))
  (if (= nil #BASEPT)
    (progn
      ;2008/08/20 YM MOD-S CAD���ް�ŕ\�����o�Ȃ��悤�ɂ���
      (setq #msg "��Ű��_���擾�ł��܂���ł���")      
      (cond
        ((= CG_AUTOMODE 0)
          (CMN_OutMsg #msg)
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog #msg)
          (quit)
        )
      );_cond
      ;2008/08/20 YM MOD-S CAD���ް�ŕ\�����o�Ȃ��悤�ɂ���
    )
  );_if
  (setq #pt$ (GetPtSeries #BASEPT #pt$)) ; �O�`�_��&pt$��#BASEPT��擪�Ɏ��v����ɂ���
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))

  ; �x���ǉ� 01/08/24 YM ADD-S
  ; ���^��Ű���ޒP�Ƃł͔z�u�s��
  (if (or (<= (distance #p3 #p4) (+ #FG_S 0.1))(<= (distance #p4 #p5) (+ #FG_S 0.1)))
    (progn
      (setq #msg "���̃R�[�i�[�L���r�ł͑O���ꂪ�쐬�ł��Ȃ����߁A�P�ƂŃ��[�N�g�b�v���쐬�ł��܂���")
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_if
  ; �x���ǉ� 01/08/24 YM ADD-E

  ;;; U�^,L�`��(U�^�i����L�z��2�ł���ꍇ)�̏ꍇ�ź�Ű��_2���܂ޏꍇ
  (if (and (= CG_W2CODE "U") (> (distance CG_BASEPT1 #p1) (distance CG_BASEPT2 #p1)))
    (progn
      (setq #BG_S1 #BG_S2)
      (setq #BG_Type1 #BG_Type2) ; BG�L�� 1:���� 0:�Ȃ�
      (setq #FG_Type1 #FG_Type2) ; FG���� 1:�Б� 2:����

      (setq #BG_S2 #BG_S3)
      (setq #BG_Type2 #BG_Type3) ; BG�L�� 1:���� 0:�Ȃ�
      (setq #FG_Type2 #FG_Type3) ; FG���� 1:�Б� 2:����
    )
  );_if

  ;;; WT�g���Ή� �K�v�Ȃ�#p2 #p4�����ߒ���(L�`��)
  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL  (if (> #BG_S1 0.1) ; �ݸ��
;;;02/01/21YM@DEL   (progn
      (setq #p2 (polar #p2 (angle #p3 #p2) #BG_S1))
      (setq #p1 (polar #p1 (angle #p6 #p1) #BG_S1))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL  (if (> #BG_S2 0.1) ; ��ۑ�
;;;02/01/21YM@DEL   (progn
      (setq #p6 (polar #p6 (angle #p5 #p6) #BG_S2))
      (setq #p1 (polar #p1 (angle #p2 #p1) #BG_S2))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if
  (setq #p22  (polar #p2   (angle #p2 #p3) #BG_T)) ; BG���ݕ�
  (setq #p66  (polar #p6   (angle #p6 #p5) #BG_T)) ; BG���ݕ�
  (setq #ddd1 (polar #p1   (angle #p2 #p3) #BG_T)) ; BG���ݕ�
  (setq #ddd2 (polar #p1   (angle #p6 #p5) #BG_T)) ; BG���ݕ�
  (setq #p11  (inters #p22 #ddd1 #p66 #ddd2 nil))
  (setq #p33  (polar #p3   (angle #p2 #p3) #FG_S)) ; WT��ėʕ�
  (setq #p55  (polar #p5   (angle #p6 #p5) #FG_S)) ; WT��ėʕ�
  (setq #ddd1 (polar #p4   (angle #p2 #p3) #FG_S)) ; WT��ėʕ�
  (setq #ddd2 (polar #p4   (angle #p6 #p5) #FG_S)) ; WT��ėʕ�
  (setq #p44  (inters #p33 #ddd1 #p55 #ddd2 nil))

  (setq #p333 (polar #p33  (angle #p3 #p2) #FG_T)) ; FG���ݕ�
  (setq #p555 (polar #p55  (angle #p5 #p6) #FG_T)) ; FG���ݕ�
  (setq #ddd1 (polar #p44  (angle #p3 #p2) #FG_T)) ; FG���ݕ�
  (setq #ddd2 (polar #p44  (angle #p5 #p6) #FG_T)) ; FG���ݕ�
  (setq #p444 (inters #p333 #ddd1 #p555 #ddd2 nil))

  (setq #point$ (list #p1 #p2 #p3 #p4 #p5 #p6 #p11 #p22 #p33 #p44 #p55 #p66 #p333 #p444 #p555))
  (setq #BGFG_Info (list #BG_Type1 #FG_Type1 #BG_Type2 #FG_Type2 #BG_SEP #TOP_FLG));03/09/22 YM #TOP_FLG ADD

  (setq CG_MAG1 (distance #p1 #p2)) ; ����ݸ�ʒu�ɖ��֌W
  (setq CG_MAG2 (distance #p1 #p6)) ; ����ݸ�ʒu�ɖ��֌W
;-- 2011/07/14 A.Satoh Mod - S
  (setq #ret$ (PKLcut0 &WTInfo &WTInfo1 &outpl_LOW #point$ #BGFG_Info))
;  (cond
;    ((= &CutId 0) ; ��ĂȂ� L�^ ���ڽ
;      (setq #ret$ (PKLcut0 &WTInfo          &outpl_LOW #point$ #BGFG_Info))
;    )
;    ((= &CutId 1) ; �΂߶��
;      (setq #ret$ (PKLcut1 &WTInfo &ZaiCode &outpl_LOW #point$ #BGFG_Info))
;    )
;    ((= &CutId 2) ; �������
;      (setq #ret$ (PKLcut2 &WTInfo &ZaiCode &outpl_LOW #point$ #BGFG_Info))
;    )
;  );_cond
;-- 2011/07/14 A.Satoh Mod - E
  #ret$
);PKMakeTeimenPline_L

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMakeTeimenPline_L_ALL
;;; <�����T�v>  : �i�������܂ޑS��WT�O�`�_����۰��قɾ��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/08/24 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKMakeTeimenPline_L_ALL (
  &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
  &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
  &WTInfo2     ; WT���2  (#BG_S2 #BG_Type2 #FG_Type2)
  /
  #BASEPT #BG_S1 #BG_S2 #DDD1 #DDD2 #FG_S #P1 #P2 #P3 #P33 #P4 #P44 #P5 #P55 #P6 #PT$ #MSG
  )
  (setq #pt$ CG_GAIKEI)
  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
  (setq #BG_S1    (nth 0 &WTInfo1)) ; �㐂��V�t�g��
  (setq #BG_S2    (nth 0 &WTInfo2)) ; �㐂��V�t�g��

;;; ��L�^��            x11  x1
;;; p1+---end1---------*---*---------------------+p2   <---BG�w��
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|---------------------+p22  <---BG�O��
;;;   |   |             |   |                     |
;;;   |   |             |   |  �ݸ��              | x11,x22�Ͷ�Ďw�������ɂ��
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333 <---FG�w��
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44------------------+p33  <---FG�O��
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ��ۑ�   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55

;;; �Vۼޯ� �O�`�_��-->��Ű��_ PKGetBaseL6
  (setq #BASEPT (PKGetBaseL6 #pt$))
  (if (= nil #BASEPT)
    (progn
      ;2008/08/20 YM MOD-S CAD���ް�ŕ\�����o�Ȃ��悤�ɂ���
      (setq #msg "��Ű��_���擾�ł��܂���ł���")      
      (cond
        ((= CG_AUTOMODE 0)
          (CMN_OutMsg #msg)
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog #msg)
          (quit)
        )
      );_cond
      ;2008/08/20 YM MOD-S CAD���ް�ŕ\�����o�Ȃ��悤�ɂ���
    )
  );_if
  (setq #pt$ (GetPtSeries #BASEPT #pt$)) ; �O�`�_��&pt$��#BASEPT��擪�Ɏ��v����ɂ���
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))

  ; �x���ǉ� 01/08/24 YM ADD-S
  ; ���^��Ű���ޒP�Ƃł͔z�u�s��
  (if (or (<= (distance #p3 #p4) (+ #FG_S 0.1))(<= (distance #p4 #p5) (+ #FG_S 0.1)))
    (progn
      (setq #msg "\n���̃R�[�i�[�L���r�ł͑O���ꂪ�쐬�ł��Ȃ����߁A�P�ƂŃ��[�N�g�b�v���쐬�ł��܂���")
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_if
  ; �x���ǉ� 01/08/24 YM ADD-E

  ;;; WT�g���Ή� �K�v�Ȃ�#p2 #p4�����ߒ���(L�`��)
  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL  (if (> #BG_S1 0.1) ; �ݸ��
;;;02/01/21YM@DEL   (progn
      (setq #p2 (polar #p2 (angle #p3 #p2) #BG_S1))
      (setq #p1 (polar #p1 (angle #p6 #p1) #BG_S1))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL  (if (> #BG_S2 0.1) ; ��ۑ�
;;;02/01/21YM@DEL   (progn
      (setq #p6 (polar #p6 (angle #p5 #p6) #BG_S2))
      (setq #p1 (polar #p1 (angle #p2 #p1) #BG_S2))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  (setq #p33  (polar #p3   (angle #p2 #p3) #FG_S)) ; WT��ėʕ�
  (setq #p55  (polar #p5   (angle #p6 #p5) #FG_S)) ; WT��ėʕ�
  (setq #ddd1 (polar #p4   (angle #p2 #p3) #FG_S)) ; WT��ėʕ�
  (setq #ddd2 (polar #p4   (angle #p6 #p5) #FG_S)) ; WT��ėʕ�
  (setq #p44  (inters #p33 #ddd1 #p55 #ddd2 nil))

  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (setq CG_GAIKEI (list #p1 #p2 #p33 #p44 #p55 #p6))
  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (princ)
);PKMakeTeimenPline_L_ALL

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKLcut0
;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 L�^��ĂȂ�(ID=0)
;;; <�߂�l>    :
;;; <�쐬>      : 00/09/26 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKLcut0 (
  &WTInfo
	&WTInfo1 ;2014/07/09 YM ADD
  &outpl_LOW
  &point$
  &BGFG_Info
  /
  #BG_EN$ #BG_EN1 #BG_EN2 #CUT_TYPE #DEP1 #DEP2 #FG_EN$ #FG_EN1 #FG_EN2
  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66
  #RET$ #RET #WTLEN$ #wt_en #WT_LEN1 #WT_LEN2 #BG_TYPE1 #BG_TYPE2 #FG_TYPE1 #FG_TYPE2
  #end1 #end2
  #BG_SEP #BG_T #DUMPT1 #DUMPT2 #FG_S #FG_T
#PA #PB #PC #PD #TOP_FLG ;03/10/14 YM ADD
;-- 2011/06/28 A.Satoh Add - S
  #DL
;-- 2011/06/28 A.Satoh Add - S
#OFFSET #P22FF #P2FF #P333FF #P33FF #P3FF #P555FF #P55FF #P5FF #P66FF #P6FF ;2014/07/089 YM ADD
  )
  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�

	;2014/07/09 YM ADD
;2017/06/12 YM DEL
;;;  (setq #offset  (nth 3 &WTInfo1)) ; �ݸ����荞�ݵ̾�Ēl


;�������@2017/06/12 YM ADD-S I�^�����߰
;;;  (setq #BG_S    (nth 0 &WTInfo1)) ; �㐂��V�t�g��
;;;
;;;  (setq #BG_Type (nth 1 &WTInfo1)) ; BG�L�� 1:���� 0:�Ȃ�
;;;  (setq #FG_Type (nth 2 &WTInfo1)) ; FG���� 1:FG�O�� 2:FG����

  (setq #offsetL  (nth 3 &WTInfo1)) ; �����莞�ݸ��(����)�̾�Ēl
  (setq #offsetR  (nth 4 &WTInfo1)) ; �����莞��ۑ�(�E��)�̾�Ēl
;�������@2017/06/12 YM ADD-E I�^�����߰


;;; ��L�^��            x11  x1
;;; p1+---end1---------*---*---------------------+p2   <---BG�w��
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|-----------------B+--+p22  <---BG�O��
;;;   |   |             |   |                     |
;;;   |   |             |   |  �ݸ��              | x11,x22�Ͷ�Ďw�������ɂ��
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333 <---FG�w��
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44--------------A+--+p33  <---FG�O��
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ��ۑ�   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   +C    |           +D
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55

  (setq #p1 (nth 0 &point$))
  (setq #p2 (nth 1 &point$))
  (setq #p3 (nth 2 &point$))
  (setq #p4 (nth 3 &point$))
  (setq #p5 (nth 4 &point$))
  (setq #p6 (nth 5 &point$))

  (setq #p11 (nth  6 &point$))
  (setq #p22 (nth  7 &point$))
  (setq #p33 (nth  8 &point$))
  (setq #p44 (nth  9 &point$))
  (setq #p55 (nth 10 &point$))
  (setq #p66 (nth 11 &point$))

  (setq #p333 (nth 12 &point$))
  (setq #p444 (nth 13 &point$))
  (setq #p555 (nth 14 &point$))
  (setq #end1 (inters #p11 #p66 #p2 #p1 nil))
  (setq #end2 (inters #p11 #p22 #p1 #p6 nil))

  ;03/09/22 YM ADD ����į���׸ޑΉ�
  ; BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
  (setq #pC  (polar #p66  (angle #p6 #p1) #BG_T)) ; BG���ݕ�
  (setq #pD  (polar #p55  (angle #p6 #p1) #BG_T)) ; BG���ݕ�

  (setq #BG_Type1 (nth 0 &BGFG_Info)); 1:���� 0:�Ȃ�
  (setq #FG_Type1 (nth 1 &BGFG_Info)); 1:�Б� 2:����

	;�������@2017/06/12 YM ADD-S
          (setq #p2ff   (polar #p2   (angle #p1 #p2) #offsetR))
          (setq #p22ff  (polar #p22  (angle #p1 #p2) #offsetR))
          (setq #p333ff (polar #p333 (angle #p1 #p2) #offsetR))
          (setq #p3ff   (polar #p3   (angle #p1 #p2) #offsetR))
          (setq #p33ff  (polar #p33  (angle #p1 #p2) #offsetR))

          (setq #p6ff   (polar #p6   (angle #p1 #p6) #offsetL))
          (setq #p66ff  (polar #p66  (angle #p1 #p6) #offsetL))
          (setq #p555ff (polar #p555 (angle #p1 #p6) #offsetL))
          (setq #p5ff   (polar #p5   (angle #p1 #p6) #offsetL))
          (setq #p55ff  (polar #p55  (angle #p1 #p6) #offsetL))
	;�������@2017/06/12 YM ADD-E

;;;2017/06/21YM@DEL	;2014/07/09 YM ADD-S
;;;2017/06/21YM@DEL          (setq #p2ff   (polar #p2   (angle #p1 #p2) #offset))
;;;2017/06/21YM@DEL          (setq #p22ff  (polar #p22  (angle #p1 #p2) #offset))
;;;2017/06/21YM@DEL          (setq #p333ff (polar #p333 (angle #p1 #p2) #offset))
;;;2017/06/21YM@DEL          (setq #p3ff   (polar #p3   (angle #p1 #p2) #offset))
;;;2017/06/21YM@DEL          (setq #p33ff  (polar #p33  (angle #p1 #p2) #offset))
;;;2017/06/21YM@DEL
;;;2017/06/21YM@DEL          (setq #p6ff   (polar #p6   (angle #p1 #p6) #offset))
;;;2017/06/21YM@DEL          (setq #p66ff  (polar #p66  (angle #p1 #p6) #offset))
;;;2017/06/21YM@DEL          (setq #p555ff (polar #p555 (angle #p1 #p6) #offset))
;;;2017/06/21YM@DEL          (setq #p5ff   (polar #p5   (angle #p1 #p6) #offset))
;;;2017/06/21YM@DEL          (setq #p55ff  (polar #p55  (angle #p1 #p6) #offset))
;;;2017/06/21YM@DEL	;2014/07/09 YM ADD-E


;-- 2011/08/25 A.Satoh Mod - S
;;;01/06/25YM@  (setq #BG_Type2 (nth 2 &BGFG_Info)); 1:���� 0:�Ȃ�
;;;01/06/25YM@  (setq #FG_Type2 (nth 3 &BGFG_Info)); 1:�Б� 2:����
;
;  ;BG��ʍ�}
;  (cond
;    ((equal #BG_Type1 1 0.1)
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11 #pC #pD #p55 #p6))) ; �ޯ��ް�ނ���
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p66 #p6))) ; �ޯ��ް�ނ���
;      );_if
;    )
;    ((equal #BG_Type1 0 0.1)                                        ; �ޯ��ް�ނȂ�
;      (setq #bg_en1 nil)
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  ;FG��ʍ�}
;  (cond
;    ((equal #FG_Type1 1 0.1)                                        ; �ʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p555 #p444 #p333))) ; �O������ؽ� �S��
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type1 2 0.1)
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p555 #p444 #p333))) ; �O������ؽ� �S��
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p66 #p6))) ; �O����O��
;    )
;    ((equal #FG_Type1 3 0.1) ; FG�O��E
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p6 #p1 #p2 #p33 #p44 #p55 #p555 #p444 #dumPT1 #dumPT2 #p11 #p66)))
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type1 4 0.1) ; FG�O�㍶
;      (setq #dumPT1 (polar #p555 (angle #p6 #p1) #FG_T))
;      (setq #dumPT2 (polar #p66  (angle #p6 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p2 #p1 #p6 #p55 #p44 #p33 #p333 #p444 #dumPT1 #dumPT2 #p11 #p22)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
  (setq #BG_Type2 (nth 2 &BGFG_Info)); 1:���� 0:�Ȃ�
  (setq #FG_Type2 (nth 3 &BGFG_Info)); 1:�Б� 2:����


;;; ��L�^��            x11  x1
;;; p1+---end1---------*---*---------------------+p2   --- #p2ff    <---BG�w��
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|-----------------B+--+p22 --- #p22ff   <---BG�O��
;;;   |   |             |   |                     |
;;;   |   |             |   |  �ݸ��              | x11,x22�Ͷ�Ďw�������ɂ��
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333    #p333ff <---FG�w��
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44--------------A+--+p33     #p33ff  <---FG�O��
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ��ۑ�   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   +C    |           +D
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55
;                               
;	 #p6ff      #p555ff      #p55ff

  ;BG��ʍ�}

  (cond
    ((and (equal #BG_Type1 1 0.1) (equal #BG_Type2 1 0.1))

      (cond
				((equal #TOP_FLG 1 0.1) ; ����į�ߑΉ� BG��荞��(�ި��۱)
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11 #pC #pD #p55 #p6)))
          (setq #bg_en2 nil)
				)
				((equal #TOP_FLG 4 0.1) ;������
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p66ff #p6ff)))
          (setq #bg_en2 nil)
				)
				((equal #TOP_FLG 5 0.1) ;�E����
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2ff #p22ff #p11 #p66 #p6)))
          (setq #bg_en2 nil)
				)
        (T
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p66 #p6)))
          (setq #bg_en2 nil)
        )
      );_cond


    )
    ((and (equal #BG_Type1 1 0.1) (equal #BG_Type2 0 0.1))
      (if (equal #TOP_FLG 1 0.1) ; ����į�ߑΉ� BG��荞��(�ި��۱)
        (progn
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #end2))) ; �ޯ��ް�ނ���
          (setq #bg_en2 nil)
        )
        ;else �ʏ�
        (progn
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2))) ; �ޯ��ް�ނ���
          (setq #bg_en2 nil)
        )
      );_if
    )
    ((and (equal #BG_Type1 0 0.1) (equal #BG_Type2 1 0.1))
      (if (equal #TOP_FLG 1 0.1) ; ����į�ߑΉ� BG��荞��(�ި��۱)
        (progn
          (setq #bg_en1 nil)
          (setq #bg_en2 (MakeTEIMEN (list #p1 #end1 #pC #pD #p55 #p6))) ; �ޯ��ް�ނ���
        )
        ;else �ʏ�
        (progn
          (setq #bg_en1 nil)
          (setq #bg_en2 (MakeTEIMEN (list #p1 #end1 #p66 #p6))) ; �ޯ��ް�ނ���
        )
      );_if
    )
    ((and (equal #BG_Type1 0 0.1) (equal #BG_Type2 0 0.1))  ; �ޯ��ް�ނȂ�
      (setq #bg_en1 nil)
      (setq #bg_en2 nil)
    )
    (T
      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
    )
  );_cond
  (setq #bg_en$ (list #bg_en1 #bg_en2))


	;2014/07/09 YM ADD-S

;;; ��L�^��            x11  x1
;;; p1+---end1---------*---*---------------------+p2   --- #p2ff    <---BG�w��
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|-----------------B+--+p22 --- #p2ff   <---BG�O��
;;;   |   |             |   |                     |
;;;   |   |             |   |  �ݸ��              | x11,x22�Ͷ�Ďw�������ɂ��
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333    #p333ff <---FG�w��
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44--------------A+--+p33     #p33ff  <---FG�O��
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ��ۑ�   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   +C    |           +D
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55
;                               
;	 #p6ff      #p555ff      #p55ff

	;2014/07/09 YM ADD-E

  ;FG��ʍ�}
;;;  (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p555 #p444 #p333))) ; �O������ؽ� �S��

			;2014/07/09 YM
      (cond
        ;2014/07/09 YM ADD-S �V�X�C�[�W�B�O���ꉡ������荞��
        ((equal #TOP_FLG 4 0.1);������
          (setq #fg_en1 (MakeTEIMEN (list #p333 #p33 #p44 #p55ff #p6ff #p6 #p555 #p444))); �O������
        )
        ((equal #TOP_FLG 5 0.1);�E����
          (setq #fg_en1 (MakeTEIMEN (list #p2ff #p33ff #p44 #p55 #p555 #p444 #p333 #p2))); �O������
        )
        ;2014/07/09 YM ADD-E �V�X�C�[�W�B�O���ꉡ������荞��

        (T ;�ʏ�
  				(setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p555 #p444 #p333))) ; �O������ؽ� �S��
        )
      );_cond



  (cond
    ((and (equal #FG_Type1 1 0.1) (equal #FG_Type2 1 0.1))    ; �ʏ�Б�
      (setq #fg_en2 nil)
    )
    ((and (equal #FG_Type1 1 0.1) (equal #FG_Type2 2 0.1))
      (setq #fg_en2 (MakeTEIMEN (list #p1  #p6  #p66  #p11)))
    )
    ((and (equal #FG_Type1 2 0.1) (equal #FG_Type2 1 0.1))
      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11))) ; �ݸ��FG����
    )
    ((and (equal #FG_Type1 2 0.1) (equal #FG_Type2 2 0.1))
      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p66 #p6))) ; �O����O��
    )
    (T
      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
    )
  );_cond

  (setq #fg_en$ (list #fg_en1 #fg_en2))
;-- 2011/08/25 A.Satoh Mod - E


  ; ܰ�į�ߒ��

;;;  (setq #wt_en (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p55 #p6)))        ; ܰ�į�ߒ�� �S��

	;2014/07/09 YM�@����

;;; ��L�^��            x11  x1
;;; p1+---end1---------*---*---------------------+p2   --- #p2ff    <---BG�w��
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|-----------------B+--+p22 --- #p2ff   <---BG�O��
;;;   |   |             |   |                     |
;;;   |   |             |   |  �ݸ��              | x11,x22�Ͷ�Ďw�������ɂ��
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333    #p333ff <---FG�w��
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44--------------A+--+p33     #p33ff  <---FG�O��
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ��ۑ�   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   +C    |           +D
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55
;                               
;	 #p6ff      #p555ff      #p55ff

  (cond
    ((equal #TOP_FLG 4 0.1) ;(������) �O�����荞�ݒǉ�
;;;(list #p333 #p33 #p44 #p55ff #p6ff #p6 #p555 #p444)
      (setq #wt_en (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p55ff #p6ff)))
		  (setq #WT_LEN1 (distance #p1 #p2))
		  (setq #WT_LEN2 (distance #p1 #p6ff))
    )
    ((equal #TOP_FLG 5 0.1) ;(�E����) �O�����荞�ݒǉ�
;;;(list #p2ff #p33ff #p44 #p55 #p555 #p444 #p333 #p2)
      (setq #wt_en (MakeTEIMEN (list #p1 #p2ff #p33ff #p44 #p55 #p6)))
		  (setq #WT_LEN1 (distance #p1 #p2ff))
		  (setq #WT_LEN2 (distance #p1 #p6))
    )
    (T ;�ʏ�(�]���ʂ�)
			(setq #wt_en (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p55 #p6))) ; ܰ�į�ߒ�� �S��
		  (setq #WT_LEN1 (distance #p1 #p2))
		  (setq #WT_LEN2 (distance #p1 #p6))
    )
  );_cond

  (setq #dep1 (distance #p33 #p2))
  (setq #dep2 (distance #p55 #p6))

  (setq #cut_type "00")
  (if (= CG_Type2Code "D")            ; ۰���ނ̌���
    (progn
      ;;; ���� #p6 �̂܂���&outpl_LOW�������T �Ȃ���� nil
      (if (PKSLOWPLCP #p6 &outpl_LOW) ; T or nil
        (setq #cut_type "40")        ; �i��������
      );_if
      ;;; �E�� #p2 �̂܂���&outpl_LOW�������T �Ȃ���� nil
      (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
        (setq #cut_type "04")        ; �i��������
      );_if
    )
  );_if

;;;  (setq #WT_LEN1 (distance #p1 #p2))
;;;  (setq #WT_LEN2 (distance #p1 #p6))
;;;  (setq #dep1 (distance #p33 #p2))
;;;  (setq #dep2 (distance #p55 #p6))

;-- 2011/06/28 A.Satoh Mod - S
; (setq #WTLEN$ (PKGetWTLEN$ #dep1 #dep2 #WT_LEN1 #WT_LEN2))
  (if (= nil CG_GLOBAL$)
    (setq #DL CG_LRCODE);2011/09/23 YM MOD
    (setq #DL (nth 11 CG_GLOBAL$))
  )
  (if (= #DL "L")
    (setq #WTLEN$ (list #WT_LEN2 #WT_LEN1))
    (setq #WTLEN$ (list #WT_LEN1 #WT_LEN2))
  )
;-- 2011/06/28 A.Satoh Mod - E
;-- 2012/04/20 A.Satoh Mod �V���N�z�u�s��Ή� (���������ɖ߂�) - S
;;;;;;-- 2011/07/11 A.Satoh Mod - S
  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep1 #dep2) #WTLEN$ #p1 1))
;;;;;  (if (= #DL "L")
;;;;;    (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep2 #dep1) #WTLEN$ #p1 1))
;;;;;    (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep1 #dep2) #WTLEN$ #p1 1))
;;;;;  )
;;;;;;-- 2011/07/11 A.Satoh Mod - E
;-- 2012/04/20 A.Satoh Mod �V���N�z�u�s��Ή� (���������ɖ߂�) - E
  (setq #ret$ (append #ret$ (list #ret)))
  #ret$
);PKLcut0

;-- 2011/08/25 A.Satoh Del - S
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PKLcut1
;;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 L�^�΂߶��(ID=1)
;;;; <�߂�l>    :
;;;; <�쐬>      : 00/09/26 YM �W����
;;;; <���l>      :
;;;;*************************************************************************>MOH<
;(defun PKLcut1 (
;  &WTInfo
;  &ZaiCode
;  &outpl_LOW
;  &point$
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #CUT_TYPE #DEP #FG_EN$ #FG_EN1 #FG_EN2
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66
;  #RET$ #RET #wt_en #WT_LEN #BG_TYPE1 #BG_TYPE2 #FG_TYPE1 #FG_TYPE2
;  #BG_SEP #BG_T #DUMPT1 #DUMPT2 #FG_S #FG_T
;#PA #PB #PC #PD #TOP_FLG ;03/10/14 YM ADD
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
;  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
;  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;
;;;; ��L�^��            x11  x1
;;;; p1+---end1---------*---*---------------------+p2   <---BG�w��
;;;;   |   |             |   |                     |
;;;;end2-- +p11----------|---|-----------------B+--+p22  <---BG�O��
;;;;   |   |             |   |                     |
;;;;   |   |             |   |  �ݸ��              | x11,x22�Ͷ�Ďw�������ɂ��
;;;;   |   |             |   |                     |
;;;;   |   |     +p444---|---|---------------------+p333 <---FG�w��
;;;;   |   |     |       |   |                     |
;;;;x22*---------------- *sp1|                     |
;;;;   |   |     |           |                     |
;;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;;; x2*-------------------- *p44--------------A+--+p33  <---FG�O��
;;;;   |   |     |         | |
;;;;   |   |     |           |
;;;;   |   |     | ��ۑ�   | |
;;;;   |   |     |           |
;;;;   |   |     |         | |
;;;;   |   +C    |           +D
;;;;   +---+-----+---------+-+
;;;; p6   p66   p555      p5 p55
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;
;  (setq #p11 (nth  6 &point$))
;  (setq #p22 (nth  7 &point$))
;  (setq #p33 (nth  8 &point$))
;  (setq #p44 (nth  9 &point$))
;  (setq #p55 (nth 10 &point$))
;  (setq #p66 (nth 11 &point$))
;
;  (setq #p333 (nth 12 &point$))
;  (setq #p444 (nth 13 &point$))
;  (setq #p555 (nth 14 &point$))
;
;  ;03/09/22 YM ADD ����į���׸ޑΉ�
;  ; BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pC  (polar #p66  (angle #p6 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pD  (polar #p55  (angle #p6 #p1) #BG_T)) ; BG���ݕ�
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;
;;;;;;;;; (�ݸ��) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG��ʍ�}
;  (cond
;    ((equal #BG_Type1 1 0.1)
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11))) ; �ޯ��ް�ނ���
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11))) ; �ݸ��BG����
;      );_if
;    )
;    ((equal #BG_Type1 0 0.1)
;      (setq #bg_en1 nil)                                   ; �ݸ��BG�Ȃ�
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p444 #p333))) ; �O������ؽ� �ݸ��
;      (setq #fg_en2 nil)                                   ; �ݸ��FG�ʏ�
;    )
;    ((equal #FG_Type1 2 0.1) ; FG����
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p444 #p333))) ; �O������ؽ� �ݸ��
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11))) ; �ݸ��FG����
;    )
;    ((equal #FG_Type1 3 0.1) ; FG�O��E
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #p11)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (list #p1  #p2  #p33  #p44 )))  ; ܰ�į�ߒ��1 H,W���
;  (setq #WT_LEN (distance #p1  #p2))
;  (setq #dep    (distance #p33 #p2))
;  (setq #cut_type "30")            ; H���
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;      (setq #cut_type "34")        ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p1 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (��ۑ�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG��ʍ�}
;  (cond
;    ((equal #BG_Type2 1 0.1) ; BG����
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p6 #p55 #pD #pC #p11))); �ޯ��ް�ނ���
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p6 #p66 #p11))) ; ��ۑ�BG����
;      );_if
;    )
;    ((equal #BG_Type2 0 0.1)
;      (setq #bg_en1 nil)                                      ; ��ۑ�BG�Ȃ�
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p44 #p55 #p555 #p444)))    ; �O������ؽ� ��ۑ�
;      (setq #fg_en2 nil)                                      ; ��ۑ�FG�ʏ�
;    )
;    ((equal #FG_Type2 2 0.1) ; FG����
;      (setq #fg_en1 (MakeTEIMEN (list #p44 #p55 #p555 #p444)))    ; �O������ؽ� ��ۑ�
;      (setq #fg_en2 (MakeTEIMEN (list #p1  #p6  #p66  #p11))) ; ��ۑ�FG����
;    )
;    ((equal #FG_Type2 3 0.1) ; FG�O�㍶
;      (setq #dumPT1 (polar #p555 (angle #p6 #p1) #FG_T))
;      (setq #dumPT2 (polar #p66  (angle #p6 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p1 #p6 #p55 #p44 #p444 #dumPT1 #dumPT2 #p11)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (list #p1  #p6  #p55  #p44)))  ; ܰ�į�ߒ��2
;  (setq #WT_LEN (distance #p1  #p6))
;  (setq #dep    (distance #p55 #p6))
;  (setq #cut_type "03")            ; H���
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p6 &outpl_LOW) ; T or nil
;      (setq #cut_type "43")        ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p6 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKLcut1
;
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PKLcut2
;;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 L�^�������(ID=2)
;;;; <�߂�l>    :
;;;; <�쐬>      : 00/09/26 YM �W����
;;;; <���l>      :
;;;;*************************************************************************>MOH<
;(defun PKLcut2 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$
;  &BGFG_Info
;  /
;  #CUTPT1 #EN_DUM1 #EN_DUM2 #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66
;  #RET$ #SP1 #X1 #X11 #X2 #X22 #cutin
;  #BG_T #DUMPT1 #DUMPT2 #FG_S #FG_T #BG_SEP #TOP_FLG
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
;  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
;  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;
;  (setq #p11 (nth  6 &point$))
;  (setq #p22 (nth  7 &point$))
;  (setq #p33 (nth  8 &point$))
;  (setq #p44 (nth  9 &point$))
;  (setq #p55 (nth 10 &point$))
;  (setq #p66 (nth 11 &point$))
;
;  (setq #p333 (nth 12 &point$))
;  (setq #p444 (nth 13 &point$))
;  (setq #p555 (nth 14 &point$))
;
;  ;;; �����̑������߂� #x1,#x2
;  (setq #x1 (CFGetDropPt #p44 (list #p1 #p2)))
;  (setq #x2 (CFGetDropPt #p44 (list #p1 #p6)))
;
;  ; (nth 11 CG_GLOBAL$) ���E�g������
;
;  (if CG_Srcpln ; ���݌���
;    (progn ; ���݌���
;      (if (= (nth 11 CG_GLOBAL$) "R") ; ��ĕ����̗�O����
;        (setq #CutPt1 #x2) ; ��ۑ�(���ۂɺ�ۂ����邩�ǂ����Ƃ͖��֌W)
;        (setq #CutPt1 #x1) ; �����ݸ��
;      );_if
;    )
;; else
;    (progn ; ���݌����ȊO
;      ; ��ĕ����w������
;      (MakeLWPL (list #p44 (polar #x1 (angle #p6 #p1) 100)) 0) ; 01/06/11 YM MOD
;      (setq #en_dum1 (entlast))
;      (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;      (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; �F��ς���
;
;      (MakeLWPL (list #p44 (polar #x2 (angle #p2 #p1) 100)) 0) ; 01/06/11 YM MOD
;      (setq #en_dum2 (entlast))
;      (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;      (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; �F��ς���
;
;      (setq #CutPt1 (getpoint "\n�J�b�g�������w��: "))
;      (entdel #en_dum1)
;      (entdel #en_dum2)
;    )
;  );_if
;
;  ;03/10/13 YM ADD-S KDA�Ή� ������Ă̐؂荞�ݕ�
;  (if (equal (KPGetSinaType) 4 0.1);KDA�Ή�
;    (setq CG_LenDircut 75);KDA
;    (setq CG_LenDircut 50);KSA,KGA,KNA
;  );_if
;
;  (setq #cutin CG_LenDircut) ; �؂荞�ݕ��Œ�
;
;;;;01/07/02YM@  (if CG_Srcpln ; ���݌���
;;;;01/07/02YM@    (progn ; ���݌���
;;;;01/07/02YM@      (setq #cutin CG_LenDircut) ; �؂荞�ݕ��Œ�
;;;;01/07/02YM@    )
;;;;01/07/02YM@    (progn ; ���݌����ȊO
;;;;01/07/02YM@      ; �؂荞�ݕ�����
;;;;01/07/02YM@      (setq #cutin nil)
;;;;01/07/02YM@      (setq #cutin (getreal "\n�؂荞�ݕ�<0.0>: "))
;;;;01/07/02YM@      (if (= #cutin nil)(setq #cutin 0.0))
;;;;01/07/02YM@    )
;;;;01/07/02YM@  );_if
;
;  (setq #x11 (polar #x1  (angle #p2 #p1) #cutin))
;  (setq #x22 (polar #x2  (angle #p6 #p1) #cutin))
;  (setq #sp1 (polar #p44 (angle #p6 #p1) #cutin))
;  (setq #sp1 (polar #sp1 (angle #p2 #p1) #cutin))
;
;  (if (< (distance #CutPt1 #x11) (distance #CutPt1 #x22)) ; ������D��Ă̗L�������߂�
;    (progn
;;;;01/06/22YM@      (setq #sp1 (polar #p44 (angle #p6 #p1) 50)) ; 01/06/11 YM ADD
;      (setq #ret$ (PKLcut2-1 &WTINFO &ZaiCode &outpl_LOW &point$ #x11 #x22 #sp1 &BGFG_Info)); ***** ��ĕ���x11 *****
;    )
;    (progn
;;;;01/06/22YM@      (setq #sp1 (polar #p44 (angle #p2 #p1) 50)) ; 01/06/11 YM ADD
;      (setq #ret$ (PKLcut2-2 &WTINFO &ZaiCode &outpl_LOW &point$ #x11 #x22 #sp1 &BGFG_Info)); ***** ��ĕ���x22 *****
;    )
;  )
;  #ret$
;);PKLcut2
;
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PKLcut2-1
;;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 L�^�������(ID=2) �����1
;;;; <�߂�l>    :
;;;; <�쐬>      : 00/09/26 YM �W����
;;;; <���l>      : MICADO������Ă͒���
;;;;*************************************************************************>MOH<
;(defun PKLcut2-1 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$ ;�_��
;  &x11
;  &x22
;  &sp1
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #CUT_TYPE #DEP #FG_EN$ #FG_EN1 #FG_EN2
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66
;  #RET$ #RET #SP1 #wt_en #WT_LEN #X11 #X22 #BG_TYPE1 #BG_TYPE2 #FG_TYPE1 #FG_TYPE2
;  #BG_SEP #dum #end1 #end2 #LIS1 #LIS2
;  #BG_T #DUMPT1 #DUMPT2 #FG_S #FG_T
;#PA #PB #PC #PD #TOP_FLG ;03/10/14 YM ADD
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
;  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
;  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;
;;;; ��L�^��            x11  x1
;;;; p1+---end1---------*---*---------------------+p2   <---BG�w��
;;;;   |   |             |   |                     |
;;;;end2-- +p11----------*dum|-----------------B+--+p22  <---BG�O��
;;;;   |   |             |   |                     |
;;;;   |   |             |   |  �ݸ��              | x11,x22�Ͷ�Ďw�������ɂ��
;;;;   |   |             |   |                     |
;;;;   |   |     +p444---|---|---------------------+p333 <---FG�w��
;;;;   |   |     |       |   |                     |
;;;;x22*---------------- *sp1|                     |
;;;;   |   |     |           |                     |
;;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;;; x2*-------------------- *p44--------------A+--+p33  <---FG�O��
;;;;   |   |     |         | |
;;;;   |   |     |           |
;;;;   |   |     | ��ۑ�   | |
;;;;   |   |     |           |
;;;;   |   |     |         | |
;;;;   |   +C    |           +D
;;;;   +---+-----+---------+-+
;;;; p6   p66   p555      p5 p55
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;
;  (setq #p11 (nth  6 &point$))
;  (setq #p22 (nth  7 &point$))
;  (setq #p33 (nth  8 &point$))
;  (setq #p44 (nth  9 &point$))
;  (setq #p55 (nth 10 &point$))
;  (setq #p66 (nth 11 &point$))
;
;  (setq #p333 (nth 12 &point$))
;  (setq #p444 (nth 13 &point$))
;  (setq #p555 (nth 14 &point$))
;  (setq #end1 (inters #p11 #p66 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p6 nil))
;
;  ;03/09/22 YM ADD ����į���׸ޑΉ�
;  ; BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pC  (polar #p66  (angle #p6 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pD  (polar #p55  (angle #p6 #p1) #BG_T)) ; BG���ݕ�
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_SEP   (nth 4 &BGFG_Info)) ; �����^:1 ��̌^:0
;
;  (setq #x11 &x11)
;  (setq #x22 &x22)
;  (setq #sp1 &sp1)
;  (setq #dum (CFGetDropPt #p22 (list #sp1 #x11)))
;;;;;;;;; (�ݸ��) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG��ʍ�}
;  (cond
;    ((equal #BG_Type1 1 0.1) ; BG����
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #pA #pB #dum))) ; �ޯ��ް�ނ���
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p22 #dum))) ; �ޯ��ް�ޒ��
;      );_if
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type1 0 0.1) ; BG�Ȃ�
;      (setq #bg_en$ (list nil nil))
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; 1���ڒʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; �O����O
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type1 2 0.1) ; 1����FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; �O����O
;      (setq #fg_en2 (MakeTEIMEN (list #x11 #p2 #p22 #dum))) ; �O������
;    )
;    ((equal #FG_Type1 3 0.1) ; 1����FG�O��E
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #dum)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x11 #p2 #p33))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #p2 #x11))
;  (setq #WT_LEN (distance #p44 #p33)) ; 01/07/02 Y-CUT
;  (setq #cut_type "20")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")            ; ۰���ނ̌���
;    (progn
;      (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;        (setq #cut_type "24")         ; �i��������
;      );_if
;    )
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #x11 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (��ۑ�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG��ʍ�}
;  (cond
;    ((equal #BG_Type2 1 0.1) ; 2����BG����
;      (cond
;        ((equal #BG_Type1 0 0.1) ; 1����BG�Ȃ� 01/07/26 YM ADD
;          (setq #bg_en1 (MakeTEIMEN (list #end1 #p1 #p6 #p66)))          ; �ޯ��ް�ޒ��
;        )
;        ((equal #BG_Type1 1 0.1) ; 1����BG���� 01/07/26 YM ADD
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;            (setq #bg_en1 (MakeTEIMEN (list #x11 #p1 #p6 #p55 #pD #pC #p11 #dum))) ; �ޯ��ް�ޒ��
;            ;else �ʏ�
;            (setq #bg_en1 (MakeTEIMEN (list #x11 #p1 #p6 #p66 #p11 #dum))) ; �ޯ��ް�ޒ��
;          );_if
;        )
;      );_cond
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;      (cond
;        ((equal #BG_Type1 1 0.1) ; 1����BG���� 01/07/26 YM ADD
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #x11 #dum #end2)))         ; �ޯ��ް�ޒ��
;        )
;        ((equal #BG_Type1 0 0.1) ; 1����BG�Ȃ� 01/07/26 YM ADD
;          (setq #bg_en1 nil)                                             ; �ޯ��ް�ޒ��
;        )
;      );_cond
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; 2���ڒʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44)))
;      (cond
;        ((equal #FG_Type1 2 0.1) ; 1����FG�O�� 01/07/26 YM ADD
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #x11 #dum #end2)))
;        )
;        ((equal #FG_Type1 1 0.1) ; 1����FG�O 01/07/26 YM ADD
;          (setq #fg_en2 nil)
;        )
;      );_cond
;    )
;    ((equal #FG_Type2 2 0.1) ; 2����FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; �O����O
;      (cond
;        ((equal #FG_Type1 2 0.1) ; 1����FG�O�� 01/07/26 YM ADD
;          (setq #fg_en2 (MakeTEIMEN (list #x11 #p1 #p6 #p66 #p11 #dum))) ; �O������E
;        )
;        ((equal #FG_Type1 1 0.1) ; 1����FG�O 01/07/26 YM ADD
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #p66 #p6))) ; �O������
;        )
;      );_cond
;    )
;    ((equal #FG_Type2 3 0.1) ; 2����FG�O��E
;      (setq #dumPT1 (polar #p555 (angle #p6 #p1) #FG_T))
;      (setq #dumPT2 (polar #p66  (angle #p6 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x11 #p1 #p6 #p55 #p44 #p444 #dumPT1 #dumPT2 #p11 #dum)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x11 #p1 #p6 #p55))))
;  (setq #WT_LEN (distance #p1 #p6))
;  (setq #cut_type "01")
;  (setq #dep (distance #p55 #p6))
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p6 &outpl_LOW) ; T or nil
;      (setq #cut_type "41")         ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p6 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKLcut2-1
;
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PKLcut2-2
;;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 L�^�������(ID=2) �����2
;;;; <�߂�l>    :
;;;; <�쐬>      : 00/09/26 YM �W����
;;;; <���l>      : MICADO������Ă͒���
;;;;*************************************************************************>MOH<
;(defun PKLcut2-2 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$ ;�_��
;  &x11
;  &x22
;  &sp1
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #CUT_TYPE #DEP #FG_EN$ #FG_EN1 #FG_EN2
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66
;  #RET$ #RET #SP1 #wt_en #WT_LEN #X11 #X22 #BG_TYPE1 #BG_TYPE2 #FG_TYPE1 #FG_TYPE2
;  #dum #end1 #end2 #LIS1 #LIS2
;  #BG_SEP #BG_T #DUMPT1 #DUMPT2 #FG_S #FG_T
;#PA #PB #PC #PD #TOP_FLG ;03/10/14 YM ADD
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
;  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
;  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;
;;;; ��L�^��            x11  x1
;;;; p1+---end1---------*---*---------------------+p2   <---BG�w��
;;;;   |   |             |   |                     |
;;;;end2-- +p11--------------|-----------------B+--+p22  <---BG�O��
;;;;   |   |             |   |                     |
;;;;   |   |             |   |  �ݸ��              | x11,x22�Ͷ�Ďw�������ɂ��
;;;;   |   |             |   |                     |
;;;;   |   |     +p444---|---|---------------------+p333 <---FG�w��
;;;;   |   |     |       |   |                     |
;;;;x22*---*dum--------- *sp1|                     |
;;;;   |   |     |           |                     |
;;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;;; x2*-------------------- *p44--------------A+--+p33  <---FG�O��
;;;;   |   |     |         | |
;;;;   |   |     |           |
;;;;   |   |     | ��ۑ�   | |
;;;;   |   |     |           |
;;;;   |   |     |         | |
;;;;   |   +C    |           +D
;;;;   +---+-----+---------+-+
;;;; p6   p66   p555      p5 p55
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;
;  (setq #p11 (nth  6 &point$))
;  (setq #p22 (nth  7 &point$))
;  (setq #p33 (nth  8 &point$))
;  (setq #p44 (nth  9 &point$))
;  (setq #p55 (nth 10 &point$))
;  (setq #p66 (nth 11 &point$))
;
;  (setq #p333 (nth 12 &point$))
;  (setq #p444 (nth 13 &point$))
;  (setq #p555 (nth 14 &point$))
;  (setq #end1 (inters #p11 #p66 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p6 nil))
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_SEP   (nth 4 &BGFG_Info)) ; �����^:1 ��̌^:0
;
;  ;03/09/22 YM ADD ����į���׸ޑΉ�
;  ; BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pC  (polar #p66  (angle #p6 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pD  (polar #p55  (angle #p6 #p1) #BG_T)) ; BG���ݕ�
;
;  (setq #x11 &x11)
;  (setq #x22 &x22)
;  (setq #sp1 &sp1)
;  (setq #dum (CFGetDropPt #p66 (list #sp1 #x22)))
;;;;;;;;; (�ݸ��) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG��ʍ�}
;  (cond
;    ((equal #BG_Type1 1 0.1) ; 1����BG����
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2����BG����
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #pA #pB #p11 #dum))) ; �ޯ��ް�ޒ��
;            ;else �ʏ�
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum))) ; �ޯ��ް�ޒ��
;          );_if
;        )
;        ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2))) ; �ޯ��ް�ޒ��
;        )
;      );_cond
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type1 0 0.1) ; 1����BG�Ȃ�
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #dum #x22)))
;          (setq #bg_en2 nil)
;          (setq #bg_en$ (list #bg_en1 #bg_en2))
;        )
;        ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;          (setq #bg_en$ (list nil nil))
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; 1���ڒʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; �O����O
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2���ڒʏ�Б�
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type2 2 0.1) ; 2���ڗ���
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #dum #x22))) ; �O�����덶
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 2 0.1) ; 1����FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; �O����O
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2���ڒʏ�Б�
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #end2))) ; �O������
;        )
;        ((equal #FG_Type2 2 0.1) ; 2���ڗ���
;          (setq #fg_en2 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum))) ; �O�����덶
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 3 0.1) ; 1����FG�O��E
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #p11 #dum)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x22 #p1 #p2 #p33))))
;  (setq #WT_LEN (distance #p2 #p1))
;  (setq #cut_type "10")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;      (setq #cut_type "14")         ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p1 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (��ۑ�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG��ʍ�}
;  (cond
;    ((equal #BG_Type2 1 0.1) ; 2����BG����
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #x22 #p6 #p55 #pD #pC #dum))) ; �ޯ��ް�ޒ��
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #x22 #p6 #p66 #dum))) ; �ޯ��ް�ޒ��
;      );_if
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;      (setq #bg_en$ (list nil nil))
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; 2���ڒʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; �O����O
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type2 2 0.1) ; 2����FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; �O����O
;      (setq #fg_en2 (MakeTEIMEN (list #x22 #p6 #p66 #dum)))    ; �O������
;    )
;    ((equal #FG_Type2 3 0.1) ; 2����FG�O�㍶
;      (setq #dumPT1 (polar #p555 (angle #p6 #p1) #FG_T))
;      (setq #dumPT2 (polar #p66  (angle #p6 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x22 #p6 #p55 #p44 #p444 #dumPT1 #dumPT2 #dum)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x22 #p6 #p55))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #x22 #p6))
;  (setq #WT_LEN (distance #p44 #p55)) ; 01/07/02 Y-CUT
;  (setq #cut_type "02")
;  (setq #dep (distance #p55 #p6))
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p6 &outpl_LOW) ; T or nil
;      (setq #cut_type "42")         ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p6 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKLcut2-2
;-- 2011/08/25 A.Satoh Del - E

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMakeTeimenPline_U
;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬
;;; <�߂�l>    :
;;; <�쐬>      : 00/09/27 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKMakeTeimenPline_U (
  &pt$         ; �eWT�O�`�_�� 4,6,8�_�̂�
;;;  &lis$        ; WT�g���t���O ; 01/08/27 YM DEL
  &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep))
  &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
  &WTInfo2     ; WT���2  (#BG_S2 #BG_Type2 #FG_Type2)
  &WTInfo3     ; WT���3  (#BG_S3 #BG_Type3 #FG_Type3)
  &CutId       ; ���ID 0,1,2 �Ȃ�,�΂�H,�����w��  L,U�̂�
  &outpl_LOW   ;
  &ZaiCode     ; �ގ��L��
  /
  #ANG #BASEPT$ #BGFG_INFO #BG_S1 #BG_S2 #BG_S3 #BG_SEP #BG_T #BG_TYPE1 #BG_TYPE2 #BG_TYPE3
  #ddd #ddd1 #ddd2 #ddd3 #ddd4 #FG_S #FG_T #FG_TYPE1 #FG_TYPE2 #FG_TYPE3 #LIS$
  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
  #POINT$ #PT$ #RET$ #WT_LEN1 #WT_LEN2 #WT_LEN3 #X2 #TOP_FLG #MSG
  )
  (setq #pt$ &pt$)

  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�

  ;03/09/22 YM ADD ����į�ߑΉ� FG�O�㍶(�ި��۱)
  (if (or (equal #TOP_FLG 2 0.1)(equal #TOP_FLG 3 0.1)(equal #TOP_FLG 22 0.1)(equal #TOP_FLG 33 0.1))
    (progn
      ;2008/08/18 YM ADD �޲�۸ނ��\�����ꂽ�܂܂ɂȂ�
      (cond
        ((= CG_AUTOMODE 0)
          (CFAlertMsg "���̔z������ׯēV�ɑΉ����Ă��܂���")
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog "���̔z������ׯēV�ɑΉ����Ă��܂���")
          (quit)
        )
      );_cond
    )
  );_if

  (setq #BG_S1    (nth 0 &WTInfo1)) ; �㐂��V�t�g��
  (setq #BG_Type1 (nth 1 &WTInfo1)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #FG_Type1 (nth 2 &WTInfo1)) ; FG���� 1:�Б� 2:����

  (setq #BG_S2    (nth 0 &WTInfo2)) ; �㐂��V�t�g��
  (setq #BG_Type2 (nth 1 &WTInfo2)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #FG_Type2 (nth 2 &WTInfo2)) ; FG���� 1:�Б� 2:����

  (setq #BG_S3    (nth 0 &WTInfo3)) ; �㐂��V�t�g��
  (setq #BG_Type3 (nth 1 &WTInfo3)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #FG_Type3 (nth 2 &WTInfo3)) ; FG���� 1:�Б� 2:����

;;; ��U�^��
;;;       end1     x11 x1
;;; p1+(BASE1)-----*---*------------------------+p2   <---BG�w��
;;;   |   |        |   |                        |
;;; end2--+p11-----dum1|------------------------+p22  <---BG�O��
;;;   |   |        |   |                        |
;;;   |   |     +p444--|------------------------+p333 <---FG�w��
;;;   |   |     |  |   |                        |
;;;x22* - dum2- - -*sp1|             �ݸ��      | x1,x2 x11,x22�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp1��J��Ď��̕���_
;;;   |   |     |      |                        |
;;;   |   |     |    +p4------------------------+p3
;;; x2* - - - - - - - -+------------------------+p33  <---FG�O��
;;;   |   |     |    | |p44
;;;   |   |     |    | |
;;;   |   |��ۑ�|    | |
;;;   |   |     |    | |
;;;   |   |     |    | |
;;; x3* - - - - - - - -+p55----------------------+p66  <---FG�O��
;;;   |   |     |    +p5-------------------------+p6
;;;   |   |     |      |                         |
;;;x33* - dum3- - -*sp2|          ���̑�         | x3,x4 x33,x44�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp2��J��Ď��̕���_
;;;   |   |     |  |   |                         |
;;;   |   |     +p555--|-------------------------+p666 <---FG�w��
;;;   |   |        |   |                         |
;;; end3--+p88-----dum4|-------------------------+p77  <---BG�O��
;;;   |   |        |   |                         |
;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG�w��
;;;       end4    x44 x4

;;; �Vۼޯ� YM �O�`�_��-->��Ű��_ PKGetBaseL6
  (setq #BASEPT$ (PKGetBaseU8 #pt$))
  (if (or (= nil (car #BASEPT$)) (= nil (cadr #BASEPT$)))
    (progn
      ;2008/08/20 YM MOD-S CAD���ް�ŕ\�����o�Ȃ��悤�ɂ���
      (setq #msg "��Ű��_���擾�ł��܂���ł���")      
      (cond
        ((= CG_AUTOMODE 0)
          (CMN_OutMsg #msg)
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog #msg)
          (quit)
        )
      );_cond
      ;2008/08/20 YM MOD-S CAD���ް�ŕ\�����o�Ȃ��悤�ɂ���
    )
  );_if
  (setq #pt$ (GetPtSeries (car #BASEPT$) #pt$)) ; �O�`�_��&pt$��#BASEPT��擪�Ɏ��v����ɂ���
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))
  (setq #p7 (nth 6 #pt$))
  (setq #p8 (nth 7 #pt$))
  (setq #WT_LEN1 (distance #p1 #p2))
  (setq #WT_LEN2 (distance #p1 #p8))
  (setq #WT_LEN3 (distance #p8 #p7))
;;; WT�g���Ή�
  (setq #x2 (CFGetDropPt #p4 (list #p1 #p8)))

  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL  (if (> #BG_S1 0.1) ; �ݸ��
;;;02/01/21YM@DEL   (progn
      (setq #p2 (polar #p2 (angle #p3 #p2) #BG_S1))
      (setq #p1 (polar #p1 (angle #p8 #p1) #BG_S1))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL  (if (> #BG_S2 0.1) ; ��ۑ�
;;;02/01/21YM@DEL   (progn
      (setq #p1 (polar #p1 (angle #p2 #p1) #BG_S2))
      (setq #p8 (polar #p8 (angle #p7 #p8) #BG_S2))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL  (if (> #BG_S3 0.1) ; ���̑���
;;;02/01/21YM@DEL   (progn
      (setq #p8 (polar #p8 (angle #p6 #p7) #BG_S3))
      (setq #p7 (polar #p7 (angle #p6 #p7) #BG_S3))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  (setq #p22  (polar #p2   (angle #p2 #p3) #BG_T)) ; BG���ݕ�
  (setq #p77  (polar #p7   (angle #p7 #p6) #BG_T)) ; BG���ݕ�
  (setq #ddd (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #ang (angle #ddd #p4))
  (setq #ddd1 (polar #p1   (angle #p2 #p3) #BG_T)) ; BG���ݕ�
  (setq #ddd2 (polar #p1   #ang            #BG_T)) ; BG���ݕ�
  (setq #ddd3 (polar #p8   #ang            #BG_T)) ; BG���ݕ�
  (setq #ddd4 (polar #p8   (angle #p7 #p6) #BG_T)) ; BG���ݕ�
  (setq #p11  (inters #p22 #ddd1 #ddd2 #ddd3 nil))
  (setq #p88  (inters #ddd2 #ddd3 #p77 #ddd4 nil))

  (setq #p33  (polar #p3   (angle #p2 #p3) #FG_S)) ; WT��ėʕ�
  (setq #p66  (polar #p6   (angle #p7 #p6) #FG_S)) ; WT��ėʕ�
  (setq #ddd (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #ddd1 (polar #p4   (angle #p2 #p3) #FG_S)) ; WT��ėʕ�
  (setq #ddd2 (polar #p4   #ang            #FG_S)) ; WT��ėʕ�
  (setq #ddd3 (polar #p5   #ang            #FG_S)) ; WT��ėʕ�
  (setq #ddd4 (polar #p5   (angle #p7 #p6) #FG_S)) ; WT��ėʕ�
  (setq #p44  (inters #p33 #ddd1 #ddd2 #ddd3 nil))
  (setq #p55  (inters #ddd2 #ddd3 #p66 #ddd4 nil))

  (setq #p333 (polar #p33  (angle #p3 #p2) #FG_T))
  (setq #p666 (polar #p66  (angle #p6 #p7) #FG_T))
  (setq #ang (angle #p4 #ddd))
  (setq #ddd1 (polar #p44  (angle #p3 #p2) #FG_T)) ; FG���ݕ�
  (setq #ddd2 (polar #p44  #ang            #FG_T)) ; FG���ݕ�
  (setq #ddd3 (polar #p55  #ang            #FG_T)) ; FG���ݕ�
  (setq #ddd4 (polar #p55  (angle #p6 #p7) #FG_T)) ; FG���ݕ�
  (setq #p444 (inters #p333 #ddd1 #ddd2 #ddd3 nil))
  (setq #p555 (inters #ddd2 #ddd3 #p666 #ddd4 nil))

  (setq #point$ (list #p1   #p2   #p3   #p4  #p5  #p6  #p7  #p8
                      #p11  #p22  #p33  #p44 #p55 #p66 #p77 #p88
                      #p333 #p444 #p555 #p666))
  (setq #BGFG_Info (list #BG_Type1 #FG_Type1 #BG_Type2 #FG_Type2 #BG_Type3 #FG_Type3 #BG_SEP))

  (setq CG_MAG1 (distance #p1 #p2)) ; ����ݸ�ʒu�ɖ��֌W1���ڊԌ�
  (setq CG_MAG2 (distance #p1 #p8)) ; ����ݸ�ʒu�ɖ��֌W2���ڊԌ�
  (setq CG_MAG3 (distance #p7 #p8)) ; ����ݸ�ʒu�ɖ��֌W3���ڊԌ�

;-- 2011/07/14 A.Satoh Mod - S
  (setq #ret$ (PKUcut0 &WTInfo #point$ #BGFG_Info))
;  (cond
;    ((= &CutId 0) ; ��ĂȂ�
;      (setq #ret$ (PKUcut0 &WTInfo                     #point$ #BGFG_Info))
;    )
;    ((= &CutId 1) ; �΂߶��
;      (setq #ret$ (PKUcut1 &WTInfo &ZaiCode &outpl_LOW #point$ #BGFG_Info))
;    )
;    ((= &CutId 2) ; �������
;      (setq #ret$ (PKUcut2 &WTInfo &ZaiCode &outpl_LOW #point$ #BGFG_Info))
;    )
;  );_cond
;-- 2011/07/14 A.Satoh Mod - S

  #ret$
);PKMakeTeimenPline_U

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMakeTeimenPline_U_ALL
;;; <�����T�v>  : �i�������܂ޑS��WT�O�`�_����۰��قɾ��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/08/24 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKMakeTeimenPline_U_ALL (
  &WTInfo      ; WT���   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
  &WTInfo1     ; WT���1  (#BG_S1 #BG_Type1 #FG_Type1)
  &WTInfo2     ; WT���2  (#BG_S2 #BG_Type2 #FG_Type2)
  &WTInfo3     ; WT���3  (#BG_S3 #BG_Type3 #FG_Type3)
  /
  #ANG #BASEPT$ #BG_S1 #BG_S2 #BG_S3 #DDD #DDD1 #DDD2 #DDD3 #DDD4
  #FG_S #P1 #P2 #P3 #P33 #P4 #P44 #P5 #P55 #P6 #P66 #P7 #P8 #PT$ #X2 #MSG
  )
  (setq #pt$ CG_GAIKEI)
  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
  (setq #BG_S1    (nth 0 &WTInfo1)) ; �㐂��V�t�g��
  (setq #BG_S2    (nth 0 &WTInfo2)) ; �㐂��V�t�g��
  (setq #BG_S3    (nth 0 &WTInfo3)) ; �㐂��V�t�g��

;;; ��U�^��
;;;       end1     x11 x1
;;; p1+(BASE1)-----*---*------------------------+p2   <---BG�w��
;;;   |   |        |   |                        |
;;; end2--+p11-----dum1|------------------------+p22  <---BG�O��
;;;   |   |        |   |                        |
;;;   |   |     +p444--|------------------------+p333 <---FG�w��
;;;   |   |     |  |   |                        |
;;;x22* - dum2- - -*sp1|             �ݸ��      | x1,x2 x11,x22�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp1��J��Ď��̕���_
;;;   |   |     |      |                        |
;;;   |   |     |    +p4------------------------+p3
;;; x2* - - - - - - - -+------------------------+p33  <---FG�O��
;;;   |   |     |    | |p44
;;;   |   |     |    | |
;;;   |   |��ۑ�|    | |
;;;   |   |     |    | |
;;;   |   |     |    | |
;;; x3* - - - - - - - -+p55----------------------+p66  <---FG�O��
;;;   |   |     |    +p5-------------------------+p6
;;;   |   |     |      |                         |
;;;x33* - dum3- - -*sp2|          ���̑�         | x3,x4 x33,x44�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp2��J��Ď��̕���_
;;;   |   |     |  |   |                         |
;;;   |   |     +p555--|-------------------------+p666 <---FG�w��
;;;   |   |        |   |                         |
;;; end3--+p88-----dum4|-------------------------+p77  <---BG�O��
;;;   |   |        |   |                         |
;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG�w��
;;;       end4    x44 x4

;;; �Vۼޯ� YM �O�`�_��-->��Ű��_ PKGetBaseL6
  (setq #BASEPT$ (PKGetBaseU8 #pt$))
  (if (or (= nil (car #BASEPT$)) (= nil (cadr #BASEPT$)))
    (progn
      ;2008/08/20 YM MOD-S CAD���ް�ŕ\�����o�Ȃ��悤�ɂ���
      (setq #msg "��Ű��_���擾�ł��܂���ł���")      
      (cond
        ((= CG_AUTOMODE 0)
          (CMN_OutMsg #msg)
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog #msg)
          (quit)
        )
      );_cond
      ;2008/08/20 YM MOD-S CAD���ް�ŕ\�����o�Ȃ��悤�ɂ���
    )
  );_if
  (setq #pt$ (GetPtSeries (car #BASEPT$) #pt$)) ; �O�`�_��&pt$��#BASEPT��擪�Ɏ��v����ɂ���
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))
  (setq #p7 (nth 6 #pt$))
  (setq #p8 (nth 7 #pt$))
;;; WT�g���Ή�
  (setq #x2 (CFGetDropPt #p4 (list #p1 #p8)))

  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL  (if (> #BG_S1 0.1) ; �ݸ��
;;;02/01/21YM@DEL   (progn
      (setq #p2 (polar #p2 (angle #p3 #p2) #BG_S1))
      (setq #p1 (polar #p1 (angle #p8 #p1) #BG_S1))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL  (if (> #BG_S2 0.1) ; ��ۑ�
;;;02/01/21YM@DEL   (progn
      (setq #p1 (polar #p1 (angle #p2 #p1) #BG_S2))
      (setq #p8 (polar #p8 (angle #p7 #p8) #BG_S2))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM ���s���g��<0������
;;;02/01/21YM@DEL  (if (> #BG_S3 0.1) ; ���̑���
;;;02/01/21YM@DEL   (progn
      (setq #p8 (polar #p8 (angle #p6 #p7) #BG_S3))
      (setq #p7 (polar #p7 (angle #p6 #p7) #BG_S3))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  (setq #ddd (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #ang (angle #ddd #p4))

  (setq #p33  (polar #p3   (angle #p2 #p3) #FG_S)) ; WT��ėʕ�
  (setq #p66  (polar #p6   (angle #p7 #p6) #FG_S)) ; WT��ėʕ�
  (setq #ddd (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #ddd1 (polar #p4   (angle #p2 #p3) #FG_S)) ; WT��ėʕ�
  (setq #ddd2 (polar #p4   #ang            #FG_S)) ; WT��ėʕ�
  (setq #ddd3 (polar #p5   #ang            #FG_S)) ; WT��ėʕ�
  (setq #ddd4 (polar #p5   (angle #p7 #p6) #FG_S)) ; WT��ėʕ�
  (setq #p44  (inters #p33 #ddd1 #ddd2 #ddd3 nil))
  (setq #p55  (inters #ddd2 #ddd3 #p66 #ddd4 nil))

  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (setq CG_GAIKEI (list #p1 #p2 #p33 #p44 #p55 #p66 #p7 #p8))
  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

);PKMakeTeimenPline_U_ALL

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKUcut0
;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 U�^��ĂȂ�(ID=0)
;;; <�߂�l>    :
;;; <�쐬>      : 00/09/27 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKUcut0 (
  &WTInfo
  &point$
  &BGFG_Info
  /
  #BG_EN$ #BG_EN1 #BG_EN2 #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP1 #DEP2 #DEP3
  #end1 #end2 #end3 #end4 #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
  #RET #RET$ #WT_EN #WT_LEN1 #WT_LEN2 #WT_LEN3 #X11 #FG_T
#BG_T #PA #PB #PC #PD #TOP_FLG #BG_SEP #FG_S ;03/10/14 YM ADD
  )
  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�

;;; ��U�^��
;;;       end1     x11 x1
;;; p1+(BASE1)-----*---*------------------------+p2   <---BG�w��
;;;   |   |        |   |                        |
;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG�O��
;;;   |   |        |   |                        |
;;;   |   |     +p444--|------------------------+p333 <---FG�w��
;;;   |   |     |  |   |                        |
;;;x22* - dum2- - -*sp1|             �ݸ��      | x1,x2 x11,x22�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp1��J��Ď��̕���_
;;;   |   |     |      |                        |
;;;   |   |     |    +p4------------------------+p3
;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG�O��
;;;   |   |     |    | |p44
;;;   |   |     |    | |
;;;   |   |��ۑ�|    | |
;;;   |   |     |    | |
;;;   |   |     |    | |
;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG�O��
;;;   |   |     |    +p5-------------------------+p6
;;;   |   |     |      |                         |
;;;x33* - dum3- - -*sp2|          ���̑�         | x3,x4 x33,x44�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp2��J��Ď��̕���_
;;;   |   |     |  |   |                         |
;;;   |   |     +p555--|-------------------------+p666 <---FG�w��
;;;   |   |        |   |                         |
;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG�O��
;;;   |   |        |   |                         |
;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG�w��
;;;       end4    x44 x4

  (setq #p1 (nth 0 &point$))
  (setq #p2 (nth 1 &point$))
  (setq #p3 (nth 2 &point$))
  (setq #p4 (nth 3 &point$))
  (setq #p5 (nth 4 &point$))
  (setq #p6 (nth 5 &point$))
  (setq #p7 (nth 6 &point$))
  (setq #p8 (nth 7 &point$))

  (setq #p11 (nth  8 &point$))
  (setq #p22 (nth  9 &point$))
  (setq #p33 (nth 10 &point$))
  (setq #p44 (nth 11 &point$))
  (setq #p55 (nth 12 &point$))
  (setq #p66 (nth 13 &point$))
  (setq #p77 (nth 14 &point$))
  (setq #p88 (nth 15 &point$))

  (setq #p333 (nth 16 &point$))
  (setq #p444 (nth 17 &point$))
  (setq #p555 (nth 18 &point$))
  (setq #p666 (nth 19 &point$))

  ;03/09/22 YM ADD ����į���׸ޑΉ�
  ; BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG���ݕ�

  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FG���� 1:�Б� 2:����
  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FG���� 1:�Б� 2:����
  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FG���� 1:�Б� 2:����

  (setq #end1 (inters #p11 #p88 #p2 #p1 nil))
  (setq #end2 (inters #p11 #p22 #p1 #p8 nil))
  (setq #end3 (inters #p77 #p88 #p1 #p8 nil))
  (setq #end4 (inters #p11 #p88 #p8 #p7 nil))

;-- 2011/08/25 A.Satoh Mod - S
;  (cond
;    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 1 0.1)) ; 111
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11 #p88 #pC #pD #p66 #p7 #p8)))
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p88 #p77 #p7 #p8)))
;      );_if
;    )
;    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 0 0.1)) ; 110
;      (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #end4 #p8)))
;    )
;    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 1 0.1)) ; 101
;      (CFAlertMsg "\n�����ޯ��ް�ނ̑g�ݍ��킹�́A�Ή����Ă��܂���B")(quit)
;    )
;    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 0 0.1)) ; 100
;      (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;    )
;    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 1 0.1)) ; 011
;      (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #p88 #p77 #p7 #p8)))
;    )
;    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 0 0.1)) ; 010
;      (setq #bg_en1 (MakeTEIMEN (list #p8 #p1 #end1 #end4)))
;    )
;    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 1 0.1)) ; 001
;      (setq #bg_en1 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
;    )
;    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 0 0.1)) ; 000 ; BG�Ȃ�
;      (setq #bg_en1 nil)
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;  (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p66 #p666 #p555 #p444 #p333))) ; �O������
;
;  (cond
;    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 2 0.1)) ; 222
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p88 #p77 #p7 #p8)))
;    )
;    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 1 0.1)) ; 221
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #end4 #p8)))
;    )
;    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 2 0.1)) ; 212
;      (CFAlertMsg "\n�����ޯ��ް�ނ̑g�ݍ��킹�́A�Ή����Ă��܂���B")(quit)
;    )
;    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 1 0.1)) ; 211
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;    )
;    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 2 0.1)) ; 122
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #p88 #p77 #p7 #p8)))
;    )
;    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 1 0.1)) ; 121
;      (setq #fg_en2 (MakeTEIMEN (list #p8 #p1 #end1 #end4)))
;    )
;    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 2 0.1)) ; 112
;      (setq #fg_en2 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
;    )
;    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 1 0.1)) ; 111 �ʏ�O����
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
  (cond
    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 1 0.1)) ; 111
      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
        (progn
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11 #p88 #pC #pD #p66 #p7 #p8)))
          (setq #bg_en2 nil)
        )
        ;else �ʏ�
        (progn
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p88 #p77 #p7 #p8)))
          (setq #bg_en2 nil)
        )
      );_if
    )
    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 0 0.1)) ; 110
      (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #end4 #p8)))
      (setq #bg_en2 nil)
    )
    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 1 0.1)) ; 101
      (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
      (setq #bg_en2 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
    )
    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 1 0.1)) ; 011
      (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #p88 #p77 #p7 #p8)))
      (setq #bg_en2 nil)
    )
    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 0 0.1)) ; 100
      (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
      (setq #bg_en2 nil)
    )
    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 0 0.1)) ; 010
      (setq #bg_en1 (MakeTEIMEN (list #p8 #p1 #end1 #end4)))
      (setq #bg_en2 nil)
    )
    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 1 0.1)) ; 001
      (setq #bg_en1 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
      (setq #bg_en2 nil)
    )
    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 0 0.1)) ; 000 ; BG�Ȃ�
      (setq #bg_en1 nil)
      (setq #bg_en2 nil)
    )
    (T
      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
    )
  );_cond
  (setq #bg_en$ (list #bg_en1 #bg_en2))

  (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p66 #p666 #p555 #p444 #p333))) ; �O������
  (cond
    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 2 0.1)) ; 222
      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p88 #p77 #p7 #p8)))
    )
    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 1 0.1)) ; 221
      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #end4 #p8)))
    )
    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 2 0.1)) ; 212
      (CFAlertMsg "\n���̑O����̑g�ݍ��킹�́A�Ή����Ă��܂���B")(quit)
    )
    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 2 0.1)) ; 122
      (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #p88 #p77 #p7 #p8)))
    )
    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 1 0.1)) ; 211
      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
    )
    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 1 0.1)) ; 121
      (setq #fg_en2 (MakeTEIMEN (list #p8 #p1 #end1 #end4)))
    )
    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 2 0.1)) ; 112
      (setq #fg_en2 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
    )
    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 1 0.1)) ; 111 �ʏ�O����
      (setq #fg_en2 nil)
    )
    (T
      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
    )
  );_cond

  (setq #fg_en$ (list #fg_en1 #fg_en2))
;-- 2011/08/25 A.Satoh Mod - E

  (setq #wt_en (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p55 #p66 #p7 #p8)))         ; ܰ�į�ߒ�� �S��
  (setq #cut_type "00")
  (setq #dep1 (distance #p2 #p33))
  (setq #dep2 (distance (CFGetDropPt #p44 (list #p1 #p8)) #p44))
  (setq #dep3 (distance #p7 #p66))
  (setq #WT_LEN1 (distance #p1 #p2))
  (setq #WT_LEN2 (distance #p1 #p8))
  (setq #WT_LEN3 (distance #p7 #p8))
  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep1 #dep2 #dep3) (list #WT_LEN1 #WT_LEN2 #WT_LEN3) #p1 2))
  (setq #ret$ (append #ret$ (list #ret)))
  #ret$
);PKUcut0

;-- 2011/08/25 A.Satoh Del - S
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PKUcut1
;;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 U�^�΂߶��(ID=1)
;;;; <�߂�l>    :
;;;; <�쐬>      : 00/09/27 YM �W����
;;;; <���l>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut1 (
;  &WTInfo
;  &ZaiCode
;  &outpl_LOW
;  &point$
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP
;  #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #RET #RET$ #WT_EN #WT_LEN
;  #DUMPT1 #DUMPT2 #FG_T
;#BG_T #PA #PB #PC #PD #TOP_FLG #BG_SEP #FG_S ;03/10/14 YM ADD
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
;  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
;  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;
;;;; ��U�^��
;;;;       end1     x11 x1
;;;; p1+(BASE1)-----*---*------------------------+p2   <---BG�w��
;;;;   |   |        |   |                        |
;;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG�O��
;;;;   |   |        |   |                        |
;;;;   |   |     +p444--|------------------------+p333 <---FG�w��
;;;;   |   |     |  |   |                        |
;;;;x22* - dum2- - -*sp1|             �ݸ��      | x1,x2 x11,x22�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp1��J��Ď��̕���_
;;;;   |   |     |      |                        |
;;;;   |   |     |    +p4------------------------+p3
;;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG�O��
;;;;   |   |     |    | |p44
;;;;   |   |     |    | |
;;;;   |   |��ۑ�|    | |
;;;;   |   |     |    | |
;;;;   |   |     |    | |
;;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG�O��
;;;;   |   |     |    +p5-------------------------+p6
;;;;   |   |     |      |                         |
;;;;x33* - dum3- - -*sp2|          ���̑�         | x3,x4 x33,x44�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp2��J��Ď��̕���_
;;;;   |   |     |  |   |                         |
;;;;   |   |     +p555--|-------------------------+p666 <---FG�w��
;;;;   |   |        |   |                         |
;;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG�O��
;;;;   |   |        |   |                         |
;;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG�w��
;;;;       end4    x44 x4
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  ;03/09/22 YM ADD ����į���׸ޑΉ�
;  ; BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;
;;;;;;;;; (�ݸ��) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG��ʍ�}
;  (cond
;    ((equal #BG_Type1 1 0.1)
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11))) ; �ݸ��BG����
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11))) ; �ݸ��BG����
;      );_if
;    )
;    ((equal #BG_Type1 0 0.1)
;      (setq #bg_en1 nil)                                   ; �ݸ��BG�Ȃ�
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p444 #p333))) ; �O������ؽ� �ݸ��
;      (setq #fg_en2 nil)                                   ; �ݸ��FG�ʏ�
;    )
;    ((equal #FG_Type1 2 0.1) ; FG����
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p444 #p333))) ; �O������ؽ� �ݸ��
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11))) ; �ݸ��FG����
;    )
;    ((equal #FG_Type1 3 0.1) ; FG�O��E
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #p11)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (list #p1  #p2  #p33  #p44)))   ; ܰ�į�ߒ��
;  (setq #WT_LEN (distance #p1 #p2))
;  (setq #dep (distance #p33 #p2))
;  (setq #cut_type "30")             ; H���
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;      (setq #cut_type "34")         ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p1 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (��ۑ�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG��ʍ�}
;  (cond
;    ((equal #BG_Type2 1 0.1) ; BG����
;      (setq #bg_en1 (MakeTEIMEN (list #p1 #p8 #p88 #p11))) ; ��ۑ�BG����
;    )
;    ((equal #BG_Type2 0 0.1)
;      (setq #bg_en1 nil)                                      ; ��ۑ�BG�Ȃ�
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p44 #p55 #p555 #p444)))    ; �O������ؽ� ��ۑ�
;      (setq #fg_en2 nil)                                      ; ��ۑ�FG�ʏ�
;    )
;    ((equal #FG_Type2 2 0.1) ; FG����
;      (setq #fg_en1 (MakeTEIMEN (list #p44 #p55 #p555 #p444))) ; �O������ؽ� ��ۑ��O
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p8 #p88 #p11)))     ; ��ۑ�FG���
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (list #p1  #p8  #p55  #p44)))      ; ܰ�į�ߒ��
;  (setq #WT_LEN (distance #p1 #p8))
;  (setq #dep (distance #p44 (CFGetDropPt #p44 (list #p1 #p8))))
;  (setq #cut_type "33")
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p8 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (���̑�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG��ʍ�}
;  (cond
;    ((equal #BG_Type3 1 0.1) ; BG����
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #p8 #p7 #p66 #pD #pC #p88))) ; 3����BG����
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #p8 #p7 #p77 #p88))) ; 3����BG����
;      );_if
;    )
;    ((equal #BG_Type3 0 0.1)
;      (setq #bg_en1 nil)                                   ; 3����BG�Ȃ�
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type3 1 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); �O������ؽ� 3����
;      (setq #fg_en2 nil)                                      ; 3����FG�ʏ�
;    )
;    ((equal #FG_Type3 2 0.1) ; FG����
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); �O������ؽ� 3���ڑO
;      (setq #fg_en2 (MakeTEIMEN (list #p8 #p7 #p77 #p88)))    ; 3����FG�������
;    )
;    ((equal #FG_Type3 3 0.1) ; FG�O�㍶
;      (setq #dumPT1 (polar #p666 (angle #p7 #p8) #FG_T))
;      (setq #dumPT2 (polar #p77  (angle #p7 #p8) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p8 #p7 #p66 #p55 #p555 #dumPT1 #dumPT2 #p88)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (list #p8  #p7  #p66  #p55)))      ; ܰ�į�ߒ��
;  (setq #dep (distance #p7 #p66))
;  (setq #WT_LEN (distance #p7 #p8))
;  (setq #cut_type "03")             ; H���
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p7 &outpl_LOW) ; T or nil
;      (setq #cut_type "43")         ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p7 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKUcut1
;
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PKUcut2
;;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 U�^�������(ID=2)
;;;; <�߂�l>    :
;;;; <�쐬>      : 00/09/27 YM �W����
;;;; <���l>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut2 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$
;  &BGFG_Info
;  /
;  #CUTPT1 #CUTPT2 #EN_DUM1 #EN_DUM2 #CUTIN #FG_T
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #POINT2$ #PTN #RET$ #SP1 #SP2 #X1 #X11 #X2 #X22 #X3 #X33 #X4 #X44
;  #BG_SEP #BG_T #FG_S #TOP_FLG
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
;  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
;  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  ;;; �����̑������߂� #x1,#x2
;  (setq #x1 (CFGetDropPt #p44 (list #p1 #p2)))
;  (setq #x2 (CFGetDropPt #p44 (list #p1 #p8)))
;  (setq #x3 (CFGetDropPt #p55 (list #p1 #p8)))
;  (setq #x4 (CFGetDropPt #p55 (list #p7 #p8)))
;
;  ;;; հ�ް�ɶ�ĕ������w��
;  (setq #CutPt1 nil)
;  (setq #CutPt2 nil)
;
;;;;01/06/25YM@  (MakeLWPL (list #p44 #sp1 #x11) 0)
;  (MakeLWPL (list #p44 (polar #x1 (angle #p8 #p1) 100)) 0) ; 01/06/25 YM MOD
;  (setq #en_dum1 (entlast))
;  (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;  (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; �F��ς���
;
;;;;01/06/25YM@  (MakeLWPL (list #p44 #sp1 #x22) 0)
;  (MakeLWPL (list #p44 (polar #x2 (angle #p2 #p1) 100)) 0) ; 01/06/25 YM MOD
;  (setq #en_dum2 (entlast))
;  (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;  (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; �F��ς���
;
;  (setq #CutPt1 (getpoint "\n�J�b�g�������w��: "))
;  (entdel #en_dum1)
;  (entdel #en_dum2)
;
;;;;01/06/25YM@  (MakeLWPL (list #p55 #sp2 #x33) 0)
;  (MakeLWPL (list #p55 (polar #x3 (angle #p2 #p1) 100)) 0) ; 01/06/25 YM MOD
;  (setq #en_dum1 (entlast))
;  (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;  (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; �F��ς���
;
;;;;01/06/25YM@  (MakeLWPL (list #p55 #sp2 #x44) 0)
;  (MakeLWPL (list #p55 (polar #x4 (angle #p1 #p8) 100)) 0) ; 01/06/25 YM MOD
;  (setq #en_dum2 (entlast))
;  (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;  (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; �F��ς���
;
;  (setq #CutPt2 (getpoint "\n�J�b�g�������w��: "))
;  (entdel #en_dum1)
;  (entdel #en_dum2)
;
;;;; X��Ă̕����w�� U�z��̏ꍇ�A�����w����2��s��
;;;;   +--------(1)-----------------+
;;;;   |         |                  |
;;;;   |         |                  |
;;;;  (2)--------+------------------+
;;;;   |         | ����� (1)��(3)=>#ptn=1
;;;;   |         |       (1)��(4)=>#ptn=2
;;;;   |         |       (2)��(3)=>#ptn=3
;;;;   |         |       (2)��(4)=>#ptn=4
;;;;  (3)--------+------------------+
;;;;   |         |                  |
;;;;   |         |                  |
;;;;   +--------(4)-----------------+
;
;  (if (< (distance #CutPt1 #x1) (distance #CutPt1 #x2))
;    (progn
;      (if (< (distance #CutPt2 #x3) (distance #CutPt2 #x4))
;        (setq #ptn 1)
;        (setq #ptn 2)
;      );_if
;    )
;    (progn
;      (if (< (distance #CutPt2 #x3) (distance #CutPt2 #x4))
;        (setq #ptn 3)
;        (setq #ptn 4)
;      );_if
;    )
;  );_if
;
;  ;03/10/13 YM ADD-S KDA�Ή� ������Ă̐؂荞�ݕ�
;  (if (equal (KPGetSinaType) 4 0.1);KDA�Ή�
;    (setq CG_LenDircut 75);KDA
;    (setq CG_LenDircut 50);KSA,KGA,KNA
;  );_if
;
;  (setq #cutin CG_LenDircut) ; �؂荞�ݕ��Œ�
;
;;;;01/07/02YM@  ; �؂荞�ݕ�����
;;;;01/07/02YM@  (setq #cutin nil)
;;;;01/07/02YM@  (setq #cutin (getreal "\n�؂荞�ݕ�<0.0>: "))
;;;;01/07/02YM@  (if (= #cutin nil)(setq #cutin 0.0))
;
;  ;;; WT��ėʕ��ړ�
;  (setq #x11 (polar #x1 (angle #p2 #p1) #cutin))
;  (setq #x22 (polar #x2 (angle #p8 #p1) #cutin))
;  (setq #x33 (polar #x3 (angle #p1 #p8) #cutin))
;  (setq #x44 (polar #x4 (angle #p7 #p8) #cutin))
;  (setq #sp1 (polar #p44 (angle #p8 #p1) #cutin))
;  (setq #sp1 (polar #sp1 (angle #p2 #p1) #cutin))
;  (setq #sp2 (polar #p55 (angle #p2 #p1) #cutin))
;  (setq #sp2 (polar #sp2 (angle #p1 #p8) #cutin))
;  (setq #point2$ (list #x1 #x2 #x3 #x4 #x11 #x22 #x33 #x44 #sp1 #sp2))
;
;  (cond
;    ((= #ptn 1)
;      (setq #ret$ (PKUcut2-1 &WTInfo &ZaiCode &outpl_LOW &point$ #point2$ &BGFG_Info))
;    )
;    ((= #ptn 2)
;      (setq #ret$ (PKUcut2-2 &WTInfo &ZaiCode &outpl_LOW &point$ #point2$ &BGFG_Info))
;    )
;    ((= #ptn 3)
;      (setq #ret$ (PKUcut2-3 &WTInfo &ZaiCode &outpl_LOW &point$ #point2$ &BGFG_Info))
;    )
;    ((= #ptn 4)
;      (setq #ret$ (PKUcut2-4 &WTInfo &ZaiCode &outpl_LOW &point$ #point2$ &BGFG_Info))
;    )
;  );_cond
;  #ret$
;);PKUcut2
;-- 2011/08/25 A.Satoh Del - E

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetBG_TEIMEN
;;; <�����T�v>  : BG������ײݍ쐬
;;; <�߂�l>    : BG������ײ�
;;; <�쐬>      : 00/09/28 YM
;;; <���l>      : ����Z�k
;;;*************************************************************************>MOH<
(defun PKGetBG_TEIMEN (
  &BG_Type  ; BG�L�� 0:�Ȃ� 1:����
  &BG_SEP   ; BG���� 0:��� 1:����
  &lis1     ; BG��̎��̒�ʒ��_ؽ�
  &lis2     ; BG�������̒�ʒ��_ؽ�
  /
  #BG_EN1
  )
  (cond
    ((equal &BG_Type 1 0.1)
      (cond
        ((equal &BG_SEP 0 0.1)
          (setq #bg_en1 (MakeTEIMEN &lis1)) ; (��̌^)
        )
        ((equal &BG_SEP 1 0.1)
          (setq #bg_en1 (MakeTEIMEN &lis2)) ; (�����^)
        )
        (T
          (CFAlertMsg "\nBG�����^���߂��s���ł��B")(quit)
        )
      );_cond
    )
    ((equal &BG_Type 0 0.1)
      (setq #bg_en1 nil)                    ; BG�Ȃ�
    )
    (T
      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
    )
  );_cond
  #bg_en1
);PKGetBG_TEIMEN

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetFG_TEIMEN
;;; <�����T�v>  : FG������ײݍ쐬
;;; <�߂�l>    : FG������ײ�
;;; <�쐬>      : 00/09/28 YM
;;; <���l>      : ����Z�k
;;;*************************************************************************>MOH<
(defun PKGetFG_TEIMEN (
  &FG_Type  ; FG���� 1:�O�� 2:����
  &BG_SEP   ; BG���� 0:��� 1:����
  &lis1     ; BG��̎��̒�ʒ��_
  &lis2     ; BG�������̒�ʒ��_
  /
  #FG_EN2
  )
  (cond
    ((equal &FG_Type 2 0.1) ; ��������
      (cond
        ((equal &BG_SEP 0 0.1)
          (setq #fg_en2 (MakeTEIMEN &lis1)) ; ��̌^
        )
        ((equal &BG_SEP 1 0.1)
          (setq #fg_en2 (MakeTEIMEN &lis2)) ; ����
        )
        (T
          (CFAlertMsg "\nBG�����^���߂��s���ł��B")(quit)
        )
      );_cond
    )
    ((equal &FG_Type 1 0.1)
      (setq #fg_en2 nil)                    ; FG�ʏ�
    )
    (T
      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
    )
  );_cond
  #fg_en2
);PKGetFG_TEIMEN

;-- 2011/08/25 A.Satoh Del - S
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PKUcut2-1
;;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 U�^�������(ID=2) �����1
;;;; <�߂�l>    :
;;;; <�쐬>      : 00/09/27 YM �W����
;;;; <���l>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut2-1 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$  ;�_��
;  &point2$ ;�_��2
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #BG_SEP #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP
;  #DUM1 #DUM2 #DUM3 #DUM4 #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #RET #RET$ #SP1 #SP2 #WT_EN #WT_LEN #X1 #X11 #X2 #X22 #X3 #X33 #X4 #X44 #end1 #end2 #end3 #end4
;  #LIS1 #LIS2
;  #DUMPT1 #DUMPT2 #FG_T
;#BG_T #PA #PB #PC #PD #TOP_FLG #FG_S ;03/10/14 YM ADD
;  )
;;;; ��U�^��
;;;;       end1     x11 x1
;;;; p1+(BASE1)-----*---*------------------------+p2   <---BG�w��
;;;;   |   |        |   |                        |
;;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG�O��
;;;;   |   |        |   |                        |
;;;;   |   |     +p444--|------------------------+p333 <---FG�w��
;;;;   |   |     |  |   |                        |
;;;;x22* - dum2- - -*sp1|             �ݸ��      | x1,x2 x11,x22�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp1��J��Ď��̕���_
;;;;   |   |     |      |                        |
;;;;   |   |     |    +p4------------------------+p3
;;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG�O��
;;;;   |   |     |    | |p44
;;;;   |   |     |    | |
;;;;   |   |��ۑ�|    | |
;;;;   |   |     |    | |
;;;;   |   |     |    | |
;;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG�O��
;;;;   |   |     |    +p5-------------------------+p6
;;;;   |   |     |      |                         |
;;;;x33* - dum3- - -*sp2|          ���̑�         | x3,x4 x33,x44�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp2��J��Ď��̕���_
;;;;   |   |     |  |   |                         |
;;;;   |   |     +p555--|-------------------------+p666 <---FG�w��
;;;;   |   |        |   |                         |
;;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG�O��
;;;;   |   |        |   |                         |
;;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG�w��
;;;;       end4    x44 x4
;
;  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
;  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
;  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  (setq #x1  (nth 0 &point2$))
;  (setq #x2  (nth 1 &point2$))
;  (setq #x3  (nth 2 &point2$))
;  (setq #x4  (nth 3 &point2$))
;  (setq #x11 (nth 4 &point2$))
;  (setq #x22 (nth 5 &point2$))
;  (setq #x33 (nth 6 &point2$))
;  (setq #x44 (nth 7 &point2$))
;  (setq #sp1 (nth 8 &point2$))
;  (setq #sp2 (nth 9 &point2$))
;  (setq #dum1 (CFGetDropPt #p22 (list #sp1 #x11)))
;  (setq #dum2 (CFGetDropPt #p11 (list #sp1 #x22)))
;  (setq #dum3 (CFGetDropPt #p11 (list #sp2 #x33)))
;  (setq #dum4 (CFGetDropPt #p77 (list #sp2 #x44)))
;  (setq #end1 (inters #p11 #p88 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p8 nil))
;  (setq #end3 (inters #p77 #p88 #p1 #p8 nil))
;  (setq #end4 (inters #p11 #p88 #p8 #p7 nil))
;
;  ;03/09/22 YM ADD ����į���׸ޑΉ�
;  ; BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_SEP   (nth 6 &BGFG_Info)) ; �����^:1 ��̌^:0
;
;;;;;;;;; (�ݸ��) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type1 1 0.1) ; BG����
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #pA #pB #dum1))) ; �ޯ��ް�ޒ��
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p22 #dum1))) ; �ޯ��ް�ޒ��
;      );_if
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type1 0 0.1) ; BG�Ȃ�
;      (setq #bg_en$ (list nil nil))
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; �ʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; �O����O
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type1 2 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; �O����O
;      (setq #fg_en2 (MakeTEIMEN (list #x11 #p2 #p22 #dum1))) ; �O������
;    )
;    ((equal #FG_Type1 3 0.1) ; FG�O��E
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #dum1)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x11 #p2 #p33))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #p2 #x11))
;  (setq #WT_LEN (distance #p44 #p33)) ; 01/07/02 Y-CUT
;  (setq #cut_type "20")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;      (setq #cut_type "24")         ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #x11 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (��ۑ�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type2 1 0.1) ; 2����BG����
;      (cond
;        ((equal #BG_Type1 1 0.1) ; 1����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #x11 #p1 #x33 #dum3 #p11 #dum1)))
;        )
;        ((equal #BG_Type1 0 0.1) ; 1����BG�Ȃ�
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #dum3 #x33)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type2 0 0.1) ; BG�Ȃ�
;      (cond
;        ((equal #BG_Type1 1 0.1) ; 1����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #x11 #dum1 #end2)))
;        )
;        ((equal #BG_Type1 0 0.1) ; 1����BG�Ȃ�
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; �ʏ�Б�
;      (cond
;        ((equal #FG_Type1 1 0.1) ; 1����FG�O�̂�
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type1 2 0.1) ; 1����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #x11 #dum1 #end2)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type2 2 0.1) ; FG�O��
;      (cond
;        ((equal #FG_Type1 1 0.1) ; 1����FG�O�̂�
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #dum3 #x33)))
;        )
;        ((equal #FG_Type1 2 0.1) ; 1����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #x11 #p1 #x33 #dum3 #p11 #dum1))) ; �O������
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; �O����O
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p1 #x33 #sp2 #p55 #p44 #sp1 #x11))))
;  (setq #WT_LEN (distance #p1 #x33))
;  (setq #cut_type "21")
;  (setq #dep (distance #p55 #x3))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #x33 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (���̑�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type3 1 0.1) ; 3����BG����
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2����BG����
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;            (setq #bg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p66 #pD #pC #p88 #dum3)))
;            ;else �ʏ�
;            (setq #bg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p77 #p88 #dum3)))
;          );_if
;        )
;        ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;          (setq #bg_en1 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type3 0 0.1)
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #x33 #dum3 #end4 #p8)))
;        )
;        ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type3 1 0.1) ; 3����FG�O��
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2����FG�O�̂�
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type2 2 0.1) ; 2����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #x33 #dum3 #end4 #p8)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type3 2 0.1) ; 3����FG����
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2����FG�O�̂�
;          (setq #fg_en2 (MakeTEIMEN (list #end3 #p8 #p7 #p77)))
;        )
;        ((equal #FG_Type2 2 0.1) ; 2����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #x33 #p8 #p7 #p77 #p88 #dum3)))
;        )
;      );_cond
;
;
;    )
;    ((equal #FG_Type3 3 0.1) ; 3����FG�O�㍶
;      (setq #dumPT1 (polar #p666 (angle #p7 #p8) #FG_T))
;      (setq #dumPT2 (polar #p77  (angle #p7 #p8) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p66 #p55 #p555 #dumPT1 #dumPT2 #p88 #dum3)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); �O������ؽ� 3����
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p8 #x33 #sp2 #p55 #p66 #p7))))
;  (setq #WT_LEN (distance #p8 #p7))
;  (setq #cut_type "01")
;  (setq #dep (distance #p66 #p7))
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p7 &outpl_LOW) ; T or nil
;      (setq #cut_type "41")         ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p7 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKUcut2-1
;
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PKUcut2-2
;;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 U�^�������(ID=2) �����2
;;;; <�߂�l>    :
;;;; <�쐬>      : 00/09/27 YM �W����
;;;; <���l>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut2-2 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$  ;�_��
;  &point2$ ;�_��2
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #BG_SEP #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP
;  #DUM1 #DUM2 #DUM3 #DUM4 #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #RET #RET$ #SP1 #SP2 #WT_EN #WT_LEN #X1 #X11 #X2 #X22 #X3 #X33 #X4 #X44 #end1 #end2 #end3 #end4
;  #LIS1 #LIS2
;  #DUMPT1 #DUMPT2 #FG_T
;#BG_T #PA #PB #PC #PD #TOP_FLG #FG_S ;03/10/14 YM ADD
;  )
;;;; ��U�^��
;;;;       end1     x11 x1
;;;; p1+(BASE1)-----*---*------------------------+p2   <---BG�w��
;;;;   |   |        |   |                        |
;;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG�O��
;;;;   |   |        |   |                        |
;;;;   |   |     +p444--|------------------------+p333 <---FG�w��
;;;;   |   |     |  |   |                        |
;;;;x22* - dum2- - -*sp1|             �ݸ��      | x1,x2 x11,x22�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp1��J��Ď��̕���_
;;;;   |   |     |      |                        |
;;;;   |   |     |    +p4------------------------+p3
;;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG�O��
;;;;   |   |     |    | |p44
;;;;   |   |     |    | |
;;;;   |   |��ۑ�|    | |
;;;;   |   |     |    | |
;;;;   |   |     |    | |
;;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG�O��
;;;;   |   |     |    +p5-------------------------+p6
;;;;   |   |     |      |                         |
;;;;x33* - dum3- - -*sp2|          ���̑�         | x3,x4 x33,x44�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp2��J��Ď��̕���_
;;;;   |   |     |  |   |                         |
;;;;   |   |     +p555--|-------------------------+p666 <---FG�w��
;;;;   |   |        |   |                         |
;;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG�O��
;;;;   |   |        |   |                         |
;;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG�w��
;;;;       end4    x44 x4
;
;  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
;  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
;  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  (setq #x1  (nth 0 &point2$))
;  (setq #x2  (nth 1 &point2$))
;  (setq #x3  (nth 2 &point2$))
;  (setq #x4  (nth 3 &point2$))
;  (setq #x11 (nth 4 &point2$))
;  (setq #x22 (nth 5 &point2$))
;  (setq #x33 (nth 6 &point2$))
;  (setq #x44 (nth 7 &point2$))
;  (setq #sp1 (nth 8 &point2$))
;  (setq #sp2 (nth 9 &point2$))
;  (setq #dum1 (CFGetDropPt #p22 (list #sp1 #x11)))
;  (setq #dum2 (CFGetDropPt #p11 (list #sp1 #x22)))
;  (setq #dum3 (CFGetDropPt #p11 (list #sp2 #x33)))
;  (setq #dum4 (CFGetDropPt #p77 (list #sp2 #x44)))
;  (setq #end1 (inters #p11 #p88 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p8 nil))
;  (setq #end3 (inters #p77 #p88 #p1 #p8 nil))
;  (setq #end4 (inters #p11 #p88 #p8 #p7 nil))
;
;  ;03/09/22 YM ADD ����į���׸ޑΉ�
;  ; BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_SEP   (nth 6 &BGFG_Info)) ; �����^:1 ��̌^:0
;
;;;;;;;;; (�ݸ��) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type1 1 0.1) ; BG����
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #pA #pB #dum1))) ; �ޯ��ް�ޒ��
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p22 #dum1))) ; �ޯ��ް�ޒ��
;      );_if
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type1 0 0.1) ; BG�Ȃ�
;      (setq #bg_en$ (list nil nil))
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; �ʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; �O����O
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type1 2 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; �O����O
;      (setq #fg_en2 (MakeTEIMEN (list #x11 #p2 #p22 #dum1))) ; �O������
;    )
;    ((equal #FG_Type1 3 0.1) ; FG�O��E
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #dum1)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x11 #p2 #p33))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #p2 #x11))
;  (setq #WT_LEN (distance #p44 #p33)) ; 01/07/02 Y-CUT
;  (setq #cut_type "20")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;      (setq #cut_type "24")         ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #x11 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (��ۑ�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type2 1 0.1) ; BG����
;      (cond
;        ((and (equal #BG_Type1 1 0.1)(equal #BG_Type3 1 0.1)) ; 1,3����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #x11 #p1 #p8 #x44 #dum4 #p88 #p11 #dum1)))
;        )
;        ((and (equal #BG_Type1 0 0.1)(equal #BG_Type3 0 0.1)) ; 1,3����BG�Ȃ�
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #end4 #p8)))
;        )
;        ((and (equal #BG_Type1 1 0.1)(equal #BG_Type3 0 0.1)) ; 1����BG����,3����BG�Ȃ�
;          (setq #bg_en1 (MakeTEIMEN (list #x11 #p1 #p8 #end4 #p11 #dum1)))
;        )
;        ((and (equal #BG_Type1 0 0.1)(equal #BG_Type3 1 0.1)) ; 1����BG�Ȃ�,3����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #p8 #x44 #dum4 #p88 #end1)))
;        )
;      );_cond
;      (setq #bg_en2 nil)
;    )
;    ((equal #BG_Type2 0 0.1) ; BG�Ȃ�
;      (cond
;        ((and (equal #BG_Type1 1 0.1)(equal #BG_Type3 1 0.1)) ; 1,3����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #x11 #dum1 #end2)))
;          (setq #bg_en2 (MakeTEIMEN (list #end3 #dum4 #x44 #p8)))
;        )
;        ((and (equal #BG_Type1 0 0.1)(equal #BG_Type3 0 0.1)) ; 1,3����BG�Ȃ�
;          (setq #bg_en1 nil)
;          (setq #bg_en2 nil)
;        )
;        ((and (equal #BG_Type1 1 0.1)(equal #BG_Type3 0 0.1)) ; 1����BG����,3����BG�Ȃ�
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #x11 #dum1 #end2)))
;          (setq #bg_en2 nil)
;        )
;        ((and (equal #BG_Type1 0 0.1)(equal #BG_Type3 1 0.1)) ; 1����BG�Ȃ�,3����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #end3 #dum4 #x44 #p8)))
;          (setq #bg_en2 nil)
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; �ʏ�Б�
;      (cond
;        ((and (equal #FG_Type1 1 0.1)(equal #FG_Type3 1 0.1)) ; 1,3����FG�O
;          (setq #fg_en2 nil)
;        )
;        ((and (equal #FG_Type1 2 0.1)(equal #FG_Type3 2 0.1)) ; 1,3����FG�O��
;          (CFAlertMsg "��������݂͑Ή��ł��܂���B\n�ʂ�����݂�ܰ�į�߂��쐬��A�O����ǉ�����ނ��g�p���ĉ������B")
;          (*error*)
;        )
;        ((and (equal #FG_Type1 1 0.1)(equal #FG_Type3 2 0.1)) ; 1����FG�O,3����BG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #end3 #dum4 #x44 #p8)))
;        )
;        ((and (equal #FG_Type1 2 0.1)(equal #FG_Type3 1 0.1)) ; 1����FG�O��,3����BG�O
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #x11 #dum1 #end2)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type2 2 0.1) ; FG�O��
;      (cond
;        ((and (equal #FG_Type1 1 0.1)(equal #FG_Type3 1 0.1)) ; 1,3����FG�O
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #end4 #p8)))
;        )
;        ((and (equal #FG_Type1 2 0.1)(equal #FG_Type3 2 0.1)) ; 1,3����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #x11 #p1 #p8 #x44 #dum4 #p88 #p11 #dum1)))
;        )
;        ((and (equal #FG_Type1 1 0.1)(equal #FG_Type3 2 0.1)) ; 1����FG�O,3����BG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #end1 #p1 #p8 #x44 #dum4 #p88)))
;        )
;        ((and (equal #FG_Type1 2 0.1)(equal #FG_Type3 1 0.1)) ; 1����FG�O��,3����BG�O
;          (setq #fg_en2 (MakeTEIMEN (list #x11 #p1 #p8 #end4 #p11 #dum1)))
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; �O����O
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p1 #p8 #x44 #sp2 #p55 #p44 #sp1 #x11))))
;  (setq #WT_LEN (distance #p1 #p8))
;  (setq #cut_type "11")
;  (setq #dep (distance #x2 #p44))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p8 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (���̑�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type3 1 0.1) ; BG����
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #x44 #p7 #p66 #pD #pC #dum4))) ; 3����BG����
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #x44 #p7 #p77 #dum4))) ; 3����BG����
;      );_if
;    )
;    ((equal #BG_Type3 0 0.1)
;      (setq #bg_en1 nil)                                   ; 3����BG�Ȃ�
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type3 1 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); �O������ؽ� 3����
;      (setq #fg_en2 nil)                                      ; 3����FG�ʏ�
;    )
;    ((equal #FG_Type3 2 0.1) ; FG����
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); �O������ؽ� 3���ڑO
;      (setq #fg_en2 (MakeTEIMEN (list #x44 #p7 #p77 #dum4)))    ; 3����FG�������
;    )
;    ((equal #FG_Type3 3 0.1) ; FG�O�㍶
;      (setq #dumPT1 (polar #p666 (angle #p7 #p8) #FG_T))
;      (setq #dumPT2 (polar #p77  (angle #p7 #p8) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x44 #p7 #p66 #p55 #p555 #dumPT1 #dumPT2 #dum4)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #x44 #sp2 #p55 #p66 #p7))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #x44 #p7))
;  (setq #WT_LEN (distance #p55 #p66)) ; 01/07/02 Y-CUT
;  (setq #cut_type "02")
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p7 &outpl_LOW) ; T or nil
;      (setq #cut_type "42")         ; �i��������
;    );_if
;  );_if
;  (setq #dep (distance #p66 #p7))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p7 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKUcut2-2
;
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PKUcut2-3
;;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 U�^�������(ID=2) �����3
;;;; <�߂�l>    :
;;;; <�쐬>      : 00/09/27 YM �W����
;;;; <���l>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut2-3 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$  ;�_��
;  &point2$ ;�_��2
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #BG_SEP #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP
;  #DUM1 #DUM2 #DUM3 #DUM4 #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #RET #RET$ #SP1 #SP2 #WT_EN #WT_LEN #X1 #X11 #X2 #X22 #X3 #X33 #X4 #X44 #end1 #end2 #end3 #end4
;  #LIS1 #LIS2
;  #DUMPT1 #DUMPT2 #FG_T
;#BG_T #PA #PB #PC #PD #TOP_FLG #FG_S ;03/10/14 YM ADD
;  )
;;;; ��U�^��
;;;;       end1     x11 x1
;;;; p1+(BASE1)-----*---*------------------------+p2   <---BG�w��
;;;;   |   |        |   |                        |
;;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG�O��
;;;;   |   |        |   |                        |
;;;;   |   |     +p444--|------------------------+p333 <---FG�w��
;;;;   |   |     |  |   |                        |
;;;;x22* - dum2- - -*sp1|             �ݸ��      | x1,x2 x11,x22�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp1��J��Ď��̕���_
;;;;   |   |     |      |                        |
;;;;   |   |     |    +p4------------------------+p3
;;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG�O��
;;;;   |   |     |    | |p44
;;;;   |   |     |    | |
;;;;   |   |��ۑ�|    | |
;;;;   |   |     |    | |
;;;;   |   |     |    | |
;;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG�O��
;;;;   |   |     |    +p5-------------------------+p6
;;;;   |   |     |      |                         |
;;;;x33* - dum3- - -*sp2|          ���̑�         | x3,x4 x33,x44�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp2��J��Ď��̕���_
;;;;   |   |     |  |   |                         |
;;;;   |   |     +p555--|-------------------------+p666 <---FG�w��
;;;;   |   |        |   |                         |
;;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG�O��
;;;;   |   |        |   |                         |
;;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG�w��
;;;;       end4    x44 x4
;
;  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
;  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
;  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  (setq #x1  (nth 0 &point2$))
;  (setq #x2  (nth 1 &point2$))
;  (setq #x3  (nth 2 &point2$))
;  (setq #x4  (nth 3 &point2$))
;  (setq #x11 (nth 4 &point2$))
;  (setq #x22 (nth 5 &point2$))
;  (setq #x33 (nth 6 &point2$))
;  (setq #x44 (nth 7 &point2$))
;  (setq #sp1 (nth 8 &point2$))
;  (setq #sp2 (nth 9 &point2$))
;  (setq #dum1 (CFGetDropPt #p22 (list #sp1 #x11)))
;  (setq #dum2 (CFGetDropPt #p11 (list #sp1 #x22)))
;  (setq #dum3 (CFGetDropPt #p11 (list #sp2 #x33)))
;  (setq #dum4 (CFGetDropPt #p77 (list #sp2 #x44)))
;  (setq #end1 (inters #p11 #p88 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p8 nil))
;  (setq #end3 (inters #p77 #p88 #p1 #p8 nil))
;  (setq #end4 (inters #p11 #p88 #p8 #p7 nil))
;
;  ;03/09/22 YM ADD ����į���׸ޑΉ�
;  ; BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_SEP   (nth 6 &BGFG_Info)) ; �����^:1 ��̌^:0
;
;;;;;;;;; (�ݸ��) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type1 1 0.1) ; 1����BG����
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2����BG����
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #pA #pB #p11 #dum2)))
;            ;else �ʏ�
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum2)))
;          );_if
;        )
;        ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type1 0 0.1) ; 1����BG�Ȃ�
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #dum2 #x22)))
;        )
;        ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; �ʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44)))
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2����FG�O
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type2 2 0.1) ; 2����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #dum2 #x22)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 2 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44)))
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2����FG�O
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;        )
;        ((equal #FG_Type2 2 0.1) ; 2����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum2)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 3 0.1) ; FG�O��E
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #p11 #dum2)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x22 #p1 #p2 #p33))))
;  (setq #WT_LEN (distance #p2 #p1))
;  (setq #cut_type "10")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")           ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p2 &outpl_LOW)  ; T or nil
;      (setq #cut_type "14")          ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p1 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (��ۑ�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type2 1 0.1) ; BG����
;      (setq #bg_en1 (MakeTEIMEN (list #x22 #x33 #dum3 #dum2))) ; �ޯ��ް�ޒ��
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type2 0 0.1) ; BG�Ȃ�
;      (setq #bg_en$ (list nil nil))
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; �ʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; �O����O
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type2 2 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; �O����O
;      (setq #fg_en2 (MakeTEIMEN (list #x22 #x33 #dum3 #dum2))) ; �O������
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #x22 #x33 #sp2 #p55 #p44 #sp1))))
;  (setq #WT_LEN (distance #p44 #p55))
;;;;01/07/09YM@  (setq #WT_LEN (distance #x22 #x33))
;  (setq #cut_type "22")
;  (setq #dep (distance #x2 #p44))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #x33 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (���̑�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type3 1 0.1) ; 3����BG����
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2����BG����
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;            (setq #bg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p66 #pD #pC #p88 #dum3)))
;            ;else �ʏ�
;            (setq #bg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p77 #p88 #dum3)))
;          );_if
;        )
;        ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;          (setq #bg_en1 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type3 0 0.1)
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #x33 #p8 #end4 #dum3)))
;        )
;        ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type3 1 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); �O������ؽ� 3����
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2����FG�O
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type2 2 0.1) ; 2����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #x33 #dum3 #end4 #p8)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type3 2 0.1) ; FG����
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); �O������ؽ� 3���ڑO
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2����FG�O
;          (setq #fg_en2 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
;        )
;        ((equal #FG_Type2 2 0.1) ; 2����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #x33 #p8 #p7 #p77 #p88 #dum3)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type3 3 0.1) ; FG�O�㍶
;      (setq #dumPT1 (polar #p666 (angle #p7 #p8) #FG_T))
;      (setq #dumPT2 (polar #p77  (angle #p7 #p8) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p66 #p55 #p555 #dumPT1 #dumPT2 #p88 #dum3)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p8 #x33 #sp2 #p55 #p66 #p7))))
;  (setq #WT_LEN (distance #p8 #p7))
;  (setq #cut_type "01")
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p7 &outpl_LOW) ; T or nil
;      (setq #cut_type "41")         ; �i��������
;    );_if
;  );_if
;  (setq #dep (distance #p66 #p7))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p7 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKUcut2-3
;
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : PKUcut2-4
;;;; <�����T�v>  : WT,BG,FG������ײ݂̍쐬 U�^�������(ID=2) �����4
;;;; <�߂�l>    :
;;;; <�쐬>      : 00/09/27 YM �W����
;;;; <���l>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut2-4 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$  ;�_��
;  &point2$ ;�_��2
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #BG_SEP #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP
;  #DUM1 #DUM2 #DUM3 #DUM4 #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #RET #RET$ #SP1 #SP2 #WT_EN #WT_LEN #X1 #X11 #X2 #X22 #X3 #X33 #X4 #X44 #end1 #end2 #end3 #end4
;  #LIS1 #LIS2
;  #DUMPT1 #DUMPT2 #FG_T
;#BG_T #PA #PB #PC #PD #TOP_FLG #FG_S ;03/10/14 YM ADD
;  )
;;;; ��U�^��
;;;;       end1     x11 x1
;;;; p1+(BASE1)-----*---*------------------------+p2   <---BG�w��
;;;;   |   |        |   |                        |
;;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG�O��
;;;;   |   |        |   |                        |
;;;;   |   |     +p444--|------------------------+p333 <---FG�w��
;;;;   |   |     |  |   |                        |
;;;;x22* - dum2- - -*sp1|             �ݸ��      | x1,x2 x11,x22�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp1��J��Ď��̕���_
;;;;   |   |     |      |                        |
;;;;   |   |     |    +p4------------------------+p3
;;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG�O��
;;;;   |   |     |    | |p44
;;;;   |   |     |    | |
;;;;   |   |��ۑ�|    | |
;;;;   |   |     |    | |
;;;;   |   |     |    | |
;;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG�O��
;;;;   |   |     |    +p5-------------------------+p6
;;;;   |   |     |      |                         |
;;;;x33* - dum3- - -*sp2|          ���̑�         | x3,x4 x33,x44�Ͷ�ĕ���(հ�ް�w��)�ɂ��ω� sp2��J��Ď��̕���_
;;;;   |   |     |  |   |                         |
;;;;   |   |     +p555--|-------------------------+p666 <---FG�w��
;;;;   |   |        |   |                         |
;;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG�O��
;;;;   |   |        |   |                         |
;;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG�w��
;;;;       end4    x44 x4
;
;  (setq #BG_T     (nth 3 &WTInfo )) ; BG�̌���
;  (setq #FG_T     (nth 5 &WTInfo )) ; FG�̌���
;  (setq #FG_S     (nth 6 &WTInfo )) ; �O����V�t�g��
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG����
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD ����į���׸�
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  (setq #x1  (nth 0 &point2$))
;  (setq #x2  (nth 1 &point2$))
;  (setq #x3  (nth 2 &point2$))
;  (setq #x4  (nth 3 &point2$))
;  (setq #x11 (nth 4 &point2$))
;  (setq #x22 (nth 5 &point2$))
;  (setq #x33 (nth 6 &point2$))
;  (setq #x44 (nth 7 &point2$))
;  (setq #sp1 (nth 8 &point2$))
;  (setq #sp2 (nth 9 &point2$))
;  (setq #dum1 (CFGetDropPt #p22 (list #sp1 #x11)))
;  (setq #dum2 (CFGetDropPt #p11 (list #sp1 #x22)))
;  (setq #dum3 (CFGetDropPt #p11 (list #sp2 #x33)))
;  (setq #dum4 (CFGetDropPt #p77 (list #sp2 #x44)))
;  (setq #end1 (inters #p11 #p88 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p8 nil))
;  (setq #end3 (inters #p77 #p88 #p1 #p8 nil))
;  (setq #end4 (inters #p11 #p88 #p8 #p7 nil))
;
;  ;03/09/22 YM ADD ����į���׸ޑΉ�
;  ; BG��荞�ݗp�̓_pA,pB,pC,pD��ǉ�
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG���ݕ�
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG�L�� 1:���� 0:�Ȃ�
;  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FG���� 1:�Б� 2:����
;  (setq #BG_SEP   (nth 6 &BGFG_Info)) ; �����^:1 ��̌^:0
;
;;;;;;;;; (�ݸ��) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type1 1 0.1) ; 1����BG����
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2����BG����
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #pA #pB #p11 #dum2)))
;            ;else �ʏ�
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum2)))
;          );_if
;        )
;        ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type1 0 0.1) ; 1����BG�Ȃ�
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #dum2 #x22)))
;        )
;        ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; �ʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44)))
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2����FG�O
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type2 2 0.1) ; 2����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #dum2 #x22)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 2 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44)))
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2����FG�O
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;        )
;        ((equal #FG_Type2 2 0.1) ; 2����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum2)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 3 0.1) ; FG�O��E
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #p11 #dum2)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x22 #p1 #p2 #p33))))
;  (setq #WT_LEN (distance #p2 #p1))
;  (setq #cut_type "10")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")           ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p2 &outpl_LOW)  ; T or nil
;      (setq #cut_type "14")          ; �i��������
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p1 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (��ۑ�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type2 1 0.1) ; 2����BG����
;      (cond
;        ((equal #BG_Type3 1 0.1) ; 3����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #x22 #p8 #x44 #dum4 #p88 #dum2)))
;        )
;        ((equal #BG_Type3 0 0.1) ; 3����BG�Ȃ�
;          (setq #bg_en1 (MakeTEIMEN (list #x22 #dum2 #end4 #p8)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type2 0 0.1) ; 2����BG�Ȃ�
;      (cond
;        ((equal #BG_Type3 1 0.1) ; 3����BG����
;          (setq #bg_en1 (MakeTEIMEN (list #end3 #dum4 #x44 #p8)))
;        )
;        ((equal #BG_Type3 0 0.1) ; 3����BG�Ȃ�
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n�ޯ��ް�����߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; �ʏ�Б�
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44)))
;      (cond
;        ((equal #FG_Type3 1 0.1) ; 3����FG�O
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type3 2 0.1) ; 3����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #end3 #dum4 #x44 #p8)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type2 2 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; �O����O
;      (cond
;        ((equal #FG_Type3 1 0.1) ; 3����FG�O
;          (setq #fg_en2 (MakeTEIMEN (list #x22 #dum2 #end4 #p8)))
;        )
;        ((equal #FG_Type3 2 0.1) ; 3����FG�O��
;          (setq #fg_en2 (MakeTEIMEN (list #x22 #p8 #x44 #dum4 #p88 #dum2)))
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n�O�������߂��s���ł��B")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #x22 #p8 #x44 #sp2 #p55 #p44 #sp1))))
;  (setq #WT_LEN (distance #x22 #p8))
;  (setq #cut_type "12")
;  (setq #dep (distance #x2 #p44))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p8 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (���̑�) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type3 1 0.1) ; BG����
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD ����į�ߑΉ� BG��荞��(�ި��۱)
;        (setq #bg_en1 (MakeTEIMEN (list #x44 #p7 #p66 #pD #pC #dum4))) ; 3����BG����
;        ;else �ʏ�
;        (setq #bg_en1 (MakeTEIMEN (list #x44 #p7 #p77 #dum4))) ; 3����BG����
;      );_if
;    )
;    ((equal #BG_Type3 0 0.1)
;      (setq #bg_en1 nil)                                   ; 3����BG�Ȃ�
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type3 1 0.1) ; FG�O��
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); �O������ؽ� 3����
;      (setq #fg_en2 nil)                                      ; 3����FG�ʏ�
;    )
;    ((equal #FG_Type3 2 0.1) ; FG����
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); �O������ؽ� 3���ڑO
;      (setq #fg_en2 (MakeTEIMEN (list #x44 #p7 #p77 #dum4)))    ; 3����FG�������
;    )
;    ((equal #FG_Type3 3 0.1) ; FG�O�㍶
;      (setq #dumPT1 (polar #p666 (angle #p7 #p8) #FG_T))
;      (setq #dumPT2 (polar #p77  (angle #p7 #p8) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x44 #p7 #p66 #p55 #p555 #dumPT1 #dumPT2 #dum4)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #x44 #sp2 #p55 #p66 #p7))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #x44 #p7))
;  (setq #WT_LEN (distance #p55 #p66)) ; 01/07/02 Y-CUT
;  (setq #cut_type "02")
;  (if (= CG_Type2Code "D")          ; ۰���ނ̌���
;    (if (PKSLOWPLCP #p7 &outpl_LOW) ; T or nil
;      (setq #cut_type "42")         ; �i��������
;    );_if
;  );_if
;  (setq #dep (distance #p66 #p7))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p7 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKUcut2-4
;-- 2011/08/25 A.Satoh Del - E

;<HOM>*************************************************************************
; <�֐���>    : PKDecideLRCODE
; <�����T�v>  : LR����������޲�۸ނ�\��
; <�쐬>      : 2000.4.18  YM
;*************************************************************************>MOH<
(defun PKDecideLRCODE (
  /
   #dcl_id ##GetDlgItem #ret
  )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( / #L #R #ret)

            (setq #L (get_tile "L"))
            (setq #R (get_tile "R"))

            (cond
              ((= #L "1")
               (setq #ret "L")
              )
              ((= #R "1")
               (setq #ret "R")
              )
            );_cond
            (done_dialog)
            #ret
          )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (= nil (new_dialog "LRCODE_Dlg" #dcl_id)) (exit))

  (action_tile "accept" "(setq #ret (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret nil) (done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)
  #ret
);PKDecideLRCODE

;<HOM>***********************************************************************
; <�֐���>    : GetBGLEN
; <�����T�v>  : BG��ʐ}�`--->BG����(BG��ʕӂ̒����̍ő�l)
; <����>      : BG��ʐ}�`
; <�߂�l>    : BG����
; <�쐬>      : 00/04/23 YM
; <���l>      :
;***********************************************************************>HOM<
(defun GetBGLEN (
  &BG  ; BG��ʐ}�`��
  /
  #DIS #I #KOSU #MAX #PT$ #PT2$
  )
  (setq #pt$ (GetLWPolyLinePt &BG)) ; BG�̊O�`�_��
  (setq #pt2$ (AddPtList #pt$)) ; �����Ɏn�_��ǉ�����

  (setq #kosu (length #pt$)) ; �ʏ�4
  (setq #i 0 #max -99999)
  (repeat #kosu ;=4
    (setq #dis (distance (nth #i #pt2$) (nth (1+ #i) #pt2$)))
    (if (>= #dis #max)(setq #max #dis)) ; �����̍ő�����߂�
    (setq #i (1+ #i))
  )
  #max ; BG�̒���
);GetBGLEN

;;;<HOM>***********************************************************************
;;; <�֐���>    : PKSetBGXData
;;; <�����T�v>  :
;;; �g���ް� G_BKGD�̾��
;;; 1. �i�Ԗ���("dummy")
;;; 2. BG��ʐ}�`�����ؽ�
;;; 3. �֘AWT�}�`�����
;;; 4. BG����
;;; 5. BG���z
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun PKSetBGXData (
  &BG_SOLID$ ; BG�}�`��ؽ� (list #BG_SOLID1 #BG_SOLID2)
  &cutL      ; WT��č�
  &cutR      ; WT��ĉE
  &ZAI       ; �ގ��L��
  &BG0$      ; BG��ʐ}�`�� (list #BG01 #BG02)
  &WT_SOLID  ; �֘AWT�}�`��
  &D150      ; �i���p�a�f==> T(T�Ȃ�i�������̂v�s�Ɣ��f)
  /
  #BG01 #BG02 #BG_ALL_LEN #BG_LEN1 #BG_LEN2 #BG_PRICE #BG_SOLID1 #BG_SOLID2 #BKGDCODE1 #BKGDCODE2
  )
  (setq #BG_ALL_LEN 0 #BG_LEN1 nil #BG_LEN2 nil) ; BG_ALL_LEN ���̊֐��ž�Ă���BG������total
  (setq #BG_SOLID1 (car  &BG_SOLID$))
  (setq #BG_SOLID2 (cadr &BG_SOLID$)) ; nil ����
  (setq #BG01 (car  &BG0$))           ; BG���1
  (setq #BG02 (cadr &BG0$))           ; nil ����

  (if (and #BG_SOLID1 (/= #BG_SOLID1 ""))
    (progn
    ;;; BG�̒���������
      (if (/= #BG01 "") (setq #BG_LEN1 (GetBGLEN #BG01)))
      (if (/= #BG02 "") (setq #BG_LEN2 (GetBGLEN #BG02)))

      (setq #BKGDCode1 "dummy") ; 00/09/21 YM �_�~�[
      (setq #BG_PRICE 0)        ; 00/09/21 YM �_�~�[
      (CFSetXData #BG_SOLID1 "G_BKGD"
        (list
          #BKGDCode1
          #BG01
          &WT_SOLID
          #BG_LEN1
          #BG_PRICE
        )
      )
      (setq #BG_ALL_LEN (+ #BG_ALL_LEN #BG_LEN1))

      (if (and (/= #BG02 "") (/= #BG_SOLID2 "")(/= #BG_LEN2 nil))
        (progn
          (setq #BKGDCode2 "dummy")
          (setq #BG_PRICE 0)
          (CFSetXData #BG_SOLID2 "G_BKGD"
            (list
              #BKGDCode2
              #BG02
              &WT_SOLID
              #BG_LEN2
              #BG_PRICE
            )
          )
          (setq #BG_ALL_LEN (+ #BG_ALL_LEN #BG_LEN2))
        )
      )
    )
  );_if
  #BG_ALL_LEN ; ���̊֐���G_BKGD��Ă���BG��total����
);PKSetBGXData

;<HOM>***********************************************************************
; <�֐���>    : PKGetBGPrice
; <�����T�v>  : BG�i�Ԃ���BG���i�����߂�
; <�߂�l>    : BG���i
; <�쐬>      : 00/05/31 YM
; <���l>      :
;***********************************************************************>HOM<
(defun PKGetBGPrice (
  &BKGDCode ; BG�i��
  /
  #BG_PRICE #QRY$
  )
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "WT��i"
      (list
        (list "�i�Ԋ�{��" (substr &BKGDCode  1 8) 'STR)
        (list "�F���L��"   (substr &BKGDCode 12 1)  'STR)
      )
    )
  );_(setq #qry$$
  (setq #qry$ (DBCheck #qry$ "�wWT��i�x" (strcat "�i�Ԋ�{��=" (substr &BKGDCode  1 8) " �F���L��=" (substr &BKGDCode 12 1))))
  (setq #BG_PRICE (nth 3 #qry$)) ; BG���i
  #BG_PRICE
);PKGetBGPrice

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMoveTempLayer
;;; <�����T�v>  : �����}�`�����ׂ������؉�w�Ɉړ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.3.22 YM
;;; <���l>      : �Ȃ�
;;;*************************************************************************>MOH<
(defun PKMoveTempLayer (
  &lis$ ; �}�`��ؽ�
  &flg  ; nil(1�ȊO):�������� 1:�����c��
  /
  #EG$ #I #LIS$
  )
  (setq #i 0)
  (repeat (length &lis$)
    (setq #eg$ (entget (nth #i &lis$)))
    (entmake (subst (cons 8 SKD_TEMP_LAYER) (assoc 8 #eg$) #eg$))
    (setq #lis$ (append #lis$ (list (entlast)))) ; �߂�l
    (if (= &flg 1)
      (entdel (nth #i &lis$)) ; �����폜
    )
    (setq #i (1+ #i))
  )
  #lis$ ; �߂�l
);PKMoveTempLayer

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMKWT
;;; <�����T�v>  : ܰ�į�߂̐��� Z�����ړ�
;;; <�߂�l>    : SOLID�}�`��
;;; <�쐬>      : 2000.3.15 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKMKWT (
  &region      ; ܰ�į��region�}�`��
  &WT_T        ; �����o������
  &WT_H        ; ܰ�į�ߎ��t������
  /
  #RET
  )
  ;2008/07/28 YM MOD 2009�Ή�
  (command "_.extrude" &region "" &WT_T) ; region �� Z�����ɉ����o��
;;;  (command "_.extrude" &region "" &WT_T "") ; region �� Z�����ɉ����o��

  (setq #ret (entlast)) ; SOLID �}�`��
  (command "_move" #ret "" '(0 0 0) (strcat "@0,0," (rtos &WT_H)))
  (entmod (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #ret)) (entget #ret))) ; WT��p�̉�w
  (entlast)
);PKMKWT

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMKFG2
;;; <�����T�v>  : ���Ķް�ނ̐��� Z�����ړ�
;;; <�߂�l>    : SOLID�}�`��
;;; <�쐬>      : 2000.3.15 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKMKFG2 (
    &region      ; �ޯ��ް��region�}�`��ؽ�
    &FG_H        ; �����o������
    &WT_H        ; ܰ�į�ߎ��t������
    &WT_T        ; ܰ�į�ߌ���
    /
    #FrontPline #i #RET #ss_ret
  )
  ;2008/07/28 YM MOD 2009�Ή�
  (command "_.extrude" &region "" (- &WT_T &FG_H) ) ; region �� -Z�����ɉ����o��
;;;  (command "_.extrude" &region "" (- &WT_T &FG_H) "") ; region �� -Z�����ɉ����o��
  (setq #ret (entlast)) ; SOLID �}�`��
  (command "_move" #ret "" '(0 0 0) (strcat "@0,0," (rtos &WT_H)))
  (entmod (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #ret)) (entget #ret))) ; WT��p�̉�w
  (entlast)
);PKMKFG2

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMKBG2
;;; <�����T�v>  : �ޯ��ް�ނ̐��� Z�����ړ�
;;; <�߂�l>    : SOLID�}�`��
;;; <�쐬>      : 2000.3.15 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKMKBG2 (
  &region      ; �ޯ��ް��region�}�`��ؽ�
  &BG_H        ; �����o������
  &WT_T        ; ܰ�į�ߌ���
  &WT_H        ; ܰ�į�ߎ��t������
  /
  #BackPline #i #MOVE #RET
  )
  ;2008/07/28 YM MOD 2009�Ή�
  (command "_.extrude" &region "" &BG_H) ; region �� Z�����ɉ����o��
;;;  (command "_.extrude" &region "" &BG_H "") ; region �� Z�����ɉ����o��
  (setq #ret (entlast)) ; SOLID �}�`��
  (setq #move (+ &WT_T &WT_H))
  (command "_move" #ret "" '(0 0 0) (strcat "@0,0," (rtos #move)))
  (entmod (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #ret)) (entget #ret))) ; WT��p�̉�w
  (entlast)
);PKMKBG2

;;;<HOM>*************************************************************************
;;; <�֐���>    : Make_Region2
;;; <�����T�v>  : ܰ�į�߂̐���(extrude)�ɕK�v��region���쐬����
;;; <�߂�l>    : region�}�`��
;;; <�쐬>      : 2000.3.15 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun Make_Region2 ( &OutPline / )
  (command "_.region" &OutPline "") 
  (entlast)
);Make_Region2

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_PosWTR_plan
;;; <�����T�v>  : ������z�u����(�v��������)
;;; <�߂�l>    :
;;;        LIST : ������(G_WTR)�}�`�̃��X�g
;;; <�쐬>      : 1999-10-21
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKW_PosWTR_plan (
  &KCode        ;(STR)�H��L��
  &SeriCode     ;(STR)SERIES�L��
  &snk-en       ;(ENAME)�V���N��}�` (Lipple �̂Ƃ��� nil)
  &snk-cd       ;(STR)�V���N�L��
  &qry$$        ;�����\��ں��ނ�ؽ� nil����
  /
;-- 2011/09/09 A.Satoh Mod - S
;  #ANG #DUM #EN #FIG-QRY$ #FLG #HINBAN #K #KEI #MSG #O #OS #ANA_layer
  #ANG #EN #FIG-QRY$ #FLG #HINBAN #K #KEI #MSG #O #OS #ANA_layer
;-- 2011/09/09 A.Satoh Mod - E
  #PTEN5 #PTEN5$$ #SM #SS_DUM #WTRHOLEEN$ #XD_PTEN$ #ZOKU #ZOKUP #ZOKUP$
  #DWG #I #PTEN5$ #RET$ #XD_PTEN5$
  #DUM_EN #II #KIKI$ #LOOP ;07/10/05 YM ADD
  )

  ;// �V�X�e���ϐ��ۊ�
  (setq #os (getvar "OSMODE"))   ;O�X�i�b�v
  (setq #sm (getvar "SNAPMODE")) ;�X�i�b�v
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)

  (if (not (tblsearch "APPID" "G_WTR")) (regapp "G_WTR"))

  ;// �V���N�ɐݒ肳��Ă��鐅����t���_�i�o�_=�T�j�̏����擾����
  (setq #pten5$$ nil)
  (if &snk-en
    (setq #pten5$$ (PKGetPTEN_NO &snk-en 5)) ; �߂�l(PTEN�}�`,G_PTEN)��ؽĂ�ؽ�
    (progn
      (setq #ret$ (KPGetPTEN 5)) ; 01/06/27 YM �֐���
      (setq #pten5$    (car  #ret$)) ; PTEN5�}�`ؽ�
      (setq #xd_pten5$ (cadr #ret$)) ; "G_PTEN"ؽ�
      (setq #i 0)
      (repeat (length #pten5$) ; ؽĂ����킹��
        (setq #pten5$$ (append #pten5$$ (list (list (nth #i #pten5$)(nth #i #xd_pten5$)))))
        (setq #i (1+ #i))
      )
    )
  );_if

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
        (if &snk-en
          (setq #ang (nth 2 (CFGetXData &snk-en "G_LSYM"))) ; �z�u�p�x
          (setq #ang 0.0) ; �ݸ�����݂��Ȃ��Ƃ��z�u�p�x0�Œ�
        );_if




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
            &KCode                     ;4 :�H��L��
            &SeriCode                  ;5 :SERIES�L��
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
);PKW_PosWTR_plan


;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_PosWTR_plan_2
;;; <�����T�v>  : ����2��z�u����(�v��������)
;;; <�߂�l>    :
;;;        LIST : ������(G_WTR)�}�`�̃��X�g
;;; <�쐬>      : 1999-10-21
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKW_PosWTR_plan_2 (
  &KCode        ;(STR)�H��L��
  &SeriCode     ;(STR)SERIES�L��
  &snk-en       ;(ENAME)�V���N��}�` (Lipple �̂Ƃ��� nil)
  &snk-cd       ;(STR)�V���N�L��
  &qry$$        ;�����\��ں��ނ�ؽ� nil����
  /
;-- 2011/09/09 A.Satoh Mod - S
;  #ANG #DUM #EN #FIG-QRY$ #FLG #HINBAN #K #KEI #MSG #O #OS #ANA_layer
  #ANG #EN #FIG-QRY$ #FLG #HINBAN #K #KEI #MSG #O #OS #ANA_layer
;-- 2011/09/09 A.Satoh Mod - E
  #PTEN5 #PTEN5$$ #SM #SS_DUM #WTRHOLEEN$ #XD_PTEN$ #ZOKU #ZOKUP #ZOKUP$
  #DWG #I #PTEN5$ #RET$ #XD_PTEN5$
  #DUM_EN #II #KIKI$ #LOOP ;07/10/05 YM ADD
  )

  ;// �V�X�e���ϐ��ۊ�
  (setq #os (getvar "OSMODE"))   ;O�X�i�b�v
  (setq #sm (getvar "SNAPMODE")) ;�X�i�b�v
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)

  (if (not (tblsearch "APPID" "G_WTR")) (regapp "G_WTR"))

  ;// �V���N�ɐݒ肳��Ă��鐅����t���_�i�o�_=�T�j�̏����擾����
  (setq #pten5$$ nil)
  (if &snk-en
    (setq #pten5$$ (PKGetPTEN_NO &snk-en 5)) ; �߂�l(PTEN�}�`,G_PTEN)��ؽĂ�ؽ�
    (progn
      (setq #ret$ (KPGetPTEN 5)) ; 01/06/27 YM �֐���
      (setq #pten5$    (car  #ret$)) ; PTEN5�}�`ؽ�
      (setq #xd_pten5$ (cadr #ret$)) ; "G_PTEN"ؽ�
      (setq #i 0)
      (repeat (length #pten5$) ; ؽĂ����킹��
        (setq #pten5$$ (append #pten5$$ (list (list (nth #i #pten5$)(nth #i #xd_pten5$)))))
        (setq #i (1+ #i))
      )
    )
  );_if

  ;������������i�Ԃ��擾����
  (setq #DB_NAME "��������")
  (setq #LIST$$ (list (list "�L��" (nth 22 CG_GLOBAL$)'STR)));����2 "PLAN22"
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

  (setq #zoku (nth 5 #sui-qry$))   ; ����2�̔z�u�ʒu����

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
;       (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"�̉~���쐬����
;
;
;        ;// �������g���f�[�^��ݒ�
;        (CFSetXData #dum "G_WTR" (list #zokuP))
;        (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; �������}�`��
;-- 2011/09/09 A.Satoh Del - E
        ;// ��������̔z�u
        (if &snk-en
          (setq #ang (nth 2 (CFGetXData &snk-en "G_LSYM"))) ; �z�u�p�x
          (setq #ang 0.0) ; �ݸ�����݂��Ȃ��Ƃ��z�u�p�x0�Œ�
        );_if




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
            &KCode                     ;4 :�H��L��
            &SeriCode                  ;5 :SERIES�L��
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
);PKW_PosWTR_plan_2


;<HOM>*************************************************************************
; <�֐���>    : PKW_MakeSKOutLine
; <�����T�v>  : �L�b�`���̊O�`�̈�����ԃ|�����C����Ԃ�
; <�߂�l>    :
;       ENAME : �L�b�`���̊O�`�̈�|�����C��
; <�쐬>      : 99-10-19
; <���l>      : 03/31 YM ���ٷ���600�V��̨װ�����s��C��
;               �ݼ�̰�ނ�100mm���Ɉړ�����--->PMEN2���ړ�����--->���߰���ފO�`�̈悪���������܂�Ȃ�--->�C��
;*************************************************************************>MOH<
(defun PKW_MakeSKOutLine (
  &BaseSym$
  &step                ;(STR)�X�e�b�v�^�C�v�t���O (T or nil) ; 00/03/13 ADD step �i��
  /
  #210 #38 #38_MAX #ANG #DIST$ #EN #EN$ #H #H$ #I #LOOP #LST$ #MSG #P-EN #P2 #P3 #PT #PT$
  #R-DEPTH #R-SS #R-WIDTH #SPT #SYM #XD$ #ZU_ID
#xd_LSYM$	;- 2011/10/21 A.Satoh Add
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_MakeSKOutLine ////")
  (CFOutStateLog 1 1 " ")

  ;// ���[�N�g�b�v�̊O�`�̈�(P��=2)����������
  (setq #38_MAX -99999) ; ���x�̍ő�l�����߂� �A�b�p�[�V��t�B���[�p ; 00/03/31 YM ADD
  (foreach #sym &BaseSym$
    (setq #spt (cdr (assoc 10 (entget #sym))))
    (setq #h$ (cons (nth 5 (CFGetXData #sym "G_SYM")) #h$))                ; 00/03/13 ADD step �i��
    (setq #en$ (CFGetGroupEnt #sym)) ; �e�ް����ނ̓����ٰ��
    (setq #i 0)
    ;// �����W�t�[�h�͑��̃L���r�Ɖ��s�������킹��
    (if (= CG_SKK_ONE_RNG (CFGetSymSKKCode #sym 1)) ; CG_SKK_ONE_RNG = 3
      (progn
        (setq #r-width (nth 3 (CFGetXData #sym "G_SYM"))) ; ��
        (setq #r-depth (nth 4 (CFGetXData #sym "G_SYM"))) ; ���s��
      )
    )

    (setq #loop T)
    (while (and #loop (< #i (length #en$)))
      (setq #en (nth #i #en$))
      (if (= 2 (car (CFGetXData #en "G_PMEN")))
        (progn
          (setq #210 (cdr (assoc 210 (entget #en)))) ; �����o������ 0,0,1
          (setq #38  (cdr (assoc 38  (entget #en)))) ; PLINE ���x
          (if (<= #38_MAX #38) ; ���x�̍ő�l #38_MAX
            (setq #38_MAX #38)
          );_if
          (if (and (= (fix (car #210)) 0) (= (fix (cadr #210)) 0) (= (fix (caddr #210)) 1))
            (progn
              (setq #lst$ (cons (list #sym #en) #lst$)) ; �ް����ނƉ����o������ 0,0,1�����ײ݂̃��X�g
              (setq #loop nil) ; �P�������烋�[�v�𔲂���
            )
          )
        )
      )
      (setq #i (1+ #i))
    );_(while (and #loop (< #i (length #en$)))

    (if #loop            ; 00/03/11 YM �`�F�b�N����
      (progn
;-- 2011/10/21 A.Satoh Mod - S
;;;;;        (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; �}�`ID
;;;;;        (setq #msg (strcat "�}�`ID=" #zu_id "�� �O�`�̈� PMEN2 ������܂���B\nPKW_MakeSKOutLine"))
;;;;;        (CMN_OutMsg #msg) ; 02/09/05 YM ADD
				(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
				(if (/= (nth 9 #xd_LSYM$) 110)
					(progn
						(setq #zu_id (nth 0 #xd_LSYM$))	; �}�`ID
		        (setq #msg (strcat "�}�`ID=" #zu_id "�� �O�`�̈� PMEN2 ������܂���B\nPKW_MakeSKOutLine"))
    		    (CMN_OutMsg #msg)
					)
				)
;-- 2011/10/21 A.Satoh Mod - S
      )
    );_if

  );_(foreach #sym &BaseSym$

  ;// ���߂��O�`�̈�̃N���[����REGION�Ƃ��č쐬����
  ;// �O�`�̈���S�_��REGION�ɕϊ�����
  (setq #r-ss (ssadd))
  (foreach #lst #lst$
    (setq #sym  (car #lst))  ; �ް�����
    (setq #p-en (cadr #lst)) ; PMEN=2,�����o������ 0,0,1�����ײ�
    ;// �R�[�i�[�L���r�͂��̂܂܂̊O�`��
    (cond
      ((= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3)) ; CG_SKK_THR_CNR = 5 �R�[�i�[�L���r
        (entmake (cdr (entget #p-en)))
        (command "_region" (entlast) "")
        (ssadd (entlast) #r-ss)
      )
      (T ; �R�[�i�[�L���r�ȊO
        (setq #38 (cdr (assoc 38 (entget #p-en)))) ; #38 ���x
        (setq #spt (cdr (assoc 10 (entget #sym)))) ; �e�}�`�}����_
        (setq #xd$ (CFGetXData #sym "G_LSYM"))
        (setq #h   (nth 5 (CFGetXData #sym "G_SYM")))

        (if (or (= &step nil)
                (and (= &step T) (> #h 728))  ;�i���ł�WT��\�鍂���L���r�̏ꍇ
;;;               (and (= &step T) (< #h 360))) ;��ٵ���ݐH����[���ނ̏ꍇ ; 03/01/16 YM MOD
                (and (= &step T) (< #h 375))) ;��ٵ���ݐH����[���ނ̏ꍇ   ; 03/01/16 YM MOD
          (progn
            (setq #ang (nth 2 #xd$)) ; ��]�p�x
            (if (= CG_SKK_ONE_RNG (CFGetSeikakuToSKKCode (nth 9 #xd$) 1)) ; CG_SKK_ONE_RNG=3 �ݼ�̰��
              (progn
                (setq #p2 (polar #spt #ang #r-width))
                (setq #p3 (polar #spt (- #ang (dtr 90)) #r-depth))
                (setq #pt (polar #p3 #ang #r-width))
              )
              (progn
                (setq #pt$ (GetLWPolyLinePt #p-en))
                (setq #dist$ nil)
                (foreach #pt #pt$
                  (setq #dist$ (cons (list #pt (distance #spt #pt)) #dist$))
                )
                (setq #dist$ (CFListSort #dist$ 1))

                ;// ��ԉ����_
                (setq #pt (car (last #dist$))) ; ���X�g�̍Ō�̗v�f��Ԃ��܂��B
                (setq #p2 (CFGetDropPt #spt (list #pt (polar #pt (- #ang (dtr 90)) 10))))
                (setq #p3 (CFGetDropPt #spt (list #pt (polar #pt #ang 10))))
              )
            )

    ;;;    MakeLwPolyLine
    ;;;    &pt$  ;(LIST)�\�����W�_ؽ�
    ;;;    &cls  ;(INT) 0=�J��/1=����
    ;;;    &elv  ;(REAL)���x
            (MakeLwPolyLine (list #spt #p2 #pt #p3) 1 0)

            (if (= (CFGetSeikakuToSKKCode (nth 9 (CFGetXData (car &BaseSym$) "G_LSYM")) 2) CG_SKK_TWO_UPP) ; �A�b�p�[�Ȃ�
              (setq #38 #38_MAX) ; ���̷��ނƍ��x�����킹��
            );_if
            (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; ���x��#38�ɕύX
            (command "_region" (entlast) "")
            (ssadd (entlast) #r-ss)
          );�i���ł�WT��\�鍂���L���r�̏ꍇ
        );_if
      );_(T
    );_(cond

  );_(foreach #lst #lst$

  ;// �쐬����REGION��UNION�ŘA������REGION�Ƃ���
  (command "_union" #r-ss "")
  ;// REGION�𕪉����A���������������|�����C��������
  (command "_explode" (entlast))
  (setq #r-ss (ssget "P"))
  (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ���ײ݂̑I�����I��
  (entlast);// �O�`�|�����C����Ԃ�
);PKW_MakeSKOutLine

;<HOM>*************************************************************************
; <�֐���>    : SKW_ReGetBasePt
; <�����T�v>  : �X�e�b�v�^�C�v�̏ꍇ�A��_���Đݒ肷��
; <�߂�l>    :
; <�쐬>      : 1999-12-20 ��{����
; <���l>      :
;*************************************************************************>MOH<
(defun SKW_ReGetBasePt (
  &basePt
  &OutPline
  /
  #dist #minDist
  #pt #pt$
  #retPt
  )
  (setq #minDist 100000)
  (setq #pt$ (GetLWPolyLinePt &outPline))
  (foreach #pt #pt$
    (setq #dist (distance &basePt #pt))
    (if (> #minDist #dist)
      (progn
        (setq #minDist #dist)
        (setq #retPt #pt)
      )
    )
  )
  (list (car #retPt) (cadr #retPt) 0.0)
)
;SKW_ReGetBasePt

;<HOM>*************************************************************************
; <�֐���>    : SKW_ChkStepType
; <�����T�v>  : �X�e�b�v�^�C�v�����ׂ�
; <�߂�l>    :
; <�쐬>      : 1999-12-20 ��{����
; <���l>      :
;*************************************************************************>MOH<
(defun SKW_ChkStepType (
    &BaseSym$       ;(LIST)�x�[�X�L���r�̊�V���{�����X�g
    /
    #sym
    #step
    #h
  )
  (if (= CG_SKK_THR_GAS (CFGetSymSKKCode (car &BaseSym$) 3)) ; CG_SKK_THR_GAS=3�޽����
    (setq &BaseSym$ (reverse &BaseSym$))
  )
  (setq #h (fix (nth 5 (CFGetXData (car &BaseSym$) "G_SYM"))))
  (foreach #sym (cdr &BaseSym$)
    (if (/= CG_SKK_THR_GAS (CFGetSymSKKCode #sym 3))
      (progn
        (if (/= #h (fix (nth 5 (CFGetXData #sym "G_SYM"))))
          (setq #step T)
        )
      )
    )
  )
  #step
);SKW_ChkStepType

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPMovePmen2_Z_0
;;; <�����T�v>  : PMEN2�̍��x��Z=0�ɂ���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/07/30 YM
;;; <���l>      : MICAD CENA�ް�ذ����WT���������ŗאڃL���r����WT�O�`region�����߂�̂ɕK�v
;;;               PMEN2�����邱�Ƃ�O��
;;;*************************************************************************>MOH<
(defun KPMovePmen2_Z_0 (
  &sym    ;����ِ}�`
  /
  #RZ #ePMEN2$
  )
  (setq #ePMEN2$ (PKGetPMEN_NO_ALL &sym 2)) ; pmen2(�O�`�̈�)
  (foreach #ePMEN2 #ePMEN2$
    (setq #rZ (cdr (assoc 38 (entget #ePMEN2)))) ; �����Z���W
    (if (< (abs #rZ) 0.1)
      nil
      (progn
        (if (< 0 #rZ)
          (command "_move" #ePMEN2 "" '(0 0 0) (strcat "@0,0," (rtos (- #rZ)))) ; ��
          (command "_move" #ePMEN2 "" '(0 0 0) (strcat "@0,0," (rtos #rZ)))     ; ��
        );_if
      )
    );_if
  )
  (princ)
);KPMovePmen2_Z_0

;;; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;; �ȉ�PMEN2���g�p����悤�ɕύX 00/05/16 YM PMEN2�擾�͔��ɒx��
;;; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_GetLinkBaseCab
;;; <�����T�v>  : �w��}�`�̑�����L���r�ɗאڂ����ް����ނ��擾����
;;; <�߂�l>    : �ް����ސ}�`(G_LSYM)�̃��X�g
;;; <�쐬>      : 1999-10-19 00/05/17 YM ���s���Ⴂ�΍� 05/18 YM ������
;;; <���l>      : �ċA�ɂ�� �אڂ����V���{���� CG_LinkSym �Ɋi�[����
;;;*************************************************************************>MOH<
(defun PKW_GetLinkBaseCab (
  &sym       ;(ENAME)�Ӂ[�}���޼���ِ}�`
  /
  #ELM #ENSS$ #I #PMEN2 #PT$ #PT$$ #PT0$ #SKK$ #SYM
#MSG ; 02/09/04 YM ADD
;-- 2011/09/09 A.Satoh Add - S
#ss #en
;-- 2011/09/09 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_GetLinkBaseCab ////")
  (CFOutStateLog 1 1 " ")

  (setq CG_LinkSym nil)
  (setq #pt$$ nil)
  (setq #pmen2 (PKGetPMEN_NO &sym 2))   ; pmen2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 &sym))   ; PMEN2 ���쐬
  );_if
  (setq #pt0$ (GetLWPolyLinePt #pmen2)) ; pmen2�O�`�_��
;-- 2011/09/09 A.Satoh Mod - S
;  (setq #enSS$ (ssget "X" '((-3 ("G_PMEN"))))) ; �}�ʏ�PMEN
;
;  (setq #i 0)
;  (repeat (sslength #enSS$)
;    (setq #elm (ssname #enSS$ #i))             ; PMEN�}�`
;    (setq #sym (CFSearchGroupSym #elm))        ; ����ِ}�`
;    (if (= #sym nil)
;      (progn
;        (setq #msg "�o�ʂɃV���{���}�`������܂���B�}�ʂ̃A�C�e�����s���ł��B\n PKW_GetLinkBaseCab")
;        (CMN_OutMsg #msg) ; 02/09/05 YM ADD
;      )
;    )
;
;    (setq #skk$ (CFGetSymSKKCode #sym nil))       ; ���i���ނ��݂�
;
;;;    (if (or (and (= (car #skk$) CG_SKK_ONE_CAB)
;;;                 (= (cadr #skk$) CG_SKK_TWO_BAS)) ; �ް�����
;;;        )
;
;    ; 01/07/30 YM MOD "118"���ނ͏���
;    (if (and (= (car #skk$) CG_SKK_ONE_CAB) ; 01/04/04 YM
;             (= (cadr #skk$) CG_SKK_TWO_BAS); �ް�����
;             (/= (caddr #skk$) 8))
;
;      (if (= (car (CFGetXData #elm "G_PMEN")) 2)     ; PMEN2
;        (progn
;          (setq #pt$ (GetLWPolyLinePt #elm))
;          (setq #pt$$ (cons (list #sym #pt$) #pt$$)) ; (sym,�O�`�_��)
;        )
;      );_if
;    );_if
;    (setq #i (1+ #i))
;  );_(repeat (sslength #ss)
  (setq #enSS$ (ssget "X" '((-3 ("G_PMEN"))))) ; �}�ʏ�PMEN
  (setq #i 0)
  (setq #ss (ssadd))
  (repeat (sslength #enSS$)
    (setq #en (ssname #enSS$ #i))
    (if (= (car (CFGetXData #en "G_PMEN")) 2)
      (setq #ss (ssadd #en #ss))
    )
    (setq #i (1+ #i))
  )

  (setq #i 0)
  (repeat (sslength #ss)
    (setq #elm (ssname #ss #i))             ; PMEN�}�`
    (setq #sym (CFSearchGroupSym #elm))        ; ����ِ}�`
    (if (= #sym nil)
      (progn
        (setq #msg "�o�ʂɃV���{���}�`������܂���B�}�ʂ̃A�C�e�����s���ł��B\n PKW_GetLinkBaseCab")
        (CMN_OutMsg #msg)
      )
    )

    (setq #skk$ (CFGetSymSKKCode #sym nil))       ; ���i���ނ��݂�

    ; "118"���ނ͏���
    (if (and (= (car #skk$) CG_SKK_ONE_CAB)
             (= (cadr #skk$) CG_SKK_TWO_BAS); �ް�����
             (/= (caddr #skk$) 8))
      (progn
        (setq #pt$ (GetLWPolyLinePt #elm))
        (setq #pt$$ (cons (list #sym #pt$) #pt$$)) ; (sym,�O�`�_��)
      )
    );_if
    (setq #i (1+ #i))
  )
;-- 2011/09/09 A.Satoh Mod - E

  (PKW_SLinkBaseSym #pt$$ #pt0$);// �ċA�ɂ��אڂ���x�[�X�L���r����������
  CG_LinkSym                    ;// �אڂ���L���r�̊�V���{���}�`��Ԃ�
);PKW_GetLinkBaseCab

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_SLinkBaseSym
;;; <�����T�v>  : �w��}�`�̑�����x�[�X�L���r�ɗאڂ���x�[�X�L���r�l�b�g���擾����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 1999-04-13 00/05/16 YM �C�� PMEN2������
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKW_SLinkBaseSym (
  &pt$$     ;(�����,���ފO�`�_��)��ؽ�
  &pt0$     ;���ފO�`�_��
  /
  #ENS2 #I #PT$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_SLinkBaseSym ////")
  (CFOutStateLog 1 1 " ")

  (setq #i 0)
  (repeat (length &pt$$)
    (setq #enS2 (nth 0 (nth #i &pt$$))) ; ����ِ}�`
    (setq #pt$  (nth 1 (nth #i &pt$$)))
;;; �אڂ��邩�ǂ����̔��f�����߂� 00/05/10 YM
;;;    (if (or (SKW_IsExistPRectCross    (list #p1 #p2 #p3 #p4)     (list #p5 #p6 #p7 #p8))  ; �]������
;;;           (SKW_IsExistPRectCross2CP (list #p1 #p2 #p3 #p4 #p1) (list #p5 #p6 #p7 #p8))  ; �ǉ�����00/05/10 YM
;;;           (SKW_IsExistPRectCross2CP (list #p5 #p6 #p7 #p8 #p5) (list #p1 #p2 #p3 #p4))) ; �ǉ�����00/05/10 YM

    (if (SKW_IsExistPRectCross &pt0$ #pt$)  ; �]������ �_��ؽĂɓ����_�����邩�ǂ���
      (progn
        (if (= nil (member #enS2 CG_LinkSym))
          (progn
            (setq CG_LinkSym (cons #enS2 CG_LinkSym)) ; CG_LinkSym �ɂȂ�������ǉ����Ă���
            (PKW_SLinkBaseSym &pt$$ #pt$)
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
)
;PKW_SLinkBaseSym

;;; �������ް�̐}�`����\������
(defun C:kosu (/ #ss)
  (setq #ss (CFGetSameGroupSS (car(entsel "\n �}�`���w��: "))))
  (princ "\n�������ް�̐}�`��")(terpri)
  (sslength #ss)
)

;///////////////////////////////////////////////
(defun C:www ( / )
  (C:KPMakeFreeWT)
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KPMakeFreeWT
;;; <�����T�v>  : ���R�Ȍ`���ܰ�į�߂��쐬��������
;;; <�߂�l>    : WT SOLID�}�`��
;;; <�쐬>      : 01/04/13 YM
;;; <���l>      : KPCAD
;;;*************************************************************************>MOH<
(defun C:KPMakeFreeWT (
  /
  #BG_PL1 #BG_PL2 #ED #FG_PL1 #FG_PL2 #MSG1 #MSG2 #MSG3 #OS #OT #SM #WT_PL
  )
;;; ���ѕϐ��ݒ�
  (StartUndoErr);// �R�}���h�̏�����
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setq #ed (getvar "EDGEMODE" ))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "EDGEMODE"  0)

  (setq #msg1 "\n���[�N�g�b�v�̊O�`�|�����C����I��: ")
  (setq #msg2 "\n�o�b�N�K�[�h�̊O�`�|�����C����I��: ")
  (setq #msg3 "\n�O����̊O�`�|�����C����I��: ")

    ;///////////////////////////////////////////////////////
    ; �������ײ݂�I��������
    ;///////////////////////////////////////////////////////
    (defun ##GetPLINE (
      &msg
      /
      #EG$ #LOOP #MSG #PLINE
      )
      ;// �O�`�̈�̎w��
      (setq #loop T)
      (while #loop
        (setq #PLINE (car (entsel &msg)))
        (if #PLINE
          (if (and (setq #eg$ (entget #PLINE)) ; �����I�΂ꂽ
                   (= (cdr (assoc 0 #eg$)) "LWPOLYLINE")
                   (= (cdr (assoc 70 #eg$)) 1))
            (progn
              (setq #loop nil) ; ����������
              (GroupInSolidChgCol2 #PLINE CG_InfoSymCol) ; �F��ς���
            )
            (CFAlertMsg "�����|�����C���ł͂���܂���B")
          );_if
          (progn
            (setq #loop nil)
            (princ "\n�|�����C���͑I������܂���ł����B")
          )
        );_if
      );while
      #PLINE
    );##GetPLINE
    ;///////////////////////////////////////////////////////

  ; �e�O�`�̈�̑I��(�I�����₷���悤�Ɉꕔ��w���ذ��)
  ; ��w"2","3"�ذ��
  (command "_layer" "T" "1" "") ; ��w�ذ�މ���
  (command "_layer" "F" "2" "") ; ��w�ذ��
  (command "_layer" "F" "3" "") ; ��w�ذ��
  (setq #WT_PL  (##GetPLINE #msg1))
  (if (= nil #WT_PL)
    (progn
      (CFAlertMsg "���[�N�g�b�v�𐶐�����t���A�L���r�l�b�g������܂���B")
      (quit)
    )
  );_if

  ; ��w"1","3"�ذ��
  (command "_layer" "F" "1" "") ; ��w�ذ��
  (command "_layer" "T" "2" "") ; ��w�ذ�މ���
  (command "_layer" "F" "3" "") ; ��w�ذ��
  (setq #BG_PL1 (##GetPLINE #msg2))
  (setq #BG_PL2 (##GetPLINE #msg2))
  ; ��w"1","2"�ذ��
  (command "_layer" "F" "1" "") ; ��w�ذ��
  (command "_layer" "F" "2" "") ; ��w�ذ��
  (command "_layer" "T" "3" "") ; ��w�ذ�މ���
  (setq #FG_PL1 (##GetPLINE #msg3))
  (setq #FG_PL2 (##GetPLINE #msg3))
  (command "_layer" "T" "1" "") ; ��w�ذ�މ���
  (command "_layer" "T" "2" "") ; ��w�ذ�މ���

  ; SOLID�̍쐬
  (FreeWTsub #WT_PL (list #BG_PL1 #BG_PL2)(list #FG_PL1 #FG_PL2))

  ; ���ѕϐ��ݒ�
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)
  (setvar "EDGEMODE"  #ed)
  (setq *error* nil)
  (princ "\n���[�N�g�b�v�𐶐����܂����B")
);C:KPMakeFreeWT

;;;<HOM>*************************************************************************
;;; <�֐���>    : FreeWTsub
;;; <�����T�v>  : ���R�Ȍ`���ܰ�į�߂��쐬
;;; <�߂�l>    : WT SOLID�}�`��
;;; <�쐬>      : 01/04/13 YM
;;; <���l>      : KPCAD
;;;*************************************************************************>MOH<
(defun FreeWTsub (
  &WT_LINE  ; WT�O�`���ײ�
  &BG_LINE$ ; BG�O�`���ײ�ؽ�
  &FG_LINE$ ; FG�O�`���ײ�ؽ�
  /
  #BG0 #BG0$ #BG01 #BG02 #BG1 #BG2 #BG_H #BG_REGION #BG_SEP
  #BG_SOLID #BG_SOLID$ #BG_SOLID1 #BG_SOLID2 #ED
  #FG0 #FG0$ #FG01 #FG02 #FG1 #FG2 #FG_H #FG_REGION
  #FG_S #FG_SOLID #FG_SOLID$ #FG_SOLID1 #FG_SOLID2 #SETXD$
  #OS #OT #SM #SS #WT #WT0 #WT0$ #WTINFO #WT_H #WT_REGION #WT_SOLID #WT_T #ZaiCode
  )
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (defun ##NiltoStr ( &dum / )
      (if (= &dum nil)
        (setq &dum "")
      )
      &dum
    )
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ; WT���̎擾
  (setq #WTInfo (KPWTINFODlg_FreeWT)) ; �_�C�A���O�m�F�\��
  (if (= #WTInfo nil)
    (*error*) ; cancel�̏ꍇ
    (progn
      (setq #WT_H   (nth 0 #WTInfo)) ; WT���� *
      (setq #WT_T   (nth 1 #WTInfo)) ; WT���� *
      (setq #BG_H   (nth 2 #WTInfo)) ; BG���� *
      (setq #FG_H   (nth 3 #WTInfo)) ; FG���� *
      (setq #BG_Sep (nth 4 #WTInfo)) ; �ޯ��ް�ޕ���
    )
  );_if

  ;// �ގ��L���̑I��(�޲�۸ނ̕\��)
  (setq #ZaiCode (PKW_ZaiDlg nil)) ; #ZAI0

; SOLID���쐬����
  (setq #WT  &WT_LINE) ; WT���
  (setq #BG1 (car  &BG_LINE$)) ; BG���1
  (setq #BG2 (cadr &BG_LINE$)) ; BG���2
  (setq #FG1 (car  &FG_LINE$)) ; FG���1
  (setq #FG2 (cadr &FG_LINE$)) ; FG���2
;;; WT�����o������+�ړ�
  (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #WT)) (entget #WT)))
  (setq #WT0 (entlast)) ; �c�� WT���
  (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT)) (entget #WT))) ; WT��p�̉�w
  (setq #WT0$ (append #WT0$ (list #WT0)))
  (setq #WT_region (Make_Region2 #WT))
  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
;;; BG1,BG2 �����o������+�ړ�
  (foreach #BG (list #BG1 #BG2)
    (if #BG
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG)) (entget #BG)))
        (setq #BG0 (entlast)) ; �c�� BG���
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG)) (entget #BG))) ; WT��p�̉�w
        (setq #BG_region (Make_Region2 #BG))
        (setq #BG_SOLID (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
      )
      (setq #BG0 nil #BG_SOLID nil)
    );_if
    (setq #BG_SOLID$ (append #BG_SOLID$ (list #BG_SOLID)))
    (setq #BG0$ (append #BG0$ (list #BG0)))
  )
;;; FG1,FG2 �����o������+�ړ�
  (foreach #FG (list #FG1 #FG2)
    (if #FG
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG)) (entget #FG)))
        (setq #FG0 (entlast)) ; �c��
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG)) (entget #FG))) ; WT��p�̉�w
        (setq #FG_region (Make_Region2 #FG))
        (setq #FG_SOLID (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
      )
      (setq #FG0 nil #FG_SOLID nil)
    );_if
    (setq #FG_SOLID$ (append #FG_SOLID$ (list #FG_SOLID)))
    (setq #FG0$ (append #FG0$ (list #FG0)))
  )

  (setq #WT0  (##NiltoStr #WT0))
  (setq #BG01 (##NiltoStr (car  #BG0$)))
  (setq #BG02 (##NiltoStr (cadr #BG0$)))
  (setq #FG01 (##NiltoStr (car  #FG0$)))
  (setq #FG02 (##NiltoStr (cadr #FG0$)))

  (setq #WT_SOLID  (##NiltoStr #WT_SOLID))
  (setq #BG_SOLID1 (##NiltoStr (car  #BG_SOLID$)))
  (setq #BG_SOLID2 (##NiltoStr (cadr #BG_SOLID$)))
  (setq #FG_SOLID1 (##NiltoStr (car  #FG_SOLID$)))
  (setq #FG_SOLID2 (##NiltoStr (cadr #FG_SOLID$)))

  (setq #ss (ssadd))
  (if (/= #WT_SOLID  "")(ssadd #WT_SOLID  #ss))
  (if (/= #FG_SOLID1 "")(ssadd #FG_SOLID1 #ss))
  (if (/= #FG_SOLID2 "")(ssadd #FG_SOLID2 #ss))

  (if (= #BG_Sep "Y")
    (progn ; �ޯ��ް�ޕ����^
      (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
    )
    (progn ; �ޯ��ް�ޕ����^�ȊO
      (if (/= #BG_SOLID1 "")(ssadd #BG_SOLID1 #ss))
      (if (/= #BG_SOLID2 "")(ssadd #BG_SOLID2 #ss))
      (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
    )
  );_if

;;; �g���ް� "G_WRKT" �̾��

;;; �VG_WRKT �̐��` ���i�K�œ��͉\�Ȃ��̂̂�
  (setq #SetXd$                ; ���ݒ荀�ڂ�-999 or "-999"
    (list "K"                  ;1. �H��L��
          CG_SeriesCode        ;2. SERIES�L��
          #ZaiCode             ;3. �ގ��L��
          0                    ;4. �`��^�C�v�P          0,1,2(I,L,U) ���̎��_�Ŗ�����
          "F"                  ;5. �`��^�C�v�Q          F,D
          0                    ;6. ���g�p
          ""                   ;7. ���g�p
          ""                   ;8. �J�b�g�^�C�v�ԍ�      0:�Ȃ�,1:VPK,2:X,3:H ���E
          #WT_H                ;9..���[��t������        827
          "��WT���s��"         ;10.���g�p
          #WT_T                ;11.�J�E���^�[����        23
          1                    ;12.���g�p
          #BG_H                ;13.�o�b�N�K�[�h�̍���    50
          20                   ;14.�o�b�N�K�[�h����      20
          1                    ;15.���g�p
          #FG_H                ;16.�O���ꍂ��            40
          20                   ;17.�O�������            20
          0                    ;18.�O����V�t�g��         7
          0 "" "" ""           ;19.�ݸ�����H
          0 "" "" "" "" "" "" "" ;23.�������f�[�^��  �������}�`�n���h��1�`5
          "R"                  ;31.�k�q����t���O
          0.0                  ;32.���g�p
          ""                   ;33.WT����_
          ""                   ;34.���g�p
          ""                   ;35.���g�p
          "����đ��������"     ;36.���g�p
          ""                   ;37.�J�b�g��
          ""                   ;38.�J�b�g�E
          ""                   ;[39]WT��ʐ}�`�����
          0.0                  ;[40]���g�p
          0.0                  ;[41]���g�p
          0.0                  ;[42]���g�p
          0                    ;[43]�Ԍ�1 1����WT
          0                    ;[44]�Ԍ�2 2����WT
          0                    ;[45]�Ԍ�3 3����WT
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
    )
  )

  (if (= nil (tblsearch "APPID" "G_WRKT")) (regapp "G_WRKT"))
  (CFSetXData #WT_SOLID "G_WRKT" #SetXd$)

;;; �g���ް� G_BKGD�̾��
;;;  (if (equal #BG_Sep 1 0.1)
;;;    (progn ; �ޯ��ް�ޕ����^
;;;     (setq #BG_ALL_LEN 0)
;;;     (if (and #BG_SOLID1 (/= #BG_SOLID1 ""))
;;;       (setq #BG_ALL_LEN
;;;         (PKSetBGXData
;;;           (list #BG_SOLID1 #BG_SOLID2)
;;;           #cutL #cutR #ZaiCode
;;;           (list #BG01 #BG02)
;;;           #WT_SOLID nil
;;;         )
;;;       )
;;;     )
;;;      (setq #BG_LEN (+ #BG_LEN #BG_ALL_LEN))
;;;    )
;;;    (setq #BG_LEN 0)
;;;  );_if

  ;// ��w�̃t���[�Y ��ʉ�w
  (command "_layer" "F" SKW_AUTO_SECTION "")
  #WT_SOLID
);FreeWTsub

;<HOM>*************************************************************************
; <�֐���>    : KPWTINFODlg_FreeWT
; <�����T�v>  : WT���_�C�A���O
;               WT�f�ތ����Ń��R�[�h���Ƃ�Ȃ������Ƃ��ɕ\������
; <�쐬>      : 2000.3.29  YM
;*************************************************************************>MOH<
(defun KPWTINFODlg_FreeWT (
  /
  #WTInfo #dcl_id ##GetDlgItem
  )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( /
            #WT_T #BG_H #FG_H #WTInfo
            #BG_SEP #WT_H)

            (cond
              ((##Check "WT_H" (get_tile "WT_H") "ܰ�į�ߍ���")   nil)
              ((##Check "WT_T" (get_tile "WT_T") "ܰ�į�ߌ���")   nil)
              ((##Check "BG_H" (get_tile "BG_H") "�ޯ��ް�ލ���") nil)
              ((##Check "FG_H" (get_tile "FG_H") "�O���ꍂ��")    nil)
              (t ; �װ���Ȃ��ꍇ
                  (setq #WT_H (atoi (get_tile "WT_H"))) ; WT�̍���
                  (setq #WT_T (atoi (get_tile "WT_T"))) ; WT�̌���
                  (setq #BG_H (atoi (get_tile "BG_H"))) ; BG�̍���
                  (setq #FG_H (atoi (get_tile "FG_H"))) ; FG�̍���
                  (if (= (get_tile "BG_SEP_YES") "1") ; �ޯ��ް�ޕ���
                    (setq #BG_Sep "Y" )
                    (setq #BG_Sep "N" )
                  );_if
                  (setq #WTInfo (list #WT_H #WT_T #BG_H #FG_H #BG_Sep))
                (done_dialog)
              )
            );_cond
            #WTInfo
          )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Check (&sKEY &sVAL &sNAME / )
            (if (= nil (and (numberp (read &sVAL)) (< 0 (read &sVAL))))
              (progn
                (alert (strcat &sNAME "����" "\n ���l����͂��Ă������� (1�`9 �̔��p����)"))
                (mode_tile &sKEY 2)
                (eval 'T) ; �װ����
              );end of progn
            ); end of if
          ); end of ##Check
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "WTINFODlg_FreeWT" #dcl_id)) (exit))

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #WTInfo (##GetDlgItem))")
  (action_tile "cancel" "(setq #WTInfo nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #WTInfo
);KPWTINFODlg_FreeWT



;<HOM>*************************************************************************
; <�֐���>    : subKPRendWT
; <�����T�v>  : ���[�N�g�b�v�̒[���q���ނɂ���(woodone�Ή�)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2008/09/27 YM ADD
; <���l>      : ��ʂ�FILLET->extrude BG��̌^��z��
; <Ver.UP>      
;               �O�����R���ނɉ����č쐬
;*************************************************************************>MOH<
(defun subKPRendWT (
  &WT ;�V�}�` D1050 P�^
  /
  #ARC1 #ARC2 #BASEPT #BG #BG_H #BG_REGION #BG_SOLID1 #BG_SOLID2 #BG_T #BG_TEI1 #BG_TEI2
  #CUTTYPE #DELOBJ #DEP #DIST$ #FG0 #FG_H #FG_REGION #FG_S #FG_SOLID #FG_T #FG_TEI1 #FG_TEI2
  #ITYPE #LAST #LINE$ #P1 #P2 #P3 #P4 #P5 #RR #SS #SS_DUM #WTL #WTR #WT_H #WT_PT$ #WT_REGION
  #WT_SOLID #WT_T #WT_TEI #X #XD$ #XDL$ #XDR$ #XD_NEW$
  )

    ;//////////////////////////////////////////////////////////////////////////
    ;հ�ް����R(�a)���Ó�������(�߂�l:T or nil)
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##RENDhantei (
      &dist$ ; (���s��,WT����)
      &iType ; R�������� 1:���� , 2:�E�� , 3:����
      &R     ; R(�a)
      /
      #ret #dist1 #dist2
      )
      (setq #dist1 (car  &dist$))
      (setq #dist2 (cadr &dist$))
      (cond
        ((or (= &iType 2)(= &iType 3))
          (if (and (< &R #dist1)(< &R #dist2))
            (setq #ret T)
            (setq #ret nil)
          );_if
        )
        ((= &iType 1) ; ����
          (if (and (< &R (* 0.5 #dist1))(< &R #dist2))
            (setq #ret T)
            (setq #ret nil)
          );_if
        )
      );_cond
      #ret
    );##RENDhantei
    ;//////////////////////////////////////////////////////////////////////////
    ;&ss("LINE"�I���)�̂����n�_or�I�_��&pt�ƈ�v����}�`ؽĂ�Ԃ�
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##GETLINE (
      &ss
      &pt
      /
      #EN #I #LIST$
      )
      (setq #list$ nil)
      (if (and &ss (< 0 (sslength &ss)))
        (progn
          (setq #i 0)
          (repeat (sslength &ss)
            (setq #en (ssname &ss #i))
            (if (or (< (distance (cdr (assoc 10 (entget #en))) &pt) 0.1)
                    (< (distance (cdr (assoc 11 (entget #en))) &pt) 0.1))
              (setq #list$ (append #list$ (list #en)))
            );_if
            (setq #i (1+ #i))
          )
        )
      );_if
      #list$
    )
    ;//////////////////////////////////////////////////////////////////////////
    ;&en("LINE"�}�`)-->�n�_,�I�_�����_��Ԃ�
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##CENTER_PT ( &en / #DUM)
      (setq #dum (mapcar '+ (cdr (assoc 10 (entget &en)))
                            (cdr (assoc 11 (entget &en)))))
      (setq #dum (mapcar '* #dum '(0.5 0.5 0.5)))
    )

    ;//////////////////////////////////////////////////////////////////////////
    ;&en(������ʐ}�` or "")���폜����
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL ( &en / )
      (if (and &en (/= &en "")(entget &en))
        (entdel &en)
      );_if
      (princ)
    )

    ;//////////////////////////////////////////////////////////////////////////
    ;fillet����
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##FILLET ( &line$ / #ARC #EN1 #EN2 #SP1 #SP2)
      (if &line$
        (progn
          (setq #en1 (car  &line$))
          (setq #en2 (cadr &line$))
          (setq #sp1 (##CENTER_PT #en1))
          (setq #sp2 (##CENTER_PT #en2))
          (command "_fillet" (list #en1 #sp1)(list #en2 #sp2))
          (setq #arc (entlast))
        )
        (progn
          (CFAlertMsg "�t�B���b�g�������ł��܂���ł����B")(quit)
        )
      );_if
      #arc
    )

    ;//////////////////////////////////////////////////////////

  ;�V�� �}�`��= &WT

  ;��đ�(���E)���f
  (cond
    ((= (nth 11 CG_GLOBAL$) "L")
      (setq #x "Left")  ; R���ޑ�=��
    )
    ((= (nth 11 CG_GLOBAL$) "R")
      (setq #x "Right") ; R���ޑ�=�E
    )
  );_cond

  ;Xdata "G_WRKT"
  (setq #xd$ (CFGetXData &WT "G_WRKT"))

  ; WT���擾
  (setq #WT_H (nth  8 #xd$))  ; WT����
  (setq #WT_T (nth 10 #xd$))  ; WT����
  (setq #BG_H (nth 12 #xd$))  ; BG����
  (setq #BG_T (nth 13 #xd$))  ; BG����
  (setq #FG_H (nth 15 #xd$))  ; FG����
  (setq #FG_T (nth 16 #xd$))  ; FG����
  (setq #FG_S (nth 17 #xd$))  ; FG��ė�

  ; �e��ʎ擾
  (setq #WT_tei (nth 38 #xd$))   ; WT��ʐ}�`�����
  (setq #BASEPT (nth 32 #xd$))   ; WT����_
  (setq #BG_tei1 (nth 49 #xd$))  ; BG SOLID1 or ���1
  (setq #BG_tei2 (nth 50 #xd$))  ; BG SOLID2 or ���2 ��������΂��̂܂�
  (setq #FG_tei1 (nth 51 #xd$))  ; FG1��� *
  (setq #FG_tei2 (nth 52 #xd$))  ; FG2��� *
  (setq #dep (car (nth 57 #xd$))); WT���s��

  ; WT��ʓ_��擾
  (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))     ; WT�O�`�_��
  (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT ����_���玞�v����ɕ��ёւ���
  (setq #p1 (nth 0 #WT_pt$)) ; WT����_
  (setq #p2 (nth 1 #WT_pt$)) ; WT�E��_
  (setq #p3 (nth 2 #WT_pt$))
  (setq #p4 (nth 3 #WT_pt$))
  (setq #p5 (nth 4 #WT_pt$))
  (setq #last (last #WT_pt$))

  ; R���މ������p���@ WT�������"10","01"
;;; (setq #dist$ (KPGetRendDist #WT_pt$ #CutType)) ; (���s��,WT����)

  ; ���H���� R���ނ����� /1=����/2=����/3=�E��/
  (setq #iType 1)
  ; R���ނ�R(�a)
  (setq #rr "60")
  (command "_fillet" "R" #rr)

  ;// �����̃��[�N�g�b�v(�O���ꍞ��3DSOLID)���폜
  (entdel &WT)
  ; ������ʍ폜
  (##ENTDEL #FG_tei1)
  (##ENTDEL #FG_tei2)

  ; WT��ʂ��߰���ĕ���
  (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT_tei)) (entget #WT_tei)))
  (command "_explode" (entlast))
  (setq #ss_dum (ssget "P")) ; LINE�̏W�܂�
  ; ��ʂ�Fillet����
  (cond
    ((= #x "Right")
      (cond
        ((= #iType 1) ; ����R����
          (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2��[�_�Ɏ���"LINE"��ؽĂ��擾
          (setq #arc1  (##FILLET #line$))       ; Fillet����"ARC"���擾
          (setq #line$ (##GETLINE #ss_dum #p3))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc1 #ss_dum)
          (ssadd #arc2 #ss_dum)
          ; FG��ʍ쐬 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen #x #WT_pt$ #arc1 #arc2 #FG_T #rr))
        )
        ((= #iType 2) ; ����R����
          (setq #line$ (##GETLINE #ss_dum #p3))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc2 #ss_dum)
          ; FG��ʍ쐬 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen_R2 #WT_pt$ #arc2 #FG_T #rr))
        )
        ((= #iType 3) ; �E��R����
          (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2��[�_�Ɏ���"LINE"��ؽĂ��擾
          (setq #arc1  (##FILLET #line$))       ; Fillet����"ARC"���擾
          ; FG��ʍ쐬 01/07/10 YM ADD
          (ssadd #arc1 #ss_dum)
          (setq #FG0 (KPMakeFGTeimen_R3 #WT_pt$ #arc1 #FG_T #rr))
        )
      );_cond
    )
    ((= #x "Left")
      (cond
        ((= #iType 1) ; ����R����
          (setq #line$ (##GETLINE #ss_dum #p1))
          (setq #arc1  (##FILLET #line$))
          (setq #line$ (##GETLINE #ss_dum #last))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc1 #ss_dum)
          (ssadd #arc2 #ss_dum)
          ; FG��ʍ쐬 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen #x #WT_pt$ #arc1 #arc2 #FG_T #rr))
        )
        ((= #iType 2) ; ����R����
          (setq #line$ (##GETLINE #ss_dum #p1))
          (setq #arc1  (##FILLET #line$))
          ; FG��ʍ쐬 01/07/10 YM ADD
          (ssadd #arc1 #ss_dum)
          (setq #FG0 (KPMakeFGTeimen_L2 #WT_pt$ #arc1 #FG_T #rr))
        )
        ((= #iType 3) ; �E��R����
          (setq #line$ (##GETLINE #ss_dum #last))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc2 #ss_dum)
          ; FG��ʍ쐬 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen_L3 #WT_pt$ #arc2 #FG_T #rr))
        )
      );_cond
    )
  );_cond

  (setq #delobj (getvar "delobj")) ; extrude��̒�ʂ�ێ�����  "delobj"=0
  (setvar "delobj" 1)              ; extrude��̒�ʂ�ێ����Ȃ�"delobj"=1

  ; Pedit ���ײ݉� WT �č쐬
  (command "_pedit" (ssname #ss_dum 0) "Y" "J" #ss_dum "" "X") ; "X" ���ײ݂̑I�����I��

  (setq #WT_region (Make_Region2 (entlast)))
  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))

;;; BG_SOLID�č쐬
;;; #BG_tei1
;;; #BG_tei2
  (setq #BG_SOLID1 nil #BG_SOLID2 nil)
  (if (and #BG_tei1 (/= #BG_tei1 ""))
    (progn
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG_tei1)) (entget #BG_tei1))) ; SOLID��w�ɂ���-->�����o���p
      (setq #BG (entlast)) ; extrude�p
      (setq #BG_region (Make_Region2 #BG))
      (setq #BG_SOLID1 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
    )
  );_if

  (if (and #BG_tei2 (/= #BG_tei2 ""))
    (progn
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG_tei2)) (entget #BG_tei2))) ; SOLID��w�ɂ���-->�����o���p
      (setq #BG (entlast)) ; extrude�p
      (setq #BG_region (Make_Region2 #BG))
      (setq #BG_SOLID2 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
    )
  );_if

  ; FG_SOLID�č쐬
  (if #FG0
    (progn
      (setq #FG_region (Make_Region2 #FG0))
      (setq #FG_SOLID  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if

  (setvar "delobj" #delobj) ; �V�X�e���ϐ���߂�

  (setq #ss (ssadd))
  (ssadd #WT_SOLID #ss)
  (if #BG_SOLID1 (ssadd #BG_SOLID1 #ss)) ; BG_SOLID��ǉ�
  (if #BG_SOLID2 (ssadd #BG_SOLID2 #ss)) ; BG_SOLID��ǉ�
  (if #FG_SOLID  (ssadd #FG_SOLID #ss))  ; FG_SOLID��ǉ�

  ;BG,WT�̘a���Ƃ�
  (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I

  ;// �g���f�[�^�̍Đݒ� �O����Ȃ�
  (setq #xd_new$
  (list
    (list 51   "");[52]:FG ��ʐ}�`�����1
    (list 52   "");[53]:FG ��ʐ}�`�����2
  ))
  (CFSetXData #WT_SOLID "G_WRKT"
    (CFModList #xd$ #xd_new$)
  )

  (setq #WTL (nth 47 #xd$)) ; ��đ���WT��
  (setq #WTR (nth 48 #xd$)) ; ��đ���WT�E

  ;����WT�̊g���f�[�^���X�V����
  (if (and (/= #WTL "") (/= #WTL nil))
    (progn
      (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; ����
      (CFSetXData #WTL "G_WRKT"
        (CFModList #xdL$
          (list
            (list 48 #WT_SOLID)     ;[49]�J�b�g����WT����ىE U�^�͍��E�ɂ���
          )
        )
      )
    )
  );_if

  ;�E��WT�̊g���f�[�^���X�V����
  (if (and (/= #WTR "") (/= #WTR nil))
    (progn
      (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; �E��
      (CFSetXData #WTR "G_WRKT"
        (CFModList
          #xdR$
          (list
            (list 47 #WT_SOLID)     ;[48]�J�b�g����WT����ٍ� U�^�͍��E�ɂ���
          )
        )
      )
    )
  );_if
  #WT_SOLID ; WT�}�`
);subKPRendWT

;<HOM>*************************************************************************
; <�֐���>    : C:TOKU_TENBAN
; <�����T�v>  : �V������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 
; <���l>      : 
;*************************************************************************>MOH<
(defun C:TOKU_TENBAN (
  /
  #loop #WT #xd$ #wk_xd$ #hinban_dat$ #BG1 #BG2 #CG_TOKU_HINBAN
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:TOKU_TENBAN ////")
  (CFOutStateLog 1 1 " ")

  ; �R�}���h�̏�����
  (StartUndoErr)
  (CFCmdDefBegin 0)
  (CFNoSnapReset)


	; 2019/03/04 YM MOD �ꍇ�킯
	(cond
		((= BU_CODE_0013 "1") ; PSKC�̏ꍇ
			(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
		)
		((= BU_CODE_0013 "2") ; PSKD�̏ꍇ
			(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
		)
		(T ;����ȊO
			(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
		)
	);_if
	; 2019/03/04 YM MOD �ꍇ�킯


	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

  (if (equal (KPGetSinaType) 2 0.1)
    (progn
      (CFAlertMsg msg8)
      (quit)
    )
    (progn
      ; ���[�N�g�b�v�̎w��
      (initget 0)
      (setq #loop T)
      (while #loop
        (setq #WT (car (entsel "\n���[�N�g�b�v��I��: ")))
        (if #WT
          (setq #xd$ (CFGetXData #WT "G_WRKT"))
          (setq #xd$ nil)
        );_if

        (if (/= #xd$ nil)
          (progn
            (setq #wk_xd$ (CFGetXData #WT "G_WTSET"))
            (if (/= #wk_xd$ nil)
              (progn
                (PCW_ChColWT #WT "MAGENTA" nil)
                (setq #loop nil)
              )
;              (if (= (nth 0 #wk_xd$) 1)
;                (progn
;                  (PCW_ChColWT #WT "MAGENTA" nil)
;                  (setq #loop nil)
;                )
;                (progn
;                  (CFAlertMsg "�w�肵�����[�N�g�b�v�͓����i�ł��B")
;                  (exit)
;                )
;              )
              (CFAlertMsg "�w�肵�����[�N�g�b�v�͕i�Ԃ��m�肳��Ă��܂���B")
            )
          )
          (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
        )

        (if (= (nth 0 #wk_xd$) 1)
          ; �K�i������
          (setq #hinban_dat$
            (list
              0                  ; �����t���O
;;;              "ZZ6500"           ; �i��
              #CG_TOKU_HINBAN     ; �i�� 2016/08/30 YM ADD (4)�V�Ȃ̂ŋ@��ȊO 2019/03/04 YM MOD �ꍇ�킯
              "0"                ; ���z
              (nth 5 #wk_xd$)    ; ��
              (nth 6 #wk_xd$)    ; ����
              (nth 7 #wk_xd$)    ; ���s
;              (nth 4 #wk_xd$)    ; �i��
;;;              (strcat "ĸ���(" (nth 1 #wk_xd$) ")")    ; �i��
							CG_TOKU_HINMEI     ; �i�� 2016/08/30 YM ADD
              (nth 8 #wk_xd$)    ; �����R�[�h
            )
          )
          ; ����������
          (setq #hinban_dat$
            (list
              0                       ; �����t���O
;;;              "ZZ6500"                ; �i��
              #CG_TOKU_HINBAN     ; �i�� 2016/08/30 YM ADD (4)�V�Ȃ̂ŋ@��ȊO 2019/03/04 YM MOD �ꍇ�킯
              (rtos (nth 3 #wk_xd$))  ; ���z
              (nth 5 #wk_xd$)         ; ��
              (nth 6 #wk_xd$)         ; ����
              (nth 7 #wk_xd$)         ; ���s
;;;              (nth 4 #wk_xd$)         ; �i��
							CG_TOKU_HINMEI     ; �i�� 2016/08/30 YM ADD
              (nth 8 #wk_xd$)         ; �����R�[�h
            )
          )
        )

        ; �V�i���m��_�C�A���O����
;-- 2011/12/12 A.Satoh Mod - S
;;;;;        (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$))
        (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$ (nth 3 #xd$)))
;-- 2011/12/12 A.Satoh Mod - E
        (if (= #hinban_dat$ nil)
          (exit)
        )

        (CFSetXData #WT "G_WTSET" (CFModList #wk_xd$
            (list
              (list 0 (nth 0 #hinban_dat$))
              (list 1 (nth 1 #hinban_dat$))
              (list 3 (nth 2 #hinban_dat$))
              (list 4 (nth 6 #hinban_dat$))
              (list 5 (nth 3 #hinban_dat$))
              (list 6 (nth 4 #hinban_dat$))
              (list 7 (nth 5 #hinban_dat$))
              (list 8 (nth 7 #hinban_dat$))
							(if (= (nth 9 #wk_xd$) "")
              	(list 9 (nth 1 #wk_xd$))
              	(list 9 (nth 9 #wk_xd$))
							)
            ))
        )
        (CFSetXData #WT "G_WRKT" (CFModList #xd$ (list (list 58 "TOKU"))))

        (command "_.change" #WT "" "P" "C" CG_WorkTopCol "")
        ;;; BG,FG���ꏏ�ɐF�ւ�����
        (setq #BG1 (nth 49 #xd$))
        (setq #BG2 (nth 50 #xd$))
        (if (/= #BG1 "")
          (progn
            (if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
              (command "_.change" #BG1 "" "P" "C" CG_WorkTopCol "")
            )
          )
        );_if
        (if (/= #BG2 "")
          (progn
            (if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
              (command "_.change" #BG2 "" "P" "C" CG_WorkTopCol "")
            )
          )
        );_if

      )
    )
  )

;  (alert "�������@�H�����@������")

  (CFNoSnapFinish)
  (CFCmdDefFinish)
  (setq *error* nil)
  (princ)
);C:TOKU_TENBAN


;-- 2012/04/20 A.Satoh Add �V���N�z�u�s��Ή� - S
;;;<HOM>*************************************************************************
;;; <�֐���>    : getSinkDep
;;; <�����T�v>  : �V���N�L���r�l�b�g���z�u���ꂽ�V�̉��s���擾����
;;; <�߂�l>    : ���s or nil
;;; <�쐬>      : 2012/04/20 A.Satoh
;;; <���l>      : �V���N����������ꍇ�́A�ŏ��Ɍ��������V���N���̉��s��Ԃ�
;;;*************************************************************************>MOH<
(defun getSinkDep (
	&wk_en			; ���[�N�g�b�v�}�`
	/
	#xd_WRKT$ #wt_pnt$ #snk$$ #snk$ #snkcab$ #sink_pnt$ #kei #chk_flg #err_flag
	#p1 #p2 #p3 #p4 #p5 #p6 #p7 #p8 #ret
	#PD #PDSIZE
	)

	;2012/06/25 YM ADD-S JudgeNaigai�̌��ʂ����nil�ˉ��s�����߂�ꂸ�A�V���N�z�u�ł��Ȃ�
  (setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "pdmode" 34)
  (setvar "PDSIZE" 10)
	;2012/06/25 YM ADD-E JudgeNaigai�̌��ʂ����nil�ˉ��s�����߂�ꂸ�A�V���N�z�u�ł��Ȃ�

	(setq #err_flag nil)

	; �V�̓_��������߂�
	(setq #xd_WRKT$ (CFGetXData &wk_en "G_WRKT"))
	(setq #wt_pnt$ (GetLWPolyLinePt (nth 38 #xd_WRKT$)))			; WT�O�`�_��
	(setq #wt_pnt$ (GetPtSeries (nth 32 #xd_WRKT$) #wt_pnt$))	; WT����_��擪�Ɏ��v����

	; ���_��^��ɐݒ肷��
	(command "vpoint" "0,0,1")

	; �V���ɂ���V���N�L���r���擾�˓V�z�u��_���擾
	(setq #snkcab$ nil)
;;;	(setq #snk$$ (nth 0 (PKW_GetWorkTopAreaSym3 &wk_en)))
;;;	(foreach #snk$ #snk$$
;;;		(setq #snkcab$ (append #snkcab$ (list (nth 1 #snk$))))
;;;	)

	;2014/07/02 YM MOD-S
	(setq #snkcab$ (PKGetSymBySKKCodeCP #wt_pnt$ CG_SKK_INT_SCA)) ; �V�̈��ݸ����
	(setq #snkcab$ (NilDel_List #snkcab$))

	(if #snkcab$
		(progn
			nil
;;;			;�V���N�L���r�V���{����_�����߂Ă���
;;;			(setq #sink_pnt$ (nth 1 (CFGetXData (car #snkcab$) "G_LSYM")))
;;;			;2012/06/25 YM ADD-S JudgeNaigai�̌��ʂ����nil�ˉ��s�����߂�ꂸ�A�V���N�z�u�ł��Ȃ�
;;;			(setq #sink_pnt$ (list (nth 0 #sink_pnt$) (nth 1 #sink_pnt$)))
;;;			;2012/06/25 YM ADD-E JudgeNaigai�̌��ʂ����nil�ˉ��s�����߂�ꂸ�A�V���N�z�u�ł��Ȃ�
		)
		(progn
			(setq #err_flag T)
			(setq #ret nil)
		)
	);_if

	(if (= #err_flag nil)
		(progn
			; �V�̓_�񐔂ɂ�鏈���̐U�蕪��
			(setq #kei (nth 3 #xd_WRKT$))
			(setq #chk_flg nil)
			(cond
				((= #kei 1)	; L�^
					(setq #p1 (nth 0 #wt_pnt$))
					(setq #p2 (nth 1 #wt_pnt$))
					(setq #p3 (nth 2 #wt_pnt$))
					(setq #p4 (nth 3 #wt_pnt$))
					(setq #p5 (nth 4 #wt_pnt$))
					(setq #p6 (nth 5 #wt_pnt$))

					; ��P�̈�`�F�b�N
;;;					(if (JudgeNaigai #sink_pnt$ (list #p1 #p2 #p3 #p4 #p1))
;;;						(progn
;;;							(setq #ret (car (nth 57 #xd_WRKT$)))
;;;							(setq #chk_flg T)
;;;						)
;;;					)

				 	; ��P�̈�`�F�b�N
					(setq #exist (PKGetSymBySKKCodeCP (list #p1 #p2 #p3 #p4 #p1) CG_SKK_INT_SCA)) ; �V�̈��ݸ����
					(if #exist
						(progn
							(setq #ret (car (nth 57 #xd_WRKT$)));2�Ԗ�
							(setq #chk_flg T)
						)
					);_if

					(if (= #chk_flg nil)
						(progn
						; ��Q�̈�`�F�b�N
;;;						(if (JudgeNaigai #sink_pnt$ (list #p4 #p5 #p6 #p1 #p4))
;;;							(progn
;;;								(setq #ret (cadr (nth 57 #xd_WRKT$)))
;;;								(setq #chk_flg T)
;;;							)
;;;						);_if

							; ��Q�̈�`�F�b�N
							(setq #exist (PKGetSymBySKKCodeCP (list #p4 #p5 #p6 #p1 #p4) CG_SKK_INT_SCA)) ; �V�̈��ݸ����
							(if #exist
								(progn
									(setq #ret (cadr (nth 57 #xd_WRKT$)));2�Ԗ�
									(setq #chk_flg T)
								)
							);_if

						)
					);_if

				)
				((= #kei 2)	; U�^
					(setq #p1 (nth 0 #wt_pnt$))
					(setq #p2 (nth 1 #wt_pnt$))
					(setq #p3 (nth 2 #wt_pnt$))
					(setq #p4 (nth 3 #wt_pnt$))
					(setq #p5 (nth 4 #wt_pnt$))
					(setq #p6 (nth 5 #wt_pnt$))
					(setq #p7 (nth 6 #wt_pnt$))
					(setq #p8 (nth 7 #wt_pnt$))

					; ��P�̈�`�F�b�N
;;;					(if (JudgeNaigai #sink_pnt$ (list #p1 #p2 #p3 #p4 #p1))
;;;						(progn
;;;							(setq #ret (car (nth 57 #xd_WRKT$)))
;;;							(setq #chk_flg T)
;;;						)
;;;					);_if

				 	; ��P�̈�`�F�b�N
					(setq #exist (PKGetSymBySKKCodeCP (list #p1 #p2 #p3 #p4 #p1) CG_SKK_INT_SCA)) ; �V�̈��ݸ����
					(if #exist
						(progn
							(setq #ret (car (nth 57 #xd_WRKT$)));2�Ԗ�
							(setq #chk_flg T)
						)
					);_if

					(if (= #chk_flg nil)
						(progn
							
						; ��Q�̈�`�F�b�N
;;;						(if (JudgeNaigai #sink_pnt$ (list #p4 #p5 #p8 #p1 #p4))
;;;							(progn
;;;								(setq #ret (cadr (nth 57 #xd_WRKT$)))
;;;								(setq #chk_flg T)
;;;							)
;;;						);_if

							; ��Q�̈�`�F�b�N
							(setq #exist (PKGetSymBySKKCodeCP (list #p4 #p5 #p8 #p1 #p4) CG_SKK_INT_SCA)) ; �V�̈��ݸ����
							(if #exist
								(progn
									(setq #ret (cadr (nth 57 #xd_WRKT$)));2�Ԗ�
									(setq #chk_flg T)
								)
							);_if
						)
					);_if

					(if (= #chk_flg nil)
						(progn

						; ��R�̈�`�F�b�N
;;;						(if (JudgeNaigai #sink_pnt$ (list #p5 #p6 #p7 #p8 #p5))
;;;							(progn
;;;								(setq #ret (caddr (nth 57 #xd_WRKT$)))
;;;								(setq #chk_flg T)
;;;							)
;;;						);_if

								; ��R�̈�`�F�b�N
								(setq #exist (PKGetSymBySKKCodeCP (list #p5 #p6 #p7 #p8 #p5) CG_SKK_INT_SCA)) ; �V�̈��ݸ����
								(if #exist
									(progn
										(setq #ret (caddr (nth 57 #xd_WRKT$)));3�Ԗ�
										(setq #chk_flg T)
									)
								);_if
							)

					);_if
				)
				(T						; I�^
					(setq #ret (car (nth 57 #xd_WRKT$)))
				)
			)
		)
	)

	;2012/06/25 YM ADD-S JudgeNaigai�̌��ʂ����nil�ˉ��s�����߂�ꂸ�A�V���N�z�u�ł��Ȃ�
  (setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)
	;2012/06/25 YM ADD-E JudgeNaigai�̌��ʂ����nil�ˉ��s�����߂�ꂸ�A�V���N�z�u�ł��Ȃ�

	; ���_�����ɖ߂�
	(command "ZOOM" "P")

;;(princ "\n#ret = ")(princ #ret)(princ)
	#ret

) ;getSinkDep
;-- 2012/04/20 A.Satoh Add �V���N�z�u�s��Ή� - E

(princ)