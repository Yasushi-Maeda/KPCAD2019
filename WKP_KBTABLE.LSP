;<HOM>*************************************************************************
; <�֐���>    : SBDrawTableBefore
; <�����T�v>  : �d�l�\���쐬���邽�߂̊��𐮂���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-11-10
; <���l>      : �e���v���[�g�t�@�C���ŐV�K�}�ʂ̂Ƃ��W�J�}�쐬
;               �}�ʂɖ��O������ꍇ
;                 �� �㏑���ۑ����A�V�K�}�ʂɂ���
;               �}�ʂɖ��O�͂Ȃ����}�`�����݂���Ƃ�
;                 �� ���݂̐}�ʂ�������A�V�K�}�ʂɂ���
;*************************************************************************>MOH<
(defun SBDrawTableBefore (
  /
  #tempdir #view #tempfile
  )
  (CFOutStateLog 1 51 "//// SBDrawTableBefore ////")


  ; �e���v���[�g�t�@�C����
  (setq #tempfile (strcat CG_SYSPATH "template\\bath\\SB_�d�l�\.dwt"))
  (if (findfile #tempfile)
    (progn

      (CFOutStateLog 1 51 "�e���v���[�g�t�@�C���� = ")(CFOutStateLog 1 51 #tempfile)
      (if (/= nil CG_OpenMode)
        (progn

          (CFOutStateLog 1 51 "�d�l�\��}")
          (setq CG_OpenMode nil)
          (SBDrawTable)

        )
        (if (equal "DRAWING.DWG" (strcase (getvar "DWGNAME")))
          (progn
            (command "_point" "0,0")

            (CFOutStateLog 1 51 "�V�K�}�ʂɂ���")
            (setq CG_OpenMode 3)
            (if (= 0 (getvar "DBMOD"))
              ;00/02/03 HN S-MOD (command "_.new")��ύX
              ;@@@(command "_.NEW" #tempfile)
              (CfDwgNewByScript #tempfile)
              ;00/02/03 HN E-MOD (command "_.new")��ύX
              (progn
                (CFOutStateLog 1 51 "�����}�ʕ���")
                ;00/02/03 HN S-MOD (command "_.new")��ύX
                ;@@@(command "_.NEW" "Y" #tempfile)
                (CfDwgNewByScript #tempfile)
                ;00/02/03 HN E-MOD (command "_.new")��ύX
              )
            )

          )
          (progn

            (CFOutStateLog 1 51 "�}�ʂɖ��O���L��")
            (setq CG_OpenMode 3)
            (CFOutStateLog 1 51 "�㏑���ۑ�")
            (command "_.QSAVE")
            (CFOutStateLog 1 51 "�V�K�}�ʂɂ���")
            ;00/02/03 HN S-MOD (command "_.new")��ύX
            ;@@@(command "_.NEW" #tempfile)
            (CfDwgNewByScript #tempfile)
            ;00/02/03 HN E-MOD (command "_.new")��ύX

          )
        ) ; end if

      ) ; end if

    )
    (progn
      (CFOutStateLog 0 42 "�d�l�\�̃e���v���[�g�t�@�C�������݂��܂���.")
      (CFOutStateLog 0 42 "�e���v���[�g�t�@�C���� = ")(CFOutStateLog 0 42 #tempfile)
    )
  ) ; end if

  (princ) ; return
) ; SKFDrawTableBefore

;<HOM>*************************************************************************
; <�֐���>    : SBDrawTable
; <�����T�v>  : �d�l�\���쐬����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-11-10
; <�C��>      : 1999-02-15 �i�}�ʔ͈͕͂ύX���Ȃ��悤�ɂ���j
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SBDrawTable (
  /
  #savedir #limmin #limmax #mlayer #tlayer #dbname #str$ #title$ #value$ #off$
  )
  (CFOutStateLog 1 51 "//// SKFDrawTable ////")


  ;--------------- �����ݒ�-----------------
  (setq #savedir CG_SBOUTPATH)

  ;�}�`�͈͐ݒ�
;  (setq #limmin '(   0.0    0.0))                ; �}�`�͈͍����_
;  (setq #limmax '(8550.0 6000.0))                ; �}�`�͈͉E��_
;  (setvar "LIMMIN" #limmin)
;  (setvar "LIMMAX" #limmax)

  ;��w
  (setq #mlayer "0_TEXT")                        ; �������w
  (setq #tlayer "0_TITLET")                      ; �^�C�g����w
  ;-----------------------------------------

  (CFOutStateLog 1 1 "�^�C�g���쐬")
  (SBMakeTitleText
    #tlayer CG_PackName CG_BukkenName CG_SeriesName CG_KoujiKind
    CG_BukkenNo CG_Zno CG_ModelName
  )

  (CFOutStateLog 1 51 "�d�l�\�쐬�̂��߂̃f�[�^�x�[�X�擾")
  ;;(setq #dbname (SBGetDbname))
  (setq #dbname CG_DBName)

  (CFOutStateLog 1 51 "�f�[�^�x�[�X���當���񃊃X�g�擾")
  (setq #str$ (SBGetDBList #dbname))

  (setq #title$ (car  #str$))                     ; �^�C�g��������
  (setq #value$ (cadr #str$))                     ; �d�l������

  (CFOutStateLog 1 51 "�d�l�\�̕������}")
  (setq #off$ (SBDrawTableText #title$ #value$))

  (CFOutStateLog 1 51 "�d�l�\�̌r��")
  (SBDrawTableLine #off$)

  (CFOutStateLog 1 41 "�p�[�W")
  (command "_.-LAYER" "T" "*" "ON" "*" "U" "*" "")
  (command  "_.PURGE" "A" "*" "N")
  (command  "_.PURGE" "A" "*" "N")
  (command  "_.PURGE" "A" "*" "N")

  (CFOutStateLog 1 51 "�}�ʔ͈�ZOOM")
  (command "_.ZOOM"   "A")

  (CFOutStateLog 1 1 "�}�ʕۑ�")
  (SBSaveas #savedir CG_BukkenNo CG_Zno)


  (princ) ; return
) ; SKFDrawPlanLayout

;<HOM>*************************************************************************
; <�֐���>    : SBDrawTableText
; <�����T�v>  : �d�l�\�̕������}
; <�߂�l>    : �������X�g
; <�쐬>      : 1998-11-10
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SBDrawTableText (
  &title$
  &value$
  /
  #title1 #title2 #value #ss #i #en #eg #1 #y2 #title110 #title111 #value10 #value11
  #dis #off #st #sv$ #10_n #11_n #subst #str #off$
  )
  (CFOutStateLog 1 51 "//// SKFDrawTableText ////")

  (setq
    #title1 "S^TITLE1"
    #title2 "S^TITLE2"
    #value  "S^VALUE"
  )
  (setq #ss (ssget "X" (list (cons 0 "TEXT")(cons 8 "0_TEXT")(cons 1 "S^*"))))
  (if (/= nil #ss)
    (progn

      ;�}�`�f�[�^�擾
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #eg (entget #en))
        (setq #1  (cdr (assoc 1 #eg)))
        (cond
          ((equal #title2   #1)  (setq #y2    (cadr (cdr (assoc 10 #eg)))))
          ((equal #title1   #1)
            (setq #title1      #eg)
            (setq #title110   (cdr (assoc 10 #eg)))
            (setq #title111   (cdr (assoc 11 #eg)))
          )
          ((equal #value #1)
            (setq #value    #eg)
            (setq #value10 (cdr (assoc 10 #eg)))
            (setq #value11 (cdr (assoc 11 #eg)))
          )
          (T                 nil)
        )
        (entdel #en)
        (setq #i (1+ #i))
      )
      ;y�������̋���
      (setq #dis (abs (- #y2 (cadr (cdr (assoc 10 #title1))))))
      (setq #off 0)
      ;��}
      (mapcar
       '(lambda ( #st #sv$ )

          (setq #10_n (list (car #title110) (- (cadr #title110) #off) (caddr #title110)))
          (setq #11_n (list (car #title111) (- (cadr #title111) #off) (caddr #title111)))
          (setq #subst (subst (cons 10 #10_n) (assoc 10 #title1) #title1))
          (setq #subst (subst (cons 11 #11_n) (assoc 11 #subst) #subst))
          (setq #subst (subst (cons 1  #st)  (assoc  1 #subst) #subst))
          (entmake (cdr #subst))

          (mapcar
           '(lambda ( #str )

              (setq #10_n (list (car #value10) (- (cadr #value10) #off) (caddr #value10)))
              (setq #11_n (list (car #value11) (- (cadr #value11) #off) (caddr #value11)))
              (setq #subst (subst (cons 10 #10_n) (assoc 10 #value) #value))
              (setq #subst (subst (cons 11 #11_n) (assoc 11 #subst) #subst))
              (setq #subst (subst (cons 1  #str)  (assoc  1 #subst) #subst))
              (entmake (cdr #subst))

              (setq #off (+ #dis #off))
            )
            #sv$
          )
          (setq #off$ (cons #off #off$))
        )
        &title$ &value$
      )
    )
    (progn
      (CFOutStateLog 0 51 "SAMPLE�����񂪂���܂���")
    )
  ) ; end if

  (reverse #off$)
) ; SKFDrawTableText

;<HOM>*************************************************************************
; <�֐���>    : SBDrawTableLine
; <�����T�v>  : �d�l�\�̌r����}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-11-10
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SBDrawTableLine (
  &off$     ; (REAL)     �������X�g
  /
  #ssv #ssh #eg #10 #11 #off #10_n #11_n #subst #y #i #en #dis10 #dis11 #pt
  )
  (CFOutStateLog 1 51 "//// SBDrawTableLine ////")
  (CFOutStateLog 1 51 "--------------------���� START-----------------")
  (CFOutStateLog 1 51 "�������X�g                            : ")(CFOutStateLog 1 51 &off$   )
  (CFOutStateLog 1 51 "--------------------���� END-------------------")

  (setq #ssv (ssget "X" (list (list -3 (list "G_VLINE")))))
  (setq #ssh (ssget "X" (list (list -3 (list "G_HLINE")))))
  (setq #eg (entget (ssname #ssh 0)))
  (setq #10 (cdr (assoc 10 #eg)))
  (setq #11 (cdr (assoc 11 #eg)))
  (mapcar
   '(lambda ( #off )
      (setq #10_n (list (car #10) (- (cadr #10) #off) (caddr #10)))
      (setq #11_n (list (car #11) (- (cadr #11) #off) (caddr #11)))
      (setq #subst (subst (cons 10 #10_n) (assoc 10 #eg) #eg))
      (setq #subst (subst (cons 11 #11_n) (assoc 11 #subst) #subst))
      (entmake (cdr #subst))
    )
    &off$
  )
  (setq #y (cadr #10_n))
  (setq #i 0)
  (repeat (sslength #ssv)
    (setq #en (ssname #ssv #i))
    (setq #eg (entget #en '("*")))
    (setq #10 (cdr (assoc 10 #eg)))
    (setq #11 (cdr (assoc 11 #eg)))
    (setq #dis10 (abs (- #y (cadr #10))))
    (setq #dis11 (abs (- #y (cadr #11))))
    (if (< #dis10 #dis11)
      (progn
        (setq #pt (list (car #10) #y (caddr #10)))
        (setq #subst (subst (cons 10 #pt) (cons 10 #10) #eg))
      )
      (progn
        (setq #pt (list (car #11) #y (caddr #11)))
        (setq #subst (subst (cons 11 #pt) (cons 11 #11) #eg))
      )
    )
    (entmod #subst)
    (setq #i (1+ #i))
  )

  (princ)
)


;<HOM>*************************************************************************
; <�֐���>    : SBGetDbname
; <�����T�v>  : �f�[�^�x�[�X���̎擾
; <�߂�l>    : �f�[�^�x�[�X����
; <�쐬>      : 1998-11-10
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SBGetDbname (
  /
  #cfg$ #series$ #i #dbname_d #flg #dbname #s
  )
  (setq #cfg$    (SBreadCSV (strcat CG_SBDATAPATH "Manage\\series.cfg")))
  (setq #series$ (mapcar 'caddr #cfg$))
  (setq #i 0)
  (repeat (length #series$)
    (if (= 'STR (type (nth #i #series$)))
      (if (wcmatch (nth #i #series$) (strcat "*" CG_SeriesCode "*"))
        (setq #dbname_d (nth 3 (nth #i #cfg$)))
      )
    )
    (setq #i (1+ #i))
  )
  (setq #i 1)
  (setq #flg T)
  (setq #dbname "")
  (repeat (strlen #dbname_d)
    (setq #s (substr #dbname_d #i 1))
    (if (/= nil #flg)
      (if (equal "." #s)
        (setq #flg nil)
        (setq #dbname (strcat #dbname #s))
      )
    )
    (setq #i (1+ #i))
  )

  #dbname
)

;<HOM>*************************************************************************
; <�֐���>    : SBGetDBList
; <�����T�v>  : �d�l�\�쐬�̂��߂̃��X�g�擾
; <�߂�l>    : �d�l�\���X�g
; <�쐬>      : 1998-11-10
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SBGetDBList (
  &dbname  ; (STR)  �f�[�^�x�[�X��
  /
  #session #sql$ #tname #title #dlen #and #i #key #val #str #str$ #str_n #sqlstr #sql2$
  #value$ #title$$ #value$$
	#msg
  )
  (setq #session (DBConnect &dbname "" ""))
  (setq #sql$ (DBSqlAutoQuery #session "select * from ���̒�` order by �L�q��"))
  (mapcar
   '(lambda ( #list$ )
      (setq #str$ nil)
      (setq #value$ nil)
      (setq #tname (CBCutSpc (nth 1 #list$)))  ; �e�[�u����
      (setq #title (CBCutSpc (nth 2 #list$)))  ; �\����
      (setq #dlen  (fix      (nth 3 #list$)))  ; ������

      ; ����������擾
      (setq #and "")
      (setq #i 4)
      (repeat #dlen
        (setq #key (CBCutSpc (nth #i #list$)))
        (if (= nil #key) (setq #key ""))
        (setq #val (SBGetKeyByAbbreviation #key))
        (if (= nil #val) (setq #val ""))
        (setq #str (strcat #and #key "=" "\'" #val "\'"))
        (setq #str$ (cons #str #str$))
        (setq #and " and ")
        (setq #i (1+ #i))
      )
      (setq #str_n (apply 'strcat (reverse #str$)))
      ; SQL���ɕҏW
      (setq #sqlstr (strcat "select * from " #tname " where " #str_n))
      ; �d�l�\�\�����X�g�擾
;;;      (setq #sql2$ (car (DBSqlAutoQuery #session #sqlstr))) ; 00/02/16 @YM@ �������� ADD
      (setq #sql2$ (DBSqlAutoQuery #session #sqlstr)) ; 00/02/16 @YM@ �������� ADD

      (if (/= nil #sql2$)
        (progn
					(CFOutStateLog 1 1 "*** �擾ں��� ***")
					(CFOutStateLog 1 1 #sql2$)

					(if (= (length #sql2$) 1) ; 00/02/16 @YM@ �������� ADD
						(progn
					  	(setq #sql2$ (car #sql2$))
						)
				    (progn ; ����˯Ă����Ƃ��ʹװ
							(setq #msg (strcat #sqlstr "�Ƀ��R�[�h����������܂���.\nSBGetDBList"))
				      (CFOutStateLog 0 1 #msg)
							(CFAlertMsg #msg)
				      (*error*)
				    )
					);_if                    ; 00/02/16 @YM@ �������� ADD

          (setq #i (1+ #dlen))
          (repeat (fix (nth #dlen #sql2$))
            (setq #value$ (cons (CBCutSpc (nth #i #sql2$)) #value$))
            (setq #i (1+ #i))
          )

          ; ���X�g�Ɋi�[
          (setq #title$$ (cons #title  #title$$))
          (setq #value$$ (cons (reverse #value$) #value$$))
        )
      ;else
        (progn
          ; ���X�g�Ɋi�[
          (setq #title$$ (cons #title  #title$$))
          (setq #value$$ (cons (list "") #value$$))
        )
      )
    )
    #sql$
  )

  (DBDisConnect #session)   ; �f�[�^�x�[�X�ڑ�����
  (list (reverse #title$$) (reverse #value$$))
)

;<HOM>*************************************************************************
; <�֐���>    : SBGetKeyByAbbreviation
; <�����T�v>  : ���̂���CG_FamilyInfo$$�̍��ڂ��������A�l���擾����
; <�߂�l>    : �l
; <�쐬>      : 1998-11-10
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SBGetKeyByAbbreviation (
  &keyname ; (STR)  ����
  /
  #cfgname #cfg$ #i #sno #val
  )
  (setq #i 0)
  (repeat (length CG_FamilyInfo$$)
    (if (= 'STR (type (last (nth #i CG_FamilyInfo$$))))
      (if (equal (last (nth #i CG_FamilyInfo$$)) &keyname)
        (setq #val (nth 1 (nth #i CG_FamilyInfo$$)))
      )
    )
    (setq #i (1+ #i))
  )
  #val
)

;<HOM>*************************************************************************
;
; <�֐���>    : CBCutSpc
;
; <�����T�v>  : ������̌��X�y�[�X���폜����
;
; <�߂�l>    :
;         STR : �폜��̕�����
;
; <�쐬>      : 97-09-13 �������L
;
; <���l>      : �Ȃ�
;
; <�O���ϐ�>  : �Ȃ�
;
; <�t�@�C��>  : �Ȃ�
;
;*************************************************************************>MOH<
(defun CBCutSpc (
  &str        ; (STR) ������
  /
  #str        ; (STR) �폜��̕�����
  #i          ; (INT) �J�E���^
  #wk         ; (STR) ���[�N����
  )

  (setq #i (strlen &str))               ; ������|�C���^
  (setq #str &str)                      ; ���ߒl

  (while (> #i 0)
    (setq #wk (substr #str #i 1))
    (cond
      ((= (ascii #wk) 32)               ; ���p�X�y�[�X
        (setq #str (substr #str 1 (1- #i)))
        (setq #i (1- #i))
      )
      ((= (ascii #wk) 64)               ; �S�p�X�y�[�X
        (if (= (ascii (substr #str (1- #i) 1)) -127)
          (progn
            (setq #str (substr #str 1 (- #i 2)))
            (setq #i (- #i 2))
          )
          (progn
            (setq #i 0)
          )
        )
      )
      (T
        (setq #i 0)
      )
    )
  )

  #str
)