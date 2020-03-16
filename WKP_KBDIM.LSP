;<HOM>*************************************************************************
; <�֐���>    : SBGetPEntity
; <�����T�v>  : �w�蕶���񐡖@�ʒu�o�}�`�擾
; <�߂�l>    : �o�}�`���X�g
;               �i
;                 �i
;                   �i�������� PT1 PT2�j            ����
;                   �i�������� PT1 PT2�j...
;                 �j
;                 �i
;                   �i�������� PT1 PT2�j            ����
;                   �i�������� PT1 PT2�j...
;                 �j
;               �j
; <���l>      : ����W�ɋ߂��ق���PT1�Ƃ���
; <�쐬>      : 1998-10-16
;*************************************************************************>MOH<
(defun SBGetPEntity (
  &layer   ; (STR)      ���ϐ}��w��
  &bpt     ; (LIST)     ����W
  /
  #ss #i #en #eg #eed$ #data$ #pt #lstx1$ #lstx2$ #lsty1$ #lsty2$ #lst1 #dd$
  #fpt #lpt #lstx_n$ #lsty_n$
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBGetPEntity ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "���ϐ}��w��                    : ")(CFOutStateLog 1 1 &layer  )
  (CFOutStateLog 1 1 "����W                        : ")(CFOutStateLog 1 1 &bpt    )
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  (CFOutStateLog 1 1 "�o�}�`�擾")
  (setq #ss (ssget "X" (list (cons 8 &layer)(list -3 (list "G_PTEN")))))

  (CFOutStateLog 1 1 "�e�f�[�^�l��")
  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)

        ; �}�`���擾
        (setq #en    (ssname #ss #i))
        ; �}�`�f�[�^�擾
        (setq #eg    (entget #en '("*")))
        ; �g���f�[�^�擾
        (setq #eed$  (cadr (assoc -3 #eg)))
        ; �����f�[�^�擾
        (setq #data$ (mapcar 'cdr (cdr #eed$)))

        ; �_�}�`�̍��W�擾
        (setq #pt  (cdr (assoc 10 #eg)))

        (if (= 11 (car #data$))                  ;�w�蕶�����@�ʒu
          (cond
            ((= 0 (nth 1 #data$))               ;����
              (if (assoc (nth 2 #data$) #lstx1$)
                (setq #lstx2$ (cons (list (nth 2 #data$) #pt) #lstx2$))
                (setq #lstx1$ (cons (list (nth 2 #data$) #pt) #lstx1$))
              )
            )
            ((= 1 (nth 1 #data$))               ;����
              (if (assoc (nth 2 #data$) #lsty1$)
                (setq #lsty2$ (cons (list (nth 2 #data$) #pt) #lsty2$))
                (setq #lsty1$ (cons (list (nth 2 #data$) #pt) #lsty1$))
              )
            )
          )
        )

        (setq #i (1+ #i))

      ) ; end repeat

      ;���X�g�ҏW
      ;����
      (mapcar
       '(lambda ( #lst1 )
          (setq #dd$ (assoc (car #lst1) #lstx2$))
          (if (/= nil #dd$)
            (progn
              (if (< (distance &bpt (cadr #lst1)) (distance &bpt (cadr #dd$)))
                (setq #fpt (cadr #lst1) #lpt (cadr  #dd$))
                (setq #fpt (cadr  #dd$) #lpt (cadr #lst1))
              )
              (setq #lstx_n$ (cons (list (car #lst1) #fpt #lpt) #lstx_n$))
            )
          )
        )
        #lstx1$
      )
      (mapcar
       '(lambda ( #lst1 )
          (setq #dd$ (assoc (car #lst1) #lsty2$))
          (if (/= nil #dd$)
            (progn
              (if (< (distance &bpt (cadr #lst1)) (distance &bpt (cadr #dd$)))
                (setq #fpt (cadr #lst1) #lpt (cadr  #dd$))
                (setq #fpt (cadr  #dd$) #lpt (cadr #lst1))
              )
              (setq #lsty_n$ (cons (list (car #lst1) #fpt #lpt) #lsty_n$))
            )
          )
        )
        #lsty1$
      )

    )
  ) ; end if

  (list #lstx_n$ #lsty_n$)
) ; SBGetPEntity


;<HOM>*************************************************************************
; <�֐���>    : SBDrawDImension
; <�����T�v>  : ���@����}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-10-16
;*************************************************************************>MOH<
(defun SBDrawDImension (
  &bpt     ; (LIST)     ����W
  &pdata$  ; (LIST)     P�_�f�[�^
  &offw    ; (REAL)     ���j�b�g�I�t�Z�b�g��W
  &offd    ; (REAL)     ���j�b�g�I�t�Z�b�g��D
  &thickw  ; (REAL)     �p�l������W
  &thickd  ; (REAL)     �p�l������D
  &baseoff ; (REAL)     ��I�t�Z�b�g��
  /
  #ss #pdata$ #offh$ #offv$ #i #en #eg #str$ #lsth$ #lstv$ #j #lsth #off #pdata #lstv
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawDImension ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "����W                        : ")(CFOutStateLog 1 1 &bpt    )
  (CFOutStateLog 1 1 "P�_�f�[�^                       : ")(CFOutStateLog 1 1 &pdata$ )
  (CFOutStateLog 1 1 "���j�b�g�I�t�Z�b�g��W           : ")(CFOutStateLog 1 1 &offw   )
  (CFOutStateLog 1 1 "���j�b�g�I�t�Z�b�g��D           : ")(CFOutStateLog 1 1 &offd   )
  (CFOutStateLog 1 1 "�p�l������W                     : ")(CFOutStateLog 1 1 &thickw )
  (CFOutStateLog 1 1 "�p�l������D                     : ")(CFOutStateLog 1 1 &thickd )
  (CFOutStateLog 1 1 "��I�t�Z�b�g��                : ")(CFOutStateLog 1 1 &baseoff)
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  (CFOutStateLog 1 1 "���@�}�`�擾")
  (setq #ss (ssget "X" (list (cons 0 "DIMENSION"))))

  (setq #pdata$ &pdata$)
;(dpr '&offw)
;(dpr '&thickw)

  (CFOutStateLog 1 1 "�e�f�[�^�l��")
  (if (/= nil #ss)
    (progn

      ; �I�t�Z�b�g�ʃ��X�g�쐬
      (if (equal CG_SIZECODE "1620")
        (setq #offh$ (list (+ &baseoff &offw &thickw) (+ &baseoff &offw)))   ; ����
        (setq #offh$ (list (+ &baseoff &thickw) &baseoff))                   ; ����
      )
      (setq #offv$ (list (+ &offd &thickd) &offd))                           ; ����

      ; ���@������擾
      (setq #i 0)
      (repeat (sslength #ss)

        ; �}�`���擾
        (setq #en    (ssname #ss #i))
        ; �}�`�f�[�^�擾
        (setq #eg    (entget #en '("*")))
        ; ���@������f�[�^�擾
        (setq #str$  (SBGetDataByDimBlock &bpt #en))
        ; ���X�g�Ɋi�[
        (if (= "H" (car #str$))
          (setq #lsth$ (cons (cdr #str$) #lsth$))
          (setq #lstv$ (cons (cdr #str$) #lstv$))
        )

        (setq #i (1+ #i))
      ) ; end repeat

      (setq #lsth$ (SBmg_sort$ 'cadadr #lsth$))
      (setq #lstv$ (SBmg_sort$ 'caadr  #lstv$))

      ;�������@��}
      (setq #i 0)
      (setq #j 0)
      (repeat (length #lsth$)
        (setq #lsth (nth #i #lsth$))
        (setq #off  (nth #j #offh$))
        (mapcar
         '(lambda ( #pdata )
            (if (wcmatch (car #lsth) (strcat "*" (car #pdata) "*"))
              (progn
                (SBDrawDim (nth 1 #lsth) (nth 1 #pdata) (nth 2 #pdata) (nth 2 #lsth) #off "H")
                (setq #j (1+ #j))
              )
            )
          )
          (car &pdata$)
        )
        (setq #i (1+ #i))
      )

      ;�������@��}
      (setq #i 0)
      (setq #j 0)
      (repeat (length #lstv$)
        (setq #lstv (nth #i #lstv$))
        (setq #off  (nth #j #offv$))
        (mapcar
         '(lambda ( #pdata )
            (if (wcmatch (car #lstv) (strcat "*" (car #pdata) "*"))
              (progn
                (SBDrawDim (nth 1 #lstv) (nth 1 #pdata) (nth 2 #pdata) (nth 2 #lstv) #off "V")
                (setq #j (1+ #j))
              )
            )
          )
          (cadr &pdata$)
        )
        (setq #i (1+ #i))
      )
    )
  ) ; end if

  ; (princ)
) ; SBDrawDImension
;<HOM>*************************************************************************
; <�֐���>    : SBGetDataByDimBlock
; <�����T�v>  : ���@���̕�����}�`�iMTEXT�j�̕�������擾����
; <�߂�l>    : �l���X�g�i���������t���O�A������A�}����_�A���@�}�`���j
; <�쐬>      : 1998-10-16
;*************************************************************************>MOH<
(defun SBGetDataByDimBlock (
  &bpt     ; (LIST)     ����W
  &en      ; (ENAME)    ���@�}�`��
  /
  #eg #13 #14 #50 #flg #pt #2 #deg #en #str
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBGetDataByDimBlock ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "����W                        : ")(CFOutStateLog 1 1 &bpt    )
  (CFOutStateLog 1 1 "���@�}�`��                      : ")(CFOutStateLog 1 1 &en     )
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  ;�}�`�f�[�^�擾
  (setq #eg (entget &en))
  (setq #13 (cdr (assoc 13 #eg)))
  (setq #14 (cdr (assoc 14 #eg)))
  (setq #50 (cdr (assoc 50 #eg)))

  ;���������t���O�擾
  (if (equal 0.0 #50 0.0001)
    (setq #flg "H")
    (setq #flg "V")
  )

  ;����W�ɋ߂����@��`���W���擾
  (if (< (distance &bpt #13)(distance &bpt #14))
    (setq #pt #13)
    (setq #pt #14)
  ) ; end if

  ;���@������擾
  (setq #2  (cdr (assoc 2 #eg)))
  (setq #deg (entget (tblobjname "BLOCK" #2)))
  (setq #en (cdr (assoc -2 #deg)))
  (while (/= nil #en)

    (setq #deg (entget #en))
    (if (equal "MTEXT" (cdr (assoc 0 #deg)))

      (setq #str  (cdr (assoc 1 #deg)))           ;���@������

    ) ; end if
    (setq #en (entnext #en))

  ) ; end while

  (list #flg #str #pt &en) ; return
) ; SBGetDataByDimBlock

;<HOM>*************************************************************************
; <�֐���>    : SBDrawDim
; <�����T�v>  : ���W���X�g�Ɗ�_���W�Ɛ��@�ʒu���W���琡�@������}����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-10-16
; <�C��>      : 1999-02-15 �i�I�t�Z�b�g�ɉ����Đ��@�����ړ�����̂���߂�j
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SBDrawDim (
  &bpt     ; (LIST)     ��_���W
  &pt1     ; (LIST)     P�_���W�P�i��_�ɋ߂��ق��j
  &pt2     ; (LIST)     P�_���W�Q
  &en      ; (LIST)     ����@���}�`��
  &off     ; (REAL)     �߂��ق�����̃I�t�Z�b�g��
  &flg     ; (STR)      ���������t���O
  /
  #layer #osmode #dimse1 #dimse2 #clayer #off #ang #dis #pt1n #eg #10 #13 #14 #pt2n
  #dm
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBDrawDim ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "����W                        : ")(CFOutStateLog 1 1 &bpt    )
  (CFOutStateLog 1 1 "P�_���W�P                       : ")(CFOutStateLog 1 1 &pt1    )
  (CFOutStateLog 1 1 "P�_���W�Q                       : ")(CFOutStateLog 1 1 &pt2    )
  (CFOutStateLog 1 1 "����@���}�`��                : ")(CFOutStateLog 1 1 &en     )
  (CFOutStateLog 1 1 "�߂��ق�����̃I�t�Z�b�g��      : ")(CFOutStateLog 1 1 &off    )
  (CFOutStateLog 1 1 "���������t���O                  : ")(CFOutStateLog 1 1 &flg    )
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  ;��w�ݒ�
  (setq #layer (cdr (assoc 8 (entget &en))))
  ;�V�X�e���ϐ��i�[
  (setq #osmode (getvar "OSMODE"))
  (setq #dimse1 (getvar "DIMSE1"))
  (setq #dimse2 (getvar "DIMSE2"))
  (setq #clayer (getvar "CLAYER"))
  ;�V�X�e���ϐ��ݒ�
  (setvar "OSMODE" 0)
;  (setvar "DIMSE1" 1)
;  (setvar "DIMSE2" 1)
  (setvar "CLAYER" #layer)

  (setq #eg (entget &en '("*")))
  (setq #10 (cdr (assoc 10 #eg)))
  (setq #13 (cdr (assoc 13 #eg)))
  (setq #14 (cdr (assoc 14 #eg)))

  (if (/= nil &off)
    (setq #off &off)
    (setq #off 0.0)
  )

  (if (> (distance #13 &pt1) (distance #14 &pt1))
    (progn
      (setq #dm #13)
      (setq #13 #14)
      (setq #14 #dm)
    )
  )

  ;---Modify S.Kawamoto Start
  (setq #ang  (angle &pt1 #13))
  (if (= &flg "H")
    (if (< (* PI 0.5) #ang (* PI 1.5))
      (setq #ang 0.0)
      (setq #ang PI)
    )
    (if (< 0.0 #ang PI)
      (setq #ang (* PI 0.5))
      (setq #ang (* PI 1.5))
    )
  )
  ;---Modify S.Kawamoto End
;  (if (= nil (equal #dis #off))
;    (progn
;      (CFOutStateLog 1 1 "�}�`�ړ�")
;      (command "_.MOVE" &en "" &bpt #pt1n)
;    )
;  )

  (command "_dimlinear" #13 &pt1 &flg #10)
  (command "_dimlinear" #14 &pt2 &flg #10)

  ;�V�X�e���ϐ��߂�
  (setvar "OSMODE" #osmode)
;  (setvar "DIMSE1" #dimse1)
;  (setvar "DIMSE2" #dimse2)
  (setvar "CLAYER" #clayer)

  (princ) ; return
) ; SBDrawDim


;<HOM>************************************************************************
;
; <�֐���>    : SBmg_sort$
;
; <�����T�v>  : �����t�����X�g�̃��X�g�̃}�[�W�\�[�g���s��
;
; <�߂�l>    : �\�[�g���ꂽ���X�g
;
;
; <�쐬>      : 96-11-01 ���� ��
;
; <���l>      : (SKFmg_sort$ 'cadr '((6 5 4 3)(8 7 1 2)(1 2 3 4)(2 3 4 5)))
;
;************************************************************************>MOH<
(defun SBmg_sort$(
    &func ; ��r�֐�
    &L1$  ;�\�[�g���s�����X�g
    /
    #i1 #Ltmp$ #L2$ #flg #itmp #ret$ #ret #ret$$
    )

  (if (and(= 'LIST(type &L1$))(/= 0 (length &L1$)))
    (progn
      (setq #i1 1)                                  ;#i1     &L1$$����
      (setq #Ltmp$ '())                             ;#Ltmp$ �ꎞ��r�pؽ�
      (setq #L2$   '())                             ;#Ltmp$   �ꎞ��r�p����
      (setq #Ltmp$ (cons (nth 0 &L1$) #Ltmp$))      ;#L2$   ����ؽ�(�Ԓl)
      (setq #L2$   #Ltmp$)                          ;#flg    �}���O nil  �}���� T
      (while (< #i1 (length  &L1$))
        (setq #Ltmp$ (reverse #L2$))
        (setq #L2$ '())
        (setq #itmp  0)
        (setq #flg nil)
        (while (< #itmp (length #Ltmp$))
          (cond
            ((> (apply &func (list(nth #i1   &L1$  )))                     ;��r�l��菬
                (apply &func (list(nth #itmp #Ltmp$)))
             )
              (setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
            )
            ((and (= #flg nil)
                  (<= (apply &func (list(nth #i1 &L1$)))                   ;��r�l����
                      (apply &func (list(nth #itmp #Ltmp$)))
                  )
             )
              (setq #L2$ (cons (nth #i1   &L1$  ) #L2$))
              (setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
              (setq #flg T)
            )
            (T                                                        ;�����
              (setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
            )
          )
          (setq #itmp (1+ #itmp))
        )
        (if (= #flg nil)                                              ;��r�l���ő�
          (setq #L2$ (cons (nth #i1   &L1$  ) #L2$))
        )
        (setq #i1 (1+ #i1))
      )
      (setq #ret$ (reverse #L2$))
    )
  )
  (mapcar
   '(lambda ( #ret )
      (if (/= nil #ret)
        (setq #ret$$ (cons #ret #ret$$))
      )
    )
    #ret$
  )
  (reverse #ret$$)
) ; SBmg_sort$

;<HOM>*************************************************************************
; <�֐���>    : SBModDimensionSketch
; <�����T�v>  : ���r���ݔ��}�̐��@���̕�����ɃI�t�Z�b�g�ʂ𑫂�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-11-05
; <�C��>      : 1999-03-01
;*************************************************************************>MOH<
(defun SBModDimensionSketch (
  &offw    ; (REAL)     ���j�b�g�I�t�Z�b�g��W
  &baseoff ; (REAL)     ��I�t�Z�b�g��
  /
  #ss #i #en #eg #len #str #subst #off
  )
  (CFOutStateLog 1 2 "//// SBModDimensionSketch ////")
  (CFOutStateLog 1 2 "--------------------���� START-----------------")
  (CFOutStateLog 1 2 "���j�b�g�I�t�Z�b�g��W           : ")(CFOutStateLog 1 2 &offw   )
  (CFOutStateLog 1 2 "��I�t�Z�b�g��                : ")(CFOutStateLog 1 2 &baseoff)
  (CFOutStateLog 1 2 "--------------------���� END-------------------")
;(dpr '&offw)
  (CFOutStateLog 1 2 "���@�}�`�擾")
  (setq #ss (ssget "X" (list (cons 1 "*`#*")(cons 0 "DIMENSION"))))

  ;-----------�C�� �X�{------------
  (if (equal CG_SIZECODE "1620")
    (setq #off (+ &offw &baseoff))
    (setq #off &baseoff)
  )

  (CFOutStateLog 1 2 "�e�f�[�^�l��")
  (if (/= nil #ss)
    (progn

      (setq #i 0)
      (repeat (sslength #ss)

        ; �}�`���擾
        (setq #en    (ssname #ss #i))
        ; �}�`�f�[�^�擾
        (setq #eg    (entget #en '("*")))
        ; ���@�������擾
        (setq #len (SBDIM_LEN #en))
        ; ���@�l�ҏW
        (setq #str (rtos (+ #len #off)))
        ; ���@���ҏW
        (setq #subst (subst (cons 1 #str) (assoc 1 #eg) #eg))
        (entmod #subst)
        (entupd #en)

        (setq #i (1+ #i))
      )

    )
  ) ; end if

  (princ)
)

;********************************************************
;  SBDIM_LEN
;
;  ���@�}�`�̐��@�l���擾����
;
;  ���� &en ���@�}�`�̴�èè��
;
;  �Ԓl ���m�Ȑ��@�l(�ُ�̏ꍇ��0.0��Ԃ�)
;********************************************************
(defun SBdim_len(
    &en
    /
    #0 #10 #13 #14 #15 #16 #50 #64 #70 #70flg #ang #ang10 #ang13 #ang14 #ang16
    #eg #int #int14 #len #vec10 #vec14 #vec15 #vec16
    )

  ;--------------------------------------------------------
  (defun pt1jiHenkan(
      &ptOp ; �ϊ�������W(0 0)�x�[�X
      &ang  ; �p�x
      )

    (list
      (-(* (car  &ptOp)(cos &ang))(* (cadr &ptOp)(sin &ang)))
      (+(* (car  &ptOp)(sin &ang))(* (cadr &ptOp)(cos &ang)))
      0.
    )
  )
  ;--------------------------------------------------------
  (setq #len 0.0)
  (setq #eg  (entget &en       ))
  (setq #0   (cdr(assoc  0 #eg)))
  (if(= "DIMENSION" #0)
    (progn
      (setq #70    (assoc 70 #eg) )
      (if(/= nil #70)
        (progn
          (setq #70(cdr      #70     ))
          (setq #70flg (boole 1 #70 7))  ;0�`6
        )
        (progn
          (setq #70    0)
          (setq #70flg 0)
        )
      )
      (cond
        ((= 0 #70flg)
          (setq #50(cdr(assoc 50 #eg)))
          (setq #13(cdr(assoc 13 #eg)))
          (setq #14(cdr(assoc 14 #eg)))
          (cond
            ((equal 0.0       #50 0.0001)          ;����
              (setq #len (abs(- (car  #13)(car  #14))))
            )
            ((equal (/ PI 2.) #50 0.0001)          ;����
              (setq #len (abs(- (cadr #13)(cadr #14))))
            )
            (T                                     ;�p�x
              (setq #int14 (inters #13 (polar #13 #50 1) #14 (polar #14 (+ #50 (* 0.5 PI)) 1) nil))
              (setq #len   (distance #13 #int14))
            )
          )
        )
    ((= 1 #70flg)                              ;���s
          (setq #13  (cdr(assoc 13 #eg)))
          (setq #14  (cdr(assoc 14 #eg)))
          (setq #len (distance #13 #14))
        )
    ((= 2 #70flg)                              ;�p�x
          (setq #10  (cdr(assoc 10 #eg)))
          (setq #13  (cdr(assoc 13 #eg)))
          (setq #14  (cdr(assoc 14 #eg)))
          (setq #15  (cdr(assoc 15 #eg)))
          (setq #16  (cdr(assoc 16 #eg)))
          (setq #ang14 (angle #14 #13))
          (setq #vec15 (mapcar '- #15 #10))
          (setq #int   (inters #10 #15 #13 #14 nil))
          (setq #vec16 (mapcar '- #16 #int))
          (setq #ang   (angle '(0 0 0) (pt1jiHenkan #vec15 (* -1 #ang14))))
          (setq #ang16 (angle '(0 0 0) (pt1jiHenkan #vec16 (* -1 #ang14))))
          (setq #ang16 (rem #ang16 PI))
          (if(> #ang16 #ang)
            (setq #ang (- PI #ang))
          )
          (setq #len   (* 180 (/ #ang PI)))
        )
    ((= 3 #70flg)                              ;���a
          (setq #10  (cdr(assoc 10 #eg)))
          (setq #15  (cdr(assoc 15 #eg)))
          (setq #len (distance #10 #15))
        )
    ((= 4 #70flg)                              ;���a
          (setq #10  (cdr(assoc 10 #eg)))
          (setq #15  (cdr(assoc 15 #eg)))
          (setq #len (distance #10 #15))
        )
    ((= 5 #70flg)                              ;�p�x�R�_
          (setq #10  (cdr(assoc 10 #eg)))
          (setq #13  (cdr(assoc 13 #eg)))
          (setq #14  (cdr(assoc 14 #eg)))
          (setq #15  (cdr(assoc 15 #eg)))
          (setq #ang13 (angle #15 #13))
          (setq #vec14 (mapcar '- #14 #15))
          (setq #vec10 (mapcar '- #10 #15))
          (setq #ang   (angle '(0 0 0) (pt1jiHenkan #vec14 (* -1 #ang13))))
          (setq #ang10 (angle '(0 0 0) (pt1jiHenkan #vec10 (* -1 #ang13))))
          (if(or(< #ang10 0.0)(> #ang10 #ang))
            (setq #ang (- (* 2 PI) #ang))
          )
          (setq #len   (* 180 (/ #ang PI)))
        )
    ((= 6 #70flg)                              ;���W���@
      (setq #64  (boole 1 #70 64))
          (setq #10  (cdr(assoc 10 #eg)))
          (setq #13  (cdr(assoc 13 #eg)))
          (if(= 0 #64)
            (setq #len (-(cadr #13)(cadr #10)))
            (setq #len (-(car  #13)(car  #10)))
          )
        )
        (T
          (setq #len 0.0)
        )
      )
    )
  )
  #len
)