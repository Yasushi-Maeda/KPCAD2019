;;;<HOF>************************************************************************
;;; <�t�@�C����>: Kcbaloon.LSP
;;; <�V�X�e����>: KitchenPlan�V�X�e��
;;; <�ŏI�X�V��>: 01/02/13 ���� ���L
;;; <���l>      : �Ȃ�
;;;************************************************************************>FOH<
;@@@(princ "\nKcbaloon.fas ��۰�ޒ�...\n")

;01/02/13 HN ADD �V��t�B���[�̌��ς薇���ݒ��ǉ�
; 0= �}�`������莩���ώZ
; 1< �����Œ�
(setq CG_FillerNum 1)


;;;<HOM>************************************************************************
;;; <�֐���>  : C:WriteBaloon
;;; <�����T�v>: ���݂̏��i�����t�@�C���ɏ����o��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �v�����t�H���_�̉��L�t�@�C�����쐬���܂�
;;;               HEAD.CFG   �w�b�_�[���
;;;               TABLE.CFG  �d�l�\���
;;;************************************************************************>MOH<
(defun C:WriteBaloon (
  /
  )

  ;// �R�}���h�̏�����
  (StartUndoErr)

  ;// �w�b�_�[��񏑂��o��
  (SKB_WriteHeadList)

  ;// �������[�N�g�b�v���
  (PKOutputWTCT)

  ;// �d�l�\�t�@�C����
  (SCFMakeBlockTable)

  (setq *error* nil)
  (princ)
)
;;;C:WriteBaloon

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_WriteHeadList
;;; <�����T�v>: ���݂̏��i�̃w�b�_�[�����t�@�C���ɏ����o��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �v�����t�H���_�� HEAD.CFG �ɏ����o���܂�
;;;************************************************************************>MOH<
(defun SKB_WriteHeadList (
  /
  #sFname     ; �t�@�C����
  #head$      ; �w�b�_�[���
  #fp         ; �t�@�C�� �|�C���^
  )
  (setq #sFname (strcat CG_KENMEI_PATH "HEAD.CFG"))

  ;// �w�b�_�[�����擾����
  (setq #head$  (SKB_GetHeadList))

  ;// �w�b�_�[���t�@�C���ւ̏�������
  (setq #fp  (open #sFname "w"))
  (princ   ";;; �e�����t�H���_�ɒu��"                  #fp)
  (princ "\n;;;"                                       #fp)
  (princ "\n;;; SeriesCD       : SERIES�L��"         #fp)
  (princ "\n;;; Series         : SERIES����"         #fp)
  (princ "\n;;; DrSeriesCD     : ��SERIES�L��"       #fp)
  (princ "\n;;; DrSeries       : ��SERIES����"       #fp)
  (princ "\n;;; DrColorCD      : ��COLOR�L��"         #fp)
  (princ "\n;;; DrColor        : ��COLOR����"         #fp)
  (princ "\n;;; WT_zaiCD       : ���[�N�g�b�v�ގ��L��" #fp)
  (princ "\n;;; WT_zai         : ���[�N�g�b�v�ގ�����" #fp)
  (princ "\n;;; WT_height      : ���[�N�g�b�v����"     #fp) ; 01/06/01 YM ADD
  (princ "\n;;; SinkCD         : �V���N�L��"           #fp)
  (princ "\n;;; Sink           : �V���N����"           #fp)
  (princ "\n;;; ElecType       : �d�C��"               #fp)
  (princ "\n;;; GasType        : �K�X��"               #fp)
  (princ "\n;;; HandleType     : �ϐk�L��(�c��L��)"   #fp)
  (princ "\n;;; EquipmentColor : �@��F"               #fp)
  (princ "\n;;;"                                       #fp)
  (princ (strcat "\nSeriesCD="       (nth  0 #head$))  #fp)
  (princ (strcat "\nSeries="         (nth  1 #head$))  #fp)
  (princ (strcat "\nDrSeriesCD="     (nth  2 #head$))  #fp)
  (princ (strcat "\nDrSeries="       (nth  3 #head$))  #fp)
  (princ (strcat "\nDrColorCD="      (nth  4 #head$))  #fp)
  (princ (strcat "\nDrColor="        (nth  5 #head$))  #fp)
  (princ (strcat "\nWT_zaiCD="       (nth  6 #head$))  #fp)
  (princ (strcat "\nWT_zai="         (nth  7 #head$))  #fp)
  (princ (strcat "\nWT_height="      (nth  8 #head$))  #fp) ; 01/06/01 YM ADD
  (princ (strcat "\nSinkCD="         (nth  9 #head$))  #fp)
  (princ (strcat "\nSink="           (nth 10 #head$))  #fp)
;;;  (princ (strcat "\nElecType="       (nth 11 #head$))  #fp)

  (princ (strcat "\nGasType="        "P")  #fp) ;2008/08/04 YM MOD
;;;  (princ (strcat "\nGasType="        (nth 12 #head$))  #fp) ;2008/08/04 YM MOD

;;;  (princ (strcat "\nHandleType="     (nth 13 #head$))  #fp)

  (princ (strcat "\nEquipmentColor=" "K")  #fp) ;2008/08/04 YM MOD
;;;  (princ (strcat "\nEquipmentColor=" (nth 14 #head$))  #fp) ;2008/08/04 YM MOD

  (princ (strcat "\nWT_Sozai="       (nth 15 #head$))  #fp) ; 2000/08/10 HT ADD
  (princ (strcat "\nWT_zai2="        (nth 16 #head$))  #fp) ; 2000/09/25 HT ADD
  (princ (strcat "\nWT_Sozai2="      (nth 17 #head$))  #fp) ; 2000/09/25 HT ADD
  (princ "\n;;;END\n"                                  #fp)
  (close #fp)

  (princ)
)
;;;SKB_WriteHeadList

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_WriteColorList
;;; <�����T�v>: ���݂̏��i��COLOR�����t�@�C���ɏ����o��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �v�����t�H���_�� COLOR.CFG �ɏ����o���܂�
;;;************************************************************************>MOH<
(defun SKB_WriteColorList (
  /
  #sFname     ; �t�@�C����
  #fp         ; �t�@�C�� �|�C���^
  #COLOR$$    ; ���ް�
  #RollScreen
  #PanelSlim
  #Panel
  #WorkTop
  )
  ; //COLOR���t�@�C����ǂݍ��ވ�U
  (setq #sFname (strcat CG_KENMEI_PATH "COLOR.CFG"))
  (if (findfile #sFname)
    (progn
      (setq #COLOR$$ (ReadIniFile #sFname))
      (setq #RollScreen  (cadr (assoc "RollScreen" #COLOR$$)))
      (setq #PanelSlim   (cadr (assoc "PanelSlim"  #COLOR$$)))
      (setq #Panel       (cadr (assoc "Panel"      #COLOR$$)))
      (setq #WorkTop     (cadr (assoc "WorkTop"    #COLOR$$)))
    )
    (progn;ELSE
      (setq #RollScreen nil)
      (setq #PanelSlim nil)
      (setq #Panel nil)
      (setq #WorkTop nil)
    )
  );END IF

  ; //�O���ϐ��Ƀf�[�^������Γ���ւ���B
  (if CG_RollScreen (setq #RollScreen CG_RollScreen) )
  (if CG_PanelSlim  (setq #PanelSlim CG_PanelSlim) )
  (if CG_Panel      (setq #Panel CG_Panel) )
  (if CG_WorkTop    (setq #WorkTop CG_WorkTop) )

  ; // �w�b�_�[���t�@�C���ւ̏�������
  (setq #fp  (open #sFname "w"))
  (princ ";;; �e�����t�H���_�ɒu��"                               #fp)
  (princ "\n;;;"                                                  #fp)
  (princ "\n;;; CG_RollScreen : ���[���X�N���[��(GV,PH)"          #fp)
  (princ "\n;;; CG_PanelSlim  : �C���e���A�p�l���X����(PH,PV,PW)" #fp)
  (princ "\n;;; CG_Panel      : �C���e���A�p�l��(SH,SV,SW)"       #fp)
  (princ "\n;;; CG_WorkTop    : ���[�N�g�b�v�F(H,X,A,F,S,J,P)"    #fp)
  (princ "\n;;;"                                                  #fp)
  (if #RollScreen
    (princ (strcat "\nRollScreen=" #RollScreen) #fp)
    (princ "\nRollScreen=" #fp)
  )
  (if #PanelSlim
    (princ (strcat "\nPanelSlim=" #PanelSlim) #fp)
    (princ "\nPanelSlim=" #fp)
  )
  (if #Panel
    (princ (strcat "\nPanel=" #Panel) #fp)
    (princ "\nPanel=" #fp)
  )
  (if #WorkTop
    (princ (strcat "\nWorkTop=" #WorkTop) #fp)
    (princ "\nWorkTop=" #fp)
  )
  (princ "\n;;;END\n" #fp)
  (close #fp)

  (princ)
)
;;;SKB_WriteColorList


;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_SetSpecList
;;; <�����T�v>: �z�u���ނ̎d�l�\����ݒ肷��
;;; <�߂�l>  : (SKB_GetSpecList) �̖߂�l�Ɠ���
;;; <���l>    : ���L�O���[�o���ϐ���ݒ�
;;;               CG_DBNAME      : DB����
;;;               CG_SeriesCode  : SERIES�L��
;;;               CG_BrandCode   : �u�����h�L��
;;;************************************************************************>MOH<
(defun SKB_SetSpecList (
  /
  #seri$
  #spec$$
  )

  ;// ���݂̏��i����ݒ�
  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DBNAME      (nth 0 #seri$))  ; DB����
      (setq CG_SeriesCode  (nth 1 #seri$))  ; SERIES�L��
      (setq CG_BrandCode   (nth 2 #seri$))  ; �u�����h�L��
    )
  )
  ;// ���ʃf�[�^�x�[�X�ւ̐ڑ�
  (if (= CG_CDBSESSION nil)
    (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  )
  ;// SERIES�ʃf�[�^�x�[�X�ւ̐ڑ�
  (if (= CG_DBSESSION nil)
    (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  )

  ;// �z�u���ގd�l�����擾
  (princ "\n�z�u���ނ̎d�l�����擾���Ă��܂�...")

  ;// �d�l�\�ڍ׏����擾
  (setq #spec$$ (SKB_GetSpecInfo))

  ;// �d�l�\�ڍ׏����擾
  (setq #spec$$ (SKB_GetSpecList #spec$$))

  ;// �d�l�ԍ��o�_�ɕi�Ԗ��̂�ݒ�
  (SKB_SetBalPten)

  #spec$$
)
;;;SKB_SetSpecList

;;;<HOM>************************************************************************
;;; <�֐���>  : KP_DelPTWF
;;; <�����T�v>: ������"G_PTWF"���폜����
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : 01/11/30 YM ADD
;;;************************************************************************>MOH<
(defun KP_DelPTWF (
  /
	#I #SS
  )
  (setq #ss (ssget "X" '((-3 ("G_PTWF"))))) ; �}�ʏ��WT,FILR��PTEN7�S��
  (if (and #ss (> (sslength #ss) 0))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (entdel (ssname #ss #i))
				(setq #i (1+ #i))
			)
		)
	);_if
	(princ)
);KP_DelPTWF

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_GetSpecInfo
;;; <�����T�v>: �d�l�\�ڍ׏����擾����
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                 1.�A��(1�`)
;;;                 2.�\�[�g�L�[
;;;                 3.���[�N�g�b�v�i�Ԗ���
;;;                 4.�}�`�n���h��
;;;                 5.���͔z�u�p�i�Ԗ���
;;;                 6.�o�͖��̃R�[�h
;;;                 7.�d�l���̃R�[�h
;;;                 8.��
;;;                 9.���z
;;;                10.�i�R�[�h
;;;                11.���ގ�ރt���O (0:�W������ 1:����WT 2:�V��t�B���[ 3:�⑫����)
;;;                12.�W��ID
;;;                13.���@
;;;                14.�|��or��悹�z
;;;               )
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKB_GetSpecInfo (
  /
  #wtlst$$
  #bzlst$$
  #all-lst$$
  #dtlst$$
  #lst$
  #no
  #filer$
  #hosoku$
  #option$
  #SpecInfo$$ #BGLST$$ #KEKOMI$
  )

;//////////////////////////////////////////////////
; �����i�ԂȂ���𑝂₷  ; 02/03/26 YM ADD
;//////////////////////////////////////////////////
		(defun ##MATOME (
			&lis$
			/
			#F #FNEW #HIN #HIN$ #I #KOSU #LOOP #RET$
;-- 2011/12/12 A.Satoh Add - S
			#bunrui
;-- 2011/12/12 A.Satoh Add - E
			)
			(setq #ret$ nil #hin$ nil)
			(foreach #e &lis$
				(setq #hin (nth 1 #e))
				(setq #LR  (nth 3 #e)) ; 02/04/08 YM ADD LR  �ǉ�
				(setq #ko  (nth 6 #e)) ; 02/12/21 YM ADD ���ǉ�
;-- 2011/12/12 A.Satoh Add - S
				(setq #bunrui (nth 11 #e))
				(setq #t_flg (nth 13 #e))
;-- 2011/12/12 A.Satoh Add - E

;-- 2011/12/12 A.Satoh Mod - S
;;;;;				(setq #dum$ (list #hin #LR)) ; 02/12/21 YM ADD
				(setq #dum$ (list #hin #LR #bunrui))
;-- 2011/12/12 A.Satoh Mod - E
				(if (member #dum$ #hin$) ; 02/12/21 YM MOD
;-- 2011/12/12 A.Satoh Add - S
					(if (= #t_flg 0)
;-- 2011/12/12 A.Satoh Add - E
					(progn ; �������̂���
						(setq #loop T #i 0)
						(setq #kosu (length #ret$))
						(while (and #loop (< #i #kosu))
							(setq #f (nth #i #ret$))
							(if (and (= (nth 1 #f) #hin)(= (nth 3 #f) #LR))
								(progn
									(setq #loop nil)
						      (setq #fnew
									 	(CFModList #f
											; 02/12/21 YM MOD-S �P����+1����̂ł͂Ȃ������m��������
							        (list (list 6 (+ #ko (nth 6 #f)))) ; ��+��
											; 02/12/21 YM MOD-E
							      )
									)
								)
							);_if
							(setq #i (1+ #i))
						)
						(setq #ret$ (subst #fnew #f #ret$)) ; �v�f���ւ�
					)
;-- 2011/12/12 A.Satoh Add - S
						(progn
	            (setq #hin$ (append #hin$ (list (list #hin #LR #bunrui)))) ; �i��ؽ�
	            (setq #ret$ (append #ret$ (list #e)))
						)
					)
;-- 2011/12/12 A.Satoh Add - E
					(progn ; ���߂�
;-- 2011/12/12 A.Satoh Mod - S
;;;;;						; 02/12/21 YM MOD-S
;;;;;						(setq #hin$ (append #hin$ (list	(list #hin #LR)))) ; �i��ؽ�
;;;;;						; 02/12/21 YM MOD-E
						(setq #hin$ (append #hin$ (list (list #hin #LR #bunrui))))
;-- 2011/12/12 A.Satoh Mod - E
						(setq #ret$ (append #ret$ (list #e)))
					)
				);_if
			)
			#ret$
		);##MATOME
;//////////////////////////////////////////////////

	; SET�\���m�F����ނ̂Ƃ��͍�}���Ȃ� 01/05/15 YM ADD
  ;// ���[�N�g�b�v�A�V��t�B���[�̎d�l�ԍ��_����}
	(if (= nil CG_SetHIN)
		(progn
			(KP_DelPTWF) ; 01/11/30 YM ADD ������"G_PTWF"���폜����
  		(SKB_MakeWkTopBaloonPoint)
		)
	);_if

  ;// ���[�N�g�b�v�}�`�̂v�s�i�ԏ����������A���[�N�g�b�v���̂��擾
  ;// WT�f��.DB��茻�݂̑f��ID�̏o�͖��̃R�[�h�E�d�l���̃R�[�h���擾
  ;// ���[�N�g�b�v�i�Ԗ��́E�}�`�n���h���E�o�͖��̃R�[�h�E�d�l���̃R�[�h�̈ꗗ�\�쐬
  ;// ���[�N�g�b�v���Q��ވȏ゠��ꍇ�ɂ͊g���f�[�^����WT�^�C�v�̔ԍ��ɕ��בւ�
  ;// �\�[�g�L�[�͂O�A���͔z�u�p�i�Ԗ��͕̂i�Ԗ��̂Ɠ������e�A���͂P���i�[
  (setq #wtlst$$ (SKB_GetWKTopList))

	;#wtlst$$
	;��:((0 "HQSI255H-ALQ-L" "2550" "40" "650" "���ڽSLį�� I �^ D650 H     �@�k" 1 126000.0 "A10" ("4C27")))

  ;// �z�u�ςݕ��ނ̍H��L���ESERIES�L���E�i�Ԗ��́E�k�^�q�敪���i�Ԑ}�`.DB������
  ;// �i�Ԗ��́E���͔z�u�p�i�Ԗ��́E�}�`�n���h���̈ꗗ�\���쐬
  ;// �������A���͔z�u�p�i�Ԗ��̂�����̏ꍇ�͂P�s�ɂ܂Ƃ߂Č��{�P
  (setq #bzlst$$ (SKB_GetBuzaiList))

	;#bzlst$$
	;�� ("H$030WFB-7%#-@@[J:BW]" "L" ("4937") 1 "0")

  (if #bzlst$$
		(progn
    ;// �ꗗ�\�̕i�Ԗ��̂ƍH��L���ESERIES�L�����L�[�ɂ��ĕi�Ԋ�{.DB������
    ;// �\�[�g�L�[�E�o�͖��̃R�[�h�E�d�l���̃R�[�h���擾���Ĉꗗ�\�ɒǉ�
    (setq #dtlst$$ (SCB_GetDetailList #bzlst$$))

    ;// �ꗗ�\�쐬��A�W��ID����у\�[�g�L�[�ŏ����ɕ��ёւ�

		; �ꗗ�\�쐬��A��1key=�W��ID(nth 10),��2key=�i�Ԋ�{.��ķ�(nth 0)�ŏ����ɕ��ёւ�
		(if #dtlst$$
    	(setq #dtlst$$ (ListSortLevel2 #dtlst$$ 10 0))
		);_if

  ))

	;#dtlst$$
	;��:(1011 "H$090S2A-JN#-@@[J:BW]" ("426D") "Z" 0 0 1 0 "xxxxxxx" "0" "A20")

  ;// ���[�N�g�b�v�ꗗ�ɕ��ވꗗ��ǉ�
  (setq #all-lst$$ (append #wtlst$$ #dtlst$$))


	;#bzlst$$
	;�� ("H$030WFB-7%#-@@[J:BW]" "L" ("4937") 1 "0")

  ;// �t�B���[�֘A�̎d�l����ǉ�
  (if (/= nil (setq #filer$ (SKB_GetFillerInfo)))
    (setq #all-lst$$ (append #all-lst$$ #filer$))
  )
	;#filer$
	;��: ((2046 "HSCM240R-@@" ("4E76") "Z" 0 0 1 0 "xxxxxxx" "2" "A60"))

  ;// �ǉ����ނ̎d�l����ǉ�
  (if (/= nil (setq #hosoku$ (SKB_GetHosokuInfo)))
    (setq #all-lst$$ (append #all-lst$$ #hosoku$))
  )

  ;// �I�v�V�����A�C�e���̎d�l����ǉ�
  (if (/= nil (setq #option$ (SKB_GetOptionInfo)))
    (setq #all-lst$$ (append #all-lst$$ #option$))
  )
	(setq #all-lst$$ (##MATOME #all-lst$$))

  ;// �ꗗ�\�쐬��A�W��ID����у\�[�g�L�[�ŏ����ɕ��т�
  (if #all-lst$$
		; �ꗗ�\�쐬��A��1key=�W��ID(nth 10),��2key=�i�Ԋ�{.��ķ�(nth 0)�ŏ����ɕ��ёւ�
    (setq #all-lst$$ (ListSortLevel2 #all-lst$$ 10 0))
  )

	;2011/04/25 YM ADD ���ʎw��Ή�  �����W��ID(nth 10),��ķ�(nth 0)�̏ꍇ,�i�Ԗ���(nth 1)�ſ�Ă���
	(if #all-lst$$
		(setq #all-lst$$ (LisSortHin #all-lst$$ 10 0 1))
	)

  (setq #SpecInfo$$ nil)
  (setq #no 1)

  ;//  �d�l�\��񃊃X�g���O���[�o���ɐݒ�
  (foreach #lst$ #all-lst$$
    (setq #SpecInfo$$ (append #SpecInfo$$ (list (cons #no #lst$))))
    (setq #no (1+ #no))
  )

  ;// �d�l�\���
  #SpecInfo$$
);SKB_GetSpecInfo



;;;<HOM>************************************************************************
;;; <�֐���>  : LisSortHin
;;; <�����T�v>: ;�����W��ID,��ķ��̏ꍇ,�i�Ԗ��̂ſ�Ă���
;;; <�߂�l>  : ��Č��ؽ�
;;; <���l>    : 
;;;             2011/04/25 YM ADD
;;;************************************************************************>MOH<
(defun LisSortHin (
  &Lst$$ ; �d�l��񃊃X�g
	&KEY1  ; ��1KEY(nil�s��)
	&KEY2  ; ��2KEY(nil�s��)
	&KEY3  ; ��2KEY(nil�s��)
  /
	#DUM$$ #LST$$ #RSLT$$ #SID1 #SID2 #SRT1 #SRT2
  )
;;;����
;;;(
;;; (2021 "R$90S0B-MN#-@@[RS:G:D]" ("45D67") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (2021 "R$90S0B-MN#-@@[RP:G:D]" ("46040") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (2021 "R$90S0B-MN#-@@[RJ:MB:D]" ("4631C") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (3003 "R$90NHB-MN#-@@[RS:G:D]" ("45DE5") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (3003 "R$90NHB-MN#-@@[RP:G:D]" ("460BE") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (3003 "R$90NHB-MN#-@@[RJ:MB:D]" ("4639A") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (4007 "R$90UHB-MN#-@@[RJ:MB:D]" ("46408") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (4007 "R$90UHB-MN#-@@[RP:G:D]" ("4612C") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (4007 "R$90UHB-MN#-@@[RS:G:D]" ("45E53") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;;)

	(setq #Lst$$ &Lst$$)

	(setq #dum$$ (list (car #Lst$$))) ;�ŏ���ؽ�
  (setq #srt1 (nth &KEY2 (car #Lst$$)));��ķ�
  (setq #sid1 (nth &KEY1 (car #Lst$$)));�W��ID

  (foreach #Lst$ (cdr #Lst$$)
    (setq #srt2 (nth &KEY2 #Lst$));��ķ�
    (setq #sid2 (nth &KEY1 #Lst$));�W��ID

    (if (and (= #srt1 #srt2)(= #sid1 #sid2))
			(progn
      	(setq #dum$$ (append #dum$$ (list #Lst$)))
			)
			;else
      (progn
				(setq #dum$$ (CFListSort #dum$$ &KEY3));�i�Ԃſ�Ă���
        (setq #rslt$$ (append #rslt$$ #dum$$))
        (setq #dum$$ (list #Lst$))
        (setq #srt1 #srt2)
        (setq #sid1 #sid2)
      )
    );_if
  )
  (if (/= #dum$$ nil)
    (setq #rslt$$ (append #rslt$$ (CFListSort #dum$$ &KEY3))) ;�i�Ԃſ�Ă���
  );_if

	#rslt$$
);LisSortHin




;;;<HOM>************************************************************************
;;; <�֐���>  : ListSortLevel2
;;; <�����T�v>: ؽĂ�ؽĂ��2KEY(nth ? �̔ԍ��Ŏw��)�܂Ŏw�肵�Ŀ��
;;; <�߂�l>  : ��Č��ؽ�
;;; <���l>    : nth 10 �W��ID , nth 0 �i�Ԋ�{.��ķ�
;;;             �֐�SCB_SortDetailList �̈�ʉ� 01/02/02 YM
;;;************************************************************************>MOH<
(defun ListSortLevel2 (
  &Lst$$ ; �d�l��񃊃X�g
	&KEY1  ; ��1KEY(nil�s��)
	&KEY2  ; ��2KEY(nil�s��)
  /
	#DUM$$ #ID1 #ID2 #LST$$ #RSLT$$
  )
	(if (= (type &KEY1) 'INT)
		(progn
		  ;// ��1KEY�Ń\�[�g����
		  (setq #Lst$$ (CFListSort &Lst$$ &KEY1))
		  (setq #id1 (nth &KEY1 (car #Lst$$)))
		  (setq #dum$$ (list (car #Lst$$)))
		  (foreach #Lst$ (cdr #Lst$$)
		    (setq #id2 (nth &KEY1 #Lst$))
		    (if (= #id1 #id2)
		      (setq #dum$$ (append #dum$$ (list #Lst$)))
		      (progn
		        ;// ��2KEY�Ń\�[�g����
						(if (= (type &KEY2) 'INT)(setq #dum$$ (CFListSort #dum$$ &KEY2)))
		        (setq #rslt$$ (append #rslt$$ #dum$$))
		        (setq #dum$$ (list #Lst$))
		        (setq #id1 #id2)
		      )
		    );_if
		  )
		  (if (/= #dum$$ nil)
		    (setq #rslt$$ (append #rslt$$
					(if (= (type &KEY1) 'INT)
						(CFListSort #dum$$ &KEY2)
						#dum$$
					)
				))
		  );_if
		)
		(setq #rslt$$ &Lst$$)
	);_if
  #rslt$$
);ListSortLevel2

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_SetBalPten
;;; <�����T�v>: �d�l�ԍ��o�_�ɕi�Ԗ��̂�ݒ肷��
;;; <�߂�l>  :
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKB_SetBalPten (
  /
	#CABANG #DOORANG #EG$ #EN #HIN #I #P-EN #PRICE #QRY$ #SS #TOKU$
	#VECTOR #XD$ #XDOPT$ #XDPTEN$ #ZOKU #ZOKU2 #HINBAN #LR_OYA #NEWHINBAN
	#DRCOLCODE #OPT2$$ #XDOPT2$
#org_hin ;2018/10/25 YM ADD-S
  )
  (setq CG_FuncName "\nSKB_SetBalPten")

  ;// �}�ʏ�̂o�_��S�Ď擾
  (setq #ss (ssget "X" '((-3 ("G_PTEN")))))
  (setq #i 0)
  (if #ss ;00/08/01 SN ADD
  (repeat (sslength #ss)
    (setq #p-en (ssname #ss #i))
		(setq #xdPTEN$ (CFGetXData #p-en "G_PTEN")) ; 01/04/05 YM #xdPTEN$ �ǉ�
    ;// �d�l�ԍ��̂o�_�݂̂ɍi�荞��
    (if (= (car #xdPTEN$) CG_BALOONTYPE) ; 01/04/05 YM �ǉ�
      (progn
        ;// �o�_�̐e�}�`�iG_LSYM,G_WTSET,G_FILR)�̐}�`���擾����
        (setq #en (SKC_GetSymInGroup #p-en)) ; �e�}�`�����(���ꂩ��G_OPT���擾)

				(if (and #en (CFGetXData #en "G_LSYM"))
					(progn
						; ��`�s��PTEN7��entmod����(�w�ʗp�Ȃ̂ɉ����o�����������ʂ������Ă������)
						; 01/05/02 YM ADD STRAT ----------------------------------------------------
						(setq #CABang (nth 2 (CFGetXData #en "G_LSYM"))) ; ���ޔz�u�p�x
						(setq #eg$ (entget #p-en))
						(if (= "04" (substr (cdr (assoc 8 #eg$)) 3 2))
							(progn ; �w�ʗp������
								(setq #vector (cdr (assoc 210 #eg$))) ; PTEN7�����o������
								(setq #DoorANG (angle '(0 0 0) #vector)) ; ���@���޸�ق̌���
								(setq #DoorANG (Angle0to360 #DoorANG)) ; 0�`360�x�̒l�ɂ���

								(if (equal (Angle0to360 (+ #CABang (dtr 90))) #DoorANG 0.001) ; PTEN7����������`����Ă��邩
									nil ; �������Ȃ�

									(entmod ; PTEN7�s��==>entmod
										(subst
											(cons 210	(polar '(0 0 0) (Angle0to360 (+ #CABang (dtr 90))) 100))
											(assoc 210 #eg$)
											#eg$
										)
									)

								);_if

							)
						);_if
					)
				);_if
				; 01/05/02 YM ADD END ----------------------------------------------------

        ;// �i�Ԗ��̂��擾����
        (if (/= nil #en)
          (progn
            (cond
;-- 2011/12/12 A.Satoh Add - S
							((/= nil (setq #xd_TOKU$ (CFGetXData #en "G_TOKU")))	; ��������
								(setq #xd$ (CFGetXData #en "G_LSYM"))
							  (setq #qry$
								  (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
								    (list
                      (list "�i�Ԗ���"        (nth  5 #xd$)  'STR)
                      (list "LR�敪"          (nth  6 #xd$)  'STR)
                      (list "�p�r�ԍ�" (rtois (nth 12 #xd$)) 'INT)
								    )
								  )
								)

							  (if (and #qry$ (= 1 (length #qry$)))
								  (progn
										(setq #qry$ (car #qry$))
										(setq #DRColCode  (nth 7 #xd$)) ; "��ذ��,��װ�L��"

										(if (and (/= #DRColCode nil)(/= #DRColCode ""))
											(progn
												(if (and #DRColCode (vl-string-search "," #DRColCode))
													(progn
														(setq #DRColCode (CMN_string-subst "," ":" #DRColCode))
														(setq #hin (strcat (nth 0 #xd_TOKU$) "[" #DRColCode "]"))
													)
													(progn
														(setq #hin (nth 0 #xd_TOKU$))
													)
												)
											)
											(progn
												(setq #hin (nth 0 #xd_TOKU$))
											)
										)

										;2018/10/25 YM MOD-S �����i�Ԃ̌��i�Ԃ�(%)�t���i�Ԃ̂Ƃ��̑Ή� @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
										;(%)�t���i�Ԃ́AL/R����Ƃ���MDB�o�^����邪�A(%)���O�����i�Ԃ�%���Ȃ����LR=Z�Ƃ݂Ȃ��ď��������Ȃ���ΓW�J�ԍ������܂����Ȃ�
		                (if (or (= "R" (nth 1 #qry$))(= "L" (nth 1 #qry$)));2018/10/25 YM MOD-S �����i�Ԃ̌��i�Ԃ�(%)�t���i�Ԃ̂Ƃ��̑Ή�
											(progn
												(setq #org_hin (nth 10 #xd_TOKU$))
												;2018/10/25 YM MOD �i�Ԃ�%���܂�ł��Ȃ�������"Z"����
								        (if (vl-string-search "%" (KP_DelHinbanKakko #org_hin)); ()�O����"%"�L������
		                  		(setq #hin (strcat #hin (nth 1 #qry$))) ; LR�𖖔���
													;else
													nil
												);_if
;;;		                  	(setq #hin (strcat #hin (nth 1 #qry$)));2018/10/25 YM MOD ; LR�𖖔���
											)
											;else
		                  nil
		                )

										(setq #hnd  (cdr (assoc 5 (entget #en))))
										(setq #hin (strcat #hin #hnd))
									)
								)
							)
;-- 2011/12/12 A.Satoh Add - E
              ((/= nil (setq #xd$ (CFGetXData #en "G_LSYM")))  ;���ސݔ�


							  (setq #qry$
								  (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
								    (list
                      (list "�i�Ԗ���"        (nth  5 #xd$)  'STR)
                      (list "LR�敪"          (nth  6 #xd$)  'STR)
                      (list "�p�r�ԍ�" (rtois (nth 12 #xd$)) 'INT)
								    )
								  )
								)

							  (if (and #qry$ (= 1 (length #qry$)))
								  (progn
										(setq #qry$ (car #qry$))

;;;										(if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
;;;											(progn ; ���ނ̂Ƃ�
										(setq #DRColCode  (nth 7 #xd$)) ; "��ذ��,��װ�L��"

										;2011/06/15 YM MOD �����ύX
										(if (and (/= #DRColCode nil)(/= #DRColCode ""))
											(progn
												; 01/11/01 YM MOD ","���܂܂�邩�ǂ�������
												(if (and #DRColCode (vl-string-search "," #DRColCode))
													(progn ; ����","���܂܂�Ă�����

														(setq #DRColCode (CMN_string-subst "," ":" #DRColCode))
														(setq #hin (strcat (nth 0 #qry$) "[" #DRColCode "]"))
													)
													(progn
														(setq #hin (nth 0 #qry$)) ; 01/11/07 YM ADD ����=nil �̏ꍇ�������Ă���(����PTEN�ɑO�̕i�Ԃ�o�^�����ݕs��)
													)
												);_if
											)
											(progn
												(setq #hin (nth 0 #qry$)) ; 01/11/05 YM ADD ���ވȊO�̂Ƃ��������Ă���-->�����o�����s��
											)
										);_if

		                (if (or (= "R" (nth 1 #qry$))(= "L" (nth 1 #qry$)))
											(progn
												;2018/01/09 YM ADD �i�Ԃ�%���܂�ł��Ȃ�������"Z"����
												
								        (if (vl-string-search "%" (KP_DelHinbanKakko #hin));()�O����"%"�L������
;;;													(setq #LR 1);L/R����
		                  		(setq #hin (strcat #hin (nth 1 #qry$))) ; LR�𖖔���
													;else
;;;													(setq #LR 0);L/R�Ȃ�
													nil
												);_if

											)
											;else
											(progn
		                  	nil ; ���̂܂�
											)
		                );_if
									 	; 01/10/30 YM MOD-E

									)
								);_if

;;;										; 01/03/10 YM ADD �������ނ������� "ĸ"�i��@���i
;;;										(if (setq #TOKU$ (CFGetXData #en "G_TOKU"))
;;;											(progn
;;;												(setq #price (itoa (fix (+ (nth 1 #TOKU$) 0.001))))
;;;										;;;										(setq #hin (strcat "ĸ" #hin "@" #price)) ; 01/05/17 YM MOD
;;;												(setq #hin (strcat (nth 0 #TOKU$) "@" #price)) ; 01/05/17 YM MOD
;;;											)
;;;										);_if
;;;							  	)
;;;									(setq #hin "DUM")
;;;							  );_if

              )
              ((/= nil (setq #xd$ (CFGetXData #en "G_WTSET")))     ;���[�N�g�b�v
                (setq #hin (nth 1 #xd$))
              )
              ((/= nil (setq #xd$ (CFGetXData #en "G_FILR")))      ;�V��t�B���[
                (setq #hin (nth 0 #xd$))
              )
            );_cond


						; 01/12/03 YM ADD-S �i�ԂɊ܂܂��()���폜����
						(if #hin ;03/12/10 YM ADD WT�i�Ԋm�肵�Ă��Ȃ��ƌ��Ϗ��쐬�ŗ�����
							(setq #hin (KP_DelHinbanKakko #hin))
							;else
							(setq #hin "")
						);_if
						; 01/12/03 YM ADD-E

						; 01/07/19 MOD ��߼�ݕi���������Ȃ����� START
						(setq #zoku  (nth 2 #xdPTEN$))
						(setq #zoku2 (1- (* 2 #zoku)))
						(if	(= 0 #zoku)
            	(CFSetXData #p-en "G_PTEN" (list 7 #hin 0)) ; ���܂Œʂ�
							(progn ; ����ȊO
								(if (and (setq #xdOPT$ (CFGetXData #en "G_OPT")) ; ��߼�ݕi����������
												 (nth #zoku2 #xdOPT$))
									(progn
										(setq #hinban (nth #zoku2 #xdOPT$)) ; "ĸFP-2C10-75"�Ȃ�

										; 03/06/18 YM ADD ��߼�ݓ�������� "G_OPT2"�Q��
										(setq #xdOPT2$ (CFGetXData #en "G_OPT2")) ; nil ���肦��
										(setq #opt2$$ (KP_GetOpt2Info #xdOPT2$)) ; #xdOPT2$==>(�����i��,���i��,���z,SET�i�׸�)��ؽ�(nil����)
										(if #opt2$$ ; nil ���肦��
											(progn
												(if (assoc #hinban #opt2$$)
													(progn
														(setq #price (nth 2 (assoc #hinban #opt2$$)))
														(setq #hinban (strcat #hinban "@" #price))
													)
												);_if
											)
										);_if


										(setq #newhinban (KP_GetOPTnewHINBAN #hinban #en))    ; OPT�i��+�e�����+�eLR-->�V�i��
		            		(CFSetXData #p-en "G_PTEN" (list 7 #newhinban #zoku)) ; #zoku�ڂ̵�߼�ݕi���
									)
		            	(CFSetXData #p-en "G_PTEN" (list 7 #hin #zoku)) ; ���܂Œʂ�
								);_if
							)
						);_if
						; 01/07/19 MOD ��߼�ݕi���������Ȃ����� END
          )
        );_if
      )
    )
    (setq #i (1+ #i))
  )
  );end if 00/08/01 SN ADD
);SKB_SetBalPten

;;;<HOM>************************************************************************
;;; <�֐���>  : KP_GetOPTnewHINBAN
;;; <�����T�v>: ��߼�ݕi�Ԃ�LR�敪������ΐe�i�Ԃ�LR�𖖔��ɂ��ĕԂ�
;;; <�߂�l>  : ��߼�ݕi�ԕ�����
;;;             01/07/19 YM
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun KP_GetOPTnewHINBAN (
	&hinbanOPT ; ��߼�ݕi��
	&sym       ; �e����ِ}�`
  /
	#QRY$ #RET #LR_OYA
  )
	(setq #LR_oya (nth 6 (CFGetXData &sym "G_LSYM"))); �e�}�`��LR
  (setq #qry$
    (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" &hinbanOPT
    (list (list "�i�Ԗ���" &hinbanOPT 'STR))))
  )
	(if (and #qry$ (= 1 (nth 1 #qry$))) ; LR�敪����ΐe�}�`��LR��t����
		(setq #ret (strcat &hinbanOPT #LR_oya))
		(setq #ret &hinbanOPT)
	);_if
	#ret
);KP_GetOPTnewHINBAN

;;;<HOM>************************************************************************
;;;<�֐���>   : SKB_GetSpecList
;;; <�����T�v>: �d�l�\�����擾����
;;; <�߂�l>  : Table.cfg�ɏo�͂���ؽ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKB_GetSpecList (
  &SpecInfo$$ ; (LIST)�d�l�\���
  /
	#DDD #HANDLE #HHH #HINMEI #I #INFO$ #KAKAKU #KOSU #LAST_HIN #LAST_REC$ #LR 
	#LRCD #NAME #NAME1 #SHINBAN #SORT_KEY #SPECLIST$ #SPECLIST$$ #SYUYAKU_ID #TENKAI_ID #WWW
#DoorInfo$ #DRHINBAN ;2011/04/23 YM ADD
#Toku_CD #Toku_FLG #xd_TOKU$	;-- 2011/12/12 A.Satoh Add
  )

  (setq #SpecList$$ nil)
  (setq #i 1)
  (foreach #info$ &SpecInfo$$

    (if (< (nth 1 #info$) 10);�\�[�g�L�[��10�ȉ��Ȃ�V�Ƃ݂Ȃ�
      ; ���[�N�g�b�v�̏ꍇ
			(progn
				(setq #SORT_KEY   (nth 1 #info$))
				(setq #LAST_HIN   (nth 2 #info$))
				(setq #WWW        (nth 3 #info$))
				(setq #HHH        (nth 4 #info$))
				(setq #DDD        (nth 5 #info$))
				(setq #HINMEI     (nth 6 #info$))
				(setq #KOSU       (nth 7 #info$))
				(setq #KAKAKU     (nth 8 #info$))
				(setq #SYUYAKU_ID (nth 9 #info$))
				(setq #HANDLE     (nth 10 #info$))
				(setq #sHinban    #LAST_HIN)
				(setq #LR         "")
				(setq #drHinban   #sHinban)
;-- 2011/12/12 A.Satoh Add - S
				(setq #Tenkai_ID -1)
        (setq #Toku_CD    (nth 13 #info$))
				(setq #Toku_FLG   (nth 14 #info$))
;-- 2011/12/12 A.Satoh Add - E
			)
			(progn
				(setq #SORT_KEY   (nth 1 #info$))
				(setq #sHinban    (nth 2 #info$));CAD�i��
				(setq #drHinban #sHinban);[]�t���i��

				;2011/04/23 YM ADD-S
				;�����ŕ��ނ��Ƃ̔���񂪂���Ύ擾����
				(setq #DoorInfo$ (KP_GetSeriStr #sHinban));���ڰ��,���F,�����ؽ�

				;2011/06/17 YM MOD-S
				(setq #sHinban    (KP_DelDrSeriStr #sHinban))
				(if (= #DoorInfo$ nil)(setq #drHinban #sHinban))
				;2011/06/17 YM MOD-E

				(setq #HANDLE     (nth 3 #info$))
				(setq #LR         (nth 4 #info$))
				(setq #SYUYAKU_ID (nth 11 #info$))
				(setq #KOSU       (nth 7 #info$));???
				(setq #Tenkai_ID (GetTenkaiID #sHinban));������Ԃ�

				;2011/06/03 YM ADD-S
				(if (or (= #LR "L")(= #LR "R"))
					(setq #drHinban (strcat #drHinban #LR))
				);_if

;-- 2011/12/12 A.Satoh Add - S
        (setq #Toku_CD    (nth 13 #info$))
				(setq #Toku_FLG   (nth 14 #info$))

				(if (= #Toku_FLG 1)
					(setq #drHinban (strcat #drHinban (car #HANDLE)))
				)
;-- 2011/12/12 A.Satoh Add - E
							 
				(cond
					((= #Tenkai_ID 0)
						;�i�ԍŏI������
						(if #DoorInfo$
							(progn ;�����(���ڰ��,���F,����)������ΐ�p����
							 	;�i��,LR,���,���,˷�
								(setq #Last_Rec$ (GetLast_Rec_DoorInfo #sHinban #LR #DoorInfo$));�i�ԍŏI��ں��ނ�Ԃ�
							)
							(progn
							 	;�i��,LR,���,���,˷�
								(setq #Last_Rec$ (GetLast_Rec #sHinban #LR 0));�i�ԍŏI��ں��ނ�Ԃ�
							)
						);_if
				 	)
					((= #Tenkai_ID 1)
					 	;�i��,LR
					 	(setq #Last_Rec$ (GetLast_Rec #sHinban #LR 1));�i�ԍŏI��ں��ނ�Ԃ�
				 	)
					((= #Tenkai_ID 2)
					 	;�i��,LR,�޽��
						(setq #Last_Rec$ (GetLast_Rec #sHinban #LR 2));�i�ԍŏI��ں��ނ�Ԃ�
				 	)
					((= #Tenkai_ID nil)
					 	;ERROR
						(setq #Last_Rec$ nil)
				 	)
				);_cond

				(if #Last_Rec$
					(progn
						(setq #LAST_HIN   (nth 10 #Last_Rec$))
						(setq #WWW        (nth 11 #Last_Rec$))
						(setq #HHH        (nth 12 #Last_Rec$))
						(setq #DDD        (nth 13 #Last_Rec$))
						(setq #HINMEI     (nth 14 #Last_Rec$))
						(setq #KAKAKU     (nth  8 #Last_Rec$))
					)
					(progn
;-- 2011/12/12 A.Satoh Add - S
						(if (= #Toku_FLG 1)
							(progn
								(setq #xd_TOKU$ (CFGetXData (handent (car #HANDLE)) "G_TOKU"))
								(if #xd_TOKU$
									(progn
				            (setq #LAST_HIN   (nth 0 #xd_TOKU$))
        				    (setq #WWW        (itoa (fix (nth 4 #xd_TOKU$))))
				            (setq #HHH        (itoa (fix (nth 5 #xd_TOKU$))))
        				    (setq #DDD        (itoa (fix (nth 6 #xd_TOKU$))))
				            (setq #HINMEI     (nth 2 #xd_TOKU$))
        				    (setq #KAKAKU     (nth 1 #xd_TOKU$))
									)
									(progn
				            (setq #LAST_HIN   "")
        				    (setq #WWW        "")
				            (setq #HHH        "")
        				    (setq #DDD        "")
				            (setq #HINMEI     "")
        				    (setq #KAKAKU     "")
									)
								)
							)
							(progn
;-- 2011/12/12 A.Satoh Add - E
						(setq #LAST_HIN   "")
						(setq #WWW        "")
						(setq #HHH        "")
						(setq #DDD        "")
						(setq #HINMEI     "")
						(setq #KAKAKU     "")
;-- 2011/12/12 A.Satoh Add - S
							)
						)
;-- 2011/12/12 A.Satoh Add - E
					)
				);_if

			)
		);_if

  	;// �d�l�\��񃊃X�g���쐬����
    (setq #SpecList$
      (list
				(itoa #i)   ;���הԍ�
				#LAST_HIN   ;�ŏI�i��
				#WWW        ;��
				#HHH        ;����
				#DDD        ;���s
				#HINMEI     ;�i��
				#KOSU       ;��
				#KAKAKU     ;���i
;-- 2011/12/12 A.Satoh Mod - S
;;;;;				#SYUYAKU_ID ;�W��ID
;;;;;				#sHinban    ;CAD�i��
;;;;;				#LR         ;LR�敪
;;;;;				#drHinban   ;[]�t���i��
        #bunrui     ;����
        #SYUYAKU_ID ;�W��ID
				#Tenkai_ID	; �W�J�^�C�v
        #sHinban    ;CAD�i��
        #LR         ;LR�敪
				#drHinban   ;[]�t���i��
				#Toku_CD		;�����R�[�h
				#Toku_FLG		;�����t���O
;-- 2011/12/12 A.Satoh Mod - E
      )
    )
    (setq #SpecList$$ (append #SpecList$$ (list #SpecList$)))

		(setq #i (1+ #i))
	);foreach

  ;// �d�l�\���X�g��Ԃ�
  #SpecList$$
)
;;;SKB_GetSpecList

;;;<HOM>************************************************************************
;;; <�֐���>  : GetLast_Rec_DoorInfo
;;; <�����T�v>: [�i�ԍŏI]����������redord���擾
;;; <�߂�l>  : redord
;;;             2011/04/23 YM ADD
;;; <���l>    : �W�J����=0�݂̂�z��
;;;************************************************************************>MOH<
(defun GetLast_Rec_DoorInfo (
  &hinban
	&LR
	&DoorInfo$ ;�����(���ڰ��,���F,����)
  /
	#QRY$ #RET
  )
	(if (= nil &DoorInfo$)
		(setq &DoorInfo$ (list "" "" ""))
	);_if

 	;�i��,LR,���,���,˷�
	(setq #qry$
	 	(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
			(list
				(list "�i�Ԗ���"               &hinban 'STR)
				(list "LR�敪"                 &LR     'STR)
				(list "���V���L��" (nth 0 &DoorInfo$)  'STR)
				(list "���J���L��" (nth 1 &DoorInfo$)  'STR)
				(list "����L��"   (nth 2 &DoorInfo$)  'STR)
			)
		)
	)
 	(if (= nil #qry$)
		(progn ;�݌˂̏ꍇ˷ËL���Ȃ��Ō������Ȃ���΂����Ȃ�
		 	;�i��,LR,���,���,˷�
			(setq #qry$
			 	(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"               &hinban 'STR)
						(list "LR�敪"                 &LR     'STR)
						(list "���V���L��" (nth 0 &DoorInfo$)  'STR)
						(list "���J���L��" (nth 1 &DoorInfo$)  'STR)
					)
				)
			)
		)
	);_if
 	(if (= nil #qry$)
		(progn ;�݌˂̏ꍇ˷ËL���Ȃ��Ō������Ȃ���΂����Ȃ�
		 	;�i��,LR,���,���,˷�
			(setq #qry$
			 	(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"               &hinban 'STR)
						(list "LR�敪"                 &LR     'STR)
					)
				)
			)
		)
	);_if
		 
	(if (and #qry$ (= (length #qry$) 1))
		(progn ;1��HIT
			(setq #ret (car #qry$))
		)
		(progn
			(setq #ret nil)
		)
	);_if
	#ret
);GetLast_Rec_DoorInfo


;;;<HOM>************************************************************************
;;; <�֐���>  : GetLast_Rec
;;; <�����T�v>: [�i�ԍŏI]����������redord���擾
;;; <�߂�l>  : redord
;;;             2008/08/07 YM ADD
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun GetLast_Rec (
  &hinban
	&LR
	&Tenaki_ID ;0,1,2
  /
	#QRY$ #RET #GAS
  )

;;;	(setq CG_DRSeriCode (nth 62 CG_GLOBAL$))
;;;	(setq CG_DRColCode  (nth 63 CG_GLOBAL$))
;;;	(setq CG_Hikite     (nth 64 CG_GLOBAL$))

	(cond
		((= &Tenaki_ID 0)
		 	;�i��,LR,���,���,˷�
			(setq #qry$
			 	(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"               &hinban 'STR)
						(list "LR�敪"                 &LR     'STR)
						(list "���V���L��" CG_DRSeriCode 'STR);2008/09/12 YM MOD ���[�Ή�
						(list "���J���L��" CG_DRColCode  'STR);2008/09/12 YM MOD ���[�Ή�
						(list "����L��"   CG_Hikite     'STR);2008/09/12 YM MOD ���[�Ή�
					)
				)
			)
		 	(if (= nil #qry$)
				(progn ;�݌˂̏ꍇ˷ËL���Ȃ��Ō������Ȃ���΂����Ȃ�
				 	;�i��,LR,���,���,˷�
					(setq #qry$
					 	(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
							(list
								(list "�i�Ԗ���"               &hinban 'STR)
								(list "LR�敪"                 &LR     'STR)
								(list "���V���L��" CG_DRSeriCode 'STR);2008/09/12 YM MOD ���[�Ή�
								(list "���J���L��" CG_DRColCode  'STR);2008/09/12 YM MOD ���[�Ή�
							)
						)
					)
				)
			);_if
		 	(if (= nil #qry$)
				(progn ;�݌˂̏ꍇ˷ËL���Ȃ��Ō������Ȃ���΂����Ȃ�
				 	;�i��,LR,���,���,˷�
					(setq #qry$
					 	(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
							(list
								(list "�i�Ԗ���"               &hinban 'STR)
								(list "LR�敪"                 &LR     'STR)
							)
						)
					)
				)
			);_if
	 	)
		((= &Tenaki_ID 1)
		 	;�i��,LR
			(setq #qry$
			 	(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"               &hinban 'STR)
						(list "LR�敪"                 &LR     'STR)
					)
				)
			)
	 	)
		((= &Tenaki_ID 2)
		 	;�i��,LR,�޽��
			;2010/11/08 YM ADD-S �W�J�}�쐬�ŗ�����

;2014/05/29 YM DEL �K�X��̓O���[�o��������
;;;		 	(if CG_GLOBAL$
;;;				(setq #GAS (nth 24 CG_GLOBAL$))
;;;				;else
				(setq #GAS CG_GasType);�Ō�����݌�����������
;;;			);_if

			;2010/11/08 YM ADD-E

			(setq #qry$
			 	(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"               &hinban 'STR)
						(list "LR�敪"                 &LR     'STR)
;2010/11/08 YM MOD-S
;;;						(list "�K�X��"     (nth 24 CG_GLOBAL$) 'STR)
						(list "�K�X��"     #GAS                'STR)
;2010/11/08 YM MOD-E
					)
				)
			)
	 	)
		(T ;����ȊO
			(setq #qry$ nil)
	 	)
	);_cond
		 
	(if (and #qry$ (= (length #qry$) 1))
		(progn ;1��HIT
			(setq #ret (car #qry$))
		)
		(progn
			(setq #ret nil)
		)
	);_if

	#ret
);GetLast_Rec



;;;<HOM>************************************************************************
;;; <�֐���>  : GetTenkaiID
;;; <�����T�v>: [�i�Ԋ�{]���������ēW�JID���擾
;;; <�߂�l>  : �W�JID
;;;             2008/08/07 YM ADD
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun GetTenkaiID (
  &hinban
  /
	#QRY$ #RET
  )
	(setq #qry$
	 	(CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
			(list
				(list "�i�Ԗ���" &hinban 'STR)
			)
		)
	)
	(if (and #qry$ (= (length #qry$) 1))
		(progn ;1��HIT
			(setq #ret (nth 4 (car #qry$)))  ;����
			(setq #ret (fix (+ #ret 0.0001)));����
		)
		;else
		(setq #ret nil)
	);_if
	#ret
);GetTenkaiID

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKResetWTSETdim$
;;; <�����T�v>  : WT�ގ�����WT�i�������߂�
;;; <����>      : WT�ގ�
;;; <�߂�l>    : WT�i��
;;; <�쐬��>    : 03/01/28 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KPGetWTHinmei (
	&zai ; WT�ގ�
  /
	#NAME #QRY$ #SQL
  )
  (setq #sql (strcat "select * from WT�ގ� where �ގ��L��='" &zai "'"))
  (setq #qry$ (DBSqlAutoQuery CG_DBSESSION #sql))
	(setq #qry$ (DBCheck #qry$ "�wWT�ގ��x" "KPGetWTHinmei"))
  (setq #name (strcat (nth 4 #qry$) SKW_WT_NAME));2008/07/29 YM MOD
	#name
);KPGetWTHinmei

;<HOM>*************************************************************************
; <�֐���>    : SKB_MakeBalNo
; <�����T�v>  : �o���[���ԍ����쐬�z�u����
; <�߂�l>    :
; <�쐬>      : 2000-01-12
; <���l>      :
;*************************************************************************>MOH<
(defun SKB_MakeBalNo (
    &en    ;(ENAME)�_�̐}�`��
    &no    ;(STR)�\������
    /
    #en
    #eg #eg2 #gnam
    #pt1 #pt2
    #210 #300 #330
    #cir
    #ss
    #lay
    #z
  )

  (setq #ss (ssadd))
  (setq #eg (entget &en))
  (setq #330 (cdr (assoc 330 #eg)))
  (setq #eg2 (entget #330))
  (setq #gnam (SKGetGroupName &en))

  (setq #pt1 (cdr (assoc 10 #eg)))
  (setq #lay (cdr (assoc 8 #eg)))
  (setq #210 (cdr (assoc 210 #eg)))

  (setvar "CLAYER" #lay)

  ;// �o���[���̉~����}
  (command "_.circle" #pt1 CG_REF_SIZE)

  (setq #ss (ssadd (entlast) #ss))
  (setq #eg (entget (entlast)))
  (setq #eg (subst (cons 210 #210) (assoc 210 #eg) #eg))
  (entmod #eg)

  (setq #pt2 (trans #pt1 1 (entlast)))
  (entmod (subst (cons 10 #pt2) (assoc 10 #eg) #eg))

  ;// �o���[�����̐���������}
  (command "_.text" "S" "REF_NO" "J" "MC" #pt2 "" &no)
  (setq #ss (ssadd (entlast) #ss))
  (setq #eg (entget (entlast)))
  (setq #eg (subst (cons 210 #210) (assoc 210 #eg) #eg))
  (entmod #eg)
  (entmod (subst (cons 10 #pt2) (assoc 10 #eg) #eg))

  ;// �u���b�N��
  (CFublock #pt1 #ss)

  (command "_.-group" "A" #gnam (entlast) "")
)
;SKB_MakeBalNo

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_GetWKTopList
;;; <�����T�v>: ���[�N�g�b�v�̎d�l�ڍ׏����擾����
;;; <�߂�l>  :
;;;               ; 1.�\�[�g�L�[
;;;               ; 2.�ŏI�i��
;;;					      ; 3.��
;;;					      ; 4.����
;;;					      ; 5.���s
;;;					      ; 6.�i��
;;;               ; 7.��
;;;               ; 8.���z
;;;               ; 9.�W��ID  �V��,������͂��߂���"A10"
;;;               ;10.�}�`�n���h��
;;;************************************************************************>MOH<
(defun SKB_GetWKTopList (
  /
	#DDD #EN #HHH #HINMEI #HND #I #KAKAKU #LAST_HIN #LST$$ #MAG #MAG$ #SS #WT$ #WWW #XD$
#TOKU_CD	;-- 2011/12/12 A.Satoh Add
  )
  (setq CG_FuncName "\nSKB_GetWKTopList")

  ;// ���[�N�g�b�v����������
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (/= #ss nil)
    (progn
			; �Ԍ��ſ�Ă��� 01/07/05 YM ADD START
      (setq #i 0 #WT$ nil)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        ;// �g���f�[�^���擾
        (setq #xd$ (CFGetXData #en "G_WRKT"))
        ;// �Ԍ�
        (setq #MAG$ (nth 55 #xd$))
        (setq #MAG  (car #MAG$))
				(setq #WT$ (append #WT$ (list (list #MAG #en))))
        (setq #i (1+ #i))
			)
			(setq #WT$ (CFListSort #WT$ 0))
			(setq #WT$ (reverse #WT$))
			; �Ԍ��ſ�Ă��� 01/07/05 YM ADD END

      (setq #i 0)
      (repeat (length #WT$)
        (setq #en (cadr (nth #i #WT$)))
        ;// �g���f�[�^���擾
        (setq #xd$ (CFGetXData #en "G_WTSET"))
        (setq #LAST_HIN (nth 1 #xd$));�ŏI�i��
        (setq #KAKAKU   (nth 3 #xd$));���z
        (setq #HINMEI   (nth 4 #xd$));�i��
        (setq #WWW      (nth 5 #xd$));��
        (setq #HHH      (nth 6 #xd$));����
        (setq #DDD      (nth 7 #xd$));���s
;-- 2011/12/12 A.Satoh Add - S
				(setq #TOKU_CD  (nth 8 #xd$));�����R�[�h
;-- 2011/12/12 A.Satoh Add - E

        ;// ���[�N�g�b�v�n���h��
        (setq #hnd (cdr (assoc 5 (entget #en))))
        ;// ���[�N�g�b�v�̏�񃊃X�g���i�[
        (setq #lst$$
          (cons
            (list
              #i              ; 1.�\�[�g�L�[
              #LAST_HIN       ; 2.�ŏI�i��
							#WWW            ; 3.��
							#HHH            ; 4.����
							#DDD            ; 5.���s
							#HINMEI         ; 6.�i��
              1               ; 7.��
              #KAKAKU         ; 8.���z
              "A10"           ; 9.�W��ID  �V��,������͂��߂���"A10"
              (list #hnd)     ;10.�}�`�n���h��
;-- 2011/12/12 A.Satoh Add - S
              ""
              "A"
							#TOKU_CD				;13.�����R�[�h
							(if (= (nth 0 #xd$) 0)
								1
								0
							)
;-- 2011/12/12 A.Satoh Add - E
            )
            #lst$$
          )
        )
        (setq #i (1+ #i))
      )
    )
  )

  ;// ���[�N�g�b�v�̏�񃊃X�g��Ԃ�
  #lst$$
)
;;;SKB_GetWKTopList

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_GetBackGuardList
;;; <�����T�v>: �o�b�N�K�[�h�̎d�l�ڍ׏����擾����
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                  1.�\�[�g�L�[
;;;                  2.���[�N�g�b�v�i�Ԗ���
;;;                  3.�}�`�n���h��
;;;                  4.���͔z�u�p�i�Ԗ���
;;;                  5.�o�͖��̃R�[�h
;;;                  6.�d�l���̃R�[�h
;;;                  7.��
;;;                  8.���z
;;;                  9.���@
;;;                 10.���ގ�ރt���O(4:�o�b�N�K�[�h)
;;;                 11.�W��ID
;;;               )
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKB_GetBackGuardList (
  /
  #ss
  #en
  #xd$
  #wname
  #hnd
  #lst$$
  #i
  #flg
  #sDim
  )
  (setq CG_FuncName "\nSKB_GetBackGuardList")

  ;// �o�b�N�K�[�h����������
  (setq #ss (ssget "X" '((-3 ("G_BKGD")))))
  (if (/= #ss nil)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en    (ssname #ss #i))
        (setq #xd$   (CFGetXData #en "G_BKGD"))
        (setq #wname (nth 0 #xd$))                ; �i�Ԗ���
        (setq #hnd   (cdr (assoc 5 (entget #en))))  ; �}�`�n��
	;00/08/10 SN MOD �i������18H�̎��͍���150
	(if (equal "18H" (substr #wname 6 3))
          (setq #sDim  (strcat (rtos (nth 3 #xd$) 2 0) "x 20x150"))
          (setq #sDim  (strcat (rtos (nth 3 #xd$) 2 0) "x 20x 50"))
	)

        ;// ���[�N�g�b�v�̏�񃊃X�g���i�[
        (setq #lst$$
          (cons
            (list
              #i              ; 1.�\�[�g�L�[
              #wname          ; 2.BG�i�Ԗ���
              (list #hnd)     ; 3.�}�`�n���h��
              #wname          ; 4.���͔z�u�p�i�Ԗ���
              1               ; 5.�o�͖��̃R�[�h
              -1              ; 6.�d�l���̃R�[�h
              1               ; 7.��
              (nth 4 #xd$)    ; 8.���z
              #sDim           ; 9.���@
              "4"             ;10.���ގ�ރt���O
              1               ;11.�W��ID
            )
            #lst$$
          )
        )
        (setq #i (1+ #i))
      )
    )
  )

  ;// �o�b�N�K�[�h�̏�񃊃X�g��Ԃ�
  #lst$$
)
;;;SKB_GetBackGuardList

;�����_�ȉ��؏グ
(defun CfFix2 (
  &fNum
  /
  #iNum
  )
  (if (equal &fNum (fix &fNum) 0.001)
    (setq #iNum     (fix &fNum) )
    (setq #iNum (1+ (fix &fNum)))
  )

  #iNum
)
;00/09/22 SN ADD
;�������ɏ����_�ȉ��؏グ
(defun CfFix3 (
  &fNum
  /
  #iNum
  )
  (if (= &fNum (fix &fNum))
    (setq #iNum     (fix &fNum) )
    (setq #iNum (1+ (fix &fNum)))
  )

  #iNum
)

(defun CfGetLWPolyLineLen (
  &en
  /
  #fLen
  #pt$
  )
  (setq #fLen 0.0)

  (setq #pt$ (GetLWPolyLinePt &en))
  (repeat (1- (length #pt$))
    (setq #fLen (+ #fLen (distance (car #pt$) (cadr #pt$))))
    (setq #pt$ (cdr #pt$))
  )

  #fLen
)


;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_GetFillerInfo
;;; <�����T�v>: �V�䏈���֘A�A�C�e���̎d�l�ڍ׏����擾����
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                  1.�\�[�g�L�[
;;;                  2.�i�Ԗ���
;;;                  3.�}�`�n���h���Q
;;;                  4.���͔z�u�p�i�Ԗ���
;;;                  5.�o�͖��̃R�[�h
;;;                  6.�d�l���̃R�[�h
;;;                  7.��
;;;                  8.���z
;;;                  9.�i�R�[�h
;;;                 10.�A�C�e�����(0:�W�� 1:����WT 2:�V��֘A 3:�⑫)
;;;                 11.�W��ID
;;;               )
;;;               �c
;;;             )
;;; <���l>    : 01/01/12 HN �V�K�쐬
;;;************************************************************************>MOH<
(defun SKB_GetFillerInfo (
  /
;-- 2011/12/12 A.Satoh Mod - S
;;;;;  #sKind      ; �A�C�e�����
;;;;;  #Flr$       ; �A�C�e�����
;;;;;  #FlrN$      ; �A�C�e�����
;;;;;  #Flr$$      ; �A�C�e�����Q
;;;;;  #fLen       ; �V��A�C�e������
;;;;;  #fLen1      ; �V��A�C�e���P�i����
;;;;;  #fLen2      ; �V��A�C�e���P�i����(�Q���Z�b�g)
;;;;;  #fLen3      ; �V��A�C�e���P�i����(�~�Q)
;;;;;  #iType      ; �V��A�C�e�����
;;;;;  #iCnt       ; ���[�v�J�E���^
;;;;;  #iCnt1      ; �V��A�C�e����
;;;;;  #iCnt2      ; �V��A�C�e����(�Q���Z�b�g)
;;;;;  #xFlr       ; �A�C�e���I���Z�b�g
;;;;;  #eName      ; �}�`��
;;;;;  #sHnd       ; �}�`�n���h��
;;;;;  #sHnd$      ; �}�`�n���h���Q
;;;;;  #eed$       ; �g���f�[�^
;;;;;  #sCode      ; �i�Ԗ���
;;;;;  #sCode2     ; �i�Ԗ���(�Q���Z�b�g)
;;;;;  #rec$       ; �i�Ԑ}�`���R�[�h
;;;;;  #rec2$      ; �i�Ԑ}�`���R�[�h(�Q���Z�b�g)
;;;;;  #out$       ; �o�͏��
;;;;;  #out$$      ; �o�͏��Q
	#sKind #Flr$$ #iCnt #fLen #out$$ #xFlr #eName #sHnd #eed$ #sCode
	#iType #bunrui #xdOPT$ #kosu #Flr$ #idx #upd_flg #wk_flr1$ #sHnd$
	#FlrN$ #rec$
;-- 2011/12/12 A.Satoh Mod - E
  )

  (setq #sKind "2") ; �V��֘A(�Œ�)
  (setq #Flr$$ nil)
  (setq #iCnt  0  )
  (setq #fLen  0.0)
  (setq #out$$ nil)

  ;//
  ;// �V��֘A�̐}�`������
  ;//
  (setq #xFlr (ssget "X" (list (list -3 (list "G_FILR")))))
  (if #xFlr
    (repeat (sslength #xFlr)
      (setq #eName (ssname #xFlr #iCnt))
      (setq #sHnd  (cdr (assoc 5 (entget #eName))))
      (setq #eed$  (CFGetXData #eName "G_FILR"))
      (setq #sCode                     (nth 0 #eed$))
      (setq #iType                     (nth 3 #eed$))
      (if (/= 7 #iType)
        (setq #fLen  (CfGetLWPolyLineLen (nth 2 #eed$)))
        (setq #fLen  (nth 4 #eed$))
      )
;-- 2011/12/12 A.Satoh Add - S
      ; ���ނ̎擾
      (if (= (length #eed$) 8)
        (setq #bunrui (nth 7 #eed$))
        (setq #bunrui "A") ; �L�b�`��("A")�Œ�
      )

      ; ���擾
      (setq #xdOPT$ (CFGetXData #eName "G_OPT"))
      (if #xdOPT$
        (setq #kosu (1+ (nth 2 #xdOPT$)))
        (setq #kosu 1)
      )
;-- 2011/12/12 A.Satoh Add - E

;-- 2011/12/12 A.Satoh Mod - S
;;;;;      ;// #iType
;;;;;      ;// 1:�V��̨װ 2:�x�� 3:���艏 4:��Џ��� 5:���� 6:�������ݶް���т̏��艏 7:�Ǐ����p��߰��
;;;;;
;;;;;      ;// ����i�Ԃ��Ȃ��ꍇ�A���X�g�ɐV�K�o�^
;;;;;      ;// ����i�Ԃ�����ꍇ�A�����Ɛ}�`�n���h�������Z���čX�V
;;;;;      (setq #Flr$ (assoc #sCode #Flr$$))
;;;;;      (if (= nil #Flr$)
;;;;;        (progn
;;;;;          (setq #Flr$  (list #sCode #iType #fLen (list #sHnd)))
;;;;;          (setq #Flr$$ (cons #Flr$ #Flr$$))
;;;;;        )
;;;;;        (progn
;;;;;          (setq #fLen  (+ #fLen    (nth 2 #Flr$)))
;;;;;          (setq #sHnd$ (cons #sHnd (nth 3 #Flr$)))
;;;;;          (setq #FlrN$ (list #sCode #iType #fLen #sHnd$))
;;;;;          (setq #Flr$$ (subst #FlrN$ #Flr$ #Flr$$))
;;;;;        )
;;;;;      )
      ; ����i�Ԃ��������͓���i�Ԃ͂��邪���ދ敪���قȂ�ꍇ�́A���X�g�ɐV�K�o�^
      ; ����i�Ԃ�����A���ދ敪�������ł���Ό������Z���čX�V
      (if (= #Flr$$ nil)
        (progn
          (setq #Flr$  (list #sCode #iType #fLen (list #sHnd) #kosu #bunrui))
          (setq #Flr$$ (cons #Flr$ #Flr$$))
        )
        (progn
          (setq #idx 0)
          (setq #upd_flg nil)
          (repeat (length #Flr$$)
            (if (= #upd_flg nil)
              (progn
                (setq #wk_flr1$ (nth #idx #Flr$$))
                (if (and (= #sCode (nth 0 #wk_flr1$)) (= #bunrui (nth 5 #wk_flr1$)))
                  (progn
                    (setq #wk_flr$ #wk_flr1$)
                    (setq #upd_flg T)
                  )
                )
              )
            )
            (setq #idx (1+ #idx))
          )

          (if (= #upd_flg T)
            (progn
              (setq #fLen  (+ #fLen    (nth 2 #wk_flr$)))
              (setq #sHnd$ (cons #sHnd (nth 3 #wk_flr$)))
              (setq #kosu  (+ #kosu    (nth 4 #wk_flr$)))
              (setq #FlrN$ (list #sCode #iType #fLen #sHnd$ #kosu #bunrui))
              (setq #Flr$$ (subst #FlrN$ #wk_flr$ #Flr$$))
            )
            (progn
              (setq #Flr$  (list #sCode #iType #fLen (list #sHnd) #kosu #bunrui))
              (setq #Flr$$ (cons #Flr$ #Flr$$))
            )
          )
        )
      )
;-- 2011/12/12 A.Satoh Mod - E

      (setq #iCnt (1+ #iCnt))
    ) ;repeat
  ) ; #xFlr


  ;//
  ;// �A�C�e�����ƂɌ��v�Z
  ;//

  (foreach #Flr$ #Flr$$
    (setq #sCode (nth 0 #Flr$))
    (setq #iType (nth 1 #Flr$))
;-- 2011/12/12 A.Satoh Mod - S
;;;;;    (setq #fLen  (nth 2 #Flr$))
;-- 2011/08/11 A.Satoh Add - S
    (setq #kosu  (nth 4 #Flr$))
    (setq #bunrui (nth 5 #Flr$))
;-- 2011/12/12 A.Satoh Mod - E
    (setq #sHnd$ (nth 3 #Flr$))

    ;// �i�Ԋ�{�e�[�u������A�C�e���P�i�̒������擾
    (setq #rec$ (CFGetDBSQLHinbanTableChk "�i�Ԑ}�`" #sCode (list (list "�i�Ԗ���" #sCode 'STR))))
;-- 2011/12/12 A.Satoh Mod - S
    (if #rec$
      (setq #out$$ (cons (list #sCode (nth 1 #rec$) #bunrui #sHnd$ #kosu #sKind "" 0 "") #out$$))
    )
;;;;;    (if #rec$
;;;;;      (if (= 7 #iType)
;;;;;        (setq #fLen1 (nth 5 #rec$)) ; �Ǐ����p�X�y�[�T�[ ;2008/06/28 OK!
;;;;;        (setq #fLen1 (nth 3 #rec$)) ; ���̑�             ;2008/06/28 OK!
;;;;;      )
;;;;;    )
;;;;;
;;;;;    ;01/02/13 HN S-ADD �V��t�B���[�̌��ς薇���ݒ��ǉ�
;;;;;    (if (< 0 CG_FillerNum)
;;;;;      (setq #fLen (* #fLen1 CG_FillerNum))
;;;;;    )
;;;;;    ;01/02/13 HN E-ADD �V��t�B���[�̌��ς薇���ݒ��ǉ�
;;;;;
;;;;;    ;// �Q���Z�b�g������΁A�i�Ԋ�{�e�[�u������A�C�e���P�i�̒������擾
;;;;;    (setq #sCode2 nil)
;;;;;    (setq #fLen2  0.0)
;;;;;    (setq #fLen3  0.0)
;;;;;    
;;;;;
;;;;;    (setq #iCnt1 0)
;;;;;    (setq #iCnt2 0)
;;;;;    (if (< 0.0 #fLen2)
;;;;;      (while (< 0.0 #fLen)
;;;;;        (cond
;;;;;          ((>= #fLen1 #fLen)
;;;;;            (setq #iCnt1 (+ 1 #iCnt1))
;;;;;            (setq #fLen  0.0)
;;;;;          )
;;;;;          ((>= #fLen2 #fLen)
;;;;;            (setq #iCnt2 (+ 1 #iCnt2))
;;;;;            (setq #fLen  0.0)
;;;;;          )
;;;;;          ((>= #fLen3 #fLen)
;;;;;            (setq #iCnt1 (+ 2 #iCnt1))
;;;;;            (setq #fLen  0.0)
;;;;;          )
;;;;;          (T
;;;;;            (setq #iCnt2 (+ 1     #iCnt2))
;;;;;            (setq #fLen  (- #fLen #fLen2))
;;;;;          )
;;;;;        )
;;;;;      )
;;;;;      (while (< 0.0 #fLen)
;;;;;        (cond
;;;;;          ((>= #fLen1 #fLen)
;;;;;            (setq #iCnt1 (+ 1 #iCnt1))
;;;;;            (setq #fLen  0.0)
;;;;;          )
;;;;;          (T
;;;;;            (setq #iCnt1 (+ 1     #iCnt1))
;;;;;            (setq #fLen  (- #fLen #fLen1))
;;;;;          )
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;
;;;;;
;;;;;		(setq #out$$ (cons (list #sCode  (nth 1 #rec$)  #sHnd$ #iCnt1 #sKind) #out$$))
;;;;;
;-- 2011/12/12 A.Satoh Mod - E
  ) ;foreach



	;SCB_GetDetailList�@�ɓn���`��
	;#bzlst$$
	;�� ("H$030WFB-7%#-@@[J:BW]" "L" ("4937") 1 "0")

  ;// �V��t�B���[�̏ڍ׏����擾
  (if #out$$
    (reverse (SCB_GetDetailList #out$$))

  )
);SKB_GetFillerInfo

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_GetHosokuInfo
;;; <�����T�v>: �⑫���ނ̎d�l�ڍ׏����擾
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                  1.�\�[�g�L�[
;;;                  2.�i�Ԗ���
;;;                  3.�}�`�n���h��
;;;                  4.���͔z�u�p�i�Ԗ���
;;;                  5.�o�͖��̃R�[�h
;;;                  6.�d�l���̃R�[�h
;;;                  7.��
;;;                  8.���z
;;;                  9.�i�R�[�h
;;;                 10.���ގ�ރt���O
;;;                    (0:�W������ 1:����WT 2:�V��t�B���[ 3:�⑫����)
;;;                 11.�W��ID
;;;               )
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKB_GetHosokuInfo (
  /
;-- 2011/12/12 A.Satoh Mod - S
;;;;;  #xrec$
;;;;;  #i
;;;;;  #hin
;;;;;  #num
;;;;;  #fig$
;;;;;  #lst$$
  #lst$$ #lst$ #fname #spec$$ #spec$ #hinban #num #name #bunrui #fig$
;-- 2011/12/12 A.Satoh Mod - E
#qry$ #syuyaku ;-- 2012/02/09 A.Satoh Add
  )
  (setq CG_FuncName "\nSKB_GetHosokuInfo")

;-- 2011/12/12 A.Satoh Mod - S
  (setq #lst$$ nil)

  ; HOSOKU.cfg�̓Ǎ�
  (setq #fname (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
  (if (findfile #fname)
    (progn
      (setq #spec$$ (ReadCSVFile #fname))
      (if #spec$$
        (foreach #spec$ #spec$$
          (setq #hinban (nth 0 (StrParse (nth 0 #spec$) "=")))
          (setq #num (atoi (nth 1 (StrParse (nth 0 #spec$) "="))))
          (setq #name (nth 1 #spec$))
          (setq #bunrui (nth 2 #spec$))
          (if (> (strlen #bunrui) 1)
            (setq #bunrui (substr #bunrui 1 1))
          )

          ; �i�Ԋ�{�e�[�u�������߼�ݕi�����擾
          (setq #fig$ (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hinban (list (list "�i�Ԗ���" #hinban 'STR)))))
          (if (/= #fig$ nil)
            (progn
;-- 2012/02/09 A.Satoh Add - S
							(if (and (= (nth 2 #spec$) "D") (= (substr (nth 5 #fig$) 1 1) "A"))
								(progn
									(setq #qry$
										(car (CFGetDBSQLHinbanTable "�W��ID�ϊ�" #hinban
										(list (list "�i�Ԗ���" #hinban 'STR))))
									)

									(if (/= #qry$ nil)
										(setq #syuyaku (nth 1 #qry$))
										(setq #syuyaku (nth 5 #fig$))
									)
								)
								(setq #syuyaku (nth 5 #fig$))
							)
;-- 2012/02/09 A.Satoh Add - E

              (setq #lst$
                (list
                  (fix (nth 2 #fig$))  ;  1.�\�[�g�L�[
                  #hinban              ;  2.�i�Ԗ���
                  (list "")            ;  3.�}�`�n���h��
                  "Z"                  ;  4.L/R
                  0                    ;  5.�o�͖��̃R�[�h
                  0                    ;  6.�d�l���̃R�[�h
                  #num                 ;  7.��
                  0                    ;  8.���z(���ς菈���Ŏ擾)
                  "xxxxxxx"            ;  9.�i�R�[�h
                  "3"                  ; 10.���ގ�ރt���O
;-- 2012/02/09 A.Satoh Mod - S
;;;;;                  (nth 5 #fig$)        ; 11.�W��ID
									#syuyaku             ; 11.�W��ID
;-- 2012/02/09 A.Satoh Mod - E
									""
									0
                )
              )
              (setq #lst$$ (append #lst$$ (list #lst$)))
            )
          )
        )
      )
    )
  )
;;;;;  ;// �⑫���ނ̕i�Ԃƌ����擾����
;;;;;  (setq #xrec$ (CFGetXRecord "SUB_PARTS"))
;;;;;  (setq #i 0)
;;;;;  (repeat (/ (length #xrec$) 2)
;;;;;    (setq #hin (nth #i #xrec$))
;;;;;    (setq #num (nth (+ #i 1) #xrec$))
;;;;;    ;// �i�Ԋ�{�e�[�u����������擾
;;;;;    (setq
;;;;;      #fig$
;;;;;      (CFGetDBSQLHinbanTableChk "�i�Ԋ�{"
;;;;;        #hin
;;;;;        (list (list "�i�Ԗ���" #hin 'STR))
;;;;;      )
;;;;;    )
;;;;;    (if (= #fig$ nil)
;;;;;      (progn
;;;;;        (princ "\n�⑫����:[")
;;;;;        (princ #hin)
;;;;;        (princ "]�̕i�Ԋ֘A��񂪂���܂���")
;;;;;      )
;;;;;      (progn
;;;;;        (setq #lst$$
;;;;;          (append #lst$$
;;;;;            (list
;;;;;              (list
;;;;;                ""                 ;1.�H��L��
;;;;;                ""                 ;2.SERIES�L��
;;;;;                #hin               ;3.�i�Ԗ���
;;;;;                (nth 2 #fig$)      ;4.���͔z�u�p�i�Ԗ���
;;;;;                (list "")          ;5.�}�`�n���h���́A�Ȃ�
;;;;;                #num               ;6.�⑫���ނ̐�
;;;;;                "3"                ;7.���ގ�ރt���O
;;;;;              )
;;;;;            )
;;;;;          )
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;    (setq #i (+ #i 2))
;;;;;  )
;;;;;  ;// �⑫���ނ̏ڍ׏����擾����
;;;;;  (if (/= #lst$$ nil)
;;;;;    (reverse (SCB_GetDetailList #lst$$))
;;;;;;;;01/07/19YM@    (reverse (SCB_GetDetailList #lst$$ 0))
;;;;;    nil
;;;;;  )
;-- 2011/12/12 A.Satoh Mod - E
);SKB_GetHosokuInfo

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_GetOptionInfo
;;; <�����T�v>: �I�v�V�������ނ̎d�l�ڍ׏����擾
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                  1.�\�[�g�L�[
;;;                  2.�i�Ԗ���
;;;                  3.�}�`�n���h��
;;;                  4.���͔z�u�p�i�Ԗ���
;;;                  5.�o�͖��̃R�[�h
;;;                  6.�d�l���̃R�[�h
;;;                  7.��
;;;                  8.���z
;;;                  9.�i�R�[�h
;;;                 10.���ގ�ރt���O
;;;                    (0:�W������ 1:����WT 2:�V��t�B���[ 3:�⑫����)
;;;                 11.�W��ID
;;;               )
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKB_GetOptionInfo (
  /
;-- 2011/12/12 A.Satoh Mod - S
;;;;;  #ss
;;;;;  #sslen
;;;;;  #sym
;;;;;  #xd$
;;;;;  #xd2$
;;;;;  #i
;;;;;  #hin
;;;;;  #num
;;;;;  #fig$
;;;;;  #lst$$ #hand #LR_oya
;;;;;#OYA_FIG$ #OYA_HINBAN #XDLSYM$ #ORG_OPT #ORG_OPT #TOKU_OPT #TOKU_OPT$$ #XDOPT2$ ; 03/06/14 YM ADD
;;;;;#KAKAKU ; 03/06/14 YM ADD
;;;;;#Err_msg ; 04/01/09 YM ADD
  #ss #sslen #i #sym #xdLSYM$ #oya_hinban #LR_oya #hand #xd$ #xd2$
  #hin #num #fig$ #lst$$ #xdFILR$
;-- 2011/12/12 A.Satoh Mod - E
#qry$ #syuyaku ;-- 2012/02/09 A.Satoh Add
  )
  (setq CG_FuncName "\nSKB_GetOptionInfo")

;-- 2011/12/12 A.Satoh Mod - S
  ; G_OPT�����ݔ����ނ�����
  (setq #ss (ssget "X" '((-3 ("G_OPT")))))
  (if (= nil #ss)
    (setq #sslen 0)
    (setq #sslen (sslength #ss))
  )

  (setq #i 0)
  (repeat #sslen
    (setq #sym (ssname #ss #i))
    (setq #xdFILR$ (CFGetXData #sym "G_FILR"))
    (if (= #xdFILR$ nil)  ; 2�ȏ�̓V��t�B���[��ΏۊO��
      (progn
        (setq #xdLSYM$ (CFGetXData #sym "G_LSYM"))

        ; �e�}�`�i��
        (if #xdLSYM$
          (setq #oya_hinban (nth 5 #xdLSYM$))
          (setq #oya_hinban "")
        )

        ; L/R�敪
        (if #xdLSYM$
          (setq #LR_oya (nth 6 #xdLSYM$))
          (setq #LR_oya "Z")
        )

        (setq #hand (cdr (assoc 5 (entget #sym))))
        (setq #xd$  (CFGetXData #sym "G_OPT"))

        (setq #xd2$ #xd$)
        (repeat (car #xd$)
          (setq #xd2$ (cdr #xd2$))
          (setq #hin  (car #xd2$))  ;�i��
          (setq #xd2$ (cdr #xd2$))
          (setq #num  (car #xd2$))  ;��

          ;// �i�Ԋ�{�e�[�u�������߼�ݕi�����擾
          (setq #fig$ (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hin (list (list "�i�Ԗ���" #hin 'STR)))))
;-- 2012/02/09 A.Satoh Mod - S
					(if (/= #fig$ nil)
						(progn
							(if (and #xdLSYM$ (= (nth 15 #xdLSYM$) "D") (= (substr (nth 5 #fig$) 1 1) "A"))
								(progn
									(setq #qry$
										(car (CFGetDBSQLHinbanTable "�W��ID�ϊ�" #hin
										(list (list "�i�Ԗ���" #hin 'STR))))
									)

									(if (/= #qry$ nil)
										(setq #syuyaku (nth 1 #qry$))
										(setq #syuyaku (nth 5 #fig$))
									)
								)
								(setq #syuyaku (nth 5 #fig$))
							)

							(setq #lst$$
								(append #lst$$
									(list
										(list
											(fix (nth 2 #fig$))             ; 1.�\�[�g�L�[
											(KP_DelHinbanKakko #hin)        ; 2.�i�Ԗ��� ()�O��
											(list "")                       ; 3.�}�`�n���h��
											(if (equal (nth 1 #fig$) 1 0.1) ; 4.L/R
												#LR_oya                       ;   �e�}�`��LR
												"Z"                           ;   LR�Ȃ�
											)
											0                               ; 5.�o�͖��̃R�[�h
											0                               ; 6.�d�l���̃R�[�h
											#num                            ; 7.��
											0                               ; 8.���z(���ς菈���Ŏ擾)
											"xxxxxxx"                       ; 9.�i�R�[�h
											"3"                             ;10.���ގ�ރt���O
											#syuyaku                   			;11.�W��ID
											(nth 15 #xdLSYM$)               ;12.����
											""
											0
										)
									)
								)
							)
						)
					)
;;;;;          (if (= #fig$ nil)
;;;;;            nil
;;;;;            (setq #lst$$
;;;;;              (append #lst$$
;;;;;                (list
;;;;;                  (list
;;;;;                    (fix (nth 2 #fig$))             ; 1.�\�[�g�L�[
;;;;;                    (KP_DelHinbanKakko #hin)        ; 2.�i�Ԗ��� ()�O��
;;;;;                    (list "")                       ; 3.�}�`�n���h��
;;;;;                    (if (equal (nth 1 #fig$) 1 0.1) ; 4.L/R
;;;;;                      #LR_oya                       ;   �e�}�`��LR
;;;;;                      "Z"                           ;   LR�Ȃ�
;;;;;                    )
;;;;;                    0                               ; 5.�o�͖��̃R�[�h
;;;;;                    0                               ; 6.�d�l���̃R�[�h
;;;;;                    #num                            ; 7.��
;;;;;                    0                               ; 8.���z(���ς菈���Ŏ擾)
;;;;;                    "xxxxxxx"                       ; 9.�i�R�[�h
;;;;;                    "3"                             ;10.���ގ�ރt���O
;;;;;                    (nth 5 #fig$)                   ;11.�W��ID
;;;;;                    (nth 15 #xdLSYM$)               ;12.����
;;;;;										""
;;;;;										0
;;;;;                  )
;;;;;                )
;;;;;              )
;;;;;            )
;;;;;          )
;-- 2012/02/09 A.Satoh Mod - E
        )
      )
    )
    (setq #i (+ #i 1))
  )
;;;;;  ;// G_OPT�����ݔ����ނ�����
;;;;;  (setq #ss (ssget "X" '((-3 ("G_OPT")))))
;;;;;  (if (= nil #ss)
;;;;;    (setq	#sslen 0)
;;;;;    (setq	#sslen (sslength #ss))
;;;;;  )
;;;;;  (setq #i 0)
;;;;;  (repeat #sslen
;;;;;    (setq #sym (ssname #ss #i))
;;;;;		(setq #xdLSYM$ (CFGetXData #sym "G_LSYM"))
;;;;;		;03/06/14 YM ADD-S
;;;;;		(if #xdLSYM$
;;;;;			(setq #oya_hinban (nth 5 #xdLSYM$)) ; �e�}�`�i��
;;;;;			(setq #oya_hinban "") ; �e�}�`�i��
;;;;;		);_if
;;;;;		;03/06/14 YM ADD-E
;;;;;		(if #xdLSYM$
;;;;;			(setq #LR_oya (nth 6 #xdLSYM$)); 01/07/19 YM ADD �e�}�`��LR
;;;;;			(setq #LR_oya "Z") ; ����ق������Ȃ�"G_OPT"
;;;;;		);_if
;;;;;		(setq #hand (cdr (assoc 5 (entget #sym))))
;;;;;    (setq #xd$     (CFGetXData #sym "G_OPT"))
;;;;;
;;;;;    (setq #xd2$ #xd$)
;;;;;    (repeat (car #xd$)
;;;;;      (setq #xd2$ (cdr #xd2$))
;;;;;      (setq #hin  (car #xd2$))  ;�i��
;;;;;      (setq #xd2$ (cdr #xd2$))
;;;;;      (setq #num  (car #xd2$))  ;��
;;;;;
;;;;;      ;// �i�Ԋ�{�e�[�u�������߼�ݕi�����擾
;;;;;      (setq #fig$
;;;;;        (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hin
;;;;;       		   (list (list "�i�Ԗ���" #hin 'STR)))
;;;;;      ))
;;;;;      (if (= #fig$ nil)
;;;;;        (progn
;;;;;					nil
;;;;;;;;					(setq #Err_msg (strcat "�ȉ��̕i�Ԃ��ް��ް��ɑ��݂��܂���ł����B\n" #hin
;;;;;;;;																 "\n���݂��ް��ް����Â��\��������܂��B"
;;;;;;;;																 "\n���V�������Ō��ς����ꍇ�A���ׂɕ\������܂���̂ł����ӂ��������B"))
;;;;;;;;					(CFAlertErr #Err_msg)
;;;;;        )
;;;;;        (progn
;;;;;
;;;;;          (setq #lst$$
;;;;;            (append #lst$$
;;;;;              (list
;;;;;                (list
;;;;;									(fix (nth 2 #fig$))            ; 1.�\�[�g�L�[
;;;;;									(KP_DelHinbanKakko #hin)       ; 2.�i�Ԗ��� ()�O��
;;;;;									(list "")                      ; 3.�}�`�n���h��
;;;;;									(if (equal (nth 1 #fig$) 1 0.1); 4.L/R
;;;;;										#LR_oya            ; �e�}�`��LR
;;;;;										"Z"                ; LR�Ȃ�
;;;;;									);_if
;;;;;
;;;;;	               	0             ; 5.�o�͖��̃R�[�h
;;;;;	               	0             ; 6.�d�l���̃R�[�h
;;;;;	                #num          ; 7.��
;;;;;			            0             ; 8.���z(���ς菈���Ŏ擾)
;;;;;	                "xxxxxxx"     ; 9.�i�R�[�h
;;;;;	                "3"           ;10.���ގ�ރt���O
;;;;;		            	(nth 5 #fig$) ;11.�W��ID   2008/07/28 YM MOD  (FIX �폜
;;;;;
;;;;;                )
;;;;;              )
;;;;;            )
;;;;;          )
;;;;;
;;;;;
;;;;;;;;		          (list
;;;;;;;;	            	(fix (nth 2 #qry$)) ; 1.�\�[�g�L�[
;;;;;;;;               	(KP_DelHinbanKakko (nth 0 #lst$))  ; 2.�i�Ԗ��� ; 02/01/09 YM ADD ()�O��
;;;;;;;;                (nth 2 #lst$)  ; 3.�}�`�n���h��
;;;;;;;;                (nth 1 #lst$)  ; 4.L/R?
;;;;;;;;               	0  ; 5.�o�͖��̃R�[�h
;;;;;;;;               	0  ; 6.�d�l���̃R�[�h
;;;;;;;;                (nth 3 #lst$)  ; 7.��
;;;;;;;;		            0             ; 8.���z(���ς菈���Ŏ擾)
;;;;;;;;                "xxxxxxx"      ; 9.�i�R�[�h
;;;;;;;;                (nth 4 #lst$)  ;10.���ގ�ރt���O
;;;;;;;;	            	(nth 5 #qry$)     ;11.�W��ID   2008/07/28 YM MOD  (FIX �폜
;;;;;;;;		          )
;;;;;;;;
;;;;;
;;;;;        )
;;;;;      )
;;;;;    );repeat
;;;;;    (setq #i (+ #i 1))
;;;;;  );repeat
;;;;;
;;;;;
;;;;;
;;;;;;2008/08/14 YM DEL
;;;;;;// �I�v�V�����A�C�e���̏ڍ׏����擾����
;;;;;;;;  (if (/= #lst$$ nil)
;;;;;;;;    (reverse (SCB_GetDetailListOPT #lst$$)) ; ��pۼޯ�
;;;;;;;;    nil
;;;;;;;;  );_if
;-- 2011/12/12 A.Satoh Mod - E

	#lst$$ ;2008/08/14 YM MOD ���̂܂ܕԂ�
);;;SKB_GetOptionInfo

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_GetKekomiInfo
;;; <�����T�v>: �P�R�~����̎d�l�ڍ׏����擾
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                  1.�\�[�g�L�[
;;;                  2.�i�Ԗ���
;;;                  3.�}�`�n���h��(�Ȃ�)
;;;                  4.���͔z�u�p�i�Ԗ���
;;;                  5.�o�͖��̃R�[�h
;;;                  6.�d�l���̃R�[�h
;;;                  7.��
;;;                  8.���z
;;;                  9.�i�R�[�h
;;;                 10.���ގ�ރt���O(3:�⑫����)
;;;                 11.�W��ID
;;;               )
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SKB_GetKekomiInfo (
  /
  #sCode
  #sCode2
  #rec$
  #fSort
  #fWidth
  #iCnt
  #lst$$
  #data$
  #data2$
  )
  (setq CG_FuncName "\nSKB_GetKekomiInfo")
  (if (= nil CG_KekomiW)
    (setq CG_KekomiW 0.0)
  )

  ;00/08/09 SN S-MOD
  ;CG_KekomiFlag=T   ���� CG_KekomiW>0.0 �̎���Џ����ώZ
  ;CG_KekomiFlag=nil ���� CG_KekomiW>0.0 �̎������į���p̨װ�߯�݂�ώZ
  (if CG_KekomiFlag
    (progn
      (setq #sCode  "KB-K270V-K" )
      (setq #sCode2 "KB-K270V2-K")
    )
    (progn
      (setq #sCode  "KB-FP270P-K")
      (setq #sCode2 "KB-FP270P-K")
    )
  )
  ;(setq #sCode  "KB-K270V-K" )
  ;(setq #sCode2 "KB-K270V2-K")
  ;00/08/09 SN E-MOD
  ;// �i�Ԋ�{�e�[�u����������擾
  (setq #rec$ (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #sCode (list (list "�i�Ԗ���" #sCode 'STR)))))
  (if (/= nil #rec$)
    (progn
      (setq #fSort (nth 2 #rec$)) ; �\�[�g�L�[
      (setq #rec$ (car (CFGetDBSQLHinbanTable "�i�Ԑ}�`" #sCode (list (list "�i�Ԗ���" #sCode 'STR)))))
      (if (/= nil #rec$)
        (progn
          (setq #fWidth (nth 3 #rec$)) ; �� ;2008/06/28 OK!
          (setq #iCnt (CfFix2 (/ CG_KekomiW #fWidth)))
          (if CG_KekomiFlag
            ;00/08/09 SN ADD ��Џ���̏���
            (progn
              (if (< 1 #iCnt)
                (progn
                  (setq #rec$ (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #sCode2 (list (list "�i�Ԗ���" #sCode2 'STR)))))
                  (setq #data2$
                    (list
                      ""              ;1.�H��L��
                      ""              ;2.SERIES�L��
                      #sCode2         ;3.�i�Ԗ���
                      (nth 2 #rec$)   ;4.���͔z�u�p�i�Ԗ���
                      (list "")       ;5.�}�`�n���h���́A�Ȃ�
                      (/ #iCnt 2)     ;6.�P�R�~����̐�
                      "3"             ;7.���ގ�ރt���O
                    )
                  )
                )
              )
              (if (= 1 (rem #iCnt 2))
                (progn
                  (setq #data$
                    (list
                      ""              ;1.�H��L��
                      ""              ;2.SERIES�L��
                      #sCode          ;3.�i�Ԗ���
                      #fSort          ;4.���͔z�u�p�i�Ԗ���
                      (list "")       ;5.�}�`�n���h���́A�Ȃ�
                      1               ;6.�P�R�~����̐�
                      "3"             ;7.���ގ�ރt���O
                    )
                  )
                )
              )
            );progn ��Џ���̏���
            ;00/08/09 SN ADD �����į���p̨װ�߯�ݏ���
            (progn
              (if (> #iCnt 0)
                (setq #data$
                  (list
                    ""              ;1.�H��L��
                    ""              ;2.SERIES�L��
                    #sCode          ;3.�i�Ԗ���
                    #fSort          ;4.���͔z�u�p�i�Ԗ���
                    (list "")       ;5.�}�`�n���h���́A�Ȃ�
                    #iCnt           ;6.�����į���p̨װ�߯�݂̐�
                    "3"             ;7.���ގ�ރt���O
                  )
                )
              );end if
            );progn �����į���p̨װ�߯�ݏ���
          );end if
        )
      )

      (if (/= nil #data2$)
        (setq #lst$$ (append #lst$$ (list #data2$)))
      )
      (if (/= nil #data$)
        (setq #lst$$ (append #lst$$ (list #data$ )))
      )
    )
    (progn
      (princ (strcat "\n�I�v�V�����A�C�e��:[" #sCode "]�̕i�Ԋ֘A��񂪂���܂���"))
    )
  )

  ;// �P�R�~����̏ڍ׏����擾����
  (if (/= #lst$$ nil)
    (reverse (SCB_GetDetailList #lst$$))
;;;01/07/19YM@    (reverse (SCB_GetDetailList #lst$$ 0))
    nil
  )
)
;;;SKB_GetKekomiInfo

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_GetBuzaiList
;;; <�����T�v>: �i�Ԗ��́E���͔z�u�p�i�Ԗ��́E�}�`�n���h���̈ꗗ�\�쐬
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                 1.�H��L��
;;;                 2.SERIES�L��
;;;                 3.�i�Ԗ���
;;;                 4.���͔z�u�p�i�Ԗ���
;;;                 5.�}�`�n���h��
;;;                 6.��
;;;                 7.���ގ�ރt���O (0:�W������ 1:����WT 2:�V��t�B���[ 3:�⑫���� +100:����)
;;;                 8.���@(��)
;;;                 9.�|��or��悹�z(��)
;;;               )
;;;             )
;;;             ��8,9�͓����L���r�l�b�g�̏ꍇ�̂ݕt��
;;; <���l>    :
;;;             1)�z�u�ςݕ��ނ̍H��L���ESERIES�L���E�i�Ԗ��́E�k�^�q�敪���
;;;               �i�Ԑ}�`.DB����������B
;;;             2)���͔z�u�p�i�Ԗ��̂�����̏ꍇ�͂P�s�ɂ܂Ƃ߂Č����P��������B
;;;************************************************************************>MOH<
(defun SKB_GetBuzaiList (
  /
	#DRCOLCODE #HND #I #LRCD #LST$ #LST$$ #LST5$$ #LST7$$ #NAME #NUM #SORT-LST$$ #SS #SYM #XD$
#bunrui #xd_TOKU$ #toku_cd #toku_flg	;--2011/12/12 A.Satoh Add
#name_hantei ;2018/10/25 YM ADD-S
  )

;/////////////////////////////////////////////////////////////////////////////
; �����i�ԂȂ���𑝂₷
;/////////////////////////////////////////////////////////////////////////////
			(defun ##MATOME1 (
			 	&lis$
				/
				#F #FNEW #HIN #HINLR #HINLR$ #I #KOSU #LOOP #LR #RET$
;-- 2011/12/12 A.Satoh Add - S
				#toku_f
;-- 2011/12/12 A.Satoh Add - E
				)
				(setq #hinLR$ nil)
				(foreach #e &lis$
					(setq #hin (nth 0 #e))
					(setq #LR  (nth 1 #e))
					(setq #hinLR (list #hin #LR))
;-- 2011/12/12 A.Satoh Mod - S
;;;;;					(if (member #hinLR #hinLR$)
					(setq #toku_f (nth 7 #e))
	        (if (and (member #hinLR #hinLR$) (= #toku_f 0))
;-- 2011/12/12 A.Satoh Mod - E
						(progn ; �������̂��ߋ��ɂ���
							(setq #loop T #i 0)
							(setq #kosu (length #ret$))
							(while (and #loop (< #i #kosu))
								(setq #f (nth #i #ret$))
								(if (and (= (nth 0 #f) #hin)(= (nth 1 #f) #LR))
									(progn
										(setq #loop nil)
							      (setq #fnew
										 	(CFModList #f
								        (list
;-- 2011/12/12 A.Satoh Mod - S
;;;;;													(list 2 (append (nth 2 #f) (nth 2 #e))) ; �}�`����ْǉ�
;;;;;													(list 3 (1+ (nth 3 #f)))                ; ��+1
													(list 3 (append (nth 3 #f) (nth 3 #e))) ; �}�`����ْǉ�
													(list 4 (1+ (nth 4 #f)))                ; ��+1
;-- 2011/12/12 A.Satoh Mod - E
												)
								      )
										)
									)
								);_if
								(setq #i (1+ #i))
							);while
							(setq #ret$ (subst #fnew #f #ret$)) ; �v�f���ւ�
						)
						(progn ; ���߂ĂłĂ����v�f
							(setq #hinLR$ (append #hinLR$ (list #hinLR))) ; (�i��,LR)ؽ�
							(setq #ret$ (append #ret$ (list #e)))
						)
					);_if
				);foreach
				#ret$
			);##MATOME1
;/////////////////////////////////////////////////////////////////////////////

  (setq CG_FuncName "\nSKB_GetBuzaiList")

  ;// G_LSYM�����ݔ����ނ�����
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
	(if (and #ss (< 0 (sslength #ss)))
		(progn

		  (setq #i 0)
		  (repeat (sslength #ss)
		    (setq #sym (ssname #ss #i))
				(if (CfGetXData #sym "G_KUTAI") ; ��͖̂���
					(progn
						nil
					)
					(progn
				    (setq #xd$ (CFGetXData #sym "G_LSYM"))

;;;;;				    (setq #name (nth  5 #xd$))                    ; �i�Ԗ���
						(setq #xd_TOKU$ (CFGetXData #sym "G_TOKU"))
						(if #xd_TOKU$
	            (setq #name (nth  0 #xd_TOKU$)) ; �i�Ԗ���
  	          (setq #name (nth  5 #xd$)) ; �i�Ԗ���
						)

						;2018/10/25 YM ADD-S �����i�Ԃ��l���@#name_hantei�@�́A()�O����"%"�L������@�����Ɏg��
						(if #xd_TOKU$
	            (setq #name_hantei (nth  10 #xd_TOKU$)) ; �����O�̌��i�Ԗ���
  	          (setq #name_hantei (nth  5 #xd$)) ; �i�Ԗ���
						);_if
						;2018/10/25 YM ADD-E �����i�Ԃ��l��

						;2018/1/18 YM ADD-S
						;2018/10/11 YM ����
;;;						(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
;;;				      (progn

								;2018/01/09 YM ADD �i�Ԃ�%���܂�ł��Ȃ�������"Z"����
				        (if (vl-string-search "%" (KP_DelHinbanKakko #name_hantei));()�O����"%"�L������
									;���̂܂�
									(setq #lrcd (nth  6 #xd$))                    ; �k�q�敪
									;else %���Ȃ��̂�"Z"�ɂ���
              		(setq #lrcd "Z")                    ; �k�q�敪
								);_if

;;;							)
;;;							;else ����ި
;;;							(progn ;���̂܂�
;;;				    		(setq #lrcd (nth  6 #xd$))                    ; �k�q�敪
;;;							)
;;;						);_if
						;2018/10/11 YM ����
						;2018/1/18 YM ADD-E




						(setq #DRColCode  (nth 7 #xd$)) ; "��ذ��,��װ�L��"
            (setq #bunrui    (nth 15 #xd$)) ; ����(A:�L�b�`�� D:���[)
						(if #xd_TOKU$
							(progn
								(setq #toku_cd (nth 3 #xd_TOKU$))
								(setq #toku_flg 1)
							)
							(progn
								(setq #toku_cd "")
								(setq #toku_flg 0)
							)
						)
;-- 2011/12/12 A.Satoh Add - E

						(if (and #DRColCode (vl-string-search "," #DRColCode))
							(progn ; ����","���܂܂�Ă�����
		 						; "��ذ��,��װ�L��" 01/10/11 YM ADD ","-->":"
								(setq #DRColCode (CMN_string-subst "," ":" #DRColCode))
								(setq #name (strcat #name "[" #DRColCode "]"))
							)
						);_if

				    (setq #hnd  (cdr (assoc 5 (entget #sym))))    ; �}�`�n���h��

				    (setq #lst$
				      (list
				        #name                 ; �i�Ԗ���
				        #lrcd                 ; LR�敪
;-- 2011/12/12 A.Satoh Add - S
								#bunrui
;-- 2011/12/12 A.Satoh Add - E
				        (list #hnd)           ; �}�`�n���h��
;-- 2011/12/12 A.Satoh Add - S
								1
								"0"
								#toku_cd		; �����R�[�h
								#toku_flg		; �����t���O
								(nth  5 #xd$)	; �i�Ԗ��́i���������p)
;-- 2011/12/12 A.Satoh Add - E
				      )
				    )
				    (setq #lst$$ (append #lst$$ (list #lst$)))
					) ; ��͖̂���
				);_if
		    (setq #i (1+ #i))
		  );repeat

		  ;// �i�Ԗ��̂Ń\�[�g���ē��ꕔ�ނ̌����擾����
		  (setq #lst$$ (CFListSort #lst$$ 0))

			; �K�i�i�݂̂̑O��
			(setq #lst5$$ nil #lst7$$ nil)
;-- 2011/12/12 A.Satoh Del - S
;;;;;			(setq #num 1)
;-- 2011/12/12 A.Satoh Del - E
			(foreach #lst$ #lst$$
;-- 2011/12/12 A.Satoh Del - S
;;;;;				(setq #lst$ (append #lst$ (list #num "0")))
;-- 2011/12/12 A.Satoh Del - E
				(setq #lst5$$ (append #lst5$$ (list #lst$))) ; �K�i�i�݂̂̑O��
			);foreach

			; �W���i����(���걲�ь����Z) ------------------------------------------------------------------
			(setq #sort-lst$$ (##MATOME1 #lst5$$))

			;2017/12/19 YM ADD-S
			;2018/10/15 YM MOD-S
;;;			(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
	      (setq #sort-lst$$ (##HINBAN_MATOME2 #sort-lst$$))
;;;			);_if
			;2018/10/15 YM MOD-E
			;2017/12/19 YM ADD-E

		)
		(progn
			(princ "�}�ʏ�ɕ��ނ�����܂���B")
		)
	);_if

  ;// ���X�g��Ԃ�
  #sort-lst$$
);SKB_GetBuzaiList

;;;<HOM>************************************************************************
;;; <�֐���>  : SCB_GetDetailList
;;; <�����T�v>: �ݔ����ނ̏ڍ׏����擾����
;;; <�߂�l>  :
;;;             (list
;;;                (list
;;;                   1.�\�[�g�L�[
;;;                   2.�i�Ԗ���
;;;                   3.�}�`�n���h��
;;;                   4.���͔z�u�p�i�Ԗ���
;;;                   5.�o�͖��̃R�[�h
;;;                   6.�d�l���̃R�[�h
;;;                   7.��
;;;                   8.���z
;;;                   9.�i�R�[�h
;;;                  10.���ގ�ރt���O
;;;                  11.�W��ID
;;;                )
;;;                ...
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SCB_GetDetailList (
  &lst$$  ;(LIST)
          ;  (list
          ;    (list
          ;      1.�H��L��
          ;      2.SERIES�L��
          ;      3.�i�Ԗ���
          ;      4.���͔z�u�p�i�Ԗ���
          ;      5.�}�`�n���h��
          ;      6.��
          ;      7.���ގ�ރt���O
          ;    )
          ;  )
	; 01/07/19 YM DEL
;;;  &flg    ; 0: �i�Ԗ��݂̂̂Ō��� 1:�i�Ԗ��́ASERIES�L���A�H��L���Ō���

  /
;-- 2011/12/12 A.Satoh Mod - S
;;;;;  #lst$ #listCode #sql #nn #qry$ #qry2$ #dlst$$ #dlst$
;;;;;	#TOKU_FLG #hinban #FVALUE #TOKU_SYM
;;;;;	#dlstent$;00/07/10 SN ADD
;;;;;  #newent$ ;00/07/10 SN ADD
;;;;;  #dupflag ;00/07/10 SN ADD
;;;;;  #newnum  ;00/07/13 SN ADD
;;;;;	#SYM #XDTOKU$ #dum
;;;;;#BASEHINBAN$ #ERRMSG #I
	#i #lst$ #hinban #qry$ #dupflag #dlst$$ #dlstent$
	#newent$ #dlst$$ #qry2$ #syuyaku #dlst$ #sym
	#Errmsg #BaseHinban$ #BaseHinban
;-- 2011/12/12 A.Satoh Mod - E
  )
  (setq CG_FuncName "\nSCB_GetDetailList")

	(setq #BaseHinban$ nil) ; 03/06/05 YM ADD �i�Ԋ�{�����Ɏ��s�����i��
	(setq #i 0)
  (foreach #lst$ &lst$$

		(setq #hinban (nth 0 #lst$))
		(WebOutLog (strcat (itoa #i) "-" #hinban))
		; []��������菜��
		(setq #hinban (KP_DelDrSeriStr #hinban))
;-- 2011/12/12 A.Satoh Add - S
		; �����i�Ԃł���ꍇ
		(if (= (nth 7 #lst$) 1)
			(setq #hinban (nth 8 #lst$))
		)
;-- 2011/12/12 A.Satoh Add - S

    ;// �w�i�Ԋ�{�x���擾����
    (setq #qry$
      (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hinban
      (list (list "�i�Ԗ���" #hinban 'STR))))
    )
    (if (and (/= nil #qry$)(not (equal 1.0 (nth 6 #qry$) 0.1))) ;  �i�Ԋ�{.�ώZF=1�͏��O���鏈����ǉ� ��OK
      (progn
        ;�d���i�Ԃ͐��ʂ����Z����B
        (setq #dupflag nil)                          ;�d���׸�OFF
        (foreach #dlstent$ #dlst$$                   ;�쐬�ς݈ꗗ��ٰ��
          (if (and #dlstent$
	        				 (= (nth 3 #dlstent$) (nth 1 #lst$)) ;"L" or "R"���r�B
              		 (= (nth 1 #dlstent$)(KP_DelHinbanKakko (nth 0 #lst$))) ;�i�Ԗ��̂��r�B �O��()�Ȃ�,��҂�()�Ȃ�
;-- 2011/08/11 A.Satoh Add - S
                   (= (nth 11 #dlstent$) (nth 5 #lst$)) ; ���� "A" or "D" ���r
;-- 2011/08/11 A.Satoh Add - E
									 )
            (progn                                   ;�����i�Ԃ���������
              (setq #newent$                         ;�V����ؽĂ���蒼��
                (list
                  (nth  0 #dlstent$)                ; 1.�\�[�g�L�[
                  (nth  1 #dlstent$)                ; 2.�i�Ԗ���
                  (append (nth  2 #dlstent$)        ; 3.���̐}�`����ق�
                          (nth  2 #lst$))           ; 3.�}�`����� 2009/12/08 YM MOD ���[�g��
                  (nth  3 #dlstent$)                ; 4.���͔z�u�p�i�Ԗ���
                  (nth  4 #dlstent$)                ; 5.�o�͖��̺���
                  (nth  5 #dlstent$)                ; 6.�d�l���̺���
                  (+
                    (nth 6 #dlstent$)               ; 7.���̌���
                    (nth 3 #lst$))                 ; 7.���݂̌������Z����B 2009/12/08 YM MOD ���[�g��
                  (nth  7 #dlstent$)                ; 8.���z(���ς��菈���Ŏ擾)
                  (nth  8 #dlstent$)                ; 9.�i����
                  (nth  9 #dlstent$)                ;10.���ގ���׸�
                  (nth 10 #dlstent$)                ;11.�W��ID
                )
              )
              (setq #dlst$$ (subst #newent$ #dlstent$ #dlst$$));�V���v�f������
              (setq #dupflag T)                    ;�d���׸�ON
            )
          )
        )

        (if (not #dupflag)
					(progn ;00/07/10 SN MOD �d������Ώ��ǉ��͂��Ȃ�
;-- 2011/12/12 A.Satoh Add - S
            (if (and (= (nth 2 #lst$) "D") (= (substr (nth 5 #qry$) 1 1) "A"))
              (progn
                (setq #qry2$
                  (car (CFGetDBSQLHinbanTable "�W��ID�ϊ�" #hinban
                  (list (list "�i�Ԗ���" #hinban 'STR))))
                )

                (if (/= #qry2$ nil)
                  (setq #syuyaku (nth 1 #qry2$))
                  (setq #syuyaku (nth 5 #qry$))
                )
              )
              (setq #syuyaku (nth 5 #qry$))
            )
;-- 2011/12/12 A.Satoh Add - E

		        (setq #dlst$
		          (list
	            	(fix (nth 2 #qry$)) ; 1.�\�[�g�L�[
               	(KP_DelHinbanKakko (nth 0 #lst$))  ; 2.�i�Ԗ��� ; 02/01/09 YM ADD ()�O��
;-- 2011/12/12 A.Satoh Mod - S
;;;;;                (nth 2 #lst$)  ; 3.�}�`�n���h��
                (nth 3 #lst$)  ; 3.�}�`�n���h��
;-- 2011/12/12 A.Satoh Mod - E
                (nth 1 #lst$)  ; 4.L/R?
               	0  ; 5.�o�͖��̃R�[�h
               	0  ; 6.�d�l���̃R�[�h
;-- 2011/12/12 A.Satoh Mod - S
;;;;;                (nth 3 #lst$)  ; 7.��
                (nth 4 #lst$)  ; 7.��
;-- 2011/12/12 A.Satoh Mod - E
		            0             ; 8.���z(���ς菈���Ŏ擾)
                "xxxxxxx"      ; 9.�i�R�[�h
;-- 2011/12/12 A.Satoh Mod - S
;;;;;                (nth 4 #lst$)  ;10.���ގ�ރt���O
;;;;;	            	(nth 5 #qry$)     ;11.�W��ID   2008/07/28 YM MOD  (FIX �폜
                (nth 5 #lst$)  ;10.���ގ�ރt���O
                #syuyaku                          ; 11.�W��ID
                (nth 2 #lst$)                     ; 12.����
								(nth 6 #lst$)											; 13.�����R�[�h
								(nth 7 #lst$)											; 14.�����t���O
;-- 2011/12/12 A.Satoh Mod - S
		          )
		        )
		        (setq #dlst$$ (append #dlst$$ (list #dlst$)))
        	)
				)
      )
			;else �i�Ԋ�{�ɂȂ������� or �����Ă��ώZF=1 �̏ꍇ
			(progn
				;�ݸ���ǂ������肷��
;-- 2011/12/12 A.Satoh Mod - S
;;;;;				(setq #sym (handent (car (nth 2 #lst$))))
				(setq #sym (handent (car (nth 3 #lst$))))
;-- 2011/12/12 A.Satoh Mod - S
				(if (or (and #sym (equal CG_SKK_INT_SNK (nth 9 (CFGetXData #sym "G_LSYM")) 0.1 )) ; ���i����=410(�ݸ)�̏ꍇ
						    (and (/= nil #qry$)(equal 1.0 (nth 6 #qry$) 0.1))) ; �i�Ԋ�{�ɂ��邪�A�ώZF=1�̏ꍇ ��OK
		      nil ; ���X[�i�Ԋ�{]�ɓo�^����Ă��Ȃ��̂ŗ�O�I�ɏ��O���� �ώZF=1�͑Ώۂɂ��Ȃ�
					; else
					(progn
						(setq #BaseHinban$ (append #BaseHinban$ (list #hinban)))
					)
				);_if
			)
    );_if
		(setq #i (1+ #i))
  );_foreach


	(if #BaseHinban$
		(progn
			(setq #Errmsg "\n")
			(foreach #BaseHinban #BaseHinban$
				(setq #Errmsg (strcat #Errmsg #BaseHinban "\n"))
			)
			(CFYesDialog (strcat "\n�ȉ��̕i�Ԃ��ް��ް��ɂ���܂���ł����B"
													 "\n�����ϖ��ׂɕ\������܂���̂ł����ӂ��������B"
													 "\n  "
													 "\n��������  "
													 "\n���i���p�łɂȂ������A�ް��ް����ް�ޮ݂��Â���"
													 "\n�������ް��ް��Ɍ�肪���邱�Ƃ��l�����܂��B"
													 "\n  "
													 #Errmsg))
		)
	);_if
	#dlst$$
);SCB_GetDetailList

;;;<HOM>************************************************************************
;;; <�֐���>  : SCB_GetDetailListOPT
;;; <�����T�v>: �ݔ����ނ̏ڍ׏����擾����(��߼�ݕi��p)
;;; <�߂�l>  :
;;;             (list
;;;                (list
;;;                   1.�\�[�g�L�[
;;;                   2.�i�Ԗ���
;;;                   3.�}�`�n���h��
;;;                   4.���͔z�u�p�i�Ԗ���
;;;                   5.�o�͖��̃R�[�h
;;;                   6.�d�l���̃R�[�h
;;;                   7.��
;;;                   8.���z
;;;                   9.�i�R�[�h
;;;                  10.���ގ�ރt���O
;;;                  11.�W��ID
;;;                )
;;;                ...
;;;             )
;;; 03/06/14 YM ��߼�ݕi������������ꍇ�̐�pۼޯ�
;;;************************************************************************>MOH<
(defun SCB_GetDetailListOPT (
  &lst$$  ;(LIST) ����߼�ݕi�̂� ��������
          ;  (list
          ;    (list
          ;      1.�H��L��
          ;      2.SERIES�L��
          ;      3.�i�Ԗ���
          ;      4.���͔z�u�p�i�Ԗ���
          ;      5.�}�`�n���h��
          ;      6.��
          ;      7.���ގ�ރt���O
          ;    )
          ;  )
  /
	#DLST$ #DLST$$ #DUPFLAG #FVALUE #HINBAN #NEWENT$ #QRY$ #SYM #TOKU_FLG #ORG_OPT
	#BIKOU #DLST1$ #DLST2$ #HINMEI
  )
  (setq CG_FuncName "\nSCB_GetDetailList")

  (foreach #lst$ &lst$$
		(setq #TOKU_FLG nil) ; ������
		(setq #sym nil) ; ��߼�ݕi�Ȃ̂� #sym �Ȃ�
		(setq #hinban (nth 2 #lst$))

    (setq #qry$ ; �����i�̏ꍇ nil ���肦��
      (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hinban
      (list (list "�i�Ԗ���" #hinban 'STR))))
    )
		(if (= #qry$ nil)
			(progn
				; ������
				(setq #org_opt nil)
				(setq #fValue  nil)

				(setq #TOKU_FLG T)
				(setq #org_opt (nth  7 #lst$)) ; ���̕i��
				(setq #fValue  (nth  8 #lst$)) ; ���z
				(setq #hinmei  (nth  9 #lst$)) ; �i��
				(setq #bikou   (nth 10 #lst$)) ; ���l
				(if (= nil #org_opt)(setq #org_opt ""))
				(if (= nil #hinmei )(setq #hinmei  ""))
				(if (= nil #bikou  )(setq #bikou   ""))
				(if (= nil #fValue )(setq #fValue 0.0))

				;���̕i�Ԃŕi�Ԋ�{����������
		    (setq #qry$ ; �����i�̏ꍇ nil ���肦��
		      (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #org_opt
		      (list (list "�i�Ԗ���" #org_opt 'STR))))
		    )
			)
		);_if

    ;00/07/10 SN S-ADD �d���i�Ԃ͐��ʂ����Z����B
    (setq #dupflag nil)                          ;�d���׸�OFF
    (foreach #dlstent$ #dlst$$                   ;�쐬�ς݈ꗗ��ٰ��
      (if (and #dlstent$
      				 (= (nth 3 #dlstent$) (nth 3 #lst$)) ;00/07/12 SN ADD "L" or "R"���r�B
          		 (= (nth 1 #dlstent$)(KP_DelHinbanKakko (nth 2 #lst$)))) ;�i�Ԗ��̂��r�B �O��()�Ȃ�,��҂�()�Ȃ�
        (progn                                   ;�����i�Ԃ���������
          (setq #newent$                         ;�V����ؽĂ���蒼��
            (list
              (nth  0 #dlstent$)                ; 1.�\�[�g�L�[
              (nth  1 #dlstent$)                ; 2.�i�Ԗ���
              (append (nth  2 #dlstent$)        ; 3.���̐}�`����قɁu
                      (nth  4 #lst$))          ; 3.�}�`�����
              (nth  3 #dlstent$)                ; 4.���͔z�u�p�i�Ԗ���
              (nth  4 #dlstent$)                ; 5.�o�͖��̺���
              (nth  5 #dlstent$)                ; 6.�d�l���̺���
              (+
                (nth 6 #dlstent$)               ; 7.���̌���
                (nth 5 #lst$))                 ; 7.���݂̌������Z����B
              (nth  7 #dlstent$)                ; 8.���z(���ς��菈���Ŏ擾)
              (nth  8 #dlstent$)                ; 9.�i����
              (nth  9 #dlstent$)                ;10.���ގ���׸�
              (nth 10 #dlstent$)                ;11.�W��ID
            )
          )
          (setq #dlst$$ (subst #newent$ #dlstent$ #dlst$$));�V���v�f������
          (setq #dupflag T)                    ;�d���׸�ON
        )
      )
    )

    ;00/07/10 SN E-ADD
    (if (not #dupflag)
			(progn ;00/07/10 SN MOD �d������Ώ��ǉ��͂��Ȃ�
        (setq #dlst1$
          (list
						(fix (nth 2 #qry$)) ; 1.�\�[�g�L�[

						(if #TOKU_FLG
							(nth 2 #lst$) ; ������()���O���Ȃ�
	         		(KP_DelHinbanKakko (nth 2 #lst$))  ; ()�O��
						);_if

						(nth 4 #lst$)  ; 3.�}�`�n���h��
						(nth 3 #lst$)  ; 4.���͔z�u�p�i�Ԗ���  LR�敪
						(nth 6 #qry$)  ; 5.�o�͖��̃R�[�h
						(nth 7 #qry$)  ; 6.�d�l���̃R�[�h
						(nth 5 #lst$)  ; 7.��

						(if #TOKU_FLG
		        	#fValue           ; ��������
		          0                 ; 8.���z(���ς菈���Ŏ擾)
						);_if

						"xxxxxxx"      ; 9.�i�R�[�h

						(if #TOKU_FLG
							(strcat "101 " #org_opt) ; "101" + �����i��
	         		(nth 6 #lst$)            ;10.���ގ�ރt���O
						);_if

	      		(fix (nth 8 #qry$)) ;11.�W��ID
          )
        )

        (setq #dlst2$
          (list
						"" ; ����
						#fValue   ; �������z
						#hinmei   ; ���i����
						#bikou    ; �����l��
					)
				)

				(if #TOKU_FLG
					(setq #dlst$ (append #dlst1$ #dlst2$))
					(setq #dlst$ #dlst1$)
				);_if
        (setq #dlst$$ (append #dlst$$ (list #dlst$)))
    	)
		);00/07/10 SN MOD �d������Ώ��ǉ��͂��Ȃ�
  );_foreach
	#dlst$$
);SCB_GetDetailListOPT

;;;<HOM>************************************************************************
;;; <�֐���>  : SCB_GetDetailList_OPT
;;; <�����T�v>: �ݔ����ނ̏ڍ׏����擾����(��߼�ݕi��p)
;;; <�߂�l>  :
;;;             (list
;;;                (list
;;;                   1.�\�[�g�L�[
;;;                   2.�i�Ԗ���
;;;                   3.�}�`�n���h��
;;;                   4.���͔z�u�p�i�Ԗ���
;;;                   5.�o�͖��̃R�[�h
;;;                   6.�d�l���̃R�[�h
;;;                   7.��
;;;                   8.���z
;;;                   9.�i�R�[�h
;;;                  10.���ގ�ރt���O
;;;                  11.�W��ID
;;;                )
;;;                ...
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun SCB_GetDetailList_OPT (
  &lst$$  ;(LIST)
          ;  (list
          ;    (list
          ;      1.�H��L��
          ;      2.SERIES�L��
          ;      3.�i�Ԗ���
          ;      4.���͔z�u�p�i�Ԗ���
          ;      5.�e�̼���ِ}�`�n���h��
          ;      6.��
          ;      7.���ގ�ރt���O
          ;    )
          ;  )
  /
	#DLST$ #DLST$$ #DUPFLAG #HINBAN #NEWENT$ #NEWNUM #QRY$ #SYM #LR_oya
	#NEWDLST$ #NEWDLST$$ #NEWHIN
  )
  (setq CG_FuncName "\nSCB_GetDetailList_OPT")

  (foreach #lst$ &lst$$
		(if (nth 4 #lst$)
			(setq #sym (handent (car (nth 4 #lst$))))
			(setq #sym nil)
		);_if

		(if (and #sym (CFGetXData #sym "G_LSYM")) ; �e�}�`
			(setq #LR_oya (nth 6 (CFGetXData #sym "G_LSYM"))); 01/07/19 YM ADD �e�}�`��LR
			(setq #LR_oya "")
		);_if

		(setq #hinban (nth 2 #lst$))
    (setq #qry$
      (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hinban
      (list (list "�i�Ԗ���" #hinban 'STR))))
    )
    (if (/= nil #qry$)
      (progn
        ;00/07/10 SN S-ADD �d���i�Ԃ͐��ʂ����Z����B
        (setq #dupflag nil)                          ;�d���׸�OFF
        (foreach #dlstent$ #dlst$$                   ;�쐬�ς݈ꗗ��ٰ��
          (if (and #dlstent$
	        				 (= (nth 3 #dlstent$) (nth 3 #lst$)) ;00/07/12 SN ADD "L" or "R"���r�B
              		 (= (nth 1 #dlstent$) (nth 2 #lst$)));�i�Ԗ��̂��r�B
            (progn                          ;�����i�Ԃ���������
              (setq #newent$                         ;�V����ؽĂ���蒼��
                (list
                  (nth  0 #dlstent$)        ; 1.�\�[�g�L�[

                  (nth  1 #dlstent$)        ; 2.�i�Ԗ���
;;;									; 01/07/19 YM ADD START
;;;									(if (and #qry$ (= 1 (nth 1 #qry$))) ; LR�敪����ΐe�}�`��LR��t����
;;;                  	(strcat (nth 1 #dlstent$) #LR_oya) ; 2.�i�Ԗ���
;;;                  	(nth  1 #dlstent$)                 ; 2.�i�Ԗ���
;;;									);_if
;;;									; 01/07/19 YM ADD END

                  (append (nth  2 #dlstent$); 3.���̐}�`����ق�
                          (nth  4 #lst$))   ; 3.�}�`�����
                  (nth  3 #dlstent$)        ; 4.���͔z�u�p�i�Ԗ���
                  (nth  4 #dlstent$)        ; 5.�o�͖��̺���
                  (nth  5 #dlstent$)        ; 6.�d�l���̺���
                  (+
                    (nth 6 #dlstent$)       ; 7.���̌���
                    (nth 5 #lst$))          ; 7.���݂̌������Z����B
                  (nth  7 #dlstent$)        ; 8.���z(���ς��菈���Ŏ擾)
                  (nth  8 #dlstent$)        ; 9.�i����
                  (nth  9 #dlstent$)        ;10.���ގ���׸�
                  (nth 10 #dlstent$)        ;11.�W��ID
                )
              )
              (setq #dlst$$ (subst #newent$ #dlstent$ #dlst$$));�V���v�f������
              (setq #dupflag T)                    ;�d���׸�ON
            )
          )
        )
        ;00/07/10 SN E-ADD
        (if (not #dupflag)
					(progn ;00/07/10 SN MOD �d������Ώ��ǉ��͂��Ȃ�
		        (setq #dlst$
		          (list
							; 01/02/02 YM KPCAD �i�Ԋ�{�̃\�[�g�L�[��(nth 2 #qry$)
	            	(fix (nth 2 #qry$)) ; 1.�\�[�g�L�[

								(nth 2 #lst$)  ; 2.�i�Ԗ���

;;;								; 01/07/19 YM ADD START
;;;								(if (and #qry$ (= 1 (nth 1 #qry$))) ; LR�敪����ΐe�}�`��LR��t����
;;;                	(strcat (nth 2 #lst$) #LR_oya)    ; 2.�i�Ԗ���
;;;                	(nth 2 #lst$)                     ; 2.�i�Ԗ���
;;;								);_if
;;;								; 01/07/19 YM ADD END

								(nth 4 #lst$)  ; 3.�}�`�n���h��
								(nth 3 #lst$)  ; 4.���͔z�u�p�i�Ԗ���
               	(nth 6 #qry$)  ; 5.�o�͖��̃R�[�h
               	(nth 7 #qry$)  ; 6.�d�l���̃R�[�h
                (nth 5 #lst$)  ; 7.��
	              0                 ; 8.���z(���ς菈���Ŏ擾)
               "xxxxxxx"      ; 9.�i�R�[�h
								(nth 6 #lst$)  ;10.���ގ�ރt���O
								(fix (nth 8 #qry$)) ;11.�W��ID
		          )
		        )
		        (if (< 7 (length #lst$))
		          (progn
		            (setq #dlst$
		              (append #dlst$
		                (list
		                  (nth 7 #lst$) ;12.���@
		                  (nth 8 #lst$) ;13.�|��or��悹�z
		                )
		              )
		            )
		          )
		        )
		        (setq #dlst$$ (append #dlst$$ (list #dlst$)))
        	)
				);00/07/10 SN MOD �d������Ώ��ǉ��͂��Ȃ�
      )
			(progn
				(princ (strcat "\n�i�Ԋ�{��" #hinban "��ں��ނ�����܂���B"))
			)
    );_if

  );_foreach

  ;00/07/13 SN S-ADD
  ;���g�̃A�C�e���̐��ʂ��P�^�Q����B
  (foreach #dlstent$ #dlst$$                        ;�쐬�ς݈ꗗ��ٰ��
    (if (and #dlstent$
             (= (nth 1 #dlstent$) "KS-ZK65P"));) ;�ǌŒ�J�i�O�B   ;00/07/14 SN MOD )����ĂɁE�E
      (progn                                  ;���g�̕i��
        (setq #newnum (fix (/ (1+ (nth 6 #dlstent$)) 2)));���𔼕��ɂ���B1��1�2��1�3��2
        (setq #newent$                              ;�V����ؽĂ���蒼��
          (list
            (nth  0 #dlstent$)                      ; 1.�\�[�g�L�[
            (nth  1 #dlstent$)                      ; 2.�i�Ԗ���
            (nth  2 #dlstent$)                      ; 3.�}�`�����
            (nth  3 #dlstent$)                      ; 4.���͔z�u�p�i�Ԗ���
            (nth  4 #dlstent$)                      ; 5.�o�͖��̺���
            (nth  5 #dlstent$)                      ; 6.�d�l���̺���
            #newnum                                 ; 7.��
            (nth  7 #dlstent$)                      ; 8.���z(���ς��菈���Ŏ擾)
            (nth  8 #dlstent$)                      ; 9.�i����
            (nth  9 #dlstent$)                      ;10.���ގ���׸�
            (nth 10 #dlstent$)                      ;11.�W��ID
          )
        )
        (setq #dlst$$ (subst #newent$ #dlstent$ #dlst$$));�V���v�f������
      )
    );END IF
  );END FOREACH
  ;00/07/13 SN E-ADD

	; 01/07/19 YM LR��ǉ����� START
	(setq #newdlst$$ nil)
	(foreach #dlst$ #dlst$$
		(setq #hinban (nth 1 #dlst$))
    (setq #qry$
      (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hinban
      (list (list "�i�Ԗ���" #hinban 'STR))))
    )
    (if (/= nil #qry$)
      (progn
				(if (= 1 (nth 1 #qry$)) ; LR�敪����ΐe�}�`��LR��t����
		    	(setq #newHIN (strcat (nth 1 #dlst$) #LR_oya)) ; 2.�i�Ԗ���
		    	(setq #newHIN (nth  1 #dlst$))                 ; 2.�i�Ԗ���
				);_if
        (setq #newdlst$ (CFModList #dlst$
          (list (list 1 #newHIN))
        ))
				(setq #newdlst$$ (append #newdlst$$ (list #newdlst$)))
			)
    );_if
	)
	; 01/07/19 YM LR��ǉ����� END

;;;  #dlst$$
	#newdlst$$
);SCB_GetDetailList_OPT

;<HOM>*************************************************************************
; <�֐���>    : SKB_GetGroupPFig
; <�����T�v>  : �w��ݔ����ނ̎d�l�ԍ��̂o�_���擾����
; <�߂�l>    :
;        LIST : �o�_�}�`�̃��X�g
;
; <�쐬>      : 2000-01-12
; <���l>      :
;*************************************************************************>MOH<
(defun SKB_GetGroupPFig (
    &hnd             ;(STR)�w��ݔ����ނ̐}�`�n���h��
    /
    #en #en$
    #p-en$
    #i
    #xd$
  )

  (setq #en (handent &hnd))
  (setq #en$ (CFGetGroupEnt #en))
  (if (/= #en nil)
    (progn
      (setq #p-en$ nil)
      (setq #i 0)
      (while (< #i (length #en$))
        (setq #en (nth #i #en$))
        (if (/= nil (setq #xd$ (CFGetXData #en "G_PTEN")))
          (if (= (nth 0 #xd$) CG_BALOONTYPE)
            (setq #p-en$ (cons #en #p-en$))
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
  ;// ���_�}�`���X�g��Ԃ�
  #p-en$
)
;SKB_GetGroupPFig

;<HOM>*************************************************************************
; <�֐���>    : SKB_MakeWkTopBaloonPoint
; <�����T�v>  : ���[�N�g�b�v�E�V��t�B���[�̎d�l�\�ԍ�
; <�߂�l>    :
; <�쐬>      : 2000-01-12
; <���l>      :
;*************************************************************************>MOH<
(defun SKB_MakeWkTopBaloonPoint (
  /
	#BASEPT #DIST1 #DIST2 #EFILR #EN #I #LAY #P1 #P2 #P22 #PT$ #PUSHPLINE #SS
	#TEI #WTR_PT #WTTYPE #XD$ #ZAICODE #ZAIF #DIST #DISTMAX #N
	#nII
	#eMRWT	; �ŉE���[�N�g�b�v
	#xMRWT$	; �ŉE���[�N�g�b�v�̊g���f�[�^
  )

  ;// ���[�N�g�b�v
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (/= #ss nil)
    (progn


      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_WRKT"))
				(setq #ZaiCode (nth 2 #xd$))
				(setq #WTtype  (nth 3 #xd$))
				(setq #ZaiF (KCGetZaiF #ZaiCode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ
        (setq #BasePt (nth 32 #xd$)) ; WT����_
				(setq #tei    (nth 38 #xd$)) ; WT��ʐ}�`�����
				(setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��

				;;; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
				(setq #pt$ (GetPtSeries #BasePt #pt$))

				; 02/06/25 YM ADD �x���ǉ�
				(if (= nil #pt$)
					(progn
						(CFAlertMsg (strcat "\nܰ�į�߂������Ă�����Ɍ�肪����A���̂܂܏����𑱂���ƴװ���������܂��B\n"
																"ܰ�į�߂�������x����Ȃ����Ɩ�肪��������ꍇ������܂��B"))
;;;						(command "undo" "b" )
						(quit)
					)
				);_if
				; 02/06/25 YM ADD �x���ǉ�

			  (setq #WTR_PT (nth 1 #pt$)) ; WT�E��_
				; ���ڽL�^:WT�̈�Ԓ����Ԍ��̐^�񒆂ɂ��� 01/04/16 YM MOD
				; ���ڽL�^�ȊO:WT�̊Ԍ��̐^�񒆂ɂ���     01/04/16 YM MOD
				(cond
					((and (not (equal (KPGetSinaType) -1 0.1))(= #ZaiF 1)(= (length #pt$) 6)) ; ���ڽL�^ #pt$���Ŕ��f 01/07/05 YM
					;((and (= #ZaiF 1)(= #WTtype 1)) ; ���ڽL�^
						(setq #dist1 (distance (nth 0 #pt$)(nth 1 #pt$)))
						(setq #dist2 (distance (nth 0 #pt$)(nth 5 #pt$)))
						(if (<= #dist2 #dist1)
							(progn
								(setq #p1 (GetCenterPT (nth 0 #pt$) (nth 1 #pt$)))
		        		(setq #p2 (polar #p1 (+ (angle #BasePt #WTR_PT) (dtr 90)) 100))
							)
							(progn
								(setq #p1 (GetCenterPT (nth 5 #pt$) (nth 0 #pt$)))
		        		(setq #p2 (polar #p1 (+ (angle (nth 5 #pt$) (nth 0 #pt$)) (dtr 90)) 100))
							)
						);_if
					)
					(T
						(setq #p1 (GetCenterPT #BasePt #WTR_PT))
		        (setq #p2 (polar #p1 (+ (angle #BasePt #WTR_PT) (dtr 90)) 100))
				 	)
				);_cond

;;;01/04/16YM@			  (setq #WTR_PT (nth 1 #pt$)) ; WT�E��_
;;;01/04/16YM@				; WT�̎d�l�\�ԍ����E��ɂ���
;;;01/04/16YM@        (setq #p1 (list (car #WTR_PT) (cadr #WTR_PT) 0))
;;;01/04/16YM@        (setq #p1 (polar #p1 (angle #WTR_PT #BasePt) (* CG_REF_SIZE 1))) ; 120mm���ɂ��炷
;;;01/04/16YM@        (setq #p2 (polar #p1 (+ (angle #BasePt #WTR_PT) (dtr 90)) 100))

        (setq #lay "Z_03")
        ;// �d�l�ԍ��o�_�̐���
        (SKW_MakeBaloonPTen
					#p1
          #p1          ;(LIST)�V���N����_
          #p2          ;(LIST)�K�X����_
          #lay         ;(STR) �z�u��w
          900          ;(REAL)�z�u����
        )
        ;// �g���f�[�^�̕t��
        (CFSetXData (entlast) "G_PTEN" (list 7 0 0))
        ;// �o�_�ƃ��[�N�g�b�v���O���[�v��
        (SKMkGroup (CFCnvElistToSS (list (entlast) #en)))
        (setq #i (1+ #i))
      )
    )
  )

  ;// �V��t�B���[
  (setq #ss (ssget "X" '((0 . "3DSOLID") (-3 ("G_FILR")))))
  (if (/= #ss nil)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_FILR"))
        ;// �V��t�B���[�̉��o���|�����C���i�B���f�[�^�j���擾
        (setq #pushPline (nth 2 #xd$))
        ; "G_FILR" �Ɋg���f�[�^�����[����A�C�e���ł́A
        ;�u�Ǐ����p�X�y�[�T�[�v������3DPOLY�Ń|�����C�����쐬���邽�߁A
        ; POLYLINE ������悤�ɂȂ��Ă��܂��B
        ; ����ȊO�� "G_FILR" �g�p�̐}�`�͂��ׂ� LWPOLYLINE ��
        ; �g�p���Ă��܂��B
        ; �܂��A�u�Ǐ����p�X�y�[�T�[�v�����́A"G_FILR"��5�Ԗڂ̃f�[�^��
        ; �|�����C���������i�[����Ă��܂��B
        ; (�ق��̃A�C�e����"G_FILR"�ɂ͂Ȃ��ł�)
        ;(setq #pt$ (GetLWPolylinePt #pushPline))
        ; 2000/06/09  �y�� �|�����C���̒��_�擾�֐��́A"LWPOLYLINE" �� "POLYLINE"�Ή��łɕύX�B

				; �V��̨װ�̈�Ԓ��������̐^�񒆂ɂ��� 01/04/26 YM MOD
				; �V��̨װ�͍����珑���̂��O��
				(if (or (= nil #p1)(= nil #p2))
					(progn
		        (setq #pt$ (GetPolyVertex #pushPline))
						(setq #n 0 #distMAX -1.0e10)
;;;01/04/27YM@						(repeat (1- (length #pt$))
;;;01/04/27YM@							(setq #dist (distance (nth #n #pt$)(nth (1+ #n) #pt$)))
;;;01/04/27YM@							(if (<= #distMAX #dist)
;;;01/04/27YM@								(progn
;;;01/04/27YM@									(setq #distMAX #dist)
;;;01/04/27YM@									(setq #p1 (GetCenterPT (nth #n #pt$) (nth (1+ #n) #pt$) ))
;;;01/04/27YM@			        		(setq #p2 (polar #p1 (+ (angle (nth #n #pt$) (nth (1+ #n) #pt$)) (dtr 90)) 100))
;;;01/04/27YM@								)
;;;01/04/27YM@							);_if
;;;01/04/27YM@							(setq #n (1+ #n))
;;;01/04/27YM@						);repeat


						; �V��̨װ�̈�Ԓ��������̐^�񒆂ɂ��� 01/04/26 YM MOD
						; �ő�̂��̂���������ꍇ�ɂ͐����̍����猩�Ă����čŏ��̂��̂ɏ�����������
						; �_����t�����ɂ��� 01/04/27 YM MOD
						(setq #pt$ (reverse #pt$)) ; �_����t�����ɂ���
						(repeat (1- (length #pt$))
							(setq #dist (distance (nth #n #pt$)(nth (1+ #n) #pt$)))
							(if (<= #distMAX #dist)
								(progn
									(setq #distMAX #dist)
									(setq #p1 (GetCenterPT (nth #n #pt$) (nth (1+ #n) #pt$) ))
			        		(setq #p2 (polar #p1 (+ (angle (nth (1+ #n) #pt$) (nth #n #pt$)) (dtr 90)) 100))
								)
							);_if
							(setq #n (1+ #n))
						);repeat

					)
				);_if

;;;01/04/16YM@        (setq #p1 (polar #p1 (angle #p1 #p2) (* CG_REF_SIZE 1)))
;;;01/04/16YM@        (setq #p22 (polar #p1 (+ (angle #p1 #p2) (dtr 90)) 100))

;;;01/04/16YM				; I�^,L�^�E�܂�Ԃ��Ȃ��Ή� 01/04/16 YM MOD
;;;01/04/16YM        (setq #p2 (polar #p2 (angle #p2 #p1) (* CG_REF_SIZE 1)))
;;;01/04/16YM        (setq #p22 (polar #p2 (+ (angle #p1 #p2) (dtr 90)) 100))

; #p1,#p2 ��WT�̂��̂��g�p����
        (setq #lay "Z_03")
        ;// �d�l�\�ԍ��̐���
        (setq #eFilr
          (SKW_MakeBaloonPTen
            #p1                   ;(LIST)�R�[�i�[��_
            #p1                   ;(LIST)�V���N����_
            #p2                   ;(LIST)�K�X����_
            #lay                  ;(STR) �z�u��w
            (- CG_CeilHeight (* CG_REF_SIZE 2)) ;(REAL)�z�u����
          )
        )
        (if (/= nil #eFilr)
          (progn
            ;// �g���f�[�^�̕t��
				    (CFSetXData (entlast) "G_PTEN" (list 7 0 0))
            ;//�o�_�ƓV��t�B���[���O���[�v��
            (SKMkGroup (CFCnvElistToSS (list (entlast) #en)))      ;���������}�`�Q�Ŗ��O�̂Ȃ��O���[�v�쐬
          )
        )

        (setq #i (1+ #i))
      )
    )
  );_if

	(princ)
)
;SKB_MakeWkTopBaloonPoint

;<HOM>*************************************************************************
; <�֐���>    : SKW_MakeBaloonPTen
; <�����T�v>  : ���[�N�g�b�v�E�V��t�B���[�̎d�l�\�ԍ���}
; <�߂�l>    :
;       ENAME : �d�l�ԍ��_�}�`��
; <�쐬>      : 2000-01-12
; <���l>      :
;*************************************************************************>MOH<
(defun SKW_MakeBaloonPTen (
  &BasePt           ;(LIST)�R�[�i�[��_
  &p1               ;(LIST)�V���N����_
  &p2               ;(LIST)�K�X����_
  &lay              ;(STR) �z�u��w
  &Height           ;(REAL)�z�u����
  /
  #pt
  #view
  #enTemp$
#eLast ; 01/11/30 YM ADD
  )

  (setq #pt (polar &BasePt (angle &BasePt &p2) (/ (distance &BasePt &p2) 2)))
  (setq #pt (list (car #pt) (cadr #pt) (+ &Height CG_REF_SIZE)))
  (cond
    ((or (= &lay "Z_03")(= &lay "Z_00")) ;����
      (setq #view (polar &p1 (angle &p2 (list 0 0)) (distance &p2 (list 0 0))))
    )
    ((or (= &lay "Z_04") (= &lay "Z_05")(= &lay "Z_06")) ;�w�ʁE����
      (setq #view (polar &p2 (angle &p1 (list 0 0)) (distance &p1 (list 0 0))))
    )
  )

	; 01/11/30 YM ADD WT��̨װ��PTEN7�ɂ́AXDATA"G_PTWF"��t���遨��ō폜���₷�����邽��
	(if (= nil (tblsearch "APPID" "G_PTWF")) (regapp "G_PTWF"))

  (if (and (/= nil (car #view)) (/= nil (cadr #view)))
    (progn
      (setq #view (list (car #view) (cadr #view) 0))
      ;// �_���쐬
      (command "_.point" #pt)
			(setq #eLast (entlast)) ; POINT 01/11/30 YM ADD
	    (setq #enTemp$ (subst (cons 8  &lay) (assoc 8 (entget (entlast))) (entget  (entlast))))
	    (entmod (subst (cons 210 #view) (assoc 210 #enTemp$) #enTemp$))
			(CFSetXData (entlast) "G_PTWF" (list 0 0 0)) ; 01/11/30 YM ADD
      (entlast)
    )
    nil
  )
);SKW_MakeBaloonPTen

;;;<HOM>************************************************************************
;;; <�֐���>  : CFGetDBSQLHinbanTableChk
;;; <�����T�v>: �i�Ԋ֘A�e�[�u����������
;;; <�߂�l>  : 1���R�[�h���̃��X�g
;;; <���l>    : 0���܂��͕������擾�����ꍇ�A�G���[�\����A(*error*)�����s���܂�
;;;************************************************************************>MOH<
(defun CFGetDBSQLHinbanTableChk (
  &sTblName   ; �e�[�u������
              ;   1:�i�Ԑ}�`
              ;   2:�i�Ԋ�{
              ;   3:�i�ԍŏI
  &sHinban    ; �i�Ԗ���
  &cond$      ; ��������
  /
  #sFuncName  ; �ďo�����֐���
  #result$$   ; ��������
  #sErrMsg    ; �G���[���b�Z�[�W
  )
  (if (= 'STR (type CG_FuncName))
    (setq #sFuncName (strcat "\n" CG_FuncName))
    (setq #sFuncName "")
  )

	(setq #result$$ (CFGetDBSQLHinbanTable &sTblName &sHinban &cond$))
  (cond
    ((= 0 (length #result$$))
			(setq #sErrMsg (strcat "�w" &sTblName "�x�Ƀ��R�[�h������܂���B" #sFuncName))
;;;      (CFOutStateLog 0 1 #sErrMsg)
			(CFAlertMsg #sErrMsg)
      (princ "\n")(princ &cond$)
      (*error*)
    )
    ((= 1 (length #result$$))
		 	nil
;;;      (CFOutStateLog 1 1 "*** �擾ں��� ***")
;;;      (CFOutStateLog 1 1 #result$$)
    )
    ((< 1 (length #result$$)) ; ����˯Ă����Ƃ��ʹװ
;;;			(CFOutStateLog 1 1 "*** �擾ں��� ***")
;;;			(CFOutStateLog 1 1 #result$$)
			(setq #sErrMsg (strcat "�w" &sTblName "�x�Ƀ��R�[�h����������܂���." #sFuncName))
;;;		  (CFOutStateLog 0 1 #sErrMsg)
			(CFAlertMsg #sErrMsg)
		  (*error*)
    )
  )

  (car #result$$)
)
;;;CFGetDBSQLHinbanTableChk

;;;<HOM>************************************************************************
;;; <�֐���>  : CFGetDBSQLRecChk
;;; <�����T�v>: �w��e�[�u�������������ɂ�茟������
;;; <�߂�l>  : 1���R�[�h���̃��X�g
;;; <���l>    : 0���܂��͕������擾�����ꍇ�A�G���[�\����A(*error*)�����s���܂�
;;;************************************************************************>MOH<
(defun CFGetDBSQLRecChk (
  &session$   ; �Z�b�V����
  &sTblName   ; �e�[�u������
  &cond$      ; ��������
  /
  #sFuncName  ; �ďo�����֐���
  #result$$   ; ��������
  #sErrMsg    ; �G���[���b�Z�[�W
  )
  (if (= 'STR (type CG_FuncName))
    (setq #sFuncName (strcat "\n" CG_FuncName))
    (setq #sFuncName "")
  )

  (setq #result$$ (CFGetDBSQLRec &session$ &sTblName &cond$))
  (cond
    ((= 0 (length #result$$))
			(setq #sErrMsg (strcat "�w" &sTblName "�x�Ƀ��R�[�h������܂���B" #sFuncName))
;;;      (CFOutStateLog 0 1 #sErrMsg)
			(CFAlertMsg #sErrMsg)
      (princ "\n")(princ &cond$)
      (*error*)
    )
    ((= 1 (length #result$$))
		 	nil
;;;      (CFOutStateLog 1 1 "*** �擾ں��� ***")
;;;      (CFOutStateLog 1 1 #result$$)
    )
    ((< 1 (length #result$$)) ; ����˯Ă����Ƃ��ʹװ
;;;			(CFOutStateLog 1 1 "*** �擾ں��� ***")
;;;			(CFOutStateLog 1 1 #result$$)
			(setq #sErrMsg (strcat "�w" &sTblName "�x�Ƀ��R�[�h����������܂���." #sFuncName))
;;;		  (CFOutStateLog 0 1 #sErrMsg)
			(CFAlertMsg #sErrMsg)
		  (*error*)
    )
  )

  (car #result$$)
)
;;;CFGetDBSQLRecChk

;;;<HOM>************************************************************************
;;; <�֐���>  : SKB_GetHeadList
;;; <�����T�v>: �d�l�\�w�b�_�[�����擾����
;;; <�߂�l>  :
;;;             (list
;;;                1.SERIES�L��
;;;                2.SERIES����
;;;                3.��SERIES�L��
;;;                4.��SERIES����
;;;                5.��COLOR�L��
;;;                6.��COLOR����
;;;                7.WT�ގ��L��
;;;                8.WT�ގ�����
;;;                9.WT����       01/06/01 YM ADD
;;;               10.�V���N�L��
;;;               11.�V���N����
;;;               12.�d�C��
;;;               13.�K�X��
;;;               14.�ϐk�L��
;;;               15.�@��F
;;; <���l>    : �ݸ��1�Ɖ��肵�A�ŏ��Ɍ����������̂��̗p���Ă��� YM
;;;************************************************************************>MOH<
(defun SKB_GetHeadList (
  /
	#BRAND #DRCOLNAME #DRSERINAME #I #LOOP #QRY$ #SERI$ #SNKCD #SNKNAME
	#SOZAINAME #SOZAINAME2 #SOZAIZAINAME #SOZAIZAINAME$ #SRNAME #SS #XREC$
	#ZAICD #ZAINAME #ZAINAME2 #MSG
  )
  (setq CG_FuncName "\nSKB_GetHeadList")

  ;// ���݂̏��i����ݒ肷��
  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DBNAME      (nth 0 #seri$))  ;DB����
      (setq CG_SeriesCode  (nth 1 #seri$))  ;SERIES�L��
      (setq CG_BrandCode   (nth 2 #seri$))  ;�u�����h�L��
      (setq CG_DRSeriCode  (nth 3 #seri$))  ;��SERIES�L��
      (setq CG_DRColCode   (nth 4 #seri$))  ;��COLOR�L��
      (setq CG_HIKITE      (nth 5 #seri$))  ;�q�L�e�L��
    )
  )

  ;// �f�[�^�x�[�X�ɐڑ�����
  (if (= CG_CDBSESSION nil)
    (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  )
  (if (= CG_DBSESSION nil)
    (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  )

  ;// �V���N������
	(setq CG_WTHeight "850") ; WT����(�}�ʏ�ɃV���N�����݂��Ȃ��Ƃ�)
  (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; �}�ʏ�̑S�V���N������
  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (setq #loop T)
      (while (and #loop (< #i (sslength #ss)))
        (if (= CG_SKK_ONE_SNK (CFGetSymSKKCode (ssname #ss #i) 1))
          (progn
            (setq #snkCd (nth 5 (CFGetXData (ssname #ss #i) "G_LSYM"))) ; �ݸ�̕i�Ԗ���
						(setq CG_WTHeight (caddr (cdr (assoc 10 (entget (ssname #ss #i)))))) ; WT�����擾 01/06/01 YM ADD
						(setq CG_WTHeight (itoa (fix (+ CG_WTHeight 0.001)))) ; WT�����擾 01/06/01 YM ADD
            (setq #loop nil)
          )
        )
        (setq #i (1+ #i))
      )
    )
    ;@@@(progn
    ;@@@  (CFAlertErr "�A�C�e�����ނ�����܂���")
    ;@@@)
  )

  ;// SERIES����
  (setq #qry$ (CFGetDBSQLRecChk CG_CDBSESSION "SERIES" (list (list "SERIES�L��" CG_SeriesCode 'STR)
																															 (list "SERIES����" CG_SeriesDB   'STR)))) ; 02/03/18 YM ADD CG_SeriesDB�ǉ�
;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #qry$)
;;;		;�ذ�ޕ�DB,����DB�Đڑ�
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E

  (if (= nil #qry$)
    (CFAlertErr "SERIES�e�[�u����������܂���(SKB_GetHeadList)")
  )

  (setq #srname (nth 13 #qry$)) ; �Q�Ɛ��ύX�@�������̂��猩�ϐ������̂�
	(if (= nil #srname)
		(setq #srname (nth 5 #qry$)) ; �]���ʂ�(ж�ޔ�)
	);_if


  ;// ��SERIES����
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "���V���Y" (list (list "���V���L��" CG_DRSeriCode 'STR))));04/04/23 YM

  (if (= nil #qry$)
		(progn
  		(setq #msg "��SERIES�e�[�u�����猻�݂̔�SERIES���������܂���ł���(SKB_GetHeadList)")
			(if (= CG_AUTOMODE 2) ; 02/09/04 YM ADD
				(WebOutLog #msg)    ; 02/09/04 YM ADD
      	(CFAlertMsg #msg)
			);_if
		)
		(progn
			(setq #qry$ (car #qry$))
		)
  )
  (setq #drseriname (nth 1 #qry$)) ; 2008/07/29 YM MOD

  ;// ��COLOR����
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "��COLOR" (list (list "���J���L��" CG_DRColCode 'STR))));04/04/23 YM
  (if (= nil #qry$)
		(progn
  		(setq #msg "��COLOR�e�[�u�����猻�݂̔�COLOR���������܂���ł���(SKB_GetHeadList)")
			(if (= CG_AUTOMODE 2) ; 02/09/04 YM ADD
				(WebOutLog #msg)    ; 02/09/04 YM ADD
      	(CFAlertMsg #msg)
			);_if
		)
		(progn
			(setq #qry$ (car #qry$))
		)
  )
  (setq #drcolname (nth 1 #qry$))

  ;// ���[�N�g�b�v�ގ�
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (/= #ss nil)
    (progn
			(setq #SozaiZaiName$ '() #i 0)

			(repeat (sslength #ss)
				;// �ގ�����
				(setq #zaiCd (nth 2 (CFGetXData (ssname #ss #i) "G_WRKT")))
				(setq #qry$
				  (CFGetDBSQLRecChk CG_DBSESSION "WT�ގ�"
				    (list
				      (list "�ގ��L��"  #zaiCd  'STR)
				    )
				  )
				)
		    (setq #zaiName (nth 2 #qry$))  ;2008/06/24 YM MOD
		    (setq #SozaiName (nth 4 #qry$));2008/06/24 YM MOD
		    (setq #SozaiZaiName$ (append #SozaiZaiName$ (list (list #SozaiName #zaiName))))
		    (setq #i (1+ #i))
			); repeat
			; 2000/09/26 HT �}�ʕ\��̃��[�N�g�b�v���\���ύX
			; �X�e�����X ���s�X���ɕ��ёւ���
			(setq #SozaiZaiName$ (CFListSort #SozaiZaiName$ 0))
			; �擪�� WT�ގ� �f�ޖ���
			(setq #zaiName (cadr (car #SozaiZaiName$)))
			(setq #SozaiName (car (car #SozaiZaiName$)))

      (if (= (length #SozaiZaiName$) 1)
				(progn
					(setq #zaiName2 "")
					(setq #SozaiName2 "")
        )
			 	(progn
	       	(if (= "�X�e�����X" (car(car #SozaiZaiName$)))
						(progn
							; �X�e�����X������ꍇ
							(if (setq #SozaiZaiName (assoc "���s�X" #SozaiZaiName$))
							  (progn
							    ; ���s�X������ꍇ
							    (setq #zaiName2 (cadr #SozaiZaiName))
							    (setq #SozaiName2 (car #SozaiZaiName))
							  )
							  (progn
							    (setq #zaiName2 "")
							    (setq #SozaiName2 "")
							  )
						  );_if
		   			)
		   			(progn
		   ; �X�e�����X���Ȃ��ꍇ
	           	; �f�ނŃ\�[�g
		   				(setq #SozaiZaiName$ (CFListSort #SozaiZaiName$ 1))
		   ; ����f�ނłȂ��Ƃ�
	           	(if (/= (cadr (car #SozaiZaiName$)) (cadr (last #SozaiZaiName$)))
	            	(progn
		              (setq #zaiName (cadr (car #SozaiZaiName$)))
		              (setq #SozaiName (car (car #SozaiZaiName$)))
		              (setq #zaiName2 (cadr (last #SozaiZaiName$)))
		              (setq #SozaiName2 (car (last #SozaiZaiName$)))
					      )
			    			(progn
			            (setq #zaiName2 "")
			            (setq #SozaiName2 "")
						    )
							);_if
						)
		 			);_if ; �X�e�����X
				)
      ); if (length ) 1

      ;// �V���N����
      (if (and (/= nil #snkCd) (/= "" #snkCd))
        (progn
 		; ===>@@@�V���N���L���͔p�~���� 00/11/17 YM
;;;00/11/25 YM	  (setq #qry$ (car (CFGetDBSQLRec CG_DBSESSION "SINK���L" (list (list "�V���N���L��" #gsink3 'STR))))) ; �����ύX
;;;00/11/25 YM          (setq #snkName (nth 3 #qry$))
          (setq #qry$ (car (CFGetDBSQLRec CG_DBSESSION "WT�V���N" (list (list "�i�Ԗ���" #snkCd 'STR)))))
          (setq #snkName (nth 2 #qry$))
        )
        (progn
          (setq #snkCd   "")
          (setq #snkName "")
        )
      )
    )
    (progn
			;04/08/20 YM ADD ��O���� ����21�Ȃ�"���ڽ"���߂���
			(if (= CG_SeriesCode "A")
				(progn
		      (setq #zaiCd   "SE")
		      (setq #snkCd   "")
		      (setq #zaiName "���ڽ" #zaiName2 "���ڽ")
		      (setq #snkName "" )
		      (setq #SozaiName "���ڽ" #SozaiName2 "���ڽ")
				)
				(progn
		      (setq #zaiCd   "")
		      (setq #snkCd   "")
		      (setq #zaiName "" #zaiName2 "")
		      (setq #snkName "" )
		      (setq #SozaiName "" #SozaiName2 "")
				)
			);_if
    )
  );_if

  (list
    CG_SeriesCode             ; 1.SERIES�L��
    (ai_strrtrim #srName)     ; 2.SERIES����
    CG_DRSeriCode             ; 3.��SERIES�L��
    (ai_strrtrim #drseriName) ; 4.��SERIES����
    CG_DRColCode              ; 5.��COLOR�L��
    (ai_strrtrim #drcolName)  ; 6.��COLOR����
    (ai_strrtrim #zaiCd)      ; 7.WT�ގ��L��
    (ai_strrtrim #zaiName)    ; 8.WT�ގ�����
    CG_WTHeight               ; 9.WT����     01/06/01 YM ADD
    (ai_strrtrim #snkCd)      ;10.�V���N�L��
    (ai_strrtrim #snkName)    ;11.�V���N����
    (if (< (length #seri$) 10) "" (nth 10 #seri$)) ;12.�d�C�� XRECORD�Ȃ����װ����������B
    (if (< (length #seri$)  9) "" (nth  9 #seri$)) ;13.�K�X�� XRECORD�Ȃ����װ����������B
    CG_DoorGrip               ;14.�ϐk�L��
    CG_KiKiColor              ;15.�@��F
    (ai_strrtrim #SozaiName)  ;16.WT�f�ޖ���  2000/08/10 HT ADD
    (ai_strrtrim #zaiName2)   ;17.WT�ގ����� 2000/09/25 HT ADD
    (ai_strrtrim #SozaiName2) ;18.WT�f�ޖ��� 2000/09/25 HT ADD
  )
)
;SKB_GetHeadList

;;;01/09/25YM@DEL;;;<HOM>***********************************************************************
;;;01/09/25YM@DEL;;; <�֐���>    : PH_OutPutDoorInfo
;;;01/09/25YM@DEL;;; <�����T�v>  : ���I��ύX�̏����o�͂���
;;;01/09/25YM@DEL;;; <�߂�l>    : �Ȃ�
;;;01/09/25YM@DEL;;; <�쐬>      : 01/09/19 YM
;;;01/09/25YM@DEL;;; <���l>      : DoorInfo.CFG
;;;01/09/25YM@DEL;;;***********************************************************************>HOM<
;;;01/09/25YM@DEL(defun PH_OutPutDoorInfo (
;;;01/09/25YM@DEL	&sym$ ; ����ِ}�`ؽ�
;;;01/09/25YM@DEL  /
;;;01/09/25YM@DEL	#FP #HINBAN #KOSU #LR #SFNAME
;;;01/09/25YM@DEL	)
;;;01/09/25YM@DEL	(if &sym$
;;;01/09/25YM@DEL		(progn
;;;01/09/25YM@DEL			(setq #sFname (strcat CG_KENMEI_PATH "DoorInfo.CFG"))
;;;01/09/25YM@DEL			(setq #kosu (itoa (length &sym$)))
;;;01/09/25YM@DEL		  ;// �t�@�C���ւ̏�������
;;;01/09/25YM@DEL		  (setq #fp  (open #sFname "w"))
;;;01/09/25YM@DEL		  (princ   ";;; �e�����t�H���_�ɒu��"           #fp)
;;;01/09/25YM@DEL		  (princ "\n;;;"                                #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; DRSeriCode= : ��SERIES�L��"   #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; DRColCode=  : ��COLOR�L��"     #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; KOSU=       : ��"             #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; HINBAN=     : �i�Ԗ���"         #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; LR=         : LR�敪"           #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; �ȉ������J��Ԃ�"             #fp)
;;;01/09/25YM@DEL		  (princ "\n;;;"                                #fp)
;;;01/09/25YM@DEL		  (princ (strcat "\nDRSeriCode=" CG_DRSeriCode) #fp)
;;;01/09/25YM@DEL		  (princ (strcat "\nDRColCode="   CG_DRColCode) #fp)
;;;01/09/25YM@DEL		  (princ (strcat "\nKOSU="               #kosu) #fp)
;;;01/09/25YM@DEL			(foreach #sym &sym$
;;;01/09/25YM@DEL		    (setq #hinban (nth 5 (CFGetXData #sym "G_LSYM")))
;;;01/09/25YM@DEL		    (setq #LR     (nth 6 (CFGetXData #sym "G_LSYM")))
;;;01/09/25YM@DEL			  (princ (strcat "\nHINBAN="         #hinban) #fp)
;;;01/09/25YM@DEL			  (princ (strcat "\nLR="                 #LR) #fp)
;;;01/09/25YM@DEL			)
;;;01/09/25YM@DEL		  (princ "\n;;;END\n"                                  #fp)
;;;01/09/25YM@DEL		  (close #fp)
;;;01/09/25YM@DEL		)
;;;01/09/25YM@DEL	);_if
;;;01/09/25YM@DEL  (princ)
;;;01/09/25YM@DEL);PH_OutPutDoorInfo

;;;<HOM>***********************************************************************
;;; <�֐���>    : PH_OutPutDoorInfo
;;; <�����T�v>  : ���I��ύX�̏����o�͂���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/09/25 YM
;;; <���l>      : DoorInfo.CFG
;;;               01/10/05 YM �S�ʏ�������(̫�ϯĕύX)
;;;***********************************************************************>HOM<
(defun PH_OutPutDoorInfo (
  /
	#DRCOLCODE #FP #HINBAN #HIN_LR$ #I #J #KOSU #LIS$ #LR #SFNAME #SS #XD$ #SERI$
	#DRSERICODE #HIN_LR$$ #K #RET$
	)

		;--------------------------------------------------------------------
		; 01/10/05 YM �����װ��ؽĂ𕪂���
		;--------------------------------------------------------------------
		(defun ##SameColList (
			&lis$$
			; ������
			;(("AG" "MSK14324" "R")
			; ("AG" "MSK14322" "R")
			; ("AJ" "MSK14322" "R")
			; ("AJ" "MSK14324" "R"))
		  /
			#COL #COL$$ #COL$$$ #DUM$$
			)
			(setq #dum$$ nil)
			(setq #col$$$ nil)
			(foreach #lis$ &lis$$
				(if (member #lis$ #dum$$)
					nil ; ���ɍl������
					(progn
						(setq #col (car #lis$)) ; �װ
						; �����װ�����W�߂�
						(setq #col$$ nil)
						(foreach #elm$ &lis$$
							(if (= #col (car #elm$)) ; �װ
								(progn
									(setq #col$$ (append #col$$ (list #elm$))) ; �W�߂����̂��i�[
									(setq #dum$$ (append #dum$$ (list #elm$))) ; ���ɍl����������
								)
							);_if
						);foreach
						(setq #col$$$ (append #col$$$ (list #col$$)))
					)
				);_if
			);foreach
			#col$$$
		);##SameColList
		;--------------------------------------------------------------------

  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DRSeriCode (nth 3 #seri$)); 4.��SERIES�L��
      (setq CG_DRColCode  (nth 4 #seri$)); 5.��COLOR�L��
		)
	);_if

  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
			(setq #i 0)
			(setq #HIN_LR$ nil)
			(repeat (sslength #ss)
      	(if (= CG_SKK_ONE_CAB (CFGetSymSKKCode (ssname #ss #i) 1))
					(progn ; ����ȯĂ�����
						(setq #xd$ (CFGetXData (ssname #ss #i) "G_LSYM"))
				    (setq #hinban     (nth 5 #xd$))
				    (setq #LR         (nth 6 #xd$))
						(setq #DRColCode  (nth 7 #xd$)) ; "��ذ��,��װ�L��"
						(setq #ret$ (StrParse #DRColCode ",")) ; 01/10/11 YM MOD ":"->","
						(setq #DRSeriCode (car  #ret$))
						(setq #DRColCode  (cadr #ret$))
; Xdata�̾�Č��� PCD_AlignDoor ---> 01/09/25 YM ADD-S G_LSYM�ɔ�װ��Ă���
						(if (and #DRColCode (/= #DRColCode "")
										 (/= #DRColCode  CG_DRColCode ))
							(progn
								; #DRColCode,#DRSeriCode �ǉ��@01/10/05 YM
								(setq #lis$ (list #DRColCode #DRSeriCode #hinban #LR))
								(setq #HIN_LR$ (append #HIN_LR$ (list #lis$)))
							)
						);_if
					)
				);_if
        (setq #i (1+ #i))
      )
    )
  );_if

	(setq #HIN_LR$ (CFListSort #HIN_LR$ 0)) ; (�װ,�i��,LR)��ؽĂ�װ�ſ�Ă���
	(setq #HIN_LR$$ (##SameColList #HIN_LR$)) ; �����װ���Ƃ�ؽĂŕ�����

	(setq #sFname (strcat CG_KENMEI_PATH "DoorInfo.CFG"))

;;;01/10/30YM@DEL	; 01/10/25 HN S-ADD
;;;01/10/30YM@DEL	(if (= nil CG_ColMix)
;;;01/10/30YM@DEL		(setq CG_ColMix (cadr (assoc "Patname" (ReadIniFile #sFname))))
;;;01/10/30YM@DEL	)
;;;01/10/30YM@DEL	; 01/10/25 HN S-ADD

  ;// �t�@�C���ւ̏�������
  (setq #fp  (open #sFname "w"))
  (princ ";;; �e�����t�H���_�ɒu��(���ς�̃^�C�~���O�ōX�V)" #fp)
  (princ "\n;;;"                                              #fp)
  (princ "\n;;; *** �}�ʂƂ͈قȂ�(��ذ��,��װ) ***"        #fp)
  (princ "\n;;; DRSeriCode= : ��SERIES�L��"                 #fp)
  (princ "\n;;; DRColCode=  : ��COLOR�L��"                   #fp)
  (princ "\n;;; KOSU=       : ����ȯĂ̐�"                    #fp)
  (princ "\n;;; HINBAN?=    : �i�Ԗ���"                       #fp)
  (princ "\n;;; LR?=        : LR�敪"                         #fp)
  (princ "\n;;; �ȉ������J��Ԃ�"                           #fp)
  (princ "\n;;; *************************************"        #fp)
  (princ "\n;;; �ȉ��}�ʂƈقȂ�(��ذ��,��װ)�̕��J��Ԃ�"  #fp)
  (princ "\n;;;"                                              #fp)
  (princ "\n;;;-----------------------------------------"     #fp)

	(if #HIN_LR$$
		(progn
			(setq #j 1)
			(foreach #HIN_LR$ #HIN_LR$$
				(setq #kosu (itoa (length #HIN_LR$)))
				(setq #DRColCode  (car  (car #HIN_LR$)))
				(setq #DRSeriCode (cadr (car #HIN_LR$)))
			  (princ (strcat "\n[Info" (itoa #j) "]" ) #fp)
			  (princ (strcat "\nDRSeriCode="           #DRSeriCode) #fp)
			  (princ (strcat "\nDRColCode="             #DRColCode) #fp)
			  (princ (strcat "\nKOSU="                       #kosu) #fp)
				(setq #k 1)
				(foreach #HIN_LR #HIN_LR$
			    (setq #hinban (nth 2 #HIN_LR))
			    (setq #LR     (nth 3 #HIN_LR))
				  (princ (strcat "\nHINBAN" (itoa #k) "=" #hinban)    #fp)
				  (princ (strcat "\nLR"     (itoa #k) "=" #LR)        #fp)
					(setq #k (1+ #k))
				)
				(setq #j (1+ #j))
			)

;;;01/10/30YM@DEL			; 01/10/11 YM ADD-S
;;;01/10/30YM@DEL			(if (= nil CG_ColMix)(setq CG_ColMix ""))
;;;01/10/30YM@DEL		  (princ "\n[ColorMixPattern]"   #fp)
;;;01/10/30YM@DEL		  (princ (strcat "\nPatname=" CG_ColMix) #fp)
;;;01/10/30YM@DEL;;;[ColorMixPattern]
;;;01/10/30YM@DEL;;;Patname=�y��MIX���z.�~�b�N�X���� <--- հ�ް���������ύX���ɑI��
;;;01/10/30YM@DEL			; 01/10/11 YM ADD-E


		  (princ "\n;;;END\n"                                     #fp)
		  (close #fp)
		)
	);_if
  (princ)
);PH_OutPutDoorInfo

(princ)

