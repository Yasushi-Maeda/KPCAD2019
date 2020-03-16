;;;<HOM>*************************************************************************
;;; <関数名>    : CFOutStateLog
;;; <処理概要>  : ﾛｸﾞﾌｧｲﾙに処理内容を出力する
;;; <戻り値>    : なし
;;; <作成>      : 1998-06-16
;;; <備考>      : 本ﾌﾟﾛｸﾞﾗﾑは全て自己処理のため、異常終了したときの原因究明用に、
;;;               各処理のﾛｸﾞをﾌｧｲﾙにまとめます。
;;;               引数 msg の形式は princ で出力される形式でよい
;;; <ｸﾞﾛｰﾊﾞﾙ>   : ﾛｸﾞﾌｧｲﾙ名   =  CG_LOGFILE
;;; CG_DEBUG=1 のときﾛｸﾞを書き込む
;;;*************************************************************************>MOH<
(defun CFOutStateLog (
  &state  ; (INT)  正常、異常、警告ﾌﾗｸﾞ（0:異常 1:正常 2:警告）
  &def    ; (INT)  処理概要ﾌﾗｸﾞ
  &msg    ; (???)  メッセージ
  /
  #f
#LOGFILE #MOJI ; 02/09/03 YM ADD
  )
  ;(princ "\n")
  ;(princ &msg)
	(if (or (= &state nil)(= &def nil)(= &msg nil)) ; 01/02/12 YM ADD
		(princ)
		(progn
			(if (= CG_DEBUG 1) ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞ=1のとき出力
				(progn

		      ;; ﾛｸﾞﾌｧｲﾙ名 #logfile
					(setq #moji (strlen CG_logfile))
					(setq #logfile (strcat (substr CG_LOGFILE 1 (- #moji 4)) "2.log"))

				  (if (and (= &state 0) (/= 'LIST (type &msg)))
				    (progn
				      (setq CG_ERRMSG (append CG_ERRMSG (list &msg)))
				    )
				  );_(if

				  (if
				    (and
				      (or (= 0 &state) (= 1 &state) (= 2 &state))
				      (= 'INT (type &def))
				    )
				    (progn
		;;;         (setq #f (open CG_LOGFILE "a")) ; "A" 追加モード  00/02/09 @YM@ MOD
		;;;		      (setq #f (open (strcat CG_LOGFILE "2") "a")) ; "A" 追加モード
				      (setq #f (open #logfile "a")) ; "A" 追加モード 00/02/17 YM MOD

				      (princ (itoa &state) #f)
				      (princ ":" #f)
				      (princ (itoa &def) #f)
				      (princ ":" #f)
				      (princ &msg #f)
				      (princ "\n" #f)
				      (close #f)
				    )
				  );_(if

				);_(progn
			);_(if (= CG_DEBUG 1)
		)
	);_if
  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : CFOutLog
; <処理概要>  : ﾛｸﾞﾌｧｲﾙに処理内容を出力する（お客様用）
; <戻り値>    : なし
; <作成>      : 1999-04-13
; <備考>      : 本ﾌﾟﾛｸﾞﾗﾑは全て自己処理のため、異常終了したときの原因究明用に、
;               各処理のﾛｸﾞをﾌｧｲﾙにまとめます。
;               引数 msg の形式は princ で出力される形式でよい
; <ｸﾞﾛｰﾊﾞﾙ>   :
;*************************************************************************>MOH<
(defun CFOutLog (
  &state  ; (INT)  正常、異常、警告ﾌﾗｸﾞ（0:異常 1:正常 2:警告）
  &def    ; (INT)  段落（0:見出し0 1:見出し１ 2:見出し２ 3:見出し３ nil:本文）
  &msg    ; (???)  メッセージ
  /
  #m0 #m1 #m2 #m3 #s2 #s3 #s4 #f
  )
	; ﾛｸﾞのﾊﾟｽが通ってないときは警告表示＆くても継続実行する
	(setq #f (open CG_LOGFILE "a")) ; 01/10/03 YM

	(if #f ; 01/10/03 YM
		; ﾛｸﾞのﾊﾟｽが通っている
		(if (or (= &state nil)(= &msg nil)) ; 01/02/12 YM ADD
			(princ)
			(progn
			  (setq #m0 "///////////////////////////////////////////////////////////////////")   ;見出し０
			  (setq #m1 "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")   ;見出し１
			  (setq #m2 "==================================")   ;見出し２
			  (setq #m3 "----------------------------------")   ;見出し３
			  (setq #s2 "    ")                         ;インデント（見出し２）
			  (setq #s3 "        ")                     ;インデント（見出し３）
			  (setq #s4 "        |  ")                  ;インデント（本文）
			  (if
			    (and
			      (or (= 0 &state) (= 1 &state) (= 2 &state))
			      (or (= nil &def) (= 'INT (type &def)))
			    )
			    (progn
			      (princ "\n")
			      (princ &msg)
	;;; 		      (setq #f (open CG_LOGFILE "a")) ; 01/10/03 YM 上に移動
			      (cond
			        ((and (= 0 &state) (= nil &def))
			          ;// エラーログ出力用文字列に追加する
			          (setq CG_ERRMSG (append CG_ERRMSG (list &msg)))
			        )
			        ((and (= 0 &state) (/= nil &def))
			          (princ (itoa &state) #f)
			          (princ ":★ERROR:" #f)
			          (princ &msg #f)
			          (princ "\n" #f)
			        )
			        ((= 0 &def)
			          ;１行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #m0 #f)
			          (princ "\n" #f)
			          ;２行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ &msg #f)
			          (princ "\n" #f)
			          ;３行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #m0 #f)
			          (princ "\n" #f)
			        )
			        ((= 1 &def)
			          ;１行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #m1 #f)
			          (princ "\n" #f)
			          ;２行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ &msg #f)
			          (princ "      " #f)
			          (princ (menucmd "M=$(edtime, $(getvar,date),YYYY年 M月 D日 DDDD - H:MM:SSam/pm)") #f)
			          (princ "\n" #f)
			          ;３行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #m1 #f)
			          (princ "\n" #f)
			        )
			        ((= 2 &def)
			          ;１行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s2 #f)
			          (princ #m2 #f)
			          (princ "\n" #f)
			          ;２行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s2 #f)
			          (princ &msg #f)
			          (princ "\n" #f)
			          ;３行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s2 #f)
			          (princ #m2 #f)
			          (princ "\n" #f)
			        )
			        ((= 3 &def)
			          ;１行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s3 #f)
			          (princ #m3 #f)
			          (princ "\n" #f)
			          ;２行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s3 #f)
			          (princ &msg #f)
			          (princ "\n" #f)
			          ;３行目
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s3 #f)
			          (princ #m3 #f)
			          (princ "\n" #f)
			        )
			        ((= nil &def)
			          (princ (itoa &state) #f)
			          (princ ":" #f)
			          (princ #s4 #f)
			          (princ &msg #f)
			          (princ "\n" #f)
			        )
			      )
			      (close #f)
			    )
			  );_if

			)
		);_if
		(progn ; 01/10/03 YM ADD
			(if (= nil CG_NO_LOGPATH)
				(if (= CG_AUTOMODE 0)
					(CFAlertErr (strcat "ﾛｸﾞﾌｧｲﾙのﾊﾟｽが通ってないため、ﾛｸﾞを出力できません。(iniﾌｧｲﾙをご確認下さい)"
															"\n実行上問題はないので処理を継続します。"))
				; else
					(princ (strcat "ﾛｸﾞﾌｧｲﾙのﾊﾟｽが通ってないため、ﾛｸﾞを出力できません。(iniﾌｧｲﾙをご確認下さい)"
															"\n実行上問題はないので処理を継続します。"))
				);_if
			; else
				(setq CG_NO_LOGPATH T) ; ﾛｸﾞﾌｧｲﾙのﾊﾟｽが通ってないとTを入力する
			);_if
		)
	);_if  ; 01/10/03 YM
  (princ)
)

(princ)

