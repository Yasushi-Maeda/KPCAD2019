; 03/04/01 YM MOD DR??** ==> DR???** �ύX�ς�

;;; �����p
;;;(defun PCD_AlignDoor           ���}�`��z�u����
;;;(defun C:ChgDr                : ���ʕύX(�S��)
;;;(defun C:ChgDrCab             : ���ʕύX(�ʃL���r�l�b�g)
;;;(defun PCD_MakeViewAlignDoor <---�v�����������\�t��
;;;(defun GetXYMaxMinFromPT$  �_���X�ő�,�ŏ�,Y�ő�,�ŏ�ؽĂ�Ԃ�
;;;(defun KP_WritePOLYLINE    ���ײݏ�ɓ������ײ݂�����
;;;(defun KP_MEJIRotate       �ڒn�����̏��180�x��]������
;;;(defun KP_MakeHantenMEJI   �ڒn�̒�`�𗠕\���]���������ײ݂�Ԃ�
;;;(defun KPstrViewLayer      #strViewLayer �����߂�
;;;(defun KPGetDoorGroup      DoorGroup�}�`�������߂�
;;;(defun KP_Get340SSFromDrgroup   ��"GROUP"�}�`(#Door)����340���ް�}�`�̑I��Ă��擾
;;;(defun KP_Get340SSFromDrgroup$  ��"GROUP"�}�`ؽ�(#Door$)����S340���ް�}�`�̑I��Ă��擾
;;;(defun KP_GetDoorBasePT         ��"GROUP"�}�`��������i������"POINT"�}�`���������ʒu���W(2D)���擾
;;;(defun KP_CheckDrgroup          ��"GROUP"�}�`ؽĂ̂���&flg�ƍ�����"GROUP"�}�`��Ԃ�
;;;(defun KPGetEnDoor              ���ٰ�߂����ް��1��Ԃ�
;;;(defun KcGetDoorInsertPnt       ���}�`�̑}��3D�_�����߂�
;;;(defun PcGetLRButtomPos         �|�����C���Ɛݒu�p�x����E�_�A���_���Z�o
;;;(defun SKD_GetGroupSymbole
;;;(defun PKD_MakeSqlBase
;;;(defun SKD_GetLeftButtomPos
;;;(defun SKD_GetRightButtomPos
;;;(defun SKD_ChangeLayer
;;;(defun SKD_DeleteNotView
;;;(defun SKD_DeleteNotView_TOKU ���}�`��L�k��Ɖ�w�Ɉړ�
;;;(defun SCD_GetDoorGroupName      ���}�`�̃O���[�v�쐬
;;;(defun SKD_GetDoorPos
;;;(defun SKD_FigureExpansion   <--- �L�k
;;;(defun GetGruopMaxMinCoordinate      "GROUP"����LINE,POLYLINE�͈͂̍ő�ŏ������߂�
;;;(defun SKD_Expansion
;;;(defun SKD_DeleteInsertLayer
;;;(defun SKD_DeleteHatch
;;;(defun PKD_EraseDoor
;;;(defun SKD_ChgSeriesDlg
;;;(defun SetLayer ( / )     �\����w�̐ݒ���s��


;;;<HOM>***********************************************************************
;;; <�֐���>    : ALL_DBCONNECT
;;; <�����T�v>  : �ذ�ޕ�,����DB�Đڑ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      :;2011/12/05 YM ADD
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun ALL_DBCONNECT ( / )
	; ARX�ă��[�h
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
  )
	;(command "delay" "500")

	;�ذ�ޕ�DB�Đڑ�
	(DBDisConnect CG_DBSESSION)
	(setq CG_DBSESSION nil)
	;(command "delay" "500")
	(setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))			

	;����DB�Đڑ�
	(DBDisConnect CG_CDBSESSION)
	(setq CG_CDBSESSION nil)
	;(command "delay" "500")
	(setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))

	(if (= CG_DBSESSION CG_CDBSESSION)
		;�����Ȃ�������
		(setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
	);_if

	(princ)
);ALL_DBCONNECT

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:MDB
;;; <�����T�v>  : ���̏��DB�ڑ�
;;; <�쐬>      : 2011/12/27 YM ADD
;;;*************************************************************************>MOH<
(defun C:MDB( / ) (ALL_DBCONNECT));C:MDB

;;;<HOM>***********************************************************************
;;; <�֐���>    : PCD_AlignDoor
;;; <�����T�v>  : ���}�`��z�u����
;;; <�߂�l>    : �����F T      ���s�Fnil
;;; <�쐬>      :
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun PCD_AlignDoor (
  &Obj$          ;���\�t�Ώۂ̃V���{��
  &SetFace       ;�\��t����ʂ̎��(2:2D-�o�� 3:3D�ڒn�̈�)
  &EraseFlg      ;�������ʂ̍폜�t���O (T:�폜 nil:�폜���Ȃ�)
  /
  #DData$        ; ���ʎw��̂���G���e�B�e�B���i�[�p
  #enData$       ; �}�`�f�[�^�i�[�p
  #DbGet         ; �f�[�^�x�[�X����擾�����f�[�^�i�[�p
  #enSymName     ; �V���{���̃G���e�B�e�B�����擾����
  #symData$      ; �V���{���̊g���f�[�^�i�[�p
  #strViewLayer  ; ���ʗp�\����w���i�[�p
  #strFileName   ; �C���T�[�g�}�`�t�@�C�����i�[�p
  #pos$          ; �C���T�[�g���W�l�i�[�p
  #Door          ; �O���[�v�����ꂽ���ʃf�[�^�̃O���[�v�̃G���e�B�e�B��
  #INO
  #Temp$         ; �e���|�������X�g
  #iLoop         ; ���[�v�p
  #iFlag         ; ���[�v�A�E�g�p�t���O
  #enName        ; foreach �p
  #ANG #ANG2 #DOORP #DRANG #EDELDOORBRK_D$ #EDELDOORBRK_H$ #EDELDOORBRK_W$
  #EG #EN$ #ENANG #FF #GG$ #GROUP$ #IVP #LEFTDOWN_PT #MEJI #MINMAX$ #OS
  #PT #RIGHTUP_PT #SM #VECTOR #VP #XLINE_H #XLINE_W #TOKU_DRGRNAME #DOOR$
  #CABANG #DOORANG #GNAM #MEJI$ #MEJIDATA$ #SURFACE #SYM0 #XDMEJI$ #MEJI_LAY
  #NEWMEJI #NEWMEJI$ #SSDOOR #MVPT #CG_DOOR_MOVE #XLINE_D
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PCD_AlignDoor ////")
  (CFOutStateLog 1 1 " ")

  (setq #os (getvar "OSMODE")); 00/02/18 YM ADD from lemon 2/9
  (setq #sm (getvar "SNAPMODE")); 00/02/18 YM ADD from lemon 2/9
  (setvar "OSMODE"     0); 00/02/18 YM ADD from lemon 2/9
  (setvar "SNAPMODE"   0); 00/02/18 YM ADD from lemon 2/9

	;2012/06/14 YM ADD-S �����ԍ�=30,46�ǉ���EASY����KPCAD�A�g�����Ƃ��A���ꊇ�ύX��MJ,FJ(�����ԍ�=30,46)�ɕύX���Ă����������Ȃ�
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")


  ;; ���}�`�p�A�v���P�[�V�������̓o�^
  (regapp SKD_EXP_APP)

  ;; �L�k��Ɨp�e���|������w�̍쐬 ;�ǉ�  00/02/15 MH ADD
  (if (tblsearch "LAYER" SKD_TEMP_LAYER)
    (progn
      (command "_layer" "U" SKD_TEMP_LAYER "")  ; �x�����b�Z�[�W�΍��2���ɕ�����  Uۯ�����
      (command "_layer" "ON" SKD_TEMP_LAYER "T" SKD_TEMP_LAYER "")  ; ON�\�� T�ذ�މ���
     ); end of progn        N�V�K C�F L����
    (command "_layer" "N" SKD_TEMP_LAYER "C" 1 SKD_TEMP_LAYER "L" SKW_AUTO_LAY_LINE SKD_TEMP_LAYER "")
  )
  ;// ���݂̃r���[��ۑ�����
  (command "_view" "S" "TEMP")
  ;// �����̔��ʂ��\��t�����Ă���΍폜
  (if CG_TOKU
    (progn ; �������޺���ޒ��͔��̓\�蒼���������Ɋ��������g�p����
      (setq #Door$ (KPGetDoorGroup (car &Obj$))) ; 01/05/11 YM
;;;01/05/18YM@      (setq #Door (KPGetDoorGroup (car &Obj$))) ; 01/05/11 YM
    )
    (if (= &EraseFlg T)
      (foreach #en &Obj$
        (PKD_EraseDoor #en)
      )
    );_if
  );_if

  (if (or (= &SetFace nil) (= &SetFace 3))
    (progn
      ;// 3D�ڒn�̈�̎擾
      (setq #Temp$ (ssget "X" '((-3 ("G_MEJI" (1070 . 1))))))
      (if (/= #Temp$ nil)
        (progn
          (setq #iLoop 0)
          (while (< #iLoop (sslength #Temp$))
            (setq #MEJI (ssname #Temp$ #iLoop))   ; 01/04/04 YM ADD �g�p�敪=1�̂ݎ擾
            (setq #xdMEJI$ (CFGetXData #MEJI "G_MEJI"))
            (if (= 1 (nth 0 #xdMEJI$)) ; �g�p�敪=1�̂ݎ擾
              (progn
                (setq #MEJI$ (entget #MEJI))
                (setq #vector (cdr (assoc 210 #MEJI$))); MEJI���ײ݉����o������
                (setq #surface (nth 1 #xdMEJI$)) ; ����:0,3 �w��:4 �E����:6 ������:5
                ; �擾�}�`�f�[�^���瓯��O���[�v���̃V���{���f�[�^���擾����
                (setq #Sym0 (SKD_GetGroupSymbole #MEJI$))
                (setq #CABang (nth 2 (CFGetXData #Sym0 "G_LSYM"))) ; ���ޔz�u�p�x

                (setq #DoorANG (angle '(0 0 0) #vector)) ; ���@���޸�ق̌���
                (setq #DoorANG (Angle0to360 #DoorANG)) ; 0�`360�x�̒l�ɂ���
                ;(Angle0to360 <radian>) ; 0�`360�x�̒l�ɂ���

                ; G_MEJI�̒�`���t��������폜���čč쐬
;;;               (cond
;;;                 ((or (= 0 #surface)(= 3 #surface)) ; ���ʂ̂ݑΉ�
;;;                   (if (equal (Angle0to360 (+ #CABang (dtr -90))) #DoorANG 0.001) ; MEJI����������`����Ă��邩
;;;                     nil ; �������Ȃ�
;;;                     (progn ; MEJI�s��==>�폜�č쐬
;;;                       (setq #newMEJI (KP_MakeHantenMEJI #MEJI #Sym0)) ; MEJI�č쐬
;;;                       (setq #newMEJI$ (entget #newMEJI))
;;;                       ; ��w�� #MEJI_lay �ɂ���
;;;                       (setq #MEJI_lay (cdr (assoc 8 #MEJI$))); MEJI��w
;;;                       (entmod (subst (cons 8 #MEJI_lay) (assoc 8 #newMEJI$) #newMEJI$))
;;;                       (CFSetXData #newMEJI "G_MEJI" #xdMEJI$) ; �g���ް����
;;;                       (setq #gnam (SKGetGroupName #Sym0)) ; ��ٰ�ߖ��擾
;;;                       ;;; newMEJI�̸�ٰ�߉�
;;;                       (command "-group" "A" #gnam #newMEJI "")
;;;                        ;; 3D �ڒn�̃n�b�`���O������
;;;                        (SKD_DeleteHatch #MEJI)
;;;                       (entdel #MEJI) ; ����MEJI�폜
;;;                       (setq #MEJI #newMEJI) ; �V�����ڒn�̈���g�p
;;;                     )
;;;                   );_if
;;;                 )
;;;                 ((= 4 #surface) ; �w��
;;;                   nil ; ���Ή� 01/04/06 YM
;;;                 )
;;;                 ((= 6 #surface) ; �E����
;;;                   nil ; ���Ή� 01/04/06 YM
;;;                 )
;;;                 ((= 5 #surface) ; ������
;;;                   nil ; ���Ή� 01/04/06 YM
;;;                 )
;;;                 (T
;;;                   nil ; ���Ή� 01/04/06 YM
;;;                 )
;;;               );_cond

                (setq #DData$ (cons #MEJI #DData$)) ; �g�p�敪=1�Ȃ�
                (setq #iLoop (+ #iLoop 1))
              )
            );_if

          );while
        )
      )
    )
  );_if

  (if (or (= &SetFace nil) (= &SetFace 2))
    (progn
      ;// 2D���̈�̎擾
      (setq #Temp$ (ssget "X" '((-3 ("G_PMEN" (1070 . 7))))))
      (if (/= #Temp$ nil)
        (progn
          (setq #iLoop 0)
          (while (< #iLoop (sslength #Temp$))
            (setq #DData$ (cons (ssname #Temp$ #iLoop) #DData$))
            (setq #iLoop (+ #iLoop 1))
          )
        )
      )
    )
  )

  (setq CG_DOORLST '()) ; 2000/06/21 HT ���x���P�̂��� ADD

  ;; ���ʎw�肳�ꂽ�f�[�^�����݂��邩�ǂ����`�F�b�N
  (if (/= #DData$ nil)
    (progn    ;; ���ʎw�肳�ꂽ�f�[�^��������
      (setq #iNo 0)

      ;; �̈搔�����[�v
      (while (< #iNo (length #DData$)) ; MEJI�̐���ٰ��

        (setq #enName (nth #iNo #DData$)) ; �}�ʏ��"G_MEJI" (1070 . 1)�S�� #DData$
        ;; �}�`�f�[�^�擾
        (setq #enData$ (entget #enName '("*")))  ; �g���f�[�^���܂߂Ď擾
        ;; �擾�}�`�f�[�^���瓯��O���[�v���̃V���{���f�[�^���擾����
        (setq #enSymName (SKD_GetGroupSymbole #enData$))

        ; 2000/06/22 [�W�J�}�쐬]�R�}���h�̎��́A���x���P�̂���
        ; ���i�}�̏ꍇ�̂ݏ������A�R�s�[����(SCFmat.lsp �W�J���}�쐬 �W�J�})
        (if (or (and (= CG_OUTCMDNAME "SCFMakeMaterial")
              (= CG_OUTSHOHINZU (substr (cdr (assoc 8 #enData$)) 6 2))) ; 01/05/28 YM �{�H�}�łȂ����i�}�̂Ƃ�
;;;01/05/28YM@              (= CG_OUTSEKOUZU (substr (cdr (assoc 8 #enData$)) 6 2)))
              (/= CG_OUTCMDNAME "SCFMakeMaterial")
            ) ; 2000/06/22 HT ���x���P�̂��� ADD
          (progn
            (if (member #enSymName &Obj$)     ;�I��}�`�ȊO�͏������Ȃ�  "G_MEJI"�}�`�̐e���I�������ΏۂƓ�����
              (if (/= #enSymName nil); �V���{���̗L�����`�F�b�N
                (progn    ; �V���{�������݂���
                  (setq #symData$ (CFGetXData #enSymName "G_LSYM"))
                  ;; �V���{������f�[�^���擾�ł������ǂ����̃`�F�b�N
                  (if (/= #symData$ nil)
                    (progn    ; �V���{���̊g���f�[�^���擾�ł���

                      ; 01/09/25 YM ADD-S G_LSYM�ɔ�װ��Ă���
                      ; �g���ް��ɔ�ذ��&��װ���
                      (if (= &SetFace 3) ; 01/10/31 YM ADD �W�J�}�쐬�̂Ƃ��ȉ��̏����͗v��Ȃ��I
                        (progn
                          (if (= CG_DRColCode nil)(setq CG_DRColCode ""))
                          (CFSetXData #enSymName "G_LSYM"
                            (CFModList #symData$
                              (list

                                ; (list 7 (strcat CG_DRSeriCode "," CG_DRColCode)) ;[8]��ذ��,��װ 01/10/05 YM ADD
                                ; [8]��ذ��,��װ,��� 02/11/30 YM ADD SX�Ή� �����ێ�

;;;         ;KPCAD�p�̉��ݒ�
;;;         (setq CG_DRSeriCode  "C")  ;��SERIES�L��
;;;         (setq CG_DRColCode  "M*")  ;��COLOR�L��
;;;         (setq CG_HIKITE      "D")  ;HIKITE�L��

                                (if (or (= CG_HIKITE "")(= CG_HIKITE nil))
                                  (list 7 (strcat CG_DRSeriCode "," CG_DRColCode)) ; ���܂łǂ���
                                  ;else
                                  (list 7 (strcat CG_DRSeriCode "," CG_DRColCode "," CG_HIKITE)) ; SX
                                );_if

                              )
                            )
                          )
                        )
                      );_if
                      ; 01/09/25 YM ADD-E G_LSYM�ɔ�װ��Ă���

                      ;; �f�[�^�x�[�X����x�[�XID(���}�`ID)�̎擾
                      (setq #DbGet (PKD_MakeSqlBase #symData$ &SetFace)) ; ���}�`�h�c
                      ;; �f�[�^�x�[�X����x�[�XID���擾�ł������ǂ����`�F�b�N
                      (if (/= #DbGet nil)
                        (progn    ; �x�[�XID���擾�ł���
                          (setq #strFileName (strcat CG_DRMSTDWGPATH
                                                     SKD_DOOR_CODE       ;  "DR"
                                                     (substr #DbGet 1 5)    ; 03/04/01 YM MOD DR??** ==> DR???** �ύX�ɔ���
                                                     ;;;(substr #DbGet 1 4) ; 03/04/01 YM MOD DR??** ==> DR???** �ύX�ɔ���
                                                     SKD_DOOR_FILE_EXT)  ; ."DWG"
                          )
                          ;; �uDR+�x�[�XID(��4��).dwg�v�̃t�@�C���̗L�����`�F�b�N
                          (if (/= (findfile #strFileName) nil)
                            (progn    ; �t�@�C����������

                              ; #strViewLayer �����߂�(�֐��� 01/05/11 YM)
                              (setq #strViewLayer (KPstrViewLayer #enName #enData$ #DbGet))

                              ;; ���W�𓾂�
                              ;�w�ʂ̏ꍇ�͉E���_�����
                              (if (= (substr #strViewLayer 3 2) "04")
                                (setq #Temp$ (SKD_GetRightButtomPos #enName))
                                (setq #Temp$ (SKD_GetLeftButtomPos  #enName))
                              )

                              ;(setq #pos$ (car #Temp$))
                              ;(setq #pos$ (trans
                              ;  (append #pos$ (list (cdr (assoc 38 #enData$)))) #enName 1 0))
                              ; 00/11/08 MH ADD �}����_�Z�o�����֐���
                              (setq #pos$ (KcGetDoorInsertPnt #enSymName #enName))

  ;;;(trans pt from to [disp])
  ;;;����
  ;;;pt : 3D �_�܂��� 3D �ψ�(�x�N�g��)��\�� 3 �̎����̃��X�g�B
  ;;;from : pt �̍��W�n��\�������R�[�h�A���ږ��A�܂��� 3D �����o���x�N�g�B
  ;;;      �����R�[�h�ɂ́A���̒l�� 1 ���w�肷�邱�Ƃ��ł��܂��B
  ;;;0  ���[���h(WCS) , 1  ���[�U(���݂� UCS)

                              (setq #Temp$ (cdr #Temp$))
                             ;// �w�ʂ�P�ʂ̉����o�����������ʂƓ����P�[�X�����邽�ߊp�x�𔽓]������
                              (setq #ang (nth 2 #symData$))

                              ; 00/08/21 ADD MH 00/08/21 DEL MH DRMASTER�̕ύX�ŕs�v��
                              ; �w�ʂȂ�NewPad�V�X�e���ł͊�}�`�̗��\�𔽉f�����Ȃ�

                              ; �����ŉE���_��V�֐��Ŏ�蒼�� ===>???���ĉ������Ă݂� 01/03/13 YM @@@@@@@@@@@@@@@@@@@@@@@@@
  ;;;                            (if (= (substr #strViewLayer 3 2) "04")
  ;;;                              (setq #pos$ (PcGetLRButtomPos #enName (nth 2 #symData$) "R"))
  ;;;                            );if
                              ; �����ŉE���_��V�֐��Ŏ�蒼�� ===>???���ĉ������Ă݂� 01/03/13 YM @@@@@@@@@@@@@@@@@@@@@@@@@

                              (if (= (substr #strViewLayer 3 2) "04") ;�w�ʂ̏ꍇ�͉E���_�����
                                (progn
                                  (setq #eg (entget #enSymName))
                                  (setq #pt (cdr (assoc 10 #eg)))
                                  (if (< 100 (distance (list (car #pt) (cadr #pt))
                                                       (list (car #pos$) (cadr #pos$))))
                                    (progn
                                      (setq #ang (- #ang (dtr 180)))
                                    )
                                  )
                                )
                              );_if


    (if CG_TOKU ; �������޺���ގ��͔���INSERT���Ȃ� 01/05/11 YM ADD
      (progn
;-- 2011/12/19 A.Satoh Del�i2011/11/24�̉��C�����ɖ߂��j- S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;				(if CG_POS_STR
;;;;;      		(progn
;;;;;						;; ���ʐ}�`�t�@�C������ʎw��̈�̍������킹��
;;;;;						;; �C���T�[�g����(�C���T�[�g�}�`�� �}���ʒu X�ړx Y�ړx �p�x)
;;;;;						(command "_insert" #strFileName #pos$ 1 1 (angtos #ang))
;;;;;
;;;;;						;; �C���T�[�g�}�`�𕪉����A�s�v�ȉ�w�̃f�[�^�͍폜���A
;;;;;						;; �c�����\������f�[�^��L�k��Ɖ�w�Ɉړ����A�O���[�v������
;;;;;						(setq #Door (SKD_DeleteNotView (entlast) #strViewLayer))
;;;;;      		)
;;;;;    		)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/12/19 A.Satoh Del�i2011/11/24�̉��C�����ɖ߂��j- E

        ; ���ݑΏۂ̔�"GROUP"�}�`#door�����߂�==>����,�w�ʂ𕪂����1����ڰ�ײ݈ʒu�ł�
        ; �������܂��L�k�ł��Ȃ�?==>�ʖ�����ڰ�ײ݈ʒu�𒲐�����

;-- 2011/12/19 A.Satoh Del�i2011/11/24�̉��C�����ɖ߂��j- S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;				(if (= CG_POS_STR nil)
;;;;;					(progn
;;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/12/19 A.Satoh Del�i2011/11/24�̉��C�����ɖ߂��j- E
        ; ���ݏ����Ώۂ͐���?�w��? -->���f����ٰ�ߖ��ōs����悤�C�� "DoorGroup"+("3","4"�Ȃ�)+(�ԍ�)
        (setq #door (KP_CheckDrgroup (substr #strViewLayer 4 1) #Door$)) ; ���ݏ����Ώۂ͐���?�w��

        ; ��"GROUP"�}�`(#Door)����340���ް�}�`�̑I��Ă��擾�A����L�k��w�Ɉړ�
        ; ===>������ٰ�߂̑S�Ă̍\�����ް����x�ɔ��L�k(���������)==>�߂�
;;;       (SKD_DeleteNotView_TOKU (KP_Get340SSFromDrgroup$ #Door$))

        ; D�����L�k���ɔ����ړ� 01/05/31 YM ADD
        (if #Door ; 01/12/11 YM #Door=nil���������
          (setq #ssDOOR (KP_Get340SSFromDrgroup #Door)) ; ���}�`
          (setq #ssDOOR nil) ; 01/12/11 YM #Door=nil���������
        );_if


;@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;(setq CG_DOOR_MOVE03 nil)
;;;(setq CG_DOOR_MOVE06 nil)
;@@@@@@@@@@@@@@@@@@@@@@@@@@@

;;;01/09/25YM@DEL       (if CG_DOOR_MOVE
        (if (or CG_DOOR_MOVE06 CG_DOOR_MOVE03) ; 01/09/25 YM MOD
          (progn

            ; 01/09/25 YM ADD-S
            (if (or (and CG_DOOR_MOVE03 (= "03" (substr #strViewLayer 3 2)))  ; ���ʔ��͈ړ�
                    (and CG_DOOR_MOVE06 (= "06" (substr #strViewLayer 3 2)))) ; �E���ʔ��͈ړ�
              (progn
                (if (and CG_DOOR_MOVE03 (= "03" (substr #strViewLayer 3 2)))
                  (setq #CG_DOOR_MOVE CG_DOOR_MOVE03)
                );_if

                (if (and CG_DOOR_MOVE06 (= "06" (substr #strViewLayer 3 2)))
                  (setq #CG_DOOR_MOVE CG_DOOR_MOVE06)
                );_if
            ; 01/09/25 YM ADD-E

                ; 01/09/07 YM ADD-S
                ; ���ٷ��ނ���������L��#DoorANG���̂܂܂��ƕʂ̳��ٷ��ނ�MEJI�p�x�ɂȂ�ꍇ����
                ; �Ώۼ���ِ}�`��MEJI������@���޸�ق̌������擾����
                (setq #vector (cdr (assoc 210 (entget #enName)))); MEJI���ײ݉����o������
                (setq #DoorANG (angle '(0 0 0) #vector)) ; ���@���޸�ق̌���
                (setq #DoorANG (Angle0to360 #DoorANG)) ; 0�`360�x�̒l�ɂ���
;;;(if CG_DOOR_MOVE_RIGHT ; �ړ�����������
;;; (setq #DoorANG (+ #DoorANG (dtr 90))) ; 01/09/25 ���ړ����������ʂł͂Ȃ��A�������ĉE����
;;;);_if
                ; 01/09/07 YM ADD-E

;;;               (if CG_DOOR_MOVE_RIGHT ; �ړ����������� 01/09/25 YM ADD
;;;                 nil ; �ړ����Ȃ�
;;;                 (progn
                    (setq #MVPT (pcpolar '(0 0 0) #DoorANG #CG_DOOR_MOVE))
                    ; CG_DOOR_MOVE : �ړ��� , #vector : ���@���޸��
                    (command "_move" #ssDOOR "" '(0 0 0) #MVPT)
;;;                 )
;;;               );_if

            ; 01/09/25 YM ADD-S
              )
            );_if
            ; 01/09/25 YM ADD-E

          )
        );_if

        (if #ssDOOR ; 01/12/11 YM #Door=nil���������
          (SKD_DeleteNotView_TOKU #ssDOOR)
        );_if
;;;       (SKD_DeleteNotView_TOKU (KP_GetDoorSSFromSYM #enSymName)) ; ����L�k��w�Ɉړ�
;-- 2011/12/19 A.Satoh Del�i2011/11/24�̉��C�����ɖ߂��j- S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;					)
;;;;;    		)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/12/19 A.Satoh Del�i2011/11/24�̉��C�����ɖ߂��j- E
      )
      (progn

                              ;; ���ʐ}�`�t�@�C������ʎw��̈�̍������킹��
                              ;; �C���T�[�g����(�C���T�[�g�}�`�� �}���ʒu X�ړx Y�ړx �p�x)
                              (command "_insert" #strFileName #pos$ 1 1 (angtos #ang))
(command "_REGEN")
                              ;; �C���T�[�g�}�`�𕪉����A�s�v�ȉ�w�̃f�[�^�͍폜���A
                              ;; �c�����\������f�[�^��L�k��Ɖ�w�Ɉړ����A�O���[�v������
                              (setq #Door (SKD_DeleteNotView (entlast) #strViewLayer))
      )
    );_if       ; �������޺���ގ��͔���INSERT���Ȃ� 01/05/11 YM ADD

                              ;; ���ʂ̔z�u&�\��������ɏI���������ǂ����̃`�F�b�N
                              (if (/= #Door nil)
                                (progn    ; ���ʂ̕\��������ɏI������
                                  ;; �L�k�������s��
                                  (if CG_STRETCH
                                    (progn

  ;/////////////////////////////////////////////////////////////////////////////////////
    (if CG_TOKU ; �������޺���ޒ� ; 01/02/09 YM
      (progn
        ; ���ٰ�߂����ް��1��Ԃ�==>group���擾 01/05/11 YM ADD

;;;       (if (= (substr #strViewLayer 3 2) "04") ;�w�ʂ̏ꍇ�͉E���_�����
;;;         (princ)
;;;       );_if

        ; KPGetEnDoor:���ٰ�߂����ް��1��Ԃ�
        (setq #TOKU_DrGrName (SKGetGroupName (KPGetEnDoor #door)))

  ;;;     (setq SKD_GROUP_NO (SCD_GetDoorGroupName)) ; ���ٰ�ߖ��̔ԍ��X�V
    ; �e�}�`�̊p�x�Ɩڒn�̈��"G_MEJI"���ALR�t���O���狁�߂�_�̕����𔻒�
        (setq #enANG (nth 2 (CFGetXData #enSymName "G_LSYM"))) ; ���єz�u�p�x
        (setq #VP (cadr (CFGetXData #enName "G_MEJI")))
        (cond
          ((= 6 #VP)(setq #DrANG (+ (* 0.5 pi) #enANG))); ��Ű����
          ((= 4 #VP)(setq #DrANG (+ pi #enANG))); �w��
          (t (setq #DrANG #enANG)); ���̑��͐��ʂƂ��ĎZ�o (= 0 #VP) ��ʐ���  (= 3 #VP) �R�[�i�[����
        ); cond

        ; ������ڰ�ײݍ폜,�ꎞ��ڰ�ײݒǉ�
        (setq #GG$ (entget #Door))
        (setq #FF T)
        (foreach #GG #GG$
          (if #FF
            (if (= (car #GG) 340)
              (if (and (= (cdr (assoc 0 (entget (cdr #GG)))) "XLINE")
                       (CFGetXData (cdr #GG) "G_BRK")) ; ��ڰ�ײ݂͏���
                nil
                (progn
                  (setq #FF nil)
                  (setq #doorP (cdr #GG))
                )
              );_if
            );_if
          );_if
        )
  ;;;     (setq #doorP (cdr (assoc 340 (entget #Door)))) ; #doorP ��BRK��������_��
        (setq #eDelDoorBRK_W$ (PcRemoveBreakLine #doorP "W")) ; W�����u���[�N����
        (setq #eDelDoorBRK_D$ (PcRemoveBreakLine #doorP "D")) ; D�����u���[�N����
        (setq #eDelDoorBRK_H$ (PcRemoveBreakLine #doorP "H")) ; H�����u���[�N����

        ; ����==> #pos$ (����),�w��==> #pos$ (�E��)
        ; 01/02/08 YM ���}�`�̍����A�E����W(World���W�n)�����߂�(��ڰ�ײݍ쐬�ɗp����)
        ; #MinMax$ ����==>����,�E�� �w��==>�E��,����
        (setq #MinMax$ (GetGruopMaxMinCoordinate #Door #pos$)) ; �ǂ��ɒǉ����邩�ɕK�v

        (setq #LeftDown_PT (car  #MinMax$)) ; ����
        (setq #RightUp_PT  (cadr #MinMax$)) ; �E��

        ;@@@@@@@@@ H �����u���[�N���C���ǉ� 01/02/07 YM CG_TOKU_BH
        ;;; ��ڰ�ײ݂̍�}
        (if CG_TOKU_BH
          (progn
            (setq #XLINE_H
              (PK_MakeBreakH
                #LeftDown_PT ; ������
                CG_TOKU_BH
              )
            ) ; �_(x,y,*),����Z
            (CFSetXData #XLINE_H "G_BRK" (list 3))
            ;;; ��ڰ�ײ̸݂�ٰ�߉�
            (command "-group" "A" #TOKU_DrGrName #XLINE_H "")
    ;;;       (command "-group" "A" (strcat SKD_GROUP_HEAD (itoa SKD_GROUP_NO)) #XLINE_H "")
          )
        );_if

        ; 01/09/25 YM ADD-S /////////////////////////////////////////////////////
        ;@@@@@@@@@ D �����u���[�N���C���ǉ� CG_TOKU_BD
        ;;; ��ڰ�ײ݂̍�}
        (if CG_TOKU_BD
          (progn
            (setq #XLINE_D
              (PK_MakeBreakD
                (cdr (assoc 10 (entget #enSymName))) ; ����ي�_���W --->01/09/25 YM MOD
                #enANG
                CG_TOKU_BD
              )
            )
            (CFSetXData #XLINE_D "G_BRK" (list 2))
            ;;; ��ڰ�ײ̸݂�ٰ�߉�
            (command "-group" "A" #TOKU_DrGrName #XLINE_D "")
        ; 01/09/25 YM ADD-E /////////////////////////////////////////////////////
          )
        );_if


        ;@@@@@@@@@ W �����u���[�N���C���ǉ� 01/02/07 YM CG_TOKU_BW
        ;;; ��ڰ�ײ݂̍�}
        (if CG_TOKU_BW
          (progn
            (setq #XLINE_W
              (PK_MakeBreakW
    ;;;01/09/25YM@DEL           #LeftDown_PT ; ������
                (cdr (assoc 10 (entget #enSymName))) ; ����ي�_���W --->01/09/25 YM MOD
    ;;;               #DrANG
                #enANG ; 01/05/21 YM MOD
                CG_TOKU_BW
              )
            )
            (CFSetXData #XLINE_W "G_BRK" (list 1))
            ;;; ��ڰ�ײ̸݂�ٰ�߉�
            (command "-group" "A" #TOKU_DrGrName #XLINE_W "")
    ;;;       (command "-group" "A" (strcat SKD_GROUP_HEAD (itoa SKD_GROUP_NO)) #XLINE_W "")
          )
        );_if

      )
    );_if
  ;/////////////////////////////////////////////////////////////////////////////////////

                                      (SKD_Expansion #Door #enData$) ; "GROUP"DoorGroup,���ʗ̈�MEJI,�������_

  ;/////////////////////////////////////////////////////////////////////////////////////
    (if CG_TOKU ; �������޺���ޒ� 01/02/09 YM
      (progn
        (foreach #eD #eDelDoorBRK_W$ (entdel #eD)) ; W�����u���[�N����
        (foreach #eD #eDelDoorBRK_D$ (entdel #eD)) ; D�����u���[�N����
        (foreach #eD #eDelDoorBRK_H$ (entdel #eD)) ; H�����u���[�N����
        (if #XLINE_W (entdel #XLINE_W)) ; �ꎞ��ڰ�ײݍ폜
        (if #XLINE_D (entdel #XLINE_D)) ; �ꎞ��ڰ�ײݍ폜
        (if #XLINE_H (entdel #XLINE_H)) ; �ꎞ��ڰ�ײݍ폜
      )
    );_if
  ;/////////////////////////////////////////////////////////////////////////////////////

                                    )
                                  );_if

                                  ; 2000/06/22 [�W�J�}�쐬]�R�}���h�̎��́A���x���P�̂��߂̏����ɂ���
                                  (if (= CG_OUTCMDNAME "SCFMakeMaterial")
                                    (progn
                                     ; "0_door"��w�ɁA�L�k�Ώۂ������}�`��u��(�R�}���h��temp�Ƃ���)
;;;                                    (setq #en$ (SKD_ChangeLayer #Door "0_door"));03/09/29 YM MOD
                                     (setq #en$ (SKD_ChangeLayer_FMAT #Door "0_door"));03/09/29 YM MOD

                                    ; 2000/06/22 (�V���{���}�`�� (�h�A�}�`��) P��7����1) ���O���[�o���ϐ��ɐݒ肷��
                                    ; �g�p����̂́A�W�J�}�쐬��������
                                    ; (setq #iVP (cdr (nth 2 (cadr (assoc -3 #enData$))))) 2000/10/05 HT MOD
                                    (setq #iVP (atoi(substr #strViewLayer 3 2))) ; �w�ʂɔ���Q���C
                                    ;YM@ �Ⴆ��"Q_03_99_01_##"�̏ꍇ #iVP=3

                                    ;(if (/= 0 #iVP)
                                      ;(progn
                                      ; �V���{���̊p�x���擾����
                                      (setq #ang2 (nth 2 (CfGetXData #enSymName "G_LSYM")))
                                      ; �V���{���̊p�x���O�i+-45�x��0�j�łȂ����ALsym��]�p�x�ŕϊ���
                                      (setq #ang2 (Angle0to360 #ang2))

                                      ;@YM (rtd 5.497)=314.955�x,(rtd 6.283)=359.989�x,(rtd 6.283)=44.9772�x
                                      (if (not (or (<= 5.497 #ang2 6.283) (<= 0.0 #ang2 0.785)))
                                        (progn ;@YM 314.955�x�`359.989�x�܂���0�x�`44.9772�x�͈̔͂ɂȂ��ꍇ
                                          ; �V���{���̊p�x���X�O�x�P�ʂɊۂ߂�
                                          (cond
                                            ((or (<= 5.497 #ang2 6.283) (<= 0.0 #ang2 0.785))
                                              (setq #ang2 0)
                                            )
                                            ((<= 0.785 #ang2 2.356) (setq #ang2  1.571)) ;@YM 90.0117�x
                                            ((<= 2.356 #ang2 3.927) (setq #ang2 3.1415)) ;@YM 179.995�x
                                            ((<= 3.927 #ang2 5.497) (setq #ang2 4.7123)) ;@YM 269.995�x
                                          )
                                        )    ; ������if���I��
                                      );_if  ; ������if���I��

                                      ; P��7����1�����ۂ̎��_������Lsym��]�p�x�ŕϊ�����
                                      ; Lsym��]�p�x�ŕϊ�����

                                      (cond
                                        ((equal #ang2 0 0.1) ; �ۂߌ�z�u�p�x=0�x
                                          (cond
                                            ((=  #iVP 3) (setq #iVP 3)) ; OK!
                                            ((=  #iVP 4) (setq #iVP 5))
                                            ((=  #iVP 5) (setq #iVP 4))
                                            ((=  #iVP 6) (setq #iVP 6)) ; OK!
                                          )
                                        )
                                        ((equal #ang2 1.571 0.1) ; �ۂߌ�z�u�p�x=90�x
                                          (cond
                                            ((=  #iVP 3) (setq #iVP 6))
                                            ((=  #iVP 4) (setq #iVP 4))
                                            ((=  #iVP 5) (setq #iVP 3))
                                            ((=  #iVP 6) (setq #iVP 5))
                                          )
                                        )
                                        ((equal #ang2 3.14159 0.1) ; �ۂߌ�z�u�p�x=180�x
                                          (cond
                                            ((=  #iVP 3) (setq #iVP 5))
                                            ((=  #iVP 4) (setq #iVP 3))
                                            ((=  #iVP 5) (setq #iVP 6))
                                            ((=  #iVP 6) (setq #iVP 4))
                                          )
                                        )
                                        ((equal #ang2 4.71239 0.1) ; �ۂߌ�z�u�p�x=270�x
                                          (cond
                                            ((=  #iVP 3) (setq #iVP 4))
                                            ((=  #iVP 4) (setq #iVP 6))
                                            ((=  #iVP 5) (setq #iVP 5))
                                            ((=  #iVP 6) (setq #iVP 3))
                                          )
                                        )
                                      ) ; cond

                                      ; �O���[�o���ϐ��ɂ��ߍ���
                                      ; (�V���{���}�`�� �h�A�}�`�����X�g ���_����)
                                      (setq CG_DOORLST (append CG_DOORLST (list (list #enSymName #en$ #iVP))))
                                    )
                                  );_if

                                  ;(command "_UCS" "P")    ; ���O�̏�Ԃɖ߂�

                                  (if (/= CG_OUTCMDNAME "SCFMakeMaterial")
                                    (progn
  ;;;                                   (setq SKD_GROUP_NO (SCD_GetDoorGroupName)) ; ���ٰ�ߖ��̔ԍ��X�V 01/03/12 YM ADD
                                      ;; ���}�`��L�k��Ɖ�w������ʎw���w�Ɉړ�����
                                      (SKD_ChangeLayer #Door (cdr (assoc 8 #enData$)))

;;;(atoi(substr #strViewLayer 3 2)) ; 01/02/27 YM �Q��
                              (if CG_TOKU ; �������޺���ޒ� 01/02/09 YM
;-- 2011/12/19 A.Satoh Mod �i2011/11/24 �̉��C�����ɖ߂��j- S
;;;;;;-- 2011/11/24 A.Satoh Mod - S
;;;;;																(if CG_POS_STR
;;;;;												      		(progn
;;;;;																		;; 3D �ڒn�̃n�b�`���O������
;;;;;																		(SKD_DeleteHatch #enName)
;;;;;																		;; �O���[�v��
;;;;;																		(command "-group" "A" (strcat SKD_GROUP_HEAD (substr #strViewLayer 4 1)(itoa SKD_GROUP_NO)))
;;;;;																		(setq #Group$ (entget #Door))
;;;;;																		(foreach #nn #Group$ ; ���O���[�v�̗v�f�����ǉ�����
;;;;;																			(if (= (car #nn) 340)(command (cdr #nn)))
;;;;;																		)
;;;;;																		(command #enSymName "")
;;;;;																	)
;;;;;																	nil
;;;;;																)
;;;;;
                                nil
;;;;;;-- 2011/11/24 A.Satoh Mod - E
;-- 2011/12/19 A.Satoh Mod �i2011/11/24 �̉��C�����ɖ߂��j- E
                                (progn ; (�������޺���ގ��͕K�v�Ȃ�)
                                      ;; 3D �ڒn�̃n�b�`���O������
                                      (SKD_DeleteHatch #enName)
                                      ;; �O���[�v��
                                      (command "-group" "A" (strcat SKD_GROUP_HEAD (substr #strViewLayer 4 1)(itoa SKD_GROUP_NO)))
                                      (setq #Group$ (entget #Door))
                                      (foreach #nn #Group$ ; ���O���[�v�̗v�f�����ǉ�����
                                        (if (= (car #nn) 340)(command (cdr #nn)))
                                      )
                                      (command #enSymName "")
                                )
                              );_if

                                    )
                                  );_if
                                )
                              );_if
                            )
                          );_if
                        )
                      );_if
                    )
                  );_if
                )
              );_if

            );_if

          )
        );_if
        (setq #iNo (+ #iNo 1))
      )
    )
  )
  (setvar "OSMODE"     #os)
  (setvar "SNAPMODE"   #sm)

  ;// �r���[�����ɖ߂�
  (command "_view" "R" "TEMP")
  ;// �u���[�N���C�����\��
  (command "_layer" "of" "N_B*" "F" SKD_TEMP_LAYER "")
  (command "_layer" "on" "M_*" "") ; 07/07 YM ADD(�װ���]��"OF"�ɂȂ���̂�����)
)
;PCD_AlignDoor


;�t���[���L�b�`���@�ꕔ����ގg�p���~
(defun FK_MSG ( / )
	
	(if (= BU_CODE_0012 "1")
		(progn
;CG_FK_MSG1
			(CFYesDialog CG_FK_MSG1)
			(quit)
		)
	);_if

);FK_MSG


;<HOM>*************************************************************************
; <�֐���>    : C:ChgDr
; <�����T�v>  : ���ʂ̈ꊇ�ύX
; <�߂�l>    :
; <�쐬>      : 1999-06-14
; <���l>      :
;*************************************************************************>MOH<
(defun C:ChgDr (
  /
  #XRec$
  #ret$
  #i
  #ss
  #en$ #SYMTOKU$ #TOKU$ #SYMNORMAL$ #TOKU
#FP #PLANINFO$ #SFNAME ;2010/01/08 YM ADD
;-- 2011/07/12 A.Satoh Add - S
  #en2$ #idx
;-- 2011/07/12 A.Satoh Add - E
;-- 2011/09/14 A.Satoh Add - S
  #ss2
;-- 2011/09/14 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ChgDr ////")
  (CFOutStateLog 1 1 " ")

	
  ; 01/10/31 YM ADD-S
  (setq CG_OUTCMDNAME "ChgDr")
  ; 01/10/31 YM ADD-E

  ;// �R�}���h�̏�����
  (StartUndoErr)


	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)


  (CFCmdDefBegin 6);00/09/26 SN ADD
  ; 02/01/15 YM ADD
  (CabShow_sub) ; ��\�����ނ�\������ 01/05/31 YM ADD

  ;// ���݂̏��i�����擾����

;�g��ں���"SERI"�̓��e
;;;          (setq CG_DBNAME      (nth  0 #seri$)) ; 1.DB����
;;;          (setq CG_SeriesCode  (nth  1 #seri$)) ; 2.SERIES�L��
;;;          (setq CG_BrandCode               "N") ; 3.�u�����h�L��
;;;          (setq CG_DRSeriCode  (nth  2 #seri$)) ; 2.��SERIES�L��
;;;          (setq CG_DRColCode   (nth  3 #seri$)) ; 3.��COLOR�L��
;;;          (setq CG_HIKITE      (nth  4 #seri$)) ; 4.�q�L�e�L��
;;;          (setq CG_UpCabHeight (nth  5 #seri$)) ; 6.��t����
;;;          (setq CG_CeilHeight  (nth  5 #seri$)) ; 7.�V�䍂��
;;;          (setq CG_RoomW       (nth  6 #seri$)) ; 8.�����Ԍ�
;;;          (setq CG_RoomD       (nth  7 #seri$)) ; 9.�������s
;;;          (setq CG_GasType     (nth  8 #seri$)) ;10.�K�X��

  (setq #XRec$ (CFGetXRecord "SERI"))
  (if (= #XRec$ nil)
    (CFAlertErr "��x�����i�ݒ肪����Ă��܂���\n���i�ݒ���s���ĉ�����")
  )

  (setq #ret$
    (SRSelectDoorSeriesDlg_Handle
      "���ʈꊇ�ύX"
      (nth 0 #XRec$);�Ώۃf�[�^�x�[�X��
      (nth 1 #XRec$);SERIES�L��
      (nth 3 #XRec$);��SERIES�L��
      (nth 4 #XRec$);��COLOR�L��
      (nth 5 #XRec$);����L��
    )
  )

;-- 2011/07/12 A.Satoh Add - S
  (if (/= #ret$ nil)
    (progn
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
;-- 2011/09/14 A.Satoh Mod - S
;      (if (/= #ss nil)
;        (progn
;          (setq #idx 0)
;          (setq #en2$ nil)
;          (repeat (sslength #ss)
;            (setq #en2$ (append #en2$ (list (ssname #ss #idx))))
;            (setq #idx (1+ #idx))
;          )
;          (if (/= #en2$ nil)
;            (if (= nil (CheckDoorGradeHinban #en2$ (car #ret$) (cadr #ret$)))
;              (setq #ret$ nil)
;            )
;          )
;        )
;      )
      (setq #idx 0)
      (setq #en2$ nil)
      (repeat (sslength #ss)
        (setq #en2$ (append #en2$ (list (ssname #ss #idx))))
        (setq #idx (1+ #idx))
      )

      (setq #ss2 (ssget "X" '((-3 ("G_FILR")))))
			(if (and #ss2 (< 0 (sslength #ss2)))
				(progn
		      (setq #idx 0)
		      (repeat (sslength #ss2)
		        (setq #en2$ (append #en2$ (list (ssname #ss2 #idx))))
		        (setq #idx (1+ #idx))
		      )
				)
			);_if
      (if (/= #en2$ nil)
        (progn
          (setq #en2$ (CheckDoorGradeHinban #en2$ (car #ret$) (cadr #ret$)))
          (if (/= #en2$ nil)
            (progn
              (setq #idx 0)
              (repeat (length #en2$)
                (if (equal CG_BASESYM (nth #idx #en2$)) ;�����
                  (GroupInSolidChgCol (nth #idx #en2$) CG_BaseSymCol)
                  (GroupInSolidChgCol2 (nth #idx #en2$) "BYLAYER")
                );_if
                (setq #idx (1+ #idx))
              )
            )
          )
        )
      )
;-- 2011/09/14 A.Satoh Mod - E
    )
  )
;-- 2011/07/12 A.Satoh Add - E

  (if (/= #ret$ nil)
    (progn
      ; ���\��t�����"G_LSYM"�ɔ��,���,����Ă��邽�߈ꎞ�I�ɸ�ٰ��پ��
      (setq CG_DRSeriCode (car  #ret$))  ;��SERIES�L��(��۰��ٍX�V)
      (setq CG_DRColCode  (cadr #ret$))  ;��COLOR�L���@(��۰��ٍX�V)
      (setq CG_Hikite    (caddr #ret$))  ;���L��(��۰��ٍX�V)

      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (if (and #ss (< 0 (sslength #ss))) ;2011/08/05 YM ADD if���ǉ�����
        (progn
          
          (setq #i 0)
          (repeat (sslength #ss)
              (setq #en$ (cons (ssname #ss #i) #en$))
            (setq #i (1+ #i))
          )
          ; 01/03/12 YM ADD �������ނƈ�ʷ��ނ𕪂���
          (setq #symTOKU$ nil #symNORMAL$ nil #TOKU nil)
          (foreach en #en$
            (if (setq #TOKU$ (CFGetXData en "G_TOKU"));2011/12/09 YM MOD G_TOKU�����ύX
              (progn
                (setq #TOKU T) ; �������ނ�������
                (setq #symTOKU$ (append #symTOKU$ (list en))) ; �������޺���ނ��g�p
              )
              (setq #symNORMAL$ (append #symNORMAL$ (list en)))
            );_if
          )

          (if #TOKU ; 01/03/22 YM ADD
            (CFAlertErr "�����L���r�l�b�g�͔��ʂ̕ύX���s���܂���B")
          );_if

          ;// ���ʂ̓\��t��(�����ȊO�̏ꍇ)
          (if #symNORMAL$
            (PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
          );_if

					;2011/12/20 YM ADD-S
					;#symNORMAL$ ��ΏۂɁA�y�i�Ԋ�{�z�W�J�^�C�v=0�̂Ƃ�G_LSYM�������ēx�X�V����B
					;OPEN BOX�ɔ���񂪂Ȃ��ĐώZ�ł��Ȃ��A�������ύX���Ă�����񂪾�Ă���Ȃ����߁B
					(foreach #sym #symNORMAL$
						(setq #xd$ (CFGetXData #sym "G_LSYM"))
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

					);foreach
					;2011/12/20 YM ADD-E

        )
      );_if

      ;// ���݂̏��i���̔������X�V���� XRecord���X�V����(���ꊇ�ύX)

      ; Xrecord�X�V
      (CFSetXRecord "SERI"
        (CFModList #XRec$
          (list
            (list 3 CG_DRSeriCode) ; CG_DRSeriCode
            (list 4 CG_DRColCode ) ; CG_DRColCode
            (list 5 CG_Hikite)     ; ����
          )
        )
      )

; 02/12/26 YM ���ꊇ�ύX�����ƭ��ύX����Ʊ��ع���ݴװ EFOpenError��Ӽޭ�� MDBupd.exe�Ŕ���
; �����ɺ��� ������NAS�ł�OKж�ޔłł͂������OK ж�ޔł�"CG_DoorHandle"�����邩��?

;03/07/22 YM MOD-S ���ĉ��� ���ꊇ�ύX������݊Ǘ���ʂŔ��F���C������Ă��Ȃ�����

      ; 02/12/06 YM ADD-S
      ; PlanInfo.cfg���X�V
      ;// ���݂̃v�������(PLANINFO.CFG)��ǂݍ���
      (setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
      ; ���ڂ̍X�V
      (setq #PLANINFO$ (subst (list "DoorSeriesCode" CG_DRSeriCode) (assoc "DoorSeriesCode" #PLANINFO$) #PLANINFO$))
      (setq #PLANINFO$ (subst (list "DoorColorCode"   CG_DRColCode) (assoc "DoorColorCode"  #PLANINFO$) #PLANINFO$))
      (setq #PLANINFO$ (subst (list "DoorHandle"         CG_Hikite) (assoc "DoorHandle"     #PLANINFO$) #PLANINFO$))

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
          (*error*)
        )
      );_if
      ; 02/12/06 YM ADD-E

;03/07/22 YM MOD-S ���ĉ��� ���ꊇ�ύX������݊Ǘ���ʂŔ��F���C������Ă��Ȃ�����

      ;00/08/25 SN ADD ����т����݂���ꍇ�͊���т��ĕ\��
      (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
        (progn
          (setq CG_BASESYM (CFGetBaseSymXRec))
          (ResetBaseSym)
          (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
        ); progn
      );_if

      (command "_purge" "BL" "*" "N") ; 01/05/14 YM ADD
      (command "_purge" "BL" "*" "N") ; 01/05/14 YM ADD

      ;;; �ҏW  00/02/20 MH MOD �֐��̍Ō�����炱�̈ʒu�Ɉړ�
      (princ "\n���ʂ�SERIES��ύX���܂���.") ;00/01/30 HN ADD ���b�Z�[�W�\����ǉ�
    )
  );_if

  ;2011/04/22 YM MOD
  (setvar "MODEMACRO"
    (strcat "�ذ��: " CG_SeriesDB " / ���ڰ��: " CG_DRSeriCode " / ��װ: " CG_DRColCode " / ����: " CG_HIKITE)
  )

  ; 01/10/31 YM ADD-S
  (setq CG_OUTCMDNAME nil)
  ; 01/10/31 YM ADD-E

  ;04/05/26 YM ADD
  (command "_REGEN")

  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)
);C:ChgDr


;<HOM>*************************************************************************
; <�֐���>    : C:ChgDrCab
; <�����T�v>  : �L���r�l�b�g�P�ʂ̔��ʓ\��t��
; <�߂�l>    :
; <�쐬>      : 1999-06-14
; <���l>      :
;*************************************************************************>MOH<
(defun C:ChgDrCab (
    /
    #xd$
    #en #en$
    #ret #ret$
    #XRec$
#CG_HIKITE
;;;    #tonF ; 00/02/17 YM ���g�p
    #msg #QRY$ #SYMTOKU$ #TOKU$ #SYMNORMAL$ #TOKU #CG_DRCOLCODE #CG_DRSERICODE
#CG_DOORHANDLE ; 02/11/30 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ChgDrCab ////")
  (CFOutStateLog 1 1 " ")

  ; 01/10/31 YM ADD-S
  (setq CG_OUTCMDNAME "ChgDrCab")
  ; 01/10/31 YM ADD-E

  ;// �R�}���h�̏�����
  (StartUndoErr)
  (CFCmdDefBegin 6);00/09/26 SN ADD

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

  ; 02/01/15 YM ADD
  (CabShow_sub) ; ��\�����ނ�\������ 01/05/31 YM ADD

  ;// ���݂̏��i�����擾����
  (setq #XRec$ (CFGetXRecord "SERI"))
  (if (= #XRec$ nil)
    (CFAlertErr "��x�����i�ݒ肪����Ă��܂���\n���i�ݒ���s���ĉ�����")
    (progn
      (setq #CG_DRSeriCode (nth 3 #XRec$)) ;���݂̐}�ʂ̔�SERIES�L����ۊ�
      (setq #CG_DRColCode  (nth 4 #XRec$)) ;���݂̐}�ʂ̔�COLOR�L����ۊ�
      (setq #CG_HIKITE     (nth 5 #XRec$)) ;���݂̐}�ʂ̈���L����ۊ�
    )
  )

  (setq #ret$
    (SRSelectDoorSeriesDlg_Handle
      "���ʑI��ύX"
      (nth 0 #XRec$)
      (nth 1 #XRec$)
      (nth 3 #XRec$);���
      (nth 4 #XRec$);���F
      (nth 5 #XRec$);����
    )
  )

  (if (/= #ret$ nil)
    (progn
      ; ���\��t�����"G_LSYM"�ɔ��,���,����Ă��邽�߈ꎞ�I�ɸ�ٰ��پ��
      (setq CG_DRSeriCode (car  #ret$))  ;��SERIES�L��(�ꎞ�I�ɕ����ύX�̔�؂ɂ���)
      (setq CG_DRColCode  (cadr #ret$))  ;��COLOR�L���@(�ꎞ�I�ɕ����ύX�̔�ׂɂ���)
      (setq CG_HIKITE (caddr #ret$)) ;���L��(�ꎞ�I�ɕ����ύX�̎��L���ɂ���)


      (setq #en T)
      (command "_view" "S" "TEMP")
      (command "_undo" "m")

      ;// �\��t������̎w���Ɠ\��t��
      (while #en
        (initget "E Undo");00/07/21 SN MOD Undo���͂�����
        (setq #en (entsel "\n���ʂ�ύX����L���r�l�b�g��I��/Enter=����/U=�߂�/: "))
        ;(initget "E")
        ;(setq #en (entsel "\n���ʂ�ύX����L���r�l�b�g��I��/Enter=����/ "))
        (cond
          ((and (= #en nil) #en$)
            (setq #ret (CFYesNoCancelDialog "����ł�낵���ł����H "))
            (cond
              ((= #ret IDYES)
                (command "_undo" "b")
                (setq #en nil)
                (repeat (length #en$);00/07/21 SN ADD �I���������������Ƃɖ߂�
                  (command "_undo" "b")
                )
              )
              ((= #ret IDNO)
                (setq #en T)
              )
              (T
                (quit)
              )
            )
          )
          ; 00/07/21 SN ADD Undo ����
          ((= #en "Undo")
            (if (> (length #en$) 0 )(progn
              (command "_undo" "b")
              (if (> (length #en$) 1 )
                (setq #en$ (cdr #en$))
                (setq #en$ '())
              )
            ))
          )
          ((/= #en nil)
            (setq #en (car #en))
            (setq #en (CFSearchGroupSym #en)) ; �I�𕔍ނ̼���ِ}�`�� #en
            (if (= #en nil)
              (progn
                (CFAlertMsg "�L���r�l�b�g�ł͂���܂���")
                (setq #en T)
              )
            ;else
              (progn
                (setq #xd$ (CFGetXData #en "G_LSYM"))

;;;02/09/04YM@DEL                (if (/= CG_SKK_ONE_CAB (CFGetSeikakuToSKKCode (nth 9 #xd$) 1))
;;;02/09/04YM@DEL                  (CFAlertMsg "�L���r�l�b�g�ł͂���܂���")
;;;02/09/04YM@DEL                  (progn
                    (if (not (member #en #en$))
                      (progn;00/07/21 SN ADD ���ɑI���ς݂̂��̂͑ΏۊO�Ƃ���B
                        (setq #en$ (cons #en #en$)) ; �I�𕔍ނ̼���ِ}�`��ؽ�
                        (command "_undo" "m");00/07/21 SN ADD ��ŐF��߂�����
                        ;// �O���[�v�̐}�`��F�ւ�
                        ;(GroupInSolidChgCol #en CG_InfoSymCol);00/07/21 SN MOD ����їp
;-- 2011/09/14 A.Satoh Mod - S
;                        (GroupInSolidChgCol2 #en CG_InfoSymCol);00/07/21 SN MOD
                        (GroupInSolidChgCol2 #en CG_ConfSymCol)
;-- 2011/09/14 A.Satoh Mod - E
                      )
                    );_if
;;;02/09/04YM@DEL                  )
;;;02/09/04YM@DEL                )
              )
            );_if
          )
          (T
            (setq #en T)
          )
        );_cond
      )
;;;01/03/22YM@      ;// ���ʂ̓\��t��
;;;01/03/22YM@      (PCD_MakeViewAlignDoor #en$ 3 T)          ;00/02/07 MH MOD

;-- 2011/07/12 A.Satoh Add - S
      (if (/= #en$ nil)
        ; �i�Ԗ��̃`�F�b�N����
;-- 2011/09/14 A.Satoh Mod - S
;        (if (= nil (CheckDoorGradeHinban #en$ (car #ret$) (cadr #ret$)))
;          (progn
;            ; �O���[�o���ϐ������ɖ߂�
;            (setq CG_DRSeriCode #CG_DRSeriCode)
;            (setq CG_DRColCode #CG_DRColCode)
;            (setq CG_HIKITE #CG_HIKITE)
;
;            (setq #ret$ nil)
;          )
;        )
        (progn
          (setq #en2$ (CheckDoorGradeHinban #en$ (car #ret$) (cadr #ret$)))
          (if (/= #en2$ nil)
            (progn
              (setq #idx 0)
              (repeat (length #en$)
                (if (equal CG_BASESYM (nth #idx #en2$)) ;�����
                  (GroupInSolidChgCol (nth #idx #en2$) CG_BaseSymCol)
                  (GroupInSolidChgCol2 (nth #idx #en2$) "BYLAYER")
                );_if
                (setq #idx (1+ #idx))
              )
            )
          )
        )
;-- 2011/09/14 A.Satoh Mod - E
      )
    )
  )

  (if (/= #ret$ nil)
    (progn
;-- 2011/07/12 A.Satoh Add - E
      ; 01/03/12 YM ADD �������ނƈ�ʷ��ނ𕪂���
      (setq #symTOKU$ nil #symNORMAL$ nil #TOKU nil)
      (foreach en #en$
        (if (setq #TOKU$ (CFGetXData en "G_TOKU"));2011/12/09 YM MOD G_TOKU�����ύX
          (progn
            (setq #TOKU T)
            (setq #symTOKU$ (append #symTOKU$ (list en))) ; �������޺���ނ��g�p
          )
          (setq #symNORMAL$ (append #symNORMAL$ (list en)))
        );_if
      )

      (if #TOKU ; 01/03/22 YM ADD
        (CFAlertErr "�����L���r�l�b�g�͔��ʂ̕ύX���s���܂���B")
      );_if

      ;// ���ʂ̓\��t��(�����ȊO�̏ꍇ)
      (if #symNORMAL$
        (PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
      );_if


			;2011/12/20 YM ADD-S
			;#symNORMAL$ ��ΏۂɁA�y�i�Ԋ�{�z�W�J�^�C�v=0�̂Ƃ�G_LSYM�������ēx�X�V����B
			;OPEN BOX�ɔ���񂪂Ȃ��ĐώZ�ł��Ȃ��A�������ύX���Ă�����񂪾�Ă���Ȃ����߁B
			(foreach #sym #symNORMAL$
				(setq #xd$ (CFGetXData #sym "G_LSYM"))
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

			);foreach
			;2011/12/20 YM ADD-E


      ;00/08/25 SN ADD ����т����݂���ꍇ�͊���т��ĕ\��
      (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
        (progn
          (setq CG_BASESYM (CFGetBaseSymXRec))
          (ResetBaseSym)
          (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
        ); progn
      )

      (command "_purge" "BL" "*" "N") ; 01/05/14 YM ADD
      (command "_purge" "BL" "*" "N") ; 01/05/14 YM ADD

      ; �װЯ������ݖ����۰��پ�� 01/10/11 YM ADD-S
      (PhSelColorMixPatternDlg) ; PHCAD�ȊO�͉������Ȃ��֐�(-->KcExtend)
      ; �װЯ������ݖ����۰��پ�� 01/10/11 YM ADD-E

       ;;; ���ҏW  00/02/20 MH MOD �֐��̍Ō�����炱�̈ʒu�Ɉړ�
      (princ "\n���ʂ�SERIES��ύX���܂���.") ;00/01/30 HN ADD ���b�Z�[�W�\����ǉ�

      ; 01/11/27 YM ADD-S �������ύX��ɔz�u�������ނ̔��́A�}�ʂ̔��łȂ��Ƃ����Ȃ�
      (setq CG_DRSeriCode #CG_DRSeriCode) ;�}�ʂ̔�SERIES�L���ɖ߂�
      (setq CG_DRColCode  #CG_DRColCode)  ;�}�ʂ̔�COLOR�L���ɖ߂�
      ; 01/11/27 YM ADD-E �������ύX��ɔz�u�������ނ̔��́A�}�ʂ̔��łȂ��Ƃ����Ȃ�
      (setq CG_HIKITE     #CG_HIKITE)     ;�}�ʂ̎��L���ɖ߂�

    )
  )


  ; 01/10/31 YM ADD-S
  (setq CG_OUTCMDNAME nil)
  ; 01/10/31 YM ADD-E

  ;04/05/26 YM ADD
  (command "_REGEN")

  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)
);C:ChgDrCab


;-- 2011/07/12 A.Satoh Add - S
;;;<HOM>***********************************************************************
;;; <�֐���>    : CheckDoorGradeHinban
;;; <�����T�v>  : ���O���[�h�ύX���i�ԃ`�F�b�N����
;;;             :   �w�肳�ꂽ���̃O���[�h�A�F�ł���ꍇ�ɑ��݂ł��Ȃ��i�Ԗ���
;;;             :   �����݂��邩�ۂ����`�F�b�N����
;;; <�߂�l>    : T   �� ���ݕs�i�Ԗ��@nil �� ���ݕs�i�ԗL
;;;             : ��11/09/14 �ύX�@���ݕs�i�Ԑ}�`���X�g����nil
;;; <�쐬>      : 11/07/12 A.Satoh
;;; <���l>      : 11/08/03 A.Satoh �ύX
;;;             :�@�E���ݕs�i�Ԃ̔�����@�ύX
;;;             : 11/09/14 A.Satoh �ύX
;;;             :�@�E���ݕs�i�ԑΏۂɓV��t�B���[�ǉ�
;;;             :�@�E���ݕs�i�ԑΏې}�`��ԐF�\��
;;;             :�@�E�g���f�[�^[G_ERR]�ݒ�
;;;             :�@�E�߂�l�ύX
;;;***********************************************************************>HOM<
(defun CheckDoorGradeHinban (
  &en$      ; �I��}�`���X�g
  &DrSeries ; ���V���[�Y�L��
  &DrColor  ; ���F�L��
  /
;-- 2011/09/14 A.Satoh Mod - S
;  #ret #idx #en #xd_LSYM$ #hinban #qry$$ #qry$ #hinban$ #msg
  #idx #en #xd_LSYM$ #hinban #qry$$ #qry$ #hinban$ #msg #xd_FILR$ #en$ #err$
  #err_flg #en_no_err$
;-- 2011/09/14 A.Satoh Mod - E
  #ser_lst$ #col_lst$
;-- 2011/08/03 A.Satoh Add - S
  #ser #col
;-- 2011/08/03 A.Satoh Add - E
  )

;-- 2011/09/14 A.Satoh Mod - S
;  (setq #ret T)
  (setq #en$ nil)
  (setq #en_no_err$ nil)
;-- 2011/09/14 A.Satoh Mod - E
  (setq #hinban$ nil)

  (setq #idx 0)
  (repeat (length &en$)
    ; �i�Ԗ��̎擾
    (setq #en (nth #idx &en$))
;-- 2011/09/14 A.Satoh Mod - S
;    (setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
;    (setq #hinban (nth 5 #xd_LSYM$))
    (setq #err_flg nil)
    (setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
    (if #xd_LSYM$
      (setq #hinban (nth 5 #xd_LSYM$))
      (progn
        (setq #xd_FILR$ (CFGetXData #en "G_FILR"))
        (setq #hinban (nth 0 #xd_FILR$))
      )
    )
;-- 2011/09/14 A.Satoh Mod - E

    ; ���V���ʔ�Ώە��ނ�����𒊏o����
    (setq #qry$$
      (CFGetDBSQLRec CG_DBSESSION "���V���ʔ�Ή�����"
        (list
          (list "�i�Ԗ���" #hinban 'STR)
        )
      )
    )

    ; ���V���[�Y��Ώە��ރ`�F�b�N
    (if (and #qry$$ (= 1 (length #qry$$)))
      (progn
        (setq #qry$ (nth 0 #qry$$))
;-- 2011/08/03 A.Satoh Mod - S
;       (setq #ser_lst$ (StrParse (nth 1 #qry$) ","))
;       (setq #col_lst$ (StrParse (nth 2 #qry$) ","))
;
;       (if (and (/= (member &DrSeries #ser_lst$) nil)
;                (/= (member &DrColor #col_lst$) nil))
;         (progn
;           ; ��Ώۂ̕i�Ԗ��̂����X�g��
;           (setq #hinban$ (append #hinban$ (list #hinban)))
;           (setq #ret nil)
;         )
;       )
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
              (progn
                ; ��Ώۂ̕i�Ԗ��̂����X�g��
                (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                (setq #ret nil)
                (GroupInSolidChgCol2 #en CG_InfoSymCol)
                (setq #en$ (append #en$ (list #en)))
                (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
              )
            )
          )
          ((and (/= #ser "ALL") (= #col "ALL"))
            (if (/= (member &DrSeries #ser_lst$) nil)
              (if (= #flag "NG")
                (progn
                  ; ��Ώۂ̕i�Ԗ��̂����X�g��
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
              (if (= #flag "OK")
                (progn
                  ; ��Ώۂ̕i�Ԗ��̂����X�g��
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
            )
          )
          ((and (= #ser "ALL") (/= #col "ALL"))
            (if (/= (member &DrColor #col_lst$) nil)
              (if (= #flag "NG")
                (progn
                  ; ��Ώۂ̕i�Ԗ��̂����X�g��
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
              (if (= #flag "OK")
                (progn
                  ; ��Ώۂ̕i�Ԗ��̂����X�g��
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
            )
          )
          (T
            (if (and (/= (member &DrSeries #ser_lst$) nil)
                     (/= (member &DrColor  #col_lst$) nil))
              (if (= #flag "NG")
                (progn
                  ; ��Ώۂ̕i�Ԗ��̂����X�g��
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
              (if (= #flag "OK")
                (progn
                  ; ��Ώۂ̕i�Ԗ��̂����X�g��
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
            )
          )
        )
;-- 2011/08/03 A.Satoh Mod - E
      )
    )

    (if (= #err_flg nil)
      (setq #en_no_err$ (append #en_no_err$ (list #en)))
    )

    (setq #idx (1+ #idx))
  )

;-- 2011/09/14 A.Satoh Mod - S
;  (if (= #ret nil)
  (if (/= #en$ nil)
;-- 2011/09/14 A.Satoh Mod - E
    (progn
      ; ���b�Z�[�W�o��
      (setq #msg "\n���݂̔��ڰ�ށA���F�̂Ƃ��ɑ��݂��Ă͂����Ȃ��i�Ԃ�����̂ŕύX�ł��܂���ł����B\n\n�i�Ԗ��́F")
      (setq #idx 0)
      (repeat (length #hinban$)
        (setq #msg (strcat #msg "\n" (nth #idx #hinban$)))
        (setq #idx (1+ #idx))
      )
;-- 2011/09/14 A.Satoh Add - S
      (if (= nil (tblsearch "APPID" "G_ERR")) (regapp "G_ERR"))
      (setq #idx 0)
      (repeat (length #en$)
        (setq #en (nth #idx #en$))
        (setq #err$ (CFGetXData #en "G_ERR"))
        (if (= #err$ nil)
          (CFSetXData #en "G_ERR" (list 1))
        )
        (setq #idx (1+ #idx))
      )
;-- 2011/09/14 A.Satoh Add - E
      (CfAlertMsg #msg)
    )
  )

;-- 2011/09/14 A.Satoh Mod - S
;  #ret
  (if (/= #en_no_err$ nil)
    (progn
      (setq #idx 0)
      (repeat (length #en_no_err$)
        (if (/= (CFGetXData (nth #idx #en_no_err$) "G_ERR") nil)
          (CFSetXData (nth #idx #en_no_err$) "G_ERR" nil)
        )
        (setq #idx (1+ #idx))
      )
    )
  )

  #en$
;-- 2011/09/14 A.Satoh Mod - E

);CheckDoorGradeHinban
;-- 2011/07/12 A.Satoh Add - E


;<HOM>*************************************************************************
; <�֐���>    : PCD_MakeViewAlignDoor
; <�����T�v>  : ���\��t���p�̃r���[���쐬����
; <���l>      :
;*************************************************************************>MOH<
(defun PCD_MakeViewAlignDoor (
    &Obj$          ;(LIST)���\�t�Ώۂ̃V���{��
    &SetFace       ;(INT)�\��t����ʂ̎��(2:2D-�o�� 3:3D�ڒn�̈�)
    &EraseFlg      ;(INT)�������ʂ̍폜�t���O (T:�폜 nil:�폜���Ȃ�)
    /
    #viewEn
  )

  (command "UCSICON" "A" "OF") ; UCS �A�C�R�����\���ɂ��܂��B
;;;@YM@;;;  (if (= 0 (getvar "TILEMODE"))                         00/02/22 ������ނł�����
;;;@YM@;;;    (progn
;;;@YM@;;;      (command "_mview" (list 0 0) (list 0.2 0.2))
;;;@YM@;;;      (setq #viewEn (entlast))
;;;@YM@;;;      ;// ���ʂ̓\��t��
;;;@YM@;;;      (if CG_AutoAlignDoor
;;;@YM@;;;        (PCD_AlignDoor &Obj$ &SetFace &EraseFlg)
;;;@YM@;;;      )
;;;@YM@;;;      (entdel #viewEn)
;;;@YM@;;;    )
;;;@YM@;;;  ;else
;;;@YM@;;;(progn
      ;// ���ʂ̓\��t��
      (if CG_AutoAlignDoor
        (PCD_AlignDoor &Obj$ &SetFace &EraseFlg)
      )
;;;@YM@;;;    )
;;;@YM@;;;)                                                       00/02/22 ������ނł�����
  ;(command "UCSICON" "A" "ON")
)
;PCD_MakeViewAlignDoor

;;;<HOM>***********************************************************************
;;; <�֐���>    : GetXYMaxMinFromPT$
;;; <�����T�v>  : �_���X�ő�,�ŏ�,Y�ő�,�ŏ�ؽĂ�Ԃ�
;;; <�߂�l>    :
;;; <�쐬>      : 01/04/06 YM
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun GetXYMaxMinFromPT$ (
  &pt$ ; �_��
  /
  #X$ #XMAX #XMIN #Y$ #YMAX #YMIN
  )
  (setq #XMAX -1.0e+10)
  (setq #XMIN +1.0e+10)
  (setq #YMAX -1.0e+10)
  (setq #YMIN +1.0e+10)

  (setq #X$ (mapcar 'car  &pt$))
  (setq #Y$ (mapcar 'cadr &pt$))

  (foreach #X #X$
    (if (<= #XMAX #X)(setq #XMAX #X))
    (if (>= #XMIN #X)(setq #XMIN #X))
  )
  (foreach #Y #Y$
    (if (<= #YMAX #Y)(setq #YMAX #Y))
    (if (>= #YMIN #Y)(setq #YMIN #Y))
  )
  (list #XMAX #XMIN #YMAX #YMIN)
);GetXYMaxMinFromPT$

;;;<HOM>***********************************************************************
;;; <�֐���>    : KP_WritePOLYLINE
;;; <�����T�v>  : ���ײݏ�ɓ������ײ݂�����
;;; <�߂�l>    : ���ײ�
;;; <�쐬>      : 01/04/06 YM
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun KP_WritePOLYLINE (
  &PLINE  ;PLINE�}�`
  /
;;; #210 #EG$ #PT$ #Z
#210 #EG$ #PT$ #Z
  )
  (setq #eg$ (entget &PLINE))
  (setq #Z   (cdr (assoc  38 #eg$))) ; ���x
  (setq #210 (cdr (assoc 210 #eg$))) ; �����o������

    ;; VPOINT �ύX �E���ʐ}
    (command "_.vpoint" #210) ; �����o������������ޭ��ɂ���
    ;; UCS �ύX
    (command "_.UCS" "V")

  (setq #pt$ nil)
  (foreach elm #eg$
    (if (= (car elm) 10)
      (setq #pt$ (append #pt$ (list (cdr elm)))) ; MEJI �O�`�_��Object�̍��W�n
;;;     (setq #pt$ (append #pt$ (list (trans (append (cdr elm)(list #Z)) &MEJI 1 0)))) ; MEJI �O�`�_��
    );_if
  )
;;; ; World���W�n�ɕϊ�
;;; (setq #pA (trans (append #pA (list #Z)) &MEJI 1 0))
;;; (setq #pB (trans (append #pB (list #Z)) &MEJI 1 0))


  (princ)
);KP_WritePOLYLINE

;;;<HOM>***********************************************************************
;;; <�֐���>    : KP_MEJIRotate
;;; <�����T�v>  : �ڒn�����̏��180�x��]������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/04/06 YM
;;; <���l>      : MEJI��`���t�̏ꍇ �g�p���Ȃ�
;;;***********************************************************************>HOM<
(defun KP_MEJIRotate (
  &MEJI  ;3D�ڒn�}�`
  &MEJI$ ;�}�`���
  /
  #P1 #P2 #P3 #P4 #PA #PB #PT$ #Z
  #RET$ #XMAX #XMIN #YMAX #YMIN
  )
  (setq #Z (cdr (assoc 38 &MEJI$)))
  (setq #pt$ nil)
  (foreach elm &MEJI$
    (if (= (car elm) 10)
      (setq #pt$ (append #pt$ (list (cdr elm)))) ; MEJI �O�`�_��Object�̍��W�n
;;;     (setq #pt$ (append #pt$ (list (trans (append (cdr elm)(list #Z)) &MEJI 1 0)))) ; MEJI �O�`�_��
    );_if
  )
  (setq #ret$ (GetXYMaxMinFromPT$ #pt$))
  (setq #XMAX (nth 0 #ret$))
  (setq #XMIN (nth 1 #ret$))
  (setq #YMAX (nth 2 #ret$))
  (setq #YMIN (nth 3 #ret$))
  (setq #pA (GetCenterPT (list #XMIN #YMAX)(list #XMAX #YMAX)))
  (setq #pB (GetCenterPT (list #XMIN #YMIN)(list #XMAX #YMIN)))
  ; World���W�n�ɕϊ�
  (setq #pA (trans (append #pA (list #Z)) &MEJI 1 0))
  (setq #pB (trans (append #pB (list #Z)) &MEJI 1 0))
  (command "._rotate3D" &MEJI "" "2" #pA #pB 180)
  (princ)
);KP_MEJIRotate

;<HOM>*************************************************************************
; <�֐���>    : KP_MakeHantenMEJI
; <�����T�v>  : �ڒn�̒�`�𗠕\���]���������ײ݂�Ԃ�
; <�߂�l>    :
; <�쐬>      : 01/04/07
; <���l>      :
;*************************************************************************>MOH<
(defun KP_MakeHantenMEJI (
  &MEJI ; �ڒnPLINE�}�`
  &Sym
  /
  #MEJI$ #pt$ #RB$ #LB$ #38 #210 #210- #Z #last
  #EG$ #LU_PT #PT
  )
  (setq #MEJI$ (CFGetXData &MEJI "G_MEJI"))
  (setq #eg$ (entget &MEJI))
  (setq #LU_PT (KcGetDoorInsertPnt &Sym &MEJI)) ; ������
  (command "._ucs" "M" #LU_PT) ; �����������_
  (setq #38  (cdr (assoc  38 #eg$)))
  (setq #210 (cdr (assoc 210 #eg$)))
  (setq #210- (mapcar '- #210))

  (command "_.vpoint" #210-) ; �@�������o�������Ɣ��΂��ޭ��ɂ���
  (command "_.UCS" "V") ; UCS �ύX(���_�͓���)

  ; �ڒn���ײݒ��_�擾===>���݂�UCS���W�n�ɕϊ�
  (setq #pt$ nil)
  (foreach elm #eg$
    (if (= (car elm) 10)
      (progn
        (setq #pt (trans (append (cdr elm) (list #38)) &MEJI 1)) ; World���W�n
;;;       (setq #pt (trans (append (cdr elm) (list #38)) &MEJI 1 0)) ; World���W�n
;;;       (setq #pt (trans #pt 0 1)) ; ���݂�USC���W�n
        (setq #pt$ (append #pt$ (list (list (car #pt)(cadr #pt)))))
      )
    );_if
  )
  (MakeLWPL #pt$ 1)
  (setq #last (entlast))

  (command "_.UCS" "W") ; ���O�ɖ߂�
  (command "zoom" "p")  ; VPOINT �r���[��߂�
  #last
);KP_MakeHantenMEJI

;<HOM>*************************************************************************
; <�֐���>    : KPstrViewLayer
; <�����T�v>  : #strViewLayer �����߂�
; <�߂�l>    : #strViewLayer
; <�쐬>      : 01/05/11 YM
; <���l>      : PCD_AlignDoor �̍s�������炷�̂ƁA���̊֐����ė��p���邽�ߍ쐬
;*************************************************************************>MOH<
(defun KPstrViewLayer (
  &enName
  &enData$
  &DBGET
  /
  #DBGET #ENDATA$ #ENNAME #STRVIEWLAYER #TEMP$
  )
  (setq #enName &enName)
  (setq #enData$ &enData$)
  (setq #DBGET &DBGET)

  ;; ���ʎw�肳�ꂽ�f�[�^��3D�ڒn�̈悩�ǂ����`�F�b�N(G_MEJI)
  (if (/= (setq #Temp$ (CFGetXData #enName "G_MEJI")) nil)
    (progn    ; ���ʎw�肪3D�ڒn�̈悾����
      ;; G_MEJI �̑���1���Q�Ƃ��A���_�敪�ԍ����擾����
      (if (< (nth 1 #Temp$) 10)
        (setq #strViewLayer "0")
      ;else
        (setq #strViewLayer "")
      )
      (if (or (and (<= (nth 1 #Temp$) 2) (>= (nth 1 #Temp$) 0))
              (> (nth 1 #Temp$) 6))
        (setq #strViewLayer (strcat #strViewLayer (itoa 3)))
      ;else
        (setq #strViewLayer (strcat #strViewLayer (itoa (nth 1 #Temp$))))
      )
      ;; ���_�敪�ԍ���\����w�i�[�ϐ��Ɋi�[����
      (setq #strViewLayer (strcat SKD_DOOR_VIEW_LAYER1
                                  #strViewLayer
                                  SKD_DOOR_VIEW_LAYER2
                                  (substr #DbGet 6 2)    ; 03/04/01 YM MOD DR??** ==> DR???** �ύX�ɔ���
                                  ;;;(substr #DbGet 5 2) ; 03/04/01 YM MOD DR??** ==> DR???** �ύX�ɔ���
                                  SKD_DOOR_VIEW_LAYER3)
      )
    )
  ;else
    (progn  ; ���ʎw�肪3D�ڒn�̈�ł͂Ȃ�����(2D���̈悾����  P��=7)
      (setq #strViewLayer (substr (cdr (assoc 8 #enData$)) 3 2))
      ;YM@ ��(8 . "Z_03_04_00_04")�Ȃ�"03"(����͎��_���)
      ;YM@ ���_��ނƂ�:03,04,05,06==>����,�w��,L����,R����

      ;; 2D���̈�f�[�^�̉�w��\����w�i�[�ϐ��Ɋi�[����
      (setq #strViewLayer (strcat SKD_DOOR_VIEW_LAYER1  ;YM@ ="Q_"
                                  #strViewLayer         ;YM@ =�Ⴆ��"03"
                                  SKD_DOOR_VIEW_LAYER2  ;YM@ ="_99_"
                                  (substr #DbGet 6 2)    ; 03/04/01 YM MOD DR??** ==> DR???** �ύX�ɔ���
                                  ;;;(substr #DbGet 5 2) ; 03/04/01 YM MOD DR??** ==> DR???** �ύX�ɔ���
                                  SKD_DOOR_VIEW_LAYER3) ;YM@ ="_##"
      )
    )
  );_if
  #strViewLayer
);KPstrViewLayer

;;;01/05/18YM@;<HOM>*************************************************************************
;;;01/05/18YM@; <�֐���>    : KPGetDoorGroup
;;;01/05/18YM@; <�����T�v>  : DoorGroup�}�`�������߂�
;;;01/05/18YM@; <�߂�l>    : DoorGroup�}�`��
;;;01/05/18YM@; <�쐬>      : 01/05/11 YM
;;;01/05/18YM@; <���l>      :
;;;01/05/18YM@;*************************************************************************>MOH<
;;;01/05/18YM@(defun KPGetDoorGroup (
;;;01/05/18YM@  &en
;;;01/05/18YM@  /
;;;01/05/18YM@  #EG$ #EG2 #I #RET
;;;01/05/18YM@  )
;;;01/05/18YM@  (setq #eg$ (entget &en '("*")))
;;;01/05/18YM@  (setq #i 0)
;;;01/05/18YM@  (foreach #eg #eg$
;;;01/05/18YM@    (if (= (car #eg) 330)
;;;01/05/18YM@      (progn
;;;01/05/18YM@        (setq #eg2 (entget (cdr #eg)))
;;;01/05/18YM@        (if (= (cdr (assoc 300 #eg2)) "DoorGroup") ; �O���[�v�̐���
;;;01/05/18YM@          (setq #ret (cdr #eg))
;;;01/05/18YM@        );_if
;;;01/05/18YM@      )
;;;01/05/18YM@    );_if
;;;01/05/18YM@    (setq #i (1+ #i))
;;;01/05/18YM@  )
;;;01/05/18YM@  #ret
;;;01/05/18YM@);KPGetDoorGroup

;<HOM>*************************************************************************
; <�֐���>    : KPGetDoorGroup
; <�����T�v>  : DoorGroup�}�`�������߂�
; <�߂�l>    : DoorGroup�}�`��
; <�쐬>      : 01/05/11 YM
; <���l>      : 01/05/18 YM �߂�lؽČ`��
;*************************************************************************>MOH<
(defun KPGetDoorGroup (
  &en
  /
  #EG$ #EG2 #I #RET$
  )
  (setq #eg$ (entget &en '("*")))
  (setq #i 0)
  (foreach #eg #eg$
    (if (= (car #eg) 330)
      (progn
        (setq #eg2 (entget (cdr #eg)))
        (if (= (cdr (assoc 300 #eg2)) SKD_GROUP_INFO) ; �O���[�v�̐���
          (setq #ret$ (append #ret$ (list (cdr #eg))))
        );_if
      )
    );_if
    (setq #i (1+ #i))
  )
  #ret$
);KPGetDoorGroup

;<HOM>*************************************************************************
; <�֐���>    : KP_Get340SSFromDrgroup
; <�����T�v>  : ��"GROUP"�}�`(#Door)����340���ް�}�`�̑I��Ă��擾
; <�߂�l>    : �I���
; <�쐬>      : 01/05/18 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KP_Get340SSFromDrgroup (
  &group ; ���ٰ�ߐ}�`
  /
  #EG$ #SS
  )
  (setq #ss (ssadd))
  (setq #eg$ (entget &group))
  (foreach #elm #eg$
    (if (= (car #elm) 340)
      ; 02/01/09 YM ADD-S ����ي�_�͏���
      (if (CFGetXData (cdr #elm) "G_SYM")
        nil
        (ssadd (cdr #elm) #ss)
      );_if
      ; 02/01/09 YM ADD-E ����ي�_�͏���
    );_if

;;;02/01/09YM@MOD   (if (= (car #elm) 340)
;;;02/01/09YM@MOD     (ssadd (cdr #elm) #ss)
;;;02/01/09YM@MOD   );_if

  )
  #ss
);KP_Get340SSFromDrgroup

;<HOM>*************************************************************************
; <�֐���>    : KP_Get340SSFromDrgroup$
; <�����T�v>  : ��"GROUP"�}�`ؽ�(#Door$)����S340���ް�}�`�̑I��Ă��擾
; <�߂�l>    : �I���
; <�쐬>      : 01/05/18 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KP_Get340SSFromDrgroup$ (
  &group$ ; ���ٰ�ߐ}�`ؽ�
  /
  #EG$ #SS #group
  )
  (setq #ss (ssadd))
  (foreach #group &group$
    (setq #eg$ (entget #group))
    (foreach #elm #eg$
      (if (= (car #elm) 340)
        (ssadd (cdr #elm) #ss)
      );_if
    )
  )
  #ss
);KP_Get340SSFromDrgroup$

;<HOM>*************************************************************************
; <�֐���>    : KP_GetDoorBasePT
; <�����T�v>  : ��"GROUP"�}�`��������i������"POINT"�}�`���������ʒu���W(2D)���擾
; <�߂�l>    : �ʒu���Wؽ�
; <�쐬>      : 01/06/26 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KP_GetDoorBasePT (
  &eg$
  /
  #RET
  )
  (setq #ret nil)
  (foreach #elm &eg$
    (if (and (= (car #elm) 340)
             (= (cdr (assoc 0 (entget (cdr #elm)))) "POINT"))
      (setq #ret (cdr (assoc 10 (entget (cdr #elm)))))
    );_if
  )
  (list (car #ret)(cadr #ret)) ; 2D
);KP_GetDoorBasePT

;<HOM>*************************************************************************
; <�֐���>    : KP_CheckDrgroup
; <�����T�v>  : ��"GROUP"�}�`ؽĂ̂���&flg�ƍ�����"GROUP"�}�`��Ԃ�
; <�߂�l>    : ��"GROUP"�}�`
; <�쐬>      : 01/05/18 YM 01/06/27 YM MOD
; <���l>      : �����\������}�`�����ׂē����w�ł����1��������΂����̂���
;               ���ʔ��\���}�`�̉�w����="1"�A�w�ʔ��\���}�`�̉�w����="2"
;               �ł�����̂��قƂ�ǂŁA��OXLINE,POINT�����݂��邽��
;               ����̍ۂɐ���50%�ȏォ�ǂ����Ƃ��Ă���B
; ===> ���ٰ�ߖ��̖������@��ύX �]��DoorGroup+?-->DoorGroup+����3,�w��4+?
;*************************************************************************>MOH<
(defun KP_CheckDrgroup (
  &flg    ; ����"3",�w��"4"����5,6�Ȃǂ��׸�
  &group$ ; ���ٰ�ߐ}�`ؽ�
  /
  #EG$ #RET #EG #GNAM #GROUP #I #LOOP #LOOP2 #N
  )
  (setq #ret nil)
  (cond
    ((= &flg "3")(setq CG_TOKU "1")) ; ���ʔ��������� 01/05/21 YM ADD
    ((= &flg "4")(setq CG_TOKU "2")) ; �w�ʔ��������� 01/05/21 YM ADD
    ((= &flg "5")(setq CG_TOKU "3"))
    ((= &flg "6")(setq CG_TOKU "4"))
    (T (CFAlertErr "���̃^�C�v�̓����L���r�l�b�g�͑Ή����Ă��܂���B")(quit))
  );_cond

  (if (= 1 (length &group$))
    (setq #ret (car &group$)) ; 1�����Ȃ画�肵�Ȃ� 01/05/28 YM
    (progn
      (setq #n 0 #loop T)
      (while (and #loop (< #n (length &group$)))
        (setq #group (nth #n &group$))
        (setq #eg$ (entget #group))
        (setq #i 0 #loop2 T)
        (while (and #loop2 (< #i (length #eg$)))
          (setq #eg (nth #i #eg$))
          (if (and (= (car #eg) 340)
                   (/= (cdr (assoc 0 (entget (cdr #eg)))) "POINT"))
            (progn ; ��ٰ�߂����ް��"POINT"�ȊO
              (setq #loop2 nil)
              (setq #gnam (SKGetGroupName (cdr #eg))) ; ��ٰ�ߖ��擾
            )
          );_if
          (setq #i (1+ #i))
        );while
        (if (= &flg (substr #gnam 10 1))
          (setq #ret #group #loop nil)
        );_if
        (setq #n (1+ #n))
      );while
    )
  );_if
  #ret
);KP_CheckDrgroup

;<HOM>*************************************************************************
; <�֐���>    : KPGetEnDoor
; <�����T�v>  : ���ٰ�߂����ް��1��Ԃ�
; <�߂�l>    : �}�`
; <�쐬>      : 01/05/11 YM
; <���l>      :
;*************************************************************************>MOH<
(defun KPGetEnDoor (
  &group ; ��ٰ�ߐ}�`
  /
  #340 #EG$ #ELM #I #LOOP
  )
  (setq #eg$ (entget &group))
  (setq #loop T #i 0)
  (while (and #loop (< #i (length #eg$)))
    (setq #elm (nth #i #eg$))
    (if (= (car #elm) 340)
      (progn
        (setq #340 (cdr #elm))
        (setq #loop nil)
      )
    );_if
    (setq #i (1+ #i))
  )
  #340
);KPGetEnDoor

;<HOM>*************************************************************************
; <�֐���>    : KcGetDoorInsertPnt
; <�����T�v>  : ���}�`�̑}��3D�_�����߂�
; <�߂�l>    :
; <�쐬>      : 00/11/08 MH
; <���l>      : �\���_��Z�l�̍ŏ��ƁAX�l�̍Œ[ �̑g�ݍ��킹����_�Ƃ���
;*************************************************************************>MOH<
(defun KcGetDoorInsertPnt (
  &eITEM      ; �ڒn�̈�̏�������e�}�`��
  &eMEJI      ; �ڒn�̈�}�`�� "G_MEJI"������ LWPLINE
  /
  #DXF$ #$ #Z #P$ #_PNT$ #PNT$ #minZP #enANG #VP #ANG  #kariP #kriP1 #kriP2
  #crsP #dPNT #fDIST #TESP #layer #PMEN$ #eg$
  )
  ; LWPLINE �̍��W�����݂�UCL�̍��W�ɕϊ�
  (setq #DXF$ (entget &eMEJI))
  (foreach #$ #DXF$ (if (= 10 (car #$)) (setq #_PNT$ (cons (cdr #$) #_PNT$))))
  (setq #Z (cdr (assoc 38 #DXF$)))
  (foreach #P$ #_PNT$ (setq #PNT$ (cons (trans (append #P$ (list #Z)) &eMEJI 1 0) #PNT$)))
  ;(setq ##PNT$ #PNT$) ; �e�X�g�p

  ; �Z�o���ꂽ���W�̂����AZ�l���ŏ��̂��̂����߂�
  (setq #minZP (car #PNT$))
  (foreach #P$ (cdr #PNT$) (if (> (caddr #minZP) (caddr #P$)) (setq #minZP #P$)))

  ; �e�}�`�̊p�x�Ɩڒn�̈��"G_MEJI"���ALR�t���O���狁�߂�_�̕����𔻒�
  (setq #enANG (nth 2 (CFGetXData &eITEM "G_LSYM")))
  (setq #VP (cadr (CFGetXData &eMEJI "G_MEJI")))

  ; 01/05/22 YM ADD �W�J�}�쐬���� &eMEJI=PMEN7 STRAT
  (if (= nil #VP)
    (if (and (setq #PMEN$ (CFGetXData &eMEJI "G_PMEN"))
             (= 7 (car #PMEN$)))
      (progn
        (cond
          ((= "03" (substr (cdr (assoc 8 #DXF$)) 3 2))
            (setq #VP 3)
          )
          ((= "04" (substr (cdr (assoc 8 #DXF$)) 3 2))
            (setq #VP 4)
          )
          ((= "06" (substr (cdr (assoc 8 #DXF$)) 3 2))
            (setq #VP 6)
          )
          (T
            (setq #VP nil)
          )
        );_cond
      )
    );_if
  );_if
  ; 01/05/22 YM ADD �W�J�}�쐬���� &eMEJI=PMEN7 END

  (cond
    ; �R�[�i�[����
    ((= 6 #VP) (setq #ANG (+ (* -0.5 pi) #enANG)))
    ; �w��
    ;((= 4 #VP) (setq #ANG #enANG)); 01/02/09 MH MOD �w�ʂ����p�x�ɐݒ�
    ; ���̑��͐��ʂƂ��ĎZ�o (= 0 #VP) ��ʐ���  (= 3 #VP) �R�[�i�[����
    (t (setq #ANG (+ pi #enANG)))
  ); cond
  ; �����ɍ����_�E�o
  (setq #kariP (pcpolar #minZP #ANG 50000))
  (setq #kriP1 (list (car #kariP) (cadr #kariP))) ; 2�����_�ɕϊ�
  (setq #kriP2 (pcpolar #kriP1 (+ (* 0.5 pi) #ANG) 1000))
  (setq #fDIST 100000); ���̋����l
  (foreach #P$ #PNT$
    (setq #crsP (inters #P$ (Pcpolar #P$ #ANG 1000) #kriP1 #kriP2 nil))
    (if (> #fDIST (distance #P$ #crsP)) (progn
      (setq #fDIST (distance #P$ #crsP))
      (setq #dPNT #P$)
    )); if progn
  ); foreach
  (setq #tesP (list (car #dPNT) (cadr #dPNT) (caddr #minZP)))
  (list (car #dPNT) (cadr #dPNT) (caddr #minZP))
); KcGetDoorInsertPnt

;<HOM>*************************************************************************
; <�֐���>    : PcGetLRButtomPos
; <�����T�v>  : �|�����C���Ɛݒu�p�x����E�_�A���_���Z�o
; <�߂�l>    : 2�����_���W
; <�쐬>      : 00/08/21 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcGetLRButtomPos (
  &ePL        ; ���|�����C���}�`��
  &fANG       ; XY���ʂɂ�����ݒu�p�x
  &LR         ; LR�t���O "L"��"R"
  /
  #PL$ #fH #dPL$ #chkP1 #chkP2 #dP #crossP #dist #chkDist #resP #resZ
  )
  ;;; ���|�����C���}�`�������W�_���X�g�ɕϊ��itrans������j
  (setq #PL$ (entget &ePL))
  (setq #fH (cdr (assoc 38 #PL$)))
  (while #PL$
    (if (= 10 (car (car #PL$)))
      (setq #dPL$ (cons (trans (append (cdr (car #PL$)) (list #fH)) &ePL 1 0) #dPL$))
    ); if
    (setq #PL$ (cdr #PL$))
  )

  ;;; �������e�_�̐����������Z�o�B�ő�̂��̂��E�[�_ �ŏ��̂��̂����[�_
  ; �����\���Q�_(2�����_)
  (setq #chkP1 '(0 0))
  (setq #chkP2 (pcpolar #chkP1 (+ &fANG (* 0.5 pi)) 100))
  (setq #resP nil)
  (setq #resZ nil)
  (foreach #dP #dPL$
    (setq #crossP (inters #chkP1 #chkP2 #dP (pcpolar #dP &fANG 100) nil))
    (setq #dist (distance #dP #crossP))
    (if (not (equal (read (angtos &fANG 0 4))
                    (read (angtos (angle #crossP #dP) 0 4)) 0.001))
      (setq #dist (- #dist))
    )
    ; ���W�_���X�g�̓��AX�l Y�l���擾
    (if (or (not #resP)
            (and (= "R" &LR) (< #chkDist #dist))
            (and (= "L" &LR) (> #chkDist #dist)))
      (progn
        (setq #resP #dP)
        (setq #chkDist #dist)
      ); progn
    ); if
    ; ���W�_���X�g�̓��AZ�l ���擾
    (if (or (not #resZ) (> #resZ (caddr #dP)))
      (setq #resZ (caddr #dP))
    ); if
  ); foreach
  (list (car #resP) (cadr #resP) #resZ )
); PcGetLRButtomPos

;;;<HOM>***********************************************************************
;;; <�֐���>    : SKD_GetGroupSymbole
;;; <�����T�v>  : �O���[�v���̃V���{����T������
;;; <�߂�l>    : �����F�V���{���}�`�̃G���e�B�e�B��   ���s�Fnil
;;; <�쐬>      : 1998/07/27 -> 1998/07/28  ���� �����Y
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun SKD_GetGroupSymbole (
    &enData$    ; �O���[�v�����������f�[�^���X�g
    /
    #GName$      ; �O���[�v�f�[�^�i�[�p
    #iGrpLoop    ; �O���[�v�v�f���[�v�p
    #SymData$    ; �V���{���t���O
    #num         ; �O���[�v�f�[�^�擾�p
    #nn
    #iFlag       ;
    #Temp$       ; �e���|�������X�g
    #iLoop       ; ���[�v�p
    #GRPDATA$
  )

  (if (/= (assoc 330 &enData$) nil)
    (progn
      (setq #iLoop 0)
      (setq #iFlag 0)
      (while (and (< #iLoop (length &enData$)) (= #iFlag 0))
        (setq #num (nth #iLoop &enData$))
        (if (= (car #num) 330)
          (progn
            (setq #GrpData$ (entget (cdr #num)))

            (setq #iGrpLoop 0)
            (setq #SymData$ nil)
            ;; �O���[�v�v�f���[�v
            (while (and (< #iGrpLoop (length #GrpData$)) (= #SymData$ nil))    ; �S�v�f�𒲂ׂ邩�A�V���{����������܂Ń��[�v
              (setq #Temp$ (nth #iGrpLoop #GrpData$))
              (if (= (car #Temp$) 340)
                (progn
                  (setq #SymData$ (CFGetXData (cdr #Temp$) "G_LSYM"))
                  (if (/= #SymData$ nil)
                    (progn
                      (setq #SymData$ (cdr #Temp$))
                      (setq #iFlag 1)
                    )
                  )
                )
              )
              (setq #iGrpLoop (+ #iGrpLoop 1))
            )
          )
        )
        (setq #iLoop (+ #iLoop 1))
      )
      (if (and (/= #iFlag 0) (/= #SymData$ nil))
        (progn
;;;          (CFOutStateLog 1 4 "    SKD_GetGroupSymbole=OK")
          #SymData$    ; return;
        )
        ;; else
        (progn
          (CFOutStateLog 0 4 "    SKD_GetGroupSymbole=�O���[�v����V���{�����擾�ł��܂���ł���")
          nil    ; return;
        )
      )
    )
    ;; else
    (progn
      (CFOutStateLog 0 4 "    SKD_GetGroupSymbole=�w�肳�ꂽ�}�`�̓O���[�v������Ă���f�[�^�ł͂���܂���")
      nil    ; return;
    )
  )
);SKD_GetGroupSymbole

;;;<HOM>***********************************************************************
;;; <�֐���>    : PKD_MakeSqlBase
;;; <�����T�v>  : ���}�`ID(�x�[�X)���f�[�^�x�[�X����擾����
;;; <�߂�l>    : �����F��������(���}�`ID)   ���s�Fnil
;;; <�쐬>      : 1998/07/25 -> 1998/07/25  ���� �����Y
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun PKD_MakeSqlBase (
  &exData$ ; �L���r�l�b�g�̊g���f�[�^(G_LSYM)
  &SetFace ; 2:PMEN7 , 3:MEJI
  /
  #strTemp    ; ������e���|����
  #strTemp2   ; ������e���|����
  #Code$      ; �����L�[�i�[���X�g
  #enName     ; foreach �p
  #doorId
  #Qry$ #msg #DOORINFO #DRSERICODE #RET$ #SERI$
  )
	;2011/12/27 YM ADD-S DB�ڑ����}�ɐ؂�Ă��܂��b��Ή�
	(setq #doorId nil)
	(setq #skk (nth 9 &exData$))

;2016/03/16 YM ADD �H�����i�R�[�h���P�P�O�@�l�������Ă���ƐH��ɔ���\��Ȃ� Windows7�͂��̏�ԂȂ̂Ŕ���\��
(setq CG_SKK_INT_SYOKU nil)
;2016/03/16 YM ADD �H�����i�R�[�h���P�P�O�@�l�������Ă���ƐH��ɔ���\��Ȃ�

	(if (= #skk CG_SKK_INT_SYOKU)
		(progn
			nil ;�������Ȃ�
		)
		(progn


		;;;	;2011/12/05 YM MOD-S
		;;;	; SERIES�ʃf�[�^�x�[�X�ւ̐ڑ�
		;;;	(if (= CG_DBSESSION nil)
		;;;		(progn
		;;;			(princ "\n������ SERIES�ʃf�[�^�x�[�X�ւ̍Đڑ� ������")
		;;;      (princ (strcat "\n�������@�����disconnect & asilisp.arx���ă��[�h����DB��CONNECT�@������"))
		;;;
		;;;			;�ذ�ޕ�DB,����DB�Đڑ�
		;;;			(ALL_DBCONNECT)
		;;;		)
		;;;	);_if
		;;;	;2011/12/05 YM MOD-E

		  (princ "\n�������@CG_DBSESSION�@������ :")(princ CG_DBSESSION)
		;-- 2011/11/29 A.Satoh Add - E

		  ; 01/10/31 YM ADD-S �������ύX�L���r�̂Ƃ��W�J�}�쐬�Ő}�ʂ̔�SERIES�Ŕ���\��
		  (if (= &SetFace 2)
		    (progn ; �W�J�}�쐬��
		      (setq #DoorInfo (nth 7 &exData$)) ; "��ذ��,��װ�L��"
		      (setq #ret$ (StrParse #DoorInfo ","))
		      (if (and #DoorInfo (/= #DoorInfo ""))
		        (progn
		          (setq #DRSeriCode (nth 0 #ret$))
		          (setq #CG_Hikite  (nth 2 #ret$));2011/04/22 YM ADD


		          (setq #Qry$
		            (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
		              (list
		                (list "�i�Ԗ���"     (nth 5 &exData$)         'STR)
		                (list "LR�敪"       (nth 6 &exData$)         'STR)
		                (list "���V���L��"   #DRSeriCode              'STR)
		                (list "����L��"     #CG_Hikite               'STR)
		              )
		            )
		          )

		        )
		      );_if
		    )
		    (progn ; &SetFace=3�̂Ƃ��ʏ���\��t��

		      (setq #Qry$
		        (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
		          (list
		            (list "�i�Ԗ���"     (nth 5 &exData$)         'STR)
		            (list "LR�敪"       (nth 6 &exData$)         'STR)
		            (list "���V���L��"   CG_DRSeriCode            'STR)
		            (list "����L��"     CG_Hikite                'STR)
		          )
		        )
		      )

		    )
		  );_if
		  ; 01/10/31 YM ADD-E �������ύX�L���r�̂Ƃ��W�J�}�쐬�Ő}�ʂ̔�SERIES�Ŕ���\��

			;2011/12/05 YM ADD
			(if (= nil #Qry$)
				(progn
		;;;			;�ذ�ޕ�DB,����DB�Đڑ�
		;;;			(ALL_DBCONNECT)

					;�Č���
				  (if (= &SetFace 2)
				    (progn ; �W�J�}�쐬��
				      (setq #DoorInfo (nth 7 &exData$)) ; "��ذ��,��װ�L��"
				      (setq #ret$ (StrParse #DoorInfo ","))
				      (if (and #DoorInfo (/= #DoorInfo ""))
				        (progn
				          (setq #DRSeriCode (nth 0 #ret$))
				          (setq #CG_Hikite  (nth 2 #ret$));2011/04/22 YM ADD


				          (setq #Qry$
				            (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
				              (list
				                (list "�i�Ԗ���"     (nth 5 &exData$)         'STR)
				                (list "LR�敪"       (nth 6 &exData$)         'STR)
				                (list "���V���L��"   #DRSeriCode              'STR)
				                (list "����L��"     #CG_Hikite               'STR)
				              )
				            )
				          )

				        )
				      );_if
				    )
				    (progn ; &SetFace=3�̂Ƃ��ʏ���\��t��

				      (setq #Qry$
				        (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
				          (list
				            (list "�i�Ԗ���"     (nth 5 &exData$)         'STR)
				            (list "LR�敪"       (nth 6 &exData$)         'STR)
				            (list "���V���L��"   CG_DRSeriCode            'STR)
				            (list "����L��"     CG_Hikite                'STR)
				          )
				        )
				      )

				    )
				  );_if

				)
			);_if

		;;;01/08/31YM@  (setq #Qry$ (DBCheck #Qry$ "�w�i�ԃV���x" "PKD_MakeSqlBase"))

		  ; 01/08/31 YM ں��ނȂ��Ă������Ȃ��悤��
		  (if (and #Qry$ (= 1 (length #Qry$)))
		    (progn
		      (setq #doorId (nth 4 (car #Qry$))) ; ���}ID
		    )
		    (progn
		      (setq #doorId nil) ; �i�ԃV����ں��ނ��Ȃ� or �d��
		      (princ (strcat "\n�y�i�ԃV���z�Ƀ��R�[�h���Ȃ����܂��͏d�����Ă��܂��B\n�i�Ԗ���:" (nth 5 &exData$)
		                          "\n����\��K�v���Ȃ��ꍇ�A�}�X�^�}�`�̖ڒn�̈�Ɣ��\����̈���폜���ĉ�����." "\n")
		      )
		    )
		  );_if

    )
  );_if

  #doorId
);PKD_MakeSqlBase

;<HOM>***********************************************************************
; <�֐���>    : SKD_GetLeftButtomPos
; <�����T�v>  : ���ʎw��}�`���̍����̍��W��T���o��
; <�߂�l>    : �����F ((�������W�_���X�g) (�����o���������X�g))�@�@�@���s�Fnil
; <�쐬>      : 1998/07/27 -> 1998/07/27   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKD_GetLeftButtomPos (
    &enName      ; ���ʎw��}�`��
    /
    #Data$       ; �}�`�f�[�^�i�[�p
    #sx          ; �ŏ�X�l
    #sy          ; �ŏ�Y�l
    #nn          ; foreach �p
  )
  ;; �}�`�̃f�[�^���擾����
  (setq #Data$ (entget &enName))

  ;; �ŏ��l�̃f�t�H���g�ݒ�
  (setq #sx (nth 0 (cdr (assoc 10 #Data$))))
  (setq #sy (nth 1 (cdr (assoc 10 #Data$))))

  ;; �}�`�\���f�[�^�������[�v
  (foreach #nn #Data$
    ;; ���X�g�����W�l�f�[�^���ǂ����̃`�F�b�N
    (if (= (car #nn) 10)
      (progn    ; ���W�l�f�[�^������
        ;; X�l�����݂̍ŏ��l��菬�������ǂ����`�F�b�N
        (if (<= (nth 0 (cdr #nn)) #sx)
          (progn    ; ����������
            ;; Y�l�����݂̍ŏ��l��菬�������ǂ����`�F�b�N
            (if (<= (nth 1 (cdr #nn)) #sy)
              (progn    ; ����������
                ;; �ŏ��l�̍X�V
                (setq #sx (nth 0 (cdr #nn)))
                (setq #sy (nth 1 (cdr #nn)))
              )
            )
          )
        )
      )
    )
  )

  ;; �����̒l�����͂���Ă��邩�ǂ����`�F�b�N
  (if (and (/= #sx nil) (/= #sy nil))
    (progn    ; ���͂���Ă���
      (CFOutStateLog 1 4 "    SKD_GetLeftButtomPos=OK")
      (cons (list #sx #sy) (assoc 210 #Data$))    ; return;
    )
    ;; else
    (progn    ; �ǂ��炩�����͂���Ă��Ȃ�����
      (CFOutStateLog 0 4 "    SKD_GetLeftButtomPos=���W�l���擾�ł��܂���ł���")
      nil    ; return;
    )
  )
);SKD_GetLeftButtomPos

;<HOM>***********************************************************************
; <�֐���>    : SKD_GetRightButtomPos
; <�����T�v>  : ���ʎw��}�`���̉E���̍��W��T���o��
; <�߂�l>    : �����F ((�E�����W�_���X�g) (�����o���������X�g))�@�@�@���s�Fnil
; <�쐬>      : 1999/04/13    ��{
; <���l>      :
;***********************************************************************>HOM<
(defun SKD_GetRightButtomPos (
    &enName      ; ���ʎw��}�`��
    /
    #Data$       ; �}�`�f�[�^�i�[�p
    #sx          ; �ŏ�X�l
    #sy          ; �ŏ�Y�l

    #nn          ; foreach �p
  )
  ;; �}�`�̃f�[�^���擾����
  (setq #Data$ (entget &enName))

  ;; �ŏ��l�̃f�t�H���g�ݒ�
  (setq #sx (nth 0 (cdr (assoc 10 #Data$))))
  (setq #sy (nth 1 (cdr (assoc 10 #Data$))))

  ;; �}�`�\���f�[�^�������[�v
  (foreach #nn #Data$
    ;; ���X�g�����W�l�f�[�^���ǂ����̃`�F�b�N
    (if (= (car #nn) 10)
      (progn    ; ���W�l�f�[�^������
        ;; X�l�����݂̍ŏ��l��菬�������ǂ����`�F�b�N
        (if (>= (nth 0 (cdr #nn)) #sx) ; �w�ʔ��s� 00/06/30 MH MOD
        ;(if (> (nth 0 (cdr #nn)) #sx)
          (progn    ; ����������
            ;; Y�l�����݂̍ŏ��l��菬�������ǂ����`�F�b�N
            (if (<= (nth 1 (cdr #nn)) #sy)
              (progn    ; ����������
                ;; �ŏ��l�̍X�V
                (setq #sx (nth 0 (cdr #nn)))
                (setq #sy (nth 1 (cdr #nn)))
              )
            )
          )
        )
      )
    )
  )
  ;; �����̒l�����͂���Ă��邩�ǂ����`�F�b�N
  (if (and (/= #sx nil) (/= #sy nil))
    (progn    ; ���͂���Ă���
      (CFOutStateLog 1 4 "    SKD_GetLeftButtomPos=OK")
      (cons (list #sx #sy) (assoc 210 #Data$))    ; return;
    )
    ;; else
    (progn    ; �ǂ��炩�����͂���Ă��Ȃ�����
      (CFOutStateLog 0 4 "    SKD_GetLeftButtomPos=���W�l���擾�ł��܂���ł���")
      nil    ; return;
    )
  )
);SKD_GetRightButtomPos

;<HOM>***********************************************************************
; <�֐���>    : SKD_ChangeLayer
; <�����T�v>  : �L�k��Ɨp��w������ʎw�肳��Ă����w�Ɉړ�����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998/07/31 -> 1998/07/31   ���� �����Y 2000/06/22 HT�߂�l�쐬
; <���l>      :
;***********************************************************************>HOM<
(defun SKD_ChangeLayer (
    &enGroup    ; �O���[�v�������O���[�v�̃O���[�v��
    &strLayer   ; �ړ����w��
    /
    #Name$      ; �O���[�v���̐}�`���i�[�p
    #Data$      ; �O���[�v���̐}�`�f�[�^�̃f�[�^���X�g�i�[�p

    #nn         ; foreach�p
    #lst$       ; ��w�ړ������}�`��
#LAYER
  )
  (setq #Name$ (entget &enGroup))
  (setq #lst$ '())
  ;; �f�[�^���X�g�������[�v
  (foreach #nn #Name$
    ;; �O���[�v�\���}�`���f�[�^���ǂ����̃`�F�b�N
    (if (= (car #nn) 340)
      (progn    ; �}�`���f�[�^������
        ;; ���̐}�`�̃f�[�^���擾����
        (setq #Data$ (entget (cdr #nn) '("*")))
        (setq #layer (cdr (assoc 8 #Data$)));03/10/17 YM ADD

        ;; ��w���L�k��Ɨp��w���ǂ����̃`�F�b�N
        (if (= #layer SKD_TEMP_LAYER)
          (progn    ; �L�k��Ɖ�w������
            ;; �}�`���̉�w��������������(��w�̈ړ�)
;;;           (setq #Data$ (vl-remove (cons 62 1) #Data$)) ; 01/05/14 YM �����Ȃ�
            (entmod (subst (cons 8 &strLayer) (cons 8 SKD_TEMP_LAYER) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; �F����w�̐F�ɂ���
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if

        ;������03/09/29 YM ADD-S ���J��������p
        ;; ��w���L�k��Ɨp��w���ǂ����̃`�F�b�N
        ;��w"DOOR_OPEN"�̔��}�`��"SKD_TEMP_LAYER_0"�Ƃ��Ă���DOOR_OPEN�ɖ߂�

        (if (= #layer SKD_TEMP_LAYER_0)
          (progn    ; �L�k��Ɖ�w������
            ;; �}�`���̉�w��������������(��w�̈ړ�)
            (entmod (subst (cons 8 DOOR_OPEN) (cons 8 SKD_TEMP_LAYER_0) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; �F����w�̐F�ɂ���
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if
        ;������03/09/29 YM ADD-E ���J��������p

        ;������03/10/17 YM ADD-S ���J��������p
        ;��w"DOOR_OPEN_04"�̔��}�`��"SKD_TEMP_LAYER_4"�Ƃ��Ă���DOOR_OPEN_04�ɖ߂�
        ;��w"DOOR_OPEN_06"�̔��}�`��"SKD_TEMP_LAYER_6"�Ƃ��Ă���DOOR_OPEN_06�ɖ߂�
        (if (= #layer SKD_TEMP_LAYER_4);�w�ʔ��J�������
          (progn    ; �L�k��Ɖ�w������
            ;; �}�`���̉�w��������������(��w�̈ړ�)
            (entmod (subst (cons 8 DOOR_OPEN_04) (cons 8 SKD_TEMP_LAYER_4) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; �F����w�̐F�ɂ���
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if

        (if (= #layer SKD_TEMP_LAYER_6);�E���ʔ��J�������
          (progn    ; �L�k��Ɖ�w������
            ;; �}�`���̉�w��������������(��w�̈ړ�)
            (entmod (subst (cons 8 DOOR_OPEN_06) (cons 8 SKD_TEMP_LAYER_6) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; �F����w�̐F�ɂ���
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if
        ;������03/10/17 YM ADD-E ���J��������p
      )
    );_if
  )
  #lst$
);SKD_ChangeLayer

;<HOM>***********************************************************************
; <�֐���>    : SKD_ChangeLayer_FMAT
; <�����T�v>  : �L�k��Ɨp��w������ʎw�肳��Ă����w�Ɉړ�����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998/07/31 -> 1998/07/31   ���� �����Y 2000/06/22 HT�߂�l�쐬
; <���l>      : 03/09/29 YM �W�J�}�쐬��p "DOOR_OPEN"��w�̔��}�`��
;               "SKD_TEMP_LAYER_0"��"0_door_0"�ɂ���
;***********************************************************************>HOM<
(defun SKD_ChangeLayer_FMAT (
    &enGroup    ; �O���[�v�������O���[�v�̃O���[�v��
    &strLayer   ; �ړ����w��
    /
    #Name$      ; �O���[�v���̐}�`���i�[�p
    #Data$      ; �O���[�v���̐}�`�f�[�^�̃f�[�^���X�g�i�[�p

    #nn         ; foreach�p
    #lst$       ; ��w�ړ������}�`��
  )
  (setq #Name$ (entget &enGroup))
  (setq #lst$ '())
  ;; �f�[�^���X�g�������[�v
  (foreach #nn #Name$
    ;; �O���[�v�\���}�`���f�[�^���ǂ����̃`�F�b�N
    (if (= (car #nn) 340)
      (progn    ; �}�`���f�[�^������
        ;; ���̐}�`�̃f�[�^���擾����
        (setq #Data$ (entget (cdr #nn) '("*")))
        ;; ��w���L�k��Ɨp��w���ǂ����̃`�F�b�N
        (if (= (cdr (assoc 8 #Data$)) SKD_TEMP_LAYER)
          (progn    ; �L�k��Ɖ�w������
            ;; �}�`���̉�w��������������(��w�̈ړ�)
;;;           (setq #Data$ (vl-remove (cons 62 1) #Data$)) ; 01/05/14 YM �����Ȃ�
            (entmod (subst (cons 8 &strLayer) (cons 8 SKD_TEMP_LAYER) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; �F����w�̐F�ɂ���
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if

        ;������03/09/29 YM ADD-S ���J��������p
        ;; ��w���L�k��Ɨp��w���ǂ����̃`�F�b�N
        ;��w"0"�̔��}�`��"SKD_TEMP_LAYER_0"�Ƃ��Ă��猳�ɖ߂����W�J�}�쐬��"0_door_0"
        (if (= (cdr (assoc 8 #Data$)) SKD_TEMP_LAYER_0)
          (progn    ; �L�k��Ɖ�w������
            ;; �}�`���̉�w��������������(��w�̈ړ�)
            (entmod (subst (cons 8 "0_door_0") (cons 8 SKD_TEMP_LAYER_0) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; �F����w�̐F�ɂ���
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if
        ;������03/09/29 YM ADD-E ���J��������p

        ;������03/10/17 YM ADD-S ���J������� �w�ʁA�E���ʗp
        ;; ��w���L�k��Ɨp��w���ǂ����̃`�F�b�N
        ;��w"0"�̔��}�`��"SKD_TEMP_LAYER_0"�Ƃ��Ă��猳�ɖ߂����W�J�}�쐬��"0_door_0"
        (if (= (cdr (assoc 8 #Data$)) SKD_TEMP_LAYER_4);�w��
          (progn    ; �L�k��Ɖ�w������
            ;; �}�`���̉�w��������������(��w�̈ړ�)
            (entmod (subst (cons 8 "0_door_4") (cons 8 SKD_TEMP_LAYER_4) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; �F����w�̐F�ɂ���
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if
        (if (= (cdr (assoc 8 #Data$)) SKD_TEMP_LAYER_6);�E����
          (progn    ; �L�k��Ɖ�w������
            ;; �}�`���̉�w��������������(��w�̈ړ�)
            (entmod (subst (cons 8 "0_door_6") (cons 8 SKD_TEMP_LAYER_6) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; �F����w�̐F�ɂ���
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if
        ;������03/10/17 YM ADD-E ���J������� �w�ʁA�E���ʗp

      )
    );_if
  )
  #lst$
);SKD_ChangeLayer_FMAT

;<HOM>***********************************************************************
; <�֐���>    : SKD_DeleteNotView
; <�����T�v>  : �C���T�[�g�}�`�𕪉����A�s�v�ȉ�w�̃f�[�^�͍폜���A
;                �c�����\������f�[�^��L�k��Ɖ�w�Ɉړ����A�O���[�v������
; <�߂�l>    : �����F �O���[�v�������O���[�v�̃G���e�B�e�B���@�@�@���s�Fnil
; <�쐬>      : 1998/07/29 -> 1998/07/30   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKD_DeleteNotView (
  &enName        ; ��������C���T�[�g�}�`�̐}�`��
  &strViewLayer  ; �\�������w��
  /
  #ssData$       ; ������̐}�`�f�[�^���i�[�p
  #enData$       ; �}�`�f�[�^�i�[�p
  #enName$       ; �L���}�`�����X�g�i�[�p
  #strDelBreak   ; �폜�u���[�N���C���̉�w��

  #iLoop         ; ���[�v�p
  #nn            ; foreach �p
#LAYER #dir #330 #EG$
  )
  ;; �C���T�[�g�}�`�𕪉�����
  (command "_explode" &enName)

  ;; �������ꂽ�f�[�^�̎擾
  (setq #ssData$ (ssget "P"))
  (setq #enName$ nil)

  ;����
  (setq #dir         (substr &strViewLayer 3 2));03/10/17 YM ADD

  (setq #strDelBreak (substr &strViewLayer 3 2))
  ;; �폜����u���[�N���C���̉�w�������߂�
  (cond
    ((or (= #strDelBreak "05") (= #strDelBreak "06"))    ; ���ʂ�����
      (setq #strDelBreak "N_BREAKW")
    )
    (T    ; ���ʁA�w�ʁA���̑�������
      (setq #strDelBreak "N_BREAKD")
    )
  )

  ;; �������ꂽ�f�[�^�������[�v
  (setq #iLoop 0)
  (while (< #iLoop (sslength #ssData$))
    (setq #enData$ (entget (ssname #ssData$ #iLoop)))
    (setq #layer (cdr (assoc 8 #enData$)));03/10/17 YM ADD

    ;; �f�[�^�̉�w���\�������w�Ɠ��ꂩ�ǂ����`�F�b�N
    (if (= (wcmatch #layer &strViewLayer) T)                  ;"Q_03_99_01_##" 
      (progn    ; �����w������
        ;; ��w���ړ����w�ɕύX����
        (entmod (subst (cons 8 SKD_TEMP_LAYER) (assoc 8 #enData$) #enData$))
        ;; �}�`�����i�[����
        (setq #enName$ (cons (cdr (car #enData$)) #enName$)) ; (-1 . �}�`��)
      )
      ;; else
      (progn    ; �����w�ł͂Ȃ�����
        ;; �f�t�H���g�w���w���ǂ����̃`�F�b�N
        (if (= (wcmatch #layer SKD_MATCH_LAYER) T)             ;"Q_00_99_##_"
          (progn    ; �f�t�H���g�w���w������
            ;; ��w���ړ����w�ɕύX����
            (entmod (subst (cons 8 SKD_TEMP_LAYER) (assoc 8 #enData$) #enData$))
            ;; �}�`�����i�[����
            (setq #enName$ (cons (cdr (car #enData$)) #enName$))
          )
          ;; else
          (progn    ; �f�t�H���g�w���w�ł͂Ȃ�����
            ;; �u���[�N���C�����ǂ����̃`�F�b�N
            (if (/= (wcmatch (strcase #layer) SKD_BREAK_LINE) T);"N_BREAK@"
              (progn    ; �u���[�N���C���ł͂Ȃ�����

                ;������03/09/29 YM ADD-S ���J��������p
                ;��w"DOOR_OPEN"�̔��}�`�͕ʈ�����"SKD_TEMP_LAYER_0"��w�ɂ��Ă���DOOR_OPEN�ɖ߂����W�J�}�쐬��"0_door_0"
                ;"DOOR_OPEN_04"�w��"DOOR_OPEN_06"�E���ʁ@���ǉ�
                (cond
                  ((= DOOR_OPEN   (strcase #layer))
                    (if (or (= #dir "04")(= #dir "05")(= #dir "06"))
                      (progn
                        (entdel (ssname #ssData$ #iLoop))
                      )
                      ;else
                      (progn
                        (entmod (subst (cons 8 SKD_TEMP_LAYER_0) (assoc 8 #enData$) #enData$))
                        (setq #enName$ (cons (cdr (car #enData$)) #enName$))
                      )
                    );_if
                  )
                  ((= DOOR_OPEN_04 (strcase #layer))
                    (if (or (= #dir "03")(= #dir "05")(= #dir "06"))
                      (progn
                        (entdel (ssname #ssData$ #iLoop))
                      )
                      ;else
                      (progn
                        (entmod (subst (cons 8 SKD_TEMP_LAYER_4) (assoc 8 #enData$) #enData$))
                        (setq #enName$ (cons (cdr (car #enData$)) #enName$))
                      )
                    );_if
                  )
                  ((= DOOR_OPEN_06 (strcase #layer))
                    (if (or (= #dir "03")(= #dir "04")(= #dir "05"))
                      (progn
                        (entdel (ssname #ssData$ #iLoop))
                      )
                      ;else
                      (progn
                        (entmod (subst (cons 8 SKD_TEMP_LAYER_6) (assoc 8 #enData$) #enData$))
                        (setq #enName$ (cons (cdr (car #enData$)) #enName$))
                      )
                    );_if
                  )
                  (T  ;���܂łǂ���
                    ;; �f�[�^�폜
                    (entdel (ssname #ssData$ #iLoop))
                  )
                );_cond

;;;03/10/17YM ADD               (if (= DOOR_OPEN (strcase (cdr (assoc 8 #enData$))))
;;;03/10/17YM ADD                 (progn
;;;03/10/17YM ADD                   (entmod (subst (cons 8 SKD_TEMP_LAYER_0) (assoc 8 #enData$) #enData$))
;;;03/10/17YM ADD                   (setq #enName$ (cons (cdr (car #enData$)) #enName$))
;;;03/10/17YM ADD                 )
;;;03/10/17YM ADD                 ;else
;;;03/10/17YM ADD                 (progn;���܂łǂ���
;;;03/10/17YM ADD                   ;; �f�[�^�폜
;;;03/10/17YM ADD                   (entdel (ssname #ssData$ #iLoop))
;;;03/10/17YM ADD                 )
;;;03/10/17YM ADD               );_if

              )
              ;; else
              (progn
                ;; �폜����u���[�N���C�����ǂ����̃`�F�b�N
                (if (= (strcase #layer) #strDelBreak)
                  (progn    ; �폜����u���[�N���C��������
                    ;; �f�[�^�폜
                    (entdel (ssname #ssData$ #iLoop))
                  )
                  ;; else
                  (progn
                    ;; �}�`�����i�[����
                    (setq #enName$ (cons (cdr (car #enData$)) #enName$))
                  )
                )
              )
            )
          )
        )
      )
    )
    (setq #iLoop (+ #iLoop 1))
  )

  ;; �i�[�����ړ���}�`���̃��X�g�� nil �łȂ����ǂ����`�F�b�N
  (if (/= #enName$ nil)
    (progn    ; ���X�g���ɐ}�`�������݂���
      (setq SKD_GROUP_NO (SCD_GetDoorGroupName)) ; 00/06/30 YM NR(4/25)����}��
;;;      (setq SKD_GROUP_NO (+ SKD_GROUP_NO 1))  ; 00/06/30 YM MOD

      ;; �i�[�����ړ���}�`�̑S�Ă𓯈�̃O���[�v�ɂ���(�O���[�v��)
      (command "-group" "C" (strcat SKD_GROUP_HEAD (substr &strViewLayer 4 1) (itoa SKD_GROUP_NO)) SKD_GROUP_INFO)
      (foreach #nn #enName$
        (command #nn)
      )
      (command "")
      ;; �O���[�v�������f�[�^�̃O���[�v�}�`�����擾����

			;2015/12/17 YM MOD-S
;;;      (setq #enData$ (cdr (assoc -1 (entget (cdr (assoc 330 (entget (nth 0 #enName$))))))))
			;�O���[�v�}�`�����擾���郍�W�b�N��ύX����@����Ď擾���Ĕ��̉�w��"M*"�ɖ߂��Ȃ��s�������
			(setq #eg$ (entget (nth 0 #enName$)))
			(foreach #eg #eg$
				(if (= 330 (car #eg))
					(progn
						(setq #330 (cdr #eg))
						(if (= "GROUP" (cdr (assoc 0 (entget #330))))
							(setq #enData$ (cdr (assoc -1 (entget #330))))
						);_if
					)
				);_if
			);foreach
			;2015/12/17 YM MOD-E


      ;; ����I��
      #enData$    ; return;
    )
    ;; else
    (progn    ; �}�`�������݂��Ȃ�����(nil)
      ;; �ُ�I���F�\����w�̃f�[�^�����݂��܂���ł���
      nil    ; return;
    )
  )
);SKD_DeleteNotView

;<HOM>***********************************************************************
; <�֐���>    : SKD_DeleteNotView_TOKU
; <�����T�v>  : ���}�`��L�k��Ɖ�w�Ɉړ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : �������޺���ޗp 01/05/11 YM
; <���l>      :
;***********************************************************************>HOM<
(defun SKD_DeleteNotView_TOKU (
  &enDoor$       ; ���}�`�I���
  /
  #ENDATA$ #ILOOP #LAYER
  )
  (setq #iLoop 0)
  (while (< #iLoop (sslength &enDoor$))
    (setq #enData$ (entget (ssname &enDoor$ #iLoop)))
    (setq #layer (cdr (assoc 8 #enData$)));03/10/17 YM ADD

    ; POINT,XLINE�ȊO�̉�w��SKD_TEMP_LAYER�ɂ���
;-- 2012/03/27 A.Satoh Mod CG����肪�o�Ȃ� - S
;;;;;    (if (or (= (cdr (assoc 0 #enData$)) "POINT")(= (cdr (assoc 0 #enData$)) "XLINE"))
    (if (= (cdr (assoc 0 #enData$)) "XLINE")
;-- 2012/03/27 A.Satoh Mod CG����肪�o�Ȃ� - S
      nil
      ;else
      (progn
;-- 2012/03/27 A.Satoh Add CG����肪�o�Ȃ� - S
				(if (= (cdr (assoc 0 #enData$)) "POINT")
					(if (= (car (CFGetXData (ssname &enDoor$ #iLoop) "G_PTEN")) 21)
						(cond
							((= DOOR_OPEN (strcase #layer))
								(entmod (subst (cons 8 SKD_TEMP_LAYER_0) (assoc 8 #enData$) #enData$))
							)
							((= DOOR_OPEN_04 (strcase #layer))
								(entmod (subst (cons 8 SKD_TEMP_LAYER_4) (assoc 8 #enData$) #enData$))
							)
							((= DOOR_OPEN_06 (strcase #layer))
								(entmod (subst (cons 8 SKD_TEMP_LAYER_6) (assoc 8 #enData$) #enData$))
							)
							(T
								(entmod (subst (cons 8 SKD_TEMP_LAYER)   (assoc 8 #enData$) #enData$))
							)
						)
					)
					(progn
						; �|�C���g�}�`�łȂ����
;-- 2012/03/27 A.Satoh Add CG����肪�o�Ȃ� - E

        ;������03/09/29 YM ADD-S ���J��������p
        ;��w"DOOR_OPEN"�̔��}�`�͕ʈ�����"SKD_TEMP_LAYER_0"��w�ɂ��Ă���DOOR_OPEN�ɖ߂����W�J�}�쐬��"0_door_0"
        ;��w"DOOR_OPEN_04"�w��"DOOR_OPEN_06"�E���ʂ��ǉ�
        (cond
          ((= DOOR_OPEN (strcase #layer))
            (entmod (subst (cons 8 SKD_TEMP_LAYER_0) (assoc 8 #enData$) #enData$))
          )
          ((= DOOR_OPEN_04 (strcase #layer))
            (entmod (subst (cons 8 SKD_TEMP_LAYER_4) (assoc 8 #enData$) #enData$))
          )
          ((= DOOR_OPEN_06 (strcase #layer))
            (entmod (subst (cons 8 SKD_TEMP_LAYER_6) (assoc 8 #enData$) #enData$))
          )
          (T
            (entmod (subst (cons 8 SKD_TEMP_LAYER)   (assoc 8 #enData$) #enData$))
          )
        );_cond
;-- 2012/03/27 A.Satoh Add CG����肪�o�Ȃ� - S
					)
				)
;-- 2012/03/27 A.Satoh Add CG����肪�o�Ȃ� - E

;;;03/10/17YM ADD       (if (= DOOR_OPEN (strcase #layer))
;;;03/10/17YM ADD         (entmod (subst (cons 8 SKD_TEMP_LAYER_0) (assoc 8 #enData$) #enData$))
;;;03/10/17YM ADD         ;else
;;;03/10/17YM ADD         (entmod (subst (cons 8 SKD_TEMP_LAYER)   (assoc 8 #enData$) #enData$))
;;;03/10/17YM ADD       );_if

      )
    );_if
    (setq #iLoop (+ #iLoop 1))
  );while
  (princ)
);SKD_DeleteNotView_TOKU

;;;<HOM>*************************************************************************
;;; <�֐���>    : SCD_GetDoorGroupName
;;; <�����T�v>  : ���}�`�̃O���[�v�쐬
;;; <�߂�l>    :
;;;         STR : ���}�`��
;;; <�쐬>      : 00/02/29
;;; <���l>      : 00/06/30 YM NR(4/25)����}��
;;;*************************************************************************>MOH<
(defun SCD_GetDoorGroupName (
  /
  #Eg$ #eXen #Sub$ #Eg$$ #sName #sTmp
  #eg #eg$ #i #en #no #no$
  )
  (setq #eg$ (entget (namedobjdict)))
  (setq #i 0)
  (setq #en nil)
  (while (and (= #en nil) (< #i (length #eg$)))
    (setq #eg (nth #i #eg$))
    (if (and (= 3 (car #eg)) (= "ACAD_GROUP" (cdr #eg)))
      (setq #en (cdr (nth (1+ #i) #eg$)))
    )
    (setq #i (1+ #i))
  )
  (if (= #en nil)
    (setq #no 0)
    (progn
      (setq #eg$ (entget #en))
      (setq #i 0)
      (while (< #i (length #eg$))
        (setq #eg (nth #i #eg$))
        (if (and (= 3 (car #eg)) (= "DOORGROUP" (substr (cdr #eg) 1 9)))
;;;01/06/27YM@          (setq #no$ (cons (atoi (substr (cdr #eg) 10)) #no$))
          (setq #no$ (cons (atoi (substr (cdr #eg) 11)) #no$)) ; ����:"DOORGROUP30",�w��:"DOORGROUP40"�ɕύX
        )
        (setq #i (1+ #i))
      )
      (if (= #no$ nil)
        (setq #no 0)
        (progn
          ;// �J���ԍ����擾����
          (setq #i 1)
          (setq #no nil)
          (while (= #no nil)
            (if (= nil (member #i #no$))
              (setq #no #i)
            )
            (setq #i (1+ #i))
          )
        )
      )
    )
  )
  #no
);SCD_GetDoorGroupName

;<HOM>***********************************************************************
; <�֐���>    : SKD_GetDoorPos
; <�����T�v>  : ���ʂ̗̈���擾����
; <�߂�l>    : �����F �E��ƍ���̍��W��Ԃ��@�@�@���s�Fnil
; <�쐬>      : 1998/08/03 -> 1998/08/03   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKD_GetDoorPos (
    &enGroup    ; ���ʂ̃O���[�v��
    /
    #enName$    ; �O���[�v���}�`���i�[�p
    #enData$    ; �}�`���f�[�^���X�g�i�[�p

    #MaxX       ; X �ő���W�l
    #MaxY       ; Y �ő���W�l
    #MaxZ       ; Z �ő���W�l
    #MinX       ; X �ŏ����W�l
    #MinY       ; Y �ŏ����W�l
    #MinZ       ; Z �ŏ����W�l

    #Temp$      ; �e���|�������X�g
    #nn         ; foreach �p
    #mm         ; foreach �p
    #View$
  )
  ;; �O���[�v�f�[�^�擾
  (setq #enName$ (entget &enGroup))

  ;; �O���[�v�v�f�������[�v
  (foreach #nn #enName$
    ;; �O���[�v�\���}�`�����ǂ����̃`�F�b�N
    (if (= (car #nn) 340)
      (progn    ; �O���[�v�\���}�`��������
        ;; �O���[�v�\���}�`�̃f�[�^���擾
        (setq #enData$ (entget (cdr #nn)))
        ;; �f�[�^�\���������[�v
        (if (or (= (cdr (assoc 0 #enData$)) "LINE") (= (cdr (assoc 0 #enData$)) "LWPOLYLINE") (= (cdr (assoc 0 #enData$)) "POLYLINE"))
          (progn
            (foreach #mm #enData$
              ;; �f�[�^�����W�l���ǂ����̃`�F�b�N
              (if (or (= (car #mm) 10) (= (car #mm) 11))
                (progn    ; ���W�l������
                  ;; ���W�ϊ�
                  (setq #Temp$ (trans (cdr #mm) (cdr #nn) 1 0))

                  ;; �����l�̑��������Ă��邩�ǂ����̃`�F�b�N
                  (if (= #MaxX nil)
                    (progn    ; �����l���������Ă��Ȃ�����
                      ;; �����l����
                      (setq #MaxX (nth 0 #Temp$))
                      (setq #MaxY (nth 1 #Temp$))
                      (setq #MaxZ (nth 2 #Temp$))
                      (setq #MinX (nth 0 #Temp$))
                      (setq #MinY (nth 1 #Temp$))
                      (setq #MinZ (nth 2 #Temp$))
                    )
                  )
                  ;; �ő� X �l�`�F�b�N
                  (if (< #MaxX (nth 0 #Temp$))
                    (progn
                      (setq #MaxX (nth 0 #Temp$))
                    )
                  )
                  ;; �ő� Y �l�`�F�b�N
                  (if (< #MaxY (nth 1 #Temp$))
                    (progn
                      (setq #MaxY (nth 1 #Temp$))
                    )
                  )
                  ;; �ő� Z �l�`�F�b�N
                  (if (< #MaxZ (nth 2 #Temp$))
                    (progn
                      (setq #MaxZ (nth 2 #Temp$))
                    )
                  )
                  ;; �ŏ� X �l�`�F�b�N
                  (if (> #MinX (nth 0 #Temp$))
                    (progn
                      (setq #MinX (nth 0 #Temp$))
                    )
                  )
                  ;; �ŏ� Y �l�`�F�b�N
                  (if (> #MinY (nth 1 #Temp$))
                    (progn
                      (setq #MinY (nth 1 #Temp$))
                    )
                  )
                  ;; �ŏ� Z �l�`�F�b�N
                  (if (> #MinZ (nth 2 #Temp$))
                    (progn
                      (setq #MinZ (nth 2 #Temp$))
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

  (if (and (/= #MaxX nil) (/= #MaxY nil) (/= #MinX nil) (/= #MinY nil))
    (progn
      (CFOutStateLog 1 4 "      SKD_GetDoorPos=End OK")
      ;; return;
      (setq #view$ (trans (getvar "VIEWDIR") 1 0))
;;; 00/05/11 DEL MH �w�ʏ��������폜
;;; 00/05/11 DEL MH (if (and (equal (car #view$) 0 0.01) (equal (cadr #view$) 1 0.01) (equal (caddr #view$) 0 0.01))
;;; 00/05/11 DEL MH         (list (list #MinX #MaxY) (list #MaxX #MinY)) ;�w�ʂ̎�
      (list (list #MaxX #MaxY) (list #MinX #MinY)) ;�w�ʂłȂ�
;;; 00/05/11 DEL MH       )
    )
    ;; else
    (progn
      (CFOutStateLog 0 4 "      SKD_GetDoorPos=End ���ʗ̈悪����Ɏ擾�ł��܂���ł���")
      ;; return;
      nil
    )
  )
);SKD_GetDoorPos

;<HOM>***********************************************************************
; <�֐���>    : SKD_FigureExpansion
; <�����T�v>  : �}�`��L�k����
; <�߂�l>    : �����F T�@�@�@���s�Fnil
; <�쐬>      : 1998/07/31 -> 1998/08/03   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKD_FigureExpansion (
  &enGroup    ; �L�k���s���O���[�v�̃O���[�v��
  &Rect$      ; ���ʗ̈�̋�`���W((�E����W) (�������W))
  &ViewZ$     ; Z ����ł̐��̓_���w��(�����o������)(ex : (0 -1 0))
  /
  #enName$    ; �O���[�v�\���}�`���i�[�p
  #brkH$      ; �u���[�N���C��H�����}�`���i�[�p
;;;01/09/25YM@DEL  #brkE$      ; �u���[�N���C��W�����������́AD�����̐}�`���i�[�p
  #brkW$      ; �u���[�N���C��W����
  #brkD$      ; �u���[�N���C��D����
  #DoorPos$   ; ���ʗ̈�̉E����W�ƍ������W�i�[�p((�E��X���W �E��Y���W) (����X���W ����Y���W))
  #iExpAmount ; �L�k�ʊi�[�p
  #BrkLine    ; �u���[�N���C���ʒu�i�[�p
  #Temp$      ; �e���|�������X�g
  #nn         ; foreach �p
  #iLoop      ; ���[�v�p
  #BrkLine$    ; �u���[�N���C���ʒu�i�[�p
  #BrkD$ #BrkW$ #OS #SM #UF #GR #OT #UV
  #clayer
  )
  (CFOutStateLog 1 4 "    SKD_FigureExpansion=Start")

;;;(command "-layer" "T" "*" "ON" "*" "U" "*" "") ; 00/03/09 YM ADD

  (setq #os (getvar "OSMODE"))     ; 00/03/08 YM ADD
  (setq #sm (getvar "SNAPMODE"))   ; 00/03/08 YM ADD
  (setq #uf (getvar "UCSFOLLOW"))  ; 00/03/08 YM ADD
  (setq #uv (getvar "UCSVIEW"))    ; 00/03/08 YM ADD
  (setq #gr (getvar "GRIDMODE"))   ; 00/03/08 YM ADD
  (setq #ot (getvar "ORTHOMODE"))  ; 00/03/08 YM ADD

;;;  (setq #wv (getvar "WORLDVIEW"))

  (setvar "OSMODE"     0) ; 00/03/08 YM ADD
  (setvar "SNAPMODE"   0) ; 00/03/08 YM ADD
  ;(setvar "UCSFOLLOW"  1) ; 00/03/08 YM ADD ; 2000/09/12 HT MOD ���x���P�̂���
  (setvar "UCSFOLLOW"  0) ; 00/03/08 YM ADD  ; 2000/09/12 HT MOD ���x���P�̂���
  (setvar "UCSVIEW"  0)   ; 00/03/08 YM ADD
  (setvar "GRIDMODE" 0)   ; 00/03/08 YM ADD
  (setvar "ORTHOMODE" 0)  ; 00/03/08 YM ADD
;;;  (setvar "WORLDVIEW"  0)

  ;; UCS �ύX
  (command "_UCS" "ZA" "0,0,0" &ViewZ$)

  (command "_PLAN" "C")  ; 2000/09/12 HT MOD ���x���P�̂���
  ;; �O���[�v���̐}�`�����擾
  (setq #enName$ (entget &enGroup))
  ;; �u���[�N���C���̗L�����`�F�b�N
  (foreach #nn #enName$
    ;; �O���[�v�\���}�`�����ǂ����̃`�F�b�N
    (if (= (car #nn) 340)
      (progn    ; �}�`��������
        ;; �u���[�N���C���̊g�����̗L���`�F�b�N
        (setq #Temp$ (CFGetXData (cdr #nn) "G_BRK"))
        (if (/= #Temp$ nil)
          (progn    ; �u���[�N���C���g����񂪂�����
            ;; �u���[�N���C���̕������`�F�b�N
            (cond
              ((= (nth 0 #Temp$) 1)    ; W�������ǂ����̃`�F�b�N(1)
                (setq #brkW$ (cons (cdr #nn) #brkW$))
;;;01/09/25YM@DEL                (setq #brkE$ (cons (cdr #nn) #brkE$))
              )
              ((= (nth 0 #Temp$) 2)    ; D�������ǂ����̃`�F�b�N(2)
                (setq #brkD$ (cons (cdr #nn) #brkD$))
;;;01/09/25YM@DEL                (setq #brkE$ (cons (cdr #nn) #brkE$))
              )
              ((= (nth 0 #Temp$) 3)    ; H�������ǂ����̃`�F�b�N(3)
                (setq #brkH$ (cons (cdr #nn) #brkH$))
              )
            )
          )
        )
      )
    )
  )

  ;; ���ʂ̗̈���擾����
  (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
  (if (/= #DoorPos$ nil)
    (if (or (/= #brkW$ nil) (/= #brkD$ nil) (/= #brkH$ nil))
      (progn
         (command "_vpoint" &ViewZ$)
      )
    )
  )

  ;/////////////////////////////////////////////////////////////
  ; ���݉�w�̕ύX
;;;01/06/07YM@  (setq #clayer (getvar "CLAYER"))
;;;01/06/07YM@  (setvar "CLAYER" SKD_TEMP_LAYER)
;;;01/06/07YM@  ; ���݉�w�ȊO���ذ�� 01/06/07
;;;01/06/07YM@  (command "_layer" "F" "*" "") ;�S�Ẳ�w���ذ��
;;;01/06/07YM@  (command "_zoom" "E") ; object�͈ͽް�
;;;01/06/07YM@  (command "_zoom" "0.8x")

  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKD_TEMP_LAYER)
  ; ���݉�w�ȊO���ذ�� 01/06/07
  (command "_layer" "F" "*" "") ;�S�Ẳ�w���ذ��

  ;03/10/20 YM ADD-S
  (command "_.layer" "T" SKD_TEMP_LAYER_0 "") ; 03/10/17 YM ADD
  (command "_.layer" "T" SKD_TEMP_LAYER_4 "") ; 03/10/17 YM ADD
  (command "_.layer" "T" SKD_TEMP_LAYER_6 "") ; 03/10/17 YM ADD
  ;03/10/20 YM ADD-E

  (command "_zoom" "E") ; object�͈ͽް�
  (command "_zoom" "0.5x")

  ;; H �����u���[�N���C���̗L���`�F�b�N
  (if (and (/= #brkH$ nil) (/= #DoorPos$ nil))
    (progn    ; H �����u���[�N���C����������
      (setq #brkH$ (SKESortBreakLine (list 2 #brkH$) (append (nth 1 #DoorPos$) '(0))))
      ;; �L�k�ʂ����߂�
      (cond ; 01/08/20 YM ADD ���ق��ް��ŏꍇ����
        ((= CG_BASE_UPPER nil) ; �ް��̂Ƃ����܂ł�ۼޯ�(����ق���t��===>T,����=nil)
          ; �۱����
          (setq #iExpAmount (/ (- (nth 1 (nth 0 &Rect$)) (nth 1 (nth 0 #DoorPos$))) (length #brkH$)))
        )
        ((= CG_BASE_UPPER T) ; ���ق̂Ƃ��ǉ���ۼޯ�(����ق���t��===>T,����=nil)
          ; ���ٷ���
          (setq #iExpAmount (/ (- (nth 1 (nth 1 &Rect$)) (nth 1 (nth 1 #DoorPos$))) (length #brkH$)))
        )
      );_cond ; 01/08/20 YM ADD ���ق��ް��ŏꍇ����

	;2015/12/17 YM ADD-S �L�k��0�̂Ƃ��͐L�k���Ȃ�
	(if (< 0.01 (abs #iExpAmount) )
		(progn

      (setq #iLoop 0)
      ;; H �����u���[�N���C�����g�p���AH �����L�k���s��
      ;; �u���[�N���C���̖{�������[�v
      (while (and (< #iLoop (length #brkH$)) (/= #DoorPos$ nil))
        (setq #nn (nth #iLoop #brkH$))
        (setq #Temp$ (entget #nn '("*")))
        (setq #BrkLine (trans (cdr (assoc 10 #Temp$)) 0 1))
        (setq #BrkLine (nth 1 #BrkLine))
        (cond ; 01/08/20 YM ADD ���ق��ް��ŏꍇ����
          ((= CG_BASE_UPPER nil) ; �ް��̂Ƃ����܂ł�ۼޯ�(����ق���t��===>T,����=nil)
            (if (ssget "C"
                (nth 0 #DoorPos$)
                (list (nth 0 (nth 1 #DoorPos$)) #BrkLine)
                (list (cons 8 "SKD_TEMP_LAYER\*"));03/10/20 YM MOD
;;;               (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (nth 0 #DoorPos$)
                    (list (nth 0 (nth 1 #DoorPos$)) #BrkLine)
                    (list (cons 8 "SKD_TEMP_LAYER\*"));03/10/20 YM MOD
;;;                   (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@0," (rtos #iExpAmount))
                )
                ;; ���ʂ̗̈���擾����
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
          ((= CG_BASE_UPPER T) ; ���ق̂Ƃ��ǉ���ۼޯ�(����ق���t��===>T,����=nil)
            (if (ssget "C"
                (list (nth 0 (nth 0 #DoorPos$)) #BrkLine)
                (nth 1 #DoorPos$)
                (list (cons 8 "SKD_TEMP_LAYER\*"))
;;;               (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (list (nth 0 (nth 0 #DoorPos$)) #BrkLine)
                    (nth 1 #DoorPos$)
                    (list (cons 8 "SKD_TEMP_LAYER\*"))
;;;                   (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@0," (rtos #iExpAmount))
                )
                ;; ���ʂ̗̈���擾����
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
        );_cond ; 01/08/20 YM ADD ���ق��ް��ŏꍇ����
        (setq #iLoop (+ #iLoop 1))
      )

		)
	);_if
	;2015/12/17 YM ADD-E �L�k��0�̂Ƃ��͐L�k���Ȃ�


    )
  );_if  H ����


  ;; W �����������́AD �����̃u���[�N���C���̗L���`�F�b�N--->W�����̂�01/09/25 YM
;;;01/09/25YM@DEL  (if (and (/= #DoorPos$ nil) (/= #brkE$ nil))
  (if (and (/= #DoorPos$ nil) (/= #brkW$ nil))
    (progn    ; �u���[�N���C����������
      (setq #brkW$ (SKESortBreakLine (list 0 #brkW$) (nth 1 #DoorPos$)))
;;;01/09/25YM@DEL      (setq #brkE$ (SKESortBreakLine (list 0 #brkE$) (nth 1 #DoorPos$)))
      ;; �L�k�ʂ����߂�
      (setq #iExpAmount (/ (- (nth 0 (nth 0 &Rect$)) (nth 0 (nth 0 #DoorPos$))) (length #brkW$)))
;;;01/09/25YM@DEL      (setq #iExpAmount (/ (- (nth 0 (nth 0 &Rect$)) (nth 0 (nth 0 #DoorPos$))) (length #brkE$)))
      (if (= CG_TOKU "2") ; �w�ʏ����� 01/05/21 YM ADD
        (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkW$)))
;;;01/09/25YM@DEL       (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkE$)))
      );_if

      (if (= CG_TOKU "4") ; �E���ʏ����� 01/09/25 YM ADD
        (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkW$)))
;;;01/09/25YM@DEL       (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkE$)))
      );_if

;;;00/05/11 DEL MH �w�ʏ������폜
;;; 00/04/27 MH ADD 180�x��]�}�`�ւ̑Ή�
;;;    (if (and (equal (car &ViewZ$) 0 0.01)
;;;             (equal (cadr &ViewZ$) 1 0.01)
;;;             (equal (caddr &ViewZ$) 0 0.01))
;;;      (setq #iExpAmount (- (/ (- (nth 0 (nth 0 #DoorPos$)) (nth 0 (nth 0 &Rect$)) )
;;;        (length #brkE$)))) ;�w��
;;;      (setq #iExpAmount (/ (- (nth 0 (nth 0 &Rect$)) (nth 0 (nth 0 #DoorPos$)))
;;;        (length #brkE$))) ;�w�ʂłȂ�
;;;    )
;;;   ;; �w��
;;; 00/04/27 MH ADD 180�x��]�}�`�ւ̑Ή�



	;2015/12/17 YM ADD-S �L�k��0�̂Ƃ��͐L�k���Ȃ�
	(if (< 0.01 (abs #iExpAmount) )
		(progn



      ;; �u���[�N���C�����g�p���A�L�k���s��
      (setq #iLoop 0)

;;;  00/03/09 YM break line �� assoc 10 ��x���W���傫�����̏��ɕ��בւ�
      (setq #BrkLine$ '())
;;;01/09/25YM@DEL      (while (< #iLoop (length #brkE$))
;;;01/09/25YM@DEL        (setq #nn (nth #iLoop #brkE$))
      (while (< #iLoop (length #brkW$))
        (setq #nn (nth #iLoop #brkW$))
        (setq #Temp$ (entget #nn '("*")))
        (setq #BrkLine$ (append #BrkLine$ (list (trans (cdr (assoc 10 #Temp$)) 0 1))))  ;;;  00/03/09 YM
        (setq #iLoop (+ #iLoop 1))
      )

      (setq #BrkLine$ (reverse (CFListSort #BrkLine$ 0)))

      (setq #iLoop 0)
      ;; �u���[�N���C���̖{�������[�v
;;;      (while (and (< #iLoop (length #brkE$)) (/= #DoorPos$ nil))   ;;;  00/03/09 YM
;;;01/09/25YM@DEL      (while (and (< #iLoop (length #brkE$)) (/= #DoorPos$ nil))
      (while (and (< #iLoop (length #brkW$)) (/= #DoorPos$ nil))
;;;        (setq #nn (nth #iLoop #brkE$))  ;;;  00/03/09 YM
;;;        (setq #Temp$ (entget #nn '("*")))  ;;;  00/03/09 YM
;;;        (setq #BrkLine (trans (cdr (assoc 10 #Temp$)) 0 1))  ;;;  00/03/09 YM
        (setq #BrkLine (nth #iLoop #BrkLine$))  ;;;  00/03/09 YM

;;;01/09/25YM@DEL        (cond
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 1)    ; W�����u���[�N���C��
            (setq #BrkLine (nth 0 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 2)    ; D�����u���[�N���C��
;;;01/09/25YM@DEL            (setq #BrkLine (nth 0 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 3)    ; H�����u���[�N���C��
;;;01/09/25YM@DEL            (setq #BrkLine (nth 1 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL        );_cond

        ; ���ꏈ��
        (cond
          ; 01/09/25 YM ADD-S
          ((= CG_TOKU "4") ; �E���ʏ�����
            (if (ssget "C"
                  (list #BrkLine     (nth 1 (nth 0 #DoorPos$))) ; ��ڰ��ʒu�̒���
;;;01/09/25YM@DEL (list (- #BrkLine) (nth 1 (nth 0 #DoorPos$))) ; ��ڰ��ʒu�̒��� �����炪������???
                  (nth 1 #DoorPos$)
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (list #BrkLine (nth 1 (nth 0 #DoorPos$)))
                    (nth 1 #DoorPos$)
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; ���ʂ̗̈���擾����
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
          ; 01/09/25 YM ADD-E
          ((= CG_TOKU "2") ; �w�ʏ����� 01/05/21 YM ADD
            (if (ssget "C"
                  (list #BrkLine     (nth 1 (nth 0 #DoorPos$))) ; ��ڰ��ʒu�̒���
;;;01/09/25YM@DEL (list (- #BrkLine) (nth 1 (nth 0 #DoorPos$))) ; ��ڰ��ʒu�̒��� �����炪������???
                  (nth 1 #DoorPos$)
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (list #BrkLine (nth 1 (nth 0 #DoorPos$)))
                    (nth 1 #DoorPos$)
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; ���ʂ̗̈���擾����
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
          ;�ȉ��ʏ폈��
          (T
            (if (ssget "C"
                  (nth 0 #DoorPos$)
                  (list #BrkLine (nth 1 (nth 1 #DoorPos$)))
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (nth 0 #DoorPos$)                                                 ; 00/03/09 YM MOD
                    (list #BrkLine (nth 1 (nth 1 #DoorPos$)))
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; ���ʂ̗̈���擾����
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
        );_cond

        (setq #iLoop (+ #iLoop 1))
      );while


		)
	);_if
	;2015/12/17 YM ADD-E �L�k��0�̂Ƃ��͐L�k���Ȃ�




    )
  );_if W ����



  ;; D �����̃u���[�N���C���̗L���`�F�b�N01/09/25 YM ADD-S /////////////////////////////////////
  (if (and (/= #DoorPos$ nil) (/= #brkD$ nil))
    (progn    ; �u���[�N���C����������
      (setq #brkD$ (SKESortBreakLine (list 0 #brkD$) (nth 1 #DoorPos$)))
      ;; �L�k�ʂ����߂�
      (setq #iExpAmount (/ (- (nth 0 (nth 0 &Rect$)) (nth 0 (nth 0 #DoorPos$))) (length #brkD$)))
      (if (= CG_TOKU "2") ; �w�ʏ����� 01/05/21 YM ADD
        (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkD$)))
      );_if

      (if (= CG_TOKU "4") ; �E���ʏ����� 01/09/25 YM ADD
;;;01/09/25YM@DEL       (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkD$)))
        (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkD$)))
      );_if

      ;; �u���[�N���C�����g�p���A�L�k���s��
      (setq #iLoop 0)

;;;  00/03/09 YM break line �� assoc 10 ��x���W���傫�����̏��ɕ��בւ�
      (setq #BrkLine$ '())
      (while (< #iLoop (length #brkD$))
        (setq #nn (nth #iLoop #brkD$))
        (setq #Temp$ (entget #nn '("*")))
        (setq #BrkLine$ (append #BrkLine$ (list (trans (cdr (assoc 10 #Temp$)) 0 1))))  ;;;  00/03/09 YM
        (setq #iLoop (+ #iLoop 1))
      )

      (setq #BrkLine$ (reverse (CFListSort #BrkLine$ 0)))

      (setq #iLoop 0)
      ;; �u���[�N���C���̖{�������[�v
      (while (and (< #iLoop (length #brkD$)) (/= #DoorPos$ nil))
        (setq #BrkLine (nth #iLoop #BrkLine$))  ;;;  00/03/09 YM

;;;01/09/25YM@DEL        (cond
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 1)    ; W�����u���[�N���C��
;;;01/09/25YM@DEL            (setq #BrkLine (nth 0 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 2)    ; D�����u���[�N���C��
            (setq #BrkLine (nth 0 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 3)    ; H�����u���[�N���C��
;;;01/09/25YM@DEL            (setq #BrkLine (nth 1 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL        );_cond

        ; ���ꏈ��
        (cond
          ; 01/09/25 YM ADD-S
          ((= CG_TOKU "4") ; �E���ʏ�����
            (if (ssget "C"
                  (list #BrkLine (nth 1 (nth 0 #DoorPos$))) ; ��ڰ��ʒu�̒���
                  (nth 1 #DoorPos$) ; ��ڰ��ʒu�̒���
;;;                 (list (- (nth 0 (nth 0 #DoorPos$)) #iExpAmount) (nth 1 (nth 1 #DoorPos$))) ; ��ڰ��ʒu�̒���
;;;01/09/25YM@DEL                 (nth 1 #DoorPos$)
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                  (list #BrkLine (nth 1 (nth 0 #DoorPos$))) ; ��ڰ��ʒu�̒���
                    (nth 1 #DoorPos$)
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; ���ʂ̗̈���擾����
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
          ; 01/09/25 YM ADD-E
          ((= CG_TOKU "2") ; �w�ʏ����� 01/05/21 YM ADD
            (if (ssget "C"
                  (list #BrkLine     (nth 1 (nth 0 #DoorPos$))) ; ��ڰ��ʒu�̒���
;;;01/09/25YM@DEL (list (- #BrkLine) (nth 1 (nth 0 #DoorPos$))) ; ��ڰ��ʒu�̒��� �����炪������???

                  (nth 1 #DoorPos$)
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (list #BrkLine (nth 1 (nth 0 #DoorPos$)))
                    (nth 1 #DoorPos$)
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; ���ʂ̗̈���擾����
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
          ;�ȉ��ʏ폈��
          (T
            (if (ssget "C"
                  (nth 0 #DoorPos$)
                  (list #BrkLine (nth 1 (nth 1 #DoorPos$)))
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (nth 0 #DoorPos$)                                                 ; 00/03/09 YM MOD
                    (list #BrkLine (nth 1 (nth 1 #DoorPos$)))
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; ���ʂ̗̈���擾����
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
        );_cond

        (setq #iLoop (+ #iLoop 1))
      );while
    )
  );_if D ����
  ;; D �����̃u���[�N���C���̗L���`�F�b�N01/09/25 YM ADD-E /////////////////////////////////////



  (SetLayer) ; �\����w�̐ݒ�(���ɖ߂�)
  (setvar "CLAYER" #clayer) ; ���݉�w��߂�

;;;01/06/07YM@  ; ���݉�w�̕ύX
;;;01/06/07YM@  (SetLayer) ; �\����w�̐ݒ�(���ɖ߂�)
;;;01/06/07YM@  (setvar "CLAYER" #clayer) ; ���݉�w��߂�
  ;/////////////////////////////////////////////////////////////

  (command "_UCS" "P")    ;���O�̏�Ԃɖ߂� ; ���x���P�̂��߂�UCSFOLLOW��0�Ƃ��AVIEW�������Ȃ��悤�ɂ����B

  (setvar "OSMODE"     #os) ; 00/03/08 YM ADD
  (setvar "SNAPMODE"   #sm) ; 00/03/08 YM ADD
  (setvar "UCSFOLLOW"  #uf) ; 00/03/08 YM ADD
  (setvar "UCSVIEW"    #uv) ; 00/03/08 YM ADD
  (setvar "GRIDMODE"   #gr) ; 00/03/08 YM ADD
  (setvar "ORTHOMODE"  #ot) ; 00/03/08 YM ADD

  ;; ���ʗ̈���擾�ł������ǂ����̃`�F�b�N
  (if (/= #DoorPos$ nil)
    (progn    ; �擾�ł���
      (CFOutStateLog 1 4 "    SKD_FigureExpansion=End OK")
      T    ; return;
    )
    ;; else
    (progn    ; ���ʗ̈悪�擾�ł��Ȃ�����
      (CFOutStateLog 0 4 "    SKD_FigureExpansion=End ���ʗ̈�̎擾���ł��܂���ł����B���}�`�f�[�^���ُ�ȉ\��������܂�")
      nil    ; return;
    )
  )

);SKD_FigureExpansion

;<HOM>***********************************************************************
; <�֐���>    : GetGruopMaxMinCoordinate
; <�����T�v>  : "GROUP"����LINE,POLYLINE�͈͂̍ő�ŏ������߂�
; <�߂�l>    : (list (list #MinX #MinY #MinZ) (list #MaxX #MaxY #MaxZ))
; <�쐬>      : 1998/07/30 -> 1998/07/31   ���� �����Y
; <���l>      : ���}�`�̍ő�A�ŏ����W�����߂�(��ڰ�ײݍ쐬�ɗp����)
;***********************************************************************>HOM<
(defun GetGruopMaxMinCoordinate (
  &enGroup ; �L�k���s���O���[�v"GROUP"
  &LeftUnderPT ; �������_ MEJI����
  /
  #10 #11 #DIS #EG$ #ET$ #FLG #PNT$ #RIGHTUPPT #TYPE #XYZ #Z #_PNT$
  )
;/////////////////////////////////////////////////////////////
; 2D-->3D
;/////////////////////////////////////////////////////////////
    (defun ##2Dto3D ( &xy / )
      (if (= (caddr &xy) nil)
        (list (car &xy)(cadr &xy) 0)
        &xy
      );_if
    )
;/////////////////////////////////////////////////////////////

  (setq #et$ (entget &enGroup))
  (setq #flg nil)
  (setq #PNT$ nil) ; ���\���}�`�̒[�_���Wؽ�
  (foreach #et #et$
    (if (= (car #et) 340)
      (progn
        (setq #eg$ (entget (cdr #et)))
        (setq #type (cdr (assoc 0 #eg$))) ; �}�`����
        (cond
          ((= #type "LINE")
            (setq #10 (cdr (assoc 10 #eg$)))
            (setq #11 (cdr (assoc 11 #eg$)))
            (setq #10 (##2Dto3D #10))
            (setq #11 (##2Dto3D #11))
            (setq #PNT$ (append #PNT$ (list #10 #11)))
          )
          ((= #type "LWPOLYLINE")
            (setq #Z (cdr (assoc 38 #eg$)))
            (setq #_PNT$ nil)
            (foreach #eg #eg$ (if (= 10 (car #eg))(setq #_PNT$ (cons (cdr #eg) #_PNT$))))
            (foreach #P #_PNT$
              (setq #xyz (trans (append #P (list #Z)) (cdr #et) 1 0))
              (setq #PNT$ (append #PNT$ (list #xyz)))
            )
          )
        );_cond
      )
    );_if
  );foreach

  ;;; ���E��_�����߂�MEJI�����ƈ�ԗ���Ă���_
  (setq #dis -999)
  (foreach #PNT #PNT$ ; �����\������LINE,POLYLINE�̊e�[�_
    (if (< #dis (distance #PNT &LeftUnderPT))
      (progn
        (setq #dis (distance #PNT &LeftUnderPT))
        (setq #RightUpPT #PNT)
      )
    );_if
  )
  (list &LeftUnderPT #RightUpPT)
);GetGruopMaxMinCoordinate

;<HOM>***********************************************************************
; <�֐���>    : SKD_Expansion
; <�����T�v>  : ���}�`��L�k����(���ۂ� SKD_FigureExpansion ���L�k�������s��)
;                �����ł́A�̈�̋�`���W�̒��o�����s��
; <�߂�l>    : �����F T�@�@�@���s�Fnil
; <�쐬>      : 1998/07/30 -> 1998/07/31   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKD_Expansion (
  &enGroup    ; �L�k���s���O���[�v�̃O���[�v��  "GROUP"
  &eMEJI$     ; ���ʗ̈�̃f�[�^���X�g "G_MEJI"
  /
  #Rect$      ; ��`���W�i�[�p
  #MaxX       ; X �ő���W�l
  #MaxY       ; Y �ő���W�l
  #MinX       ; X �ŏ����W�l
  #MinY       ; Y �ŏ����W�l

  #Temp$      ; �e���|�������X�g
  #nn         ; foreach �p
  #View$ #view
  #Sp$ #Ep$
  #lay
  )
  (CFOutStateLog 1 4 "    SKD_Expansion=Start")

  ;; ��`���W�i�[�ϐ��̏�����
  (setq #Rect$ nil)
  (setq #Sp$ nil)
  (setq #Ep$ nil)
  ;; 00/11/13 MH ���p�`�̗̈悪����̂ŁA�����ύX
  ;; ���ʗ̈�̍��W����4�ȏ�ł��邩�ǂ����̃`�F�b�N
  (if (>= (cdr (assoc 90 &eMEJI$)) 4)
  ;; ���ʗ̈�̍��W����4�ł��邩�ǂ����̃`�F�b�N
  ;(if (= (cdr (assoc 90 &eMEJI$)) 4)
    (progn    ; ���_����4�ȏゾ����
      ;; �f�[�^�v�f�������[�v
      (foreach #nn &eMEJI$
        ;; ���X�g�̃f�[�^�����W�l�ł��邩�ǂ����`�F�b�N
        (if (= (car #nn) 10)
          (progn    ; ���W�l������
            (setq #Temp$ (cdr #nn))
            ;; �f�t�H���g�̒l�ŏ�����
            (if (= #MaxX nil)
              (progn
                ;; �����l����
                (setq #MaxX (nth 0 #Temp$))
                (setq #MaxY (nth 1 #Temp$))
                (setq #MinX (nth 0 #Temp$))
                (setq #MinY (nth 1 #Temp$))
              )
            )
            ;; �ő� X �l�`�F�b�N
            (if (< #MaxX (nth 0 #Temp$))
              (progn
                (setq #MaxX (nth 0 #Temp$))
              )
            )
            ;; �ő� Y �l�`�F�b�N
            (if (< #MaxY (nth 1 #Temp$))
              (progn
                (setq #MaxY (nth 1 #Temp$))
              )
            )
            ;; �ŏ� X �l�`�F�b�N
            (if (> #MinX (nth 0 #Temp$))
              (progn
                (setq #MinX (nth 0 #Temp$))
              )
            )
            ;; �ŏ� Y �l�`�F�b�N
            (if (> #MinY (nth 1 #Temp$))
              (progn
                (setq #MinY (nth 1 #Temp$))
              )
            )
          )
        )
      )
      ;; ���W�����X�g�Ɋi�[����
      (setq #lay (cdr (assoc 8 &eMEJI$)))
      (setq #View$ (cdr (assoc 210 &eMEJI$)))

;;;00/05/11DEL �w�ʓ��ꏈ�����폜
;;;00/05/11DEL      (if (and (equal (car #View$) 0 0.01) (equal (cadr #View$) 1 0.01) (equal (caddr #View$) 0 0.01))
;;;00/05/11DEL        (progn
;;;00/05/11DEL          (setq #Rect$ (list (list #MinX #MaxY) (list #MaxX #MinY))) ;�w�ʂ̎�
;;;00/05/11DEL        )
;;;00/05/11DEL        (progn

          (setq #Rect$ (list (list #MaxX #MaxY) (list #MinX #MinY))) ;�w�ʂłȂ�

;;;00/05/11DEL        )
;;;00/05/11DEL      )
      ;; �L�k�������s��
      (if (/= (SKD_FigureExpansion &enGroup #Rect$ #View$) nil)
        (progn
          (CFOutStateLog 1 4 "    SKD_Expansion=End OK")
          T    ;return;
        )
        ;; else
        (progn
          (CFOutStateLog 0 4 "    SKD_Expansion=End �L�k����������ɍs���܂���ł���")
          nil    ; return;
        )
      )
    )
    ;; else
    (progn    ; ���_�����ȉ�������
      (CFOutStateLog 0 4 "    SKD_Expansion=End ���ʗ̈�̒��_�����ُ�(4�ȉ�)�ł�")
      nil    ; return;
    )
  )
);SKD_Expansion

;<HOM>***********************************************************************
; <�֐���>    : SKD_DeleteInsertLayer
; <�����T�v>  : �C���T�[�g���ꂽ���}�`�̉�w��S�č폜����
; <�߂�l>    : �����F T�@�@�@���s�Fnil
; <�쐬>      : 1998/08/03 -> 1998/08/03   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKD_DeleteInsertLayer (
    /
    #iLoop      ; ���[�v�p
  )
  (setq #iLoop 0)
  (while (< #iLoop 5)
    (command "_purge" "B" "*" "N")
    (setq #iLoop (+ #iLoop 1))
  )
  (command "_purge" "LA" "Q_*" "N")
)
;SKD_DeleteInsertLayer

;<HOM>***********************************************************************
; <�֐���>    : SCD_DeleteHatch
; <�����T�v>  : �n�b�`�}�`������
; <�߂�l>    : �����F T      ���s�Fnil
; <�쐬>      : 1998/08/04 -> 1998/08/04   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKD_DeleteHatch (
    &enName    ; ���ʗ̈�̐}�`��
    /
    #Data$      ; �f�[�^���X�g�i�[�p
    #nn         ; foreach �p
    #lay
  )
  (if (/= (CFGetXData &enName "G_MEJI") nil)
    (progn
      (setq #Data$ (entget &enName))
      (foreach #nn #Data$
        (if (= (car #nn) 330)
          (progn
            ;(if (= (cdr (assoc 0 (entget (cdr #nn)))) "HATCH")
            (setq #lay (cdr (assoc 8 (entget (cdr #nn)))))
            (if (and
                 (/= #lay nil)
                 (= nil (CFGetXData (cdr #nn) "G_MEJI"))
                 (wcmatch #lay "M_*")
                )
              (progn
                (entdel (cdr #nn))
              )
            )
          )
        )
      )
    )
  )
  T    ; return;
)
;SKD_DeleteHatch

;<HOM>***********************************************************************
; <�֐���>    : SKD_EraseDoor
; <�����T�v>  : ���ɑ��݂�����ʂ��폜����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-15
; <���l>      : �Ȃ�
;***********************************************************************>HOM<
(defun SKD_EraseDoor (
    &en       ;(ENAME)���ʂ��폜����V���{���}�`��
    &SetFace  ;(INT)  �폜����ʂ̎��(2:2D-�o�� 3:3D�ڒn�̈�)
    /
    #eg$ #eg #eg2 #eg2$ #delFlg #300 #330 #340 #i #j #lay #loop
  )
  ;// �V���{����}�`�����b�N
  (command "_.layer" "lo" "N_SYMBOL" "")
  (setvar "PICKSTYLE" 1)
  (setq #eg$ (entget &en '("*")))

  (setq #i 0)
  (foreach #eg #eg$
    ;// �O���[�v�֘A�̐}�`�̎��ɏ������s��
    (if (= (car #eg) 330)
      (progn
        (setq #eg2$ (entget (cdr #eg)))
        (setq #300 (cdr (assoc 300 #eg2$)))      ;�O���[�v��`����
        (setq #330 (cdr (assoc 330 #eg2$)))
        (setq #340 (cdr (assoc 340 #eg2$)))

        (if (= #300 "DoorGroup")
          ;// �O���[�v��`���̂�"DoorGroup" �̏ꍇ
          (progn
            (setq #loop T)
            (setq #j 0)
            (setq #delFlg nil)

            (while (and #loop (< #j (length #eg2$)))
              (setq #eg2 (nth #j #eg2$))
              (if (= (car #eg2) 340)
                (progn
                  ;// ��w���擾����
                  (setq #lay (cdr (assoc 8 (entget (cdr #eg2)))))
                  (cond
                    ;// �R�c���ʂ̏ꍇ�́A��w�l�Q�� �A�y�Q�����폜�ΏۂƂ���
                    ((= &SetFace 3)
                      (if (and #lay (= nil (wcmatch #lay "N_*")))
                        (progn
                          (entdel (cdr #eg2))
                          (setq #delFlg T)
                        )
                      )
                    )
                    ;// �Q�c���ʂ̏ꍇ�́A��w�y�Q�����폜�ΏۂƂ���
                    ((= &SetFace 2)
                      (if (and #lay (wcmatch #lay "Z_*"))
                        (progn
                          (entdel (cdr #eg2))
                          (setq #delFlg T)
                        )
                      )
                    )
                  )
                )
              )
              (setq #j (1+ #j))
            )
            ;// �O���[�v��`�}�`�����폜����
            (if (= #delFlg T)
              (entdel (cdr (car #eg2$)))
            )
          )
        ;else
          ;// �O���[�v��`���ɂȂɂ������Ă��Ȃ��ꍇ
          (progn
            (setq #lay (cdr (assoc 8 (entget #340))))
            (if (and
                     #lay
                     (/= (strcase #lay) "N_SYMBOL")
                     (= (wcmatch #lay "Y_*") nil)
                )
              (progn
                (cond
                  ;// �R�c���ʂ̏ꍇ�́A��w�l�Q�� �A�y�Q�����폜�ΏۂƂ���
                  ((and (= &SetFace 3) (= nil (wcmatch #lay "Z_*")))
                    (command "_.ERASE" #340 "")  ;�O���[�v���[�h�ō폜 PICKAUTO=1
                  )
                  ;// �Q�c���ʂ̏ꍇ�́A��w�y�Q�����폜�ΏۂƂ���
                  ;((and (= &SetFace 2) (wcmatch #lay "Z_*"))
                  ;  (command "_.ERASE" #340 "")  ;�O���[�v���[�h�ō폜 PICKAUTO=1
                  ;)
                )
              )
            )
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
  (setvar "PICKSTYLE" 0)
  (command "_.layer" "u" "N_SYMBOL" "")
)
;SKD_EraseDoor

;<HOM>***********************************************************************
; <�֐���>    : PKD_EraseDoor
; <�����T�v>  : ���ɑ��݂�����ʂ��폜����
; <�߂�l>    :
; <�쐬>      :
; <���l>      :
;***********************************************************************>HOM<
(defun PKD_EraseDoor (
    &en
    /
    #eg$ #eg #eg2 #300 #330 #340 #i #lay
  )
  ;// �V���{����}�`�����b�N
  (command "_layer" "lo" "N_SYMBOL" "") ; LOۯ�
  (setvar "PICKSTYLE" 1)
  (setq #eg$ (entget &en '("*")))
  (setq #i 0)
  (foreach #eg #eg$
    (if (= (car #eg) 330)
      (progn
        (setq #eg2 (entget (cdr #eg)))
        (setq #300 (cdr (assoc 300 #eg2))) ; �O���[�v�̐���
;;;        (setq #330 (cdr (assoc 330 #eg2))) ; ���g�p YM 00/02/29
        (setq #340 (cdr (assoc 340 #eg2)))
        (if (= #300 SKD_GROUP_INFO) ; �O���[�v�̐���
          (progn
            (command "_erase" #340 "")
            (entdel (cdr (car #eg2)))
          )
          ;03/05/09 YM DEL-S
;;;         (progn
;;;           (setq #lay (cdr (assoc 8 (entget #340)))) ; ��w�𒲂ׂ�
;;;         )
          ;#300=""��#340�����܂���"M_*"���������߰��������Ă��܂�
          ;#300=""�̂Ƃ��̏����͕K�v�Ȃ��̂ł͂Ȃ���?-->���i�ʂ�Ȃ�-->���Ă���
;;;03/05/09YM@DEL          (progn
;;;03/05/09YM@DEL            (setq #lay (cdr (assoc 8 (entget #340))))
;;;03/05/09YM@DEL;;;;�ҏW  ;00/02/14 MH MOD
;;;03/05/09YM@DEL            (if (and (= 'STR (type #lay)) (/= #lay "N_SYMBOL") (= nil (wcmatch #lay "Z_*")))
;;;03/05/09YM@DEL;;;            (if (and (/= #lay "N_SYMBOL") (= nil (wcmatch #lay "Z_*")))
;;;03/05/09YM@DEL            ;(if (= nil (wcmatch (cdr (assoc 8 (entget #340))) "N_*"))
;;;03/05/09YM@DEL              (progn
;;;03/05/09YM@DEL                (command "_erase" #340 "")
;;;03/05/09YM@DEL              )
;;;03/05/09YM@DEL            )
;;;03/05/09YM@DEL          )
          ;03/05/09 YM DEL-E

;�ꎞ�I�ɕ��� 03/06/10 YM
          (progn
            (setq #lay (cdr (assoc 8 (entget #340))))
;;;;�ҏW  ;00/02/14 MH MOD
;;;;�ҏW  ;04/04/12 SK MOD �O���[�v����"Y_*" �}�`���l������悤�ύX
            ; 06/09/12 ���̃��[�g�͂���Ȃ��͂��B
            ; �K�v�Ȑ}�`�������Ă��܂��B
;            (if (and (= 'STR (type #lay)) (/= #lay "N_SYMBOL") (= nil (wcmatch #lay "Z_*"))(= nil (wcmatch #lay "Y_*")))  ; 06/09/12 T.Ari Mod
             (if nil
;;;            (if (and (= 'STR (type #lay)) (/= #lay "N_SYMBOL") (= nil (wcmatch #lay "Z_*")))
;;;            (if (and (/= #lay "N_SYMBOL") (= nil (wcmatch #lay "Z_*")))
            ;(if (= nil (wcmatch (cdr (assoc 8 (entget #340))) "N_*"))
              (progn
                (command "_erase" #340 "")
              )
            )
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
  (setvar "PICKSTYLE" 0)
  (command "_layer" "u" "N_SYMBOL" "")
)
;PKD_EraseDoor

;<HOM>***********************************************************************
; <�֐���>    : KP_GetAllDoor
; <�����T�v>  : �}�ʏ�̑S���}�`�̑I��Ă�Ԃ�
; <�߂�l>    : �I���
; <�쐬>      : 03/05/13 YM
; <���l>      : �y���ݕۑ��z���ɔ����폜���Ă���ۑ�����
;***********************************************************************>HOM<
(defun KP_GetAllDoor (
  /
  #300 #EG$ #EG2$ #I #SS #SSDOOR #SYM #340 #LAY
  )
  (setq #ssDOOR (ssadd))
  (setq #ss (ssget "X" '((-3 ("G_SYM"))))) ; G_LSYM �}�`�I���
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        (setq #eg$ (entget #sym '("*")))
        (foreach #eg #eg$
          (if (= (car #eg) 330)
            (progn
              (setq #eg2$ (entget (cdr #eg)))
              (setq #300 (cdr (assoc 300 #eg2$))) ; �O���[�v�̐���
              (if (= #300 SKD_GROUP_INFO)
                (foreach #eg2 #eg2$
                  (if (= (car #eg2) 340)
                    (progn
                      ;��w"N_SYMBOL"������
                      (setq #340 (cdr #eg2))
                      (setq #lay (cdr (assoc 8 (entget #340))))
                      (if (/= #lay "N_SYMBOL")
                        (ssadd (cdr #eg2) #ssDOOR)
                      );_if
                    )
                  );_if
                )
              );_if
            )
          );_if
        );foreach
        (setq #i (1+ #i))
      );repeat
    )
  );_if
  #ssDOOR ; ���}�`�I���
);KP_GetAllDoor

;<HOM>*************************************************************************
; <�֐���>    : SKD_ChgSeriesDlg
; <�����T�v>  : ��SERIES�ύX�_�C�A���O
; <�߂�l>    :
; <�쐬>      : 1999-10-21
; <���l>      :
;*************************************************************************>MOH<
(defun SKD_ChgSeriesDlg (
    &SeriCode        ;(STR)SERIES�L��
    &BrandCode       ;(STR)�u�����h�L��
    &DrCode          ;(STR)��SERIES�L��
    &DrColCode       ;(STR)��COLOR�L��
    /
    #dcl_id
    #lst
    #no
    ##GetDlgItem
    ##SelectSeries
    #ret$
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##GetDlgItem ( / #lst )
    ;// �a���̓`�F�b�N
    (setq #lst
      (list
        (get_tile "seri")
        (get_tile "col")
      )
    )
    (done_dialog)
    #lst
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##SelectSeries ( / #lst )
    (start_list "col" 3)
    (foreach #lst &hole-qry$$
      (add_list (strcat (itoa (fix (nth 1 #lst))) "�F" (nth 2 #lst)))
    )
    (end_list)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "PosSinkDlg" #dcl_id)) (exit))

  (start_list "sink" 3)
  (foreach #lst &snk-qry$$
    (add_list (strcat (nth 1 #lst) "�F" (nth 2 #lst)))
  )
  (end_list)

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
  (action_tile "seri"    "(##SelectSeries)")
  (action_tile "cancel" "(setq #ret$ nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  ;// �V���N�A�������A������ނ̑I��ԍ��y�ь��a�A�\�����a��Ԃ�
  #ret$
)
;SKD_ChgSeriesDlg

;<HOM>***********************************************************************
; <�֐���>    : SetLayer
; <�����T�v>  : �\����w�̐ݒ���s��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/06/07 YM
; <���l>      :
;***********************************************************************>HOM<
(defun SetLayer ( / )
  ;// �\����w�̐ݒ�
  (command "_layer"
    "F"   "*"                ;�S�Ẳ�w���t���[�Y
    "T"   "Z_00*"            ;  Z_00���̃\���b�h��w�̃t���[�Y����
    "T"   "N_*"              ;  N_*�V���{�����_�}�`��w�̃t���[�Y����
    "T"   "M_*"              ;  M_*�ڒn�̈�}�`��w�̉���
    "T"   "0"                ;  "0"��w�̉���
    "ON"  "M_*"              ;  M_*�ڒn�̈�}�`��w�̕\��
    "OFF" "N_B*" ""          ;  N_B*�u���[�N���C���}�`�̔�\��
  )
  (command "_.layer" "T" "Z_KUTAI" "") ; 01/02/20 YM ADD
  (command "_.layer" "T" "0_*" "")     ; 01/06/11 YM ADD

  (command "_.layer" "T" DOOR_OPEN    "") ; 03/09/29 YM ADD
  (command "_.layer" "T" DOOR_OPEN_04 "") ; 03/10/17 YM ADD
  (command "_.layer" "T" DOOR_OPEN_06 "") ; 03/10/17 YM ADD

;;;01/07/16YM@  (command "_.layer" "T" "0_door" "")  ; 01/06/11 YM ADD
  (princ)
);SetLayer

(princ)