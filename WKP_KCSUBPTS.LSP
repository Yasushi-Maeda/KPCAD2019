(setq CG_SUBPARTS "HOSOKU")   ; 補足部材用拡張レコードのキー名

(defun C:SubParts () (SKH_HosokuBuzai))

;<HOM>*************************************************************************
; <関数名>     : SKH_HosokuBuzaiCnvList1
; <処理概要>   : 補足部材 レコードデータ 変換(二重→単一)
; <戻り値>     : 単一リスト
; <作成>       : 1999-11-25  山田
; <備考>       :
;*************************************************************************>MOH<
(defun SKH_HosokuBuzaiCnvList1 (
    &lst$$    ; 二重リスト
    /
    #Result$
    #nn$
  )
  (setq #Result$ nil)
  (foreach #nn$ &lst$$
    (setq #Result$ (append #Result$ #nn$))
  )
  #Result$
)

;<HOM>*************************************************************************
; <関数名>     : SKH_HosokuBuzaiCnvList2
; <処理概要>   : 補足部材 レコードデータ 変換(単一→二重)
; <戻り値>     : 二重リスト
; <作成>       : 1999-11-25  山田
; <備考>       :
;*************************************************************************>MOH<
(defun SKH_HosokuBuzaiCnvList2 (
    &lst$   ; 単一リスト
    /
    #Result$$
    #nn$
    #Len
    #i
  )
  (setq #Result$$ nil)
  (setq #Len (length &lst$))
  (setq #i 0)
  (while (< #i #Len)
    (setq #nn$ (list (nth #i &lst$) (nth (+ #i 1) &lst$)))
    (setq #Result$$ (append #Result$$ (list #nn$)))
    (setq #i (+ #i 2))
  )
  #Result$$
)

;<HOM>*************************************************************************
; <関数名>     : SKH_HosokuBuzai
; <処理概要>   : 補足部材 入力・確認
; <戻り値>     :
; <作成>       : 1999-11-25  山田 (1999-12-08 ダイアログ DLL化により修正)
; <備考>       :
;*************************************************************************>MOH<
(defun SKH_HosokuBuzai (
    /
    #XRecord$$
    #nn$
    #s #ss #name #value
    #f
    #i
    #loop
  )

	; 01/09/03 YM ADD-S UNDO処理追加
	; 前処理
	(StartUndoErr)
	; 01/09/03 YM ADD-E UNDO処理追加

;;;01/09/03YM@MOD  (StartCmnErr)

  (setq #XRecord$$ (SKH_HosokuBuzaiCnvList2 (CFGetXRecord CG_SUBPARTS)))
  (setq #f (open ".\XRecord.cfg" "w"))
  (if (/= nil #f)
    (progn
      (write-line ";-----------------------------------------------------------------------" #f)
      (write-line "; 補足部材 拡張レコード" #f)
      (write-line ";" #f)
      (write-line "; <品番>=<個数>" #f)
      (write-line ";-----------------------------------------------------------------------" #f)
      (foreach #nn$ #XRecord$$
        (setq #s (strcat (nth 0 #nn$) "=" (nth 1 #nn$)))
        (write-line #s #f)
      )
      (close #f)
    )
  )

  ;00/10/10 HN E-MOD モジュール呼び出し方法変更
  ;@@@(C:arxStartApp (strcat CG_SysPATH "HOSOKU.EXE") 1)
  (C:arxStartApp (strcat CG_SysPATH "PLAN.EXE 3") 0)
  ;00/10/10 HN E-MOD モジュール呼び出し方法変更

  (setq #f (open ".\XRecord.cfg" "r"))
  (if (/= nil #f)
    (progn
      (setq #XRecord$$ nil)
      (setq #loop T)
      (while #loop
        (setq #s (read-line #f))
        (if (= nil #s) (setq #loop nil)
          (if (wcmatch #s "?*=?*")
            (progn
              (setq #i 2)
              (while (<= #i (strlen #s))
                (setq #name nil #value nil)
                (setq #ss (substr #s #i 1))
                (if (= #ss "=")
                  (progn
                    (setq #name (substr #s 1 (1- #i)))
                    (setq #value (substr #s (1+ #i) (strlen #s)))
                  )
                  (setq #i (1+ #i))
                )
                (if (and (/= #name nil) (/= #value nil))
                  (setq #i (1+ (strlen #s)))
                )
              )
              (setq #XRecord$$ (append #XRecord$$ (list (list #name #value))))
            )
          )
        )
      )
    )
    (close #f)
  )

  (CFSetXRecord CG_SUBPARTS (SKH_HosokuBuzaiCnvList1 #XRecord$$))

	; 01/09/03 YM ADD-S UNDO処理追加
	; 後処理
  (setq *error* nil)
	; 01/09/03 YM ADD-E UNDO処理追加

  (princ)
)

(princ)
