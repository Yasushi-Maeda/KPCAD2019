;<HOM>*************************************************************************
; <�֐���>    : C:StretchCabW
; <�����T�v>  : �������޺����(������)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 
; <���l>      : 
;*************************************************************************>MOH<
(defun C:StretchCabW (
  /
	#cmdecho #osmode #pickstyle #sys$ #en #err_flag #sym #ss #bsym
	#err_flag #xd_LSYM$ #hinban #qry$$ #taisyo #taisyo_str #chk
  )

	;****************************************************
	; �G���[����
	;****************************************************
  (defun StretchCabWUndoErr( &msg )
    (command "_undo" "b")
    (CFCmdDefFinish)
    (setq *error* nil)
    (princ)
  )
	;****************************************************

 	;****************************************************
  ;	2018/03/13 YK ADD-STR�@�p�x�����������Ƃ��̑Ή�
 (defun LsymRadChg(
    /
    #ss_LSYM #sym #i #xd$ #rad
;	  #basePT #baseX #baseY #baseZ
    )
	  (setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM")))))
    (if (and #ss_LSYM (< 0 (sslength #ss_LSYM)))
      (progn
		  	(setq #i 0)
		  	(repeat (sslength #ss_LSYM)
		  		(setq #sym (ssname #ss_LSYM #i))
		  		(setq #xd$ (CFGetXData #sym "G_LSYM"))
          (setq #rad  (nth 2 #xd$))     ; �z�u�p�x

					;2018/09/05 YM MOD
;;;				  (if (equal #rad      0 0.0001) (setq #rad    0)) ;2018/08/30 YM ����͗L�������A�O�ȊO���Ή��K�v
				  (if (equal #rad      0 0.0001) (setq #rad  0.0)) ;2018/08/30 YM ����͗L�������A�O�ȊO���Ή��K�v
					;2018/09/05 YM MOD
					
          (CFSetXData #sym "G_LSYM"
            (CFModList #xd$
              (list
                (list 2 #rad)
              )
            )
          )
			  	(setq #i (+ #i 1)) 
  	  	)
	  	)
	  )
    (princ)
  );_(defun c:oya()
   (LsymRadChg)
	
  ;	2018/03/13 YK ADD-END�@�p�x�����������Ƃ��̑Ή�
 	;****************************************************
	
  (setq *error* StretchCabWUndoErr)
	(setq #cmdecho (getvar "CMDECHO"))
	(setq #osmode (getvar "OSMODE"))
	(setq #pickstyle (getvar "PICKSTYLE"))
	(setvar "CMDECHO" 0)
	(setvar "OSMODE" 0)
  (setvar "PICKSTYLE" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")

  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
	(setq CG_BASE_UPPER nil)
	(setq CG_POS_STR nil)
	(setq CG_TOKU T)
  (KP_TOKU_GROBAL_RESET)
	(setq #err_flag nil)
	(setq #taisyo_str "")

	(setq #en T)
	(while #en
		(setq #err_flag nil)
		(setq #sym nil)
		(setq #en (car (entsel "\n���ނ�I�� : ")))
		(if #en (setq #sym (CFSearchGroupSym #en)))
		(if (and #en (not #sym)) (CFAlertMsg "���̕��ނ͓������ł��܂���"))
		(if #sym ; ����ق�����
			(cond
				((CFGetXData #sym "G_KUTAI")
					nil
				)
				(T
					(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
					(setq #hinban (nth 5 #xd_LSYM$))

					(setq #qry$$
						(CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
							(list
								(list "�i�Ԗ���" #hinban 'STR)
							)
						)
					)

					(if (/= #qry$$ nil)
						(if (= (length #qry$$) 1)
							(setq #taisyo (nth 10 (nth 0 #qry$$)))
							(progn
								(CFAlertMsg "�i�Ԋ�{���̎擾�Ɏ��s���܂����B�������I�����܂��B")
								(setq #err_flag T)
							)
						)
						(progn
							(CFAlertMsg "�i�Ԋ�{���̎擾�Ɏ��s���܂����B�������I�����܂��B")
							(setq #err_flag T)
						)
					)

					(if (= #err_flag nil)
						(if (or (= #taisyo "X") (= #taisyo "") (= #taisyo nil))
							(progn
								(cond
									((= #taisyo "")
										(setq #taisyo_str "��")
									)
									((= #taisyo nil)
										(setq #taisyo_str "��")
									)
									(T
										(setq #taisyo_str "X")
									)
								)
								(CFAlertMsg "���̕��ނ͓������ł��܂���")
								(princ (strcat "\n�������� �i�Ԋ�{�F�i�Ԗ��� = " #hinban "  �����Ώ� = " #taisyo_str))
								(setq #err_flag T)
							)
						)
					)

;-- 2011/12/16 A.Satoh Add - S
					(if (= #err_flag nil)
						(progn
							; �I���������ނ̓������۔�����s��
							(setq #chk (StretchCabW_CheckExec #sym #taisyo))
							(if (= #chk nil)
								(progn
									(CFAlertMsg "���̕��ނ͂���ȏ�������ł��܂���")
									(setq #err_flag T)
								)
							)
						)
					)
;-- 2011/12/16 A.Satoh Add - E

					(if (= #err_flag nil)
						(progn
							; �}�`�F��ύX
							(setq #ss (CFGetSameGroupSS #sym))
							(command "_change" #ss "" "P" "C" CG_InfoSymCol "")

;-- 2012/02/23 A.Satoh Add - S
							; �A���������ɔ��̐L�k���s���B
				      ; �����I�Ƀ��C���t���[���\���ɕύX����B
							(C:2DWire)
;-- 2012/02/23 A.Satoh Add - E

							(if (= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3))
								; �R�[�i�[�L���r�ł���ꍇ
								(StretchCabW_CNR_sub #sym #taisyo #chk)
								; �R�[�i�[�L���r�ȊO�ł���ꍇ
								(StretchCabW_sub #sym #taisyo #chk)
							)

							;�F��߂�
;-- 2012/02/15 A.Satoh Add - S
							(setq #ss (CFGetSameGroupSS #sym))
;-- 2012/02/15 A.Satoh Add - E
							(command "_change" #ss "" "P" "C" "BYLAYER" "")

							;����т̏ꍇ�͊���ѐF�ɂ���B
							(if (and (setq #bsym (car (CFGetXRecord "BASESYM"))) (equal (handent #bsym) #sym))
								(progn
									(ResetBaseSym)
									(GroupInSolidChgCol #sym CG_BaseSymCol)
								)
							)

							(setq #en nil)
						)
					)
				)
			)
		)
	)

  (setq CG_TOKU nil)
  (setq CG_TOKU_BW nil)
  (setq CG_TOKU_BD nil)
  (setq CG_TOKU_BH nil)
	(setq CG_BASE_UPPER nil)
	(setq CG_POS_STR nil)
  (KP_TOKU_GROBAL_RESET)

	(CFCmdDefFinish)
	(PKEndCOMMAND #sys$)
	(setvar "CMDECHO" #cmdecho)
	(setvar "OSMODE" #osmode)
  (setvar "PICKSTYLE" #pickstyle)
	(setq *error* nil)

;  (alert "�������@�H�����@������")

  (princ)
);C:StretchCabW


;-- 2011/12/16 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_CheckExec
; <�����T�v>  : �I���������ނ̓������۔�����s��
; <�߂�l>    : T  : �������\
;             : nil: �������s��
; <�쐬>      : 11/12/16 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_CheckExec (
	&en		; �V���{���}�`��
	&taisyo	; �����Ώ�
  /
;-- 2012/02/16 A.Satoh Mod CG�Ή� - S
;;;;;	#ret #W_f #D_f #H_f #xd_TOKU$ #xd_SYM$
	#ret #W_f #D_f #H_f #xd_TOKU$ #xd_REG$
;-- 2012/02/16 A.Satoh Mod CG�Ή� - E
  )

	(setq #ret nil)

	(if (= &taisyo "A")
		(progn
			(setq #W_f T)
			(setq #D_f T)
			(setq #H_f T)
		)
		(if (= (strlen &taisyo) 4)
			(progn
				(if (= (substr &taisyo 2 1) "W")
					(setq #W_f T)
					(setq #W_f nil)
				)
				(if (= (substr &taisyo 3 1) "D")
					(setq #D_f T)
					(setq #D_f nil)
				)
				(if (= (substr &taisyo 4 1) "H")
					(setq #H_f T)
					(setq #H_f nil)
				)
			)
			(progn
				(setq #W_f T)
				(setq #D_f T)
				(setq #H_f T)
			)
		)
	)

	(setq #xd_TOKU$ (CFGetXData &en "G_TOKU"))
	(if #xd_TOKU$
		(progn	; �������(G_TOKU)���ݒ肳��Ă���ꍇ
;-- 2012/02/22 A.Satoh Mod - S
;;;;;			(if (and (= #W_f T) (not (equal (nth 4 #xd_TOKU$) (nth 12 #xd_TOKU$) 0.001)))
			(if (and (= #W_f T) (not (equal (nth 17 #xd_TOKU$) (nth 12 #xd_TOKU$) 0.001)))
;-- 2012/02/22 A.Satoh Add - E
				(setq #W_f nil)
			)
;-- 2012/02/22 A.Satoh Mod - S
;;;;;			(if (and (= #D_f T) (not (equal (nth 6 #xd_TOKU$) (nth 13 #xd_TOKU$) 0.001)))
			(if (and (= #D_f T) (not (equal (nth 18 #xd_TOKU$) (nth 13 #xd_TOKU$) 0.001)))
;-- 2012/02/22 A.Satoh Add - E
				(setq #D_f nil)
			)
;-- 2012/02/22 A.Satoh Mod - S
;;;;;			(if (and (= #H_f T) (not (equal (nth 5 #xd_TOKU$) (nth 14 #xd_TOKU$) 0.001)))
			(if (and (= #H_f T) (not (equal (nth 19 #xd_TOKU$) (nth 14 #xd_TOKU$) 0.001)))
;-- 2012/02/22 A.Satoh Add - E
				(setq #H_f nil)
			)
		)
		(progn	; �������(G_TOKU)���ݒ肳��Ă��Ȃ��ꍇ
;-- 2012/02/16 A.Satoh Mod - S
;;;;;			(setq #xd_SYM$ (CFGetXData &en "G_SYM"))
;;;;;			(if #xd_SYM$
;;;;;				(progn
;;;;;					(if (and (= #W_f T) (not (equal (nth 11 #xd_SYM$) 0.0 0.001)))
;;;;;						(setq #W_f nil)
;;;;;					)
;;;;;					(if (and (= #D_f T) (not (equal (nth 12 #xd_SYM$) 0.0 0.001)))
;;;;;						(setq #D_f nil)
;;;;;					)
;;;;;					(if (and (= #H_f T) (not (equal (nth 13 #xd_SYM$) 0.0 0.001)))
;;;;;						(setq #H_f nil)
;;;;;					)
;;;;;				)
;;;;;				(progn
;;;;;					(setq #W_f nil)
;;;;;					(setq #D_f nil)
;;;;;					(setq #H_f nil)
;;;;;				)
;;;;;			)
			(setq #xd_REG$ (CFGetXData &en "G_REG"))
			(if #xd_REG$
				(progn
;-- 2012/02/22 A.Satoh Mod - S
;;;;;					(if (and (= #W_f T) (not (equal (nth 4 #xd_REG$) (nth 12 #xd_REG$) 0.001)))
					(if (and (= #W_f T) (not (equal (nth 17 #xd_REG$) (nth 12 #xd_REG$) 0.001)))
;-- 2012/02/22 A.Satoh Mod - E
						(setq #W_f nil)
					)
;-- 2012/02/22 A.Satoh Mod - S
;;;;;					(if (and (= #D_f T) (not (equal (nth 6 #xd_REG$) (nth 13 #xd_REG$) 0.001)))
					(if (and (= #D_f T) (not (equal (nth 18 #xd_REG$) (nth 13 #xd_REG$) 0.001)))
;-- 2012/02/22 A.Satoh Mod - E
						(setq #D_f nil)
					)
;-- 2012/02/22 A.Satoh Mod - S
;;;;;					(if (and (= #H_f T) (not (equal (nth 5 #xd_REG$) (nth 14 #xd_REG$) 0.001)))
					(if (and (= #H_f T) (not (equal (nth 19 #xd_REG$) (nth 14 #xd_REG$) 0.001)))
;-- 2012/02/22 A.Satoh Mod - E
						(setq #H_f nil)
					)
				)
			)
;-- 2012/02/16 A.Satoh Mod - E
		)
	)

	(if (or (= #W_f T) (= #D_f T) (= #H_f T))
		(setq #ret (list #W_f #D_f #H_f))
		(setq #ret nil)
	)

	#ret

);StretchCabW_CheckExec
;-- 2011/12/16 A.Satoh Add - E


;-- 2012/02/15 A.Satoh Add CG�Ή� - S
;<HOM>*************************************************************************
; <�֐���>    : InputGRegData
; <�����T�v>  : �w��̃V���{���ɑ΂��ĐL�k���M�����[�L���r�L���r���(G_REG)
;             : ��ݒ肷��
; <�߂�l>    : T:����I�� nil �L�����Z���I��
; <�쐬>      : 12/02/15 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun InputGRegData (
  &sym				; �ΏۃV���{���}�`
	&org_size$	; �C���O�T�C�Y���X�g (�� ���s ����)
	&XLINE_W$
	&XLINE_D$
	&XLINE_H$
	&chk
	&cab_size$
	&flag       ; �R�[�i�[�L���r�FT    �R�[�i�[�L���r�ȊO�Fnil
  /
	#ret #err_flag #org_width #org_depth #org_height #hinban #hinban2 #lr #hin_last #hinban$
	#xd_REG$ #XLINE_W$ #XLINE_D$ #XLINE_H$ #xd_SYM$ #xd_LSYM$
	#maguti1 #maguti2 #maguti3 #oku1 #oku2 #oku3 #height1 #height2 #height3
;-- 2012/02/22 A.Satoh Mod - S
;;;;;#hin_last$ #hin_width #hin_depth #hin_takasa #width_diff #height_diff #depth_diff  ;-- 2012/02/21 A.Satoh Add
#hin_last$ #hin_width #hin_depth #hin_takasa
;-- 2012/02/22 A.Satoh Mod - S
#W_sabun #D_sabun #H_sabun #W_f #D_f #H_f  ;-- 2012/02/22 A.Satoh Add
#str_d #str_c    ;-- 2012/03/16 A.Satoh Add
#DOOR_INFO$ #DRCOLCODE #DRHIKITE #DRSERICODE #RET$ #SET_CG ;2013/08/05 YM ADD
  )

	(setq #ret T)
	(setq #err_flag nil)
	(setq #set_cg nil)
	(setq #org_width  (nth 0 &org_size$))
	(setq #org_depth  (nth 1 &org_size$))
	(setq #org_height (nth 2 &org_size$))
;-- 2012/02/22 A.Satoh Add - S
	(setq #W_sabun 0.0)
	(setq #D_sabun 0.0)
	(setq #H_sabun 0.0)

	(setq #W_f T)
	(setq #D_f T)
	(setq #H_f T)

	(if (= (nth 0 &chk) nil)
		(setq #W_f nil)
	)
	(if (= (nth 1 &chk) nil)
		(setq #D_f nil)
	)
	(if (= (nth 2 &chk) nil)
		(setq #H_f nil)
	)
;-- 2012/02/22 A.Satoh Add - E

	(setq #xd_REG$ (CFGetXData &sym "G_REG"))
	(if (= #xd_REG$ nil)
		(progn
			(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
			(if (= #xd_LSYM$ nil)
				(setq #err_flag T)
			)

			(if (= #err_flag nil)
				(progn
					(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
					(if (= #xd_SYM$ nil)
						(setq #err_flag T)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
					; �L�k�O��̃V���{���T�C�Y�̍����擾
;-- 2012/02/22 A.Satoh Del - S
;;;;;;-- 2012/02/21 A.Satoh Add - S
;;;;;					(setq #width_diff  (- (nth 3 #xd_SYM$) #org_width))
;;;;;					(setq #depth_diff  (- (nth 4 #xd_SYM$) #org_depth))
;;;;;					(setq #height_diff (- (nth 5 #xd_SYM$) #org_height))
;;;;;;-- 2012/02/21 A.Satoh Add - E
;-- 2012/02/22 A.Satoh Del - E
					(setq #hinban (nth 5 #xd_LSYM$))
					(setq #lr     (nth 6 #xd_LSYM$))

					; �i�Ԗ��̂��犇�ʂ����O
					(setq #hinban2 (KP_DelHinbanKakko #hinban))

					; �ŏI�i�Ԃ��擾
;-- 2012/02/21 A.Satoh Mod - S
;;;;;					(setq #hin_last (car (StretchCabW_GetHinbanLast #hinban2 #lr)))
;;;;;					(if (= #hin_last nil)
;;;;;						(setq #err_flag T)
;;;;;					)

					;2013/08/05 YM MOD-S
					(setq #Door_Info$     (nth 7 #xd_LSYM$))
					(setq #ret$ (StrParse #Door_Info$ ","))
					(setq #DRSeriCode (car   #ret$))(if (= #DRSeriCode nil)(setq #DRSeriCode ""))
					(setq #DRColCode  (cadr  #ret$))(if (= #DRColCode nil)(setq #DRColCode ""))
					(setq #DRHikite   (caddr #ret$))(if (= #DRHikite nil)(setq #DRHikite ""))

					(if (= #DRSeriCode "")
						(progn
							(setq #DRSeriCode CG_DRSeriCode)
							(setq #DRColCode  CG_DRColCode)
							(setq #DRHikite   CG_Hikite)
						)
					);_if

;;;					(setq #hin_last$ (StretchCabW_GetHinbanLast #hinban2 #lr))
					(setq #hin_last$ (StretchCabW_GetHinbanLast_HIKISU #hinban2 #lr #DRSeriCode #DRColCode #DRHikite))
					;2013/08/05 YM MOD-E


					(if (= #hin_last$ nil)
						(progn
							(setq #hin_last #hinban)
							(setq #hin_width  (nth 3 #xd_SYM$))
							(setq #hin_depth  (nth 4 #xd_SYM$))
							(setq #hin_takasa (nth 5 #xd_SYM$))
						)
						(progn
							(setq #hin_last (car #hin_last$))
;-- 2012/02/22 A.Satoh Mod - S
;;;;;							(setq #hin_width  (+ (atof (nth 1 #hin_last$)) #width_diff))
;;;;;							(setq #hin_takasa (+ (atof (nth 2 #hin_last$)) #height_diff))
;;;;;							(setq #hin_depth  (+ (atof (nth 3 #hin_last$)) #depth_diff))
							(if (= #W_f T)
								(setq #W_sabun (- (nth 3 #xd_SYM$) #org_width))
							)
							(if (= #D_f T)
								(setq #D_sabun (- (nth 4 #xd_SYM$) #org_depth))
							)
							(if (= #H_f T)
								(setq #H_sabun (-(nth 5 #xd_SYM$) #org_height ))
							)
							(setq #hin_width  (+ (atof (nth 1 #hin_last$)) #W_sabun))
							(setq #hin_takasa (+ (atof (nth 2 #hin_last$)) #H_sabun))
							(setq #hin_depth  (+ (atof (nth 3 #hin_last$)) #D_sabun))
;-- 2012/02/22 A.Satoh Mod - S
						)
					)
;-- 2012/02/21 A.Satoh Mod - E
				)
			)

			(if (= #err_flag nil)
				(setq #hinban$
					(list
						""										; �����i��
						0.0										; ���z
						""										; �i��
						""										; �����R�[�h�@�����R�[�h-�A��
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(nth 3 #xd_SYM$)			; ��
;;;;;						(nth 5 #xd_SYM$)			; ����
;;;;;						(nth 4 #xd_SYM$)			; ���s
						#hin_width						; ��
						#hin_takasa						; ����
						#hin_depth						; ���s
;-- 2012/02/21 A.Satoh Mod - E
					)
				)
			)
		)
		(progn
			(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
			(if (= #xd_LSYM$ nil)
				(setq #err_flag T)
			)

			(if (= #err_flag nil)
				(progn
					(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
					(if (= #xd_SYM$ nil)
						(setq #err_flag T)
					)
				)
			)

;-- 2012/02/22 A.Satoh Mod - S
;;;;;			(if (= #err_flag nil)
;;;;;				(setq #hinban$
;;;;;					(list
;;;;;						(nth 0 #xd_REG$)			; �����i��
;;;;;						(nth 1 #xd_REG$)			; ���z
;;;;;						(nth 2 #xd_REG$)			; �i��
;;;;;						(nth 3 #xd_REG$)			; �����R�[�h
;;;;;;-- 2012/02/21 A.Satoh Mod - S
;;;;;;;;;;						(nth 3 #xd_SYM$)			; ��
;;;;;;;;;;						(nth 5 #xd_SYM$)			; ����
;;;;;;;;;;						(nth 4 #xd_SYM$)			; ���s
;;;;;						(nth 4 #xd_REG$)			; ��
;;;;;						(nth 5 #xd_REG$)			; ����
;;;;;						(nth 6 #xd_REG$)			; ���s
;;;;;;-- 2012/02/21 A.Satoh Mod - E
;;;;;					)
;;;;;				)
;;;;;			)
			(if (= #err_flag nil)
				(progn
					(if (= #W_f T)
						(setq #W_sabun (- (nth 3 #xd_SYM$) #org_width))
					)
					(if (= #D_f T)
						(setq #D_sabun (- (nth 4 #xd_SYM$) #org_depth))
					)
					(if (= #H_f T)
						(setq #H_sabun (- (nth 5 #xd_SYM$) #org_height ))
					)
					(setq #hin_width  (+ (nth 4 #xd_REG$) #W_sabun))
					(setq #hin_takasa (+ (nth 5 #xd_REG$) #H_sabun))
					(setq #hin_depth  (+ (nth 6 #xd_REG$) #D_sabun))

					(setq #hinban$
						(list
							(nth 0 #xd_REG$)			; �����i��
							(nth 1 #xd_REG$)			; ���z
							(nth 2 #xd_REG$)			; �i��
							(nth 3 #xd_REG$)			; �����R�[�h
							#hin_width						; ��
							#hin_takasa						; ����
							#hin_depth						; ���s
						)
					)
				)
			)
;-- 2012/02/22 A.Satoh Mod - E
		)
	)

	(if (= #err_flag nil)
		(progn
			(if &XLINE_W$
				(progn
					; �u���[�N���C���ʒu���������Ń\�[�g����
					(setq #XLINE_W$ (SortBrkLineDist &XLINE_W$))

					(setq #maguti1 (car #XLINE_W$))
					(if (= #maguti1 nil)
						(setq #maguti1 0.0)
					)
					(setq #maguti2 (cadr #XLINE_W$))
					(if (= #maguti2 nil)
						(setq #maguti2 0.0)
					)
					(setq #maguti3 (caddr #XLINE_W$))
					(if (= #maguti3 nil)
						(setq #maguti3 0.0)
					)
				)
				(progn
					(setq #maguti1 0.0)
					(setq #maguti2 0.0)
					(setq #maguti3 0.0)
				)
			)
			(if &XLINE_D$
				(progn
					; �u���[�N���C���ʒu���������Ń\�[�g����
					(setq #XLINE_D$ (SortBrkLineDist &XLINE_D$))

					(setq #oku1 (car #XLINE_D$))
					(if (= #oku1 nil)
						(setq #oku1 0.0)
					)
					(setq #oku2 (cadr #XLINE_D$))
					(if (= #oku2 nil)
						(setq #oku2 0.0)
					)
					(setq #oku3 (caddr #XLINE_D$))
					(if (= #oku3 nil)
						(setq #oku3 0.0)
					)
				)
				(progn
					(setq #oku1 0.0)
					(setq #oku2 0.0)
					(setq #oku3 0.0)
				)
			)
			(if &XLINE_H$
				(progn
					; �u���[�N���C���ʒu���������Ń\�[�g����
					(setq #XLINE_H$ (SortBrkLineDist &XLINE_H$))

					(setq #height1 (car #XLINE_H$))
					(if (= #height1 nil)
						(setq #height1 0.0)
					)
					(setq #height2 (cadr #XLINE_H$))
					(if (= #height2 nil)
						(setq #height2 0.0)
					)
					(setq #height3 (caddr #XLINE_H$))
					(if (= #height3 nil)
						(setq #height3 0.0)
					)
				)
				(progn
					(setq #height1 0.0)
					(setq #height2 0.0)
					(setq #height3 0.0)
				)
			)

			; �L�k���M�����[�L���r���(G_REG)�̐ݒ�
			(if #xd_REG$
				(progn
;-- 2012/03/16 A.Satoh Add - S
					(if &flag
						(if (> (nth 15 #xd_REG$) 0.0)
							(setq #str_d (nth 15 #xd_REG$))
							(setq #str_d (nth 3 &cab_size$))
						)
						(setq #str_d (nth 15 #xd_REG$))
					)
					(if &flag
						(if (> (nth 16 #xd_REG$) 0.0)
							(setq #str_c (nth 16 #xd_REG$))
							(setq #str_c (nth 2 &cab_size$))
						)
						(setq #str_c (nth 16 #xd_REG$))
					)
;-- 2012/03/16 A.Satoh Add - E

					(CFSetXData &sym "G_REG"
						(CFModList #xd_REG$
							(list
								(list  0 (nth 0 #hinban$))										; [ 0]�����i��
								(list  1 (nth 1 #hinban$))										; [ 1]���z
								(list  2 (nth 2 #hinban$))										; [ 2]�i��
								(list  3 (nth 3 #hinban$))										; [ 3]�����R�[�h
								(list  4 (nth 4 #hinban$))										; [ 4]��
								(list  5 (nth 5 #hinban$))										; [ 5]����
								(list  6 (nth 6 #hinban$))										; [ 6]���s
;-- 2012/03/16 A.Satoh Add - S
								(list 15 #str_d)															; [15]�c�̐L�k��
								(list 16 #str_c)															; [16]�b�̐L�k��
;-- 2012/03/16 A.Satoh Add - E
								(list 17 (nth 3 #xd_SYM$))										; [17]�L�k��}�`�T�C�Y�v
								(list 18 (nth 4 #xd_SYM$))										; [18]�L�k��}�`�T�C�Y�c
								(list 19 (nth 5 #xd_SYM$))										; [19]�L�k��}�`�T�C�Y�g
								(if &XLINE_W$
									(list 20 (list #maguti1 #maguti2 #maguti3))	; [20]�u���[�N���C���ʒu�v
									(list 20 (nth 20 #xd_REG$))
								)
								(if &XLINE_D$
									(list 21 (list #oku1    #oku2    #oku3))		; [21]�u���[�N���C���ʒu�c
									(list 21 (nth 21 #xd_REG$))
								)
								(if &XLINE_H$
									(list 22 (list #height1 #height2 #height3))	; [22]�u���[�N���C���ʒu�g
									(list 22 (nth 22 #xd_REG$))
								)
							)
						)
					)
				)
				(CFSetXData &sym "G_REG"
					(list
						(nth 0 #hinban$)													; [ 0]�����i��
						(nth 1 #hinban$)													; [ 1]���z
						(nth 2 #hinban$)													; [ 2]�i��
						(nth 3 #hinban$)													; [ 3]�����R�[�h
						(nth 4 #hinban$)													; [ 4]��
						(nth 5 #hinban$)													; [ 5]����
						(nth 6 #hinban$)													; [ 6]���s
						""																				; [ 7]�\���P
						""																				; [ 8]�\���Q
						""																				; [ 9]�\���R
						#hinban																		; [10]���i�Ԗ���
						#hin_last																	; [11]���ŏI�i��
						#org_width																; [12]���}�`�T�C�Y�v
						#org_depth																; [13]���}�`�T�C�Y�c
						#org_height																; [14]���}�`�T�C�Y�g
;-- 2012/03/16 A.Satoh Mod -S
;;;;;						""																				; [15]�\���S
;;;;;						""																				; [16]�\���T
						(if &flag
							(nth 3 &cab_size$)											; [15]�c�̐L�k��
							0.0																			; [15]�c�̐L�k��
						)
						(if &flag
							(nth 2 &cab_size$)											; [16]�b�̐L�k��
							0.0																			; [16]�b�̐L�k��
						)
;-- 2012/03/16 A.Satoh Mod -E
						(nth 3 #xd_SYM$)													; [17]�L�k��}�`�T�C�Y�v
						(nth 4 #xd_SYM$)													; [18]�L�k��}�`�T�C�Y�c
						(nth 5 #xd_SYM$)													; [19]�L�k��}�`�T�C�Y�g
						(list #maguti1 #maguti2 #maguti3)					; [20]�u���[�N���C���ʒu�v
						(list #oku1    #oku2    #oku3)						; [21]�u���[�N���C���ʒu�c
						(list #height1 #height2 #height3)					; [22]�u���[�N���C���ʒu�g
					)
				)
			)
		)
		(setq #ret nil)
	)

	#ret

);InputGRegData


;<HOM>*************************************************************************
; <�֐���>    : SortBrkLineDist
; <�����T�v>  : �u���[�N���C���ʒu��񃊃X�g�̓��e���\�[�g����
; <�߂�l>    : �\�[�g��̃u���[�N���C���ʒu��񃊃X�g
; <�쐬>      : 12/02/17 A.Satoh
; <���l>      : 3���ڂ̃��X�g��z��
;             : 0.0�̓\�[�g�ΏۊO
;*************************************************************************>MOH<
(defun SortBrkLineDist (
	&XLINE$
  /
	#ret$ #flag #item1 #item2 #item3 #wk_item
  )

	(setq #ret$ nil)
	(setq #flag nil)

	(setq #item1 (car   &XLINE$))
	(if (= #item1 nil)
		(setq #item1 0.0)
	)
	(setq #item2 (cadr  &XLINE$))
	(if (= #item2 nil)
		(setq #item2 0.0)
	)
	(setq #item3 (caddr &XLINE$))
	(if (= #item3 nil)
		(setq #item3 0.0)
	)

	; �l���S��0.0�ł���ꍇ�́A�������s��Ȃ�
	(if (and (equal #item1 0.0 0.001) (equal #item2 0.0 0.001) (equal #item3 0.0 0.001))
		(progn
			(setq #ret$ &XLINE$)
			(setq #flag T)
		)
	)

	(if (= #flag nil)
		(progn
			(if (and (equal #item2 0.0 0.001) (not (equal #item3 0.0 0.001)))
				(progn
					(setq #item2 #item3)
					(setq #item3 0.0)
				)
			)

			(if (and (equal #item1 0.0 0.001) (not (equal #item2 0.0 0.001)))
				(progn
					(setq #item1 #item2)
					(setq #item2 0.0)
				)
			)

			; #item1��#item2�ő召��r
			(if (and (not (equal #item1 0.0 0.001)) (not (equal #item2 0.0 0.001)))
				(if (> #item1 #item2)
					(progn
						(setq #wk_item #item2)
						(setq #item2 #item1)
						(setq #item1 #wk_item)
					)
				)
			)

			; �召��r���#item1��#item3�ő召��r���s��
			(if (and (not (equal #item1 0.0 0.001)) (not (equal #item3 0.0 0.001)))
				(if (> #item1 #item3)
					(progn
						(setq #wk_item #item3)
						(setq #item3 #item1)
						(setq #item1 #wk_item)
					)
				)
			)

			; #item2��#item3�ő召��r���s��
			(if (and (not (equal #item2 0.0 0.001)) (not (equal #item3 0.0 0.001)))
				(if (> #item2 #item3)
					(progn
						(setq #wk_item #item3)
						(setq #item3 #item2)
						(setq #item2 #wk_item)
					)
				)
			)

			(setq #ret$ (list #item1 #item2 #item3))
		)
	)

	#ret$

);SortBrkLineDist
;-- 2012/02/15 A.Satoh Add CG�Ή� - E


;-- 2011/12/05 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_CNR_sub
; <�����T�v>  : �R�[�i�[�L���r�l�b�g�L�k����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 11/12/05 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_CNR_sub (
  &en         ; �L�k�Ώۼ���ِ}�`
	&taisyo			; �����Ώ�
	&chk				; ���͉ۃ`�F�b�N
  /
	#XLINE_W$ #XLINE_D$ #XLINE_H$ #xd_LSYM$ #xd_SYM$ #xd_TOKU$
	#pnt$ #ang #gnam #err_flag #flag #pmen2 #pt$ #base
	#p1 #p2 #p3 #p4 #p5 #p6 #w1 #w2 #d1 #d2 #a1 #a2 #h
	#org_size$ #org_width #org_depth #org_height #wdh$ #cab_size$
	#eDelBRK_W$ #eDelBRK_D$ #eDelBRK_H$ #eD #BrkW #BrkD #BrkH
	#XLINE_W #XLINE_D #XLINE_H #str_flag #expData$ #clayer
	#hinban #qry$
	#item1 #item2 #sabun
#doorID  ;-- 2012/03/23 A.Satoh Add
  )

	(setq #XLINE_W$ nil)
	(setq #XLINE_D$ nil)
	(setq #XLINE_H$ nil)

	(setq #xd_LSYM$ (CFGetXData &en "G_LSYM"))
	(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))
	(setq #xd_TOKU$ (CFGetXData &en "G_TOKU"))
	(setq #pnt$  (cdr (assoc 10 (entget &en))))      ; ����ي�_
	(setq #ang (nth 2 #xd_LSYM$))                  ; ����ٔz�u�p�x

	;2018/09/05 YM MOD
;;;  (if (equal #ang      0 0.0001) (setq #ang    0)) ;2018/03/12  ;2018/08/30 YM ����͗L�������A�O�ȊO���Ή��K�v
  (if (equal #ang      0 0.0001) (setq #ang  0.0)) ;2018/03/12  ;2018/08/30 YM ����͗L�������A�O�ȊO���Ή��K�v
	;2018/09/05 YM MOD

	(setq #hinban (nth 5 #xd_LSYM$))
;-- 2012/03/23 A.Satoh Add - S
	(setq #doorID (nth 7 #xd_LSYM$))
;-- 2012/03/23 A.Satoh Add - E
	(setq #gnam (SKGetGroupName &en))              ; ��ٰ�ߖ�
	(setq #err_flag nil)
	(setq #str_flag nil)
;-- 2012/02/17 A.Satoh Add CG�Ή� - S
	(setq CG_SizeH (nth 13 #xd_LSYM$))
;-- 2012/02/17 A.Satoh Add CG�Ή� - E

	(if (> 0 (nth 10 #xd_SYM$))
		(setq CG_BASE_UPPER T)
	)

      ; ��Ű����        w1=p1�`p2
      ; p1          p2  w2=p1�`p6
      ; +-----------+   d1=p2�`p3
      ; |           |   d2=p5�`p6
      ; |           |   a1=p3�`p4
      ; |     +-----+   a2=p4�`p5
      ; |     |p4   p3
      ; |     |
      ; +-----+
      ; p6    p5

	(setq #pmen2 (PKGetPMEN_NO &en 2))  ; PMEN2�����߂�
	(setq #pt$ (GetLWPolyLinePt #pmen2)) ; PMEN2 �O�`�̈�
	(setq #base (PKGetBaseL6 #pt$))      ; ��Ű��_�����߂�(����ق����Ȃ�)
	(setq #pt$ (GetPtSeries #base #pt$)) ; #base ��擪�Ɏ��v����
	(setq #p1 (nth 0 #pt$))
	(setq #p2 (nth 1 #pt$))
	(setq #p3 (nth 2 #pt$))
	(setq #p4 (nth 3 #pt$))
	(setq #p5 (nth 4 #pt$))
	(setq #p6 (nth 5 #pt$))

	(setq #w1 (distance #p1 #p2))
	(setq #w2 (distance #p1 #p6))
	(setq #d1 (distance #p2 #p3))
	(setq #d2 (distance #p5 #p6))
	(setq #a1 (distance #p3 #p4))
	(setq #a2 (distance #p4 #p5))
	(setq #h  (nth 5 #xd_SYM$)) ; ���@H

	(if #xd_TOKU$
		(progn
			(setq #org_width  (nth 12 #xd_TOKU$))
			(setq #org_depth  (nth 13 #xd_TOKU$))
			(setq #org_height (nth 14 #xd_TOKU$))
		)
		(progn
			(setq #org_width  #w1)
			(setq #org_depth  #w2)
			(setq #org_height #h)
		)
	)
	(setq #org_size$ (list #org_width #org_depth #org_height))

	(if (= &taisyo "B")
		(setq #cab_size$ (list 0.0 0.0 0.0 0.0 0.0))
		(progn
			; �_�C�A���O�\��
			(setq #wdh$ (list #w1 #w2 #d1 #d2 #h #org_width #org_depth #org_height))
			(setq #cab_size$ (StretchCabW_SetTOKUCNRCABSizeDlg &en #wdh$ &taisyo &chk))
			(if (= #cab_size$ nil)
				(setq #err_flag T)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
			(setq #eDelBRK_W$ (PcRemoveBreakLine &en "W")) ; W�����u���[�N����
			(setq #eDelBRK_D$ (PcRemoveBreakLine &en "D")) ; D�����u���[�N����
			(setq #eDelBRK_H$ (PcRemoveBreakLine &en "H")) ; H�����u���[�N����

			; �u���[�N���C���ʒu�����߂�
;			(if (or (not (equal (nth 0 #cab_size$) (nth 0 #wdh$) 0.0001))
;							(not (equal (nth 1 #cab_size$) (nth 1 #wdh$) 0.0001))
;							(not (equal (nth 2 #cab_size$) (nth 2 #wdh$) 0.0001))
;							(not (equal (nth 3 #cab_size$) (nth 3 #wdh$) 0.0001))
;							(not (equal (nth 4 #cab_size$) (nth 4 #wdh$) 0.0001)))
			(if (or (not (equal (nth 0 #cab_size$) 0.0 0.0001))
							(not (equal (nth 1 #cab_size$) 0.0 0.0001))
							(not (equal (nth 2 #cab_size$) 0.0 0.0001))
							(not (equal (nth 3 #cab_size$) 0.0 0.0001))
							(not (equal (nth 4 #cab_size$) 0.0 0.0001)))
				(progn
					(setq #str_flag T)

					; �w��̃V���{���}�`�����[�N��w�Ɉړ�����
					(setq #expData$ (StretchCabW_MoveCabToWorkLayer &en))

					; ���[�N��w�ȊO���\���ɂ���
					; ���݉�w���擾
					(setq #clayer (getvar "CLAYER"))

					; ������w(�Ȃ���΍쐬)�����݉�w�ɂ��Ă���ȊO���ذ�� �F�ԍ�1-255,����
					(KPSetClayerOtherFreeze "EXP_TEMP_LAYER" 1 SKW_AUTO_LAY_LINE)
				)
			)

			; �u���[�N���C���ʒu�����߂�
			; �v����
;			(if (or (not (equal (nth 0 #cab_size$) (nth 0 #wdh$) 0.0001))
;							(not (equal (nth 3 #cab_size$) (nth 3 #wdh$) 0.0001)))
			(if (or (not (equal (nth 0 #cab_size$) 0.0 0.0001))
							(not (equal (nth 3 #cab_size$) 0.0 0.0001)))
				(progn
					; �v�����u���[�N���C���ʒu�����߂�
					(setq #XLINE_W$ (StretchCabW_MakeBreakLineW #pnt$ #ang))
					(if (= (length #XLINE_W$) 2)
						(progn
							(setq #item1 (nth 0 #XLINE_W$))
							(setq #item2 (nth 1 #XLINE_W$))
							(if (> #item2 #item1)
								(setq #XLINE_W$ (list #item2 #item1))
							)
						)
					)
				)
			)

			; �c����
;			(if (or (not (equal (nth 1 #cab_size$) (nth 1 #wdh$) 0.0001))
;							(not (equal (nth 2 #cab_size$) (nth 2 #wdh$) 0.0001)))
			(if (or (not (equal (nth 1 #cab_size$) 0.0 0.0001))
							(not (equal (nth 2 #cab_size$) 0.0 0.0001)))
				(progn
					; �c�����u���[�N���C���ʒu�����߂�
					(setq #XLINE_D$ (StretchCabW_MakeBreakLineD #pnt$ #ang))
					(if (= (length #XLINE_D$) 2)
						(progn
							(setq #item1 (nth 0 #XLINE_D$))
							(setq #item2 (nth 1 #XLINE_D$))
							(if (< #item1 #item2)
								(setq #XLINE_D$ (list #item2 #item1))
							)
						)
					)
				)
			)

			; �g����
;			(if (not (equal (nth 4 #cab_size$) (nth 4 #wdh$) 0.0001))
			(if (not (equal (nth 4 #cab_size$) 0.0 0.0001))
				; �g�����u���[�N���C���ʒu�����߂�
				(setq #XLINE_H$ (StretchCabW_MakeBreakLineH #pnt$ #ang))
			)

			(if (= #str_flag T)
				(progn
					(setq #str_flag nil)

					; ���[�N��w�ֈړ������V���{�������̉�w�ɖ߂�
					(StretchCabW_MoveCabBackOrgLayer #expData$)

					; �}�ʂ̕\����Ԃ����ɖ߂�
					(SetLayer)

				  (setvar "CLAYER" #clayer) ; ���݉�w��߂�

					(SetLayer)

					(if (and (= #XLINE_W$ nil) (= #XLINE_D$ nil) (= #XLINE_H$ nil))
						(progn
							(CFAlertErr "�u���[�N���C�����ݒ肳��Ă��܂���B\n�����������𒆒f���܂��B")
							(setq #err_flag T)
						)
					)
;-- 2011/12/16 A.Satoh Add - S
					(if (= #err_flag nil)
						(progn
							(if (and (= #XLINE_W$ nil)
										(or (not (equal (nth 0 #cab_size$) 0.0 0.0001))
												(not (equal (nth 3 #cab_size$) 0.0 0.0001))))
								(CFAlertMsg "�������̃u���[�N���C�����ݒ肳��Ă��܂���B\n�E���Ԍ�����э������s�͐L�k����܂���B")
							)
							(if (and (= #XLINE_D$ nil)
										(or (not (equal (nth 1 #cab_size$) 0.0 0.0001))
												(not (equal (nth 2 #cab_size$) 0.0 0.0001))))
								(CFAlertMsg "���s�����̃u���[�N���C�����ݒ肳��Ă��܂���B\n�����Ԍ�����щE�����s�͐L�k����܂���B")
							)
							(if (and (= #XLINE_H$ nil)
										(not (equal (nth 4 #cab_size$) 0.0 0.0001)))
								(CFAlertMsg "���������̃u���[�N���C�����ݒ肳��Ă��܂���B\n�����͐L�k����܂���B")
							)
						)
					)
;-- 2011/12/16 A.Satoh Add - E
				)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
			; �L�k����
;	    ;// <W1�E�����ފԌ�>
;			(if (not (equal (nth 0 #cab_size$) #w1 0.0001)) ; W1(W)
;				(foreach #BrkW #XLINE_W$
	    ;// [A] �L�k��
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (nth 0 #cab_size$) 0.0 0.0001)) ; W1(W)
			(if (and #XLINE_W$ (not (equal (nth 0 #cab_size$) 0.0 0.0001))) ; W1(W)
;-- 2011/12/16 A.Satoh Mod - E
				(if (not (equal (nth 3 #cab_size$) 0.0 0.0001))
					(progn
						(setq #BrkW (nth 0 #XLINE_W$))
						(setq #XLINE_W (PK_MakeBreakW #pnt$ #ang #BrkW))
						(CFSetXData #XLINE_W "G_BRK" (list 1))
						(command "-group" "A" #gnam #XLINE_W "")	; �u���[�N���C���̃O���[�v��

       		  (setq CG_TOKU_BW #BrkW)
 	        	(setq CG_TOKU_BD nil)
	   	      (setq CG_TOKU_BH nil)

						; �ŐV�����g�p����
						(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

						; �L���r�l�b�g�{�̂̐L�k���s��
;          (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$)(- (nth 0 #cab_size$) #w1)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))
    	      (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$) (nth 0 #cab_size$)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

						; �ꎞ��ڰ�ײݍ폜
						(entdel #XLINE_W)

						; ���}�`�̐L�k
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
					(progn
						(setq #sabun (/ (nth 0 #cab_size$) (length #XLINE_W$)))

						(foreach #BrkW #XLINE_W$
							(setq #XLINE_W (PK_MakeBreakW #pnt$ #ang #BrkW))
							(CFSetXData #XLINE_W "G_BRK" (list 1))
							(command "-group" "A" #gnam #XLINE_W "")	; �u���[�N���C���̃O���[�v��

       			  (setq CG_TOKU_BW #BrkW)
 	        		(setq CG_TOKU_BD nil)
	   	      	(setq CG_TOKU_BH nil)

							; �ŐV�����g�p����
							(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

							; �L���r�l�b�g�{�̂̐L�k���s��
  	  	      (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

							; �ꎞ��ڰ�ײݍ폜
							(entdel #XLINE_W)

							; ���}�`�̐L�k
							(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

							(KP_TOKU_GROBAL_RESET)
						)
					)
				)
      )

;			;// <W2�������ފԌ�>
;			(if (not (equal (nth 1 #cab_size$) #w2 0.0001)) ; W2(D)
;				(foreach #BrkD #XLINE_D$
			;// [B] �L�k��
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (nth 1 #cab_size$) 0.0 0.0001)) ; W2(D)
			(if (and #XLINE_D$ (not (equal (nth 1 #cab_size$) 0.0 0.0001))) ; W2(D)
;-- 2011/12/16 A.Satoh Mod - E
				(if (not (equal (nth 2 #cab_size$) 0.0 0.0001))
					(progn
						(setq #BrkD (nth 0 #XLINE_D$))

						(setq #XLINE_D (PK_MakeBreakD #pnt$ #ang #BrkD))
						(CFSetXData #XLINE_D "G_BRK" (list 2))

						; ��ڰ�ײ̸݂�ٰ�߉�
						(command "-group" "A" #gnam #XLINE_D "")

       	  	(setq CG_TOKU_BW nil)
	 	        (setq CG_TOKU_BD #BrkD)
  	 	      (setq CG_TOKU_BH nil)

						; �ŐV�����g�p����
						(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

						; �L���r�l�b�g�{�̂̐L�k���s��
;					(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$)(- (nth 1 #cab_size$) #w2)) (nth 5 #xd_SYM$))
						(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) (nth 1 #cab_size$)) (nth 5 #xd_SYM$))

						; �ꎞ��ڰ�ײݍ폜
						(entdel #XLINE_D)

						; ���}�`�̐L�k
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
					(progn
						(setq #sabun (/ (nth 1 #cab_size$) (length #XLINE_D$)))

						(foreach #BrkD #XLINE_D$
							(setq #XLINE_D (PK_MakeBreakD #pnt$ #ang #BrkD))
							(CFSetXData #XLINE_D "G_BRK" (list 2))

							; ��ڰ�ײ̸݂�ٰ�߉�
							(command "-group" "A" #gnam #XLINE_D "")

       		  	(setq CG_TOKU_BW nil)
	 	      	  (setq CG_TOKU_BD #BrkD)
  	 	      	(setq CG_TOKU_BH nil)

							; �ŐV�����g�p����
							(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

							; �L���r�l�b�g�{�̂̐L�k���s��
							(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

							; �ꎞ��ڰ�ײݍ폜
							(entdel #XLINE_D)

							; ���}�`�̐L�k
							(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

							(KP_TOKU_GROBAL_RESET)
						)
					)
				)
			)

;			;// <D1�E�����މ��s��>
;			(if (not (equal (nth 2 #cab_size$) #d1 0.0001)) ; D1(D)
;				(foreach #BrkD #XLINE_D$
			;// [C] �L�k��
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (nth 2 #cab_size$) 0.0 0.0001)) ; D1(D)
			(if (and #XLINE_D$ (not (equal (nth 2 #cab_size$) 0.0 0.0001))) ; D1(D)
;-- 2011/12/16 A.Satoh Mod - E
				(if (not (equal (nth 1 #cab_size$) 0.0 0.0001))
					(progn
						(if (= (length #XLINE_D$) 2)
							(setq #BrkD (nth 1 #XLINE_D$))
							(setq #BrkD (nth 0 #XLINE_D$))
						)

						(setq #XLINE_D (PK_MakeBreakD #pnt$ #ang #BrkD))
						(CFSetXData #XLINE_D "G_BRK" (list 2))

						; ��ڰ�ײ̸݂�ٰ�߉�
						(command "-group" "A" #gnam #XLINE_D "")

    	   	  (setq CG_TOKU_BW nil)
 	    	    (setq CG_TOKU_BD #BrkD)
   	    	  (setq CG_TOKU_BH nil)

						; �ŐV�����g�p����
						(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

						; �L���r�l�b�g�{�̂̐L�k���s��
						(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) (nth 2 #cab_size$)) (nth 5 #xd_SYM$))

						; �ꎞ��ڰ�ײݍ폜
						(entdel #XLINE_D)

						; ���}�`�̐L�k
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
					(progn
						(setq #sabun (/ (nth 2 #cab_size$) (length #XLINE_D$)))

						(foreach #BrkD #XLINE_D$
							(setq #XLINE_D (PK_MakeBreakD #pnt$ #ang #BrkD))
							(CFSetXData #XLINE_D "G_BRK" (list 2))

							; ��ڰ�ײ̸݂�ٰ�߉�
							(command "-group" "A" #gnam #XLINE_D "")

    	  	 	  (setq CG_TOKU_BW nil)
 	    	  	  (setq CG_TOKU_BD #BrkD)
   	    	  	(setq CG_TOKU_BH nil)

							; �ŐV�����g�p����
							(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

							; �L���r�l�b�g�{�̂̐L�k���s��
							(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

							; �ꎞ��ڰ�ײݍ폜
							(entdel #XLINE_D)

							; ���}�`�̐L�k
							(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

							(KP_TOKU_GROBAL_RESET)
						)
					)
				)
			)

;			;// <D2�������މ��s��>
;			(if (not (equal (nth 3 #cab_size$) #d2 0.0001)) ; D2(W)
;				(foreach #BrkW #XLINE_W$
			;// [D] �L�k��
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (nth 3 #cab_size$) 0.0 0.0001)) ; D2(W)
			(if (and #XLINE_W$ (not (equal (nth 3 #cab_size$) 0.0 0.0001))) ; D2(W)
;-- 2011/12/16 A.Satoh Mod - E
				(if (not (equal (nth 0 #cab_size$) 0.0 0.0001))
					(progn
						(if (= (length #XLINE_W$) 2)
							(setq #BrkW (nth 1 #XLINE_W$))
							(setq #BrkW (nth 0 #XLINE_W$))
						)

						(setq #XLINE_W (PK_MakeBreakW #pnt$ #ang #BrkW))
						(CFSetXData #XLINE_W "G_BRK" (list 1))
						(command "-group" "A" #gnam #XLINE_W "")	; �u���[�N���C���̃O���[�v��

  	     	  (setq CG_TOKU_BW #BrkW)
 	  	      (setq CG_TOKU_BD nil)
   	  	    (setq CG_TOKU_BH nil)

						; �ŐV�����g�p����
						(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

						; �L���r�l�b�g�{�̂̐L�k���s��
;          (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$)(- (nth 3 #cab_size$) #d2)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))
  	        (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$) (nth 3 #cab_size$)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

						; �ꎞ��ڰ�ײݍ폜
						(entdel #XLINE_W)

						; ���}�`�̐L�k
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
					(progn
						(setq #sabun (/ (nth 3 #cab_size$) (length #XLINE_W$)))

						(foreach #BrkW #XLINE_W$
							(setq #XLINE_W (PK_MakeBreakW #pnt$ #ang #BrkW))
							(CFSetXData #XLINE_W "G_BRK" (list 1))
							(command "-group" "A" #gnam #XLINE_W "")	; �u���[�N���C���̃O���[�v��

  	  	   	  (setq CG_TOKU_BW #BrkW)
 	  	  	    (setq CG_TOKU_BD nil)
   	  	  	  (setq CG_TOKU_BH nil)

							; �ŐV�����g�p����
							(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

							; �L���r�l�b�g�{�̂̐L�k���s��
  		        (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

							; �ꎞ��ڰ�ײݍ폜
							(entdel #XLINE_W)

							; ���}�`�̐L�k
							(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

							(KP_TOKU_GROBAL_RESET)
						)
					)
        )
      )

			;// <H����>
;			(if (not (equal (nth 4 #cab_size$) #h 0.0001)) ; H
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (nth 4 #cab_size$) 0.0 0.0001)) ; H
			(if (and #XLINE_H$ (not (equal (nth 4 #cab_size$) 0.0 0.0001))) ; H
;-- 2011/12/16 A.Satoh Mod - E
				(progn
;-- 2012/02/20 A.Satoh Add - S
					(setq CG_SizeH (+ CG_SizeH (nth 4 #cab_size$)))
;-- 2012/02/20 A.Satoh Add - E
					(setq #sabun (/ (nth 4 #cab_size$) (length #XLINE_H$)))
					(foreach #BrkH #XLINE_H$
;-- 2012/01/25 A.Satoh Add - S
						(if CG_BASE_UPPER
							(setq #BrkH (- (caddr #pnt$) #BrkH))
						)
;-- 2012/01/25 A.Satoh Add - E
						(setq #XLINE_H (PK_MakeBreakH #pnt$ #BrkH))
						(CFSetXData #XLINE_H "G_BRK" (list 3))

						; ��ڰ�ײ̸݂�ٰ�߉�
						(command "-group" "A" #gnam #XLINE_H "")

	       	  (setq CG_TOKU_BW nil)
 		        (setq CG_TOKU_BD nil)
   		      (setq CG_TOKU_BH #BrkH)

						; �ŐV�����g�p����
						(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

						; �L���r�l�b�g�{�̂̐L�k���s��
						(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (nth 4 #xd_SYM$) (+ (nth 5 #xd_SYM$) #sabun))

;-- 2012/02/22 A.Satoh Add : �i�Ԑ}�`DB�̓o�^H���@�l���X�V���� - S
	    		  (CFSetXData &en "G_LSYM"
	  	    	  (CFModList #xd_LSYM$
		    	  	  (list (list 13 CG_SizeH))
    	    		)
      			)
;-- 2012/02/22 A.Satoh Add : �i�Ԑ}�`DB�̓o�^H���@�l���X�V���� - E

						; �ꎞ��ڰ�ײݍ폜
						(entdel #XLINE_H)

						; ���}�`�̐L�k
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
				)
			)

			; ������ڰ�ײݕ���
			; W����
			(foreach #eD #eDelBRK_W$ (if (= (entget #eD) nil) (entdel #eD)))
			; D����
			(foreach #eD #eDelBRK_D$ (if (= (entget #eD) nil) (entdel #eD)))
			; H����
			(foreach #eD #eDelBRK_H$ (if (= (entget #eD) nil) (entdel #eD)))

;-- 2012/03/23 A.Satoh Add - S
			(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
			(CFSetXData #sym "G_LSYM" (CFModList #xd_LSYM$ (list (list 7 #doorID))))
;-- 2012/03/23 A.Satoh Add - E

			(setq #qry$
				(CFGetDBSQLRec CG_DBSESSION "�����K�i�i"
					(list
						(list "�i�Ԗ���" #hinban 'STR)
					)
				)
			)
			(if (= #qry$ nil)
				(progn
					; �w��̃V���{���ɑ΂��ē����L���r����ݒ肷��
					(if (= nil (tblsearch "APPID" "G_TOKU")) (regapp "G_TOKU"))
					(setq #flag (StretchCabW_InputTokuData &en #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ &chk #cab_size$ T))
					(if (= #flag nil)
						(command "_undo" "b")
					)
				)
				(progn
					(princ (strcat "\n�������������K�i�i �i�Ԗ��� = " #hinban))
;-- 2012/02/15 A.Satoh Add CG�Ή� - S
					(if (= nil (tblsearch "APPID" "G_REG")) (regapp "G_REG"))
					(InputGRegData &en #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ &chk #cab_size$ T)
;-- 2012/02/15 A.Satoh Add CG�Ή� - E
				)
			)
		)
	)

	(setq CG_BASE_UPPER nil)
;-- 2012/02/17 A.Satoh Add CG�Ή� - S
	(setq CG_SizeH nil)
;-- 2012/02/17 A.Satoh Add CG�Ή� - E
  (princ)

) ;StretchCabW_CNR_sub


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_SetTOKUCNRCABSizeDlg
; <�����T�v>  : �R�[�i�[�L���r�p�����L���r�T�C�Y�ύX��ʏ������s��
; <�߂�l>    : �T�C�Y���X�g:(�E���Ԍ�,�����Ԍ�,�E�����s,�������s,����)
;             : nil �L�����Z������
; <�쐬>      : 11/12/05 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_SetTOKUCNRCABSizeDlg (
	&en		; �V���{���}�`��
	&wdh$	; �T�C�Y��񃊃X�g
	&taisyo	; �����Ώ�
	&chk
  /
	#dcl_id #x #y #next #ret$
	#W_f #D_f #H_f
  )

	;***********************************************************************
	; �n�j�{�^����������
	; �߂�l:�T�C�Y�ύX��񃊃X�g (�E���Ԍ� �����Ԍ� �E�����s �������s ����)
	;***********************************************************************
	(defun ##SetTOKUCNRCABSize_CallBack (
		/
		#err_flag #width1 #width2 #depth1 #depth2 #height #data$
		)

    (setq #err_flag nil)

    ; [A]�L�k�ʃ`�F�b�N
		(setq #width1 (get_tile "edtWT_Width_A"))
		(if (or (= #width1 "") (= #width1 nil))
			(progn
				(set_tile "error" "[A] �L�k�ʂ����͂���Ă��܂���")
				(mode_tile "edtWT_Width_A" 2)
				(setq #err_flag T)
			)
;|
			(if (or (= (type (read #width1)) 'INT) (= (type (read #width1)) 'REAL))
				(if (or (> -1000 (read #width1)) (< 1000 (read #width1)))
					(progn
						(set_tile "error" "�E���Ԍ��� 99999 �ȉ��̐��l����͂��ĉ�����")
						(mode_tile "edtWT_Width_A" 2)
						(setq #err_flag T)
					)
					(if (> (read #width1) 99999)
						(progn
							(set_tile "error" "�E���Ԍ��� 99999 �ȉ��̐��l����͂��ĉ�����")
							(mode_tile "edtWT_Width_A" 2)
							(setq #err_flag T)
						)
					)
				)
				(progn
					(set_tile "error" "�E���Ԍ��� 99999 �ȉ��̐��l����͂��ĉ�����")
					(mode_tile "edtWT_Width_A" 2)
					(setq #err_flag T)
				)
			)
|;
		)

		; [B] �L�k�ʃ`�F�b�N
		(if (= #err_flag nil)
			(progn
				(setq #width2 (get_tile "edtWT_Width_B"))
				(if (or (= #width2 "") (= #width2 nil))
					(progn
						(set_tile "error" "[B] �L�k�ʂ����͂���Ă��܂���")
						(mode_tile "edtWT_Width_B" 2)
						(setq #err_flag T)
					)
;|
					(if (or (= (type (read #width2)) 'INT) (= (type (read #width2)) 'REAL))
						(if (> 0 (read #width2))
							(progn
								(set_tile "error" "�����Ԍ��� 99999 �ȉ��̐��l����͂��ĉ�����")
								(mode_tile "edtWT_Width_B" 2)
								(setq #err_flag T)
							)
							(if (> (read #width2) 99999)
								(progn
									(set_tile "error" "�����Ԍ��� 99999 �ȉ��̐��l����͂��ĉ�����")
									(mode_tile "edtWT_Width_B" 2)
									(setq #err_flag T)
								)
							)
						)
						(progn
							(set_tile "error" "�����Ԍ��� 99999 �ȉ��̐��l����͂��ĉ�����")
							(mode_tile "edtWT_Width_B" 2)
							(setq #err_flag T)
						)
					)
|;
				)
			)
		)

		; [C] �L�k�ʃ`�F�b�N
		(if (= #err_flag nil)
			(progn
				(setq #depth1 (get_tile "edtWT_Depth_C"))
				(if (or (= #depth1 "") (= #depth1 nil))
					(progn
						(set_tile "error" "[C] �L�k�ʂ����͂���Ă��܂���")
						(mode_tile "edtWT_Depth_C" 2)
						(setq #err_flag T)
					)
;|
					(setq #depth1 "")
					(if (or (= (type (read #depth1)) 'INT) (= (type (read #depth1)) 'REAL))
						(if (> 0 (read #depth1))
							(progn
								(set_tile "error" "�E�����s�� 99999 �ȉ��̐��l����͂��ĉ�����")
								(mode_tile "edtWT_Depth_C" 2)
								(setq #err_flag T)
							)
							(if (> (read #depth1) 99999)
								(progn
									(set_tile "error" "�E�����s�� 99999 �ȉ��̐��l����͂��ĉ�����")
									(mode_tile "edtWT_Depth_C" 2)
									(setq #err_flag T)
								)
							)
						)
						(progn
							(set_tile "error" "�E�����s�� 99999 �ȉ��̐��l����͂��ĉ�����")
							(mode_tile "edtWT_Depth_C" 2)
							(setq #err_flag T)
						)
					)
|;
				)
			)
		)

		; [D] �L�k�ʃ`�F�b�N
		(if (= #err_flag nil)
			(progn
				(setq #depth2 (get_tile "edtWT_Depth_D"))
				(if (or (= #depth2 "") (= #depth2 nil))
					(progn
						(set_tile "error" "[C] �L�k�ʂ����͂���Ă��܂���")
						(mode_tile "edtWT_Depth_D" 2)
						(setq #err_flag T)
					)
;|
					(setq #depth2 "")
					(if (or (= (type (read #depth2)) 'INT) (= (type (read #depth2)) 'REAL))
						(if (> 0 (read #depth2))
							(progn
								(set_tile "error" "���s�� 99999 �ȉ��̐��l����͂��ĉ�����")
								(mode_tile "edtWT_Depth_D" 2)
								(setq #err_flag T)
							)
							(if (> (read #depth2) 99999)
								(progn
									(set_tile "error" "���s�� 99999 �ȉ��̐��l����͂��ĉ�����")
									(mode_tile "edtWT_Depth_D" 2)
									(setq #err_flag T)
								)
							)
						)
						(progn
							(set_tile "error" "���s�� 99999 �ȉ��̐��l����͂��ĉ�����")
							(mode_tile "edtWT_Depth_D" 2)
							(setq #err_flag T)
						)
					)
|;
				)
			)
		)

		; ���� �L�k�ʃ`�F�b�N
		(if (= #err_flag nil)
			(progn
				(setq #height (get_tile "edtWT_Height"))
				(if (or (= #height "") (= #height nil))
					(progn
						(set_tile "error" "���� �L�k�ʂ����͂���Ă��܂���")
						(mode_tile "edtWT_Height" 2)
						(setq #err_flag T)
					)
;|
					(setq #height "")
					(if (or (= (type (read #height)) 'INT) (= (type (read #height)) 'REAL))
						(if (> 0 (read #height))
							(progn
								(set_tile "error" "������ 99999 �ȉ��̐��l����͂��ĉ�����")
								(mode_tile "edtWT_Height" 2)
								(setq #err_flag T)
							)
							(if (> (read #height) 99999)
								(progn
									(set_tile "error" "������ 99999 �ȉ��̐��l����͂��ĉ�����")
									(mode_tile "edtWT_Height" 2)
									(setq #err_flag T)
								)
							)
						)
						(progn
							(set_tile "error" "������ 99999 �ȉ��̐��l����͂��ĉ�����")
							(mode_tile "edtWT_Height" 2)
							(setq #err_flag T)
						)
					)
|;
				)
			)
		)

		; �T�C�Y�ύX��񃊃X�g�̍쐬
		(if (= #err_flag nil)
			(progn
				(setq #data$ (list (atof #width1) (atof #width2) (atof #depth1) (atof #depth2) (atof #height)))
				(done_dialog)
				#data$
			)
		)

	)
	;***********************************************************************

	; �����ꊇ�ύX��ʕ\��
	(setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kcmain.dcl")))
	(if (not (new_dialog "SetTOKUCNRCABSizeDlg" #dcl_id)) (exit))

	; �����\������
	(set_tile "txt2"
		(strcat "�E���Ԍ�=" (rtos (nth 0 &wdh$)) " , �����Ԍ�=" (rtos (nth 1 &wdh$)))
	)
	(set_tile "txt3"
		(strcat "�E�����s=" (rtos (nth 2 &wdh$)) " , �������s=" (rtos (nth 3 &wdh$)))
	)
	(set_tile "txt4"
		(strcat "����=" (rtos (nth 4 &wdh$)))
	)

;	(set_tile "edtWT_Width_A" (rtos (nth 0 &wdh$)))
;	(set_tile "edtWT_Width_B" (rtos (nth 1 &wdh$)))
;	(set_tile "edtWT_Depth_C" (rtos (nth 2 &wdh$)))
;	(set_tile "edtWT_Depth_D" (rtos (nth 3 &wdh$)))
;	(set_tile "edtWT_Height" (rtos (nth 4 &wdh$)))
	(set_tile "edtWT_Width_A" "0")
	(set_tile "edtWT_Width_B" "0")
	(set_tile "edtWT_Depth_C" "0")
	(set_tile "edtWT_Depth_D" "0")
	(set_tile "edtWT_Height"  "0")

	(if (= &taisyo "A")
		(progn
			(setq #W_f T)
			(setq #D_f T)
			(setq #H_f T)
		)
		(if (= (strlen &taisyo) 4)
			(progn
				(if (= (substr &taisyo 2 1) "W")
					(setq #W_f T)
					(setq #W_f nil)
				)
				(if (= (substr &taisyo 3 1) "D")
					(setq #D_f T)
					(setq #D_f nil)
				)
				(if (= (substr &taisyo 4 1) "H")
					(setq #H_f T)
					(setq #H_f nil)
				)
			)
			(progn
				(setq #W_f T)
				(setq #D_f T)
				(setq #H_f T)
			)
		)
	)

	(if (= (nth 0 &chk) nil)
		(setq #W_f nil)
	)
	(if (= (nth 1 &chk) nil)
		(setq #D_f nil)
	)
	(if (= (nth 2 &chk) nil)
		(setq #H_f nil)
	)

	(if (= #W_f nil)
		(progn
			(mode_tile "edtWT_Width_A" 1)
			(mode_tile "edtWT_Depth_D" 1)
		)
	)
	(if (= #D_f nil)
		(progn
			(mode_tile "edtWT_Width_B" 1)
			(mode_tile "edtWT_Depth_C" 1)
		)
	)
	(if (= #H_f nil)
		(mode_tile "edtWT_Height" 1)
	)

	(if (not (equal (nth 0 &wdh$) (nth 5 &wdh$) 0.0001))
		(progn
			(mode_tile "edtWT_Width_A" 1)
			(mode_tile "edtWT_Depth_D" 1)
		)
	)
	(if (not (equal (nth 1 &wdh$) (nth 6 &wdh$) 0.0001))
		(progn
			(mode_tile "edtWT_Width_B" 1)
			(mode_tile "edtWT_Depth_C" 1)
		)
	)
	(if (not (equal (nth 4 &wdh$) (nth 7 &wdh$) 0.0001))
		(mode_tile "edtWT_Height" 1)
	)

	; �X���C�h
	(setq #x (dimx_tile "slide1")
				#y (dimy_tile "slide1")
	)
	(start_image "slide1")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\CNR"))
	(end_image)

	(setq #next 99)
	(while (and (/= 1 #next) (/= 0 #next))
		; �{�^����������
  	(action_tile "accept" "(setq #ret$ (##SetTOKUCNRCABSize_CallBack))")
  	(action_tile "cancel" "(setq #ret$ nil) (done_dialog 0)")

  	(setq #next (start_dialog))
	)

  (unload_dialog #dcl_id)

	#ret$

);StretchCabW_SetTOKUCNRCABSizeDlg


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_sub
; <�����T�v>  : �ʏ�L���r�l�b�g�̐L�k����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 11/12/05 A.Satoh
; <���l>      : �R�[�i�[�L���r�ȊO�̃L���r�l�b�g��Ώ�
;*************************************************************************>MOH<
(defun StretchCabW_sub (
  &en         ; �L�k�Ώۼ���ِ}�`
	&taisyo			; �����Ώ�
	&chk				; ���͉ۃ`�F�b�N
  /
	#sym #err_flag #xd_LSYM$ #xd_SYM$ #xd_TOKU$ #pt #ang #gnam
	#width #depth #height #org_width #org_depth #org_height #org_size$
	#wdh$ #cab_size$ #XLINE_W$ #BrkW #XLINE_D$ #BrkD #XLINE_H$ #BrkH #brk$
	#eD #eDelBRK_W$ #XLINE_W #eDelBRK_D$ #XLINE_D #eDelBRK_H$ #XLINE_H
	#flag #str_flag #expData$ #clayer #sabun
	#hinban #qry$
#doorID  ;-- 2012/03/23 A.Satoh Add
 )
	(setq CG_ORG_Layer$ nil);2017/04/17 YM ADD

	(setq #sym &en)
	(setq #str_flag nil)
	(setq #err_flag nil)
	(setq #XLINE_W$ nil)
	(setq #XLINE_D$ nil)
	(setq #XLINE_H$ nil)

	(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
	(setq #xd_SYM$  (CFGetXData #sym "G_SYM" ))
	(setq #xd_TOKU$ (CFGetXData #sym "G_TOKU"))
	(setq #pt  (cdr (assoc 10 (entget #sym))))      ; ����ي�_
	(setq #ang (nth 2 #xd_LSYM$))                  ; ����ٔz�u�p�x

	;2018/09/05 YM MOD
;;;  (if (equal #ang      0 0.0001) (setq #ang    0)) ;2018/03/12  ;2018/08/30 YM ����͗L�������A�O�ȊO���Ή��K�v
  (if (equal #ang      0 0.0001) (setq #ang  0.0)) ;2018/03/12  ;2018/08/30 YM ����͗L�������A�O�ȊO���Ή��K�v
	;2018/09/05 YM MOD

	(setq #gnam (SKGetGroupName #sym))              ; ��ٰ�ߖ�
	(setq #hinban (nth 5 #xd_LSYM$))
;-- 2012/03/23 A.Satoh Add - S
	(setq #doorID (nth 7 #xd_LSYM$))
;-- 2012/03/23 A.Satoh Add - E
;-- 2012/02/17 A.Satoh Add CG�Ή� - S
	(setq CG_SizeH (nth 13 #xd_LSYM$))		; �i�Ԑ}�`DB�̓o�^�g���@�l
;-- 2012/02/17 A.Satoh Add CG�Ή� - E

	; ���_�t���O��L���ɐݒ�
	(if (> 0 (nth 10 #xd_SYM$))
		(setq CG_BASE_UPPER T)
	)

	(setq #width  (nth 3 #xd_SYM$))
	(setq #depth  (nth 4 #xd_SYM$))
	(setq #height (nth 5 #xd_SYM$))

	(if #xd_TOKU$
		(progn
			(setq #org_width  (nth 12 #xd_TOKU$))
			(setq #org_depth  (nth 13 #xd_TOKU$))
			(setq #org_height (nth 14 #xd_TOKU$))
		)
		(progn
			(setq #org_width  #width)
			(setq #org_depth  #depth)
			(setq #org_height #height)
		)
	)
	(setq #org_size$ (list #org_width #org_depth #org_height))

	(if (= &taisyo "B")
		(setq #cab_size$ (list #width #depth #height))
		(progn
			; �_�C�A���O�\��
			(setq #wdh$ (list #width #depth #height #org_width #org_depth #org_height))
			(setq #cab_size$ (StretchCabW_SetTOKUCABSizeDlg #sym #wdh$ &taisyo &chk))
			(if (= #cab_size$ nil)
				(setq #err_flag T)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
			(setq #eDelBRK_W$ (PcRemoveBreakLine #sym "W")) ; W�����u���[�N����
			(setq #eDelBRK_D$ (PcRemoveBreakLine #sym "D")) ; D�����u���[�N����
			(setq #eDelBRK_H$ (PcRemoveBreakLine #sym "H")) ; H�����u���[�N����

			; �u���[�N���C���ʒu�����߂�
			(if (or (not (equal (car #cab_size$) (nth 3 #xd_SYM$) 0.0001))
							(not (equal (cadr #cab_size$) (nth 4 #xd_SYM$) 0.0001))
							(not (equal (caddr #cab_size$) (nth 5 #xd_SYM$) 0.0001)))
				(progn
					(setq #str_flag T)

					; �w��̃V���{���}�`�����[�N��w�Ɉړ�����
					(setq #expData$ (StretchCabW_MoveCabToWorkLayer #sym))
					(setq CG_ORG_Layer$ #expData$);���̉�w�i�[ 2017/04/17 YM ADD

					; ���[�N��w�ȊO���\���ɂ���
					; ���݉�w���擾
					(setq #clayer (getvar "CLAYER"))

					; ������w(�Ȃ���΍쐬)�����݉�w�ɂ��Ă���ȊO���ذ�� �F�ԍ�1-255,����
					(KPSetClayerOtherFreeze "EXP_TEMP_LAYER" 1 SKW_AUTO_LAY_LINE)

				)
			)

			; �v����
			(if (not (equal (car #cab_size$) (nth 3 #xd_SYM$) 0.0001))
				; �v�����u���[�N���C���ʒu�����߂�
				(setq #XLINE_W$ (StretchCabW_MakeBreakLineW #pt #ang))
;				(progn
;					;;;;; �����p�b�菈��
;					;******************
;					(setq #BrkW (fix (* (fix (nth 3 #xd_SYM$)) 0.5)))
;					(setq #XLINE_W$ (list #BrkW))
;					;******************
;				)
			)

			; �c����
			(if (not (equal (cadr #cab_size$) (nth 4 #xd_SYM$) 0.0001))
				; �c�����u���[�N���C���ʒu�����߂�
				(setq #XLINE_D$ (StretchCabW_MakeBreakLineD #pt #ang))
;				(progn
;					;;;;; �����p�b�菈��
;					;******************
;					(setq #BrkD (fix (* (fix (nth 4 #xd_SYM$)) 0.5)))
;					(setq #XLINE_D$ (list #BrkD))
;					;******************
;				)
			)

			; �g����
			(if (not (equal (caddr #cab_size$) (nth 5 #xd_SYM$) 0.0001))
				; �g�����u���[�N���C���ʒu�����߂�
				(setq #XLINE_H$ (StretchCabW_MakeBreakLineH #pt #ang))
;				(progn
;					;;;;; �����p�b�菈��
;					;******************
;					(setq #BrkH (fix (* (fix (nth 5 #xd_SYM$)) 0.5)))
;					(setq #XLINE_H$ (list #BrkH))
;					;******************
;				)
			)

			(if (= #str_flag T)
				(progn
					(setq #str_flag nil)

					; ���[�N��w�ֈړ������V���{�������̉�w�ɖ߂�
					(StretchCabW_MoveCabBackOrgLayer #expData$)

					; �}�ʂ̕\����Ԃ����ɖ߂�
					(SetLayer)

				  ; ���݉�w��߂�
				  (setvar "CLAYER" #clayer)
					(SetLayer)

					(if (and (= #XLINE_W$ nil) (= #XLINE_D$ nil) (= #XLINE_H$ nil))
						(progn
							(CFAlertErr "�u���[�N���C�����ݒ肳��Ă��܂���B\n�����������𒆒f���܂��B")
							(setq #err_flag T)
						)
					)
;-- 2011/12/16 A.Satoh Add - S
					(if (= #err_flag nil)
						(progn
							(if (and (= #XLINE_W$ nil)
										(not (equal (car #cab_size$) (nth 3 #xd_SYM$) 0.0001)))
								(CFAlertMsg "�������̃u���[�N���C�����ݒ肳��Ă��܂���B\n���͐L�k����܂���B")
							)
							(if (and (= #XLINE_D$ nil)
										(not (equal (cadr #cab_size$) (nth 4 #xd_SYM$) 0.0001)))
								(CFAlertMsg "���s�����̃u���[�N���C�����ݒ肳��Ă��܂���B\n���s�͐L�k����܂���B")
							)
							(if (and (= #XLINE_H$ nil)
										(not (equal (caddr #cab_size$) (nth 5 #xd_SYM$) 0.0001)))
								(CFAlertMsg "���������̃u���[�N���C�����ݒ肳��Ă��܂���B\n�����͐L�k����܂���B")
							)
						)
					)
;-- 2011/12/16 A.Satoh Add - E
				)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (car #cab_size$) (nth 3 #xd_SYM$) 0.0001))
			(if (and #XLINE_W$ (not (equal (car #cab_size$) (nth 3 #xd_SYM$) 0.0001)))
;-- 2011/12/16 A.Satoh Mod - S
				(progn
					(setq #sabun (/ (- (car #cab_size$) (nth 3 #xd_SYM$)) (length #XLINE_W$)))
					(foreach #BrkW #XLINE_W$
						(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
						(CFSetXData #XLINE_W "G_BRK" (list 1))
						(command "-group" "A" #gnam #XLINE_W "")	; �u���[�N���C���̃O���[�v��

       		  (setq CG_TOKU_BW #BrkW)
 	        	(setq CG_TOKU_BD nil)
	   	      (setq CG_TOKU_BH nil)

						; �L���r�l�b�g�{�̂̐L�k���s��
						;(SKY_Stretch_Parts #sym (car #cab_size$) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))
						(setq #xd_SYM$  (CFGetXData #sym "G_SYM" ))
						(SKY_Stretch_Parts #sym (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

						; �ꎞ��ڰ�ײݍ폜
						(entdel #XLINE_W)

						; ���}�`�̐L�k
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #sym) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
				)
			)

;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (cadr #cab_size$) (nth 4 #xd_SYM$) 0.0001))
			(if (and #XLINE_D$ (not (equal (cadr #cab_size$) (nth 4 #xd_SYM$) 0.0001)))
;-- 2011/12/16 A.Satoh Mod - E
				(progn
					(setq #sabun (/ (- (cadr #cab_size$) (nth 4 #xd_SYM$)) (length #XLINE_D$)))
					(foreach #BrkD #XLINE_D$
						(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
						(CFSetXData #XLINE_D "G_BRK" (list 2))

						; ��ڰ�ײ̸݂�ٰ�߉�
						(command "-group" "A" #gnam #XLINE_D "")

       	  	(setq CG_TOKU_BW nil)
	 	        (setq CG_TOKU_BD #BrkD)
  	 	      (setq CG_TOKU_BH nil)

						; �L���r�l�b�g�{�̂̐L�k���s��
						;(SKY_Stretch_Parts #sym (car #cab_size$) (cadr #cab_size$) (nth 5 #xd_SYM$))
						(setq #xd_SYM$  (CFGetXData #sym "G_SYM" ))
						(SKY_Stretch_Parts #sym (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

						; �ꎞ��ڰ�ײݍ폜
						(entdel #XLINE_D)

						; ���}�`�̐L�k
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #sym) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
				)
			)

;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (caddr #cab_size$) (nth 5 #xd_SYM$) 0.0001))
			(if (and #XLINE_H$ (not (equal (caddr #cab_size$) (nth 5 #xd_SYM$) 0.0001)))
;-- 2011/12/16 A.Satoh Mod - E
				(progn
					(setq #sabun (/ (- (caddr #cab_size$) (nth 5 #xd_SYM$)) (length #XLINE_H$)))
					(foreach #BrkH #XLINE_H$
;-- 2011/12/13 A.Satoh Add - S
						(if CG_BASE_UPPER
							(setq #BrkH (- (caddr #pt) #BrkH))
						)
;-- 2011/12/13 A.Satoh Add - E
						(setq #XLINE_H (PK_MakeBreakH #pt #BrkH))
						(CFSetXData #XLINE_H "G_BRK" (list 3))

						; ��ڰ�ײ̸݂�ٰ�߉�
						(command "-group" "A" #gnam #XLINE_H "")

       	  	(setq CG_TOKU_BW nil)
	 	        (setq CG_TOKU_BD nil)
  	 	      (setq CG_TOKU_BH #BrkH)

						; �L���r�l�b�g�{�̂̐L�k���s��
						(setq #xd_SYM$  (CFGetXData #sym "G_SYM" ))
						;(SKY_Stretch_Parts #sym (car #cab_size$) (cadr #cab_size$) (caddr #cab_size$))
						(SKY_Stretch_Parts #sym (nth 3 #xd_SYM$) (nth 4 #xd_SYM$) (+ (nth 5 #xd_SYM$) #sabun))

;-- 2012/03/23 A.Satoh Add : �i�Ԑ}�`DB�̓o�^H���@�l���X�V���� - S
	    		  (CFSetXData &en "G_LSYM"
	  	    	  (CFModList #xd_LSYM$
		    	  	  (list (list 13 CG_SizeH))
    	    		)
      			)
;-- 2012/03/23 A.Satoh Add : �i�Ԑ}�`DB�̓o�^H���@�l���X�V���� - E

						; �ꎞ��ڰ�ײݍ폜
						(entdel #XLINE_H)

						; ���}�`�̐L�k
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #sym) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
				)
			)

			; ������ڰ�ײݕ���
			; W����
			(foreach #eD #eDelBRK_W$ (if (= (entget #eD) nil) (entdel #eD)))
			; D����
			(foreach #eD #eDelBRK_D$ (if (= (entget #eD) nil) (entdel #eD)))
			; H����
			(foreach #eD #eDelBRK_H$ (if (= (entget #eD) nil) (entdel #eD)))

;-- 2012/03/23 A.Satoh Add - S
			(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
			(CFSetXData #sym "G_LSYM" (CFModList #xd_LSYM$ (list (list 7 #doorID))))
;-- 2012/03/23 A.Satoh Add - E

			(setq #qry$
				(CFGetDBSQLRec CG_DBSESSION "�����K�i�i"
					(list
						(list "�i�Ԗ���" #hinban 'STR)
					)
				)
			)
			(if (= #qry$ nil)
				(progn
					; �w��̃V���{���ɑ΂��ē����L���r����ݒ肷��
					(if (= nil (tblsearch "APPID" "G_TOKU")) (regapp "G_TOKU"))
					(setq #flag (StretchCabW_InputTokuData #sym #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ &chk nil nil))
					(if (= #flag nil)
						(command "_undo" "b")
					)
				)
				(progn
					(princ (strcat "\n�������������K�i�i �i�Ԗ��� = " #hinban))
;-- 2012/02/15 A.Satoh Mod CG�Ή� - S
					(if (= nil (tblsearch "APPID" "G_REG")) (regapp "G_REG"))
					(InputGRegData &en #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ &chk nil nil)
;-- 2012/02/15 A.Satoh Mod CG�Ή� - E
				)
			)
		)
	)

;-- 2012/02/17 A.Satoh Add CG�Ή� - S
	(setq CG_SizeH nil)
	(setq CG_BASE_UPPER nil)
;-- 2012/02/17 A.Satoh Add CG�Ή� - E
	(princ)

) ;StretchCabW_sub


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_SetTOKUCABSizeDlg
; <�����T�v>  : �ʏ�L���r�p�����L���r�T�C�Y�ύX��ʏ������s��
; <�߂�l>    : �T�C�Y���X�g:(�Ԍ�,���s,����)
;             : nil �L�����Z������
; <�쐬>      : 11/12/05 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_SetTOKUCABSizeDlg (
	&en		; �ΏۃV���{���}�`��
	&wdh$	; �T�C�Y��񃊃X�g
	&taisyo	; �����Ώ�
	&chk				; ���͉ۃ`�F�b�N
  /
	#dcl_id #next #ret$
	#W_f #D_f #H_f
  )

	;***********************************************************************
	; �n�j�{�^����������
	; �߂�l:�T�C�Y�ύX��񃊃X�g (�� ���s ����)
	;***********************************************************************
	(defun ##SetTOKUCNRCABSize_CallBack (
		/
		#err_flg #width #depth #height #data$
		#wk_height  ;-- 2012/02/20 A.Satoh Add
		)

    (setq #err_flg nil)

    ; ���`�F�b�N
		(setq #width (get_tile "edtWT_Width"))
		(if (or (= #width "") (= #width nil))
			(setq #width "")
			(if (or (= (type (read #width)) 'INT) (= (type (read #width)) 'REAL))
				(if (> 0 (read #width))
					(progn
						(set_tile "error" "�Ђ� 99999 �ȉ��̐��l����͂��ĉ�����")
						(mode_tile "edtWT_Width" 2)
						(setq #err_flg T)
					)
					(if (>= (read #width) 99999)
						(progn
							(set_tile "error" "�Ђ� 99999 �ȉ��̐��l����͂��ĉ�����")
							(mode_tile "edtWT_Width" 2)
							(setq #err_flg T)
						)
					)
				)
				(progn
					(set_tile "error" "�Ђ� 99999 �ȉ��̐��l����͂��ĉ�����")
					(mode_tile "edtWT_Width" 2)
					(setq #err_flg T)
				)
			)
		)

		; ���s�`�F�b�N
		(if (= #err_flg nil)
			(progn
				(setq #depth (get_tile "edtWT_Depth"))
				(if (or (= #depth "") (= #depth nil))
					(setq #depth "")
					(if (or (= (type (read #depth)) 'INT) (= (type (read #depth)) 'REAL))
						(if (> 0 (read #depth))
							(progn
;-- 2012/01/24 A.Satoh Mod - S
;;;;;								(set_tile "error" "���s�� 1000 �����̐��l����͂��ĉ�����")
								(set_tile "error" "���s�� 0 �ȏ�̐��l����͂��ĉ�����")
;-- 2012/01/24 A.Satoh Mod - E
								(mode_tile "edtWT_Depth" 2)
								(setq #err_flg T)
							)
;-- 2012/01/24 A.Satoh Del - S
;;;;;							(if (>= (read #depth) 1000)
;;;;;								(progn
;;;;;									(set_tile "error" "���s�� 1000 �����̐��l����͂��ĉ�����")
;;;;;									(mode_tile "edtWT_Depth" 2)
;;;;;									(setq #err_flg T)
;;;;;								)
;;;;;							)
;-- 2012/01/24 A.Satoh Del - E
						)
						(progn
;-- 2012/01/24 A.Satoh Mod - S
;;;;;							(set_tile "error" "���s�� 1000 �����̐��l����͂��ĉ�����")
							(set_tile "error" "���s�� 0 �ȏ�̐��l����͂��ĉ�����")
;-- 2012/01/24 A.Satoh Mod - E
							(mode_tile "edtWT_Depth" 2)
							(setq #err_flg T)
						)
					)
				)
			)
		)

		; �����`�F�b�N
		(if (= #err_flg nil)
			(progn
				(setq #height (get_tile "edtWT_Height"))
				(if (or (= #height "") (= #height nil))
					(setq #height "")
					(if (or (= (type (read #height)) 'INT) (= (type (read #height)) 'REAL))
						(if (> 0 (read #height))
							(progn
								(set_tile "error" "������ 99999 �ȉ��̐��l����͂��ĉ�����")
								(mode_tile "edtWT_Height" 2)
								(setq #err_flg T)
							)
							(if (>= (read #height) 99999)
								(progn
									(set_tile "error" "������ 99999 �ȉ��̐��l����͂��ĉ�����")
									(mode_tile "edtWT_Height" 2)
									(setq #err_flg T)
								)
							)
						)
						(progn
							(set_tile "error" "������ 99999 �ȉ��̐��l����͂��ĉ�����")
							(mode_tile "edtWT_Height" 2)
							(setq #err_flg T)
						)
					)
				)
			)
		)

		; �T�C�Y�ύX��񃊃X�g�̍쐬
		(if (= #err_flg nil)
			(progn
;-- 2012/02/20 A.Satoh Mod - S
;;;;;				(setq #data$ (list (atof #width) (atof #depth) (atof #height)))
				(setq #wk_height (- (atof #height) CG_SizeH))
				(setq CG_SizeH (atof #height))
				(setq #height (+ (nth 2 &wdh$) #wk_height))
				(setq #data$ (list (atof #width) (atof #depth) #height))
;-- 2012/02/20 A.Satoh Mod - E
				(done_dialog)
				#data$
			)
		)
	)
	;***********************************************************************

;|
	(setq #seigyo$ (StretchCabW_CheckTokuSeigyo &en))
	(setq #sei_W (car   #seigyo$))
	(setq #sei_D (cadr  #seigyo$))
	(setq #sei_H (caddr #seigyo$))
|;

	; �����L���r�T�C�Y�ύX��ʕ\��
	(setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kcmain.dcl")))
	(if (not (new_dialog "SetTOKUCABSizeDlg" #dcl_id)) (exit))

	; �����\������
;-- 2012/02/20 A.Satoh Mod - S
;;;;;	(set_tile "txt2"
;;;;;		(strcat "��=" (rtos (nth 0 &wdh$)) " , ���s=" (rtos (nth 1 &wdh$)) " , ����=" (rtos (nth 2 &wdh$)))
;;;;;	)
	(set_tile "txt2"
		(strcat "��=" (rtos (nth 0 &wdh$)) " , ���s=" (rtos (nth 1 &wdh$)) " , ����=" (rtos CG_SizeH))
	)
;-- 2012/02/20 A.Satoh Mod - S

	(set_tile "edtWT_Width" (rtos (nth 0 &wdh$)))
	(set_tile "edtWT_Depth" (rtos (nth 1 &wdh$)))
;-- 2012/02/20 A.Satoh Mod - S
;;;;;	(set_tile "edtWT_Height" (rtos (nth 2 &wdh$)))
	(set_tile "edtWT_Height" (rtos CG_SizeH))
;-- 2012/02/20 A.Satoh Mod - E
;|
	;**************************************************
	; 12/8���_�ł̎b�菈��
	; ����Amdb�Q�Ƃɂ�鏈���ɕύX
	;**************************************************
	(if (/= CG_DRSeriCode "UF")
		(mode_tile "edtWT_Width" 1)
	)
	;**************************************************
|;

	; �����Ώۂɂ����͐���
	(if (= &taisyo "A")
		(progn
			(setq #W_f T)
			(setq #D_f T)
			(setq #H_f T)
		)
		(if (= (strlen &taisyo) 4)
			(progn
				(if (= (substr &taisyo 2 1) "W")
					(setq #W_f T)
					(setq #W_f nil)
				)
				(if (= (substr &taisyo 3 1) "D")
					(setq #D_f T)
					(setq #D_f nil)
				)
				(if (= (substr &taisyo 4 1) "H")
					(setq #H_f T)
					(setq #H_f nil)
				)
			)
			(progn
				(setq #W_f T)
				(setq #D_f T)
				(setq #H_f T)
			)
		)
	)

	(if (= (nth 0 &chk) nil)
		(setq #W_f nil)
	)
	(if (= (nth 1 &chk) nil)
		(setq #D_f nil)
	)
	(if (= (nth 2 &chk) nil)
		(setq #H_f nil)
	)

	(if (= #W_f nil)
		(mode_tile "edtWT_Width" 1)
	)
	(if (= #D_f nil)
		(mode_tile "edtWT_Depth" 1)
	)
	(if (= #H_f nil)
		(mode_tile "edtWT_Height" 1)
	)

	(if (not (equal (nth 0 &wdh$) (nth 3 &wdh$) 0.0001))
		(mode_tile "edtWT_Width" 1)
	)
	(if (not (equal (nth 1 &wdh$) (nth 4 &wdh$) 0.0001))
		(mode_tile "edtWT_Depth" 1)
	)
	(if (not (equal (nth 2 &wdh$) (nth 5 &wdh$) 0.0001))
		(mode_tile "edtWT_Height" 1)
	)

	(setq #next 99)
	(while (and (/= 1 #next) (/= 0 #next))
		; �{�^����������
  	(action_tile "accept" "(setq #ret$ (##SetTOKUCNRCABSize_CallBack))")
  	(action_tile "cancel" "(setq #ret$ nil) (done_dialog 0)")

  	(setq #next (start_dialog))
	)

  (unload_dialog #dcl_id)

	#ret$

);StretchCabW_SetTOKUCABSizeDlg


;|
;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_CheckTokuSeigyo
; <�����T�v>  : ������������Q�Ƃ��A��������̗L�����`�F�b�N����
; <�߂�l>    : �������䃊�X�g:(W���� D���� H����)
; <�쐬>      : 11/12/08 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_CheckTokuSeigyo (
	&en		; �ΏۃV���{���}�`��
  /
  )

	(setq #ret$ nil)

	; �w��̃V���{���}�`���琫�i�R�[�h���擾
	(setq #xd_LSYM$ (CFGetXData &en "G_LSYM"))
	(setq #seikaku (nth 9 #xd_LSYM$))

	; ������������擾����
	(setq #qry$$ (DBSqlAutoQuery CG_DBSESSION "select * from ��������")))
	(if (= #qry$$ nil)
		(progn
			; ���R�[�h�����݂��Ȃ��ꍇ�́A����Ȃ�
			(setq #ret$ (list 0 0 0))
		)
		(progn
			(foreach #qry$ #qry$$
				(setq #seikaku (nth 0 #qry$))
				(if (/= #seikaku "ALL")
					(setq #seikaku$ (StrParse #seikaku ","))
				)
				(setq #seikaku_chk (nth 1 #qry$))
				(setq #door (nth 2 #qry$))
				(if (/= #door "ALL")
					(setq #door$ (StrParse #door ","))
				)
				(setq #door_chk (nth 3 #qry$))
				(setq #houkou$ (StrParse (nth 4 #qry$) ","))
				(setq #seigyo (nth 5 #qry$))

				
			)
		)
	)


	#ret$

);StretchCabW_CheckTokuSeigyo
|;


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_InputTokuData
; <�����T�v>  : �w��̃V���{���ɑ΂��ē����L���r����ݒ肷��
; <�߂�l>    : T:����I�� nil �L�����Z���I��
; <�쐬>      : 11/12/01 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_InputTokuData (
  &sym				; �ΏۃV���{���}�`
	&org_size$	; �C���O�T�C�Y���X�g (�� ���s ����)
	&XLINE_W$
	&XLINE_D$
	&XLINE_H$
	&chk
	&cab_size$
	&flag       ; �R�[�i�[�L���r�FT    �R�[�i�[�L���r�ȊO�Fnil
  /
	#ret #err_flag #org_width #org_depth #org_height
	#xd_TOKU$ #xd_LSYM$ #xd_SYM$ #XLINE_W$ #XLINE_D$ #XLINE_H$
	#hinban #hinban2 #lr #skk #syuyaku #hin_last #toku_hin
	#qry$$ #qry2$$ #hinban$ #hinban2$
	#maguti1 #maguti2 #maguti3 #oku1 #oku2 #oku3 #height1 #height2 #height3
#hin_last$ #hin_width #hin_depth #hin_takasa  ;-- 2012/02/21 A.Satoh Add
#W_f #D_f #H_f #W_sabun #D_sabun #H_sabun  ;-- 2012/02/22 A.Satoh Add
#str_d #str_c   ;-- 2012/03/16 A.Satoh Add
#DOOR_INFO$ #DRCOLCODE #DRHIKITE #DRSERICODE #RET$ ;2013/08/05 YM ADD
#CG_TOKU_HINBAN #REG_D #REG_H #REG_W #XD_REG$ ;2018/05/17 YM ADD
#BRK_TOKU_W$ #BRK_TOKU_D$ #BRK_TOKU_H$ #BRK_REG_W$ #BRK_REG_D$ #BRK_REG_H$ ;2018/05/25 YM ADD
#HEIGHT1_REG #MAGUTI1_REG #OKU1_REG  ;2018/05/25 YM ADD
  )

	(setq #ret T)
	(setq #err_flag nil)
	(setq #org_width  (nth 0 &org_size$))
	(setq #org_depth  (nth 1 &org_size$))
	(setq #org_height (nth 2 &org_size$))

	;2018/05/18 YM ADD-S G_REG ���݊m�F
	(setq #xd_REG$ (CFGetXData &sym "G_REG"))
	(if #xd_REG$
		(progn ;G_REG ����
			(setq #org_width  (nth 12 #xd_REG$))
			(setq #org_depth  (nth 13 #xd_REG$))
			(setq #org_height (nth 14 #xd_REG$))
		)
	);_if

	;2018/05/18 YM ADD-E G_REG ���݊m�F

;-- 2012/02/22 A.Satoh Add - S
	(setq #W_sabun 0.0)
	(setq #D_sabun 0.0)
	(setq #H_sabun 0.0)

	(setq #W_f T)
	(setq #D_f T)
	(setq #H_f T)

	(if (= (nth 0 &chk) nil)
		(setq #W_f nil)
	)
	(if (= (nth 1 &chk) nil)
		(setq #D_f nil)
	)
	(if (= (nth 2 &chk) nil)
		(setq #H_f nil)
	)
;-- 2012/02/22 A.Satoh Add - E

	(setq #xd_TOKU$ (CFGetXData &sym "G_TOKU"))
	(if (= #xd_TOKU$ nil)
		(progn ;G_TOKU �Ȃ�
			(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
			(if (= #xd_LSYM$ nil)
				(setq #err_flag T)
			)

			(if (= #err_flag nil)
				(progn
					(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
					(if (= #xd_SYM$ nil)
						(setq #err_flag T)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
					(setq #hinban (nth 5 #xd_LSYM$))
					(setq #lr     (nth 6 #xd_LSYM$))
					(setq #skk    (nth 9 #xd_LSYM$))

					(setq #qry$$
						(CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
							(list
								(list "�i�Ԗ���" #hinban 'STR)
								(list "���iCODE" (itoa (fix #skk)) 'INT)
							)
						)
					)

					(if (/= #qry$$ nil)
						(if (= (length #qry$$) 1)
							(setq #syuyaku (nth 5 (nth 0 #qry$$)))
							(setq #err_flag T)
						)
						(setq #err_flag T)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
;-- 2011/12/14 A.Satoh Mod - S
;;;;;					(setq #qry$$
;;;;;						(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
;;;;;							(list
;;;;;								(list "�i�Ԗ���"   #hinban       'STR)
;;;;;								(list "LR�敪"     #lr           'STR)
;;;;;								(list "���V���L��" CG_DRSeriCode 'STR)
;;;;;								(list "���J���L��" CG_DRColCode  'STR)
;;;;;								(list "����L��"   CG_Hikite     'STR)
;;;;;							)
;;;;;						)
;;;;;					)
;;;;;
;;;;;					(if (/= #qry$$ nil)
;;;;;						(if (= (length #qry$$) 1)
;;;;;							(setq #hin_last (nth 10 (car #qry$$)))
;;;;;							(setq #err_flag T)
;;;;;						)
;;;;;;-- 2011/12/13 A.Satoh Mod - S
;;;;;;						(setq #err_flag T)
;;;;;						(progn
;;;;;							(setq #qry2$$
;;;;;								(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
;;;;;									(list
;;;;;										(list "�i�Ԗ���"   #hinban       'STR)
;;;;;										(list "LR�敪"     #lr           'STR)
;;;;;										(list "���V���L��" CG_DRSeriCode 'STR)
;;;;;										(list "���J���L��" CG_DRColCode  'STR)
;;;;;									)
;;;;;								)
;;;;;							)
;;;;;
;;;;;							(if (/= #qry2$$ nil)
;;;;;								(if (= (length #qry2$$) 1)
;;;;;									(setq #hin_last (nth 10 (car #qry2$$)))
;;;;;									(setq #err_flag T)
;;;;;								)
;;;;;								(setq #err_flag T)
;;;;;							)
;;;;;						)
;;;;;;-- 2011/12/13 A.Satoh Mod - E
;;;;;					)
					; �i�Ԗ��̂��犇�ʂ����O
					(setq #hinban2 (KP_DelHinbanKakko #hinban))

					; �ŏI�i�Ԃ��擾
;-- 2012/02/21 A.Satoh Mod - S
;;;;;					(setq #hin_last (car (StretchCabW_GetHinbanLast #hinban2 #lr)))
;;;;;					(if (= #hin_last nil)
;;;;;						(setq #err_flag T)
;;;;;					)

					;2013/08/05 YM MOD-S
					(setq #Door_Info$     (nth 7 #xd_LSYM$))
					(setq #ret$ (StrParse #Door_Info$ ","))
					(setq #DRSeriCode (car   #ret$))(if (= #DRSeriCode nil)(setq #DRSeriCode ""))
					(setq #DRColCode  (cadr  #ret$))(if (= #DRColCode nil)(setq #DRColCode ""))
					(setq #DRHikite   (caddr #ret$))(if (= #DRHikite nil)(setq #DRHikite ""))

					(if (= #DRSeriCode "")
						(progn
							(setq #DRSeriCode CG_DRSeriCode)
							(setq #DRColCode  CG_DRColCode)
							(setq #DRHikite   CG_Hikite)
						)
					);_if

;;;					(setq #hin_last$ (StretchCabW_GetHinbanLast #hinban2 #lr))
					(setq #hin_last$ (StretchCabW_GetHinbanLast_HIKISU #hinban2 #lr #DRSeriCode #DRColCode #DRHikite))
					;2013/08/05 YM MOD-E

					(if (= #hin_last$ nil)
						(progn
							(setq #hin_last #hinban)
							(setq #hin_width (nth 3 #xd_SYM$))
							(setq #hin_depth (nth 4 #xd_SYM$))
							(setq #hin_takasa (nth 5 #xd_SYM$))
						)
						(progn
							(setq #hin_last (car #hin_last$))
;-- 2012/02/22 A.Satoh Mod - S
;;;;;							(setq #hin_width  (atof (nth 1 #hin_last$)))
;;;;;							(setq #hin_takasa (atof (nth 2 #hin_last$)))
;;;;;							(setq #hin_depth  (atof (nth 3 #hin_last$)))
							(if (= #W_f T)
								(setq #W_sabun (- (nth 3 #xd_SYM$) #org_width))
							)
							(if (= #D_f T)
								(setq #D_sabun (- (nth 4 #xd_SYM$) #org_depth))
							)
							(if (= #H_f T)
								(setq #H_sabun (- (nth 5 #xd_SYM$) #org_height))
							)
							(setq #hin_width  (+ (atof (nth 1 #hin_last$)) #W_sabun))
							(setq #hin_takasa (+ (atof (nth 2 #hin_last$)) #H_sabun))
							(setq #hin_depth  (+ (atof (nth 3 #hin_last$)) #D_sabun))
;-- 2012/02/22 A.Satoh Mod - E
						)
					)
;-- 2012/02/21 A.Satoh Mod - E
;-- 2011/12/14 A.Satoh Mod - E
				)
			)

			(if (= #err_flag nil)
				(progn
		      (setq #qry$$
    		    (CFGetDBSQLRec CG_CDBSESSION "�W�񖼏�"
        		  (list
            		(list "�W��ID" #syuyaku 'STR)
		          )
    		    )
		      )
					(if (/= #qry$$ nil)
						(if (= (length #qry$$) 1)
							(setq #toku_hin (nth 2 (car #qry$$)))
							(setq #err_flag T)
						)
						(setq #err_flag T)
					)
				)
			)

			;2016/10/06 YM ADD �@�킩�ǂ����̔���
			(if (KikiHantei (nth 5 #xd_LSYM$) (nth 9 #xd_LSYM$)) ;�i��,���i����
				(progn
					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_KIKI)
				)
				;�@��ȊO
				(progn
					;2018/07/27 YM MOD-S
;;;					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN)
					(cond
						((= BU_CODE_0013 "1") ; PSKC�̏ꍇ
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
						)
						((= BU_CODE_0013 "2") ; PSKD�̏ꍇ
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
						)
						(T ;����ȊO
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
						)
					);_if
					;2018/07/27 YM MOD-E
				)
			);_if
; 2017/11/13 KY ADD-S
; �t���[���L�b�`�� �W���J�E���^�[�Ή�
			(if (IsFKLWCounter (nth 5 #xd_LSYM$))
				(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_LWCT)
			);if
; 2017/11/13 KY ADD-E

			(if (= #err_flag nil)
				(progn
					(setq #hinban$
						(list
;;;							#toku_hin													; �����i��
							#CG_TOKU_HINBAN										; �����i�� 2016/08/30 YM MOD (2)
							0																	; ���z
;;;							(strcat "ĸ���(" #hin_last ")")		; �i��
							(strcat "ĸ(" #hin_last ")")      ; �i�� 2016/08/30 YM MOD
							""																; �����R�[�h�@�����R�[�h-�A��
;-- 2012/02/21 A.Satoh Mod - S
;;;;;							(nth 3 #xd_SYM$)									; ��
;;;;;							(nth 5 #xd_SYM$)									; ����
;;;;;							(nth 4 #xd_SYM$)									; ���s
							#hin_width												; ��
							#hin_takasa												; ����
							#hin_depth												; ���s
;-- 2012/02/21 A.Satoh Mod - E
						)
					)
				)
			)
		)
		;else
		(progn ;G_TOKU ����
			(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
			(if (= #xd_LSYM$ nil)
				(setq #err_flag T)
			)

			(if (= #err_flag nil)
				(progn
					(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
					(if (= #xd_SYM$ nil)
						(setq #err_flag T)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
;-- 2012/02/22 A.Satoh Add - S
					(if (= #W_f T)
						(setq #W_sabun (- (nth 3 #xd_SYM$) #org_width))
					)
					(if (= #D_f T)
						(setq #D_sabun (- (nth 4 #xd_SYM$) #org_depth))
					)
					(if (= #H_f T)
						(setq #H_sabun (- (nth 5 #xd_SYM$) #org_height))
					)
					(setq #hin_width  (+ (nth 4 #xd_TOKU$) #W_sabun))
					(setq #hin_takasa (+ (nth 5 #xd_TOKU$) #H_sabun))
					(setq #hin_depth  (+ (nth 6 #xd_TOKU$) #D_sabun))
;-- 2012/02/22 A.Satoh Add - E

					(setq #hinban$
						(list
							(nth 0 #xd_TOKU$)				; �����i��
							(fix (nth 1 #xd_TOKU$))	; ���z
							(nth 2 #xd_TOKU$)				; �i��
							(nth 3 #xd_TOKU$)				; �����R�[�h
;-- 2012/02/22 A.Satoh Add - S
;;;;;;-- 2012/02/21 A.Satoh Mod - S
;;;;;;;;;;							(nth 3 #xd_SYM$)				; ��
;;;;;;;;;;							(nth 5 #xd_SYM$)				; ����
;;;;;;;;;;							(nth 4 #xd_SYM$)				; ���s
;;;;;							(nth 4 #xd_TOKU$)				; ��
;;;;;							(nth 5 #xd_TOKU$)				; ����
;;;;;							(nth 6 #xd_TOKU$)				; ���s
;;;;;;-- 2012/02/21 A.Satoh Mod - E
							#hin_width
							#hin_takasa
							#hin_depth
;-- 2012/02/22 A.Satoh Add - E
						)
					)
				)
			)
		)
	);(if (= #xd_TOKU$ nil)

	(if (= #err_flag nil)
		(progn
			; �����L���r�����͉�ʏ���
			(setq #hinban2$ (Toku_HeightChange_SetTokuDataDlg #hinban$))
			(if #hinban2$
				(progn
					(if &XLINE_W$
						(progn
							; �u���[�N���C���ʒu���������Ń\�[�g����
							(setq #XLINE_W$ (SortBrkLineDist &XLINE_W$))

							(setq #maguti1 (car #XLINE_W$))
							(if (= #maguti1 nil)
								(setq #maguti1 0.0)
							)
							(setq #maguti2 (cadr #XLINE_W$))
							(if (= #maguti2 nil)
								(setq #maguti2 0.0)
							)
							(setq #maguti3 (caddr #XLINE_W$))
							(if (= #maguti3 nil)
								(setq #maguti3 0.0)
							)
						)
						(progn
							(setq #maguti1 0.0)
							(setq #maguti2 0.0)
							(setq #maguti3 0.0)
						)
					)
					(if &XLINE_D$
						(progn
							; �u���[�N���C���ʒu���������Ń\�[�g����
							(setq #XLINE_D$ (SortBrkLineDist &XLINE_D$))

							(setq #oku1 (car #XLINE_D$))
							(if (= #oku1 nil)
								(setq #oku1 0.0)
							)
							(setq #oku2 (cadr #XLINE_D$))
							(if (= #oku2 nil)
								(setq #oku2 0.0)
							)
							(setq #oku3 (caddr #XLINE_D$))
							(if (= #oku3 nil)
								(setq #oku3 0.0)
							)
						)
						(progn
							(setq #oku1 0.0)
							(setq #oku2 0.0)
							(setq #oku3 0.0)
						)
					)
					(if &XLINE_H$
						(progn
							; �u���[�N���C���ʒu���������Ń\�[�g����
							(setq #XLINE_H$ (SortBrkLineDist &XLINE_H$))

							(setq #height1 (car #XLINE_H$))
							(if (= #height1 nil)
								(setq #height1 0.0)
							)
							(setq #height2 (cadr #XLINE_H$))
							(if (= #height2 nil)
								(setq #height2 0.0)
							)
							(setq #height3 (caddr #XLINE_H$))
							(if (= #height3 nil)
								(setq #height3 0.0)
							)
						)
						(progn
							(setq #height1 0.0)
							(setq #height2 0.0)
							(setq #height3 0.0)
						)
					)

					; �������(G_TOKU)�̐ݒ�
					(if #xd_TOKU$
						(progn
;-- 2012/03/16 A.Satoh Add - S
							(if &flag
								(if (> (nth 15 #xd_TOKU$) 0.0)
									(setq #str_d (nth 15 #xd_TOKU$))
									(setq #str_d (nth 3 &cab_size$))
								)
								(setq #str_d (nth 15 #xd_TOKU$))
							)
							(if &flag
								(if (> (nth 16 #xd_TOKU$) 0.0)
									(setq #str_c (nth 16 #xd_TOKU$))
									(setq #str_c (nth 2 &cab_size$))
								)
								(setq #str_c (nth 16 #xd_TOKU$))
							)
;-- 2012/03/16 A.Satoh Add - E

							(CFSetXData &sym "G_TOKU"
								(CFModList #xd_TOKU$
									(list
										(list  0 (nth 0 #hinban2$))													; [ 0]�����i��
										(list  1 (nth 1 #hinban2$))													; [ 1]���z
										(list  2 (nth 2 #hinban2$))													; [ 2]�i��
										(list  3 (nth 3 #hinban2$))													; [ 3]�����R�[�h
										(list  4 (nth 4 #hinban2$))													; [ 4]��
										(list  5 (nth 5 #hinban2$))													; [ 5]����
										(list  6 (nth 6 #hinban2$))													; [ 6]���s
;-- 2012/03/16 A.Satoh Add - S
										(list 15 #str_d)																		; [15]�c�̐L�k��
										(list 16 #str_c)																		; [16]�b�̐L�k��
;-- 2012/03/16 A.Satoh Add - E
										(list 17 (nth 3 #xd_SYM$))													; [17]�L�k��}�`�T�C�Y�v
										(list 18 (nth 4 #xd_SYM$))													; [18]�L�k��}�`�T�C�Y�c
										(list 19 (nth 5 #xd_SYM$))													; [19]�L�k��}�`�T�C�Y�g
										(if &XLINE_W$
											(list 20 (list #maguti1 #maguti2 #height3))				; [20]�u���[�N���C���ʒu�v
											(list 20 (nth 20 #xd_TOKU$))
										)
										(if &XLINE_D$
											(list 21 (list #oku1    #oku2    #oku3))					; [21]�u���[�N���C���ʒu�c
											(list 21 (nth 21 #xd_TOKU$))
										)
										(if &XLINE_H$
											(list 22 (list #height1 #height2 #height3))				; [22]�u���[�N���C���ʒu�g
											(list 22 (nth 22 #xd_TOKU$))
										)
									)
								)
							)
						)
						(progn ; "G_TOKU" ���Ȃ��ꍇ


	;2018/05/23 YM ADD-S G_REG ���݊m�F

	;��������ނŒǉ����ꂽ��ڰ�ײ�
	(setq #BRK_TOKU_W$ (list #maguti1 #maguti2 #maguti3)) ; [20]�u���[�N���C���ʒu�v
	(setq #BRK_TOKU_D$ (list #oku1    #oku2    #oku3))    ; [21]�u���[�N���C���ʒu�c
	(setq #BRK_TOKU_H$ (list #height1 #height2 #height3)) ; [22]�u���[�N���C���ʒu�g

	(if #xd_REG$
		(progn ;G_REG ����

			;�}�`���ŏ����玝���Ă�����ڰ�ײ�
			(setq #BRK_REG_W$ (nth 20 #xd_REG$))(setq #maguti1_reg (car #BRK_REG_W$))
			(setq #BRK_REG_D$ (nth 21 #xd_REG$))(setq #oku1_reg    (car #BRK_REG_D$))
			(setq #BRK_REG_H$ (nth 22 #xd_REG$))(setq #height1_reg (car #BRK_REG_H$))

			(if (and (equal #maguti1 0 0.01) (not (equal #maguti1_reg 0 0.01))) (setq #BRK_TOKU_W$ #BRK_REG_W$) )
			(if (and (equal #oku1    0 0.01) (not (equal #oku1_reg    0 0.01))) (setq #BRK_TOKU_D$ #BRK_REG_D$) )
			(if (and (equal #height1 0 0.01) (not (equal #height1_reg 0 0.01))) (setq #BRK_TOKU_H$ #BRK_REG_H$) )

		)
	);_if

;     G_REG ���������ڰ�ײ�ʒu������


;;;	;2018/05/18 YM ADD-E G_REG ���݊m�F

							(CFSetXData &sym "G_TOKU"
								(list
									(nth 0 #hinban2$)													; [ 0]�����i��
									(nth 1 #hinban2$)													; [ 1]���z
									(nth 2 #hinban2$)													; [ 2]�i��
									(nth 3 #hinban2$)													; [ 3]�����R�[�h
									(nth 4 #hinban2$)													; [ 4]��
									(nth 5 #hinban2$)													; [ 5]����
									(nth 6 #hinban2$)													; [ 6]���s
									""																				; [ 7]�\���P
									""																				; [ 8]�\���Q
									""																				; [ 9]�\���R
									#hinban																		; [10]���i�Ԗ���
									#hin_last																	; [11]���ŏI�i��
									#org_width																; [12]���}�`�T�C�Y�v
									#org_depth																; [13]���}�`�T�C�Y�c
									#org_height																; [14]���}�`�T�C�Y�g
;-- 2012/03/16 A.Satoh Mod -S
;;;;;									""																				; [15]�\���S
;;;;;									""																				; [16]�\���T
									(if &flag
										(nth 3 &cab_size$)											; [15]�c�̐L�k��
										0.0																			; [15]�c�̐L�k��
									)
									(if &flag
										(nth 2 &cab_size$)											; [16]�b�̐L�k��
										0.0																			; [16]�b�̐L�k��
									)
;-- 2012/03/16 A.Satoh Mod -E
									(nth 3 #xd_SYM$)													; [17]�L�k��}�`�T�C�Y�v
									(nth 4 #xd_SYM$)													; [18]�L�k��}�`�T�C�Y�c
									(nth 5 #xd_SYM$)													; [19]�L�k��}�`�T�C�Y�g

;2018/05/25 YM MOD-S
;;;									(list #maguti1 #maguti2 #maguti3)					; [20]�u���[�N���C���ʒu�v
;;;									(list #oku1    #oku2    #oku3)						; [21]�u���[�N���C���ʒu�c
;;;									(list #height1 #height2 #height3)					; [22]�u���[�N���C���ʒu�g
#BRK_TOKU_W$
#BRK_TOKU_D$
#BRK_TOKU_H$
;2018/05/25 YM MOD-E

								)
							)

						)
					)
				)
				(setq #ret nil)
			)
		)
	);_if

	#ret

);StretchCabW_InputTokuData


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_GetHinbanLast
; <�����T�v>  : �w��̕i�Ԗ��̂�LR�敪���ŏI�i�Ԃ����߂�
; <�߂�l>    : �ŏI�i�� or nil
; <�쐬>      : 11/12/14 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_GetHinbanLast (
	&hinban			; �i�Ԗ��́i���ʖ����j
	&lr					; LR�敪
  /
	#flag #ret$ #qry$$ #qry$
  )

	(setq #flag nil)
	(setq #ret$ nil)

	; �i�Ԗ��� LR�敪 ���V���L�� ���J���L�� ����L�� �K�X��Ō���
	(setq #qry$$
		(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
			(list
				(list "�i�Ԗ���"   &hinban       'STR)
				(list "LR�敪"     &lr           'STR)
				(list "���V���L��" CG_DRSeriCode 'STR)
				(list "���J���L��" CG_DRColCode  'STR)
				(list "����L��"   CG_Hikite     'STR)
				(list "�K�X��"     CG_GasType    'STR)
			)
		)
	)

	(if (/= #qry$$ nil)
		(if (= (length #qry$$) 1)
			(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

				;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
				;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�
;-- 2012/02/21 A.Satoh Mod - E
				(setq #flag T)
			)
			(progn
				(princ "\n�Y���f�[�^���������o����܂����B")
				(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
				(princ (strcat "\n��������LR�敪�@�@ = " &lr))
				(princ (strcat "\n�����������V���L�� = " CG_DRSeriCode))
				(princ (strcat "\n�����������J���L�� = " CG_DRColCode))
				(princ (strcat "\n������������L���@ = " CG_Hikite))
				(princ (strcat "\n���������K�X��@�@ = " CG_GasType))
				(setq #ret$ nil)
				(setq #flag T)
			)
		)
	)

	; �i�Ԗ��� LR�敪 ���V���L�� ���J���L�� ����L���Ō���
	(setq #qry$$
		(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
			(list
				(list "�i�Ԗ���"   &hinban       'STR)
				(list "LR�敪"     &lr           'STR)
				(list "���V���L��" CG_DRSeriCode 'STR)
				(list "���J���L��" CG_DRColCode  'STR)
				(list "����L��"   CG_Hikite     'STR)
			)
		)
	)

	(if (/= #qry$$ nil)
		(if (= (length #qry$$) 1)
			(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

				;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
				;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
				(setq #flag T)
			)
			(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;				(repeat #qry$ #qry$$
				(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
					(if (= #flag nil)
						(if (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil))
							(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

								;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
								;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
								(setq #flag T)
							)
						)
					)
				)
				(if (= #flag nil)
					(progn
						(princ "\n�Y���f�[�^���������o����܂����B")
						(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
						(princ (strcat "\n��������LR�敪�@�@ = " &lr))
						(princ (strcat "\n�����������V���L�� = " CG_DRSeriCode))
						(princ (strcat "\n�����������J���L�� = " CG_DRColCode))
						(princ (strcat "\n������������L���@ = " CG_Hikite))
						(setq #ret$ nil)
						(setq #flag T)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; �i�Ԗ��� LR�敪 ���V���L�� ���J���L���Ō���
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"   &hinban       'STR)
						(list "LR�敪"     &lr           'STR)
						(list "���V���L��" CG_DRSeriCode 'STR)
						(list "���J���L��" CG_DRColCode  'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n�Y���f�[�^���������o����܂����B")
								(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
								(princ (strcat "\n��������LR�敪�@�@ = " &lr))
								(princ (strcat "\n�����������V���L�� = " CG_DRSeriCode))
								(princ (strcat "\n�����������J���L�� = " CG_DRColCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; �i�Ԗ��� LR�敪 ���V���L���Ō���
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"   &hinban       'STR)
						(list "LR�敪"     &lr           'STR)
						(list "���V���L��" CG_DRSeriCode 'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n�Y���f�[�^���������o����܂����B")
								(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
								(princ (strcat "\n��������LR�敪�@�@ = " &lr))
								(princ (strcat "\n�����������V���L�� = " CG_DRSeriCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; �i�Ԗ��� LR�敪 ���J���L���Ō���
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"   &hinban      'STR)
						(list "LR�敪"     &lr          'STR)
						(list "���J���L��" CG_DRColCode 'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n�Y���f�[�^���������o����܂����B")
								(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
								(princ (strcat "\n��������LR�敪�@�@ = " &lr))
								(princ (strcat "\n�����������J���L�� = " CG_DRColCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; �i�Ԗ��� LR�敪 �K�X��Ō���
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���" &hinban    'STR)
						(list "LR�敪"   &lr        'STR)
						(list "�K�X��"   CG_GasType 'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
												 (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n�Y���f�[�^���������o����܂����B")
								(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
								(princ (strcat "\n��������LR�敪�@�@ = " &lr))
								(princ (strcat "\n���������K�X��@�@ = " CG_GasType))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; �i�Ԗ��� LR�敪�Ō���
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���" &hinban 'STR)
						(list "LR�敪"   &lr     'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(progn
									(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
													 (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
													 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
													 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
										(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

											;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
											;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
											(setq #flag T)
										)
									)
								)
							)
						)

						(if (= #flag nil)
							(progn
								(princ "\n�Y���f�[�^���������o����܂����B")
								(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
								(princ (strcat "\n��������LR�敪�@�@ = " &lr))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)


	#ret$

);StretchCabW_GetHinbanLast


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_GetHinbanLast_HIKISU
; <�����T�v>  : �w��̕i�Ԗ��̂�LR�敪���ŏI�i�Ԃ����߂�
; <�߂�l>    : �ŏI�i�� or nil
; <�쐬>      : 11/12/14 A.Satoh
; <���l>      : 2013/08/05 YM ADD �����̎������ŕi�ԍŏI����������
;*************************************************************************>MOH<
(defun StretchCabW_GetHinbanLast_HIKISU (
	&hinban			; �i�Ԗ��́i���ʖ����j
	&lr					; LR�敪
	&DRSeriCode ; ���V���L��
	&DRColCode  ; ���J���L��
	&Hikite     ; ����L��
  /
	#flag #ret$ #qry$$ #qry$
  )

	(setq #flag nil)
	(setq #ret$ nil)

	; �i�Ԗ��� LR�敪 ���V���L�� ���J���L�� ����L�� �K�X��Ō���
	(setq #qry$$
		(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
			(list
				(list "�i�Ԗ���"   &hinban       'STR)
				(list "LR�敪"     &lr           'STR)
				(list "���V���L��" &DRSeriCode   'STR)
				(list "���J���L��" &DRColCode    'STR)
				(list "����L��"   &Hikite       'STR)
				(list "�K�X��"     CG_GasType    'STR)
			)
		)
	)

	(if (/= #qry$$ nil)
		(if (= (length #qry$$) 1)
			(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

				;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
				;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�
;-- 2012/02/21 A.Satoh Mod - E
				(setq #flag T)
			)
			(progn
				(princ "\n�Y���f�[�^���������o����܂����B")
				(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
				(princ (strcat "\n��������LR�敪�@�@ = " &lr))
				(princ (strcat "\n�����������V���L�� = " &DRSeriCode))
				(princ (strcat "\n�����������J���L�� = " &DRColCode))
				(princ (strcat "\n������������L���@ = " &Hikite))
				(princ (strcat "\n���������K�X��@�@ = " CG_GasType))
				(setq #ret$ nil)
				(setq #flag T)
			)
		)
	)

	; �i�Ԗ��� LR�敪 ���V���L�� ���J���L�� ����L���Ō���
	(setq #qry$$
		(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
			(list
				(list "�i�Ԗ���"   &hinban       'STR)
				(list "LR�敪"     &lr           'STR)
				(list "���V���L��" &DRSeriCode   'STR)
				(list "���J���L��" &DRColCode    'STR)
				(list "����L��"   &Hikite       'STR)
			)
		)
	)

	(if (/= #qry$$ nil)
		(if (= (length #qry$$) 1)
			(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

				;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
				;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
				(setq #flag T)
			)
			(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;				(repeat #qry$ #qry$$
				(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
					(if (= #flag nil)
						(if (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil))
							(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

								;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
								;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
								(setq #flag T)
							)
						)
					)
				)
				(if (= #flag nil)
					(progn
						(princ "\n�Y���f�[�^���������o����܂����B")
						(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
						(princ (strcat "\n��������LR�敪�@�@ = " &lr))
						(princ (strcat "\n�����������V���L�� = " &DRSeriCode))
						(princ (strcat "\n�����������J���L�� = " &DRColCode))
						(princ (strcat "\n������������L���@ = " &Hikite))
						(setq #ret$ nil)
						(setq #flag T)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; �i�Ԗ��� LR�敪 ���V���L�� ���J���L���Ō���
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"   &hinban       'STR)
						(list "LR�敪"     &lr           'STR)
						(list "���V���L��" &DRSeriCode   'STR)
						(list "���J���L��" &DRColCode    'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n�Y���f�[�^���������o����܂����B")
								(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
								(princ (strcat "\n��������LR�敪�@�@ = " &lr))
								(princ (strcat "\n�����������V���L�� = " &DRSeriCode))
								(princ (strcat "\n�����������J���L�� = " &DRColCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; �i�Ԗ��� LR�敪 ���V���L���Ō���
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"   &hinban       'STR)
						(list "LR�敪"     &lr           'STR)
						(list "���V���L��" &DRSeriCode   'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n�Y���f�[�^���������o����܂����B")
								(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
								(princ (strcat "\n��������LR�敪�@�@ = " &lr))
								(princ (strcat "\n�����������V���L�� = " &DRSeriCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; �i�Ԗ��� LR�敪 ���J���L���Ō���
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���"   &hinban      'STR)
						(list "LR�敪"     &lr          'STR)
						(list "���J���L��" &DRColCode   'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n�Y���f�[�^���������o����܂����B")
								(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
								(princ (strcat "\n��������LR�敪�@�@ = " &lr))
								(princ (strcat "\n�����������J���L�� = " &DRColCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; �i�Ԗ��� LR�敪 �K�X��Ō���
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���" &hinban    'STR)
						(list "LR�敪"   &lr        'STR)
						(list "�K�X��"   CG_GasType 'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
												 (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n�Y���f�[�^���������o����܂����B")
								(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
								(princ (strcat "\n��������LR�敪�@�@ = " &lr))
								(princ (strcat "\n���������K�X��@�@ = " CG_GasType))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; �i�Ԗ��� LR�敪�Ō���
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
					(list
						(list "�i�Ԗ���" &hinban 'STR)
						(list "LR�敪"   &lr     'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(progn
									(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
													 (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
													 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
													 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
										(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

											;2013/01/30 YM MOD-S (nth  8 (car #qry$$))��ǉ�
;;;											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
											;2013/01/30 YM MOD-E (nth  8 (car #qry$$))��ǉ�

;-- 2012/02/21 A.Satoh Mod - E
											(setq #flag T)
										)
									)
								)
							)
						)

						(if (= #flag nil)
							(progn
								(princ "\n�Y���f�[�^���������o����܂����B")
								(princ (strcat "\n���������i�Ԗ��́@ = " &hinban))
								(princ (strcat "\n��������LR�敪�@�@ = " &lr))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)


	#ret$

);StretchCabW_GetHinbanLast_HIKISU


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_MoveCabToWorkLayer
; <�����T�v>  : �w��̃V���{���}�`�����[�N���C���i"EXP_TEMP_LAYER")�ֈړ�����
; <�߂�l>    : �ړ��}�`��񃊃X�g(�}�`�� ����w��)
; <�쐬>      : 11/12/08 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_MoveCabToWorkLayer (
	&enSym	; �V���{���}�`��
  /
	#ss #idx #en #Temp$ #strLayer #expData$
  )

	(setq #expData$ nil)

	(setq #ss (CFGetSameGroupSS &enSym))
	(setq #idx 0)
	(repeat (sslength #ss)
		(setq #en (ssname #ss #idx))
		(setq #Temp$ (entget #en))

		(setq #strLayer (cdr (assoc 8 #Temp$)))
;-- 2011/12/16 A.Satoh Mod - S
;;;;;		(if (or (= (substr #strLayer 1 4) "Z_00") (= (substr #strLayer 1 3) "M_5"))
		(if (or (= (substr #strLayer 1 4) "Z_00") (= (substr #strLayer 1 2) "M_"))
;-- 2011/12/16 A.Satoh Mod - E
			(progn
				; �}�`���Ɖ�w����1���X�g�ɂ��Ċi�[����(�}�`�� ��w��)
				(setq #expData$ (cons (list #en #strLayer) #expData$))

				; �L�k�Ώ̐}�`��L�k������w�Ɉړ�����
				(entmod (subst (cons 8 "EXP_TEMP_LAYER") (assoc 8 #Temp$) #Temp$))
			)
		)

		(setq #idx (1+ #idx))
	)

	#expData$

) ;StretchCabW_MoveCabToWorkLayer


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_MoveCabBackOrgLayer
; <�����T�v>  : ���[�N���C���̃V���{���}�`�������C���֖߂�
; <�߂�l>    : �ړ��}�`��񃊃X�g(�}�`�� ����w��)
; <�쐬>      : 11/12/08 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_MoveCabBackOrgLayer (
	&expData$
  /
	#nn #Temp$
  )

	(foreach #nn &expData$ ; �L�k��Ɖ�w���猳�̉�w�ɐ}�`�f�[�^���ړ�����
		(setq #Temp$ (entget (nth 0 #nn) '("*")))
		(entmod (subst (cons 8 (nth 1 #nn)) (cons 8 "EXP_TEMP_LAYER") #Temp$))
	)

	(princ)

) ;StretchCabW_MoveCabBackOrgLayer


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_MakeBreakLineW
; <�����T�v>  : �v�����u���[�N���C�����쐬����
; <�߂�l>    : �v�����u���[�N���C���ʒu���X�g
; <�쐬>      : 11/12/06 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_MakeBreakLineW (
	&base_pnt$	; �V���{���}����_
	&ang				; ��]�p�x�i���W�A���j
  /
	#orthomode #clayer
	#ret$ #ename$ #cnt #flag #dp #dist #en #pnt$ #ang
  )

	; ���s���[�h�̐ݒ�
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)

;	; ���݉�w�̕ύX
;	(setq #clayer (getvar "CLAYER"))
;	
;  (command "_layer" "T" "N_BREAKW" "")
;  (command "_layer" "ON" "N_BREAKW" "")
;	(setvar "CLAYER" "N_BREAKW")
;EXP_TEMP_LAYER
	; ���_�̕ύX
	;(command "_vpoint" "0,-1,0")
;-- 2011/12/15 A.Satoh Mod - S
;;;;;	(C:ChgViewFront)
	(setq #ang (fix (rtd &ang)))	; ���W�A�����p�x�ɕϊ�
	(cond
		((= #ang 90)
			(C:ChgViewSideR)
		)
		((= #ang 180)
			(C:ChgViewBack)
		)
		((= #ang 270)
			(C:ChgViewSideL)
		)
		(T
			(C:ChgViewFront)
		)
	)
;-- 2011/12/15 A.Satoh Mod - E
	(command "._zoom" "E")
	(command "_.ZOOM" "0.5x")
	(command "_.UCS" "V")

	(setq #ret$ nil)
	(setq #ename$ nil)
	(setq #cnt 0)
	(setq #flag T)
	(setq #pnt$ (trans &base_pnt$ 0 1))

	(while #flag
		(setq #dp (getvar "lastpoint"))
		(princ "\n�u���[�N���C���ʒu���w��/�I��[ENTER]�F")
		(command ".XLINE" "V" PAUSE)
		(if (= nil (equal 0.0 (distance #dp (getvar "lastpoint")) 0.0001))
			(progn
				(command "")
				(setq #cnt (1+ #cnt))

				(if (>= 2 #cnt)
					(progn
						(setq #ename$ (append #ename$ (list (entlast))))
;						(setq #dist (abs (fix (- (car (getvar "lastpoint")) (car &base_pnt$)))))
						(setq #dist (abs (fix (- (car (getvar "lastpoint")) (car #pnt$)))))
						(setq #ret$ (append #ret$ (list #dist)))
					)
					(progn
						(CFAlertErr "�u���[�N���C���͂Q�ӏ��ȏ�w���ł��܂���")
						(entdel (entlast))
					)
				)
			)
			(setq #flag nil)
		)
	)

	(foreach #en #ename$
		(entdel #en)
	)

	; ���_��߂�
	(command "_.UCS" "W")

	(command "_zoom" "P")
	(command "_zoom" "P")
	(command "_zoom" "P")

	; ���s���[�h��߂�
  (setvar "ORTHOMODE" #orthomode)
;  (command "_layer" "OF" "N_BREAKW" "")
;
;	; ���݉�w��߂�
;	(setvar "CLAYER" #clayer)

	#ret$

) ;StretchCabW_MakeBreakLineW


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_MakeBreakLineD
; <�����T�v>  : �c�����u���[�N���C�����쐬����
; <�߂�l>    : �c�����u���[�N���C���ʒu���X�g
; <�쐬>      : 11/12/06 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_MakeBreakLineD (
	&base_pnt$
	&ang				; ��]�p�x�i���W�A���j
  /
	#orthomode #clayer
	#ret$ #ename$ #cnt #flag #dp #dist #en #pnt$ #ang
  )

	; ���s���[�h�̐ݒ�
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)

;	; ���݉�w�̕ύX
;	(setq #clayer (getvar "CLAYER"))
;  (command "_layer" "T" "N_BREAKW" "")
;  (command "_layer" "ON" "N_BREAKW" "")
;	(setvar "CLAYER" "N_BREAKW")

	; ���_�̕ύX
	;(command "_vpoint" "1,0,0")
;-- 2011/12/15 A.Satoh Mod - E
;;;;;	(C:ChgViewSideR)
	(setq #ang (fix (rtd &ang)))	; ���W�A�����p�x�ɕϊ�
	(cond
		((= #ang 90)
			(C:ChgViewBack)
		)
		((= #ang 180)
			(C:ChgViewSideL)
		)
		((= #ang 270)
			(C:ChgViewFront)
		)
		(T
			(C:ChgViewSideR)
		)
	)
;-- 2011/12/15 A.Satoh Mod - E
	(command "._zoom" "E")
	(command "_.ZOOM" "0.5x")
	(command "_.UCS" "V")

	(setq #ret$ nil)
	(setq #ename$ nil)
	(setq #cnt 0)
	(setq #flag T)
	(setq #pnt$ (trans &base_pnt$ 0 1))

	(while #flag
		(setq #dp (getvar "lastpoint"))
		(princ "\n�u���[�N���C���ʒu���w��/�I��[ENTER]�F")
		(command ".XLINE" "V" PAUSE)
		(if (= nil (equal 0.0 (distance #dp (getvar "lastpoint")) 0.0001))
			(progn
				(command "")
				(setq #cnt (1+ #cnt))

				(if (>= 2 #cnt)
					(progn
						(setq #ename$ (append #ename$ (list (entlast))))
;						(setq #dist (abs (fix (- (car (getvar "lastpoint")) (car &base_pnt$)))))
						(setq #dist (abs (fix (- (car (getvar "lastpoint")) (car #pnt$)))))
						(setq #ret$ (append #ret$ (list #dist)))
					)
					(progn
						(CFAlertErr "�u���[�N���C���͂Q�ӏ��ȏ�w���ł��܂���")
						(entdel (entlast))
					)
				)
			)
			(setq #flag nil)
		)
	)

	(foreach #en #ename$
		(entdel #en)
	)

	; ���_��߂�
	(command "_.UCS" "W")

	(command "_zoom" "P")
	(command "_zoom" "P")
	(command "_zoom" "P")

	; ���s���[�h��߂�
  (setvar "ORTHOMODE" #orthomode)
;  (command "_layer" "OF" "N_BREAKW" "")
;
;	; ���݉�w��߂�
;	(setvar "CLAYER" #clayer)

	#ret$

) ;StretchCabW_MakeBreakLineD


;<HOM>*************************************************************************
; <�֐���>    : StretchCabW_MakeBreakLineH
; <�����T�v>  : �g�����u���[�N���C�����쐬����
; <�߂�l>    : �g�����u���[�N���C���ʒu���X�g
; <�쐬>      : 11/12/06 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun StretchCabW_MakeBreakLineH (
	&base_pnt$
	&ang				; ��]�p�x�i���W�A���j
  /
	#orthomode #clayer
	#ret$ #ename$ #cnt #flag #dp #dist #en #pnt$ #ang
  )

	; ���s���[�h�̐ݒ�
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)

;	; ���݉�w�̕ύX
;	(setq #clayer (getvar "CLAYER"))
;  (command "_layer" "T" "N_BREAKW" "")
;  (command "_layer" "ON" "N_BREAKW" "")
;	(setvar "CLAYER" "N_BREAKW")

	; ���_�̕ύX
	;(command "_vpoint" "0,-1,0")
;-- 2011/12/15 A.Satoh Mod - S
;;;;;	(C:ChgViewFront)
	(setq #ang (fix (rtd &ang)))	; ���W�A�����p�x�ɕϊ�
	(cond
		((= #ang 90)
			(C:ChgViewSideR)
		)
		((= #ang 180)
			(C:ChgViewBack)
		)
		((= #ang 270)
			(C:ChgViewSideL)
		)
		(T
			(C:ChgViewFront)
		)
	)
;-- 2011/12/15 A.Satoh Mod - E
	(command "._zoom" "E")
	(command "_.ZOOM" "0.5x")
	(command "_.UCS" "V")

	(setq #ret$ nil)
	(setq #ename$ nil)
	(setq #cnt 0)
	(setq #flag T)
	(setq #pnt$ (trans &base_pnt$ 0 1))

	(while #flag
		(setq #dp (getvar "lastpoint"))
		(princ "\n�u���[�N���C���ʒu���w��/�I��[ENTER]�F")
		(command ".XLINE" "H" PAUSE)
		(if (= nil (equal 0.0 (distance #dp (getvar "lastpoint")) 0.0001))
			(progn
				(command "")
				(setq #cnt (1+ #cnt))

				(if (>= 2 #cnt)
					(progn
						(setq #ename$ (append #ename$ (list (entlast))))
;						(setq #dist (abs (fix (- (cadr (getvar "lastpoint")) (cadr &base_pnt$)))))
						(setq #dist (abs (fix (- (cadr (getvar "lastpoint")) (cadr #pnt$)))))
						(setq #ret$ (append #ret$ (list #dist)))
					)
					(progn
						(CFAlertErr "�u���[�N���C���͂Q�ӏ��ȏ�w���ł��܂���")
						(entdel (entlast))
					)
				)
			)
			(setq #flag nil)
		)
	)

	(foreach #en #ename$
		(entdel #en)
	)

	; ���_��߂�
	(command "_.UCS" "W")

	(command "_zoom" "P")
	(command "_zoom" "P")
	(command "_zoom" "P")

	; ���s���[�h��߂�
  (setvar "ORTHOMODE" #orthomode)
;  (command "_layer" "OF" "N_BREAKW" "")
;
;	; ���݉�w��߂�
;	(setvar "CLAYER" #clayer)

	#ret$

) ;StretchCabW_MakeBreakLineH
;-- 2011/12/05 A.Satoh Add - E


;<HOM>*************************************************************************
; <�֐���>    : StretchCab_sub
; <�����T�v>  : �������޺����(����=����ٖ�)�o�[�W����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/10/21 YM
; <���l>      : NAS�p �������޺����
;*************************************************************************>MOH<
(defun StretchCab_sub (
  &SYM
  /
  #EN #HINBAN #LR #LXD$ #SYS$ #XD$
  )
  ; �O����
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)

  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
  (setq CG_TOKU T); �������ގ��s��
  (KP_TOKU_GROBAL_RESET)
  (setq CG_BASE_UPPER nil)

  (if (and &SYM (= 'ENAME (type &SYM))) ; �����
    (progn
      (setq #LXD$ (CFGetXData &SYM "G_LSYM"))
      (setq #HINBAN (nth 5 #LXD$))
      (setq #LR     (nth 6 #LXD$))
      (setq #XD$ (CFGetXData &SYM "G_SYM"))

      ; �������@ð��ق����� 01/10/09 YM MOD-S @@@@@@@@@@@@@@@@@@@@@
      (if (setq CG_QRY$ (GetTokuDim #HINBAN #LR)) ; ��۰���
        (progn ; ����ȯĐL�k���s(ں��ނ�����ꍇ�̂ݑΏ�)
          (PcStretchCab_N &SYM)
          (setq #en nil)
        )
        (progn ; �������@ð��ق�ں��ނ��Ȃ��ꍇ
          (setq #en nil) ; 02/07/09 YM MOD
          ; 02/07/09 YM ADD-S �i��,���i�ύX�޲�۸ނ�\������
          (KPGetHinbanMoney &SYM)
        )
      );_if
      ; �������@ð��ق����� 01/10/09 YM MOD-E @@@@@@@@@@@@@@@@@@@@@

    )
    (progn
      (CFAlertMsg "���̐}�`�͏����Ώۂɂł��܂���")
      (setq #en T)
    )
  );_if


  ; �㏈��
  (CFCmdDefFinish)
  (PKEndCOMMAND #sys$)
  (setq CG_TOKU nil)
  (setq CG_TOKU_BW nil)
  (setq CG_TOKU_BD nil)
  (setq CG_TOKU_BH nil)
  (setq CG_QRY$  nil)
  (KP_TOKU_GROBAL_RESET)

  (setq CG_BASE_UPPER nil)
  (princ)

); StretchCab_sub

;<HOM>*************************************************************************
; <�֐���>    : C:StretchCab
; <�����T�v>  : �L���r�l�b�g�L�k����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/10/09 YM
; <���l>      : NAS�p �������޺����
;*************************************************************************>MOH<
(defun C:StretchCab (
  /
  #EN #HINBAN #LR #LXD$ #SYM #SYS$ #XD$
  )

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
      (defun TempErr ( msg / #msg )
        (setq CG_TOKU nil)
        (setq CG_TOKU_BW nil)
        (setq CG_TOKU_BD nil)
        (setq CG_TOKU_BH nil)
        (setq CG_QRY$  nil)
        (KP_TOKU_GROBAL_RESET)
        (setq CG_BASE_UPPER nil)
        (command "_undo" "b")
        (setq *error* nil)
        (princ)
      )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

  ; �O����
  (setq *error* TempErr)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")

  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
  (setq CG_TOKU T); �������ގ��s��
  (KP_TOKU_GROBAL_RESET)
  (setq CG_BASE_UPPER nil)

  (setq #en 'T)
  (while #en
    (setq #sym nil)
    (setq #en (car (entsel "\n�����Ώۂ̃L���r�l�b�g��I�� : ")))
    (if #en (setq #sym (CFSearchGroupSym #en)))

    (if #sym ; ����ق�����
      (progn
        (setq #LXD$ (CFGetXData #sym "G_LSYM"))
        (setq #HINBAN (nth 5 #LXD$))
        (setq #LR     (nth 6 #LXD$))
        (setq #XD$ (CFGetXData #sym "G_SYM"))

        ; �������@ð��ق����� 01/10/09 YM MOD-S @@@@@@@@@@@@@@@@@@@@@
        (if (setq CG_QRY$ (GetTokuDim #HINBAN #LR)) ; ��۰���
          (progn ; ����ȯĐL�k���s(ں��ނ�����ꍇ�̂ݑΏ�)
            (PcStretchCab_N #sym)
            (setq #en nil)
          )
          (progn ; �������@ð��ق�ں��ނ��Ȃ��ꍇ
            (setq #en nil) ; 02/07/09 YM MOD
            ; 02/07/09 YM ADD-S �i��,���i�ύX�޲�۸ނ�\������
            (KPGetHinbanMoney #sym)
          )
        );_if
        ; �������@ð��ق����� 01/10/09 YM MOD-E @@@@@@@@@@@@@@@@@@@@@

      )
      (progn
        (CFAlertMsg "���̐}�`�͏����Ώۂɂł��܂���")
        (setq #en T)
      )
    );_if

  );while

  ;04/05/26 YM ADD
  (command "_REGEN")

  ; �㏈��
  (setq *error* nil)
  (CFCmdDefFinish)
  (PKEndCOMMAND #sys$)
  (setq CG_TOKU nil)
  (setq CG_TOKU_BW nil)
  (setq CG_TOKU_BD nil)
  (setq CG_TOKU_BH nil)
  (setq CG_QRY$  nil)
  (KP_TOKU_GROBAL_RESET)

  (setq CG_BASE_UPPER nil)
  (princ)

); C:StretchCab

;<HOM>*************************************************************************
; <�֐���>    : C:RegularCab
; <�����T�v>  : ��������ȯĂ����̷���ȯĂɖ߂�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 
; <���l>      : 
;*************************************************************************>MOH<
(defun C:RegularCab (
  /
	#cmdecho #osmode #sys$
	#ss #sym$ #eCH #FIG$ #en
	#xd_LSYM$ #xd_TOKU$ #pt #ang
	#org_w #org_d #org_h #str_w #str_d #str_h
#xd_REG$	;-- 2012/02/16 A.Satoh Add CG�Ή�
#hin_last$  ;-- 2012/02/22 A.Satoh Add
  )

	;****************************************************
	; �G���[����
	;****************************************************
  (defun RegularCabUndoErr( &msg )
    (command "_undo" "b")
    (CFCmdDefFinish)
    (setq *error* nil)
    (princ)
  )
	;****************************************************

  (setq *error* RegularCabUndoErr)
	(command "_UNDO" "M")
	(command "_UNDO" "A" "OFF")
	(setq #cmdecho (getvar "CMDECHO"))
	(setq #osmode (getvar "OSMODE"))
	(setvar "CMDECHO" 0)
	(setvar "OSMODE" 0)
  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
	(setq CG_REGULAR nil)

  (setq CG_BASESYM (CFGetBaseSymXRec))

	; ���ޑI���������s��
;-- 2012/02/15 A.Satoh Mod CG�Ή� - S
;;;;;	(setq #ss (RegularCab_ItemSel '(()("G_TOKU")) CG_InfoSymCol))
	(setq #ss (RegularCab_ItemSel '(()("G_TOKU" "G_REG")) CG_InfoSymCol))
;-- 2012/02/15 A.Satoh Mod CG�Ή� - E

	; �I���������ނ̐F�����ɖ߂��A���ނ̃V���{���}�`�����X�g��Ԃ�
	(setq #sym$ (Toku_HeightChange_ChangeItemColor #ss '(()("G_LSYM")) nil))

	; �������ނ�L�k�O�̕��ށi�W�����ށj�ɓ���ւ���
	(foreach #eCH #sym$
		(setq #xd_LSYM$ (CFGetXData #eCH "G_LSYM"))
		(setq #pt (cdr (assoc 10 (entget #eCH))))
		(setq #ang (nth 2 #xd_LSYM$))
		(setq #xd_TOKU$ (CFGetXData #eCH "G_TOKU"))
;-- 2012/02/15 A.Satoh Mod CG�Ή� - S
;;;;;		(setq #org_w (nth 12 #xd_TOKU$))
;;;;;		(setq #org_d (nth 13 #xd_TOKU$))
;;;;;		(setq #org_h (nth 14 #xd_TOKU$))
;;;;;		(setq #str_w (nth 17 #xd_TOKU$))
;;;;;		(setq #str_d (nth 18 #xd_TOKU$))
;;;;;		(setq #str_h (nth 19 #xd_TOKU$))
		(if #xd_TOKU$ 
			(progn
				(setq #org_w (nth 12 #xd_TOKU$))
				(setq #org_d (nth 13 #xd_TOKU$))
				(setq #org_h (nth 14 #xd_TOKU$))
				(setq #str_w (nth 17 #xd_TOKU$))
				(setq #str_d (nth 18 #xd_TOKU$))
				(setq #str_h (nth 19 #xd_TOKU$))
			)
			(progn
				(setq #xd_REG$ (CFGetXData #eCH "G_REG"))
				(setq #org_w (nth 12 #xd_REG$))
				(setq #org_d (nth 13 #xd_REG$))
				(setq #org_h (nth 14 #xd_REG$))
				(setq #str_w (nth 17 #xd_REG$))
				(setq #str_d (nth 18 #xd_REG$))
				(setq #str_h (nth 19 #xd_REG$))
			)
		)
;-- 2012/02/15 A.Satoh Mod CG�Ή� - E
		(if (or (/= #org_w #str_w) (/= #org_d #str_d) (/= #org_h #str_h))
			(progn
;-- 2012/02/24 A.Satoh Add - S
;-- 2012/02/22 A.Satoh Add - S
;;;;;					(setq #hin_last$ (StretchCabW_GetHinbanLast (nth 5 #xd_LSYM$) (nth 6 #xd_LSYM$)))
;;;;;					(if (= #hin_last$ nil)
;;;;;						(progn
;;;;;							(setq #hin_width  #org_w)
;;;;;							(setq #hin_takasa #org_d)
;;;;;							(setq #hin_depth  #org_h)
;;;;;						)
;;;;;						(progn
;;;;;							(setq #hin_width  (atof (nth 1 #hin_last$)))
;;;;;							(setq #hin_takasa (atof (nth 2 #hin_last$)))
;;;;;							(setq #hin_depth  (atof (nth 3 #hin_last$)))
;;;;;						)
;;;;;					)
;-- 2012/02/22 A.Satoh Add - E
				(setq #hin_last$
					(CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
						(list
							(list "�i�Ԗ���" (nth  5 #xd_LSYM$)        'STR)
							(list "LR�敪"   (nth  6 #xd_LSYM$)        'STR)
							(list "�p�r�ԍ�" (itoa (nth 12 #xd_LSYM$)) 'INT)
						)
					)
				)
				(if (and #hin_last$ (= 1 (length #hin_last$)))
					(progn
						(setq #hin_width  (nth 3 (car #hin_last$)))
						(setq #hin_depth  (nth 4 (car #hin_last$)))
						(setq #hin_takasa (nth 5 (car #hin_last$)))
					)
					(progn
						(setq #hin_width  #org_w)
						(setq #hin_depth  #org_h)
						(setq #hin_takasa #org_d)
					)
				)
;-- 2012/02/24 A.Satoh Add - E

;-- 2012/02/23 A.Satoh Add - S
				; �A���������ɔ��̐L�k���s���B
; �����I�Ƀ��C���t���[���\���ɕύX����B
				(C:2DWire)
;-- 2012/02/23 A.Satoh Add - E

				(setq #FIG$
					(list
						(nth 5 #xd_LSYM$)
						(nth 0 #xd_LSYM$)
						0
						(nth 12 #xd_LSYM$)
						(nth 6 #xd_LSYM$)
;-- 2012/02/22 A.Satoh Mod - S
;;;;;						#org_w
;;;;;						#org_d
;;;;;						#org_h
						#hin_width
						#hin_depth
						#hin_takasa
;-- 2012/02/22 A.Satoh Mod - E
						(nth 9 #xd_LSYM$)
						""
						(nth 8 #xd_LSYM$)
						(nth 15 #xd_LSYM$)
					)
				)
				(setq CG_REGULAR T)
				(setq #en (PcSetItem "CHG" nil #FIG$ #pt #ang nil #eCH))
				(setq #eCH nil)
			)
			(progn
				(if #xd_TOKU$
					(CFSetXData #eCH "G_TOKU" nil)
				)
				(if #xd_REG$
					(CFSetXData #eCH "G_REG" nil)
				)
			)
		)
	)

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

  (CFCmdDefFinish)
  (PKEndCOMMAND #sys$)
	(setvar "CMDECHO" #cmdecho)
	(setvar "OSMODE" #osmode)
	(setq CG_REGULAR nil)
	(setq *error* nil)

;  (alert "�������@�H�����@������")

  (princ)
);C:RegularCab


;-- 2011/12/03 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : RegularCab_ItemSel
; <�����T�v>  : �����ꊇ�ύX�Ώۂ̕��ޑI�����s��
; <�߂�l>    : �I�𕔍ނ̑I���Z�b�g or nil(���I��)
; <�쐬>      : 11/11/30 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun RegularCab_ItemSel (
	&XDataLst$$
	&iCol
  /
	#enp #pp1 #pp2 #en #ssRet #ss #sswork #gmsg #i #ii #setflag
	#engrp #ssgrp #xd$ #ENR
  )

  ;*********************************************
  ; �J��Ԃ����т̑I��
  ;*********************************************
  (setq #ssRet (ssadd))
  (setq #pp1 T)
  (while #pp1
    ;---------------------------------------------
    ; ���ш��I���̏���
    ;---------------------------------------------
    (setq org*error* *error*)   ;ItemSel���ꏈ�� ���X��*error*�֐����L��
    (setq *error* cancel*error*);ItemSel���ꏈ�� *error*�֐���ItemSel�p�̊֐���킹��
    (setq #enp (entselpoint "\n�A�C�e����I��:"))
    (setq *error* org*error*)   ;ItemSel���ꏈ�� ���X��*error*�֐��ɖ߂�
    (setq #pp1 (cadr #enp))
    ;�����݉���
    (if #pp1 
			(progn
      	(setq #en #enp)
	      ;�I��_�ɵ�޼ު�Ă���
  	    (if (car #en)
    	    (progn
      	    ;�I���޼ު�Ă�I��Ăɉ��Z
        	  (setq #ss (ssadd))
          	(ssadd (car #en) #ss)
	        )
  	      (progn
    	      ;���w�菈��
      	    (setq #pp2 nil)
        	  (setq #gmsg " ��������̺�Ű���w��:")
          	(while (not #pp2);��Ű���I�������܂�ٰ��
            	(setq #pp2 (getcorner #pp1 #gmsg))
	            (if #pp2
  	            ;�����݉���
    	          (progn
      	          (if (< (car (trans #pp1 0 2)) (car (trans #pp2 0 2)))
        	          ;�����E�I��
          	        (progn
            	        (setq #sswork (ssget "W" #pp1 #pp2))
              	      (setq #ss (ItemSurplus #sswork &XDataLst$$))
                	    (setq #sswork  nil)
                  	)
	                  ;�E����
  	                (progn
    	                (setq #ss (ssget "C" #pp1 #pp2))
      	            )
        	        )
          	    )
            	  ;�E���݉���
              	(progn
                	(princ "\n���̎w�肪�����ł�.")
	                (setq #gmsg "\n�A�C�e����I��: ��������̺�Ű���w��:")
  	            )
    	        )
      	    )
        	)
	      )
  	  )
		)

    ;---------------------------------------------
    ;�I���A�C�e���̐F��ς���
    ;---------------------------------------------
    (if #ss
			(progn
				; �I�������A�C�e�����������ނł��邩���`�F�b�N����
				(setq #ssGrp (RegularCab_CheckItemToku #ss))

				; �I�������A�C�e���̐F��I��F(RED)�ɕς���
				(if #ssGrp
	      	(setq #ssGrp (ChangeItemColor #ssGrp &XDataLst$$ &iCol))
				)

      	;�F��ς������т�߂�l�I��Ă։��Z
	      (setq #i 0)
  	    (repeat (sslength #ssGrp)
    	    (ssadd (ssname #ssGrp #i) #ssRet)
      	  (setq #i (1+ #i))
      	)

				; �I�������A�C�e�����i�Ԋ�{�ɓo�^����Ă��邩���`�F�b�N
  	    ;�I��Ă��芎�F�ύX�����A�C�e���������ꍇ�A�I��s�̃A�C�e���Ƃ݂Ȃ��B
    	  (if (and (> (sslength #ss) 0) (<= (sslength #ssGrp) 0))
      	  (CFAlertErr "���̃A�C�e���͑I���ł��܂���B")
	      )
  	    (setq #ss nil)
    	  (setq #ssGrp nil)
	    )
		)
  )

  ;*********************************************
  ; �Ώۏ������ёI��
  ;*********************************************
  (setq #enR 'T)
  ;�E���݉���or�߂�l�I��Ă��Ȃ��Ȃ�����I��
  (while (and #enR (> (sslength #ssRet) 0))
    (setq #enR (car (entsel "\n�Ώۂ��珜���A�C�e����I��:")))
    ;�߂�l�I��Ă����ް�̂ݏ�������B
    (if (and #enR (ssmemb #enR #ssRet))
			(progn
	      ;�ꎞ�I�ɑI��Ă��쐬
  	    (setq #sswork (ssadd))
    	  (ssadd #enR #sswork)
      	;�I���т̐F��߂�
	      (setq #ssGrp (ChangeItemColor #sswork &XDataLst$$ nil))
  	    ;�F��߂������т�߂�l�I��Ă��珜��
    	  (setq #i 0)
      	(repeat (sslength #ssGrp)
        	(ssdel (ssname #ssGrp #i) #ssRet)
	        (setq #i (1+ #i))
  	    )
    	  (setq #sswork nil)
      	(setq #ssGrp nil)
	    )
		)
  )

  #ssRet

);RegularCab_ItemSel


;<HOM>*************************************************************************
; <�֐���>    : RegularCab_CheckItemToku
; <�����T�v>  : �I�������A�C�e�����������ނł��邩�ǂ������`�F�b�N����
; <�߂�l>    : �������ޑI���Z�b�g or nil
; <�쐬>      : 11/12/03 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun RegularCab_CheckItemToku (
  &ss
  /
	#ssRet #idx #idx2 #en #engrp #ssGrp
  )

	(setq #ssRet (ssadd))
	(setq #idx 0)

	(repeat (sslength &ss)
		(setq #en (ssname &ss #idx))
		(if (not (ssmemb #en #ssRet))
;-- 2012/02/15 A.Satoh Mod CG�Ή� - S
;;;;;			(if (and (setq #engrp (SearchGroupSym #en))
;;;;;							 (setq #ssGrp (CFGetSameGroupSS #engrp))
;;;;;							 (CheckXData #engrp (list "G_TOKU")))
			(if (and (setq #engrp (SearchGroupSym #en))
							 (setq #ssGrp (CFGetSameGroupSS #engrp))
							 (or (CheckXData #engrp (list "G_TOKU"))
							     (CheckXData #engrp (list "G_REG"))))
;-- 2012/02/15 A.Satoh Mod CG�Ή� - E
				(progn
					;�߂�l�I��Ăɉ��Z
					(setq #idx2 0)
					(repeat (sslength #ssGrp)
						(ssadd (ssname #ssGrp #idx2) #ssRet)
						(setq #idx2 (1+ #idx2))
					)
					(setq #ssGrp nil)
				)
			)
		)
		(setq #idx (1+ #idx))
	)

	#ssRet

);RegularCab_CheckItemToku
;-- 2011/12/03 A.Satoh Add - E


;<HOM>*************************************************************************
; <�֐���>    : C:Toku_HeightChange
; <�����T�v>  : ���݂��ƈꊇ���č����ύX����(ж�޹�АL�k)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 
; <���l>      : ж�޹�АL�k����ނƎ��Ă��邪��Ђł͂Ȃ����ʂ�L�k����
;*************************************************************************>MOH<
(defun C:Toku_HeightChange (
  /
	#BASESYM #err_flag #cmdecho #osmode
	#planinfo$ #wt_height #size #ss #sym$$ #buzai$$ #action
	#flag
  )

	;****************************************************
	; �G���[����
	;****************************************************
	(defun TempErr ( msg / #msg )
		(command "_undo" "b")
		(setvar "CMDECHO" #cmdecho)
		(setvar "OSMODE" #osmode)
;-- 2012/02/20 A.Satoh Add CG�Ή� - S
		(setq CG_SizeH nil)
;-- 2012/02/20 A.Satoh Add CG�Ή� - E
		(setq *error* nil)
		(princ)
	)
	;****************************************************

	; �O����
	(setq *error* TempErr)
	(command "_UNDO" "M")
	(command "_UNDO" "A" "OFF")
	(setq #cmdecho (getvar "CMDECHO"))
	(setq #osmode (getvar "OSMODE"))
	(setvar "CMDECHO" 0)
	(setvar "OSMODE" 0)

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

	; SERIES�ʃf�[�^�x�[�X�ւ̐ڑ�
	(if (= CG_DBSESSION nil)
		(progn
			(princ "\n������ SERIES�ʃf�[�^�x�[�X�ւ̍Đڑ� ������")
			(setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
		)
	)

	; �f�[�^�x�[�X�ւ̍Đڑ�
	; �Đڑ����s���̏���
	(if (= CG_DBSESSION nil)
		(progn
			(princ "\n������ �Z�b�V�����Ď擾 ������")
      (princ (strcat "\n�������@asilisp.arx���ă��[�h����DB��CONNECT�@������"))

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

			(setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
		)
	)
	(princ "\n�������@CG_DBSESSION�@������ :")(princ CG_DBSESSION)

	(setq #BASESYM (CFGetBaseSymXRec)) ; �����
	(setq #err_flag nil)

	; �����ꊇ�ύX��ʏ������s��
	(setq #size (Toku_HeightChange_SelectStrechSizeDlg))
	(if (= #size nil)
		(setq #err_flag T)
	)

	;2013/04/01 YM ADD-S
	(Kakunin)
	;2013/04/01 YM ADD-E

	(if (= #err_flag nil)
		(progn
			; ���ޑI���������s��
			(setq #ss (Toku_HeightChange_ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_InfoSymCol #size))

			; �I�𕔍ނ̐F�����ɖ߂�
			(setq #sym$$ (Toku_HeightChange_ChangeItemColor #ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil))

			; �I�������A�C�e���̏��������擾
			(setq #buzai$$ (Toku_HeightChange_GetItemHinbanKihon #sym$$ #size))

;-- 2012/02/23 A.Satoh Add - S
			; �A���������ɔ��̐L�k���s���B
      ; �����I�Ƀ��C���t���[���\���ɕύX����B
			(C:2DWire)
;-- 2012/02/23 A.Satoh Add - E

			; ���ނ̐L�k�܂��͈ړ����s��
			(TokuBuzaiStretch #buzai$$ #size)

			; �����L���r������
			(if (= nil (tblsearch "APPID" "G_TOKU")) (regapp "G_TOKU"))
			(setq #flag T)
			(foreach #buzai$ #buzai$$
				(if (= #flag T)
					(progn
						(setq #action (cadr #buzai$))
						(if (/= #action "M")
							(progn
								(setq #flag (TokuCab_InputTokuData #buzai$ #size #BASESYM))
								(if (= #flag nil)
									(command "_undo" "b")
								)
							)
						)
					)
				)
			)
		)
	)
;-- 2012/02/20 A.Satoh Add CG�Ή� - S
	(setq CG_SizeH nil)
;-- 2012/02/20 A.Satoh Add CG�Ή� - E
	(setvar "CMDECHO" #cmdecho)
	(setvar "OSMODE" #osmode)
	(setq *error* nil)

;  (alert "�������@�H�����@������")

  (princ)
);C:Toku_HeightChange


;<HOM>*************************************************************************
; <�֐���>    : Kakunin
; <�����T�v>  : �����ꊇ�ύX�̂Ƃ��ɉ���EP�����݂���΃��b�Z�[�W��\������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2013/04/01 YM ADD
; <���l>      :
;*************************************************************************>MOH<
(defun Kakunin (
  /
	#BASE_FLG #ENSS$ #I #SKK$
  )
	(setq #BASE_FLG nil);����EP�����׸�
	
  (setq #enSS$ (ssget "X" '((-3 ("G_LSYM")))))
  (setq #i 0)
  (repeat (sslength #enSS$)
		(ssname #enSS$ #i)
    (setq #skk$ (CFGetSymSKKCode (ssname #enSS$ #i) nil))
    (if (and (= (car #skk$) CG_SKK_ONE_SID)(= (cadr #skk$) CG_SKK_TWO_BAS))
      (setq #BASE_FLG T) ;���䂪����� T
    );_if
;;;    (if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) CG_SKK_TWO_UPP))
;;;      (setq #UPPER_FLG T);��䂪����� T
;;;    );_if
    (setq #i (1+ #i))
  );repeat

	;����EP�����݂���΃��b�Z�[�W�\��
	(if #BASE_FLG
		(CFYesDialog "\�K�v�ɉ����ăG���h�p�l���̍����ύX���s�Ȃ��ĉ������B")
	);_if
	(princ)
);Kakunin

;-- 2011/11/25 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : Toku_HeightChange_SelectStrechSizeDlg
; <�����T�v>  : �����ꊇ�ύX��ʂ���̎w��ɂ��A�L�k���������߂�
; <�߂�l>    : �V����80cm�F-50mm�L�k
;             : �V����90cm�F50mm�L�k
;             : �L�����Z���{�^�������Fnil
; <�쐬>      : 11/11/25 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_SelectStrechSizeDlg (
  /
	#dcl_id #next #ret
  )

	;***********************************************************************
	; �n�j�{�^����������
	; �߂�l:�L�k�T�C�Y(50 or -50)
	;***********************************************************************
	(defun ##SelectStrechSize_CallBack (
		/
		#err_flag #size #wt_80 #wt_90
		)

		(setq #err_flag nil)
		(setq #size nil)

		(setq #wt_80 (get_tile "WT80"))
		(setq #wt_90 (get_tile "WT90"))

		; ���̓`�F�b�N
		; ���W�I�{�^�����I������Ă��Ȃ�
		(if (and (= #wt_80 "0") (= #wt_90 "0"))
			(progn
				(set_tile "error" "�V�������I������Ă��܂���B")
				(setq #err_flag T)
			)
		)

		(if (= #err_flag nil)
			(progn
				(if (= #wt_80 "1")
					(setq #size -50)
					(setq #size 50)
				)

				(done_dialog 1)
			)
		)

		#size
	)
	;***********************************************************************

	; �����ꊇ�ύX��ʕ\��
	(setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kcmain.dcl")))
	(if (not (new_dialog "SelectStrechSizeDlg" #dcl_id)) (exit))

	(setq #next 99)
	(while (and (/= 1 #next) (/= 0 #next))
		; �{�^����������
  	(action_tile "accept" "(setq #ret (##SelectStrechSize_CallBack))")
  	(action_tile "cancel" "(setq #ret nil) (done_dialog 0)")

  	(setq #next (start_dialog))
	)

  (unload_dialog #dcl_id)

	#ret

);Toku_HeightChange_SelectStrechSizeDlg


;<HOM>*************************************************************************
; <�֐���>    : Toku_HeightChange_ItemSel
; <�����T�v>  : �����ꊇ�ύX�Ώۂ̕��ޑI�����s��
; <�߂�l>    : �I�𕔍ނ̑I���Z�b�g or nil(���I��)
; <�쐬>      : 11/11/30 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_ItemSel (
	&XDataLst$$
	&iCol
	&size
  /
	#enp #pp1 #pp2 #en #ssRet #ss #sswork #gmsg #i #ii #setflag
	#engrp #ssgrp #xd$
	#Item$ #err_flag #enR
  )

  ;*********************************************
  ; �J��Ԃ����т̑I��
  ;*********************************************
  (setq #ssRet (ssadd))
  (setq #pp1 T)
  (while #pp1
    ;---------------------------------------------
    ; ���ш��I���̏���
    ;---------------------------------------------
    (setq org*error* *error*)   ;ItemSel���ꏈ�� ���X��*error*�֐����L��
    (setq *error* cancel*error*);ItemSel���ꏈ�� *error*�֐���ItemSel�p�̊֐���킹��
    (setq #enp (entselpoint "\n�A�C�e����I��:"))
    (setq *error* org*error*)   ;ItemSel���ꏈ�� ���X��*error*�֐��ɖ߂�
    (setq #pp1 (cadr #enp))
    ;�����݉���
    (if #pp1 
			(progn
      	(setq #en #enp)
	      ;�I��_�ɵ�޼ު�Ă���
  	    (if (car #en)
    	    (progn
      	    ;�I���޼ު�Ă�I��Ăɉ��Z
        	  (setq #ss (ssadd))
          	(ssadd (car #en) #ss)
	        )
  	      (progn
    	      ;���w�菈��
      	    (setq #pp2 nil)
        	  (setq #gmsg " ��������̺�Ű���w��:")
          	(while (not #pp2);��Ű���I�������܂�ٰ��
            	(setq #pp2 (getcorner #pp1 #gmsg))
	            (if #pp2
  	            ;�����݉���
    	          (progn
      	          (if (< (car (trans #pp1 0 2)) (car (trans #pp2 0 2)))
        	          ;�����E�I��
          	        (progn
            	        (setq #sswork (ssget "W" #pp1 #pp2))
              	      (setq #ss (ItemSurplus #sswork &XDataLst$$))
                	    (setq #sswork  nil)
                  	)
	                  ;�E����
  	                (progn
    	                (setq #ss (ssget "C" #pp1 #pp2))
      	            )
        	        )
          	    )
            	  ;�E���݉���
              	(progn
                	(princ "\n���̎w�肪�����ł�.")
	                (setq #gmsg "\n�A�C�e����I��: ��������̺�Ű���w��:")
  	            )
    	        )
      	    )
        	)
	      )
  	  )
		)

    ;---------------------------------------------
    ;�I���A�C�e���̐F��ς���
    ;---------------------------------------------
    (if #ss
			(progn
				; �I�������A�C�e�����i�Ԋ�{�ɓo�^����Ă��邩�ۂ����`�F�b�N
				(setq #Item$ (Toku_HeightChange_CheckItemHinbanKihon #ss &size))
				(setq #ssGrp (car #Item$))
				(setq #err_flag (cadr #Item$))

				(if #ssGrp
	      	(setq #ssGrp (ChangeItemColor #ssGrp &XDataLst$$ &iCol))
				)

      	;�F��ς������т�߂�l�I��Ă։��Z
	      (setq #i 0)
  	    (repeat (sslength #ssGrp)
    	    (ssadd (ssname #ssGrp #i) #ssRet)
      	  (setq #i (1+ #i))
      	)

				; �I�������A�C�e�����i�Ԋ�{�ɓo�^����Ă��邩���`�F�b�N
  	    ;�I��Ă��芎�F�ύX�����A�C�e���������ꍇ�A�I��s�̃A�C�e���Ƃ݂Ȃ��B
    	  (if (and (> (sslength #ss) 0) (<= (sslength #ssGrp) 0))
					(if (= #err_flag 0)
						(CFAlertErr "���̃A�C�e���͑I���ł��܂���B")
						(CFAlertErr "���ɍ����ύX���s���Ă��܂��B")
					)
	      )
  	    (setq #ss nil)
    	  (setq #ssGrp nil)
	    )
		)
  )

  ;*********************************************
  ; �Ώۏ������ёI��
  ;*********************************************
  (setq #enR 'T)
  ;�E���݉���or�߂�l�I��Ă��Ȃ��Ȃ�����I��
  (while (and #enR (> (sslength #ssRet) 0))
    (setq #enR (car (entsel "\n�Ώۂ��珜���A�C�e����I��:")))
    ;�߂�l�I��Ă����ް�̂ݏ�������B
    (if (and #enR (ssmemb #enR #ssRet))
			(progn
	      ;�ꎞ�I�ɑI��Ă��쐬
  	    (setq #sswork (ssadd))
    	  (ssadd #enR #sswork)
      	;�I���т̐F��߂�
	      (setq #ssGrp (ChangeItemColor #sswork &XDataLst$$ nil))
  	    ;�F��߂������т�߂�l�I��Ă��珜��
    	  (setq #i 0)
      	(repeat (sslength #ssGrp)
        	(ssdel (ssname #ssGrp #i) #ssRet)
	        (setq #i (1+ #i))
  	    )
    	  (setq #sswork nil)
      	(setq #ssGrp nil)
	    )
		)
  )

  #ssRet

);Toku_HeightChange_ItemSel


;<HOM>*************************************************************************
; <�֐���>    : Toku_HeightChange_ChangeItemColor
; <�����T�v>  : �I�𕔍ނ�����̐F�ɕύX���A�Ώۂ̃V���{�����X�g��Ԃ�
; <�߂�l>    : �V���{�����X�g
; <�쐬>      : 11/12/01
; <���l>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_ChangeItemColor(
	&ss
	&XDataLst$$
	&iCol
  /
	#ss #engrp$ #ssdum #idx #idx2 #engrp #ssGrp #en
  )

	; �I���Z�b�g�Ɋ܂܂�镔�ނ̐F��ύX����
	(setq #ss (ChangeItemColor &ss &XDataLst$$ &iCol))

	(setq #engrp$ nil)
	(setq #ssdum (ssadd))
	(setq #idx 0)

	(repeat (sslength #ss)
		(setq #en (ssname #ss #idx))
		(if (not (ssmemb #en #ssdum))
			(if (and (setq #engrp (SearchGroupSym #en))				; ����ق���
							 (setq #ssGrp (CFGetSameGroupSS #engrp)))	; ��ٰ�ߑS��
		 		(progn
					(setq #engrp$ (cons #engrp #engrp$))
					(setq #idx2 0)
					(repeat (sslength #ssGrp)
						(ssadd (ssname #ssGrp #idx2) #ssdum)
						(setq #idx2 (1+ #idx2))
					)
					(setq #ssGrp nil)
				)
				(progn
					(setq #engrp$ (cons #en #engrp$))
					(ssadd #en #ssdum)
				)
			)
		)
		(setq #idx (1+ #idx))
	)

	#engrp$

);Toku_HeightChange_ChangeItemColor


;<HOM>*************************************************************************
; <�֐���>    : Toku_HeightChange_CheckItemHinbanKihon
; <�����T�v>  : �I�������A�C�e�����i�Ԋ�{�ɓo�^����Ċ������ύX�̑Ώۂ�
;             : �ł��邩���`�F�b�N����
; <�߂�l>    : �����ύX�ΏۃA�C�e���I���Z�b�g or nil
; <�쐬>      : 11/11/30 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_CheckItemHinbanKihon (
  &ss
	&size
  /
	#ssRet #idx #idx2 #idx3 #en #en2 #enR
	#sym #engrp #ssGrp #xd_LSYM$ #hinban #seikaku #action
	#qry$$ #xd_WRKT$ #sswork #xd_SYM$
	#err_flag #xd_TOKU$ #org_height #str_height
  )

	(setq #ssRet (ssadd))
	(setq #idx 0)
	(setq #err_flag 0)

	(repeat (sslength &ss)
		(setq #en (ssname &ss #idx))
		(if (not (ssmemb #en #ssRet))
			(if (and (setq #sym (SearchGroupSym #en))
							 (setq #ssGrp (CFGetSameGroupSS #sym)))
				(progn
					(setq #xd_TOKU$ (CFGetXData #sym "G_TOKU"))
					(if (/= #xd_TOKU$ nil)
						(progn
							(setq #org_height (nth 14 #xd_TOKU$))		; ���}�`�T�C�Y�g
							(setq #str_height (nth 19 #xd_TOKU$))		; �L�k��}�`�T�C�Y�g
							; �}�`�T�C�Y�g(����)���L�k����Ă���΍����ύX���s��Ȃ�
							(if (not (equal #org_height #str_height 0.0001))
								(setq #err_flag 1)
							)
						)
;-- 2011/12/16 A.Satoh Add - S
						(progn
							(setq #xd_SYM$ (CFGetXData #sym "G_SYM"))
							(if #xd_SYM$
								(if (not (equal (nth 13 #xd_SYM$) 0.0 0.0001))
									(setq #err_flag 1)
								)
								(setq #err_flag 1)
							)
						)
;-- 2011/12/16 A.Satoh Add - E
					)

					(if (= #err_flag 0)
						(progn
							(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
							(if #xd_LSYM$
								(progn
									(setq #hinban (nth 5 #xd_LSYM$))
									(setq #seikaku (nth 9 #xd_LSYM$))

									(setq #qry$$
										(CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
											(list
												(list "�i�Ԗ���" #hinban 'STR)
												(list "���iCODE" (itoa (fix #seikaku)) 'INT)
											)
										)
									)

									(if (/= #qry$$ nil)
										(if (= (length #qry$$) 1)
											(progn
												(if (> 0 &size)
													(setq #action (nth 8 (nth 0 #qry$$)))
													(setq #action (nth 9 (nth 0 #qry$$)))
												)
												(if (/= #action "X")
													(progn
														;�߂�l�I��Ăɉ��Z
														(setq #idx2 0)
														(repeat (sslength #ssGrp)
															(ssadd (ssname #ssGrp #idx2) #ssRet)
															(setq #idx2 (1+ #idx2))
														)
														(setq #ssGrp nil)
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
				(if (setq #xd_WRKT$ (CFGetXData #en "G_WRKT"))
					(progn
						; ���_����ɐݒ�
						(command "vpoint" "0,0,1")
						(setq #sswork (Toku_HeightChange_PCW_ChColWTItemSSret #en))

						; ���_��߂�
						(command "zoom" "p")

						(if (/= (setq #enR (nth 49 #xd_WRKT$)) "")
							; BG�}�`��I���Z�b�g�ɉ��Z
							(ssadd #enR #ssRet)
						)
						(if (/= (setq #enR (nth 50 #xd_WRKT$)) "")
							; FG�}�`��I���Z�b�g�ɉ��Z
							(ssadd #enR #ssRet)
						)

						; ���[�N�g�b�v��I���Z�b�g�ɉ��Z
						(ssadd #en #ssRet)

						(setq #idx2 0)
						(repeat (sslength #sswork)
							(setq #en2 (ssname #sswork #idx2))
							(if (not (ssmemb #en2 #ssRet))
								(cond
									;��ٰ�߱��� �ݸ�Ȃ�
									((and (setq #engrp (SearchGroupSym #en2))
												(setq #ssGrp (CFGetSameGroupSS #engrp))
												(CheckXData #engrp (list "G_LSYM")))
										;�߂�l�I��Ăɉ��Z
										(setq #idx3 0)
										(repeat (sslength #ssGrp)
											(ssadd (ssname #ssGrp #idx3) #ssRet)
											(setq #idx3 (1+ #idx3))
										)
										(setq #ssGrp nil)
									)
									(T; �ޯ��ް�ނȂ�
										; �I��Ăɉ��Z
										(ssadd (ssname #sswork #idx2) #ssRet)
									)
								)
							)
							(setq #idx2 (1+ #idx2))
						)
						(setq #sswork nil)
					)
				)
			)
		)

		(setq #idx (1+ #idx))
	)

	(list #ssRet #err_flag)

);Toku_HeightChange_CheckItemHinbanKihon


;<HOM>*************************************************************************
; <�֐���>    : Toku_HeightChange_PCW_ChColWTItemSSret
; <�����T�v>  : ���[�N�g�b�v��n���āAWT,BG,FG,�y�т����̒�ʐ}�`+��������
;             : �I���Z�b�g��Ԃ�
;             : ���֐��ł���uPCW_ChColWTItemSSret�v�͐F�ς����s�����A�{�֐���
;             : �F�ς����s��Ȃ�
; <�߂�l>    : �I���Z�b�g
; <�쐬>      : 11/12/05 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_PCW_ChColWTItemSSret (
  &wtEn  ;(ENAME)WT�}�`
  /
	#ssRet #xd_WRKT$ #tei #pt$ #pt2$ #sym$ #sym #hole
	#ssGrp #idx #G_WTR$ #G_WTR #cut1 #cut2 #cut3 #cut4
  )

	(setq #ssRet (ssadd)) ; �߂�l�I���

	(setq #xd_WRKT$ (CFGetXData &wtEn "G_WRKT"))
	(ssadd &wtEn #ssRet)
	(ssadd (nth 38 #xd_WRKT$) #ssRet) ; WT���

	; [60]�O�`�������� START
	(if (and (nth 59 #xd_WRKT$) (/= "" (nth 59 #xd_WRKT$)) (entget (nth 59 #xd_WRKT$)))
		(ssadd (nth 59 #xd_WRKT$) #ssRet) ; WT���
	)

	; WT��ʐ}�`�����
	(setq #tei (nth 38 #xd_WRKT$))

	; �O�`�_��
	(setq #pt$ (GetLWPolyLinePt #tei))

	; �I�_�̎��Ɏn�_��ǉ����ė̈���͂�
	(setq #pt2$ (append #pt$ (list (car #pt$))))

	; �̈�Ɋ܂܂��A�V���N,��������������
	(setq #sym$ (PKGetSinkSuisenSymCP #pt2$))
	(foreach #sym #sym$
		(if (= (nth 9 (CFGetXData #sym "G_LSYM")) CG_SKK_INT_SNK)
			(progn
				(setq #hole (nth 3 (CFGetXData #sym "G_SINK")))
				(if (and #hole (/= #hole "")(entget #hole))
					(ssadd #hole #ssRet)
				)
			)
		)

		(setq #ssGrp (CFGetSameGroupSS #sym))
		(setq #idx 0)
		(repeat (sslength #ssGrp)
			(ssadd (ssname #ssGrp #idx) #ssRet)
			(setq #idx (1+ #idx))
		)
		(setq #ssGrp nil)
	)

	; �̈�Ɋ܂܂�鐅����"G_WTR"ؽ�
	(setq #G_WTR$ (PKGetG_WTRCP #pt2$)) 
	(foreach #G_WTR #G_WTR$
		(ssadd #G_WTR #ssRet)
	)

	(setq #cut1 (nth 60 #xd_WRKT$))
	(if (and #cut1 (/= #cut1 "") (handent #cut1) (entget (handent #cut1)))
		(ssadd (handent #cut1) #ssRet)
	)

	(setq #cut2 (nth 61 #xd_WRKT$))
	(if (and #cut2 (/= #cut2 "") (handent #cut2) (entget (handent #cut2)))
		(ssadd (handent #cut2) #ssRet)
	)

	(setq #cut3 (nth 62 #xd_WRKT$))
	(if (and #cut3 (/= #cut3 "") (handent #cut3) (entget (handent #cut3)))
		(ssadd (handent #cut3) #ssRet)
	)

	(setq #cut4 (nth 63 #xd_WRKT$))
	(if (and #cut4 (/= #cut4 "") (handent #cut4) (entget (handent #cut4)))
		(ssadd (handent #cut4) #ssRet)
	)

	; BG1
	(if (/= (nth 49 #xd_WRKT$) "")
		(progn
			(ssadd (nth 49 #xd_WRKT$) #ssRet)

			(if (= (cdr (assoc 0 (entget (nth 49 #xd_WRKT$)))) "3DSOLID")
				(ssadd (nth  1 (CFGetXData (nth 49 #xd_WRKT$) "G_BKGD")) #ssRet)
			)
		)
	)

	; BG2
	(if (/= (nth 50 #xd_WRKT$) "")
		(progn
			(ssadd (nth 50 #xd_WRKT$) #ssRet)

			(if (= (cdr (assoc 0 (entget (nth 50 #xd_WRKT$)))) "3DSOLID")
				(ssadd (nth 1 (CFGetXData (nth 50 #xd_WRKT$) "G_BKGD")) #ssRet)
			)
		)
	)

	; FG1
	(if (/= (nth 51 #xd_WRKT$) "")
		(ssadd (nth 51 #xd_WRKT$) #ssRet)
	)

	; FG2
	(if (/= (nth 52 #xd_WRKT$) "")
		(ssadd (nth 52 #xd_WRKT$) #ssRet)
	)

	; ������  ��ŏ���������
	(setq #idx 23)
	(repeat (nth 22 #xd_WRKT$)
		(if (nth #idx #xd_WRKT$)
			(if (entget (nth #idx #xd_WRKT$))
				(ssadd (nth #idx #xd_WRKT$) #ssRet)
			)
		)
		(setq #idx (1+ #idx))
	)

  #ssRet

);Toku_HeightChange_PCW_ChColWTItemSSret


;<HOM>*************************************************************************
; <�֐���>    : Toku_HeightChange_GetItemHinbanKihon
; <�����T�v>  : �I�������A�C�e���ɊY������u���[�N���C���ʒu�����i�Ԋ�{����
;             : �擾����
; <�߂�l>    : ���ސ}�`���ƃu���[�N���C���A�W��ID��񃊃X�g
;             :  ((�}�`�� "S30" "A20") (�}�`�� "M" "A30")�E�E(�}�`�� "S30" "A40"))
; <�쐬>      : 11/12/01 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_GetItemHinbanKihon (
  &en$
	&size
  /
	#ret$ #idx #en #xd_LSYM$ #xd_SYM$ #XD_WRKT$ #hinban #seikaku
	#qry$$ #syuyaku #action #width #depth #height
  )

	(setq #ret$ nil)
	(setq #idx 0)

	(repeat (length &en$)
		(setq #en (nth #idx &en$))
		(setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
		(if #xd_LSYM$
			(progn
				(setq #xd_SYM$ (CFGetXData #en "G_SYM"))
				(setq #hinban (nth 5 #xd_LSYM$))
				(setq #seikaku (nth 9 #xd_LSYM$))
				(setq #width  (nth 3 #xd_SYM$))
				(setq #depth  (nth 4 #xd_SYM$))
				(setq #height (nth 5 #xd_SYM$))

				; �V���N����ѐ����͑ΏۂɊ܂߂Ȃ�
				(if (and (/= #seikaku CG_SKK_INT_SUI)
								 (/= #seikaku CG_SKK_INT_SNK))
					(progn
						(setq #qry$$
							(CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
								(list
									(list "�i�Ԗ���" #hinban 'STR)
									(list "���iCODE" (itoa (fix #seikaku)) 'INT)
								)
							)
						)

						(if (/= #qry$$ nil)
							(if (= (length #qry$$) 1)
								(progn
									(setq #syuyaku (nth 5 (car #qry$$)))
									(if (> 0 &size)
										(setq #action (nth 8 (car #qry$$)))
										(setq #action (nth 9 (car #qry$$)))
									)

									(setq #ret$ (append #ret$ (list (list #en #action #syuyaku (list #width #depth #height)))))
								)
							)
						)
					)
				)
			)
			(if (setq #xd_WRKT$ (CFGetXData #en "G_WRKT"))
				(setq #ret$ (append #ret$ (list (list #en "M" "" '()))))
			)
		)
		(setq #idx (1+ #idx))
	)

	#ret$

);Toku_HeightChange_GetItemHinbanKihon


;<HOM>*************************************************************************
; <�֐���>    : TokuBuzaiStretch
; <�����T�v>  : �w�蕔�ނ̐L�k�E�ړ����s��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 11/12/01 A.Satoh
; <���l>      : 12/2 ���_�ł�H�����̂ݑΉ�
;             : �����L���r�Ή�����W�����AD���������킹�đΉ�
;*************************************************************************>MOH<
(defun TokuBuzaiStretch (
  &buzai$$
	&size
  /
	#sym #action #buzai$
	#ss #ss_arw #buf #iCol #xd_WRKT$ #sswork 	#en
	#idx #ssdum #engrp #ssGrp #idx2 #xd$ #wt_flg
	#xd_SYM$ #xd_LSYM$
	#str_width #str_depth #str_height #pt #ang #gnam #eD
	#BrkW #eDelBRK_W$ #XLINE_W
	#BrkD #eDelBRK_D$ #XLINE_D
	#BrkH #eDelBRK_H$ #XLINE_H
#doorID  ;-- 2012/03/23 A.Satoh Add
#CG_SizeH ;2013/01/07 YM ADD
#HINBAN #QRY$ #SKK #TOKU_KIGO ;2013/11/04 YM ADD
  )

	(foreach #buzai$ &buzai$$
		(setq #sym (car #buzai$))
		(setq #action (cadr #buzai$))
		(setq #wt_flg nil)
		(setq #xd_WRKT$ nil)

		(if (= #action "M")
			(progn
				; ���ނ��T�C�Y���y�����Ɉړ�����
				; �V���{���}�`�����Ɉړ�����I���Z�b�g�����߂�
				(cond
					((CFGetXData #sym "G_LSYM")
						(setq #ss (CFGetSameGroupSS #sym))
					)
					((setq #xd_WRKT$ (CFGetXData #sym "G_WRKT"))
						(setq #wt_flg T)

						; ���_����ɐݒ�
						(command "vpoint" "0,0,1")

						; ���[�N�g�b�v�ɕR�t���}�`�I���Z�b�g�����߂�
						(setq #ss (Toku_HeightChange_PCW_ChColWTItemSSret #sym))

						; ���_��߂�
						(command "zoom" "p")
					)
				)

				(if #ss
					(progn
						; ��A�C�e��������A��A�C�e�����w�蕔�ނɊ܂܂��ꍇ
						; �����ړ�����
						(if (and (CFGetXRecord "BASESYM")
										 (ssmemb (handent (car (CFGetXRecord "BASESYM"))) #ss))
							(progn
								(setq #ss_arw (ssget "X" '((-3 ("G_ARW"))))) ; �����ړ�����
								(CMN_ssaddss #ss_arw #ss)
							)
						)

						; �y�����ɃT�C�Y���ړ�����
						(setq #buf (strcat "0,0," (rtos &size)))
						(command "._MOVE" #ss "" "0,0,0" #buf)
					)
				)

				(if (= #wt_flg T)
					; ���[�N�g�b�v��t�������C������
          (CFSetXData #sym "G_WRKT" (CFModList #xd_WRKT$ (list (list 8 (+ (nth 8 #xd_WRKT$) &size)))))
				)
			)
			(progn
				; ���ނ��T�C�Y���y�����ɐL�k����
				(setq CG_BASE_UPPER nil)
				(setq CG_POS_STR nil)
				(setq CG_TOKU nil)

        (setq #xd_SYM$ (CFGetXData #sym "G_SYM"))
;-- 2012/02/20 A.Satoh Del - S
;;;;;;-- 2012/02/17 A.Satoh Add CG�Ή� - S
;;;;;				(setq CG_SizeH (nth 5 #xd_SYM$))
;;;;;;-- 2012/02/17 A.Satoh Add CG�Ή� - E
;-- 2012/02/20 A.Satoh Del - E
				(setq #str_width  (nth 3 #xd_SYM$))	; �L�k��Ё@�@�������������L���r�Ή����ɏC��
				(setq #str_depth  (nth 4 #xd_SYM$))	; �L�k�㉜�s�@�������������L���r�Ή����ɏC��
				(setq #str_height (+ (nth 5 #xd_SYM$) &size))	; �L�k�㍂��
				(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))

				;2013/11/04  YM ADD-S DEEP�H��̏ꍇ�Ɍx����\������
				(setq #hinban (nth 5 #xd_LSYM$));�i��
				(setq #SKK (nth 9 #xd_LSYM$));���i����
				;;;�E�f�B�[�v�H��̔���@���i�R�[�h�P�P�O ���� �i�Ԋ�{�̓����Ώۂ�"X"�łȂ��ꍇ
				(if (equal #SKK 110 0.001)
					(progn
					  (setq #qry$
					    (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
					      (list
					        (list "�i�Ԗ���" #hinban 'STR)
					      )
					    )
					  )
					  (if (and #qry$ (= 1 (length #qry$)))
							(progn
								(setq #TOKU_KIGO (nth 10 (car #qry$))) ;�����Ώ�
								(if (/= "X" #TOKU_KIGO)
									;DEEP�H����܂ނ��ǂ���?
									(if (= 50 &size) ;H900�̏ꍇ
										(CFYesDialog "\n�P�R�~�p�l��������i�Ԃɒu�������Ă��������B")
									);_if
								);_if
							)
						);_if
					)
				);_if
				;2013/11/04 YM ADD-E DEEP�H��̏ꍇ�Ɍx����\������

				(setq #pt (cdr (assoc 10 (entget #sym))))      ; ����ي�_
				(setq #ang (nth 2 #xd_LSYM$))                  ; ����ٔz�u�p�x
;-- 2012/03/23 A.Satoh Add - S
				(setq #doorID (nth 7 #xd_LSYM$))
;-- 2012/03/23 A.Satoh Add - E
				(setq #gnam (SKGetGroupName #sym))             ; ��ٰ�ߖ�
;-- 2012/02/20 A.Satoh Add CG�Ή� - S
;;; 2013/01/07YM@MOD				(setq CG_SizeH (nth 13 #xd_LSYM$))
;;; 2013/01/07YM@MOD				(setq CG_SizeH (+ CG_SizeH &size))
;-- 2012/02/20 A.Satoh Add CG�Ή� - E

;2013/01/07 YM MOD
				(setq #CG_SizeH (nth 13 #xd_LSYM$))
				(setq #CG_SizeH (+ #CG_SizeH &size))
;2013/01/07 YM MOD

				(setq #BrkW (fix (* (fix (nth 3 #xd_SYM$)) 0.5)))
				(setq #BrkD (fix (* (fix (nth 4 #xd_SYM$)) 0.5)))
				(if (> 0 (nth 10 #xd_SYM$))
					(setq CG_BASE_UPPER T)
				)
				(if CG_BASE_UPPER
					(setq #BrkH (- (+ (fix (atof (substr #action 2))) (caddr #pt)) (nth 5 #xd_SYM$)))
					(setq #BrkH (fix (atof (substr #action 2))))
				)
        (if (not (equal #str_width (nth 3 #xd_SYM$) 0.0001))
					(progn
						(setq CG_TOKU T)
						(setq #eDelBRK_W$ (PcRemoveBreakLine #sym "W")) ; W�����u���[�N����
						(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
						(CFSetXData #XLINE_W "G_BRK" (list 1))
						;;; ��ڰ�ײ̸݂�ٰ�߉�
						(command "-group" "A" #gnam #XLINE_W "")
	          (setq CG_TOKU_BW #BrkW)
	          (SKY_Stretch_Parts #sym #str_width (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))
            ;;; �ꎞ��ڰ�ײݍ폜
            (entdel #XLINE_W)
            ;;; ������ڰ�ײݕ���
            (foreach #eD #eDelBRK_W$
              (if (= (entget #eD) nil) (entdel #eD)) ;W�����u���[�N����
            )
					)
        )
        (if (not (equal #str_depth (nth 4 #xd_SYM$) 0.0001))
					(progn
						(setq CG_TOKU T)
						(setq #eDelBRK_D$ (PcRemoveBreakLine #sym "D")) ; D�����u���[�N����
						(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
						(CFSetXData #XLINE_D "G_BRK" (list 2))
						;;; ��ڰ�ײ̸݂�ٰ�߉�
						(command "-group" "A" #gnam #XLINE_D "")
  	        (setq CG_TOKU_BD #BrkD)
	          (SKY_Stretch_Parts #sym #str_width #str_depth (nth 5 #xd_SYM$))
            ;;; �ꎞ��ڰ�ײݍ폜
            (entdel #XLINE_D)
            ;;; ������ڰ�ײݕ���
            (foreach #eD #eDelBRK_D$
              (if (= (entget #eD) nil) (entdel #eD)) ;D�����u���[�N����
            );for
					)
        )
        (if (not (equal #str_height (nth 5 #xd_SYM$) 0.0001))
					(progn
						(setq CG_TOKU T)
						(setq #eDelBRK_H$ (PcRemoveBreakLine #sym "H")) ; H�����u���[�N����
						(setq #XLINE_H (PK_MakeBreakH #pt #BrkH))
						(CFSetXData #XLINE_H "G_BRK" (list 3))
						;;; ��ڰ�ײ̸݂�ٰ�߉�
						(command "-group" "A" #gnam #XLINE_H "")
    	      (setq CG_TOKU_BH #BrkH)
	          (SKY_Stretch_Parts #sym #str_width #str_depth #str_height)
            ;;; �ꎞ��ڰ�ײݍ폜
            (entdel #XLINE_H)
            ;;; ������ڰ�ײݕ���
            (foreach #eD #eDelBRK_H$
              (if (= (entget #eD) nil) (entdel #eD)) ;H�����u���[�N����
            );for
					)
        )

;-- 2012/02/22 A.Satoh Add : �i�Ԑ}�`DB�̓o�^H���@�l���X�V���� - S
	      (CFSetXData #sym "G_LSYM"
  	      (CFModList #xd_LSYM$
						;2013/01/07 YM MOD-S
;	    	    (list (list 13 CG_SizeH))
	    	    (list (list 13 #CG_SizeH))
						;2013/01/07 YM MOD-E
        	)
      	)
;-- 2012/02/22 A.Satoh Add : �i�Ԑ}�`DB�̓o�^H���@�l���X�V���� - E

				(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #sym) 3 T))

;-- 2012/03/23 A.Satoh Add - S
				(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
	      (CFSetXData #sym "G_LSYM" (CFModList #xd_LSYM$ (list (list  7 #doorID))))
;-- 2012/03/23 A.Satoh Add - E

				(setq CG_BASE_UPPER nil)
				(setq CG_POS_STR nil)
				(setq CG_TOKU nil)
;-- 2012/02/20 A.Satoh Add - S
;;;;;;-- 2012/02/17 A.Satoh Add CG�Ή� - S
;;;;;				(setq CG_SizeH nil)
;;;;;;-- 2012/02/17 A.Satoh Add CG�Ή� - E
;-- 2012/02/20 A.Satoh Add - E
			)
		)
	)

	(princ)

);TokuBuzaiStretch


;;;(KikiHantei (nth 5 #xd_LSYM$) (nth 9 #xd_LSYM$)) ;�i��,���i����

;<HOM>*************************************************************************
; <�֐���>    : KikiHantei
; <�����T�v>  : �@�킩�ǂ�������
; <�߂�l>    : T:�@�� nil �@��ȊO
; <�쐬>      : 2016/10/06 YM ADD-S
; <���l>      : 
;*************************************************************************>MOH<
(defun KikiHantei (
  &hinban ;�i��
	&skk    ;���i����
  /
	#RET
  )
	(setq #ret nil)
	
;;;���i�R�[�h
;;;110�@�H��
;;;113�@�K�X�L���r�@�܂��́@�I�[�u���@�i�����j
;;;210�@�K�X�R�����@�܂��́@�h�g
;;;320�@�����W�t�[�h
;;;510�@����(�Y���Ȃ�)
;;;
;;;�i�����j
;;;�I�[�u���@�́A�i�Ԗ���=HD�`
;;;�K�X�L���r�́A�i�Ԗ���=H$�`
;;;�ŋ�ʉ�

	(if (or (= &skk 110)(= &skk 210)(= &skk 320)(= &skk 510))
		(setq #ret T)
	);_if

	(if (and (= &skk 113)(wcmatch &hinban "HD*"))
		(setq #ret T)
	);_if

	#ret
);KikiHantei


;<HOM>*************************************************************************
; <�֐���>    : TokuCab_InputTokuData
; <�����T�v>  : �w��̃V���{���ɑ΂��ē����L���r����ݒ肷��
; <�߂�l>    : T:����I�� nil �L�����Z���I��
; <�쐬>      : 11/12/01 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun TokuCab_InputTokuData (
  &buzai$
	&size
	&base_sym
  /
	#err_flag #en #action #syuyaku
	#xd_LSYM$ #xd_SYM$ #xd_TOKU$
	#hin_last$ #hinban #hinban2 #lr #hin_last #toku_hin
	#hin_takasa #org_width #org_depth #org_height
	#qry$ #hinban$ #hinban2$
	#ret #ssGrp
#XLINE_W$ #XLINE_D$ #XLINE_H$ #org_size$ ;-- 2012/12/15 A.Satoh CG�Ή�
#hin_width #hin_depth ;-- 2012/02/21 A.Satoh Add 
#chk ;-- 2012/02/22 A.Satoh Add
#DOOR_INFO$ #DRCOLCODE #DRHIKITE #DRSERICODE #HIN_KAKAKU #RET$ ;2013/08/05 YM ADD
#CG_TOKU_HINBAN ;2018/07/27 YM ADD
  )

	(setq #ret T)
	(setq #err_flag nil)
	(setq #en         (nth 0 &buzai$))
	(setq #action     (nth 1 &buzai$))
	(setq #syuyaku    (nth 2 &buzai$))
	(setq #org_width  (nth 0 (nth 3 &buzai$)))
	(setq #org_depth  (nth 1 (nth 3 &buzai$)))
	(setq #org_height (nth 2 (nth 3 &buzai$)))

	; �ΏۃV���{���̐F�ς�
	(setq #ssGrp (CFGetSameGroupSS #en))
	(setq #ssGrp (ChangeItemColor #ssGrp '(()("G_LSYM")) CG_ConfSymCol))

	(setq #xd_TOKU$ (CFGetXData #en "G_TOKU"))
	(if (= #xd_TOKU$ nil)
		(progn
			(setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
			(if (= #xd_LSYM$ nil)
				(setq #err_flag T)
			)

			(if (= #err_flag nil)
				(progn
					(setq #xd_SYM$ (CFGetXData #en "G_SYM"))
					(if (= #xd_SYM$ nil)
						(setq #err_flag T)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
					(setq #hinban (nth 5 #xd_LSYM$))
					(setq #lr     (nth 6 #xd_LSYM$))

;-- 2011/12/15 A.Satoh Mod - S
;;;;;					(setq #qry$$
;;;;;						(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
;;;;;							(list
;;;;;								(list "�i�Ԗ���"   #hinban       'STR)
;;;;;								(list "LR�敪"     #lr           'STR)
;;;;;								(list "���V���L��" CG_DRSeriCode 'STR)
;;;;;								(list "���J���L��" CG_DRColCode  'STR)
;;;;;								(list "����L��"   CG_Hikite     'STR)
;;;;;							)
;;;;;						)
;;;;;					)
;;;;;
;;;;;					(if (/= #qry$$ nil)
;;;;;						(if (= (length #qry$$) 1)
;;;;;							(progn
;;;;;								(setq #hin_last (nth 10 (car #qry$$)))
;;;;;								(setq #hin_takasa (atof (nth 12 (car #qry$$))))
;;;;;							)
;;;;;							(setq #err_flag T)
;;;;;						)
;;;;;						(progn
;;;;;;-- 2011/12/13 A.Satoh Add - S
;;;;;;							(setq #hin_last #hinban)
;;;;;;							(setq #hin_takasa #org_height)
;;;;;;-- 2011/12/13 A.Satoh Add - S
;;;;;							(setq #qry2$$
;;;;;								(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
;;;;;									(list
;;;;;										(list "�i�Ԗ���"   #hinban       'STR)
;;;;;										(list "LR�敪"     #lr           'STR)
;;;;;										(list "���V���L��" CG_DRSeriCode 'STR)
;;;;;										(list "���J���L��" CG_DRColCode  'STR)
;;;;;									)
;;;;;								)
;;;;;							)
;;;;;
;;;;;							(if (/= #qry2$$ nil)
;;;;;								(if (= (length #qry2$$) 1)
;;;;;									(progn
;;;;;										(setq #hin_last (nth 10 (car #qry2$$)))
;;;;;										(setq #hin_takasa (atof (nth 12 (car #qry2$$))))
;;;;;									)
;;;;;									(setq #err_flag T)
;;;;;								)
;;;;;								(progn
;;;;;									(setq #hin_last #hinban)
;;;;;									(setq #hin_takasa #org_height)
;;;;;								)
;;;;;							)
;;;;;						)
;;;;;					)
					; �����K�i�i�`�F�b�N���s��
					(setq #qry$
						(CFGetDBSQLRec CG_DBSESSION "�����K�i�i"
							(list
								(list "�i�Ԗ���" #hinban 'STR)
							)
						)
					)
					(if (/= #qry$ nil)
						(progn
							(princ (strcat "\n�������������K�i�i �i�Ԗ��� = " #hinban))
							(setq #err_flag T)
;-- 2012/02/15 A.Satoh Add CG�Ή� - S
							(if (= nil (tblsearch "APPID" "G_REG")) (regapp "G_REG"))
							(setq #org_size$ (list #org_width #org_depth #org_height))
							(setq #XLINE_W$  (list nil nil))								; �u���[�N���C���ʒu�v
							(setq #XLINE_D$	 (list nil nil))								; �u���[�N���C���ʒu�c
							(setq #XLINE_H$  (list (atof (substr #action 2)) nil))	; �u���[�N���C���ʒu�g
;-- 2012/02/22 A.Satoh Add - S
							(setq #chk (list nil nil T))
;-- 2012/02/22 A.Satoh Add - E
							(InputGRegData #en #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ #chk nil nil)
;-- 2012/02/15 A.Satoh Add CG�Ή� - E
						)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
					; �i�Ԗ��̂��犇�ʂ����O
					(setq #hinban2 (KP_DelHinbanKakko #hinban))

					;2013/08/05 YM MOD-S
					(setq #Door_Info$     (nth 7 #xd_LSYM$))
					(setq #ret$ (StrParse #Door_Info$ ","))
					(setq #DRSeriCode (car   #ret$))(if (= #DRSeriCode nil)(setq #DRSeriCode ""))
					(setq #DRColCode  (cadr  #ret$))(if (= #DRColCode nil)(setq #DRColCode ""))
					(setq #DRHikite   (caddr #ret$))(if (= #DRHikite nil)(setq #DRHikite ""))

					(if (= #DRSeriCode "")
						(progn
							(setq #DRSeriCode CG_DRSeriCode)
							(setq #DRColCode  CG_DRColCode)
							(setq #DRHikite   CG_Hikite)
						)
					);_if

					; �ŏI�i�Ԃ��擾
;;;					(setq #hin_last$ (StretchCabW_GetHinbanLast #hinban2 #lr))
					(setq #hin_last$ (StretchCabW_GetHinbanLast_HIKISU #hinban2 #lr #DRSeriCode #DRColCode #DRHikite))
					;2013/08/05 YM MOD-E




					(if (= #hin_last$ nil)
						(progn
							(setq #hin_last #hinban)
;-- 2012/02/21 A.Satoh Add - S
							(setq #hin_width #org_width)
							(setq #hin_depth #org_height)
;-- 2012/02/21 A.Satoh Add - E
							(setq #hin_takasa #org_height)
							;2013/01/30 YM ADD
							(setq #hin_KAKAKU 0)
						)
						(progn
							(setq #hin_last (car #hin_last$))
;-- 2012/02/21 A.Satoh Mod - S
;;;;;							(setq #hin_takasa (atof (cadr #hin_last$)))
							(setq #hin_width  (atof (nth 1 #hin_last$)))
							(setq #hin_takasa (atof (nth 2 #hin_last$)))
							(setq #hin_depth  (atof (nth 3 #hin_last$)))
;-- 2012/02/21 A.Satoh Mod - E

							;2013/01/30 YM ADD
							(setq #hin_KAKAKU (nth 4 #hin_last$))
						)
					)
;-- 2011/12/15 A.Satoh Mod - S
				)
			)

			(if (= #err_flag nil)
				(progn
		      (setq #qry$
    		    (CFGetDBSQLRec CG_CDBSESSION "�W�񖼏�"
        		  (list
            		(list "�W��ID" #syuyaku 'STR)
		          )
    		    )
		      )
					(if (/= #qry$ nil)
						(if (= (length #qry$) 1)
							(setq #toku_hin (nth 2 (car #qry$)))
							(setq #err_flag T)
						)
						(setq #err_flag T)
					)
				)
			)


			;2016/10/06 YM ADD �@�킩�ǂ����̔���
			(if (KikiHantei (nth 5 #xd_LSYM$) (nth 9 #xd_LSYM$)) ;�i��,���i����
				(progn
					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_KIKI)
				)
				;�@��ȊO
				(progn
					;2018/07/27 YM MOD-S
;;;					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN)
					(cond
						((= BU_CODE_0013 "1") ; PSKC�̏ꍇ
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
						)
						((= BU_CODE_0013 "2") ; PSKD�̏ꍇ
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
						)
						(T ;����ȊO
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
						)
					);_if
					;2018/07/27 YM MOD-E
				)
			);_if


			(if (= #err_flag nil)
				(progn
					(setq #hinban$
						(list
;;;							#toku_hin													; �����i��
							#CG_TOKU_HINBAN										; �����i�� 2016/08/30 YM MOD (3)
							;2013/01/30 YM MOD ���z��\������
;;;							0																	; ���z
							#hin_KAKAKU           						; ���z

;;;							(strcat "ĸ���(" #hin_last ")")		; �i��
							(strcat "ĸ(" #hin_last ")")      ; �i�� 2016/08/30 YM MOD
							""																; �����R�[�h�@�����R�[�h-�A��
;-- 2012/02/21 A.Satoh Mod - S
;;;;;							(nth 3 #xd_SYM$)									; ��
							#hin_width												; ��
;-- 2012/02/21 A.Satoh Mod - S
;							(+ (nth 5 #xd_SYM$) &size)				; ����
							(+ #hin_takasa &size)							; ����
;-- 2012/02/21 A.Satoh Mod - S
;;;;;							(nth 4 #xd_SYM$)									; ���s
							#hin_depth												; ���s
;-- 2012/02/21 A.Satoh Mod - E
						)
					)
				)
			)
		)
		(progn
;-- 2012/02/22 A.Satoh Add - S
			(setq #xd_SYM$ (CFGetXData #en "G_SYM"))
			(if (= #xd_SYM$ nil)
				(setq #err_flag T)
			)
;-- 2012/02/22 A.Satoh Add - E

			(setq #hinban$
				(list
					(nth 0 #xd_TOKU$)				; �����i��
					(fix (nth 1 #xd_TOKU$))	; ���z
					(nth 2 #xd_TOKU$)				; �i��
					(nth 3 #xd_TOKU$)				; �����R�[�h
					(nth 4 #xd_TOKU$)				; ��
					(nth 5 #xd_TOKU$)				; ����
					(nth 6 #xd_TOKU$)				; ���s
				)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
			; �����L���r�����͉�ʏ���
			(setq #hinban2$ (Toku_HeightChange_SetTokuDataDlg #hinban$))
			(if #hinban2$
				(progn
					; �������(G_TOKU)�̐ݒ�
					(if #xd_TOKU$
						(progn
							(CFSetXData #en "G_TOKU"
								(CFModList #xd_TOKU$
									(list
										(list  0 (nth 0 #hinban2$))													; [ 0]�����i��
										(list  1 (nth 1 #hinban2$))													; [ 1]���z
										(list  2 (nth 2 #hinban2$))													; [ 2]�i��
										(list  3 (nth 3 #hinban2$))													; [ 3]�����R�[�h
										(list  4 (nth 4 #hinban2$))													; [ 4]��
										(list  5 (nth 5 #hinban2$))													; [ 5]����
										(list  6 (nth 6 #hinban2$))													; [ 6]���s
										(list 17 (nth 3 #xd_SYM$))													; [17]�L�k��}�`�T�C�Y�v
										(list 18 (nth 4 #xd_SYM$))													; [18]�L�k��}�`�T�C�Y�c
										(list 19 (nth 5 #xd_SYM$))													; [19]�L�k��}�`�T�C�Y�g
;-- 2012/03/16 A.Satoh Mod - S
;;;;;										(list 20 (list 0.0 0.0 0.0))												; [20]�u���[�N���C���ʒu�v
;;;;;										(list 21 (list 0.0 0.0 0.0))												; [21]�u���[�N���C���ʒu�c
										(list 20 (nth 20 #xd_TOKU$))												; [20]�u���[�N���C���ʒu�v
										(list 21 (nth 21 #xd_TOKU$))												; [21]�u���[�N���C���ʒu�c
;-- 2012/03/16 A.Satoh Mod - S
										(list 22 (list (atof (substr #action 2)) 0.0 0.0))	; [22]�u���[�N���C���ʒu�g
									)
								)
							)
						)
						(progn
							(CFSetXData #en "G_TOKU"
								(list
									(nth 0 #hinban2$)													; [ 0]�����i��
									(nth 1 #hinban2$)													; [ 1]���z
									(nth 2 #hinban2$)													; [ 2]�i��
									(nth 3 #hinban2$)													; [ 3]�����R�[�h
									(nth 4 #hinban2$)													; [ 4]��
									(nth 5 #hinban2$)													; [ 5]����
									(nth 6 #hinban2$)													; [ 6]���s
									""																				; [ 7]�\���P
									""																				; [ 8]�\���Q
									""																				; [ 9]�\���R
									#hinban																		; [10]���i�Ԗ���
									#hin_last																	; [11]���ŏI�i��
									#org_width																; [12]���}�`�T�C�Y�v
									#org_depth																; [13]���}�`�T�C�Y�c
									#org_height																; [14]���}�`�T�C�Y�g
;-- 2012/03/16 A.Satoh Mod - S
;;;;;									""																				; [15]�\���S
;;;;;									""																				; [16]�\���T
									0.0																				; [15]�c�̐L�k��
									0.0																				; [16]�b�̐L�k��
;-- 2012/03/16 A.Satoh Mod - E
									(nth 3 #xd_SYM$)													; [17]�L�k��}�`�T�C�Y�v
									(nth 4 #xd_SYM$)													; [18]�L�k��}�`�T�C�Y�c
									(nth 5 #xd_SYM$)													; [19]�L�k��}�`�T�C�Y�g
									(list 0.0 0.0 0.0)												; [20]�u���[�N���C���ʒu�v
									(list 0.0 0.0 0.0)												; [21]�u���[�N���C���ʒu�c
									(list (atof (substr #action 2)) 0.0 0.0)	; [22]�u���[�N���C���ʒu�g
								)
							)
						)
					)
				)
				(setq #ret nil)
			)
		)
	)

	(if (equal &base_sym #en)
		(GroupInSolidChgCol #en CG_BaseSymCol)
		(GroupInSolidChgCol2 #en "BYLAYER")
	)

	#ret
);TokuCab_InputTokuData


;<HOM>*************************************************************************
; <�֐���>    : Toku_HeightChange_SetTokuDataDlg
; <�����T�v>  : �����L���r�����͉�ʂ�\�����A�w��̕��ށi�V���{���}�`�j
;             : �ɑ΂��ē�������ݒ肷��
; <�߂�l>    : ���͏��  : �ݒ�
;             : nil: �L�����Z���i���������ꊇ�ύX���L�����Z������j
; <�쐬>      : 11/12/01 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_SetTokuDataDlg (
	&hinban$
  /
	#hinban #price #hinmei #toku_cd #toku1 #toku2 #width #height #depth
	#dcl_id #next #ret
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// Toku_HeightChange_SetTokuDataDlg ////")
  (CFOutStateLog 1 1 " ")

	;***********************************************************************
	; ����̕�����ɑ΂��A�S�p���܂܂�邩���`�F�b�N����
	; �߂�l:T �S�p����@nil:���p�̂�
	; �����R�[�h��127(0x80)���傫���ꍇ�͑S�p�����Ƃ݂Ȃ�
	;***********************************************************************
	(defun ##CheckStr (
		&str
		/
		#idx #flg #code
		)

		(setq #flg nil)
		(setq #idx 1)

		(while (and (<= #idx (strlen &str)) (not #flg))
			(setq #code (ascii(substr &str #idx 1)))
			(if (> #code 127); 0x80(127)����̏ꍇ�͑S�p�����Ƃ݂Ȃ�
				; ���p�J�i(161�`223)�͑ΏۊO�Ƃ���
				(if (or (< #code 161) (> #code 223))
					(setq #flg T)
				)
			)
			(setq #idx (1+ #idx))
		)

		#flg
	)

	;***********************************************************************
	; �n�j�{�^����������
	; �߂�l:�L�k�T�C�Y(50 or -50)
	;***********************************************************************
	(defun ##SetTokuData_CallBack (
		/
    #hinban #price #hinmei #tokucd #width #height #depth
    #err_flg #data$ #tokucd1 #tokucd2 #flg1 #flg2
		#wk_height  ;-- 2012/02/20 A.Satoh Add
    )

    (setq #err_flg nil)
		(setq #data$ nil)

    ; �����i�ԃ`�F�b�N
    (setq #hinban (get_tile "edtWT_NAME"))
    (if (or (= #hinban "") (= #hinban nil))
      (progn
        (set_tile "error" "�����i�Ԃ����͂���Ă��܂���")
        (mode_tile "edtWT_NAME" 2)
        (setq #err_flg T)
      )
			(progn
;      	(setq #hinban (strcase #hinban))
				(if (> (strlen #hinban) 15)
					(progn
						(set_tile "error" "�����i�Ԃ�15���ȉ��œ��͂��ĉ�����")
						(mode_tile "edtWT_NAME" 2)
						(setq #err_flg T)
					)
					;2014/02/10 YM ADD
					(progn ;�i�Ԃɶ�ς���
						(if (vl-string-search "," #hinban)
							(progn
								(set_tile "error" "�i�Ԃɶ�ς��g�p���Ȃ��ŉ�����")
								(mode_tile "edtWT_NAME" 2)
								(setq #err_flg T)
							)
						);_if
					)
				);_if
			)
    );_if

    ; ���z�`�F�b�N
    (if (= #err_flg nil)
      (progn
        (setq #price (get_tile "edtWT_PRI"))
        (if (or (= #price "") (= #price nil))
          (progn
            (set_tile "error" "���z�����͂���Ă��܂���")
            (mode_tile "edtWT_PRI" 2)
            (setq #err_flg T)
          )
          (if (= (type (read #price)) 'INT)
            (if (> 0 (read #price))
              (progn
                (set_tile "error" "0�ȏ�̐����l����͂��ĉ�����")
                (mode_tile "edtWT_PRI" 2)
                (setq #err_flg T)
              )
							(if (> (read #price) 9999999)
								(progn
	                (set_tile "error" "���z�� 9999999 �ȉ��̐����l����͂��ĉ�����")
  	              (mode_tile "edtWT_PRI" 2)
    	            (setq #err_flg T)
								)
							)
            )
            (progn
              (set_tile "error" "���z�� 9999999 �ȉ��̐����l����͂��ĉ�����")
              (mode_tile "edtWT_PRI" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; �i���擾
    (if (= #err_flg nil)
			(progn
      	(setq #hinmei (get_tile "edtWT_HINMEI"))
				(if (> (strlen #hinmei) 30)
          (progn
            (set_tile "error" "�i����30���ȉ��œ��͂��ĉ�����")
            (mode_tile "edtWT_HINMEI" 2)
            (setq #err_flg T)
          )
					(if (##CheckStr #hinmei)
						(progn
	            (set_tile "error" "�i���͔��p�̂ݓ��͉\�ł�")
  	          (mode_tile "edtWT_HINMEI" 2)
    	        (setq #err_flg T)
						)
						;2014/02/10 YM ADD
						(progn ;�i�Ԃɶ�ς���
							(if (vl-string-search "," #hinmei)
								(progn
									(set_tile "error" "�i���ɶ�ς��g�p���Ȃ��ŉ�����")
									(mode_tile "edtWT_HINMEI" 2)
									(setq #err_flg T)
								)
							);_if
						)
					)
				)
			)
    )

    ; �����R�[�h�`�F�b�N
    (if (= #err_flg nil)
      (progn
        (setq #tokucd1 (get_tile "edtWT_Toku1"))
        (setq #tokucd2 (get_tile "edtWT_Toku2"))

        (if (or (= #tokucd1 "") (= #tokucd1 nil))
          (setq #flg1 nil)
          (setq #flg1 T)
        )
        (if (or (= #tokucd2 "") (= #tokucd2 nil))
          (setq #flg2 nil)
          (setq #flg2 T)
        )

        (cond
          ((and (= #flg1 nil) (= #flg2 nil))
            (setq #tokucd "")
          )
          ((and (= #flg1 T) (= #flg2 nil))
            (set_tile "error" "�����R�[�h�����͂���Ă��܂���")
            (mode_tile "edtWT_Toku2" 2)
            (setq #err_flg T)
          )
          ((and (= #flg1 nil) (= #flg2 T))
            (set_tile "error" "�����R�[�h�����͂���Ă��܂���")
            (mode_tile "edtWT_Toku1" 2)
            (setq #err_flg T)
          )
          (T
            (if (= (type (read #tokucd2)) 'INT)
              (if (> 1 (read #tokucd2))
                (progn
                  (set_tile "error" "1�ȏ�̐����l����͂��ĉ�����")
                  (mode_tile "edtWT_Toku2" 2)
                  (setq #err_flg T)
                )
              )
              (progn
                (set_tile "error" "1�ȏ�̐����l����͂��ĉ�����")
                (mode_tile "edtWT_Toku2" 2)
                (setq #err_flg T)
              )
            )

            (if (= #err_flg nil)
              (if (< (strlen #tokucd1) 12)
                (progn
                  (set_tile "error" "���ނ�12���œ��͂��ĉ�����")
                  (mode_tile "edtWT_Toku1" 2)
                  (setq #err_flg T)
                )
                (progn
                  (setq #tokucd1 (strcase #tokucd1))
                  (if (= (strlen #tokucd2) 1)
                    (setq #tokucd2 (strcat "00" #tokucd2))
                    (if (= (strlen #tokucd2) 2)
                      (setq #tokucd2 (strcat "0" #tokucd2))
                    )
                  )
                  (setq #tokucd (strcat #tokucd1 "-" #tokucd2))
                )
              )
            )
          )
        )
      )
    )

    ; �Ѓ`�F�b�N
    (if (= #err_flg nil)
      (progn
        (setq #width (get_tile "edtWT_Width"))
        (if (or (= #width "") (= #width nil))
          (setq #width "")
          (if (or (= (type (read #width)) 'INT) (= (type (read #width)) 'REAL))
            (if (> 0 (read #width))
              (progn
                (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
                (mode_tile "edtWT_Width" 2)
                (setq #err_flg T)
              )
							(if (> (read #width) 99999)
								(progn
	                (set_tile "error" "�Ђ� 99999 �ȉ��̐��l����͂��ĉ�����")
  	              (mode_tile "edtWT_Width" 2)
    	            (setq #err_flg T)
								)
							)
            )
            (progn
              (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
              (mode_tile "edtWT_Width" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; �����`�F�b�N
    (if (= #err_flg nil)
      (progn
        (setq #height (get_tile "edtWT_Height"))
        (if (or (= #height "") (= #height nil))
          (setq #height "")
          (if (or (= (type (read #height)) 'INT) (= (type (read #height)) 'REAL))
            (if (> 0 (read #height))
              (progn
                (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
                (mode_tile "edtWT_Height" 2)
                (setq #err_flg T)
              )
;;;;;							(if (>= (read #height) 1000)
							(if (> (read #height) 99999)
								(progn
;;;;;	                (set_tile "error" "������ 1000 �����̐��l����͂��ĉ�����")
	                (set_tile "error" "������ 99999 �ȉ��̐��l����͂��ĉ�����")
  	              (mode_tile "edtWT_Height" 2)
    	            (setq #err_flg T)
								)
							)
            )
            (progn
              (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
              (mode_tile "edtWT_Height" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; ���s�`�F�b�N
    (if (= #err_flg nil)
      (progn
        (setq #depth (get_tile "edtWT_Depth"))
        (if (or (= #depth "") (= #depth nil))
          (setq #depth "")
          (if (or (= (type (read #depth)) 'INT) (= (type (read #depth)) 'REAL))
            (if (> 0 (read #depth))
              (progn
                (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
                (mode_tile "edtWT_Depth" 2)
                (setq #err_flg T)
              )
;;;;;							(if (> (read #depth) 99999)
							(if (>= (read #depth) 1000)
								(progn
;;;;;	                (set_tile "error" "���s�� 99999 �ȉ��̐��l����͂��ĉ�����")
	                (set_tile "error" "���s�� 1000 �����̐��l����͂��ĉ�����")
  	              (mode_tile "edtWT_Depth" 2)
    	            (setq #err_flg T)
								)
							)
            )
            (progn
              (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
              (mode_tile "edtWT_Depth" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; ���i0�~�̊m�F
    (if (= #err_flg nil)
      (if (equal (atof #price) 0.0 0.0001)
        (if (= (CFYesNoDialog "���i��0�~�ŗǂ��ł����H") nil)
          (setq #err_flg T)
        )
      )
    )

    ; ������񃊃X�g�̍쐬
    (if (= #err_flg nil)
      (progn
        (setq #data$ (list #hinban (atof #price) #hinmei #tokucd (atof #width) (atof #height) (atof #depth)))
        (done_dialog)
        #data$
      )
    )

		#data$
	)
	;***********************************************************************

  (setq #hinban  (nth 0 &hinban$)) ; �i��
  (setq #price   (nth 1 &hinban$)) ; ���z
  (setq #hinmei  (nth 2 &hinban$)) ; �i��
  (setq #toku_cd (nth 3 &hinban$)) ; �����R�[�h
  (if (/= #toku_cd "")
    (progn
      (setq #toku1 (substr #toku_cd 1 12))
      (setq #toku2 (substr #toku_cd 14 3))
    )
    (progn
      (setq #toku1 "")
      (setq #toku2 "")
    )
  )
  (setq #width   (nth 4 &hinban$)) ; ��
  (setq #height  (nth 5 &hinban$)) ; ����
  (setq #depth   (nth 6 &hinban$)) ; ���s

	; �����L���r�����͉�ʕ\��
	(setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kcmain.dcl")))
	(if (not (new_dialog "SetTOKUCABInfoDlg" #dcl_id)) (exit))

	; �����ݒ�
	(set_tile "edtWT_NAME"   #hinban)							; �����i��
	(set_tile "edtWT_PRI"    (itoa #price))				; ���z
	(set_tile "edtWT_HINMEI" #hinmei)							; �i��
	(set_tile "edtWT_Toku1"  #toku1)							; �����R�[�h�P
	(set_tile "edtWT_Toku2"  #toku2)							; �����R�[�h�Q
	(set_tile "edtWT_Width"  (rtos #width 2 1))		; ��
;2013/01/04 YM MOD-S
	(set_tile "edtWT_Height" (rtos #height 2 1))	; ����
;;;;-- 2012/02/20 A.Satoh Add - S
;;;;;;;;	(set_tile "edtWT_Height" (rtos #height 2 1))	; ����
;;;	(set_tile "edtWT_Height" (rtos CG_SizeH 2 1))	; ����
;;;;-- 2012/02/20 A.Satoh Add - E
;2013/01/04 YM MOD-E
	(set_tile "edtWT_Depth"  (rtos #depth 2 1))		; ���s

	(setq #next 99)
	(while (and (/= 1 #next) (/= 0 #next))
		; �{�^����������
  	(action_tile "accept" "(setq #ret (##SetTokuData_CallBack))")
  	(action_tile "cancel" "(setq #ret nil) (done_dialog 0)")

  	(setq #next (start_dialog))
	)

  (unload_dialog #dcl_id)

	#ret

);Toku_HeightChange_SetTokuDataDlg


;-- 2011/11/25 A.Satoh Add - E


;<HOM>*************************************************************************
; <�֐���>    : KPGetHinbanMoney
; <�����T�v>  : �i��,���i�̓����޲�۸ނ�\������Xdata"G_TOKU"�ɾ�Ă���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/07/09 YM
; <���l>      : NAS�������޺���ޗp
;*************************************************************************>MOH<
(defun KPGetHinbanMoney (
  &SYM
  /
  #HINBAN #LR #LXD$ #ORG_PRICE #RET$ #SBIKOU #SHINMEI #SS #SYM #USERHINBAN
#USERBIKOU #USERHINMEI ; 02/07/10 YM ADD
  )
  (setq #sym &SYM)
  (setq #LXD$ (CFGetXData #sym "G_LSYM"))
  (setq #HINBAN (nth 5 #LXD$))
  (setq #LR     (nth 6 #LXD$))

;;; ���މ��i������
  (setq #ret$ (KPGetPrice #HINBAN #LR))
  (setq #ORG_price (nth 0 #ret$))
  (setq #sHINMEI   (nth 1 #ret$)) ; �i��
  (setq #sBIKOU    (nth 2 #ret$)) ; ���l

  ; �}�`�F��ύX
  (setq #ss (CFGetSameGroupSS #sym))
  (command "_change" #ss "" "P" "C" CG_InfoSymCol "")

  ;;; �m�F�޲�۸�
  (setq #ret$
    (ShowTOKUCAB_Dlog_N
      #HINBAN
      "0"
      nil        ; ���ݎg���Ă��Ȃ�
      #ORG_price ; ���̉��i
      #sHINMEI   ; �i��
      #sBIKOU    ; ���l
    )
  ); �i��,���i

  (if (= nil #ret$)
    (quit)
  );_if

  ; �S�p��߰��𔼊p��߰��ɒu��������
  (setq #userHINBAN (vl-string-subst "  " "�@" (nth 0 #ret$))) ; հ�ް���͕i��
  ; 02/07/10 YM ADD-S
  (setq #userHINMEI (nth 2 #ret$)) ; հ�ް���͕i��
  (setq #userBIKOU  (nth 3 #ret$)) ; հ�ް���͔��l
  ; 02/07/10 YM ADD-E

  ;;; �_�C�A���O����l�����ꂽ���X�g������L���r�g���f�[�^�Ɋi�[
  (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))
  (CFSetXData #sym "G_TOKU"
    (list
      #userHINBAN   ; հ�ް���͕i��
      (nth 1 #ret$) ; ���i
        "" ; (W1,W2,W3)���o���Ă���(����g�p)��Ű���ނ�""
      1    ; 1:�������޺���� 0:��АL�k
      ""   ; W ��ڰ�ײ݈ʒu ��а
      ""   ; D ��ڰ�ײ݈ʒu ��а
      ""   ; H ��ڰ�ײ݈ʒu ��а
      #HINBAN    ; ���̕i��
      ; 02/07/10 YM ADD-S �i�ԁA���i�ɉ����ĕi���Ɣ��l���ێ�����
      #userHINMEI   ; �i��(���ϖ���,�d�l�\�ł́u���́v)
      #userBIKOU    ; ���l(���ϖ��ׂł́u���l�v,�d�l�\�ł́u�d�l�v)
      ; 02/07/10 YM ADD-E
    )
  )

  ;�F��߂�
  (command "_change" #ss "" "P" "C" "BYLAYER" "")

  (princ)
);KPGetHinbanMoney

;<HOM>*************************************************************************
; <�֐���>    : GetTokuDim
; <�����T�v>  : �i��,LR����������@ð��ق�����
; <�߂�l>    : ں���(LIST) ������1���̂Ƃ��ȊO��nil
; <�쐬>      : 01/10/09 YM
; <���l>      : NAS�������޺���ޗp
;*************************************************************************>MOH<
(defun GetTokuDim (
  &HINBAN
  &LR
  /
  #QRY$ #RET
  )
  (setq #Qry$
    (CFGetDBSQLRec CG_DBSESSION "�������@"
      (list
        (list "�i�Ԗ���" &HINBAN 'STR)
        (list "LR�敪"   &LR     'STR)
      )
    )
  )
  (if (and #Qry$ (= (length #Qry$) 1))
    (setq #ret (car #Qry$))
    (setq #ret nil)
  );_if

  #ret
);GetTokuDim

;<HOM>*************************************************************************
; <�֐���>    : PcStretchCab_N
; <�����T�v>  : �L���r�l�b�g�L�k����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/04/07 MH 01/01/27 YM ��ڰ�ײ݂Ȃ��ł�OK�ɉ���
; <���l>      : ����ُ�t���̏ꍇ�l�� 01/02/21 YM
;               NAS�p���� 01/10/09 YM
;               ���̊֐��ɂ���ɂ�[�������@]��ں��ނ����݂��邱�Ƃ��K�v
;*************************************************************************>MOH<
(defun PcStretchCab_N (
  &en         ; �L�k�Ώۼ���ِ}�`
  /
  #DLOG$ #sym #LXD$ #XD$ #WDH$ #ss #bsym
  #ANG #BRKD #BRKH #BRKW #EDELBRK_D$ #EDELBRK_H$ #EDELBRK_W$ #GNAM
  #PT #XLINE_D #XLINE_H #XLINE_W #HINBAN #RET$ #flg #CNTZ #FHMOV
  #LR #ORG_PRICE #QRY$ #userHINBAN
  #DBASE #RZ #SBIKOU #SHINMEI ; 01/08/20 YM ADD �ݼލ��������L�k�s�
  #A1 #A2 #BASE #BRKW1 #BRKW2 #BRKW3 #D #D1 #D2 #H #P1 #P2 #P3 #P4 #P5 #P6 ; 02/07/09 YM ADD
  #PMEN2 #PT$ #TCNRFLG #TOKU_XD$ #W1 #W2 #W3 #XLINE_W1 #XLINE_W2 #XLINE_W3 ; 02/07/09 YM ADD
#USERBIKOU #USERHINMEI ; 02/07/10 YM ADD
#BRKW4 #W4 #XLINE_W4 ;03/11/28
  )
  (setq #flg nil) ; �L�k���������Ȃ�=T
  (setq #sym &en)

  (setq #dBASE (cdr (assoc 10 (entget #sym)))) ; ����وʒu
  (setq #rZ (caddr #dBASE)) ; ��t������
  (if (= #rZ nil)(setq #rZ 0.0))
  (setq #LXD$ (CFGetXData #sym "G_LSYM"))
  (setq #HINBAN (nth 5 #LXD$))
  (setq #LR     (nth 6 #LXD$))
  (setq #XD$  (CFGetXData #sym "G_SYM" ))
  (setq #TOKU_XD$ (CFGetXData #sym "G_TOKU"))

  (if (> 0 (nth 10 #XD$))  ; ����ق���t��===>T,����=nil
    (setq CG_BASE_UPPER T) ; �������޺���ޒ��̸�۰���
  );_if

; ������ڰ�ײݏ���
  (setq #eDelBRK_W$ (PcRemoveBreakLine #sym "W")) ; W�����u���[�N����
  (setq #eDelBRK_D$ (PcRemoveBreakLine #sym "D")) ; D�����u���[�N����
  (setq #eDelBRK_H$ (PcRemoveBreakLine #sym "H")) ; H�����u���[�N����
  (setq #pt  (cdr (assoc 10 (entget #sym))))      ; ����ي�_
  (setq #ANG (nth 2 #LXD$))                       ; ����ٔz�u�p�x
  (setq #gnam (SKGetGroupName #sym))              ; ��ٰ�ߖ�

;;; ���މ��i������
  (setq #ret$ (KPGetPrice #HINBAN #LR))
  (setq #ORG_price (nth 0 #ret$))
  (setq #sHINMEI   (nth 1 #ret$)) ; �i��
  (setq #sBIKOU    (nth 2 #ret$)) ; ���l

  ; �}�`�F��ύX
  (setq #ss (CFGetSameGroupSS #sym))
  (command "_change" #ss "" "P" "C" CG_InfoSymCol "")

  ; 01/10/10 YM ��Ű���ނ��ǂ����ŕ���
  (if (= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3))
    (progn ; ��Ű���ނ̂Ƃ�
      (setq #tCNRflg T)
      ; ��Ű����        W1=p1�`p2
      ; p1          p2  W2=p1�`p6
      ; +-----------+   D1=p2�`p3
      ; |           |   D2=p5�`p6
      ; |           |   A1=p3�`p4
      ; |     +-----+   A2=p4�`p5
      ; |     |p4   p3
      ; |     |
      ; +-----+
      ; p6    p5

      (setq #pmen2 (PKGetPMEN_NO #sym 2))  ; PMEN2�����߂�
      (setq #pt$ (GetLWPolyLinePt #pmen2)) ; PMEN2 �O�`�̈�
      (setq #base (PKGetBaseL6 #pt$))      ; ��Ű��_�����߂�(����ق����Ȃ�)
      (setq #pt$ (GetPtSeries #base #pt$)) ; #base ��擪�Ɏ��v����
      (setq #p1 (nth 0 #pt$))
      (setq #p2 (nth 1 #pt$))
      (setq #p3 (nth 2 #pt$))
      (setq #p4 (nth 3 #pt$))
      (setq #p5 (nth 4 #pt$))
      (setq #p6 (nth 5 #pt$))

      (setq #W1 (distance #p1 #p2))
      (setq #W2 (distance #p1 #p6))
      (setq #D1 (distance #p2 #p3))
      (setq #D2 (distance #p5 #p6))
      (setq #A1 (distance #p3 #p4))
      (setq #A2 (distance #p4 #p5))

      (setq #H  (nth 5 #XD$)) ; ���@H

      ; �_�C�A���O�\�����擾 01/10/09 YM ADD-E

      ; �_�C�A���O�\��
      (setq #WDH$ (list #D2 #D1 #H #W1 #W2)) ; ���p���ޗp ; NAS�p 01/10/10 YM @@@@@@@@@@@@@@@@@@@@@
      (setq #DLOG$ (PcGetStretchCabInfoDlg_N_CNR #WDH$))      ; NAS�p 01/10/10 YM @@@@@@@@@@@@@@@@@@@@@
      (if (not #DLOG$)
        (quit)
      );_if

      ; #DLOG$ �߂�l = D2,D1,H,W1,W2


      ; �L�k���s D2,D1,H,W1,W2 �̏��Ԃɍō��T��s��

    ;/////////////////////////////////////////////////////////////////////// <D2�������މ��s��>
      (if (not (equal (nth 0 #DLOG$) #D2 0.0001)) ; D2(W)
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (setq #BrkW (* #D2 0.5))

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))

          (CFSetXData #XLINE_W "G_BRK" (list 1))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_W "")

          (setq CG_TOKU_BW #BrkW)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 0 #DLOG$) #D2)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_W)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <D1�E�����މ��s��>
      (if (not (equal (nth 1 #DLOG$) #D1 0.0001)) ; D1(D)
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (setq #BrkD (* #D1 0.5))

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))

          (CFSetXData #XLINE_D "G_BRK" (list 2))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_D "")

          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD #BrkD)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; �ŐV�����g�p����
          (SKY_Stretch_Parts #sym (nth 3 #XD$) (+ (nth 4 #XD$)(- (nth 1 #DLOG$) #D1)) (nth 5 #XD$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_D)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <H����>
      (if (not (equal (nth 2 #DLOG$) #H 0.0001)) ; H
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (if CG_BASE_UPPER ; ���_
            (setq #BrkH (- #rZ 150)) ; ����َ��t������-150mm(fix)
;-- 2011/08/24 A.Satoh Mod - S
;            (setq #BrkH 100) ; ����_ H=100mm(fix)
            (setq #BrkH 480) ; ����_ H=480mm �b��
;-- 2011/08/24 A.Satoh Mod - S
          );_if

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))

          (CFSetXData #XLINE_H "G_BRK" (list 3))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_H "")

          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH #BrkH)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; �ŐV�����g�p����
          (SKY_Stretch_Parts #sym (nth 3 #XD$) (nth 4 #XD$) (nth 2 #DLOG$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_H)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <W1�E�����ފԌ�>
      (if (not (equal (nth 3 #DLOG$) #W1 0.0001)) ; W1(W)
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (setq #BrkW (+ #D2 (* #A1 0.5)))

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))

          (CFSetXData #XLINE_W "G_BRK" (list 1))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_W "")

          (setq CG_TOKU_BW #BrkW)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; �ŐV�����g�p����
          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 3 #DLOG$) #W1)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_W)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <W2�������ފԌ�>
      (if (not (equal (nth 4 #DLOG$) #W2 0.0001)) ; W2(D)
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (setq #BrkD (+ #D1 (* #A2 0.5)))

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))

          (CFSetXData #XLINE_D "G_BRK" (list 2))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_D "")

          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD #BrkD)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; �ŐV�����g�p����
          (SKY_Stretch_Parts #sym (nth 3 #XD$) (+ (nth 4 #XD$)(- (nth 4 #DLOG$) #W2)) (nth 5 #XD$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_D)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;//////////////////////////////////////////////////////////////////////////////////////////////

    )
    (progn ; ��Ű���ވȊO�̂Ƃ�
      (setq #tCNRflg nil)

      (if #TOKU_XD$
        (progn
          (setq #W1 (car   (nth 2 #TOKU_XD$))) ; ���@W1
          (setq #W2 (cadr  (nth 2 #TOKU_XD$))) ; ���@W2
          (setq #W3 (caddr (nth 2 #TOKU_XD$))) ; ���@W3
          ;03/10/17 YM ADD 4���ڔ����ǉ�
          (setq #W4 (nth 10 #TOKU_XD$)) ; ���@W4
        )
        (progn
          (setq #W1 (nth 2 CG_QRY$)) ; ���@W1
          (setq #W2 (nth 3 CG_QRY$)) ; ���@W2
          (setq #W3 (nth 4 CG_QRY$)) ; ���@W3
          (setq #W4 (nth 5 CG_QRY$)) ; ���@W4 03/10/17 YM ADD
        )
      );_if

      ;03/10/17 YM ADD 4���ڔ����ǉ�
      (if (= nil #W4)
        (setq #W4 0)
      );_if

      (setq #D  (nth 4 #XD$)) ; ���@D
      (setq #H  (nth 5 #XD$)) ; ���@H

      ; �_�C�A���O�\��
      (setq #WDH$ (list #D #H #W1 #W2 #W3 #W4)) ; �ʏ��ޗp ; NAS�p 01/10/09 YM #W4�ǉ� 03/10/17 YM
      (setq #DLOG$ (PcGetStretchCabInfoDlg_N #WDH$))     ; NAS�p 01/10/09 YM @@@@@@@@@@@@@@@@@@@@@
      (if (not #DLOG$)
        (quit)
      );_if

      ; #DLOG$ �߂�l = D,H,W1,W2,W3

      ; �L�k���s W1,W2,W3,D,H �̏��Ԃɍō��T��s��

    ;/////////////////////////////////////////////////////////////////////// <W����1>
      (if (not (equal (nth 2 #DLOG$) #W1 0.0001)) ; W1
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (setq #BrkW1 (* #W1 0.5))

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_W1 (PK_MakeBreakW #pt #ANG #BrkW1))

          (CFSetXData #XLINE_W1 "G_BRK" (list 1))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_W1 "")

          (setq CG_TOKU_BW #BrkW1)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 2 #DLOG$) #W1)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_W1)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <W����2>
      (if (and (not (equal #W2 0 0.0001))
               (not (equal (nth 3 #DLOG$) #W2 0.0001))) ; W2
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (setq #BrkW2 (+ (nth 2 #DLOG$)(* #W2 0.5)))

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_W2 (PK_MakeBreakW #pt #ANG #BrkW2))

          (CFSetXData #XLINE_W2 "G_BRK" (list 1))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_W2 "")

          (setq CG_TOKU_BW #BrkW2)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; �ŐV�����g�p����
          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 3 #DLOG$) #W2)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_W2)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <W����3>
      (if (and (not (equal #W3 0 0.0001))
               (not (equal (nth 4 #DLOG$) #W3 0.0001))) ; W3
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (setq #BrkW3 (+ (nth 2 #DLOG$)(nth 3 #DLOG$)(* #W3 0.5)))

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_W3 (PK_MakeBreakW #pt #ANG #BrkW3))

          (CFSetXData #XLINE_W3 "G_BRK" (list 1))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_W3 "")

          (setq CG_TOKU_BW #BrkW3)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; �ŐV�����g�p����
          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 4 #DLOG$) #W3)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_W3)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;03/10/17 YM ADD-S
    ;/////////////////////////////////////////////////////////////////////// <W����4> 4�����Ή�
      (if (and (not (equal #W4 0 0.0001))
               (not (equal (nth 5 #DLOG$) #W4 0.0001))) ; W4
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (setq #BrkW4 (+ (nth 2 #DLOG$)(nth 3 #DLOG$)(nth 4 #DLOG$)(* #W4 0.5)))

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_W4 (PK_MakeBreakW #pt #ANG #BrkW4))

          (CFSetXData #XLINE_W4 "G_BRK" (list 1))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_W4 "")

          (setq CG_TOKU_BW #BrkW4)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; �ŐV�����g�p����
          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 5 #DLOG$) #W4)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_W4)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)
    ;03/10/17 YM ADD-E 4�����Ή�

    ;/////////////////////////////////////////////////////////////////////// <D����>
      (if (not (equal (nth 0 #DLOG$) #D 0.0001)) ; D
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (setq #BrkD (* #D 0.5))

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))

          (CFSetXData #XLINE_D "G_BRK" (list 2))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_D "")

          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD #BrkD)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; �ŐV�����g�p����
          (SKY_Stretch_Parts #sym (nth 3 #XD$) (nth 0 #DLOG$) (nth 5 #XD$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_D)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <H����>
      (if (not (equal (nth 1 #DLOG$) #H 0.0001)) ; H
        (progn
          (setq #flg T) ; �L�k����������
          ;;; ��ڰ�ײ݈ʒu�擾
          (if CG_BASE_UPPER ; ���_
            (setq #BrkH (- #rZ 150)) ; ����َ��t������-150mm(fix)
;-- 2011/08/24 A.Satoh Mod - S
;            (setq #BrkH 100) ; ����_ H=100mm(fix)
            (setq #BrkH 480) ; ����_ H=480mm �b��
;-- 2011/08/24 A.Satoh Mod - E
          );_if

          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))

          (CFSetXData #XLINE_H "G_BRK" (list 3))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_H "")

          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH #BrkH)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; �ŐV�����g�p����
          (SKY_Stretch_Parts #sym (nth 3 #XD$) (nth 4 #XD$) (nth 1 #DLOG$))

          ;;; �ꎞ��ڰ�ײݍ폜
          (entdel #XLINE_H)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;//////////////////////////////////////////////////////////////////////////////////////////////

    )
  );_if


  ;;; ������ڰ�ײݕ���
  (foreach #eD #eDelBRK_W$ (entdel #eD)) ; W�����u���[�N����
  (foreach #eD #eDelBRK_D$ (entdel #eD)) ; D�����u���[�N����
  (foreach #eD #eDelBRK_H$ (entdel #eD)) ; H�����u���[�N����

  ;�F��߂�
  (command "_change" #ss "" "P" "C" "BYLAYER" "")

  ;����т̏ꍇ�͊���ѐF�ɂ���B
  (if (and (setq #bsym (car (CFGetXRecord "BASESYM")))
           (equal (handent #bsym) #sym))
    (progn
      (ResetBaseSym)
      (GroupInSolidChgCol #sym CG_BaseSymCol)
    )
  );_if

  ;;; �m�F�޲�۸�(�i��,���i���͉��)�͏�ɕ\������
; 02/07/09 YM DEL-S
;;; (if #flg
;;;   (progn
; 02/07/09 YM DEL-E

      (setq #ret$
        (ShowTOKUCAB_Dlog_N

          #HINBAN ; 01/10/17 YM MOD

;;;01/10/17YM@DEL         (if (= #LR "Z")
;;;01/10/17YM@DEL           (strcat #HINBAN) ; �i��
;;;01/10/17YM@DEL           (strcat #HINBAN #LR) ; �i��
;;;01/10/17YM@DEL         );_if

          "0"
          (list (nth 0 #DLOG$)(nth 1 #DLOG$)(nth 2 #DLOG$)) ; �ʏ��� ; �g���Ă��Ȃ�
          #ORG_price ; ���̉��i
          #sHINMEI ; �i��
          #sBIKOU  ; ���l
        )
      ); �i��,���i

      ; 01/10/17 YM ADD-S
      (if (= nil #ret$)
        (quit)
      );_if
      ; 01/10/17 YM ADD-E

      ; �S�p��߰��𔼊p��߰��ɒu�������� 01/06/27 YM ADD
      (setq #userHINBAN (vl-string-subst "  " "�@" (nth 0 #ret$))) ; հ�ް���͕i��
      ; 02/07/10 YM ADD-S
      (setq #userHINMEI (nth 2 #ret$)) ; հ�ް���͕i��
      (setq #userBIKOU  (nth 3 #ret$)) ; հ�ް���͔��l
      ; 02/07/10 YM ADD-E

      ;;; �_�C�A���O����l�����ꂽ���X�g������L���r�g���f�[�^�Ɋi�[
      (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))
      (CFSetXData #sym "G_TOKU"
        (list
          #userHINBAN   ; հ�ް���͕i��
          (nth 1 #ret$) ; ���i
;;;         (list (nth 0 #DLOG$)(nth 1 #DLOG$)(nth 2 #DLOG$))

          (if #tCNRflg ; 01/10/10 YM MOD
            "" ; ��Ű����
            (list (nth 2 #DLOG$)(nth 3 #DLOG$)(nth 4 #DLOG$)) ; (W1,W2,W3)���o���Ă���(����g�p)
          );_if

          1 ; 1:�������޺���� 0:��АL�k
;;;         CG_TOKU_BW ; W ��ڰ�ײ݈ʒu
;;;         CG_TOKU_BD ; D ��ڰ�ײ݈ʒu
;;;         CG_TOKU_BH ; H ��ڰ�ײ݈ʒu
          "" ; W ��ڰ�ײ݈ʒu ��а
          "" ; D ��ڰ�ײ݈ʒu ��а
          "" ; H ��ڰ�ײ݈ʒu ��а
          #HINBAN    ; ���̕i��

          ; 02/07/10 YM ADD-S �i�ԁA���i�ɉ����ĕi���Ɣ��l���ێ�����
          #userHINMEI   ; �i��(���ϖ���,�d�l�\�ł́u���́v)
          #userBIKOU    ; ���l(���ϖ��ׂł́u���l�v,�d�l�\�ł́u�d�l�v)
          ; 02/07/10 YM ADD-E

          (nth 5 #DLOG$);4���ڔ��� #W4 03/10/17 YM ADD

        )
      )

; 02/07/09 YM DEL-S
;;;   )
;;;   (princ "\n�L�k���܂���ł����B")
;;; );_if
; 02/07/09 YM DEL-E

  ; 02/07/09 YM ADD-S
  (if (= #flg nil)
    (princ "\n�L�k���܂���ł����B")
  )
  ; 02/07/09 YM ADD-E

  (princ)
); PcStretchCab_N

;<HOM>*************************************************************************
; <�֐���>    : PcGetStretchCabInfoDlg_N
; <�����T�v>  : �L�k�L���r�l�b�g�̃T�C�Y�Ɗg���f�[�^���e�l��(�ʏ���)
; <�߂�l>    : ���ʃ��X�g
; <�쐬>      : 01/10/09 YM NAS�p
; <���l>      :
;*************************************************************************>MOH<
(defun  PcGetStretchCabInfoDlg_N (
  &Defo$
;;;(list #D #H #W1 #W2 #W3) ����
  /
  #DCL_ID #ID #IH #IW1 #IW2 #IW3 #RES$
#iW4 ;03/10/17 YM ADD
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���p���l���ǂ���
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CHK_edit (
    &sKEY ; key
    &DEF  ; ��̫�Ēl
    &flg  ; �����׸� 0:���p���l , 1:���p���l>0 , 2:nil�łȂ�������
    /
    #val
    )
    (setq #val (read (get_tile &sKEY)))
    (cond
      ((and (= &flg 2)(= #val nil))
        (alert "���������͂��ĉ������B")
        (set_tile &sKEY &DEF)
        (mode_tile &sKEY 2)
      )
      ((= &flg 0)
        (if (or (= (type #val) 'INT)
                (= (type #val) 'REAL))
          (princ) ; ���p����������
          (progn
            (alert "���p�����l����͂��ĉ������B")
            (set_tile &sKEY &DEF)
            (mode_tile &sKEY 2)
          )
        );_if
      )
      ((= &flg 1)
        (if (and (or (= (type #val) 'INT)
                     (= (type #val) 'REAL))
                 (> #val 0.001)) ; �X�ɐ����ǂ������ׂ�(0�͕s��)
          (princ) ; OK
          (progn
            (alert "0���傫�Ȕ��p�����l����͂��ĉ������B")
            (set_tile &sKEY &DEF)
            (mode_tile &sKEY 2)
          )
        );_if
      )
    );_cond
    (princ)
  );##CHK_edit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ##GetDlgItem (
  / ; �޲�۸ނ̌��ʂ��擾����
  #RES$
  )
  (setq #RES$ (list
    (atoi (get_tile "D"))
    (atoi (get_tile "H"))
    (atoi (get_tile "W1"))
    (atoi (get_tile "W2"))
    (atoi (get_tile "W3"))
    (atoi (get_tile "W4")));03/10/17 YM ADD
  )
  (done_dialog)
  #RES$
);##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; �f�t�HWDH
  (setq #iD  (fix (nth 0 &Defo$)))
  (setq #iH  (fix (nth 1 &Defo$)))
  (setq #iW1 (fix (nth 2 &Defo$)))
  (setq #iW2 (fix (nth 3 &Defo$)))
  (setq #iW3 (fix (nth 4 &Defo$)))
  ;03/10/17 YM ADD-S
  (if (nth 5 &Defo$)
    (setq #iW4 (fix (nth 5 &Defo$)))
    (setq #iW4 0)
  );_if
  ;03/10/17 YM ADD-E

  ;;; �_�C�A���O�̎��s��
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (not (new_dialog "GetStretchCabInfoDlg_N" #dcl_id)) (exit))

  ;;; �f�t�H������̐ݒ�
;;;  (set_tile "Msg1" "   �ΏۃL���r�l�b�g �̃T�C�Y��")
;;;  (set_tile "Msg2" (strcat "   ���� ��= " (itoa #iW) ", ���s= " (itoa #iD) ", ����= " (itoa #iH) " �ł�"))
  (set_tile "D"  (itoa #iD))
  (set_tile "H"  (itoa #iH))
  (set_tile "W1" (itoa #iW1))

  (if (equal #iW2 0 0.1)
    (progn
      (set_tile "W2" "0")
      (mode_tile "W2" 1) ; �g�p�s�\
    )
    (progn
      (set_tile "W2" (itoa #iW2))
    )
  );_if

  (if (equal #iW3 0 0.1)
    (progn
      (set_tile "W3" "0")
      (mode_tile "W3" 1) ; �g�p�s�\
    )
    (progn
      (set_tile "W3" (itoa #iW3))
    )
  );_if

  ;03/10/17 YM ADD-S
  (if (equal #iW4 0 0.1)
    (progn
      (set_tile "W4" "0")
      (mode_tile "W4" 1) ; �g�p�s�\
    )
    (progn
      (set_tile "W4" (itoa #iW4))
    )
  );_if
  ;03/10/17 YM ADD-E

  ;;; �^�C���̃��A�N�V�����ݒ� ���p����������
  (action_tile "D"  "(##CHK_edit \"D\"  (itoa #iD ) 1)")
  (action_tile "H"  "(##CHK_edit \"H\"  (itoa #iH ) 1)")
  (action_tile "W1"  "(##CHK_edit \"W1\"  (itoa #iW1 ) 1)")
  (action_tile "W2"  "(##CHK_edit \"W2\"  (itoa #iW2 ) 1)")
  (action_tile "W3"  "(##CHK_edit \"W3\"  (itoa #iW3 ) 1)")
  (action_tile "W4"  "(##CHK_edit \"W4\"  (itoa #iW4 ) 1)");03/10/17 YM ADD

  (action_tile "accept" "(setq #RES$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #RES$ nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #RES$
);PcGetStretchCabInfoDlg_N

;<HOM>*************************************************************************
; <�֐���>    : PcGetStretchCabInfoDlg_N_CNR
; <�����T�v>  : �L�k�L���r�l�b�g�̃T�C�Y�Ɗg���f�[�^���e�l��(���p����)
; <�߂�l>    : ���ʃ��X�g
; <�쐬>      : 01/10/10 YM NAS�p
; <���l>      :
;*************************************************************************>MOH<
(defun  PcGetStretchCabInfoDlg_N_CNR (
  &Defo$
;;;(list #D2 #D1 #H #W1 #W2) ����
  /
  #DCL_ID #ID1 #ID2 #IH #IW1 #IW2 #RES$
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; �����̃L�[�ȊO�͸�ڰ���
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##STOP (
    &sKEY ; key
    /
    )
    (cond
      ((= &sKEY "D2")
        (mode_tile "D1" 1) ; �g�p�s�\
        (mode_tile "H"  1) ; �g�p�s�\
        (mode_tile "W1" 1) ; �g�p�s�\
        (mode_tile "W2" 1) ; �g�p�s�\
      )
      ((= &sKEY "D1")
        (mode_tile "D2" 1) ; �g�p�s�\
        (mode_tile "H"  1) ; �g�p�s�\
        (mode_tile "W1" 1) ; �g�p�s�\
        (mode_tile "W2" 1) ; �g�p�s�\
      )
      ((= &sKEY "H")
        (mode_tile "D1" 1) ; �g�p�s�\
        (mode_tile "D2" 1) ; �g�p�s�\
        (mode_tile "W1" 1) ; �g�p�s�\
        (mode_tile "W2" 1) ; �g�p�s�\
      )
      ((= &sKEY "W1")
        (mode_tile "D1" 1) ; �g�p�s�\
        (mode_tile "D2" 1) ; �g�p�s�\
        (mode_tile "H"  1) ; �g�p�s�\
        (mode_tile "W2" 1) ; �g�p�s�\
      )
      ((= &sKEY "W2")
        (mode_tile "D1" 1) ; �g�p�s�\
        (mode_tile "D2" 1) ; �g�p�s�\
        (mode_tile "H"  1) ; �g�p�s�\
        (mode_tile "W1" 1) ; �g�p�s�\
      )
    );_cond
    (princ)
  );##STOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; �����l�ɖ߂�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##clear (
    /
    #ID1 #ID2 #IH #IW1 #IW2
    )
    (mode_tile "D1" 0) ; �g�p��
    (mode_tile "D2" 0) ; �g�p��
    (mode_tile "H"  0) ; �g�p��
    (mode_tile "W1" 0) ; �g�p��
    (mode_tile "W2" 0) ; �g�p��
    (setq #iD2 (fix (nth 0 &Defo$)))
    (setq #iD1 (fix (nth 1 &Defo$)))
    (setq #iH  (fix (nth 2 &Defo$)))
    (setq #iW1 (fix (nth 3 &Defo$)))
    (setq #iW2 (fix (nth 4 &Defo$)))
    ;;; �f�t�H������̐ݒ�
    (set_tile "D2" (itoa #iD2))
    (set_tile "D1" (itoa #iD1))
    (set_tile "H"  (itoa #iH))
    (set_tile "W1" (itoa #iW1))
    (set_tile "W2" (itoa #iW2))
    (princ)
  );##clear

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���p���l���ǂ���
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CHK_edit (
    &sKEY ; key
    &DEF  ; ��̫�Ēl
    &flg  ; �����׸� 0:���p���l , 1:���p���l>0 , 2:nil�łȂ�������
    /
    #val
    )

    (setq #val (read (get_tile &sKEY)))
    (cond
      ((and (= &flg 2)(= #val nil))
        (alert "���������͂��ĉ������B")
        (set_tile &sKEY &DEF)
        (mode_tile &sKEY 2)
      )
      ((= &flg 0)
        (if (or (= (type #val) 'INT)
                (= (type #val) 'REAL))
          (princ) ; ���p����������
          (progn
            (alert "���p�����l����͂��ĉ������B")
            (set_tile &sKEY &DEF)
            (mode_tile &sKEY 2)
          )
        );_if
      )
      ((= &flg 1)
        (if (and (or (= (type #val) 'INT)
                     (= (type #val) 'REAL))
                 (> #val 0.001)) ; �X�ɐ����ǂ������ׂ�(0�͕s��)
          (progn ; 03/02/05 YM ADD-S
            ; �ҏW�����{�b�N�X�ȊO�͕ҏW�s�Ƃ���
            (cond
              ((= &sKEY "D2")
                (if (= #val (nth 0 &Defo$))
                  nil ; �����l�Ɠ����Ȃ牽�����Ȃ�
                  (##STOP "D2") ; �����ȊO���g�p�֎~
                );_if
              )
              ((= &sKEY "D1")
                (if (= #val (nth 1 &Defo$))
                  nil ; �����l�Ɠ����Ȃ牽�����Ȃ�
                  (##STOP "D1") ; �����ȊO���g�p�֎~
                );_if
              )
              ((= &sKEY "H")
                (if (= #val (nth 2 &Defo$))
                  nil ; �����l�Ɠ����Ȃ牽�����Ȃ�
                  (##STOP "H") ; �����ȊO���g�p�֎~
                );_if
              )
              ((= &sKEY "W1")
                (if (= #val (nth 3 &Defo$))
                  nil ; �����l�Ɠ����Ȃ牽�����Ȃ�
                  (##STOP "W1") ; �����ȊO���g�p�֎~
                );_if
              )
              ((= &sKEY "W2")
                (if (= #val (nth 4 &Defo$))
                  nil ; �����l�Ɠ����Ȃ牽�����Ȃ�
                  (##STOP "W2") ; �����ȊO���g�p�֎~
                );_if
              )
            );_cond
          ) ; 03/02/05 YM ADD-E
          (progn
            (alert "0���傫�Ȕ��p�����l����͂��ĉ������B")
            (set_tile &sKEY &DEF)
            (mode_tile &sKEY 2)
          )
        );_if
      )
    );_cond
    (princ)
  );##CHK_edit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ##GetDlgItem (
  / ; �޲�۸ނ̌��ʂ��擾����
  #RES$
  )
  (setq #RES$ (list
    (atoi (get_tile "D2"))
    (atoi (get_tile "D1"))
    (atoi (get_tile "H"))
    (atoi (get_tile "W1"))
    (atoi (get_tile "W2")))
  )
  (done_dialog)
  #RES$
);##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;(list #D2 #D1 #H #W1 #W2) ����
  (setq #iD2 (fix (nth 0 &Defo$)))
  (setq #iD1 (fix (nth 1 &Defo$)))
  (setq #iH  (fix (nth 2 &Defo$)))
  (setq #iW1 (fix (nth 3 &Defo$)))
  (setq #iW2 (fix (nth 4 &Defo$)))

  ;;; �_�C�A���O�̎��s��
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (not (new_dialog "GetStretchCabInfoDlg_N_CNR" #dcl_id)) (exit))

  ;;; �f�t�H������̐ݒ�
  (set_tile "D2" (itoa #iD2))
  (set_tile "D1" (itoa #iD1))
  (set_tile "H"  (itoa #iH))
  (set_tile "W1" (itoa #iW1))
  (set_tile "W2" (itoa #iW2))

  ;;; �^�C���̃��A�N�V�����ݒ� ���p����������
  (action_tile "D2" "(##CHK_edit \"D2\" (itoa #iD2 ) 1)")
  (action_tile "D1" "(##CHK_edit \"D1\" (itoa #iD1 ) 1)")
  (action_tile "H"  "(##CHK_edit \"H\"  (itoa #iH  ) 1)")
  (action_tile "W1" "(##CHK_edit \"W1\" (itoa #iW1 ) 1)")
  (action_tile "W2" "(##CHK_edit \"W2\" (itoa #iW2 ) 1)")
  (action_tile "BUTTON"  "(##CLEAR)")

  (action_tile "accept" "(setq #RES$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #RES$ nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #RES$
);PcGetStretchCabInfoDlg_N_CNR

;<HOM>*************************************************************************
; <�֐���>    : ShowTOKUCAB_Dlog_N
; <�����T�v>  : �������޺���މ��i,�i�Ԋm�F�޲�۸�
; <�߂�l>    : ���i,�i��
; <�쐬>      : 01/01/29 YM
; <���l>      :
; ***********************************************************************************>MOH<
(defun ShowTOKUCAB_Dlog_N (
  &HINBAN
  &PRICE ; ���i��̫�Ēl
  &WDH
  &ORG_price ; ���̉��i
  &sHINMEI ; �i�� 01/08/20 YM ADD
  &sBIKOU  ; ���l 01/08/20 YM ADD
  /
  #SDCLID #RES$
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckNum (&sKEY / #val #ret)
    (setq #ret nil)
    (setq #val (read (get_tile &sKEY)))
    (if (= (type (read (get_tile &sKEY))) 'INT)
      (if (< #val -0.00001)
        (progn
          (alert "0�ȏ�̐����l����͂��ĉ�����")
          (set_tile &sKEY "")
          (mode_tile &sKEY 2)
        )
        (setq #ret T)
      );_if
      (progn
        (alert "0�ȏ�̐����l����͂��ĉ�����")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckStr (&sKEY / #ret)
    (setq #ret nil)
; 03/01/27 YM DEL-S
;;;    (if (= (type (read (get_tile &sKEY))) 'SYM)
;;;     (progn
; 03/01/27 YM DEL-E

        (if (= (get_tile &sKEY) &HINBAN)
          (progn
            (alert "�����i�Ԃ���͂��ĉ�����")
;;;           (set_tile &sKEY "")
            (mode_tile &sKEY 2)
          )
          (setq #ret T)
        );_if

; 03/01/27 YM DEL-S
;;;     )
;;;     (progn
;;;        (alert "���������͂��ĉ�����")
;;;        (set_tile &sKEY "")
;;;        (mode_tile &sKEY 2)
;;;     )
;;;    );_if
; 03/01/27 YM DEL-E

    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; �S���ڃ`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (defun ##Check&GetAllVal ( / #DLG$)
    (cond
      ((not (##CheckNum "edtTOKU_PRI"))  nil) ; ���ڂɴװ�������nil��Ԃ�
      ((not (##CheckStr "edtTOKU_ID")) nil)   ; ���ڂɴװ�������nil��Ԃ�
;;;     ; 02/07/10 YM ADD-S
;;;     ((not (##CheckStr "edtHINMEI")) nil)    ; ���ڂɴװ�������nil��Ԃ�
;;;     ((not (##CheckStr "edtBIKOU")) nil)     ; ���ڂɴװ�������nil��Ԃ�
;;;     ; 02/07/10 YM ADD-E

      (T ; ���ڂɴװ�Ȃ�
        (setq #DLG$
          (list
            (strcase (get_tile "edtTOKU_ID"))  ; �i�� �啶���ɂ���
;;;02/01/21YM@MOD           (atoi (get_tile "edtTOKU_PRI"))      ; ���i(�~)
            (atof (get_tile "edtTOKU_PRI")) ; ���i 02/01/21 YM �����ɂ���(����16bit)
            ; 02/07/10 YM ADD-S
            (get_tile "edtHINMEI")  ; �i��
            (get_tile "edtBIKOU")   ; ���l
            ; 02/07/10 YM ADD-E
          )
        )
        (done_dialog)
        #DLG$
      )
    );_cond
  ); end of ##Check&GetAllVal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; �S���ڃ`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (defun ##Exit ( / )
    (done_dialog)
    nil
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;; �_�C�A���O�̎��s��
  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "ShowTOKUCABDlg_N" #sDCLID)) (exit))

  ; �����l�̐ݒ� ; txtORG_PRICE
  (set_tile "edtTOKU_ID" &HINBAN) ; �i��
  (set_tile "edtTOKU_PRI" &PRICE) ; ���i
  (set_tile "txtORG_PRICE" (strcat "�@���̉��i�F " &ORG_price "�~"))

  ; 02/07/10 YM MOD-S ��ި���ޯ���ɕύX
;;;  (set_tile "txtHINMEI"    (strcat "�@�i�@���@�@�F " &sHINMEI)) ; �i�� 01/08/20 YM ADD
;;;  (set_tile "txtBIKOU"     (strcat "�@���@�l�@�@�F " &sBIKOU))  ; ���l 01/08/20 YM ADD
  (set_tile "edtHINMEI" &sHINMEI) ; �i��
  (set_tile "edtBIKOU"  &sBIKOU)  ; ���l
  ; 02/07/10 YM MOD-E

;;;01/10/17YM@DEL (mode_tile "edtTOKU_PRI" 2)
  (mode_tile "edtTOKU_ID" 2)

;;;  (set_tile "edtTOKU_W" (nth 0 &WDH))
;;;  (set_tile "edtTOKU_D" (nth 1 &WDH))
;;;  (set_tile "edtTOKU_H" (nth 2 &WDH))

  ;;; �^�C���̃��A�N�V�����ݒ�
;;;  (action_tile "edtTOKU_ID"  "(##CHK_edit \"edtTOKU_ID\"  &HINBAN 2)")
;;;  (action_tile "edtTOKU_PRI" "(##CHK_edit \"edtTOKU_PRI\" &PRICE  1)")

  ; OK�{�^���������ꂽ��S���ڂ��`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (action_tile "accept" "(setq #RESULT$ (##Check&GetAllVal))")
  (action_tile "cancel" "(setq #RESULT$ (##Exit))") ; cancel

  (start_dialog)
  (unload_dialog #sDCLID)
  ; ���X�g��Ԃ�
  #RESULT$
);ShowTOKUCAB_Dlog_N

;<HOM>*************************************************************************
; <�֐���>    : PhSelColorMixPatternDlg
; <�����T�v>  : COLOR�~�b�N�X�p�^�[���̑I��
; <�߂�l>    : COLOR�~�b�N�X�p�^�[��(STR)
; <�쐬>      : 01/10/11 YM
; <���l>      : �Ȃ�(��۰��ٕϐ��ɾ��) CG_ColMix ="[��Mix��].Я������"
;               PHCAD�ȊO�͉������Ȃ�
;*************************************************************************>MOH<
(defun PhSelColorMixPatternDlg (
  /

  )
  nil
);PhSelColorMixPatternDlg

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_ZaisituDlg
;;; <�����T�v>  : �ގ��I���_�C�A���O
;;; <�߂�l>    : �ގ��L��
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKW_ZaisituDlg (
  /
  #DCL_ID #POP$ #QRY$$ #ZAI #ZCODE #SINA_Type #dum$$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_ZaisituDlg ////")
  (CFOutStateLog 1 1 " ")

  (setq #SINA_Type (KPGetSinaType)) ; ���i����=3(Sophy & Shera)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #zai #cut
            )
            (setq #zai (nth (atoi (get_tile "zai")) #pop$)) ; �ގ��L��

            (setq #cut nil)
            (cond
              ((= (get_tile "radio1") "1")(setq #cut 0))
              ((= (get_tile "radio2") "1")(setq #cut 1))
              ((= (get_tile "radio3") "1")(setq #cut 2))
              ((= (get_tile "radio4") "1")(setq #cut 3))
            );_cond

            (if #cut
              (progn
                (done_dialog)
                (list #zai #cut)
              )
              (progn
                (CFAlertMsg "�J�b�g�̎�ނ�I�����ĉ������B")
                (princ)
              )
            );_if

          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �߯�߱���ؽ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( / #dum$$) ; �ގ��|�b�v�A�b�v���X�g
            (setq #pop$ '())
            (start_list "zai" 3)
						(setq #dum$$ nil)
            (foreach #Qry$ #Qry$$
							;2011/09/18 YM ADD-S �`��ōގ����i�荞��
							(if (wcmatch CG_W2CODE (nth 9 #Qry$)) ;�Ή��\�Ȍ`��(��ϋ�؂�) Z,L,U
								(progn
	              	(add_list (strcat (nth 1 #Qry$) " : " (nth 2 #Qry$)))
									(setq #dum$$ (append #dum$$ (list #Qry$)))
              		(setq #pop$ (append #pop$ (list (nth 1 #Qry$)))) ; �ގ��L���̂ݕۑ�
								)
							);_if
            )
						;2011/09/18 YM ADD �`��ōގ����i�荞��
						(setq #Qry$$ #dum$$);�i�荞�񂾂��̂ɍX�V
            (end_list)
            (set_tile "zai" "0") ; �ŏ���̫���
            (setq #Zcode (nth (atoi (get_tile "zai")) #pop$))  ; ���ݑI�𒆂̍ގ�
            (princ)
          );##Addpop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �ގ��ɂ���Ķ�Ď�ނ𐧌�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Check_CUT ( / #zK #ZaiF #ZCODE #qry_zai$ #cut_typ)
            (setq #Zcode (nth (atoi (get_tile "zai")) #pop$))  ; ���ݑI�𒆂̍ގ�
            (setq #ZaiF (KCGetZaiF #Zcode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ

            (cond
              ((= CG_W2CODE "Z")
                (set_tile "radio1" "1") ; ��ĂȂ�
                (mode_tile "cut"  1) ; �g�p�s�\ ��Ď��׼޵
              )
              (T
                (mode_tile "cut"  0)    ; �g�p�\ ��Ď��׼޵
								;L�^,U�^
                ;mdb����
                (setq #qry_zai$
                  (CFGetDBSQLRec CG_DBSESSION "WT�ގ�"
                    (list
                      (list "�ގ��L��" #Zcode 'STR)
                    )
                  )
                )
							 	(setq #cut_typ (nth 6 (car #qry_zai$)));X,J,N
							 	(cond
									((= #cut_typ "N")
                  	(set_tile  "radio1" "1") ; ��ĂȂ�
										(mode_tile "radio2" 1)
										(mode_tile "radio3" 1)
										(mode_tile "radio4" 1)
								 	)
									((= #cut_typ "X")
										(mode_tile "radio1" 1)
                  	(set_tile  "radio2" "1") ; �΂߶��
										(mode_tile "radio3" 1)
										(mode_tile "radio4" 1)
								 	)
									((= #cut_typ "J")
										(mode_tile "radio1" 1)
										(mode_tile "radio2" 1)
                  	(set_tile  "radio3" "1") ; ������� KDA�Ή� 03/10/13 YM ADD
										(mode_tile "radio4" 1)
								 	)
									((= #cut_typ "S")
										(mode_tile "radio1" 1)
										(mode_tile "radio2" 1)
										(mode_tile "radio3" 1)
                  	(set_tile  "radio4" "1") ; ������� KDA�Ή� 03/10/13 YM ADD
								 	)
									(T
                  	(set_tile  "radio1" "1") ; ��ĂȂ�
										(mode_tile "radio2" 1)
										(mode_tile "radio3" 1)
										(mode_tile "radio4" 1)
								 	)
								);_cond

              )
            );_cond

            (princ)
          );##Check_CUT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;// �ގ��L���̑I��
  (setq #Qry$$
    (DBSqlAutoQuery CG_DBSESSION
      (strcat "select * from WT�ގ� where �p��F=0")
    )
  )
  (setq #Qry$$ (CFListSort #Qry$$ 0)) ; (nth 0 �����������̏��ɿ�� 01/05/28 YM ADD

  ; �p��F��1�łȂ����� 01/08/10 YM ADD START
  (setq #dum$$ nil)
  (foreach #Qry$ #Qry$$
    (setq #dum$$ (append #dum$$ (list #Qry$)))
  )
  (setq #Qry$$ #dum$$)
  ; �p��F��1�łȂ����� 01/08/10 YM ADD END

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "ZaisituDlg" #dcl_id)) (exit))

  ;;; �߯�߱���ؽ�
  (##Addpop)
  ;;; ������Ď�ސݒ�
  (##Check_CUT)

  ;// ��ق�ر���ݐݒ�
  (action_tile "zai" "(##Check_CUT)")
  (action_tile "accept" "(setq #zai (##GetDlgItem))")
  (action_tile "cancel" "(setq #zai nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #zai
);PKW_ZaisituDlg

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_DansaHantei
;;; <�����T�v>  : �i�C�Ӕz�u�j���[�N�g�b�v�������� I�^,L�^,U�^�Ή�,D��đΉ�
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_DansaHantei (
  &base$ ;
  /
  #EN_LOW$ #H #HND #HNDB #SS_DEL #THR
  )
  (setq #hndB (car (CFGetXRecord "BASESYM"))) ; �����
  (setq #en_LOW$ nil)
  (setq #ss_del (ssadd))
  ;;; ۰���ޕ��ނ������I�ɏ��O(���@H�����Ă���)
  (foreach #en &base$
    (setq #thr (CFGetSymSKKCode #en 3))
    (cond
      ; 02/03/28 YM MOD-S
      ((or (= #thr CG_SKK_THR_GAS)(= #thr CG_SKK_THR_NRM))
        (setq #h (nth 5 (CFGetXData #en "G_SYM")))
        (if (and (> #h 450) (< #h 550)) ; ����۰���߂̷���ȯĂ�����Βi������
          (progn ; �i�����ޏ��O
            (setq CG_Type2Code "D") ; "F","D"
            (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ۰���߷���ȯļ���ِ}�`ؽ�
            ;;; ����тȂ��
            (setq #hnd  (cdr (assoc 5 (entget #en))))
            (if (equal #hnd #hndB)
              (GroupInSolidChgCol #en CG_BaseSymCol) ; ��
              (GroupInSolidChgCol2 #en "BYLAYER") ; �F��߂�
            );_if
            (ssadd #en #ss_del) ; ��ŏ��O����
          )
        );_if
      )
      ; 02/03/28 YM MOD-E
    );_cond
  );_(foreach #en #en$   ;// ۰���ޕ��ނ��Ȃ�
  (list #ss_del #en_LOW$)
);KP_DansaHantei


; �����ݸ޼�� 02/09/03 YM ADD

;<HOM>*************************************************************************
; <�֐���>    : SKAutoError1
; <�����T�v>  : �װ�֐� �����ݸ޼��
;*************************************************************************>MOH<
(defun SKAutoError1 ( msg / #msg )
;;;  (princ "\n�������C�A�E�g���������f����܂���.")
  (setq #msg "���C����ʂɖ߂�܂�")
  (CFAlertMsg #msg)

;;;  ;// �G���[���O���o�͂���
;;;  (CFOutErrLog)
;;;  (foreach #msg CG_ERRMSG
;;;    (CFOutLog 0 1 #msg)
;;;  )
  (setvar "FILEDIA" 1)
  (if (/= CG_DBSESSION nil)
    (DBDisConnect CG_DBSession)
  )
  (if (/= CG_CDBSESSION nil)
    (DBDisConnect CG_CDBSession)
  )
  (setq CG_DBSESSION nil)
  (setq CG_CDBSESSION nil)
;;;  (startapp (strcat CG_SYSPATH "WARN.EXE"))
;;;  (if (= CG_AUTOFLAG "1")
    (command "_quit" "y")
;;;  )
  (princ)
);SKAutoError1

; WEB�� 02/09/03 YM ADD

;<HOM>*************************************************************************
; <�֐���>    : SKAutoError2
; <�����T�v>  : �װ�֐� WEB��CAD���ް
;*************************************************************************>MOH<
(defun SKAutoError2 ( msg / #msg )
  (princ "\n�������C�A�E�g���������f����܂���.")

;;;(WebOutLog "msg=")
;;;(WebOutLog msg)
;;;(WebOutLog "CG_ERRMSG=")
;;;(WebOutLog CG_ERRMSG)

  ;// �G���[���O�o�͗p������ɒǉ�����
  (if (/= msg CG_ERRMSG)
    (setq CG_ERRMSG (append CG_ERRMSG (list msg)))
  );_if

;;;  (CFAlertMsg msg) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@ ��ō폜����!!!

;;; ; �ʏ�۸ނɏ�������
;;;  (foreach #msg CG_ERRMSG
;;;   (WebOutLog CG_ERRMSG)    ; 02/09/04 YM ADD ۸ޏo�͒ǉ�
;;;  )

  ; �װ۸ނɏ�������
  (CFOutErrLog)

  (setvar "FILEDIA" 1)
  (if (/= CG_DBSESSION nil)
    (DBDisConnect CG_DBSession)
  )
  (if (/= CG_CDBSESSION nil)
    (DBDisConnect CG_CDBSession)
  )

  (setq CG_DBSESSION nil)
  (setq CG_CDBSESSION nil)

;;;  (startapp (strcat CG_SYSPATH "WARN.EXE"))
;;;  (if (= CG_AUTOFLAG "1")
    (command "_quit" "y")
;;;  )
  (princ)
);SKAutoError2

;////////////////////////////////////////////////////////////////////////////////
; ���ݑ}�������
(defun C:ib ()
  (C:KP_InBlock)
)
; ���ݕۑ������
(defun C:wb ()
  (C:KP_WrBlock)
)
;////////////////////////////////////////////////////////////////////////////////

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KP_WrBlock
;;; <�����T�v>  : �������݂𖼑O��t���ĕۑ�����(��ōė��p����)
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/04/25 YM
;;; <���l>      : �}�ʏ�ɃA�C�e�����Ȃ��ƃ_��,��A�C�e���̐F��"BYLAYER"�ŕۑ�����
;;;*************************************************************************>MOH<
(defun C:KP_WrBlock (
  /
  #EN #FLGTOKU #HAND #HNDB #I #IFILEDIA #J #N #PICKSTYLE #RET #SFNAME #SS #SSARW
  #SSKUTAI #SSROOM #SSTOKU #SSYASI #SS_DUM #TENDFLG #XDYASI$
#MODEL #MODEL_BACK ; 03/05/12 YM ADD
#PATH #PATH0       ; 03/07/04 YM
  )
    ;//////////////////////////////////////////////////////////////////////
    ;���ٰ�݉� 03/05/13 YM
    ;//////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL_SUB ( &ss / #i )
      (if (and &ss (> (sslength &ss) 0)) ; ��A�C�e���̖��
        (progn
          ;// �V���ɒǉ����ꂽ��A�C�e���̖����폜����
          (setq #i 0)
          (repeat (sslength &ss)
            (entdel (ssname &ss #i))
            (setq #i (1+ #i))
          )
        )
      );_if
      (princ)
    );##ENTDEL_SUB
    ;//////////////////////////////////////////////////////////////////////
    ;���ٰ�݉�&���̈ꎞ�폜�ǉ� 03/05/13 YM
    ;//////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL ( / )
      ;��A�C�e���̖����ꎞ�폜����
      (##ENTDEL_SUB #ssARW)
      ;�}�ʘg�ƓV��̓_���ꎞ�폜����
      (##ENTDEL_SUB #ssROOM)
      ;�}�ʏ�̔����ꎞ�폜����
      (##ENTDEL_SUB #ssDOOR)
      (princ)
    );##ENTDEL
    ;//////////////////////////////////////////////////////////////////////

  (StartUndoErr);// �R�}���h�̏�����
  (setq #iFILEDIA (getvar "FILEDIA"))
  (setvar "FILEDIA" 1)

  ; 02/11/11 YM ADD ��̂̂ݏ����o�����[�h��I���\
  (setq #ret (KPGetBlockWrInsModeDlg))
  (if (= #ret nil)
    (*error*)
  ; else
    (if (= "1" #ret)
      (progn ; ���܂łǂ���}�ʑS�̂�ۑ� ----------------------------------------------

        (setq #ssTOKU (ssget "X" '((-3 ("G_TOKU")))))
        (setq #flgTOKU nil)
        (if (and #ssTOKU (< 0 (sslength #ssTOKU)))
          (progn ; ��������(��АL�k�łȂ�)�����݂���ƏI�� 01/05/15 YM ADD
            (setq #i 0)
            (repeat (sslength #ssTOKU)
              (if (= 1 (nth 3 (CFGetXData (ssname #ssTOKU #i) "G_TOKU")))
                (setq #flgTOKU T)
              );_if
              (setq #i (1+ #i))
            )
            (if #flgTOKU
              (progn
                (CFAlertErr "�}�ʏ�ɓ����L���r�l�b�g�����݂��邽�߁A�v�����ۑ��ł��܂���B")
                (*error*)
              )
            );_if
          )
        );_if

        (setq #ssARW  (ssget "X" '((-3 ("G_ARW")))))
        (setq #ssROOM (ssget "X" '((-3 ("G_ROOM")))))
        ; 03/05/13 YM ADD-S �}�ʏ�̑S���}�`
        (setq #ssDOOR (KP_GetAllDoor))
        ; 03/05/13 YM ADD-S
        (setq #PICKSTYLE (getvar "PICKSTYLE"))
        (setvar "PICKSTYLE" 3)

        ;���ݑ��݂����}�̈�ԍ����l��
        (setq #ssYASI (ssget "X" (list (list -3 (list "RECT")))))
        ; �������΍폜����
        (if (and #ssYASI (> (sslength #ssYASI) 0)) ; �
          (if (CFYesNoDialog "�ۑ��O�ɖ���폜����K�v������܂��B\n����폜���܂����H")
            (progn
              ; ��폜
              (setq #i 0)
              (repeat (sslength #ssYASI) ; ���������
                (setq #en (ssname #ssYASI #i))
                (setq #xdYASI$ (CFGetXData #en "RECT")) ; �g���ް�
                (setq #n 3 #hand (nth #n #xdYASI$))
                (while #hand
                  (command "_erase" (handent #hand) "")
                  (setq #n (1+ #n))
                  (setq #hand (nth #n #xdYASI$))
                )
                (command "_erase" #en "")
                (setq #i (1+ #i))
              )
            )
            (*error*)
          );_if
        );_if

        ; �g�A�V��̓_�A�����ꎞ�I�ɍ폜���� 01/05/10 YM ADD
        (##ENTDEL) ; 03/05/13 YM �����ꎞ�폜

        (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
        (if (and #ss (> (sslength #ss) 0))
          (progn ; �}�ʏ�ɉ������ނ�����Ƃ�
            ; ��A�C�e���̐F���ꎞ�I�Ɍ��ɖ߂�
            (setq #hndB (car (CFGetXRecord "BASESYM"))) ; �����
            (if (and #hndB (/= #hndB ""))
              (GroupInSolidChgCol2 (handent #hndB) "BYLAYER")  ;BYLAYER�F�ɕύX
            )

          ; CG_DBNAME DB����̫��ނ�����΂����ɁA�Ȃ���Ώ]���ʂ�ذ�ދL����̫��ނɕۑ�����
          ; 03/07/04 YM MOD-S
          (setq #path0 (strcat CG_SYSPATH "PLAN\\" CG_DBNAME))
          (if (findfile #path0)
            ;�V�ذ�� NK_KSA,NK_KGA �Ȃ�
            (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\"))
            ;else   �]���ذ��(NK_CKC,NK_CKN �Ȃ�)
            (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
          );_if
;;;         (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\")) ; 03/07/04 YM MOD
          ; CG_DBNAME DB�� 03/07/04 YM MOD-E

            ; ̧�َw��
            (setq #sFname (getfiled "���O��t���ĕۑ�" #path "dwg" 1))
            (if #sFname
              (progn
      ;;;01/05/14YM@          (command "_purge" "A" "*" "N") ; �S�Ă��߰�ނ��� 01/05/14

                ; 03/07/09 YM ADD �s�v�ȸ�ٰ�ߒ�`���폜����
                (KP_DelUnusedGroup)

                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")

                ; MODEL.DWG��SAVE 01/10/24 ADD-S
                (command "_.QSAVE")
                ; MODEL.DWG��SAVE 01/10/24 ADD-E

      ;;;         (command "_.save" #sFname) ; ���� 01/08/31 YM MOD
      ;;;         (command "_.SAVEAS" "2000" #sFname) ; saveas ���ƌ��ݐ}�ʂ�"Model.dwg"�ł͂Ȃ��Ȃ�

                ; 01/10/24 YM ADD-S ��߰��,��߰�� -->̧�ي����Ȃ��߰�Ɏ��s
                (setq #tEndFlg (vl-file-copy  (strcat CG_KENMEI_PATH "MODEL.DWG") #sFname nil))
                (if (= nil #tEndFlg)
                  (progn ; ����̧�ق����߰�s�̏ꍇ
                    (vl-file-delete #sFname)
                    (vl-file-copy  (strcat CG_KENMEI_PATH "MODEL.DWG") #sFname nil)
                  )
                );_if
                ; 01/10/24 YM ADD-E

      ;;;         ; 01/08/31 YM ADD-S MODEL.dwg���J��
      ;;;         (CfDwgOpenByScript (strcat CG_KENMEI_PATH "MODEL.DWG"))
      ;;;         ; 01/08/31 YM ADD-E
              )
              (progn
                (CFAlertMsg "\n�ۑ����܂���ł����B")
                (*error*)
              )
            );_if

            ; ��A�C�e���̐F�����̗΂ɖ߂�
            (if (and #hndB (/= #hndB ""))
              (GroupInSolidChgCol2 (handent #hndB) CG_BaseSymCol) ;�ΐF�ɕύX
            )
          )
          (progn
            (CFAlertMsg "\n�}�ʏ�ɕ��ނ�����܂���B")
            (*error*)
          )
        );_if

        ; �g�A�V��̓_�A���𕜊������� 01/05/10 YM ADD
        (##ENTDEL)
      )
      (progn ; ��̂̂ݕۑ����� ---------------------------------------------------------------------------------------

        ; ���݂�MODEL.dwg��ۑ����ĕʖ��ŊJ�� 03/01/24 YM ADD
        (command "_.QSAVE") ; �����ۑ�(Model.dwg)

        (setq #MODEL      (strcat CG_KENMEI_PATH "MODEL.DWG"))
        (setq #MODEL_BACK (strcat CG_KENMEI_PATH "MODEL_BACK.DWG"))

        (if (findfile #MODEL_BACK)(vl-file-delete #MODEL_BACK)) ; "Model_BACK.dwg"������Ώ���
        (command "_.SAVEAS" "2000" #MODEL_BACK) ; ���ݐ}�ʂ�"Model_BACK.dwg"�ɂȂ�
;;;       (setq #tEndFlg (vl-file-copy #MODEL #MODEL_BACK nil))   ; ��߰���쐬

        ; ��̈ȊO��S�č폜���Ă���ۑ�����
        (setq #ss (ssget "X" '((-3 ("G_KUTAI")))))
        (if (and #ss (> (sslength #ss) 0))
          (progn ; �}�ʏ�ɋ�̂�����Ƃ�
            (DelwithoutKUTAI) ; ��̈ȊO�͑S�č폜����

            ; ̧�َw��
            (setq #sFname (getfiled "���O��t���ĕۑ�" (strcat CG_SYSPATH "PLAN\\" "KUTAI" "\\") "dwg" 1))
            (if #sFname
              (progn
                ; 03/07/09 YM ADD �s�v�ȸ�ٰ�ߒ�`���폜����
                (KP_DelUnusedGroup)

                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")

                (command "_.QSAVE")
                (setq #tEndFlg (vl-file-copy #MODEL_BACK #sFname nil))
                (if (= nil #tEndFlg)
                  (progn ; ����̧�ق����߰�s�̏ꍇ
                    (vl-file-delete #sFname)
                    (vl-file-copy #MODEL_BACK #sFname nil)
                  )
                );_if

                ; �ۑ������̂��ޯ����߂��Ă������}��  #MODEL_BACK�@���J��
;;;               (CfDwgOpenByScript #MODEL)
                (SCFCmnFileOpen #MODEL 1)

              )
              (progn
                (CFAlertMsg "\n�ۑ����܂���ł����B")
                (*error*)
              )
            );_if

          )
          (progn
            (CFAlertMsg "\n�}�ʏ�ɋ�̂�����܂���B")
            (*error*)
          )
        );_if

      ) ; ��̂̂ݕۑ����� ---------------------------------------------------------------------------------------
    )
  );_if

  (setvar "FILEDIA" #iFILEDIA)
  (setq *error* nil)
  (princ "\n�u���b�N��ۑ����܂����B")
  (princ)
);C:KP_WrBlock

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_WrBlock
;;; <�����T�v>  : ���ݕۑ�(�֐�CALL�p)
;;; <����>      : �ۑ��t�@�C����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/04/25 YM
;;; <���l>      : �}�ʏ�ɃA�C�e�����Ȃ��ƃ_��,��A�C�e���̐F��"BYLAYER"�ŕۑ�����
;;;*************************************************************************>MOH<
(defun sub_WrBlock (
  &sFname ; �ۑ��t�@�C����
  /
  )

  ; 03/05/07 YM ADD �s�v�ȸ�ٰ�ߒ�`���폜����
  (KP_DelUnusedGroup)
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

  ; ̧�َw��
  (command "_.saveas" "2000" &sFname)
  (princ "\n�u���b�N��ۑ����܂����B")
  (princ)
);sub_WrBlock

;;;<HOM>*************************************************************************
;;; <�֐���>    : DelwithoutKUTAI
;;; <�����T�v>  : ��̈ȊO(����,WRKT,FILR,�}�ʘg,�V��̓_,����ޖ��,�)���폜����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/01/24 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun DelwithoutKUTAI (
  /
  #I #II #SSDEL #SSFILR #SSGRP #SSLSYM #SSWRKT #SYM #XD$ #EN #SSARW #SSHOLE #SSROOM #SSYASI
  )
  (setq #ssDEL (ssadd)) ; �폜�ΏۑI���
  (setq #ssWRKT (ssget "X" '((-3 ("G_WRKT")))))
  (setq #ssLSYM (ssget "X" '((-3 ("G_LSYM")))))
  (setq #ssFILR (ssget "X" '((-3 ("G_FILR")))))
  (setq #ssHOLE (ssget "X" '((-3 ("G_HOLE")))))

  ; WRKT
  (if (and #ssWRKT (< 0 (sslength #ssWRKT)))
    (progn
      (setq #i 0)
      (repeat (sslength #ssWRKT)
        (setq #sym (ssname #ssWRKT #i)) ; WT�{��
        (setq #ssGrp (PCW_ChColWTItemSSret #sym "BYLAYER")) ;ܰ�į�ߊ֘A�������I��
        ; �폜�ΏۑI��Ăɉ��Z
        (if (and #ssGrp (< 0 (sslength #ssGrp)))
          (progn
            (setq #ii 0)
            (repeat (sslength #ssGrp)
              (ssadd (ssname #ssGrp #ii) #ssDEL)
              (setq #ii (1+ #ii))
            )
          )
        );_if
        (setq #ssGrp nil)
        (setq #i (1+ #i))
      )
    )
  );_if

  ; G_LSYM
  (if (and #ssLSYM (< 0 (sslength #ssLSYM)))
    (progn
      (setq #i 0)
      (repeat (sslength #ssLSYM)
        (setq #sym (ssname #ssLSYM #i)) ; �����
        (if (= nil (CFGetXData #sym "G_KUTAI"))
          (setq #ssGrp (CFGetSameGroupSS #sym)) ; ��ٰ�ߐ}�`
          (setq #ssGrp nil)
        );_if

        ; �폜�ΏۑI��Ăɉ��Z
        (if (and #ssGrp (< 0 (sslength #ssGrp)))
          (progn
            (setq #ii 0)
            (repeat (sslength #ssGrp)
              (ssadd (ssname #ssGrp #ii) #ssDEL)
              (setq #ii (1+ #ii))
            )
          )
        );_if
        (setq #ssGrp nil)
        (setq #i (1+ #i))
      )
    )
  );_if

  ; �V��̨װ
  (if (and #ssFILR (< 0 (sslength #ssFILR)))
    (progn
      (setq #i 0)
      (repeat (sslength #ssFILR)
        (setq #sym (ssname #ssFILR #i)) ; �{��
        (setq #xd$ (CFGetXData #sym "G_FILR"))
        ; �폜�ΏۑI��Ăɉ��Z
        (ssadd #sym #ssDEL)         ;�V��̨װ�{�̂��폜�ΏۑI��Ăɉ��Z
        (ssadd (nth 2 #xd$) #ssDEL) ;��ʂ��폜�ΏۑI��Ăɉ��Z
        (setq #i (1+ #i))
      )
    )
  );_if

  ; G_HOLE
  (if (and #ssHOLE (< 0 (sslength #ssHOLE)))
    (command "_.erase" #ssHOLE "")
  );_if

  ; �S�č폜
  (if (and #ssDEL (< 0 (sslength #ssDEL)))
    (command "_.erase" #ssDEL "")
  );_if

  ; ���,�}�ʘg,�V��̓_�폜
  (setq #ssARW  (ssget "X" '((-3 ("G_ARW")))))
  (setq #ssROOM (ssget "X" '((-3 ("G_ROOM")))))

  (if (and #ssARW (< 0 (sslength #ssARW)))
    (command "_.erase" #ssARW "")
  );_if

  (if (and #ssROOM (< 0 (sslength #ssROOM)))
    (command "_.erase" #ssROOM "")
  );_if

  ; ��폜
  ;���ݑ��݂����}�̈�ԍ����l��
  (setq #ssYASI (ssget "X" (list (list -3 (list "RECT")))))
  ; �������΍폜����
  (if (and #ssYASI (> (sslength #ssYASI) 0)) ; �
    (progn
      ; ��폜
      (setq #i 0)
      (repeat (sslength #ssYASI) ; ���������
        (setq #en (ssname #ssYASI #i))
        (KCFDeleteYashi #en)
        (setq #i (1+ #i))
      )
    )
  );_if
  (princ)
);DelwithoutKUTAI

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KP_InBlock
;;; <�����T�v>  : �����̃v������}�����čė��p����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : C:PC_InsertPlan �����ɍ쐬 01/04/25 YM
;;; <���l>      : �}�����G_ARW , G_ROOM���폜
;;;*************************************************************************>MOH<
(defun C:KP_InBlock (
  /
  #ANG #EN #EN$ #FLG #I #INSPT #N #PURGE #SERI$ #SERIES #SETANG #SETPT #SFNAME
  #STR #SYMNORMAL$ #SYMTOKU$ #TOKU #TOKU$ #WTBASE #XD$ #PATH #RET #SKK
#PATH0 ; 03/07/04 YM
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KP_InBlock ////")
  (CFOutStateLog 1 1 " ")
  (StartUndoErr);// �R�}���h�̏�����
  (CFCmdDefBegin 7);00/09/13 SN ADD

  ; 02/11/11 YM ADD ��̂̂ݏ����o�����[�h��I���\
  (setq #ret (KPGetBlockWrInsModeDlg))
  (if (= #ret nil)
    (*error*)
  ; else
    (progn

      ;// ���݂̏��i�����擾����
      (if (setq #seri$ (CFGetXRecord "SERI"))
        (progn
          (setq CG_SeriesCode  (nth 1 #seri$))  ;SERIES�L��
          (setq CG_DRSeriCode  (nth 3 #seri$))  ;��SERIES�L��
          (setq CG_DRColCode   (nth 4 #seri$))  ;��COLOR�L��
        )
      );_if

      (if (or (= nil CG_SeriesCode)(= nil CG_DRSeriCode)(= nil CG_DRColCode))
        (progn
          (CFAlertMsg "���i��񂪎擾�ł��܂���ł����B\n�}�ʂ��ăI�[�v�����Ă��������B")
          (*error*)
        )
      );_if

      ;// ���݂̃V���{���}�`�����߂�
      (setq CG_PREV_SYMSS (ssget "X" '((-3 ("G_LSYM")))))
      (setq CG_PREV_WTSS  (ssget "X" '((-3 ("G_WRKT")))))
      (setq CG_PREV_ARW   (ssget "X" '((-3 ("G_ARW" )))))
      (setq CG_PREV_ROOM  (ssget "X" '((-3 ("G_ROOM")))))

      (if (= nil CG_PREV_SYMSS) (setq CG_PREV_SYMSS (ssadd)))
      (if (= nil CG_PREV_WTSS)  (setq CG_PREV_WTSS  (ssadd)))
      (if (= nil CG_PREV_ARW )  (setq CG_PREV_ARW   (ssadd)))
      (if (= nil CG_PREV_ROOM)  (setq CG_PREV_ROOM  (ssadd)))

      (if (= "1" #ret)
        (progn
          ; CG_DBNAME DB�� 03/07/04 YM MOD-S
          (setq #path0 (strcat CG_SYSPATH "PLAN\\" CG_DBNAME))
          (if (findfile #path0)
            ;�V�ذ�� NK_KSA,NK_KGA �Ȃ�
            (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\"))
            ;else   �]���ذ��(NK_CKC,NK_CKN �Ȃ�)
            (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
          );_if
;;;         (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\")) ; 03/07/04 YM MOD
          ; CG_DBNAME DB�� 03/07/04 YM MOD-E
        )
      ; else
        (setq #path (strcat CG_SYSPATH "PLAN\\" "KUTAI" "\\"))
      );_if

        ; ����dwg�̌���
        (if (vl-directory-files #path "*.dwg")
          (progn
            ; ̧�َw��
            (setq #sFname (getfiled "�u���b�N�}��" #path "dwg" 8))
            (if #sFname
              (progn
                (command "vpoint" "0,0,1"); ���_��^�ォ��
                (princ "\n�z�u�_: ")
                (command "_Insert" #sFname pause "" "")
                (princ "\n�p�x: ")
                (command pause)

                (setq #insPt (getvar "LASTPOINT"))
                (setq #ang (cdr (assoc 50 (entget (entlast)))))

                (command "_explode" (entlast))

  ; ��ٰ�ߕ��� 03/07/09 YM ADD
  (KP_DelUnusedGroup)

                ;// �z�u������V���{��G_LSYM �̔z�u�_�A�z�u�p�x��u��������
                ;// ���݂̃V���{���}�`�����߂�
                (setq CG_AFTER_SYMSS (ssget "X" '((-3 ("G_LSYM")))))

                ;// �V���ɒǉ����ꂽ�V���{���}�`�����߂�
                (setq #i 0 #en$ nil)
                (repeat (sslength CG_AFTER_SYMSS)
                  (setq #en (ssname CG_AFTER_SYMSS #i))
                  (if (= nil (ssmemb #en CG_PREV_SYMSS))
                    (progn
                      (setq #setpt (cdr (assoc 10 (entget #en))))

                      (setq #xd$ (CFGetXData #en "G_LSYM"))
                      (setq #series (nth 4 #xd$)) ; �}�����݂̼ذ��
                      (setq #skk    (nth 9 #xd$)) ; ���i���� ; 03/03/29 YM ADD

(setq CG_SKK_ONE_KUT 9);���
(setq CG_SKK_TWO_KUT 9);���
(setq CG_SKK_THR_KUT 9);���

                      (if (and (= #ret "1")(/= CG_SeriesCode #series) ; 02/11/11 YM MOD
                               (/= #skk CG_SKK_INT_KUT)) ; 03/03/29 YM ADD ��̂͏���
;;;                     (if (/= CG_SeriesCode #series) ; 02/11/11 YM MOD
                        (progn
                          (CFAlertMsg (strcat "SERIES���قȂ邽�߁A�u���b�N��}���ł��܂���B"
                            "\n���݂̐}�ʂ�SERIES�F   " CG_SeriesCode
                            "\n�}���u���b�N��SERIES �F"#series)
                          )
                          (*error*)
                        )
                      );_if
                      (setq #setang (+ #ang (nth 2 #xd$)))

                      ;// �g���f�[�^�̍X�V
                      (CFSetXData #en "G_LSYM"
                        (list
                          (nth  0 #xd$)  ;1 :�{�̐}�`ID      :
                          #setpt         ;2 :�}���_          :  �X�V
                          #setang        ;3 :��]�p�x        :  �X�V
                          (nth  3 #xd$)  ;4 :�H��L��        :
                          (nth  4 #xd$)  ;5 :SERIES�L��    :
                          (nth  5 #xd$)  ;6 :�i�Ԗ���        :
                          (nth  6 #xd$)  ;7 :L/R�敪         :
                          (nth  7 #xd$)  ;8 :���}�`ID        :
                          (nth  8 #xd$)  ;9 :���J���}�`ID    :
                          (nth  9 #xd$)  ;10:���iCODE      :
                          (nth 10 #xd$)  ;11:�����t���O      :
                          (nth 11 #xd$)  ;12:�z�u���ԍ�      :
                          (nth 12 #xd$)  ;13:�p�r�ԍ�        :
                          (nth 13 #xd$)  ;14:���@�g          :
                          (nth 14 #xd$)  ;15.�f�ʎw���̗L��  :
                          (nth 15 #xd$)  ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
                        )
                      )
                      (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
                        (setq #en$ (cons #en #en$)) ; ���\�蒼���Ώ۷���
                      );_if

                    )
                  )
                  (setq #i (1+ #i))
                )
                (command "zoom" "p") ; ���_��߂�

                ; �}�ʂ̔��L��,�װ�ɒ��肩���� ----------------------------------------START

                ; �������ނƈ�ʷ��ނ𕪂���
                (setq #symTOKU$ nil #symNORMAL$ nil #TOKU nil)
                (foreach en #en$
                  (if (and (setq #TOKU$ (CFGetXData en "G_TOKU"))
                           (= (nth 3 #TOKU$) 1))
                    (progn
                      (setq #TOKU T) ; �������ނ�������
                      (setq #symTOKU$ (append #symTOKU$ (list en))) ; �������޺���ނ��g�p
                    )
                    (setq #symNORMAL$ (append #symNORMAL$ (list en)))
                  );_if
                )
                (if #TOKU
                  (CFAlertErr "�����L���r�l�b�g�͔��ʂ̕ύX���s���܂���B")
                );_if

                ;// ���ʂ̓\��t��(�����ȊO�̏ꍇ)
                (if #symNORMAL$
                  ;�v�����}�����ɕ��ނ������邱�Ƃ����邽�ߔ��폜���Ȃ� MICADO�łɓ���
                  (PCD_MakeViewAlignDoor #symNORMAL$ 3 nil);03/12/05 YM MOD
;;;                 (PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
                );_if

                ; �}�ʂ̔��L��,�װ�ɒ��肩���� ----------------------------------------END

                ;// �ŐV�̃��[�N�g�b�v���擾����
                ;// �z�u������V���{��G_LSYM �̔z�u�_�A�z�u�p�x��u��������
                ;// ���݂̃V���{���}�`�����߂�
                (setq CG_AFTER_WTSS (ssget "X" '((-3 ("G_WRKT")))))
                (setq CG_AFTER_ARW  (ssget "X" '((-3 ("G_ARW")))))
                (setq CG_AFTER_ROOM (ssget "X" '((-3 ("G_ROOM")))))

                (if (/= CG_AFTER_WTSS nil)
                  (progn
                    ;// �V���ɒǉ����ꂽWT�����߂�
                    (setq #i 0)
                    (repeat (sslength CG_AFTER_WTSS)
                      (setq #en (ssname CG_AFTER_WTSS #i))
                      (if (= nil (ssmemb #en CG_PREV_WTSS))
                        (progn
                          (setq #xd$ (CFGetXData #en "G_WRKT"))
                          (setq #WTbase (PKGetWTLeftUpPT #insPt #ang (nth 32 #xd$))) ; 09/11 YM
                          ;// �g���f�[�^�̍X�V
                          (CFSetXData #en "G_WRKT"
                            (CFModList #xd$
                              (list (list 32 #WTbase))
                            )
                          )
                        )
                      );_if
                      (setq #i (1+ #i))
                    )
                  )
                );_if

                (if (/= CG_AFTER_ARW nil) ; ��A�C�e���̖��
                  (progn
                    ;// �V���ɒǉ����ꂽ��A�C�e���̖����폜����
                    (setq #i 0)
                    (repeat (sslength CG_AFTER_ARW)
                      (setq #en (ssname CG_AFTER_ARW #i))
                      (if (= nil (ssmemb #en CG_PREV_ARW))
                        (entdel #en)
                      );_if
                      (setq #i (1+ #i))
                    )
                  )
                );_if

                (if (/= CG_AFTER_ROOM nil) ; �}�ʘg�ƓV��̓_
                  (progn
                    ;// �V���ɒǉ����ꂽ�}�ʘg�ƓV��̓_���폜����
                    (setq #i 0)
                    (repeat (sslength CG_AFTER_ROOM)
                      (setq #en (ssname CG_AFTER_ROOM #i))
                      (if (= nil (ssmemb #en CG_PREV_ROOM))
                        (entdel #en)
                      );_if
                      (setq #i (1+ #i))
                    )
                  )
                );_if

                ; dwg�p�X���̕����񂩂���ۯ������擾
                (setq #n 0)
                (setq #purge "" #flg nil)
                (repeat (1- (strlen #sFname))
                  (setq #str (substr #sFname (- (strlen #sFname) #n) 1)) ; ��������

                  (if (= #str "\\")(setq #flg nil))
                  (if #flg (setq #purge (strcat #str #purge)))
                  (if (= #str ".")(setq #flg T))
                  (setq #n (1+ #n))
                )

                ;// �C���T�[�g�����u���b�N��`���p�[�W����
                (command "_purge" "BL" #purge "N")

                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")

      ;;;01/05/14YM@          (command "_purge" "A" "*" "N") ; �S�Ă��߰�ނ��� 01/05/14 YM ADD
                (princ "\n�u���b�N��}�����܂����B")
              )
            );_if
          )
          (progn
            (CFAlertMsg (strcat "�}������v�������o�^����Ă��܂���B" )) ; 02/11/11 YM MOD
;;;           (CFAlertMsg (strcat "�}������v�������o�^����Ă��܂���B\nSERIES�L��:" CG_SeriesCode)) ; 02/11/11 YM MOD
            (quit)
          )
        );_if

    )
  );_if

  ;04/05/26 YM ADD
  (command "_REGEN")

  (CFCmdDefFinish)
  (setq *error* nil)
  (princ)
);C:KP_InBlock

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_KP_InBlock
;;; <�����T�v>  : �����̃v������}������(�֐�CALL�p)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/12/06 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun sub_KP_InBlock (
  &path ;�}��dwg�ٖ�
  /
  #ANG #EN #EN$ #FLG #I #INSPT #N #PURGE #SERI$ #SERIES #SETANG #SETPT #SFNAME 
  #SKK #STR #WTBASE #XD$
  )
  (CFCmdDefBegin 7)
  ;// ���݂̏��i�����擾����
  (if (setq #seri$ (CFGetXRecord "SERI"))
    (progn
      (setq CG_SeriesCode  (nth 1 #seri$))  ;SERIES�L��
      (setq CG_DRSeriCode  (nth 3 #seri$))  ;��SERIES�L��
      (setq CG_DRColCode   (nth 4 #seri$))  ;��COLOR�L��
    )
  );_if

  (if (or (= nil CG_SeriesCode)(= nil CG_DRSeriCode)(= nil CG_DRColCode))
    (progn
      (CFAlertMsg "���i��񂪎擾�ł��܂���ł����B\n�}�ʂ��ăI�[�v�����Ă��������B")
      (*error*)
    )
  );_if

  ;// ���݂̃V���{���}�`�����߂�
  (setq CG_PREV_SYMSS (ssget "X" '((-3 ("G_LSYM")))))
  (setq CG_PREV_WTSS  (ssget "X" '((-3 ("G_WRKT")))))
  (setq CG_PREV_ARW   (ssget "X" '((-3 ("G_ARW" )))))
  (setq CG_PREV_ROOM  (ssget "X" '((-3 ("G_ROOM")))))

  (if (= nil CG_PREV_SYMSS) (setq CG_PREV_SYMSS (ssadd)))
  (if (= nil CG_PREV_WTSS)  (setq CG_PREV_WTSS  (ssadd)))
  (if (= nil CG_PREV_ARW )  (setq CG_PREV_ARW   (ssadd)))
  (if (= nil CG_PREV_ROOM)  (setq CG_PREV_ROOM  (ssadd)))

  (command "vpoint" "0,0,1"); ���_��^�ォ��
  (command "_.INSERT" &path "0,0,0" 1 1 "0")
  (setq #insPt '(0 0 0))
  (setq #ang 0.0)
  (command "_explode" (entlast))

  ; ��ٰ�ߕ��� 03/07/09 YM ADD
  (KP_DelUnusedGroup)

  ;// �z�u������V���{��G_LSYM �̔z�u�_�A�z�u�p�x��u��������
  ;// ���݂̃V���{���}�`�����߂�
  (setq CG_AFTER_SYMSS (ssget "X" '((-3 ("G_LSYM")))))

  ;// �V���ɒǉ����ꂽ�V���{���}�`�����߂�
  (setq #i 0 #en$ nil)
  (repeat (sslength CG_AFTER_SYMSS)
    (setq #en (ssname CG_AFTER_SYMSS #i))
    (if (= nil (ssmemb #en CG_PREV_SYMSS))
      (progn
        (setq #setpt (cdr (assoc 10 (entget #en))))

        (setq #xd$ (CFGetXData #en "G_LSYM"))
        (setq #series (nth 4 #xd$)) ; �}�����݂̼ذ��
        (setq #skk    (nth 9 #xd$)) ; ���i���� ; 03/03/29 YM ADD

        (setq #setang (+ #ang (nth 2 #xd$)))

        ;// �g���f�[�^�̍X�V
        (CFSetXData #en "G_LSYM"
          (list
            (nth  0 #xd$)  ;1 :�{�̐}�`ID      :
            #setpt         ;2 :�}���_          :  �X�V
            #setang        ;3 :��]�p�x        :  �X�V
            (nth  3 #xd$)  ;4 :�H��L��        :
            (nth  4 #xd$)  ;5 :SERIES�L��    :
            (nth  5 #xd$)  ;6 :�i�Ԗ���        :
            (nth  6 #xd$)  ;7 :L/R�敪         :
            (nth  7 #xd$)  ;8 :���}�`ID        :
            (nth  8 #xd$)  ;9 :���J���}�`ID    :
            (nth  9 #xd$)  ;10:���iCODE      :
            (nth 10 #xd$)  ;11:�����t���O      :
            (nth 11 #xd$)  ;12:�z�u���ԍ�      :
            (nth 12 #xd$)  ;13:�p�r�ԍ�        :
            (nth 13 #xd$)  ;14:���@�g          :
            (nth 14 #xd$)  ;15.�f�ʎw���̗L��  :
            (nth 15 #xd$)  ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
          )
        )
        (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
          (setq #en$ (cons #en #en$)) ; ���\�蒼���Ώ۷���
        );_if

      )
    )
    (setq #i (1+ #i))
  );repeat
;;;               (command "zoom" "p") ; ���_��߂�

  ;// �ŐV�̃��[�N�g�b�v���擾����
  ;// �z�u������V���{��G_LSYM �̔z�u�_�A�z�u�p�x��u��������
  ;// ���݂̃V���{���}�`�����߂�
  (setq CG_AFTER_WTSS (ssget "X" '((-3 ("G_WRKT")))))
  (setq CG_AFTER_ARW  (ssget "X" '((-3 ("G_ARW")))))
  (setq CG_AFTER_ROOM (ssget "X" '((-3 ("G_ROOM")))))

  (if (/= CG_AFTER_WTSS nil)
    (progn
      ;// �V���ɒǉ����ꂽWT�����߂�
      (setq #i 0)
      (repeat (sslength CG_AFTER_WTSS)
        (setq #en (ssname CG_AFTER_WTSS #i))
        (if (= nil (ssmemb #en CG_PREV_WTSS))
          (progn
            (setq #xd$ (CFGetXData #en "G_WRKT"))
            (setq #WTbase (PKGetWTLeftUpPT #insPt #ang (nth 32 #xd$))) ; 09/11 YM
            ;// �g���f�[�^�̍X�V
            (CFSetXData #en "G_WRKT"
              (CFModList #xd$
                (list (list 32 #WTbase))
              )
            )
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (if (/= CG_AFTER_ARW nil) ; ��A�C�e���̖��
    (progn
      ;// �V���ɒǉ����ꂽ��A�C�e���̖����폜����
      (setq #i 0)
      (repeat (sslength CG_AFTER_ARW)
        (setq #en (ssname CG_AFTER_ARW #i))
        (if (= nil (ssmemb #en CG_PREV_ARW))
          (entdel #en)
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (if (/= CG_AFTER_ROOM nil) ; �}�ʘg�ƓV��̓_
    (progn
      ;// �V���ɒǉ����ꂽ�}�ʘg�ƓV��̓_���폜����
      (setq #i 0)
      (repeat (sslength CG_AFTER_ROOM)
        (setq #en (ssname CG_AFTER_ROOM #i))
        (if (= nil (ssmemb #en CG_PREV_ROOM))
          (entdel #en)
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  ;// �C���T�[�g�����u���b�N��`���p�[�W����
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (princ "\n�u���b�N��}�����܂����B")

  (CFCmdDefFinish)
  (princ)
);sub_KP_InBlock

;;;<HOM>*************************************************************************
;;; <�֐���>    : sub_KP_WrBlock
;;; <�����T�v>  : �������݂𖼑O��t���ĕۑ�����
;;; <����>      : �Ȃ�(̧�ق̂͸�۰��ٕϐ� CG_SAVE-DWG)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/12/06 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun sub_KP_WrBlock (
  /
  #EN #HAND #HNDB #I #IFILEDIA #N #PICKSTYLE #SS #SSARW #SSDOOR #SSROOM 
  #SSYASI #TENDFLG #XDYASI$
  )
    ;//////////////////////////////////////////////////////////////////////
    ;���ٰ�݉� 03/05/13 YM
    ;//////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL_SUB ( &ss / #i )
      (if (and &ss (> (sslength &ss) 0)) ; ��A�C�e���̖��
        (progn
          ;// �V���ɒǉ����ꂽ��A�C�e���̖����폜����
          (setq #i 0)
          (repeat (sslength &ss)
            (entdel (ssname &ss #i))
            (setq #i (1+ #i))
          )
        )
      );_if
      (princ)
    );##ENTDEL_SUB
    ;//////////////////////////////////////////////////////////////////////
    ;���ٰ�݉�&���̈ꎞ�폜�ǉ� 03/05/13 YM
    ;//////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL ( / )
      ;��A�C�e���̖����ꎞ�폜����
      (##ENTDEL_SUB #ssARW)
      ;�}�ʘg�ƓV��̓_���ꎞ�폜����
      (##ENTDEL_SUB #ssROOM)
      ;�}�ʏ�̔����ꎞ�폜����
      (##ENTDEL_SUB #ssDOOR)
      (princ)
    );##ENTDEL
    ;//////////////////////////////////////////////////////////////////////


  (setq #iFILEDIA (getvar "FILEDIA"))
  (setvar "FILEDIA" 1)


  (setq #ssARW  (ssget "X" '((-3 ("G_ARW")))))
  (setq #ssROOM (ssget "X" '((-3 ("G_ROOM")))))
  ; 03/05/13 YM ADD-S �}�ʏ�̑S���}�`
  (setq #ssDOOR (KP_GetAllDoor))
  ; 03/05/13 YM ADD-S
  (setq #PICKSTYLE (getvar "PICKSTYLE"))
  (setvar "PICKSTYLE" 3)

  ;���ݑ��݂����}�̈�ԍ����l��
  (setq #ssYASI (ssget "X" (list (list -3 (list "RECT")))))
  ; �������΍폜����
  (if (and #ssYASI (> (sslength #ssYASI) 0)) ; �
    (if (CFYesNoDialog "�ۑ��O�ɖ���폜����K�v������܂��B\n����폜���܂����H")
      (progn
        ; ��폜
        (setq #i 0)
        (repeat (sslength #ssYASI) ; ���������
          (setq #en (ssname #ssYASI #i))
          (setq #xdYASI$ (CFGetXData #en "RECT")) ; �g���ް�
          (setq #n 3 #hand (nth #n #xdYASI$))
          (while #hand
            (command "_erase" (handent #hand) "")
            (setq #n (1+ #n))
            (setq #hand (nth #n #xdYASI$))
          )
          (command "_erase" #en "")
          (setq #i (1+ #i))
        )
      )
      (*error*)
    );_if
  );_if

  ; �g�A�V��̓_�A�����ꎞ�I�ɍ폜���� 01/05/10 YM ADD
  (##ENTDEL) ; 03/05/13 YM �����ꎞ�폜

  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss (> (sslength #ss) 0))
    (progn ; �}�ʏ�ɉ������ނ�����Ƃ�
      ; ��A�C�e���̐F���ꎞ�I�Ɍ��ɖ߂�
      (setq #hndB (car (CFGetXRecord "BASESYM"))) ; �����
      (if (and #hndB (/= #hndB ""))
        (GroupInSolidChgCol2 (handent #hndB) "BYLAYER")  ;BYLAYER�F�ɕύX
      )

      ; ̧�ٺ�߰

      ; 03/07/09 YM ADD �s�v�ȸ�ٰ�ߒ�`���폜����
      (KP_DelUnusedGroup)
      (command "_purge" "BL" "*" "N")
      (command "_purge" "BL" "*" "N")
      (command "_.QSAVE")
      ; 01/10/24 YM ADD-S ��߰��,��߰�� -->̧�ي����Ȃ��߰�Ɏ��s
      (setq #tEndFlg (vl-file-copy  (strcat CG_KENMEI_PATH "MODEL.DWG") CG_SAVE-DWG nil))
      (if (= nil #tEndFlg)
        (progn ; ����̧�ق����߰�s�̏ꍇ
          (vl-file-delete CG_SAVE-DWG)
          (vl-file-copy  (strcat CG_KENMEI_PATH "MODEL.DWG") CG_SAVE-DWG nil)
        )
      );_if
      ; 01/10/24 YM ADD-E

      ; ��A�C�e���̐F�����̗΂ɖ߂�
      (if (and #hndB (/= #hndB ""))
        (GroupInSolidChgCol2 (handent #hndB) CG_BaseSymCol) ;�ΐF�ɕύX
      )
    )
    (progn
      (CFAlertMsg "\n�}�ʏ�ɕ��ނ�����܂���B")
      (*error*)
    )
  );_if

  ; �g�A�V��̓_�A���𕜊������� 01/05/10 YM ADD
  (##ENTDEL)

  (setvar "FILEDIA" #iFILEDIA)
  (princ "\n�u���b�N��ۑ����܂����B")
  (princ)
);sub_KP_WrBlock

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_InBlock_sub
;;; <�����T�v>  : �v�����}���֐��Ăяo���p(�}���ʒu,�p�x�Œ�)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 03/05/09 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_InBlock_sub (
  &sFname ; DWG��
  /
  #ANG #EN #EN$ #FLG #I #INSPT #N #PATH #PURGE #RET #SERI$ #SERIES #SETANG #SETPT
  #SKK #STR #SYMNORMAL$ #SYMTOKU$ #TOKU #TOKU$ #WTBASE #XD$
  )
  ;// ���݂̏��i�����擾����
  (if (setq #seri$ (CFGetXRecord "SERI"))
    (progn
      (setq CG_SeriesCode  (nth 1 #seri$))  ;SERIES�L��
      (setq CG_DRSeriCode  (nth 3 #seri$))  ;��SERIES�L��
      (setq CG_DRColCode   (nth 4 #seri$))  ;��COLOR�L��
    )
  );_if

  (if (or (= nil CG_SeriesCode)(= nil CG_DRSeriCode)(= nil CG_DRColCode))
    (progn
      (CFAlertMsg "���i��񂪎擾�ł��܂���ł����B\n�}�ʂ��ăI�[�v�����Ă��������B")
      (*error*)
    )
  );_if

  ;// ���݂̃V���{���}�`�����߂�
  (setq CG_PREV_SYMSS (ssget "X" '((-3 ("G_LSYM")))))
  (setq CG_PREV_WTSS  (ssget "X" '((-3 ("G_WRKT")))))
  (setq CG_PREV_ARW   (ssget "X" '((-3 ("G_ARW" )))))
  (setq CG_PREV_ROOM  (ssget "X" '((-3 ("G_ROOM")))))

  (if (= nil CG_PREV_SYMSS) (setq CG_PREV_SYMSS (ssadd)))
  (if (= nil CG_PREV_WTSS)  (setq CG_PREV_WTSS  (ssadd)))
  (if (= nil CG_PREV_ARW )  (setq CG_PREV_ARW   (ssadd)))
  (if (= nil CG_PREV_ROOM)  (setq CG_PREV_ROOM  (ssadd)))

  (command "_insert" &sFname "0,0,0" 1 1 "0")
  (setq #insPt '(0 0 0))
  (setq #ang 0)
  (command "_explode" (entlast))

  ;// �z�u������V���{��G_LSYM �̔z�u�_�A�z�u�p�x��u��������
  ;// ���݂̃V���{���}�`�����߂�
  (setq CG_AFTER_SYMSS (ssget "X" '((-3 ("G_LSYM")))))

  ;// �V���ɒǉ����ꂽ�V���{���}�`�����߂�
  (setq #i 0 #en$ nil)
  (repeat (sslength CG_AFTER_SYMSS)
    (setq #en (ssname CG_AFTER_SYMSS #i))
    (if (= nil (ssmemb #en CG_PREV_SYMSS))
      (progn
        (setq #setpt (cdr (assoc 10 (entget #en))))

        (setq #xd$ (CFGetXData #en "G_LSYM"))
        (setq #series (nth 4 #xd$)) ; �}�����݂̼ذ��
        (setq #skk    (nth 9 #xd$)) ; ���i���� ; 03/03/29 YM ADD

        (if (and (= #ret "1")(/= CG_SeriesCode #series) ; 02/11/11 YM MOD
                 (/= #skk CG_SKK_INT_KUT)) ; 03/03/29 YM ADD ��̂͏���
          (progn
            (CFAlertMsg (strcat "SERIES���قȂ邽�߁A�u���b�N��}���ł��܂���B"
              "\n���݂̐}�ʂ�SERIES�F   " CG_SeriesCode
              "\n�}���u���b�N��SERIES �F"#series)
            )
            (*error*)
          )
        );_if
        (setq #setang (+ #ang (nth 2 #xd$)))

        ;// �g���f�[�^�̍X�V
        (CFSetXData #en "G_LSYM"
          (list
            (nth  0 #xd$)  ;1 :�{�̐}�`ID      :
            #setpt         ;2 :�}���_          :  �X�V
            #setang        ;3 :��]�p�x        :  �X�V
            (nth  3 #xd$)  ;4 :�H��L��        :
            (nth  4 #xd$)  ;5 :SERIES�L��    :
            (nth  5 #xd$)  ;6 :�i�Ԗ���        :
            (nth  6 #xd$)  ;7 :L/R�敪         :
            (nth  7 #xd$)  ;8 :���}�`ID        :
            (nth  8 #xd$)  ;9 :���J���}�`ID    :
            (nth  9 #xd$)  ;10:���iCODE      :
            (nth 10 #xd$)  ;11:�����t���O      :
            (nth 11 #xd$)  ;12:�z�u���ԍ�      :
            (nth 12 #xd$)  ;13:�p�r�ԍ�        :
            (nth 13 #xd$)  ;14:���@�g          :
            (nth 14 #xd$)  ;15.�f�ʎw���̗L��  :
            (nth 15 #xd$)  ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
          )
        )
        (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
          (setq #en$ (cons #en #en$)) ; ���\�蒼���Ώ۷���
        );_if

      )
    );_if
    (setq #i (1+ #i))
  );repeat

  ; �}�ʂ̔��L��,�װ�ɒ��肩���� ----------------------------------------START

; 03/05/15 YM DEL ���͓\��Ȃ���PLAN.DWG���쐬��MODEL.DWG�ɑ}�����Ă������\��
;;;03/05/15YM@DEL ; �������ނƈ�ʷ��ނ𕪂���
;;;03/05/15YM@DEL (setq #symTOKU$ nil #symNORMAL$ nil #TOKU nil)
;;;03/05/15YM@DEL (foreach en #en$
;;;03/05/15YM@DEL   (if (and (setq #TOKU$ (CFGetXData en "G_TOKU"))
;;;03/05/15YM@DEL            (= (nth 3 #TOKU$) 1))
;;;03/05/15YM@DEL     (progn
;;;03/05/15YM@DEL       (setq #TOKU T) ; �������ނ�������
;;;03/05/15YM@DEL       (setq #symTOKU$ (append #symTOKU$ (list en))) ; �������޺���ނ��g�p
;;;03/05/15YM@DEL     )
;;;03/05/15YM@DEL     (setq #symNORMAL$ (append #symNORMAL$ (list en)))
;;;03/05/15YM@DEL   );_if
;;;03/05/15YM@DEL )
;;;03/05/15YM@DEL (if #TOKU
;;;03/05/15YM@DEL   (CFAlertErr "�����L���r�l�b�g�͔��ʂ̕ύX���s���܂���B")
;;;03/05/15YM@DEL );_if
;;;03/05/15YM@DEL
;;;03/05/15YM@DEL  ;// ���ʂ̓\��t��(�����ȊO�̏ꍇ)
;;;03/05/15YM@DEL (if #symNORMAL$
;;;03/05/15YM@DEL   (PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
;;;03/05/15YM@DEL );_if

  ; �}�ʂ̔��L��,�װ�ɒ��肩���� ----------------------------------------END

  ;// �ŐV�̃��[�N�g�b�v���擾����
  ;// �z�u������V���{��G_LSYM �̔z�u�_�A�z�u�p�x��u��������
  ;// ���݂̃V���{���}�`�����߂�
  (setq CG_AFTER_WTSS (ssget "X" '((-3 ("G_WRKT")))))
  (setq CG_AFTER_ARW  (ssget "X" '((-3 ("G_ARW")))))
  (setq CG_AFTER_ROOM (ssget "X" '((-3 ("G_ROOM")))))

  (if (/= CG_AFTER_WTSS nil)
    (progn
      ;// �V���ɒǉ����ꂽWT�����߂�
      (setq #i 0)
      (repeat (sslength CG_AFTER_WTSS)
        (setq #en (ssname CG_AFTER_WTSS #i))
        (if (= nil (ssmemb #en CG_PREV_WTSS))
          (progn
            (setq #xd$ (CFGetXData #en "G_WRKT"))
            (setq #WTbase (PKGetWTLeftUpPT #insPt #ang (nth 32 #xd$))) ; 09/11 YM
            ;// �g���f�[�^�̍X�V
            (CFSetXData #en "G_WRKT"
              (CFModList #xd$
                (list (list 32 #WTbase))
              )
            )
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (if (/= CG_AFTER_ARW nil) ; ��A�C�e���̖��
    (progn
      ;// �V���ɒǉ����ꂽ��A�C�e���̖����폜����
      (setq #i 0)
      (repeat (sslength CG_AFTER_ARW)
        (setq #en (ssname CG_AFTER_ARW #i))
        (if (= nil (ssmemb #en CG_PREV_ARW))
          (entdel #en)
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (if (/= CG_AFTER_ROOM nil) ; �}�ʘg�ƓV��̓_
    (progn
      ;// �V���ɒǉ����ꂽ�}�ʘg�ƓV��̓_���폜����
      (setq #i 0)
      (repeat (sslength CG_AFTER_ROOM)
        (setq #en (ssname CG_AFTER_ROOM #i))
        (if (= nil (ssmemb #en CG_PREV_ROOM))
          (entdel #en)
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  ; dwg�p�X���̕����񂩂���ۯ������擾
  (setq #n 0)
  (setq #purge "" #flg nil)
  (repeat (1- (strlen &sFname))
    (setq #str (substr &sFname (- (strlen &sFname) #n) 1)) ; ��������

    (if (= #str "\\")(setq #flg nil))
    (if #flg (setq #purge (strcat #str #purge)))
    (if (= #str ".")(setq #flg T))
    (setq #n (1+ #n))
  )

  ;// �C���T�[�g�����u���b�N��`���p�[�W����
  (command "_purge" "BL" #purge "N")

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
;;; (princ "\n�u���b�N��}�����܂����B")
  (princ)
);KP_InBlock_sub

;<HOM>*************************************************************************
; <�֐���>    : KPGetBlockWrInsModeDlg
; <�����T�v>  : �y���ݕۑ��z�y���ݑ}���z����Ӱ�ޑI���޲�۸�
; <�߂�l>    : 1:�}�ʑS��,0:��̂̂�
; <�쐬>      : 02/11/11 YM
;*************************************************************************>MOH<
(defun KPGetBlockWrInsModeDlg (
  /
  #DCL_ID #RET
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #ret
            )
            (setq #ret (get_tile "radioALL")) ; ̨װ��
            (done_dialog)     ; ���p����1�ȏゾ����
            #ret
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;; �_�C�A���O�̎��s��
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (= nil (new_dialog "SelBlockWrInsModeDlg" #dcl_id)) (exit))

; 02/11/28 YM ADD �������ɂ��g�p�֎~-->�g�p�\��03/01/24
;*************************************
;;;(mode_tile "radioKUTAI" 1) ; �g�p�s�\
;*************************************

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #ret (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; ���ʃ��X�g��Ԃ�
  #ret
); KPGetBlockWrInsModeDlg

;<HOM>*************************************************************************
; <�֐���>    : SKFGetCabiEntity
; <�����T�v>  : �L���r�l�b�g���Ƃ̎w���w�̐}�`�����X�g�ɂ܂Ƃ߂�
; <�߂�l>    : �}�`�����X�g
;               �i
;                 �i
;                     �f�ʎw��         0
;                     �V���{���}�`��   1
;                     ���f���t���O     2
;                     ���f���ԍ�       3
;                     ���ʃt���O       4
;                     ���ʕ����t���O   5
;                     �}�`�����X�g     6
;                 �j
;                 �c
;               �j
; <�쐬>      : 1998-07-15   ->   1999-06-21
; <���l>      : �R�[�i�[�L���r�l�b�g�̐��ʃt���O�͖�������ON�ɐݒ�
;*************************************************************************>MOH<

(defun SKFGetCabiEntity (
  &kind       ; �}�ʎ�ށi����:"P" �W�J�`:"A" �W�J�a:"B" �W�J�b:"C" �W�J�c:"D"�j �W�J�d:"E"�ǉ�
  &zcode$     ; �}�ʎ��
  &ss         ; �_�~�[�̈�I���G���e�B�e�B
  &ang        ; ��]�p�x
  /
  #iI #den #i #ed$ #ModelFlg #ModelNo #han #sym #code$ #eed$ #ano
  #vcode #fcode #ang #vcode$ #wd #zcode #layer #en$ #en #8 #layen$
  #dflg #ret$ #Ret$$ #ret_n$ #lst$ #ret_n$$
  ; 2000/07/06 HT YASHIAC  ��̈攻��ύX
  #next
  #pt0 #pt1 #pt2 #pt3   ; �l���̍��W  01/04/10 TM
  #pt$
  #xSp          ; ��}�`�I���Z�b�g
  #sPt          ; ��̊�_
  #eYas         ; ��}�`��
  #xYas$        ; ��̈�_��
  )

  ; 01/07/19 HN ADD �I�u�W�F�N�g�͈͂̃Y�[��������ǉ�
  (command "_.ZOOM" (getvar "EXTMIN") (getvar "EXTMAX"))

  ; ��擾
  (setq #xSp (ssget "X" '((-3 ("RECT")))))
  (if #xSp
    (progn
      (cond
        ((or (= &kind "E") (= &kind "F"))
          (setq #xSp (SCFIsYashiType #xSp (strcat "*" &kind "*")))
        )
        ((wcmatch &kind "*[ABCD]*")
          (setq #xSp (SCFIsYashiType #xSp "*[ABCD]*"))
        )
      )
      (setq #eYas (ssname #xSp 0))
      (if (not #eYas)
        (princ "\n����ُ�H")
      )
    )
  )

  ; �_�~�[�}�`�̈�I���Z�b�g���ƂɊg���f�[�^
  (setq #iI 0)
  (repeat (sslength &ss)
    (setq #den (ssname &ss #iI))
    (setq #ed$ (CfGetXData #den "G_SKDM"))
    (setq #ModelFlg (nth 0 #ed$))   ; 1. ���f���t���O
    (setq #ModelNo  (nth 1 #ed$))   ; 2. ���f���ԍ�

    (foreach #sym (cddr #ed$)       ; 3.�ȍ~ �_�~�[�}�`�̈�̃G���e�B�e�B
      (CFDispStar) ; "�v�Z��"�\�� 01/07/23 HN ADD

      ; ������̃`�F�b�N
      (setq #next T)
      (if (and #xSp (/= &kind "P") (/= &kind "M"))
        (progn
          ; ��ʂ̂S�_���쐬
          (setq #sPt (cdr (assoc 10 (entget #sym))))
          (setq #pt$ (GetSym4Pt #sym))
          (setq #pt0 (nth 0 #pt$))  ; ���_
          (setq #pt1 (nth 1 #pt$))  ; W
          (setq #pt3 (nth 2 #pt$))  ; D
          (setq #pt2 (polar #pt1 (angle #pt0 #pt3) (distance #pt0 #pt3)))

          (setq #next (KCFIsAreaMatchYashi &kind #eYas (list #pt0 #pt1 #pt2 #pt3) #sym))
          ; DEBUG(princ " ����: ")
          ; DEBUG(princ #next)
        )
      )

      ; 2000/10/19 HT "G_PANEL"���t������Ă���}�`�́A(GetWtAndFilr)
      ; �擾�����̂�2�d�ɂȂ�Ȃ��悤�ɂ����ł͏Ȃ�
      (if (CfGetXData #sym "G_PANEL")
        (setq #next nil)
      )

      (if (= #next T)
        (progn

          ; ���iCODE�擾
          (setq #code$ (CFGetSymSKKCode #sym nil))
          ; �V���{���̊g���f�[�^�擾
          (setq #eed$ (cadr (assoc -3 (entget #sym '("G_LSYM")))))
          (if (/= nil #eed$)
            (progn
              (cond
                ; ���ʐ}�̏ꍇ
                ((equal "P" &kind)
                  ;���_���       ... ���ʐ}
                  (setq #vcode "01")
                  ;���ʕ����t���O ... �K������
                  (setq #wd "W")
                  ;���ʃt���O
                  (setq #ang   (cdr (nth  3 #eed$)))
                  (setq #ang   (Angle0to360 (+ #ang &ang)))
                  (setq #vcode$ (SKFGetViewByAngle #ang "A"))
                  (if (and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_THR_CNR (nth 2 #code$)))
                    (progn
                        (setq #fcode 1)
                    )
                    (cond
                      ((or (= "03" (car  #vcode$))(= "04" (car  #vcode$)))
                        (setq #fcode 1)
                      )
                      ((or (= "05" (car  #vcode$))(= "06" (car  #vcode$)))
                      (setq #fcode 0)
                      )
                    )
                  )
                )
                ; �W�J�}�̏ꍇ
                ((wcmatch &kind "[ABCDEF]")
                  ; �z�u�p�x���擾
                  (if (/= nil (nth 3 #eed$))
                    (progn
                      ; ���ʊp�x���v�Z
                      (setq #ang   (cdr (nth  3 #eed$)))
                      (setq #ang   (Angle0to360 (+ #ang &ang)))
                      ; ���_��ށE�̈�t���O�擾
                      (setq #vcode$ (SKFGetViewByAngle #ang &kind))

                       ;DEBUG(princ "\n�: ")
                       ;DEBUG(princ &kind)
                       ;DEBUG(princ " �����R�[�h�E��������: ")
                       ;DEBUG(princ #vcode$)

                      (setq #vcode  (car  #vcode$))
                      (setq #wd     (cadr #vcode$))

                      ; ���ʃt���O
                      ; �R�[�i�[�L���r�l�b�g�͏��ON
                      (if (and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_THR_CNR (nth 2 #code$)))
                        (progn
                            (setq #fcode 1)
                        )
                        (cond

                          ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                          ; 04/03/24 SK ADD-S �Ζʃv�����Ή�
                          ((= "04" #vcode)
                            (setq #fcode -1)
                          )
                          ; 04/03/24 SK ADD-E �Ζʃv�����Ή�
                          ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

                          ((or (= "03" #vcode)(= "04" #vcode))
                            (setq #fcode 1)
                          )
                          ((or (= "05" #vcode)(= "06" #vcode))
                            (setq #fcode 0)
                          )
                        )
                      )
                    )
                  )
                )
                (T (setq #vcode ""))
              )
              (setq #en$ (CFGetGroupEnt #sym)) ;00/09/12 HN ADD �������Ή�
              (mapcar
               '(lambda ( #zcode )
                  ; ��w���擾
                  (if (= 'STR (type #zcode))
                    (progn
                    ; 2000/09/12 HT �b��Ή� �����W�t�[�h���̑������i�}�{�H�}�ɕ\������Ȃ�
                    ; �t�[�h�ɂ����ẮA�p�r�ԍ�=4��Z_05_00_04_## �ƂȂ�܂����A
                    ; �f�r�l�}�ʂł͏��i�}�E�{�H�}�̐}�`��Z_05_00_00_## �ɍ�}����
                    ; �Ă��邽�߁A�W�J���}�̑ΏۊO�ƂȂ�܂����B
                    ;
                    ; ����A**�ł̂f�r�l�}�ʂł́A���i�}�͑S��"00"�ƂȂ��Ă��܂�
                    ; ���A�{�H�}��"00"�ɂȂ��Ă�����"11"�����̑��̔ԍ��ɂȂ��Ă���
                    ; ��ł܂��܂��̏�Ԃł��B
                    ;
                    ; �֌˂���Ƌ��c�̌��ʁA�{���̓f�[�^�����C������ׂ��ł����A�t
                    ; �[�h���͐��������̂ŁA�W�J�}�쐬���ɂ͗p�r�ԍ������Ȃ��d�l
                    ; �Ɂi�Ƃ肠�����j�ύX���邱�Ƃɂ��܂��B
                    ;
                    ; �p�r�ԍ�**�����ł��ΏۂƂ���悤�ɕύX���ĂĂ��������B
                    ; Z_05_00_**_##
                    (setq #layer (strcat "Z_" #vcode "_" #zcode "_" "##_##"))
                    ; (setq #layer (strcat "Z_" #vcode "_" #zcode "_" #ano "_##"))
                    )
                  )
                  ;@@@(setq #en$ (CFGetGroupEnt #sym)) ;00/09/12 HN DEL �������Ή�
                  (mapcar
                   '(lambda ( #en )
                      (setq #8 (cdr (assoc 8 (entget #en))))
                      (if (wcmatch #8 #layer)
                        (setq #layen$ (cons #en #layen$))
                      )
                    )
                    #en$
                  )
                  ; �f�ʎw��
                  (if (/= nil (nth 15 #eed$))
                    (progn
                      (setq #dflg (cdr (nth 15 #eed$)))
                    )
                  )
                  ;--- ���X�g�Ɋi�[ ---
                  (setq #ret$
                    (cons
                      (list
                        #dflg      ; �f�ʎw��
                        #sym       ; �V���{���}�`��
                        #ModelFlg  ; ���f���t���O
                        #ModelNo   ; ���f���ԍ�
                        #fcode     ; ���ʃt���O
                        #wd        ; ���ʕ����t���O
                        #layen$    ; �}�`�����X�g
                      )
                      #ret$
                    )
                  )
                  ;--------------------
                  (setq #layen$ nil)
                )
                &Zcode$
              )
              (setq #Ret$$ (cons (reverse #ret$) #Ret$$))
              (setq #ret$ nil)
            )
          )
        )
;DEBUG        (progn
;DEBUG
;DEBUG          ; ���ʊp�x���v�Z
;DEBUG          (setq #eed$ (cadr (assoc -3 (entget #sym '("G_LSYM")))))
;DEBUG          (setq #ang   (cdr (nth  3 #eed$)))
;DEBUG          (setq #ang   (Angle0to360 (+ #ang &ang)))
;DEBUG          ; ���_��ށE�̈�t���O�擾
;DEBUG          (setq #vcode$ (SKFGetViewByAngle #ang &kind))
;DEBUG
;DEBUG         (princ "\n�: ")
;DEBUG         (princ &kind)
;DEBUG         (princ " �����R�[�h�E��������: ")
;DEBUG         (princ #vcode$)
;DEBUG
;DEBUG        )
      )
    )
    (setq #iI (1+ #iI))
  )
  (setq #iI 0)
  (repeat (length &zcode$)
    (setq #ret_n$
      (mapcar
       '(lambda ( #lst$ )
          (nth #iI #lst$)
        )
        #Ret$$
      )
    )
    (setq #ret_n$$ (cons #ret_n$ #ret_n$$))
    (setq #ret_n$ nil)
    (setq #iI (1+ #iI))
  )

  (reverse #ret_n$$)
) ; SKFGetCabiEntity




;<HOM>*************************************************************************
; <�֐���>    : C:COMM04
; <�����T�v>  : �����ܲ�(MW)�������
; <�߂�l>    :
; <�쐬>      : 2008/03/21 YM ADD �װ�WS�Ή��ǉ������
; <���l>      : ���ق́y�I��ύX�z�ł��Ȃ�.�ܲ�(MW),�ܲĈȊO�������K�v�Ȃ���
;               ���ق��ܲĐF�ɂ������ނ�ǉ�
;*************************************************************************>MOH<
(defun C:COMM04 (
  /
  #EN #EN$ #RET #XD$ #XREC$ #series
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ChgPanelWhite ////")
  (CFOutStateLog 1 1 " ")

  ;�ذ�ޔ���(�װ�WS��������) Errmsg.ini���Q��
  (setq #series (CFgetini "PANEL_WHITE" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
  (if (wcmatch CG_SeriesDB #series)
    nil
    ;else
    (progn
      (CFAlertMsg msg8)
      (quit)
    )
  );_if

  ;// �R�}���h�̏�����
  (StartUndoErr)
  (CFCmdDefBegin 6)
  (CabShow_sub) ; ��\�����ނ�\������ 01/05/31 YM ADD

  ;// ���݂̏��i�����擾����
  (setq #XRec$ (CFGetXRecord "SERI"))
  (if (= #XRec$ nil)
    (CFAlertErr "��x�����i�ݒ肪����Ă��܂���\n���i�ݒ���s���ĉ�����")
  )



  ;// �\��t������̎w���Ɠ\��t��
  (setq #en T)
  (command "_undo" "m")
  (while #en
    (initget "E Undo");00/07/21 SN MOD Undo���͂�����
    (setq #en (entsel "\n���-��ܲ�(MW)�ɂ������ق�I��/Enter=����/U=�߂�/: "))
    ;(initget "E")
    ;(setq #en (entsel "\n���ʂ�ύX����L���r�l�b�g��I��/Enter=����/ "))
    (cond
      ((and (= #en nil) #en$)
        (setq #ret (CFYesNoCancelDialog "����ł�낵���ł����H�z���C�g�ɌŒ肳��܂��B\n���F�ύX�̏ꍇ�A�폜/�Ĕz�u���K�v�ł��B"))
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
                    (GroupInSolidChgCol2 #en CG_InfoSymCol);00/07/21 SN MOD
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
  ;�ܲ� "MA,MWA"�̏��𖄂ߍ���
  (foreach #sym #en$
    (setq #xd$ (CFGetXData #sym "G_LSYM"))
    (CFSetXData
      #sym
      "G_LSYM"
      (CFModList
        #xd$
        (list 
          (list 7 "MA,MWA")
        )
      )
    )
  );foreach

  (CFCmdDefFinish)
  (setq *error* nil)
  (princ)
);C:COMM04


;<HOM>*************************************************************************
; <�֐���>    : ChgWS_Hikite
; <�����T�v>  : �װ�WS�ň���������ύX
; <�߂�l>    :
; <�쐬>      : 2008/03/27 YM ADD �װ�WS�Ή��ǉ������
; <���l>      : °�ݑΉ��łȂ��@��͈���L����ύX����K�v������
;*************************************************************************>MOH<
(defun ChgWS_Hikite (
  /
  #COL #DOOR #DUM$ #HIKI #HINBAN #I #QRY_A$ #QRY_N$ #SERI #SERIES #SS #SYM #XD$ #XREC$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// ChgWS_Hikite ////")
  (CFOutStateLog 1 1 " ")


        ;************************************************
        ; G_LSYM�̔������X�V���� 2008/03/27 YM ADD
        ;************************************************
        (defun ##KOUSIN (
           &seri &col &str &sym &xd$
          /
          #COL #DOOR #SERI
          )
          (setq #seri (strcat (substr &seri 1 1) &str (substr &seri 3 10)) );���
          (setq #col  (strcat (substr &col 1 2) &str) ) ;���
          (setq #door (strcat #seri "," #col))
          ;���𖄂ߍ���
          (CFSetXData
            &sym
            "G_LSYM"
            (CFModList
              &xd$
              (list 
                (list 7 #door)
              )
            )
          )
          (princ)
        );defun




  ;�ذ�ޔ���(�װ�WS��������) Errmsg.ini���Q��
  (setq #series (CFgetini "PANEL_WHITE" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
  (if (wcmatch CG_SeriesDB #series)
    (progn

      ;// �R�}���h�̏�����
      (StartUndoErr)
      (CFCmdDefBegin 6)
      (CabShow_sub) ; ��\�����ނ�\������ 01/05/31 YM ADD

      ;// ���݂̏��i�����擾����
      (setq #XRec$ (CFGetXRecord "SERI"))
      (if (= #XRec$ nil)
        (CFAlertErr "��x�����i�ݒ肪����Ă��܂���\n���i�ݒ���s���ĉ�����")
      )


    ;;; CG_DRSeriCode
    ;;; CG_DRColCode

      ;�}�`����ق��W�߂�
      (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; G_LSYM �}�`�I���

      (if (and #ss (> (sslength #ss) 0))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i))
            (setq #xd$ (CFGetXData #sym "G_LSYM"))
            (setq #hinban (nth 5 #xd$))
            ;�i�Ԃ�"@@#"���܂ނ��ǂ���
            (if (or (/= nil (vl-string-search "@@#" #hinban) )
                    (/= nil (vl-string-search "AA#" #hinban) ))
              (progn ;�܂ޏꍇ
                
                (setq #door (nth 7 #xd$));���,���(MA,MWA)
                (setq #dum$ (StrParse #door ","))
                (setq #seri (nth 0 #dum$))     ;���
                (setq #col  (nth 1 #dum$))     ;���
                (setq #hiki (substr #seri 2 1));����L��
                
                ;mdb����
                (setq #qry_N$
                  (CFGetDBSQLRec CG_DBSESSION "���莩���ύX"
                    (list
                      (list "�i�Ԗ���" #hinban 'STR)
                      (list "���ꏈ��"   "N"   'STR);°�ݑΉ��@��
                    )
                  )
                )

                ;mdb����
                (setq #qry_A$
                  (CFGetDBSQLRec CG_DBSESSION "���莩���ύX"
                    (list
                      (list "�i�Ԗ���" #hinban 'STR)
                      (list "���ꏈ��"   "A"   'STR);°�ݔ�Ή��@��̗�O�@K,R,U��Y �ɕύX����
                    )
                  )
                )

                (if (and (= nil #qry_N$)(= nil #qry_A$))
                  (progn ; �ʏ�̈���ύX
                    ;����=A,Y,C,D�Ȃ牽�����Ȃ�
                    (if (or (= #hiki "A")(= #hiki "Y")(= #hiki "C")(= #hiki "D"))
                      (progn
                        nil
                      )
                      (progn ;����ȊO
                        ;�@�@�@K,R,U��Y �ɕύX����
                        ;�@�@�@L,S,V��C �ɕύX����
                        ;�@�@�@M,T,W��D �ɕύX����
                        (cond
                          ((or (= #hiki "K")(= #hiki "R")(= #hiki "U"))
                            (##KOUSIN #seri #col "Y" #sym #xd$)
                          )
                          ((or (= #hiki "L")(= #hiki "S")(= #hiki "V"))
                            (##KOUSIN #seri #col "C" #sym #xd$)
                          )
                          ((or (= #hiki "M")(= #hiki "T")(= #hiki "W"))
                            (##KOUSIN #seri #col "D" #sym #xd$)
                          )
                        );_cond
                      )
                    );_if
                  )
                );_if
                
                (if (and (= nil #qry_N$)(/= nil #qry_A$))
                  (progn ; ��O�̈���ύX
                    ;����=A,Y,�Ȃ牽�����Ȃ�
                    (if (or (= #hiki "A")(= #hiki "Y"))
                      (progn
                        nil
                      )
                      (progn ;����ȊO
                        ; K,R,U��Y
                        ; C,D,L,M,S,T,V,W��A
                        (cond
                          ((or (= #hiki "K")(= #hiki "R")(= #hiki "U"))
                            (##KOUSIN #seri #col "Y" #sym #xd$)
                          )
                          ((or (= #hiki "C")(= #hiki "D")(= #hiki "L")(= #hiki "M")
                               (= #hiki "S")(= #hiki "T")(= #hiki "V")(= #hiki "W"))
                            (##KOUSIN #seri #col "A" #sym #xd$)
                          )
                        );_cond
                      )
                    );_if
                  )
                );_if

              )
            );_if

            (setq #i (1+ #i))
          );_(repeat

        )
      );_if

      (CFCmdDefFinish)
      (setq *error* nil)
      (princ "\n������X�V���܂���")
    )
  );_if
  (princ)
);ChgWS_Hikite



;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KPInsertBlock
;;; <�����T�v>  : �p�[�X��}�����ĕ�������(�p�[�X�}���R�}���h)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/03/13 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KPInsertBlock (
  /
  #BLOCK #OT #69 #8 #90 #EG$ #I #OK #SSVIEW #EVIEW
  #ORTHOMODE #OSMODE #SNAPMODE ;2010/01/08 YM ADD
  )
  ;// �R�}���h�̏�����
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (StartUndoErr)
  );_if

  (setq #ssVIEW (ssget "X" '((0 . "VIEWPORT"))))
  (setq #i 0 #OK nil)
  (if #ssVIEW
    (progn
      (repeat (sslength #ssVIEW)
        (setq #eg$ (entget (ssname #ssVIEW #i)))
        (setq #8  (cdr (assoc  8 #eg$)))
;;;01/12/05YM@DEL       (setq #90 (cdr (assoc 90 #eg$)))
;;;01/12/05YM@MOD       (if (and (= #8 "VIEW1")(= #90 34881)) ; �����}ON
        (if (= #8 "VIEW2") ; 01/12/05 YM MOD ���������ύX ��w�݂̂��݂�
          (progn
            (setq #OK T)
            (setq #69 (cdr (assoc 69 #eg$))) ; VIEWPORT ID
            ; 02/01/31 YM ADD-S �B������ON
            (setq #eVIEW (ssname #ssVIEW #i)) ; VIEWPORT�}�`
            ; 02/01/31 YM ADD-E �B������ON
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

;;;  (setq #ot (getvar "ORTHOMODE"))
;;;  (setvar "ORTHOMODE"  1)

  (if #OK
    (progn
      (setvar "ELEVATION" 0.0)              ; 01/12/06 HN ADD
      (setvar "TILEMODE" 1)
      (setq #block (strcat CG_KENMEI_PATH "BLOCK\\" "M_0.dwg"))
      (if (findfile #block)
        (progn
          ; 02/03/11 YM ADD-S purge���Ȃ��ƑO�̃p�[�X��}�����Ă��܂�
          (command "_purge" "bl" "*" "N")
          (command "_purge" "bl" "*" "N")
          (command "_purge" "bl" "*" "N")
          ; 02/03/11 YM ADD-E purge���Ȃ��ƑO�̃p�[�X��}�����Ă��܂�

          (princ "\n�p�[�X�}���ʒu: ")
          (command "_Insert" #block pause "" "")
          (princ "\n�z�u�p�x: ")
          (command pause)
          (command "_explode" (entlast))
        )
        (progn
          (CFAlertMsg "\n�p�[�X������܂���B")
          (quit)
        )
      );_if
      (setvar "TILEMODE" 0) ; ڲ��Đ}�Ɉڍs

      ; 02/01/31 YM ADD-S �߰��p�ޭ��߰ĉB������ON
      (command "_.pspace") ; �߰�߰���

      ; 02/02/08 YM ADD-S
      (command "zoom" "E") ; ��ʂ����ς��ɃY�[��
      ; 02/02/08 YM ADD-E

      (command "_layer" "U" "VIEW2" "ON" "VIEW2" "") ; ۯ�����,�\��
      (command "_.MVIEW" "H" "ON" #eVIEW "")
      ; 06/08/07 T.Ari Add �r���[�|�[�g�����b�N����Ă���3DORBIT�������Ȃ��ꍇ�����邽�߁B
      (command "_.MVIEW" "L" "OFF" #eVIEW "")
      (command "_layer" "LO" "VIEW2" "OF" "VIEW2" "") ; ۯ�,��\��
      ; 02/01/31 YM ADD-E �߰��p�ޭ��߰ĉB������ON

      (princ "\n�����̒������s���ĉ������B")
      (princ "\n")
      (command "_mspace")
      (setvar "CVPORT" #69)
      (command "_3DORBIT")
      (setvar "ELEVATION" 0.0)
    )
    (progn ; �߰����ذ�z�u���s��
      ; 03/01/21 YM MOD-S
;;;     (CFAlertMsg "\n���̐}�ʂɂ̓p�[�X�p�̃r���[�|�[�g���ݒ肳��Ă��܂���B")
;;;     (quit)

      ;05/07/04 YM ADD osnap,���sӰ�މ���
      (setq #OSMODE    (getvar "OSMODE"   ))
      (setq #SNAPMODE  (getvar "SNAPMODE" ))
      (setq #ORTHOMODE (getvar "ORTHOMODE"))
      (setvar "OSMODE"    0)
      (setvar "SNAPMODE"  0)
      (setvar "ORTHOMODE" 0)

      (KPFreeInsertBlock)

      ;05/07/04 YM ADD osnap,���sӰ�ޖ߂�
      (setvar "OSMODE"    #OSMODE)
      (setvar "SNAPMODE"  #SNAPMODE)
      (setvar "ORTHOMODE" #ORTHOMODE)

    )
  );_if

  ;;;  (setvar "ORTHOMODE" #ot)
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM ����Ӱ�ނŴװ�֐���`���Ȃ�
    (setq *error* nil)
  );_if
  (princ)
);C:KPInsertBlock

;<HOM>*************************************************************************
; <�֐���>    : PCM_MirrorParts
; <�����T�v>  : �~���[���]����
; <�߂�l>    :
; <�쐬��>    : 1999-06-14
; <���l>      : 03/05/28 YM Kcmrr.lsp ���炱���ֈړ�
;*************************************************************************>MOH<
(defun PCM_MirrorParts (
  &SymSS            ;(PICKSET)���]�Ώ̂̕���
  &p1               ;(LIST)�Ώ̎��̈�_��
  &p2               ;(LIST)�Ώ̎��̓�_��
  &EraseFlg         ;(INT) T:���]�����폜 nil:���]�����c��
  /
  #ANG #BPT #BPT1 #BPT2 #DROPPT #DWG #HOLE #I
  #LR #M1PT #M2PT #SEIKAKU #SETLR #SKK$ #SNK_ANA
  #SS #SSYM #SYM #SYM$ #WID #XD-LSYM$ #XD-SNK$ #XD-SYM$ #EN_LIS$
  #DIMD #DIMH #DIMW #ANA #DUM$ #KEI #LAST #O #PTEN5 #XD_PTEN5 #ZOKUP
  #ANA_layer #CRT #RET$ #xd-opt$ #TOKU #XD-TOKU$ #XD-KUTAI$
  #GASSYM #GASCABSYM #SNKSYM #SNKCABSYM #CT_TOP
#RD #RH #RNEW_D #RNEW_H #RNEW_W #RW #XDNEWSYM$ ; 02/03/25 YM
#KIKAKU #TOKUSUN #HH #XDNEWLSYM$ #QRY$ ; 03/05/28 YM
#PTEN5$ #PTEN5$$ #QRY$$ #SINK_KIGO #SINK_LR #SINK_SYM #ZURASHI_W ;2018/10/30 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PCM_MirrorParts ////")
  (CFOutStateLog 1 1 " ")

;;; ���������V���N���Ɉړ����Ȃ���΂Ȃ�Ȃ�
;;; ��АL�k���K�v�ȂƂ��ɔ�����,����,��ۂ��D�悷�� 01/03/22 YM ADD
  (if (equal (KPGetSinaType) 2 0.1) ; 01/06/29 YM ADD Lipple�ͺ�۷��ޗD��
    (setq #en_lis$ (PKMoveSNKbeforeOther_Lipple &SymSS)) ; �I���--->�}�`ؽ�
    (setq #en_lis$ (PKMoveSNKbeforeOther        &SymSS)) ; �I���--->�}�`ؽ�
  );_if

  ; �������ނ��܂ނ��ǂ������肷�� �܂�==>�����I��
  (setq #TOKU nil #CT_TOP nil #TOKUSUN nil) ; 03/05/27 YM #TOKUSUN �ǉ�
;03/05/27 YM DEL-S �������܂�ł��Ă��������p������
;;;  (foreach #sym #en_lis$
;;;    (setq #xd-toku$ (CFGetXData #sym "G_TOKU")) ; 01/03/22 YM ADD
;;;   (if (and #xd-toku$ (= (nth 3 #xd-toku$) 1))
;;;     (setq #TOKU T) ; �������ނ��܂�ł���
;;;   );_if
;;;   ; ���ʂ��܂ނ��ǂ��� 01/08/28 YM ADD-S ����̓~�J�h�d�l
;;;   (if (and #xd-toku$ (= (nth 3 #xd-toku$) 2))
;;;     (setq #CT_TOP T) ; �������ނ��܂�ł���
;;;   );_if
;;;   ; ���ʂ��܂ނ��ǂ��� 01/08/28 YM ADD-E
;;; )
;;; (if #TOKU
;;;   (progn
;;;     (CFAlertErr "�����L���r�l�b�g�̓~���[���]�ł��܂���B")
;;;     (quit)
;;;   )
;;; );_if
;;;
;;;   ; 01/08/28 YM ADD-S
;;; (if #CT_TOP
;;;   (CFAlertErr "\n���]��̐��ʗp�J�E���^�[�g�b�v�͕i�Ԋm�肪��������܂��B\n�i�Ԋm�肵�����ĉ������B")
;;; );_if
;;;   ; 01/08/28 YM ADD-E
;03/05/27 YM DEL-E

  ; ��͖̂������邱�Ƃɂ��� 01/04/23 YM ADD START
  (setq #dum$ nil)
  (foreach #sym #en_lis$
    (setq #xd-kutai$ (CFGetXData #sym "G_KUTAI"))
    (if #xd-kutai$
      nil ; ��̐}�`
      (setq #dum$ (append #dum$ (list #sym)))
    );_if
  )
  (setq #en_lis$ #dum$)
  (setq #dum$ nil)
  ; ��͖̂������邱�Ƃɂ��� 01/04/23 YM ADD END

  ; ���ʐ}�ړ��Ɏg�� 01/07/17 YM ADD
  (setq #GASSYM    nil)
  (setq #GASCABSYM nil)
  (setq #SNKSYM    nil)
  (setq #SNKCABSYM nil)

;/// main ���� /////////////////////////////////////////////////////////////////////
  (foreach #sym #en_lis$
    (setq #xd-lsym$ (CFGetXData #sym "G_LSYM"))
    (setq #xd-sym$  (CFGetXData #sym "G_SYM"))
    (setq #xd-opt$  (CFGetXData #sym "G_OPT"))  ; 01/02/28 YM ADD
    (setq #xd-toku$ (CFGetXData #sym "G_TOKU")) ; 01/03/22 YM ADD ��������

    ; 03/05/28 YM ADD �������܂ނ��ǂ�������
    (setq #KIKAKU nil) ; #KIKAKU=T�Ȃ�A�����Ȃ̂œ���==>�K�i�i�ɂ���("G_TOKU"��t�����Ȃ�)
    (if (and #xd-toku$ (= (nth 3 #xd-toku$) 1))
      (progn
        (if (or (not (equal (nth 11 #xd-sym$) 0 0.001)) ; �L�k�׸�W
                (not (equal (nth 12 #xd-sym$) 0 0.001)) ; �L�k�׸�D
                (not (equal (nth 13 #xd-sym$) 0 0.001))); �L�k�׸�H
          (setq #TOKUSUN T #KIKAKU T) ; #TOKUSUN = T�Ȃ�ү���ޕ\�� , #KIKAKU = T
        )
      )
    );_if

    (setq #bpt1     (cdr (assoc 10 (entget #sym))))
    (setq #seikaku  (nth 9 #xd-lsym$))   ;���iCODE

    (if (= #seikaku CG_SKK_INT_SNK) ; �ݸ�̏ꍇ ; 01/08/31 YM MOD 410-->��۰��ى�
      (progn
        (setq #xd-snk$  (CFGetXData #sym "G_SINK"))

				;2013/01/28 YM ADD-S
				(setq #SINK_KIGO (nth 0 #xd-snk$)) ; �ݸ�L��

			  (setq #qry$$
			    (CFGetDBSQLRec CG_DBSESSION "WT�V���N"
			      (list
			        (list "�V���N�L��" #SINK_KIGO 'STR)
			      )
			    )
			  )
				(if #qry$$
					(setq #SINK_LR (nth 4 (car #qry$$)))
					(setq #SINK_LR 1.0)
				);_if
				;2013/01/28 YM ADD-E

        (setq #HOLE (nth 3 #xd-snk$)) ; �ݸ���}�`��
        (if (and #HOLE (/= #HOLE ""))
          (progn
            (if (= &EraseFlg T) ; T:�폜
              (progn
                (command "_mirror" #HOLE "" &p1 &p2 "Y") ; �ړ�
                (setq #SNK_ANA #HOLE)     ;�װ���]��ݸ���}�`��
              )
              (progn
                (command "_mirror" #HOLE "" &p1 &p2 "N") ; ��߰
                (setq #SNK_ANA (entlast)) ;�װ���]��ݸ���}�`��
              )
            );_if
          )
        );_if
      )
    );_if

    (setq #ang  (nth 2 #xd-lsym$))   ;��]�p�x
    (setq #dwg  (nth 0 #xd-lsym$))   ;

;������ړ��@��� #rW �����߂ĕ␳����
    ; 02/03/25 YM ADD-S
    (setq #rW (nth 3 #xd-sym$))
    (setq #rD (nth 4 #xd-sym$))
    (setq #rH (nth 5 #xd-sym$))
    ; 02/03/25 YM ADD-E

		;2018/10/30 YM ADD ������v�l�̕␳�@�i�� (nth 5 #xd-lsym$)
		;2018/10/30 YM ADD-S
		(setq #ZURASHI_W (Counter_ZURASHI_W (nth 5 #xd-lsym$) )) ;�����W�� or nil

		(if #ZURASHI_W ;�������_���炵��������
			(setq #rW #ZURASHI_W) ;����į�ߏ����A�Б�į�ߏ����������_����,���]�ړ��Ή�
		);_if
		;2018/10/30 YM ADD-E




;2018\10\30 YM MOD-S
;;;		(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
;;;			(progn
;;;				(if (= #seikaku CG_SKK_INT_SUI) ;�����Ȃ�W=0
;;;		    	(setq #wid  0)    ;
;;;					;else
;;;					(setq #wid  (nth 3 #xd-sym$))    ;�����ȊO���̂܂�
;;;				);_if
;;;			)
;;;			;else �ڰѷ��݈ȊO
;;;			(progn
;;;		    (setq #wid  (nth 3 #xd-sym$))    ;
;;;			)
;;;		);_if

		(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
			(progn
				(if (= #seikaku CG_SKK_INT_SUI) ;�����Ȃ�W=0
		    	(setq #rW  0)    ;
					;else
					nil
				);_if
			)
			;else �ڰѷ��݈ȊO
			(progn
		    nil
			)
		);_if
;2018\10\30 YM MOD-E


    (setq #bpt2 (polar #bpt1 #ang #rW))




    ;// �Ώ̎��ƃV���{����_�̐��_�����߂�
    (setq &p1 (list (car &p1) (cadr &p1) (caddr #bpt1)))
    (setq &p2 (list (car &p2) (cadr &p2) (caddr #bpt1)))
    (setq #DropPt (CFGetDropPt #bpt1 (list &p1 &p2)))

    ;// ���]��̉����_�����߂�
    (setq #m1pt (polar #bpt1 (angle #bpt1 #DropPt) (* 2. (distance #bpt1 #DropPt))))

    ;// �Ώ̎��ƃV���{����_�̐��_�����߂�
    (setq #DropPt (CFGetDropPt #bpt2 (list &p1 &p2)))

    ;// ���]��̉����_�����߂�
    (setq #m2pt (polar #bpt2 (angle #bpt2 #DropPt) (* 2. (distance #bpt2 #DropPt))))
    (setq #ang  (angle #m2pt #m1pt))

    ;// L/R�敪�̎擾
    (setq #LR (nth 6 #xd-lsym$))
    (if (/= #LR "Z")   ;L/R�敪���� ; 00/02/18 YM MOD
      (progn
        ;// �����蕔�ނ��擾���Ȃ����A�Ĕz�u
        ; 01/02/28 YM MOD START
        (setq #ret$ (PKC_GetLRParts #xd-lsym$))
        (setq #dwg #ret$)
;;;2008/08/04YM@DEL        (setq #dwg (car   #ret$))
;;;2008/08/04YM@DEL        (setq #CRT (cadr  #ret$)) ; �W�JID
        ; 01/02/28 YM MOD END
      )
    )
    (setq #skk$ (CFGetSeikakuToSKKCode #seikaku nil))

		;2017/09/25 YM MOD-S �ڰѷ��݂͔�΂� �ݸ�}�`���Ȃ����߁B���̂܂ܐ����𔽓]������Ə��������B
		;�����Ԍ��T�C�Y>0�̂��߁A�����Ԍ��T�C�Y=0�Ƃ݂Ȃ�
		(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
			(progn
				nil ;SKIP
			)
			(progn

		    (cond
		      ((= (caddr #skk$) CG_SKK_THR_CNR)
		        (setq #m2pt #m1pt)
		        (setq #ang (- #ang (dtr 90)))
		      )
		      ((or (= (car #skk$) CG_SKK_ONE_SNK) (= (car #skk$) CG_SKK_ONE_WTR))
					 	;�ݸ or ����
						(if (= (car #skk$) CG_SKK_ONE_SNK)
							;�ݸ
		      		(setq #m2pt #m1pt)
							;else ����
							(progn
								;�ݸ��L/R������΂���ł���
								(if (equal #SINK_LR 1.0 0.001)
									(progn
				        		(setq #m2pt #m1pt)
									)
									(progn
										;�ݸ��L/R���Ȃ���ΐ������ʒu(1������z��)�ɔz�u����
							      ;// �V���N�ɐݒ肳��Ă��鐅����t���_�i�o�_=�T�j�̏����擾����
							      (setq #pten5$$ (PKGetPTEN_NO #SINK_SYM 5)) ; �߂�l(PTEN�}�`,G_PTEN)��ؽĂ�ؽ�
										(setq #pten5$ (car #pten5$$))
										(setq #pten5 (nth 0 #pten5$))
										(setq #m2pt (cdr (assoc 10 (entget #pten5)))) ; ���S�_���W
									)
								);_if
							)
						);_if
		      )
		    );_cond

			)
		);_if
		;2017/09/25 YM MOD-E �ڰѷ��݂͔�΂�

    (setq #ssym (CFGetSameGroupSS #sym))
    (if (= &EraseFlg T)
      (command "_erase" #ssym "")
    )
    (command "_insert" (strcat CG_MSTDWGPATH #dwg) #m2pt 1 1 (rtd #ang))
    (command "_explode" (entlast))  ;�C���T�[�g�}�`����
    (setq #ssym (ssget "P"))
    (setq #last (ssname #ssym 0))


    (SKMkGroup #ssym)               ;���������}�`�Q�Ŗ��O�̂Ȃ��O���[�v�쐬
;;;    (setq #sym (SKC_GetSymInGroup #last)) ; ����َ擾
       (setq #sym (PKC_GetSymInGroup #ssym))      ;;  2005/08/03 G.YK ADD



    ; 02/03/25 YM ADD-S
    (setq #xdNEWSYM$  (CFGetXData #sym "G_SYM"))
    (setq #rNEW_W (nth 3 #xdNEWSYM$))
    (setq #rNEW_D (nth 4 #xdNEWSYM$))
    (setq #rNEW_H (nth 5 #xdNEWSYM$))
    ; 02/03/25 YM ADD-E

		;2018/10/30 YM ADD ������v�l�̕␳�@�i�� (nth 5 #xd-lsym$)
		;2018/10/30 YM ADD-S
		(setq #ZURASHI_W (Counter_ZURASHI_W (nth 5 #xd-lsym$) )) ;�����W�� or nil

		(if #ZURASHI_W ;�������_���炵��������
			(setq #rNEW_W #ZURASHI_W) ;����į�ߏ����A�Б�į�ߏ����������_����,���]�ړ��Ή�
		);_if
		;2018/10/30 YM ADD-E


    (if (= #LR "Z")       ; 00/02/18 YM MOD
      (setq #setLR "Z")   ; 00/02/18 YM MOD
      (if (= #LR "L")     ; 00/02/18 YM MOD
        (setq #setLR "R") ; 00/02/18 YM MOD
        (setq #setLR "L") ; 00/02/18 YM MOD
      )
    )
    (setq #bpt (cdr (assoc 10 (entget #sym))))

;;;   (if (= #seikaku CG_SKK_INT_SCA) ; �ݸ���ނ̏ꍇ ; 01/08/31 YM MOD 112-->��۰��ى�
;;;     (setq #snkCAB #sym)
;;;   )

    ;// �g���f�[�^�̍Đݒ�
    (CFSetXData #sym "G_LSYM"
      (list
        #dwg                ;1 :�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID
        #bpt                ;2 :�}���_          :�z�u��_
        #ang                ;3 :��]�p�x        :�z�u��]�p�x
        (nth 3  #xd-lsym$)  ;4 :�H��L��        :CG_Kcode
        (nth 4  #xd-lsym$)  ;5 :SERIES�L��    :CG_SeriesCode
        (nth 5  #xd-lsym$)  ;6 :�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���
        #setLR              ;7 :L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪
        (nth 7  #xd-lsym$)  ;8 :���}�`ID        :
      (if (/= #LR "Z")
        ""                ;9 :���J���}�`ID    : HOPE-0351 2008/08/04 YM MOD
        (nth 8  #xd-lsym$)
      );_if
        (nth 9  #xd-lsym$)  ;10:���iCODE      :�w�i�Ԋ�{�x.���iCODE
        (nth 10 #xd-lsym$)  ;11:�����t���O      :�O�Œ�i�P�ƕ��ށj
        (nth 11 #xd-lsym$)  ;12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
        (nth 12 #xd-lsym$)  ;13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�
        (nth 13 #xd-lsym$)  ;14:���@�g          :�w�i�Ԑ}�`�x.���@�g
        (nth 14 #xd-lsym$)  ;15:�f�ʎw���̗L��  :�f�ʎw���̗L��
        (nth 15 #xd-lsym$)  ;16:����(����"A" or ���["D") : 2011/07/04 YM ADD
      )
    )
    (if #xd-opt$ (CFSetXData #sym "G_OPT" #xd-opt$)) ; 01/02/28 YM ADD

    ; 03/05/28 YM ADD-S
    ; �����i�Ȃ猳�̓�������t�^����.�A�������i(#KIKAKU=T)�͕t�����Ȃ�
    (if (and (= nil #KIKAKU) #xd-toku$)
      (CFSetXData #sym "G_TOKU" #xd-toku$)
    );_if

    ;�����i==>�K�i�i�ɂ������̂�"G_SYM"�̐L�k�׸ނ�0�ر����
    ;;;[12]:�L�k�׸�W                               (1040 . 1250.0)-->0
    ;;;[13]:�L�k�׸�D                               (1070 . 0)
    ;;;[14]:�L�k�׸�H                               (1070 . 900)-->0
    (if (and (= T #KIKAKU) #xd-toku$)
      (progn
        ;// �g���f�[�^��"G_SYM"�̍X�V
        (CFSetXData #sym "G_SYM"
          (CFModList #xdNEWSYM$
            (list
              (list 11 0)
              (list 12 0)
              (list 13 0)
            )
          )
        )
        ;// �g���f�[�^��"G_LSYM"�̍X�V
        ;�i�Ԑ}�`.���@H���擾���Ēu��������
        (setq #xdNEWLSYM$ (CFGetXData #sym "G_LSYM")) ; ���]��̐V����"G_LSYM"
        (setq #qry$
          (car
            (CFGetDBSQLHinbanTable "�i�Ԑ}�`"
               (nth 5 #xdNEWLSYM$)
               (list
                 (list "�i�Ԗ���" (nth 5 #xdNEWLSYM$)          'STR)
                 (list "LR�敪"   (nth 6 #xdNEWLSYM$)          'STR)
                 (list "�p�r�ԍ�" (rtois (nth 12 #xdNEWLSYM$)) 'INT)
               )
            )
          )
        )
        (CFSetXData #sym "G_LSYM"
          (CFModList #xdNEWLSYM$
            (list
              (list 13 (nth 5 #qry$));2008/06/28 YM OK!
            )
          )
        )
      )
    );_if
    ; 03/05/28 YM ADD-E


    ; 01/06/20 YM "G_SINK"��ĕs��C��
    (if (= nil #SNK_ANA)(setq #SNK_ANA ""))

    (if (= #seikaku CG_SKK_INT_SNK) ; �ݸ�̏ꍇ ; 01/08/31 YM MOD 410-->��۰��ى�
			(progn
				;2013/01/28 YM ADD-S
				(setq #SINK_SYM #sym);�V���N�}�`���L�����Ă���
				;2013/01/28 YM ADD-E
	      (CFSetXData #sym "G_SINK"
	        (CFModList
	          #xd-snk$
	          (list
	            (list 3 #SNK_ANA)
	;;;           (list 4 #snkCAB)
	          )
	        )
	      )
			)
    );_if

    (if (and #xd-toku$ (= (nth 3 #xd-toku$) 0))
      (progn ; ��АL�k���K�v
        (setq KEKOMI_BRK (nth 4 #xd-toku$)); ��ڰ�ײ݈ʒu
        (setq KEKOMI_COM (nth 5 #xd-toku$)); �L�k��
        (KPCallKekomi (list #sym)) ; ��АL�k����
      )
    );_if

    ; ���ʐ}�ړ��Ɏg�� 01/07/17 YM ADD
    (cond
      ((= #seikaku CG_SKK_INT_GAS)(setq #GASSYM    #sym)) ; ��ۂ̏ꍇ ; 01/08/31 YM MOD 210-->��۰��ى�
      ((= #seikaku CG_SKK_INT_GCA)(setq #GASCABSYM #sym)) ; ��۷��ނ̏ꍇ ; 01/08/31 YM MOD 113-->��۰��ى�
      ((= #seikaku CG_SKK_INT_SNK)(setq #SNKSYM    #sym)) ; �ݸ�̏ꍇ ; 01/08/31 YM MOD 410-->��۰��ى�
      ((= #seikaku CG_SKK_INT_SCA)(setq #SNKCABSYM #sym)) ; �ݸ���ނ̏ꍇ ; 01/08/31 YM MOD 112-->��۰��ى�
    );_cond

    ; 02/03/25 YM ADD-S �L�k���Ă������͍̂ĐL�k����(��������Ű����ȯĈȊO�Ɍ���-->��Ű����L/R�ŕs�)
    (if (and (= CG_SKK_ONE_CAB (CFGetSymSKKCode #sym 1))
             (= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3)))
      nil ; ��Ű����ȯĂ�����
      (progn

        ;�����i==>�K�i�i�ɂ������̂͑ΏۊO�Ƃ��� 03/05/28 YM ADD
        (if (and (= T #KIKAKU) #xd-toku$)
          nil ; 03/05/28 YM ADD
          ;else
          (progn ; �]��ۼޯ�
            (if (not (equal #rNEW_W #rW 0.0001))
              (SKY_Stretch_Parts #sym #rW #rNEW_D #rNEW_H)
            );_if
            (if (not (equal #rNEW_D #rD 0.0001))
              (SKY_Stretch_Parts #sym #rW #rD #rNEW_H)
            );_if
            (if (not (equal #rNEW_H #rH 0.0001))
              (SKY_Stretch_Parts #sym #rW #rD #rH)
            );_if
          )
        );_if

      )
    );_if
    ; 02/03/25 YM ADD-E �L�k���Ă������͍̂ĐL�k����

    (setq #sym$ (cons #sym #sym$))
  );_foreach
;/// main ���� /////////////////////////////////////////////////////////////////////

  ;03/05/27 YM MOD-S �����ł��������s��(quit���Ȃ�)
  (if #TOKUSUN
    (progn
      (CFYesDialog "�����L���r�͋K�i�i�ɖ߂邽�߁A���]��Ē������K�v�ł�")
    )
  );_if
  ;03/05/27 YM MOD-E

  ; ���ʐ}�ړ� 01/07/17 YM ADD
  (if (and #GASSYM #GASCABSYM)
    (PKC_MoveToSGCabinetSub #GASSYM #GASCABSYM)
  );_if
  (if (and #SNKSYM #SNKCABSYM)
    (PKC_MoveToSGCabinetSub #SNKSYM #SNKCABSYM)
  );_if

  ;// ���]��̐ݔ����ސ}�`���X�g��Ԃ�
  #sym$
);PCM_MirrorParts

;<HOM>*************************************************************************
; <�֐���>    : SKFSetHidePLayer
; <�����T�v>  : �o�ʁA�o���A�o�_���\���Ƃ���
; <�߂�l>    : �}�`�����X�g
; <�쐬>      : 1998-09-10 2003/06/06 YM Kcfcmn.lsp ���炻�̂܂܈ړ�
;*************************************************************************>MOH<
(defun SKFSetHidePLayer (
    /
  #ss
  #EG #EN #I #SUBST ;03/11/28 YM ADD
  )
  (setq #ss (ssget "X" '((-3 ("G_PMEN,G_PSEN,G_PTEN")))))
  (If (/= #ss nil)
    (progn

      (if (= nil (tblsearch "LAYER" "O_HIDE")) (MakeLayer "O_HIDE" 7 "CONTINUOUS"))
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #eg (entget #en '("*")))
        (setq #subst (subst (cons 8 "O_HIDE")(assoc 8 #eg) #eg))
        (entmod #subst)
        (setq #i (1+ #i))
      )
      (command "_.layer" "OFF" "O_HIDE" "")
    )
  )
)

;<HOM>*************************************************************************
; <�֐���>    : KP_GetOpt2Info
; <�����T�v>  : "G_OPT2" ==> (�����i��,���i��,���z,SET�i�׸�,�i��,���l)��ؽ� nil����
; <�߂�l>    : ������߼�ݕi��� (�����i��,���i��,���z,SET�i�׸�,�i��,���l)��ؽ� nil����
; <�쐬>      : 03/06/17 YM
; <���l>      : �_�~�[�̊֐�
; ***********************************************************************************>MOH<
(defun KP_GetOpt2Info (
  &xdOPT2$ ; ������߼�ݕi��� nil���蓾��
  /
  #opt2$$
  )
  (setq #opt2$$ nil)
  #opt2$$
);KP_GetOpt2Info

;<HOM>*************************************************************************
; <�֐���>    : SCFGetBlockKindDlg
; <�����T�v>  : �o�͓W�J���}�ݒ�_�C�A���O
; <�߂�l>    : �_�C�A���O�Ԃ�l
; <�쐬>      : 1999-06-21
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun SCFGetBlockKindDlg (
  &no$        ; �̈�ԍ����X�g
  /
  #xSp #iI #Ex$ #No$ #iMode #sNo #iId  #Ret$ #iRet
  )

  (defun ##OK_Click(
    /
    #Ret$ #sPln #sExa #sExb #sExc #sExd #sTab
    )

    ; 2000/07/06 HT YASHIAC  ��̈攻��ύX DEL START
    ;;�̈�ԍ��l��
    ;(if (/= nil #No$)
    ;  (progn
    ;    (if (/= 1 (length #No$))
    ;      (if (= "0" (get_tile "popRyo"))
    ;        (setq #No$ (cdr #No$))
    ;        (setq #No$ (list (nth (atoi (get_tile "popRyo")) #No$)))
    ;      )
    ;    )
    ;  )
    ;)
    ; 2000/07/06 HT YASHIAC  ��̈攻��ύX END

    (if (= "1" (get_tile "tglAll"))
      (progn
        (setq #Ret$ (list 1 1 1))
        ; 2000/07/06 HT YASHIAC  ��̈攻��ύX MOD
        ;(setq #Ret$ (list #Ret$ #No$))
        (setq #Ret$ (list #Ret$ (list "0")))
        (done_dialog 1)
      )
      (progn
        (setq #sPln (get_tile "tglPln"))
        (setq #sExt (get_tile "tglExt"))
        (setq #sTab (get_tile "tglTab"))
        (if (and (= "0" #sPln)(= "0" #sExt)(= "0" #sTab))
          (CFAlertMsg "�����I������Ă��܂���,")
          (progn
            ;�}�ʎ��
            (setq #Ret$ (list #sPln #sExt #sTab))
            (setq #Ret$ (mapcar 'atoi #Ret$))
            ; 2000/07/06 HT YASHIAC  ��̈攻��ύX MOD
            ; (setq #Ret$ (list #Ret$ #No$))
            (setq #Ret$ (list #Ret$ (list "0")))
            (done_dialog 1)
          )
        )
      )
    )
    #Ret$
  )

  (defun ##AllTgl (
    /
    )
    (if (= "1" (get_tile "tglAll"))
      (progn
        (mode_tile "tglPln" 1)
        (mode_tile "tglExt" 1)
        (mode_tile "tglTab" 1)
      )
      (progn
        (mode_tile "tglPln" 0)
        (mode_tile "tglExt" 0)
        (mode_tile "tglTab" 0)
      )
    )
  )

  ; 2000/07/06 HT YASHIAC  ��̈攻��ύX DEL START
  ;;�̈�NO�l��
  ;(if (/= nil &no$)
  ;  (progn
  ;    (mapcar
  ;     '(lambda ( #no )
  ;        (if (= 'STR (type #no))
  ;          (setq #No$ (cons #no #No$))
  ;        )
  ;      )
  ;      &no$
  ;    )
  ;    (if (/= nil #No$)
  ;      (progn
  ;        (setq #No$ (acad_strlsort #No$))
  ;        (setq #No$ (ExceptToList #No$))
  ;        (if (/= 1 (length #No$))
  ;          (progn
  ;            (setq #No$ (cons "ALL" #No$))
  ;            (setq #iMode 0)
  ;          )
  ;          (setq #iMode 1)
  ;        )
  ;      )
  ;      (progn
  ;        (setq #No$ nil)
  ;        (setq #sNo "1")
  ;        (setq #iMode 1)
  ;      )
  ;    )
  ;  )
  ;  (progn
  ;    (setq #No$ nil)
  ;    (setq #sNo "1")
  ;    (setq #iMode 1)
  ;  )
  ;)

  ;;ؽ��ޯ���ɒl��\������
  ;(defun ##SetList ( &SCFey &List$ / #vAl )
  ;  (start_list &SCFey)
  ;  (foreach #vAl &List$
  ;    (add_list #vAl)
  ;  )
  ;  (end_list)
  ;)
  ; 2000/07/06 HT YASHIAC  ��̈攻��ύX DEL END

  ;�޲�۸ޕ\��
  (setq #iId (GetDlgID "CSFmat"))
  (if (not (new_dialog "GetMat" #iId))(exit))

    (##AllTgl)
    ; 2000/07/06 HT YASHIAC  ��̈攻��ύX DEL
    ;(##SetList "popRyo" #No$)
    ;(mode_tile "popRyo" #iMode)
    (action_tile "tglAll" "(##AllTgl)")
    (action_tile "accept" "(setq #Ret$ (##OK_Click))")
    (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OK�{�^������
    #Ret$
    nil
  )
) ; SCFGetBlockKindDlg

;<HOM>*************************************************************************
; <�֐���>    : KP_MakeDummyPoint
; <�����T�v>  : ����ڰĂ�POINT����}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 03/07/26 YM
; <���l>      : �Ȃ� NAS�̓_�~�[�֐�(�����Ȃ�)
;*************************************************************************>MOH<
(defun KP_MakeDummyPoint ( / )
  (princ)
)


;<HOM>*************************************************************************
; <�֐���>    : c:SCFDispOnOff
; <�����T�v>  : �\������R�}���h
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/03/15
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun c:SCFDispOnOff (
  /
  #DT #EG #IID #IRET #KEY #LAY$ #LAYER #LAYER$$ #RET$
  )
  ;2011/07/06 YM MOD-S ���ڕύX
;;; (setq #layer$$
;;;   (list
;;;     (list "0_DOOR"   "tgl1")
;;;     (list "0_PLIN_1" "tgl2")
;;;     (list "0_PLIN_2" "tgl3")
;;;     (list "0_WALL"   "tgl4")
;;;     (list "0_REFNO"  "tgl5")
;;;   )
;;; )
  (setq #layer$$
    (list
      (list "0_DOOR"    "tgl0")  ;���͗l�\��    2013/09/17 ���ĉ��� tgl1==>tgl0
      (list "0_pline_1" "tgl1")  ;���J�����\��
      (list "0_KUTAI"   "tgl2")  ;��̕\��
      (list "0_WALL"    "tgl3")  ;���ٕ��ʕ\��
      (list "0_REFNO"   "tgl4")  ;�d�l�\�ԍ��\��
    )
  )
  ;2011/07/06 YM MOD-E ���ڕύX

  ;////////////////////////////////////////////////////////////////
  (defun ##OK_Click(
    /
    )
    (list
      (list "0_DOOR"   (get_tile "tgl0"))  ; ���͗l�\�� ;2013/09/17 ���ĉ��� tgl1==>tgl0
      (list "0_pline_1" (get_tile "tgl1"))  ; ���͗l�\��
      (list "0_KUTAI"  (get_tile "tgl2"))  ; ��̕\��
      (list "0_WALL"   (get_tile "tgl3"))  ; 2000/06/20 HT �{���̳��ٕ��ʕ\��  �ǉ�
      (list "0_REFNO"  (get_tile "tgl4"))  ; 01/05/01 YM ADD �d�l�\�ԍ��\��  �ǉ�
    )
  )
  ;////////////////////////////////////////////////////////////////

  (SCFStartShori "SCFDispOnOff")  ; 2000/09/08 HT ADD

  ;�޲�۸ޕ\��
  (setq #iId (GetDlgID "CSFdisp"))
  (if (not (new_dialog "SCFDispOnOff" #iId))(exit))

  ; ����ĸ�ِݒ� 01/05/01 YM
  (foreach #layer$ #layer$$
    (setq #layer (car  #layer$))
    (setq #key   (cadr #layer$))
    (if (tblsearch "LAYER" #layer) ; 62 : �F�ԍ�(���̏ꍇ�A��w�͔�\��)
      (if (= 1 (cdr (assoc 70 (tblsearch "LAYER" #layer)))) ; (70.1)�ذ�� 01/05/18 YM MOD
;;;01/05/18YM@      (if (minusp (cdr (assoc 62 (tblsearch "LAYER" #layer)))) ; ���l�������ǂ����𒲂ׂ܂�
        (set_tile #key "0") ; ��\��==>���������Ȃ�
        (set_tile #key "1") ; �\��==>����������
      );_if
      (mode_tile #key 1) ; �g�p�s�\
    );_if
  )

  ; �����
  (action_tile "accept" "(setq #Ret$ (##OK_Click))(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OK�{�^������
    (progn
      (mapcar
       '(lambda ( #lay$ )
          (setq #layer (car #lay$))
          (if (tblsearch "LAYER" #layer)
            (progn
              ; 01/05/18 YM MOD START
;;;             (setq #eg (entget (tblobjname "LAYER" #layer)))
              (cond
                ((= "1" (cadr #lay$))
                  (command "_.layer" "T" #layer "")
;;;                 (entmod (subst (cons 70 0) (assoc 70 #eg) #eg))
                )
                ((= "0" (cadr #lay$))
                  (command "_.layer" "F" #layer "")
;;;                 (entmod (subst (cons 70 1) (assoc 70 #eg) #eg)) ; �ذ��
                )
              );_cond
              ; 01/05/18 YM MOD END

;;;01/05/18YM@; 62 : �F�ԍ�(���̏ꍇ�A��w�͔�\��)
;;;01/05/18YM@            (if (or (and (minusp (cdr (assoc 62 (tblsearch "LAYER" #layer)))) ; ���l�������ǂ����𒲂ׂ܂�
;;;01/05/18YM@                         (= "1" (cadr #lay$)))
;;;01/05/18YM@                    (and (not (minusp (cdr (assoc 62 (tblsearch "LAYER" #layer)))))
;;;01/05/18YM@                         (= "0" (cadr #lay$))))
;;;01/05/18YM@              (progn
;;;01/05/18YM@                (setq #eg (entget (tblobjname "LAYER" #layer)))
;;;01/05/18YM@                (setq #dt (* -1 (cdr (assoc 62 #eg))))
;;;01/05/18YM@                (entmod (subst (cons 62 #dt) (assoc 62 #eg) #eg))
;;;01/05/18YM@              )
;;;01/05/18YM@            );_if

            )
          );_if
        )
        #Ret$
      )
    )
  );_if
  (princ)
) ; SCFGetPatDlg

;<HOM>*************************************************************************
; <�֐���>    : SCAutoFDispOnOff
; <�����T�v>  : �����\������(����̔�ذ�ނ̂Ƃ������u���J��������v��OFF�ɂ���)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 03/09/30
; <���l>      : ����̔�ذ�ނ�"Errmsg.ini"�Œ�`����
;               �}�ʎQ�Ǝ���CALL����NAS�͉������Ȃ�
;*************************************************************************>MOH<
(defun SCAutoFDispOnOff ( / )
  (princ)
); SCAutoFDispOnOff

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_DanmenDlg
;;; <�����T�v>  : WT�f�ʃ_�C�A���O
;;; <�߂�l>    : �f�ʏ��(WT�f��ں���,(2����BG�L��,FG����,3����BG�L��,FG����))
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKW_DanmenDlg (
  &ZaiCode ; �ގ�
  &CutId   ; ���ID
  /
  #DCL_ID #DAN$$ #QRY$$ #REC$
#FULLFLAT ;03/11/28 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_DanmenDlg ////")
  (CFOutStateLog 1 1 " ")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1,2,3����WT�ݒ�g�p��,�s�����Ӱ�޾��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##MODE123 (&flg1 &flg2 &flg3 / )
            ; 0:�g�p�� 1:�g�p�s��
            (mode_tile "box1"    &flg1)
            (mode_tile "BGtext1" &flg1)
            (mode_tile "FGtext1" &flg1)
            (mode_tile "box2"    &flg2)
            (mode_tile "BGtext2" &flg2)
            (mode_tile "FGtext2" &flg2)
            (mode_tile "box3"    &flg3)
            (mode_tile "BGtext3" &flg3)
            (mode_tile "FGtext3" &flg3)
            (princ)
          );##MODE123
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1,2,3����WT�ݒ�׼޵���ݾ��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##SET123 (&flg1 &flg2 &flg3 &flg4 &flg5 &flg6 /  )
            (set_tile "BGradio1-1" &flg1) ; 1����BG�L��
            (set_tile "FGradio1-1" &flg2) ; 1����FG���ߑO��,����
            (set_tile "BGradio2-1" &flg3) ; 2����BG�L��
            (set_tile "FGradio2-1" &flg4) ; 2����FG���ߑO��,����
            (set_tile "BGradio3-1" &flg5) ; 3����BG�L��
            (set_tile "FGradio3-1" &flg6) ; 3����FG���ߑO��,����
            (princ)
          );##SET123
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; WT�f��ں��ނ��擾
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( /
            #BG1-1 #BG2-1 #BG3-1 #BG_S1 #BG_S2 #BG_S3 #BG_TYPE1 #BG_TYPE2 #BG_TYPE3
            #FG1-1 #FG1-2 #FG1-3 #FG1-4 #FG2-1 #FG2-2 #FG2-3 #FG3-1 #FG3-2 #FG3-3
            #FG_TYPE1 #FG_TYPE2 #FG_TYPE3 #WTINFO1 #WTINFO2 #WTINFO3
            )
            (if (= (get_tile "rad2") "1") ; �f�ʌʐݒ������
              (progn ; �f�ʌʐݒ�
                (setq #BG1-1 (get_tile "BGradio1-1"))        ; 1����BG�L��
                (setq #BG2-1 (get_tile "BGradio2-1"))        ; 2����BG�L��
                (setq #BG3-1 (get_tile "BGradio3-1"))        ; 3����BG�L��

                (setq #FG1-1 (get_tile "FGradio1-1"))        ; 1����FG���ߑO��
                (setq #FG1-2 (get_tile "FGradio1-2"))        ; 1����FG���ߑO��
;;;               (setq #FG1-3 (get_tile "FGradio1-3"))        ; 1����FG���ߑO��E
;;;               (setq #FG1-4 (get_tile "FGradio1-4"))        ; 1����FG���ߑO����
                (setq #FG2-1 (get_tile "FGradio2-1"))        ; 2����FG���ߑO��
                (setq #FG2-2 (get_tile "FGradio2-2"))        ; 2����FG���ߑO��
;;;               (setq #FG2-3 (get_tile "FGradio2-3"))        ; 2����FG���ߑO��E
                (setq #FG3-1 (get_tile "FGradio3-1"))        ; 3����FG���ߑO��
                (setq #FG3-2 (get_tile "FGradio3-2"))        ; 3����FG���ߑO��
;;;               (setq #FG3-3 (get_tile "FGradio3-3"))        ; 3����FG���ߑO��E

                (setq #BG_S1 (atof (get_tile "WT_EXT1"))) ; 1����WT���s�g��
                (setq #BG_S2 (atof (get_tile "WT_EXT2"))) ; 2����WT���s�g��
                (setq #BG_S3 (atof (get_tile "WT_EXT3"))) ; 3����WT���s�g��

                (if (= #BG1-1 "1")  ; 1����BG�L��
                  (setq #BG_Type1 1); BG����
                  (setq #BG_Type1 0); BG�Ȃ�
                );_if
                (if (= #BG2-1"1")   ; 2����BG�L��
                  (setq #BG_Type2 1); BG����
                  (setq #BG_Type2 0); BG�Ȃ�
                );_if
                (if (= #BG3-1 "1")  ; 3����BG�L��
                  (setq #BG_Type3 1); BG����
                  (setq #BG_Type3 0); BG�Ȃ�
                );_if

                (cond
                  ((= #FG1-1 "1")     ; 1����FG����
                    (setq #FG_Type1 1); FG�O
                  )
                  ((= #FG1-2 "1")     ; 1����FG����
                    (setq #FG_Type1 2); FG�O��
                  )
                  ((= #FG1-3 "1")     ; 1����FG����
                    (setq #FG_Type1 3); FG�O��E
                  )
                  ((= #FG1-4 "1")     ; 1����FG����
                    (setq #FG_Type1 4); FG�O�㍶
                  )
                );_cond

                (cond
                  ((= #FG2-1 "1")     ; 2����FG����
                    (setq #FG_Type2 1); FG�O
                  )
                  ((= #FG2-2 "1")     ; 2����FG����
                    (setq #FG_Type2 2); FG�O��
                  )
                  ((= #FG2-3 "1")     ; 2����FG����
                    (setq #FG_Type2 3); FG�O��E
                  )
                );_cond

                (cond
                  ((= #FG3-1 "1")     ; 3����FG����
                    (setq #FG_Type3 1); FG�O
                  )
                  ((= #FG3-2 "1")     ; 3����FG����
                    (setq #FG_Type3 2); FG�O��
                  )
                  ((= #FG3-3 "1")     ; 3����FG����
                    (setq #FG_Type3 3); FG�O��E
                  )
                );_cond

                (setq #WTInfo1 (list #BG_S1 #BG_Type1 #FG_Type1));1����WT���s�g��,1����BG�L��,1����FG����
                (setq #WTInfo2 (list #BG_S2 #BG_Type2 #FG_Type2));2����
                (setq #WTInfo3 (list #BG_S3 #BG_Type3 #FG_Type3));3����
              )
              (progn ; �f�ʋ���
                (setq #WTInfo1
                  (list (nth 10 #rec$)(nth 3 #rec$)(nth 6 #rec$));�㐂����,BG�L��,�O��������
                )
                (setq #WTInfo2 #WTInfo1)
                (setq #WTInfo3 #WTInfo1)
              )
            );_if

            (done_dialog)
            (list #rec$ #WTInfo1 #WTInfo2 #WTInfo3)
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �ʐݒ�\��open
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##open ( / #flg1 #flg2)

;03/11/27 YM ����ΰёΉ� MOD-S

        ;03/10/14 YM ADD
        (setq #FullFlat (nth 12 #rec$))
        (cond 
          ;����ΰ���������
          ((or (equal #FullFlat 51 0.1)(equal #FullFlat 52 0.1))
            ;���ׯď����l��`
            (set_tile "rad2" "1")
            (mode_tile "BGradio1" 1)
            (mode_tile "FGradio1" 1)
;-- 2011/08/25 A.Satoh Mod - S
;            (set_tile "WT_EXT1" "450")
            (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
          )
          ;�ި��۱���ׯ�����
          ((or (equal #FullFlat  2 0.1)(equal #FullFlat  3 0.1)
               (equal #FullFlat 22 0.1)(equal #FullFlat 33 0.1))
            ;���ׯď����l��`
            (set_tile "rad2" "1")
            (mode_tile "BGradio1" 1)
            (mode_tile "FGradio1" 1)
;-- 2011/08/25 A.Satoh Mod - S
;            (set_tile "WT_EXT1" "410")
            (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
          )
          ;07/07/11 YM ADD �ڽ��ׯ�����D=880
          ((or (equal #FullFlat 82 0.1)(equal #FullFlat 83 0.1))
            ;���ׯď����l��`
            (set_tile "rad2" "1")
            (mode_tile "BGradio1" 1)
            (mode_tile "FGradio1" 1)
;-- 2011/08/25 A.Satoh Mod - S
;            (set_tile "WT_EXT1" "230")
            (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
          )
          (T
            (if (= (get_tile "rad2") "1")
              (progn ; �ʐݒ�
                (cond ; �g�pӰ�ސ���
                  ((= CG_W2CODE "Z")(##MODE123 0 1 1))
                  ((= CG_W2CODE "L")
                    (if (= &CutId 0)
                      (##MODE123 0 0 1) ; L�^��ĂȂ� 01/08/27 YM MOD
                      (##MODE123 0 0 1) ; L�^��Ă���
                    );_if
                  )
                  ((= CG_W2CODE "U")(##MODE123 0 0 0))
                  (T (##MODE123 0 0 0))
                );_cond
                (##FG_SEIGYO) ; �O����׼޵����
              )
              (progn ; �f�ʋ���
                (if (equal (nth 3 #rec$) 1 0.1)
                  (setq #flg1 "1") ; BG����
                  (setq #flg1 "0") ; BG�Ȃ�
                );_if
                (if (= #flg1 "1")
                  (setq #flg2 "1") ; BG����==>�O����O��
                  (if (equal (nth 6 #rec$) 1 0.1)
                    (setq #flg2 "1") ; �O����O��
                    (setq #flg2 "0") ; �O���ꗼ��
                  )
                );_if

                (##SET123 #flg1 #flg2 #flg1 #flg2 #flg1 #flg2) ; ׼޵���ݾ��
                (set_tile "WT_EXT1" "0") ; 1����WT���s�g��
                (set_tile "WT_EXT2" "0") ; 2����WT���s�g��
                (set_tile "WT_EXT3" "0") ; 3����WT���s�g��
                (##MODE123 1 1 1) ; ׼޵����Ӱ�ޕύX(�S�Ďg�p�s��)
              )
            );_if

          )
        );_cond

;03/11/27 YM ����ΰёΉ� MOD-E

;03/11/27 YM MOD ����ΰёΉ�
;;;       ;03/10/14 YM ADD
;;;       (setq #FullFlat (nth 12 #rec$))
;;;       (if (or (equal #FullFlat  2 0.1)(equal #FullFlat  3 0.1)
;;;               (equal #FullFlat 22 0.1)(equal #FullFlat 33 0.1))
;;;         (progn ;���ׯď����l��`
;;;           (set_tile "rad2" "1")
;;;            (mode_tile "BGradio1" 1)
;;;            (mode_tile "FGradio1" 1)
;;;           (set_tile "WT_EXT1" "410")
;;;         )
;;;         (progn
;;;
;;;           (if (= (get_tile "rad2") "1")
;;;             (progn ; �ʐݒ�
;;;               (cond ; �g�pӰ�ސ���
;;;                 ((= CG_W2CODE "Z")(##MODE123 0 1 1))
;;;                 ((= CG_W2CODE "L")
;;;                   (if (= &CutId 0)
;;;;;;01/08/27YM@                     (##MODE123 0 1 1) ; L�^��ĂȂ�
;;;                     (##MODE123 0 0 1) ; L�^��ĂȂ� 01/08/27 YM MOD
;;;                     (##MODE123 0 0 1) ; L�^��Ă���
;;;                   );_if
;;;                 )
;;;                 ((= CG_W2CODE "U")(##MODE123 0 0 0))
;;;                 (T (##MODE123 0 0 0))
;;;               );_cond
;;;               (##FG_SEIGYO) ; �O����׼޵����
;;;             )
;;;             (progn ; �f�ʋ���
;;;               (if (equal (nth 3 #rec$) 1 0.1)
;;;                 (setq #flg1 "1") ; BG����
;;;                 (setq #flg1 "0") ; BG�Ȃ�
;;;               );_if
;;;               (if (= #flg1 "1")
;;;                 (setq #flg2 "1") ; BG����==>�O����O��
;;;                 (if (equal (nth 6 #rec$) 1 0.1)
;;;                   (setq #flg2 "1") ; �O����O��
;;;                   (setq #flg2 "0") ; �O���ꗼ��
;;;                 )
;;;               );_if
;;;
;;;               (##SET123 #flg1 #flg2 #flg1 #flg2 #flg1 #flg2) ; ׼޵���ݾ��
;;;               (set_tile "WT_EXT1" "0") ; 1����WT���s�g��
;;;               (set_tile "WT_EXT2" "0") ; 2����WT���s�g��
;;;               (set_tile "WT_EXT3" "0") ; 3����WT���s�g��
;;;               (##MODE123 1 1 1) ; ׼޵����Ӱ�ޕύX(�S�Ďg�p�s��)
;;;             )
;;;           );_if
;;;
;;;         )
;;;       );_if

            (princ)
          );##open
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �߯�߱���ؽ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( / dum$$)

						;2011/09/18 YM ADD-S &ZaiCode ���݂̍ގ��ōi�荞��
						;�\���\�f��ID���yWT�ގ��z����擾����
					  (setq #Qry_zai$
					    (CFGetDBSQLRec CG_DBSESSION "WT�ގ�"
					      (list
					        (list "�ގ��L��" &ZaiCode 'STR)
					      )
					    )
					  )
						;�f��IDؽ�
						;;;	(setq #danmenID$ (StrParse (nth 7 (car #Qry_zai$)) ","))
						(setq #danmenID (nth 7 (car #Qry_zai$)))
						;2011/09/18 YM ADD-E &ZaiCode ���݂̍ގ��ōi�荞��

            (start_list "dan1" 3)
						(setq dum$$ nil)
            (foreach #Qry$ #Qry$$
							(if (wcmatch (nth 0 #Qry$) #danmenID)
								(progn
              		(add_list (nth 1 #Qry$))
									(setq dum$$ (append dum$$ (list #Qry$)))
								)
							);_if
            )
						(setq #Qry$$ dum$$);�i�荞�񂾂��̂ɒu��������
            (end_list)
            (set_tile "dan1" "0") ; �ŏ���̫���
            (##Addtext)
            (princ)
          );##Addpop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �I�𒆂̒f��ؽĂɏ]����WT���÷�ĕ\��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addtext ( /  #dum1 #dum2)
            (setq #rec$ (nth (atoi (get_tile "dan1")) #Qry$$)) ; ���ݑI��f��ں���
            (set_tile "text11" (itoa (fix (+ (nth 2  #rec$))))) ; ܰ�į�ߌ���
            (set_tile "text22" (itoa (fix (+ (nth 4  #rec$))))) ; �ޯ��ް�ލ���
            (set_tile "text33" (itoa (fix (+ (nth 5  #rec$))))) ; �ޯ��ް�ތ���
            (set_tile "text44" (itoa (fix (+ (nth 7  #rec$))))) ; �O���ꍂ��
            (set_tile "text55" (itoa (fix (+ (nth 8  #rec$))))) ; �O�������
            (set_tile "text66" (itoa (fix (+ (nth 9  #rec$))))) ; �O������

            (if (equal (nth  3  #rec$) 0 0.1)(setq #dum1 "�ޯ��ް�ނȂ�"))
            (if (equal (nth  3  #rec$) 1 0.1)(setq #dum1 "�ޯ��ް�ނ���"))

            (if (equal (nth  6  #rec$) 1 0.1)(setq #dum2 "�O���̂�"))
            (if (equal (nth  6  #rec$) 2 0.1)(setq #dum2 "����"))

            (set_tile "text77" #dum1) ; �ޯ��ް�ޗL��
            (set_tile "text88" #dum2) ; �O��������

            ;03/10/14 YM ADD
            (setq #FullFlat (nth 12 #rec$))

;07/07/11 YM MOD �ش���ׯ�D=880�Ή�
            (cond
              ((or (equal #FullFlat  2 0.1)(equal #FullFlat  3 0.1)
                    (equal #FullFlat 22 0.1)(equal #FullFlat 33 0.1))
              ;���ׯď����l��`
                (set_tile "rad2" "1")
                (##open)
                (mode_tile "BGradio1" 1)
                (mode_tile "FGradio1" 1)
;-- 2011/08/25 A.Satoh Mod - S
;                (set_tile "WT_EXT1" "410")
                (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
              )

              ((or (equal #FullFlat 82 0.1)(equal #FullFlat 83 0.1))
              ;���ׯď����l��`
                (set_tile "rad2" "1")
                (##open)
                (mode_tile "BGradio1" 1)
                (mode_tile "FGradio1" 1)
;-- 2011/08/25 A.Satoh Mod - S
;                (set_tile "WT_EXT1" "230")
                (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
              )

              (T  ;���ׯĈȊO�����l��`
                (set_tile "rad1" "1")
;-- 2011/08/25 A.Satoh Mod - S
;                (set_tile "WT_EXT1" "0")
                (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
                (##open)
              )
            );_cond


;07/07/11 YM MOD �ش���ׯ�D=880�Ή�
;;;           (if (or (equal #FullFlat  2 0.1)(equal #FullFlat  3 0.1)
;;;                   (equal #FullFlat 22 0.1)(equal #FullFlat 33 0.1))
;;;             (progn ;���ׯď����l��`
;;;               (set_tile "rad2" "1")
;;;               (##open)
;;;               (mode_tile "BGradio1" 1)
;;;               (mode_tile "FGradio1" 1)
;;;               (set_tile "WT_EXT1" "410")
;;;             )
;;;             (progn ;���ׯĈȊO�����l��`
;;;               (set_tile "rad1" "1")
;;;               (set_tile "WT_EXT1" "0")
;;;               (##open)
;;;             )
;;;           );_if



            (princ)
          );##Addtext
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; BG�L���ɂ��O����I�������� BG����==>���ʑO����s��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##FG_SEIGYO ( / )
            (if (= (get_tile "BGradio1-1") "1") ; 1����BG�L��
              (progn ; BG����
                (set_tile  "FGradio1-1" "1") ; 1����FG���ߑO��
                (mode_tile "FGradio1-2" 1)   ; �g�p�s��
;;;               (mode_tile "FGradio1-3" 1)   ; �g�p�s��
;;;               (mode_tile "FGradio1-4" 1)   ; �g�p�s��
              )
              (progn
                (mode_tile "FGradio1-2" 0)   ; �g�p��
;;;               (mode_tile "FGradio1-3" 0)   ; �g�p��
;;;               (if (or (= CG_W2CODE "Z") ; I�^ or L�^��ĂȂ�
;;;                       (and (= CG_W2CODE "L")(= &CutId 0)))
;;;                 (mode_tile "FGradio1-4" 0)   ; �g�p��
;;;                 (mode_tile "FGradio1-4" 1)   ; �g�p�s��
;;;               );_if
              )
            );_if
            (if (= (get_tile "BGradio2-1") "1") ; 2����BG�L��
              (progn
                (set_tile  "FGradio2-1" "1") ; 1����FG���ߑO��
                (mode_tile "FGradio2-2" 1)   ; �g�p�s��
;;;               (mode_tile "FGradio2-3" 1)   ; �g�p�s��
              )
              (progn
                (mode_tile "FGradio2-2" 0)   ; �g�p��
;;;               (if (= CG_W2CODE "U")
;;;                 (mode_tile "FGradio2-3" 1) ; �g�p�s��
;;;                 (mode_tile "FGradio2-3" 0) ; �g�p��
;;;               );_if
              )
            );_if
            (if (= (get_tile "BGradio3-1") "1") ; 3����BG�L��
              (progn
                (set_tile  "FGradio3-1" "1") ; 1����FG���ߑO��
                (mode_tile "FGradio3-2" 1)   ; �g�p�s��
;;;               (mode_tile "FGradio3-3" 1)   ; �g�p�s��
              )
              (progn
                (mode_tile "FGradio3-2" 0)   ; �g�p��
;;;               (mode_tile "FGradio3-3" 0)   ; �g�p��
              )
            );_if
            (princ)
          );##FG_SEIGYO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #Qry$$
    (DBSqlAutoQuery CG_DBSESSION "select * from WT�f��")
  )
  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "DanmenDlg" #dcl_id)) (exit))
  ;;; �߯�߱���ؽ�
  (##Addpop)

  ;;; �����ݒ�
  (set_tile "rad1" "1") ; ������׼޵="�f�ʋ���"
  (##open) ; �ʐݒ�(�޲�۸މE��)�̐���

; ;// ��ق�ر���ݐݒ�
  (action_tile "rad"  "(##open))") ; �f�ʋ���rad1,��rad2
  (action_tile "dan1" "(##Addtext))")
  (action_tile "accept" "(setq #dan$$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #dan$$ nil) (done_dialog)")
  (action_tile "BGradio1" "(##FG_SEIGYO))"); �O�������ߑI�𐧌�
  (action_tile "BGradio2" "(##FG_SEIGYO))"); �O�������ߑI�𐧌�
  (action_tile "BGradio3" "(##FG_SEIGYO))"); �O�������ߑI�𐧌�
  (start_dialog)
  (unload_dialog #dcl_id)
  #dan$$
);PKW_DanmenDlg




;����������������������������������������
;�������@�ȉ��~�J�h�œ������޺���� ������
;<HOM>*************************************************************************
; <�֐���>    : C:StretchCab
; <�����T�v>  : �L���r�l�b�g�L�k����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/04/07 MH
; <���l>      :
;*************************************************************************>MOH<
(defun C:StretchCabM (
  /
  #en #Gen #LXD$ #XD$ #sys$
  )

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
      (defun TempErr ( msg / #msg )
        (setq CG_TOKU nil)
        (setq CG_TOKU_BW nil)
        (setq CG_TOKU_BD nil)
        (setq CG_TOKU_BH nil)
        (KP_TOKU_GROBAL_RESET)
        (setq CG_BASE_UPPER nil)
        (command "_undo" "b")
        (setq *error* nil)
        (princ)
      )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

  ; �O����
  (setq *error* TempErr)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")

  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
  (setq CG_TOKU T)
  (KP_TOKU_GROBAL_RESET)
  (setq CG_BASE_UPPER nil)

  (setq #en 'T)
  (while #en
    (setq #Gen nil)
    (setq #en (car (entsel "\n�����Ώۂ̃L���r�l�b�g��I�� : ")))
    (if #en (setq #Gen (CFSearchGroupSym #en)))
    (if (and #en (not #Gen)) (CFAlertMsg "���̐}�`�͏����Ώۂɂł��܂���"))
    (if #Gen
      (progn
        (setq #LXD$ (CFGetXData #Gen "G_LSYM"))
        (setq #XD$ (CFGetXData #Gen "G_SYM"))
        (cond
          ((CFGetXData #Gen "G_KUTAI")
            nil
          )

          ;;; �L���r�l�b�g�L�k���s
          (t (PcStretchCab #Gen)(setq #en nil))
        ); cond
      )
    ) ; progn if
  );while

;;;02/04/23YM@DEL ); 01/06/28 YM ADD ����ނ̐��� Lipple
;;;02/04/23YM@DEL);_if

  ; �㏈��
  (setq *error* nil)
  (CFCmdDefFinish);00/09/07 SN MOD
  (PKEndCOMMAND #sys$)
  (setq CG_TOKU nil)
  (setq CG_TOKU_BW nil)
  (setq CG_TOKU_BD nil)
  (setq CG_TOKU_BH nil)
;;;01/09/25YM@DEL (setq CG_DOOR_MOVE nil) ; 01/05/31 YM ADD
  ; 01/09/25 YM ADD-S
  (KP_TOKU_GROBAL_RESET)
  ; 01/09/25 YM ADD-E

  (setq CG_BASE_UPPER nil); 01/08/20 YM ADD
  (princ)

); C:StretchCab

;<HOM>*************************************************************************
; <�֐���>    : PcStretchCab
; <�����T�v>  : �L���r�l�b�g�L�k����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/04/07 MH 01/01/27 YM ��ڰ�ײ݂Ȃ��ł�OK�ɉ���
; <���l>      : ����ُ�t���̏ꍇ�l�� 01/02/21 YM
;*************************************************************************>MOH<
(defun PcStretchCab (
  &en ; �L�k�Ώۼ���ِ}�`
  /
  #DLOG$ #sym #LXD$ #XD$ #WDH$ #ss #bsym
  #ANG #BRKD #BRKH #BRKW #EDELBRK_D$ #EDELBRK_H$ #EDELBRK_W$ #GNAM
  #PT #XLINE_D #XLINE_H #XLINE_W #HINBAN #RET$ #flg #CNTZ #FHMOV
  #LR #ORG_PRICE #QRY$ #userHINBAN
  #DBASE #RZ #SBIKOU #SHINMEI ; 01/08/20 YM ADD �ݼލ��������L�k�s�
  #USERBIKOU #USERHINMEI ; 03/07/17 YM ADD
  #hinban$ #cannot$ #dlg #mp #eD$
  )
  (setq #flg nil) ; �L�k���������Ȃ�=T
  (setq #sym &en)

;;;  ;������ 05/03/31 SZ ADD ������
;;;  ;ERRMSG.INI��[BREAKLINE]���ڂ��擾
;;;  (setq #hinban$ (CFgetini "BREAKLINE" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
;;;  (if (strp #hinban$) (setq #hinban$ (strparse #hinban$ ",")))
;;;  (setq #cannot$ (CFgetini "BREAKLINE" "0002" (strcat CG_SKPATH "ERRMSG.INI")))
;;;  (if (strp #cannot$) (setq #cannot$ (strparse #cannot$ ",")))
;;;  ;������ 05/03/31 SZ ADD ������

  ; 01/08/20 YM ADD-S
  (setq #dBASE (cdr (assoc 10 (entget #sym)))) ; ����وʒu
  (setq #rZ (caddr #dBASE)) ; ��t������
  (if (= #rZ nil)(setq #rZ 0.0))
  ; 01/08/20 YM ADD-E
  (setq #LXD$ (CFGetXData #sym "G_LSYM"))
  (setq #HINBAN (nth 5 #LXD$))
  (setq #LR     (nth 6 #LXD$))
  (setq #XD$  (CFGetXData #sym "G_SYM" ))
  ; 01/08/20 YM ADD-S
  (if (> 0 (nth 10 #XD$)) ; ����ق���t��===>T,����=nil
    (setq CG_BASE_UPPER T) ; �������޺���ޒ��̸�۰���
  );_if
  ; 01/08/20 YM ADD-E

  (setq #eDelBRK_W$ (PcRemoveBreakLine #sym "W")) ; W�����u���[�N����
  (setq #eDelBRK_D$ (PcRemoveBreakLine #sym "D")) ; D�����u���[�N����
  (setq #eDelBRK_H$ (PcRemoveBreakLine #sym "H")) ; H�����u���[�N����
  (setq #pt  (cdr (assoc 10 (entget #sym))))      ; ����ي�_
  (setq #ANG (nth 2 #LXD$))                       ; ����ٔz�u�p�x
  (setq #gnam (SKGetGroupName #sym))              ; ��ٰ�ߖ�

;;; ;�L�k�s�i�� 05/03/31 ADD SZ
;;; (if (member #hinban #cannot$)
;;;   (progn
;;;     (CFAlertMsg "���̐}�`�͏����Ώۂɂł��܂���")
;;;     (exit)
;;;   )
;;; )

;;; ���މ��i������
;;;01/08/20YM@  (setq #ORG_price (KPGetPrice #HINBAN #LR)) ; �߂�l�ǉ�
  ; 01/08/20 YM MOD-S
  (setq #ret$ (KPGetPrice #HINBAN #LR))
  (setq #ORG_price (nth 0 #ret$))
  (setq #sHINMEI   (nth 1 #ret$)) ; �i��
  (setq #sBIKOU    (nth 2 #ret$)) ; ���l
  ; 01/08/20 YM MOD-E

  ; �}�`�F��ύX
  (setq #ss (CFGetSameGroupSS #sym))
  (command "_change" #ss "" "P" "C" CG_InfoSymCol "")

  ; W,D,H
  (setq #WDH$ (list (nth 3 #XD$) (nth 4 #XD$) (nth 5 #XD$)))

;;; (if (not (member #hinban #hinban$))
;;;   (progn
      ;���[�U�ݒ�_�C�A���O
      (setq #dlg T) ;�t���OON
      (setq #DLOG$ (PcGetStretchCabInfoDlg #WDH$))
      (if (not #DLOG$) (quit))
      ;�u���[�N���C���ʒu�擾
      (setq #BrkW (nth 3 #DLOG$))
      (setq #BrkD (nth 4 #DLOG$))
      (if CG_BASE_UPPER
        ;���_
        (setq #BrkH (- (+ (nth 5 #DLOG$) #rZ) (nth 5 #XD$))) ;�V���{����t�������l��
        ;����_
        (setq #BrkH (nth 5 #DLOG$))
      );if
;;;   )
;;;   ;else
;;;   ;�u���[�N���C�����������Ȃ��ꍇ���� 05/03/31 ADD SZ
;;;   ;��ERRMSG.INI�ݒ�ς̐}�`(���ʃ��E���h�^�C�v�V��)
;;;   (progn
;;;     ;�u���[�N���C���̕���
;;;     (foreach #eD$ (list #eDelBRK_W$ #eDelBRK_D$ #eDelBRK_H$)
;;;       (foreach #eD #eD$ (if (= (entget #eD) nil) (entdel #eD)))
;;;     )
;;;     ;�u���[�N���C������_����߂����Ƀ\�[�g����
;;;     (setq #eDelBRK_W$ (reverse (SKESortBreakLine (list 0 #eDelBRK_W$) #pt)))
;;;     (setq #eDelBRK_D$ (reverse (SKESortBreakLine (list 1 #eDelBRK_D$) #pt)))
;;;     (setq #eDelBRK_H$ (reverse (SKESortBreakLine (list 2 #eDelBRK_H$) #pt)))
;;;     ;���[�U�I��->�L�k��̒l���X�g���擾
;;;     (setq #DLOG$
;;;       (list
;;;         (UserSelectBreakLine "W" (car   #WDH$) #eDelBRK_W$)
;;;         (UserSelectBreakLine "D" (cadr  #WDH$) #eDelBRK_D$)
;;;         (UserSelectBreakLine "H" (caddr #WDH$) #eDelBRK_H$)
;;;       )
;;;     )
;;;   )
;;; );if

;;;01/09/25YM@DEL (setq CG_TOKU_BW #BrkW)
;;;01/09/25YM@DEL (setq CG_TOKU_BD #BrkD)
;;;01/09/25YM@DEL (setq CG_TOKU_BH #BrkH)

;;;01/02/27YM@  ;;; ��ڰ�ײ݂̍�}
;;;01/02/27YM@  (setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))
;;;01/02/27YM@  (setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))
;;;01/02/27YM@  (setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))
;;;01/02/27YM@  (CFSetXData #XLINE_W "G_BRK" (list 1))
;;;01/02/27YM@  (CFSetXData #XLINE_D "G_BRK" (list 2))
;;;01/02/27YM@  (CFSetXData #XLINE_H "G_BRK" (list 3))
;;;01/02/27YM@  ;;; ��ڰ�ײ̸݂�ٰ�߉�
;;;01/02/27YM@  (command "-group" "A" #gnam #XLINE_W "")
;;;01/02/27YM@  (command "-group" "A" #gnam #XLINE_D "")
;;;01/02/27YM@  (command "-group" "A" #gnam #XLINE_H "")

  ; �L�k���s
  (if (or (not (equal (car   #WDH$) (car   #DLOG$) 0.1))
          (not (equal (cadr  #WDH$) (cadr  #DLOG$) 0.1))
          (not (equal (caddr #WDH$) (caddr #DLOG$) 0.1)))
    (progn
      (setq #flg T) ; �L�k����������

      (if #dlg ; 05/03/31 ADD SZ
        (progn
          ;;; ��ڰ�ײ݂̍�}
          (setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))
          (setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))
          (setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))
          (CFSetXData #XLINE_W "G_BRK" (list 1))
          (CFSetXData #XLINE_D "G_BRK" (list 2))
          (CFSetXData #XLINE_H "G_BRK" (list 3))
          ;;; ��ڰ�ײ̸݂�ٰ�߉�
          (command "-group" "A" #gnam #XLINE_W "")
          (command "-group" "A" #gnam #XLINE_D "")
          (command "-group" "A" #gnam #XLINE_H "")
        )
      )

;;;      (SKY_Stretch_Parts #sym (car #DLOG$) (cadr #DLOG$) (caddr #DLOG$))
      (setq #fHmov (- (caddr #DLOG$) (nth 5 #XD$)))
; 01/02/27 YM MOD
      (if (not (equal (car #DLOG$)  (nth 3 #XD$) 0.0001)) ; W
        (progn
          (setq CG_TOKU_BW #BrkW)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)
          (SKY_Stretch_Parts #sym (car #DLOG$) (nth 4 #XD$) (nth 5 #XD$))

          (if #dlg ; 05/03/31 ADD SZ
            (progn
              ;;; �ꎞ��ڰ�ײݍ폜
              (entdel #XLINE_W)
              ;;; ������ڰ�ײݕ���
              (foreach #eD #eDelBRK_W$
                (if (= (entget #eD) nil) (entdel #eD)) ;W�����u���[�N����
              );for
            )
            ;else �� 05/03/31 ADD SZ
            (progn
              (setq #eD$ nil)
              ;W�����u���[�N����
              (foreach #eD #eDelBRK_W$
                (if (= (entget #eD) nil)
                  (entdel #eD)
                  ;else
                  (setq #eD$ (append #eD$ (list #eD)))
                )
              );for
              ;�u���[�N���C���̈ړ���̍��W�����߂�
              (cond
                ;�������u���[�N���C�����Q�ȏテ�[�U�I�����ꂽ�ꍇ�́A�������r���[�ȑΉ�
                ((< 1 (length #eD$))
                  ;�����L�k�l�̔����̒l�ňړ�����
                  (setq #mp (list (fix (* 0.5 (- (car #DLOG$) (car #WDH$)))) 0 0))
                  ;W�����u���[�N�ړ�
                  (foreach #eD #eDelBRK_W$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;���[�U�I���u���[�N���C�����P�ŁA�ł���_���̏ꍇ
                ((and (= 1 (length #eD$)) (equal (car #eD$) (car #eDelBRK_W$)))
                  ;�����L�k�l���̂܂܂̒l�ňړ�����
                  (setq #mp (list (fix (- (car #DLOG$) (car #WDH$))) 0 0))
                  ;W�����u���[�N�ړ�
                  (foreach #eD #eDelBRK_W$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;���[�U�I���u���[�N���C�����P�ŁA�ł���_���牓���ꍇ
                ((and (= 1 (length #eD$)) (equal (car #eD$) (last #eDelBRK_W$)))
                  ;�ړ����Ȃ�
                )
                ;���̑��̏ꍇ
                (T
                  ;�ړ����Ȃ�
                )
              );cond
            )
          );if

          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      ; 01/09/25 YM ADD-S
      (KP_TOKU_GROBAL_RESET)
      ; 01/09/25 YM ADD-E

      (if (not (equal (cadr #DLOG$) (nth 4 #XD$) 0.0001)) ; D
        (progn
          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD #BrkD)
          (setq CG_TOKU_BH nil)
          (SKY_Stretch_Parts #sym (car #DLOG$) (cadr #DLOG$) (nth 5 #XD$))

          (if #dlg ; 05/03/31 ADD SZ
            (progn
              ;;; �ꎞ��ڰ�ײݍ폜
              (entdel #XLINE_D)
              ;;; ������ڰ�ײݕ���
              (foreach #eD #eDelBRK_D$
                (if (= (entget #eD) nil) (entdel #eD)) ;D�����u���[�N����
              );for
            )
            ;else �� 05/03/31 ADD SZ
            (progn
              (setq #eD$ nil)
              ;D�����u���[�N����
              (foreach #eD #eDelBRK_D$
                (if (= (entget #eD) nil)
                  (entdel #eD)
                  ;else
                  (setq #eD$ (append #eD$ (list #eD)))
                )
              );for
              ;�u���[�N���C���̈ړ���̍��W�����߂�
              (cond
                ;�������u���[�N���C�����Q�ȏテ�[�U�I�����ꂽ�ꍇ�́A�������r���[�ȑΉ�
                ((< 1 (length #eD$))
                  ;�����L�k�l�̔����̒l�ňړ�����
                  (setq #mp (list 0 (fix (* 0.5 (- (cadr #DLOG$) (cadr #WDH$)))) 0))
                  ;D�����u���[�N�ړ�
                  (foreach #eD #eDelBRK_D$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;���[�U�I���u���[�N���C�����P�ŁA�ł���_���̏ꍇ
                ((and (= 1 (length #eD$)) (equal (car #eD$) (car #eDelBRK_D$)))
                  ;�����L�k�l���̂܂܂̒l�ňړ�����
                  (setq #mp (list 0 (fix (- (cadr #DLOG$) (cadr #WDH$))) 0))
                  ;D�����u���[�N�ړ�
                  (foreach #eD #eDelBRK_D$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;���[�U�I���u���[�N���C�����P�ŁA�ł���_���牓���ꍇ
                ((and (= 1 (length #eD$)) (equal (car #eD$) (last #eDelBRK_D$)))
                  ;�ړ����Ȃ�
                )
                ;���̑��̏ꍇ
                (T
                  ;�ړ����Ȃ�
                )
              );cond
            )
          );if

          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      ; 01/09/25 YM ADD-S
      (KP_TOKU_GROBAL_RESET)
      ; 01/09/25 YM ADD-E

      (if (not (equal (caddr #DLOG$)(nth 5 #XD$) 0.0001)) ; H
        (progn
          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH #BrkH)
          (SKY_Stretch_Parts #sym (car #DLOG$) (cadr #DLOG$) (caddr #DLOG$))

          (if #dlg ; 05/03/31 ADD SZ
            (progn
              ;;; �ꎞ��ڰ�ײݍ폜
              (entdel #XLINE_H)
              ;;; ������ڰ�ײݕ���
              (foreach #eD #eDelBRK_H$
                (if (= (entget #eD) nil) (entdel #eD)) ;H�����u���[�N����
              );for
            )
            ;else �� 05/03/31 ADD SZ
            (progn
              (setq #eD$ nil)
              ;H�����u���[�N����
              (foreach #eD #eDelBRK_H$
                (if (= (entget #eD) nil)
                  (entdel #eD)
                  ;else
                  (setq #eD$ (append #eD$ (list #eD)))
                )
              );for
              ;�u���[�N���C���̈ړ���̍��W�����߂�
              (cond
                ;�������u���[�N���C�����Q�ȏテ�[�U�I�����ꂽ�ꍇ�́A�������r���[�ȑΉ�
                ((< 1 (length #eD$))
                  ;�����L�k�l�̔����̒l�ňړ�����
                  (setq #mp (list 0 0 (fix (* 0.5 (- (caddr #DLOG$) (caddr #WDH$))))))
                  ;H�����u���[�N�ړ�
                  (foreach #eD #eDelBRK_H$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;���[�U�I���u���[�N���C�����P�ŁA�ł���_���̏ꍇ
                ((and (= 1 (length #eD$)) (equal (car #eD$) (car #eDelBRK_H$)))
                  ;�����L�k�l���̂܂܂̒l�ňړ�����
                  (setq #mp (list 0 0 (fix (- (caddr #DLOG$) (caddr #WDH$)))))
                  ;H�����u���[�N�ړ�
                  (foreach #eD #eDelBRK_H$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;���[�U�I���u���[�N���C�����P�ŁA�ł���_���牓���ꍇ
                ((and (= 1 (length #eD$)) (equal (car #eD$) (last #eDelBRK_H$)))
                  ;�ړ����Ȃ�
                )
                ;���̑��̏ꍇ
                (T
                  ;�ړ����Ȃ�
                )
              );cond
            )
          );if

          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

;;;01/09/25YM@DEL     ;;; �ꎞ��ڰ�ײݍ폜
;;;01/09/25YM@DEL     (entdel #XLINE_W)
;;;01/09/25YM@DEL     (entdel #XLINE_D)
;;;01/09/25YM@DEL     (entdel #XLINE_H)
;;;01/09/25YM@DEL     ;;; ������ڰ�ײݕ���
;;;01/09/25YM@DEL     (foreach #eD #eDelBRK_W$ (entdel #eD)) ; W�����u���[�N����
;;;01/09/25YM@DEL     (foreach #eD #eDelBRK_D$ (entdel #eD)) ; D�����u���[�N����
;;;01/09/25YM@DEL     (foreach #eD #eDelBRK_H$ (entdel #eD)) ; H�����u���[�N����

;;;01/09/25YM@DEL     (PCD_MakeViewAlignDoor (list #sym) 3 T)

; �W�J�}�쐬���ɍs��Ȃ��ƈӖ����Ȃ��̂ŉ��̏����͎~�߂�
;;;01/03/12YM@      (setq CG_OUTCMDNAME "SCFMakeMaterial") ; 01/03/11 YM ADD 2D-PMEN7�ɉ�w"0_door"�Ŕ��𒣂邽��
;;;01/03/12YM@      (PCD_MakeViewAlignDoor (list #sym) 2 nil)
;;;01/03/12YM@      (setq CG_OUTCMDNAME nil) ; 01/03/11 YM ADD
;;;01/03/12YM@      (command "_layer" "OFF" "0_door" "") ; ��w "0_door" ��\��
    )
    (progn ; �������Ȃ�
      (setq #flg T) ; �L�k���������Ȃ�  ; �i�Ԃ̂ݕς���Ƃ��̂��ߏI�����Ȃ�
;;;01/04/06YM@      (setq #flg nil) ; �L�k���������Ȃ�

;;;01/04/06YM@      (CFAlertMsg "\n�L�k���܂���ł����B")
      (princ "\n�L�k���܂���ł����B")
    )
  ); end of if

  ;�F��߂�
  (command "_change" #ss "" "P" "C" "BYLAYER" "")

;;;01/02/27YM@  ;;; �ꎞ��ڰ�ײݍ폜
;;;01/02/27YM@  (entdel #XLINE_W)
;;;01/02/27YM@  (entdel #XLINE_D)
;;;01/02/27YM@  (entdel #XLINE_H)
;;;01/02/27YM@  ;;; ������ڰ�ײݕ���
;;;01/02/27YM@  (foreach #eD #eDelBRK_W$ (entdel #eD)) ; W�����u���[�N����
;;;01/02/27YM@  (foreach #eD #eDelBRK_D$ (entdel #eD)) ; D�����u���[�N����
;;;01/02/27YM@  (foreach #eD #eDelBRK_H$ (entdel #eD)) ; H�����u���[�N����
;;;  (command "._shademode" "H") ; �B������ ����(��߰�ޱ���)07/07 YM ADD

  ;;; 01/02/21 YM ADD
  ; ���_��H�����L�k�̂������A�C�e���͐L�k��H�����Ɉړ� 01/02/02 MH ADD
  ; ���̏����v��Ȃ��H�H�H
;;;01/02/27YM@  (if (and (not (equal 0 #fHmov 0.1)) (= -1 (nth 10 (CFGetXData #sym "G_SYM"))))
;;;01/02/27YM@    (progn
;;;01/02/27YM@      ; �ړ���_��Z�l���擾
;;;01/02/27YM@      (setq #cntZ (- (caddr #pt) #fHmov))
;;;01/02/27YM@      (command "_move" (CFGetSameGroupSS #sym) "" #pt
;;;01/02/27YM@        (list (car #pt) (cadr #pt) #cntZ))
;;;01/02/27YM@    ); progn
;;;01/02/27YM@  ); if

  ;����т̏ꍇ�͊���ѐF�ɂ���B
  (if (and (setq #bsym (car (CFGetXRecord "BASESYM")))
           (equal (handent #bsym) #sym))
    (progn
      (ResetBaseSym)
      (GroupInSolidChgCol #sym CG_BaseSymCol)
    )
  );_if

  ;;; �m�F�޲�۸�
  (if #flg
    (progn
      (setq #ret$
        (ShowTOKUCAB_Dlog

          (if (= #LR "Z") ; 01/06/27 YM ADD LR�ǉ�
            (strcat "ĸ" #HINBAN) ; �i��
            (strcat "ĸ" #HINBAN #LR) ; �i��
          );_if

;;;01/06/27YM@          (strcat "ĸ" #HINBAN )
          "0"
          (list (nth 0 #DLOG$)(nth 1 #DLOG$)(nth 2 #DLOG$))
          #ORG_price ; ���̉��i
          #sHINMEI ; �i�� 01/08/20 YM ADD
          #sBIKOU  ; ���l 01/08/20 YM ADD
        )
      ); �i��,���i

      (if (= nil #ret$)
        (quit)
      );_if

      ; �S�p��߰��𔼊p��߰��ɒu�������� 01/06/27 YM ADD
      (setq #userHINBAN (vl-string-subst "  " "�@" (nth 0 #ret$))) ; հ�ް���͕i��
      ; 03/06/19 YM ADD-S
      (setq #userHINMEI (nth 2 #ret$)) ; հ�ް���͕i��
      (setq #userBIKOU  (nth 3 #ret$)) ; հ�ް���͔��l
      ; 03/06/19 YM ADD-E

      ;;; �_�C�A���O����l�����ꂽ���X�g������L���r�g���f�[�^�Ɋi�[
      (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))
      (CFSetXData #sym "G_TOKU"
        (list
          #userHINBAN   ; հ�ް���͕i��
          (nth 1 #ret$) ; ���i
          (list (nth 0 #DLOG$)(nth 1 #DLOG$)(nth 2 #DLOG$))
    ;;;          (strcat (itoa (car #DLOG$)) "X" (itoa (cadr #DLOG$)) "X" (itoa (caddr #DLOG$)))
          1 ; 1:�������޺���� 0:��АL�k
          CG_TOKU_BW ; W ��ڰ�ײ݈ʒu
          CG_TOKU_BD ; D ��ڰ�ײ݈ʒu
          CG_TOKU_BH ; H ��ڰ�ײ݈ʒu
          #HINBAN    ; �i��
          ; 03/06/19 YM ADD-S �i�ԁA���i�ɉ����ĕi���Ɣ��l���ێ�����
          #userHINMEI   ; �i��(���ϖ���,�d�l�\�ł́u���́v)
          #userBIKOU    ; ���l(���ϖ��ׂł́u���l�v,�d�l�\�ł́u�d�l�v)
          ; 03/06/19 YM ADD-E
        )
      )
    )
  );_if
  (princ)
); PcStretchCab

;<HOM>*************************************************************************
; <�֐���>    : PcGetStretchCabInfoDlg
; <�����T�v>  : �L�k�L���r�l�b�g�̃T�C�Y�Ɗg���f�[�^���e�l��
; <�߂�l>    : ���ʃ��X�g
; <�쐬>      : 00/04/11 MH
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun  PcGetStretchCabInfoDlg (
  &Defo$
  /
  #dcl_id #iW #iD #iH #iBW #iBD #iBH
  #RES$
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���p���l���ǂ���
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CHK_edit (
    &sKEY ; key
    &DEF  ; ��̫�Ēl
    &flg  ; �����׸� 0:���p���l , 1:���p���l>0 , 2:nil�łȂ�������
    /
    #val
    )
    (setq #val (read (get_tile &sKEY)))
    (cond
      ((and (= &flg 2)(= #val nil))
        (alert "���������͂��ĉ������B")
        (set_tile &sKEY &DEF)
        (mode_tile &sKEY 2)
      )
      ((= &flg 0)
        (if (or (= (type #val) 'INT)
                (= (type #val) 'REAL))
          (princ) ; ���p����������
          (progn
            (alert "���p�����l����͂��ĉ������B")
            (set_tile &sKEY &DEF)
            (mode_tile &sKEY 2)
          )
        );_if
      )
      ((= &flg 1)
        (if (and (or (= (type #val) 'INT)
                     (= (type #val) 'REAL))
                 (> #val 0.001)) ; �X�ɐ����ǂ������ׂ�(0�͕s��)
          (princ) ; OK
          (progn
            (alert "0���傫�Ȕ��p�����l����͂��ĉ������B")
            (set_tile &sKEY &DEF)
            (mode_tile &sKEY 2)
          )
        );_if
      )
    );_cond
    (princ)
  );##CHK_edit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ##GetDlgItem (
  / ; �޲�۸ނ̌��ʂ��擾����
  #RES$
)
  (setq #RES$ (list
    (atoi (get_tile "W"))
    (atoi (get_tile "D"))
    (atoi (get_tile "H"))
    (atoi (get_tile "BW"))
    (atoi (get_tile "BD"))
    (atoi (get_tile "BH")))
  )
  (done_dialog)
  #RES$
);##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; �f�t�HWDH
  (setq #iW  (fix (nth 0 &Defo$)))
  (setq #iD  (fix (nth 1 &Defo$)))
  (setq #iH  (fix (nth 2 &Defo$)))
  (setq #iBW (fix (* #iW 0.5)))
  (setq #iBD (fix (* #iD 0.5)))
  (setq #iBH (fix (* #iH 0.5)))

  ;;; �_�C�A���O�̎��s��
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (not (new_dialog "GetStretchCabInfoDlg" #dcl_id)) (exit))

  ;;; �f�t�H������̐ݒ�
  (set_tile "Msg1" "   �ΏۃL���r�l�b�g �̃T�C�Y��")
  (set_tile "Msg2" (strcat "   ���� ��= " (itoa #iW) ", ���s= " (itoa #iD) ", ����= " (itoa #iH) " �ł�"))
  (set_tile "W"  (itoa #iW))
  (set_tile "D"  (itoa #iD))
  (set_tile "H"  (itoa #iH))
  (set_tile "BW" (itoa #iBW))
  (set_tile "BD" (itoa #iBD))
  (set_tile "BH" (itoa #iBH))

  ;;; �^�C���̃��A�N�V�����ݒ� ���p����������
  (action_tile "W"  "(##CHK_edit \"W\"  (itoa #iW ) 1)")
  (action_tile "D"  "(##CHK_edit \"D\"  (itoa #iD ) 1)")
  (action_tile "H"  "(##CHK_edit \"H\"  (itoa #iH ) 1)")
  (action_tile "BW" "(##CHK_edit \"BW\" (itoa #iBW) 0)")
  (action_tile "BD" "(##CHK_edit \"BD\" (itoa #iBD) 0)")
  (action_tile "BH" "(##CHK_edit \"BH\" (itoa #iBH) 0)")

  (action_tile "accept" "(setq #RES$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #RES$ nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #RES$
);PcGetStretchCabInfoDlg

;<HOM>*************************************************************************
; <�֐���>    : ShowTOKUCAB_Dlog
; <�����T�v>  : �������޺���މ��i,�i�Ԋm�F�޲�۸�
; <�߂�l>    : ���i,�i��
; <�쐬>      : 01/01/29 YM
; <���l>      :
; ***********************************************************************************>MOH<
(defun ShowTOKUCAB_Dlog (
  &HINBAN
  &PRICE ; ���i��̫�Ēl
  &WDH
  &ORG_price ; ���̉��i
  &sHINMEI ; �i�� 01/08/20 YM ADD
  &sBIKOU  ; ���l 01/08/20 YM ADD
  /
  #RESULT$ #SDCLID
  )
;;;02/01/21YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;02/01/21YM@DEL; ���p���l���ǂ���
;;;02/01/21YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;02/01/21YM@DEL  (defun ##CHK_edit (
;;;02/01/21YM@DEL   &sKEY ; key
;;;02/01/21YM@DEL   &DEF  ; ��̫�Ēl
;;;02/01/21YM@DEL   &flg  ; �����׸� 0:���p���l , 1:���p���l>0 , 2:nil�łȂ�������
;;;02/01/21YM@DEL   /
;;;02/01/21YM@DEL   #val
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL   (setq #val (read (get_tile &sKEY)))
;;;02/01/21YM@DEL   (cond
;;;02/01/21YM@DEL     ((and (= &flg 2)(= #val nil))
;;;02/01/21YM@DEL        (alert "���������͂��ĉ������B")
;;;02/01/21YM@DEL        (set_tile &sKEY &DEF)
;;;02/01/21YM@DEL        (mode_tile &sKEY 2)
;;;02/01/21YM@DEL     )
;;;02/01/21YM@DEL     ((= &flg 0)
;;;02/01/21YM@DEL       (if (or (= (type #val) 'INT)
;;;02/01/21YM@DEL               (= (type #val) 'REAL))
;;;02/01/21YM@DEL         (princ) ; ���p����������
;;;02/01/21YM@DEL         (progn
;;;02/01/21YM@DEL           (alert "���p�����l����͂��ĉ������B")
;;;02/01/21YM@DEL           (set_tile &sKEY &DEF)
;;;02/01/21YM@DEL           (mode_tile &sKEY 2)
;;;02/01/21YM@DEL         )
;;;02/01/21YM@DEL       );_if
;;;02/01/21YM@DEL     )
;;;02/01/21YM@DEL     ((= &flg 1)
;;;02/01/21YM@DEL       (if (and (= (type #val) 'INT)
;;;02/01/21YM@DEL                (> #val -0.001)) ; �X�ɐ����ǂ������ׂ�(0�͕s��) ; 02/01/21 YM MOD 0�~���\��
;;;02/01/21YM@DEL;;;02/01/21YM@DEL                 (> #val 0.001)) ; �X�ɐ����ǂ������ׂ�(0�͕s��)
;;;02/01/21YM@DEL         (progn ; 02/01/21 YM ADD
;;;02/01/21YM@DEL           (if (equal 0.0 #val 0.0001)
;;;02/01/21YM@DEL             (progn
;;;02/01/21YM@DEL               (if (CFYesNoDialog "0�~�ł���낵���ł����H") ; 0�~�̂Ƃ�
;;;02/01/21YM@DEL                 nil ; OK
;;;02/01/21YM@DEL                 (progn
;;;02/01/21YM@DEL                   (set_tile &sKEY &DEF)
;;;02/01/21YM@DEL                   (mode_tile &sKEY 2)
;;;02/01/21YM@DEL                 )
;;;02/01/21YM@DEL               );_if
;;;02/01/21YM@DEL             )
;;;02/01/21YM@DEL           );_if
;;;02/01/21YM@DEL         ) ; 02/01/21 YM ADD
;;;02/01/21YM@DEL         (progn
;;;02/01/21YM@DEL;;;02/01/21YM@DEL            (alert "0���傫�Ȕ��p�����l����͂��ĉ������B")
;;;02/01/21YM@DEL           (alert "0�ȏ�̔��p�����l����͂��ĉ������B") ; 02/01/21 YM MOD 0�~���\��
;;;02/01/21YM@DEL           (set_tile &sKEY &DEF)
;;;02/01/21YM@DEL           (mode_tile &sKEY 2)
;;;02/01/21YM@DEL         )
;;;02/01/21YM@DEL       );_if
;;;02/01/21YM@DEL     )
;;;02/01/21YM@DEL    );_cond
;;;02/01/21YM@DEL   (princ)
;;;02/01/21YM@DEL  );##CHK_edit
;;;02/01/21YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;02/01/21YM@DEL   (defun ##GetDlgItem (
;;;02/01/21YM@DEL     / ; �޲�۸ނ̌��ʂ��擾����
;;;02/01/21YM@DEL     #RES$
;;;02/01/21YM@DEL     )
;;;02/01/21YM@DEL     (setq #RES$
;;;02/01/21YM@DEL       (list
;;;02/01/21YM@DEL         (get_tile "edtTOKU_ID")         ; �i��
;;;02/01/21YM@DEL         (atof (get_tile "edtTOKU_PRI")) ; ���i 01/03/01 YM �����ɂ���(����16bit)
;;;02/01/21YM@DEL         &WDH ; W,D,H
;;;02/01/21YM@DEL       )
;;;02/01/21YM@DEL     )
;;;02/01/21YM@DEL     (done_dialog)
;;;02/01/21YM@DEL     #RES$
;;;02/01/21YM@DEL   );##GetDlgItem
;;;02/01/21YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckNum (&sKEY / #val #ret)
    (setq #ret nil)
    (setq #val (read (get_tile &sKEY)))
    (if (= (type (read (get_tile &sKEY))) 'INT)
      (if (< #val -0.00001) ; ����
        (progn
          (alert "0�ȏ�̐����l����͂��ĉ�����")
          (set_tile &sKEY "")
          (mode_tile &sKEY 2)
        )
;;;02/01/21YM@DEL       (setq #ret T)
        ; 02/01/21 YM ADD-S
        (progn
          (if (equal 0.0 #val 0.00001) ; 0�~�̂Ƃ�
            (if (CFYesNoDialog "0�~�ł���낵���ł����H") ; 0�~�̂Ƃ�
              (setq #ret T)
              (mode_tile &sKEY 2)
            );_if
            (setq #ret T)
          );_if
        )
        ; 02/01/21 YM ADD-E
      );_if
      (progn ; �����ȊO
        (alert "0�ȏ�̐����l����͂��ĉ�����")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckStr (&sKEY / #ret)

;;;02/02/19YM@DEL    (setq #ret nil)
;;;02/02/19YM@DEL    (if (= (type (read (get_tile &sKEY))) 'SYM)
;;;02/02/19YM@DEL     (progn

;;;02/01/21YM@DEL       (if (= (get_tile &sKEY) &HINBAN)
;;;02/01/21YM@DEL         (progn
;;;02/01/21YM@DEL           (alert "�����i�Ԃ���͂��ĉ�����")
;;;02/01/21YM@DEL           (mode_tile &sKEY 2)
;;;02/01/21YM@DEL         )
          (setq #ret T)
;;;02/01/21YM@DEL       );_if

;;;02/02/19YM@DEL     )
;;;02/02/19YM@DEL     (progn
;;;02/02/19YM@DEL        (alert "���������͂��ĉ�����")
;;;02/02/19YM@DEL        (set_tile &sKEY "")
;;;02/02/19YM@DEL        (mode_tile &sKEY 2)
;;;02/02/19YM@DEL     )
;;;02/02/19YM@DEL    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; �S���ڃ`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (defun ##Check&GetAllVal ( / #DLG$)
    (cond
      ((not (##CheckNum "edtTOKU_PRI"))  nil) ; ���ڂɴװ�������nil��Ԃ�
      ((not (##CheckStr "edtTOKU_ID")) nil) ; ���ڂɴװ�������nil��Ԃ�
      (T ; ���ڂɴװ�Ȃ�
        (setq #DLG$
          (list
            (get_tile "edtTOKU_ID")         ; �i��
            (atof (get_tile "edtTOKU_PRI")) ; ���i 01/03/01 YM �����ɂ���(����16bit)
            ; 03/06/19 YM ADD-S
            (get_tile "edtHINMEI")  ; �i��
            (get_tile "edtBIKOU")   ; ���l
            ; 03/06/19 YM ADD-E
          )
        )
        (done_dialog)
        #DLG$
      )
    );_cond

  ); end of ##Check&GetAllVal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; �S���ڃ`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (defun ##Exit ( / )
    (done_dialog)
    nil
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;; �_�C�A���O�̎��s��
  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  ;03/06/19 YM ADD �i���A���l���ҏW�\��
;;;  (if (= nil (new_dialog "ShowTOKUCABDlg" #sDCLID)) (exit))
  (if (= nil (new_dialog "ShowTOKUCABDlg_N" #sDCLID)) (exit))

  ; �����l�̐ݒ� ; txtORG_PRICE
  (set_tile "edtTOKU_ID" &HINBAN)
  (set_tile "edtTOKU_PRI" &PRICE)
  (set_tile "txtORG_PRICE" (strcat "�@���̉��i�F " &ORG_price "�~"))
  ;03/06/19 YM MOD-S �i���A���l���ҏW�\��
;;;  (set_tile "txtHINMEI"    (strcat "�@�i�@���@�@�F " &sHINMEI)) ; �i�� 01/08/20 YM ADD
;;;  (set_tile "txtBIKOU"     (strcat "�@���@�l�@�@�F " &sBIKOU))  ; ���l 01/08/20 YM ADD
  (set_tile "edtHINMEI" &sHINMEI) ; �i��
  (set_tile "edtBIKOU"  &sBIKOU)  ; ���l
  ;03/06/19 YM MOD-E

  (mode_tile "edtTOKU_PRI" 2)
;;;  (set_tile "edtTOKU_W" (nth 0 &WDH))
;;;  (set_tile "edtTOKU_D" (nth 1 &WDH))
;;;  (set_tile "edtTOKU_H" (nth 2 &WDH))

  ;;; �^�C���̃��A�N�V�����ݒ�
;;;02/01/21YM@DEL  (action_tile "edtTOKU_ID"  "(##CHK_edit \"edtTOKU_ID\"  &HINBAN 2)")
;;;02/01/21YM@DEL  (action_tile "edtTOKU_PRI" "(##CHK_edit \"edtTOKU_PRI\" &PRICE  1)")
;;;02/01/21YM@DEL  (action_tile "accept" "(setq #RES$ (##GetDlgItem))")

  ; OK�{�^���������ꂽ��S���ڂ��`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B02/01/21 YM MOD
  (action_tile "accept" "(setq #RESULT$ (##Check&GetAllVal))")
  (action_tile "cancel" "(setq #RESULT$ (##Exit))") ; cancel

  (start_dialog)
  (unload_dialog #sDCLID)
  ; ���X�g��Ԃ�
  #RESULT$
);ShowTOKUCAB_Dlog

;<HOM>*************************************************************************
; <�֐���>    : C:CabSubtractKutai
; <�����T�v>  : �L���r�؂茇���R�}���h
; <�߂�l>    : �Ȃ�
; <�쐬>      : A.Satoh
; <���l>      : 
;*************************************************************************>MOH<
(defun C:CabSubtractKutai (
  /
  #hndB #hnd #sym_lis$ #cab_lis$ #en #ss #idx
  #sym #ku_en #kutai_Lis$ #cab_en #kutai
  )

;**********************************
    ;; �G���[����
    (defun CabSubtractKutaiErr (msg)
      (command "_.UNDO" "B")
      (setq *error* nil)
      (princ)
    )
;**********************************

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:CabSubtractKutai ////")
  (CFOutStateLog 1 1 " ")

  (setq *error* CabSubtractKutaiErr)
  (command "_.UNDO" "M")
  (command "_.UNDO" "A" "OFF")

  ; �L���r�l�b�g�I��
  (setq #hndB (car (CFGetXRecord "BASESYM"))) ; �����
  (setq #sym_lis$ nil)
  (setq #cab_lis$ nil)
  (setq #en T)
  (while #en
    (initget "U")
    (setq #en (entsel "\n���ނ�I�����Ă�������: "))
    (cond
      ((= #en "U")
        ;;; ����тȂ��
        (if (> (length #sym_lis$) 0)
          (progn
            (setq #hnd (cdr (assoc 5 (entget (car #sym_lis$)))))
            (if (equal #hnd #hndB)
              (GroupInSolidChgCol (car #sym_lis$) CG_BaseSymCol) ; ��
              (GroupInSolidChgCol2 (car #sym_lis$) "BYLAYER")    ; �F��߂�
            )
            ; ���X�g���璼�O�̂��̂��폜
            (setq #sym_lis$ (cdr #sym_lis$))
          )
        )
      )
      ((= #en nil)
        (if (= (length #sym_lis$) 0)
          (progn
            (CFAlertErr "���ނ��I������Ă��܂���")
            (setq #en T)
          )
        )
      )
      (T
        (setq #sym (CFSearchGroupSym (car #en)))
        (if (= #sym nil)
          (CFAlertMsg "���ނ��I������Ă��܂���")
          (if (= (CFGetXData #sym "G_LSYM") nil)
            (CFAlertMsg "���ނ��I������Ă��܂���")
            (progn
              (GroupInSolidChgCol2 #sym CG_InfoSymCol)
              (setq #sym_lis$ (cons #sym #sym_lis$))

              ; �V���{���}�`�Ɠ���O���[�v�����o�[�}�`�����o��
              (setq #ss (CFGetSameGroupSS #sym))
              (setq #idx 0)
              (repeat (sslength #ss)
                (setq #cab_en (ssname #ss #idx))
                (if (= (cdr (assoc 0 (entget #cab_en))) "3DSOLID")
                  (setq #cab_lis$ (cons #cab_en #cab_lis$))
                )
                (setq #idx (1+ #idx))
              )
            )
          )
        )
      )
    )
  )

  ; �؂茇����̂�I��
  (setq #en T)
  (setq #kutai_lis$ nil)
  (while #en
    (setq #en (car (entsel "\n�؂茇����̂�I�����Ă�������: ")))
    (if (= #en nil)
      (progn
        (CFAlertErr "��̂��I������Ă��܂���")
        (setq #en T)
      )
      (progn
        ; �e�V���{���̎擾
        (setq #sym (SearchGroupSym #en))
        (if (= #sym nil)
          (CFAlertMsg "��̂��I������Ă��܂���")
          ; ���i�R�[�h�`�F�b�N
          (if (/= (nth 9 (CFGetXData #sym "G_LSYM")) 999)
            (CFAlertMsg "��̂ł͂���܂���")
            (progn
              (setq #ss (CFGetSameGroupSS #sym))
              (setq #idx 0)
              (repeat (sslength #ss)
                (setq #ku_en (ssname #ss #idx))
                (if (= (cdr (assoc 0 (entget #ku_en))) "3DSOLID")
                  (setq #kutai_lis$ (cons #ku_en #kutai_lis$))
                )
                (setq #idx (1+ #idx))
              )
              (setq #ku_en (car #kutai_lis$))
              (setq #en nil)
            )
          )
        )
      )
    )
  )

  ; �L���r�؂茇���������s��
  (foreach #cab_en #cab_lis$
    (command "._COPY" #ku_en "" "0,0,0" "0,0,0")
    (setq #kutai (entlast))
    (command "_.SUBTRACT" #cab_en "" #kutai "")
    (command "_REGEN")
  )

  ; �L���r�l�b�g�̐F�����ɖ߂�
  (foreach #en #sym_lis$
    ;;; ����тȂ��
    (setq #hnd (cdr (assoc 5 (entget #en))))
    (if (equal #hnd #hndB)
      (GroupInSolidChgCol #en CG_BaseSymCol) ; ��
      (GroupInSolidChgCol2 #en "BYLAYER") ; �F��߂�
    )
  )

  (setq *error* nil)

; (alert "�������@�H�����@������")
;
  (princ)
);C:CabSubtractKutai

; 2017/11/13 KY ADD-S
; �t���[���L�b�`�� �W���J�E���^�[�Ή�
;<HOM>*************************************************************************
; <�֐���>    : IsFKLWCounter
; <�����T�v>  : �i�Ԃ��W���J�E���^�[���ǂ���
; <�߂�l>    : T=�W���J�E���^�[ / nil=��
; <�쐬>      : KY
; <���l>      : 
;*************************************************************************>MOH<
(defun IsFKLWCounter (
	&hinban
	/
	#ret
	#qry$
	)

	(setq #ret nil)
	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn
			(setq #qry$ (CFGetDBSQLRec CG_DBSESSION "�W���J�E���^"
								(list (list "�i�Ԗ���" &hinban 'STR))))
			(if (and #qry$ (= (length #qry$) 1))
				(setq #ret T)
			);if
		);progn
	);if

	#ret
)
; 2017/11/13 KY ADD-E

(princ)