;|
;;;<HOM>***********************************************************************
;;; <関数名>		: DBConnect
;;; <処理概要>	: DB に接続する
;;; <戻り値>		: 成功:セッション名(ex:("SQLSESSION" 1.0))	失敗:nil
;;; <作成>			: 1998/06/04 -> 1998/06/04	松木 健太郎
;;; <備考>			:
;;;***********************************************************************>HOM<
(defun DBConnect
	(
		&DBName			; データベース名
		&id					; ユーザー名
		&pass				; パスワード
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
	(setq #session (asi_connect &DBName &id &pass))									; DB と接続
	(if (= (asi_objp #session) T)																		; 接続が成功したかチェック
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
;;; <関数名>		: DBDisconnect
;;; <処理概要>	: 接続されている DB を切断する
;;; <戻り値>		: 成功: T		失敗: nil
;;; <作成>			: 1998/06/04 -> 1998/06/04	松木 健太郎
;;; <備考>			:
;;;***********************************************************************>HOM<
(defun DBDisConnect
	(
		&session				; セッション名
	/
	)
	(if (= (asi_objp &session) T)																; 接続の状態チェック
		(progn
			(asi_disconnect &session)																		; DB との接続を切断する
		)
		;; else
		(progn
			nil	; return
		)
	)
)


;;;<HOM>***********************************************************************
;;; <関数名>		: DBSqlQuery
;;; <処理概要>	: DB から SQL 文によりデータを所得する
;;; <戻り値>		: データリスト	ex) (( データ1 ) ( データ2 ))
;;; <作成>			: 1998/05/28 -> 1998/05/28	松木 健太郎
;;; <備考>			: 使用するには、DB に接続されていなければなりません
;;;								Access のスキーマ指定問題を自己解決する場合は DBSqlAutoQuery よりこちらを使って下さい
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

	(if (/= #statement nil)																			; 上記処理(文と接続の確立)が成功したかチェック
		(progn
			(setq #cursor (asi_alloc #statement "CURS-NAME1"))			; SQL のカーソルを割り当てる
			(asi_open #cursor)																			; SQL カーソルのオープン

			(setq #listH (asi_coldsc #cursor))											; DB の1行目である列名を受信する。
			(setq #listC (asi_fetch #cursor))												; DB のデータの1行目を受信
			(while (/= #listC nil)
				(setq #listRet$ (append #listRet$ (list #listC)))
				(setq #listC (asi_fetch #cursor "NEXT"))							; 以後、2行目、3行目と受信していく
			)

			(if (asi_objp #cursor)																	; SQL カーソルのオープンチェック
				(asi_close #cursor)																		; SQL カーソルがオープンされていた閉じる
			)

			(if (asi_objp #statement)																; 文と接続の確立をチェック
				(asi_deallocstm #statement)														; 文と接続が確立されていたら、解放する
			)

			#listRet$	; return
		)
		;; else
		(progn	; SQL 文のミス
			nil	; retrurn
		)
	)
)


;;;<HOM>***********************************************************************
;;; <関数名>		: DBSqlAutoQuery
;;; <処理概要>	: DB から SQL 文によりデータを取得する
;;; <戻り値>		: 成功 : データリスト	ex) (( データ1 ) ( データ2 ))		失敗 : nil
;;; <作成>			: 1998/05/28 -> 1998/05/28	松木 健太郎
;;; <備考>			: 使用するには、DB に接続されていなければなりません
;;;								スキーマ名は、指定しても指定しなくてもどちらでも構いません
;;;								スキーマ指定問題を自己解決する場合は DBSqlQuery を使って下さい
;;;								ex) (DBSqlAutoQuery '("SQLSESSION" 65.0) "select * from Syain")
;;;***********************************************************************>HOM<
(defun DBSqlAutoQuery
	(
		&session		; 接続セッション名
		&Sql				; 照会 SQL 文
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
;;;					(princ "\n取得失敗\n")
					(setq #listH (DBSqlQuery &session "select SCHEMA_NAME from INFORMATION_SCHEMA.SCHEMATA for read only"))
					(if (/= #listH nil)
						(progn
							(setq #listTemp (strtok &Sql ","))
							(setq #listTemp2 (car #listTemp))
							(foreach #ll (cdr #listTemp)
								(setq #listTemp2 (strcat #listTemp2 ", " #ll))
							)
							;; スキーマの自動結合
							(setq #listTemp (strtok #listTemp2 " "))									; SQL 文分割
							(setq #listCa (strcat (car #listTemp) " "))					; 初期値代入
							(foreach #nn (cdr #listTemp)
								(if (= (strcase #nn) "FROM")
									(progn
										;; FROM の後に、スキーマ名を挿入する
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
														(setq #listCa (strcat #listCa #nn " "))				; 既存データの結合
													)
													(progn
														(setq #listCa (strcat #listCa "\"" (car (car #listH)) "\"." #nn " "))
													)
												)
											)
											(progn
												(setq #listCa (strcat #listCa #nn " "))				; 既存データの結合
											)
										)
									)
								)
							)
;;;							(princ (strcat "\nCheck:" #listCa "\n"))

;;;							(princ "\n\nスキーマ付加\n")
;;							(dpr '#listCa)

							(setq #listRet$ (DBSqlQuery &session #listCa))
							(if (= #listRet$ nil )
								(progn
;;;									(princ (strcat "\nSQL の文法が間違っています：" &SQL "\n"))
									(setq #listRet$ nil)
								)
								(progn
									#listRet$	; return
								)
							)
						)
						(progn
;;;							(princ (strcat "\nDB の設定が間違っています(スキーマ情報がありません)\n"))
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
;;; <関数名>		: SqlGet
;;; <処理概要>	: テスト用、SQL 文によるデータの所得ルーチン
;;; <戻り値>		: データリスト	ex) (( データ1 ) ( データ2 ))
;;; <作成>			: 1998/05/27 -> 1998/05/28	松木 健太郎
;;; <備考>			: 松木 Lisp 勉強用
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
	(setq #session (DBConnect &DBName &id &pass))									; DB と接続
	(if (/= #session nil)																						; 接続が成功したかチェック
		(progn
			(setq #listH (DBSqlAutoQuery #session &Sql))
			(DBDisconnect #session)																		; DB との接続を切断する
			(if (/= #listH nil)
				(progn
					(princ (strcat "\n" &Sql))
				)
				;; else
				(progn
					(princ (strcat "\nSQL 文に異常があります:" &Sql "\n"))
				)
			)
			#listH	; return
		)
		;; else
		(progn	; DB への接続に失敗した
			(princ (strcat "\nDB と接続できません：" &DBName "\n"))
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
; <関数名>		: strtok
; <処理概要>	: ｽﾄﾘﾝｸﾞﾄｰｸﾝ
; <戻り値>		:
; <作成>			:
; <備考>			: 例.(strtok " 1,,  2,  3,")->{"1" "2" "3"}
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
  (cond (*acad-object*)       ; 保存されているオブジェクトを返す
    (t
     (setq *acad-object* (vlax-get-acad-object))
    )
  )
)

(defun active-document ()
  (cond (*active-document*)   ; 保存されているオブジェクトを返す
    (t
     (setq *active-document* (vla-get-activedocument (acad-object)))
    )
  )
)

(defun model-space ()
  (cond (*active-document*)   ; 保存されているオブジェクトを返す
    (t
     (setq *model-space* (vla-get-modelspace (active-document)))
    )
  )
)

(princ)
