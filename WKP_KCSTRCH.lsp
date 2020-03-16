
(setq SG_PCLAYER    "Z_00_00_00_01")  ;3D�\���b�h�̉�w
(setq SG_YCLAYER    "Y_00_00_00_01")  ;��ʗ̈�̉�w

;<HOM>*************************************************************************
; <�֐���>    : SKS_StretchParts
; <�����T�v>  : ���ސL�k����
; <�߂�l>    :
; <�쐬��>    : 1998-07-30
; <�쐬��>    : S.Kawamoto
; <���l>      : �ǂ�������Ăяo���Ă��Ȃ��悤�ł��� YM
;*************************************************************************>MOH<
(defun SKS_StretchParts (
    /
    #i #ss
  )
  ;// �}�ʂ̃N���[���A�b�v
  (SKS_CleanUpPrim) ; �}�ʓ��ŕs�K�v�ƂȂ����f�[�^���폜

  ;// �R�c���̂̍č쐬
  (PKS_StretchPrimAll) ; �T�C�h�p�l���̐L�k�ɂ��g�p
)
;SKS_StretchParts

;<HOM>*************************************************************************
; <�֐���>    : SKS_CleanUpPrim
; <�����T�v>  : �}�ʓ��ŕs�K�v�ƂȂ����f�[�^���폜
; <�߂�l>    :
; <�쐬��>    : 1998-07-30
; <�쐬��>    : S.Kawamoto
; <���l>      : �ǂ�������Ăяo���Ă��Ȃ���̊֐�����̂݌Ăяo���Ă��� YM
;*************************************************************************>MOH<
(defun SKS_CleanUpPrim (
    /
    #ss #solid #i #en #eg
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKS_CleanUpPrim ////")
  (CFOutStateLog 1 1 " ")

  (command "_layer" "lo" "Z_00_00_??_01" "")
  (command "_layer" "lo" "Y_00_00_??_01" "")
  (setq #solid (ssget "X" '((8 . "Z_00*"))))
  (setq #ss (ssadd))
  (setq #i 0)
  (repeat (sslength #solid)
    (setq #en (ssname #solid #i))
    (setq #eg (entget (ssname #solid #i)))
    (if (/= (cdr (assoc 8 #eg)) "Z_00")
      (ssadd #en #ss)
    )
    (setq #i (1+ #i))

  )
  (command "_erase" #ss "")  ; Z_00*��w�̂���Z_00��w�ȊO�̂��̂��폜
  (setq #ss (ssget "X" '((8 . "Y_00*"))))
  (command "_erase" #ss "")  ; Y_00*��w���폜
  (command "_layer" "u" "Z_00_00_??_01" "")
  (command "_layer" "u" "Y_00_00_??_01" "")
  (princ)
)
;SKS_CleanUpPrim

;<HOM>*************************************************************************
; <�֐���>    : PKS_StretchPrimAll
; <�����T�v>  : �v�f�}�`�̊g���f�[�^��񂩂�v�f���č쐬����
; <�߂�l>    :
; <�쐬��>    : 1998-07-30
; <�쐬��>    : S.Kawamoto
; <���l>      : ; �T�C�h�p�l���̐L�k�Ɏg�p���Ă���
;*************************************************************************>MOH<
(defun PKS_StretchPrimAll (
  /
  #ss #i #en #eg #300 #330 #sym #xd$
  #eg$ #eg2$ #en2
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKS_StretchPrimAll ////")
  (CFOutStateLog 1 1 " ")

  (setvar "PICKSTYLE" 0)

  (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; �}�ʏ����ِ}�`���ׂ�
  (if (/= #ss nil)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_SYM"))
        (if (or (/= 0 (fix (nth 11 #xd$))) (/= 0 (fix (nth 12 #xd$))) (/= 0 (fix (nth 13 #xd$)))) ; �L�k�׸�W,D,H�̂ǂꂩ��0�łȂ�
          (progn
            ;// �Q�c�}�`�̐L�k
            (SKEExpansion #en)

            ;// �R�c�}�`�̐L�k
            (setq #eg$ (entget (cdr (assoc 330 (entget #en)))))  ;// �e�}�ʏ����擾
            (foreach #lst #eg$
              (if (= 340 (car #lst))
                (progn
                  (setq #en2 (cdr #lst))  ;// ��ٰ�����ް�}�` #en2
                  (setq #eg2$ (entget #en2 '("G_PRIM")))
                  (if (and (/= nil #eg2$) (= (cdr (assoc 0 #eg2$)) "3DSOLID") (= (cdr (assoc 8 #eg2$)) "Z_00_00_00_01"))
                    (progn
                      (princ "\n���̂��č쐬���Ă��܂�...")
;;;                      (setq #330 (cdr (assoc 330 #eg2$))); scstretch�ͺ��Ă��Ă��� 00/02/29 YM DEL
;;;                      (setq #eg2$ (entget #330))         ; scstretch�ͺ��Ă��Ă��� 00/02/29 YM DEL
                      (setq #300 (SKGetGroupName #en2))
                      (command "_ucs" "w")
                      (setq #en2 (SKS_RemakePrim #en2)) ; #en2  "G_PRIM"��������"3DSOLID"�ŁA��w"Z_00_00_00_01"
                      (command "_ucs" "p")
                      (if (/= #en2 nil)
                        (command "-group" "A" #300 #en2 "")
                      )
                    )
                  )
                )
              )
            )
            (CFSetXData #en "G_SYM" ; �X�V
              (list
                (nth 0 #xd$)    ;�V���{������
                (nth 1 #xd$)    ;�R�����g�P
                (nth 2 #xd$)    ;�R�����g�Q
                (if (/= (nth 11 #xd$) 0) ; �L�k�t���O�v��0�łȂ�������A�V���{����l�v�̂����ɐL�k�t���O�v������
                  (nth 11 #xd$) ;�L�k�t���O�v  0 or 1
                  (nth 3 #xd$)  ;�V���{����l�v
                )
                (if (/= (nth 12 #xd$) 0) ; �L�k�t���O�c��0�łȂ�������A�V���{����l�c�̂����ɐL�k�t���O�c������
                  (nth 12 #xd$) ;�L�k�t���O�c  0 or 1
                  (nth 4 #xd$)  ;�V���{����l�c
                )
                (if (/= (nth 13 #xd$) 0) ; �L�k�t���O�g��0�łȂ�������A�V���{����l�g�̂����ɐL�k�t���O�g������
                  (nth 13 #xd$) ;�L�k�t���O�g  0 or 1
                  (nth 5 #xd$)  ;�V���{����l�g
                )
                (nth 6 #xd$)    ;�V���{����t������
                (nth 7 #xd$)    ;���͕��@
                (nth 8 #xd$)    ;�v�����t���O
                (nth 9 #xd$)    ;�c�����t���O
                (nth 10 #xd$)   ;�g�����t���O
                (nth 11 #xd$)   ;�L�k�t���O�v  0 or 1
                (nth 12 #xd$)   ;�L�k�t���O�c  0 or 1
                (nth 13 #xd$)   ;�L�k�t���O�g  0 or 1
                (nth 14 #xd$)   ;�u���[�N���C�����v
                (nth 15 #xd$)   ;�u���[�N���C�����c
                (nth 16 #xd$)   ;�u���[�N���C�����g
              )
            )
          )
        )
        (setq #i (1+ #i))
      )
      (command "_vpoint" "0,0,1")
      (command "_ucs" "w")
    )
  )
)
;PKS_StretchPrimAll


;<HOM>*************************************************************************
; <�֐���>    : SKS_RemakePrim
; <�����T�v>  : �v�f�}�`�̊g���f�[�^��񂩂�v�f���č쐬����
; <�q�L�X�E>  : �}�`��"G_PRIM"��������"3DSOLID"�ŁA��w"Z_00_00_00_01"�ɂ������
; <�߂�l>    :
; <�쐬��>    : 1998-07-30
; <�쐬��>    : S.Kawamoto
; <���l>      : �v�f�}�`(G_PRIM)�A�v�f��ʐ}�`(G_BODY)�A�v�f����ʐ}�`(G_ANA)
;               �̏������ɍč쐬����
;*************************************************************************>MOH<
(defun SKS_RemakePrim (
    &prm        ;(ENAME)�v�f��èè��   "G_PRIM"��������"3DSOLID"�ŁA��w"Z_00_00_00_01"
    /
    #prxd$ #dn #eg$ #prm #bdxd$ #ana$ #i #ana #anxd$ #typ #RET
;;;  #ss ; 00/02/29 YM DEL �g���ĂȂ�
   #38 #dn38 #EXT_H
;-- 2011/08/23 A.Satoh Add - S
;  #base_hei #en38
;-- 2011/08/23 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKS_RemakePrim ////")
  (CFOutStateLog 1 1 " ")

  ; 02/06/13 YM ADD-S extrude�̂Ƃ��Ɉꎞ�I�Ƀ��[���h���W�n�ɂ���
  (command "._UCS" "S" "TMP_UCS") ; ���݂�UCS��ۑ�����
  (command "._UCS" "W")           ; world���W�n�ɂ���
  ; 02/06/13 YM ADD-E

;;;  (setq #ss (ssadd)) ; 00/02/29 YM DEL �g���ĂȂ�

  ;// ����è�ނ̊g���ް����擾
  (setq #prxd$ (CFGetXData &prm "G_PRIM"))
  ;;; 00/05/31 MH ADD
  (if (not #prxd$) (progn (CFAlertErr (strcat
  "�L�k�Ώۂ̃\���b�h�}�`�Ƀv���~�e�B�u��� \"G_PRIM\"������܂���ł���"
  "\n\nSKS_RemakePrim")) (exit)))
  (setq #dn (nth 10  #prxd$))   ;// 3DSOLID�̒�ʗ̈�}�`��(�|�����C��)
  (if (/= #dn nil)
    (progn
;;;      (setq #ss (ssadd #dn #ss)) ; 00/02/25 YM MOD
;;;      (ssadd #dn #ss) ; 00/02/25 YM MOD  ; 00/02/29 YM DEL �g���ĂȂ�

;-- 2012/02/17 A.Satoh Add CG�Ή� - S
			(setq #xd_CG$ (CFGetXData &prm "G_CG"))
;-- 2012/02/17 A.Satoh Add CG�Ή� - S
      ;// ��ʗ̈�̺�߰��د�ނɓW�J����
      (setq #eg$ (entget #dn)) ; ��ʗ̈�}�`(�|�����C��)���
;;;   (subst newitem olditem lst)
      (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER = "Z_00_00_00_01"
;;;   (cons 8 SG_PCLAYER)��(assoc 8 #eg$)�͓����H�H�H
      (setq #eg$ (entget (entlast))); �R�s�[������ʗ̈�}�`���(��w�͓����ł�����ق͕ς��) ---> (entlast)
;-- 2011/08/23 A.Satoh Add - S
;      (setq #base_hei (nth 6 #prxd$))
;      (if (> 0 #base_hei)
;        (progn
;          (setq #en38 (cdr (assoc 38 #eg$)))
;          (entmod (subst (cons 38 (- #en38 #base_hei)) (assoc 38 #eg$) #eg$))
;         (if (> (nth 7 #prxd$) 0)
;           (setq #prxd$ (subst (* (nth 7 #prxd$) -1) (nth 7 #prxd$) #prxd$))
;         )
;        )
;      )
;-- 2011/08/23 A.Satoh Add - E
      (setvar "CLAYER" SG_PCLAYER)  ; ���݂̉�w��SG_PCLAYER�ɐݒ�
      ;// �v�f�̍č쐬
      (if (/= (car #prxd$) 3) ; "G_PRIM" ���߂��P��ʂłȂ� ���ݕt�� or ������
        (progn
          ;2010/01/08 YM MOD AutoCAD2009�Ή�
          (command "_extrude" (entlast) "" "T" (nth 9 #prxd$) (nth 7 #prxd$) )  ;// ����"7"��ð�ߊp�x"9"�ŉ��o��
;;;          (command "_extrude" (entlast) "" (nth 7 #prxd$) (nth 9 #prxd$))  ;// ����"7"��ð�ߊp�x"9"�ŉ��o��
;;;                           ^^^^^^^^^entmake�ź�߰����������ײ�

;;;          ;// ��������è�ނ��폜
      ;;; 00/04/20 DEL MH
;;;         (entdel &prm) ; ���� 3DSOLID
          (setq #prm (entlast)) ; "3DSOLID"
;;;                  ^^^^^^^^^�����o���د��

      ;;; 00/04/20 ADD MH �����ŁA���v���~�e�B�u�ƐV�\���b�h���r�����ċ��ʔ͈͂������ꍇ
      ;;; �����o���������t�ł������Ɣ��f�B�V�\���b�h���폜���ċt�����ō쐬�������B
; 02/06/13 YM DEL-S �����o�����肵�Ȃ�(RemakePrim�̂Ƃ��Ɉꎞ�I��ܰ��ލ��W�n�ɂ���)
;;;          (if (not (PcChkIntersect #prm &prm))
;;;            (progn
;;;              (entdel #prm)
;;;              (entmake #eg$) ; SG_PCLAYER = "Z_00_00_00_01"
;;;              (command "_extrude" (entlast) "" (- (nth 7 #prxd$)) (nth 9 #prxd$))
;;;              (setq #prm (entlast)) ; "3DSOLID"
;;;            ); progn
;;;          )
; 02/06/13 YM DEL-E
          (entdel &prm) ; ���肪�ς񂾂̂ŁA���v���e�B�u�폜

          (CFSetXData #prm "G_PRIM" #prxd$) ; �V�v���~�e�B�u�Ɋg���ް�"G_PRIM"���
;-- 2012/02/17 A.Satoh Add CG�Ή� - S
					(if #xd_CG$
						; �V�v���~�e�B�u�Ɋg���f�[�^"G_CG"���Z�b�g
						(CFSetXData #prm "G_CG" #xd_CG$)
					)
;-- 2012/02/17 A.Satoh Add CG�Ή� - S

;;;          (setq #ss (ssadd #prm #ss)) ; 00/02/25 YM MOD
;;;          (ssadd #prm #ss) ; 00/02/25 YM MOD ; 00/02/29 YM DEL �g���ĂȂ�

          (setq #dn38 (cdr (assoc 38 (entget #dn)))) ; ��ʐ}�`(�|�����C��)�̍��x

          ;// ���̍�蒼��
          (setq #bdxd$ (CFGetXData #dn "G_BODY"))    ; ��ʐ}�`(�|�����C��)��"G_BODY" : PLINE ��� or ��ʂɕt��������
          (if (/= #bdxd$ nil)
            (progn
              (setq #ana$ nil)
              (setq #i 2)
              (repeat (nth 1 #bdxd$)        ; ���ް������J��Ԃ�
                (setq #ana (nth #i #bdxd$)) ; ���}�`�� #i=2
;;;                (setq #ss (ssadd #ana #ss)) ; 00/02/25 YM MOD
;;;                (ssadd #ana #ss) ; 00/02/25 YM MOD ; 00/02/29 YM DEL �g���ĂȂ�

                (setq #anxd$ (CFGetXData #ana "G_ANA"))
                (setq #eg$ (entget #ana)) ; ���}�`���

                ;// ���̉��o��
                (setq #typ (nth 1 #anxd$)) ; ���[������

                (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; 00/02/29 YM ADD ; ���}�`�̺�߰SG_PCLAYER="Z_00_00_00_01"
                (cond
                  ((= #typ 0)  ;// �ђʌ�
;;;                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$))       ; ���}�`�̺�߰  SG_PCLAYER="Z_00_00_00_01"

                    ;2010/01/08 YM MOD AutoCAD2009�Ή�
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) (nth 7 #prxd$)) ; ���̉����o�� nth 7����  nth 3ð�ߊp�x
;;;                    (command "_extrude" (entlast) "" (nth 7 #prxd$) (nth 3 #anxd$)) ; ���̉����o�� nth 7����  nth 3ð�ߊp�x
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 0 (nth 2 #anxd$) (nth 3 #anxd$))) ; ���[������ 0 �ђʌ�
                  )
                  ((= #typ 1)  ;// ��ʂ���т�
;;;                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER="Z_00_00_00_01"
                    (if KEKOMI_COM ; 01/01/12 YM MOD �r㻌^�Ή�
                      (setq #ext_H (- (nth 2 #anxd$) KEKOMI_COM))
                      (setq #ext_H (nth 2 #anxd$))
                    );_if
                   
                    ;2010/01/08 YM MOD AutoCAD2009�Ή�
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) #ext_H) ; ���̉����o�� nth 2���[��  nth 3ð�ߊp�x
;;;                    (command "_extrude" (entlast) "" #ext_H (nth 3 #anxd$)) ; ���̉����o�� nth 2���[��  nth 3ð�ߊp�x
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 1 #ext_H (nth 3 #anxd$))) ; ���[������ 1 ��ʂ���т�
                  )
                  ((= #typ 2)  ;// ��ʂ���т�
;;;                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER="Z_00_00_00_01"

                    ;2010/01/08 YM MOD AutoCAD2009�Ή�
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) (nth 2 #anxd$)) ; ���̉����o�� nth 2���[��  nth 3ð�ߊp�x
;;;                    (command "_extrude" (entlast) "" (nth 2 #anxd$) (nth 3 #anxd$)) ; ���̉����o�� nth 2���[��  nth 3ð�ߊp�x
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 2 (nth 2 #anxd$) (nth 3 #anxd$))) ; ���[������ 2 �ђʌ�
                  )
                )

                ;// �v�f�Ƃ̍����Ƃ�
                (command "_subtract" #prm "" (entlast) "")
;;;                                          ^^^^^^^^^�����o���쐬���د��
                (setq #i (1+ #i))
              );_(repeat
            )
          );_if
          ; 02/06/13 YM DEL-S
;;;          (entlast)
          ; 02/06/13 YM DEL-E

          ; 02/06/13 YM MOD-S
          (setq #ret (entlast)) ; �߂�l��#ret�Ƃ���
          ; 02/06/13 YM MOD-E

        );_progn ; "G_PRIM" ���߂��P��ʂłȂ� ���ݕt�� or ������
      ;else

          ; 02/06/13 YM DEL-S
;;;       nil      ; "G_PRIM" ���߂��P��ʂ̂Ƃ�
          ; 02/06/13 YM DEL-E

        ; 02/06/13 YM MOD-S
        (setq #ret nil)      ; "G_PRIM" ���߂��P��ʂ̂Ƃ� ; �߂�l��#ret�Ƃ���
        ; 02/06/13 YM MOD-E
      );_if
    )
  )

  ; 02/06/13 YM ADD-S extrude�̂Ƃ��Ɉꎞ�I�Ƀ��[���h���W�n�ɂ���
  (command "._UCS" "R" "TMP_UCS") ; �o�^����UCS���Ăяo��
  (command "._UCS" "D" "TMP_UCS") ; �o�^����UCS���폜����
  ; 02/06/13 YM ADD-E

  #ret ; �߂�l��#ret�Ƃ��� 02/06/13 YM ADD
)
;SKS_RemakePrim

;<HOM>***********************************************************************
; <�֐���>    : SKS_ExpansionSolid
; <�����T�v>  : �L�k�����\���b�h�}�`�ɑ������ʐ}�`�̗v�f���݂�ύX����
; <�߂�l>    : �����F T�@�@�@���s�Fnil
; <�쐬��>    : 1998-07-30
; <�쐬��>    : S.Kawamoto
; <���l>      :
;***********************************************************************>HOM<
(defun SKS_ExpansionSolid (
  &vflg    ;(INT) W(1),D(2),H(3) �t���O
  &p1      ;(INT) �̈�P
  &p2      ;(INT) �̈�Q
  &wid     ;(REAL)�L�k��
  &lay     ;(STR) ��w��
  &EXT_flg ; 01/03/01 YM ADD ��t�������t�����̃t���O (1 or 2) �L�k�t���O=�m�[�}��:1 �A�b�p�[:2
  /
  #ssC
  #ssW
  #i #en #xd$ #h #dn #eg #210 #setflg #vflg
  #view #viewdir #ANA #ANA$ #BODY$ #H_ANA #NN
;-- 2011/08/19 A.Satoh Add - S
  #ana_hei #base_hei #ana_xd$
;-- 2011/08/19 A.Satoh Add - E
;-- 2011/08/23 A.Satoh Add - S
;  #set_hei
;-- 2011/08/23 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKS_ExpansionSolid ////")
  (CFOutStateLog 1 1 " ")

  (setq #ssC (ssget "C" &p1 &p2 (list (cons 0 "3DSOLID") (cons 8 &lay))))
  (if (= #ssC nil)
    (progn
      (CFOutStateLog 1 7 "      SKEExpansionSolid=�L�k�ΏۂɃ\���b�h���܂܂�Ȃ�")
      T
    )
    (progn
      (setq #ssW (ssget "W" &p1 &p2 (list (cons 0 "3DSOLID") (cons 8 &lay))))
      (command "_ucs" "w")
      (setq #viewdir (getvar "VIEWDIR"))
      (command "_ucs" "p")
      (setq #i 0)
      (repeat (sslength #ssC)
        (setq #en (ssname #ssC #i))
        (setq #xd$ (CFGetXData #en "G_PRIM"))
        ;;; 00/05/30 MH ADD
;;;        (if (not #xd$) (progn (CFAlertErr (strcat  ; 01/02/22 YM DEL
;;;          "�L�k�Ώۂ̃\���b�h�}�`�Ƀv���~�e�B�u��� \"G_PRIM\"������܂���ł���"
;;;          "\n\nSKS_ExpansionSolid")) (exit)))

        (setq #setflg nil) ; 01/02/22 YM ������ړ�

        (if #xd$ ; 01/02/22 YM
          (progn ; "G_PRIM"������Ƃ� ; 01/02/22 YM

            (setq #h (nth 7 #xd$))
;-- 2011/08/23 A.Satoh Add - S
;            (setq #set_hei (nth 6 #xd$))
;            (if (and (= &vflg 3) (> 0 #set_hei) (= &EXT_flg 2))
;              (setq #h (* #h -1))
;            )
;-- 2011/08/23 A.Satoh Add - E
            (setq #dn (nth 10 #xd$))
            (setq #eg (entget #dn))
            (setq #210 (cdr (assoc CG_SKK_INT_GAS #eg))) ; 01/08/31 YM MOD 210-->��۰��ى�
            (setq #view (list  (fix (car   #210)) (fix (cadr  #210)) (fix (caddr #210))))
            (setq #viewdir (list (fix (car #viewdir)) (fix (cadr #viewdir)) (fix (caddr #viewdir))))

;;;           (setq #setflg nil)
            (cond
              ((or (= &vflg 1) (= &vflg 2))    ;�v�܂��͂c�����L�k�̏ꍇ
                (if (or (equal #viewdir (list 0 -1 0)) (equal #viewdir (list 0 1 0))) ;���݂�����or�w��
                  (if (or (equal (list -1 0 0) #view) (equal (list 1 0 0) #view))
                    (if (or (= #ssW nil) (= (ssmemb #en #ssW) nil)) ; �w�肳�ꂽ�I�u�W�F�N�g(�}�`)���I���Z�b�g�̃����o�[���ǂ������e�X�g
                      (progn
                        (setq #setflg T)
                      )
                    )
                  )
                  (if (or (equal (list 0 -1 0) #view) (equal (list 0 1 0) #view)) ;���݂��E����or������
                    (if (or (= #ssW nil) (= (ssmemb #en #ssW) nil))
                      (setq #setflg T)
                    )
                  )
                )
              )
              ((= &vflg 3)  ;�g�����L�k�̏ꍇ
                (if (equal (list 0 0 1) #view)
                  (if (or (= #ssW nil) (= (ssmemb #en #ssW) nil))
                    (setq #setflg T)
                  )
                )
              )
            )
            ; 01/03/01 YM �s�����
            ; ����ُ�t���g�����g��==>�L�k��&wid(-)
            ;<��>
            ; G_PRIM�����o����-500==>-600
            ; G_PRIM�����o���� 466==> 366�~(��������566�ɂȂ�ׂ�)

            ; ����ى��t���g�����g��==>�L�k��&wid(+)
            ;<��>
            ; G_PRIM�����o���� 701==> 770
            ; �����̗Ⴉ��A�����o���ʂ̐�Βl����������悤�ɐݒ肵�Ȃ���΂Ȃ�Ȃ�
            ; (�L�k�̏ꍇ�͋t�ƂȂ�)

            ; ��t�������o���ʁ{�Ȃ猸�Z
            ; ��t�������o���ʁ|�Ȃ���Z
            ; ���t�������o���ʁ{�Ȃ���Z
            ; ���t�������o���ʁ|�Ȃ猸�Z
            (if (= #setflg T)
              (progn
                (CFSetXData #en "G_PRIM"
                  (list
                    (nth 0 #xd$)
                    (nth 1 #xd$)
                    (nth 2 #xd$)
                    (nth 3 #xd$)
                    (nth 4 #xd$)
                    (nth 5 #xd$)
                    (nth 6 #xd$)

                    (cond ; 01/03/01 YM �s��Ή������o���ʕs��Ή�
                      ((= &EXT_flg 1) ; ɰ��(���t��)
                        (if (< 0 #h)
                          (+ #h &wid)     ;�v�f����+�L�k��
                          (- #h &wid)     ;�v�f����-�L�k��
                        );_if
                      )
                      ((= &EXT_flg 2) ; ���߰(��t��)
                        (if (< 0 #h)
                          (- #h &wid)     ;�v�f����-�L�k��
                          (+ #h &wid)     ;�v�f����+�L�k��
                        );_if
                      )
                      (T
                        (if (< 0 #h)
                          (+ #h &wid)     ;�v�f����+�L�k��
                          (- #h &wid)     ;�v�f����-�L�k��
                        );_if
                      )
                    );_cond

                    (nth 8 #xd$)
                    (nth 9 #xd$)
                    (nth 10 #xd$)
                  )
                )
                ; 01/03/08 YM ADD ���̉����o���ʂ��X�V���Ȃ��Ƃ����Ȃ�(�����)
                (setq #BODY$ (CFGetXData (nth 10 #xd$) "G_BODY")) ; ��ʏ��擾
                (setq #nn 2)
                (repeat (nth 1 #BODY$)
                  (setq #ANA (nth #nn #BODY$))
;-- 2011/08/19 A.Satoh Mod - S
                  (setq #ANA$ (CFGetXData #ANA "G_ANA")) ; �����擾
                  (if #ANA$
                    (progn
                      (setq #h_ana (nth 2 #ANA$)) ; ������

                      (setq #ana_xd$ (entget #ANA '("*")))
                      (setq #ana_hei (cdr (assoc 38 #ana_xd$)))
                      (setq #base_hei (nth 1 &p2))

;                     (if (> (+ #ana_hei #h_ana) #base_hei)
;                       (progn
;-- 2011/12/20 A.Satoh Add - S
											(cond
												((= &EXT_flg 1)	; ɰ��(���t��)
													(cond
														((< #ana_hei #base_hei)		; �u���[�N���C�������x�[�X�}�`�̏�ɂ���
															(if (> (+ #ana_hei #h_ana) #base_hei)	; �u���[�N���C�������͈͓��ɂ���ꍇ
	    	        	              (CFSetXData #ANA "G_ANA"
  	    	        	              (list
    	    	        	              (nth 0 #ANA$)
      	    	        	            (nth 1 #ANA$)
																		(if (< 0 #h_ana)
																			(+ #h_ana &wid) ;������+�L�k��
																			(- #h_ana &wid) ;������-�L�k��
																		)
              		    	            (nth 3 #ANA$)
                		    	        )
																)
															)
														)
														((>= #ana_hei #base_hei)	; �u���[�N���C�������x�[�X�}�`�̉��ɂ���
  	          	              (CFSetXData #ANA "G_ANA"
    	          	              (list
      	          	              (nth 0 #ANA$)
        	          	            (nth 1 #ANA$)
;-- 2012/01/05 A.Satoh Mod - S
;;;;;																	(if (< 0 #h_ana)
;;;;;																		(+ #h_ana &wid) ;������+�L�k��
;;;;;																		(- #h_ana &wid) ;������-�L�k��
;;;;;																	)
																	#h_ana
;-- 2012/01/05 A.Satoh Mod - E
              	  	              (nth 3 #ANA$)
                	  	          )
                  	  	      )
;-- 2012/01/05 A.Satoh Del - S
;;;;;
;;;;; 	                  	  	    (setq #ana_xd$ (subst (cons 38 (+ #ana_hei &wid)) (assoc 38 #ana_xd$) #ana_xd$))
;;;;;   	                  	  	  (entmod #ana_xd$)
;-- 2012/01/05 A.Satoh Del - E
														)
													)
												)
												((= &EXT_flg 2)	; ���߰(��t��)
    	     	              (CFSetXData #ANA "G_ANA"
      	     	              (list
															(nth 0 #ANA$)
															(nth 1 #ANA$)
															(if (< 0 #h_ana)
																(- #h_ana &wid) ;������-�L�k��
																(+ #h_ana &wid) ;������+�L�k��
															)
															(nth 3 #ANA$)
														)
													)
												)
											)
;;;;;                      (if (equal #ana_hei 0)
;;;;;                        (if (> (+ #ana_hei #h_ana) #base_hei)
;;;;;                          (CFSetXData #ANA "G_ANA"
;;;;;                            (list
;;;;;                              (nth 0 #ANA$)
;;;;;                              (nth 1 #ANA$)
;;;;;                              (cond ; �������X�V
;;;;;                                ((= &EXT_flg 1) ; ɰ��(���t��)
;;;;;                                  (if (< 0 #h_ana)
;;;;;                                    (+ #h_ana &wid) ;������+�L�k��
;;;;;                                    (- #h_ana &wid) ;������-�L�k��
;;;;;                                  );_if
;;;;;                                )
;;;;;                                ((= &EXT_flg 2) ; ���߰(��t��)
;;;;;                                  (if (< 0 #h_ana)
;;;;;                                    (- #h_ana &wid) ;������-�L�k��
;;;;;                                    (+ #h_ana &wid) ;������+�L�k��
;;;;;                                  );_if
;;;;;                                )
;;;;;                              );_cond
;;;;;                              (nth 3 #ANA$)
;;;;;                            )
;;;;;                          )
;;;;;                        )
;;;;;												(if (> (+ #ana_hei #h_ana) #base_hei)
;;;;; 	                        (progn
;;;;;   	                        (setq #ana_xd$ (subst (cons 38 (+ #ana_hei &wid)) (assoc 38 #ana_xd$) #ana_xd$))
;;;;;     	                      (entmod #ana_xd$)
;;;;;       	                  )
;;;;;         	              )
;;;;;                      )
                    )
                  );_if
;-- 2011/12/20 A.Satoh Add - E
;                  (setq #ANA$ (CFGetXData #ANA "G_ANA")) ; �����擾
;                  (if #ANA$
;                    (progn
;                      (setq #h_ana (nth 2 #ANA$)) ; ������
;
;                      (CFSetXData #ANA "G_ANA"
;                        (list
;                          (nth 0 #ANA$)
;                          (nth 1 #ANA$)
;                          
;                          (cond ; �������X�V
;                            ((= &EXT_flg 1) ; ɰ��(���t��)
;                              (if (< 0 #h_ana)
;                                (+ #h_ana &wid) ;������+�L�k��
;                                (- #h_ana &wid) ;������-�L�k��
;                              );_if
;                            )
;                            ((= &EXT_flg 2) ; ���߰(��t��)
;                              (if (< 0 #h_ana)
;                                (- #h_ana &wid) ;������-�L�k��
;                                (+ #h_ana &wid) ;������+�L�k��
;                              );_if
;                            )
;                          );_cond
;
;                          (nth 3 #ANA$)
;                        )
;                      )
;                    )
;                  );_if
;-- 2011/08/19 A.Satoh Mod - E

                  (setq #nn (1+ #nn))
                );repeat
              )
            );_if

          ) ; 01/02/22 YM
        );_if ; 01/02/22 YM
        (setq #i (1+ #i))
      )
    )
  )
  #setflg
);SKS_ExpansionSolid

;<HOM>*************************************************************************
; <�֐���>    : SKS_MakeViewStretchPrimAll
; <�����T�v>  : �r���[���쐬���A���ސL�k���s��
; <���l>      : 01/07/11 YM from NR ���݌����������ّΉ�
;*************************************************************************>MOH<
(defun SKS_MakeViewStretchPrimAll (
    /
    #viewEn
    #os #sn
    #res$
    #xmax #ymax
    #wid
  )
  ;// �V�X�e���ϐ���ݒ�
  (setq #os (getvar "OSMODE"))
  (setq #sn (getvar "SNAPMODE"))
  (setvar "OSMODE"   0)
  (setvar "GRIDMODE" 0)
  (setvar "SNAPMODE" 0)
  (command "_.UCSICON" "A" "OF")  ;UCS�A�C�R����S�Ĕ�\��

  (if (= 0 (getvar "TILEMODE"))
    (progn
      ;// �r���[�̃T�C�Y���擾����
      (command "_.pspace")
      (setvar "SNAPMODE" 0)
      (setvar "OSMODE"   0)
      (setvar "GRIDMODE" 0)

      (setq #res$ (GetViewSize))
      (setq #xmax (nth 1 #res$))
      (setq #ymax (nth 3 #res$))
      (setq #wid (/ (- #xmax (car #res$)) 15.))
      (command "_.mview" (list #xmax #ymax) (list (- #xmax #wid) (- #ymax #wid)))
      (setq #viewEn (entlast))
      (command "_.mspace")

      ;// ���ނ̐L�k
      (PKS_StretchPrimAll) ; SKS->PKS
      (command "_.PSPACE")
      (entdel #viewEn)
      (command "_.MSPACE")
    )
  ;else
    (progn
      ;// ���ނ̐L�k
      (PKS_StretchPrimAll) ; SKS->PKS
    )
  )
  ;// �V�X�e���ϐ������ɖ߂�
  (setvar "OSMODE"   #os)
  (setvar "SNAPMODE" #sn)
);SKS_MakeViewStretchPrimAll

;<HOM>*************************************************************************
; <�֐���>    : SKS_StretchPartsSub
; <�����T�v>  : ���ނ̐L�k
; <�߂�l>    :
; <�쐬>      : 1998-07-30
; <���l>      :
;*************************************************************************>MOH<
(defun SKS_StretchPartsSub (
    &sym
    /
    #ss #i #en #eg$ #300 #330 #xd$ #gnam #en2 #eg2$ #lst
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKS_StretchPartsSub ////")
  (CFOutStateLog 1 1 " ")

  (setvar "PICKSTYLE" 0)
  (setq #en &sym)
  (setq #xd$ (CFGetXData #en "G_SYM"))
  (if (or (/= 0 (fix (nth 11 #xd$))) (/= 0 (fix (nth 12 #xd$))) (/= 0 (fix (nth 13 #xd$)))) ; �L�k�׸�W,D,H�̂ǂꂩ��0�łȂ�
    (progn
      ;// �Q�c�}�`�̐L�k
      ;(command "_layer" "T" "*" "")
      (SKS_Expansion #en)

      ;// �R�c�}�`�̐L�k
      (setq #eg$ (entget (cdr (assoc 330 (entget #en)))))  ;// �e�}�ʏ����擾
      (foreach #lst #eg$  ;// ��ٰ�����ް�}�`�̎擾
        (if (= 340 (car #lst))
          (progn
            (setq #en2 (cdr #lst)) ; ��ٰ�����ް�}�` #en2
            (setq #eg2$ (entget #en2 '("G_PRIM")))
            (if (and (/= nil #eg2$) (= (cdr (assoc 0 #eg2$)) "3DSOLID") (= (cdr (assoc 8 #eg2$)) "Z_00_00_00_01"))
              (progn ; ��ٰ�����ް �̂���"G_PRIM" "3DSOLID" ��w="Z_00_00_00_01"
                (setq #gnam (SKGetGroupName #en2)) ; ��ٰ�ߖ��̎擾
                (setq #en2 (SKS_RemakePrim #en2)) ; #en2  "G_PRIM"��������"3DSOLID"�ŁA��w"Z_00_00_00_01"
                (if (/= #en2 nil)
                  (progn
                    (command "-group" "A" #gnam #en2 "")
                  )
                )
              )
            )
          )
        )
      )
      (CFSetXData #en "G_SYM" ; �g���ް��X�V
        (list
          (nth 0 #xd$)    ;�V���{������          ���̂܂�
          (nth 1 #xd$)    ;�R�����g�P            ���̂܂�
          (nth 2 #xd$)    ;�R�����g�Q            ���̂܂�

          (if (/= (nth 11 #xd$) 0)      ; �L�k�׸ނ�0�łȂ�������
            (nth 11 #xd$)   ; �L�k�׸ނv
            (nth 3 #xd$)    ;�V���{����l�v    ���̂܂�
          )
          (if (/= (nth 12 #xd$) 0)      ; �L�k�׸ނ�0�łȂ�������
            (nth 12 #xd$)   ; �L�k�׸ނc
            (nth 4 #xd$)    ;�V���{����l�c    ���̂܂�
          )
          (if (/= (nth 13 #xd$) 0)      ; �L�k�׸ނ�0�łȂ�������
            (nth 13 #xd$)   ; �L�k�׸ނg
            (nth 5 #xd$)    ;�V���{����l�g    ���̂܂�
          )

          (nth 6 #xd$)    ;�V���{����t������    ���̂܂�
          (nth 7 #xd$)    ;���͕��@              ���̂܂�
          (nth 8 #xd$)    ;�v�����t���O          ���̂܂�
          (nth 9 #xd$)    ;�c�����t���O          ���̂܂�
          (nth 10 #xd$)   ;�g�����t���O          ���̂܂�
          (nth 11 #xd$)   ;�L�k�t���O�v          ���̂܂�
          (nth 12 #xd$)   ;                      ���̂܂�
          (nth 13 #xd$)   ;                      ���̂܂�
          (nth 14 #xd$)   ;�u���[�N���C�����v    ���̂܂�
          (nth 15 #xd$)   ;�u���[�N���C�����c    ���̂܂�
          (nth 16 #xd$)   ;�u���[�N���C�����g    ���̂܂�
        )
      )
    )
  )
  (command "_vpoint" "0,0,1") ; ���ʐ}
  (command "_ucs" "w")        ; ܰ���
)
;SKS_StretchPartsSub

;<HOM>***********************************************************************
; <�֐���>    : SKS_Expansion
; <�����T�v>  : �V���{���ɑ����� 2D �}�`��S�ĐL�k����
; <�q�L�X�E>  : ����ِ}�`
; <�߂�l>    : �����F T�@�@�@���s�Fnil
; <�쐬>      : 1998/08/05, 1998/08/17 -> 1998/08/17   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKS_Expansion
  (
    &enSym      ; �L�k���s���V���{���}�`��
  /
    #SymData$   ; �V���{���f�[�^�i�[�p
    #enGroup    ; �V���{���̏�������O���[�v���i�[�p
    #GrpData$   ; �O���[�v�\���}�`��(�O���[�v�̃f�[�^)�i�[�p
    #expData$   ; �L�k�������s���}�`�f�[�^���i�[�p
    #iRad       ; �V���{���̉�]�p�x�i�[�p
    #SymPos$    ; �V���{���̑}���_�i�[�p
    #ViewZ$     ; �����o�������i�[�p
    #iHSize     ; ���݂� H �����̃T�C�Y�i�[�p
    #iWSize     ; ���݂� W �����̃T�C�Y�i�[�p
    #iDSize     ; ���݂� D �����̃T�C�Y�i�[�p
    #iHExp      ; H �����̐L�k���i�[�p
    #iWExp      ; W �����̐L�k���i�[�p
    #iDExp      ; D �����̐L�k���i�[�p
    #BrkH$      ; H �����̃u���[�N���C�����i�[�p
    #BrkW$      ; W �����̃u���[�N���C�����i�[�p
    #BrkD$      ; D �����̃u���[�N���C�����i�[�p
    #bCabFlag   ; �L���r�l�b�g�t���O(�A�b�p�[�L���r�l�b�g:1 ����ȊO:0)
    #Pos$       ; �L�k�Ώ̐}�`�̋�`�̈���W�i�[�p
    #iExpSize   ; �L�k���s���T�C�Y�i�[�p
    #iLoop      ; ���[�v�p
    #nn         ; foreach �p
    #strLayer   ; ��w���i�[�p
    #Temp$      ; �e���|�������X�g
    ;; ���[�J���萔�i�[�p
    Exp_F_View  ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
    Exp_FM_View ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
    Exp_FP_View ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p
    Exp_S_View  ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
    Exp_SM_View ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
    Exp_SP_View ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p
    Exp_Temp_Layer; �L�k��Ɨp��w���i�[�p
    Upper_Cab_Code ; �O���[�o���萔�p
  )
  ;; �L�k�����J�n
  (CFOutStateLog 1 7 "      SKEExpansion=Start")
  ;T    ; return;
  ;; ���[�J���萔�̏�����(�����l���)
  (setq Exp_F_View  '(0 -1 0))  ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_FM_View '(-1 0 0))  ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_FP_View '(1 0 0))   ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_S_View  '(-1 0 0))  ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_SM_View '(0 1 0))   ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_SP_View '(0 -1 0))  ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p

  (setq Exp_Temp_Layer  "EXP_TEMP_LAYER") ; �L�k��Ɨp��w��

  ;; �L�k��Ɨp�e���|������w�̍쐬
  (command "_layer" "N" Exp_Temp_Layer "C" 1 Exp_Temp_Layer "L" SKW_AUTO_LAY_LINE Exp_Temp_Layer ""); �L�k��Ɨp�e���|������w�̍쐬

  (setq #bCabFlag 0)
  (setq #SymData$ (CFGetXData &enSym "G_LSYM")); �V���{���� "G_LSYM" �g���f�[�^���擾����

  (if (/= #SymData$ nil)                                     ; "G_LSYM" �f�[�^���擾�ł������ǂ����̃`�F�b�N
    (progn                                                   ; �擾�ł���
      (setq #iRad    (nth 2 #SymData$))                      ; ��]�p�x(nth 2)���擾����
      (setq #SymPos$ (nth 1 #SymData$))                      ; �}���_(nth 1)���擾����
      (setq #Temp$   (nth 9 #SymData$))                      ; ���iCODE�擾
      (if (= CG_SKK_TWO_UPP (CFGetSeikakuToSKKCode #Temp$ 2)); ���iCODE���A�b�p�[�L���r�l�b�g���ǂ����̃`�F�b�N
        (setq #bCabFlag 1)                                   ; ���߰����
      )
      (setq #SymData$ (CFGetXData &enSym "G_SYM")); �V���{���� "G_SYM" �g���f�[�^���擾����

      (if (/= #SymData$ nil)               ; "G_SYM" �f�[�^���擾�ł������ǂ����̃`�F�b�N
        (progn                             ; �擾�ł���
          (setq #iWSize (nth  3 #SymData$)); ���݂� W �T�C�Y(nth 3)
          (setq #iDSize (nth  4 #SymData$)); ���݂� D �T�C�Y(nth 4)
          (setq #iHSize (nth  5 #SymData$)); ���݂� H �T�C�Y(nth 5)
          (setq #iWExp  (nth 11 #SymData$)); W ����(nth 11)�̐L�k��
          (setq #iDExp  (nth 12 #SymData$)); D ����(nth 12)�̐L�k��
          (setq #iHExp  (nth 13 #SymData$)); H ����(nth 13)�̐L�k��
          (setq #SymData$ (entget &enSym)) ; ����ِ}�`�����擾����
          (setq #enGroup (cdr (assoc 330 #SymData$)))      ; �V���{���̃O���[�v�����擾���� "G_GROUP"
          (setq #GrpData$ (entget #enGroup))               ; �O���[�v���f�[�^(�O���[�v�����X�g)���擾���� "G_GROUP"�}�`���

          (foreach #nn #GrpData$                           ; 2D �}�`�ŐL�k�������s���f�[�^���i�荞�ށB�u���[�N���C���𒊏o����
            (if (= (car #nn) 340)                          ; �O���[�v�\���}�`�����ǂ����̃`�F�b�N
              (progn                                       ; �O���[�v�\���}�`��������
                (setq #Temp$ (entget (cdr #nn)))           ; �O���[�v�\���}�`�����

                (if (/= (cdr (assoc 0 #Temp$)) "XLINE")    ; �O���[�v�\���}�`���\���b�h�f�[�^(0 . "3DSOLID")�ȊO���ǂ����̃`�F�b�N
;;;                                                                                                ^^^^^^^^"XLINE"??? "3DSOLID"???
                  (progn                                   ; �\���b�h�f�[�^�ł͂Ȃ�����
                    (setq #strLayer (cdr (assoc 8 #Temp$))); ��w���̎擾
                    (setq #expData$ (cons (list (cdr #nn) #strLayer) #expData$)); (�}�`�� ��w��)
                    (entmod
                      (subst (cons 8 Exp_Temp_Layer) (assoc 8 #Temp$) #Temp$)   ; �L�k�Ώې}�`��L�k������w�Ɉړ�����
                    )
                  )
                );_if

                (if (= (cdr (assoc 0 #Temp$)) "XLINE")                                 ; �O���[�v�\���}�`���u���[�N���C�����ǂ����̃`�F�b�N
                  (progn                                                               ; �u���[�N���C��������
                    (setq #Temp$ (CFGetXData (cdr #nn) "G_BRK"))                       ; �u���[�N���C���̊g���f�[�^���擾
                    (if (/= #Temp$ nil)                                                ; �g���f�[�^�����݂��邩�ǂ����̃`�F�b�N
                      (progn                                                           ; �g���f�[�^�����݂���
                        (cond                                                          ; H,W,D �e�u���[�N���C���̎�ޖ��ɐ}�`�����i�[����
                          ((= (nth 0 #Temp$) 1) (setq #BrkW$ (cons (cdr #nn ) #BrkW$))); W �����u���[�N���C�� #BrkW$ : ��ڰ�ײݐ}�`��ؽ�
                          ((= (nth 0 #Temp$) 2) (setq #BrkD$ (cons (cdr #nn ) #BrkD$))); D �����u���[�N���C�� #BrkD$ : ��ڰ�ײݐ}�`��ؽ�
                          ((= (nth 0 #Temp$) 3) (setq #BrkH$ (cons (cdr #nn ) #BrkH$))); H �����u���[�N���C�� #BrkH$ : ��ڰ�ײݐ}�`��ؽ�
                        )
                      )
                    )
                  )
                )
              );_progn
            );_if
          );_(foreach

          (if (and (= #BrkH$ nil) (= #BrkW$ nil) (= #BrkD$ nil))
            (CFAlertErr "���̃A�C�e���ɂ͐L�k���C��������܂���ł���")
          )
          ; �L�k����
          (cond                                     ; �����o�������̔��f
            ((= #iRad 0) (setq #ViewZ$ Exp_F_View)) ; #iRad : LSYM ��]�p�x(nth 2)
            ((< #iRad 0) (setq #ViewZ$ Exp_FM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_FP_View))
          )

          ; �L�k���s���T�C�Y�̃`�F�b�N(�A�b�p�[�L���r�l�b�g�̏ꍇ�� +- ���t�])
          (if (and (= #bCabFlag 1) (/= #iHExp 0)) ; �A�b�p�[�L���r�� H����(nth 13)�̐L�k�����O�łȂ�
            (progn
              (setq #iExpSize (list 1 (- #iHExp #iHSize) 2)) ; �L�k��-���݂�H�T�C�Y(nth 5)
            )
            ; else
            (progn
              (setq #iExpSize (list 0 (- #iHExp #iHSize) 1))
            )
          );_if

          (if (and (/= #BrkH$ nil) (/= #iHExp 0))
            (progn                                                    ; �u���[�N���C������_���牓�����Ƀ\�[�g����
              (setq #BrkH$ (SKESortBreakLine (list 2 #BrkH$) #SymPos$))
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkH$ #iExpSize) ; H �����̐L�k����
              (CFOutStateLog 1 7 "        SKEExpansion=H�u���[�N OK") ; ����I��
            )
            ;; else
            (progn
              (CFOutStateLog 1 7 "        SKEExpansion=H�u���[�N�Ȃ�"); ����I��
            )
          )

          (if (and (/= #BrkW$ nil) (/= #iWExp 0))
            (progn
              (setq #BrkW$ (SKESortBreakLine (list 0 #BrkW$) #SymPos$)); �u���[�N���C������_���牓�����Ƀ\�[�g����
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkW$ (list 2 (- #iWExp #iWSize))); W �����̐L�k����
              (CFOutStateLog 1 7 "        SKEExpansion=W�u���[�N OK"); ����I��
            )
            ; else
            (progn
              (CFOutStateLog 1 7 "        SKEExpansion=W�u���[�N�Ȃ�"); ����I��
            )
          )
          ; �����o�������̔��f
          (cond
            ((= #iRad 0) (setq #ViewZ$ Exp_S_View))
            ((< #iRad 0) (setq #ViewZ$ Exp_SM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_SP_View))
          )
          (if (and (/= #BrkD$ nil) (/= #iDExp 0))
            (progn

              (setq #BrkD$ (SKESortBreakLine (list 1 #BrkD$) #SymPos$)); �u���[�N���C������_���牓�����Ƀ\�[�g����
              ; D �����̐L�k����
;;;@YM@             (if (and (= CG_Type2Code "W") (= CG_LRCODE "R") (equal #ViewZ$ (list 0 -1 0)))
;;;@YM@               (progn
;;;@YM@                 (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 3 (- #iDExp #iDSize)))
;;;@YM@               )
;;;@YM@               (progn
;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU T)
;--2011/07/21 A.Satoh Add - E
                  (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 2 (- #iDExp #iDSize)))
;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU nil)
;--2011/07/21 A.Satoh Add - E
;;;@YM@               )
;;;@YM@             )

              (CFOutStateLog 1 7 "        SKEExpansion=D�u���[�N OK"); ����I��
            )
            ;; else
            (progn

              (CFOutStateLog 1 7 "        SKEExpansion=D�u���[�N�Ȃ�"); ����I��
            )
          )

          (foreach #nn #expData$ ; �L�k��Ɖ�w���猳�̉�w�ɐ}�`�f�[�^���ړ�����
            (setq #Temp$ (entget (nth 0 #nn) '("*")))
            (entmod
              (subst (cons 8 (nth 1 #nn)) (cons 8 Exp_Temp_Layer) #Temp$)
            )
          )

          (CFOutStateLog 1 7 "      SKEExpansion=OK End"); ����I��
          T   ; return;
        )
        ; else
        (progn    ; �V���{���̊g���f�[�^���擾�ł��Ȃ�����
          (CFOutStateLog 0 7 "      SKEExpansion=\"G_SYM\"�g���f�[�^���擾�ł��܂���ł��� error End"); �ُ�I��
          nil   ; return;
        )
      );_if
    )
    ;; else
    (progn    ; �g���f�[�^���擾�ł��Ȃ�����
      (CFOutStateLog 0 7 "      SKEExpansion=\"G_LSYM\"�g���f�[�^���擾�ł��܂���ł��� error End"); �ُ�I��
      nil   ; return;
    )
  );_if
)
;SKS_Expansion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 01/08/20 YM �ȉ���"KcEXP.lsp"�̊֐���S�Ĉړ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;<HOM>***********************************************************************
; <�֐���>    : CFPwStretch
; <�����T�v>  : Z�������̃|�����C���̈ړ����T�|�[�g�����X�g���b�`
; <�߂�l>    : �����F T      ���s�Fnil
; <�쐬>      : 1998/08/19 -> 1998/08/19, 1998/10/05 -> 1998/10/07   ���� �����Y
; <���l>      : AutoCAD �̕W�� STRETCH �R�}���h���s�b��Ȃ��̂Ŏ���
;***********************************************************************>HOM<
(defun CFPwStretch (
  &enList$      ; �G���e�B�e�B���X�g(�}�`�� �}�`�� ...) or �I���Z�b�g(ssget �Ŏ擾)
  &Pos$         ; �I��̈�
  &Fillter      ; �I���t�B���^
  &StartPos$    ; �L�k�J�n�_���W
  &strExpAmount ; �L�k��
  /
  #enList$      ; �G���e�B�e�B���X�g
  #plList$      ; �|�����C�����W�f�[�^�i�[���X�g((�}�`�� 1�|�����C�����W�f�[�^���X�g) ...)
  #plTemp$      ; �|�����C���̍��W�f�[�^�i�[�p�e���|�������X�g
  #plName       ; �|�����C���}�`���i�[�p
  #iLFlag       ; ���[�v�t���O
  #Temp$        ; �e���|�������X�g
  #nn           ; foreach �p
  #mm           ; foreach �p
  #iLoop        ; ���[�v�p
  #iLoop2       ; ���[�v�p
  #ssEn         ; ssget �擾�f�[�^�i�[�p
  #DIMSS #ELM #EN_LAYER_LIS #ET #I #210 #ENDIM #NEWLAYER #DUMSS
;-- 2011/07/20 A.Satoh Add - S
  #idx #flg #flg2 #en #MEJI$ #ssEn2 #max_x #max_y #min_x #min_y
  #st_pnt$ #pnt_x #pnt_y #pnt_z #gname #enLayer$ #enLayer #orgLayer
;-- 2011/07/20 A.Satoh Add - E
#pnt$	;-- 2011/12/08 Add
#ORG_LAYER #ORG_LAYER_VIEW #SKIP #S_VIEW ;2017/04/17 YM ADD
  )
  ;; �����f�[�^�� ssget �Ŏ擾�����I���Z�b�g�f�[�^���ǂ����̃`�F�b�N
  (if (= (type &enList$) 'PICKSET)
    (progn    ; ssget �Ŏ擾�����I���Z�b�g������
      ;; �I���Z�b�g���G���e�B�e�B���X�g�ɕϊ�
      (setq #iLoop 0)
      (while (< #iLoop (sslength &enList$))
        (setq #enList$ (cons (ssname &enList$ #iLoop) #enList$))
        (setq #iLoop (+ #iLoop 1))
      )
    )
    ;; else
    (progn    ; �I���Z�b�g�ł͂Ȃ�����
      ;; �R�s�[
      (setq #enList$ &enList$)
    )
  )
  (setq #plList$ nil)

  ;; �G���e�B�e�B���X�g�v�f�������[�v
  (foreach #nn #enList$
    ;; �}�`�f�[�^�擾
    (setq #Temp$ (entget #nn))
    ;; �}�`���|�����C���f�[�^���ǂ����̃`�F�b�N
    (if (= (cdr (assoc 0 #Temp$)) "LWPOLYLINE")
      (progn    ; �}�`�f�[�^���|�����C��������
        (setq #plName nil)
        (setq #plTemp$ nil)
        ;; �f�[�^�\���v�f�������[�v
        (foreach #mm #Temp$
          ;; ���W�f�[�^���ǂ����̃`�F�b�N
          (if (= (car #mm) 10)
            (progn    ; ���W�f�[�^������
              ;; �����ݒ肪�ł��Ă��邩�ǂ����̃`�F�b�N
              (if (= #plName nil)
                (progn    ; �ł��Ă��Ȃ�����
                  (setq #plName #nn)    ; �����l���
                  (setq #plTemp$ (list (cdr #mm)))
                )
                ;; else
                (progn    ; �ł��Ă���
                  (setq #plTemp$ (append #plTemp$ (list (cdr #mm))))    ; �f�[�^�ǉ�
                )
              )
            )
          )
        )
        ;; �����ݒ肪�ł��Ă��邩�ǂ����̃`�F�b�N
        (if (= #plList$ nil)
          (progn    ; �ł��Ă��Ȃ�����
            (setq #plList$ (list (list #plName #plTemp$)))    ; �����l���
          )
          ;; else
          (progn    ; �ł��Ă���
            (setq #plList$ (append #plList$ (list (list #plName #plTemp$))))    ; �f�[�^�ǉ�
          )
        )

      )
    )
  )

  (setq #ssEn
    (ssget "C"
      (nth 0 &Pos$)
      (nth 1 &Pos$)
      &Fillter ; ((8 . "EXP_TEMP_LAYER"))
    )
  )


  ;DIMENSION�͐L�k�Ώۂ��珜��(��w"TEMP_DIM_LAYER"�Ɉڂ�) ; 01/03/12 YM ADD START
  (setq #dimSS (ssadd))
  (setq #i 0)
  (repeat (sslength #ssEn) ; ����O���[�v���̑S�}�`
    (setq #elm (ssname #ssEn #i)) ; �e�v�f
    (setq #et  (entget #elm))
    (if (= (cdr (assoc 0 #et)) "DIMENSION") ; ���@�ȊO 00/03/22 YM ADD
      (ssadd #elm #dimSS)
    );_if
    (setq #i (1+ #i))
  );_(repeat

  (setq #en_Layer_lis (Chg_SStoEnLayer #dimSS))         ; ؽ�--->(<�}�`��> ��w)��ؽĂ�ؽĂɕϊ�
  (MakeTempLayer2 "TEMP_DIM_LAYER")                     ; ���@�L�k��Ɨp�e���|������w�̍쐬
  (if (and #dimSS (> (sslength #dimSS) 0))
    (command "chprop" #dimSS "" "LA" "TEMP_DIM_LAYER" "") ; �Ώې}�`�������ذ��w�ֈړ�
  );_if

;2011/07/04 YM MOD-S �������Ȃ肷����EP�������L�k�ł��Ȃ�(�S�̽ްт���NG)
(command "_.zoom" "W" (nth 0 &Pos$) (nth 1 &Pos$))
  ; 01/06/05 YM ADD
;;;  (command "_zoom" "0.5x") ; ��ʂ��肬�肾�ƈꕔ�}�`����گ��ł��Ȃ��悤�ł���

;2011/07/04 YM MOD-E �������Ȃ肷����EP�������L�k�ł��Ȃ�

  ; 01/03/12 YM ADD END
  (if #ssEn
    (progn
;-- 2011/07/20 A.Satoh Add - S
      (if (= CG_OKU T)
        (progn
          ; ���g�}�`�𕪉�����i����̂܂܂ł̓X�g���b�`�o���Ȃ��ׁj
          (setq #idx 0)
          (setq #flg T)
          (setq #enLayer$ nil)
          (repeat (sslength #ssEn)
            (if (= #flg T)
              (progn
                (setq #en (ssname #ssEn #idx))
                (setq #MEJI$ (CFGetXData #en "G_MEJI"))
                (if (/= #MEJI$ nil)
                  (progn
                    (setq #flg nil)

                    ; �L�k���s���}�`�����X�g�ύX�p�}�`���X�g�ɔ��g�}�`����ݒ肷��
                    (setq CG_EXPDATA$ (list #en))

                    ; �O���[�v�����擾
                    (setq #gname (SKGetGroupName #en))

                    ; ���g�}�`�𕪉�����
                    (command "_.EXPLODE" #en)

                    (setq #ssEn2 (ssget "P"))
                  )
                )
              )
            )
            (setq #idx (1+ #idx))
          )
        )
      )
;-- 2011/07/20 A.Satoh Add - E

      ;; �X�g���b�`���s
      (command
        "_.stretch"
          (ssget "C"
            (nth 0 &Pos$)
            (nth 1 &Pos$)
            &Fillter
          )
        ""    ; �I���m��
        &StartPos$    ; �L�k�J�n�_
        &strExpAmount    ; �L�k��
      )

;-- 2011/07/20 A.Satoh Add - S
;2011/07/25 YM ADD �����ǉ�:��̐L�k���AG_MEJI���Ȃ�����#ssEn2=nil�ƂȂ��Ĉȉ��̏����ŗ�����̂�nil�łȂ����Ƃ������ɉ�����
;;;      (if (= CG_OKU T)
      (if (and #ssEn2 (= CG_OKU T)(< 0 (sslength #ssEn2)) )
        (progn
          ; UCS�ύX
          ;; UCS�ϊ��p���W���X�g�쐬
          (setq #idx 0)
          (setq #pnt$ nil)
          (setq #max_x nil #max_y nil #min_x nil #min_y nil)
          (repeat (sslength #ssEn2)
            (setq #en (ssname #ssEn2 #idx))
            (setq #st_pnt$ (cdr (assoc 10 (entget #en))))
            (setq #pnt_x (nth 0 #st_pnt$))
            (setq #pnt_z (nth 1 #st_pnt$))
            (setq #pnt_y (nth 2 #st_pnt$))

            (if (= #max_x nil)
              (setq #max_x #pnt_x)
              (if (< #max_x #pnt_x)
                (setq #max_x #pnt_x)
              )
            )
            (if (= #max_y nil)
              (setq #max_y #pnt_y)
              (if (< #max_y #pnt_y)
                (setq #max_y #pnt_y)
              )
            )
            (if (= #min_x nil)
              (setq #min_x #pnt_x)
              (if (> #min_x #pnt_x)
                (setq #min_x #pnt_x)
              )
            )
            (if (= #min_y nil)
              (setq #min_y #pnt_y)
              (if (> #min_y #pnt_y)
                (setq #min_y #pnt_y)
              )
            )
            (setq #idx (1+ #idx))
          )
          (setq #pnt$ (list (list #min_x #pnt_z #min_y) (list #max_x #pnt_z #min_y) (list #max_x #pnt_z #max_y) (list #min_x #pnt_z #max_y)))

          (command "_.UCS" (nth 0 #pnt$) (nth 1 #pnt$) (nth (1- (length #pnt$)) #pnt$))

          ; �|�����C����
          (command "_.PEDIT" "M")
          (setq #idx 0)
          (repeat (sslength #ssEn2)
            (command (ssname #ssEn2 #idx))
            (setq #idx (1+ #idx))
          )
          (command "" "Y" "J" "" "C" "")

          (setq #en (entlast))

          ; �L�k���s���}�`�����X�g�ύX�p�}�`�����X�g�ɕ�����̔��g�}�`����ݒ肷��
          (setq CG_EXPDATA$ (append CG_EXPDATA$ (list #en)))

          ; �|�����C���}�`���O���[�v�Ɋ܂߂�
          (command "_.GROUP" "A" #gname #en "")

          ; UCS�����ɖ߂�
          (command "_.UCS" "P")
        )
      )
;-- 2011/07/20 A.Satoh Add - E

      ; 01/06/05 YM ADD
      (command "zoom" "p") ; ��ʂ��肬�肾�ƈꕔ�}�`����گ��ł��Ȃ��悤�ł���

;;;01/03/12YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/03/12YM@      ; �������޺����,��АL�k����ގ�,�L�k�ł��Ȃ�DIMENSION���گ� 01/01/23 01/01/27 YM
;;;01/03/12YM@      (if (or KEKOMI_COM CG_TOKU_H CG_TOKU_D)
;;;01/03/12YM@        (progn
;;;01/03/12YM@          (PK_KEKOMI_DIM_Stretch
;;;01/03/12YM@            "R" ; �E����
;;;01/03/12YM@            &Pos$            ; �L�k�J�n�_���W
;;;01/03/12YM@            &Fillter         ; �L�k��
;;;01/03/12YM@            &StartPos$       ; �L�k�J�n�_
;;;01/03/12YM@            &strExpAmount    ; �L�k��
;;;01/03/12YM@          )
;;;01/03/12YM@        )
;;;01/03/12YM@      );_if
;;;01/03/12YM@
;;;01/03/12YM@      (if (or KEKOMI_COM CG_TOKU_H)
;;;01/03/12YM@        (progn
;;;01/03/12YM@          (PK_KEKOMI_DIM_Stretch
;;;01/03/12YM@            "L" ; ������
;;;01/03/12YM@            &Pos$            ; �L�k�J�n�_���W
;;;01/03/12YM@            &Fillter         ; �L�k��
;;;01/03/12YM@            &StartPos$       ; �L�k�J�n�_
;;;01/03/12YM@            &strExpAmount    ; �L�k��
;;;01/03/12YM@          )
;;;01/03/12YM@        )
;;;01/03/12YM@      );_if ;  01/01/23 YM (��АL�k��)
;;;01/03/12YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    )
    ;; else
    (progn
      (princ "\n*** �I��������܂���ł��� ****************************\n\n")
    )
  );_if

  ; ���@�ȊO�L�k���ς�

  ; ���@�P���L�k����; 01/03/12 YM ADD START
  (setq #i 1)
  (foreach dum #en_Layer_lis ; (<�}�`��> ��w)
    (setq #enDIM (car dum))

		; DIMENSION�̌��̉�w�����߂� 2017/04 17 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		(if CG_ORG_Layer$
			(progn
				;�������@���ݐL�k�Ώۃr���[����@������
				(setq #S_VIEW nil)
;;;     (setq CG_TOKU_BW #BrkW)
;;; 	  (setq CG_TOKU_BD nil)
;;;	   	(setq CG_TOKU_BH nil)
				(if CG_TOKU_BW (setq #S_VIEW "W")) ;�@�Е����L�k��
				(if CG_TOKU_BD (setq #S_VIEW "D")) ;���s�����L�k��
				(if CG_TOKU_BH (setq #S_VIEW "H")) ;���������L�k��

				(setq #org_Layer (cadr (assoc (car dum) CG_ORG_Layer$)))
				(setq #org_Layer_View (substr #org_Layer 1 4)) ;"Z_01"
				;�������@����Ώۉ�w���ǂ�������@������
				(setq #SKIP nil) ; SKIP���邩�ǂ���
				(cond
					((= #S_VIEW "W")
						(if (= #org_Layer_View "Z_01") (setq #SKIP T) );����SKIP
				 	)
					((= #S_VIEW "D")
						(if (= #org_Layer_View "Z_01") (setq #SKIP T) );����SKIP
				 	)
					((= #S_VIEW "H")
						(if (= #org_Layer_View "Z_01") (setq #SKIP T) );����SKIP
				 	)
					(T
						(setq #SKIP nil)
				 	)
				);cond


			)
		);_if

    (setq #210 (cdr (assoc 210 (entget #enDIM))))
    (setq #newLAYER (strcat "TEMP_DIM_LAYER" (itoa #i))) ; ���@�P���ʉ�w�쐬
    (MakeTempLayer2 #newLAYER) ; ���@�L�k��Ɨp�e���|������w�̍쐬
    (if #enDIM
      (command "chprop" #enDIM "" "LA" #newLAYER "") ; �Ώې}�`�������ذ��w�ֈړ�
    );_if

    ;; VPOINT �ύX �E���ʐ}
    (command "_.vpoint" #210) ; ���@�����o������������ޭ��ɂ���
    ;; UCS �ύX
    (command "_.UCS" "V")

    (setq #dumSS
      (ssget "C"
        (nth 0 &Pos$)
        (nth 1 &Pos$)
        (list (cons 8 #newLAYER))
      )
    )

		;2017/04/17 YM MOD-S
    (if (and (= #SKIP nil) (/= #dumSS nil))
;;;    (if (/= #dumSS nil)
      (progn
        ;; �X�g���b�`���s
        (command
          "_.stretch"
            (ssget "C"
              (nth 0 &Pos$)
              (nth 1 &Pos$)
              (list (cons 8 #newLAYER))
            )
          ""    ; �I���m��
          &StartPos$    ; �L�k�J�n�_
          &strExpAmount    ; �L�k��
        )
      )
    );_if

    ;; UCS �ύX
    (command "_.UCS" "P") ; ���O�ɖ߂�
    ;; VPOINT �r���[��߂�
    (command "zoom" "p")
    (setq #i (1+ #i))
  );foreach

  (BackLayer #en_Layer_lis) ; ��w�����ɖ߂�
  ; 01/03/12 YM ADD END
  

;-- 2011/11/02 A.Satoh Del - S
;  (if (= CG_ACAD_VER "14")
;    (progn
;-- 2011/11/02 A.Satoh Del - E
      ;; �|�����C���̃f�[�^�`�F�b�N
      (foreach #nn #plList$
        ;; �|�����C���̃f�[�^�擾
        (setq #plTemp$ (entget (car #nn)))
;-- 2011/12/13 A.Satoh Add - S
				(if #plTemp$
					(progn
;-- 2011/12/13 A.Satoh Add - E
        (setq #iLoop  0)
        (setq #iLoop2 0)
        (setq #iLFlag 0)
        ;; �f�[�^�\���v�f�������[�v
        (while (and (< #iLoop (length #plTemp$)) (= #iLFlag 0))
          ;; �f�[�^�����W�f�[�^���ǂ����̃`�F�b�N
          (if (= (car (nth #iLoop #plTemp$)) 10)
            (progn    ; ���W�f�[�^������
              ;; �����W�Ɣ�r(�ǂ����A�኱�덷���o��悤�Ȃ̂ŁA�����_��5�ʈȉ��͐؂�̂Ă�)
              (if (> (distance (cdr (nth #iLoop #plTemp$)) (nth #iLoop2 (nth 0 (cdr #nn)))) 0.0001)
                (progn    ; �����W�ƈႤ�l������
                  ;; �|�����C���͈ړ����Ă���̂ŁA���[�v���甲���A���̃f�[�^��
                  (setq #iLFlag 1)
                )
              )
              (setq #iLoop2 (+ #iLoop2 1))
            )
          )
          (setq #iLoop (+ #iLoop 1))
        )

        ;; �|�����C�����ړ����Ă��Ȃ����`�F�b�N
        (if (and (= #iLFlag 0) (/= "3DSOLID" (cdr (assoc 0 (entget (car #nn))))))
          (progn    ; �ړ����Ă��Ȃ�����
;-- 2011/11/02 A.Satoh Del - S
            ;(getstring)
;-- 2011/11/02 A.Satoh Del - E
            ;; �|�����C�����ړ�
            (command
              "_.move"
              (car #nn)
              ""
              "0,0,0"
              &strExpAmount
            )
;-- 2011/11/02 A.Satoh Del - S
            ;(getstring)
;-- 2011/11/02 A.Satoh Del - E
          )
        )
;-- 2011/12/13 A.Satoh Add - S
					)
				)
;-- 2011/12/13 A.Satoh Add - E
      )
;-- 2011/11/02 A.Satoh Del - S
;    )
;  )
;-- 2011/11/02 A.Satoh Del - E
  ;; ����I��
  (CFOutStateLog 1 7 "        CFPwStretch=OK")
  T    ; return;
);CFPwStretch

;;;01/03/12YM@;<HOM>***********************************************************************
;;;01/03/12YM@; <�֐���>    : PK_KEKOMI_DIM_Stretch
;;;01/03/12YM@; <�����T�v>  : �L�k����Ȃ�"DIMENSION"��L�k����(���E���ʂ�����ޭ�)
;;;01/03/12YM@; <�߂�l>    : �Ȃ�
;;;01/03/12YM@; <�쐬>      : 01/01/23 YM
;;;01/03/12YM@; <���l>      :
;;;01/03/12YM@;***********************************************************************>HOM<
;;;01/03/12YM@(defun PK_KEKOMI_DIM_Stretch (
;;;01/03/12YM@  &flg          ; "R" or "L" ���E����
;;;01/03/12YM@  &Pos$         ; �L�k�J�n�_���W
;;;01/03/12YM@  &Fillter      ; �L�k��
;;;01/03/12YM@  &StartPos$    ; �L�k�J�n�_
;;;01/03/12YM@  &strExpAmount ; �L�k��
;;;01/03/12YM@  /
;;;01/03/12YM@  #SS0
;;;01/03/12YM@  )
;;;01/03/12YM@  (if (= &flg "R")
;;;01/03/12YM@    (progn
;;;01/03/12YM@
;;;01/03/12YM@      (Setq #SS0
;;;01/03/12YM@        (ssget "C"
;;;01/03/12YM@          (nth 0 &Pos$)
;;;01/03/12YM@          (nth 1 &Pos$)
;;;01/03/12YM@          (list
;;;01/03/12YM@            (cons -4 "<AND")
;;;01/03/12YM@              (car &Fillter)
;;;01/03/12YM@              (cons 0 "DIMENSION")
;;;01/03/12YM@              (cons 210 '(1 0 0))
;;;01/03/12YM@            (cons -4 "AND>")
;;;01/03/12YM@          )
;;;01/03/12YM@        )
;;;01/03/12YM@      )
;;;01/03/12YM@
;;;01/03/12YM@      (if (and #SS0 (> (sslength #SS0) 0))
;;;01/03/12YM@        (progn
;;;01/03/12YM@
;;;01/03/12YM@          ;; VPOINT �ύX �E���ʐ}
;;;01/03/12YM@          (command "_.vpoint" '(1 0 0))
;;;01/03/12YM@          ;; UCS �ύX
;;;01/03/12YM@          (command "_.UCS" "V")
;;;01/03/12YM@          (command
;;;01/03/12YM@            "_.stretch"
;;;01/03/12YM@            (ssget "C"
;;;01/03/12YM@              (nth 0 &Pos$)
;;;01/03/12YM@              (nth 1 &Pos$)
;;;01/03/12YM@              (list
;;;01/03/12YM@                (cons -4 "<AND")
;;;01/03/12YM@                  (car &Fillter)
;;;01/03/12YM@                  (cons 0 "DIMENSION")
;;;01/03/12YM@                  (cons 210 '(1 0 0))
;;;01/03/12YM@                (cons -4 "AND>")
;;;01/03/12YM@              )
;;;01/03/12YM@            )
;;;01/03/12YM@            ""               ; �I���m��
;;;01/03/12YM@            &StartPos$       ; �L�k�J�n�_
;;;01/03/12YM@            &strExpAmount    ; �L�k��
;;;01/03/12YM@          )
;;;01/03/12YM@          ;; UCS �ύX
;;;01/03/12YM@          (command "_.UCS" "P") ; ���O�ɖ߂�
;;;01/03/12YM@          ;; VPOINT �r���[��߂�
;;;01/03/12YM@          (command "zoom" "p")
;;;01/03/12YM@
;;;01/03/12YM@        )
;;;01/03/12YM@      );if
;;;01/03/12YM@
;;;01/03/12YM@    )
;;;01/03/12YM@  );_if
;;;01/03/12YM@  (if (= &flg "L")
;;;01/03/12YM@    (progn
;;;01/03/12YM@
;;;01/03/12YM@      (Setq #SS0
;;;01/03/12YM@        (ssget "C"
;;;01/03/12YM@          (nth 0 &Pos$)
;;;01/03/12YM@          (nth 1 &Pos$)
;;;01/03/12YM@          (list
;;;01/03/12YM@            (cons -4 "<AND")
;;;01/03/12YM@              (car &Fillter)
;;;01/03/12YM@              (cons 0 "DIMENSION")
;;;01/03/12YM@              (cons 210 '(-1 0 0))
;;;01/03/12YM@            (cons -4 "AND>")
;;;01/03/12YM@          )
;;;01/03/12YM@        )
;;;01/03/12YM@      )
;;;01/03/12YM@
;;;01/03/12YM@      (if (and #SS0 (> (sslength #SS0) 0))
;;;01/03/12YM@        (progn
;;;01/03/12YM@
;;;01/03/12YM@          ;; VPOINT �ύX �����ʐ}
;;;01/03/12YM@          (command "_.vpoint" '(-1 0 0))
;;;01/03/12YM@          ;; UCS �ύX
;;;01/03/12YM@          (command "_.UCS" "V")
;;;01/03/12YM@          (command
;;;01/03/12YM@            "_.stretch"
;;;01/03/12YM@            (ssget "C"
;;;01/03/12YM@              (nth 0 &Pos$)
;;;01/03/12YM@              (nth 1 &Pos$)
;;;01/03/12YM@              (list
;;;01/03/12YM@                (cons -4 "<AND")
;;;01/03/12YM@                  (car &Fillter)
;;;01/03/12YM@                  (cons 0 "DIMENSION")
;;;01/03/12YM@                  (cons 210 '(-1 0 0))
;;;01/03/12YM@                (cons -4 "AND>")
;;;01/03/12YM@              )
;;;01/03/12YM@            )
;;;01/03/12YM@            ""    ; �I���m��
;;;01/03/12YM@            &StartPos$    ; �L�k�J�n�_
;;;01/03/12YM@            &strExpAmount    ; �L�k��
;;;01/03/12YM@          )
;;;01/03/12YM@          ;; UCS �ύX
;;;01/03/12YM@          (command "_.UCS" "P") ; ���O�ɖ߂�
;;;01/03/12YM@          ;; VPOINT �r���[��߂�
;;;01/03/12YM@          (command "zoom" "p")
;;;01/03/12YM@
;;;01/03/12YM@        )
;;;01/03/12YM@      );if
;;;01/03/12YM@
;;;01/03/12YM@    )
;;;01/03/12YM@  );_if
;;;01/03/12YM@  (princ)
;;;01/03/12YM@);PK_KEKOMI_DIM_Stretch

;<HOM>***********************************************************************
; <�֐���>    : SKEGetPos
; <�����T�v>  : �}�`���̍ő���W�ƁA�ŏ����W���擾����
; <�߂�l>    : �����F ((�ő���WX,Y,Z) (�ŏ����WX,Y,Z))�@�@�@���s�Fnil
; <�쐬>      : 1998/08/17 -> 1998/08/18   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKEGetPos
  (
    &enList$     ; ���W���擾����}�`�����X�g((�}�`�� ���̉�w��) (�}�`�� ���̉�w��) ..)
  /
    #enName      ; �}�`���i�[�p

    #MaxX        ; �ő�X�l
    #MaxY        ; �ő�Y�l
    #MaxZ        ; �ő�Z�l

    #MinX        ; �ŏ�X�l
    #MinY        ; �ŏ�Y�l
    #MinZ        ; �ŏ�Z�l

    #pos$        ; �e���|�������W�l�i�[�p

    #bPosFlag    ; ���W��r�t���O

    #nn          ; foreach �p
    #mm          ; foreach �p
    #Temp$       ; �e���|�������X�g
    #iHatch      ; �n�b�`���O�}�`��p�̃e���|����
  )
  ;;======================================================================
  ;; �ϐ��̏�����
  ;;======================================================================
  (setq #MaxX nil)

  ;; �}�`�������[�v
  (foreach #nn &enList$
    (setq #enName (car #nn))    ; �}�`���i�[
    (setq #Temp$ (entget #enName '("*")))    ; �}�`�f�[�^�擾
    ;; �f�[�^�v�f�������[�v
    (foreach #mm #Temp$
      ;; ���W�f�[�^���ǂ����̃`�F�b�N
      (if (and (<= (car #mm) 18) (>= (car #mm) 10))
        (progn    ; ���W�f�[�^������
          ;; ���W��r�t���O�N���A
          (setq #bPosFlag nil)
          ;; �f�[�^�̃`�F�b�N(2D���W�n�����}�`���ǂ����̃`�F�b�N)
          (cond
            ((= (cdr (assoc 0 #Temp$)) "LWPOLYLINE")    ; �|�����C��������(2D���W�n�����}�`�f�[�^������)
              ;; ���W�ϊ�
              (setq #pos$ (trans (append (cdr #mm) (list (cdr (assoc 38 #Temp$)))) #enName 1 0))
              ;; ���W��r�t���O�I��
              (setq #bPosFlag 1)
            )
            ((= (cdr (assoc 0 #Temp$)) "LINE")    ; ���C��������(�ό`3D���W�n�����}�`�f�[�^������)
              ;; ���W�ϊ�
              (setq #pos$ (trans (cdr #mm) #enName 1 0))
              ;; ���W��r�t���O�I��
              (setq #bPosFlag 1)
            )
            ; 01/03/26 YM ADD START //////////// �ݸ���ނ̏��ɂ���"ARC"���L�k�͈͂Ɋ܂܂�Ȃ�����
            ((= (cdr (assoc 0 #Temp$)) "ARC")    ; �~�ʂ�����(�ό`3D���W�n�����}�`�f�[�^������)
              ;; ���W�ϊ�
              (setq #pos$ (trans (cdr #mm) #enName 1 0))
              ;; ���W��r�t���O�I��
              (setq #bPosFlag 1)
            )
            ((= (cdr (assoc 0 #Temp$)) "CIRCLE") ; �~������(�ό`3D���W�n�����}�`�f�[�^������)
              ;; ���W�ϊ�
              (setq #pos$ (trans (cdr #mm) #enName 1 0))
              ;; ���W��r�t���O�I��
              (setq #bPosFlag 1)
            )
            ; 01/03/26 YM ADD END //////////// �ݸ���ނ̏��ɂ���"ARC"���L�k�͈͂Ɋ܂܂�Ȃ�����
            ((or (= (cdr (assoc 0 #Temp$)) "HATCH")
                 (= (cdr (assoc 0 #Temp$)) "POINT")
             )
              ;; ���W��r�t���O�I�t
              (setq #bPosFlag 0)
            )
            (T    ; �|�����C���ł͂Ȃ�����(3D���W�n�����}�`�f�[�^������)
              (setq #pos$ (cdr #mm))
              ;; ���W��r�t���O�I��
              (setq #bPosFlag 1)
            )
          )
          ;; ���W��r�t���O���I���ɂȂ��Ă邩�ǂ����̃`�F�b�N
          (if (= #bPosFlag 1)
            (progn    ; �I���ɂȂ��Ă���
              ;; �f�t�H���g���W�l�̓���
              (if (= #MaxX nil)
                (progn    ; �f�t�H���g�����͂���Ă��Ȃ�����
                  (setq #MaxX (nth 0 #pos$))
                  (setq #MaxY (nth 1 #pos$))
                  (setq #MaxZ (nth 2 #pos$))
                  (setq #MinX (nth 0 #pos$))
                  (setq #MinY (nth 1 #pos$))
                  (setq #MinZ (nth 2 #pos$))
                )
                ;; else
                (progn    ; �f�t�H���g�l�͉ߋ��ɓ��͂���Ă���
                  ;; �ő�l�̔��f
                  (if (> (nth 0 #pos$) #MaxX)
                    (progn
                      (setq #MaxX (nth 0 #pos$))
                    )
                  )
                  (if (> (nth 1 #pos$) #MaxY)
                    (progn
                      (setq #MaxY (nth 1 #pos$))
                    )
                  )
                  (if (> (nth 2 #pos$) #MaxZ)
                    (progn
                      (setq #MaxZ (nth 2 #pos$))
                    )
                  )
                  ;; �ŏ��l�̔��f
                  (if (< (nth 0 #pos$) #MinX)
                    (progn
                      (setq #MinX (nth 0 #pos$))
                    )
                  )
                  (if (< (nth 1 #pos$) #MinY)
                    (progn
                      (setq #MinY (nth 1 #pos$))
                    )
                  )
                  (if (< (nth 2 #pos$) #MinZ)
                    (progn
                      (setq #MinZ (nth 2 #pos$))
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )

  ;; ����I��
  (CFOutStateLog 1 7 "        SKEGetPos=OK")
  (list (list #MaxX #MaxY #MaxZ) (list #MinX #MinY #MinZ))    ; return;
)
;SKEGetPos

;<HOM>***********************************************************************
; <�֐���>    : SKEFigureExpansion
; <�����T�v>  : �}�`��L�k����
; <�߂�l>    : �����F T      ���s�Fnil
; <�쐬>      : 1998/08/17 -> 1998/08/17, 1998/10/05 -> 1998/10/07   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKEFigureExpansion (
    &enList$     ; �L�k���s���}�`�̐}�`�����X�g((�}�`�� ���̉�w��) (�}�`�� ���̉�w��) ..)
    &ViewZ$      ; Z ����ł̐��̓_���w��(�����o������)(ex : (0 -1 0))
    &BrkType$    ; �L�k���s���u���[�N���C�����w��(�u���[�N���C���͊�_���牓�����Ƀ\�[�g����Ă��邱�Ƃ�����)
    &iExpSize    ; �L�k����T�C�Y(�L�k���� �L�k�T�C�Y �L�k�t���O)
                 ;                �L�k����=��:0 ��:1 �E:2 ��:3
                 ;                �L�k�t���O=�m�[�}��:1 �A�b�p�[:2
  /
    #Pos$        ; ���ޗ̈�̍ő���W�ƍŏ����W�i�[�p((�ő�X���W �ő�Y���W �ő�Z���W) (�ŏ�X���W �ŏ�Y���W �ŏ�Z���W))
    #PosS$       ; �L�k�̈�n�_���W
    #PosE$       ; �L�k�̈�I�_���W
    #iBrkLine    ; �u���[�N���C���ʒu�i�[�p
    #strExpAmount; �u���[�N���C��1�{������̐L�k�ʊi�[�p

    #strFillLayer; �t�B���^���������w���i�[�p

    #PosTemp$    ; �e���|�������X�g
    #Temp$       ; �e���|�������X�g
    #nn          ; foreach �p
    #bLoop       ; ���[�v�t���O
#EXT_VAL #XX1 #XX2 #YY1 #YY2 ;2010/01/08 YM ADD
  )
  ;; �L�k���s���}�`�̗L���ƐL�k�ʂ��`�F�b�N
  (if (and (/= &enList$ nil) (/= &iExpSize 0))
    (progn    ; �L�k���s���}�`�����݂���
      ;; VPOINT �ύX
      (command "_.vpoint" &ViewZ$)
      ;; UCS �ύX
      (command "_.UCS" "V")

      (setq #strFillLayer (cdr (assoc 8 (entget (nth 0 (nth 0 &enList$))))))
      ; �����̏ꍇ"OFF"�̂��Ƃ�����̂�"ON"�ɂ���@01/03/22 YM ADD
      (command "_layer" "T" #strFillLayer "")
      (command "_layer" "ON" #strFillLayer "")

      ;;======================================================================
      ;; �L�k����
      ;;======================================================================
      (setq #bLoop nil)
      ;; �u���[�N���C���̖{�������[�v����
      (foreach #nn &BrkType$
        ;; �u���[�N���C��1�{������̐L�k�ʎ擾
        (setq #strExpAmount (rtos (/ (nth 1 &iExpSize) (length &BrkType$))))
        ;;======================================================================
        ;; �}�`�̍ő�A�ŏ����W�����߂�(�L�k�Ώ̐}�`�S�Ă�I���ł����`�̈�̒��o)
        ;;======================================================================
        (setq #Pos$ (SKEGetPos &enList$))

        ;; �u���[�N���C���̎�ނɂ���Ďg�p������W���i�荞��
        (setq #Temp$ (CFGetXData #nn "G_BRK"))
        (cond
          ((= (nth 0 #Temp$) 3)    ; H �����u���[�N���C��
            (setq #PosTemp$ (list
                              (list (nth 0 (nth 0 #Pos$)) (nth 1 (nth 0 #Pos$)))
                              (list (nth 0 (nth 1 #Pos$)) (nth 1 (nth 1 #Pos$)))
                            )
            )
            (setq #iBrkLine (nth 1 (trans (cdr (assoc 10 (entget #nn))) 0 1)))
          )
          ((= (nth 0 #Temp$) 1)    ; W �����u���[�N���C��
            (setq #PosTemp$ (list
                              (list (nth 0 (nth 0 #Pos$)) (nth 1 (nth 0 #Pos$)))
                              (list (nth 0 (nth 1 #Pos$)) (nth 1 (nth 1 #Pos$)))
                            )
            )
            (setq #iBrkLine (nth 0 (trans (cdr (assoc 10 (entget #nn))) 0 1)))
          )
          ((= (nth 0 #Temp$) 2)    ; D �����u���[�N���C��
            (setq #PosTemp$ (list
                              (list (nth 0 (nth 0 #Pos$)) (nth 1 (nth 0 #Pos$)))
                              (list (nth 0 (nth 1 #Pos$)) (nth 1 (nth 1 #Pos$)))
                            )
            )
            (setq #iBrkLine (nth 0 (trans (cdr (assoc 10 (entget #nn))) 0 1)))
          )
        );_cond

        ;;======================================================================
        ;; �L�k�ɕK�v�ȃp�����[�^���e�u���[�N���C���̎�ނɂ���Ď擾����
        ;;======================================================================

        ; ��������,��АL�k���͑S�Ă����Ұ����۰��ى� 01/01/27 YM -------------------
;;;       (if (or TOKU_COM KEKOMI_COM)
;;;         (progn
;;;            (setq PosS_0$ (nth 0 #PosTemp$))                         ;; �I���J�n�_���擾
;;;            (setq PosE_0$ (list (nth 0 (nth 1 #PosTemp$)) #iBrkLine));; �I���I�_���擾
;;;            (setq strExpAmount_0 (strcat "@0," #strExpAmount))       ;; �L�k�ʂ��擾
;;;
;;;            (setq PosS_1$ (list (nth 0 (nth 0 #PosTemp$)) (nth 1 (nth 1 #PosTemp$)))) ;; �I���J�n�_���擾
;;;            (setq PosE_1$ (list (nth 0 (nth 1 #PosTemp$)) #iBrkLine))                 ;; �I���I�_���擾
;;;            (setq strExpAmount_1 (strcat "@0," (rtos (* -1.0 (atof #strExpAmount))))) ;; �L�k�ʂ��擾
;;;
;;;            (setq PosS_2$ (nth 0 #PosTemp$))                         ;; �I���J�n�_���擾
;;;            (setq PosE_2$ (list #iBrkLine (nth 1 (nth 1 #PosTemp$))));; �I���I�_���擾
;;;            (setq strExpAmount_2 (strcat "@" #strExpAmount ",0"))    ;; �L�k�ʂ��擾
;;;
;;;            (setq PosS_3$ (list (nth 0 (nth 1 #PosTemp$)) (nth 1 (nth 0 #PosTemp$)))) ;; �I���J�n�_���擾
;;;            (setq PosE_3$ (list #iBrkLine (nth 1 (nth 1 #PosTemp$))))                 ;; �I���I�_���擾
;;;            (setq strExpAmount_3 (strcat "@" (rtos (* -1 (atof #strExpAmount))) ",0"));; �L�k�ʂ��擾
;;;         )
;;;       );_if
        ; ��������,��АL�k���͑S�Ă����Ұ����۰��ى� 01/01/27 YM -------------------


;;;���ʂ��猩���L���r�l�b�g�͈͂�Brk Line,
;;;STRETCH �͈� #PosTemp$ (SKEFigureExpansion)�̊֌W
;;;@1:STRAT
;;;@2:END
;;;
;;;�����
;;;�@+-------------------------@1
;;;
;;;--@2------------------------------- Brk Line
;;;
;;;  +-------------------------+
;;;
;;;������
;;;�@+-------------------------+
;;;
;;;--@2------------------------------- Brk Line
;;;
;;;�@+-------------------------@1
;;;
;;;�E����
;;;              |
;;;�@+-----------|-------------@1
;;;              |
;;;              |
;;;�@+-----------@2------------+
;;;              |
;;;            Brk Line
;;;
;;;������
;;;              |
;;;�@@2----------|-------------+
;;;              |
;;;              |
;;;�@+-----------@1------------+
;;;              |
;;;            Brk Line

        (setq #XX1 (nth 0 (nth 0 #PosTemp$)))
        (setq #YY1 (nth 1 (nth 0 #PosTemp$)))
        (setq #XX2 (nth 0 (nth 1 #PosTemp$)))
        (setq #YY2 (nth 1 (nth 1 #PosTemp$)))
        (setq #EXT_VAL 1000) ; STRETCH�ő傫�ڂɂƂ�l

        (cond
          ((= (nth 0 &iExpSize) 0)    ; ������̐L�k
            (setq #PosS$ (list (+ #XX1 #EXT_VAL) #YY1))                         ;; �I���J�n�_���擾
            (setq #PosE$ (list (- #XX2 #EXT_VAL) #iBrkLine));; �I���I�_���擾
;;;02/02/04YM@MOD            (setq #PosS$ (nth 0 #PosTemp$))                         ;; �I���J�n�_���擾
;;;02/02/04YM@MOD            (setq #PosE$ (list (nth 0 (nth 1 #PosTemp$)) #iBrkLine));; �I���I�_���擾
            (setq #strExpAmount (strcat "@0," #strExpAmount))       ;; �L�k�ʂ��擾
          )
          ((= (nth 0 &iExpSize) 1)    ; �������̐L�k
            (setq #PosS$ (list (+ #XX1 #EXT_VAL) #YY2)) ;; �I���J�n�_���擾
            (setq #PosE$ (list (- #XX2 #EXT_VAL) #iBrkLine))                 ;; �I���I�_���擾
;;;02/02/04YM@MOD            (setq #PosS$ (list (nth 0 (nth 0 #PosTemp$)) (nth 1 (nth 1 #PosTemp$)))) ;; �I���J�n�_���擾
;;;02/02/04YM@MOD            (setq #PosE$ (list (nth 0 (nth 1 #PosTemp$)) #iBrkLine))                 ;; �I���I�_���擾
            (setq #strExpAmount (strcat "@0," (rtos (* -1.0 (atof #strExpAmount))))) ;; �L�k�ʂ��擾
          )
          ((= (nth 0 &iExpSize) 2)    ; �E�����̐L�k
            (setq #PosS$ (list #XX1      (+ #YY1 #EXT_VAL)))                         ;; �I���J�n�_���擾
            (setq #PosE$ (list #iBrkLine (- #YY2 #EXT_VAL)));; �I���I�_���擾
;;;02/02/04YM@MOD            (setq #PosS$ (nth 0 #PosTemp$))                         ;; �I���J�n�_���擾
;;;02/02/04YM@MOD            (setq #PosE$ (list #iBrkLine (nth 1 (nth 1 #PosTemp$))));; �I���I�_���擾
            (setq #strExpAmount (strcat "@" #strExpAmount ",0"))    ;; �L�k�ʂ��擾
          )
          ((= (nth 0 &iExpSize) 3)    ; �������̐L�k
            ; 02/02/04 YM MOD
            (setq #PosS$ (list #iBrkLine (+ #YY2 #EXT_VAL)))                 ;; �I���I�_���擾
            (setq #PosE$ (list #XX2      (- #YY1 #EXT_VAL))) ;; �I���J�n�_���擾
;;;02/02/04YM@MOD            (setq #PosS$ (list (nth 0 (nth 1 #PosTemp$)) (nth 1 (nth 0 #PosTemp$)))) ;; �I���J�n�_���擾
;;;02/02/04YM@MOD            (setq #PosE$ (list #iBrkLine (nth 1 (nth 1 #PosTemp$))))                 ;; �I���I�_���擾
            (setq #strExpAmount (strcat "@" (rtos (* -1 (atof #strExpAmount))) ",0"));; �L�k�ʂ��擾
          )
        );_cond

;-- 2011/12/24 A.Satoh Add - S
(command "_zoom" "e");; ZOOM
(command "_zoom" "0.8x") ; ��ʂ��肬�肾�ƈꕔ�}�`����گ��ł��Ȃ��悤�ł���
;-- 2011/12/24 A.Satoh Add - E
        ;;======================================================================
        ;; 3D �L�k����
        ;;======================================================================
        (SKS_ExpansionSolid
          (nth 0 #Temp$)                              ; �L�k�����t���O(W:1, D:2, H:3)
          #PosS$                                      ; �I���n�_
          (if (/= #bLoop nil)
            (progn
              (if (/= (nth 0 #Temp$) 3)
                (progn
                  (list
                    (-
                      (nth 0 #PosE$)
                      (if (= (nth 2 &iExpSize) 2)
                        (progn
                          (* (/ (nth 1 &iExpSize) (length &BrkType$)) -1)    ; 1�񂠂���̐L�k��
                        )
                        ;; else
                        (progn
                          (/ (nth 1 &iExpSize) (length &BrkType$))    ; 1�񂠂���̐L�k��
                        )
                      )
                    )
                    (nth 1 #PosE$)
                  )
                )
                ;; else
                (progn
                  (list
                    (nth 0 #PosE$)
                    (-
                      (nth 1 #PosE$)
                      (if (= (nth 2 &iExpSize) 2)
                        (progn
                          (* (/ (nth 1 &iExpSize) (length &BrkType$)) -1)    ; 1�񂠂���̐L�k��
                        )
                        ;; else
                        (progn
                          (/ (nth 1 &iExpSize) (length &BrkType$))    ; 1�񂠂���̐L�k��
                        )
                      )
                    )
                  )
                )
              )
            )
            ;; else
            (progn
              #PosE$
            )
          )
          (if (= (nth 2 &iExpSize) 2)
            (progn
;;;01/06/08YM@              (* (nth 1 &iExpSize) -1) ; �L�k��*(-1) ; 01/06/05 YM MOD
              (* (/ (nth 1 &iExpSize) (length &BrkType$)) -1)    ; 1�񂠂���̐L�k��
            )
            ;; else
            (progn
;;;01/06/08YM@              (nth 1 &iExpSize) ; �L�k�� ; 01/06/05 YM MOD
              (/ (nth 1 &iExpSize) (length &BrkType$))    ; 1�񂠂���̐L�k��
            )
          )
          #strFillLayer                                ; �t�B���^�}�X�N��w
          (nth 2 &iExpSize) ; 01/03/01 YM ADD ��t�������t�����̃t���O (1 or 2)
        )
        (setq #bLoop T)
        ;(command "_.-layer" "on" "*" "")

        ;;======================================================================
        ;; �X�g���b�`�R�}���h���g���ĐL�k���s��
        ;;======================================================================
;-- 2011/12/24 A.Satoh Del (�Y�[�������ӏ����u3D �L�k�����v�̑O�ɕύX�j- S
;;;;;;03/12/06 YM ADD C:Automrr �ŐL�k�ł��Ȃ��@�ꎞ����
;;;;;(command "_zoom" "e");; ZOOM
;;;;;(command "_zoom" "0.5x") ; ��ʂ��肬�肾�ƈꕔ�}�`����گ��ł��Ȃ��悤�ł���
;;;;;;03/12/06 YM ADD C:Automrr �ŐL�k�ł��Ȃ��@�ꎞ����
;-- 2011/12/24 A.Satoh Del (�Y�[�������ӏ����u3D �L�k�����v�̑O�ɕύX�j- S

;-- 2011/07/21 A.Satoh Add - S
        ; �L�k���s���}�`�̐}�`�����X�g(�O���[�o���ϐ�)������������
        (setq CG_EXPDATA$ nil)
;-- 2011/07/21 A.Satoh Add - E
        (CFPwStretch
          (ssget "C"  ; �L�k�}�`�̑I��
            #PosS$    ; �I���J�n�_
            #PosE$    ; �I���I�_
            (list (cons 8 #strFillLayer))  ; �I���t�B���^
          )
          (list #PosS$ #PosE$)
          (list (cons 8 #strFillLayer))    ; �I���t�B���^
          #PosS$
          #strExpAmount    ; �L�k��
        )
      )
      ;(command "_.vpoint" (list 0 0 1))

      ;; ����I��
      (CFOutStateLog 1 7 "        SKEFigureExpansion=OK")
      T    ; return;
    )
    ;; else
    (progn    ; �L�k���s���}�`�����݂��Ȃ�����
      ;; ����I��
      (CFOutStateLog 1 7 "        SKEFigureExpansion=�L�k�Ώ̐}�`�����݂��܂���ł��� OK")
      T    ; return;
    )
  )
);SKEFigureExpansion

;<HOM>***********************************************************************
; <�֐���>    : SKESortBreakLine
; <�����T�v>  : �u���[�N���C������_���牓�����Ƀ\�[�g����
; <�߂�l>    : �����F �\�[�g��̃u���[�N���C�������X�g�@�@�@���s�Fnil
; <�쐬>      : 1998/08/19 -> 1998/08/19   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKESortBreakLine
  (
    &BrkLine$    ; �u���[�N���C�������X�g(�u���[�N���C���^�C�v (�u���[�N���C�������X�g))�u���[�N���C���^�C�v=H:2 W:0 D:1
    &Pos$        ; �z�u��_
  /
    #SortLine$  ; �\�[�g��̃u���[�N���C���i�[�p
    #iVal        ; ��_�Ƃ̋����i�[�p

    #Temp$      ; �e���|�����f�[�^���X�g
    #TempData$  ; �e���|�����G���e�B�e�B���i�[�p�ϐ�

    #nn          ; foreach �p
  )
  ;; �ϐ�������
  (setq #SortLine$ nil)

  ;;======================================================================
  ;; �u���[�N���C���̊�_����̋������擾����
  ;;======================================================================
  ;; �u���[�N���C���̗v�f�������[�v
  (foreach #nn (nth 1 &BrkLine$)
    (setq #Temp$ (entget #nn))
    (setq #iVal (distance &Pos$ (cdr (assoc 10 #Temp$))))
    (setq #TempData$ (cons (list #iVal #nn) #TempData$))
  )

; �z�u�p�x���l���ɓ���Ă��Ȃ��̂ł͂Ȃ����� 01/06/05 YM MOD
;;;01/06/05YM@  (foreach #nn (nth 1 &BrkLine$)
;;;01/06/05YM@    (setq #Temp$ (entget #nn))
;;;01/06/05YM@    (setq #iVal (abs (- (nth (car &BrkLine$) &Pos$) (nth (car &BrkLine$) (cdr (assoc 10 #Temp$))))))
;;;01/06/05YM@    (setq #TempData$ (cons (list #iVal #nn) #TempData$))
;;;01/06/05YM@  )
; �z�u�p�x���l���ɓ���Ă��Ȃ��̂ł͂Ȃ����� 01/06/05 YM MOD

  ;;======================================================================
  ;; �u���[�N���C�����\�[�g���A�}�`���������i�[����
  ;;======================================================================
  (setq #Temp$ (CFListSort #TempData$ 0))
  ;(setq #Temp$ (CFSortRecFirstElm #TempData$))
  (foreach #nn #Temp$
    (setq #SortLine$ (cons (nth 1 #nn) #SortLine$))
  )

  ;; ����I��
  (CFOutStateLog 1 7 "        SKESortBreakLine=OK")
  #SortLine$    ; return;
)
;SKESortBreakLine

;<HOM>***********************************************************************
; <�֐���>    : SKEExpansion
; <�����T�v>  : �V���{���ɑ����� 2D �}�`��S�ĐL�k����
; <�߂�l>    : �����F T�@�@�@���s�Fnil
; <�쐬>      : 1998/08/05, 1998/08/17 -> 1998/08/17   ���� �����Y
; <���l>      :
;***********************************************************************>HOM<
(defun SKEExpansion (
  &enSym      ; �L�k���s���V���{���}�`��
  /
  #SymData$   ; �V���{���f�[�^�i�[�p
  #enGroup    ; �V���{���̏�������O���[�v���i�[�p
  #GrpData$   ; �O���[�v�\���}�`��(�O���[�v�̃f�[�^)�i�[�p
  #expData$   ; �L�k�������s���}�`�f�[�^���i�[�p
  #iRad       ; �V���{���̉�]�p�x�i�[�p
  #SymPos$    ; �V���{���̑}���_�i�[�p
  #ViewZ$     ; �����o�������i�[�p
  #iHSize     ; ���݂� H �����̃T�C�Y�i�[�p
  #iWSize     ; ���݂� W �����̃T�C�Y�i�[�p
  #iDSize     ; ���݂� D �����̃T�C�Y�i�[�p
  #iHExp      ; H �����̐L�k���i�[�p
  #iWExp      ; W �����̐L�k���i�[�p
  #iDExp      ; D �����̐L�k���i�[�p
  #BrkH$      ; H �����̃u���[�N���C�����i�[�p
  #BrkW$      ; W �����̃u���[�N���C�����i�[�p
  #BrkD$      ; D �����̃u���[�N���C�����i�[�p
  #bCabFlag   ; �L���r�l�b�g�t���O(�A�b�p�[�L���r�l�b�g:1 ����ȊO:0)
  #Pos$       ; �L�k�Ώ̐}�`�̋�`�̈���W�i�[�p
  #iExpSize   ; �L�k���s���T�C�Y�i�[�p
  #iLoop      ; ���[�v�p
  #nn         ; foreach �p
  #strLayer   ; ��w���i�[�p
  #Temp$      ; �e���|�������X�g
  ;; ���[�J���萔�i�[�p
  Exp_F_View  ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
  Exp_FM_View ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
  Exp_FP_View ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p
  Exp_S_View  ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
  Exp_SM_View ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
  Exp_SP_View ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p
  Exp_Temp_Layer ; �L�k��Ɨp��w���i�[�p
  Upper_Cab_Code ; �O���[�o���萔�p
#STRFILLLAYER
  )
  ;; �L�k�����J�n
  (CFOutStateLog 1 7 "      SKEExpansion=Start")
  ;T    ; return;
  ;; ���[�J���萔�̏�����(�����l���)
  (setq Exp_F_View  '(0 -1 0))  ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_FM_View '(-1 0 0))  ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_FP_View '(1 0 0))   ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_S_View  '(-1 0 0))  ; ��]�p0���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_SM_View '(0 1 0))   ; ��]�p�}�C�i�X���ʎ��_�ʒu�萔�i�[�p
  (setq Exp_SP_View '(0 -1 0))  ; ��]�p�v���X���ʎ��_�ʒu�萔�i�[�p
;;; ���ʂ͍�����Ƃ��Ă���悤�ł��� YM
  (setq Exp_Temp_Layer  "EXP_TEMP_LAYER")  ; �L�k��Ɨp��w��

  ;; �L�k��Ɨp�e���|������w�̍쐬
  (command "_layer" "N" Exp_Temp_Layer "C" 1 Exp_Temp_Layer "L" SKW_AUTO_LAY_LINE Exp_Temp_Layer "")
  ; �����̏ꍇ"OFF"�̂��Ƃ�����̂�"ON"�ɂ���@01/03/22 YM ADD
  (command "_layer" "T" #strFillLayer "")
  (command "_layer" "ON" #strFillLayer "")

  (setq #bCabFlag 0)
  (setq #SymData$ (CFGetXData &enSym "G_LSYM")); �V���{���� "G_LSYM" �g���f�[�^���擾����

  (if (/= #SymData$ nil)                  ; "G_LSYM" �f�[�^���擾�ł������ǂ����̃`�F�b�N
    (progn                                ; �擾�ł���
      (setq #iRad    (nth 2 #SymData$))   ; �擾�����g���f�[�^�����]�p�x(nth 2)���擾����
      (setq #SymPos$ (nth 1 #SymData$))   ; �擾�����g���f�[�^����}���_(nth 1)���擾����
      (setq #Temp$   (nth 9 #SymData$))   ; ���iCODE�擾
      (if (= CG_SKK_TWO_UPP (CFGetSeikakuToSKKCode #Temp$ 2))      ; ���iCODE���A�b�p�[�L���r�l�b�g���ǂ����̃`�F�b�N
        (setq #bCabFlag 1)
      )
      (setq #SymData$ (CFGetXData &enSym "G_SYM"))      ; �V���{���� "G_SYM" �g���f�[�^���擾����

      (if (/= #SymData$ nil)                        ; "G_SYM" �f�[�^���擾�ł������ǂ����̃`�F�b�N
        (progn                                      ; �擾�ł���
          (setq #iWSize (nth 3 #SymData$))          ; �擾�����g���f�[�^���猻�݂� W �T�C�Y(nth 3)���擾����
          (setq #iDSize (nth 4 #SymData$))          ; �擾�����g���f�[�^���猻�݂� D �T�C�Y(nth 4)���擾����
          (setq #iHSize (nth 5 #SymData$))          ; �擾�����g���f�[�^���猻�݂� H �T�C�Y(nth 5)���擾����
          (setq #iWExp  (nth 11 #SymData$))         ; �擾�����g���f�[�^���� W ����(nth 11)�̐L�k�����擾����
          (setq #iDExp  (nth 12 #SymData$))         ; �擾�����g���f�[�^���� D ����(nth 12)�̐L�k�����擾����
          (setq #iHExp  (nth 13 #SymData$))         ; �擾�����g���f�[�^���� H ����(nth 13)�̐L�k�����擾����
          (setq #SymData$ (entget &enSym))          ; �V���{���̃f�[�^���擾����
          (setq #enGroup (cdr (assoc 330 #SymData$)))          ; �V���{���̃O���[�v�����擾����
          (setq #GrpData$ (entget #enGroup))                   ; �O���[�v���f�[�^(�O���[�v�����X�g)���擾����

          (foreach #nn #GrpData$                               ; 2D �}�`�ŐL�k�������s���f�[�^���i�荞�ށB�u���[�N���C���𒊏o����
            (if (= (car #nn) 340)                              ; �O���[�v�\���}�`�����ǂ����̃`�F�b�N
              (progn                                           ; �O���[�v�\���}�`��������
                (setq #Temp$ (entget (cdr #nn)))               ; �O���[�v�\���}�`���̃f�[�^���擾����

                (if (/= (cdr (assoc 0 #Temp$)) "XLINE")        ; �O���[�v�\���}�`���\���b�h�f�[�^(0 . "3DSOLID")�ȊO���ǂ����̃`�F�b�N

                  (progn    ; �\���b�h�f�[�^�ł͂Ȃ�����
                    (setq #strLayer (cdr (assoc 8 #Temp$)))    ; ��w���̎擾
                    (setq #expData$ (cons (list (cdr #nn) #strLayer) #expData$)) ; �}�`���Ɖ�w����1���X�g�ɂ��Ċi�[����(�}�`�� ��w��)
                    (entmod  ; �L�k�Ώ̐}�`��L�k������w�Ɉړ�����
                      (subst (cons 8 Exp_Temp_Layer) (assoc 8 #Temp$) #Temp$)
                    )
                  )
                )
                (if (= (cdr (assoc 0 #Temp$)) "XLINE")                ; �O���[�v�\���}�`���u���[�N���C�����ǂ����̃`�F�b�N
                  (progn    ; �u���[�N���C��������
                    (setq #Temp$ (CFGetXData (cdr #nn) "G_BRK")); �u���[�N���C���̊g���f�[�^���擾
                    (if (/= #Temp$ nil) ; �g���f�[�^�����݂��邩�ǂ����̃`�F�b�N
                      (progn    ; �g���f�[�^�����݂���
                        (cond ; H,W,D �e�u���[�N���C���̎�ޖ��ɐ}�`�����i�[����
                          ((= (nth 0 #Temp$) 1) (setq #BrkW$ (cons (cdr #nn ) #BrkW$))); W �����u���[�N���C��������
                          ((= (nth 0 #Temp$) 2) (setq #BrkD$ (cons (cdr #nn ) #BrkD$))); D �����u���[�N���C��������
                          ((= (nth 0 #Temp$) 3) (setq #BrkH$ (cons (cdr #nn ) #BrkH$))); H �����u���[�N���C��������
                        )
                      )
                    )
                  )
                )
              )
            )
          )
          ;; �L�k����
          ;; �����o�������̔��f
          (cond
            ((= #iRad 0) (setq #ViewZ$ Exp_F_View))
            ((< #iRad 0) (setq #ViewZ$ Exp_FM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_FP_View))
          )
          ;; �L�k���s���T�C�Y�̃`�F�b�N(�A�b�p�[�L���r�l�b�g�̏ꍇ�� +- ���t�])
          (if (and (= #bCabFlag 1) (/= #iHExp 0))
            (progn
              (setq #iExpSize (list 1 (- #iHExp #iHSize) 2))
            )
            ;; else
            (progn
              (setq #iExpSize (list 0 (- #iHExp #iHSize) 1))
            )
          )
          (if (and (/= #BrkH$ nil) (/= #iHExp 0))
            (progn ; �u���[�N���C������_���牓�����Ƀ\�[�g����
              (setq #BrkH$ (SKESortBreakLine (list 2 #BrkH$) #SymPos$))
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkH$ #iExpSize)              ; H �����̐L�k����
              (CFOutStateLog 1 7 "        SKEExpansion=H�u���[�N OK")              ; ����I��
            )
            ;; else
            (progn
              (CFOutStateLog 1 7 "        SKEExpansion=H�u���[�N�Ȃ�")              ; ����I��
            )
          )

          (if (and (/= #BrkW$ nil) (/= #iWExp 0))
            (progn              ; �u���[�N���C������_���牓�����Ƀ\�[�g����
              (setq #BrkW$ (SKESortBreakLine (list 0 #BrkW$) #SymPos$))
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkW$ (list 2 (- #iWExp #iWSize))) ; W �����̐L�k����
              (CFOutStateLog 1 7 "        SKEExpansion=W�u���[�N OK")              ; ����I��
            )
            ;; else
            (progn
              (CFOutStateLog 1 7 "        SKEExpansion=W�u���[�N�Ȃ�")              ; ����I��
            )
          )

          (cond          ;; �����o�������̔��f
            ((= #iRad 0) (setq #ViewZ$ Exp_S_View))
            ((< #iRad 0) (setq #ViewZ$ Exp_SM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_SP_View))
          )
          (if (and (/= #BrkD$ nil) (/= #iDExp 0))
            (progn
              (setq #BrkD$ (SKESortBreakLine (list 1 #BrkD$) #SymPos$))              ; �u���[�N���C������_���牓�����Ƀ\�[�g����
              ;; D �����̐L�k����
;;;             (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 3 (- #iDExp #iDSize)))
;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU T)
;--2011/07/21 A.Satoh Add - E
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 2 (- #iDExp #iDSize)))
 ;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU nil)
;--2011/07/21 A.Satoh Add - E
             (CFOutStateLog 1 7 "        SKEExpansion=D�u���[�N OK")              ; ����I��
            )
            ;; else
            (progn
              (CFOutStateLog 1 7 "        SKEExpansion=D�u���[�N�Ȃ�")              ; ����I��
            )
          )

          (foreach #nn #expData$ ; �L�k��Ɖ�w���猳�̉�w�ɐ}�`�f�[�^���ړ�����
            (setq #Temp$ (entget (nth 0 #nn) '("*")))
            (entmod
              (subst (cons 8 (nth 1 #nn)) (cons 8 Exp_Temp_Layer) #Temp$)
            )
          )
          (CFOutStateLog 1 7 "      SKEExpansion=OK End")          ;; ����I��
          T    ; return;
        )
        ;; else
        (progn    ; �V���{���̊g���f�[�^���擾�ł��Ȃ�����
          (CFOutStateLog 0 7 "      SKEExpansion=\"G_SYM\"�g���f�[�^���擾�ł��܂���ł��� error End")          ; �ُ�I��
          nil    ; return;
        )
      )
    )
    ;; else
    (progn    ; �g���f�[�^���擾�ł��Ȃ�����
      (CFOutStateLog 0 7 "      SKEExpansion=\"G_LSYM\"�g���f�[�^���擾�ł��܂���ł��� error End")      ; �ُ�I��
      nil    ; return;
    )
  )
)
;SKEExpansion

(princ)
