;<HOM>*************************************************************************
; <�֐���>    : PKP_SidePanel
; <�����T�v>  : �T�C�h�p�l����z�u����
; <�߂�l>    :
; <�쐬��>    : 1999-10-10
; <���l>      :
;*************************************************************************>MOH<
(defun PKP_SidePanel (
;;;    &type  ;(STR)�T�C�h�p�l���̎�� (N,A,B,C,D) ;03/12/30 YM �����p�~(�~�J�h�łɂ��킹��)
    /
    #base$ #gasu$ #appa$ #ss #i #en #xd$ #uper-en$ #base-en$ #lst$
    #skk$
  )
  (CFOutStateLog 1 5 "//// SKPosSidePanel ////")
  (CFOutStateLog 1 5 "--------------------���� START-----------------")
  (CFOutStateLog 1 5 "�T�C�h�p�l���̎��                : ")(CFOutStateLog 1 5 &type)
  (CFOutStateLog 1 5 "--------------------���� END-----------------")
;;;  (CFOutLog 1 nil (strcat "  +�T�C�h�p�l���̎��: " &type))

  (regapp "G_SIDEP")

	(WebOutLog "++++++++++++++++++++++++++++")
	(WebOutLog "*error*�֐�") ; 02/09/11 YM ADD
	(WebOutLog *error*)       ; 02/09/11 YM ADD
	(WebOutLog "++++++++++++++++++++++++++++")

;;;// �x�[�X�L���r�l�b�g���������A�x�[�X�L���r�l�b�g�̍�������щ��s�����擾
;;;// �A�b�p�[�L���r�l�b�g���������A�A�b�p�[�L���r�l�b�g�̍�������щ��s�����擾
;;;
;;;// �J�E���^�[�g�b�v�̍��������߂Ă���
;;;        LIST : 1.���[�N�g�b�v�̍ŏ㕔�̍���
;;;             : 2.���[�N�g�b�v�̉��s���P
;;;             : 3.���[�N�g�b�v�̉��s���Q
;;;  (PKP_GetWorkTopHeight)

  (if (/= CG_SidePanelCode "N")
    (progn
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_LSYM"))
        ;// ���iCODE�Ńx�[�X�L���r�A�A�b�p�[�L���r�̔�����s��
        (setq #skk$ (CFGetSeikakuToSKKCode (nth 9 #xd$) nil))

        (if (and (= CG_SKK_ONE_CAB (nth 0 #skk$)) (= CG_SKK_TWO_UPP (nth 1 #skk$)))
          (setq #uper-en$ (cons #en #uper-en$))
        ;else
          (if (and (= CG_SKK_ONE_CAB (nth 0 #skk$)) (= CG_SKK_TWO_BAS (nth 1 #skk$)))
            (setq #base-en$ (cons #en #base-en$))
          )
        )
        (setq #i (1+ #i))
      )
      (setq #lst$ (SKP_GetSidePanelPos #base-en$ #uper-en$ CG_SidePanelCode))
      (cond
        ((= CG_W2Code "Z")     ;�h�^
          (PKP_PosSidePanelByKata "I" CG_SidePanelCode #lst$)
        )
        (T                     ;�k�^
          (PKP_PosSidePanelByKata "L" CG_SidePanelCode #lst$)
        )
      )
    )
  );_if

	(WebOutLog "�������ق���t���܂���"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
	(princ)
);PKP_SidePanel

;<HOM>*************************************************************************
; <�֐���>    : PKP_PosSidePanelByKata
; <�����T�v>  : �T�C�h�p�l����z�u����
; <�߂�l>    :
; <�쐬��>    : 1999-10-10
; <���l>      : 02/12/30 NAS��pۼޯ��ǉ�
;*************************************************************************>MOH<
(defun PKP_PosSidePanelByKata (
    &kata  ;(STR)�^�i�k�A�h�j
    &type  ;(STR)�T�C�h�p�l���̎�� (N,A,B,C,D)
    &info$ ;(LIST)�[�̕��ނ̊�_�Ɛ}�`���̃��X�g
           ;       ((�ō��x�[�X�}�` ���W)
           ;        (�ŉE�x�[�X�}�` ���W)
           ;        (�ō��A�b�p�[�}�` ���W)
           ;        (�ŉE�A�b�p�[�}�` ���W)
           ;        (�ŉ��x�[�X�}�` ���W)
           ;        (�ŉ��A�b�p�[�}�` ���W)
           ;       )
    /
    #filer-h #info$ #en #pt #xd$ #w #d #h #panel$ #fname$ #hin #sql #fig$ #qry$ #msg
		#ANG #PW
#DRCOL$ #DRCOL$$ #FIGL$ #FIGR$ #FNAMEL$ #FNAMER$ #HINLR #LR-FLAG #QRYL$ #QRYR$ ; 02/12/30 YM ADD
#HINBAN #I #LR-FLAG-BASE #LR-FLAG-UPPER #LR_EXIST #PW-BASE #PW-UPPER ;03/12/03 YM ADD
  )
  (CFOutStateLog 1 5 "//// SKPosSidePanel ////")
  (CFOutStateLog 1 5 "--------------------���� START-----------------")
  (CFOutStateLog 1 5 "�^                      : ")(CFOutStateLog 1 5 &kata)
  (CFOutStateLog 1 5 "�T�C�h�p�l�����        : ")(CFOutStateLog 1 5 &type)
  (CFOutStateLog 1 5 "�[�̕��ނ̊�_�Ɛ}�`��  : ")(CFOutStateLog 1 5 &info$)
  (CFOutStateLog 1 5 "--------------------���� END-------------------")

	; 02/09/04 YM ADD ۸ޏo�͒ǉ�
	(WebOutLog "�������َ��t������(PKP_PosSidePanelByKata)")
	(WebOutLog "�������ٕi��=")
	(WebOutLog CG_SidePanel$)
	(WebOutLog " ")
	; 02/09/04 YM ADD ۸ޏo�͒ǉ�

	(WebOutLog "++++++++++++++++++++++++++++")
	(WebOutLog "*error*�֐�") ; 02/09/11 YM ADD
	(WebOutLog *error*)       ; 02/09/11 YM ADD
	(WebOutLog "++++++++++++++++++++++++++++")

	
	; 02/12/30 YM ADD-S
;;;	(setq CG_SidePanelLR$ nil)
	(setq #LR-flag nil)
	(setq #fnameR$ nil)
	(setq #fnameL$ nil)
	(setq #fname$  nil)
	; �������ق�LR���K�v���ǂ����y��ׁz�Ŕ��� ��ɂ̏ꍇ�����@�햼��K,L/R���聨�p�~ L/R����

;03/12/3 YM MOD-S �d�g�ݕύX
;;;���X����ͻ������ق�L/R���Ȃ����Ƃ��O��
;;;����(�������)�ɂ����L/R�����鹰��ɑΉ�
;;;([��COLOR]�Ɂu����LR�v̨���ޒǉ�)
;;;��WT����,�V�䍂���ɂ���Ļ������ق̋@�햼���ς��̂ɑΉ�
;;;�����̓xDIPLOA�̻������ق͍ŏ�����L/R������A��(F*)�ɂ����
;;;�@�햼���ς��A������L/R�Ȃ�������ɂȂ鹰����łĂ�������
;;;[��׊�OP]�����OPTID�������Ă͂��̂܂܂�[��׍\OP]�̌�����p�~
;;;[��������]ð��ْǉ�
;;;OPTID+��؋L����KEY�ɂ��ĕi��+LR�L���̏����擾����
;;;([��COLOR]�u����LR�v�g�p���Ȃ�)
;;;=======================================================
;;;[��������]
;;;OPTID ���V���L�� ���V������   RECNO �i�Ԗ���      LR�L��
;;;3     G          �O���X���C�� 1     CPS240X66@@KF 0
;;;4     G          �O���X���C�� 1     CPS91X66@@KF  0
;;;4     G          �O���X���C�� 2     CPS50X37@@KF  0
;;;...
;;;3     N          �~���m       1     CPS240X66@@KF 0
;;;4     N          �~���m       1     CPS91X66@@%F  1
;;;4     N          �~���m       2     CPS50X37@@%F  1
;;;...
;;;=======================================================



	(setq #i 0);i=0�ް�,i=1���߰
	(setq #LR-flag-base nil)
	(setq #LR-flag-upper nil)

  (foreach #hin CG_SidePanel$
		(setq #hinban   (car #hin))  ;�i��
		(setq #LR_exist (cadr #hin)) ;L/R�L��

		(if (equal #LR_exist 1.0 0.001)
			(progn
				;R����
		    (setq #qryR$
		      (CFGetDBSQLHinbanTable "�i�Ԑ}�`" #hinban
		         (list
		           (list "�i�Ԗ���" #hinban 'STR)
		           (list "LR�敪" "R" 'STR)
		         )
		      )
		    )
				;L����
		    (setq #qryL$
		      (CFGetDBSQLHinbanTable "�i�Ԑ}�`" #hinban
		         (list
		           (list "�i�Ԗ���" #hinban 'STR)
		           (list "LR�敪" "L" 'STR)
		         )
		      )
		    )
				;���@W�����߂�
				(if (and #qryL$ (= (length #qryL$) 1))
					(if (= #i 0)
			  		(setq #pw-base (nth 4 (car #qryL$)))
						;else
						(setq #pw-upper (nth 4 (car #qryL$)))
					);_if
				);_if

				;R����-----------------------------------------------
				(if (and #qryR$ (= (length #qryR$) 1))
					(progn
						(setq #qryR$ (car #qryR$))
		    		(setq #figR$ (list (nth 7 #qryR$) (nth 1 #qryR$)))
					)
					;else
					(setq #figR$ nil)
				);_if
				(if #figR$
		    	(setq #fnameR$ (append #fnameR$ (list #figR$))); (�}�`ID,LR)��ؽ�
				);_if

				;L����-----------------------------------------------
				(if (and #qryL$ (= (length #qryL$) 1))
					(progn
						(setq #qryL$ (car #qryL$))
		    		(setq #figL$ (list (nth 7 #qryL$) (nth 1 #qryL$)))
					)
					;else
					(setq #figL$ nil)
				);_if
				(if #figL$
		    	(setq #fnameL$ (append #fnameL$ (list #figL$))); (�}�`ID,LR)��ؽ�
				);_if

				;Z����=nil ------------------------------------------
				(setq #fig$ nil)
	    	(setq #fname$ (append #fname$ (list #fig$))); (�}�`ID,LR)��ؽ�

				;��������L/R�׸�
				(if (= #i 0)
					(setq #LR-flag-base T)
				);_if
				(if (= #i 1)
					(setq #LR-flag-upper T)
				);_if

			)
			;else
			(progn
		    (setq #qry$
		      (CFGetDBSQLHinbanTable "�i�Ԑ}�`" #hinban
		         (list
		           (list "�i�Ԗ���" #hinban 'STR)
		           (list "LR�敪" "Z" 'STR)
		         )
		      )
		    )
				;���@W�����߂�
				(if (and #qry$ (= (length #qry$) 1))
					(if (= #i 0)
			  		(setq #pw-base (nth 4 (car #qry$)))
						;else
						(setq #pw-upper (nth 4 (car #qry$)))
					);_if
				);_if

				;Z����
				(if (and #qry$ (= (length #qry$) 1))
					(progn
						(setq #qry$ (car #qry$))
		    		(setq #fig$ (list (nth 7 #qry$) (nth 1 #qry$)))
					)
					;else
					(setq #fig$ nil)
				);_if
				(if #fig$
		    	(setq #fname$ (append #fname$ (list #fig$))); (�}�`ID,LR)��ؽ�
				);_if

				;L/R����=nil
				(setq #figL$ nil)
				(setq #figR$ nil)
	    	(setq #fnameL$ (append #fnameL$ (list #figL$))); (�}�`ID,LR)��ؽ�
	    	(setq #fnameR$ (append #fnameR$ (list #figR$))); (�}�`ID,LR)��ؽ�
			)
		);_if
		(setq #i (1+ #i));i=0�ް�,i=1���߰
  );foreach

  (regapp "G_PTEN")


  ;// �x�[�X�i�V���N���j
  (if (or (= &type "A") (= &type "B") (= &type "C") (= &type "D"))     ;�Б��Ɏ��t��
    (progn
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I")  (setq #info$ (nth 1 &info$)))
            ((= &kata "L")  (setq #info$ (nth 1 &info$)))
            ((= &kata "WL") (setq #info$ (nth 4 &info$)))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I")  (setq #info$ (nth 0 &info$)))
            ((= &kata "L")  (setq #info$ (nth 0 &info$)))
            ((= &kata "WL") (setq #info$ (nth 4 &info$)))
          )
        )
      )
      (setq #en  (car #info$))
      (setq #pt  (cadr #info$))
      (setq #xd$ (CFGetXData #en "G_SYM"))
      (setq #w   (nth 3 #xd$))
      (setq #xd$ (CFGetXData #en "G_LSYM"))
      (setq #ang (rtd (nth 2 #xd$)))
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I") (setq #pt (list (+ (car #pt) #w) (cadr #pt) 0.0)))
            ((= &kata "L") (setq #pt (list (+ (car #pt) #w) (cadr #pt) 0.0)))
            ((= &kata "WL")(setq #pt (list (car #pt) (- (cadr #pt) #w) 0.0)))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I") (setq #pt (list (- (car #pt) #pw-base) (cadr #pt) 0.0)))
            ((= &kata "L") (setq #pt (list (- (car #pt) #pw-base) (cadr #pt) 0.0)))
            ((= &kata "WL")(setq #pt (list (car #pt) (- (cadr #pt) #pw-base) 0.0)))
          )
        )
      )
      ;// �T�C�h�p�l���𐶐�����

			; 03/04/10 YM MOD-S
			(if (and #LR-flag-base (or (= &type "C") (= &type "D"))) ; ��̂��������ŏꍇ�����K�v
				(if (= (nth 11 CG_GLOBAL$) "R") ; 03/04/10 YM ADD ����ɂ��ꍇ����
	      	(PKP_MakeSidePanel (car #fnameR$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP1") ; LR����̏ꍇ(�E����)
				;else
	      	(PKP_MakeSidePanel (car #fnameL$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP1") ; LR����̏ꍇ(������)
				);_if
			;else
	      (PKP_MakeSidePanel (car #fname$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP1")    ; "K"�̏ꍇ
			);_if

			; 03/04/10 YM ADD-E

    )
  );_if
  ;// �x�[�X�i�K�X���j
  (if (or (= &type "B") (= &type "D"))     ;�����Ɏ��t��
    (progn
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I")  (setq #info$ (nth 0 &info$)))
            ((= &kata "L")  (setq #info$ (nth 4 &info$)))
            ((= &kata "WL") (setq #info$ (nth 0 &info$)))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I")  (setq #info$ (nth 1 &info$)))
            ((= &kata "L")  (setq #info$ (nth 4 &info$)))
            ((= &kata "WL") (setq #info$ (nth 1 &info$)))
          )
        )
      )
      ;(dpr '#info$)
      (setq #en (car #info$))
      (setq #pt (cadr #info$))
      (setq #xd$ (CFGetXData #en "G_SYM"))
      (setq #w (nth 3 #xd$))
      (setq #xd$ (CFGetXData #en "G_LSYM"))
      (setq #ang (rtd (nth 2 #xd$)))
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I") (setq #pt (list (- (car #pt) #pw-base) (cadr #pt) 0.0)))
            ((= &kata "L") (setq #pt (list (car #pt) (- (cadr #pt) #pw-base) 0.0)))
            ((= &kata "WL")(setq #pt (list (- (car #pt) #pw-base) (cadr #pt) 0.0)))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I") (setq #pt (list (+ (car #pt) #w) (cadr #pt) 0.0)))
            ((= &kata "L") (setq #pt (list (car #pt) (- (cadr #pt) #w) 0.0)))
            ((= &kata "WL")(setq #pt (list (+ (car #pt) #w) (cadr #pt) 0.0)))
          )
        )
      )
      ;// �T�C�h�p�l���𐶐�����

			; 03/04/10 YM MOD-S
			(if (and #LR-flag-base (or (= &type "C") (= &type "D"))) ; ��̂��������ŏꍇ�����K�v
				(if (= (nth 11 CG_GLOBAL$) "R") ; 03/04/10 YM ADD ����ɂ��ꍇ����
	      	(PKP_MakeSidePanel (car #fnameL$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP2") ; LR����̏ꍇ(�E����)
				;else
	      	(PKP_MakeSidePanel (car #fnameR$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP2") ; LR����̏ꍇ(������)
				);_if
			;else
	      (PKP_MakeSidePanel (car #fname$) (car (car CG_SidePanel$)) #pt #ang #en "SIDEP2")    ; "K"�̏ꍇ
			);_if

			; 03/04/10 YM ADD-E
    )
  );_if
  ;// �A�b�p�[�i�V���N���j
  (if (or (= &type "C") (= &type "D"))     ;�Б��Ɏ��t���i�x�[�X�A�A�b�p�[�����j
    (progn
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I")  (setq #info$ (nth 3 &info$)))
            ((= &kata "L")  (setq #info$ (nth 3 &info$)))
            ((= &kata "WL") (setq #info$ (nth 5 &info$)))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I")  (setq #info$ (nth 2 &info$)))
            ((= &kata "L")  (setq #info$ (nth 2 &info$)))
            ((= &kata "WL") (setq #info$ (nth 5 &info$)))
          )
        )
      )
      (setq #en (car #info$))
      (setq #pt (cadr #info$))
      (setq #xd$ (CFGetXData #en "G_SYM"))
      (setq #w (nth 3 #xd$))
      (setq #xd$ (CFGetXData #en "G_LSYM"))
      (setq #ang (rtd (nth 2 #xd$)))
      (cond
        ((= (nth 11 CG_GLOBAL$) "R")
          (cond
            ((= &kata "I") (setq #pt (list (+ (car #pt) #w) (cadr #pt))))
            ((= &kata "L") (setq #pt (list (+ (car #pt) #w) (cadr #pt))))
            ((= &kata "WL")(setq #pt (list (car #pt) (- (cadr #pt) #w))))
          )
        )
        ((= (nth 11 CG_GLOBAL$) "L")
          (cond
            ((= &kata "I") (setq #pt (list (- (car #pt) #pw-upper) (cadr #pt))))
            ((= &kata "L") (setq #pt (list (- (car #pt) #pw-upper) (cadr #pt))))
            ((= &kata "WL")(setq #pt (list (car #pt) (- (cadr #pt) #pw-upper))))
          )
        )
      )
      ;// �T�C�h�p�l���𐶐�����

			; 03/04/10 YM MOD-S
			(if (and #LR-flag-upper (or (= &type "C") (= &type "D"))) ; ��̂��������ŏꍇ�����K�v
				(if (= (nth 11 CG_GLOBAL$) "R") ; 03/04/10 YM ADD ����ɂ��ꍇ����
	      	(PKP_MakeSidePanel (cadr #fnameR$) (car (cadr CG_SidePanel$)) (list (car #pt) (cadr #pt) CG_CeilHeight) #ang #en "SIDEP3") ; LR����̏ꍇ(�E����)
				;else
	      	(PKP_MakeSidePanel (cadr #fnameL$) (car (cadr CG_SidePanel$)) (list (car #pt) (cadr #pt) CG_CeilHeight) #ang #en "SIDEP3") ; LR����̏ꍇ(������)
				);_if
			;else
	      (PKP_MakeSidePanel (cadr #fname$) (car (cadr CG_SidePanel$)) (list (car #pt) (cadr #pt) CG_CeilHeight) #ang #en "SIDEP3")    ; "K"�̏ꍇ
			);_if

			; 03/04/10 YM ADD-E

    )
  );_if

	; 02/12/30 YM ADD-S
	(setq CG_SidePanel$ nil)
;;;	(setq CG_SidePanelLR$ nil)
;;;	(setq #LR-flag nil)
	; 02/12/30 YM ADD-E

  (princ)
)
;PKP_PosSidePanelByKata

;<HOM>*************************************************************************
; <�֐���>    : PKP_MakeSidePanel
; <�����T�v>  : �z�u��񂩂�T�C�h�p�l�����쐬����
; <�߂�l>    :
; <�쐬��>    : 1999-10-10
; <���l>      :
;*************************************************************************>MOH<
(defun PKP_MakeSidePanel (
    &file         ;(LIST) (�}���t�@�C���� LR�敪)
    &hin          ;(STR) �i�Ԗ���
    &pt           ;(LIST)�z�u�_
    &ang          ;(REAL)�z�u�p�x
    &en           ;(ENAME)���t����L���r�l�b�g�̐}�`��
    &grp          ;(STR)�O���[�v��
    /
    #sym #xd$ #w #d #h
    #listCode #sql #nn #seikaku
    #lst$
    #CounterH #CounterD1 #CounterD2
    #qry$
		#FIL-H #LR #MSG
  )

  (CFOutStateLog 1 5 "//// PKP_MakeSidePanel ////")
  (CFOutStateLog 1 5 "--------------------���� START-----------------")
  (CFOutStateLog 1 5 "�}���t�@�C����   : ")(CFOutStateLog 1 5 &file)
  (CFOutStateLog 1 5 "�i�Ԗ���         : ")(CFOutStateLog 1 5 &hin)
  (CFOutStateLog 1 5 "�z�u�_           : ")(CFOutStateLog 1 5 &pt)
  (CFOutStateLog 1 5 "�z�u�p�x         : ")(CFOutStateLog 1 5 &ang)
  (CFOutStateLog 1 5 "�}�`��           : ")(CFOutStateLog 1 5 &en)
  (CFOutStateLog 1 5 "�O���[�v��       : ")(CFOutStateLog 1 5 &grp)
  (CFOutStateLog 1 5 "--------------------���� END-------------------")

  (setq #lr (cadr &file))
  (setq &file (car &file))
;;;  (CFOutLog 1 nil (strcat "  +�}���t�@�C����: " &file))
;;;  (CFOutLog 1 nil (strcat "  +LR�敪: " #lr))
;;;  (CFOutLog 1 nil (strcat "  +�i�Ԗ���: "       &hin))
  ;-----------------------------------------
  ; �T�C�h�p�l���̐L�k�ʂ����߂�
  ;-----------------------------------------
  (setq #xd$ (CFGetXData &en "G_SYM"))
  (setq #w   (nth 3 #xd$))
  (setq #d   (nth 4 #xd$))
  (setq #h   (nth 5 #xd$))

  ;// ���[�N�g�b�v�̏����擾����
  (setq #lst$ (PKP_GetWorkTopHeight))
  (setq #CounterH  (nth 0 #lst$))
  (setq #CounterD1 (nth 1 #lst$))
  (setq #CounterD2 (nth 2 #lst$))
  (cond
    ;// �x�[�X�̐L�k�l
    ((or (= &grp "SIDEP1") (= &grp "SIDEP2"))
      (cond
        ((or (= CG_SidePanelCode "A") (= CG_SidePanelCode "B"))
          (setq #h CG_CeilHeight)
        )
        ((or (= CG_SidePanelCode "C") (= CG_SidePanelCode "D"))
          (setq #h (+ #CounterH CG_PANEL_OFFSET))
        )
      )
      ;// �T�C�h�p�l���̉��s����ݒ肷��
;;;@YM@      (if (and (= CG_Type2Code "W") (= &grp "SIDEP1"))
;;;@YM@        (setq #d (+ #CounterD1 CG_PANEL_OFFSET))
        (setq #d (+ #CounterD2 CG_PANEL_OFFSET))
;;;@YM@      )
    )
    ;// �A�b�p�[�̐L�k�l
    (T
      (setq #fil-h (- CG_CeilHeight CG_UpCabHeight))
      (setq #h (+ #h #fil-h CG_PANEL_OFFSET))
      (setq #d (+ #d CG_PANEL_OFFSET))
    )
  )
  ;-----------------------------------------
  ; ���iCODE���擾
  ;-----------------------------------------
  (setq #qry$
;;;    (car ; 00/02/16 @YM@ �������� ADD
			(CFGetDBSQLHinbanTable
            "�i�Ԋ�{"
            &hin
            (list
;;;              (list "�i�Ԗ���" "NODATA" 'STR) ; �G���[�e�X�g
              (list "�i�Ԗ���" &hin 'STR)
            )
       )
;;;    ) ; 00/02/16 @YM@ �������� ADD
  );_(setq

  (if (= #qry$ nil)
    (progn
			(setq #msg (strcat "�w�i�Ԋ�{�x�Ƀ��R�[�h������܂���.\nPKP_MakeSidePanel"))
			(CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  )
	(CFOutStateLog 1 1 "*** �擾ں��� ***")
	(CFOutStateLog 1 1 #qry$)

	(if (= (length #qry$) 1) ; 00/02/16 @YM@ �������� ADD
		(progn
	  	(setq #qry$ (car #qry$))
		)
    (progn ; ����˯Ă����Ƃ��ʹװ
			(setq #msg (strcat "�w�i�Ԋ�{�x�Ƀ��R�[�h����������܂���.\nPKP_MakeSidePanel"))
			(CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
	);_if                    ; 00/02/16 @YM@ �������� ADD

  (setq #seikaku (nth 3 #qry$)); @YM@ OK!
;;;  (if (/= #qry$ nil)
;;;;;;    (CFOutLog 1 nil (strcat "  +���iCODE: " (rtos #seikaku)))
;;;  )
  ;-----------------------------------------
  ;�T�C�h�p�l����}������
  ;-----------------------------------------
	; 02/09/04 YM ADD ۸ޏo�͒ǉ�
	(WebOutLog "�������ق�}�����܂�(PKP_MakeSidePanel)")

  (command "_insert" (strcat CG_MSTDWGPATH &file) &pt 1 1 &ang)
  (command "_explode" (entlast))                    ;�C���T�[�g�}�`����
  ;// ���������I���Z�b�g�Ŗ��O�̂Ȃ��O���[�v���쐬����
  (SKMkGroup (ssget "P"))

  ;// ��}�`���擾����
  (setq #sym (SKC_GetSymInGroup (entlast)))

  ;-----------------------------------------
  ;�g���f�[�^�̕t��
  ;-----------------------------------------
  (CFSetXData #sym "G_LSYM"
    (list
      &file           ;1 :�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID
      &pt             ;2 :�}���_          :�z�u��_
      (dtr &ang)      ;3 :��]�p�x        :�z�u��]�p�x
      CG_Kcode        ;4 :�H��L��        :CG_Kcode      ; 01/10/26 YM ADD ""--> CG_Kcode
      CG_SeriesCode   ;5 :SERIES�L��    :CG_SeriesCode ; 01/10/26 YM ADD ""--> CG_SeriesCode
      &hin            ;6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���
      #lr             ;7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪
      ""              ;8 :���}�`ID        :
      ""              ;9 :���J���}�`ID    :
      (fix #seikaku)  ;10:���iCODE      :�w�i�Ԋ�{�x.���iCODE
      0               ;11:�����t���O      :�O�Œ�i�P�ƕ��ށj
      0               ;12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
      0               ;13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�
      0               ;14:���@�g          :�w�i�Ԑ}�`�x.���@�g
      0               ;15:�f�ʎw���̗L��  :�f�ʎw���̗L��
    )
  )
  (setq #xd$ (CFGetXData #sym "G_SYM"))
  (CFSetXData #sym "G_SYM"
    (list
      (nth 0 #xd$)    ;�V���{������
      (nth 1 #xd$)    ;�R�����g�P
      (nth 2 #xd$)    ;�R�����g�Q
      (nth 3 #xd$)   ;�V���{����l�v
      (nth 4 #xd$)   ;�V���{����l�c
      (nth 5 #xd$)   ;�V���{����l�g
      (nth 6 #xd$)    ;�V���{����t������
      (nth 7 #xd$)    ;���͕��@
      (nth 8 #xd$)    ;�v�����t���O
      (nth 9 #xd$)    ;�c�����t���O
      (nth 10 #xd$)   ;�g�����t���O
      (nth 11 #xd$)   ;�L�k�t���O�v
      #d              ;�L�k�t���O�c
      #h              ;�L�k�t���O�g
      (nth 14 #xd$)   ;�u���[�N���C�����v
      (nth 15 #xd$)   ;�u���[�N���C�����c
      (nth 16 #xd$)   ;�u���[�N���C�����g
    )
  )
)
;PKP_MakeSidePanel

;<HOM>*************************************************************************
; <�֐���>    : SKP_GetSidePanelPos
; <�����T�v>  : �T�C�h�p�l���̔z�u�����擾����
; <�߂�l>    :
;             : (LIST)�[�̕��ނ̊�_�Ɛ}�`���̃��X�g
;                  ((�ō��x�[�X�}�` ���W)
;                   (�ŉE�x�[�X�}�` ���W)
;                   (�ō��A�b�p�[�}�` ���W)
;                   (�ŉE�A�b�p�[�}�` ���W)
;                   (�ŉ��x�[�X�}�` ���W)
;                   (�ŉ��A�b�p�[�}�` ���W)
;                  )
; <�쐬��>    : 1999-10-10
; <���l>      :
;*************************************************************************>MOH<
(defun SKP_GetSidePanelPos (
    &base-en$     ;(LIST)�x�[�X�L���r�l�b�g�}�`�̃��X�g
    &uper-en$     ;(LIST)�A�b�p�[�L���r�l�b�g�}�`�̃��X�g
    &type         ;(STR)�T�C�h�p�l���̎�� (N,A,B,C,D)
    /
    #i #maxpt1 #minpt1 #maxpt2 #minpt2 
		#minypt #en #eg #pt #maxen1 #minen1 
		#minypt1 #minyen1 #maxen2 #minen2 #minyen
		#MINYEN2 #MINYPT2
  )
  (CFOutStateLog 1 5 "//// SKP_GetSidePanelPos ////")
  (CFOutStateLog 1 5 "--------------------���� START-----------------")
  (CFOutStateLog 1 5 "�x�[�X�L���r�l�b�g�}�`    : ")(CFOutStateLog 1 5 &base-en$)
  (CFOutStateLog 1 5 "�A�b�p�[�L���r�l�b�g�}�`  : ")(CFOutStateLog 1 5 &uper-en$)
  (CFOutStateLog 1 5 "�T�C�h�p�l���̎��        : ")(CFOutStateLog 1 5 &type)
  (CFOutStateLog 1 5 "--------------------���� END-------------------")

  (setq #i 0)

  (setq #maxpt1 (list -10000 -10000))
  (setq #minpt1 (list 10000 -10000))
  (setq #maxpt2 (list -1000 -1000))
  (setq #minpt2 (list 10000 -10000))
  (setq #minypt1 (list -10000 10000))
  (setq #minypt2 (list -10000 10000))
  (foreach #en &base-en$
    (setq #eg (entget #en))
    (setq #pt (cdr (assoc 10 #eg)))
    
    (if (< (car #maxpt1) (car #pt))
      (progn
        (setq #maxpt1 #pt)
        (setq #maxen1 #en)
      )
    )
    (if (> (car #minpt1) (car #pt))
      (progn
        (setq #minpt1 #pt)
        (setq #minen1 #en)
      )
    )
    (if (> (cadr #minypt1) (cadr #pt))
      (progn
        (setq #minypt1 #pt)
        (setq #minyen1 #en)
      )
    )
    (setq #i (1+ #i))
  )
  (foreach #en &uper-en$
    (setq #eg (entget #en))
    (setq #pt (cdr (assoc 10 #eg)))

    (if (< (car #maxpt2) (car #pt))
      (progn
        (setq #maxpt2 #pt)
        (setq #maxen2 #en)
      )
    )
    (if (> (car #minpt2) (car #pt))
      (progn
        (setq #minpt2 #pt)
        (setq #minen2 #en)
      )
    )
    (if (> (cadr #minypt2) (cadr #pt))
      (progn
        (setq #minypt2 #pt)
        (setq #minyen2 #en)
      )
    )
    (setq #i (1+ #i))
  )
  ;// ���ʂ�Ԃ�
  (list (list #minen1 #minpt1)
        (list #maxen1 #maxpt1)
        (list #minen2 #minpt2)
        (list #maxen2 #maxpt2)
        (list #minyen1 #minypt1)
        (list #minyen2 #minypt2)
  )
)
;SKP_GetSidePanelPos

;<HOM>*************************************************************************
; <�֐���>    : PKP_GetWorkTopHeight
; <�����T�v>  : �J�E���^�[�̍ŏ㕔�̍��������߂�
; <�߂�l>    :
;        LIST : 1.���[�N�g�b�v�̍ŏ㕔�̍���
;             : 2.���[�N�g�b�v�̉��s���P
;             : 3.���[�N�g�b�v�̉��s���Q
; <�쐬��>    : 01/07/11 YM MOD
; <���l>      : ���^WT�p-->�V�^WT�p�ɍč쐬
;*************************************************************************>MOH<
(defun PKP_GetWorkTopHeight (
    /
    #ss #xd$ #h
    #en
    #d1 #d2
  )
	(CFOutStateLog 1 1 " ")
	(CFOutStateLog 1 1 "//// PKP_GetWorkTopHeight ////")
	(CFOutStateLog 1 1 " ")

  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (= #ss nil)
    (progn
      (CFOutStateLog 0 5 "PKP_GetWorkTopHeight:���[�N�g�b�v������܂���B")
    )
    (progn
      (setq #xd$ (CFGetXData (ssname #ss 0) "G_WRKT"))
			; ���[���t�������A�J�E���^�[�����A�o�b�N�K�[�h����
      (setq #h (+ (nth 8 #xd$) (nth 10 #xd$) (nth 12 #xd$)))

      (setq #dep$ (nth 57 #xd$)) ; WT���s��ؽ� dep1,dep2(���ڽL�^)
      (setq #d1 (car  #dep$))
      (setq #d2 #d1) ; 01/07/11 YM ??? ���s��2�Ƃ́H
;;;			(if (< 0.1 #d2)
;;;				nil
;;;				(setq #d2 nil)
;;;			);_if
      (CFOutStateLog 1 5 (strcat "PKP_GetWorkTopHeight:�J�E���^�[�ŏ㕔����=" (rtos #h)))
    )
  )
  (list #h #d1 #d2)
);PKP_GetWorkTopHeight

;;;01/07/11YM@;<HOM>*************************************************************************
;;;01/07/11YM@; <�֐���>    : SKP_GetWorkTopHeight
;;;01/07/11YM@; <�����T�v>  : �J�E���^�[�̍ŏ㕔�̍��������߂�
;;;01/07/11YM@; <�߂�l>    :
;;;01/07/11YM@;        LIST : 1.���[�N�g�b�v�̍ŏ㕔�̍���
;;;01/07/11YM@;             : 2.���[�N�g�b�v�̉��s���P
;;;01/07/11YM@;             : 3.���[�N�g�b�v�̉��s���Q
;;;01/07/11YM@; <�쐬��>    : 1999-10-10
;;;01/07/11YM@; <���l>      :
;;;01/07/11YM@;*************************************************************************>MOH<
;;;01/07/11YM@(defun SKP_GetWorkTopHeight (
;;;01/07/11YM@    /
;;;01/07/11YM@    #ss #xd$ #h
;;;01/07/11YM@    #en
;;;01/07/11YM@    #d1 #d2
;;;01/07/11YM@  )
;;;01/07/11YM@	(CFOutStateLog 1 1 " ")
;;;01/07/11YM@	(CFOutStateLog 1 1 "//// SKP_GetWorkTopHeight ////")
;;;01/07/11YM@	(CFOutStateLog 1 1 " ")
;;;01/07/11YM@
;;;01/07/11YM@  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
;;;01/07/11YM@  (if (= #ss nil)
;;;01/07/11YM@    (progn
;;;01/07/11YM@      (CFOutStateLog 0 5 "SKP_GetWorkTopHeight:���[�N�g�b�v������܂���B")
;;;01/07/11YM@    )
;;;01/07/11YM@  ;else
;;;01/07/11YM@    (progn
;;;01/07/11YM@      (setq #xd$ (CFGetXData (ssname #ss 0) "G_WRKT"))
;;;01/07/11YM@;;; ���[���t�������A�J�E���^�[�����A�o�b�N�K�[�h����
;;;01/07/11YM@      (setq #h (+ (nth 8 #xd$) (nth 10 #xd$) (nth 12 #xd$)))
;;;01/07/11YM@      (setq #en (nth 28 #xd$)) ; WT���ʐ}�`�n���h��
;;;01/07/11YM@      (setq #d1 (cadr (CFGetXData #en "G_SIDE")))
;;;01/07/11YM@      (if (/= "" (nth 29 #xd$)); �J�b�g��ʐ}�`�n���h��
;;;01/07/11YM@        (progn
;;;01/07/11YM@          (setq #en (nth 29 #xd$))
;;;01/07/11YM@          (setq #d2 (cadr (CFGetXData #en "G_SIDE")))
;;;01/07/11YM@        )
;;;01/07/11YM@        (setq #d2 nil)
;;;01/07/11YM@      )
;;;01/07/11YM@      (CFOutStateLog 1 5 (strcat "SKP_GetWorkTopHeight:�J�E���^�[�ŏ㕔����=" (rtos #h)))
;;;01/07/11YM@    )
;;;01/07/11YM@  )
;;;01/07/11YM@  (list #h #d1 #d2)
;;;01/07/11YM@)
;;;01/07/11YM@;SKP_GetWorkTopHeight

;<HOM>*************************************************************************
; <�֐���>    : SDP_PosSidePanel
; <�����T�v>  : �T�C�h�p�l����z�u����
; <�߂�l>    :
; <�쐬��>    : 1999-10-10
; <���l>      :
;*************************************************************************>MOH<
(defun SDP_PosSidePanel (
    &type  ;(STR)�T�C�h�p�l���̎�� (N,R,L,T or B)
    /
    #base$ #gasu$ #appa$ #ss #i #en #xd$ #uper-en$ #base-en$ #lst$
		#SKK$
  )
  (CFOutStateLog 1 5 "//// SKPosSidePanel ////")
  (CFOutStateLog 1 5 "--------------------���� START-----------------")
  (CFOutStateLog 1 5 "�T�C�h�p�l���̎��                : ")(CFOutStateLog 1 5 &type)
  (CFOutStateLog 1 5 "--------------------���� END-----------------")
;;;  (CFOutLog 1 nil (strcat "  +�T�C�h�p�l���̎��: " &type))

  (regapp "G_SIDEP")

  ;// �x�[�X�L���r�l�b�g���������A�x�[�X�L���r�l�b�g�̍�������щ��s�����擾
  ;// �A�b�p�[�L���r�l�b�g���������A�A�b�p�[�L���r�l�b�g�̍�������щ��s�����擾

  ;// �J�E���^�[�g�b�v�̍��������߂Ă���
  (if (/= CG_Type1Code "A")
    (SDP_GetCounterTopHeight)
  )

  (if (/= &type "N")
    (progn
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_LSYM"))

        ;// ���iCODE�Ńx�[�X�L���r�A�A�b�p�[�L���r�̔�����s��
        (setq #skk$ (CFGetSeikakuToSKKCode (nth 9 #xd$) nil))

        (if (and (= CG_SKK_ONE_CAB (nth 0 #skk$)) (= CG_SKK_TWO_UPP (nth 1 #skk$)))
          (setq #uper-en$ (cons #en #uper-en$))
        ;else
          (if (and (= CG_SKK_ONE_CAB (nth 0 #skk$)) (= CG_SKK_TWO_BAS (nth 1 #skk$)))
            (setq #base-en$ (cons #en #base-en$))
          )
        )
        ;(if (member (nth 9 #xd$) #appa$)
        ;  (setq #uper-en$ (cons #en #uper-en$))
        ;  (if (member (nth 9 #xd$) #base$)
        ;    (setq #base-en$ (cons #en #base-en$))
        ;  )
        ;)
        (setq #i (1+ #i))
      )
      (setq #lst$ (SDP_GetSidePanelPos #base-en$ #uper-en$ &type))
      (SDP_PosSidePanelByKata &type #lst$)
    )
  )
)
;SDP_PosSidePanel

;<HOM>*************************************************************************
; <�֐���>    : SDP_PosSidePanel
; <�����T�v>  : �T�C�h�p�l����z�u����
; <�߂�l>    :
; <�쐬��>    : 1999-10-10
; <���l>      :
;*************************************************************************>MOH<
(defun SDP_PosSidePanelByKata (
    &type  ;(STR)�T�C�h�p�l���̎�� (N,R,L,T)
    &info$ ;(LIST)�[�̕��ނ̊�_�Ɛ}�`���̃��X�g
           ;       ((�ō��x�[�X�}�` ���W)
           ;        (�ŉE�x�[�X�}�` ���W)
           ;        (�ō��A�b�p�[�}�` ���W)
           ;        (�ŉE�A�b�p�[�}�` ���W)
           ;        (�ŉ��x�[�X�}�` ���W)
           ;        (�ŉ��A�b�p�[�}�` ���W)
           ;       )
    /
    #filer-h #info$ #en #pt #xd$ #w #d #h #panel$ #fname$ #hin #sql #fig$ #qry$
		#ANG #MSG #PW 
  )
	(CFOutStateLog 1 1 " ")
	(CFOutStateLog 1 1 "//// SDP_PosSidePanelByKata ////")
	(CFOutStateLog 1 1 " ")

  ;//�@CG_SidePanel$�̓��e
  ;//
  ;//    �E�J�b�v�{�[�h
  ;//        (
  ;//          �V��܂ł̃x�[�X�i�ԁi�P�����j
  ;//          �V��܂ł̃A�b�p�[�i�ԁi�P�����j
  ;//        )
  ;//    �E�J�E���^�[���j�b�g
  ;//        (
  ;//          �����x�[�X�i�ԁi�Q�����j
  ;//          �����A�b�p�[�i�ԁi�Q�����j
  ;//        )
  ;//    �E�R���r�l�[�V����
  ;//        (
  ;//          �����x�[�X�i�ԁi�Q�����j
  ;//          �����A�b�p�[�i�ԁi�Q�����j
  ;//          �V��܂ł̃x�[�X�i�ԁi�P���j
  ;//        )
  ;//
  ;//   �����x�[�X�̍����͂��ꂼ��J�E���^�[�̍ŏ�ʒu�{�P�Wmm�ɐL�k
  ;//   �����x�[�X�̉��s�͂��ꂼ��אڃL���r�l�b�g�̉��s���{�P�Wmm�ɐL�k
  ;//   �����A�b�p�[�̍����͂��ꂼ��אڃL���r�l�b�g�̉��s���{�V��t�B���[�����{�P�Wmm�ɐL�k
  ;//   �����A�b�p�[�̉��s�͂��ꂼ��אڃL���r�l�b�g�̉��s���{�P�Wmm�ɐL�k
  ;//

	(WebOutLog "CG_SidePanel$=") ; 02/09/11 YM ADD
	(WebOutLog CG_SidePanel$)    ; 02/09/11 YM ADD

  (foreach #hin CG_SidePanel$
    (setq #qry$
;;;      (car ; 00/02/16 @YM@ �������� ADD
        (CFGetDBSQLHinbanTable
           "�i�Ԑ}�`"
           #hin
           (list
             (list "�i�Ԗ���" #hin 'STR)
           )
        )
;;;      ) ; 00/02/16 @YM@ �������� ADD
    )
    (if (= #qry$ nil)
      (progn
				(setq #msg (strcat "�w�i�Ԑ}�`�x�Ƀ��R�[�h������܂���.\nSDP_PosSidePanelByKata"))
	      (CFOutStateLog 0 1 #msg)
				(CFAlertMsg #msg)
	      (*error*)
      )
    )
		(CFOutStateLog 1 1 "*** �擾ں��� ***")
		(CFOutStateLog 1 1 #qry$)

		(if (= (length #qry$) 1) ; 00/02/16 @YM@ �������� ADD
			(progn
		  	(setq #qry$ (car #qry$))
				(WebOutLog "[�i�Ԑ}�`]�擾ں���=") ; 02/09/11 YM ADD
				(WebOutLog #qry$) ; 02/09/11 YM ADD
			)
	    (progn ; ����˯Ă����Ƃ��ʹװ
				(setq #msg (strcat "�w�i�Ԑ}�`�x�Ƀ��R�[�h����������܂���.\nSDP_PosSidePanelByKata"))
	      (CFOutStateLog 0 1 #msg)
				(CFAlertMsg #msg)
	      (*error*)
	    )
		);_if                    ; 00/02/16 @YM@ �������� ADD

    (setq #fig$ (list (nth 6 #qry$)));2008/06/28 YM OK!

    (setq #fname$ (append #fname$ #fig$))

  );foreach


  (regapp "G_PTEN")
  (setq #pw (nth 3 #qry$)) ;2008/06/28 YM OK!

  ;// �x�[�X�i�E���j
  (if (or (= &type "R") (= &type "T") (= &type "B"))     ;�Б��܂��͗����Ɏ��t��
    (progn
      (setq #info$ (nth 1 &info$))
      (setq #en  (car #info$))
      (setq #pt  (cadr #info$))
      (setq #xd$ (CFGetXData #en "G_SYM"))
      (setq #w (nth 3 #xd$))
      (setq #xd$ (CFGetXData #en "G_LSYM"))
      (setq #ang (rtd (nth 2 #xd$)))
      (setq #pt (list (+ (car #pt) #w) (cadr #pt) 0.0))
      ;// �R���r�l�[�V�����ŉE����̏ꍇ
      (if (and (= CG_Type1Code "C") (= (nth 11 CG_GLOBAL$) "R"))
        (SDP_MakeSidePanel
          (caddr #fname$)
          (caddr CG_SidePanel$)
          #pt
          #ang
          #en
          "SIDEP1"
        )
      ;else
        (SDP_MakeSidePanel
          (car #fname$)
          (car CG_SidePanel$)
          #pt
          #ang
          #en
          "SIDEP1"
        )
      )
    )
  )
  ;// �x�[�X�i�����j
  (if (or (= &type "L") (= &type "T") (= &type "B"))     ;�����Ɏ��t��
    (progn
      (setq #info$ (nth 0 &info$))
      (setq #en (car #info$))
      (setq #pt (cadr #info$))
      (setq #xd$ (CFGetXData #en "G_SYM"))
      (setq #w (nth 3 #xd$))
      (setq #xd$ (CFGetXData #en "G_LSYM"))
      (setq #ang (rtd (nth 2 #xd$)))
      (setq #pt (list (- (car #pt) #pw) (cadr #pt) 0.0))
      ;// �R���r�l�[�V�����ō�����̏ꍇ
      (if (and (= CG_Type1Code "C") (= (nth 11 CG_GLOBAL$) "L"))
        (SDP_MakeSidePanel
          (caddr #fname$)
          (caddr CG_SidePanel$)
          #pt
          #ang
          #en
          "SIDEP2"
        )
      ;else
        (SDP_MakeSidePanel
          (car #fname$)
          (car CG_SidePanel$)
          #pt
          #ang
          #en
          "SIDEP2"
        )
      )
    )
  )
  ;// �A�b�p�[�i�E���j
  (if (car (nth 3 &info$))
    ;// �Б��Ɏ��t���i�x�[�X�A�A�b�p�[�����j
    (if (and (/= CG_Type1Code "A")(/= CG_Type1Code "D") (or (= &type "R") (= &type "T") (= &type "B")))
      (progn
        (if (and (= CG_Type1Code "C") (= (nth 11 CG_GLOBAL$) "R"))
          (princ)
        ;else
          (progn
            (setq #info$ (nth 3 &info$))
            (setq #en (car #info$))
            (setq #pt (cadr #info$))
            (setq #xd$ (CFGetXData #en "G_SYM"))
            (setq #w (nth 3 #xd$))
            (setq #xd$ (CFGetXData #en "G_LSYM"))
            (setq #ang (rtd (nth 2 #xd$)))
            (setq #pt (list (+ (car #pt) #w) (cadr #pt)))
            ;// �T�C�h�p�l���𐶐�����
            (SDP_MakeSidePanel
              (cadr #fname$)
              (cadr CG_SidePanel$)
              (list (car #pt) (cadr #pt) CG_CeilHeight)
              #ang
              #en
              "SIDEP3"
            )
          )
        )
      )
    )
  )
  ;// �A�b�p�[�i�����j
  (if (car (nth 2 &info$))
    ;//�����Ɏ��t���i�x�[�X�A�A�b�p�[�����j
    (if (and (/= CG_Type1Code "A") (/= CG_Type1Code "D")(or (= &type "L") (= &type "T") (= &type "B")))
      (progn
        (if (and (= CG_Type1Code "C") (= (nth 11 CG_GLOBAL$) "L"))
          (princ)
          (progn
            (setq #info$ (nth 2 &info$))
            (setq #en (car #info$))
            (setq #pt (cadr #info$))
            (setq #xd$ (CFGetXData #en "G_SYM"))
            (setq #w (nth 3 #xd$))
            (setq #xd$ (CFGetXData #en "G_LSYM"))
            (setq #ang (rtd (nth 2 #xd$)))
            (setq #pt (list (- (car #pt) #pw) (cadr #pt)))
            ;// �T�C�h�p�l���𐶐�����
            (SDP_MakeSidePanel
              (cadr #fname$)
              (cadr CG_SidePanel$)
              (list (car #pt) (cadr #pt) CG_CeilHeight)
              #ang
              #en
              "SIDEP4"
            )
          )
        )
      )
    )
  )
  (princ)
)
;SDP_PosSidePanelByKata

;<HOM>*************************************************************************
; <�֐���>    : SDP_MakeSidePanel
; <�����T�v>  : �z�u��񂩂�T�C�h�p�l�����쐬����
; <�߂�l>    :
; <�쐬��>    : 1999-10-10
; <���l>      :
;*************************************************************************>MOH<
(defun SDP_MakeSidePanel (
    &file         ;(STR) �}���t�@�C����
    &hin          ;(STR) �i�Ԗ���
    &pt           ;(LIST)�z�u�_
    &ang          ;(REAL)�z�u�p�x
    &en           ;(ENAME)���t����L���r�l�b�g�̐}�`��
    &grp          ;(STR)�O���[�v��
    /
    #sym #xd$ #w #d #h
    #listCode #sql #nn #seikaku
    #qry$
		#FIL-H #MSG
  )
  (CFOutStateLog 1 5 "//// SKMakeSidePanel ////")
  (CFOutStateLog 1 5 "--------------------���� START-----------------")
  (CFOutStateLog 1 5 "�}���t�@�C����   : ")(CFOutStateLog 1 5 &file)
  (CFOutStateLog 1 5 "�i�Ԗ���         : ")(CFOutStateLog 1 5 &hin)
  (CFOutStateLog 1 5 "�z�u�_           : ")(CFOutStateLog 1 5 &pt)
  (CFOutStateLog 1 5 "�z�u�p�x         : ")(CFOutStateLog 1 5 &ang)
  (CFOutStateLog 1 5 "�}�`��           : ")(CFOutStateLog 1 5 &en)
  (CFOutStateLog 1 5 "�O���[�v��       : ")(CFOutStateLog 1 5 &grp)
  (CFOutStateLog 1 5 "--------------------���� END-------------------")
;;;  (CFOutLog 1 nil (strcat "  +�}���t�@�C����: " &file))
;;;  (CFOutLog 1 nil (strcat "  +�i�Ԗ���: "       &hin))

  ;-----------------------------------------
  ; �T�C�h�p�l���̐L�k�ʂ����߂�
  ;-----------------------------------------
  (setq #xd$ (CFGetXData &en "G_SYM"))
  (setq #w   (nth 3 #xd$))
  (setq #d   (nth 4 #xd$))
  (setq #h   (nth 5 #xd$))
  (cond
    ;// �x�[�X�̐L�k�l
    ((or (= &grp "SIDEP1") (= &grp "SIDEP2"))
      (cond
        (or (= CG_Type1Code "A")(= CG_Type1Code "D")     ;�J�b�v�{�[�h
          (setq #h CG_CeilHeight)
          (setq #d (+ #d CG_PANEL_OFFSET))
        )
        ((= CG_Type1Code "B")     ;�J�E���^�[���j�b�g
          (setq #h (+ CG_CounterHeight CG_PANEL_OFFSET))
          (setq #d (+ CG_CounterDepth CG_PANEL_OFFSET))
        )
        ((= CG_Type1Code "C")     ;�R���r�l�[�V����
          (if
            (or (and (= (nth 11 CG_GLOBAL$) "R") (= &grp "SIDEP1"))
                (and (= (nth 11 CG_GLOBAL$) "L") (= &grp "SIDEP2"))
            )
            (setq #h CG_CeilHeight)
          ;else
            (setq #h (+ CG_CounterHeight CG_PANEL_OFFSET))
          )
          (setq #d (+ CG_CounterDepth CG_PANEL_OFFSET))
        )
      )
    )
    ;// �A�b�p�[�̐L�k�l
    (T
      (setq #fil-h (- CG_CeilHeight CG_UpCabHeight))
      (setq #h (+ #h #fil-h CG_PANEL_OFFSET))
      (setq #d (+ #d CG_PANEL_OFFSET))
    )
  )
  ;-----------------------------------------
  ; ���iCODE���擾
  ;-----------------------------------------
  (setq #qry$
;;;    (car ; 00/02/16 @YM@ �������� ADD
			(CFGetDBSQLHinbanTable
            "�i�Ԋ�{"
            &hin
            (list
              (list "�i�Ԗ���" &hin 'STR)
            )
       )
;;;    ) ; 00/02/16 @YM@ �������� ADD
  )

  (if (= #qry$ nil)
    (progn
			(setq #msg (strcat "�w�i�Ԋ�{�x�Ƀ��R�[�h������܂���.\nSDP_MakeSidePanel"))
      (CFOutStateLog 0 1 #msg)
			(CFAlertMsg #msg)
      (*error*)
    )
  )
	(CFOutStateLog 1 1 "*** �擾ں��� ***")
	(CFOutStateLog 1 1 #qry$)

	(if (= (length #qry$) 1) ; 00/02/16 @YM@ �������� ADD
		(progn
	  	(setq #qry$ (car #qry$))
		)
    (progn ; ����˯Ă����Ƃ��ʹװ
			(setq #msg (strcat "�w�i�Ԋ�{�x�Ƀ��R�[�h����������܂���.\nSDP_MakeSidePanel"))
      (CFOutStateLog 0 1 #msg)
			(CFAlertMsg #msg)
      (*error*)
    )
	);_if                    ; 00/02/16 @YM@ �������� ADD

  (setq #seikaku (nth 5 #qry$))
;;;  (if (/= #seikaku nil)
;;;    (CFOutLog 1 nil (strcat "  +���iCODE: " (rtos #seikaku)))
;;;  )
  ;-----------------------------------------
  ;�T�C�h�p�l����}������
  ;-----------------------------------------
  (command "_insert"  (strcat CG_MSTDWGPATH &file) &pt 1 1 &ang)
  (command "_explode" (entlast))                    ;�C���T�[�g�}�`����
  ;// ���������I���Z�b�g�Ŗ��O�̂Ȃ��O���[�v���쐬����
  (SKMkGroup (ssget "P"))

  ;// �g���f�[�^�̐ݒ�
  (setq #sym (SKC_GetSymInGroup (entlast)))
  (CFSetXData #sym "G_LSYM"
    (list
      &file         ;1 :�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID
      &pt           ;2 :�}���_          :�z�u��_
      (dtr &ang)    ;3 :��]�p�x        :�z�u��]�p�x
      ""            ;4 :�H��L��        :CG_Kcode
      ""            ;5 :SERIES�L��    :CG_SeriesCode
      &hin          ;6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���
      0            ;7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪
      ""            ;8 :���}�`ID        :
      ""            ;9 :���J���}�`ID    :
      (fix #seikaku)      ;10:���iCODE      :�w�i�Ԋ�{�x.���iCODE
      0             ;11:�����t���O      :�O�Œ�i�P�ƕ��ށj
      0             ;12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
      0             ;13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�
      0             ;14:���@�g          :�w�i�Ԑ}�`�x.���@�g
      0             ;15:�f�ʎw���̗L��  :�f�ʎw���̗L��
    )
  )
  ;// ���t����L���r�l�b�g�̃T�C�Y������W,D,H��ݒ肷��
  (setq #xd$ (CFGetXData #sym "G_SYM"))
  (CFSetXData #sym "G_SYM"
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
      (nth 11 #xd$)   ;�L�k�t���O�v
      #d
      #h
      (nth 14 #xd$)   ;�u���[�N���C�����v
      (nth 15 #xd$)   ;�u���[�N���C�����c
      (nth 16 #xd$)   ;�u���[�N���C�����g
    )
  )
)
;SDP_MakeSidePanel

;<HOM>*************************************************************************
; <�֐���>    : SDP_GetSidePanelPos
; <�����T�v>  : �T�C�h�p�l���̔z�u�����擾����
; <�߂�l>    :
;             : (LIST)�[�̕��ނ̊�_�Ɛ}�`���̃��X�g
;                  ((�ō��x�[�X�}�` ���W)
;                   (�ŉE�x�[�X�}�` ���W)
;                   (�ō��A�b�p�[�}�` ���W)
;                   (�ŉE�A�b�p�[�}�` ���W)
;                   (�ŉ��x�[�X�}�` ���W)
;                   (�ŉ��A�b�p�[�}�` ���W)
;                  )
; <�쐬��>    : 1999-10-10
; <���l>      :
;*************************************************************************>MOH<
(defun SDP_GetSidePanelPos (
    &base-en$     ;(LIST)�x�[�X�L���r�l�b�g�}�`�̃��X�g
    &uper-en$     ;(LIST)�A�b�p�[�L���r�l�b�g�}�`�̃��X�g
    &type         ;(STR)�T�C�h�p�l���̎�� (N,A,B,C,D)
    /
    #i #maxpt1 #minpt1 #maxpt2 #minpt2 #minypt #en #eg #pt 
		#maxen1 #minen1 #minypt1 #minyen1 #maxen2 #minen2 #minyen
		#MINYEN2 #MINYPT2
  )
	(CFOutStateLog 1 1 " ")
	(CFOutStateLog 1 1 "//// SDP_GetSidePanelPos ////")
	(CFOutStateLog 1 1 " ")

  (setq #i 0)
  (setq #maxpt1 (list -10000 0))
  (setq #minpt1 (list 10000 0))
  (setq #maxpt2 (list -10000 0))
  (setq #minpt2 (list 10000 0))
  (setq #minypt1 (list 0 10000))
  (setq #minypt2 (list 0 10000))
  (foreach #en &base-en$
    (setq #eg (entget #en))
    (setq #pt (cdr (assoc 10 #eg)))
    
    (if (< (car #maxpt1) (car #pt))
      (progn
        (setq #maxpt1 #pt)
        (setq #maxen1 #en)
      )
    )
    (if (> (car #minpt1) (car #pt))
      (progn
        (setq #minpt1 #pt)
        (setq #minen1 #en)
      )
    )
    (if (> (cadr #minypt1) (cadr #pt))
      (progn
        (setq #minypt1 #pt)
        (setq #minyen1 #en)
      )
    )
    (setq #i (1+ #i))
  )
  (foreach #en &uper-en$
    (setq #eg (entget #en))
    (setq #pt (cdr (assoc 10 #eg)))
    
    (if (< (car #maxpt2) (car #pt))
      (progn
        (setq #maxpt2 #pt)
        (setq #maxen2 #en)
      )
    )
    (if (> (car #minpt2) (car #pt))
      (progn
        (setq #minpt2 #pt)
        (setq #minen2 #en)
      )
    )
    (if (> (cadr #minypt2) (cadr #pt))
      (progn
        (setq #minypt2 #pt)
        (setq #minyen2 #en)
      )
    )
    (setq #i (1+ #i))
  )
  ;// ���ʂ�Ԃ�
  (list (list #minen1 #minpt1)
        (list #maxen1 #maxpt1)
        (list #minen2 #minpt2)
        (list #maxen2 #maxpt2)
        (list #minyen1 #minypt1)
        (list #minyen2 #minypt2)
  )
)
;SDP_GetSidePanelPos

;<HOM>*************************************************************************
; <�֐���>    : SDP_GetCounterTopHeight
; <�����T�v>  : �J�E���^�[�̍ŏ㕔�̍��������߂�
; <�߂�l>    :
;        REAL : ����
; <�쐬��>    : 1999-10-10
; <���l>      :
;*************************************************************************>MOH<
(defun SDP_GetCounterTopHeight (
    /
    #ss #i #en #xd$ #h
  )
	(CFOutStateLog 1 1 " ")
	(CFOutStateLog 1 1 "//// SDP_GetCounterTopHeight ////")
	(CFOutStateLog 1 1 " ")

  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (setq #i 0)
  (while (and (= #h nil) (< #i (sslength #ss)))
    (setq #en (ssname #ss #i))
    (setq #xd$ (CFGetXData #en "G_LSYM"))
    (if (= CG_SKK_ONE_CNT (CFGetSeikakuToSKKCode (nth 9 #xd$) 1))
      (progn
        (setq #xd$ (CFGetXData #en "G_SYM"))
        (setq #h (nth 2 (cdr (assoc 10 (entget #en)))))
        (setq #h (+ #h (nth 5 #xd$)))
        (setq CG_CounterHeight #h)
        (setq CG_CounterDepth  (nth 4 #xd$))
      )
    )
    (setq #i (1+ #i))
  )
)
;SDP_GetCounterTopHeight

(princ)
