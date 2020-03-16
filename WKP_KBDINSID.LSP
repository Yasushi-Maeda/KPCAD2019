;<HOM>*************************************************************************
; <�֐���>    : SBDrawInsideBefore
; <�����T�v>  : ���ϐ}���쐬���邽�߂̊��𐮂���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-06-16
; <���l>      : �e���v���[�g�t�@�C���ŐV�K�}�ʂ̂Ƃ����ϐ}�쐬
;               �}�ʂɖ��O������ꍇ
;                 �� �㏑���ۑ����A�V�K�}�ʂɂ���
;               �}�ʂɖ��O�͂Ȃ����}�`�����݂���Ƃ�
;                 �� ���݂̐}�ʂ�������A�V�K�}�ʂɂ���
;*************************************************************************>MOH<
(defun SBDrawInsideBefore (
  /
  #tempdir #tempfile
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawInsideBefore ////")
	(CFOutStateLog 1 1 " ")

  ; �e���v���[�g�t�@�C���̊i�[�f�B���N�g��
  (setq #tempdir (strcat CG_SYSPATH "template\\bath\\"))

  ; �e���v���[�g�t�@�C����
  (setq #tempfile (strcat #tempdir "SB_����" CG_SizeCode ".dwt"))
  (if (findfile #tempfile)
    (progn

      (CFOutStateLog 1 1 "�e���v���[�g�t�@�C���� = ")(CFOutStateLog 1 1 #tempfile)
      (if (/= nil CG_OpenMode)
        (progn

          (CFOutStateLog 1 1 "���ϐ}��}")
          (setq CG_OpenMode nil)
          (SBDrawInside)
        )
        (if (equal "DRAWING.DWG" (strcase (getvar "DWGNAME")))
          (progn
            (command "_point" "0,0")

            (CFOutStateLog 1 1 "�V�K�}�ʂɂ���")
            (setq CG_OpenMode 3)
            (if (= 0 (getvar "DBMOD"))
              ;00/02/03 HN S-MOD (command "_.new")��ύX
              ;@@@(command ".new" #tempfile)
              (CfDwgNewByScript #tempfile)
              ;00/02/03 HN E-MOD (command "_.new")��ύX
              (progn
                (CFOutStateLog 1 1 "�����}�ʕ���")
                ;00/02/03 HN S-MOD (command "_.new")��ύX
                ;@@@(command ".new" "Y" #tempfile)
                (CfDwgNewByScript #tempfile)
                ;00/02/03 HN E-MOD (command "_.new")��ύX
              )
            )

          )
          (progn

            (CFOutStateLog 1 1 "�}�ʂɖ��O���L��")
            (setq CG_OpenMode 3)
            (CFOutStateLog 1 1 "�㏑���ۑ�")
            (command ".qsave")
            (CFOutStateLog 1 1 "�V�K�}�ʂɂ���")
            ;00/02/03 HN S-MOD (command "_.new")��ύX
            ;@@@(command ".new" #tempfile)
            (CfDwgNewByScript #tempfile)
            ;00/02/03 HN E-MOD (command "_.new")��ύX

          )
        ) ; end if
      ) ; end if
    )
    (progn
      (CFOutStateLog 1 1 "���ϐ}�̃e���v���[�g�t�@�C�������݂��܂���.")
      (CFOutStateLog 1 1 "�e���v���[�g�t�@�C���� = ")(CFOutStateLog 1 1 #tempfile)
    )
  ) ; end if

  (princ) ; return
) ; SBDrawInsideBefore

;<HOM>*************************************************************************
; <�֐���>    : SBDrawInside
; <�����T�v>  : ���ϐ}���쐬����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-06-16
; <�C��>      : 1999-02-15 �i�ϐ��@����MASTER�}�ʑS�ĂɗL���ɂ���j
; <���l>      : ���̊֐��ł͌��ݓ��ϐ}�p�e���v���[�g�ŐV�K�}�ʂ��J�������
;               �ł��邱�Ƃ�O������Ƃ���.
;*************************************************************************>MOH<
(defun SBDrawInside (
  /
  #cfgname #savedir #tlayer #90 #vlayer #dlayer #dsize #wsize #cfg$ #cfgnai$ #cfgequ$
  #bpt #pdata$ #bpt$ #cmdecho #lay$
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawInside ////")
	(CFOutStateLog 1 1 " ")

  ;--------------- �����ݒ�-----------------
  (setq #cfgname (strcat CG_SBDATAPATH CG_SeriesFolder "\\CFG\\CLASSIFI.CFG"))  ; CFG�t�@�C����
  (setq #savedir CG_SBOUTPATH)
  (setq #tlayer "0_TITLET")                           ; �^�C�g����w
  (setq #90 90)                                       ; ��ʐ}�ʋ��ENO
  (setq #vlayer "#_vardim")                           ; �ϐ��@�_��w
  (setq #lay$
    (list
      "0"
      "0_frame" "0_titlef"  "0_titlet" "0_dim"  "0_dimtxt" "0_text" "0_draw" "0_sugata" "0_syousai"
      "1_base"  "1_bathtub" "1_tile"   "1_door" "1_parts"  "1_plug"
      "2_base"  "2_bathtub" "2_tile"   "2_door" "2_parts"  "2_plug"
      "3_base"  "3_bathtub" "3_tile"   "3_door" "3_parts"  "3_plug"
      "4_base"  "4_bathtub" "4_tile"   "4_door" "4_parts"  "4_plug"
    )
  )
  ;-----------------------------------------

  ;CFG�t�@�C�������邩
  (if (findfile #cfgname)
    (progn

      (CFOutStateLog 1 1 "W,D�T�C�Y�擾")
      (setq #dsize (* 100 (atof (substr CG_SizeCode 1 2))))
      (setq #wsize (* 100 (atof (substr CG_SizeCode 3 2))))

      (CFOutStateLog 1 1 "UB�Ǔ����̈�_����}����")
      (setq #bpt$
        (SBDrawBasePoint
          CG_WOffset CG_DOffset #wsize #dsize CG_WPanelThk CG_DPanelThk CG_CeilHeight #90
          CG_BaseOffset
        )
      )
      (CFOutStateLog 1 1 "CFG�t�@�C�����X�g�ҏW")
      (setq #cfg$ (SBModCfgFile #cfgname #90))
      (setq #cfgnai$ (car  #cfg$))
      (setq #cfgequ$ (cadr #cfg$))

      (CFOutStateLog 1 1 "���ϐ}��}")
      (setq #bpt$
        (SBDrawInsideParts
          #cfgnai$ #bpt$ #90 CG_WOffset CG_DOffset #wsize #dsize CG_WPanelThk
          CG_DPanelThk CG_CeilHeight CG_BaseOffset
        )
      )

      (CFOutStateLog 1 1 "���@����}")
      (command "_.-LAYER" "T" "*" "ON" "*" "U" "*" "")
      (setq #bpt (nth 2 (nth 0 #bpt$)))
      (setq #pdata$ (SBGetPEntity #vlayer #bpt))
      (SBDrawDImension #bpt #pdata$ CG_WOffset CG_DOffset CG_WPanelThk CG_DPanelThk CG_BaseOffset)

      (CFOutStateLog 1 1 "�h�A�ڍא}�A�B���ڍא}��}")
      (setq #bpt$ (SBGetGeneralBasePt #90))
      (SBDrawGeneralPlan #bpt$ #cfgequ$ (strcat CG_SBDATAPATH CG_SeriesFolder "\\"))

      (CFOutStateLog 1 1 "�B���̈�")
      (SBModPmenByRegion)

      (CFOutStateLog 1 1 "�^�C�g���쐬")
      (SBMakeTitleText
        #tlayer CG_PackName CG_BukkenName CG_SeriesName CG_KoujiKind
        CG_BukkenNo CG_Zno CG_ModelName
      )

      (CFOutStateLog 1 1 "�p�[�W")
      (command "_.-LAYER" "T" "*" "ON" "*" "U" "*" "")
      (setq #cmdecho (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_.PURGE" "A" "*" "Y")
      (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
        (command "Y")
      )
      (command "_.PURGE" "A" "*" "Y")
      (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
        (command "Y")
      )
      (command "_.PURGE" "A" "*" "Y")
      (while (wcmatch (getvar "CMDNAMES") "*PURGE*")
        (command "Y")
      )
      (setvar "CMDECHO" #cmdecho)
      (command  "_.ZOOM"  "A")

      (CFOutStateLog 1 1 "��w�\���ҏW")
      (command "_.-LAYER" "OF" "*" "")
      (command "_.-LAYER")
      (foreach #lay #lay$
        (if (tblsearch "layer" #lay)
          (command "ON" #lay)
        )
      )
      (command "")
      (setvar "CLAYER" "0")

      (CFOutStateLog 1 1 "�}�ʕۑ�")
      (SBSaveas #savedir CG_BukkenNo CG_Zno)
    )
    (progn
      (CFOutStateLog 0 1 "CFG�t�@�C�������݂��܂���")
    )
  ) ; end if

  (setvar "filedia" 1)

  (princ) ; return
) ; SBDrawInside


;<HOM>*************************************************************************
; <�֐���>    : SBDrawBasePoint
; <�����T�v>  : UB�Ǔ����̈�_����}����
; <�߂�l>    : ����W���X�g
;               (
;                 ����W���X�g   ; ���ʐ}
;                 ����W���X�g   ; ���ʐ}
;                 ����W���X�g   ; ���ʐ}
;                 ����W���X�g   ; �V�䕚�}
;               )
; <�쐬>      : 1998-10-15
; <�C��>      : 1999-03-01
;*************************************************************************>MOH<
(defun SBDrawBasePoint (
  &offw    ; (REAL)     ���j�b�g�I�t�Z�b�g��W
  &offd    ; (REAL)     ���j�b�g�I�t�Z�b�g��D
  &sizew   ; (REAL)     W�T�C�Y
  &sized   ; (REAL)     D�T�C�Y
  &thickw  ; (REAL)     �p�l������W
  &thickd  ; (REAL)     �p�l������D
  &ceil    ; (REAL)     �V�䍂��
  &90      ; (INT)      ��؂鐔�l
  &baseoff ; (REAL)     ��I�t�Z�b�g��
  /
  ##DrawEnXData #player #flayer #slayer #clayer #offw #offd #cclayer #ss #i #en #eg
  #eed$ #8 #pbpt #fbpt #sbpt #cbpt #pbpt$ #fbpt$ #sbpt$ #cbpt$ #dbpt$ #pt$ #pt #equ$ #no
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawBasePoint ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "���j�b�g�I�t�Z�b�g��W           : ")(CFOutStateLog 1 1 &offw   )
  (CFOutStateLog 1 1 "���j�b�g�I�t�Z�b�g��D           : ")(CFOutStateLog 1 1 &offd   )
  (CFOutStateLog 1 1 "W�T�C�Y                         : ")(CFOutStateLog 1 1 &sizew  )
  (CFOutStateLog 1 1 "D�T�C�Y                         : ")(CFOutStateLog 1 1 &sized  )
  (CFOutStateLog 1 1 "�p�l������W                     : ")(CFOutStateLog 1 1 &thickw )
  (CFOutStateLog 1 1 "�p�l������D                     : ")(CFOutStateLog 1 1 &thickd )
  (CFOutStateLog 1 1 "�V�䍂��                        : ")(CFOutStateLog 1 1 &ceil   )
  (CFOutStateLog 1 1 "��؂鐔�l                      : ")(CFOutStateLog 1 1 &90     )
  (CFOutStateLog 1 1 "��I�t�Z�b�g��                : ")(CFOutStateLog 1 1 &baseoff)
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  ;�g���f�[�^��_�}�`�ɕt������
  (defun ##DrawEnXData (
    &ptno$    ; (LIST) �_�}�`�̍��W�Ɗi�[����NO���X�g
    /
    #pt #en #no #eg #eed$
    )
    (setq #pt (car  &ptno$))
    (command "_.POINT" "non" #pt)
    (setq #en (entlast))
    (setq #no (cadr &ptno$))
    (setq #eg   (entget #en))
    (setq #eed$ (list -3 (list "G_WKPT" (cons 1070 #no))))
    (entmod (append #eg (list #eed$)))

    (princ)
  )
  ;--------------- �����ݒ�-----------------
  ;��w�ݒ�
  (setq #player "Z1_POINT")   ; ���ʐ}
  (setq #flayer "Z2_POINT")   ; ���ʐ}
  (setq #slayer "Z3_POINT")   ; ���ʐ}
  (setq #clayer "Z4_POINT")   ; �V�䕚�}
  ;W�I�t�Z�b�g
  ;---------�C�� �X�{--------------
  ;�I�t�Z�b�g�ʂ��T�C�Y1620�̂ݑ���
  (if (equal CG_SIZECODE "1620")
    (setq #offw (+ &baseoff &offw &thickw))
    (setq #offw (+ &baseoff &thickw))
  )
  (setq #offd (+ &offd &thickd))
  ;------------------------------
  ;���݉�w
  (setq #cclayer (getvar "CLAYER"))
  ;-----------------------------------------
  ;�̈�_�}�`�Z�b�g
  (setq #ss (ssget "X" '((-3 ("G_WKPT")))))
  (if (/= nil #ss)
    (progn

      (setq #i 0)
      (repeat (sslength #ss)

        (setq #en (ssname #ss #i))
        (setq #eg (entget #en '("*")))
        (setq #eed$ (cdr (assoc -3 #eg)))
        (if (/= nil #eed$)
          (progn

            ;��w
            (setq #8  (cdr (assoc 8 #eg)))
            ;NO
            (setq #no (cdr (cadr (assoc "G_WKPT" #eed$))))
            ;���W�擾
            (if (< #no &90)
              (cond
                ((= #player #8)                      ; ���ʐ}
                  (if (= 3 #no)
                    (setq #pbpt (cdr (assoc 10 #eg)))
                  )
                  (setq #pbpt$ (cons (list #no (cdr (assoc 10 #eg))) #pbpt$))
                )
                ((= #flayer #8)                      ; ���ʐ}
                  (if (= 1 #no)
                    (setq #fbpt (cdr (assoc 10 #eg)))
                  )
                  (setq #fbpt$ (cons (list #no (cdr (assoc 10 #eg))) #fbpt$))
                )
                ((= #slayer #8)                      ; ���ʐ}
                  (if (= 2 #no)
                    (setq #sbpt (cdr (assoc 10 #eg)))
                  )
                  (setq #sbpt$ (cons (list #no (cdr (assoc 10 #eg))) #sbpt$))
                )
                ((= #clayer #8)                      ; �V�䕚�}
                  (if (= 3 #no)
                    (setq #cbpt (cdr (assoc 10 #eg)))
                  )
                  (setq #cbpt$ (cons (list #no (cdr (assoc 10 #eg))) #cbpt$))
                )
              ) ; end cond
            )

          )
        ) ; end if
        (setq #i (1+ #i))

      ) ; end repeat

    )
  ) ; end if

  ;���W��NO GET
  (setq #pbpt$                   ; ���ʐ}
    (list
      (cadr (assoc 4 #pbpt$))
      (cadr (assoc 3 #pbpt$))
      (cadr (assoc 2 #pbpt$))
      (cadr (assoc 1 #pbpt$))
    )
  )
  (setq #fbpt$                   ; ���ʐ}
    (list
      (cadr (assoc 2 #fbpt$))
      (cadr (assoc 1 #fbpt$))
    )
  )
  (setq #sbpt$                   ; ���ʐ}
    (list
      (cadr (assoc 2 #sbpt$))
      (cadr (assoc 1 #sbpt$))
    )
  )
  (setq #cbpt$                   ; �V�䕚�}
    (list
      (cadr (assoc 4 #cbpt$))
      (cadr (assoc 3 #cbpt$))
      (cadr (assoc 2 #cbpt$))
      (cadr (assoc 1 #cbpt$))
    )
  )

  (CFOutStateLog 1 1 "���ʐ}")
  (setq #pt$ nil)
  ;���݉�w
  (setvar "CLAYER" #player)
  ;�D
  (setq #pt (list (+ (car #pbpt) #offw       ) (- (cadr #pbpt) #offd &sized)))
  (setq #pt$ (cons (list #pt 5) #pt$))
  (setq #pbpt$ (cons #pt #pbpt$))
  ;�E
  (setq #pt (list (+ (car #pbpt) #offw &sizew) (- (cadr #pbpt) #offd &sized)))
  (setq #pt$ (cons (list #pt 6) #pt$))
  (setq #pbpt$ (cons #pt #pbpt$))
  ;�F
  (setq #pt (list (+ (car #pbpt) #offw       ) (- (cadr #pbpt) #offd       )))
  (setq #pt$ (cons (list #pt 7) #pt$))
  (setq #pbpt$ (cons #pt #pbpt$))
  ;�G
  (setq #pt (list (+ (car #pbpt) #offw &sizew) (- (cadr #pbpt) #offd       )))
  (setq #pt$ (cons (list #pt 8) #pt$))
  (setq #pbpt$ (cons #pt #pbpt$))

  ;��}
  (mapcar '##DrawEnXData #pt$)

  (CFOutStateLog 1 1 "���ʐ}")
  (setq #pt$ nil)
  ;���݉�w
  (setvar "CLAYER" #flayer)
  ;�B
  (setq #pt (list (+ (car #fbpt) #offw       )    (cadr #fbpt)              ))
  (setq #pt$ (cons (list #pt 3) #pt$))
  (setq #fbpt$ (cons #pt #fbpt$))
  ;�C
  (setq #pt (list (+ (car #fbpt) #offw &sizew)    (cadr #fbpt)              ))
  (setq #pt$ (cons (list #pt 4) #pt$))
  (setq #fbpt$ (cons #pt #fbpt$))
  ;�D
  (setq #pt (list (+ (car #fbpt) #offw       ) (+ (cadr #fbpt) &ceil       )))
  (setq #pt$ (cons (list #pt 5) #pt$))
  (setq #fbpt$ (cons #pt #fbpt$))
  ;�E
  (setq #pt (list (+ (car #fbpt) #offw &sizew) (+ (cadr #fbpt) &ceil       )))
  (setq #pt$ (cons (list #pt 6) #pt$))
  (setq #fbpt$ (cons #pt #fbpt$))

  ;��}
  (mapcar '##DrawEnXData #pt$)

  (CFOutStateLog 1 1 "���ʐ}")
  (setq #pt$ nil)
  ;���݉�w
  (setvar "CLAYER" #slayer)
  ;�B
  (setq #pt (list (- (car #sbpt) #offd &sized)    (cadr #sbpt)              ))
  (setq #pt$ (cons (list #pt 3) #pt$))
  (setq #sbpt$ (cons #pt #sbpt$))
  ;�C
  (setq #pt (list (- (car #sbpt) #offd       )    (cadr #sbpt)              ))
  (setq #pt$ (cons (list #pt 4) #pt$))
  (setq #sbpt$ (cons #pt #sbpt$))
  ;�D
  (setq #pt (list (- (car #sbpt) #offd &sized) (+ (cadr #sbpt) &ceil       )))
  (setq #pt$ (cons (list #pt 5) #pt$))
  (setq #sbpt$ (cons #pt #sbpt$))
  ;�E
  (setq #pt (list (- (car #sbpt) #offd       ) (+ (cadr #sbpt) &ceil       )))
  (setq #pt$ (cons (list #pt 6) #pt$))
  (setq #sbpt$ (cons #pt #sbpt$))

  ;��}
  (mapcar '##DrawEnXData #pt$)

  (CFOutStateLog 1 1 "�V�䕚�}")
  (setq #pt$ nil)
  ;���݉�w
  (setvar "CLAYER" #clayer)
  ;�D
  (setq #pt (list (+ (car #cbpt) #offw       ) (- (cadr #cbpt) #offd &sized)))
  (setq #pt$ (cons (list #pt 5) #pt$))
  (setq #cbpt$ (cons #pt #cbpt$))
  ;�E
  (setq #pt (list (+ (car #cbpt) #offw &sizew) (- (cadr #cbpt) #offd &sized)))
  (setq #pt$ (cons (list #pt 6) #pt$))
  (setq #cbpt$ (cons #pt #cbpt$))
  ;�F
  (setq #pt (list (+ (car #cbpt) #offw       ) (- (cadr #cbpt) #offd       )))
  (setq #pt$ (cons (list #pt 7) #pt$))
  (setq #cbpt$ (cons #pt #cbpt$))
  ;�G
  (setq #pt (list (+ (car #cbpt) #offw &sizew) (- (cadr #cbpt) #offd       )))
  (setq #pt$ (cons (list #pt 8) #pt$))
  (setq #cbpt$ (cons #pt #cbpt$))

  ;��}
  (mapcar '##DrawEnXData #pt$)

  ;���݉�w
  (setvar "CLAYER" #cclayer)

  (list
    (reverse #pbpt$)
    (reverse #fbpt$)
    (reverse #sbpt$)
    (reverse #cbpt$)
  ) ; return
) ; SBDrawBasePoint

;<HOM>*************************************************************************
; <�֐���>    : SBDrawInsideParts
; <�����T�v>  : ���ϐ}�`���p�[�c���ɍ�}����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-10-15
;*************************************************************************>MOH<
(defun SBDrawInsideParts (
  &cfg$    ; (LIST)     CFG�t�@�C�������X�g
  &bpt$    ; (LIST)     ��_���X�g
  &90      ; (INT)      ��؂鐔�l
  &offw    ; (REAL)     ���j�b�g�I�t�Z�b�g��W
  &offd    ; (REAL)     ���j�b�g�I�t�Z�b�g��D
  &sizew   ; (REAL)     W�T�C�Y
  &sized   ; (REAL)     D�T�C�Y
  &thickw  ; (REAL)     �p�l������W
  &thickd  ; (REAL)     �p�l������D
  &ceil    ; (REAL)     �V�䍂��
  &baseoff ; (REAL)     ��I�t�Z�b�g��
  /
  #data #fname$ #z #fname #han #nhan$$ #bpt$ #fn$
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawInsideParts ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "CFG�t�@�C�������X�g             : ")(CFOutStateLog 1 1 &cfg$   )
  (CFOutStateLog 1 1 "��_���X�g                    : ")(CFOutStateLog 1 1 &bpt$   )
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  ; ���]�}�ʍ�}
  (mapcar
   '(lambda ( #data )
      ; �t�@�C�����A�\�������A���]�L���擾
      (setq #fname$ (SBGetFnameZ #data (strcat CG_SBDATAPATH CG_SeriesFolder "\\")))
      (setq #z     (car   #fname$))
      (setq #fname (cadr  #fname$))
      (setq #han   (caddr #fname$))

      (CFOutLog 1 nil (strcat "  +�}��̧�ٖ�  :" #fname))
      (CFOutLog 1 nil (strcat "    +�\������:" #z))

      (if (findfile #fname)
        (if (= "A" #han)
          (SBDrawInsert #z #fname &bpt$)
          (setq #nhan$$ (cons (list #z #fname) #nhan$$))
        )
        (progn
          (CFOutStateLog 0 1 "�t�@�C�������݂��܂���")(CFOutStateLog 0 1 #fname)
        )
      )
    )
    &cfg$
  )
  ; �}�`���]
  ;;(if (wcmatch CG_DoorCode "[CDF]"))
  (if (= CG_DoorLR "L")
    (SBMirrorParts &bpt$)
  )
  (setq #bpt$
    (SBGetBasePoint &90 CG_DoorLR &offw &offd &sizew &sized &thickw &thickd &ceil &baseoff)
  )
;  (setq #bpt$ &bpt$)
  ; ���]�ې}�ʍ�}
  (mapcar
   '(lambda ( #fn$ )
      (SBDrawInsert (car #fn$) (cadr #fn$) #bpt$)
    )
    #nhan$$
  )
  ;�A�����@�č�}
  (SBReSetShade)

  #bpt$
) ; SBDrawInsideParts


;<HOM>*************************************************************************
; <�֐���>    : SBDrawInsert
; <�����T�v>  : �p�[�c���R�s�[���A��}����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-10-15
;*************************************************************************>MOH<
(defun SBDrawInsert (
  &z       ; (REAL)     �\�������iZ���W�j
  &fname   ; (STR)      �p�[�c�t�@�C����
  &bpt$    ; (LIST)     ����W���X�g
  /
  #inen #en$ #Han$ #enno #pt$ #no #ss #bpt #lpt #mken #eg #5 #Ex$ #lastent #osmode
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawInsert ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "�\�������iZ���W�j               : ")(CFOutStateLog 1 1 &z     )
  (CFOutStateLog 1 1 "�p�[�c�t�@�C����                : ")(CFOutStateLog 1 1 &fname )
  (CFOutStateLog 1 1 "��_���X�g                    : ")
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  (CFOutStateLog 1 1 "�}�`�}��")
  (command "_.INSERT" &fname "0,0" "1" "1" "0")
  (setq #inen (entlast))

  (setq #en$ (SBGetEntityByFname #inen))
  (setq #Han$ nil)

  ; �e�}�ʖ��ɃR�s�[�A�ړ�����
  (mapcar
   '(lambda ( #enno #pt$ )

      (setq #no  (cadr #enno))
      ;�}�`�R�s�[
      (setq #ss (ssadd))
      (if (/= nil #no)
        (progn
          (setq #bpt (car  #enno))
          (setq #lpt (nth (1- #no) #pt$))
          (setq #lpt (list (car #lpt) (cadr #lpt) (atof &z)))
          (mapcar
           '(lambda ( #mken )
              (setq #eg  (entget #mken '("*")))
              (setq #5   (cdr (assoc 5 #eg)))
              (setq #Ex$ (assoc "G_HDIM" (cdr (assoc -3 #eg))))
              (if (/= nil #Ex$)
                (setq #Han$ (cons (cdr (nth 1 #Ex$)) #Han$))
              )
              (if (= nil (member #5 #Han$))
                (progn
                  (entmake (cdr #eg))
                  (ssadd (entlast) #ss)
                )
              )
            )
            (nth 2 #enno)
          )
        )
      )
      (if (/= 0 (sslength #ss))
        (progn
          ;98/11/24 Modify S.Kawamoto Start
          (if (and #lastent (/= nil (ssmemb #lastent #ss)))
            (ssdel #lastent #ss)
          )
          ;98/11/24 Modify S.Kawamoto End
          ;�}�`�ړ�
          (setq #osmode (getvar "OSMODE"))
          (setvar "OSMODE" 0)
          (command "_.MOVE" #ss "" #bpt #lpt)
          (setvar "OSMODE" #osmode)
        )
      )
      (setq #lastent (entlast))
      (setq #ss nil)
    )
    #en$ &bpt$
  )
  (entdel #inen)

  (princ) ; repeat
)

;<HOM>*************************************************************************
; <�֐���>    : SBGetEntityByFname
; <�����T�v>  : ����W�ANO�A�}�`�����X�g���e�}�ʖ��Ɋi�[����
; <�߂�l>    : �}�`�����X�g
;               (
;                 (����W NO �}�`�����X�g)   ; ���ʐ}
;                 (����W NO �}�`�����X�g)   ; ���ʐ}
;                 (����W NO �}�`�����X�g)   ; ���ʐ}
;                 (����W NO �}�`�����X�g)   ; �V�䕚�}
;               )
; <�쐬>      : 1998-10-15
;*************************************************************************>MOH<
(defun SBGetEntityByFname (
  &inen    ; (ENAME)    �p�[�c�}�`��
  /
  #en$ #en #eg #8 #eed$ #ppt #pno #pen$ #fpt #fno #fen$ #spt #sno #sen$
  #cpt #cno #cen$
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBGetEntityByFname ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "�p�[�c�}�`��                    : ")(CFOutStateLog 1 1 &inen   )
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  (CFOutStateLog 1 1 "�}�`�̍\���}�ʖ����X�g�擾")
  (setq #en$ (SBGetDataByBlock &inen))

  ;(����W NO �}�`�����X�g)
  (mapcar
   '(lambda ( #en )

      (setq #eg   (entget #en '("*")))
      (setq #8    (cdr (assoc 8 #eg)))
      (setq #eed$ (cdr (assoc -3 #eg)))
      (cond

        ((wcmatch #8 "1_*")            ; ���ʐ}
          (if (assoc "G_SBPT" #eed$)
            (progn
              (setq #ppt (cdr (assoc 10 #eg)))
              (setq #pno (cdr (nth 3 (assoc "G_SBPT" #eed$))))
            )
          )
          (setq #pen$ (cons #en #pen$))
        )

        ((wcmatch #8 "2_*")            ; ���ʐ}
          (if (assoc "G_SBPT" #eed$)
            (progn
              (setq #fpt (cdr (assoc 10 #eg)))
              (setq #fno (cdr (nth 3 (assoc "G_SBPT" #eed$))))
            )
          )
          (setq #fen$ (cons #en #fen$))
        )

        ((wcmatch #8 "3_*")            ; ���ʐ}
          (if (assoc "G_SBPT" #eed$)
            (progn
              (setq #spt (cdr (assoc 10 #eg)))
              (setq #sno (cdr (nth 3 (assoc "G_SBPT" #eed$))))
            )
          )
          (setq #sen$ (cons #en #sen$))
        )

        ((wcmatch #8 "4_*")            ; �V�䕚�}
          (if (assoc "G_SBPT" #eed$)
            (progn
              (setq #cpt (cdr (assoc 10 #eg)))
              (setq #cno (cdr (nth 3 (assoc "G_SBPT" #eed$))))
            )
          )
          (setq #cen$ (cons #en #cen$))
        )

      ) ; end cond

    )
    #en$
  ) ; end mapcar

  (list
    (list #ppt #pno #pen$)
    (list #fpt #fno #fen$)
    (list #spt #sno #sen$)
    (list #cpt #cno #cen$)
  ) ; return
)

;<HOM>*************************************************************************
; <�֐���>    : SBMirrorParts
; <�����T�v>  : �p�[�c��}�ʖ��ɔ��]����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-10-19
;*************************************************************************>MOH<
(defun SBMirrorParts (
  &bpt$    ; (LIST)     ��_���X�g
  /
  #ss #ptx1 #ptx2 #ptx #mpt1 #mpt2
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBMirrorParts ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "��_���X�g                    : ")(CFOutStateLog 1 1 &bpt$   )
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  ; ���ʐ}���]
  (setq #ss (ssget "X" (list (cons 8 "1_*"))))
  (if (/= nil #ss)
    (progn
      (setq #ptx1 (car (nth 0 (nth 0 &bpt$))))
      (setq #ptx2 (car (nth 1 (nth 0 &bpt$))))
      (setq #ptx  (+ (* (- #ptx2 #ptx1) 0.5) #ptx1))
      (setq #mpt1 (list #ptx 0.0 0.0))
      (setq #mpt2 (list #ptx 1.0 0.0))
      (command "_.MIRROR" #ss "" "_non" #mpt1 "_non" #mpt2 "Y")
    )
  )
  (setq #ss nil)

  ; ���ʐ}���]
  (setq #ss (ssget "X" (list (cons 8 "2_*"))))
  (if (/= nil #ss)
    (progn
      (setq #ptx1 (car (nth 0 (nth 1 &bpt$))))
      (setq #ptx2 (car (nth 1 (nth 1 &bpt$))))
      (setq #ptx  (+ (* (- #ptx2 #ptx1) 0.5) #ptx1))
      (setq #mpt1 (list #ptx 0.0 0.0))
      (setq #mpt2 (list #ptx 1.0 0.0))
      (command "_.MIRROR" #ss "" "_non" #mpt1 "_non" #mpt2 "Y")
    )
  )
  (setq #ss nil)

  ; ���ʐ}���]
  (setq #ss (ssget "X" (list (cons 8 "3_*"))))
  (if (/= nil #ss)
    (progn
      (setq #ptx1 (car (nth 0 (nth 2 &bpt$))))
      (setq #ptx2 (car (nth 1 (nth 2 &bpt$))))
      (setq #ptx  (+ (* (- #ptx2 #ptx1) 0.5) #ptx1))
      (setq #mpt1 (list #ptx 0.0 0.0))
      (setq #mpt2 (list #ptx 1.0 0.0))
      (command "_.MIRROR" #ss "" "_non" #mpt1 "_non" #mpt2 "Y")
    )
  )
  (setq #ss nil)

  ; �V�䕚�}���]
  (setq #ss (ssget "X" (list (cons 8 "4_*"))))
  (if (/= nil #ss)
    (progn
      (setq #ptx1 (car (nth 0 (nth 3 &bpt$))))
      (setq #ptx2 (car (nth 1 (nth 3 &bpt$))))
      (setq #ptx  (+ (* (- #ptx2 #ptx1) 0.5) #ptx1))
      (setq #mpt1 (list #ptx 0.0 0.0))
      (setq #mpt2 (list #ptx 1.0 0.0))
      (command "_.MIRROR" #ss "" "_non" #mpt1 "_non" #mpt2 "Y")
    )
  )
  (setq #ss nil)

  (princ) ; return
) ; SBMirrorParts


;<HOM>*************************************************************************
; <�֐���>    : SBReSetShade
; <�����T�v>  : �A�����@�𔽓]�������ꂽ�}�`�݂̂ɏ����������s��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-07-01
;*************************************************************************>MOH<
(defun SBReSetShade (
  /
  #ss
  )
  ; ���ʐ}
  (setq #ss (ssget "X" (list (cons 0 "DIMENSION") (cons 8 "1_*") (list -3 (list "G_HDIM")))))
  (if (/= nil #ss)
    (SBReSetShadeDimension #ss "1_hide")
  )
  ; ���ʐ}
  (setq #ss (ssget "X" (list (cons 0 "DIMENSION") (cons 8 "2_*") (list -3 (list "G_HDIM")))))
  (if (/= nil #ss)
    (SBReSetShadeDimension #ss "2_hide")
  )
  ; ���ʐ}
  (setq #ss (ssget "X" (list (cons 0 "DIMENSION") (cons 8 "3_*") (list -3 (list "G_HDIM")))))
  (if (/= nil #ss)
    (SBReSetShadeDimension #ss "3_hide")
  )
  ; �V�䕚�}
  (setq #ss (ssget "X" (list (cons 0 "DIMENSION") (cons 8 "4_*") (list -3 (list "G_HDIM")))))
  (if (/= nil #ss)
    (SBReSetShadeDimension #ss "4_hide")
  )
)

;<HOM>*************************************************************************
; <�֐���>    : SBReSetShadeDimension
; <�����T�v>  : �A�����@�𔽓]�������ꂽ�}�`�݂̂ɏ����������s��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-06-30
;*************************************************************************>MOH<

(defun SBReSetShadeDimension (
  &xSp        ; ���]�������s�����}�`�̑I���Z�b�g
  &sLay       ; ��w��
  /
  #iI #eEn #Ex$ #New$ #ed #pt$ #bpt #pt1 #pt3 #pt2
  #pt4 #ang #3den #5 #eed
  )
  (setq #iI 0)
  (repeat (sslength &xSp)
    (setq #eEn (ssname &xSp #iI))
    (setq #Ex$ (assoc -3 (entget #eEn '("G_HDIM"))))
    (if (/= nil #Ex$)
      (progn
        ;���@���č쐬
        (setq #New$ nil)
        (mapcar
         '(lambda ( #ed )
            (if (/= 2 (car #ed))
              (setq #New$ (cons #ed #New$))
            )
          )
          (entget #eEn '("*"))
        )
        (entmod (reverse #New$))
        ;���@���̕�����̗̈���擾
        (setq #pt$ (GetDimTextPt #eEn))
        (if (/= nil #pt$)
          (progn
            (setq #bpt (nth 0 #pt$))
            (setq #pt1 (list (car (nth 1 #pt$)) (cadr (nth 1 #pt$)) (nth 4 #pt$)))
            (setq #pt3 (list (car (nth 2 #pt$)) (cadr (nth 2 #pt$)) (nth 4 #pt$)))
            (setq #pt2 (list (car #pt3) (cadr #pt1) (nth 4 #pt$)))
            (setq #pt4 (list (car #pt1) (cadr #pt3) (nth 4 #pt$)))
            (setq #ang (angtos (nth 3 #pt$)))
            ; �S�Ă̍��W��WCS->UCS�ɕϊ�
            (setq #bpt (trans #bpt 0 1)
                  #pt1 (trans #pt1 0 1)
                  #pt2 (trans #pt2 0 1)
                  #pt3 (trans #pt3 0 1)
                  #pt4 (trans #pt4 0 1)
            )
            ;3D�ʍ�}
            (command "_3dface" "non" #pt1 "non" #pt2 "non" #pt3 "non" #pt4 "")
            (setq #3den (entlast))
            ;3D�ʉ�]
            (command "_rotate"  #3den ""  "non" #bpt #ang)
            (entmod (subst (cons 8 &sLay) (assoc 8 (entget #3den)) (entget #3den)))
            (setq #5   (cdr (assoc 5 (entget #3den))))
            ;�g���f�[�^�ύX
            (setq #eed (list "G_HDIM" (cons 1005 #5)))
            (entmod (append (entget #eEn) (list (list -3 #eed))))
          )
        )
      )
    )
    (setq #iI (1+ #iI))
  )

  (princ)
) ; SBReSetShadeDimension
;<HOM>*************************************************************************
; <�֐���>    : GetDimTextPt
; <�����T�v>  : ���@���̕�����̗̈���擾����
; <�߂�l>    : �̈惊�X�g�i���S���W �������W �E����W ��]�p�x Z���W�j
; <�쐬>      : 1998-09-09
;*************************************************************************>MOH<
(defun GetDimTextPt (
  &en   ; (ENAME)  ���@�}�`��
  /
  #deg #10 #42 #43 #50 #71 #dZ #min #max #pt
  )
  (setq #deg (GetDataByDimBlockMtext &en))
  (setq #10  (nth 0 #deg))        ;�}����_
  (setq #42  (nth 1 #deg))        ;��
  (setq #43  (nth 2 #deg))        ;����
  (setq #50  (nth 3 #deg))        ;��]�p�x
  (setq #71  (nth 4 #deg))        ;�A�^�b�`�����_
  (setq #dZ  (caddr (cdr (assoc 10 (entget &en)))));Z���W
  ;�}���`�e�L�X�g�̍����_�A�E��_��71�Ԃ̃t���O�����ɎZ�o����
  (cond
    ((= 1 #71)
      (setq #min (list    (car #10)              (- (cadr #10)        #43 )))
      (setq #max (list (+ (car #10)        #42 )    (cadr #10)             ))
    )
    ((= 2 #71)
      (setq #min (list (- (car #10) (* 0.5 #42)) (- (cadr #10)        #43 )))
      (setq #max (list (+ (car #10) (* 0.5 #42))    (cadr #10)             ))
    )
    ((= 3 #71)
      (setq #min (list (- (car #10)        #42 ) (- (cadr #10) (* 0.5 #43))))
      (setq #max (list    (car #10)                 (cadr #10)             ))
    )
    ((= 4 #71)
      (setq #min (list    (car #10)              (- (cadr #10) (* 0.5 #43))))
      (setq #max (list (+ (car #10)        #42 ) (+ (cadr #10) (* 0.5 #43))))
    )
    ((= 5 #71)
      (setq #min (list (- (car #10) (* 0.5 #42)) (- (cadr #10) (* 0.5 #43))))
      (setq #max (list (+ (car #10) (* 0.5 #42)) (+ (cadr #10) (* 0.5 #43))))
    )
    ((= 6 #71)
      (setq #min (list (- (car #10)        #42 ) (- (cadr #10) (* 0.5 #43))))
      (setq #max (list    (car #10)              (+ (cadr #10) (* 0.5 #43))))
    )
    ((= 7 #71)
      (setq #min (list    (car #10)                 (cadr #10)             ))
      (setq #max (list (+ (car #10)        #42 ) (+ (cadr #10)        #43 )))
    )
    ((= 8 #71)
      (setq #min (list (- (car #10) (* 0.5 #42))    (cadr #10)             ))
      (setq #max (list (+ (car #10) (* 0.5 #42)) (+ (cadr #10)        #43 )))
    )
    ((= 9 #71)
      (setq #min (list (- (car #10)        #42 )    (cadr #10)             ))
      (setq #max (list    (car #10)              (+ (cadr #10)        #43 )))
    )
  )
  (setq #pt (mapcar '* (mapcar '+ #min #max) '(0.5 0.5)))

  (list #pt #min #max #50 #dZ)
)
;<HOM>*************************************************************************
; <�֐���>    : GetDataByDimBlockMtext
; <�����T�v>  : ���@���̕�����}�`�iMTEXT�j�̕K�v�Ȓl���擾����
; <�߂�l>    : �l���X�g�i�}����_�A���A�����A��]�p�x�A�A�^�b�`�����_�j
; <�쐬>      : 1998-09-10
;*************************************************************************>MOH<
(defun GetDataByDimBlockMtext (
  &en   ; (ENAME) ���@�}�`��
  /
  #eg #2 #deg #en #10 #42 #43 #50 #71
  )
  (setq #eg (entget &en))
  (setq #2  (cdr (assoc 2 #eg)))
  (setq #deg (entget (tblobjname "BLOCK" #2)))
  (setq #en (cdr (assoc -2 #deg)))
  (setq #en (entnext #en))
  (while (/= nil #en)
    (setq #deg (entget #en))
    (if (equal "MTEXT" (cdr (assoc 0 #deg)))
      (progn
        (setq #10  (cdr (assoc 10 #deg)))  ;�}����_
        (setq #42  (cdr (assoc 42 #deg)))  ;��
        (setq #43  (cdr (assoc 43 #deg)))  ;����
        (setq #50  (cdr (assoc 50 #deg)))  ;��]�p�x
        (setq #71  (cdr (assoc 71 #deg)))  ;�A�^�b�`�����_
      )
    )
    (setq #en (entnext #en))
  )

  (list #10 #42 #43 #50 #71)
)

;<HOM>*************************************************************************
; <�֐���>    : SBGetBasePoint
; <�����T�v>  : UB�Ǔ����̈�_���l������
; <�߂�l>    : ����W���X�g
;               (
;                 ����W���X�g   ; ���ʐ}
;                 ����W���X�g   ; ���ʐ}
;                 ����W���X�g   ; ���ʐ}
;                 ����W���X�g   ; �V�䕚�}
;               )
; <�쐬>      : 1998-10-15
; <�C��>      : 1999-03-01
;*************************************************************************>MOH<
(defun SBGetBasePoint (
  &90      ; (INT)      ��؂鐔�l
  &flg     ; (STR)      �h�A�ʒu�R�[�h�i"L"�Ȃ獶�E���]�j
  &offw    ; (REAL)     ���j�b�g�I�t�Z�b�g��W
  &offd    ; (REAL)     ���j�b�g�I�t�Z�b�g��D
  &sizew   ; (REAL)     W�T�C�Y
  &sized   ; (REAL)     D�T�C�Y
  &thickw  ; (REAL)     �p�l������W
  &thickd  ; (REAL)     �p�l������D
  &ceil    ; (REAL)     �V�䍂��
  &baseoff ; (REAL)     ��I�t�Z�b�g��
  /
  #player #flayer #slayer #clayer #offw #offd
  #ss #i #en #eg #eed$ #8 #no
  #pbpt$ #fbpt$ #sbpt$ #cbpt$ #pbpt #fbpt #sbpt #cbpt
  )
  ;--------------- �����ݒ�-----------------
  ;��w�ݒ�
  (setq #player "Z1_POINT")   ; ���ʐ}
  (setq #flayer "Z2_POINT")   ; ���ʐ}
  (setq #slayer "Z3_POINT")   ; ���ʐ}
  (setq #clayer "Z4_POINT")   ; �V�䕚�}
  ;------------------------------
  ;W�I�t�Z�b�g
  ;�I�t�Z�b�g�ʂ��T�C�Y1620�̂ݑ���
  (if (equal CG_SIZECODE "1620")
    (setq #offw (+ &baseoff &offw &thickw))
    (setq #offw (+ &baseoff &thickw))
  )
  (setq #offd (+ &offd &thickd))
  ;-----------------------------------------
  ;�̈�_�}�`�Z�b�g
  (setq #ss (ssget "X" '((-3 ("G_WKPT")))))
  (if (/= nil #ss)
    (progn

      (setq #i 0)
      (repeat (sslength #ss)

        (setq #en (ssname #ss #i))
        (setq #eg (entget #en '("*")))
        (setq #eed$ (cdr (assoc -3 #eg)))
        (if (/= nil #eed$)
          (progn

            ;��w
            (setq #8  (cdr (assoc 8 #eg)))
            ;NO
            (setq #no (cdr (cadr (assoc "G_WKPT" #eed$))))
            ;���W�擾
            (if (< #no &90)
              (cond
                ((= #player #8)                      ; ���ʐ}
                  (setq #pbpt$ (cons (list #no (cdr (assoc 10 #eg))) #pbpt$))
                )
                ((= #flayer #8)                      ; ���ʐ}
                  (setq #fbpt$ (cons (list #no (cdr (assoc 10 #eg))) #fbpt$))
                )
                ((= #slayer #8)                      ; ���ʐ}
                  (setq #sbpt$ (cons (list #no (cdr (assoc 10 #eg))) #sbpt$))
                )
                ((= #clayer #8)                      ; �V�䕚�}
                  (setq #cbpt$ (cons (list #no (cdr (assoc 10 #eg))) #cbpt$))
                )
              ) ; end cond
            )

          )
        ) ; end if
        (setq #i (1+ #i))

      ) ; end repeat

    )
  ) ; end if
  (if (/= &flg "L")
    (progn                           ; ����
      (setq #pbpt$                   ; ���ʐ}
        (list
          (cadr (assoc 1 #pbpt$))
          (cadr (assoc 2 #pbpt$))
          (cadr (assoc 3 #pbpt$))
          (cadr (assoc 4 #pbpt$))
          (cadr (assoc 5 #pbpt$))
          (cadr (assoc 6 #pbpt$))
          (cadr (assoc 7 #pbpt$))
          (cadr (assoc 8 #pbpt$))
        )
      )
      (setq #fbpt$                   ; ���ʐ}
        (list
          (cadr (assoc 1 #fbpt$))
          (cadr (assoc 2 #fbpt$))
          (cadr (assoc 3 #fbpt$))
          (cadr (assoc 4 #fbpt$))
          (cadr (assoc 5 #fbpt$))
          (cadr (assoc 6 #fbpt$))
        )
      )
      (setq #sbpt$                   ; ���ʐ}
        (list
          (cadr (assoc 1 #sbpt$))
          (cadr (assoc 2 #sbpt$))
          (cadr (assoc 3 #sbpt$))
          (cadr (assoc 4 #sbpt$))
          (cadr (assoc 5 #sbpt$))
          (cadr (assoc 6 #sbpt$))
        )
      )
      (setq #cbpt$                   ; �V�䕚�}
        (list
          (cadr (assoc 1 #cbpt$))
          (cadr (assoc 2 #cbpt$))
          (cadr (assoc 3 #cbpt$))
          (cadr (assoc 4 #cbpt$))
          (cadr (assoc 5 #cbpt$))
          (cadr (assoc 6 #cbpt$))
          (cadr (assoc 7 #cbpt$))
          (cadr (assoc 8 #cbpt$))
        )
      )
    )
    (progn                           ; ���]
      (setq #pbpt (cadr (assoc 4 #pbpt$)))
      (setq #pbpt$                   ; ���ʐ}
        (list
          (cadr (assoc 1 #pbpt$))
          (cadr (assoc 2 #pbpt$))
          (cadr (assoc 3 #pbpt$))
          (cadr (assoc 4 #pbpt$))
          (list (- (car #pbpt) #offw &sizew) (- (cadr #pbpt) #offd &sized))
          (list (- (car #pbpt) #offw       ) (- (cadr #pbpt) #offd &sized))
          (list (- (car #pbpt) #offw &sizew) (- (cadr #pbpt) #offd       ))
          (list (- (car #pbpt) #offw       ) (- (cadr #pbpt) #offd       ))
        )
      )
      (setq #fbpt (cadr (assoc 2 #fbpt$)))
      (setq #fbpt$                   ; ���ʐ}
        (list
          (cadr (assoc 1 #fbpt$))
          (cadr (assoc 2 #fbpt$))
          (list (- (car #fbpt) #offw &sizew)    (cadr #fbpt)              )
          (list (- (car #fbpt) #offw       )    (cadr #fbpt)              )
          (list (- (car #fbpt) #offw &sizew) (+ (cadr #fbpt) &ceil       ))
          (list (- (car #fbpt) #offw       ) (+ (cadr #fbpt) &ceil       ))
        )
      )
      (setq #sbpt (cadr (assoc 1 #sbpt$)))
      (setq #sbpt$                   ; ���ʐ}
        (list
          (cadr (assoc 1 #sbpt$))
          (cadr (assoc 2 #sbpt$))
          (list (+ (car #sbpt) #offd       )    (cadr #sbpt)              )
          (list (+ (car #sbpt) #offd &sized)    (cadr #sbpt)              )
          (list (+ (car #sbpt) #offd       ) (+ (cadr #sbpt) &ceil       ))
          (list (+ (car #sbpt) #offd &sized) (+ (cadr #sbpt) &ceil       ))
        )
      )
      (setq #cbpt (cadr (assoc 4 #cbpt$)))
      (setq #cbpt$                   ; �V�䕚�}
        (list
          (cadr (assoc 1 #cbpt$))
          (cadr (assoc 2 #cbpt$))
          (cadr (assoc 3 #cbpt$))
          (cadr (assoc 4 #cbpt$))
          (list (- (car #cbpt) #offw &sizew) (- (cadr #cbpt) #offd &sized))
          (list (- (car #cbpt) #offw       ) (- (cadr #cbpt) #offd &sized))
          (list (- (car #cbpt) #offw &sizew) (- (cadr #cbpt) #offd       ))
          (list (- (car #cbpt) #offw       ) (- (cadr #cbpt) #offd       ))
        )
      )
    )
  )

  (list #pbpt$ #fbpt$ #sbpt$ #cbpt$) ; return
)