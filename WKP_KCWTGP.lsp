;<�֐������p>
;;;(defun GetMelamineWT   ����ܰ�į�߂̏����擾
;;;(defun PKGetMelamineWT_Outline   �`\tmp\temp[&no].dwg �Ƃ��ĕۑ�
;;;(defun C:PKShowWTinGroundPlan ( WT,BG�O�`���@,�����,�i��,���i,���ފ��t��`���R�}���h
;;;(defun PKGetWT (                WT���w��
;;;(defun PKSetSYS ( / )           ���ѕϐ��̐ݒ�
;;;(defun GetANAdimGAS-SNK$ (      WT���@���A��ۑ��A�ݸ���ɕ�����
;;;(defun GetANAcabGAS-SNK$ (      ���ސ��@W���A��ۑ��A�ݸ���ɕ�����
;;;(defun PKListToA_CabW (         ���ސ��@W����𕶎���ɂ��� (150 300) ==>"(150) (300)"
;;;(defun PKDimWrite (             WT���@�L��
;;;(defun PKCabWrite (             WT�����ސ��@�v�L��
;;;(defun PK_BG_DimWrite (         BG���@�L��
;;;(defun PKITOAPRICE (            ���i�𕶎���ɂ��� 1234000==>"1,234,000�~"
;;;(defun PKWTGroundPlanWAKU (     �g������
;;;(defun PKGetWT-ANA_Outline (    WT�}�`����n����WT�O�`+�ݸ,��ی��}�`��ۯ���
;;;(defun PKGetBG_Outline (        WT�}�`����n����WT�O�`+�ݸ,��ی��}�`��ۯ����`\tmp\temp[&no].dwg �Ƃ��ĕۑ�
;;;(defun XminYmax (               �_�񂩂� �߲�č��W(Xmin,Ymax)��Ԃ�

(defun c:ttt()
	(StartUndoErr);����ނ̏�����
	(command "vpoint" "0,0,1") ; ===>�^�ォ��̊O�`,�� ���Ƃ�Ȃ�����
	(GetMelamineWT)
)

(defun C:WTLayout ;00/08/03 SN MOD ����
	(
	/
	#sFName #sMdlName
	#iOk
	)

	(StartUndoErr);����ނ̏�����
  ;// �w�b�_�[��񏑂��o�� 00/09/19 YM ADD
  (SKB_WriteHeadList)

	(setq #sMdlName (strcat (getvar "dwgprefix") (getvar "dwgname")));���Đ}�ʖ����L��
	(setq #iOk (CFYesNoDialog "�}�ʂ���x�ۑ����܂����H"))
	(if (= T #iOk)
		(command "_.save" #sMdlName)
	)
	(setq #sFName (getfiled "���[�N�g�b�v�}��" (strcat CG_KENMEI_PATH "OUTPUT\\") "dwg" 3))
	(if (/= nil #sFName)(progn
		(C:PKShowWTinGroundPlan)
		(command "_.save" #sFName)
		(if (/= (getvar "DBMOD") 0)
			(command "_.open" "y" #sMdlName)
			(command "_.open" #sMdlName)
		);END IF
	));END IF-PROGN
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetMelamineWT
;;; <�����T�v>  : ����ܰ�į�߂̏����擾
;;;               �`\tmp\temp[&no].dwg �Ƃ��ĕۑ�
;;; <�߂�l>    : 
;;;               ((��޼ު��ID
;;;                 ����ܰ�į�ߕi�Ԗ���
;;;                 (����ܰ�į�ߊ�_)
;;;                 (��ؽ�)��ܰ�į�߂̺��&�ݸ���̏�ԂƓ��ް�
;;;                 (���s��ؽ�)
;;;                 (���̷���ȯĕ�)������LIST
;;;                 ����ܰ�į�ߕ�
;;;                 ����ܰ�į�߉��s��
;;;                 ����ܰ�į�ߍ���
;;;                 ����ܰ�į�ߊp�x
;;;                 ����ܰ�į�߉��i
;;;               ))
;;; <�쐬>      : 2000.8.04 SN
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun GetMelamineWT(
    /
    ;
    #pdsize
    ;�}�ʂ�������ܰ�į�߂�T��
    #ssLSYM #iI #xdLSYM #mWT$ #mWTdata$$
    ;����ܰ�į�ߗ̈�̷���ȯĕ����擾
    ;#ssLSYM #xdLSYM #iI
    #mWT #xdSYM #mCabDim$
    #pBasePt #rAng #rW #rD #rH #pOppPt #sHinban
    #fig$ #MCAB$
    )

    ;���ϐ�������
    (setq #pdsize (getvar "PDSIZE"))
    (setvar "PDSIZE" 1)

    ;�ϐ�������
    (setq #iI 0)
    (setq #mWT$ '())

    ;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;�}�ʂ�������ܰ�į�߂�T��
    ;;;;;;;;;;;;;;;;;;;;;;;;;;
    (setq #ssLSYM (ssget "X" '((-3 ("G_LSYM")))));G_LSYM���т����W
    (if #ssLSYM
      (repeat (sslength #ssLSYM)
        (if (setq #xdLSYM (CFGetXData (ssname #ssLSYM #iI) "G_LSYM"))
          (if (= (nth 9 #xdLSYM) 710);���i���ނŔ��f
          ;(if (wcmatch (nth 5 #xdLSYM) "KS-M*");�i�Ԗ��̂Ŕ��f
              (setq #mWT$ (append (list (ssname #ssLSYM #iI))))
          );end if
        );end if
        (setq #iI (1+ #iI))
      );end repeat
    );end if

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;����ܰ�į�ߊ֘A���̎��W
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (setq #mWTdata$$ '())
    (foreach #mWT #mWT$
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;����ܰ�į�ߗ̈�̷���ȯĕ����擾
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (setq #pBasePt (cdr (assoc 10 (entget #mWT))));��_���擾
      (if (setq #xdLSYM (CFGetXData #mWT "G_LSYM"))(progn
        (setq #rAng    (nth 2 #xdLSYM));��]�p�x
        (setq #sHinban (nth 5 #xdLSYM));�i�Ԗ���
      ));end if-progn
      (if (setq #xdSYM (CFGetXData #mWT "G_SYM"))(progn
        (setq #rW (nth 3 #xdSYM));�W
        (setq #rD (nth 4 #xdSYM));�D
        (setq #rH (nth 5 #xdSYM));�H
      ));end if-progn
      ;�Ίp�̓_�����߂�
      (setq #pOppPt (polar (polar #pBasePt #rAng #rW) (- #rAng (* 0.5 pi)) #rD))
      ;�ڂ��鷬��ȯĂ�Ă��Ă��܂��ׁA�_�����������Ɋ񂹂�B
      (setq #pOppPt  (polar #pOppPt  #rAng -5))
      ;����ܰ�į�ߗ̈�
      (setq #ssLSYM (ssget "C" #pBasePt #pOppPt '((-3 ("G_LSYM")))))
;(command "line" #pBasePt #pOppPt "");DEBUG
      ;�I��ē����۱�ݒu���т��擾
;(princ "�I��Ă�");debug
;(princ (sslength #ssLSYM));debug
;(princ "�̃A�C�e�����Z�b�g����܂����B\n" );debug
      (setq #iI 0)
      (setq #mCab$ '())
      (if #ssLSYM
        (repeat (sslength #ssLSYM)
          (if (setq #xdSYM (CFGetXData (ssname #ssLSYM #iI) "G_SYM"))
            ;����0�ݒu���т���ȯĂƂ���B
            (if (equal (nth 6 #xdSYM) 0 0.0001)(progn
              (setq #mCabDim$ (append #mCabDim$ (list (nth 3 #xdSYM))))
;(GroupInSolidChgCol2 (ssname #ssLSYM #iI) CG_InfoSymCol);debug
            ));end if
          );end if
          (setq #iI (1+ #iI))
        );end repeat
      );end if
;(princ "�����~�����̃L���r�l�b�g��");debug
;(princ (length #mCabDim$));debug
;(princ "�ł��B\n");debug
      ;D/B�i�Ԋ�{ð��ق�������ܰ�į�߂̏����擾
      (setq
        #fig$
        (CFGetDBSQLHinbanTableChk
          "�i�Ԋ�{"
          #sHinban
          (list (list "�i�Ԗ���" #sHinban 'STR))
        )
      )
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;����ܰ�į�߂̏��ؽĂ��쐬
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (setq #mWTdata$$ (append #mWTdata$$ 
        (list (list
          #mWT                            ;Entity
          #sHinban                        ;����ܰ�į�ߕi�Ԗ���
          #pBasePt                        ;����ܰ�į�ߊ�_
          (list #rW #rW "" "" "" "" "" "");��ؽā�ܰ�į�߂̺��&�ݸ���̏��
          (list #rD 0.0 0.0)              ;���s��ؽ�
          #mCabDim$                       ;���̷���ȯĕ�(����LIST)
          #rW                             ;����ܰ�į�ߕ�
          #rD                             ;����ܰ�į�߉��s��
          #rH                             ;����ܰ�į�ߍ���
          #rAng                           ;����ܰ�į�ߊp�x
          (if #fig$ (nth 14 #fig$) 0)     ;���i
        ))
      ))
    );end repeat

    (setvar "PDSIZE" #pdsize)

    #mWTdata$$
);GetMelamineWT

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetMelamineWT_Outline
;;; <�����T�v>  : 
;;;               �`\tmp\temp[&no].dwg �Ƃ��ĕۑ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.8.04 SN
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PKGetMelamineWT_Outline (
	&WT     ; WT�}�`��
	&no     ; �ŉE�v�s����̔ԍ� 0,1,2...
	&mWT$
  /
	#ANG #BASEWT #EGAS_P5$ #ESNK_P$ #ESNK_P1$ #ESNK_P4$ #GAS$$ 
	#P1 #P2 #P3 #PT$ #RET$ #SNK$$ #SS #TEIWT #XDWT$ #ZAI
	#lent #gent #nent #olayer #nlayer #dmyWT #MWT$
  #iFILEDIA   ; �V�X�e���ϐ� 01/11/22 HN ADD
  )
	(setq #teiWT nil)
	(setq #dmyWT nil)
	(setq #ss (ssadd))
	(setq #baseWT (nth 2 #mWT$));��_���擾
	(setq #xdWT$ (CFGetXData &WT "G_PMEN"))
	(if #xdWT$
		;G_PMEN����������ײݏ����擾 �Ȃ������а���쐬
		(setq #teiWT (nth 0 #xdWT$))   ;WT���ײ�
		(progn ; ELSE
			;��а���ײ݂̍��W�쐬
			;6=W 7=D 8=H 9=ANG
			(setq #p1 (polar #baseWT (nth 9 &mWT$) (nth 6 &mWT$)))
			(setq #p2 (polar #p1 (- (nth 9 &mWT$) (* pi 0.5)) (nth 7 &mWT$)))
			(setq #p3 (polar #p2 (nth 9 &mWT$) (* -1 (nth 6 &mWT$))))
			(setq #lent (entlast));���݂̍ŏIEntity�擾
			(command "_.pline" #baseWT #p1 #p2 #p3 "C")
			(setq #dmyWT (entlast));��а���ײ݂�Entity�擾
			;��а���ײݍ쐬������Ȃ�teiWT�ɑ��
			(if (not (equal #lent #dmyWT))
				(setq #teiWT #dmyWT)
			)
		)
	);end if
;???	(setq #zai (substr (nth 2 #xdWT$) 1 1)) ; �ގ�

	(if #teiWT (progn
		;��а���ײ݂��쐬���Ă������w��ς���
		(if #dmyWT (progn
			(setq #gent (entget #teiWT))              ;Entity���
			(setq #olayer (assoc 8 #gent))            ;��w���擾
			(setq #nlayer (cons 8 SKW_AUTO_SECTION))  ;�z�u��w��
			(setq #nent (subst #nlayer #olayer #gent));��w��u��������
			(entmod #nent)                            ;Entyty�X�V
		));end if - progn

		(ssadd #teiWT #ss)
		;;; UCS��`
		(setq #pt$ (GetLWPolyLinePt #teiWT))    ; WT�O�`�_��
		(setq #pt$ (GetPtSeries #baseWT #pt$))  ; #BASEPT ��擪�Ɏ��v����
		(setq #p1 (nth 0 #pt$))
		(setq #p2 (nth 1 #pt$))
		(setq #ang (angle #p1 #p2))
		(setq #p3 (polar #p1 (+ #ang (dtr 90)) 500))
		(command "._ucs" "3" #p1 #p2 #p3)
		(setq #baseWT (trans #baseWT 0 1))      ; հ�ް���W�n�ɕϊ�

		;;; ��ۯ��ۑ�
		(setq #iFILEDIA (getvar "FILEDIA")) ; 01/11/22 HN ADD
		(setvar "FILEDIA" 0)
		(command "._wblock" (strcat CG_SYSPATH "tmp\\tempWT" &no ".dwg") "" #baseWT #ss "")
		(command "._oops") ; �}�`����
		(command "._ucs" "P")
		(if #dmyWT (entdel #teiWT));��а���ײݍ폜
		(setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD
	));end if - progn
	(princ)
);PKGetMelamineWT_Outline

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:PKShowWTinGroundPlan
;;; <�����T�v>  : WT,BG�O�`���@,�����,�i��,���i,���ފ��t��`���R�}���h
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.20 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun C:PKShowWTinGroundPlan (
  /
	#BLPT #FLG #HINBAN #HINBAN$ #I #INSPT #NO #PRICE #PRICE$ #TYPE 
	#WT #WT$ #WTMR #XDWT$ #XDWTSET$ #DIM$ #IPT #K #Y #DIM$$ #DEP$$
	#CABW #CABW$ #CABW$$ #XDWTCT$
	#BG$ #BG1 #BG2 #BGTEI #BG_HIN #BG_HIN$ #BG_LEN$ #BG_PRI #BG_PRI$ #XDBG$
	#mWTdata$$ #mWT$
	#title$ #title1 #title2 #title3 #STRANG #STRH #STRPT
  )
	;;; 00/09/19 YM MOVE
	(setq #title$ (SCFGetTitleStr))
	(setq #title1 (strcat "�y���[�N�g�b�v��o�b�N�K�[�h�z�@" (nth 5 #title$)))
	(setq #title2 (strcat "�Ǘ��R�[�h�F" (nth 2 #title$)))
	(setq #title3 (nth 9 #title$))

  ;;; �R�}���h�̏�����
;	(StartUndoErr);00/08/03 SN MOD ����ނ̏������͏�ʂōs��
	;;; WT���w��
	(setq #WT (PKGetWT))
	(command "vpoint" "0,0,1") ; ===>�^�ォ��̊O�`,�� ���Ƃ�Ȃ�����
	;;; �ŉEWT���擾
	(setq #WTMR (car (PKGetMostRightWT #WT)))
	(setq #WT$ (PKGetWT$FromMRWT #WTMR))    ; ��ԉEWT==>�E���珇�̊֘AWTؽĂ�Ԃ�
	(setq #xdWT$ (CFGetXData (car #WT$) "G_WRKT"))
	(setq #ZaiCode (nth 2 #xdWT$))
	(setq #ZaiF (KCGetZaiF #ZaiCode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ
	(setq #type (nth 3 #xdWT$))       ; L:�`������1
	(setq #flg nil)
	(if (and (not (equal (KPGetSinaType) -1 0.1))(= #ZaiF 1)(= #type 1))
		(setq #flg "SL") ; ���ڽL�^
	);_if
	;;; ��w�����ׂ��ذ�މ��� ===>�����Ƃ�Ȃ�����
	(command "_layer" "T" "*" "")
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;; WT�i��,���i,���@����,����W�l������i�[���AWT���ʐ}��ۯ��쐬 ;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(setq #i 0 #dim$$ '() #dep$$ '() #cabW$$ '() #BG$ '())
	(foreach #WT #WT$ ; 1�̃v�����ŗאڂv�s�J��Ԃ�����
	  (if (setq #xdWTSET$ (CFGetXData #WT "G_WTSET"))
			(progn ; �i�Ԋm�肳��Ă���
				(setq #HINBAN$ (append #HINBAN$ (list (nth 1 #xdWTSET$)))) ; WT�i��
				(setq #PRICE$  (append #PRICE$  (list (nth 3 #xdWTSET$)))) ; WT���i
				; ���@������쐬
				(setq #k 6 #dim$ '())
				(repeat (nth 5 #xdWTSET$) ; �����@��
					(setq #dim$ (append #dim$ (list (nth #k #xdWTSET$))))
					(setq #k (1+ #k))
				)
				(setq #dim$$ (append #dim$$ (list #dim$))) ; ���@����
;;;				; ����W������쐬
;;;				(setq #xdWTCT$ (CFGetXData #WT "G_WTCT"))
;;;				(setq #k 10 #cabW$ '())
;;;				(repeat 14 
;;;					(setq #cabW (nth #k #xdWTCT$))
;;;					(if (/= #cabW "")
;;;						(setq #cabW$ (append #cabW$ (list #cabW)))
;;;					);_if
;;;					(setq #k (1+ #k))
;;;				)
;;;				(setq #cabW$$ (append #cabW$$ (list #cabW$))) ; ����W����
			)
			(progn ; �i�Ԋm�肳��Ă��Ȃ�
				(CFAlertMsg "���[�N�g�b�v�͕i�Ԋm�肳��Ă��܂���B")
				(quit)
			)
		)
		(setq #xdWT$ (CFGetXData #WT "G_WRKT"))
		(setq #BG1 (nth 49 #xdWT$))
		(if (/= #BG1 "")
			(if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
				(setq #BG$ (append #BG$ (list #BG1)))
			)
		)

		(setq #BG2 (nth 50 #xdWT$))
		(if (/= #BG2 "")
			(if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
				(setq #BG$ (append #BG$ (list #BG2)))
			)
		)

		(setq #dep$$ (append #dep$$ (list (nth 57 #xdWT$)))) ; ���s��
		(setq #no (itoa #i))
		(PKGetWT-ANA_Outline #WT #no) ; ��ۯ��� �`\tmp\tempWT[#i].dwg �Ƃ��ĕۑ�
		(setq #i (1+ #i))
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;; 00/08/04 SN ADD tempWT[#1]�̑���������ܰ�į�߂���ۯ����쐬
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(setq #mWTdata$$ (GetMelamineWT));����ܰ�į�ߊ֘A�����擾
	(foreach #mWT$ #mWTdata$$
		(setq #WT$     (append #WT$     (list (nth  0 #mWT$))))
		(setq #HINBAN$ (append #HINBAN$ (list (nth  1 #mWT$))))
		(setq #dim$$   (append #dim$$   (list (nth  3 #mWT$))))
		(setq #dep$$   (append #dep$$   (list (nth  4 #mWT$))))
		(setq #cabW$$  (append #cabW$$  (list (nth  5 #mWT$))))
		(setq #PRICE$  (append #PRICE$  (list (nth 10 #mWT$))))
		;���ײ݂���ۯ��ɏ����o��
		(setq #no (itoa #i))
		(PKGetMelamineWT_Outline (nth 0 #mWT$) #no #mWT$)
		(setq #i (1+ #i))
	)
	;00/08/04 SN E-ADD

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;; BG�i��,���i,���@������i�[���ABG���ʐ}��ۯ��쐬 ;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(setq #i 0)
	(foreach #BG #BG$ ; 1�̃v�����ŗאڂv�s�J��Ԃ�����
	  (if (setq #xdBG$ (CFGetXData #BG "G_BKGD"))
			(progn
				(setq #BGtei (nth 1 #xdBG$)) ; BG��ʐ}�`
				(setq #WT    (nth 2 #xdBG$)) ; �֘AWT
				(setq #BG_HIN$ (append #BG_HIN$  (list (nth 0 #xdBG$)))) ; BG�i��
				(setq #BG_LEN$ (append #BG_LEN$  (list (nth 3 #xdBG$)))) ; BG����
				(setq #BG_PRI$ (append #BG_PRI$  (list (nth 4 #xdBG$)))) ; BG���i
			)
	  )
		(setq #no (itoa #i))
		(PKGetBG_Outline #BGtei #WT #no) ; ��ۯ��� �`\tmp\tempBG[#i].dwg �Ƃ��ĕۑ�
		(setq #i (1+ #i))
	)

;;;03/09/29YM@MOD  ;// �\����w�̐ݒ�(�v�����������l�̉�w����)
;;;03/09/29YM@MOD  (command "_layer"
;;;03/09/29YM@MOD    "F"   "*"                ;�S�Ẳ�w���t���[�Y
;;;03/09/29YM@MOD    "T"   "Z_00*"            ;  Z_00���̃\���b�h��w�̃t���[�Y����
;;;03/09/29YM@MOD    "T"   "N_*"              ;  N_*�V���{�����_�}�`��w�̃t���[�Y����
;;;03/09/29YM@MOD    "T"   "M_*"              ;  M_*�ڒn�̈�}�`��w�̉���
;;;03/09/29YM@MOD    "T"   "0"                ;  "0"��w�̉���
;;;03/09/29YM@MOD    "ON"  "M_*"              ;  M_*�ڒn�̈�}�`��w�̕\��
;;;03/09/29YM@MOD    "OFF" "N_B*" ""          ;  N_B*�u���[�N���C���}�`�̔�\��
;;;03/09/29YM@MOD  )
	(SetLayer);03/09/29 YM MOD

	(command "zoom" "p")
  ;;; �����ۑ�
;;;  (CFAutoSave) ; --->�v�s���ʐ}�������Ȃ�
	;(command "_.save" (strcat (getvar "dwgprefix") (getvar "dwgname"))) 00/08/03 SN MOD �ۑ��͕ʌ��ōs��
	;;; �V�K�}�ʂ��J��
	(if (/= (getvar "DBMOD") 0)
		(progn
			;00/08/03 SN MOD �ۑ��͕ʓrհ�ގw���ɂ��s���Ă���̂ł����ł͋���NEW���s��
			(command "._new" "N" ".")
	   	;(command "_qsave")
	   	;(vl-cmdf "._new" ".")
		)
		(progn
		(vl-cmdf "._new" ".")
		)
	);_if

	;;;;;;;;;;;;;;;;;;;;;;;;
	;;; �V�K�}�ʍ�}�J�n ;;;
	;;;;;;;;;;;;;;;;;;;;;;;;
	(PKSetSYS) ; ���ѕϐ��̐ݒ�

	;;; WT ;;;
	(if (= #flg "SL")
		(setq #Y 5200 #iPT '(600  -900)) ; ���ڽ�k�^
		(setq #Y 3200 #iPT '(600 -1400)) ; ���ڽ�k�^�ȊO
	);_if

;;; ���ٗ� �i�ԋL��
	(setq #strH "120")
	(setq #strANG "0")
	(setq #strPT (list    0 200))
	(command "._TEXT" #strPT #strH #strANG #title1)
	(setq #strPT (list 8500 200))
	(command "._TEXT" #strPT #strH #strANG #title2)

	(setq #i 0)
	(repeat (length #WT$)
		(setq #HINBAN (nth #i #HINBAN$))
		(setq #PRICE  (nth #i #PRICE$ ))
		(setq #PRICE (PKITOAPRICE #PRICE)) ; 1234000==>"1,234,000�~"
		(setq #insPT (list 0 (* #i (- (+ #Y 200)))))
		(PKWTGroundPlanWAKU #insPT 5000 #Y 200 #HINBAN #PRICE) ; �g������
 		;;; ��ۯ���}��
		(setq #blPT (mapcar '+ #iPT #insPT))
		(command "._insert" (strcat CG_SYSPATH "tmp\\tempWT" (itoa #i) ".dwg") #blPT 1 1 "0");2009
		;;; ���@�L��
		(PKDimWrite #flg (nth #i #dim$$) (nth #i #dep$$) #blPT)
		;;; ����W�L��
;;;		(PKCabWrite #flg (nth #i #dim$$) (nth #i #dep$$) (nth #i #cabW$$) #blPT)
		(setq #i (1+ #i))
	)
	(setq #strPT (list 9300 (- (* #i (- (+ #Y 200))) (atoi #strH))) )
	(command "._TEXT" #strPT #strH #strANG #title3)

	;;; BG ;;;
	(setq #Y 2200 #iPT '(600 -1400))
	
	(setq #i 0)
	(repeat (length #BG$)
		(setq #BG_HIN (nth #i #BG_HIN$))
		(setq #BG_PRI  (nth #i #BG_PRI$))
		(setq #BG_PRI (PKITOAPRICE #BG_PRI)) ; 1234000==>"1,234,000�~"
		(setq #insPT (list 5200 (* #i (- (+ #Y 200)))))
		(PKWTGroundPlanWAKU #insPT 5000 #Y 200 #BG_HIN #BG_PRI) ; �g������
 		;;; ��ۯ���}��
		(setq #blPT (mapcar '+ #iPT #insPT))
		(command "._insert" (strcat CG_SYSPATH "tmp\\tempBG" (itoa #i) ".dwg") #blPT 1 1 "0");2009
		;;; BG���@�L��
		(PK_BG_DimWrite (nth #i #BG_LEN$) #blPT)
		(setq #i (1+ #i))
	)

	(command "._zoom" "e")
	(princ)
);C:PKShowWTinGroundPlan

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetWT
;;; <�����T�v>  : WT���w��
;;; <�߂�l>    : (WT�}�`��,"G_WRKT")
;;; <�쐬>      : 2000.6.21 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PKGetWT (
  /
	#LOOP #WT
  )
  ;;; ���[�N�g�b�v�̎w��
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #WT (car (entsel "\n���[�N�g�b�v��I��: ")))
		(if (= #WT nil)
			(CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
			(progn
	      (if (= (CFGetXData #WT "G_WRKT") nil)
	        (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
	        (setq #loop nil)
	      )
			)
		);_if
  )
	#WT ; WT�}�`��
);PKGetWT

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKSetSYS
;;; <�����T�v>  : ���ѕϐ��̐ݒ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.21 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PKSetSYS ( / )
	(setvar "GRIDUNIT" '( 150  150))
	(setvar "SNAPUNIT" '(  50   50))
	(setvar "LIMMAX"   '(4000 4000))
	(setvar "LIMMIN"   '(   0    0))
	;;; ���@�֘A���ѕϐ��̐ݒ�
	(setvar "DIMTMOVE" 1)  			; ���@�l�ړ��K��
	(setvar "DIMEXE" 50)   			; �⏕����������
	(setvar "DIMEXO" 25)   			; �N�_����̵̾��
	(setvar "DIMBLK" "OPEN30")  ; 30�x�J���
	(setvar "DIMASZ" 50)   			; ���̻���
	(setvar "DIMTXT" 50)   			; ��������
	(setvar "DIMTAD"  0)   			; ���@�z�u��������
	(setvar "DIMJUST" 0)   			; ���@�z�u��������
	(setvar "DIMGAP" 25)   			; ���@������̵̾��
	(setvar "DIMDEC" 0)    			; ���x
	(setvar "DIMATFIT" 2)  			; ���@�l���t�B�b�g
	(command "._UCSICON" "OF")
	(princ)
);PKSetSYS

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetANAdimGAS-SNK$
;;; <�����T�v>  : WT���@���A��ۑ��A�ݸ���ɕ�����
;;; <�߂�l>    : ��ۑ��A�ݸ�� �����@����
;;; <�쐬>      : 2000.6.21 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun GetANAdimGAS-SNK$ (
	&WTLEN1 ; ��ۑ�
	&dim$   ; �����@����
	&dimnum ; �����@����̎��ް���
	/
	#GASDIM$ #I #SNKDIM$ #SUM #dim
  )

	(setq #GASdim$ '())
	(setq #SNKdim$ '())
	(setq #i 0 #sum 0)
	(repeat (- &dimnum 2)
	;(repeat 6
		(setq #dim (nth #i &dim$))		
		(if (/= #dim "")
			(progn
				(setq #sum (+ #sum #dim))
				(if (< #sum (+ &WTLEN1 0.1))
					(setq #GASdim$ (append #GASdim$ (list #dim)))
					(setq #SNKdim$ (append #SNKdim$ (list #dim)))
				);_if
			)
		);_if
		(setq #i (1+ #i))
	)
	(list #GASdim$ #SNKdim$)
);GetANAdimGAS-SNK$

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetANAcabGAS-SNK$
;;; <�����T�v>  : ���ސ��@W���A��ۑ��A�ݸ���ɕ�����
;;; <�߂�l>    : ��ۑ��A�ݸ�� ���@W����
;;; <�쐬>      : 2000.6.23 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun GetANAcabGAS-SNK$ (
	&WTLEN1 ; ��ۑ�
	&cab$   ; ���ސ��@����
  /
	#CAB #GASCAB$ #I #SNKCAB$ #SUM
  )

	(setq #GAScab$ '())
	(setq #SNKcab$ '())
	(setq #i 0 #sum 0)
	(repeat (length &cab$)
		(setq #cab (nth #i &cab$))		
		(if (/= #cab "")
			(progn
				(setq #sum (+ #sum #cab))
				(if (< #sum (+ &WTLEN1 0.1))
					(setq #GAScab$ (append #GAScab$ (list #cab)))
					(setq #SNKcab$ (append #SNKcab$ (list #cab)))
				);_if
			)
		);_if
		(setq #i (1+ #i))
	)
	(list #GAScab$ #SNKcab$)
);GetANAcabGAS-SNK$

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKListToA_CabW
;;; <�����T�v>  : ���ސ��@W����𕶎���ɂ��� (150 300) ==>"(150) (300)"
;;; <�߂�l>    : ������
;;; <�쐬>      : 2000.6.23 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PKListToA_CabW (
	&cab$ ; ���ސ��@W����
  /
	#DUM
  )
	(setq #dum " ")
	(foreach #cab &cab$
		(setq #cab (itoa (fix (+ #cab 0.00001))))
		(setq #dum (strcat #dum "(" #cab ")"))
	)
	#dum
);PKListToA_CabW

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKDimWrite
;;; <�����T�v>  : WT���@�L��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.21 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PKDimWrite (
	&flg   ; �׸� ���ڽL=>"SL" ��=> nil
	&dim$  ; �����@����
	&dep$  ; ���s��ؽĂ�ؽ�
	&blPT  ; block�}���_
  /
	#DIM #DIMPT #DIMPT1 #DIMPT2 #I #K #WTLEN
	#EDPT #GASDIM$ #RET$ #SNKDIM$ #STPT #WTLEN1 #WTLEN2
	#DIMNUM ;00/08/03 SN ADD
  )
  	;00/08/03 SN ADD ���@��\�L���鐔�𐔂���
  	;I�^�̏ꍇ �U��MAX �ݸ���ۂ�������Ƃ��ꂼ��-2
  	(setq #dimnum 0)
	(foreach #dim &dim$
	  (if (/= #dim "") (setq #dimnum (1+ #dimnum)))
	)
  
	(if (= &flg "SL")
		(progn ; L�^
			(setq #WTLEN1 (nth (- #dimnum 2) &dim$)) ; ��ۑ� 00/08/03 SN MOD
			(setq #WTLEN2 (nth (- #dimnum 1) &dim$)) ; �ݸ�� 00/08/03 SN MOD
			(setq #ret$ (GetANAdimGAS-SNK$ #WTLEN1 &dim$ #dimnum));00/08/03 SN MOD �����̒ǉ�
			;(setq #WTLEN1 (nth 6 &dim$)) ; ��ۑ� 00/08/03 SN MOD
			;(setq #WTLEN2 (nth 7 &dim$)) ; �ݸ�� 00/08/03 SN MOD
			;(setq #ret$ (GetANAdimGAS-SNK$ #WTLEN1 &dim$))
			(setq #GASdim$ (nth 0 #ret$)) ; ��ۑ�
			(setq #SNKdim$ (nth 1 #ret$)) ; �ݸ��
			(setq #stPT (polar &blPT (dtr -90) #WTLEN1)) ; ���@�����o���_��ۑ�
			(setq #edPT (polar &blPT 0.0       #WTLEN2)) ; ���@�I���_�ݸ��
			;;; ��ۑ� �����@
			(if (= (length #GASdim$) 1)
				(progn ; ���@�P����===>�L���I��
					(setq #dimPT1 (polar #stPT (dtr 90) (nth 0 #GASdim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 180) 400))
					(command "._DIMLINEAR" #stPT #dimPT1 #dimPT2)	; ���@�L��
				)
				(progn  ; ���@����
					;;; �P�ڂ̐��@���L������
					(setq #dimPT1 (polar #stPT (dtr 90) (nth 0 #GASdim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 180) 200))
					(command "._DIMLINEAR" #stPT #dimPT1 #dimPT2)	; ���@�L��

					(setq #dimPT #dimPT1)
					(setq #k 1)
					(repeat (1- (length #GASdim$))
						(setq #dim (nth #k #GASdim$))
						(setq #dimPT (polar #dimPT (dtr 90) #dim))
						(command "._DIMCONTINUE" #dimPT  "" "")	; ���񐡖@�L��
						(setq #k (1+ #k))
					);_repeat

					;;; �S�̂̐��@���L������
					(setq #dimPT1 (polar #stPT (dtr 90) #WTLEN1))
					(setq #dimPT2 (polar #dimPT1 (dtr 180) 400))
					(command "._DIMLINEAR" #stPT #dimPT1 #dimPT2)	; ���@�L��
				)
			);_if
			
			;;; ���s��
			(setq #dimPT1 (polar #stPT 0.0 (nth 1 &dep$)))
			(setq #dimPT2 (polar #dimPT1 (dtr -90) 400))
			(command "._DIMLINEAR" #stPT #dimPT1 #dimPT2)	; ���@�L��

			;;; �ݸ�� �����@
			(if (= (length #SNKdim$) 1)
				(progn ; ���@�P����===>�L���I��
					(setq #dimPT1 (polar &blPT 0.0 (nth 0 #SNKdim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 400))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; ���@�L��
				)
				(progn  ; ���@����
					;;; �P�ڂ̐��@���L������
					(setq #dimPT1 (polar &blPT 0.0 (nth 0 #SNKdim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 200))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; ���@�L��

					(setq #dimPT #dimPT1)
					(setq #k 1)
					(repeat (1- (length #SNKdim$))
						(setq #dim (nth #k #SNKdim$))
						(setq #dimPT (polar #dimPT 0.0 #dim))
						(command "._DIMCONTINUE" #dimPT  "" "")	; ���񐡖@�L��
						(setq #k (1+ #k))
					);_repeat

					;;; �S�̂̐��@���L������
					(setq #dimPT1 (polar &blPT 0.0 #WTLEN2))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 400))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; ���@�L��
				)
			);_if

			;;; ���s��
			(setq #dimPT1 (polar #edPT (dtr -90) (nth 0 &dep$)))
			(setq #dimPT2 (polar #dimPT1 0.0 400))
			(command "._DIMLINEAR" #edPT #dimPT1 #dimPT2)	; ���@�L��

		)
		(progn ; I�^
			(setq #WTLEN (nth (1- #dimnum) &dim$));00/08/03 SN MOD ���@ؽĂ̍ŌオWTLEN
		 	;(setq #WTLEN (nth 5 &dim$))          ;00/08/03 SN MOD
			;;; �����@
			(if (equal (nth 0 &dim$) #WTLEN 0.001)
				(progn ; ���@�P����===>�L���I��
					(setq #dimPT1 (polar &blPT 0.0 (nth 0 &dim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 400))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; ���@�L��
				)
				(progn  ; ���@����
					;;; �P�ڂ̐��@���L������
					(setq #dimPT1 (polar &blPT 0.0 (nth 0 &dim$)))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 200))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; ���@�L��

					(setq #dimPT #dimPT1)
					(setq #k 1) 
					(repeat (- #dimnum 2);00/08/03 SN MOD ���@ؽĐ�-2�𒼗�\�L 
					;(repeat 4           ;00/08/03 SN MOD
						(setq #dim (nth #k &dim$))
						(if (/= #dim "")(progn;00/08/03 SN MOD Command��IF���Ɋ܂߂�
							(setq #dimPT (polar #dimPT 0.0 #dim))
						;)
							(command "._DIMCONTINUE" #dimPT  "" "")	; ���񐡖@��
						));END IF -PROGN
						(setq #k (1+ #k))
					);_repeat

					;;; �S�̂̐��@���L����
					(setq #dimPT1 (polar &blPT 0.0 #WTLEN))
					(setq #dimPT2 (polar #dimPT1 (dtr 90) 400))
					(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; ���@�L��
				)
			);_if

			;;; ���s��
			(setq #dimPT1 (polar &blPT (dtr -90) (car &dep$)))
			(setq #dimPT2 (polar #dimPT1 (dtr 180) 400))
			(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; ���@�L��
		)
	);_if
	(princ)
);PKDimWrite

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKCabWrite
;;; <�����T�v>  : WT�����ސ��@�v�L��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.21 YM
;;; <���l>      : WT���� #WTLEN1 �Ʒ��ސ��@W�Ƃ͕K��������v���Ȃ�
;;;             ; 
;;;*************************************************************************>MOH<
(defun PKCabWrite (
	&flg   ; �׸� ���ڽL=>"SL" ��=> nil
	&dim$  ; �����@����
	&dep$  ; ���s��ؽ�
	&cab$  ; ���ސ��@�v����
	&blPT  ; block�}���_
  /
	#STR #STRANG #STRH #STRPT
	#EDPT #GASCAB$ #RET$ #SNKCAB$ #STPT #STRANG90 #WTLEN1 #WTLEN2
	#DIMNUM #DIM;00/08/04 SN ADD
  )
  	;00/08/04 SN ADD ���@��\�L���鐔�𐔂���
  	;I�^�̏ꍇ �U��MAX �ݸ���ۂ�������Ƃ��ꂼ��-2
  	(setq #dimnum 0)
	(foreach #dim &dim$
	  (if (/= #dim "") (setq #dimnum (1+ #dimnum)))
	)

	(setq #strH "50")
	(setq #strANG    "0")
	(setq #strANG90 "90")

	(if (= &flg "SL")
		(progn ; L�^
;;; &blPT
;;;  +----------------#edPT
;;;  |                 |
;;;  |                 |
;;;  |      +----------+
;;;  |      |
;;;  |      |
;;;#stPT----+
			(setq #WTLEN1 (nth (- #dimnum 2) &dim$)) ; ��ۑ� 00/08/04 SN MOD
			(setq #WTLEN2 (nth (- #dimnum 1) &dim$)) ; �ݸ�� 00/08/04 SN MOD
			;(setq #WTLEN1 (nth 6 &dim$)) ; ��ۑ� 00/08/03 SN MOD
			;(setq #WTLEN2 (nth 7 &dim$)) ; �ݸ�� 00/08/03 SN MOD
			(setq #stPT (polar &blPT (dtr -90) #WTLEN1)) ; ���@�����o���_��ۑ�
			(setq #edPT (polar &blPT 0.0       #WTLEN2)) ; ���@�I���_�ݸ��
			(setq #ret$ (GetANAcabGAS-SNK$ #WTLEN1 &cab$))
			(setq #GAScab$ (nth 0 #ret$)) ; ��ۑ�
			(setq #SNKcab$ (nth 1 #ret$)) ; �ݸ��
			;;; ��ۑ�
			(setq #STR (PKListToA_CabW #GAScab$))
			(setq #strPT (polar #stPT 0.0 (+ (cadr &dep$) 200))) ; ���@�����o���_��ۑ�
			(command "._TEXT" #strPT #strH #strANG90 #STR)
			;;; �ݸ��
			(setq #STR (PKListToA_CabW #SNKcab$))
			(setq #strPT (polar #edPT  (dtr -90) (+ (car &dep$) 200))) ; ���@�����o���_�ݸ��
			(setq #strPT (polar #strPT (dtr 180) (+ (- #WTLEN2 (cadr &dep$)) -200))) ; ���@�����o���_�ݸ��
			(command "._TEXT" #strPT #strH #strANG #STR)
		)
		(progn ; I�^
			(setq #STR (PKListToA_CabW &cab$))
			(setq #strPT (polar &blPT (dtr -90) (+ (car &dep$) 200))) ; ���@�����o���_��ۑ�
			(command "._TEXT" #strPT #strH #strANG #STR)
		)
	);_if
	(princ)
);PKCabWrite

;;;<HOM>*************************************************************************
;;; <�֐���>    : PK_BG_DimWrite
;;; <�����T�v>  : BG���@�L��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.21 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PK_BG_DimWrite (
	&BG_LEN ; BG����
	&blPT   ; block�}���_
  /
	#DIMPT1 #DIMPT2
  )
	;;; BG����
	(setq #dimPT1 (polar &blPT 0.0 &BG_LEN))
	(setq #dimPT2 (polar #dimPT1 (dtr 90) 200))
	(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; ���@�L��
	;;; ���s��
	(setq #dimPT1 (polar &blPT (dtr -90) CG_BG_T)) ; BG����
	(setq #dimPT2 (polar #dimPT1 (dtr 180) 200))
	(command "._DIMLINEAR" &blPT #dimPT1 #dimPT2)	; ���@�L��

	(princ)
);PK_BG_DimWrite

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKITOAPRICE
;;; <�����T�v>  : ���i�𕶎���ɂ��� 1234000==>"1,234,000�~"
;;; <�߂�l>    : ������
;;; <�쐬>      : 2000.6.21 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PKITOAPRICE (
	&price ; ����
  /
	#DUM #I #J #KOSU #PRICE #STR
  )
	(setq #dum " ")
	(setq #price (itoa (fix (+ &price 0.00001))))
	(setq #kosu (strlen #price))
	(setq #i #kosu)
	(setq #j 1)
	(repeat #kosu
		(setq #str (substr #price #i 1))
		(setq #dum (strcat #str #dum))
		(if (and (= (rem #j 3) 0) (/= #j #kosu)) ; ��]
			(setq #dum (strcat "," #dum))
		);_if
		(setq #j (1+ #j))
		(setq #i (1- #i))
	)
	(strcat #dum "�~")
);PKITOAPRICE

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKWTGroundPlanWAKU
;;; <�����T�v>  : �g������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.20 YM
;;; <���l>      : 
;;;           LenX
;;;  O*-----------------+
;;;   |                 |TitY
;;; p1+-----------------+p2
;;;LenY                 |
;;;   |                 |
;;;   |                 |
;;;   +-----------------+
;;;*************************************************************************>MOH<
(defun PKWTGroundPlanWAKU (
	&origin ; �g����_
	&LenX   ; �g��
	&LenY   ; �g����
	&TitY   ; ���ٕ�
	&HINBAN ; WT�i�� or BG�i��(����)
	&PRICE  ; ���z(����)
  /
	#ENDPT #P1 #P2 #STRANG #STRH #STRPT
  )
;;; �g �쐬
	(setq #endPT (strcat "@" (rtos &LenX) "," (rtos (- &LenY))))
	(command "._rectangle" &origin #endpt)
;;; ���ٗ� �쐬
	(setq #p1 (list    (car &origin)        (+ (cadr &origin)(- &TitY))))
	(setq #p2 (list (+ (car &origin) &LenX) (+ (cadr &origin)(- &TitY))))
	(command "._line" #p1 #p2 "")

;;;	(command "._style" "standard" "�l�r ����" "" "" "" "" "")
	;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
	(command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
;;; ���ٗ� �i�ԋL��
	(if &HINBAN
		(progn
			(setq #strPT (list (+ (car #p1) 200) (+ (cadr #p1) 50)))
			(setq #strH "100")
			(setq #strANG "0")
			(command "._TEXT" #strPT #strH #strANG &HINBAN)
		)
	);_if
;;; ���ٗ� ���z�L��
	(if &PRICE
		(progn
			(setq #strPT (list (- (car #p2) 1000) (+ (cadr #p2) 50)))
			(setq #strH "100")
			(setq #strANG "0")
			(command "._TEXT" #strPT #strH #strANG &PRICE)
		)
	);_if

;;;	(command "._zoom" "e")
	(princ)
);PKWTGroundPlanWAKU

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetWT-ANA_Outline
;;; <�����T�v>  : WT�}�`����n����WT�O�`+�ݸ,��ی��}�`��ۯ���
;;;               �`\tmp\temp[&no].dwg �Ƃ��ĕۑ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.20 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PKGetWT-ANA_Outline (
	&WT     ; WT�}�`��
	&no     ; �ŉE�v�s����̔ԍ� 0,1,2...
  /
	#ANG #BASEWT #EGAS_P5$ #ESNK_P$ #ESNK_P1$ #ESNK_P4$$ #GAS$$ #P1 #P2 #P3 #PT$ #RET$ #SNK$$ 
	#SS #TEIWT #XDWT$ #ZAICODE #ZAIF
  #iFILEDIA   ; �V�X�e���ϐ� 01/11/22 HN ADD
  )
	(setq #ss (ssadd))
	(setq #xdWT$ (CFGetXData &WT "G_WRKT"))
	(setq #ZaiCode (nth 2 #xdWT$)) ; 00/09/26 YM
	(setq #ZaiF (KCGetZaiF #ZaiCode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ
	(setq #baseWT (nth 32 #xdWT$)) ; WT����_
	(setq #teiWT  (nth 38 #xdWT$)) ; WT��ʐ}�`

	(setq #ret$ (PKW_GetWorkTopAreaSym3	&WT))
;;;	#SNK$$ = (#enSNK #enSNKCAB #snkPen1 #snkPen4)
;;;	#GAS$$ = (#enGAS #enGASCAB #GasPen5)
;;; (#SNK$$ #GAS$$ #eWTR$ )
	(setq #SNK$$ (nth 0 #ret$))
	(setq #GAS$$ (nth 1 #ret$))
;;; �ϐ��֑��<�ݸ>
	(foreach #SNK$ #SNK$$
		(setq #eSNK_P1$ (append #eSNK_P1$ (list (nth 2 #SNK$)))) ; �ݸPMEN1�����ؽ�(nil)�܂�
		(setq #eSNK_P4$$ (append #eSNK_P4$$ (list (nth 3 #SNK$)))) ; �ݸPMEN4�����ؽ�(nil)�܂�
	)
	(setq #eSNK_P1$ (NilDel_List #eSNK_P1$ ))
	(setq #eSNK_P4$$ (NilDel_List #eSNK_P4$$ ))

;;; �ϐ��֑��<���>
	(foreach #GAS$ #GAS$$
		(setq #eGAS_P5$ (append #eGAS_P5$ (list (nth 2 #GAS$)))) ; ���PMEN5�����ؽ�(nil)�܂�
	)
	(setq #eGAS_P5$ (NilDel_List #eGAS_P5$ ))

	; �e�ݸ�̍ގ��ɉ������ݸ���̈��ؽĂ�Ԃ�(�ݸ�����Ή�)
	;01/03/27 YM MOD �ݸ���̈�̑������݂Ĕ��f STRAT
	(setq #eSNK_P$ (KPGetSinkANA #eSNK_P4$$ #ZaiF)) ; �e�ݸ����PMEN4ؽĂ�ؽ�
	;01/03/27 YM MOD �ݸ���̈�̑������݂Ĕ��f END

;;;01/03/27YM@	(cond ; 00/09/26 YM
;;;01/03/27YM@		((equal #ZaiF 1 0.1)
;;;01/03/27YM@			(setq #eSNK_P$ #eSNK_P1$) ; ���ڽ
;;;01/03/27YM@		)
;;;01/03/27YM@		((equal #ZaiF 0 0.1)
;;;01/03/27YM@			(setq #eSNK_P$ #eSNK_P4$) ; �l�H�嗝��
;;;01/03/27YM@		)
;;;01/03/27YM@		(T
;;;01/03/27YM@			(CFAlertMsg "\n�wWT�ގ��x��\"�f��F\"���s���ł��B")(quit)
;;;01/03/27YM@		)
;;;01/03/27YM@	);_cond

	(ssadd #teiWT #ss)
	(foreach #eSNK_P #eSNK_P$
		(ssadd #eSNK_P #ss)
	)
	(foreach #eGAS_P5 #eGAS_P5$
		(ssadd #eGAS_P5  #ss)
	)

	;;; UCS��`
	(setq #pt$ (GetLWPolyLinePt #teiWT))    ; WT�O�`�_��
	(setq #pt$ (GetPtSeries #baseWT #pt$))  ; #BASEPT ��擪�Ɏ��v����
	(setq #p1 (nth 0 #pt$))
	(setq #p2 (nth 1 #pt$))
	(setq #ang (angle #p1 #p2))
	(setq #p3 (polar #p1 (+ #ang (dtr 90)) 500))
	(command "._ucs" "3" #p1 #p2 #p3)
	(setq #baseWT (trans #baseWT 0 1))      ; հ�ް���W�n�ɕϊ�

	;;; ��ۯ��ۑ�
	(setq #iFILEDIA (getvar "FILEDIA")) ; 01/11/22 HN
	(setvar "FILEDIA" 0)
	(command "._wblock" (strcat CG_SYSPATH "tmp\\tempWT" &no ".dwg") "" #baseWT #ss "")
	(command "._oops") ; �}�`����
  (command "._ucs" "P")
	(setvar "FILEDIA" #iFILEDIA)
	(princ)
);PKGetWT-ANA_Outline

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKGetBG_Outline
;;; <�����T�v>  : WT�}�`����n����WT�O�`+�ݸ,��ی��}�`��ۯ���
;;;               �`\tmp\temp[&no].dwg �Ƃ��ĕۑ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.20 YM
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PKGetBG_Outline (
	&BGtei ; BG�}�`��
	&WT    ; �֘AWT
	&no    ; ��ۯ��ԍ� 0,1,2...
  /
	#ANG #BASEWT #P1 #P2 #P3 #PT$ #SS #TEIWT #XDWT$ #BASEBG
  #iFILEDIA   ; �V�X�e���ϐ� 01/11/22 HN ADD
  )
	(setq #xdWT$ (CFGetXData &WT "G_WRKT"))
	(setq #baseWT (nth 32 #xdWT$)) ; WT����_
	(setq #teiWT  (nth 38 #xdWT$)) ; WT��ʐ}�`

	(setq #ss (ssadd))
	(ssadd &BGtei #ss)

	;;; UCS��`
	(setq #pt$ (GetLWPolyLinePt #teiWT))    ; WT�O�`�_��
	(setq #pt$ (GetPtSeries #baseWT #pt$))  ; #BASEPT ��擪�Ɏ��v����
	(setq #p1 (nth 0 #pt$))
	(setq #p2 (nth 1 #pt$))
	(setq #ang (angle #p1 #p2))
	(setq #p3 (polar #p1 (+ #ang (dtr 90)) 500))
	(command "._ucs" "3" #p1 #p2 #p3)
;;;	(setq #baseWT (trans #baseWT 0 1))      ; հ�ް���W�n�ɕϊ�

	(setq #pt$ (GetLWPolyLinePt &BGtei))    ; BG�O�`�_��
	(setq #baseBG (XminYmax #pt$))          ; �_�񂩂� �߲�č��W(Xmin,Ymax)��Ԃ�
;;;	(setq #baseBG (trans #baseBG 0 1))      ; հ�ް���W�n�ɕϊ�
	(setq #p1 (nth 0 #pt$))

	;;; ��ۯ��ۑ�
  (setq #iFILEDIA (getvar "FILEDIA")) ; 01/11/22 HN ADD
	(setvar "FILEDIA" 0)
	(command "._wblock" (strcat CG_SYSPATH "tmp\\tempBG" &no ".dwg") "" #baseBG #ss "")
	(command "._oops") ; �}�`����
  (command "._ucs" "P")
	(setvar "FILEDIA" #iFILEDIA)  ; 01/11/22 HN ADD
	(princ)
);PKGetBG_Outline

;;;<HOM>*************************************************************************
;;; <�֐���>    : XminYmax
;;; <�����T�v>  : �_�񂩂� �߲�č��W(Xmin,Ymax)��Ԃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000.6.21 YM
;;; <���l>      : ucs 3 �̍ے�
;;;*************************************************************************>MOH<
(defun XminYmax (
	&pt$
  /
	#PT$ #X #XMIN #Y #YMAX
  )
	(setq #Xmin  1.0e+10)
	(setq #Ymax -1.0e+10)

	(foreach #pt &pt$
		(setq #pt (trans #pt 0 1)) ; հ�ް���W�n�ɕϊ�
		(setq #x (car  #pt))
		(if (<= #x #Xmin)
			(setq #Xmin #x)
		);_if
		(setq #y (cadr #pt))
		(if (>= #y #Ymax)
			(setq #Ymax #y)
		);_if
	)
	(list #Xmin #Ymax)
);XminYmax

(princ)