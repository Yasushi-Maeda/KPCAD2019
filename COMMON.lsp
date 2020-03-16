;<HOM>************************************************************************
; <�֐���>    : dpr
; <�����T�v>  : �f�o�b�O�p�o��
; <�߂�l>    :
; <�쐬>      : 97-01-31 ��{����
; <���l>      :
;              ��j�V���{�� #a (�l��3) ���o��
;                  (dpr '#a)
;                  �o�͓��e   "#a = 3"
;************************************************************************>MOH<
(defun dpr (
    &val    ;(SYM) �V���{����
  )
  (princ "\n")
  (princ &val)
  (princ " = ")
  (princ (eval &val))
  (princ)
)
;dpr

;<HOM>************************************************************************
; <�֐���>    : dtr
; <�����T�v>  : �p�x���烉�W�A���ɕϊ�
; <�߂�l>    :
; <�쐬>      : 96-12-03 ��{����
; <���l>      : �Ȃ�
;************************************************************************>MOH<
(defun dtr (
    &a  ;(REAL) �p�x
  )
  (* pi (/ &a 180.0))
)
;dtr

;<HOM>************************************************************************
; <�֐���>    : rtd
; <�����T�v>  : ���W�A������p�x�ɕϊ�
; <�߂�l>    :
; <�쐬>      : 96-12-03 ��{����
; <���l>      : �Ȃ�
;************************************************************************>MOH<
(defun rtd (
    &a  ;(REAL) ���W�A��
  )
  (/ (* &a 180.0) pi)
)
;rtd

;<HOM>*************************************************************************
; <�֐���>    : rtois
; <�����T�v>  : �����l�𐮐�������ɕϊ�����
; <�߂�l>    :
;       (INT) : ����������
; <�쐬>      : 1998-06-15
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun rtois (
    &r   ;(REAL)�����l
  )
  (itoa (atoi (rtos &r 2 2)))
)
;rtois

;<HOM>*************************************************************************
; <�֐���>    : MakeLayer
; <�����T�v>  : ��w���쐬����
; <�߂�l>    :
; <�쐬>      : 98-03-25 ��{����
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun MakeLayer (
    &lay        ;(STR)��w��
    &col        ;(INT)�F
    &lt         ;(STR)����
  )
  (if (= nil (tblobjname "LAYER" &lay))
    (entmake
      (list
        '(0 . "LAYER")
        '(5 . "28")
        '(100 . "AcDbSymbolTableRecord")
        '(100 . "AcDbLayerTableRecord")
        (cons 2 &lay)
        '(70 . 64)
        (cons 62 &col)
        (cons 6 &lt)
      )
    )
  )
)
;MakeLayer

;<HOM>*************************************************************************
; <�֐���>    : MakeLwPolyLine
; <�����T�v>  : �_�񂩂烉�C�g�E�F�C�g�|�����C�����쐬����
; <�߂�l>    :
;       ENAME : �쐬�������C�g�E�F�C�g�|�����C����
; <�쐬>      : 98-03-25 ��{����
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun MakeLwPolyLine (
    &pt$  ;(LIST)�\�����W�_ؽ�
    &cls  ;(INT) 0=�J��/1=����
    &elv  ;(REAL)���x
    /
    #vn #eg #pt #pw
  )
  ;// ���_��
  (setq #pw (getvar "PLINEWID"))
  (setq #vn (length &pt$))
  (setq #eg
    (list
      '(0 . "LWPOLYLINE")
      '(100 . "AcDbEntity")
      '(100 . "AcDbPolyline")
      (cons 90 #vn)          ;���_��
      (cons 70 &cls)         ;���_��
      (cons 38 &elv)         ;���_��
    )
  )
  (foreach #pt &pt$
    (setq #eg (append #eg (list (cons 10 #pt))))
    (setq #eg (append #eg (list (cons 40 #pw))))
    (setq #eg (append #eg (list (cons 41 #pw))))
  )
  (entmake #eg)
  ;// �|�����C���}�`����Ԃ�
  (entlast)
)
;MakeLwPolyLine

;<HOM>*************************************************************************
; <�֐���>    : GetLwPolyLinePt
; <�����T�v>  : ���C�g�E�F�C�g�|�����C���̓_����擾����
; <�߂�l>    :
;        LIST : ���C�g�E�F�C�g�|�����C���̓_��
; <�쐬>      : 98-03-25 ��{����
; <���l>      :
;*************************************************************************>MOH<
(defun GetLwPolyLinePt (
    &en
    /
    #v1 #v2 #v3 #v4 #eg #pt$
  )
  (setq #eg (entget &en))
  (setq #v1 (length #eg)
        #v2 0
  )
  (while (> #v1 #v2)
    (setq #v3 (nth #v2 #eg))
    (if (= (car #v3) 10)
      (progn
        (setq #pt$ (append #pt$ (list (cdr #v3))))
      )
    )
    (setq #v2 (+ #v2 1))
  )
  #pt$
)
;GetLwPolyLinePt

;<HOM>*************************************************************************
; <�֐���>    : ReadCSVFile
; <�����T�v>  : CSV�t�@�C����ǂݍ���
; <�߂�l>    :
; <�쐬>      : 98-04-20 ��{����
; <���l>      :
;*************************************************************************>MOH<
(defun ReadCSVFile (
    &csvfile
    /
    #fp
    #rstr
    #itm$
    #res$$
  )
  (setq #fp (open &csvfile "r")) ;// ̧�ٵ����(READ)

  ;// ̧�ق�ǂݍ���
  (while (setq #rstr (read-line #fp))
    ;// �������������ŋ�؂�
    (setq #itm$ (strparse #rstr ","))
    (setq #res$$ (append #res$$ (list #itm$)))
  )
  (close #fp)  ;// ̧�ٸ۰��

  ;// ���ʂ�Ԃ�
  #res$$
)
;ReadCSVFile

;<HOM>************************************************************************
; <�֐���>    : DelListItem
; <�����T�v>  : ���X�g���̎w��v�f���폜����
; <�߂�l>    :
;      ���X�g : �폜��̃��X�g
;
; <���l>      : �n�߂ɂ݂������v�f�̂ݍ폜
;************************************************************************>MOH<
(defun DelListItem (
    &list$    ;�Ώۃ��X�g
    &mem      ;�폜�v�f
    /
  )
  (cond
    ((atom &list$)
      &list$
    )
    ((equal (car &list$) &mem)
      (cdr &list$)
    )
    (T
      (cons (car &list$) (DelListItem (cdr &list$) &mem))
    )
  )
)
;DelListItem

;<HOM>*************************************************************************
; <�֐���>    : IsEntInPolygon
; <�����T�v>  : �}�`���̈���ɂ��邩�`�F�b�N
; <�߂�l>    :
;           T : �̈��
;         nil : �̈�O
; <���l>      : mode�ɂ���
;                 WP ���̈�ŗ̈��
;                 CP �����̈�ŗ̈��
;*************************************************************************>MOH<
(defun IsEntInPolygon (
    &en      ;(ENAME)���O����}�`
    &pt$     ;(LIST) ���O����̈���W���X�g
    &mode    ;(STR)  ���[�h("WP":�|���S����  "CP":�|���S������)
    /
    #ss
  )
  (setq #ss (ssget &mode &pt$))
  (if (and (/= #ss nil) (ssmemb &en #ss))
    T
    nil
  )
)
;IsEntInPolygon

;<HOM>*************************************************************************
; <�֐���>    : IsPtInPolygon
; <�����T�v>  : �w��_���̈���ɂ��邩�`�F�b�N
; <�߂�l>    :
; <���l>      : mode�ɂ���
;                 WP ���̈�ŗ̈��
;                 CP �����̈�ŗ̈��
;*************************************************************************>MOH<
(defun IsPtInPolygon (
    &pt        ;(LIST)�w��_
    &pt$       ;(LIST)���O����̈���W���X�g
    /
    #ss #ret
  )
  ;// �_�~�[�_�͍�}����
  (entmake
    (list
      (cons 0 "POINT")
      (cons 100 "AcDbEntity")
      (cons 100 "AcDbPoint")
      (cons 10 &pt)
    )
  )
  ;// �_�~�[�_���̈���ɂ��邩���ׂ�
  (setq #ret (IsEntInPolygon (entlast) &pt$ "CP"))
  ;// �_�~�[�_���폜����
  (entdel (entlast))
  ;// ���ʂ�Ԃ�
  #ret
)
;IsPtInPolygon

;<HOM>*************************************************************************
; <�֐���>    : YesNoDialog
; <�����T�v>  : �x���_�C�A���O�\��(Yes,Cancel)
; <�߂�l>    :
;           T : �͂�
;         nil : ������
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(setq YesNoDialog CFYesNoDialog)

;<HOM>*************************************************************************
; <�֐���>    : GetVal
; <�����T�v>  : ���X�g���
; <�߂�l>    :
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun GetVal (
    &grp           ;(STR) �O���[�v�R�[�h
    &ele           ;(LIST)���X�g���
  )
  (cond
    ((= (type &ele) 'ENAME)          ;ele���}�`���̂Ƃ�
      (cdr (assoc &grp (entget &ele)))
    )
    ((not &ele) nil)                 ;ele��nil�̂Ƃ�
    ((not (listp &ele)) nil)         ;ele���������Ȏ�
    ((= (type (car &ele)) 'ENAME)    ;entsel���Ԃ����X�g�̂Ƃ�
      (cdr (assoc &grp (entget (car &ele))))
    )
    (T (cdr (assoc &grp &ele)))       ;entget���Ԃ����X�g�̂Ƃ�
  )
)
;GetVal

;<HOM>*************************************************************************
; <�֐���>    : setError
; <�����T�v>  : �װ�֐�
;*************************************************************************>MOH<
(defun setError ()
  (setvar "CMDECHO" 0)
  (if (= CG_DEBUG nil)
    (setq *error* err_function)
    (setq *error* nil)
  )
)
;setError

;<HOM>*************************************************************************
; <�֐���>    : err_function
; <�����T�v>  : �װ�֐�
;*************************************************************************>MOH<
(defun err_function (msg)
  ;(setvar "OSMODE" CG_OSMODE)
  ;(setq *error* nil)
  (princ)
)
;err_function

;;;-----------------------------------------------------------------------------
;;; from ai_util.lsp
;;;
;;; (ai_strtrim <string> )
;;; (ai_strltrim <string> )
;;; (ai_strrtrim <string> )
;;;
;;; Trims leading and trailing spaces from strings.
;;;-----------------------------------------------------------------------------
;<HOM>*************************************************************************
; <�֐���>    : ai_strtrim
; <�����T�v>  : ������̋󔒍폜
; <�߂�l>    :
;         STR : �󔒍폜������
; <�쐬>      : 1999-12-20
; <���l>      :
;               "    ������    " -> "������"
;*************************************************************************>MOH<
(defun ai_strtrim (
    &s          ;(STR)������
  )
  (cond
    ((/= (type &s) 'str) nil)
    (t (ai_strltrim (ai_strrtrim &s)))
  )
)
;ai_strtrim

;<HOM>*************************************************************************
; <�֐���>    : ai_strltrim
; <�����T�v>  : ������̍��󔒍폜
; <�߂�l>    :
;         STR : �󔒍폜������
; <�쐬>      : 1999-12-20
; <���l>      :
;               "    ������" -> "������"
;*************************************************************************>MOH<
(defun ai_strltrim (
    &s          ;(STR)������
  )
  (cond
    ((eq &s "") &s)
    ((/= " " (substr &s 1 1)) &s)
    (t (ai_strltrim (substr &s 2)))
  )
)
;ai_strltrim

;<HOM>*************************************************************************
; <�֐���>    : ai_strrtrim
; <�����T�v>  : ������̉E�󔒍폜
; <�߂�l>    :
;         STR : �󔒍폜������
; <�쐬>      : 1999-12-20
; <���l>      :
;               "������     " -> "������"
;*************************************************************************>MOH<
(defun ai_strrtrim (
    &s          ;(STR)������
  )
  (cond
    ((eq &s "") &s)
    ((/= " " (substr &s (strlen &s) 1)) &s)
    (t (ai_strrtrim (substr &s 1 (1- (strlen &s)))))
  )
)
;ai_strrtrim

;;;<HOM>************************************************************************
;;; <�֐���>  : C:KpChg
;;; <�����T�v>: �Q�c�v�f�|���̑��|����^�F�ύX
;;; <�쐬>    : 2001/05/15 GSM���ڐA
;;; <�߂�l>  : �Ȃ�
;;;************************************************************************>MOH<
(defun C:KpChg
  (
  /
  #ss
  #list$
  #i
  #en
  #eg
  #sub
  #ltype
  )
  (setq #ss (ssget))
  (if (/= nil #ss)
    (progn
      (setq #list$ (NRElemChgLtCoDialog))
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #eg (entget #en '("*")))
        (if (/= nil (car #list$))
          (if (assoc 62 #eg)
            (setq #sub (subst (cons 62 (car #list$)) (assoc 62 #eg)#eg))
            (setq #sub (append #eg (list (cons 62 (car #list$)))))
          )
          (setq #sub #eg)
        )
        (if (/= nil (cadr #list$))
          (progn
            (if (assoc 6 #eg)
              (entmod (subst (cons 6 (cadr #list$)) (assoc 6 #sub)#sub))
              (entmod (append #sub (list (cons 6 (cadr #list$)))))
            )
          )
          (entmod #sub)
        )
        (setq #i (1+ #i))
      ) ;_repeat
    ) ;_progn
  ) ;_if

  (princ)
) ;C:KpChg

;;;<HOM>************************************************************************
;;; <�֐���>  : NRElemChgLtypeDialog
;;; <�����T�v>: �Q�c�v�f�|�����޲�۸�
;;; <�쐬>    : 2001/05/15 GSM���ڐA
;;; <�߂�l>  : �Ȃ�
;;;************************************************************************>MOH<
(defun NRElemChgLtypeDialog (
  /
  ##okey_dia
  #list$
  #dcl_id
  #what_next
  #ret
  )

  (defun ##okey_dia ()
    (get_tile "list")
  )
  (setq #list$ (list "BYBLOCK" "BYLAYER"))
  (setq #list$ (cons (cdr (assoc 2 (tblnext "LTYPE" T))) #list$))
  (while (setq #tbl$ (tblnext "LTYPE"))
    (setq #list$ (cons (cdr (assoc 2 #tbl$)) #list$))
  )
  (setq #list$ (reverse #list$))
  (setq #dcl_id (eval (load_dialog (strcat CG_DCLPATH "common.dcl"))))
  (setq #what_next 99)
  (while (and (/= 1 #what_next) (/= 0 #what_next))
    (new_dialog "linetype" #dcl_id)
    (start_list "list")
    (mapcar 'add_list #list$)
    (end_list)
    (set_tile "list" "0")
    (action_tile "accept" "(setq #ret (##okey_dia))(done_dialog 1)")
    (action_tile "cancel" "(done_dialog 0)")
    (setq #what_next (start_dialog))
  )
  (unload_dialog #dcl_id)

  (if (/= nil #ret)
    (nth (atoi #ret) #list$)
    nil
  )
)

;;;<HOM>************************************************************************
;;; <�֐���>  : NRElemChgLtCoDialog
;;; <�����T�v>: �Q�c�v�f�|����^�F�ύX�_�C�A���O
;;; <�쐬>    : 2001/05/15 GSM���ڐA
;;; <�߂�l>  : �Ȃ�
;;;************************************************************************>MOH<
(defun NRElemChgLtCoDialog
  (
  /
  #dcl_id
  #what_next
  #ltype
  #color
  )
  (setq #dcl_id (eval (load_dialog (strcat CG_DCLPATH "common.dcl"))))
  (setq #what_next 99)
  (while (and (/= 1 #what_next) (/= 0 #what_next))
    (new_dialog "ltcochg" #dcl_id)
    (action_tile "ltype" "(setq #ltype (NRElemChgLtypeDialog))(done_dialog 2)")
    (action_tile "color" "(setq #color (acad_colordlg 256))(done_dialog 2)")
    (action_tile "accept"  "(done_dialog  1)")
    (action_tile "cancel"  "(done_dialog  0)")
    (setq #what_next (start_dialog))
  )
  (unload_dialog #dcl_id)

  (list #color #ltype)
)


;;;<HOM>*************************************************************************
;;; <�֐���>     : C:PickUP_suisen
;;; <�����T�v>   : ���𐅐����s�b�N�A�b�v����
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 06/06/13 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun C:PickUP_suisen (
  /
	#CG_DBNAME #CG_DEBUG #CSV$$ #DATE_TIME #DUM$$ #FIL #ISERI #MDB #OFILE #SERI #SERI$$
  )

    ;;;**********************************************************************
    ;;; ٰ�ߏ���
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#HINBAN #QRY$$ #QRY_KAISO$$ #qry_zukei$$
      )

				(setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))

				(princ "\n-------------------------" #fil)
				(princ (strcat "\nDB��:" CG_DBNAME) #fil)
				(princ "\n-------------------------" #fil)

				;�i�Ԋ�{����
		    (setq #qry$$
	      	(CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
		        (list
		          (list "���iCODE" "510" 'INT)
		        )
		      )
		    )

				(foreach #qry$ #qry$$
					(setq #hinban (nth 0 #qry$))
					;�K�w����
			    (setq #qry_kaiso$$
		      	(CFGetDBSQLRec CG_DBSESSION (strcat "�K�w" CG_SeriesCode)
			        (list
			          (list "�K�w����" #hinban 'STR)
			        )
			      )
			    )
					(if (= nil #qry_kaiso$$)
						(princ (strcat "\n�K�w�ɑ��݂��Ȃ�," #hinban) #fil)
						;else
						(progn
							(if (> 0 (nth 1 (car #qry_kaiso$$)))
								(princ (strcat "\n�~," #hinban) #fil)
								;else
								(progn
									;�i�Ԑ}�`����
							    (setq #qry_zukei$$
						      	(CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
							        (list
							          (list "�i�Ԗ���" #hinban 'STR)
							          (list "LR�敪"   "Z"     'STR)
							        )
							      )
							    )
									(if (= nil #qry_zukei$$)
										(princ (strcat "\n��," #hinban ",�i�Ԑ}�`�ɂ���܂���") #fil)
										;else
										(progn
											(setq #id (nth 6 (car #qry_zukei$$)));2008/06/28 OK!
											(princ (strcat "\n��," #hinban ",ID=" #id) #fil)
										)
									);_if
								)
							);_if
						)
					);_if
				)
			
			(princ)
		);###EXE
    ;/////////////////////////////////////////////////////////////////////////////


	(StartUndoErr);// �R�}���h�̏�����

	(setvar "CMDECHO" 0)
	(C:de0)

	(setq #CG_DBNAME CG_DBNAME);���݂̃V���[�Y

	(setq #CG_DEBUG CG_DEBUG);���ޯ�Ӱ��
	(setq CG_DEBUG 0);���ޯ�Ӱ��

	;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	;�Ώۼذ�ޏ�� 0/01/10 YM ADD
  (setq #iseri (strcat CG_SYSPATH "temp\\pickup_seri.txt"));�����Ώۼذ�ނ̓ǂݍ���
  (setq #CSV$$ (ReadCSVFile #iseri))
	;�擪��";"���������珜��
	(setq #dum$$ nil)
	(foreach #CSV$ #CSV$$
		(setq #MDB (nth 0 #CSV$))
		(setq #seri (nth 1 #CSV$))
		(if (= ";" (substr #MDB 1 1))
			nil
			;else
			(progn
				(setq #dum$$ (append #dum$$ (list (list #MDB #seri))))
			)
		);_if
	);foreach
	(setq #seri$$ #dum$$)
	;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  (setq #ofile  (strcat CG_SYSPATH "temp\\kekka.txt"));�������ʏo��̧��
  (setq #fil (open #ofile "W" ))

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n" #fil)
	(princ (strcat "\n--------------------------------------") #fil)
	(princ (strcat "\n�����ꗗ ��:��ʊK�w(+),�~:��ʊK�w(-)") #fil)
	(princ (strcat "\n--------------------------------------") #fil)
  (princ "\n" #fil)

	(foreach #seri$ #seri$$ ; �e�ذ�ނł�loop
		(setq CG_SeriesDB (nth 0 #seri$))
		(setq CG_DBNAME (nth 0 #seri$))
		(setq CG_SeriesCode (nth 1 #seri$))
		(setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))

		(###EXE)

	);_if

	;DB�ڑ�,���ޯ�Ӱ�ނ�߂�
	(setq CG_DBSESSION  (dbconnect #CG_DBNAME  "" ""))
	(setq CG_DEBUG #CG_DEBUG);���ޯ�Ӱ��

	(setq *error* nil)
	(if #fil (close #fil))

	(startapp "notepad.exe" #ofile)
  (princ)
);C:PickUP_suisen

;;;<HOM>*************************************************************************
;;; <�֐���>     : C:zukei_kosu
;;; <�����T�v>   : ���i����="1??"��[�i�Ԑ}�`]�ɐ}�`ID��������̂̈ꗗ���o��
;;;                �Ώۼذ�ނ́A�`\system\log\zukei_kosu.txt
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 06/11/6 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun C:zukei_kosu (
  /
	#CG_SERIESCODE #CG_SERIESDB #CSV$$ #DATE_TIME #DUM$$ #FIL #HINBAN #I #IFILE #MDB
	#QRY_KIHON$$ #REC$$ #SERI #SERI$$ #SKK #ZUKEIID #ZUKEIID$
  )

    ;;;**********************************************************************
    ;;; ؽĂ̏d�����R�[�h������
    ;;; 05/06/01 YM
    ;;;**********************************************************************
    (defun ##delREC0 (
      &lis$ ; #hin$��ؽČ`��
      /
      #DUM$ #HIN #HIN$ #LIS$ #RET$
      )
      (setq #dum$ nil #hin$ nil)
      (foreach #lis &lis$
        (setq #hin #lis)
        (if (member #hin #hin$)
          nil
          ;else
          (setq #dum$ (cons #lis #dum$))
        );_if
        (setq #hin$ (cons #hin #hin$))
      )
      (setq #ret$ #dum$)
      #ret$
    );##delREC0


	(setq #CG_SeriesDB CG_SeriesDB)
	(setq #CG_SeriesCode CG_SeriesCode)

	(setvar "CMDECHO" 0)
	(C:de0)

  (setq #fil (open (strcat CG_SYSPATH "LOG\\zukei_kosu.out") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n���i����=1??��[�i�Ԑ}�`]�ɐ}�`ID��������̂̈ꗗ���o��" #fil)
  (princ "\n" #fil)

	;�Ώۼذ�ޏ��
  (setq #ifile (strcat CG_SYSPATH "LOG\\zukei_kosu.txt"));�����Ώۼذ�ނ̓ǂݍ���
  (setq #CSV$$ (ReadCSVFile #ifile))
	;�擪��";"���������珜��
	(setq #dum$$ nil)
	(foreach #CSV$ #CSV$$
		(setq #MDB (nth 0 #CSV$))
		(setq #seri (nth 1 #CSV$))
		(if (= ";" (substr #MDB 1 1))
			nil
			;else
			(progn
				(setq #dum$$ (append #dum$$ (list (list #MDB #seri))))
			)
		);_if
	);foreach
	(setq #seri$$ #dum$$)

	(setq #zukeiID$ nil)
	(foreach #seri$ #seri$$ ; �e�ذ�ނł�loop
		(setq CG_SeriesDB (nth 0 #seri$))
		(setq CG_SeriesCode (nth 1 #seri$))
		(setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))
		(princ (strcat "\n�ذ��:" CG_SeriesDB))
		(princ (strcat "\n�ذ��:" CG_SeriesDB) #fil)
		;��[�i�Ԑ}�`]��-----------------------------------------------
		(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "�i�Ԑ}�`")))
		(setq #i 0)
		(foreach #rec$ #rec$$
			(setq #hinban  (nth 0 #rec$))
			(setq #zukeiID (nth 6 #rec$));2008/06/28 OK!
			(if (and (= #zukeiID nil)(= #zukeiID ""))
				nil
				;else
				(progn
					;�i�Ԋ�{���� ���i����
			    (setq #qry_kihon$$
		      	(CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
			        (list
			          (list "�i�Ԗ���" #hinban 'STR)
			        )
			      )
			    )
					(if #qry_kihon$$
						(progn
							(setq #skk (nth 3 (car #qry_kihon$$)))
							(if (and (< 99.99 #skk)(> 199.9 #skk))
								(progn
;;;									(princ (strcat "\n�i��:" #hinban) #fil)
									(setq #i (1+ #i))
								)
							);_if
						)
					);_if
					
				)
			);_if
		);foreach
		(princ (strcat "\n--- ��:" (itoa #i)) #fil)
	);foreach

	(princ "\n" #fil)
	(princ "\n")

	(princ "\n�����`�F�b�N�I������")
	(princ "\n�����`�F�b�N�I������" #fil)
  (close #fil)


  ;// ���̃f�[�^�x�[�X�ɐڑ�����
	(setq CG_SeriesDB #CG_SeriesDB)
	(setq CG_SeriesCode #CG_SeriesCode)

  (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))

  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\SLIDE-CHECK.txt"))
	(princ)
);C:zukei_kosu

;<HOM>*************************************************************************
; <�֐���>    : C:TENBAN_SAKUSEI
; <�����T�v>  : KPCAD�̷������݂���V������dwg�ۑ�����
; <�߂�l>    : �Ȃ�
; <�쐬��>    : 06/11/08 YM
; <���l>      : 
;�@             [�O��]�}�ʂɉ����Ȃ���Ԃ������݌��������s��������(�z�u�p�x=0)
;               ���ݕۑ��ꏊ,���O�͂��߂���(Xdata�͍폜���ĕۑ�)
;               �V��1����===>(strcat CG_SYSPATH "LOG\\WT_1.dwg")
;               �V��2����===>(strcat CG_SYSPATH "LOG\\WT_2.dwg")
;*************************************************************************>MOH<
(defun C:TENBAN_SAKUSEI (
  /
	#BASEWT #I #SS #SSOLDSYM #SSWT #SYM #WT #XD$ #XY #Z #OFNAME
  )
  (StartUndoErr);// �R�}���h�̏�����
	(setvar "FILEDIA" 0)
	(setvar "CMDECHO" 0)
	(C:de0)

;;;  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
;;;	(if (and #ss (< 0 (sslength #ss)))
;;;		(progn
;;;			(setq #i 0)
;;;			(repeat (sslength #ss)
;;;				(setq #sym (ssname #ss #i))
;;;				; G_LSYM���ލ폜
;;;		    (setq #ssOLDSYM (CFGetSameGroupSS #sym))
;;;		    (command "_erase" #ssOLDSYM "")
;;;				(command "_purge" "BL" "*" "N")
;;;				(command "_purge" "BL" "*" "N")
;;;				(command "_purge" "BL" "*" "N")
;;;				(setq #i (1+ #i))
;;;			);repeat
;;;		)
;;;	);_if

	;�}�ʏ��WT������
  (setq #ssWT (ssget "X" '((-3 ("G_WRKT")))))
	(if (and #ssWT (<= 1 (sslength #ssWT)))
		(progn
			(setq #i 0)
			(repeat (sslength #ssWT)
				(setq #WT (ssname #ssWT #i))
				;�ۑ��p�X&�t�@�C������
				(setq #ofname (strcat CG_SYSPATH "LOG\\WT_" (itoa (1+ #i)) ".dwg"))
				;Xdata "G_WRKT" �擾
				(setq #xd$ (CFGetXData #WT "G_WRKT"))
				;WT���ʂ̈ʒu
				(setq #Z (nth 8 #xd$))
				;WT��ʂ̍���_
				(setq #XY (nth 32 #xd$))
				;WT�}����_
				(setq #baseWT (list (car #XY) (cadr #XY) #Z))
				;Xdata=G_WRKT,G_WTSET�̍폜
				(DelAppXdata #WT "G_WRKT")
				(DelAppXdata #WT "G_WTSET")
				(command "._wblock" #ofname "" #baseWT #WT "")
				(setq #i (1+ #i))
			)
		)
	);_if

	(c:clear) ; �}�ʸر�
	; ��ٰ�ߕ���
	(KP_DelUnusedGroup)
	(command "_purge" "BL" "*" "N")
	(command "_purge" "BL" "*" "N")
	(command "_purge" "BL" "*" "N")

  (setq *error* nil)
  (CFCmdDefFinish)
  (princ)
);C:TENBAN_SAKUSEI

;<HOM>*************************************************************************
; <�֐���>    : new_old_kakaku_hantei
; <�����T�v>  : �V�����i����
; <�߂�l>    :
; <�쐬>      : 07/10/02 YM ADD
; <���l>      :
;*************************************************************************>MOH<
(defun new_old_kakaku_hantei (
	/
	#FNAME #RET #STR
  )
	(setq #fname (strcat CG_KENMEI_PATH "new_old_kakaku.cfg"))
  (if (= nil (findfile #fname))
    (setq #ret "OLD")
		;else
		(progn
			(setq #str (car (car (ReadCSVFile #fname))))
			(cond
				((= #str "KAKAKU=NEW")
			 		(setq #ret "NEW")
			 	)
				((= #str "KAKAKU=OLD")
			 		(setq #ret "OLD")
			 	)
				(T
			 		(setq #ret "OLD")
		 		)
			);_cond
		)
  );_if
	#ret
);new_old_kakaku_hantei


;<HOM>*************************************************************************
; <�֐���>    : SetPlan_Kiki_Name
; <�����T�v>  : �V���ʋ@��ꗗ�̌���
; <�߂�l>    :
; <�쐬>      : 07/10/02 YM ADD
; <���l>      : 07/10/06 YM ADD DIPLOA���Ɍ���KEY�ǉ�
;*************************************************************************>MOH<
(defun SetPlan_Kiki_Name (
	/
	#QRY$ #DRSERI #KEY
  )
	(if (= CG_SeriesCode "D")
		(progn ;DIPLOA�̂Ƃ���KEY��ǉ�
			(setq #DRSeri (substr CG_DRSeriCode 1 1))
			(if (or (= #DRSeri "A")(= #DRSeri "B"))
				(setq #KEY "SP")
				;else
				(setq #KEY "EX")
			);_if

		  (setq #qry$ (car
			  (CFGetDBSQLRec CG_CDBSESSION "�V���ʋ@��ꗗ"
			    (list
						(list "����" (strcat "NK_" CG_SeriesDB) 'STR)
						(list "KEY1" #KEY                       'STR);"SP" ro "EX"
			    )
			  ))
			)
		)
		(progn
		  (setq #qry$ (car
			  (CFGetDBSQLRec CG_CDBSESSION "�V���ʋ@��ꗗ"
			    (list
						(list "����" (strcat "NK_" CG_SeriesDB)   'STR)
			    )
			  ))
			)
		)
	);_if
	#qry$
);SetPlan_Kiki_Name

;;;<HOM>*************************************************************************
;;; <�֐���>     : C:EXhinban
;;; <�����T�v>   : �i�Ԃ��w�肵�Ċe�V���[�Y��(�K�w,�i�Ԋ�{,�i�ԍŏI)�ɑ��݂��邩�ǂ���
;;;                �ꗗ���o�͂���
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 05/09/16 YM
;;; <����>       : 05/12/13 YM ���łɎd�l,���i�����o��
;;; <���l>       : ������g�p����ƃG���[: ADS �v���G���[���o�Ă��܂�
;;;*************************************************************************>MOH<
(defun C:EXhinban (
  /
	#CG_DBNAME #CG_DEBUG #CG_SERIESCODE #CG_SERIESDB #CSV$$ #DATE_TIME #DUM$$ #FIL
	#HINBAN$ #IFILE #ISERI #KAI$$ #KEKKA$$ #KEKKA1 #KEKKA2 #MDB #OFILE #QRY1$$
	#QRY2$$ #SERI #SERI$$ #UPID #UPID_FLG #UPID_UPKAISO #kekka44
  )

    ;;;**********************************************************************
    ;;; ٰ�ߏ���
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#KAI$$ #KEKKA1 #KEKKA2 #QRY1$$ #QRY2$$ #UPID #UPID_FLG #UPID_UPKAISO
      )

			(princ (strcat "\n--- " CG_SeriesDB " ---"))
      (foreach #hinban #hinban$
				(princ (strcat "\n " #hinban))

        ;�K�w����
        (setq #qry1$$
          (CFGetDBSQLRec CG_DBSESSION "�K�w"
            (list
              (list "�K�w����" #hinban 'STR)
            )
          )
        )

        (if #qry1$$
          (progn
            (setq #UPid (nth 1 (car #qry1$$)));1�߂�ں��ނ̏�ʊK�wID
            (if (> 0 (read #UPid))
              (setq #UPid_flg -1)
              ;else
              (progn ;��ʊK�wID>0�ł��K�w̫��ގ��̂̏�ʊK�wID�𒲂ׂ�
                ;��ʊK�w�̏�ʊK�wID���擾
                (setq #kai$$
                  (CFGetDBSQLRec CG_DBSESSION "�K�w"
                    (list
                      (list "�K�wID" #UPid 'STR)
                    )
                  )
                )
                (setq #upid_upkaiso (nth 1 (car #kai$$)))
                (if (> 0 (read #upid_upkaiso))
                  (setq #UPid_flg -1)
                  ;else
                  (setq #UPid_flg 1)
                );_if
              )
            );_if
          )
        );_if

        (if #qry1$$
          (progn
            (if (> 0 #UPid_flg)
              (setq #kekka1 "��");��ʊK�wID��ϲŽ
              ;else
              (setq #kekka1 "��");��ʊK�wID����׽
            );_if
          )
          ;else
          (setq #kekka1 "�~")
        );_if

        ;�i�Ԋ�{����
        (setq #qry2$$
          (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
            (list
              (list "�i�Ԗ���" #hinban 'STR)
            )
          )
        )

        (if #qry2$$
          (setq #kekka2 "��")
          ;else
          (setq #kekka2 "�~")
        );_if



        ;�i�Ԑ}�`����
        (setq #qry3$$
          (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
            (list
              (list "�i�Ԗ���" #hinban 'STR)
            )
          )
        )

        (if #qry3$$
          (setq #kekka3 "��")
          ;else
          (setq #kekka3 "�~")
        );_if



        ;�i��OP����
        (setq #qry4$$
          (CFGetDBSQLRec CG_DBSESSION "�i��OP"
            (list
              (list "�i�Ԗ���" #hinban 'STR)
            )
          )
        )
        (if #qry4$$
          (setq #kekka4 "��")
          ;else
          (setq #kekka4 "�~")
        );_if


        ;�i��OP����(2)
        (setq #qry44$$
          (CFGetDBSQLRec CG_DBSESSION "�i��OP"
            (list
              (list "OP�i�Ԗ���" #hinban 'STR)
            )
          )
        )
        (if #qry44$$
          (setq #kekka44 "��")
          ;else
          (setq #kekka44 "�~")
        );_if


        ;�i�ԍŏI����
        (setq #qry5$$
          (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
            (list
              (list "�i�Ԗ���" #hinban 'STR)
            )
          )
        )
        (if #qry5$$
          (setq #kekka5 "��")
          ;else
          (setq #kekka5 "�~")
        );_if

        (setq #kekka$$ (append #kekka$$ (list (list #hinban CG_DBNAME #kekka1 #kekka2 #kekka3 #kekka4 #kekka44 #kekka5))))

      );foreach

      (princ)
    );###EXE
    ;/////////////////////////////////////////////////////////////////////////////


  (StartUndoErr);// �R�}���h�̏�����

  (setvar "CMDECHO" 0)
  (C:de0)

  ;07/02/19 YM ADD-S
  (setq #CG_SeriesDB   CG_SeriesDB)  ;"KJE"
  (setq #CG_DBNAME     CG_DBNAME)    ;"TK_KJE"
  (setq #CG_SeriesCode CG_SeriesCode);"J"
  ;07/02/19 YM ADD-E

  (setq #CG_DEBUG CG_DEBUG);���ޯ�Ӱ��
  (setq CG_DEBUG 0);���ޯ�Ӱ��

 ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;�Ώۼذ�ޏ�� 0/01/10 YM ADD
  (setq #iseri (strcat CG_SYSPATH "LOG\\EXHIN_seri.txt"));�����Ώۼذ�ނ̓ǂݍ���
  (setq #CSV$$ (ReadCSVFile #iseri))
  ;�擪��";"���������珜��
  (setq #dum$$ nil)
  (foreach #CSV$ #CSV$$
    (setq #MDB (nth 0 #CSV$))
    (setq #seri (nth 1 #CSV$))
    (if (= ";" (substr #MDB 1 1))
      nil
      ;else
      (progn
        (setq #dum$$ (append #dum$$ (list (list #MDB #seri))))
      )
    );_if
  );foreach
  (setq #seri$$ #dum$$)
  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  (setq #ifile (strcat CG_SYSPATH "LOG\\EXHIN.txt"));�����Ώەi�Ԃ̓ǂݍ���
  (setq #CSV$$ (ReadCSVFile #ifile))
  (setq #hinban$ (mapcar 'car #CSV$$));�����Ώەi��ؽ�

  (setq #ofile  (strcat CG_SYSPATH "LOG\\kekka.txt"));�������ʏo��̧��
  (setq #fil (open #ofile "W" ))

  (if (= nil #fil)
    (progn
      (CFAlertErr (strcat "kekka.txt ���J���܂���B���Ă�������"))
      (quit)
    )
  );_if


  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));���t
  (princ #date_time #fil ) ; ���t��������

  (princ "\n" #fil)
  (princ (strcat "\n-------------") #fil)
  (princ (strcat "\n�i�ԑ��݊m�F ") #fil)
  (princ (strcat "\n-------------") #fil)
  (princ "\n" #fil)

  (setq #kekka$$ nil);���ʊi�[ؽ�

  (foreach #seri$ #seri$$ ; �e�ذ�ނł�loop
    (setq CG_SeriesDB (nth 0 #seri$))
    (setq CG_DBNAME   (nth 0 #seri$))
    (setq CG_SeriesCode (nth 1 #seri$))
    (setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))

    ;DB�ڑ��ł��Ȃ��Ȃ�����Đڑ�
    (if (= nil CG_DBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
      )
    );_if

    ;DB�ڑ��ł��Ȃ��Ȃ�����Đڑ�
    (if (= nil CG_CDBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
      )
    );_if

    (###EXE)

  );_if

  ;���ʏo��
  (foreach #hinban #hinban$
    (princ (strcat "\n�i��=" #hinban ":") #fil)
    (princ (strcat "\n     /�K�w/�i�Ԋ�{/�i�Ԑ}�`/�i��OP(�i��)/�i��OP(OP�i��)/�i�ԍŏI/") #fil)
    (princ (strcat "\n") #fil)
    (foreach #kekka$ #kekka$$
      (if (= #hinban (car #kekka$))
        (princ (strcat "\n" (nth 1 #kekka$) "  " (nth 2 #kekka$) "  " (nth 3 #kekka$) "  " (nth 4 #kekka$) "  "
											 			(nth 5 #kekka$) "  " (nth 6 #kekka$) "  " (nth 7 #kekka$)) #fil)
;;;(list #hinban CG_DBNAME #kekka1 #kekka2 #kekka3 #kekka4 #kekka44 #kekka5)
      );_if
    )
    (princ (strcat "\n----------------------------------------------------------") #fil)
  )



;;;  ;DB�ڑ�,���ޯ�Ӱ�ނ�߂�
;;;  (setq CG_DEBUG #CG_DEBUG);���ޯ�Ӱ��
;;;
;;;  (setq CG_SeriesDB   #CG_SeriesDB)  ;"KJE"
;;;  (setq CG_DBNAME     #CG_DBNAME)    ;"TK_KJE"
;;;  (setq CG_SeriesCode #CG_SeriesCode);"J"
;;;
;;;  (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
;;;  (if (= nil CG_DBSESSION)
;;;    (progn
;;;        (arxunload "asilisp16.arx")
;;;        (arxload "asilisp16.arx")
;;;      (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
;;;    )
;;;  );_if


  (setq *error* nil)
  (if #fil (close #fil))

  (startapp "notepad.exe" #ofile)

  (princ)
);C:EXhinban


;;;<HOM>*************************************************************************
;;; <�֐���>     : C:HinbanLast_GAScheck
;;; <�����T�v>   : �i�ԍŏI�K�X��t�����R�[�h�o�^�󋵃`�F�b�N
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 07/10/16 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun C:HinbanLast_GAScheck (
  /
	#CG_DBNAME #CG_DEBUG #CG_SERIESCODE #CG_SERIESDB #CSV$$ #DATE_TIME #DUM$$
	#FIL #ISERI #KEKKA$$ #MDB #OFILE #SERI #SERI$$
  )

    ;;;**********************************************************************
    ;;; ٰ�ߏ���
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#HINBAN$ #QRY_BASE$$ #QRY_LAST$$
      )

      ;�i�Ԋ�{����(210)
      (setq #qry_base$$
        (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
          (list
            (list "���iCODE" "210" 'INT)
          )
        )
      )
			(setq #hinban$ nil)
			(foreach #qry_base$ #qry_base$$
				(setq #hinban$ (append #hinban$ (list (car #qry_base$))))
			)

      ;�i�Ԋ�{����(113)
      (setq #qry_base$$
        (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
          (list
            (list "���iCODE" "113" 'INT)
            (list "�W�J�^�C�v" "2" 'INT)
          )
        )
      )
			(setq #dum$ nil)
			(foreach #qry_base$ #qry_base$$
				(setq #dum$ (append #dum$ (list (car #qry_base$))))
			)
			(setq #hinban$ (append #hinban$ #dum$))
			
      ;�i�ԍŏI����
			(foreach #hinban #hinban$
        (setq #qry_LAST$$
          (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
            (list
              (list "�i�Ԗ���" #hinban 'STR)
            )
          )
        )
				(princ (strcat "\n" #hinban "," (itoa (length #qry_LAST$$))) #fil);�o��
			)
      (princ)
    );###EXE
    ;/////////////////////////////////////////////////////////////////////////////


  (StartUndoErr);// �R�}���h�̏�����

  (setvar "CMDECHO" 0)
  (C:de0)

  ;07/02/19 YM ADD-S
  (setq #CG_SeriesDB   CG_SeriesDB)  ;"KJE"
  (setq #CG_DBNAME     CG_DBNAME)    ;"TK_KJE"
  (setq #CG_SeriesCode CG_SeriesCode);"J"
  ;07/02/19 YM ADD-E

  (setq #CG_DEBUG CG_DEBUG);���ޯ�Ӱ��
  (setq CG_DEBUG 0);���ޯ�Ӱ��

 ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;�Ώۼذ�ޏ�� 0/01/10 YM ADD
  (setq #iseri (strcat CG_SYSPATH "LOG\\LASTHIN_seri.txt"));�����Ώۼذ�ނ̓ǂݍ���
  (setq #CSV$$ (ReadCSVFile #iseri))
  ;�擪��";"���������珜��
  (setq #dum$$ nil)
  (foreach #CSV$ #CSV$$
    (setq #MDB (nth 0 #CSV$))
    (setq #seri (nth 1 #CSV$))
    (if (= ";" (substr #MDB 1 1))
      nil
      ;else
      (progn
        (setq #dum$$ (append #dum$$ (list (list #MDB #seri))))
      )
    );_if
  );foreach
  (setq #seri$$ #dum$$)
  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  (setq #ofile  (strcat CG_SYSPATH "LOG\\LASTkekka.txt"));�������ʏo��̧��
  (setq #fil (open #ofile "W" ))

  (if (= nil #fil)
    (progn
      (CFAlertErr (strcat "LASTkekka.txt ���J���܂���B���Ă�������"))
      (quit)
    )
  );_if


;;;  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));���t
;;;  (princ #date_time #fil ) ; ���t��������

  (princ "\n" #fil)

  (setq #kekka$$ nil);���ʊi�[ؽ�

  (foreach #seri$ #seri$$ ; �e�ذ�ނł�loop
    (setq CG_SeriesDB (nth 0 #seri$))
    (setq CG_DBNAME   (nth 0 #seri$))
    (setq CG_SeriesCode (nth 1 #seri$))
    (setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))

    ;DB�ڑ��ł��Ȃ��Ȃ�����Đڑ�
    (if (= nil CG_DBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
      )
    );_if

    ;DB�ڑ��ł��Ȃ��Ȃ�����Đڑ�
    (if (= nil CG_CDBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
      )
    );_if

		(princ (strcat "\n���ذ��," CG_DBNAME) #fil)
    (###EXE)

  );_if

  (setq *error* nil)
  (if #fil (close #fil))

  (startapp "notepad.exe" #ofile)

  (princ)
);C:HinbanLast_GAScheck

;;;<HOM>*************************************************************************
;;; <�֐���>     : CHK_HAIBAN
;;; <�����T�v>   : �p�ŕi���ǂ����`�F�b�N(�K�w,�i�Ԋ�{�̑��݊m�F)
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 07/10/16 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun CHK_HAIBAN (
	&hinban
  /
	#HINBAN #KAI$$ #KEKKA1 #KEKKA2 #KEKKAC #QRY1$$ #QRY2$$ #QRY_C$$ #RET #UPID #UPID_FLG #UPID_UPKAISO
  )

  ;�K�w����
  (setq #qry1$$
    (CFGetDBSQLRec CG_DBSESSION (strcat "�K�w" CG_SeriesCode)
      (list
        (list "�K�w����" &hinban 'STR)
      )
    )
  )

  (if #qry1$$
    (progn
      (setq #UPid (nth 1 (car #qry1$$)));1�߂�ں��ނ̏�ʊK�wID
      (if (> 0 #UPid)
        (setq #UPid_flg -1)
        ;else
        (progn ;��ʊK�wID>0�ł��K�w̫��ގ��̂̏�ʊK�wID�𒲂ׂ�
          ;��ʊK�w�̏�ʊK�wID���擾
          (setq #kai$$
            (CFGetDBSQLRec CG_DBSESSION (strcat "�K�w" CG_SeriesCode)
              (list
                (list "�K�wID" (itoa (fix #UPid)) 'INT)
              )
            )
          )
          (setq #upid_upkaiso (nth 1 (car #kai$$)))
          (if (> 0 #upid_upkaiso)
            (setq #UPid_flg -1)
            ;else
            (setq #UPid_flg 1)
          );_if
        )
      );_if
    )
  );_if

  (if #qry1$$
    (progn
      (if (> 0 #UPid_flg)
        (setq #kekka1 "��");��ʊK�wID��ϲŽ
        ;else
        (setq #kekka1 "��");��ʊK�wID����׽
      );_if
    )
    ;else
    (setq #kekka1 "�~")
  );_if


  ;���ʊK�w����
  (setq #qry_C$$
    (CFGetDBSQLRec CG_CDBSESSION "�K�w"
      (list
        (list "�K�w����" &hinban 'STR)
      )
    )
  )

  (if #qry_C$$
    (progn
      (setq #UPid (nth 1 (car #qry_C$$)));1�߂�ں��ނ̏�ʊK�wID
      (if (> 0 #UPid)
        (setq #UPid_flg -1)
        ;else
        (progn ;��ʊK�wID>0�ł��K�w̫��ގ��̂̏�ʊK�wID�𒲂ׂ�
          ;��ʊK�w�̏�ʊK�wID���擾
          (setq #kai$$
            (CFGetDBSQLRec CG_CDBSESSION "�K�w"
              (list
                (list "�K�wID" (itoa (fix #UPid)) 'INT)
              )
            )
          )
          (setq #upid_upkaiso (nth 1 (car #kai$$)))
          (if (> 0 #upid_upkaiso)
            (setq #UPid_flg -1)
            ;else
            (setq #UPid_flg 1)
          );_if
        )
      );_if
    )
  );_if

  (if #qry_C$$
    (progn
      (if (> 0 #UPid_flg)
        (setq #kekkaC "��");��ʊK�wID��ϲŽ
        ;else
        (setq #kekkaC "��");��ʊK�wID����׽
      );_if
    )
    ;else
    (setq #kekkaC "�~")
  );_if


  ;�i�Ԋ�{����
  (setq #qry2$$
    (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
      (list
        (list "�i�Ԗ���" &hinban 'STR)
      )
    )
  )

  (if #qry2$$
    (setq #kekka2 "��")
    ;else
    (setq #kekka2 "�~")
  );_if

	(if (and #qry2$$ (or (= #kekka1 "��")(= #kekkaC "��")))
		(setq #ret T)
		(setq #ret nil)
	);_if

	#ret
);CHK_HAIBAN

;;;<HOM>*************************************************************************
;;; <�֐���>     : C:HinbanLast_KakakuCheck
;;; <�����T�v>   : �i�ԍŏI���z�`�F�b�N
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 07/10/16 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun C:HinbanLast_KakakuCheck (
  /
	#CG_DBNAME #CG_DEBUG #CG_SERIESCODE #CG_SERIESDB #CSV$$ #DATE_TIME #DUM$$
	#FIL #ISERI #KEKKA$$ #MDB #OFILE #SERI #SERI$$
  )

    ;;;**********************************************************************
    ;;; ٰ�ߏ���
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#HINBAN$ #QRY_BASE$$ #QRY_LAST$$ #rec$$
			#BASE_YEN #BASE_YEN2 #DRKEY #GSKEY #HINBAN #LR #QRY_SERI$$ #SERI_YEN #SERI_YEN2 #YEN #YEN2
      )
			;�i�ԍŏI����
			(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �i�ԍŏI")))

			(foreach #rec$ #rec$$
				(setq #hinban (nth  0 #rec$))

				;�p�Ń`�F�b�N(���Ԃ�������)
				(setq #ret (CHK_HAIBAN #hinban))

				(if #ret
					(progn ;�p�ŕi�łȂ��Ƃ�
						
						(setq #LR     (nth  1 #rec$))
						(setq #DRkey  (nth  3 #rec$))
						(setq #GSkey  (nth  7 #rec$))
						(setq #YEN    (nth 13 #rec$))
						(setq #YEN2   (nth 14 #rec$))

						(if #DRkey
							(progn
					      ;�i�ԃV������
					      (setq #qry_SERI$$
					        (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
					          (list
					            (list "�i�Ԗ���"   #hinban 'STR)
					            (list "LR�敪"     #LR     'STR)
					            (list "���V���L��" #DRkey  'STR)
					          )
					        )
					      )
								(if (and #qry_SERI$$ (= (length #qry_SERI$$) 1))
									(progn
										(setq #Seri_YEN  (nth 8 (car #qry_SERI$$)))
										(setq #Seri_YEN2 (nth 9 (car #qry_SERI$$)))
										(if (or (/= #Seri_YEN #YEN)(/= #Seri_YEN2 #YEN2))
											(if (and (/= #Seri_YEN 0.0)(/= #Seri_YEN2 0.0))
												(princ (strcat "\n" #hinban "," #LR "," #DRkey "[�i�ԃV��][�i�ԍŏI]�ŉ��i����v���Ȃ�") #fil);�o��
											);_if
										);_if
									)
									(progn
										(princ (strcat "\n" #hinban "," #LR "," #DRkey "��[�i�ԃV��]�ɑ��݂��Ȃ�") #fil);�o��
									)
								);_if
							)
						);_if


						(if #GSkey
							(progn
					      ;�i�Ԋ�{����
					      (setq #qry_BASE$$
					        (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
					          (list
					            (list "�i�Ԗ���"   #hinban 'STR)
					          )
					        )
					      )
								(if (and #qry_BASE$$ (= (length #qry_BASE$$) 1))
									(progn
										(setq #BASE_YEN  (nth 14 (car #qry_BASE$$)))
										(setq #BASE_YEN2 (nth 15 (car #qry_BASE$$)))
										(if (or (/= #BASE_YEN #YEN)(/= #BASE_YEN2 #YEN2))
											(princ (strcat "\n" #hinban "," #LR "," #GSkey "[�i�Ԋ�{][�i�ԍŏI]�ŉ��i����v���Ȃ�") #fil);�o��
										);_if
									)
									(progn
										(princ (strcat "\n" #hinban "," #LR "," #GSkey "��[�i�Ԋ�{]�ɑ��݂��Ȃ�") #fil);�o��
									)
								);_if
							)
						);_if

					)
				);_if
			);foreach

      (princ)
    );###EXE
    ;/////////////////////////////////////////////////////////////////////////////


  (StartUndoErr);// �R�}���h�̏�����

  (setvar "CMDECHO" 0)
  (C:de0)

  ;07/02/19 YM ADD-S
  (setq #CG_SeriesDB   CG_SeriesDB)  ;"KJE"
  (setq #CG_DBNAME     CG_DBNAME)    ;"TK_KJE"
  (setq #CG_SeriesCode CG_SeriesCode);"J"
  ;07/02/19 YM ADD-E

  (setq #CG_DEBUG CG_DEBUG);���ޯ�Ӱ��
  (setq CG_DEBUG 0);���ޯ�Ӱ��

 ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;�Ώۼذ�ޏ�� 0/01/10 YM ADD
  (setq #iseri (strcat CG_SYSPATH "LOG\\LAST_KAKAKU_seri.txt"));�����Ώۼذ�ނ̓ǂݍ���
  (setq #CSV$$ (ReadCSVFile #iseri))
  ;�擪��";"���������珜��
  (setq #dum$$ nil)
  (foreach #CSV$ #CSV$$
    (setq #MDB (nth 0 #CSV$))
    (setq #seri (nth 1 #CSV$))
    (if (= ";" (substr #MDB 1 1))
      nil
      ;else
      (progn
        (setq #dum$$ (append #dum$$ (list (list #MDB #seri))))
      )
    );_if
  );foreach
  (setq #seri$$ #dum$$)
  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  (setq #ofile  (strcat CG_SYSPATH "LOG\\LAST_KAKAKU_kekka.txt"));�������ʏo��̧��
  (setq #fil (open #ofile "W" ))

  (if (= nil #fil)
    (progn
      (CFAlertErr (strcat "LAST_KAKAKU_kekka.txt ���J���܂���B���Ă�������"))
      (quit)
    )
  );_if


;;;  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));���t
;;;  (princ #date_time #fil ) ; ���t��������

  (princ "\n" #fil)

  (setq #kekka$$ nil);���ʊi�[ؽ�

  (foreach #seri$ #seri$$ ; �e�ذ�ނł�loop
    (setq CG_SeriesDB (nth 0 #seri$))
    (setq CG_DBNAME   (nth 0 #seri$))
    (setq CG_SeriesCode (nth 1 #seri$))
    (setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))

    ;DB�ڑ��ł��Ȃ��Ȃ�����Đڑ�
    (if (= nil CG_DBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
      )
    );_if

    ;DB�ڑ��ł��Ȃ��Ȃ�����Đڑ�
    (if (= nil CG_CDBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
      )
    );_if

		(princ (strcat "\n���ذ��," CG_DBNAME) #fil)
    (###EXE)

  );_if

  (setq *error* nil)
  (if #fil (close #fil))

  (startapp "notepad.exe" #ofile)

  (princ)
);C:HinbanLast_KakakuCheck



;;;<HOM>*************************************************************************
;;; <�֐���>     : C:EXbikou
;;; <�����T�v>   : ���l���ɕ������o�͂�����̂�ؽı���
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 07/10/19 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun C:EXbikou (
  /
	#CG_DBNAME #CG_DEBUG #CG_SERIESCODE #CG_SERIESDB #CSV$$ #DUM$$ #FIL #ISERI
	#MDB #OFILE #SERI #SERI$$
  )

    ;;;**********************************************************************
    ;;; ٰ�ߏ���
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#HINBAN #ID #QRY$ #REC$$ #SIYOU
      )
			(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "�i�Ԋ�{")))
			(foreach #rec$ #rec$$
				(setq #hinban (nth 0 #rec$))
				(setq #id (nth 7 #rec$))
				(if (equal #id 0.0 0.001)
					nil
					;else
					(progn
						(setq #sID (itoa (fix (+ #id 0.001)))) 
						;�d�l���̌���
					  (setq #qry$	(car
						  (CFGetDBSQLRec CG_CDBSESSION "�d�l����"
						    (list
									(list "�d�lID" #sID 'INT)
						    )
						  ))
						)
						(if (= nil #qry$)
							(setq #siyou "")
							;else
							(setq #siyou (nth 1 #qry$))
						);_if
						(if (= nil #siyou)(setq #siyou ""))
						(princ (strcat "\n" #hinban "," #siyou) #fil)
					)

				);_if
			);foreach
      (princ)
    );###EXE
    ;/////////////////////////////////////////////////////////////////////////////


  (StartUndoErr);// �R�}���h�̏�����

  (setvar "CMDECHO" 0)
  (C:de0)

  ;07/02/19 YM ADD-S
  (setq #CG_SeriesDB   CG_SeriesDB)  ;"KJE"
  (setq #CG_DBNAME     CG_DBNAME)    ;"TK_KJE"
  (setq #CG_SeriesCode CG_SeriesCode);"J"
  ;07/02/19 YM ADD-E

  (setq #CG_DEBUG CG_DEBUG);���ޯ�Ӱ��
  (setq CG_DEBUG 0);���ޯ�Ӱ��

 ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;�Ώۼذ�ޏ�� 0/01/10 YM ADD
  (setq #iseri (strcat CG_SYSPATH "LOG\\BIKOU_SERI.txt"));�����Ώۼذ�ނ̓ǂݍ���
  (setq #CSV$$ (ReadCSVFile #iseri))
  ;�擪��";"���������珜��
  (setq #dum$$ nil)
  (foreach #CSV$ #CSV$$
    (setq #MDB (nth 0 #CSV$))
    (setq #seri (nth 1 #CSV$))
    (if (= ";" (substr #MDB 1 1))
      nil
      ;else
      (progn
        (setq #dum$$ (append #dum$$ (list (list #MDB #seri))))
      )
    );_if
  );foreach
  (setq #seri$$ #dum$$)
  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  (setq #ofile  (strcat CG_SYSPATH "LOG\\Bikou_kekka.txt"));�������ʏo��̧��
  (setq #fil (open #ofile "W" ))

  (princ "\n" #fil)


  (foreach #seri$ #seri$$ ; �e�ذ�ނł�loop
    (setq CG_SeriesDB (nth 0 #seri$))
    (setq CG_DBNAME   (nth 0 #seri$))
    (setq CG_SeriesCode (nth 1 #seri$))
    (setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))

    ;DB�ڑ��ł��Ȃ��Ȃ�����Đڑ�
    (if (= nil CG_DBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
      )
    );_if

    ;DB�ڑ��ł��Ȃ��Ȃ�����Đڑ�
    (if (= nil CG_CDBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
      )
    );_if

		(princ (strcat "\n���ذ��," CG_DBNAME) #fil)
    (###EXE)

  );_if

  (setq *error* nil)
  (if #fil (close #fil))

  (startapp "notepad.exe" #ofile)

  (princ)
);C:EXbikou


;;;<HOM>*************************************************************************
;;; <�֐���>     : C:DoorZumen
;;; <�����T�v>   : ���K�v�����m�F
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 07/10/16 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun C:DoorZumen (
  /
	#FIL #OFILE
  )
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#DR_ID #HINBAN #LR #REC$$ #RET
      )

			;�i�ԃV������
			(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �i�ԃV��")))

			(foreach #rec$ #rec$$
				(setq #hinban (nth  0 #rec$))
				;�p�Ń`�F�b�N(���Ԃ�������)
				(setq #ret (CHK_HAIBAN #hinban))

				(if #ret
					(progn ;�p�ŕi�łȂ��Ƃ�
						(setq #LR     (nth  1 #rec$))
						(setq #DR_id  (nth  5 #rec$))
						;�o��
						(if (and #DR_id (/= #DR_id ""))
							(princ (strcat "\n" #hinban "," #LR "," #DR_id) #fil)
						);_if
					)
				);_if
			);foreach

      (princ)
    );###EXE
    ;/////////////////////////////////////////////////////////////////////////////


  (StartUndoErr);// �R�}���h�̏�����
  (setvar "CMDECHO" 0)
  (C:de0)
  (setq #ofile  (strcat CG_SYSPATH "LOG\\���}�`����_kekka.csv"));�������ʏo��̧��
  (setq #fil (open #ofile "W" ))
  (princ "\n" #fil)
	(princ (strcat "\n���ذ��," CG_DBNAME) #fil)
  (###EXE)

  (setq *error* nil)
  (if #fil (close #fil))
  (startapp "notepad.exe" #ofile)
  (princ)
);C:DoorZumen


;;;<HOM>*************************************************************************
;;; <�֐���>    : C:MDBCHECK
;;; <�����T�v>  :�V����ިmdb�s��������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2011/03/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:MDBCHECK (
  /
	#CG_DEBUG #DATE_TIME #DBNAME #DUM$$ #FIL #FLG #HIN #HIN$ #HIN1 #HIN2 #HINBAN
	#HIN_KAKKO$ #KIHON$$ #KIHON_HIN #KIHON_HIN$ #KIHON_KOSU #KIHON_LR #KOSU #LAST_L$$
	#LAST_R$$ #LAST_Z$$ #LIS$ #N #NG-Z #NUM #REC$ #REC$$ #TABLE$$ #ZUKEIID #ZUKEIID$
	#FIELD1 #FIELD2 #LR
  )

    ;;;**********************************************************************
    ;;; ؽĂ̏d�����R�[�h������
    ;;; 05/06/01 YM
    ;;;**********************************************************************
    (defun ##delREC0 (
      &lis$ ; #hin$��ؽČ`��
      /
      #DUM$ #HIN #HIN$ #LIS$
      )
      (setq #dum$ nil)
      (foreach #lis &lis$
        (if (member #lis #dum$)
          nil
          ;else
          (setq #dum$ (cons #lis #dum$))
        );_if
      )
      #dum$
    );##delREC0


    ;;;**********************************************************************
    ;;; ;�i�Ԋ�{�̑�������
    ;;; 05/06/14 YM
    ;;;**********************************************************************
    (defun ##CheckKIHON_REC (
      &hin$   ; �i�Ԃ�ؽČ`��
      &DBNAME ; DB��
      /
      )
      (foreach #hin &hin$
        (if (member #hin #kihon_hin$)
          nil ; OK
          ;else
					(if (= nil (wcmatch #hin "GAS,OBUN,�޽*,���*,�H��*,̰��*,HOOD*,MIRROR*,�����*,�װ*,��������,��������,ֺϸ��,�����ޯ��"))
          	(princ (strcat "\n" ",��,"  &DBNAME ": [�i�Ԋ�{]�ɓo�^���Ȃ�" "," #hin) #fil)
					);_if
        );_if
      );foreach
      (princ)
    );##CheckKIHON_REC



    ;;;**********************************************************************
    ;;; ؽĂ̏d�����R�[�h������
    ;;; 04/12/19 YM
    ;;;**********************************************************************
    (defun ##delREC (
      &lis$ ; (list #hin #LR)��ؽČ`��
      /
      #DUM$ #HIN #HIN$ #LIS$ #RET$
      )
      ;04/11/02 YM ADD-S
      (setq #dum$ nil #hin$ nil)
      (foreach #lis &lis$
        (setq #hin (car #lis))
        (if (member #hin #hin$)
          nil
          ;else
          (setq #dum$ (cons #lis #dum$))
        );_if
        (setq #hin$ (cons #hin #hin$))
      )
      (setq #ret$ #dum$)
      #ret$
    );##delREC

    ;;;**********************************************************************
    ;;; ;�i�Ԑ}�`�̑�������
    ;;; 04/12/19 YM
    ;;;**********************************************************************
    (defun ##CheckREC (
      &lis$   ; (list #hin #LR)��ؽČ`��
      &DBNAME ; DB��
      &FIL    ;̧�َ���
      /
      #HIN #LR #QRY$$ #ZUKEIID
      )
      (foreach #lis &lis$
        (setq #hin (car  #lis))
        (setq #LR  (cadr #lis))

				(if (= nil #hin)
          (CFAlertMsg (strcat "\n�������i��=nil����B" &DBNAME))
					;else
					(progn
		        (if (= nil (wcmatch #hin "L16*,L18*,L19*,L21*,GAS,OBUN,�޽*,���*,�H��*,̰��*,MIRROR*,�����*,�װ*,��������,��������"))
		          (progn
		            (setq #qry$$
		              (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
		                (list
		                  (list "�i�Ԗ���"  #HIN 'STR)
		                  (list "LR�敪"    #LR 'STR)
		                )
		              )
		            )
		            (if (= nil #qry$$)
		              (progn
		                (princ (strcat "\n������ [" &DBNAME "] (�i�Ԑ}�`�ɂȂ�): " "�i�Ԗ���=" #HIN " LR�敪=" #LR ) &FIL);�װ�o��
		              )
		              (progn
		                (setq #zukeiID (nth 6 (car #qry$$)));2008/06/28 OK!
		                (if (or (= #zukeiID "")(= #zukeiID nil))
		                  (princ (strcat "\n������ [" &DBNAME "]: " "���}�`ID�Ȃ�/�i�Ԗ���=" #HIN " LR�敪=" #LR ) &FIL);�װ�o��
		                );_if
		              )
		            );_if
		          )
		        );_if
					)
				);_if
      );foreach
      (princ)
    );##CheckREC


;///////////////////////////////////////////////////////////////////////////////

    ;;;**********************************************************************
    ;;; ;�i�Ԃɽ�߰������S�p()�����邩�ǂ�������
    ;;;**********************************************************************
    (defun ##CheckSpace (
      &hin$ ; �i��ؽ�
      &msg  ; �����Ώ�ð��ُ��
      &fil  ; ̧�َ��ʎq
      /
      #CHR #FIL #FLG #I #STRLEN
      )
      (foreach #hin &hin$
        ;�i�Ԃ�"<>"���O��
        (if (= nil #hin)
          (CFAlertMsg (strcat "\n�������i��=nil����B" &msg))
					;else
					(progn
		        (setq #hin (KP_DelHinbanKakko #hin))

		        ;���p��߰������邩�ǂ���
		        (setq #flg (vl-string-search " " #hin))
		        (if #flg
		          (princ (strcat "\n�������i�Ԗ��̂ɽ�߰����܂�: " &msg "�i��: " #hin) &fil)
		        );_if

		        ;�S�p��߰������邩�ǂ���
		        (setq #flg (vl-string-search "�@" #hin))
		        (if #flg
		          (princ (strcat "\n�������i�Ԗ��̂ɑS�p��߰����܂�: " &msg "�i��: " #hin) &fil)
		        );_if

		        ;�S�p���ʂ����邩�ǂ���
		        (setq #flg (vl-string-search "�i" #hin))
		        (if #flg
		          (princ (strcat "\n�������i�Ԗ��̂ɑS�p���ʂ��܂�: " &msg "�i��: " #hin) &fil)
		        );_if

		        ;�S�p���ʂ����邩�ǂ���
		        (setq #flg (vl-string-search "�j" #hin))
		        (if #flg
		          (princ (strcat "\n�������i�Ԗ��̂ɑS�p���ʂ��܂�: " &msg "�i��: " #hin) &fil)
		        );_if

		        ;�S�p���ꕶ�������邩�ǂ���
		        (setq #flg (vl-string-search "\\" #hin))
		        (if #flg
		          (princ (strcat "\n�������i�Ԗ��̂ɓ��ꕶ�����܂�: " &msg "�i��: " #hin) &fil)
		        );_if
					)
        );_if
      );foreach

      (princ)
    );##CheckSpace

;///////////////////////////////////////////////////////////////////////////////

	; (C:MDBCHECKSK)
	(StartUndoErr);// �R�}���h�̏�����

	(setvar "CMDECHO" 0)
	;���ޯ�Ӱ���׸ނ�ۑ�
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);����

  (setq #fil (open (strcat CG_SYSPATH "LOG\\MDB�s����CHECK_" CG_SeriesDB ".csv") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������

  (princ "\n(C:MDBCHECKSK)����ނɂ������" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesDB) #fil)

  (princ "\n")
  (princ "\n" #fil)

  (setq #kihon$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "�i�Ԋ�{")))

	;�@[�i�Ԋ�{]�����@"%"�t���i�Ԃ�LR����ŁA"%"�Ȃ��i�Ԃ�LR�Ȃ��ɂȂ��Ă��邩�ǂ���
  (princ "\n")
  (princ "\n" #fil)
	(setq #kihon_kosu (length #kihon$$))
  (princ (strcat "\n ----- \"�i�Ԋ�{��ں��ސ�: " (itoa #kihon_kosu) " ��"))
  (princ (strcat "\n ----- \"�i�Ԋ�{��ں��ސ�: " (itoa #kihon_kosu) " ��") #fil)
  (princ "\n")
  (princ "\n" #fil)


  (princ (strcat "\n�@[�i�Ԋ�{][�i�ԍŏI]�����@�J�n"))
  (princ (strcat "\n�@[�i�Ԋ�{][�i�ԍŏI]�����@�J�n") #fil)

;	(CFYesDialog "�@[�i�Ԋ�{][�i�ԍŏI]�������s���܂�")

	;�������@�i�Ԋ�{��ٰ�߁@������
  (setq #hin$ nil)
  (setq #hin_kakko$ nil)
  (setq #kihon_hin$ nil)
	(setq #kosu (length #kihon$$))
	(setq #n 1)
  (foreach #kihon$ #kihon$$

    (if (and (/= #n 0)(= 0 (rem #n 500)))
      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
    );_if

    (setq #kihon_hin (nth 0 #kihon$)) ;�i��
    (setq #kihon_LR  (nth 1 #kihon$)) ;LR�L��
    (setq #kihon_skk (nth 3 #kihon$)) ;���iCODE
    (setq #kihon_typ (nth 4 #kihon$)) ;�W�J����
    (setq #kihon_sid (nth 5 #kihon$)) ;�W��ID
		(setq #hin (KP_DelHinbanKakko #kihon_hin));���ʂ͂���

    ;"%"�t������
    (if (vl-string-search "%" #kihon_hin)
      (progn ;"%"����
        (if (equal #kihon_LR 1.0 0.001)
          nil ; OK
          ;else
          (princ (strcat "\n" ",��," "\"%\"�t���i�ԂȂ̂�[�i�Ԋ�{]L/R�L��=1�ł͂Ȃ�" "," #kihon_hin) #fil)
        );_if
      )
      (progn ;"%"�Ȃ�
        (if (equal #kihon_LR 0.0 0.001)
          nil ; OK
          ;else
          (princ (strcat "\n" ",��," "\"%\"�Ȃ��i�ԂȂ̂�[�i�Ԋ�{]L/R�L��=1�ł���" "," #kihon_hin) #fil)
        );_if
      )
    );_if

		
    ;"@"�t������ 2011/03/28 YM ADD-S
    (if (vl-string-search "@" #kihon_hin)
			(progn ;"@"����
        (cond
					((equal #kihon_typ 0.0 0.001)
          	nil ; OK
				 	)
					(T
          	(princ (strcat "\n" ",��," "\"@@\"�t���i�ԂȂ̂�[�i�Ԋ�{]�W�J����=0�ł͂Ȃ�" "," #kihon_hin) #fil)
				 	)
        );_cond
      )
			(progn ;"@"�Ȃ�
        (cond
					((equal #kihon_typ 0.0 0.001)
					 	nil
				 	)
					((equal #kihon_typ 1.0 0.001)
						nil
				 	)
					((equal #kihon_typ 2.0 0.001)
						(cond ;�޽���M�@��
							((equal #kihon_skk 113.0 0.001)
								;����݂̂͂�
								(setq #obun$$ (DBSqlAutoQuery CG_DBSESSION
																(strcat "select �L�� from ����OBUN where �i�Ԗ��� = '" #kihon_hin "'")))
						    (if (= nil #obun$$)
						      (princ (strcat "\n" ",��," "����݂̂͂��Ȃ̂�[����OBUN]��ں��ނ��Ȃ�" "," #kihon_hin) #fil)
						    );_if
						 	)
							((equal #kihon_skk 210.0 0.001)
								;���M�@��̂͂�
								(setq #gas$$ (DBSqlAutoQuery CG_DBSESSION
															 (strcat "select �L�� from ����GAS where �i�Ԗ��� = '" #kihon_hin "'")))
						    (if (= nil #gas$$)
						      (princ (strcat "\n" ",��," "���M�@��̂͂��Ȃ̂�[����GAS]��ں��ނ��Ȃ�"  "," #kihon_hin) #fil)
						    );_if
							)
							(T
								(princ (strcat "\n" ",��," "�W�J����(�޽�킠��)�����������m�F���Ă�������" "," #kihon_hin) #fil)
						 	)
						);_cond
				 	)					
					(T
          	(princ (strcat "\n" ",��," "�W�J���߂����������m�F���Ă�������(��O)" "," #kihon_hin) #fil)
				 	)
        );_cond
      )
    );_if
    ;"@"�t������ 2011/03/28 YM ADD-E







		;[�i�ԍŏI]��������
		(if (member #hin #hin$)
			(progn
				nil ;2��ڈȍ~�d���������Ȃ�
			)
			(progn
				(setq #LAST_L$$ nil)
				(setq #LAST_R$$ nil)
				(setq #LAST_Z$$ nil)
				(if (equal #kihon_LR 1.0 0.001);L/R����
					(progn
				    (setq #LAST_L$$
				      (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
				        (list
				          (list "�i�Ԗ���"  #hin 'STR)
				          (list "LR�敪"    "L"        'STR)
				        )
				      )
				    )
				    (setq #LAST_R$$
				      (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
				        (list
				          (list "�i�Ԗ���"  #hin 'STR)
				          (list "LR�敪"    "R"        'STR)
				        )
				      )
				    )

				    (if (= nil #LAST_L$$)
				      (princ (strcat "\n" ",��," "L/R�L��=1�Ȃ̂�[�i�ԍŏI]LR�敪=L��ں��ނ��Ȃ�"  "," #hin) #fil)
				    );_if

				    (if (= nil #LAST_R$$)
				      (princ (strcat "\n" ",��," "L/R�L��=1�Ȃ̂�[�i�ԍŏI]LR�敪=R��ں��ނ��Ȃ�" "," #hin) #fil)
				    );_if

					)
					(progn ;L/R�Ȃ�
				    (setq #LAST_Z$$
				      (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
				        (list
				          (list "�i�Ԗ���"  #hin 'STR)
				          (list "LR�敪"    "Z"        'STR)
				        )
				      )
				    )
				    (if (= nil #LAST_Z$$)
				      (princ (strcat "\n" ",��," "L/R�L��=0�Ȃ̂�[�i�ԍŏI]LR�敪=Z��ں��ނ��Ȃ�" "," #hin) #fil)
				    );_if
					)
				);_if
			)
		);_if


		;�ݐ�
		(setq #hin$ (cons #hin #hin$));()�Ȃ��i�ԏ����ς�
		(setq #kihon_hin$ (cons #kihon_hin #kihon_hin$));[�i�Ԋ�{]�S�i�ԗݐ�

		(setq #n (1+ #n))
  );foreach











  (princ "\n")
  (princ "\n" #fil)



  (princ (strcat "\n �A�eð��ٓo�^�i�Ԃ�[�i�Ԋ�{]�ɑ��݂��邩�����@�J�n"))
  (princ (strcat "\n �A�eð��ٓo�^�i�Ԃ�[�i�Ԋ�{]�ɑ��݂��邩�����@�J�n") #fil)


	(setq #unit$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "select ���j�b�g�L�� from SERIES WHERE SERIES���� = '" CG_SeriesDB "'")))
	(setq #unit$ (car #unit$$))
	(setq #unit (car #unit$))

	(cond
		((= #unit "A") ;����
			(setq #table$$
				(list
					(list "SINKCAB�Ǘ�" "�i�Ԗ���" "-")							
					(list "�K���X�p�e�B�V����" "�i�Ԗ���" "LR�敪")
					(list "�K���X�z�u���" "�i�Ԗ���" "-")
					(list "�L�b�`���p�l���E��" "�i�Ԗ���" "LR�敪")
					(list "�V���NOP" "OP�i�Ԗ���" "-")
					(list "�p�l���\��" "�i�Ԗ���" "LR�敪")
					(list "�v���\��" "�i�Ԗ���" "LR�敪")
					(list "�����z�u���" "�i�Ԗ���" "-")
					(list "�W��ID�ϊ�" "�i�Ԗ���" "-")
					(list "�V��t�B��" "�i�Ԗ���" "LR�敪")
					(list "�V�䖋��" "�i�Ԗ���" "LR�敪")
					(list "�����K�i�i" "�i�Ԗ���" "-")
					(list "�i��OP" "�i�Ԗ���" "-")
					(list "�i��OP" "OP�i�Ԗ���" "-")

					(list "����GAS" "�i�Ԗ���" "LR�敪")
					(list "����HOOD" "�i�Ԗ���" "LR�敪")
;;;							(list "����HOOD�\��" "�i�Ԗ���" "LR�敪")
					(list "����OBUN" "�i�Ԗ���" "LR�敪")
					(list "�����p�l���\��" "�i�Ԗ���" "LR�敪")
					(list "����������" "�i�Ԗ���" "LR�敪")
					(list "�����\��" "�i�Ԗ���" "LR�敪")
					(list "��������" "�i�Ԗ���" "LR�敪")
					(list "��������BOX�\��" "�i�Ԗ���" "LR�敪")
					(list "OP�u��" "�Ώەi��" "�Ώەi��LR")
					(list "OP�u��" "�u���i��" "�u���i��LR")
				)
			)
		)
		((= #unit "D") ;���[
			(setq #table$$
				(list
					(list "C�J�E���^�u��" "�i�Ԗ���" "LR�敪")
					(list "�p�l���\��EX" "�i�Ԗ���" "LR�敪")
					(list "�v���\��" "�i�Ԗ���" "LR�敪")
					(list "�V�䖋��D" "�i�Ԗ���" "LR�敪")
					(list "�V�䖋����" "�i�Ԗ���" "LR�敪")							
					(list "OP�u��" "�Ώەi��" "�Ώەi��LR")
					(list "OP�u��" "�u���i��" "�u���i��LR")
				)
			)
		)
		(T
			(setq #table$$ nil)
		)
	);_cond


	(foreach #table$ #table$$
	  (setq #lis$ nil #hin$ nil)
	  (setq #DBNAME (nth 0 #table$))
		(setq #field1  (nth 1 #table$))
		(setq #field2  (nth 2 #table$))

		(if (= #field2 "-")
			(progn
	  		(setq #rec$ (DBSqlAutoQuery CG_DBSESSION (strcat "select DISTINCT " #field1 " from " #DBNAME)))
			)
			(progn
	  		(setq #rec$ (DBSqlAutoQuery CG_DBSESSION (strcat "select DISTINCT " #field1 "," #field2 " from " #DBNAME)))
			)
		);_if

	  (foreach #rec #rec$
	    (setq #hin  (nth 0 #rec))
	    (setq #LR   (nth 1 #rec))
			(if (= #LR nil)
				nil
				;else
				(progn
					;LR�敪�ƕi�Ԃ�"%"�����Ė������Ȃ�����������
					(if (or (= #LR "L")(= #LR "R"))
						(progn ;�i�Ԃ�"%"���Ȃ��Ƃ����Ȃ�
					    (if (vl-string-search "%" #hin)
								nil ;OK
								;else
					      (princ (strcat "\n" ",��," "L/R����Ȃ̂ɕi�Ԃ�%���Ȃ�" "[" #DBNAME "]" "," #hin) #fil)
					    );_if
						)
						(progn ;"Z" �i�Ԃ�"%"������΂�������
					    (if (vl-string-search "%" #hin)
					      (princ (strcat "\n" ",��," "LR�敪=Z�Ȃ̂ɕi�Ԃ�%������" "]" #DBNAME "]" "," #hin) #fil)
								;else
								nil ;OK
					    );_if
						)
					);_if
									
				)
			);_if

	    (setq #hin$ (cons #hin #hin$))
	  )

	  ;��߰��Ȃ�����
	  (##CheckSpace #hin$ (strcat "[" #DBNAME "] ") #fil)


	  (##CheckKIHON_REC #hin$ (strcat "[" #DBNAME "]"))

	  (princ "\n")
	  (princ "\n" #fil)
	);(foreach



	;���ޯ�Ӱ���׸ނ�߂�
	(setq CG_DEBUG #CG_DEBUG)

  (princ (strcat "\n---�I��") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\MDB�s����CHECK_" CG_SeriesDB ".csv"))
  (princ)
);C:MDBCHECK



;;;<HOM>*************************************************************************
;;; <�֐���>    : C:LASTHINBANCHECK1
;;; <�����T�v>  :�V����ި�i�ԍŏI���F�֌W�ް���������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2011/03/28 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:LASTHINBANCHECK1 (
  /
	#CG_DEBUG #DATE_TIME #DR_COLO #DR_HIKI #DR_SERI #FIL #HIKITE$$ #HIN #KIHON$$
	#KIHON_HIN #KIHON_KOSU #KIHON_LR #KIHON_SKK #KIHON_TYP #KOSU #LAST_L$$ #LAST_R$$
	#LAST_Z$$ #N
  )
	; (C:MDBCHECKSK)
	(StartUndoErr);// �R�}���h�̏�����

	(setvar "CMDECHO" 0)
	;���ޯ�Ӱ���׸ނ�ۑ�
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);����

  (setq #fil (open (strcat CG_SYSPATH "LOG\\�i�ԍŏI���F�֌WCHECK_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������

  (princ "\n(C:LASTHINBANCHECK)����ނɂ������" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesDB) #fil)

  (princ "\n")
  (princ "\n" #fil)

  (setq #kihon$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �i�Ԗ���,LR�L��,���iCODE,�W�J�^�C�v from " "�i�Ԋ�{")))

	(setq #kihon_kosu (length #kihon$$))
  (princ (strcat "\n ----- \"�i�Ԋ�{��ں��ސ�: " (itoa #kihon_kosu) " ��"))
  (princ (strcat "\n ----- \"�i�Ԋ�{��ں��ސ�: " (itoa #kihon_kosu) " ��") #fil)
  (princ "\n")
  (princ "\n" #fil)

  (princ (strcat "\n ----- [�i�ԍŏI]���F�֌W�ް����������@�J�n"))
  (princ (strcat "\n ----- [�i�ԍŏI]���F�֌W�ް����������@�J�n") #fil)
  (princ "\n")
  (princ "\n" #fil)



	;[����Ǘ�]���R�[�h���J��Ԃ���[�i�ԍŏI]����������
	(setq #HIKITE$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select ���V���L��,���J���L��,����L�� from ����Ǘ�")))

	;�������@�i�Ԋ�{��ٰ�߁@������
	(setq #kosu (length #kihon$$))
	(setq #n 1)
  (foreach #kihon$ #kihon$$
    (if (and (/= #n 0)(= 0 (rem #n 50)))
      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
    );_if

    (setq #kihon_hin (nth 0 #kihon$)) ;�i��
    (setq #kihon_LR  (nth 1 #kihon$)) ;LR�L��
    (setq #kihon_skk (nth 2 #kihon$)) ;���iCODE
    (setq #kihon_typ (nth 3 #kihon$)) ;�W�J�^�C�v

    ;()���O��
    (setq #hin (KP_DelHinbanKakko #kihon_hin))

		;�W�J�^�C�v=0���Ώ�
		(if (equal #kihon_typ 0.0 0.001)
			(progn ;�W�J�^�C�v=0 @@�t���i��
				;@@��������
		    (if (vl-string-search "@" #kihon_hin)
					(progn ;"@"����

						(foreach #HIKITE$ #HIKITE$$
							(setq #dr_seri (nth 0 #HIKITE$))
							(setq #dr_colo (nth 1 #HIKITE$))
							(setq #dr_hiki (nth 2 #HIKITE$))

							(setq #LAST_L$$ nil)
							(setq #LAST_R$$ nil)
							(setq #LAST_Z$$ nil)

					    (if (vl-string-search "#" #kihon_hin)
								(progn ;"#"���� ----------------------------------------------

									(if (equal #kihon_LR 1.0 0.001)
										(progn
									    (setq #LAST_L$$
									      (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
									        (list
									          (list "�i�Ԗ���"  #hin 'STR)
									          (list "LR�敪"    "L"  'STR)
									          (list "���V���L��"  #dr_seri  'STR)
									          (list "���J���L��"  #dr_colo  'STR)
									          (list "����L��"    #dr_hiki  'STR)
									        )
									      )
									    )
									    (setq #LAST_R$$
									      (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
									        (list
									          (list "�i�Ԗ���"  #hin 'STR)
									          (list "LR�敪"    "R"  'STR)
									          (list "���V���L��"  #dr_seri  'STR)
									          (list "���J���L��"  #dr_colo  'STR)
									          (list "����L��"    #dr_hiki  'STR)
									        )
									      )
									    )
									    (if (= nil #LAST_L$$)
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ��Ȃ� / �i��,LR,���,���,����: " #hin "," "L," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if
									    (if (= nil #LAST_R$$)
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ��Ȃ� / �i��,LR,���,���,����: " #hin "," "R," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if

									    (if (< 1 (length #LAST_L$$))
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ����� / �i��,LR,���,���,����: " #hin "," "L," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if
									    (if (< 1 (length #LAST_R$$))
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ����� / �i��,LR,���,���,����: " #hin "," "R," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if

										)
										(progn ;L/R�Ȃ�
									    (setq #LAST_Z$$
									      (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
									        (list
									          (list "�i�Ԗ���"  #hin 'STR)
									          (list "LR�敪"    "Z"  'STR)
									          (list "���V���L��"  #dr_seri  'STR)
									          (list "���J���L��"  #dr_colo  'STR)
									          (list "����L��"    #dr_hiki  'STR)
									        )
									      )
									    )
									    (if (= nil #LAST_Z$$)
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ��Ȃ� / �i��,LR,���,���,����: " #hin "," "Z," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if

									    (if (< 1 (length #LAST_Z$$))
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ����� / �i��,LR,���,���,����: " #hin "," "Z," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if

										)
									);_if


								)
								(progn ;"#"�Ȃ� ----------------------------------------------

									(if (equal #kihon_LR 1.0 0.001)
										(progn
											;�����KEY�ɂ��Ȃ�
									    (setq #LAST_L$$
									      (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
									        (list
									          (list "�i�Ԗ���"  #hin 'STR)
									          (list "LR�敪"    "L"  'STR)
									          (list "���V���L��"  #dr_seri  'STR)
									          (list "���J���L��"  #dr_colo  'STR)
									        )
									      )
									    )
									    (setq #LAST_R$$
									      (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
									        (list
									          (list "�i�Ԗ���"  #hin 'STR)
									          (list "LR�敪"    "R"  'STR)
									          (list "���V���L��"  #dr_seri  'STR)
									          (list "���J���L��"  #dr_colo  'STR)
									        )
									      )
									    )
									    (if (= nil #LAST_L$$)
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ��Ȃ� / �i��,LR,���,���: " #hin "," "L," #dr_seri "," #dr_colo) #fil)
									    );_if
									    (if (= nil #LAST_R$$)
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ��Ȃ� / �i��,LR,���,���: " #hin "," "R," #dr_seri "," #dr_colo) #fil)
									    );_if

									    (if (< 1 (length #LAST_L$$))
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ����� / �i��,LR,���,���: " #hin "," "L," #dr_seri "," #dr_colo) #fil)
									    );_if
									    (if (< 1 (length #LAST_R$$))
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ����� / �i��,LR,���,���: " #hin "," "R," #dr_seri "," #dr_colo) #fil)
									    );_if

										)
										(progn ;L/R�Ȃ�
									    (setq #LAST_Z$$
									      (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
									        (list
									          (list "�i�Ԗ���"  #hin 'STR)
									          (list "LR�敪"    "Z"  'STR)
									          (list "���V���L��"  #dr_seri  'STR)
									          (list "���J���L��"  #dr_colo  'STR)
									        )
									      )
									    )
									    (if (= nil #LAST_Z$$)
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ��Ȃ� / �i��,LR,���,���: " #hin "," "Z," #dr_seri "," #dr_colo) #fil)
									    );_if

									    (if (< 1 (length #LAST_Z$$))
									      (princ (strcat "\n������[�i�ԍŏI]��ں��ނ����� / �i��,LR,���,���: " #hin "," "Z," #dr_seri "," #dr_colo) #fil)
									    );_if

										)
									);_if


								)
							);_if

						);foreach

					)
					(progn ;"@"�Ȃ�
						(princ (strcat "\n������[�i�Ԋ�{]�W�J����=0�Ȃ̂ɕi�Ԗ��̂�@@���Ȃ�: " #kihon_hin) #fil)
					)
				);_if

			)
		);_if

		(setq #n (1+ #n))
  );foreach

  (princ (strcat "\n ----- [�i�ԍŏI]���F�֌W�ް����������@�I��"))
  (princ (strcat "\n ----- [�i�ԍŏI]���F�֌W�ް����������@�I��") #fil)
  (princ "\n")
  (princ "\n" #fil)

	;���ޯ�Ӱ���׸ނ�߂�
	(setq CG_DEBUG #CG_DEBUG)

  (princ (strcat "\n---�I��") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\�i�ԍŏI���F�֌WCHECK_" CG_SeriesDB ".txt"))
  (princ)
);C:LASTHINBANCHECK1


;;;<HOM>*************************************************************************
;;; <�֐���>    : C:LASTHINBANCHECK2
;;; <�����T�v>  :�V����ި�i�Ԗ���-�ŏI�i��ϯ�ݸ�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2011/03/28 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:LASTHINBANCHECK2 (
  /
	#CG_DEBUG #DATE_TIME #DR_COLO #DR_HIKI #DR_SERI #FIL #HIN #KOSU #LAST #LAST$$ #N #NUM
  )
	(StartUndoErr);// �R�}���h�̏�����

	(setvar "CMDECHO" 0)
	;���ޯ�Ӱ���׸ނ�ۑ�
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);����

  (setq #fil (open (strcat CG_SYSPATH "LOG\\�ŏI�i�ԃ}�b�`���OCHECK_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������

  (princ "\n(C:LASTHINBANCHECK)����ނɂ������" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesDB) #fil)

  (princ "\n")
  (princ "\n" #fil)

  (setq #LAST$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �i�Ԗ���,�K�X��,�ŏI�i�� from �i�ԍŏI")))

	(setq #kosu (length #LAST$$))
  (princ (strcat "\n ----- \"�i�ԍŏI��ں��ސ�: " (itoa #kosu) " ��"))
  (princ (strcat "\n ----- \"�i�ԍŏI��ں��ސ�: " (itoa #kosu) " ��") #fil)
  (princ "\n")
  (princ "\n" #fil)

  (princ (strcat "\n ----- [�i�ԍŏI]�ŏI�i�ԃ}�b�`���OCHECK�@�J�n"))
  (princ (strcat "\n ----- [�i�ԍŏI]�ŏI�i�ԃ}�b�`���OCHECK�@�J�n") #fil)
  (princ "\n")
  (princ "\n" #fil)

	(setq #n 1)
  (foreach #LAST$ #LAST$$
    (if (and (/= #n 0)(= 0 (rem #n 100)))
      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
    );_if

    (setq #hin  (nth 0 #LAST$)) ;�i�Ԗ���
    (setq #gas  (nth 1 #LAST$)) ;gas
    (setq #last (nth 2 #LAST$)) ;�ŏI�i��

		(if (or (= nil #gas)(= "" #gas))
			(progn
				;<��>
				; H$15B1N-JN#-@@  "$","#","@@"��"*"�ɒu��������
				; HRJ15B1N-JND-G ��ϯ�ݸ�
				(setq #hin (vl-string-subst "*" "$"  #hin)) ;"$"�u��
				(setq #hin (vl-string-subst "*" "#"  #hin)) ;"#"�u��
				(setq #hin (vl-string-subst "*" "%"  #hin)) ;"%"�u��
				(if (setq #num (vl-string-search "@@" #hin))
					(setq #hin (strcat (substr #hin 1 #num) "*") ) ;"@@"�u��
				);_if
							 
				(if (wcmatch #last #hin)
					nil ;ϯ�
					;else
		      (princ (strcat "\n������[�i�ԍŏI]�i�Ԗ��̂ƍŏI�i�Ԃ�ϯ����Ȃ�: " (nth 0 #LAST$) "," #last) #fil)
				);_if
			)
			(progn
				nil
			)
		);_if

		(setq #n (1+ #n))
  );foreach

  (princ (strcat "\n ----- [�i�ԍŏI]�ŏI�i�ԃ}�b�`���OCHECK�@�I��"))
  (princ (strcat "\n ----- [�i�ԍŏI]�ŏI�i�ԃ}�b�`���OCHECK�@�I��") #fil)
  (princ "\n")
  (princ "\n" #fil)

	;���ޯ�Ӱ���׸ނ�߂�
	(setq CG_DEBUG #CG_DEBUG)

  (princ (strcat "\n---�I��") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\�ŏI�i�ԃ}�b�`���OCHECK_" CG_SeriesDB ".txt"))
  (princ)
);C:LASTHINBANCHECK2


;;;<HOM>*************************************************************************
;;; <�֐���>    : C:PLANCHECK1
;;; <�����T�v>  : [�v�����Ǘ�][�����Ǘ�]��ID��[�v�����\��][�����\��]
;;;               �ɑ��݂��邩�ǂ�������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2011/03/12 YM
; select distinct �v����ID from �v���Ǘ� where �v����ID like '*G00*'
; select distinct �v����ID from �v���\�� where �v����ID like '*G00*'
;;;*************************************************************************>MOH<
(defun C:PLANCHECK1 (
  /
	#CG_DEBUG #DATE_TIME #DBNAME1 #DBNAME2 #FIL #IDNAME #QRY$$ #REC$ #TABLE$$
  )

	(StartUndoErr);// �R�}���h�̏�����

	(setvar "CMDECHO" 0)
	;���ޯ�Ӱ���׸ނ�ۑ�
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);����


  (setq #fil (open (strcat CG_SYSPATH "LOG\\�v����ID�Ή�CHECK_" CG_SeriesDB ".csv") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������

  (princ "\n" #fil)
  (princ "\n[**�Ǘ�]��ID��[**�\��]�ɑ��݂��邩�@�B�I������" #fil)
  (princ "\n��������[**�Ǘ�]�̓o�^���Ԉ���Ă����炱�������͖��Ӗ�" #fil)
  (princ "\n" #fil)
  (princ "\n(C:PLANCHECK1)����ނɂ������" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesDB) #fil)
  (princ "\n" #fil)

	(setq #unit$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "select ���j�b�g�L�� from SERIES WHERE SERIES���� = '" CG_SeriesDB "'")))
	(setq #unit$ (car #unit$$))
	(setq #unit (car #unit$))


	(cond
		((= #unit "A") ;����
			(setq #table$$
				(list
					(list "�v���Ǘ�" "�v���\��" "�v����ID" )
					(list "�����Ǘ�" "�����\��" "����ID" )
					(list "�p�l���Ǘ�" "�p�l���\��" "ID" )
					(list "�����p�l���Ǘ�" "�����p�l���\��" "ID" )
					(list "��������BOX�Ǘ�" "��������BOX�\��" "ID" )
				)
			)
	 	)
		((= #unit "D") ;���[
			(setq #table$$
				(list
					(list "�v���Ǘ�" "�v���\��" "�v����ID" )
				)
			)
	 	)
		(T
			(setq #table$$ nil)
	 	)
	);_cond

	(foreach #table$ #table$$
	  (setq #rec$ nil)
	  (setq #DBNAME1 (nth 0 #table$))
	  (setq #DBNAME2 (nth 1 #table$))
		(setq #IDNAME  (nth 2 #table$))
	  (princ (strcat "\n" #DBNAME1 " read"))

		;�d���폜
	  (setq #rec$ (DBSqlAutoQuery CG_DBSESSION (strcat "select DISTINCT " #IDNAME " from " #DBNAME1)))

	  (princ (strcat "\nں��ސ�: " (itoa (length #rec$))))

	  (princ "\n" )
	  (princ "\n" #fil)
		(princ (strcat "\n��[" #DBNAME1 "]��[" #DBNAME2 "]�����������@�J�n��"))
		(princ (strcat "\n��[" #DBNAME1 "]��[" #DBNAME2 "]�����������@�J�n��") #fil)

		(setq #kosu (length #rec$))
		(setq #n 1)

	  (foreach #rec #rec$
	    (if (and (/= #n 0)(= 0 (rem #n 500)))
	      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
	    );_if

	    (setq #qry$$
	      (CFGetDBSQLRec CG_DBSESSION #DBNAME2
	        (list
	          (list #IDNAME   (nth 0 #rec)  'STR)
	        )
	      )
	    )
		  (if (= nil #qry$$)
		    (princ (strcat "\n,��,"�@"[" #DBNAME2 "]�ɂȂ�" "," "[" #DBNAME1 "]" #IDNAME "," (nth 0 #rec)) #fil)
			);_if

			(setq #n (1+ #n))
	  )

		(princ (strcat "\n��[" #DBNAME1 "]��[" #DBNAME2 "]�����������@�I����"))
		(princ (strcat "\n��[" #DBNAME1 "]��[" #DBNAME2 "]�����������@�I����") #fil)
	  (princ "\n" )
	  (princ "\n" #fil)
	)

	;���ޯ�Ӱ���׸ނ�߂�
	(setq CG_DEBUG #CG_DEBUG)

  (princ (strcat "\n") #fil)
  (princ (strcat "\n---�I��") #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\�v����ID�Ή�CHECK_" CG_SeriesDB ".csv"))
  (princ)
);C:PLANCHECK1


;;;<HOM>*************************************************************************
;;; <�֐���>    : C:PLANCHECK2
;;; <�����T�v>  : [**�Ǘ�][**�\��]�̃��R�[�h�d���`�F�b�N
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2011/03/14 YM
;;;*************************************************************************>MOH<
(defun C:PLANCHECK2 (
  /
	#CG_DEBUG #DATE_TIME #DBNAME #FIL #LR #REC$$ #REC_2$$ #REC_3$$ #REC_4$$
	#REC_DOWN #REC_DOWN$$ #REC_UPPER$$
  )

	(StartUndoErr);// �R�}���h�̏�����

	(setvar "CMDECHO" 0)
	;���ޯ�Ӱ���׸ނ�ۑ�
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);����

  (setq #fil (open (strcat CG_SYSPATH "LOG\\�v�����d��CHECK_" CG_SeriesDB ".csv") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n" #fil)
  (princ "\n(C:PLANCHECK2)����ނɂ������" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesDB) #fil)
  (princ "\n" #fil)


	(if (or (= (substr CG_SeriesDB 2 1) "K")(= (substr CG_SeriesDB 3 1) "K"))
		(progn
			
		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "�v���Ǘ�")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o(����)
		  (setq #rec_down$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"���j�b�g�L��,�V���N���Ԍ�,�`��,�\���^�C�v,�t���A�L���r�^�C�v,�V���N�ʒu,�R�����ʒu,�H��ʒu,���s��,�V���N�L��,SOFT_CLOSE,�V��_�݌ˍ���,count(*)"
					" from " #DBNAME
					" group by "
					"���j�b�g�L��,�V���N���Ԍ�,�`��,�\���^�C�v,�t���A�L���r�^�C�v,�V���N�ʒu,�R�����ʒu,�H��ʒu,���s��,�V���N�L��,SOFT_CLOSE,�V��_�݌ˍ���"
		 			" HAVING count(*) > 1"
				))
			)

			;�d��ں��ނ̒��o(���)
		  (setq #rec_upper$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"���j�b�g�L��,�V���N���Ԍ�,�`��,�\���^�C�v,SOFT_CLOSE,�V��_�݌ˍ���,count(*)"
					" from " #DBNAME
					" group by "
					"���j�b�g�L��,�V���N���Ԍ�,�`��,�\���^�C�v,SOFT_CLOSE,�V��_�݌ˍ���"
		 			" HAVING count(*) > 1"
				))
			)

			;̧�ُo��(����)
			(foreach #rec_down$ #rec_down$$
				(princ (strcat "\n" #DBNAME "������d����: " ) #fil)
				(princ
					(strcat
						(nth  0 #rec_down$) ","
						(nth  1 #rec_down$) ","
						(nth  2 #rec_down$) ","
						(nth  4 #rec_down$) ","
						(nth  5 #rec_down$) ","
						(nth  6 #rec_down$) ","
						(nth  7 #rec_down$) ","
						(nth  8 #rec_down$) ","
						(nth  9 #rec_down$) ","
						(nth 10 #rec_down$) ","
						(nth 11 #rec_down$) ","
						(rtos (fix (+ (nth 12 #rec_down$) 0.001)))
						"���d��"
				 	) #fil)
			);foreach

			;̧�ُo��(���)
			(foreach #rec_upper$ #rec_upper$$
				(if (equal (nth  3 #rec_upper$) 2.0 0.001)
					(progn
						(princ (strcat "\n" #DBNAME "�����d����: " ) #fil)
						(princ
							(strcat
								(nth  0 #rec_upper$) ","
								(nth  1 #rec_upper$) ","
								(nth  2 #rec_upper$) ","
								(nth  4 #rec_upper$) ","
								(nth  5 #rec_upper$) ","
								(rtos (fix (+ (nth 6 #rec_down) 0.001)))
								"���d��"
						 	) #fil)
					)
				);_if
			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "�v���\��")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"�v����ID,RECNO,�i�Ԗ���,LR�敪,���i�^�C�v,����X,����Y,����Z,count(*)"
					" from " #DBNAME
					" group by "
					"�v����ID,RECNO,�i�Ԗ���,LR�敪,���i�^�C�v,����X,����Y,����Z"
		 			" HAVING count(*) > 1"
				))
			)
			;̧�ُo��
			(foreach #rec$ #rec$$
				(princ (strcat "\n[" #DBNAME "],���d����," ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR�敪���o�^!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 8 #rec$) 0.001)))
						"���d��"
				 	) #fil)
			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "�����Ǘ�")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o(���M�@��)
		  (setq #rec_2$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"���j�b�g�L��,�V���N���Ԍ�,�`��,���i�^�C�v,�t���A�L���r�^�C�v,�V���N�ʒu,�R�����ʒu,�H��ʒu,���s��,�V���N�L��,�R�������ݒu,SOFT_CLOSE,�V��_�݌ˍ���,�R�����e����,count(*)"
					" from " #DBNAME
					" group by "
					"���j�b�g�L��,�V���N���Ԍ�,�`��,���i�^�C�v,�t���A�L���r�^�C�v,�V���N�ʒu,�R�����ʒu,�H��ʒu,���s��,�V���N�L��,�R�������ݒu,SOFT_CLOSE,�V��_�݌ˍ���,�R�����e����"
		 			" HAVING count(*) > 1"
				))
			)
			;�d��ں��ނ̒��o(�ݼ�̰��)
		  (setq #rec_3$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"���j�b�g�L��,�V���N���Ԍ�,�`��,���i�^�C�v,�V��_�݌ˍ���,HOOD�L��,count(*)"
					" from " #DBNAME
					" group by "
					"���j�b�g�L��,�V���N���Ԍ�,�`��,���i�^�C�v,�V��_�݌ˍ���,HOOD�L��"
		 			" HAVING count(*) > 1"
				))
			)
			;�d��ں��ނ̒��o(�H��)
		  (setq #rec_4$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"���j�b�g�L��,���i�^�C�v,�t���A�L���r�^�C�v,���s��,�V���N�L��,SOFT_CLOSE,�V��_�݌ˍ���,�H��L��,count(*)"
					" from " #DBNAME
					" group by "
					"���j�b�g�L��,���i�^�C�v,�t���A�L���r�^�C�v,���s��,�V���N�L��,SOFT_CLOSE,�V��_�݌ˍ���,�H��L��"
		 			" HAVING count(*) > 1"
				))
			)

			;̧�ُo��
			(foreach #rec_2$ #rec_2$$
				(if (equal (nth  3 #rec_2$) 2.0 0.001);(���M�@��)
					(progn
						(princ (strcat "\n" #DBNAME "�����M�@��@�d����: " ) #fil)
						(princ
							(strcat
								(nth  0 #rec_2$) ","
								(nth  1 #rec_2$) ","
								(nth  2 #rec_2$) ","
								(nth  4 #rec_2$) ","
								(nth  5 #rec_2$) ","
								(nth  6 #rec_2$) ","
								(nth  7 #rec_2$) ","
								(nth  8 #rec_2$) ","
								(nth  9 #rec_2$) ","
								(nth 10 #rec_2$) ","
								(nth 11 #rec_2$) ","
								(nth 12 #rec_2$) ","
								(nth 13 #rec_2$) ","
								(rtos (fix (+ (nth 14 #rec_2$) 0.001)))
								"���d��"
						 	) #fil)
					)
				);_if
			);foreach

			(foreach #rec_3$ #rec_3$$
				(if (equal (nth  3 #rec_3$) 3.0 0.001);(�ݼ�̰��)
					(progn
						(princ (strcat "\n" #DBNAME "���ݼ�̰�ށ@�d����: " ) #fil)
						(princ
							(strcat
								(nth  0 #rec_3$) ","
								(nth  1 #rec_3$) ","
								(nth  2 #rec_3$) ","
								(nth  4 #rec_3$) ","
								(nth  5 #rec_3$) ","
								(rtos (fix (+ (nth 6 #rec_3$) 0.001)))
								"���d��"
						 	) #fil)
					)
				);_if
			);foreach

			(foreach #rec_4$ #rec_4$$
				(if (equal (nth  1 #rec_4$) 4.0 0.001);(�H��)
					(progn
						(princ (strcat "\n" #DBNAME "���H��@�d����: " ) #fil)
						(princ
							(strcat
								(nth  0 #rec_4$) ","
								(nth  2 #rec_4$) ","
								(nth  3 #rec_4$) ","
								(nth  4 #rec_4$) ","
								(nth  5 #rec_4$) ","
								(nth  6 #rec_4$) ","
								(nth  7 #rec_4$) ","
								(rtos (fix (+ (nth 8 #rec_4$) 0.001)))
								"���d��"
						 	) #fil)
					)
				);_if
			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "�����\��")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"����ID,RECNO,�i�Ԗ���,LR�敪,count(*)"
					" from " #DBNAME
					" group by "
					"����ID,RECNO,�i�Ԗ���,LR�敪"
		 			" HAVING count(*) > 1"
				))
			)
			;̧�ُo��
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "���d����: " ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR�敪���o�^!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 4 #rec$) 0.001)))
						"���d��"
				 	) #fil)
			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "�����p�l���Ǘ�")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"�V���N���Ԍ�,�`��,���i�^�C�v,���s��,�V����,�V���N�L��,����,count(*)"
					" from " #DBNAME
					" group by "
					"�V���N���Ԍ�,�`��,���i�^�C�v,���s��,�V����,�V���N�L��,����"
		 			" HAVING count(*) > 1"
				))
			)

			;̧�ُo��
			(foreach #rec$ #rec$$
				(cond
					((equal (nth  2 #rec$) 1.0 0.001)
						(princ (strcat "\n" #DBNAME "��1:�������ف@�d����: " ) #fil)
					)
					((equal (nth  2 #rec$) 5.0 0.001)
						(princ (strcat "\n" #DBNAME "��5:�������ف@�d����: " ) #fil)
				 	)
					(T
						(princ (strcat "\n" #DBNAME "��?:���i���ߕs���@�d����: " ) #fil)
				 	)
				);_cond

				(princ
					(strcat
						(nth  0 #rec$) ","
						(nth  1 #rec$) ","
						(nth  3 #rec$) ","
						(nth  4 #rec$) ","
						(nth  5 #rec$) ","
						(nth  6 #rec$) ","
						(rtos (fix (+ (nth 7 #rec$) 0.001)))
						"���d��"
				 	) #fil)

			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "�����p�l���\��")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ID,RECNO,�i�Ԗ���,LR�敪,count(*)"
					" from " #DBNAME
					" group by "
					"ID,RECNO,�i�Ԗ���,LR�敪"
		 			" HAVING count(*) > 1"
				))
			)
			;̧�ُo��
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "���d����: " ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR�敪���o�^!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 4 #rec$) 0.001)))
						"���d��"
				 	) #fil)
			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "��������BOX�Ǘ�")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"�V���N���Ԍ�,�`��,���i�^�C�v,���s��,�V����,���V���L��,count(*)"
					" from " #DBNAME
					" group by "
					"�V���N���Ԍ�,�`��,���i�^�C�v,���s��,�V����,���V���L��"
		 			" HAVING count(*) > 1"
				))
			)

			;̧�ُo��
			(foreach #rec$ #rec$$
				(cond
					((equal (nth  2 #rec$) 7.0 0.001)
						(princ (strcat "\n" #DBNAME "��7:����BOX�@�d����: " ) #fil)
					)
					(T
						(princ (strcat "\n" #DBNAME "��?:���i���ߕs���@�d����: " ) #fil)
				 	)
				);_cond

				(princ
					(strcat
						(nth  0 #rec$) ","
						(nth  1 #rec$) ","
						(nth  3 #rec$) ","
						(nth  4 #rec$) ","
						(nth  5 #rec$) ","
						(rtos (fix (+ (nth 6 #rec$) 0.001)))
						"���d��"
				 	) #fil)

			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "��������BOX�\��")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ID,RECNO,�i�Ԗ���,LR�敪,count(*)"
					" from " #DBNAME
					" group by "
					"ID,RECNO,�i�Ԗ���,LR�敪"
		 			" HAVING count(*) > 1"
				))
			)
			;̧�ُo��
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "���d����: " ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR�敪���o�^!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 4 #rec$) 0.001)))
						"���d��"
				 	) #fil)
			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "�p�l���Ǘ�")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"���s��,�V����,����,�G���h�p�l��,�݌ˍ���,�g�b�v����,count(*)"
					" from " #DBNAME
					" group by "
					"���s��,�V����,����,�G���h�p�l��,�݌ˍ���,�g�b�v����"
		 			" HAVING count(*) > 1"
				))
			)

			;̧�ُo��
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "���d����: " ) #fil)
				(princ
					(strcat
						(nth  0 #rec$) ","
						(nth  1 #rec$) ","
						(nth  2 #rec$) ","
						(nth  3 #rec$) ","
						(nth  4 #rec$) ","
						(nth  5 #rec$) ","
						(rtos (fix (+ (nth 6 #rec$) 0.001)))
						"���d��"
				 	) #fil)

			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "�p�l���\��")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ID,RECNO,�i�Ԗ���,LR�敪,count(*)"
					" from " #DBNAME
					" group by "
					"ID,RECNO,�i�Ԗ���,LR�敪"
		 			" HAVING count(*) > 1"
				))
			)
			;̧�ُo��
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "���d����: " ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR�敪���o�^!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 4 #rec$) 0.001)))
						"���d��"
				 	) #fil)
			);foreach

		  (princ "\n" #fil)
		  (princ "\n")

		)
		(progn ;"SD"���[


		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "�v���Ǘ�")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o(����)
		  (setq #rec_down$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"���j�b�g�L��,��{�\��,�\���^�C�v,���[�Ԍ�,���s��,SOFT_CLOSE,�A���~�g�K���X,�J�E���^�[�F,count(*)"
					" from " #DBNAME
					" group by "
					"���j�b�g�L��,��{�\��,�\���^�C�v,���[�Ԍ�,���s��,SOFT_CLOSE,�A���~�g�K���X,�J�E���^�[�F"
		 			" HAVING count(*) > 1"
				))
			)

			;�d��ں��ނ̒��o(���)
		  (setq #rec_upper$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"���j�b�g�L��,���\��,�\���^�C�v,���[�Ԍ�,SOFT_CLOSE,count(*)"
					" from " #DBNAME
					" group by "
					"���j�b�g�L��,���\��,�\���^�C�v,���[�Ԍ�,,SOFT_CLOSE"
		 			" HAVING count(*) > 1"
				))
			)

			;̧�ُo��(����)
			(foreach #rec_down$ #rec_down$$
				(if (equal (nth  2 #rec_down$) 1.0 0.001)
					(progn
						(princ (strcat "\n" #DBNAME "������d����: " ) #fil)
						(princ
							(strcat
								(nth  0 #rec_down$) ","
								(nth  1 #rec_down$) ","
								(nth  3 #rec_down$) ","
								(nth  4 #rec_down$) ","
								(nth  5 #rec_down$) ","
								(nth  6 #rec_down$) ","
								(nth  7 #rec_down$) ","
								(rtos (fix (+ (nth 8 #rec_down$) 0.001)))
								"���d��"
						 	) #fil)
					)
				);_if
			);foreach

			;̧�ُo��(���)
			(foreach #rec_upper$ #rec_upper$$
				(if (equal (nth  3 #rec_upper$) 2.0 0.001)
					(progn
						(princ (strcat "\n" #DBNAME "�����d����: " ) #fil)
						(princ
							(strcat
								(nth  0 #rec_upper$) ","
								(nth  1 #rec_upper$) ","
								(nth  3 #rec_upper$) ","
								(nth  4 #rec_upper$) ","
								(rtos (fix (+ (nth 5 #rec_down) 0.001)))
								"���d��"
						 	) #fil)
					)
				);_if
			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "�v���\��")
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)
			;�d��ں��ނ̒��o
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"�v����ID,RECNO,�i�Ԗ���,LR�敪,���i�^�C�v,����X,����Y,����Z,count(*)"
					" from " #DBNAME
					" group by "
					"�v����ID,RECNO,�i�Ԗ���,LR�敪,���i�^�C�v,����X,����Y,����Z"
		 			" HAVING count(*) > 1"
				))
			)
			;̧�ُo��
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "���d����: " ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR�敪���o�^!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 8 #rec$) 0.001)))
						"���d��"
				 	) #fil)
			);foreach

			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
			(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		)
	);_if




  ;-------------------------------------------------------------------------------
  (setq #rec$$ nil)
  (setq #DBNAME "�i�ԍŏI")
	(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n"))
	(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�J�n") #fil)

	;�d��ں��ނ̒��o
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
		(strcat "select " 
			"�i�Ԗ���,LR�敪,���V���L��,���J���L��,����L��,�K�X��,�ŏI�i��,count(*)"
			" from " #DBNAME
			" group by "
			"�i�Ԗ���,LR�敪,���V���L��,���J���L��,����L��,�K�X��,�ŏI�i��"
 			" HAVING count(*) > 1"
		))
	)
	;̧�ُo��
	(foreach #rec$ #rec$$
		(princ (strcat "\n" #DBNAME "���d����: " ) #fil)
		(princ
			(strcat
				(nth  0 #rec$) ","
				(nth  1 #rec$) ","
				(nth  6 #rec$) ","
				(rtos (fix (+ (nth 7 #rec$) 0.001)))
				"���d��"
		 	) #fil)
	);foreach

	(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��"))
	(princ (strcat "\n" #DBNAME "�̏d�����R�[�h���o�@�I��") #fil)
  ;-------------------------------------------------------------------------------

  (princ "\n" #fil)
  (princ "\n")

	(princ (strcat "\n---�I��") #fil)

	;���ޯ�Ӱ���׸ނ�߂�
	(setq CG_DEBUG #CG_DEBUG)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\�v�����d��CHECK_" CG_SeriesDB ".csv"))
	
  (princ)
);C:PLANCHECK2



;;;<HOM>*************************************************************************
;;; <�֐���>    : C:PLANCHECK3
;;; <�����T�v>  : �o�^�L���s�����`�F�b�N
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2011/03/14 YM
;;;*************************************************************************>MOH<
(defun C:PLANCHECK3 (
  /
	#CG_DEBUG #DATE_TIME #DBNAME #FIELD #FIL #HIN$ #KIGO #LIS$ #REC$ #RECSK$ #SK_KIGO$ #TABLE$$ #TOKUSEI
  )

	;07/02/19 YM ADD-S °َg�p������
	(StartUndoErr);// �R�}���h�̏�����

	(setvar "CMDECHO" 0)
	;���ޯ�Ӱ���׸ނ�ۑ�
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);����


  (setq #fil (open (strcat CG_SYSPATH "LOG\\�o�^�L���s����CHECK_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
	(princ (strcat "\n�eð��ق̓o�^�L����[SK�����l]�ƑΉ����Ă��邩����") #fil)
  (princ "\n" #fil)
  (princ "\n(C:PLANCHECK3)����ނɂ������" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesDB) #fil)
  (princ "\n" #fil)

  ;-------------------------------------------------------------------------------

	(setq #unit$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "select ���j�b�g�L�� from SERIES WHERE SERIES���� = '" CG_SeriesDB "'")))
	(setq #unit$ (car #unit$$))
	(setq #unit (car #unit$))

	;2015/06/30 YM ADD OP�u���̋L��������������

	(cond
		((= #unit "A") ;����
			(setq #table$$
			 	;̨���ޖ�,ð��ٖ�,SK�����l.����ID
				(list
					(list "PLAN32"             "HOOD����"           "PLAN32" )

					(list "�`��"               "OP�u���V���N"       "PLAN05" )
					(list "���s��"             "OP�u���V���N"       "PLAN07" )
					(list "�V���N�L��"         "OP�u���V���N"       "PLAN17" )

;;;					(list "�ގ��L��"           "WT�ގ�"             "PLAN16" )

;;;					(list "���s"               "SINK���s�Ǘ�"       "PLAN07" )

					(list "�L��"               "�K���X�p�e�B�V����" "PLAN44" )
					(list "�V���N���Ԍ�"       "�K���X�p�e�B�V����" "PLAN04" )
					(list "���s��"             "�K���X�p�e�B�V����" "PLAN07" )
					(list "�V����"           "�K���X�p�e�B�V����" "PLAN31" )
					(list "�V���N�L��"         "�K���X�p�e�B�V����" "PLAN17" )

					(list "�L��"               "�L�b�`���p�l���E��" "PLAN47" )

					(list "�ގ��L��"           "�V���NOP"           "PLAN16" )
					(list "�V���N�L��"         "�V���NOP"           "PLAN17" )

					(list "�ގ��L��"           "�g�b�v��������"     "PLAN16" )
					(list "�V���N�L��"         "�g�b�v��������"     "PLAN17" )
					(list "�`��"               "�g�b�v��������"     "PLAN05" )

					(list "���s��"             "�p�l���Ǘ�"         "PLAN07" )
					(list "�V����"           "�p�l���Ǘ�"         "PLAN31" )
					(list "�G���h�p�l��"       "�p�l���Ǘ�"         "PLAN45" )
					(list "�݌ˍ���"           "�p�l���Ǘ�"         "PLAN32" )

					(list "���V���L��"         "�p�l������"         "PLAN12" )
					(list "���J���L��"         "�p�l������"         "PLAN13" )

					(list "�V���N���Ԍ�"       "�v���Ǘ�"   "PLAN04" )
					(list "�`��"               "�v���Ǘ�"   "PLAN05" )
					(list "�t���A�L���r�^�C�v" "�v���Ǘ�"   "PLAN06" )
					(list "���s��"             "�v���Ǘ�"   "PLAN07" )
					(list "�V���N�L��"         "�v���Ǘ�"   "PLAN17" )
					(list "SOFT_CLOSE"         "�v���Ǘ�"   "PLAN08" )

					(list "���V���L��"         "����Ǘ�"   "PLAN12" )
					(list "���J���L��"         "����Ǘ�"   "PLAN13" )
					(list "����L��"           "����Ǘ�"   "PLAN14" )

					(list "�V���N�L��"         "�����ʒu"   "PLAN17" )

					(list "�V���N���Ԍ�"       "�V�䖋��"   "PLAN04" )
					(list "�`��"               "�V�䖋��"   "PLAN05" )
					(list "�ϊ��l"             "�V�䖋��"   "PLAN46" )

					(list "�ގ��L��"           "�V���i"   "PLAN16" )
					(list "�`��"               "�V���i"   "PLAN05" )
					(list "�V���N�L��"         "�V���i"   "PLAN17" )
					(list "�V���N���Ԍ�"       "�V���i"   "PLAN04" )
					(list "���s��"             "�V���i"   "PLAN07" )

					(list "���J���L��"         "��COLOR"   "PLAN13" )

					(list "���V���L��"         "���V���Y"   "PLAN12" )

					(list "���V���L��"         "���V�Ǘ�"   "PLAN12" )
					(list "���J���L��"         "���V�Ǘ�"   "PLAN13" )

					(list "���V���L��"         "�i�ԃV��"   "PLAN12" )
					(list "����L��"           "�i�ԃV��"   "PLAN14" )

					(list "���V���L��"         "�i�ԍŏI"   "PLAN12" )
					(list "���J���L��"         "�i�ԍŏI"   "PLAN13" )
					(list "����L��"           "�i�ԍŏI"   "PLAN14" )

					(list "�L��"               "����GAS"    "PLAN20" )

					(list "PLAN23"             "����HOOD"   "PLAN23" )

					(list "�L��"               "����OBUN"   "PLAN21" );2011/03/15 YM MOD
					(list "���s��"             "����OBUN"   "PLAN07" )
					(list "�V����"           "����OBUN"   "PLAN31" )

					(list "�V���N���Ԍ�"       "�����p�l���Ǘ�"   "PLAN04" )
					(list "�`��"               "�����p�l���Ǘ�"   "PLAN05" )
					(list "���s��"             "�����p�l���Ǘ�"   "PLAN07" )
					(list "�V����"           "�����p�l���Ǘ�"   "PLAN31" )
					(list "�V���N�L��"         "�����p�l���Ǘ�"   "PLAN17" )

					(list "�V���N���Ԍ�"       "�����Ǘ�"   "PLAN04" )
					(list "�`��"               "�����Ǘ�"   "PLAN05" )
					(list "�t���A�L���r�^�C�v" "�����Ǘ�"   "PLAN06" )
					(list "�V���N�ʒu"         "�����Ǘ�"   "PLAN02" )
					(list "�R�����ʒu"         "�����Ǘ�"   "PLAN09" )
					(list "�H��ʒu"           "�����Ǘ�"   "PLAN10" )
					(list "���s��"             "�����Ǘ�"   "PLAN07" )
					(list "�V���N�L��"         "�����Ǘ�"   "PLAN17" )
					(list "�R�������ݒu"       "�����Ǘ�"   "PLAN21" )
					(list "SOFT_CLOSE"         "�����Ǘ�"   "PLAN08" )
					(list "HOOD�L��"           "�����Ǘ�"   "PLAN23" )
					(list "�H��L��"           "�����Ǘ�"   "PLAN42" )

					(list "�L��"               "��������"   "PLAN19" )

					(list "�V���N���Ԍ�"       "��������BOX�Ǘ�"   "PLAN04" )
					(list "�`��"               "��������BOX�Ǘ�"   "PLAN05" )
					(list "���s��"             "��������BOX�Ǘ�"   "PLAN07" )
					(list "�V����"           "��������BOX�Ǘ�"   "PLAN31" )
					(list "���V���L��"         "��������BOX�Ǘ�"   "PLAN12" )
				)
			)

		)
		((= #unit "D") ;���[

			(setq #table$$
			 	;̨���ޖ�,ð��ٖ�,SK�����l.����ID
				(list
					(list "�G���h�p�l��"             "C�G���h�p�l���L��"           "PLAN171" )
					(list "�G���h�p�l��"             "C�G���h�p�l���L��"           "PLAN271" )
					(list "�G���h�p�l��"             "C�G���h�p�l���L��"           "PLAN371" )
					(list "�G���h�p�l��"             "C�G���h�p�l���L��"           "PLAN471" )
					(list "�G���h�p�l��"             "C�G���h�p�l���L��"           "PLAN571" )

					(list "KEY"               "C�J�E���^�ő�Ԍ�"       "PLAN157" )
					(list "KEY"               "C�J�E���^�ő�Ԍ�"       "PLAN257" )
					(list "KEY"               "C�J�E���^�ő�Ԍ�"       "PLAN357" )
					(list "KEY"               "C�J�E���^�ő�Ԍ�"       "PLAN457" )
					(list "KEY"               "C�J�E���^�ő�Ԍ�"       "PLAN557" )

					(list "��{�\��"               "C�J�E���^���"       "PLAN154" )
					(list "��{�\��"               "C�J�E���^���"       "PLAN254" )
					(list "��{�\��"               "C�J�E���^���"       "PLAN354" )
					(list "��{�\��"               "C�J�E���^���"       "PLAN454" )
					(list "��{�\��"               "C�J�E���^���"       "PLAN554" )

					(list "�J�E���^�F"               "C�J�E���^�u��"       "PLAN157" )
					(list "�J�E���^�F"               "C�J�E���^�u��"       "PLAN257" )
					(list "�J�E���^�F"               "C�J�E���^�u��"       "PLAN357" )
					(list "�J�E���^�F"               "C�J�E���^�u��"       "PLAN457" )
					(list "�J�E���^�F"               "C�J�E���^�u��"       "PLAN557" )

					(list "��{�\��"               "C�V�����s�Q��"       "PLAN154" )
					(list "��{�\��"               "C�V�����s�Q��"       "PLAN254" )
					(list "��{�\��"               "C�V�����s�Q��"       "PLAN354" )
					(list "��{�\��"               "C�V�����s�Q��"       "PLAN454" )
					(list "��{�\��"               "C�V�����s�Q��"       "PLAN554" )

					(list "�ϊ��l"               "�p�l���Ǘ�EX"       "PLAN171" )
					(list "�ϊ��l"               "�p�l���Ǘ�EX"       "PLAN271" )
					(list "�ϊ��l"               "�p�l���Ǘ�EX"       "PLAN371" )
					(list "�ϊ��l"               "�p�l���Ǘ�EX"       "PLAN471" )
					(list "�ϊ��l"               "�p�l���Ǘ�EX"       "PLAN571" )

					(list "���V���L��"               "�p�l������"       "PLAN62" )
					(list "���J���L��"               "�p�l������"       "PLAN63" )

					(list "KEY"               "C�J�E���^�ő�Ԍ�"       "PLAN157" )
					(list "KEY"               "C�J�E���^�ő�Ԍ�"       "PLAN257" )
					(list "KEY"               "C�J�E���^�ő�Ԍ�"       "PLAN357" )
					(list "KEY"               "C�J�E���^�ő�Ԍ�"       "PLAN457" )
					(list "KEY"               "C�J�E���^�ő�Ԍ�"       "PLAN557" )

					(list "��{�\��"               "�v���Ǘ�"       "PLAN154" )
					(list "��{�\��"               "�v���Ǘ�"       "PLAN254" )
					(list "��{�\��"               "�v���Ǘ�"       "PLAN354" )
					(list "��{�\��"               "�v���Ǘ�"       "PLAN454" )
					(list "��{�\��"               "�v���Ǘ�"       "PLAN554" )

					(list "���\��"               "�v���Ǘ�"       "PLAN161" )
					(list "���\��"               "�v���Ǘ�"       "PLAN261" )
					(list "���\��"               "�v���Ǘ�"       "PLAN361" )
					(list "���\��"               "�v���Ǘ�"       "PLAN461" )
					(list "���\��"               "�v���Ǘ�"       "PLAN561" )

					(list "���[�Ԍ�"               "�v���Ǘ�"       "PLAN155" )
					(list "���[�Ԍ�"               "�v���Ǘ�"       "PLAN255" )
					(list "���[�Ԍ�"               "�v���Ǘ�"       "PLAN355" )
					(list "���[�Ԍ�"               "�v���Ǘ�"       "PLAN455" )
					(list "���[�Ԍ�"               "�v���Ǘ�"       "PLAN555" )

					(list "���s��"               "�v���Ǘ�"       "PLAN153" )
					(list "���s��"               "�v���Ǘ�"       "PLAN253" )
					(list "���s��"               "�v���Ǘ�"       "PLAN353" )
					(list "���s��"               "�v���Ǘ�"       "PLAN453" )
					(list "���s��"               "�v���Ǘ�"       "PLAN553" )

					(list "SOFT_CLOSE"           "�v���Ǘ�"       "PLAN58" )

					(list "�A���~�g�K���X"       "�v���Ǘ�"       "PLAN159" )
					(list "�A���~�g�K���X"       "�v���Ǘ�"       "PLAN259" )
					(list "�A���~�g�K���X"       "�v���Ǘ�"       "PLAN359" )
					(list "�A���~�g�K���X"       "�v���Ǘ�"       "PLAN459" )
					(list "�A���~�g�K���X"       "�v���Ǘ�"       "PLAN559" )

					(list "�J�E���^�[�F"         "�v���Ǘ�"       "PLAN157" )
					(list "�J�E���^�[�F"         "�v���Ǘ�"       "PLAN257" )
					(list "�J�E���^�[�F"         "�v���Ǘ�"       "PLAN357" )
					(list "�J�E���^�[�F"         "�v���Ǘ�"       "PLAN457" )
					(list "�J�E���^�[�F"         "�v���Ǘ�"       "PLAN557" )

					(list "���V���L��"             "����Ǘ�"       "PLAN62" )
					(list "���J���L��"             "����Ǘ�"       "PLAN63" )
					(list "����L��"               "����Ǘ�"       "PLAN64" )

					(list "���s�L��"               "���s"       "PLAN153" )
					(list "���s�L��"               "���s"       "PLAN253" )
					(list "���s�L��"               "���s"       "PLAN353" )
					(list "���s�L��"               "���s"       "PLAN453" )
					(list "���s�L��"               "���s"       "PLAN553" )

					(list "�Ԍ��L��"               "�Ԍ�"       "PLAN155" )
					(list "�Ԍ��L��"               "�Ԍ�"       "PLAN255" )
					(list "�Ԍ��L��"               "�Ԍ�"       "PLAN355" )
					(list "�Ԍ��L��"               "�Ԍ�"       "PLAN455" )
					(list "�Ԍ��L��"               "�Ԍ�"       "PLAN555" )

					(list "���s�L��"               "��䉜�s"       "PLAN161" )
					(list "���s�L��"               "��䉜�s"       "PLAN261" )
					(list "���s�L��"               "��䉜�s"       "PLAN361" )
					(list "���s�L��"               "��䉜�s"       "PLAN461" )
					(list "���s�L��"               "��䉜�s"       "PLAN561" )

					(list "�ϊ��l"               "�V�䖋��D"       "PLAN72" )
					(list "���V���L��"           "�V�䖋��D"       "PLAN62" )


					(list "���J���L��"         "��COLOR"   "PLAN63" )

					(list "���V���L��"         "���V���Y"   "PLAN62" )

					(list "���V���L��"         "���V�Ǘ�"   "PLAN62" )
					(list "���J���L��"         "���V�Ǘ�"   "PLAN63" )

					(list "���V���L��"         "�i�ԃV��"   "PLAN62" )
					(list "����L��"           "�i�ԃV��"   "PLAN64" )

					(list "���V���L��"         "�i�ԍŏI"   "PLAN62" )
					(list "���J���L��"         "�i�ԍŏI"   "PLAN63" )
					(list "����L��"           "�i�ԍŏI"   "PLAN64" )

				)
			)

		)
		(T
			(setq #table$$ nil)
		)
	);_cond

	(foreach #table$ #table$$
	  (setq #lis$ nil #hin$ nil)
		(setq #field   (nth 0 #table$))
	  (setq #DBNAME  (nth 1 #table$))
	  (setq #tokusei (nth 2 #table$))
	  (setq #rec$   (DBSqlAutoQuery CG_DBSESSION (strcat "select DISTINCT " #field " from " #DBNAME)))
	  (setq #recSK$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �ϊ��l from SK�����l where ����ID = '" #tokusei "'")))
		(setq #SK_kigo$ (mapcar 'car #recSK$))

	  (foreach #rec #rec$
	    (setq #kigo (nth 0 #rec))
			(if (= #kigo nil)(setq #kigo ""))
			(if (member #kigo #SK_kigo$)
				nil
				;else
				(progn
					(if (or (= #kigo "")(= #kigo "-")(= #kigo "_"))
						nil
						;else
	      		(princ (strcat "\n�������@ð��ٖ��y" #DBNAME "�z, ̨���ޖ�=" #field " [SK�����l].����ID= " #tokusei "�@���s���ȋL��: "  #kigo ) #fil)
					);_if
				)
			);_if
	  );foreach
	);foreach


  (princ "\n" #fil)
	(princ (strcat "\n---�I��") #fil)
  (princ "\n" #fil)

	;���ޯ�Ӱ���׸ނ�߂�
	(setq CG_DEBUG #CG_DEBUG)

  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\�o�^�L���s����CHECK_" CG_SeriesDB ".txt"))
  (princ)
);C:PLANCHECK3

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:PLANCHECK4
;;; <�����T�v>  : [�v�����Ǘ�]�̃��R�[�h�ɑΉ����郌�R�[�h��[�����Ǘ�]
;;;               �ɑ��݂��邩�ǂ�������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 06/01/18 YM
;;;*************************************************************************>MOH<
(defun C:PLANCHECK4 (
  /
	#CAB #CG_DEBUG #DATE_TIME #DBNAME #DDD #FIL #HUKU$$ #KEI #KOSU #MAG #N #PKO #PSI
	#PSY #REC$$ #SFT #SNK #UNDER_GAS$ #UNI #WTH #QRYSYOKU$$ #SKIGO$
  )
	(StartUndoErr);// �R�}���h�̏�����

	(setvar "CMDECHO" 0)
	;���ޯ�Ӱ���׸ނ�ۑ�
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);����


  (setq #fil (open (strcat CG_SYSPATH "LOG\\�v���Ǘ�-�����Ǘ��Ή�CHECK_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
	(princ (strcat "\n�y�v���Ǘ��z(����)�ɑΉ�����y�����Ǘ��zں��ނ����݂��邩����(���i����=2,4���Ώ�)") #fil)
  (princ "\n" #fil)
  (princ "\n(C:PLANCHECK4)����ނɂ������" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesDB) #fil)
  (princ "\n" #fil)


  ;-------------------------------------------------------------------------------

  (setq #rec$$ nil)
  (setq #DBNAME "�v���Ǘ�")
  (princ (strcat "\n" #DBNAME " read"))
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " #DBNAME " where �\���^�C�v=1")))

  (princ (strcat "\n[��׊Ǘ�]����"))
	(setq #kosu (itoa (length #rec$$)))
  (princ (strcat "\nں��ސ�: " #kosu))


	;[SK�����l]�H��L�������߂�
	(setq #Skigo$ nil)
  (setq #qrySYOKU$$
  	(CFGetDBSQLRec CG_DBSESSION "SK�����l"
      (list
        (list "����ID" "PLAN42" 'STR)
      )
    )
  )
	(foreach #qrySYOKU$ #qrySYOKU$$
		(if (/= "N" (nth 4 #qrySYOKU$))
			(setq #Skigo$ (append #Skigo$ (list (nth 4 #qrySYOKU$))))
		);_if
	)

;******************************************************************************
	;�eں��ނɑΉ�����[�����Ǘ�]������
	(setq #n 1)
  (princ "\n[�����Ǘ�]�ɑΉ�ں��ނ����݂��Ȃ�����([��׊Ǘ�]�̓o�^�����������Ƃ��O��)" #fil)
  (princ "\n" #fil)
	(foreach #rec$ #rec$$
    (if (and (/= #n 0)(= 0 (rem #n 500)))
      (princ (strcat "\n" (itoa #n) "/"  #kosu))
    );_if

		(setq #uni (nth  1 #rec$));���j�b�g�L��
		(setq #mag (nth  2 #rec$));�V���N���Ԍ�
		(setq #kei (nth  3 #rec$));�`��
		(setq #cab (nth  5 #rec$));�t���A�L���r�^�C�v
		(setq #psi (nth  6 #rec$));�V���N�ʒu
		(setq #pko (nth  7 #rec$));�R�����ʒu
		(setq #psy (nth  8 #rec$));�H��ʒu
		(setq #ddd (nth  9 #rec$));���s��
		(setq #snk (nth 10 #rec$));�V���N�L��
		(setq #sft (nth 12 #rec$));SOFT_CLOSE
		(setq #wth (nth 13 #rec$));�V��_�݌ˍ���

    ;[�����Ǘ�]�޽������ <���i����=2>
		(setq #under_GAS$ (list "B" "O"))
		(foreach #under_GAS #under_GAS$
	    (setq #huku$$
	      (CFGetDBSQLRec CG_DBSESSION "�����Ǘ�"
					(list
						(list "���j�b�g�L��"       #uni 'STR)
						(list "�V���N���Ԍ�"       #mag 'STR)
						(list "�`��"               #kei 'STR)
						(list "���i�^�C�v"         "2"  'INT)
						(list "�t���A�L���r�^�C�v" #cab 'STR)
						(list "�V���N�ʒu"         #psi 'STR)
						(list "�R�����ʒu"         #pko 'STR)
						(list "�H��ʒu"           #psy 'STR)
						(list "���s��"             #ddd 'STR)
						(list "�V���N�L��"         #snk 'STR)
						(list "�R�������ݒu"       #under_GAS 'STR)
						(list "SOFT_CLOSE"         #sft 'STR)
						(list "�V��_�݌ˍ���"      #wth 'STR)
						(list "�R�����e����"       "_"  'STR)
					)
	      )
			)
			(if #huku$$
				nil
				;else
			  (princ (strcat "\n<���i����=2>: "
											 #uni ","
											 #mag ","
											 #kei ",2,"
											 #cab ","
											 #psi ","
											 #pko ","
											 #psy ","
											 #ddd ","
											 #snk ","
											 #under_GAS ","
											 #sft ","
											 #wth
								 ) #fil)
			);_if
    );foreach



    ;[�����Ǘ�]�H������� <���i����=4>
		(if (or (= #cab "UN")(= #cab "BN"))
			nil ; �H��Ȃ�
			;else
			(progn
				(foreach #Skigo #Skigo$
			    (setq #huku$$
			      (CFGetDBSQLRec CG_DBSESSION "�����Ǘ�"
			        (list
								(list "���j�b�g�L��"       #uni 'STR)
								(list "���i�^�C�v"         "4"  'INT)
								(list "�t���A�L���r�^�C�v" #cab 'STR)
								(list "���s��"             #ddd 'STR)
								(list "�V���N�L��"         #snk 'STR)
								(list "SOFT_CLOSE"         #sft 'STR)
								(list "�V��_�݌ˍ���"      #wth 'STR)
								(list "�H��L��"         #Skigo 'STR)
			        )
			      )
			    )
					(if #huku$$
						nil
						;else
					  (princ (strcat "\n<���i����=4>: "
											 		 #uni ","
													 "4,"
													 #cab ","
													 #ddd ","
													 #snk ","
													 #sft ","
													 #wth ","
													 #Skigo
										 ) #fil)
					);_if
				);foreach
			)
		);_if

		(setq #n (1+ #n))
  );foreach

;******************************************************************************

  (princ "\n" #fil)
	(princ (strcat "\n---�I��") #fil)
  (princ "\n" #fil)
	;���ޯ�Ӱ���׸ނ�߂�
	(setq CG_DEBUG #CG_DEBUG)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\�v���Ǘ�-�����Ǘ��Ή�CHECK_" CG_SeriesDB ".txt"))
  (princ)
);C:PLANCHECK4


;;;<HOM>*************************************************************************
;;; <�֐���>    : C:CG_BUNRUI
;;; <�����T�v>  : �y�i�Ԑ}�`�z���番�ނ���(CG�Ή�)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2011/03/28 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:CG_BUNRUI (
  /
	#CG_DEBUG #DATE_TIME #FIL #HIN #HINBAN #HINMEI #KIHON$ #KIHON$$ #KIHON_KOSU
	#KOSU #LAST$$ #LR #N #SKK #ZUKEI #ZUKEI$$ #ZUKEI_KOSU
  )
	; (C:MDBCHECKSK)
	(StartUndoErr);// �R�}���h�̏�����

	;�ݸ�i�Ԉꗗ
	(setq #snk$
		(list
			"A_"
			"FP"
			"FP_970"
			"FW"
			"FW_970"
			"GL"
			"GL_105"
			"GL_700"
			"GL_900"
			"GS"
			"GS_105"
			"GS_700"
			"GS_900"
			"H_"
			"H_105"
			"H_105_D700"
			"H_700"
			"H_GE"
			"K_"
			"K_105"
			"K_600"
			"L_"
			"L_900"
			"L_TL65"
			"L_TL90"
			"MB"
			"MB_105"
			"MB_700"
			"MP"
			"MP_105"
			"MP_700"
			"MW"
			"MW_105"
			"MW_700"
			"MY"
			"MY_105"
			"MY_700"
			"S_"
			"S_780"
			"T_"
			"T_600"
			"U_"
			"U_20"
			"U_900"
			"U_90020"
		)
	)

	(setvar "CMDECHO" 0)
	;���ޯ�Ӱ���׸ނ�ۑ�
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);����

  (setq #fil (open (strcat CG_SYSPATH "LOG\\CG����_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������

  (princ "\n(C:C:CG_BUNRUI)����ނɂ��" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesDB) #fil)	

  (princ "\n")
  (princ "\n" #fil)

  (setq #zukei$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �i�Ԗ���,LR�敪,�}�`ID,���@H,���@D from " "�i�Ԑ}�`")))

	(setq #zukei_kosu (length #zukei$$))
  (princ (strcat "\n ----- \"�i�Ԑ}�`��ں��ސ�: " (itoa #zukei_kosu) " ��"))
  (princ (strcat "\n ----- \"�i�Ԑ}�`��ں��ސ�: " (itoa #zukei_kosu) " ��") #fil)
  (princ "\n")
  (princ "\n" #fil)

  (princ "\n�i��,LR,�}�`ID,���i����,�i��,����,���s" #fil)

	;�������@�i�Ԋ�{��ٰ�߁@������
	(setq #kosu (length #zukei$$))
	(setq #n 1)
  (foreach #zukei$ #zukei$$
    (if (and (/= #n 0)(= 0 (rem #n 50)))
      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
    );_if

    (setq #hinban (nth 0 #zukei$)) ;�i��
    (setq #LR     (nth 1 #zukei$)) ;LR
    (setq #zukei  (nth 2 #zukei$)) ;�}�`ID
    (setq #HH     (itoa (fix (nth 3 #zukei$)))) ;����
    (setq #DD     (itoa (fix (nth 4 #zukei$)))) ;���s

		(if (or (= #zukei nil)(= #zukei ""))
			(setq #zukei  "���o�^")
		);_if
    (setq #kihon$$
      (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
        (list
          (list "�i�Ԗ���"  #hinban 'STR)
        )
      )
    )
		(if #kihon$$
			(setq #skk (itoa (fix (nth 3 (car #kihon$$)))))
			;else
			(progn
        (if (member #hinban #snk$)
					(setq #skk "410")
					;else
					(setq #skk "???")
				);_if
			)
		);_if
    ;()���O��
    (setq #hin (KP_DelHinbanKakko #hinban))

    (setq #last$$
      (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
        (list
          (list "�i�Ԗ���"  #hin 'STR)
          (list "LR�敪"    #LR  'STR)
        )
      )
    )
		(if #last$$
			(setq #hinmei (nth 14 (car #last$$)))
			;else
			(progn
        (if (member #hinban #snk$)
					(setq #hinmei "�ݸ")
					;else
					(setq #hinmei "---")
				);_if
			)
		);_if
    (princ (strcat "\n" #hinban "," #LR "," #zukei "," #skk "," #hinmei "," #HH "," #DD) #fil)
;;;(princ "\n�i��,LR,�}�`ID,���i����,�i��" #fil)
		(setq #n (1+ #n))
  );foreach

	;���ޯ�Ӱ���׸ނ�߂�
	(setq CG_DEBUG #CG_DEBUG)

  (princ (strcat "\n---�I��") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\CG����_" CG_SeriesDB ".txt"))
  (princ)
);C:CG_BUNRUI


;;;<HOM>*************************************************************************
;;; <�֐���>     : C:MOJIID
;;; <�����T�v>   : ����ID����͂����Đ��@������\��
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 07/03/26 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun C:MOJIID (
  /
	#QRY$ #RET
  )
	(setq #str_id (getstring "\n����ID�����: "))

  (setq #qry$
    (car
      (CFGetDBSQLRec CG_CDBSESSION "���@����"
        (list
          (list "����ID" #str_id 'INT)
        )
      )
    )
  )
  (if (= nil #qry$)
		(progn
    	(princ "\n[���@����]�ɒ�`�Ȃ�")
		)
		(progn
    	(princ "\n")
			(princ #qry$)
		)
  );_if
	(princ)
);C:MOJIID


;;;<HOM>*************************************************************************
;;; <�֐���>     : C:BUZAILIST
;;; <�����T�v>   : �}�ʏ�̕��ވꗗ
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 07/03/26 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun C:BUZAILIST (
  /
	#DATE_TIME #FIL #FP #HIN #I #ID #KOSU #LR #OFILE #SS #SYM #XD_LSYM$ 
  )
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))

	(if (and #ss (< 0 (sslength #ss)))
		(progn
			(setq #kosu (sslength #ss))

		  (setq #ofile  (strcat CG_SYSPATH "log\\BUZAILIST.txt"))
		  (setq #fil (open #ofile "W" ))

		  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));���t
		  (princ #date_time #fil) ; ���t��������
		  (princ "\n" #fil)
			(princ (strcat "\n----------------------") #fil)
			(princ (strcat "\n���@�}�ʏ�̕��ވꗗ�@") #fil)
			(princ (strcat "\n----------------------") #fil)
		  (princ "\n" #fil)

		  (setq #i 0)
			(princ "\n��ID,�}�`ID,�i�Ԗ���,LR�敪,X,Y,Z,ANG" #fil)
		  (repeat #kosu
	      (setq #sym (ssname #ss #i))
				(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
				(setq #id  (nth 0 #xd_LSYM$));�}�`ID
				(setq #pt  (nth 1 #xd_LSYM$));�}����_
				(setq #ang (nth 2 #xd_LSYM$));�}���p�x
				(setq #hin (nth 5 #xd_LSYM$));�i��
				(setq #LR  (nth 6 #xd_LSYM$));LR

				(setq #DrInfo (nth 7 #xd_LSYM$)) ;�����
		    (setq #DrInfo$ (strparse #DrInfo ","))
				(setq #DRSeri (nth 0 #DrInfo$))
				(setq #DRCol  (nth 1 #DrInfo$))
				(setq #DRHiki (nth 2 #DrInfo$))

				(if (= #DRSeri nil)					(setq #DRSeri ""))
				(if (= #DRCol nil)					(setq #DRCol ""))
				(if (= #DRHiki nil)					(setq #DRHiki ""))

			  (setq #qry$$
			    (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
			      (list
			        (list "�i�Ԗ���"    #hin    'STR)
			        (list "LR�敪"      #LR     'STR)
			        (list "���V���L��"  #DRSeri 'STR)
			        (list "����L��"    #DRHiki 'STR)
			      )
			    )
			  )
				(if (= nil #qry$$)
					(progn
						(setq #drid "���}�`ID�Ȃ�")
					)
					(progn
	      		(setq #drid (nth 4 (car #qry$$)));"0410329"
						(if (= #drid nil)					(setq #drid "���}�`ID=nil"))
					)
				);_if

;;;				(setq #id (strcat "'" #id))
				(princ (strcat "\n" #drid  "," #id "," #hin "," #LR ",") #fil)
				(setq #xx (nth 0 #pt))(if (< (abs #xx) 0.001)(setq #xx 0))
				(setq #yy (nth 1 #pt))(if (< (abs #yy) 0.001)(setq #yy 0))
				(setq #zz (nth 2 #pt))(if (< (abs #zz) 0.001)(setq #zz 0))

				(princ #xx #fil)
				(princ "," #fil)				
				(princ #yy #fil)
				(princ "," #fil)				
				(princ #zz #fil)
				(princ "," #fil)
				(princ #ang #fil)

		    (setq #i (1+ #i))
		  );repeat

			(startapp "notepad.exe" #ofile)
		  (close #fil)

		)
		(progn
			(princ "\n�}�ʏ�ɕ��ނ�����܂���")
		)
	);_if

	(princ)
);C:BUZAILIST


;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KAISOCHECK
;;; <�����T�v>  : [�K�w]<==>[�i�Ԋ�{][�i�Ԑ}�`]��������
;;; <�쐬>      : 2011/08/30 YM
;;; <���l>      :
;;;                               
;;;                               
;;;                               
;;;                               
;;;                               

;;;*************************************************************************>MOH<
(defun C:KAISOCHECK (
  /
	#DATE_TIME #DBNAME #FIL #HIN #HIN$$ #KAISO$$ #KAISO_FLG #KAISO_HIN$
	#KIHON$$ #KIHON_ALL$$ #KIHON_HIN #LIS$ #NO_HIN #NUM #REC$ #UP_ID_1 #ZUKEI$$ #ZUKEIID
	#FIL
  )

;///////////////////////////////////////////////////////////////////////////////

    ;;;**********************************************************************
    ;;; ;�i�Ԃɽ�߰�����,�S�p�����邩�ǂ�������
    ;;;**********************************************************************
    (defun ##CheckSpace (
      &hin ; �i��
			&tbl ;ð��ٖ�
      /
			#FLG #HIN
      )
      ;�i�Ԃ�"()"���O��
      (setq #hin (KP_DelHinbanKakko &hin))

      ;���p��߰������邩�ǂ���
			(setq #flg1 nil)
      (setq #flg1 (vl-string-search " " #hin))
			(if #flg1
      	(princ (strcat "\n" ",��," "�i�Ԃɔ��p��߰�����" &tbl "," #hin) #fil)
			);_if

      ;�S�p��߰������邩�ǂ���
			(setq #flg2 nil)
      (setq #flg2 (vl-string-search "�@" #hin))
			(if #flg2
      	(princ (strcat "\n" ",��," "�i�ԂɑS�p��߰�����" &tbl "," #hin) #fil)
			);_if

      (princ)
    );##CheckSpace

;///////////////////////////////////////////////////////////////////////////////

	(setq #fil (open (strcat CG_SYSPATH "LOG\\�K�w�s����CHECK_" CG_SeriesDB ".csv") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n�K�w�s��������(C:KAISOCHECK)" #fil)
  (princ (strcat "\n�ذ��=" CG_SeriesDB) #fil)
  (princ "\n" #fil)
  (princ "\n")
	
  ;�ذ�ފK�w����-------------------------------------------------------------------------------
  (setq #lis$ nil #rec$ nil #hin$$ nil #KAISO$$ nil #KIHON$$ nil)

  (setq #DBNAME "�K�w")
  (princ (strcat "\n" #DBNAME " read"))
  (setq #rec$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " #DBNAME)))

  (foreach #rec #rec$
    (setq #kaiso_flg (nth 3 #rec)) ;�K�w�׸�
    (setq #hin       (nth 2 #rec)) ;�i�Ԗ���

		(if (or (= #hin nil)(= #hin ""))
			(progn
				(princ "\n�i�Ԗ��� = nil")
				(princ #rec)
			)
			(progn ;�i��=nil�ȊO��Ώ�
		    (setq #UP_ID_1   (substr (nth 1 #rec) 1 1)) ;��ʊK�wID
		    (if (equal #kaiso_flg 0.0 0.001) ; �K�w�׸�=0�̂��̂���
		    	(setq #hin$$ (append #hin$$ (list (list #hin #UP_ID_1))));(�i��,��ʊK�wID��1����)��ؽ�
		    );_if
			)
		);_if
  );foreach
	
  (princ (strcat "\n�����J�n"))
  (princ (strcat "\n�����J�n") #fil)

  (princ (strcat "\n" "," "�敪" "," "�G���[" "," "�i��/̧��" "," "LR�敪" "," "���l") #fil)

  (princ "\n")
  (princ "\n" #fil)

  (foreach #hin$ #hin$$
		(setq #hin (nth 0 #hin$));�i��
	 	(setq #UP_ID_1 (nth 1 #hin$));��ʊK�wID��1����
		;"()"�t���i�Ԕ���
    (if (and (vl-string-search "(" #hin)(vl-string-search ")" #hin))
      (progn ;"()"�t���i�Ԃ�����
	      ;�i�Ԃ�"()"���O��
	      (setq #no_hin (KP_DelHinbanKakko #hin))
        ;"()"�Ȃ��i�Ԃ�[�i�Ԋ�{]�ɂ��邩
        (setq #KIHON$$
          (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
            (list
              (list "�i�Ԗ���"  #no_hin 'STR)
            )
          )
        )
        (if (= nil #KIHON$$)
          (princ (strcat "\n" ",��," "[�i�Ԋ�{]�Ɋ���()�Ȃ��i�ԂȂ�" "," #hin) #fil)
        );_if
			)
		);_if

		;���p�A�S�p��߰�����[�K�w]
		(##CheckSpace #hin "[�K�w]")


    ;�ؼ��ٕi�Ԃ�����
    ;�i�Ԃ�[�i�Ԋ�{]�ɂ��邩
    (setq #KIHON$$
      (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
        (list
          (list "�i�Ԗ���"  #hin 'STR)
        )
      )
    )
    (if (= nil #KIHON$$)
			(progn
				(if (= #UP_ID_1 "-")
					nil
					;else
      		(princ (strcat "\n" ",��," "[�K�w]�ɂ���[�i�Ԋ�{]�ɂȂ�" "," #hin) #fil)
				);_if
			)
    );_if

		;��ʊK�w��"9"�łȂ����[�i�Ԑ}�`]�̑����������s��
		(if (and (/= #UP_ID_1 "9")(/= #UP_ID_1 "-"))
			(progn
		    ;"%"�t������
		    (if (vl-string-search "%" #hin)
					(progn ;LR����

				    (setq #ZUKEI$$
				      (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
				        (list
				          (list "�i�Ԗ���"  #hin 'STR)
				          (list "LR�敪"    "L" 'STR)
				        )
				      )
				    )
				    (if (= nil #ZUKEI$$)
				      (princ (strcat "\n" ",��," "[�K�w]�ɂ���[�i�Ԑ}�`]�ɂȂ�" "," #hin "," "LR�敪=L") #fil)
				    );_if
						(if (and #ZUKEI$$ (= 1 (length #ZUKEI$$)))
							(progn
								(setq #zukeiID (nth 6 (car #ZUKEI$$)))
						    (if (or (= nil #zukeiID)(= "" #zukeiID))
						      (princ (strcat "\n" ",��,"  "[�i�Ԑ}�`]�ɐ}�`ID�Ȃ�" "," #hin "," "LR�敪=L") #fil)
									;else
									(progn
										(if (findfile (strcat CG_SKDATAPATH "MASTER\\" #zukeiID ".dwg"))
											nil
											;else
											(princ (strcat "\n" ",��,"  "MASTER�}�`�Ȃ�" "," #hin "," "LR�敪=L" "," #zukeiID ".dwg") #fil)
										);_if

										(if (findfile (strcat CG_SKDATAPATH "CRT\\" #zukeiID ".sld"))
											nil
											;else
											(princ (strcat "\n" ",��,"  "CRT�ײ�ނȂ�" "," #hin "," "LR�敪=L" "," #zukeiID ".sld") #fil)
										);_if
									)
						    );_if
							)
						);_if


				    (setq #ZUKEI$$
				      (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
				        (list
				          (list "�i�Ԗ���"  #hin 'STR)
				          (list "LR�敪"    "R" 'STR)
				        )
				      )
				    )
				    (if (= nil #ZUKEI$$)
				      (princ (strcat "\n" ",��," "[�K�w]�ɂ���[�i�Ԑ}�`]�ɂȂ�" "," #hin "," "LR�敪=R") #fil)
				    );_if
						(if (and #ZUKEI$$ (= 1 (length #ZUKEI$$)))
							(progn
								(setq #zukeiID (nth 6 (car #ZUKEI$$)))
						    (if (or (= nil #zukeiID)(= "" #zukeiID))
						      (princ (strcat "\n" ",��,"  "[�i�Ԑ}�`]�ɐ}�`ID�Ȃ�" "," #hin "," "LR�敪=R") #fil)
									;else
									(progn
										(if (findfile (strcat CG_SKDATAPATH "MASTER\\" #zukeiID ".dwg"))
											nil
											;else
											(princ (strcat "\n" ",��,"  "MASTER�}�`�Ȃ�" "," #hin  "," "LR�敪=R" "," #zukeiID ".dwg") #fil)
										);_if

										(if (findfile (strcat CG_SKDATAPATH "CRT\\" #zukeiID ".sld"))
											nil
											;else
											(princ (strcat "\n" ",��,"  "CRT�ײ�ނȂ�" "," #hin "," "LR�敪=R" "," #zukeiID ".sld") #fil)
										);_if
									)
						    );_if

							)
						);_if

					)
					(progn ;LR�Ȃ�

				    (setq #ZUKEI$$
				      (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
				        (list
				          (list "�i�Ԗ���"  #hin 'STR)
				          (list "LR�敪"    "Z" 'STR)
				        )
				      )
				    )
				    (if (= nil #ZUKEI$$)
				      (princ (strcat "\n" ",��," "[�K�w]�ɂ���[�i�Ԑ}�`]�ɂȂ�" "," #hin "," "LR�敪=Z") #fil)
				    );_if
						(if (and #ZUKEI$$ (= 1 (length #ZUKEI$$)))
							(progn
								(setq #zukeiID (nth 6 (car #ZUKEI$$)))
						    (if (or (= nil #zukeiID)(= "" #zukeiID))
						      (princ (strcat "\n" ",��,"  "[�i�Ԑ}�`]�ɐ}�`ID�Ȃ�" "," #hin "," "LR�敪=Z") #fil)
									;else
									(progn
										(if (findfile (strcat CG_SKDATAPATH "MASTER\\" #zukeiID ".dwg"))
											nil
											;else
											(princ (strcat "\n" ",��,"  "MASTER�}�`�Ȃ�" "," #hin "," "LR�敪=Z" "," #zukeiID ".dwg") #fil)
										);_if

										(if (findfile (strcat CG_SKDATAPATH "CRT\\" #zukeiID ".sld"))
											nil
											;else
											(princ (strcat "\n" ",��,"  "CRT�ײ�ނȂ�" "," #hin "," "LR�敪=Z" "," #zukeiID ".sld") #fil)
										);_if
									)
						    );_if

							)
						);_if


					)
				);_if

			)
		);_if
  );(foreach

  (princ "\n")
  (princ "\n" #fil)


  ;��[�i�Ԋ�{]�ɂ�����̂��A�K�w�ɓo�^����Ă��邩
  (princ (strcat "\n[�i�Ԋ�{]���K�w���������J�n"))
  (princ (strcat "\n[�i�Ԋ�{]���K�w���������J�n") #fil)

	(setq #kaiso_hin$  (mapcar 'car #hin$$))

  (setq #kihon$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "�i�Ԋ�{")))
  (setq #kihon_ALL$$ nil)
  (foreach #kihon$ #kihon$$
    (setq #kihon_hin (nth 0 #kihon$)) ;�i��
		;���p�A�S�p��߰�����[�i�Ԋ�{]
		(##CheckSpace #kihon_hin "[�i�Ԋ�{]")
    (if (member #kihon_hin #kaiso_hin$)
      nil ; OK
      ;else
      (princ (strcat "\n" ",��," "[�i�Ԋ�{]�ɂ���[�K�w]�ɂȂ�" "," #kihon_hin) #fil)
    );_if
  );foreach

  (princ "\n")
  (princ "\n" #fil)
  (princ (strcat "\n[�i�Ԋ�{]���K�w���������I��"))
  (princ (strcat "\n[�i�Ԋ�{]���K�w���������I��") #fil)
  (princ "\n")
  (princ "\n" #fil)

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n" #fil)

  (princ (strcat "\n������ �K�w�s���������I�� ������") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\�K�w�s����CHECK_" CG_SeriesDB ".csv"))
  (princ)
);C:KAISOCHECK


;;;<HOM>***********************************************************************
;;; <�֐���>    : C:DB_CONNECT
;;; <�����T�v>  : �ذ�ޕ�DB�Đڑ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      :;2012/04/23 YM ADD
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun C:DB_CONNECT ( / #rec$$ #RET)

	(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)
	(setq #ret (DBDisConnect CG_DBSESSION))
	(princ "\n�ذ�ޕ�DB��ؒf���܂���")
	(princ "\n�߂�l=")(princ #ret)

	(if #ret
		(progn ;����ؒf
			(setq CG_DBSESSION nil)

			(princ "\nCG_DBNAME= ")(princ CG_DBNAME)
			(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)
			(setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
			(princ "\n�ذ�ޕ�DB��ڑ����܂���")
			(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)

			(princ "\n�ڑ��e�X�g:�y���V���Y�z ")
			(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from ���V���Y")))

			(if #rec$$
				(progn
					(princ "\n��������ں��ވꗗ")
					(foreach #rec$ #rec$$
						(princ "\n")(princ #rec$)
					)
				)
				(progn
					; ARX�ă��[�h
				  (cond
				    ((= "19" CG_ACADVER)
				      (arxunload "asilispX19.arx")
				      (arxload "asilispX19.arx")
				    )
				    ((= "18" CG_ACADVER)
				      (arxunload "asilispX18.arx")
				      (arxload "asilispX18.arx")
				    )
				    ((= "17" CG_ACADVER)
				      (arxunload "asilispX17.arx")
				      (arxload "asilispX17.arx")
				    )
				    ((= "16" CG_ACADVER)
				      (arxunload "asilisp16.arx")
				      (arxload "asilisp16.arx")
				    )
				  );_cond

					(setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
					(princ "\n�ذ�ޕ�DB��ڑ����܂���")
					(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)
					(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from ���V���Y")))
					(princ "\n��������ں��ވꗗ")
					(foreach #rec$ #rec$$
						(princ "\n")(princ #rec$)
					)
				)
			);_if

		)
		(progn
			(CFAlertErr (strcat "DB�𐳏�ɐؒf�ł��܂���BKPCAD�𒆒f�I����A�ċN�����Ă��������B"
													"\n���f�I���ł��Ȃ��ꍇ�́Aquit[Enter]�ŋ����I�����Ă�������"))
		)
	);_if

	(princ)
);C:DB_CONNECT

;;;<HOM>***********************************************************************
;;; <�֐���>    : C:DB_DISCONNECT
;;; <�����T�v>  : �ذ�ޕ�DB�ؒf
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      :;2012/04/23 YM ADD
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun C:DB_DISCONNECT ( / #rec$$ #ret)

	(princ "\nCG_DBNAME= ")(princ CG_DBNAME)
	(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)

	(setq #ret (DBDisConnect CG_DBSESSION))
	(princ "\n�ذ�ޕ�DB��ؒf���܂���")
	(princ "\n�߂�l=")(princ #ret)

	(setq CG_DBSESSION nil)
	(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)

	(princ "\n�ڑ��e�X�g:�y���V���Y�z ")
	(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from ���V���Y")))
	(foreach #rec$ #rec$$
		(princ "\n")(princ #rec$)
	)
	(princ)
);C:DB_DISCONNECT



;;;<HOM>***********************************************************************
;;; <�֐���>    : C:DB_SEARCH_SPEED
;;; <�����T�v>  : �i�ԍŏI�������x
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      :;2012/06/01 YM ADD
;;; <���l>      :
;;;***********************************************************************>HOM<
(defun C:DB_SEARCH_SPEED (
	/
	#rec$$ #ret #DATE_TIME #FIL #HINBAN$ #OFILE #QRY$
)

	(setq #start (* 86400 (getvar "TDINDWG")));�J�n����

  (setq #ofile  (strcat CG_SYSPATH "tmp\\�������x.txt"));�������ʏo��̧��
  (setq #fil (open #ofile "W" ))

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));���t
  (princ #date_time #fil) ; ���t��������

  (princ "\n" #fil)
  (princ "\n--- �J�n ---" #fil)
  (princ "\n" #fil)


	(setq #hinban$ 
		(list
			"H$45U3A-JN#-@@(E)"
			"H$45U3A-JN#-@@"
			"H$45U3A-IN#-@@"
			"H$45TGA-QN#-@@"
			"H$45T3A-IN#-@@"
			"H$45T3A-QN#-@@"
			"H$45TQA-JN#-@@"
			"H$45U3N-CN#-@@"
			"H$45T3A-JN#-@@(E)"
			"H$30UQA-JN#-@@"
			"H$45UQA-JN#-@@"
			"H$60T3A-JN#-@@"
			"H$60T3A-JN#-@@(E)"
			"H$60T3A-QN#-@@"
			"H$30TGA-QN#-@@"
			"H$45T3N-JN#-@@"
			"H$45T3N-CN#-@@"
			"H$60T3N-JN#-@@"
			"H$75T3N-JN#-@@"
			"H$75T3N-CN#-@@"
			"H$30T3S-JN#-@@"
			"H$45T3S-JN#-@@"
			"H$60T3S-JN#-@@"
			"H$75T3S-JN#-@@"
			"H$45T3A-JN#-@@"
			"H$30TQA-JN#-@@"
			"H$60T3A-IN#-@@"
			"H$30U3A-JN#-@@"
			"H$30U3A-JN#-@@(E)"
			"H$30U3A-IN#-@@"
			"H$30U3N-CN#-@@"
			"H$75T3A-JN#-@@(E)"
			"H$30T3B-JN#-@@"
			"H$45YNA-JN#-@@(E)"
			"H$60U3A-IN#-@@"
			"H$45YQA-JN#-@@"
			"H$45XQA-JN#-@@"
			"H$45YPA-QN#-@@"
			"H$45YNB-JN#-@@"
			"H$45YNS-JN#-@@"
			"H$45YNN-CN#-@@"
			"H$45YNN-JN#-@@"
			"H$60XNA-JN#-@@(E)"
			"H$45YNA-QN#-@@"
			"H$60XNA-IN#-@@"
			"H$45YNA-JN#-@@"
			"H$30T3N-CN#-@@"
			"H$45XNN-CN#-@@"
			"H$60U3A-JN#-@@(E)"
			"H$75U3A-IN#-@@"
			"H$75UQA-JN#-@@"
			"H$45XNA-IN#-@@"
			"H$45XNA-JN#-@@(E)"
			"H$45XNA-JN#-@@"
			"H$45YNA-IN#-@@"
			"HS$FBM-@@"
			"H$60TQA-JN#-@@"
			"H$60U3A-JN#-@@"
			"H$75T3A-JN#-@@"
			"H$75T3A-QN#-@@"
			"H$75T3A-IN#-@@"
			"H$75T3B-JN#-@@"
			"H$75TGA-QN#-@@"
			"H$75TQA-JN#-@@"
			"H$60XNA-JN#-@@"
			"H$75U3A-JN#-@@(E)"
			"H$60TGA-QN#-@@"
			"HS$FBM-U-@@"
			"HS$FBM-U-@@(D700)"
			"H$60YQA-JN#-@@"
			"H$60XQA-JN#-@@"
			"H$60YPA-QN#-@@"
			"H$60YNA-IN#-@@"
			"H$60YNA-QN#-@@"
			"H$60YNA-JN#-@@(E)"
			"H$60YNA-JN#-@@"
			"H$75U3A-JN#-@@"
			"H$30T3N-JN#-@@"
			"H$15U1N-IN#-@@"
			"H$60UQA-JN#-@@"
			"H$30T3A-JN#-@@"
			"H$30T3A-JN#-@@(E)"
			"H$30T3A-QN#-@@"
			"H$30T3A-IN#-@@"
			"H$15B1N-JN#-@@"
			"H$15B1N-JN#-@@(E)"
			"H$15B1N-QN#-@@"
			"H$15B1N-IN#-@@"
			"H$15U1N-JN#-@@(E)"
			"H$15U1N-JN#-@@"
			"H$A5RHB-IN#-@@"
			"H$A5RHB-JN#-@@(E)"
			"H$A5RHB-JN#-@@"
			"H$90SRN-QN-@@(���ٕt)"
			"H$90SRN-JN-@@(���ٕt)"
			"H$90SRN-IN-@@"
			"H$90RHN-CN#-@@"
			"H$90SRN-JN-@@"
			"H$A5RRN-IN-@@"
			"H$90S2N-CN#-@@"
			"H$90S2S-JN#-@@"
			"H$90S2N-JN#-@@"
			"H$90S2A-IN#-@@"
			"H$90S2A-QN#-@@"
			"H$90S2A-JN#-@@(E)"
			"H$90RRN-JN-@@(���ٕt)"
			"H$90RRN-JN-@@"
			"H$90RHB-IN#-@@"
			"H$90SRN-QN-@@"
			"H$B0RHN-CN#-@@"
			"H$A5SRN-QN-@@(���ٕt)"
			"H$A5SRN-JN-@@(���ٕt)"
			"H$A5SRN-IN-@@"
			"H$A5SRN-QN-@@"
			"H$A5SRN-JN-@@"
			"H$A5RRN-JN-@@"
			"H$A5S2N-CN#-@@"
			"H$A5S2B-JN#-@@"
			"H$A5S2S-JN#-@@"
			"H$A5S2N-JN#-@@"
			"H$A5S2A-IN#-@@"
			"H$A5S2A-QN#-@@"
			"H$A5S2A-JN#-@@(E)"
			"H$A5S2A-JN#-@@"
			"H$A5RRN-JN-@@(���ٕt)"
			"H$90RRN-IN-@@"
			"H$90RHB-JN#-@@"
			"H$75RHN-CN#-@@"
			"H$75S2N-CN#-@@"
			"H$90S2A-JN#-@@"
			"H$90RHB-JN#-@@(E)"
			"H$60G2A-JN#-@@"
			"H$60FHB-JN#-@@(E)"
			"H$60FHB-JN#-@@"
			"H$60G2A-JN#-@@(E)"
			"H$80CHN-QN#-@@"
			"R$60S0N-MN#-@@"
			"R$90SSS-MN#-@@"
			"R$75SSS-MN#-@@"
			"R$90SSN-MN#-@@"
			"R$60S4B-RN#-@@"
			"R$60S0S-MN#-@@"
			"R$75S4B-RN#-@@"
			"R$90S4B-RN#-@@"
			"R$45S4B-MN#-@@"
			"R$60S4B-MN#-@@"
			"R$75SSN-MN#-@@"
			"R$90S1B-MN#-@@"
			"R$75S1B-MN#-@@"
			"R$75S1B-LN#-@@"
			"R$45S4B-RN#-@@"
			"R$90S1B-MN#-@@(�޽�J42)"
			"R$90S1B-LN#-@@(�޽�J42)"
			"R$75S1B-MN#-@@(�޽�J42)"
			"R$90S0N-MN#-@@"
			"R$75S0S-MN#-@@"
			"R$75S0N-MN#-@@"
			"R$90S0C-PN#-@@"
			"R$60S0B-PN#-@@"
			"R$45S3B-LN#-@@"
			"R$75S4B-MN#-@@"
			"R$90S0S-MN#-@@"
			"R$75S3B-PN#-@@"
			"HS$B075M-@@-T10"
			"R$60PHB-JN#-@@(��߰���t)"
			"HS$B075M-@@-T19"
			"R$90PHB-JN#-@@(��߰���t)"
			"HS$B090M-@@-T10"
			"R$60PHB-JN#-@@"
			"R$75PHB-JN#-@@"
			"R$90PHB-JN#-@@"
			"HS$BK90M-@@-T18"
			"HS$BK75M-@@-T18"
			"HS$BK90M-@@-T10"
			"HS$BK75M-@@-T10"
			"R$75PHB-JN#-@@(��߰���t)"
			"R$75S3B-LN#-@@"
			"R$45S3B-PN#-@@"
			"R$60S3B-PN#-@@"
			"R$75S0B-PN#-@@"
			"R$90S3B-PN#-@@"
			"R$75S0C-PN#-@@"
			"R$45S3B-MN#-@@"
			"HS$B075M-@@-T18"
			"R$60S3B-MN#-@@"
			"R$90S4B-MN#-@@"
			"R$75S3B-MN#-@@"
			"R$75S1B-LN#-@@(�޽�J42)"
			"R$60S1B-MN#-@@"
			"HS$B105M-@@-T18"
			"HS$B105M-@@-T19"
			"HS$B090M-@@-T19"
			"HS$B090M-@@-T18"
			"R$60S3B-LN#-@@"
			"R$90S1B-LN#-@@"
			"R$60D2B-MN#-@@"
			"R$90D2B-MN#-@@"
			"R$90S1B-PN#-@@"
			"R$75S1B-PN#-@@"
			"R$90S1B-PN#-@@(�޽�J42)"
			"R$75SKB-MN#-@@"
			"R$60S1B-PN#-@@"
			"R$75S2B-RN#-@@(�޽�J42)"
			"R$90S0B-PN#-@@"
			"R$90S3B-MN#-@@"
			"R$90S0B-LN#-@@"
			"R$60SSB-MN#-@@"
			"R$90SSB-MN#-@@"
			"R$60SKB-MN#-@@"
			"R$75S1B-PN#-@@(�޽�J42)"
			"R$75S2B-MN#-@@(�޽�J42)"
			"R$60S1B-LN#-@@"
			"R$75S0B-MN#-@@"
			"R$75S0B-LN#-@@"
			"R$60S0B-MN#-@@"
			"R$60S0B-LN#-@@"
			"R$90S2B-MN#-@@"
			"R$90S0B-MN#-@@"
			"R$90S2B-MN#-@@(�޽�J42)"
			"R$60S2B-RN#-@@"
			"R$60S2B-MN#-@@"
			"R$90S2B-RN#-@@"
			"R$75S2B-RN#-@@"
			"R$90S2B-RN#-@@(�޽�J42)"
			"R$90S3B-LN#-@@"
			"R$75SSB-MN#-@@"
			"R$75S2B-MN#-@@"
			"R$75PTN-HN-@@"
			"R$90PHB-HN#-@@(��߰���t)"
			"R$75PHB-HN#-@@(��߰���t)"
			"R$60PHB-HN#-@@(��߰���t)"
			"R$A5PTN-HN-@@"
			"R$A5PTN-BN-@@"
			"R$60PHB-BN#-@@"
			"R$90PTN-BN-@@"
			"R$60PHB-HN#-@@"
			"R$75PTN-BN-@@"
			"R$A5PTN-HN-@@(��߰���t)"
			"R$90PTN-HN-@@(��߰���t)"
			"R$75PTN-HN-@@(��߰���t)"
			"R$90PHB-UN#-@@"
			"R$75PHB-UN#-@@"
			"R$90PTN-HN-@@"
			"R$90SBN-MN#-@@"
			"R$60SBN-MN#-@@(�޽�JE1)"
			"R$75PHB-BN#-@@"
			"R$75PHB-HN#-@@"
			"R$90PHB-BN#-@@"
			"R$75SBN-MN#-@@(�޽�JE2)"
			"R$90PHB-HN#-@@"
			"R$90SBN-MN#-@@(�޽�JE3)"
			"R$90SKB-MN#-@@"
			"R$60SBN-MN#-@@"
			"R$75SBN-MN#-@@"
			"H$75W3B-9N#-@@"
			"H$60W3B-9N#-@@"
			"H$90W3B-9N#-@@"
			"HS$FW7P-@@"
			"H$90WHB-5N#-@@"
			"H$60W3B-5N#-@@"
			"HS$FW9J-@@"
			"HS$FW7J-@@"
			"HS$FW9P-@@"
			"HS$FW5-@@"
			"HS$FW5P-@@"
			"HS$FW9F-@@"
			"HS$FW7F-@@"
			"HS$FW5F-@@"
			"HS$FW9-@@"
			"HS$FW7-@@"
			"HS$FW5J-@@"
			"R$75WHN-MN#-@@"
			"R$60WHN-MN#-@@"
			"R$90UHB-MN#-@@"
			"R$75UHB-LN#-@@"
			"R$90WHN-MN#-@@"
			"R$75UHB-MN#-@@"
			"R$60UHB-MN#-@@"
			"R$90WHB-MN#-@@"
			"R$75WHB-MN#-@@"
			"R$60WHB-MN#-@@"
			"R$60W3B-MN#-@@"
			"R$75URB-LN#-@@"
			"R$60URB-LN#-@@"
			"R$75W1B-MN#-@@"
			"R$90W1B-MN#-@@"
			"R$90UHB-LN#-@@"
			"R$90W2B-MN#-@@"
			"R$75W3B-MN#-@@"
			"R$90W3B-MN#-@@"
			"R$90UHN-MN#-@@"
			"R$75UHN-MN#-@@"
			"R$60UHN-MN#-@@"
			"R$75W2B-MN#-@@"
			"H$90WHB-9N#-@@"
			"H$90WDB-7N#-@@"
			"H$90WHN-7N#-@@"
			"H$90WHN-9N-@@"
			"H$90WLB-7N#-@@"
			"H$90WHN-5N-@@"
			"H$90WLN-7N-@@"
			"H$90WHB-9N-@@"
			"H$90WDN-7N-@@"
			"H$90WHN-7N-@@"
			"H$90W2B-7N#-@@"
			"H$90W3B-5N#-@@"
			"H$75W2B-5N#-@@"
			"H$90W2B-5N#-@@"
			"H$60W3B-7N#-@@"
			"H$75W3B-7N#-@@"
			"H$90WLB-7N-@@"
			"H$75W2B-7N#-@@"
			"H$90WHB-5N-@@"
			"H$75W1B-7N#-@@"
			"H$75W3B-5N#-@@"
			"H$90WHB-7N#-@@"
			"R$60UHB-LN#-@@"
			"H$90W1B-7N#-@@"
			"H$90W3B-7N#-@@"
			"H$90WHB-7N-@@"
			"H$75WHB-5N#-@@"
			"H$75WHB-5N-@@"
			"H$60WHN-9N-@@"
			"H$60WHN-7N-@@"
			"H$75WHB-7N-@@"
			"H$60WHB-9N#-@@"
			"H$75WHB-7N#-@@"
			"H$60WHB-9N-@@"
			"H$60WHB-7N#-@@"
			"H$60WHB-7N-@@"
			"H$60WHB-5N#-@@"
			"H$60WHB-5N-@@"
			"H$60WHN-5N-@@"
			"H$75WHB-9N#-@@"
			"H$75WLB-7N#-@@"
			"H$75WLB-7N-@@"
			"H$75WHN-7N#-@@"
			"H$75WHN-5N-@@"
			"H$90WDB-7N-@@"
			"H$75WHB-9N-@@"
			"H$75WHN-7N-@@"
			"R$90NHN-MN#-@@"
			"R$75NHN-MN#-@@"
			"R$60NHN-MN#-@@"
			"R$60NHB-MN#-@@"
			"H$D0WYN-YN-@@"
			"H$C5WYN-YN-@@"
			"R$90NHB-LN#-@@"
			"H$F0WYN-YN-@@"
			"R$90NHB-MN#-@@"
			"R$75NHB-MN#-@@"
			"R$75NHB-LN#-@@"
			"R$60NHB-LN#-@@"
			"H$90WYN-YN-@@"
			"R$90N3B-MN#-@@"
			"R$60N3B-LN#-@@"
			"R$75N3B-LN#-@@"
			"R$90N3B-LN#-@@"
			"R$60N3B-MN#-@@"
			"R$75N3B-MN#-@@"
		)
	)

	(foreach #hinban #hinban$
		
	 	;�i��,LR,���,���,˷�
		(setq #qry$
		 	(CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
				(list
					(list "�i�Ԗ���"    #hinban      'STR)
					(list "LR�敪"      "Z"          'STR)
					(list "���V���L��" CG_DRSeriCode 'STR)
					(list "���J���L��" CG_DRColCode  'STR)
					(list "����L��"   CG_Hikite     'STR)
				)
			)
		)
		(if (= 1 (length #qry$))
			(progn
				(princ (strcat "\n" (nth 10 (car #qry$)) ))
			)
		);_if
		

	);foreach


	(setq #end (* 86400 (getvar "TDINDWG")));�I������
	(setq #time (rtos (- #end #start)));����
	(princ (strcat "\n����= " #time))
	(princ (strcat "\n����= " #time) #fil)


  (princ "\n" #fil)
  (princ "\n--- �I�� ---" #fil)
  (princ "\n" #fil)

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));���t
  (princ #date_time #fil) ; ���t��������


	(if #fil (close #fil))

	(startapp "notepad.exe" #ofile)
  (princ)


);C:DB_SEARCH_SPEED

;<HOM>************************************************************************
; <�֐���>    : mdb_dwg_zukei_size_check
; <�����T�v>  : [�i�Ԑ}�`]��GSM�}�`�ƂŃT�C�Y���r����
; <�߂�l>    :
; <�쐬>      : 2012/07/20 YM ADD
; <���l>      :
;************************************************************************>MOH<
(defun C:mdb_dwg_zukei_size_check (
 	/
	#FIL #FLG #FULLPATH #HIN #I #LR #NAME #PATH #QRY$$ #REC$$ #SKK #SS_SYM #SYM #XD$ #ZUKEIID #ZUKEI
	#GSM_D #GSM_H #GSM_W #MDB_D #MDB_H #MDB_LR #MDB_W #DATE_TIME
	)
	; ۸�̧��OPEN
  (setq #fil (open (strcat CG_SYSPATH "\\log\\mdb_dwg_zukei_size_check.csv") "a" ))

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n" #fil)
	(princ (strcat "\n----------------------------------------") #fil)
	(princ (strcat "\n[�i�Ԑ}�`]��GSM�}�`�ƂŃT�C�Y���r���� ") #fil)
	(princ (strcat "\n----------------------------------------") #fil)
  (princ "\n" #fil)
	;ͯ�ް
  (princ "\n�}�`ID,�i�Ԗ���,LR�敪,���iCODE,mdb_W,mdb_D,mdb_H,GSM_W,GSM_D,GSM_H" #fil)



	;�i�Ԋ�{ ���i����="1??"�̂��̂𒊏o
	(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �i�Ԗ���,LR�L��,���iCODE from �i�Ԋ�{ where ���iCODE > 100 and ���iCODE < 199")))

	(foreach #rec$ #rec$$
		(setq #hin (nth 0 #rec$))
		(setq #LR  (nth 1 #rec$))
		(setq #skk (nth 2 #rec$))
		;�i�Ԑ}�`����
    (setq #qry$$
    	(CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
        (list
          (list "�i�Ԗ���" #hin 'STR)
        )
      )
    )
		(if #qry$$
			(progn ;2��HIT����\������
				(foreach #qry$ #qry$$
					(setq #mdb_LR (nth 1 #qry$)) ;LR
					(setq #mdb_W  (nth 3 #qry$)) ;W
					(setq #mdb_D  (nth 4 #qry$)) ;D
					(setq #mdb_H  (nth 5 #qry$)) ;H
					(setq #zukeiID (strcat (nth 6 #qry$))) ;�}�`ID
					(setq #zukei   (strcat "'" (nth 6 #qry$))) ;�}�`ID

					(setq #fullpath (strcat CG_MSTDWGPATH #zukeiID ".dwg"))
		      (if (findfile #fullpath)
						(progn
							;̧�ٵ����
							(if (/= (getvar "DBMOD") 0)
								(command "_OPEN" "Y" #fullpath)
								;else
								(command "_OPEN" #fullpath)
							);END IF

							(setq #path (getvar "DWGPREFIX"))
						  (setq #name (getvar "DWGNAME")) ; ���݂�̧�ٖ�
						  (princ (strcat "\n" #zukei "," #hin "," #mdb_LR ",") #fil)(princ #skk #fil)(princ "," #fil)

							;"G_SYM"����
							(setq #ss_SYM (ssget "X" '((-3 ("G_SYM")))))

						  (if (and #ss_SYM (= 1 (sslength #ss_SYM)))
								(progn
									(setq #i 0)
							    (setq #sym (ssname #ss_SYM #i))
									(setq #xd$ (CFGetXData #sym "G_SYM"))
									(setq #GSM_W (nth 3 #xd$)) ;W
									(setq #GSM_D (nth 4 #xd$)) ;D
									(setq #GSM_H (nth 5 #xd$)) ;H

						  		(princ #mdb_W #fil)(princ "," #fil)
									(princ #mdb_D #fil)(princ "," #fil)
									(princ #mdb_H #fil)(princ "," #fil)
						  		(princ #GSM_W #fil)(princ "," #fil)
									(princ #GSM_D #fil)(princ "," #fil)
									(princ #GSM_H #fil)

									;����v
									(if (not (equal #mdb_W #GSM_W 0.1))
										(princ ",���@W�l���قȂ�" #fil)
									);_if

									;����c
									(if (not (equal #mdb_D #GSM_D 0.1))
										(princ ",���@D�l���قȂ�" #fil)
									);_if

									;����g
									(if (not (equal #mdb_H #GSM_H 0.1))
										(princ ",���@H�l���قȂ�" #fil)
									);_if

									(setq #i (1+ #i))
								)
								(progn ;G_SYM���Ȃ����A�܂��́A�������݂���
									(princ (strcat "�������@G_SYM���Ȃ����A�܂��́A�������݂���: �}�`ID=" #zukei) #fil)
								)
							);_if

						)
						(progn
							(princ (strcat "\n�������@DWĢ�ق�����܂���: �}�`ID=" #zukei) #fil)
						)		        
		      );_if

				)
			)
			(progn
				(princ (strcat "\n�������@�i�Ԑ}�`��ں��ނ�����܂���: �i�Ԗ���=" #hin) #fil)
			)
		);_if


	);foreach

	(close #fil)
	(princ)
);mdb_dwg_zukei_size_check



;;;<HOM>*************************************************************************
;;; <�֐���>    : C:CG_DOOR_MASTER_CHECK
;;; <�����T�v>  : �y���\���zð��ق�ں��ޘR�������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2012/08/08 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:CG_DOOR_MASTER_CHECK (
  /
	#DATE_TIME #DOORID$$ #DOORID1 #DOORID2 #DRMASTER$$ #FIL #HINBAN #HINBAN$$ #LR
	#ZUKEI$$ #ZUKEIID #DRMASTER$ #I #LOOP #OK
  )
  (setq #fil (open (strcat CG_SYSPATH "LOG\\���\��ð���CHECK.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n" #fil)

	;�y�i�ԃV���z�Ώەi��
	(setq #hinban$$ nil)
	;�y�i�ԃV���z����,���}�`ID��null�łȂ��Ώەi�Ԃ̂�(�d���폜)�𒊏o
	(setq #hinban$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select distinct �i�Ԗ��� from �i�ԃV�� where ���}�`ID is not null")))

	(foreach #hinban$ #hinban$$
		(setq #hinban (car #hinban$))
		;�y�i�Ԑ}�`�z
		(setq #zukei$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select LR�敪,�}�`ID from �i�Ԑ}�` where �i�Ԗ��� = '" #hinban "'")))
		;2���̏ꍇ����
		(foreach #zukei$ #zukei$$
			;(LR�敪,�}�`ID)
			(setq #LR      (nth 0 #zukei$))
			(setq #zukeiID (nth 1 #zukei$))

			;�y�i�ԃV���z
			(setq #doorID$$ (DBSqlAutoQuery CG_DBSESSION
												(strcat "select ���}�`ID from �i�ԃV�� where �i�Ԗ��� = '" #hinban "' and LR�敪 = '" #LR "'" )))
			;��\�y�i�ԃV���z
			(setq #doorID1 (car (car #doorID$$))) ;0471111
			(setq #doorID1 (strcat (substr #doorID1 1 5) "*"))

			;�y���\���z���݊m�F
			(setq #drMASTER$$ (DBSqlAutoQuery CG_DBSESSION
												(strcat "select ���}�`ID from ���\�� where �}�`ID = '" #zukeiID "'" )))

			;��\�y���\���z
			(if #drMASTER$$
				(progn
					(setq #loop T)
					(setq #i 0)
					(setq #OK nil); ;���Ȃ�
					(while (and #loop (< #i (length #drMASTER$$)))
						(setq #drMASTER$ (nth #i #drMASTER$$))
						(setq #doorID2 (car #drMASTER$)) ;0471111
						(if (wcmatch #doorID2 #doorID1)
							(progn
								(setq #loop nil);ٰ�߂��甲����
								(setq #OK T); ;���Ȃ�
							)
						);_if

						(setq #i (1+ #i))
					);while

					(if #OK
						nil
						;else
						;�װ�o��
						(princ (strcat "\n*** Record����ϯ����Ȃ�: �i�Ԗ���= " #hinban ",LR�敪= " #LR ",�y�i�ԃV���z���}�`ID= " #doorID1 ",�}�`ID= " #zukeiID ) #fil)
					);_if

				)
				(progn ;�y���\���z�ɂȂ�
						;�װ�o��
						(princ (strcat "\nxxx Record�Ȃ�   �@�@�@: �i�Ԗ���= " #hinban ",LR�敪= " #LR ",�y�i�ԃV���z���}�`ID= " #doorID1 ",�}�`ID= " #zukeiID ) #fil)
				)				
			);_if

		);foreach

	);foreach


  (princ (strcat "\n---�I��") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\���\��ð���CHECK.txt"))
  (princ)

	;like����"%"ܲ��޶���
	;(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �i�Ԗ��� from �i�ԃV�� where ���}�`ID like '04711%'")))
	;null����
	;(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �Ԍ��L�� from �Ԍ� where �Ԍ� is null ")))
	;null�����d���폜	
	;(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select distinct �Ԍ��L�� from �Ԍ� where �Ԍ� is null ")))
	;ں��޿��
	;(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select ID,�Ԍ��L�� from �Ԍ� where �Ԍ� is null ORDER BY ID")))

);C:CG_DOOR_MASTER_CHECK

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:Change_SKK
;;; <�����T�v>  : ���i�R�[�h��ύX����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2013/05/17 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:Change_SKK (
  /
	#EN #SKK #SYM #XD$
  )
  (setq #en (car (entsel)))

  (if (= #en nil)
    (progn
      (CFAlertErr "���ނ��I������܂���ł���")(quit)
    )
    (progn
      (setq #sym (SearchGroupSym #en)) ; ����ِ}�`��
    )
  );_if

  (if (= #sym nil)
    (progn
      (CFAlertErr "\"G_LSYM\"������܂���")(quit)
    )
    (progn

			(setq #skk (getstring "\n�V�������i���ނ����: "))
			(setq #skk (atoi #skk ))

      (setq #xd$ (CFGetXData #sym "G_LSYM"))
      (setq #xd$
        (CFModList #xd$
          (list
            (list 9 #skk)
          )
        )
      )
      (CFSetXData #sym "G_LSYM" #xd$)
		)
	);_if

	(princ)
);C:Change_SKK

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:CG_Info
;;; <�����T�v>  : �I�������}�`��CG�s������ɕK�v�ȏ����擾(���\��)
;;; <�쐬>      : 2013/08/19 �C�� YM
;;;*************************************************************************>MOH<

;;;-----------------------------------------------------------------
;;;[0]:G_LSYM ����ي�_                       G_LSYM
;;;[1]:�{�̐}�`ID    :10�޲�(dwģ�ٖ�)         (1000 . 0210812)
;;;[2]:�}���_        :�z�u��_ x,y,z            (1010 770.0 0.0 0.0)
;;;[3]:��]�p�x      :׼ޱ�                     (1040 . 0.0)
;;;[4]:�H��L��      :2�޲�                     (1000 . K)
;;;[5]:�ذ�ދL��     :2�޲�                     (1000 . S)
;;;[6]:�i�Ԗ���      :20�޲�                    (1000 . H$45U3A-IN#-@@)
;;;[7]:L/R�敪       :Z,L,R                     (1000 . Z)
;;;[8]:���}�`ID      :10�޲�                    (1000 . MJ,H_M,X)
;;;[9]:���J���}�`ID  :10�޲�                    (1000 . 0210812)
;;;[10]:���i����      :�i�ԏ��̐��i����        (1070 . 111)
;;;[11]:�����׸�      :0(�P��),1(����),2(OP����) (1070 . 0)
;;;[12]:�z�u���ԍ�    :�z�u���ԍ�(1�`)           (1070 . 0)
;;;[13]:�p�r�ԍ�      :0�`99                     (1070 . 0)
;;;[14]:���@�g        :�i�Ԑ}�`DB�̓o�^H���@�l   (1070 . 813)
;;;[15]:�f�ʎw���L��  :0(�Ȃ�),1(����)           (1070 . 0)
;;;[16]:����          :�L�b�`��(A) or ���[(D)    (1000 . A)
;;; -----------------------------------------------------------------
;;;[0]:G_SYM                                    G_SYM
;;;[1]:����ٖ���                                (1000 . S-45PPXB5)
;;;[2]:���ĂP                                   (1000 . )
;;;[3]:���ĂQ                                   (1000 . )
;;;[4]:����ي�lW                             (1040 . 450.0)
;;;[5]:����ي�lD                             (1040 . 650.0)
;;;[6]:����ي�lH                             (1040 . 813.0)
;;;[7]:����َ�t����                            (1040 . 0.0)
;;;[8]:���͕��@                                 (1070 . 3)
;;;[9]:W�����׸�                                (1070 . 1)
;;;[10]:D�����׸�                                (1070 . 1)
;;;[11]:H�����׸�                                (1070 . 1)
;;;[12]:�L�k�׸�W                                (1070 . 0)
;;;[13]:�L�k�׸�D                                (1070 . 0)
;;;[14]:�L�k�׸�H                                (1070 . 0)
;;;[15]:��ڰ�ײݐ�W                              (1070 . 0)
;;;[16]:��ڰ�ײݐ�D                              (1070 . 0)
;;;[17]:��ڰ�ײݐ�H                              (1070 . 0)
;;; -----------------------------------------------------------------
;;;���}ID=DR0410312

(defun c:CG_Info(
  /
	#DD #DRCOL #DRHIKI #DRID #DRINFO #DRINFO$ #DRSERI #EN #ET #HH
	#HINBAN #LR #QRY$$ #WW #XD_LSYM #XD_SYM #ZUKEI #SYM #XD_LSYM$ #XD_SYM$
	#GSM_D #GSM_H #GSM_W #I ;2013/11/07 YM ADD
  )
	;���ވꗗ
;;;	(C:BUZAILIST)

  (setq #iseri (strcat CG_SYSPATH "texture_path.txt"));ø����̌����p�X
  (setq #path$ (ReadCSVFile #iseri))
	(setq #path (car (car #path$)))

	(princ "\n")
	(princ "\n")
	(princ "\n")
	
  (setq #en (car (entsel)))

  (if (= #en nil)
    (progn
      (CFAlertErr "���ނ��I������܂���ł���")
			(quit)
    )
    (progn
      (setq #sym (SearchGroupSym #en)) ; ����ِ}�`��
    )
  );_if

  (if (= #sym nil)
    (progn
      (CFAlertErr "\"G_LSYM\"������܂���")
			(quit)
    )
    (progn
;;;      (setq #et (entget #sym))

			(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
			(setq #xd_SYM$  (CFGetXData #sym "G_SYM"))

			(setq #GSM_W (nth 3 #xd_SYM$)) ;GSM_W
			(setq #GSM_D (nth 4 #xd_SYM$)) ;GSM_D
			(setq #GSM_H (nth 5 #xd_SYM$)) ;GSM_H

			(setq #zukei  (nth 0 #xd_LSYM$)) ;�{�̐}�`ID "0210812"
			(setq #hinban (nth 5 #xd_LSYM$)) ;�i�Ԗ���
			(setq #LR     (nth 6 #xd_LSYM$)) ;LR�敪
			(setq #DrInfo (nth 7 #xd_LSYM$)) ;�����
	    (setq #DrInfo$ (strparse #DrInfo ","))
			(if (= #DrInfo "")
				(progn
					;�@��ނȂ�
					(setq #DRSeri "")
					(setq #DRCol  "")
					(setq #DRHiki "")
				)
				(progn
					(setq #DRSeri (nth 0 #DrInfo$))
					(setq #DRCol  (nth 1 #DrInfo$))
					(setq #DRHiki (nth 2 #DrInfo$))
				)
			);_if

			;�������@�i�Ԑ}�`�@������
		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
		      (list
		        (list "�i�Ԗ���"    #hinban       'STR)
		        (list "LR�敪"      #LR           'STR)
		      )
		    )
		  )
			(if (= nil #qry$$)
				(progn
		      (setq #WW "�Ȃ�") ;450.0
		      (setq #DD "�Ȃ�")
		      (setq #HH "�Ȃ�")
				)
				(progn
		      (setq #WW (itoa (fix (+ (nth 3 (car #qry$$)) 0.001))));450.0
		      (setq #DD (itoa (fix (+ (nth 4 (car #qry$$)) 0.001))))
		      (setq #HH (itoa (fix (+ (nth 5 (car #qry$$)) 0.001))))
				)
			);_if

			;�������@�i�ԃV���@������
		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
		      (list
		        (list "�i�Ԗ���"    #hinban 'STR)
		        (list "LR�敪"      #LR     'STR)
		        (list "���V���L��"  #DRSeri 'STR)
		        (list "����L��"    #DRHiki 'STR)
		      )
		    )
		  )
			(if (= nil #qry$$)
				(progn
					(princ "\n �i�ԃV���Ȃ�")
      		(setq #drid "���}�`ID�Ȃ�")
				)
				(progn
      		(setq #drid (nth 4 (car #qry$$)));"0410329"
					(if (= #drid nil)(setq #drid ""))
				)
			);_if

		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "���\��"
		      (list
		        (list "���}�`ID"    #drid  'STR)
		        (list "�}�`ID"      #zukei 'STR)
		      )
		    )
		  )


      (princ "\n**************************************************************************" )
      (princ "\n��CG�֘A���o�́�" )
      (princ "\n--------------------------------------------------------------------------" )
			(princ "\n���\�� �������}�`ID =")(princ #drid)
			(princ "\n���\�� �����@�}�`ID =")(princ #zukei)

			(princ "\n�����  =")(princ #DrInfo)
			(princ "\n���V���L��=")(princ #DRSeri)
			(princ "\n���J���L��=")(princ #DRCol)
			(princ "\n����L���@=")(princ #DRHiki)
      (princ "\n--------------------------------------------------------------------------" )
			(princ "\n [���\��]")
      (princ "\n--------------------------------------------------------------------------" )
      (princ "\n���}�`ID,�}�`ID,�\�t��,�Ԍ�,����,����,X,Y,W,H,������,�y���,�����,���ʒu,���V���[�Y,���J���[" )
      (princ "\n--------------------------------------------------------------------------" )
			(if (= nil #qry$$)
				(progn
					(princ "\n�������@���\���Ȃ��@������")
				)
				(progn
					(foreach #qry$ #qry$$
						;0160709_0500202_03_0300_0520_01_LB.jpg
						(setq #DR_ID  (nth 0 #qry$))
						(setq #ZU_ID  (nth 1 #qry$))
						(setq #MEN_ID (itoa (fix (nth 2 #qry$))))
						(setq #WW     (itoa (fix (nth 3 #qry$))))
						(cond
							((= 2 (strlen #WW))
							 	(setq #WW (strcat "00" #WW))
						 	)
							((= 3 (strlen #WW))
							 	(setq #WW (strcat "0" #WW))
						 	)
							((= 4 (strlen #WW))
								nil
						 	)
							(T
								(princ "\n�����T�C�Y������������")
						 	)
						);_cond

						(setq #HH     (itoa (fix (nth 4 #qry$))))
						(cond
							((= 2 (strlen #HH))
							 	(setq #HH (strcat "00" #HH))
						 	)
							((= 3 (strlen #HH))
							 	(setq #HH (strcat "0" #HH))
						 	)
							((= 4 (strlen #HH))
								nil
						 	)
							(T
								(princ "\n�������T�C�Y������������")
						 	)
						);_cond

						(setq #MAI    (itoa (fix (nth 5 #qry$))))

						;�e�N�X�`����
						(if (= 1 (strlen #DRCol))
							(setq #DRCol (strcat #DRCol "@"))
						);_if
						(setq #TEXTURE (strcat #ZU_ID "_" #DR_ID "_" "0" #MEN_ID "_" #WW "_" #HH "_" "0" #MAI "_" #DRCol ".jpg"))
						;���e�N�X�`�����݊m�F
						(setq #flg (findfile (strcat #path "Door_Texture_3\\" #DRCol "\\" #TEXTURE)))
						(if #flg
							(progn ;���݂���

								;����̫��ނɑ��݂���jpg���폜����
								(setq #jpg$ (vl-directory-files CG_LOGPATH "*.jpg" 1));�g���݊֐�����
								(foreach #jpg #jpg$
									(vl-file-delete (strcat CG_LOGPATH #jpg))
								);foreach


								(princ "\n��ø���= ")(princ #TEXTURE)(princ "�@����")
								;��߰����
					      (setq #tEndFlg (vl-file-copy  (strcat #path "Door_Texture_3\\" #DRCol "\\" #TEXTURE) (strcat CG_LOGPATH #TEXTURE) nil))
					      (if (= nil #tEndFlg)
					        (progn
					          (CFAlertErr (strcat "��ø������߰�ł��܂���"))
					        )
									(progn ;��߰�o����
										;mspaint.exe �ŊJ��
										(startapp "mspaint.exe" (strcat #path "Door_Texture_3\\" #DRCol "\\" #TEXTURE))
									)
					      );_if
							)
							;else
							(progn
								(princ "\n��ø���= ")(princ #TEXTURE)(princ "���������e�N�X�`���Ȃ�������")
							)
						);_if


						(setq #i 1)
						(foreach #qry #qry$
							(if (= #i 1)
								(princ "\n")
							);_if
							(princ #qry)
							(if (/= #i (length #qry$))
								(princ ",")
							);_if
							(setq #i (1+ #i))
						);foreach
						(princ "\n")
					);foreach
				)
			);_if

      (princ "\n--------------------------------------------------------------------------" )
			(princ "\n�f�r�l.���@W  =")(princ #GSM_W)
			(princ "\n�f�r�l.���@D  =")(princ #GSM_D)
			(princ "\n�f�r�l.���@H  =")(princ #GSM_H)
      (princ "\n--------------------------------------------------------------------------" )
			(princ "\n�i�Ԑ}�`.�}�`ID  =")(princ #zukei)
			(princ "\n�i�Ԑ}�`.�i�Ԗ���=")(princ #hinban)
			(princ "\n�i�Ԑ}�`.LR�敪  =")(princ #LR)
			(princ "\n�i�Ԑ}�`.���@W  =")(princ #WW)
			(princ "\n�i�Ԑ}�`.���@D  =")(princ #DD)
			(princ "\n�i�Ԑ}�`.���@H  =")(princ #HH)
      (princ "\n**************************************************************************" )


		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "�}�e���A������"
		      (list
		        (list "�i��"    #hinban  'STR)
		      )
		    )
		  )
			(if #qry$$
				(progn
					(foreach #qry$ #qry$$
						(setq #material (nth 1 #qry$)) ;jpg���� or jpg�Ȃ�

						;".jpg"���܂�ł���΃e�N�X�`�����݊m�F���s��
						(setq #material_big (strcase #material));�啶��
						(if (wcmatch #material_big "*.JPG")
							(progn ;�e�N�X�`�����݊m�F
								(setq #flg (findfile (strcat #path "Goods_Texture_3\\" #material)))
								(if #flg
									(progn ;���݂���
										(princ "\n�@��ø���= ")(princ #material)(princ "�@����")
									)
									;else
									(progn
										(princ "\n�@��ø���= ")(princ #material)(princ "�������@��ø����Ȃ�������")
									)
								);_if
							)
							(progn ;�}�e���A��
								(princ "\n�}�e���A��= ")(princ #material)
							)
						);_if
					)
				)
				(progn
					(princ "\n [�}�e���A������]�Ȃ�")
				)
			);_if

    )
  );_if

	(princ "\n")
	(princ "\n")
	(princ "\n")
	(princ)
);c:CG_Info

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;2015/08/10 YM ADD �i�ԃ��X�g����y���\���z�e�N�X�`�����݊m�F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:CG_Info_TOOL(
  /
	#CSV$$ #DATE_TIME #DRCOL #DRHIKI #DRID #DRSERI #DR_ID #FIL #FLG #HH
	#HINBAN #HINBAN$ #IFILE #LR #LR_FLG #MAI #MEN_ID #OFILE #QRY$$ #TEXTURE
	#WW #ZUKEI #ZU_ID
  )

		;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		;�y�����z
		(defun ##KENSAKU( / )

			(setq #err_flg nil);�װ�Ȃ�T
			
			;�������@�i�Ԑ}�`�@������
		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
		      (list
		        (list "�i�Ԗ���"    #hinban       'STR)
		        (list "LR�敪"      #LR           'STR)
		      )
		    )
		  )
			(if #qry$$
				(progn
					(setq  #zukei (nth 6 (car #qry$$)))
					(if (or (= #zukei nil)(= #zukei ""))
						(progn
							(setq #err_flg T)
							;�o��
					  	(princ (strcat "\n" #hinban "," #LR "," "���}�`ID�o�^�Ȃ�") #fil)
						)
					);_if
				)
				(progn
					(setq #err_flg T)
					;�o��
			  	(princ (strcat "\n" #hinban "," #LR "," "���i�Ԑ}�`�ɂȂ�") #fil)
				)
			);_if

			;�������@�i�ԃV���@������
		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
		      (list
		        (list "�i�Ԗ���"    #hinban 'STR)
		        (list "LR�敪"      #LR     'STR)
		        (list "���V���L��"  #DRSeri 'STR)
		        (list "����L��"    #DRHiki 'STR)
		      )
		    )
		  )
			(if #qry$$
				(progn
					(setq  #drid (nth 4 (car #qry$$)))
					(if (or (= #drid nil)(= #drid ""))
						(progn
							(setq #err_flg T)
							;�o��
					  	(princ (strcat "\n" #hinban "," #LR "," "�����}�`ID�o�^�Ȃ�") #fil)
						)
					);_if
				)
				(progn
					(setq #err_flg T)
					;�o��
			  	(princ (strcat "\n" #hinban "," #LR "," "���i�ԃV���ɂȂ�") #fil)
				)
			);_if

			;�������@���\���@������
			(if #err_flg
				nil ;�װ
				;else
				(progn

				  (setq #qry$$
				    (CFGetDBSQLRec CG_DBSESSION "���\��"
				      (list
				        (list "���}�`ID"    #drid  'STR)
				        (list "�}�`ID"      #zukei 'STR)
				      )
				    )
				  )

					(if (= nil #qry$$)
						(progn
							;�o��
					  	(princ (strcat "\n" #hinban "," #LR ","  "���}�`ID=" #drid "," "�}�`ID=" #zukei "," "�����\���Ȃ�") #fil)
						)
						(progn
							;(princ "\n�i�Ԗ���,LR�敪,���}�`ID,�}�`ID,�\�t��,�Ԍ�,����,����" )
							(foreach #qry$ #qry$$
								;0160709_0500202_03_0300_0520_01_LB.jpg
								(setq #DR_ID  (nth 0 #qry$))
								(setq #ZU_ID  (nth 1 #qry$))
								(setq #MEN_ID (itoa (fix (nth 2 #qry$))))
								(setq #WW     (itoa (fix (nth 3 #qry$))))
								(cond
									((= 2 (strlen #WW))
									 	(setq #WW (strcat "00" #WW))
								 	)
									((= 3 (strlen #WW))
									 	(setq #WW (strcat "0" #WW))
								 	)
									((= 4 (strlen #WW))
										nil
								 	)
									(T
										(setq #WW "�����T�C�Y�s��")
								 	)
								);_cond

								(setq #HH     (itoa (fix (nth 4 #qry$))))
								(cond
									((= 2 (strlen #HH))
									 	(setq #HH (strcat "00" #HH))
								 	)
									((= 3 (strlen #HH))
									 	(setq #HH (strcat "0" #HH))
								 	)
									((= 4 (strlen #HH))
										nil
								 	)
									(T
										(setq #HH "�������s��")
								 	)
								);_cond

								(setq #MAI    (itoa (fix (nth 5 #qry$))))

								;�e�N�X�`����
								(if (= 1 (strlen #DRCol))
									(setq #DRCol (strcat #DRCol "@"))
								);_if
								(setq #TEXTURE (strcat #ZU_ID "_" #DR_ID "_" "0" #MEN_ID "_" #WW "_" #HH "_" "0" #MAI "_" #DRCol ".jpg"))

								;���e�N�X�`�����݊m�F
								(setq #flg (findfile (strcat #path "Door_Texture_3\\" #DRCol "\\" #TEXTURE)))

								(if #flg
									(setq #TEXTURE (strcat #TEXTURE " , ø������݂���" )) ;���݂���
									;else
									(setq #TEXTURE (strcat #TEXTURE " , ��ø����Ȃ�" )) ;���݂��Ȃ�
								);_if


								;�o��
						  	(princ (strcat "\n" #hinban "," #LR "," #DR_ID "," #ZU_ID "," #MEN_ID "," #WW "," #HH "," #MAI "," #TEXTURE) #fil)

							);foreach

						)
					);_if

				)
			);_if

			(princ)
		);##KENSAKU
		;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



  (setq #iseri (strcat CG_SYSPATH "texture_path.txt"));ø����̌����p�X
  (setq #path$ (ReadCSVFile #iseri))
	(setq #path (car (car #path$)))

	;�����Ώەi�Ԃ̓ǂݍ���
  (setq #ifile (strcat CG_SYSPATH "LOG\\CG_INFO_HINBAN.txt"))
  (setq #CSV$$ (ReadCSVFile #ifile))
  (setq #hinban$ (mapcar 'car #CSV$$));�����Ώەi��ؽ�

	;�������ʏo��̧��
  (setq #ofile  (strcat CG_SYSPATH "LOG\\CG_INFO_KEKKA.txt"))
  (setq #fil (open #ofile "W" ))

  (if (= nil #fil)
    (progn
      (CFAlertErr (strcat "kekka.txt ���J���܂���B���Ă�������"))
      (quit)
    )
  );_if

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));���t
  (princ #date_time #fil ) ; ���t��������

  (princ "\n" #fil)
	(princ "\n")

	;���݂̔�
	(setq #DRSeri CG_DRSeriCode)
	(setq #DRCol  CG_DRColCode)
	(setq #DRHiki CG_HIKITE)

  (princ "\n�i�Ԗ���,LR�敪,���}�`ID,�}�`ID,�\�t��,�Ԍ�,����,����,ø�����" #fil)

	(foreach #hinban #hinban$

		;�������@�i�Ԋ�{�@������
	  (setq #qry$$
	    (CFGetDBSQLRec CG_DBSESSION "�i�Ԋ�{"
	      (list
	        (list "�i�Ԗ���"    #hinban       'STR)
	      )
	    )
	  )
		(if #qry$$
			(progn
				
				(setq #LR_FLG (fix (nth 1 (car #qry$$))))
				(cond
					((= 0 #LR_FLG)
					 	(setq #LR "Z")
				 	)
					((= 1 #LR_FLG)
					 	(setq #LR "L")
				 	)
					(T
					 	nil
				 	)
				);_cond

				;�y�����z
				(##KENSAKU)

				(if (= #LR "L")
					(progn
						(setq #LR "R")
						(##KENSAKU)
					)
				);_if

			)
			(progn
				;�o��
		  	(princ (strcat "\n" #hinban ","  "���i�Ԋ�{�Ȃ�") #fil)
			)
		);_if

	);(foreach


  (if #fil (close #fil))

  (startapp "notepad.exe" #ofile)

	(princ "\n�����I��")
	(princ)
);c:CG_Info_TOOL




;2014/02/14 YM ADD CG���ްDOOR TEXTURE2�̃t�@�C�����`�F�b�N
(defun C:CHECK_DOOR_TEXTURE2 (
  /
	#FP #RSTR
  )
	(setq #i 0)
  (setq #fp (open "./LOG/DOOR_TEXTURE2.txt" "r")) ;̧�ٵ����(READ)
  (while (setq #rstr (read-line #fp)) ;̧�ق�ǂݍ���
		(if (= 0 (rem #i 10000))
			(progn
				(princ "\ni=")(princ #i)
			)
		);_if
		(if (vl-string-search "jpg" #rstr) ; "jpg"�����邩?
			(progn ;16,17��
				(if (wcmatch (substr #rstr 16 4) "_0*_")
					nil
					;else
					(princ (strcat "\n" #rstr));�o��
				);_if
      )
    );_if
		(setq #i (1+ #i))
  )
  (close #fp)  ;// ̧�ٸ۰��
	(princ "\nread-line��")(princ #i)
	(princ)
);

;<HOM>*************************************************************************
; <�֐���>    : C:GCG
; <�����T�v>  : �}�ʏ��C_CG�L���𒲂ׂ�
; <�߂�l>    : 
;*************************************************************************>MOH<
(defun C:GCG ( / #EN #I #SS #SYM #XD$ #HIN #ID #LR #XD_LSYM$)

  (setq #en (car (entsel)))

  (if (= #en nil)
    (progn
      (CFAlertErr "���ނ��I������܂���ł���")(quit)
    )
    (progn
      (setq #sym (SearchGroupSym #en)) ; ����ِ}�`��
			(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
			(setq #id  (nth 0 #xd_LSYM$));�}�`ID
			(setq #hin (nth 5 #xd_LSYM$));�i��
			(setq #LR  (nth 6 #xd_LSYM$));LR

			(princ "\n�}�`ID: ")(princ #id)
			(princ "\n�i��  : ")(princ #hin)
			(princ "\nLR    : ")(princ #LR)

		  (setq #ss (CFGetSameGroupSS #sym));��ٰ�ߐ}�`
		  (setq #i 0)
		  (repeat (sslength #ss)
		    (setq #en (ssname #ss #i))
		    (setq #xd$ (CFGetXData #en "G_CG"))
				(if #xd$
					(progn
						(princ "\nG_CG: ")(princ #xd$)
					)
				);_if
		    (setq #i (1+ #i))
		  );repeat
    )
  );_if
	(princ)
);C:GCG


;<HOM>*************************************************************************
; <�֐���>    : C:SHOWXD
; <�����T�v>  : �}�ʏ��C_CG�L���𒲂ׂ�
; <�߂�l>    : 
;*************************************************************************>MOH<
(defun C:SHOWXD (
	/
	#EN #XD$$
	)

  (setq #en (car (entsel)))

  (if (= #en nil)
    (progn
      (CFAlertErr "���ނ��I������܂���ł���")(quit)
    )
    (progn
			(setq #xd$$ (entget #en '("*")))
		 	(setq #xd$$ (cdr (assoc -3 #xd$$)))
			(foreach #xd$ #xd$$
				(princ "\n")(princ #xd$)
			);(foreach
    )
  );_if
	(princ)
);C:SHOWXD

;*************************************************************************>MOH<
; �e�L�X�g�ɏo��
;*************************************************************************>MOH<
(defun writetxt (
  &str ;������
  &txt ;�t�@�C����
  /
  #FIL #OFILE
  )
  (if CG_LOG
    (progn
      (setq #ofile &txt) ;�o��̧�ٖ�
      (setq #fil (open #ofile "A" ));�ǉ����[�h

      (princ &str #fil);������o��
      (princ "\n" #fil)
      (if #fil (close #fil))
    )
  );_if

;	(startapp "notepad.exe" #ofile)
  (princ)
);writetxt



;;;<HOM>*************************************************************************
;;; <�֐���>    : C:SINK_CHECK
;;; <�����T�v>  : [WT�V���N].�V���N�L�����u���v�Ƃ��Ċe�e�[�u���̃V���N�L�����`�F�b�N
;;; <�쐬>      : 2015/06/26 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:SINK_CHECK (
  /
	#CHECK$ #DATE_TIME #DBNAME #DUM$ #FIL #ITM$ #REC$$ #SINK$
  )

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		(defun ##CHECK ( / )
			(foreach sink #check$
				(if (member sink #sink$)
					nil
					;else
					(progn
						;���݂��Ȃ��V���N�L�����o��
						(if (/= sink "_")
							(princ (strcat "\n" #DBNAME "," sink ) #fil)
						);_if
					)
				);_if
			);(foreach

			(princ)
		);##CHECK
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		(defun ##UNIQUE ( &lis$ / #ret$)
			(setq #ret$ nil)
			(foreach lis &lis$
				(if (member lis #ret$)
					nil
					;else
					(setq #ret$ (append #ret$ (list lis)))
				);_if
			);foreach
			#ret$
		);##UNIQUE
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		(defun ##GASSAN ( / #dum$)
			(setq #dum$ nil)
			(foreach #check #check$
			  ;// �������������ŋ�؂�
			  (setq #itm$ (strparse #check ","))
				(foreach #itm #itm$
					(if (member #itm #dum$)
						nil
						;else
						(setq #dum$ (append #dum$ (list #itm)))
					);_if
				);foreach
			);foreach
			(setq #check$ #dum$)
			(princ)
		);##CHECK
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	(setq #fil (open (strcat CG_SYSPATH "LOG\\SINK�L���s����CHECK_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������

  (princ "\n--- SINK�L���s��������(C:SINK_CHECK) ---" #fil)
  (princ "\n" #fil)
  (princ "\n")
	
  (setq #DBNAME "WT�V���N")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �V���N�L�� from " #DBNAME)))
	(setq #sink$ (mapcar 'car #rec$$));�u���v�Ƃ���V���N�L����ؽ�



	
  (princ "\n�������@[WT�V���N]�ɑ��݂��Ȃ�SINK�L���ꗗ�@������" #fil)

  (setq #DBNAME "�V���i")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �V���N�L�� from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));�u���v�Ƃ���V���N�L����ؽ�
	(setq #check$ (##UNIQUE #check$))
	(##CHECK)

  (setq #DBNAME "OP�u���V���N")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �V���N�L�� from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));�u���v�Ƃ���V���N�L����ؽ�
	(setq #check$ (##UNIQUE #check$))
	(##CHECK)

  (setq #DBNAME "�v���Ǘ�")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �V���N�L�� from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));�u���v�Ƃ���V���N�L����ؽ�
	(setq #check$ (##UNIQUE #check$))
	(##CHECK)

  (setq #DBNAME "�K�i�V�e���@")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �V���N�L�� from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));�u���v�Ƃ���V���N�L����ؽ�
	(setq #check$ (##UNIQUE #check$))
	(##CHECK)

  (setq #DBNAME "�����ʒu")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �V���N�L�� from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));�u���v�Ƃ���V���N�L����ؽ�
	(setq #check$ (##UNIQUE #check$))
	(##CHECK)




  (setq #DBNAME "SINKCAB�Ǘ�")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �V���N from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));�u���v�Ƃ���V���N�L����ؽ�
	(##GASSAN)
	(##CHECK)


  (setq #DBNAME "SINK���s�Ǘ�")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �V���N from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));�u���v�Ƃ���V���N�L����ؽ�
	(##GASSAN)
	(##CHECK)


  (setq #DBNAME "SINK�ގ��Ǘ�")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select �V���N from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));�u���v�Ƃ���V���N�L����ؽ�
	(##GASSAN)
	(##CHECK)


  (princ "\n" #fil)
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
  (princ #date_time #fil) ; ���t��������
  (princ "\n" #fil)

  (princ (strcat "\n������ �V���N�L���s���������I�� ������") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\SINK�L���s����CHECK_" CG_SeriesDB ".txt"))
  (princ)
);C:KAISOCHECK


;;;<HOM>*************************************************************************
;;; <�֐���>     : C:KAISO
;;; <�����T�v>   : �i�Ԃ���́@�K�w�̂ǂ��ɂ��邩�H
;;; <�߂�l>     : �Ȃ�
;;; <�쐬>       : 2016/06/30 YM
;;; <���l>       : 
;;;*************************************************************************>MOH<
(defun KAISO (
  /
	#DBSESSION #HINBAN #KOSU #QRY$ #QRY$$
  )

	(princ "\n")
	(setq #hinban (getstring "\n�@�햼�����(�@�햼�̈ꕔ�ł�OK): "))
	(princ "\n")
	(princ "\n")

	(setq #qry$$
	  (DBSqlAutoQuery CG_DBSESSION (strcat "select ��ʊK�wID from �K�w where �K�w���� like '%" #hinban "%'"))
	)
	(setq #qry$ (mapcar 'car #qry$$))
	(setq #qry$ (##DEL #qry$))

	(setq #kosu (length #qry$))
	(if (> #kosu 10)
		(progn
			(princ "\n�Ώۋ@�햼��10���𒴂��܂�")
			(quit)
		)
	)


;CG_CDBSESSION
;CG_DBSESSION

	(if (= #kosu 0)
		(princ "\n���@�햼���K�w�ɑ��݂��܂���")
		;else
		(MAIN #qry$)
	);_if

	(princ "\n")
	(princ)
);C:KAISO


;;;*************************************************************************>MOH<
;�d���폜
(defun ##DEL (
	&lis$
  /
	
  )
	;�d���폜
	(setq #dum$ nil)
	(foreach #lis &lis$
		(if (member #lis #dum$)
			nil
			;else
			(setq #dum$ (cons #lis #dum$))
		);_if
	);foreach
	#dum$
);##DEL


;;;*************************************************************************>MOH<
(defun MAIN (
	&qry$
  /
	#FLG #KAISONAME #KAISONAME$ #NO_FLG #TUIKA_FLG #UPKAISOID #tbl
  )

	(setq #tbl "�K�w")

			;------------------------------------------------------------------
			(defun GetKaisoName(  &ID / )


				(setq #qry$
				  (DBSqlAutoQuery CG_DBSESSION (strcat "select ��ʊK�wID,�K�w���� from " #tbl " where �K�wID='" &ID "'"))
				)
				(if (= nil #qry$)
					nil
					;else
					(cadr (car #qry$)) ;�K�w����
				);_if
			);GetKaisoName

			;------------------------------------------------------------------
			(defun GetUPKaisoID(  &ID / )
				(setq #qry$
				  (DBSqlAutoQuery CG_DBSESSION (strcat "select ��ʊK�wID,�K�w���� from " #tbl " where �K�wID='" &ID "'"))
				)
				(if (= nil #qry$)
					nil
					;else
					(car  (car #qry$)) ;��ʊK�wID
				);_if
			);GetKaisoName
			;------------------------------------------------------------------

	(setq #NO_flg T);���݂��Ȃ�

	(princ "\n--- �u�ذ���ݐ݌v�v�ꏊ�͈ȉ��̂Ƃ��� ---")

	(foreach #qry &qry$
		(setq #UPkaisoID #qry)
		(if (= "-" (substr #UPkaisoID 1 1))
			nil
			;else
			(progn
				(setq #flg T)
				(setq #tuika_flg nil);�ǉ����ނ̏ꍇT
				(setq #NO_flg nil);���݂��Ȃ�
				(setq #kaisoName$ nil)
				(while #flg
					(setq #kaisoName (GetKaisoName  #UPkaisoID))
					(if (= nil #kaisoName)
						(setq #flg nil)
						;else
						(setq #kaisoName$ (cons #kaisoName #kaisoName$ ))
					);_if
					(setq #UPkaisoID (GetUPKaisoID  #UPkaisoID))
					(if (= #UPkaisoID nil)(setq #flg nil))
					(if (= #UPkaisoID "0")(setq #flg nil))
					(if (= #UPkaisoID "9000")(setq #flg nil))
					(if (= #UPkaisoID "9000")(setq #tuika_flg T))
				)
				;�o��
				(foreach #kaisoName #kaisoName$
					(princ "\n")(princ #kaisoName)(princ " - ")
				)
				(princ "\n-------------------------------")
			)
		);_if

	);foreach

	(if #NO_flg
		(princ "\n���@�햼���K�w�ɑ��݂��܂���")
	);_if

	(if #tuika_flg
		(princ "\n(�ǉ�����)")
	);_if

);MAIN


(defun chgtoku( / #et)
  (setq #sym (car (entsel "����ي�_��I��: ")))
	(setq #xd$ (CFGetXData #sym "G_TOKU"))

  (CFSetXData #sym "G_TOKU"
    (CFModList #xd$
      (list (list 12 150.0))
    )
  )
  (princ)
)

;;;<HOM>*************************************************************************
;;; <�֐���>    : c:oya
;;; <�����T�v>  : �I�������}�`�̐e�}�`����\��     @YM@ �R�}���h�`�F�b�N�p
;;; <�쐬>      : 00/02/11 �C�� YM
;;;*************************************************************************>MOH<
(defun c:oya(
  /
  #en #ET #ET2 #J #I #K #NAME #NAME1 #NAME2 #XD #XD2 #XD_LSYM #XD_SYM
#DRID #HINBAN #LR #QRY$$
  )
  (setq #en (car (entsel)))

  (if (= #en nil)
    (progn
      (CFAlertErr "���ނ��I������܂���ł���")(quit)
    )
    (progn
      (setq #en (SearchGroupSym #en)) ; ����ِ}�`��
    )
  )

  (if (= #en nil)
    (progn
      (CFAlertErr "\"G_LSYM\"������܂���")(quit)
    )
    (progn
      (setq #et (entget #en))

      (setq #i 0) ; �}�`���
      (terpri)(princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n")
      (repeat (length #et)
        (setq #et2 (nth #i #et))
        (princ #et2)(terpri)
        (setq #i (1+ #i))
      )
      (princ "-----------------------------------------------------------------" )

      (setq #xd_LSYM (car (cdr (assoc -3 (entget #en '("G_LSYM"))))))
      (setq #xd_SYM  (car (cdr (assoc -3 (entget #en '("G_SYM"))))))


     (setq #name1 (list
            ":G_LSYM ����ي�_                       ";0
            ":�{�̐}�`ID    :10�޲�(dwģ�ٖ�)         ";1
            ":�}���_        :�z�u��_ x,y,z            ";2
            ":��]�p�x      :׼ޱ�                     ";3
            ":�H��L��      :2�޲�                     ";4
            ":�ذ�ދL��     :2�޲�                     ";5
            ":�i�Ԗ���      :20�޲�                    ";6
            ":L/R�敪       :Z,L,R                     ";7
            ":���}�`ID      :10�޲�                    ";8
            ":���J���}�`ID  :10�޲�                    ";9
            ":���i����      :�i�ԏ��̐��i����        ";10
            ":�����׸�      :0(�P��),1(����),2(OP����) ";11
            ":�z�u���ԍ�    :�z�u���ԍ�(1�`)           ";12
            ":�p�r�ԍ�      :0�`99                     ";13
            ":���@�g        :�i�Ԑ}�`DB�̓o�^H���@�l   ";14
            ":�f�ʎw���L��  :0(�Ȃ�),1(����)           ";15
            ":����          :�L�b�`��(A) or ���[(D)    ";16
     ))

     (setq #name2 (list
            ":G_SYM                                    "
            ":����ٖ���                                "
            ":���ĂP                                   "
            ":���ĂQ                                   "
            ":����ي�lW                             "
            ":����ي�lD                             "
            ":����ي�lH                             "
            ":����َ�t����                            "
            ":���͕��@                                 "
            ":W�����׸�                                "
            ":D�����׸�                                "
            ":H�����׸�                                "
            ":�L�k�׸�W                                "
            ":�L�k�׸�D                                "
            ":�L�k�׸�H                                "
            ":��ڰ�ײݐ�W                              "
            ":��ڰ�ײݐ�D                              "
            ":��ڰ�ײݐ�H                              "
     ))

      (setq #j 0) ; �g���f�[�^"G_LSYM"
      (repeat (length #xd_LSYM)
        (setq #xd2 (nth #j #xd_LSYM))
        (princ "\n[")(princ (1- #j))(princ "]")(princ (nth #j #name1))(princ #xd2)
        (setq #j (1+ #j))
      )
      (princ "\n -----------------------------------------------------------------" )
      (setq #j 0) ; �g���f�[�^"G_SYM"
      (repeat (length #xd_SYM)
        (setq #xd2 (nth #j #xd_SYM))
        (princ "\n[")(princ (1- #j))(princ "]")(princ (nth #j #name2))(princ #xd2)
        (setq #j (1+ #j))
      )
      (princ "\n -----------------------------------------------------------------" )
      (princ)
    )
  );_if



	(setq #hinban (cdr (nth 6 #xd_LSYM)));�i��
	(setq #LR     (cdr (nth 7 #xd_LSYM)));LR


	;2018/07/12 YM ADD-S

	;�������@�i�Ԑ}�`�@������
  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION "�i�Ԑ}�`"
      (list
        (list "�i�Ԗ���"  #hinban 'STR)
        (list "LR�敪"    #LR 'STR)
      )
    )
  )
  (if (= nil #qry$$)
		(princ "\n�i�Ԑ}�`�@�Ȃ�")
		;else
		(progn

			(princ "\n�i�Ԑ}�`.���@W  =")(princ (nth 3 (car #qry$$)))
			(princ "\n�i�Ԑ}�`.���@D  =")(princ (nth 4 (car #qry$$)))
			(princ "\n�i�Ԑ}�`.���@H  =")(princ (nth 5 (car #qry$$)))
			(princ "\n -----------------------------------------------------------------" )			
		)
	);_if
	;2018/07/12 YM ADD-E

  (setq #hinban (cdr (nth 6 #xd_LSYM)));�i��
  (setq #LR     (cdr (nth 7 #xd_LSYM)));LR

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION "�i�ԃV��"
      (list
        (list "�i�Ԗ���"    #hinban       'STR)
        (list "LR�敪"      #LR           'STR)
        (list "���V���L��"  CG_DRSeriCode 'STR)
        (list "����L��"    CG_HIKITE     'STR)
      )
    )
  )
  (if (= nil #qry$$)
    (setq #drid "�Ȃ�")
    ;else
    (progn
      (if (= nil (nth 4 (car #qry$$)))
        (setq #drid "�Ȃ�")
        ;else
        (setq #drid (strcat "DR" (nth 4 (car #qry$$))))
      );_if
    )
  );_if

	(princ "\n�}�`ID= ")(princ (cdr (nth 1 #xd_LSYM)))
	(princ "\n�@�햼= ")(princ (cdr (nth 6 #xd_LSYM)))
	(princ "\n   L/R= ")(princ (cdr (nth 7 #xd_LSYM)))
	(princ "\n���}ID= ")(princ  #drid)

  (princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n")
  (princ "\n�߂�l: \n" )
  (if #en #en nil )

);_(defun c:oya()


;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ZukeiCheck
;;; <�����T�v>  : �}�ʏ�̐}�`�̏����e�L�X�g�o�́@SOLID��Xdata�ɖ������Ȃ����`�F�b�N
;;; <�쐬>      : 2015/06/09 YM ADD
;;;*************************************************************************>MOH<
(defun C:ZukeiCheck(
	/
	#ANA #ANA_HANDLE #ANA_KOSU #DATE_TIME #DN #FIL #I #J #NAME_ANA #NAME_BODY
	#NAME_PRIM #SOLID #XD_ANA$ #XD_BODY$ #XD_PRIM$
	)

	; ̧��OPEN
  (setq #fil (open (strcat CG_SYSPATH "all.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; ���t
	(princ #date_time #fil) ; ���t��������
	(princ "\n" #fil)

 	(setq #name_PRIM
		(list
      ":�^�C�v(1=���̈� 2=������ 3=�P���)       ";1
      ":��]����ԍ�(1,2,3,4) ==>[���ύX]      ";2
      ":���f�[�^��(0:�Œ�? �g���ĂȂ�?)          ";3
      ":�P��ʎ��(0=���� 1=�s����(type=�P��ʎ�)";4
      ":�C�ӑ����P                               ";5
      ":�C�ӑ����Q                               ";6
      ":����t������                             ";7
      ":���v�f����                               ";8
      ":���X�Ίp�x                               ";9
      ":�e�[�p�p�x                               ";10
      ":����ʐ}�`�n���h��                      ";11
      ":�H�H�H                                  ";12
      ":�H�H�H                                  ";13
      ":�H�H�H                                  ";14
      ":�H�H�H                                  ";15
	))

 	(setq #name_BODY
 		(list
      ":�^�C�v(1=��� 2=���)                    ";1
      ":���f�[�^��                               ";2
      ":���}�`�n���h��1                          ";3
      ":���}�`�n���h��2                          ";4
      ":���}�`�n���h��3                          ";5
      ":���}�`�n���h��4                          ";6
      ":���}�`�n���h��5                          ";7
      ":�H�H�H                                   ";8
      ":�H�H�H                                   ";9
      ":�H�H�H                                   ";10
	))

 	(setq #name_ANA
 		(list
      ":���`��^�C�v(1=�ʏ팊 2=�X�Ό�)          ";1
      ":���^�C�v(0=�ђ� 1=��ʊт� 2=��ʊт�)   ";2
      ":���[��                                   ";3
      ":�e�[�p�p�x                               ";4
      ":�H�H�H                                   ";5
      ":�H�H�H                                   ";6
      ":�H�H�H                                   ";7
	))

  (setq #SOLID (car (entsel "\nSOLID�}�`��I��: ")))

  (setq #xd_PRIM$ (CFGetXData #SOLID "G_PRIM"))  ;����è�ސ}�`

	(if #xd_PRIM$
		(progn
			(princ "\n<G_PRIM>" #fil)
      (setq #j 0) ; �g���f�[�^"G_PRIM"���ڐ�
      (repeat (length #xd_PRIM$)
      	(princ "\n[" #fil)(princ #j #fil)(princ "]" #fil)
				(princ (nth #j #name_PRIM) #fil)
				(princ (nth #j #xd_PRIM$) #fil)
        (setq #j (1+ #j))
      )
      (princ "\n -----------------------------------------------------------------"  #fil)
    	(princ "\n" #fil)

		)
		(progn
			(CFAlertMsg "G_PRIM������܂���")
			(quit)
		)
	);_if

;;;  (setq #dn  (handent (nth 10 #xd_PRIM$)))       ;��ʗ̈�}�` G_BODY
  (setq #dn  (nth 10 #xd_PRIM$))       ;��ʗ̈�}�` G_BODY

	(if (= (type #dn) 'ENAME)
		(progn
  		(setq #xd_BODY$ (CFGetXData #dn "G_BODY"))
		)
		(progn
			(CFAlertMsg "��ʐ}�`����ق���������.")
			(quit)
		)
	);_if

	(if #xd_BODY$
		(progn
			(princ "\n<G_BODY>" #fil)
      (setq #j 0) ; �g���f�[�^"G_BODY"���ڐ�
      (repeat (length #xd_BODY$)
      	(princ "\n[" #fil)(princ #j #fil)(princ "]" #fil)
				(princ (nth #j #name_BODY) #fil)
				(princ (nth #j #xd_BODY$) #fil)
        (setq #j (1+ #j))
      )
      (princ "\n -----------------------------------------------------------------"  #fil)
    	(princ "\n" #fil)
		)
		(progn
			(CFAlertMsg "G_BODY������܂���")
			(quit)
		)
	);_if

  (setq #ANA_kosu (nth 1 #xd_BODY$))             ;��ʗ̈�}�` G_BODY
	(setq #i 2)
	(repeat #ANA_kosu
		(setq #ANA_handle (nth #i #xd_BODY$))
;;;		(setq #ana (handent #ANA_handle))
		(setq #ana #ANA_handle)

		(if (= (type #ana) 'ENAME)
			(progn
				(setq #xd_ANA$ (CFGetXData #ana "G_ANA"))
			)
			(progn
				(CFAlertMsg "����ʐ}�`����ق���������.")
				(quit)
			)
		);_if

		(if #xd_ANA$
			(progn
				(princ "\n<G_ANA>" #fil)
	      (setq #j 0) ; �g���f�[�^"G_ANA"���ڐ�
	      (repeat (length #xd_ANA$)
	      	(princ "\n[" #fil)(princ #j #fil)(princ "]" #fil)
					(princ (nth #j #name_ANA) #fil)
					(princ (nth #j #xd_ANA$) #fil)
	        (setq #j (1+ #j))
	      )
	      (princ "\n -----------------------------------------------------------------"  #fil)
	    	(princ "\n" #fil)
			)
			(progn
				(CFAlertMsg "G_ANA������܂���")
				(quit)
			)
		);_if

		(setq #i (1+ #i))
	);repeat


  (if #fil
    (progn
      (close #fil)
      (princ "\ņ�قɏ������݂܂���.")
			(startapp "notepad.exe" (strcat CG_SYSPATH "all.txt"))
    )
  );_if
  (princ)
);C:ZukeiCheck



;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ADDCOM01
;;; <�����T�v>  : 
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2015/01/30 YM
;;; <���l>      : OEM�Œǉ��p
;;;*************************************************************************>MOH<
(defun C:ADDCOM01 (
  /
  )
  ;// �R�}���h�̏�����
	(C:arxStartApp (strcat CG_SysPATH "version.exe") 0)
	(princ)
);C:ADDCOM01

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ADDCOM02
;;; <�����T�v>  : 
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2015/01/30 YM
;;; <���l>      : OEM�Œǉ��p
;;;*************************************************************************>MOH<
(defun C:ADDCOM02 (
  /
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)
	(KAISO)
	(princ)
);C:ADDCOM02

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ADDCOM03
;;; <�����T�v>  : 
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2015/01/30 YM
;;; <���l>      : OEM�Œǉ��p
;;;*************************************************************************>MOH<
(defun C:ADDCOM03 (
  /
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)
	(c:CG_Info_TOOL)
	(princ)
);C:ADDCOM03

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ADDCOM04
;;; <�����T�v>  : 
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2015/01/30 YM
;;; <���l>      : OEM�Œǉ��p
;;;*************************************************************************>MOH<
(defun C:ADDCOM04 (
  /
  )
	;2016/11/11 YM ADD
  (C:newAutoPut)
	(princ)
);C:ADDCOM04

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ADDCOM05
;;; <�����T�v>  : 
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2015/01/30 YM
;;; <���l>      : OEM�Œǉ��p
;;;*************************************************************************>MOH<
(defun C:ADDCOM05 (
  /
  )
	;2016/11/11 YM ADD
  (C:newAutoPutC)
	(princ)
);C:ADDCOM05

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ADDCOM06
;;; <�����T�v>  : 
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2015/01/30 YM
;;; <���l>      : OEM�Œǉ��p
;;;*************************************************************************>MOH<
(defun C:ADDCOM06 (
  /
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)

	(princ "\n  ���@acet-str-find �����s")
	(setq #ret (acet-str-find "HHA[^T][0-9]+[-][A|K].*" "HHAS030-A" nil T)) ;I�^���t���[��
	(princ "\n  �����Ȃ�߂�l���P�ƂȂ�͂�")
	(princ #ret)
	(princ "\n")


	(princ "\n  �������@acet-list-remove-nth �����s")
	(setq #ret2 (acet-list-remove-nth 3 '(0 1 2 3 3 4 5)))
	(princ "\n  �����Ȃ�߂�l��(0 1 2 3 4 5)�ƂȂ�͂�")
	(princ #ret2)
	(princ "\n")

	
	(princ "\n  �����@acet-list-put-nth �����s")
	(setq #ret1 (acet-list-put-nth 3 '(0 1 2 9999 4 5)  3))
	(princ "\n  �����Ȃ�߂�l��(0 1 2 3 4 5)�ƂȂ�͂�")
	(princ #ret1)
	(princ "\n")

;2017/07/18 YM ADD-S �ڰѷ��ݑΉ�
;������v�Z
(OutputKanaguInfo)
;2017/07/18 YM ADD-E �ڰѷ��ݑΉ�


	(princ "\n --- end ---")
	(princ)
);C:ADDCOM06

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ADDCOM07
;;; <�����T�v>  : �f�r�l�}�`�̊g���f�[�^���̐����������Ă��邩�`�F�b�N
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2015/01/30 YM
;;; <���l>      : OEM�Œǉ��p
;;;*************************************************************************>MOH<
(defun C:ADDCOM07 (
  /
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)
	(princ "\nHello World!")
	(princ)
);C:ADDCOM07

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ADDCOM08
;;; <�����T�v>  : 
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2015/01/30 YM
;;; <���l>      : OEM�Œǉ��p
;;;*************************************************************************>MOH<
(defun C:ADDCOM08 (
  /
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)
	(princ "\nHello World!")
	(princ)
);C:ADDCOM08

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ADDCOM09
;;; <�����T�v>  : 
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2015/01/30 YM
;;; <���l>      : OEM�Œǉ��p
;;;*************************************************************************>MOH<
(defun C:ADDCOM09 (
  /
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)
	(princ "\nHello World!")
	(princ)
);C:ADDCOM09

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:ADDCOM10
;;; <�����T�v>  : 
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2015/01/30 YM
;;; <���l>      : OEM�Œǉ��p
;;;*************************************************************************>MOH<
(defun C:ADDCOM10 (
  /
  )
  ;// �R�}���h�̏�����
  (StartUndoErr)
	(princ "\nHello World!")
	(princ)
);C:ADDCOM10

(princ)

