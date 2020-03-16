
(defun *error* (msg)
  (princ "@@@ error: ")
  (princ msg)
 (princ)
)

;;;(defun my_err(s)
;;;  (prompt "\nERROR: mycmd failed or was cancelled")
;;;  (setvar "clayer" old_clayer)
;;;  (command-s "._undo" "_e")
;;;  (setq *error* mv_oer)
;;;)

(defun c:mycmd ()

  (setq old_clayer (getvar "clayer"));現在画層を格納

;;;  (setq old_err *error* ;エラー関数を一旦他の名前にする
;;;        *error* my_err
;;;        old_clayer (getvar "clayer")
;;;  )

  (setq insPt (getpoint "\nSpecify text insertion: "))

  (if (/= insPt nil)
    (progn

			;画層を変更する
		  (setvar "clayer" "0");2020/02/14 ADD

      (command-s "._undo" "_be")
      (command-s "._-layer" "_m" "Text" "_C" "3" "" "")
      (command-s "._-text" insPt000 "" "0" "Sample Text")
      (command-s "._undo" "_e")

;;;      (command "._undo" "_be")
;;;      (command "._-layer" "_m" "Text" "_C" "3" "" "")
;;;      (command "._-text" insPt000 "" "0" "Sample Text")
;;;      (command "._undo" "_e")

;;;      (command-s "._undo" "_be")
;;;      (command-s "._-layer" "_m" "Text" "_C" "3" "" "")
;;;      (command-s "._-text" insPt "" "0" "Sample Text")
;;;      (command-s "._undo" "_e")

    )
  )

  (setvar "clayer" old_clayer)
  (setq *error* mv_oer)
 (princ)
)

;command　関数を使って、変数をinsPt000にした場合

;;;コマンド:
;;;Specify text insertion: そのようなコマンド  "MYCMD" はありません。ヘルプを表示するには F1 キーを押してください。
;;;そのようなコマンド  "0" はありません。ヘルプを表示するには F1 キーを押してください。
;;;そのようなコマンド  "SAMPLE TEXT" はありません。ヘルプを表示するには F1 キーを押してください。
;;;＜エラー関数(defun my_err(s)に飛ばずに最後まで通る＞

;command-S　関数を使った場合
;;;＜エラー発生直後すぐにエラー関数(defun my_err(s)に飛ぶ＞

;エラー関数を何も指定しないと、通常は
;*error*　に飛ぶ msg = エラー: 不明な (command-s) の失敗。

;;;コマンド:
;;;コマンド:
;;;MYCMD
;;;
;;;Specify text insertion: アプリケーション エラー: コマンド入力で送ったタイプが無効です。
;;; エラー: 不明な (command-s) の失敗。





;; *pop-error-mode* 関数の使用例
 
(defun my_err (err_msg)
    (if (/= err_msg "Function cancelled")
      (prompt (strcat "\nError: " err_msg))
    )
    (command "._undo" "_e")
    (command "._U")
    (setq *error* olderr)
  (princ)
)
 
(defun myUtil (key / )
    (setq olderr *error*
          *error* my_err)
    (*push-error-using-command*)         ;; カスタム エラー ハンドラーのコマンド-s の代わりに command 関数の使用
    (command "._undo" "_group")          ;; このサンプルでは実行されませんが、エラー ハンドラーを設定するための良いフレームワーク。
    (/ 1 0)                              ;; コードを設定するときに、カスタム エラー handlerRemove をトリガーする不適切な値を持つ関数を呼び出す
 
    ;;; ここに何かの処理を実行。
 
    (command "._undo" "_e")
    (setq *error* olderr)                ; 古い *error* ハンドラーを復元
    (*pop-error-mode*)                   ; *pop-error-mode* を使用
)
