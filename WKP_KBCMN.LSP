;<HOM>*************************************************************************
; <�֐���>    : SBModCfgFile
; <�����T�v>  : CFG�t�@�C���̓��e�����X�g�Ɋi�[���A90�Ԃŕ�����
; <�߂�l>    : CFG���X�g
;               ---CFG�t�@�C��---           ---���X�g---
;
;               01,��̕�             (
;               02,����                 (("01" "��̕�")("02" "����")("03" "�ڒn��(��+��)"))
;               03,�ڒn��(��+��)   ��   (("90" "�B���ڍא}")("91" "�h�A�p�}"))
;               90,�B���ڍא}         )
;               91,�h�A�p�}
;
; <�쐬>      : 1998-10-30
;*************************************************************************>MOH<
(defun SBModCfgFile (
  &cfgname ; (STR)      CFG�t�@�C����
  &90      ; (INT)      ��؂鐔�l
  /
  ;@@@#data$ #dt #no #nai$ #equ$ #DT #EQU$ #NAI$ #NO ;00/01/30 HN MOD �d���ϐ��錾���C��
  #data$ #dt #no #nai$ #equ$
  )
  (CFOutStateLog 1 0 "//// SBModCfgFile ////")
  (CFOutStateLog 1 0 "--------------------���� START-----------------")
  (CFOutStateLog 1 0 "CFG�t�@�C����                   : ")(CFOutStateLog 1 0 &cfgname)
  (CFOutStateLog 1 0 "��؂鐔�l                      : ")(CFOutStateLog 1 0 &90     )
  (CFOutStateLog 1 0 "--------------------���� END-------------------")

  ; �}�`���ޒ�`�f�[�^�擾
  (setq #data$ (SBreadCSV &cfgname))

  (mapcar
   '(lambda ( #dt )

      (setq #no (atoi (car #dt)))
      (if (< #no &90)
        (setq #nai$ (cons #dt #nai$))
        (setq #equ$ (cons #dt #equ$))
      ) ; end if

    )
    #data$
  ) ; end mapcar

  (list #nai$ #equ$) ; return
) ; SBModCfgFile

;***********************************************************************
;  SBreadCSV
;
;  �b�r�u�t�@�C���̓ǂݍ���
;
;1,�d�C,�A���[�d�q,�\����,�V�O�i���^���[,ETTW-100-3DK
;2,�d�C,�a��d�C,�\����,�p�C���b�g�����v,"APN""126""DN 20V"
;3,�d�C,�m�h�r�r,����,"PU(��3,200V,1/120)",G3LE28L120020
;
;(("1" "�d�C" "�A���[�d�q" "�\����" "�V�O�i���^���["     "ETTW-100-3DK"  )
; ("2" "�d�C" "�a��d�C"   "�\����" "�p�C���b�g�����v"   "APN"126"DN 20V")
; ("3" "�d�C" "�m�h�r�r"   "����"   "PU(��3,200V,1/120)" "G3LE28L120020" ))
;
;***********************************************************************
(defun SBreadCSV (
    &fName
    /
    #fp #csv #lst #str #dblQuo #c #i #buf
    )
  (setq #fp  (open &fName "r"))
  (if (/= nil #fp)
    (progn
      (setq #csv nil)
      (setq #buf T)
      (while(/= nil #buf)
        (setq #buf (read-line #fp))
        (if(/= nil #buf)
          (progn
            (setq #lst nil)
            (setq #str "")
            (setq #dblQuo nil)
            (setq #i 1)
            (repeat (strlen #buf)
              (setq #c (substr #buf #i 1))
              (cond
                ((and(=  nil #dblQuo)(=  "," #c))
                  (setq #lst (cons #str #lst))
                  (setq #str "")
                )
                ((and(=  nil #dblQuo)(=  "\"" #c))
                  (setq #dblQuo T)
                )
                ((and(= T    #dblQuo)(=  "\"" #c))
                  (if(and(< #i (strlen #buf))(= "\"" (substr #buf (1+ #i) 1)))
                    (progn
                      (setq #str (strcat #str "\""))
                      (setq #i (1+ #i))
                    )
                    (progn
                      (setq #lst (cons #str #lst))
                      (setq #dblQuo nil)
                      (setq #str "")
                      (setq #i (1+ #i))
                    )
                  )
                )
                (T
                  (setq #str (strcat #str #c))
                )
              )
              (setq #i (1+ #i))
            )
            (setq #lst (cons #str #lst))
            (setq #csv (cons (reverse #lst) #csv))
          )
        )
      )
      (setq #csv (reverse #csv))
      (close #fp)
    )
  )
  #csv
)

;<HOM>*************************************************************************
; <�֐���>    : SBMakeTitleText
; <�����T�v>  : �}�ʘg�̃^�C�g������}����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-06-19
; <���l>      : ��w�� "0_TITLET" �Ƃ���
;               �^�C�g�������͊��ɍ�}����Ă�����̂Ƃ���B
;*************************************************************************>MOH<
(defun SBMakeTitleText (
  &tlayer  ; (STR)      �^�C�g��������w
  &fcode   ; (STR)      �p�b�P�[�W�ԍ�
  &bukken  ; (STR)      ��������
  &series  ; (STR)      SERIES
  &kname   ; (STR)      �H�����
  &bcode   ; (STR)      �����ԍ�
  &zno     ; (STR)      �}�ʒʂ��ԍ�
  &form    ; (STR)      �^��
  /
  #title$ #title$$ #sstit #i #en #eg #str #str_n #subst #ken
  )
  (CFOutStateLog 1 40 "//// SKFMakeTitleText ////")
  (CFOutStateLog 1 40 "--------------------���� START-----------------")
  (CFOutStateLog 1 40 "�^�C�g��������w                : ")(CFOutStateLog 1 40 &tlayer )
  (CFOutStateLog 1 40 "�p�b�P�[�W�ԍ�                  : ")(CFOutStateLog 1 40 &fcode  )
  (CFOutStateLog 1 40 "��������                        : ")(CFOutStateLog 1 40 &bukken )
  (CFOutStateLog 1 40 "SERIES                        : ")(CFOutStateLog 1 40 &series )
  (CFOutStateLog 1 40 "�H�����                        : ")(CFOutStateLog 1 40 &kname  )
  (CFOutStateLog 1 40 "�����ԍ�                        : ")(CFOutStateLog 1 40 &bcode  )
  (CFOutStateLog 1 40 "�}�ʒʂ��ԍ�                    : ")(CFOutStateLog 1 40 &zno    )
  (CFOutStateLog 1 40 "�^��                            : ")(CFOutStateLog 1 40 &form   )
  (CFOutStateLog 1 40 "--------------------���� END-------------------")
  (CFOutLog 1 nil (strcat ""))
  (CFOutLog 1 nil (strcat "���ق��o�͂��܂�"))
  (CFOutLog 1 nil (strcat "  +�^�C�g��������w: " &tlayer ))
  (CFOutLog 1 nil (strcat "  +�p�b�P�[�W�ԍ�  : " &fcode  ))
  (CFOutLog 1 nil (strcat "  +��������        : " &bukken ))
  (CFOutLog 1 nil (strcat "  +SERIES        : " &series ))
  (CFOutLog 1 nil (strcat "  +�H�����        : " &kname  ))
  (CFOutLog 1 nil (strcat "  +�����ԍ�        : " &bcode  ))
  (CFOutLog 1 nil (strcat "  +�}�ʒʂ��ԍ�    : " &zno    ))
  (CFOutLog 1 nil (strcat "  +�^��            : " &form   ))
  ;�^�C�g������
  (if
    (and
      (not (equal "" &bcode))(= 'STR (type &bcode))
      (not (equal "" &zno))  (= 'STR (type &zno))
    )
    (setq #title$
      (list &bukken &kname &fcode &series (strcat &bcode &zno) &form
            (menucmd "M=$(edtime,$(getvar,date),YYYY.MO.DD)")
      )
    )
    (progn

      (setq #title$
        (list &bukken &kname &fcode &series (strcat &bcode &zno) &form
              (menucmd "M=$(edtime,$(getvar,date),YYYY.MO.DD)")
        )
      )
      (CFOutStateLog 2 40 "�}��:�����ȃf�[�^ = ")
      (CFOutStateLog 2 40 "�����ԍ�     : &bcode  = ")(CFOutStateLog 2 40 &bcode)
      (CFOutStateLog 2 40 "�}�ʒʂ��ԍ� : &zno  = ")  (CFOutStateLog 2 40 &zno)

    )
  ) ; end if

  (setq #title$$
    (list
      (list "T^��������"       (nth 0 #title$))
      (list "T^�H�����"       (nth 1 #title$))
      (list "T^�p�b�P�[�W�ԍ�" (nth 2 #title$))
      (list "T^SERIES"       (nth 3 #title$))
      (list "T^�}��"           (nth 4 #title$))
      (list "T^�^��"           (nth 5 #title$))
      (list "T^�쐬��"         (nth 6 #title$))
    )
  )
  ;-----------------------------------------
  ;�^�C�g�������擾
  (setq #sstit (ssget "X" (list (cons 8 &tlayer))))
  ;�����쐬
  (if (/= nil #sstit)
    (progn

      (setq #i 0)
      (repeat (sslength #sstit)

        (setq #en    (ssname #sstit #i))
        (setq #eg    (entget #en))
        (setq #str   (assoc 1 #eg))
        (setq #ken (assoc (cdr #str) #title$$))
        (if (/= nil #ken)
          (progn
            (setq #str_n (cadr #ken))
            (if (and (/= "" #str_n) (/= nil #str_n) (= 'str (type #str_n)))
              (progn

                (setq #subst (subst (cons 1 #str_n) #str #eg))
                (entmod #subst)

              )
              (progn

                (setq #subst (subst (cons 1 "") #str #eg))
                (entmod #subst)
                (CFOutStateLog 2 40 "�^�C�g��:�����ȃf�[�^ = ")
                (CFOutStateLog 2 40 #str_n)
              )
            ) ; end if

          )
        ) ; end if

        (setq #i (1+ #i))
      ) ; end repeat

    )
  ) ; end if

  (princ) ; return
) ; SKFMakeTitleText

;<HOM>*************************************************************************
; <�֐���>    : SBModPmenByRegion
; <�����T�v>  : �B���̈�����[�W����������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-06-18
;*************************************************************************>MOH<
(defun SBModPmenByRegion (
  /
  ;@@@##ModRegion #ss #i #en #eed$ #EN ;00/01/30 HN MOD �d���ϐ��錾���C��
  ##ModRegion #ss #i #en #eed$
  )
  (CFOutStateLog 1 40 "//// SBModPmenByRegion ////")

  ;�}�`�����o��
  ;   +==================================================================+
  ;   |   �}�`�������o������ƕʐ}�`�ɂȂ�̂ŉ�w�A�F�A���킪���ꂼ��   |
  ;   |   "0","BYLAYER","BYLAYER"�ɕς���Ă��܂�                        |
  ;   |   ���̂��ߌ��̑����ɍĐݒ肵�Ă��Ȃ��Ă͂����Ȃ�               |
  ;   +==================================================================+
  (defun ##ModRegion (
    &en   ; (ENAME) ���[�W�������}�`��
    /
    ;@@@#eg #8 #6 #62 #exen #exeg #subst #en
    #eg #8 #6 #62 #exen #exeg #subst ;00/01/30 HN MOD �d���ϐ��錾���C��
    )
    (CFOutStateLog 1 0 "�}�`�g���f�[�^ = ")
    (setq #eg (entget #en '("*")))
    (CFOutStateLog 1 0 (last #eg))
    (setq #8  (cdr (assoc 8  #eg)))
    (setq #6  (cdr (assoc 6  #eg)))
    (setq #62 (cdr (assoc 62 #eg)))
    (if (= nil #62)
      (setq #62 256)
    ) ; end if
    ;���[�W������
    (command "_.region" &en "")
    (setq #exen (entlast))
    (setq #exeg (entget #exen))

    ;��w�ύX
    (setq #subst (subst (cons 8 #8)(assoc 8 #exeg)#exeg))

    ;����ύX
    (if (/= nil #6)
      (if (assoc 6 #exeg)
        (setq #subst (subst (cons 6 #6)(assoc 6 #subst)#subst))
        (setq #subst (append #subst (list (cons 6 #6))))
      ) ; end if
    ) ; end if

    ;�F�ύX
    (if (assoc 62 #exeg)
      (setq #subst (subst (cons 62 #62)(assoc 62 #subst)#subst))
      (setq #subst (append #subst (list (cons 62 #62))))
    ) ; end if

    (entmod #subst) ; return

  ) ; end defun

  (setq #ss (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_PMEN")))))
  (if (/= nil #ss)
    (progn

      (setq #i 0)
      (repeat (sslength #ss)

        (setq #en (ssname #ss #i))
        (setq #eed$ (cadr (assoc -3 (entget #en '("G_PMEN")))))

        (if (and (/= nil #eed$) (listp #eed$))
          (if (= 1 (cdr (nth 1 #eed$)))
            (##ModRegion #en)
          )
        )

        (setq #i (1+ #i))

      ) ; end repeat

    )
  ) ; end if

  (princ) ; return
) ; SBModPmenByRegion


;<HOM>*************************************************************************
; <�֐���>    : SBSaveas
; <�����T�v>  : �����ԍ��{�ʔԖ��Ő}�ʂ�ۑ�����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-07-14
;*************************************************************************>MOH<
(defun SBSaveas (
  &dir     ; (STR)      �ۑ���̃f�B���N�g��
  &bcode   ; (STR)      �����ԍ�
  &zcode   ; (STR)      �ʔ�
  /
  #fname
  )
  (CFOutStateLog 1 40 "//// SBSaveas ////")
  (CFOutStateLog 1 40 "--------------------���� START-----------------")
  (CFOutStateLog 1 40 "�ۑ���̃f�B���N�g��            : ")(CFOutStateLog 1 40 &dir    )
  (CFOutStateLog 1 40 "�����ԍ�                        : ")(CFOutStateLog 1 40 &bcode  )
  (CFOutStateLog 1 40 "�ʔ�                            : ")(CFOutStateLog 1 40 &zcode  )
  (CFOutStateLog 1 40 "--------------------���� END-------------------")

  (if (= nil (dos_mkdir &dir))
    (if
      (and
        (/= nil &bcode) (not (equal "" &bcode)) (= 'STR (type &bcode))
        (/= nil &zcode) (not (equal "" &zcode)) (= 'STR (type &zcode))
      )
      (progn
        (CFOutStateLog 1 40  (strcat "�}�ʖ�  : " &bcode CG_Hinmoku CG_INCNO &zcode))
        (if (= CG_OUTPUTTYPE "DWG")
          (progn
            (setq #fname (strcat &dir &bcode CG_Hinmoku CG_INCNO &zcode ".dwg"))
            (if (findfile #fname)
              (CFOutStateLog 2 40 "̧�ي��� -> �㏑��")
            )
            (command "_saveas" "" #fname) ;00/02/17 HN MOD R14��2000
          )
          (progn
            ;(setq #fname (strcat &dir &bcode CG_Hinmoku CG_INCNO &zcode ".tif"))
            (setq #fname (strcat &dir &bcode CG_Hinmoku CG_INCNO &zcode))
            ;// TIFF �t�@�C���ɏo�͂���
            ;(if (findfile #fname)
            ;  (command "_plot" "L" 0 "N" #fname "Y")
              (command "_plot" "L" 0 "N" #fname)
            ;)
          )
        )
      )
      (progn

        (CFOutStateLog 0 40  "�}�ʖ�:�������ް� = ")
        (CFOutStateLog 0 40  &bcode)
        (CFOutStateLog 0 40  &zcode)

      )
    ) ; end if
    (progn

      (CFOutStateLog 0 40  "�}�ʕۑ��f�B���N�g��:�����ȃf�[�^ = ")
      (CFOutStateLog 0 40  &dir)
      (dos_rmdir &dir)

    )
  ) ; end if

  (princ) ; return
) ; SBSaveas

;<HOM>*************************************************************************
; <�֐���>    : SBGetDataByBlock
; <�����T�v>  : �u���b�N�ō\�������}�`���擾����
; <�߂�l>    : �}�`�����X�g
; <�쐬>      : 1998-09-10
;*************************************************************************>MOH<
(defun SBGetDataByBlock (
  &en      ; (ENAME)    INSERT�}�ʖ�
  /
  #eg #2 #deg #en #en$
  )
  (CFOutStateLog 1 41 "//// SBGetDataByBlock ////")
  (CFOutStateLog 1 41 "--------------------���� START-----------------")
  (CFOutStateLog 1 41 "INSERT�}�ʖ�                    : ")(CFOutStateLog 1 41 &en     )
  (CFOutStateLog 1 41 "--------------------���� END-------------------")

  (CFOutStateLog 1 41 "INSETRT�}�`�f�[�^�擾")
  (setq #eg (entget &en))

  (CFOutStateLog 1 41 "BLOCK���擾")
  (setq #2  (cdr (assoc 2 #eg)))

  (CFOutStateLog 1 41 "BLOCK�}�`�f�[�^�擾")
  (setq #deg (entget (tblobjname "BLOCK" #2)))

  (CFOutStateLog 1 41 "BLOCK�\���}�`���擾")
  (setq #en (cdr (assoc -2 #deg)))

  (while (/= nil #en)
    (setq #en$ (cons #en #en$))
    (setq #en (entnext #en))
  ) ; end while

  #en$ ; return
) ; SBGetDataByBlock
;<HOM>*************************************************************************
; <�֐���>    : SBDrawGeneralPlan
; <�����T�v>  : ��ʐ}�ʁi�h�A�p�}�A�B���ڍא}�A���r���ݔ��}�j��}
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1998-11-06
;*************************************************************************>MOH<
(defun SBDrawGeneralPlan (
  &bpt$    ; (LIST)     ��_���W���X�g
  &cfgequ$ ; (LIST)     CFG�t�@�C�����X�g
  &srzdir  ; (STR)      SERIES�f�B���N�g��
  /
  #data #lpt$ #fname$ #z #fname #lpt #ss #bpt #i #en #eg #eed$ #bpt #osmode
  )
  (CFOutStateLog 1 0 "//// SBDrawGeneralPlan ////")
  (CFOutStateLog 1 0 "--------------------���� START-----------------")
  (CFOutStateLog 1 0 "��_���W���X�g                : ")(CFOutStateLog 1 0 &bpt$   )
  (CFOutStateLog 1 0 "CFG�t�@�C�����X�g               : ")(CFOutStateLog 1 0 &cfgequ$)
  (CFOutStateLog 1 0 "SERIES�f�B���N�g��            : ")(CFOutStateLog 1 0 &srzdir )
  (CFOutStateLog 1 0 "--------------------���� END-------------------")

  (mapcar
   '(lambda ( #data )
      (setq #lpt$ nil)
      ; ����W���X�g�擾
      (setq #lpt$ (assoc (atoi (car #data)) &bpt$))
      (if (/= nil #lpt$)
        (progn
          ; �t�@�C�����擾
          (setq #fname$ (SBGetFnameZ #data &srzdir))
          ; �\������
          (setq #z     (car  #fname$))
          ; �t�@�C����
          (setq #fname (cadr #fname$))

          (CFOutLog 1 nil (strcat "  +�}��̧�ٖ�  :" #fname))
          (CFOutLog 1 nil (strcat "    +�\������:" #z))

          ; �e���v���[�g����W
          (setq #lpt (cadr #lpt$))
          (setq #lpt (list (car #lpt) (cadr #lpt) (distof #z)))
          (if (findfile #fname)
            (progn

              (CFOutStateLog 1 1 "�}�`�}��")
              (command "_.INSERT" #fname "0,0,0" 1 1 "0")
              (command "_.EXPLODE" (entlast))
              (setq #ss (ssget "P"))
              ; ����W�擾
              (if (/= nil #ss)
                (progn
                  ; ����W�擾
                  (setq #bpt nil)
                  (setq #i 0)
                  (repeat (sslength #ss)
                    (setq #en (ssname #ss #i))
                    (setq #eg   (entget #en '("*")))
                    (setq #eed$ (cdr (assoc -3 #eg)))
                    (if (assoc "G_SBPT" #eed$)
                      (setq #bpt (cdr (assoc 10 #eg)))
                    )
                    (setq #i (1+ #i))
                  )
                  ;�}�`�ړ�
                  (setq #osmode (getvar "OSMODE"))
                  (setvar "OSMODE" 0)
                  (command "_.MOVE" #ss "" #bpt #lpt)
                  (setvar "OSMODE" #osmode)
                )
                (progn
                  (CFOutStateLog 0 1 "�}�`�̒��g�����݂��܂���")(CFOutStateLog 0 1 #fname)
                )
              )

            )
            (progn
              (CFOutStateLog 0 1 "�t�@�C�������݂��܂���")(CFOutStateLog 0 1 #fname)
            )
          )

        )
      ) ; end if
    )
    &cfgequ$
  )
)

;<HOM>*************************************************************************
; <�֐���>    : SBGetGeneralBasePt
; <�����T�v>  : ��ʐ}�ʁi�h�A�p�}�A�B���ڍא}�A���r���ݔ��}�j
;               �̊�_���W�擾
; <�߂�l>    : ��_���W���X�g
; <�쐬>      : 1998-11-06
;*************************************************************************>MOH<
(defun SBGetGeneralBasePt (
  &90      ; (INT)      ��؂鐔�l
  /
  #ss #i #en #eg #eed$ #no #bpt$
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBGetGeneralBasePt ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "��؂鐔�l                      : ")(CFOutStateLog 1 1 &90     )
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  ;�̈�_�}�`�Z�b�g
  (setq #ss (ssget "X" '((-3 ("G_WKPT")))))
  (if (/= nil #ss)
    (progn

      (setq #i 0)
      (repeat (sslength #ss)

        (setq #en (ssname #ss #i))
        (setq #eg (entget #en '("G_WKPT")))
        (setq #eed$ (cdr (assoc -3 #eg)))
        (if (/= nil #eed$)
          (progn

            ;NO
            (setq #no (cdr (cadr (assoc "G_WKPT" #eed$))))
            ;���W�擾
            (if (> #no (- &90 1))
              (setq #bpt$ (cons (list #no (cdr (assoc 10 #eg))) #bpt$))
            )
          )
        )
        (setq #i (1+ #i))
      )
    )
  )

  #bpt$ ; return
)
;<HOM>*************************************************************************
; <�֐���>    : SBGetFnameZ
; <�����T�v>  : �p�[�c�̃t�@�C�����ƕ\�����Ɣ��]�L�����X�g���l������
; <�߂�l>    : ���]�ۂ̂Ƃ��̃f�[�^���X�g
;               (�\������ �t�@�C���� ���]�L��)
; <�쐬>      : 1998-10-15
;*************************************************************************>MOH<
(defun SBGetFnameZ (
  &data$   ; (LIST)     �p�[�c�f�[�^���X�g
  &srzdir  ; (STR)      SERIES�f�B���N�g��
  /
  #no #han #z #key$ #cfgdir #keyname #s$ #han #cdata$ #cdata #fname #key #s
  )
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SBGetFnameZ ////")
	(CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "--------------------���� START-----------------")
  (CFOutStateLog 1 1 "�p�[�c�f�[�^���X�g              : ")(CFOutStateLog 1 1 &data$  )
  (CFOutStateLog 1 1 "SERIES�f�B���N�g��            : ")(CFOutStateLog 1 1 &srzdir )
  (CFOutStateLog 1 1 "--------------------���� END-------------------")

  (setq #no   (nth 0 &data$))          ; �Ǘ��ԍ�
  (setq #han  (nth 3 &data$))          ; ���]��
  (setq #z    (nth 4 &data$))          ; �\����
  (setq #key$ (cdr (cddddr &data$)))   ; �������ڋL��
  (setq #cfgdir (strcat &srzdir "CFG/"))
  ;�L�[��
  (setq #keyname "")
  (mapcar
   '(lambda ( #key )
      (setq #s$ (assoc (strcat CG_SeriesCode "B" #key) CG_FamilyInfo$$))
      (if (and (/= nil #s$) (/= "" #s$))
        (progn
          (setq #s (cadr #s$))
          (setq #keyname (strcat #keyname #s))
        )
      )
    )
    #key$
  )
  ;���]�L��
  (if (= "0" #han)
    (setq #han "A")
    (setq #han CG_DoorLR)
    ;;(if (wcmatch CG_DoorLR "[ABE/]")
    ;;  (setq #han "R")
    ;;  (setq #han "L")
    ;;)
  )
  ;�t�@�C�����擾
  ;���ʃt�@�C��
  (setq #cdata$ (SBreadCSV (strcat #cfgdir #no ".CFG")))
  (mapcar
   '(lambda ( #cdata )
      (if
        (and
          (equal (nth 0 #cdata) #han)
          (equal (nth 1 #cdata) #keyname)
          (equal (nth 2 #cdata) "1")
        )
        (setq #fname (strcat &srzdir "CMASTER/" (nth 3 #cdata) ".DWG"))
      )
    )
    #cdata$
  )
  ;�P�ƃt�@�C��
  (if (or (= nil #fname)(= "" #fname))
    (setq #fname (strcat &srzdir "MASTER/" #no #han #keyname ".DWG"))
  )

  (list #z #fname #han) ; return
) ; SBGetFnameZ