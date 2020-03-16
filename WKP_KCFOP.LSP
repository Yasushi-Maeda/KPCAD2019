
;<HOM>*************************************************************************
; <�֐���>    : C:SCFOutPattern
; <�����T�v>  : �o�̓p�^�[���ݒ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-17
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun C:SCFOutPattern (
  /
  #Txt$ #DclRet$
  )

  (SCFStartShori "SCFOutPattern")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  ; 2000/07/04 HT DEL ���i�} �{�H�}�I���Ȃ���  START
  ;���_����
  ; (setq #View$
  ;  (list
  ;    (list "02" "L")    ; ���i�}
  ;    (list "03" "S")    ; �{�H�}
  ;  )
  ;)
  ; 2000/07/04 HT DEL ���i�} �{�H�}�I���Ȃ���  END

  ;TXT�Ǎ���
  ; �p�^�[���ݒ��ǂݍ���
  ; ���i�}�Ǝ{�H�}�쐬�̐ݒ�́A���g�p�i���@����_�C�A���O�Őݒ�ɕύX2000/07/04�j
  (setq #Txt$ (SKOutPatReadScv (strcat CG_SKPATH "outpat.cfg")))
  ;�_�C�A���O�\��
  ; 2000/07/04 HT MOD ���i�} �{�H�}�I���Ȃ���  
  ; (setq #DclRet$ (SCFOutPatDlgMain #Txt$ #View$))
  (setq #DclRet$ (SCFOutPatDlgMain #Txt$))
  (if (/= nil #DclRet$)
    (progn
      ;TXT�o��
      (SCFOutPatWriteScv (strcat CG_SKPATH "outpat.cfg") #DclRet$)
    )
  )

  ; �I������ 2000/09/07 HT
  (SCFEndShori)
  (princ)
) ; C:SCFOutPattern

;<HOM>*************************************************************************
; <�֐���>    : SCFOutPatDlgMain
; <�����T�v>  : �o�̓p�^�[���ݒ�_�C�A���O
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-17
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCFOutPatDlgMain (
  &Txt$       ; �o�������̧��ؽ�
  ; &View$      ; ���_����ؽ�  ; 2000/07/04 HT DEL ���i�} �{�H�}�I���Ȃ���
  /
  #iId #iRet #sNo #sYashi #iType
  )

  ;ؽ��ޯ���ɒl��\������
  (defun ##SetList ( &sKey &List$ / #vAl )
    (start_list &sKey)
    (foreach #vAl &List$
      (add_list #vAl)
    )
    (end_list)
  )
  ;����݂�V�K�o�^����
  (defun ##New_Click (
    /
    #sNpat #sPat #iAuto #A$ #H$ #iI
    )
    (setq #sNpat (get_tile "edtPat"))
    (cond
      ((= "" #sNpat)
        (CFAlertMsg "����ݖ�����͂��Ă�������.")
      )
      ((member (strcase #sNpat) #Pat$)
        (CFAlertMsg "���͂��ꂽ����ݖ��͊��ɑ��݂��܂�.")
        (mode_tile "edtPat" 2)
      )
      (T
        (setq #New$ (list (strcase #sNpat) 1))
        (setq #Txt$ (SCFOpSortList (append #Txt$ (list #New$))))
        (setq #Pat$  (mapcar 'car  #Txt$))
        (setq #Auto$ (mapcar 'cadr #Txt$))
        (##SetList "popPat" #Pat$)
        (set_tile "edtPat" "")
        (setq #iI 0)
        (mapcar
         '(lambda ( #sPat )
            (if (equal #sPat (strcase #sNpat))
              (set_tile "popPat" (itoa #iI))
            )
            (setq #iI (1+ #iI))
          )
          #Pat$
        )
        (##Pat_Change)
      )
    )
  )
  ;����ݖ���ύX����
  (defun ##Edt_Click (
    /
    #sEpat #sFpat #Edit$ #iI #sPat
    )
    (setq #sEpat (strcase (get_tile "edtPat")))
    (setq #sFpat (nth (atoi (get_tile "popPat")) #Pat$))
    (cond
      ((= "" #sEpat)
        (CFAlertMsg "�ύX��������ݖ�����͂��Ă�������.")
      )
      ((member #sEpat #Pat$)
        (CFAlertMsg "���͂��ꂽ����ݖ��͊��ɑ��݂��܂�.")
        (mode_tile "edtPat" 2)
      )
      (T
        (setq #Edit$ (append (list #sEpat 1) (cdr (cdr (assoc #sFpat #Txt$)))))
        (setq #Txt$ (SCFSubstList #Txt$ (atoi (get_tile "popPat")) #Edit$))
        (setq #Txt$ (SCFOpSortList #Txt$))
        (setq #Pat$  (mapcar 'car  #Txt$))
        (setq #Auto$ (mapcar 'cadr #Txt$))
        (##SetList "popPat" #Pat$)
        (set_tile "edtPat" "")
        (setq #iI 0)
        (mapcar
         '(lambda ( #sPat )
            (if (equal #sPat (strcase #sEpat))
              (set_tile "popPat" (itoa #iI))
            )
            (setq #iI (1+ #iI))
          )
          #Pat$
        )
        (##Pat_Change)
      )
    )
  )
  ;����݂��폜����
  (defun ##Del_Click (
    /
    #sDpat #iOk #sPat #iAuto #A$ #H$ #H_n$ #Txt_n$
    )
    (setq #sDpat (nth (atoi (get_tile "popPat")) #Pat$))
    (setq #iOk
      (CFYesNoDialog
        (strcat "  �u����݁F" #sDpat "�v  ���폜���܂�.\n   ��낵���ł����H")
      )
    )
    (if (= T #iOk)
      (progn
        (setq #Txt$ (SCFSubstList #Txt$ (atoi (get_tile "popPat")) nil))
        (setq #Txt$ (SCFOpSortList #Txt$))
        (setq #Pat$  (mapcar 'car  #Txt$))
        (setq #Auto$ (mapcar 'cadr #Txt$))
        (##SetList "popPat" #Pat$)
        (set_tile "edtPat" "")
        (set_tile "popPat" "0")
        (##Pat_Change)
      )
    )
  )
  ;����ݏڍׂ�\������
  (defun ##Pat_Change (
    /
    #sCpat #sPat #iAuto #iFlg #Lst$ #Disp$
    )
    (setq #sCpat (nth (atoi (get_tile "popPat")) #Pat$))
    ;�g�p��ٕ\���ύX
    (mapcar
     '(lambda ( #sPat #iAuto )
        (if (equal #sPat #sCpat)
          (setq #iFlg #iAuto)
        )
      )
      #Pat$ #Auto$
    )
    ; �p�^�[�����I�����ꂽ���A�L�������ɂ���
    (if (= 0 #iFlg)
      (progn
        (mode_tile "btnEdt"  1)
        (mode_tile "btnDel"  1)
        (mode_tile "btnPat"  1)
        (mode_tile "btnPdel" 1)
      )
      (progn
        (mode_tile "btnEdt"  0)
        (mode_tile "btnDel"  0)
        (mode_tile "btnPat"  0)
        (mode_tile "btnPdel" 0)
      )
    )
    ;�ڍ�ؽĕ\��
    (setq #Lst$ (cdr (cdr (assoc #sCpat #Txt$))))
    (if (/= nil (car #Lst$))
      (progn
        (mapcar
         '(lambda ( #Lst$ )
            ; 2000/07/04 HT DEL ���i�} �{�H�}�I���Ȃ��� START
            ; (setq #V$ nil)
            ; (setq #Kind$ (cdr #Lst$))
            ; (if (member (car (nth 0 &View$)) #Kind$)
            ;   (cond
            ;     ((= "L" (cadr (nth 0 &View$))) (setq #V$ (cons "���i" #V$)))
            ;     ((= "S" (cadr (nth 0 &View$))) (setq #V$ (cons "�{�H" #V$)))
            ;  )
            ; )
            ; (if (member (car (nth 1 &View$)) #Kind$)
            ;  (cond
            ;    ((= "L" (cadr (nth 1 &View$))) (setq #V$ (cons "���i" #V$)))
            ;    ((= "S" (cadr (nth 1 &View$))) (setq #V$ (cons "�{�H" #V$)))
            ;  )
            ;)
            ;(setq #V$ (reverse #V$))
            ;(setq #sView "")
            ;(if (/= nil #V$)
            ;  (progn
            ;    (mapcar '(lambda ( #sV ) (setq #sView (strcat #sView "/" #sV))) #V$)
            ;    (setq #sView (strcat "[" (substr #sView 2) "]"))
            ;  )
            ;)
            ; (setq #Disp$ (cons (strcat (car #Lst$) "\t" #sView) #Disp$))
            (setq #Disp$ (cons (car #Lst$) #Disp$))
            ; 2000/07/04 HT DEL ���i�} �{�H�}�I���Ȃ��� END
          )
          #Lst$
        )
      )
    )
    (##SetList "lstTmp" (reverse #Disp$))
  )
  ;�ڍ�����݂�ݒ肷��
  (defun ##Set_Click (
    /
    #sPat #Lst$
    )
    (setq #sPat (nth (atoi (get_tile "popPat")) #Pat$))
    (setq #Lst$ (assoc #sPat #Txt$))
    (setq #Lst$ (SCFOutPatDlgSub #Lst$ &View$))
    (setq #Txt$ (SCFSubstList #Txt$ (atoi (get_tile "popPat")) #Lst$))
    (setq #Txt$ (SCFOpSortList #Txt$))
    (setq #Pat$  (mapcar 'car  #Txt$))
    (setq #Auto$ (mapcar 'cadr #Txt$))
    (##Pat_Change)
  )
  ;�ڍ�����݂��폜
  (defun ##Pdel_Click (
    /
    #sPat #Lst$ #iTmp
    )
    (setq #sPat (nth (atoi (get_tile "popPat")) #Pat$))
    (setq #Lst$ (assoc #sPat #Txt$))
    (setq #iTmp  (+ 2 (atoi (get_tile "lstTmp"))))
    (setq #Lst$ (SCFSubstList #Lst$ #iTmp nil))
    (setq #Txt$ (SCFSubstList #Txt$ (atoi (get_tile "popPat")) #Lst$))
    (setq #Txt$ (SCFOpSortList #Txt$))
    (setq #Pat$  (mapcar 'car  #Txt$))
    (setq #Auto$ (mapcar 'cadr #Txt$))
    (##Pat_Change)
  )
  (setq #Txt$ &Txt$)
  (setq #Pat$  (mapcar 'car  #Txt$))
  (setq #Auto$ (mapcar 'cadr #Txt$))

  ;�޲�۸ޕ\��
  (setq #iId (GetDlgID "CSFop"))
  (if (not (new_dialog "outpatmain" #iId))(exit))

    (##SetList "popPat" #Pat$)
    (##Pat_Change)
    (action_tile "btnPat"  "(##Set_Click)")
    (action_tile "btnPdel" "(##Pdel_Click)")
    (action_tile "popPat"  "(##Pat_Change)")
    (action_tile "btnNew"  "(##New_Click)")
    (action_tile "btnEdt"  "(##Edt_Click)")
    (action_tile "btnDel"  "(##Del_Click)")
    (action_tile "accept"  "(done_dialog 1)")
    (action_tile "cancel"  "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OK�{�^������
    #Txt$
    nil
  )
) ; SCFOutPatDlgMain


;<HOM>*************************************************************************
; <�֐���>    : SCFOutPatDlgSub
; <�����T�v>  : �o�̓p�^�[���ݒ�_�C�A���OSUB
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-18
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun SCFOutPatDlgSub (
  &Lst$       ; �I�����ꂽ���ڂ̃��X�g
  &View$      ; ���_����ؽ�
  /
  #Tmp$ #Atmp$ #sTmp #Tmp_n$ #View$ #iId ##OK_Click #iRet #Ret$
  #LBlist$  ; ���݃��X�g�{�b�N�X�ŕ\������Ă���f�[�^���X�g		
  )

  ; OK�{�^���������ꂽ���ɌĂ΂��֐�
  (defun ##OK_Click(
    /
    #Lst$
    )
    ; 2000/07/04 HT DEL ���i�} �{�H�}�I���Ȃ��� START
    ;(setq #sL (get_tile "tglRay"))
    ;(setq #sS (get_tile "tglSet"))
    ;(if (= "1" (get_tile "tglRay"))
    ;  (setq #Lst$ (cons (cadr (assoc "L" #View$)) #Lst$))
    ;)
    ;(if (= "1" (get_tile "tglSet"))
    ;  (setq #Lst$ (cons (cadr (assoc "S" #View$)) #Lst$))
    ;)
    ;(if (= nil #Lst$)
    ;  (setq #Lst$ (list ""))
    ;)
    ;(setq #Lst$ (reverse #Lst$))
    ; 2000/07/04 HT DEL ���i�} �{�H�}�I���Ȃ��� END
    ; 2000/07/04 HT ADD ���i�} �{�H�}�I���Ȃ��� 
    (setq #Lst$ (list ""))
    ; �I�����ꂽ�e���v���[�g���擾
    (setq #Lst$ (cons (nth (atoi (get_tile "lstTmp")) #LBlist$) #Lst$))
    (setq #Ret$ (append &Lst$ (list #Lst$)))
    (done_dialog 1)
  )

  ; 2000/07/04 HT ADD �T�C�Y�Ǝړx
  ; ���ׂă`�F�b�N�{�^���������ꂽ���ɌĂ΂��֐�
  (defun ##ALL_Click (
    /
    )
    ; ���ׂă`�F�b�N�{�^��ON OFF�ŁA���W�I�{�^����L�������ɂ���
    (if (= "1" (get_tile "tglALL"))
      (progn
        (mode_tile "rdoA4" 1)
        (mode_tile "rdoA3" 1)
        (mode_tile "rdoA2" 1)
        (mode_tile "rdoB4" 1)
        (mode_tile "rdo20" 1)
        (mode_tile "rdo30" 1)
        (mode_tile "rdo40" 1)
        (mode_tile "rdo01" 1)
	; ���ׂĂ̏�ԂŃ��X�g�{�b�N�X�\��
        (##SetList "lstTmp" #Tmp$)
      )
      (progn
        (mode_tile "rdoA4" 0)
        (mode_tile "rdoA3" 0)
        (mode_tile "rdoA2" 0)
        (mode_tile "rdoB4" 0)
        (mode_tile "rdo20" 0)
        (mode_tile "rdo30" 0)
        (mode_tile "rdo40" 0)
        (mode_tile "rdo01" 0)
	; ���̃��W�I�{�^���̏�ԂŃ��X�g�{�b�N�X�\��
        (##rdo_Click)
      )
    )
  )

  
  ;ؽ��ޯ���ɒl��\������
  (defun ##SetList ( &sKey &List$ / #vAl )
    (setq #LBlist$ &List$)
    (start_list &sKey)
    (foreach #vAl &List$
      (add_list #vAl)
    )
    (end_list)
  )

  ; 2000/07/04 HT ADD �T�C�Y�Ǝړx
  ; �p���T�C�Y�Ǝړx�̃��W�I�{�^���������ꂽ���ɌĂ΂��֐�
  (defun ##rdo_Click (  /  #sSizeScale #Tmp2$)
    ; ALL�̃`�F�b�N��OFF�Ȃ�w�肳�ꂽ�p���T�C�Y�Ǝړx�̂�
    ; ���X�g�{�b�N�X�ɕ\������
    (if (= "0" (get_tile "tglALL"))
      (progn
	      ; �e���v���[�g���ŏ�5�o�C�g�Ŕ���
	      ; ex) A3-01  A3�T�C�Y1�{(����),  A4-40	A4�T�C�Y40�{
	      (setq #sSizeScale (strcat 
	        (substr (get_tile "rdoSize") 4 2)
	        "-"
	        (substr (get_tile "rdoScale") 4 2)
	      ))
	      (setq #Tmp2$ '())
	      (mapcar '(lambda(#sPat)
		        (if (= (substr #sPat 1 5) #sSizeScale)
		          (progn
							  ; �e���v���[�g�S��(���ɐݒ肳��Ă�����̂͏���)  
							  ; �T�C�Y�Ǝړx�̊Y��������̂̂ݎ�荞��  
				  			(setq #Tmp2$ (append #Tmp2$ (list #sPat)))  
				  	  )
		        );_if
        	)
	        #Tmp$
	      );mapcar
	      ; ���X�g�{�b�N�X�ɕ\��
	      (##SetList "lstTmp" #Tmp2$)
      )
    );_if

  );(defun ##rdo_Click

  ;����ڰĖ��l��
  ; ���Ƀp�^�[���ݒ肳��Ă�����͕̂\������Ȃ�(���X�g����Ȃ�)
  ; #Tmp$�Ɂu���ׂāv��ON�̎��̃f�[�^�����߂�
  (setq #Tmp$ (SCFGetDirFile CG_TMPHPATH))
  (setq #Atmp$ (mapcar 'car (cdr (cdr &Lst$))))
  (if (/= nil #Atmp$)
    (progn
      (mapcar
       '(lambda ( #sTmp )
          (if (not (member #sTmp #Atmp$))
            (setq #Tmp_n$ (cons #sTmp #Tmp_n$))
          )
        )
        #Tmp$
      )
      (setq #Tmp$ (reverse #Tmp_n$))
    )
  )

  (if (/= nil #Tmp$)
    (progn
      (setq #View$ (mapcar 'reverse &View$))
      ;�޲�۸ޕ\��
      (setq #iId (GetDlgID "CSFop"))
      (if (not (new_dialog "outpatsub" #iId))(exit))
        ; 2000/07/03 �p���T�C�Y�Ǝړx�t�B���^�[�������� START 
        ; ALL�Ƀ`�F�b�NON�̎��A�p���T�C�Y�Ǝړx�I���ł��Ȃ�
        (set_tile "rdoSize" "rdoA4")
        (set_tile "rdoScale" "rdo40")
        (set_tile "tglALL" "1")
        (##ALL_Click)
        ; 2000/07/03 �p���T�C�Y�Ǝړx�t�B���^�[�������� END
        (set_tile "lstTmp" "0")
        (set_tile "txtPat" (car &Lst$))
        (##SetList "lstTmp" #Tmp$)
        ; 2000/07/04 HT ADD �T�C�Y�Ǝړx START
        (action_tile "tglALL" "(##ALL_Click)")
        (action_tile "rdoSize" "(##rdo_Click)")
        (action_tile "rdoScale" "(##rdo_Click)")
        ; 2000/07/04 HT ADD �T�C�Y�Ǝړx END
        (action_tile "accept" "(##OK_Click)")
        (action_tile "cancel" "(done_dialog 0)")
      (setq #iRet (start_dialog))
      (unload_dialog #iId)
    )
    (CFAlertMsg "����ڰĂ����݂��܂���")
  )

  (if (= 1 #iRet)
    #Ret$
    &Lst$
  )
) ; SCFOutPatDlgSub

;<HOM>*************************************************************************
; <�֐���>    : SCFGetDirFile
; <�����T�v>  : �w���ިڸ�ؓ���̧�ق����ׂĊl������i�g���q�Ȃ��j
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-18
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun SCFGetDirFile (
  &sDir       ; �ިڸ��
  /
  #file_o$
  )
  ; 2000/08/08  HT R14�s�v DEL
  ;(if (= "14" CG_ACAD_VER)
  ;  (progn
  ;    (dos_chdir &sdir)
  ;    (setq #file_o$ (dos_dir "*.dwt"))
  ;  )
  ;  (progn
      (setq #file_o$ (vl-directory-files &sdir "*.dwt" 1))
  ;  )
  ;)

  (mapcar '(lambda ( #fname ) (nth 1 (fnsplitl #fname))) #file_o$)
) ; SCFGetDirFile

;<HOM>*************************************************************************
; <�֐���>    : SCFSubstList
; <�����T�v>  : ���X�g�̎w�荀�ڂ��X�V����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-21
; <���l>      : �����F�v�f��nil���i�[����Ƃ��̍��ڂ͍폜����܂�.
;*************************************************************************>MOH<

(defun SCFSubstList (
  &List$      ; ���̃��X�g
  &iNo        ; �X�V����No
  &Elm        ; �v�f
  /
  #iI #New$
  )
  (setq #iI 0)
  (repeat (length &List$)
    (if (= #iI &iNo)
      (if (/= nil &Elm)
        (setq #New$ (cons &Elm           #New$))
      )
      (setq #New$ (cons (nth #iI &List$) #New$))
    )
    (setq #iI (1+ #iI))
  )
  (reverse #New$)
) ; SCFSubstList

;<HOM>*************************************************************************
; <�֐���>    : SCFOpSortList
; <�����T�v>  : �o�̓p�^�[���ŕύX�\�ȃ��X�g�̂ݿ�Ă���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-21
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun SCFOpSortList (
  &Txt$
  /
  #Pat$ #Auto$ #sPat #iAuto #A$ #H$ #Txt$
  )
  (setq #Pat$  (mapcar 'car  &Txt$))
  (setq #Auto$ (mapcar 'cadr &Txt$))
  (mapcar
   '(lambda ( #sPat #iAuto )
      (if (= 0 #iAuto)
        (setq #A$ (cons #sPat #A$))
        (setq #H$ (cons #sPat #H$))
      )
    )
    #Pat$ #Auto$
  )
  (setq #A$ (reverse #A$))
  (if (/= nil #H$)
    (setq #H$ (acad_strlsort #H$))
  )
  (setq #Pat$ (append #A$ #H$))

  (mapcar
   '(lambda ( #sPat )
      (setq #Txt$ (cons (assoc #sPat &Txt$) #Txt$))
    )
    #Pat$
  )

  (reverse #Txt$)
) ; SCFOpSortList

;<HOM>*************************************************************************
; <�֐���>    : SCFOutPatWriteScv
; <�����T�v>  : �o�̓p�^�[���ݒ�t�@�C��������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-23
; <���l>      : �Ȃ�
;*************************************************************************>MOH<

(defun SCFOutPatWriteScv (
  &sFname     ; ̧�ٖ�
  &Txt$       ; �����ݕ����񃊃X�g
  /
  #fp #Lst$ #Tmp$ #sTr #s
  )
  (setq #fp  (open &sFname "w"))
  (if (/= nil #fp)
    (progn
      (mapcar
       '(lambda ( #Lst$ )
          ;����ݖ��L��
          (princ (strcat "*" (nth 0 #Lst$) "," (itoa (nth 1 #Lst$))) #fp)
          ;����݋L��
          (mapcar
           '(lambda ( #Tmp$ )
              (setq #sTr "")
              (mapcar
               '(lambda ( #s )
                  (setq #sTr (strcat #sTr #s ","))
                )
                #Tmp$
              )
              (setq #sTr (substr #sTr 1 (1- (strlen #sTr))))
              (princ (strcat "\n" #sTr) #fp)
            )
            (cdr (cdr #Lst$))
          )
          (princ "\n" #fp)
        )
        &Txt$
      )
    )
  )
  (close #fp)

  (princ)
) ; SCFOutPatWriteScv
