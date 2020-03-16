;<HOM>*************************************************************************
; <�֐���>    : C:DelParts
; <�����T�v>  : �ݔ����ނ̍폜
; <�߂�l>    :
; <�쐬>      : 2000-01-26
; <���l>      :
;*************************************************************************>MOH<
(defun C:DelParts (/
       #PD;00/07/03 SN ADD
       )
  (StartUndoErr);00/07/27 SN MOD
  ;(StartCmnErr);00/07/27 SN MOD
  (CFCmdDefBegin 6);00/09/07 SN ADD
  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM

  (PcDeleteItems '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")));00/07/31 SN MOD
  ;(PcDeleteItems);00/07/31 SN MOD
  ;(SC_DeleteParts nil) 00/05/26 MH ���������ɍX
  (CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  (setvar "pdmode" #PD) ; 06/12 YM
  (princ "\n���ނ��폜���܂����B")
  (princ)
);C:DelParts

;<HOM>*************************************************************************
; <�֐���>    : C:DelPartsCnt
; <�����T�v>  : �ݔ����ނ̍폜�i�A�����[�h�j
; <�߂�l>    :
; <�쐬>      : 2000-01-26
; <���l>      :
;*************************************************************************>MOH<
(defun C:DelPartsCnt (/
       #PD;00/07/03 SN ADD
       )
  ;00/07/27 SN MOD �r���Ŵװ�I��������PDMODE�����ɖ߂�Ȃ��s��C��

  (StartUndoErr);00/07/27 SN MOD
  ;(StartCmnErr);00/07/27 SN MOD
  ;(CFCmdDefBegin 6);00/09/07 SN ADD
  ; 00/07/27 SN MOD PDMODE�̐ؑւ͓����ōs��
  ;(setq #PD (getvar "pdmode")) ; 06/12 YM
  ;(setvar "pdmode" 34)         ; 06/12 YM

  (SC_DeleteParts T)
  ;(CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  ; 00/07/27 SN MOD PDMODE�̐ؑւ͓����ōs��
  ;(setvar "pdmode" #PD) ; 06/12 YM

  (princ)
);C:DelPartsCnt

;<HOM>*************************************************************************
; <�֐���>    : C:DelWkTop
; <�����T�v>  : ���[�N�g�b�v�̍폜
; <�߂�l>    :
; <�쐬>      :
; <���l>      : 00/07/12 C:DelParts�̓��e�ƍ����ւ�
;*************************************************************************>MOH<
(defun C:DelWkTop (/
       #PD;00/07/03 SN ADD
       )
  (StartUndoErr) ;00/07/31 SN MOD
  ;(StartCmnErr) ;00/07/31 SN MOD
  (CFCmdDefBegin 6);00/09/07 SN ADD
  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM

  (PcDeleteItems '(("G_WRKT")));00/07/31 SN MOD
  ;(PcDeleteItems);00/07/31 SN MOD
  ;(SC_DeleteParts nil) 00/05/26 MH ���������ɕύX
  (CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  (setvar "pdmode" #PD) ; 06/12 YM

  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : C:DelFiler
; <�����T�v>  : �V��t�B���[�̍폜
; <�߂�l>    :
; <�쐬>      : 2000-01-26
; <���l>      :
;*************************************************************************>MOH<
(defun C:DelFiler (/
       #PD;00/07/03 SN ADD
       )
  ;00/07/27 SN MOD �r���Ŵװ�I��������PDMODE�����ɖ߂�Ȃ��s��C��
  
  ;// �R�}���h�̏�����
  (StartUndoErr);00/07/27 SN MOD
  ;(StartCmnErr);00/07/27 SN MOD
  ;(CFCmdDefBegin 6);00/09/07 SN ADD
  
  ; 00/07/27 SN MOD PDMODE�̐ؑւ͓����ōs��
  ;(setq #PD (getvar "pdmode")) ; 06/12 YM
  ;(setvar "pdmode" 34)         ; 06/12 YM

  (SC_DeleteParts nil)
  ;(CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  ; 00/07/27 SN MOD PDMODE�̐ؑւ͓����ōs��
  ;(setvar "pdmode" #PD) ; 06/12 YM

  (princ)
)
;C:DelFiler

;<HOM>*************************************************************************
; <�֐���>    : PcDeleteItems
; <�����T�v>  : �ݔ����ނ̍폜�iLSYM,FILER,WORKTOP) �����I����
; <�߂�l>    :
; <�쐬>      : 2000-05-26 MH
; <���l>      : �I����P�A�C�e���Âw�菜�O�ł���
;*************************************************************************>MOH<
(defun PcDeleteItems (
  &XDataLst$$;00/07/31 SN ADD �폜�Ώۂ�XDATA����ؽĂœn���B
  /
  #ss #GLPss #i #ii #en #WTDEL$ #DEL$ #DL #NEW$ #enR #enREM
  #WT ;00/07/31 SN ADD
  )
  ;(StartUndoErr);// �R�}���h�̏����� ;00/07/03 SN MOD ���ď���
  (setq #ss (ItemSel &XDataLst$$ CG_InfoSymCol))

  ; �I�����ꂽ�}�`���`�F�b�N �폜���X�g�Ɏ擾
  (if #ss (progn
    (setq #i 0)
    (while (< #i (sslength #ss))
      (cond
        ((and
          (setq #en (ssname #ss #i))
          ;00/07/31 SN MOD
          (CheckXData #en (nth 0 &XDataLst$$))
          ;(or (CFGetXData #en "G_WRKT")
          ;    (CFGetXData #en "G_BKGD")
          ;    (CFGetXData #en "G_FILR"))
          (not (member #en #WTDEL$))); and
          ; �������݂��������̂�F�ւ�&���X�g��
          ;(GroupInSolidChgCol2 #en CG_InfoSymCol) 00/09/18 SN MOD �F�ύX�͑I���֐����ōs��
          (setq #WTDEL$ (cons #en #WTDEL$))
          ; ���̐}�`���� #ss���珜��
          (ssdel #en #ss)
          (setq #i 0) ; #ss�̓��e���ς��������A #i���Z�b�g
        )
        ((and (setq #en (SearchGroupSym (ssname #ss #i)))
              (not (member #en #DEL$))(CFGetXData #en "G_LSYM");)
          (CheckXData #en (nth 1 &XDataLst$$)))   ;00/07/31 SN MOD
          ; �O���[�v�}�`�F�ւ�&�폜���X�g�ǉ�
          ;(GroupInSolidChgCol2 #en CG_InfoSymCol) 00/09/18 SN MOD �F�ύX�͑I���֐����ōs��
          (setq #DEL$ (cons #en #DEL$))
          ; ���̃O���[�v�e�q�}�`�����ׂ�#ss���珜��
          (setq #GLPss (CFGetSameGroupSS #en))
          (setq #ii 0)
          (while (< #ii (sslength #GLPss))
            (ssdel (ssname #GLPss #ii) #ss)
            (setq #ii (1+ #ii))
          );while
          (setq #i 0) ; #ss�̓��e���ς��������A #i���Z�b�g
        )
        (t (setq #i (1+ #i)))
      );cond
    ); while
  )); if progn

  ; WT�폜���X�g�Ɏc����WT�ƃt�B���[�폜���s
  (foreach #DL #WTDEL$
    (cond
      ((CFGetXData #DL "G_FILR") (SCW_DelFiler #DL))
      ((or (CFGetXData #DL "G_WRKT")
           (CFGetXData #DL "G_BKGD"))
        (GroupInSolidChgCol2 #DL "BYLAYER") ; �F��߂�
        (PCW_DelWkTop nil #DL))  ; 07/03 YM MOD
;;;        (PCW_DelWkTop 1 #DL)) ; 07/03 YM MOD
    );cond
  )

  ; 00/06/22 SN S-ADD �폜�ΏۃA�C�e���̐F��߂��B
  (foreach #DL #DEL$
    (if (and (CFGetXRecord "BASESYM")                          ; ����т����ݒ�
             (= (cdr (assoc 5 (entget #DL))) (car (CFGetXRecord "BASESYM")))) ; ����т� &ss �ɓ����Ă���
      (GroupInSolidChgCol2 #DL CG_BaseSymCol)
      (GroupInSolidChgCol2 #DL "BYLAYER")
    )
  ); foreach
  ; 00/06/22 SN E-ADD

  ; �폜���X�g�Ɏc�����A�C�e���폜���s
;;; (command "vpoint" "0,0,1") ;  "LWPOLYLINE"  ��w: "Z_wtbase"
  (foreach #DL #DEL$
    (SCY_DelParts #DL nil)
  ); foreach
;;; (command "zoom" "p")
  ; 00/07/10 MH ADD �����I����A��A�C�e���̎��̂��Ȃ���΂w���R�[�h��������
  (if (and (CFGetBaseSymXRec) (not (entget (CFGetBaseSymXRec))))
    (CFSetXRecord "BASESYM" nil))

  (setq *error* nil)
  (princ)
)
;PcDeleteItems

;<HOM>*************************************************************************
; <�֐���>    : SC_DeleteParts
; <�����T�v>  : �ݔ����ނ̍폜�iLSYM,FILER,WORKTOP)
; <�߂�l>    :
; <�쐬>      : 2000-01-26
; <���l>      :
;*************************************************************************>MOH<
(defun SC_DeleteParts (
    &CntFlg
    /
    #en #XD
    #PD ;00/07/27 SN ADD
  #SNAPMODE #GRIDMODE #ORTHOMODE #OSMODE ; 00/09/12 SN ADD
  )

  (CFCmdDefBegin 6);00/09/26 SN ADD

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SC_DeleteParts ////")
  (CFOutStateLog 1 1 " ")

  (setq #PD (getvar "pdmode")); 00/07/27 SN ADD

  ;// ���[�N�g�b�v�̎w��
  (setq #en T)
  (while #en
    (setvar "pdmode" 34)  ;00/07/27 SN
    (initget "U")
;;;    (setq #en (entsel "\n�폜����A�C�e����I��/U=�߂�/: "))
    (setq #en (entsel "\n�폜����A�C�e����I��: "))
    (setvar "pdmode" #PD) ;00/07/27 SN ��UPDMODE��߂�
    (cond
      ((= #en "U")
        (command "_.undo" "b")
      )
      ((= #en nil)
        (princ)
      )
      (T
        (setq #en (car #en))
        (cond
          ((setq #xd (CFGetXData #en "G_WRKT"))
;;;           (if (> (length #xd) 50)
              (PCW_DelWkTop 1 #en)    ; 00/04/07 YM ADD �V�^�̍폜 �폜����ގ��׸�=1
;;;             (SCW_DelWkTop #en)    ; ���^�̍폜
;;;           )
          )
          ((setq #xd (CFGetXData #en "G_BKGD")) ; 00/03/18 YM ADD
;;;           (if (< (length #xd) 4)
;;;             (PCW_DelBKGD #en)     ; 00/04/07 YM ADD �V�^�̍폜
              (PCW_DelWkTop 1 #en)    ; 00/04/07 YM ADD �V�^�̍폜 �폜����ގ��׸�=1  ; 04/25 YM
;;;             (SCW_DelBKGD #en)     ; ���^�̍폜
;;;           )
          )
;;;          ((CFGetXData #en "G_FRGD") ; 00/04/07 YM ADD
;;;            (PCW_DelFRGD #en)        ; 00/04/07 YM ADD
;;;          )

          ((CFGetXData #en "G_FILR")
            (SCW_DelFiler #en)
          )
          ((CFGetXData #en "G_ROOM")
            (CFYesDialog "�I�������}�`�͊Ԍ��̈�ł��@")
          )
          ((CFGetXData #en "RECT")
            (CFYesDialog "�I�������}�`�͖�̈�ł��@")
          )
          (T
            (setq #en (CFSearchGroupSym #en))
            (if #en
              (progn
                (SCY_DelParts #en &CntFlg)
              )
            )
          )
        )
        ;00/09/26 SN S-ADD
        ;հ�ޕύX�̉\��������̂ň�U��荞��
        (setq #SNAPMODE  (getvar "SNAPMODE" ))
        (setq #GRIDMODE  (getvar "GRIDMODE" ))
        (setq #ORTHOMODE (getvar "ORTHOMODE"))
        (setq #OSMODE    (getvar "OSMODE"   ))
        (CFCmdDefEnd);00/09/26 SN ADD
        (command "_.undo" "m");00/07/27 SN UNDOϰ�
        (CFCmdDefStart 6);00/09/26 SN ADD
        ;00/09/26 SN ADD հ�ޕύX�ݒ�Ή�
        ;��U��荞�񂾂��̂����ɖ߂��B
        (setvar "SNAPMODE"  #SNAPMODE )
        (setvar "GRIDMODE"  #GRIDMODE )
        (setvar "ORTHOMODE" #ORTHOMODE)
        (setvar "OSMODE"    #OSMODE   )
      )
    )
  )
  ; 00/07/10 MH ADD �����I����A��A�C�e���̎��̂��Ȃ���΂w���R�[�h��������
  (if (and (CFGetBaseSymXRec) (not (entget (CFGetBaseSymXRec))))
    (CFSetXRecord "BASESYM" nil))
  (CFCmdDefFinish);00/09/26 SN ADD
)
;DeleteParts

;<HOM>*************************************************************************
; <�֐���>    : SCY_DelParts
; <�����T�v>  : �ݔ����ނ̍폜�i�L���r�l�b�g�Ȃ�G_LSYM�������ށj
; <�߂�l>    :
; <�쐬>      : 2000-01-26
; <���l>      :
;*************************************************************************>MOH<
(defun SCY_DelParts (
  &enSym         ;(ENAME)
  &CntFlg        ;(INT)�A�����[�h�t���O
  /
  #DELHAND #DELWTR #DIST #EG$ #EGWTR$ #I #MINDIST #MSG1 #NO #O #SKK #SS #SSWTR #WT
  #DUM$ #EG #HOLE #KOSU #N #SETXD$ #W-XD$ #WT_T
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SCY_DelParts ////")
  (CFOutStateLog 1 1 " ")
  (setq #msg1 "\n�V���N�݂̂̍폜�͂ł��܂���B\n���[�N�g�b�v���폜���Ă��������B")
;;;  (setq #msg2 "���[�N�g�b�v���i�Ԋm�肳��Ă��܂��B\n�����͍폜�ł��܂���")

  (if (Setq #eg$ (entget &enSym)) ; �}�`���폜����Ă��Ȃ���
    (progn
      (setq #skk (nth 9 (CFGetXData &enSym "G_LSYM")))

      (if (= #skk CG_SKK_INT_SUI) ; ���� ; 01/08/31 YM MOD 510-->��۰��ى�
        (progn
          (command "vpoint" "0,0,1")
          (setq #o (cdr (assoc 10 #eg$)))
          (setq #WT (PK_GetWTunderSuisen #o))

          ; �S������"G_WTR"�}�`�擾
          (setq #ssWTR (ssget "X" '((-3 ("G_WTR")))))
          ; �������وʒu�Ɉ�ԋ߂����̂��擾����
          (setq #i 0 #MINdist 1.0e10)
          (if #ssWTR    ; 01/05/24 HN ADD
            (repeat (sslength #ssWTR)
              (setq #egWTR$ (entget (ssname #ssWTR #i)))
              (setq #dist (distance #o (cdr (assoc 10 #egWTR$)))) ; ���������S�_�`��������
              (if (<= #dist #MINdist)
                (progn
                  (setq #MINdist #dist)
                  (setq #delWTR (ssname #ssWTR #i)) ; �������}�`
                  (setq #delHAND (cdr (assoc 5 (entget #delWTR)))) ; �������}�`�����
                )
              );_if
              (setq #i (1+ #i))
            )
          ) ;_if 01/05/24 HN ADD

          (if (> 0.1 #MINdist)  ; 01/05/24 HN ��������ȊO�̐���Ή�
            (progn
              (if #WT ; 01/06/28 YM Lipple WT�Ȃ��ŗ�����
                (progn

                  (setq #w-xd$ (CFGetXData #WT "G_WRKT"))
                  ; �i�Ԋm�肳��Ă����猊����
                  (if (CFGetXData #WT "G_WTSET")
                    (progn
                      (setq #WT_T (nth 10 #w-xd$)) ; WT����
                      (setq #eg (entget #delWTR))
                      (setq #eg (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (cdr #eg)) (cdr #eg)))
                      (setq #eg (subst (cons 62 2) (assoc 62 #eg) #eg))
                      (entmake #eg) ; ������а�쐬
                      (setq #hole (entlast))
                      ;2008/07/28 YM 2009�Ή�
                      (command "_extrude" #hole "" (- #WT_T) ) ;�����o��
;;;                     (command "_extrude" #hole "" (- #WT_T) "") ;�����o��
                      (command "_union" #WT (entlast) "")        ;�a���Z
                    )
                  );_if

                  ; �g���ް�"G_WRKT"�X�V(�������ڍ폜)
                  (setq #kosu (nth 22 #w-xd$))
                  (setq #i 23 #dum$ nil)
                  ; ���ݓo�^����Ă��鐅����ؽĂ���폜�Ώۂ�������ؽ�#dum$�����߂�
                  (repeat #kosu
                    (if (and (/= (nth #i #w-xd$) "")(entget (nth #i #w-xd$))) ; �����Ȑ}�`���łȂ�
                      (if (equal (nth #i #w-xd$) (handent #delHAND)) ; "G_WTR"�}�`��
                        nil
                        (setq #dum$ (append #dum$ (list (nth #i #w-xd$))))
                      );_if
                    );_if
                    (setq #i (1+ #i))
                  )

                  (setq #kosu (1- #kosu)) ; ����-1
                  (setq #setxd$
                    (list
                      (list 22 #kosu)
                    )
                  )
                  (setq #n 23)
                  (foreach #dum #dum$
                    (setq #setxd$ (append #setxd$ (list (list #n #dum))))
                    (setq #n (1+ #n))
                  )
                  (setq #setxd$ (append #setxd$ (list (list #n ""))))

                  ; ������"G_WTR"�폜
                  (entdel (handent #delHAND))

                  ;// ���[�N�g�b�v�g���f�[�^�̍X�V
                  (CFSetXData #WT "G_WRKT"
                    (CFModList #w-xd$ #setxd$)
                  )
                
                )
              );_if 01/06/28 YM Lipple WT�Ȃ��ŗ�����

            )
          ) ;_if  01/05/24 HN ��������ȊO�̐���Ή�

          (command "zoom" "p")
        )
      );_if

      (if (= #skk CG_SKK_INT_SNK) ; �V���N ; 01/08/31 YM MOD 410-->��۰��ى�
        (progn
          (CFAlertMsg #msg1)
          (setq #NO T)
        )
      );_if

    )
  );_if

  ;(command "_.undo" "m") ;00/07/03 SN MOD ���ď���

  (if #NO ; T ==> �ݸ�܂��͐����A�폜���Ȃ�
    (princ)
    (progn ; nil
      (setq CG_BASESYM (CFGetBaseSymXRec))
      (if (equal &enSym CG_BASESYM)
        (progn
          (ResetBaseSym)
          (CFSetXRecord "BASESYM" nil)
          (setq CG_BASESYM nil)
        )
      )
      (if (= &CntFlg T)
        (progn
          ;// �Ώې}�`���ӂ̐}�`���ړ�
          ; (DeleteSymRelMoveSym &enSym) 00/07/17 MH MOD �ړ�������V�֐��ɓ���
          (PcMoveItemAround "DEL" &enSym nil "R"
            (- (nth 3 (CFGetXData (CFSearchGroupSym &enSym) "G_SYM"))) nil)
          (if (/= CG_BASESYM nil)
            (progn
              (ResetBaseSym)
              (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
            )
          )
        )
      )

      (setq #ss (CFGetSameGroupSS &enSym))
      (setq #i 0)
      (repeat (sslength #ss)
        (entdel (ssname #ss #i)) ; �����ō폜
        (setq #i (1+ #i))
      )
    )
  );_if

  ;(command "_.erase" #ss "")
);SCY_DelParts

;<HOM>*************************************************************************
; <�֐���>    : SCW_DelFiler
; <�����T�v>  : �V��t�B���[�̍폜
; <�߂�l>    :
; <�쐬>      : 2000-01-26
; <���l>      :
;*************************************************************************>MOH<
(defun SCW_DelFiler (
  &enFlr         ;(ENAME)�t�B���[�}�`��
  /
  #PL #SS
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SCW_DelFiler ////")
  (CFOutStateLog 1 1 " ")

  ;(command "_.undo" "m") ;00/07/03 SN MOD ���ď���

  (setq #pl (nth 2 (CFGetXData &enFlr "G_FILR")))
  ;(entdel &enFlr)
  (setq #ss (CFGetSameGroupSS &enFlr))
  (if (or (= #ss nil) (= (sslength #ss) 0))
    (entdel &enFlr)
    (command "_.erase" #ss "")
  )
  (entdel #pl)
)
;SCW_DelFiler

;<HOM>*************************************************************************
; <�֐���>    : PCW_DelWkTop
; <�����T�v>  : ���[�N�g�b�v�̍폜
; <�߂�l>    :
; <�쐬>      : 2000-01-26
; <���l>      : �C�� YM 00/04/07 �V�^WT�p
;*************************************************************************>MOH<
(defun PCW_DelWkTop (
  &cmd  ; �폜����ގ�=1 �폜���܂����H�̃��b�Z�[�W��\������ 1�ȊO�̓��b�Z�[�W�Ȃ�
  &wtEn ;(ENAME)ܰ�į�ߐ}�`(�ޯ��ް�ސ}�`�̂��Ƃ�����)
  /
  #EN$ #GASPEN #I #MSG #ONE #SNKPEN
  #SS$ #SS2 #WTL #WTR #XD$ #XD0$
  #WTEN #XD_BG #XD_WT
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PCW_DelWkTop ////")
  (CFOutStateLog 1 1 " ")

;;; BKGD�̂Ƃ�
  (setq #xd_BG (CFGetXData &wtEn "G_BKGD"))
  (if #xd_BG
    (setq #wtEn (nth 2 #xd_BG)) ; WT�}�`��
  );_if

;;; WRKT�̂Ƃ�
  (setq #xd_WT (CFGetXData &wtEn "G_WRKT"))
  (if #xd_WT
    (setq #wtEn &wtEn)
  );_if

  ;(if (= &cmd 1);00/07/03 SN MOD ���ď���
  ;  (command "_.undo" "m") ;00/07/03 SN MOD ���ď���
  ;);00/07/03 SN MOD ���ď���
  (setq #xd$ (CFGetXData #wtEn "G_WRKT"))
  (setq #ss$ '())
  (command "vpoint" "0,0,1")  ; 00/04/25 YM

  ;// �F�ւ��m�F
  (setq #ss$ (cons (PCW_ChColWTItemSSret #wtEn CG_InfoSymCol) #ss$)) ; �ݸ������Έꏏ�Ɏ�� 04/25 YM

  ;;; ��đ��荶
  (setq #WTL (nth 47 #xd$))          ; ��WT�}�`�����
  (while (and #WTL (/= #WTL ""))     ; ����WT�������
    (setq #ss$ (cons (PCW_ChColWTItemSSret #WTL CG_InfoSymCol) #ss$)) ; �ݸ������Έꏏ�Ɏ�� 04/25 YM
    (setq #xd0$ (CFGetXData #WTL "G_WRKT"))
    (setq #WTL (nth 47 #xd0$))       ; �X�ɍ��ɂ��邩
    (if (= #WTL "") (setq #WTL nil)) ; �Ȃ������� nil
  )

  ;;; ��đ���E
  (setq #WTR (nth 48 #xd$))          ; ��WT�}�`�����
  (while (and #WTR (/= #WTR ""))     ; ����WT�������
    (setq #ss$ (cons (PCW_ChColWTItemSSret #WTR CG_InfoSymCol) #ss$)) ; �ݸ������Έꏏ�Ɏ�� 04/25 YM
    (setq #xd0$ (CFGetXData #WTR "G_WRKT"))
    (setq #WTR (nth 48 #xd0$))       ; �X�ɍ��ɂ��邩
    (if (= #WTR "") (setq #WTR nil)) ; �Ȃ������� nil
  )

  (command "zoom" "p")

  (if (= &cmd 1)
    (progn ; �폜����ގ�
      (if (CFGetXData #wtEn "G_WTSET")
        (setq #msg "���̃��[�N�g�b�v�͊��ɕi�Ԋm�肳��Ă��܂��B\n�폜���܂����H")
        (setq #msg "�{���ɍ폜���Ă���낵���ł����H")
      )
      (if (CFYesNoDialog #msg)
        (progn
          (foreach #ss #ss$
            (command "_.erase" #ss "") ; �폜����
          )
        )
        (command "_.undo" "b")
      );_if
    )
    (progn ; �폜����ގ��ȊO
      (foreach #ss #ss$
        (command "_.erase" #ss "")    ; �폜����
      )
    )
  );_if

(princ)
)
;PCW_DelWkTop

;<HOM>*************************************************************************
; <�֐���>    : PCW_ChColWTItemSSret
; <�����T�v>  : ܰ�į�߂�n���āAWT,BG,FG,�y�т����̒�ʐ}�`+�������̑I��Ă�Ԃ�
;               �����̐F�ς����s��.(WT�̈���ɼݸ������΂���� YM 04/25)
; <�߂�l>    : �I���
; <�쐬>      : 00/04/07 YM ADD
; <���l>      :
;*************************************************************************>MOH<
(defun PCW_ChColWTItemSSret (
  &wtEn  ;(ENAME)WT�}�`
  &color ; �F�ւ�����F nil:�F�ւ����Ȃ�
  /
  #I #SS #XD$ #J #PT$ #PT2$ #SS2 #SS_SYM #SYM #SYM$ #TEI #hole #G_WTR$
;-- 2011/07/29 A.Satoh Add - S
  #cut1 #cut2 #cut3 #cut4 ;#cut
;-- 2011/07/29 A.Satoh Add - E
;-- 2012/10/01 A.Satoh Add - S
  #en
;-- 2012/10/01 A.Satoh Add - E
  )
  (setq #ss (ssadd)) ; �߂�l�I���

  (setq #xd$ (CFGetXData &wtEn "G_WRKT"))
  (ssadd &wtEn #ss)
  (command "_.change" &wtEn "" "P" "C" &color "") ; ����WT
;;;  (command "_.change" &wtEn "" "P" "C" CG_InfoSymCol "") ; ����WT
  (ssadd (nth 38 #xd$) #ss) ; WT���

;-- 2012/10/01 A.Satoh Mod - S
	(if (and (nth 59 #xd$) (/= "" (nth 59 #xd$)))
		(progn
			(if (= (type (nth 59 #xd$)) 'ENAME)		; �}�`�����ݒ肳��Ă���ꍇ
				(ssadd (nth 59 #xd$) #ss) ; WT���
			)
			(if (= (type (nth 59 #xd$)) 'STR)			; �}�`�n���h�����ݒ肳��Ă���ꍇ
				(progn
					(setq #en (handent (nth 59 #xd$)))
					(if #en
						(ssadd #en #ss) ; WT���
					)
				)
			)
		)
	)
;;;  ; 01/07/04 YM ADD [60]�O�`�������� START
;;;;;;  (if (and (nth 59 #xd$)(/= "" (nth 59 #xd$))(entget (nth 59 #xd$)));2012/09/26 YM MOD
;;;  (if (and (nth 59 #xd$)(/= "" (nth 59 #xd$))(handent (nth 59 #xd$)));2012/09/26 YM MOD
;;;    (ssadd (nth 59 #xd$) #ss) ; WT���
;;;  );_if
;;;  ; 01/07/04 YM ADD [60]�O�`�������� END
;-- 2012/10/01 A.Satoh Mod - E

  (setq #tei (nth 38 #xd$))          ; WT��ʐ}�`�����
  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��
  (setq #pt2$ (append #pt$ (list (car #pt$)))) ; �I�_�̎��Ɏn�_��ǉ����ė̈���͂�

  ;// �̈�Ɋ܂܂��A�V���N,��������������
  (setq #sym$ (PKGetSinkSuisenSymCP #pt2$))
  (foreach #sym #sym$
    (if (= (nth 9 (CFGetXData #sym "G_LSYM")) CG_SKK_INT_SNK)   ; �ݸ����ِ}�` ; 01/08/31 YM MOD 410-->��۰��ى�
      (progn
        (setq #hole (nth 3 (CFGetXData #sym "G_SINK")))
				(if (= (type #hole) 'STR)
					nil ;�}�`�����Ă��鉽�����Ȃ�
					;else
					(progn
		        ; 02/05/21 YM MOD-S
		        (if (and #hole (/= #hole ""))
		          (ssadd #hole #ss)
							;else
							nil ;�}�`�����Ă��鉽�����Ȃ�
		        );_if ; �ݸ���̈���ǉ�
		        ; 02/05/21 YM MOD-E
					)
				);_if

;;;02/05/21YM@DEL        (if (/= #hole "")(ssadd #hole #ss)) ; �ݸ���̈���ǉ�
      )
    );_if

    (setq #ss2 (CFGetSameGroupSS #sym))
    (command "_.change" #ss2 "" "P" "C" &color "")
    (setq #j 0)
    (repeat (sslength #ss2)
      (ssadd (ssname #ss2 #j) #ss)
      (setq #j (1+ #j))
    )
  )
;;; �̈�Ɋ܂܂�鐅����"G_WTR"ؽ� 07/22 YM ADD
  (setq #G_WTR$ (PKGetG_WTRCP #pt2$)) 
  (foreach #G_WTR #G_WTR$
    (ssadd #G_WTR #ss)
  )

;-- 2011/09/05 A.Satoh Mod - S
;;-- 2011/07/29 A.Satoh Add - S
;  ; �J�b�g���C���}�`��I���Z�b�g�ɒǉ�����
;  (setq #cut (nth 35 #xd$))
;  ;2011/08/02 YM ADD I�^�̂Ƃ��폜==>�V�¸د��ŗ����� #cut = "����đ��������" ������
;  (if (and #cut (/= #cut "")(/= #cut "����đ��������") (entget (handent #cut)))
;    (progn
;      (command "_.CHANGE" (handent #cut) "" "P" "C" &color "")
;      (ssadd (handent #cut) #ss)
;    )
;  )
;;-- 2011/08/31 A.Satoh Add - S
;  (setq #cut2 (nth 36 #xd$))
;  (if (and #cut2 (/= #cut2 "") (handent #cut2) (entget (handent #cut2)))
;    (progn
;      (command "_.CHANGE" (handent #cut2) "" "P" "C" &color "")
;      (ssadd (handent #cut2) #ss)
;    )
;  )
;;-- 2011/08/31 A.Satoh Add - E
;;-- 2011/07/29 A.Satoh Add - E
  (setq #cut1 (nth 60 #xd$))
  (if (and #cut1 (/= #cut1 "") (handent #cut1) (entget (handent #cut1)))
    (progn
      (command "_.CHANGE" (handent #cut1) "" "P" "C" &color "")
      (ssadd (handent #cut1) #ss)
    )
  )
  (setq #cut2 (nth 61 #xd$))
  (if (and #cut2 (/= #cut2 "") (handent #cut2) (entget (handent #cut2)))
    (progn
      (command "_.CHANGE" (handent #cut2) "" "P" "C" &color "")
      (ssadd (handent #cut2) #ss)
    )
  )
  (setq #cut3 (nth 62 #xd$))
  (if (and #cut3 (/= #cut3 "") (handent #cut3) (entget (handent #cut3)))
    (progn
      (command "_.CHANGE" (handent #cut3) "" "P" "C" &color "")
      (ssadd (handent #cut3) #ss)
    )
  )
  (setq #cut4 (nth 63 #xd$))
  (if (and #cut4 (/= #cut4 "") (handent #cut4) (entget (handent #cut4)))
    (progn
      (command "_.CHANGE" (handent #cut4) "" "P" "C" &color "")
      (ssadd (handent #cut4) #ss)
    )
  )
;-- 2011/09/05 A.Satoh Mod - S

;;; BG1 ;;;
  (if (/= (nth 49 #xd$) "")
    (progn
      (ssadd (nth 49 #xd$) #ss) ; BG SOLID1 or ��ʐ}�`�����1

      (if (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID")
        (progn ; SOLID��������
          (command "_.change" (nth 49 #xd$) "" "P" "C" &color "")
          (ssadd (nth  1 (CFGetXData (nth 49 #xd$) "G_BKGD")) #ss) ; BG���1��������
        )
      );_if
    )
  );_if

;;; BG2 ;;;
  (if (/= (nth 50 #xd$) "")
    (progn
      (ssadd (nth 50 #xd$) #ss) ; BG SOLID2 or ��ʐ}�`�����2

      (if (= (cdr (assoc 0 (entget (nth 50 #xd$)))) "3DSOLID")
        (progn ; SOLID��������
          (command "_.change" (nth 50 #xd$) "" "P" "C" &color "")
          (ssadd (nth  1 (CFGetXData (nth 50 #xd$) "G_BKGD")) #ss) ; BG���2��������
        )
      );_if
    )
  );_if

;;; FG1 ;;;
  (if (/= (nth 51 #xd$) "")
    (ssadd (nth 51 #xd$) #ss) ; FG1 ��ʐ}�`�����
  );_if

;;; FG2 ;;;
  (if (/= (nth 52 #xd$) "")
    (ssadd (nth 52 #xd$) #ss) ; FG2 ��ʐ}�`�����
  );_if

;;;  ;// ������  ��ŏ���������
  (setq #i 23)
  (repeat (nth 22 #xd$)
    (if (nth #i #xd$) ; 07/14 YM �������Ȃ��Ƃ��ɔ�����
      (if (entget (nth #i #xd$))
        (ssadd (nth #i #xd$) #ss)
      );_if
    );_if
    (setq #i (1+ #i))
  )
  #ss
);PCW_ChColWTItemSSret

;<HOM>*************************************************************************
; <�֐���>    : PCW_WTItemSSret
; <�����T�v>  : ܰ�į�߂�n���āA�J�b�g���荶�E��WT,BG,FG,�I��Ă�Ԃ�
; <�߂�l>    : �I���
; <�쐬>      : 00/04/07 YM ADD
; <���l>      :
;*************************************************************************>MOH<
(defun PCW_WTItemSSret (
  &wten  ;(ENAME)WT�}�`
  /
  #I #SS #XD$ #WTL #WTR #XD0$
  )
  (setq #ss (ssadd)) ; �߂�l�I���
  (setq #xd$ (CFGetXData &wtEn "G_WRKT"))
  (ssadd &wtEn #ss)
  (if (/= (nth 49 #xd$) "")
    (ssadd (nth 49 #xd$) #ss) ; BG SOLID�}�`�����1
  )
  (if (/= (nth 50 #xd$) "")
    (ssadd (nth 50 #xd$) #ss) ; BG SOLID�}�`�����2
  )
  (if (/= (nth 51 #xd$) "")
    (ssadd (nth 51 #xd$) #ss) ; FG SOLID�}�`�����
  )
  ;;; ��đ��荶
  (setq #WTL (nth 47 #xd$)) ; ��WT�}�`�����
  (while (and #WTL (/= #WTL "")) ; ����WT�������
    (setq #xd0$ (CFGetXData #WTL "G_WRKT"))
    (if (/= (nth 49 #xd$) "")
      (ssadd (nth 49 #xd$) #ss) ; BG SOLID�}�`�����1
    )
    (if (/= (nth 50 #xd$) "")
      (ssadd (nth 50 #xd$) #ss) ; BG SOLID�}�`�����2
    )
    (if (/= (nth 51 #xd$) "")
      (ssadd (nth 51 #xd$) #ss) ; FG SOLID�}�`�����
    )
    (setq #WTL (nth 47 #xd0$)) ; �X�ɍ��ɂ��邩
    (if (= #WTL "") (setq #WTL nil)) ; �Ȃ������� nil
  )
  ;;; ��đ���E
  (setq #WTR (nth 48 #xd$)) ; ��WT�}�`�����
  (while (and #WTR (/= #WTR "")) ; ����WT�������
    (setq #xd0$ (CFGetXData #WTR "G_WRKT"))
    (if (/= (nth 49 #xd$) "")
      (ssadd (nth 49 #xd$) #ss) ; BG SOLID�}�`�����1
    )
    (if (/= (nth 50 #xd$) "")
      (ssadd (nth 50 #xd$) #ss) ; BG SOLID�}�`�����2
    )
    (if (/= (nth 51 #xd$) "")
      (ssadd (nth 51 #xd$) #ss) ; FG SOLID�}�`�����
    )
    (setq #WTR (nth 48 #xd0$)) ; �X�ɍ��ɂ��邩
    (if (= #WTR "") (setq #WTR nil)) ; �Ȃ������� nil
  )
  #ss
);PCW_WTItemSSret

;<HOM>*************************************************************************
; <�֐���>    : PCW_DelBKGD
; <�����T�v>  : ܰ�į�߂̍폜���ޯ��ް�ނ�د������Ƃ�ܰ�į�߂��폜�������̂Ŋ֘AWT�}�`����
;               PCW_DelWkTop �Ɉ����n��
; <�߂�l>    :
; <�쐬>      : 00/03/18 YM ADD
; <���l>      :
;*************************************************************************>MOH<
(defun PCW_DelBKGD (
    &BGen         ;(ENAME)BKGD�}�`
    /
    #HAND_WT #XD_BG
  )

  (setq #xd_BG (CFGetXData &BGen "G_BKGD"))
  (if #xd_BG
    (progn
      (setq #hand_WT (nth 2 #xd_BG)) ; WT�}�`��
      (PCW_DelWkTop 1 #hand_WT) ; �폜����ގ��׸�=1
    )
    (progn
      (CFAlertMsg "�g���f�[�^ G_BKGD ������܂���B")
      (quit)
    )
  );_if

)
;PCW_DelBKGD

;;; �ȉ�01/01/12 YM COPY
;*************************************************************************>MOH<
;ItemSel��p�װ�֐�
;grread�֐���ESC�Ŕ��������ɢ*��ݾ�*���ү���ނ��o�͂��Ȃ��̂ŁA
;���X��*error*�����̑O�ɢ*��ݾ�*����o�͂���֐��B
;*************************************************************************>MOH<
(defun cancel*error*( &msg )
  (princ "*��ݾ�*");��ݾق�ү���ނ��o��
  (org*error* "")  ;���X��*error*�̏������s��
)

;<HOM>*************************************************************************
; <�֐���>    : ItemSel
; <�����T�v>  : ���ёI���֐�
;               �w��_���ɱ��т�����ꍇ�ͱ��ёI��
;               �w��_���ɱ��т��Ȃ��ꍇ
;               �@������E���F�͈͓��ɑS�ē����Ă��鱲�т�I��
;               �@�E���獶���F�͈͓��Ɉꕔ�ł������Ă��鱲�т�I��
; <����>      : &XDataLst$$ �I��Ώ۱��т�XDATA�Q
;               (("G_WRKT" "G_FILR")("G_LSYM")) nth 1�͸�ٰ�ߏ����p
;               &iCol �I���ѕ\���F
; <�߂�l>    : �I���
; <�쐬>      : 00/09/06 SN ADD
; <���l>      :
;             :
;*************************************************************************>MOH<
(defun ItemSel( &XDataLst$$ &iCol
  /
  #enp #pp1 #pp2 #en
  #ssRet #ss #sswork
  #gmsg #i #ii #setflag
  #engrp #ssgrp
  #xd$ #ENR
  )

  ;*********************************************
  ; �J��Ԃ����т̑I��
  ;*********************************************
  (setq #ssRet (ssadd))
  (setq #pp1 T)
  (while #pp1
    ;---------------------------------------------
    ; ���ш��I���̏���
    ;---------------------------------------------
    (setq org*error* *error*)   ;ItemSel���ꏈ�� ���X��*error*�֐����L��
    (setq *error* cancel*error*);ItemSel���ꏈ�� *error*�֐���ItemSel�p�̊֐���킹��
    (setq #enp (entselpoint "\n�A�C�e����I��:"))
    (setq *error* org*error*)   ;ItemSel���ꏈ�� ���X��*error*�֐��ɖ߂�
    (setq #pp1 (cadr #enp))
    ;�����݉���
    (if #pp1 (progn
      (setq #en #enp)
      ;�I��_�ɵ�޼ު�Ă���
      (if (car #en)
        (progn;then
          ;�I���޼ު�Ă�I��Ăɉ��Z
          (setq #ss (ssadd))
          (ssadd (car #en) #ss)
        );end progn
        (progn;else
          ;���w�菈��
          (setq #pp2 nil)
          (setq #gmsg " ��������̺�Ű���w��:")
          (while (not #pp2);��Ű���I�������܂�ٰ��
            (setq #pp2 (getcorner #pp1 #gmsg))
            (if #pp2
              ;�����݉���
              (progn
                (if (< (car (trans #pp1 0 2)) (car (trans #pp2 0 2)))
                  ;�����E�I��
                  (progn;then
                    (setq #sswork (ssget "W" #pp1 #pp2))
                    (setq #ss (ItemSurplus #sswork &XDataLst$$))
                    (setq #sswork  nil)
                  );end progn
                  ;�E����
                  (progn;else
                    (setq #ss (ssget "C" #pp1 #pp2))
                  );end progn
                );end if
              );end progn
              ;�E���݉���
              (progn
                (princ "\n���̎w�肪�����ł�.")
                (setq #gmsg "\n�A�C�e����I��: ��������̺�Ű���w��:")
              )
            );end if
          );end while
        );end progn
      );end if
    ));end if - progn
    ;---------------------------------------------
    ;�I���A�C�e���̐F��ς���
    ;---------------------------------------------
    (if #ss (progn
      (setq #ssGrp (ChangeItemColor #ss &XDataLst$$ &iCol))
      ;�F��ς������т�߂�l�I��Ă։��Z
      (setq #i 0)
      (repeat (sslength #ssGrp)
        (ssadd (ssname #ssGrp #i) #ssRet)
        (setq #i (1+ #i))
      )
      ;�I��Ă��芎�F�ύX�����A�C�e���������ꍇ�A�I��s�̃A�C�e���Ƃ݂Ȃ��B
      (if (and (> (sslength #ss) 0) (<= (sslength #ssGrp) 0))
        (CFAlertErr "���̃A�C�e���͑I���ł��܂���B")
      )
      (setq #ss nil)
      (setq #ssGrp nil)
    ));end if - progn
  );end while

  ;*********************************************
  ; �Ώۏ������ёI��
  ;*********************************************
  (setq #enR 'T)
  ;�E���݉���or�߂�l�I��Ă��Ȃ��Ȃ�����I��
  (while (and #enR (> (sslength #ssRet) 0))
    (setq #enR (car (entsel "\n�Ώۂ��珜���A�C�e����I��:")))
    ;�߂�l�I��Ă����ް�̂ݏ�������B
    (if (and #enR (ssmemb #enR #ssRet))(progn
      ;�ꎞ�I�ɑI��Ă��쐬
      (setq #sswork (ssadd))
      (ssadd #enR #sswork)
      ;�I���т̐F��߂�
      (setq #ssGrp (ChangeItemColor #sswork &XDataLst$$ nil))
      ;�F��߂������т�߂�l�I��Ă��珜��
      (setq #i 0)
      (repeat (sslength #ssGrp)
        (ssdel (ssname #ssGrp #i) #ssRet)
        (setq #i (1+ #i))
      )
      (setq #sswork nil)
      (setq #ssGrp nil)
    ));end if - progn
  ); while

  #ssRet
);ItemSel

;<HOM>*************************************************************************
; <�֐���>    : ItemSurplus
; <�����T�v>  : ���ёI���֐�
;             : �I��ē��̈��̱��т�������
;             : ����Ե�޼ު�Ă��S�đI������Ă��鱲�т����̑I��Ă��쐬����B
; <�߂�l>    :
; <�쐬>      : 00/09/06 SN ADD
; <���l>      : 
;*************************************************************************>MOH<
(defun ItemSurplus( &ss &XDataLst$$
  /
  #ssGrp #ssRet #ssErr #ssWork
  #membFlag #wFlag
  #i #i2
  #en #engrp
  #layerdata #layername$
  )

  ;���ݎg�p���̉�w�ꗗ���擾
  ;�ذ��or��\����Ԃ̉�w�͏Ȃ�
  (setq #layername$ '())
  (setq #layerdata (tblnext "LAYER" T))
  (while #layerdata
    (if (and (=  (cdr (assoc 70 #layerdata)) 0) ;��w���ذ�ނł͂Ȃ�
             (>= (cdr (assoc 62 #layerdata)) 0));��\���ł��Ȃ�
      (setq #layername$ (append #layername$ (list (cdr (assoc 2 #layerdata)))))
    )
    (setq #layerdata (tblnext "LAYER" nil))
  )

  (setq #i 0)
  (if &ss (progn
    (setq #ssRet (ssadd))
    (setq #ssErr (ssadd))
    ;�I��ē��̑S�Ă�Entity�ɑ΂��������s��
    (repeat (sslength &ss)
      (setq #en (ssname &ss #i))
      ;�߂�l�I��ĂɊ܂܂�Ă��Ȃ�Entity��Ώۂɂ���B
      (if (and (not (ssmemb #en #ssRet))
               (not (ssmemb #en #ssErr)))
        (cond
          ;��ٰ�߱��т̏���
          ((and (setq #engrp (SearchGroupSym (ssname &ss #i)))
                (setq #ssGrp (CFGetSameGroupSS #engrp))
                (CheckXData #engrp (nth 1 &XDataLst$$)))
            (setq #ssWork (ssadd))
            (setq #i2 0)
            (setq #membFlag T)
            (setq #wFlag T)
            ;���т�Entity���S�Ĉ����̑I��ĂɊ܂܂�Ă��邩��������B
            (repeat (sslength #ssGrp)
              (setq #en (ssname #ssGrp #i2))
              (if (and (not (ssmemb #en &ss))                            ;�I��Ă����ް�łȂ����
                       (member (cdr (assoc 8 (entget #en))) #layername$));��޼ު�ĉ�w�����ݎg�p��
                (if (/= (cdr (assoc 0 (entget #en))) "INSERT") ; 01/04/09 YM
                  (setq #membFlag nil)               ;"INSERT"�łȂ���΂Ƃ���������t�� 01/04/09 YM
                );_if                                          ; 01/04/09 YM
;;;01/04/09YM@                (setq #membFlag nil)               ;�I��ĂɊ܂܂�Ȃ���޼ު�Ă���
                (ssadd (ssname #ssGrp #i2) #ssWork);
              );end if
              (setq #i2 (1+ #i2))
            );end repeat
            ;���т̑S�Ă����ް���܂܂�Ă�����
            (if #membFlag
              (progn;THEN
                ;���т̑S�Ă̵�޼ު�Ă�߂�I��Ăɉ��Z
                (setq #i2 0)
                (repeat (sslength #ssGrp)
                  (ssadd (ssname #ssGrp #i2) #ssRet)
                  (setq #i2 (1+ #i2))
                );end repeat
              );end progn
              (progn;ELSE
                ;�ꕔ�I���̵�޼ު�Ă������p�I��Ăɉ��Z(���x���ߗp)
                (setq #i2 0)
                (repeat (sslength #ssWork)
                  (ssadd (ssname #ssWork #i2) #ssErr)
                  (setq #i2 (1+ #i2))
                );end repeat
              );end progn
            );end if
            (setq #ssWork nil)
            (setq #ssGrp nil)
          );end progn
          ;ܰ�į�ߥ̨װ�ȂǸ�ٰ�߈ȊO�̱���
          ((CheckXData #en (nth 0 &XDataLst$$))
            (ssadd #en #ssRet)
          )
        );end cond
      );end if
      (setq #i (1+ #i))
    );end repeat
    (setq #ssErr nil)
  ));end if - end progn
  #ssRet
);ItemSurplus

;<HOM>*************************************************************************
; <�֐���>    : ChangeItemColor
; <�����T�v>  : �I��ĂɊ܂܂�鱲�т̐F��ς���
;             : �I��ĂɈꕔ�ł��܂܂�Ă���Ƃ��̸�ٰ�߂�T�������B
;             : 
; <�߂�l>    : �F��ς����S�Ă̵�޼ު�Ă��܂ޑI���
;             : 
; <�쐬>      : 00/09/22 SN ADD
; <���l>      : &iCol=nil�� �Ȃɂ��I�����Ă��Ȃ���Ԃɖ߂��B
;*************************************************************************>MOH<
(defun ChangeItemColor( &ss &XDataLst$$ &iCol
  /
  #i #ii #iii
  #enR
  #ssRet #ssGrp #sswork
  #en #engrp
  #xd$ #wtxd$
;-- 2011/06/13 A.Satoh Add - S
  #skk
;-- 2011/06/13 A.Satoh Add - E
  )

	;2017/08/25 YM ADD �ڰѷ��݂̂Ƃ��͐��𐫊i���ނ��ꎞ�I�ɕύX����(��۰��ٕϐ��͕ς��Ȃ�)
	(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
		(progn
			(setq #CG_SKK_INT_SUI 5555) ;�ڰѷ��݂̏ꍇ�̏ꍇ5555���肦�Ȃ��l
		)
		(progn
			(setq #CG_SKK_INT_SUI CG_SKK_INT_SUI) ;����ި�̏ꍇ510
		)
	);_if

  (setq #i 0)
  (setq #ssRet (ssadd))
  (setq CG_BASESYM (CFGetBaseSymXRec))
  (repeat (sslength &ss)
    (setq #enR (ssname &ss #i))
    (if (not (ssmemb #enR #ssRet))
      (cond
        ;��ٰ�߱��т̏���
        ((and (setq #engrp (SearchGroupSym #enR))
              (setq #ssGrp (CFGetSameGroupSS #engrp))
              (CheckXData #engrp (nth 1 &XDataLst$$)))
;-- 2011/06/13 A.Satoh Mod - S
          (setq #skk (nth 9 (CFGetXData #engrp "G_LSYM")))
          (if (and (/= #skk #CG_SKK_INT_SUI) ;2017/08/25 YM MOD CG_SKK_INT_SUI==>#CG_SKK_INT_SUI
                   (/= #skk  CG_SKK_INT_SNK))
            (progn
              ;�F
              (if &iCol;�F�ύX�w��
                (GroupInSolidChgCol2 #engrp &iCol)
                (if (equal CG_BASESYM #engrp);�����
                  (GroupInSolidChgCol #engrp CG_BaseSymCol)
                  (GroupInSolidChgCol2 #engrp "BYLAYER")
                )
              )
              ;�߂�l�I��Ăɉ��Z
              (setq #ii 0)
              (repeat (sslength #ssGrp)
                (ssadd (ssname #ssGrp #ii) #ssRet)
                (setq #ii (1+ #ii))
              );end repeat
              (setq #ssGrp nil)
            )
          )
;          ;�F
;          (if &iCol;�F�ύX�w��
;            (GroupInSolidChgCol2 #engrp &iCol)
;            (if (equal CG_BASESYM #engrp);�����
;              (GroupInSolidChgCol #engrp CG_BaseSymCol)
;              (GroupInSolidChgCol2 #engrp "BYLAYER")
;            )
;          )
;          ;�߂�l�I��Ăɉ��Z
;          (setq #ii 0)
;          (repeat (sslength #ssGrp)
;            (ssadd (ssname #ssGrp #ii) #ssRet)
;            (setq #ii (1+ #ii))
;          );end repeat
;          (setq #ssGrp nil)
;-- 2011/06/13 A.Satoh Mod - E
        )
        ;ܰ�į�ߥ̨װ�ȂǸ�ٰ�߈ȊO�̱���
        ((CheckXData #enR (nth 0 &XDataLst$$))
          (cond
            ;ܰ�į��
            ((setq #wtxd$ (CFGetXData #enR "G_WRKT"))
              ;ܰ�į�ߊ֘A���т��擾
              (command "vpoint" "0,0,1")                             ;�ォ�猩�Ȃ��Ƽݸ�A�����Ȃǂ��ׂĂƂ�Ȃ�
              (if &iCol;�F�ύX�w��
                (setq #sswork (PCW_ChColWTItemSSret #enR &iCol))     ;ܰ�į�ߊ֘A�������I��
                (setq #sswork (PCW_ChColWTItemSSret #enR "BYLAYER")) ;ܰ�į�ߊ֘A�������I��
              )
              (command "zoom" "p")                                   ;���_��߂�
              (if (and (not &iCol) (CFGetXData #enR "G_WTSET"))(progn;�i�Ԋm��ܰ�į��
                (GroupInSolidChgCol2 #enR CG_WorkTopCol)             ;�i�Ԋm��ܰ�į�ߐF
                (if (/= (setq #en (nth 49 #wtxd$)) "")(progn         ;BG����
                  (GroupInSolidChgCol2 #en CG_WorkTopCol)            ;�i�Ԋm��ܰ�į�ߐF
                  (ssadd #en #ssRet)                                 ;BG��߂�l�I��Ăɉ��Z
                ));end if - progn
                (if (/= (setq #en (nth 50 #wtxd$)) "")(progn         ;FG����
                  (GroupInSolidChgCol2 #en CG_WorkTopCol)            ;�i�Ԋm��ܰ�į�ߐF
                  (ssadd #en #ssRet)                                 ;FG��߂�l�I��Ăɉ��Z
                ));end if - progn
              ));end if - progn
              (ssadd #enR #ssRet)                                    ;ܰ�į�߂�߂�l�I��Ăɉ��Z
              ;ܰ�į�ߊ֘A��߂�l�I��Ăɉ��Z
              (setq #ii 0)
              (repeat (sslength #sswork)
                (setq #en (ssname #sswork #ii))
                (if (not (ssmemb #en #ssRet))                        ;���ް�ȊO�̂��̂̂ݑΏۂɂ���B
                  (cond
                    ;��ٰ�߱��� �ݸ�Ȃ�
                    ((and (setq #engrp (SearchGroupSym #en))
                          (setq #ssGrp (CFGetSameGroupSS #engrp))
                          (CheckXData #engrp (nth 1 &XDataLst$$)))
                      (if (and (not &iCol) (equal CG_BASESYM #engrp));����тȂ�F�ύX
                        (GroupInSolidChgCol #engrp CG_BaseSymCol)
                      )
                      ;�߂�l�I��Ăɉ��Z
                      (setq #iii 0)
                      (repeat (sslength #ssGrp)
                        (ssadd (ssname #ssGrp #iii) #ssRet)
                        (setq #iii (1+ #iii))
                      );end repeat
                      (setq #ssGrp nil)
                    )
                    (T; �ޯ��ް�ނȂ�
                      ;��ٰ�߱��тłȂ���΂��̂܂ܐF�ύX
                      (if (and (not &iCol) (equal CG_BASESYM #en));����тȂ�F�ύX
                        (GroupInSolidChgCol #en CG_BaseSymCol)
                      )
                      (ssadd (ssname #sswork #ii) #ssRet)         ;�߂�l�I��Ăɉ��Z
                    )
                  );end cond
                );end if
                (setq #ii (1+ #ii))
              );end repeat
              (setq #sswork nil)
            )
            ;�V��̨װ
            ((setq #xd$ (CFGetXData #enR "G_FILR"))
              (if &iCol                                  ;�F�ύX�w������
                (GroupInSolidChgCol2 #enR &iCol)         ;�w���F�ɕύX
                (if (equal CG_BASESYM #enR)              ;�F�ύX�w���Ȃ������
                  (GroupInSolidChgCol #enR CG_BaseSymCol);����ѐF�ɕύX
                  (GroupInSolidChgCol2 #enR "BYLAYER")   ;BYLAYER�F�ɕύX
                );end if
              );end if
              (ssadd #enR #ssRet)                        ;�V��̨װ��߂�l�I��Ăɉ��Z
              (ssadd (nth 2 #xd$) #ssRet)                ;��ʂ��߂�l�I��Ăɉ��Z
            )
            (T
              (if &iCol                                  ;�F�ύX�w������
                (GroupInSolidChgCol2 #enR &iCol)         ;�w���F�ɕύX
                (if (equal CG_BASESYM #enR)              ;�F�ύX�w���Ȃ������
                  (GroupInSolidChgCol #enR CG_BaseSymCol);����ѐF�ɕύX
                  (GroupInSolidChgCol2 #enR "BYLAYER")   ;BYLAYER�F�ɕύX
                );end if
              );end if
            )
          );end cond
        )
      );cond
    );end if
    (setq #i (1+ #i))
  );end repeat
  #ssRet
);ChangeItemColor

;<HOM>*************************************************************************
; <�֐���>    : entselpoint
; <�����T�v>  : entsel+getpoint�I�Ȋ֐�
;             : 
; <�߂�l>    : �}�`���ƍ��W��ؽ� (<�}�`��: ****> (x y z))
;             : ��èè�����I���̏ꍇ�͐}�`����nil (nil (x y z))
; <�쐬>      : 00/09/12 SN ADD
; <���l>      : 
;*************************************************************************>MOH<
(defun entselpoint( &msg
   /
   #allkeys #curtype #grret #type #data
   #loopf
   #sysvar #enp #en
   )

  (setq #allkeys 12);�I����@�F���ٌ`����w��
  (setq #curtype 2);���ٌ`��F��޼ު�đI�𶰿ف�
  (setq #loopf T)
  (princ &msg)
  (while #loopf
    (setq #grret (grread nil #allkeys #curtype))
    (setq #type (car #grret))
    (setq #data (cadr #grret))
    (cond
      ;������orACAD����̧ݸ��ݸد�
      ((= #type 2)
        (cond
          ; 01/05/16 HN ADD Enter���̏�����ǉ�
          ((= #data 13);[Enter]
            (setq #loopf nil)
          )
          ((= #data 2);[�ů��]
            (if (= (getvar "SNAPMODE") 0)
              (progn (setvar "SNAPMODE" 1) (princ " <�ů�� ��> ") )
              (progn (setvar "SNAPMODE" 0) (princ " <�ů�� ��> ") )
            )
          )
          ((= #data 7);[��د��]
            (if (= (getvar "GRIDMODE") 0)
              (progn (setvar "GRIDMODE" 1) (princ " <��د�� ��> ") )
              (progn (setvar "GRIDMODE" 0) (princ " <��د�� ��> ") )
            )
          )
          ((= #data 15);[����Ӱ��]
            (if (= (getvar "ORTHOMODE") 0)
              (progn (setvar "ORTHOMODE" 1) (princ " <����Ӱ�� ��> ") )
              (progn (setvar "ORTHOMODE" 0) (princ " <����Ӱ�� ��> ") )
            )
          )
          ((= #data 21);[��]
            (setq #sysvar (getvar "AUTOSNAP"))
            (if (= (logand (lsh #sysvar -3) 1) 0);AUTOSNAP���ѕϐ���8
              (progn (setvar "AUTOSNAP" (+ #sysvar 8)) (princ " <�� ��> ") )
              (progn (setvar "AUTOSNAP" (- #sysvar 8)) (princ " <�� ��> ") )
            )
          )
          ((= #data 23);[OTRACK]
            (setq #sysvar (getvar "AUTOSNAP"))
            (if (= (logand (lsh #sysvar -4) 1) 0);AUTOSNAP���ѕϐ���16
              (progn (setvar "AUTOSNAP" (+ #sysvar 16)) (princ " <O �ů�� �ׯ�ݸ� ��> ") )
              (progn (setvar "AUTOSNAP" (- #sysvar 16)) (princ " <O �ů�� �ׯ�ݸ� ��> ") )
            )
          )
        )
      )
      ;�����݂������ꂽ
      ((= #type 3)
        (setq #enp (nentselp #data))
        (if (not #enp) (setq #enp (list nil #data)))
        (setq #loopf nil)
      )
      ;�E���݂������ꂽ
      ((= #type 25)
        (setq #enp nil)
        (setq #loopf nil)
      )
    )
  )
  #enp
)
;00/07/31 SN S-ADD ؽĂɊ܂܂��XData�̑��݂��m�F
(defun CheckXData( &en &xdlst$ / #xdobj #objflg )
  (setq #objflg nil)

  (foreach #xdobj &xdlst$
    (if (CFGetXData &en #xdobj)(setq #objflg T))
  )
  #objflg
)

(princ)
