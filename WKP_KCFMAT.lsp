;(setq CG_KPDEPLOY_ARX_LOAD nil)  ;ARX�Ή��œW�J�}�쐬�œ��삳���邩�ǂ���
(setq CG_KPDEPLOY_ARX_LOAD T)  ;ARX�Ή��œW�J�}�쐬�œ��삳���邩�ǂ���
(setq CG_DoorZMove 650) ; ���}�`��Z����(�}�ʂ�XY���ʂƂ���)�ɉ����o���� 01/03/15 YM ADD
(setq CG_Yashi_OffY 250) ; ���ʐ}�ϰ��ʒu���炵 2011/06/14 YM ADD

;;;<HOF>************************************************************************
;;; <�t�@�C����>: SCFmat.LSP
;;; <�V�X�e����>: ******�V�X�e��
;;; <�ŏI�X�V��>: 00/03/13 ���� ���L
;;; <���l>      : �Ȃ�
;;;************************************************************************>FOH<
;@@@(princ "\nSCFmat.fas ��۰�ޒ�...\n")

;<HOM>*************************************************************************
; <�֐���>    : C:SCFMakeMaterial
; <�����T�v>  : �W�J���}�쐬
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-21
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun C:SCFMakeMaterial (
  /
#room_ss #room_en #idx
#ss #en #code$ #xd$
#D #W #ang #p1 #p2 #p3 #p4
#ss2 #idx2 #en2 #xdl2$
#lsymList$$
#qry$
#data$ #xdl$ #hinban #en2$ #eg #tmp
#enCp$ #enCpTmp$ #sym
  )
   ;;; �W�J���}�����̃��C�������́A�p�[�X�}���C�A�E�g�R�}���h�Ƌ��ʂ̂��߁A
   ;;; (SCFMakeMaterial2)�֐��ɕ������� 2000/10/10

  (WebOutLog "�װ�֐� SKAutoError2 ���`���܂�(C:SCFMakeMaterial)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�

  (cond
    ((= CG_AUTOMODE 1)
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError1)
      );_if
    )
    ((= CG_AUTOMODE 2)
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError2)
      );_if
    )
    ((= CG_AUTOMODE 3)
      (if (= 1 CG_DEBUG)
        nil
        ;else
        (setq *error* SKAutoError1)
      );_if
    )
  );_cond

;-- 2011/09/27 A.Satoh Del - S
;;;;;;-- 2011/09/19 A.Satoh Add - S
;;;;;  ; �{�H�}�o���������s��
;;;;;  (if (SCF_SekouLayer)
;;;;;    (progn
;;;;;;-- 2011/09/19 A.Satoh Add - E
;-- 2011/09/27 A.Satoh Del - E

;-- 2012/05/09 A.Satoh Add �p�[�X�}�����g�o�͑Ή� - S
;;;; �W�J�}�쐬���ɕ����g�}�`�̃��C����"0"�łȂ���΁A�����I��"0"�ɕύX����
	(setq #room_ss (ssget "X" '((-3 ("G_ROOM")))))
	(if #room_ss
		(progn
			(setq #idx 0)
			(repeat (sslength #room_ss)
				(setq #room_en (ssname #room_ss #idx))
				(if (/= (cdr (assoc 8 (entget #room_en))) "0")
					(command "_CHANGE" #room_en "" "P" "LA" "0" "")
				)
				(setq #idx (1+ #idx))
			)
		)
	)
;-- 2012/05/09 A.Satoh Add �p�[�X�}�����g�o�͑Ή� - E

;;  2005/11/30 G.YK ADD-S
  (setq CG_Material_View (getvar "VIEWDIR"))
  (command "_vpoint" "0,0,1");
;;  2005/11/30 G.YK ADD-E
  ; ��w�߰�� 01/07/17 YM ADD START
  (command "_purge" "LA" "0_*"   "N") ; �g���Ă��Ȃ���w���폜����.
  ; ��w�߰�� 01/07/17 YM ADD END

  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (StartUndoErr)
  );_if

;-- 2011/10/05 A.Satoh Add - S
  (setq CG_OSMODE_BAK (getvar "OSMODE"))
;-- 2011/10/05 A.Satoh Add - E

  (setq CG_TABLE nil) ; Table.cfg�o�͍ς��׸� 01/02/07 YM

  ; (�������p�̃t���O�ɂ���)
  (SCFStartShori "SCFMakeMaterial")

	; 2017/09/14 KY ADD-S
	; �t���[���L�b�`���Ή�
	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn
			;201709/21 YM ADD-S ��w��\���ɂ�����ڰт�rotate�ňʒu�����������Ȃ�����
		  (setvar "OSMODE"    0)
		  (setvar "GRIDMODE"  0)
		  (setvar "ORTHOMODE" 0)
		  (setvar "SNAPMODE"  0)
			;201709/21 YM ADD-E ��w��\���ɂ�����ڰт�rotate�ňʒu�����������Ȃ�̂����

			(command "_.ZOOM" "E")(command "_.ZOOM" "S" "0.8x")
			(setq #ss (ssget "X" '((-3 ("G_SYM")))))
			(if (and #ss (< 0 (sslength #ss)))
				(progn
					; �Ώۂ̃J�E���^�̗̈����G_LSYM�̃��X�g�̎擾
					(setq #lsymList$$ nil)
					(setq #idx 0)
					(repeat (sslength #ss)
						(setq #en (ssname #ss #idx))
						(setq #code$ (CFGetSymSKKCode #en nil))
						(if (equal #code$ (list CG_SKK_ONE_CNT CG_SKK_TWO_BAS CG_SKK_THR_DIN) 0.1) ; �J�E���^(717)
							(progn
								(setq #xd$ (CfGetXData #en "G_SYM"))
								(setq #D (nth 4 #xd$)) ; ���@D

;;; 2017/10/17YM								(if (> #D 800)
;;; 2017/10/17YM									(progn
										; �}�`�̈�̊p�S�_
										(setq #W (nth 3 #xd$)) ; ���@W
										(setq #ang (nth 2 (CfGetXData #en "G_LSYM"))) ; ��]�p�x
										(setq #p1 (cdr (assoc 10 (entget #en))))
										(setq #p2 (polar #p1 #ang #W))
										(setq #p3 (polar #p2 (- #ang (dtr 90)) #D))
										(setq #p4 (polar #p1 (- #ang (dtr 90)) #D))
										(setq #ss2 (ssget "CP" (list #p1 #p2 #p3 #p4 #p1) '((-3 ("G_LSYM")))))
										(if (and #ss2 (< 0 (sslength #ss2)))
											(progn
												(setq #idx2 0)
												(repeat (sslength #ss2)
													(setq #en2 (ssname #ss2 #idx2))
													(setq #xdl2$ (CfGetXData #en2 "G_LSYM"))
													(if (= nil (vl-position (list #en2 #xdl2$) #lsymList$$))
														(progn
															(setq #lsymList$$ (append #lsymList$$ (list (list #en2 #xdl2$))))
														);progn
													);if
													(setq #idx2 (1+ #idx2))
												);repeat
												(setq #ss2 nil)
											);progn
										);if

;;; 2017/10/17YM									);progn
;;; 2017/10/17YM								);if

							);progn
						);if
						(setq #idx (1+ #idx))
					);repeat
					(setq #ss nil)
					(if #lsymList$$ ; G_LSYM�̃��X�g�������
						(progn
							(setq #idx 0)
							(foreach #data$ #lsymList$$
								(setq #en (nth 0 #data$))
								(setq #xdl$ (nth 1 #data$))
								(setq #hinban (nth 5 #xdl$)) ; �i��
								(setq #qry$
												(CFGetDBSQLRec CG_DBSESSION "E�W�J�}���@�Ώ�"
													(list (list "�i�Ԗ���" #hinban 'STR))))
								(if (and #qry$ (= (length #qry$) 1))
									(progn
										(setq #ss2 (CFGetSameGroupSS #en))
										(setq #idx2 0 #en2$ nil)
										(repeat (sslength #ss2)
											(setq #en2 (ssname #ss2 #idx2))
											(setq #eg (entget #en2))
											(setq #tmp (cdr (assoc 8 #eg)))
											(setq #tmp (substr #tmp 1 4))
											(if (or (= #tmp "Z_01") (= #tmp "Z_03"))
												(progn ;2017/10/03 YM ADD-S
													(if (CfGetXData #en2 "G_PMEN")
														(princ) ;PMEN�͖�������B���̈悪�w�ʐ}���B�����Ă��܂�
														;else
														(setq #en2$ (append #en2$ (list #en2)))
													);_if
												) ;2017/10/03 YM ADD-S
											);if
											(setq #idx2 (1+ #idx2))
										);repeat
										(setq #ss2 nil)
;;(princ #hinban)(princ " ")(princ #en)(princ " ")(princ #en2$)(princ "\n")
										(setq #p1 nil #p2 nil #enCpTmp$ nil)
										(mapcar '(lambda (#sym)
															(setq #xd$ (CfGetXData #sym "G_SYM"))
															(setq #xdl$ (CfGetXData #sym "G_LSYM"))
;;(princ (entget #sym))(princ "\n")
;;;;(princ #xd$)(princ "\n")
;;;;(princ "\n")
															(setq #en2 nil)
															; ��]����
															(if #xd$
																(progn
																	(setq #p1 (cdr (assoc 10 (entget #sym))))
																	(setq #W (nth 3 #xd$)) ; ���@W
																	(setq #ang (nth 2 #xdl$)) ; ��]�p�x
																	(setq #p2 (polar #p1 #ang (/ #W 2.0))) ; ��]��_
																	(command "_.ROTATE" #sym "" #p2 "C" "180")
																	(setq #en2 (entlast))
																	(CFSetXData #en2 "G_SYM" #xd$)
																	(setq #p3 (mapcar '(lambda (#1 #2) (- (* #2 2.0) #1)) #p1 #p2)) ; ��]��̑}���_���W
																);progn
																;else
																(progn
																	(if (and #p1 #p2)
																		(progn
																			(command "_.ROTATE" #sym "" #p2 "C" "180")
																			(setq #en2 (entlast))
																		);progn
																	);if
																);progn
															);if
															(if #en2
																(progn
																	(setq #enCpTmp$ (append #enCpTmp$ (list #en2)))
																	(if (= nil (tblsearch "APPID" "G_DEL")) (regapp "G_DEL"))
																	(CFSetXData #en2 "G_DEL" (list 1))
																	(if #xdl$
																		(progn
																			(CFSetXData #en2 "G_LSYM"
																				(CFModList #xdl$
																					(list (list 1 #p3)
																								(list 2 (+ #ang PI))
																								(list 5 "�ް���а"))))
																		);progn
																	);if
																);progn
															);if
														)
													(cons #en #en2$) ; ����ِ}�`���ŏ��ɂȂ�悤�ɓn��(�g���f�[�^�擾�̂���)
												)
										; �R�s�[�����}�`�̃O���[�v��
										(setq #ss (ssadd))
										(mapcar '(lambda (#sym) (ssadd #sym #ss)) #enCpTmp$)
										(SKMkGroup #ss)
										(setq #ss nil)
										(setq #enCp$ (append #enCp$ #enCpTmp$))
									);progn
								);if
								(setq #idx (1+ #idx))
							);foreach
						);progn
					);if
				);progn
			);if
		);progn
	);if
	; 2017/09/14 KY ADD-E

  ; �W�J���}�쐬����
    (if (= CG_KPDEPLOY_ARX_LOAD T)
      (setq CG_TENKAI_OK (SCFMakeMaterialArx))  ;�W�J�}ARX�Ή���(���݂͂�����j
      (setq CG_TENKAI_OK (SCFMakeMaterial2))    ;�W�J�}LISP�Ή���
    )

		;2017/09/21 YM ADD OEM�łœ�������������
		(if CG_TENKAI_OK
			nil ;
			;else
;;;			(CFAlertErr "(SCFMakeMaterialArx) �߂�l CG_TENKAI_OK �� nil") ;2017/09/28 YM DEL
		);_if

;;;2008/08/02YM@DEL  ; �W�J���}�쐬����
;;;2008/08/02YM@DEL  (setq CG_TENKAI_OK (SCFMakeMaterial2)) ; �߂�l�ǉ� 01/02/20 YM

  ; ����������  Open���Ȃ����Ȃ��Ƃ����Ȃ����R ����������
  ; 1. �J���Ȃ����ăO���[�v������������Ă��܂���Q�i���̎���肪[���C�A�E�g]�ŏo�͂���Ȃ��j�����
  ; 2. 2000/06/22 ���}�`�쐬���̑��x���P�ɔ���"0_door"��w�ɍ쐬���A�W�J���}�p�ɂ̓R�s�[����̂�
  ;    "0_door"��w�ɕs�v�Ȑ}�`���c���Ă���̂�OPEN���Ȃ����Ȃ���΂Ȃ�Ȃ�
  ; 3. ; 2000/06/21 ���폜���[�h�ɕύX�i[���]-[�\������]���C�Ή��j�̂��߂�
  ;    SCFmat.lsp��(PCD_MakeViewAlignDoor #Dooren$ 2 T)�ŁA�����폜����悤�ɂ�������
  ; 4. �A������ ���ꂽ��Ԃ�胏�C�A�t���[���̂ق����������x����������
  ;    �R�}���h�ŏ��Ƀ��C�A�t���[���ɂ���
  ; ����������  Open���Ȃ����Ȃ��Ƃ����Ȃ����R ����������

;-- 2011/09/27 A.Satoh Add - S
  (if (= CG_TENKAI_OK nil)
    (progn
			; 2017/09/14 KY ADD-S
			; �t���[���L�b�`���Ή�
			(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
				(progn
					(if #enCp$
						(progn
							; �R�s�[�����}�`�̍폜
							(mapcar 'entdel #enCp$)
							(CfAutoSave)
						);progn
					);if
				);progn
			);if
			; 2017/09/14 KY ADD-E

      (princ "�W�J�}�쐬������ݾق��܂����B")
      (command "_.ZOOM" "P")
    )
    (progn
;-- 2011/09/27 A.Satoh Add - E

  (CFNoSnapFinish)

  ; �I������
  (SCFEndShori)

  ; �}�ʂ��I�[�v�����Ȃ���
  (WebOutLog "�����Ӱ��=8 �Ő}�ʍĵ���݂��܂�"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (setq CG_OPENMODE 8) ; 01/03/05 YM ADD ==>ACADDOC.LSP S::STARTUP

  ; ����Ӱ�ނł�SCFCmnFileOpen�������Ȃ�
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
    (progn
      (command "_.Open" "N" (strcat CG_KENMEI_PATH "MODEL.dwg"))
      (S::STARTUP)
    )
    ;else
    (SCFCmnFileOpen (strcat CG_KENMEI_PATH (getvar "DWGNAME")) 1) ; 2000/10/19 HT �֐���
  );_if

  ;���J���p��
  ;2010/11/30 YM ADD-S
  ;�f�o�b�N���[�h�Ȃ��̈���c������
  (if (and (= CG_DEBUG 1)(= CG_AUTOMODE 2))
    ;��̈��}(�֐���)
    (DrawYashiArea);2010/11/30 YM ADD
  );_if
  ;2010/11/30 YM ADD-E

;-- 2011/09/19 A.Satoh Add - S
    )
  )
;-- 2011/09/19 A.Satoh Add - E
;-- 2011/10/05 A.Satoh Add - S
  (setvar "OSMODE" CG_OSMODE_BAK)
  (setq CG_OSMODE_BAK nil)
;-- 2011/10/05 A.Satoh Add - E

  (princ)
) ; C:SCFMakeMaterial


;-- 2011/09/19 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : SCF_SekouLayer
; <�����T�v>  : �{�H�}�o���o����������
; <�߂�l>    : �Ȃ�
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
;(defun C:qqq (
(defun SCF_SekouLayer (
  /
  #dcl_id #layer5$ #layer6$ #layer19$ #layer20$ #layer21$
  #rec$$ #rec$ #layer #flag #rule$$
  #mode_flg5 #mode_flg6 #mode_flg19 #mode_flg20 #mode_flg21
  #wt_dat$$ #ss #idx #LR #oku$$ #oku$ #oku
  #delLay$
#sKatte ;2017/09/21 YM ADD
#KPCAD_KEY #LAYER19 #LAYER20 #LAYER21 #LAYER6 #RAD19M #RADFKL #RADFKM #RADFKR #RET #XD_WT$ ;2018/02/16 YM ADD
  )

;***********************************************************
  (defun ##DelLayer (
    &list$
    /
    #idx #no #string #layer$ #rec$ #layer #num #value #ret$
    #ss #i #en
;;; #rec$$�̓��[�J����`���Ȃ�
    )


    (setq #idx 0)
    (repeat (length &list$)
      (setq #no (nth 0 (nth #idx &list$)))
      (setq #string (nth 1 (nth #idx &list$)))

      (setq #layer$ nil)
      (foreach #rec$ #rec$$
        (setq #layer     (nth 0 #rec$))
        (setq #num (atoi (nth 1 #rec$)))
        (setq #value     (nth 2 #rec$))
        (if (= #no #num)
          (if (wcmatch #string #value)
            (progn
              ;","��؂�l��
              (setq #ret$ (StrParse #layer ","));��w��ؽ�
              (setq #layer$ (append #layer$ #ret$))
            )
          );_if
        )
      )

      ;����̉�w�̐}�`���폜
      (foreach #layer #layer$
        (setq #ss (ssget "X" (list (cons 8 #layer))))
        (if (and #ss (/= 0 (sslength #ss)))
          (progn
            (setq #i 0)
            (repeat (sslength #ss)
              (setq #en (ssname #ss #i))
              (if (entget #en)
                (entdel #en)
              );_if
              (setq #i (1+ #i))
            );repeat
          )
        );_if
      );foreach

      (setq #idx (1+ #idx))
    )

  ) ; ##DelLayer
;***********************************************************
  (defun ##SekouExec (
    /
;;; #rule$$ #wt_dat$$�̓��[�J���錾���Ȃ�
    #delLayer$ #rule$ #value #err_flag #wt_dat$
    #rad5L #rad5R #rad20L #rad20R #rad6L #rad6R #rad21L #rad21R #rad19L 
    #rad19R
		#counters$$ #counter$
    )

    (setq #err_flag nil)
    (setq #delLayer$ nil)
    (setq #rad5L (get_tile "rad5L"))
    (setq #rad5R (get_tile "rad5R"))
    (setq #rad20L (get_tile "rad20L"))
    (setq #rad20R (get_tile "rad20R"))

		;2018/02/15 YM ADD-S
    (setq #radFKL (get_tile "radFKL"))
    (setq #radFKM (get_tile "radFKM"))
    (setq #radFKR (get_tile "radFKR"))
		;2018/02/15 YM ADD-E

    (setq #rad6L  (get_tile "rad6L"))
    (setq #rad6R  (get_tile "rad6R"))
    (setq #rad21L (get_tile "rad21L"))
    (setq #rad21R (get_tile "rad21R"))
    (setq #rad19L (get_tile "rad19L"))
    (setq #rad19M (get_tile "rad19M"))
    (setq #rad19R (get_tile "rad19R"))

    (if (and
          (= #rad5L  "0") (= #rad5R  "0")
          (= #rad20L "0") (= #rad20R "0")
          (= #radFKL "0") (= #radFKM "0") (= #radFKR "0") ;2018/02/15 YM ADD
          (= #rad6L  "0") (= #rad6R  "0")
          (= #rad21L "0") (= #rad21R "0")
          (= #rad19L "0") (= #rad19M "0") (= #rad19R "0")
        ) ;�{���͂����`�F�b�N�ł͂Ȃ��B�S���I�����ĂȂ������Ƃ������G���[���o�Ȃ��B�P�ł��I������ƃX���[���Ă��܂��B
      (progn
        (setq #err_flag T)
        (alert "�{�H�}�o���������ݒ肳��Ă��܂���B")
      )
    );_if

    (if (= #err_flag nil)
      (progn
        (foreach #rule$ #rule$$
          (cond
            ((= (atoi (nth 1 #rule$)) 5)
              (if (and (= #rad5L "1") (= #rad5R "0"))
                (progn
                  (setq #value (nth 3 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 5 #value))))
                )
              )
              (if (and (= #rad5L "0") (= #rad5R "1"))
                (progn
                  (setq #value (nth 5 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 5 #value))))
                )
              )
            )
            ((= (atoi (nth 1 #rule$)) 6)
              (if (and (= #rad6L "1") (= #rad6R "0"))
                (progn
                  (setq #value (nth 3 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 6 #value))))
                )
              )
              (if (and (= #rad6L "0") (= #rad6R "1"))
                (progn
                  (setq #value (nth 5 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 6 #value))))
                )
              )
            )
            ((= (atoi (nth 1 #rule$)) 19)

              (if (and (= #rad19L "1") (= #rad19M "0") (= #rad19R "0")) ;���ؐ���250
                (progn
                  (setq #value (nth 3 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 19 #value))))
                )
              )

              (if (and (= #rad19L "0") (= #rad19M "0") (= #rad19R "1")); ���؈ȊO�P�T�O
                (progn
                  (setq #value (nth 5 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 19 #value))))
                )
              )


              (if (and (= #rad19L "0") (= #rad19M "1") (= #rad19R "0")) ;����U�蕝�Q�O�O
                (progn
                  (setq #value (nth 7 #rule$)) ;�t�B�[���h�ǉ�
                  (setq #delLayer$ (append #delLayer$ (list (list 19 #value))))
                )
              )


            )
            ((= (atoi (nth 1 #rule$)) 20)
              (if (and (= #rad20L "1") (= #rad20R "0"))
                (progn
                  (setq #value (nth 3 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 20 #value))))
                )
              )
              (if (and (= #rad20L "0") (= #rad20R "1"))
                (progn
                  (setq #value (nth 5 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 20 #value))))
                )
              )
            )
            ((= (atoi (nth 1 #rule$)) 21)
              (if (and (= #rad21L "1") (= #rad21R "0"))
                (progn
                  (setq #value (nth 3 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 21 #value))))
                )
              )
              (if (and (= #rad21L "0") (= #rad21R "1"))
                (progn
                  (setq #value (nth 5 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 21 #value))))
                )
              )
            )
          )
        )

        (foreach #wt_dat$ #wt_dat$$
          (setq #delLayer$ (append #delLayer$ (list (list 7 (nth 0 #wt_dat$)))))
          (setq #delLayer$ (append #delLayer$ (list (list 11 (nth 1 #wt_dat$)))))
        )
        (setq #delLayer$ (append #delLayer$ (list (list 18 "A"))))
        (setq #delLayer$ (append #delLayer$ (list (list 22 "C01"))))

        ; �Ώۉ�w��̐}�`���폜
        (##DelLayer #delLayer$)

				;2018/02/15 YM ADD-S FK�Ή��yST�{�H�\��2�z�Q��
;;;		    (setq #radFKL (get_tile "radFKL"))
;;;		    (setq #radFKM (get_tile "radFKM"))
;;;		    (setq #radFKR (get_tile "radFKR"))

;;;���W�I�{�^������
;;;���w�ʕǗp  ���E�Ǘp(FK)  �����Ǘp(FK)
				(cond
					((= #radFKL "1") ;���w�ʕǗp
					 	(setq #KPCAD_KEY "RADIO_1") ;�yST�{�H�\��2�z����KEY
				 	)
					((= #radFKM "1") ;���E�Ǘp(FK)
					 	(setq #KPCAD_KEY "RADIO_2") ;�yST�{�H�\��2�z����KEY
				 	)
					((= #radFKR "1") ;�����Ǘp(FK)
					 	(setq #KPCAD_KEY "RADIO_3") ;�yST�{�H�\��2�z����KEY
				 	)
					(T
					 	(setq #KPCAD_KEY "")
				 	)
				);cond

				;�yST�{�H�\��2�z����
				;2018/02/16 YM ADD 2�̏����Ŏ{�H�}�o���킯 IH (FK�Ή�)�yST�{�H�\��2�z�ɐ������ڂ���
			  (ST_DelLayer2 #KPCAD_KEY)


				

				;2018/02/15 YM ADD-E

        (done_dialog)

        T
      )
    )
  ) ; ##SekouExec
;***********************************************************


;***********************************************************
  (defun ##IH (    /	 #rad20L    )
    (setq #rad20L (get_tile "rad20L"))

    (if (= #rad20L "1") ;IH������
      (progn ;����
        (mode_tile "radFKL" 0)
        (mode_tile "radFKM" 0)
        (mode_tile "radFKR" 0)
      )
    );_if

    (if (= #rad20L "0") ;IH�ȊO������
      (progn ;�񊈐�
        (mode_tile "radFKL" 1)
        (mode_tile "radFKM" 1)
        (mode_tile "radFKR" 1)
        (set_tile "radFKL" "0")
        (set_tile "radFKM" "0")
        (set_tile "radFKR" "0")
      )
    );_if


  ) ; ##IH
;***********************************************************


  ; �}�ʏ�̓V�̉��s�����擾����
  (setq #wt_dat$$ nil)
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if #ss
    (progn
      (setq #idx 0)
      (repeat (sslength #ss)
        (setq #xd_wt$ (CFGetXData (ssname #ss #idx) "G_WRKT"))
        (setq #LR (nth 30 #xd_wt$))
        (setq #oku$$
          (CFGetDBSQLRec CG_DBSESSION "���s"
            (list
              (list "���s" (itoa (fix (+ (car (nth 57 #xd_wt$)) 0.01))) 'INT)
            )
          )
        )
        (if (and #oku$$ (= 1 (length #oku$$)))
          (progn
            (setq #oku$ (nth 0 #oku$$))
            (setq #oku (nth 1 #oku$))
          )
          (setq #oku "-")
        )

        ;(setq #wt_dat$$ (append #wt_dat$ (list (list #oku #LR)))) ; #wt_dat$ ==> #wt_dat$$ ����
        (setq #wt_dat$$ (append #wt_dat$$ (list (list #oku #LR)))) ; #wt_dat$ ==> #wt_dat$$ ����

        (setq #idx (1+ #idx))
      )
    )
  )
	; 2017/06/12 KY ADD-S
	; �t���[���L�b�`���Ή�(���[�N�g�b�v���Ȃ����ߏo���������ł��Ȃ�=>�J�E���^�[�̉��s���ŏ���)
	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn
			(setq #oku "")
			(setq #counters$$ (GetFrameInfo$$ nil T))
			(setq #counters$$ (nth 1 #counters$$))
			(foreach #counter$ #counters$$
				(if (= #oku "")
					(progn
						(setq #oku (strcat "D" (itoa (fix (+ (nth 1 (nth 3 #counter$)) 0.1)))))
						;(princ "\n�J�E���^�[���s��: ")(princ #oku)(princ "\n")
						(setq #LR "?")

						;�ڰѷ���(�V���Ȃ�) L/R�̓��[�U�[�ɕ��� ;2017/09/21 YM ADD-S
						(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
							(progn
								(setq #iType1 0) ;I�^
					      (initget 1 "L R")
					      (setq #sKatte (getkword "\n���E������w�� /L=������/R=�E����/:  "))
								(setq CG_FK_LP #sKatte);2017/09/21 YM ADD �ڰѷ��ݍ��E����
								(setq #LR #sKatte)
							)
						);_if

						(setq #wt_dat$$ (append #wt_dat$$ (list (list #oku #LR))))
					);progn
				);if
			);foreach
		);progn
	);if
	; 2017/06/12 KY ADD-E

  ; KP�{�H�\���������X�g���쐬����
  (setq #rule$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "KP�{�H�\������")))

  ; �{�H�\���Ώۉ�w���X�g���쐬����
  (setq #layer5$ nil #layer6 nil #layer19 nil #layer20 nil #layer21 nil)
  (setq #mode_flg5 nil #mode_flg6 nil #mode_flg19 nil #mode_flg20 nil #mode_flg21 nil)
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "ST�{�H�\��")))
  (foreach #rec$ #rec$$
    (setq #layer     (nth 0 #rec$))
    (setq #num (atoi (nth 1 #rec$)))
    (cond
      ((= #num 5)
        (setq #layer5$ (append #layer5$ (StrParse #layer ",")))
      )
      ((= #num 6)
        (setq #layer6$ (append #layer6$ (StrParse #layer ",")))
      )
      ((= #num 19)
        (setq #layer19$ (append #layer19$ (StrParse #layer ",")))
      )
      ((= #num 20)
        (setq #layer20$ (append #layer20$ (StrParse #layer ",")))
      )
      ((= #num 21)
        (setq #layer21$ (append #layer21$ (StrParse #layer ",")))
      )
    )
  )

  ; �g���Ă��Ȃ���w���폜����
  (command "_purge" "LA" "*" "N")

  ; �{�H�\���Ώۉ�w��̐}�`���݃`�F�b�N
  ;;; �����ԍ�5
  (setq #flag nil)
  (foreach #layer #layer5$
    (if (= #flag nil)
      (if (ssget "X" (list (cons 8 #layer)))
        (setq #flag T)
      )
    )
  )
  ;(if (= #flag1 nil) ; #flag1 ==> #flag ����
  (if (= #flag nil) ; #flag1 ==> #flag ����
    (setq #mode_flg5 T)
  )

  ;;; �����ԍ�6
  (setq #flag nil)
  (foreach #layer #layer6$
    (if (= #flag nil)
      (if (ssget "X" (list (cons 8 #layer)))
        (setq #flag T)
      )
    )
  )
  (if (= #flag nil)
    (setq #mode_flg6 T)
  )

  ;;; �����ԍ�19
  (setq #flag nil)
  (foreach #layer #layer19$
    (if (= #flag nil)
      (if (ssget "X" (list (cons 8 #layer)))
        (setq #flag T)
      )
    )
  )
  (if (= #flag nil)
    (setq #mode_flg19 T)
  )

  ;;; �����ԍ�20
  (setq #flag nil)
  (foreach #layer #layer20$
    (if (= #flag nil)
      (if (ssget "X" (list (cons 8 #layer)))
        (setq #flag T)
      )
    )
  )
  (if (= #flag nil)
    (setq #mode_flg20 T)
  )

  ;;; �����ԍ�21
  (setq #flag nil)
  (foreach #layer #layer21$
    (if (= #flag nil)
      (if (ssget "X" (list (cons 8 #layer)))
        (setq #flag T)
      )
    )
  )
  (if (= #flag nil)
    (setq #mode_flg21 T)
  )

  (if (and (= #mode_flg5 T) (= #mode_flg6 T) (= #mode_flg19 T) (= #mode_flg20 T) (= #mode_flg21 T))
    (progn
      (setq #delLay$ nil)
      (foreach #wt_dat$ #wt_dat$$
        (setq #delLay$ (append #delLay$ (list (list 7 (nth 0 #wt_dat$)))))
        (setq #delLay$ (append #delLay$ (list (list 11 (nth 1 #wt_dat$)))))
      )
      (setq #delLayer$ (append #delLay$ (list (list 18 "A"))))
      (setq #delLayer$ (append #delLay$ (list (list 22 "C01"))))

      ; �����폜���ڂɊY�������w��̐}�`���폜
      (##DelLayer #delLay$)

      (setq #ret T)
    )
    (progn
      ; �_�C�A���O�\��
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
      (if (= nil (new_dialog "SEKOU_Dlg" #dcl_id)) (exit))

      ; �o�������Ώۉ�w�ɐ}�`�����݂��Ȃ��ꍇ�́A���W�I�{�^����񊈐�
      (if (= #mode_flg5 T)
        (progn ;P�^ or I�^,L�^
          (mode_tile "rad5L" 1)
          (mode_tile "rad5R" 1)
        )
      )

      (if (= #mode_flg6 T)
        (progn ;��ٽײ��,�нײ��
          (mode_tile "rad6L" 1)
          (mode_tile "rad6R" 1)
        )
      )

      (if (= #mode_flg19 T)
        (progn ;�����@��������
          (mode_tile "rad19L" 1)
          (mode_tile "rad19M" 1)
          (mode_tile "rad19R" 1)
        )
      )

      (if (= #mode_flg20 T)
        (progn ;20L=IH,20R=�޽
          (mode_tile "rad20L" 1)
          (mode_tile "rad20R" 1)
					;2018/02/16 YM ADD
	        (mode_tile "radFKL" 1)
	        (mode_tile "radFKM" 1)
	        (mode_tile "radFKR" 1)
        )
      )

; ׼޵���ݑI����Ԃɂ���ɂ� (set_tile "radFKR" "1")
; ׼޵���݂̒l���擾����ɂ� (setq #rad5L (get_tile "rad5L"))

;;;			;IH�̂Ƃ�
;;;			;2018/02/15 YM ADD-S
;;;      (if (= #mode_flg99 T)
;;;        (progn ;20L=IH,20R=�޽
;;;          (mode_tile "radFKL" 1)
;;;          (mode_tile "radFKM" 1)
;;;          (mode_tile "radFKR" 1)
;;;        )
;;;      )
;;;			;2018/02/15 YM ADD-E

      (if (= #mode_flg21 T)
        (progn ;�����,��ۂ̂�
          (mode_tile "rad21L" 1)
          (mode_tile "rad21R" 1)
        )
      )


;2016/06/10 YM ADD ���������ӂ蕝�Q�O�O�͈ꎞ�I�Ƀ��W�I�{�^���񊈐�
(mode_tile "rad19M" 1)
;2016/06/10 YM ADD ���������ӂ蕝�Q�O�O�͈ꎞ�I�Ƀ��W�I�{�^���񊈐�

			;2018/02/15 YM ADD
      (action_tile "rad20L" "(setq #ret (##IH))")
      (action_tile "rad20R" "(setq #ret (##IH))")

      (action_tile "accept" "(setq #ret (##SekouExec))")
      (action_tile "cancel" "(setq #ret nil) (done_dialog)")

      (start_dialog)

      (unload_dialog #dcl_id)
    )
  )

  #ret

) ;SCF_SekouLayer
;-- 2011/09/19 A.Satoh Add - S

;;;<HOM>*************************************************************************
;;; <�֐���>    : ST_DelLayer2
;;; <�����T�v>  : �ꕔ�s�v�Ȏ{�H�}��w�̐}�`���폜����
;;; <�߂�l>    : �Ȃ�
;;; <����>      : ��w��ؽ�(ܲ��޶���OK)
;;; <�쐬>      : 2018/02/16 YM ADD
;;; <���l>      : KPCAD�p(EASY�p�Ə������Ⴄ)
;;;*************************************************************************>MOH<
(defun ST_DelLayer2 (
	&KPCAD_KEY ;����KEY
  /
  #EN #I #LAYER #LAYER$ #NUM #REC$$ #SS #VALUE #RET$
	#NUM1 #NUM2 #QRY$ #VALUE1 #VALUE2
  )
  (setq #layer$ nil)

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "ST�{�H�\��2"
      (list
        (list "KPCAD_KEY"  &KPCAD_KEY  'STR)
      )
    )
  )
	(if #qry$
		(progn
			
			(setq #qry$ (car #qry$))
		  (setq #layer (nth 0 #qry$))
		  ;","��؂�l��
		  (setq #layer$ (StrParse #layer ","));��w��ؽ�

		  ;����̉�w�̐}�`���폜
		  (foreach #layer #layer$
		    (setq #ss (ssget "X" (list (cons 8 #layer))))
		    (if (and #ss (/= 0 (sslength #ss)))
		      (progn
		        (setq #i 0)
		        (repeat (sslength #ss)
		          (setq #en (ssname #ss #i))
		          (if (entget #en)
		            (entdel #en)
		          );_if
		          (setq #i (1+ #i))
		        );repeat
		      )
		    );_if
		  );foreach

    )
  );_if
  
  (princ)
);ST_DelLayer2


;<HOM>*************************************************************************
; <�֐���>    : SCFMakeMaterial2
; <�����T�v>  : �W�J���}�쐬���C������
; <�߂�l>    : �Ȃ�
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCFMakeMaterial2 (
  /
  #clayer #cecolor #osmode #kind$$ #kind$ #ang$ #DclRet$ #Kind$ #zmove
  #Skind$ #no #ssD #yashi #ang #ssdoor #z$ #save
 #MSG ; 03/06/10 YM ADD
  ; 2000/07/06 HT YASHIAC  ��̈攻��ύX
  #find #i #xSp #xSs
  #sView  ; �}�ʎ��
  )
  ;03/07/17 YM ADD-S
  (setq CG_SUISEN_YUKA "N") ; "N"(�]���̐���ǂ���)
  ;03/07/17 YM ADD-E

  (WebOutLog "�W�J���}�쐬���C������(SCFMakeMaterial2)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�

  ; 2000/06/14 HT �ŏ��ɐ}�ʕۑ����čŌ�ɊJ���Ȃ���

  ; 01/09/07 YM MOD-S ����Ӱ�ނł͕ۑ����Ȃ�-->save�̂�

  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
    (progn
      ; ����Ӱ�ނ̂Ƃ�"MODEL.DWG"��j���I������"MODEL.DWG"��OPEN�ł��Ȃ����ߖ��O��ς��ĕۑ����Ă���
      ; �j���I�����Ȃ��ƃR�����̊G����������Ă��܂�
;;;     (command ".qsave") ; 101/10/01 YM MOD
;;;     (if (findfile (strcat CG_SYSPATH "auto.dwg")) ; 01/10/02 YM ADD-S
      ;06/06/16 AO MOD �ۑ��`����2004�ɕύX
      ;(command "_saveas" "2000" (strcat CG_SYSPATH "auto.dwg"))
;-- 2011/10/06 A.Satoh Mod - S
;;;;;      (command "_saveas" CG_DWG_VERSION (strcat CG_SYSPATH "auto.dwg"))
      (command "_saveas" CG_DWG_VER_MODEL (strcat CG_SYSPATH "auto.dwg"))
;-- 2011/10/06 A.Satoh Mod - E
    )
    (CFAutoSave)
  );_if
  ; 01/09/07 YM MOD-E ����Ӱ�ނł͕ۑ����Ȃ�

  ; 06/09/20 T.Ari ADD ��_���W��G_LSYM�ɐݒ肵�Ȃ���
  (SCFWFModGLSymPosAngle)

  (CFNoSnapReset);00/08/25 SN ADD
  (CFNoSnapStart);00/08/25 SN ADD

  ; 04/04/08 ADD-S �Ζʃv�����Ή�
  ; �����̎���viewpoint �̈ʒu�ɂ���Ă͏������f����鎖�����邽��
  ; �r���[������������
  (command "_.VPOINT" "0,0,1")
  ; 04/04/08 ADD-E �Ζʃv�����Ή�

  ; (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" "0")
  ; (setq #cecolor (getvar "CECOLOR"))
  (setvar "CECOLOR" "BYLAYER")
  ; (setq #osmode (getvar "OSMODE"))
  (setvar "OSMODE" 0)

  (setvar "GRIDMODE" 0)  ; 2000/09/12 ���x���P
  (setvar "ORTHOMODE" 0) ; 2000/09/12 ���x���P
  (setvar "SNAPMODE" 0)  ; 2000/09/12 ���x���P

  ; 2000/07/06 HT YASHIAC  ��̈攻��ύX ADD
  (setq CG_UTypeWT nil)
  (setq CG_TABLE nil)

  (if (/= nil CG_KENMEI_PATH)
    (progn
      ; 2000/07/06 HT YASHIAC  ��̈攻��ύX START
      ;// ���o�[�W�����̖���x��
      (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))
      (if #xSp
        (progn
          (setq #i 0)
          (repeat (sslength #xSp)
            (if (= "LWPOLYLINE" (cdr (assoc 0 (entget (ssname #xSp #i)))))
              (CFAlertErr (strcat "���o�[�W�����̃V�X�e���b�`�c�ō쐬���ꂽ�������܂�.\n"
                                  "��폜�Ŗ���폜���Ă���W�J�}�쐬���ĉ�����"))
            )
            (setq #i (1+ #i))
          )
        )
      );_if
      ; 2000/07/06 HT YASHIAC  ��̈攻��ύX END

      ; 01/05/30 TM ADD EF�������̂�ABCD����Ȃ��ꍇ�͍�}���Ȃ�
      (if (and (SCFIsYashiType #xSp "*[EF]*") (not (SCFIsYashiType #xSp "*[ABCD]*")))
        (progn
          (CFAlertErr (strcat "ABCD�������܂���.\n"
                              "��ݒ��ABCD����쐬���ĉ�����"))
        )
        (progn
;;;(makeERR "�W�J1-1") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ �W�J-1-1
          ;�_�~�[�̈�ݒ�
          (WebOutLog "�_�~�[�̈�ݒ�(SetDummyArea)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
          (SetDummyArea)
          ;�f�[�^�l��
          (setq #kind$$ (GetMaterialData))
          (if (/= nil #kind$$)
            (progn
              (setq #kind$  (car  #kind$$))
              (setq #ang$   (cadr #kind$$))
              (if (/= CG_OUTCMDNAME "SCFLayPrs")
                (progn
                ;�W�J���}��ފl��
                ; �_�C�A���O�\��

                  ; 01/09/07 YM MOD-S ����Ӱ�ނł��޲�۸ޕ\�����Ȃ�
                  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
                ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
                    (setq #DclRet$ CG_AUTOMODE_TENKAI)
                    (setq #DclRet$ (SCFGetBlockKindDlg (mapcar 'car #kind$)))
                  );_if
                  ; 01/09/07 YM MOD-E ����Ӱ�ނł��޲�۸ޕ\�����Ȃ�

                )
                (progn
                ; �p�[�X���}�����쐬���C�A�E�g�̎�
                ; ���ʐ}���I�����ꂽ��ԂƂ���
                  (setq #DclRet$ (list (list 1 0 0) (list "0")))
                )
              );_if

              ;03/07/17 YM ADD-S
              (if (and #DclRet$ (nth 2 #DclRet$))
                (setq CG_SUISEN_YUKA (nth 2 #DclRet$)) ; "Y"(�����グ) or "N"(�]���̕ǂ���)
                ;else
                (setq CG_SUISEN_YUKA "N") ; "N"(�]���̕ǂ���)
              );_if
              ;03/07/17 YM ADD-E

              ; �W�J�}�쐬�`�F�b�N
              ; �}�ʍ쐬�p�f�[�^��
              ;   ((���ʐ}�p�f�[�^) (�W�J�}�p�f�[�^�̃��X�g) �d�l�}�쐬�L��)�̃��X�g�ɐ�������
              (setq #Kind$ (SCFCheckExpand #kind$ #DclRet$))
              (if (/= nil #Kind$)
                (progn
                  ;; �쐬�ςݓW�J���}���폜 01/07/27 HN ADD
                  ;; �m�F�_�C�A���O�\��
                  (KPfDelBlockDwg)

                  ; 2000/06/22 HT ADD ���x���P
                  ; �A������ ���ꂽ��Ԃ�胏�C�A�t���[���̂ق����������x������
                  ; ���C�A�t���[���ɂ���
                  (C:2DWire)
                  ; �f�ʎw��}�`�y�уo���[��������Z���W�ړ���
                  (setq #zmove 10000)
                  (princ "\n�W�J�}�쐬���c\n")
                  ; �R�����y�уV���N�A�����̒f�ʂ��L���r���ʂɈړ�
                  ; (PKC_MoveToSGCabinet) 2001/03/03 KS DEL

                  ;Head.cfg�t�@�C�������o��
                  ; (SKB_WriteHeadList) 2000/10/12 HT DEL CfAutoSave���őΉ�

                  ;// �������[�N�g�b�v���
                  (PKOutputWTCT)

                  ; 2000/06/30 HT �W�J���}�p��w���t���[�Yor���b�N����Ă������������
                  ;               �W�J���}�p��w���쐬����Ă���(�{�����肦�Ȃ�?)�ꍇ�̑Ή�
                  (SCF_LayDispOn
                    (list "0_door" "0_plane" "0_dim" "0_plin_1" "0_plin_2" "0_pers"
                          "0_side_A" "0_side_B" "0_side_C" "0_side_D" "0_side_E" "O_sode_F" "0_KUTAI"))
;;;(makeERR "�W�J1-2") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ �W�J-1-2
                  ;�̈斈�ɓW�J���}�쐬
                  ;-- ���ʐ} ... �ŏ��̃f�[�^
                  (if (/= nil (nth 0 #kind$))
                    (progn
                      (princ "\n���ʐ}�쐬���c\n")
                      (WebOutLog "���ʐ}�쐬���c"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
                      (mapcar
                       '(lambda ( #Skind$ )
                          (setq #no    (nth 0 #Skind$))           ; �̈�ԍ�
                          (setq #ssD   (nth 1 #Skind$))           ; �_�~�[�̈�I���G���e�B�e�B
                          (setq #yashi (nth 2 #Skind$))           ; ��̈�}�`��
                          ;(setq #ang   (cadr (assoc #no #ang$)))  ; �p�x
                          (setq #ang (cadr (nth 0 #ang$)))  ; �p�x

                          ;�_�~�[�̈�č쐬  00/04/07
                          (SetDummyAgain #ssD #yashi)
                          (if (/= CG_OUTCMDNAME "SCFLayPrs")
                            (SCFMakeBlockPlan "P" #no #ssD #yashi #ang "0_PLANE" "0_DIM")
                          )
                          (SCFMakeBlockPers "M" #no #ssD #yashi #ang "0_PERS")
                        )
                        (nth 0 #kind$)
                      )
                    )
                  )
                  ;-- �d�l�}���쐬���邩�H
                  (if (/= nil (nth 2 #kind$))
                    (progn
                      (princ "\n�d�l�}�쐬���c\n")
                      (WebOutLog "�d�l�}�쐬���c"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
    ;;;01/03/25YM@                  ; 01/05/22 YM 2��ڈȍ~�d�l�\�ԍ��������Ȃ��Ȃ�
    ;;;01/03/25YM@                  (setq #sFname (strcat CG_KENMEI_PATH "TABLE.CFG"))
    ;;;01/03/25YM@                  (if (= (findfile #sFname) nil)
    ;;;01/03/25YM@                    (SCFMakeBlockTable);Table.cfg������������Ώ����o���B
    ;;;01/03/25YM@                  );_if
                      (SCFMakeBlockTable)  ;�d�l�� �Â��^�C�v��Table.cfg�o�͂��Ȃ�

                      (setq CG_TABLE T) ; Table.cfg�쐬�׸� 01/02/07 YM

                    )
                  )
                  ;-- �W�J�} ... �Q�Ԗڂ̃f�[�^
                  (if (/= nil (nth 1 #kind$))
                    (progn
                      (princ "\n�W�J�}�쐬���c\n")
                      (WebOutLog "�W�J�}�쐬���c"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
                      ;2D���ʍ쐬
                      ; 2000/06/22 HT ADD ���x���P
                      ;(setq #ssdoor (AlignDoorBySym$ (mapcar 'cadr (nth 1 #kind$))))
                      (AlignDoorBySym$ (mapcar 'cadr (nth 1 #kind$)))
                      ; M_��w�̐}�`�����ׂč폜���� HT 2000/09/12  START
                      ; �p�[�X�}�쐬�� ��w"M_*"�̐}�`�����ׂč폜���đ��x���P���͂���
                      (setq #xSs (ssget "X" (list (cons 8 "M_*"))))
                      (if #xSs
                        (command "erase" #xSs "")
                      )
                      ; 01/06/06 TM MOD-S �}�ʂ̊p�x�f�[�^�擾��ύX
                      (foreach #Skind$ (nth 1 #kind$)
                        (setq #no    (nth 0 #Skind$))    ; �̈�ԍ�
                        (setq #ssD   (nth 1 #Skind$))    ; �_�~�[�̈�I���G���e�B�e�B
                        (setq #yashi (nth 2 #Skind$))    ; ��̈�}�`��;��̈攻��ύX�ɂ����nil
                                                         ; ����ɂ��A���[�N�g�b�v�擾���ɋ��̈�ł�
                                                         ;  ���肵�Ȃ��Ȃ�
                        ; 01/06/06 TM MOD �p�x�͐}�ʎ�ނ��ƂɈقȂ�̂ňȉ��Ŏ擾����悤�ɕύX
                        ;(setq #ang   (cadr (assoc #no #ang$)))  ; �p�x
                        (setq #z$    (nth 3 #Skind$))    ; �}�ʎ��

                        ;�_�~�[�̈�č쐬  00/04/07
                        (SetDummyAgain #ssD #yashi)

                        (if (and (/= nil #ssD) (/= 0 (sslength #ssD)))
                          (progn
                            (foreach #sView #z$
                              (if (and #sView (/= 0 #sView)) ; �W�J�}ABCDEF
                                (progn
                                  ; �}�ʎ�ނɑΉ������p�x�f�[�^���擾����
                                  (setq #ang (KCFGetExpandAngle #kind$$ #sView))
                                  (if #ang
                                    (progn
                                      ; �W�J�}����}����
                                      (SCFMakeBlockExpand
                                        (strcat "S" #sView) #no #ssD #yashi #ang
                                        (strcat "0_SIDE_" #sView) "0_DIM" #sView #zmove #ssdoor)
                                    )
                                  );_if
                                )
                              );_if
                            );_foreach
                          )
                        );_if
                      );_ foreach
                      ; 01/06/06 TM MOD-E �}�ʂ̊p�x�f�[�^�擾��ύX
                    )
                  );_if (/= nil (nth 1 #kind$))

                  (princ "\n�W�J�}�쐬���c�I��")
                  (WebOutLog "�W�J�}�쐬���c�I��"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
                  (setq #save T)
                )
              );_if (/= nil #Kind$)
            )
          );_if (/= nil #kind$$)
          ;�_�~�[�̈�폜
          (DelDummyArea)
        )
      );_if (not (SCFIsYashiType #xSp "*[ABCD]*"))
    )
    (progn
      (setq #msg "�������Ăяo����Ă��܂���")
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  )

  ; 2000/06/22 HT ADD  (�������p�̃t���O�N���A)
  (setq CG_OUTCMDNAME nil)

  ; 2000/06/14 HT �ŏ��ɐ}�ʕۑ����ĊJ���Ȃ���
  ; (if (/= nil #save)
  ;   ;�����I�ɕۑ�
  ;  (CFAutoSave)
  ; )
  ; (setvar "CLAYER" #clayer)
  ; (setvar "CECOLOR" #cecolor)
  ; (setvar "OSMODE" #osmode)
  ; (setq *error* nil)

;;;(makeERR "�W�J1-3") ; �����I�ɴװ�쐬@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ �W�J-1-3

;;;  (princ)
  #Kind$ ; 01/02/20 YM ADD �����ǉ�
) ; SCFMakeMaterial2

;<HOM>*************************************************************************
; <�֐���>    : KP_MakePrs
; <�����T�v>  : �߰��}�݂̂̍쐬(WEB�Ōďo���p)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 03/05/16 YM
; <���l>      : \BLOCK\M_0.dwg
;*************************************************************************>MOH<
(defun KP_MakePrs (
  /
  #ANG #KIND$ #KIND$$ #NO #SSD #YASHI
  )
  (SetDummyArea)
  (setq #kind$$ (GetMaterialData));�W�J���}�쐬�p�̃f�[�^���l������
  (setq #kind$  (car (car #kind$$)))
  (setq #no     (nth 0 #kind$))   ; �̈�ԍ�
  (setq #ssD    (nth 1 #kind$))   ; �_�~�[�̈�I���G���e�B�e�B
  (setq #yashi  (nth 2 #kind$))   ; ��̈�}�`��
  (setq #ang 0.0)                 ; �p�x
  (SCF_LayDispOn                  ;��\��or�t���[�Yor���b�N��������
    (list "0_door" "0_plane" "0_dim" "0_plin_1" "0_plin_2" "0_pers"
          "0_side_A" "0_side_B" "0_side_C" "0_side_D" "0_side_E" "O_sode_F" "0_KUTAI"))
  ;�_�~�[�̈�č쐬
  (SetDummyAgain #ssD #yashi)
  (SCFMakeBlockPers "M" #no #ssD #yashi #ang "0_PERS")
  #ssD ; �_�~�[�̈�I���G���e�B�e�B
);KP_MakePrs

;<HOM>*************************************************************************
; <�֐���>    : C:KP_MakePrsOnly
; <�����T�v>  : �߰��̂ݍč쐬
; <�߂�l>    : �Ȃ�
; <�쐬>      : 03/06/09 YM
; <���l>      :
;*************************************************************************>MOH<
(defun C:KP_MakePrsOnly (
  /
  #GRIDMODE #ORTHOMODE #OSMODE #SNAPMODE #ssD #SSSKDM
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)

  ;// �r���[��o�^
  (command "_view" "S" "TEMP_MkPrs")

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)

  ;�߰��쐬����
  (setq #ssD (KP_MakePrs)) ; �_�~�[�̈�I���G���e�B�e�B

  (if (and #ssD (< 0 (sslength #ssD)))
    (command "_erase" #ssD "")
  );_if

  (setq #ssSKDM (ssget "X" '((-3 ("G_SKDM")))))

  (if (and #ssSKDM (< 0 (sslength #ssSKDM)))
    (command "_erase" #ssSKDM "")
  );_if

  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)

  ;// �r���[��߂�
  (command "_view" "R" "TEMP_MkPrs")

  (setq *error* nil)
  (princ)
);C:KP_MakePrsOnly

;<HOM>*************************************************************************
; <�֐���>    : KCFGetExpangAngle
; <�����T�v>  : �W�J���}�^�W�J�}�̊p�x���擾����
; <�߂�l>    : �p�x
; <�쐬>      : 01/06/05 TM
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KCFGetExpandAngle (
  &kind$$   ; �W�J���}�쐬�p�f�[�^
  &sYashi   ; �ΏۂƂȂ��f�[�^
  /
  #kind$    ; �W�J���}�쐬�p�f�[�^�̖����
  #ang$     ; �W�J���}�쐬�p�f�[�^�̊p�x����
  #skk$ #saa$ #sss ; ����ϐ�
  #rRet     ; �߂�l
  )
  ; �f�[�^�𕪂���
  (setq #kind$  (car  &kind$$))
  (setq #ang$   (cadr &kind$$))

  ; �w�肵���}�ʎ�ނ̊܂܂��f�[�^��T��
  (mapcar
    '(lambda (#skk$ #saa$)
      (foreach #sss (nth 3 #skk$)
        (if (= 'STR (type #sss))
          (progn
            (if (= &sYashi #sss)           ; �}�ʎ��
              (progn
                (setq #rRet (cadr #saa$))
              )
            );_if
          )
        );_if
      );_foreach
    )
    #kind$ #ang$
  )
  #rRet

); KCFGetExpandAngle

;<HOM>*************************************************************************
; <�֐���>    : GetMaterialData
; <�����T�v>  : �W�J���}�쐬�p�̃f�[�^���l������
; <�߂�l>    : (((���ʂ� �̈�ԍ��A�_�~�[�̈�I���G���e�B�e�B�[�A��̈�}�`��)
;             :  (�W�J�� �̈�ԍ��A�_�~�[�̈�I���G���e�B�e�B�[�A��̈�}�`��)
;             :  (�d�l�\�� �̈�ԍ��A�_�~�[�̈�I���G���e�B�e�B�[�A��̈�}�`��))
;             :  (�̈�̊p�x �̈�̊p�x �E�E�E)
;             :  )
; <�쐬>      : 00/02/15
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun GetMaterialData (
  /
  #xSp #no #ssD #sssym #sType #Skind$ #kind$ #ang$ #iI
  #eEn #ed$ #sDang #sYashi #sDy #ang
  #nII
  #ssTT
  #eTT$
  #eTT0$
  #eTTPrev
  #eTT
  #xTT$
  )

  (defun ##mergelists (
    &list_a$
    &list_b$
    /
    #atom
    #merged_list$
    )
    (setq #merged_list$ &list_a$)
    (foreach #atom &list_b$
      (if (not (member #atom #merged_list$))
        (setq #merged_list$ (cons #atom #merged_list$))
      )
    )
    #merged_list$
  )


  ; �V���{���}�`�̑I���Z�b�g���쐬
  (setq #ssD (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_SKDM")))))
  (if (= nil #ssD) (setq #ssD (ssadd)))

;|
  ; 01/07/13 TM ADD �ǉ����Ē�����
  ; �i�g�b�v���������� .... �x�����B������������������@�́H
  (setq #ssTT (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_*")))))
  (setq #nII 0)
  (repeat (sslength #ssTT)
    (setq #eTT0$ (CFGetGroupEnt (ssname #ssTT #nII)))
    (if #eTT$
      (setq #eTT$ (##mergelists #eTT$ #eTT0$))
      (setq #eTT$ (list #eTT0$))
    )
    (setq #nII (1+ #nII))
  )

  ; ���iCODE�� 717(=J�g�b�v) �̐}�`���擾����
  (foreach #eTT #eTT$
    (if
      (and
        #eTT
        (not (equal #eTT #eTTPrev))
        (setq #xTT$ (CFGetXData #eTT "G_LSYM"))
        (equal (nth 9 #xTT$) 717)
      )
      (progn
        ; �Y���̐}�`�̂S�_���W�����߂�
        (setq #dTT (GetSym4Pt #eTT))

        ; ���[�N�g�b�v�Ɨ̈悪�d�Ȃ邩�H

      )
    )
    (setq #eTTPrev #eTT)
  )
|;
  ; 01/07/13 TM ADD �ǉ����Ē�����


  ;2010/11/30 YM ADD-S
  (if (= CG_AUTOMODE 2)
    ;��̈��}(�֐���)
    (DrawYashiArea);2010/11/30 YM ADD
  );_if
  ;2010/11/30 YM ADD-E


  ; ��}�`�l��
  (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))
  (if (= nil #xSp)
    ; ��ݒ�Ȃ��̏ꍇ
    (progn

      ; 01/09/07 YM MOD-S ����Ӱ�ނł͌x�����Ȃ�
      (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
    ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
        nil
        (CFAlertMsg "��ݒ肪����Ă��܂���B�����Ŕ��f���܂�")
      );_if
      ; 01/09/07 YM MOD-E ����Ӱ�ނł͌x�����Ȃ�

      (setq #no   "0")
      ;(setq #ssD (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_SKDM")))))
      ;(if (= nil #ssD) (setq #ssD (ssadd)))
      ;�V���{���}�`���玩���Ŕ��f
      (setq #sType (SKGetKichenType nil))
      (cond
        ((or (equal #sType "I-RIGHT") (equal #sType "I-LEFT"))
          (setq #Skind$    (list "A" "B"  0  "D"  0  0))
        )
        ;_(or (equal #sType "L-RIGHT") (equal #sType "W-LEFT"))
        ((equal #sType "L-RIGHT")
          (setq #Skind$    (list "A"  0   0  "D"  0  0))
        )
        ;_(or (equal #sType "L-LEFT")  (equal #sType "W-RIGHT"))
        ((equal #sType "L-LEFT")
          (setq #Skind$    (list "A" "B"  0   0   0  0))
        )
        ((or (equal #sType "D-RIGHT") (equal #sType "D-LEFT"))
          (setq #Skind$    (list "A" "B"  0  "D"  0  0))
        )
      )
      (if (/= nil #Skind$)
        (progn
          (setq #kind$
            (list
              (list #no #ssD nil (list "P"))    ; ���ʐ}
              (list #no #ssD nil #Skind$)       ; ABCD�����W�J�}
            )
          )
          (setq #ang$
            (list
              (list "0" 0.0)    ; ���ʐ}
              (list "0" 0.0)    ; �W�J�}
            )
          )
        )
      )
    )
    ; ������݂���ꍇ
    (progn
      (setq #iI 0)

      (repeat (sslength #xSp)

        ; ��}�`�̊g���f�[�^
        (setq #eEn (ssname #xSp #iI))
        (setq #ed$    (CfGetXData #eEn "RECT"))
        ;(princ "\n��g��(�ԍ� �p�x ����): ")
        ;(princ #ed$)

        (setq #no     (nth 0 #ed$))              ; �̈�ԍ�
        (setq #sDang  (nth 1 #ed$))              ; ��p�x
        (setq #sYashi (nth 2 #ed$))              ; �쐬��L�� "ABD"

        ; �e�����ɑΉ���������f�[�^���쐬����
        (setq #Skind$ nil)
        (foreach #sDy '("A" "B" "C" "D" "E" "F")
          (if (wcmatch #sYashi (strcat "*" #sDy "*"))
            (setq #Skind$ (cons #sDy #Skind$))
            (setq #Skind$ (cons 0    #Skind$))
          )
        )
        ; �����ꂩ�̕����̖�����݂���ꍇ�A�}�ʎ�ނƊp�x�̃f�[�^��ǉ�����
        (if (/= nil #Skind$)
          (progn
            (setq #kind$ (cons (list #no #ssD nil (reverse #Skind$)) #kind$))

            ; 2000/07/06 HT YASHIAC  ��̈攻��ύX END
            (if (/= nil (angtof #sDang))
              (progn
                (setq #ang (Angle0to360 (- (* 0.5 PI) (angtof #sDang))))
                (setq #ang$ (cons (list #no #ang) #ang$))
              )
            );_if
          )
        );_if

        (setq #iI (1+ #iI))

      ) ; repeat

      ; ���ʐ}���Œ�f�[�^�Ƃ��Ēǉ����� ; 01/05/25 TM �W�J�}�Ȃ��͂��Ԃ񂠂肦�Ȃ�����
      (setq #kind$ (cons (list #no #ssD nil (list "P")) #kind$))
      (setq #ang$ (cons (list #no 0.0) #ang$))

      ; 01/05/25 TM �Ӑ}���s���ȃR�[�h
;      (if (= nil #ang$)
;       (foreach #no (mapcar 'car #kind$)
;         (setq #ang$ (cons (list #no 0.0) #ang$))
;       )
;      )
;      (if (> (sslength #xSp) 1)
;        (progn
;         (setq #eEn (ssname #xSp 0))
;         (setq #ed$  (CfGetXData #eEn "RECT"))
;         (if (/= "E" (nth 2 #ed$))
;             (progn
;             (setq #ang$ (reverse #ang$))
;             (setq #kind$ (list (nth 1 #kind$)(nth 0 #kind$)(nth 2 #kind$)))
;           )
;         )
;       )
;      )

    )
  );_if (/= nil #xSp)

  (list #kind$ #ang$)
) ; GetMaterialData


;<HOM>*************************************************************************
; <�֐���>    : DrawYashiArea
; <�����T�v>  : ��̈��������}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2010/11/30
; <���l>      : 
;*************************************************************************>MOH<
(defun DrawYashiArea ( / )
  ; �Ζʃv�����͖������`�a�c�d�Ƃ���
  (cond
    ((= CG_PlanType "SK")

      ; I�^�v�������ǂ����𔻒肷��
      (if (= "I00" (nth  5 CG_GLOBAL$))
        (progn
          (if (= CG_HOOD_FLG "IP")
            ;I�^��P�^̰��
            (KCFAutoMakeTaimenPlanYashi);P�^�Ȃ��̈掩���ݒ�
          ;else
            (KCFAutoMakeIgataPlanYashi);I�^�Ȃ��̈掩���ݒ�
          );_if
        )
        ;I�^�ȊO�̂Ƃ�
        (progn
          ; �Ζʃv�������ǂ����𔻒肷��
          (setq #sfpType (SCFIsTaimenFlatPlan))
          (if #sfpType
            (KCFAutoMakeTaimenPlanYashi);P�^�Ȃ��̈掩���ݒ�
          );_if
        )
      );_if

    )

    ;SK�ȊO ���[�̂Ƃ�

    ;((= CG_SeriesDB "SDA") ;2011/02/01 YM MOD�yPG����z
    ((= BU_CODE_0001 "1")
      (KCFAutoMakeDiningPlanYashi);���[I�z��Ȃ��̈掩���ݒ�
    )
    ;((= CG_SeriesDB "SDB") ;2011/02/01 YM MOD�yPG����z
    ((= BU_CODE_0001 "2")
      ;2009/1/26 YM ADD ���[�g��
      (KCFAutoMakeDiningPlanYashi_EXTEND);���[�g��
    )
    (T ;__OTHER
      (KCFAutoMakeDiningPlanYashi_EXTEND);���[�g��
    )
  );_cond
  (princ)
);DrawYashiArea


;<HOM>*************************************************************************
; <�֐���>    : GetDaByRyoiki
; <�����T�v>  : ��̈���̃_�~�[�̈���l������
; <�߂�l>    : ��̈���ɂ���_�~�[�̈�I���G���e�B�e�B
; <�쐬>      : 00/02/15
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun GetDaByRyoiki (
  &en         ; �̈�}�`��
  /
  #ypt$ #ss #i #en #pt$ #flg #pt #en$
  )
  ;��̈�}�`�̍��W���l������
  (setq #ypt$ (mapcar 'car (get_allpt_H &en)))
  (setq #ypt$ (append #ypt$ (list (car #ypt$))))

  ;�_�~�[�̈�l��
  (setq #ss (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_SKDM")))))

  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #pt$ (mapcar 'car (get_allpt_h #en)))
        (setq #flg T)
        (mapcar
         '(lambda ( #pt )
            (if (not (CFAreaInPt #pt #ypt$))
              (setq #flg nil)
            )
          )
          #pt$
        )
        (if (/= nil #flg)
          (setq #en$ (cons #en #en$))
        )
        (setq #i (1+ #i))
      )
    )
  )

  (En$2Ss #en$)
) ; GetDaByRyoiki


;<HOM>*************************************************************************
; <�֐���>    : GetDaByRyoiki2
; <�����T�v>  : �_�~�[�̈���l������
; <�߂�l>    : �_�~�[�̈�I���G���e�B�e�B
; <�쐬>      : 00/02/15
; <���l>      : ��̈�̔���Ȃ��ɂ���
;             : 2000/07/06 HT YASHIAC  ��̈攻��ύX
;             : �֐��ǉ�
;*************************************************************************>MOH<

(defun GetDaByRyoiki2 (
  &en         ; �̈�}�`��
  /
  #ypt$ #ss #i #en #pt$ #flg #pt #en$
  )
  ;�_�~�[�̈�l��
  (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_SKDM"))))
) ; GetDaByRyoiki2

;<HOM>*************************************************************************
; <�֐���>    : GetDaByRyoiki3
; <�����T�v>  : ��̈���l������
; <�߂�l>    : ��̈�}�`�G���e�B�e�B
; <�쐬>      : 01/04/20 TM
; <���l>      : ��̈�f�[�^������ꍇ�̂ݕԂ�
;*************************************************************************>MOH<
(defun GetDaByRyoiki3 (
  &eEn        ; ��}�`��
  &sYashi     ; � "A" "B" "C" "D" "E" ��
  /
  #eXd$       ; �g���f�[�^(�)
  #eYas$      ; �̈�G���e�B�e�B
  #nPos       ; �w���̈ʒu
  )

  ; ����W
  ; DEBUG (princ "\n#dPt0 ")
  ; DEBUG (setq #dPt0 (cdr (assoc 10 (entget &eEn))))
  ; DEBUG (princ #dPt0)

  ; ��̈�̊g���������擾
  ; DEBUG (princ "\nXdata: ")
  (setq #eXd$ (CFGetXData &eEn "RECT"))
  ; DEBUG (princ #eXd$)

  ; 3 �Ԗڂ̍���(�����������) �̒��Ɏw�肷�������݂��邩�H
  (if (setq #nPos (vl-string-search &sYashi (nth 2 #eXd$)))

    ; 4 �Ԗڂ̍���(��̈�w��}�`�n���h��)�̗L�����`�F�b�N
    (if (nth (+ 3 #nPos) #eXd$)
      ; ��̈�w��}�`�n���h��������ꍇ�́A���̐}�`��Ԃ�
      (progn
        (setq #eYas$ (handent (nth (+ 3 #nPos) #eXd$)))
      )
    )
  )

  #eYas$

) ;_ GetDaByRyoiki3

;<HOM>*************************************************************************
; <�֐���>    : KCFGetDaByYasReg
; <�����T�v>  : ��̈���l������
; <�߂�l>    : ��̈�_��
; <�쐬>      : 01/04/23 TM
; <���l>      : ��̈�f�[�^������ꍇ�͗̈�̓_��
;               �Ȃ��ꍇ�͖��_���������A���A�E��5000 ���̋�`�̂S�_
;               01/05/31 TM ���ʐ}�^�p�[�X�}�͑ΏۊO
;*************************************************************************>MOH<
(defun KCFGetDaByYasReg (
  &eEn        ; ��}�`�G���e�B�e�B
  &sType      ; � "A" "B" "C" "D" "E" "F"
  /
  #eYas           ; �̈�G���e�B�e�B
  #dYas$          ; �̈�_��
  #p1 #p2 #p3 #p4 ; �������肵���̈�̒[�_
  #dPt0           ; ����W
  #rAng           ; ��Ƃ����̌���
  #rYsAng         ; �w�肵����̌���
#SXD$ ; 03/06/10 YM ADD
  )
  ; �̈�}�`�G���e�B�e�B���擾
  (setq #eYas (GetDaByRyoiki3 &eEn &sType))

  ; DEBUG (princ "\n�:")
  ; DEBUG (princ &sType)
  ; �̈�}�`������ꍇ�͓_���擾����
  (if #eYas
    (progn
      (setq #dYas$ (GetLwPolyLinePt #eYas))
      ; DEBUG (princ " ��̈悠��: ")
      ; DEBUG (princ #dYas$)
    )
  )
  ; �_�񂪑��݂��Ȃ��ꍇ�A�����ݒ肷��
  (if (not #dYas$)
    (progn
      ; ��}�`�̊�_�Ɗp�x���擾
      (setq #dPt0 (cdr (assoc 10 (entget &eEn))))
      (setq #sXd$ (CFGetXData &eEn "RECT"))
      (setq #rAng (dtr (atoi (nth 1 #sXd$))))


    ;  ��̈掩������̊
    ;
    ;
    ;                       10000
    ;         p3 ------------------------------- p2
    ;            |                             |
    ;            |                             |
    ;            |                             |
    ;            |         (&sType="P")        |
    ;            |             ��              |
    ;     10000  |             ��              |   10000
    ;            |            (���ʐ}�̌v�Z�p) |
    ;            |                             |
    ;            |        �w������         |
    ;            |          (&sType)           |
    ;            |             ��              |
    ;         p4 |-----------  ��  ----------- | p1   --> A����
    ;
    ;       �͈͂ɖ�������Ă��邩�ǂ���
    ;

      ; A �����̑��Ε����Ōv�Z����
      (cond
        ((wcmatch &sType "*A*")
          (setq #rYsAng #rAng)
        )
        ((wcmatch &sType "*B*")
          (setq #rYsAng (- #rAng (dtr 90)))
        )
        ((wcmatch &sType "*C*")
          (setq #rYsAng (- #rAng (dtr 180)))
        )
        ((wcmatch &sType "*D*")
          (setq #rYsAng (- #rAng (dtr 270)))
;         (setq #rYsAng (+ #rAng (dtr 90)))
        )
        ; �ǉ��
        ; �ǉ���ɂ͗̈悪�K������
        ((wcmatch &sType "*[EF]*")
          (CfAlertErr "�d��̖�̈悪�ݒ肳��Ă��܂���B\n�ǉ���ݒ�Őݒ肵�����Ă��������B")
          (quit)
        )
        ; 01/05/31 TM DEL-S ���̕����͎g�p���Ȃ��B���̂܂܎g���ƌ��󕽖ʐ}��WT �������Ȃ��Ȃ�s�����
        ; ���ʐ} 01/04/26 TM ZAN
        ;@DEL@ ((or (wcmatch &sType "*P*") (wcmatch &sType "*M*"))
        ;@DEL@  ; ���ʐ}�̌v�Z��̖�p�x�� ���ʌ���(=B ��Ɠ��p�x)
        ;@DEL@  (setq #rYsAng (dtr (- 90)))
        ;@DEL@  ; ����W�������쐬��̈�̐����`�̒��S�ƂȂ�悤�ɒ���
        ;@DEL@  (setq #dPt0  (polar #dPt0  0.0       5000))
        ;@DEL@ )
        ; 01/05/31 TM DEL-E ���̕����͎g�p���Ȃ��B���̂܂܎g���ƌ��󕽖ʐ}��WT �������Ȃ��Ȃ�s�����
      )
      ; ���ʐ}�^�p�[�X�}�A�܂��͎w���ɗ̈悪�Ȃ��W�J�}�i=�����̈�ݒ�p��p�x�������ς݁j�̏ꍇ
      (if #rYsAng
        (progn
          (setq #p1 (polar #dPt0 (- #rYsAng (dtr 90))  5000))
          (setq #p2 (polar #p1      #rYsAng           10000))
          (setq #p3 (polar #p2   (+ #rYsAng (dtr 90)) 10000))
          (setq #p4 (polar #dPt0 (+ #rYsAng (dtr 90))  5000))

          (setq #dYas$ (list #p1 #p2 #p3 #p4))
          ; DEBUG (princ "�����擾:")
          ; DEBUG (princ " ��p�x:")
          ; DEBUG (princ #rYsAng)
          ; DEBUG (princ " ��p�x:")
          ; DEBUG (princ #rAng)
          ; DEBUG (princ " �̈�:")
          ; DEBUG (princ #dYas$)
        )
        (progn
          ;(princ "\n��̈掩���擾���s")
        )
      )
    )
  )

  #dYas$

) ;_ KCFGetDaByYasReg


;<HOM>*************************************************************************
; <�֐���>    : SCFCheckExpand
; <�����T�v>  : �W�J���}�쐬�`�F�b�N
; <�߂�l>    : �쐬����}�ʎ��
; <�쐬>      : 99/11/26
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun SCFCheckExpand (
  &kind$      ; �쐬�ł���̈�ԍ��Ɛ}�ʎ�ރ��X�g
  &DclRet$    ; �_�C�A���O�Ԃ�l
  /
  #shiyou #DclRet$ #str #no #plane #expand #kind #p #pkind$ #e #ekind$ #skind #kind$
  )
  ;---  �d�l�\�`�F�b�N  ----
  (if (equal (list 1 0) (cdr (car &DclRet$)))
    (progn
      (setq #shiyou "�W�J�}���쐬����Ǝ����I�Ɏd�l�\���X�V����܂��B")
      (setq #DclRet$ (list (cons (car (car &DclRet$)) (list 1 1)) (cadr &DclRet$)))
    )
    (progn
      (setq #DclRet$ &DclRet$)
    )
  );_if
  ;-------------------------
  (setq #str "")
  (mapcar
   '(lambda ( #no )
      (setq #plane  nil)
      (setq #expand nil)
      (mapcar
       '(lambda ( #kind )
            (if (= "P" (car (nth 3 #kind)))
              (setq #plane  (cons #kind #plane))
              (setq #expand (cons #kind #expand))
            )
        )
        &kind$
      )
      ;���ʐ}
      (if (and (= 1 (nth 0 (car #DclRet$))) (/= nil #plane))
        (mapcar
         '(lambda ( #p )
            (setq #pkind$ (cons #p #pkind$))
          )
          #plane
        )
        (if (= 1 (nth 0 (car #DclRet$)))
          (setq #str (strcat #str "���ʐ}\n"))
        )
      )
      ;�W�J�}
      (if (and (= 1 (nth 1 (car #DclRet$))) (/= nil #expand))
        (mapcar
         '(lambda ( #e )
            (setq #ekind$ (cons #e #ekind$))
          )
          #expand
        )
        (if (= 1 (nth 1 (car #DclRet$)))
          (setq #str (strcat #str "�W�J�}\n"))
        )
      )
      ;�d�l�\
      (if (= 1 (nth 2 (car #DclRet$)))
        (setq #skind T)
      )
    )
    (cadr #DclRet$)
  )

  ;---- �G���[�o��  ----
  ;�����
  (if (/= 0 (strlen #str))
    (progn
      (CFAlertMsg (strcat #str "\n�̓W�J���}�͍쐬�ł��܂���\n��ݒ�������Ȃ��Ă�������"))
      (setq #kind$ nil)
    )
    (progn
      ;�d�l�\
      (if (/= nil #shiyou)
        (CfAlertMsg #shiyou)
      )
      (if (and (= nil #pkind$)(= nil #ekind$) (= nil #skind))
        (setq #kind$ nil)
        (setq #kind$ (list #pkind$ #ekind$ #skind))
      )
    )
  );_if

  #kind$
) ; SCFCheckExpand


;<HOM>*************************************************************************
; <�֐���>    : SCFMakeBlockPers
; <�����T�v>  : �W�J���}�쐬 �p�[�X�}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 99/11/29
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun SCFMakeBlockPers (
  &sType      ; �}�ʃ^�C�v
  &sNo        ; �̈�ԍ�
  &ssD        ; �_�~�[�̈�I���G���e�B�e�B
  &yashi      ; ��̈�}�`��
  &ang        ; ��]�p�x
  &sLayer     ; �p�[�X�}��w
  /
  #ss_n #i #enD #ed$ #sym #en$ #en #layer #eg #subst #xWt
#entlast ;-- 2011/12/27 A.Satoh Add
  )

  (setq #ss_n (ssadd))
  (setq #i 0)
  (repeat (sslength &ssD)
    (setq #enD (ssname &ssD #i))
    (setq #ed$ (CfGetXData #enD "G_SKDM"))
    (mapcar
     '(lambda ( #sym )
        ;�V���{���Ɠ����O���[�v�̐}�`���l��
        (setq #en$ (CFGetGroupEnt #sym))
        (mapcar
         '(lambda ( #en )
            (setq #layer (strcase (cdr (assoc 8 (entget #en)))))
            (if
              (or
                (wcmatch #layer "Z_00*")
                (wcmatch #layer "M_*")
                (wcmatch #layer "Z_KUTAI")  ; 01/02/04 HN ADD �p�[�X�}�ɋ�̉�w��ǉ�
              )
              (progn
                ;�}�`�f�[�^�擾
                (setq #eg (entget #en '("*")))
                (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
                ;�}�`�R�s�[
                ;�C��  00/04/12  START -----------
                (if (/= "POLYLINE" (cdr (assoc 0 #subst)))
                  (progn
                    (entmake #subst)
                  )
                  (progn
                    (entmake #subst)
                    (while (/= "SEQEND" (cdr (assoc 0 (entget (setq #en (entnext #en))))))
                      (setq #eg (entget #en '("*")))
                      (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                      (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
                      (entmake #subst)
                    )
                    (setq #eg (entget #en '("*")))
                    (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                    (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
                    (entmake #subst)
                  )
                )
                ;�C��  00/04/12  END -----------
                ;�I���Z�b�g�ɒǉ�
                (ssadd (entlast) #ss_n)
              )
            )
          )
          #en$
        )
      )
      (cdr (cdr #ed$))
    )
    (setq #i (1+ #i))
  )

  (setq #xWt (GetWtAndFilr &yashi "M"))
  (if (/= nil #xWt)
    (progn
      (setq #i 0)
      (repeat (sslength #xWt)
        (setq #en (ssname #xWt #i))
        ;�}�`�f�[�^�擾
        (setq #eg (entget #en '("*")))
        (setq #subst (OmitAssocNo #eg '(-1 330 5)))
        (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
        ;�}�`�R�s�[
        (entmake #subst)
        ;�I���Z�b�g�ɒǉ�
        (setq #entlast (GetLastEntity))
        (if (= 'ENAME (type #entlast))
          (ssadd #entlast #ss_n)
        )
        (setq #i (1+ #i))
      )
    )
  )
  ;�}�`��]
  (if (and (/= nil #ss_n) (/= 0 (sslength #ss_n)))
    (progn
      ; (command "_.ROTATE" #ss_n "" "0,0,0" (angtos &ang)) 2000/10/03 HT MOD
      (command "_.ROTATE" #ss_n "" "0,0,0" (angtos &ang (getvar "AUNITS") CG_OUTAUPREC))
      (if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo ".dwg"))
        (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "" "0,0,0" #ss_n "")
        (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "" "0,0,0" #ss_n "")
      )
    )
  )

  (princ)
) ; SCFMakeBlockPers


;<HOM>*************************************************************************
; <�֐���>    : GetLastEntity
; <�����T�v>  : AutoCad2000�Ή� "entlast"
; <�߂�l>    : �}�`��
; <�쐬>      : 99-08-11 �g��\��
; <���l>      ;
;*************************************************************************>MOH<

(defun GetLastEntity (
  /
  #en #en2
  )
  (setq #en (entlast));�Ō�̐}�`���擾
  (if (and (/= nil #en) (= 'ENAME (type #en)))
    (if (equal (cdr (assoc 0 (entget #en))) "INSERT")
      (setq #en2 #en)
      ;���݂̐}�`(#en)��#en2�Ɋi�[���A����ȍ~(entnext)�̐}�`��#en�Ɋi�[�A�̃��[�v
      (while #en (setq #en (entnext (setq #en2 #en))))
    )
  )
  #en2
) ; GetLastEntity


;<HOM>*************************************************************************
; <�֐���>    : SCFMakeBlockPlan
; <�����T�v>  : �W�J���}�쐬 ���ʐ}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-21
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun SCFMakeBlockPlan (
  &sType      ; �}�ʃ^�C�v
  &sNo        ; �̈�ԍ�
  &ssD        ; �_�~�[�̈�I���G���e�B�e�B
  &yashi      ; ��̈�}�`��
  &ang        ; ��]�p�x
  &sLayer     ; ���ʐ}��w
  &sDlayer    ; ���@����w
  /
  #Zcode$ #noen$$$ #ss_n$ #ss_n #noen$$ #noen$ #danmen #sym #ModelFlg
  #ModelNo #syou #wd #en$ #ModelAngle #eg #subst #sym_n #ed$ #ang #en
  #xWt #i #entlast #ssP #ss_b #sZcode #ss #sBname
  #Cons8sLayer    ; 2000/06/22 HT ADD ���x���P�p
  #8              ; 2000/06/22 HT ADD ���x���p
  #ss #yashi #xYashi #j #dY #EgY$ #cecolor  ; 2000/07/13 HT ADD ��L���ǉ�
  #i
  )
  (if (= nil (tblsearch "APPID" "G_SKDM")) (regapp "G_SKDM"))
  (setq #Zcode$ (list CG_OUTSHOHINZU CG_OUTSEKOUZU))  ; 2000/09/25 HT

  ;�}�`�����X�g�擾�i�f�ʎw�� �V���{���}�`�� ���ʃt���O �}�`�����X�g�j�c�j
  (setq #noen$$$ (SKFGetCabiEntity &sType #Zcode$ &ssD &ang))

  ;���ʐ}�}�`���R�s�[����
  (repeat (length #Zcode$)
    (setq #ss_n$ (cons (ssadd) #ss_n$))
  )
  ;�V���{���}�`�ƃV���{���̃O���[�v�̐}�`�R�s�[
  (mapcar
   '(lambda ( #ss_n #noen$$ )
      (mapcar
       '(lambda ( #noen$ )
          ;�V���{���}�`��
          (setq #danmen   (nth 0 #noen$))  ;�f�ʎw��
          (setq #sym      (nth 1 #noen$))  ;�V���{���}�`��
          (setq #ModelFlg (nth 2 #noen$))  ;���f���t���O
          (setq #ModelNo  (nth 3 #noen$))  ;���f���ԍ�
          (setq #syou     (nth 4 #noen$))  ;���ʃt���O�i�O�F���� �P�F���ʁj
          (setq #wd       (nth 5 #noen$))  ;���ʕ����t���O�i"W" "D"�j
          (setq #en$      (nth 6 #noen$))  ;�V���{���Ɠ����O���[�v�̐}�`�����X�g
          ;�_�~�[�g���f�[�^�̊i�[�p�x
          (if (= "K" #ModelFlg)
            (setq #ModelAngle 0.0)
            (setq #ModelAngle (nth 2 (CfGetXData #sym "G_LSYM")))
          )

          (setq #eg  (entget #sym '("*")))
          (setq #Cons8sLayer (cons 8 &sLayer)) ; 2000/06/22 HT ADD ���x���P
          ;(setq #subst (subst (cons 8 &sLayer) (assoc 8 #eg) #eg)) ; 2000/06/22 HT ���x���P
          (setq #subst (subst #Cons8sLayer (assoc 8 #eg) #eg)) ; 2000/06/22 HT ���x���P
          (entmake #subst)
          ;�R�s�[��}�`���擾
          (setq #sym_n (entlast))
          ;�g���f�[�^�̉�]�p�x�ϊ�
          (setq #ed$ (CfGetXData #sym_n "G_LSYM"))
          (setq #ang (Angle0to360 (+ (nth 2 #ed$) &ang)))
          (setq #ed$ (append (list (car #ed$)(cadr #ed$) #ang) (cdr (cdr (cdr #ed$)))))
          (CfSetXData #sym_n "G_LSYM" #ed$)
          ;�g���f�[�^�Ƀ_�~�[�i�[
          (CfSetXData #sym_n "G_SKDM" (list 1 #ModelFlg #ModelNo #syou #ModelAngle #wd))
          ;�I���Z�b�g�Ɋi�[
          (ssadd #sym_n #ss_n)
          (mapcar
           '(lambda ( #en )
              ;�}�`�f�[�^�擾
              (setq #eg (entget #en '("*")))
              (setq #8 (assoc 8 #eg)) ; 2000/06/22 HT ���x���P
              (setq #pl$ (CfGetXData #en "G_PLIN"))
              (cond
                ((equal "DIMENSION" (cdr (assoc 0 #eg)))
                  ; (setq #subst (subst (cons 8 &sDlayer)  (assoc 8 #eg) #eg)) ; 2000/06/22 HT ���x���P
                  (setq #subst (subst (cons 8 &sDlayer) #8 #eg))               ; 2000/06/22 HT ���x���P
                )
                ((= 3 (car #pl$))
                  ; (setq #subst (subst (cons 8 "0_plin_1") (assoc 8 #eg) #eg)) ; 2000/06/22 HT ���x���P
                  (setq #subst (subst (cons 8 "0_plin_1") #8 #eg))              ; 2000/06/22 HT ���x���P
                )
                ((= 4 (car #pl$))
                  ; (setq #subst (subst (cons 8 "0_plin_2") (assoc 8 #eg) #eg)) ; 2000/06/22 HT ���x���P
                  (setq #subst (subst (cons 8 "0_plin_2") #8 #eg))              ; 2000/06/22 HT ���x���P
                )
                (T
                  ;2011/07/06 YM MOD-S ��̔�\�� ; ��̂́A"0_KUTAI"��w�ɒu�� (�\������R�}���h�Ή��̂���)
                  (cond
                    ((= CG_SKK_TWO_UPP (CFGetSymSKKCode #Sym 2))
                      (setq #subst (subst (cons 8 "0_WALL") #8 #eg))
                    )
                    ((= CG_SKK_TWO_KUT (CFGetSymSKKCode #Sym 2))
                      (setq #subst (subst (cons 8 "0_KUTAI") #8 #eg))
                    )
                    (T
                      (setq #subst (subst (cons 8 &sLayer ) #8 #eg))
                    )
                  );_if

;;;                  ; 2000/06/20 �E�I�[���L���r�l�b�g�́A"0_WALL"��w�ɒu�� (�\������R�}���h�Ή��̂���)
;;;                  (if (= CG_SKK_TWO_UPP (CFGetSymSKKCode #Sym 2))
;;;                    (progn
;;;                     ; (setq #subst (subst (cons 8 "0_WALL") (assoc 8 #eg) #eg)) ; 2000/06/22 HT ���x���P
;;;                     (setq #subst (subst (cons 8 "0_WALL") #8 #eg))              ; 2000/06/22 HT ���x���P
;;;                    )
;;;                    (progn
;;;                     ; (setq #subst (subst (cons 8 &sLayer ) (assoc 8 #eg) #eg)) ; 2000/06/22 HT ���x���P
;;;                     (setq #subst (subst (cons 8 &sLayer ) #8 #eg))              ; 2000/06/22 HT ���x���P
;;;                    )
;;;                  );_if
                  ;2011/07/06 YM MOD-E ��̔�\�� ; ��̂́A"0_KUTAI"��w�ɒu�� (�\������R�}���h�Ή��̂���)

                )
              )
              ;�}�`�R�s�[
              ;�C��  00/04/12  START -----------
              (if (/= "POLYLINE" (cdr (assoc 0 #subst)))
                (progn
                  (entmake #subst)
                )
                (progn
                  (entmake #subst)
                  (while (/= "SEQEND" (cdr (assoc 0 (entget (setq #en (entnext #en))))))
                    (setq #eg (entget #en '("*")))
                    (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                    ;(setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst)) ; 2000/06/22 HT ���x���P
                    (setq #subst (subst #Cons8sLayer (assoc 8 #subst) #subst))      ; 2000/06/22 HT ���x���P
                    (entmake #subst)
                  )
                  (setq #eg (entget #en '("*")))
                  (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                  ; (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))  ; 2000/06/22 HT ���x���P
                  (setq #subst (subst #Cons8sLayer (assoc 8 #subst) #subst))        ; 2000/06/22 HT ���x���P
                  (entmake #subst)
                )
              )
              ;�C��  00/04/12  END  -----------
              ;�I���Z�b�g�ɒǉ�
              (ssadd (entlast) #ss_n)
            )
            #en$
          )
        )
        #noen$$
      )
    )
    #ss_n$ #noen$$$
  )

  ;Z_00�}�`�擾
  (setq #xWt (GetWtAndFilr &yashi "P"))
  (if (/= nil #xWt)
    (progn
      (mapcar
       '(lambda ( #ss_n )
          (setq #i 0)
          (repeat (sslength #xWt)
            (setq #en (ssname #xWt #i))
            (setq #eg (entget #en '("*")))
            (if (equal "DIMENSION" (cdr (assoc 0 #eg)))
              (setq #subst (subst (cons 8 &sDlayer) (assoc 8 #eg) #eg))
              (setq #subst (subst (cons 8  &sLayer) (assoc 8 #eg) #eg))
            )
            (entmake (cdr #subst))
            (setq #entlast (entlast))
            (ssadd #entlast #ss_n)
            (setq #i (1+ #i))
          )
        )
        #ss_n$
      )
    )
  )


  ;�_�~�[�_�}�`�擾
  (setq #ssP (ssget "X" (list (cons 0 "POINT")(list -3 (list "G_SKDM")))))
  (if (/= nil #ssP)
    (progn
      (setq #i 0)
      (repeat (sslength #ssP)
        (setq #en (ssname #ssP #i))
        (if (= "W" (nth 1 (CfGetXData #en "G_SKDM")))
          (progn
            (mapcar
             '(lambda ( #ss_n )
                (entmake (cdr (entget #en '("*"))))
                (ssadd (entlast) #ss_n)
              )
              #ss_n$
            )
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
  (setq #ss_b (ssadd))
  (mapcar
   '(lambda ( #sZcode #ss )
      (if (and (/= nil #ss) (/= 0 (sslength #ss)))
        (progn
          ; ���ʐ}�ɖ�L�����쐬����
          (KCFSetYashiInPlane #ss)
          ;��ۯ���
          (setq #sBname (strcat &sType #sZcode))
          ; (command "_.ROTATE" #ss "" "0,0,0" (angtos &ang)) 2000/10/03 HT MOD
          (command "_.ROTATE" #ss "" "0,0,0" (angtos &ang (getvar "AUNITS") CG_OUTAUPREC))
          (command "_block" #sBname "0,0,0" #ss "")
          (command "_insert" #sBname "0,0,0" 1 1 "0")
          (ssadd (entlast) #ss_b)
        )
      )
    )
    #Zcode$ #ss_n$
  )

  (if (and (/= nil #ss_b) (/= 0 (sslength #ss_b)))
    (if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo))
      (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "Y" "" "0,0,0" #ss_b "")
      (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "" "0,0,0" #ss_b "")
    )
  )

  (princ)
) ; SCFMakeBlockPlan


;<HOM>*************************************************************************
; <�֐���>    : KCFSetYashiInPlane
; <�����T�v>  : ���ʐ}�ɖ��ݒ肷��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2000/10/16 TH
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KCFSetYashiInPlane (
  &sS       ; ���ʐ}�}�`�I���Z�b�g
  /
  #xSs      ; ��}�`�I���Z�b�g
  #dY       ; ���_
  #xYashi   ; ��}�`�i�����j�I���Z�b�g
  #EgY$     ; ��}�`�i�����j
  #i #j     ; ����ϐ�
  #cecolor  ; ���ݐF
  )

  (setq #xSs (ssget "X" '((-3 ("RECT")))))
  (if (and #xSs (/= 0 (sslength #xSs)))
    (progn
    (setq #i 0)
    (repeat (sslength #xSs)
      (setq #dY (cdr (assoc 10 (entget (ssname #xSs #i)))))
      (entmake (cdr (entget (ssname #xSs #i) '("*"))))
      ; ������] HT 2000/11/14 START
      (command "._EXPLODE" (entlast))
      (setq #xYashi (ssget "P"))
      (if #xYashi
        (progn
        (setq #j 0)
        (repeat (sslength #xYashi)
          (if (= (cdr (assoc 0 (setq #EgY$ (entget (ssname #xYashi #j))))) "TEXT")
            (progn
              (entmod (subst (cons 50 (- &ang)) (assoc 50 #EgY$) #EgY$))
            )
          )
          (setq #j (1+ #j))
        )
        (setq #cecolor (getvar "CECOLOR"))    ; ���ݐF
        (setvar "CECOLOR" "50")  ; �W�J�}
        ;�ău���b�N��
        (SKUblock #dY #xYashi)
        (setvar "CECOLOR" #cecolor)
        ; ������] HT 2000/11/14 END
        )
      )
      (ssadd (entlast) &sS)
      (setq #i (1+ #i))
    )
    )
  )
)

;<HOM>*************************************************************************
; <�֐���>    : SCFMakeBlockExpand
; <�����T�v>  : �W�J���}�쐬 �W�J�}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-21
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCFMakeBlockExpand (
  &sType      ; �}������
  &sNo        ; �̈�ԍ�
  &xSp        ; �_�~�[�̈�I���G���e�B�e�B
  &yashi      ; ��̈�}�`��
  &ang        ; ��]�p�x
  &sLayer     ; ���ʐ}��w
  &sDlayer    ; ���@����w
  &sDy        ; ���ۂ̖�L��
  &zmove      ; Z�����ړ���
  &ssdoor     ; ���ʑI���G���e�B�e�B
  /
  #Kind #Zcode$ #ss_n$ #ss_d$ #noen$$$ #kind #addang #iI #ss_n #ss_d
  #noen$$ #noen$ #danmen #sym #ModelFlg #ModelNo #syou #wd #en$ #ModelAngle
  #ssup #eg #10 #subst #sym_n #ed$ #ang #en #entlast #xWt #i #ssP #ss_b
  #sZcode #ss #sBname
  #Cons8sLayer    ; 2000/06/22 HT ADD ���x���P�p
  #8              ; 2000/06/22 HT ADD ���x���P�p
  #dat$           ; 2000/06/22 HT ADD (�V���{���}�`�� (���}�`���X�g) P�ʑ���1)
  #Dooren$        ; 2000/06/22 HT ADD (���}�`���X�g)
  #j              ; 2000/06/22 HT ADD (���}�`���X�g) �̃J�E���^
  #iVP            ; 2000/06/22 HT ADD ���_���(int�ŕ\��) 3 4 5 6
  #doorlst        ; 2000/06/22 HT ADD ���x���P�p
  #elm #loop #SSdoorMOVE ; 01/03/15 YM ���̂�Z�ړ�
  #ftpType                 ; �t���b�g�v�����^�C�v "SF":�Z�~�t���b�g "FF":�t���t���b�g
  )
  ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  ; 04/05/17 SK ADD-S �Ζʃv�����Ή�
  (setq #ftpType (SCFIsTaimenFlatPlan))
  ; 04/05/17 SK ADD-E �Ζʃv�����Ή�
  ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

   ; 2000/06/22 HT DEL ���x���P
   ;(if (= nil &ssdoor)
   ; (setq &ssdoor (ssadd))
   ;)
  ;---�����ݒ�---
  (if (= nil (tblsearch "APPID" "G_SKDM")) (regapp "G_SKDM"))
  (setq #Kind &sDy)
  (setq #Zcode$ (list CG_OUTSHOHINZU CG_OUTSEKOUZU)) ; 2000/09/25 HT

  (repeat (length #Zcode$)
    (setq #ss_n$ (cons (ssadd) #ss_n$))
    (setq #ss_d$ (cons (ssadd) #ss_d$))
  )
  ;@@@(princ "\nSKFGetCabiEntity: START")
  ;�}�`�����X�g�擾�i�i�f�ʎw�� �V���{���}�`�� ���ʃt���O �}�`�����X�g�j�c�j
  (setq #noen$$$ (SKFGetCabiEntity #Kind #Zcode$ &xSp &ang))

  ;@@@(princ "\nSKFGetCabiEntity: END")
  (if (not (apply 'or #noen$$$))
    (progn
      (princ "\n")
      (princ #Kind)
      (princ " ����ɐ}�`�����݂��Ȃ�...�X�L�b�v")
    )
    (progn

      ; 2D���Ŏ擾�����f�[�^���g��
      (setq #doorlst CG_DOORLST) ; 2000/06/22 HT ADD ���x���P

      ;--------------
      ;��������ɑ������މ�]�p�x��ݒ�
      ; ���ۂ̖ Default��A����=3
      ;            Default��B����=4
      ;            Default��C����=5
      ;            Default��D����=6
      ; E F ��̏ꍇ�� B �Ɠ��l�Ɉ���
      (cond
        ((= "A" #kind)
          (setq #addang (* PI 0.0))
          (cond
            ((equal &ang 0 0.1)       (setq #iVP 3)) ; OK!
            ((equal &ang 1.571 0.1)   (setq #iVP 4)) ;2001/03/15 MOD KS 01/03/17 YM MOD
            ((equal &ang 3.14159 0.1) (setq #iVP 5)) ;2001/03/15 MOD KS 01/03/17 YM MOD
            ((equal &ang 4.71239 0.1) (setq #iVP 6)) ;2001/03/15 MOD KS 01/03/17 YM MOD
          )
        )
        ; 01/05/25 TM MOD �F �ǉ�
        ((or (= "B" #kind) (= "E" #kind) (= "F" #kind))
          (setq #addang (* PI 0.5))
          (cond
            ((equal &ang 0 0.1)       (setq #iVP 4)) ; OK!
            ((equal &ang 1.571 0.1)   (setq #iVP 5)) ;2001/03/15 MOD KS 01/03/17 YM MOD
            ((equal &ang 3.14159 0.1) (setq #iVP 6))
            ((equal &ang 4.71239 0.1) (setq #iVP 3)) ;2001/03/15 MOD KS 01/03/17 YM MOD
          )
        )
        ((= "C" #kind)
          (setq #addang (* PI 1.0))
          (cond
            ((equal &ang 0 0.1)       (setq #iVP 5)) ; OK!
            ((equal &ang 1.571 0.1)   (setq #iVP 6)) ;2001/03/15 MOD KS 01/03/17 YM MOD
            ((equal &ang 3.14159 0.1) (setq #iVP 3))
            ((equal &ang 4.71239 0.1) (setq #iVP 4)) ;2001/03/15 MOD KS 01/03/17 YM MOD
          )
        )
        ((= "D" #kind)
          (setq #addang (* PI 1.5))
          (cond
            ((equal &ang 0 0.1)       (setq #iVP 6)) ; OK!
            ((equal &ang 1.571 0.1)   (setq #iVP 3)) ;2001/03/15 MOD KS 01/03/17 YM MOD
            ((equal &ang 3.14159 0.1) (setq #iVP 4))
            ((equal &ang 4.71239 0.1) (setq #iVP 5)) ;2001/03/15 MOD KS 01/03/17 YM MOD
          )
        )
      )
      (setq #iI 0)
      (mapcar
       '(lambda ( #ss_n #ss_d #noen$$ )
          (mapcar
            '(lambda ( #noen$ )
              (setq #danmen   (nth 0 #noen$))  ;�f�ʎw��
              (setq #sym      (nth 1 #noen$))  ;�V���{���}�`��
              (setq #ModelFlg (nth 2 #noen$))  ;���f���t���O
              (setq #ModelNo  (nth 3 #noen$))  ;���f���ԍ�
              (setq #syou     (nth 4 #noen$))  ;���ʃt���O�i�O�F���� �P�F���ʁj
              (setq #wd       (nth 5 #noen$))  ;���ʕ����t���O�i"W" "D"�j
              (setq #en$      (nth 6 #noen$))  ;�V���{���Ɠ����O���[�v�̐}�`�����X�g
              ;�_�~�[�g���f�[�^�̊i�[�p�x
              (if (= "K" #ModelFlg)
                (setq #ModelAngle 0.0)                                 ; �L�b�`��
                (setq #ModelAngle (nth 2 (CfGetXData #sym "G_LSYM")))  ; �_�C�j���O
              )
              ;�f�ʎw��I���Z�b�g
              (setq #ssup (ssadd))
              ;�V���{���}�`�ʒu
              (setq #eg (entget #sym '("*")))
              (setq #10 (cdr (assoc 10 #eg)))
              (setq #Cons8sLayer (cons 8 &sLayer)) ; 2000/06/22 HT ���x���P
              ;��w�ϊ�
              ;(setq #subst (subst (cons 8 &sLayer) (assoc 8 #eg) #eg))

              ;2011/07/06 YM MOD ��̂��ǂ����ŉ�w���
              (if (= CG_SKK_TWO_KUT (CFGetSymSKKCode #sym 2))
                (setq #subst (subst (cons 8 "0_KUTAI") (assoc 8 #eg) #eg))
                ;else �]���ʂ�
                (setq #subst (subst #Cons8sLayer       (assoc 8 #eg) #eg))
              );_if


              ;�V���{���}�`�R�s�[
              (entmake #subst)
              ;�R�s�[��}�`���擾
              (setq #sym_n (entlast))

              ;�g���f�[�^�̉�]�p�x�ϊ�
              (setq #ed$ (CfGetXData #sym_n "G_LSYM"))
              (setq #ang (Angle0to360 (+ (nth 2 #ed$) &ang #addang)))
              (setq #ed$ (append (list (car #ed$)(cadr #ed$) #ang) (cdr (cdr (cdr #ed$)))))
              (CfSetXData #sym_n "G_LSYM" #ed$)

              ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
              ; 04/05/17 SK MOD-S �Ζʃv�����Ή�
              ;�g���f�[�^�Ƀ_�~�[�i�[
              (cond
                ; �Ζʃv�����łȂ��A���ʃt���O�ɔw�ʒl(-1)�������Ă���ꍇ
                ; ���ʒl(1) �ɐݒ肷��
                ((and (= #ftpType nil) (= #syou -1))
                  (CfSetXData #sym_n "G_SKDM" (list 1 #ModelFlg #ModelNo 1 #ModelAngle #wd))
                )
                ; ����ȊO�͂��̂܂ܐ��ʃt���O��ݒ�
                (T
                  (CfSetXData #sym_n "G_SKDM" (list 1 #ModelFlg #ModelNo #syou #ModelAngle #wd))
                )
              )
              ; 04/05/17 SK MOD-E �Ζʃv�����Ή�
              ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
              ;�I���Z�b�g�Ɋi�[
              (ssadd #sym_n #ss_n)
              (mapcar
               '(lambda ( #en )

                  ;�}�`�f�[�^�擾
                  (setq #eg (entget #en '("*")))
                  (setq #8 (assoc 8 #eg))
                  ;��w�ϊ�
                  (setq #pl$ (CfGetXData #en "G_PLIN"))
                  (cond
                    ; ���@�H
                    ((equal "DIMENSION" (cdr (assoc 0 #eg)))
                      (setq #subst (subst (cons 8 &sDlayer) #8 #eg))
                    )
                    ; �ԍ�3�H
                    ((= 3 (car #pl$))
                      (setq #subst (subst (cons 8 "0_plin_1") #8 #eg))
                    )
                    ; �ԍ�4�H
                    ((= 4 (car #pl$))
                      (setq #subst (subst (cons 8 "0_plin_2") #8 #eg))
                    )
                    (T

                      ;2011/07/06 YM MOD-S ��̂��ǂ����ŉ�w���
                      (if (= CG_SKK_TWO_KUT (CFGetSymSKKCode #sym_n 2))
                        (setq #subst (subst (cons 8 "0_KUTAI") #8 #eg))
                        ;else �]���ʂ�
                        (setq #subst (subst (cons 8 &sLayer ) #8 #eg))
                      );_if

;;;                     (setq #subst (subst (cons 8 &sLayer ) #8 #eg))
                      ;2011/07/06 YM MOD-E ��̂��ǂ����ŉ�w���

                    )
                  )
                  ; �}�`�R�s�[
                  (if (/= "POLYLINE" (cdr (assoc 0 #subst)))
                    (progn
                      (entmake #subst)
                    )
                    (progn
                      (entmake #subst)
                      (while (/= "SEQEND" (cdr (assoc 0 (entget (setq #en (entnext #en))))))
                        (setq #eg (entget #en '("*")))
                        (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                        (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
                        (entmake #subst)
                      )
                      (setq #eg (entget #en '("*")))
                      (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                      (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
                      (entmake #subst)
                    )
                  )
                  ; �R�s�[�����}�`
                  (setq #entlast (entlast))

                  (setq #eg (entget #entlast '("*")))
                  ; �u���b�N���\������}�`�̉�w��S�čX�V����
                  (if (equal "INSERT" (cdr (assoc 0 #eg)))
                    (setq #entlast (SKFReBlock #entlast))
                  )
                  ;�{�H�������@�ɐ��ʃt���O��ǉ�
                  (setq #ed$ (CfGetXData #en "G_PTEN"))
                  (if (and (/= nil #ed$)(= 8 (nth 0 #ed$)))
                    (CfSetXData #en "G_PTEN" (list 8 #syou 0))
                  )
                  ;�I���Z�b�g�ɒǉ�
                  (ssadd #entlast #ss_n)
                  ;�f�ʎw�肳��A���ʂ̐}�`���_�~�[�̑I���Z�b�g�ɒǉ�
                  (if (and (= 1 #danmen) (= 0 #syou))
                    (ssadd #entlast #ss_d)
                  )
                )
                #en$
              )

              ; 2000/06/22 ���ʐ}�`�̃V���{���}�`���ƈ�v���Ă�����0_door��w��
              ;  ���ʐ}�`���R�s�[���A�I���Z�b�g�ɒǉ�����
              ;  CG_DOORLST = ((�V���{���}�`�� (���}�`���X�g) P�ʑ���1)
              ;                (�V���{���}�`�� (���}�`���X�g) P�ʑ���1)�E�E�E)
              (while (setq #dat$ (assoc #sym #doorlst))
                (setq #j 0)
                ; �V���{���}�`���͕�������̂ŁA��x�I�������Ɩ���0�ɂ���
                (setq #doorlst (subst (list 0 (list 0) 0) #dat$ #doorlst))
                ; ���}�`���ׂăR�s�[����
                (repeat (length (setq #Dooren$ (cadr #dat$)))
                  ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                  ; 04/05/17 SK MOD-S �Ζʃv�����Ή�
                  ; �w�ʃL���r������\��t����
                  ;(if (or (= 1 #syou) (= -1 #syou))
                  (if (or (= 1 #syou) (= -1 #syou))
                  ; 04/05/17 SK MOD-E �Ζʃv�����Ή�
                  ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    (progn
                    (if (or (= 0 (caddr #dat$)) (= #iVP (caddr #dat$)))
                      (progn
                      ; ���}�`���X�g�̂����A���ʃt���OON�ŁA���ʂ����������̂݃R�s�[����
                      ; �R�[�i�[�ɁA���ʌ����̔��Ƒ��ʌ����̔��������
                        (foreach #n #ss_n$
                          ; ���i�}�p�Ǝ{�H�}�p �����쐬
                          (entmake (cdr (entget (nth #j #Dooren$) '("*"))))
                          ; �I���Z�b�g�ɒǉ�����
                          (ssadd (entlast) #n)
                        )
                      )
                    );_if
                    )
                  )
                  (setq #j (1+ #j))
                );repeat
              )
            )
            #noen$$
          )
          (setq #iI (1+ #iI))
        )
        #ss_n$ #ss_d$ #noen$$$
      )

      ;Z_00�}�`(���[�N�g�b�v�^�t�B���[)�擾

      (setq #xWt (GetWtAndFilr &yashi #kind))

      (if (/= nil #xWt)
        (progn
          (foreach #ss_n #ss_n$
            (setq #i 0)
            (repeat (sslength #xWt)
              (setq #en (ssname #xWt #i))
              (setq #eg (entget #en '("*")))
              (if (equal "DIMENSION" (cdr (assoc 8 #eg)))
                (setq #subst (subst (cons 8 &sDlayer) (assoc 8 #eg) #eg))
                (setq #subst (subst (cons 8 &sLayer ) (assoc 8 #eg) #eg))
              )

              (entmake (cdr #subst))
              (ssadd (entlast) #ss_n)
              (setq #i (1+ #i))
            );_repeat
          );_foreach
        )
      );_if (/= nil #xWt)

      ;�_�~�[�_�}�`�擾
      (setq #ssP (ssget "X" (list (cons 0 "POINT")(list -3 (list "G_SKDM")))))
      (if (/= nil #ssP)
        (progn
          (setq #i 0)
          (repeat (sslength #ssP)
            (setq #en (ssname #ssP #i))
            (if (= "W" (nth 1 (CfGetXData #en "G_SKDM")))
              (progn
                (mapcar
                 '(lambda ( #ss_n )
                    (entmake (cdr (entget #en '("*"))))
                    (ssadd (entlast) #ss_n)
                  )
                  #ss_n$
                )
              )
            )
            (setq #i (1+ #i))
          )
        )
      )
      (setq #ss_b (ssadd))

      ;��ۯ���
      (mapcar
       '(lambda ( #sZcode #ss #ss_d )
          ;�}�`��]
          ; (command "_.ROTATE" #ss "" "0,0,0" (angtos &ang)) 2000/10/03 HT MOD
          (command "_.ROTATE" #ss "" "0,0,0" (angtos &ang (getvar "AUNITS") CG_OUTAUPREC))
          ;�}�`��3D��]
          (cond
            ((= "A" #kind)
              (rotate3d #ss "X" "" -90)
            )
            ; 01/05/25 TM ADD �F �ǉ�
            ; ((or (= "B" #kind) (= "E" #kind)) ; 2000/10/06 HT E�����
            ((or (= "B" #kind) (= "E" #kind) (= "F" #kind))
              (rotate3d #ss "Y" ""  90)
              (rotate3d #ss "Z" ""  90)
            )
            ((= "C" #kind)
              (rotate3d #ss "X" ""  90)
              (rotate3d #ss "Z" "" 180)
            )
            ((= "D" #kind)
              (rotate3d #ss "Y" "" -90)
              (rotate3d #ss "Z" "" -90)
            )
          )
          ;�f�ʎw��̐}�`�ɍ�����^����
          (if (and (/= nil #ss_d) (/= 0 (sslength #ss_d)))
            (progn
              (command "_move" #ss_d "" "0,0,0" (list 0.0 0.0 &zmove))
            )
          )

; "0_door" ����Z�ړ� 01/03/15 YM ADD START /////////////////////////////////////////////////
          (setq #loop 0 #SSdoorMOVE (ssadd))
          (repeat (sslength #ss)
            (setq #elm (ssname #ss #loop))
            (if (= (cdr (assoc 8 (entget #elm))) "0_door")  ; ��w
              (ssadd #elm #SSdoorMOVE)
            );_if
            (setq #loop (1+ #loop))
          )
          (if (and #SSdoorMOVE (< 0 (sslength #SSdoorMOVE)))
            (progn
              ; CG_DoorZMove ; ���}�`��Z����(�}�ʂ�XY���ʂƂ���)�ɉ����o����
              (command "_move" #SSdoorMOVE "" "0,0,0" (list 0.0 0.0 CG_DoorZMove))
            )
          );_if
; "0_door" �����ړ� 01/03/15 YM ADD END /////////////////////////////////////////////////

          (setq #sBname (strcat #Kind #sZcode))
          (command "_block" #sBname "0,0,0" #ss "")
          (command "_insert" #sBname "0,0,0" 1 1 "0")
          (ssadd (entlast) #ss_b)
        )
        #Zcode$ #ss_n$ #ss_d$
      )

      (if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo))
        (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "Y" "" "0,0,0" #ss_b "")
        (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "" "0,0,0" #ss_b "")
      )
    )
  );_if (not (apply 'or #noen$$$))

  (princ)
) ; SCFMakeBlockExpand

;<HOM>*************************************************************************
; <�֐���>    : SCFMakeBlockTable
; <�����T�v>  : �W�J���}�쐬 �d�l�\
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-23
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCFMakeBlockTable (
  /
  #sFname #CG_SpecList$$ #fp #Lst$ #sTr #s
  #sFnameExt #fpExt #ssExt #iExt     ;00/08/03 SN ADD
  #symExt #xdExt$ #wlineExt #specExt$;00/08/03 SN ADD
  #noExt #nameExt                    ;00/08/03 SN ADD
  #Spec$ #newSpecList$$ #iSpec       ;00/08/03 SN ADD
#DUM$$ #HIN #HIN_OLD #I #KKK #LR #LR_OLD #NUM #NUM_CHANGE #NUM_CHANGE$ #DUM1$ #DUM2$ #k
  )
  ;�d�l�\̧�ٖ�
  (setq #sFname (strcat CG_KENMEI_PATH "Table.cfg"))
  ;�d�l�\�쐬
  (setq #CG_SpecList$$ (Skb_SetSpecList))

  ;2009/12/08 YM ADD �i�Ԃ������Ȃ�L,R�̏��Ԃɂ���
  (setq #hin_old nil)
  (setq #LR_old  nil)
  (setq #num_CHANGE$ nil)
  ;����ւ��L������ �����i�Ԃ��A�����AR,L�̏��Ԃł����L,R�̏��Ԃɂ���
  (foreach #CG_SpecList$ #CG_SpecList$$
    (setq #num (nth  0 #CG_SpecList$));�ԍ�
;-- 2011/12/12 A.Satoh Mod - S
;;;;;    (setq #hin (nth  9 #CG_SpecList$))
;;;;;    (setq #LR  (nth 10 #CG_SpecList$))
    (setq #hin (nth 11 #CG_SpecList$))
    (setq #LR  (nth 12 #CG_SpecList$))
;-- 2011/12/12 A.Satoh Mod - E
    (if (and (= #hin #hin_old)
             (= "R" #LR_old)
             (= "L" #LR))
      (progn ;���Ԃ̓���ւ����K�v
        (setq #num_CHANGE$ (append #num_CHANGE$ (list (atoi #num))));1��O�Ɠ���ւ����K�v(����)
      )
    );_if
    (setq #hin_old #hin)
    (setq #LR_old   #LR)
  );foreach

  ;����ւ�����
  (if #num_CHANGE$
    (progn

;;;     (setq #dum$$ nil)
;;;     (foreach #CG_SpecList$ #CG_SpecList$$
;;;       (setq #num (atoi (nth  0 #CG_SpecList$)));�ԍ�(����)
;;;       (setq #kkk #num)
;;;       (if (= #num (1- #num_CHANGE))
;;;         (progn ;�ԍ�����׽
;;;           (setq #CG_SpecList$
;;;              (CFModList #CG_SpecList$
;;;                (list (list 0 (itoa (1+ #num))))
;;;              )
;;;           )
;;;           (setq #kkk (1+ #num))
;;;         )
;;;       );_if
;;;       (if (= #num  #num_CHANGE)
;;;         (progn ;�ԍ���ϲŽ
;;;           (setq #CG_SpecList$
;;;              (CFModList #CG_SpecList$
;;;                (list (list 0 (itoa (1- #num))))
;;;              )
;;;           )
;;;           (setq #kkk (1- #num))
;;;         )
;;;       );_if
;;;
;;;       (setq #dum$$ (append #dum$$ (list (append #CG_SpecList$ (list #kkk)))))
;;;     );foreach

      ;2011/06/03 YM MOD-S
      (foreach #num_CHANGE #num_CHANGE$ ;#num_CHANGE��1�O�Ɠ���ւ���
        ;1�O
        (setq #dum1$ (assoc (itoa (1- #num_CHANGE)) #CG_SpecList$$))
        ;�ԍ�����׽
        (setq #dum1$
          (CFModList #dum1$
            (list (list 0 (itoa #num_CHANGE)))
          )
        )

        ;���̎�
        (setq #dum2$ (assoc (itoa #num_CHANGE) #CG_SpecList$$))
        ;�ԍ���ϲŽ
        (setq #dum2$
          (CFModList #dum2$
            (list (list 0 (itoa (1- #num_CHANGE))))
          )
        )

        ;1�O��#dum1$�ɓ���ւ���
        (setq #CG_SpecList$$
          (CFModList #CG_SpecList$$
            (list (list (- #num_CHANGE 2) #dum1$))
          )
        )
        ;���̎���#dum2$�ɓ���ւ���
        (setq #CG_SpecList$$
          (CFModList #CG_SpecList$$
            (list (list (- #num_CHANGE 1) #dum2$))
          )
        )

      );(foreach

      ;2011/06/11 YM ADD �ԍ��ſ�� �����ſ�Ă����"1","10","11","2"�ƂȂ��Ă��܂����琔���ſ�Ă��Ȃ������
      (setq #dum$$ nil)
      (foreach #CG_SpecList$ #CG_SpecList$$
        (setq #k (atoi (nth 0 #CG_SpecList$)))
        (setq #dum$$ (append #dum$$ (list (cons #k #CG_SpecList$ ))));�ԍ���擪�ɒǉ�
      )

      ;�����̔ԍ��ſ��
      (setq #dum$$ (CFListSort #dum$$ 0))

      (setq #CG_SpecList$$ nil);�ر
      (foreach #dum$ #dum$$
        (setq #CG_SpecList$ (cdr #dum$))
        (setq #CG_SpecList$$ (append #CG_SpecList$$ (list #CG_SpecList$)))
      )

    )
  );_if


  ;Table.cfg�����o��
  (setq #fp  (open #sFname "w"))
  (if (/= nil #fp)
    (progn
      (setq #i 0)
      (foreach #CG_SpecList$ #CG_SpecList$$
        (foreach #CG_SpecList #CG_SpecList$
          (princ #CG_SpecList #fp)(princ "," #fp)
        )
        (princ "\n" #fp)
        (setq #i (1+ #i))
      )
    )
  );_if
  (close #fp)
  (princ)
); SCFMakeBlockTable

;;;<HOM>*************************************************************************
;;; <�֐���>  : CFDispStar
;;; <�����T�v>: �R�}���h���C����"�v�Z��"��\������
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 01/07/19 HN
;;; <���l>    : �O���[�o�� CG_CntStar : �\��������
;;;             �b��I�ɖ{�t�@�C���ɒu���Ă��܂�
;;;*************************************************************************>MOH<
(defun CFDispStar
  (
  /
  #iNum    ; �R�}���h���C���\������
  #sDisp   ; �\��������
  )
  (setq #iNum  50)
  (setq #sDisp "")
  (cond
    ((= nil CG_CntStar)
      (princ "\r")
      (princ "->")
      (setq CG_CntStar 0)
    )
    ((< 50 CG_CntStar)
      (princ "\r")                      ; ���ɕ��A
      (repeat (+ 20 #iNum) (princ " ")) ; �N���A
      (princ "\r")                      ; ���ɕ��A
      (setq CG_CntStar 0)
    )
    (T
      (repeat CG_CntStar (setq #sDisp (strcat #sDisp ".")))
      (princ "\r")  ; ���ɕ��A
      (princ (strcat #sDisp "��(._.)�v�Z��"))
      (setq CG_CntStar (1+ CG_CntStar))
    )
  )
  (princ)
) ;_CFDispStar

;<HOM>*************************************************************************
; <�֐���>    : KCFIsAreaMatchYashi
; <�����T�v>  : �w�肵����ɓ_�񂪊܂܂�Ă��邩�H
; <�߂�l>    : T=�܂܂�Ă��� nil=�܂܂�Ă��Ȃ�
; <�쐬>      : 01/04/24 TM ADD
; <����>      : 01/07/19 HN ��̈���̐}�`�擾�O��ZOOM��}��
; <���l>      : �O���[�o��
;               CG_sYKind       : �O�񔻒肵������
;               CG_dArea$       : ��̈�̍��W���X�g
;               CG_dAreaMinMax$ : ��̈�̍ŏ��ő���W
;               CG_eSymArea$    : 3DSOLID�̐}�`�����X�g
;               CG_eSym$Area$   : �O���[�v���̑S�}�`���܂ސ}�`�����X�g
;*************************************************************************>MOH<
(defun KCFIsAreaMatchYashi (
  &sYKind   ; � ("A" "B" "C" "D" "E" "F")
  &eYashi   ; ��}�`
  &dSym$    ; �w��̈���W
  &eSym     ; ����A�C�e���̊�}�` 01/06/11 HN ADD
  /
  #sXd$     ; ��̊g���f�[�^
  #xBas     ; ��̊�_
  #xBD      ; ��̊�_����C������̓_
  #xAC      ; ��̊�_����D������̓_
  #xPt      ; ����ϐ�
  #Ret      ; ����ϐ�
  #nPos     ; �g���f�[�^�̎w���̈ʒu
  #hReg     ; ��̈�}�`�n���h��
  #ssSym    ; �V���{���}�`�̑I���Z�b�g
  #xYas$    ; ��̈�a���W     01/06/11 HN ADD
  #eSym     ; 3DSOLID �̐}�`��
  #eSym$    ; �O���[�v���̐}�`�����X�g
  #iCnt     ; �J�E���^
  )
  (CFDispStar) ; "�v�Z��"�\��

  ; 01/07/19 HN S-MOD ����O��ƈႤ�ꍇ�́A��̈�����擾
  ; 01/06/11 HN S-ADD
  ; ���ɎQ�Ƃ����}�`�Ɩ�̈���𖈉�擾����Ə������Ԃɉe������̂�
  ; �O���[�o���ϐ��ɂĕێ�����悤�ɂ���
  (if (/= &sYKind CG_sYKind)
    (progn
      (setq CG_sYKind &sYKind)  ; ����
      (setq CG_eSymArea$  nil)  ; ��̈����3DSOLID�}�`�����X�g
      (setq CG_eSym$Area$ nil)  ; ��̈���̃O���[�v�}�`���܂ޑS�}�`���X�g

      (setq CG_dArea$ (KCFGetDaByYasReg &eYashi &sYKind)) ; ��̈���W���擾
      (setq CG_dAreaMinMax$ (GetPtMinMax CG_dArea$))      ; ��̈�̍ŏ��ő���W
    )
  )
  ; 01/06/11 HN E-ADD
  ; 01/07/19 HN E-MOD ����O��ƈႤ�ꍇ�́A��̈�����擾

  ; ��̊�_
  (setq #xBas (cdr (assoc 10 (entget &eYashi))))

  ; ��̊g���f�[�^���擾
  (setq #sXd$ (CFGetXData &eYashi "RECT"))

; 01/07/17 TM DEL
; ; ��_����C ������Ɍ��������W�B100 �ɋ����Ƃ��Ă̈Ӗ��͂Ȃ�
; (setq #xC (polar #xBas (- (dtr (atoi (nth 1 #sXd$))) (dtr 180)) 100))
; ; ��_����D ������Ɍ��������W
; (setq #xD (polar #xBas (- (dtr (atoi (nth 1 #sXd$))) (dtr 90)) 100))
; 01/07/17 TM DEL

  ; 01/07/11 TM DEL ���݂͑S�Ă̖�ŗ̈�}�`���擾�ł��邽�߁A����͕s�v
  ;DEL ; ��̈�}�`�擾
  ;DEL (setq #nPos (vl-string-search &sYKind (nth 2 #sXd$)))
  ;DEL (if #nPos
  ;DEL   (setq #hReg (nth (+ 3 #nPos) #sXd$))
  ;DEL )

; 01/07/11 TM DEL ���݂͔���s�v
; (if (and #hReg (/= "" #hReg))
;   ; ��̈�}�`������ꍇ
;   (progn
; 01/07/11 TM DEL ���݂͔���s�v

      ; 01/07/19 HN S-DEL ��Ɉړ�
      ;@DEL@; ��̈�擾
      ;@DEL@(setq #xYas$ (KCFGetDaByYasReg &eYashi &sYKind))
      ;@DEL@; DEBUG(princ "\n#xYas$: ")(princ #xYas$)
      ; 01/07/19 HN E-DEL ��Ɉړ�

      ; 01/06/11 HN S-MOD
      ; ��}�`���Q�ƍς݂ł���΁A�܂܂�Ă���
      (if (member &eSym CG_eSym$Area$)
        (progn
          (setq #Ret T)
        )
        (progn
          (setq #iCnt 0)
          ; 01/07/19 HN DEL �Y�[���������ړ�
          ;@DEL@; 01/07/19 HN ADD �Y�[��������ǉ�
          ;@DEL@;@MOD@(command "_.ZOOM" (car CG_dAreaMinMax$) (cadr CG_dAreaMinMax$))
          ;@DEL@(command "_.ZOOM" (getvar "LIMMIN") (getvar "LIMMAX"))

          ; ��̈���� 3DSOLID ���擾

          ;"3DSOLID"�����łȂ�"BODY"���܂߂� 03/07/24 YM MOD-S
;;;          (setq #ssSym (ssget "CP" CG_dArea$ '((0 . "3DSOLID")))) ; 01/07/19 HN MOD #xYas$ �� CG_dArea$

          (setq #ssSym (ssget "CP" CG_dArea$ '(
                                                (-4 . "<OR")
                                                  (0 . "3DSOLID")
                                                  (0 . "BODY")
                                                (-4 . "OR>")
                                              )
          )) ; 01/07/19 HN MOD #xYas$ �� CG_dArea$

          ;"BODY"���܂߂� 03/07/24 YM MOD-E

          (if #ssSym
            ; 3DSOLID ���Q�ƍς݂��ǂ���
            (while (and (= nil #Ret) (< #iCnt (sslength #ssSym)))
              (CFDispStar)  ; "�v�Z��"�\��
              (setq #eSym (ssname #ssSym #iCnt))
              ; 3DSOLID�}�`���Q�Ƃ���Ă��Ȃ����
              (if (not (member #eSym CG_eSymArea$))
                (progn
                  ; �Q�ƍςݐ}�`�̓o�^
                  (setq CG_eSymArea$ (cons #eSym CG_eSymArea$))
                  ; �O���[�v�}�`���Q�ƍς݂Ƃ��ēo�^
                  (setq #eSym$ (CFGetGroupEnt #eSym))
                  (setq CG_eSym$Area$ (append #eSym$ CG_eSym$Area$))
                )
                ;@DEL@(setq #Ret T) ; 01/07/18 TM ADD  ; 01/07/19 HN DEL
              )
              ; ��}�`���Q�ƍς݂ł���΁A�܂܂�Ă���
              (if (member &eSym CG_eSym$Area$)
                (progn
                  (setq #Ret T)
                )
              )
              (setq #iCnt (1+ #iCnt))
            )
          )
        )
      )
      ; 01/06/11 HN E-MOD

; 01/07/11 TM DEL ���݂͔���s�v
;    )
;
;   ; ��̈�}�`���Ȃ��ꍇ
;   (progn
;     ; ��Ɣ�r���ėL�����`�F�b�N
;     ; 01/06/08 TM ���� A�`D ��ɂ����Ă���̈�������ݒ肵�Ă��邽�߁AP��M �ȊO�͂����͒ʂ�Ȃ��͂�
;     (foreach #xPt &dSym$
;
;       (cond
;         ((= &sYKind "B")
;           (if (= 1 (CFArea_rl #xBas #xC #xPt))
;             (setq #Ret T)
;           )
;         )
;         ((= &sYKind "D")
;           (if (= -1 (CFArea_rl #xBas #xC #xPt))
;             (setq #Ret T)
;           )
;         )
;         ((= &sYKind "A")
;           (if (= 1 (CFArea_rl #xBas #xD #xPt))
;             (setq #Ret T)
;           )
;         )
;         ((= &sYKind "C")
;           (if (= -1 (CFArea_rl #xBas #xD #xPt))
;             (setq #Ret T)
;           )
;         )
;         ((or (= &sYKind "E") (= &sYKind "F"))
;           (princ "\n����ُ�ł��B")
;         )
;         ; ���ʐ}�E�p�[�X�}�w�莞�͂��ׂĂ̓_�� T ��Ԃ�
;         ((or (= &sYKing "M") (= &sYKind "P")) (setq #Ret T))
;
;         ; ���̑�
;         (t (princ "\n�ُ�Ȗ: ") (princ &sYKind))
;       );_cond
;     );_foreach
;   )
; );_if #hReg
; 01/07/11 TM DEL ���݂͔���s�v

    #Ret

);_ KCFIsAreaMatchYashi

  ;;;<HOM>************************************************************************
  ;;; <�֐���>  : KCFItemSurplus
  ;;; <�����T�v>: ���ёI���֐�
  ;;;           : �I��ē��̈��̱��т�������
  ;;; <�߂�l>  :
  ;;; <�쐬>    : 01/09/06 SN ADD
  ;;; <���l>    : ItemSurplus �����ذ��or��\����Ԃ̉�w���ΏۂƂ���
  ;;;************************************************************************>MOH<
  (defun KCFItemSurplus
    (
    &ss
    &XDataLst$$
    /
    #ssGrp #ssRet #ssErr #ssWork
    #membFlag #wFlag
    #i #i2
    #en #engrp
    #layerdata #layername$
    )

    ;���ݎg�p���̉�w�ꗗ���擾
    (setq #layername$ '())
    (setq #layerdata (tblnext "LAYER" T))
    (while #layerdata
      (setq #layername$ (append #layername$ (list (cdr (assoc 2 #layerdata)))))
      (setq #layerdata (tblnext "LAYER" nil))
    )

    (setq #i 0)
    (if &ss (progn
      (setq #ssRet (ssadd))
      (setq #ssErr (ssadd))
      ;�I��ē��̑S�Ă�Entity�ɑ΂��������s��
      (repeat (sslength &ss)
        (setq #en (ssname &ss #i))
        ;�߂�l�I��ĂɊ܂܂�Ă��Ȃ�Entity��Ώۂɂ���B
        (if (and (not (ssmemb #en #ssRet))
                 (not (ssmemb #en #ssErr)))
          (cond
            ;��ٰ�߱��т̏���
            ((and (setq #engrp (SearchGroupSym (ssname &ss #i)))
                  (setq #ssGrp (CFGetSameGroupSS #engrp))
                  (CheckXData #engrp (nth 1 &XDataLst$$)))
              (setq #ssWork (ssadd))
              (setq #i2 0)
              (setq #membFlag T)
              (setq #wFlag T)
              ;���т�Entity���S�Ĉ����̑I��ĂɊ܂܂�Ă��邩��������B
              (repeat (sslength #ssGrp)
                (setq #en (ssname #ssGrp #i2))
                (if (and (not (ssmemb #en &ss))                            ;�I��Ă����ް�łȂ����
                         (member (cdr (assoc 8 (entget #en))) #layername$));��޼ު�ĉ�w�����ݎg�p��
                  (if (/= (cdr (assoc 0 (entget #en))) "INSERT") ; 01/04/09 YM
                    (setq #membFlag nil)               ;"INSERT"�łȂ���΂Ƃ���������t�� 01/04/09 YM
                  );_if                                          ; 01/04/09 YM
                  (ssadd (ssname #ssGrp #i2) #ssWork);
                );end if
                (setq #i2 (1+ #i2))
              );end repeat
              ;���т̑S�Ă����ް���܂܂�Ă�����
              (if #membFlag
                (progn;THEN
                  ;���т̑S�Ă̵�޼ު�Ă�߂�I��Ăɉ��Z
                  (setq #i2 0)
                  (repeat (sslength #ssGrp)
                    (ssadd (ssname #ssGrp #i2) #ssRet)
                    (setq #i2 (1+ #i2))
                  );end repeat
                );end progn
                (progn;ELSE
                  ;�ꕔ�I���̵�޼ު�Ă������p�I��Ăɉ��Z(���x���ߗp)
                  (setq #i2 0)
                  (repeat (sslength #ssWork)
                    (ssadd (ssname #ssWork #i2) #ssErr)
                    (setq #i2 (1+ #i2))
                  );end repeat
                );end progn
              );end if
              (setq #ssWork nil)
              (setq #ssGrp nil)
            );end progn
            ;ܰ�į�ߥ̨װ�ȂǸ�ٰ�߈ȊO�̱���
            ((CheckXData #en (nth 0 &XDataLst$$))
              (ssadd #en #ssRet)
            )
          );end cond
        );end if
        (setq #i (1+ #i))
      );end repeat
      (setq #ssErr nil)
    ));end if - end progn
    #ssRet
  );ItemSurplus

; 02/02/04 HN S-MOD ��]�p�x���王�_�擾�̏�����ύX
;@DEL@  ;<HOM>*************************************************************************
;@DEL@  ; <�֐���>    : SKFGetViewByAngle
;@DEL@  ; <�����T�v>  : ��]�p�x���王�_��ނ��l������
;@DEL@  ; <�߂�l>    : �i���_��� WD�t���O�j
;@DEL@  ; <�쐬>      : 1998-06-22
;@DEL@  ; <���l>      : ���_��ނ͈ȉ��̕\����l������
;@DEL@  ;               ��]�p�x     �W�J�`�}    �W�J�a�}    �W�J�b�}    �W�J�c�}
;@DEL@  ;                   �O�x       "03"        "05"        "04"        "06"
;@DEL@  ;                 �X�O�x       "05"        "04"        "06"        "03"
;@DEL@  ;               �P�W�O�x       "04"        "06"        "03"        "05"
;@DEL@  ;               �Q�V�O�x       "06"        "03"        "05"        "04"
;@DEL@  ;               ����ȊO        ""          ""          ""          ""
;@DEL@  ;*************************************************************************>MOH<
;@DEL@
;@DEL@  (defun SKFGetViewByAngle (
;@DEL@    &angle   ; (REAL)     ��]�p�x
;@DEL@    &kind    ; (STR)      �}�ʎ�ށi�W�J�`�}:"A" �W�J�a�}:"B" �W�J�b�}:"C" �W�J�c�}:"D"�j
;@DEL@    /
;@DEL@    #deg #ret #wd
;@DEL@    )
;@DEL@
;@DEL@    ;��]�p�x��x���\���ɕϊ�����
;@DEL@    (setq #deg (/ (* &angle 180.0) PI))
;@DEL@    (if (> 0.0 #deg)
;@DEL@      (while (= nil (< 0.0 #deg 360.0))
;@DEL@        (setq #deg (+ #deg 360.0))
;@DEL@      )
;@DEL@    )
;@DEL@    (if (< 360.0 #deg)
;@DEL@      (while (= nil (< 0.0 #deg 360.0))
;@DEL@        (setq #deg (- #deg 360.0))
;@DEL@      )
;@DEL@    )
;@DEL@    (if (equal #deg 360.0 0.01)
;@DEL@      (setq #deg 0.0)
;@DEL@    )
;@DEL@    ;�p�x��
;@DEL@    (cond
;@DEL@      ((or (<= 315.0 #deg 360.0) (<= 0.0 #deg 45.0)) (setq #deg   0.0)) ;0
;@DEL@      ((<=  45.0 #deg 135.0)                         (setq #deg  90.0)) ;90
;@DEL@      ((<= 135.0 #deg 225.0)                         (setq #deg 180.0)) ;180
;@DEL@      ((<= 225.0 #deg 315.0)                         (setq #deg 270.0)) ;270
;@DEL@    )
;@DEL@    ;���_�������l��
;@DEL@    (cond
;@DEL@      ((equal   0.0 #deg 0.01)                         ;    �O�x
;@DEL@        (cond
;@DEL@          ((equal "A" &kind)  (setq #ret "03" #wd "W"))            ; ��
;@DEL@          ; 01/05/25 TM ADD �F �ǉ�
;@DEL@          ((or (equal "B" &kind) (equal "E" &kind) (equal "F" &kind))  (setq #ret "05" #wd "D"))
;@DEL@                                                                  ; L���ʁi�����ʁj
;@DEL@          ((equal "C" &kind)  (setq #ret "04" #wd "W"))            ; �w��
;@DEL@          ((equal "D" &kind)  (setq #ret "06" #wd "D"))            ; R���ʁi�E���ʁj
;@DEL@        ) ; end cond
;@DEL@      )
;@DEL@      ((equal  90.0 #deg 0.01)                         ;  �X�O�x
;@DEL@        (cond
;@DEL@          ((equal "A" &kind)  (setq #ret "05" #wd "D"))            ; L���ʁi�����ʁj
;@DEL@          ((or (equal "B" &kind) (equal "E" &kind) (equal "F" &kind))  (setq #ret "04" #wd "W")) ; �w��
;@DEL@          ((equal "C" &kind)  (setq #ret "06" #wd "D"))            ; R���ʁi�E���ʁj
;@DEL@          ((equal "D" &kind)  (setq #ret "03" #wd "W"))            ; ����
;@DEL@        ) ; end cond
;@DEL@      )
;@DEL@      ((equal 180.0 #deg 0.01)                         ;�P�W�O�x
;@DEL@        (cond
;@DEL@          ((equal "A" &kind)  (setq #ret "04" #wd "W"))            ; �w��
;@DEL@          ((or (equal "B" &kind) (equal "E" &kind) (equal "F" &kind))  (setq #ret "06" #wd "D"))
;@DEL@                                                                    ; R���ʁi�E���ʁj
;@DEL@          ((equal "C" &kind)  (setq #ret "03" #wd "W"))            ; ����
;@DEL@          ((equal "D" &kind)  (setq #ret "05" #wd "D"))            ; L���ʁi�����ʁj
;@DEL@        ) ; end cond
;@DEL@      )
;@DEL@      ((equal 270.0 #deg 0.01)                         ;�Q�V�O�x
;@DEL@        (cond
;@DEL@          ((equal "A" &kind)  (setq #ret "06" #wd "D"))            ; R���ʁi�E���ʁj
;@DEL@          ((or (equal "B" &kind) (equal "E" &kind) (equal "F" &kind)) (setq #ret "03" #wd "W")); ����
;@DEL@          ((equal "C" &kind)  (setq #ret "05" #wd "D"))            ; L���ʁi�����ʁj
;@DEL@          ((equal "D" &kind)  (setq #ret "04" #wd "W"))            ; �w��
;@DEL@        ) ; end cond
;@DEL@      )
;@DEL@    ) ; end cond
;@DEL@
;@DEL@    ;�������Ă͂܂�Ȃ���΋󕶎����Ԃ�
;@DEL@    (if (= nil #ret)
;@DEL@      (progn
;@DEL@        ; DEBUG (princ "\n�Y������ʂȂ��H�H")
;@DEL@      ; DEBUG (princ &angle)(princ ",")(princ &kind)
;@DEL@      (setq #ret "")
;@DEL@    )
;@DEL@  ) ; end if
;@DEL@
;@DEL@  (list #ret #wd) ; return
;@DEL@) ; SKFGetViewByAngle


;;;<HOM>************************************************************************
;;; <�֐���>  : SKFGetViewByAngle
;;; <�����T�v>: ��]�p�x���王�_��ނ��l������
;;; <�߂�l>  : �i���_��� WD�t���O�j
;;; <����>    : 2002-02-01 HN
;;; <���l>    : ���_��ނ͈ȉ��̕\����l������
;;;               ��]�p�x     �W�J�`�}    �W�J�a�}    �W�J�b�}    �W�J�c�}
;;;                   �O�x       "03"        "05"        "04"        "06"
;;;                 �X�O�x       "05"        "04"        "06"        "03"
;;;               �P�W�O�x       "04"        "06"        "03"        "05"
;;;               �Q�V�O�x       "06"        "03"        "05"        "04"
;;;               ����ȊO        ""          ""          ""          ""
;;;************************************************************************>MOH<
(defun SKFGetViewByAngle
  (
  &rAng       ; ��]�p�x
  &sKind      ; �}�ʎ�ށi�W�J�`�}:"A" �W�J�a�}:"B" �W�J�b�}:"C" �W�J�c�}:"D"�j
  /
  #rDeg       ; ��]�p�x(�x���\��)
  #sFace      ; �ʎ��
  #sWd        ;
  )

  ;��]�p�x��x���\���ɕϊ�����
  (setq #rDeg (/ (* &rAng 180.0) PI))
  (while (> 0.0 #rDeg)
    (setq #rDeg (+ #rDeg 360.0))
  )
  (while (< 360.0 #rDeg)
    (setq #rDeg (- #rDeg 360.0))
  )
  (if (equal #rDeg 360.0 0.01)
    (setq #rDeg 0.0)
  )

  ;���_�������l��
  (setq #sFace "")
  (cond
    ((equal 0.0 #rDeg 0.01)   ; �O�x
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "03" #sWd "W")) ; ����
        ((member &sKind (list "B" "E" "F")) (setq #sFace "05" #sWd "D")) ; ���ʍ�
        ((member &sKind (list "C"        )) (setq #sFace "04" #sWd "W")) ; �w��
        ((member &sKind (list "D"        )) (setq #sFace "06" #sWd "D")) ; ���ʉE
      );_cond
    )
    ((equal 90.0 #rDeg 0.01)  ; �X�O�x
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "05" #sWd "D")) ; ���ʍ�
        ((member &sKind (list "B" "E" "F")) (setq #sFace "04" #sWd "W")) ; �w��
        ((member &sKind (list "C"        )) (setq #sFace "06" #sWd "D")) ; ���ʉE
        ((member &sKind (list "D"        )) (setq #sFace "03" #sWd "W")) ; ����
      );_cond
    )
    ((equal 180.0 #rDeg 0.01) ; �P�W�O�x
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "04" #sWd "W")) ; �w��
        ((member &sKind (list "B" "E" "F")) (setq #sFace "06" #sWd "D")) ; ���ʉE
        ((member &sKind (list "C"        )) (setq #sFace "03" #sWd "W")) ; ����
        ((member &sKind (list "D"        )) (setq #sFace "05" #sWd "D")) ; ���ʍ�
      );_cond
    )
    ((equal 270.0 #rDeg 0.01) ; �Q�V�O�x
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "06" #sWd "D")) ; ���ʉE
        ((member &sKind (list "B" "E" "F")) (setq #sFace "03" #sWd "W")) ; ����
        ((member &sKind (list "C"        )) (setq #sFace "05" #sWd "D")) ; ���ʍ�
        ((member &sKind (list "D"        )) (setq #sFace "04" #sWd "W")) ; �w��
      );_cond
    )
    ((< 0.0 #rDeg 90.0)       ; �O�`�X�O�x
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "03" #sWd "W")) ; ����
        ((member &sKind (list "B" "E" "F")) (setq #sFace "04" #sWd "W")) ; �w��
        ((member &sKind (list "C"        )) (setq #sFace "04" #sWd "W")) ; �w��
        ((member &sKind (list "D"        )) (setq #sFace "03" #sWd "W")) ; ����
      );_cond
    )
    ((< 90.0 #rDeg 180.0)     ; �X�O�`�P�W�O�x
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "04" #sWd "W")) ; �w��
        ((member &sKind (list "B" "E" "F")) (setq #sFace "04" #sWd "W")) ; �w��
        ((member &sKind (list "C"        )) (setq #sFace "03" #sWd "W")) ; ����
        ((member &sKind (list "D"        )) (setq #sFace "03" #sWd "W")) ; ����
      );_cond
    )
    ((< 180.0 #rDeg 270.0)    ; �P�W�O�`�Q�V�O�x
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "04" #sWd "W")) ; �w��
        ((member &sKind (list "B" "E" "F")) (setq #sFace "03" #sWd "W")) ; ����
        ((member &sKind (list "C"        )) (setq #sFace "03" #sWd "W")) ; ����
        ((member &sKind (list "D"        )) (setq #sFace "04" #sWd "W")) ; �w��
      );_cond
    )
    ((< 270.0 #rDeg 360.0)    ; �Q�V�O�`�R�U�O�x
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "03" #sWd "W")) ; ����
        ((member &sKind (list "B" "E" "F")) (setq #sFace "03" #sWd "W")) ; ����
        ((member &sKind (list "C"        )) (setq #sFace "04" #sWd "W")) ; �w��
        ((member &sKind (list "D"        )) (setq #sFace "04" #sWd "W")) ; �w��
      );_cond
    )
  );_cond

  (list #sFace #sWd)
);_defun
; 02/02/04 HN E-MOD ��]�p�x���王�_�擾�̏�����ύX

;<HOM>*************************************************************************
; <�֐���>    : AlignDoorBySym$
; <�����T�v>  : �V���{�����X�g����2D-P�ʂ̔��ʂ�z�u����
; <�߂�l>    : �쐬���ꂽ����
; <���l>      :
; <�쐬>      : 00/01/14
; <�x��>      : 01/03/12 YM ��۰��� CG_DOORLST �̎g�����ɒ��ӁI
;               �g���������ƓW�J�}�œ������ނɔ��𒣂�Ȃ��Ȃ�
;*************************************************************************>MOH<
(defun AlignDoorBySym$ (
  &ss$        ; �_�~�[�̈�I���G���e�B�e�B���X�g
  /
  #ss #ssD #i #enD #ed$ #en #code #Dooren$ #entlast
  #ANG #DR_SS #DUM$ #MVPT #SYMD #SYMPT #TOKU$ #Dooren0$
  #SYMNORMAL$ #SYMTOKU$ #DOORLST$
  )

  ;//////////////////////////////////////////////////////////////
  ; ��w0_door�̂��̂ɍi��
  ;//////////////////////////////////////////////////////////////
    (defun ##0_door (
      &ss
      /
      #ELM #I #RET
      )
      (setq #i 0 #ret (ssadd))
      (repeat (sslength &ss)
        (setq #elm (ssname &ss #i))
        (if (= (cdr (assoc 8 (entget #elm))) "0_door") ; ��w"0_door"
          (ssadd #elm #ret)
        );_if
        (setq #i (1+ #i))
      )
      #ret
    );
  ;//////////////////////////////////////////////////////////////

  ;�L���r�l�b�g�̐}�`��I���G���e�B�e�B�Ŋl��
  (setq #ss (ssadd))
  (mapcar
   '(lambda ( #ssD )
      (setq #i 0)
      (repeat (sslength #ssD)
        (setq #enD (ssname #ssD #i))  ; �_�~�[�}�`��
        (setq #ed$ (CfGetXData #enD "G_SKDM"))
        (mapcar
         '(lambda ( #en )
            (if (not (ssmemb #en #ss))
              (progn
                (setq #code (CfGetSymSKKCode #en 1))
; 02/09/04 YM DEL ����ȯĂł���Ƃ����������폜����
;;;02/09/04YM@DEL                (if (equal CG_SKK_ONE_CAB #code)
                  (ssadd #en #ss)
;;;02/09/04YM@DEL                )
              )
            )
          )
          (cdr (cdr #ed$))
        )
        (setq #i (1+ #i))
      )
    )
    &ss$
  )
  ;�I���G���e�B�e�B���}�`�����X�g
  (setq #Dooren$ (Ss2En$ #ss))

  ; 01/03/12 YM ADD �������ނƈ�ʷ��ނ𕪂���
  ; �������ނ́A������ڰ�ײ݈ꎞ�폜�A�ꎞ��ڰ�ײݍ쐬���Ȃ���
  ; �����L�k���Ȃ����߁A�ʏ��ނƏ����𕪂���
  (setq #symTOKU$ nil #symNORMAL$ nil #doorlst$ nil)
  (foreach en #Dooren$
    (if (setq #TOKU$ (CFGetXData en "G_TOKU"));2011/12/09 YM MOD G_TOKU�����ύX
      (setq #symTOKU$ (append #symTOKU$ (list en)))     ; �������޺���ނ��g�p
      (setq #symNORMAL$ (append #symNORMAL$ (list en))) ; �ʏ���(��АL�k�܂�)
    );_if
  )
  ; �������ޔ��\����́A�������޺���ގ��Ɠ��������ɂ���
  ; PCD_MakeViewAlignDoor�ɓn��(��ڰ�ײ݂��ꎞ�ǉ�)
  ; �������޺���ގ��s���׸ނ𗧂Ă� (CG_TOKU) 01/03/12 YM ADD
  (setq CG_TOKU T) ; �������ގ��s��
  (foreach #symTOKU #symTOKU$
    (setq #TOKU$ (CFGetXData #symTOKU "G_TOKU"))

; �������޺���ޒ��͔��̓\�蒼���������Ɋ��������g�p���� 01/10/11 YM DEL
;;;01/10/11YM@DEL   (setq CG_TOKU_BW (nth 4 #TOKU$)) ; ��ڰ�ײ݈ʒu
;;;01/10/11YM@DEL   (setq CG_TOKU_BD (nth 5 #TOKU$)) ; ��ڰ�ײ݈ʒu
;;;01/10/11YM@DEL   (setq CG_TOKU_BH (nth 6 #TOKU$)) ; ��ڰ�ײ݈ʒu
    ;// ���ʂ̓\��t��
    (PCD_MakeViewAlignDoor (list #symTOKU) 2 T)
    (setq #doorlst$ (append #doorlst$ CG_DOORLST))
  )
  (setq CG_TOKU nil) ; �������ގ��s��

  ;// ���ʂ̓\��t��(�����ȊO�̏ꍇ)
  (if #symNORMAL$
    (progn
      (PCD_MakeViewAlignDoor #symNORMAL$ 2 T)
      (setq #doorlst$ (append #doorlst$ CG_DOORLST))
    )
  );_if

  (setq CG_DOORLST #doorlst$)

;;; ((<�}�`��: 199c4e0>  6)
;;;  (<�}�`��: 199d238>  6)
;;;  (<�}�`��: 199db88>  6)
;;;  (<�}�`��: 199efa0>  4)
;;;  (<�}�`��: 199efa0>  5)
;;;  (<�}�`��: 98f6988>  4)
;;;  (<�}�`��: 98f6988>  5)
;;;  (<�}�`��: 98f7640>  6)
;;; )

;;;01/03/12YM@  (setq #Dooren0$ #Dooren$)
;;;01/03/12YM@
;;;01/03/12YM@  ; 01/03/10 YM �}�`�����X�g����������ނ݂̂���菜��
;;;01/03/12YM@  (setq #dum$ nil)
;;;01/03/12YM@  (foreach Dooren #Dooren$
;;;01/03/12YM@    (if (and (setq #TOKU$ (CfGetXData Dooren "G_TOKU"))
;;;01/03/12YM@             (= (nth 3 #TOKU$) 1)) ; �������޺���ނ��g�������̂��ǂ���
;;;01/03/12YM@      nil
;;;01/03/12YM@      (setq #dum$ (append #dum$ (list Dooren)))
;;;01/03/12YM@    );_if
;;;01/03/12YM@  );foreach
;;;01/03/12YM@  (setq #Dooren$ #dum$)

  ; 2000/06/22 HT DEL ���x���P
  ;(setq #ss (ssadd))
;;;01/03/12YM@  (if (/= nil #Dooren$)
;;;01/03/12YM@    (progn
      ; 2000/06/22 HT DEL ���x���P
      ;(setq #entlast (entlast))
      ; 2000/06/21 ���폜���[�h�ɕύX�i[���]-[�\������]���C�Ή��j
      ;(PCD_MakeViewAlignDoor #Dooren$ 2 nil)

;;;01/03/12YM@      (PCD_MakeViewAlignDoor #Dooren$ 2 T) ; ��ŏ�������

      ; 2000/06/22 HT DEL ���x���P START
      ;(if (/= nil (setq #en (entnext #entlast)))
      ;  (progn
      ;    (ssadd #en #ss)
      ;    (while (setq #en (entnext #en))
      ;      (ssadd #en #ss)
      ;    )
      ;  )
      ;)
      ; 2000/06/22 HT DEL ���x���P END
;;;01/03/12YM@    )
;;;01/03/12YM@  );_if

  ;���ʒu��O�ʂɐ��@D�����ړ� 01/03/14 YM START
  ;�w�ʔ��͈ړ����Ȃ�(���}�`�͸�۰��� CG_DOORLST �𗘗p)���\��t�����ɸ�ٰ�߉����Ȃ� 01/03/14 YM ADD
  (foreach DOORLST CG_DOORLST
    (setq #sym (car DOORLST))
    (if (and (not (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB) "?" (itoa CG_SKK_THR_CNR)))) ; ��Ű���ނłȂ� ; 01/08/31 YM MOD ��۰��ى�
             (not (CFGetXData #sym "G_TOKU")))         ; �������ނłȂ�
      (progn
        (setq #DR_SS (CMN_enlist_to_ss (cadr DOORLST))) ; ���}�`ؽ�==>�I���
        (setq #symPT (cdr (assoc 10 (entget #sym))))    ; ��_
        (setq #symD (nth 4 (CfGetXData #sym "G_SYM")))  ; ���@D
        (setq #ang  (nth 2 (CfGetXData #sym "G_LSYM"))) ; �z�u�p�x
        (cond
          ((= (nth 2 DOORLST) 3)
            (setq #MVPT (polar #symPT (- #ang (dtr 90)) #symD)) ; ���ʔ�
          )
          ((= (nth 2 DOORLST) 4)
            (setq #MVPT (polar #symPT (+ #ang (dtr 90)) 0)) ; �w�ʔ�
          )
          (T
            (setq #MVPT (polar #symPT (- #ang (dtr 90)) #symD)) ; ���̑�???
          )
        );_cond
        (command "_move" #DR_SS "" #symPT #MVPT)
      )
    );_if
  );foreach
  ;���ʒu��O�ʂɐ��@D�����ړ� 01/03/10 YM END

;;;01/03/14@  ;���ʒu��O�ʂɐ��@D�����ړ� 01/03/10 YM START
;;;01/03/14@  (foreach sym #Dooren$
;;;01/03/14@    (if (not (CheckSKK$ sym (list (itoa CG_SKK_ONE_CAB) "?" (itoa CG_SKK_THR_CNR)))) ; 01/08/31 YM MOD ��۰��ى�
;;;01/03/14@      (progn ; ��Ű���ނ͏��O
;;;01/03/14@        (setq #DR_SS (KP_GetDoorSSFromSYM sym))
;;;01/03/14@        ;;;��w"0_door"�̂��̂ɍi��
;;;01/03/14@        (setq #DR_SS (##0_door #DR_SS))
;;;01/03/14@        (setq #symPT (cdr (assoc 10 (entget sym))))    ; ��_
;;;01/03/14@        (setq #symD (nth 4 (CfGetXData sym "G_SYM")))  ; ���@D
;;;01/03/14@        (setq #ang  (nth 2 (CfGetXData sym "G_LSYM"))) ; �z�u�p�x
;;;01/03/14@        (setq #MVPT (polar #symPT (- #ang (dtr 90)) #symD))
;;;01/03/14@        (command "_move" #DR_SS "" #symPT #MVPT)
;;;01/03/14@      )
;;;01/03/14@    );_if
;;;01/03/14@  );foreach
;;;01/03/14@  ;���ʒu��O�ʂɐ��@D�����ړ� 01/03/10 YM END �������ނ͑ΏۊO

  ; 2000/06/22 HT DEL ���x���P
  ;#ss
) ; AlignDoorBySym$

;<HOM>***********************************************************************
; <�֐���>    : KP_GetDoorSSFromSYM
; <�����T�v>  : ����ِ}�`��n���Ċ��ɑ��݂�����ʐ}�`�̑I��Ă��擾����
; <����>    :����ِ}�`
; <�߂�l>  :���ʐ}�`�̑I���
; <�쐬>    :01/03/09 YM
; <���l>    : PKD_EraseDoor �̐^��
;***********************************************************************>HOM<
(defun KP_GetDoorSSFromSYM (
  &sym
  /
  #300 #340 #EG$ #EG2 #RETSS #I #SS$
  )
  ;////////////////////////////////////////////////////////////////////
  ; �I���ؽ�==>�I��Ăɂ܂Ƃ߂�
  ;////////////////////////////////////////////////////////////////////
  (defun ##fromSS$toSS (
    &ss$
    /
    #ss #ELM #I #J
    )
    (setq #ss (ssadd))
    (foreach dum &ss$
      (if (> (sslength dum) 0)
        (progn
          (setq #j 0)
          (repeat (sslength dum)
            (setq #elm (ssname dum #j))
            (ssadd #elm #ss)
            (setq #j (1+ #j))
          )
        )
      );_if
    )
    #ss
  );
  ;////////////////////////////////////////////////////////////////////

  ;// �V���{����}�`�����b�N
  (command "_layer" "lo" "N_SYMBOL" "") ; LOۯ�
  (setvar "PICKSTYLE" 1)
  (setq #eg$ (entget &sym '("*")))
  (setq #i 0)
  (foreach #eg #eg$
    (if (= (car #eg) 330)
      (progn
        (setq #eg2 (entget (cdr #eg)))
        (setq #300 (cdr (assoc 300 #eg2))) ; �O���[�v�̐���
        (setq #340 (cdr (assoc 340 #eg2)))
        (if (= #300 SKD_GROUP_INFO) ; �O���[�v�̐��� 01/06/27 YM "DoorGroup"-->SKD_GROUP_INFO ��۰��ق��g�p
          (setq #SS$ (append #SS$ (list (CFGetSameGroupSS #340))))
        );_if
      )
    );_if
    (setq #i (1+ #i))
  );foreach
  (setvar "PICKSTYLE" 0)
  (command "_layer" "u" "N_SYMBOL" "")
  (##fromSS$toSS #SS$)
);KP_GetDoorSSFromSYM

;<HOM>************************************************************************
; <�֐���>  : GetWtAndFilr
; <�����T�v>: ���[�N�g�b�v�ƓV��t�B���[���l��
; <�߂�l>  : �I���Z�b�g
; <�쐬>    : 00/01/20
; <���l>    : ���ʐ}�̂Ƃ��̓��[�N�g�b�v�̂�
;             ��̈�}�`����nil�̂Ƃ��A���ׂĂ��Ώ�
;             �R�[�i�[��_��SKDM�̐}�`��u��
;             2000/06/12 HT    "G_WRKT" "G_BKGD" "G_FILR" "G_PANEL" 00/10/18���ׂĎ擾
;                        �����^���[�N�g�b�v�ɂ��Ή�
;************************************************************************>MOH<

(defun GetWtAndFilr (
  &en         ; ��}�`��
  &type       ; ���ʐ}�A�W�J�}�t���O�i"M":�p�[�X�} "P":���ʐ} "E":�W�J�}�j
  /
  #ss
  #pt$
  #flg
  #ssw
  #i
  #en
  ;#ed$
  ;#wpt
  ;#wpt$
  #flg2
  #gen$
  #gen
  ;#pp
  #ssf
  #fben
  #fpt
  #sXAppName$  ; �Ώې}�`��XData AppName
  #ij
  )
  (setq #ss (ssadd))
  (if (/= nil &en)
    (progn
      ; 01/04/25 TM MOD ��̈�̎d�l�ύX ZANZANZAN
      ;��̈�̍\�����W���l��
      ;(setq #pt$ (mapcar 'car (get_allpt_h &en)))
      (setq #pt$ (mapcar 'car (KCFGetDaByYasReg &en &type)))
      ; 01/04/25 TM MOD ��̈�̎d�l�ύX
      ; JudgeNaigai �΍�
      (setq #pt$ (append #pt$ (list (car #pt$))))
      (setq #flg nil)
    )
    (progn
      ;(princ "\n�t�B���[�E���[�N�g�b�v�Ȃ�")
      (setq #flg T)
    )
  )

  ; 2000/06/12  HT ���[�N�g�b�v�ƃo�b�N�K�[�h�ƃt�B���[�ƃX�y�[�T�[
  ;             �I���G���e�B�e�B�Ŋl��
  ; 01/04/28 MOD HN
  ;@DEL@(setq #XAppName$ (list "G_WRKT" "G_BKGD"))  ;00/10/18 HN MOD
  ; 01/05/31 TM MOD-S ���ʐ}�̏ꍇ�̓t�B���[�����Ȃ��悤�ɕύX
  (if (/= &type "P")
    (setq #XAppName$ (list "G_WRKT" "G_BKGD" "G_FILR"))
    ; 01/11/30 HN MOD �������}�`���Ώ�
    ;@MOD@(setq #XAppName$ (list "G_WRKT" "G_BKGD"))
    (setq #XAppName$ (list "G_WRKT" "G_BKGD" "G_WTHL"))
  )
  ; 01/05/31 TM MOD-E ���ʐ}�̏ꍇ�̓t�B���[�����Ȃ��悤�ɕύX
  (setq #ij 0)
  (repeat (length #XAppName$)
    ;���[�N�g�b�v��I���G���e�B�e�B�Ŋl��
    (setq #ssw (ssget "X" (list (list -3 (list (nth #iJ #XAppName$))))))

    ; 2000/07/06 HT YASHIAC  ��̈攻��ύX
    ;// ���������W�J�ΏۂƂȂ郏�[�N�g�b�v�𔲂�����
    (command "_.VIEW" "T")
    (setq #ssw (GetWtAndFilrByYashi #ssw &type (nth #iJ #XAppName$)))
    (if (/= nil #ssw)
      (progn
        (setq #i 0)
        (repeat (sslength #ssw)
          (setq #en (ssname #ssw #i))
          ;(setq #ed$ (CfGetXData #en (nth #iJ #XAppName$)))
          ; 2000/06/13 HT
          ;(setq #flg2 "OK")
          ;���[�N�g�b�v�R�[�i�[��_��
          ;(if (and (/= nil #ed$) (= (nth #iJ #XAppName$) "G_WRKT"))
          ;  (progn
          ;    ;(if (> 50 (length #ed$))     ; 00/04/10 HN MOD
          ;    ;  (setq #wpt (nth 45 #ed$))  ; New G_WRKT
          ;    (setq #wpt (nth 32 #ed$))  ; Old G_WRKT  2000/06/10 HT 2000/07/03 HT
          ;     ;)
          ;    (setq #wpt$ (cons #wpt #wpt$))
          ;    ;�̈�͈͓������f
          ;    (if (/= nil #flg)
          ;      (setq #flg2 "OK")
          ;      (if (JudgeNaigai #wpt #pt$)
          ;        (setq #flg2 "OK")
          ;        (setq #flg2 "NO")
          ;      )
          ;    )
          ;  )
          ;)
          ;(if (= "OK" #flg2)
          ;  (progn
              (if (or (= "M" &type) (= "P" &type))
                (progn             ;���ʐ}
                  (ssadd #en #ss)
                )
                (progn             ; �W�J�}
                  (if (or (= (nth #iJ #XAppName$) "G_BKGD")
                          (= (nth #iJ #XAppName$) "G_FILR"))
                    (progn
                     (ssadd #en #ss)
                    )
                    (progn
                      (setq #gen$ (SKFGetGroupEnt #en))
                      (mapcar
                       '(lambda ( #gen )
                          ; 2000/10/19 HT �C���e���A�p�l�� G_LSYM�}�`�͏Ȃ����������̂�
                          ; Z_??��w�̐}�`�݂̂Ƃ����B
                          (if (wcmatch (cdr (assoc 8 (entget #gen))) "Z_??")
                            (ssadd #gen #ss)
                          )
                        )
                        #gen$
                      )
                    )
                  );_if
                )
              )
          ;  )
          ;)
          ;;00/10/18 HN S-ADD
          ;(if (= (nth #iJ #XAppName$) "G_PANEL")
          ;  (progn
          ;    (ssadd #en #ss)
          ;  )
          ;)
          ;00/10/18 HN E-ADD
          (setq #i (1+ #i))
        )
        ; (setq #wpt$ (PtSort #wpt$ (angtof "5") T))
      )
    )
    (setq #ij (1+ #ij))
  ) ; repeat


  ;�V��t�B���[�i�W�J�}�̂݁j
  (if (/= "P" &type)
    (progn
      ; 01/05/31 TM ADD �e�X�g
      (setq #ssf (ssget "X" (list (list -3 (list "G_FILR")))))
      ; 2000/07/06 HT YASHIAC  ��̈攻��ύX
      ;// ���������W�J�ΏۂƂȂ郏�[�N�g�b�v�𔲂��o��
      (setq #ssf (GetWtAndFilrByYashi #ssf &type "G_FILR"))
      (if (/= nil #ssf)
        (progn
          (setq #i 0)
          (repeat (sslength #ssf)
            (setq #en (ssname #ssf #i))
            ;�V��t�B���[�\�����W�l��
            (setq #fben (nth 2 (CfGetXData #en "G_FILR")))
            (setq #fpt (car (mapcar 'car (get_allpt_h #fben))))
            ;�̈�͈͓������f
            (if (/= nil #flg)
              (setq #flg2 "OK")
              (if (JudgeNaigai #fpt #pt$)
                (setq #flg2 "OK")
                (setq #flg2 "NO")
              )
            )
;@@@(princ "\n#flg2: ")(princ #flg2)
            (if (= "OK" #flg2)
              (progn

;;;01/04/13Fri_YM@                (ssadd #en #ss)
;;;01/04/13Fri_YM@                ; 00/05/28 HN E-MOD �V��t�B���[�̐}�`�擾���@��ύX

;;;01/04/13Fri_YM@ �ǉ� START
                      (setq #gen$ (SKFGetGroupEnt #en))
                      (mapcar
                       '(lambda ( #gen )
                          ; 2000/10/19 HT �C���e���A�p�l�� G_LSYM�}�`�͏Ȃ����������̂�
                          ; Z_??��w�̐}�`�݂̂Ƃ����B
                          (if (wcmatch (cdr (assoc 8 (entget #gen))) "Z_??")
                            (ssadd #gen #ss)
                          )
                        )
                        #gen$
                      )
;;;01/04/13Fri_YM@ �ǉ� END

              )
            )
            (setq #i (1+ #i))
          )
        )
      )
    )
  )

  ; 2000/06/22 HT ��������p�����̂��ߍ폜
  ;; 2000/06/12 HT �T�C�h�p�l�����擾����
  ; DEL (setq #xSs (ssget "X" '((-3 ("G_LSYM")))))
  ; DEL (setq #i 0)
  ; DEL (if #xSs
  ; DEL   (progn
  ; DEL   (repeat (sslength #xSs)
  ; DEL     (if (= (CFGetSymSKKCode (setq #en (ssname #xSs #i)) 1) CG_SKK_ONE_SID)
  ; DEL       (progn
  ; DEL         (setq #gen$ (SKFGetGroupEnt #en))
  ; DEL         (mapcar
  ; DEL           '(lambda ( #gen )
  ; DEL              ; �u���[�N���C���͕s�v
  ; DEL              (if (= (CfGetXData #gen "G_BRK") nil)
  ; DEL                (ssadd #gen #ss)
  ; DEL              )
  ; DEL            )
  ; DEL           #gen$
  ; DEL         )
  ; DEL       )
  ; DEL     )
  ; DEL     (setq #i (1+ #i))
  ; DEL   )
  ; DEL   )
  ; DEL )

  #ss
)


;<HOM>*************************************************************************
; <�֐���>    : GetWtAndFilrByYashi
; <�����T�v>  : ���������W�J�ΏۂƂȂ郏�[�N�g�b�v�ƓV��t�B���[�𔲂��o��
; <�߂�l>    : �I���Z�b�g
; <�쐬>      : 00/01/20
; <���l>      : ���ʐ}�̂Ƃ��̓��[�N�g�b�v�̂�
;               ��̈�}�`����nil�̂Ƃ��A���ׂĂ��Ώ�
;               �R�[�i�[��_��SKDM�̐}�`��u��
;               2000/07/06 HT YASHIAC  ��̈攻��ύX �֐��ǉ�
;*************************************************************************>MOH<

(defun GetWtAndFilrByYashi (
    &ssw    ;(PICKSET)���[�N�g�b�v�I���Z�b�g
    &type   ;(STR)    ���ʐ}�A�W�J�����L���i"M":�p�[�X�} "P":���ʐ} "A or B or C or D or E":�W�J�}�j
    &app    ;(STR) �A�v���P�[�V������(G_WRKT,G_FILR)
    /
    #p1 #p2 #p3 #p4 ; �̈�̂S���̓_
    #xReg   ; ��̈�_��
    #sXp
    #sXd$   ; �g���}�`(??  �`����� �ݒ�)
    #sPt    ; ��_
    #rAng   ; ��̌���(�P��:rad)
    #ssw
    #eYas   ; ��}�`
    #dGr    ; ��}�`�̒��S�H
  )

  ; ��I���Z�b�g�擾
  (setq #sXp (ssget "X" '((-3 ("RECT")))))
  ; �����ʖ�擾
  ; 01/05/25 TM MOD-S �F�ǉ�
  ;(if (= &type "E")
  ;  (setq #sXp (SCFIsYashiType #sXp "*E*"))
  ;  (setq #sXp (SCFIsYashiType #sXp "*[ABCD]*"))
  ;)
  (cond
    ((or (= &type "E") (= &type "F"))
      (setq #sXp (SCFIsYashiType #sXp (strcat "*" &type "*")))
    )
    (t (setq #sXp (SCFIsYashiType #sXp "*[ABCD]*")))
  )
  ; 01/05/25 TM MOD-E �F�ǉ�

  ; 01/05/31 HN MOD ������ύX
  ;@MOD@(if #sXp
  (if (and (/= "M" &type) (/= "P" &type) #sXp)
    (progn
      (setq #eYas (ssname #sXp 0))
      ; ��g���f�[�^�擾
      (setq #sXd$ (CFGetXData #eYas "RECT"))

      ; ��p�x
      (setq #rAng (dtr (atoi (nth 1 #sXd$))))
      ; DEBUG (princ "\n��̌���: ")(princ #rAng)

      ; ���_
      (setq #sPt (cdr (assoc 10 (entget #eYas))))

      ; ��ɗ̈悪�w�肳��Ă��邩�H
      (setq #xReg$ (KCFGetDaByYasReg #eYas &type))
      (if #xReg$
        (progn
          ; 01/04/26 TM ADD ��̈悪�ݒ肳��Ă���ꍇ�A���_�����̓K���ȓ_�ɕύX����
          (if (not (JudgeNaigai #sPt #xReg$))
            (progn
              (setq #xGr
                (list
                  (/ (apply '+ (mapcar 'car  #xReg$)) (length #xReg$))
                  (/ (apply '+ (mapcar 'cadr  #xReg$)) (length #xReg$))
                )
              )
              ; 01/04/26 TM ADD �S���W�̒����ʒu ZAN
              (setq #sPt #xGr)
            )
          )
          ; �w��}�`���擾
          ; 04/04/08 MOD-S �Ζʃv�����Ή�
          ; 10000�ł́A�R�ʃr���[���̏c���̃r���[�ł̃Y�[���̈���͂ݏo��
          ;(command "ZOOM" "C" #sPt 10000)
          (command "ZOOM" "C" #sPt 20000)
          ; 04/04/08 MOD-S �Ζʃv�����Ή�

          ;(ssget "CP" (list #p1 #p2 #p3 #p4) (list (list -3 (list &app))))
          (ssget "CP" #xReg$ (list (list -3 (list &app))))
        )
        ; �w�肳��Ă��Ȃ��ꍇ�A���ׂẴ��[�N�g�b�v��Ԃ�
        &ssw
      )
    )
    (progn
      &ssw
    )
  )
) ; GetWtAndFilrByYashi

;/////////////////////////////////////


(defun c:iii ( / )
  (C:KPInsertBlock)
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KPDeleteBlock
;;; <�����T�v>  : �p�[�X���폜����(�p�[�X�폜�R�}���h)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/03/13 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KPDeleteBlock (
  /
  #SS
  )
  ;// �R�}���h�̏�����
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (StartUndoErr)
  );_if

  ; 03/01/21 YM ADD-S
  (setq #dwgname (getvar "DWGNAME"))
  (if (vl-string-search "����" #dwgname) ; �߰��p����ڰ�
    (progn
      (CFAlertMsg "���̐}�ʂ̓p�[�X���폜�ł��܂���")
      (quit)
    )
  );_if
  ; 03/01/21 YM ADD-E

  (setq #lay-view3 "VIEW3")
  ; VIEWPORT (VIEW3:�ذ�߰��}���p)������΍폜
  (setq #ssVIEW (ssget "X" '((0 . "VIEWPORT"))))
  (setq #i 0)
  (if (and #ssVIEW (< 0 (sslength #ssVIEW)))
    (progn
      (repeat (sslength #ssVIEW)
        (setq #eg$ (entget (ssname #ssVIEW #i)))
        (setq #8  (cdr (assoc  8 #eg$)))
        (if (= #8 #lay-view3)
          (progn ; �ߋ����߰��ǉ�����
            ; VIEWPORT�}�`���폜
            (command "_layer" "U" #lay-view3 "ON" #lay-view3 "") ; ۯ�����,�\��
            (entdel (ssname #ssVIEW #i))
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (setvar "TILEMODE" 1) ; �������
  (setq #ss (ssget "X" '((8 . "0_PERS")))) ; �߰��̉�w
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (command "erase" #ss "")
      (princ "\n�p�[�X���폜���܂����B")
    )
    (CFAlertMsg "\n�}�ʂɃp�[�X�����݂��܂���B")
  );_if

  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (setq *error* nil)
  );_if
  (princ)
);C:KPDeleteBlock

;;;<HOM>************************************************************************
;;; <�֐���>  : KPfDelBlockDwg
;;; <�����T�v>: �W�J���}�t�H���_�̑S�t�@�C�����폜
;;; <�߂�l>  : LIST: �폜�����t�@�C����
;;;             nil : �t�@�C���Ȃ��A�܂��́A�폜�Ȃ�
;;; <�쐬>    : 01/07/27 HN
;;; <���l>    : �m�F�_�C�A���O��\�����܂��B
;;;************************************************************************>MOH<
(defun KPfDelBlockDwg
  (
  /
  #sPath      ; �W�J���}�t�H���_�i�t���p�X�j
  #sFile      ; �폜����W�J���}�̃t�@�C�����i�p�X�Ȃ��j
  #sFile$     ; �폜����W�J���}�̃t�@�C�������X�g
  )

  ;; �W�J���}�t�H���_���̑S�t�@�C�������X�g
  (setq #sPath (strcat CG_KENMEI_PATH "BLOCK\\"))
  (setq #sFile$ (vl-directory-files #sPath nil 1))

  ;; �t�@�C�������݂���ꍇ�A�m�F�_�C�A���O��\��
  (if #sFile$
    ;; �폜���Ȃ��ꍇ�̓t�@�C�������X�g���N���A
    ; 01/09/07 YM MOD-S ����Ӱ�ނł͑S�č폜����
    (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
  ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
      nil
      (if (= nil (CFYesNoDialog "�쐬�ς݂̓W�J���}�����ׂč폜���܂����H"))
        (setq #sFile$ nil)
      )
    );_if
    ; 01/09/07 YM MOD-E ����Ӱ�ނł͑S�č폜����
  )

  ;; �W�J���}�t�@�C�����폜
  (foreach #sFile #sFile$
    (vl-file-delete (strcat #sPath #sFile))
  )

  ;; �f�o�b�O�p�o��
  (if CG_DEBUG
    (progn
      (princ "\n**** KPfDelBlockDwg() ****")
      (foreach #sFile #sFile$
        (princ (strcat "\ņ�� " #sPath #sFile "���폜���܂���."))
      )
    )
  )

  #sFile$
) ;_defun KPfDelBlockDwg




;;;<HOM>************************************************************************
;;; <�֐���>  : ChViewport
;;; <�����T�v>: VIEWPORT�؂�ւ��֐�
;;; <����>    : VIEWPORT ID
;;; <�쐬>    : 03/01/17 YM
;;; <���l>    :
;;;************************************************************************>MOH<
(defun ChViewport ( &ID / )
  (setvar "TILEMODE" 0); ڲ�����ސ؂�ւ�
  (command "_.pspace") ; �߰�߰��Ԃɂ���
  (command "_mspace")  ; ���ً�Ԃɂ���
  (setvar "CVPORT" &ID); �ޭ��߰�ID
  (princ)
)

;///////////////// ����ڰč쐬�֐� //////////////////////////
(defun C:tt ( / #LAY-VIEW1)
  ; 2D�p�ޭ��߰ĉ�w"VIEW1"�쐬 A3-30
  (setq #lay-view1 "VIEW1")
  (if (tblsearch "layer" #lay-view1)
    (command "_layer"                "C" 1 #lay-view1 "L" SKW_AUTO_LAY_LINE #lay-view1 "")
    (command "_layer" "N" #lay-view1 "C" 1 #lay-view1 "L" SKW_AUTO_LAY_LINE #lay-view1 "")
  );_if

  (setvar "CLAYER" #lay-view1)

  ; 2D�ޭ��߰č�}
  (command "_mview" (list 8.7 4.2) (list 577.3 402.4)) ; A2
;;; (command "_mview" (list 5 5) (list 404.6 280.5)) ; A3

  (command "_mspace") ; 3D�ޭ��߰ē����ً��

  (princ)
)


;;;<HOM>*************************************************************************
;;; <�֐���>    : KPFreeInsertBlock
;;; <�����T�v>  : �ذ����ڰĂ��߰���}������(�ذ�߰��}�������)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 02/11/18 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KPFreeInsertBlock (
  /
  #69 #BLOCK #CS #EG$ #EVIEW3D #LAY-0PERS #LAY-VIEW2 #P1 #P2
  #8 #CLAYER #DWGNAME #I #LAY-VIEW3 #SSVIEW #SS #xSp
  )
  (setq #dwgname (getvar "DWGNAME"))
  (if (vl-string-search "����" #dwgname) ; �߰��p����ڰ�
    (progn
      (CFAlertMsg "���̐}�ʂɂ̓p�[�X��}���ł��܂���")
      (quit)
    )
  );_if

  ; ڲ�����ސ؂�ւ�
  (setvar "TILEMODE" 0)
  ; ��x�߰����ذ�}�������ꍇ��Ԃ��߰�߰��Ԃɂ��Ă����߰��폜���s��
  (command "_.pspace") ; �߰�߰��� 03/01/21 YM ADD

  (setq #lay-0pers "0_pers")
  (setq #lay-view2 "VIEW2")
  (setq #lay-view3 "VIEW3")

  ; VIEWPORT(VIEW2�߰��}���p,VIEW3�ذ�߰��}���p) �̌���
  (setq #ssVIEW (ssget "X" '((0 . "VIEWPORT"))))
  (setq #i 0)
  (if (and #ssVIEW (< 0 (sslength #ssVIEW)))
    (progn
      (repeat (sslength #ssVIEW)
        (setq #eg$ (entget (ssname #ssVIEW #i)))
        (setq #8  (cdr (assoc  8 #eg$)))
        (if (= #8 #lay-view3)
          (progn ; �ߋ����߰��ǉ�����
            (if (CFYesNoDialog "�}�������p�[�X���폜���܂���?")
              (progn ; �ߋ����߰��ǉ�����
                ; VIEWPORT�}�`���폜
                (command "_layer" "U" #lay-view3 "ON" #lay-view3 "") ; ۯ�����,�\��
                (entdel (ssname #ssVIEW #i))

                (setvar "TILEMODE" 1) ; �������
                (setq #ss (ssget "X" '((8 . "0_PERS")))) ; �߰��̉�w
                (if (and #ss (< 0 (sslength #ss)))
                  (progn
                    (command "erase" #ss "")
                    (princ "\n�p�[�X���폜���܂����B")
                  )
                );_if

                  (setvar "TILEMODE" 0) ; ڲ������
              )
            ; else
              (quit) ; �I��
            );_if
          )
        );_if

        (setq #i (1+ #i))
      )
    )
  );_if

  ; 2D�p�ޭ��߰ĉ�w"VIEW1"�쐬 A3-30
  (setq #lay-view3 "VIEW3")
  (if (tblsearch "layer" #lay-view3)
    (command "_layer"                "C" 1 #lay-view3 "L" SKW_AUTO_LAY_LINE #lay-view3 "") ; ��
    (command "_layer" "N" #lay-view3 "C" 1 #lay-view3 "L" SKW_AUTO_LAY_LINE #lay-view3 "") ; ��
  );_if

  ; 3D�ޭ��߰č�}
  ;// �J�[�\���T�C�Y
;;;  (setq #cs (getvar "CURSORSIZE"))
;;;  (setvar "CURSORSIZE" 100)
  ; ���݉�w�̕ύX
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" #lay-view3)

  (command "zoom" "E")  ; ��ʂ����ς��ɃY�[��
  (princ "\n�p�[�X�}���g���l�p(2�_)�ň͂��Ă�������: ")
  (setq #p1 (getpoint))
  (setq #p2 (getcorner #p1))
  (command "_mview" #p1 #p2)

  (setq #eVIEW3D (entlast))
  (setq #eg$ (entget #eVIEW3D))
  (setq #69 (cdr (assoc 69 #eg$))) ; VIEWPORT ID

  ; 3D���ً�ԓ����߰���w�ȊO���ذ��
  (command "_mspace") ; 3D�ޭ��߰ē����ً��
  (setvar "GRIDMODE" 0)
  (setvar "ORTHOMODE" 1)
  (setvar "SNAPMODE" 0)

  (command "_vplayer" "F" "*" "C" "")        ; �S��w�ذ��
  (command "_vplayer" "T" #lay-0pers "C" "") ; �߰���w�ذ�މ���

  ; ���ً�Ԃ��߰���}��
  (SKChgView "2,-2,1") ; �ޭ��ύX
  (command "zoom" "E") ; ��ʂ����ς��ɃY�[��

  (setvar "TILEMODE" 1)
  (setq #block (strcat CG_KENMEI_PATH "BLOCK\\" "M_0.dwg"))
  (if (findfile #block)
    (progn
      (command "_purge" "bl" "*" "N")
      (command "_purge" "bl" "*" "N")
      (command "_purge" "bl" "*" "N")

      (setvar "ELEVATION" 0.0)
      (command "_Insert" #block '(0.0 0.0) 1 1 0.0)

; �Œ�ʒu�ɑ}��
;;;      (princ "\n�p�[�X�}���ʒu: ")
;;;      (command "_Insert" #block pause "" "")
;;;      (princ "\n�z�u�p�x: ")
;;;      (command pause)

      (command "_explode" (entlast))
      (setq #xSp (ssget "P"))
      (setvar "ELEVATION" 0.0)
    )
    (progn
      (CFAlertMsg "\n�p�[�X������܂���B")
      (quit)
    )
  );_if

  (setvar "TILEMODE" 0) ; ڲ��Đ}�Ɉڍs
  (command "_.pspace")  ; �߰�߰���
  (command "zoom" "E")  ; ��ʂ����ς��ɃY�[��
  (command "_.MVIEW" "H" "ON" #eVIEW3D "")

  ; 3D���ޯ�
  (princ "\n�����̒������s���ĉ������B")
  (princ "\n")

  (ChViewport #69)

  (command "_mspace")
  (command "_camera" (list 6222 -6222 3411) (list -66 66 266)) ; �쓌���p�}�J�����ʒu
; (command "_.DVIEW" "ALL" "" "D" 7500 "X") ; �����}
  (command "_.DVIEW" #xSp "" "D" 7500 "X") ; �����}

;;; (command "zoom" "E")  ; ��ʂ����ς��ɃY�[��
  (command "_3DORBIT")

  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (setq *error* nil)
  );_if

  ; �I�����ݒ�
  (command "_.pspace") ; �߰�߰���
  ; "VIEW2"��ۯ�,��\��
;;; (command "_layer" "U" #lay-view3 "ON" #lay-view3 "") ; ۯ�����,�\��
  (command "_layer" "LO" #lay-view3 "OF" #lay-view3 "") ; ۯ�,��\��
  ;// �J�[�\���T�C�Y
;;;  (setvar "CURSORSIZE" #cs)
  ; ���݉�w�̕ύX
  (setvar "CLAYER" #clayer)


  ; ���b�Z�[�W�\��:
;;;  (CFYesDialog (strcat "�ēx�p�[�X�̌�����ύX����ɂ́A"))
  (princ "\n")(princ "\n")
  (princ "\n���p�[�X�̌�����ύX����ɂ͍ēx�p�[�X�}�����s���Ă�������")
  (princ)
);KPFreeInsertBlock


;<HOM>*************************************************************************
; <�֐���>    : KCFAutoMakeDiningPlanYashi
; <�����T�v>  : ���[�v�����p�̖�������ō쐬����(I�^�z��O��)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 08/12/23 YM
; <���l>      : �ABC���쐬����
;               �ȉ��̔z���O��
;               +-----+------------+
;               |     |            |
;               +-----+------------+
;*************************************************************************>MOH<
(defun KCFAutoMakeDiningPlanYashi (
  /
  #AEN #BEN #DD #DEN #LR #OFFSET #P1 #P2 #P3 #P4 #PB1 #PB2 #PB3 #PB4 
  #PD1 #PD2 #PD3 #PD4 #PP1 #PP2 #PP3 #PP4 #SCECOLOR #WW #YEN #YPT
  )

  (if (= nil (tblsearch "APPID" "RECT")) (regapp "RECT"))

  ; ���[�v�������ǂ����𔻒肷��
  (if (= CG_UnitCode "D");���[
    (progn
      ; �}�`�F�ԍ��̕ύX
      (setq #sCECOLOR (getvar "CECOLOR"))
      (setvar "CECOLOR" "50")

      ;���s���Ԍ�����W�JB,D�̈�����߂�
      (setq #DD (nth 53 CG_GLOBAL$));���s��
      (setq #DD (- (atoi (substr #DD 2 10))))
      (setq #WW (nth 55 CG_GLOBAL$));�Ԍ�
      (setq #WW (* (atoi (substr #WW 2 10)) 10))
      (setq #LR (nth 56 CG_GLOBAL$));L/R/N

      (if (or (= #LR "L")(= #LR "N"))
        (progn ;L����܂��͏���Ȃ�

          (setq #p1 (list 3600 0))
          (setq #p2 (list (+ 3600 #WW) 0))
          (setq #p3 (list (+ 3600 #WW) #DD))
          (setq #p4 (list 3600 #DD))

          ;I�^�̈���͂ޗ̈�̓_�����߂�
    ; +p1                    +p2
    ;    @               @
    ;    |               |
    ;    @               @
    ; +p4                    +p3
          (setq #offset 200)
          (setq #pp1 (polar #p1 (dtr 135.) #offset))
          (setq #pp2 (polar #p2 (dtr  45.) #offset))
          (setq #pp3 (polar #p3 (dtr  -45.) #offset))
          (setq #pp4 (polar #p4 (dtr -135.) #offset))

          ;B�̈�
          (setq #pb1 #pp1)
          (setq #pb4 #pp4)
          (setq #pb2 (list (+ (nth 0 #pb1) 500) (nth 1 #pp1)))
          (setq #pb3 (list (+ (nth 0 #pb4) 500) (nth 1 #pp4)))

          ;D�̈�
          (setq #pd2 #pp2)
          (setq #pd3 #pp3)
          (setq #pd1 (list (- (nth 0 #pd2) 500) (nth 1 #pp2)))
          (setq #pd4 (list (- (nth 0 #pd3) 500) (nth 1 #pp3)))

        )
        (progn ;R����

          (setq #p1 (list (- 3600 #WW)   0))
          (setq #p2 (list 3600   0))
          (setq #p3 (list 3600 #DD))
          (setq #p4 (list (- 3600 #WW) #DD))

          ;I�^�̈���͂ޗ̈�̓_�����߂�
    ; +p1                    +p2
    ;    @               @
    ;    |               |
    ;    @               @
    ; +p4                    +p3
          (setq #offset 200)
          (setq #pp1 (polar #p1 (dtr 135.) #offset))
          (setq #pp2 (polar #p2 (dtr  45.) #offset))
          (setq #pp3 (polar #p3 (dtr  -45.) #offset))
          (setq #pp4 (polar #p4 (dtr -135.) #offset))

          ;B�̈�
          (setq #pb1 #pp1)
          (setq #pb4 #pp4)
          (setq #pb2 (list (+ (nth 0 #pb1) 500) (nth 1 #pp1)))
          (setq #pb3 (list (+ (nth 0 #pb4) 500) (nth 1 #pp4)))

          ;D�̈�
          (setq #pd2 #pp2)
          (setq #pd3 #pp3)
          (setq #pd1 (list (- (nth 0 #pd2) 500) (nth 1 #pp2)))
          (setq #pd4 (list (- (nth 0 #pd3) 500) (nth 1 #pp3)))

        )
      );_if

      ; ���z�u����_�����߂�
      (setq #yPt  (polar #p3 (angle #p3 #p4) (/ (distance #p3 #p4) 2.0)))

      ; ��̍�}
      (setq #yEn  (SCFDrawYashi "ABD" #yPt "90" CG_YASHI_LAYER))
      (setvar "CECOLOR" "60")

      ; ��`�a�c�̗̈��}
      (setq #aEn (MakeLwPolyLine (list #pp1 #pp2 #pp3 #pp4) 1 0))
      (setq #bEn (MakeLwPolyLine (list #pb1 #pb2 #pb3 #pb4) 1 0))
      (setq #dEn (MakeLwPolyLine (list #pd1 #pd2 #pd3 #pd4) 1 0))

      ; �g���f�[�^�̕t��
      (CFSetXData #yEn "RECT"
        (list
          "0"
          "90"
          "ABD"
          (cdr (assoc 5 (entget #aEn)))
          (cdr (assoc 5 (entget #bEn)))
          (cdr (assoc 5 (entget #dEn)))
        )
      )

      ; �V�X�e���ϐ������ɖ߂�
      (setvar "CECOLOR" #sCECOLOR)
      (command "zoom" "e")
      (command "_REGEN")
    )
  )
  (princ)
);KCFAutoMakeDiningPlanYashi

;<HOM>*************************************************************************
; <�֐���>    : KCFAutoMakeDiningPlanYashi_EXTEND
; <�����T�v>  : ���[�v�����p�̖�������ō쐬����(I�^�z����[�g��)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2009/11/27 YM ADD
; <���l>      : �ABC���쐬����
;               �ȉ��̔z���O��
;               +-----+------------+
;               |     |            |
;               +-----+------------+
;*************************************************************************>MOH<
(defun KCFAutoMakeDiningPlanYashi_EXTEND (
  /
  #AEN #BEN #DD #DEN #LR #OFFSET #P1 #P2 #P3 #P4 #PB1 #PB2 #PB3 #PB4 
  #PD1 #PD2 #PD3 #PD4 #PP1 #PP2 #PP3 #PP4 #SCECOLOR #WW #YEN #YPT
  #QRY$ #SWW
  )

  (if (= nil (tblsearch "APPID" "RECT")) (regapp "RECT"))

  ; ���[�v�������ǂ����𔻒肷��
  (if (= CG_UnitCode "D");���[
    (progn
      ; �}�`�F�ԍ��̕ύX
      (setq #sCECOLOR (getvar "CECOLOR"))
      (setvar "CECOLOR" "50")

      ;���s���Ԍ�����W�JB,D�̈�����߂�
      (setq #DD 600);���s�� ���߂���

      ;�S�̊Ԍ������߂�
      (setq #WW 0.0)
      (foreach #i (list 1 2 3 4 5)
        (setq #sWW (nth (+ (* 100 #i) 55) CG_GLOBAL$));�Ԍ�
        (if (= nil #sWW)(setq #sWW ""))
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
            (list (list "�Ԍ��L��" #sWW 'STR))
          )
        )
        (if #qry$
          (progn
            (setq #WW (+ #WW (nth 2 (car #qry$))))
          )
        );_if

        (setq #sEP (nth (+ (* 100 #i) 71) CG_GLOBAL$));�������ٗL��
        (if (and (/= #sEP "N")(/= #sEP "X"))
          (setq #EP 20.0)
          ;else
          (setq #EP 0.0)
        );_if
        (setq #WW (+ #WW #EP))
        (setq #i (1+ #i))
      );foreach

      (setq #LR (nth 60 CG_GLOBAL$));���E�
      (if (= #LR "LL")
        (progn ;���

          (setq #p1 (list 0 0))
          (setq #p2 (list (+ 0 #WW) 0))
          (setq #p3 (list (+ 0 #WW) (- 0 #DD)))
          (setq #p4 (list 0 (- 0 #DD)))

          ;I�^�̈���͂ޗ̈�̓_�����߂�
    ; +p1                    +p2
    ;    @               @
    ;    |               |
    ;    @               @
    ; +p4                    +p3
          (setq #offset 50)
          (setq #pp1 (polar #p1 (dtr 135.) #offset))
          (setq #pp2 (polar #p2 (dtr  45.) #offset))
          (setq #pp3 (polar #p3 (dtr  -45.) #offset))
          (setq #pp4 (polar #p4 (dtr -135.) #offset))

          ;B�̈�
          (setq #pb1 #pp1)
          (setq #pb4 #pp4)
          ;���ʖ�̈�͑S�� 2009/12/10 YM MOD-S
;;;         (setq #pb2 (list (+ (nth 0 #pb1) 100) (nth 1 #pp1)))
;;;         (setq #pb3 (list (+ (nth 0 #pb4) 100) (nth 1 #pp4)))
          (setq #pb2 #pp2)
          (setq #pb3 #pp3)

          ;D�̈�
          (setq #pd2 #pp2)
          (setq #pd3 #pp3)
          ;���ʖ�̈�͑S�� 2009/12/10 YM MOD-S
;;;         (setq #pd1 (list (- (nth 0 #pd2) 100) (nth 1 #pp2)))
;;;         (setq #pd4 (list (- (nth 0 #pd3) 100) (nth 1 #pp3)))
          (setq #pd1 #pp1)
          (setq #pd4 #pp4)
        )
        (progn ;�E�

          (setq #p1 (list (- 0 #WW) 0))
          (setq #p2 (list 0 0))
          (setq #p3 (list 0 (- 0 #DD)))
          (setq #p4 (list (- 0 #WW) (- 0 #DD)))

          ;I�^�̈���͂ޗ̈�̓_�����߂�
    ; +p1                    +p2
    ;    @               @
    ;    |               |
    ;    @               @
    ; +p4                    +p3
          (setq #offset 50)
          (setq #pp1 (polar #p1 (dtr 135.) #offset))
          (setq #pp2 (polar #p2 (dtr  45.) #offset))
          (setq #pp3 (polar #p3 (dtr  -45.) #offset))
          (setq #pp4 (polar #p4 (dtr -135.) #offset))

          ;B�̈�
          (setq #pb1 #pp1)
          (setq #pb4 #pp4)
          ;���ʖ�̈�͑S�� 2009/12/10 YM MOD-S
;;;         (setq #pb2 (list (+ (nth 0 #pb1) 100) (nth 1 #pp1)))
;;;         (setq #pb3 (list (+ (nth 0 #pb4) 100) (nth 1 #pp4)))
          (setq #pb2 #pp2)
          (setq #pb3 #pp3)

          ;D�̈�
          (setq #pd2 #pp2)
          (setq #pd3 #pp3)
          ;���ʖ�̈�͑S�� 2009/12/10 YM MOD-S
;;;         (setq #pd1 (list (- (nth 0 #pd2) 100) (nth 1 #pp2)))
;;;         (setq #pd4 (list (- (nth 0 #pd3) 100) (nth 1 #pp3)))
          (setq #pd1 #pp1)
          (setq #pd4 #pp4)
        )
      );_if

      ; ���z�u����_�����߂�
      (setq #yPt  (polar #p3 (angle #p3 #p4) (/ (distance #p3 #p4) 2.0)))

      ;2011/06/14 YM ADD �B������Ȃ��悤�ɂ���
      (setq #yPt (list (car #yPt) (- (cadr #yPt) CG_Yashi_OffY) 10000))

      ; ��̍�}
      (setq #yEn  (SCFDrawYashi "ABD" #yPt "90" CG_YASHI_LAYER))
      (setvar "CECOLOR" "60")

      ; ��`�a�c�̗̈��}
      (setq #aEn (MakeLwPolyLine (list #pp1 #pp2 #pp3 #pp4) 1 0))
      (setq #bEn (MakeLwPolyLine (list #pb1 #pb2 #pb3 #pb4) 1 0))
      (setq #dEn (MakeLwPolyLine (list #pd1 #pd2 #pd3 #pd4) 1 0))

      ; �g���f�[�^�̕t��
      (CFSetXData #yEn "RECT"
        (list
          "0"
          "90"
          "ABD"
          (cdr (assoc 5 (entget #aEn)))
          (cdr (assoc 5 (entget #bEn)))
          (cdr (assoc 5 (entget #dEn)))
        )
      )

      ; �V�X�e���ϐ������ɖ߂�
      (setvar "CECOLOR" #sCECOLOR)
      (command "zoom" "e")
      (command "_REGEN")
    )
  );_if
  (princ)
);KCFAutoMakeDiningPlanYashi_EXTEND

;<HOM>*************************************************************************
; <�֐���>    : KCFAutoMakeIgataPlanYashi��
; <�����T�v>  : I�^�v�����p�̖�������ō쐬����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 08/12/22 YM
; <���l>      : �ABC���쐬����
;*************************************************************************>MOH<
(defun KCFAutoMakeIgataPlanYashi (
  /
  #AEN #BEN #DEN #OFFSET #P1 #P2 #P3 #P4 #PG1 #PG2 #PG3 #PG4 #PP1 #PP2 #PP3 #PP4
  #PS1 #PS2 #PS3 #PS4 #PT$ #RET$ #SCECOLOR #SS #X_GAS #X_SNK #YEN #YPT
  )

  (if (= nil (tblsearch "APPID" "RECT")) (regapp "RECT"))

;;;2010/11/18DEL  ; I�^�v�������ǂ����𔻒肷��
;;;2010/11/18DEL  (if (= "I00" (nth  5 CG_GLOBAL$))
;;;2010/11/18DEL    (progn

      ;�ݸ,��۔z�u�ʒu���W
      (setq #ret$ (Get_snk_gas_XY))
      ;�ݸ�z�u�ʒu���W
      (setq #X_snk (car  #ret$))
;;;     ;2009/01/10 YM ADD-S�@����ي�_���班�����炷
;;;     (if (= "R" (nth 11 CG_GLOBAL$))
;;;       (setq #X_snk (+ #X_snk 100))
;;;       ;else
;;;       (setq #X_snk (- #X_snk 100))
;;;     );_if

      ;��۔z�u�ʒu���W
      (setq #X_gas (cadr #ret$))
      ;2009/01/10 YM ADD-S�@����ي�_���班�����炷 ���ʐ}��̰�ނƒ݌˗����łĂ��܂��̂�����邽��
      (setq #X_gas (+ #X_gas 100))

      (if (and #X_snk #X_gas)
        (progn

          ; �}�`�F�ԍ��̕ύX
          (setq #sCECOLOR (getvar "CECOLOR"))
          (setvar "CECOLOR" "50")

          (if (= "L" (nth 11 CG_GLOBAL$))
            (progn
              (setq #pt_B #X_snk)
              (setq #pt_D #X_gas)
            )
            (progn
              (setq #pt_B #X_gas)
              (setq #pt_D #X_snk)
            )
          );_if

          (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
          (setq #pt$ (car (car (GetWorkTopArea (ssname #ss 0)))))
          (setq #offset 400)

          ; �L�b�`��I�^�̈���͂ޗ̈�̓_�����߂�
    ; +p1                    +p2
    ;    @               @
    ;    |               |
    ;    @               @
    ; +p4                    +p3
          (setq #p1 (polar (nth 0  #pt$) (dtr 135.) #offset))
          (setq #p2 (polar (nth 1  #pt$) (dtr  45.) #offset))
          (setq #p3 (polar (nth 2  #pt$) (dtr  -45.) #offset))
          (setq #p4 (polar (nth 3  #pt$) (dtr -135.) #offset))

          (setq #pp1 (polar #p1 (dtr 135.) #offset))
          (setq #pp2 (polar #p2 (dtr  45.) #offset))
          (setq #pp3 (polar #p3 (dtr  -45.) #offset))
          (setq #pp4 (polar #p4 (dtr -135.) #offset))

          ;D�̈�
          (setq #pd1 (list #pt_D (nth 1 #pp1)))
          (setq #pd2 #pp2)
          (setq #pd3 #pp3)
          (setq #pd4 (list #pt_D (nth 1 #pp4)))

          ;B�̈�
          (setq #pb1 #pp1)
          (setq #pb2 (list #pt_B (nth 1 #pp1)))
          (setq #pb3 (list #pt_B (nth 1 #pp4)))
          (setq #pb4 #pp4)

          ; ���z�u����_�����߂�
          (setq #yPt  (polar #p3 (angle #p3 #p4) (/ (distance #p3 #p4) 2.0)))

          ; ��̍�}
          (setq #yEn  (SCFDrawYashi "ABD" #yPt "90" CG_YASHI_LAYER))
          (setvar "CECOLOR" "60")

          ;�A
          (setq #offset2 200)
          (setq #pA1 (polar #p1 (dtr 135.) #offset2))
          (setq #pA2 (polar #p2 (dtr  45.) #offset2))
          (setq #pA3 (polar #p3 (dtr  -45.) #offset2))
          (setq #pA4 (polar #p4 (dtr -135.) #offset2))

          ; ��`�a�c�̗̈��}
          (setq #aEn (MakeLwPolyLine (list #pA1 #pA2 #pA3 #pA4) 1 0))
          (setq #bEn (MakeLwPolyLine (list #pb1 #pb2 #pb3 #pb4) 1 0))
          (setq #dEn (MakeLwPolyLine (list #pd1 #pd2 #pd3 #pd4) 1 0))

          ; �g���f�[�^�̕t��
          (CFSetXData #yEn "RECT"
            (list
              "0"
              "90"
              "ABD"
              (cdr (assoc 5 (entget #aEn)))
              (cdr (assoc 5 (entget #bEn)))
              (cdr (assoc 5 (entget #dEn)))
            )
          )
          (command "zoom" "e")
          (command "_REGEN")
          ; �V�X�e���ϐ������ɖ߂�
          (setvar "CECOLOR" #sCECOLOR)
        )
      );_if

;;;2010/11/18DEL    )
;;;2010/11/18DEL  );_if
  (princ)
);KCFAutoMakeIgataPlanYashi��

;<HOM>*************************************************************************
; <�֐���>    : KCFAutoMakeTaimenPlanYashi
; <�����T�v>  : �Ζʃv�����p�̖�������ō쐬����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 04/04/13 SK
; <���l>      : ��`�a�c�y�ђǉ���d���쐬����
;*************************************************************************>MOH<
(defun KCFAutoMakeTaimenPlanYashi (
  /
  #ss
  #pt$
  #offset
  #p1 #p2 #p3 #p4            
  #yPt #yePt                 ;���_
  #yEn #yeEn                 ;��}�`
  #aEn #bEn #cEn #dEn #eEn   ;��̈�}�`
  #sfpType                   ;�Ζʃt���b�g�v�����̃^�C�v
  #sCECOLOR                  ;���ݐF
  )

  (if (= nil (tblsearch "APPID" "RECT")) (regapp "RECT"))

;;;2010/11/18DEL  ; �Ζʃv�������ǂ����𔻒肷��
;;;2010/11/18DEL  (setq #sfpType (SCFIsTaimenFlatPlan))
;;;2010/11/18DEL  (if #sfpType
;;;2010/11/18DEL    (progn


      ; �}�`�F�ԍ��̕ύX
      (setq #sCECOLOR (getvar "CECOLOR"))
      (setvar "CECOLOR" "50")

      ; �Ζʃv�����͖������`�a�c�d�Ƃ���
      (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
      (setq #pt$ (car (car (GetWorkTopArea (ssname #ss 0)))))

      ;2009/04/21 YM ADD if���ǉ�
      (if (wcmatch (nth  5 CG_GLOBAL$) "G*" )
        (setq #offset 820);�ް�����
        ;else
        (setq #offset 400);�]��
      );_if

      ; �L�b�`���̈���͂ޗ̈�̓_�����߂�
      (setq #p1 (polar (car    #pt$) (dtr 135.) #offset))
      (setq #p2 (polar (cadr   #pt$) (dtr  45.) #offset))

      ;2008/08/13 YM DEL
;;;      (if (= #sfpType "SF")
;;;        (progn
;;;          (setq #p1 (list (car #p1) (+ (cadr #p1) 600.)))
;;;          (setq #p2 (list (car #p2) (+ (cadr #p2) 600.)))
;;;        )
;;;      );_if

      (setq #p3 (polar (caddr  #pt$) (dtr  -45.) #offset))
      (setq #p4 (polar (nth 3  #pt$) (dtr -135.) #offset))

      ; ���z�u����_�����߂�
      (setq #yPt  (polar #p3 (angle #p3 #p4) (/ (distance #p3 #p4) 2.0)))
      (setq #yePt (polar #p1 (angle #p1 #p2) (/ (distance #p1 #p2) 2.0)))

      ; ��̍�}
      (setq #yEn  (SCFDrawYashi "ABD" #yPt "90" CG_YASHI_LAYER))
      (setq #yeEn (SCFDrawYashi "E" #yePt "0" CG_YASHI_LAYER))

      (setvar "CECOLOR" "60")

      ; ��`�a�c�̗̈��}
      (setq #aEn (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))
      (setq #bEn (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))
      (setq #dEn (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))

      ; ��d�̗̈��}
      (setq #eEn (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))

      ; �g���f�[�^�̕t��
      (CFSetXData #yEn "RECT"
        (list
          "0"
          "90"
          "ABD"
          (cdr (assoc 5 (entget #aEn)))
          (cdr (assoc 5 (entget #bEn)))
          (cdr (assoc 5 (entget #dEn)))
        )
      )
      ; ��d�̗̈��}
      (CFSetXData #yeEn "RECT"
        (list
          "0"
          "0"
          "E"
          (cdr (assoc 5 (entget #eEn)))
        )
      )
      ; �V�X�e���ϐ������ɖ߂�
      (setvar "CECOLOR" #sCECOLOR)
      (command "zoom" "e")
      (command "_REGEN")


;;;2010/11/18DEL    )
;;;2010/11/18DEL  );_if

  (princ)
);KCFAutoMakeTaimenPlanYashi


;<HOM>*************************************************************************
; <�֐���>    : Get_snk_gas_XY
; <�����T�v>  : �ݸ,��ۂ̔z�u�ʒu���W�����߂�
; <�߂�l>    : �ݸ,��ۂ̔z�u�ʒu���W
; <�쐬>      : 08/12/23 YM
; <���l>      : ��̈�쐬�Ɏg�p����
;*************************************************************************>MOH<
(defun Get_snk_gas_XY (
  /
  #GASX #I #PT #RET$ #SEIKAKU #SNKX #SS_LSYM #SYM #XD-LSYM$
  )
  (setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM"))))) ; G_LSYM �}�`�I���
  (if (and #ss_LSYM (< 0 (sslength #ss_LSYM)))
    (progn
      (setq #i 0)
      (setq #snkX nil)
      (setq #gasX nil)
      (repeat (sslength #ss_LSYM)
        (setq #sym (ssname #ss_LSYM #i))
        (setq #pt (cdr (assoc 10 (entget #sym))))
        (setq #xd-lsym$ (CFGetXData #sym "G_LSYM"))
        (setq #seikaku  (nth 9 #xd-lsym$)) ;���iCODE
;;;       ;2009/01/10 YM MOD-S
;;;       (if (= #seikaku CG_SKK_INT_SNK);�ݸ
        (if (= #seikaku CG_SKK_INT_SCA);�ݸ����
          (progn
            (setq #snkX (car #pt));����ي�_X���W

            (if (= "R" (nth 11 CG_GLOBAL$))
              (progn ;�E���莞�ݸ���޼���ي�_+50mm�E��
                (setq #snkX (+ #snkX 50))
              )
              (progn ;�����莞�ݸ���޼���ي�_+���@W�l�E��
                ;���@W�l
                (setq #WW (nth 3 (CFGetXData #sym "G_SYM"))) ; ���@W
                (setq #snkX (+ #snkX #WW))
                (setq #snkX (- #snkX 50))
              )
            );_if

          )
        );_if

        (if (= #seikaku CG_SKK_INT_GAS);210�޽���
          (setq #gasX (car #pt))
        );_if
        (setq #i (1+ #i))
      );repeat
    )
  );_if
  (setq #ret$ (list #snkX #gasX))
  #ret$
);Get_snk_gas_XY

;<HOM>*************************************************************************
; <�֐���>    : SCFWFModGLSymPosAngle
; <�����T�v>  : G_LSYM�̔z�u��_�����݂̊�_�̈ʒu�ɏC������B
; <�߂�l>    : �Ȃ�
; <���l>      : nil
;*************************************************************************>MOH<
(defun SCFWFModGLSymPosAngle (
  /
  #ss
  #en
  #xd$
  #bpt
  #angle
  )
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (foreach #en (Ss2En$ #ss)
    (setq #bpt (cdrassoc 10 (entget #en)))
    (setq #xd$ (CFGetXData #en "G_LSYM"))
    (setq #angle (nth 2 #xd$))
    (while (or (equal #angle (* PI 2) 0.001) (> #angle (* PI 2)))
      (setq #angle (- #angle (* PI 2)))
    )
    (while (and (not (equal #angle 0.0 0.001)) (< #angle 0.0))
      (setq #angle (+ #angle (* PI 2)))
    )
    (CFSetXData #en "G_LSYM"
      (CFModList #xd$
        (list (list 1 #bpt) (list 2 #angle))
      )
    )
  )
)
;SCFWFModGLSymPos








;<HOM>*************************************************************************
; <�֐���>    : SCFMakeMaterialArx
; <�����T�v>  : �W�J���}�쐬���C������(ARX�Ή���)
; <�߂�l>    : �Ȃ�
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCFMakeMaterialArx (
  /
  #clayer #cecolor #osmode
  #kind$$ #kind$ #ang$ #DclRet$
  #Skind$ #ssD #save
  #msg      ; 03/06/10 YM ADD
  #sView    ; �}�ʎ��
  #pCrtFlg  ; ���ʐ}�쐬�t���O
  #eCrtFlg  ; �W�J�}�쐬�t���O
  #xSp
  #ZoomArea #PtS #PtE #cArea  ;;  2005/12/07 G.YK ADD
  )
  ;;  2005/12/07 G.YK ADD-S
  (defun ##NormYashi (
      &cArea &tArea
      /
      #cArea #cPtS #cPtE #cU #cD #cL #cR
      #tArea #tPtS #tPtE #tU #tD #tL #tR
      )
      (setq #cPtS (car &cArea))
      (setq #cPtE (cadr &cArea))
      (setq #cL (min (car #cPtS)(car #cPtE)))
      (setq #cR (max (car #cPtS)(car #cPtE)))
      (setq #cD (min (cadr #cPtS)(cadr #cPtE)))
      (setq #cU (max (cadr #cPtS)(cadr #cPtE)))

      (setq #tPtS (car &tArea))
      (setq #tPtE (cadr &tArea))
      (setq #tL (min (car #tPtS)(car #tPtE)))
      (setq #tR (max (car #tPtS)(car #tPtE)))
      (setq #tD (min (cadr #tPtS)(cadr #tPtE)))
      (setq #tU (max (cadr #tPtS)(cadr #tPtE)))

      (if (< #tU #cU)(progn
        nil
      )(progn
        (setq #tU (+ #cU 150))
        (setq #cU #tU)
      ))
      (if (< #tL #cL)(progn
        (setq #tL (- #cL 150))
        (setq #cL #tL)
      )(progn
        nil
      ))
      (if (< #tR #cR)(progn
        nil
      )(progn
        (setq #tR (+ #cR 150))
        (setq #cR #tR)
      ))
      (if (< #tD #cD)(progn
        (setq #tD (- #cD 150))
        (setq #cD #tD)
      )(progn
        nil
      ))

      (setq #cPtS (list #cL #cU))
      (setq #cPtE (list #cR #cD))
      (setq #cArea (list #cPtS #cPtE))

      (setq #tPtS (list #tL #tU))
      (setq #tPtE (list #tR #tD))
      (setq #tArea (list #tPtS #tPtE))

      (list #cArea #tArea)
  )
  ;;  2005/12/07 G.YK ADD-E

  (WebOutLog "�W�J���}�쐬���C������(SCFMakeMaterialArx)")
; T.Ari Add Start lisp�ō�}������R�s�[
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
    (progn
      ; ����Ӱ�ނ̂Ƃ�"MODEL.DWG"��j���I������"MODEL.DWG"��OPEN�ł��Ȃ����ߖ��O��ς��ĕۑ����Ă���
      ; �j���I�����Ȃ��ƃR�����̊G����������Ă��܂�
;;;     (command ".qsave") ; 101/10/01 YM MOD
;;;     (if (findfile (strcat CG_SYSPATH "auto.dwg")) ; 01/10/02 YM ADD-S
      ;06/06/16 AO MOD �ۑ��`����2004�ɕύX
      ;(command "_saveas" "2000" (strcat CG_SYSPATH "auto.dwg"))
;-- 2011/10/06 A.Satoh Mod - S
;;;;;      (command "_saveas" CG_DWG_VERSION (strcat CG_SYSPATH "auto.dwg"))
      (command "_saveas" CG_DWG_VER_MODEL (strcat CG_SYSPATH "auto.dwg"))
;-- 2011/10/06 A.Satoh Mod - E
    )
    (CFAutoSave)
  );_if
  ; 01/09/07 YM MOD-E ����Ӱ�ނł͕ۑ����Ȃ�
; T.Ari Add End

;-- 2011/09/27 A.Satoh Add - S
  ; �{�H�}�o���������s��
  (if (SCF_SekouLayer)
    (progn
;-- 2011/09/27 A.Satoh Add - E

  ; 06/09/20 T.Ari ADD ��_���W��G_LSYM�ɐݒ肵�Ȃ���
  (SCFWFModGLSymPosAngle)

  (CFNoSnapReset);00/08/25 SN ADD


;| T.Ari Del Start �^�J����p����
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3))
    ;������}���[�h�ł́A��֘A�̑O�������s����U�ۑ�����
    (progn
      ;��̓��͏����擾����
      (setq CG_SKViewList (##CFgetiniCountList "SK_VIEW" "COUNT" "VIEW" 2))
      ;�p�[�X�r���[�̍쐬
      (KCFMakeModelPersView)

    ;;  2005/12/07 G.YK ADD-S
      (SetLayer_sub "N_YASHI*"  "OF"  "F")
      (SetLayer_sub "G_RM*"  "OF"  "F")
      (command "zoom" "e")
      (setq #ZoomArea (list (getvar "EXTMIN")(getvar "EXTMAX")))
      (princ "\n aaa1")
      (princ "\n�Y�[���̈�: ")(princ #ZoomArea)
      (SetLayer_sub "N_YASHI*"  "ON"  "T")
      (SetLayer_sub "G_RM*"  "ON"  "T")

      (setq #PtS (car #ZoomArea))
      (setq #PtE (cadr #ZoomArea))
      (setq #cArea (list
          (list (car #PtS)(cadr #PtE))
          (list (car #PtE)(cadr #PtS))
      ))
    ;;  2005/12/07 G.YK ADD-E

      ;�p�[�X��������쐬����i�ŏI�}�ʂɂ͕ۑ����Ȃ����߁A��L�Ő}�ʂ�ۑ����Ă���j
    ;;(KCFAutoMakeSKViewYashiPers)  ;;  2005/12/07 G.YK DEL
      (setq #cArea (KCFAutoMakeSKViewYashiPers ##NormYashi #cArea)) ;;  2005/12/07 G.YK ADD

      ;�p�[�X�ȊO�̖�������쐬����
    ;;(KCFAutoMakeSKViewYashi)  ;;  2005/12/07 G.YK DEL
      (setq #cArea (KCFAutoMakeSKViewYashi ##NormYashi #cArea)) ;;  2005/12/07 G.YK ADD

      ;��U�}�ʂ�ۑ�����
      (CFQSave)

      ; ����Ӱ�ނ̂Ƃ�"MODEL.DWG"��j���I������"MODEL.DWG"��OPEN�ł��Ȃ����ߖ��O��ς��ĕۑ����Ă���
      ; �j���I�����Ȃ��ƃR�����̊G����������Ă��܂�
      (command "_saveas" CG_DWG_VERSION (strcat CG_SYSPATH "auto.dwg"));04/08/12 YM MOD 2000==>2004
    )
  ;else
    ;�J�X�^��TOP�ҏW���[�h�ł͈�U�ۑ�����
    (progn
      (CFAutoSave)
    )
  );_if

  ;;; 04/04/14 SK DELL-S ���Ϗ����͌�ōs��
  ;;;�������[�h�̎��͐�Ɍ��ς�����X�V���Ă���
  ;;;(if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
  ;;;  (progn
  ;;;    (SCFMakeBlockTable)    ;;  2005/04/12 G.YK ADD
  ;;;    (PKC_MitumoriPreSelect)  ;;  2005/04/12 G.YK ADD
  ;;;  )
  ;;;)
  ;;; 04/04/14 SK DELL-E ���Ϗ����͌�ōs��

  ;--------------------------------------------------------------------------
  ;�}�ʐ}�쐬�p�ɐ}�ʂ�␳����
  ; (���d�v)�����ŕϊ����ꂽ�f�[�^�́A�W�J�}�I����Ɍ��̐}�ʂɂ͉e�����Ȃ�
  ;--------------------------------------------------------------------------
  (SCFConvertMaterialDwg)
|; ; T.Ari Del End
  (setvar "CLAYER"    "0")
  (setvar "CECOLOR"   "BYLAYER")
  (setvar "OSMODE"    0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "SNAPMODE"  0)
  (command "_.SHADEMODE" "2D")  ;���C�A�t���[���\���i���x����j

  ; ��̈攻��ύX
  (setq CG_UTypeWT nil)
  (setq CG_TABLE nil)

  ; ��}�`���擾����
  (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))

  ; EF�������̂�ABCD����Ȃ��ꍇ�͍�}���Ȃ�
  (if (and (SCFIsYashiType #xSp "*[EF]*") (not (SCFIsYashiType #xSp "*[ABCD]*")))
    (progn
      (CFAlertErr (strcat "ABCD�������܂���.\n"
                          "��ݒ��ABCD����쐬���ĉ�����"))
    )
    (progn

      ;�W�J�}�쐬�̍ۂɂ͖��z�u���ނ����[�N�Ɉڂ�
      ; -> ���Ϗ��쐬�̍ۂɌ��ɖ߂�
      ; T.Ari �R�����g��
;     (SCFCnvWNSymbolApp CG_WG_WORK_CONVERT)

      ; �_�~�[�̈�ݒ�
      (WebOutLog "�_�~�[�̈�ݒ�(SetDummyArea)")
      (SetDummyArea)   ;�_�~�[�̈�ݒ�

      ; �f�[�^�l��
      (setq #kind$$ (GetMaterialData))
      (if (/= nil #kind$$)
        (progn
          (setq #kind$  (car  #kind$$))
          (setq #ang$   (cadr #kind$$))

          (if (/= CG_OUTCMDNAME "SCFLayPrs")
            (progn

;2011/07/22 YM MOD-S �޲�۸ޕ\�����Ȃ�
;;;              ; ����Ӱ�ނł��޲�۸ޕ\�����Ȃ�
;;;              (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;;                (setq #DclRet$ CG_AUTOMODE_TENKAI)
;;;                (setq #DclRet$ (SCFGetBlockKindDlg (mapcar 'car #kind$)))
;;;              );_if
              (setq #DclRet$ CG_AUTOMODE_TENKAI)
;2011/07/22 YM MOD-S �޲�۸ޕ\�����Ȃ�

            )
            (progn
              ; �p�[�X���}�����쐬���C�A�E�g�̎�
              ; ���ʐ}���I�����ꂽ��ԂƂ���
              (setq #DclRet$ (list (list 1 0 0) (list "0")))
            )
          )

          ; �W�J�}�쐬�`�F�b�N
          ; �}�ʍ쐬�p�f�[�^��
          ;   ((���ʐ}�p�f�[�^) (�W�J�}�p�f�[�^�̃��X�g) �d�l�}�쐬�L��)�̃��X�g�ɐ�������
          (setq #Kind$ (SCFCheckExpand #kind$ #DclRet$))
          (if (/= nil #Kind$)
            (progn
              ;; �m�F�_�C�A���O�\��
              (KPfDelBlockDwg)

              (princ "\n�W�J�}�쐬���c\n")

              ;// �������[�N�g�b�v���
              (PKOutputWTCT)

              ; �W�J���}�p��w���t���[�Yor���b�N����Ă������������
              ; �W�J���}�p��w���쐬����Ă���(�{�����肦�Ȃ�?)�ꍇ�̑Ή�
              (SCF_LayDispOn
                (list "0_door" "0_plane" "0_dim" "0_plin_1" "0_plin_2" "0_pers"
                      "0_side_A" "0_side_B" "0_side_C" "0_side_D" "0_side_E" "0_side_F"
                      "0_side_G" "0_side_H" "0_side_I" "0_side_J" "0_kutai"
                )
              )

              ;----------------------------------------------------------
              ; ARX �W�J�}�쐬
              ;----------------------------------------------------------

              ;�p�[�X�S�̕����쐬����
;-- 2012/01/27 A.Satoh Mod (���ɖ߂��j- S
;-- 2011/07/11 A.Satoh Mod - S
;;;;              (command "SCFMakeExpandAll" 1 0 0)
              (command "SCFMakeExpandAll" 1 nil nil)
;-- 2011/07/11 A.Satoh Mod - E
;-- 2012/01/27 A.Satoh Mod (���ɖ߂��j- E
;2009/04/20 YM
;;;              (if (= CG_ARX_DEPLOY_RET 0)
;;;                (progn
;;;                  (CFAlertMsg "�W�J�}�쐬�Ɏ��s���܂���")
;;;                  (setq #Kind$ nil)
;;;                )
;;;              )

              ; �_�~�[�̈�č쐬
              ; �̈�ɂ͂���Ȃ��V���{�������݂��邽�߁A���̃V���{�����_�~�[�̈�ɂ���Ă��܂�
              (setq #ssD (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_SKDM")))))

              (SetDummyAgain #ssD nil)

              ; ���ʐ}�쐬�L��
              (if (/= nil (nth 0 #kind$))
                (setq #pCrtFlg 1)     ; ���ʐ}�쐬�t���O
              )
              ; �W�J�}�쐬�L��
              (if (/= nil (nth 1 #kind$))
                (progn
                  ; �W�J�}���쐬����Ƃ��́A�����͂��Ă���
                  ; �O���[�o���i�[���ꂽ�����́AARX�̓W�J�}�쐬�����ֈ����p�����
                  ; CG_DOORLST
                  (AlignDoorBySym$ (mapcar 'cadr (nth 1 #kind$)))

                  ;// �W�J�}�쐬�t���O
                  (setq #eCrtFlg 1)
                )
              )
              ;-- �d�l�}���쐬���邩�H
              (if (/= nil (nth 2 #kind$))
                (progn
                  ;���[�J�����[�h�̎��̓_�C�A���O�`�F�b�N�������Ɍ��Ϗ��������s����
                  ;;;(if (= CG_AUTOMODE 0)
                  ;;;  (progn
                      ;���Ϗ��쐬�̍ۂɂ͖��z�u���ނ̏������ɖ߂�
                      ; T.Ari �R�����g��
;                     (SCFCnvWNSymbolApp CG_WG_REAL_CONVERT)

                      (princ "\n�d�l�}�쐬���c\n")
                      (WebOutLog "�d�l�}�쐬���c")
                      (SCFMakeBlockTable)         ; �d�l�� �Â��^�C�v��Table.cfg�o�͂��Ȃ�  ;;  2005/04/12 G.YK DEL
                      ; T.Ari �R�����g��
;                     (PKC_MitumoriPreSelect) ;;  2005/02/21 G.YK ADD ;;  2005/04/12 G.YK DEL
                      (setq CG_TABLE T)           ; Table.cfg�쐬�׸� 01/02/07 YM
                  ;;; )
                  ;;;)
                )
              )
              ; DEBUG �W�J�} ARX�Ή�
              ;(if (CFYesNoDialog "\n�������Ƃ߂܂���")
              ;  (progn
              ;    (setq *error* nil)
              ;    (*error*)
              ;  )
              ;-- �W�J�}�쐬�����@ARX�Ή�������
              (if (or #eCrtFlg #pCrtFlg)
                (progn
                  (princ "\n�W�J�}�쐬���c\n")

                  (WebOutLog "�W�J�}�쐬���c")

                  ;; 04/04/14 SK ADD-S
                  ;�W�J�}�`�q�w�������O�Ƀ��[�N�n�̉�w�̐}�`�������Ă���
                  ; T.Ari �R�����g��
;                 (SCFEraseWorkEnt)
                  ;; 04/04/14 SK ADD-E

                  ; T.Ari �R�����g��
;                 (SCFChgCutWtBasePolyline)

                  ;----------------------------------------------------------
                  ; ARX �W�J�}�쐬
                  ;----------------------------------------------------------
;-- 2012/01/27 A.Satoh Mod (���ɖ߂�) - S
									;2012/01/17 YM MOD -S TS�ɂ��킹��
                  (command "SCFMakeExpandAll" 0 #pCrtFlg #eCrtFlg)
;;;;;									(command "SCFMakeExpandAll" #pCrtFlg #pCrtFlg #eCrtFlg)
									;2012/01/17 YM MOD -E TS�ɂ��킹��
;-- 2012/01/27 A.Satoh Mod (���ɖ߂�) - E


									;2012/01/17 YM MOD -S TS�����߰���Ēǉ�
                  ;�p�[�X�S�̕����쐬����
                  (if (ssget "X" '((-3 ("RECTPERS"))))
                    (progn
                      (command "_.ERASE" (ssget "X" '((-3 ("RECTPERS")))) "")
                      (command "SCFMakeExpandAll" 1 nil nil)
                    )
                  )
                  (if (= CG_ARX_DEPLOY_RET 0)
                    (progn
                      (CFAlertMsg "�W�J�}�쐬�Ɏ��s���܂���")
                      (setq #Kind$ nil)
                    )
                  )
									;2012/01/17 YM MOD -E TS�����߰���Ēǉ�

                )
              );_if

              (princ "\n�W�J�}�쐬���c�I��")
              (WebOutLog "�W�J�}�쐬���c�I��")
              (setq #save T)
            )
          );_if (/= nil #Kind$)
        )
      )
    )
  )

  ; (�������p�̃t���O�N���A)
  (setq CG_OUTCMDNAME nil)
;-- 2011/09/27 A.Satoh Add - S
    )
  )
;-- 2011/09/27 A.Satoh Add - E

  ;�߂�l
  #Kind$
)
; SCFMakeMaterialArx

;<HOM>*************************************************************************
; <�֐���>    : SCFModYoutoLayer
; <�����T�v>  : �p�r�ϊ�
; <�߂�l>    : �Ȃ�
; <���l>      :
;*************************************************************************>MOH<
(defun SCFModYoutoLayer (
  /
  #yid #toks #tokn
  #tokuseichi$$
  #tdata #tid #tval$ #tval
  #rec$$ #i #f #tid #modlist$
  #zlay #zlay$ #zlay1$ #zlay2$
  #eLay #eg$ #ss #ylay #vlay #zlaynew
  )
  (setq #yid 1)
  (setq #toks 2 #tokn 6)
  
  (setq #tokuseichi$$ (SCFGetTokuseichi))
  (if #tokuseichi$$
    (progn
      (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION "SELECT * FROM ST�{�H�\��"))
      (foreach #rec$ #rec$$
        (setq #i 0 #f T)
        (while (and #f (< #i #tokn) (setq #tid (nth (+ (* #i 2) #toks) #rec$)))
          (setq #tdata$ (assoc #tid (nth 0 #tokuseichi$$)))
          (if (not #tdata$)
            (setq #tdata$ (assoc #tid (nth 1 #tokuseichi$$)))
          )
          (setq #tval$ (strparse (nth (+ (* #i 2) #toks 1) #rec$) ","))
          (if (or (not #tdata$) (not (member (nth 1 #tdata$) #tval$)))
            (setq #f nil)
          )
          (setq #i (1+ #i))
        )
        (if #f (setq #modlist$ (cons (nth #yid #rec$) #modlist$)))
      )
      (setq #zlay$ (SCFGetZLayer))
      (foreach #zlay #zlay$
        (setq #ylay (itoa (atoi (substr #zlay 9 2))))
        (cond
          ((= #ylay "0")
            nil
          )
          ((member #ylay #modlist$)
            (setq #zlay1$ (cons #zlay #zlay1$))
          )
          (T
            (setq #zlay2$ (cons #zlay #zlay2$))
          )
        )
      )
      (foreach #zlay #zlay2$
        (setq #ylay (itoa (atoi (substr #zlay 9 2))))
        (setq #rec$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "SELECT ��w�ԍ� FROM �p�r���� WHERE �p�r�ԍ� = " #ylay )))
        (if (and #rec$$ (or (not (car (car #rec$$))) (equal (car (car #rec$$)) 0.0 0.01)))
          (progn
            (setq #ss (ssget "X" (list (cons 8 #zlay))))
            (if (and #ss (< 0 (sslength #ss)))
              (command "_.erase" #ss "")
            )
            (setq #eLay (tblobjname "LAYER" #zlay))
            (entdel #eLay)
          )
        )
      )
      (foreach #zlay #zlay1$
        (setq #ylay (itoa (atoi (substr #zlay 9 2))))
        (setq #vlay (itoa (atoi (substr #zlay 3 2))))
        (setq #rec$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "SELECT �ϊ���p�r FROM �p�r�ϊ� WHERE �p�r�ԍ� = " #ylay " AND ���_�敪 = " #vlay "")))
        (if #rec$$
          (progn
      (setq #ylay (itoa (fix (car (car #rec$$)))))
            (setq #zlaynew (strcat (substr #zlay 1 8) (if (= 1 (strlen #ylay)) "0" "") #ylay (substr #zlay 11)))
            (MakeLayer #zlaynew 7 "CONTINUOUS")
            (setq #ss (ssget "X" (list (cons 8 #zlay))))
            (if (and #ss (< 0 (sslength #ss)))
              (progn
                (setq #i 0)
                (repeat (sslength #ss)
                  (setq #eg$ (entget (ssname #ss #i)))
                  (entmod (subst (cons 8 #zlaynew) (assoc 8 #eg$) #eg$))
                  (setq #i (1+ #i))
                )
              )
            )
            (setq #eLay (tblobjname "LAYER" #zlay))
            (entdel #eLay)
          )
        )
      )
    )
  )
  T
)
;SCFChgCutWtBasePolyline


;<HOM>*************************************************************************
; <�֐���>    : SCFWFBowlCabSetHeight
; <�����T�v>  : ���ʃ{�E���L���r�̍�����ύX����i�V�T�O�Œ�j
; <�߂�l>    : �Ȃ�
; <���l>      : nil
;*************************************************************************>MOH<
(defun SCFWFBowlCabSetHeight (
  /
  #qry$
  #qry2$
  #skk$
  #ss
  #en
  #xd$
  #tkr$
  #wth
  )
  ; ���j�b�g�L�����擾����
  (setq #qry$
    (CFGetDBSQLRec CG_CDBSESSION "SERIES"
      (list
        (list "SERIES����" CG_SeriesDB   'STR)
        (list "SERIES�L��" CG_SeriesCode 'STR)
      )
    )
  )

;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #qry$)
;;;		;�ذ�ޕ�DB,����DB�Đڑ�
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E


  ;���ʂ̏ꍇ
  (if (or (= "S" (nth 3 (car #qry$))) (= "M" (substr (nth 0 (car #qry$)) 1 1)))
    (progn
      (setq #tkr$ (CFGetXRecord "TKR"))
      (if #tkr$
        (setq #wth (nth 0 #tkr$))
        (setq #wth CG_WFBowlCabHeight)
      )
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (foreach #en (Ss2En$ #ss)
        (setq #skk$ (CFGetSymSKKCode #en nil))
        (if (and
              (= (car #skk$) CG_SKK_ONE_CAB)
              (= (cadr #skk$) CG_SKK_TWO_BAS)
              (or
                (= (caddr #skk$) CG_SKK_THR_NRM)
                (= (caddr #skk$) CG_SKK_THR_SNK)
                (= (caddr #skk$) CG_SKK_THR_GAS)
                (= (caddr #skk$) CG_SKK_THR_CNR)
              )
            )
          (progn
            (setq #xd$ (CFGetXData #en "G_LSYM"))
            (CFSetXData #en "G_LSYM"
              (CFModList #xd$
                (if (= "S" (nth 3 (car #qry$)))
                  (progn
                    (if (= CG_CDBSESSION nil) (setq CG_DBSESSION (DBConnect CG_DBNAME "" "")))
                    (setq #qry2$
                      (CFGetDBSQLRec CG_CDBSESSION "�g������" 
                          (list (list "�@�\��" "wfbch" 'STR)
                                (list "���ڂP" (nth 5 #xd$) 'STR)
                          )
                      )
                    )
                    (if #qry2$
                      (list (list 13 (atoi (nth 3 (car #qry2$)))))
                      (list (list 13 (- #wth (nth 2 (nth 1 #xd$)))))
                    )
                  )
                  (list (list 13 CG_KSetBGCabHeight))
                )
              )
            )
          )
        )
      )
    )
  )
)
;SCFWFBowlCabSetHeight


;<HOM>*************************************************************************
; <�֐���>    : SCFConvertMaterialDwg
; <�����T�v>  : �W�J�}�O�ɐ}�`�f�[�^�𐳋K������
; <�߂�l>    : �Ȃ�
; <���l>      : (���d�v)�����ŕϊ����ꂽ�f�[�^�́A�W�J�}�I�����
;                       ���̐}�ʂ��J���Ȃ������߉e������Ȃ�
;*************************************************************************>MOH<
(defun SCFConvertMaterialDwg (
  )
  ; �_�~�[�̈悪�s���Ɏc���Ă���΍폜
  (DelDummyArea)

  ;;; 04/04/14 TM DEL-S
  ;;;�����ł̏����͓W�J�}�`�q�w�Ăяo�����O�ɌĂяo��
  ;;;���z�u���ނ����[�N�Ɉڂ�
  ;;;(SCFEraseWorkEnt)
  ;;;(SCFCnvWNSymbolApp CG_WG_WORK_CONVERT)
  ;; 04/04/14 TM DEL-E

  (SCFWFModGLSymPosAngle)
;  (SCFWFModGWrktPos)
  
  ;�L�b�`���p�l���̃T�C�Y����ݒ肵�Ȃ���
  (SCFCnvKPSymbolWDH)

  ;��̈�����炷(ARX�s��̒����j
  ;���O���菈���ŗ̈�̊�_�ƃV���{���̊�_����������ł��͈͓���
  ;�݂Ȃ��Ă��܂����߁A������ł��炷
  (SCFMoveRectArea)

  ;���ʂ̃{�E���L���r������΍�����750�ɂ���
  (SCFWFBowlCabSetHeight)

  ;TAKARA�p�V��t�B���[�̊g���f�[�^�̐��i�R�[�h���A�b�p�[���ނƂ���
  (SCFCnvFilerSymbol)

  ;�R�[�i�[�g�[���L���r�̐��i�R�[�h��ύX����
  (SCFCnvSkkCnrTallCab)

  ;�T�C�h�p�l���̐��i�R�[�h��ύX����
  (SCFCnvSkkSidePanel)

  (SCFWtCut)
  
  (SCFModYoutoLayer)

)
;SCFConvertMaterialDwg

;<HOM>*************************************************************************
; <�֐���>    : SCFCnvKPSymbolWDH
; <�����T�v>  : �L�b�`���p�l���A��̂̃T�C�Y����ݒ肵�Ȃ���
; <�߂�l>    : �Ȃ�
; <���l>      : G_SYM(W,D,H) <- SK_KP(W,D,H)
;*************************************************************************>MOH<
(defun SCFCnvKPSymbolWDH (
  /
  #ss
  #en
  #kpXd$ #symXd$
  #w #d #h
  )
  ;�L�b�`���p�l����W,D,H�����ւ���
  (setq #ss (ssget "X" '((-3 ("SK_KP,SK_KUTAI")))))
  (foreach #en (Ss2En$ #ss)
    (setq #kpXd$  (CFGetXData #en "SK_KP"))
    (if (= #kpXd$ nil)
      (progn
        (setq #kpXd$  (CFGetXData #en "SK_KUTAI"))
        (setq #kpXd$ (list (nth 0 #kpXd$) (* (nth 1 #kpXd$) -1) (nth 2 #kpXd$)))
      )
    )
    (setq #symXd$ (CFGetXData #en "G_SYM"))
    (setq #w (nth 0 #kpXd$))
    (setq #d (nth 1 #kpXd$))
    (setq #h (nth 2 #kpXd$))
    (if #symXd$
      (progn
        ;// �g���f�[�^�̍X�V
        (CFSetXData #en "G_SYM"
          (CFModList #symXd$
            (list (list 3 #w)(list 4 #d)(list 5 #h))
          )
        )
      )
    )
  )
)
;SCFCnvKPSymbolWDH

;<HOM>*************************************************************************
; <�֐���>    : SCFMoveRectArea
; <�����T�v>  : ��̈�����炷
; <�߂�l>    : �Ȃ�
; <���l>      : ��̈�����炷(ARX�s��̒����j
;                ���O���菈���ŗ̈�̊�_�ƃV���{���̊�_����������ł��͈͓���
;                �݂Ȃ��Ă��܂����߁A������ł��炷
;                0.5�����炵�Ă���̂ŁA���̕��ނ̊�_�Ƃ����鎖��
;                �܂��Ȃ��Ǝv���邪 ����������ARX�̉��C���K�v
;*************************************************************************>MOH<
(defun SCFMoveRectArea (
  /
  #ss
  )
  (setq #ss (ssget "X" '((8 . "N_YASHI_AREA"))))
  (if #ss
    (command "_.MOVE" #ss "" (list 0 0 0) (list 0.5 0.5 0))
  )
)
;SCFMoveRectArea

;<HOM>*************************************************************************
; <�֐���>    : SCFCnvFilerSymbol
; <�����T�v>  : �V��t�B���[���ނ� G_FILR �g���f�[�^���_�~�[�ݒ肷��
; <�߂�l>    : �Ȃ�
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCFCnvFilerSymbol (
  /
  #ss
  #en
  #xd$
  #filrSkk
  #en$
  )
  ;�V��t�B���[�̐��i�R�[�h
  (setq #filrSKK 920)

  ;�L�b�`���p�l����W,D,H�����ւ���
  (setq #ss (ssget "X" '((-3 ("G_TAKARA")))))
  (foreach #en (Ss2En$ #ss)
    (setq #xd$ (CFGetXData #en "G_TAKARA"))
    (if (= (nth 1 #xd$) 16)
      (progn
        (setq #xd$ (CFGetXData #en "G_LSYM"))
        ;// �g���f�[�^�̍X�V
        (CFSetXData #en "G_LSYM"
          (CFModList #xd$
            (list (list 9 #filrSkk))
          )
        )
      )
    )
  )
)
;SCFCnvFilerSymbol


;<HOM>*************************************************************************
; <�֐���>    : SCFCnvSkkCnrTallCab
; <�����T�v>  : �R�[�i�[�g�[���L���r�̐��i�R�[�h��ύX����
; <�߂�l>    : �Ȃ�
; <���l>      : ���i�R�[�h 915 -> 117 �ɕύX����
;             : ������̃R�[�i�[�g�[���L���r�́A���L�������s��
;                 ��_�����ォ�獶��
;                 �p�x+90�x
;                 W <-> D �̕ϊ�
;*************************************************************************>MOH<
(defun SCFCnvSkkCnrTallCab (
  /
  #ss
  #en
  #skk$
  #lXd$
  #sXd$
  #w #d
  #ang
  #p1 #p2
  #eg
  #subLay1 #subLay2
  #gEn$
  #lay
  )
  (princ "\n�ꎞ�I�ɃR�[�i�[�g�[���L���r�̐��i�R�[�h��ϊ����܂�")
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (foreach #en (Ss2En$ #ss)

    (setq #skk$ (CFGetSymSKKCode #en nil))
    ;�R�[�i�[�g�[���L���r�̏ꍇ
    (if (or (equal #skk$ (list 9 1 5)) (equal #skk$ (list 9 2 5)))
      (progn
        (setq #lXd$ (CFGetXData #en "G_LSYM"))
        (setq #sXd$ (CFGetXData #en "G_SYM"))

        ;���i�R�[�h�̍Đݒ�
        (CFSetXData #en "G_LSYM"
          (CFModList #lXd$
            (list
              (list 9 (+ 107 (* (nth 1 #skk$) 10)))
            )
          )
        )
        ;�R�[�i�[�g�[���L���r�̂k�^�̎��A�o�^��v�C�c������ւ����Ă��邽�߁A
        ;���@������o�͂ł��Ȃ����߁A�����Ő��K������
        (if (= "L" (nth 6 #lXd$))
          (progn
            (princ "\n�ꎞ�I�ɂk�^�R�[�i�[�g�[���L���r�̌��_�ƃT�C�Y����ϊ����܂�")
            (setq #w (nth 3 #sXd$))
            (setq #d (nth 4 #sXd$))

            ;------------------------------------------------------------------
            ;W��D�����ւ���
            ;------------------------------------------------------------------
            (CFSetXData #en "G_SYM"
              (CFModList #sXd$
                (list (list 3 #d) (list 4 #w))
              )
            )
            (setq #ang (angle0to360 (+ (nth 2 #lXd$) (* 0.5 PI))))
            (setq #lXd$ (CFGetXData #en "G_LSYM"))

            ;------------------------------------------------------------------
            ;�p�x�̐ݒ�
            ;------------------------------------------------------------------
            (CFSetXData #en "G_LSYM"
              (CFModList #lXd$
                (list
                  (list 2 #ang)
                )
              )
            )
            (setq #p1 (cdr (assoc 10 (entget #en))))
            (setq #p2 (polar #p1 (- #ang PI) #d))
            (command "_.move" #en "" #p1 #p2)

            ;��w������ɍ��킹�ĕύX����
            ; 03 -> 05
            ; 04 -> 06
            ; 05 -> 04
            ; 06 -> 03
            (setq #gEn$ (CFGetGroupEnt #en))

            ;------------------------------------------------------------------
            ; ��_�Ɗp�x���ς��̂ŁA�Y�������w���ύX����
            ;------------------------------------------------------------------
            (command "_.LAYER" "T" "Z_03*" "T" "Z_04*" "T" "Z_05*" "T" "Z_06" "")
            (foreach #en #gEn$
              (setq #eg (entget #en))
              (setq #lay (cdr (assoc 8 (entget #en))))
              (if #lay
                (progn
                  (setq #subLay1 (substr #lay 1 4))
                  (setq #subLay2 (substr #lay 5))
                  (cond
                    ((= "Z_03" #subLay1)
                      (entmod (subst (cons 8 (strcat "Z_05" #subLay2)) (cons 8 #lay) #eg))
                    )
                    ((= "Z_04" #subLay1)
                      (entmod (subst (cons 8 (strcat "Z_06" #subLay2)) (cons 8 #lay) #eg))
                    )
                    ((= "Z_05" #subLay1)
                      (entmod (subst (cons 8 (strcat "Z_04" #subLay2)) (cons 8 #lay) #eg))
                    )
                    ((= "Z_06" #subLay1)
                      (entmod (subst (cons 8 (strcat "Z_03" #subLay2)) (cons 8 #lay) #eg))
                    )
                  )
                )
              )
            )
            (command "_.LAYER" "F" "Z_03*" "F" "Z_04*" "F" "Z_05*" "F" "Z_06" "")
          )
        )
      )
    )
  )
)
;SCFCnvSkkCnrTallCab

;<HOM>*************************************************************************
; <�֐���>    : SCFCnvSkkSidePanel
; <�����T�v>  : �T�C�h�p�l���̐��i�R�[�h��ύX����
; <�߂�l>    : �Ȃ�
; <���l>      : ���i�R�[�h 610 -> 611 �ɕύX����
;               �ύX����̂̓t���b�g�Ζʂ���сA�V���N�A�C�����h���[�N�g�b�v��
;*************************************************************************>MOH<
(defun SCFCnvSkkSidePanel (
  /
  #sslsym
  #enlsym
  #sswkset
  #enwkset
  #skk$
  #lXd$
  #pt$$
  #pt$
  #10$
  #sp1
  #sp2
  #sp3
  #sp4
  #wkhin
  #flg
  #flg2
  #ryoiki
  )
  (princ "\n�ꎞ�I�ɃT�C�h�p�l���̐��i�R�[�h��ϊ����܂�")
  (setq #sswkset (ssget "X" '((-3 ("G_WTSET")))))
  (setq #sslsym (ssget "X" '((-3 ("G_LSYM")))))
  (foreach #enlsym (Ss2En$ #sslsym)

    (setq #skk$ (CFGetSymSKKCode #enlsym nil))
    ;�R�[�i�[�g�[���L���r�̏ꍇ
    (if (equal #skk$ (list 6 1 0))
      (progn
        (setq #flg nil)
        (foreach #enwkset (Ss2En$ #sswkset)
          (setq #wkhin (CfGetXData #enwkset "G_WTSET"))
;          (if (= CG_SeriesCode "L")
;         (if #wkhin (setq #wkhin (substr (nth 1 #wkhin) 3 1)))
;         (if (and #wkhin (or (= #wkhin "V") (= #wkhin "H") (= #wkhin "P")))
;            (progn
              (setq #pt$$ (GetWorkTopArea #enwkset))
              (setq #flg2 nil)
              (foreach #pt$ #pt$$
                (setq #ryoiki (nth 0 #pt$))
                (setq #10$ (GetSym4PtDHelf #enlsym))
                (setq #sp1 (nth 0 #10$))
                (setq #sp2 (nth 1 #10$))
                (setq #sp3 (nth 2 #10$))
                (setq #flg T)
                (foreach #10 (list #sp1 #sp2 #sp3)
                  (setq #10 (list (car #10) (cadr #10) 0.0))
                  (if (and (not (JudgeNaigai #10 #ryoiki))(not (JudgeNaigai #10 (reverse #ryoiki))))
                    (setq #flg nil)
                  )
                )
                (if #flg
                  (setq #flg2 T)
                )
;|
                (setq #10$ (GetSym4Pt #enlsym))
                (setq #sp1 (nth 0 #10$))
                (setq #sp2 (nth 1 #10$))
                (setq #sp3 (nth 2 #10$))
                (setq #sp4 (polar #sp1 (angle #sp1 #sp2) (* 0.5 (distance #sp1 #sp2))))
                (setq #sp4 (polar #sp4 (- (angle #sp1 #sp2) (* 0.5 PI)) CG_MIKIRI_OFFSET))
                (foreach #10 (list #sp1 #sp2 #sp3 #sp4)
                  (setq #10 (list (car #10) (cadr #10) 0.0))
                  (if (or (JudgeNaigai #10 #ryoiki) (JudgeNaigai #10 (reverse #ryoiki)))
                    (setq #flg2 T)
                  )
                )
                (if #flg2
                  (setq #flg T)
                )
|;
              )
;            )
;          )
          (if #flg
            (progn
              (setq #lXd$ (CFGetXData #enlsym "G_LSYM"))

              ;���i�R�[�h�̍Đݒ�
              (CFSetXData #enlsym "G_LSYM"
                (CFModList #lXd$
                  (list
                    (list 9 611)
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
;SCFCnvSkkSidePanel


;<HOM>*************************************************************************
; <�֐���>    : SCFWtCut
; <�����T�v>  : L�^�V�J�b�g
; <�߂�l>    : �Ȃ�
; <���l>      :
;*************************************************************************>MOH<
(defun SCFWtCut (
  /
  #ss #i #en #ret$ #ret #j #enpl #enpld$
  )
  (if (not (tblsearch "APPID" "G_WTCUT")) (regapp "G_WTCUT"))
  (setq #ss (ssget "X" (list (list -3 (list "G_WRKT")))))
  (if #ss
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (if (and (= (nth  3 (CFGetXData #en "G_WRKT"))   1)
                 (> (nth 42 (CFGetXData #en "G_WRKT")) 750)
                 (> (nth 43 (CFGetXData #en "G_WRKT")) 750)
            )
          (progn
            (setq #ret$ (PKW_Tenban_Cut #en))
            (if #ret$
              (progn
                (setq #j 0)
                (foreach #ret #ret$
                  (setq #enpl (MakeLwPolyLine (cdr #ret) 1 0.0))
                  (setq #enpld$ (entget #enpl))
                  (entmod (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 #enpld$) #enpld$))
                  (CFSetXData (car #ret) "G_WTCUT" (list #j #enpl))
                  (SKMkGroup (CFCnvElistToSS (list (car #ret))))
                  (setq #j (1+ #j))
                )
              )
            )
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
  T
)
;SCFWtCut

;<HOM>*************************************************************************
; <�֐���>    : SCFGetTokuseichi
; <�����T�v>  : �����l�擾
; <�߂�l>    : �Ȃ�
; <���l>      :
;*************************************************************************>MOH<
(defun SCFGetTokuseichi (
  /
  #tokuseichi1$ #tokuseichi2$
  )
  (if (not CG_INPUTFILEPATH)
    (PKC_MitumoriSetEnv)
  )
  (setq #tokuseichi1$ (ReadIniFileSection (strcat CG_KENMEI_PATH "SRCPLN.CFG") "COMMON"))
  (if #tokuseichi1$
    (setq #tokuseichi1$ (ReadIniFileSection (strcat CG_KENMEI_PATH "SRCPLN.CFG") (nth 1 (assoc "PLANTYPE" #tokuseichi1$))))
  )
  (setq #tokuseichi2$ (SCFGetIniPutIdList))
  (list #tokuseichi1$ #tokuseichi2$)
)
;SCFGetTokuseichi

;<HOM>*************************************************************************
; <�֐���>    : PKC_MitumoriSetEnv
; <�����T�v>  : ���ݒ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2004-09-09 G.YK
; <���l>      :
;*************************************************************************>MOH<
(defun PKC_MitumoriSetEnv (
  /
  #PlanInfo #DataFile
  )
  ;\CustomSK\WORK\ ���߽
  (setq CG_WORKPATH (cadr (assoc "WORKPATH" CG_INIINFO$)))
  (setq #PlanInfo (ReadIniFile (strcat CG_WORKPATH "PlanInfo.cfg")))
  (setq #DataFile (cadr (assoc "DATFILE" #PlanInfo)))
  ;�`.top ̧�ق��߽
  (setq CG_INPUTFILEPATH (strcat CG_WORKPATH (cadr (assoc "DATFILE" #PlanInfo))))
)





(princ)
;;; end of KCFmat.lsp
