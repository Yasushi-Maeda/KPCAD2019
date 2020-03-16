(setq CG_LAYOUT_DIM_Z 15000.0)  ; ���@���̂y�l  01/10/02 HN ADD

;<HOM>*************************************************************************
; <�֐���>    : CFIsEqualPt
; <�����T�v>  : �Q�̓_���W������ł��邩�𒲂ׂ�
; <�߂�l>    :
;           T : ������W�ł���
;         nil : ������W�ł͂Ȃ�
; <�쐬>      : 04/03/25 SK ADD
; <���l>      :
;*************************************************************************>MOH<
(defun CFIsEqualPt (
		&p1   ;(LIST)���W�P
		&p2   ;(LIST)���W�Q
		/
	)
	;// �w������G���e�B�e�B����n�I�_�����o��
	(if (and
				(equal (car  &p1) (car  &p2) 0.001)
				(equal (cadr &p1) (cadr &p2) 0.001)
			)
		T
		nil
	)
)
;CFIsEqualPt

;<HOM>*************************************************************************
; <�֐���>    : SCFIsTaimenFlatPlan
; <�����T�v>  : �Ζʃt���b�g�v�������ǂ����𒲂ׂ�
; <�߂�l>    :
;          SF : �Z�~�t���b�g�Ζʃv����
;          FF : �t���t���b�g�Ζʃv����
;         nil : ����ȊO
; <�쐬>      : 04/04/08 SK ADD
; <���l>      :
;*************************************************************************>MOH<
(defun SCFIsTaimenFlatPlan (
	/
	#en     #en$
	#wtXd$
	#fType
	)
	; �S�}�ʂ̃V���{���擾
	(setq #en$ (Ss2En$ (ssget "X" '((-3 ("G_WRKT"))))))

	(foreach #en #en$
		(setq #wtXd$ (CFGetXData #en "G_WRKT"))
		(if (/= (nth 31 #wtXd$) "")
			(setq #fType (nth 31 #wtXd$))
		)
	)
	; �t���b�g�v�����^�C�v��Ԃ�
	#fType
)
;SCFIsTaimenFlatPlan

;<HOM>*************************************************************************
; <�֐���>    : SCFGetTaimenFlatPlanInfo
; <�����T�v>  : �\���̂̊O�ɑΖʗp�̃x�[�X�L���r������΂��̉��s���A�c�������擾����
; <�߂�l>    :
;        LIST : (�Ζʂ̉��s���@�ΖʃL���r�̂c����)
;         nil : �ΖʃL���r���Ȃ�
; <�쐬>      : 04/03/25 SK ADD
; <���l>      :
;*************************************************************************>MOH<
(defun SCFGetTaimenFlatPlanInfo (
	&enSym$        ; �\���G���e�B�e�B���X�g
	/
	#en1  #en2  #en2$
	#ang1 #ang2
	#p1   #p2
	#p1z  #p2z
	#xd1$ #xd2$
	#210$
	#tAng          ;�ΖʃL���r�̑Ζʕ���
	#tDepth        ;�ΖʃL���r�̉��s��
	#tDepthTmp     ;�ΖʃL���r�̉��s��
	#skk$          ;���i�R�[�h
	#no1
	#no2
	#yDist
	)
	; �S�}�ʂ̃V���{���擾
	(setq #en2$ (Ss2En$ (ssget "X" '((-3 ("G_LSYM"))))))

	(foreach #en1 &enSym$
		(if (and #en1 (setq #xd1$ (CFGetXData #en1 "G_LSYM")) (CfGetXData #en1 "G_SKDM"))
			(progn
				; ���i�R�[�h���擾����
				(setq #skk$ (CFGetSymSKKCode #en1 nil))
				; �x�[�X�L���r �J�E���^�[���Ώ�
				(if (and (or (= (car #skk$) 1) (= (car #skk$) 7)) (= (cadr #skk$) 1))
					(progn
						; �\�����L���r�̌��_�Ɗp�x�����߂�
						(setq #p1   (cdr (assoc 10 (entget #en1))))
						(setq #p1z  (last #p1))
						(setq #p1   (list (car #p1) (cadr #p1)))
						(setq #ang1 (nth 2 #xd1$))

						; 09/04/17 T.Ari Mod
						; ���f���ԍ�������̂��̂͑ΏۊO
						(setq #no1 (nth 2 (CfGetXData #en1 "G_SKDM")))

						; ����ΏۃL���r���Ζʂ��ǂ������ׂ�
						(foreach #en2 #en2$
							; ���i�R�[�h���擾
							(setq #skk$ (CFGetSymSKKCode #en2 nil))
							; �x�[�X�L���r �J�E���^�[���Ώ�
							(if (and (or (= (car #skk$) 1) (= (car #skk$) 7)) (= (cadr #skk$) 1) (CfGetXData #en2 "G_SKDM"))
								(progn
									(setq #xd2$ (CFGetXData #en2 "G_LSYM"))

									; ����ΏۃL���r�̌��_�Ɗp�x�����߂�
									(setq #p2   (cdr (assoc 10 (entget #en2))))
									(setq #p2z  (last #p2))
									(setq #p2   (list (car #p2) (cadr #p2)))
									(setq #ang2 (nth 2 #xd2$))

									(setq #210$ (cdr (assoc 210 (entget #en2))))
									; 09/04/17 T.Ari Mod
									; ���f���ԍ�������̂��̂͑ΏۊO
									(setq #no2 (nth 2 (CfGetXData #en2 "G_SKDM")))

									; �݂��̃L���r�̌������t�ł��邱��
									(if (and (/= #no1 #no2) (equal (angtos #ang1 0 2) (angtos (+ #ang2 pi) 0 2)))
										(cond
											;// ���ʐ}�̏ꍇ
											((CFIsEqualPt (list 0 0 1) #210$)
												; T.Ari Mod 09/04/20
												; ������xY���W������Ă��Ă��ΖʂƂ���B
												(setq #yDist (- (cadr #p2) (cadr #p1)))
												(if (equal #yDist 0 200)
													(progn
														(setq #xd2$ (CFGetXData #en2 "G_SYM"))
														(setq #tDepthTmp (+ #yDist (nth 4 #xd2$)))
														(if (or (= #tDepth nil) (> #tDepthTmp #tDepth))
															(progn
																(setq #tDepth #tDepthTmp)
																(setq #tAng   (- #ang2 (dtr 90)))
															)
														)
													)
												)
											)
											; �W�J�a�c��ł̃`�F�b�N
											; ��_XY���W�������ŁAZ���W���قȂ邱��
											((and (equal (car #p2) (car #p1) 200) (= (equal #p1z #p2z 200) nil))
												(setq #xd2$ (CFGetXData #en2 "G_SYM"))
												(setq #tDepthTmp (+ (nth 4 #xd2$) (- (car #p2) (car #p1))))
												(if (or (= #tDepth nil) (> #tDepthTmp #tDepth))
													(progn
														(setq #tDepth #tDepthTmp)
														(setq #tAng   (- #ang2 (dtr 90)))
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
	)
	; �Ζʏ���Ԃ�
	(if #tDepth
		(list #tDepth #tAng)
	;else
		nil
	)
)
;SCFGetTaimenFlatPlanInfo

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetBaseHeight
;;; <�����T�v>: �������̃f�t�H���g�l���擾���܂�
;;; <�߂�l>  : ������
;;;             �ݒ�l���Ȃ��ꍇ�́Anil ��Ԃ��܂�
;;; <�쐬>    : 01/09/23
;;; <���l>    : DIMENSION.INI �� "BaseHeight" ���Q�Ƃ��܂��B
;;;             �{�֐��́APanaHome�l�p�ɍ쐬�B
;;;************************************************************************>MOH<
(defun SCFGetBaseHeight
	(
	/
	#sFile      ; �t�@�C����
	#vData$     ; �t�@�C�� �f�[�^
	#sData      ; �����f�[�^
	#rData      ; �����l�f�[�^
	)
	(setq #rData nil)
	(setq #sFname (strcat CG_SYSPATH "DIMENSION.INI"))
	(if (findfile #sFname)
		(progn
			(setq #vData$ (ReadIniFile #sFname))
			(setq #sData (cadr (assoc "BaseHeight" #vData$)))
			(if #sData
				(setq #rData (atof #sData))
			)
		);_progn
	);_if

	#rData
);_defun


;<HOM>*************************************************************************
; <�֐���>    : SCFDrawDimensionEx
; <�����T�v>  : �W�J�}�̐��@��������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/02/18
; <���l>      : ���̊֐��ł͊e�W�J�}�i�W�JA�E�W�JB�E�W�JC�E�W�JD�j
;               ���쐬�ς݂ł��邱��
;*************************************************************************>MOH<
(defun SCFDrawDimensionEx (
	&ztype      ; �}�ʎ�ރ^�C�v�i����:"P" �W�JA�`F:"A" "B" "C" "D" "E" "F"�j
	&dimpat$    ; �o�̓p�^��
	&Zumen      ; �}�ʎ�� ���i�} : "02"  �{�H�} : "03"	2000/07/04 HT ADD
	/
	#clayer #layer #ss #ss$ #ang #ryo$ #pen$ #iti$ #i #flg #tmp$
	)

	; #iti$�ϐ��̎g������
	; (�� �� �� �E)�̐��@�ʒu
	; ex.
	;     #iti$ = (0 0 1 1)�Ȃ�A��≺�̐��@���́A0�i�ڂ̈ʒu�ɍ쐬�����
	;     ����E�̐��@���́A1�i�ڂ̈ʒu�ɍ쐬�����B0�i�ڂ̈ʒu�̐��@����
	;     �d�Ȃ炸�ɍ쐬�ł���B
	;
	;     <�E���ɍ쐬����鐡�@�̗�>
	;
	;         300      120   120
	;     |----------|-----|-----|
	;     �O         �O    �O
	;   ��_         0�i��  1�i��
	;
	;     -----------|-----|
	;                |     |
	;                |     |
	;                |     |
	;     -----------|-----|
	;

	;-----  �����ݒ�  -----
	(setq #clayer (getvar "CLAYER"))
	(setvar "CLAYER" "0_DIM")

	(setq CG_DimOffLen 50) ; �{�H���@�̃I�t�Z�b�g����

	; �W�J�}�̕����ɉ�������w���w��
	(cond
		((equal "A" &ztype)  (setq #layer "0_SIDE_A"))
		((equal "B" &ztype)  (setq #layer "0_SIDE_B"))
		((equal "C" &ztype)  (setq #layer "0_SIDE_C"))
		((equal "D" &ztype)  (setq #layer "0_SIDE_D"))
		((equal "E" &ztype)  (setq #layer "0_SIDE_E"))
		((equal "F" &ztype)  (setq #layer "0_SIDE_F"))
		;2011/07/15 YM ADD
		((equal "G" &ztype)  (setq #layer "0_SIDE_G"))
		((equal "H" &ztype)  (setq #layer "0_SIDE_H"))
		((equal "I" &ztype)  (setq #layer "0_SIDE_I"))
		((equal "J" &ztype)  (setq #layer "0_SIDE_J"))
	)
	;----------------------
	;�^�C�v����
	(setq #ss$ (KCFDivSymByLayoutEx #layer))
	(cond

		; B�^ (==���ʃt���O��ON �̐}�`���Ȃ��ꍇ)
		((= 'PICKSET (type #ss$))

			(if (not #iti$) (setq #iti$ (list 0 0 0 0)))

			; 01/05/17 TM ADD �㑤�Ɏ{�H���@����}
			(setq #ryo$ (GetRangeUpBas #ss$))
		 	(if (or (/= nil (car #ryo$)) (/= nil (cadr #ryo$)))
				(progn
		 			(setq #pen$ (car (SCFGetPEntity #layer)))
					(setq #iti$ (DrawPtenDim #pen$ #ryo$ #layer (nth 2 &dimpat$) (nth 3 &dimpat$)))
				)
			)

			; 01/06/07 TM �S�{�H���@��}��ɃL���r�l�b�g���@����}����
			(KCFDrawCabiDim #ss$ #iti$)
		)

		; A�^/B�^�̈ꕔ (==���ʃt���O�����ׂ�0�ł͂Ȃ��ꍇ)
		((= 'LIST (type #ss$))

			; �{�H���@ON�̎�
			(setq #iti$ (list 0 0 0 0))
			; 01/09/09 HN MOD �{�H���@��}�̔��菈����ύX
			;@MOD@(if (and (= "1" (nth 1 &dimpat$)) (/= &Zumen CG_OUTSHOHINZU))
			(if (= "1" (nth 1 &dimpat$))
				(progn

					; �x�[�X�ƃA�b�p�[�̗̈���W�l��
					;(princ "\n#ryo$(�����^�C�v): ")
					(setq #ryo$ (GetRangeUpBas #ss$))
					;(princ #ryo$)

					; �����ꂩ�̗̈悪����ꍇ�Ɏ{�H���@����}
					(if (or (/= nil (car #ryo$)) (/= nil (cadr #ryo$)))
						(progn
							;P�}�`�l��
							(setq #pen$ (car (SCFGetPEntity #layer)))
							;DEBUG (princ "\n���C���[: ")
							;DEBUG (princ #layer)
							;DEBUG (princ "\n�o�_���@��: ")
							;DEBUG (princ #pen$)
							; �{�H���@�Ǝ{�H�������@����}
							;DEBUG (princ "\n�e�X�g #ryo$: ")
							;DEBUG (princ #ryo$)
							;DEBUG (princ "\n�{�H(3�Ԗ�)����(4�Ԗ�) ")
							;DEBUG (princ &dimpat$)
							(setq #iti$ (DrawPtenDim #pen$ #ryo$ #layer (nth 2 &dimpat$) (nth 3 &dimpat$)))
						)
				 )
				)
			)
			; �L���r�l�b�g���@ON��
			; ���@����_�C�A���O�ύX�ɂƂ��Ȃ��A���i�}ON�̎��͕K���o��
			(if (or (= "1" (nth 0 &dimpat$)) (= &Zumen CG_OUTSHOHINZU))
				(progn
					; 2000/06/19 HT I�^�̎��݂̂��ׂĂ̐��ʃt���O0�ł��o�͂���悤�ɏC�� START
					;if (or (= CG_KitType "I-LEFT") (= CG_KitType "I-RIGHT")
					;	  (= CG_KitType "D-LEFT") (= CG_KitType "D-RIGHT"))
					;  progn
					; 2000/06/16 I�^�̎��́A���ʃt���O0�ł��o�͂���悤�ɏC�� END
					; "K" �݂̂� "D"�݂̂̎��̂ݏ������� 2000/08/28 DEL
					; ���ׂẴ��f���Ő��ʃt���O��OFF�Ȃ�
					(setq #tmp$ '())
					; �L�b�`���I�����X�g��ǉ�
					(if  (/= (car #ss$) nil)
						(progn
							(setq #tmp$ (append (car #ss$)))
						)
					)
					; �_�C�j���O�I�����X�g��ǉ�
					(if (/= (cadr #ss$) nil)
						(progn
							(setq #tmp$ (append #tmp$ (cadr #ss$)))
						)
					)

					(setq #flg 0)
					(foreach #tmp	#tmp$
						(setq #i 0)
						; ���ׂẴL���r�l�b�g�̐��ʃt���O��0�ǂ�������
						(repeat (sslength #tmp)
							; ���ʃt���O�� 1(=����) �̃L���r�l�b�g�����邩�H
							(if (and (or (= 1 (nth 3 (CFGetXData (ssname #tmp #i) "G_SKDM")))
													 (= -1 (nth 3 (CFGetXData (ssname #tmp #i) "G_SKDM"))))
											(= CG_SKK_ONE_CAB (CFGetSymSKKCode (ssname #tmp #i) 1)))
								(setq #flg 1)
							)
							(setq #i (1+ #i))
						)
					);_foreach

					; ���ʃt���O�̗����Ă���L���r�l�b�g���ЂƂ��Ȃ��ꍇ
					(if (/= #flg 1)
						(progn
							(foreach #tmp #tmp$
								(KCFDrawCabiDim #tmp #iti$)
							)
						)
						; ���ʃt���O�̗����Ă���L���r�l�b�g������ꍇ
						(progn
							; �㉺��}
							(SCF_A_DrawDim #ss$ #iti$)
							;���E��}
							(setq #ss$ (GetModelSideDim #ss$))
							;DEBUG(princ "\n�i���E���f���I���G���e�B�e�B���X�g ���E�̊�_���W�j: ")
							;DEBUG(princ #ss$)
							(DrawSideDim (cadr (car #ss$)) "R" #layer (cadr (cadr #ss$)) (nth 3 #iti$))
							(DrawSideDim (car  (car #ss$)) "L" #layer (car  (cadr #ss$)) (nth 2 #iti$))
						)
					)
				)
			);_if
		)
		(t (princ "\nSCFDrawDimensionEx"))
	);_cond

	(setvar "CLAYER" #clayer)
	(princ)
) ; SCFDrawDimensionEx

;<HOM>*************************************************************************
; <�֐���>    : KCFDrawCabiDim
; <�����T�v>  : �L���r�l�b�g�̐��@����}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/04/10 TM ##DrawCabDim ���ړ� (�I���W�i��:2000/06/16  HT
; <���l>      : ���f���S�Ă̐��ʃt���O=0�����Ȃ��ꍇ��
;             : I�^�̏��i�}�̍�}�𓯂����[�`���ɂ����B)
;*************************************************************************>MOH<
(defun KCFDrawCabiDim (
	&xSs			; �V���{���I���G���e�B�e�B
	&iti$			; ��}�ʒu
	/
	#sym$  ; �i�x�[�X�V���{���}�`�� �A�b�p�[�V���{���}�`�����X�g �x�[�X�L���r�l�b�g�����j
	#bh    ;  �x�[�X�L���r�l�b�g����
	#2pt$  ;
	#ang   ;
	#iti   ;
	#en
	#skk$
	#taimen$
	#ed$
	#no
	#ss
	#wpt$
	#bpt
	)
	;�V���{���}�`�l��
	; #sym$ =�i�x�[�X�V���{���}�`�� �A�b�p�[�V���{���}�`�����X�g �x�[�X�L���r�l�b�g�����j
	(setq #sym$ (SCF_B_GetSym &xSs))

	(if (/= nil #sym$)
		(progn
			; �x�[�X�L���r�l�b�g�������擾
			(setq #bh (nth 2 #sym$))

			(setq #taimen$ (SCFGetTaimenFlatPlanInfo (Ss2En$ &xSs)))
			(setq #ed$ (CfGetXData (car #sym$) "G_SKDM"))
			(if (and (= "D" (nth 1 #ed$)) (/= #taimen$ nil))
				(princ)
				(progn
					(setq #no (nth 2 #ed$))
					(setq #ss (ssget "X" '((-3 ("G_SKDM")))))
					(foreach #en (Ss2En$ #ss)
						(setq #ed$ (CfGetXData #en "G_SKDM"))
						(if (and (= "W" (nth 1 #ed$)) (= #no (nth 2 #ed$)))
							(setq #wpt$ (cons (cdrassoc 10 (entget #en)) #wpt$))
						)
					)

					; �S�}�`���̃��X�g���쐬
					(setq #sym$ (append (list (nth 0 #sym$)) (nth 1 #sym$)))

					;�p�x�Z�o
					;�V���{���ʒu�ƃL���r�l�b�g���s���ʒu�𓾂�
					; 06/09/20 T.Ari Mod ��֕������Ă���x�[�X�L���r���l��
					;(setq #2pt$ (Get2PointByLay (car #sym$)))
					(setq #2pt$ (Get2PointByLay (car #sym$) 1))
					(setq #2pt$ (list
												(polar (car #2pt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData (car #sym$) "G_LSYM"))))
												(polar (cadr #2pt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData (car #sym$) "G_LSYM"))))
											)
					)
					(if (/= nil #2pt$)
						(progn

							; �V���{���ʒu�ƃL���r�l�b�g���s���ʒu����L���r�l�b�g�̊p�x���擾����
							; ���@���L�q���鍶�E���������肷��
							(setq #ang (angle (cadr #2pt$) (car #2pt$)))
							; CG_DRSeriCodeRV 14. ���o�[�V�u���p��SERIES�L��

							(if (or (= CG_DRSeriCodeRV nil) (= CG_DRSeriCodeRV ""))
								; ���o�[�V�u���̏ꍇ
								(princ)
								; �ʏ�̏ꍇ
								(setq #ang (+ #ang PI))
							)
							;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
							; 04/03/25 SK ADD-S �Ζʃv�����Ή�
;							(if (SCFIsTaimenFlatPlan)
;								(foreach #en (Ss2En$ &xSs)
;									(setq #skk$ (CFGetSymSKKCode #en nil))
;									; �J�E���^�[�V�͐��@�o�͑ΏۂƂ���
;									(if (= (car #skk$) CG_SKK_ONE_CNT)
;										(setq #sym$ (append #sym$ (list #en)))
;									)
;								)
;							)
							; 04/03/25 SK ADD-E �Ζʃv�����Ή�
							;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

							;���@��}
							;(SCF_B_DrawDim_Din #layer #sym$ #ang nil #iti 1)
							(setq #bpt (car #2pt$))
							(setq #wpt$ (SCFmg_sort$ 'car (cons #bpt #wpt$)))
							(if (/= #taimen$ nil)
								(setq #ang (Angle0to360 (+ #ang PI)))
							)

							(if (or (equal #ang 0.0 0.01) (equal #ang (* 2.0 PI) 0.01))
								(setq #bpt (list (nth 0 (last #wpt$)) (nth 1 #bpt) (nth 2 #bpt)))
								(setq #bpt (list (nth 0 (car #wpt$)) (nth 1 #bpt) (nth 2 #bpt)))
							)
							(if (or (equal #ang 0.0 0.01) (equal #ang (* 2.0 PI) 0.01))
								(setq #iti (nth 3 &iti$)) ; �E
								(setq #iti (nth 2 &iti$))	; ��
							)

							(SCF_B_DrawDim_Din #layer #sym$ #ang #bpt #iti 1)
						)
					);_if (/= nil #2pt$)
				)
			)
		)
	)
);_ defun KCFDrawCabiDim

;<HOM>*************************************************************************
; <�֐���>    : KCFGetCabiDimAng
; <�����T�v>  : �L���r�l�b�g�̐��@��}�������擾����
; <�߂�l>    : �p�x  �V���{���}�`���Ȃ��ꍇ nil
; <�쐬>      : 01/05/17 TM
; <���l>      : �V���{���ʒu�ƃL���r�l�b�g���s���ʒu����L���r�l�b�g���@�̊p�x���v�Z
;*************************************************************************>MOH<
(defun KCFGetCabiDimAng (
	&xSs			; �V���{���I���G���e�B�e�B
	/
	#sym$			; �V���{���}�`���X�g
	#2pt$			; �V���{���ʒu�ƃL���r�l�b�g���s���ʒu
	#ang			; �p�x
	)

	;�V���{���}�`�l��
	; #sym$ =�i�x�[�X�V���{���}�`�� �A�b�p�[�V���{���}�`�����X�g �x�[�X�L���r�l�b�g�����j
	(setq #sym$ (SCF_B_GetSym &xSs))
	(if (/= nil #sym$)
		(progn
			; �S�}�`���̃��X�g���쐬
			(setq #sym$ (append (list (nth 0 #sym$)) (nth 1 #sym$)))

			;�V���{���ʒu�ƃL���r�l�b�g���s���ʒu�𓾂�
			(setq #2pt$ (Get2PointByLay (car #sym$) 1))
			(if (/= nil #2pt$)
				(progn
					; �V���{���ʒu�ƃL���r�l�b�g���s���ʒu����L���r�l�b�g�̊p�x���擾����
					; ���@���L�q���鍶�E���������肷��
					(setq #ang (angle (cadr #2pt$) (car #2pt$)))
				)
			)
		)
	)
	#ang

);_defun KCFGetCabiDimAng

;<HOM>*************************************************************************
; <�֐���>    : DivSymByLayoutEx
; <�����T�v>  : ���C�A�E�g��̃V���{���𕪂���  �}�`�ړ�����p
; <�߂�l>    : �i
;                 �i�L�b�`���I���G���e�B�e�B���X�g�j
;                 �i�_�C�j���O�I���G���e�B�e�B���X�g�j
;               �j
; <���l>      :
; <�쐬>      : 00/02/16
; <���l>      : ���ʃt���O�����ׂ�0�̃��f���͑ΏۊO
;               �A���A���f���S�Ă�0�̂��̂����Ȃ��ꍇ�A�L�b�`���̃V���{����Ԃ�
;*************************************************************************>MOH<
(defun DivSymByLayoutEx (
&layer      ; �V���{�����l�������w
/
#ss #i #en #ed$ #data$ #no #dd #tmp$ #flg #kd$ #dd$ #kitss
#err_flag  ;-- 2011/11/13 A.Satoh Add
)
;@@@00/05/18(princ "\n&layer: ")(princ &layer)

;-- 2011/11/13 A.Satoh Add - S
	(setq #err_flag nil)
;-- 2011/11/13 A.Satoh Add - E
	;�V���{���}�`�l��
	(setq #ss (ssget "X" (list (list -3 (list "G_SKDM")) (cons 8 &layer))))

	(setq #i 0)

	(if #ss
		(progn
			(repeat (sslength #ss)
				; �V���{���}�`�̊g���f�[�^���擾
				(setq #en (ssname #ss #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))

;@@@00/05/18(princ "\n#ed$: ")(princ #ed$)
				;(if (/= "W" (nth 1 #ed$))
				;  (setq #data$ (cons (list (nth 2 #ed$)(nth 1 #ed$)(nth 3 #ed$) #en) #data$))
				;)
				;;00/05/18 HN S-ADD �������h�^�̎{�H���@���쐬���邽�ߎb��Ή�������
				;(if (/= "D" (nth 1 #ed$))
				;  (setq #data$ (cons (list (nth 2 #ed$)(nth 1 #ed$) 1 #en) #data$))
				;)
				;00/05/18 HN E-ADD �������h�^�̎{�H���@���쐬���邽�ߎb��Ή�������
				; ���[�N�g�b�v
				(if (/= "W" (nth 1 #ed$))
					; (���f��No. ���f����� ���ʃt���O[1�ɌŒ�] �V���{���}�`��)
					(setq #data$ (cons (list (nth 2 #ed$)(nth 1 #ed$) 1 #en) #data$))
				)
				(setq #i (1+ #i))
			)
		)
		(progn
;-- 2011/11/13 A.Satoh Mod - S
;;;;;			(princ "�W�J���}�ɐ}�`������܂���B") (setq CG_OpenMode nil)
;-- 2012/02/02 A.Satoh Mod - S
			(princ "\n���������W�J���}�ɐ}�`������܂���B")
;;;;;			(CFAlertMsg "�W�J���}�ɐ}�`������܂���B")
;-- 2012/02/02 A.Satoh Mod - E
			(setq #err_flag T)
;-- 2011/11/13 A.Satoh Mod - E
		)
	)

;-- 2011/11/13 A.Satoh Add - S
	(if (= #err_flag nil)
		(progn
;-- 2011/11/13 A.Satoh Add - E
	; ���f��No.���Ƀ\�[�g
	(setq #data$ (SCFmg_sort$ 'car #data$))

	(setq #no (nth 0 (nth 0 #data$)))
	(foreach #dd #data$
		(if (= #no (nth 0 #dd))
			(progn
				(setq #tmp$ (cons (cdr #dd) #tmp$))
				(if (= 1 (nth 2 #dd))
					(setq #flg T)
				)
			)
			(progn
				(if (/= nil #flg)
					(if (= "K" (nth 0 (nth 0 #tmp$)))
						(setq #kd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #kd$))
						(setq #dd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #dd$))
					)
					(if (= "K" (nth 0 (nth 0 #tmp$)))
						(setq #kitss (En$2Ss (mapcar 'caddr #tmp$)))
					)
				)
				(setq #tmp$ (list (cdr #dd)))
				(setq #no   (car #dd))
				(setq #flg nil)
			)
		)
	)

	(if (/= nil #tmp$)
		(if (/= nil #flg)
			(if (= "K" (nth 0 (nth 0 #tmp$)))
				(setq #kd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #kd$))
				(setq #dd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #dd$))
			)
			(if (= "K" (nth 0 (nth 0 #tmp$)))
				(setq #kitss (En$2Ss (mapcar 'caddr #tmp$)))
			)
		)
	)

	(if (or (/= nil #kd$) (/= nil #dd$))
		(list #kd$ #dd$)
		#kitss
	)
;-- 2011/11/13 A.Satoh Add - S
		)
		nil
	)
;-- 2011/11/13 A.Satoh Add - E
) ; DivSymByLayoutEx

;<HOM>*************************************************************************
; <�֐���>    : KCFDivSymByLayoutEx
; <�����T�v>  : ���C�A�E�g��̃V���{���𕪂���  �W�J�}�p
; <�߂�l>    : 1. ���ʐ}�����݂���ꍇ: ���X�g(�\���͈ȉ��̒ʂ�)
;              �i
;                 �i�L�b�`���I���G���e�B�e�B���X�g�j
;                 �i�_�C�j���O�I���G���e�B�e�B���X�g�j
;               �j
;             : 2. ���ʐ}�������݂��Ȃ��ꍇ: �ΏۂƂȂ邷�ׂẴV���{�����܂Ƃ߂��I���Z�b�g
; <�쐬>      : 00/02/16
; <���l>      :
;*************************************************************************>MOH<
(defun KCFDivSymByLayoutEx (
	&layer      ; �V���{�����l�������w
	/
	#ss #i
	#en #ed$ #data$ #no #dd #tmp$ #flg #kd$ #dd$
	#kitss	; �L�b�`���̃V���{��
	#dinss	; �_�C�j���O�̃V���{�� 01/05/16 TM ADD
	#eKSide$	; ���ʐ}�`�G���e�B�e�B�̃��X�g(�L�b�`��)
	#eDSide$	; ���ʐ}�`�G���e�B�e�B�̃��X�g(�_�C�j���O)
#err_flag  ;-- 2011/11/13 A.Satoh Add
	)
	;@@@00/05/18(princ "\n&layer: ")(princ &layer)

	(setq #i 0)
;-- 2011/11/13 A.Satoh Add - S
	(setq #err_flag nil)
;-- 2011/11/13 A.Satoh Add - E

	; ���[�N�g�b�v�}�`�ȊO�̃f�[�^���W�߂�
	(setq #ss (ssget "X" (list (list -3 (list "G_SKDM")) (cons 8 &layer))))
	(if #ss
		(progn
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				(if (/= "W" (nth 1 #ed$))
					(setq #data$ (cons (list (nth 2 #ed$) (nth 1 #ed$) (nth 3 #ed$) #en) #data$))
				)
				(setq #i (1+ #i))
			)
		)
		; �Ȃ��ꍇ�͏I��
		(progn
;-- 2011/11/13 A.Satoh Add - S
;;;;;			(princ "�W�J���}�ɐ}�`������܂���B") (setq CG_OpenMode nil)
;-- 2012/02/02 A.Satoh Mod - S
			(princ "\n���������W�J���}�ɐ}�`������܂���B")
;;;;;			(CFAlertMsg "�W�J���}�ɐ}�`������܂���B")
;-- 2012/02/02 A.Satoh Mod - E
			(setq #err_flag T)
;-- 2011/11/13 A.Satoh Add - E
		)
	)

;-- 2011/11/13 A.Satoh Add - S
	(if (= #err_flag nil)
		(progn
;-- 2011/11/13 A.Satoh Add - E
	; ���f���ԍ��Ń\�[�g
	(setq #data$ (SCFmg_sort$ 'car #data$))

	; 01/06/21 TM ADD
	(setq #eKSide$ '() #eDSide$ '())
	(setq #no (nth 0 (nth 0 #data$)))
	; �W�߂��f�[�^�����f���ԍ����ƂɏW�߂�
	(foreach #dd #data$
			; DEBUG (princ "\n�f�[�^ : ")
			; DEBUG (princ #dd)
			(if (= #no (nth 0 #dd))
				; ���f���ԍ����ω����Ă��Ȃ��ꍇ(�ƍŏ�)
				(progn
					(setq #tmp$ (cons (cdr #dd) #tmp$))
					; ���ʃt���OON �̏ꍇ
					(if (= 1 (nth 2 #dd))
						(setq #flg T)
					)
				)
				; ���f���ԍ����ς��ꍇ
				(progn
					; ���ʂȐ}�`����ł�����ΐ��ʂ���
					(if (/= nil #flg)
						; ���ʂ���
						(if (= "K" (nth 0 (nth 0 #tmp$)))
							(setq #kd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #kd$))
							(setq #dd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #dd$))
						)
						; ���ʈȊO
						(progn
							; 01/06/21 TM MOD �L�b�`���ƃ_�C�j���O�𕪂��ďo�͂���悤�ɕύX(2��^�Ή�)
							(if (= "K" (nth 0 (nth 0 #tmp$)))
								(setq #eKSide$ (append (mapcar 'caddr #tmp$) #eKSide$))
								(setq #eDSide$ (append (mapcar 'caddr #tmp$) #eDSide$))
							)
						)
					)
					; #tmp$, #no, #flg ������
					(setq #tmp$ (list (cdr #dd)))
					(setq #no   (car #dd))
					; 01/08/07 DEL TM �����ŏ��������Ă��܂����炷�ׂĂ̐}�`�f�[�^���Ԃ�Ȃ�...
					;(setq #flg nil)
				)
			)
		)

		(if (/= nil #tmp$)
			(if (/= nil #flg)
				; ����
				(if (= "K" (nth 0 (nth 0 #tmp$)))
					(setq #kd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #kd$))
					(setq #dd$ (cons (En$2Ss (mapcar 'caddr #tmp$)) #dd$))
				)
				(progn
					; ���ʈȊO
					; 01/06/20 MOD ���ʐ}��"K"/"D" ����ʂ��Ȃ�("K"��"D"�̂Q��^�������݂��邽��)
					(if (= "K" (nth 0 (nth 0 #tmp$)))
						(setq #eKSide$ (append (mapcar 'caddr #tmp$) #eKSide$))
						(setq #eDSide$ (append (mapcar 'caddr #tmp$) #eDSide$))
					)
				)
			)
		)
		(if (or #kd$ #dd$)
			(progn
				(list #kd$ #dd$)
			)
	; 01/06/21 TM MOD �L�b�`���ƃ_�C�j���O����������ꍇ�̍l��
			(progn
				(if #eKSide$
					(setq #kitss (En$2Ss #eKSide$))
				)
				(if #eDSide$
					(setq #dinss (En$2Ss #eDSide$))
				)

				(if (and #dinss #kitss)
					(progn
						(list (list #kitss) (list #dinss))
					)
					(progn
						(if #kitss #kitss #dinss)
					)
				)
			)
		)
;-- 2011/11/13 A.Satoh Add - S
		)
		nil
	)
;-- 2011/11/13 A.Satoh Add - E
	) ; KCFDivSymByLayoutEx

	;<HOM>*************************************************************************
	; <�֐���>    : SCF_B_GetSym
	; <�����T�v>  : ���@����}����x�[�X�ƃA�b�p�[�̃V���{�����l��
	; <�߂�l>    : �i�x�[�X�V���{���}�`�� �A�b�p�[�V���{���}�`�����X�g �x�[�X�L���r�l�b�g�����j
	; <���l>      :  �x�[�X�V���{���}�`��         = Z���W�ő�
	;                �A�b�p�[�V���{���}�`�����X�g = Z���W�ő�
	;                �x�[�X�L���r�l�b�g�����ő�
	; <�쐬>      : 00/02/03
	;*************************************************************************>MOH<

	(defun SCF_B_GetSym (
		&ss         ; �V���{���I���G���e�B�e�B
		/
		#findF #i #en #ed$ #code$ #denb$ #bas$ #denu$ #upp$ #bh$ #bh
		#max #bsym
		#z #z$ #usym #usym$
		#eBFbas$		; �r�[�t���[�p��̐}�`�G���e�B�e�B���X�g
		#h #minH    ; �Ζʃv�����Ή�
#sa ;2019/03/15 YM ADD
		)

		;2019/03/15 YM ADD-S
		(if (= BU_CODE_0014 "1") ; PSKD
			(setq #sa 26.01)
			;else ����ȊO
			(setq #sa  0.01)
		);_if
		;2019/03/15 YM ADD-E

		;�f�ʎw������Ă���V���{���}�`�����l��
		(setq #findF nil)
		(setq #i 0)
		(repeat (sslength &ss)
			(setq #en (ssname &ss #i))
			(setq #ed$ (CfGetXData #en "G_LSYM"))
			(setq #code$ (CFGetSymSKKCode #en nil))
			;�x�[�X�ƃA�b�p�[�ƕ�����
			(if (and #code$ (or (= CG_SKK_ONE_CAB (nth 0 #code$))(= CG_SKK_ONE_RNG (nth 0 #code$))))
				(progn
					(cond
						((and (= CG_SKK_TWO_BAS (nth 1 #code$)) (/= CG_SKK_THR_RVS (nth 2 #code$)))
						 	(if (/= BU_CODE_0012 "1") ; �t���[���L�b�`���łȂ��ꍇ
								(if (= 1 (nth 14 #ed$))						; �f�ʎw������Ă���H
									(setq #denb$ (cons #en #denb$))
									; 02/03/31 HN S-ADD ���iCODE=110��ΏۂƂ���
									(if (= CG_SKK_THR_ETC (nth 2 #code$))
										(setq #denb$ (cons #en #denb$))
									)
									; 02/03/31 HN E-ADD ���iCODE=110��ΏۂƂ���
								)
							);if
							(setq #bas$ (cons #en #bas$))
						)
						((= CG_SKK_TWO_UPP (nth 1 #code$))
						 	(if (/= BU_CODE_0012 "1") ; �t���[���L�b�`���łȂ��ꍇ
								(if (= 1 (nth 14 #ed$))					; �f�ʎw������Ă���H
									(setq #denu$ (cons #en #denu$))
								)
							);if
							(setq #upp$ (cons #en #upp$))
						)
					)
					; 01/07/31 TM MOD �Ƃ肠�����A�r�[�t���[������o���Ă݂�
					(if (equal (list CG_SKK_ONE_CAB CG_SKK_TWO_BAS CG_SKK_THR_BFR) #code$)
						(progn
							(if #sBFbas$
								(setq #eBFbas$ (append #eBFbas$ (list #en)))
								(setq #eBFbas$ (list #en))
							)
						)
					)
				)
				(progn
					(if (= CG_SKK_ONE_CNT (nth 0 #code$))
						(if (/= BU_CODE_0012 "1") ; �t���[���L�b�`���łȂ��ꍇ
							(if (= 1 (nth 14 #ed$))
								(setq #denu$ (cons #en #denu$))     ; �f�ʎw������Ă���
							)
						);if
						; 01/12/19 HN S-MOD �V���N�E�����E���̑��}�`�͐��@��}�ΏۂƂ��Ȃ�
						;@MOD@(setq #upp$ (cons #en #upp$))
						(if
							(and
								;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
								; 04/03/25 SK ADD-S �Ζʃv�����Ή�
								; �x�[�X�̕��ނłȂ���
								(/= CG_SKK_TWO_BAS (nth 1 #code$))
								; 04/03/25 SK ADD-E �Ζʃv�����Ή�
								;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
								(/= CG_SKK_ONE_SNK (nth 0 #code$))  ; �V���N
								(/= CG_SKK_ONE_WTR (nth 0 #code$))  ; �����E�򐅊�
								(/= CG_SKK_ONE_ETC (nth 0 #code$))  ; ���̑�
							)
							(setq #upp$ (cons #en #upp$))
						);_if
						; 01/12/19 HN E-MOD �V���N�E�����E���̑��}�`�͐��@��}�ΏۂƂ��Ȃ�
					)
				)
			)
			(setq #i (1+ #i))
		)

		; �f�ʎw������Ă�����̂�����Ύ��o���B
		(if (/= nil #denb$) (setq #bas$ #denb$))
		(if (/= nil #denu$) (setq #upp$ #denu$))
		;�x�[�X�L���r�l�b�g�����l��
		(foreach #en #bas$
			(setq #bh$ (cons (nth 13 (CfGetXData #en "G_LSYM")) #bh$))
		)
		(if #bh$
			(setq #bh (apply 'max #bh$))
		)

		;Z���W�̈�ԑ傫���V���{���}�`���l��
		;�x�[�X
		(if (/= nil #bas$)
			(progn
				(setq #max (caddr (cdrassoc 10 (entget (nth 0 #bas$)))))
				(setq #minH (cadr (cdrassoc 10 (entget (nth 0 #bas$)))))
				(setq #bsym (nth 0 #bas$))
				(foreach #en #bas$
;					(setq #z (caddr (cdrassoc 10 (entget #en))))
					(setq #h (cadr  (cdrassoc 10 (entget #en))))
					(setq #z$ (GetZPointByLay #en 0))
					(mapcar
						'(lambda (#z)
							; 04/04/13 SK MODD-S �Ζʃv�����Ή�
							; �y���W���������́A�g���W�̏���������D�悷��
							(if (equal #z #max 0.001)
								(if (< #h #minH)
									(progn
										(setq #max #z)
										(setq #minH #h)
										(setq #bsym #en)
									)
								)
								(if (> #z #max)
									(progn
										(setq #max #z)
										(setq #minH #h)
										(setq #bsym #en)
									)
								)
							)
							; 04/04/13 SK MODD-E �Ζʃv�����Ή�
						)
						#z$
					)
				)
			)
		)

		; 01/07/31 TM ADD-S �r�[�t���[�䂪����ꍇ�A�Œ�̃V���{�����擾
		;                   (�L���r�l�b�g�{�̂������@���Ⴍ���邽��)
		(if #eBFbas$
			(foreach #en #eBFbas$
				(setq #z (caddr (cdrassoc 10 (entget #en))))
				(setq #z$ (GetZPointByLay #en 0))
				(mapcar
					'(lambda (#z)
						(if (< #z #max)
							(progn
								(setq #max #z)
								(setq #bsym #en)
							)
						)
					)
					#z$
				)
			)
		)
		; 01/07/31 TM ADD-E �r�[�t���[�䂪����ꍇ�A�Œ�̃V���{�����擾

		;�A�b�p�[
		(if (/= nil #upp$)
			(progn
				(setq #max (caddr (cdrassoc 10 (entget (nth 0 #upp$)))))
				(setq #usym (nth 0 #upp$))
				(foreach #en #upp$
;					(setq #z (caddr (cdrassoc 10 (entget #en))))
					(setq #z$ (GetZPointByLay #en 0))
					(mapcar
						'(lambda (#z)
							(if (> #z #max)
								(progn
									(setq #max #z)
								)
							)
						)
						#z$
					)
				)

				(foreach #en #upp$
					(setq #z (caddr (cdrassoc 10 (entget #en))))
					(setq #z$ (GetZPointByLay #en 0))
					(mapcar
						'(lambda (#z)
							(if (equal #z #max #sa) ;2019/03/15 YM ADD ���e�͈͊g�� 2018����ި���[���ʐ},���ʐ}�Ő��@���o�Ȃ���
								(if (= CG_SKK_TWO_UPP (CFGetSymSKKCode #en 2))
									(setq #usym  #en)
									(setq #usym$ (cons #en #usym$))
								)
							)
						)
						#z$
					)
				)
			)
		) ;_if (/= nil #upp$)

		(if (and #bsym (cons #usym #usym$) #bh)
			(list #bsym (cons #usym #usym$) #bh)
			nil
		)
	) ; SCF_B_GetSym

	;<HOM>*************************************************************************
	; <�֐���>    : SCF_Aub_GetSym
	; <�����T�v>  : ���@����}����x�[�X�ƃA�b�p�[�ƑS�̂̍��W���X�g�l��
	; <�߂�l>    : �i�x�[�X �A�b�p�[ �S�́j
	; <�쐬>      : 00/02/10
	;*************************************************************************>MOH<
	(defun SCF_Aub_GetSym (
		&ss         ; �V���{���I���G���e�B�e�B
		&KorD
		/
		#i #en #ed$ #code$ #base$ #midd$ #uppu$ #h #sideu$ #sideb$ #bpt$
		#upt$ #umpt$ #pt$ #spt$
		#eSinkbase
		#bpttmp$
		)
		;���ʃt���O�����ʂ̂��݂̂̂��l��
		(setq #i 0)
		(repeat (sslength &ss)
			(setq #en    (ssname &ss #i))
			(setq #ed$   (CfGetXData #en "G_SKDM"))
			(setq #code$ (CfGetSymSKKCode #en nil))

			; ���ʃt���O������
			(if (= 1 (nth 3 #ed$))
				(progn
					(if (= CG_SKK_ONE_CAB (nth 0 #code$))
						;�L���r�l�b�g
						(progn
							(cond
								((= CG_SKK_TWO_BAS (nth 1 #code$))   ; �x�[�X
									(if (= CG_SKK_THR_SNK (nth 2 #code$)) ; 2000/10/19 HT �V���N
										(setq #eSinkbase #en)
										(setq #base$ (cons #en #base$))
									)
								)
								((= CG_SKK_TWO_MID (nth 1 #code$))   ; �~�h��
									(setq #midd$ (cons #en #midd$))
								)
								((= CG_SKK_TWO_UPP (nth 1 #code$))   ; �A�b�p�[
									(setq #uppu$ (cons #en #uppu$))
								)
							)
						)
						;���̑�
						(progn
							(cond
								;�T�C�h�p�l��
								((= CG_SKK_ONE_SID (nth 0 #code$))
									(if (= CG_SKK_TWO_BAS (nth 1 #code$))
										;�x�[�X
										(progn
											(setq #h (nth 5 (CfGetXData #en "G_SYM")))
											(if (equal CG_CeilHeight #h 0.01)
												(setq #sideu$ (cons #en #sideu$))
											)
											(setq #sideb$ (cons #en #sideb$))
										)
										;�A�b�p�[
										(progn
											(setq #sideu$ (cons #en #sideu$))
										)
									)
								)
								;�����W�t�[�h
								((= CG_SKK_ONE_RNG (nth 0 #code$))
									(setq #uppu$ (cons #en #uppu$))
								)
								;�①�� 2000/07/25 �ǉ�
								((and (= CG_SKK_ONE_ETC (nth 0 #code$))
											(= CG_SKK_TWO_BAS (nth 1 #code$))
											(= CG_SKK_THR_NRM (nth 2 #code$)) ;�①�ɁA�y�j���V����
									)
									(setq #base$ (cons #en #base$))
								)
							)
						)
					)
				)
			)
			(setq #i (1+ #i))
		)
		;�x�[�X
		(if (/= nil #base$)
			(progn
				(mapcar
				 '(lambda ( #en / #bpttmp$ )
						; (setq #bpt$ (append (Get2PointByLay #en) #bpt$))
						; ���o�[�V�u���Ή� 2000/10/20 HT MOD START
						; ���ʂ̂ݏo��
						; 06/09/20 T.Ari Mod ��֕������Ă���x�[�X�L���r���l��
						(setq #bpttmp$ (Get2PointByLay #en 0))
						(setq #bpttmp$ (list (polar (car #bpttmp$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM"))))
																 (polar (cadr #bpttmp$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM"))))))
						(setq #bpt$ (append #bpttmp$ #bpt$))
;						(setq #bpt$ (append (Get2PointByLay #en 0) #bpt$))
            ; ���o�[�V�u���Ή� 2000/10/20 HT MOD END
					)
					(append #base$ #sideb$)
				)
			)
		)

		; ���o�[�V�u���Ή� 2000/10/20 HT MOD START
		; ���ʂ̂ݏo��
		; �������A�V���N�L���r�Ȃ�w�ʁE���ʉ�
		(if (/= nil #eSinkbase)
			(progn
				; �x�[�X�L���r�l�b�g�̂����V���N
				; 06/09/20 T.Ari Mod ��֕������Ă���x�[�X�L���r���l��
				(setq #bpttmp$ (Get2PointByLay #eSinkbase 1))
				(setq #bpttmp$ (list (polar (car #bpttmp$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #eSinkbase "G_LSYM"))))
														 (polar (cadr #bpttmp$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #eSinkbase "G_LSYM"))))))
				(setq #bpt$ (append #bpttmp$ #bpt$))
;				(setq #bpt$ (append (Get2PointByLay #eSinkbase 1) #bpt$))
				(append #base$ (list #eSinkbase))
			)
		)
		; ���o�[�V�u���Ή� 2000/10/20 HT MOD END
		; Y���W�Ń\�[�g����
		(setq #bpt$ (CfListSort #bpt$ 1))
		;�A�b�p�[
		(if (/= nil #uppu$)
			(progn
				(mapcar
				 '(lambda ( #en )
						;(setq #upt$ (append (Get2PointByLay #en) #upt$))
						(setq #upt$ (append (Get2PointByLay #en 1) #upt$))
					)
					#uppu$
				)
				(if (and (/= nil #upt$) (or (> (length #upt$) 2) (/= (length #sideu$) 0)))
					(progn
						; �T�C�h�p�l���̍��W���Z�o
						(mapcar
						 '(lambda ( #en )
								;(setq #spt$ (append (Get2PointByLay #en) #spt$))
								(setq #spt$ (append (Get2PointByLay #en 1) #spt$))
							)
							#sideu$
						)
						(if (= &KorD "K")
							(progn
								(setq #umpt$ (PtSort #upt$ 0.0 T))
								(setq #umpt$ (list (car #umpt$) (last #umpt$)))
								(setq #umpt$ (append #umpt$ #spt$))
							)
							(setq #upt$ (append #upt$ #spt$))
						)
					)
				)
			)
		)

		(list #bpt$ #upt$ #umpt$)
	) ; SCF_Aub_GetSym

	;<HOM>*************************************************************************
	; <�֐���>    : SCF_A_DrawDim
	; <�����T�v>  : �`�^�̐��@����}
	; <�߂�l>    : �Ȃ�
	; <�쐬>      : 00/02/07
	;*************************************************************************>MOH<
	(defun SCF_A_DrawDim (
		&ss$
		&iti$       ; ���@�\���ʒu���X�g
		/
		#ss #ss$ #pt$ #bpt #upt #all$ #ball$
		#i
		)
		(setq #i 0)
		(foreach #ss (apply 'append &ss$)
			;���W�l��
			(setq #pt$ (SCF_Aub_GetSym #ss (if (and (car &ss$) (< #i (length (car &ss$)))) "K" "D")))
			(setq #i (1+ #i))
			;�x�[�X
			;	���@�\���ʒu (����)
			;	����W ... ���݂̐��@�\���ʒu����Ƃ��č쐬 (���؂�)
			;	���@���W ... ����W ���� �P�s�����̈ʒu�Ƃ���
			; �������A���؂肷��͎̂{�H���@�̂���ꍇ�̂�
			(if (/= nil (car #pt$))
				(progn
					(setq #bpt (car (nth 0 #pt$)))
	;					01/03/01 TM MOD ���@���̑��؂�
					; �{�H���@���Ȃ��ꍇ�͑��؂肵�Ȃ�
					(if (= (nth 1 &iti$) 0)
						; ���؂�Ȃ�
						(progn
							(setq #dpt (polar #bpt (* 1.5 PI) (GetDimHeight (nth 1 &iti$))))
						)
						; ���؂�
						(progn
							(setq #bpt (polar #bpt (* 1.5 PI) (GetDimHeight (1- (nth 1 &iti$)))))
							(setq #dpt (polar #bpt (* 1.5 PI) CG_DimHeight_1Line))
						)
					)
					(SCFDrawDimLin (nth 0 #pt$) #bpt #dpt "H")
					(setq #ball$ (append #ball$ (nth 0 #pt$)))
				)
			)
			;�A�b�p�[
			;	���@�\���ʒu (����)
			;	����W ... ���݂̐��@�\���ʒu����Ƃ��č쐬 (���؂�)
			;	���@���W ... ����W ���� �P�s����̈ʒu�Ƃ���
			; �������A���؂肷��͎̂{�H���@�̂���ꍇ�̂�
			(if (and (/= nil (nth 0 #pt$)) (/= nil (nth 1 #pt$)))
				(progn
	; 01/04/11 TM MOD �V�䍂�����琡�@�������悤�ɕύX
	;	         (if (= nil #bpt)
	;						(progn
	;							; ����̂݃L���r�l�b�g�̍��W��p����
	;	            (setq #bpt (nth 0 (nth 1 #pt$)))
	;						)
	;						; �Q��ڈȍ~�͑��Όv�Z
	;						(progn
	;	            (setq #bpt (nth 0 (nth 1 #pt$)))
	;							; 01/04/10 TM DEL ���؂肪����ꍇ�͂����ł͏グ�Ȃ�
	;          		;(setq #dpt (polar #bpt (* 0.5 PI) (GetDimHeight (nth 0 &iti$))))
	;						)
	;					)
	; 01/04/11 TM MOD  �V�䍂�����琡�@�������悤�ɕύX
					; �ʒu���L���r�l�b�g���W�A������V�䍂���ɐݒ�
					(setq #bpt (nth 0 (nth 0 #pt$)))
					(setq #bpt (polar #bpt (* 0.5 PI) CG_CeilHeight))
	; 01/04/11 TM MOD  �V�䍂�����琡�@�������悤�ɕύX

					; ���@�\����ʒu���Q�l�ɁA�L���r�l�b�g���@�\���ʒu���v�Z����
					;	�{�H���@���Ȃ��ꍇ�͑��؂肵�Ȃ�
					(if (= (nth 0 &iti$) 0)
						; ���؂�Ȃ�
						(progn
	; 01/04/11 TM DEL �V�䍂�����琡�@�������悤�ɕύX
	;	       		(setq #bpt (polar #bpt (* 0.5 PI) CG_DimHeight_1Line))
							(setq #dpt (polar #bpt (* 0.5 PI) (GetDimHeight (nth 0 &iti$))))
						)
						; ���؂�
						(progn
	;	01/04/11 TM MOD �V�䍂�����琡�@�������悤�ɕύX
	;						(setq #bpt (polar #bpt (* 0.5 PI) (GetDimHeight (+ (nth 0 &iti$) 1))))
							(setq #bpt (polar #bpt (* 0.5 PI) (GetDimHeight (nth 0 &iti$))))
							; ���@���W�͏�L�Ōv�Z�������W�̂P�s����
							(setq #dpt (polar #bpt (* 0.5 PI) CG_DimHeight_1Line))
						)
					)
					(SCFDrawDimLin (nth 1 #pt$) #bpt #dpt "H")
				)
			)
			; �S�̂̐��@�\���̂��߂ɁA�����Ƃ��O��(�Ō�ɕ`�����)�̊���@���L������
			(if (/= nil #bpt) (setq #upt #bpt))
			; 01/05/14 TM ADD �����̐��@���ρB�K���Ō�̓_����_�ɂȂ��Ă�̂ŁA�����ō��E���l������K�v�͂Ȃ��H

			;�S�̂����X�g�Ɋi�[
			(if (and (/= nil (nth 0 #pt$)) (/= nil (nth 1 #pt$))(/= nil (nth 2 #pt$)))
				(progn
					(setq #all$ (append #all$ (nth 2 #pt$)))
				)
			)
		)

		;�S��
		(if (and &iti$ #all$ #upt #bpt)
			(progn
				;2000/07/12 U�^�ŉ����ɐ��@���쐬������Q�����C
				;(SCFDrawDimLin #all$ #upt (polar #bpt (* 0.5 PI) (GetDimHeight (1+ (nth 0 &iti$)))) "H")
				; 01/03/02 TM MOD ���؂�Ή���ǉ�
				;	�{�H���@�̗L��(=���؂�̗L��)�ɂ���đS�̐��@�̕\���ʒu���ω�����
				(if (= (nth 0 &iti$) 0)
					(progn
						(SCFDrawDimLin #all$ #upt (polar #upt (* 0.5 PI) (GetDimHeight (1+ (nth 0 &iti$)))) "H")
					)
					(progn
						(SCFDrawDimLin #all$ #upt (polar #upt (* 0.5 PI) (* CG_DimHeight_1Line 2)) "H")
					)
				)
			)
		)
		(if (and (= CG_PlanType "SD") (< 2 (length #ball$)))
			(progn
				(setq #ball$ (2dto3d (PtSort (3dto2d #ball$) 0.0 T)))
				(setq #ball$ (list (car #ball$) (last #ball$)))
				(if (= (nth 1 &iti$) 0)
					; ���؂�Ȃ�
					(progn
						(SCFDrawDimLin #ball$ (car #ball$) (polar (car #ball$) (* 1.5 PI) (GetDimHeight (1+ (nth 1 &iti$)))) "H")
					)
					; ���؂�
					(progn
						(setq #bpt (polar (car #ball$) (* 1.5 PI) (GetDimHeight (1- (nth 1 &iti$)))))
						(SCFDrawDimLin #ball$ #bpt (polar #bpt (* 1.5 PI) (* CG_DimHeight_1Line 2)) "H")
					)
				)

			)
		)


		(princ)
) ; SCF_A_DrawDim

;<HOM>*************************************************************************
; <�֐���>    : DrawSideDim
; <�����T�v>  : ���E�̐��@����}����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/02/17
; <���l>      :
;*************************************************************************>MOH<
(defun DrawSideDim (
	&ss         ; ���f���P���̑I���G���e�B�e�B
	&flg        ; ���E�t���O("L","R")
	&layer      ; ��w��
	&bpt        ; ����W�_
	&iti        ; ���@��}�ʒu
	/
	#i #en #code #pt$ #en$ #ptt$ #ent$ #ang #bpt #enpt$ #pt #base #en_n$ #basept
	#dMinMax$		; �̈�ő�^�ŏ����W���X�g
	#bh$        ; 04/04/13 SK ADD �ϐ��錾�ǉ�
#sa ;2019/03/15 YM ADD
	)
	;���f���t���O�l��
	(setq #kd (nth 1 (CfGetXData (ssname &ss 0) "G_SKDM")))

	;�L���r�l�b�g�ƃJ�E���^�[�V�ƃ����W�t�[�h���l��
	(setq #i 0)
	(repeat (sslength &ss)
		(setq #en   (ssname &ss #i))
		(setq #code (CFGetSymSKKCode #en 1))
		(if
			(and
				;���ʃt���O
				(= 1 (nth 3 (CfGetXData #en "G_SKDM")))
				;�L���r�l�b�g
				(or
					(= CG_SKK_ONE_CAB #code)
					(= CG_SKK_ONE_CNT #code)
					(= CG_SKK_ONE_RNG #code)
				)
			)
			(progn
				; (setq #pt$ (Get2PointByLay #en))
				(setq #pt$ (Get2PointByLay #en 1))
			; 06/09/20 T.Ari Mod ��֕������Ă���x�[�X�L���r���l��
				(if (= CG_SKK_TWO_BAS (CFGetSymSKKCode #en 2))
					(progn
						(setq #en$ (cons (list (polar (car #pt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM")))) #en) #en$))
						(setq #en$ (cons (list (polar (cadr #pt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM")))) #en) #en$))
						(setq #bh$ (cons (+ (nth 13 (CfGetXData #en "G_LSYM")) (nth 2 (nth 1 (CfGetXData #en "G_LSYM")))) #bh$))
					)
					(progn
						(setq #en$ (cons (list (car  #pt$) #en) #en$))
						(setq #en$ (cons (list (cadr #pt$) #en) #en$))
					)
				)
			)
		)
		;(setq #ptt$ (Get2PointByLay #en))
		(setq #ptt$ (Get2PointByLay #en 1))
		; 06/09/20 T.Ari Mod ��֕������Ă���x�[�X�L���r���l��
		(if (= CG_SKK_TWO_BAS (CFGetSymSKKCode #en 2))
			(progn
				(setq #ent$ (cons (list (polar (car #ptt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM")))) #en) #ent$))
				(setq #ent$ (cons (list (polar (cadr #ptt$) (* PI 1.5) (nth 2 (nth 1 (CfGetXData #en "G_LSYM")))) #en) #ent$))
			)
			(progn
				(setq #ent$ (cons (list (car  #ptt$) #en) #ent$))
				(setq #ent$ (cons (list (cadr #ptt$) #en) #ent$))
			)
		)
		(setq #i (1+ #i))
	)

	;�x�[�X�L���r�l�b�g����
	(setq #bh (apply 'max #bh$))
	;���W�\�[�g
	(setq #en$  (SCFmg_sort$ 'caar #en$))
	(setq #ent$ (SCFmg_sort$ 'caar #ent$))
	(if (= "L" &flg)
		(progn
			(setq #ang PI)
			; 01/08/02 TM ADD ���W�̍����Œ�
			(setq #bpt
				(list
					(car (KCFCmnListMinMax (mapcar 'car (mapcar 'car #en$))))
					(car (KCFCmnListMinMax (mapcar 'cadr (mapcar 'car #en$))))
					(car (KCFCmnListMinMax (mapcar 'caddr (mapcar 'car #en$))))
				)
			)
		)
		(progn
			(setq #ang 0.0)
			(setq #en$  (reverse #en$))
			(setq #ent$ (reverse #ent$))
			; 01/08/02 TM ADD ���W�̉E���Œ�
			(setq #bpt
				(list
					(cadr (KCFCmnListMinMax (mapcar 'car (mapcar 'car #en$))))
					(car (KCFCmnListMinMax (mapcar 'cadr (mapcar 'car #en$))))
					(car (KCFCmnListMinMax (mapcar 'caddr (mapcar 'car #en$))))
				)
			)
		)
	)

	;2019/03/15 YM ADD-S
	(if (= BU_CODE_0014 "1") ; PSKD
		(setq #sa 26.01)
		;else ����ȊO
		(setq #sa  6.01)
	);_if
	;2019/03/15 YM ADD-E

	; 01/08/02 TM MOD ���W�_�̈�̉E���^��������������悤�ɕύX
	;(setq #bpt (car (car #en$)))
	(foreach  #enpt$ #en$
		(setq #pt (car  #enpt$))
		(setq #en (cadr #enpt$))
		(setq #code (CFGetSymSKKCode #en 2))
		; �x�[�X�L���r�l�b�g�Ɠ������W�̂��̂̂�
;;;		(if (equal (car #bpt) (car #pt) 0.01)

;;;(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ

		;2017/09/21 YM ADD �ڰѷ��݂̏ꍇ�͒ʂ�(���ʏc���@����}����)
		;2019/03/15 YM ADD ���e�͈͊g�� 2018����ި���[���ʐ},���ʐ}�Ő��@���o�Ȃ���

	
		(if (or (= BU_CODE_0012 "1") (equal (car #bpt) (car #pt) #sa)) ;���Ԍ��Ή��V��5mm�J���Ă��� 2017/01/27 YM ADD 

			(if (= CG_SKK_TWO_BAS #code)
				(progn
					(if (/= CG_SKK_ONE_CNT (CFGetSymSKKCode #en 1))
						(setq #base #en)
						(setq #en_n$ (cons #en #en_n$))
					)
				)
				(setq #en_n$ (cons #en #en_n$))
			);_if

		);_if

	)

	(if (/= #base nil)
		(progn
			(setq #en$ (cons #base #en_n$))

			(setq #basept (car (car #ent$)))
			;���@��}
			(if (= "K" #kd)
				(if (= "L" &flg)
; 01/08/02 TM MOD ��_���w�肷��悤�ɕύX
;          (SCF_B_DrawDim_Kit &layer #en$ #ang &bpt &iti 1 #bh)
;          (SCF_B_DrawDim_Kit &layer #en$ #ang &bpt &iti 0 #bh)
					(SCF_B_DrawDim_Kit &layer #en$ #ang #bpt &iti 1 #bh)
					(SCF_B_DrawDim_Kit &layer #en$ #ang #bpt &iti 0 #bh)
				)
			 	(if (= "R" &flg)
; 01/08/10 TM MOD ��_���w�肷��悤�ɕύX
;       		(SCF_B_DrawDim_Din &layer #en$ #ang &bpt &iti 1)
;       		(SCF_B_DrawDim_Din &layer #en$ #ang &bpt &iti 0)
			 		(SCF_B_DrawDim_Din &layer #en$ #ang #bpt &iti 1)
			 		(SCF_B_DrawDim_Din &layer #en$ #ang #bpt &iti 0)
				)
			)
		)
	)

	(princ)
) ; DrawSideDim

;<HOM>*************************************************************************
; <�֐���>    : KCFCmnListMinMax
; <�����T�v>  : �w�肵��(����)���X�g�̍ŏ��^�ő�l���擾����
; <�߂�l>    : (�ŏ��l �ő�l)
; <�쐬>      : 01/08/02
;*************************************************************************>MOH<
(defun KCFCmnListMinMax (
	&rlst$	; ���X�g
	/
	#dRet$
	)

	(setq #dRet$
		(list
			(eval (append (list 'min) &rlst$))
			(eval (append (list 'max) &rlst$))
		)
	)
	#dRet$

); KCFCmnListMinMax

;<HOM>*************************************************************************
; <�֐���>    : SCF_B_DrawDim_Kit
; <�����T�v>  : �a�^�̐��@����}�i�L�b�`���j
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/02/03
;*************************************************************************>MOH<
(defun SCF_B_DrawDim_Kit (
	&layer      ; ��w
	&sym$       ; ���@����}����V���{���}�`���i�x�[�X �A�b�p�[���̑��j
	&ang        ; ���@���o�͂���p�x
	&bpt        ; ��ʒu���W(nil�̂Ƃ��x�[�X�̍��W)
	&iti        ; ���@��}�ʒu
	&flg        ; �V�䍂�����@�o�̓t���O�i1=ON 1�ȊO=OFF�j
	&bh         ; �x�[�X�L���r�l�b�g����
	/
	#en
	#code$ 			; ���iCODE
	#tenb #wt$ #bsym #ed$ #bpt #ang #bpt2 #base #tbpt2 #bg #sym #upt #upt$ #ceil #pt$
	#xDimPt			; ���@���W     01/03/07 TM ADD  ���@�����؂�p
	#eBFbas			; �r�[�t���[�� 01/08/01 TM ADD
	#pt0        ; ������       01/09/23 HN ADD
	)
	(foreach #en (cdr &sym$)
		(setq #code$ (CFGetSymSKKCode #en nil))
		(if (= CG_SKK_ONE_CNT (nth 0 #code$))
			(setq #tenb #en)
		)

	)

	;���[�N�g�b�v�f�[�^�l��
	(setq #wt$ (car (SCFGetWrktXdata &layer)))

	;�x�[�X�ʒu
	(setq #bsym (car  &sym$))
 	(setq #ed$  (CfGetXData #bsym "G_SYM"))
 	(setq #bpt  (cdrassoc 10 (entget #bsym)))
	; 06/09/20 T.Ari Add ��֕������Ă���x�[�X�L���r���l��
 	(setq #bpt (polar #bpt (* PI 1.5) (nth 2 (nth 1 (CfGetXData #bsym "G_LSYM")))))

	;����W
	(if (/= nil &bpt)
		(setq #base &bpt)
		(setq #base #bpt)
	)

	; H�����t���O���擾
	(if (= 1 (nth 10 #ed$))
		(setq #ang (* PI 0.5))
		(setq #ang (* PI 1.5))
	)
	(setq #ed$  (CfGetXData #bsym "G_LSYM"))
;  (if (/= nil #tenb)
;    (setq #bpt2 (polar #bpt #ang                (nth 13 #ed$)))
; 2000/06/308 HT �o�b�N�K�[�h�ʒu���@�ʒu�s���̏�Q���C
;                ���[�N�g�b�v�̉��[��t���@�Ƃ���
	;    (setq #bpt2 (polar #bpt #ang (+ (cadr #wt$) (nth 13 #ed$))))
	; (setq #bpt2 (polar #bpt #ang (+ (cadr #wt$) &bh)))
	; 01/03/26 HN S-MOD �o�b�N�K�[�h�Ȃ���z��
	(if #wt$
		; 01/08/02 TM MOD ����@����ɂ���悤�ɕύX
		;(setq #bpt2 (polar #bpt #ang (+ (nth 1 #wt$) (nth 4 #wt$))))
		(setq #bpt2 (polar #base #ang (+ (nth 1 #wt$) (nth 4 #wt$))))
	)
	; 01/03/26 HN E-MOD �o�b�N�K�[�h�Ȃ���z��
;  )

	;�a�f����
	; 01/05/24 TM ADD ���[�N�g�b�v���Ȃ��ꍇ�ABG���Ȃ��͂�
	(if #wt$
		(if (/= nil #tenb)
			(progn
				; 01/08/02 TM MOD ����@����ɂ���悤�ɕύX
				;(setq #tbpt2 (polar #bpt #ang (+ (cadr #wt$) &bh)))
				(setq #tbpt2 (polar #base #ang (+ (cadr #wt$) &bh)))
				(setq #bg   (polar #tbpt2 (* PI 0.5) (nth 3 #wt$)))
			)
			; 01/03/26 HN S-MOD �o�b�N�K�[�h�Ȃ���z��
			(if #wt$
				(setq #bg   (polar #bpt2 (* PI 0.5) (nth 3 #wt$)))
			)
			; 01/03/26 HN E-MOD �o�b�N�K�[�h�Ȃ���z��
		)
	)

	;���̑��̃V���{���ʒu
	(foreach #sym (cdr &sym$)
		(if (not (equal #tenb #sym))
			(progn
				(setq #ed$  (CfGetXData #sym "G_SYM"))
				(setq #upt  (cdrassoc 10 (entget #sym)))
				(setq #upt$ (cons #upt #upt$))
				; H�����t���O 1=����
				(if (= 1 (nth 10 #ed$))
					(setq #ang (* PI 0.5))
					(setq #ang (* PI 1.5))
				)
				; �V���{����lH
				(setq #upt (polar #upt #ang (nth 5 #ed$)))
				(setq #upt$ (cons #upt #upt$))
			)
		)
	)

	; 01/09/23 HN S-MOD ���@�ɏ�������ǉ�
	;@MOD@; �V�䍂��
	;@MOD@; 01/08/02 TM MOD ����@����ɂ���悤�ɕύX
	;@MOD@;(setq #ceil (polar #bpt (* PI 0.5) CG_CeilHeight))
	;@MOD@(setq #ceil (polar #base (* PI 0.5) CG_CeilHeight))
	;@MOD@
	;@MOD@;���W���܂Ƃ߂�
	;@MOD@; 01/08/02 TM MOD ����@����ɂ���悤�ɕύX
	;@MOD@;(setq #pt$ (append #upt$ (list #bpt #bpt2 #bg #ceil)))
	;@MOD@(setq #pt$ (append #upt$ (list #base #bpt2 #bg #ceil)))

;2008/07/03 YM ADD
; �{�t�@�C���̃��[�h���ɏ��������擾
(setq CG_BaseHeight (SCFGetBaseHeight))

	(if CG_BaseHeight
		(progn
			(setq #ceil (polar #base (* PI 0.5) (- CG_CeilHeight CG_BaseHeight)))
			(setq #pt0 (list (car #base) (- (cadr #base) CG_BaseHeight) (caddr #base)))
			(setq #pt$ (append #upt$ (list #pt0 #base #bpt2 #bg #ceil)))
		)
		(progn
			(setq #ceil (polar #base (* PI 0.5) CG_CeilHeight))
			(setq #pt$ (append #upt$ (list #base #bpt2 #bg #ceil)))
		)
	);_if
	; 01/09/23 HN E-MOD ���@�ɏ�������ǉ�

	; 01/03/07 TM MOD ���ʂ̐��@�����؂肷��
	; ���@���W���쐬
	; �{�H���@�����݂���ꍇ�A�{�H���@�\���̕����@���W���ړ�
	(if (/= nil #pt$)
		(setq #xDimPt (polar #base &ang (GetDimHeight (1+ &iti))))
		(setq #xDimPt (polar #base &ang (GetDimHeight &iti)))
	)

	;	�ʒu�f�[�^�����݂���ꍇ�A����W�𐓏グ���� (= ���؂�)
	(if (/= 0 &iti)
		(setq #base (polar #xDimPt (+ PI &ang) CG_DimHeight_1Line))
	)
	;�L���r�l�b�g�����@��}
	; 01/03/07 TM MOD ���ʂ̐��@�����؂肷��
	;  (SCFDrawDimLin #pt$ #base (polar #base &ang (GetDimHeight &iti)) "V")
	(SCFDrawDimLin #pt$ #base #xDimPt "V")

	;�V�䍂�����@��}
	(if (= 1 &flg)
		(progn
			(setq #pt$ (PtSort #pt$ (* 0.5 PI) T))
			(setq #pt$ (list (car #pt$) (last #pt$)))
	; 01/03/07 TM MOD ���ʂ̐��@�����؂肷��
	;   (SCFDrawDimLin #pt$ #base (polar #base &ang (GetDimHeight (1+ &iti))) "V")
			(SCFDrawDimLin #pt$ #xDimPt (polar #xDimPt &ang  CG_DimHeight_1Line) "V")
		)
	)

	(princ)
) ; SCF_B_DrawDim_Kit


;<HOM>*************************************************************************
; <�֐���>    : SCF_B_DrawDim_Din
; <�����T�v>  : �a�^�̐��@����}�i�_�C�j���O�j
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/02/17
;*************************************************************************>MOH<
(defun SCF_B_DrawDim_Din (
	&layer      ; ��w
	&sym$       ; ���@����}����V���{���}�`���i�x�[�X �A�b�p�[���̑��j
	&ang        ; ���@���o�͂���p�x
	&bpt        ; ��ʒu���W
	&iti        ; ���@��}�ʒu
	&flg        ; �V�䍂�����@�o�̓t���O�i1=ON =OFF�j
	/
	#en #code #temb #en$ #bsym #ed$ #bpt #ang #bpt2 #sym #upt #upt$ #ceil #pt$ #bg
	#xDimPt			; ���@���W  01/03/07 TM ADD  ���@�����؂�
	#pt0        ; ������    01/09/23 HN ADD
	#BASE #CODE$ #COOK-FLG #DUM$ #SCOOKFREE #TSENMEN_CT #WT$ ; 02/12/16 YM ADD
	#taimen$ #tDepth #tAng  ; �Ζʏ�� 04/03/25 SK ADD
	#tembH                  ; �V��� 04/03/25 SK ADD
	ftpType                 ; �t���b�g�v�����^�C�v "SF":�Z�~�t���b�g "FF":�t���t���b�g
	#sLongBg #rLongBg-Minus #rLongBg-BG #LongBg	;06/07/13 T.Ari ADD �R�����L���r�o�b�N�K�[�h�Ή�
	#CookFree$ #CookFree$$ #LongBg$ #LongBg$$	;06/08/01 T.Ari ADD CookFree & LongBg ini->DB
	#hinban #CookFree	;06/08/01 T.Ari ADD CookFree & LongBg ini->DB
	#counters$$ ; �J�E���^�[��񃊃X�g(�t���[���L�b�`���p)
	#ct #counter$
	)



;|
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	; 04/03/25 SK ADD-S �Ζʃv�����Ή�
	; �Ζʃv�����̓W�J�a�c���@�̑Ή�
	(if (setq #ftpType (SCFIsTaimenFlatPlan))
		(progn
			; �Ζʑ��ƂȂ�L���r�̉��s���Ɖ��s���p�x�����߂�
			;2008/08/13 YM DEL
;;;      (setq #taimen$ (SCFGetTaimenFlatPlanInfo &sym$));nil���Ԃ��Ă��܂��̂őΖʂƂ݂Ȃ���Ȃ�

;;;      (if #taimen$ ;2008/08/13 YM DEL
				(cond
;2008/08/13 YM DEL
;;;          ((= #ftpType "SF")
;;;            ; ���@��}�J�n�_�����s�������������ʒu�ɒ�������
;;;            (setq #tDepth (car  #taimen$))
;;;            (setq #tAng   (cadr #taimen$))
;;;            (setq #tAng (+ #tAng pi))
;;;            (setq #tDepth (nth 4 (CFGetXData (car &sym$) "G_SYM")))
;;;            (setq &bpt (polar &bpt #tAng #tDepth))
;;;            (setq &ang (+ &ang pi))
;;;          )
;;;          ((= #ftpType "FF")
;;;            ; ���@��}�J�n�_�����s�������������ʒu�ɒ�������
;;;            (setq #tDepth (car  #taimen$))
;;;            (setq #tAng   (cadr #taimen$))
;;;            (setq &bpt (polar &bpt #tAng #tDepth))
;;;          )

					; ���@��}�J�n�_�����s�������������ʒu�ɒ�������
					((= #ftpType "D105")
						(setq #tDepth 400)
						(setq &bpt (polar &bpt &ang #tDepth))
					)


					;2009/04/17 YM ADD-S �ް�����
					((= #ftpType "D650")
						(setq #tDepth 350)
						(setq &bpt (polar &bpt &ang #tDepth))
					)
					;2009/04/17 YM ADD-E


					((= #ftpType "D970")
						(setq #tDepth 320)
						(setq &bpt (polar &bpt &ang #tDepth))
					)
					((= #ftpType "D900")
						(setq #tDepth 250)
						(setq &bpt (polar &bpt &ang #tDepth))
					)
					(T
					 	nil
				 	)
				);_cond
;;;      );_if
		)
	);_if
|;
	; 04/03/25 SK ADD-E �Ζʃv�����Ή�
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	;�V�̃V���{���l��
	(setq #tSENMEN_CT nil); 01/09/05 YM ADD ���ʶ��������==>T

	; 02/06/19 YM ADD-S �Վ������ǉ� /////////////////////////////////////////////
	; ���ق��Ȃ����݂̂Ƃ�&sym$�ɺ�ۂ�2���遨�W�J�c�}�̍��������̐��@
	; ��WT�t�߂̐��@����������(��ۂ̐��@�������Ă���)
	; &sym$�̂������i����210�̂��̂͏��O���鏈����ǉ�����Ƃ��܂�������.
	(setq #dum$ nil)
	(foreach sym &sym$
		(if (and sym (= CG_SKK_INT_GAS (nth 9 (CFGetXdata sym "G_LSYM"))))
			nil
		;else
			(setq #dum$ (append #dum$ (list sym)))
		);_if
	)
	(setq &sym$ #dum$)

	; 02/06/19 YM ADD-E �Վ������ǉ� /////////////////////////////////////////////
	(foreach #en (cdr &sym$)
		(if #en
			(progn
				(setq #code  (CFGetSymSKKCode #en 1))
				(setq #code$ (CFGetSymSKKCode #en nil)) ; 01/09/05 YM ADD

				; �J�E���^�[�V�Ȃ�V���{����lH���擾
				; ����ȊO�Ȃ�}�`���擾
				; 01/09/05 YM MOD-S
				(if (= CG_SKK_ONE_CNT #code) ; �����������
					(progn
						(setq #temb (nth 5 (CfGetXData #en "G_SYM"))) ; ����

						;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
						; 04/03/25 SK ADD-S �Ζʃv�����Ή�
						(setq #tembH (nth 2 (nth 1 (CfGetXData #en "G_LSYM"))))
						; 04/03/25 SK ADD-E �Ζʃv�����Ή�
						;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

						(if (= (caddr #code$) CG_SKK_THR_ETC) ; ���ʶ����������
							(setq #tSENMEN_CT T)
						);_if
					)
					(setq #en$ (cons #en #en$))
				);_if
				; 01/09/05 YM MOD-E

;;;01/09/05YM@MOD				(if (= CG_SKK_ONE_CNT #code)
;;;01/09/05YM@MOD					(setq #temb (nth 5 (CfGetXData #en "G_SYM")))
;;;01/09/05YM@MOD					(setq #en$ (cons #en #en$))
;;;01/09/05YM@MOD				)

			)
		)
	)
	; �J�E���^�[�V�Ȃ�������A0�ɏ�����
	(if (= nil #temb) (setq #temb 0))

	;�x�[�X
	(setq #bsym (car  &sym$))
	(setq #ed$  (CfGetXData #bsym "G_SYM"))

	; �}�`���g����擾
	(if (or (= CG_DRSeriCodeRV nil) (= CG_DRSeriCodeRV ""))
		; RV �ȊO�͊�_
		(progn
			(setq #bpt  (cdrassoc 10 (entget #bsym)))
			; 06/09/20 T.Ari Add ��֕������Ă���x�[�X�L���r���l��
			(setq #bpt (polar #bpt (* PI 1.5) (nth 2 (nth 1 (CfGetXData #bsym "G_LSYM")))))
		)
		; RV �̏ꍇ�A���ʈʒu����_�Ƃ���
		(progn
			(setq #bpt (nth 2 (GetSym4Pt #bsym)))
			; 06/09/20 T.Ari Add ��֕������Ă���x�[�X�L���r���l��
			(setq #bpt (polar #bpt (* PI 1.5) (nth 2 (nth 1 (CfGetXData #bsym "G_LSYM")))))
		)
	)
	; 01/08/10 TM MOD �ʒu���ړ�
	;����W
	(if (/= nil &bpt)
		(setq #base &bpt)
		(setq #base #bpt)
	)

	; 01/03/07 TM MOD ���ʂ̐��@�����؂肷��
	; H�����t���O������
	(if (= 1 (nth 10 #ed$))
		(setq #ang (* PI 0.5))
		(setq #ang (* PI 1.5))
	)
	(setq #ed$  (CfGetXData #bsym "G_LSYM"))

	;���[�N�g�b�v�f�[�^�l��  (�V���N���Ȃ�WT�̏ꍇ(D-RIGHT)�̑Ή�)
	; 2000/08/28 HT
	(setq #wt$ (car (SCFGetWrktXdata &layer)))
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	; 04/03/25 SK ADD-S �Ζʃv�����Ή�
	; �Ζʂd�̎��[���͓V���̐��@�Ƃ���
	(if (and #ftpType (/= #temb 0))
		(setq #wt$ (list "" 0.0 1 #temb #tembH))
	)
	; 04/03/25 SK ADD-E �Ζʃv�����Ή�
	;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	(if (= (car #wt$) nil)
		(progn
			; ��_ ���� (���@H + �J�E���^�[�V�V���{����lH)�̍����ʒu
			; 01/08/02 TM MOD ����@����ɂ���悤�ɕύX
			;(setq #bpt2 (polar #bpt #ang (+ #temb (nth 13 #ed$))))
			(setq #bpt2 (polar #base #ang (+ #temb (nth 13 #ed$))))
			(setq #bpt2 (polar #bpt2 (* PI 0.5) (nth 2 (nth 1 (CfGetXData #bsym "G_LSYM")))))

		;;;01/06/29YM@		(setq #bg nil)
			; WT���Ȃ��Ʒ��݂ɂ�BG���@������01/06/29 YM ADD START

			; 01/09/05 YM MOD-S
			(if (or (KPCheckMiniKitchen &sym$)
							(and (KP_CT_EXIST) #tSENMEN_CT)) ; �������̫�ÑΉ��ذ�ފ����ʶ�������� 01/09/05 YM
			; 01/09/05 YM MOD-E
;;;01/09/05YM@MOD			(if (KPCheckMiniKitchen &sym$)

				; 02/12/16 YM MOD �Ʒ��ݸ��ذ�Ȃ�BG����45mm����ȊO50mm
				(progn
;|
					(setq #sCookFree-Snk (CFgetini "COOKFREE" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
					(setq #rSnk-BG       (CFgetini "COOKFREE" "0002" (strcat CG_SKPATH "ERRMSG.INI")))
					(setq #sCookFree-Gas (CFgetini "COOKFREE" "0003" (strcat CG_SKPATH "ERRMSG.INI")))
					(setq #rGas-BG       (CFgetini "COOKFREE" "0004" (strcat CG_SKPATH "ERRMSG.INI")))
;06/07/13 T.Ari ADD-S �R�����L���r�o�b�N�K�[�h�Ή�
					(setq #sLongBg        (CFgetini "LONGBG"    "0001" (strcat CG_SKPATH "ERRMSG.INI")))
					(setq #rLongBg-Minus  (CFgetini "LONGBG"    "0002" (strcat CG_SKPATH "ERRMSG.INI")))
					(setq #rLongBg-BG     (CFgetini "LONGBG"    "0003" (strcat CG_SKPATH "ERRMSG.INI")))
;06/07/13 T.Ari ADD-E �R�����L���r�o�b�N�K�[�h�Ή�
					(setq #Cookflg-Snk nil)
					(setq #Cookflg-Gas nil)
|;
					(setq #CookFree$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from COOKFREE")))
					(setq #LongBg$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from LONGBG")))
					(setq #CookFree nil)
					(setq #LongBg nil)	;06/07/13 T.Ari ADD �R�����L���r�o�b�N�K�[�h�Ή�
					(foreach #sym &sym$
						(if #sym ; 03/01/07 YM ADD #sym = nil �΍�
							(progn
								(setq #hinban (nth 5 (CFGetXData #sym "G_LSYM")))
								(if #CookFree$$
									(foreach #CookFree$ #CookFree$$
										(if (wcmatch #hinban (car #CookFree$))
											(setq #CookFree (cdr #CookFree$))
										)
									)
								)
								(if #LongBg$$
									(foreach #LongBg$ #LongBg$$
										(if (wcmatch #hinban (car #LongBg$))
											(setq #LongBg (cdr #LongBg$))
										)
									)
								)
;|
								(if (wcmatch (nth 5 (CFGetXData #sym "G_LSYM")) #sCookFree-Snk)
									(setq #Cookflg-Snk T) ; ����ذ�ݸ����Ɣ��f
								);_if
								(if (wcmatch (nth 5 (CFGetXData #sym "G_LSYM")) #sCookFree-Gas)
									(setq #Cookflg-Gas T) ; ����ذ�޽����Ɣ��f
								);_if
;06/07/13 T.Ari ADD-S �R�����L���r�o�b�N�K�[�h�Ή�
								(if (wcmatch (nth 5 (CFGetXData #sym "G_LSYM")) #sLongBg)
									(setq #LongBg T) ; ����ذ�޽����Ɣ��f
								);_if
;06/07/13 T.Ari ADD-E �R�����L���r�o�b�N�K�[�h�Ή�
|;
							)
						);_if
					)

					(cond
						(#CookFree
							(setq #bg (polar #bpt2 (* PI 0.5) (car #CookFree)))
						)
						(#LongBg
							(setq #bpt2 (polar #bpt2 (* PI 1.5) (car #LongBg)))
							(setq #bg (polar #bpt2 (* PI 0.5) (cadr #LongBg)))
						)
;|
						(#Cookflg-Snk
							(setq #bg (polar #bpt2 (* PI 0.5) (atof #rSnk-BG)))
					 	)
						(#Cookflg-Gas
							(setq #bg (polar #bpt2 (* PI 0.5) (atof #rGas-BG)))
					 	)
;06/07/13 T.Ari ADD-S �R�����L���r�o�b�N�K�[�h�Ή�
						(#LongBg
							(progn
								(setq #bpt2 (polar #bpt2 (* PI 1.5) (atof #rLongBg-Minus)))
								(setq #bg (polar #bpt2 (* PI 0.5) (atof #rLongBg-BG)))
							)
					 	)
;06/07/13 T.Ari ADD-E �R�����L���r�o�b�N�K�[�h�Ή�
|;
						(T
							(setq #bg (polar #bpt2 (* PI 0.5) CG_BG_H))
					 	)
					);_if
				)
				; 02/12/16 YM MOD �Ʒ��ݸ��ذ�Ȃ�BG����45mm����ȊO50mm

			; else
			 	; 2017/06/09 KY MOD-S
			 	; �t���[���L�b�`���Ή�
				;(setq #bg nil)
				(progn
					(setq #bg nil)
					(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
						(progn
							(setq #counters$$ (nth 1 (GetFrameInfo$$ nil T))) ; �J�E���^�[���̎擾
							(if #counters$$
								(progn
									(foreach #counter$ #counters$$
										(setq #ct (nth 2 (nth 3 #counter$))) ; �J�E���^�[�̌���
										(if (and (= nil #bg) (> #ct 0))
											(progn
												(setq #bpt2 (nth 1 #counter$))
												(setq #bpt2 (list (nth 0 #bpt2) (nth 1 #bpt2) 0.0))
												(setq #bg (polar #bpt2 (* PI 0.5) #ct)) ; �J�E���^�[�̌���
											);progn
										);if
									);foreach
								);progn
							);if
						);progn
					);if
				);progn
			 	; 2017/06/09 KY MOD-E
			);_if
			; WT���Ȃ��Ʒ��݂ɂ�BG���@������01/06/29 YM ADD END
		)
		(progn
			; ���[�N�g�b�v�̉��[��t���@�Ƃ���
			; 01/08/02 TM MOD ����@����ɂ���悤�ɕύX
			;(setq #bpt2 (polar #bpt #ang (+ (nth 1 #wt$) (nth 4 #wt$))))
			(setq #bpt2 (polar #base #ang (+ (nth 1 #wt$) (nth 4 #wt$))))
			;�a�f����
			(setq #bg   (polar #bpt2 (* PI 0.5) (nth 3 #wt$)))
		)
	)
	;���̑��̃V���{���ʒu
	(foreach #sym	#en$
		(setq #ed$  (CfGetXData #sym "G_SYM"))
		(setq #upt  (cdrassoc 10 (entget #sym)))
		(setq #upt$ (cons #upt #upt$))
		(if (= 1 (nth 10 #ed$))
			(setq #ang (* PI 0.5))
			(setq #ang (* PI 1.5))
		)
		(setq #ed$ (CfGetXData #sym "G_LSYM"))

		; ��_ ���� ���@H�̍����ʒu
		(setq #upt (polar #upt #ang (nth 13 #ed$)))
		; ��_ ���� ���@H�̍����ʒu���X�g
		(setq #upt$ (cons #upt #upt$))
	)

	; 01/09/23 HN MOD ���@�ɏ�������ǉ�
	;@MOD@;�V�䍂��
	;@MOD@; 01/08/02 TM MOD ����@����ɂ���悤�ɕύX
	;@MOD@;(setq #ceil (polar #bpt (* PI 0.5) CG_CeilHeight))
	;@MOD@(setq #ceil (polar #base (* PI 0.5) CG_CeilHeight))
	;@MOD@
	;@MOD@;���W���܂Ƃ߂�
	;@MOD@; WT������ꍇ�ƂȂ��ꍇ
	;@MOD@;(setq #pt$ (append #upt$ (list #bpt #bpt2 #ceil)))
	;@MOD@(if #bg
	;@MOD@	; 01/08/02 TM MOD ����@����ɂ���悤�ɕύX
	;@MOD@	;(setq #pt$ (append #upt$ (list #bpt #bpt2 #bg #ceil)))
	;@MOD@	(setq #pt$ (append #upt$ (list #base #bpt2 #bg #ceil)))
	;@MOD@	; 01/08/02 TM MOD ����@����ɂ���悤�ɕύX
	;@MOD@	;(setq #pt$ (append #upt$ (list #bpt #bpt2 #ceil)))
	;@MOD@	(setq #pt$ (append #upt$ (list #base #bpt2 #ceil)))
	;@MOD@)

	(if CG_BaseHeight
		(progn
			(setq #ceil (polar #base (* PI 0.5) (- CG_CeilHeight CG_BaseHeight)))
			(setq #pt0 (list (car #base) (- (cadr #base) CG_BaseHeight) (caddr #base)))
			(if #bg
				(setq #pt$ (append #upt$ (list #pt0 #base #bpt2 #bg #ceil)))
				(setq #pt$ (append #upt$ (list #pt0 #base #bpt2     #ceil)))
			)
		);_progn
		(progn
			(setq #ceil (polar #base (* PI 0.5) CG_CeilHeight))
			(if #bg
				(setq #pt$ (append #upt$ (list #base #bpt2 #bg #ceil)))
				(setq #pt$ (append #upt$ (list #base #bpt2     #ceil)))
			)
		);_progn
	);_if
	; 01/09/23 HN E-ADD ���@�ɏ�������ǉ�

	; ���@���W���쐬
	; �{�H���@�����݂���ꍇ�A�{�H���@�\���̕����@���W���ړ�
	(if (/= nil #pt$)
		(setq #xDimPt (polar #base &ang (GetDimHeight (1+ &iti))))
	)

	;	�ʒu�f�[�^�����݂���ꍇ�A����W�𐓏グ���� (= ���؂�)
	(if (/= 0 &iti)
		(progn
			(setq #base (polar #xDimPt (+ PI &ang) CG_DimHeight_1Line))
		)
	)

	;�L���r�l�b�g�����@�}
	(SCFDrawDimLin #pt$ #base #xDimPt "V")

	;�V�䍂�����@��}
	(if (= 1 &flg)
		(progn
			(setq #pt$ (PtSort #pt$ (* 0.5 PI) T))
			(setq #pt$ (list (car #pt$) (last #pt$)))
			; 2000/06/19 HT SCF_B_DrawDim_Kit�Ɠ��������ɂ���  &bpt => #base
			; (SCFDrawDimLin #pt$ &bpt (polar &bpt &ang (GetDimHeight (1+ &iti))) "V")
			; (SCFDrawDimLin #pt$ &bpt (polar #base &ang (GetDimHeight (1+ &iti))) "V")
			; 01/03/07 TM MOD ���ʂ̐��@�����؂肷��
			; (SCFDrawDimLin #pt$ #base (polar #base &ang (GetDimHeight (1+ &iti))) "V")
			(SCFDrawDimLin #pt$ #xDimPt (polar #xDimPt &ang  CG_DimHeight_1Line) "V")
		)
	)
	(princ)
) ; SCF_B_DrawDim_Din


;<HOM>*************************************************************************
; <�֐���>    : GetModelSideDim
; <�����T�v>  : �c���@�̃��f���V���{�����l��
; <�߂�l>    : �i���E���f���I���G���e�B�e�B���X�g ���E�̊�_���W�j
; <�쐬>      : 00/02/17
;*************************************************************************>MOH<
(defun GetModelSideDim (
	&ss$        ; �I���G���e�B�e�B���X�g
	/
	#ss #ss$ #flg #x #i #en #2pt$ #pt$ #list$ #ssret$
	#ssModel	; ���f��No. ���Ƃ̑I���Z�b�g
	#eModel		; �}�`��
	#nII			; ����ϐ�
	)
	;�t���O�ƁA�I���G���e�B�e�B�l��
; 01/08/10 TM MOD(1)-S �I���W�i���̃\�[�X
;	(foreach #ss (car &ss$)
;		(setq #ss$ (cons (list "K" #ss) #ss$))
;  )
;	(foreach #ss (cadr &ss$)
;		(setq #ss$ (cons (list "D" #ss) #ss$))
;	)
; 01/08/10 TM MOD(1)-E �I���W�i���̃\�[�X

; 01/08/10 TM MOD(2)-S �Ƃ肠�����������̂��c���Ă����B
; �������AK �� D �̃��f�����������ɂ���Ɛ��@���d�Ȃ�B
;	(princ "\n�J�n: ")
;	(princ (car &ss$))
;	(if (car &ss$)
;		(progn
;			; �L�b�`��
;			(setq #ssModel (ssadd))
;			(foreach #ss (car &ss$)
;				(setq #nII 0)
;				(repeat (sslength #ss)
;					(setq #ssModel (ssadd (ssname #ss #nII) #ssModel))
;					(setq #nII (1+ #nII))
;				)
;			)
;			(if #ssModel
;				(progn
;					(setq #ss$ (cons (list "K" #ssModel) #ss$))
;					(princ "\n#ss$+: ")
;					(princ #ss$)
;				)
;			)
;		)
;	)
;	(princ "\n�J�n: ")
;	(princ (cadr &ss$))
;	(if (cadr &ss$)
;		(progn
;			; �_�C�j���O
;			(setq #ssModel (ssadd))
;			(foreach #ss (cadr &ss$)
;				(setq #nII 0)
;				(repeat (sslength #ss)
;					(setq #ssModel (ssadd (ssname #ss #nII) #ssModel))
;					(setq #nII (1+ #nII))
;				)
;			)
;			(if #ssModel
;				(progn
;					(setq #ss$ (cons (list "D" #ssModel) #ss$))
;					(princ "\n#ss$*")
;					(princ #ss$)
;				)
;			)
;		)
;	)
; 01/08/10 TM MOD(2)-E �Ƃ肠�����������̂��c���Ă����B

	; 01/08/10 TM MOD-S �S�O�`���܂Ƃ߂Ĉ�̃f�[�^�Ƃ��Ĉ���
	; �L�b�`���̃��f���f�[�^��ǉ�
	(if (car &ss$)
		(progn
			(if (not #ssModel) (setq #ssModel (ssadd)))
			(foreach #ss (car &ss$)
				(setq #nII 0)
				(repeat (sslength #ss)
					(setq #ssModel (ssadd (ssname #ss #nII) #ssModel))
					(setq #nII (1+ #nII))
				)
			)
		)
	)

	; �_�C�j���O�̃��f���f�[�^��ǉ�
	(if (cadr &ss$)
		(progn
			(if (not #ssModel) (setq #ssModel (ssadd)))
			(foreach #ss (cadr &ss$)
				(setq #nII 0)
				(repeat (sslength #ss)
					(setq #ssModel (ssadd (ssname #ss #nII) #ssModel))
					(setq #nII (1+ #nII))
				)
			)
		)
	)

	; �S���f���f�[�^��"K" �Ƃ��ē���
	(if #ssModel
		(progn
			(setq #ss$ (cons (list "K" #ssModel) #ss$))
		)
	)

	; 01/08/10 TM MOD �ȍ~�̊֐��Ńf�[�^�����E���K�v�Ȃ��߁A�����ɔz������
	(if (= 1 (length #ss$))
		(progn
			(setq #ss$$ (append #ss$ #ss$))
		)
		(progn
			(setq #ss$$ #ss$)
		)
	)
	; 01/08/10 TM MOD-S �S�O�`���܂Ƃ߂Ĉ�̃f�[�^�Ƃ��Ĉ���

	;�e���f���̍��W�l��
	(foreach #ss$ #ss$$
		(setq #flg   (car  #ss$))
		(setq #ss    (cadr #ss$))
		;X���W
		(setq #x     (car (car (Get2PointByLay (ssname #ss 0) 1))))
		;���E�̍��W
		(setq #i 0)
		(repeat (sslength #ss)
			(setq #en (ssname #ss #i))
			(setq #2pt$ (Get2PointByLay #en 1))
			(setq #pt$ (cons (car  #2pt$) #pt$))
			(setq #pt$ (cons (cadr #2pt$) #pt$))
			(setq #i (1+ #i))
		)
		(setq #list$ (cons (list #x #flg #ss) #list$))
	)
	(if #list$
		(progn
			;�\�[�g
			(setq #list$ (mapcar 'cdr (SCFmg_sort$ 'car #list$)))

			;�o�͐��@�����肷��
			(if (assoc "K" #list$)
				;�L�b�`��������
				(progn
					(if (= "D" (car (last #list$)))
						;�E�Ƀ_�C�j���O������
						(progn
							(setq #ssret$ (list (cadr (assoc "K" #list$)) (cadr (last #list$))))
						)
						;�E�Ƀ_�C�j���O�͂Ȃ�
						(progn
							(setq #ssret$ (list (cadr (car #list$)) (cadr (assoc "K" (reverse #list$)))))
						)
					)
				)
				;�_�C�j���O�̂�
				(progn
					(setq #ssret$ (list (cadr (car #list$)) (cadr (last #list$))))
				)
			)

			;���E�̊���W�l��
			;(setq #pt$ (SCFmg_sort$ 'car #pt$)) 2000/10/19 HT MOD START
			;(list #ssret$ (list (car #pt$) (last #pt$)))
			; �ł����E �ł���
			(setq #pt$ (SCFCmnXYSortByX #pt$))
		)
	)
	(if #pt$
		(list #ssret$ (list (car (car #pt$)) (car (last #pt$))))
		nil
	)
	;2000/10/19 HT END
) ; GetModelSideDim

;<HOM>*************************************************************************
; <�֐���>    : SCFDrawDimLin
; <�����T�v>  : ���W���X�g�Ɗ�_���W�Ɛ��@�ʒu���W����A�����@����}����
; <�߂�l>    : �����t���O �iT:���� nil:���s�j
; <�쐬>      : 1998-06-26
; <���l>      : �����͏��15000�Ƃ���  01/10/02 HN MOD 10000��15000
;               ���񐡖@
;*************************************************************************>MOH<
(defun SCFDrawDimLin (
	&pt$    ; (LIST) ���@�ʒu���W���X�g
	&bpt    ; (LIST) ��_���W      �inil�̂Ƃ�&pt$�̒l�����̂܂܎g�p�j
	&dpt    ; (LIST) ���@�ʒu���W
	&flg    ; (STR)  ���@�����t���O�i����:"H" ����:"V"�j
	/
	#osmode #pt$ #xy #pt #flg #ang #en #i #subst #no #pt_n
	)
	;--- �����ݒ� ---
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	;----------------
	(mapcar
	 '(lambda ( #elm )
			(if (/= nil #elm)
				(setq #pt$ (cons #elm #pt$))
			)
		)
		&pt$
	)

	;���W�v�Z
	(if (/= nil &bpt)
		(if (equal "H" &flg)
			(setq #pt$ (mapcar '(lambda ( #xy ) (list #xy (cadr &bpt) 0.0)) (mapcar 'car  #pt$)))
			(setq #pt$ (mapcar '(lambda ( #xy ) (list (car  &bpt) #xy 0.0)) (mapcar 'cadr #pt$)))
		)
		(setq #pt$ (mapcar '(lambda ( #pt ) (list (car #pt) (cadr #pt) 0.0)) #pt$))
	)
	(setq #flg T)
	;���Ԃ��Ă�����W���Ȃ�
	(if (= "H" &flg)
		(setq #ang (* 0.0 PI))
		(setq #ang (* 0.5 PI))
	)
	(setq #pt$ (PtSort #pt$ #ang T))
	;���W���\�[�g
	(if (not (< 1 (length #pt$)))
		(setq #flg nil)
	)
	(if (/= nil #flg)
		(progn
			;���@����}����O�̐}�`���l��
			(setq #en (entlast))
			;���@��}
			(command "_.dimlinear" (nth 0 #pt$) (nth 1 #pt$) &flg (list (car &dpt) (cadr &dpt) 0.0))
			(setq #i 2)
			(command "_.dimcontinue")
			(repeat (- (length #pt$) 2)
				(command (nth #i #pt$))
				(setq #i (1+ #i))
			)
			(command "" "")
			;��}�������@�}�`������15000�ɂ�����  01/10/02 HN MOD 10000��15000
			(while (setq #en (entnext #en))
				(setq #subst (entget #en '("*")))
				(mapcar
				 '(lambda ( #no )
						(setq #pt (cdr (assoc #no #subst)))
						(if (/= nil #pt)
							(progn
								;01/10/02 HN MOD 10000��15000
								;@MOD@(setq #pt_n (list (car #pt) (cadr #pt) 10000.0))
								(setq #pt_n (list (car #pt) (cadr #pt) CG_LAYOUT_DIM_Z))
								(setq #subst (subst (cons #no #pt_n) (assoc #no #subst) #subst))
							)
						)
					)
				 ; ���W
				 '(10 11 12 13 14)
				)
				(entmod #subst)
			)
		)
	)
	(setvar "OSMODE" #osmode)

	#flg
) ; SCFDrawDimLin

;<HOM>*************************************************************************
; <�֐���>    : SCFDrawDimAlig
; <�����T�v>  : ���W���X�g�Ɗ�_���W�Ɛ��@�ʒu���W���畽�s���@����}����
; <�߂�l>    : �����t���O �iT:���� nil:���s�j
; <�쐬>      : 00/03/02
; <���l>      : �����͏��15000�Ƃ���  01/10/02 HN MOD 10000��15000
;*************************************************************************>MOH<
(defun SCFDrawDimAlig (
	&pt$    ; (LIST) ���@�ʒu���W���X�g�Q�_
	&dpt    ; (LIST) ���@�ʒu���W
	/
	#osmode #pt$ #p #subst #no #pt #pt_n
	)
	;--- �����ݒ� ---
	(setq #osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	;----------------
	(setq #pt$
		(mapcar
		 '(lambda ( #p )
				(list (car #p) (cadr #p) 0.0)
			)
			&pt$
		)
	)
	;���@��}
	(command "_.dimaligned" (nth 0 #pt$) (nth 1 #pt$) (list (car &dpt) (cadr &dpt) 0.0))
	;��}�������@�}�`������15000�ɂ�����  01/10/02 HN MOD 10000��15000
	(setq #subst (entget (entlast) '("*")))
	(mapcar
	 '(lambda ( #no )
			(setq #pt (cdr (assoc #no #subst)))
			(if (/= nil #pt)
				(progn
 					;01/10/02 HN MOD 10000��15000
 					;@MOD@(setq #pt_n (list (car #pt) (cadr #pt) 10000.0))
 					(setq #pt_n (list (car #pt) (cadr #pt) CG_LAYOUT_DIM_Z))
					(setq #subst (subst (cons #no #pt_n) (assoc #no #subst) #subst))
				)
			)
		)
	 '(10 11 12 13 14)
	)
	(entmod #subst)
	(setvar "OSMODE" #osmode)

	T
) ; SCFDrawDimAlig

;<HOM>*************************************************************************
; <�֐���>    : Get2PointByLay2
; <�����T�v>  : �}�`������A�V���{���ʒu�ƃL���r�l�b�g���ʒu���Z�o
; <�߂�l>    : �Q�_���W���X�g
; <���l>      : �^���� �^���̃A�C�e���ȊO�����e�l�ŕԂ�)
;*************************************************************************>MOH<
(defun Get2PointByLay2 (
	&en         ; �}�`��
	/
	#pt1 #edl$ #eds$ #flg #ang #dis #pt2 #pt$
	)
	(if (and &en (= 'ENAME (type &en)))
		(progn
			(setq #pt1 (cdrassoc 10 (entget &en)))
			(setq #pt1 (list (car #pt1) (cadr #pt1) 0.0))
			(setq #edl$ (CfGetXData &en "G_LSYM"))
			(setq #eds$ (CfGetXData &en "G_SYM"))
			(if (and #edl$ #eds$)
				(progn
					(setq #flg (nth 5 (CfGetXData &en "G_SKDM")))
					(if (= "W" #flg)
						(progn
							(setq #ang (Angle0to360 (nth 2 #edl$)))
							(setq #flg (nth 8 #eds$))
							(setq #dis (nth 3 #eds$))
						)
						(progn
							(setq #ang (Angle0to360 (+ (* PI 1.5) (nth 2 #edl$))))
							(setq #flg (nth 9 #eds$))
							(setq #dis (nth 4 #eds$))
						)
					)
					(if (= -1 #flg)
						(setq #ang (+ PI #ang))
					)
					(if
						(and
							#pt1 #ang #dis
						)
						(progn
			 				(setq #dis (+ #dis (cos #Ang)))
							(setq #pt2 (polar #pt1 #ang #dis))
							(setq #pt$ (list #pt1 #pt2))
						)
					)
				)
			)
		)
	)

	#pt$
) ; Get2PointByLay2

;2011/06/06 YM MOD-S
;;;;<HOM>*************************************************************************
;;;; <�֐���>    : Get2PointByLay
;;;; <�����T�v>  : �}�`������A�V���{���ʒu�ƃL���r�l�b�g���ʒu���Z�o
;;;; <�߂�l>    : �Q�_���W���X�g
;;;;             : XY���ʂɕ��s�Ȃ���(�L�p�x�̎��ǂ����邩)
;;;;*************************************************************************>MOH<
;;;(defun Get2PointByLay (
;;;	&en         ; �}��
;;;	&iHaimen		; ���o�[�V�u��
;;;	/
;;;	#pt1 #edl$ #eds$ #WDflg #flg #ang #dis #pt2 #pt$
;;;	)
;;;	(if (and &en (= 'ENAME (type &en)))
;;;		(progn
;;;			; �V���{����_�擾
;;;			(setq #pt1 (cdrassoc 10 (entget &en)))
;;;			(setq #pt1 (list (car #pt1) (cadr #pt1) 0.0))
;;;			(setq #edl$ (CfGetXData &en "G_LSYM"))
;;;			(setq #eds$ (CfGetXData &en "G_SYM"))
;;;			; �V���{���}�`�����݂���ꍇ
;;;			(if (and #edl$ #eds$)
;;;				(progn
;;;					(setq #WDflg (nth 5 (CfGetXData &en "G_SKDM")))
;;;					(if (= "W" #WDflg)
;;;						; "W" �����̏ꍇ
;;;						(progn
;;;							(setq #ang (Angle0to360 (nth 2 #edl$)))
;;;							(setq #flg (nth 8 #eds$))
;;;							(setq #dis (nth 3 #eds$))
;;;						)
;;;						; "D"�����̏ꍇ
;;;						(progn
;;;							; 2000/09/06 HT MOD �L�p�x�Ή� WIDECAB START
;;;							(if (setq #ang (SCFGetWideCabAng #eds$))
;;;								(progn
;;;								; �L�p�x�̏ꍇ
;;;								(setq #ang (Angle0to360 (+ (- (* PI 2.0) #ang) (nth 2 #edl$))))
;;;								)
;;;								(progn
;;;								; ��� (�R�[�i�[�p�x90�x�̏ꍇ)
;;;								(setq #ang (Angle0to360 (+ (* PI 1.5) (nth 2 #edl$))))
;;;								)
;;;							)
;;;							; 2000/09/06 HT MOD �L�p�x�Ή� WIDECAB END
;;;							(setq #flg (nth 9 #eds$))
;;;							(setq #dis (nth 4 #eds$))
;;;						)
;;;					)
;;;					; �t����
;;;					(if (= -1 #flg)
;;;						(setq #ang (+ PI #ang))
;;;					)
;;;					(if
;;;						(and
;;;							; �_���擾�\
;;;							#pt1 #ang #dis
;;;							(or
;;;								; ���ʌ����܂��͋t�����̏ꍇ
;;;								(equal 0.0 (Angle0to360 #ang) 0.1)
;;;								(equal (* 2.0 PI) (Angle0to360 #ang) 0.1)
;;;								(if (or (= "D" #WDflg) (= &iHaimen 1) (= CG_DRSeriCodeRV nil))
;;;									(equal PI (Angle0to360 #ang) 0.1)
;;;									nil
;;;								)
;;;							)
;;;						)
;;;						(progn
;;;							(setq #pt2 (polar #pt1 #ang #dis))
;;;							(setq #pt$ (list #pt1 #pt2))
;;;						)
;;;						(progn
;;;							; 01/05/29 �E/F �̏ꍇ
;;;							(setq #ang (+ (* 0.5 PI) #ang))
;;;						 	(setq #pt2 (polar #pt1 #ang #dis))
;;;							(if (= "W" #WDflg)
;;;								(progn
;;;									(setq #pt$ (list #pt2 #pt1))
;;;								)
;;;								(progn
;;;									(setq #pt$ (list #pt1 #pt2))
;;;								)
;;;							)
;;;						)
;;;					)
;;;				)
;;;			)
;;;		)
;;;	)
;;;
;;;	#pt$
;;;) ; Get2PointByLay

;<HOM>*************************************************************************
; <�֐���>    : Get2PointByLay
; <�����T�v>  : �}�`������A�V���{���ʒu�ƃL���r�l�b�g���ʒu���Z�o
; <�߂�l>    : �Q�_���W���X�g
;             : XY���ʂɕ��s�Ȃ���(�L�p�x�̎��ǂ����邩)
;               TS����֐����R�s�[
;*************************************************************************>MOH<
(defun Get2PointByLay (
  &en         ; �}��
  &iHaimen    ; ���o�[�V�u��
  /
  #pt1 #edl$ #eds$ #WDflg #flg #ang #dis #pt2 #pt$ #skDm$ #syomen
  )
  (if (and &en (= 'ENAME (type &en)))
    (progn
      ; �V���{����_�擾
      (setq #pt1 (cdrassoc 10 (entget &en)))
      (setq #pt1 (list (car #pt1) (cadr #pt1) 0.0))
      (setq #edl$ (CfGetXData &en "G_LSYM"))
      (setq #eds$ (CfGetXData &en "G_SYM"))

      ; �V���{���}�`�����݂���ꍇ
      (if (and #edl$ #eds$)
        (progn
          (setq #skDm$ (CfGetXData &en "G_SKDM"))
          (setq #WDflg (nth 5 #skDm$))
          (setq #syomen (nth 3 #skDm$))

          (if (or (= "W" #WDflg) (= #syomen -1))
          ;(if (= "W" #WDflg)
            ; "W" �����̏ꍇ
            (progn
              (setq #ang (Angle0to360 (nth 2 #edl$)))
              (setq #flg (nth 8 #eds$))
              (setq #dis (nth 3 #eds$))
            )
            ; "D"�����̏ꍇ
            (progn
              ; ���
              (setq #ang (Angle0to360 (+ (* PI 1.5) (nth 2 #edl$))))

              (setq #flg (nth 9 #eds$))
              (setq #dis (nth 4 #eds$))
            )
          )
          ; �t����
          (if (= -1 #flg)
            (setq #ang (+ PI #ang))
          )
          (if
            (and
              ; �_���擾�\
              #pt1 #ang #dis
              (or
                ; ���ʌ����܂��͋t�����̏ꍇ
                (equal 0.0 (Angle0to360 #ang) 0.1)
                (equal PI (Angle0to360 #ang) 0.1)
                (equal (* 2.0 PI) (Angle0to360 #ang) 0.1)
                (if (or (= "D" #WDflg) (= &iHaimen 1))
                  (equal PI (Angle0to360 #ang) 0.1)
                  nil
                )
              )
            )
            (progn
              (setq #dis (fix (+ #dis 0.001)))
              (setq #pt2 (polar #pt1 #ang #dis))
              (setq #pt$ (list #pt1 #pt2))
            )
            (progn
              ; 01/05/29 �E/F �̏ꍇ
              ; 04/12/11 ANG�ݒ�̈Ӗ��s���̂��ߏ���
              (setq #ang (+ (* 0.5 PI) #ang))
              (setq #pt2 (polar #pt1 #ang #dis))
              (if (= "W" #WDflg)
                (setq #pt$ (list #pt2 #pt1))
              ;else
                (setq #pt$ (list #pt1 #pt2))
              )
            )
          )
        )
      )
    )
  )

  #pt$
) ; Get2PointByLay
;2011/06/06 YM MOD-E

;<HOM>*************************************************************************
; <�֐���>    : GetZPointByLay
; <�����T�v>  : �}�`������A�V���{���ʒu�ƃL���r�l�b�g���s���W���Z�o
; <�߂�l>    : 2��Z���W�l
;             : XY���ʂɕ��s�Ȃ���(�L�p�x�̎��ǂ����邩)
;*************************************************************************>MOH<
(defun GetZPointByLay (
	&en         ; �}��
	&iHaimen    ; ���o�[�V�u��
	/
	#pt1 #edl$ #eds$ #WDflg #flg #ang #dis #pt2 #pt$ #skDm$ #syomen
	)
	(if (and &en (= 'ENAME (type &en)))
		(progn
			; �V���{����_�擾
			(setq #pt1 (cdrassoc 10 (entget &en)))
			(setq #pt1 (list (nth 0 #pt1) (nth 2 #pt1) (nth 1 #pt1)))
			(setq #edl$ (CfGetXData &en "G_LSYM"))
			(setq #eds$ (CfGetXData &en "G_SYM"))

			; �V���{���}�`�����݂���ꍇ
			(if (and #edl$ #eds$)
				(progn
					(setq #skDm$ (CfGetXData &en "G_SKDM"))
					(setq #WDflg (nth 5 #skDm$))
					(setq #syomen (nth 3 #skDm$))

					(if (or (= "W" #WDflg) (= #syomen -1))
						; "W" �����̏ꍇ
						(progn
							(setq #angx (Angle0to360 (nth 2 #edl$)))
							(setq #flgx (nth 8 #eds$))
							(setq #disx (nth 3 #eds$))
							(setq #angy (Angle0to360 (+ #angx (* 0.5 PI))))
							(setq #flgy (nth 9 #eds$))
							(setq #disy (nth 4 #eds$))
						)
						; "D"�����̏ꍇ
						(progn
							; ���
							(setq #angx (Angle0to360 (+ (* PI 1.5) (nth 2 #edl$))))
							(setq #flgx (nth 9 #eds$))
							(setq #disx (nth 4 #eds$))
							(setq #angy (Angle0to360 (- #angx (* PI 0.5))))
							(setq #flgy (nth 8 #eds$))
							(setq #disy (nth 3 #eds$))
						)
					)
					; �t����
					(if (= -1 #flgx)
						(setq #angx (+ PI #angx))
					)
					(if (= -1 #flgy)
						(setq #angy (+ PI #angy))
					)
					(if
						(and
							; �_���擾�\
							#pt1 #angx #disx
							(or
								; ���ʌ����܂��͋t�����̏ꍇ
								(equal 0.0 (Angle0to360 #angx) 0.1)
								(equal PI (Angle0to360 #angx) 0.1)
								(equal (* 2.0 PI) (Angle0to360 #angx) 0.1)
								(if (or (= "D" #WDflg) (= &iHaimen 1))
									(equal PI (Angle0to360 #angx) 0.1)
									nil
								)
							)
						)
						(progn
							(setq #disx (fix (+ #disx 0.001)))
							(setq #disy (fix (+ #disy 0.001)))
							(setq #pt2 (polar #pt1 #angx #disx))
							(setq #pt2 (polar #pt2 #angy #disy))
						)
						(progn
							; 01/05/29 �E/F �̏ꍇ
							; 04/12/11 ANG�ݒ�̈Ӗ��s���̂��ߏ���
							(setq #angx (+ (* 0.5 PI) #angx))
							(setq #angy (+ (* 0.5 PI) #angy))
							(setq #pt2 (polar #pt1 #angx #disx))
							(setq #pt2 (polar #pt2 #angy #disy))
						)
					)
				)
			)
		)
	)

	(list (nth 1 #pt1) (nth 1 #pt2))
) ; GetZPointByLay

;<HOM>*************************************************************************
; <�֐���>    : GetRangeUpBas
; <�����T�v>  : �x�[�X�ƃA�b�p�[�̗̈���l���i�����_ �E��_�j
; <�߂�l>    : �i�x�[�X �A�b�p�[�j
; <�쐬>      : 00/02/17
;*************************************************************************>MOH<
(defun GetRangeUpBas (
	&ss$        ; �I���Z�b�g���X�g
	/
	#ss$ #ss #i #en #code$ #bas$ #upp$ #2pt$ #bpt$ #ed$ #ang #upt #upt$
	#tss$
#hin #INSPT #XD_LSYM$ #DUM_PT #dum_pt1 #dum_pt2 ;2011/06/04 YM ADD
	)
	;�A�b�p�[�ƃx�[�X�̐}�`�����X�g�l��
	(if (= 'PICKSET (type &ss$))
		(setq #ss$ (list &ss$))
		(progn
			(foreach #ss &ss$
				(if #ss
					(setq #ss$ (append #ss$ #ss))
				)
			)
		)
	)

	(foreach #ss  #ss$
		(setq #i 0)
		(repeat (sslength #ss)
			(setq #en (ssname #ss #i))
			(setq #code$ (CFGetSymSKKCode #en nil))
			(if (or (= CG_SKK_ONE_CAB (nth 0 #code$))(= CG_SKK_ONE_RNG (nth 0 #code$)))
				(cond
					((= CG_SKK_TWO_BAS (nth 1 #code$))  ; �x�[�X
						(setq #bas$ (cons #en #bas$))
					)
					((= CG_SKK_TWO_UPP (nth 1 #code$))  ; �A�b�p�[
						(setq #upp$ (cons #en #upp$))
					)
					; 01/08/07 TM ADD �x�[�X�ł��A�b�p�[�ł��Ȃ����W���x�[�X�ɏ���������
					; (�b��Ή�: ���t���V���@�̈ʒu���x�[�X�L���r�l�b�g�̈ʒu�ɍ��킹��)
					(t (setq #bas$ (cons #en #bas$)))
				)
			)
			(setq #i (1+ #i))
		)
	)

	; 01/07/08 HN S-ADD �L���r�l�b�g�ƃ����W�t�[�h�������ꍇ�A���̑����ނ�Ώ�
	(if (and (= nil #bas$) (= nil #upp$))
		(foreach #ss #ss$
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #bas$ (cons #en #bas$))
				(setq #upp$ (cons #en #upp$))
				(setq #i (1+ #i))
			)
		)
	)
	; 01/07/08 HN E-ADD �L���r�l�b�g�ƃ����W�t�[�h�������ꍇ�A���̑����ނ�Ώ�

	;���W�l��
	; �x�[�X
	(foreach #en #bas$

		;2011/06/04 YM ADD-S
		(setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
		(setq #hin (nth 5 #xd_LSYM$));�g��Ȃ����m�F�p
		(setq #insPT (nth 1 #xd_LSYM$));�g��Ȃ����m�F�p
		;2011/06/04 YM ADD-E

		;(setq #2pt$ (Get2PointByLay #en))
		(setq #2pt$ (Get2PointByLay #en 1))
		(if (/= nil #2pt$)
			(progn
				(setq #code$ (CFGetSymSKKCode #en nil))
				; 06/09/21 T.Ari Mod ��֕������Ă���x�[�X�L���r���l��
				(if (and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_TWO_BAS (nth 1 #code$)))
					(progn
						;2011/06/04 YM MOD-S
;;;						(setq #bpt$ (cons (polar (car  #2pt$) (* PI 1.5) (nth 2 (nth 1 (CFGetXData #en "G_LSYM")))) #bpt$))
;;;						(setq #bpt$ (cons (polar (cadr #2pt$) (* PI 1.5) (nth 2 (nth 1 (CFGetXData #en "G_LSYM")))) #bpt$))
						(setq #dum_pt (nth 1 #xd_LSYM$))
						(setq #dum_pt1 (polar (car  #2pt$) (* PI 1.5) (nth 2 #dum_pt)))
						(setq #bpt$ (cons #dum_pt1 #bpt$))
						(setq #dum_pt2 (polar (cadr #2pt$) (* PI 1.5) (nth 2 #dum_pt)))
						(setq #bpt$ (cons #dum_pt2 #bpt$))
						;2011/06/04 YM MOD-E
					)
					(progn
						(setq #bpt$ (cons (car  #2pt$) #bpt$))
						(setq #bpt$ (cons (cadr #2pt$) #bpt$))
					)
				)
				(setq #ed$  (CfGetXData #en "G_SYM"))
				(if (= 1 (nth 10 #ed$))
					(setq #ang (* PI 0.5))
					(setq #ang (* PI 1.5))
				)
				(setq #upt (polar (car #2pt$) #ang (nth 5 #ed$)))
				(setq #bpt$ (cons #upt #bpt$))
			)
		)
	)

	; �A�b�p�[
	(foreach #en #upp$
		;(setq #2pt$ (Get2PointByLay #en))
		(setq #2pt$ (Get2PointByLay #en 1))
		(if (/= nil #2pt$)
			(progn
				(setq #upt$ (cons (car  #2pt$) #upt$))
				(setq #upt$ (cons (cadr #2pt$) #upt$))
				(setq #ed$  (CfGetXData #en "G_SYM"))
				(if (= 1 (nth 10 #ed$))
					(setq #ang (* PI 0.5))
					(setq #ang (* PI 1.5))
				)
				(setq #upt (polar (car #2pt$) #ang (nth 5 #ed$)))
				(setq #upt$ (cons #upt #upt$))
			)
		)
	)

	;�ő�ƍŏ��̍��W���l��
	(if (/= nil #bpt$)
		(setq #bpt$ (GetPtMinMax #bpt$))
	)
	(if (/= nil #upt$)
		(setq #upt$ (GetPtMinMax #upt$))
	)

	(list #bpt$ #upt$)

) ; GetRangeUpBas

;<HOM>************************************************************************
; <�֐���>  : DrawPtenDim
; <�����T�v>: �{�H���@�Ǝ{�H�������@����}
; <�߂�l>  : �ʒu���W
; <�쐬>    : 00/02/17
; <���l>    : 00/05/09 HN MOD �{�H���@�Ɏ{�H���ǉ��\��
;************************************************************************>MOH<
(defun DrawPtenDim (
	&pten$      ; P�_�}�`
	&ryo$       ; �x�[�X�ƃA�b�p�[�̗̈���W���X�g �����ꂩ�̍��W�͗L���ł��邱��
	&layer      ; ��w
	&sekou      ; �{�H���@�o�͕����t���O
	&doubu      ; �{�H�����o�͕����t���O
	/
	#doubu$     ; �{�H�������@�_���X�g
	#sekou$			; �{�H���@�_���X�g
	#bpt$
	#iti$
	#dReg$	; �x�[�X�ƃA�b�p�[�̗̈���W���X�g
	)

;@@@(princ "\nDrawPtenDim  ��w: ")(princ &layer);00/05/18
	(setq #doubu$  (nth 1 &pten$))
	(setq #sekou$  (nth 2 &pten$))

	(if (not #iti$) (setq #iti$ (list 0 0 0 0)))
	; 01/05/17 TM ADD ������\�����邽�߂Ƀ_�~�[�̗̈���W��ǉ�
	(setq #dReg$ (KCFGetDummyRange &ryo$))
	(if (/= nil #sekou$)
		(progn
			(setq #bpt$ (GetBasePtBySekou #dReg$ &sekou &layer))
			(setq #iti$ (SCFDrawDimSekou #sekou$ (cadr #dReg$) (car #dReg$) CG_DimOffLen #bpt$))
		)
	)
	(if (/= nil (car #doubu$))
		(progn
			;(setq #iti$ (SCFDrawDimDoubuti #doubu$ &ryo$ #iti$ &doubu))
			; �{�H�������@ UP/BAS�̈�̗��[�̋߂������ɍ�}����
			; (I�^2�񑤖ʂ̏ꍇ�ȂǂɕБ��ɐ��@������Ă��܂��s��C��)

;			(setq #iti$ (SCFDrawDimDoubuti2 #doubu$ #dReg$ #iti$ &doubu))
			(setq #iti$ (SCFDrawDimDoubuti3 #doubu$ #dReg$ #iti$ &doubu))
		)
	)
	#iti$
) ; DrawPtenDim

;<HOM>*************************************************************************
; <�֐���>    : KCFGetDummyRange
; <�����T�v>  : �x�[�X�E�A�b�p�[�̈悪�Ȃ��ꍇ�Ƀ_�~�[���쐬����
; <�߂�l>    : �i�x�[�X �A�b�p�[�j
; <�쐬>      : 01.05.17 TM
; <���l>      : ���������̐��@(�V�䍂���|����)�쐬�p
;             : �ǂ���̍��W���Ȃ��ꍇ�� nil
;*************************************************************************>MOH<
(defun KCFGetDummyRange (
	&dReg$		; �̈惊�X�g
	/
	#dReg$		; �̈惊�X�g
	#dBs$			; �x�[�X���W
	#dUp$			; �A�b�p�[���W
	#dDum1		; �_�~�[���W
	#dDum2		; �_�~�[���W
	)
	(if (cadr &dReg$)
		(progn
			(if (not (car &dReg$))
				; �x�[�X���W���Ȃ��ꍇ�A�A�b�p�[���W����쐬����
				(progn
					(setq #dDum1 (car (cadr &dReg$)))
					(setq #dDum1 (list (car #dDum1) (+ 831 (- (cadr #dDum1) CG_CeilHeight))))
					(setq #dDum2 (cadr (cadr &dReg$)))
					(setq #dDum2 (list (car #dDum2) (+ 831 (- (cadr #dDum2) CG_CeilHeight))))
					(setq #dBs$ (list #dDum1 #dDum2))
					(setq #dReg$ (list #dBs$ (cadr &dReg$)))
				)
				; ��������ꍇ�͂��̂܂ܕԂ�
				(progn
					(setq #dReg$ &dReg$)
				)
			)
		)
		(progn
			; �A�b�p�[���W���Ȃ��ꍇ�A�x�[�X���W����쐬����
			(if (car &dReg$)
				(progn
					(setq #dDum1 (car (car &dReg$)))
					(setq #dDum1 (list (car #dDum1) (+ 831 (- CG_CeilHeight (cadr #dDum1)))))
					(setq #dDum2 (cadr (car &dReg$)))
					(setq #dDum2 (list (car #dDum2) (+ 831 (- CG_CeilHeight (cadr #dDum2)))))
					(setq #dUp$ (list #dDum1 #dDum2))
					(setq #dReg$ (list (car &dReg$) #dUp$))
				)
				(princ "\n�̈悪��?:KCFGetDummyRange")
			)
		)
	)
	#dReg$

);_defun KCFGetDummyRange

;<HOM>*************************************************************************
; <�֐���>    : GetRangePlane
; <�����T�v>  : ���ʐ}�̗̈���l��
; <�߂�l>    : �i�����_ �E��_�j
; <�쐬>      : 00/02/17
;*************************************************************************>MOH<
(defun GetRangePlane (
	&ss$        ; �I���Z�b�g���X�g
	/
	#ss$ #ss #i #en #code$ #spt$ #pt$
	)
	;�A�b�p�[�ƃx�[�X�̐}�`�����X�g�l��
	(setq #ss$ (apply 'append &ss$))
	(mapcar
	 '(lambda ( #ss )
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #code$ (CFGetSymSKKCode #en nil))
				(if (or (= CG_SKK_ONE_CAB (nth 0 #code$))(= CG_SKK_ONE_RNG (nth 0 #code$)))
					(progn
						(setq #spt$ (GetSym4Pt #en))
						(setq #pt$ (append #pt$ (list (nth 0 #spt$)(nth 1 #spt$)(nth 2 #spt$))))
					)
				)
				(setq #i (1+ #i))
			)
		)
		#ss$
	)
	(if (not #pt$)
		(mapcar
		 '(lambda ( #ss )
				(setq #i 0)
				(repeat (sslength #ss)
					(setq #en (ssname #ss #i))
					(setq #spt$ (GetSym4Pt #en))
					(setq #pt$ (append #pt$ (list (nth 0 #spt$)(nth 1 #spt$)(nth 2 #spt$))))
					(setq #i (1+ #i))
				)
			)
			#ss$
		)
	)

	;�ő�ƍŏ��̍��W���l��
	(GetPtMinMax #pt$)
) ; GetRangePlane

;<HOM>*************************************************************************
; <�֐���>    : IsRegion2Retsu
; <�����T�v>  : �̈�͂Q��^�̗̈悩�H
; <�߂�l>    : T or nil
; <�쐬>      : 01/04/17 TM
; <���l>      : �̈�̐^�񒆂ɐ}�`�����݂��邩�Ŕ���
;*************************************************************************>MOH<
(defun IsRegion2Retsu (
	&dRegion$	; �̈���W (((�A�b�p�[�P) (�A�b�p�[�Q)) ((�x�[�X�P) (�x�[�X�Q)))
	/
	#dUp
	#dBs
	#sMid
	)
	;DEBUG (princ "\n���̓_")
	;DEBUG (princ &dRegion$)
	(if (car &dRegion$)
		(setq #dUp (GetCenterPT (car (car &dRegion$)) (cadr (car &dRegion$))))
	)
	(if (cadr &dRegion$)
		(setq #dBs (GetCenterPT (car (cadr &dRegion$)) (cadr (cadr &dRegion$))))
	)
	;DEBUG (princ "\n���_")
	;DEBUG (princ #dUp)
	;DEBUG (princ #dBs)

	(if (not #dUp) (setq #dUp #dBs))
	(if (not #dBs) (setq #dBs #dUp))

	(setq #sMid (ssget "_C" #dUp #dBs))

	(if #sMid
		(progn
			T
		)
		(progn
			nil
		)
	)
)

;<HOM>*************************************************************************
; <�֐���>    : GetBasePtBySekou
; <�����T�v>  : �{�H���@�̊�_���擾
; <�߂�l>    : �i�A�b�p�[ �x�[�X�j
; <�쐬>      : 00/02/24
; <���l>      : L�^�EW�^           �F�R�[�i�[�L���r��_
;               I�^                �F�R�����L���r��
;               I�^�ŃR�������Ȃ����F���E�߂��ق�
;*************************************************************************>MOH<
(defun GetBasePtBySekou (
	&ryo$       ; �x�[�X�ƃA�b�p�[�̗̈���W���X�g
	&flg        ; �o�͕����t���O�iI�^�̎��̂ݗL���j
	&layer      ; ��w
	/
	#ssD #i #en #10 #ed$ #pt0 #flg #pt1 #code$ #gas #ret$ #bpt #half #ptj
	#WEn$  ; (WTEn WTEn �E�E�E)
	#WEn   ; WTEn��ɂȂ�WT
	#ssDum	; �_�~�[�I���Z�b�g
	#nII		; ����ϐ�
	#DPt$		; �V���N�̊�_��(���[)
	#pt0Tmp
	#pt1Tmp
	)
;@@@(princ "\n\nGetBasePtBySekou()"  ) ;DebugHN
;@@@(princ "\n&ryo$: " )(princ &ryo$ ) ;DebugHN
;@@@(princ "\n&flg: "  )(princ &flg  ) ;DebugHN
;@@@(princ "\n&layer: ")(princ &layer) ;DebugHN

	; <�����T�v>  : �K�X���̓V���N�L���r�̍��W���擾
	; <�쐬>      :
	; <�߂�l>    : ���W
	; <���l>			:
	(defun ##GasSinkCab10 (
		/
		#i     ; �J�E���^
		#xSs   ; "G_SKDM"�̑I���Z�b�g
		#eEn   ; "G_SKDM"�}�`��
		#Ed$   ; XData
		#10    ; ���W
		#code$ ; ���iCODE
		#bGetGas
	)

		(setq #bGetGas nil)
		(setq #10 nil)
		(setq #xSs (ssget "X" (list (list -3 (list "G_SKDM")))))
		(if (/= nil #xSs)
			(progn
				(setq #i 0)
				(repeat (sslength #xSs)
					(setq #eEn  (ssname #xSs #i))
					(if (= (nth 1 (CfGetXData #eEn "G_SKDM")) "K")
						(progn
							(setq #code$ (CFGetSymSKKCode #eEn nil))
							(if (and (= CG_SKK_ONE_CAB (nth 0 #code$))
											 (= CG_SKK_TWO_BAS (nth 1 #code$))
											 (= CG_SKK_THR_GAS (nth 2 #code$)))
								(progn ;2011/04/08 YM ADD (progn��ǉ�
									(setq #10  (cdrassoc 10 (entget #eEn)))
									(setq #bGetGas T)
								) ;2011/04/08 YM ADD (progn��ǉ�
							)
							(if (and (= #bGetGas nil)
											 (= CG_SKK_ONE_CAB (nth 0 #code$))
											 (= CG_SKK_TWO_BAS (nth 1 #code$))
											 (= CG_SKK_THR_SNK (nth 2 #code$)))
								(setq #10  (cdrassoc 10 (entget #eEn)))
							)
						)
					)
					(setq #i (1+ #i))
				)
			)
		)
		#10
	)
	; 00/10/31 HT START
	; <�����T�v>  : �o�b�N�K�[�h�p�̊���W�����߂�
	; <�쐬>      :
	; <�߂�l>    : ����W
	; <���l>			: 01/03/06 TM �S�ʓI�ɉ���
	(defun ##BKGDBasePt (
		&xReg$		; �̈�}�`���X�g ((�x�[�X) (�A�b�p))
		&xDumPt$	; �_�~�[�}�`
		/
		#ptGasSink
		#xB0			; �x�[�X�̈�̒[�_
		#xB1			; �x�[�X�̈�̒[�_
		#xBasePt	; ����W
		#dist1
		#dist2
		#taimen
		#xDumPtTmp$
		#ptGasSinkTmp
		#DIST3 ;2011/04/08 YM ADD
		)
		(WebOutLog (strcat "��##BKGDBasePt��  " &layer ))

		(setq #ptGasSink (##GasSinkCab10))
		(setq #xB0 (car  (car &xReg$)))
		(setq #xB1 (cadr (car &xReg$)))

		(WebOutLog "#ptGasSink= ")
		(WebOutLog #ptGasSink)
		(WebOutLog "#xB0= ")
		(WebOutLog #xB0)
		(WebOutLog "#xB1= ")
		(WebOutLog #xB1)

		; �x�[�X�̗̈���W���r���āA�o�b�N�K�[�h���ɋ߂����̗̈�̒[����_�Ƃ���
		; �_�~�[�}�`�O�ƂQ�͑Ίp����ɂ���͂�
		; T.Arimoto Mod �Ζʎ��̓L���r��_(�K�X���̓V���N)���g�p����悤�ɏC��
		; T.Arimoto Mod 2008/11/04 �Ζʔ��f���@���C��
		; ���[�N�g�b�v���ʂ̒��S����2/3�̋����͈͂Ƀx�[�X�L���r��_������ΑΖʂƔ��f
		(setq #xDumPtTmp$ (list (list (car (car &xDumPt$)) 0.0) (list (car (caddr &xDumPt$)) 0.0)))
		(setq #dist1 (distance (car #xDumPtTmp$) (list (car #xB0) 0.0)))
		(setq #dist2 (distance (cadr #xDumPtTmp$) (list (car #xB0) 0.0)))
		(setq #taimen nil)

		(WebOutLog "���@#xDumPtTmp$= ")
		(WebOutLog #xDumPtTmp$)
		(WebOutLog "���@#dist1= ")
		(WebOutLog #dist1)
		(WebOutLog "���@#dist2= ")
		(WebOutLog #dist2)
		(WebOutLog "���@#taimen= ")
		(WebOutLog #taimen)


		(if #ptGasSink
			(progn
				(WebOutLog (strcat "��##BKGDBasePt�� #ptGasSink ���� " &layer ))
				(setq #ptGasSinkTmp (list (car #ptGasSink) 0.0))
				(setq #dist3 (distance #ptGasSinkTmp (list (* (+ (caar #xDumPtTmp$) (caadr #xDumPtTmp$)) 0.5) 0.0)))
;				(setq #taimen (and (< #dist3 (* 2 (distance (car #xDumPtTmp$) #ptGasSinkTmp)))
;													 (< #dist3 (* 2 (distance (cadr #xDumPtTmp$) #ptGasSinkTmp)))))
				(setq #taimen T)

				(WebOutLog "���@#ptGasSinkTmp= ")
				(WebOutLog #ptGasSinkTmp)
				(WebOutLog "���@#dist3= ")
				(WebOutLog #dist3)
				(WebOutLog "���@#taimen= ")
				(WebOutLog #taimen)

			)
			(progn
				nil
				(WebOutLog (strcat "��##BKGDBasePt�� #ptGasSink �Ȃ� " &layer ))
			)
		)
		(cond
			(#taimen
				(setq #xBasePt (list (car #ptGasSink) (cadr #xB0) 0.0))
			 	(WebOutLog (strcat "��##BKGDBasePt�� cond�� #taimen " &layer ))
			)
			((< #dist1 #dist2)
				(setq #xBasePt  #xB0)
			 	(WebOutLog (strcat "��##BKGDBasePt�� cond�� (< #dist1 #dist2) " &layer ))
			)
			(T
				(setq #xBasePt (list (car #xB1) (cadr #xB0) 0.0))
			 	(WebOutLog (strcat "��##BKGDBasePt�� cond�� T " &layer ))
			)
		)
;|
		(if (< (distance (car &xDumPt$) #xB0) (distance (caddr &xDumPt$) #xB0))
			(progn
				(setq #xBasePt  #xB0)
			)
			(progn
				(setq #xBasePt (list (car #xB1) (cadr #xB0) 0.0))
			)
		)
|;

		(WebOutLog "���@#xBasePt= ")
		(WebOutLog #xBasePt)
		(WebOutLog "�����������@(defun ##BKGDBasePt �I���I�I�I")
		(WebOutLog "�@")

		#xBasePt

	) ;_defun
	; 00/10/31 HT END

	; �����Ƃ邽�߂ɍ��W�n��ύX
	(command "UCS" "W")

	; �V���N�����H����̃��[�N�g�b�v���擾
	(setq #WEn$ (SCFGetWkTopXData))
	(if (> (length #WEn$) 0)
		(progn
			(setq #WPt$ (SCFGetDummyWPtSort))
			; ���W�n��߂�
			(command "UCS" "G" "F")
			(command "-VIEW" "O" "F")

			; �擾�������[�N�g�b�v����A�V���N�������̂�����
			(foreach #Pt$ #WPt$
				(setq #xSs (ssget "_C" (car (3dto2d (list (trans (nth 0 #Pt$) 0 1))))
				(car (3dto2d (list (trans (nth 2 #Pt$) 0 1))))))
				; 00/11/01 HT ADD
				(setq #i 0)
				(repeat (length #WEn$)
					(if (ssmemb (nth #i #WEn$) #xSs)
						(progn
							; ��_(���[)
							(setq #DPt$ #Pt$)
							; �}�`
							(setq #WEn (nth #i #WEn$))
						)
					)
					(setq #i (1+ #i))
				)
				; 00/11/01 HT ADD
			)

			(command "UCS" "P")
			(command "-VIEW" "O" "T")

			; �V���N������ꍇ
			(if #WEn
				(progn

				; 01/07/05 TM MOD �Ƃ肠���������Ȃ��悤�ɕύX �b��
				; ��_
				(setq	#pt0 (nth 0 #DPt$)
							#pt1 (nth 1 #DPt$))

					(setq #Ed$ (CfGetXData #WEn "G_WRKT"))
					(if (= (nth 3 #Ed$) 1)
						; L�^   ->  �R�[�i�[��_
						(progn
							(setq #ret$ (list (polar #pt0 (* 0.5 PI) CG_CeilHeight) #pt0))
						)
					)
				)
			)
		)
	)

	(if (and #WEn (equal (car #pt0) (car #pt1) 0.01) (equal (cadr #pt0) (cadr #pt1) 0.01))
		; ���ʐ}  ; 01/03/06 TM ADD
		(progn
			; 01/04/17 TM MOD �Q��^���ʐ}�ȊO�̏ꍇ�̓o�b�N�K�[�h���Ɋ�_��ݒ肷��
			; �Q��^�͋߂��� (== �����̃L���r�l�b�g���̊�_) ���玩����}�����邽�ߎw�肵�Ȃ�
			(if (IsRegion2Retsu &ryo$)
				(progn
					(setq #bpt (##BKGDBasePt &ryo$ #DPt$))
					(setq #ret$ (list (polar #bpt (* 0.5 PI) CG_CeilHeight) #bpt))
				)
			)
		)
		; ���ʐ}�ȊO
		(progn
			; 02/07/11 YM ADD-S
			(if (and (equal (KPGetSinaType) 2 0.1) ; ���i����=2
							 (or (= CG_sType "SB")(= CG_sType "SD"))) ; �W�JB,D�}
				(setq &flg "A")
			);_if
			; 02/07/11 YM ADD-E

			; 01/04/12 TM MOD �V���N���Ȃ��ꍇ����_�����肷�鏈���𑱍s����H
			; �����܂ł̏����Ŋ�_�����肵�Ă��Ȃ��ꍇ
			; == L �^�ȊO�E���ʈȊO�E�V���N���Ȃ� ��
			(if (not #ret$)
				(progn
					; �_�C�A���O�Ŏw�肵����_�����ɏ]���Đݒ肷��
					(cond
						; �������w��
						((= "L" &flg) (setq #bpt  (car (car &ryo$))))

						; �E�����w��
						((= "R" &flg) (setq #bpt  (list (car (cadr (car &ryo$))) (cadr (car (car &ryo$))) 0.0)))

						; �����w��
						((= "A" &flg)
							; �K�X�L���r�l�b�g������ꍇ�̓K�X�L���r�l�b�g���������
							(setq #gas (SCFGetGasCab10))
							; 06/09/27 T.Ari Mod-S ���[�N�g�b�v���Ȃ��R�����L���r������v�����Ή�
							(if (/= nil #gas)
								(progn
									; 01/06/20 TM MOD-S ���_��荶�E�����߂��ق��ɕύX
									;(setq #half (* 0.5 (distance #pt0 #pt1)))
									; #ptj ... X���W����������
									;(if (equal 0.0 (angle #pt0 #pt1) 0.01)
									;	(setq #ptj #pt0)
									;	(setq #ptj #pt1)
									;)
									;if (< (distance #ptj #gas) #half)
									; 01/07/05 TM �Ƃ肠���������Ȃ��悤�ɂ�b�� �b��
									(if #pt0
										(if (and (< (* 0.5 PI) (angle #pt0 #pt1)) (> (* 1.5 PI) (angle #pt0 #pt1)))
											(progn (setq #pt0tmp #pt1) (setq #pt1tmp #pt0))
											(progn (setq #pt0tmp #pt0) (setq #pt1tmp #pt1))
										)
									)
									(if #WEn
										(if (and #pt0 (< (distance #pt0tmp #gas) (distance #pt1tmp #gas)))
										; 01/06/20 TM MOD-E ���_��荶�E���K�X�L���r�l�b�g�����߂��ق��ɕύX
											(setq #bpt (car (car &ryo$)))   																				;X���W��������
											(setq #bpt (list (car (cadr (car &ryo$)))(cadr (car (car &ryo$))) 0.0)) ;X���W�傫����
										)
										(if (< (abs (- (nth 0 (car (car &ryo$))) (nth 0 #gas))) (abs (- (nth 0 (cadr (car &ryo$))) (nth 0 #gas))))
											(setq #bpt (car (car &ryo$)))   																				;X���W��������
											(setq #bpt (list (car (cadr (car &ryo$)))(cadr (car (car &ryo$))) 0.0)) ;X���W�傫����
										)
									)
								)
							; 06/09/27 T.Ari Mod-E ���[�N�g�b�v���Ȃ��R�����L���r������v�����Ή�
								; �K�X�L���r�l�b�g�Ȃ��A�V���N�Ȃ��̏ꍇ�͏���ݒ�̋t�����ɂ���
								(progn
									; 01/06/22 TM ADD-S ���ʐ}�̏ꍇ�̊�_�����̓_�~�[�}�`�̊�_������
									(if (not (KCFIsShomen))
										; ���ʂ̏ꍇ�́A�o�b�N�K�[�h��(==��_���Ɖ���)�𐡖@��_�Ƃ���
										(progn
											; 01/07/18 MOD HN �ŏ��x���W�����_����_�Ƃ���
											;@MOD@(setq #bpt (car (KCFGetDummyBasePts)))
											(setq #bpt (KCFGetDummyBasePts))
										)
									; 01/06/22 TM ADD-E ���ʐ}�̏ꍇ�̊�_�����̓_�~�[�}�`�̊�_������
										; ���ʂ̏ꍇ�͋߂�������
										(progn
											; �E����
											(if (wcmatch CG_KitType "*-RIGHT")
												(progn
													(if (car &ryo$)
														(setq #bpt (car (car &ryo$)))   ;��
														(progn ; 01/04/16 YM �Վ��Ή�
															(setq #bpt (car (cadr &ryo$))); 01/04/16 YM ADD �݌˂݂̂̂Ƃ�������ʂ�
															(setq #bpt (list (car #bpt)(+ 831 (- (cadr #bpt) CG_CeilHeight)))); ��а 01/04/16 YM ADD
		;;;												(setq #bpt nil) ; 01/04/16 YM ADD �݌˂݂̂̂Ƃ�������ʂ�
														) ; 01/04/16 YM �Վ��Ή�
													);_if
												)
												(progn
													(if (car &ryo$)
														(setq #bpt (list (car (cadr (car &ryo$)))(cadr (car (car &ryo$))) 0.0)) ;�E
														(progn ; 01/04/16 YM �Վ��Ή�
															(setq #bpt (list (car (cadr (cadr &ryo$)))(cadr (car (cadr &ryo$))) 0.0)) ;�E
		;;;												(setq #bpt nil) ; 01/04/16 YM ADD �݌˂݂̂̂Ƃ�������ʂ�
														) ; 01/04/16 YM �Վ��Ή�
													);_if
												)
											)
										)
									);_if (not (KCFIsShomen))
								)
							);_if (and (/= nil #gas) #WEn)
						)
						; �_�C�A���O�w��Ȃ��H
						(t (princ "\nGetBasePtBySekou error"))
					) ;_cond
					(if #bpt
						(setq #ret$ (list (polar #bpt (* 0.5 PI) CG_CeilHeight) #bpt))
						(progn ; 01/04/16 YM �Վ��Ή�
							(setq #ret$ (list nil nil)) ; 01/04/16 YM ADD �݌˂݂̂̂Ƃ�������ʂ�
						) ; 01/04/16 YM �Վ��Ή�
					);_if
				)
			)
		)
	)
	#ret$

); GetBasePtBySekou

;<HOM>*************************************************************************
; <�֐���>    : KCFIsShomen
; <�����T�v>  : ���݂̐}�`�ɐ��ʂ̂��̂������Ă��邩�H
; <�߂�l>    : T �����Ă��� nil �����Ă��Ȃ�
; <�쐬>      : 01/06/22 TM
; <���l>      : �W�J���}�̃_�~�[�}�`("G_SKDM")�����݂��邱�ƁB
;*************************************************************************>MOH<
(defun KCFIsShomen (
	/
	#ssDum	;	�_�~�[�}�`�I���Z�b�g
	#nII		; ����ϐ�
	#ret		; �߂�l
	)
	; �}�`�S�̂��猟������
	(setq #ssDum (ssget "X" (list (list -3 (list "G_SKDM")))))
	(setq #nII 0)
	(repeat (sslength #ssDum)
		(if (= 1 (nth 3 (CFGetXdata (ssname #ssDum #nII) "G_SKDM"))) (setq #ret 1))
		(setq #nII (1+ #nII))
	)
	#ret

); KCFIsShomen

;<HOM>*************************************************************************
; <�֐���>    : KCFGetDummyBasePts
; <�����T�v>  : �_�~�[�}�`�̊�_�����߂�
; <�߂�l>    : �}�`���Ȃ��ꍇnil ���̑��̏ꍇ�͊�_
; <�쐬>      : 01/06/22 TM
; <����>      : 01/07/18 HN �߂�l�����W���X�g������W�ɕύX
; <���l>      : �W�J���}�̃_�~�[�}�`("G_SKDM")�����݂��邱�ƁB
;               �ŏ��x���W�����_����_�Ƃ��� 01/07/18 ADD HN
;*************************************************************************>MOH<
(defun KCFGetDummyBasePts (
	/
	#ssDum		;	�_�~�[�}�`�I���Z�b�g
	#nII #dd	; ����ϐ�
	#dRet$		; ���W���X�g   01/07/18 HN MOD �R�����g�ύX
	#dPt      ; ���W         01/07/18 HN ADD
	#fY       ; �x���W       01/07/18 HN ADD
	#dRet     ; �߂�l       01/07/18 HN ADD
	)
	; �}�`�S�̂��猟������
	(setq #ssDum (ssget "X" (list (list -3 (list "G_SKDM")))))
	(setq #nII 0 #dRet$ '())
	(repeat (sslength #ssDum)
		(if (setq #dd (assoc 10 (entget (ssname #ssDum #nII))))
			(setq #dRet$ (append #dRet$ (list (cdr #dd))))
		)
		(setq #nII (1+ #nII))
	)
	#dRet$

	; 01/07/18 S-ADD HN �ŏ��x���W�����_����_�Ƃ��鏈����ǉ�
	(setq #dRet (car  #dRet$))
	(setq #fY   (cadr #dRet ))
	(foreach #dPt #dRet$
		(if (> #fY (cadr #dPt))
			(progn
				(setq #dRet #dPt)
				(setq #fY (cadr #dRet))
			)
		)
	)
	#dRet
	; 01/07/18 E-ADD HN �ŏ��x���W�����_����_�Ƃ��鏈����ǉ�
); KCFGetDummyBasePts

;<HOM>*************************************************************************
; <�֐���>    : C:GetPMEN
; <�����T�v>  : P�ʐ}�`���擾�^�\������
; <�߂�l>    :
; <�쐬>      : �f�o�b�O�p 01/06/01 TM
; <���l>      : see C:GetPTEN
;*************************************************************************>MOH<
(defun C:GetPMEN (
	/
	#ss
	#i
	#en
	#eg
	#eed$
	#app
	#data$
	)

	(if (setq #ss (ssget "X" (list (list -3 (list "G_PMEN")))))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en    (ssname #ss #i))             ; �}�`���擾
				(setq #eg    (entget #en '("*")))         ; �}�`�f�[�^�擾
				(setq #eed$  (cadr (assoc -3 #eg)))       ; �g���f�[�^�擾
				(setq #app   (car #eed$))                 ; �A�v���P�[�V�������擾
				(setq #data$ (mapcar 'cdr (cdr #eed$)))   ; �����f�[�^�擾
				(cond
					((equal "G_PMEN" #app)                  ; �o��
						; �V���N���A�R������
						(if (or (= 4 (car #data$)) (= 5 (car #data$)))
						; �B���A�O�`
						;if (or (= 1 (car #data$)) (= 2 (car #data$)))
							(progn
								(princ "\nP�ʺ���: ")(princ #data$)(princ "  ��w: ")(princ (cdr (assoc 8 #eg)))
								(princ (cdrassoc 10 #eg))
								;(entmod (subst (cons 62 3) (assoc 62 #eg) #eg))
							)
						)
					)
				)
			)
			(setq #i (1+ #i))
		)
		(princ "\nG_PMEN�̐}�`�͂���܂���.")
	)
	(princ)
)


