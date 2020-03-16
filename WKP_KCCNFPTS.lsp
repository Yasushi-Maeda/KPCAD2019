;;; (defun C:ConfWkTop
;;; (defun C:ConfParts
;;; (defun SC_Conf
;;; (defun PcConfItemNoLSYM
;;; (defun SC_ConfParts

;;; (defun SKY_PartsInfoDialog
;;; (defun PC_ConfWKTop2
;;; (defun PKY_WKTopInfoDialog
;;; (defun PcGetPrintNameH800

;<HOM>*************************************************************************
; <�֐���>    : C:ConfWkTop
; <�����T�v>  : �ݔ����ނ̊m�F�iWORKTOP)
; <�߂�l>    :
; <�쐬>      : 2000-01-26
; <���l>      :
;*************************************************************************>MOH<
(defun C:ConfWkTop ()
  (StartCmnErr)
  (SC_Conf)
  (setq *error* nil)
  (princ)
)
;C:ConfWkTop

;<HOM>*************************************************************************
; <�֐���>    : C:ConfParts
; <�����T�v>  : �ݔ����ނ̊m�F�iLSYM)
; <�߂�l>    :
; <�쐬>      : 2000-01-26
; <���l>      :
;*************************************************************************>MOH<
(defun C:ConfParts ()
  (setq CG_CHG_COL nil) ; �F�ւ����Ȃ�'T
  (StartCmnErr)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;00/09/07 SN S-ADD
      (defun ConfPartsCmnErr ( &msg )
        (CFCmdDefFinish)
        (if CG_CHG_COL ; 01/01/22 YM ADD �F�ւ����Ȃ�'T
          (command "_undo" "b") ; �F�ւ���
        );_if
        (setq *error* nil)
        (setq CG_CHG_COL nil) ; �F�ւ����Ȃ�'T
        (princ)
      )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq *error* ConfPartsCmnErr)
  (CFCmdDefBegin 6)
  ;00/09/07 SN E-ADD
  (SC_Conf)
  (CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  (setq CG_CHG_COL nil) ; �F�ւ����Ȃ�'T
  (princ)
)
;C:ConfParts

;<HOM>*************************************************************************
; <�֐���>    : SC_Conf
; <�����T�v>  : �A�C�e���m�F "G_WRKT" "G_FILR" "G_BKGD" "RECT" "G_ROOM" "G_LSYM"
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2000-01-26 �� 01/04/03 MH MOD (�S�ʕύX)
; <���l>      :
;*************************************************************************>MOH<
(defun SC_Conf ( / #en #xd$ )
  (setq #en T)
  (while #en
    (setq #en (car (entsel "\n�m�F����A�C�e����I��: ")))
    (cond
      ((not #en) (princ))
      ((setq #xd$ (CFGetXData #en "G_WRKT")) (PC_ConfWKTop2 #en))
      ((setq #xd$ (CFGetXData #en "G_BKGD"));�o�b�O�K�[�h�͂܂�PcConfItemNoLSYM�ɓn���Ȃ�
        (CFYesDialog (strcat "�o�b�N�K�[�h�i��: [" (nth 0 #xd$) "]")))
      ((or (CFGetXData #en "G_FILR")(CFGetXData #en "G_BKGD"))(PcConfItemNoLSYM #en))
      ((CFGetXData #en "RECT")   (CFYesDialog "��̈�  �@�@"))
      ((CFGetXData #en "G_ROOM") (CFYesDialog "�Ԍ��̈�@�@  "))
      (T (setq #en (CFSearchGroupSym #en)) ; G_LSYM �����A�C�e���̏���
         (if #en (SC_ConfParts #en)) )
    ); cond
  ); while
  (princ)
);SC_Conf

;<HOM>*************************************************************************
; <�֐���>    : PcConfItemNoLSYM
; <�����T�v>  : �A�C�e�����\�� "G_FILR" "G_BKGD"
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/03/28 MH
; <���l>      : ���������Ă�̂ňꏏ�ɂ���
;*************************************************************************>MOH<
(defun PcConfItemNoLSYM (
  &eEN
  /
  #xd$ #OPT$ #sOUTNAM #sHIN #ZQLY$ #INF$ #en #TOPflg #wtxd$ #setH #PLPT$ #setH
  #symType ; 2011/12/22 �R�c �ǉ�
  )

  (cond
    ; �t�B���[�����A�C�e������
    ((setq #xd$ (CFGetXData &eEN "G_FILR"))
      ; LW�|������������̂͂��̍��x�A����ȊO��0
      (cond
        ((setq #setH (cdr (assoc 38 (entget (nth 2 #xd$))))))
        (t (setq #setH 0))
      ); cond
      (setq #sOUTNAM "�V��t�B���[")
      (setq #sHIN (car #xd$))
      (setq #ZQLY$ (PcGetPartQLY$ "�i�Ԑ}�`" #sHIN nil 0))
      (setq #INF$ (list
        #sHIN
        "Z"   ; ���E��
        #setH     ; Z�l
        (nth 3 #ZQLY$);2008/06/28 OK!
        (nth 4 #ZQLY$);2008/06/28 OK!
        (nth 5 #ZQLY$);2008/06/28 OK!
        ""  ;���J��ID   ;2008/06/28 OK!
        (if (nth 6 #ZQLY$) (nth 6 #ZQLY$) "")   ;�}�`ID    ;2008/06/28 OK!
      )) ; if setq
      (setq #OPT$ (CFGetXData &eEN "G_OPT"))
      (if (= 'LIST (type #OPT$)) (setq #OPT$ (cdr #OPT$)))
      (command "_.undo" "m")
      (setq CG_CHG_COL T) ; 01/01/22 YM ADD �F�ւ����Ȃ�'T
      (command "_.chprop" &eEN "" "C" CG_ConfSymCol ""); 00/10/26 MOD MH "_change" �ύX
      ; �_�C�A���O�\��
;;;      (PKY_PartsInfoDialog #INF$ #OPT$ #sOUTNAM nil nil) ; 03/06/17 YM ADD �����ǉ�(����)
;;; ��2011/12/22 �R�c �ύX�E�ǉ� -------------------------------
;;;      (PKY_PartsInfoDialog #INF$ #OPT$ #sOUTNAM nil nil nil) ; 03/10/12 YM ADD ����"G_LSYM"�ǉ�(����)
      (if (/= nil #xd$)
        (setq #symType (nth 7 #xd$))
        (setq #symType nil)
      )
      ; ���� ���� �ǉ�(����)
      (setq #symType (PKY_PartsInfoDialog #INF$ #OPT$ #sOUTNAM nil nil nil #symType))
;;; ��2011/12/22 �R�c �ύX�E�ǉ� -------------------------------
      (command "_.undo" "b")
;;; ��2011/12/22 �R�c �ǉ� -------------------------------
      (if (/= nil #symType)
        (progn
          (setq #xd$ (CFModList #xd$ (list (list 7 #symType))))
          (CFSetXData &eEN "G_FILR" #xd$)
        )
      )
;;; ��2011/12/22 �R�c �ǉ� -------------------------------
      (setq CG_CHG_COL nil) ; 01/01/22 YM ADD �F�ւ����Ȃ�'T
    )
    ; �o�b�N�K�[�h�A�g�b�v����̏���
    ((setq #xd$ (CFGetXData &eEN "G_BKGD"))
      (setq #TOPflg (= 1 (nth 5 #xd$)))
      (setq #sOUTNAM (if #TOPflg "�g�b�v����" "�o�b�N�K�[�h"))
      (setq #wtxd$ (CFGetXData (nth 2 #xd$) "G_WRKT"))
      (setq #sHIN (car #xd$))
      (setq #INF$ (list
        #sHIN
        "Z"   ; ���E��
        (+ (nth 8 #wtxd$) (nth 10 #wtxd$))  ; �}���_��Z�l
        (nth 3 #xd$)     ; W
        (if #TOPflg 140 20) ; D
        (if #TOPflg  60 50) ; H
        ""   ;���J��ID
        ""   ;�}�`ID
      )) ; if setq
;;;      (PKY_PartsInfoDialog #INF$ nil #sOUTNAM nil nil) ; 03/06/17 YM ADD �����ǉ�(����)
;;;      (PKY_PartsInfoDialog #INF$ #OPT$ #sOUTNAM nil nil nil) ; 03/10/12 YM ADD ����"G_LSYM"�ǉ�(����)
      (PKY_PartsInfoDialog #INF$ #OPT$ #sOUTNAM nil nil nil nil) ; 2011/12/22 �R�c ���� ���� �ǉ�(����)
    )
    (t (princ))
  ); cond
);PcConfItemNoLSYM

;;;<HOM>*************************************************************************
;;; <�֐���>    : SC_ConfParts
;;; <�����T�v>  : �A�C�e�����(�z�u���ސ}�`�̏��)�\��
;;; <�߂�l>    :
;;; <�쐬>      : 1999-11-19
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun SC_ConfParts (
   &enSym
  /
  #en #xd1$ #xd2$ #xd3$ #lst$ #w #d #h #loop #ss #oplst$ #FIG$ #OUTNAME #HIN850
  #gent$ ; 00/08/29 SN ADD
  #sDoorFigID   ;���J��ID 00/09/07 HN ADD
  #SNK_ANA #XDKUTAI$
#DRINFO #DRINFO$ #HANDLE #XDTOKU$ ; 02/11/30 YM ADD
#XDLSYM$ #XDOPT2$ ;2010/01/08 YM ADD
  #symType ; 2011/12/22 �R�c �ǉ�
  )

  ;// �x�[�X�L���r�l�b�g�̎w��
  (command "_.undo" "m")
  (setq CG_CHG_COL T) ; 01/01/22 YM ADD �F�ւ����Ȃ�'T

  (setq #ss (CFGetSameGroupSS &enSym))
;  (command "_.change" #ss "" "P" "C" CG_ConfSymCol "")
  ; 00/10/26 MOD MH "_change" ��UCS �ɕ��s�łȂ��}�`���R��邽��
  (command "_.chprop" #ss "" "C" CG_ConfSymCol "")


  (setq #xd1$ (CFGetXData &enSym "G_LSYM"))
  (setq #xd2$ (CFGetXData &enSym "G_SYM"))
  (setq #xdKUTAI$ (CFGetXData &enSym "G_KUTAI"))
  (setq #xdTOKU$  (CFGetXData &enSym "G_TOKU"))

  (setq #gent$ (entget &enSym));00/08/29 SN ADD
  (setq #HIN850 (nth 5 #xd1$)) ; �i�Ԗ���
  (setq #outname (PcGetPrintNameH800 #HIN850 (nth 9 #xd1$))) ; �i�Ԗ���--->�o�͖���

  ; 02/07/10 YM ADD-S
  (if (and #xdTOKU$ (nth 8 #xdTOKU$))
    (setq #outname (nth 8 #xdTOKU$)) ; new���ߓ������ނ�հ�ް���͕i����\������
  );_if
  ; 02/07/10 YM ADD-E

  (if #xdTOKU$
    (setq #HIN850 (nth 0 #xdTOKU$)) ; ��������,��АL�k���ނ̏ꍇ�i�Ԃ�ύX
  );_if


  (setq #DrInfo (nth 7 #xd1$)) ; ���,���,���
  (setq #DrInfo$ (StrtoLisByBrk  #DrInfo ",")) ; �������","�ŋ�؂���ؽĉ�����
  (setq #Handle (caddr #DrInfo$)) ; ���L��( or nil)

  ; �������̏ꍇ"G_SYM","G_LSYM" 01/02/22 YM ADD
  (if #xdKUTAI$
    nil
    (progn
      (setq #fig$
        (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
          (list
            (list "�i�Ԗ���" (nth 5 #xd1$) 'STR)
            (list "LR�敪"   (nth 6 #xd1$) 'STR)
            (list "�p�r�ԍ�" (itoa (nth 12 #xd1$)) 'INT) ;00/09/21 MH ADD
          )
        )
      )
      (setq #fig$ (DBCheck #fig$ "�w�i�Ԑ}�`�x" "SC_ConfParts"))
    )
  );_if

  (setq #w (nth 3 #xd2$))
  (setq #d (nth 4 #xd2$))
  (setq #h (nth 5 #xd2$))


  ;HOPE-0140 00/09/07 HN ADD G_LSYM�̔��}�`ID��"none"�̏ꍇ��DB���擾
  (if #xdKUTAI$
    (setq #sDoorFigID (nth 8 #xd1$)) ; ������ 01/02/22 YM ADD
    (if (= "none" (nth 8 #xd1$))
      (setq #sDoorFigID "")
      (setq #sDoorFigID (nth 8 #xd1$))
    );_if
  );_if
  ;HOPE-0140 00/09/07 HN ADD G_LSYM�̔��}�`ID��"none"�̏ꍇ��DB���擾

  (setq #lst$
    (list #HIN850
          (nth  6 #xd1$)
          (nth  3 (assoc 10 #gent$));00/08/29 SN MOD �}���_��entget�̏����g�p����B
          #w
          #d
          #h
          #sDoorFigID   ;���J��ID
          (nth 0 #xd1$) ; 00/03/23 MH MOD
    )
  )
  ;;; �I�v�V�����g�����(�Ȃ��ꍇ��nil�l) 00/02/22 MH ADD
  (setq #xd3$ (CFGetXData &enSym "G_OPT"))
  (if (= 'LIST (type #xd3$)) (setq #oplst$ (cdr #xd3$)))

  ; 03/06/17 YM ADD ������߼�ݕi���
  (setq #xdOPT2$ (CFGetXData &enSym "G_OPT2"))

;;; 00/02/22 MH MOD
;;;  (PKY_PartsInfoDialog #lst$ #oplst$ #outname #SNK_ANA #xdOPT2$) ;;; �I�v�V�����i����ǉ� ; 03/06/17 YM ADD �����ǉ�(����)
  (setq #xdLSYM$ (CFGetXData &enSym "G_LSYM"));03/10/12 YM ADD
;;; ��2011/12/22 �R�c �ύX�E�ǉ� -------------------------------
;;;  (PKY_PartsInfoDialog #lst$ #oplst$ #outname #SNK_ANA #xdOPT2$ #xdLSYM$) ; 03/10/12 YM ADD ����"G_LSYM"�ǉ�(����)
  (if (/= nil #xd1$)
    (setq #symType (nth 15 #xd1$))
    (setq #symType nil)
  )
  ; ���� ���� �ǉ�(����)
  (setq #symType (PKY_PartsInfoDialog #lst$ #oplst$ #outname #SNK_ANA #xdOPT2$ #xdLSYM$ #symType))
;;; ��2011/12/22 �R�c �ύX�E�ǉ� -------------------------------
;;;  (SKY_PartsInfoDialog #lst$)
  (command "_.undo" "b")
;;; ��2011/12/22 �R�c �ǉ� -------------------------------
  (if (/= nil #symType)
    (progn
      (setq #xd1$ (CFModList #xd1$ (list (list 15 #symType))))
      (CFSetXData &enSym "G_LSYM" #xd1$)
    )
  )
;;; ��2011/12/22 �R�c �ǉ� -------------------------------
  (setq CG_CHG_COL nil) ; 01/01/22 YM ADD �F�ւ���'T
  (princ)
);C:ConfParts

;;;<HOM>*************************************************************************
;;; <�֐���>    : SKY_PartInfoDialog
;;; <�����T�v>  : �A�C�e�����(�z�u���ސ}�`�̏��)�\���_�C�A���O
;;; <�߂�l>    :
;;; <�쐬>      : 1999-11-19
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun SKY_PartsInfoDialog (
    &lst$
    /
    #dcl_id
    #lr
    #_lr
    #findFlg
    #fX #fY
  )

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCCONF.DCL")))
  (if (new_dialog "PartsXData_Box" #dcl_id)
    (progn
      (setq #lr (nth 1 &lst$))
;;; 00/02/07 MH MOD
      (setq #_lr (cond ((= #lr "Z") "") ((= #lr "L") " (L)") ((= #lr "R") " (R)")))
      (set_tile "_name" (strcat (nth 0 &lst$) #_lr))
      (set_tile "_ins_pz" (rtos (nth 2 &lst$) 2 2))
      (set_tile "_sym_w"  (rtos (nth 3 &lst$) 2 2))
      (set_tile "_sym_d"  (rtos (nth 4 &lst$) 2 2))
      (set_tile "_sym_h"  (rtos (nth 5 &lst$) 2 2))

      (setq #fX (dimx_tile "image"))
      (setq #fY (dimy_tile "image"))
      (start_image "image")
      (fill_image  0 0 #fX #fY -0)
      (setq #findFlg T)
      (if CG_DROPENPATH
        (progn
          (if (findfile (strcat CG_DROPENPATH (nth 6 &lst$) ".sld"))
            (progn
              (slide_image 0 0 #fX (- #fY 10) (strcat CG_DROPENPATH (nth 6 &lst$) ".sld"))
            )
            (progn
              (if (findfile (strcat CG_DROPENPATH (substr (nth 6 &lst$) 1 7) ".sld"))
                (progn
                  (slide_image 0 0 #fX (- #fY 10) (strcat CG_DROPENPATH (substr (nth 6 &lst$) 1 7) ".sld"))
                )
              ;else
                (progn
                  (if (findfile (strcat CG_SKDATAPATH "CRT\\" (substr (nth 6 &lst$) 1 7) ".sld"))
                    (slide_image 0 0 #fX (- #fY 10) (strcat CG_SKDATAPATH "CRT\\" (substr (nth 6 &lst$) 1 7) ".sld"))
                    (setq #findFlg nil)
                  )
                )
              )
            )
          )
        )
        (progn
          (if (findfile (strcat CG_SKDATAPATH "CRT\\" (substr (nth 6 &lst$) 1 7) ".sld"))
            (slide_image 0 0 #fX (- #fY 10) (strcat CG_SKDATAPATH "CRT\\" (substr (nth 6 &lst$) 1 7) ".sld"))
            (slide_image 0 0 #fX (- #fY 10) (strcat CG_SYSPATH "notfile.sld"))
          )
        )
      )
      (end_image)
      (action_tile "accept" "(done_dialog)")

      (start_dialog)
    )
  )
  (unload_dialog #dcl_id)
);SKY_PartsInfoDialog

;;;<HOM>*************************************************************************
;;; <�֐���>    : PC_ConfWKTop2
;;; <�����T�v>  : ���[�N�g�b�v���\��
;;; <�߂�l>    :
;;; <�쐬>      : 00/09/22 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PC_ConfWKTop2 (
  &wtEn        ;(ENAME)���[�N�g�b�v�}�`��
  /
  #wtEn #xd1$ #lst$ #loop #62 #XD2$ #RET_WTINFO$ #SET$
  #BRK #DIM #ELM #K
  )

  (command "_.undo" "m")

  ;// ���[�N�g�b�v�̎w��
  (initget 0)
  (setq #loop T)
  (setq #xd1$ (CFGetXData &wtEn "G_WRKT"))
  (if (= #xd1$ nil)
    (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
    (progn
      ;(command "_.change" &wtEn "" "P" "C" CG_ConfSymCol "")
      ; 01/02/26 MOD MH "_change" ��UCS �ɕ��s�łȂ��}�`���R��邽��
      (command "_.chprop" &wtEn "" "C" CG_ConfSymCol "")
      (setq #xd2$ (CFGetXData &wtEn "G_WTSET"))

      (if (/= #xd2$ nil)
        (progn
          (setq #brk " " #dim "")
          (setq #k 12)
          (repeat (nth 11 #xd2$) ; �����@��
            (setq #elm (nth #k #xd2$))
            (if (equal #elm (fix (+ #elm 0.0001)) 0.001)       ; �����_�ȉ�����
              (setq #dim (strcat #dim (itoa (fix (+ #elm 0.001))) #brk)) ; �����_�ȉ��؂�̂�
              (setq #dim (strcat #dim (rtos #elm 2 1) #brk))             ; ���P���܂�(��Q�ʎl�̌ܓ�)
            );_if
            (setq #k (1+ #k))
          )

          (setq #lst$ ; �i�Ԋm�肵�Ă���
            (list
              (nth  0 #xd2$) ;�����t���O
              (nth  1 #xd2$) ;�i��
              (nth  3 #xd2$) ;���i
              (nth  8 #xd1$) ;��t������
              (nth  2 #xd1$) ;�ގ�
              (car  (nth 55 #xd1$)) ;�Ԍ�1
              (cadr (nth 55 #xd1$)) ;�Ԍ�2
              (car  (nth 57 #xd1$)) ;���s1
              (cadr (nth 57 #xd1$)) ;���s2
	            (caddr (nth 57 #xd1$));���s3 2012/04/19 YM ADD
              #dim
            )
          )
        )
        (setq #lst$ ; �i�Ԋm�肵�Ă��Ȃ�
          (list
            ""
            ""
            ""
            (nth  8 #xd1$) ;��t������
            (nth  2 #xd1$) ;�ގ�
            (car  (nth 55 #xd1$)) ;�Ԍ�1
            (cadr (nth 55 #xd1$)) ;�Ԍ�2
            (car  (nth 57 #xd1$)) ;���s1
            (cadr (nth 57 #xd1$)) ;���s2
            (caddr (nth 57 #xd1$));���s3 2012/04/19 YM ADD
            ""
          )
        )
      );_if
      (PKY_WKTopInfoDialog #lst$)
      ; ���[�N�g�b�v�F�ύX��
      (if (CFGetXData &wtEn "G_WTSET")
        ; 01/02/26 MH MOD"_change" ��UCS �ɕ��s�łȂ��}�`���R��邽��
        ;(command "_.change" &wtEn "" "P" "C" CG_WorkTopCol "")
        ;(command "_.change" &wtEn "" "P" "C" "BYLAYER" "")
        (command "_.chprop" &wtEn "" "C" CG_WorkTopCol "")
        (command "_.chprop" &wtEn "" "C" "BYLAYER" "")
      )
      (setq #loop nil)
    )
  );_if
  (princ)
);PC_ConfWKTop2

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKY_WKTopInfoDialog
;;; <�����T�v>  : ���[�N�g�b�v���m�F�\���_�C�A���O
;;; <�߂�l>    :
;;; <�쐬>      : 00/09/22 YM �W��
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKY_WKTopInfoDialog (
  &lst$
  /
  #DCL_ID #LST$ #MAGU1 #MAGU2 #MEMO #OKU1 #OKU2 #QRY$ #RET
#CODE #DIM #HIGH #MONEY ; 02/11/30 YM ADD
#LST$
  )
;;;    &lst$
;;;  0;�����t���O
;;;  1;�i��
;;;  2;���i
;;;  3;��t������
;;;  4;�ގ�
;;;  5;�Ԍ�1
;;;  6;�Ԍ�2
;;;  7;���s1
;;;  8;���s2

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCCONF.DCL")))
  (if (new_dialog "WKTopXDataAll" #dcl_id)
    (progn
      (setq #qry$
        (DBSqlAutoQuery CG_DBSESSION (strcat "select * from WT�ގ� where �ގ��L��='" (nth 4 &lst$) "'"))
      )
      (setq #qry$ (DBCheck #qry$ "�wWT�ގ��x" "PKY_WKTopInfoDialog"))

      (setq #code (nth 1 &lst$))

      (if (= (nth 2 &lst$) "")
        (setq #money "0")
        (setq #money  (itoa (fix (+ (nth 2 &lst$) 0.001) )))
      )
      (if (= (nth 3 &lst$) "")
        (setq #high "0")
        (setq #high  (itoa (fix (+ (nth 3 &lst$) 0.001) )))
      )
      (if (= (nth 5 &lst$) "")
        (setq #magu1 "0")
        (setq #magu1 (itoa (fix (+ (nth 5 &lst$) 0.001) )))
      )
      (if (= (nth 6 &lst$) "")
        (setq #magu2 "0")
        (setq #magu2 (itoa (fix (+ (nth 6 &lst$) 0.001) )))
      )
      (if (= (nth 7 &lst$) "")
        (setq #oku1 "0")
        (setq #oku1 (itoa (fix (+ (nth 7 &lst$) 0.001) )))
      )
      (if (= (nth 8 &lst$) "")
        (setq #oku2 "0")
        (setq #oku2 (itoa (fix (+ (nth 8 &lst$) 0.001) )))
      )
			;2012/04/19 YM ADD-S
			(if (= (nth 9 &lst$) "")
				(setq #oku3 "0")
				(setq #oku3 (itoa (fix (+ (nth 9 &lst$) 0.001) )))
			)
			;2012/04/19 YM ADD-E
			(if (= (nth 10 &lst$) "")
				(setq #dim " ")
				(setq #dim (nth 10 &lst$))
			)

			;2020/02/13 YM ADD �ގ��L�����\������
      (set_tile "WTzai" (strcat (nth 4 #qry$)  " (" (nth 1 #qry$) ")"))  ; �ގ�
      (set_tile "WTcode"  #code)        ; �i��
      (set_tile "WTmoney" #money)       ; ���z
      (set_tile "WThigh"  #high)        ; ��t������
      (set_tile "WTmagu1" #magu1)       ; �Ԍ�1
      (set_tile "WTmagu2" #magu2)       ; �Ԍ�2
      (set_tile "WToku1"  #oku1)        ; ���s1
      (set_tile "WToku2"  #oku2)        ; ���s2
      (set_tile "WToku3"  #oku3)        ; ���s3 2012/04/19 YM ADD
      (set_tile "ana"  #dim)            ; �����@
    )
  );_if

  (if (= "" (nth 1 &lst$))
    (set_tile "error" "�i�Ԃ��m�肳��Ă��܂���")
  )

  (action_tile "accept" "(setq #lst$ nil)(done_dialog)")
  (action_tile "cancel" "(setq #lst$ nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  (princ)
);PKY_WKTopInfoDialog

;;;<HOM>*************************************************************************
;;; <�֐���>    : PcGetPrintNameH800
;;; <�����T�v>  : �i�Ԗ��̂�n���� ��K�w+SERIES��� �e�[�u������o�͖��̂�Ԃ�
;;; <�߂�l>    : �o�͖��̕����� �i�������s�Ȃ�"�K�w����2"�Ō����j
;;; <�쐬>      : 00/04/28 MH      00/06/28 YM MOD
;;; <���l>      : �����擾�̏ꍇ�͍ŏ��Ɍ��o�̂���
;;;*************************************************************************>MOH<
(defun PcGetPrintNameH800 (
  &sHINBAN    ; �i�Ԗ���
  &skk        ; ���i����
  /
  #sTABLE #QLY$ #sNAME #NAME$
  )
  (if (and &skk (= &skk CG_SKK_INT_SNK)) ; 01/08/31 YM MOD 410-->��۰��ى�
    (progn ; �ݸ�̏ꍇ"WT�ݸ"������
      (setq #name$ ; �P��������
        (CFGetDBSQLRec CG_DBSESSION "WT�V���N"
          (list (list "�i�Ԗ���" &sHINBAN 'STR))
        )
      );_(setq
      (setq #sNAME (nth 2 (car #name$))) ; �ݸ�̕i���擾
    )
    (progn
      ; ��K�w+SERIES��� �e�[�u�����쐬
      (setq #sTABLE "�K�w")
      ;�N�G���擾
      (setq #QLY$
        (car (CFGetDBSQLRec CG_DBSESSION #sTABLE
          (list
            (list "�K�w����" &sHINBAN 'STR)
          ); end of list
      ))); end of setq

      (if #QLY$
        (setq #sNAME (nth 6 #QLY$)) ;�K�w����i���擾
        ;else
        (setq #sNAME "") ;�i���擾�ł���
      );_if

      (if (/= 'STR (type #sNAME)) (setq #sNAME ""))
    )
  );_if

  (if (/= 'STR (type #sNAME)) (setq #sNAME ""))
  #sNAME
); PcGetPrintNameH800


;;;<HOM>*************************************************************************
;;; <�֐���>    : PKY_PartInfoDialog
;;; <�����T�v>  : �A�C�e�����(�z�u���ސ}�`�̏��)�ƃI�v�V�����i���̕\��
;;; <�߂�l>    :
;;; <�쐬>      : 00/02/22 MH ADD
;;; <���l>      : �I�v�V�������X�g��nil�̏ꍇ�I�v�V���������B��
;;;*************************************************************************>MOH<
(defun PKY_PartsInfoDialog (
  &lst$
  &oplst$
  &outname ; �o�͖���
  &SNK_ANA ; �ݸ�����H�L��
  &G_OPT2  ; "G_OPT2 �̂܂� ������߼�ݏ�� 03/06/17 YM ADD NAS�ł�nil
  &xdLSYM$ ; "G_LSYM" 03/10/12 YM ADD
  &symType ; ����(�L�b�`��/���[) (�g���f�[�^) 2011/12/22 �R�c �ǉ�
  /
  #dcl_id
  #lr
  #_lr
  #findFlg #outname
  #fX #fY #sADD #oplst$
#HINBAN #STENKAI_ID #SZUKEI_ID ;03/10/10 YM ADD
  #symType    ; ����(�L�b�`��/���[) (�g���f�[�^) 2011/12/22 �R�c �ǉ�
  )

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCCONF.DCL")))
  (if (not (new_dialog "PartsXData_Opt_Box" #dcl_id)) (exit))

  ;;; �I�v�V�������̏���
  (if (and (= 'LIST (type &oplst$)) (< 1 (length &oplst$)))
    ;;; �I�v�V������񃊃X�g���L���Ȃ�΃��X�g�{�b�N�X�ɕ\��
    (progn
      (setq #oplst$ &oplst$)
      (start_list "_option" 3)
      (while (< 1 (length #oplst$))
        (setq #outname (PcGetPrintNameH800 (car #oplst$) nil)) ; �i�Ԗ���--->�o�͖��� 06/29 YM
        (if (= #outname "")(setq #outname " "))
;-- 2011/08/05 A.Satoh Mod - S
;        (setq #sADD (strcat (car #oplst$) "\t" #outname "\t" (itoa (fix (cadr #oplst$)))))
        (setq #sADD (strcat (car #oplst$) "\t" (itoa (fix (cadr #oplst$)))))
;-- 2011/08/05 A.Satoh Mod - S
        (add_list #sADD)
        (repeat 2 (setq #oplst$ (cdr #oplst$)))
      )
      (end_list)
      (mode_tile "_option" 0)
    ); end of progn
    ;;; ���X�g�������A���X�g�{�b�N�X���g�p�֎~�ɂ���
    (progn
      (mode_tile "_option" 1)
    ); end of progn
  ); end of if

  (setq #lr (nth 1 &lst$))
  (setq #_lr
    (cond
     ((= #lr "Z") "")
     ((= #lr "L") " (L����)")
     ((= #lr "R") " (R����)")
    )
  )

  ; NAS �Ǝ� 01/06/19 YM ADD
  (NPGetDrCol) ; ��װ���۰��قɾ�� 01/06/20 YM ADD

  ;03/10/12 YM ADD &xdLSYM$ �ǉ�
;;; (setq #hinban (NPAddHinDrCol_WOODONE (nth 0 &lst$) (nth 1 &lst$) &xdLSYM$)) ; @@%#�t���i��,LR,LSYM
  (setq #hinban (strcat (nth 0 &lst$) #_lr))

  (set_tile "key_name" "�i�@�@��") ; 07/13 YM MOD �ݸ�����H�L������
  (set_tile "_name" #hinban); NAS �Ǝ� 01/06/19 YM MOD

;-- 2011/08/05 A.Satoh Del - S
;  (set_tile "key_name2" "�i�@�@��") ; 03/06/09 YM ADD
;  (set_tile "_outname" &outname)
;-- 2011/08/05 A.Satoh Del - E

  (if &SNK_ANA
    (progn ; �ݸ�m�F�̂Ƃ�
      (set_tile "_ins_pz" "0")
      (set_tile "_sym_w"  "0")
      (set_tile "_sym_d"  "0")
      (set_tile "_sym_h"  "0")
    )
    (progn
      (set_tile "_ins_pz" (rtos (nth 2 &lst$) 2 0)) ; precision=2 to 0 07/22 YM
      (set_tile "_sym_w"  (rtos (nth 3 &lst$) 2 0)) ; precision=2 to 0 07/22 YM
      (set_tile "_sym_d"  (rtos (nth 4 &lst$) 2 0)) ; precision=2 to 0 07/22 YM
      (set_tile "_sym_h"  (rtos (nth 5 &lst$) 2 0)) ; precision=2 to 0 07/22 YM
    )
  );_if

  ;;; ��2011/12/22 �R�c �ǉ� -------------------------------
  ; ���ނ��_�C�A���O�ɐݒ�
  (if (/= nil &symType)
    (set_tile "_sym_type" &symType)
    (mode_tile "_sym_type" 1)
  )
  ;;; ��2011/12/22 �R�c �ǉ� -------------------------------

  (setq #fX (dimx_tile "image"))
  (setq #fY (dimy_tile "image"))
  (start_image "image")
  (fill_image  0 0 #fX #fY -0)

  ; �����m�F�ŗ����� 01/08/07 YM ADD START
  (setq #sTENKAI_ID (nth 6 &lst$))
  (setq #sZUKEI_ID  (nth 7 &lst$))
  (if (= nil #sTENKAI_ID)
    (setq #sTENKAI_ID #sZUKEI_ID)
  );_if
  ; �����m�F�ŗ����� 01/08/07 YM ADD END

  ;;; 00/03/23 MH MOD  ���򕔕��S�ʏ�������
  (setq #findFlg T)

  (if (and (= nil #sTENKAI_ID)(= nil #sZUKEI_ID)) ; ��������ǉ� 01/08/07 YM ADD
    (progn
      (slide_image 0 0 #fX (- #fY 10) (strcat CG_SYSPATH "notfile.sld"))
      (setq #findFlg nil)
    )
    (progn
      (cond
        ((findfile (strcat CG_SKDATAPATH "CRT\\" (nth 6 &lst$) ".sld"))
          (slide_image 0 0 #fX (- #fY 10) (strcat CG_SKDATAPATH "CRT\\" (nth 6 &lst$) ".sld"))
        )
        ((findfile (strcat CG_SKDATAPATH "CRT\\" (nth 7 &lst$) ".sld"))
          (slide_image 0 0 #fX (- #fY 10) (strcat CG_SKDATAPATH "CRT\\" (nth 7 &lst$) ".sld"))
          (setq #findFlg nil)
        )
        (t
          (slide_image 0 0 #fX (- #fY 10) (strcat CG_SYSPATH "notfile.sld"))
          (setq #findFlg nil)
        )
      ); end of cond
    )
  );_if

  (end_image)
  ;;; ��2011/12/22 �R�c �ύX -------------------------------
  ;(action_tile "accept" "(done_dialog)")
  (action_tile "accept" "(progn (setq #symType (get_tile \"_sym_type\")) (done_dialog))") ; �I���������ނ̎擾
  ;;; ��2011/12/22 �R�c �ǉ� -------------------------------
  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; ��2011/12/22 �R�c �ǉ� -------------------------------
;  ; ���ނ�Ԃ�(�Đݒ�p)
  (if (/= nil &symType)
    #symType
    nil
  )
  ;;; ��2011/12/22 �R�c �ǉ� -------------------------------
);PKY_PartsInfoDialog

;;;<HOM>*************************************************************************
;;; <�֐���>    : NPGetDrCol
;;; <�����T�v>  : ��װ���۰���(CG_DRColCode)�ɾ�Ă���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/06/20 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun NPGetDrCol (
  /
  #MSG1 #MSG2 #SERI$
  )
  (setq #msg1 "��COLOR�L����������܂���B")
  (setq #msg2 "�R�}���h���I�����܂����B")
  (if (setq #seri$ (CFGetXRecord "SERI"))
    (setq CG_DRColCode (nth 4 #seri$)) ;��COLOR�L��
    (progn
      (CFAlertErr #msg1)
      (princ #msg2)
      (*error*)
    )
  );_if
  (princ)
);NPGetDrCol

;;;<HOM>*************************************************************************
;;; <�֐���>    : NPAddHinDrCol_WOODONE
;;; <�����T�v>  : ���ޕi�Ԃ�@@%�����ɔ�װ+LR�����ĕԂ�
;;; <�߂�l>    : �i�ԕ�����
;;; <�쐬>      : 2010/01/07 YM ADD
;;; <���l>      : ���g�p
;;;*************************************************************************>MOH<
(defun NPAddHinDrCol_WOODONE (
  &hinban ; ���i��
  &LR     ; LR�敪
  &xdLSYM$ ; "G_LSYM" 03/10/12 YM ADD
  /
  #RET #HIKITE #COLOR #CG_DRCOLCODE #DRSERICODE #RET$ #DoorInfo
#CG_DRSERICODE #CG_HIKITE
  )

  ; 03/10/12 YM ADD-S �����ύX���L���擾
  (if &xdLSYM$
    (progn
      (setq #DoorInfo  (nth 7 &xdLSYM$)) ; "��ذ��,��װ�L��"
      (setq #ret$ (StrParse #DoorInfo ",")) ; 01/10/11 YM MOD ":"->","
      (setq #CG_DRSeriCode (car   #ret$))
      (setq #CG_DRColCode  (cadr  #ret$))
      (setq #CG_HIKITE     (caddr #ret$))
    )
    ;else
    (progn
      (setq #CG_DRSeriCode "$")
      (setq #CG_DRColCode  "@@")
      (setq #CG_HIKITE     "#")
    )
  );_if
  ; 03/10/12 YM ADD-E �����ύX���L���擾

  (if (or (= nil #CG_DRColCode)(= "" #CG_DRColCode))
    (setq #CG_DRColCode CG_DRColCode)
  );_if

  ;LR������
  (setq #ret (vl-string-subst &LR "%" &hinban))

  (cond
    ((wcmatch #ret "*`@`@`@*");�V���
      ;04/07/12 YM MOD-S ���F�L��2 or 3���Ή�
      (if (and #CG_DRColCode (/= #CG_DRColCode ""))
        (setq #ret (vl-string-subst #CG_DRColCode "@@@" #ret))
      );_if
      ;03/10/12 YM MOD-E
    )
    ((wcmatch #ret "*`@`@`#*");DIPLOA
      ; 03/10/07 YM ADD �ި��۱�Ή�
      ;����L�����擾 nil or 1����
      (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode �ɕύX
      (setq #ret (vl-string-subst #CG_DRColCode "@@#" #ret)) ; "@@#"�ɔ�װ����"@@#"���Ȃ��Ƃ��̂܂�
    )
    (T ;���̑��ذ��
      ;03/10/12 YM MOD-S ���F�L��2 or 3���Ή�
      ;�ʏ�̏ꍇ
      (if (and #CG_DRColCode (/= #CG_DRColCode ""))
        (setq #ret (vl-string-subst (substr #CG_DRColCode 1 2) "@@" #ret))
      );_if
      ;03/10/12 YM MOD-E
    )
  );_cond

  (if (wcmatch #ret "*`#*");DIPLOA �܂�"#"���c���Ă���
    (progn
      (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode �ɕύX
      (setq #ret (vl-string-subst #HIKITE "#" #ret));�i��"SC#"��"#"�Ɉ���L��������
    )
  );_if

  (if (wcmatch #ret "*`@*");DIPLOA �܂�"@"���c���Ă���
    (progn
      ;�X��"@"����F�L��1���ɕύX���� 03/10/10 YM ADD
      ;���F�L��1�����擾 nil or 1����
      (setq #COLOR (KPGetColor #CG_DRColCode))
      (setq #ret (vl-string-subst #COLOR "@" #ret));�i��"A@A"��"@"�ɐF�L��������
    )
  );_if

  #ret
);NPAddHinDrCol_WOODONE

;;;<HOM>*************************************************************************
;;; <�֐���>    : NPAddHinDrCol
;;; <�����T�v>  : ���ޕi�Ԃ�@@%�����ɔ�װ+LR�����ĕԂ�
;;; <�߂�l>    : �i�ԕ�����
;;; <�쐬>      : 01/06/19 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun NPAddHinDrCol (
  &hinban ; ���i��
  &LR     ; LR�敪
  &xdLSYM$ ; "G_LSYM" 03/10/12 YM ADD
  /
  #RET #HIKITE #COLOR #CG_DRCOLCODE #DRSERICODE #RET$
  )

  ; 03/10/12 YM ADD-S �����ύX���L���擾
  (if &xdLSYM$
    (progn
      (setq #CG_DRColCode  (nth 7 &xdLSYM$)) ; "��ذ��,��װ�L��"
      (setq #ret$ (StrParse #CG_DRColCode ",")) ; 01/10/11 YM MOD ":"->","
      (setq #DRSeriCode (car  #ret$))
      (setq #CG_DRColCode  (cadr #ret$))
    )
    ;else
    (setq #CG_DRColCode CG_DRColCode)
  );_if
  ; 03/10/12 YM ADD-E �����ύX���L���擾

  (if (or (= nil #CG_DRColCode)(= "" #CG_DRColCode))
    (setq #CG_DRColCode CG_DRColCode)
  );_if

  ;LR������
  (setq #ret (vl-string-subst &LR "%" &hinban))

  (cond
    ((wcmatch #ret "*`@`@`@*");�V���
      ;04/07/12 YM MOD-S ���F�L��2 or 3���Ή�
      (if (and #CG_DRColCode (/= #CG_DRColCode ""))
        (setq #ret (vl-string-subst #CG_DRColCode "@@@" #ret))
      );_if
      ;03/10/12 YM MOD-E
    )
    ((wcmatch #ret "*`@`@`#*");DIPLOA
      ; 03/10/07 YM ADD �ި��۱�Ή�
      ;����L�����擾 nil or 1����
      (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode �ɕύX
      (setq #ret (vl-string-subst #CG_DRColCode "@@#" #ret)) ; "@@#"�ɔ�װ����"@@#"���Ȃ��Ƃ��̂܂�
    )
    (T ;���̑��ذ��
      ;03/10/12 YM MOD-S ���F�L��2 or 3���Ή�
      ;�ʏ�̏ꍇ
      (if (and #CG_DRColCode (/= #CG_DRColCode ""))
        (setq #ret (vl-string-subst (substr #CG_DRColCode 1 2) "@@" #ret))
      );_if
      ;03/10/12 YM MOD-E
    )
  );_cond

  (if (wcmatch #ret "*`#*");DIPLOA �܂�"#"���c���Ă���
    (progn
      (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode �ɕύX
      (setq #ret (vl-string-subst #HIKITE "#" #ret));�i��"SC#"��"#"�Ɉ���L��������
    )
  );_if

  (if (wcmatch #ret "*`@*");DIPLOA �܂�"@"���c���Ă���
    (progn
      ;�X��"@"����F�L��1���ɕύX���� 03/10/10 YM ADD
      ;���F�L��1�����擾 nil or 1����
      (setq #COLOR (KPGetColor #CG_DRColCode))
      (setq #ret (vl-string-subst #COLOR "@" #ret));�i��"A@A"��"@"�ɐF�L��������
    )
  );_if

  #ret
);NPAddHinDrCol

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPGetHikite
;;; <�����T�v>  : ��װ�L���������L�����擾
;;; <�߂�l>    : "" or 1����
;;; <�쐬>      : 03/10/07 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KPGetHikite (
  &CG_DRColCode
  /
  #ret
  )
  (setq #ret "")
  ;����L�����擾 nil or 1����
  (if (and &CG_DRColCode (/= nil &CG_DRColCode))
    (setq #ret (substr &CG_DRColCode 3 1))
  );_if
  #ret
);KPGetHikite

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPGetColor
;;; <�����T�v>  : ��װ�L������F�L��1�����擾
;;; <�߂�l>    : 1����
;;; <�쐬>      : 03/10/10 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KPGetColor (
  &CG_DRColCode
  /
  #ret
  )
  (setq #ret "")
  ;����L�����擾 nil or 1����
  (if (and &CG_DRColCode (/= nil &CG_DRColCode))
    (setq #ret (substr &CG_DRColCode 2 1))
  );_if
  #ret
);KPGetColor

;;;<HOM>*************************************************************************
;;; <�֐���>    : NPAddHinDrCol2
;;; <�����T�v>  : ���ޕi�Ԃ�@@%������[?:??]���̔��??� + LR�����ĕԂ�
;;;               ������
;;; <�߂�l>    : �i�ԕ�����
;;; <�쐬>      : 01/12/07 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun NPAddHinDrCol2 (
  &hinban ; ���i�� "STTF045@@%[B:BA]"
  &LR     ; LR�敪
  /
  #RET #CG_DRCOLCODE #NO1 #NO2 #NO3 #HIKITE #COLOR
#COL1 #COL2 #LASTHINBAN #QRY$$ ;03/10/10 YM ADD
#END #NO%
  )
    ;/////////////////////////////////////////////////////////////////////////
    ; &obj �� &str �̉��Ԃ߂�.�Ȃ����nil��Ԃ�
    (defun ##GetIndex (
      &str ; STR
      &obj ; �Ώە���
      /
      #I #LOOP #NO #STR
      )
      (setq #no nil) ; "[" �����Ԗڂ�
      (setq #i 1 #loop T)
      (while (and #loop (< #i (1+ (strlen &str))))
        (if (= (substr &str #i 1) &obj)
          (progn
            (setq #no #i)
            (setq #loop nil)
          )
        );_if
        (setq #i (1+ #i))
      )
      #no
    );##GetIndex
    ;/////////////////////////////////////////////////////////////////////////

  (setq #no1 (##GetIndex &hinban "[")) ; "[" �����Ԗڂ�
  (setq #no2 (##GetIndex &hinban ":")) ; ":" �����Ԗڂ�
  (setq #no3 (##GetIndex &hinban "]")) ; "]" �����Ԗڂ�
  (if (and #no1 #no2 #no3)
    (progn ; [*]����
      (setq #CG_DRColCode (substr &hinban (1+ #no2)(- #no3 #no2 1))) ; ��װ���� @@@
    )
    (progn ; [*]�Ȃ�
      (setq #CG_DRColCode CG_DRColCode) ; �}�ʂ̔�װ
    )
  );_if

;;; (vl-string-subst new-str pattern string [start-pos])

  ; 02/03/21 YM ADD-S
  (setq #LastHinban nil)
  (setq #LastHinban (KPGetLastHinban &hinban &LR))
  (if #LastHinban
    (setq #ret #LastHinban)                                  ; �ŏI�i�Ԃ��g�p
  ; else
    (progn
      ; 03/01/27 YM ADD-S
      ; ���F�ϊ�TB����
      ; 06/09/25 T.Ari Mod ���F�ϊ������폜
      (setq #Qry$$ nil)
;     (setq #Qry$$
;       (CFGetDBSQLRec CG_DBSESSION "���F�ϊ�"
;         (list (list "SERIES�L��" CG_SeriesCode 'STR))
;       )
;     )
      (if #Qry$$ ; ��������
        (progn
          (setq #COL2 nil) ; �ϊ�����F(�d�l�\�̔��F����F�ϊ�TB�ɏ]���ĕϊ�����)
          (foreach #Qry$ #Qry$$
            (setq #COL1 (nth 2 #Qry$)) ; �ϊ���
            (if (= #CG_DRColCode #COL1)
              (setq #COL2 (nth 3 #Qry$)) ; �ϊ���
            );_if
          )
          (if #COL2
            (setq #CG_DRColCode #COL2)
          );_if
        )
      );_if

      ;04/07/30 YM MOD �V��̑Ή�
      (setq #ret &hinban)
      (cond
        ((wcmatch #ret "*`@`@`@*");�V���
          ;04/07/12 YM MOD-S ���F�L��2 or 3���Ή�
          (if (and #CG_DRColCode (/= #CG_DRColCode ""))
            (setq #ret (vl-string-subst #CG_DRColCode "@@@" #ret))
          );_if
          ;03/10/12 YM MOD-E
        )
        ((wcmatch #ret "*`@`@`#*");DIPLOA
          ; 03/10/07 YM ADD �ި��۱�Ή�
          ;����L�����擾 nil or 1����
          (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode �ɕύX
          (setq #ret (vl-string-subst #CG_DRColCode "@@#" #ret)) ; "@@#"�ɔ�װ����"@@#"���Ȃ��Ƃ��̂܂�
        )
        (T ;���̑��ذ��
          ;03/10/12 YM MOD-S ���F�L��2 or 3���Ή�
          ;�ʏ�̏ꍇ
          (if (and #CG_DRColCode (/= #CG_DRColCode ""))
            (setq #ret (vl-string-subst (substr #CG_DRColCode 1 2) "@@" #ret))
          );_if
          ;03/10/12 YM MOD-E
        )
      );_cond

      (if (wcmatch #ret "*`#*");DIPLOA �܂�"#"���c���Ă���
        (progn
          (setq #HIKITE (KPGetHikite #CG_DRColCode));DRColCode==>#CG_DRColCode �ɕύX
          (setq #ret (vl-string-subst #HIKITE "#" #ret));�i��"SC#"��"#"�Ɉ���L��������
        )
      );_if

      (if (wcmatch #ret "*`@*");DIPLOA �܂�"@"���c���Ă���
        (progn
          ;�X��"@"����F�L��1���ɕύX���� 03/10/10 YM ADD
          ;���F�L��1�����擾 nil or 1����
          (setq #COLOR (KPGetColor #CG_DRColCode))
          (setq #ret (vl-string-subst #COLOR "@" #ret));�i��"A@A"��"@"�ɐF�L��������
        )
      );_if
      ;04/07/30 YM MOD �V��̑Ή�

;;;     ; 03/09/18 YM ADD �ި��۱�Ή�
;;;     (setq #ret (vl-string-subst #CG_DRColCode "@@#" &hinban)) ; "@@#"�ɔ�װ����"@@#"���Ȃ��Ƃ��̂܂�
;;;
;;;     ;03/10/12 YM MOD-S ���F�L��2 or 3���Ή�
;;;     (if (and #CG_DRColCode (/= #CG_DRColCode ""))
;;;       (setq #ret (vl-string-subst (substr #CG_DRColCode 1 2) "@@" #ret))
;;;     );_if
;;;     ;03/10/12 YM MOD-E
;;;
;;;     ; 03/10/07 YM ADD �ި��۱�Ή�
;;;     ;����L�����擾 nil or 1����
;;;     (setq #HIKITE (KPGetHikite #CG_DRColCode))
;;;     (setq #ret (vl-string-subst #HIKITE "#" #ret));�i��"SC#"��"#"�Ɉ���L��������
;;;
;;;     ;�X��"@"����F�L��1���ɕύX���� 03/10/10 YM ADD
;;;     ;���F�L��1�����擾 nil or 1����
;;;     (setq #COLOR (KPGetColor #CG_DRColCode))
;;;     (setq #ret (vl-string-subst #COLOR "@" #ret));�i��"A@A"��"@"�ɐF�L��������

    )
  );_if
  ; 02/03/21 YM ADD-E

  ;03/10/24 YM ADD-S
  ;"%"��������[]���Ȃ������疖����"L","R"����菜��
  (setq #no% (##GetIndex #ret "%")) ; "%" �����Ԗڂ�
  (if #no%
    (progn
      (if (and #no1 #no2 #no3)
        nil ;[]����
        ;else
        (progn ;[]���Ȃ�
          (setq #end (substr #ret (strlen #ret) 1));����1����
          (if (or (= #end "R")(= #end "L"))
            (setq #ret (substr #ret 1 (1- (strlen #ret))));����1�����폜
          );_if
        )
      );_if
    )
  );_if
  ;03/10/24 YM ADD-E


;;;02/03/21YM@MOD (setq #ret (vl-string-subst #CG_DRColCode "@@" &hinban))
  (setq #ret (vl-string-subst &LR "%" #ret))

  ; []��������菜��
  (setq #ret (KP_DelDrSeriStr #ret))

  #ret
);NPAddHinDrCol2

;;;<HOM>*************************************************************************
;;; <�֐���>    : NPGetLR
;;; <�����T�v>  : ���ޕi�ԕ����񂩂�LR���擾���ĕԂ�
;;; <�߂�l>    : LR
;;; <�쐬>      : 02/05/13 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun NPGetLR (
  &str ; ���i�� "STTF045@@%[B:BA]"�Ȃ�
  /
  #NO1 #NO2 #NO3 #RET #NO%
  )
    ;/////////////////////////////////////////////////////////////////////////
    ; &obj �� &str �̉��Ԃ߂�.�Ȃ����nil��Ԃ�
    (defun ##GetIndex (
      &str ; STR
      &obj ; �Ώە���
      /
      #I #LOOP #NO #STR
      )
      (setq #no nil) ; "[" �����Ԗڂ�
      (setq #i 1 #loop T)
      (while (and #loop (< #i (1+ (strlen &str))))
        (if (= (substr &str #i 1) &obj)
          (progn
            (setq #no #i)
            (setq #loop nil)
          )
        );_if
        (setq #i (1+ #i))
      )
      #no
    );##GetIndex
    ;/////////////////////////////////////////////////////////////////////////

  (setq #no1 (##GetIndex &str "[")) ; "[" �����Ԗڂ�
  (setq #no2 (##GetIndex &str ":")) ; ":" �����Ԗڂ�
  (setq #no3 (##GetIndex &str "]")) ; "]" �����Ԗڂ�
  (if (and #no1 #no2 #no3)
    (progn ; [*]����
      (setq #ret (substr &str (1+ #no3) 1)) ; LR���� ""������
      (if (= #ret "")
        (setq #ret "Z") ; LR
      );_if
    )
    (progn ; [*]�Ȃ�
;;;     (setq #ret "Z") ; LR 03/10/22 YM MOD
      ;"%"������Έ�ԍŌ�̕���,����ȊO��"Z"
      (setq #no% (##GetIndex &str "%")) ; "%" �����Ԗڂ�
      (if #no%
        (progn
          (setq #ret (substr &str (strlen &str) 1))
          (if (and (/= #ret "R")(/= #ret "L"))
            (setq #ret "Z") ; LR
          );_if
        )
        ;else
        (setq #ret "Z") ; LR
      );_if
    )
  );_if

  #ret
);NPGetLR

;<HOM>*************************************************************************
; <�֐���>    : C:ConfPartsAll
; <�����T�v>  : �}�ʏ�̑S�z�u���ނ̊m�F�@(�ǉ����ނ��\��)
; <�߂�l>    :
; <�쐬>      : 2011/08/12 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun C:ConfPartsAll (
  /
  #CG_SpecList$$ #hin_old #LR_old #num_CHANGE$ #num #hin #LR
  #num_CHANGE #dum1$ #dum2$ #dum$$ #fname #fp #i #k
;-- 2011/09/02 A.Satoh Add - S
  #Expense$
;-- 2011/09/02 A.Satoh Add - E
  #A_CNT #BUNRUI #CG_SPECLIST$ #CG_SPECLISTA$$ #CG_SPECLISTD$$ #D_CNT #LIST$ ;2011/09/23 YM ADD
#ss_LSYM #idx #xd$ #DoorInfo #hinban #Qry_kihon$$ #tenkai_type ;-- 2012/02/18 A.Satoh Add
  )

	;2014/05/29 YM ADD-S
	(setq CG_GLOBAL$ nil)
	;2014/05/29 YM ADD-E

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ConfPartsAll ////")
  (CFOutStateLog 1 1 " ")

  ; �O����
  (StartUndoErr)

  ; �t���[�v�����݌v��ʂ̏���
  (C:arxStartApp (strcat CG_SysPATH "KillPlan.exe") 0)

;-- 2011/09/02 A.Satoh Add - S
  ; buzai.cfg��[EXPENSE]��ێ�����
  (setq #Expense$ (ConfPartsAll_GetExpenseFromBuzaiFile))
;-- 2011/09/02 A.Satoh Add - E

;-- 2012/02/18 A.Satoh Add - S
; �y[woodone-prj:04712] Re: �Q/�P�R����z�Ή�
	(setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss_LSYM (< 0 (sslength #ss_LSYM)))
    (progn
			(setq #idx 0)
			(repeat (sslength #ss_LSYM)
				(setq #sym (ssname #ss_LSYM #idx))
				;�y�i�Ԋ�{�z�W�J�^�C�v=0�̂Ƃ�G_LSYM����񂪂Ȃ���ξ�Ă���
				(setq #xd$ (CFGetXData #sym "G_LSYM"))

	      (setq #DoorInfo (nth 7 #xd$)) ; "��ذ��,��װ�L��"
	      (if (or (= nil #DoorInfo)(= #DoorInfo ""))
					(progn
						(setq #hinban (nth 5 #xd$));�i�Ԗ���
						;�W�J���ߎ擾
		        (setq #Qry_kihon$$
		          (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
		            (list (list "�i�Ԗ���"  #hinban 'STR))
		          )
		        )
						(if (and #Qry_kihon$$ (= 1 (length #Qry_kihon$$)))
							(progn
								(setq #tenkai_type (nth 4 (car #Qry_kihon$$)));�W�J����
								(if (equal #tenkai_type 0.0 0.001);�W�J����=0
									(progn ;�����X�V
		                (CFSetXData #sym "G_LSYM"
		                  (CFModList #xd$
		                    (list
		                      (list 7 (strcat CG_DRSeriCode "," CG_DRColCode "," CG_HIKITE))
		                    )
		                  )
		                )
									)
								);_if
							)
						);_if
					)
				);_if
				(setq #idx (1+ #idx))
			);repeart
		)
	);_if
;-- 2012/02/18 A.Satoh Add - E

  ; �}�ʏ�̕��ނ��擾����
  (setq #CG_SpecList$$ (ConfPartsAll_SetSpecList))

  (setq #hin_old nil)
  (setq #LR_old  nil)
  (setq #num_CHANGE$ nil)

  ;����ւ��L������ �����i�Ԃ��A�����AR,L�̏��Ԃł����L,R�̏��Ԃɂ���
  (foreach #CG_SpecList$ #CG_SpecList$$
    (setq #num (nth  0 #CG_SpecList$));�ԍ�
;-- 2011/10/18 A.Satoh Mod - S
;;;;;    (setq #hin (nth  9 #CG_SpecList$))
;;;;;    (setq #LR  (nth 10 #CG_SpecList$))
    (setq #hin (nth 11 #CG_SpecList$))
    (setq #LR  (nth 12 #CG_SpecList$))
;-- 2011/10/18 A.Satoh Mod - E
    (if (and (= #hin #hin_old) (= "R" #LR_old) (= "L" #LR))
      (setq #num_CHANGE$ (append #num_CHANGE$ (list (atoi #num))));1��O�Ɠ���ւ����K�v(����)
    );_if
    (setq #hin_old #hin)
    (setq #LR_old   #LR)
  );foreach

  ;����ւ�����
  (if #num_CHANGE$
    (progn
      (foreach #num_CHANGE #num_CHANGE$ ;#num_CHANGE��1�O�Ɠ���ւ���
        ;1�O
        (setq #dum1$ (assoc (itoa (1- #num_CHANGE)) #CG_SpecList$$))

        ;�ԍ�����׽
        (setq #dum1$ (CFModList #dum1$ (list (list 0 (itoa #num_CHANGE)))))

        ;���̎�
        (setq #dum2$ (assoc (itoa #num_CHANGE) #CG_SpecList$$))

        ;�ԍ���ϲŽ
        (setq #dum2$ (CFModList #dum2$ (list (list 0 (itoa (1- #num_CHANGE))))))

        ;1�O��#dum1$�ɓ���ւ���
        (setq #CG_SpecList$$ (CFModList #CG_SpecList$$ (list (list (- #num_CHANGE 2) #dum1$))))

        ;���̎���#dum2$�ɓ���ւ���
        (setq #CG_SpecList$$ (CFModList #CG_SpecList$$ (list (list (- #num_CHANGE 1) #dum2$))))
      )

      ; �ԍ��Ń\�[�g�i�����ſ�Ă����"1","10","11","2"�ƂȂ��Ă��܂����琔���ſ�Ă��Ȃ�����ҁj
      (setq #dum$$ nil)
      (foreach #CG_SpecList$ #CG_SpecList$$
        (setq #k (atoi (nth 0 #CG_SpecList$)))
        (setq #dum$$ (append #dum$$ (list (cons #k #CG_SpecList$ ))));�ԍ���擪�ɒǉ�
      )

      ;�����̔ԍ��ſ��
      (setq #dum$$ (CFListSort #dum$$ 0))

      (setq #CG_SpecList$$ nil);�ر
      (foreach #dum$ #dum$$
        (setq #CG_SpecList$ (cdr #dum$))
        (setq #CG_SpecList$$ (append #CG_SpecList$$ (list #CG_SpecList$)))
      )
    )
  )

  ; �L�b�`���A���[�p�ɕ���
  (setq #CG_SpecListA$$ nil)
  (setq #CG_SpecListD$$ nil)
  (setq #a_cnt 0)
  (setq #d_cnt 0)

  (foreach #CG_SpecList$ #CG_SpecList$$
    (setq #bunrui (nth 8 #CG_SpecList$))
    (if (= #bunrui "A")
      (progn
        (setq #a_cnt (1+ #a_cnt))
        ; �L�b�`���p��񃊃X�g�쐬
        (setq #list$
          (list
            (list
              #a_cnt
              (nth 1 #CG_SpecList$)
              (nth 2 #CG_SpecList$)
              (nth 3 #CG_SpecList$)
              (nth 4 #CG_SpecList$)
              (nth 5 #CG_SpecList$)
              (nth 6 #CG_SpecList$)
              (nth 7 #CG_SpecList$)
;-- 2011/11/24 A.Satoh Add - S
              (nth 13 #CG_SpecList$)
              (nth 14 #CG_SpecList$)
;-- 2011/11/24 A.Satoh Add - E
            )
          )
        )
        (setq #CG_SpecListA$$ (append #CG_SpecListA$$ #list$))
      )
      (progn
        (setq #d_cnt (1+ #d_cnt))
        ; ���[�p��񃊃X�g�쐬
        (setq #list$
          (list
            (list
              #d_cnt
              (nth 1 #CG_SpecList$)
              (nth 2 #CG_SpecList$)
              (nth 3 #CG_SpecList$)
              (nth 4 #CG_SpecList$)
              (nth 5 #CG_SpecList$)
              (nth 6 #CG_SpecList$)
              (nth 7 #CG_SpecList$)
;-- 2011/11/24 A.Satoh Add - S
              (nth 13 #CG_SpecList$)
              (nth 14 #CG_SpecList$)
;-- 2011/11/24 A.Satoh Add - E
            )
          )
        )
        (setq #CG_SpecListD$$ (append #CG_SpecListD$$ #list$))
      )
    )
  )

  ; �ubuzai.cfg�v�̏o��
  (setq #fname (strcat CG_KENMEIDATA_PATH "buzai.cfg"))
  (setq #fp  (open #fname "w"))
  (if (/= #fp nil)
    (progn
      (if #CG_SpecListA$$
        (progn
          (princ "[A]\n" #fp)
          (foreach #CG_SpecListA$ #CG_SpecListA$$
            (setq #i 0)
            (repeat (1- (length #CG_SpecListA$))
              (princ (nth #i #CG_SpecListA$) #fp)
              (princ "," #fp)
              (setq #i (1+ #i))
            )
            (princ (nth #i #CG_SpecListA$) #fp)
            (princ "\n" #fp)
          )
        )
      )

      (if #CG_SpecListD$$
        (progn
          (princ "[D]\n" #fp)
          (foreach #CG_SpecListD$ #CG_SpecListD$$
            (setq #i 0)
            (repeat (1- (length #CG_SpecListD$))
              (princ (nth #i #CG_SpecListD$) #fp)
              (princ "," #fp)
              (setq #i (1+ #i))
            )
            (princ (nth #i #CG_SpecListD$) #fp)
            (princ "\n" #fp)
          )
        )
      )

;-- 2011/09/02 A.Satoh Add - S
      (if #Expense$
        (progn
          (princ "[EXPENSE]\n" #fp)
          (setq #i 0)
          (repeat (length #Expense$)
            (princ (car (nth #i #Expense$)) #fp)
            (princ (cadr (nth #i #Expense$)) #fp)
            (princ "\n" #fp)
            (setq #i (1+ #i))
          )
        )
      )
;-- 2011/09/02 A.Satoh Add - E

      (close #fp)
    )
  )

  ; �u�z�u���ވꊇ�m�F�v���W���[���Ăяo��
  (C:arxStartApp (strcat CG_SysPATH "ConfAllParts.exe") 1)

;  (alert "�������@�H�����@������")

  ; �㏈��
  (setq *error* nil)

  (princ)
);C:ConfPartsAll


;-- 2011/09/02 A.Satoh Add - S
;;;<HOM>************************************************************************
;;; <�֐���>  : ConfPartsAll_GetExpenseFromBuzaiFile
;;; <�����T�v>: buzai.cfg��[EXPENSE]���ڂ����X�g�ŕԂ�
;;; <�߂�l>  : Expense���ڃ��X�g or nil
;;; <�쐬>    : 2011/09/02 A.Satoh
;;; <���l>    : 
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetExpenseFromBuzaiFile (
  /
  #fname #fp #ret$ #buf #j #loop #str #title
#syori ;2011/09/23 YM ADD
  )

  ; buzai.cfg���J��
  (setq #fname (strcat CG_KENMEIDATA_PATH "buzai.cfg"))
  (setq #fp (open #fname "r"))
  (if (/= #fp nil)
    (progn
      (setq #syori nil)
      (setq #ret$ nil)
      (setq #buf T)
      (while #buf
        (setq #buf (read-line #fp))
        (if #buf
          (if (= #syori nil)
            (if (= #buf "[EXPENSE]")
              (setq #syori T)
            )
            (progn
              (setq #j 1)
              (setq #loop T)
              (repeat (strlen #buf)
                (if (= #loop T)
                  (progn
                    (if (= (substr #buf #j 1) "=")
                      (progn
                        (setq #title (substr #buf 1 #j))
                        (setq #str (substr #buf (1+ #j)))
                        (setq #loop nil)
                      )
                    )
                    (setq #j (1+ #j))
                  )
                )
              )

              (setq #ret$ (append #ret$ (list (list #title #str))))
            )
          )
        )
      )

      (close #fp)
    )
    (setq #ret$ nil)
  )


  #ret$

) ;ConfPartsAll_GetExpenseFromBuzaiFile
;-- 2011/09/02 A.Satoh Add - S


;;;<HOM>************************************************************************
;;; <�֐���>  : ConfPartsAll_SetSpecList
;;; <�����T�v>: �z�u���ނ̎d�l�\����ݒ肷��
;;; <�߂�l>  : �d�l�\��񃊃X�g
;;; <���l>    : ���L�O���[�o���ϐ���ݒ�
;;;               CG_DBNAME      : DB����
;;;               CG_SeriesCode  : SERIES�L��
;;;               CG_BrandCode   : �u�����h�L��
;;;************************************************************************>MOH<
(defun ConfPartsAll_SetSpecList (
  /
  #seri$ #spec$$
  )

  ; ���݂̏��i����ݒ�
  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DBNAME      (nth 0 #seri$))  ; DB����
      (setq CG_SeriesCode  (nth 1 #seri$))  ; SERIES�L��
      (setq CG_BrandCode   (nth 2 #seri$))  ; �u�����h�L��
    )
  )

  ; ���ʃf�[�^�x�[�X�ւ̐ڑ�
  (if (= CG_CDBSESSION nil)
    (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  )

  ; SERIES�ʃf�[�^�x�[�X�ւ̐ڑ�
  (if (= CG_DBSESSION nil)
    (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  )

;  ;// �z�u���ގd�l�����擾
;  (princ "\n�z�u���ނ̎d�l�����擾���Ă��܂�...")

  ; �z�u���ގd�l�ڍ׏����擾
  (setq #spec$$ (ConfPartsAll_GetSpecInfo))

  ; �z�u���ގd�l�ڍ׏����擾
  (setq #spec$$ (ConfPartsAll_GetSpecList #spec$$))


;  ;// �d�l�ԍ��o�_�ɕi�Ԗ��̂�ݒ�
;  (SKB_SetBalPten)

  #spec$$

) ;ConfPartsAll_SetSpecList




;;;<HOM>************************************************************************
;;; <�֐���>  : ConfPartsAll_GetSpecInfo
;;; <�����T�v>: �z�u���ގd�l�ڍ׏����擾����
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                 1.�A��(1�`)
;;;                 2.�\�[�g�L�[
;;;                 3.���[�N�g�b�v�i�Ԗ���
;;;                 4.�}�`�n���h��
;;;                 5.���͔z�u�p�i�Ԗ���
;;;                 6.�o�͖��̃R�[�h
;;;                 7.�d�l���̃R�[�h
;;;                 8.��
;;;                 9.���z
;;;                10.�i�R�[�h
;;;                11.���ގ�ރt���O (0:�W������ 1:����WT 2:�V��t�B���[ 3:�⑫����)
;;;                12.�W��ID
;;;                13.���@
;;;                14.�|��or��悹�z
;;;               )
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetSpecInfo (
  /
  #wtlst$$
  #bzlst$$
  #all-lst$$
  #dtlst$$
  #lst$
  #no
  #filer$
  #hosoku$
  #option$
  #SpecInfo$$ #BGLST$$ #KEKOMI$
  )

    ;//////////////////////////////////////////////////
    ; �����i�ԂȂ���𑝂₷
    ;//////////////////////////////////////////////////
    (defun ##HINBAN_MATOME (
      &lis$
      /
      #ret$ #LR #e #hin #ko #kosu #loop #i #dum$ #f #fnew
      #hin$
;-- 2011/08/12 A.Satoh Add - S
      #bunrui
;-- 2011/08/12 A.Satoh Add - E
			#t_flg	;-- 2011/11/24 A.Satoh Add
      )

      (setq #ret$ nil #hin$ nil)
      (foreach #e &lis$
        (setq #hin (nth 1 #e))
        (setq #LR  (nth 3 #e))
        (setq #ko  (nth 6 #e))
;-- 2011/08/12 A.Satoh Add - S
        (setq #bunrui (nth 11 #e))
;-- 2011/08/12 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
				(setq #t_flg (nth 13 #e))
;-- 2011/11/24 A.Satoh Add - E

;-- 2011/08/12 A.Satoh Mod - S
;        (setq #dum$ (list #hin #LR))
        (setq #dum$ (list #hin #LR #bunrui))
;-- 2011/08/12 A.Satoh Mod - E
        (if (member #dum$ #hin$)
;-- 2011/11/24 A.Satoh Add - S
					(if (= #t_flg 0)
;-- 2011/11/24 A.Satoh Add - W
          (progn ; �������̂���
            (setq #loop T #i 0)
            (setq #kosu (length #ret$))
            (while (and #loop (< #i #kosu))
              (setq #f (nth #i #ret$))
              (if (and (= (nth 1 #f) #hin)(= (nth 3 #f) #LR))
                (progn
                  (setq #loop nil)
                  (setq #fnew (CFModList #f (list (list 6 (+ #ko (nth 6 #f))))))
                )
              )
              (setq #i (1+ #i))
            )
            (setq #ret$ (subst #fnew #f #ret$)) ; �v�f���ւ�
          )
;-- 2011/11/24 A.Satoh Add - S
						(progn
	            (setq #hin$ (append #hin$ (list (list #hin #LR #bunrui)))) ; �i��ؽ�
	            (setq #ret$ (append #ret$ (list #e)))
						)
					)
;-- 2011/11/24 A.Satoh Add - W
          (progn ; ���߂�
;-- 2011/08/12 A.Satoh Mod - S
;            (setq #hin$ (append #hin$ (list (list #hin #LR)))) ; �i��ؽ�
            (setq #hin$ (append #hin$ (list (list #hin #LR #bunrui)))) ; �i��ؽ�
;-- 2011/08/12 A.Satoh Mod - E
            (setq #ret$ (append #ret$ (list #e)))
          )
        )
      )
      #ret$
    );##HINBAN_MATOME
    ;//////////////////////////////////////////////////

; ; SET�\���m�F����ނ̂Ƃ��͍�}���Ȃ�
;  ; ���[�N�g�b�v�A�V��t�B���[�̎d�l�ԍ��_����}
; (if (= nil CG_SetHIN)
;   (progn
;     (KP_DelPTWF) ; ������"G_PTWF"���폜����
;     (SKB_MakeWkTopBaloonPoint)
;   )
; )

  ; ���[�N�g�b�v�}�`�̂v�s�i�ԏ����������A���[�N�g�b�v���̂��擾
  ; WT�f��.DB��茻�݂̑f��ID�̏o�͖��̃R�[�h�E�d�l���̃R�[�h���擾
  ; ���[�N�g�b�v�i�Ԗ��́E�}�`�n���h���E�o�͖��̃R�[�h�E�d�l���̃R�[�h�̈ꗗ�\�쐬
  ; ���[�N�g�b�v���Q��ވȏ゠��ꍇ�ɂ͊g���f�[�^����WT�^�C�v�̔ԍ��ɕ��בւ�
  ; �\�[�g�L�[�͂O�A���͔z�u�p�i�Ԗ��͕̂i�Ԗ��̂Ɠ������e�A���͂P���i�[
  ;#wtlst$$
  ;��:((0 "HQSI255H-ALQ-L" "2550" "40" "650" "���ڽSLį�� I �^ D650 H     �@�k" 1 126000.0 "A10" ("4C27")))
  (setq #wtlst$$ (ConfPartsAll_GetWKTopList))

  ; �z�u�ςݕ��ނ̍H��L���ESERIES�L���E�i�Ԗ��́E�k�^�q�敪���i�Ԑ}�`.DB������
  ; �i�Ԗ��́E���͔z�u�p�i�Ԗ��́E�}�`�n���h���̈ꗗ�\���쐬
  ; �������A���͔z�u�p�i�Ԗ��̂�����̏ꍇ�͂P�s�ɂ܂Ƃ߂Č��{�P
  ;#bzlst$$
  ;�� ("H$030WFB-7%#-@@[J:BW]" "L" "A" ("4937") 1 "0")
  (setq #bzlst$$ (ConfPartsAll_GetBuzaiList))

  (if #bzlst$$
    (progn
      ; �ꗗ�\�̕i�Ԗ��̂ƍH��L���ESERIES�L�����L�[�ɂ��ĕi�Ԋ�{.DB������
      ; �\�[�g�L�[�E�o�͖��̃R�[�h�E�d�l���̃R�[�h���擾���Ĉꗗ�\�ɒǉ�
      (setq #dtlst$$ (ConfPartsAll_GetDetailList #bzlst$$))

      ; �ꗗ�\�쐬��A�W��ID����у\�[�g�L�[�ŏ����ɕ��ёւ�
      ; �ꗗ�\�쐬��A��1key=�W��ID(nth 10),��2key=�i�Ԋ�{.��ķ�(nth 0)�ŏ����ɕ��ёւ�
      ;#dtlst$$
      ;��:(1011 "H$090S2A-JN#-@@[J:BW]" ("426D") "Z" 0 0 1 0 "xxxxxxx" "0" "A20" "A")
      (if #dtlst$$
        (setq #dtlst$$ (ListSortLevel2 #dtlst$$ 10 0))
      )
    )
  )

  ; ���[�N�g�b�v�ꗗ�ɕ��ވꗗ��ǉ�
  (setq #all-lst$$ (append #wtlst$$ #dtlst$$))

  ; �t�B���[�֘A�̎d�l����ǉ�
  (if (/= nil (setq #filer$ (ConfPartsAll_GetFillerInfo)))
    (setq #all-lst$$ (append #all-lst$$ #filer$))
  )
  ;#filer$
  ;��: ((2046 "HSCM240R-@@" ("4E76") "Z" 0 0 1 0 "xxxxxxx" "2" "A60" "A"))

  ; �ǉ����ނ̎d�l����ǉ�
  (if (/= nil (setq #hosoku$ (ConfPartsAll_GetHosokuInfo)))
    (setq #all-lst$$ (append #all-lst$$ #hosoku$))
  )

  ; �I�v�V�����A�C�e���̎d�l����ǉ�
  (if (/= nil (setq #option$ (ConfPartsAll_GetOptionInfo)))
    (setq #all-lst$$ (append #all-lst$$ #option$))
  )
  (setq #all-lst$$ (##HINBAN_MATOME #all-lst$$))

  ; �ꗗ�\�쐬��A�W��ID����у\�[�g�L�[�ŏ����ɕ��т�
  (if #all-lst$$
    ; �ꗗ�\�쐬��A��1key=�W��ID(nth 10),��2key=�i�Ԋ�{.��ķ�(nth 0)�ŏ����ɕ��ёւ�
    (setq #all-lst$$ (ListSortLevel2 #all-lst$$ 10 0))
  )

  ; ���ʎw��Ή�  �����W��ID(nth 10),��ķ�(nth 0)�̏ꍇ,�i�Ԗ���(nth 1)�ſ�Ă���
  (if #all-lst$$
    (setq #all-lst$$ (LisSortHin #all-lst$$ 10 0 1))
  )

  (setq #SpecInfo$$ nil)
  (setq #no 1)

  ; �d�l�\��񃊃X�g���O���[�o���ɐݒ�
  (foreach #lst$ #all-lst$$
    (setq #SpecInfo$$ (append #SpecInfo$$ (list (cons #no #lst$))))
    (setq #no (1+ #no))
  )

  ; �z�u���ގd�l���
  #SpecInfo$$

) ;ConfPartsAll_GetSpecInfo

;;;<HOM>************************************************************************
;;; <�֐���>  : ConfPartsAll_GetWKTopList
;;; <�����T�v>: ���[�N�g�b�v�̎d�l�ڍ׏����擾����
;;; <�߂�l>  :
;;;               ; 1.�\�[�g�L�[
;;;               ; 2.�ŏI�i��
;;;               ; 3.��
;;;               ; 4.����
;;;               ; 5.���s
;;;               ; 6.�i��
;;;               ; 7.��
;;;               ; 8.���z
;;;               ; 9.�W��ID  �V��,������͂��߂���"A10"
;;;               ;10.�}�`�n���h��
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetWKTopList (
  /
  #ss #i #WT$ #en #xd$ #MAG$ #MAG
  #LAST_HIN #KAKAKU #HINMEI #WWW #HHH #DDD #hnd #lst$$
#TOKU_CD	;-- 2011/12/12 A.Satoh Add
  )

  (setq CG_FuncName "\nConfPartsAll_GetWKTopList")

  ; ���[�N�g�b�v����������
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (/= #ss nil)
    (progn
      ; �Ԍ��Ń\�[�g����
      (setq #i 0 #WT$ nil)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_WRKT"))
        (setq #MAG$ (nth 55 #xd$))
        (setq #MAG  (car #MAG$))
        (setq #WT$ (append #WT$ (list (list #MAG #en))))
        (setq #i (1+ #i))
      )
      (setq #WT$ (CFListSort #WT$ 0))
      (setq #WT$ (reverse #WT$))

      (setq #i 0)
      (repeat (length #WT$)
        (setq #en (cadr (nth #i #WT$)))
        ; �g���f�[�^���擾
        (setq #xd$ (CFGetXData #en "G_WTSET"))
        (if (= #xd$ nil)
          (progn
            (CFAlertMsg "���[�N�g�b�v�̕i�Ԃ��m�肵�Ă��܂���B\n�������I�����܂��B");2011/09/22 YM MOD
            (exit)
          )
        )
        (setq #LAST_HIN (nth 1 #xd$));�ŏI�i��
        (setq #KAKAKU   (nth 3 #xd$));���z
        (setq #HINMEI   (nth 4 #xd$));�i��
        (setq #WWW      (nth 5 #xd$));��
        (setq #HHH      (nth 6 #xd$));����
        (setq #DDD      (nth 7 #xd$));���s
;-- 2011/10/18 A.Satoh Add - S
				(setq #TOKU_CD  (nth 8 #xd$));�����R�[�h
;-- 2011/10/18 A.Satoh Add - E

        ; ���[�N�g�b�v�n���h��
        (setq #hnd (cdr (assoc 5 (entget #en))))
        ; ���[�N�g�b�v�̏�񃊃X�g���i�[
        (setq #lst$$
          (cons
            (list
              #i              ; 1.�\�[�g�L�[
              #LAST_HIN       ; 2.�ŏI�i��
              #WWW            ; 3.��
              #HHH            ; 4.����
              #DDD            ; 5.���s
              #HINMEI         ; 6.�i��
              1               ; 7.��
              #KAKAKU         ; 8.���z
              "A10"           ; 9.�W��ID  �V��,������͂��߂���"A10"
              (list #hnd)     ;10.�}�`�n���h��
              ""
              "A"
;-- 2011/10/18 A.Satoh Add - S
							#TOKU_CD				;13.�����R�[�h
;-- 2011/10/18 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
							(if (= (nth 0 #xd$) 0)
								1
								0
							)
;-- 2011/11/24 A.Satoh Add - E
            )
            #lst$$
          )
        )
        (setq #i (1+ #i))
      )
    )
  )

  #lst$$

) ;ConfPartsAll_GetWKTopList

;;;<HOM>************************************************************************
;;;<�֐���>   : ConfPartsAll_GetSpecList
;;; <�����T�v>: �d�l�\�����擾����
;;; <�߂�l>  : Table.cfg�ɏo�͂���ؽ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetSpecList (
  &SpecInfo$$ ; (LIST)�d�l�\���
  /
  #SpecList$$ #SpecList$ #i #info$ #SORT_KEY #LAST_HIN #WWW #HHH #DDD #HINMEI
  #KOSU #KAKAKU #SYUYAKU_ID #HANDLE #LR #sHinban #drHinban #DoorInfo$ #KOSU
  #Tenkai_ID #Last_Rec$ #bunrui
#Toku_CD #Toku_FLG	;-- 2011/11/24 A.Satoh Add
#xd_TOKU$	;-- 2011/12/09 A.Satoh Add
  )

  (setq #SpecList$$ nil)
  (setq #i 1)

  (foreach #info$ &SpecInfo$$
    (if (< (nth 1 #info$) 10);�\�[�g�L�[��10�ȉ��Ȃ�V�Ƃ݂Ȃ�
      ; ���[�N�g�b�v�̏ꍇ
      (progn
        (setq #SORT_KEY   (nth 1 #info$))
        (setq #LAST_HIN   (nth 2 #info$))
        (setq #WWW        (nth 3 #info$))
        (setq #HHH        (nth 4 #info$))
        (setq #DDD        (nth 5 #info$))
        (setq #HINMEI     (nth 6 #info$))
        (setq #KOSU       (nth 7 #info$))
        (setq #KAKAKU     (nth 8 #info$))
        (setq #SYUYAKU_ID (nth 9 #info$))
        (setq #HANDLE     (nth 10 #info$))
        (setq #sHinban    #LAST_HIN)
        (setq #LR         "")
        (setq #drHinban   #sHinban)
        (setq #bunrui     (nth 12 #info$))
;-- 2011/10/12 A.Satoh Add - S
				(setq #Tenkai_ID -1)
;-- 2011/10/12 A.Satoh Add - E
;-- 2011/10/18 A.Satoh Add - S
        (setq #Toku_CD    (nth 13 #info$))
;-- 2011/10/18 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
				(setq #Toku_FLG   (nth 14 #info$))
;-- 2011/11/24 A.Satoh Add - E
      )
      (progn
        (setq #SORT_KEY   (nth 1 #info$))
        (setq #sHinban    (nth 2 #info$));CAD�i��
        (setq #drHinban #sHinban);[]�t���i��

        ;�����ŕ��ނ��Ƃ̔���񂪂���Ύ擾����
        (setq #DoorInfo$ (KP_GetSeriStr #sHinban));���ڰ��,���F,�����ؽ�

        (setq #sHinban    (KP_DelDrSeriStr #sHinban))
        (if (= #DoorInfo$ nil)
          (setq #drHinban #sHinban)
        )

        (setq #HANDLE     (nth 3 #info$))
        (setq #LR         (nth 4 #info$))
        (setq #SYUYAKU_ID (nth 11 #info$))
        (setq #KOSU       (nth 7 #info$));???
        (setq #Tenkai_ID (GetTenkaiID #sHinban));������Ԃ�
        (setq #bunrui     (nth 12 #info$))

				;2017/10/30 YM MOD-S

;;;        (if (or (= #LR "L")(= #LR "R"))
;;;          (setq #drHinban (strcat #drHinban #LR))
;;;        )

				;L/R�L����"%"�L���Ŕ��f���� (%)�Ŗ��ׂQ�s�ɂȂ��Ă��܂��΍�
		    (if (vl-string-search "%" #drHinban)
		      (progn ;"%"����
	          (setq #drHinban (strcat #drHinban #LR))
					)
					(progn
						nil
					)
        );_if

				;2017/10/30 YM MOD-E


;-- 2011/12/09 A.Satoh Mod - S
;;;;;;-- �������悤�m��܂ł̎b�菈��
;;;;;;******************************************
;;;;;;-- 2011/10/18 A.Satoh Add - S
;;;;;        (setq #Toku_CD    "")
;;;;;;-- 2011/10/18 A.Satoh Add - E
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;				(setq #Toku_FLG   0)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;******************************************
        (setq #Toku_CD    (nth 13 #info$))
				(setq #Toku_FLG   (nth 14 #info$))
;-- 2011/12/09 A.Satoh Mod - E

        (cond
          ((= #Tenkai_ID 0)
            ;�i�ԍŏI������
            (if #DoorInfo$
              (progn ;�����(���ڰ��,���F,����)������ΐ�p����
                ;�i��,LR,���,���,˷�
                (setq #Last_Rec$ (GetLast_Rec_DoorInfo #sHinban #LR #DoorInfo$));�i�ԍŏI��ں��ނ�Ԃ�
              )
              (progn
                ;�i��,LR,���,���,˷�
                (setq #Last_Rec$ (GetLast_Rec #sHinban #LR 0));�i�ԍŏI��ں��ނ�Ԃ�
              )
            );_if
          )
          ((= #Tenkai_ID 1)
            ;�i��,LR
            (setq #Last_Rec$ (GetLast_Rec #sHinban #LR 1));�i�ԍŏI��ں��ނ�Ԃ�
          )
          ((= #Tenkai_ID 2)
            ;�i��,LR,�޽��
            (setq #Last_Rec$ (GetLast_Rec #sHinban #LR 2));�i�ԍŏI��ں��ނ�Ԃ�
          )
          ((= #Tenkai_ID nil)
            ;ERROR
            (setq #Last_Rec$ nil)
          )
        );_cond

        (if #Last_Rec$
          (progn
            (setq #LAST_HIN   (ai_strrtrim(nth 10 #Last_Rec$)))
            (setq #WWW        (nth 11 #Last_Rec$))
            (setq #HHH        (nth 12 #Last_Rec$))
            (setq #DDD        (nth 13 #Last_Rec$))
            (setq #HINMEI     (ai_strrtrim(nth 14 #Last_Rec$)))
            (setq #KAKAKU     (nth  8 #Last_Rec$))
          )
          (progn
;-- 2011/12/09 A.Satoh Add - S
						(if (= #Toku_FLG 1)
							(progn
								(setq #xd_TOKU$ (CFGetXData (handent (car #HANDLE)) "G_TOKU"))
								(if #xd_TOKU$
									(progn
				            (setq #LAST_HIN   (nth 0 #xd_TOKU$))
        				    (setq #WWW        (itoa (fix (nth 4 #xd_TOKU$))))
				            (setq #HHH        (itoa (fix (nth 5 #xd_TOKU$))))
        				    (setq #DDD        (itoa (fix (nth 6 #xd_TOKU$))))
				            (setq #HINMEI     (nth 2 #xd_TOKU$))
        				    (setq #KAKAKU     (nth 1 #xd_TOKU$))
									)
									(progn
				            (setq #LAST_HIN   "")
        				    (setq #WWW        "")
				            (setq #HHH        "")
        				    (setq #DDD        "")
				            (setq #HINMEI     "")
        				    (setq #KAKAKU     "")
									)
								)
							)
							(progn
;-- 2011/12/09 A.Satoh Add - E
            (setq #LAST_HIN   "")
            (setq #WWW        "")
            (setq #HHH        "")
            (setq #DDD        "")
            (setq #HINMEI     "")
            (setq #KAKAKU     "")
;-- 2011/12/09 A.Satoh Add - S
							)
						)
;-- 2011/12/09 A.Satoh Add - E
          )
        )
      )
    )

		;2016/11/11 YM ADD-S [�i�ԍŏI]nil���
	  (if (= nil #WWW)(setq #WWW "0"))           ;��
	  (if (= nil #HHH)(setq #HHH "0"))           ;����
	  (if (= nil #DDD)(setq #DDD "0"))           ;���s
	  (if (= nil #HINMEI)(setq #HINMEI " "))     ;�i��
	  (if (= nil #KAKAKU)(setq #KAKAKU 0.0))     ;���i
	  (if (= nil #LAST_HIN)(setq #LAST_HIN " ")) ;�ŏI�i��
		;2016/11/11 YM ADD-E

    ; �d�l�\��񃊃X�g���쐬����
    (setq #SpecList$
      (list
        (itoa #i)   ;���הԍ�
        #LAST_HIN   ;�ŏI�i��
        #WWW        ;��
        #HHH        ;����
        #DDD        ;���s
        #HINMEI     ;�i��
        #KOSU       ;��
        #KAKAKU     ;���i
;        #SYUYAKU_ID ;�W��ID
;        #sHinban    ;CAD�i��
;        #LR         ;LR�敪
;        #drHinban   ;[]�t���i��
        #bunrui     ;����
;-- 2011/10/12 A.Satoh Add - S
        #SYUYAKU_ID ;�W��ID
				#Tenkai_ID	; �W�J�^�C�v
        #sHinban    ;CAD�i��
        #LR         ;LR�敪
;-- 2011/10/12 A.Satoh Add - E
;-- 2011/10/18 A.Satoh Add - S
				#Toku_CD		;�����R�[�h
;-- 2011/10/18 A.Satoh Add - E
;-- 2011/11/24 A.Satoh Add - S
				#Toku_FLG		;�����t���O
;-- 2011/11/24 A.Satoh Add - E
      )
    )

    (setq #SpecList$$ (append #SpecList$$ (list #SpecList$)))

    (setq #i (1+ #i))
  );(foreach

  #SpecList$$

) ; ConfPartsAll_GetSpecList


    ;/////////////////////////////////////////////////////////////////////////////
    ; �����i�ԂȂ���𑝂₷ �i�Ԃ�%���܂ނ��ǂ�����L/R���f
    ;/////////////////////////////////////////////////////////////////////////////
    (defun ##HINBAN_MATOME2 (
      &lis$
      /
      #hinLR$ #e #hin #LR #bunrui #hinLR$ #hinLR #loop #kosu #ii #f #fnew #ret$
			#F_LR #TOKU_F #KO #newLR ;2018/01/09 YM ADD
      )

;;;(if (vl-string-search "%" #kihon_hin)

      (setq #hinLR$ nil)
      (foreach #e &lis$
        (setq #hin    (nth 0 #e))
        (if (vl-string-search "%" (KP_DelHinbanKakko #hin));()�O����"%"�L������
					(setq #LR 1) ;L/R���� ���i�d�l���LR�����邩�ǂ���
					;else
					(setq #LR 0)
				);_if
        (setq #bunrui (nth 2 #e))
        (setq #ko (nth 4 #e))
        (setq #hinLR  (list #hin #LR #bunrui))
				(setq #toku_f (nth 7 #e))
        (if (and (member #hinLR #hinLR$) (= #LR 0) (= #toku_f 0))
          (progn
            (setq #loop T #ii 0)
            (setq #kosu (length #ret$))
						(setq #fnew nil)
            (while (and #loop (< #ii #kosu))
              (setq #f (nth #ii #ret$))

			        (if (vl-string-search "%" (KP_DelHinbanKakko (nth 0 #f)));()�O����"%"�L������
								(setq #f_LR 1);L/R����
								;else
								(setq #f_LR 0)
							);_if

              (if (and (= (nth 0 #f) #hin) (= #f_LR #LR) (= #f_LR 0) (= (nth 2 #f) #bunrui))
                (progn
									;2018/01/09 YM ADD-S
									(setq #newLR (nth 1 #f))
									(if (= #f_LR 0)(setq #newLR "Z"))
									;2018/01/09 YM ADD-E

                  (setq #loop nil)
                  (setq #fnew
                    (CFModList #f
                      (list
                        (list 1 #newLR) ; 2018/01/09 YM ADD
                        (list 3 (append (nth 3 #f) (nth 3 #e))) ; �}�`����ْǉ�
                        (list 4 (+ #ko (nth 4 #f)))             ; �����Z
                      )
                    )
                  )
                )
              );_if
              (setq #ii (1+ #ii))
            );while
						(if #fnew
            	(setq #ret$ (subst #fnew #f #ret$)) ; �v�f���ւ�
						);_if
          )
          (progn
            (setq #hinLR$ (append #hinLR$ (list #hinLR))) ; (�i��,LR,����)ؽ�
            (setq #ret$ (append #ret$ (list #e)))
          )
        )
      )

      #ret$

    ) ;##HINBAN_MATOME2


;;;<HOM>************************************************************************
;;; <�֐���>  : ConfPartsAll_GetBuzaiList
;;; <�����T�v>: �i�Ԗ��́E���͔z�u�p�i�Ԗ��́E�}�`�n���h���̈ꗗ�\�쐬
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                 1.�H��L��
;;;                 2.SERIES�L��
;;;                 3.�i�Ԗ���
;;;                 4.���͔z�u�p�i�Ԗ���
;;;                 5.�}�`�n���h��
;;;                 6.��
;;;                 7.���ގ�ރt���O (0:�W������ 1:����WT 2:�V��t�B���[ 3:�⑫���� +100:����)
;;;                 8.���@(��)
;;;                 9.�|��or��悹�z(��)
;;;               )
;;;             )
;;;             ��8,9�͓����L���r�l�b�g�̏ꍇ�̂ݕt��
;;; <���l>    :
;;;             1)�z�u�ςݕ��ނ̍H��L���ESERIES�L���E�i�Ԗ��́E�k�^�q�敪���
;;;               �i�Ԑ}�`.DB����������B
;;;             2)���͔z�u�p�i�Ԗ��̂�����̏ꍇ�͂P�s�ɂ܂Ƃ߂Č����P��������B
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetBuzaiList (
  /
  #ss #i #sym #xd$ #name #lrcd #DRColCode #bunrui #hnd #lst$
  #lst$$ #lst5$$ #num #sort-lst$$
#xd_TOKU$ #toku_cd #toku_flg	;--2011/12/09 A.Satoh Add
  )

    ;/////////////////////////////////////////////////////////////////////////////
    ; �����i�ԂȂ���𑝂₷
    ;/////////////////////////////////////////////////////////////////////////////
    (defun ##HINBAN_MATOME1 (
      &lis$
      /
      #hinLR$ #e #hin #LR #bunrui #hinLR$ #hinLR #loop #kosu #ii #f #fnew #ret$
      )

      (setq #hinLR$ nil)
      (foreach #e &lis$
        (setq #hin    (nth 0 #e))
        (setq #LR     (nth 1 #e))
        (setq #bunrui (nth 2 #e))
        (setq #hinLR  (list #hin #LR #bunrui))
;-- 2011/12/09 A.Satoh Add - S
				(setq #toku_f (nth 7 #e))
;-- 2011/12/09 A.Satoh Add - E
;-- 2011/12/09 A.Satoh Mod - S
;;;;;        (if (member #hinLR #hinLR$)
        (if (and (member #hinLR #hinLR$) (= #toku_f 0))
;-- 2011/12/09 A.Satoh Mod - E
          (progn
            (setq #loop T #ii 0)
            (setq #kosu (length #ret$))
            (while (and #loop (< #ii #kosu))
              (setq #f (nth #ii #ret$))
              (if (and (= (nth 0 #f) #hin)(= (nth 1 #f) #LR) (= (nth 2 #f) #bunrui))
                (progn
                  (setq #loop nil)
                  (setq #fnew
                    (CFModList #f
                      (list
                        (list 3 (append (nth 3 #f) (nth 3 #e))) ; �}�`����ْǉ�
                        (list 4 (1+ (nth 4 #f)))                ; ��+1
                      )
                    )
                  )
                )
              )
              (setq #ii (1+ #ii))
            )
            (setq #ret$ (subst #fnew #f #ret$)) ; �v�f���ւ�
          )
          (progn
            (setq #hinLR$ (append #hinLR$ (list #hinLR))) ; (�i��,LR,����)ؽ�
            (setq #ret$ (append #ret$ (list #e)))
          )
        )
      )

      #ret$

    ) ;##HINBAN_MATOME1
    ;/////////////////////////////////////////////////////////////////////////////


;;;    ;/////////////////////////////////////////////////////////////////////////////
;;;    ; �����i�ԂȂ���𑝂₷ �i�Ԃ�%���܂ނ��ǂ�����L/R���f
;;;    ;/////////////////////////////////////////////////////////////////////////////
;;;    (defun ##HINBAN_MATOME2 (
;;;      &lis$
;;;      /
;;;      #hinLR$ #e #hin #LR #bunrui #hinLR$ #hinLR #loop #kosu #ii #f #fnew #ret$
;;;			#F_LR #TOKU_F #KO
;;;      )
;;;
;;;;;;(if (vl-string-search "%" #kihon_hin)
;;;
;;;      (setq #hinLR$ nil)
;;;      (foreach #e &lis$
;;;        (setq #hin    (nth 0 #e))
;;;        (if (vl-string-search "%" (KP_DelHinbanKakko #hin));()�O����"%"�L������
;;;					(setq #LR 1);L/R����
;;;					;else
;;;					(setq #LR 0)
;;;				);_if
;;;        (setq #bunrui (nth 2 #e))
;;;        (setq #ko (nth 4 #e))
;;;        (setq #hinLR  (list #hin #LR #bunrui))
;;;				(setq #toku_f (nth 7 #e))
;;;        (if (and (member #hinLR #hinLR$) (= #LR 0) (= #toku_f 0))
;;;          (progn
;;;            (setq #loop T #ii 0)
;;;            (setq #kosu (length #ret$))
;;;						(setq #fnew nil)
;;;            (while (and #loop (< #ii #kosu))
;;;              (setq #f (nth #ii #ret$))
;;;
;;;			        (if (vl-string-search "%" (KP_DelHinbanKakko (nth 0 #f)));()�O����"%"�L������
;;;								(setq #f_LR 1);L/R����
;;;								;else
;;;								(setq #f_LR 0)
;;;							);_if
;;;
;;;              (if (and (= (nth 0 #f) #hin) (= #f_LR #LR) (= #f_LR 0) (= (nth 2 #f) #bunrui))
;;;                (progn
;;;                  (setq #loop nil)
;;;                  (setq #fnew
;;;                    (CFModList #f
;;;                      (list
;;;                        (list 3 (append (nth 3 #f) (nth 3 #e))) ; �}�`����ْǉ�
;;;                        (list 4 (+ #ko (nth 4 #f)))             ; �����Z
;;;                      )
;;;                    )
;;;                  )
;;;                )
;;;              );_if
;;;              (setq #ii (1+ #ii))
;;;            );while
;;;						(if #fnew
;;;            	(setq #ret$ (subst #fnew #f #ret$)) ; �v�f���ւ�
;;;						);_if
;;;          )
;;;          (progn
;;;            (setq #hinLR$ (append #hinLR$ (list #hinLR))) ; (�i��,LR,����)ؽ�
;;;            (setq #ret$ (append #ret$ (list #e)))
;;;          )
;;;        )
;;;      )
;;;
;;;      #ret$
;;;
;;;    ) ;##HINBAN_MATOME2
    ;/////////////////////////////////////////////////////////////////////////////

  (setq CG_FuncName "\nConfPartsAll_GetBuzaiList")

  ; G_LSYM�����ݔ����ނ�����
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        (if (CfGetXData #sym "G_KUTAI") ; ��͖̂���
          nil
          (progn
            (setq #xd$ (CFGetXData #sym "G_LSYM"))
;-- 2011/12/09 A.Satoh Add - S
						(setq #xd_TOKU$ (CFGetXData #sym "G_TOKU"))
;-- 2011/12/09 A.Satoh Add - E
;-- 2011/12/09 A.Satoh Mod - S
;;;;;            (setq #name      (nth  5 #xd$)) ; �i�Ԗ���
						(if #xd_TOKU$
	            (setq #name      (nth  0 #xd_TOKU$)) ; �i�Ԗ���
  	          (setq #name      (nth  5 #xd$)) ; �i�Ԗ���
						)
;-- 2011/12/09 A.Satoh Mod - E
            (setq #lrcd      (nth  6 #xd$)) ; �k�q�敪
            (setq #DRColCode (nth  7 #xd$)) ; "��ذ��,��װ�L��"
            (setq #bunrui    (nth 15 #xd$)) ; ����(A:�L�b�`�� D:���[)
;-- 2011/12/09 A.Satoh Add - S
						(if #xd_TOKU$
							(progn
								(setq #toku_cd (nth 3 #xd_TOKU$))
								(setq #toku_flg 1)
							)
							(progn
								(setq #toku_cd "")
								(setq #toku_flg 0)
							)
						)
;-- 2011/12/09 A.Satoh Add - E

            (if (and #DRColCode (vl-string-search "," #DRColCode))
              (progn
                (setq #DRColCode (CMN_string-subst "," ":" #DRColCode))
                (setq #name (strcat #name "[" #DRColCode "]"))
              )
            )

            ; �}�`�n���h��
            (setq #hnd (cdr (assoc 5 (entget #sym))))

						;2018/01/29 YM ADD-S �y�d�v�z�i�Ԃ̊��ʂ������ŊO���Ă��܂��B���ʊO���Ă��i�Ԋ�{�̃f�[�^�������O��
						(setq #name (KP_DelHinbanKakko #name))

            (setq #lst$
              (list
                #name       ; �i�Ԗ���
                #lrcd       ; LR�敪
                #bunrui     ; ����
                (list #hnd) ; �}�`�n���h��
;-- 2011/12/09 A.Satoh Add - S
								1
								"0"
								#toku_cd		; �����R�[�h
								#toku_flg		; �����t���O
								(nth  5 #xd$)	; �i�Ԗ��́i���������p)
;-- 2011/12/09 A.Satoh Add - E
              )
            )
            (setq #lst$$ (append #lst$$ (list #lst$)))
          )
        )
        (setq #i (1+ #i))
      )

      ; �i�Ԗ��̂Ń\�[�g���ē��ꕔ�ނ̌����擾����
      (setq #lst$$ (CFListSort #lst$$ 0))

      ; �K�i�i�݂̂̑O��
      (setq #lst5$$ nil)
;-- 2011/12/09 A.Satoh Del - S
;;;;;      (setq #num 1)
;-- 2011/12/09 A.Satoh Del - E
      (foreach #lst$ #lst$$
;-- 2011/12/09 A.Satoh Del - S
;;;;;        (setq #lst$ (append #lst$ (list #num "0")))
;-- 2011/12/09 A.Satoh Del - E
        (setq #lst5$$ (append #lst5$$ (list #lst$)))
      )

      ; �W���i����(���걲�ь����Z)
      (setq #sort-lst$$ (##HINBAN_MATOME1 #lst5$$))

			;2017/10/30 YM ADD-S
			;2018/10/15 YM MOD-S
;;;			(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
	      (setq #sort-lst$$ (##HINBAN_MATOME2 #sort-lst$$))
;;;			);_if
			;2018/10/15 YM MOD-E
			;2017/10/30 YM ADD-E

    )
    (princ "�}�ʏ�ɕ��ނ�����܂���B")
  )

  #sort-lst$$

) ;ConfPartsAll_GetBuzaiList

;;;<HOM>************************************************************************
;;; <�֐���>  : ConfPartsAll_GetDetailList
;;; <�����T�v>: �ݔ����ނ̏ڍ׏����擾����
;;; <�߂�l>  : (list
;;;                (list
;;;                   1.�\�[�g�L�[
;;;                   2.�i�Ԗ���
;;;                   3.�}�`�n���h��
;;;                   4.���͔z�u�p�i�Ԗ���
;;;                   5.�o�͖��̃R�[�h
;;;                   6.�d�l���̃R�[�h
;;;                   7.��
;;;                   8.���z
;;;                   9.�i�R�[�h
;;;                  10.���ގ�ރt���O
;;;                  11.�W��ID
;;;                  12.����
;;;                )
;;;                ...
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetDetailList (
  &lst$$  ;(LIST)
          ;  (list
          ;    (list
          ;      1.�i�Ԗ���
          ;      2.LR�敪
          ;      3.����
          ;      4.�}�`�n���h�����X�g
          ;      5.��
          ;      6.���ގ�ރt���O
					;      7.�����R�[�h
					;      8.�����t���O
					;      9.���X�̕i�Ԗ���
          ;    )
          ;  )
          ;�@�� (("H$030WFB-7%#-@@[J:BW]" "L" "A" ("4937") 1 "0") (�E�E�E)�E�E�E)
  /
  #BaseHinban$ #BaseHinban #i #lst$ #hinban #qry$
  #dupflag #dlstent$ #dlst$$ #dlst$ #newent$ 
  #sym #Errmsg #qry2$ #syuyaku
  )

  (setq CG_FuncName "\nConfPartsAll_GetDetailList")

  (setq #BaseHinban$ nil) ; �i�Ԋ�{�����Ɏ��s�����i��
  (setq #i 0)
  (foreach #lst$ &lst$$
    (setq #hinban (nth 0 #lst$))
    (WebOutLog (strcat (itoa #i) "-" #hinban))
    ; []��������菜��
    (setq #hinban (KP_DelDrSeriStr #hinban))
;-- 2011/12/09 A.Satoh Add - S
		; �����i�Ԃł���ꍇ
		(if (= (nth 7 #lst$) 1)
			(setq #hinban (nth 8 #lst$))
		)
;-- 2011/12/09 A.Satoh Add - S

    ; �w�i�Ԋ�{�x���擾����
    (setq #qry$
      (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hinban
      (list (list "�i�Ԗ���" #hinban 'STR))))
    )

    ; �i�Ԋ�{.�ώZF=1�͏��O���鏈����ǉ� ��OK
    (if (and (/= nil #qry$)(not (equal 1.0 (nth 6 #qry$) 0.1)))
      (progn
        ;�d���i�Ԃ͐��ʂ����Z����
        (setq #dupflag nil) ; �d���׸�OFF
        ;�쐬�ς݈ꗗ��ٰ��
        (foreach #dlstent$ #dlst$$
          (if (and #dlstent$
                   (= (nth 3 #dlstent$) (nth 1 #lst$)) ;"L" or "R"���r�B
                   (= (nth 1 #dlstent$)(KP_DelHinbanKakko (nth 0 #lst$))) ; �i�Ԗ��̂��r
;-- 2011/08/11 A.Satoh Add - S
                   (= (nth 11 #dlstent$) (nth 5 #lst$)) ; ���� "A" or "D" ���r
;-- 2011/08/11 A.Satoh Add - E
                   )
            (progn
              (setq #newent$   ; �V����ؽĂ���蒼��
                (list
                  (nth  0 #dlstent$)                       ;  1.�\�[�g�L�[
                  (nth  1 #dlstent$)                       ;  2.�i�Ԗ���
                  (append (nth 2 #dlstent$) (nth 3 #lst$)) ;  3.���̐}�`����قɐ}�`����ق�ǉ�����
                  (nth  3 #dlstent$)                       ;  4.���͔z�u�p�i�Ԗ���
                  (nth  4 #dlstent$)                       ;  5.�o�͖��̺���
                  (nth  5 #dlstent$)                       ;  6.�d�l���̺���
                  (+ (nth 6 #dlstent$) (nth 4 #lst$))      ;  7.���̌��Ɍ��݂̌������Z����
                  (nth  7 #dlstent$)                       ;  8.���z(���ς��菈���Ŏ擾)
                  (nth  8 #dlstent$)                       ;  9.�i����
                  (nth  9 #dlstent$)                       ; 10.���ގ���׸�
                  (nth 10 #dlstent$)                       ; 11.�W��ID
                  (nth  2 #lst$)                           ; 12.����
                )
              )
              (setq #dlst$$ (subst #newent$ #dlstent$ #dlst$$));�V���v�f������
              (setq #dupflag T)                    ;�d���׸�ON
            )
          )
        )

        (if (not #dupflag)
          (progn
            (if (and (= (nth 2 #lst$) "D") (= (substr (nth 5 #qry$) 1 1) "A"))
              (progn
                (setq #qry2$
                  (car (CFGetDBSQLHinbanTable "�W��ID�ϊ�" #hinban
                  (list (list "�i�Ԗ���" #hinban 'STR))))
                )

                (if (/= #qry2$ nil)
                  (setq #syuyaku (nth 1 #qry2$))
                  (setq #syuyaku (nth 5 #qry$))
                )
              )
              (setq #syuyaku (nth 5 #qry$))
            )

            (setq #dlst$
              (list
                (fix (nth 2 #qry$))               ;  1.�\�[�g�L�[
                (KP_DelHinbanKakko (nth 0 #lst$)) ;  2.�i�Ԗ���
                (nth 3 #lst$)                     ;  3.�}�`�n���h��
                (nth 1 #lst$)                     ;  4.L/R
                0                                 ;  5.�o�͖��̃R�[�h
                0                                 ;  6.�d�l���̃R�[�h
                (nth 4 #lst$)                     ;  7.��
                0                                 ;  8.���z(���ς菈���Ŏ擾)
                "xxxxxxx"                         ;  9.�i�R�[�h
                (nth 5 #lst$)                     ; 10.���ގ�ރt���O
                ;(nth 5 #qry$)                     ; 11.�W��ID
                #syuyaku                          ; 11.�W��ID
                (nth 2 #lst$)                     ; 12.����
;-- 2011/12/09 A.Satoh Add - S
								(nth 6 #lst$)											; 13.�����R�[�h
								(nth 7 #lst$)											; 14.�����t���O
;-- 2011/12/09 A.Satoh Add - E
              )
            )
            (setq #dlst$$ (append #dlst$$ (list #dlst$)))
          )
        )
      )
      ;else �i�Ԋ�{�ɂȂ������� or �����Ă��ώZF=1 �̏ꍇ
      (progn
        ;�ݸ���ǂ������肷��
        (setq #sym (handent (car (nth 3 #lst$))))
        (if (or (and #sym (equal CG_SKK_INT_SNK (nth 9 (CFGetXData #sym "G_LSYM")) 0.1)) ; ���i����=410(�ݸ)�̏ꍇ
                (and (/= nil #qry$)(equal 1.0 (nth 6 #qry$) 0.1))) ; �i�Ԋ�{�ɂ��邪�A�ώZF=1�̏ꍇ ��OK
          nil ; ���X[�i�Ԋ�{]�ɓo�^����Ă��Ȃ��̂ŗ�O�I�ɏ��O���� �ώZF=1�͑Ώۂɂ��Ȃ�
          ; else
          (progn
            (setq #BaseHinban$ (append #BaseHinban$ (list #hinban)))
          )
        );_if
      )
    );_if
    (setq #i (1+ #i))
  );_foreach

  (if #BaseHinban$
    (progn
      (setq #Errmsg "\n")
      (foreach #BaseHinban #BaseHinban$
        (setq #Errmsg (strcat #Errmsg #BaseHinban "\n"))
      )
      (CFYesDialog (strcat "\n�ȉ��̕i�Ԃ��ް��ް��ɂ���܂���ł����B"
                           "\n���z�u���ފm�F��ʂɕ\������܂���̂ł����ӂ��������B"
                           "\n  "
                           "\n��������"
                           "\n���i���p�łɂȂ������A�ް��ް����ް�ޮ݂��Â���"
                           "\n�������ް��ް��Ɍ�肪���邱�Ƃ��l�����܂��B"
                           "\n  "
                           #Errmsg))
    )
  );_if

  #dlst$$

) ;ConfPartsAll_GetDetailList

;;;<HOM>************************************************************************
;;; <�֐���>  : ConfPartsAll_GetFillerInfo
;;; <�����T�v>: �V�䏈���֘A�A�C�e���̎d�l�ڍ׏����擾����
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                  1.�\�[�g�L�[
;;;                  2.�i�Ԗ���
;;;                  3.�}�`�n���h���Q
;;;                  4.���͔z�u�p�i�Ԗ���
;;;                  5.�o�͖��̃R�[�h
;;;                  6.�d�l���̃R�[�h
;;;                  7.��
;;;                  8.���z
;;;                  9.�i�R�[�h
;;;                 10.�A�C�e�����(0:�W�� 1:����WT 2:�V��֘A 3:�⑫)
;;;                 11.�W��ID
;;;                 12.����
;;;               )
;;;               �c
;;;             )
;;; <���l>    : 11/08/04 A.Satoh �V�K�쐬

;;;************************************************************************>MOH<
(defun ConfPartsAll_GetFillerInfo (
  /
  #sKind #Flr$$ #Flr$ #iCnt #fLen #bunrui #out$$
  #xFlr #eName #sHnd #eed$ #sCode #iType #fLen
  #rec$ #iCnt1 #iCnt2 #fLen1 #fLen2 #fLen3
;-- 2011/08/12 A.Satoh Add - S
  #kosu #idx #upd_flg #wk_flr$ #wk_flr1$
;-- 2011/08/12 A.Satoh Add - E
  #FLRN$ #SHND$ #XDOPT$ ;2011/09/23 YM ADD
  )

  (setq #sKind  "2") ; �V��֘A(�Œ�)
  (setq #Flr$$  nil)
  (setq #iCnt   0)
  (setq #fLen   0.0)
  (setq #out$$  nil)
;-- 2011/08/11 A.Satoh Del - S
;  (setq #bunrui "A") ; �L�b�`��("A")�Œ�
;-- 2011/08/11 A.Satoh Del - E

  ; �V��֘A�̐}�`������
  (setq #xFlr (ssget "X" (list (list -3 (list "G_FILR")))))
  (if #xFlr
    (repeat (sslength #xFlr)
      (setq #eName (ssname #xFlr #iCnt))
      (setq #sHnd  (cdr (assoc 5 (entget #eName))))
      (setq #eed$  (CFGetXData #eName "G_FILR"))
      (setq #sCode (nth 0 #eed$))
      (setq #iType (nth 3 #eed$)) ; #iType
                                  ;  1:�V��̨װ 2:�x�� 3:���艏 4:��Џ��� 5:���� 6:�������ݶް���т̏��艏 7:�Ǐ����p��߰��
      (if (/= 7 #iType)
        (setq #fLen (CfGetLWPolyLineLen (nth 2 #eed$)))
        (setq #fLen (nth 4 #eed$))
      )
;-- 2011/08/11 A.Satoh Add - S
      ; ���ނ̎擾
      (if (= (length #eed$) 8)
        (setq #bunrui (nth 7 #eed$))
        (setq #bunrui "A") ; �L�b�`��("A")�Œ�
      )

      ; ���擾
      (setq #xdOPT$ (CFGetXData #eName "G_OPT"))
      (if #xdOPT$
        (setq #kosu (1+ (nth 2 #xdOPT$)))
        (setq #kosu 1)
      )
;-- 2011/08/11 A.Satoh Add - E

;-- 2011/08/12 A.Satoh Mod - S
      ; ����i�Ԃ��������͓���i�Ԃ͂��邪���ދ敪���قȂ�ꍇ�́A���X�g�ɐV�K�o�^
      ; ����i�Ԃ�����A���ދ敪�������ł���Ό������Z���čX�V
      (if (= #Flr$$ nil)
        (progn
          (setq #Flr$  (list #sCode #iType #fLen (list #sHnd) #kosu #bunrui))
          (setq #Flr$$ (cons #Flr$ #Flr$$))
        )
        (progn
          (setq #idx 0)
          (setq #upd_flg nil)
          (repeat (length #Flr$$)
            (if (= #upd_flg nil)
              (progn
                (setq #wk_flr1$ (nth #idx #Flr$$))
                (if (and (= #sCode (nth 0 #wk_flr1$)) (= #bunrui (nth 5 #wk_flr1$)))
                  (progn
                    (setq #wk_flr$ #wk_flr1$)
                    (setq #upd_flg T)
                  )
                )
              )
            )
            (setq #idx (1+ #idx))
          )

          (if (= #upd_flg T)
            (progn
              (setq #fLen  (+ #fLen    (nth 2 #wk_flr$)))
              (setq #sHnd$ (cons #sHnd (nth 3 #wk_flr$)))
              (setq #kosu  (+ #kosu    (nth 4 #wk_flr$)))
              (setq #FlrN$ (list #sCode #iType #fLen #sHnd$ #kosu #bunrui))
              (setq #Flr$$ (subst #FlrN$ #wk_flr$ #Flr$$))
            )
            (progn
              (setq #Flr$  (list #sCode #iType #fLen (list #sHnd) #kosu #bunrui))
              (setq #Flr$$ (cons #Flr$ #Flr$$))
            )
          )
        )
      )
;|
      ; ����i�Ԃ��Ȃ��ꍇ�A���X�g�ɐV�K�o�^
      ; ����i�Ԃ�����ꍇ�A�����Ɛ}�`�n���h�������Z���čX�V
      (setq #Flr$ (assoc #sCode #Flr$$))
      (if (= nil #Flr$)
        (progn
;-- 2011/08/11 A.Satoh Mod - S
;          (setq #Flr$  (list #sCode #iType #fLen (list #sHnd)))
          (setq #Flr$  (list #sCode #iType #fLen (list #sHnd) #kosu #bunrui))
;-- 2011/08/11 A.Satoh Mod - E
          (setq #Flr$$ (cons #Flr$ #Flr$$))
        )
        (progn
          (setq #fLen  (+ #fLen    (nth 2 #Flr$)))
          (setq #sHnd$ (cons #sHnd (nth 3 #Flr$)))
;-- 2011/08/11 A.Satoh Mod - S
;          (setq #FlrN$ (list #sCode #iType #fLen #sHnd$))
          (setq #FlrN$ (list #sCode #iType #fLen #sHnd$ #kosu #bunrui))
;-- 2011/08/11 A.Satoh Mod - E
          (setq #Flr$$ (subst #FlrN$ #Flr$ #Flr$$))
        )
      )
|;
;-- 2011/08/12 A.Satoh Mod - E

      (setq #iCnt (1+ #iCnt))
    )
  )

  ; �A�C�e�����ƂɌ��v�Z
  (foreach #Flr$ #Flr$$
    (setq #sCode (nth 0 #Flr$))
    (setq #iType (nth 1 #Flr$))
;-- 2011/08/12 A.Satoh Del - S
;    (setq #fLen  (nth 2 #Flr$))
;-- 2011/08/12 A.Satoh Del - E
    (setq #sHnd$ (nth 3 #Flr$))
;-- 2011/08/11 A.Satoh Add - S
    (setq #kosu  (nth 4 #Flr$))
    (setq #bunrui (nth 5 #Flr$))
;-- 2011/08/11 A.Satoh Add - S

    ;// �i�Ԋ�{�e�[�u������A�C�e���P�i�̒������擾
    (setq #rec$ (CFGetDBSQLHinbanTableChk "�i�Ԑ}�`" #sCode (list (list "�i�Ԗ���" #sCode 'STR))))
;-- 2011/08/12 A.Satoh Mod - S
    (if #rec$
;-- 2011/12/09 A.Satoh Mod - S
;;;;;      (setq #out$$ (cons (list #sCode (nth 1 #rec$) #bunrui #sHnd$ #kosu #sKind) #out$$))
      (setq #out$$ (cons (list #sCode (nth 1 #rec$) #bunrui #sHnd$ #kosu #sKind "" 0 "") #out$$))
;-- 2011/12/09 A.Satoh Mod - S
    )
;|
    (if #rec$
      (if (= 7 #iType)
        (setq #fLen1 (nth 5 #rec$)) ; �Ǐ����p�X�y�[�T�[
        (setq #fLen1 (nth 3 #rec$)) ; ���̑�
      )
    )

    ; �V��t�B���[�̌��ς薇���ݒ��ǉ�
    (if (< 0 CG_FillerNum)
      (setq #fLen (* #fLen1 CG_FillerNum))
    )

    ; �Q���Z�b�g������΁A�i�Ԋ�{�e�[�u������A�C�e���P�i�̒������擾
    (setq #fLen2  0.0)
    (setq #fLen3  0.0)
    (setq #iCnt1 0)
    (setq #iCnt2 0)

    (if (< 0.0 #fLen2)
      (while (< 0.0 #fLen)
        (cond
          ((>= #fLen1 #fLen)
            (setq #iCnt1 (+ 1 #iCnt1))
            (setq #fLen  0.0)
          )
          ((>= #fLen2 #fLen)
            (setq #iCnt2 (+ 1 #iCnt2))
            (setq #fLen  0.0)
          )
          ((>= #fLen3 #fLen)
            (setq #iCnt1 (+ 2 #iCnt1))
            (setq #fLen  0.0)
          )
          (T
            (setq #iCnt2 (+ 1     #iCnt2))
            (setq #fLen  (- #fLen #fLen2))
          )
        )
      )
      (while (< 0.0 #fLen)
        (cond
          ((>= #fLen1 #fLen)
            (setq #iCnt1 (+ 1 #iCnt1))
            (setq #fLen 0.0)
          )
          (T
            (setq #iCnt1 (+ 1     #iCnt1))
            (setq #fLen  (- #fLen #fLen1))
          )
        )
      )
    )

    (setq #out$$ (cons (list #sCode (nth 1 #rec$) #bunrui #sHnd$ #iCnt1 #sKind) #out$$))
|;
;-- 2011/08/12 A.Satoh Mod - E
  ) ;foreach

  ;ConfPartsAll_GetDetailList �ɓn���`���i#out$$)
  ;�� ("H$030WFB-7%#-@@[J:BW]" "L" "A" ("4937") 1 "0")

  ;// �V��t�B���[�̏ڍ׏����擾
  (if #out$$
    (reverse (ConfPartsAll_GetDetailList #out$$))
  )

) ;ConfPartsAll_GetFillerInfo

;;;<HOM>************************************************************************
;;; <�֐���>  : ConfPartsAll_GetHosokuInfo
;;; <�����T�v>: �⑫���ނ̎d�l�ڍ׏����擾
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                  1.�\�[�g�L�[
;;;                  2.�i�Ԗ���
;;;                  3.�}�`�n���h��
;;;                  4.���͔z�u�p�i�Ԗ���
;;;                  5.�o�͖��̃R�[�h
;;;                  6.�d�l���̃R�[�h
;;;                  7.��
;;;                  8.���z
;;;                  9.�i�R�[�h
;;;                 10.���ގ�ރt���O
;;;                    (0:�W������ 1:����WT 2:�V��t�B���[ 3:�⑫����)
;;;                 11.�W��ID
;;;                 12.����
;;;               )
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetHosokuInfo (
  /
  #lst$$ #lst$ #fname #spec$$ #spec$ #hinban #num #name #bunrui #fig$
#qry$ #syuyaku ;-- 2012/01/17 A.Satoh Add
  )

  (setq CG_FuncName "\nConfPartsAll_GetHosokuInfo")

  (setq #lst$$ nil)

  ; HOSOKU.cfg�̓Ǎ�
  (setq #fname (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
  (if (findfile #fname)
    (progn
      (setq #spec$$ (ReadCSVFile #fname))
      (if #spec$$
        (foreach #spec$ #spec$$
          (setq #hinban (nth 0 (StrParse (nth 0 #spec$) "=")))
          (setq #num (atoi (nth 1 (StrParse (nth 0 #spec$) "="))))
          (setq #name (nth 1 #spec$))
          (setq #bunrui (nth 2 #spec$))
          (if (> (strlen #bunrui) 1)
            (setq #bunrui (substr #bunrui 1 1))
          )

          ; �i�Ԋ�{�e�[�u�������߼�ݕi�����擾
          (setq #fig$ (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hinban (list (list "�i�Ԗ���" #hinban 'STR)))))
          (if (/= #fig$ nil)
            (progn
;-- 2012/01/17 A.Satoh Add - S
							(if (and (= (nth 2 #spec$) "D") (= (substr (nth 5 #fig$) 1 1) "A"))
								(progn
									(setq #qry$
										(car (CFGetDBSQLHinbanTable "�W��ID�ϊ�" #hinban
										(list (list "�i�Ԗ���" #hinban 'STR))))
									)

									(if (/= #qry$ nil)
										(setq #syuyaku (nth 1 #qry$))
										(setq #syuyaku (nth 5 #fig$))
									)
								)
								(setq #syuyaku (nth 5 #fig$))
							)
;-- 2012/01/17 A.Satoh Add - E

              (setq #lst$
                (list
                  (fix (nth 2 #fig$))  ;  1.�\�[�g�L�[
                  #hinban              ;  2.�i�Ԗ���
                  (list "")            ;  3.�}�`�n���h��
                  "Z"                  ;  4.L/R
                  0                    ;  5.�o�͖��̃R�[�h
                  0                    ;  6.�d�l���̃R�[�h
                  #num                 ;  7.��
                  0                    ;  8.���z(���ς菈���Ŏ擾)
                  "xxxxxxx"            ;  9.�i�R�[�h
                  "3"                  ; 10.���ގ�ރt���O
;-- 2012/01/17 A.Satoh Mod - S
;;;;;                  (nth 5 #fig$)        ; 11.�W��ID
									#syuyaku             ; 11.�W��ID
;-- 2012/01/17 A.Satoh Mod - E
                  #bunrui              ; 12.����
;-- 2011/12/09 A.Satoh Add - S
									""
									0
;-- 2011/12/09 A.Satoh Add - E
                )
              )
              (setq #lst$$ (append #lst$$ (list #lst$)))
            )
          )
        )
      )
    )
  )

;  ; �⑫���ނ̏ڍ׏����擾����
;  (if (/= #lst$$ nil)
;    (reverse (ConfPartsAll_GetDetailList #lst$$))
;    nil
;  )

);ConfPartsAll_GetHosokuInfo

;;;<HOM>************************************************************************
;;; <�֐���>  : ConfPartsAll_GetOptionInfo
;;; <�����T�v>: �I�v�V�������ނ̎d�l�ڍ׏����擾
;;; <�߂�l>  :
;;;             (list
;;;               (list
;;;                  1.�\�[�g�L�[
;;;                  2.�i�Ԗ���
;;;                  3.�}�`�n���h��
;;;                  4.���͔z�u�p�i�Ԗ���
;;;                  5.�o�͖��̃R�[�h
;;;                  6.�d�l���̃R�[�h
;;;                  7.��
;;;                  8.���z
;;;                  9.�i�R�[�h
;;;                 10.���ގ�ރt���O
;;;                    (0:�W������ 1:����WT 2:�V��t�B���[ 3:�⑫����)
;;;                 11.�W��ID
;;;                 12.����
;;;               )
;;;             )
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun ConfPartsAll_GetOptionInfo (
  /
  #ss #sslen #i #sym #xdLSYM$ #oya_hinban #LR_oya #hand #xd$ #xd2$
  #hin #num #fig$ #lst$$ #xdFILR$
#qry$ #syuyaku ;-- 2012/02/09 A.Satoh Add
  )

  (setq CG_FuncName "\nConfPartsAll_GetOptionInfo")

  ; G_OPT�����ݔ����ނ�����
  (setq #ss (ssget "X" '((-3 ("G_OPT")))))
  (if (= nil #ss)
    (setq #sslen 0)
    (setq #sslen (sslength #ss))
  )

  (setq #i 0)
  (repeat #sslen
    (setq #sym (ssname #ss #i))
    (setq #xdFILR$ (CFGetXData #sym "G_FILR"))
    (if (= #xdFILR$ nil)  ; 2�ȏ�̓V��t�B���[��ΏۊO��
      (progn
        (setq #xdLSYM$ (CFGetXData #sym "G_LSYM"))

        ; �e�}�`�i��
        (if #xdLSYM$
          (setq #oya_hinban (nth 5 #xdLSYM$))
          (setq #oya_hinban "")
        )

        ; L/R�敪
        (if #xdLSYM$
          (setq #LR_oya (nth 6 #xdLSYM$))
          (setq #LR_oya "Z")
        )

        (setq #hand (cdr (assoc 5 (entget #sym))))
        (setq #xd$  (CFGetXData #sym "G_OPT"))

        (setq #xd2$ #xd$)
        (repeat (car #xd$)
          (setq #xd2$ (cdr #xd2$))
          (setq #hin  (car #xd2$))  ;�i��
          (setq #xd2$ (cdr #xd2$))
          (setq #num  (car #xd2$))  ;��

          ;// �i�Ԋ�{�e�[�u�������߼�ݕi�����擾
          (setq #fig$ (car (CFGetDBSQLHinbanTable "�i�Ԋ�{" #hin (list (list "�i�Ԗ���" #hin 'STR)))))
;-- 2012/02/09 A.Satoh Mod - S
					(if (/= #fig$ nil)
						(progn
							(if (and #xdLSYM$ (= (nth 15 #xdLSYM$) "D") (= (substr (nth 5 #fig$) 1 1) "A"))
								(progn
									(setq #qry$
										(car (CFGetDBSQLHinbanTable "�W��ID�ϊ�" #hin
										(list (list "�i�Ԗ���" #hin 'STR))))
									)

									(if (/= #qry$ nil)
										(setq #syuyaku (nth 1 #qry$))
										(setq #syuyaku (nth 5 #fig$))
									)
								)
								(setq #syuyaku (nth 5 #fig$))
							)

							(setq #lst$$
								(append #lst$$
									(list
										(list
											(fix (nth 2 #fig$))             ; 1.�\�[�g�L�[
											(KP_DelHinbanKakko #hin)        ; 2.�i�Ԗ��� ()�O��
											(list "")                       ; 3.�}�`�n���h��
											(if (equal (nth 1 #fig$) 1 0.1) ; 4.L/R
												#LR_oya                       ;   �e�}�`��LR
												"Z"                           ;   LR�Ȃ�
											)
											0                               ; 5.�o�͖��̃R�[�h
											0                               ; 6.�d�l���̃R�[�h
											#num                            ; 7.��
											0                               ; 8.���z(���ς菈���Ŏ擾)
											"xxxxxxx"                       ; 9.�i�R�[�h
											"3"                             ;10.���ގ�ރt���O
											#syuyaku                        ;11.�W��ID
											(nth 15 #xdLSYM$)               ;12.����
											""
											0
										)
									)
								)
							)
						)
					)
;;;;;          (if (= #fig$ nil)
;;;;;            nil
;;;;;            (setq #lst$$
;;;;;              (append #lst$$
;;;;;                (list
;;;;;                  (list
;;;;;                    (fix (nth 2 #fig$))             ; 1.�\�[�g�L�[
;;;;;                    (KP_DelHinbanKakko #hin)        ; 2.�i�Ԗ��� ()�O��
;;;;;                    (list "")                       ; 3.�}�`�n���h��
;;;;;                    (if (equal (nth 1 #fig$) 1 0.1) ; 4.L/R
;;;;;                      #LR_oya                       ;   �e�}�`��LR
;;;;;                      "Z"                           ;   LR�Ȃ�
;;;;;                    )
;;;;;                    0                               ; 5.�o�͖��̃R�[�h
;;;;;                    0                               ; 6.�d�l���̃R�[�h
;;;;;                    #num                            ; 7.��
;;;;;                    0                               ; 8.���z(���ς菈���Ŏ擾)
;;;;;                    "xxxxxxx"                       ; 9.�i�R�[�h
;;;;;                    "3"                             ;10.���ގ�ރt���O
;;;;;                    (nth 5 #fig$)                   ;11.�W��ID
;;;;;                    (nth 15 #xdLSYM$)               ;12.����
;;;;;;-- 2011/12/09 A.Satoh Add - S
;;;;;										""
;;;;;										0
;;;;;;-- 2011/12/09 A.Satoh Add - E
;;;;;                  )
;;;;;                )
;;;;;              )
;;;;;            )
;;;;;          )
;-- 2012/02/09 A.Satoh Mod - E
        )
      )
    )
    (setq #i (+ #i 1))
  )

  #lst$$

) ;ConfPartsAll_GetOptionInfo


(princ)

