;;;<<�쓮�̕ύX>> 02/04/11 MH 
;;;
;;;���v��������������}�ŁAI�^�ŁA�}�E���g�����W�t�[�h�����Ԃɂ���v�����́A
;;;  �}�E���g�����W�t�[�h�̍��E�ŕ������ăt�B���[���쐬����悤�ɍ쓮��ύX�B
;;;
;;;���v��������������}�ŁA���O�� �t���[�v��������I�^ �Ŕw�ʂ̎w���
;;;  ����V��t�B���[���쐬������AI�^�A�V��t�B���[�L��̃v������
;;;  ��}������ƕs�v�Ȕw�ʂ���}�����s����C��
;;;  
;;;<<�v���O�����̕ҏW>>
;;;
;;;���t�B���[�͈͂����߂镔���ŃL���r�l�b�g�̔�����26mm�ɃL���E�`����
;;;  �����������O���[�o���ϐ� SKW_FILLER_DOOR �ɂ��� �t�@�C���̐擪��
;;;  ���L�B���݂͒l 26 ��ݒ�i��}��̔���20�ŏ�����Ă���j
;;;
;;;���t�B���[�̈悩��t�B���[��}���|�����C�����Z�o����
;;;  �֐� PcGetFilerOfsP&PL$ �̓��e���킩��ɂ��������̂ŁA�֐���
;;;  �������č쓮�̓��e�ɃR�����g�ǉ��B



;; �V��t�B���[�p�O���[�o���ϐ�
(setq SKW_FILLER_DOOR 25);����  2008/08/12 YM MOD ̨װ�̏o��344=>355�ɂ���

(setq SKW_FILLER_SIDE 0)
(setq SKW_FILLER_LSIDE 0)
(setq SKW_FILLER_RSIDE 0)
(setq SKW_FILLER_BSIDE 0)
(setq SKW_FILLER_LLEN 0.0);00/10/25 SN ADD �����s�����̒��� PcGetFilerOfsP&PL$���Őݒ�
(setq SKW_FILLER_RLEN 0.0);00/10/25 SN ADD �E���s�����̒��� PcGetFilerOfsP&PL$���Őݒ�
(setq SKW_FILLER_AUTO 'T) ; ���������Ȃ� T �蓮����͂Ȃ� nil

;;;01/12/17YM@DEL(defun C:PosFiler  ( ) (setq SKW_FILLER_AUTO 'T)  (PosUpFiler 2 1))
;;;01/12/17YM@MOD(defun C:MakeFiler ( ) (setq SKW_FILLER_AUTO nil) (PosUpFiler 2 1))

; 01/12/17 YM MOD-S PosUpFiler�֐���������
(defun C:PosFiler  ( ) (setq SKW_FILLER_AUTO 'T)  (PosUpFiler))
(defun C:MakeFiler ( ) (setq SKW_FILLER_AUTO nil) (PosUpFiler))
; 01/12/17 YM MOD-E

;<HOM>***********************************************************************
; <�֐���>    : PosUpFiler
; <�����T�v>  : �V��t�B���[��������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/02/06 MH MOD
; <���l>      : 01/12/17 YM ADD ̨װ��I���ł���悤�ɏC��(�޲�۸ނ�1�ɂ܂Ƃ߂�)
; ���݌����ł����͂Ƃ���Ȃ���PKW_UpperFiller
;             : 02/04/10 MH I�^�Ńt�B���[���O�����ɂ͂ݏo���ē\����s��i���A�j
;             : �ɂ��Ă�PcGetFilerOfsP&PL$�֐����̒��ӏ������Q�Ƃ��Ă�������
;***********************************************************************>HOM<
(defun PosUpFiler (
  /
;-- 2011/07/21 A.Satoh Mod - S
;  #BLR$ #ECAB #ELV #FD #FH #HEIGHT #HINBAN #HINBAN$ #MSG #OF&PT$ #OFDIST #OFSETP$
;  #OPT$$ #PLWID #PT$ #QLY$ #QRY$$ #SIDE_L #SIDE_R #SITEM #SOPHIN #SQL$ #UPHEIGHT
  #BLR$ #ECAB #ELV #FD #FH #HEIGHT #MSG #OF&PT$ #OFDIST #OFSETP$ #kosu #en
  #OPT$$ #PLWID #PT$ #QLY$ #qry$ #SIDE_L #SIDE_R #SITEM #SOPHIN #SQL$ #UPHEIGHT
;-- 2011/07/21 A.Satoh Mod - S
;-- 2011/08/11 A.Satoh Mod - S
  #syokei
;-- 2011/08/11 A.Satoh Mod - E
	#sa_H #ERR ;2011/12/19 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PosUpFiler ////")
  (CFOutStateLog 1 1 " ")

  ;// �R�}���h�̏�����
  (StartUndoErr) ;00/08/24 SN MOD Undo�������ɌĂт�
  (CFCmdDefBegin 6);00/09/26 SN ADD

  (setq #plWid (getvar "PLINEWID"))
  (setvar "PLINEWID" 0)

;;;02/03/29YM@DEL ;// �r���[��o�^ 02/03/27 YM ADD-S
;;;02/03/29YM@DEL  (command "_view" "S" "TEMP_PF")
;;;02/03/29YM@DEL ;// �r���[��o�^ 02/03/27 YM ADD-S

  ;// �V��t�B���[�i�Ԍ��̎擾
  ;// �v����OP�e�[�u������������
;;;  (setq #sql$
;;;    (list
;;;     (list "OP�i�敪"     "2"  'INT)
;;;     (list "���j�b�g�L��" "K"  'STR)
;;;   )
;;;
;;;
;;;  )
;;;  (setq #qry$$ (CFGetDBSQLRec CG_DBSESSION "�v����OP" #sql$))
;;;
;;; (if (= #qry$$ nil)
;;;   (progn
;;;     (CFAlertMsg msg8)
;;;     (quit)
;;;   )
;;; );_if

;;; (if #qry$$
;;;   (progn
;;;     (setq #Hinban$ nil)
;;;     (foreach #qry$ #qry$$
;;;       ;// �I�v�V�����Ǘ�ID�Ńv���\OP�e�[�u������������
;;;       (setq #opt$$
;;;         (CFGetDBSQLRec CG_DBSESSION "�v���\OP"
;;;           (list (list "OPTID" (rtois (car #qry$)) 'INT))
;;;         )
;;;       )
;;;       (if (= #opt$$ nil)
;;;         (progn
;;;           (setq #msg (strcat "�w�v���\OP�x�Ƀ��R�[�h������܂���B"))
;;;           (CFOutStateLog 0 1 #msg)
;;;           (CFAlertMsg #msg)
;;;           (*error*)
;;;         )
;;;         (progn
;;;           (setq #Hinban (nth 2 (car #opt$$)))
;;;           (setq #Hinban$ (append #Hinban$ (list #Hinban)))
;;;         )
;;;       );_if
;;;
;;;     );foreach
;;;   )
;;;   (progn
;;;      (CFAlertMsg "\"��׊�OP\"��ں��ނ�����܂���B")
;;;      (exit)
;;;   )
;;; );_if

;-- 2011/07/21 A.Satoh Mod - S
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "�V��t�B��"
      (list (list "���V���L��" CG_DRSeriCode 'STR))
    )
  )
  (if (= #qry$ nil)
    (progn
      (CFAlertMsg "�V��t�B�������擾�ł��܂���B")
      (exit)
    )
  )

; ;�V���̕i�Ԃ��߂��� 2009/10/07 YM ADD
; (setq #Hinban$ '("HSCM240R-@@"))
;-- 2011/07/21 A.Satoh Mod - E

  ; ̨װ������̫�Ă����߂�
  (setq #UpHeight CG_UpCabHeight)
  (setq #elv (getvar "ELEVATION"))
  (setvar "ELEVATION" #UpHeight)

  ; �V�䂩��̋󌄂ƕ��ނ̍�����r�B
  (setq #fH (- CG_CeilHeight #UpHeight))


	;2013/11/19 YM ADD-S
	(setq #lis$$ nil);�V�䖋�̌����A�V��|�݌�����i�荞��
	(foreach #qry #qry$
		(setq #HH (fix (+ (nth 1 #qry) 0.001))) ;100,200,300
		(setq #lis$$ (append #lis$$ (list (list #HH #qry))))
	)
	(cond
		((and (< 0.001 #fH)(> 100.001 #fH)) ;0<#fH<100
			(setq #qry$ (cdr (assoc 100 #lis$$)))
	 	)
		((and (< 100.001 #fH)(> 200.001 #fH)) ;0<#fH<200
			(setq #qry$ (cdr (assoc 200 #lis$$)))
	 	)
		((and (< 200.001 #fH)(> 300.001 #fH)) ;0<#fH<300
			(setq #qry$ (cdr (assoc 300 #lis$$)))
	 	)
		(T ;����ȊO���蓾�Ȃ�
			(CFAlertMsg "�V�䖋���쐬�ł��܂���B�V�䍂���ƒ݌������̍������m�F�������B")
			(exit)
	 	)
	);cond
	;2013/11/19 YM ADD-E


  ; ��׊�OP ����,̨װ�I��,̨װ�����Ȃǂ��޲�۸ނ�\��

  ; ���s�����ʕ��̗L��
  ; &PLNFLG �v������������N�����ꂽ�Ȃ�'T  �t���[�݌v�Ȃ�nil
  ; �t���[�݌v���炾�����烆�[�U�[���獶�E�̗L�������߂� 01/04/04 �w�ʎw��\�ɕύX
  (setq #SIDE_L SKW_FILLER_LSIDE)
  (setq #SIDE_R SKW_FILLER_RSIDE)
;-- 2011/07/21 A.Satoh Mod - S
;  (if (not (setq #BLR$ (PcGetFilerALLDlg #Hinban$ #fH)))
  (if (not (setq #BLR$ (PcGetFilerALLDlg #qry$)))
;-- 2011/07/21 A.Satoh Mod - E
    (progn
;;;01/12/19YM@DEL     (command "_Undo" "B")
      (exit)
    )
  );_if
  (setq SKW_FILLER_BSIDE (nth 0 #BLR$))
  (setq SKW_FILLER_LSIDE (nth 1 #BLR$))
  (setq SKW_FILLER_RSIDE (nth 2 #BLR$))
  (setq #sOPHIN          (nth 3 #BLR$))
  (setq #height          (nth 4 #BLR$))
;-- 2011/07/22 A.Satoh Add - S
  (setq #kosu            (nth 5 #BLR$))
;-- 2011/07/22 A.Satoh Add - E
;-- 2011/08/11 A.Satoh Add - S
  (setq #syokei          (nth 6 #BLR$))
;-- 2011/08/11 A.Satoh Add - E


;2011/12/19 YM ADD-S �V������
	(setq #sa_H (- CG_CeilHeight CG_UpCabHeight))
	(setq #ERR nil)
	;2013/11/19 YM MOD-S
	(if (and (< -0.001 (- #height #sa_H ))(> 100.001 (- #height #sa_H )))
;;;	(if (< 0.0001 (+ (- #sa_H #height) 0.01))
	;2013/11/19 YM MOD-E
		nil ;OK
	 	;else
	 	(setq #ERR T)
 	);_if

	(if #ERR
		(progn
      (CFAlertMsg "\n�V�䖋���쐬�ł��܂���B�V�䍂���ƒ݌������̍������m�F�������B")
      (quit) ;�����I��
		)
	);_if


  (setq #QLY$
    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`" (list (list "�i�Ԗ���" #sOPHIN 'STR)))
  )
  (setq #QLY$ (KcChkQLY$ #QLY$ "�i�Ԑ}�`" (strcat "�i�Ԗ���=" #sOPHIN)))

  (setq #sItem   "�V��t�B���[")  ; ����
;;;  ; �K�{���� ����#fD ����#fH �擾
  (setq #fD      (nth 4 #QLY$)) ; ̨װ�̌��݂͕i�Ԑ}�`���Q�� ;2008/06/28 YM OK!
  (setq #ofDIST  SKW_FILLER_SIDE) ; �I�t�Z�b�g��

  ; �O���[�o���ϐ�SKW_FILLER_AUTO�Ŕ͈͎����v�Z������͂�����
  (cond
    (SKW_FILLER_AUTO
      ;; �t�B���[�ݒu��}�`�����[�U�[���狁�߂�
      (setq #eCAB (PcSelItemForFiller #sItem))
      ;; �}�`���擾����Ȃ������珈���I��
      (if (/= 'ENAME (type #eCAB)) (exit))
      ;; �����z�u�t�B���[�ݒu��|�����C���_���X�g�擾
      (setq #of&pt$ (PcGetFilerOfsP&PL$ #eCAB #ofDIST nil))
    )
    ;; ����͂Ńt�B���[�ݒu��|�����C���_���X�g�l��
    (t (setq #of&pt$ (list (PcDrawPlinePtWithOffset 1 #ofDIST))))
  ); cond

  (CFNoSnapReset);00/08/24 SN ADD 00/08/28 MH MOD ���[�U�_�擾�Ɋ���h�����߈ʒu�ړ��B
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart)

  ; �V��t�B���[�ݒu���s
  (foreach #o&p$ #of&pt$
    (setq #ofsetP$ (car #o&p$))
    (setq #pt$ (cadr #o&p$))
;-- 2011/07/22 A.Satoh Mod - S
;    (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height #UpHeight) ; 01/12/17 YM �����폜
;-- 2011/08/11 A.Satoh Mod - S
;    (setq #en (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height #UpHeight))

		;2013/11/19 YM MOD-S
;;;    setq #en (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height #UpHeight #syokei))
    (setq #en (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #sa_H #UpHeight #syokei))
		;2013/11/19 YM MOD-E

;-- 2011/08/11 A.Satoh Mod - E

    ; �����g���f�[�^�ɐݒ�
    (if (>= #kosu 2)
      (SetOpt #en (list (list #sOPHIN (1- #kosu))))
    )
;-- 2011/07/22 A.Satoh Mod - E
;;;01/12/17YM@MOD    (PcMakeFiler #sOPHIN &iOPTID #pt$ #ofsetP$ #fD #height #UpHeight)
  ); foreach

;;;02/03/29YM@DEL  ;// �r���[��߂�
;;;02/03/29YM@DEL  (command "_view" "R" "TEMP_PF") ; 02/03/27 YM ADD

  (princ (strcat "\n" #sItem ":["))
  (princ #sOPHIN)
  (princ "]")
  ;(setq SKW_FILLER_SIDE #FSIDE); �O���[�o���ݒ��߂� ; 01/01/19 MH �g�p���ĂȂ�
  (setvar "ELEVATION" #elv) ; ���̍����ɖ߂�
  (setvar "PLINEWID" #plWid)
  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  (CFNoSnapEnd)
  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)

);PosUpFiler

;;;01/12/17 YM ADD ̨װ��I���ł���悤�ɏC��(�޲�۸ނ�1�ɂ܂Ƃ߂�)


;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_UpperFiller
;;; <�����T�v>  : �i�v���������p�j�V��t�B���[�𐶐�����
;;; <�߂�l>    :
;;; <�쐬>      : 02/04/05 MH
;;; <���l>      : ϳ��̰�ނ��Ԃɂ���A�ݒu�̈悪2����v�����ɑΉ�
;;;*************************************************************************>MOH<
(defun PKW_UpperFiller (/ #QLY$ #sOPHIN #eBASE #eBASE$)

;2009/11/21 YM DEL
;;;  ;; �V��̨װ�����������nil�ɂȂ�̂ł����ōĒ�`
;;;  (setq SKW_FILLER_LSIDE 0)
;;;  (setq SKW_FILLER_RSIDE 0)
;;;  (setq SKW_FILLER_BSIDE 0)
(if (= nil SKW_FILLER_LSIDE)(setq SKW_FILLER_LSIDE 0))
(if (= nil SKW_FILLER_RSIDE)(setq SKW_FILLER_RSIDE 0))
(if (= nil SKW_FILLER_BSIDE)(setq SKW_FILLER_BSIDE 0))

  ;; �t�B���[�쐬��A�C�e�����X�g���擾�i�e�t�B���[�̈�ɂ�1�}�`�j
  (setq #eBASE$ (PKW_GetFillerBaseItemList))

  (foreach #eBASE #eBASE$
    (PcMkFillerInPLAN
      #eBASE                            ; ��Ƃ���A�C�e���̐}�`��
      CG_CeilHeight                     ; �V�䍂��=2400mm
      CG_UpCabHeight                    ; ���t������=2300mm
    )
  ) ;_ if

  (WebOutLog "�V��̨װ�𐶐����܂���"); 02/09/04 YM ADD ۸ޏo�͒ǉ�
  (princ)
) ;_PKW_UpperFiller

;<HOM>*************************************************************************
; <�֐���>    : PKW_GetFillerBaseItemList
; <�����T�v>  : �i�v���������p�j�V��t�B���[�ݒu��}�`���X�g�쐬
;                ϳ��̰�ނ��Ԃɂ���A�ݒu�̈悪2����v�����ɑΉ�
; <�߂�l>    :  �}�`�����X�g �܂��� nil
; <�쐬>      : 02/04/05 MH
; <���l>      : ������ I�^��ϳ�Č^̰�ނ��܂ݍ��[�E�[����ϳ�Č^̰�ނłȂ��v����
;*************************************************************************>MOH<
(defun PKW_GetFillerBaseItemList (
  /
  #sym$ #eBASE$ #eMount #enL #enR #enX$ #eWALL #iCORNER #sym 
  )
  
  ;; ���}�ʒ��̃E�H�[�������̃A�C�e���S�}�`�����X�g��o
  (setq #sym$ (KcSameLevelItem CG_SKK_TWO_UPP)) ; �݌˼����ؽ�(�ݼ�̰�ފ܂�)  

  ;; I �^�ł���ϳ�Č^̰�ނ����邩����
  (setq #EnX$ nil)   ; (��_X�l  �}�`��) ���X�g
  (setq #eWall nil)  ; �݌ˌ^���ސ}�`��
  (setq #eMount nil) ; ϳ�Č^̰�ސ}�`��
  (setq #iCorner 0)  ; ��Ű���ނ̐�

  (foreach #sym #sym$
    ;; ��Ű���ނ̐����J�E���g
    (if (= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3)) (setq #iCorner (1+ #iCorner)))

    ;; �݌˷��ސ}�`���擾
    (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #sym 1)) (setq #eWall #sym)) 

    ;; ϳ�Č^̰�ސ}�`���擾
    (if (= 328 (nth 9 (CFGetXData #sym "G_LSYM"))) (setq #eMount #sym))

    ;; �\�����т�(X�l �}�`��)���X�g�쐬
    (setq #EnX$ (cons (list (car (cdr (assoc 10 (entget #sym)))) #sym) #EnX$))
  )

  ;; �h�^�Ń}�E���g�t�[�h�L��Ȃ番���z�u�̏�������
  (setq #eBASE$ nil) 
  (if (and (= 0 #iCorner) (= 'ENAME (type #eMount)))
    (progn
      ;; ���X�g����_��X�l���ŕ��בւ�
      (setq #EnX$ (PcListOrderByNumInList #EnX$ 0))
      ;; ��car(���[) �� �Ō�last(�E�[) �̃A�C�e�����擾 
      (setq #enL (cadr (car #EnX$)))
      (setq #enR (cadr (last #EnX$)))
      ;; ���[�Ƃ��}�E���g�^�t�[�h�ȊO�Ȃ� ���̂Q�A�C�e���łQ��t�B���[�ݒu���s��
      (if (and (not (eq #enL #eMount))
               (not (eq #enR #eMount))
          )
        (setq #eBASE$ (list #enL #enR))
      );_ if
    )
  )

  ;; ��ʏ����͂P��t�B���[�ݒu���s���B�݌ˌ^���ސ}�`���ݒ�
  (if (and (= nil #eBASE$) (= 'ENAME (type #eWall)))
    (setq #eBASE$ (list #eWall))
  )

  ;; �}�`�����X�g��Ԃ��i�ݒu�}�`���Ȃ������ꍇ��nil���Ԃ�j
  #eBASE$
);_PKW_GetFillerBaseItemList

;<HOM>*************************************************************************
; <�֐���>    : PcMkFillerInPLAN
; <�����T�v>  : �V��t�B���[�𐶐��i�v���������p�j
; <�߂�l>    :
; <�쐬>      : 00/10/06 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcMkFillerInPLAN (
  &eBASE          ;(LIST)�x�[�X�L���r��V���{���̐}�`���X�g
  &CeilHeight     ;(REAL)�V�䍂��
  &UpCabHeight    ;(REAL)���t������
  /
  #QLY$ #fD #height #of&pt$ #o&p$ #ofsetP$ #pt$ #CFG$ #sCOL #sOPHIN #QLY$$ #kosu
  )
  (WebOutLog "�V��̨װ�̐�������(PcMkFillerInPLAN)"); 02/09/04 YM ADD ۸ޏo�͒ǉ�

  (if (= nil (tblsearch "LAYER" SKW_AUTO_SECTION))
    (command "_layer" "N" SKW_AUTO_SECTION "C" 2 SKW_AUTO_SECTION "L"
      SKW_AUTO_LAY_LINE SKW_AUTO_SECTION "")
  ); if

  (if (= "K" (nth  3 CG_GLOBAL$));���݂̂Ƃ�
    (progn
      ;�V�䖋�̕i�Ԏ擾
      (setq #QLY$$
        (CFGetDBSQLRec CG_DBSESSION "�V�䖋��"
          (list
            (list "�V���N���Ԍ�" (nth 4  CG_GLOBAL$) 'STR)
            (list "�`��"         (nth 5  CG_GLOBAL$) 'STR)
            (list "�ϊ��l"       (nth 46 CG_GLOBAL$) 'STR)
            (list "���V���L��"   (nth 12 CG_GLOBAL$) 'STR)
          )
        )
      )
      (setq #kosu (length #QLY$$))
      (setq #sOPHIN  (nth 4 (car #QLY$$))) ; �i��
    )
    (progn ;"D"���[

      (cond
        ;((= CG_SeriesDB "SDA") ;2011/02/01 YM MOD�yPG����z
        ((= BU_CODE_0002 "1") 
          ;�V�䖋�̕i�Ԏ擾
          (setq #QLY$$
            (CFGetDBSQLRec CG_DBSESSION "�V�䖋��D"
              (list
                (list "�ϊ��l"       (nth 72 CG_GLOBAL$) 'STR)
              )
            )
          )
        )
        ;((= CG_SeriesDB "SDB") ;2011/02/01 YM MOD�yPG����z
        ((= BU_CODE_0002 "2")  
          ;�V�䖋�̕i�Ԏ擾
          (setq #QLY$$
            (CFGetDBSQLRec CG_DBSESSION "�V�䖋��D"
              (list
                (list "�ϊ��l"       (nth 72 CG_GLOBAL$) 'STR)
                (list "���V���L��"   (nth 62 CG_GLOBAL$) 'STR);2009/10/27 YM ADD KEY�ǉ�
              )
            )
          )
        )
        (T ;__OTHER
          ;�V�䖋�̕i�Ԏ擾
          (setq #QLY$$
            (CFGetDBSQLRec CG_DBSESSION "�V�䖋��D"
              (list
                (list "�ϊ��l"       (nth 72 CG_GLOBAL$) 'STR)
                (list "���V���L��"   (nth 62 CG_GLOBAL$) 'STR);2009/10/27 YM ADD KEY�ǉ�
              )
            )
          )
        )
      );_cond

      (setq #kosu (length #QLY$$))
      (setq #sOPHIN  (nth 2 (car #QLY$$))) ; �i��
    )
  );_if

  ;�i�Ԑ}�`�e�[�u������N�G���擾
  (setq #QLY$
    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`" (list (list "�i�Ԗ���" #sOPHIN 'STR)))
  )
  (setq #QLY$ (KcChkQLY$ #QLY$ "�i�Ԑ}�`" (strcat "�i�Ԗ���=" #sOPHIN)))
  ; �K�{���� ����#fD �擾
  (setq #fD (nth 4 #QLY$));2008/06/28 YM OK!

  ; �����擾


;2011/12/19 YM ADD-S �V������
;����ID	�\����	�����l	�����l��
;PLAN46	1	X	-----
;PLAN46	2	N	��t���Ȃ�
	(setq #height (- &CeilHeight &UpCabHeight))

;2013/11/19 YM DEL-S
;;;	(if (and CG_GLOBAL$ (nth 46 CG_GLOBAL$) (/= (nth 46 CG_GLOBAL$) "N")(/= (nth 46 CG_GLOBAL$) "X"))
;;;		(progn ;�V�䍂��,�݌��������� CG_CeilHeight , CG_UpCabHeight
;;;			(cond
;;;				((= "A" (nth 46 CG_GLOBAL$))
;;;  				(setq #height 100.0)
;;;			 	)
;;;				((= "B" (nth 46 CG_GLOBAL$))
;;;  				(setq #height 200.0)
;;;			 	)
;;;				((= "C" (nth 46 CG_GLOBAL$))
;;;  				(setq #height 300.0)
;;;			 	)
;;;				(T
;;;  				(setq #height (- &CeilHeight &UpCabHeight))
;;;			 	)
;;;			);_cond
;;;		)
;;;	);_if
;;;
;;;	(if (and CG_GLOBAL$ (nth 72 CG_GLOBAL$) (/= (nth 72 CG_GLOBAL$) "N")(/= (nth 72 CG_GLOBAL$) "X"))
;;;		(progn ;�V�䍂��,�݌��������� CG_CeilHeight , CG_UpCabHeight
;;;			(cond
;;;				((= "A" (nth 72 CG_GLOBAL$))
;;;  				(setq #height 100.0)
;;;			 	)
;;;				((= "B" (nth 72 CG_GLOBAL$))
;;;  				(setq #height 200.0)
;;;			 	)
;;;				((= "C" (nth 72 CG_GLOBAL$))
;;;  				(setq #height 300.0)
;;;			 	)
;;;				(T
;;;  				(setq #height (- &CeilHeight &UpCabHeight))
;;;			 	)
;;;			);_cond
;;;		)
;;;	);_if
;2013/11/19 YM DEL-E

  ; �t�B���[�̈�A�C�e���̐}�`���Ɨ̈�_��(�␳�L)�̃��X�g���Z�o
  (setq #of&pt$
    (PcGetFilerOfsP&PL$
    &eBASE            ; ��Ƃ���E�H�[���L���r�̐}�`��
    SKW_FILLER_SIDE   ; ���Ȃ��̃I�t�Z�b�g�l
    'T                ; �v������������N��= 'T  �t���[�݌v�Ȃ�nil
    )
  ); setq



  ; �t�B���[��}&�f�[�^�Z�b�g���s
  (foreach #o&p$ #of&pt$
    (setq #ofsetP$ (car #o&p$))
    (setq #pt$ (cadr #o&p$))

    ;2011/05/21 YM MOD �݌ˉ�OPEN_BOX�̂Ƃ�Z=2150mm�ɕ␳����
    (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
;-- 2011/08/11 A.Satoh Mod - S
;      ;�݌ˉ�OPEN_BOX����
;      (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height CG_WallUnderOpenBoxHeight)
;      ;else
;      (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height CG_UpCabHeight)
      ; �v�����������́A�����l���u�L�b�`��("A")�v�Őݒ�
      ;�݌ˉ�OPEN_BOX����
      (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height CG_WallUnderOpenBoxHeight "A")
      ;else
      (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height CG_UpCabHeight "A")
;-- 2011/08/11 A.Satoh Mod - E
    );_if


  ); foreach

  (princ)
) ;PcMkFillerInPLAN

;<HOM>***********************************************************************
; <�֐���>    : KcChkQLY$
; <�����T�v>  : �P��O��̃N�G���̌��ʃ`�F�b�N
; <�߂�l>    : �N�G�����X�g �܂��� nil
; <�쐬>      : 01/02/06 MH MOD
; <���l>      : �N�G���� 0 �܂��͕����̏ꍇ �G���[���b�Z�[�W�\���I��
;***********************************************************************>HOM<
(defun KcChkQLY$ (&QLY$ &sTable &addMSG / #msg)
  (cond
    ((not &QLY$)
      (setq #msg (strcat "�w" &sTable "�x��ں��ނ�����܂���B\n" &addMSG))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    ((< 1 (length &QLY$))
      (setq #msg (strcat "�w" &sTable "�x��ں��ނ��������݂��܂��B\n" &addMSG))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    (t (car &QLY$))
  ); cond
); KcChkQLY$

;<HOM>*************************************************************************
; <�֐���>    : PcDrawPlinePtWithOffset
; <�����T�v>  : �A�����������}�������̒[�_�̃��X�g���擾����
; <�߂�l>    : (�I�t�Z�b�g��_   �쐬�����_�񃊃X�g�j
; <�쐬>      : 00-04-17 MH
; <���l>      : �I�t�Z�b�g�Ԋu���ݒ肷��悤�ɕύX 00/12/25 MH MOD
;*************************************************************************>MOH<
(defun PcDrawPlinePtWithOffset (
  &mode         ;(INT) �����L���Ƃ��邩(���b�Z�[�W�̂�)0:���� 1:�L��
  &defoD        ; �f�t�H���g�̃I�t�Z�b�g��
  /
  #en$ #loop #msg #p1 #p2 #pt$ #os #eDEL #subP$ #dist$ #pt$ #crosP
  #i #i2 #ofANG$ #pt$2 #new$ #ofP$ #C_FLG #ePL #clseFLG #midP #ofP2
  #dist #ofP ;02/03/29MH@ADD
  )
  (setq #dist (fix &defoD))
  (setq #loop T)
  (setq #p1 (getpoint (strcat "\n�n�_: ")))
  (setq #dist$ (list 0))
  (setq #pt$ (list #p1))
  (while (= T #loop)
    (cond
      ; C�L�����[�h
      ((and (= &mode 1) (/= nil #p1) (< 3 (length #pt$)))
        (initget 128 "-a 1a 2a 3a 4a 5a 6a 7a 8a 9a U C")
        (setq #p2 (getpoint #p1 (strcat "\n���_ /U=�߂�/C=����/: ")))
        (if (and (= 'STR (type #p2)) (numberp (read #p2))) (progn
          (setq #dist (fix (read #p2)))
          (initget "U C")
          (setq #p2 (getpoint #p1 (strcat "\n���_ /U=�߂�/C=����/: ")))
        )); if progn
      )
      ((/= nil #p1) ; C�Ȃ����[�h
        (initget 128 "-a 1a 2a 3a 4a 5a 6a 7a 8a 9a U")
        (setq #p2 (getpoint #p1 (strcat "\n���_ /U=�߂�/: ")))
        (if (and (= 'STR (type #p2)) (numberp (read #p2))) (progn
          (setq #dist (fix (read #p2)))
          (initget "U")
          (setq #p2 (getpoint #p1 (strcat "\n���_ /U=�߂�/: ")))
        )); if
      )
    ); cond
    (cond
      ((= nil #p2)
        (setq #loop nil)
      )
      ((= "U" #p2)
        (setq #p1 (trans (cdr (assoc 10 (entget (car #en$)))) 0 1))
        (entdel (car #en$))
        (setq #en$ (cdr #en$))
        (setq #pt$ (cdr #pt$))
        (setq #dist$ (cdr #dist$))
      )
      (T
        (if (= "C" #p2) (progn
          (setq #loop nil)
          (setq #p2 (last #pt$))
        )); if progn
        (setq #dist$ (cons #dist #dist$))
        (setq #pt$ (cons #p2 #pt$))
        (setq #os (getvar "OSMODE"))
        (setvar "OSMODE" 0)
        (command "_line" #p1 #p2 "")
        (command "_change" (entlast) "" "P" "C" "1" "")
        (setvar "OSMODE" #os)
        (setq #p1 #p2)
        (setq #en$ (cons (entlast) #en$))
      )
    )
  )

  (setq #ofP (getpoint "�ݒu��������������w�� :")) ; HOPE-0359 01/03/02 MH MOD
  ;(setq #ofP (getpoint "�ݒu����V�䏈���A�C�e���̓����������w�� �F"))
  ; �����̈�_�ڂ̒l��0(�g�p���Ȃ�)�̂ŏ���
  (mapcar 'entdel #en$)
  (setq #dist$ (cdr (reverse #dist$)))
  (setq #pt$ (reverse #pt$))

  ; 00/12/25 MH ADD �擾���ꂽ�|�����C���ɃI�t�Z�b�g�����_���X�g���Z�o
  (if (not (equal &defoD 0 0.01)) (progn
    (setq #clseFLG (equal (car #pt$) (last #pt$) 0.01))
    (if #clseFLG
      (MakeLwPolyLine (cdr #pt$) 1 CG_UpCabHeight) ; �����|�����C��
      (MakeLwPolyLine #pt$ 0 CG_UpCabHeight)       ; �J�����|�����C��
    )
    (setq #ePL (entlast))
    ; �I�t�Z�b�g�ʂ��}�C�i�X�l�̏ꍇ�A�I�t�Z�b�g�_���|�����C���̊O�ɏo��
    (if (> 0 &defoD)
      (progn
        (setq #midP (inters #ofP
          (pcpolar #ofP (+ (* 0.5 pi) (angle (car #pt$)(cadr #pt$))) 100)
          (car #pt$)(cadr #pt$) nil))
        (setq #ofP2 (pcpolar #midP (angle #ofP #midP) (distance #ofP #midP)))
      ); progn
      (setq #ofP2 (list (car #ofP)(cadr #ofP)))
    ); if
    (command "_offset" (abs &defoD) #ePL #ofP2 "")
    (setq #pt$ (GetLWPolyLinePt (entlast)))
    (entdel #ePL)
    (entdel (entlast))
    (if #clseFLG (progn
      (setq #p2 (last #pt$))
      (setq #pt$ (cons #p2 #pt$))
    )); if progn
  )); if progn

  (list (list (car #ofP)(cadr #ofP)) #pt$)
); PcDrawPlinePtWithOffset

;<HOM>*************************************************************************
; <�֐���>    : KcSameLevelItem
; <�����T�v>  : ���}�ʒ��̓��荂���̃A�C�e���̐}�`�����X�g��o
; <�߂�l>    : �}�`���̃��X�g�� nil
; <�쐬>      : 01/02/02 MH
; <���l>      :
;*************************************************************************>MOH<
(defun KcSameLevelItem (
    &iHIGH     ; ��������������(���iCODE2���ڂ̐���)
    /
    #ss #i #eONE #eSEL$
  )
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if #ss (progn
    (setq #i 0)
    (repeat (sslength #ss)
      (setq #eONE (ssname #ss #i))
      (if (= &iHIGH (CFGetSymSKKCode #eONE 2)) (setq #eSEL$ (cons #eONE #eSEL$)))
      (setq #i (1+ #i))
    ); repeat
  )) ; if progn
  #eSEL$
);_KcSameLevelItem

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcSelItemForFiller
;;; <�����T�v>  : �V��t�B���[�ݒu�̊�ƂȂ�A�C�e�������[�U�[�ɑI��������
;;; <�߂�l>    : �}�`���� nil (�L�����Z�����ꂽ�ꍇ)
;;; <�쐬>      : 02/04/05 MH
;;; <���l>     * ���وʒu�̷���ȯĂ��ݼ�̰�ށAϳ�Č^̰�ނ͕s�Ƃ���
;;;            * �޲�ݸނ��w�����ꂽ�Ȃ�A���̐}�`�Ɋ���ڂ�
;;;*************************************************************************>MOH<
(defun PcSelItemForFiller (
  &sItem       ; �t�B���[�̖���
  /
  #en #NEXT$ #chgCAB #i
  )

  (setq #en 'T)
  (while (and #en (not (= 'ENAME (type #en))))

    ;; ���[�U�[�ɐ}�`��I�������� 02/03/27 YM MOD ̰�ނ͑I�΂��Ȃ�
    (setq #en (car (entsel (strcat "\n" &sItem "��ݒu����L���r�l�b�g��I�� �F"))))

    ;; �ݒu�\�}�`������
    (if #en
      (progn
        (setq #en (SearchGroupSym #en))
        (cond
          ;; �A�C�e���ȊO�̐}�`����уE�H�[���ʒu�ȊO�̐}�`�̓��b�Z�[�W�o���Ď擾
          ((not #en)
            (CFAlertMsg "�ݒu����L���r�l�b�g��I�����Ă��������B")
            (setq #en 'T)
          )
          ((not (= CG_SKK_TWO_UPP (CFGetSymSKKCode #en 2)))
            (CFAlertMsg "�݌˂�I�����Ă��������B")
            (setq #en 'T)
          )
          ;; �}�E���g�^�t�[�h"328" ���w�肳�ꂽ�Ȃ�΃��b�Z�[�W�o���Ď擾
          ((= 328 (nth 9 (CFGetXData #en "G_LSYM")))
            (CFAlertMsg "ϳ�Č^̰�ނ͑Ώۂ��珜�O����܂�\n�݌˂�د����Ă�������")
            (setq #en 'T)
          )
        ) ;_cond
        ;; ��L�̏����ȊO�͐ݒu�\
      )
    ) ;_ if
    ;; #en = 'T �Ȃ�΃��[�v�ĊJ
  ) ;_ while

  ;; �޲�ݸނ̂���L�^�΍�B�޲�ݸ޷��ނ��w�肳��Ă����炻��ȊO�Ɉڂ�
  (if (and (= 'ENAME (type #en))
           (= CG_SKK_THR_DIN (CFGetSymSKKCode #en 3))
      )
    (progn
      ;; �t�B���[�̈�A�C�e���̐}�`���Ɨ̈�_��(�␳�L)�̃��X�g���Z�o
      (setq #NEXT$ (PcGetFillerAreaItem$ #en))
      (setq #chgCAB nil)
      (setq #i 0)
      ;; �t�B���[�ݒu�\�אڐ}�`���X�g�̒������޲�ݸވȊO�̐}�`���擾
      (while (and (not #chgCAB) (< #i (length #NEXT$)))
        (setq #chgCAB (car (nth #i #NEXT$)))
        ;; �޲�ݸވȊO�̷���ȯ� �͋���
        (if (not (and (= CG_SKK_ONE_CAB (CFGetSymSKKCode #chgCAB 1)) ; ����
                      (/= CG_SKK_THR_DIN (CFGetSymSKKCode #chgCAB 3)); ���޲�ݸ�
            ))
          (setq #chgCAB nil)
        )
        (setq #i (1+ #i))
      ) ;_ while
      ;; �אڂ��޲�ݸވȊO�L���r���擾����Ă���΁A���ʐ}�`���ڂ��B
      ;; (�擾����Ȃ���΂��̂܂�)
      (if #chgCAB
        (setq #en #chgCAB)
      )
    )
  ) ;_ if

  ;; ���ʐ}�`�� �܂��� nil �Ԃ�
  #en
)

;<HOM>*************************************************************************
; <�֐���>    : PcGetFillerAreaItem$
; <�����T�v>  : �t�B���[�̈�A�C�e���}�`���Ɣ����␳�ϓ_��̃��X�g���Z�o
; <�߂�l>    : ((�}�`�� (�O�`��P�_)) (�}�`�� (�O�`��P�_))���)
; <�쐬>      : 02/04/04 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcGetFillerAreaItem$ (
  &eCAB       ; ��}�`��
  /
  #CHK$ #CHKREST$ #EADD$ #I #NEXT$ #NEXTFLG #REST$ #STOPFLG #UPPER$
  )  
  ;; �t�B���[�ݒu�\ �S�A�C�e���O�`��P�_���X�g�쐬
  ;; ((�}�`�� (�O�`��P�_)) (�}�`�� (�O�`��P�_))���)
  (setq #UPPER$ (PcGetUpperItemPL$))
  
  ; ��}�`�̊O�`��P�_���X�g��S�A�C�e�����X�g����E�o�A�אڊ1�Ƃ��Ď擾
  (setq #eADD$ (assoc &eCAB #UPPER$))
  (setq #NEXT$ (list #eADD$))
  (setq #REST$ (PcDelInList (list #eADD$) #UPPER$))

  ; �O�`��P�_���X�g����A��}�`�̗אڐ}�`���X�g#NEXT$���擾����
  (setq #stopFLG nil)
  (while (and (not #stopFLG) (setq #chkREST$ #REST$))
    (setq #stopFLG 'T)
    (while (and #stopFLG (setq #CHK$ (car #chkREST$)))
      ; #CHK$ �̗̈悪 #NEXT$ �̑S�̈�Ɨאڂ��邩�`�F�b�N����
      (setq #nextFLG nil)
      (setq #i 0)
      (while (and (not #nextFLG) (< #i (length #NEXT$)))
        (setq #nextFLG (PcJudgeCrossing (cadr #CHK$) (cadr (nth #i #NEXT$))))
        (setq #i (1+ #i))
      ); while
      ; �אڂ�����
      (if #nextFLG (progn
        ; #NEXT$ �אڃ��X�g�ɂ��̃��X�g��������
        (setq #NEXT$ (cons #CHK$ #NEXT$))
        ; #REST$���炱�̃��X�g�𔲂�
        (setq #REST$ (PcDelInList (list #CHK$) #REST$))
        ; �t���O�ύX
        (setq #stopFLG nil)
      )); if progn
      (setq #chkREST$ (cdr #chkREST$))
    ); while
  ); while

  #NEXT$
); PcGetFillerAreaItem$

;<HOM>*************************************************************************
; <�֐���>    : PcGetEn$CrossItemArea
; <�����T�v>  : �}�`�����X�g������A�C�e���̎w��͈͂ɏd���ʒu���閼���o
; <�߂�l>    : �}�`���̃��X�g �Ȃ�= nil
; <�쐬>      : 00/09/14 MH
; <���l>      : �ڂ���ʒu�̐}�`���擾���邩�ǂ����t���O�Ŕ��f
;*************************************************************************>MOH<
(defun PcGetEn$CrossItemArea (
  &eONE       ; �`�F�b�N���ɂȂ�}�`��
  &iL &iR &iF &iB ; �͈͂��w�肷�鍶�E�O��̐L�k�l(0�Ō��}�`�͈͂Ɠ��l)
  &flgNX      ; ���̃t���O�� 'T �Ȃ�A�w��͈͂ɐڂ���ʒu�̐}�`���擾
  &eCHK$      ; �`�F�b�N����ΏۂƂȂ�}�`�����X�g
  /
  #eCHK$ #dSQR$ #TEMP$ #eCHK #dCHK$ #pFLG #RES$
  )
  (setq #RES$ nil)
  (setq #eCHK$ &eCHK$)
  ;;; �͈͂ɐڂ���}�`���擾���Ȃ��̂Ȃ�A�͈͑S�̂�1mm�k������B
  (if (not &flgNX) (progn
    (setq &iL (1- &iL))
    (setq &iR (1- &iR))
    (setq &iF (1- &iF))
    (setq &iB (1- &iB))))
  (setq #dSQR$ (PcGetItem4P$ &eONE &iL &iR &iF &iB))
  ; �`�F�b�N�Ώۂ̐}�`���X�g�����r���̐}�`������
  (setq #eCHK$ (PcDelInList (list &eONE) #eCHK$))
  ; ����`�Ɗe�}�`�̕ӂ�����邩�A�_�͔͈͓��ɓ��邩�A���`�F�b�N
  (while (setq #eCHK (car #eCHK$))
    ;;; �`�F�b�N����A�C�e���̋�`�̈�S�_�����߂�
    (setq #dCHK$ (PcGetItem4P$ #eCHK 0 0 0 0))
    (setq #pFLG (PcJudgeCrossing #dSQR$ #dCHK$))
    (if #pFLG (setq #RES$ (cons #eCHK #RES$)))
    (setq #eCHK$ (cdr #eCHK$))
  ); end of while
  ; ���ʂ�Ԃ� nil �� ���X�g
  #RES$
); PcGetEn$CrossArea

;<HOM>*************************************************************************
; <�֐���>    : PcDelInList
; <�����T�v>  : ���X�g���̎w��̃��X�g���̗v�f�𔲂�
; <�߂�l>    : ���X�g �� nil
; <�쐬>      : 00/09/14 MH
;*************************************************************************>MOH<
(defun PcDelInList (#DEL$ #ORG$ / #TEMP$)
  (setq #TEMP$ nil)
  (foreach #OG #ORG$
    (if (not (member #OG #DEL$))
      (setq #TEMP$ (append #TEMP$ (list #OG))))
    )
  #TEMP$
); PcDelInList

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcGetUpperItemPL$
;;; <�����T�v>  : �t�B���[�����̈�擾�p �Ώې}�`+�̈�_�񃊃X�g�쐬
;;;             : �Ώې}�`�����X�g���� �V��t�B���[�s�A�C�e�����O
;;;             : �����𔲂����O�`�����X�g���Z�o���Ēǉ�
;;; <�߂�l>    : ((�}�`�� (�O�`���_��)) (�}�`�� (�O�`���_��))���) �܂��� nil
;;; <�쐬>      : 02/04/04 MH
;;; <���l>   * ϳ�Č^�ݼ�̰��,�������ق̓��X�g���珜�O
;;;          * �ݼ�̰�� �͗אڐ}�`���牜�s���擾
;;;          * ��Ű���ނ̂�P�ʂ���_��Z�o,���}�`��LSYM�̒l�œ_��Z�o
;;;*************************************************************************>MOH<
(defun PcGetUpperItemPL$ (
  /
  #DPL$ #DPT #DUM$$ #ECNR$ #EITEM$ #EUPPER$ #FD #GSYM$ #LSYM$ #RES$ 
  )

  ;; �}�ʒ�����S�A�b�p�[�����̃A�C�e�����X�g�擾
  (setq #eUPPER$ (KcSameLevelItem CG_SKK_TWO_UPP))

  ;; ̨װ�ݒu�ΏۂɂȂ�Ȃ��}�`���O�ƺ�Ű���ޕ���
  (setq #dum$$ nil)
  (setq #eCNR$ nil)  ;; ��Ű���ސ}�`���X�g 
  (foreach #en #eUPPER$
    (cond
      ;; �������� ���O 02/01/16 YM ADD-S
      ((= CG_SKK_ONE_SID (CFGetSymSKKCode #en 1))
      )
      ;; ϳ�Č^̰��"328" ���O 02/03/29MH@ADD
      ((= 328 (nth 9 (CFGetXData #en "G_LSYM")))
      )
      ;; ��Ű���ނ� �}�`���X�g�擾
      ((= CG_SKK_THR_CNR (CFGetSymSKKCode #en 3))
        (setq #eCNR$ (cons #en #eCNR$))
      )
       ;; ��Ű���ވȊO�̃t�B���[�ݒu�\�}�`���X�g
      (t (setq #dum$$ (cons #en #dum$$)))
    )
  )
  (setq #eITEM$ #dum$$)

  (setq #Res$ nil) ; ���ʃ��X�g������

  ;; ��Ű���� (�}�`�� (�O�`���_��)) ���ʃ��X�g�ǉ�
  (foreach #en #eCNR$
    (setq #dPL$ (PcCornerCabPLByPMen #en))
    (setq #Res$ (cons (list #en #dPL$) #Res$))
  )

  ;; ��Ű���ވȊO�̃t�B���[�ݒu�}�` (�}�`�� (�O�`���_��)) ���ʃ��X�g�ǉ�
  (foreach #en #eITEM$
    (setq #dPT (cdr (assoc 10 (entget #en))))
    (setq #LSYM$ (CFGetXData #en "G_LSYM"))
    (setq #GSYM$ (CFGetXData #en "G_SYM"))
    ;; ���s�l�擾
    ;; �}�`�������W�t�[�h�ł���Ηאڐ}�`��D�l�擾
    (if (= CG_SKK_ONE_RNG (CFGetSymSKKCode #en 1))
      (setq #fD (PcGetRange&SideFilrD #en #eUPPER$)) 
      ; ����ȊO�̐}�`
      (setq #fD (nth 4 #GSYM$))
    )
    ;; �Z�o���ꂽ���s����GSYM LSYM����_����o��
    (setq #dPL$ (PcMk4P$byWD&Ang #dPT (nth 3 #GSYM$) #fD (nth 2 #LSYM$)))
    (setq #Res$ (cons (list #en #dPL$) #Res$))
  );_ foreach

  ;; ���ʃ��X�g��Ԃ�
  #Res$

);_ PcGetUpperItemPL$

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcCornerCabPLByPMen
;;; <�����T�v>  : ��Ű���ނ�P�ʓ_�񂩂���ʂ��������O�`�_���X�g�Z�o
;;; <�߂�l>    : ���������_��i�Z�o�Ɏ��s�����ꍇP�ʍ\���_���Ԃ��j
;;; <�쐬>      : 02/04/04 MH
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PcCornerCabPLByPMen (
  &eCNR         ; ��Ű���ސ}�`��
  /
  #D0 #D1 #D2 #D2NEW #D3NEW #D4 #D4NEW #D5 #DNEW$ #DPMEN$
  #EN #EPMEN #ERR #FANG #GSYM$ #I #LSYM$ #PXD$ #UP-SS 
  )

  ;; �g�p�敪=2 ��P�ʂ�}�`�̃O���[�v�����猟��
  (setq #up-ss (CFGetSameGroupSS &eCNR))
  (setq #i 0)
  (setq #ePMEN nil)
  (while (and (not #ePMEN) (< #i (sslength #up-ss)))
    (setq #en (ssname #up-ss #i))
    (setq #pxd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
    (if (and #pxd$ (= 2 (car #pxd$))) (setq #ePMEN #en))
    (setq #i (1+ #i))
  )
  ;; �o�ʂQ�O�`�̈�_��
  (setq #dPmen$ (GetLWPolyLinePt #ePMEN))
  
;;; ��Ű����P�ʂ̍\���_����_�Ɛݒu�p�x���画�肵�ĕϐ��Ɋ�����
;;;
;;;       �ݒu�p�x                �ݒu�p�x
;;;  #d0     ��    #d1      #d1     ��     #d0
;;;   *-------------*         *-------------*
;;;   �b            �b        �b            �b
;;;   �b    #d3     �b        �b    #d3     �b
;;;   �b     *------*         *------*      �b   
;;;   �b     �b    #d2       #d2     �b     �b
;;;   �b     �b                      �b     �b
;;;   *------*                       *------*
;;;  #d5    #d4                     #d4     #d5
;;;
  (setq #err nil)
  (setq #LSYM$ (CFGetXData &eCNR "G_LSYM"))
  (setq #GSYM$ (CFGetXData &eCNR "G_SYM"))

  (setq #fANG (read (angtos (caddr #LSYM$) 0 3))); ����p�x
  (setq #d0 (cdr (assoc 10 (entget &eCNR)))) ; �R�[�i�[�L���r�̊�_���W
  (setq #d0 (list (car #d0) (cadr #d0)))

  ;; #d0����ݒu�p�x��ɂ���_ #d1
  (setq #d1 (PcFindAnglePnt #d0 #fANG #dPmen$ nil))
  (if (= nil #d1) (setq #err T))

  ;; #d0����ݒu�p�x+-90�x �ɂ���_ #d5
  (if (= nil #err)
    (progn
      (setq #d5 (PcFindAnglePnt #d0 #fANG #dPmen$ 'T))
      (if (= nil #d5) (setq #err T))
    )
  )  
  ; #d5����ݒu�p�x��ɂ���_ #d4 �����߂�
  (if (= nil #err)
    (progn
      (setq #d4 (PcFindAnglePnt #d5 #fANG #dPmen$ nil))
      (if (= nil #d4) (setq #err T))
    )
  )
  ;; #d1����ݒu�p�x+-90�x �ɂ���_ #d2
  (if (= nil #err)
    (progn
      (setq #d2 (PcFindAnglePnt #d1 #fANG #dPmen$ 'T))
      (if (= nil #d2) (setq #err T))
    )
  )  

  ; #d0 #d1 #d2 #d4 #d5 �܂Ŏ擾����Ă���ΐV�_�Z�o
  (if (= nil #err)
    (progn
      (setq #d2new (pcpolar #d1 (angle #d1 #d2) (+ (distance #d1 #d2) (- SKW_FILLER_DOOR))))
      (setq #d4new (pcpolar #d5 (angle #d5 #d4) (+ (distance #d5 #d4) (- SKW_FILLER_DOOR))))
      (setq #d3new (inters #d2new (pcpolar #d2new (angle #d1 #d0) 100)
                           #d4new (pcpolar #d4new (angle #d5 #d0) 100) nil)
      ); setq
      (setq #dNEW$ (list #d0 #d1 #d2new #d3new #d4new #d5 #d0))
    )
    ; �_���łĂ��Ȃ���΁A���̓_���X�g�����̂܂ܕԂ�
    (setq #dNEW$ #dPmen$)
  )
  #dNEW$
);_ PcCornerCabPLByPMen

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcFindAnglePnt
;;; <�����T�v>  : �_�񃊃X�g���A�p�x�����ɂ����ŏ��̓_��Ԃ�
;;; <�߂�l>    : �_���X�g�܂��� nil
;;; <�쐬>      : 02/04/04 MH
;;; <���l> �t���Onil = ��_���猟���p�x ��ɂ���_��Ԃ�
;;;        �t���O T  = ��_���猟���p�x�}90�x ��ɂ���_��Ԃ�
;;;*************************************************************************>MOH<
(defun PcFindAnglePnt (
  &chkP            ; ��_
  &fA              ; �����p�x
  &dALL$           ; �����_���X�g
  &90FLG           ; 90�x�t���O
  /
  #resP #i #P #fANG90 #fANG270
  )
  (setq #resP nil)
  (setq #i 0)
  (while (and (= nil #resP) (< #i (length &dALL$)))
    (setq #P (nth #i &dALL$))
    ;; ����_�ȊO��������p�x����
    (if (not (equal 0 (distance &chkP #P) 0.1))
      (cond
        ;; �t���O T = �w���p�x�}90�x�ɓ_������Ύ擾
        (&90FLG
         (setq #fANG90 (read (angtos (+ (angle &chkP #P) (* 0.5 pi)) 0 3)))
         (setq #fANG270 (read (angtos (+ (angle &chkP #P) (* -0.5 pi)) 0 3)))
         (if (or (equal &fA #fANG90 0.01)
                 (equal &fA #fANG270 0.01)
             )
           (setq #resP #P)
         )
        )
        ;; �w���p�x�ゾ������擾
        (t
         (if (equal &fA (read (angtos (angle &chkP #P) 0 3)) 0.01)
           (setq #resP #P)
         )
        )
      ) ;_ cond
    ) ;_if
    (setq #i (1+ #i))
  ) ;_ while

  #resP
) ;_ PcFindAnglePnt

;<HOM>*************************************************************************
; <�֐���>    : PcGetRange&SideFilrD
; <�����T�v>  : �����W�t�[�h,�T�C�h�p�l�� �אڃA�C�e������t�B���[�p�␳���s�l���Z�o
; <�߂�l>    : ���l
; <�쐬>      : 00/10/02 MH
;*************************************************************************>MOH<
(defun PcGetRange&SideFilrD (
  &eONE       ; �ΏۂƂȂ�}�`��(�����W���T�C�h�p�l��)
  &eUPPER$    ; �}���̃A�b�p�[�A�C�e�����X�g
  /
  #eNT_L$ #eNT_R$ #jANG #eN #eNT_L #eNT_R #fD #eNT$ ##difANG
  )
  (defun ##difANG (&ent$ &jANG / #eN #temp$)
    (setq #temp$ nil)
    (foreach #eN &ent$
      (if (equal &jANG (atof (angtos (nth 2 (CFGetXData #eN "G_LSYM")) 0 3)) 0.001)
        (setq #temp$ (cons #eN #temp$))
      ); if
    ); foreach
    #temp$
  ); ##difANG

  ; �܂��A�A�C�e���̉E���אڂ����(�X�y�[�T�[�΍��20mm�g��)
  (setq #eNT_L$ (PcGetEn$CrossItemArea &eONE 20 0 0 0 'T &eUPPER$))
  (setq #eNT_R$ (PcGetEn$CrossItemArea &eONE 0 20 0 0 'T &eUPPER$))
  ; 01/04/09 MH MOD �����[�ɑ΍�Ŋp�x�̈Ⴄ�}�`�͎Q�Ƃ��Ȃ��悤�ύX
  ; �擾���ꂽ�אڐ}�`���A�ݒu�p�x���قȂ�}�`�����O
  (setq #jANG (atof (angtos (nth 2 (CFGetXData &eONE "G_LSYM")) 0 3)))
  (setq #eNT_L$ (##difANG #eNT_L$ #jANG))
  (setq #eNT_R$ (##difANG #eNT_R$ #jANG))

  (if (car #eNT_L$) (setq #eNT$ (cons (car #eNT_L$) #eNT$)))
  (if (car #eNT_R$) (setq #eNT$ (cons (car #eNT_R$) #eNT$)))

  (cond
    ; ��Ƃ������W�ȊO�̃A�C�e���Ȃ�Ώ��̕��̉��s��
    ((and #eNT$ (< 1 (length #eNT$))
          (not (= CG_SKK_ONE_RNG (CFGetSymSKKCode (car #eNT$) 1)))
          (not (= CG_SKK_ONE_RNG (CFGetSymSKKCode (cadr #eNT$) 1)))
     ); and
      (setq #fD (min (PcChk750CentrItemD (car #eNT$))
                     (PcChk750CentrItemD (cadr #eNT$))))
    )
    ; ����̂ݎ擾�ň�ʃA�C�e���܂��́A��Ƃꂽ���̍ŏ�����ʃA�C�e��
    ((and #eNT$ (< 0 (length #eNT$))
                (not (= CG_SKK_ONE_RNG (CFGetSymSKKCode (car #eNT$) 1))))
      (setq #fD (PcChk750CentrItemD (car #eNT$)))
    )
    ; ��Ƃꂽ���̓�߂���ʃA�C�e��
    ((and #eNT$ (< 1 (length #eNT$))
                (not (= CG_SKK_ONE_RNG (CFGetSymSKKCode (cadr #eNT$) 1))))
      (setq #fD (PcChk750CentrItemD (cadr #eNT$)))
    )
    ; �ΏۃA�C�e�����T�C�h�p�l���Ń����W�t�[�h���אڂȂ�{�֐�����A������
    ((and #eNT$ (= CG_SKK_ONE_SID (CFGetSymSKKCode &eONE 1))
                (= CG_SKK_ONE_RNG (CFGetSymSKKCode (car #eNT$) 1)))
      (setq #fD (PcGetRange&SideFilrD (car #eNT$) &eUPPER$))
    )
    ; �����܂łŎ擾�ł��Ȃ������珊����ŏ��l���o�B���Ȃ���΃A�C�e�����̂�D�l������
    ; �T�C�h�p�l�����̂̉��s���␳�H�H�H
    (t (setq #fD (PcGetMinDinRow &eONE &eUPPER$))
    )
  ); cond
  #fD
); PcGetRange&SideFilrD

;<HOM>*************************************************************************
; <�֐���>    : PcGetMinDinRow
; <�����T�v>  : ��}�`�̍��E�אڐ}�`���A�ŏ��̉��s�l���o��
; <�߂�l>    : ���l
; <�쐬>      : 01/02/04 MH �ύX
;*************************************************************************>MOH<
(defun PcGetMinDinRow (
  &eONE       ; ��Ƃ���}�`��
  &eCHK$      ; �`�F�b�N�Ώې}�`�����X�g
  /
  #fD ;02/03/29MH@ADD
  #eNEXT$ #minD #eNT
  )
  (setq #eNEXT$ (PcGetNextSimilarItem$ "SameAng" "L" &eONE nil &eCHK$))
  (setq #eNEXT$ (PcGetNextSimilarItem$ "SameAng" "R" &eONE #eNEXT$ &eCHK$))

  ; �擾���ꂽ�אڃA�C�e���̂����ŏ���D�l���o
  ; ��L���r��D�l���܂��ݒ�
  (setq #minD (nth 4 (CFGetXData &eONE "G_SYM")))
  (foreach #eNT #eNEXT$
    (if (> #minD (setq #fD (nth 4 (CFGetXData #eNT "G_SYM"))))
      (setq #minD #fD)
    ); if
  ); foreach
  #minD
); PcGetMinDinRow

;<HOM>*************************************************************************
; <�֐���>    : PcMk4P$byWD&Ang
; <�����T�v>  : W�l��D�l�Ɗp�x����2������4�_���X�g���쐬
; <�߂�l>    : �S�_���X�g (��_ �E�_ �O�E�_ �O���_)
; <�쐬>      : 00-10-03 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcMk4P$byWD&Ang (&dB &fW &fD &fANG / #spP1 #spP4 #RES$ )
  (if (and (numberp (car &dB)) (numberp (cadr &dB))
           (numberp &fW) (numberp &fD) (numberp &fANG))
    (progn
      (setq #spP1 (list (car &dB) (cadr &dB)))
      ; 01/01/19 MH MOD �������|�����C���ɔ��������� �I�t�Z�b�g�l�𓝈�
      (setq #spP4 (Pcpolar #spP1 (+ (* -0.5 pi) &fANG) (- &fD SKW_FILLER_DOOR)))
      (setq #RES$
        (list #spP1 (Pcpolar #spP1 &fANG &fW) (Pcpolar #spP4 &fANG &fW) #spP4))
    ); progn
    (setq #RES$ nil)
  );_ if
  #RES$
); PcMk4P$byWD&Ang

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcGetFilerOfsP&PL$
;;; <�����T�v>  : �t�B���[�ݒu�̈�_��(�����Ȃ�)�ƃI�t�Z�b�g�_�̎Z�o
;;; <�߂�l>    : ((ofs�_  (�_��)) (ofs�_  (�_��)))
;;; <�쐬>      : 00/10/04 MH  02/04/05 MH ��������
;;; <��Ǝ菇> �@ ��}�`�Ɨאڂ���t�B���[�ݒu�\�}�` �S�̗̂̈�\���_��擾   
;;;            �A �אڂ���t�B���[�ݒu�\�}�`���̑S��Ű����ؽĂ��쐬
;;;            �B ��Ű���ނ̐��ɂ�� I�^�AL�^U�^�̃^�C�v�𔻒�A�̈�\���_�񂩂�
;;;               �t�B���[�ݒu�_��ƃI�t�Z�b�g�_���Z�o�������ʃ��X�g�Ƃ���B
;;;
;;; <���l>  * �t�B���[�̈�́A��Ű���ނ̂ݐ}�`�o�ʂ���Z�o
;;;           ���̑��̐}�`�́AG_SYM�̊�_�AD�l�AW�l�ɂ����̂Ƃ���B
;;;         * I �^�őO�ʁA�w�ʂ̂ݍ��E�Ȃ��̃v�����̂�2�g�̃��X�g�ɂȂ�
;;;           ���̑��͏��1�g�̃��X�g���Ԃ�
;;;         * I �^�Ŕw�ʂɎw�����������ꍇ�̂ݕ����_��ɂȂ�
;;;          �i���̏ꍇ�A�_�񃊃X�g�̓��ƍŌオ���_�j
;;;*************************************************************************>MOH<
(defun PcGetFilerOfsP&PL$ (
  &eCAB       ; ��̃E�H�[���ʒu�}�`��
  &fOF        ; �I�t�Z�b�g�l
  &PLNFLG     ; �v������������N�����ꂽ�Ȃ�'T  �t���[�݌v�Ȃ�nil
  /
  #BSP #DPL$ #DUM$$ #ECAB #ECNR$ #FANG #LFRPT$ #NEXT$ #OFP&PL$ #RES$ #XLD$
  )
  ;;****************************************************************
  ;; ��}�`�̗אڂ���}�`�̈�̓_�񃊃X�g�i�����v�܂��j���쐬
  ;;****************************************************************  
  
  ;; ��}�`����K�v�l�擾
  (setq #XLD$ (CFGetXData &eCAB "G_LSYM"))
  (setq #bsP (cdr (assoc 10 (entget &eCAB))))
  (setq #bsP (list (car #bsP) (cadr #bsP)))
  (setq #fANG (nth 2 #XLD$))

  ;; �t�B���[�̈�A�C�e���̐}�`���Ɨ̈�_��(�␳�L)�̃��X�g���Z�o
  ;; ((�}�`�� (�O�`��P�_)) (�}�`�� (�O�`��P�_))���)
  (setq #NEXT$ (PcGetFillerAreaItem$ &eCAB))
  ;; ���X�g�̓_���ذ�ޮݍ쐬�A�����A�̈�S�̂̊O�`�̈�_��擾
  (setq #dum$$ (mapcar 'cadr #NEXT$)); �_��̂݃��X�g�ɕϊ�
  (setq #dPL$ (PcUnionRegion #dum$$))

  ;; �_��𔽎��v���ɂ���B��}�`�̊p�x���r,���v���Ȃ烊�o�[�X���s
  (setq #dPL$ (PcReverseClockWisePL #dPL$ #bsP #fANG))    

  ;; �אڐ}�`���X�g�����纰Ű����ؽ�((�}�`�� LR����) (�}�`�� LR����)) ����
  (setq #dum$$ (mapcar 'car #NEXT$))
  (setq #eCNR$ (PcGetCornerList #dum$$ #fANG))

  ;;*******************************************************************
  ;; �t�B���[�̈�\���_�񂩂�̾�ē_�ƃt�B���[�쐬�p�_�񃊃X�g���쐬
  ;;******************************************************************* 
  ;; �̈撆�̺�Ű���ނ̐��ɂ��h�^ �k�^ �t�^ ����
  (cond
    ;; �h�^ (���p�L���r�Ȃ�)
    ((= 0 (length #eCNR$))
     (setq #RES$ (PcGetOffsetPAndPLtypeI #dPL$ #fANG &fOF))
     (setq #LFRpt$ (car #RES$))
     (setq #ofP&PL$ (cadr #RES$))
    );_ �h�^

    ;; �k�^ �t�^���� (���p�L���r�̐� �P���Q)
    ((>= 2 (length #eCNR$))
     (setq #ofP&PL$ (PcGetOffsetPAndPLtypeLU #dPL$ #eCNR$ &fOF))
     (setq #LFRpt$ (cadr (car #ofP&PL$)))
    );_ �k�^ �t�^

    ;; ����ȏ�̓G���[���~
    (t
     (CFAlertMsg "�͈͒��ɋ��p�L���r�l�b�g��2�ȏ㌟�o����܂���")
     (exit)
    )
  );_ cond
  
  ;;**********************************
  ;; ���s���������O���[�o���ϐ��ݒ�
  ;;**********************************  
  ;; #LFRpt$ = �����Ӂ]�����]�E���� �̃|�����C���_��(�t���v�܂��)

  ;; �����s��������
  (if (= SKW_FILLER_LSIDE 1)
    ;; THEN �_ؽĂ̐擪�Q�_�������s�����̒����Ƃ���B
    (setq SKW_FILLER_LLEN (distance (car #LFRpt$) (cadr #LFRpt$)))
    ;; ELSE �Ȃ����0
    (setq SKW_FILLER_LLEN 0.0)
  );_ end if
  
  ;; �E���s��������
  (if (= SKW_FILLER_RSIDE 1)
    ;; THEN �_ؽĂ̍Ō���Q�_���E���s�����̒����Ƃ���B
    (progn
      ;; �Ō���̂Q�_����邽�߂ɓ_�񃊃o�[�X�A�Q�_�Ԃ����s�Ƃ���B
      (setq #LFRpt$ (reverse #LFRpt$))
      (setq SKW_FILLER_RLEN (distance (car #LFRpt$) (cadr #LFRpt$)))
    )
    ;; ELSE �Ȃ����0
    (setq SKW_FILLER_RLEN 0.0)
  );_ end if

;;�m�F�p
;;;(princ "SKW_FILLER_LSIDE")
;;;(princ SKW_FILLER_LSIDE)
;;;(princ SKW_FILLER_LLEN)
;;;(princ "SKW_FILLER_RSIDE")
;;;(princ SKW_FILLER_RSIDE)
;;;(princ SKW_FILLER_RLEN )
  
  (setq SKW_FILLER_LSIDE 0)
  (setq SKW_FILLER_RSIDE 0)

  ;; ���ʃ��X�g��Ԃ� ((ofs�_  (�_��))�������)
  #ofP&PL$
)
;_ PcGetFilerOfsP&PL$

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcGetOffsetPAndPLtypeI
;;; <�����T�v>  : I �^�z�� �V��t�B���[�ݒu�|�����C���_��ƃI�t�Z�b�g�_�擾
;;; <�߂�l>    : ��Ŏg��  #LFRpt$  �_��ƁA �t�B���[�w�����X�g���� ���X�g 
;;;             : ((�̾�ē_ (�_��))) �܂��� ((�̾�ē_ (�_��)) (�̾�ē_ (�_��)))  
;;; <�쐬>      : 02/04/05 MH
;;; <���l>  * �w�ʂ��� ���E�Ȃ��̃v�����̂� 2�g�̃��X�g�ɂȂ邻�̑��͏��1�g
;;;         * �w�ʂ���A���E����̎w���̏ꍇ�̂ݕ����_��ɂȂ�B
;;;*************************************************************************>MOH<
(defun PcGetOffsetPAndPLtypeI (
  &dPL$       ; �̈�_��i�����|�����C���Ŕ����v���j
  &fANG       ; ��}�`�̊p�x
  &fOF        ; �I�t�Z�b�g�l
  /
  #ALLPL$ #BACKFLG #BACKPL$ #BCLP #BCRP #CHKANG #DPL$ #DUM$$ #FA1 #FRONTPL$
  #I #OFP&PL$ #OFSP #STOPFLG #LFRPT$ 
  )

  ;; �w�ʐݒu�t���O #backFLG �w�ʂ���= 'T
  (if (= 1 SKW_FILLER_BSIDE) ;; �_�C�A���O�̔w�ʃg�O�����I��
    (setq #backFLG 'T)
    (setq #backFLG nil)
  )

  ;;*******************************************************************
  ;; �̈�\���_��ƁA��}�`�̊p�x���r�A�w�ʍŉE�_�A�w�ʍō��_������
  ;; �\�����𔽎��v�܂��̔w�ʃ|�����C���ƑO�ʃ|�����C���ɕ�������
  ;; �i�O�ʁA�w�ʂƂ��ɓʉ����Ă���\��������j
  ;;*******************************************************************
;;;     �w�ʍō��_              ��     �w�ʍŉE�_
;;;       #bcLP       �w�ʃ|�����C��     #bcRP
;;;        + ----------------------------- +   
;;;                 
;;;        �b                              �b    �w�ʃ|�����C���ȊO
;;;     �� �b                              �b ��    = �O�ʃ|�����C��
;;;        + ----------------------------- +
;;;                         ��
  
  (setq #dPL$ &dPL$)
  ;; ����p�x���A���O���ɕϊ�
  (setq #fA1 (read (angtos &fANG 0 3)))
  ;; ����p�ɓ_�񂩂�\�������X�g�쐬
  (setq #allPL$ (PcMkLine$byPL$ #dPL$ 'T))
  
  ;; �w�ʐ����X�g#backL$ �擾   ����= ��}�`�Ɗp�x180�x�t�̐�
  (setq #backPL$ nil)
  (foreach #chkL #allPL$
    ;; �I�_���n�_�p�x
    (setq #chkANG (angle (cadr #chkL) (car #chkL)))
    ;; �`�F�b�N�}�`�p�x���A���O���ɕϊ� 
    (setq #chkANG (read (angtos #chkANG 0 3)))
    (if (equal #fA1 #chkANG 0.01)
      (setq #backPL$ (cons #chkL #backPL$)))
  );_ foreach

  ;; �w�ʐ����X�g#backPL$ ���� �ō��_ �ƍŉE�_ ���Z�o
  (setq #bcLP (PcGetSidePinPL$ #backPL$ &fANG "L")) ; #backPL$���� �ō��_
  (setq #bcRP (PcGetSidePinPL$ #backPL$ &fANG "R")) ; #backPL$���� �ŉE�_

  ;; �O�`�̈�_�� #dPL$ �� �w�ʍō��_ #bcLP �����ɂ���悤���בւ�
  (setq #dPL$ (PcOrderPL$byOneP #dPL$ #bcLP))

  ;; �����v���O�`�̈�_�� #dPL$ ���A�w�ʃ|�����C���ƑO�ʃ|�����C���ɕ���

  ;; #backPL$ �w�ʃ|�����C�����X�g
  (setq #dum$$ #dPL$)
  (while (and (car #dum$$)
              (not (equal #bcRP (car #dum$$) 0.01))
         )
    (setq #dum$$ (cdr #dum$$))
  ); while
  (setq #backPL$ (append #dum$$ (list (car #dPL$))))

  ; #frontPL$ = �O�ʃ|�����C��
  (setq #i 0)
  (setq #dum$$ nil)
  (setq #stopFLG nil)
  (while (and (not #stopFLG) (< #i (length #dPL$)))
    (setq #dum$$ (append #dum$$ (list (nth #i #dPL$))))
    (if (equal #bcRP (nth #i #dPL$) 0.01)
      (setq #stopFLG 'T)
    )
    (setq #i (1+ #i))
  ); while
  (setq #frontPL$ #dum$$)

  ;;**********************************************
  ;; �O�ʁA�w�ʁA�_����w����ԕ��I�t�Z�b�g���s
  ;;**********************************************
  ;; 02/04/10MH ���ӏ���  
  ;; I�^�̵̾�ē_���v�����S�̂̒����łƂ��Ă��܂����A�ȉ��̕s�������܂��B
  ;; ��D�l�̈قȂ�L���r�l�b�g��2�̃v�����A����� �ʕ��A����������
  ;;   ̨װ�̈悪���E�Ώ̂ȃv�����ŵ̾�Ă��w���_�Ƌt�Ɋ|����B
  ;; �����Ƃ����̂���쓮����Ԃ悤�Ȃ̂ŁA���̌������ɂȂ����Ƃ���
  ;; �̈�̊�L���r�l�b�g��̒����_��̾�ē_�ɂ���悤�{�֐���ύX���Ă݂Ă��������B
  
  ;; �I�t�Z�b�g�_ = �O�ʃ|�����C��#frontPL$ �S�̂̒���
  (setq #ofsP (Pcpolar (car #frontPL$) (angle (car #frontPL$) (last #frontPL$))
                       (* 0.5 (distance (car #frontPL$) (last #frontPL$))))
  )
  (setq #ofsP (Pcpolar #ofsP (+ &fANG (* -0.5 pi))
                       (* 0.5 (distance (car #frontPL$) (cadr #frontPL$))))
  )

  ;; �O�ʂƔw�ʂ̃I�t�Z�b�g�������s
  ;; �w�ʐݒu����Ȃ�A�w�ʃ|�����C�����I�t�Z�b�g����
  (if #backFLG
    (setq #backPL$ (PcOffsetFilerBCPL$ #backPL$ #ofsP &fOF &fANG))
  )
  ;; �O�ʃ|�����C����ԕ��I�t�Z�b�g ����
  (setq #frontPL$ (PcOffsetFilerPL$  #frontPL$ #ofsP &fOF nil nil))

  ;;***************************************************
  ;; ���ʁA�w�ʂ̎w��ɉ����Ē�o���X�g�̉��H����
  ;;***************************************************
  ;; �w�ʃ|�����C���ƑO�ʃ|�����C�������H���Ĉȉ��̃P�[�X�ɑΉ�
  ;; �@���E���ʂȂ�  �O�� �{ ����  �i���� 2���X�g�j        
  ;; �A���E���ʂȂ�  �O�ʂ̂�       (�O�ʃ��X�g�̂�)
  ;; �B���E���ʂ���  �O�� �{ ����   (��̕����|�����C���ɉ��H)
  ;; �C�����ʂ̂�    �O�� �{ ����   (�O�ʂ���Ō�̓_�𔲂��āA�w�ʃ|�����C���ƌ���)         
  ;; �D�E���ʂ̂�    �O�� �{ ����   (�O�ʂ���ŏ��̓_�𔲂��āA�w�ʃ|�����C���ƌ���) 
  ;; �E�����ʂ̂�    �O�ʂ̂�       (�O�ʂ���Ō�̓_�𔲂��j
  ;; �F�E���ʂ̂�    �O�ʂ̂�       (�O�ʂ���ŏ��̓_�𔲂��j
  
  (setq #LFRpt$  nil) ;_ �T�C�h���s���擾�p�̓_�񃊃X�g
  (setq #ofP&PL$ nil)
  (if (= 0 (+ SKW_FILLER_LSIDE SKW_FILLER_RSIDE))
    ;; �@���E���ʂȂ�  �O�� �{ ����  �i���� 2���X�g�j        
    ;; �A���E���ʂȂ�  �O�ʂ̂�       (�O�ʃ��X�g�̂�)
    (progn
      ;; �w�ʐݒu����i�w�ʃ|�����C���ƑO�ʃ|�����C���łQ���X�g�K�v�j
      ;; ���ʃ��X�g�ɔw�ʃ|�����C�����X�g��ݒ�
      (if #backFLG
        (setq #ofP&PL$ (list (list #ofsP #backPL$)))  
      )
      ;; �o�_���X�g���獶�E���Ǔ_�𔲂����_��쐬
      (setq #i 1)
      (setq #dum$$ nil)
      (while (< #i (1- (length #frontPL$)))
        (setq #dum$$ (append #dum$$ (list (nth #i #frontPL$))))
        (setq #i (1+ #i))
      );_ while

      ;; ���ʃ��X�g�ɑO�ʃ|�����C���̃��X�g��������
      (setq #ofP&PL$ (cons (list #ofsP #dum$$) #ofP&PL$))
    )
    (progn
      ;; 00/10/25 SN ADD ����-�O��-�E���̏��ɕ��񂾂Ƒz�肵���_ؽ�
      (setq #LFRpt$ #frontPL$)
      ;; �O�ʃ|�����C�����H ���ʍ��E�t���O���瑤�ʕ��̓_��������
      ;; �E�����ʂ̂�    �O�ʂ̂�       (�O�ʂ���Ō�̓_�𔲂��j
      ;; �F�E���ʂ̂�    �O�ʂ̂�       (�O�ʂ���ŏ��̓_�𔲂��j
      (setq #frontPL$ (PcPL$SidePart #frontPL$ &fOF))

      ;; �w�ʂ���̏ꍇ�A�w�ʓ_�� #backPL$ ����������
      ;; �B���E���ʂ���  �O�� �{ ����   (��̕����|�����C���ɉ��H)
      ;; �C�����ʂ̂�    �O�� �{ ����   (�O�ʂ���d���_�𔲂��A�w�ʃ|�����C���ƌ���)         
      ;; �D�E���ʂ̂�    �O�� �{ ����   (�O�ʂ���d���_�𔲂��A�w�ʃ|�����C���ƌ���) 
      (cond
        ;; �����ʂ݂̂���
        ((and #backFLG (= 0 SKW_FILLER_RSIDE))
          (setq #frontPL$ (append (reverse (cdr (reverse #backPL$))) #frontPL$))
        )
        ;; �E���ʂ݂̂���A���邢�� ���E���ʂƂ��ɂ���
        (#backFLG
          (setq #frontPL$ (append #frontPL$ (cdr #backPL$)))
        )
      ); cond

      ;; ���ʂ����X�g�ɃZ�b�g
      (setq #ofP&PL$ (list (list #ofsP #frontPL$)))
    ) 
  );_ if

  ;; ���ʃ��X�g��Ԃ�  #LFRpt$ �� ���E �Ȃ��̏ꍇ�͎g�p����Ȃ����� nil�l
  (list #LFRpt$ #ofP&PL$)
)
;_ PcGetOffsetPAndPLtypeI

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcGetOffsetPAndPLtypeLU
;;; <�����T�v>  : �k�^�t�^�z�񋤒� �V��t�B���[�ݒu�|�����C���_��Ƶ̾�ē_�擾
;;; <�߂�l>    : ���X�g ((#LFRpt$�_��)   (�̾�ē_ (�_��)) ) 
;;; <�쐬>      : 02/04/08 MH
;;; <���l>      
;;;*************************************************************************>MOH<
(defun PcGetOffsetPAndPLtypeLU (
  &dPL$       ; �̈�_��i�����|�����C���Ŕ����v���j
  &eCNR$      ; ((�}�`�� LR����) (�}�`�� LR����)) L�^ �͗v�f�͈��
  &fOF        ; �I�t�Z�b�g�l
  /
  #BSP #DPL$ #EBASE #ECNR$ #ENCHK #FRONTPL$ #OFSP #SLR #XD$ #XLD$
  )
  (setq #eCNR$ &eCNR$)
  
  ;; U�^�̏ꍇ�A��Ű���ނ̃��X�g��(��������  �E������) �ɕ��בւ�
  (if (= 2 (length #eCNR$))
    (progn
      (setq #enChk (car (last #eCNR$)))
      (setq #XLD$ (CFGetXData #enChk "G_LSYM"))
      (setq #bsP (cdr (assoc 10 (entget #enChk))))
      (setq #bsP (list (car #bsP) (cadr #bsP)))
      ;; ��ڃL���r�̊�_����ݒu�p�x�̉�������Ɉ�ڃL���r�̊�_��
      ;; ����ꍇ�͏��Ԃ����ւ�
      (if (PcIsExistPOnLine (list #bsP (Pcpolar #bsP (nth 2 #XLD$) 10000))
                            (list (cdr (assoc 10 (entget (car (car #eCNR$)))))))
        (setq #eCNR$ (reverse #eCNR$))
      );_ if
    )
  );_if
  
  ;; L�^�̏ꍇ���̂܂� U�^�̏ꍇ�A�E���̺�Ű���ނ���}�`�Ɏw��
  (setq #eBASE (car (last #eCNR$))) 
  (setq #sLR (cadr (last #eCNR$))) 
  (setq #dPL$ &dPL$)
  (setq #XD$ (CFGetXData #eBASE "G_SYM"))
  (setq #XLD$ (CFGetXData #eBASE "G_LSYM"))

  (setq #bsP (cdr (assoc 10 (entget #eBASE))))
  (setq #bsP (list (car #bsP) (cadr #bsP)))

  ;; �R�[�i�[�Ƃ��ă_�C�j���O�L���r���n���Ă����ꍇ�̊�_�ړ�
  (if (= CG_SKK_THR_DIN (CFGetSymSKKCode #eBASE 3))
    (progn
      (setq #bsP (Pcpolar #bsP (- (nth 2 #XLD$) (* 0.5 pi)) (- (nth 4 #XD$) SKW_FILLER_DOOR)))
      (if (= "R" #sLR) ; �E������
        (setq #bsP (Pcpolar #bsP (nth 2 #XLD$) (nth 3 #XD$)))
      ); if
    )
  );_ if

  ;;*******************************************************************
  ;; �̈�\���_��i�����v���j��Ű���ފ�_�擪�ɕ��т���
  ;; �O�ʃ|�����C���݂̂̓_����擾����B
  ;;*******************************************************************
;;;
;;; �t�^�́A�̈�\���_����E��Ű���ފ�_�擪�ɕ��בւ�����A
;;; �擪��2�_���폜���邱�ƂŁA�O�ʃ|�����C���_��쐬
;;;
;;;    ����Ű���ފ�_     ��     #�_��擪 = �E��Ű���ފ�_
;;;     �_��2�_��                   �_��1�_��           
;;;        ��� � � � � � � � � � � � � ��   
;;;        �                            �  
;;;     �� �                            �                                
;;;        �     +---------------+      �
;;;        �     �b       ��     �b     � ��
;;;        �     �b�O��          �b     �
;;;        �     �b�|�����C���_��b     �
;;;        +-----+               +------+
;;;
;;; �k�^�́A�̈�\���_����E��Ű���ފ�_�擪�ɕ��בւ�����A
;;; �擪��1�_���폜���邱�ƂŁA�O�ʃ|�����C���_��쐬                          
;;;
;;;  #�_��擪(��Ű���ފ�_)           
;;;        ��� � � � � � � � � � +  
;;;        �                     �b  
;;;     �� �                     �b                                  
;;;        �     +---------------+
;;;        �     �b           ��       
;;;        �     �b ��           
;;;        �     �b      �O�ʃ|�����C���_�� 
;;;        +-----+   
;;;
  
  ;; �����v�܂��O�`�̈�_������p�L���r�̊�_�����ɂ���悤���בւ�
  (setq #dPL$ (PcOrderPL$byOneP #dPL$ #bsP))
  ;; ���p�L���r�̊�_�𔲂��āA�J�����O�ʃ|�����C���_���X�g�ɉ��H
  (repeat (length #eCNR$) (setq #dPL$ (cdr #dPL$)))
  (setq #frontPL$ #dPL$)

  ;; �I�t�Z�b�g�_�擾 (AutoCad�̃o�O�Ȃ̂��A�����̉��z��_���I�t�Z�b�g�_��
  ;; ����Ƌt�����Ɏ��s����� �����ɋ߂��I�t�Z�b�g��_�����_��)
  (setq #ofsP (pcpolar (car #frontPL$) (angle (car #frontPL$) (cadr #frontPL$))
    (* 0.5 (distance (car #frontPL$) (cadr #frontPL$)))))
  (setq #ofsP (pcpolar #ofsP (angle (cadr #frontPL$) (caddr #frontPL$))
    (* 0.5 (distance (cadr #frontPL$) (caddr #frontPL$)))))

  ;;********************************
  ;; �O�ʁA�w����ԕ��I�t�Z�b�g
  ;;********************************  
  (setq #frontPL$ (PcOffsetFilerPL$ #frontPL$ #ofsP &fOF (mapcar 'car #eCNR$) nil))

  ;;***********************************************
  ;; ���ʂ̎w��ɉ����đO�ʃ|�����C�����X�g�̉��H
  ;;***********************************************
  (setq #frontPL$ (PcPL$SidePart #frontPL$ &fOF))

  ;; ���ʂ�Ԃ�
  (list (list #ofsP #frontPL$))
)
;_ PcGetOffsetPAndPLtypeLU 

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcChkCornerDinning
;;; <�����T�v>  : �`�F�b�N�Ώې}�`�����z�u�̃_�C�j���O�L���r�Ȃ�� 'T
;;; <�߂�l>    : T or nil
;;; <�쐬>      : 02/04/08 MH
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PcChkCornerDinning (
  &eCHK
  &NEXT$
  /
  #FLG #eBF #eBF$
  )
  (setq #FLG nil)
  (cond
    ; �޲�ݸޗp��?
    ((/= CG_SKK_THR_DIN (CFGetSymSKKCode &eCHK 3))
     (setq #FLG nil)
    )
    ;_ �}�` �O��̗אڂ���p�x�łȂ����_�C�j���O�ȊO�̏ꍇ T
    (t
     (setq #eBF$ (PcGetEn$CrossArea &eCHK -5 -5 0 0 'T)) ; �}�`�̑O��̐}�`���E�o
     ; �אڃ��X�g���ɑO��}�`�������T
     (foreach #eBF #eBF$
       (if (member #eBF &NEXT$) (setq #FLG 'T)) 
     )
    )
  );_ cond
  #FLG
)
;_ PcChkCornerDinning

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcUnionRegion
;;; <�����T�v>  : �אڃ��X�g�̓_�񂷂ׂă��[�W�����������A�S�̂̓_����o��
;;; <�߂�l>    : �����_�񃊃X�g
;;; <�쐬>      : 02/04/05 MH
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun PcUnionRegion (
  &dPL$       ; ��������|�����C���_�񃊃X�g
  /
  #dRES$ #NT_regn #OutPline #r-ss 
  )
  ;; 
  (setq #NT_regn (ssadd))
                           
  ;; �S�אڐ}�`�̊O�`�������[�W������
  (foreach #NT$ &dPL$
    (MakeLwPolyLine #NT$ 1 0)
    (command "_region" (entlast) "")
    (ssadd (entlast) #NT_regn)
  );_ foreach

  ;; ���[�W������1�P�ȏ�Ȃ猋�����Ĉ�ɂ���
  (if (< 1 (sslength #NT_regn)) (command "_union" #NT_regn ""))
  ;; REGION�𕪉����A���������������|�����C��������
  (command "_explode" (entlast))
  (setq #r-ss (ssget "P"))

  (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ���ײ݂̑I�����I��
  (setq #OutPline (entlast))

  ;; �S�O�`�̈�_������߂�
  (setq #dRES$ (GetLWPolyLinePt #OutPline))
  (entdel #OutPline )

  ;; ���ʂ̓_���Ԃ�
  #dRES$
)
;_ PcUnionRegion

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcReverseClockWisePL
;;; <�����T�v>  : �_��Ɗ�}�`�̐ݒu�p�x���r,���v���Ȃ烊�o�[�X���s
;;; <�߂�l>    : �t���v���̓_�񃊃X�g
;;; <�쐬>      : 02/04/05 MH
;;; <���l>      * ��_��ɂ���\����(�w�ʐ�)�̊p�x����p�x�Ɠ����Ȃ�A
;;;               ���v���Ɣ��肵�ă��o�[�X���s
;;;*************************************************************************>MOH<
(defun PcReverseClockWisePL (
  &dPL$      ; �|�����C���_�񃊃X�g
  &dPT       ; ��}�`�̊�_
  &fAng      ; ��}�`�̊p�x(���W�A��)
  /
  #ANG #CHKANG #CHKL #I #LINE$ #LINEALL$ #ONLINE #REVFLG #dRES$
  )
  ;; ����_���X�g���o�������X�g�ɕϊ�
  (setq #Line$ (PcMkLine$byPL$ &dPL$ 'T))

  ;; ����p�Ɋp�x���A���O����
  (setq #ang (read (angtos &fAng 0 3)))

  (setq #i 0)
  (setq #revFLG nil)
  (while (and (= nil #revFLG) (< #i (length #Line$)))
    (setq #chkL (nth #i #Line$))
    ;; ��_��̐������� �_�ゾ������ 'T
    (setq #OnLine (PcIsExistPOnLine #chkL (list &dPT)))
    ;; ��_��̐��ł��p�x����}�`�Ɠ����ł���΁A���v���Ɣ���
    (if #OnLine
      (progn
        (setq #chkAng (read (angtos (angle (car #chkL) (cadr #chkL)) 0 3)))
        (If (equal #ang #chkAng 0.01)
          (setq #revFLG 'T)
        )
      )
    ) ;_ if
    ;; �C���N�������g
    (setq #i (1+ #i))
  ) ;_ while

  ;; #revFLG = 'T  �_�񃊃o�[�X���s
  (if #revFLG
    (setq #dRES$ (reverse &dPL$))
    (setq #dRES$ &dPL$)
  )

  ;; ���ʂ̓_���Ԃ�
  #dRES$
)
 ;_ PcReverseClockWisePL 

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcGetCornerList
;;; <�����T�v>  : �t�B���[�ݒu�}�`���X�g������A���p�L���r�E�o
;;; <�߂�l>    : ���X�g ((�}�`�� LR����) (�}�`�� LR����) �c)  �܂���  nil
;;; <�쐬>      : 02/04/05 MH
;;; <���l>  
;;;              
;;;*************************************************************************>MOH<
(defun PcGetCornerList (
  &eUPPER$      ; �t�B���[�ݒu�̈�̐}�`�����X�g
  &fANG         ; ����̊�ɂȂ� ��}�`�̐ݒu�p�x�i���W�A���j
  /
  #CHKANG #ECNR$ #FANG #RES$ #SLR #SLR$
  )
  ;; ����p�x���A���O���ɕϊ�
  (setq #fANG (read (angtos &fANG 0 3)))
  (setq #Res$ nil); ((LR����  �}�`��) (LR���� �}�`��)�c) 

  (foreach #en &eUPPER$
    (setq #chkANG (nth 2 (CFGetXData #en "G_LSYM")))
    ;; �`�F�b�N�}�`�p�x���A���O���ɕϊ� 
    (setq #chkANG (read (angtos #chkANG 0 3)))
    ;; ��Ű���ނ̔���
    (if
      (or
        ;; ��Ű����
        (= CG_SKK_THR_CNR (CFGetSymSKKCode #en 3)); ��Ű����
        ;; ���z�u���޲�ݸ޷��ށi��p�x�Ɗp�x���قȂ���́j
        (and (not (equal #fANG #chkANG 0.01)) ; ��p�x�ƈقȂ�
             (PcChkCornerDinning #en &eUPPER$); ���z�u���޲�ݸ޷���
        );_ and
      );_ or
      (progn
        ;; �ݒu���������Ƃ߂� ���F�S����"L"�ɂȂ�̂ł́H�H�H
        (if (and (= CG_SKK_THR_DIN (CFGetSymSKKCode #en 3))
                 (equal #fANG #chkANG 0.01)
            )
          (setq #sLR "R")
          (setq #sLR "L")
        ); if
        (setq #Res$ (cons (list #en #sLR) #Res$))
      ); progn
    ); if
  ); foreach

  ;;���X�g�̌��ʂ�Ԃ�
  #Res$
)
;_ PcGetCornerList 

;<HOM>*************************************************************************
; <�֐���>    : PcGetFilerBLRDlg
; <�����T�v>  : �����E�����[�U�[�ɑI�΂���
; <�߂�l>    : ���X�g (B L R) �̈ʒu�� T �� nil
; <�쐬>      : 01/04/04 MH
;*************************************************************************>MOH<
(defun PcGetFilerBLRDlg ( / #dcl_id #BLR$ X)
  ;;; �_�C�A���O�̎��s��
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "GetFilerBLRDlg" #dcl_id)) (exit))
  ;// ��ق�ر���ݐݒ�
  (action_tile "accept"
    "(setq #BLR$ (list (get_tile \"B\") (get_tile \"L\") (get_tile \"R\"))) (done_dialog)")
  (action_tile "cancel" "(setq #BLR$ nil) (done_dialog)")
  ;;;�f�t�H�l���
  (set_tile "B" "0")
  (set_tile "L" "1")
  (set_tile "R" "1")
  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; ���ʃ��X�g��Ԃ�
  (if #BLR$ (mapcar '(lambda (X) (= "1" X)) #BLR$) nil)
); PcGetFilerBLRDlg

;<HOM>*************************************************************************
; <�֐���>    : PcGetFilerALLDlg
; <�����T�v>  : �����E�����[�U�[�ɑI�΂���
; <�߂�l>    : ���X�g (B L R) �̈ʒu�� T �� nil
; <�쐬>      : 01/12/17 YM ADD ̨װ�I��,̨װ�����w���1���޲�۸ނōs��
;*************************************************************************>MOH<
(defun PcGetFilerALLDlg ( 
;-- 2011/07/21 A.Satoh Mod - S
; &Hinban$
;  &H
  &qry$
;-- 2011/07/21 A.Satoh Mod - S
  /
  #dcl_id #BLR$
;-- 2011/07/21 A.Satoh Add - S
  #hinban$ #syoki_index #height$ #idx #takasa
;-- 2011/07/21 A.Satoh Add - E
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #BLR$ #H #RET #SFILR
;-- 2011/07/22 A.Satoh Add - S
            #kosu #flag #kitchin #syunou
;-- 2011/07/22 A.Satoh Add - E
;-- 2011/08/11 A.Satoh Add - S
            #syokei #kitchin
;-- 2011/08/11 A.Satoh Add - E
            )
            (setq #BLR$
              (list
                (atoi (get_tile "B"))
                (atoi (get_tile "L"))
                (atoi (get_tile "R"))
              )
            )

;-- 2011/07/21 A.Satoh Mod - S
;           (setq #sFilr (nth (atoi (get_tile "FILR")) &Hinban$)) ; ̨װ�i��
;            (setq #H (read (get_tile "edtBOX"))) ; ̨װ����
;
;            (if (and (or (= (type #H) 'INT)(= (type #H) 'REAL))
;                     (> #H 0.0001))
;              (progn
;                (done_dialog) ; ���p����������
;                (setq #ret (append #BLR$ (list #sFilr #H))) ; �߂�l B,L,R,�i��,����
;              )
;              (progn
;                (alert "0���傫�Ȓl����͂��ĉ�����")
;                (set_tile "edtBOX" "")
;                (mode_tile "edtBOX" 2)
;                (princ)
;              )
;            );_if

            (setq #flag T)
            (setq #sFilr (nth (atoi (get_tile "FILR")) #hinban$)) ; ̨װ�i��
            (setq #H (read (get_tile "edtBOX")))        ; ̨װ����
            (setq #kosu (read (get_tile "edtBOX2")))    ; ��
;-- 2011/08/11 A.Satoh Add - S
            (setq #kitchin (get_tile "radio_A"))
            (if (= #kitchin "1")
              (setq #syokei "A")
              (setq #syokei "D")
            )
;-- 2011/08/11 A.Satoh Add - E

            ; �������͒l�`�F�b�N
            (if (/= #H nil)
              (if (or (= (type #H) 'INT) (= (type #H) 'REAL))
                (if (> #H 0.0001)
                  (if (> #H #takasa)
                    (progn
                      (setq #flag nil)
                      (alert (strcat "�����F" (rtos #takasa) " �ȉ��̒l����͂��ĉ�����"))
                      (set_tile "edtBOX" "")
                      (mode_tile "edtBOX" 2)
                      (princ)
                    )
                  )
                  (progn
                    (setq #flag nil)
                    (alert "0���傫�Ȓl����͂��ĉ�����")
                    (set_tile "edtBOX" "")
                    (mode_tile "edtBOX" 2)
                    (princ)
                  )
                )
                (progn
                  (setq #flag nil)
                  (alert "���l����͂��ĉ�����")
                  (set_tile "edtBOX" "")
                  (mode_tile "edtBOX" 2)
                  (princ)
                )
              )
              (progn
                (setq #flag nil)
                (alert "���������͂���Ă��܂���")
                (mode_tile "edtBOX" 2)
                (princ)
              )
            )

            ; �����͒l�`�F�b�N
            (if (= #flag T)
              (if (/= #kosu nil)
                (if (= (type #kosu) 'INT)
                  (if (<= #kosu 0)
                    (progn
                      (setq #flag nil)
                      (alert "0���傫�Ȓl����͂��ĉ�����")
                      (set_tile "edtBOX2" "")
                      (mode_tile "edtBOX2" 2)
                      (princ)
                    )
                  )
                  (progn
                    (setq #flag nil)
                    (alert "�����l�œ��͂��ĉ�����")
                    (set_tile "edtBOX2" "")
                    (mode_tile "edtBOX2" 2)
                    (princ)
                  )
                )
                (progn
                  (setq #flag nil)
                  (alert "�������͂���Ă��܂���")
                  (mode_tile "edtBOX2" 2)
                  (princ)
                )
              )
            )

            (if (= #flag T)
              (progn
                (done_dialog)
;-- 2011/08/11 A.Satoh Mod - S
;                (setq #ret (append #BLR$ (list #sFilr #H #kosu))
                (setq #ret (append #BLR$ (list #sFilr #H #kosu #syokei)))
;-- 2011/08/11 A.Satoh Mod - E
              )
            )
;-- 2011/07/21 A.Satoh Mod - E

          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �߯�߱���ؽ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/07/21 A.Satoh Mod - S
;          (defun ##Addpop ( /  ) ; �ގ��|�b�v�A�b�v���X�g
;           (start_list "FILR" 3)
;           (foreach #Hinban &Hinban$
;             (add_list #Hinban)
;           )
;           (end_list)
;           (set_tile "FILR" "0") ; �ŏ���̫���
;           (princ)
;          );##Addpop
          (defun ##Addpop (
            /
            #hinban
            )

            (start_list "FILR" 3)
            (foreach #hinban #Hinban$
              (add_list #hinban)
            )
            (end_list)

            (set_tile "FILR" #syoki_index)
            (princ)
          );##Addpop
;-- 2011/07/21 A.Satoh Mod - E
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/07/21 A.Satoh Add - S
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �i�ԑI��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##SelectFilr (
            /
            #index
            )

            (setq #index (atoi (get_tile "FILR")))

            (setq #takasa (nth #index #height$))
            (set_tile "edtBOX" (rtos #takasa))
            (princ)
          );##SelectFilr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/07/21 A.Satoh Add - E

;-- 2011/07/21 A.Satoh Add - S
  (setq #idx 0)
  (setq #hinban$ nil)
  (setq #syoki_index "")
  (setq #height$ nil)
  (repeat (length &qry$)
    (setq #height$ (append #height$ (list (nth 1 (nth #idx &qry$)))))
    (setq #hinban$ (append #hinban$ (list (nth 2 (nth #idx &qry$)))))
    (if (= (nth 5 (nth #idx &qry$)) 1)
      (setq #syoki_index (itoa #idx))
    )
    (setq #idx (1+ #idx))
  )
;-- 2011/07/21 A.Satoh Add - E

  ;;; �_�C�A���O�̎��s��
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "GetFilerALLDlg" #dcl_id)) (exit))

  ; �����l
;-- 2011/07/22 A.Satoh Mod - S
  (setq #takasa (nth (atoi #syoki_index) #height$))
  (set_tile "edtBOX" (rtos #takasa))
;  (set_tile "edtBOX" (rtos &H))
;-- 2011/07/22 A.Satoh Mod - S

  ; 01/12/19 YM ADD-S
  (if SKW_FILLER_AUTO ; ���������̂Ƃ�
    (progn
      ;;;�f�t�H�l���
      (set_tile "B" "0")
      (set_tile "L" "1")
      (set_tile "R" "1")
    )
    (progn ; �ʐ���
      ; �����ޯ�����ڰ���
      ;;;�f�t�H�l���
      (set_tile "F" "0")
      (set_tile "B" "0")
      (set_tile "L" "0")
      (set_tile "R" "0")
      (mode_tile "Check" 1)   ; �g�p�s��
    )
  );_if
  ; 01/12/19 YM ADD-E

;-- 2011/08/11 A.Satoh Add - S
  ; �L�b�`��/���[�敪
  (set_tile "radio_A" "1")
;-- 2011/08/11 A.Satoh Add - E

  ;;; �߯�߱���ؽ�
  (##Addpop)

  ;// ��ق�ر���ݐݒ�
;-- 2011/07/21 A.Satoh Add - S
  (action_tile "FILR" "(##SelectFilr)")
;-- 2011/07/21 A.Satoh Add - E
  (action_tile "accept" "(setq #BLR$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #BLR$ nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; ���ʃ��X�g��Ԃ�
  #BLR$
); PcGetFilerALLDlg

;<HOM>*************************************************************************
; <�֐���>    : PcGetFilerLRDlg
; <�����T�v>  : �����E�����[�U�[�ɑI�΂���
; <�߂�l>    : ���X�g (L R) �̈ʒu�� T �� nil
; <�쐬>      : 00/07/04 MH
;*************************************************************************>MOH<
(defun PcGetFilerLRDlg ( / #dcl_id #LR$ X)
  ;;; �_�C�A���O�̎��s��
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "GetFilerLRDlg" #dcl_id)) (exit))
  ;// ��ق�ر���ݐݒ�
  (action_tile "accept"
    "(setq #LR$ (list (get_tile \"L\") (get_tile \"R\"))) (done_dialog)")
  (action_tile "cancel" "(setq #LR$ nil) (done_dialog)")
  ;;;�f�t�H�l���
  (set_tile "L" "1")
  (set_tile "R" "1")
  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; ���ʃ��X�g��Ԃ�
  (if #LR$ (if #LR$ (mapcar '(lambda (X) (= "1" X)) #LR$) nil) nil)
); PcGetFilerLRDlg

;<HOM>*************************************************************************
; <�֐���>    : PcGetSidePinPL$
; <�����T�v>  : �w�ʂ̐����W���Ŋ�p�x�̕����Ɉ�Ԓ[�ƂȂ�_��E�o
; <�߂�l>    :
; <�쐬>      : 00-10-10 MH
; <���l>      : �w�ʂ���݂�ƁA��p�x�͉E�����ł��B
;*************************************************************************>MOH<
(defun PcGetSidePinPL$ (
  &backPL$    ; �����Ώۂ̐��_��
  &bsANG      ; ��ƂȂ�p�x
  &dirFLG     ; �擾����[�̃t���O "L" or "R"
  /
  #chkD ;02/03/29MH@ADD
  #chkP$ #fANG #jdgP1 #jdgP2 #resP #minD #chP
  )
  (setq #chkP$ (apply 'append &backPL$))
  (setq #fANG &bsANG)
  (if (= "L" &dirFLG) (setq #fANG (+ pi #fANG)))
  ; ����ݒ�
  (setq #jdgP1 (Pcpolar (car #chkP$) #fANG 100000))
  (setq #jdgP2 (Pcpolar #jdgP1 (+ (* 0.5 pi)  #fANG) 100))
  (setq #resP (car #chkP$))
  (setq #minD (distance #resP (inters #resP (pcpolar #resP #fANG 100) #jdgP1 #jdgP2 nil)))
  (foreach #chP #chkP$
    (setq #chkD (distance #chP (inters #chP (pcpolar #chP #fANG 100) #jdgP1 #jdgP2 nil)))
    (if (> #minD #chkD) (progn
      (setq #resP #chP)
      (setq #minD #chkD)
    )) ; if progn
  ); foreach
  #resP
); PcGetSidePinPL$

;<HOM>*************************************************************************
; <�֐���>    : PcOffsetFilerBCPL$
; <�����T�v>  : �w�ʂ̗̈�_����I�t�Z�b�g����
; <�߂�l>    :
; <�쐬>      : 00-10-10 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcOffsetFilerBCPL$ (
  &dPL$       ; �����Ώۂ̗̈�_��
  &ofsP       ; �S�̂���݂��I�t�Z�b�g�_
  &fOF        ; �I�t�Z�b�g�l
  &baseANG    ; ��}�`�̊p�x
  /
  #dPL$ #ofANG$ #jdgANG$ #jANG
  )
  (setq #dPL$ &dPL$)
  ; �e���ɑ΂���I�t�Z�b�g�������X�g #ofANG$ ���Z�o
  (setq #ofANG$ (PcGetPLOffsetAng$ #dPL$ &ofsP))
  (setq #jdgANG$ nil)
  (setq #jANG (read (angtos (+ &baseANG (* -0.5 pi)) 0 3)))
  (repeat (1- (length #dPL$)) (setq #jdgANG$ (cons #jANG #jdgANG$)))
  ; ���ʕ����̊e�_�I�t�Z�b�g����
  (setq #dPL$ (PcOffsetPL$ #dPL$ #ofANG$ #jdgANG$ &fOF 'T))
  ; �i�������̃I�t�Z�b�g����
  (setq #dPL$ (PcOffsetPL$ #dPL$ #ofANG$ #jdgANG$ &fOF nil))
  #dPL$
); PcOffsetFilerBCPL$

;<HOM>*************************************************************************
; <�֐���>    : PcOffsetFilerPL$
; <�����T�v>  : �w�ʂ���������̗̈�_����I�t�Z�b�g����
; <�߂�l>    :
; <�쐬>      : 00-10-05 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcOffsetFilerPL$ (
  &dPL$       ; �����Ώۂ̗̈�_��
  &ofsP       ; �S�̂���݂��I�t�Z�b�g�_
  &fOF        ; �I�t�Z�b�g�l
  &eCONR$     ; �̈撆�̃R�[�i�[�L���r�̐}�`�����X�g
  &backFLG    ; �w�ʂ̂���Ȃ��t���O (����= 'T))
  /
  #dPL$ #dL #dR #TEMP$ #i #ofANG$ #dCONR$ #eCN #dCB #minD #dCCP #dP #dCONR$
  #jdgANG$ #iCP #jANG1 #jANG2 #jANG3 #jANG #chkXD$ #chkP #chkANG
  )
  (setq #dPL$ &dPL$)
  ; ���E���Ǔ_�������Ă���
  (setq #dL (car #dPL$))
  (setq #dR (last #dPL$))
  (setq #TEMP$ nil)
  (setq #i 1)
  (while (< #i (1- (length #dPL$)))
    (setq #TEMP$ (append #TEMP$ (list (nth #i #dPL$))))
    (setq #i (1+ #i))
  ); while

  (setq #dPL$ #TEMP$) ; ���ƍŌオ�����ꂽ�̈�_��
  ; �e���ɑ΂���I�t�Z�b�g�������X�g #ofANG$ ���Z�o
  (setq #ofANG$ (PcGetPLOffsetAng$ #dPL$ &ofsP))

  ; �R�[�i�[�L���r�̐��������p�_ #dCONR$ ���擾���X�g��
  (setq #dCONR$ nil)
  (foreach #eCN &eCONR$
    (setq #chkXD$ (CFGetXData #eCN "G_LSYM"))
    ; 02/03/29MH@MOD ��_��LSYM�������Ă����̂ŕύX
    (setq #chkP (cdr (assoc 10 (entget #eCN))))
    ; 02/03/29MH@DEL (setq #chkP (cadr #chkXD$))
    ; �R�[�i�[�L���r
    (if (= CG_SKK_THR_CNR (CFGetSymSKKCode #eCN 3))
      (progn
        ; #dPL$���̃R�[�i�[�L���r�̊�_�Ɉ�ԋ߂��_������p�_
        (setq #minD 10000); ���l
        (setq #dCCP nil)
        (foreach #dP #dPL$
          (if (> #minD (distance #chkP #dP))
            (progn
              (setq #minD (distance #chkP #dP))
              (setq #dCCP #dP)
          )); if
        )
      );progn
      (progn
      ; �_�C�j���O�L���r���g�p����ꍇ�̓L���r��_�̉�������ɂ���_�ŋ������Z����
        (setq #chkANG (atof (angtos (nth 2 #chkXD$) 0 3)))
        (setq #dCCP nil)
        (foreach #dP #dPL$
          (if (equal #chkANG (atof (angtos (angle #chkP #dP) 0 3)) 0.001)
            (cond
              ((not #dCCP) (setq #dCCP #dP))
              ((< (distance #chkP #dP) (distance #chkP #dCCP))(setq #dCCP #dP))
            ); cond
          ); if
        ); foreach
      );progn
    ); if
    (setq #dCONR$ (append #dCONR$ (list #dCCP)))
  ); foreach
  ; �����E�̏��� �R�[�i�[�L���r�p�_�𔻒f��Ɋe�o�����Ή��̐��ʊp�x���X�g���쐬
  (setq #jdgANG$ nil)
  (setq #iCP (length #dCONR$))
  (cond
    ; I�^
    ((= 0 #iCP)
      (setq #jANG (read (angtos (angle (car #dPL$) #dL) 0 3)))
      (repeat (1- (length #dPL$)) (setq #jdgANG$ (cons #jANG #jdgANG$)))
    ); I�^
    ; L�^
    ((= 1 #iCP)
      (setq #jANG1 (read (angtos (angle (car #dPL$) #dL) 0 3)))
      (setq #jANG2 (read (angtos (angle (last #dPL$) #dR) 0 3)))
      (setq #i 1)
      (setq #jANG #jANG1)
      (while (< #i (length #dPL$))
        (setq #jdgANG$ (append #jdgANG$ (list #jANG)))
        (if (equal 0 (distance (nth #i #dPL$) (car #dCONR$)) 0.1) (setq #jANG #jANG2))
        (setq #i (1+ #i))
      ); while
    ); L�^
    ; U�^
    ((= 2 #iCP)
      ; ���ԕ����̊p�x���擾���Ă���
      ; �R�[�i�[�L���r�̊�_�Q�_�ƁA����p�_�̌�_�����߂�
      (setq #jANG1 (read (angtos (angle (car #dPL$) #dL) 0 3)))
      ; 02/03/29MH@MOD ��_��LSYM�������Ă����̂ŕύX
      (setq #jANG2 (read (angtos (+ (* 0.5 pi)
        (angle (cdr (assoc 10 (entget (car &eCONR$))))
               (cdr (assoc 10 (entget (cadr &eCONR$)))))) 0 3)))
      ; 02/03/29MH@DEL(setq #jANG2 (read (angtos (+ (* 0.5 pi)
      ; 02/03/29MH@DEL  (angle (cadr (CFGetXData (car &eCONR$) "G_LSYM"))
      ; 02/03/29MH@DEL         (cadr (CFGetXData (cadr &eCONR$) "G_LSYM")))) 0 3)))
      (setq #jANG3 (read (angtos (angle (last #dPL$) #dR) 0 3)))
      (setq #i 1)
      (setq #jANG #jANG1)
      (while (< #i (length #dPL$))
        (setq #jdgANG$ (append #jdgANG$ (list #jANG)))
        (if (or (equal (nth #i #dPL$) (car #dCONR$) 0.01)
                (equal (nth #i #dPL$) (cadr #dCONR$) 0.01))
          (if (= #jANG #jANG1) (setq #jANG #jANG2) (setq #jANG #jANG3))
        ); if
        (setq #i (1+ #i))
      ); while
    ); U�^
  ); cond
  ; ���ʕ����̊e�_�I�t�Z�b�g����
  (setq #dPL$ (PcOffsetPL$ #dPL$ #ofANG$ #jdgANG$ &fOF 'T))
  (setq #dPL$ (PcOffsetPL$ #dPL$ #ofANG$ #jdgANG$ &fOF nil))
  ; �w�ʕ����̊e�_�I�t�Z�b�g����
  (if &backFLG (progn
    (setq #dL (Pcpolar #dL (angle #dL (car #dPL$)) &fOF))
    (setq #dR (Pcpolar #dR (angle #dR (last #dPL$)) &fOF))
  )); if progn
  ; ���E���Ǔ_��߂�
  (append (list #dL) #dPL$ (list #dR))
); PcOffsetFilerPL$

;<HOM>*************************************************************************
; <�֐���>    : PcGetPLOffsetAng$
; <�����T�v>  : �|�����C���_���X�g�Ƃ���ɑΉ�����P�̃I�t�Z�b�g�_����
;             : �|�����C�����\������e���ɑΉ����� �I�t�Z�b�g�p�x���X�g���쐬
; <�߂�l>    : �\�������̊p�x���X�g
; <�쐬>      : 00-07-03 MH
; <���l>      : �I�t�Z�b�g�������}�C�i�X�̏ꍇ�A180�x��]�p�x��ݒ�
;*************************************************************************>MOH<
(defun PcGetPLOffsetAng$ (
  &pt$        ; �|�����C���_���X�g
  &ofP        ; �I�t�Z�b�g��_
  /
  #ofANG$     ; �|�����C�����\������e���ɑΉ�����I�t�Z�b�g�p�x
  #dRES$      ; �|�����C�����\������e���ɑΉ�����I�t�Z�b�g�_���X�g
  #eDEL #subP$ #i #i2 #stP1 #nxP1 #stP2 #nxP2 #crsP1 #crsP2 #ofANG #ofANG$ #view$
  )
  ; �܂��A���[�U�̎�����#ofP�_�ŃI�t�Z�b�g�������|�����_���X�g�擾
  (MakeLwPolyLine &pt$ 0 CG_UpCabHeight)
  (setq #eDEL (entlast))
  ;;; 00/07/22 MH ADD �I�t�Z�b�g�̍ۂ̊p�x�𕽖ʂɂ���
  (setq #view$ (getvar "VIEWDIR"));;; �v���_����
  (command "_vpoint" '(0 0 1))
  (command "_offset" 10 (entlast) (list (car &ofP) (cadr &ofP)) "")
;(command "_change" (entlast) "" "P" "C" "green" "");�e�X�g�p�F��
  (command "_vpoint" #view$);;;���_�����ɂ��ǂ�
  (setq #subP$ (GetLWPolyLinePt (entlast))) ;���|�����_���X�g#subP$
  (entdel (entlast)) ;���X�g�擾�Ɏg�p�����}�`�͏���
  (entdel #eDEL)

  ; ���ɑ΂���I�t�Z�b�g�������X�g #ofANG$ ���Z�o
  (setq #i 0)
  (while (setq #nxP1 (nth (1+ #i) &pt$))
    (setq #stP1 (nth #i &pt$))
    (setq #ofANG (angle #stP1 #nxP1))
    (setq #crsP1 (pcpolar #stP1 #ofANG (* 0.5 (distance #stP1 #nxP1))))
    (setq #crsP2 nil)
    (setq #i2 0)
    (while (and (not #crsP2) (setq #nxP2 (nth (1+ #i2) #subP$)))
      (setq #crsP2 (inters (nth #i2 #subP$) #nxP2 #crsP1
        (pcpolar #crsP1 (+ #ofANG (DTR 90)) 100) nil))
      (if (not (and #crsP2 (equal 10 (distance #crsP1 #crsP2) 0.1)))
        (setq #crsP2 nil)
      )
      (setq #i2 (1+ #i2))
    ); while
    (if #crsP2
      (setq #ofANG (angle #crsP1 #crsP2))
      (setq #ofANG (+ (angle #stP1 #nxP1) (DTR 90)))
    )
    ; #ofANG�Z�o�����܂ŁB���X�g�Ɏ擾
    (setq #ofANG$ (append #ofANG$ (list #ofANG)))
    (setq #i (1+ #i))
  ); while
  #ofANG$
); PcGetPLOffsetAng$

;<HOM>*************************************************************************
; <�֐���>    : PcGetPLOffsetAngEach$
; <�����T�v>  : P�_���X�g�Ƃ���ɑΉ�����I�t�Z�b�g�_����ʊp�x���X�g�쐬
; <�߂�l>    : �\�������̊p�x���X�g
; <�쐬>      : 00-07-03 MH
; <���l>      : ��{�̐��ɂ����g���Ȃ�
;*************************************************************************>MOH<
(defun PcGetPLOffsetAngEach$ (
  &pt$        ; �|�����C���_���X�g
  &ofP        ; �I�t�Z�b�g��_
  /
  #ofANG$     ; �|�����C�����\������e���ɑΉ�����I�t�Z�b�g�p�x
  #dRES$      ; �|�����C�����\������e���ɑΉ�����I�t�Z�b�g�_���X�g
  #eDEL #subP$ #i #i2 #stP1 #nxP1 #stP2 #nxP2 #crsP1 #crsP2 #ofANG #ofANG$ #view$
  )
  ;;; 00/07/22 MH ADD �I�t�Z�b�g�̍ۂ̊p�x�𕽖ʂɂ���
  (setq #view$ (getvar "VIEWDIR"));;; �v���_����
  (command "_vpoint" '(0 0 1))

  ; ���ɑ΂���I�t�Z�b�g�������X�g #ofANG$ ���Z�o
  (setq #i 0)
  (while (setq #nxP1 (nth (1+ #i) &pt$))
    ; �܂��A���[�U�̎�����#ofP�_�ŃI�t�Z�b�g�������|�����_���X�g�擾
    (MakeLwPolyLine (list (nth #i &pt$) #nxP1) 0 CG_UpCabHeight)
    (setq #eDEL (entlast))
    (command "_offset" 50 (entlast) (list (car &ofP) (cadr &ofP)) "")
    (setq #subP$ (GetLWPolyLinePt (entlast))) ;���|�����_���X�g#subP$
    (entdel (entlast)) ;���X�g�擾�Ɏg�p�����}�`�͏���
    ;(command "_change" (entlast) "" "P" "C" "green" "");�e�X�g�p�F��
    (entdel #eDEL)

    (setq #stP1 (nth #i &pt$))
    (setq #ofANG (angle #stP1 #nxP1))
    (setq #crsP1 (pcpolar #stP1 #ofANG (* 0.5 (distance #stP1 #nxP1))))
    (setq #crsP2 nil)
    (setq #i2 0)
    (while (and (not #crsP2) (setq #nxP2 (nth (1+ #i2) #subP$)))
      (setq #crsP2 (inters (nth #i2 #subP$) #nxP2 (list (car #crsP1) (cadr #crsP1))
        (pcpolar #crsP1 (+ #ofANG (DTR 90)) 100) nil))
      (if (not (and #crsP2 (equal 50 (distance #crsP1 #crsP2) 0.1)))
        (setq #crsP2 nil)
      )
      (setq #i2 (1+ #i2))
    ); while
    (if #crsP2
      (setq #ofANG (angle #crsP1 #crsP2))
      (setq #ofANG (+ (angle #stP1 #nxP1) (DTR 90)))
    )
    ; #ofANG�Z�o�����܂ŁB���X�g�Ɏ擾
    (setq #ofANG$ (append #ofANG$ (list #ofANG)))
    (setq #i (1+ #i))
  ); while
  (command "_vpoint" #view$);;;���_�����ɂ��ǂ�

  #ofANG$
); PcGetPLOffsetAngEach$

;<HOM>*************************************************************************
; <�֐���>    : PcPL$SidePart
; <�����T�v>  : ���E���Ǖ��̗L�����O���[�o�����画�f���t�B���[�̈�_���ύX
; <�߂�l>    : �̈�_�񃊃X�g
; <�쐬>      : 00-10-05 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcPL$SidePart (
  &dPL$       ; �Ώۂ̗̈�_��
  &fOF        ; �I�t�Z�b�g�l
  /
  #dPL$ #ofANG #i #oPL #TEMP$ #dPL$
  )
  ; ���ʍ��E�t���O���݂ăI�t�Z�b�g&��������
  (setq #dPL$ &dPL$)
  (if (= 1 SKW_FILLER_LSIDE)
  ; �����ʗL��
    (progn
      (setq #ofANG (angle (cadr #dPL$) (caddr #dPL$)))
      (setq #TEMP$ nil)
      (setq #i 0)
      (foreach #oPL #dPL$
        (if (> 2 #i)
          (setq #TEMP$ (append #TEMP$ (list (Pcpolar #oPL #ofANG &fOF))))
          (setq #TEMP$ (append #TEMP$ (list #oPL)))
        ); if
        (setq #i (1+ #i))
      ); foreach
      (setq #dPL$ #TEMP$)
    ); progn
    ; �����ʂȂ�
    (setq #dPL$ (cdr #dPL$))
  ); ��
  (if (= 1 SKW_FILLER_RSIDE)
    ; �E���ʗL��
    (progn
      (setq #ofANG (angle (nth (- (length #dPL$) 2) #dPL$)
                          (nth (- (length #dPL$) 3) #dPL$)))
      (setq #TEMP$ nil)
      (setq #i 0)
      (foreach #oPL #dPL$
        (if (< (- (length #dPL$) 3) #i)
          (setq #TEMP$ (append #TEMP$ (list (Pcpolar #oPL #ofANG &fOF))))
          (setq #TEMP$ (append #TEMP$ (list #oPL)))
        ); if
        (setq #i (1+ #i))
      ); foreach
      (setq #dPL$ #TEMP$)
    ); progn
    ; �E���ʂȂ�
    (setq #dPL$ (reverse (cdr (reverse #dPL$))))
  ); �E
  #dPL$
); PcPL$SidePart

;<HOM>*************************************************************************
; <�֐���>    : PcPL$SidePart2
; <�����T�v>  : �w�ʐ��F���E���Ǖ��̗L�����O���[�o�����画�f���t�B���[�̈�_��ύX
; <�߂�l>    : �̈�_�񃊃X�g
; <�쐬>      : 00-10-05 MH
; <���l>      : �w�ʗp
;*************************************************************************>MOH<
(defun PcPL$SidePart2 (
  &fANG       ; ��p�x
  &dPL$       ; �Ώۂ̗̈�_��
  &fOF        ; �I�t�Z�b�g�l
  /
  #dPL$ #ofANG #newP
  )
  (setq #dPL$ &dPL$)
  ; �����ʗL��  �I�t�Z�b�g&��������
  (if (= 1 SKW_FILLER_LSIDE) (progn
    (setq #ofANG &fANG)
    (setq #newP (pcpolar (last #dPL$) #ofANG &fOF))
    (setq #dPL$ (reverse (cons #newP (cdr (reverse #dPL$)))))
  )); ��
  ; �E���ʗL��  �I�t�Z�b�g&��������
  (if (= 1 SKW_FILLER_RSIDE) (progn
      (setq #ofANG (+ pi &fANG))
      (setq #newP (pcpolar (car #dPL$) #ofANG &fOF))
      (setq #dPL$ (cons #newP (cdr #dPL$)))
  )); �E
  #dPL$
); PcPL$SidePart2

;<HOM>*************************************************************************
; <�֐���>    : PcOffsetPL$
; <�����T�v>  : �̈�_����p�x(����or��)���m�F���Ȃ���I�t�Z�b�g���ꂽ�ʒu�Ɉړ�
; <�߂�l>    : ���H�ςݓ_���X�g
; <�쐬>      : 00-10-06 MH
; <���l>      :
;*************************************************************************>MOH<;
(defun PcOffsetPL$ (
  &dPL$       ; �����Ώۗ̈�_��
  &fANG$      ; �����Ƃ̃I�t�Z�b�g�p�x���X�g
  &jdgANG$    ; ���ʂ��ǂ����m�F���邽�߂̊p�x�i���H�ς݁j���X�g
  &fOF        ; �I�t�Z�b�g�l
  &frontFLG   ; ���ʕ����̃I�t�Z�b�g�Ȃ�T ���ʂȂ�nil
  /
  #dPL$ #i #ii #angFLG #P1 #P2 #TEMP$ #dP
  )
  (setq #dPL$ &dPL$)
  (setq #i 0)
  (while (< #i (1- (length #dPL$)))
    (setq #angFLG (equal (read (angtos (nth #i &fANG$) 0 3)) (nth #i &jdgANG$) 0.01))
    (if (or (and &frontFLG #angFLG) (and (not &frontFLG) (not #angFLG)))(progn
      (setq #P1 (pcpolar (nth #i #dPL$) (nth #i &fANG$) &fOF))
      (setq #P2 (pcpolar (nth (1+ #i) #dPL$) (nth #i &fANG$) &fOF))
      ; �R�[�i�[�L���r�����p�Ή��̂��ߐ����I���W�i��#dPL$���X�V����K�v�L
      (setq #TEMP$ nil)
      (setq #ii 0)
      (foreach #dP #dPL$
        (cond
          ((= #i #ii) (setq #TEMP$ (append #TEMP$ (list #P1))))
          ((= (1+ #i) #ii) (setq #TEMP$ (append #TEMP$ (list #P2))))
          (t (setq #TEMP$ (append #TEMP$ (list #dP))))
        ); cond
        (setq #ii (1+ #ii))
      ); foreach
      (setq #dPL$ #TEMP$) ; �I���W�i��#dPL$���X�V
    )); if progn
    (setq #i (1+ #i))
  ); while
  #dPL$
); PcOffsetPL$

;<HOM>*************************************************************************
; <�֐���>    : PcMkPL$byLine$
; <�����T�v>  : �A���������̃��X�g���|�����C���_���X�g�ɂ��ǂ�
; <�߂�l>    : �_���X�g
; <�쐬>      : 00/10/05 MH
; <���l>      : �o�_���X�g�͓��̓_�ƍŌ�̓_�������ꍇ�̂ݕ����|�����C������
;*************************************************************************>MOH<
(defun PcMkPL$byLine$ (&LINE$ / #i #PL$)
  (setq #i 0)
  (setq #PL$ (list (car &LINE$)))
  (while (< #i (1- (length &LINE$)))
    (setq #PL$ (append #PL$ (list (cadr (nth #i &LINE$)))))
    (setq #i (1+ #i))
  ); while
  #PL$
); PcMkPL$byLine$

;<HOM>*************************************************************************
; <�֐���>    : PcOrderPL$byOneP
; <�����T�v>  : �����o�_���X�g������_��1�Ԗڂ̈ʒu�ɂ���悤���בւ�
; <�߂�l>    : ���בւ����o�_���X�g
; <�쐬>      : 00/10/10 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcOrderPL$byOneP (
  &CPL$       ; ����P�_���X�g   (a b c d e f g)
  &topP       ; �g�b�v�ɂ���_
  /
  #CPL$ #i #stopF #aMOV
  )
  (setq #CPL$ &CPL$)
  (setq #stopF (if (equal (car #CPL$) &topP 0.01) 'T nil))
  (setq #i 0)
  (while (and (not #stopF) (< #i (length #CPL$)))
    (setq #aMOV (car #CPL$))
    (setq #CPL$ (append (cdr #CPL$) (list #aMOV)))
    (setq #stopF (if (equal (car #CPL$) &topP 0.01) 'T nil))
    (setq #i (1+ #i))
  ); while
  #CPL$
); PcOrderPL$byOneP

;<HOM>*************************************************************************
; <�֐���>    : PcGetFilerHeight
; <�����T�v>  : �A�b�p�[�p�}�`����A�㕔��_��Z�l������
; <�߂�l>    : Z�l
; <�쐬>      : 00/08/01 MH
; <���l>      : �r�� nil �����o�����΁A���[�U�[�ɍ����������˂�B
;*************************************************************************>MOH<
(defun PcGetFilerHeight (
  &eITEM      ; �ݒu�̊�ƂȂ�}�`��
  /
  #eITEM #LXD$ #XD$ #NEXT$ #NX #sCHK #eMC #fZ #elv #height
  )
  (setq #eITEM &eITEM)
  (if (= 'ENAME (type #eITEM)) (progn
    (setq #LXD$ (CFGetXData #eITEM "G_LSYM"))
    ; �A�C�e���̊�_��Z�l���擾
    ; 02/03/29MH@MOD ��_��LSYM�������Ă����̂ŕύX
    (setq #fZ (caddr (cdr (assoc 10 (entget #eITEM)))))
    ; 02/03/29MH@DEL(setq #fZ (caddr (cadr #LXD$)))
    (setq #XD$ (CFGetXData #eITEM "G_SYM"))
    (if (= 1 (nth 10 #XD$)) (setq #fZ (+ #fZ (nth 5 #XD$))))
  )); if&progn
  ; �����܂ł�  #fZ �����ĂȂ���΁A���[�U�[�Ɍ��߂�����B
  (if (not (numberP #fZ)) (progn
    (setq #elv (getvar "ELEVATION"))
    (setvar "ELEVATION" CG_UpCabHeight)
    (setq #height (getreal (strcat "\n \n����<" (itoa (fix CG_UpCabHeight)) ">: ")))
    (setq #fZ (if (not #height) CG_UpCabHeight #height))
    (setvar "ELEVATION" #elv) ; ���̍����ɖ߂�
  )); if
  #fZ
); PcGetFilerHeight

;<HOM>***********************************************************************
; <�֐���>    : PcMakeFiler
; <�����T�v>  : ��|�����C������V��t�B���[�}�`�쐬�A�g���f�[�^�Z�b�g
; <�߂�l>    : �}�`��
; <�쐬>      : 00/04/24 MH
; <���l>      : 00/10/10 MH �ŏ��ƍŌオ����Ȃ��P���Ƃ݂Ȃ���������悤�ɕύX
;***********************************************************************>HOM<
(defun PcMakeFiler (
    &sOPHIN   ; �t�B���[�i��
;;;01/12/17YM@MOD    &iFR      ; �t�B���[��ޔԍ� �����폜
    &pt$      ; �t�B���[�쐬�̌��ƂȂ�PLINE��\���_���X�g
    &ofP      ; �I�t�Z�b�g�̕����_�iNil���Ǝ����Z�o����j
    &fD       ; �t�B���[�̌���
    &fH       ; �t�B���[�̍���
    &fUPHeight ; �t�B���[�̐ݒu���x
;-- 2011/08/11 A.Satoh Add - S
    &syokei   ; ���v��� "A":�L�b�`�� "D":���[
;-- 2011/08/11 A.Satoh Add - E
    /
   #os #view$ #FLG #pt$ #ofP #closeFLG #ePL #eOFSPL #pt2$ #e1 #e2
   #e1AREA #e2AREA #eOUT #eIN #en #FLG
#AORD ;2011/08/12 YM ADD
  )
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (setq #view$ (getvar "VIEWDIR"));;; �v���_����
  (setq #FLG (if (equal #view$ '(0.0 -1.0 0.0) 0.01) 'T nil))
  (if #FLG (command "_vpoint" '(0 0 1)))

  (setq #pt$ &pt$)
  (if (not &ofP)
    (setq &ofP (polar (car #pt$) (+ (dtr 90) (angle (car #pt$) (cadr #pt$))) 100)))
  (setq #ofP (list (car &ofP) (cadr &ofP) &fUPHeight))

  ; �t�B���[3DSOLID�̍쐬�ƐώZ�p�̃|�����C��#ePL�擾
  (setq #closeFLG (if (equal (car #pt$) (last #pt$) 0.01) 'T nil))
  (if #closeFLG
    (MakeLwPolyLine (cdr #pt$) 1 &fUPHeight) ; �����|�����C��
    (MakeLwPolyLine #pt$ 0 &fUPHeight)       ; �J�����|�����C��
  ); (command "_change" (entlast) "" "P" "C" "red" "") ;�m�F�p
  (setq #ePL (entlast))
  ; ���ݕ��I�t�Z�b�g�����|�����C���쐬�C�_���X�g�擾
  (command "_offset" &fD (entlast) #ofP "")
  (setq #eOFSPL (entlast))
  (setq #pt2$ (GetLWPolyLinePt #eOFSPL))
  (if #closeFLG
    ; �����|�����C��
    (progn
      ;// �V��t�B���[�̊O�`�̈�(���[�W����)�𐶐�
      ; �O���̕|�����C��
      (entmake (entget #ePL))
      (command "_region" (entlast) "")
      (setq #e1 (entlast))
      (command "_AREA" "O" (entlast))
      (setq #e1AREA (getvar "AREA"))
      ;(command "_change" (entlast) "" "P" "C" "red" "") ;�m�F�p
      ; �����̕|�����C��
      (command "_region" #eOFSPL "")
      ;(command "_change" (entlast) "" "P" "C" "blue" "") ;�m�F�p
      (setq #e2 (entlast))
      (command "_AREA" "O" (entlast))
      (setq #e2AREA (getvar "AREA"))
      (cond
        ((> #e1AREA #e2AREA) (setq #eOUT #e1) (setq #eIN #e2))
        ((< #e1AREA #e2AREA) (setq #eOUT #e2) (setq #eIN #e1))
        (t (CFAlertMsg "�t�B���[��}�p �|�����C�����쐬�ł��܂���ł���")(exit))
      ); cond
      (command "_subtract" #eOUT "" #eIN "")
    ); progn
    ; �J�����|�����C��
    (progn
      (entdel #eOFSPL)
      ;;; ���ތ����̓_���X�g�������ė̈�_���X�g�쐬
      (setq #pt2$ (reverse #pt2$))
      (setq #pt$ (append #pt$ #pt2$))
      ;// �V��t�B���[�̊O�`�̈�(�|�����C��)�𐶐�
      (MakeLwPolyLine #pt$ 1 &fUPHeight)
    );progn
  ); if
  ;// �V��t�B���[�̉����o��
  ;2008/07/28 YM MOD 2009�Ή�
  (command "_extrude" (entlast) "" &fH )
;;;  (command "_extrude" (entlast) "" &fH "")
  (setq #en (entlast))
  (entmod (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #en)) (entget #en)))

  (if #FLG (command "_vpoint" #view$))
  (setvar "OSMODE" #os)

  ;// �V��t�B���[�g���f�[�^�̕t��
  (if (= nil (tblsearch "APPID" "G_FILR"))(regapp "G_FILR"))


	;2011/08/12 YM ADD �v���������̂Ƃ��̏��v(���� or ���[)�̒l���㏑��
	(if (and CG_GLOBAL$ (nth 46 CG_GLOBAL$) (/= (nth 46 CG_GLOBAL$) "N")(/= (nth 46 CG_GLOBAL$) "X"))
		(setq &syokei "A");����
	);_if
	(if (and CG_GLOBAL$ (nth 72 CG_GLOBAL$) (/= (nth 72 CG_GLOBAL$) "N")(/= (nth 72 CG_GLOBAL$) "X"))
		(setq &syokei "D");���[
	);_if


  (if #en (CFSetXData #en "G_FILR"
;-- 2011/08/11 A.Satoh Mod - S
;    (list &sOPHIN SKW_AUTO_SOLID #ePL 1 0.0 SKW_FILLER_LLEN SKW_FILLER_RLEN)))
    (list &sOPHIN SKW_AUTO_SOLID #ePL 1 0.0 SKW_FILLER_LLEN SKW_FILLER_RLEN &syokei)))
;-- 2011/08/11 A.Satoh Mod - E
  ; �I�v�V�����ݒu  01/04/03 MH ADD
  (KcSetG_OPT #en)
  #en
); PcMakeFiler

; <HOM>***********************************************************************************
; <�֐���>   : PcListOrderByNumInList
; <�����T�v> : ���X�g���̐��l���܂񂾃��X�g���w��̈ʒu�̐��̑傫�����Ń\�[�g����B
; <�߂�l>   : ���e���\�[�g���ꂽ���X�g (��̐��� ������)
; <���l>     : ���l�ȊO�������Ă���ƌ��̃��X�g���Ԃ�܂��B
; ***********************************************************************************>MOH<
(defun PcListOrderByNumInList (
  &NUM$      ; ���X�g�̏W��
  &iLO       ; �\�[�g�̊�ɂ��鐔�l�̈ʒu�i������ 0�j
  /
  #X #iA #iB #NUM #STOP #TEMP$ #NUM$ #DEC$ #NEW$
  )
  (foreach #NUM &NUM$ (if (not (numberp (nth &iLO #NUM))) (setq #STOP 'T)))
  (if (= 'T #STOP)
    (setq #NEW$ &NUM$)
    (progn
      (setq #NUM$ &NUM$)
      (while (car #NUM$)
        (setq #TEMP$ (mapcar '(lambda (#X) (nth &iLO #X)) #NUM$))
        (setq #iA (- (length #TEMP$) (length (member (apply 'min #TEMP$) #TEMP$))))
        (setq #NEW$ (append #NEW$ (list (nth #iA #NUM$))))
        (setq #iB 0)
        (setq #DEC$ nil)
        (while (< #iB (length #NUM$))
          (if (/= #iB #iA)
            (setq #DEC$ (append #DEC$ (list (nth #iB #NUM$))))
          ); end of if
          (setq #iB (1+ #iB))
        ); end of while
        (setq #NUM$ #DEC$)
      ); end of while
    ); end of progn
  ); end of if
  #NEW$
); end of defun

;<HOM>*************************************************************************
; <�֐���>    : PcMkLine$byPL$
; <�����T�v>  : �|�����C���_���X�g�� �o�����̃��X�g�ɕҏW
; <�߂�l>    : �_���̂܂܂� �����X�g
; <�쐬>      : 00/10/04 MH
; <���l>      : �t���O�� T�Ȃ� �����|�����C���_�Ƃ��čŌ�Ɠ��̓_�̐���������
;*************************************************************************>MOH<
(defun PcMkLine$byPL$ (&PL$ &C_FLG / #i #LINE$)
  (setq #i 0)
  (while (< #i (1- (length &PL$)))
    (setq #LINE$ (append #LINE$ (list (list (nth #i &PL$) (nth (1+ #i) &PL$)))))
    (setq #i (1+ #i))
  ); while
  (if &C_FLG (setq #LINE$ (append #LINE$ (list (list (last &PL$) (car &PL$))))))
  #LINE$
); PcMkLine$byPL$
;;;02/04/04MH@DEL<HOM>*************************************************************************
;;;02/04/04MH@DEL <�֐���>    : PcGetUpperItemPL$
;;;02/04/04MH@DEL <�����T�v>  : �A�b�p�[�A�C�e���̐}�`�����X�g����A�O�`��P�_���X�g�쐬
;;;02/04/04MH@DEL <�߂�l>    : ((�}�`�� (�O�`��P�_)) (�}�`�� (�O�`��P�_))���)
;;;02/04/04MH@DEL <�쐬>      : 00-10-03 MH
;;;02/04/04MH@DEL <���l>      : �Z���^�[�L���r,�����W�t�[�h,�T�C�h�p�l��D380�͗v�̈�k��
;;;02/04/04MH@DEL*************************************************************************>MOH<
;;;02/04/04MH@DEL(defun PcGetUpperItemPL$ (
;;;02/04/04MH@DEL  &eUPPER$    ; �A�b�p�[�A�C�e�����X�g
;;;02/04/04MH@DEL  /
;;;02/04/04MH@DEL  #RES$ #eUP #LSYM$ #up-ss #i #ePMEN #en #pxd$ #dAREA$ #fD #GSYM$ #dSymPT
;;;02/04/04MH@DEL  #eUPPER0$ ;02/04/03MH@ADD
;;;02/04/04MH@DEL  )
;;;02/04/04MH@DEL ; 02/01/16 YM ADD-S �������ق�ΏۊO�ɂ���
;;;02/04/04MH@DEL (setq #eUPPER0$ nil) ; �������ق����O��������
;;;02/04/04MH@DEL  (foreach #eUP &eUPPER$
;;;02/04/04MH@DEL    (if (= CG_SKK_ONE_SID (CFGetSymSKKCode #eUP 1))
;;;02/04/04MH@DEL     nil
;;;02/04/04MH@DEL     (setq #eUPPER0$ (append #eUPPER0$ (list #eUP)))
;;;02/04/04MH@DEL   );_if
;;;02/04/04MH@DEL )
;;;02/04/04MH@DEL ; 02/01/16 YM ADD-E �������ق�ΏۊO�ɂ���
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL02/01/16 YM MOD  (foreach #eUP &eUPPER$
;;;02/04/04MH@DEL  (foreach #eUP #eUPPER0$
;;;02/04/04MH@DEL    ; �V��̨װ�s��Ή� 01/11/26 YM ADD G_LSYM�̑}���_���g�p�����A���ۂ̼���ٍ��W�l���g�p
;;;02/04/04MH@DEL    (setq #dSymPT (cdr (assoc 10 (entget #eUP)))) ; 01/11/26 YM ADD
;;;02/04/04MH@DEL    (setq #LSYM$ (CFGetXData #eUP "G_LSYM"))
;;;02/04/04MH@DEL    (setq #GSYM$ (CFGetXData #eUP "G_SYM"))
;;;02/04/04MH@DEL    ; �|�����C���_���X�g�擾
;;;02/04/04MH@DEL    (if (= CG_SKK_THR_CNR (CFGetSymSKKCode #eUP 3))
;;;02/04/04MH@DEL      ; �R�[�i�[�L���r�݂̂o�ʂ���擾������
;;;02/04/04MH@DEL      (progn
;;;02/04/04MH@DEL        ; �g�p�敪=2 ��P�ʂ��O���[�v�����猟��
;;;02/04/04MH@DEL        (setq #up-ss (CFGetSameGroupSS #eUP))
;;;02/04/04MH@DEL        (setq #i 0)
;;;02/04/04MH@DEL        (setq #ePMEN nil)
;;;02/04/04MH@DEL        (while (and (not #ePMEN) (< #i (sslength #up-ss)))
;;;02/04/04MH@DEL          (setq #en (ssname #up-ss #i))
;;;02/04/04MH@DEL          (setq #pxd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
;;;02/04/04MH@DEL          (if (and #pxd$ (= 2 (car #pxd$))) (setq #ePMEN #en))
;;;02/04/04MH@DEL          (setq #i (1+ #i))
;;;02/04/04MH@DEL        )
;;;02/04/04MH@DEL        (setq #dAREA$ (GetLWPolyLinePt #ePMEN)); �o�ʂQ�O�`�̈�_������߂�
;;;02/04/04MH@DEL        (setq #dAREA$ (PcChgCornerCabD$ #dSymPT #LSYM$ #dAREA$));;02/03/29MH@MOD�t�B���[��쓮
;;;02/04/04MH@DEL        ;;; (setq #dAREA$ (PcChgCornerCabD$ #LSYM$ #dAREA$)); �����␳ 01/01/28 MH ADD
;;;02/04/04MH@DEL      ); progn
;;;02/04/04MH@DEL      ; �R�[�i�[�L���r�ȊO�̃A�C�e������
;;;02/04/04MH@DEL      (progn
;;;02/04/04MH@DEL        ; ���s�l
;;;02/04/04MH@DEL        (cond
;;;02/04/04MH@DEL          ; �A�C�e���������W�t�[�h�A�T�C�h�p�l�������� (�אڂ���擾)
;;;02/04/04MH@DEL          ((= CG_SKK_ONE_RNG (CFGetSymSKKCode #eUP 1))
;;;02/04/04MH@DEL            (setq #fD (PcGetRange&SideFilrD #eUP &eUPPER$)) ; #eUPPER$ �� &eUPPER$ 02/01/16 YM MOD
;;;02/04/04MH@DEL;;;02/01/16 YM MOD            (setq #fD (PcGetRange&SideFilrD #eUP #eUPPER$)) ; �ϐ�#eUPPER$�͂����ŏ��߂ĂłĂ���.���������̂ł�?
;;;02/04/04MH@DEL          )
;;;02/04/04MH@DEL          ; ����ȊO�i�v�Z���^�[�L���r�␳�j
;;;02/04/04MH@DEL          (t (setq #fD (nth 4 #GSYM$)))
;;;02/04/04MH@DEL        )
;;;02/04/04MH@DEL        ; �͈͓_�Z�o (�p�x�Ɗ�_�͐}�`���狤�ʂŎ擾)
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL       ; �V��̨װ�s��Ή� 01/11/26 YM ADD G_LSYM�̑}���_���g�p�����A���ۂ̼���ٍ��W�l���g�p
;;;02/04/04MH@DEL        (setq #dAREA$ (PcMk4P$byWD&Ang #dSymPT (nth 3 #GSYM$) #fD (nth 2 #LSYM$)))
;;;02/04/04MH@DEL;;;01/11/26YM@MOD        (setq #dAREA$ (PcMk4P$byWD&Ang (cadr #LSYM$) (nth 3 #GSYM$) #fD (nth 2 #LSYM$)))
;;;02/04/04MH@DEL      ); progn
;;;02/04/04MH@DEL    ); if
;;;02/04/04MH@DEL    (setq #RES$ (cons (list #eUP #dAREA$) #RES$))
;;;02/04/04MH@DEL  ); foreach
;;;02/04/04MH@DEL  #RES$
;;;02/04/04MH@DEL); PcGetUpperItemPL$
;;;02/04/04MH@DEL<HOM>*************************************************************************
;;;02/04/04MH@DEL <�֐���>    : PcChgCornerCabD$
;;;02/04/04MH@DEL <�����T�v>  : �R�[�i�[�L���r�̔��ʂ��������O�`�_���X�g�쐬
;;;02/04/04MH@DEL <�߂�l>    :
;;;02/04/04MH@DEL <�쐬>      : 01-01-19 MH
;;;02/04/04MH@DEL <���l>      :
;;;02/04/04MH@DEL*************************************************************************>MOH<
;;;02/04/04MH@DEL(defun PcChgCornerCabD$ (
;;;02/04/04MH@DEL  &dSymPT     ; �R�[�i�[�L���r��_  ;; 02/03/29MH@ADD
;;;02/04/04MH@DEL  &LSYM$      ; �R�[�i�[�L���r��LSYM
;;;02/04/04MH@DEL  &dAREA$     ; P�ʓ_���X�g
;;;02/04/04MH@DEL  / 
;;;02/04/04MH@DEL  #err #jANG #LINE$ #i #TEMP$ #chkL #d0 #d1 #d2 #d3 #d4 #d5 #d6
;;;02/04/04MH@DEL  #d2new #d3new #d4new #dNEW$
;;;02/04/04MH@DEL  )
;;;02/04/04MH@DEL  (defun ##findPnt (&LN$ &dCHK / #chkL #TEMP$ #resP #resL$)
;;;02/04/04MH@DEL    (setq #resP nil)
;;;02/04/04MH@DEL    (setq #TEMP$ nil)
;;;02/04/04MH@DEL    (foreach #chkL &LN$
;;;02/04/04MH@DEL      (cond
;;;02/04/04MH@DEL        ((equal 0 (distance (car #chkL) &dCHK) 0.1)  (setq #resP (cadr #chkL)))
;;;02/04/04MH@DEL        ((equal 0 (distance (cadr #chkL) &dCHK) 0.1) (setq #resP (car #chkL)))
;;;02/04/04MH@DEL        (t (setq #TEMP$ (cons #chkL #TEMP$)))
;;;02/04/04MH@DEL      ); cond
;;;02/04/04MH@DEL    ); foreach
;;;02/04/04MH@DEL    (if #resP (setq #LINE$ #TEMP$) (setq #err nil))
;;;02/04/04MH@DEL    #resP
;;;02/04/04MH@DEL  ); defun
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL  (setq #err 'T)
;;;02/04/04MH@DEL  (setq #jANG (read (angtos (caddr &LSYM$) 0 3))); �ݒu�p�x
;;;02/04/04MH@DEL  ;;02/03/29MH@MOD �����I�t�Z�b�g�s�̕s��Ή�
;;;02/04/04MH@DEL  (setq #d0 &dSymPT) ; �R�[�i�[�L���r�̊�_���W
;;;02/04/04MH@DEL  ;;;(setq #d0 (cadr &LSYM$)) ; �R�[�i�[�L���r�̊�_���W
;;;02/04/04MH@DEL  (setq #d0 (list (car #d0) (cadr #d0)))
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL  (setq #i 1)
;;;02/04/04MH@DEL  (setq #LINE$ (list (list (car &dAREA$) (last &dAREA$))))
;;;02/04/04MH@DEL  (while (< #i (length &dAREA$))
;;;02/04/04MH@DEL    (setq #LINE$ (cons (list (nth (1- #i) &dAREA$) (nth #i &dAREA$)) #LINE$))
;;;02/04/04MH@DEL    (setq #i (1+ #i))
;;;02/04/04MH@DEL  ); while
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL  ; ��_����ݒu�p�x��ɂ���_ #d1
;;;02/04/04MH@DEL  (setq #TEMP$ nil)
;;;02/04/04MH@DEL  (foreach #chkL #LINE$
;;;02/04/04MH@DEL    (cond
;;;02/04/04MH@DEL      ((and (equal 0 (distance (car #chkL) #d0) 0.1)
;;;02/04/04MH@DEL            (equal #jANG (read (angtos (angle #d0 (cadr #chkL)) 0 3)) 0.001))
;;;02/04/04MH@DEL        (setq #d1 (cadr #chkL))
;;;02/04/04MH@DEL      )
;;;02/04/04MH@DEL      ((and (equal 0 (distance (cadr #chkL) #d0) 0.1)
;;;02/04/04MH@DEL            (equal #jANG (read (angtos (angle #d0 (car #chkL)) 0 3)) 0.001))
;;;02/04/04MH@DEL        (setq #d1 (car #chkL))
;;;02/04/04MH@DEL      )
;;;02/04/04MH@DEL      (t (setq #TEMP$ (cons #chkL #TEMP$)))
;;;02/04/04MH@DEL    ); cond
;;;02/04/04MH@DEL  ); foreach
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL  (if #d1 (setq #LINE$ #TEMP$) (setq #err nil))
;;;02/04/04MH@DEL  ; #d1���璼�p�̐���ɂ���_ #d2
;;;02/04/04MH@DEL  (if #err (setq #d2 (##findPnt #LINE$ #d1)))
;;;02/04/04MH@DEL  ; ��_�����_�p�x�{���p�̐���ɂ���_ #d5
;;;02/04/04MH@DEL  (if #err (setq #d5 (##findPnt #LINE$ #d0)))
;;;02/04/04MH@DEL  ; #d5���璼�p�̐���ɂ���_ #d4
;;;02/04/04MH@DEL  (if #err (setq #d4 (##findPnt #LINE$ #d5)))
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL  ; #d0 #d1 #d2 #d4 #d5 �܂Ŏ擾����Ă���ΐV�_�Z�o
;;;02/04/04MH@DEL  (if #err
;;;02/04/04MH@DEL    (progn
;;;02/04/04MH@DEL      (setq #d2new (pcpolar #d1 (angle #d1 #d2) (+ (distance #d1 #d2) -26)))
;;;02/04/04MH@DEL      (setq #d4new (pcpolar #d5 (angle #d5 #d4) (+ (distance #d5 #d4) -26)))
;;;02/04/04MH@DEL      (setq #d3new (inters #d2new (pcpolar #d2new (angle #d1 #d0) 100)
;;;02/04/04MH@DEL                           #d4new (pcpolar #d4new (angle #d5 #d0) 100) nil)
;;;02/04/04MH@DEL      ); setq
;;;02/04/04MH@DEL      (setq #dNEW$ (list #d0 #d1 #d2new #d3new #d4new #d5 #d0))
;;;02/04/04MH@DEL    )
;;;02/04/04MH@DEL    ; �_���łĂ��Ȃ���΁A���̓_���X�g�����̂܂ܕԂ�
;;;02/04/04MH@DEL    (setq #dNEW$ &dAREA$)
;;;02/04/04MH@DEL  )
;;;02/04/04MH@DEL  #dNEW$
;;;02/04/04MH@DEL); PcChgCornerCabD$

;;;02/04/05MH@DEL;<HOM>*************************************************************************
;;;02/04/05MH@DEL; <�֐���>    : PcSelItemForFiller
;;;02/04/05MH@DEL; <�����T�v>  : �E�H�[���ʒu�ɂ���A�C�e����I��������
;;;02/04/05MH@DEL; <�߂�l>    : �}�`���� nil (�L�����Z�����ꂽ�ꍇ)
;;;02/04/05MH@DEL; <�쐬>      : 01/02/02 MH
;;;02/04/05MH@DEL; <���l>      :
;;;02/04/05MH@DEL;*************************************************************************>MOH<
;;;02/04/05MH@DEL(defun PcSelItemForFiller (
;;;02/04/05MH@DEL    &sItem    ; �t�B���[�̖���
;;;02/04/05MH@DEL    &sFLG     ; �����擾="H" �ݒu�Ώۏ���"I"
;;;02/04/05MH@DEL    /
;;;02/04/05MH@DEL    #dum$ ;;02/03/29MH@ADD
;;;02/04/05MH@DEL    #en #sMsg #sMsg2 #NEXT$ #eCAB #i #eNT
;;;02/04/05MH@DEL  )
;;;02/04/05MH@DEL  (setq #sMsg2
;;;02/04/05MH@DEL    (cond
;;;02/04/05MH@DEL      ((= "I" &sFLG)
;;;02/04/05MH@DEL        (strcat "\n" &sItem "��ݒu����L���r�l�b�g��I�� �F")) ; 02/03/27 YM MOD ̰�ނ͑I�΂��Ȃ�
;;;02/04/05MH@DEL;;;02/03/27YM@MOD        (strcat "\n" &sItem "��ݒu����L���r�l�b�g�܂��̓����W�t�[�h��I�� �F"))
;;;02/04/05MH@DEL      ((= "H" &sFLG) (strcat "\n" &sItem
;;;02/04/05MH@DEL        "��ݒu����L���r�l�b�g��I�� /Enter=����<"             ; 02/03/27 YM MOD ̰�ނ͑I�΂��Ȃ�
;;;02/04/05MH@DEL;;;02/03/27YM@MOD        "��ݒu����L���r�l�b�g�܂��̓����W�t�[�h��I�� /Enter=����<"
;;;02/04/05MH@DEL        (itoa (fix CG_UpCabHeight)) ">�F"))
;;;02/04/05MH@DEL      (t "")
;;;02/04/05MH@DEL    ); cond
;;;02/04/05MH@DEL  ); setq
;;;02/04/05MH@DEL  (setq #sMsg "�ݒu����L���r�l�b�g��I�����Ă��������B")
;;;02/04/05MH@DEL  (setq #en 'T)
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  ; 02/03/27 YM ADD-S
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  (command "vpoint""0,0,1") ; �^�ォ��̎��_
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  ; 02/03/27 YM ADD-E
;;;02/04/05MH@DEL
;;;02/04/05MH@DEL  (while (and #en (not (= 'ENAME (type #en))))
;;;02/04/05MH@DEL   ; 02/03/27 YM ADD-S
;;;02/04/05MH@DEL   (setq #dum$ (entsel #sMsg2))
;;;02/04/05MH@DEL    (setq #en (car  #dum$))
;;;02/04/05MH@DEL;;;02/03/29YM@DEL    (setq CG_CLICK_PT (cadr #dum$))
;;;02/04/05MH@DEL;;;02/03/29YM@DEL    (setq CG_CLICK_PT (list (car (cadr #dum$)) (cadr (cadr #dum$)) ))
;;;02/04/05MH@DEL   ; 02/03/27 YM ADD-E
;;;02/04/05MH@DEL;;;02/03/27YM@MOD    (setq #en (car (entsel #sMsg2)))
;;;02/04/05MH@DEL    (if #en (progn
;;;02/04/05MH@DEL      (setq #en (SearchGroupSym #en))
;;;02/04/05MH@DEL      (if (or (not #en) (not (= CG_SKK_TWO_UPP (CFGetSymSKKCode #en 2)))) (progn
;;;02/04/05MH@DEL        (CFAlertMsg #sMsg)
;;;02/04/05MH@DEL        (setq #en 'T)
;;;02/04/05MH@DEL      )) ;if progn
;;;02/04/05MH@DEL    )) ;if progn
;;;02/04/05MH@DEL  );while
;;;02/04/05MH@DEL
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  ; 02/03/27 YM ADD-S
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  (command "zoom" "p") ; ���_�����ɖ߂�
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  ; 02/03/27 YM ADD-E
;;;02/04/05MH@DEL
;;;02/04/05MH@DEL  ;;;02/04/05MH@DEL02/03/29MH@ADD
;;;02/04/05MH@DEL  ; �}�E���g�^�t�[�h"328" ���w�肳�ꂽ�Ȃ�΃��b�Z�[�W���o����ƒ��~
;;;02/04/05MH@DEL  (if (and (= 'ENAME (type #en))
;;;02/04/05MH@DEL           (= 328 (nth 9 (CFGetXData #en "G_LSYM")))
;;;02/04/05MH@DEL      )
;;;02/04/05MH@DEL    (progn
;;;02/04/05MH@DEL      (CFAlertMsg "ϳ�Č^̰�ނ͑Ώۂ��珜�O����܂�\n�݌˂�د����Ă�������")
;;;02/04/05MH@DEL      (exit)
;;;02/04/05MH@DEL    )
;;;02/04/05MH@DEL  );_if
;;;02/04/05MH@DEL  ;;;02/03/29MH@ADD
;;;02/04/05MH@DEL
;;;02/04/05MH@DEL  ; �_�C�j���O�̂���L�^�΍�B��}�`���_�C�j���O�ȊO�Ɉڂ�
;;;02/04/05MH@DEL  (if (and (= 'ENAME (type #en)) (= CG_SKK_THR_DIN (CFGetSymSKKCode #en 3)))(progn
;;;02/04/05MH@DEL    (setq #NEXT$ (PcGetFillerAreaItem$ #en))
;;;02/04/05MH@DEL    (setq #eCAB nil)
;;;02/04/05MH@DEL    (setq #i 0)
;;;02/04/05MH@DEL    (while (and (not #eCAB) (< #i (length #NEXT$)))
;;;02/04/05MH@DEL      (setq #eNT (car (nth #i #NEXT$)))
;;;02/04/05MH@DEL      (if (and (= CG_SKK_ONE_CAB (CFGetSymSKKCode #eNT 1))   ; ����
;;;02/04/05MH@DEL               (/= CG_SKK_THR_DIN (CFGetSymSKKCode #eNT 3))) ; ���޲�ݸ�
;;;02/04/05MH@DEL        (setq #eCAB #eNT)
;;;02/04/05MH@DEL      )
;;;02/04/05MH@DEL      (setq #i (1+ #i))
;;;02/04/05MH@DEL    ); while
;;;02/04/05MH@DEL    (setq #en (if #eCAB #eCAB #en))
;;;02/04/05MH@DEL  )); if progn
;;;02/04/05MH@DEL  #en
;;;02/04/05MH@DEL);PcSelItemForFiller

;;;02/04/08MH@MOD;<HOM>*************************************************************************
;;;02/04/08MH@MOD; <�֐���>    : PcGetFilerOfsP&PL$
;;;02/04/08MH@MOD; <�����T�v>  : �t�B���[�̈�S�}�`���Ɨ̈�_�񂩂�t�B���[��}�����X�g�쐬
;;;02/04/08MH@MOD; <�߂�l>    : ((ofs�_  (P���_)) (ofs�_  (P���_))���)
;;;02/04/08MH@MOD; <�쐬>      : 00-10-04 MH
;;;02/04/08MH@MOD; <���l>      : P���_���X�g�̓��ƍŌオ���_�̏ꍇ�A����P���ł���Ɣ��f������
;;;02/04/08MH@MOD;*************************************************************************>MOH<
;;;02/04/08MH@MOD(defun PcGetFilerOfsP&PL$ (
;;;02/04/08MH@MOD  &eCAB       ; ��Ƃ���E�H�[���L���r�̐}�`��(�Z���^�[�p���ǂ����̔���p)
;;;02/04/08MH@MOD  &NEXT$      ; (�}�`�� (�O�`��P�_)) (�}�`�� (�O�`��P�_))���)
;;;02/04/08MH@MOD  &fOF        ; �I�t�Z�b�g�l
;;;02/04/08MH@MOD  &PLNFLG     ; �v������������N�����ꂽ�Ȃ�'T  �t���[�݌v�Ȃ�nil
;;;02/04/08MH@MOD  /
;;;02/04/08MH@MOD  #NEXT$ #baseXD$ #bsP #bsANG #BchkANG #SIDE_L #SIDE_R #LR #NT_regn #NT$ #r-ss
;;;02/04/08MH@MOD  #dPL$ #revFLG #chkL$ #LINEall$ #i #BchkANG  #chkL$ #cL #revFLG #revFLG #eCNR$
;;;02/04/08MH@MOD  #backPL$ #backL #ofsP #resPL$ #centerF #TEMP$ #ofP&PL$ #XD$ #ANG #eCNR$ #eNT #eCAB
;;;02/04/08MH@MOD  #jANG #sLR$ #chkANG #LFRpt$;00/10/25 SN ADD
;;;02/04/08MH@MOD  #BACKL$ #BCLP #BCRP #DBCPL$ #RESBCPL$ #STOPFLG ;02/03/29MH@MOD
;;;02/04/08MH@MOD  #DUMPT$ #OUTPLINE #OUTPLINE$ #R-SS-LINE #REGION ; 02/03/27 YM ADD
;;;02/04/08MH@MOD  )
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ;; U�^ L�^�̋��ʕ�
;;;02/04/08MH@MOD  (defun ##GetLUofP&PL ( &dPL$ &fOF &eCNR$ &sLR$ / ##BSP ##dPL$ ##ofsP ##XD$ ##XLD$)
;;;02/04/08MH@MOD    (setq ##dPL$ &dPL$)
;;;02/04/08MH@MOD    (setq ##XD$ (CFGetXData (last &eCNR$) "G_SYM"))
;;;02/04/08MH@MOD    (setq ##XLD$ (CFGetXData (last &eCNR$) "G_LSYM"))
;;;02/04/08MH@MOD    ;; 02/03/29MH@MOD ��_��LSYM�������Ă����̂ŕύX
;;;02/04/08MH@MOD    (setq ##BSP (cdr (assoc 10 (entget (last &eCNR$)))))
;;;02/04/08MH@MOD    ;;02/03/29MH@DEL(setq ##BSP (cadr ##XLD$))
;;;02/04/08MH@MOD    (setq ##BSP (list (car ##BSP) (cadr ##BSP)))
;;;02/04/08MH@MOD    ; �R�[�i�[�Ƃ��ă_�C�j���O�L���r���n���Ă����ꍇ�̊�_�ړ�
;;;02/04/08MH@MOD    (if (= CG_SKK_THR_DIN (CFGetSymSKKCode (last &eCNR$) 3))(progn
;;;02/04/08MH@MOD      (setq ##BSP (Pcpolar ##BSP (- (nth 2 ##XLD$) (* 0.5 pi)) (- (nth 4 ##XD$) 26)))
;;;02/04/08MH@MOD      (if (= "R" (last &sLR$)) ; �E������
;;;02/04/08MH@MOD        (setq ##BSP (Pcpolar ##BSP (nth 2 ##XLD$) (nth 3 ##XD$)))
;;;02/04/08MH@MOD      ); if
;;;02/04/08MH@MOD    )); if progn
;;;02/04/08MH@MOD    ; �����O�`�̈�_������p�L���r�̊�_�����ɂ���悤���בւ�
;;;02/04/08MH@MOD    (setq ##dPL$ (PcOrderPL$byOneP ##dPL$ ##BSP))
;;;02/04/08MH@MOD    ; ���p�L���r�̊�_�𔲂��āA�J�������ʐ��_���X�g�ɉ��H
;;;02/04/08MH@MOD    (repeat (length &eCNR$) (setq ##dPL$ (cdr ##dPL$)))
;;;02/04/08MH@MOD    ; �I�t�Z�b�g�_�擾 (AutoCad�̃o�O�Ȃ̂��A�����̉��z��_���I�t�Z�b�g�_��
;;;02/04/08MH@MOD    ; ����Ƌt�����Ɏ��s����� �����ɋ߂��I�t�Z�b�g��_�����_��)
;;;02/04/08MH@MOD    (setq ##ofsP (pcpolar (car ##dPL$) (angle (car ##dPL$) (cadr ##dPL$))
;;;02/04/08MH@MOD      (* 0.5 (distance (car ##dPL$) (cadr ##dPL$)))))
;;;02/04/08MH@MOD    (setq ##ofsP (pcpolar ##ofsP (angle (cadr ##dPL$) (caddr ##dPL$))
;;;02/04/08MH@MOD      (* 0.5 (distance (cadr ##dPL$) (caddr ##dPL$)))))
;;;02/04/08MH@MOD    ; �|�����C���I�t�Z�b�g����
;;;02/04/08MH@MOD    (setq ##dPL$ (PcOffsetFilerPL$ ##dPL$ ##ofsP &fOF &eCNR$ nil))
;;;02/04/08MH@MOD    ; ���ʍ��E�t���O���݂ăI�t�Z�b�g&����
;;;02/04/08MH@MOD    (setq ##dPL$ (PcPL$SidePart ##dPL$ &fOF))
;;;02/04/08MH@MOD    ; ���ʂ�Ԃ�
;;;02/04/08MH@MOD    (list (list ##ofsP ##dPL$))
;;;02/04/08MH@MOD  ); ##GetLUofP&PL
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; �`�F�b�N�Ώې}�`�����z�u�̃_�C�j���O�L���r�Ȃ�� 'T
;;;02/04/08MH@MOD  (defun ##ChkCornerDinning (&eCHK &NEXT$ / #FLG #eBF #eBF$ )
;;;02/04/08MH@MOD    (setq #FLG nil)
;;;02/04/08MH@MOD    (cond
;;;02/04/08MH@MOD      ((/= CG_SKK_THR_DIN (CFGetSymSKKCode &eCHK 3)) (setq #FLG nil)); �޲�ݸޗp��
;;;02/04/08MH@MOD      ; �}�` �O��̗אڂ���p�x�łȂ����_�C�j���O�ȊO
;;;02/04/08MH@MOD      (t (setq #eBF$ (PcGetEn$CrossArea &eCHK -5 -5 0 0 'T)) ; �}�`�̑O��̐}�`���E�o
;;;02/04/08MH@MOD         (foreach #eBF #eBF$ (if (assoc #eBF &NEXT$) (setq #FLG 'T))); �אڃ��X�g���ɂ���H
;;;02/04/08MH@MOD      )
;;;02/04/08MH@MOD    ); cond
;;;02/04/08MH@MOD    #FLG
;;;02/04/08MH@MOD  ); defun
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; ���ʂŗ��p�����}�`�̏��
;;;02/04/08MH@MOD  (setq #NEXT$ &NEXT$)
;;;02/04/08MH@MOD  (setq #baseXD$ (CFGetXData &eCAB "G_LSYM"))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ;; 02/03/29MH@MOD ��_��LSYM�������Ă����̂ŕύX
;;;02/04/08MH@MOD  (setq #bsP (cdr (assoc 10 (entget &eCAB))))
;;;02/04/08MH@MOD  (setq #bsP (list (car #bsP) (cadr #bsP)))
;;;02/04/08MH@MOD  ;;02/03/29MH@DEL (setq #bsP (list (car (cadr #baseXD$)) (cadr (cadr #baseXD$))))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  (setq #bsANG (nth 2 #baseXD$))
;;;02/04/08MH@MOD  (setq #BchkANG (read (angtos #bsANG 0 3)))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD; PosUpFiler �̏��������ɔ��� 01/12/17 YM DEL-S --------------------------------------------
;;;02/04/08MH@MOD;;;01/12/17YM@DEL  ; ���s�����ʕ��̗L��
;;;02/04/08MH@MOD;;;01/12/17YM@DEL  (if (not &PLNFLG) (progn
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    ; �t���[�݌v���炾�����烆�[�U�[���獶�E�̗L�������߂� 01/04/04 �w�ʎw��\�ɕύX
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (setq #SIDE_L SKW_FILLER_LSIDE)
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (setq #SIDE_R SKW_FILLER_RSIDE)
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (if (not (setq #BLR (PcGetFilerBLRDlg))) (progn (command "_Undo" "B") (exit)))
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (setq SKW_FILLER_BSIDE (if (car #BLR) 1 0))
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (setq SKW_FILLER_LSIDE (if (cadr #BLR) 1 0))
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (setq SKW_FILLER_RSIDE (if (caddr #BLR) 1 0))
;;;02/04/08MH@MOD;;;01/12/17YM@DEL  )); if progn
;;;02/04/08MH@MOD; PosUpFiler �̏��������ɔ��� 01/12/17 YM DEL-E --------------------------------------------
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; �S�אڐ}�`�̊O�`�������[�W������
;;;02/04/08MH@MOD  (setq #NT_regn (ssadd))
;;;02/04/08MH@MOD  (foreach #NT$ &NEXT$
;;;02/04/08MH@MOD    (MakeLwPolyLine (cadr #NT$) 1 0)
;;;02/04/08MH@MOD    (command "_region" (entlast) "")
;;;02/04/08MH@MOD    (ssadd (entlast) #NT_regn)
;;;02/04/08MH@MOD  ); foreach
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; ���[�W������1�P�ȏ�Ȃ猋�����Ĉ�ɂ���
;;;02/04/08MH@MOD  (if (< 1 (sslength #NT_regn)) (command "_union" #NT_regn ""))
;;;02/04/08MH@MOD  ; REGION�𕪉����A���������������|�����C��������
;;;02/04/08MH@MOD  (command "_explode" (entlast))
;;;02/04/08MH@MOD  (setq #r-ss (ssget "P"))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  ; 02/03/25 YM ADD-S �}�E���g�^̰�ޏ��O�����̴װ����
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  (setq #OutPline$ nil) ; �O�`PLINE��ؽ�
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  (if (and #r-ss (< 0 (sslength #r-ss))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL           (= "REGION" (cdr (assoc 0 (entget (ssname #r-ss 0))))))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    (progn ; "REGION"���܂܂�Ă���
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (setq #i 0)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (repeat (sslength #r-ss)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #region (ssname #r-ss #i))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (command "_explode" #region)  ; �eREGION�𕪉�
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #r-ss-line (ssget "P")) ;LINE�̑I���
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (command "_pedit" (entlast) "Y" "J" #r-ss-line "" "X") ; "X" ���ײ݂̑I�����I�� PLINE��
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #OutPline$ (append #OutPline$ (list (entlast))))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #i (1+ #i))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL;;;02/03/27YM@DEL     (CFAlertMsg "���̷���ȯĔz��ł͓V��̨װ�����������ł��܂���.\n(ϳ�Č^̰�ނ͑Ώۂ��珜�O����܂�)")
;;;02/04/08MH@MOD;;;02/03/29YM@DEL;;;02/03/27YM@DEL     (exit)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  );_if
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  ; 02/03/25 YM ADD-E
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  ; 02/03/27 YM MOD-S if���ŕ���
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  (if #OutPline$
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    (progn
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      ; CG_CLICK_PT ���܂܂��̈�̕��ɓV��̨װ��\��
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (command "vpoint" "0,0,1") ; �^�ォ��̎��_
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (foreach OutPline #OutPline$
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (command "_offset" 50 OutPline '(99999 99999) "") ; PLINE�������傫������
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #dum_PLINE (entlast))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #dumPT$ (GetLWPolyLinePt #dum_PLINE))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #dumPT$ (AddPtList #dumPT$)) ; �����Ɏn�_��ǉ�����
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (if (JudgeNaigai CG_CLICK_PT #dumPT$)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL          (progn
;;;02/04/08MH@MOD;;;02/03/29YM@DEL            (setq #OutPline OutPline) ; ������̗̈�ɓV��̨װ��\��
;;;02/04/08MH@MOD;;;02/03/29YM@DEL          )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL          (entdel OutPline)           ; ������̗̈�ɓV��̨װ��\��Ȃ��̂�PLINE���폜����
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        );_if
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (entdel #dum_PLINE)           ; �̾�Ă���PLINE���폜����
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (if (= nil #OutPline)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (progn
;;;02/04/08MH@MOD;;;02/03/29YM@DEL;;;02/03/27YM@MOD         (CFAlertMsg "���̷���ȯĔz��ł͓V��̨װ�����������ł��܂���.\n(ϳ�Č^̰�ނ͑Ώۂ��珜�O����܂�)")
;;;02/04/08MH@MOD;;;02/03/29YM@DEL          (CFAlertMsg "ϳ�Č^̰�ނ͑Ώۂ��珜�O����܂�\n�݌˂�د����Ă�������")
;;;02/04/08MH@MOD;;;02/03/29YM@DEL          (exit)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      );_if
;;;02/04/08MH@MOD;;;02/03/29YM@DEL
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (command "zoom" "p") ; ���_�����ɖ߂�
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (setq CG_CLICK_PT nil)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    (progn ; ���܂łǂ���
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ���ײ݂̑I�����I��
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (setq #OutPline (entlast))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  );_if
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  ; 02/03/27 YM MOD-E if���ŕ���
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD ; 02/03/29 YM MOD-S ���Ƃɖ߂���
;;;02/04/08MH@MOD  (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ���ײ݂̑I�����I��
;;;02/04/08MH@MOD  (setq #OutPline (entlast))
;;;02/04/08MH@MOD ; 02/03/29 YM MOD-E
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; �S�O�`�̈�_������߂�
;;;02/04/08MH@MOD  (setq #dPL$ (GetLWPolyLinePt #OutPline))
;;;02/04/08MH@MOD  (entdel #OutPline )
;;;02/04/08MH@MOD  ; �_����������E�ɂ��邽�߁A���̊p�x����}�`�p�x�Ɠ����Ȃ�S�O�`�̈�_�񃊃o�[�X
;;;02/04/08MH@MOD  (setq #i 0)
;;;02/04/08MH@MOD  (setq #revFLG nil)
;;;02/04/08MH@MOD  (setq #chkL$ nil)
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  (setq #LINEall$ (PcMkLine$byPL$ #dPL$ 'T)) ; �o�������X�g�ɕϊ�
;;;02/04/08MH@MOD  (while (and (not #chkL$) (< #i (length #LINEall$)))
;;;02/04/08MH@MOD    (setq #cL (nth #i #LINEall$))
;;;02/04/08MH@MOD    ; ��L���r�̊�_��ɂ���A�p�x��������180�x�t�̐���E�o
;;;02/04/08MH@MOD    (if (PcIsExistPOnLine #cL (list #bsP))
;;;02/04/08MH@MOD      (cond
;;;02/04/08MH@MOD        ((equal #BchkANG (read (angtos (angle (car #cL) (cadr #cL)) 0 3)) 0.01)
;;;02/04/08MH@MOD          (setq #chkL$ #cL)
;;;02/04/08MH@MOD          (setq #revFLG 'T)
;;;02/04/08MH@MOD        )
;;;02/04/08MH@MOD        ((equal #BchkANG (read (angtos (angle (cadr #cL) (car #cL)) 0 3)) 0.01)
;;;02/04/08MH@MOD          (setq #chkL$ #cL)
;;;02/04/08MH@MOD        )
;;;02/04/08MH@MOD        (t nil)
;;;02/04/08MH@MOD      ); cond
;;;02/04/08MH@MOD    ); if
;;;02/04/08MH@MOD    (setq #i (1+ #i))
;;;02/04/08MH@MOD  ); while
;;;02/04/08MH@MOD  ; ���̊p�x����}�`�p�x�Ɠ����Ȃ�S�O�`�̈�_�񃊃o�[�X
;;;02/04/08MH@MOD  (if #revFLG (setq #dPL$ (reverse #dPL$)))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; �אڐ}�`���X�g������A���p�L���r��E�o #eCNR$
;;;02/04/08MH@MOD  (setq #jANG (read (angtos (nth 2 (CFGetXData &eCAB "G_LSYM")) 0 3)))
;;;02/04/08MH@MOD  (setq #eCNR$ nil)
;;;02/04/08MH@MOD  (setq #sLR$ nil)
;;;02/04/08MH@MOD  (foreach #NT$ #NEXT$
;;;02/04/08MH@MOD    (setq #eNT (car #NT$))
;;;02/04/08MH@MOD    (setq #chkANG (nth 2 (CFGetXData #eNT "G_LSYM")))
;;;02/04/08MH@MOD    (if (or
;;;02/04/08MH@MOD      (and (= CG_SKK_THR_CNR (CFGetSymSKKCode #eNT 3)); ��Ű����
;;;02/04/08MH@MOD           (not (member #eNT #eCNR$)))
;;;02/04/08MH@MOD      (and (not (equal #jANG (atof (angtos #chkANG 0 3)) 0.1)) ; ��p�x�ƈقȂ�
;;;02/04/08MH@MOD           (not (member #eNT #eCNR$))
;;;02/04/08MH@MOD           (##ChkCornerDinning #eNT #NEXT$); �}�`�O��̗אڂɊ�p�x�̐}�`������
;;;02/04/08MH@MOD      ); and
;;;02/04/08MH@MOD        ); or
;;;02/04/08MH@MOD      (progn
;;;02/04/08MH@MOD        (setq #eCNR$ (cons #eNT #eCNR$))
;;;02/04/08MH@MOD        (if (and (= CG_SKK_THR_DIN (CFGetSymSKKCode #eNT 3))
;;;02/04/08MH@MOD                 (equal #jANG (atof (angtos (+ #chkANG (* -0.5 pi)) 0 3)) 0.001))
;;;02/04/08MH@MOD          (setq #sLR$ (cons "R" #sLR$))
;;;02/04/08MH@MOD          (setq #sLR$ (cons "L" #sLR$))
;;;02/04/08MH@MOD        ); if
;;;02/04/08MH@MOD      ); progn
;;;02/04/08MH@MOD    ); if
;;;02/04/08MH@MOD  ); foreach
;;;02/04/08MH@MOD  (if (< 2 (length #eCNR$)) (progn
;;;02/04/08MH@MOD    (CFAlertMsg "�Ώۗ̈�ɋ��p�E�H�[���L���r�l�b�g��2�ȏ㌟�o����܂���") (exit))
;;;02/04/08MH@MOD  ); if
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; �I�t�Z�b�g�_�ƃ|���_���X�g���쐬 #ofP&PL$
;;;02/04/08MH@MOD  (cond
;;;02/04/08MH@MOD    ; �h�^ (���p�L���r�Ȃ�)
;;;02/04/08MH@MOD    ((not #eCNR$)
;;;02/04/08MH@MOD      ; �w�ʐ��擾
;;;02/04/08MH@MOD      (setq #i 0)
;;;02/04/08MH@MOD      (setq #backL$ nil)
;;;02/04/08MH@MOD      (setq #LINEall$ (PcMkLine$byPL$ #dPL$ 'T)) ; �o�������X�g�ɕϊ�
;;;02/04/08MH@MOD      (while (< #i (length #LINEall$))
;;;02/04/08MH@MOD        (setq #cL (nth #i #LINEall$))
;;;02/04/08MH@MOD        ; �p�x����}�`�Ƃ�180�x�t�����̐����w�ʐ�(�����擾)
;;;02/04/08MH@MOD        (if (equal #BchkANG (read (angtos (angle (cadr #cL) (car #cL)) 0 3)) 0.01)
;;;02/04/08MH@MOD          (setq #backPL$ (cons #cL #backPL$))) ;if
;;;02/04/08MH@MOD        (setq #i (1+ #i))
;;;02/04/08MH@MOD      ); while
;;;02/04/08MH@MOD      ;; �Z���^�[�L���r�ɂ͑O�ʍ��킹�̏ꍇ�L�B
;;;02/04/08MH@MOD      ;; �S�̂��A�w�ʃp�[�g�ƑO�ʃp�[�g�ɕ�����
;;;02/04/08MH@MOD      ; �w�ʃ��X�g#backPL$���� �ō��_ �ƍŉE�_�� ������
;;;02/04/08MH@MOD      (setq #bcLP (PcGetSidePinPL$ #backPL$ #bsANG "L")) ; #backPL$���� �ō��_
;;;02/04/08MH@MOD      (setq #bcRP (PcGetSidePinPL$ #backPL$ #bsANG "R")) ; #backPL$���� �ŉE�_
;;;02/04/08MH@MOD      ; �����O�`�̈�_�� #dPL$ �� �w�ʐ����̍ō��_�����ɂ���悤���בւ���
;;;02/04/08MH@MOD      (setq #dPL$ (PcOrderPL$byOneP #dPL$ #bcLP))
;;;02/04/08MH@MOD      ; #dBCPL$ �w�ʃp�[�g
;;;02/04/08MH@MOD      (setq #TEMP$ #dPL$)
;;;02/04/08MH@MOD      (while (and (car #TEMP$) (not (equal #bcRP (car #TEMP$) 0.01)))
;;;02/04/08MH@MOD        (setq #TEMP$ (cdr #TEMP$))
;;;02/04/08MH@MOD      ); while
;;;02/04/08MH@MOD      (setq #dBCPL$ (append #TEMP$ (list (car #dPL$))))
;;;02/04/08MH@MOD      ; #dPL$ = �O�ʃp�[�g
;;;02/04/08MH@MOD      (setq #i 0)
;;;02/04/08MH@MOD      (setq #TEMP$ nil)
;;;02/04/08MH@MOD      (setq #stopFLG nil)
;;;02/04/08MH@MOD      (while (and (not #stopFLG) (< #i (length #dPL$)))
;;;02/04/08MH@MOD        (setq #TEMP$ (append #TEMP$ (list (nth #i #dPL$))))
;;;02/04/08MH@MOD        (if (equal #bcRP (nth #i #dPL$) 0.01) (setq #stopFLG 'T))
;;;02/04/08MH@MOD        (setq #i (1+ #i))
;;;02/04/08MH@MOD      ); while
;;;02/04/08MH@MOD      (setq #dPL$ #TEMP$)
;;;02/04/08MH@MOD      ; �h�^���ʃI�t�Z�b�g�_�F�S�̂̒���
;;;02/04/08MH@MOD      (setq #ofsP (Pcpolar (car #dPL$) (angle (car #dPL$) (last #dPL$))
;;;02/04/08MH@MOD        (* 0.5 (distance (car #dPL$) (last #dPL$)))))
;;;02/04/08MH@MOD      (setq #ofsP (Pcpolar #ofsP (+ #bsANG (* -0.5 pi))
;;;02/04/08MH@MOD        (* 0.5 (nth 4 (CFGetXData &eCAB "G_SYM")))))
;;;02/04/08MH@MOD      ; ����Z���^�[�p���ǂ����̃t���O�B�Z���^�[�p= 'T
;;;02/04/08MH@MOD      (setq #centerF (= 1 SKW_FILLER_BSIDE)) ;01/04/04 �w�ʎw��\�ɕύX
;;;02/04/08MH@MOD      ; �Z���^�[�p�Ȃ�A�w�ʃI�t�Z�b�g����
;;;02/04/08MH@MOD      (if #centerF (setq #resBCPL$ (PcOffsetFilerBCPL$ #dBCPL$ #ofsP &fOF #bsANG)))
;;;02/04/08MH@MOD      ;010204MHDEL(setq #centerF (PcChkCenterUpper &eCAB))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD      ;�|�����C���O�ʃI�t�Z�b�g����
;;;02/04/08MH@MOD      (setq #resPL$ (PcOffsetFilerPL$ #dPL$ #ofsP &fOF nil nil))
;;;02/04/08MH@MOD      (setq #ofP&PL$ nil)
;;;02/04/08MH@MOD      (cond
;;;02/04/08MH@MOD        ; ���ʍ��E�Ȃ�
;;;02/04/08MH@MOD        ((= 0 (+ SKW_FILLER_LSIDE SKW_FILLER_RSIDE))
;;;02/04/08MH@MOD          ; �Z���^�[�p�������i���ʂƔw�ʂŃ��X�g���Q�K�v�j
;;;02/04/08MH@MOD          (if #centerF (setq #ofP&PL$ (list (list #ofsP #resBCPL$)))); �w�ʃ��X�g�擾
;;;02/04/08MH@MOD          ; �o�_���X�g���獶�E���Ǔ_�폜
;;;02/04/08MH@MOD          (setq #i 1)
;;;02/04/08MH@MOD          (setq #TEMP$ nil)
;;;02/04/08MH@MOD          (while (< #i (1- (length #resPL$)))
;;;02/04/08MH@MOD            (setq #TEMP$ (append #TEMP$ (list (nth #i #resPL$))))
;;;02/04/08MH@MOD            (setq #i (1+ #i))
;;;02/04/08MH@MOD          ); while
;;;02/04/08MH@MOD          (setq #resPL$ #TEMP$)
;;;02/04/08MH@MOD          ; ���ʂɐ��ʃ��X�g���Z�b�g
;;;02/04/08MH@MOD          (setq #ofP&PL$ (cons (list #ofsP #resPL$) #ofP&PL$))
;;;02/04/08MH@MOD        ) ; ���ʍ��E�Ȃ�
;;;02/04/08MH@MOD        (t
;;;02/04/08MH@MOD          ; ���ʍ��E�t���O���݂đ��ʕ��̃I�t�Z�b�g&��������
;;;02/04/08MH@MOD          (setq #resPL$ (PcPL$SidePart #resPL$ &fOF))
;;;02/04/08MH@MOD          ;(if #resBCPL$ (setq #resBCPL$ (PcPL$SidePart2 #bsANG #resBCPL$ &fOF)))
;;;02/04/08MH@MOD          (setq #LFRpt$ #resPL$);00/10/25 SN ADD ����-�O��-�E���̏��ɕ��񂾂Ƒz�肵���_ؽ�
;;;02/04/08MH@MOD          ; �Z���^�[�p�ł������ꍇ�̔w�ʓ_�ǉ�
;;;02/04/08MH@MOD          (if #centerF
;;;02/04/08MH@MOD            (cond
;;;02/04/08MH@MOD              ; �����ʂ݂̂�����
;;;02/04/08MH@MOD              ((= 0 SKW_FILLER_RSIDE)
;;;02/04/08MH@MOD                (setq #resPL$ (append (reverse (cdr (reverse #resBCPL$))) #resPL$)))
;;;02/04/08MH@MOD              ; �E���ʂ̂݁A���邢�� ���E���ʂƂ��ɂ���
;;;02/04/08MH@MOD              (t (setq #resPL$ (append #resPL$ (cdr #resBCPL$)))); t
;;;02/04/08MH@MOD            ); cond
;;;02/04/08MH@MOD          ); if �Z���^�[
;;;02/04/08MH@MOD          ; ���ʂ��Z�b�g
;;;02/04/08MH@MOD          (setq #ofP&PL$ (list (list #ofsP #resPL$)))
;;;02/04/08MH@MOD        ) ; ���ʂ���
;;;02/04/08MH@MOD      ); cond
;;;02/04/08MH@MOD    ); �h
;;;02/04/08MH@MOD    ; �k�^ (���p�L���r�̐� �P)
;;;02/04/08MH@MOD    ((= 1 (length #eCNR$))
;;;02/04/08MH@MOD      (setq #ofP&PL$ (##GetLUofP&PL #dPL$ &fOF #eCNR$ #sLR$))
;;;02/04/08MH@MOD      (setq #LFRpt$ (car (cdr (car #ofP&PL$))));00/10/25 SN ADD ����-�O��-�E���̏��ɕ��񂾂Ƒz�肵���_ؽ�
;;;02/04/08MH@MOD    ); �k
;;;02/04/08MH@MOD    ; �t�^ (���p�L���r�̐� �Q)
;;;02/04/08MH@MOD    ((= 2 (length #eCNR$))
;;;02/04/08MH@MOD     ; #eCNR$ �������č����Ɉʒu����L���r����ڂɂ���悤���בւ�
;;;02/04/08MH@MOD      (setq #XD$ (CFGetXData (cadr #eCNR$) "G_LSYM"))
;;;02/04/08MH@MOD     ; 02/03/29MH@MOD ��_��LSYM�������Ă����̂ŕύX
;;;02/04/08MH@MOD      (setq #bsP (cdr (assoc 10 (entget (cadr #eCNR$)))))
;;;02/04/08MH@MOD      (setq #bsP (list (car #bsP) (cadr #bsP)))
;;;02/04/08MH@MOD     ; ��ڂ̃L���r�̊�_����ݒu�p�x�̉�������Ɉ�ڂ̃L���r��_��
;;;02/04/08MH@MOD     ; ����Ώ��Ԃ����ւ���
;;;02/04/08MH@MOD     (if (PcIsExistPOnLine (list #bsP (Pcpolar #bsP (nth 2 #XD$) 10000))
;;;02/04/08MH@MOD            (list (cdr (assoc 10 (entget (car #eCNR$))))))
;;;02/04/08MH@MOD        (setq #eCNR$ (list (cadr #eCNR$)(car #eCNR$)))
;;;02/04/08MH@MOD      ); if
;;;02/04/08MH@MOD     ;;02/03/29MH@DEL (setq #bsP (list (car (cadr #XD$)) (cadr (cadr #XD$))))
;;;02/04/08MH@MOD     ;;02/03/29MH@DEL (if (PcIsExistPOnLine (list #bsP (Pcpolar #bsP (nth 2 #XD$) 10000))
;;;02/04/08MH@MOD     ;;02/03/29MH@DEL       (list (cadr (CFGetXData (car #eCNR$) "G_LSYM"))))
;;;02/04/08MH@MOD     ;;02/03/29MH@DEL   (setq #eCNR$ (list (cadr #eCNR$)(car #eCNR$)))
;;;02/04/08MH@MOD     ;;02/03/29MH@DEL ); if
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD     (setq #ofP&PL$ (##GetLUofP&PL #dPL$ &fOF #eCNR$ #sLR$))
;;;02/04/08MH@MOD      (setq #LFRpt$ (car (cdr (car #ofP&PL$))));00/10/25 SN ADD ����-�O��-�E���̏��ɕ��񂾂Ƒz�肵���_ؽ�
;;;02/04/08MH@MOD    ); �t
;;;02/04/08MH@MOD  ); cond
;;;02/04/08MH@MOD  ; 00/10/25 SN S-ADD ���s�����̒������擾����B
;;;02/04/08MH@MOD  (if (= SKW_FILLER_LSIDE 1);�����s��������
;;;02/04/08MH@MOD    ; THEN �_ؽĂ̐擪�Q�_�������s�����̒����Ƃ���B
;;;02/04/08MH@MOD    (setq SKW_FILLER_LLEN
;;;02/04/08MH@MOD      (distance (car #LFRpt$) (cadr #LFRpt$))
;;;02/04/08MH@MOD    )
;;;02/04/08MH@MOD    ; ELSE �Ȃ����0
;;;02/04/08MH@MOD    (setq SKW_FILLER_LLEN 0.0)
;;;02/04/08MH@MOD  );end if
;;;02/04/08MH@MOD  (if (= SKW_FILLER_RSIDE 1);�E���s��������
;;;02/04/08MH@MOD    ; THEN �_ؽĂ̌���Q�_���E���s�����̒����Ƃ���B
;;;02/04/08MH@MOD    (setq SKW_FILLER_RLEN
;;;02/04/08MH@MOD      ;�Ō���̂Q�_�Ԃ����s�Ƃ���B
;;;02/04/08MH@MOD      (distance (nth (- (length #LFRpt$) 2) #LFRpt$) (nth (- (length #LFRpt$) 1) #LFRpt$))
;;;02/04/08MH@MOD    )
;;;02/04/08MH@MOD    ; ELSE �Ȃ����0
;;;02/04/08MH@MOD    (setq SKW_FILLER_RLEN 0.0)
;;;02/04/08MH@MOD  );end if
;;;02/04/08MH@MOD  ; 00/10/25 SN E-ADD ���s�����̒������擾����B
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD;;;01/12/19YM@MOD  (if (not &PLNFLG) (progn
;;;02/04/08MH@MOD;;;01/12/19YM@MOD    (setq SKW_FILLER_LSIDE #SIDE_L) ;�O���[�o����߂�
;;;02/04/08MH@MOD;;;01/12/19YM@MOD    (setq SKW_FILLER_RSIDE #SIDE_R) ;�O���[�o����߂�
;;;02/04/08MH@MOD;;;01/12/19YM@MOD  )); if progn
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD ; 01/12/19 YM MOD-S
;;;02/04/08MH@MOD (setq SKW_FILLER_LSIDE 0) ; ���ɖ߂�
;;;02/04/08MH@MOD (setq SKW_FILLER_RSIDE 0) ; ���ɖ߂�
;;;02/04/08MH@MOD ; 01/12/19 YM MOD-S
;;;02/04/08MH@MOD(setq ##ofP&PL$ #ofP&PL$)
;;;02/04/08MH@MOD  #ofP&PL$
;;;02/04/08MH@MOD); PcGetFilerOfsP&PL$

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KP_SETFilerKOSU
;;; <�����T�v>  : �V��̨װ������
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 02/11/10 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KP_SETFilerKOSU (
  /
  #FILER #HINBAN #KOSU #KOSU_NEW #LOOP #RET #XD$ #XDOPT$ #DUM #DUM$ #I #LIS$ #OPT_OLD$
;-- 2011/08/11 A.Satoh Add - S
  #syokei #ret$
;-- 2011/08/11 A.Satoh Add - E
  )

  ;// �R�}���h�̏�����
  (StartUndoErr)
  (CFCmdDefBegin 6);00/09/26 SN ADD

  ;// �V��t�B���[�̎w��
  (setq #xd$ nil)
  (setq #loop T)
  (while #loop
    (setq #Filer (car (entsel "\n�V��t�B���[��I��: ")))
    (if #Filer
      (setq #xd$ (CFGetXData #Filer "G_FILR"))
      (setq #xd$ nil)
    );_if

    (if (= #xd$ nil)
      (CFAlertMsg "�V��t�B���[�ł͂���܂���B")
      (setq #loop nil)
    );_if
  );while

;-- 2011/08/11 A.Satoh Add - S
  (setq #syokei (nth 7 #xd$))
;-- 2011/08/11 A.Satoh Add - E

  ; Xdata regapp
  (if (= (tblsearch "APPID" "G_OPT") nil) (regapp "G_OPT"))

  (setq #HINBAN (nth 0 #xd$)) ; �V��̨װ�i��
  (setq #xdOPT$ (CFGetXData #Filer "G_OPT")) ; �����̾�Č�
;;;(-3 (G_OPT (1070 . 1) (1000 . SDKA105SCK) (1070 . 1))

  (setq #lis$ (cdr #xdOPT$)) ; �i��1,��1,�i��2,��2,...��ؽ�
  (setq #opt_old$ nil)       ; (�i��1,��1)(�i��2,��2),...
  (setq #i 0)
  (foreach #lis #lis$
    ; �i��,��,�i��,��,...�̏���
    (if (= 0 (rem #i 2))
      (setq #dum #lis)
      (setq #opt_old$ (append #opt_old$ (list (list #dum #lis))))
    );_if
    (setq #i (1+ #i))
  );foreach

  (if #xdOPT$
    (progn
      (setq #dum$ (assoc #hinban #opt_old$))
      (if #dum$
        (setq #KOSU (1+ (cadr #dum$))) ; �����擾
      ; else
        (setq #KOSU 1) ; ���擾�ł��Ȃ�
      );_if
    )
    (progn
      (setq #KOSU 1)
    )
  );_if

  ; �����͉�ʕ\��
;-- 2011/08/11 A.Satoh Mod - S
;  (setq #ret (KPGetFilerKOSUDlg #Hinban #KOSU)) ; �K�v���v��
  (setq #ret$ (KPGetFilerKOSUDlg #Hinban #KOSU #syokei))
;-- 2011/08/11 A.Satoh Mod - E

;-- 2011/08/11 A.Satoh Mod - S
;  (if (and #ret (/= #ret #KOSU))
;    (progn ; ���X�V���K�v
;      (setq #KOSU_new (1- #ret))
;      ;;; PcSetOpt$G_OPT (�}�`,���eؽ�) ���eؽ�=((�i��  ��) (�i��  ��) (�i��  ��)�c)
;      (SetOpt #Filer (list (list #Hinban #KOSU_new)))
;      (princ "\n�V��̨װ�̌���ύX���܂����B")
;    )
;  ; else
;    (princ "\n�V��̨װ�̌���ύX���܂���ł����B")
;  );_if
  (if #ret$
    (progn
      (CFSetXData #Filer "G_FILR"
        (list
          (nth 0 #xd$)  ; �i��
          (nth 1 #xd$)  ; ��w
          (nth 2 #xd$)  ; PLINE�n���h��
          (nth 3 #xd$)  ; �Œ�l
          (nth 4 #xd$)  ; �Œ�l
          (nth 5 #xd$)  ; ���T�C�h�̒���
          (nth 6 #xd$)  ; �E�T�C�h�̒���
          (nth 1 #ret$) ; ���v����
        )
      )

      (if (/= (nth 0 #ret$) #KOSU)
        (progn ; ���X�V���K�v
          (setq #KOSU_new (1- (nth 0 #ret$)))
          ;;; PcSetOpt$G_OPT (�}�`,���eؽ�) ���eؽ�=((�i��  ��) (�i��  ��) (�i��  ��)�c)
          (SetOpt #Filer (list (list #Hinban #KOSU_new)))
          (princ "\n�V��̨װ�̌���ύX���܂����B")
        )
      ; else
        (princ "\n�V��̨װ�̌���ύX���܂���ł����B")
      );_if
    )
  )
;-- 2011/08/11 A.Satoh Mod - E


  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)

);C:KP_SETFilerKOSU

;<HOM>*************************************************************************
; <�֐���>    : SetOpt
; <�����T�v>  : �n���ꂽ���X�g�̓��e��"G_OPT"�ɒǉ�/�폜/�܂��͐V�K�ݒu����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/11/11 YM
; <���l>      : ���X�g�`�� ((�i��  ��) (�i��  ��) (�i��  ��)�c)
;               ����0�Ȃ�폜����.���ɓo�^����Ă���i�ԂȂ琔��ǉ�����
;*************************************************************************>MOH<
(defun SetOpt (
  &eEN       ; �ݒ�Ώۂ̐}�`��
  &OPT$      ; �ǉ�(or �V�K)�I�v�V�������e���X�g
  /
  #GOP$ #HINBAN #HINBAN$ #I #IHIN #LIS$ #NUM #OP$ #OPFLG #OPT$ #XD$
  #ELM #KOSU$ #OPT_OLD$
  )

  (setq #xd$ (CFGetXData &eEN "G_OPT"))
  
  (if #xd$
    (progn ; "G_OPT"�����݂��遨���ɓo�^����Ă���i�Ԃƌ����擾����
      (setq #num  (car #xd$)) ; ��߼�ݕi�̎�ނ̐�
      (setq #lis$ (cdr #xd$)) ; �i��1,��1,�i��2,��2,...��ؽ�
      (setq #opt_old$ nil)    ; (�i��1,��1)(�i��2,��2),...
      (setq #i 0)
      (foreach #lis #lis$
        ; �i��,��,�i��,��,...�̏���
        (if (= 0 (rem #i 2))
          (setq #hinban #lis)
          (setq #opt_old$ (append #opt_old$ (list (list #hinban #lis))))
        );_if
        (setq #i (1+ #i))
      );foreach

      (setq #hinban$ (mapcar  'car #opt_old$)) ; �i��1,�i��2,...
      (setq #kosu$   (mapcar 'cadr #opt_old$)) ; ��1,��2,...

      (foreach OPT &OPT$
        (if (member (car OPT) #hinban$)
          (progn ; ���ɓ����i�Ԃ��o�^����Ă���
            (setq #elm (assoc (car OPT) #opt_old$)) ; �Ώۂ̗v�f
            (if (= 0 (cadr OPT))
              (progn ; ؽĂ���v�f���폜����
                (setq #opt_old$ (vl-remove #elm #opt_old$))
                (if (= #opt_old$ nil)
                  (progn ; �v�f���Ȃ��Ȃ�����"G_OPT"���폜����
                    (DelAppXdata &eEN "G_OPT")
                  )
                );_if
              )
              (progn ; ����ύX����
                (setq #opt_old$ (subst OPT #elm #opt_old$))
              )
            );_if
          )
        ; else
          (progn ; "G_OPT"�͂��邪�Ώۂ̕i�Ԃ��܂��o�^����Ă��Ȃ�
            (if (= 0 (cadr OPT))
              nil ; ��0�Ȃ牽�����Ȃ�
            ; else
              (setq #opt_old$ (append #opt_old$ (list OPT)))
            );_if
          )
        );_if

      );foreach

      (if (= #opt_old$ nil)
        nil ; "G_OPT"�폜�ς�
      ; else
        (progn
          (setq #GOP$ (cons (length #opt_old$) (apply 'append #opt_old$)))
          (CFSetXData &eEN "G_OPT" #GOP$) ;�ό`������ؽĂ�"G_OPT"�ݒ�
        )
      );_if
;;;     (PcSetOpt$G_OPT �}�` ؽ�)
    )
  ; else
    (progn ; �I�v�V������񖳂� = �V�K�ݒu
      (if (= (tblsearch "APPID" "G_OPT") nil) (regapp "G_OPT"))
      (setq #OP$ (append (list (length &OPT$)) (apply 'append &OPT$)))
      (CFSetXData &eEN "G_OPT" #OP$)
    )
  );_if
  (princ)
);PcSetOpt$G_OPT

;<HOM>*************************************************************************
; <�֐���>    : KPGetFilerKOSUDlg
; <�����T�v>  : ̨װ�������޲�۸�
; <�߂�l>    : ��
; <�쐬>      : 02/11/10 YM
;*************************************************************************>MOH<
(defun KPGetFilerKOSUDlg ( 
  &Hinban
  &KOSU
;-- 2011/08/11 A.Satoh Add - S
  &SYOKEI
;-- 2011/08/11 A.Satoh Add - E
  /
  #DCL_ID #RET
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #KOSU #ret
;-- 2011/08/11 A.Satoh Add - S
            #kitchin #syokei
;-- 2011/08/11 A.Satoh Add - E
            )
            (setq #KOSU (read (get_tile "edtBOX"))) ; ̨װ��
;-- 2011/08/11 A.Satoh Add - S
            (setq #kitchin (get_tile "radio_A"))
            (if (= #kitchin "1")
              (setq #syokei "A")
              (setq #syokei "D")
            )
;-- 2011/08/11 A.Satoh Add - E

            (if (and (= (type #KOSU) 'INT)(> #KOSU 0))
              (progn
                (done_dialog)     ; ���p����1�ȏゾ����
;-- 2011/08/11 A.Satoh Add - S
;                (setq #ret #KOSU) ; �߂�l ��
                (setq #ret (list #KOSU #syokei)) ; �߂�l (�� ���v���)
;-- 2011/08/11 A.Satoh Add - E
              )
              (progn
                (alert "1�ȏ�̔��p��������͂��ĉ�����")
                (set_tile "edtBOX" "")
                (mode_tile "edtBOX" 2)
                (princ)
              )
            );_if

          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;; �_�C�A���O�̎��s��
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "GetFilerKOSUDlg" #dcl_id)) (exit))

  ; �����l
  (set_tile "text2" &Hinban)       ; ������(�i��)
  (set_tile "edtBOX" (rtos &KOSU)) ; ������(�������l)
;-- 2011/08/11 A.Satoh Add - S
  (if (= &SYOKEI "A")
    (set_tile "radio_A" "1")     ; �L�b�`��
    (set_tile "radio_D" "1")     ; ���[
  )
;-- 2011/08/11 A.Satoh Add - E

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #ret (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; ���ʃ��X�g��Ԃ�
  #ret
); KPGetFilerKOSUDlg

(princ)

