;;;<HOM>*************************************************************************
;;; <�֐���>    : CFOutStateLog
;;; <�����T�v>  : ۸�̧�قɏ������e���o�͂���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 1998-06-16
;;; <���l>      : �{��۸��т͑S�Ď��ȏ����̂��߁A�ُ�I�������Ƃ��̌��������p�ɁA
;;;               �e������۸ނ�̧�قɂ܂Ƃ߂܂��B
;;;               ���� msg �̌`���� princ �ŏo�͂����`���ł悢
;;; <��۰���>   : ۸�̧�ٖ�   =  CG_LOGFILE
;;; CG_DEBUG=1 �̂Ƃ�۸ނ���������
;;;*************************************************************************>MOH<
(defun CFOutStateLog (
  &state  ; (INT)  ����A�ُ�A�x���׸ށi0:�ُ� 1:���� 2:�x���j
  &def    ; (INT)  �����T�v�׸�
  &msg    ; (???)  ���b�Z�[�W
  /
  #f
#LOGFILE #MOJI ; 02/09/03 YM ADD
  )
  ;(princ "\n")
  ;(princ &msg)
	(if (or (= &state nil)(= &def nil)(= &msg nil)) ; 01/02/12 YM ADD
		(princ)
		(progn
			(if (= CG_DEBUG 1) ; ���ޯ��Ӱ��=1�̂Ƃ��o��
				(progn

		      ;; ۸�̧�ٖ� #logfile
					(setq #moji (strlen CG_logfile))
					(setq #logfile (strcat (substr CG_LOGFILE 1 (- #moji 4)) "2.log"))

				  (if (and (= &state 0) (/= 'LIST (type &msg)))
				    (progn
				      (setq CG_ERRMSG (append CG_ERRMSG (list &msg)))
				    )
				  );_(if

				  (if
				    (and
				      (or (= 0 &state) (= 1 &state) (= 2 &state))
				      (= 'INT (type &def))
				    )
				    (progn
		;;;         (setq #f (open CG_LOGFILE "a")) ; "A" �ǉ����[�h  00/02/09 @YM@ MOD
		;;;		      (setq #f (open (strcat CG_LOGFILE "2") "a")) ; "A" �ǉ����[�h
				      (setq #f (open #logfile "a")) ; "A" �ǉ����[�h 00/02/17 YM MOD

				      (princ (itoa &state) #f)
				      (princ ":" #f)
				      (princ (itoa &def) #f)
				      (princ ":" #f)
				      (princ &msg #f)
				      (princ "\n" #f)
				      (close #f)
				    )
				  );_(if

				);_(progn
			);_(if (= CG_DEBUG 1)
		)
	);_if
  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : CFOutLog
; <�����T�v>  : ۸�̧�قɏ������e���o�͂���i���q�l�p�j
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-04-13
; <���l>      : �{��۸��т͑S�Ď��ȏ����̂��߁A�ُ�I�������Ƃ��̌��������p�ɁA
;               �e������۸ނ�̧�قɂ܂Ƃ߂܂��B
;               ���� msg �̌`���� princ �ŏo�͂����`���ł悢
; <��۰���>   :
;*************************************************************************>MOH<
(defun CFOutLog (
  &state  ; (INT)  ����A�ُ�A�x���׸ށi0:�ُ� 1:���� 2:�x���j
  &def    ; (INT)  �i���i0:���o��0 1:���o���P 2:���o���Q 3:���o���R nil:�{���j
  &msg    ; (???)  ���b�Z�[�W
  /
  #m0 #m1 #m2 #m3 #s2 #s3 #s4 #f
  )
	; ۸ނ��߽���ʂ��ĂȂ��Ƃ��͌x���\�������Ă��p�����s����
	(setq #f (open CG_LOGFILE "a")) ; 01/10/03 YM

	(if #f ; 01/10/03 YM
		; ۸ނ��߽���ʂ��Ă���
		(if (or (= &state nil)(= &msg nil)) ; 01/02/12 YM ADD
			(princ)
			(progn
			  (setq #m0 "///////////////////////////////////////////////////////////////////")   ;���o���O
			  (setq #m1 "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")   ;���o���P
			  (setq #m2 "==================================")   ;���o���Q
			  (setq #m3 "----------------------------------")   ;���o���R
			  (setq #s2 "    ")                         ;�C���f���g�i���o���Q�j
			  (setq #s3 "        ")                     ;�C���f���g�i���o���R�j
			  (setq #s4 "        |  ")                  ;�C���f���g�i�{���j
			  (if
			    (and
			      (or (= 0 &state) (= 1 &state) (= 2 &state))
			      (or (= nil &def) (= 'INT (type &def)))
			    )
			    (progn
			      (princ "\n")
			      (princ &msg)
	;;; 		      (setq #f (open CG_LOGFILE "a")) ; 01/10/03 YM ��Ɉړ�
			      (cond
			        ((and (= 0 &state) (= nil &def))
			          ;// �G���[���O�o�͗p������ɒǉ�����
			          (setq CG_ERRMSG (append CG_ERRMSG (list &msg)))
			        )
			        ((and (= 0 &state) (/= nil &def))
			          (princ (itoa &state) #f)
			          (princ ":��ERROR:" #f)
			          (princ &msg #f)
			          (princ "\n" #f)
			        )
			        ((= 0 &def)
			          ;�P�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #m0 #f)
			          (princ "\n" #f)
			          ;�Q�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ &msg #f)
			          (princ "\n" #f)
			          ;�R�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #m0 #f)
			          (princ "\n" #f)
			        )
			        ((= 1 &def)
			          ;�P�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #m1 #f)
			          (princ "\n" #f)
			          ;�Q�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ &msg #f)
			          (princ "      " #f)
			          (princ (menucmd "M=$(edtime, $(getvar,date),YYYY�N M�� D�� DDDD - H:MM:SSam/pm)") #f)
			          (princ "\n" #f)
			          ;�R�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #m1 #f)
			          (princ "\n" #f)
			        )
			        ((= 2 &def)
			          ;�P�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s2 #f)
			          (princ #m2 #f)
			          (princ "\n" #f)
			          ;�Q�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s2 #f)
			          (princ &msg #f)
			          (princ "\n" #f)
			          ;�R�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s2 #f)
			          (princ #m2 #f)
			          (princ "\n" #f)
			        )
			        ((= 3 &def)
			          ;�P�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s3 #f)
			          (princ #m3 #f)
			          (princ "\n" #f)
			          ;�Q�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s3 #f)
			          (princ &msg #f)
			          (princ "\n" #f)
			          ;�R�s��
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s3 #f)
			          (princ #m3 #f)
			          (princ "\n" #f)
			        )
			        ((= nil &def)
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s4 #f)
			          (princ &msg #f)
			          (princ "\n" #f)
			        )
			      )
			      (close #f)
			    )
			  );_if

			)
		);_if
		(progn ; 01/10/03 YM ADD
			(if (= nil CG_NO_LOGPATH)
				(if (= CG_AUTOMODE 0)
					(CFAlertErr (strcat "۸�̧�ق��߽���ʂ��ĂȂ����߁A۸ނ��o�͂ł��܂���B(ini̧�ق����m�F������)"
															"\n���s����͂Ȃ��̂ŏ������p�����܂��B"))
				; else
					(princ (strcat "۸�̧�ق��߽���ʂ��ĂȂ����߁A۸ނ��o�͂ł��܂���B(ini̧�ق����m�F������)"
															"\n���s����͂Ȃ��̂ŏ������p�����܂��B"))
				);_if
			; else
				(setq CG_NO_LOGPATH T) ; ۸�̧�ق��߽���ʂ��ĂȂ���T����͂���
			);_if
		)
	);_if  ; 01/10/03 YM
  (princ)
)

(princ)
