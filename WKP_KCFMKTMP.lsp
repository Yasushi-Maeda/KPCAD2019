;;;<HOF>************************************************************************
;;; <�t�@�C����>: KCFmktmp.LSP
;;; <�V�X�e����>: KitchenPlan�V�X�e��
;;; <�ŏI�X�V��>: 01/04/08 �������L
;;; <���l>      : �Ȃ�
;;;************************************************************************>FOH<
;@@@(princ "\nSCFmktmp.fas ��۰�ޒ�...\n")

;<HOM>*************************************************************************
; <�֐���>    : C:SCFMkTplRead
; <�����T�v>  : հ������ڰĂ̍쐬 -> ����ڰēǍ���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-28
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun C:SCFMkTplRead (
  /
  #sFname #iOk
  )

  (SCFStartShori "SCFMkTplRead")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  (setq #iOk (CFYesNoDialog "�}�ʂ���x�ۑ����܂����H"))
  (setq #sFname (getfiled "����ڰēǍ���" CG_TMPHPATH "dwt" 6))
  (if (/= nil #sFname)
    (progn
      (if (= T #iOk)
        (progn
          ; 01/03/02 HN S-MOD �̈�g�̔�\��������ǉ�
          ; �e���v���[�g�}�ʂ̏ꍇ�A�̈�g���\���Ƃ���
          (if (JudgeModeMkTpl)
            (progn
              (command "_.layer" "of" "0_waku" "")
              (setvar "CLAYER" "0")
            )
          )
          ; 01/03/02 HN E-MOD �̈�g�̔�\��������ǉ�
;;;03/04/18YM@MOD          (command "_.save" (strcat (getvar "dwgprefix") (getvar "dwgname")))
					; 03/04/18 YM MOD-S
				  (command "_.QSAVE")
				  (if (wcmatch (getvar "CMDNAMES") "*QSAVE*")
				    (command "2000" "")
				  )
					; 03/04/18 YM MOD-E

        )
      )
      (setq CG_OpenMode 5)
      ;���j���[�؂�ւ�
      (ChgSystemCADMenu "")
      (CfDwgOpenByScript #sFname)
    )
  )
;;;	(CFAlertMsg "�I���ӁF����ڰĂ̕ۑ��ɂ͕K���A[հ�ް����ڰ�][հ�ް����ڰĕۑ�]�����g�����������B")

  ; �I������ 2000/09/07 HT
  (SCFEndShori)

  (princ)
) ; C:SCFMkTplRead

;<HOM>*************************************************************************
; <�֐���>    : SCFMkTplBefore
; <�����T�v>  : հ������ڰĕҏW�O�̏���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/01/28
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCFMkTplBefore (
  /
  )
  ;��w�쐬
  (if (not (tblsearch "LAYER" "0_WAKU")) (SKFMakeLayer "0_WAKU" 8 "CONTINUOUS"))

  ; �̈�}�`�̑��݂����w��\���ɂ��� 2000/09/26 HT MOD START
  (SCFWakuLayerON)
  ;;��wON
  ;(command "-layer" "on" "0_WAKU" "")
  ;;���݉�w�ɐݒ�
  ;(setvar "CLAYER" "0_WAKU")
  ; �̈�}�`�̑��݂����w��\���ɂ��� 2000/09/26 HT MOD END


  ;ZOOM
  (command "_.ZOOM" "A")
  ;�O���[�v
  (setvar "PICKSTYLE" 3)
  ;�I�[�v�����[�h
  (setq CG_OpenMode nil)

  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : C:SCFMkTplRect
; <�����T�v>  : հ������ڰĂ̍쐬 -> �̈�쐬
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-18
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun C:SCFMkTplRect (
  /
  #sClayer #Pt$ #eR #sVcode #sTxt #dMin #dMax #dPt #eT #xSp #eEn
  )

  (SCFStartShori "SCFMkTplRect")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  (if (JudgeModeMkTpl)
    (progn
      ;��w�쐬
      (setvar "PICKSTYLE" 3)
      (setq #sClayer (getvar "CLAYER"))
      ; �̈�}�`�̑��݂����w��\���ɂ��� 2000/09/26 HT ADD
      (SCFWakuLayerON)
      ;(setvar "CLAYER" "0_WAKU")
      (setq #Pt$ (CFDrawRectOrRegionTransUcs 1))
      (if (/= nil #Pt$)
        (progn
          (setq #eR (entlast))
          (setq #sVcode (SCFMkTplRectDlg "P"))
          (if (/= nil #sVcode)
            (progn
              ;�g���ް��t��
              (if (not (tblsearch "APPID" "FRAME")) (regapp "FRAME"))
              (CfSetXData #eR "FRAME" (list #sVcode))
              ;�e�L�X�g�\��
              (cond
                ((= "P"  #sVcode) (setq #sTxt "���ʐ}"))
                ((= "SA" #sVcode) (setq #sTxt "�W�J�`�}"))
                ((= "SB" #sVcode) (setq #sTxt "�W�J�a�}"))
                ((= "SC" #sVcode) (setq #sTxt "�W�J�b�}"))
                ((= "SD" #sVcode) (setq #sTxt "�W�J�c�}"))
                ((= "SE" #sVcode) (setq #sTxt "�W�J�d�}"))  ; 2000/10/06 HT
                ((= "D"  #sVcode) (setq #sTxt "�d�l�}"))
                ((= "F" (substr #sVcode 1 1))
                  (setq #sTxt (strcat "�p�}" (substr #sVcode 2)))
                )
              )
              (setq #dMin (list (apply 'min (mapcar 'car #Pt$))(apply 'min (mapcar 'cadr #Pt$))))
              (setq #dMax (list (apply 'max (mapcar 'car #Pt$))(apply 'max (mapcar 'cadr #Pt$))))
              (setq #dPt  (mapcar '* '(0.5 0.5) (mapcar '+ #dMin #dMax)))
              (setq #dPt  (list (car #dPt) (cadr #dPt) 0.0))
              (entmake
                (list
                  (cons 0 "TEXT")
                  (cons 1 #sTxt)
                  (cons 10 #dPt)
                  (cons 11 #dPt)
                  (cons 40 200)      ; ��������
                  (cons 72 1)        ; �����ʒu���킹
                  (cons 73 2)        ; �����ʒu���킹
                  (cons 50 0)        ; ��]�p�x
                )
              )
              (setq #eT (entlast))
              ;�O���[�v��
              (setq #xSp (ssadd))
              (ssadd #eR #xSp)
              (ssadd #eT #xSp)
              (SKMkGroup #xSp)
            )
            (entdel #eEn)
          )
        )
      )
      (setvar "CLAYER" #sClayer)
    )
    (progn
      (CFAlertMsg "�e���v���[�g���J���Ă��܂���")
    )
  )

  ; �I������ 2000/09/07 HT
  (SCFEndShori)
  (princ)
) ; C:SCFMkTplRect

;<HOM>*************************************************************************
; <�֐���>    : C:SCFMkTplDel
; <�����T�v>  : հ������ڰĂ̍쐬 -> �̈�폜
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-18
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun C:SCFMkTplDel (
  /
  #xSp #En$ #Ex$ #eEn #Gen$ #eGen #eRect #iOk
  )
  (SCFStartShori "SCFMkTplDel")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  ; �̈�}�`�̑��݂����w��\���ɂ��� 2000/09/26 HT ADD
  (SCFWakuLayerON)

  (if (JudgeModeMkTpl)
    (progn
      (setq #xSp (ssget "X" (list (list -3 (list "FRAME")))))
      (if (/= nil #xSp)
        (progn
          (setq #En$ T)
          (while (/= nil #En$)
            (setq #En$ (SKGetPtByEn "�폜����̈��I�����Ă�������." "*" "�̈�" nil))
            (if (/= nil #En$)
              (progn
                ;�w�肳�ꂽ�}�`�̃O���[�v���l��
                (setq #Gen$ (SKFGetGroupEnt (car (car #En$))))
                (mapcar
                 '(lambda ( #eGen )
                    (setq #Ex$ (CfGetXData #eGen "FRAME"))
                    (if (/= nil #Ex$)
                      (progn
                        (setq #eEn #eGen)
                        (setq #En$ nil)
                      )
                    )
                  )
                  #Gen$
                )
                (if (= nil #eEn)
                  (setq #En$ T)
                )
              )
            )
          )
          (if (/= nil #eEn)
            (progn
              ;�O���[�v���n�C���C�g
              (mapcar
               '(lambda ( #eGen )
                  (if (assoc -3 (entget #eGen '("RECT")))
                    (setq #eRect #eGen)
                  )
                  (redraw #eGen 3)
                )
                #Gen$
              )
              ;�m�F�_�C�A���O
              (setq #iOk (CFYesNoDialog "���̗̈���폜���܂�\n��낵���ł����H"))
              (mapcar
               '(lambda ( #eGen )
                  (redraw #eGen 4)
                )
                #Gen$
              )
              (if (= T #iOk)
                (progn
                  ;��ٰ�ߕ���
                  (setq #sName (SKGetGroupName (car #Gen$)))
                  ;113 01/04/08 HN MOD OEM�ł̔�����@��ύX
                  ;MOD(if (= "OEM" CG_ACAD_VER)
                  (if (/= "ACAD" (strcase (getvar "PROGRAM")))
                    (command "_.-group" "U" #sName)
                    (command "_.-group" "E" #sName)
                  )
                  ;��폜
                  (mapcar
                   '(lambda ( #eGen )
                      (entdel #eGen)
                    )
                    #Gen$
                  )
                )
              )
            )
          )
        )
        (progn
          (CFAlertMsg "�̈�}�`���}�ʓ��ɑ��݂��܂���")
        )
      )
    )
    (progn
      (CFAlertMsg "�e���v���[�g���J���Ă��܂���")
    )
  )

  ; �I������ 2000/09/07 HT
  (SCFEndShori)
  (princ)
) ; C:SCFMkTplDel

;<HOM>*************************************************************************
; <�֐���>    : C:SCFMkTplEdit
; <�����T�v>  : հ������ڰĂ̍쐬 -> �����ύX
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-18
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun C:SCFMkTplEdit (
  /
  #xSp #En$ #Ex$ #eEn #sVcode #Gen$ #eG #eT #sTxt
  )

  (SCFStartShori "SCFMkTplEdit")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  ; �̈�}�`�̑��݂����w��\���ɂ��� 2000/09/26 HT ADD
  (SCFWakuLayerON)

  (if (JudgeModeMkTpl)
    (progn
      (setq #xSp (ssget "X" (list (list -3 (list "FRAME")))))
      (if (/= nil #xSp)
        (progn
          (setq #En$ T)
          (while (/= nil #En$)
            (setq #En$ (SKGetPtByEn "�����ύX����̈��I�����Ă�������." "*" "�̈�" nil))
            (if (/= nil #En$)
              (progn
                ;�w�肳�ꂽ�}�`�̃O���[�v���l��
                (setq #Gen$ (SKFGetGroupEnt (car (car #En$))))
                (mapcar
                 '(lambda ( #eGen )
                    (setq #Ex$ (CfGetXData #eGen "FRAME"))
                    (if (/= nil #Ex$)
                      (progn
                        (setq #eEn #eGen)
                        (setq #sVcode (car (CfGetXData #eEn "FRAME")))
                        (setq #En$ nil)
                      )
                    )
                  )
                  #Gen$
                )
                (if (= nil #eEn)
                  (setq #En$ T)
                )
              )
            )
          )
          (if (/= nil #eEn)
            (progn
              (setq #sVcode (SCFMkTplRectDlg #sVcode))
              (if (/= nil #sVcode)
                (progn
                  ;�g���ް��ύX
                  (CfSetXData #eEn "FRAME" (list #sVcode))
                  ;�w�肳�ꂽ�}�`�̃O���[�v���l��
                  (setq #Gen$ (SKFGetGroupEnt #eEn))
                  (mapcar
                   '(lambda ( #eG )
                      (if (equal "TEXT" (cdr (assoc 0 (entget #eG))))
                        (setq #eT #eG)
                      )
                    )
                    #Gen$
                  )
                  ;�e�L�X�g�\��
                  (cond
                    ((= "P"  #sVcode) (setq #sTxt "���ʐ}"))
                    ((= "SA" #sVcode) (setq #sTxt "�W�J�`�}"))
                    ((= "SB" #sVcode) (setq #sTxt "�W�J�a�}"))
                    ((= "SC" #sVcode) (setq #sTxt "�W�J�b�}"))
                    ((= "SD" #sVcode) (setq #sTxt "�W�J�c�}"))
                    ((= "SE" #sVcode) (setq #sTxt "�W�J�d�}"))  ; 2000/10/06 HT ADD
                    ((= "D"  #sVcode) (setq #sTxt "�d�l�}"))
                    ((= "F"  (substr #sVcode 1 1))
                      (setq #sTxt (strcat "�p�}" (substr #sVcode 2)))
                    )
                  )
                  (entmod (subst (cons 1 #sTxt) (assoc 1 (entget #eT)) (entget #eT)))
                )
              )
            )
          )
        )
        (progn
          (CFAlertMsg "�̈�}�`���}�ʓ��ɑ��݂��܂���")
        )
      )
    )
    (progn
      (CFAlertMsg "�e���v���[�g���J���Ă��܂���")
    )
  )

  ; �I������ 2000/09/07 HT
  (SCFEndShori)
  (princ)
) ; C:SCFMkTplEdit

;<HOM>*************************************************************************
; <�֐���>    : C:SCFMkTplSave
; <�����T�v>  : հ������ڰĂ̍쐬 -> �ۑ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-18
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun C:SCFMkTplSave
  (
  /
  #sFname #dfname
  )

  (SCFStartShori "SCFMkTplSave")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  (if (JudgeModeMkTpl)
    (progn
      (command "_-layer" "of" "0_waku" "")
      (setvar "CLAYER" "0")
      (setq #iRet nil)

      (while (= #iRet nil)
        (setq #sFname (getfiled "����ڰĕۑ�" CG_TMPHPATH "dwt" 1))
        (if (/= nil #sFname)
          (progn
            ; �e���v���[�g�t�@�C�����������K���ɂ����Ă��邩�ǂ����̊m�F
            ; 2000/08/08 HT
            (setq #iRet (SCFDWTFNameCheck #sFname))
            (if (= #iRet nil)
              (progn
                ; �����K���ɂ����Ă��Ȃ����A�ۑ����邩�ǂ����m�F����B
                ; �����K���ɂ����Ă��Ȃ��ꍇ�A�p�^�[���ڍאݒ�̃t�B���^��
                ; �ΏۂɂȂ�Ȃ��B���A���ɉe���͂Ȃ��B
                (setq #iRet
                  (CFYesNoDialog
                    (strcat
                      "�e���v���[�g���������K���ɂ����Ă��܂���B"
                      "\n   �ۑ����Ă�낵���ł����H\n"
                      "\n    [�����K��] "
                      "\n     (1-2���p���T�C�Y = A4 A3 A2 B4)"
                      "\n     (4-5���ړx = 40 30 20 01)"
                      "\n       ��.) A3-30-1-IU�^����.dwt"
                    )
                  )
                )
              )
            )
            (if (= #iRet T)
              (progn
                (setq #dfname (strcat CG_TMPAPATH "dummy.dwg"))
                (command "_.saveas" "2000" #dfname)

								;2020/03/06 YM MOD-S
;;;                (command "_.saveas" "t" #sFname )
                (command "_.saveas" "t" #sFname "m" "");�P�ʃ��[�g���A�e���v���[�g�̐���
								;2020/03/06 YM MOD-E

                (if (findfile #dfname)
                  (vl-file-delete #dfname)
                )
              )
            )  ; �m�F���b�Z�[�W
          ) ; progn
          (progn
            ; �t�@�C���_�C�A���O�ŃL�����Z�����ꂽ���̓��[�v�𔲂���
            (setq #iRet T)
          )
        ) ; �t�@�C���_�C�A���O
      ) ; while
    )
    (progn
      (CFAlertMsg "�e���v���[�g���J���Ă��܂���B")
    )
  )

  ; �I������ 2000/09/07 HT
  (SCFEndShori)
  (princ)
) ; C:SCFMkTplSave


;<HOM>*************************************************************************
; <�֐���>    : SCFDWTFNameCheck
; <�����T�v>  : �e���v���[�g�t�@�C�����������K���ɂ����Ă��邩�ǂ����̊m�F
; <�߂�l>    : �����Ă��� : T    not : nil
; <�쐬>      : 2000/08/08
; <���l>      : �p�^�[���ڍאݒ�_�C�A���O�ł̃t�B���^�[�Ŏg�p�\���ǂ���
;*************************************************************************>MOH<
(defun SCFDWTFNameCheck (
  &sDWTFileName     ; �e���v���[�g�t�@�C����
  /
  #sPaperSize$      ; �p���T�C�Y
  #sScale$	    ; �ړx
  #bRet             ; �Ԃ�l
  #sFileName        ; �f�B���N�g���p�X�Ɗg���q���������t�@�C����

  )
  (setq #bRet T)
  (setq #sFileName (vl-filename-base &sDWTFileName))
  (setq #sPaperSize$ (list "A4" "A3" "A2" "B4"))
  (setq #sScale$ (list "40" "30" "20" "01"))
  (if (or
    (= nil (member (substr #sFileName 1 2) #sPaperSize$))
    (= nil (member (substr #sFileName 4 2) #sScale$))
    )
    (progn
    (setq #bRet nil)
    )
  )
#bRet
)

;<HOM>*************************************************************************
; <�֐���>    : SCFMkTplRectDlg
; <�����T�v>  : հ������ڰĂ̍쐬�޲�۸�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-18
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SCFMkTplRectDlg (
  &sVcode     ; �޲�۸ޕ\�������l
  /
  #ss #i #en #ed$ #fno$ #iId #sRet ##OK_Click #iRet
  )

  (defun ##OK_Click(
    /
    #sDrw #sRet #fs
    )
    (setq #sDrw (get_tile "rdoDrw"))
    (cond
      ((= "rdoPl" #sDrw) (setq #sRet "P"))
      ((= "rdoEx" #sDrw)
        (cond
          ((= "rdoA" (get_tile "rdoDrc")) (setq #sRet "SA"))
          ((= "rdoB" (get_tile "rdoDrc")) (setq #sRet "SB"))
          ((= "rdoC" (get_tile "rdoDrc")) (setq #sRet "SC"))
          ((= "rdoD" (get_tile "rdoDrc")) (setq #sRet "SD"))
          ((= "rdoE" (get_tile "rdoDrc")) (setq #sRet "SE"))  ; 2000/10/06 HT ADD
        )
      )
      ((= "rdoDn" #sDrw) (setq #sRet "D"))
;2011/07/25 YM DEL-S
;;;      ((= "rdoFg" #sDrw)
;;;        (cond
;;;          ((/= 'INT (type (read (get_tile "edtfig"))))
;;;            (CFAlertMsg "�������w�肵�Ă�������")
;;;          )
;;;          ((minusp (read (get_tile "edtfig")))
;;;            (CFAlertMsg "���̒l���w�肵�Ă�������")
;;;          )
;;;          ((member (get_tile "edtfig") #fno$)
;;;            (CFAlertMsg "���̒l�͊��ɑ��݂��܂�")
;;;          )
;;;          (T
;;;            (setq #fs (get_tile "edtfig"))
;;;            (setq #sRet (strcat "F" #fs))
;;;          )
;;;        )
;;;      )
;2011/07/25 YM DEL-E
    )
    (if (/= nil #sRet)
      (done_dialog 1)
    )

    #sRet
  )
  (defun ##Chg_Image(
    /
    #sPlan #sFname #fX #fY
    )
    ;�W�J������C���[�W
    (setq #sPlan (get_tile "rdoDrw"))
    (if (= #sPlan "rdoEx")
      (progn
        (setq #sFname "abcd")
        (mode_tile "rdoDrc" 0)
      )
      (progn
        (setq #sFname "no")
        (mode_tile "rdoDrc" 1)
      )
    )
    (setq #fX (dimx_tile "imgYashi"))
    (setq #fY (dimy_tile "imgYashi"))
    (start_image "imgYashi")
    (fill_image  0 0 #fX #fY -0)
    (slide_image 0 0 #fX #fY (strcat CG_SLDPATH #sFname ".sld"))
    (end_image)

    ;�p�}�ԍ�
;2011/07/25 YM DEL-S
;;;    (if (= #sPlan "rdoFg")
;;;      (progn
;;;        (mode_tile "edtfig" 0)
;;;        (mode_tile "edtfig" 2)
;;;      )
;;;      (mode_tile "edtfig" 1)
;;;    );_if
;2011/07/25 YM DEL-E

  )

  ;�����̎p�}�ԍ��l��
  (setq #ss (ssget "X" (list (list -3 (list "FRAME")))))
  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #ed$ (CfGetXData #en "FRAME"))
        (if (= "F" (substr (car #ed$) 1 1))
          (setq #fno$ (cons (substr (car #ed$) 2) #fno$))
        )
        (setq #i (1+ #i))
      )
    )
  )

  ;�޲�۸ޕ\��
  (setq #iId (GetDlgID "CSFmktmp"))
  (if (not (new_dialog "mktpl" #iId))(exit))

    (cond
      ((= "P"  &sVcode) (set_tile "rdoPl" "1")(set_tile "rdoA" "1"))
      ((= "SA" &sVcode) (set_tile "rdoEx" "1")(set_tile "rdoA" "1"))
      ((= "SB" &sVcode) (set_tile "rdoEx" "1")(set_tile "rdoB" "1"))
      ((= "SC" &sVcode) (set_tile "rdoEx" "1")(set_tile "rdoC" "1"))
      ((= "SD" &sVcode) (set_tile "rdoEx" "1")(set_tile "rdoD" "1"))
      ((= "SE" &sVcode) (set_tile "rdoEx" "1")(set_tile "rdoE" "1")) ; 2000/10/06 HT ADD
      ((= "D"  &sVcode) (set_tile "rdoDn" "1")(set_tile "rdoA" "1"))
;2011/07/25 YM DEL-S
;;;      ((= "F"  (substr &sVcode 1 1))
;;;        (set_tile "rdoFg" "1")
;;;        (set_tile "edtfig" (substr &sVcode 2))
;;;      )
;2011/07/25 YM DEL-E
    )
    (##Chg_Image)

    (action_tile "rdoDrw" "(##Chg_Image)")
    (action_tile "accept" "(setq #sRet (##OK_Click))")
    (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OK�{�^������
    #sRet
    nil
  )
) ; SCFMkTplRectDlg

;<HOM>*************************************************************************
; <�֐���>    : JudgeModeMkTpl
; <�����T�v>  : ���[�U�e���v���[�g�̍쐬���[�h�����f
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/01/31
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun JudgeModeMkTpl (
  /
  #sFname
  )
  (setq #sFname (getvar "DWGNAME"))
  (if (equal (strcase #sFname) "MODEL.DWG")
    nil
    T
  )

) ; JudgeModeMkTpl


;<HOM>*************************************************************************
; <�֐���>    : SCFWakuLayerON
; <�����T�v>  : 0_WAKU ��w ON  + ���݉�w��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/09/26
; <���l>      : �̈�}�`�̑��݂����w��\���ɂ���
;*************************************************************************>MOH<
(defun SCFWakuLayerON (
  /
  )
  ;��w�쐬
  (if (not (tblsearch "LAYER" "0_WAKU")) (SKFMakeLayer "0_WAKU" 8 "CONTINUOUS"))
  ;��wON
  (SCF_LayDispOn (list "0_WAKU"))
  ;���݉�w�ɐݒ�
  (setvar "CLAYER" "0_WAKU")
)


