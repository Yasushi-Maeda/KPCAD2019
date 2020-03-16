(setq CG_DimOffLen 50)
(setq CG_DimSDispIgnoreMax 120.0)		; 01/03/05 TM ADD �{�H���@�̂����A���@�l�����̒l�ȉ��̂��͕̂\�����Ȃ�

;<HOM>*************************************************************************
; <�֐���>    : SCFDrawDimensionPl
; <�����T�v>  : ���ʐ}�̐��@��������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/02/28
; <���l>      : �e�W�J�}�i���ʁj���쐬�ς݂ł��邱��
;*************************************************************************>MOH<
(defun SCFDrawDimensionPl (
	&dimpat$    ; �o�̓p�^�[�� (((�L���r�l�b�g���@ �{�H���@ �����E���E�E �c��) (�p�^�[�� �p�^�[���E�E�E))
	&Zumen      ; �}�ʎ�� ���i�} : "02"  �{�H�} : "03"	2000/07/10 HT ADD
	/
	#clayer 		; ���݂̉�w
	#pen$				; �o�}�`�̃��X�g
	#sui 				; ������\���o�_
	#pten$			; P�_�}�`
	#model$ #flg #ang$ #ang #ss$ #ssall #bpt #basept #entlast
	#zok$ #ss #pm$ #pt$ #iti #drawflg #upt$ #dpt #all$ #iti$
	#ssWt       ; ���[�N�g�b�v�̑I���Z�b�g
	#bUTypeflg  ; ���[�N�g�b�v��U�^�܂�
	#suiAttr$		; �}�`�������X�g 01/02/16 TM   �Ƃ肠���������̂�
	#eSKDM			; �g������
	#iti_sekou	; �{�H���@�̏I���ʒu
	#model_bak$	; ���f���f�[�^�̃o�b�N�A�b�v�p
	#model			; �P��p�x�̃��f���f�[�^
	#mmm$       ; ���f���f�[�^ foreach���[�v�p  01/08/17 HN ADD
	#enSym$     ; 04/03/24 SK ADD
	#taimen$    ; �Ζʏ�� 04/03/24 SK ADD
	#ftpType    ; �t���b�g�Ζʃv�����^�C�v "SF":�Z�~�t���b�g "FF":�t���t���b�g
	#counterPt
	#pm$$				; 09/11/30 T.Arimoto Add ���[�g��
	#pt$$				; 09/11/30 T.Arimoto Add ���[�g��
	#fpm1
	#all2$
	)
	;-----  �����ݒ�  -----
	;(setvar "CMDECHO" 1)
	(setq #clayer (getvar "CLAYER"))
	(setvar "CLAYER" "0_DIM")
	;----------------------
	; P�_�AP�ʊl��
	; ((����_ �����_ ���@�_) (�O�`�� �V���N�� �R������))
	; �o�_�̃f�[�^��((����) �o�_���W)
	; �o�ʂ̃f�[�^��((����) �Ίp���W�P �Ίp���W�Q)
	(setq #pen$ (SCFGetPEntity "0_PLANE"))

	; 01/07/25 TM ADD ZAN ���ӏ�����ǉ�
	;
	;   �I�I�I���ӁI�I�I
	;
	;   �����ŁA��L�֐�����Ԃ��Ă���l���ȍ~�̏����ɓs���������悤�ɕύX���Ă���B
	;   ���݂ł͎g�p���Ă��Ȃ��f�[�^���܂܂�Ă��邽�߁A���ۂɂ́u�s���̂悢�v�f�[�^��
	;   �Ȃ��Ă��Ȃ����A�֐��̈����̕ύX�̓s����A���̂܂܂ɂȂ��Ă���B
	;
	;   �ύX�O�̃f�[�^�͏�LP�ʁAP�_�l���̍��̒ʂ�
	;
	;   �ύX��̃f�[�^��
	;  (�����f�[�^ �o�_�f�[�^ �o�ʃf�[�^)
	;  �����f�[�^   ���ݎg�p���Ă��Ȃ�(���W ID)
	;  �o�_�f�[�^�� (���W ... )  �{�H���@�_�̂݁H
	;  �o�ʃf�[�^�� ((���W�P ���W�Q)  ...) �O�`�� �V���N�� �R������
	;  �f�[�^�����݂��Ȃ��ꍇ�� nil
	;
	;  �O�`�f�[�^�͌���(01/07/25)�ł̓L�b�`���̏ꍇ�̂ݑ��݂���
	;
	;          �����f�[�^�̂ݒǉ�  �擪�ȊO  �e�}�`��     P�ʂ�
	(setq #pen$ (cons #sui (mapcar 'cdr (mapcar 'car (cadr #pen$)))))
	; DEBUG (princ "\n#pen$: ")
	; DEBUG (princ #pen$)

	(setq #ssall (ssget "X" '((-3 ("G_SKDM")))))

	;���f���𕪂���
	; �_�~�[�_G_SKDM�̂����A"K" "W"���L�b�`���A"D"�����[�ɂ���B
	; �������p�x���ɂ킯��B
	(setq #model$ (DivSymByLayoutPl))
	(if #model$
		(progn
			; ����ɁA�꒼����ɂ�����̂��܂Ƃ߂�
			(setq #model$ (DivAngPtH #model$))

			; 01/07/30 TM DEBUG
			;DEBUG (princ "\n�V���{�����W: ")
			;DEBUG (princ (car #model$))
			;DEBUG (foreach #kkk (caddr (car #model$))
			;DEBUG 	(princ "\n�_��: ")
			;DEBUG 	(setq #jjj 0)
			;DEBUG 	(repeat (sslength (cadr #kkk))
			;DEBUG 		(princ (cdr (assoc 10 (entget (ssname (cadr #kkk) #jjj)))))
			;DEBUG 		(setq #jjj (1+ #jjj))
			;DEBUG 	)
			;DEBUG )
			; 01/07/30 TM DEBUG
			; 01/07/30 TM MOD-S �b��Ή�
			(setq #model_bak$ #model$)
			(setq #model$ '())
			(foreach #mmm$ #model_bak$
				; 01/07/30 TM ZAN �Ƃ肠�����Q�ȏ゠��ꍇ�́A"K" �݂̂ɂ��Ă݂�
				; ??? "D" �������Ă���ꍇ�̈Ӗ����悭������Ȃ�
				(if (< 1 (length (nth 2 #mmm$)))
					;01/08/17 HN S-MOD "K"���Ȃ��ꍇ�̏�����ǉ�
					;@MOD@(setq #mmm$ (list (nth 0 #mmm$) (nth 1 #mmm$) (list (assoc "K" (nth 2 #mmm$)))))
					(if (assoc "K" (nth 2 #mmm$))
						;01/08/20 HN S-MOD "D"�̏�����ǉ�
						; ���ǁA"K","D"�̏��ɕ��ёւ����̂�
						;@MOD@(setq #mmm$ (list (nth 0 #mmm$) (nth 1 #mmm$) (list (assoc "K" (nth 2 #mmm$)))))
						(if (assoc "D" (nth 2 #mmm$))
							(setq #mmm$ (list (nth 0 #mmm$) (nth 1 #mmm$) (list (assoc "K" (nth 2 #mmm$)) (assoc "D" (nth 2 #mmm$)))))
							(setq #mmm$ (list (nth 0 #mmm$) (nth 1 #mmm$) (list (assoc "K" (nth 2 #mmm$))                          )))
						)
						;01/08/20 HN E-MOD "D"�̏�����ǉ�
						(setq #mmm$ (list (nth 0 #mmm$) (nth 1 #mmm$) (nth 2 #mmm$)))
					)
					;01/08/17 HN E-MOD "K"���Ȃ��ꍇ�̏�����ǉ�
				)
				;01/08/17 HN MOD �f�o�b�O�����C��
				;@MOD@;DEBUG (princ "\n���f���f�[�^")
				;@MOD@;DEBUG (princ #mm$)
				;DEBUG (princ "\n���f���f�[�^: ")(princ #mmm$) ;DEBUG-HN
				;DEBUG (princ "\nsslength: ")(princ (sslength (cadr (car (nth 2 #mmm$))))) ;DEBUG-HN
				(if #model$
					(setq #model$ (append #model$ (list #mmm$)))
					(setq #model$ (list #mmm$))
				)
			)
			;@DEL@; 01/07/30 TM MOD-E  �b��Ή�

			; (DivAngPtH)�́A
			; ���}�̂悤�Ɉ꒼����ɂ����ė���Ă�����̂���ʂ��Ď擾
			;
			;
			;     --------XXX-------
			;    |                  |  <== �S�� + �T�C�h�p�l�����@
			;     -- -----    --- --
			;    |  |     |  |   |  |  <== ���̑��̐��@
			;     --------    ------
			;    |cab cab |  | cab  |
			;     --------    ------
			;

			; ���[�N�g�b�v��ނ� U �^�̎� �t���O�����Ă�
			(setq #ssWt  (ssget "X" (list (list -3 (list "G_WRKT")))))
			(setq #bUTypeflg (SCF_IsUType #ssWt))

			;�p�x���ɐ��@����}

			(foreach #ang$ #model$

				;�p�x�ύX
				(setq #ang (car   #ang$))
				(setq #ss$ (caddr #ang$))

				;�V���{����]
;				(setq #ssall (En$2Ss (apply 'append (mapcar 'Ss2En$ (mapcar 'cadr #ss$)))))
				(setq #bpt (cdrassoc 10 (entget (ssname #ssall 0))))
				(RotateSymDin #bpt #ssall #ang "F" nil)

				;�{�H���@��_�Z�o
				(setq #basept (GetBasePtByPlane #ss$ #ang (nth 2 &dimpat$)))

		    (if #basept ;2011/09/30 YM ADD
		      (progn

				(setq #iti$ '())

				;01/08/20 HN S-ADD ��_=nil�̏ꍇ�A�]���̕��@�ōď����i�Ƃ肠�����̑Ή��j
;				(if (= nil #basept)
;					(progn
;						(setq #ang (car   #ang$))
;						(setq #ss$ (caddr #ang$))
;						;�V���{����]
;						(setq #ssall (En$2Ss (apply 'append (mapcar 'Ss2En$ (mapcar 'cadr #ss$)))))
;						(setq #bpt (cdrassoc 10 (entget (ssname #ssall 0))))
;						(RotateSymDin #bpt #ssall #ang "F" nil)
;						(setq #basept (GetBasePtByPlane #ss$ #ang (nth 2 &dimpat$)))
;					)
;				);_if
				;01/08/20 HN E-ADD ��_=nil�̏ꍇ�A�]���̕��@�ōď����i�Ƃ肠�����̑Ή��j

				(setq #enSym$ nil)
				(foreach #zok$ #ss$
					(foreach #en (Ss2En$ (cadr #zok$))
						(if (/= nil (CFGetXData #en "G_LSYM"))
							(if (equal #ang (nth 2 (CFGetXData #en "G_LSYM")) 0.01)
								(setq #enSym$ (cons #en #enSym$))
							)
						)
					)
				)
				(setq #taimen$ (SCFGetTaimenFlatPlanInfo #enSym$))
				(if #taimen$
					(setq #basept (list (car #basept) (+ (cadr #basept) (car #taimen$)) (caddr #basept)))
				)
				(setq #counterPt (GetKitchenCounterBackPos #ang$))
				(if #counterPt
					(if (< (cadr #basept) (cadr #counterPt))
						(setq #basept (list (car #basept) (cadr #counterPt) (caddr #basept)))
					)
				)

;|
				;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
				;04/03/24 SK ADD-S �Ζʃv�����Ή�
				(if (setq #ftpType (SCFIsTaimenFlatPlan))
					(progn
						; ���@��}�Ώۂ̃V���{���擾
						(foreach #zok$ #ss$
							(setq #enSym$ (append #enSym$ (Ss2En$ (cadr #zok$))))
						)
						; �Ζʑ��ƂȂ�L���r�̉��s���Ɖ��s���p�x�����߂�
						;2008/08/14 YM DEL D105,D970�͒����ޯ������Ȃ̂ŁA#taimen$��nil�łȂ���D900��nil���Ԃ��Ă���
;;;		        (setq #taimen$ (SCFGetTaimenFlatPlanInfo #enSym$))

						;2008/08/13 YM MOD WOODONE��nil���Ԃ�==>�����ޯ�����i����=117�ɂ�����l���Ԃ��Ă���
						;07/07/12 YM ADD �ش��D=880�Ή�

								;#ang + (rtos 90)
;;;								(setq #taimen$ (list 220.0 1.5708))

						;�Ζ����ݎ��̒���
						(cond
							((= "D105" (nth 7 CG_GLOBAL$))
							 	;�����ޯ��D=200
								(setq #taimen$ (list 400.0 1.5708))
						 	)

							;2009/04/17 YM ADD-S
							((= "D650" (nth 7 CG_GLOBAL$));�ް�����"G*"
							 	;�����ޯ��D=100
								(setq #taimen$ (list 350.0 1.5708))
						 	)
							;2009/04/17 YM ADD-E

							((= "D970" (nth 7 CG_GLOBAL$))
							 	;�����ޯ��D=130
								(setq #taimen$ (list 320.0 1.5708))
						 	)
							((= "D900" (nth 7 CG_GLOBAL$))
							 	;�����ޯ���Ȃ�
								(setq #taimen$ (list 250.0 1.5708))
						 	)
							(T
								(setq #taimen$ (list 400.0 1.5708))
						 	)
						);_cond


						; ���@��}�J�n�_�����s�������������ʒu�ɒ�������
						(if #taimen$
							(setq #basept (list (car #basept) (+ (cadr #basept) (car #taimen$) 30.)))
						)
					)
				)
				;04/03/24 SK ADD-E �Ζʃv�����Ή�
				;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
|;
				;GET ENTLAST
				(setq #entlast (entlast))

				(setq #pm$$ nil)
				(setq #pt$$ nil)

				(foreach #zok$ #ss$

					(if (or (and (/= #taimen$ nil) (= (car #zok$) "D"))
									(and (= (car (car #ss$)) "K") (= (car #zok$) "D"))) ; P�^�̏ꍇ
						(princ)
						(progn
							(setq #ss (cadr #zok$))
							(setq #pm$ nil)

							; 01/07/12 TM MOD �L�b�`���^�_�C�j���O���p�ɕύX
							; ��P�_,P�ʎ擾
							;   #pm$: �i���� �O�`�̈� �V���N�� �R������ �{�H���@�f�[�^�j
							;    01/02/23 TM MOD �{�H���@�̕��ʐ}�\���̂��߁A
							;    �{�H���@�_�̂݁A(((X, Y, Z) . �}�`ID) ....) �̃��X�g�ɕύX
							;    ����ȊO�͓_��
							;			(if (= "K" (car #zok$))
							;				(setq #pm$ (GetPenByPlane #pen$ #ss #ang #bpt))
							;				(setq #pm$ (list nil nil nil nil))
							;			)
							; 01/07/12 TM MOD �L�b�`���^�_�C�j���O���p�ɕύX
							; ��P�_,P�ʎ擾
							;   #pm$: �i���� �O�`�̈� �V���N�� �R������ �{�H���@�f�[�^�j
							;    �{�H���@�_�̂݁A(((X, Y, Z) . �}�`ID) ....) �̃��X�g
							;    ����ȊO�͓_��
							(setq #pm$ (GetPenByPlane #pen$ #ss #ang #bpt (car #zok$)))
							(setq #pm$$ (append #pm$$ (list (list (cadr #zok$) #pm$))))
							; 01/07/12 TM MOD �L�b�`���^�_�C�j���O���p�ɕύX
							; DEBUG (princ "\nP�}�`�擾(#pm$):\n  ")
							; DEBUG (princ #pm$)

							;���W�擾
							; SCF_Pln_GetSym_Kit�̖߂�l0�߂͏��nil
							; �L�b�`���̏ꍇ�inil �L���r�l�b�g �V���N�E�R�����O�` �S��-�S�́{�T�C�h�p�l���j
							;                �V���N�E�R�����O�`���g�p
							; ���[�̏ꍇ�i�L���r�l�b�g nil nil �S��-�S�́{�T�C�h�p�l���j
							; 01/07/13 TM MOD �L�b�`���^�_�C�j���O�̊֐������ʉ�
							;			(if (= "K" (car #zok$))
							;				(setq #pt$  (SCF_Pln_GetSym_Kit #ss #pm$ #ang)) ; �L�b�`��
							;				(setq #pt$  (SCF_Pln_GetSym_Din #ss      #ang)) ; �_�C�j���O
							;			)
							; 01/07/13 TM MOD �L�b�`���^�_�C�j���O�̊֐������ʉ�
							(setq #pt$  (SCF_Pln_GetSym_Kit #ss #pm$ #ang (car #zok$)))
							(setq #pt$$ (append #pt$$ (list (list (car #zok$) #pt$))))
							; DEBUG (princ "\n���@���W���擾(#pt$):  \n")
							; DEBUG (princ #pt$)

						)
					);_if
				);(foreach #zok$ #ss$

				(if #bUTypeflg
					(setq #iti_sekou 1)
					(setq #iti_sekou 0)
				);_if

				(setq #fpm1 nil)
				(foreach #pm$ #pm$$
					(setq #fpm1 (or #fpm1 (nth 4 (nth 1 #pm$))))
					(if #bUTypeflg
						(setq #iti 1)
						(setq #iti 0)
					)

					; �{�H���@��}�t���OON (==�{�H�}�̍�}) �̏ꍇ
					; 01/09/09 HN MOD �{�H���@��}�̔��菈����ύX
					;@MOD@(if (and (= "1" (nth 1 &dimpat$)) (/= &Zumen CG_OUTSHOHINZU))
					(if (= "1" (nth 1 &dimpat$))
						(progn
							; �{�H���@�_�E����
							(if (or (/= nil (nth 0 (nth 1 #pm$))) (/= nil (nth 4 (nth 1 #pm$))))
								(progn
									(setq #iti (DrawDimPtenByPlane #iti #basept (nth 0 (nth 1 #pm$)) (nth 4 (nth 1 #pm$)) #ang))
									(if (> #iti #iti_sekou)
										(setq #iti_sekou #iti)
									)
								)
							)
						) ;_progn
					);_if (and (= "1" (nth 1 &dimpat$)) (/= &Xuman CG_OUTSHOHINZU))

				);foreach #pm$ #pm$$

				(foreach #pt$ #pt$$

					; �L���r�l�b�g���@��}�t���OON �܂��� ���i�}��}���w��̏ꍇ
					(if (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU))
						(progn
							;; #pt$ �̓��e:
							;;  (��V���N�E�R���������@ ��L���r�l�b�g���@ ���L���r�l�b�g���@ �S�́{�T�C�h�p�l��)
							;;

							; �{�H���@�ʒu
							(setq #iti #iti_sekou)

							; �㑤 �L���r�l�b�g�����@(�_�C�j���O�̂ݑ��݂���)
							(if (/= nil (nth 1 (nth 1 #pt$)))
								(progn
									; 01/08/17 HN DEL �s�v�ȃf�o�b�O�����폜
									;@DEL@(princ (car #zok$))
									;@DEL@(princ "\n�Ȃ�ł����ɁH")
									;@DEL@(princ (nth 1 #pt$))
									(setq #drawflg T)

									(setq #upt$ (nth 1 (nth 1 #pt$)))

									; �{�H�}�̏ꍇ�A���{�H���@������ꍇ�̂ݐ��@���𑫐؂肷��
									(if (and (/= nil #fpm1) (/= 0 #iti))
										(progn
											(setq #basept (polar #basept (* 0.5 PI) (GetDimHeight #iti)))
											(setq #dpt  (polar #basept (* 0.5 PI) CG_DimHeight_1Line))
											; 01/07/25 TM  ??
											(setq #iti -1.5)
											; 2017/06/12 KY ADD-S
											; �t���[���L�b�`���Ή�
											(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
												(setq #iti -0.5)
											)
											; 2017/06/12 KY ADD-E
										)
										(progn
											(setq #dpt  (polar #basept (* 0.5 PI) (GetDimHeight #iti)))
											(setq #iti (1+ #iti))
										)
									)
									; �ʏ�_�C�j���O:�L���r�l�b�g�����@
									; lipple�̏ꍇ �V���N�^�R��������
									(SCFDrawDimLin #upt$ #basept #dpt "H")
								)
							)

							; �㑤 �L���r�l�b�g���@
							(if (/= nil (nth 0 (nth 1 #pt$)))
								(progn
									(setq #drawflg T)
									(setq #upt$ (nth 0 (nth 1 #pt$)))

									; �{�H�}�̏ꍇ�A���{�H���@������ꍇ�̂ݐ��@���𑫐؂肷��
									(if (and (/= nil #fpm1) (/= 0 #iti))
										(progn
											(setq #basept (polar #basept (* 0.5 PI) (GetDimHeight #iti)))
											(setq #dpt  (polar #basept (* 0.5 PI) CG_DimHeight_1Line))
											; 01/07/25 TM  ??
											(setq #iti -0.5)
										)
										(progn
											(setq #dpt  (polar #basept (* 0.5 PI) (GetDimHeight #iti)))
											(setq #iti (1+ #iti))
										)
									)
									; �_�C�j���O�^�L�b�`�� �S�̐��@
									(SCFDrawDimLin #upt$ #basept #dpt "H");�����i�}�����@�A�{�H�}�S�̐��@(��)��

									;2018/10/03 YM ADD-S ���@�_�ɉ~������
;;;									(foreach #upt #upt$
;;;										(command "_circle" #upt 30.0)
;;;									);foreach
;;;									(command "_circle" #basept 50.0)
;;;									(command "_REGEN")
									;2018/10/03 YM ADD-E

								)
							);_if

							; �����L���r�l�b�g���@
							(if (/= nil (nth 2 (nth 1 #pt$)))
								(progn
									;��
									(if (/= nil #flg)
										(progn
											(setq #drawflg T)
											(setq #dpt$ (nth 2 (nth 1 #pt$)))
											(setq #bpd  (GetBasePtDown #ss))
											(setq #dpt (polar #bpd (* 1.5 PI) (GetDimHeight 1)))
											(SCFDrawDimLin #dpt$ #bpd #dpt "H")
										)
									)
								)
							)
;-- 2012/03/27 A.Satoh Add - S
							(setq CG_PlanType "SD")
;-- 2012/03/27 A.Satoh Add - E
							; �O�`���@�f�[�^�𒙂���(�L�b�`��)
							(if (/= nil (nth 3 (nth 1 #pt$)))
								(progn
									(if (= (nth 0 #pt$) "K")
;-- 2012/03/27 A.Satoh Add - S
										(progn
;-- 2012/03/27 A.Satoh Add - E
										(setq #all$ (append #all$ (nth 3 (nth 1 #pt$))))
;-- 2012/03/27 A.Satoh Add - S
											(setq CG_PlanType "SK")
										)
;-- 2012/03/27 A.Satoh Add - E
									)
									(setq #all2$ (append #all2$ (nth 3 (nth 1 #pt$))))
								)
							)
						)
					);_if (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU))

					(setq #iti$ (cons #iti #iti$))
					(setq #iti nil)
				);_foreach #zok$ #ss$

				; �㑤�O�`���@(�L�b�`���p)
				(if  (and (/= nil #all$) (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU)))
					(progn
						(setq #iti (apply 'max #iti$))
						(setq #drawflg T)
						;�����i�}�S�̐��@(��)�A�{�H�}�S�̐��@(��)��
						(SCFDrawDimLin #all$ #basept (polar #basept (* 0.5 PI) (GetDimHeight #iti)) "H")

						;2018/10/03 YM ADD-S ���@�_�ɉ~������
;;;									(foreach #all #all$
;;;										(command "_circle" #all 60.0)
;;;									);foreach
;;;									(command "_circle" #basept 100.0)
;;;									(command "_REGEN")
						;2018/10/03 YM ADD-E ���@�_�ɉ~������

					)
				);_if
				(if (and (= CG_PlanType "SD") (/= nil #all2$) (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU)))
					(progn
						(if (not #iti)
							(setq #iti (- (apply 'max #iti$) 1))
						)
						(setq #all2$ (2dto3d (PtSort (3dto2d #all2$) 0.0 T)))
						(if (> (length #all2$) 2)
							(progn
								(setq #all2$ (list (car #all2$) (last #all2$)))
								(SCFDrawDimLin #all2$ #basept (polar #basept (* 0.5 PI) (GetDimHeight (1+ #iti))) "H")
							)
						)
					)
				);_if

    	);2011/09/30 YM ADD
		);_if

				(setq #all$ nil)
				(setq #all2$ nil)
				(setq #iti nil)
				;�V���{����]
				(RotateSymDin #bpt #ssall #ang "B" #entlast)
			)
			; ���̐��@����}
			; ���@��}�t���O��ON ���� �{�H�}�܂��͏��i�}���@��ON �̏ꍇ
			(if (and (/= nil #drawflg) (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU)))
				(DrawSideDimPl #model$)
			)
		)
	)
	(setvar "CLAYER" #clayer)
	(princ)
);SCFDrawDimensionPl

;<HOM>*************************************************************************
; <�֐���>    : DivSymByLayoutPl
; <�����T�v>  : ���C�A�E�g��̃V���{���𕪂���
; <�߂�l>    : �i�i�p�x �I���Z�b�g���X�g�j�c�j
; <�쐬>      : 00/02/28
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun DivSymByLayoutPl (
	/
	#ss #i #en #ed$ #en$ #data$ #no #dd #tk$ #tw$ #td$ #kd$ #wd$ #dd$ #flg
	#ssk #ssw #ang$ #ang$$ #ang #ret$
	#nCode$	    ; ���iCODE
	#iCnt       ; �J�E���^
	)
	(setq #ss (ssget "X" (list (list -3 (list "G_SKDM")))))
	(if (/= nil #ss)
		(progn
			;���f���ԍ����ɕ�����
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				; ((���f���ԍ� ���f���t���O �}�`��) ...)�̃��X�g���쐬
				; 01/05/15 TM ADD ��̂��`�F�b�N���āA�V���{���Ɋ܂߂Ȃ�

				(if (CheckSKK$ #en (list (itoa CG_SKK_ONE_KUT)(itoa CG_SKK_TWO_KUT)(itoa CG_SKK_TWO_KUT))) ; 01/08/31 YM MOD ��۰��ى�
					nil ; "G_LSYM"���� and ��̂̂Ƃ�
					(if (= nil (CheckSKK$ #en (list "9" "0" "0")))  ; 02/03/26 HN ADD ���̑��@���ΏۊO�Ƃ���
						(setq #en$ (cons (list (nth 2 #ed$) (nth 1 #ed$) #en) #en$))
					)
				);_if

				(setq #i (1+ #i))
			)
			; ���f���ԍ��Ń\�[�g
			(setq #data$ (SCFmg_sort$ 'car #en$))
			(if #data$
				(progn
					(setq #no (nth 0 (nth 0 #data$)))
					(foreach #dd #data$
						(princ "\n")(princ (list (nth 0 #dd) (cfgetxdata (nth 2 #dd) "G_LSYM")))
						; �ŏ��Ƃ����Ӗ��H ZAN  01/05/14 TM ADD
						(if (= #no (nth 0 #dd))
							(progn
								(cond
									((= "K" (nth 1 #dd))  (setq #tk$ (cons (cdr #dd) #tk$)))
									((= "W" (nth 1 #dd))  (setq #tw$ (cons (cdr #dd) #tw$)))
									((= "D" (nth 1 #dd))  (setq #td$ (cons (cdr #dd) #td$)))
								)
							)
							(progn
								(if (/= nil #tk$)
									(setq #kd$ (cons (En$2Ss (mapcar 'cadr #tk$)) #kd$))
									(setq #kd$ (cons nil                          #kd$))
								)
								(if (/= nil #tw$)
									(setq #wd$ (cons (En$2Ss (mapcar 'cadr #tw$)) #wd$))
									(setq #wd$ (cons nil                          #wd$))
								)
								(if (/= nil #td$)
									(setq #dd$ (cons (En$2Ss (mapcar 'cadr #td$)) #dd$))
								)
								(setq #tk$ nil)
								(setq #tw$ nil)
								(setq #td$ nil)
								(cond
									((= "K" (nth 1 #dd))  (setq #tk$ (cons (cdr #dd) #tk$)))
									((= "W" (nth 1 #dd))  (setq #tw$ (cons (cdr #dd) #tw$)))
									((= "D" (nth 1 #dd))  (setq #td$ (cons (cdr #dd) #td$)))
								)
								(setq #no   (car #dd))
								(setq #flg nil)
							)
						)
					)

					(if (/= nil #tk$)
						(setq #kd$ (cons (En$2Ss (mapcar 'cadr #tk$)) #kd$))
						(setq #kd$ (cons nil                          #kd$))
					)
					(if (/= nil #tw$)
						(setq #wd$ (cons (En$2Ss (mapcar 'cadr #tw$)) #wd$))
						(setq #wd$ (cons nil                          #wd$))
					)
					(if (/= nil #td$)
						(setq #dd$ (cons (En$2Ss (mapcar 'cadr #td$)) #dd$))
					)
					;�e���f���̊p�x���Z�o
					;�L�b�`��
					(mapcar
					 '(lambda ( #ssk #ssw )
							(if (/= nil #ssk)
								(progn

									;�Q�p�x���l��
									(setq #ang$ (GetAnglePlan #ssw #ssk))
									;���X�g�Ɋi�[
									(setq #ang$$ (cons (car #ang$) #ang$$))
									(if (/= nil (cadr #ang$))
										(setq #ang$$ (cons (cadr #ang$) #ang$$))
									)
								)
							)
						)
						#kd$ #wd$
					)
					;�_�C�j���O
					(foreach #ss #dd$
						; 01/09/09 HN S-MOD �p�x�擾������ύX
						; �����^�����ȊO�̕��ނ͖�������
						;@MOD@(setq #ang (nth 2 (CfGetXData (ssname #ss 0) "G_LSYM")))
						(setq #iCnt 0)
						(if #ss
							(while (> (sslength #ss) #iCnt)
			 					(setq #ang (nth 2 (CfGetXData (ssname #ss #iCnt) "G_LSYM")))
								; �����������Ȃ烋�[�v�𔲂���
								(if (equal 0.0 (rem #ang (/ PI 2.0)) 0.00001)
									(setq #iCnt (sslength #ss))
									(setq #iCnt (1+ #iCnt))
								)
							)
						)
						; 01/09/09 HN E-MOD �p�x�擾������ύX
						(setq #ang$$ (cons (list #ang "D" #ss) #ang$$))
					)
					;�����p�x�ł܂Ƃ߂�
					(setq #ret$ (CollectAngle #ang$$))
				)
			)
		)
	)

	#ret$
);_DivSymByLayoutPl

;<HOM>*************************************************************************
; <�֐���>    : GetAnglePlan
; <�����T�v>  : �e���f���̊p�x���Z�o
; <�߂�l>    : �i
;                 �i�p�x ���f���t���O �I���Z�b�g���X�g�j
;                 �i�p�x ���f���t���O �I���Z�b�g���X�g�jL�^�̎��̂�
;               �j
; <�쐬>      : 00/02/29
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun GetAnglePlan (
	&ssw        ; ���f���̑I���G���e�B�e�B"W"
	&ssk        ; ���f���̑I���G���e�B�e�B"K"
	/
	#en #ed$ #pt #pt0$ #pt1$ #pt2$ #pt3$ #pt4$ #pt5$ #ang1 #ss1 #ryo$
	#tpt$ #ret1$ #ang2 #ss2 #ret2$

	#ss  ; ���[�N�g�b�v�̑I���Z�b�g
	#pt$ ; ���[�N�g�b�v�̒��_���X�g
	)

	(mapcar
	 '(lambda ( #en )
			(setq #ed$ (CfGetXData #en "G_SKDM"))
			(setq #pt  (cdrassoc 10 (entget #en)))
			(cond
				((= 0 (nth 3 #ed$))  (setq #pt0$ (list #pt #en)))
				((= 1 (nth 3 #ed$))  (setq #pt1$ (list #pt #en)))
				((= 2 (nth 3 #ed$))  (setq #pt2$ (list #pt #en)))
				((= 3 (nth 3 #ed$))  (setq #pt3$ (list #pt #en)))
				((= 4 (nth 3 #ed$))  (setq #pt4$ (list #pt #en)))
				((= 5 (nth 3 #ed$))  (setq #pt5$ (list #pt #en)))
			)
		)
		(Ss2En$ &ssw)
	)

	(setq #ang1 (Angle0to360 (+ (* PI 0.5) (angle (car #pt1$) (car #pt2$)))))
	(setq #ss1  (ssadd))
	(ssadd (cadr #pt0$) #ss1)
	(ssadd (cadr #pt1$) #ss1)
	(ssadd (cadr #pt2$) #ss1)
	(setq #ryo$ (list (car #pt0$) (car #pt1$) (car #pt2$)))
	(mapcar
	 '(lambda ( #en )
			(setq #tpt$ (GetSym4Pt #en))

			;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
			;04/03/24 SK S-MOD �Ζʃv�����Ή�
			;�T�C�h�p�l���͖������ɑΏۂɂ���
			(if (= CG_SKK_ONE_SID (CFGetSymSKKCode #en 1))
				(progn
					(ssadd #en #ss1)
				)
			;else
				(if
					(or
						(JudgeNaiugaiAng #ryo$ #ang1 (nth 0 #tpt$))
						(JudgeNaiugaiAng #ryo$ #ang1 (nth 1 #tpt$))
					)
					(ssadd #en #ss1)
				)
			)
			;04/03/24 SK E-MOD �Ζʃv�����Ή�
			;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

		)
		(Ss2En$ &ssk)
	)
	(setq #ret1$ (list #ang1 "K" #ss1))
	(if (/= nil #pt3$)
		(progn
			(setq #ang2 (Angle0to360 (+ (* PI 0.5) (angle (car #pt3$) (car #pt4$)))))
			(setq #ss2 (ssadd))
			(ssadd (cadr #pt0$) #ss2)
			(ssadd (cadr #pt3$) #ss2)
			(ssadd (cadr #pt4$) #ss2)
			(setq #ryo$ (list (car #pt0$) (car #pt3$) (car #pt4$)))
			(mapcar
			 '(lambda ( #en )
					(setq #tpt$ (GetSym4Pt #en))
					(if
						(or
							(JudgeNaiugaiAng #ryo$ #ang2 (nth 0 #tpt$))
							(JudgeNaiugaiAng #ryo$ #ang2 (nth 1 #tpt$))
						)
						(ssadd #en #ss2)
					)
				)
				(Ss2En$ &ssk)
			)
			(if (/= nil #pt5$)
				(progn
					(setq #ang5_1 (Angle0to360 (angle (car #pt0$) (car #pt5$))))
					(setq #ang5_2 (Angle0to360 (+ PI (angle (car #pt0$) (car #pt5$)))))
					(setq #ang1   (Angle0to360 #ang1))
					(setq #ang2   (Angle0to360 #ang2))
					(cond
						((or (equal #ang5_1 #ang1 0.01) (equal #ang5_2 #ang1 0.01))
							(ssadd (cadr #pt5$) #ss1)
						)
						((or (equal #ang5_1 #ang2 0.01) (equal #ang5_2 #ang2 0.01))
							(ssadd (cadr #pt5$) #ss2)
						)
						(T
							nil
						)
					)
				)
			)
			(setq #ret2$ (list #ang2 "K" #ss2))
		)
	)

	(list #ret1$ #ret2$)
) ; GetAnglePlan

;<HOM>*************************************************************************
; <�֐���>    : CollectAngle
; <�����T�v>  : ���X�g�̑��v�f�ł܂Ƃ߂�
; <�߂�l>    :
; <�쐬>      : 00/01/20
; <���l>      : �Ȃ�(+ PI)
;*************************************************************************>MOH<
(defun CollectAngle (
	&ang$       ; ���X�g
	/
	#ang$$ #i #tang #tmp$ #ret$
	)
	(setq #ang$$ (SCFmg_sort$ 'car &ang$))
	(setq #i 0)
	(repeat (length #ang$$)
		(if (= nil #tang)
			(setq #tang (car (nth #i #ang$$)))
		)
		(if (equal #tang (car (nth #i #ang$$)) 0.01)
			(progn
				(setq #tmp$ (cons (cdr (nth #i #ang$$)) #tmp$))
			)
			(progn
				(setq #ret$ (cons (list #tang (reverse #tmp$)) #ret$))
				(setq #tmp$ (list (cdr (nth #i #ang$$))))
				(setq #tang (car (nth #i #ang$$)))
			)
		)
		(setq #i (1+ #i))
	)
	(if (/= nil #tmp$)
		(setq #ret$ (cons (list #tang (reverse #tmp$)) #ret$))
	)

	(reverse #ret$)
)

;<HOM>*************************************************************************
; <�֐���>    : GetPenByPlane
; <�����T�v>  : �e���f���̈����P�_,P�ʊl��
; <�߂�l>    : P�_,P�ʃ��X�g�i���� �O�`�̈� �V���N�� �R������ �{�H���@�_���X�g�j
; <�쐬>      : 00/02/29
; <���l>      : 01/07/24 TM MOD �L�b�`���^�_�C�j���O���p�ɕύX
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun GetKitchenCounterBackPos (
	&ang$
	/
	#ssw #ssskdm #en #ed$ #ang #i #ss$ #ss #no #cpt$
	)
	(setq #ssw (ssadd))
	(setq #ssskdm (ssget "X" (list (list -3 (list "G_SKDM")))))
	(if (/= nil #ssskdm)
		(progn
			(setq #i 0)
			(repeat (sslength #ssskdm)
				(setq #en (ssname #ssskdm #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				(if (= (nth 1 #ed$) "W")
					(ssadd #en #ssw)
				)
				(setq #i (1+ #i))
			)
		)
	)
	(if (< 0 (sslength #ssw))
		(progn
			(setq #ang (car &ang$))
			(foreach #ss$ (caddr &ang$)
				(if (= (car #ss$) "K")
					(progn
						(setq #ss (cadr #ss$))
						(if (< 0 (sslength #ss))
							(progn
								(setq #en (ssname #ss 0))
								(setq #ed$ (CfGetXData #en "G_SKDM"))
								(setq #no (nth 2 #ed$))
								(setq #i 0)
								(repeat (sslength #ssw)
									(setq #en (ssname #ssw #i))
									(setq #ed$ (CfGetXData #en "G_SKDM"))
									(if (= #no (nth 2 #ed$))
										(setq #cpt$ (cons (cdrassoc 10 (entget #en)) #cpt$))
									)
									(setq #i (1+ #i))
								)
							)
						)
					)
				)
			)
		)
	)
	(if (/= #cpt$ nil)
		(last (SCFmg_sort$ 'cadr #cpt$))
		nil
	)
)

;<HOM>*************************************************************************
; <�֐���>    : GetPenByPlane
; <�����T�v>  : �e���f���̈����P�_,P�ʊl��
; <�߂�l>    : P�_,P�ʃ��X�g�i���� �O�`�̈� �V���N�� �R������ �{�H���@�_���X�g�j
; <�쐬>      : 00/02/29
; <���l>      : 01/07/24 TM MOD �L�b�`���^�_�C�j���O���p�ɕύX
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun GetPenByPlane (
	&pen$       ; P�_,P�ʃ��X�g
	&ss         ; �V���{���I���G���e�B�e�B
	&ang        ; ���f����]�p�x
	&bpt        ; ��_
	&KorD				; �L�b�`��"K" �^ �_�C�j���O "D"
	/
	#i #en #10 #pt$ #minmax #ryo$ #ang #pt1_n$ #pt2_n$ #ret$ #ss #ed$ #pt_n
	#sekou$	; �{�H���@�_��
	#eXd$ 	; �g���f�[�^
	#dPt$		; ����ϐ�
	#pt0$
	)

	; �V���{���̍��W���l��
	(setq #i 0)
	(repeat (sslength &ss)
		(setq #en  (ssname &ss #i))
		(if (= &KorD "K")
			; �L�b�`���̏ꍇ
			(progn
				(setq #10  (cdrassoc 10 (entget #en)))
				(setq #pt$ (cons #10 #pt$))
			)
			(progn
				; �g���f�[�^������̂ŁA�l�������߂�
				(if (CfGetXData #en "G_SYM")
					(progn
						(setq #dPt$ (GetSym4Pt #en))
						(if #pt$
							(setq #pt$ (append #pt$ #dPt$))
							(setq #pt$ #dPt$)
						)
					)
				)
			)
		)
		(setq #i   (1+ #i))
	);_repeat
	; DEBUG (princ "\n�S���W: \n")
	; DEBUG (princ #pt$)

	; �̈���W���X�g�쐬(�ő���̗̈���Ƃ�)
	(if #pt$
		(progn
			(setq #minmax (GetPtMinMax #pt$))
			(if #minmax
				(setq #ryo$
					(list
						(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
						(list (car (car  #minmax)) (cadr (car  #minmax)) 0.0)
						(list (car (cadr #minmax)) (cadr (car  #minmax)) 0.0)
						(list (car (cadr #minmax)) (cadr (cadr #minmax)) 0.0)
						(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
					)
				)
				(setq #ryo$ nil)
			)
		)
	)
	; DEBUG(princ "\n�̈�: ")
	; DEBUG(princ #ryo$)
	(if #ryo$
		(progn
			; ��]�p�x
			(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))

			;���W�ϊ�
			; �o�_
			(if (/= nil (car &pen$))
				(setq #pt1_n$
					(mapcar
						'(lambda (#pen)
							(pt1jiHenkanB &bpt #pen #ang)
						)
						(car &pen$)
					)
				)
				(setq #pt1_n$ nil)
			)
			; �o��
			(setq #pt2_n$
				(mapcar
				 '(lambda ( #pt$ )
						(if (/= nil #pt$)
							(list
								(pt1jiHenkanB &bpt (car #pt$) #ang)
								(pt1jiHenkanB &bpt (cadr #pt$) #ang)
							)
							nil
						)
					)
					(cdr &pen$) ; P��
				)
			)

			; �̈���̂o�}�`�l��
			; �o�_
			(if (and (/= nil #pt1_n$) (JudgeNaigai #pt1_n$ #ryo$))
				(setq #ret$ (cons #pt1_n$ #ret$))
				(setq #ret$ (cons nil     #ret$))
			)
			; �o��
			(foreach #pt$ #pt2_n$
				(if
					(and
						(/= nil (car #pt$))
						(JudgeNaigai (car  #pt$) #ryo$)
						(JudgeNaigai (cadr #pt$) #ryo$)
					)
					(setq #ret$ (cons #pt$ #ret$))
					(setq #ret$ (cons nil  #ret$))
				)
			)

			; �{�H���@�_�{�}�`�h�c
			(setq #ss (ssget "X" (list (list -3 (list "G_PTEN")))))
			(if #ss
				(progn
				(setq #i 0)
				(repeat (sslength #ss)
					(setq #en (ssname #ss #i))
					(setq #ed$ (CFGetXData #en "G_PTEN"))
					; �{�H���@�_ = 9
					(if (= 9 (nth 0 #ed$))
						(progn
							(setq #10 (cdrassoc 10 (entget #en)))
							(setq #pt_n (pt1jiHenkanB &bpt #10 #ang))
							(if (JudgeNaigai #pt_n #ryo$)
								(progn
									; 01/02/23 TM ADD �}�`ID (nth 2 #ed$)  ��ǉ�
									(setq #pt_n (cons #pt_n (nth 2 #ed$)))
									(setq #sekou$ (cons #pt_n #sekou$))
								)
							)
						)
					)
					(setq #i (1+ #i))
					)
					(progn
					;;; (princ "�{�H���@�_������܂���B(G_PTEN ���݂��Ȃ�)") 2000/10/24 �s�v
					)
				)
			)

			(reverse (cons #sekou$ #ret$))
		)
		(list nil nil nil nil nil)
	)
)

;<HOM>*************************************************************************
; <�֐���>    : SCF_Pln_GetSym_Kit
; <�����T�v>  : ���@���W�l��  �L�b�`�����_�C�j���O
; <�߂�l>    : ���@���W���X�g
; <�쐬>      : 00/03/01
;             : 01/07/13 TM MOD �L�b�`����p���_�C�j���O�ł��g����悤�ɕύX
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCF_Pln_GetSym_Kit (
	&ss         ; �I���G���e�B�e�B
	&pen$       ; P�}�`���X�g
	&ang        ; ��]�p�x
	&KorD				; "K" �L�b�`�� "D" �_�C�j���O
	/
	#ang #i #en #10 #ed$ #pt$ #pts$ #ptc$ #code$ #pt1 #edl$ #eds$ #angle
	#w #pt2
	#pt1$ #pt2$ #pt3$ #pt4$	; �e�i�̐��@�_��
	#fWideAng   ; �L�p�x�R�[�i�[�p�x
	#ang2
	#xDin$			; �_�C�j���O�p�H
	#ftpType
;;;	#frm_flg		; �c�t���[���p�̃t���O
;;;	#ptc2$$
	#pttmp #pttmp$
	)
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	;04/06/16 SK ADD-S �Ζʃv�����Ή�
	(setq #ftpType (SCFIsTaimenFlatPlan))
	;04/06/16 SK ADD-E �Ζʃv�����Ή�
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	;���W�ϊ�
	(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))

;;; 	; 2017/06/08 KY ADD-S
;;; 	; �t���[���L�b�`���Ή�
;;;	(setq #ptc2$$ nil)
;;; 	; 2017/06/08 KY ADD-E

	(setq #i 0)
	(repeat (sslength &ss)
		(setq #en (ssname &ss #i))
		; 10 ��`�_? TM
		(setq #10 (cdrassoc 10 (entget #en)))
		; �g���������擾
		(setq #ed$ (CfGetXData #en "G_SKDM"))

		(if (= "W" (nth 1 #ed$))
			(progn ; ����
				(if (= 0 (nth 3 #ed$))
					(progn
						(setq #pt$  (cons #10 #pt$))
						(setq #pts$ (cons #10 #pts$))
						(setq #ptc$ (cons #10 #ptc$))
					)
				)
				(if (or (= 1 (nth 3 #ed$)) (= 3 (nth 3 #ed$)))
					(progn
						(setq #pt$  (cons #10 #pt$))
						(setq #pts$ (cons #10 #pts$))
						(setq #ptc$ (cons #10 #ptc$))
					)
				)
				(if (= 5 (nth 3 #ed$))
					(setq #pts$ (cons #10 #pts$))
				)
			)
			(progn   ;�T�C�h�p�l��
				(setq #code$ (CFGetSymSKKCode #en nil))
				(setq #pt1   (cdrassoc 10 (entget #en)))
				(setq #edl$  (CfGetXData #en "G_LSYM"))
				(setq #eds$  (CfGetXData #en "G_SYM"))
				(setq #angle (Angle0to360 (+ #ang (nth 2 #edl$))))

				; 2000/09/06 HT MOD �L�p�x�Ή� WIDECAB START
				(if (setq #fWideAng (SCFGetWideCabAng #eds$))
					(progn
					; �L�p�x�̏ꍇ
					(setq #ang2 (Angle0to360 (+ (- (* PI 2.0) #fWideAng) (nth 2 #edl$))))
						(if (equal #ang #ang2 0.01)
							(progn
		 					; D�����̊p�x����]�p�x�Ɠ������ꍇ
					 		; (W�����ł͂Ȃ��AD�������ق���)
								(setq #pt2 (polar #pt1 (+ (- (* PI 2.0) #fWideAng) #angle) (nth 4 #eds$)))
							)
						)
					)
					(progn
						; ��� (�R�[�i�[�p�x90�x�̏ꍇ)
						(setq #w     (nth 3 #eds$))
						(if (= 1 (nth 8 #eds$))
						(setq #pt2 (polar #pt1       #angle  #w))
							(setq #pt2 (polar #pt1 (+ PI #angle) #w))
						)
					)
				)
				; 2000/09/06 HT MOD �L�p�x�Ή� WIDECAB END

				(cond
					;2017/01/25 YM MOD-S
					((and (= CG_SKK_ONE_SID (nth 0 #code$)) (/= CG_SKK_TWO_UPP (nth 1 #code$))  ) ;�p�l���̂����A�A�b�p�[�����O
;;;					((= CG_SKK_ONE_SID (nth 0 #code$))
					;2017/01/25 YM MOD-E

						;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
						; �t���t���b�g�ŃL�b�`���̈�̃T�C�h�p�l���̕��ʐ��@�͕s�v�Ƃ���
						(if (and (or (= #ftpType "D105")(= #ftpType "D650")(= #ftpType "D970")(= #ftpType "D900")(= #ftpType "D750")) (= &KorD "K")) ; D750�ǉ� 2018/10/03 YM MOD
							(princ)  ;�Ȃɂ����Ȃ�
						;else
							(progn
								;2010/11 YM �V����ި ����SP���@
								;�V����ި�Ή�į�ߏ������������
								;CG_GLOBAL$=nil�łȂ��Ƃ��������
								;(setq #TOP_F (GetTopFlg))
								;#TOP_F="Y"�Ȃ珈�����΂�
								(setq #pt$  (cons #pt1 #pt$))
								(setq #pt$  (cons #pt2 #pt$))

								;2018/10/11 YM ADD
								(command "_circle" #pt1 5.0)
								(command "_circle" #pt2 5.0)
								(command "_REGEN")
								;2018/10/11 YM ADD
							)
						);_if
						;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
					)
					((and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_TWO_BAS (nth 1 #code$)))
						; 2017/06/08 KY MOD-S
						; �t���[���L�b�`���Ή�
						;(setq #ptc$ (cons #pt1 #ptc$))
						;(setq #ptc$ (cons #pt2 #ptc$))
						(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
							(progn
								; �c�t���[���ɑ΂��鐡�@�ł͂Ȃ��A�J�E���^�[�ɑ΂��鐡�@����} (2017/07/26)
;;;								(if (= 1 (GetFrameType #eds$ #edl$))
;;;									(progn
;;;										(setq #ptc2$$ (cons (list #pt1 #pt2) #ptc2$$))
;;;									);progn
;;;								);if
							);progn
							;else
							(progn
								(setq #ptc$ (cons #pt1 #ptc$))
								(setq #ptc$ (cons #pt2 #ptc$))
							);progn
						);if
						; 2017/06/08 KY MOD-E
					)
				)
				; 2017/07/26 KY ADD-S
				; �c�t���[���ɑ΂��鐡�@�ł͂Ȃ��A�J�E���^�[�ɑ΂��鐡�@����}
				(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
					(progn
						(if (equal #code$ (list CG_SKK_ONE_CNT CG_SKK_TWO_BAS CG_SKK_THR_DIN) 0.1)
							(if (IsCounter #eds$ #edl$)
								(progn
									(setq #ptc$ (cons #pt1 #ptc$))
									(setq #ptc$ (cons #pt2 #ptc$))
								);progn
							);if
						);if
					);progn
				);if
				; 2017/07/26 KY ADD-E
			)
		)
		(setq #i (1+ #i))
	)

;;;	; 2017/06/15 KY ADD-S
;;;	; �t���[���L�b�`���Ή�
;;;	;  �c�t���[���Ŏn�_X/�I�_X�����݂ɓ_��ɒǉ�
;;;	;  ���c�t���[����W���@���쐬���Ȃ�����
;;;	(if #ptc2$$
;;;		(progn
;;;			; �����l�̔�r
;;;			;   -1 : ����1 < ����2
;;;			;    0 : ����1 = ����2
;;;			;    1 : ����1 > ����2
;;;			(defun ##comp ( &d1 &d2 / )
;;;				(cond
;;;					((equal &d1 &d2 0.001)
;;;						0
;;;					)
;;;					((< &d1 &d2)
;;;						-1
;;;					)
;;;					(T
;;;						1
;;;					)
;;;				);cond
;;;			);##comp
;;;
;;;			(defun ##PtSortExtra$$ ( &pt$$ / #d1$ #d2$ #pt1s #pt1e #pt2s #pt2e #pt1 #pt2 )
;;;				(defun ###comp ( &pt1 &pt2 )
;;;					(< (+ (* 10 (##comp (nth 0 &pt1) (nth 0 &pt2)))
;;;						(##comp (nth 1 &pt1) (nth 1 &pt2))) 0)
;;;				);###comp
;;;				(vl-sort &pt$$
;;;							'(lambda ( #d1$ #d2$ )
;;;								(setq #pt1s (nth 0 #d1$))
;;;								(setq #pt1e (nth 1 #d1$))
;;;								(setq #pt2s (nth 0 #d2$))
;;;								(setq #pt2e (nth 1 #d2$))
;;;								(setq #pt1 (if (###comp #pt1s #pt1e) #pt1s #pt1e))
;;;								(setq #pt2 (if (###comp #pt2s #pt2e) #pt2s #pt2e))
;;;								(###comp #pt1 #pt2)
;;;							)
;;;				)
;;;			);##PtSortExtra
;;;
;;;			; �\�[�g
;;;			(setq #ptc2$$ (##PtSortExtra$$ #ptc2$$))
;;;
;;;			(setq #frm_flg 0)
;;;			(foreach #pttmp$ #ptc2$$
;;;				(if (= #frm_flg 0)
;;;					  (setq #ptc$ (cons (nth 0 #pttmp$) #ptc$))
;;;					  ;else
;;;					  (setq #ptc$ (cons (nth 1 #pttmp$) #ptc$))
;;;				);if
;;;        (setq #frm_flg (- 1 #frm_flg))
;;;			)
;;;		);progn
;;;	);if
	; 2017/06/15 KY ADD-S

	; 01/07/13 TM MOD-S �_�C�j���O�p�C����������
	(if (= &KorD "K")
		(progn
			(setq #pt1$ (append (nth 2 &pen$) (nth 3 &pen$) #pts$))  ; ��   �V���N�E�R������
			; #pt2$ �̓L�b�`���ɂ͕s�v
			(setq #pt2$ nil)
			(setq #pt3$ (append (nth 1 &pen$) (nth 2 &pen$) #pts$))  ; ��   �V���N�E�R�����O�`
			(setq #pt4$ #pt$)                                        ; �S�� �S�́{�T�C�h�p�l��
		)
		(progn
			; 01/07/25 TM MOD �O�����v�Z���āA�L���r�l�b�g�S�̂͂���ɔC����
			(setq #xDin$ (KCFGetCabLRSidePt (Ss2En$ &ss) &ang))
; 01/07/30 TM MOD �S�̐��@�ƃT�C�h�p�l���̐��@���L�b�`���ɍ��킹��
;  		(setq #pt1$ (append                             #pts$ #xDin$))  ; �� �V���N�E�R������
;			(setq #pt1$ (append                             #pts$ #xDin$ #pt$))  ; �� �V���N�E�R������
;			(setq #pt2$ (append (nth 2 &pen$) (nth 3 &pen$) #ptc$ #xDin$))	; �� �L���r�l�b�g�S��
			(setq #pt1$ nil)
			(setq #pt2$ (append (nth 2 &pen$) (nth 3 &pen$) #ptc$ #pts$ #xDin$))	; �� �L���r�l�b�g�S��
			(setq #pt3$ (append (nth 1 &pen$) (nth 2 &pen$) #pts$))  				; �� �V���N�E�R�����O�`
; 01/07/30 TM MOD �S�̐��@�ƃT�C�h�p�l���̐��@���L�b�`���ɍ��킹��
;  		(setq #pt4$ #pt$)                                        				; �S�� �S�́{�T�C�h�p�l��
			(setq #pt4$ nil)                                        				; �S�� �S�́{�T�C�h�p�l��
			(setq #pt4$ (append #pt1$ #pt2$))
		)
	)
	; 01/07/13 TM MOD-E �_�C�j���O�p�C����������

	(list #pt1$ #pt2$ #pt3$ #pt4$)
); SCF_Pln_GetSym_Kit

;<HOM>*************************************************************************
; <�֐���>    : SCF_Pln_GetSym_Din
; <�����T�v>  : ���@���W�l��  �_�C�j���O
; <�߂�l>    : ���@���W���X�g
; <�쐬>      : 00/03/01
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCF_Pln_GetSym_Din (
	&ss         ; �I���G���e�B�e�B
	&ang        ; ��]�p�x
	/
	#ang #en #side$ #en$ #pt1 #edl$ #eds$ #angle #w #pt2 #sidept$ #tpt$ #spt$
	)
	;���W�ϊ�
	(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))
	; �T�C�h�p�l���^�L���r�l�b�g�𕪂���
	(foreach #en (Ss2En$ &ss)
		(if (= CG_SKK_TWO_BAS (CFGetSymSKKCode #en 2))
			(if (= CG_SKK_ONE_SID (CFGetSymSKKCode #en 1))
				(progn
					(setq #side$ (cons #en #side$))  ; �T�C�h�p�l��
				)
				(progn
					; 01/06/25 TM ���iCODE�P���ڂ� 9(==���̑�or ���)�̂��̂��O��
					(if (/= CG_SKK_ONE_ETC (CFGetSymSKKCode #en 1))
						(setq #en$   (cons #en #en$))    ; �L���r�l�b�g
					)
				)
			)
		);_if (= CG_SKK_TWO_BAS (CFGetSymSKKCode #en 2))
	)

	;�T�C�h�p�l�����W�Z�o
	(if (/= nil #side$)
		(progn
			(foreach #en #side$
				(setq #pt1   (cdrassoc 10 (entget #en)))
				(setq #edl$  (CfGetXData #en "G_LSYM"))
				(setq #eds$  (CfGetXData #en "G_SYM"))
				(setq #angle (Angle0to360 (+ #ang (nth 2 #edl$))))
				(setq #w     (nth 3 #eds$))
				(if (= 1 (nth 8 #eds$))
					(setq #pt2 (polar #pt1       #angle  #w))
					(setq #pt2 (polar #pt1 (+ PI #angle) #w))
				)
				(setq #sidept$ (cons #pt1 #sidept$))
				(setq #sidept$ (cons #pt2 #sidept$))
			)
		)
	)

	;�L���r�l�b�g�̍��W�̍ō��ƍŉE�̍��W���l��
	(if (/= nil #en$)
		(progn
			(foreach #en #en$
				(setq #pt1   (cdrassoc 10 (entget #en)))
				(setq #edl$  (CfGetXData #en "G_LSYM"))
				(setq #eds$  (CfGetXData #en "G_SYM"))
				(setq #angle (Angle0to360 (+ #ang (nth 2 #edl$))))
				(setq #w     (nth 3 #eds$))
				(if (= 1 (nth 8 #eds$))
					(setq #pt2 (polar #pt1       #angle  #w))
					(setq #pt2 (polar #pt1 (+ PI #angle) #w))
				)
				(setq #tpt$ (cons #pt1 #tpt$))
				(setq #tpt$ (cons #pt2 #tpt$))
			)
			(setq #tpt$ (PtSort #tpt$ (angtof "5") T))
	;      (setq #spt$ (list (car #tpt$) (last #tpt$)))
			(setq #spt$ #tpt$)
			(setq #sidept$ (cons (car  #tpt$) #sidept$))
			(setq #sidept$ (cons (last #tpt$) #sidept$))
		)
	)

	(list #spt$ nil nil #sidept$)
) ; SCF_Pln_GetSym_Din


;<HOM>*************************************************************************
; <�֐���>    : KCFGetCabLRSidePt
; <�����T�v>  : �L���r�l�b�g�̍��W�̍ō��ƍŉE�̍��W���l��
; <�߂�l>    : �_��
; <�쐬>      : 01/07/13 TM ADD
; <���l>      :
;*************************************************************************>MOH<
(defun KCFGetCabLRSidePt (
	&en$		; �L���r�l�b�g�̐}�`���X�g
	&ang		; �}�`�̊p�x
	/
	#en				; �L���r�l�b�g�}�`
	#pt1			; �}�`��_
	#edl$			; G_LSYM �g���f�[�^
	#eds$			; G_SYM �g���f�[�^
	#angle		; �}�`�̊p�x
	#w				; W��������
	#sidept$	; �_��
	#tpt$			; ����ϐ�
	#pt2			;
	)

	;�L���r�l�b�g�̍��W�̍ō��ƍŉE�̍��W���l��
	(if (/= nil &en$)
		(progn
			(foreach #en &en$
				(setq #pt1   (cdrassoc 10 (entget #en)))
				(setq #edl$  (CfGetXData #en "G_LSYM"))
				(setq #eds$  (CfGetXData #en "G_SYM"))
				(setq #angle (Angle0to360 (+ (Angle0to360 (- (* 2.0 PI) &ang)) (nth 2 #edl$))))

				(setq #w     (nth 3 #eds$))
				; �L���r�l�b�g�����ɍ��킹��
				(if (= 1 (nth 8 #eds$))
					(setq #pt2 (polar #pt1       #angle  #w))
					(setq #pt2 (polar #pt1 (+ PI #angle) #w))
				)
				(setq #tpt$ (cons #pt1 #tpt$))
				(setq #tpt$ (cons #pt2 #tpt$))
			)
			(setq #tpt$ (PtSort #tpt$ (angtof "5") T))
			(setq #spt$ #tpt$)
			(setq #sidept$ (cons (car  #tpt$) #sidept$))
			(setq #sidept$ (cons (last #tpt$) #sidept$))
		)
	)
	#sidept$

) ; KCFGetCabLRSidePt


;<HOM>*************************************************************************
; <�֐���>    : DrawDimPtenByPlane
; <�����T�v>  : �{�H���@�E���𐡖@����}����
; <�߂�l>    : �\�������ʒu (#iti)
; <�쐬>      : 01/03/05 TM
; <���l>      : ���@��_
;               L�^�EW�^           �F�R�[�i�[�L���r��_
;               I�^                �F�R�����L���r��
;               I�^�ŃR�������Ȃ����F���E�߂��ق�
;*************************************************************************>MOH<
(defun DrawDimPtenByPlane (
	&iIti       ; ���@�ʒu
	&xBase      ; ��_
	&xSui				; �����̍��W
	&xSek$      ; �{�H���@�_ �Ƒ����̃��X�g
	&rAng				; ��}�}�`�̊p�x
	/
	#xPten$					; ���@��}�p�_�{������
	#rBase					;	���@�`��p����W
	#rSui						; ���@�`��p���@�_
	#iIti						; �\���ʒu�ϐ�
	#eEn						; ��}�}�`�G���e�B�e�B
	)

	; �����̐��@�����݂���ꍇ
	(if (/= nil &xSui)
		(progn

			; �{�s���@�_�ƈꏏ�Ƀ\�[�g���č�}���邽�߁A�{�H���@�_�Ƒ����̃f�[�^���쐬����
			; �_�~�[�̐��@�}�`ID -1 ��ǉ�����
			(setq #xPten$ (list (cons &xSui -1)))

		)
	)

	; �{�H���@�����݂���ꍇ
	(if (/= nil &xSek$)
		(progn
			; �{�H���@�_�Ƒ����f�[�^��ݒ�(�ǉ�)
			(setq #xPten$ (append #xPten$ &xSek$))
		)
	)

	; ���𐡖@�Ǝ{�H���@�����W���ɕ`�悷��
	(setq #iIti (DrawDimSekouByPlane &iIti &xBase #xPten$ &rAng))

	#iIti

)

;<HOM>*************************************************************************
; <�֐���>    : DrawDimSuisenBGByPlane
; <�����T�v>  : �����̂a�f����̐��@����}
; <�߂�l>    :
; <�쐬>      : 00/03/05 TM
; <���l>      :
;*************************************************************************>MOH<
(defun DrawDimSuisenBGByPlane (
	&xSui			; �����̍��W �Ƒ���
	&xBasePt	; ��}�̊�_
	/
	#rBGPt		;
	#xPt			; �v�Z����_
	)
	(if (/= nil &xSui)
		(progn
			; BG����̐��𐡖@����}����
			; BG ��_
			(setq #xPt (car (3dto2d &xSui)))
			(setq #rBGPt (inters &xBasePt (polar &xBasePt 0.0 10.0) #xPt (polar #xPt (* PI 0.5) 10.0) nil))
			(SCFDrawDimLin (list #rBGPt #xPt) nil (polar #xPt PI CG_DimOffLen) "V")
		)
		(progn
;			(princ "\nDrawDimSuisenBGByPlane: ")
;			(princ &xSui)
		)
	)

	(princ)
)


;; 01/03/05 TM DEL-S ���̊֐��̋@�\�� DrawDim*ByPlane �Ɉڂ��܂���
;<HOM>*************************************************************************
; <�֐���>    : DrawDimSuisenByPlane
; <�����T�v>  : ����̎{�H���@����}
; <�߂�l>    : �ʒu (1�C���N�������g�����l)
; <�쐬>      : 00/02/24
; <���l>      : ���@��_
;               L�^�EW�^           �F�R�[�i�[�L���r��_
;               I�^                �F�R�����L���r��
;               I�^�ŃR�������Ȃ����F���E�߂��ق�
;*************************************************************************>MOH<
(defun DrawDimSuisenByPlane (
;  &bpt        ; ��_
;  &ppt        ; �{�H���_
;  &iti        ; �ʒu
;  /
;  #bpt #ppt #pt
;	#eEn				; ��}�}�`�G���e�B�e�B
	)
;  (setq #bpt (car (3dto2d (list &bpt))))
;  (setq #ppt (car (3dto2d (list &ppt))))
;  ;��_����̐��@��}
;  ;(SCFDrawDimLin (list #bpt #ppt) nil (polar #bpt (* PI 0.5) (GetDimHeight 0)) "H") ;2000/09/14 DEL
;	; 01/03/05 TM MOD ZAN �b��Ή� ���@�l�����̒l�ȉ��̏ꍇ�͕\�����Ȃ��悤�ɂ���
;	(if (< CG_DimSDispIgnoreMax (abs (- (car #bpt) (car #ppt))))
;		(SCFDrawDimLin (list #bpt #ppt) nil (polar #bpt (* PI 0.5) (GetDimHeight &iti)) "H") ;2000/09/14 ADD
;	)
;
;  ;BG����̐��@��}
;  (setq #pt (inters #bpt (polar #bpt 0.0 10.0) #ppt (polar #ppt (* PI 0.5) 10.0) nil))
;  (SCFDrawDimLin (list #pt #ppt) nil (polar #ppt PI CG_DimOffLen) "V")
;
;  (1+ &iti)
	(princ "\nDrawDimSuisenByPlane: ���̊֐��͌��ݎg���Ă���܂���B\n��m���߂��������BTM")
)
;; 01/03/05 TM DEL-E ���̊֐��̋@�\�� DrawDim*nByPlane �Ɉڂ��܂���

;<HOM>*************************************************************************
; <�֐���>    : DrawDimSekouByPlane
; <�����T�v>  : �{�H���@�E��������}
; <�߂�l>    : �ʒu
; <�쐬>      : 00/02/24
;							; 01/03/05 TM ���𐡖@��}�𓝍�
; <���l>      : ���@��_
;               L�^�EW�^           �F�R�[�i�[�L���r��_
;               I�^                �F�R�����L���r��
;               I�^�ŃR�������Ȃ����F���E�߂��ق�
;*************************************************************************>MOH<
(defun DrawDimSekouByPlane (
	&iti        ; �ʒu
	&bpt        ; ��_
	&ppt$       ; �{�H���@�_ �Ƒ���
	&rAng				; ��}�}�`�̊p�x		: 01/04/24 TM ADD
	/
	#bpt #iti #ppt$ #ppt
	#eEn						; ��}�}�`�G���e�B�e�B
	#xSui$					; ���𐡖@�_��
	#xSek$					; �{�H���@�_��
	#xPten$					; ��}����_��
	#ii	#pp$	#nID	; ����ϐ�
	#rBGPt					; �a�f���@�`��p��_
	#isRotate				; ���@�쐬���]���邩�i�k�^�̂݁j
	#isRotateRight	; ���@�쐬��E������]���邩�i�k�^�̂݁j
	)
	(setq #bpt (car (3dto2d (list &bpt))))
	(setq #iti &iti)

	; �\�[�g��r�p���W����쐬 TM ADD
	(foreach #ii &ppt$
		; �{�H���@�_�Ɛ��𐡖@�_�𕪂���
		(if (= -1 (cdr #ii))
			(setq #xSui$ (append #xSui$ (list (car #ii))))
			(setq #xSek$ (append #xSek$ (list (car #ii))))
		)
	)

	; �{�H���@�_�̈ʒu�ɂ���āA���W���Ƀ\�[�g����
	; 01/02/26 TM MOD-S
	;  (if (< (car #bpt) (car (car #ppt$)))
	;    (setq #ppt$ (PtSort #ppt$ 0.0 T))
	;    (setq #ppt$ (PtSort #ppt$ PI  T))
	;  )
	; 01/02/26 TM MOD-M
	; (��ŉ�]�ړ�����) �c���@�ɂ͐����̐��@�͊܂߂Ȃ�
	(if (< (car #bpt) (car (car (car &ppt$))))
		; ���@�_����_�̉E���ɂ���ꍇ(��ŉ�]�ړ�����)
		(progn
			; �E����̏ꍇ�A�V���N������̂Ő��𐡖@�v
			(if (wcmatch CG_KitType "*-RIGHT")
				(progn
					(setq #xPten$ (PtSort (append #xSui$ #xSek$) 0.0 T))
					(DrawDimSuisenBGByPlane #xSui$ #bpt)
				)
				(progn
					(setq #xPten$ (PtSort #xSek$ 0.0 T))
				)
			)
		)
		; ���@�_����_�̍����ɂ���ꍇ
		(progn
			(if (wcmatch CG_KitType "*-RIGHT")
				(progn
					(setq #xPten$ (PtSort #xSek$ PI T))
				)
				(progn
					(setq #xPten$ (PtSort (append #xSui$ #xSek$) PI  T))
					(DrawDimSuisenBGByPlane #xSui$ #bpt)
				)
			)
		)
	)
	; 01/02/26 TM MOD-E

	; 01/04/24 TM MOD
	; ��ŉ�]�ړ����鉡���@�\�������`�F�b�N����
	; L �^�̏ꍇ�A�ŏ��ɂ��ׂĂ̐��@�������Ă���A�}�`���ƂX�O�x��]����B
	; ���̂��߁A��]��̐��@�̍��E�^�㉺�̈ʒu���t�]����ꍇ�����邽�߁A�C������B
	; �ǂ̕����ɕ��ʐ��@����}����邩���`�F�b�N���āA
	; (���ʐ}�͕K���`�����ɂȂ邱�Ƃ���) �C���̗L�������肷��

	; 01/04/24 TM ADD �v�Z�p�̊p�x==�\�����鐡�@���o�͂�������
	(setq #rDimAng (Angle0to360 (+ (* 0.5 PI) &rAng)))

	; �\�[�g�������ԂɎ{�H���@�_�Ƒ����̃��X�g����בւ���
	(foreach  #ii #xPten$
		(setq #pp$ (append #pp$ (list (assoc #ii &ppt$))))
	)
	; 01/02/26 TM MOD-E

	(foreach #ppt #pp$
		; 01/02/22 TM MOD �{�H���@�_���X�g�̃f�[�^���ɐ}�`ID ��ǉ�
		; (setq #ppt (car (3dto2d (list #ppt))))
		(setq #nID (cdr #ppt))
		(setq #ppt (car (3dto2d (list (car #ppt)))))
		; ��_����̐��@��}
		; 01/03/04 TM MOD L�^�̏c�������@�\���̗}��

		; 01/03/05 TM MOD ZAN �b��Ή� ���@�l�����̒l�ȉ��̏ꍇ�͕\�����Ȃ��悤�ɂ���
		(if (< CG_DimSDispIgnoreMax (abs (- (car #bpt) (car #ppt))))
			(progn
				; 01/04/24 TM ADD ���@�\���p�x�������i���ƉE�j�ɂȂ�ꍇ�A�\�ߕ\���ʒu�𗠕Ԃ�
				(if (or (equal #rDimAng 0 0.01) (equal #rDimAng (* 1.5 PI)))
					(progn
						(SCFDrawDimLin (list #bpt #ppt) nil (polar #bpt (* PI 0.5) (GetDimHeight #iti)) "H")
						; 01/05/31 TM MOD �{�H���@�����񂪖��o�^�̏ꍇ�ɑΉ�
						(if (SCFUpdDimStr (entlast) #nID)
							(SCFUpdDimStrPlacement (entlast) #ppt "R" (list 0.0 (- CG_DimHeight_1Line) 0.0) T)
						)
					)
					; ���񂹁E���̏�i�f�t�H���g�j
					(SCFDrawDimLinAddStr (list #bpt #ppt) nil (polar #bpt (* PI 0.5) (GetDimHeight #iti)) "H" #nID)
				)
				(setq #iti (1+ #iti))
			)
		)
	)

	#iti
) ; DrawDimSekouByPlane

;<HOM>*************************************************************************
; <�֐���>    : RotateSymDin
; <�����T�v>  : �_�C�j���O�̃��f�����p�x�ŉ�]
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/02/18
;*************************************************************************>MOH<
(defun RotateSymDin (
	&bpt        ; ��_
	&ss         ; �_�C�j���O�̃V���{���̑I���G���e�B�e�B
	&ang        ; ���f���̉�]�p�x
	&flg        ; ��}�t�F�[�Y�t���O�i"F":��}�O "B":��}��j
	&entlast    ; ��}�O��entlast
	/
	#ang #ss #en
	)
	(if (= "F" &flg)
		(progn
			(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))
			(setq #ss &ss)
		)
		(progn
			(setq #ang &ang)
			(setq #ss &ss)
			(setq #en &entlast)
			(if #en ;2011/09/30 YM ADD
				(progn
					(while (setq #en (entnext #en))
						(ssadd #en #ss)
					)
				)
			);_if ;2011/09/30 YM ADD
		)
	)
	(if (/= nil #ss)
		(progn
			(command "_rotate" #ss "" &bpt (angtos #ang (getvar "AUNITS") CG_OUTAUPREC))
		)
	)

	(princ)
) ; GetDiningAngle

;<HOM>*************************************************************************
; <�֐���>    : GetBasePtByPlane
; <�����T�v>  : �{�H���@�̊�_���擾
; <�߂�l>    : ��_
; <�쐬>      : 00/03/02
; <���l>      : L�^�EW�^           �F�R�[�i�[�L���r��_
;               I�^                �F�R�����L���r��
;               I�^�ŃR�������Ȃ����F���E�߂��ق�
;               ���j���̊֐��͐}�`����]��������ɓK�p
;*************************************************************************>MOH<
(defun GetBasePtByPlane (
	&ss$        ; �I���G���e�B�e�B���X�g
	&ang        ; ��]�p�x
	&flg        ; �o�͕����t���O�iI�^�̂ݗL���j
	/
	#zok$ #kind #ss #en #ed$ #ret #ang #pt$ #pt1 #pt2 #code$ #gas #sang
	#pt3 #ptK$
	)


	;<HOM>*************************************************************************
	; <�֐���>    : ##Get2PtAng
	; <�����T�v>  : �V���{���̊�_��W�����_��ϊ�����p�x�ŕϊ����Ċl��
	; <�߂�l>    : �Q�_���W
	;*************************************************************************>MOH<
	(defun ##Get2PtAng (
		&ang        ; �ϊ�����p�x
		&en         ; �V���{���}�`��
		/
		#pt1 #edl$ #eds$ #angle #w #pt2
		#code$ #bWflg #code$ #fWideAng
		)
		(setq #pt1   (cdrassoc 10 (entget &en)))
		(setq #edl$  (CfGetXData &en "G_LSYM"))
		(setq #eds$  (CfGetXData &en "G_SYM"))
		(setq #angle (Angle0to360 (+ &ang (nth 2 #edl$))))
		(setq #code$ (CFGetSymSKKCode &en nil))
		(setq #bWflg T) ; W���@�擾�t���O T
		; �R�[�i�[�L���r
		(if (and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_THR_CNR (nth 2 #code$)))
			(progn
				; �������ɂȂ��ꍇ
				(if (not (equal &ang (nth 2 #edl$) 0.01))
					(progn
						; D���@�擾
						(setq #pt2 (polar #pt1 #angle (nth 4 #eds$)))
						(setq #bWflg nil) ; W���@�擾�t���O nil
					)
				)
			)
		)
		(if (= #bWflg T)
			(progn
			(setq #w     (nth 3 #eds$))
			; �L���r�l�b�g�����ɕ��������킹��
			(if (= 1 (nth 8 #eds$))
				(setq #pt2 (polar #pt1       #angle  #w))
				(setq #pt2 (polar #pt1 (+ PI #angle) #w))
			)
			)
		)
		(list #pt1 #pt2)
	)
	;==============================================================================

	;<HOM>*************************************************************************
	; <�֐���>    : ##Pt$XangYmax
	; <�����T�v>  : X���W�ŏ�(�p�x0) or X���W�ő�(�p�xPI) and  Y���W�ő���擾
	; <�߂�l>    : ���W
	; <���l>      : �p�xX�����̍Ō�[�A����Y���W�ő�̍��W�����߂�(�p�x=0 or PI)
	;*************************************************************************>MOH<
	(defun ##Pt$XangYmax (
		 &pt$		; ���W��
		 &ang		; ��r��ƂȂ����
		 /
		 #pt$
		 #Ret
		 )
		 (setq #pt$ (PtSort &pt$ &ang T)) ;�������@X,Y�Ƃ��ɓ������W�̓_���Ȃ��Ă���@&ang���O�Ȃ�X���W�����������̏��Ƀ\�[�g

		 ; �擪���擾(�ŏ�����������ꍇ�ɑΉ�)
     ; vl-remove-if-not  �w�肳�ꂽ���X�g�̗v�f�̒��ŁA�e�X�g�֐��ɍ��i�������ׂĂ̗v�f��Ԃ��܂��B
     ; �������@�_�񃊃X�g�̐擪��X���W�Ɠ������_�����𒊏o���Ă���
		 (setq #pt$ (vl-remove-if-not '(lambda (#l) (= (car(car #pt$)) (car #l))) #pt$))

		 ; �擪�̂���Y�������ő�
		 (setq #Ret (car (PtSort #pt$ (- (/ PI 2.0)) T))); �������@Y���W���傫�����̏��Ƀ\�[�g���Ă���

     ; X���W�ŏ�(�p�x0) or X���W�ő�(�p�xPI) and  Y���W�ő���擾
		 ; (##Pt$XangYmax (list '(10 2 0) '(10 3 0) '(2 2 0) '(2 3 0) '(33 2 0) '(33 3 0) '(4 2 0) '(4 3 0) ) 0.0)
     ; (2 3 0)
		 #Ret
	)
	;==============================================================================


	;<HOM>*************************************************************************
	; <�֐���>    : ##Pt3Dto2D
	; <�����T�v>  : (x y z)==>(x y)
	; <�߂�l>    : ���W
	; <���l>      : 
	;*************************************************************************>MOH<
	(defun ##Pt3Dto2D (
		 &pt
		 /
		 )
		 (setq #ret (list (nth 0 &pt) (nth 1 &pt)))
		 #ret
	)
	;==============================================================================


	; 09/04/17 T.Ari Mod
	; �J�E���^�[�̈�Ԍ����擾
	; �������F�R�[�i�[�L���r��_
	(setq #ptK$ nil)
	(foreach #zok$ &ss$
		(setq #kind (car  #zok$))
		(setq #ss   (cadr #zok$))
		(if (= "K" #kind)
			(progn
				(foreach #en (Ss2En$ #ss)
					(setq #ed$ (CfGetXData #en "G_SKDM"))
					(if (= "C" (nth 5 #ed$))
						(setq #ret (cdrassoc 10 (entget #en)))
						(if (= "W" (nth 2 #ed$))
							(setq #ptK$ (cons (cdrassoc 10 (entget #en)) #ptK$))
						)
					)
				); foreach
			)
		)
	); foreach

	; �������F�w������A�܂��̓R������
	(if (= nil #ret)
		(progn
			(cond
				; ���w��
				((= "L" &flg)
					(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))
					(foreach #zok$  &ss$
						(setq #kind (car  #zok$))
						(setq #ss   (cadr #zok$))
						(if (= "K" #kind)
							(foreach #en (Ss2En$ #ss)
								(setq #ed$ (CfGetXData #en "G_SKDM"))
								(if (= "K" (nth 1 #ed$))
									(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
								)
							)
							(foreach #en (Ss2En$ #ss)
								(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
							)
						)
					)
					(setq #ret (##Pt$XangYmax #pt$ 0.0))
				)
				; �E�w��
				((= "R" &flg)
					(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))
					(foreach #zok$  &ss$
						(setq #kind (car  #zok$))
						(setq #ss   (cadr #zok$))
						(if (= "K" #kind)
							(foreach #en	(Ss2En$ #ss)
								(setq #ed$ (CfGetXData #en "G_SKDM"))
								(if (= "K" (nth 1 #ed$))
									(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
								)
							)
							(foreach #en (Ss2En$ #ss)
								(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
							)
						)
					)
					(setq #ret (##Pt$XangYmax #pt$ PI))
				)
				; �����ݒ�(�R����������ꍇ�A�R������)
				((= "A" &flg)
					;���W�ϊ�
					(setq #ang (Angle0to360 (- (* 2.0 PI) &ang)))
					(foreach #zok$ &ss$
						(setq #kind (car  #zok$))
						(setq #ss   (cadr #zok$))
						; �L�b�`���L���r�l�b�g
						(if (= "K" #kind)
							(progn
								(foreach #en (Ss2En$ #ss)
									(setq #ed$ (CfGetXData #en "G_SKDM"))
									(cond
										; ��_
										((and (= "W" (nth 1 #ed$)) (= 0 (nth 3 #ed$)))
											(setq #pt1 (cdrassoc 10 (entget #en)))
										)
										; W�����_
										((and (= "W" (nth 1 #ed$)) (= 1 (nth 3 #ed$)))
											(setq #pt2 (cdrassoc 10 (entget #en)))
										)
										; D�����_
										((and (= "W" (nth 1 #ed$)) (= 3 (nth 3 #ed$)))
											(setq #pt2 (cdrassoc 10 (entget #en)))
										)
										; �L�b�`���L���r
										((= "K" (nth 1 #ed$))
											(setq #code$ (CFGetSymSKKCode #en nil))
											(if (= CG_SKK_ONE_CAB (nth 0 #code$))
												(progn
													; �R�����L���r�̏ꍇ�R�������擾
													(if
													 (and
														 (= CG_SKK_TWO_BAS (nth 1 #code$))
														 (= CG_SKK_THR_GAS (nth 2 #code$))
													 )
													 (setq #gas (cdrassoc 10 (entget #en)))
													)
													; �L���r�l�b�g�̂Q�_���擾
													(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
												)
											)
											; 2000/09/20 HT END
										)
									)
								); foreach

								; ��_�̊ԂɃR����������ꍇ�A�R�����ɋ߂�������ɕ����ݒ肷��
								(if (/= nil #gas)
									(progn
										(if
											(and
												(< (distance #pt1 #gas) (distance #pt2 #pt1))
												(< (distance #pt2 #gas) (distance #pt2 #pt1))
											)
											(progn
												(if (< (distance #pt1 #gas) (distance #pt2 #gas))
													(progn
														(setq #sang (angle #pt1 #pt2))
													)
													(progn
														(setq #sang (angle #pt2 #pt1))
													)
												) ;if (< (distance #pt1 #gas) (distance #pt2 #gas))

												(setq #ret (##Pt$XangYmax #pt$ #sang))
											)
										); if
									)
								);if (/= nil #gas)
								; 09/04/17 T.Ari Mod �J�E���^�[�w�ʂ̃��C������_�ɏC��
								(if (and (/= nil #ret) (/= nil #ptK$))
									(setq #ret
										(list
											(nth 0 #ret)
											(nth 1 (car (PtSort (cons #ret #ptK$) (- (/ PI 2.0)) T)))
											(nth 2 #ret)
										)
									)
								)
							)
							(progn
								(foreach #en (Ss2En$ #ss)
										(setq #pt$ (append #pt$ (##Get2PtAng #ang #en)))
										(setq #code$ (CFGetSymSKKCode #en nil))
										(if
										 (and
											 (= CG_SKK_TWO_BAS (nth 1 #code$))
											 (= CG_SKK_THR_GAS (nth 2 #code$))
										 )
										 (if (= (nth 6 (CfGetXData #en "G_LSYM")) "L")
											 (setq #gas (nth 1 (##Get2PtAng #ang #en)))
											 (setq #gas (cdrassoc 10 (entget #en)))
										 )
										)
									)
								; 06/09/27 T.Ari Mod-S ���[�N�g�b�v���Ȃ��R�����L���r������v�����Ή�
									(if #gas
										(progn
											(setq #pt1 (##Pt$XangYmax #pt$ 0.0))
											(setq #pt2 (##Pt$XangYmax #pt$ PI))
											(if
												(and
													(<= (distance (##Pt3Dto2D #pt1) (##Pt3Dto2D #gas)) (distance (##Pt3Dto2D #pt2) (##Pt3Dto2D #pt1)) )
													(<= (distance (##Pt3Dto2D #pt2) (##Pt3Dto2D #gas)) (distance (##Pt3Dto2D #pt2) (##Pt3Dto2D #pt1)) )
												)
												(progn
													(if (< (distance (##Pt3Dto2D #pt1) (##Pt3Dto2D #gas)) (distance (##Pt3Dto2D #pt2) (##Pt3Dto2D #gas)))
														(progn
															(setq #sang (angle #pt1 #pt2))
														)
														(progn
															(setq #sang (angle #pt2 #pt1))
														)
													) ;if (< (distance #pt1 #gas) (distance #pt2 #gas))

													(setq #ret (##Pt$XangYmax #pt$ #sang))
												)
											); if
										)
									);_if
								; 06/09/27 T.Ari Mod-E ���[�N�g�b�v���Ȃ��R�����L���r������v�����Ή�
								)
							) ;if (= "K" #kind)
						) ;foreach #zok$ &ss$
					) ;(= "A" &flg)
				);cond
			)
		);if (= nil #ret)

		; ��O�����F���E�߂��ق�
		(if (= nil #ret)
			(progn
				(setq #ret (##Pt$XangYmax #pt$ 0.0))
			)
		)

	#ret
) ; GetBasePtByPlane

;<HOM>*************************************************************************
; <�֐���>    : JudgeNaiugaiAng
; <�����T�v>  : �p�x�t�����O����
; <�߂�l>    : T�F��   nil�F�O
; <�쐬>      : 00/03/02
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun JudgeNaiugaiAng (
	&pt$        ; �̈���W���X�g
	&ang        ; �p�x
	&pt         ; ������W
	/
	#ang #pt #pt$ #minmax #ryo$
	)
	;�̈�l��
	(setq #ang (Angle0to360 (- 0.0 &ang)))
	(mapcar
	 '(lambda ( #pt )
			(setq #pt$ (cons (pt1jihenkan #pt #ang) #pt$))
		)
		&pt$
	)
	;�̈���W���X�g�l��
	(setq #minmax (GetPtMinMax #pt$))
	(setq #ryo$
		(list
			(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
			(list (car (car  #minmax)) (cadr (car  #minmax)) 0.0)
			(list (car (cadr #minmax)) (cadr (car  #minmax)) 0.0)
			(list (car (cadr #minmax)) (cadr (cadr #minmax)) 0.0)
			(list (car (car  #minmax)) (cadr (cadr #minmax)) 0.0)
		)
	)

	(JudgeNaigai (pt1jihenkan &pt #ang) #ryo$)
)

;<HOM>*************************************************************************
; <�֐���>    : GetBasePtDown
; <�����T�v>  : I�^�̉��̊�_���l��
; <�߂�l>    : ��_
; <�쐬>      : 00/03/03
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun GetBasePtDown (
	&ss         ; �L�b�`���I���G���e�B�e�B
	/
	#en$ #en #ed$ #ret
	)
	(setq #en$ (Ss2En$ &ss))
	(mapcar
	 '(lambda ( #en )
			(setq #ed$ (CfGetXData #en "G_SKDM"))
			(if
				(and
					(= "W" (nth 1 #ed$))
					(= 2   (nth 3 #ed$))
				)
				(setq #ret (cdrassoc 10 (entget #en)))
			)
		)
		#en$
	)

	#ret
) ; GetBasePtDown

;|
;<HOM>*************************************************************************
; <�֐���>    : DrawSideDimPl
; <�����T�v>  : ���̐��@����}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/03/02
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun DrawSideDimPl (
	&model$     ; ���������f�����X�g
	/
	#ang$ #ang #ss$ #zok$ #ss #ret$ #pt$ #pp #pt$$ #ra #ran #noang$
	#ang$$ #ang_n$$ #dim$ #dim$$ #dd
	#ssall #bpt #enSym$ #taimen$
	)

	(setq #ssall (ssget "X" '((-3 ("G_SKDM")))))

	(mapcar
	 '(lambda ( #ang$ )
			(setq #ang    (car   #ang$))
			(setq #ss$    (caddr #ang$))

			(setq #bpt (cdrassoc 10 (entget (ssname #ssall 0))))
			(RotateSymDin #bpt #ssall #ang "F" nil)

			(setq #enSym$ nil)
			(foreach #zok$ #ss$
				(foreach #en (Ss2En$ (cadr #zok$))
					(if (/= nil (CFGetXData #en "G_LSYM"))
						(if (equal #ang (nth 2 (CFGetXData #en "G_LSYM")) 0.01)
							(setq #enSym$ (cons #en #enSym$))
						)
					)
				)
			)
			(setq #taimen$ (SCFGetTaimenFlatPlanInfo #enSym$))
			(RotateSymDin #bpt #ssall #ang "B" (entlast))

			(mapcar
			 '(lambda ( #zok$ )
					(if (and (/= #taimen$ nil) (= (car #zok$) "D"))
						(princ)
						(progn
							(setq #ss (cadr #zok$))
							;���W�l��
							(if (= "K" (car #zok$))
								(setq #ret$ (SCF_Sid_GetSym_Kit #ss))  ; �L�b�`��
								(setq #ret$ (SCF_Sid_GetSym_Din #ss))  ; �_�C�j���O
							)
							(setq #pt$ (car #ret$))

							;���W���X�g
							(mapcar
							 '(lambda ( #pp )
									(setq #pt$$ (cons #pp #pt$$))
								)
								#pt$
							)
							;�p�x
							(mapcar
							 '(lambda ( #ra )
									(setq #ran (Angle0to360 (car #ra)))
									(setq #noang (list (angtos #ran) (rtos (cadr #ra) 2 2)))
									(if (not (member #noang #noang$))
										(setq #noang$ (cons #noang #noang$))
									)
								)
								(cadr #ret$)
							)
						)
					)
				)
				#ss$
			)
		)
		&model$
	);_mapcar

	;�p�x�ł܂Ƃ߂�
	(setq #ang$$ (CollectAngle #pt$$))

	;�����ł܂Ƃ߂�
	(setq #ang$$ (DivAngPt #ang$$))

	;�o�͂��Ă͂����Ȃ��p�x���Ȃ�
	(mapcar
	 '(lambda ( #ang$ )
			(setq #noang (list (angtos (car #ang$)) (rtos (cadr #ang$) 2 2)))
			(if (not (member #noang #noang$))
				(progn
					(setq #ang_n$$ (cons #ang$ #ang_n$$))
				)
			)
		)
		#ang$$
	)
	;�D�揇�ʌ���I
	(mapcar
	 '(lambda ( #pt$ )
			(setq #dim$ (JudgePriority (car #pt$) (caddr #pt$)))
			(setq #dim$$ (cons #dim$ #dim$$))
		)
		#ang_n$$
	)
	;���@��}
	(mapcar
	 '(lambda ( #dd )
			(SCFDrawDimAlig (car #dd) (cadr #dd))
		)
		#dim$$
	)

	(princ)
) ; DrawSideDimPl
|;
;<HOM>*************************************************************************
; <�֐���>    : DrawSideDimPl
; <�����T�v>  : ���̐��@����}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/03/02
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun DrawSideDimPl (
	&model$     ; ���������f�����X�g
	/
	#ang$ #ang #ss$ #zok$ #ss #ret$ #pt$ #pp #pt$$ #ra #ran #noang$
	#ang$$ #ang_n$$ #dim$ #dim$$ #dd
	#dd1 #dd2 #cnt
	#pt1$
	#pt2$
	#NOANG
	#lst$
	#minX #minY
	#x #y
	#ang
	#orgDimAng
	#sameAng
	#dimAng
	#ssAll$
	#pt
	#areaIn
	#areaPt$
	#en

	#bpt
	#ssall
	#enSym$
	#taimen$
	)

	(setq #ssall (ssget "X" '((-3 ("G_SKDM")))))

	(foreach #ang$ &model$
		(setq #ang (car   #ang$))
		(setq #ss$ (caddr #ang$))

		(setq #bpt (cdrassoc 10 (entget (ssname #ssall 0))))
		(RotateSymDin #bpt #ssall #ang "F" nil)

		(setq #enSym$ nil)
		(foreach #zok$ #ss$
			(foreach #en (Ss2En$ (cadr #zok$))
				(if (/= nil (CFGetXData #en "G_LSYM"))
					(if (equal #ang (nth 2 (CFGetXData #en "G_LSYM")) 0.01)
						(setq #enSym$ (cons #en #enSym$))
					)
				)
			)
		)
		(setq #taimen$ (SCFGetTaimenFlatPlanInfo #enSym$))
		(RotateSymDin #bpt #ssall #ang "B" (entlast))

		(foreach #zok$ #ss$
			(if (and (/= #taimen$ nil) (= (car #zok$) "D"))
				(princ)
				(progn
					(setq #ss (cadr #zok$))
					(setq #ssAll$ (cons #ss #ssAll$))
					;���W�l��
					(if (= "K" (car #zok$))
						(setq #ret$ (SCF_Sid_GetSym_Kit #ss))  ; �L�b�`��
						(setq #ret$ (SCF_Sid_GetSym_Din #ss))  ; �_�C�j���O
					)
					(setq #pt$ (car #ret$))
					;���W���X�g
					(foreach #pp #pt$
						(setq #pt$$ (cons #pp #pt$$))
					)
					;�p�x
					(foreach #ra (cadr #ret$)
						(setq #ran (Angle0to360 (car #ra)))
						(setq #noang (list (angtos #ran) (rtos (cadr #ra) 2 2)))
						(if (not (member #noang #noang$))
							(setq #noang$ (cons #noang #noang$))
						)
					)
				)
			)
		)
	)
	;�p�x�ł܂Ƃ߂�
	(setq #ang$$ (CollectAngle #pt$$))
	;�����ł܂Ƃ߂�
	(setq #ang$$ (DivAngPt #ang$$))
	;�o�͂��Ă͂����Ȃ��p�x���Ȃ�
	(foreach #ang$ #ang$$

		(setq #ang (angtos (car #ang$)))
		(setq #noang (list #ang (rtos (cadr #ang$) 2 2)))
		;---------------------------------------------------------------
		;�ł��[�̕��ނ݂̂�ΏۂƂ��Đ��@�o�͏����擾����
		;�i���@�̏d�Ȃ���������邽�߁j
		;---------------------------------------------------------------
		(if (not (member #noang #noang$))
			(progn
				; ���@��_�������Ő��@�p�x���Ⴄ���̂��Ȃ����𒲂ׂ�
				(setq #orgDimAng nil)
				(setq #sameAng T)
				(foreach #lst$ (caddr #ang$)
					(setq #dimAng (angtos (angle (car (car (cadr #lst$))) (cadr (car (cadr #lst$))))))
					(if (= #orgDimAng nil)
						(setq #orgDimAng #dimAng)
						(progn
							(if (/= #dimAng #orgDimAng)
								(setq #sameAng nil)
							)
						)
					)
				)
				; ���@�p�x�������ł���΁A��ԊO���̐��@�ʒu�����߂�
				(if #sameAng
					(progn
						;�e���ʂł̈�Ԓ[�ƂȂ鐡�@�Ώۂ̏������o����
						(setq #maxX 0)
						(setq #maxY 0)
						(setq #minX 100000)
						(setq #minY 100000)

						(foreach #lst$ (caddr #ang$)
							(setq #x (car (car (car (cadr #lst$)))))
							(setq #y (cadr (car (car (cadr #lst$)))))
							(cond
								;X�̍ő�̂��̂��Ώ�
								((= #ang "0")
									(if (> #x #maxX)
										(progn
											(setq #ang$ (list (car #ang$) (cadr #ang$) (list #lst$)))
											(setq #maxX #x)
										)
									)
								)
								;Y�̍ő�̂��̂��Ώ�
								((= #ang "90")
									(if (> #y #maxY)
										(progn
											(setq #ang$ (list (car #ang$) (cadr #ang$) (list #lst$)))
											(setq #maxY #y)
										)
									)
								)
								;X�̍ŏ��̂��̂��Ώ�
								((= #ang "180")
									(if (< #x #minX)
										(progn
											(setq #ang$ (list (car #ang$) (cadr #ang$) (list #lst$)))
											(setq #minX #x)
										)
									)
								)
								;Y�̍ŏ��̂��̂��Ώ�
								((= #ang "270")
									(if (< #y #minY)
										(progn
											(setq #ang$ (list (car #ang$) (cadr #ang$) (list #lst$)))
											(setq #minY #y)
										)
									)
								)
							)
						)
					)
				)
				(setq #ang_n$$ (cons #ang$ #ang_n$$))
			)
		)
		;---------------------------------------------------------------
	)
	(setq #ss (ssget "X" '((-3 ("G_SYM")))))

	(foreach #pt1$ #ang_n$$

		(setq #ang (car #pt1$))

		(foreach #pt2$ (caddr #pt1$)
			(setq #dim$ (cadr #pt2$))
			(setq #pt$ (car #dim$))
			;----------------------------------------------------------------
			; �S�̂���L���r�l�b�g�̈���ɑ��݂���_���Ȃ����`�F�b�N����
			;   �i�R�[�i�[�g�[���L���r���ɐ��@������P�[�X�̐��@���O�Ή��j
			;----------------------------------------------------------------
			(setq #areaIn nil)
			(foreach #en (Ss2En$ #ss)
				(if (and (CFGetXData #en "G_SYM") (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1)))
					(progn
						(setq #areaPt$ (GetSymAreaPt #en))
						(setq #areaPt$ (append #areaPt$ (list (car #areaPt$))))
						(foreach #pt #pt$
							; �����O���ɂ��炳�Ȃ��Ɛ��@�̊�ƂȂ�L���r�ň����|����B
							(if (JudgeNaigai (polar #pt #ang 10) #areaPt$)
								(setq #areaIn T)
							)
						)
					)
				)
			)
			;----------------------------------------------------------------
			;�L���r�l�b�g�̈�O�ł���΍�}����
			(if (= #areaIn nil)
				(progn
					;�L�b�`���p�l���t���̐��@�̏ꍇ�͉����珇�ɂȂ�悤���W�����킹��
					(if (>= (length #pt$) 3)
						(setq #pt$ (list (last #pt$) (car #pt$) (cadr #pt$)))
					)
					;�e���ނ̉��s�����@����}����
					(setq #cnt 0)
					(repeat (1- (length #pt$))
						(setq #dd1 (nth #cnt #pt$))
						(setq #dd2 (nth (1+ #cnt) #pt$))
						(SCFDrawDimAlig (list #dd1 #dd2) (polar #dd1 #ang (GetDimHeight 0)))
						(setq #cnt (1+ #cnt))
					)
					;�L�b�`���p�l�����l�������S�̐��@�̍�}
					(if (>= (length #pt$) 3)
						(progn
							(setq #dd1 (nth 0 #pt$))
							(setq #dd2 (last  #pt$))
							(SCFDrawDimAlig (list #dd1 #dd2) (polar #dd1 #ang (GetDimHeight 1)))
						)
					)
				)
			)
		)
	)
	(princ)
) ; DrawSideDimPl


;<HOM>*************************************************************************
; <�֐���>    : SCF_Sid_GetSym_Kit
; <�����T�v>  : ���̐��@���̍��W�Ɗp�x�l��  �L�b�`��
; <�߂�l>    : ���W�Ɗp�x�l��
; <�쐬>      : 00/03/03 �ЂȂ܂�ł�
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCF_Sid_GetSym_Kit (
	&ss         ; �I���G���e�B�e�B
	/
	#en$ #en #10 #ed$ #pt0 #flg #pt1 #pt2 #ang #pt$ #rpt$ #noang$ #pt3
	)
	(setq #en$ (Ss2En$ &ss))
	(mapcar
	 '(lambda ( #en )
			(setq #10  (cdrassoc 10 (entget #en)))
			(setq #ed$ (CfGetXData #en "G_SKDM"))
			(if (= "W" (nth 1 #ed$))
				(progn
					(cond
						((= 0 (nth 3 #ed$))
							(setq #pt0 #10)
							(if (= "C" (nth 5 #ed$))
								(setq #flg T)
							)
						)
						((or (= 1 (nth 3 #ed$))(= 3 (nth 3 #ed$)))
							(setq #pt1 #10)
						)
						((or (= 2 (nth 3 #ed$))(= 4 (nth 3 #ed$)))
							(setq #pt2 #10)
						)
					)
				)
			)
		)
		#en$
	)
	(if (and (/= nil #pt0) (/= nil #pt1) (/= nil #pt2))
		(progn
			(setq #ang  (angle #pt0 #pt1))
			; 2000/07/14 HT U�^�Ή��̂��߉��̐��@�ʒu���A���点�ďd�Ȃ���Ȃ���
			;(setq #pt$  (list (list #pt1 #pt2) (polar #pt1 #ang (GetDimHeight 1))))
			(setq #pt$  (list (list #pt1 #pt2) (polar #pt1 #ang (GetDimHeight 0))))
			(setq #rpt$ (cons (list (Angle0to360 #ang) "K" #pt$) #rpt$))
			(if (/= nil #flg)
				(progn
					(setq #noang$ (cons (list (angle #pt1 #pt0) (GetBByAngPt #pt0 #ang)) #noang$))
					(setq #pt3 (polar #pt0 (angle #pt1 #pt2) (distance #pt1 #pt2)))
					(setq #pt$  (list (list #pt0 #pt3) (polar #pt0 (+ PI #ang) (GetDimHeight 1))))
					(setq #rpt$ (cons (list (Angle0to360 (+ PI #ang)) "K" #pt$) #rpt$))
				)
			)
			(setq #noang$ (cons (list (angle #pt2 #pt1) (GetBByAngPt #pt1 #ang)) #noang$))
		)
	)

	(list #rpt$ #noang$)
) ; SCF_Sid_GetSym_Kit

;<HOM>*************************************************************************
; <�֐���>    : SCF_Sid_GetSym_Din
; <�����T�v>  : ���̐��@���̍��W�Ɗp�x�l�� �_�C�j���O
; <�߂�l>    : ���W�Ɗp�x�l��
; <�쐬>      : 00/03/03
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCF_Sid_GetSym_Din (
	&ss         ; �I���G���e�B�e�B
	/
	#en$ #en #code$ #ang #pt$ #dw #enpt$ #cnpt$ #spt$ #sptcn$ #spt #ept #pp$ #sang
	#ept$ #eang #pt1$ #pt2$ #noang$
	#cntEn$ #en2$  ;2004/04/12 SK �Ζʃv�����Ή�
	#baseall$ #tmppt$ #offset #tmppt
	)
	(setq #en$ (Ss2En$ &ss))

	; 2004/04/12 SK ADD-S �Ζʃv�����Ή�
	; �_�C�j���O�J�E���^�[�́A�L���r�l�b�g���D�搡�@�ƂȂ邽�߁A
	; �ō��A�ŉE�ɂȂ鎖���l�����Ă��̎��_�Ń��X�g�̍ŏ��ɂ��Ă���
	; ���@�̗D�揇�ʂ�
	;   �T�C�h�p�l�� ���@�_�C�j���O�J�E���^�[ �� �L���r�l�b�g
	(foreach #en #en$
		(setq #code$ (CFGetSymSKKCode #en nil))
		(cond
			((= CG_SKK_ONE_CNT (nth 0 #code$))
				(setq #cntEn$ (cons #en #cntEn$))
			)
			(T
				(setq #en2$ (cons #en #en2$))
			)
		)
	)
	(setq #en$ (append #cntEn$ #en2$))
	; 2004/04/12 SK ADD-E �Ζʃv�����Ή�

	(mapcar
	 '(lambda ( #en )
			; 2000/07/25 HT + �①�ɒǉ�
			;�x�[�X�L���r�l�b�g�̂݊l��
			(setq #code$ (CFGetSymSKKCode #en nil))
			(if
				(or
					(and
						(= CG_SKK_ONE_CAB (nth 0 #code$))
						(= CG_SKK_TWO_BAS (nth 1 #code$))
					)
					(and ;�①��&�y�j���V�������j�b�g
						(equal CG_SKK_ONE_ETC (nth 0 #code$))
						(equal CG_SKK_TWO_BAS (nth 1 #code$))
						(equal CG_SKK_THR_NRM (nth 2 #code$))
					)
					; 02/03/26 HN S-ADD �J�E���^�[�V�ƃT�C�h�p�l�����Ώ�
					(= CG_SKK_ONE_CNT (nth 0 #code$))
					(and
						(= CG_SKK_ONE_SID (nth 0 #code$))
						(= CG_SKK_TWO_BAS (nth 1 #code$))
					)
					; 02/03/26 HN E-ADD �J�E���^�[�V�ƃT�C�h�p�l�����Ώ�
				)
				(progn
					;�p�x�Z�o
					(if (= nil #ang)
						(setq #ang (nth 2 (CfGetXData #en "G_LSYM")))
					)
					;���W�Z�o
					(setq #pt$ (GetSym4Pt #en))

					(setq #dw
						(polar
							(nth 1 #pt$)
							(angle    (nth 0 #pt$)(nth 2 #pt$))
							(distance (nth 0 #pt$)(nth 2 #pt$))
						)
					)
; 08/08/13
; �G���h�p�l���͏o�͐��@���珜�O���邽�߁A���@�̏����o���ʒu����邽�߂̕ϐ���ʂɐݒ�
					(setq #baseall$ (cons (nth 0 #pt$) #baseall$))
					(setq #baseall$ (cons (nth 1 #pt$) #baseall$))
					(if (/= CG_SKK_ONE_SID (nth 0 #code$))
						(progn
							; 08/09/17 �J�E���^�[���@��D�悳���邽�߂ɕʂ̕ϐ��Ɋm��
							(if (= CG_SKK_ONE_CNT (nth 0 #code$))
								(progn
									(setq #cnpt$ (cons (list (nth 0 #pt$) (nth 2 #pt$)) #cnpt$))
									(setq #cnpt$ (cons (list (nth 1 #pt$) #dw         ) #cnpt$))
								)
								(progn
									(setq #enpt$ (cons (list (nth 0 #pt$) (nth 2 #pt$)) #enpt$))
									(setq #enpt$ (cons (list (nth 1 #pt$) #dw         ) #enpt$))
								)
							)
						)
					)
				)
			)
		)
		#en$
	)
	;�\�[�g
	(if (or #enpt$ #cnpt$)
		(progn
			(setq #spt$ (2dto3d (3dto2d (PtSort (mapcar 'car (append #enpt$ #cnpt$)) #ang T))))
			(setq #spt  (car  #spt$))
			(setq #ept  (last #spt$))

			;�ō��ƍŉE���l��
			(mapcar
			 '(lambda ( #pp$ )
					(setq #pp$ (2dto3d (3dto2d #pp$)))
					(if (equal 0.0 (distance (car #pp$) #spt) 0.001)
						(setq #spt$ #pp$)
						(setq #sang (Angle0to360 (- (angle (car #pp$) (cadr #pp$)) (* PI 0.5))))
					)
					(if (equal 0.0 (distance (car #pp$) #ept) 0.001)
						(setq #ept$ #pp$)
						(setq #eang (Angle0to360 (+ (angle (car #pp$) (cadr #pp$)) (* PI 0.5))))
					)
				)
				; �J�E���^�[���ォ��]������̂ŁA�J�E���^�[���D�悳���
				(append #enpt$ #cnpt$)
			)
			(setq #baseall$ (PtSort #baseall$ #ang T))
		)
	)
	;�R�_�ڊl��
	; 01/02/05 HN S-MOD ������nil�����ǉ�
	(if (or (= nil #sang) (= nil #eang) (= nil (car #spt$)) (= nil (car #ept$)))
		nil
		(progn
; 08/08/13
; �G���h�p�l�����[�ɂ���΁A���̕����@�����o���ʒu�����炵�Ă��
			(setq #tmppt$ #spt$)
			(setq #offset (distance (car (3dto2d (list (car #baseall$)))) (car (3dto2d (list (car #tmppt$))))))
			(setq #spt$ nil)
			(foreach #tmppt #tmppt$
				(setq #tmppt (polar #tmppt #sang #offset))
				(setq #spt$ (append #spt$ (list #tmppt)))
			)
			(setq #tmppt$ #ept$)
			(setq #offset (distance (car (3dto2d (list (last #baseall$)))) (car (3dto2d (list (car #tmppt$))))))
			(setq #ept$ nil)
			(foreach #tmppt #tmppt$
				(setq #tmppt (polar #tmppt #eang #offset))
				(setq #ept$ (append #ept$ (list #tmppt)))
			)
			(setq #pt1$ (list #sang "D" (list #spt$ (polar (car #spt$) #sang (GetDimHeight 1)))))
			(setq #pt2$ (list #eang "D" (list #ept$ (polar (car #ept$) #eang (GetDimHeight 1)))))
			(setq #noang$ (list (list (angle (cadr #spt$) (car #spt$)) (GetBByAngPt (car #spt$) #sang))))
			(list (list #pt1$ #pt2$) #noang$)
		)
	)
	; 01/02/05 HN E-MOD ������nil�����ǉ�
) ; SCF_Sid_GetSym_Din


;<HOM>*************************************************************************
; <�֐���>    : JudgePriority
; <�����T�v>  : ���E�̐��@�̏o�͂���D�揇�ʌ���
; <�߂�l>    : ���@���X�g
; <�쐬>      : 00/03/03
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun JudgePriority (
	&ang        ; �p�x
	&pt$        ; ���W���X�g
	/
	#kpt$ #pt$ #pt_n$ #p$ #tpt #tv #vec$ #ret
	)
	(if (assoc "K" &pt$)
		(progn
			(setq #kpt$ (cadr (assoc "K" &pt$)))
			(setq #pt$ (mapcar 'cadr &pt$))
			(setq #pt_n$
				(mapcar
				 '(lambda ( #p$ )
						(list (cadr #p$) #p$)
					)
					#pt$
				)
			)
			(setq #tpt (last (PtSort (mapcar 'car #pt_n$) &ang T)))
			(mapcar
			 '(lambda ( #p$ )
					(if (equal 0.0 (distance #tpt (car #p$)) 0.001)
						(progn
							(setq #tv (cadr (cadr #p$)))
						)
					)
				)
				#pt_n$
			)
			(setq #vec$ (mapcar '- #tv (cadr #kpt$)))
			(setq #ret
				(list
					(list
						(mapcar '+ (car  (car #kpt$)) #vec$)
						(mapcar '+ (cadr (car #kpt$)) #vec$)
					)
					(mapcar '+ (cadr #kpt$) #vec$)
				)
			)
		)
		(progn
			(setq #pt$ (mapcar 'cadr &pt$))
			(setq #pt_n$
				(mapcar
				 '(lambda ( #p$ )
						(list (cadr #p$) #p$)
					)
					#pt$
				)
			)
			(setq #tpt (last (PtSort (mapcar 'car #pt_n$) &ang T)))
			(mapcar
			 '(lambda ( #p$ )
					(if (equal 0.0 (distance #tpt (car #p$)) 0.001)
						(progn
							(setq #ret (cadr #p$))
						)
					)
				)
				#pt_n$
			)
		)
	)

	#ret
)
;<HOM>*************************************************************************
; <�֐���>    : DivAngPt
; <�����T�v>  : �p�x�ƍ��W���X�g����A�꒼����ɂ�����̂��܂Ƃ߂�
; <�߂�l>    :
; <�쐬>      : 00/03/14
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun DivAngPt (
	&pt$
	/
	#pt$ #ang #elm$ #pt #b #new$ #new$$
	)
	(mapcar
	 '(lambda ( #pt$ )
			(setq #ang (car #pt$))
			(mapcar
			 '(lambda ( #elm$ )
					(setq #pt (car (car (cadr #elm$))))
					(setq #b (GetBByAngPt #pt #ang))
					(setq #new$ (cons (append (list #b) #elm$) #new$))
				)
				(cadr #pt$)
			)
			(setq #new$ (CollectAngle #new$))
			(mapcar
			 '(lambda ( #elm$ )
					(setq #new$$ (cons (cons #ang #elm$) #new$$))
				)
				#new$
			)
			(setq #new$ nil)
		)
		&pt$
	)

	#new$$
)

;<HOM>*************************************************************************
; <�֐���>    : GetBByAngPt
; <�����T�v>  : �p�x�ƍ��W����AX=0�̎���Y�̒l���l��
; <�߂�l>    : B
; <�쐬>      : 00/03/14
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun GetBByAngPt (
	&pt
	&ang
	/
	#pt2 #a #ret #ang
	)
	(setq #ang (Angle0to360 &ang))
	(cond
		((or (equal 0.0 #ang 0.01)(equal PI #ang 0.01))
			;y
			(setq #ret (cadr &pt))
		)
		((or (equal (* 0.5 PI) #ang 0.01) (equal (* 1.5 PI) #ang 0.01))
			;x
			(setq #ret (car &pt))
		)
		(T
			;b
			(setq #pt2 (polar (list (car &pt) (cadr &pt) 0.0) #ang 10))
			(setq #a   (/ (- (cadr #pt2) (cadr &pt)) (- (car #pt2) (car &pt))))
			(setq #ret (- (cadr &pt) (* #a (car &pt))))
		)
	)
	#ret
)
;<HOM>*************************************************************************
; <�֐���>    : DivAngPtH
; <�����T�v>  : �p�x�ƍ��W���X�g����A�꒼����ɂ�����̂��܂Ƃ߂�
; <�߂�l>    : ((�p�x B (("K" #ss))))
; <�쐬>      : 00/03/14
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun DivAngPtH (
	&pt$    ; ((�p�x (("KorD" #ss))) ( )�E�E�E)
	/
	#pt$ #ang #elm$ #en$ #en #pt #code$ #b #new$ #new$$
	)
	(foreach #pt$  &pt$
		(setq #ang (car #pt$))

		(foreach  #elm$	(cadr #pt$)
			(setq #en$ (Ss2En$ (cadr #elm$)))

			(foreach #en #en$
				(if (/= "W" (nth 1 (CfGetXData #en "G_SKDM")))
					(if (= nil #pt)
						(progn
							;�x�[�X�L���r�l�b�g�̂݊l��
							(setq #code$ (CFGetSymSKKCode #en nil))

							(if
								(and
									(= CG_SKK_ONE_CAB (nth 0 #code$))
									(= CG_SKK_TWO_BAS (nth 1 #code$))
								)
								(setq #pt (cdrassoc 10 (entget #en)))
							)
						)
					)
				)
			)
			(setq #b (GetBByAngPt #pt #ang))
			(setq #new$ (cons (append (list #b) #elm$) #new$))
			(setq #pt nil)
		)

		(setq #new$ (CollectAngle #new$))
		(foreach #elm$ #new$
			(setq #new$$ (cons (cons #ang #elm$) #new$$))
		)
		(setq #new$ nil)
	)

	#new$$
)
;DivAngPtH

(defun CFcompact (
	&list$
	/
	#ret$
	#ii
	)

	(foreach #ii &list$
		(if #ii
			(setq #ret$ (cons	#ii #ret$))
		)
	)

	(reverse #ret$)
)



