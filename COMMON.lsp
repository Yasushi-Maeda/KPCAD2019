;<HOM>************************************************************************
; <関数名>    : dpr
; <処理概要>  : デバッグ用出力
; <戻り値>    :
; <作成>      : 97-01-31 川本成二
; <備考>      :
;              例）シンボル #a (値が3) を出力
;                  (dpr '#a)
;                  出力内容   "#a = 3"
;************************************************************************>MOH<
(defun dpr (
    &val    ;(SYM) シンボル名
  )
  (princ "\n")
  (princ &val)
  (princ " = ")
  (princ (eval &val))
  (princ)
)
;dpr

;<HOM>************************************************************************
; <関数名>    : dtr
; <処理概要>  : 角度からラジアンに変換
; <戻り値>    :
; <作成>      : 96-12-03 川本成二
; <備考>      : なし
;************************************************************************>MOH<
(defun dtr (
    &a  ;(REAL) 角度
  )
  (* pi (/ &a 180.0))
)
;dtr

;<HOM>************************************************************************
; <関数名>    : rtd
; <処理概要>  : ラジアンから角度に変換
; <戻り値>    :
; <作成>      : 96-12-03 川本成二
; <備考>      : なし
;************************************************************************>MOH<
(defun rtd (
    &a  ;(REAL) ラジアン
  )
  (/ (* &a 180.0) pi)
)
;rtd

;<HOM>*************************************************************************
; <関数名>    : rtois
; <処理概要>  : 実数値を整数文字列に変換する
; <戻り値>    :
;       (INT) : 整数文字列
; <作成>      : 1998-06-15
; <備考>      : なし
;*************************************************************************>MOH<
(defun rtois (
    &r   ;(REAL)実数値
  )
  (itoa (atoi (rtos &r 2 2)))
)
;rtois

;<HOM>*************************************************************************
; <関数名>    : MakeLayer
; <処理概要>  : 画層を作成する
; <戻り値>    :
; <作成>      : 98-03-25 川本成二
; <備考>      : なし
;*************************************************************************>MOH<
(defun MakeLayer (
    &lay        ;(STR)画層名
    &col        ;(INT)色
    &lt         ;(STR)線種
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
; <関数名>    : MakeLwPolyLine
; <処理概要>  : 点列からライトウェイトポリラインを作成する
; <戻り値>    :
;       ENAME : 作成したライトウェイトポリライン名
; <作成>      : 98-03-25 川本成二
; <備考>      : なし
;*************************************************************************>MOH<
(defun MakeLwPolyLine (
    &pt$  ;(LIST)構成座標点ﾘｽﾄ
    &cls  ;(INT) 0=開く/1=閉じる
    &elv  ;(REAL)高度
    /
    #vn #eg #pt #pw
  )
  ;// 頂点数
  (setq #pw (getvar "PLINEWID"))
  (setq #vn (length &pt$))
  (setq #eg
    (list
      '(0 . "LWPOLYLINE")
      '(100 . "AcDbEntity")
      '(100 . "AcDbPolyline")
      (cons 90 #vn)          ;頂点数
      (cons 70 &cls)         ;頂点数
      (cons 38 &elv)         ;頂点数
    )
  )
  (foreach #pt &pt$
    (setq #eg (append #eg (list (cons 10 #pt))))
    (setq #eg (append #eg (list (cons 40 #pw))))
    (setq #eg (append #eg (list (cons 41 #pw))))
  )
  (entmake #eg)
  ;// ポリライン図形名を返す
  (entlast)
)
;MakeLwPolyLine

;<HOM>*************************************************************************
; <関数名>    : GetLwPolyLinePt
; <処理概要>  : ライトウェイトポリラインの点列を取得する
; <戻り値>    :
;        LIST : ライトウェイトポリラインの点列
; <作成>      : 98-03-25 川本成二
; <備考>      :
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
; <関数名>    : ReadCSVFile
; <処理概要>  : CSVファイルを読み込む
; <戻り値>    :
; <作成>      : 98-04-20 川本成二
; <備考>      :
;*************************************************************************>MOH<
(defun ReadCSVFile (
    &csvfile
    /
    #fp
    #rstr
    #itm$
    #res$$
  )
  (setq #fp (open &csvfile "r")) ;// ﾌｧｲﾙｵｰﾌﾟﾝ(READ)

  ;// ﾌｧｲﾙを読み込む
  (while (setq #rstr (read-line #fp))
    ;// 文字列をﾃﾞﾐﾘﾀで区切る
    (setq #itm$ (strparse #rstr ","))
    (setq #res$$ (append #res$$ (list #itm$)))
  )
  (close #fp)  ;// ﾌｧｲﾙｸﾛｰｽﾞ

  ;// 結果を返す
  #res$$
)
;ReadCSVFile

;<HOM>************************************************************************
; <関数名>    : DelListItem
; <処理概要>  : リスト中の指定要素を削除する
; <戻り値>    :
;      リスト : 削除後のリスト
;
; <備考>      : 始めにみつかった要素のみ削除
;************************************************************************>MOH<
(defun DelListItem (
    &list$    ;対象リスト
    &mem      ;削除要素
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
; <関数名>    : IsEntInPolygon
; <処理概要>  : 図形が領域内にあるかチェック
; <戻り値>    :
;           T : 領域内
;         nil : 領域外
; <備考>      : modeについて
;                 WP 窓領域で領域内
;                 CP 交差領域で領域内
;*************************************************************************>MOH<
(defun IsEntInPolygon (
    &en      ;(ENAME)内外判定図形
    &pt$     ;(LIST) 内外判定領域座標リスト
    &mode    ;(STR)  モード("WP":ポリゴン窓  "CP":ポリゴン交差)
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
; <関数名>    : IsPtInPolygon
; <処理概要>  : 指定点が領域内にあるかチェック
; <戻り値>    :
; <備考>      : modeについて
;                 WP 窓領域で領域内
;                 CP 交差領域で領域内
;*************************************************************************>MOH<
(defun IsPtInPolygon (
    &pt        ;(LIST)指定点
    &pt$       ;(LIST)内外判定領域座標リスト
    /
    #ss #ret
  )
  ;// ダミー点は作図する
  (entmake
    (list
      (cons 0 "POINT")
      (cons 100 "AcDbEntity")
      (cons 100 "AcDbPoint")
      (cons 10 &pt)
    )
  )
  ;// ダミー点が領域内にあるか調べる
  (setq #ret (IsEntInPolygon (entlast) &pt$ "CP"))
  ;// ダミー点を削除する
  (entdel (entlast))
  ;// 結果を返す
  #ret
)
;IsPtInPolygon

;<HOM>*************************************************************************
; <関数名>    : YesNoDialog
; <処理概要>  : 警告ダイアログ表示(Yes,Cancel)
; <戻り値>    :
;           T : はい
;         nil : いいえ
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(setq YesNoDialog CFYesNoDialog)

;<HOM>*************************************************************************
; <関数名>    : GetVal
; <処理概要>  : リスト情報
; <戻り値>    :
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun GetVal (
    &grp           ;(STR) グループコード
    &ele           ;(LIST)リスト情報
  )
  (cond
    ((= (type &ele) 'ENAME)          ;eleが図形名のとき
      (cdr (assoc &grp (entget &ele)))
    )
    ((not &ele) nil)                 ;eleがnilのとき
    ((not (listp &ele)) nil)         ;eleがおかしな時
    ((= (type (car &ele)) 'ENAME)    ;entselが返すリストのとき
      (cdr (assoc &grp (entget (car &ele))))
    )
    (T (cdr (assoc &grp &ele)))       ;entgetが返すリストのとき
  )
)
;GetVal

;<HOM>*************************************************************************
; <関数名>    : setError
; <処理概要>  : ｴﾗｰ関数
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
; <関数名>    : err_function
; <処理概要>  : ｴﾗｰ関数
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
; <関数名>    : ai_strtrim
; <処理概要>  : 文字列の空白削除
; <戻り値>    :
;         STR : 空白削除文字列
; <作成>      : 1999-12-20
; <備考>      :
;               "    文字列    " -> "文字列"
;*************************************************************************>MOH<
(defun ai_strtrim (
    &s          ;(STR)文字列
  )
  (cond
    ((/= (type &s) 'str) nil)
    (t (ai_strltrim (ai_strrtrim &s)))
  )
)
;ai_strtrim

;<HOM>*************************************************************************
; <関数名>    : ai_strltrim
; <処理概要>  : 文字列の左空白削除
; <戻り値>    :
;         STR : 空白削除文字列
; <作成>      : 1999-12-20
; <備考>      :
;               "    文字列" -> "文字列"
;*************************************************************************>MOH<
(defun ai_strltrim (
    &s          ;(STR)文字列
  )
  (cond
    ((eq &s "") &s)
    ((/= " " (substr &s 1 1)) &s)
    (t (ai_strltrim (substr &s 2)))
  )
)
;ai_strltrim

;<HOM>*************************************************************************
; <関数名>    : ai_strrtrim
; <処理概要>  : 文字列の右空白削除
; <戻り値>    :
;         STR : 空白削除文字列
; <作成>      : 1999-12-20
; <備考>      :
;               "文字列     " -> "文字列"
;*************************************************************************>MOH<
(defun ai_strrtrim (
    &s          ;(STR)文字列
  )
  (cond
    ((eq &s "") &s)
    ((/= " " (substr &s (strlen &s) 1)) &s)
    (t (ai_strrtrim (substr &s 1 (1- (strlen &s)))))
  )
)
;ai_strrtrim

;;;<HOM>************************************************************************
;;; <関数名>  : C:KpChg
;;; <処理概要>: ２Ｄ要素－その他－線種／色変更
;;; <作成>    : 2001/05/15 GSMより移植
;;; <戻り値>  : なし
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
;;; <関数名>  : NRElemChgLtypeDialog
;;; <処理概要>: ２Ｄ要素－線種ﾀﾞｲｱﾛｸﾞ
;;; <作成>    : 2001/05/15 GSMより移植
;;; <戻り値>  : なし
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
;;; <関数名>  : NRElemChgLtCoDialog
;;; <処理概要>: ２Ｄ要素－線種／色変更ダイアログ
;;; <作成>    : 2001/05/15 GSMより移植
;;; <戻り値>  : なし
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
;;; <関数名>     : C:PickUP_suisen
;;; <処理概要>   : 現役水栓をピックアップする
;;; <戻り値>     : なし
;;; <作成>       : 06/06/13 YM
;;; <備考>       : 
;;;*************************************************************************>MOH<
(defun C:PickUP_suisen (
  /
	#CG_DBNAME #CG_DEBUG #CSV$$ #DATE_TIME #DUM$$ #FIL #ISERI #MDB #OFILE #SERI #SERI$$
  )

    ;;;**********************************************************************
    ;;; ﾙｰﾌﾟ処理
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#HINBAN #QRY$$ #QRY_KAISO$$ #qry_zukei$$
      )

				(setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))

				(princ "\n-------------------------" #fil)
				(princ (strcat "\nDB名:" CG_DBNAME) #fil)
				(princ "\n-------------------------" #fil)

				;品番基本検索
		    (setq #qry$$
	      	(CFGetDBSQLRec CG_DBSESSION "品番基本"
		        (list
		          (list "性格CODE" "510" 'INT)
		        )
		      )
		    )

				(foreach #qry$ #qry$$
					(setq #hinban (nth 0 #qry$))
					;階層検索
			    (setq #qry_kaiso$$
		      	(CFGetDBSQLRec CG_DBSESSION (strcat "階層" CG_SeriesCode)
			        (list
			          (list "階層名称" #hinban 'STR)
			        )
			      )
			    )
					(if (= nil #qry_kaiso$$)
						(princ (strcat "\n階層に存在しない," #hinban) #fil)
						;else
						(progn
							(if (> 0 (nth 1 (car #qry_kaiso$$)))
								(princ (strcat "\n×," #hinban) #fil)
								;else
								(progn
									;品番図形検索
							    (setq #qry_zukei$$
						      	(CFGetDBSQLRec CG_DBSESSION "品番図形"
							        (list
							          (list "品番名称" #hinban 'STR)
							          (list "LR区分"   "Z"     'STR)
							        )
							      )
							    )
									(if (= nil #qry_zukei$$)
										(princ (strcat "\n○," #hinban ",品番図形にありません") #fil)
										;else
										(progn
											(setq #id (nth 6 (car #qry_zukei$$)));2008/06/28 OK!
											(princ (strcat "\n○," #hinban ",ID=" #id) #fil)
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


	(StartUndoErr);// コマンドの初期化

	(setvar "CMDECHO" 0)
	(C:de0)

	(setq #CG_DBNAME CG_DBNAME);現在のシリーズ

	(setq #CG_DEBUG CG_DEBUG);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ
	(setq CG_DEBUG 0);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ

	;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	;対象ｼﾘｰｽﾞ情報 0/01/10 YM ADD
  (setq #iseri (strcat CG_SYSPATH "temp\\pickup_seri.txt"));ﾁｪｯｸ対象ｼﾘｰｽﾞの読み込み
  (setq #CSV$$ (ReadCSVFile #iseri))
	;先頭に";"があったら除く
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

  (setq #ofile  (strcat CG_SYSPATH "temp\\kekka.txt"));ﾁｪｯｸ結果出力ﾌｧｲﾙ
  (setq #fil (open #ofile "W" ))

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n" #fil)
	(princ (strcat "\n--------------------------------------") #fil)
	(princ (strcat "\n水栓一覧 ○:上位階層(+),×:上位階層(-)") #fil)
	(princ (strcat "\n--------------------------------------") #fil)
  (princ "\n" #fil)

	(foreach #seri$ #seri$$ ; 各ｼﾘｰｽﾞでのloop
		(setq CG_SeriesDB (nth 0 #seri$))
		(setq CG_DBNAME (nth 0 #seri$))
		(setq CG_SeriesCode (nth 1 #seri$))
		(setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))

		(###EXE)

	);_if

	;DB接続,ﾃﾞﾊﾞｯｸﾓｰﾄﾞを戻す
	(setq CG_DBSESSION  (dbconnect #CG_DBNAME  "" ""))
	(setq CG_DEBUG #CG_DEBUG);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ

	(setq *error* nil)
	(if #fil (close #fil))

	(startapp "notepad.exe" #ofile)
  (princ)
);C:PickUP_suisen

;;;<HOM>*************************************************************************
;;; <関数名>     : C:zukei_kosu
;;; <処理概要>   : 性格ｺｰﾄﾞ="1??"で[品番図形]に図形IDがあるものの一覧を出力
;;;                対象ｼﾘｰｽﾞは、～\system\log\zukei_kosu.txt
;;; <戻り値>     : なし
;;; <作成>       : 06/11/6 YM
;;; <備考>       : 
;;;*************************************************************************>MOH<
(defun C:zukei_kosu (
  /
	#CG_SERIESCODE #CG_SERIESDB #CSV$$ #DATE_TIME #DUM$$ #FIL #HINBAN #I #IFILE #MDB
	#QRY_KIHON$$ #REC$$ #SERI #SERI$$ #SKK #ZUKEIID #ZUKEIID$
  )

    ;;;**********************************************************************
    ;;; ﾘｽﾄの重複レコードを除く
    ;;; 05/06/01 YM
    ;;;**********************************************************************
    (defun ##delREC0 (
      &lis$ ; #hin$のﾘｽﾄ形式
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
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n性格ｺｰﾄﾞ=1??で[品番図形]に図形IDがあるものの一覧を出力" #fil)
  (princ "\n" #fil)

	;対象ｼﾘｰｽﾞ情報
  (setq #ifile (strcat CG_SYSPATH "LOG\\zukei_kosu.txt"));ﾁｪｯｸ対象ｼﾘｰｽﾞの読み込み
  (setq #CSV$$ (ReadCSVFile #ifile))
	;先頭に";"があったら除く
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
	(foreach #seri$ #seri$$ ; 各ｼﾘｰｽﾞでのloop
		(setq CG_SeriesDB (nth 0 #seri$))
		(setq CG_SeriesCode (nth 1 #seri$))
		(setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))
		(princ (strcat "\nｼﾘｰｽﾞ:" CG_SeriesDB))
		(princ (strcat "\nｼﾘｰｽﾞ:" CG_SeriesDB) #fil)
		;★[品番図形]★-----------------------------------------------
		(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "品番図形")))
		(setq #i 0)
		(foreach #rec$ #rec$$
			(setq #hinban  (nth 0 #rec$))
			(setq #zukeiID (nth 6 #rec$));2008/06/28 OK!
			(if (and (= #zukeiID nil)(= #zukeiID ""))
				nil
				;else
				(progn
					;品番基本検索 性格ｺｰﾄﾞ
			    (setq #qry_kihon$$
		      	(CFGetDBSQLRec CG_DBSESSION "品番基本"
			        (list
			          (list "品番名称" #hinban 'STR)
			        )
			      )
			    )
					(if #qry_kihon$$
						(progn
							(setq #skk (nth 3 (car #qry_kihon$$)))
							(if (and (< 99.99 #skk)(> 199.9 #skk))
								(progn
;;;									(princ (strcat "\n品番:" #hinban) #fil)
									(setq #i (1+ #i))
								)
							);_if
						)
					);_if
					
				)
			);_if
		);foreach
		(princ (strcat "\n--- 個数:" (itoa #i)) #fil)
	);foreach

	(princ "\n" #fil)
	(princ "\n")

	(princ "\n★★チェック終了★★")
	(princ "\n★★チェック終了★★" #fil)
  (close #fil)


  ;// 元のデータベースに接続する
	(setq CG_SeriesDB #CG_SeriesDB)
	(setq CG_SeriesCode #CG_SeriesCode)

  (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))

  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\SLIDE-CHECK.txt"))
	(princ)
);C:zukei_kosu

;<HOM>*************************************************************************
; <関数名>    : C:TENBAN_SAKUSEI
; <処理概要>  : KPCADのｷｯﾁﾝﾌﾟﾗﾝから天板だけをdwg保存する
; <戻り値>    : なし
; <作成日>    : 06/11/08 YM
; <備考>      : 
;　             [前提]図面に何もない状態からﾌﾟﾗﾝ検索を一回行った直後(配置角度=0)
;               現在保存場所,名前はきめうち(Xdataは削除して保存)
;               天板1枚目===>(strcat CG_SYSPATH "LOG\\WT_1.dwg")
;               天板2枚目===>(strcat CG_SYSPATH "LOG\\WT_2.dwg")
;*************************************************************************>MOH<
(defun C:TENBAN_SAKUSEI (
  /
	#BASEWT #I #SS #SSOLDSYM #SSWT #SYM #WT #XD$ #XY #Z #OFNAME
  )
  (StartUndoErr);// コマンドの初期化
	(setvar "FILEDIA" 0)
	(setvar "CMDECHO" 0)
	(C:de0)

;;;  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
;;;	(if (and #ss (< 0 (sslength #ss)))
;;;		(progn
;;;			(setq #i 0)
;;;			(repeat (sslength #ss)
;;;				(setq #sym (ssname #ss #i))
;;;				; G_LSYM部材削除
;;;		    (setq #ssOLDSYM (CFGetSameGroupSS #sym))
;;;		    (command "_erase" #ssOLDSYM "")
;;;				(command "_purge" "BL" "*" "N")
;;;				(command "_purge" "BL" "*" "N")
;;;				(command "_purge" "BL" "*" "N")
;;;				(setq #i (1+ #i))
;;;			);repeat
;;;		)
;;;	);_if

	;図面上のWTを検索
  (setq #ssWT (ssget "X" '((-3 ("G_WRKT")))))
	(if (and #ssWT (<= 1 (sslength #ssWT)))
		(progn
			(setq #i 0)
			(repeat (sslength #ssWT)
				(setq #WT (ssname #ssWT #i))
				;保存パス&ファイル名称
				(setq #ofname (strcat CG_SYSPATH "LOG\\WT_" (itoa (1+ #i)) ".dwg"))
				;Xdata "G_WRKT" 取得
				(setq #xd$ (CFGetXData #WT "G_WRKT"))
				;WT下面の位置
				(setq #Z (nth 8 #xd$))
				;WT底面の左上点
				(setq #XY (nth 32 #xd$))
				;WT挿入基点
				(setq #baseWT (list (car #XY) (cadr #XY) #Z))
				;Xdata=G_WRKT,G_WTSETの削除
				(DelAppXdata #WT "G_WRKT")
				(DelAppXdata #WT "G_WTSET")
				(command "._wblock" #ofname "" #baseWT #WT "")
				(setq #i (1+ #i))
			)
		)
	);_if

	(c:clear) ; 図面ｸﾘｱｰ
	; ｸﾞﾙｰﾌﾟ分解
	(KP_DelUnusedGroup)
	(command "_purge" "BL" "*" "N")
	(command "_purge" "BL" "*" "N")
	(command "_purge" "BL" "*" "N")

  (setq *error* nil)
  (CFCmdDefFinish)
  (princ)
);C:TENBAN_SAKUSEI

;<HOM>*************************************************************************
; <関数名>    : new_old_kakaku_hantei
; <処理概要>  : 新旧価格判定
; <戻り値>    :
; <作成>      : 07/10/02 YM ADD
; <備考>      :
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
; <関数名>    : SetPlan_Kiki_Name
; <処理概要>  : シリ別機器一覧の検索
; <戻り値>    :
; <作成>      : 07/10/02 YM ADD
; <備考>      : 07/10/06 YM ADD DIPLOA時に検索KEY追加
;*************************************************************************>MOH<
(defun SetPlan_Kiki_Name (
	/
	#QRY$ #DRSERI #KEY
  )
	(if (= CG_SeriesCode "D")
		(progn ;DIPLOAのときはKEYを追加
			(setq #DRSeri (substr CG_DRSeriCode 1 1))
			(if (or (= #DRSeri "A")(= #DRSeri "B"))
				(setq #KEY "SP")
				;else
				(setq #KEY "EX")
			);_if

		  (setq #qry$ (car
			  (CFGetDBSQLRec CG_CDBSESSION "シリ別機器一覧"
			    (list
						(list "略称" (strcat "NK_" CG_SeriesDB) 'STR)
						(list "KEY1" #KEY                       'STR);"SP" ro "EX"
			    )
			  ))
			)
		)
		(progn
		  (setq #qry$ (car
			  (CFGetDBSQLRec CG_CDBSESSION "シリ別機器一覧"
			    (list
						(list "略称" (strcat "NK_" CG_SeriesDB)   'STR)
			    )
			  ))
			)
		)
	);_if
	#qry$
);SetPlan_Kiki_Name

;;;<HOM>*************************************************************************
;;; <関数名>     : C:EXhinban
;;; <処理概要>   : 品番を指定して各シリーズの(階層,品番基本,品番最終)に存在するかどうか
;;;                一覧を出力する
;;; <戻り値>     : なし
;;; <作成>       : 05/09/16 YM
;;; <改良>       : 05/12/13 YM ついでに仕様,商品名を出力
;;; <備考>       : 何回も使用するとエラー: ADS 要求エラーが出てしまう
;;;*************************************************************************>MOH<
(defun C:EXhinban (
  /
	#CG_DBNAME #CG_DEBUG #CG_SERIESCODE #CG_SERIESDB #CSV$$ #DATE_TIME #DUM$$ #FIL
	#HINBAN$ #IFILE #ISERI #KAI$$ #KEKKA$$ #KEKKA1 #KEKKA2 #MDB #OFILE #QRY1$$
	#QRY2$$ #SERI #SERI$$ #UPID #UPID_FLG #UPID_UPKAISO #kekka44
  )

    ;;;**********************************************************************
    ;;; ﾙｰﾌﾟ処理
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#KAI$$ #KEKKA1 #KEKKA2 #QRY1$$ #QRY2$$ #UPID #UPID_FLG #UPID_UPKAISO
      )

			(princ (strcat "\n--- " CG_SeriesDB " ---"))
      (foreach #hinban #hinban$
				(princ (strcat "\n " #hinban))

        ;階層検索
        (setq #qry1$$
          (CFGetDBSQLRec CG_DBSESSION "階層"
            (list
              (list "階層名称" #hinban 'STR)
            )
          )
        )

        (if #qry1$$
          (progn
            (setq #UPid (nth 1 (car #qry1$$)));1つめのﾚｺｰﾄﾞの上位階層ID
            (if (> 0 (read #UPid))
              (setq #UPid_flg -1)
              ;else
              (progn ;上位階層ID>0でも階層ﾌｫﾙﾀﾞ自体の上位階層IDを調べる
                ;上位階層の上位階層IDを取得
                (setq #kai$$
                  (CFGetDBSQLRec CG_DBSESSION "階層"
                    (list
                      (list "階層ID" #UPid 'STR)
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
              (setq #kekka1 "△");上位階層IDがﾏｲﾅｽ
              ;else
              (setq #kekka1 "○");上位階層IDがﾌﾟﾗｽ
            );_if
          )
          ;else
          (setq #kekka1 "×")
        );_if

        ;品番基本検索
        (setq #qry2$$
          (CFGetDBSQLRec CG_DBSESSION "品番基本"
            (list
              (list "品番名称" #hinban 'STR)
            )
          )
        )

        (if #qry2$$
          (setq #kekka2 "○")
          ;else
          (setq #kekka2 "×")
        );_if



        ;品番図形検索
        (setq #qry3$$
          (CFGetDBSQLRec CG_DBSESSION "品番図形"
            (list
              (list "品番名称" #hinban 'STR)
            )
          )
        )

        (if #qry3$$
          (setq #kekka3 "○")
          ;else
          (setq #kekka3 "×")
        );_if



        ;品番OP検索
        (setq #qry4$$
          (CFGetDBSQLRec CG_DBSESSION "品番OP"
            (list
              (list "品番名称" #hinban 'STR)
            )
          )
        )
        (if #qry4$$
          (setq #kekka4 "○")
          ;else
          (setq #kekka4 "×")
        );_if


        ;品番OP検索(2)
        (setq #qry44$$
          (CFGetDBSQLRec CG_DBSESSION "品番OP"
            (list
              (list "OP品番名称" #hinban 'STR)
            )
          )
        )
        (if #qry44$$
          (setq #kekka44 "○")
          ;else
          (setq #kekka44 "×")
        );_if


        ;品番最終検索
        (setq #qry5$$
          (CFGetDBSQLRec CG_DBSESSION "品番最終"
            (list
              (list "品番名称" #hinban 'STR)
            )
          )
        )
        (if #qry5$$
          (setq #kekka5 "○")
          ;else
          (setq #kekka5 "×")
        );_if

        (setq #kekka$$ (append #kekka$$ (list (list #hinban CG_DBNAME #kekka1 #kekka2 #kekka3 #kekka4 #kekka44 #kekka5))))

      );foreach

      (princ)
    );###EXE
    ;/////////////////////////////////////////////////////////////////////////////


  (StartUndoErr);// コマンドの初期化

  (setvar "CMDECHO" 0)
  (C:de0)

  ;07/02/19 YM ADD-S
  (setq #CG_SeriesDB   CG_SeriesDB)  ;"KJE"
  (setq #CG_DBNAME     CG_DBNAME)    ;"TK_KJE"
  (setq #CG_SeriesCode CG_SeriesCode);"J"
  ;07/02/19 YM ADD-E

  (setq #CG_DEBUG CG_DEBUG);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ
  (setq CG_DEBUG 0);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ

 ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;対象ｼﾘｰｽﾞ情報 0/01/10 YM ADD
  (setq #iseri (strcat CG_SYSPATH "LOG\\EXHIN_seri.txt"));ﾁｪｯｸ対象ｼﾘｰｽﾞの読み込み
  (setq #CSV$$ (ReadCSVFile #iseri))
  ;先頭に";"があったら除く
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

  (setq #ifile (strcat CG_SYSPATH "LOG\\EXHIN.txt"));ﾁｪｯｸ対象品番の読み込み
  (setq #CSV$$ (ReadCSVFile #ifile))
  (setq #hinban$ (mapcar 'car #CSV$$));ﾁｪｯｸ対象品番ﾘｽﾄ

  (setq #ofile  (strcat CG_SYSPATH "LOG\\kekka.txt"));ﾁｪｯｸ結果出力ﾌｧｲﾙ
  (setq #fil (open #ofile "W" ))

  (if (= nil #fil)
    (progn
      (CFAlertErr (strcat "kekka.txt が開けません。閉じてください"))
      (quit)
    )
  );_if


  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));日付
  (princ #date_time #fil ) ; 日付書き込み

  (princ "\n" #fil)
  (princ (strcat "\n-------------") #fil)
  (princ (strcat "\n品番存在確認 ") #fil)
  (princ (strcat "\n-------------") #fil)
  (princ "\n" #fil)

  (setq #kekka$$ nil);結果格納ﾘｽﾄ

  (foreach #seri$ #seri$$ ; 各ｼﾘｰｽﾞでのloop
    (setq CG_SeriesDB (nth 0 #seri$))
    (setq CG_DBNAME   (nth 0 #seri$))
    (setq CG_SeriesCode (nth 1 #seri$))
    (setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))

    ;DB接続できなくなったら再接続
    (if (= nil CG_DBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
      )
    );_if

    ;DB接続できなくなったら再接続
    (if (= nil CG_CDBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
      )
    );_if

    (###EXE)

  );_if

  ;結果出力
  (foreach #hinban #hinban$
    (princ (strcat "\n品番=" #hinban ":") #fil)
    (princ (strcat "\n     /階層/品番基本/品番図形/品番OP(品番)/品番OP(OP品番)/品番最終/") #fil)
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



;;;  ;DB接続,ﾃﾞﾊﾞｯｸﾓｰﾄﾞを戻す
;;;  (setq CG_DEBUG #CG_DEBUG);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ
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
;;; <関数名>     : C:HinbanLast_GAScheck
;;; <処理概要>   : 品番最終ガス種付きレコード登録状況チェック
;;; <戻り値>     : なし
;;; <作成>       : 07/10/16 YM
;;; <備考>       : 
;;;*************************************************************************>MOH<
(defun C:HinbanLast_GAScheck (
  /
	#CG_DBNAME #CG_DEBUG #CG_SERIESCODE #CG_SERIESDB #CSV$$ #DATE_TIME #DUM$$
	#FIL #ISERI #KEKKA$$ #MDB #OFILE #SERI #SERI$$
  )

    ;;;**********************************************************************
    ;;; ﾙｰﾌﾟ処理
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#HINBAN$ #QRY_BASE$$ #QRY_LAST$$
      )

      ;品番基本検索(210)
      (setq #qry_base$$
        (CFGetDBSQLRec CG_DBSESSION "品番基本"
          (list
            (list "性格CODE" "210" 'INT)
          )
        )
      )
			(setq #hinban$ nil)
			(foreach #qry_base$ #qry_base$$
				(setq #hinban$ (append #hinban$ (list (car #qry_base$))))
			)

      ;品番基本検索(113)
      (setq #qry_base$$
        (CFGetDBSQLRec CG_DBSESSION "品番基本"
          (list
            (list "性格CODE" "113" 'INT)
            (list "展開タイプ" "2" 'INT)
          )
        )
      )
			(setq #dum$ nil)
			(foreach #qry_base$ #qry_base$$
				(setq #dum$ (append #dum$ (list (car #qry_base$))))
			)
			(setq #hinban$ (append #hinban$ #dum$))
			
      ;品番最終検索
			(foreach #hinban #hinban$
        (setq #qry_LAST$$
          (CFGetDBSQLRec CG_DBSESSION "品番最終"
            (list
              (list "品番名称" #hinban 'STR)
            )
          )
        )
				(princ (strcat "\n" #hinban "," (itoa (length #qry_LAST$$))) #fil);出力
			)
      (princ)
    );###EXE
    ;/////////////////////////////////////////////////////////////////////////////


  (StartUndoErr);// コマンドの初期化

  (setvar "CMDECHO" 0)
  (C:de0)

  ;07/02/19 YM ADD-S
  (setq #CG_SeriesDB   CG_SeriesDB)  ;"KJE"
  (setq #CG_DBNAME     CG_DBNAME)    ;"TK_KJE"
  (setq #CG_SeriesCode CG_SeriesCode);"J"
  ;07/02/19 YM ADD-E

  (setq #CG_DEBUG CG_DEBUG);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ
  (setq CG_DEBUG 0);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ

 ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;対象ｼﾘｰｽﾞ情報 0/01/10 YM ADD
  (setq #iseri (strcat CG_SYSPATH "LOG\\LASTHIN_seri.txt"));ﾁｪｯｸ対象ｼﾘｰｽﾞの読み込み
  (setq #CSV$$ (ReadCSVFile #iseri))
  ;先頭に";"があったら除く
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

  (setq #ofile  (strcat CG_SYSPATH "LOG\\LASTkekka.txt"));ﾁｪｯｸ結果出力ﾌｧｲﾙ
  (setq #fil (open #ofile "W" ))

  (if (= nil #fil)
    (progn
      (CFAlertErr (strcat "LASTkekka.txt が開けません。閉じてください"))
      (quit)
    )
  );_if


;;;  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));日付
;;;  (princ #date_time #fil ) ; 日付書き込み

  (princ "\n" #fil)

  (setq #kekka$$ nil);結果格納ﾘｽﾄ

  (foreach #seri$ #seri$$ ; 各ｼﾘｰｽﾞでのloop
    (setq CG_SeriesDB (nth 0 #seri$))
    (setq CG_DBNAME   (nth 0 #seri$))
    (setq CG_SeriesCode (nth 1 #seri$))
    (setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))

    ;DB接続できなくなったら再接続
    (if (= nil CG_DBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
      )
    );_if

    ;DB接続できなくなったら再接続
    (if (= nil CG_CDBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
      )
    );_if

		(princ (strcat "\n◆ｼﾘｰｽﾞ," CG_DBNAME) #fil)
    (###EXE)

  );_if

  (setq *error* nil)
  (if #fil (close #fil))

  (startapp "notepad.exe" #ofile)

  (princ)
);C:HinbanLast_GAScheck

;;;<HOM>*************************************************************************
;;; <関数名>     : CHK_HAIBAN
;;; <処理概要>   : 廃版品かどうかチェック(階層,品番基本の存在確認)
;;; <戻り値>     : なし
;;; <作成>       : 07/10/16 YM
;;; <備考>       : 
;;;*************************************************************************>MOH<
(defun CHK_HAIBAN (
	&hinban
  /
	#HINBAN #KAI$$ #KEKKA1 #KEKKA2 #KEKKAC #QRY1$$ #QRY2$$ #QRY_C$$ #RET #UPID #UPID_FLG #UPID_UPKAISO
  )

  ;階層検索
  (setq #qry1$$
    (CFGetDBSQLRec CG_DBSESSION (strcat "階層" CG_SeriesCode)
      (list
        (list "階層名称" &hinban 'STR)
      )
    )
  )

  (if #qry1$$
    (progn
      (setq #UPid (nth 1 (car #qry1$$)));1つめのﾚｺｰﾄﾞの上位階層ID
      (if (> 0 #UPid)
        (setq #UPid_flg -1)
        ;else
        (progn ;上位階層ID>0でも階層ﾌｫﾙﾀﾞ自体の上位階層IDを調べる
          ;上位階層の上位階層IDを取得
          (setq #kai$$
            (CFGetDBSQLRec CG_DBSESSION (strcat "階層" CG_SeriesCode)
              (list
                (list "階層ID" (itoa (fix #UPid)) 'INT)
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
        (setq #kekka1 "△");上位階層IDがﾏｲﾅｽ
        ;else
        (setq #kekka1 "○");上位階層IDがﾌﾟﾗｽ
      );_if
    )
    ;else
    (setq #kekka1 "×")
  );_if


  ;共通階層検索
  (setq #qry_C$$
    (CFGetDBSQLRec CG_CDBSESSION "階層"
      (list
        (list "階層名称" &hinban 'STR)
      )
    )
  )

  (if #qry_C$$
    (progn
      (setq #UPid (nth 1 (car #qry_C$$)));1つめのﾚｺｰﾄﾞの上位階層ID
      (if (> 0 #UPid)
        (setq #UPid_flg -1)
        ;else
        (progn ;上位階層ID>0でも階層ﾌｫﾙﾀﾞ自体の上位階層IDを調べる
          ;上位階層の上位階層IDを取得
          (setq #kai$$
            (CFGetDBSQLRec CG_CDBSESSION "階層"
              (list
                (list "階層ID" (itoa (fix #UPid)) 'INT)
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
        (setq #kekkaC "△");上位階層IDがﾏｲﾅｽ
        ;else
        (setq #kekkaC "○");上位階層IDがﾌﾟﾗｽ
      );_if
    )
    ;else
    (setq #kekkaC "×")
  );_if


  ;品番基本検索
  (setq #qry2$$
    (CFGetDBSQLRec CG_DBSESSION "品番基本"
      (list
        (list "品番名称" &hinban 'STR)
      )
    )
  )

  (if #qry2$$
    (setq #kekka2 "○")
    ;else
    (setq #kekka2 "×")
  );_if

	(if (and #qry2$$ (or (= #kekka1 "○")(= #kekkaC "○")))
		(setq #ret T)
		(setq #ret nil)
	);_if

	#ret
);CHK_HAIBAN

;;;<HOM>*************************************************************************
;;; <関数名>     : C:HinbanLast_KakakuCheck
;;; <処理概要>   : 品番最終金額チェック
;;; <戻り値>     : なし
;;; <作成>       : 07/10/16 YM
;;; <備考>       : 
;;;*************************************************************************>MOH<
(defun C:HinbanLast_KakakuCheck (
  /
	#CG_DBNAME #CG_DEBUG #CG_SERIESCODE #CG_SERIESDB #CSV$$ #DATE_TIME #DUM$$
	#FIL #ISERI #KEKKA$$ #MDB #OFILE #SERI #SERI$$
  )

    ;;;**********************************************************************
    ;;; ﾙｰﾌﾟ処理
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#HINBAN$ #QRY_BASE$$ #QRY_LAST$$ #rec$$
			#BASE_YEN #BASE_YEN2 #DRKEY #GSKEY #HINBAN #LR #QRY_SERI$$ #SERI_YEN #SERI_YEN2 #YEN #YEN2
      )
			;品番最終検索
			(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 品番最終")))

			(foreach #rec$ #rec$$
				(setq #hinban (nth  0 #rec$))

				;廃版チェック(時間がかかる)
				(setq #ret (CHK_HAIBAN #hinban))

				(if #ret
					(progn ;廃版品でないとき
						
						(setq #LR     (nth  1 #rec$))
						(setq #DRkey  (nth  3 #rec$))
						(setq #GSkey  (nth  7 #rec$))
						(setq #YEN    (nth 13 #rec$))
						(setq #YEN2   (nth 14 #rec$))

						(if #DRkey
							(progn
					      ;品番シリ検索
					      (setq #qry_SERI$$
					        (CFGetDBSQLRec CG_DBSESSION "品番シリ"
					          (list
					            (list "品番名称"   #hinban 'STR)
					            (list "LR区分"     #LR     'STR)
					            (list "扉シリ記号" #DRkey  'STR)
					          )
					        )
					      )
								(if (and #qry_SERI$$ (= (length #qry_SERI$$) 1))
									(progn
										(setq #Seri_YEN  (nth 8 (car #qry_SERI$$)))
										(setq #Seri_YEN2 (nth 9 (car #qry_SERI$$)))
										(if (or (/= #Seri_YEN #YEN)(/= #Seri_YEN2 #YEN2))
											(if (and (/= #Seri_YEN 0.0)(/= #Seri_YEN2 0.0))
												(princ (strcat "\n" #hinban "," #LR "," #DRkey "[品番シリ][品番最終]で価格が一致しない") #fil);出力
											);_if
										);_if
									)
									(progn
										(princ (strcat "\n" #hinban "," #LR "," #DRkey "が[品番シリ]に存在しない") #fil);出力
									)
								);_if
							)
						);_if


						(if #GSkey
							(progn
					      ;品番基本検索
					      (setq #qry_BASE$$
					        (CFGetDBSQLRec CG_DBSESSION "品番基本"
					          (list
					            (list "品番名称"   #hinban 'STR)
					          )
					        )
					      )
								(if (and #qry_BASE$$ (= (length #qry_BASE$$) 1))
									(progn
										(setq #BASE_YEN  (nth 14 (car #qry_BASE$$)))
										(setq #BASE_YEN2 (nth 15 (car #qry_BASE$$)))
										(if (or (/= #BASE_YEN #YEN)(/= #BASE_YEN2 #YEN2))
											(princ (strcat "\n" #hinban "," #LR "," #GSkey "[品番基本][品番最終]で価格が一致しない") #fil);出力
										);_if
									)
									(progn
										(princ (strcat "\n" #hinban "," #LR "," #GSkey "が[品番基本]に存在しない") #fil);出力
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


  (StartUndoErr);// コマンドの初期化

  (setvar "CMDECHO" 0)
  (C:de0)

  ;07/02/19 YM ADD-S
  (setq #CG_SeriesDB   CG_SeriesDB)  ;"KJE"
  (setq #CG_DBNAME     CG_DBNAME)    ;"TK_KJE"
  (setq #CG_SeriesCode CG_SeriesCode);"J"
  ;07/02/19 YM ADD-E

  (setq #CG_DEBUG CG_DEBUG);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ
  (setq CG_DEBUG 0);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ

 ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;対象ｼﾘｰｽﾞ情報 0/01/10 YM ADD
  (setq #iseri (strcat CG_SYSPATH "LOG\\LAST_KAKAKU_seri.txt"));ﾁｪｯｸ対象ｼﾘｰｽﾞの読み込み
  (setq #CSV$$ (ReadCSVFile #iseri))
  ;先頭に";"があったら除く
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

  (setq #ofile  (strcat CG_SYSPATH "LOG\\LAST_KAKAKU_kekka.txt"));ﾁｪｯｸ結果出力ﾌｧｲﾙ
  (setq #fil (open #ofile "W" ))

  (if (= nil #fil)
    (progn
      (CFAlertErr (strcat "LAST_KAKAKU_kekka.txt が開けません。閉じてください"))
      (quit)
    )
  );_if


;;;  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));日付
;;;  (princ #date_time #fil ) ; 日付書き込み

  (princ "\n" #fil)

  (setq #kekka$$ nil);結果格納ﾘｽﾄ

  (foreach #seri$ #seri$$ ; 各ｼﾘｰｽﾞでのloop
    (setq CG_SeriesDB (nth 0 #seri$))
    (setq CG_DBNAME   (nth 0 #seri$))
    (setq CG_SeriesCode (nth 1 #seri$))
    (setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))

    ;DB接続できなくなったら再接続
    (if (= nil CG_DBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
      )
    );_if

    ;DB接続できなくなったら再接続
    (if (= nil CG_CDBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
      )
    );_if

		(princ (strcat "\n◆ｼﾘｰｽﾞ," CG_DBNAME) #fil)
    (###EXE)

  );_if

  (setq *error* nil)
  (if #fil (close #fil))

  (startapp "notepad.exe" #ofile)

  (princ)
);C:HinbanLast_KakakuCheck



;;;<HOM>*************************************************************************
;;; <関数名>     : C:EXbikou
;;; <処理概要>   : 備考欄に文言を出力するものをﾘｽﾄｱｯﾌﾟ
;;; <戻り値>     : なし
;;; <作成>       : 07/10/19 YM
;;; <備考>       : 
;;;*************************************************************************>MOH<
(defun C:EXbikou (
  /
	#CG_DBNAME #CG_DEBUG #CG_SERIESCODE #CG_SERIESDB #CSV$$ #DUM$$ #FIL #ISERI
	#MDB #OFILE #SERI #SERI$$
  )

    ;;;**********************************************************************
    ;;; ﾙｰﾌﾟ処理
    ;;;**********************************************************************
    (defun ###EXE (
      /
			#HINBAN #ID #QRY$ #REC$$ #SIYOU
      )
			(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "品番基本")))
			(foreach #rec$ #rec$$
				(setq #hinban (nth 0 #rec$))
				(setq #id (nth 7 #rec$))
				(if (equal #id 0.0 0.001)
					nil
					;else
					(progn
						(setq #sID (itoa (fix (+ #id 0.001)))) 
						;仕様名称検索
					  (setq #qry$	(car
						  (CFGetDBSQLRec CG_CDBSESSION "仕様名称"
						    (list
									(list "仕様ID" #sID 'INT)
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


  (StartUndoErr);// コマンドの初期化

  (setvar "CMDECHO" 0)
  (C:de0)

  ;07/02/19 YM ADD-S
  (setq #CG_SeriesDB   CG_SeriesDB)  ;"KJE"
  (setq #CG_DBNAME     CG_DBNAME)    ;"TK_KJE"
  (setq #CG_SeriesCode CG_SeriesCode);"J"
  ;07/02/19 YM ADD-E

  (setq #CG_DEBUG CG_DEBUG);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ
  (setq CG_DEBUG 0);ﾃﾞﾊﾞｯｸﾓｰﾄﾞ

 ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ;対象ｼﾘｰｽﾞ情報 0/01/10 YM ADD
  (setq #iseri (strcat CG_SYSPATH "LOG\\BIKOU_SERI.txt"));ﾁｪｯｸ対象ｼﾘｰｽﾞの読み込み
  (setq #CSV$$ (ReadCSVFile #iseri))
  ;先頭に";"があったら除く
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

  (setq #ofile  (strcat CG_SYSPATH "LOG\\Bikou_kekka.txt"));ﾁｪｯｸ結果出力ﾌｧｲﾙ
  (setq #fil (open #ofile "W" ))

  (princ "\n" #fil)


  (foreach #seri$ #seri$$ ; 各ｼﾘｰｽﾞでのloop
    (setq CG_SeriesDB (nth 0 #seri$))
    (setq CG_DBNAME   (nth 0 #seri$))
    (setq CG_SeriesCode (nth 1 #seri$))
    (setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))

    ;DB接続できなくなったら再接続
    (if (= nil CG_DBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
      )
    );_if

    ;DB接続できなくなったら再接続
    (if (= nil CG_CDBSESSION)
      (progn
        (arxunload "asilisp16.arx")
        (arxload "asilisp16.arx")
        (setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
      )
    );_if

		(princ (strcat "\n◆ｼﾘｰｽﾞ," CG_DBNAME) #fil)
    (###EXE)

  );_if

  (setq *error* nil)
  (if #fil (close #fil))

  (startapp "notepad.exe" #ofile)

  (princ)
);C:EXbikou


;;;<HOM>*************************************************************************
;;; <関数名>     : C:DoorZumen
;;; <処理概要>   : 扉必要枚数確認
;;; <戻り値>     : なし
;;; <作成>       : 07/10/16 YM
;;; <備考>       : 
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

			;品番シリ検索
			(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 品番シリ")))

			(foreach #rec$ #rec$$
				(setq #hinban (nth  0 #rec$))
				;廃版チェック(時間がかかる)
				(setq #ret (CHK_HAIBAN #hinban))

				(if #ret
					(progn ;廃版品でないとき
						(setq #LR     (nth  1 #rec$))
						(setq #DR_id  (nth  5 #rec$))
						;出力
						(if (and #DR_id (/= #DR_id ""))
							(princ (strcat "\n" #hinban "," #LR "," #DR_id) #fil)
						);_if
					)
				);_if
			);foreach

      (princ)
    );###EXE
    ;/////////////////////////////////////////////////////////////////////////////


  (StartUndoErr);// コマンドの初期化
  (setvar "CMDECHO" 0)
  (C:de0)
  (setq #ofile  (strcat CG_SYSPATH "LOG\\扉図形枚数_kekka.csv"));ﾁｪｯｸ結果出力ﾌｧｲﾙ
  (setq #fil (open #ofile "W" ))
  (princ "\n" #fil)
	(princ (strcat "\n◆ｼﾘｰｽﾞ," CG_DBNAME) #fil)
  (###EXE)

  (setq *error* nil)
  (if #fil (close #fil))
  (startapp "notepad.exe" #ofile)
  (princ)
);C:DoorZumen


;;;<HOM>*************************************************************************
;;; <関数名>    : C:MDBCHECK
;;; <処理概要>  :新ｽｲｰｼﾞｨmdb不整合ﾁｪｯｸ
;;; <戻り値>    : なし
;;; <作成>      : 2011/03/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:MDBCHECK (
  /
	#CG_DEBUG #DATE_TIME #DBNAME #DUM$$ #FIL #FLG #HIN #HIN$ #HIN1 #HIN2 #HINBAN
	#HIN_KAKKO$ #KIHON$$ #KIHON_HIN #KIHON_HIN$ #KIHON_KOSU #KIHON_LR #KOSU #LAST_L$$
	#LAST_R$$ #LAST_Z$$ #LIS$ #N #NG-Z #NUM #REC$ #REC$$ #TABLE$$ #ZUKEIID #ZUKEIID$
	#FIELD1 #FIELD2 #LR
  )

    ;;;**********************************************************************
    ;;; ﾘｽﾄの重複レコードを除く
    ;;; 05/06/01 YM
    ;;;**********************************************************************
    (defun ##delREC0 (
      &lis$ ; #hin$のﾘｽﾄ形式
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
    ;;; ;品番基本の存在ﾁｪｯｸ
    ;;; 05/06/14 YM
    ;;;**********************************************************************
    (defun ##CheckKIHON_REC (
      &hin$   ; 品番のﾘｽﾄ形式
      &DBNAME ; DB名
      /
      )
      (foreach #hin &hin$
        (if (member #hin #kihon_hin$)
          nil ; OK
          ;else
					(if (= nil (wcmatch #hin "GAS,OBUN,ｶﾞｽ*,ｺﾝﾛ*,食洗*,ﾌｰﾄﾞ*,HOOD*,MIRROR*,ｶｳﾝﾀｰ*,ﾐﾗｰ*,ｻｲﾄﾞﾊﾟﾈﾙ,ﾌﾛﾝﾄﾊﾟﾈﾙ,ﾖｺﾏｸｲﾀ,中間ﾎﾞｯｸｽ"))
          	(princ (strcat "\n" ",★,"  &DBNAME ": [品番基本]に登録がない" "," #hin) #fil)
					);_if
        );_if
      );foreach
      (princ)
    );##CheckKIHON_REC



    ;;;**********************************************************************
    ;;; ﾘｽﾄの重複レコードを除く
    ;;; 04/12/19 YM
    ;;;**********************************************************************
    (defun ##delREC (
      &lis$ ; (list #hin #LR)のﾘｽﾄ形式
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
    ;;; ;品番図形の存在ﾁｪｯｸ
    ;;; 04/12/19 YM
    ;;;**********************************************************************
    (defun ##CheckREC (
      &lis$   ; (list #hin #LR)のﾘｽﾄ形式
      &DBNAME ; DB名
      &FIL    ;ﾌｧｲﾙ識別
      /
      #HIN #LR #QRY$$ #ZUKEIID
      )
      (foreach #lis &lis$
        (setq #hin (car  #lis))
        (setq #LR  (cadr #lis))

				(if (= nil #hin)
          (CFAlertMsg (strcat "\n◆◆◆品番=nilあり。" &DBNAME))
					;else
					(progn
		        (if (= nil (wcmatch #hin "L16*,L18*,L19*,L21*,GAS,OBUN,ｶﾞｽ*,ｺﾝﾛ*,食洗*,ﾌｰﾄﾞ*,MIRROR*,ｶｳﾝﾀｰ*,ﾐﾗｰ*,ｻｲﾄﾞﾊﾟﾈﾙ,ﾌﾛﾝﾄﾊﾟﾈﾙ"))
		          (progn
		            (setq #qry$$
		              (CFGetDBSQLRec CG_DBSESSION "品番図形"
		                (list
		                  (list "品番名称"  #HIN 'STR)
		                  (list "LR区分"    #LR 'STR)
		                )
		              )
		            )
		            (if (= nil #qry$$)
		              (progn
		                (princ (strcat "\n◆◆◆ [" &DBNAME "] (品番図形にない): " "品番名称=" #HIN " LR区分=" #LR ) &FIL);ｴﾗｰ出力
		              )
		              (progn
		                (setq #zukeiID (nth 6 (car #qry$$)));2008/06/28 OK!
		                (if (or (= #zukeiID "")(= #zukeiID nil))
		                  (princ (strcat "\n◆◆◆ [" &DBNAME "]: " "☆図形IDなし/品番名称=" #HIN " LR区分=" #LR ) &FIL);ｴﾗｰ出力
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
    ;;; ;品番にｽﾍﾟｰｽ文字全角()があるかどうかﾁｪｯｸ
    ;;;**********************************************************************
    (defun ##CheckSpace (
      &hin$ ; 品番ﾘｽﾄ
      &msg  ; ﾁｪｯｸ対象ﾃｰﾌﾞﾙ情報
      &fil  ; ﾌｧｲﾙ識別子
      /
      #CHR #FIL #FLG #I #STRLEN
      )
      (foreach #hin &hin$
        ;品番の"<>"を外す
        (if (= nil #hin)
          (CFAlertMsg (strcat "\n◆◆◆品番=nilあり。" &msg))
					;else
					(progn
		        (setq #hin (KP_DelHinbanKakko #hin))

		        ;半角ｽﾍﾟｰｽがあるかどうか
		        (setq #flg (vl-string-search " " #hin))
		        (if #flg
		          (princ (strcat "\n◆◆◆品番名称にｽﾍﾟｰｽを含む: " &msg "品番: " #hin) &fil)
		        );_if

		        ;全角ｽﾍﾟｰｽがあるかどうか
		        (setq #flg (vl-string-search "　" #hin))
		        (if #flg
		          (princ (strcat "\n◆◆◆品番名称に全角ｽﾍﾟｰｽを含む: " &msg "品番: " #hin) &fil)
		        );_if

		        ;全角括弧があるかどうか
		        (setq #flg (vl-string-search "（" #hin))
		        (if #flg
		          (princ (strcat "\n◆◆◆品番名称に全角括弧を含む: " &msg "品番: " #hin) &fil)
		        );_if

		        ;全角括弧があるかどうか
		        (setq #flg (vl-string-search "）" #hin))
		        (if #flg
		          (princ (strcat "\n◆◆◆品番名称に全角括弧を含む: " &msg "品番: " #hin) &fil)
		        );_if

		        ;全角特殊文字があるかどうか
		        (setq #flg (vl-string-search "\\" #hin))
		        (if #flg
		          (princ (strcat "\n◆◆◆品番名称に特殊文字を含む: " &msg "品番: " #hin) &fil)
		        );_if
					)
        );_if
      );foreach

      (princ)
    );##CheckSpace

;///////////////////////////////////////////////////////////////////////////////

	; (C:MDBCHECKSK)
	(StartUndoErr);// コマンドの初期化

	(setvar "CMDECHO" 0)
	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを保存
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);解除

  (setq #fil (open (strcat CG_SYSPATH "LOG\\MDB不整合CHECK_" CG_SeriesDB ".csv") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み

  (princ "\n(C:MDBCHECKSK)ｺﾏﾝﾄﾞによるﾁｪｯｸ" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesDB) #fil)

  (princ "\n")
  (princ "\n" #fil)

  (setq #kihon$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "品番基本")))

	;①[品番基本]ﾁｪｯｸ　"%"付き品番がLRありで、"%"なし品番がLRなしになっているかどうか
  (princ "\n")
  (princ "\n" #fil)
	(setq #kihon_kosu (length #kihon$$))
  (princ (strcat "\n ----- \"品番基本のﾚｺｰﾄﾞ数: " (itoa #kihon_kosu) " 件"))
  (princ (strcat "\n ----- \"品番基本のﾚｺｰﾄﾞ数: " (itoa #kihon_kosu) " 件") #fil)
  (princ "\n")
  (princ "\n" #fil)


  (princ (strcat "\n①[品番基本][品番最終]ﾁｪｯｸ　開始"))
  (princ (strcat "\n①[品番基本][品番最終]ﾁｪｯｸ　開始") #fil)

;	(CFYesDialog "①[品番基本][品番最終]ﾁｪｯｸを行います")

	;★★★　品番基本でﾙｰﾌﾟ　★★★
  (setq #hin$ nil)
  (setq #hin_kakko$ nil)
  (setq #kihon_hin$ nil)
	(setq #kosu (length #kihon$$))
	(setq #n 1)
  (foreach #kihon$ #kihon$$

    (if (and (/= #n 0)(= 0 (rem #n 500)))
      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
    );_if

    (setq #kihon_hin (nth 0 #kihon$)) ;品番
    (setq #kihon_LR  (nth 1 #kihon$)) ;LR有無
    (setq #kihon_skk (nth 3 #kihon$)) ;性格CODE
    (setq #kihon_typ (nth 4 #kihon$)) ;展開ﾀｲﾌﾟ
    (setq #kihon_sid (nth 5 #kihon$)) ;集約ID
		(setq #hin (KP_DelHinbanKakko #kihon_hin));括弧はずし

    ;"%"付き判定
    (if (vl-string-search "%" #kihon_hin)
      (progn ;"%"あり
        (if (equal #kihon_LR 1.0 0.001)
          nil ; OK
          ;else
          (princ (strcat "\n" ",◆," "\"%\"付き品番なのに[品番基本]L/R有無=1ではない" "," #kihon_hin) #fil)
        );_if
      )
      (progn ;"%"なし
        (if (equal #kihon_LR 0.0 0.001)
          nil ; OK
          ;else
          (princ (strcat "\n" ",◆," "\"%\"なし品番なのに[品番基本]L/R有無=1である" "," #kihon_hin) #fil)
        );_if
      )
    );_if

		
    ;"@"付き判定 2011/03/28 YM ADD-S
    (if (vl-string-search "@" #kihon_hin)
			(progn ;"@"あり
        (cond
					((equal #kihon_typ 0.0 0.001)
          	nil ; OK
				 	)
					(T
          	(princ (strcat "\n" ",●," "\"@@\"付き品番なのに[品番基本]展開ﾀｲﾌﾟ=0ではない" "," #kihon_hin) #fil)
				 	)
        );_cond
      )
			(progn ;"@"なし
        (cond
					((equal #kihon_typ 0.0 0.001)
					 	nil
				 	)
					((equal #kihon_typ 1.0 0.001)
						nil
				 	)
					((equal #kihon_typ 2.0 0.001)
						(cond ;ｶﾞｽ加熱機器
							((equal #kihon_skk 113.0 0.001)
								;ｵｰﾌﾞﾝのはず
								(setq #obun$$ (DBSqlAutoQuery CG_DBSESSION
																(strcat "select 記号 from 複合OBUN where 品番名称 = '" #kihon_hin "'")))
						    (if (= nil #obun$$)
						      (princ (strcat "\n" ",●," "ｵｰﾌﾞﾝのはずなのに[複合OBUN]にﾚｺｰﾄﾞがない" "," #kihon_hin) #fil)
						    );_if
						 	)
							((equal #kihon_skk 210.0 0.001)
								;加熱機器のはず
								(setq #gas$$ (DBSqlAutoQuery CG_DBSESSION
															 (strcat "select 記号 from 複合GAS where 品番名称 = '" #kihon_hin "'")))
						    (if (= nil #gas$$)
						      (princ (strcat "\n" ",●," "加熱機器のはずなのに[複合GAS]にﾚｺｰﾄﾞがない"  "," #kihon_hin) #fil)
						    );_if
							)
							(T
								(princ (strcat "\n" ",●," "展開ﾀｲﾌﾟ(ｶﾞｽ種あり)が正しいか確認してください" "," #kihon_hin) #fil)
						 	)
						);_cond
				 	)					
					(T
          	(princ (strcat "\n" ",●," "展開ﾀｲﾌﾟが正しいか確認してください(例外)" "," #kihon_hin) #fil)
				 	)
        );_cond
      )
    );_if
    ;"@"付き判定 2011/03/28 YM ADD-E







		;[品番最終]検索ﾁｪｯｸ
		(if (member #hin #hin$)
			(progn
				nil ;2回目以降重複処理しない
			)
			(progn
				(setq #LAST_L$$ nil)
				(setq #LAST_R$$ nil)
				(setq #LAST_Z$$ nil)
				(if (equal #kihon_LR 1.0 0.001);L/Rあり
					(progn
				    (setq #LAST_L$$
				      (CFGetDBSQLRec CG_DBSESSION "品番最終"
				        (list
				          (list "品番名称"  #hin 'STR)
				          (list "LR区分"    "L"        'STR)
				        )
				      )
				    )
				    (setq #LAST_R$$
				      (CFGetDBSQLRec CG_DBSESSION "品番最終"
				        (list
				          (list "品番名称"  #hin 'STR)
				          (list "LR区分"    "R"        'STR)
				        )
				      )
				    )

				    (if (= nil #LAST_L$$)
				      (princ (strcat "\n" ",◆," "L/R有無=1なのに[品番最終]LR区分=Lのﾚｺｰﾄﾞがない"  "," #hin) #fil)
				    );_if

				    (if (= nil #LAST_R$$)
				      (princ (strcat "\n" ",◆," "L/R有無=1なのに[品番最終]LR区分=Rのﾚｺｰﾄﾞがない" "," #hin) #fil)
				    );_if

					)
					(progn ;L/Rなし
				    (setq #LAST_Z$$
				      (CFGetDBSQLRec CG_DBSESSION "品番最終"
				        (list
				          (list "品番名称"  #hin 'STR)
				          (list "LR区分"    "Z"        'STR)
				        )
				      )
				    )
				    (if (= nil #LAST_Z$$)
				      (princ (strcat "\n" ",◆," "L/R有無=0なのに[品番最終]LR区分=Zのﾚｺｰﾄﾞがない" "," #hin) #fil)
				    );_if
					)
				);_if
			)
		);_if


		;累積
		(setq #hin$ (cons #hin #hin$));()なし品番処理済み
		(setq #kihon_hin$ (cons #kihon_hin #kihon_hin$));[品番基本]全品番累積

		(setq #n (1+ #n))
  );foreach











  (princ "\n")
  (princ "\n" #fil)



  (princ (strcat "\n ②各ﾃｰﾌﾞﾙ登録品番が[品番基本]に存在するかﾁｪｯｸ　開始"))
  (princ (strcat "\n ②各ﾃｰﾌﾞﾙ登録品番が[品番基本]に存在するかﾁｪｯｸ　開始") #fil)


	(setq #unit$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "select ユニット記号 from SERIES WHERE SERIES名称 = '" CG_SeriesDB "'")))
	(setq #unit$ (car #unit$$))
	(setq #unit (car #unit$))

	(cond
		((= #unit "A") ;ｷｯﾁﾝ
			(setq #table$$
				(list
					(list "SINKCAB管理" "品番名称" "-")							
					(list "ガラスパティション" "品番名称" "LR区分")
					(list "ガラス配置候補" "品番名称" "-")
					(list "キッチンパネル拾い" "品番名称" "LR区分")
					(list "シンクOP" "OP品番名称" "-")
					(list "パネル構成" "品番名称" "LR区分")
					(list "プラ構成" "品番名称" "LR区分")
					(list "横幕板配置候補" "品番名称" "-")
					(list "集約ID変換" "品番名称" "-")
					(list "天井フィラ" "品番名称" "LR区分")
					(list "天井幕板" "品番名称" "LR区分")
					(list "特注規格品" "品番名称" "-")
					(list "品番OP" "品番名称" "-")
					(list "品番OP" "OP品番名称" "-")

					(list "複合GAS" "品番名称" "LR区分")
					(list "複合HOOD" "品番名称" "LR区分")
;;;							(list "複合HOOD構成" "品番名称" "LR区分")
					(list "複合OBUN" "品番名称" "LR区分")
					(list "複合パネル構成" "品番名称" "LR区分")
					(list "複合横幕板" "品番名称" "LR区分")
					(list "複合構成" "品番名称" "LR区分")
					(list "複合水栓" "品番名称" "LR区分")
					(list "複合中間BOX構成" "品番名称" "LR区分")
					(list "OP置換" "対象品番" "対象品番LR")
					(list "OP置換" "置換品番" "置換品番LR")
				)
			)
		)
		((= #unit "D") ;収納
			(setq #table$$
				(list
					(list "Cカウンタ置換" "品番名称" "LR区分")
					(list "パネル構成EX" "品番名称" "LR区分")
					(list "プラ構成" "品番名称" "LR区分")
					(list "天井幕板D" "品番名称" "LR区分")
					(list "天井幕板枚数" "品番名称" "LR区分")							
					(list "OP置換" "対象品番" "対象品番LR")
					(list "OP置換" "置換品番" "置換品番LR")
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
					;LR区分と品番の"%"を見て矛盾がないかﾁｪｯｸする
					(if (or (= #LR "L")(= #LR "R"))
						(progn ;品番に"%"がないといけない
					    (if (vl-string-search "%" #hin)
								nil ;OK
								;else
					      (princ (strcat "\n" ",＠," "L/Rありなのに品番に%がない" "[" #DBNAME "]" "," #hin) #fil)
					    );_if
						)
						(progn ;"Z" 品番に"%"があればおかしい
					    (if (vl-string-search "%" #hin)
					      (princ (strcat "\n" ",＠," "LR区分=Zなのに品番に%がある" "]" #DBNAME "]" "," #hin) #fil)
								;else
								nil ;OK
					    );_if
						)
					);_if
									
				)
			);_if

	    (setq #hin$ (cons #hin #hin$))
	  )

	  ;ｽﾍﾟｰｽなどﾁｪｯｸ
	  (##CheckSpace #hin$ (strcat "[" #DBNAME "] ") #fil)


	  (##CheckKIHON_REC #hin$ (strcat "[" #DBNAME "]"))

	  (princ "\n")
	  (princ "\n" #fil)
	);(foreach



	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを戻す
	(setq CG_DEBUG #CG_DEBUG)

  (princ (strcat "\n---終了") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\MDB不整合CHECK_" CG_SeriesDB ".csv"))
  (princ)
);C:MDBCHECK



;;;<HOM>*************************************************************************
;;; <関数名>    : C:LASTHINBANCHECK1
;;; <処理概要>  :新ｽｲｰｼﾞｨ品番最終扉色関係ﾃﾞｰﾀ存在ﾁｪｯｸ
;;; <戻り値>    : なし
;;; <作成>      : 2011/03/28 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:LASTHINBANCHECK1 (
  /
	#CG_DEBUG #DATE_TIME #DR_COLO #DR_HIKI #DR_SERI #FIL #HIKITE$$ #HIN #KIHON$$
	#KIHON_HIN #KIHON_KOSU #KIHON_LR #KIHON_SKK #KIHON_TYP #KOSU #LAST_L$$ #LAST_R$$
	#LAST_Z$$ #N
  )
	; (C:MDBCHECKSK)
	(StartUndoErr);// コマンドの初期化

	(setvar "CMDECHO" 0)
	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを保存
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);解除

  (setq #fil (open (strcat CG_SYSPATH "LOG\\品番最終扉色関係CHECK_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み

  (princ "\n(C:LASTHINBANCHECK)ｺﾏﾝﾄﾞによるﾁｪｯｸ" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesDB) #fil)

  (princ "\n")
  (princ "\n" #fil)

  (setq #kihon$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select 品番名称,LR有無,性格CODE,展開タイプ from " "品番基本")))

	(setq #kihon_kosu (length #kihon$$))
  (princ (strcat "\n ----- \"品番基本のﾚｺｰﾄﾞ数: " (itoa #kihon_kosu) " 件"))
  (princ (strcat "\n ----- \"品番基本のﾚｺｰﾄﾞ数: " (itoa #kihon_kosu) " 件") #fil)
  (princ "\n")
  (princ "\n" #fil)

  (princ (strcat "\n ----- [品番最終]扉色関係ﾃﾞｰﾀ存在ﾁｪｯｸ　開始"))
  (princ (strcat "\n ----- [品番最終]扉色関係ﾃﾞｰﾀ存在ﾁｪｯｸ　開始") #fil)
  (princ "\n")
  (princ "\n" #fil)



	;[引手管理]レコード分繰り返して[品番最終]を検索する
	(setq #HIKITE$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select 扉シリ記号,扉カラ記号,引手記号 from 引手管理")))

	;★★★　品番基本でﾙｰﾌﾟ　★★★
	(setq #kosu (length #kihon$$))
	(setq #n 1)
  (foreach #kihon$ #kihon$$
    (if (and (/= #n 0)(= 0 (rem #n 50)))
      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
    );_if

    (setq #kihon_hin (nth 0 #kihon$)) ;品番
    (setq #kihon_LR  (nth 1 #kihon$)) ;LR有無
    (setq #kihon_skk (nth 2 #kihon$)) ;性格CODE
    (setq #kihon_typ (nth 3 #kihon$)) ;展開タイプ

    ;()を外す
    (setq #hin (KP_DelHinbanKakko #kihon_hin))

		;展開タイプ=0が対象
		(if (equal #kihon_typ 0.0 0.001)
			(progn ;展開タイプ=0 @@付き品番
				;@@存在ﾁｪｯｸ
		    (if (vl-string-search "@" #kihon_hin)
					(progn ;"@"あり

						(foreach #HIKITE$ #HIKITE$$
							(setq #dr_seri (nth 0 #HIKITE$))
							(setq #dr_colo (nth 1 #HIKITE$))
							(setq #dr_hiki (nth 2 #HIKITE$))

							(setq #LAST_L$$ nil)
							(setq #LAST_R$$ nil)
							(setq #LAST_Z$$ nil)

					    (if (vl-string-search "#" #kihon_hin)
								(progn ;"#"あり ----------------------------------------------

									(if (equal #kihon_LR 1.0 0.001)
										(progn
									    (setq #LAST_L$$
									      (CFGetDBSQLRec CG_DBSESSION "品番最終"
									        (list
									          (list "品番名称"  #hin 'STR)
									          (list "LR区分"    "L"  'STR)
									          (list "扉シリ記号"  #dr_seri  'STR)
									          (list "扉カラ記号"  #dr_colo  'STR)
									          (list "引手記号"    #dr_hiki  'STR)
									        )
									      )
									    )
									    (setq #LAST_R$$
									      (CFGetDBSQLRec CG_DBSESSION "品番最終"
									        (list
									          (list "品番名称"  #hin 'STR)
									          (list "LR区分"    "R"  'STR)
									          (list "扉シリ記号"  #dr_seri  'STR)
									          (list "扉カラ記号"  #dr_colo  'STR)
									          (list "引手記号"    #dr_hiki  'STR)
									        )
									      )
									    )
									    (if (= nil #LAST_L$$)
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞがない / 品番,LR,扉ｼﾘ,扉ｶﾗ,引手: " #hin "," "L," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if
									    (if (= nil #LAST_R$$)
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞがない / 品番,LR,扉ｼﾘ,扉ｶﾗ,引手: " #hin "," "R," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if

									    (if (< 1 (length #LAST_L$$))
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞが複数 / 品番,LR,扉ｼﾘ,扉ｶﾗ,引手: " #hin "," "L," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if
									    (if (< 1 (length #LAST_R$$))
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞが複数 / 品番,LR,扉ｼﾘ,扉ｶﾗ,引手: " #hin "," "R," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if

										)
										(progn ;L/Rなし
									    (setq #LAST_Z$$
									      (CFGetDBSQLRec CG_DBSESSION "品番最終"
									        (list
									          (list "品番名称"  #hin 'STR)
									          (list "LR区分"    "Z"  'STR)
									          (list "扉シリ記号"  #dr_seri  'STR)
									          (list "扉カラ記号"  #dr_colo  'STR)
									          (list "引手記号"    #dr_hiki  'STR)
									        )
									      )
									    )
									    (if (= nil #LAST_Z$$)
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞがない / 品番,LR,扉ｼﾘ,扉ｶﾗ,引手: " #hin "," "Z," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if

									    (if (< 1 (length #LAST_Z$$))
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞが複数 / 品番,LR,扉ｼﾘ,扉ｶﾗ,引手: " #hin "," "Z," #dr_seri "," #dr_colo "," #dr_hiki) #fil)
									    );_if

										)
									);_if


								)
								(progn ;"#"なし ----------------------------------------------

									(if (equal #kihon_LR 1.0 0.001)
										(progn
											;引手をKEYにしない
									    (setq #LAST_L$$
									      (CFGetDBSQLRec CG_DBSESSION "品番最終"
									        (list
									          (list "品番名称"  #hin 'STR)
									          (list "LR区分"    "L"  'STR)
									          (list "扉シリ記号"  #dr_seri  'STR)
									          (list "扉カラ記号"  #dr_colo  'STR)
									        )
									      )
									    )
									    (setq #LAST_R$$
									      (CFGetDBSQLRec CG_DBSESSION "品番最終"
									        (list
									          (list "品番名称"  #hin 'STR)
									          (list "LR区分"    "R"  'STR)
									          (list "扉シリ記号"  #dr_seri  'STR)
									          (list "扉カラ記号"  #dr_colo  'STR)
									        )
									      )
									    )
									    (if (= nil #LAST_L$$)
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞがない / 品番,LR,扉ｼﾘ,扉ｶﾗ: " #hin "," "L," #dr_seri "," #dr_colo) #fil)
									    );_if
									    (if (= nil #LAST_R$$)
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞがない / 品番,LR,扉ｼﾘ,扉ｶﾗ: " #hin "," "R," #dr_seri "," #dr_colo) #fil)
									    );_if

									    (if (< 1 (length #LAST_L$$))
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞが複数 / 品番,LR,扉ｼﾘ,扉ｶﾗ: " #hin "," "L," #dr_seri "," #dr_colo) #fil)
									    );_if
									    (if (< 1 (length #LAST_R$$))
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞが複数 / 品番,LR,扉ｼﾘ,扉ｶﾗ: " #hin "," "R," #dr_seri "," #dr_colo) #fil)
									    );_if

										)
										(progn ;L/Rなし
									    (setq #LAST_Z$$
									      (CFGetDBSQLRec CG_DBSESSION "品番最終"
									        (list
									          (list "品番名称"  #hin 'STR)
									          (list "LR区分"    "Z"  'STR)
									          (list "扉シリ記号"  #dr_seri  'STR)
									          (list "扉カラ記号"  #dr_colo  'STR)
									        )
									      )
									    )
									    (if (= nil #LAST_Z$$)
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞがない / 品番,LR,扉ｼﾘ,扉ｶﾗ: " #hin "," "Z," #dr_seri "," #dr_colo) #fil)
									    );_if

									    (if (< 1 (length #LAST_Z$$))
									      (princ (strcat "\n◆◆◆[品番最終]にﾚｺｰﾄﾞが複数 / 品番,LR,扉ｼﾘ,扉ｶﾗ: " #hin "," "Z," #dr_seri "," #dr_colo) #fil)
									    );_if

										)
									);_if


								)
							);_if

						);foreach

					)
					(progn ;"@"なし
						(princ (strcat "\n◆◆◆[品番基本]展開ﾀｲﾌﾟ=0なのに品番名称に@@がない: " #kihon_hin) #fil)
					)
				);_if

			)
		);_if

		(setq #n (1+ #n))
  );foreach

  (princ (strcat "\n ----- [品番最終]扉色関係ﾃﾞｰﾀ存在ﾁｪｯｸ　終了"))
  (princ (strcat "\n ----- [品番最終]扉色関係ﾃﾞｰﾀ存在ﾁｪｯｸ　終了") #fil)
  (princ "\n")
  (princ "\n" #fil)

	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを戻す
	(setq CG_DEBUG #CG_DEBUG)

  (princ (strcat "\n---終了") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\品番最終扉色関係CHECK_" CG_SeriesDB ".txt"))
  (princ)
);C:LASTHINBANCHECK1


;;;<HOM>*************************************************************************
;;; <関数名>    : C:LASTHINBANCHECK2
;;; <処理概要>  :新ｽｲｰｼﾞｨ品番名称-最終品番ﾏｯﾁﾝｸﾞﾁｪｯｸ
;;; <戻り値>    : なし
;;; <作成>      : 2011/03/28 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:LASTHINBANCHECK2 (
  /
	#CG_DEBUG #DATE_TIME #DR_COLO #DR_HIKI #DR_SERI #FIL #HIN #KOSU #LAST #LAST$$ #N #NUM
  )
	(StartUndoErr);// コマンドの初期化

	(setvar "CMDECHO" 0)
	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを保存
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);解除

  (setq #fil (open (strcat CG_SYSPATH "LOG\\最終品番マッチングCHECK_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み

  (princ "\n(C:LASTHINBANCHECK)ｺﾏﾝﾄﾞによるﾁｪｯｸ" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesDB) #fil)

  (princ "\n")
  (princ "\n" #fil)

  (setq #LAST$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select 品番名称,ガス種,最終品番 from 品番最終")))

	(setq #kosu (length #LAST$$))
  (princ (strcat "\n ----- \"品番最終のﾚｺｰﾄﾞ数: " (itoa #kosu) " 件"))
  (princ (strcat "\n ----- \"品番最終のﾚｺｰﾄﾞ数: " (itoa #kosu) " 件") #fil)
  (princ "\n")
  (princ "\n" #fil)

  (princ (strcat "\n ----- [品番最終]最終品番マッチングCHECK　開始"))
  (princ (strcat "\n ----- [品番最終]最終品番マッチングCHECK　開始") #fil)
  (princ "\n")
  (princ "\n" #fil)

	(setq #n 1)
  (foreach #LAST$ #LAST$$
    (if (and (/= #n 0)(= 0 (rem #n 100)))
      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
    );_if

    (setq #hin  (nth 0 #LAST$)) ;品番名称
    (setq #gas  (nth 1 #LAST$)) ;gas
    (setq #last (nth 2 #LAST$)) ;最終品番

		(if (or (= nil #gas)(= "" #gas))
			(progn
				;<例>
				; H$15B1N-JN#-@@  "$","#","@@"を"*"に置き換える
				; HRJ15B1N-JND-G とﾏｯﾁﾝｸﾞ
				(setq #hin (vl-string-subst "*" "$"  #hin)) ;"$"置換
				(setq #hin (vl-string-subst "*" "#"  #hin)) ;"#"置換
				(setq #hin (vl-string-subst "*" "%"  #hin)) ;"%"置換
				(if (setq #num (vl-string-search "@@" #hin))
					(setq #hin (strcat (substr #hin 1 #num) "*") ) ;"@@"置換
				);_if
							 
				(if (wcmatch #last #hin)
					nil ;ﾏｯﾁ
					;else
		      (princ (strcat "\n◆◆◆[品番最終]品番名称と最終品番がﾏｯﾁしない: " (nth 0 #LAST$) "," #last) #fil)
				);_if
			)
			(progn
				nil
			)
		);_if

		(setq #n (1+ #n))
  );foreach

  (princ (strcat "\n ----- [品番最終]最終品番マッチングCHECK　終了"))
  (princ (strcat "\n ----- [品番最終]最終品番マッチングCHECK　終了") #fil)
  (princ "\n")
  (princ "\n" #fil)

	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを戻す
	(setq CG_DEBUG #CG_DEBUG)

  (princ (strcat "\n---終了") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\最終品番マッチングCHECK_" CG_SeriesDB ".txt"))
  (princ)
);C:LASTHINBANCHECK2


;;;<HOM>*************************************************************************
;;; <関数名>    : C:PLANCHECK1
;;; <処理概要>  : [プラン管理][複合管理]のIDが[プラン構成][複合構成]
;;;               に存在するかどうかﾁｪｯｸ
;;; <戻り値>    : なし
;;; <作成>      : 2011/03/12 YM
; select distinct プランID from プラ管理 where プランID like '*G00*'
; select distinct プランID from プラ構成 where プランID like '*G00*'
;;;*************************************************************************>MOH<
(defun C:PLANCHECK1 (
  /
	#CG_DEBUG #DATE_TIME #DBNAME1 #DBNAME2 #FIL #IDNAME #QRY$$ #REC$ #TABLE$$
  )

	(StartUndoErr);// コマンドの初期化

	(setvar "CMDECHO" 0)
	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを保存
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);解除


  (setq #fil (open (strcat CG_SYSPATH "LOG\\プランID対応CHECK_" CG_SeriesDB ".csv") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み

  (princ "\n" #fil)
  (princ "\n[**管理]のIDが[**構成]に存在するか機械的にﾁｪｯｸ" #fil)
  (princ "\nそもそも[**管理]の登録が間違っていたらこのﾁｪｯｸは無意味" #fil)
  (princ "\n" #fil)
  (princ "\n(C:PLANCHECK1)ｺﾏﾝﾄﾞによるﾁｪｯｸ" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesDB) #fil)
  (princ "\n" #fil)

	(setq #unit$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "select ユニット記号 from SERIES WHERE SERIES名称 = '" CG_SeriesDB "'")))
	(setq #unit$ (car #unit$$))
	(setq #unit (car #unit$))


	(cond
		((= #unit "A") ;ｷｯﾁﾝ
			(setq #table$$
				(list
					(list "プラ管理" "プラ構成" "プランID" )
					(list "複合管理" "複合構成" "複合ID" )
					(list "パネル管理" "パネル構成" "ID" )
					(list "複合パネル管理" "複合パネル構成" "ID" )
					(list "複合中間BOX管理" "複合中間BOX構成" "ID" )
				)
			)
	 	)
		((= #unit "D") ;収納
			(setq #table$$
				(list
					(list "プラ管理" "プラ構成" "プランID" )
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

		;重複削除
	  (setq #rec$ (DBSqlAutoQuery CG_DBSESSION (strcat "select DISTINCT " #IDNAME " from " #DBNAME1)))

	  (princ (strcat "\nﾚｺｰﾄﾞ数: " (itoa (length #rec$))))

	  (princ "\n" )
	  (princ "\n" #fil)
		(princ (strcat "\n★[" #DBNAME1 "]→[" #DBNAME2 "]引当てﾁｪｯｸ　開始★"))
		(princ (strcat "\n★[" #DBNAME1 "]→[" #DBNAME2 "]引当てﾁｪｯｸ　開始★") #fil)

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
		    (princ (strcat "\n,◆,"　"[" #DBNAME2 "]にない" "," "[" #DBNAME1 "]" #IDNAME "," (nth 0 #rec)) #fil)
			);_if

			(setq #n (1+ #n))
	  )

		(princ (strcat "\n★[" #DBNAME1 "]→[" #DBNAME2 "]引当てﾁｪｯｸ　終了★"))
		(princ (strcat "\n★[" #DBNAME1 "]→[" #DBNAME2 "]引当てﾁｪｯｸ　終了★") #fil)
	  (princ "\n" )
	  (princ "\n" #fil)
	)

	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを戻す
	(setq CG_DEBUG #CG_DEBUG)

  (princ (strcat "\n") #fil)
  (princ (strcat "\n---終了") #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\プランID対応CHECK_" CG_SeriesDB ".csv"))
  (princ)
);C:PLANCHECK1


;;;<HOM>*************************************************************************
;;; <関数名>    : C:PLANCHECK2
;;; <処理概要>  : [**管理][**構成]のレコード重複チェック
;;; <戻り値>    : なし
;;; <作成>      : 2011/03/14 YM
;;;*************************************************************************>MOH<
(defun C:PLANCHECK2 (
  /
	#CG_DEBUG #DATE_TIME #DBNAME #FIL #LR #REC$$ #REC_2$$ #REC_3$$ #REC_4$$
	#REC_DOWN #REC_DOWN$$ #REC_UPPER$$
  )

	(StartUndoErr);// コマンドの初期化

	(setvar "CMDECHO" 0)
	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを保存
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);解除

  (setq #fil (open (strcat CG_SYSPATH "LOG\\プラン重複CHECK_" CG_SeriesDB ".csv") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n" #fil)
  (princ "\n(C:PLANCHECK2)ｺﾏﾝﾄﾞによるﾁｪｯｸ" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesDB) #fil)
  (princ "\n" #fil)


	(if (or (= (substr CG_SeriesDB 2 1) "K")(= (substr CG_SeriesDB 3 1) "K"))
		(progn
			
		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "プラ管理")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出(下台)
		  (setq #rec_down$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ユニット記号,シンク側間口,形状,構成タイプ,フロアキャビタイプ,シンク位置,コンロ位置,食洗位置,奥行き,シンク記号,SOFT_CLOSE,天板_吊戸高さ,count(*)"
					" from " #DBNAME
					" group by "
					"ユニット記号,シンク側間口,形状,構成タイプ,フロアキャビタイプ,シンク位置,コンロ位置,食洗位置,奥行き,シンク記号,SOFT_CLOSE,天板_吊戸高さ"
		 			" HAVING count(*) > 1"
				))
			)

			;重複ﾚｺｰﾄﾞの抽出(上台)
		  (setq #rec_upper$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ユニット記号,シンク側間口,形状,構成タイプ,SOFT_CLOSE,天板_吊戸高さ,count(*)"
					" from " #DBNAME
					" group by "
					"ユニット記号,シンク側間口,形状,構成タイプ,SOFT_CLOSE,天板_吊戸高さ"
		 			" HAVING count(*) > 1"
				))
			)

			;ﾌｧｲﾙ出力(下台)
			(foreach #rec_down$ #rec_down$$
				(princ (strcat "\n" #DBNAME "★下台重複★: " ) #fil)
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
						"件重複"
				 	) #fil)
			);foreach

			;ﾌｧｲﾙ出力(上台)
			(foreach #rec_upper$ #rec_upper$$
				(if (equal (nth  3 #rec_upper$) 2.0 0.001)
					(progn
						(princ (strcat "\n" #DBNAME "★上台重複★: " ) #fil)
						(princ
							(strcat
								(nth  0 #rec_upper$) ","
								(nth  1 #rec_upper$) ","
								(nth  2 #rec_upper$) ","
								(nth  4 #rec_upper$) ","
								(nth  5 #rec_upper$) ","
								(rtos (fix (+ (nth 6 #rec_down) 0.001)))
								"件重複"
						 	) #fil)
					)
				);_if
			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "プラ構成")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"プランID,RECNO,品番名称,LR区分,商品タイプ,距離X,距離Y,距離Z,count(*)"
					" from " #DBNAME
					" group by "
					"プランID,RECNO,品番名称,LR区分,商品タイプ,距離X,距離Y,距離Z"
		 			" HAVING count(*) > 1"
				))
			)
			;ﾌｧｲﾙ出力
			(foreach #rec$ #rec$$
				(princ (strcat "\n[" #DBNAME "],★重複★," ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR区分未登録!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 8 #rec$) 0.001)))
						"件重複"
				 	) #fil)
			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "複合管理")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出(加熱機器)
		  (setq #rec_2$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ユニット記号,シンク側間口,形状,商品タイプ,フロアキャビタイプ,シンク位置,コンロ位置,食洗位置,奥行き,シンク記号,コンロ下設置,SOFT_CLOSE,天板_吊戸高さ,コンロ脇調理,count(*)"
					" from " #DBNAME
					" group by "
					"ユニット記号,シンク側間口,形状,商品タイプ,フロアキャビタイプ,シンク位置,コンロ位置,食洗位置,奥行き,シンク記号,コンロ下設置,SOFT_CLOSE,天板_吊戸高さ,コンロ脇調理"
		 			" HAVING count(*) > 1"
				))
			)
			;重複ﾚｺｰﾄﾞの抽出(ﾚﾝｼﾞﾌｰﾄﾞ)
		  (setq #rec_3$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ユニット記号,シンク側間口,形状,商品タイプ,天板_吊戸高さ,HOOD記号,count(*)"
					" from " #DBNAME
					" group by "
					"ユニット記号,シンク側間口,形状,商品タイプ,天板_吊戸高さ,HOOD記号"
		 			" HAVING count(*) > 1"
				))
			)
			;重複ﾚｺｰﾄﾞの抽出(食洗)
		  (setq #rec_4$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ユニット記号,商品タイプ,フロアキャビタイプ,奥行き,シンク記号,SOFT_CLOSE,天板_吊戸高さ,食洗記号,count(*)"
					" from " #DBNAME
					" group by "
					"ユニット記号,商品タイプ,フロアキャビタイプ,奥行き,シンク記号,SOFT_CLOSE,天板_吊戸高さ,食洗記号"
		 			" HAVING count(*) > 1"
				))
			)

			;ﾌｧｲﾙ出力
			(foreach #rec_2$ #rec_2$$
				(if (equal (nth  3 #rec_2$) 2.0 0.001);(加熱機器)
					(progn
						(princ (strcat "\n" #DBNAME "★加熱機器　重複★: " ) #fil)
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
								"件重複"
						 	) #fil)
					)
				);_if
			);foreach

			(foreach #rec_3$ #rec_3$$
				(if (equal (nth  3 #rec_3$) 3.0 0.001);(ﾚﾝｼﾞﾌｰﾄﾞ)
					(progn
						(princ (strcat "\n" #DBNAME "★ﾚﾝｼﾞﾌｰﾄﾞ　重複★: " ) #fil)
						(princ
							(strcat
								(nth  0 #rec_3$) ","
								(nth  1 #rec_3$) ","
								(nth  2 #rec_3$) ","
								(nth  4 #rec_3$) ","
								(nth  5 #rec_3$) ","
								(rtos (fix (+ (nth 6 #rec_3$) 0.001)))
								"件重複"
						 	) #fil)
					)
				);_if
			);foreach

			(foreach #rec_4$ #rec_4$$
				(if (equal (nth  1 #rec_4$) 4.0 0.001);(食洗)
					(progn
						(princ (strcat "\n" #DBNAME "★食洗　重複★: " ) #fil)
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
								"件重複"
						 	) #fil)
					)
				);_if
			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "複合構成")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"複合ID,RECNO,品番名称,LR区分,count(*)"
					" from " #DBNAME
					" group by "
					"複合ID,RECNO,品番名称,LR区分"
		 			" HAVING count(*) > 1"
				))
			)
			;ﾌｧｲﾙ出力
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "★重複★: " ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR区分未登録!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 4 #rec$) 0.001)))
						"件重複"
				 	) #fil)
			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "複合パネル管理")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"シンク側間口,形状,商品タイプ,奥行き,天板高さ,シンク記号,厚み,count(*)"
					" from " #DBNAME
					" group by "
					"シンク側間口,形状,商品タイプ,奥行き,天板高さ,シンク記号,厚み"
		 			" HAVING count(*) > 1"
				))
			)

			;ﾌｧｲﾙ出力
			(foreach #rec$ #rec$$
				(cond
					((equal (nth  2 #rec$) 1.0 0.001)
						(princ (strcat "\n" #DBNAME "★1:ｻｲﾄﾞﾊﾟﾈﾙ　重複★: " ) #fil)
					)
					((equal (nth  2 #rec$) 5.0 0.001)
						(princ (strcat "\n" #DBNAME "★5:ﾌﾛﾝﾄﾊﾟﾈﾙ　重複★: " ) #fil)
				 	)
					(T
						(princ (strcat "\n" #DBNAME "★?:商品ﾀｲﾌﾟ不明　重複★: " ) #fil)
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
						"件重複"
				 	) #fil)

			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "複合パネル構成")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ID,RECNO,品番名称,LR区分,count(*)"
					" from " #DBNAME
					" group by "
					"ID,RECNO,品番名称,LR区分"
		 			" HAVING count(*) > 1"
				))
			)
			;ﾌｧｲﾙ出力
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "★重複★: " ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR区分未登録!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 4 #rec$) 0.001)))
						"件重複"
				 	) #fil)
			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "複合中間BOX管理")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"シンク側間口,形状,商品タイプ,奥行き,天板高さ,扉シリ記号,count(*)"
					" from " #DBNAME
					" group by "
					"シンク側間口,形状,商品タイプ,奥行き,天板高さ,扉シリ記号"
		 			" HAVING count(*) > 1"
				))
			)

			;ﾌｧｲﾙ出力
			(foreach #rec$ #rec$$
				(cond
					((equal (nth  2 #rec$) 7.0 0.001)
						(princ (strcat "\n" #DBNAME "★7:中間BOX　重複★: " ) #fil)
					)
					(T
						(princ (strcat "\n" #DBNAME "★?:商品ﾀｲﾌﾟ不明　重複★: " ) #fil)
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
						"件重複"
				 	) #fil)

			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "複合中間BOX構成")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ID,RECNO,品番名称,LR区分,count(*)"
					" from " #DBNAME
					" group by "
					"ID,RECNO,品番名称,LR区分"
		 			" HAVING count(*) > 1"
				))
			)
			;ﾌｧｲﾙ出力
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "★重複★: " ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR区分未登録!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 4 #rec$) 0.001)))
						"件重複"
				 	) #fil)
			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "パネル管理")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"奥行き,天板高さ,厚み,エンドパネル,吊戸高さ,トップ勝ち,count(*)"
					" from " #DBNAME
					" group by "
					"奥行き,天板高さ,厚み,エンドパネル,吊戸高さ,トップ勝ち"
		 			" HAVING count(*) > 1"
				))
			)

			;ﾌｧｲﾙ出力
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "★重複★: " ) #fil)
				(princ
					(strcat
						(nth  0 #rec$) ","
						(nth  1 #rec$) ","
						(nth  2 #rec$) ","
						(nth  3 #rec$) ","
						(nth  4 #rec$) ","
						(nth  5 #rec$) ","
						(rtos (fix (+ (nth 6 #rec$) 0.001)))
						"件重複"
				 	) #fil)

			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "パネル構成")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ID,RECNO,品番名称,LR区分,count(*)"
					" from " #DBNAME
					" group by "
					"ID,RECNO,品番名称,LR区分"
		 			" HAVING count(*) > 1"
				))
			)
			;ﾌｧｲﾙ出力
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "★重複★: " ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR区分未登録!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 4 #rec$) 0.001)))
						"件重複"
				 	) #fil)
			);foreach

		  (princ "\n" #fil)
		  (princ "\n")

		)
		(progn ;"SD"収納


		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "プラ管理")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出(下台)
		  (setq #rec_down$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ユニット記号,基本構成,構成タイプ,収納間口,奥行き,SOFT_CLOSE,アルミ枠ガラス,カウンター色,count(*)"
					" from " #DBNAME
					" group by "
					"ユニット記号,基本構成,構成タイプ,収納間口,奥行き,SOFT_CLOSE,アルミ枠ガラス,カウンター色"
		 			" HAVING count(*) > 1"
				))
			)

			;重複ﾚｺｰﾄﾞの抽出(上台)
		  (setq #rec_upper$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"ユニット記号,上台構成,構成タイプ,収納間口,SOFT_CLOSE,count(*)"
					" from " #DBNAME
					" group by "
					"ユニット記号,上台構成,構成タイプ,収納間口,,SOFT_CLOSE"
		 			" HAVING count(*) > 1"
				))
			)

			;ﾌｧｲﾙ出力(下台)
			(foreach #rec_down$ #rec_down$$
				(if (equal (nth  2 #rec_down$) 1.0 0.001)
					(progn
						(princ (strcat "\n" #DBNAME "★下台重複★: " ) #fil)
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
								"件重複"
						 	) #fil)
					)
				);_if
			);foreach

			;ﾌｧｲﾙ出力(上台)
			(foreach #rec_upper$ #rec_upper$$
				(if (equal (nth  3 #rec_upper$) 2.0 0.001)
					(progn
						(princ (strcat "\n" #DBNAME "★上台重複★: " ) #fil)
						(princ
							(strcat
								(nth  0 #rec_upper$) ","
								(nth  1 #rec_upper$) ","
								(nth  3 #rec_upper$) ","
								(nth  4 #rec_upper$) ","
								(rtos (fix (+ (nth 5 #rec_down) 0.001)))
								"件重複"
						 	) #fil)
					)
				);_if
			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		  ;-------------------------------------------------------------------------------
		  (setq #rec$$ nil)
		  (setq #DBNAME "プラ構成")
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)
			;重複ﾚｺｰﾄﾞの抽出
		  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
				(strcat "select " 
					"プランID,RECNO,品番名称,LR区分,商品タイプ,距離X,距離Y,距離Z,count(*)"
					" from " #DBNAME
					" group by "
					"プランID,RECNO,品番名称,LR区分,商品タイプ,距離X,距離Y,距離Z"
		 			" HAVING count(*) > 1"
				))
			)
			;ﾌｧｲﾙ出力
			(foreach #rec$ #rec$$
				(princ (strcat "\n" #DBNAME "★重複★: " ) #fil)
				(if (nth  3 #rec$)
					(setq #LR (nth  3 #rec$))
					(setq #LR "LR区分未登録!")
				);_if
				(princ
					(strcat
						(nth  0 #rec$) ","
						(rtos (fix (+ (nth 1 #rec$) 0.001))) ","
						(nth  2 #rec$) ","
						#LR            ","
						(rtos (fix (+ (nth 8 #rec$) 0.001)))
						"件重複"
				 	) #fil)
			);foreach

			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
			(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
		  ;-------------------------------------------------------------------------------

		  (princ "\n" #fil)
		  (princ "\n")

		)
	);_if




  ;-------------------------------------------------------------------------------
  (setq #rec$$ nil)
  (setq #DBNAME "品番最終")
	(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始"))
	(princ (strcat "\n" #DBNAME "の重複レコード抽出　開始") #fil)

	;重複ﾚｺｰﾄﾞの抽出
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION
		(strcat "select " 
			"品番名称,LR区分,扉シリ記号,扉カラ記号,引手記号,ガス種,最終品番,count(*)"
			" from " #DBNAME
			" group by "
			"品番名称,LR区分,扉シリ記号,扉カラ記号,引手記号,ガス種,最終品番"
 			" HAVING count(*) > 1"
		))
	)
	;ﾌｧｲﾙ出力
	(foreach #rec$ #rec$$
		(princ (strcat "\n" #DBNAME "★重複★: " ) #fil)
		(princ
			(strcat
				(nth  0 #rec$) ","
				(nth  1 #rec$) ","
				(nth  6 #rec$) ","
				(rtos (fix (+ (nth 7 #rec$) 0.001)))
				"件重複"
		 	) #fil)
	);foreach

	(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了"))
	(princ (strcat "\n" #DBNAME "の重複レコード抽出　終了") #fil)
  ;-------------------------------------------------------------------------------

  (princ "\n" #fil)
  (princ "\n")

	(princ (strcat "\n---終了") #fil)

	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを戻す
	(setq CG_DEBUG #CG_DEBUG)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\プラン重複CHECK_" CG_SeriesDB ".csv"))
	
  (princ)
);C:PLANCHECK2



;;;<HOM>*************************************************************************
;;; <関数名>    : C:PLANCHECK3
;;; <処理概要>  : 登録記号不整合チェック
;;; <戻り値>    : なし
;;; <作成>      : 2011/03/14 YM
;;;*************************************************************************>MOH<
(defun C:PLANCHECK3 (
  /
	#CG_DEBUG #DATE_TIME #DBNAME #FIELD #FIL #HIN$ #KIGO #LIS$ #REC$ #RECSK$ #SK_KIGO$ #TABLE$$ #TOKUSEI
  )

	;07/02/19 YM ADD-S ﾂｰﾙ使用可否ﾁｪｯｸ
	(StartUndoErr);// コマンドの初期化

	(setvar "CMDECHO" 0)
	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを保存
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);解除


  (setq #fil (open (strcat CG_SYSPATH "LOG\\登録記号不整合CHECK_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
	(princ (strcat "\n各ﾃｰﾌﾞﾙの登録記号が[SK特性値]と対応しているかﾁｪｯｸ") #fil)
  (princ "\n" #fil)
  (princ "\n(C:PLANCHECK3)ｺﾏﾝﾄﾞによるﾁｪｯｸ" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesDB) #fil)
  (princ "\n" #fil)

  ;-------------------------------------------------------------------------------

	(setq #unit$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "select ユニット記号 from SERIES WHERE SERIES名称 = '" CG_SeriesDB "'")))
	(setq #unit$ (car #unit$$))
	(setq #unit (car #unit$))

	;2015/06/30 YM ADD OP置換の記号もﾁｪｯｸしたい

	(cond
		((= #unit "A") ;ｷｯﾁﾝ
			(setq #table$$
			 	;ﾌｨｰﾙﾄﾞ名,ﾃｰﾌﾞﾙ名,SK特性値.特性ID
				(list
					(list "PLAN32"             "HOOD高さ"           "PLAN32" )

					(list "形状"               "OP置換シンク"       "PLAN05" )
					(list "奥行き"             "OP置換シンク"       "PLAN07" )
					(list "シンク記号"         "OP置換シンク"       "PLAN17" )

;;;					(list "材質記号"           "WT材質"             "PLAN16" )

;;;					(list "奥行"               "SINK奥行管理"       "PLAN07" )

					(list "記号"               "ガラスパティション" "PLAN44" )
					(list "シンク側間口"       "ガラスパティション" "PLAN04" )
					(list "奥行き"             "ガラスパティション" "PLAN07" )
					(list "天板高さ"           "ガラスパティション" "PLAN31" )
					(list "シンク記号"         "ガラスパティション" "PLAN17" )

					(list "記号"               "キッチンパネル拾い" "PLAN47" )

					(list "材質記号"           "シンクOP"           "PLAN16" )
					(list "シンク記号"         "シンクOP"           "PLAN17" )

					(list "材質記号"           "トップ勝ち判定"     "PLAN16" )
					(list "シンク記号"         "トップ勝ち判定"     "PLAN17" )
					(list "形状"               "トップ勝ち判定"     "PLAN05" )

					(list "奥行き"             "パネル管理"         "PLAN07" )
					(list "天板高さ"           "パネル管理"         "PLAN31" )
					(list "エンドパネル"       "パネル管理"         "PLAN45" )
					(list "吊戸高さ"           "パネル管理"         "PLAN32" )

					(list "扉シリ記号"         "パネル厚み"         "PLAN12" )
					(list "扉カラ記号"         "パネル厚み"         "PLAN13" )

					(list "シンク側間口"       "プラ管理"   "PLAN04" )
					(list "形状"               "プラ管理"   "PLAN05" )
					(list "フロアキャビタイプ" "プラ管理"   "PLAN06" )
					(list "奥行き"             "プラ管理"   "PLAN07" )
					(list "シンク記号"         "プラ管理"   "PLAN17" )
					(list "SOFT_CLOSE"         "プラ管理"   "PLAN08" )

					(list "扉シリ記号"         "引手管理"   "PLAN12" )
					(list "扉カラ記号"         "引手管理"   "PLAN13" )
					(list "引手記号"           "引手管理"   "PLAN14" )

					(list "シンク記号"         "水栓位置"   "PLAN17" )

					(list "シンク側間口"       "天井幕板"   "PLAN04" )
					(list "形状"               "天井幕板"   "PLAN05" )
					(list "変換値"             "天井幕板"   "PLAN46" )

					(list "材質記号"           "天板価格"   "PLAN16" )
					(list "形状"               "天板価格"   "PLAN05" )
					(list "シンク記号"         "天板価格"   "PLAN17" )
					(list "シンク側間口"       "天板価格"   "PLAN04" )
					(list "奥行き"             "天板価格"   "PLAN07" )

					(list "扉カラ記号"         "扉COLOR"   "PLAN13" )

					(list "扉シリ記号"         "扉シリズ"   "PLAN12" )

					(list "扉シリ記号"         "扉シ管理"   "PLAN12" )
					(list "扉カラ記号"         "扉シ管理"   "PLAN13" )

					(list "扉シリ記号"         "品番シリ"   "PLAN12" )
					(list "引手記号"           "品番シリ"   "PLAN14" )

					(list "扉シリ記号"         "品番最終"   "PLAN12" )
					(list "扉カラ記号"         "品番最終"   "PLAN13" )
					(list "引手記号"           "品番最終"   "PLAN14" )

					(list "記号"               "複合GAS"    "PLAN20" )

					(list "PLAN23"             "複合HOOD"   "PLAN23" )

					(list "記号"               "複合OBUN"   "PLAN21" );2011/03/15 YM MOD
					(list "奥行き"             "複合OBUN"   "PLAN07" )
					(list "天板高さ"           "複合OBUN"   "PLAN31" )

					(list "シンク側間口"       "複合パネル管理"   "PLAN04" )
					(list "形状"               "複合パネル管理"   "PLAN05" )
					(list "奥行き"             "複合パネル管理"   "PLAN07" )
					(list "天板高さ"           "複合パネル管理"   "PLAN31" )
					(list "シンク記号"         "複合パネル管理"   "PLAN17" )

					(list "シンク側間口"       "複合管理"   "PLAN04" )
					(list "形状"               "複合管理"   "PLAN05" )
					(list "フロアキャビタイプ" "複合管理"   "PLAN06" )
					(list "シンク位置"         "複合管理"   "PLAN02" )
					(list "コンロ位置"         "複合管理"   "PLAN09" )
					(list "食洗位置"           "複合管理"   "PLAN10" )
					(list "奥行き"             "複合管理"   "PLAN07" )
					(list "シンク記号"         "複合管理"   "PLAN17" )
					(list "コンロ下設置"       "複合管理"   "PLAN21" )
					(list "SOFT_CLOSE"         "複合管理"   "PLAN08" )
					(list "HOOD記号"           "複合管理"   "PLAN23" )
					(list "食洗記号"           "複合管理"   "PLAN42" )

					(list "記号"               "複合水栓"   "PLAN19" )

					(list "シンク側間口"       "複合中間BOX管理"   "PLAN04" )
					(list "形状"               "複合中間BOX管理"   "PLAN05" )
					(list "奥行き"             "複合中間BOX管理"   "PLAN07" )
					(list "天板高さ"           "複合中間BOX管理"   "PLAN31" )
					(list "扉シリ記号"         "複合中間BOX管理"   "PLAN12" )
				)
			)

		)
		((= #unit "D") ;収納

			(setq #table$$
			 	;ﾌｨｰﾙﾄﾞ名,ﾃｰﾌﾞﾙ名,SK特性値.特性ID
				(list
					(list "エンドパネル"             "Cエンドパネル有無"           "PLAN171" )
					(list "エンドパネル"             "Cエンドパネル有無"           "PLAN271" )
					(list "エンドパネル"             "Cエンドパネル有無"           "PLAN371" )
					(list "エンドパネル"             "Cエンドパネル有無"           "PLAN471" )
					(list "エンドパネル"             "Cエンドパネル有無"           "PLAN571" )

					(list "KEY"               "Cカウンタ最大間口"       "PLAN157" )
					(list "KEY"               "Cカウンタ最大間口"       "PLAN257" )
					(list "KEY"               "Cカウンタ最大間口"       "PLAN357" )
					(list "KEY"               "Cカウンタ最大間口"       "PLAN457" )
					(list "KEY"               "Cカウンタ最大間口"       "PLAN557" )

					(list "基本構成"               "Cカウンタ種類"       "PLAN154" )
					(list "基本構成"               "Cカウンタ種類"       "PLAN254" )
					(list "基本構成"               "Cカウンタ種類"       "PLAN354" )
					(list "基本構成"               "Cカウンタ種類"       "PLAN454" )
					(list "基本構成"               "Cカウンタ種類"       "PLAN554" )

					(list "カウンタ色"               "Cカウンタ置換"       "PLAN157" )
					(list "カウンタ色"               "Cカウンタ置換"       "PLAN257" )
					(list "カウンタ色"               "Cカウンタ置換"       "PLAN357" )
					(list "カウンタ色"               "Cカウンタ置換"       "PLAN457" )
					(list "カウンタ色"               "Cカウンタ置換"       "PLAN557" )

					(list "基本構成"               "C天幕奥行参照"       "PLAN154" )
					(list "基本構成"               "C天幕奥行参照"       "PLAN254" )
					(list "基本構成"               "C天幕奥行参照"       "PLAN354" )
					(list "基本構成"               "C天幕奥行参照"       "PLAN454" )
					(list "基本構成"               "C天幕奥行参照"       "PLAN554" )

					(list "変換値"               "パネル管理EX"       "PLAN171" )
					(list "変換値"               "パネル管理EX"       "PLAN271" )
					(list "変換値"               "パネル管理EX"       "PLAN371" )
					(list "変換値"               "パネル管理EX"       "PLAN471" )
					(list "変換値"               "パネル管理EX"       "PLAN571" )

					(list "扉シリ記号"               "パネル厚み"       "PLAN62" )
					(list "扉カラ記号"               "パネル厚み"       "PLAN63" )

					(list "KEY"               "Cカウンタ最大間口"       "PLAN157" )
					(list "KEY"               "Cカウンタ最大間口"       "PLAN257" )
					(list "KEY"               "Cカウンタ最大間口"       "PLAN357" )
					(list "KEY"               "Cカウンタ最大間口"       "PLAN457" )
					(list "KEY"               "Cカウンタ最大間口"       "PLAN557" )

					(list "基本構成"               "プラ管理"       "PLAN154" )
					(list "基本構成"               "プラ管理"       "PLAN254" )
					(list "基本構成"               "プラ管理"       "PLAN354" )
					(list "基本構成"               "プラ管理"       "PLAN454" )
					(list "基本構成"               "プラ管理"       "PLAN554" )

					(list "上台構成"               "プラ管理"       "PLAN161" )
					(list "上台構成"               "プラ管理"       "PLAN261" )
					(list "上台構成"               "プラ管理"       "PLAN361" )
					(list "上台構成"               "プラ管理"       "PLAN461" )
					(list "上台構成"               "プラ管理"       "PLAN561" )

					(list "収納間口"               "プラ管理"       "PLAN155" )
					(list "収納間口"               "プラ管理"       "PLAN255" )
					(list "収納間口"               "プラ管理"       "PLAN355" )
					(list "収納間口"               "プラ管理"       "PLAN455" )
					(list "収納間口"               "プラ管理"       "PLAN555" )

					(list "奥行き"               "プラ管理"       "PLAN153" )
					(list "奥行き"               "プラ管理"       "PLAN253" )
					(list "奥行き"               "プラ管理"       "PLAN353" )
					(list "奥行き"               "プラ管理"       "PLAN453" )
					(list "奥行き"               "プラ管理"       "PLAN553" )

					(list "SOFT_CLOSE"           "プラ管理"       "PLAN58" )

					(list "アルミ枠ガラス"       "プラ管理"       "PLAN159" )
					(list "アルミ枠ガラス"       "プラ管理"       "PLAN259" )
					(list "アルミ枠ガラス"       "プラ管理"       "PLAN359" )
					(list "アルミ枠ガラス"       "プラ管理"       "PLAN459" )
					(list "アルミ枠ガラス"       "プラ管理"       "PLAN559" )

					(list "カウンター色"         "プラ管理"       "PLAN157" )
					(list "カウンター色"         "プラ管理"       "PLAN257" )
					(list "カウンター色"         "プラ管理"       "PLAN357" )
					(list "カウンター色"         "プラ管理"       "PLAN457" )
					(list "カウンター色"         "プラ管理"       "PLAN557" )

					(list "扉シリ記号"             "引手管理"       "PLAN62" )
					(list "扉カラ記号"             "引手管理"       "PLAN63" )
					(list "引手記号"               "引手管理"       "PLAN64" )

					(list "奥行記号"               "奥行"       "PLAN153" )
					(list "奥行記号"               "奥行"       "PLAN253" )
					(list "奥行記号"               "奥行"       "PLAN353" )
					(list "奥行記号"               "奥行"       "PLAN453" )
					(list "奥行記号"               "奥行"       "PLAN553" )

					(list "間口記号"               "間口"       "PLAN155" )
					(list "間口記号"               "間口"       "PLAN255" )
					(list "間口記号"               "間口"       "PLAN355" )
					(list "間口記号"               "間口"       "PLAN455" )
					(list "間口記号"               "間口"       "PLAN555" )

					(list "奥行記号"               "上台奥行"       "PLAN161" )
					(list "奥行記号"               "上台奥行"       "PLAN261" )
					(list "奥行記号"               "上台奥行"       "PLAN361" )
					(list "奥行記号"               "上台奥行"       "PLAN461" )
					(list "奥行記号"               "上台奥行"       "PLAN561" )

					(list "変換値"               "天井幕板D"       "PLAN72" )
					(list "扉シリ記号"           "天井幕板D"       "PLAN62" )


					(list "扉カラ記号"         "扉COLOR"   "PLAN63" )

					(list "扉シリ記号"         "扉シリズ"   "PLAN62" )

					(list "扉シリ記号"         "扉シ管理"   "PLAN62" )
					(list "扉カラ記号"         "扉シ管理"   "PLAN63" )

					(list "扉シリ記号"         "品番シリ"   "PLAN62" )
					(list "引手記号"           "品番シリ"   "PLAN64" )

					(list "扉シリ記号"         "品番最終"   "PLAN62" )
					(list "扉カラ記号"         "品番最終"   "PLAN63" )
					(list "引手記号"           "品番最終"   "PLAN64" )

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
	  (setq #recSK$ (DBSqlAutoQuery CG_DBSESSION (strcat "select 変換値 from SK特性値 where 特性ID = '" #tokusei "'")))
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
	      		(princ (strcat "\n◆◆◆　ﾃｰﾌﾞﾙ名【" #DBNAME "】, ﾌｨｰﾙﾄﾞ名=" #field " [SK特性値].特性ID= " #tokusei "　★不正な記号: "  #kigo ) #fil)
					);_if
				)
			);_if
	  );foreach
	);foreach


  (princ "\n" #fil)
	(princ (strcat "\n---終了") #fil)
  (princ "\n" #fil)

	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを戻す
	(setq CG_DEBUG #CG_DEBUG)

  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\登録記号不整合CHECK_" CG_SeriesDB ".txt"))
  (princ)
);C:PLANCHECK3

;;;<HOM>*************************************************************************
;;; <関数名>    : C:PLANCHECK4
;;; <処理概要>  : [プラン管理]のレコードに対応するレコードが[複合管理]
;;;               に存在するかどうかﾁｪｯｸ
;;; <戻り値>    : なし
;;; <作成>      : 06/01/18 YM
;;;*************************************************************************>MOH<
(defun C:PLANCHECK4 (
  /
	#CAB #CG_DEBUG #DATE_TIME #DBNAME #DDD #FIL #HUKU$$ #KEI #KOSU #MAG #N #PKO #PSI
	#PSY #REC$$ #SFT #SNK #UNDER_GAS$ #UNI #WTH #QRYSYOKU$$ #SKIGO$
  )
	(StartUndoErr);// コマンドの初期化

	(setvar "CMDECHO" 0)
	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを保存
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);解除


  (setq #fil (open (strcat CG_SYSPATH "LOG\\プラ管理-複合管理対応CHECK_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
	(princ (strcat "\n【プラ管理】(下台)に対応する【複合管理】ﾚｺｰﾄﾞが存在するかﾁｪｯｸ(商品ﾀｲﾌﾟ=2,4が対象)") #fil)
  (princ "\n" #fil)
  (princ "\n(C:PLANCHECK4)ｺﾏﾝﾄﾞによるﾁｪｯｸ" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesDB) #fil)
  (princ "\n" #fil)


  ;-------------------------------------------------------------------------------

  (setq #rec$$ nil)
  (setq #DBNAME "プラ管理")
  (princ (strcat "\n" #DBNAME " read"))
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " #DBNAME " where 構成タイプ=1")))

  (princ (strcat "\n[ﾌﾟﾗ管理]検索"))
	(setq #kosu (itoa (length #rec$$)))
  (princ (strcat "\nﾚｺｰﾄﾞ数: " #kosu))


	;[SK特性値]食洗記号を求める
	(setq #Skigo$ nil)
  (setq #qrySYOKU$$
  	(CFGetDBSQLRec CG_DBSESSION "SK特性値"
      (list
        (list "特性ID" "PLAN42" 'STR)
      )
    )
  )
	(foreach #qrySYOKU$ #qrySYOKU$$
		(if (/= "N" (nth 4 #qrySYOKU$))
			(setq #Skigo$ (append #Skigo$ (list (nth 4 #qrySYOKU$))))
		);_if
	)

;******************************************************************************
	;各ﾚｺｰﾄﾞに対応する[複合管理]を検索
	(setq #n 1)
  (princ "\n[複合管理]に対応ﾚｺｰﾄﾞが存在しないもの([ﾌﾟﾗ管理]の登録が正しいことが前提)" #fil)
  (princ "\n" #fil)
	(foreach #rec$ #rec$$
    (if (and (/= #n 0)(= 0 (rem #n 500)))
      (princ (strcat "\n" (itoa #n) "/"  #kosu))
    );_if

		(setq #uni (nth  1 #rec$));ユニット記号
		(setq #mag (nth  2 #rec$));シンク側間口
		(setq #kei (nth  3 #rec$));形状
		(setq #cab (nth  5 #rec$));フロアキャビタイプ
		(setq #psi (nth  6 #rec$));シンク位置
		(setq #pko (nth  7 #rec$));コンロ位置
		(setq #psy (nth  8 #rec$));食洗位置
		(setq #ddd (nth  9 #rec$));奥行き
		(setq #snk (nth 10 #rec$));シンク記号
		(setq #sft (nth 12 #rec$));SOFT_CLOSE
		(setq #wth (nth 13 #rec$));天板_吊戸高さ

    ;[複合管理]ｶﾞｽを検索 <商品ﾀｲﾌﾟ=2>
		(setq #under_GAS$ (list "B" "O"))
		(foreach #under_GAS #under_GAS$
	    (setq #huku$$
	      (CFGetDBSQLRec CG_DBSESSION "複合管理"
					(list
						(list "ユニット記号"       #uni 'STR)
						(list "シンク側間口"       #mag 'STR)
						(list "形状"               #kei 'STR)
						(list "商品タイプ"         "2"  'INT)
						(list "フロアキャビタイプ" #cab 'STR)
						(list "シンク位置"         #psi 'STR)
						(list "コンロ位置"         #pko 'STR)
						(list "食洗位置"           #psy 'STR)
						(list "奥行き"             #ddd 'STR)
						(list "シンク記号"         #snk 'STR)
						(list "コンロ下設置"       #under_GAS 'STR)
						(list "SOFT_CLOSE"         #sft 'STR)
						(list "天板_吊戸高さ"      #wth 'STR)
						(list "コンロ脇調理"       "_"  'STR)
					)
	      )
			)
			(if #huku$$
				nil
				;else
			  (princ (strcat "\n<商品ﾀｲﾌﾟ=2>: "
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



    ;[複合管理]食洗を検索 <商品ﾀｲﾌﾟ=4>
		(if (or (= #cab "UN")(= #cab "BN"))
			nil ; 食洗なし
			;else
			(progn
				(foreach #Skigo #Skigo$
			    (setq #huku$$
			      (CFGetDBSQLRec CG_DBSESSION "複合管理"
			        (list
								(list "ユニット記号"       #uni 'STR)
								(list "商品タイプ"         "4"  'INT)
								(list "フロアキャビタイプ" #cab 'STR)
								(list "奥行き"             #ddd 'STR)
								(list "シンク記号"         #snk 'STR)
								(list "SOFT_CLOSE"         #sft 'STR)
								(list "天板_吊戸高さ"      #wth 'STR)
								(list "食洗記号"         #Skigo 'STR)
			        )
			      )
			    )
					(if #huku$$
						nil
						;else
					  (princ (strcat "\n<商品ﾀｲﾌﾟ=4>: "
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
	(princ (strcat "\n---終了") #fil)
  (princ "\n" #fil)
	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを戻す
	(setq CG_DEBUG #CG_DEBUG)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\プラ管理-複合管理対応CHECK_" CG_SeriesDB ".txt"))
  (princ)
);C:PLANCHECK4


;;;<HOM>*************************************************************************
;;; <関数名>    : C:CG_BUNRUI
;;; <処理概要>  : 【品番図形】から分類する(CG対応)
;;; <戻り値>    : なし
;;; <作成>      : 2011/03/28 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:CG_BUNRUI (
  /
	#CG_DEBUG #DATE_TIME #FIL #HIN #HINBAN #HINMEI #KIHON$ #KIHON$$ #KIHON_KOSU
	#KOSU #LAST$$ #LR #N #SKK #ZUKEI #ZUKEI$$ #ZUKEI_KOSU
  )
	; (C:MDBCHECKSK)
	(StartUndoErr);// コマンドの初期化

	;ｼﾝｸ品番一覧
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
	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを保存
	(setq #CG_DEBUG CG_DEBUG)
	(setq CG_DEBUG 0);解除

  (setq #fil (open (strcat CG_SYSPATH "LOG\\CG分類_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み

  (princ "\n(C:C:CG_BUNRUI)ｺﾏﾝﾄﾞによる" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesDB) #fil)	

  (princ "\n")
  (princ "\n" #fil)

  (setq #zukei$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select 品番名称,LR区分,図形ID,寸法H,寸法D from " "品番図形")))

	(setq #zukei_kosu (length #zukei$$))
  (princ (strcat "\n ----- \"品番図形のﾚｺｰﾄﾞ数: " (itoa #zukei_kosu) " 件"))
  (princ (strcat "\n ----- \"品番図形のﾚｺｰﾄﾞ数: " (itoa #zukei_kosu) " 件") #fil)
  (princ "\n")
  (princ "\n" #fil)

  (princ "\n品番,LR,図形ID,性格ｺｰﾄﾞ,品名,高さ,奥行" #fil)

	;★★★　品番基本でﾙｰﾌﾟ　★★★
	(setq #kosu (length #zukei$$))
	(setq #n 1)
  (foreach #zukei$ #zukei$$
    (if (and (/= #n 0)(= 0 (rem #n 50)))
      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
    );_if

    (setq #hinban (nth 0 #zukei$)) ;品番
    (setq #LR     (nth 1 #zukei$)) ;LR
    (setq #zukei  (nth 2 #zukei$)) ;図形ID
    (setq #HH     (itoa (fix (nth 3 #zukei$)))) ;高さ
    (setq #DD     (itoa (fix (nth 4 #zukei$)))) ;奥行

		(if (or (= #zukei nil)(= #zukei ""))
			(setq #zukei  "未登録")
		);_if
    (setq #kihon$$
      (CFGetDBSQLRec CG_DBSESSION "品番基本"
        (list
          (list "品番名称"  #hinban 'STR)
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
    ;()を外す
    (setq #hin (KP_DelHinbanKakko #hinban))

    (setq #last$$
      (CFGetDBSQLRec CG_DBSESSION "品番最終"
        (list
          (list "品番名称"  #hin 'STR)
          (list "LR区分"    #LR  'STR)
        )
      )
    )
		(if #last$$
			(setq #hinmei (nth 14 (car #last$$)))
			;else
			(progn
        (if (member #hinban #snk$)
					(setq #hinmei "ｼﾝｸ")
					;else
					(setq #hinmei "---")
				);_if
			)
		);_if
    (princ (strcat "\n" #hinban "," #LR "," #zukei "," #skk "," #hinmei "," #HH "," #DD) #fil)
;;;(princ "\n品番,LR,図形ID,性格ｺｰﾄﾞ,品名" #fil)
		(setq #n (1+ #n))
  );foreach

	;ﾃﾞﾊﾞｯｸﾓｰﾄﾞﾌﾗｸﾞを戻す
	(setq CG_DEBUG #CG_DEBUG)

  (princ (strcat "\n---終了") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\CG分類_" CG_SeriesDB ".txt"))
  (princ)
);C:CG_BUNRUI


;;;<HOM>*************************************************************************
;;; <関数名>     : C:MOJIID
;;; <処理概要>   : 文字IDを入力させて寸法文字を表示
;;; <戻り値>     : なし
;;; <作成>       : 07/03/26 YM
;;; <備考>       : 
;;;*************************************************************************>MOH<
(defun C:MOJIID (
  /
	#QRY$ #RET
  )
	(setq #str_id (getstring "\n文字IDを入力: "))

  (setq #qry$
    (car
      (CFGetDBSQLRec CG_CDBSESSION "寸法文字"
        (list
          (list "文字ID" #str_id 'INT)
        )
      )
    )
  )
  (if (= nil #qry$)
		(progn
    	(princ "\n[寸法文字]に定義なし")
		)
		(progn
    	(princ "\n")
			(princ #qry$)
		)
  );_if
	(princ)
);C:MOJIID


;;;<HOM>*************************************************************************
;;; <関数名>     : C:BUZAILIST
;;; <処理概要>   : 図面上の部材一覧
;;; <戻り値>     : なし
;;; <作成>       : 07/03/26 YM
;;; <備考>       : 
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

		  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));日付
		  (princ #date_time #fil) ; 日付書き込み
		  (princ "\n" #fil)
			(princ (strcat "\n----------------------") #fil)
			(princ (strcat "\n■　図面上の部材一覧　") #fil)
			(princ (strcat "\n----------------------") #fil)
		  (princ "\n" #fil)

		  (setq #i 0)
			(princ "\n扉ID,図形ID,品番名称,LR区分,X,Y,Z,ANG" #fil)
		  (repeat #kosu
	      (setq #sym (ssname #ss #i))
				(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
				(setq #id  (nth 0 #xd_LSYM$));図形ID
				(setq #pt  (nth 1 #xd_LSYM$));挿入基点
				(setq #ang (nth 2 #xd_LSYM$));挿入角度
				(setq #hin (nth 5 #xd_LSYM$));品番
				(setq #LR  (nth 6 #xd_LSYM$));LR

				(setq #DrInfo (nth 7 #xd_LSYM$)) ;扉情報
		    (setq #DrInfo$ (strparse #DrInfo ","))
				(setq #DRSeri (nth 0 #DrInfo$))
				(setq #DRCol  (nth 1 #DrInfo$))
				(setq #DRHiki (nth 2 #DrInfo$))

				(if (= #DRSeri nil)					(setq #DRSeri ""))
				(if (= #DRCol nil)					(setq #DRCol ""))
				(if (= #DRHiki nil)					(setq #DRHiki ""))

			  (setq #qry$$
			    (CFGetDBSQLRec CG_DBSESSION "品番シリ"
			      (list
			        (list "品番名称"    #hin    'STR)
			        (list "LR区分"      #LR     'STR)
			        (list "扉シリ記号"  #DRSeri 'STR)
			        (list "引手記号"    #DRHiki 'STR)
			      )
			    )
			  )
				(if (= nil #qry$$)
					(progn
						(setq #drid "扉図形IDなし")
					)
					(progn
	      		(setq #drid (nth 4 (car #qry$$)));"0410329"
						(if (= #drid nil)					(setq #drid "扉図形ID=nil"))
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
			(princ "\n図面上に部材がありません")
		)
	);_if

	(princ)
);C:BUZAILIST


;;;<HOM>*************************************************************************
;;; <関数名>    : C:KAISOCHECK
;;; <処理概要>  : [階層]<==>[品番基本][品番図形]存在ﾁｪｯｸ
;;; <作成>      : 2011/08/30 YM
;;; <備考>      :
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
    ;;; ;品番にｽﾍﾟｰｽ文字,全角があるかどうかﾁｪｯｸ
    ;;;**********************************************************************
    (defun ##CheckSpace (
      &hin ; 品番
			&tbl ;ﾃｰﾌﾞﾙ名
      /
			#FLG #HIN
      )
      ;品番の"()"を外す
      (setq #hin (KP_DelHinbanKakko &hin))

      ;半角ｽﾍﾟｰｽがあるかどうか
			(setq #flg1 nil)
      (setq #flg1 (vl-string-search " " #hin))
			(if #flg1
      	(princ (strcat "\n" ",★," "品番に半角ｽﾍﾟｰｽあり" &tbl "," #hin) #fil)
			);_if

      ;全角ｽﾍﾟｰｽがあるかどうか
			(setq #flg2 nil)
      (setq #flg2 (vl-string-search "　" #hin))
			(if #flg2
      	(princ (strcat "\n" ",★," "品番に全角ｽﾍﾟｰｽあり" &tbl "," #hin) #fil)
			);_if

      (princ)
    );##CheckSpace

;///////////////////////////////////////////////////////////////////////////////

	(setq #fil (open (strcat CG_SYSPATH "LOG\\階層不整合CHECK_" CG_SeriesDB ".csv") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n階層不整合ﾁｪｯｸ(C:KAISOCHECK)" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesDB) #fil)
  (princ "\n" #fil)
  (princ "\n")
	
  ;ｼﾘｰｽﾞ階層ﾁｪｯｸ-------------------------------------------------------------------------------
  (setq #lis$ nil #rec$ nil #hin$$ nil #KAISO$$ nil #KIHON$$ nil)

  (setq #DBNAME "階層")
  (princ (strcat "\n" #DBNAME " read"))
  (setq #rec$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " #DBNAME)))

  (foreach #rec #rec$
    (setq #kaiso_flg (nth 3 #rec)) ;階層ﾌﾗｸﾞ
    (setq #hin       (nth 2 #rec)) ;品番名称

		(if (or (= #hin nil)(= #hin ""))
			(progn
				(princ "\n品番名称 = nil")
				(princ #rec)
			)
			(progn ;品番=nil以外を対象
		    (setq #UP_ID_1   (substr (nth 1 #rec) 1 1)) ;上位階層ID
		    (if (equal #kaiso_flg 0.0 0.001) ; 階層ﾌﾗｸﾞ=0のものだけ
		    	(setq #hin$$ (append #hin$$ (list (list #hin #UP_ID_1))));(品番,上位階層IDの1桁目)のﾘｽﾄ
		    );_if
			)
		);_if
  );foreach
	
  (princ (strcat "\nﾁｪｯｸ開始"))
  (princ (strcat "\nﾁｪｯｸ開始") #fil)

  (princ (strcat "\n" "," "区分" "," "エラー" "," "品番/ﾌｧｲﾙ" "," "LR区分" "," "備考") #fil)

  (princ "\n")
  (princ "\n" #fil)

  (foreach #hin$ #hin$$
		(setq #hin (nth 0 #hin$));品番
	 	(setq #UP_ID_1 (nth 1 #hin$));上位階層IDの1桁目
		;"()"付き品番判定
    (if (and (vl-string-search "(" #hin)(vl-string-search ")" #hin))
      (progn ;"()"付き品番だった
	      ;品番の"()"を外す
	      (setq #no_hin (KP_DelHinbanKakko #hin))
        ;"()"なし品番が[品番基本]にあるか
        (setq #KIHON$$
          (CFGetDBSQLRec CG_DBSESSION "品番基本"
            (list
              (list "品番名称"  #no_hin 'STR)
            )
          )
        )
        (if (= nil #KIHON$$)
          (princ (strcat "\n" ",●," "[品番基本]に括弧()なし品番なし" "," #hin) #fil)
        );_if
			)
		);_if

		;半角、全角ｽﾍﾟｰｽﾁｪｯｸ[階層]
		(##CheckSpace #hin "[階層]")


    ;ｵﾘｼﾞﾅﾙ品番もﾁｪｯｸ
    ;品番が[品番基本]にあるか
    (setq #KIHON$$
      (CFGetDBSQLRec CG_DBSESSION "品番基本"
        (list
          (list "品番名称"  #hin 'STR)
        )
      )
    )
    (if (= nil #KIHON$$)
			(progn
				(if (= #UP_ID_1 "-")
					nil
					;else
      		(princ (strcat "\n" ",■," "[階層]にあり[品番基本]になし" "," #hin) #fil)
				);_if
			)
    );_if

		;上位階層が"9"でなければ[品番図形]の存在ﾁｪｯｸも行う
		(if (and (/= #UP_ID_1 "9")(/= #UP_ID_1 "-"))
			(progn
		    ;"%"付き判定
		    (if (vl-string-search "%" #hin)
					(progn ;LRあり

				    (setq #ZUKEI$$
				      (CFGetDBSQLRec CG_DBSESSION "品番図形"
				        (list
				          (list "品番名称"  #hin 'STR)
				          (list "LR区分"    "L" 'STR)
				        )
				      )
				    )
				    (if (= nil #ZUKEI$$)
				      (princ (strcat "\n" ",▲," "[階層]にあり[品番図形]になし" "," #hin "," "LR区分=L") #fil)
				    );_if
						(if (and #ZUKEI$$ (= 1 (length #ZUKEI$$)))
							(progn
								(setq #zukeiID (nth 6 (car #ZUKEI$$)))
						    (if (or (= nil #zukeiID)(= "" #zukeiID))
						      (princ (strcat "\n" ",▼,"  "[品番図形]に図形IDなし" "," #hin "," "LR区分=L") #fil)
									;else
									(progn
										(if (findfile (strcat CG_SKDATAPATH "MASTER\\" #zukeiID ".dwg"))
											nil
											;else
											(princ (strcat "\n" ",◆,"  "MASTER図形なし" "," #hin "," "LR区分=L" "," #zukeiID ".dwg") #fil)
										);_if

										(if (findfile (strcat CG_SKDATAPATH "CRT\\" #zukeiID ".sld"))
											nil
											;else
											(princ (strcat "\n" ",◇,"  "CRTｽﾗｲﾄﾞなし" "," #hin "," "LR区分=L" "," #zukeiID ".sld") #fil)
										);_if
									)
						    );_if
							)
						);_if


				    (setq #ZUKEI$$
				      (CFGetDBSQLRec CG_DBSESSION "品番図形"
				        (list
				          (list "品番名称"  #hin 'STR)
				          (list "LR区分"    "R" 'STR)
				        )
				      )
				    )
				    (if (= nil #ZUKEI$$)
				      (princ (strcat "\n" ",▲," "[階層]にあり[品番図形]になし" "," #hin "," "LR区分=R") #fil)
				    );_if
						(if (and #ZUKEI$$ (= 1 (length #ZUKEI$$)))
							(progn
								(setq #zukeiID (nth 6 (car #ZUKEI$$)))
						    (if (or (= nil #zukeiID)(= "" #zukeiID))
						      (princ (strcat "\n" ",▼,"  "[品番図形]に図形IDなし" "," #hin "," "LR区分=R") #fil)
									;else
									(progn
										(if (findfile (strcat CG_SKDATAPATH "MASTER\\" #zukeiID ".dwg"))
											nil
											;else
											(princ (strcat "\n" ",◆,"  "MASTER図形なし" "," #hin  "," "LR区分=R" "," #zukeiID ".dwg") #fil)
										);_if

										(if (findfile (strcat CG_SKDATAPATH "CRT\\" #zukeiID ".sld"))
											nil
											;else
											(princ (strcat "\n" ",◇,"  "CRTｽﾗｲﾄﾞなし" "," #hin "," "LR区分=R" "," #zukeiID ".sld") #fil)
										);_if
									)
						    );_if

							)
						);_if

					)
					(progn ;LRなし

				    (setq #ZUKEI$$
				      (CFGetDBSQLRec CG_DBSESSION "品番図形"
				        (list
				          (list "品番名称"  #hin 'STR)
				          (list "LR区分"    "Z" 'STR)
				        )
				      )
				    )
				    (if (= nil #ZUKEI$$)
				      (princ (strcat "\n" ",▲," "[階層]にあり[品番図形]になし" "," #hin "," "LR区分=Z") #fil)
				    );_if
						(if (and #ZUKEI$$ (= 1 (length #ZUKEI$$)))
							(progn
								(setq #zukeiID (nth 6 (car #ZUKEI$$)))
						    (if (or (= nil #zukeiID)(= "" #zukeiID))
						      (princ (strcat "\n" ",▼,"  "[品番図形]に図形IDなし" "," #hin "," "LR区分=Z") #fil)
									;else
									(progn
										(if (findfile (strcat CG_SKDATAPATH "MASTER\\" #zukeiID ".dwg"))
											nil
											;else
											(princ (strcat "\n" ",◆,"  "MASTER図形なし" "," #hin "," "LR区分=Z" "," #zukeiID ".dwg") #fil)
										);_if

										(if (findfile (strcat CG_SKDATAPATH "CRT\\" #zukeiID ".sld"))
											nil
											;else
											(princ (strcat "\n" ",◇,"  "CRTｽﾗｲﾄﾞなし" "," #hin "," "LR区分=Z" "," #zukeiID ".sld") #fil)
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


  ;●[品番基本]にあるものが、階層に登録されているか
  (princ (strcat "\n[品番基本]→階層存在ﾁｪｯｸ開始"))
  (princ (strcat "\n[品番基本]→階層存在ﾁｪｯｸ開始") #fil)

	(setq #kaiso_hin$  (mapcar 'car #hin$$))

  (setq #kihon$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "品番基本")))
  (setq #kihon_ALL$$ nil)
  (foreach #kihon$ #kihon$$
    (setq #kihon_hin (nth 0 #kihon$)) ;品番
		;半角、全角ｽﾍﾟｰｽﾁｪｯｸ[品番基本]
		(##CheckSpace #kihon_hin "[品番基本]")
    (if (member #kihon_hin #kaiso_hin$)
      nil ; OK
      ;else
      (princ (strcat "\n" ",◎," "[品番基本]にあり[階層]になし" "," #kihon_hin) #fil)
    );_if
  );foreach

  (princ "\n")
  (princ "\n" #fil)
  (princ (strcat "\n[品番基本]→階層存在ﾁｪｯｸ終了"))
  (princ (strcat "\n[品番基本]→階層存在ﾁｪｯｸ終了") #fil)
  (princ "\n")
  (princ "\n" #fil)

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n" #fil)

  (princ (strcat "\n★★★ 階層不整合ﾁｪｯｸ終了 ★★★") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\階層不整合CHECK_" CG_SeriesDB ".csv"))
  (princ)
);C:KAISOCHECK


;;;<HOM>***********************************************************************
;;; <関数名>    : C:DB_CONNECT
;;; <処理概要>  : ｼﾘｰｽﾞ別DB再接続
;;; <戻り値>    : なし
;;; <作成>      :;2012/04/23 YM ADD
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun C:DB_CONNECT ( / #rec$$ #RET)

	(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)
	(setq #ret (DBDisConnect CG_DBSESSION))
	(princ "\nｼﾘｰｽﾞ別DBを切断しました")
	(princ "\n戻り値=")(princ #ret)

	(if #ret
		(progn ;正常切断
			(setq CG_DBSESSION nil)

			(princ "\nCG_DBNAME= ")(princ CG_DBNAME)
			(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)
			(setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
			(princ "\nｼﾘｰｽﾞ別DBを接続しました")
			(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)

			(princ "\n接続テスト:【扉シリズ】 ")
			(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 扉シリズ")))

			(if #rec$$
				(progn
					(princ "\n検索結果ﾚｺｰﾄﾞ一覧")
					(foreach #rec$ #rec$$
						(princ "\n")(princ #rec$)
					)
				)
				(progn
					; ARX再ロード
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
					(princ "\nｼﾘｰｽﾞ別DBを接続しました")
					(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)
					(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 扉シリズ")))
					(princ "\n検索結果ﾚｺｰﾄﾞ一覧")
					(foreach #rec$ #rec$$
						(princ "\n")(princ #rec$)
					)
				)
			);_if

		)
		(progn
			(CFAlertErr (strcat "DBを正常に切断できません。KPCADを中断終了後、再起動してください。"
													"\n中断終了できない場合は、quit[Enter]で強制終了してください"))
		)
	);_if

	(princ)
);C:DB_CONNECT

;;;<HOM>***********************************************************************
;;; <関数名>    : C:DB_DISCONNECT
;;; <処理概要>  : ｼﾘｰｽﾞ別DB切断
;;; <戻り値>    : なし
;;; <作成>      :;2012/04/23 YM ADD
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun C:DB_DISCONNECT ( / #rec$$ #ret)

	(princ "\nCG_DBNAME= ")(princ CG_DBNAME)
	(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)

	(setq #ret (DBDisConnect CG_DBSESSION))
	(princ "\nｼﾘｰｽﾞ別DBを切断しました")
	(princ "\n戻り値=")(princ #ret)

	(setq CG_DBSESSION nil)
	(princ "\nCG_DBSESSION= ")(princ CG_DBSESSION)

	(princ "\n接続テスト:【扉シリズ】 ")
	(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 扉シリズ")))
	(foreach #rec$ #rec$$
		(princ "\n")(princ #rec$)
	)
	(princ)
);C:DB_DISCONNECT



;;;<HOM>***********************************************************************
;;; <関数名>    : C:DB_SEARCH_SPEED
;;; <処理概要>  : 品番最終検索速度
;;; <戻り値>    : なし
;;; <作成>      :;2012/06/01 YM ADD
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun C:DB_SEARCH_SPEED (
	/
	#rec$$ #ret #DATE_TIME #FIL #HINBAN$ #OFILE #QRY$
)

	(setq #start (* 86400 (getvar "TDINDWG")));開始時刻

  (setq #ofile  (strcat CG_SYSPATH "tmp\\検索速度.txt"));ﾁｪｯｸ結果出力ﾌｧｲﾙ
  (setq #fil (open #ofile "W" ))

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));日付
  (princ #date_time #fil) ; 日付書き込み

  (princ "\n" #fil)
  (princ "\n--- 開始 ---" #fil)
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
			"H$90SRN-QN-@@(ﾊﾟﾈﾙ付)"
			"H$90SRN-JN-@@(ﾊﾟﾈﾙ付)"
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
			"H$90RRN-JN-@@(ﾊﾟﾈﾙ付)"
			"H$90RRN-JN-@@"
			"H$90RHB-IN#-@@"
			"H$90SRN-QN-@@"
			"H$B0RHN-CN#-@@"
			"H$A5SRN-QN-@@(ﾊﾟﾈﾙ付)"
			"H$A5SRN-JN-@@(ﾊﾟﾈﾙ付)"
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
			"H$A5RRN-JN-@@(ﾊﾟﾈﾙ付)"
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
			"R$90S1B-MN#-@@(ﾀﾞｽﾄJ42)"
			"R$90S1B-LN#-@@(ﾀﾞｽﾄJ42)"
			"R$75S1B-MN#-@@(ﾀﾞｽﾄJ42)"
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
			"R$60PHB-JN#-@@(ｽﾍﾟｰｻｰ付)"
			"HS$B075M-@@-T19"
			"R$90PHB-JN#-@@(ｽﾍﾟｰｻｰ付)"
			"HS$B090M-@@-T10"
			"R$60PHB-JN#-@@"
			"R$75PHB-JN#-@@"
			"R$90PHB-JN#-@@"
			"HS$BK90M-@@-T18"
			"HS$BK75M-@@-T18"
			"HS$BK90M-@@-T10"
			"HS$BK75M-@@-T10"
			"R$75PHB-JN#-@@(ｽﾍﾟｰｻｰ付)"
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
			"R$75S1B-LN#-@@(ﾀﾞｽﾄJ42)"
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
			"R$90S1B-PN#-@@(ﾀﾞｽﾄJ42)"
			"R$75SKB-MN#-@@"
			"R$60S1B-PN#-@@"
			"R$75S2B-RN#-@@(ﾀﾞｽﾄJ42)"
			"R$90S0B-PN#-@@"
			"R$90S3B-MN#-@@"
			"R$90S0B-LN#-@@"
			"R$60SSB-MN#-@@"
			"R$90SSB-MN#-@@"
			"R$60SKB-MN#-@@"
			"R$75S1B-PN#-@@(ﾀﾞｽﾄJ42)"
			"R$75S2B-MN#-@@(ﾀﾞｽﾄJ42)"
			"R$60S1B-LN#-@@"
			"R$75S0B-MN#-@@"
			"R$75S0B-LN#-@@"
			"R$60S0B-MN#-@@"
			"R$60S0B-LN#-@@"
			"R$90S2B-MN#-@@"
			"R$90S0B-MN#-@@"
			"R$90S2B-MN#-@@(ﾀﾞｽﾄJ42)"
			"R$60S2B-RN#-@@"
			"R$60S2B-MN#-@@"
			"R$90S2B-RN#-@@"
			"R$75S2B-RN#-@@"
			"R$90S2B-RN#-@@(ﾀﾞｽﾄJ42)"
			"R$90S3B-LN#-@@"
			"R$75SSB-MN#-@@"
			"R$75S2B-MN#-@@"
			"R$75PTN-HN-@@"
			"R$90PHB-HN#-@@(ｽﾍﾟｰｻｰ付)"
			"R$75PHB-HN#-@@(ｽﾍﾟｰｻｰ付)"
			"R$60PHB-HN#-@@(ｽﾍﾟｰｻｰ付)"
			"R$A5PTN-HN-@@"
			"R$A5PTN-BN-@@"
			"R$60PHB-BN#-@@"
			"R$90PTN-BN-@@"
			"R$60PHB-HN#-@@"
			"R$75PTN-BN-@@"
			"R$A5PTN-HN-@@(ｽﾍﾟｰｻｰ付)"
			"R$90PTN-HN-@@(ｽﾍﾟｰｻｰ付)"
			"R$75PTN-HN-@@(ｽﾍﾟｰｻｰ付)"
			"R$90PHB-UN#-@@"
			"R$75PHB-UN#-@@"
			"R$90PTN-HN-@@"
			"R$90SBN-MN#-@@"
			"R$60SBN-MN#-@@(ﾀﾞｽﾄJE1)"
			"R$75PHB-BN#-@@"
			"R$75PHB-HN#-@@"
			"R$90PHB-BN#-@@"
			"R$75SBN-MN#-@@(ﾀﾞｽﾄJE2)"
			"R$90PHB-HN#-@@"
			"R$90SBN-MN#-@@(ﾀﾞｽﾄJE3)"
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
		
	 	;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
		(setq #qry$
		 	(CFGetDBSQLRec CG_DBSESSION "品番最終"
				(list
					(list "品番名称"    #hinban      'STR)
					(list "LR区分"      "Z"          'STR)
					(list "扉シリ記号" CG_DRSeriCode 'STR)
					(list "扉カラ記号" CG_DRColCode  'STR)
					(list "引手記号"   CG_Hikite     'STR)
				)
			)
		)
		(if (= 1 (length #qry$))
			(progn
				(princ (strcat "\n" (nth 10 (car #qry$)) ))
			)
		);_if
		

	);foreach


	(setq #end (* 86400 (getvar "TDINDWG")));終了時刻
	(setq #time (rtos (- #end #start)));時間
	(princ (strcat "\n時間= " #time))
	(princ (strcat "\n時間= " #time) #fil)


  (princ "\n" #fil)
  (princ "\n--- 終了 ---" #fil)
  (princ "\n" #fil)

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));日付
  (princ #date_time #fil) ; 日付書き込み


	(if #fil (close #fil))

	(startapp "notepad.exe" #ofile)
  (princ)


);C:DB_SEARCH_SPEED

;<HOM>************************************************************************
; <関数名>    : mdb_dwg_zukei_size_check
; <処理概要>  : [品番図形]とGSM図形とでサイズを比較する
; <戻り値>    :
; <作成>      : 2012/07/20 YM ADD
; <備考>      :
;************************************************************************>MOH<
(defun C:mdb_dwg_zukei_size_check (
 	/
	#FIL #FLG #FULLPATH #HIN #I #LR #NAME #PATH #QRY$$ #REC$$ #SKK #SS_SYM #SYM #XD$ #ZUKEIID #ZUKEI
	#GSM_D #GSM_H #GSM_W #MDB_D #MDB_H #MDB_LR #MDB_W #DATE_TIME
	)
	; ﾛｸﾞﾌｧｲﾙOPEN
  (setq #fil (open (strcat CG_SYSPATH "\\log\\mdb_dwg_zukei_size_check.csv") "a" ))

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n" #fil)
	(princ (strcat "\n----------------------------------------") #fil)
	(princ (strcat "\n[品番図形]とGSM図形とでサイズを比較する ") #fil)
	(princ (strcat "\n----------------------------------------") #fil)
  (princ "\n" #fil)
	;ﾍｯﾀﾞｰ
  (princ "\n図形ID,品番名称,LR区分,性格CODE,mdb_W,mdb_D,mdb_H,GSM_W,GSM_D,GSM_H" #fil)



	;品番基本 性格ｺｰﾄﾞ="1??"のものを抽出
	(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select 品番名称,LR有無,性格CODE from 品番基本 where 性格CODE > 100 and 性格CODE < 199")))

	(foreach #rec$ #rec$$
		(setq #hin (nth 0 #rec$))
		(setq #LR  (nth 1 #rec$))
		(setq #skk (nth 2 #rec$))
		;品番図形検索
    (setq #qry$$
    	(CFGetDBSQLRec CG_DBSESSION "品番図形"
        (list
          (list "品番名称" #hin 'STR)
        )
      )
    )
		(if #qry$$
			(progn ;2件HITする可能性あり
				(foreach #qry$ #qry$$
					(setq #mdb_LR (nth 1 #qry$)) ;LR
					(setq #mdb_W  (nth 3 #qry$)) ;W
					(setq #mdb_D  (nth 4 #qry$)) ;D
					(setq #mdb_H  (nth 5 #qry$)) ;H
					(setq #zukeiID (strcat (nth 6 #qry$))) ;図形ID
					(setq #zukei   (strcat "'" (nth 6 #qry$))) ;図形ID

					(setq #fullpath (strcat CG_MSTDWGPATH #zukeiID ".dwg"))
		      (if (findfile #fullpath)
						(progn
							;ﾌｧｲﾙｵｰﾌﾟﾝ
							(if (/= (getvar "DBMOD") 0)
								(command "_OPEN" "Y" #fullpath)
								;else
								(command "_OPEN" #fullpath)
							);END IF

							(setq #path (getvar "DWGPREFIX"))
						  (setq #name (getvar "DWGNAME")) ; 現在のﾌｧｲﾙ名
						  (princ (strcat "\n" #zukei "," #hin "," #mdb_LR ",") #fil)(princ #skk #fil)(princ "," #fil)

							;"G_SYM"ﾁｪｯｸ
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

									;判定Ｗ
									(if (not (equal #mdb_W #GSM_W 0.1))
										(princ ",寸法W値が異なる" #fil)
									);_if

									;判定Ｄ
									(if (not (equal #mdb_D #GSM_D 0.1))
										(princ ",寸法D値が異なる" #fil)
									);_if

									;判定Ｈ
									(if (not (equal #mdb_H #GSM_H 0.1))
										(princ ",寸法H値が異なる" #fil)
									);_if

									(setq #i (1+ #i))
								)
								(progn ;G_SYMがないか、または、複数存在する
									(princ (strcat "★★★　G_SYMがないか、または、複数存在する: 図形ID=" #zukei) #fil)
								)
							);_if

						)
						(progn
							(princ (strcat "\n★★★　DWGﾌｧｲﾙがありません: 図形ID=" #zukei) #fil)
						)		        
		      );_if

				)
			)
			(progn
				(princ (strcat "\n★★★　品番図形にﾚｺｰﾄﾞがありません: 品番名称=" #hin) #fil)
			)
		);_if


	);foreach

	(close #fil)
	(princ)
);mdb_dwg_zukei_size_check



;;;<HOM>*************************************************************************
;;; <関数名>    : C:CG_DOOR_MASTER_CHECK
;;; <処理概要>  : 【扉構成】ﾃｰﾌﾞﾙのﾚｺｰﾄﾞ漏れをﾁｪｯｸ
;;; <戻り値>    : なし
;;; <作成>      : 2012/08/08 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:CG_DOOR_MASTER_CHECK (
  /
	#DATE_TIME #DOORID$$ #DOORID1 #DOORID2 #DRMASTER$$ #FIL #HINBAN #HINBAN$$ #LR
	#ZUKEI$$ #ZUKEIID #DRMASTER$ #I #LOOP #OK
  )
  (setq #fil (open (strcat CG_SYSPATH "LOG\\扉構成ﾃｰﾌﾞﾙCHECK.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n" #fil)

	;【品番シリ】対象品番
	(setq #hinban$$ nil)
	;【品番シリ】から,扉図形IDがnullでない対象品番のみ(重複削除)を抽出
	(setq #hinban$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select distinct 品番名称 from 品番シリ where 扉図形ID is not null")))

	(foreach #hinban$ #hinban$$
		(setq #hinban (car #hinban$))
		;【品番図形】
		(setq #zukei$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select LR区分,図形ID from 品番図形 where 品番名称 = '" #hinban "'")))
		;2件の場合あり
		(foreach #zukei$ #zukei$$
			;(LR区分,図形ID)
			(setq #LR      (nth 0 #zukei$))
			(setq #zukeiID (nth 1 #zukei$))

			;【品番シリ】
			(setq #doorID$$ (DBSqlAutoQuery CG_DBSESSION
												(strcat "select 扉図形ID from 品番シリ where 品番名称 = '" #hinban "' and LR区分 = '" #LR "'" )))
			;代表【品番シリ】
			(setq #doorID1 (car (car #doorID$$))) ;0471111
			(setq #doorID1 (strcat (substr #doorID1 1 5) "*"))

			;【扉構成】存在確認
			(setq #drMASTER$$ (DBSqlAutoQuery CG_DBSESSION
												(strcat "select 扉図形ID from 扉構成 where 図形ID = '" #zukeiID "'" )))

			;代表【扉構成】
			(if #drMASTER$$
				(progn
					(setq #loop T)
					(setq #i 0)
					(setq #OK nil); ;問題なし
					(while (and #loop (< #i (length #drMASTER$$)))
						(setq #drMASTER$ (nth #i #drMASTER$$))
						(setq #doorID2 (car #drMASTER$)) ;0471111
						(if (wcmatch #doorID2 #doorID1)
							(progn
								(setq #loop nil);ﾙｰﾌﾟから抜ける
								(setq #OK T); ;問題なし
							)
						);_if

						(setq #i (1+ #i))
					);while

					(if #OK
						nil
						;else
						;ｴﾗｰ出力
						(princ (strcat "\n*** Recordありﾏｯﾁしない: 品番名称= " #hinban ",LR区分= " #LR ",【品番シリ】扉図形ID= " #doorID1 ",図形ID= " #zukeiID ) #fil)
					);_if

				)
				(progn ;【扉構成】にない
						;ｴﾗｰ出力
						(princ (strcat "\nxxx Recordなし   　　　: 品番名称= " #hinban ",LR区分= " #LR ",【品番シリ】扉図形ID= " #doorID1 ",図形ID= " #zukeiID ) #fil)
				)				
			);_if

		);foreach

	);foreach


  (princ (strcat "\n---終了") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\扉構成ﾃｰﾌﾞﾙCHECK.txt"))
  (princ)

	;like検索"%"ﾜｲﾙﾄﾞｶｰﾄﾞ
	;(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select 品番名称 from 品番シリ where 扉図形ID like '04711%'")))
	;null検索
	;(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select 間口記号 from 間口 where 間口 is null ")))
	;null検索重複削除	
	;(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select distinct 間口記号 from 間口 where 間口 is null ")))
	;ﾚｺｰﾄﾞｿｰﾄ
	;(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select ID,間口記号 from 間口 where 間口 is null ORDER BY ID")))

);C:CG_DOOR_MASTER_CHECK

;;;<HOM>*************************************************************************
;;; <関数名>    : C:Change_SKK
;;; <処理概要>  : 性格コードを変更する
;;; <戻り値>    : なし
;;; <作成>      : 2013/05/17 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:Change_SKK (
  /
	#EN #SKK #SYM #XD$
  )
  (setq #en (car (entsel)))

  (if (= #en nil)
    (progn
      (CFAlertErr "部材が選択されませんでした")(quit)
    )
    (progn
      (setq #sym (SearchGroupSym #en)) ; ｼﾝﾎﾞﾙ図形名
    )
  );_if

  (if (= #sym nil)
    (progn
      (CFAlertErr "\"G_LSYM\"がありません")(quit)
    )
    (progn

			(setq #skk (getstring "\n新しい性格ｺｰﾄﾞを入力: "))
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
;;; <関数名>    : C:CG_Info
;;; <処理概要>  : 選択した図形のCG不具合調査に必要な情報を取得(扉構成)
;;; <作成>      : 2013/08/19 修正 YM
;;;*************************************************************************>MOH<

;;;-----------------------------------------------------------------
;;;[0]:G_LSYM ｼﾝﾎﾞﾙ基準点                       G_LSYM
;;;[1]:本体図形ID    :10ﾊﾞｲﾄ(dwgﾌｧｲﾙ名)         (1000 . 0210812)
;;;[2]:挿入点        :配置基点 x,y,z            (1010 770.0 0.0 0.0)
;;;[3]:回転角度      :ﾗｼﾞｱﾝ                     (1040 . 0.0)
;;;[4]:工種記号      :2ﾊﾞｲﾄ                     (1000 . K)
;;;[5]:ｼﾘｰｽﾞ記号     :2ﾊﾞｲﾄ                     (1000 . S)
;;;[6]:品番名称      :20ﾊﾞｲﾄ                    (1000 . H$45U3A-IN#-@@)
;;;[7]:L/R区分       :Z,L,R                     (1000 . Z)
;;;[8]:扉図形ID      :10ﾊﾞｲﾄ                    (1000 . MJ,H_M,X)
;;;[9]:扉開き図形ID  :10ﾊﾞｲﾄ                    (1000 . 0210812)
;;;[10]:性格ｺｰﾄﾞ      :品番情報の性格ｺｰﾄﾞ        (1070 . 111)
;;;[11]:複合ﾌﾗｸﾞ      :0(単独),1(複合),2(OP部材) (1070 . 0)
;;;[12]:配置順番号    :配置順番号(1～)           (1070 . 0)
;;;[13]:用途番号      :0～99                     (1070 . 0)
;;;[14]:寸法Ｈ        :品番図形DBの登録H寸法値   (1070 . 813)
;;;[15]:断面指示有無  :0(なし),1(あり)           (1070 . 0)
;;;[16]:分類          :キッチン(A) or 収納(D)    (1000 . A)
;;; -----------------------------------------------------------------
;;;[0]:G_SYM                                    G_SYM
;;;[1]:ｼﾝﾎﾞﾙ名称                                (1000 . S-45PPXB5)
;;;[2]:ｺﾒﾝﾄ１                                   (1000 . )
;;;[3]:ｺﾒﾝﾄ２                                   (1000 . )
;;;[4]:ｼﾝﾎﾞﾙ基準値W                             (1040 . 450.0)
;;;[5]:ｼﾝﾎﾞﾙ基準値D                             (1040 . 650.0)
;;;[6]:ｼﾝﾎﾞﾙ基準値H                             (1040 . 813.0)
;;;[7]:ｼﾝﾎﾞﾙ取付高さ                            (1040 . 0.0)
;;;[8]:入力方法                                 (1070 . 3)
;;;[9]:W方向ﾌﾗｸﾞ                                (1070 . 1)
;;;[10]:D方向ﾌﾗｸﾞ                                (1070 . 1)
;;;[11]:H方向ﾌﾗｸﾞ                                (1070 . 1)
;;;[12]:伸縮ﾌﾗｸﾞW                                (1070 . 0)
;;;[13]:伸縮ﾌﾗｸﾞD                                (1070 . 0)
;;;[14]:伸縮ﾌﾗｸﾞH                                (1070 . 0)
;;;[15]:ﾌﾞﾚｰｸﾗｲﾝ数W                              (1070 . 0)
;;;[16]:ﾌﾞﾚｰｸﾗｲﾝ数D                              (1070 . 0)
;;;[17]:ﾌﾞﾚｰｸﾗｲﾝ数H                              (1070 . 0)
;;; -----------------------------------------------------------------
;;;扉図ID=DR0410312

(defun c:CG_Info(
  /
	#DD #DRCOL #DRHIKI #DRID #DRINFO #DRINFO$ #DRSERI #EN #ET #HH
	#HINBAN #LR #QRY$$ #WW #XD_LSYM #XD_SYM #ZUKEI #SYM #XD_LSYM$ #XD_SYM$
	#GSM_D #GSM_H #GSM_W #I ;2013/11/07 YM ADD
  )
	;部材一覧
;;;	(C:BUZAILIST)

  (setq #iseri (strcat CG_SYSPATH "texture_path.txt"));ﾃｸｽﾁｬの検索パス
  (setq #path$ (ReadCSVFile #iseri))
	(setq #path (car (car #path$)))

	(princ "\n")
	(princ "\n")
	(princ "\n")
	
  (setq #en (car (entsel)))

  (if (= #en nil)
    (progn
      (CFAlertErr "部材が選択されませんでした")
			(quit)
    )
    (progn
      (setq #sym (SearchGroupSym #en)) ; ｼﾝﾎﾞﾙ図形名
    )
  );_if

  (if (= #sym nil)
    (progn
      (CFAlertErr "\"G_LSYM\"がありません")
			(quit)
    )
    (progn
;;;      (setq #et (entget #sym))

			(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
			(setq #xd_SYM$  (CFGetXData #sym "G_SYM"))

			(setq #GSM_W (nth 3 #xd_SYM$)) ;GSM_W
			(setq #GSM_D (nth 4 #xd_SYM$)) ;GSM_D
			(setq #GSM_H (nth 5 #xd_SYM$)) ;GSM_H

			(setq #zukei  (nth 0 #xd_LSYM$)) ;本体図形ID "0210812"
			(setq #hinban (nth 5 #xd_LSYM$)) ;品番名称
			(setq #LR     (nth 6 #xd_LSYM$)) ;LR区分
			(setq #DrInfo (nth 7 #xd_LSYM$)) ;扉情報
	    (setq #DrInfo$ (strparse #DrInfo ","))
			(if (= #DrInfo "")
				(progn
					;機器類など
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

			;＜＜＜　品番図形　＞＞＞
		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "品番図形"
		      (list
		        (list "品番名称"    #hinban       'STR)
		        (list "LR区分"      #LR           'STR)
		      )
		    )
		  )
			(if (= nil #qry$$)
				(progn
		      (setq #WW "なし") ;450.0
		      (setq #DD "なし")
		      (setq #HH "なし")
				)
				(progn
		      (setq #WW (itoa (fix (+ (nth 3 (car #qry$$)) 0.001))));450.0
		      (setq #DD (itoa (fix (+ (nth 4 (car #qry$$)) 0.001))))
		      (setq #HH (itoa (fix (+ (nth 5 (car #qry$$)) 0.001))))
				)
			);_if

			;＜＜＜　品番シリ　＞＞＞
		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "品番シリ"
		      (list
		        (list "品番名称"    #hinban 'STR)
		        (list "LR区分"      #LR     'STR)
		        (list "扉シリ記号"  #DRSeri 'STR)
		        (list "引手記号"    #DRHiki 'STR)
		      )
		    )
		  )
			(if (= nil #qry$$)
				(progn
					(princ "\n 品番シリなし")
      		(setq #drid "扉図形IDなし")
				)
				(progn
      		(setq #drid (nth 4 (car #qry$$)));"0410329"
					(if (= #drid nil)(setq #drid ""))
				)
			);_if

		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "扉構成"
		      (list
		        (list "扉図形ID"    #drid  'STR)
		        (list "図形ID"      #zukei 'STR)
		      )
		    )
		  )


      (princ "\n**************************************************************************" )
      (princ "\n＜CG関連情報出力＞" )
      (princ "\n--------------------------------------------------------------------------" )
			(princ "\n扉構成 検索扉図形ID =")(princ #drid)
			(princ "\n扉構成 検索　図形ID =")(princ #zukei)

			(princ "\n扉情報  =")(princ #DrInfo)
			(princ "\n扉シリ記号=")(princ #DRSeri)
			(princ "\n扉カラ記号=")(princ #DRCol)
			(princ "\n引手記号　=")(princ #DRHiki)
      (princ "\n--------------------------------------------------------------------------" )
			(princ "\n [扉構成]")
      (princ "\n--------------------------------------------------------------------------" )
      (princ "\n扉図形ID,図形ID,貼付面,間口,高さ,枚目,X,Y,W,H,柄方向,框種類,取手種類,取手位置,扉シリーズ,扉カラー" )
      (princ "\n--------------------------------------------------------------------------" )
			(if (= nil #qry$$)
				(progn
					(princ "\n★★★　扉構成なし　★★★")
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
								(princ "\n★幅サイズがおかしい★")
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
								(princ "\n★高さサイズがおかしい★")
						 	)
						);_cond

						(setq #MAI    (itoa (fix (nth 5 #qry$))))

						;テクスチャ名
						(if (= 1 (strlen #DRCol))
							(setq #DRCol (strcat #DRCol "@"))
						);_if
						(setq #TEXTURE (strcat #ZU_ID "_" #DR_ID "_" "0" #MEN_ID "_" #WW "_" #HH "_" "0" #MAI "_" #DRCol ".jpg"))
						;扉テクスチャ存在確認
						(setq #flg (findfile (strcat #path "Door_Texture_3\\" #DRCol "\\" #TEXTURE)))
						(if #flg
							(progn ;存在する

								;既にﾌｫﾙﾀﾞに存在するjpgを削除する
								(setq #jpg$ (vl-directory-files CG_LOGPATH "*.jpg" 1));組込み関数あり
								(foreach #jpg #jpg$
									(vl-file-delete (strcat CG_LOGPATH #jpg))
								);foreach


								(princ "\n扉ﾃｸｽﾁｬ= ")(princ #TEXTURE)(princ "　あり")
								;ｺﾋﾟｰする
					      (setq #tEndFlg (vl-file-copy  (strcat #path "Door_Texture_3\\" #DRCol "\\" #TEXTURE) (strcat CG_LOGPATH #TEXTURE) nil))
					      (if (= nil #tEndFlg)
					        (progn
					          (CFAlertErr (strcat "扉ﾃｸｽﾁｬをｺﾋﾟｰできません"))
					        )
									(progn ;ｺﾋﾟｰ出来た
										;mspaint.exe で開く
										(startapp "mspaint.exe" (strcat #path "Door_Texture_3\\" #DRCol "\\" #TEXTURE))
									)
					      );_if
							)
							;else
							(progn
								(princ "\n扉ﾃｸｽﾁｬ= ")(princ #TEXTURE)(princ "★★★扉テクスチャなし★★★")
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
			(princ "\nＧＳＭ.寸法W  =")(princ #GSM_W)
			(princ "\nＧＳＭ.寸法D  =")(princ #GSM_D)
			(princ "\nＧＳＭ.寸法H  =")(princ #GSM_H)
      (princ "\n--------------------------------------------------------------------------" )
			(princ "\n品番図形.図形ID  =")(princ #zukei)
			(princ "\n品番図形.品番名称=")(princ #hinban)
			(princ "\n品番図形.LR区分  =")(princ #LR)
			(princ "\n品番図形.寸法W  =")(princ #WW)
			(princ "\n品番図形.寸法D  =")(princ #DD)
			(princ "\n品番図形.寸法H  =")(princ #HH)
      (princ "\n**************************************************************************" )


		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "マテリアル検索"
		      (list
		        (list "品番"    #hinban  'STR)
		      )
		    )
		  )
			(if #qry$$
				(progn
					(foreach #qry$ #qry$$
						(setq #material (nth 1 #qry$)) ;jpgあり or jpgなし

						;".jpg"を含んでいればテクスチャ存在確認を行う
						(setq #material_big (strcase #material));大文字
						(if (wcmatch #material_big "*.JPG")
							(progn ;テクスチャ存在確認
								(setq #flg (findfile (strcat #path "Goods_Texture_3\\" #material)))
								(if #flg
									(progn ;存在する
										(princ "\n機器ﾃｸｽﾁｬ= ")(princ #material)(princ "　あり")
									)
									;else
									(progn
										(princ "\n機器ﾃｸｽﾁｬ= ")(princ #material)(princ "★★★機器ﾃｸｽﾁｬなし★★★")
									)
								);_if
							)
							(progn ;マテリアル
								(princ "\nマテリアル= ")(princ #material)
							)
						);_if
					)
				)
				(progn
					(princ "\n [マテリアル検索]なし")
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
;2015/08/10 YM ADD 品番リストから【扉構成】テクスチャ存在確認
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:CG_Info_TOOL(
  /
	#CSV$$ #DATE_TIME #DRCOL #DRHIKI #DRID #DRSERI #DR_ID #FIL #FLG #HH
	#HINBAN #HINBAN$ #IFILE #LR #LR_FLG #MAI #MEN_ID #OFILE #QRY$$ #TEXTURE
	#WW #ZUKEI #ZU_ID
  )

		;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		;【検索】
		(defun ##KENSAKU( / )

			(setq #err_flg nil);ｴﾗｰならT
			
			;＜＜＜　品番図形　＞＞＞
		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "品番図形"
		      (list
		        (list "品番名称"    #hinban       'STR)
		        (list "LR区分"      #LR           'STR)
		      )
		    )
		  )
			(if #qry$$
				(progn
					(setq  #zukei (nth 6 (car #qry$$)))
					(if (or (= #zukei nil)(= #zukei ""))
						(progn
							(setq #err_flg T)
							;出力
					  	(princ (strcat "\n" #hinban "," #LR "," "★図形ID登録なし") #fil)
						)
					);_if
				)
				(progn
					(setq #err_flg T)
					;出力
			  	(princ (strcat "\n" #hinban "," #LR "," "★品番図形になし") #fil)
				)
			);_if

			;＜＜＜　品番シリ　＞＞＞
		  (setq #qry$$
		    (CFGetDBSQLRec CG_DBSESSION "品番シリ"
		      (list
		        (list "品番名称"    #hinban 'STR)
		        (list "LR区分"      #LR     'STR)
		        (list "扉シリ記号"  #DRSeri 'STR)
		        (list "引手記号"    #DRHiki 'STR)
		      )
		    )
		  )
			(if #qry$$
				(progn
					(setq  #drid (nth 4 (car #qry$$)))
					(if (or (= #drid nil)(= #drid ""))
						(progn
							(setq #err_flg T)
							;出力
					  	(princ (strcat "\n" #hinban "," #LR "," "★扉図形ID登録なし") #fil)
						)
					);_if
				)
				(progn
					(setq #err_flg T)
					;出力
			  	(princ (strcat "\n" #hinban "," #LR "," "★品番シリになし") #fil)
				)
			);_if

			;＜＜＜　扉構成　＞＞＞
			(if #err_flg
				nil ;ｴﾗｰ
				;else
				(progn

				  (setq #qry$$
				    (CFGetDBSQLRec CG_DBSESSION "扉構成"
				      (list
				        (list "扉図形ID"    #drid  'STR)
				        (list "図形ID"      #zukei 'STR)
				      )
				    )
				  )

					(if (= nil #qry$$)
						(progn
							;出力
					  	(princ (strcat "\n" #hinban "," #LR ","  "扉図形ID=" #drid "," "図形ID=" #zukei "," "★扉構成なし") #fil)
						)
						(progn
							;(princ "\n品番名称,LR区分,扉図形ID,図形ID,貼付面,間口,高さ,枚目" )
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
										(setq #WW "★幅サイズ不備")
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
										(setq #HH "★高さ不備")
								 	)
								);_cond

								(setq #MAI    (itoa (fix (nth 5 #qry$))))

								;テクスチャ名
								(if (= 1 (strlen #DRCol))
									(setq #DRCol (strcat #DRCol "@"))
								);_if
								(setq #TEXTURE (strcat #ZU_ID "_" #DR_ID "_" "0" #MEN_ID "_" #WW "_" #HH "_" "0" #MAI "_" #DRCol ".jpg"))

								;扉テクスチャ存在確認
								(setq #flg (findfile (strcat #path "Door_Texture_3\\" #DRCol "\\" #TEXTURE)))

								(if #flg
									(setq #TEXTURE (strcat #TEXTURE " , ﾃｸｽﾁｬ存在する" )) ;存在する
									;else
									(setq #TEXTURE (strcat #TEXTURE " , ★ﾃｸｽﾁｬなし" )) ;存在しない
								);_if


								;出力
						  	(princ (strcat "\n" #hinban "," #LR "," #DR_ID "," #ZU_ID "," #MEN_ID "," #WW "," #HH "," #MAI "," #TEXTURE) #fil)

							);foreach

						)
					);_if

				)
			);_if

			(princ)
		);##KENSAKU
		;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



  (setq #iseri (strcat CG_SYSPATH "texture_path.txt"));ﾃｸｽﾁｬの検索パス
  (setq #path$ (ReadCSVFile #iseri))
	(setq #path (car (car #path$)))

	;ﾁｪｯｸ対象品番の読み込み
  (setq #ifile (strcat CG_SYSPATH "LOG\\CG_INFO_HINBAN.txt"))
  (setq #CSV$$ (ReadCSVFile #ifile))
  (setq #hinban$ (mapcar 'car #CSV$$));ﾁｪｯｸ対象品番ﾘｽﾄ

	;ﾁｪｯｸ結果出力ﾌｧｲﾙ
  (setq #ofile  (strcat CG_SYSPATH "LOG\\CG_INFO_KEKKA.txt"))
  (setq #fil (open #ofile "W" ))

  (if (= nil #fil)
    (progn
      (CFAlertErr (strcat "kekka.txt が開けません。閉じてください"))
      (quit)
    )
  );_if

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"));日付
  (princ #date_time #fil ) ; 日付書き込み

  (princ "\n" #fil)
	(princ "\n")

	;現在の扉
	(setq #DRSeri CG_DRSeriCode)
	(setq #DRCol  CG_DRColCode)
	(setq #DRHiki CG_HIKITE)

  (princ "\n品番名称,LR区分,扉図形ID,図形ID,貼付面,間口,高さ,枚目,ﾃｸｽﾁｬ名" #fil)

	(foreach #hinban #hinban$

		;＜＜＜　品番基本　＞＞＞
	  (setq #qry$$
	    (CFGetDBSQLRec CG_DBSESSION "品番基本"
	      (list
	        (list "品番名称"    #hinban       'STR)
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

				;【検索】
				(##KENSAKU)

				(if (= #LR "L")
					(progn
						(setq #LR "R")
						(##KENSAKU)
					)
				);_if

			)
			(progn
				;出力
		  	(princ (strcat "\n" #hinban ","  "★品番基本なし") #fil)
			)
		);_if

	);(foreach


  (if #fil (close #fil))

  (startapp "notepad.exe" #ofile)

	(princ "\nﾁｪｯｸ終了")
	(princ)
);c:CG_Info_TOOL




;2014/02/14 YM ADD CGｻｰﾊﾞｰDOOR TEXTURE2のファイル名チェック
(defun C:CHECK_DOOR_TEXTURE2 (
  /
	#FP #RSTR
  )
	(setq #i 0)
  (setq #fp (open "./LOG/DOOR_TEXTURE2.txt" "r")) ;ﾌｧｲﾙｵｰﾌﾟﾝ(READ)
  (while (setq #rstr (read-line #fp)) ;ﾌｧｲﾙを読み込む
		(if (= 0 (rem #i 10000))
			(progn
				(princ "\ni=")(princ #i)
			)
		);_if
		(if (vl-string-search "jpg" #rstr) ; "jpg"があるか?
			(progn ;16,17桁
				(if (wcmatch (substr #rstr 16 4) "_0*_")
					nil
					;else
					(princ (strcat "\n" #rstr));出力
				);_if
      )
    );_if
		(setq #i (1+ #i))
  )
  (close #fp)  ;// ﾌｧｲﾙｸﾛｰｽﾞ
	(princ "\nread-line数")(princ #i)
	(princ)
);

;<HOM>*************************************************************************
; <関数名>    : C:GCG
; <処理概要>  : 図面上のC_CG有無を調べる
; <戻り値>    : 
;*************************************************************************>MOH<
(defun C:GCG ( / #EN #I #SS #SYM #XD$ #HIN #ID #LR #XD_LSYM$)

  (setq #en (car (entsel)))

  (if (= #en nil)
    (progn
      (CFAlertErr "部材が選択されませんでした")(quit)
    )
    (progn
      (setq #sym (SearchGroupSym #en)) ; ｼﾝﾎﾞﾙ図形名
			(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
			(setq #id  (nth 0 #xd_LSYM$));図形ID
			(setq #hin (nth 5 #xd_LSYM$));品番
			(setq #LR  (nth 6 #xd_LSYM$));LR

			(princ "\n図形ID: ")(princ #id)
			(princ "\n品番  : ")(princ #hin)
			(princ "\nLR    : ")(princ #LR)

		  (setq #ss (CFGetSameGroupSS #sym));ｸﾞﾙｰﾌﾟ図形
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
; <関数名>    : C:SHOWXD
; <処理概要>  : 図面上のC_CG有無を調べる
; <戻り値>    : 
;*************************************************************************>MOH<
(defun C:SHOWXD (
	/
	#EN #XD$$
	)

  (setq #en (car (entsel)))

  (if (= #en nil)
    (progn
      (CFAlertErr "部材が選択されませんでした")(quit)
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
; テキストに出力
;*************************************************************************>MOH<
(defun writetxt (
  &str ;文字列
  &txt ;ファイル名
  /
  #FIL #OFILE
  )
  (if CG_LOG
    (progn
      (setq #ofile &txt) ;出力ﾌｧｲﾙ名
      (setq #fil (open #ofile "A" ));追加モード

      (princ &str #fil);文字列出力
      (princ "\n" #fil)
      (if #fil (close #fil))
    )
  );_if

;	(startapp "notepad.exe" #ofile)
  (princ)
);writetxt



;;;<HOM>*************************************************************************
;;; <関数名>    : C:SINK_CHECK
;;; <処理概要>  : [WTシンク].シンク記号を「正」として各テーブルのシンク記号をチェック
;;; <作成>      : 2015/06/26 YM
;;; <備考>      :
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
						;存在しないシンク記号を出力
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
			  ;// 文字列をﾃﾞﾐﾘﾀで区切る
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



	(setq #fil (open (strcat CG_SYSPATH "LOG\\SINK記号不整合CHECK_" CG_SeriesDB ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み

  (princ "\n--- SINK記号不整合ﾁｪｯｸ(C:SINK_CHECK) ---" #fil)
  (princ "\n" #fil)
  (princ "\n")
	
  (setq #DBNAME "WTシンク")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select シンク記号 from " #DBNAME)))
	(setq #sink$ (mapcar 'car #rec$$));「正」とするシンク記号のﾘｽﾄ



	
  (princ "\n＜＜＜　[WTシンク]に存在しないSINK記号一覧　＞＞＞" #fil)

  (setq #DBNAME "天板価格")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select シンク記号 from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));「正」とするシンク記号のﾘｽﾄ
	(setq #check$ (##UNIQUE #check$))
	(##CHECK)

  (setq #DBNAME "OP置換シンク")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select シンク記号 from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));「正」とするシンク記号のﾘｽﾄ
	(setq #check$ (##UNIQUE #check$))
	(##CHECK)

  (setq #DBNAME "プラ管理")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select シンク記号 from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));「正」とするシンク記号のﾘｽﾄ
	(setq #check$ (##UNIQUE #check$))
	(##CHECK)

  (setq #DBNAME "規格天板脇寸法")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select シンク記号 from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));「正」とするシンク記号のﾘｽﾄ
	(setq #check$ (##UNIQUE #check$))
	(##CHECK)

  (setq #DBNAME "水栓位置")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select シンク記号 from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));「正」とするシンク記号のﾘｽﾄ
	(setq #check$ (##UNIQUE #check$))
	(##CHECK)




  (setq #DBNAME "SINKCAB管理")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select シンク from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));「正」とするシンク記号のﾘｽﾄ
	(##GASSAN)
	(##CHECK)


  (setq #DBNAME "SINK奥行管理")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select シンク from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));「正」とするシンク記号のﾘｽﾄ
	(##GASSAN)
	(##CHECK)


  (setq #DBNAME "SINK材質管理")
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select シンク from " #DBNAME)))
	(setq #check$ (mapcar 'car #rec$$));「正」とするシンク記号のﾘｽﾄ
	(##GASSAN)
	(##CHECK)


  (princ "\n" #fil)
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n" #fil)

  (princ (strcat "\n★★★ シンク記号不整合ﾁｪｯｸ終了 ★★★") #fil)
  (princ "\n" #fil)
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\SINK記号不整合CHECK_" CG_SeriesDB ".txt"))
  (princ)
);C:KAISOCHECK


;;;<HOM>*************************************************************************
;;; <関数名>     : C:KAISO
;;; <処理概要>   : 品番を入力　階層のどこにあるか？
;;; <戻り値>     : なし
;;; <作成>       : 2016/06/30 YM
;;; <備考>       : 
;;;*************************************************************************>MOH<
(defun KAISO (
  /
	#DBSESSION #HINBAN #KOSU #QRY$ #QRY$$
  )

	(princ "\n")
	(setq #hinban (getstring "\n機種名を入力(機種名の一部でもOK): "))
	(princ "\n")
	(princ "\n")

	(setq #qry$$
	  (DBSqlAutoQuery CG_DBSESSION (strcat "select 上位階層ID from 階層 where 階層名称 like '%" #hinban "%'"))
	)
	(setq #qry$ (mapcar 'car #qry$$))
	(setq #qry$ (##DEL #qry$))

	(setq #kosu (length #qry$))
	(if (> #kosu 10)
		(progn
			(princ "\n対象機種名が10件を超えます")
			(quit)
		)
	)


;CG_CDBSESSION
;CG_DBSESSION

	(if (= #kosu 0)
		(princ "\n●機種名が階層に存在しません●")
		;else
		(MAIN #qry$)
	);_if

	(princ "\n")
	(princ)
);C:KAISO


;;;*************************************************************************>MOH<
;重複削除
(defun ##DEL (
	&lis$
  /
	
  )
	;重複削除
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

	(setq #tbl "階層")

			;------------------------------------------------------------------
			(defun GetKaisoName(  &ID / )


				(setq #qry$
				  (DBSqlAutoQuery CG_DBSESSION (strcat "select 上位階層ID,階層名称 from " #tbl " where 階層ID='" &ID "'"))
				)
				(if (= nil #qry$)
					nil
					;else
					(cadr (car #qry$)) ;階層名称
				);_if
			);GetKaisoName

			;------------------------------------------------------------------
			(defun GetUPKaisoID(  &ID / )
				(setq #qry$
				  (DBSqlAutoQuery CG_DBSESSION (strcat "select 上位階層ID,階層名称 from " #tbl " where 階層ID='" &ID "'"))
				)
				(if (= nil #qry$)
					nil
					;else
					(car  (car #qry$)) ;上位階層ID
				);_if
			);GetKaisoName
			;------------------------------------------------------------------

	(setq #NO_flg T);存在しない

	(princ "\n--- 「ﾌﾘｰﾌﾟﾗﾝ設計」場所は以下のとおり ---")

	(foreach #qry &qry$
		(setq #UPkaisoID #qry)
		(if (= "-" (substr #UPkaisoID 1 1))
			nil
			;else
			(progn
				(setq #flg T)
				(setq #tuika_flg nil);追加部材の場合T
				(setq #NO_flg nil);存在しない
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
				;出力
				(foreach #kaisoName #kaisoName$
					(princ "\n")(princ #kaisoName)(princ " - ")
				)
				(princ "\n-------------------------------")
			)
		);_if

	);foreach

	(if #NO_flg
		(princ "\n●機種名が階層に存在しません●")
	);_if

	(if #tuika_flg
		(princ "\n(追加部材)")
	);_if

);MAIN


(defun chgtoku( / #et)
  (setq #sym (car (entsel "ｼﾝﾎﾞﾙ基点を選択: ")))
	(setq #xd$ (CFGetXData #sym "G_TOKU"))

  (CFSetXData #sym "G_TOKU"
    (CFModList #xd$
      (list (list 12 150.0))
    )
  )
  (princ)
)

;;;<HOM>*************************************************************************
;;; <関数名>    : c:oya
;;; <処理概要>  : 選択した図形の親図形情報を表示     @YM@ コマンドチェック用
;;; <作成>      : 00/02/11 修正 YM
;;;*************************************************************************>MOH<
(defun c:oya(
  /
  #en #ET #ET2 #J #I #K #NAME #NAME1 #NAME2 #XD #XD2 #XD_LSYM #XD_SYM
#DRID #HINBAN #LR #QRY$$
  )
  (setq #en (car (entsel)))

  (if (= #en nil)
    (progn
      (CFAlertErr "部材が選択されませんでした")(quit)
    )
    (progn
      (setq #en (SearchGroupSym #en)) ; ｼﾝﾎﾞﾙ図形名
    )
  )

  (if (= #en nil)
    (progn
      (CFAlertErr "\"G_LSYM\"がありません")(quit)
    )
    (progn
      (setq #et (entget #en))

      (setq #i 0) ; 図形情報
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
            ":G_LSYM ｼﾝﾎﾞﾙ基準点                       ";0
            ":本体図形ID    :10ﾊﾞｲﾄ(dwgﾌｧｲﾙ名)         ";1
            ":挿入点        :配置基点 x,y,z            ";2
            ":回転角度      :ﾗｼﾞｱﾝ                     ";3
            ":工種記号      :2ﾊﾞｲﾄ                     ";4
            ":ｼﾘｰｽﾞ記号     :2ﾊﾞｲﾄ                     ";5
            ":品番名称      :20ﾊﾞｲﾄ                    ";6
            ":L/R区分       :Z,L,R                     ";7
            ":扉図形ID      :10ﾊﾞｲﾄ                    ";8
            ":扉開き図形ID  :10ﾊﾞｲﾄ                    ";9
            ":性格ｺｰﾄﾞ      :品番情報の性格ｺｰﾄﾞ        ";10
            ":複合ﾌﾗｸﾞ      :0(単独),1(複合),2(OP部材) ";11
            ":配置順番号    :配置順番号(1～)           ";12
            ":用途番号      :0～99                     ";13
            ":寸法Ｈ        :品番図形DBの登録H寸法値   ";14
            ":断面指示有無  :0(なし),1(あり)           ";15
            ":分類          :キッチン(A) or 収納(D)    ";16
     ))

     (setq #name2 (list
            ":G_SYM                                    "
            ":ｼﾝﾎﾞﾙ名称                                "
            ":ｺﾒﾝﾄ１                                   "
            ":ｺﾒﾝﾄ２                                   "
            ":ｼﾝﾎﾞﾙ基準値W                             "
            ":ｼﾝﾎﾞﾙ基準値D                             "
            ":ｼﾝﾎﾞﾙ基準値H                             "
            ":ｼﾝﾎﾞﾙ取付高さ                            "
            ":入力方法                                 "
            ":W方向ﾌﾗｸﾞ                                "
            ":D方向ﾌﾗｸﾞ                                "
            ":H方向ﾌﾗｸﾞ                                "
            ":伸縮ﾌﾗｸﾞW                                "
            ":伸縮ﾌﾗｸﾞD                                "
            ":伸縮ﾌﾗｸﾞH                                "
            ":ﾌﾞﾚｰｸﾗｲﾝ数W                              "
            ":ﾌﾞﾚｰｸﾗｲﾝ数D                              "
            ":ﾌﾞﾚｰｸﾗｲﾝ数H                              "
     ))

      (setq #j 0) ; 拡張データ"G_LSYM"
      (repeat (length #xd_LSYM)
        (setq #xd2 (nth #j #xd_LSYM))
        (princ "\n[")(princ (1- #j))(princ "]")(princ (nth #j #name1))(princ #xd2)
        (setq #j (1+ #j))
      )
      (princ "\n -----------------------------------------------------------------" )
      (setq #j 0) ; 拡張データ"G_SYM"
      (repeat (length #xd_SYM)
        (setq #xd2 (nth #j #xd_SYM))
        (princ "\n[")(princ (1- #j))(princ "]")(princ (nth #j #name2))(princ #xd2)
        (setq #j (1+ #j))
      )
      (princ "\n -----------------------------------------------------------------" )
      (princ)
    )
  );_if



	(setq #hinban (cdr (nth 6 #xd_LSYM)));品番
	(setq #LR     (cdr (nth 7 #xd_LSYM)));LR


	;2018/07/12 YM ADD-S

	;＜＜＜　品番図形　＞＞＞
  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION "品番図形"
      (list
        (list "品番名称"  #hinban 'STR)
        (list "LR区分"    #LR 'STR)
      )
    )
  )
  (if (= nil #qry$$)
		(princ "\n品番図形　なし")
		;else
		(progn

			(princ "\n品番図形.寸法W  =")(princ (nth 3 (car #qry$$)))
			(princ "\n品番図形.寸法D  =")(princ (nth 4 (car #qry$$)))
			(princ "\n品番図形.寸法H  =")(princ (nth 5 (car #qry$$)))
			(princ "\n -----------------------------------------------------------------" )			
		)
	);_if
	;2018/07/12 YM ADD-E

  (setq #hinban (cdr (nth 6 #xd_LSYM)));品番
  (setq #LR     (cdr (nth 7 #xd_LSYM)));LR

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION "品番シリ"
      (list
        (list "品番名称"    #hinban       'STR)
        (list "LR区分"      #LR           'STR)
        (list "扉シリ記号"  CG_DRSeriCode 'STR)
        (list "引手記号"    CG_HIKITE     'STR)
      )
    )
  )
  (if (= nil #qry$$)
    (setq #drid "なし")
    ;else
    (progn
      (if (= nil (nth 4 (car #qry$$)))
        (setq #drid "なし")
        ;else
        (setq #drid (strcat "DR" (nth 4 (car #qry$$))))
      );_if
    )
  );_if

	(princ "\n図形ID= ")(princ (cdr (nth 1 #xd_LSYM)))
	(princ "\n機種名= ")(princ (cdr (nth 6 #xd_LSYM)))
	(princ "\n   L/R= ")(princ (cdr (nth 7 #xd_LSYM)))
	(princ "\n扉図ID= ")(princ  #drid)

  (princ "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n")
  (princ "\n戻り値: \n" )
  (if #en #en nil )

);_(defun c:oya()


;;;<HOM>*************************************************************************
;;; <関数名>    : C:ZukeiCheck
;;; <処理概要>  : 図面上の図形の情報をテキスト出力　SOLIDのXdataに矛盾がないかチェック
;;; <作成>      : 2015/06/09 YM ADD
;;;*************************************************************************>MOH<
(defun C:ZukeiCheck(
	/
	#ANA #ANA_HANDLE #ANA_KOSU #DATE_TIME #DN #FIL #I #J #NAME_ANA #NAME_BODY
	#NAME_PRIM #SOLID #XD_ANA$ #XD_BODY$ #XD_PRIM$
	)

	; ﾌｧｲﾙOPEN
  (setq #fil (open (strcat CG_SYSPATH "all.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
	(princ #date_time #fil) ; 日付書き込み
	(princ "\n" #fil)

 	(setq #name_PRIM
		(list
      ":タイプ(1=厚領域 2=線識面 3=単一面)       ";1
      ":回転基準軸番号(1,2,3,4) ==>[軸変更]      ";2
      ":穴データ数(0:固定? 使ってない?)          ";3
      ":単一面種別(0=透明 1=不透明(type=単一面時)";4
      ":任意属性１                               ";5
      ":任意属性２                               ";6
      ":★取付け高さ                             ";7
      ":★要素厚み                               ";8
      ":★傾斜角度                               ";9
      ":テーパ角度                               ";10
      ":★底面図形ハンドル                      ";11
      ":？？？                                  ";12
      ":？？？                                  ";13
      ":？？？                                  ";14
      ":？？？                                  ";15
	))

 	(setq #name_BODY
 		(list
      ":タイプ(1=底面 2=上面)                    ";1
      ":穴データ数                               ";2
      ":穴図形ハンドル1                          ";3
      ":穴図形ハンドル2                          ";4
      ":穴図形ハンドル3                          ";5
      ":穴図形ハンドル4                          ";6
      ":穴図形ハンドル5                          ";7
      ":？？？                                   ";8
      ":？？？                                   ";9
      ":？？？                                   ";10
	))

 	(setq #name_ANA
 		(list
      ":穴形状タイプ(1=通常穴 2=傾斜穴)          ";1
      ":穴タイプ(0=貫通 1=底面貫き 2=上面貫き)   ";2
      ":穴深さ                                   ";3
      ":テーパ角度                               ";4
      ":？？？                                   ";5
      ":？？？                                   ";6
      ":？？？                                   ";7
	))

  (setq #SOLID (car (entsel "\nSOLID図形を選択: ")))

  (setq #xd_PRIM$ (CFGetXData #SOLID "G_PRIM"))  ;ﾌﾟﾘﾐﾃｨﾌﾞ図形

	(if #xd_PRIM$
		(progn
			(princ "\n<G_PRIM>" #fil)
      (setq #j 0) ; 拡張データ"G_PRIM"項目数
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
			(CFAlertMsg "G_PRIMがありません")
			(quit)
		)
	);_if

;;;  (setq #dn  (handent (nth 10 #xd_PRIM$)))       ;底面領域図形 G_BODY
  (setq #dn  (nth 10 #xd_PRIM$))       ;底面領域図形 G_BODY

	(if (= (type #dn) 'ENAME)
		(progn
  		(setq #xd_BODY$ (CFGetXData #dn "G_BODY"))
		)
		(progn
			(CFAlertMsg "底面図形ﾊﾝﾄﾞﾙがおかしい.")
			(quit)
		)
	);_if

	(if #xd_BODY$
		(progn
			(princ "\n<G_BODY>" #fil)
      (setq #j 0) ; 拡張データ"G_BODY"項目数
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
			(CFAlertMsg "G_BODYがありません")
			(quit)
		)
	);_if

  (setq #ANA_kosu (nth 1 #xd_BODY$))             ;底面領域図形 G_BODY
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
				(CFAlertMsg "穴底面図形ﾊﾝﾄﾞﾙがおかしい.")
				(quit)
			)
		);_if

		(if #xd_ANA$
			(progn
				(princ "\n<G_ANA>" #fil)
	      (setq #j 0) ; 拡張データ"G_ANA"項目数
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
				(CFAlertMsg "G_ANAがありません")
				(quit)
			)
		);_if

		(setq #i (1+ #i))
	);repeat


  (if #fil
    (progn
      (close #fil)
      (princ "\nﾌｧｲﾙに書き込みました.")
			(startapp "notepad.exe" (strcat CG_SYSPATH "all.txt"))
    )
  );_if
  (princ)
);C:ZukeiCheck



;;;<HOM>*************************************************************************
;;; <関数名>    : C:ADDCOM01
;;; <処理概要>  : 
;;; <戻り値>    : なし
;;; <作成>      : 2015/01/30 YM
;;; <備考>      : OEM版追加用
;;;*************************************************************************>MOH<
(defun C:ADDCOM01 (
  /
  )
  ;// コマンドの初期化
	(C:arxStartApp (strcat CG_SysPATH "version.exe") 0)
	(princ)
);C:ADDCOM01

;;;<HOM>*************************************************************************
;;; <関数名>    : C:ADDCOM02
;;; <処理概要>  : 
;;; <戻り値>    : なし
;;; <作成>      : 2015/01/30 YM
;;; <備考>      : OEM版追加用
;;;*************************************************************************>MOH<
(defun C:ADDCOM02 (
  /
  )
  ;// コマンドの初期化
  (StartUndoErr)
	(KAISO)
	(princ)
);C:ADDCOM02

;;;<HOM>*************************************************************************
;;; <関数名>    : C:ADDCOM03
;;; <処理概要>  : 
;;; <戻り値>    : なし
;;; <作成>      : 2015/01/30 YM
;;; <備考>      : OEM版追加用
;;;*************************************************************************>MOH<
(defun C:ADDCOM03 (
  /
  )
  ;// コマンドの初期化
  (StartUndoErr)
	(c:CG_Info_TOOL)
	(princ)
);C:ADDCOM03

;;;<HOM>*************************************************************************
;;; <関数名>    : C:ADDCOM04
;;; <処理概要>  : 
;;; <戻り値>    : なし
;;; <作成>      : 2015/01/30 YM
;;; <備考>      : OEM版追加用
;;;*************************************************************************>MOH<
(defun C:ADDCOM04 (
  /
  )
	;2016/11/11 YM ADD
  (C:newAutoPut)
	(princ)
);C:ADDCOM04

;;;<HOM>*************************************************************************
;;; <関数名>    : C:ADDCOM05
;;; <処理概要>  : 
;;; <戻り値>    : なし
;;; <作成>      : 2015/01/30 YM
;;; <備考>      : OEM版追加用
;;;*************************************************************************>MOH<
(defun C:ADDCOM05 (
  /
  )
	;2016/11/11 YM ADD
  (C:newAutoPutC)
	(princ)
);C:ADDCOM05

;;;<HOM>*************************************************************************
;;; <関数名>    : C:ADDCOM06
;;; <処理概要>  : 
;;; <戻り値>    : なし
;;; <作成>      : 2015/01/30 YM
;;; <備考>      : OEM版追加用
;;;*************************************************************************>MOH<
(defun C:ADDCOM06 (
  /
  )
  ;// コマンドの初期化
  (StartUndoErr)

	(princ "\n  ★　acet-str-find を実行")
	(setq #ret (acet-str-find "HHA[^T][0-9]+[-][A|K].*" "HHAS030-A" nil T)) ;I型横フレーム
	(princ "\n  成功なら戻り値＝１となるはず")
	(princ #ret)
	(princ "\n")


	(princ "\n  ★★★　acet-list-remove-nth を実行")
	(setq #ret2 (acet-list-remove-nth 3 '(0 1 2 3 3 4 5)))
	(princ "\n  成功なら戻り値＝(0 1 2 3 4 5)となるはず")
	(princ #ret2)
	(princ "\n")

	
	(princ "\n  ★★　acet-list-put-nth を実行")
	(setq #ret1 (acet-list-put-nth 3 '(0 1 2 9999 4 5)  3))
	(princ "\n  成功なら戻り値＝(0 1 2 3 4 5)となるはず")
	(princ #ret1)
	(princ "\n")

;2017/07/18 YM ADD-S ﾌﾚｰﾑｷｯﾁﾝ対応
;金具自動計算
(OutputKanaguInfo)
;2017/07/18 YM ADD-E ﾌﾚｰﾑｷｯﾁﾝ対応


	(princ "\n --- end ---")
	(princ)
);C:ADDCOM06

;;;<HOM>*************************************************************************
;;; <関数名>    : C:ADDCOM07
;;; <処理概要>  : ＧＳＭ図形の拡張データ情報の整合性が取れているかチェック
;;; <戻り値>    : なし
;;; <作成>      : 2015/01/30 YM
;;; <備考>      : OEM版追加用
;;;*************************************************************************>MOH<
(defun C:ADDCOM07 (
  /
  )
  ;// コマンドの初期化
  (StartUndoErr)
	(princ "\nHello World!")
	(princ)
);C:ADDCOM07

;;;<HOM>*************************************************************************
;;; <関数名>    : C:ADDCOM08
;;; <処理概要>  : 
;;; <戻り値>    : なし
;;; <作成>      : 2015/01/30 YM
;;; <備考>      : OEM版追加用
;;;*************************************************************************>MOH<
(defun C:ADDCOM08 (
  /
  )
  ;// コマンドの初期化
  (StartUndoErr)
	(princ "\nHello World!")
	(princ)
);C:ADDCOM08

;;;<HOM>*************************************************************************
;;; <関数名>    : C:ADDCOM09
;;; <処理概要>  : 
;;; <戻り値>    : なし
;;; <作成>      : 2015/01/30 YM
;;; <備考>      : OEM版追加用
;;;*************************************************************************>MOH<
(defun C:ADDCOM09 (
  /
  )
  ;// コマンドの初期化
  (StartUndoErr)
	(princ "\nHello World!")
	(princ)
);C:ADDCOM09

;;;<HOM>*************************************************************************
;;; <関数名>    : C:ADDCOM10
;;; <処理概要>  : 
;;; <戻り値>    : なし
;;; <作成>      : 2015/01/30 YM
;;; <備考>      : OEM版追加用
;;;*************************************************************************>MOH<
(defun C:ADDCOM10 (
  /
  )
  ;// コマンドの初期化
  (StartUndoErr)
	(princ "\nHello World!")
	(princ)
);C:ADDCOM10

(princ)

