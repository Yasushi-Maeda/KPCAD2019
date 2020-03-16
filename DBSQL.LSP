;|
;;;<HOM>***********************************************************************
;;; <�֐���>		: DBConnect
;;; <�����T�v>	: DB �ɐڑ�����
;;; <�߂�l>		: ����:�Z�b�V������(ex:("SQLSESSION" 1.0))	���s:nil
;;; <�쐬>			: 1998/06/04 -> 1998/06/04	���� �����Y
;;; <���l>			:
;;;***********************************************************************>HOM<
(defun DBConnect
	(
		&DBName			; �f�[�^�x�[�X��
		&id					; ���[�U�[��
		&pass				; �p�X���[�h
	/
		#session
	)
	(if (= &id nil)
		(progn
			(setq &id "")
		)
	)
	(if (= &pass nil)
		(progn
			(setq &pass "")
		)
	)
	(setq #session (asi_connect &DBName &id &pass))									; DB �Ɛڑ�
	(if (= (asi_objp #session) T)																		; �ڑ��������������`�F�b�N
		(progn
			#session	; return
		)
		;; else
		(progn
			nil	; return
		)
	)
)


;;;<HOM>***********************************************************************
;;; <�֐���>		: DBDisconnect
;;; <�����T�v>	: �ڑ�����Ă��� DB ��ؒf����
;;; <�߂�l>		: ����: T		���s: nil
;;; <�쐬>			: 1998/06/04 -> 1998/06/04	���� �����Y
;;; <���l>			:
;;;***********************************************************************>HOM<
(defun DBDisConnect
	(
		&session				; �Z�b�V������
	/
	)
	(if (= (asi_objp &session) T)																; �ڑ��̏�ԃ`�F�b�N
		(progn
			(asi_disconnect &session)																		; DB �Ƃ̐ڑ���ؒf����
		)
		;; else
		(progn
			nil	; return
		)
	)
)


;;;<HOM>***********************************************************************
;;; <�֐���>		: DBSqlQuery
;;; <�����T�v>	: DB ���� SQL ���ɂ��f�[�^����������
;;; <�߂�l>		: �f�[�^���X�g	ex) (( �f�[�^1 ) ( �f�[�^2 ))
;;; <�쐬>			: 1998/05/28 -> 1998/05/28	���� �����Y
;;; <���l>			: �g�p����ɂ́ADB �ɐڑ�����Ă��Ȃ���΂Ȃ�܂���
;;;								Access �̃X�L�[�}�w��������ȉ�������ꍇ�� DBSqlAutoQuery ��肱������g���ĉ�����
;;;								ex) (DBSqlAutoQuery '("SQLSESSION" 1.0)
;;;								"select * from \"D:\\home\\Matsuki\\Work\\Noritz\\DB\\test\".Syain")
;;;***********************************************************************>HOM<
(defun DBSqlQuery
	(
		&session
		&Sql
	/
		#statement
		#cursor
		#listH
		#listC
		#listRet$
	)
	(setq #statement (asi_prepare &session &Sql))

	(if (/= #statement nil)																			; ��L����(���Ɛڑ��̊m��)�������������`�F�b�N
		(progn
			(setq #cursor (asi_alloc #statement "CURS-NAME1"))			; SQL �̃J�[�\�������蓖�Ă�
			(asi_open #cursor)																			; SQL �J�[�\���̃I�[�v��

			(setq #listH (asi_coldsc #cursor))											; DB ��1�s�ڂł���񖼂���M����B
			(setq #listC (asi_fetch #cursor))												; DB �̃f�[�^��1�s�ڂ���M
			(while (/= #listC nil)
				(setq #listRet$ (append #listRet$ (list #listC)))
				(setq #listC (asi_fetch #cursor "NEXT"))							; �Ȍ�A2�s�ځA3�s�ڂƎ�M���Ă���
			)

			(if (asi_objp #cursor)																	; SQL �J�[�\���̃I�[�v���`�F�b�N
				(asi_close #cursor)																		; SQL �J�[�\�����I�[�v������Ă�������
			)

			(if (asi_objp #statement)																; ���Ɛڑ��̊m�����`�F�b�N
				(asi_deallocstm #statement)														; ���Ɛڑ����m������Ă�����A�������
			)

			#listRet$	; return
		)
		;; else
		(progn	; SQL ���̃~�X
			nil	; retrurn
		)
	)
)


;;;<HOM>***********************************************************************
;;; <�֐���>		: DBSqlAutoQuery
;;; <�����T�v>	: DB ���� SQL ���ɂ��f�[�^���擾����
;;; <�߂�l>		: ���� : �f�[�^���X�g	ex) (( �f�[�^1 ) ( �f�[�^2 ))		���s : nil
;;; <�쐬>			: 1998/05/28 -> 1998/05/28	���� �����Y
;;; <���l>			: �g�p����ɂ́ADB �ɐڑ�����Ă��Ȃ���΂Ȃ�܂���
;;;								�X�L�[�}���́A�w�肵�Ă��w�肵�Ȃ��Ă��ǂ���ł��\���܂���
;;;								�X�L�[�}�w��������ȉ�������ꍇ�� DBSqlQuery ���g���ĉ�����
;;;								ex) (DBSqlAutoQuery '("SQLSESSION" 65.0) "select * from Syain")
;;;***********************************************************************>HOM<
(defun DBSqlAutoQuery
	(
		&session		; �ڑ��Z�b�V������
		&Sql				; �Ɖ� SQL ��
	/
		#listCa
		#listH
		#listTemp
		#listTemp2
		#listRet$
		#flag
	)
	(CFOutStateLog 1 1 " ")
	(CFOutStateLog 1 1 "DBSqlAutoQuery SQL=")
	(CFOutStateLog 1 1 &Sql)
	(CFOutStateLog 1 1 " ")

  (if (= CG_DEBUG 1)
		(progn
			(princ "\n== DBSqlAutoQuery =============================================")
			(princ "\n &Sql =")(princ &Sql)
			(princ "\n==============================================================")
		)
  )

	(if (= (strcase (asi_dbms &session)) "ODBC")
		(progn
;;;			(princ "\nODBC\n")
			(setq #flag 0)
;;			(dpr '&Sql)
			(setq #listRet$ (DBSqlQuery &session &Sql))

			(if (= #listRet$ nil)
				(progn
;;;					(princ "\n�擾���s\n")
					(setq #listH (DBSqlQuery &session "select SCHEMA_NAME from INFORMATION_SCHEMA.SCHEMATA for read only"))
					(if (/= #listH nil)
						(progn
							(setq #listTemp (strtok &Sql ","))
							(setq #listTemp2 (car #listTemp))
							(foreach #ll (cdr #listTemp)
								(setq #listTemp2 (strcat #listTemp2 ", " #ll))
							)
							;; �X�L�[�}�̎�������
							(setq #listTemp (strtok #listTemp2 " "))									; SQL ������
							(setq #listCa (strcat (car #listTemp) " "))					; �����l���
							(foreach #nn (cdr #listTemp)
								(if (= (strcase #nn) "FROM")
									(progn
										;; FROM �̌�ɁA�X�L�[�}����}������
										(setq #listCa (strcat #listCa #nn " "))
										(setq #flag 1)
									)
									(progn
										(if (/= #flag 0)
											(progn
												(cond
													((= (strcase #nn) "WHERE") (setq #flag 0))
													((= (strcase #nn) "GROUP") (setq #flag 0))
													((= (strcase #nn) "HAVING") (setq #flag 0))
													((= (strcase #nn) "ORDER") (setq #flag 0))
													(T (setq #flag 1))
												)
												(if (= #flag 0)
													(progn
														(setq #listCa (strcat #listCa #nn " "))				; �����f�[�^�̌���
													)
													(progn
														(setq #listCa (strcat #listCa "\"" (car (car #listH)) "\"." #nn " "))
													)
												)
											)
											(progn
												(setq #listCa (strcat #listCa #nn " "))				; �����f�[�^�̌���
											)
										)
									)
								)
							)
;;;							(princ (strcat "\nCheck:" #listCa "\n"))

;;;							(princ "\n\n�X�L�[�}�t��\n")
;;							(dpr '#listCa)

							(setq #listRet$ (DBSqlQuery &session #listCa))
							(if (= #listRet$ nil )
								(progn
;;;									(princ (strcat "\nSQL �̕��@���Ԉ���Ă��܂��F" &SQL "\n"))
									(setq #listRet$ nil)
								)
								(progn
									#listRet$	; return
								)
							)
						)
						(progn
;;;							(princ (strcat "\nDB �̐ݒ肪�Ԉ���Ă��܂�(�X�L�[�}��񂪂���܂���)\n"))
							nil	; return
						)
					)
				)

				(progn
					#listRet$	; return
				)
			)
		)
		(progn
;;;			(princ (strcat "\n" (asi_dbms &session) "\n"))
			(DBSqlQuery &session &sql)
		)
	)
)

|;
;;;<HOM>***********************************************************************
;;; <�֐���>		: SqlGet
;;; <�����T�v>	: �e�X�g�p�ASQL ���ɂ��f�[�^�̏������[�`��
;;; <�߂�l>		: �f�[�^���X�g	ex) (( �f�[�^1 ) ( �f�[�^2 ))
;;; <�쐬>			: 1998/05/27 -> 1998/05/28	���� �����Y
;;; <���l>			: ���� Lisp �׋��p
;;;***********************************************************************>HOM<
(defun SqlGet
	(
		&DBName
		&id
		&pass
		&Sql
	/
		#session
		#listH
	)
	(setq #session (DBConnect &DBName &id &pass))									; DB �Ɛڑ�
	(if (/= #session nil)																						; �ڑ��������������`�F�b�N
		(progn
			(setq #listH (DBSqlAutoQuery #session &Sql))
			(DBDisconnect #session)																		; DB �Ƃ̐ڑ���ؒf����
			(if (/= #listH nil)
				(progn
					(princ (strcat "\n" &Sql))
				)
				;; else
				(progn
					(princ (strcat "\nSQL ���Ɉُ킪����܂�:" &Sql "\n"))
				)
			)
			#listH	; return
		)
		;; else
		(progn	; DB �ւ̐ڑ��Ɏ��s����
			(princ (strcat "\nDB �Ɛڑ��ł��܂���F" &DBName "\n"))
			nil	; return
		)
	)
)


; strtol convert string of chars into list of 1-char strings
(defun strtol ( s / lst c )
	(repeat (setq c (strlen s))
		(Setq lst (cons (substr s c 1) lst)
					c		(1- c)
	))
	lst
)

;; helper function
(defun strp(s)(and(='STR(type s))(/= s "")))

;<HOM>*************************************************************************
; <�֐���>		: strtok
; <�����T�v>	: ���ݸ�İ��
; <�߂�l>		:
; <�쐬>			:
; <���l>			: ��.(strtok " 1,,  2,  3,")->{"1" "2" "3"}
;*************************************************************************>MOH<
(defun strtok(strng chs / len c l s cnt chsl )
	(setq chsl (strtol chs))
	(setq len (strlen strng) s "" cnt (1+ len))
	(while (> (setq cnt (1- cnt)) 0)
		(setq c (substr strng cnt 1))
		(if (member c chsl)
			(if (strp s)
				(setq l (cons s l) s "")
			)
		;else
			(setq s (strcat c s))
		)
	)
	(if (strp s)
		(cons s l)
		l
	)
)

;STRPARSE FOR PARSING STRING (and keeping null tokens)
(defun strparse(strng chs / len c l s chsl cnt );;delim==one-of-chs.
	(setq chsl (strtol chs))
	(setq len (strlen strng) s "" cnt (1+ len))
	(while (> (setq cnt (1- cnt)) 0)
		(setq c (substr strng cnt 1))
		(if (member c chsl)
			;(if (/= cnt len);; "1,2," -> ("1" "2") and not ("1" "2" "")
				(setq l (cons s l) s "")
			;)
			(setq s (strcat c s))
		)
	)
	(cons s l)	 ;; ",1,2" -> ("" "1" "2")
)

;/////////////////////////////////////////////////////////////////////////

;////////////////////////////////////////////////////////////////////////////////
(defun acad-object ()
  (cond (*acad-object*)       ; �ۑ�����Ă���I�u�W�F�N�g��Ԃ�
    (t
     (setq *acad-object* (vlax-get-acad-object))
    )
  )
)

(defun active-document ()
  (cond (*active-document*)   ; �ۑ�����Ă���I�u�W�F�N�g��Ԃ�
    (t
     (setq *active-document* (vla-get-activedocument (acad-object)))
    )
  )
)

(defun model-space ()
  (cond (*active-document*)   ; �ۑ�����Ă���I�u�W�F�N�g��Ԃ�
    (t
     (setq *model-space* (vla-get-modelspace (active-document)))
    )
  )
)

(princ)