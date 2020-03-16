;��֘A��w�̒�`
(setq CG_YASHI_LAYER                "N_YASHI")                ;���w
(setq CG_YASHI_AREA_LAYER           "N_YASHI_AREA")           ;��̈��w
(setq CG_YASHI_PERS_LAYER           "N_YASHI_PERS")           ;�p�[�X���w
(setq CG_YASHI_PERS_HIDE_AREA_LAYER "N_YASHI_PERS_HIDE_AREA") ;�p�[�X��̈��w
(setq CG_YASHI_COL        50)                      ;��̐F
(setq CG_YASHI_AREA_COL   60)                      ;��̈�̐F

(setq CG_PERS_HIDE_AREA "N_PERS_HIDE_AREA")  ;�p�[�X��\���̈��w

(setq CG_PERS_VIEW_HD   "TKR_����")             ;�p�[�X�r���[�̓�����

;<HOM>*************************************************************************
; <�֐���>    : C:SCFSetYashi
; <�����T�v>  : ��ݒ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-16
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun C:SCFSetYashi (
  /
  #plinewid #cecolor #entlast #xSp #iI #ed$ #j #No$ #DclRet$ #Rec$
  #eRec #flg #inspt #eNo #Ed$ #en$ #dY #iOrthomode #dA #sAng #eYen #eEn #del$ #en
  )

  (SCFStartShori "SCFSetYashi")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  ; ���݂̃��C�����A�F���L�����Ă���
  (setvar "CLAYER" "0")
  (setq #plinewid (getvar "PLINEWID"))  ; �|�����C���̕�
  (setvar "PLINEWID" 0.0)
  (setq #cecolor (getvar "CECOLOR"))    ; ���ݐF

;-- 2011/09/26 A.Satoh Add - S
  (setq #iOrthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)
;-- 2011/09/26 A.Satoh Add - E

	;�^�ォ����ޭ��ɂ��� 2011/09/26 YM ADD-S
  ;// �r���[��o�^
  (command "_view" "S" "TEMP_SY")
	(command "_.VPOINT" "0,0,1")
	;2011/09/26 YM ADD-E

  ; 01/05/10 TM DEL �s�v
  ;(setq #entlast (entlast))

  (if (/= nil CG_KENMEI_PATH)
    (progn
      (setvar "PICKSTYLE" 3)
      ;���ݑ��݂����}�̈�ԍ����l��
      (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))

      ; ABCD����������邩
      (if (setq #xSp (SCFIsYashiType #xSp "*[ABCD]*"))
        (if (CFYesNoDialog "���ɖ���ݒ肳��Ă��܂�\n�폜���܂���?")
          (progn
            (KCFDeleteYashi (ssname #xSp 0))
          )
          (progn
            (quit)
          )
        )
      )      
      
      ; ������ݒ�_�C�A���O
      (setq #DclRet$ (SCFSetYashiDlg #No$))
      (if (/= nil #DclRet$)
        ; ��ʒu�Ɩ�̈���w�肷��
        (progn
          (setq #eYen (KCFPlaceYashi #DclRet$))
        )
        ;else
        (*error* "��ݒ蒆�~")
      )
    )
    (progn
      (CFAlertMsg "�������Ăяo����Ă��܂���.")
    )
  )

  (setvar "CECOLOR" #cecolor)
  (setvar "PLINEWID" #plinewid)
;-- 2011/09/26 A.Satoh Add - S
  (setvar "ORTHOMODE" #iOrthomode)
;-- 2011/09/26 A.Satoh Add - E

  ;// �r���[��߂� 2011/09/26 YM ADD-S
  (command "_view" "R" "TEMP_SY")
	;2011/09/26 YM ADD-E

  ; �I������ 2000/09/07 HT
  (SCFEndShori)

  (princ "\n�I��")

  ; DEBUG (princ "\n��f�[�^: ")
  ; DEBUG (princ (entget #eYen))
  (princ)
) ; C:SCFYashiSet

;<HOM>*************************************************************************
; <�֐���>    : SCFSetYashiDlgOkClick
; <�����T�v>  : ��ݒ�_�C�A���O
; <�߂�l>    : ��L��ؽ�
;        LIST : �i�̈�ԍ� ��L�� ��}�̈�w��L�����X�g�j
; <�쐬>      : 01/04/27 TM ADD �O�ɏo����
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KCFSetYashiDlgOkClick(
    /
;    #flg ; ��ݒ�`�F�b�N
    )

    (if (not  (or 
                (= "1" (get_tile "tglA"))(= "1" (get_tile "tglB"))
                (= "1" (get_tile "tglC"))(= "1" (get_tile "tglD"))
              )
        )
        (CFAlertMsg "����w�肵�Ă�������.")
        (done_dialog 1)
    )

) ;_ KCFSetYashiDlgOkClick

;<HOM>*************************************************************************
; <�֐���>    : SCFSetYashiDlg
; <�����T�v>  : ��ݒ�_�C�A���O
; <�߂�l>    : ��L��ؽ�
;        LIST : �i�̈�ԍ� ��L�� ��̈�ݒ肷���L���j
; <�쐬>      : 1999-06-16 -> 99/11/25
; <���l>      : 01/04/27 TM MOD ����Ƃɖ�̈��ݒ�\�ɕύX
;*************************************************************************>MOH<
(defun SCFSetYashiDlg (
  &No$        ; ���ɑ��݂����ԍ����X�g
  /
  #sYashi #dYashi #iId #iRet #sNo #iType
  #sYsReg   ; ��̈�ݒ肷��������
#S ;2011/07/16 YM ADD
  )

  ;============================================================================
  ; ��L���̃g�O���ύX���ɌĂяo�����֐�
  (defun ##Chg_Image(
    &sKey     ; (STR)�ύX�����L�� "" 
              ; "" �̏ꍇ�ύX���Ȃ�
    /
    #iI       ; ����ϐ�
    #Yashi$   ; ��������X�g
    #Yashi_n$ ; ����ϐ�
    #YasReg$  ; ��̈惊�X�g
    #s        ; ����ϐ�
    #sFname 
    #fX #fY
    )
    ; 01/04/27 TM ADD-S ��̈�̍Ēǉ�
    ; �e��̗L����؂�ւ����ۂɁA��̈�L���̐ݒ��L���^�����ɂ���
    (cond
      ((= "1" (get_tile (strcat "tgl" &sKey)))
        (mode_tile (strcat "tglReg" &sKey) 0)
      )
      ((= "0" (get_tile (strcat "tgl" &sKey)))
        (mode_tile (strcat "tglReg" &sKey) 1)
      )
    )
    ; 01/04/27 TM ADD-E ��̈�̍Ēǉ�

    ; ������w��̗L�����`�F�b�N
    (setq #Yashi_n$
      (mapcar
       '(lambda ( #s )
          (if (/= "0" (get_tile (strcat "tgl" #s))) #s "")
        )
        '("A" "B" "C" "D")
      )
    )
    (setq #Yashi$ (acad_strlsort #Yashi_n$))
    ; DEBUG (princ "\n�����: ")
    ; DEBUG (princ #Yashi$)

    ; ������ɑΉ������̈�̗L�����`�F�b�N
    (setq #Yashi_n$ 
      (mapcar 
        '(lambda ( #s ) 
          (if (/= "0" (get_tile (strcat "tglReg" #s))) #s "")
        )
        #Yashi$
      )
    )
    (setq #YasReg$ #Yashi_n$)
    ; DEBUG (princ "\n�̈�ݒ�: ")
    ; DEBUG (princ #YasReg$)

    ; ���X�g��A�����ĕ�����ɖ߂�
    (setq #sYsReg (apply 'strcat #YasReg$))   ; ��̈�L��
    (setq #sYashi (apply 'strcat #Yashi$))    ; ��L��

    (if (/= "" #sYashi)
      (setq #sFname #sYashi)
      (setq #sFname "no")
    )

    ; ����f���}�̑傫�����擾
    (setq #fX (dimx_tile "imgYashi"))
    (setq #fY (dimy_tile "imgYashi"))

    ; �V��������f���}�ɍ����ւ���
    (start_image "imgYashi")
    (fill_image  0 0 #fX #fY -0)
    (slide_image 0 0 #fX #fY (strcat CG_SLDPATH #sFname ".sld"))
    (end_image)

  )
  ;============================================================================

  (setq #sYashi "")
  (setq #sYsReg "")

  ;�޲�۸ޕ\��
  (setq #iId (GetDlgID "CSFsy"))
  (if (not (new_dialog "setyashi" #iId))(exit))

    (##Chg_Image "")

    (action_tile "tglA"   "(##Chg_Image \"A\")")
    (action_tile "tglB"   "(##Chg_Image \"B\")")
    (action_tile "tglC"   "(##Chg_Image \"C\")")
    (action_tile "tglD"   "(##Chg_Image \"D\")")
    (action_tile "tglRegA"   "(##Chg_Image \"\")")
    (action_tile "tglRegB"   "(##Chg_Image \"\")")
    (action_tile "tglRegC"   "(##Chg_Image \"\")")
    (action_tile "tglRegD"   "(##Chg_Image \"\")")
    ; 01/04/27 TM MOD �O�ɏo����
    ; (action_tile "accept" "(##OK_Click)")
    (action_tile "accept" "(KCFSetYashiDlgOkClick)")
    (action_tile "cancel" "(done_dialog 0)")

    (setq #iRet (start_dialog))
    (unload_dialog #iId)

    (if (= #iRet 1) ;OK�{�^������
      (progn
        ; 01/04/27 TM MOD ��̈�L���ݒ��ǉ�
        ;(list #sNo #sYashi #iType)
        ; DEBUG (princ "\n��ݒ�: ")
        ; DEBUG (princ #sYashi)
        ; DEBUG (princ "\n��̈�ݒ�: ")
        ; DEBUG (princ #sYsReg)
        (list #sNo #sYashi #sYsReg)
      )
    )
) ; SKSetYashiDlg

;<HOM>*************************************************************************
; <�֐���>    : SCFDrawYashi
; <�����T�v>  : ���}
; <�߂�l>    : �쐬�}�`��ؽ�
; <�쐬>      : 1999-06-17
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCFDrawYashi (
  &sYashi     ; �\���������iA��B -> "AB"�j
  &dY         ; ��z�u���W
  &sAng       ; A�����p�x
  &lay        ; �z�u��w
  /
  #En$ #iI #xSa #sS #sAng #xSp #iJ #eEn #ePt #dPt
#CLAY #LASTEN #SFLG #STRLEN
  )
  ;// ��̉�w���쐬����
	;2012/01/17 YM ADD-S
  (MakeLayer CG_YASHI_LAYER                CG_YASHI_COL      "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_LAYER           CG_YASHI_COL      "CONTINUOUS")
  (MakeLayer CG_YASHI_AREA_LAYER           CG_YASHI_AREA_COL "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")
	;2012/01/17 YM ADD-E

  ; ���݉�w�̕ύX
  (setq #cLay (getvar "CLAYER"))
  (setvar "CLAYER" &lay)

  (setq #xSa (ssadd))
  ;���S�~��}
  (entmake (list (cons 0 "CIRCLE")(cons 10 &dY)(cons 40 40)))
  (ssadd (entlast) #xSa)
  (if (= (substr &sYashi 1 1) "P")
    (setq #strLen 1)
    (setq #strLen (strlen &sYashi))
  )
  ;���}
  (setq #iI 1)
  (repeat #strLen
    ;��l��
    (setq #sS (substr &sYashi #iI 1))
    ;�ǉ��p�x
    (cond
      ((equal "A" (strcase #sS))
        (setq #sAng (angtos (+ 0          (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
      ((equal "B" (strcase #sS))
        (setq #sAng (angtos (+ (* 1.5 PI) (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
      ((equal "C" (strcase #sS))
        (setq #sAng (angtos (+ (* 1.0 PI) (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
      ((equal "D" (strcase #sS))
        (setq #sAng (angtos (+ (* 0.5 PI) (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
      ; ��ǉ� �͖B �̕����Ɠ��l�Ɉ���
      ((member (strcase #sS) CG_ADDYASHI_LIST)
        (setq #sAng (angtos (+ (* 1.5 PI) (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
      ;�p�[�X�
      (T
        (setq #sS &sYashi)
        (setq #sAng (angtos (+ 0          (angtof &sAng)) (getvar "AUNITS") CG_OUTAUPREC))
      )
    )
    ;��}��
    (setq #sflg "")
    (command "_insert" (strcat #sflg CG_BLOCKPATH "YASHI.DWG") "_non" &dY 1 1 #sAng)
    (command "_explode" (entlast))
    ;POINT�}�`�l��
    (setq #xSp (ssget "P"))
    (setq #iJ 0)
    (repeat (sslength #xSp)
      (setq #eEn (ssname #xSp #iJ))
      (if (equal "POINT" (cdr (assoc 0 (entget #eEn))))
        (setq #ePt #eEn)
        (ssadd #eEn #xSa)
      )
      (setq #iJ (1+ #iJ))
    )
    (setq #dPt (cdr (assoc 10 (entget #ePt))))
    (entdel #ePt)

    ;���ʍ�}
    (setq #lastEn (MakeText #sS #dPt 100 1 2 "STANDARD"))

    (ssadd #lastEn #xSa)
    (setq #iI (1+ #iI))
  )
  ;�ău���b�N��
  (SKUblock &dY #xSa)

  ;���݉�w�����ɖ߂�
  (setvar "CLAYER" #cLay)
  (entlast)
) ; SCFDrawYashi

;;;<HOM>*************************************************************************
;;; <�֐���>    : KCFDeleteYashi
;;; <�����T�v>  : ��폜
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/05/01 TM 
;;; <���l>      : ��ɂ��Ă���̈�}�`���폜����i�͂��j
;;;*************************************************************************>MOH<
(defun KCFDeleteYashi (
  &eEn    ; ��}�`�̐}�`��
  /
  #eXd$   ; ��}�`�̊g���f�[�^
  #nII    ; ����ϐ�
  #eYas$  ; ��̈�̃G���e�B�e�B���X�g
  #eYas   ; ����ϐ�
  )

  (setq #eXd$ (CFGetXData &eEn "RECT"))
  (if (= #eXd$ nil)
    (setq #eXd$ (CFGetXData &eEn "RECTPERS"))
  )
  ; �g���f�[�^����ł͂Ȃ��ꍇ
  ; DEBUG (princ "\n#eXd$: ")
  ; DEBUG (princ #eXd$)
  (if (not #eXd$)
    (progn
      (CFAlertMsg "��}�`�ł͂���܂���B")
    )
    (progn
      ; �g���f�[�^��4�Ԗڈȍ~���̈�}�`�n���h��
      (setq #nII 4)
      (while (<= #nII (length #eXd$))
        (if (and (nth (1- #nII) #eXd$) (/= "" (nth (1- #nII) #eXd$)))
          (progn
            ; �̈�}�`�̃O���[�v(���̂�"Yashi[ABCDEF}")�Ɋ܂܂��}�`���������Ă��ׂč폜
            (setq #eYas$ (CFGetGroupEnt (handent (nth (1- #nII) #eXd$))))
            (foreach #eYas #eYas$
              (command "_.ERASE" #eYas "")
            )
          )
        )
        (setq #nII (1+ #nII))
      )
      (command "_.ERASE" &eEn "")
    )
  )

  (princ)

)

;;;<HOM>************************************************************************
;;; <�֐���>  : KCFPlaceYashi
;;; <�����T�v>: ��ʒu�ݒ�
;;; <�߂�l>  : �ݒ肵����}�`��
;;; <�쐬>    : 2001-05-01 TM
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun KCFPlaceYashi (
  &DclRet$    ; (�̈�ԍ� �ݒ肷��������̘A�� �ݒ肷���̈敶����̘A��)
  /
  #sCECOLOR     ; �ύX�O�̐}�`�̐F�ԍ�
;-- 2011/09/26 A.Satoh Del - S
;;;;;  #iOrthomode   ; �ύX�O�̒������[�h
;-- 2011/09/26 A.Satoh Del - S
  #dY           ; ��L����_
  #dA           ; ��L���p�x
  #sAng         ; ��L���p�x
  #eYen         ; ��}�`��
  #eXd$         ; ��g���f�[�^
  #hArea$       ; ��̈�}�`�O���[�v��
  #nII          ; ����ϐ�
  #sAorE        ; ��ƂȂ�����
  #sYas         ; �������
  #sYasDir$     ; ������w�蕶����
  )

;;;  ; �}�`�F�ԍ��̕ύX
;;;  (setq #sCECOLOR (getvar "CECOLOR"))
;;;  (setvar "CECOLOR" "60")

  ; �s�b�N�`���̕ύX�H
  (setvar "PICKSTYLE" 3)

  ; �f�[�^���Ȃ��ꍇ�͎��s���Ȃ�
  (if (= nil &DclRet$)
    (progn
      (princ "\n��f�[�^�Ȃ�")
      (quit)
    )
  ) 
  (cond
    ; �ʏ�̖
    ((wcmatch (nth 1 &DclRet$) "*[ABCD]*")
      (setq #sAorE "A")
    )
    ; ���̑��̖
    (t (setq #sAorE (nth 1 &DclRet$)))
  )
; 01/05/25 TM MOD �F�ǉ�

;;; ;���ݐF�ύX
;;; (setvar "CECOLOR" "50")  ; �W�J�}

  ;��ݒ�
  (setq #dY (getpoint "\n��L����}�ʒu���w�肵�Ă�������: "))
  (if (/= nil #dY)
    (progn
;-- 2011/09/26 A.Satoh Del - S
;;;;;      (setq #iOrthomode (getvar "ORTHOMODE"))
;;;;;      (setvar "ORTHOMODE" 1)
;-- 2011/09/26 A.Satoh Del - E
      (setq #dA (getangle #dY (strcat "\n" #sAorE "�������w�肵�Ă�������: ")))
;-- 2011/09/26 A.Satoh Del - S
;;;;;      (setvar "ORTHOMODE" #iOrthomode)
;-- 2011/09/26 A.Satoh Del - E
      (if (/= nil #dA)
        (progn
    
          ;���}
          (if (/= #sAorE "A")
            (progn
              ; E/F������B�����ɍ�}�p�x��ǂݑւ���
              (setq #dA (+ #dA (/ pi 2.0)))
            )
          )
          ; �z�u�����ۂ̌����ƍ���Ȃ� ZAN 01/05/25 TM NOTE
          (setq #sAng (angtos #dA (getvar "AUNITS") CG_OUTAUPREC))
          (setq #eXd$ (list "0" #sAng (nth 1 &DclRet$)))
          (setq #eYen (SCFDrawYashi (nth 1 &DclRet$) #dY #sAng CG_YASHI_LAYER))

          ; ��̈�w��̂����̂ݗ̈�w����s��
          (if (nth 2 &DclRet$) ; ��̈�w��(�R�Ԗ�)
            (progn
              ; ����������񁨕����̔z��ɕϊ�
              (setq #nII 1)
              (setq #sYasDir$ '())
              (repeat (strlen (nth 1 &DclRet$)) ; ������w��̐�
                (setq #sYasDir$ (cons (substr (nth 1 &DclRet$) #nII 1) #sYasDir$))
                (setq #nII (1+ #nII))
              )
              (setq #sYasDir$ (reverse #sYasDir$))
                      
              ; �����������Ɠ��������Ŗ�̈�}�`�n���h����z�u����
              (setq #nII 1)
              (setq #hArea '())
              (foreach #sYas #sYasDir$
                (if (= #sYas (substr (nth 2 &DclRet$) #nII 1))
                  (progn
                    (princ "\n")
                    (princ (substr (nth 2 &DclRet$) #nII 1))
                    (princ " �����̖�̈���w�肵�Ă��������B")
                    (setq #hArea$ (cons (KCFSetYashiReg (substr (nth 2 &DclRet$) #nII 1)) #hArea$))
                    (setq #nII (1+ #nII))
                  )
                  (progn
                    (setq #hArea$ (cons "" #hArea$))
                  )
                )
              );_foreach #sYas #sYasDir$
              (setq #hArea$ (reverse #hArea$))
            )
          );_if (nth 2 &DclRet$)

          ; ��̈�O���[�v��������ꍇ�A�g�������ɒǉ�
          (if #hArea$
            (progn
              (setq #eXd$ (append #eXd$ #hArea$))
            )
          )

          ; �g���������}�`�ɑg�ݍ���
          (if (not (tblsearch "APPID" "RECT")) (regapp "RECT"))
          (CFSetXData #eYen "RECT" #eXd$)
        )
        (progn
          (*error* "��̈�ʒu�w��L�����Z��")
        )
      );_if (/= nil #dA)
    )
    (*error* "��L���ʒu�w��L�����Z��")
  );_if (/= nil #dY)

;;;  ; �V�X�e���ϐ������ɖ߂�
;;;  (setvar "CECOLOR" #sCECOLOR)

  #eYen

) ;_ KCFPlaceYashi


;;;<HOM>************************************************************************
;;; <�֐���>  : KCFPlaceYashiPers
;;; <�����T�v>: �p�[�X��ʒu�ݒ�
;;; <�߂�l>  : �ݒ肵����}�`��
;;; <�쐬>    : 2005-02-06 SK
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun KCFPlaceYashiPers (
  &DclRet$    ; (�̈�ԍ� �ݒ肷��������̘A�� �ݒ肷���̈敶����̘A��)
  /
  #iOrthomode    ; �ύX�O�̒������[�h
  #dY            ; ��L����_
  #dA            ; ��L���p�x
  #sAng          ; ��L���p�x
  #eYen          ; ��}�`��
  #eXd$          ; ��g���f�[�^
  #hArea$        ; ��̈�}�`�O���[�v��
  #nII          ; ����ϐ�
  #sAorE        ; ��ƂȂ�����
  #sYas          ; �������
  #sYasDir$      ; ������w�蕶����
  )

  ; �s�b�N�`���̕ύX�H
  (setvar "PICKSTYLE" 3)

  ; �f�[�^���Ȃ��ꍇ�͎��s���Ȃ�
  (if (= nil &DclRet$)
    (progn
      (princ "\n��f�[�^�Ȃ�")
      (quit)
    )
  )
  (setq #sAorE (nth 1 &DclRet$))

  ;���ݐF�ύX
  ;(setvar "CECOLOR" "50")  ; �W�J�}

  ;��ݒ�
  (setq #dY (getpoint "\n��L����}�ʒu���w�肵�Ă�������: "))
  (if (/= nil #dY)
    (progn
      (setq #iOrthomode (getvar "ORTHOMODE"))
      (setvar "ORTHOMODE" 0)
      (setq #dA (getangle #dY (strcat "\n" #sAorE "�������w�肵�Ă�������: ")))
      (setvar "ORTHOMODE" #iOrthomode)
      (if (/= nil #dA)
        (progn

          ; �z�u�����ۂ̌����ƍ���Ȃ� ZAN 01/05/25 TM NOTE
          (setq #sAng (angtos #dA (getvar "AUNITS") CG_OUTAUPREC))

          (setq #eXd$ (list "0" #sAng (nth 1 &DclRet$)))
          (setq #eYen (SCFDrawYashi (nth 1 &DclRet$) #dY #sAng CG_YASHI_PERS_LAYER))

          ; ��̈�w��̂����̂ݗ̈�w����s��
          (if (nth 2 &DclRet$) ; ��̈�w��(�R�Ԗ�)
            (progn
              (princ "\n")
              ;(princ (nth 2 &DclRet$))
              ;(princ " �����̖�̈���w�肵�Ă��������B")
              (princ "\n�p�[�X�̗̈�O���w�肵�Ă�������: ")
              (setq #hArea$ (cons (KCFSetYashiReg (nth 2 &DclRet$)) #hArea$))
              (setq #hArea$ (reverse #hArea$))
            )
          );_if (nth 2 &DclRet$)

          ; ��̈�O���[�v��������ꍇ�A�g�������ɒǉ�
          (if #hArea$
            (progn
              (setq #eXd$ (append #eXd$ #hArea$))
            )
          )

          ; �g���������}�`�ɑg�ݍ���
          (if (not (tblsearch "APPID" "RECTPERS")) (regapp "RECTPERS"))
          (CFSetXData #eYen "RECTPERS" #eXd$)
        )
        (progn
          (*error* "��̈�ʒu�w��L�����Z��")
        )
      );_if (/= nil #dA)
    )
    (*error* "��L���ʒu�w��L�����Z��")
  );_if (/= nil #dY)
  #eYen

) ;_ KCFPlaceYashiPers

;;;<HOM>************************************************************************
;;; <�֐���>  : KCFSetYashiReg
;;; <�����T�v>: ��̈�ݒ�
;;; <�߂�l>  : �ݒ肵���̈�}�`�̃n���h��
;;; <�쐬>    : 2001-05-01 TM
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun KCFSetYashiReg (
  &sYas    ; �̈�ݒ肷�� "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"�@:�W�J�}�
           ;                  "P1" "P2" "P3" : �p�[�X�
  /
  #xSp          ; ��}�`
  #sType        ; �̈�^�C�v
  #iType        ; �̈�^�C�v
  #inspt        ; ����\����_
  #Rec$          ; ��̈�_��
  #eRec          ; ��̈�}�`��
  #eNam          ; ��̈於�̐}�`��
  #sArea        ; ��̈�}�`�O���[�v��
  #hArea        ; ��̈�}�`�n���h��
  #Ed$          ; ��g���f�[�^
  #sYasGrpNam    ; ��̈�O���[�v��
  #cLay         ; ���݉�w
  #areaLay
  )
  ; ���݉�w�̕ύX
  (setq #cLay (getvar "CLAYER"))
  ; �s�b�N�`���̕ύX�H
  (setvar "PICKSTYLE" 3)

  ;// ��̉�w���쐬����
  (cond
    ((= (substr &sYas 1 1) "P")
      (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")
      (setq #areaLay CG_YASHI_PERS_HIDE_AREA_LAYER)

      ; �Ώۗ̈�}�`�̎�ނ�I��
;-- 2011/09/22 A.Satoh Mod - S
;;;;;      (initget "1 2 3")
;;;;;      (setq #sType (getkword "\n��`(1)/�̈�(2)/�̈�Ȃ�(3)/<1>: "))
;;;;;      (if (= nil #sType)
;;;;;        (setq #sType "1")
;;;;;      )
      (setq #sType "1")
;-- 2011/09/22 A.Satoh Mod - E
      (setq #iType (atoi #sType))
    )
    (T
      (MakeLayer CG_YASHI_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")
      (setq #areaLay CG_YASHI_AREA_LAYER)

      ; �Ώۗ̈�}�`�̎�ނ�I��
;-- 2011/09/22 A.Satoh Mod - S
;;;;;      (initget "1 2")
;;;;;      (setq #sType (getkword "\n��`(1)/�̈�(2)<1>: "))
;;;;;      (if (= nil #sType)
;;;;;        (setq #sType "1")
;;;;;      )
      (setq #sType "1")
;-- 2011/09/22 A.Satoh Mod - E
      (setq #iType (atoi #sType))
    )
  )
  (setvar "CLAYER" #areaLay)

  ; ��̈�̍쐬
  (if (/= 3 #iType)
    (progn
      ; �̈�I���E��}
      (setq #Rec$ (CFDrawRectOrRegionTransUcs #iType))
      (setq #eRec (entlast))

      ; �̈�ԍ���}
      ;@DEL@(setq #inspt (list (car (car #Rec$)) (cadr (car #Rec$)) 0.0))
      ;@DEL@(MakeText "E" #inspt 100 2 3 "STANDARD")

      ; �����}

      (setq #inspt (list (- (car (car #Rec$)) 25) (- (cadr (car #Rec$)) 25) 0.0))
      (setq #eNam (MakeText &sYas #inspt 100 2 3 "STANDARD"))
      (command "_.CHANGE" #eNam "" "P" "LA" #areaLay "")
      ; �̈�Ɩ��̂��O���[�v������
      (setq #sArea (strcat "Yashi" &sYas))
      (command "-group" "C" #sArea #sArea #eRec #eNam "")

      ; �̈�}�`�̃n���h�����擾
      (setq #hArea (cdr (assoc 5 (entget #eRec))))
    )
    (setq #hArea "")
  )

  ; �V�X�e���ϐ������ɖ߂�
  (setvar "CLAYER" #cLay)

  #hArea
) ;_ KCFSetYashiReg

;;;<HOM>*************************************************************************
;;; <�֐���>    : KCFAutoMakeSKViewYashi
;;; <�����T�v>  : ��̎�����}�i�p�[�X�ȊO�j
;;; <�߂�l>    :
;;;           T : ����ɖ����}����
;;;         nil : �����}���Ă��Ȃ�
;;; <�쐬>      : 2004-09-29 SK
;;; <���l>      : Input.cfg �� SK_VIEW�Z�N�V���������ɖ��������}����
;*************************************************************************>MOH<
(defun KCFAutoMakeSKViewYashi (
  &NormYashi &cArea ;;  2005/12/07 G.YK ADD
  /
  #view$$ #view$
  #rstr
  #itm$
  #abcdItm$
  #pt$$
  #abcdPt$$
  #ang
  #dum$ #dum
  #tArea #AreaList  ;;  2005/11/30 G.YK ADD
  )
  (WebOutLog "Input.cfg �̏������Ɏ����Ŗ���쐬���܂�")

  (if (= CG_SKViewList nil)
    (WebOutLog "Input.cfg ��SK_VIEW �Z�N�V����������܂���")
  ;else
    (progn
      ;// �Ȃ���Ζ�̉�w���쐬����
      (MakeLayer CG_YASHI_LAYER       CG_YASHI_COL "CONTINUOUS")
      (MakeLayer CG_YASHI_PERS_LAYER  CG_YASHI_COL "CONTINUOUS")

      ;// �Ȃ���Ζ�̈�̉�w���쐬����
      (MakeLayer CG_YASHI_AREA_LAYER           CG_YASHI_AREA_COL "CONTINUOUS")
      (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")

      (if (= (tblsearch "APPID" "RECT")     nil) (regapp "RECT"))
      (if (= (tblsearch "APPID" "RECTPERS") nil) (regapp "RECTPERS"))

;      (setq #pt (list 1250 -2000))
      (setq #rstr "")
      (foreach #dum$ CG_SKViewList
        (setq #itm$ nil)
        (foreach #dum #dum$
          (if (= #dum nil)
            (setq #itm$ (append #itm$ (list "")))
            (setq #itm$ (append #itm$ (list #dum)))
          )
        )
        (cond
          ;ABCD��̏ꍇ
          ((member (car #itm$) (list "A" "B" "C" "D"))
            (setq #abcdItm$ (append #abcdItm$ (list (car #itm$))))
          ;;  2005/11/30 G.YK ADD-S
            (setq #tArea (list
                  (list (atof (nth 1 #itm$)) (atof (nth 2 #itm$)))
                  (list (atof (nth 3 #itm$)) (atof (nth 4 #itm$)))
            ))
            (setq #AreaList (&NormYashi &cArea #tArea))
            (setq &cArea (car #AreaList))
            (setq #tArea (cadr #AreaList))
            (setq #abcdPt$$ (append #abcdPt$$ (list #tArea)))
          ;;  2005/11/30 G.YK ADD-E
          ;|  2005/11/30 G.YK DEL-S
            (setq #abcdPt$$ (append #abcdPt$$
                        (list (list
                          (list (atof (nth 1 #itm$)) (atof (nth 2 #itm$)))
                          (list (atof (nth 3 #itm$)) (atof (nth 4 #itm$)))
                        )))
            )
              2005/11/30 G.YK DEL-E |;
          )
          ;�p�[�X��̏ꍇ�i�Ȃɂ����Ȃ��j
          ((= "P" (substr (car #itm$) 1 1))
            (princ)
          )
          ;��ǉ��̏ꍇ
          (T
          ;;  2005/12/07 G.YK ADD-S
            (setq #tArea (list
                  (list (atof (nth 1 #itm$)) (atof (nth 2 #itm$)))
                  (list (atof (nth 3 #itm$)) (atof (nth 4 #itm$)))
            ))
            (setq #AreaList (&NormYashi &cArea #tArea))
            (setq &cArea (car #AreaList))
            (setq #tArea (cadr #AreaList))
            (setq #pt$$ (list #tArea))
          ;;  2005/12/07 G.YK ADD-E
          ;|  2005/12/07 G.YK DEL-S
            (setq #pt$$ (list (list
                          (list (atof (nth 1 #itm$)) (atof (nth 2 #itm$)))
                          (list (atof (nth 3 #itm$)) (atof (nth 4 #itm$)))
                        ))
            )
              2005/12/07 G.YK DEL-E |;
            (cond
              ((= (nth 5 #itm$) "A") (setq #ang "180"))
              ((= (nth 5 #itm$) "B") (setq #ang "270"))
              ((= (nth 5 #itm$) "C") (setq #ang "0"))
              ((= (nth 5 #itm$) "D") (setq #ang "90"))
            )
            (WebOutLog "��ǉ��̍�}")
            ;��ǉ��Ɨ̈�̍�}
            (KCFMakeKSKViewYashi "RECT" (list (car #itm$)) (nth 5 #itm$) #pt$$ #ang)
          )
        )
      )
      ;ABCD��Ɨ̈�̍�}
      (WebOutLog "ABCD��̍�}")

      (KCFMakeKSKViewYashi "RECT" #abcdItm$ (car #abcdItm$) #abcdPt$$ "90")
    )
  )
;|  2005/12/07 G.YK DEL-S
  (if CG_SKViewList
    T
  ;else
    nil
  )
  2005/12/07 G.YK DEL-S |;
  &cArea  ;;  2005/12/07 G.YK ADD
)
;KCFAutoMakeSKViewYashi

;;;<HOM>*************************************************************************
;;; <�֐���>    : KCFAutoMakeSKViewYashiPers
;;; <�����T�v>  : �p�[�X��̎�����}
;;; <�߂�l>    :
;;;           T : ����ɖ����}����
;;;         nil : �����}���Ă��Ȃ�
;;; <�쐬>      : 2004-09-29 SK
;;; <���l>      : Input.cfg �� SK_VIEW�Z�N�V���������ɖ��������}����
;*************************************************************************>MOH<
(defun KCFAutoMakeSKViewYashiPers (
  &NormYashi &cArea ;;  2005/12/07 G.YK ADD
  /
  #rstr
  #itm$
  #pt$$
  #ang
  #dum$ #dum
  #tArea #AreaList  ;;  2005/12/07 G.YK ADD
  )
  (WebOutLog "Input.cfg �̏������Ɏ����Ŗ���쐬���܂�")

  (if (= CG_SKViewList nil)
    (WebOutLog "Input.cfg ��SK_VIEW �Z�N�V����������܂���")
  ;else
    (progn
      ;// �Ȃ���Ζ�̉�w���쐬����
      (MakeLayer CG_YASHI_LAYER       CG_YASHI_COL "CONTINUOUS")
      (MakeLayer CG_YASHI_PERS_LAYER  CG_YASHI_COL "CONTINUOUS")

      ;// �Ȃ���Ζ�̈�̉�w���쐬����
      (MakeLayer CG_YASHI_AREA_LAYER           CG_YASHI_AREA_COL "CONTINUOUS")
      (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")


      (if (= (tblsearch "APPID" "RECT")     nil) (regapp "RECT"))
      (if (= (tblsearch "APPID" "RECTPERS") nil) (regapp "RECTPERS"))

      (setq #rstr "")
      (foreach #dum$ CG_SKViewList
        (setq #itm$ nil)
        (foreach #dum #dum$
          (if (= #dum nil)
            (setq #itm$ (append #itm$ (list "")))
            (setq #itm$ (append #itm$ (list #dum)))
          )
        )
        (cond
          ;�p�[�X��̏ꍇ
          ((= "P" (substr (car #itm$) 1 1))
          ;;  2005/12/07 G.YK ADD-S
            (if (and (/= (nth 6 #itm$) "")(/= (nth 7 #itm$) "")
                     (/= (nth 8 #itm$) "")(/= (nth 9 #itm$) ""))(progn
              (setq #tArea (list
                    (list (atof (nth 6 #itm$)) (atof (nth 7 #itm$)))
                    (list (atof (nth 8 #itm$)) (atof (nth 9 #itm$)))
              ))
              (setq #AreaList (&NormYashi &cArea #tArea))
              (setq &cArea (car #AreaList))
              (setq #tArea (cadr #AreaList))
              (setq #pt$$ (list #tArea))
            )(progn
              (setq #pt$$ (list (list
                            (list (atof (nth 6 #itm$)) (atof (nth 7 #itm$)))
                            (list (atof (nth 8 #itm$)) (atof (nth 9 #itm$)))
                          ))
              )
            ))
          ;;  2005/12/07 G.YK ADD-E
          ;|  2005/12/07 G.YK DEL-S
            (setq #pt$$ (list (list
                          (list (atof (nth 6 #itm$)) (atof (nth 7 #itm$)))
                          (list (atof (nth 8 #itm$)) (atof (nth 9 #itm$)))
                        ))
            )
              2005/12/07 G.YK DEL-E |;
            (WebOutLog "�p�[�X��̍�}")
            ;��ǉ��Ɨ̈�̍�}
            (KCFMakeKSKViewYashi "RECTPERS" (list (car #itm$)) "" #pt$$ (nth 10 #itm$))
          )
        )
      )
    )
  )
;|  2005/12/07 G.YK DEL-S
  (if CG_SKViewList
    T
  ;else
    nil
  )
  2005/12/07 G.YK DEL-E |;
  &cArea  ;;  2005/12/07 G.YK ADD
)
;KCFAutoMakeSKViewYashi

;;;<HOM>*************************************************************************
;;; <�֐���>    : KCFMakeKSKViewYashi
;;; <�����T�v>  : ��̎�����}
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2004-09-29 SK
;;; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KCFMakeKSKViewYashi (
  &appName    ;(STR) �ݒ�A�v���P�[�V������
  &yashiMrk$  ;(STR) ��L�����X�g
  &baseMrk    ;(STR) ���L��
  &ptLst$      ;(LIST)��ɑ΂���̈�̂Q�_���W���X�g
  &ang        ;(STR) ��̊p�x
  /
  #mrk
  #mrkStr
  #cLay
  #area
  #areaEn$
  #inspt
  #eNam
  #sArea
  #xd$
  #en
  #yashiEn
  #p1 #p2 #p3 #p4
  #pt #pt$
#CUT_BD #B_LIS$ #D_LIS$ #D_X_L #D_X_R ;2010/10/23 YM ADD
  )
  ;��L���̉�w�Ɩ�̈�̉�w�����肷��
  (cond
    ((= &appName "RECT")
      (setq #mrkLay  CG_YASHI_LAYER)
      (setq #areaLay CG_YASHI_AREA_LAYER)
    )
    ((= &appName "RECTPERS")
      (setq #mrkLay  CG_YASHI_PERS_LAYER)
      (setq #areaLay CG_YASHI_PERS_HIDE_AREA_LAYER)
    )
  )

  ;���݉�w��ۑ�
  (setq #cLay (getvar "CLAYER"))

  (setq #mrkStr "")
  ;��L����A������������ɂ���
  (foreach #mrk &yashiMrk$
    (setq #mrkStr (strcat #mrkStr #mrk))
  )
  ;�_�����������E���Ƃ���
  (setq #area (car &ptLst$))
  (setq #pt$ #area)
  (setq #pt$ (append #pt$ (list (list (car (car #area)) (cadr (cadr #area))))))
  (setq #pt$ (append #pt$ (list (list (car (cadr #area)) (cadr (car #area))))))
  (setq #p1 (list (apply 'min (mapcar 'car #pt$)) (apply 'min (mapcar 'cadr #pt$))))
  (setq #p2 (list (apply 'max (mapcar 'car #pt$)) (apply 'min (mapcar 'cadr #pt$))))
  (setq #p3 (list (apply 'max (mapcar 'car #pt$)) (apply 'max (mapcar 'cadr #pt$))))
  (setq #p4 (list (apply 'min (mapcar 'car #pt$)) (apply 'max (mapcar 'cadr #pt$))))

  ;��̔z�u�ʒu�����߂�
  (cond
    ((= &baseMrk "A")
      (setq #pt (polar #p1 (angle #p1 #p2) (/ (distance #p1 #p2) 2.)))
    )
    ((= &baseMrk "B")
      (setq #pt (polar #p2 (angle #p2 #p3) (/ (distance #p2 #p3) 2.)))
    )
    ((= &baseMrk "C")
      (setq #pt (polar #p3 (angle #p3 #p4) (/ (distance #p3 #p4) 2.)))
    )
    ((= &baseMrk "D")
      (setq #pt (polar #p4 (angle #p4 #p1) (/ (distance #p4 #p1) 2.)))
    )
    ;�p�[�X�̎�
    (T
      (setq #pt (list 0 0))
    )
  )
  ;--------------------------------------------
  ;��L���̍�}
  ;--------------------------------------------
  (SCFDrawYashi #mrkStr #pt &ang #mrkLay)
  (setq #yashiEn (entlast))

  ;���݉�w���̈��w�Ƃ���
  (setvar "CLAYER" #areaLay)

  ;2010/10/23 YM ADD-S �ySK_2010/11���z��@�\���P�@���ӂ̂�
  (if (and (= CG_KITCHEN_SKIP "SK__Y")(= &baseMrk "A")(= (car &yashiMrk$) "A"))
    (progn
      ;D�̈��X���W����������ƿ�Ă���
      (setq #D_lis$ (CFListSort (nth 2 &ptLst$) 0))

      ;D�̈�
      (setq #D_lis$
        (list
          (nth 0 #D_lis$);����
          (list CG_SYUHEN_NOMI_D_CUT_X (nth 1 (nth 1 #D_lis$)));�E���́A���[+900mm
        )
      )

      ;B�̈��X���W����������ƿ�Ă���
      (setq #B_lis$ (CFListSort (nth 1 &ptLst$) 0))

      ;B�̈�
      (setq #B_lis$
        (list
          (list CG_SYUHEN_NOMI_B_CUT_X (nth 1 (nth 0 #B_lis$))) ;����
          (nth 1 #B_lis$);�E��
        )
      )

      (setq &ptLst$
        (list
          (nth 0 &ptLst$);A
          #B_lis$        ;B
          #D_lis$        ;D
          (nth 3 &ptLst$);C
        )
      )
    )
  );_if
  ;2010/10/23 YM ADD-E �ySK_2010/11���z��@�\���P�@���ӂ̂�

  ;--------------------------------------------
  ;��̈����}
  ;--------------------------------------------
  (mapcar
    '(lambda ( #mrk #area )
;      (if (= nil (equal (car #area) (cadr #area)))
;        (progn
          (command "_.RECTANGLE" (car #area) (cadr #area))
          (setq #areaEn$ (append #areaEn$ (list (entlast))))

          ;���������}����
          (setq #inspt (list (- (car (car #area)) 25) (- (cadr (car #area)) 25) 0.0))
          (setq #eNam (MakeText #mrk #inspt 100 2 3 "STANDARD"))
          (command "_.CHANGE" (entlast) "" "P" "LA" #areaLay "")

          ; �̈�Ɩ��̂��O���[�v������
          (setq #sArea (strcat "Yashi" #mrk))
          (command "-group" "C" #sArea #sArea (last #areaEn$) #eNam "")
;        )
;      )
    )
    &yashiMrk$
    &ptLst$
  )
  ;--------------------------------------------
  ;��L���}�`�Ɋg���f�[�^��t������
  ;--------------------------------------------
  (setq #xd$ (list "0" &ang #mrkStr))
  (foreach #en #areaEn$
    (setq #xd$ (append #xd$ (list (cdr (assoc 5 (entget #en))))))
  )
  (CFSetXData #yashiEn &appName #xd$)

  ;��w�����ɖ߂�
  (setvar "CLAYER" #cLay)
)
;KCFMakeKSKViewYashi

;;;<HOM>*************************************************************************
;;; <�֐���>    : KCFDeletePersYashi
;;; <�����T�v>  : �p�[�X��Ɨ̈���폜����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2004-09-29 SK
;;; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KCFDeletePersYashi (
  )
  (setq #ss$
    (list
      (ssget "X" (list (cons 8 CG_YASHI_PERS_LAYER)))
      (ssget "X" (list (cons 8 CG_YASHI_PERS_HIDE_AREA_LAYER)))
    )
  )
  (foreach #ss #ss$
    (command "_.ERASE" #ss "")
  )
)
;KCFDeletePersYashi

;;;<HOM>*************************************************************************
;;; <�֐���>    : KCFMakeModelPersView
;;; <�����T�v>  : �p�[�X�r���[��Ƃ��쐬����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2004-11-24 SK
;;; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun KCFMakeModelPersView (
  /
  #dum$ #dum
  #pName
  #itm$ #itm
  #p1 #p2
  #ang
  )
  (WebOutLog "�p�[�X��r���[�̍쐬")

  (foreach #itm$ CG_SKViewList
    (cond
      ;�p�[�X��̏ꍇ
      ((= "P" (substr (car #itm$) 1 1))
        ;�p�[�X�r���[�̖��O
        (setq #pName (strcat CG_PERS_VIEW_HD (nth 0 #itm$)))
        (if (= (nth 10 #itm$) nil)
          (setq #ang 60.)
          (setq #ang (nth 10 #itm$))
        )
        ;�p�x�̐ݒ�
        (setq #p1 (list 0 0 0))
        (setq #p2 (polar #p1 (dtr (atoi #ang)) 100))
        (setq #p2 (list (car #p2) (cadr #p2) -50))
        (command "_.VPOINT" "0,0,1")

        (command "_.ZOOM" "E")
        (command "_.ZOOM" "0.1X")
        (command "_.DVIEW" "ALL" "" "PO" #p2 #p1 "X")
        (command "_.ZOOM" "E")

        ;�r���[�̍쐬
        (command "_.VIEW" "S" #pName)
      )
    )
  )
  (command "_.VPOINT" "0,0,1")
)
;KCFMakeModelPersView