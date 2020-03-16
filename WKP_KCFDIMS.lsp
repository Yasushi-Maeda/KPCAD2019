(setq CG_Dim1CharWidth 72)	; TM ADD ���@�����̂P�������̕�(�b���)

(setq CG_SEKOU_DIMSTR_L_OFFSET 50.)  ;�{�H���@�����̐��@������̃I�t�Z�b�g


;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetTopMaterial
;;; <�����T�v>: �J�E���^�[�g�b�v�̑f�ނ��擾����
;;; <�߂�l>  : �g�b�v�f�ރt���O
;;;               0:�l���嗝��  1:�X�e�����X  nil:�g�b�v�Ȃ�
;;; <���l>    : �g�b�v���������݂���ꍇ�A�C�ӂ̃g�b�v�f�ނ�Ԃ��܂��B
;;; <�쐬>    : 2001-03-27 HN
;;;************************************************************************>MOH<
(defun SCFGetTopMaterial
	(
	&sLayer     ; �ΏۂƂ����w��
	/
	#psWRKT     ; �g�b�v�̑I���Z�b�g
	#WRKT$      ; �g�b�v�̊g���f�[�^
	#iTop       ; �g�b�v�̑f�ރt���O
	)

	(setq #psWRKT (ssget "X" (list (cons 8 &layer) (list -3 (list "G_WRKT")))))
	
	(if #psWRKT
		(progn
			(setq #WRKT$ (CFGetXData (ssname #psWRKT 0) "G_WRKT"))
			(if #WRKT$
				(setq #iTop (KCGetZaiF (nth 2 #WRKT$)))
			)
		)
	)

	#iTop
) ;_SCFGetTopMaterial


;<HOM>*************************************************************************
; <�֐���>    : SCFGetPEntity
; <�����T�v>  : �o�}�`�擾
; <�߂�l>    : �o�}�`���X�g
;               �i
;                 �i
;                   �i�����l ���W�P �j...         �o�_
;                 �j
;                 �i
;                   �i�����l ���W�P ���W�Q�j...   �o��
;                 �j
;               �j
; <���l>      : �E���W
;                   �o�_                �o��
;                   ���W�P�F�_���W      ���W�P�F�����_
;                                       ���W�Q�F�E��_
;               �E�K�v�ȃf�[�^
;                   P�_
;                    ���������S�_  �����Q
;                    �{�H�����ʒu
;                    �{�H���@�ʒu  �����P �����Q
;                   P��
;                    �O�`�̈�
;                    �V���N���̈�
;                    �R�������̈�
; <�쐬>      : 1998-07-02
;*************************************************************************>MOH<
(defun SCFGetPEntity (
	&layer   ; (STR)      �W�J�}��w��
	/
	#ss #i #en #eg #eed$ #app #data$ #pt1 #sui$ #dou$ #sun$ #pt$ #pt2
	#ins$ #gai$ #sin$ #gas$ #ten$ #men$
	; 01/03/27 HN S-ADD ���[�J���ϐ���ǉ�
	#iTop       ; �g�b�v�̑f�ރt���O
	#sink0$     ; �V���N���̈�i�l���嗝�΁j
	#sink1$     ; �V���N���̈�i�X�e�����X�j
	; 01/03/27 HN E-ADD ���[�J���ϐ���ǉ�
	)

	;01/03/27 HN ADD �g�b�v�f�ގ擾������ǉ�
	;@DEBUG@(princ "\n&layer: ")(princ &layer) ;01/08/28 HN ADD �f�o�b�O�p
	(setq #iTop (SCFGetTopMaterial &layer))

	(setq #ss (ssget "X" (list (cons 8 &layer)(list -3 (list "G_PTEN,G_PMEN")))))

	(if (/= nil #ss)
		(progn

			(setq #i 0)
			(repeat (sslength #ss)

				; �}�`���擾
				(setq #en    (ssname #ss #i))
				; �}�`�f�[�^�擾
				(setq #eg    (entget #en '("*")))
				; �g���f�[�^�擾
				(setq #eed$  (cadr (assoc -3 #eg)))
				; �A�v���P�[�V�������擾
				(setq #app   (car #eed$))
				; �����f�[�^�擾
				(setq #data$ (mapcar 'cdr (cdr #eed$)))
				(cond
					((equal "G_PTEN" #app)                   ;�o�_
						; �_�}�`�̍��W�擾
						(setq #pt1 (cdr (assoc 10 #eg)))

						(cond
; 01/03/14 TM DEL-S �������͎{�H���@�_�Ƃ��Đ��@�\������悤�ɕύX
;              ((= 5 (car #data$))                  ;���������S�_
;                (if (= 0 (caddr #data$))
;                  (setq #sui$ (cons (list nil #pt1) #sui$))
;                )
;              )
; 01/03/14 TM DEL-S �������͎{�H���@�_�Ƃ��Đ��@�\������悤�ɕύX
							((= 8 (car #data$))                  ;�{�H�����ʒu
									; 01/04/13 TM ADD DEBUG
									; (princ "\n#data$: ")(princ #data$)
									; (princ " ")(princ #pt1)
								(setq #dou$ (cons (list (list (cadr #data$) (caddr #data$)) #pt1 #en) #dou$))
							)
							((= 9 (car #data$))                  ;�{�H���@�ʒu
;@@@05/18DEBUG(princ "\n#data$: ")(princ (car #data$))
								(if (and (= 'INT (type (cadr #data$)))(= 'INT (type (caddr #data$))))
									(progn
										(setq #sun$ (cons (list (list (cadr #data$) (caddr #data$)) #pt1) #sun$))
									)
								)
							)
						)
					)
					((equal "G_PMEN" #app)                ;�o��
						; �}�`�̍����A�E����W�擾
						(setq #pt$ (mapcar 'car (get_allpt_H #en)))
						(setq #pt1
							(list
								(apply 'min (mapcar 'car  #pt$))
								(apply 'min (mapcar 'cadr #pt$))
							)
						)
						(setq #pt2
							(list
								(apply 'max (mapcar 'car  #pt$))
								(apply 'max (mapcar 'cadr #pt$))
							)
						)
						(cond
							((= 2 (car #data$))                  ;�O�`�̈�i�K�X�j
								(if (= 1 (cadr #data$))
									(setq #gai$ (cons (list nil #pt1 #pt2) #gai$))
								)
							)
							((= 4 (car #data$))                  ;�V���N���̈�

								; 2017/09/20 YM MOD
								; �t���[���L�b�`���Ή�
								(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
									(progn
										nil ;�������Ȃ�
									)
									(progn

										; 01/03/27 HN S-ADD �����P�ɂ��V���N���U�蕪�������ɕύX
										;MOD(setq #sin$ (cons (list nil #pt1 #pt2) #sin$))
										;@@@(princ "\n�V���N�� ����1: ")(princ (cadr #data$)) ;DEBUG
										(cond
											((= 0 (cadr #data$))  ; �l���嗝��
												(setq #sink0$ (cons (list nil #pt1 #pt2) #sink0$))
												;@DEBUG@(princ "\n<�l���嗝��> pt1: ")(princ #pt1)(princ "  pt2: ")(princ #pt2) ;01/08/28 HN ADD �f�o�b�O�p
											)
											((= 1 (cadr #data$))  ; �X�e�����X
												(setq #sink1$ (cons (list nil #pt1 #pt2) #sink1$))
												;@DEBUG@(princ "\n<�X�e�����X> pt1: ")(princ #pt1)(princ "  pt2: ")(princ #pt2) ;01/08/28 HN ADD �f�o�b�O�p
											)
										)
										; 01/03/27 HN E-ADD �����P�ɂ��V���N���U�蕪�������ɕύX

									)
								);_if

							)
							((= 5 (car #data$))                  ;�R�������̈�

								; 2017/09/20 YM MOD
								; �t���[���L�b�`���Ή�
								(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
									(progn
										nil ;�������Ȃ�
									)
									(progn

										(setq #gas$ (cons (list nil #pt1 #pt2) #gas$))

									)
								);_if
									
							)
						) ; end cond

					)
					(T
						nil
					)
				)
				(setq #i (1+ #i))
			)
		)
	)

	; 01/03/27 HN S-ADD �����P�ɂ��V���N���U�蕪��������ǉ�
	;@DEBUG@(princ "\n#iTop: ")(princ #iTop) ;01/08/28 HN ADD �f�o�b�O�p
	(cond
		; 01/08/28 HN MOD �j���[�}�[�u����ǉ�
		;@MOD@((= 0 #iTop)    ; �l���嗝��
		((or (= 0 #iTop) (= -1 #iTop))   ; �l���嗝�΁E�j���[�}�[�u��
			(if #sink0$
				(setq #sin$ #sink0$)
				(setq #sin$ #sink1$)
			)
		)
		((= 1 #iTop)    ; �X�e�����X
			(if #sink1$
				(setq #sin$ #sink1$)
				(setq #sin$ #sink0$)
			)
		)
		; 01/07/13 TM �g�b�v�Ȃ��ł��V���N��������ꍇ�ɑΉ�(Lipple�Ή�)
		(T         ; �g�b�v�Ȃ�(�Ƃ肠�����l���嗝�΂�D��)
			;@DEL@(princ "\n�ݸ������װ �ގ�F: ")(princ #iTop) ; 01/08/28 HN ADD �G���[�\��  02/03/26 HN DEL
			(if #sink1$
				(setq #sin$ #sink1$)
				(setq #sin$ #sink0$)
			)
	 		; (princ "�@�g�b�v�Ȃ�: ")
			; (princ #sin$)
		)
	)
	; 01/03/27 HN E-ADD �����P�ɂ��V���N���U�蕪��������ǉ�

	(setq #ten$ (list #sui$ #dou$ #sun$))
	; (princ "\n#ten$: ")
	; (princ #ten$)
	(setq #men$ (list #gai$ #sin$ #gas$))
	; (princ "\n#men$: ")
	; (princ #men$)

	(list #ten$ #men$)
) ; SCFGetPEntity

;<HOM>*************************************************************************
; <�֐���>    : C:GetPTEN
; <�����T�v>  : P�_�}�`���擾�^�\������
; <�߂�l>    : 
; <�쐬>      : �f�o�b�O�p�H 01/02/28 TM 
;*************************************************************************>MOH<
(defun C:GetPTEN (
	/
	#ss
	#i
	#en
	#eg
	#eed$
	#app
	#data$
	)

	(if (setq #ss (ssget "X" (list (list -3 (list "G_PTEN")))))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en    (ssname #ss #i))             ; �}�`���擾
				(setq #eg    (entget #en '("*")))         ; �}�`�f�[�^�擾
				(setq #eed$  (cadr (assoc -3 #eg)))       ; �g���f�[�^�擾
				(setq #app   (car #eed$))                 ; �A�v���P�[�V�������擾
				(setq #data$ (mapcar 'cdr (cdr #eed$)))   ; �����f�[�^�擾
				(cond
					((equal "G_PTEN" #app)                  ; �o�_
						(if (or (= 8 (car #data$)) (= 9 (car #data$)))
							(progn
								(princ "\nP�_����: ")(princ #data$)(princ "  ��w: ")(princ (cdr (assoc 8 #eg)))
								(princ (cdrassoc 10 #eg))
								(entmod (subst (cons 62 3) (assoc 62 #eg) #eg))
							)
						)
					)
				)
				(setq #i (1+ #i))
			)
		)
		(princ "\nG_PTEN�̐}�`�͂���܂���.")
	)
	(princ)
)

;; 01/04/13 TM DEL-S �g�p���Ă��Ȃ��̂ō폜
;;<HOM>*************************************************************************
;; <�֐���>    : SCFDrawDimDoubuti
;; <�����T�v>  : �{�H�������@������}����
;; <�߂�l>    : �ʒu���X�g�i�� �� �� �E�j
;; <�쐬>      : 00/03/27
;;*************************************************************************>MOH<
;(defun SCFDrawDimDoubuti (
;  &pdpt$      ; �{�H�������W���X�g
;  &ryo$       ; �x�[�X�ƃA�b�p�[�̗̈���W���X�g
;  &iti$       ; ���@�ʒuNO
;  &flg        ; �c���t���O�i"Y":��  "T":�c�j
;  /
;  #iti$ #data #pt1$ #pt0$ #minx #maxx #y #ss #i #en #ed$ #pt0 #pt1 #base #ang #iti
;  #tmp$        #flg
;  )
;;@@@(princ "\n&pdpt$: ")(princ &pdpt$)
;
;  ;<HOM>************************************************************************
;  ; <�֐���>  : ##DrawDoubuti
;  ; <�����T�v>: �{�H�������@���c�Ɖ��ɕ����ďo��
;  ; <�߂�l>  : iti
;  ;************************************************************************>MOH<
;  (defun ##DrawDoubuti (
;    &bpt      ; ��_
;    &ceil     ; �V�䍂��
;    &pt$      ; �{�H�����_���W���X�g
;    &flg      ; �c���t���O�i"Y":��  "T":�c�j
;    &iti      ; �ʒu
;    &ang      ; �o�͐��@�p�x
;    /
;    #cpt
;    #wt$
;    #wt
;    #pt
;    #ptp
;    #pt$
;    #i
;    #pt_n$
;    #iti
;    #dpt
;
;
;    #pold
;    #tmp$
;    #newpt$
;
;    )
;    (setq #cpt (polar &bpt (* 0.5 PI) &ceil))
;    (setq #pt$ &pt$)
;    ; 2000/07/12 X���WY���W�̏��Ń\�[�g����
;    ; ((X1 Y1)(X1 Y2)(X1 Y3)�E�E(X2 Y1)(X2 Y2)(X2 Y3)�E�E�E)
;    (setq #pt$ (SCFmg_sort$ 'car #pt$))
;    (setq #newpt$ '() #i 1 #pold (car (nth 0 #pt$)))
;    (mapcar '(lambda (#p)
;      (if (= #i (length #pt$))
;        (progn
;        (setq #tmp$ (append #tmp$ (list #p)))
;        (setq #tmp$ (SCFmg_sort$ 'cadr #tmp$))
;        (setq #newpt$ (append #newpt$ #tmp$))
;        )
;        (progn
;        (if (not (equal (car #p) #pold 0.1))
;          (progn
;            (setq #pold (car #p))
;          (setq #tmp$ (SCFmg_sort$ 'cadr #tmp$))
;          (setq #newpt$ (append #newpt$ #tmp$))
;          (setq #tmp$ '())
;          (setq #tmp$ (append #tmp$ (list #p)))
;          )
;          (progn
;          (setq #tmp$ (append #tmp$ (list #p)))
;          )
;        )
;        )
;      )
;      (setq #i (1+ #i))
;      ) ; lambda
;      #pt$
;    )
;    ; �\�[�g�I���
;    (setq #wt$ #newpt$)
;
;
;    ; 00/05/28 HN S-ADD XY���W�Ń}�[�W���鏈����ǉ�
;    ;@@@(setq #pt$ (PtSort &pt$ (* 0.5 PI) T))
;;    (setq #wt$ (PtSort &pt$ (* 0.5 PI) T))
;
;    (setq #i 0 #pt$ '())
;    (setq #ptp (list -9999.9 -9999.9 0.0))
;    (repeat (length #wt$)
;      (setq #wt (nth #i #wt$))
;      (setq #pt (list (car #wt) (cadr #wt) 0.0))
;      (if
;        (or
;          (not (equal (car  #ptp) (car  #pt) 0.1))
;          (not (equal (cadr #ptp) (cadr #pt) 0.1))
;        )
;        (progn
;          (setq #pt$ (cons #pt #pt$))
;          ; (setq #ptp #pt)
;        )
;      )
;      (setq #ptp #pt)
;      (setq #i (1+ #i))
;    )
;    (setq #pt$ (reverse #pt$))
;    ; 00/05/28 HN E-ADD XY���W�Ń}�[�W���鏈����ǉ�
;
;    ; X���W���قȂ�ꍇ(I�^2��̏ꍇ�ȂǁA���ʂ�2����ꍇ�ɂ�����???)��
;    ; �Ή��͍s��Ȃ����Ƃɂ���B�܂蓯�����@�����������ɍ쐬����Ă�
;    ; ���܂�Ȃ����̂Ƃ���B(�Г��ł����킹)
;
;;@debug@(setq #i 0)
;;@debug@(repeat (length #pt$)
;;@debug@  (princ "\nNo.")(princ #i)(princ ": ")(princ (nth #i #pt$))
;;@debug@  (setq #i (1+ #i))
;;@debug@)
;
;    (if (= "Y" &flg)
;      ; ������
;      (progn
;        ;��̂Ƃ��͈�Ȃ�
;        (if (/= 0 (rem (length #pt$) 2))
;          (setq #pt$ (reverse (cdr (reverse #pt$))))
;        )
;        (setq #i 0)
;        (repeat (/ (length #pt$) 2)
;          (setq #pt_n$ (cons (list &bpt (nth #i #pt$) (nth (1+ #i) #pt$)) #pt_n$))
;;(princ "\n")(princ (car #pt_n$))
;          (setq #i (+ 2 #i))
;        )
;        ; 2000/06/28 HT ��Q16 ���@�\�����d�Ȃ� => �\���Ȃ��Ƃ���
;        ;;�Ō�̗v�f�ɂ͓V��ʒu���W�������� 2000/06/28 HT DEL
;        ; (setq #pt_n$ (append (list (cons #cpt (car #pt_n$))) (cdr #pt_n$))) ; 2000/06/28 HT DEL
;        (setq #pt_n$ (reverse #pt_n$))
;      )
;      ; �c����
;      (progn
;        ; 2000/06/28 HT ��Q16 ���@�\�����d�Ȃ� => �\���Ȃ��Ƃ���
;        ; (setq #pt_n$ (list (append (list &bpt) #pt$ (list #cpt))))
;        (setq #pt_n$ (list (append (list &bpt) #pt$)))
;      )
;    )
;    (setq #iti &iti)
;
;    (foreach #pt$ #pt_n$
;      (setq #dpt (polar &bpt &ang (GetDimHeight #iti)))
;      (SCFDrawDimLin #pt$ &bpt #dpt "V")
;      (setq #iti (1+ #iti))
;    )
;    #iti
;  ); defun ##DrawDoubuti
;  ;******************************************************************************
;
;  (setq #iti$ &iti$)
;
;  ;���ʂƑ��ʂ𕪂���
;  (foreach #data &pdpt$
;    (if (= 1 (car #data))
;      (setq #pt1$ (cons (cadr #data) #pt1$))  ; ����
;      (setq #pt0$ (cons (cadr #data) #pt0$))  ; ����
;    )
;  )
;  ; Z���W��0.0�ɂ���
;  (setq #pt1$ (2dto3d (3dto2d #pt1$)))  ; ����
;  (setq #pt0$ (2dto3d (3dto2d #pt0$)))  ; ����
;
;
;  ;�A�b�p�[�L���r�l�b�g��X���W�l��
;  (setq #minx (car  (car  (car &ryo$))))
;  (setq #maxx (car  (cadr (car &ryo$))))
;  (setq #y    (cadr (car  (car &ryo$))))
;  ;�_�~�[�_�擾
;  (setq #ss (ssget "X" (list (list -3 (list "G_SKDM")))))
;  (if (/= nil #ss)
;    (progn
;      (setq #i 0)
;      (repeat (sslength #ss)
;        (setq #en (ssname #ss #i))
;        (setq #ed$ (CfGetXData #en "G_SKDM"))
;
;				; ���[�N�g�b�v�_�~�[�}�`
;        (if (= "W" (nth 1 #ed$))
;          (cond
;						; ���f�������_�ԍ� 0 ���ʁH
;            ((= 0 (nth 3 #ed$))
;              ;(princ #pt0)
;            )
;						; ���f�������_�ԍ� 1 ���ʁH
;            ((= 1 (nth 3 #ed$))
;              ;(princ #pt1)
;            )
;          )
;        )
;        (setq #i (1+ #i))
;      )
;
;      ; 2000/06/20 HT ���ʂŐ��ʂƓ������@�l�̂��̂́A��}���Ȃ�
;      ; L�^�ł̕s��C���̂���
;      (setq #tmp$ #pt0$)
;      (setq #pt0$ '())
;      (setq #i 0)
;      (repeat (/ (length #tmp$) 2)
;
;				(setq #flg nil #j 0)
;				(repeat (length #pt1$)
;					(if (equal (distance (nth #j #pt1$) (nth #i #tmp$)) 0 0.1)
;						(progn
;							(setq #flg T)
;						)
;					)
;					(setq #j (1+ #j))
;				)
;
;				(if #flg
;					(progn
;						(setq #flg nil #j 0)
;						(repeat (length #pt1$)
;							(if (equal (distance (nth #j #pt1$) (nth (1+ #i) #tmp$)) 0 0.1)
;								(progn
;									(setq #flg T)
;								)
;							)
;							(setq #j (1+ #j))
;						)
;					)
;				)
;
;        (if (= #flg nil)
;          (progn
;						(setq #pt0$ (append #pt0$ (list (nth #i #tmp$))))
;						(setq #pt0$ (append #pt0$ (list (nth (1+ #i) #tmp$))))
;          )
;        )
;        (setq #i (+ #i 2))
;      )
;      ; 2000/06/20 HT ���ʂŐ��ʂƓ������@�l�̂��̂́A��}���Ȃ�
;
;      ;���ʕ�����}
;      (if (/= nil #pt1$)
;        (progn
;					; ���@�̌������w��
;          ; 2000/06/28 HT ���[�N�g�b�v�Ŕ��肹���AP�_�Ƃ���
;          ;_if (< (abs (- #minx (car #pt1))) (abs (- #maxx (car #pt1))))
;          (if (< (abs (- #minx (car (nth 0 #pt1$)))) (abs (- #maxx (car (nth 0 #pt1$)))))
;            (progn
;              (setq #base (list #minx #y 0.0))
;              (setq #ang  PI)
;              (setq #iti (nth 2 #iti$))
;            )
;            (progn
;              (setq #base (list #maxx #y 0.0))
;              (setq #ang  0.0)
;              (setq #iti (nth 3 #iti$))
;            )
;          )
;          (setq #iti (##DrawDoubuti #base CG_CeilHeight #pt1$ &flg #iti #ang))
;          (if (/= 0.0 #ang)
;            (setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) #iti (nth 3 #iti$)))
;            (setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) (nth 2 #iti$) #iti))
;          )
;        )
;      )
;      ;���ʕ�����}
;      (if (/= nil #pt0$)
;        (progn
;          (if (< (abs (- #minx (car (nth 0 #pt0$)))) (abs (- #maxx (car (nth 0 #pt0$)))))
;            (progn
;              (setq #base (list #minx #y 0.0))
;              (setq #ang  PI)
;              (setq #iti (nth 2 #iti$))
;            )
;            (progn
;              (setq #base (list #maxx #y 0.0))
;              (setq #ang  0.0)
;              (setq #iti (nth 3 #iti$))
;            )
;          )
;          (setq #iti (##DrawDoubuti #base CG_CeilHeight #pt0$ &flg #iti #ang))
;          (if (/= 0.0 #ang)
;            (setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) #iti (nth 3 #iti$)))
;            (setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) (nth 2 #iti$) #iti))
;          )
;        )
;      )
;    )
;  )
;
;  #iti$
;) ; SCFDrawDimDoubuti
; 01/04/13 TM DEL-E �g�p���Ă��Ȃ��̂ō폜

;<HOM>*************************************************************************
; <�֐���>    : SCFDrawDimDoubuti2Exec
; <�����T�v>: �{�H�������@���c�Ɖ��ɕ����ďo��
; <�߂�l>    : �ʒu
; <�쐬>      : 00/03/27  00/08
;             : ���ʂŐ��ʂƓ������@�l�̂��̂́A��}���Ȃ��B
;             : P�_��Z���W�͖���
;             : P�_X�ʒu�ɂ��A�A�C�e���S�̗̂̈�̍��E�ɍ�}����悤�ύX
;*************************************************************************>MOH<
(defun KCFDrawDimDoubuti2Exec (
	&bpt      ; ��_
	&ceil     ; �V�䍂��
	&pt$      ; �{�H�����_���W���X�g
	&flg      ; �c���t���O�i"Y":��  "T":�c�j
	&iti      ; �ʒu
	&ang      ; �o�͐��@�p�x
	/
	#cpt			; �V�䍂���̓_
	#wt$			; 
	#wt				; �{�H�����_���W
	#pt				; ����ϐ�
	#ptp
	#pt$ #i		; ����p�ϐ�
	#pt_n$
	#iti			; �\���ʒu
	#dpt			; ���@�_
	)
	(setq #cpt (polar &bpt (* 0.5 PI) &ceil))
	(setq #wt$ &pt$)

	; 01/05/28 HN ADD �ʒu=nil�̏ꍇ�͂O��ݒ�
	(if (= nil &iti)
		(setq &iti 0)
	)
	
	; 00/05/28 HN S-ADD XY���W�Ń}�[�W���鏈����ǉ�
	;@@@(setq #pt$ (PtSort &pt$ (* 0.5 PI) T))
	;    (setq #wt$ (PtSort &pt$ (* 0.5 PI) T))

	(setq #i 0 #pt$ '())
	(setq #ptp (list -9999.9 -9999.9 0.0))				; �Q�Ɠ_
	(repeat (length #wt$)
		(setq #wt (nth #i #wt$))										; �������@�_
		(setq #pt (list (car #wt) (cadr #wt) 0.0))	; �Q�����������_
		; X Y ���W���������ꍇ�Ƀ}�[�W�ΏۂƂ݂Ȃ�
		(if (or (not (equal (car  #ptp) (car  #pt) 0.1))
						(not (equal (cadr #ptp) (cadr #pt) 0.1)))
			(progn
				(setq #pt$ (cons #pt #pt$))
				; (setq #ptp #pt)
			)
		)
		(setq #ptp #pt)
		(setq #i (1+ #i))
	)
	(setq #pt$ (reverse #pt$))
	; 00/05/28 HN E-ADD XY���W�Ń}�[�W���鏈����ǉ�

	; 01/04/13 TM ADD DEBUG ZAN
	; DEBUG (princ "\n��}����_�̐�(�O): ")(princ (length #pt$))
	;	DEBUG (setq #i 0)
	; DEBUG	(repeat (length #pt$)
	; DEBUG		(princ "\nNo.")(princ #i)(princ ": ")(princ (nth #i #pt$))
	; DEBUG		(setq #i (1+ #i))
	; DEBUG	)

	(if (= "Y" &flg)
		; ������
		(progn
			;��̂Ƃ��͈�Ȃ�
			; 01/04/15 TM MOD ZAN �������@�̎d�l�l���v �Q���Ƃɕ\�����S�ĘA���Ɏb��ύX��
			; (if (/= 0 (rem (length #pt$) 2))
			; 	(setq #pt$ (reverse (cdr (reverse #pt$))))
			; )
			;(setq #i 0)
			; 01/04/15 TM MOD ZAN �������@�̎d�l�l���v �Q���Ƃɕ\�����S�ĘA���Ɏb��ύX��
			;(repeat (/ (length #pt$) 2)
			;	(setq #pt_n$ (cons (list &bpt (nth #i #pt$) (nth (1+ #i) #pt$)) #pt_n$))
			;	(setq #i (+ 2 #i))
			;)
			; 01/04/15 TM MOD ZAN �������@�̎d�l�l���v �Q���Ƃɕ\�����S�ĘA���Ɏb��ύX��
			(setq #pt_n$ (list &bpt) #pt nil)
			(foreach #pt #pt$
				(setq #pt_n$ (append (list #pt) #pt_n$))
			)
;			(princ "\n�Ă�Ă�")
;			(princ #pt_n$)
			; 2000/06/28 HT ��Q16 ���@�\�����d�Ȃ� => �\���Ȃ��Ƃ���
			;;�Ō�̗v�f�ɂ͓V��ʒu���W�������� 2000/06/28 HT DEL
			; (setq #pt_n$ (append (list (cons #cpt (car #pt_n$))) (cdr #pt_n$))) ; 2000/06/28 HT DEL
			(setq #pt_n$ (reverse #pt_n$))

		)
		; �c����
		(progn
			; 2000/06/28 HT ��Q16 ���@�\�����d�Ȃ� => �\���Ȃ��Ƃ���
			; (setq #pt_n$ (list (append (list &bpt) #pt$ (list #cpt))))
			; 01/04/23 HN  MOD
			;@MOD@(setq #pt_n$ (list (append (list &bpt) #pt$)))
			(setq #pt_n$ (append (list &bpt) #pt$))
		)
	)
	; 01/04/13 TM ADD DEBUG ZAN
	; DEBUG (princ "\n��}����_�̐�: ")(princ (length #pt_n$))
	; DEBUG (setq #i 0)
	; DEBUG (repeat (length #pt_n$)
	; DEBUG 	(princ "\nNo.")(princ #i)(princ ": ")(princ (nth #i #pt_n$))
	; DEBUG 	(setq #i (1+ #i))
	; DEBUG )

; 01/04/15 TM MOD-S ZAN �������@�̎d�l�l���v �Q���Ƃɕ\�����S�ĘA���Ɏb��ύX��
;	(setq #iti &iti)
;	(foreach #pt$ #pt_n
;		(setq #dpt (polar &bpt &ang (GetDimHeight #iti)))
;		(SCFDrawDimLin #pt$ &bpt #dpt "V")
;		(setq #iti (1+ #iti))
;	)
; 01/04/15 TM MOD-E ZAN �������@�̎d�l�l���v �Q���Ƃɕ\�����S�ĘA���Ɏb��ύX��

	(SCFDrawDimLin #pt_n$ &bpt (polar &bpt &ang (GetDimHeight &iti)) "V")
	(SCFDrawDimLinAddStr #pt_n$ &bpt (polar &bpt &ang (GetDimHeight &iti)) "V" #dimId)
	(setq #iti (1+ &iti))

	#iti

) ;_defun KCFDrawDimDoubuti2Exec


;<HOM>*************************************************************************
; <�֐���>    : SCFDrawDimDoubuti2
; <�����T�v>  : �{�H�������@������}����
; <�߂�l>    : �ʒu���X�g�i�� �� �� �E�j
; <�쐬>      : 00/03/27  00/08
;             : ���ʂŐ��ʂƓ������@�l�̂��̂́A��}���Ȃ��B
;             : P�_��Z���W�͖���
;             : P�_X�ʒu�ɂ��A�A�C�e���S�̗̂̈�̍��E�ɍ�}����悤�ύX
;*************************************************************************>MOH<
(defun SCFDrawDimDoubuti2 (
	&pdpt$      ; �{�H�������W���X�g
	&ryo$       ; �x�[�X�ƃA�b�p�[�̗̈���W���X�g
	&iti$       ; ���@�ʒuNO
	&flg        ; �c���t���O�i"Y":��  "T":�c�j
	/
	#iti$ #data #pt1$ #pt0$ #minx #maxx #y #ss #i #j #en #ed$ #pt0 #pt1 #base #ang #iti
	#tmp$        #flg
	#pt0$
	#pt1$
	#pt0L$$ #pt0R$$ #pt1L$$ #pt1R$$ 
	)

;01/04/15 TM MOD-S KCFDrawDimDoubuti2Exec �Ƃ��ĊO�ɏo����
;  ;<HOM>************************************************************************
;  ; <�֐���>  : ##DrawDoubuti
;  ; <�����T�v>: �{�H�������@���c�Ɖ��ɕ����ďo��
;  ; <�߂�l>  : iti
;  ;************************************************************************>MOH<
;  (defun ##DrawDoubuti (
;    &bpt      ; ��_
;    &ceil     ; �V�䍂��
;    &pt$      ; �{�H�����_���W���X�g
;    &flg      ; �c���t���O�i"Y":��  "T":�c�j
;    &iti      ; �ʒu
;    &ang      ; �o�͐��@�p�x
;    /
;    )
;  )
;  ;******************************************************************************
;01/04/15 TM MOD-E KCFDrawDimDoubuti2Exec �Ƃ��ĊO�ɏo����

	(setq #iti$ &iti$)

	;DEBUG (princ "\n &pdpt$: ")
	;DEBUG (princ &pdpt$)

	;���ʂƑ��ʂ𕪂���
	(foreach #data &pdpt$
		; ���ꕽ�ʏ�ɓ_���ڂ�
		(setq #data (list (car #data) (caadr #data) (cadadr #data) 0.0))

		;DEBUG (princ "\n #data: ")
		;DEBUG (princ #data)

		(if (= 1 (car #data))
			(setq #pt1$ (cons (cdr #data) #pt1$))  ; ����
			(setq #pt0$ (cons (cdr #data) #pt0$))  ; ����
		)
	)
	;DEBUG (princ "\n#pt1$ #pt0$:")(princ #pt1$)(princ " ")(princ #pt0$)

	;�A�b�p�[�L���r�l�b�g��X���W�l��
	(setq #minx (car  (car  (car &ryo$))))
	;�A�b�p�[�L���r�l�b�g��X���W�l��
	; 01/04/05 TM ADD-S �A�b�p�[�L���r�l�b�g�̑��݂��`�F�b�N���A�Ȃ��ꍇ�̓x�[�X�L���r�l�b�g���g�p����
	(if (car &ryo$)
		(progn
			(setq #minx (car  (car  (car &ryo$))))
			(setq #maxx (car  (cadr (car &ryo$))))
			(setq #y    (cadr (car  (car &ryo$))))
		)
		(progn
			(setq #minx (car  (car  (cadr &ryo$))))
			(setq #maxx (car  (cadr (cadr &ryo$))))
			(setq #y    (cadr (car  (cadr &ryo$))))
		)
	)
	; 01/04/05 TM ADD-S �A�b�p�[�L���r�l�b�g�̑��݂��`�F�b�N���A�Ȃ��ꍇ�̓x�[�X�L���r�l�b�g���g�p����

	;�_�~�[�_�擾
	(setq #ss (ssget "X" (list (list -3 (list "G_SKDM")))))
	(if (/= nil #ss)
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #i))
				(setq #ed$ (CfGetXData #en "G_SKDM"))
				; ���[�N�g�b�v�_�~�[�_
				(if (= "W" (nth 1 #ed$))
					(cond
						((= 0 (nth 3 #ed$))
							(setq #pt0 (cdrassoc 10 (entget #en)))
						)
						((= 1 (nth 3 #ed$))
							(setq #pt1 (cdrassoc 10 (entget #en)))
						)
					)
				)
				(setq #i (1+ #i))
			)

			; DEBUG (princ "\n#pt1$ #pt0$:")(princ #pt1$)(princ "\n")(princ #pt0$)

			; 01/04/15 TM MOD-S �k�^�̏ꍇ�݂̂ɓK�p����悤�ɕύX
			(if (wcmatch CG_KitType "L-*")
				(progn
					; 2000/06/20 HT ���ʂŐ��ʂƓ������@�l�̂��̂́A��}���Ȃ��悤�ɂ����B
					; L�^�ł̕s��C���̂���
					(setq #tmp$ #pt0$)
					(setq #pt0$ '())
					(setq #i 0)
					(repeat (/ (length #tmp$) 2)

						(setq #flg nil #j 0)
						(repeat (length #pt1$)
							(if (equal (distance (nth #j #pt1$) (nth #i #tmp$)) 0 0.1)
								(progn
									(setq #flg T)
								)
							)
							(setq #j (1+ #j))
						)
						(if #flg
							(progn
								(setq #flg nil #j 0)
								(repeat (length #pt1$)
									(if (equal (distance (nth #j #pt1$) (nth (1+ #i) #tmp$)) 0 0.1)
										(progn
											(setq #flg T)
										)
									)
									(setq #j (1+ #j))
								)
							)
						)

						(if (= #flg nil)
							(progn
								(setq #pt0$ (append #pt0$ (list (nth #i #tmp$))))
								(setq #pt0$ (append #pt0$ (list (nth (1+ #i) #tmp$))))
							)
						)
						(setq #i (+ #i 2))
					)
				)
			);_ if (wcmatch CG_KitType "L-*")
			; 01/04/15 TM MOD-E �k�^�̏ꍇ�݂̂ɓK�p����悤�ɕύX
; 06/07/14 T.Ari ADD-S �_��}�[�W�����ǉ�
			; ���̓_���Y���W���S�Ċ܂܂��_����폜
			(defun ##MergeDoubutiPt ( &ptMarge$$ / )
				; ���̓_���Y���W���S�Ċ܂܂��_����폜(������ŋt�����X�g�ϊ�)
				(defun ##MergeDoubutiPtSub1 ( &ptMarge$$ / )
					; �_���Y���W���X�g�����̓_��Ɋ܂܂�Ă��Ȃ���Γ_���Ԃ�
					(defun ##MergeDoubutiPtSub2 ( &ptMarge1$ &ptMarge2$$ / )
						; Y���W���X�g�����̓_���Y���W�ɑS�Ċ܂܂�邩�`�F�b�N
						(defun ##MergeDoubutiPtSub3 ( &y1$ &ptMarge2$$ / #y2$ )
							(if &ptMarge2$$
								(progn
									(setq #y2$ (mapcar 'cadr (car &ptMarge2$$)))
									; &l1$���X�g�̒��̒l���S��&l2$���X�g�ɂ����T
									(defun ##ListCheck ( &l1$ &l2$ / )
										(if &l1$ 
											(if (member (car &l1$) &l2$) (##ListCheck (cdr &l1$) &l2$) nil )
											T
										)
									)
									(if (##ListCheck &y1$ #y2$)
										nil
										(##MergeDoubutiPtSub3 &y1$ (cdr &ptMarge2$$))
									)
								)
								T
							)
						)
						(if &ptMarge2$$
							; �`�F�b�N�_��̑S��Y���W�����̓_��ɂ��邩���`�F�b�N
							(if (##MergeDoubutiPtSub3 (mapcar 'cadr &ptMarge1$) &ptMarge2$$)
								;�Ȃ���Α��̓_������l�Ƀ`�F�b�N(�ċA)���A�`�F�b�N���ʂɎ������܂߂ĕԋp
								(append (##MergeDoubutiPtSub2 (car &ptMarge2$$) (cdr &ptMarge2$$)) (list &ptMarge1$))
								;����Α��̓_������l�Ƀ`�F�b�N(�ċA)���A���̃`�F�b�N���ʂ�ԋp
								(##MergeDoubutiPtSub2 (car &ptMarge2$$) (cdr &ptMarge2$$))
							)
							; �`�F�b�N�Ώۂ̓_�񂪂Ȃ��̂ł��̓_���Y���W�����̓_��Ɋ܂܂�邱�Ƃ͂Ȃ�
							; �̂ŕԋp
							(list &ptMarge1$)
						)
					)
					(##MergeDoubutiPtSub2 (car &ptMarge$$) (cdr &ptMarge$$))
				)
				(if &ptMarge$$
					(##MergeDoubutiPtSub1 (##MergeDoubutiPtSub1 &ptMarge$$))
					nil
				)
			)
; 06/07/14 T.Ari ADD-E �_��}�[�W�����ǉ�
			
			(if (/= nil #pt1$)
				;���ʕ�����}
				(progn
			
					; ����X���W�ŕ����� X���W���������̂̓��X�g�ł����� Y���W�̓\�[�g�� 2000/08 HT
					(setq #pt1$$ (SCFCmnXYSortByX #pt1$))
					; ����X���W���ɁA�A�C�e���S�̗̂̈�̍�����or�E�����ɐ��@����}���邩���߂�
; 06/07/14 T.Ari MOD-S �_��}�[�W�����ǉ�
					(foreach  #pt1$ #pt1$$
						; 2000/06/28 HT ���[�N�g�b�v��P�_�Ŕ���
						;_if (< (abs (- #minx (car #pt1))) (abs (- #maxx (car #pt1))))
						(if (< (abs (- #minx (car (nth 0 #pt1$)))) (abs (- #maxx (car (nth 0 #pt1$)))))
							(setq #pt1L$$ (append #pt1L$$ (list #pt1$)))
							(setq #pt1R$$ (append #pt1R$$ (list #pt1$)))
						)
					)
					(setq #pt1L$$ (##MergeDoubutiPt #pt1L$$))
					(setq #pt1R$$ (##MergeDoubutiPt #pt1R$$))
					(foreach  #pt1$ (append #pt1L$$ #pt1R$$)
; 06/07/14 T.Ari MOD-E �_��}�[�W�����ǉ�
						; 2000/06/28 HT ���[�N�g�b�v��P�_�Ŕ���
						;_if (< (abs (- #minx (car #pt1))) (abs (- #maxx (car #pt1))))
						(if (< (abs (- #minx (car (nth 0 #pt1$)))) (abs (- #maxx (car (nth 0 #pt1$)))))
							(progn
								(setq #base (list #minx #y 0.0))
								(setq #ang  PI)
								(setq #iti (nth 2 #iti$))
							)
							(progn
								(setq #base (list #maxx #y 0.0))
								(setq #ang  0.0)
								(setq #iti (nth 3 #iti$))
							)
						)
						; DEBUG (princ "\n���� ")
						; DEBUG (princ #pt1$)
						; DEBUG (princ "\n")
						; DEBUG (princ #base)
						; DEBUG (princ "\n")
						; DEBUG (princ &flg)
						; DEBUG (princ "\n")
						; DEBUG (princ #ang)
						; 01/04/13 TM MOD �O�ɏo����
						;(setq #iti (##DrawDoubuti #base CG_CeilHeight #pt1$ &flg #iti #ang))
						(setq #iti (KCFDrawDimDoubuti2Exec #base CG_CeilHeight #pt1$ &flg #iti #ang))
						(if (/= 0.0 #ang)
							(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) #iti (nth 3 #iti$)))
							(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) (nth 2 #iti$) #iti))
						)
					)
				)
				;���ʕ�����}
				(if (/= nil #pt0$)
					(progn

						; ����X���W�ŕ����� X���W���������̂̓��X�g�ł����� Y���W�̓\�[�g�� 2000/08 HT
						(setq #pt0$$ (SCFCmnXYSortByX #pt0$))
						; ����X���W���ɁA�A�C�e���S�̗̂̈�̍�����or�E�����ɐ��@����}���邩���߂�
; 06/07/14 T.Ari MOD-S �_��}�[�W�����ǉ�
						(foreach #pt0$ #pt0$$
							(if (< (abs (- #minx (car (nth 0 #pt0$)))) (abs (- #maxx (car (nth 0 #pt0$)))))
								(setq #pt0L$$ (append #pt0L$$ (list #pt0$)))
								(setq #pt0R$$ (append #pt0R$$ (list #pt0$)))
							)
						)
						(setq #pt0L$$ (##MergeDoubutiPt #pt0L$$))
						(setq #pt0R$$ (##MergeDoubutiPt #pt0R$$))
						(foreach  #pt0$ (append #pt0L$$ #pt0R$$)
; 06/07/14 T.Ari MOD-E �_��}�[�W�����ǉ�
							(if (< (abs (- #minx (car (nth 0 #pt0$)))) (abs (- #maxx (car (nth 0 #pt0$)))))
								(progn
									(setq #base (list #minx #y 0.0))
									(setq #ang  PI)
									(setq #iti (nth 2 #iti$))
								)
								(progn
									(setq #base (list #maxx #y 0.0))
									(setq #ang  0.0)
									(setq #iti (nth 3 #iti$))
								)
							)
							; DEBUG (princ "\n���� ")
							; DEBUG (princ #pt0$)
							; DEBUG (princ "\n")
							; DEBUG (princ #base)
							; DEBUG (princ "\n")
							; DEBUG (princ &flg)
							; DEBUG (princ "\n")
							; DEBUG (princ #ang)
							; �{�H�������@��}
							; 01/04/13 TM MOD �O�ɏo����
							;(setq #iti (##DrawDoubuti #base CG_CeilHeight #pt0$ &flg #iti #ang))
							(setq #iti (KCFDrawDimDoubuti2Exec #base CG_CeilHeight #pt0$ &flg #iti #ang))
							(if (/= 0.0 #ang)
								(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) #iti (nth 3 #iti$)))
								(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) (nth 2 #iti$) #iti))
							)
						)
					)
				);_if (/= nil #pt0$)
			)
		)
	)

	#iti$
) ; SCFDrawDimDoubuti2


;<HOM>*************************************************************************
; <�֐���>    : SCFDrawDimDoubuti3Exec
; <�����T�v>: �{�H�������@���c�Ɖ��ɕ����ďo��
; <�߂�l>    : �ʒu
; <�쐬>      : 08/12/17
;             : ���ʂŐ��ʂƓ������@�l�̂��̂́A��}���Ȃ��B
;             : P�_��Z���W�͖���
;             : P�_X�ʒu�ɂ��A�A�C�e���S�̗̂̈�̍��E�ɍ�}����悤�ύX
;*************************************************************************>MOH<
(defun KCFDrawDimDoubuti3Exec (
	&bpt      ; ��_
	&ceil     ; �V�䍂��
	&pt$      ; �{�H�����_���W���X�g
	&flg      ; �c���t���O�i"Y":��  "T":�c�j
	&iti      ; �ʒu
	&ang      ; �o�͐��@�p�x
	&dimId		; ���@����ID
	/
	#cpt			; �V�䍂���̓_
	#wt$			; 
	#wt				; �{�H�����_���W
	#pt				; ����ϐ�
	#ptp
	#pt$ #i		; ����p�ϐ�
	#pt_n$
	#iti			; �\���ʒu
	#dpt			; ���@�_
	)
	(setq #cpt (polar &bpt (* 0.5 PI) &ceil))
	(setq #wt$ &pt$)

	(if (= nil &iti)
		(setq &iti 0)
	)
	
	(setq #i 0 #pt$ '())
	(setq #ptp (list -9999.9 -9999.9 0.0))				; �Q�Ɠ_
	(repeat (length #wt$)
		(setq #wt (nth #i #wt$))										; �������@�_
		(setq #pt (list (car #wt) (cadr #wt) 0.0))	; �Q�����������_
		; X Y ���W���������ꍇ�Ƀ}�[�W�ΏۂƂ݂Ȃ�
		(if (or (not (equal (car  #ptp) (car  #pt) 0.1))
						(not (equal (cadr #ptp) (cadr #pt) 0.1)))
			(progn
				(setq #pt$ (cons #pt #pt$))
			)
		)
		(setq #ptp #pt)
		(setq #i (1+ #i))
	)
	(setq #pt$ (reverse #pt$))

	(if (= "Y" &flg)
		; ������
		(progn
			(setq #pt_n$ (list &bpt) #pt nil)
			(foreach #pt #pt$
				(setq #pt_n$ (append (list #pt) #pt_n$))
			)
			(setq #pt_n$ (reverse #pt_n$))

		)
		; �c����
		(progn
			(setq #pt_n$ (append (list &bpt) #pt$))
		)
	)
	(SCFDrawDimLinAddStr (list (car #pt_n$) (cadr #pt_n$)) &bpt (polar &bpt &ang (GetDimHeight &iti)) "V" &dimId)
	(if (cdr #pt_n$)
		(SCFDrawDimLinAddStr (cdr #pt_n$) &bpt (polar &bpt &ang (GetDimHeight &iti)) "V" 0)
	)
	(setq #iti (1+ &iti))

	#iti

) ;_defun KCFDrawDimDoubuti3Exec

;<HOM>*************************************************************************
; <�֐���>    : SCFDrawDimDoubuti3
; <�����T�v>  : �{�H�������@������}����
; <�߂�l>    : �ʒu���X�g�i�� �� �� �E�j
; <�쐬>      : 08/12/17
;             : ���ʂŐ��ʂƓ������@�l�̂��̂́A��}���Ȃ��B
;             : P�_��Z���W�͖���
;             : P�_X�ʒu�ɂ��A�A�C�e���S�̗̂̈�̍��E�ɍ�}����悤�ύX
;*************************************************************************>MOH<
(defun SCFDrawDimDoubuti3 (
	&pdpt$      ; �{�H�������W���X�g
	&ryo$       ; �x�[�X�ƃA�b�p�[�̗̈���W���X�g
	&iti$       ; ���@�ʒuNO
	&flg        ; �c���t���O�i"Y":��  "T":�c�j
	/
	#iti$ #data #pt1$ #pt0$ #minx #maxx #y #ss #i #j #en #ed$ #pt0 #pt1 #base #ang #iti
	#tmp$        #flg
	#pt0$
	#pt1$
	#pt0L$$ #pt0R$$ #pt1L$$ #pt1R$$
	#pdpt$
	#pdpt$$ #pdptadd$ #pdpttmp$
	#pdpt$ #pdpt2$ #pdpt3$
	#pdpt2add$ #datatmp #pdpttmp$
	#pdpt3tmp$
	#pt$$
	#pdpt3$ #pdpt3f$ #pdpt3s$ #pdpt3u$ #pdpt3r$ #pdpt3add$ #pdpt3tmp$
	#pdpt3 #pdpt3f #pdpt3s #pdpt3u #pdpt3r #pdpt3tmp #pdpt3stmp
	#pdpt4$ #pdpt4
	#pdpt4L$ #pdpt4L
	#pdpt4R$ #pdpt4R
	)

	(setq #iti$ &iti$)


	;�A�b�p�[�L���r�l�b�g��X���W�l��
	(setq #minx (car  (car  (car &ryo$))))
	;�A�b�p�[�L���r�l�b�g��X���W�l��
	(if (car &ryo$)
		(progn
			(setq #minx (car  (car  (car &ryo$))))
			(setq #maxx (car  (cadr (car &ryo$))))
			(setq #y    (cadr (car  (car &ryo$))))
		)
		(progn
			(setq #minx (car  (car  (cadr &ryo$))))
			(setq #maxx (car  (cadr (cadr &ryo$))))
			(setq #y    (cadr (car  (cadr &ryo$))))
		)
	)
	(setq #pdpt$$ nil)
	(setq #pdpt$ &pdpt$)
	(while (setq #data (car #pdpt$))
		(setq #pdptadd$ (list #data))
		(setq #pdpt$ (cdr #pdpt$))
		(setq #pdpttmp$ nil)
		(while (setq #datatmp (car #pdpt$))
			(setq #pdpt$ (cdr #pdpt$))
			(if (= (caar #data) (caar #datatmp))
				(setq #pdptadd$ (append #pdptadd$ (list #datatmp)))
				(setq #pdpttmp$ (append #pdpttmp$ (list #datatmp)))
			)
		)
		(setq #pdpt$ #pdpttmp$)
		(setq #pdpt$$ (append #pdpt$$ (list #pdptadd$)))
	)
	
	(setq #pdpt3f$ nil)
	(setq #pdpt3s$ nil)
	(setq #pdpt3u$ nil)
	(setq #pdpt3r$ nil)
	(foreach #pdpt$ #pdpt$$

		(setq #pdpt2$ nil)
		(while (setq #data (car #pdpt$))
			(setq #pdpt$ (cdr #pdpt$))
			(setq #pdpt2add$ (list (cadr #data)))
			(setq #pdpttmp$ nil)
			(while (setq #datatmp (car #pdpt$))
				(setq #pdpt$ (cdr #pdpt$))
				(if (= (cadar #data) (cadar #datatmp))
					(setq #pdpt2add$ (append #pdpt2add$ (list (cadr #datatmp))))
					(setq #pdpttmp$ (append #pdpttmp$ (list #datatmp)))
				)
			)
			(setq #pdpt$ #pdpttmp$)
			(setq #pdpt2$ (append #pdpt2$ (list (list (car #data) #pdpt2add$))))
		)
		
		; ���ʐ}�`��XZ���W�����ւ���
		(foreach #data #pdpt2$
			(if (>= (caar #data) 10)
				(setq #data (list (car #data)
						(mapcar '(lambda (#pt)
								(list (caddr #pt) (cadr #pt) (car #pt))
							)
							(cadr #data)
						)
					)
				)
			)
			; �eX���W�ɑ��݂���_�������łȂ��ƃ_���ȍ��Ȃ̂ŁA�����f�[�^��2���p���Đ������\�[�g�o����悤�ɂ���B
			(setq #pt$$ (SCFCmnXYSortByX (append (cadr #data) (cadr #data))))
			; ����_��2������̂ŁA1���Ȃ��Ă��B
			; ���łɑ��ʐ}�`��XZ���W�����ɖ߂�
			(setq #pt$$ 
				(mapcar '(lambda (#pt$ / #ret$)
						(setq #ret$ nil)
						(while (setq #pt (car #pt$))
							(setq #ret$ (append #ret$ 
								(list (if (< (caar #data) 10) #pt (list (caddr #pt) (cadr #pt) (car #pt))))
							))
							(setq #pt$ (cddr #pt$))
						)
						#ret$
					)
					#pt$$
				)
			)
			(foreach #pt$ #pt$$
				(setq #pdpt3add$ nil)
				(while (setq #pt (car #pt$))
					(setq #pdpt3add$ (append #pdpt3add$ (list #pt)))
					(while (and (equal (car #pt) (caar #pt$) 0.1) (equal (cadr #pt) (cadar #pt$) 0.1))
						(setq #pt$ (cdr #pt$))
					)
				)
				(cond
					; ���ʐ}
					((< (caar #data) 10)
						(setq #pdpt3f$ (append #pdpt3f$ (list (list (car #data) (caar #pdpt3add$) #pdpt3add$))))
					)
					; ��䑤��
					((= (caar #data) 10)
						(setq #pdpt3u$ (append #pdpt3u$ (list (list (car #data) (caar #pdpt3add$) #pdpt3add$))))
					)
					; �����W�t�[�h
					((= (caar #data) 13)
						(setq #pdpt3r$ (append #pdpt3r$ (list (list (car #data) (caar #pdpt3add$) #pdpt3add$))))
					)
					; ���̑�(����A����)
					(T
						(setq #pdpt3s$ (append #pdpt3s$ (list (list (car #data) (caar #pdpt3add$) #pdpt3add$))))
					)
				)
			)
		)
	)
	; ���ʂ̓����W�t�[�h�D��
	(if #pdpt3r$
		(foreach #pdpt3u #pdpt3u$
			(setq #flg T)
			(foreach #pdpt3r #pdpt3r$
				(if (and 
							(= (cadar #pdpt3r) (cadar #pdpt3u))
							(equal (cadr #pdpt3r) (cadr #pdpt3u) 0.1))
					(setq #flg nil)
				)
			)
			(if #flg
				(setq #pdpt3s$ (append #pdpt3s$ (list #pdpt3u)))
			)
		)
		(setq #pdpt3s$ (append #pdpt3s$ #pdpt3u$))
	)
	(setq #pdpt3s$ (append #pdpt3s$ #pdpt3r$))
	; ���ʂ܂Ƃ�
	(setq #pdpt3tmp$ nil)
	(while (setq #pdpt3s (car #pdpt3s$))
		(setq #pdpt3tmp$ (append #pdpt3tmp$ (list #pdpt3s)))
		(setq #pdpt3s$ (cdr #pdpt3s$))
		(setq #pdpt3stmp$ nil)
		(while (setq #pdpt3stmp (car #pdpt3s$))
			(setq #pdpt3s$ (cdr #pdpt3s$))
			(setq #flg T)
			(if (and (= (cadar #pdpt3s) (cadar #pdpt3stmp)) (= (length (caddr #pdpt3s)) (length (caddr #pdpt3stmp))))
				(progn
					(setq #i 0)
					(while 
						(and 
							(< #i (length (caddr #pdpt3s))) 
							(equal (car (nth #i (caddr #pdpt3s))) (car (nth #i (caddr #pdpt3stmp))) 0.1)
							(equal (cadr (nth #i (caddr #pdpt3s))) (cadr (nth #i (caddr #pdpt3stmp))) 0.1)
						)
						(setq #i (1+ #i))
					)
					(if (= #i (length (caddr #pdpt3s)))
						(setq #flg nil)
					)
				)
			)
			(if #flg
				(setq #pdpt3stmp$ (append #pdpt3stmp$ (list #pdpt3stmp)))
			)
		)
		(setq #pdpt3s$ #pdpt3stmp$)
	)
	(setq #pdpt3s$ #pdpt3tmp$)
	
	; Y���S�ē������@���܂Ƃ߁AX���W�̕��ς����B
	; ���ʑ��ɐ��@�̔�����D�悳���邽�߁A���ς����߂鎞�ɏd�݂�3�{�ɂ��Ă���B
	(setq #pdpt4$ nil)
	(setq #pdpt3$ (append #pdpt3f$ #pdpt3s$))
	(while (setq #pdpt3 (car #pdpt3$))
		(setq #xx (* (cadr #pdpt3) (if (< (caar #pdpt3) 10) 1 3)))
		(setq #j (if (< (caar #pdpt3) 10) 1 3))
		(setq #pdpt3$ (cdr #pdpt3$))
		(setq #pdpt3tmp$ nil)
		(while (setq #pdpt3tmp (car #pdpt3$))
			(setq #pdpt3$ (cdr #pdpt3$))
			(setq #flg nil)
			(if (and (= (cadar #pdpt3) (cadar #pdpt3tmp)) (= (length (caddr #pdpt3)) (length (caddr #pdpt3tmp))))
				(progn
					(setq #i 0)
					(while 
						(and 
							(< #i (length (caddr #pdpt3))) 
							(equal (cadr (nth #i (caddr #pdpt3))) (cadr (nth #i (caddr #pdpt3tmp))) 0.1)
						)
						(setq #i (1+ #i))
					)
					(if (= #i (length (caddr #pdpt3)))
						(setq #flg T)
					)
				)
			)
			(if #flg
				(progn
					(setq #xx (+ #xx (* (cadr #pdpt3tmp) (if (< (caar #pdpt3tmp) 10) 1 3))))
					(setq #j (+ #j (if (< (caar #pdpt3tmp) 10) 1 3)))
				)
				(setq #pdpt3tmp$ (append #pdpt3tmp$ (list #pdpt3tmp)))
			)
		)
		(setq #pdpt3$ #pdpt3tmp$)
		(setq #pdpt4$ (append #pdpt4$ (list (list (car #pdpt3) (/ #xx #j) (caddr #pdpt3)))))
	)

	(setq #pdpt4L$ nil #pdpt4R$ nil)
	(foreach #pdpt4 #pdpt4$
		(defun ##SortMinPdpt4 ( &Pdpt4 &Pdpt4$ / )
			(if (or (not &Pdpt4$) (< (cadr (caaddr #pdpt4)) (cadr (caaddr (car &Pdpt4$)))))
				(append (list #pdpt4) &Pdpt4$)
				(append (list (car &Pdpt4$)) (##SortMinPdpt4 #pdpt4 (cdr &Pdpt4$)))
			)
		)
		(if (< (abs (- #minx (cadr #pdpt4))) (abs (- #maxx (cadr #pdpt4))))
			(setq #pdpt4L$ (##SortMinPdpt4 #pdpt4 #pdpt4L$))
			(setq #pdpt4R$ (##SortMinPdpt4 #pdpt4 #pdpt4R$))
		)
	)
	(foreach #pdpt4 #pdpt4L$
		(setq #iti (KCFDrawDimDoubuti3Exec (list #minx #y 0.0) CG_CeilHeight (caddr #pdpt4) &flg (nth 2 #iti$) PI (cadar #pdpt4)))
		(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) #iti (nth 3 #iti$)))
	)
	(foreach #pdpt4 #pdpt4R$
		(setq #iti (KCFDrawDimDoubuti3Exec (list #maxx #y 0.0) CG_CeilHeight (caddr #pdpt4) &flg (nth 3 #iti$) 0.0 (cadar #pdpt4)))
		(setq #iti$ (list (nth 0 #iti$) (nth 1 #iti$) (nth 2 #iti$) #iti))
	)
	
	
	#iti$
) ; SCFDrawDimDoubuti3


;;;<HOM>************************************************************************
;;; <�֐���>  : SCFDrawDimSekou
;;; <�����T�v>: �{�H���@����}����
;;; <�߂�l>  : �ʒu���X�g�i�� �� �� �E�j
;;; <�쐬>    : 1998-07-07
;;; <���l>    : 00/05/09 HN MOD �{�H���@�Ɏ{�H���ǉ��\��
;;;************************************************************************>MOH<
(defun SCFDrawDimSekou (
	&attr$     ; (LIST) �����ƍ��W���X�g
	&appa$     ; (LIST) �A�b�p�[�L���r�l�b�g���W���X�g
	&base$     ; (LIST) �x�[�X�L���r�l�b�g���W���X�g
	&off       ; (REAL) �w�萡�@���@���⏕������
	&bpt$      ; (LIST) ��_���X�g�i�A�b�p�[ �x�[�X�j
	/
	#appa$ #ap$ #ajp$ #i #pt1 #pt2 #iti #aiti$ #base$ #bp$
	#bjp$ #biti$ #iti$ #aiti #biti
	)

	; �A�b�p�[�^�x�[�X�̈�̂S�_���W�擾
	(if &appa$
		(setq #appa$
			(list
				(car &appa$)
				(list (car (cadr &appa$))(cadr (car &appa$)))
				(cadr &appa$)
				(list (car (car &appa$))(cadr (cadr &appa$)))
			)
		)
	)
	(if &base$
		(setq #base$
			(list
				(car &base$)
				(list (car (cadr &base$))(cadr (car &base$)))
				(cadr &base$)
				(list (car (car &base$))(cadr (cadr &base$)))
			)
		)
	)

	;//////////////////�A�b�p�[�L���r�l�b�g//////////////////
	; 01/04/05 TM MOD-S �A�b�p�[�L���r�l�b�g�����݂��Ȃ��ꍇ�͖���
	(if &appa$
		(progn
			;�����㉺���E�A�w��ɕ�����
			(setq #ap$ (SCFGetPtenBy4Dire (list #appa$ #base$) &attr$ "A"))
			(setq #ajp$ (car #ap$))
			;���בւ�
			(setq #ajp$ (list (nth 1 #ajp$)(nth 3 #ajp$)(nth 0 #ajp$)(nth 2 #ajp$)))

			;�����̐��@������}
			(setq #i 0)
			(repeat (length #appa$)
				(setq #pt1 (nth #i #appa$))
				(if (/= nil (nth (1+ #i) #appa$))
					(setq #pt2 (nth (1+ #i) #appa$))
					(setq #pt2 (car #appa$))
				)
				(if (/= nil (nth #i #ajp$))
					(progn
						(if (> (car #pt1) (car #pt2))
							(setq #iti (SCFDrawDimByPpt2Pt (list #pt1 #pt2) (nth #i #ajp$) (car  &bpt$)))
							(setq #iti (SCFDrawDimByPpt2Pt (list #pt2 #pt1) (nth #i #ajp$) (car  &bpt$)))
						)
					)
					(setq #iti 0)
				)
				(setq #aiti$ (cons #iti #aiti$))
				(setq #i (1+ #i))
			)
			; 01/04/11 TM MOD �Y���̕����ɒP�Ɛ��@������ꍇ�A���@�L���ʒu�����炷
			(if (= 1 (car (car (cadr #ap$))))
				(setq #aiti$ (list (nth 0 #aiti$) (1+ (nth 1 #aiti$)) (nth 2 #aiti$) (nth 3 #aiti$)))
			)

			;�P�Ɛ��@��}
			(SCFDrawDimTandoku #appa$ (cadr #ap$) &off "U")
		)
		(progn
			(setq #aiti$ '(0 0 0 0))
		)
	)
	; 01/04/05 TM MOD-E �A�b�p�[�L���r�l�b�g�����݂��Ȃ��ꍇ�͖���

	;//////////////////�x�[�X�L���r�l�b�g//////////////////
	; 01/04/05 TM MOD-S �x�[�X�L���r�l�b�g�����݂��Ȃ��ꍇ�͖���
	(if &base$
		(progn
			;�����㉺���E�A�w��ɕ�����
			(setq #bp$ (SCFGetPtenBy4Dire (list #appa$ #base$) &attr$ "B"))
			(setq #bjp$ (car #bp$))
			;���בւ�
			(setq #bjp$ (list (nth 1 #bjp$)(nth 3 #bjp$)(nth 0 #bjp$)(nth 2 #bjp$)))

			;�����̐��@������}
			(setq #i 0)
			(repeat (length #base$)
				(setq #pt1 (nth #i #base$))
				(if (/= nil (nth (1+ #i) #base$))
					(setq #pt2 (nth (1+ #i) #base$))
					(setq #pt2 (car #base$))
				)

				(if (/= nil (nth #i #bjp$))
					(progn
						(if (> (car #pt1) (car #pt2))
							(setq #iti
								(SCFDrawDimByPpt2Pt (list #pt2 #pt1) (nth #i #bjp$) (cadr &bpt$))
							)
							(setq #iti
								(SCFDrawDimByPpt2Pt (list #pt1 #pt2) (nth #i #bjp$) (cadr &bpt$))
							)
						)
					)
					(setq #iti 0)
				)
				(setq #biti$ (cons #iti #biti$))
				(setq #i (1+ #i))
			)
			; 01/04/11 TM MOD �Y���̕����ɒP�Ɛ��@������ꍇ�A���@�L���ʒu�����炷
			(if (= 2 (car (car (cadr #ap$))))
				(setq #biti$ (list (nth 0 #biti$) (nth 1 #biti$) (1+ (nth 2 #biti$)) (nth 3 #biti$)))
			)
			;�P�Ɛ��@��}
			(SCFDrawDimTandoku #base$ (cadr #bp$) &off "B")
		)
		(progn
			(setq #biti$ '(0))
		)
	)
	; 01/04/05 TM MOD-E �x�[�X�L���r�l�b�g�����݂��Ȃ��ꍇ�͖���

	;���@�ʒu�l��
	(setq #iti$ (mapcar '(lambda ( #aiti #biti ) (max #aiti #biti)) #aiti$ #biti$))
	;���בւ�
	(setq #iti$ (list (nth 1 #iti$)(nth 3 #iti$)(nth 0 #iti$)(nth 2 #iti$)))

	#iti$
) ; SCFDrawDimSekou

; 01/04/11 TM-MOD-E �O�ɏo���Ė��̕ύX
;<HOM>************************************************************************
;
; <�֐���>    : KCFIsInArea
;
; <�����T�v>  : ���݂̗̈�ɑ��݂��邩
;
; <�߂�l>    : T=����, nil=���Ȃ�
;
; <���l>      : �`�F�b�N���Ă���͍̂����̂�
;************************************************************************>MOH<
; �̈�O �̓_���l������悤�ɕύX�֐��쐬 00/10/31 HT START
(defun KCFIsInArea (
	&dPt		; �ΏۂƂȂ�_
	&dArea$		; �x�[�X���S�_���W
	&sUorB		; �A�b�p�[="A" �x�[�X="B"
	/
	#Ret			; �߂�l
	#rBorder	; ���W���E�l
	)

	; 01/04/12 TM ADD �V�䍂���^�Q�ŋ�ʂ���悤�ɕύX
	(setq #rBorder (+ (/ CG_CeilHeight 2.0) (apply 'min (mapcar 'cadr &dArea$))))

	(if (= &sUorB "A")
		(progn
; 01/04/12 TM DEL �V�䍂���^�Q�ŋ�ʂ���悤�ɕύX
;			; �A�b�p�[�L���r�̈�ԉ�������̏ꍇ�̓A�b�p�[
;			(setq #rBorder (apply 'min (mapcar 'cadr &dArea$)))
;			(if (>= (cadr (cadr &dPt)) #rBorder)
			(if (> (cadr (cadr &dPt)) #rBorder)
				(setq #Ret T)
			)
		)
		(progn
; 01/04/12 TM DEL �V�䍂���^�Q�ŋ�ʂ���悤�ɕύX
;			; �x�[�X�L���r�̈�ԏ�������̏ꍇ�̓x�[�X
;			(setq #rBorder (apply 'max (mapcar 'cadr &dArea$)))
			(if (<= (cadr (cadr &dPt)) #rBorder)
				(setq #Ret T)
			)
		)
	)

	#Ret
)
; �̈�O �̓_���l������悤�ɕύX 00/10/31 HT END
; 01/04/11 TM-MOD-E �O�ɏo���Ė��̕ύX

;<HOM>************************************************************************
;
; <�֐���>    : SCFGetPtenBy4Dire
;
; <�����T�v>  : �L���r�l�b�g�S�_���W���X�g����o�_��������Ƃɕ�����
;
; <�߂�l>    : �o�_���X�g
;               �i�i�� �� �� �E�j�P�Ɓj
; <���l>      : �A�b�p�[�L���r�l�b�g�� �� ��
;               �x�[�X�L���r�l�b�g��   �� ���ȗ�����
;************************************************************************>MOH<
(defun SCFGetPtenBy4Dire (
	&pt$    ; (LIST) �S�_���W���X�g ((�A�b�p�[) (�x�[�X))
	&p$     ; (LIST) �o�_�̑����ƍ��W�̃��X�g
	&flg    ; (STR)  �L���r�l�b�g�t���O�i"A"=�A�b�p�[ "B"=�x�[�X�j
	/
	#flg #p$ #min #zoku1 #i #pt1 #pt2 #pp #dis #cond #dn$ #rt$ #up$ #lt$ #tandoku$
	#isIn	; �Y���̈�ɂ��邩
	#pt$	; ���݂̂S�_���W
	)

; 01/04/11 TM MOD-S ������ύX����ƂƂ��ɊO�ɏo����
; KCFIsInArea �Q��
;  ; �̈�O �̓_���l������悤�ɕύX�֐��쐬 00/10/31 HT START
;  ; �A�b�p�[�̈����=�A�b�p�[
;  ; �x�[�X�̈��艺=�x�[�X
;	(defun ##IsUpperArea (
;		&Ppt		; �ΏۂƂȂ�_
;		&up$		; �̈�̂S�_
;		/
;  )
;  ; �̈�O �̓_���l������悤�ɕύX 00/10/31 HT END
; 01/04/11 TM MOD-E ������ύX����ƂƂ��ɊO�ɏo����

	; �����ݒ�
	(if (= "A" &flg)
		(progn
			(setq #flg 0)
			(setq #pt$ (car &pt$))
		)
		(progn
			(setq #flg 2)
			(setq #pt$ (cadr &pt$))
		)
	)

	(foreach #p$ &p$
		(setq #min nil)
		(setq #zoku1 (car  (car #p$)))

		;; ���O����֐��ύX
		; if (IsPtInPolygon (cadr #p$) &pt$)
		; �̈�O �̓_���l������悤�ɕύX 00/10/31 HT
		; �A�b�p�[�̈����=�A�b�p�[
		; �x�[�X�̈��艺=�x�[�X
		;if (##IsUpperArea #p$ (car &pt$) (cadr &pt$))
		; �w�肳�ꂽ�̈���Ɏ��܂��Ă��邩
		(if (KCFIsInArea #p$ (cadr &pt$) &flg)
			(progn
				(cond
					((= 0 #zoku1)                  ;����
						(setq #i 0)
						(repeat (length #pt$)
							(setq #pt1 (nth #i #pt$))
							(if (/= nil (nth (1+ #i) #pt$))
								(setq #pt2 (nth (1+ #i) #pt$))
								(setq #pt2 (car #pt$))
							)
							(if (/= #i #flg)
								(progn
									(setq #pp (cadr #p$))
									(setq #dis (SCFGetPerDist #pp #pt1 #pt2))
									(if (or (= nil #min) (> #min #dis))
										(setq #min #dis #cond #i)
									)
								)
							)
							(setq #i (1+ #i))
						)
						(if (= &flg "A") (setq #cond 2))
						(if (= &flg "B") (setq #cond 0));00/12/27 SN ADD
						(cond
							((= 0 #cond) (setq #dn$ (cons #p$ #dn$)))
							((= 1 #cond) (setq #rt$ (cons #p$ #rt$)))
							((= 2 #cond) (setq #up$ (cons #p$ #up$)))
							((= 3 #cond) (setq #lt$ (cons #p$ #lt$)))
							(T                                   nil)
						)
					)
					((or (= 1 #zoku1) (= 2 #zoku1) (= 3 #zoku1) (= 4 #zoku1))
						(setq #tandoku$ (cons #p$ #tandoku$))
					)
					(T
						nil
					)
				)
			)
		)
	)

	(list (list #up$ #dn$ #lt$ #rt$) #tandoku$)
) ;SCFGetPtenBy4Dire

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFDrawDimLinAddStr
;;; <�����T�v>: �Q�_�̍��W�Ƃo�_���X�g���琡�@������}���A�������ǉ�����
;;; <�߂�l>  : ���@���ʒu
;;; <���l>    : 00/05/18 HN �{�H���@�Ɏ{�H����ǉ�
;;; 				  : 01/02/15 TM �֐����ɂ���̂��O�ɏo����
;;;************************************************************************>MOH<
(defun SCFDrawDimLinAddStr (
	&pt$    ; (LIST) ���@�ʒu���W���X�g
	&bpt    ; (LIST) ��_���W      �inil�̂Ƃ�&pt$�̒l�����̂܂܎g�p�j
	&dpt    ; (LIST) ���@�ʒu���W
	&flg    ; (STR)  ���@�����t���O�i����:"H" ����:"V"�j
	&iDimID ; ���@����ID
	/
	#bRet   ; ���@�}�`�쐬�t���O
	#eEn    ; ���@�}�`��
	#xPt$		; ���@�`��_
	)
;	(princ "\n&pt$") (princ &pt$)
;	(princ "\n&bpt") (princ &bpt)
;	(princ "\n&dpt") (princ &dpt)
;	(princ "\n&flg") (princ &flg)
;	(princ "\n&iDimID") (princ &iDimID)
	
	(if (setq #bRet (SCFDrawDimLin &pt$ &bpt &dpt &flg))
		(progn
			; 01/03/04 �������@�̏ꍇ�̂ݕ������ǉ�����
			;if (< 0 &iDimID)
			(if (< 0 &iDimID)
;			(if (and (< 0 &iDimID) (eq &flg "H"))
				(progn
					(setq #eEn (entlast))               ; ���@�}�`
;	01/03/08 TM MOD
;					(SCFUpdDimStr #eEn &iDimID)
					(if (SCFUpdDimStr #eEn &iDimID)
						; ���@���������_���Ɋ񂹂�
						(SCFUpdDimStrPlacement #eEn (nth 0 &pt$) "L" '(0.0 0.0 0.0) (eq &flg "H"))
					)

				)
			)
		)
		(progn
			(if (< 0 &iDimID)
				(progn
					(princ "\n �{�H���t�����@�̐}�`���쐬����܂���ł����B") 
				)
			)
		)
	)
	#bRet
)

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFDrawDimPptTanRen
;;; <�����T�v>: �o�_���X�g���琡�@��P�ƂƘA���ɕ�����
;;; <�߂�l>  : (�P�Ɠ_���X�g �A���_���X�g)
;;; <���l>    : 01/02/28 TM
;;;************************************************************************>MOH<
(defun SCFDrawDimPptTanRen (
	&p$		; �o�_���X�g
	/
	#p$		; �o�_�f�[�^����ϐ� 
	#tan$	; �P�Ɛ��@�f�[�^
	#ren$	; �A�����@�f�[�^
	)

	; �o�_���ƂɒP�Ɛ��@�ƘA�����@�ɕ�����
	(mapcar
	 '(lambda ( #p$ )
			(cond
				; ������2�Ԗڂ̍��ڂ� 0 ���A�ŏ���0��2�Ԗڂ���  01/02/23 TM
				((or
					(= 0 (cadr (car #p$)))
					(and (< 0 (cadr (car #p$))) (= 0 (car (car #p$))))
				 )
					(setq #tan$ (cons #p$ #tan$))   ;�P�Ɛ��@
				)
				; ������2�Ԗڂ̍��ڂ�1  01/02/23 TM
				((= 1 (cadr (car #p$)))
					(setq #ren$ (cons #p$ #ren$))   ;�A�����@
				)
				(T
					nil
				)
			)
		)
		&p$
	)
	(list #tan$ #ren$)

) ;_defun SCFDrawDimPptTanRen


;;;<HOM>************************************************************************
;;; <�֐���>  : SCFDrawLineSortPzAttr
;;; <�����T�v>: X���W���Ƀ\�[�g����
;;; <�߂�l>  : (((x y z) (x y z) �E�E�E) (���� �����E�E�E))
;;; <���l>    : 
;;;************************************************************************>MOH<
(defun SCFDrawLineSortPzAttr (
	&tan$		; �P�Ɛ��@���X�g  ((���� x y z) ...
	/
	#t$			; ((x y z) (x y z) �E�E�E)
	#tmp$		; ���@���X�g�ꎞ�ϐ�
	#tmp2$	; P�_ �{�H���@�ʒu ����2 (0 115 �E�E�E)
	#dPt		; �}�[�W�����p
	#dPtW		; �}�[�W�����p
	)
	(setq #tmp$ '())
	; �����ƍ��W���\�[�g�֐��̌`���ɍ��킹�ĂЂ�����Ԃ�
	(mapcar '(lambda (#x)
		(setq #tmp$ (append #tmp$ (list (append (cadr #x) (list (car #x))))))
		)
		&tan$
	)
	(setq #tmp$ (SCFmg_sort$ 'car #tmp$))

	; 01/02/06 HN S-ADD X���W�ł̃}�[�W������ǉ�
	(setq #dPtW  nil)
	(setq #tmp2$ nil)
	(foreach #dPt #tmp$
		; 01/04/05 TM MOD-S ���@���W�̃}�[�W������ύX�i�ʒu������ł��������قȂ�ꍇ�͕ʂɂ���j
		;if (not (equal (car  #dPtW) (car  #dPt)))
;;;		(if (not (equal (car  #dPtW) (car  #dPt))) ; 03/07/14 YM MOD
		(if (not (equal (car  #dPtW) (car  #dPt) 0.01) ) ; 03/07/14 YM MOD
			(progn
				(setq #tmp2$ (cons #dPt #tmp2$))
			)
			(progn
;;;				(if (not (equal (SCFGetDimStr  (cadr (last #dPtW))) (SCFGetDimStr (cadr (last  #dPt))))) ; 03/07/14 YM MOD
				(if (not (equal (SCFGetDimStr  (cadr (last #dPtW))) (SCFGetDimStr (cadr (last  #dPt))) 0.01) ) ; 03/07/14 YM MOD
					(setq #tmp2$ (cons #dPt #tmp2$))
				)
			)
		)
		; 01/04/05 TM MOD-E ���@���W�̃}�[�W������ύX�i�ʒu������ł��������قȂ�ꍇ�͕ʂɂ���j
		(setq #dPtW #dPt)
	)
	(setq #tmp$ (reverse #tmp2$))
	; (princ "\n#tmp$: ")(princ #tmp$)
	; (getstring "\n##SortPzAttr() Enter Key !!")
	; 01/02/06 HN E-ADD X���W�ł̃}�[�W������ǉ�

	(setq #tmp2$ '() #t$ '())
	(mapcar '(lambda (#x)
		(setq #tmp2$ (append #tmp2$ (list (cadr (nth 3 #x)))))
		(setq #t$ (append #t$ (list (list (nth 0 #x) (nth 1 #x) (nth 2 #x)))))
		)
		#tmp$
	)
	(list #t$ #tmp2$)

) ;defun SCFDrawLineSortPzAttr

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFDrawDimByPpt2Pt
;;; <�����T�v>: �Q�_�̍��W�Ƃo�_���X�g���琡�@������}����
;;; <�߂�l>  : ���@���ʒu
;;; <���l>    : 00/05/18 HN �{�H���@�Ɏ{�H����ǉ�
;;;************************************************************************>MOH<
(defun SCFDrawDimByPpt2Pt (
	&pt$    ; (LIST) �Q�_���W
	&p$     ; (LIST) �o�_�̑����ƍ��W���X�g
	&basePt ; (LIST) ��_
	/
	#ang 		; ���@���̂Ȃ��p�x
	#dang 	; ���@���̖@���̊p�x
	#ty 
	#bpt$ 
	#iti1 
	#iti2 
	#p$ 
	#tan$ 
	#tan
	#ren$ 
	#p 
	#pt$ 
	#dpt 
	#dis 
	#flg 
	#iDimID		; P�}�`ID
	#eDim
	#sSQL			; ���@��������擾����SQL
	#qry$			; �N�G���[
	#sDimStr	; ���@������
	#ed
	#ret
	#Attr$
	#basept		; 01/02/27 TM ADD ���؂�p��_
	#ret$			; ����ϐ� 01/02/28 TM 
	)

; 01/02/28 TM DEL-S �֐����O�ɏo����  SCFDrawLineAddStr ���Q��
;	 (SCFDrawDimLin)��A�������ǉ�����
;  (defun ##DrawDimLin (
;  ) ;defun ##DrawDimLin
	;-----------------------------------------------------------------
; 01/02/28 TM DEL-E �֐����O�ɏo����

; 01/02/28 TM DEL-S �֐����O�ɏo����  SCFDrawLineSortPzAttr ���Q��
;	(defun ##SortPzAttr (
;  ) ;defun ##SortPzAttr
	;-----------------------------------------------------------------
; 01/02/28 TM DEL-E �֐����O�ɏo����  SCFDrawLineSortPzAttr ���Q��

	; �����ݒ�
	(setq #ang  (angle (car &pt$) (cadr &pt$)))			; �p�x
	(setq #dang (- #ang (* 0.5 PI)))								; ���@�p�x
	; �\�[�g�����A�����������p�x����v�Z����
	(if (or (equal 0.0 #ang 0.01) (equal PI #ang 0.01))
		(setq #ty "X" #bpt$ (SCFmg_sort$ 'car  &pt$))
		(setq #ty "Y" #bpt$ (SCFmg_sort$ 'cadr &pt$))
	)
	(setq #iti1 0)
	(setq #iti2 0)

	; �o�_�f�[�^����A���@��P�Ɛ��@�ƘA�����@�ɕ�����
	(setq #ret$ (SCFDrawDimPptTanRen &p$))
	(setq #tan$ (car #ret$))
	(setq #ren$ (cadr #ret$))

; #tan$ ���펞
;;;(
;;; ((0 14) (10485.0 1845.0 12150.0))
;;; ((0 131) (10415.0 1845.0 12150.0))
;;; ((0 131) (10415.0 1845.0 1850.0))
;;; ((0 131) (10415.0 1845.0 11250.0))
;;; ((0 131) (10415.0 1845.0 1100.0))
;;;) 

	; �����@  TM
	(if (= #ty "X")
		(progn                              ;�� ��
			;�P�Ɛ��@
			(if (/= nil #tan$)
				(progn
					; X���W���Ƀ\�[�g���� 00/10/30 START
;          (setq #ret (##SortPzAttr #tan$)) ; 01/02/28 TM MOD �\�[�g�֐����O�ɏo����
					(setq #ret (SCFDrawLineSortPzAttr #tan$))
					(setq #tan$ (car #ret) ; ���펞 ((10415.0 1845.0 1100.0) (10485.0 1845.0 12150.0))
								#Attr$ (cadr #ret))
					;(setq #tan$ (SCFmg_sort$ 'car  (mapcar 'cadr #tan$)))
					; X���W���Ƀ\�[�g���� 00/10/30 END

					(if (/= nil &basePt)
						; ��_����  TM
						(progn
							; ��_��荶���̏ꍇ�A�������t�ɂ��� TM
							(if (< (car (car #tan$)) (car &basept))
								(progn
									(setq #tan$ (reverse #tan$))
									(setq #Attr$ (reverse #Attr$))
								)
							)
							; ���ׂĂ̐��@�ɂ��Đ�������  TM
							(mapcar
							 '(lambda ( #p #a )
									(setq #pt$ (list &basePt #p))
									(setq #dpt (polar &basePt #dang (GetDimHeight #iti1)))
									; (SCFDrawDimLin #pt$ nil #dpt "H") 00/10/30 HT mod
									;(##DrawDimLin #pt$ nil #dpt "H" #a) 01/02/28 TM �֐����O�ɏo����
									(SCFDrawDimLinAddStr  #pt$ nil #dpt "H" #a)
									(setq #iti1 (1+ #iti1))
								)
								#tan$ #Attr$
							)
						)
						; ��_�Ȃ�  TM
						(progn
							; #dis ��̍��W�̒��_�����X�����̍�  TM
							(setq #dis  (* 0.5 (- (car (cadr #bpt$)) (car (car #bpt$)))))
							; #flg ���_���E���ɐ��@�[�_������ꍇ nil  TM
							(setq #flg T)
							(if (> (- (car (car #tan$)) (car (car #bpt$))) #dis)
								(setq #flg nil)
							)
							; ���_��荶���ɂ�����̂�����
							(while #flg

								; #pt$ ��_�ƒP�Ɛ��@
								(setq #pt$ (list (car #bpt$) (car #tan$)))
								; #dpt ���@�����̊�_
								(setq #dpt (polar (car #bpt$) #dang (GetDimHeight #iti1)))
								;(SCFDrawDimLin #pt$ nil #dpt "H") 00/10/30 HT mod
								;(##DrawDimLin #pt$ nil #dpt "H" (car #Attr$)) 01/02/28 TM �֐����O�ɏo����
								(SCFDrawDimLinAddStr  #pt$ nil #dpt "H" (car #Attr$))

								; �[�_�Ƒ����̃��X�g�̐擪���폜
								(setq #tan$ (cdr #tan$))
								(setq #Attr$ (cdr #Attr$)) ;00/10/30 ADD
								; �[�_���X�g���Ȃ��Ȃ�����I��
								(if (= 0 (length #tan$))
									(setq #flg nil)
									(if (> (- (car (car #tan$)) (car (car #bpt$))) #dis)
										(setq #flg nil)
									)
								)
								(setq #iti1 (1+ #iti1))

							)
							; ���_���E���ɂ�����̂�����
							(mapcar
							 '(lambda ( #tan #a )
									(setq #pt$ (list (cadr #bpt$) #tan))
									(setq #dpt (polar (car #bpt$) #dang (GetDimHeight #iti2)))
									;(SCFDrawDimLin #pt$ nil #dpt "H") 00/10/30 HT mod
									;(##DrawDimLin #pt$ nil #dpt "H" #a) ; 01/02/28 TM �֐����O�ɏo����
									(SCFDrawDimLinAddStr #pt$ nil #dpt "H" #a)
									(setq #iti2 (1+ #iti2))
								)
								(reverse #tan$) (reverse #Attr$) ; 00/10/30 (reverse #tan$)
							)
						)
					)
				)
			)
			
			;�A�����@
			(if (/= nil #ren$)
				(progn
					(setq #ren$ (SCFmg_sort$ 'car  (mapcar 'cadr #ren$)))
					(setq #pt$ (append (list (car  #bpt$)) #ren$ (list (cadr #bpt$))))
					(setq #dpt (polar (car #bpt$) #dang (GetDimHeight (max #iti1 #iti2))))
					(SCFDrawDimLin #pt$ #nil #dpt "H")
					(setq #iti1 (1+ (max #iti1 #iti2)))
				)
			)
		)
		(progn                              ;�� �E
			(if (/= nil #tan$)
				(progn
					;�P�Ɛ��@
					; X���W���Ƀ\�[�g���� 00/10/30 START
					;(setq #ret (##SortPzAttr #tan$)) 01/02/28 TM �֐����O�ɏo����
					(setq #ret (SCFDrawLineSortPzAttr #tan$))
					(setq #tan$ (car #ret)
								#Attr$ (cadr #ret))
					; (setq #tan$ (SCFmg_sort$ 'cadr (mapcar 'cadr #tan$)))
					; X���W���Ƀ\�[�g���� 00/10/30 END
					(setq #dis  (* 0.5 (- (cadr (cadr #bpt$)) (cadr (car #bpt$)))))
					(setq #flg T)
					(if (> (- (cadr (car #tan$)) (cadr (car #bpt$))) #dis)
						(setq #flg nil)
					)
					;��
					(while #flg
						(setq #pt$ (list (car #bpt$) (car #tan$)))
						(setq #basept (list (caar #bpt$) (+ (DimGetHeight #iti1) (caadr #bpt$)) (caaddr #bpt$)))
;            (setq #dpt (polar (car #bpt$) #dang (GetDimHeight #iti1)))
						(setq #dpt (polar (car #bpt$) #dang (GetDimHeight -1)))
						; (SCFDrawDimLin #pt$ nil #dpt "V") 00/10/30 HT mod
;            (##DrawDimLin #pt$ nil #dpt "V" (car #Attr$)) ; 01/02/28 TM �֐����O�ɏo����
						(SCFDrawDimLinAddStr #pt$ #basept #dpt "V" (car #Attr$))
						(setq #tan$ (cdr #tan$))
						(setq #Attr$ (cdr #Attr$)) ;00/10/30 ADD
						(if (= 0 (length #tan$))
							(setq #flg nil)
							(if (> (- (cadr (car #tan$)) (cadr (car #bpt$))) #dis)
								(setq #flg nil)
							)
						)
						(setq #iti1 (1+ #iti1))
					)
					;��
					(mapcar
					 '(lambda ( #tan #a )
							(setq #pt$ (list (cadr #bpt$) #tan))
							(setq #dpt (polar (car #bpt$) #dang (GetDimHeight #iti2)))
							; (SCFDrawDimLin #pt$ nil #dpt "V") 00/10/30 HT mod
							; (##DrawDimLin #pt$ nil #dpt "V" #a) ; 01/02/28 TM �֐����O�ɏo����
;							01/03/04 TM 
;            	(SCFDrawDimLinAddStr #pt$ nil #dpt "V" #a)
							(SCFDrawDimLin #pt$ nil #dpt "V" #a)
							(setq #iti2 (1+ #iti2))
						)
						(reverse #tan$) (reverse #Attr$) ; 00/10/30 HT (reverse #tan$)
					)
				)
			)
			(if (/= nil #ren$)
				(progn
					;�A�����@
					(setq #ren$ (SCFmg_sort$ 'car  (mapcar 'cadr #ren$)))
					(setq #pt$ (append (list (car #bpt$)) #ren$ (list (cadr #bpt$))))
					(setq #dpt (polar (car #bpt$) #dang (GetDimHeight (max #iti1 #iti2))))
					(SCFDrawDimLin #pt$ nil #dpt "V")
					(setq #iti1 (1+ (max #iti1 #iti2)))
				)
			)
		)
	)

	(max #iti1 #iti2)

) ; SCFDrawDimByPpt2Pt


;;;<HOM>************************************************************************
;;; <�֐���>  : SCFDrawDimTandoku
;;; <�����T�v>: �P�Ɛ��@��}
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : 2001/10/18 HN ����&sFlag�ǉ�
;;;             ���E�̏ꍇ�́A�A�b�p�[�͏ォ��A�x�[�X�͉����琡�@���������B
;;;             2001/12/07 HN ���E�㉺�̐��@�⏕���̒�����ύX
;;;             ����&off�͖����Ƃ���
;;;             #rDimOffLenUL= 50.0 ��^��
;;;             #rDimOffLenBR=120.0 ���^�E
;;;************************************************************************>MOH<
(defun SCFDrawDimTandoku
	(
	&pt$        ; (LIST) �̈���W���X�g
	&tanp$      ; (LIST) �P�Ɛ��@���X�g
	&off        ; (REAL) ���@�⏕���̒���
	&sFlag      ; (STR)  "U":�A�b�p�[  "B":�x�[�X
	/
	#disx #disy #p$ #zoku$ #pten #pt$ #dpt #flg1 #flg2
	#rOffUL ; ��^��  01/12/07 HN ADD
	#rOffBR ; ���^�E  01/12/07 HN ADD
	)
	(setq #rOffUL  50.0)  ; 01/12/07 HN ADD
	(setq #rOffBR 120.0)  ; 01/12/07 HN ADD

	; ��_�Ԃ̋���
	(setq #disx (distance (nth 0 &pt$) (nth 1 &pt$)))
	(setq #disy (distance (nth 1 &pt$) (nth 2 &pt$)))
	(mapcar
	 '(lambda ( #p$ )
			(setq #zoku$ (car  #p$))    ;�������X�g
			(setq #pten  (cadr #p$))    ;���W
			;���@�����W�擾
			(cond
				((and (= 1 (car #zoku$)) (<= 0 (cadr #zoku$)))     ;�� �P�� (and (= 1 (car #zoku$))(= 0 (cadr #zoku$)))
					(if (< (- (car #pten) (car (nth 0 &pt$))) (* 0.5 #disx))
						(setq #pt$ (list (list (car (nth 1 &pt$)) (cadr #pten)) #pten)) ;��
						(setq #pt$ (list (list (car (nth 0 &pt$)) (cadr #pten)) #pten)) ;�E
					)
				 	; 01/12/07 HN MOD ���E�㉺�̐��@�⏕���̒�����ύX
					;@MOD@(setq #dpt (list (car #pten) (+ (cadr #pten) &off)))
					(setq #dpt (list (car #pten) (+ (cadr #pten) #rOffUL)))
					(setq #flg1 nil)
					(setq #flg2 "H")
				)
				((and (= 2 (car #zoku$))(<= 0 (cadr #zoku$)))     ;�� �P�� (and (= 2 (car #zoku$))(= 0 (cadr #zoku$)))
					(if (< (- (car #pten) (car (nth 0 &pt$))) (* 0.5 #disx))
						(setq #pt$ (list (list (car (nth 1 &pt$)) (cadr #pten)) #pten)) ;�� 01/07/12 HN MOD "0" �� "1"
						(setq #pt$ (list (list (car (nth 0 &pt$)) (cadr #pten)) #pten)) ;�E 01/07/12 HN MOD "1" �� "0"
					)
				 	; 01/12/07 HN MOD ���E�㉺�̐��@�⏕���̒�����ύX
					;@MOD@(setq #dpt (list (car #pten) (- (cadr #pten) &off)))
					(setq #dpt (list (car #pten) (- (cadr #pten) #rOffBR)))
					(setq #flg1 nil)
					(setq #flg2 "H")
				)
				((and (= 3 (car #zoku$))(<= 0 (cadr #zoku$)))     ;�� �P�� (and (= 3 (car #zoku$))(= 0 (cadr #zoku$)))
					; 01/10/18 HN S-MOD �A�b�p�[�^�x�[�X�Ő��@�ʒu��ύX
					;@MOD@; 01/07/12 HN DEL ������݂̂Ƃ���
					;@MOD@;@DEL@(if (< (- (cadr #pten)(cadr (nth 0 &pt$))) (* 0.5 #disy))
					;@MOD@  (setq #pt$ (list (list (car #pten) (cadr (nth 0 &pt$))) #pten)) ;��
					;@MOD@;@DEL@  (setq #pt$ (list (list (car #pten) (cadr (nth 2 &pt$))) #pten)) ;��
					;@MOD@;@DEL@)
					(if (= "U" &sFlag)
						(setq #pt$ (list (list (car #pten) (cadr (nth 2 &pt$))) #pten)) ; �A�b�p�[�͏�
						(setq #pt$ (list (list (car #pten) (cadr (nth 0 &pt$))) #pten)) ; �x�[�X  �͉�
					)
					; 01/10/18 HN E-MOD �A�b�p�[�^�x�[�X�Ő��@�ʒu��ύX
				 	; 01/12/07 HN MOD ���E�㉺�̐��@�⏕���̒�����ύX
					;@MOD@(setq #dpt (list (- (car #pten) &off) (cadr #pten)))  ; 01/07/12 HN MOD "+" �� "-"
					(setq #dpt (list (- (car #pten) #rOffUL) (cadr #pten)))
					(setq #flg1 nil)
					(setq #flg2 "V")
				)
				((and (= 4 (car #zoku$))(<= 0 (cadr #zoku$)))     ;�E �P�� (and (= 4 (car #zoku$))(= 0 (cadr #zoku$)))
					; 01/10/18 HN S-MOD �A�b�p�[�^�x�[�X�Ő��@�ʒu��ύX
					; 01/07/12 HN DEL ������݂̂Ƃ���
					;@DEL@(if (< (- (cadr #pten) (cadr (nth 0 &pt$))) (* 0.5 #disy))
						(setq #pt$ (list (list (car #pten) (cadr (nth 0 &pt$))) #pten)) ;��
					;@DEL@  (setq #pt$ (list (list (car #pten) (cadr (nth 2 &pt$))) #pten)) ;��
					;@DEL@)
					(if (= "U" &sFlag)
						(setq #pt$ (list (list (car #pten) (cadr (nth 2 &pt$))) #pten)) ; �A�b�p�[�͏�
						(setq #pt$ (list (list (car #pten) (cadr (nth 0 &pt$))) #pten)) ; �x�[�X  �͉�
					)
					; 01/10/18 HN E-MOD �A�b�p�[�^�x�[�X�Ő��@�ʒu��ύX
				 	; 01/12/07 HN MOD ���E�㉺�̐��@�⏕���̒�����ύX
					;@MOD@(setq #dpt (list (+ (car #pten) &off) (cadr #pten)))  ; 01/07/12 HN MOD "-" �� "+"
					(setq #dpt (list (+ (car #pten) #rOffBR) (cadr #pten)))
					(setq #flg1 nil)
					(setq #flg2 "V")
				)
				; 00/05/18 HN MOD �A���^�C�v�̔���ύX 1 �� -1
				((and (= 1 (car #zoku$))(= -1 (cadr #zoku$)))     ;�� �A��
					(setq #pt$ (list (nth 0 &pt$) #pten (nth 1 &pt$)))
				 	; 01/12/07 HN MOD ���E�㉺�̐��@�⏕���̒�����ύX
					;@MOD@(setq #dpt (list (car #pten) (+ (cadr #pten) &off)))
					(setq #dpt (list (car #pten) (+ (cadr #pten) #OffUL)))
					(setq #flg1 #pten)
					(setq #flg2 "H")
				)
				; 00/05/18 HN MOD �A���^�C�v�̔���ύX 1 �� -1
				((and (= 2 (car #zoku$))(= -1 (cadr #zoku$)))     ;�� �A��
					(setq #pt$ (list (nth 0 &pt$) #pten (nth 1 &pt$)))
				 	; 01/12/07 HN MOD ���E�㉺�̐��@�⏕���̒�����ύX
					;@MOD@(setq #dpt (list (car #pten) (- (cadr #pten) &off)))
					(setq #dpt (list (car #pten) (- (cadr #pten) #rOffBR)))
					(setq #flg1 #pten)
					(setq #flg2 "H")
				)
				; 00/05/18 HN MOD �A���^�C�v�̔���ύX 1 �� -1
				((and (= 3 (car #zoku$))(= -1 (cadr #zoku$)))     ;�� �A��
					(setq #pt$ (list (nth 0 &pt$) #pten (nth 2 &pt$)))
				 	; 01/12/07 HN MOD ���E�㉺�̐��@�⏕���̒�����ύX
					;@MOD@(setq #dpt (list (- (car #pten) &off) (cadr #pten)))
					(setq #dpt (list (- (car #pten) #rOffUL) (cadr #pten)))
					(setq #flg1 #pten)
					(setq #flg2 "V")
				)
				; 00/05/18 HN MOD �A���^�C�v�̔���ύX 1 �� -1
				((and (= 4 (car #zoku$))(= -1 (cadr #zoku$)))     ;�E �A��
					(setq #pt$ (list (nth 0 &pt$) #pten (nth 2 &pt$)))
				 	; 01/12/07 HN MOD ���E�㉺�̐��@�⏕���̒�����ύX
					;@MOD@(setq #dpt (list (+ (car #pten) &off) (cadr #pten)))
					(setq #dpt (list (+ (car #pten) #rOffBR) (cadr #pten)))
					(setq #flg1 #pten)
					(setq #flg2 "V")
				)
			)
			;���@����}
;@@@(princ "\n#pt$: " )(princ #pt$ )
;@@@(princ "\n#flg1: ")(princ #flg1)
;@@@(princ "\n#dpt: " )(princ #dpt )
;@@@(princ "\n#flg2: ")(princ #flg2)
;@@@(getstring "\ndebug: ")
			(if (SCFDrawDimLin #pt$ #flg1 #dpt #flg2)
				(progn
				; ���@���쐬����������
				; P�_�ʒu�⑮�����������Ȃ��Ƃ��A���@���쐬�ł��Ȃ�
				;@@@(getstring "\nSCFDrawDimLin END: ")

				;00/05/18 HN S-ADD ���@�Ɏ{�H��񕶎���t��
				(setq #iDimID (cadr #zoku$))         ; ���@����ID
				(setq #eDim (entlast))               ; ���@�}�`
				; 01/03/04 TM MOD �������@�̏ꍇ�̂ݕ������ǉ�����
				(if (< 0 #iDimID)
;				(if (and (< 0 #iDimID) (or (= 1 (car #zoku$)) (= 2 (car #zoku$))))
					(progn
						; �{�H���@�������ǉ�
						; 01/05/31 TM MOD �{�H���@�����񂪑��݂��Ȃ��ꍇ���l��
						(if (SCFUpdDimStr #eDim #iDimID)
							; ��_���Ɋ񂹂�
							(SCFUpdDimStrPlacement #eDim #dpt "L" '(0 0 0) (or (= 1 (car #zoku$)) (= 2 (car #zoku$))))
						)
					)
				)
			) ; progn
			(progn
				(setq #iDimID (cadr #zoku$))         ; ���@����ID
				(if (< 0 #iDimID)
					(progn
					(princ "\n �{�H���t�����@�̐}�`���쐬����܂���ł����BP�_���W:") (princ #pten)
					)
				)
			)
			) ; ���@�쐬����
		;00/05/18 HN E-ADD ���@�Ɏ{�H��񕶎���t��
		)
	&tanp$
	)

	(princ)
) ; SCFDrawDimTandoku


;;;<HOM>************************************************************************
;;; <�֐���>  : SCFUpdDimStr
;;; <�����T�v>: ���@������C��
;;; <�߂�l>  : nil=���@������C�����s(�����񂪂Ȃ�)
;;; <���l>    : CG_CDBSession OK 01/04/05 TM ADD
;;;************************************************************************>MOH<
(defun SCFUpdDimStr (
	&eEn        ; �}�`��
	&iID        ; �}�`ID
;	&xBasePt		; ���@��_ ; 01/04/17 TM DEL �����ł͓������Ȃ��d�l�ɕύX
	/
	#sDimStr    ; ���@������
	)

	; ���@��������擾����
	(setq #sDimStr (SCFGetDimStr &iID))
	; 01/05/31 TM MOD �����񂪂Ȃ��ꍇ���l��
	(cond 
		((or (= nil #sDimStr) (= "" #sDimStr))
			; 01/05/31 TM ADD �{�H���@�����񂪂Ȃ��ꍇ�Ɍx������
			;(princ (strcat "\n�{�H���@�����񂪖��o�^�ł�: ����ID=" (itoa &iID)))

;;;			(CFAlertMsg (strcat "\n�{�H���@�����񂪖��o�^�ł�:����ID=" (itoa &iID)))
 			(WebOutLog (strcat "\n�{�H���@�����񂪖��o�^�ł�:����ID=" (itoa &iID)))
			nil
		)
		(t
			(setq #sDimStr (strcat "<> " #sDimStr))
			(setq #ed$ (entget &eEn))
			(setq #ed$ (subst (cons 1 #sDimStr) (assoc 1 #ed$) #ed$))
			(entmod #ed$)
		)
	);_cond
); SCFUpdDimStr

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetDimStr
;;; <�����T�v>: ���@������擾
;;; <�߂�l>  : ���@������
;;; <���l>    : CG_CDBSession OK
;;;************************************************************************>MOH<
(defun SCFGetDimStr (
	&iID        ; �}�`ID
	/
	#sSQL       ; SQL��
	#qry$       ; �N�G���[
	)

	(if (= &iID 0)
		(progn
			nil	
		)
		(progn
			(setq #sSQL (strcat "select * from ���@���� where ����ID=" (rtois &iID)))
			(setq #qry$ (car (DBSqlAutoQuery CG_CDBSession #sSQL)))
		)
	)

	(cadr #qry$)

)

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFDispDimStr
;;; <�����T�v>: ���@������̍��W�\��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : 01/02/26 TM �V�K�ǉ�  �����ȏꍇ�̂ݗL��
;;;************************************************************************>MOH<
(defun SCFDispDimStr (
	&eEn			; �}�`��
	/
	#ed$				; �}�`�G���e�B�e�B
	#xLtHogPos	; W
	#nn					; ����ϐ�
	)

	; �}�`�G���e�B�e�B�擾
	(setq #ed$ (entget &eEn))

	(foreach #nn '(10 11 12 13 14)

		(princ "\n���@�������W (")
		(princ #nn)
		(princ "): ")
		; ���@������̊���W
		(if (/= nil (assoc #nn #ed$))
			(progn
				(setq #xLtHogPos (assoc #nn #ed$))
				(princ #xLtHogPos)
			)
			; 01/02/23 TM ADD �������Ȃ��ꍇ
			(progn
				(princ "�����Ȃ�")
			)
		)
	)
	(princ)

)

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetStrWidth
;;; <�����T�v>: ���@������̕����v�Z����
;;; <�߂�l>  : ������̕�
;;; <���l>    : 01/02/26 TM �V�K�ǉ�  �����ȏꍇ�̂ݗL��
;;;************************************************************************>MOH<
(defun SCFGetStrWidth (
	&eEn				; ���@�}�`��
	/
	#ed$				; �}�`�G���e�B�e�B
	#etmp$			; ��Ɨp�G���e�B�e�B
	#sDimStr		; 1 ���@������
	#rStrW			; ������
	)

	; �}�`�G���e�B�e�B�擾
	(setq #ed$ (entget &eEn))

	(setq #etmp$ nil)
	; ������{��	   
	(if (/= nil (assoc 1 #ed$))
		(progn 
			(setq #etmp$ (list (assoc 1 #ed$)))
			(setq #etmp$ (cons (cons 0 "TEXT") #etmp$))
			; �����̃f�t�H���g�T�C�Y��������� ZAN  TM 01/02/28
			(setq #etmp$ (cons (cons 40 CG_Dim1CharWidth) #etmp$))
		)
		(progn
			(princ "\n���@�����񂪂Ȃ�")
			nil
		)
	)

	(setq #xDiag (textbox #etmp$))
;	(princ "\n������:")	(princ #xDiag)
	
	(if #xDiag
		(progn
			(setq #rStrW (abs (- (caar #xDiag) (caadr #xDiag))))
;			(princ "\n������:")	(princ #rStrW)
			#rStrW
		)
		0
	)
)

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFCoodToStr
;;; <�����T�v>: ���W���X�g�𕶎���ɕϊ�����
;;; <�߂�l>  : ���W�̃J���}��؂蕶����  "XXXX.XX,YYYY.YY,ZZZZ.ZZ"
;;; <���l>    : 01/02/26 TM �V�K�ǉ�
;;;************************************************************************>MOH<
(defun SCFCoodToStr (
	&cood$			; �R�������W
	/
	#cood_str		; ���W������
	#rr					; ����ϐ�(���W)
	)
	
	(setq #cood_str nil)
	(if (/= 3 (length &cood$))
		(progn
			(princ "\n���W���ُ�: ")
			(princ &cood$)
			nil
		)
	)

	(foreach #rr &cood$
		(if (/= nil #cood_str) 
			(progn 
				(setq #cood_str (strcat #cood_str "," (rtos #rr)))
			)
			(progn
				(setq #cood_str (rtos #rr))
			)
		)
	)
	#cood_str
)

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFGetDimStrCood
;;; <�����T�v>: ���@�������u�����W���v�Z����
;;; <�߂�l>  : ���W
;;; <���l>    : 01/02/26 TM �V�K�ǉ�
;;; 					: �f�t�H���g�ł͍��񂹂���
;;; 					: �����̏ꍇ�����l�����Ă��Ȃ�
;;;************************************************************************>MOH<
(defun SCFDimStrCood (
	&xBase		; ����W
	&xCent		; �����񒆐S
	&xDim			; ���@���W
	&rWidth		; ������̕�
	&xBase0		; ���@�̊�_
	&sLR			; ���E�񂹂̎w�� "R" �E�� ����ȊO�͍���
	/
	#sLR			; ���E�t���O
	#rOffset	; ���炵��
	#xDest		; �߂�l���W
	#xBase0Pt	; ���@��_
	#xBasePt	; �ړ��ΏۂƂȂ��_
	#xDimPt		; �ړ��ΏۂƂȂ鐡�@�_
	)

	(setq #rOffSet 0.0)

	; ���@��_
	(setq #xBase0Pt &xBase0)

	; 01/04/17 TM ADD ���E�w���ǉ�
	(if &sLR
		(setq #sLR &sLR)
		(setq #sLR "L")
	)

	;DEBUG (princ "\n���@�񂹎w��:")
	;DEBUG (princ #sLR)

	; ��_���W�Ƃ̋������߂��ق������_ ....�d�l�P
;	(if (> (distance &xBase &xBase0) (distance &xDim &xBase0))
;		(progn
;			(setq #xBasePt &xBase)
;			(setq #xDimPt &xDim)
;		)
;		(progn
;			(setq #xBasePt &xDim)
;			(setq #xDimPt &xBase)
;		)
;	)

	; 01/04/17 TM MOD X ���W�̑傫��������_�Ƃ��� ... �d�l�Q�i���񂹐�p�j
	(if (< (car &xBase) (car &xDim))
		(progn
			(setq #xBasePt &xDim)
			(setq #xDimPt &xBase)
		)
		(progn
			(setq #xBasePt &xBase)
			(setq #xDimPt &xDim)
		)
	)

	; ��_�Ɛ��@�̍��W�̑召�ŉE�񂹂����񂹂��𔻒肷��
	;(if (< (car #xBasePt) (car #xDimPt))
	;	(setq #sLR "R")
	;	(setq #sLR "L")
	;)

	; �w���W�̃I�t�Z�b�g
	(cond 
		((eq #sLR "R")
			; l<-width------>|
			; 888.8 ���@������
			;      +---------+
			;      |    ^    |
			;      Dim Cent Base
			;
			; dest-x    =  B - w / 2         
			; default-x =  B - (B - D) / 2    = c  -
			; offset    =  (B - D - w) / 2
			(setq #rOffset (/ (- (car #xBasePt) &rWidth (car #xDimPt)) 2)))

		((eq #sLR "L")
		 	; l<----- w ----->|
		 	;  888.8 ���@������
		 	; +---------+
		 	; |    ^    |
		 	; D    C    B
		 	;
		 	; dest-x    =  D + w / 2         
		 	; default-x =  (B + D) / 2    = C  -
		 	; offset    =  (D + w - B) / 2
		 	(setq #rOffset (/ (- (+ (car #xDimPt) &rWidth) (car #xBasePt)) 2))
		)

		(t (princ "\n�ُ�ȍ��E����") (setq #rOffset 0.0))
	)

	; �I�t�Z�b�g�𔽉f
	(if (/= #rOffset 0.0)
		(setq #xDest (polar &xCent 0.0 #rOffset))
		(setq #xDest &xCent)
	)

	#xDest

)

;;;<HOM>************************************************************************
;;; <�֐���>  : SCFUpdDimStrPlacement
;;; <�����T�v>: ���@��������W�C��
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : 01/02/06 TM �V�K�ǉ�
;;;************************************************************************>MOH<
(defun SCFUpdDimStrPlacement (
	&eEn        ; �}�`��
	&xBasePt		; ���@��_
	&sLR				; �E�^���� "R" �E�� ����ȊO�͍�
	&dOffs			; �ړ��I�t�Z�b�g
	&fH			; �����̏ꍇT
	/
	#ed$				; �}�`����
	#nYdir			; 70 ���@�\������
	#rStrW			; ���@������
	#nLtPosTyp	; 72 ���@�����̉�������ʒu�w�� (0=�� 1=���S 2=�E 3=���[ 4=���� 5=�t�B�b�g)
	#xLtBasPos	; 10 ��ʒu���W
	#xLtCtrPos	; 11 �����񒆉��ʒu���W
	#xLtOthPos	; 13 ���@�[���W
	#ii
	#xPos				; �v�Z���ꂽ���W
	#ptH$
	#dist
	#ang
#kpdeploy ; 2011/12/15 YM ADD
	)

	; �G���e�B�e�B���擾
	(setq #ed$ (entget &eEn))

	; ����   TM
	; �����̏ꍇ=1 �����̏ꍇ=0
	(if &fH
		(setq #nYDir 0)
		(setq #nYDir 1)
	)
;|
	(if (/= nil (assoc 70 #ed$))
		(progn
			(setq #nYDir (rem (lsh (cdr (assoc 70 #ed$)) -8) 2))
		)
		; 01/02/23 TM ADD �������Ȃ��ꍇ�f�t�H���g�͐������@�ƍl����
		(progn
			(setq #nYDir 0)
		)
	)
|;

	; ���@�̊���W 
	(if (/= nil (assoc 10 #ed$))
		(progn
			(setq #xLtBasPos$ (cdr (assoc 10 #ed$)))
		)
		(progn
			(princ "���@�\������W���Ȃ� 10")
		)
	)

	; ���@������̔z�u���W
	(if (/= nil (assoc 11 #ed$))
		(progn
			(setq #xLtCtrPos$ (cdr (assoc 11 #ed$)))
		)
		(progn
			(princ "���@�����\���ʒu���Ȃ� 11")
		)
	)

	; ���@�̍��W 
	(if (/= nil (assoc 13 #ed$))
		(progn
			(setq #xLtOthPos$ (cdr (assoc 13 #ed$)))
		)
		(progn
			(princ "���@�\�����W���Ȃ� 13")
		)
	)

	; ���@������̕� ZAN ���@�����{�̂̕��̍l�����s��
	; ZAN ���� "<> ���@������" �̕��ɂȂ��Ă��邽�߁A
	; ZAN �傫�������̐��@����"<>" �Ǝ��ۂ̐��@�̐����̕��̍����������
	; ZAN e.g. "129.3 ���t�^����" ���Ɩ�R������(�v���|�[�V���i�������̂��߁A���m�ɂ͈قȂ�j
	; 08/09/16 �^�J���̕������擾����

	;2016/01/13 YM DEL-S
;;;	;2011/12/15 YM ADD-S
;;;  (cond
;;;    ((= "17" CG_ACADVER)
;;;   		(setq #kpdeploy "kpdeploy17.arx")
;;;	 	)
;;;    ((= "18" CG_ACADVER)
;;;   		(setq #kpdeploy "kpdeploy18.arx")
;;;	 	)
;;;    ((= "19" CG_ACADVER)
;;;   		(setq #kpdeploy "kpdeploy19.arx")
;;;	 	)
;;;    (T
;;;			(CFAlertMsg "\nARX�̃o�[�W�������Ή����Ă��܂���(kpdeploy18.arx)")
;;;	 	)
;;;	);_cond
;;;	;2011/12/15 YM ADD-E
	;2016/01/13 YM DEL-E

	;2016/01/13 YM DEL-S
;;;	(if (= nil (member #kpdeploy (arx)))	;2011/12/15 YM ADD-S ACAD�o�[�W�����ɂ���ċ��
;;;		(setq #rStrW (SCFGetStrWidth &eEn))
;;;	;else
;;;		(progn

			;// ���@�����̕����擾����
			(setq #hnd (cdr (assoc 5 (entget &eEn))))
			(command "SCFGetDimTextWidth" #hnd)
			(setq #rStrW (+ CG_DIMTEXTW CG_SEKOU_DIMSTR_L_OFFSET))

;;;		)
;;;	)
	;2016/01/13 YM DEL-E

	; ���������A�����@�����ȊO�ɕ����񂪂���ꍇ�̂݁A�������ǉ��^�񂹂�
	(command ".-osnap" "") ; 01/04/10 TM ADD ���@��OSNAP �ł����̂ŁA�����I��OFF �ɂ���
	(if (and (/= 1 #nYDir) (/= "<>" #sDimStr))
		(progn
			(command "_.dimtedit" &eEn  
				(SCFCoodToStr (mapcar '+ (SCFDimStrCood #xLtBasPos$ #xLtCtrPos$ #xLtOthPos$ #rStrW &xBasePt &sLR)
																	&dOffs
											)
				)
			)
		)
		(progn
			; T.Ari Mod
			; �����̏ꍇ���W����]���ċ��߂�
;			(command "_.dimtedit" &eEn  (SCFCoodToStr (mapcar '+ &dOffs #xLtBasPos$) &xBasePt &sLR))
			(setq #ptH$
				(mapcar '+ (SCFDimStrCood #xLtBasPos$ #xLtCtrPos$ #xLtOthPos$ #rStrW &xBasePt &sLR) &dOffs)
			)
			(setq #ang (+ (angle #xLtCtrPos$ #ptH$) (* 0.5 PI)))
			(setq #dist (distance #xLtCtrPos$ #ptH$))
			(command "_.dimtedit" &eEn  (SCFCoodToStr (polar #xLtCtrPos$ #ang #dist)))
		)
	)
	(princ)
) ; _defun SCFUpdDimStrPlacement

