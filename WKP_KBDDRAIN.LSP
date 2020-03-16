;<HOM>*************************************************************************
; <�֐���>    : SBDrawDrainageBefore
; <�����T�v>  : ���r���ݔ��}���쐬���邽�߂̊��𐮂���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-06-16
; <���l>      : �e���v���[�g�t�@�C���ŐV�K�}�ʂ̂Ƃ����ϐ}�쐬
;               �}�ʂɖ��O������ꍇ
;                 �� �㏑���ۑ����A�V�K�}�ʂɂ���
;               �}�ʂɖ��O�͂Ȃ����}�`�����݂���Ƃ�
;                 �� ���݂̐}�ʂ�������A�V�K�}�ʂɂ���
;*************************************************************************>MOH<
(defun SBDrawDrainageBefore (
  /
  #tempdir #tempfile
  )
;;;  (CFOutStateLog 1 2 "//// SBDrawDrainageBefore ////")

  ; �e���v���[�g�t�@�C���̊i�[�f�B���N�g��
  (setq #tempdir (strcat CG_SYSPATH "template\\bath\\"))

  ; �e���v���[�g�t�@�C����
  (setq #tempfile (strcat #tempdir "SB_���r.dwt"))
  (if (findfile #tempfile)
    (progn

;;;      (CFOutStateLog 1 2 "�e���v���[�g�t�@�C���� = ")(CFOutStateLog 1 2 #tempfile)
      (if (/= nil CG_OpenMode)
        (progn

;;;          (CFOutStateLog 1 2 "���r���ݔ��}��}")
          (setq CG_OpenMode nil)
          (SBDrawDrainage)
        )
        (if (equal "DRAWING.DWG" (strcase (getvar "DWGNAME")))
          (progn
            (command "_point" "0,0")

;;;            (CFOutStateLog 1 2 "�V�K�}�ʂɂ���")
            (setq CG_OpenMode 3)
            (if (= 0 (getvar "DBMOD"))
              ;00/02/03 HN S-MOD (command "_.new")��ύX
              ;@@@(command ".new" #tempfile)
              (CfDwgNewByScript #tempfile)
              ;00/02/03 HN E-MOD (command "_.new")��ύX
              (progn
;;;                (CFOutStateLog 1 2 "�����}�ʕ���")
                ;00/02/03 HN S-MOD (command "_.new")��ύX
                ;@@@(command ".new" "Y" #tempfile)
                (CfDwgNewByScript #tempfile)
                ;00/02/03 HN E-MOD (command "_.new")��ύX
              )
            )
          )
          (progn

;;;            (CFOutStateLog 1 2 "�}�ʂɖ��O���L��")
            (setq CG_OpenMode 3)
;;;            (CFOutStateLog 1 2 "�㏑���ۑ�")
            (command ".qsave")
;;;            (CFOutStateLog 1 2 "�V�K�}�ʂɂ���")
            ;00/02/03 HN S-MOD (command "_.new")��ύX
            ;@@@(command ".new" #tempfile)
            (CfDwgNewByScript #tempfile)
            ;00/02/03 HN E-MOD (command "_.new")��ύX

          )
        ) ; end if
      ) ; end if
    )
    (progn
;;;      (CFOutStateLog 1 2 "���r���ݔ��}�̃e���v���[�g�t�@�C�������݂��܂���.")
;;;      (CFOutStateLog 1 2 "�e���v���[�g�t�@�C���� = ")(CFOutStateLog 1 2 #tempfile)
    )
  ) ; end if

  (princ) ; return
) ; SBDrawDrainageBefore

;<HOM>*************************************************************************
; <�֐���>    : SBDrawDrainage
; <�����T�v>  : ���r���ݔ��}���쐬����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-06-16
; <�C��>      : 1999-03-01
; <���l>      : ���̊֐��ł͌��ݓ��ϐ}�p�e���v���[�g�ŐV�K�}�ʂ��J�������
;               �ł��邱�Ƃ�O������Ƃ���.
;*************************************************************************>MOH<
(defun SBDrawDrainage (
  /
  #cfgname #savedir #tlayer #90 #cfgequ$ #bpt$ #cmdecho #dsize #wsize #bpt$ #view #LAY$
  )
;;;  (CFOutStateLog 1 2 "//// SBDrawDrainage ////")

  ;--------------- �����ݒ�-----------------
  (setq #cfgname (strcat CG_SBDATAPATH CG_SeriesFolder "\\CFG\\CLASSIFI.CFG"))
  (setq #savedir CG_SBOUTPATH)
  (setq #tlayer "0_TITLET")
  (setq #90 90)
  (setq #lay$
    (list
      "0"
      "0_frame" "0_pers" "0_plane" "0_side_a" "0_titlef"  "0_titlet"
    )
  )
  ;-----------------------------------------

  (if (findfile #cfgname)
    (progn
;(dpr '#cfgname)
;;;      (CFOutStateLog 1 2 "CFG�t�@�C�����X�g�ҏW")
      (setq #cfgequ$ (cadr (SBModCfgFile #cfgname #90)))
;(dpr '#cfgequ$)
;;;      (CFOutStateLog 1 2 "���r���ݔ��}��}")
      (setq #bpt$ (SBGetGeneralBasePt #90))
      (SBDrawGeneralPlan #bpt$ #cfgequ$ (strcat CG_SBDATAPATH CG_SeriesFolder "\\"))

;;;      (CFOutStateLog 1 2 "���@���ҏW")
      ;-------�C�� �X�{----------------
      (SBModDimensionSketch CG_WOffset CG_BaseOffset)
      ;-------------------------------

;;;      (CFOutStateLog 1 2 "�^�C�g���쐬")
      (SBMakeTitleText
        #tlayer CG_PackName CG_BukkenName CG_SeriesName CG_KoujiKind
        CG_BukkenNo CG_Zno CG_ModelName
      )

;;;      (CFOutStateLog 1 2 "�p�[�W")
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

;;;      (CFOutStateLog 1 1 "��w�\���ҏW")
      (command "_.-LAYER" "OF" "*" "")
      (command "_.-LAYER")
      (foreach #lay #lay$
        (if (tblsearch "layer" #lay)
          (command "ON" #lay)
        )
      )
      (command "")
      (setvar "CLAYER" "0")

;;;      (CFOutStateLog 1 2 "�}�ʕۑ�")
      (SBSaveas #savedir CG_BukkenNo CG_Zno)
    )
    (progn
;;;      (CFOutStateLog 0 1 "CFG�t�@�C�������݂��܂���")
    )
  ) ; end if

  (setvar "filedia" 1)

  (princ) ; return
) ; SBDrawDrainage
