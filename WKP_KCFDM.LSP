;<HOM>*************************************************************************
; <関数名>    : C:SCFDanMen
; <処理概要>  : 断面指示／解除
; <戻り値>    : なし
; <作成>      : 1999/06/17 → 01/04/18 MH 全面書換
; <備考>      : なし
;*************************************************************************>MOH<
(defun C:SCFDanMen ( / #iColSet #iColCan #eBASE #eSYN #LXD$ #HD #HDL$)

  (SCFStartShori "SCFDanMen") ; 2000/09/08 HT ADD
  (StartUndoErr)

  (if (not CG_KENMEI_PATH) (progn 
    (CFAlertMsg "物件が呼び出されていません。") (command "_undo" "b") (exit)))
  (setq #iColSet 4)        ; 設定色
  (setq #iColCan "BYLAYER"); 解除色
  
  (setq #eBASE (CFGetBaseSymXRec)) ; 基準アイテム獲得
  (if #eBASE (ResetBaseSym)) ; 基準アイテムの色リセット
  
  (KcChk&SetAllDanmenXRec); Xrecord が存在しない図面であったら図面を走査して設定
  (setq #HDL$ (KcDelNoExistXRec "DANMENSYM")); Xrecord から図面に存在しないﾊﾝﾄﾞﾙ削除
  ; 図面中、断面指示されているアイテムを設定色に変色
  (foreach #HD #HDL$ 
    (command "_.chprop" (CFGetSameGroupSS (handent #HD)) "" "C" #iColSet ""))

  (setq #eSYN 'T)
  (while #eSYN
    (cond
      ((not (setq #eSYN (car (entsel "\nアイテムを選択：")))))
      ((or (not (setq #eSYN (CFSearchGroupSym #eSYN)))
           (not (setq #LXD$ (CfGetXData #eSYN "G_LSYM"))))
        (CFAlertMsg "\nアイテムではありません。")
        (setq #eSYN 'T)
      )
      ((= 1 (nth 14 #LXD$))
        (command "_.chprop" (CFGetSameGroupSS #eSYN) "" "C" #iColCan ""); 色変色
        (KcChgG_LSYMSecNo #eSYN 0); LSYMの断面指示値を変更
        (princ "\n断面指示を解除しました.")
      )
      ((= 0 (nth 14 #LXD$))
        (command "_.chprop" (CFGetSameGroupSS #eSYN) "" "C" #iColSet ""); 色変色
        (KcChgG_LSYMSecNo #eSYN 1); LSYMの断面指示値を変更
        (princ "\n断面指示を設定しました.")
      )
    ); cond
  ); while

  (setq #HDL$ (CFGetXRecord "DANMENSYM")) ; 変更後のXrecord 断面ON リスト取得
  ; 図面中、断面指示されているアイテムを設定色に変色
  (foreach #HD #HDL$ 
    (command "_.chprop" (CFGetSameGroupSS (handent #HD)) "" "C" #iColCan ""))

  (if #eBASE (GroupInSolidChgCol #eBASE CG_BaseSymCol)) ; 基準アイテムの色を戻す

  (SCFEndShori) ; 終了処理  2000/09/07 HT
  (princ)
); C:SCFDanMen

;;<HOM>*************************************************************************
; <関数名>    : KcChk&SetAllDanmenXRec
; <処理概要>  : 図面を走査して断面指示されている全アイテムをXrecordに取得
; <戻り値>    : なし
; <作成>      : 01/04/26 MH
; <備考>      : 
;*************************************************************************>MOH<
(defun KcChk&SetAllDanmenXRec ( 
  / 
  #SS #i #eSYN #iDan #HDL$
  )
  ; "DANMENSYM" が存在しない場合に実行
  ; 01/05/28 HN S-MOD 断面指示部材は都度検索するように変更
  ;@DEL@(if (not (CFGetXRecord "DANMENSYM"))(progn
    (setq #SS (ssget "X" (list (list -3 (list "G_LSYM")))))
    (if (and #SS (< 0 (sslength #SS))) (progn
      (setq #i 0)
      (repeat (sslength #SS)
        (setq #eSYN (ssname #SS #i))
        (setq #iDan (nth 14 (CfGetXData #eSYN "G_LSYM")))
        ; G_LSYMをもち、断面指示=1のアイテムのハンドルをリスト化
        (if (= 1 #iDan) (setq #HDL$ (cons (cdr (assoc 5 (entget #eSYN))) #HDL$)))
        (setq #i (1+ #i))
      );repeat
    )); if progn
    (CFSetXRecord "DANMENSYM" #HDL$)
  ;@DEL@)); if progn
  ; 01/05/28 HN E-MOD 断面指示部材は都度検索するように変更
  (princ)
) ; KcChk&SetAllDanmenXRec

;;010426MH;;<HOM>*************************************************************************
;;010426MH;; <関数名>    : SCFDanMenColChg
;;010426MH;; <処理概要>  : Xrecord参照して図面中、断面指示されているアイテムを指定色に変更
;;010426MH;; <戻り値>    : なし
;;010426MH;; <作成>      : 01/04/25 MH 書き換え
;;010426MH;; <備考>      : 
;;010426MH;;*************************************************************************>MOH<
;;010426MH;(defun SCFDanMenColChg ( 
;;010426MH;  &iCol ; 色番号
;;010426MH;  / 
;;010426MH;  #HD #HDL$ #eSYN
;;010426MH;  )
;;010426MH;  (setq #HDL$ (CFGetXRecord "DANMENSYM")) ; Xrecord 断面ON リスト取得
;;010426MH;  (foreach #HD #HDL$
;;010426MH;    (if (and (setq #eSYN (handent #HD)) (entget #eSYN))
;;010426MH;      (command "_.chprop" (CFGetSameGroupSS #eSYN) "" "C" &iCol "")
;;010426MH;    ); if
;;010426MH;  )
;;010426MH;  (princ)
;;010426MH;) ; SCFDanMenColChg

;;010425MH;;<HOM>*************************************************************************
;;010425MH; <関数名>    : SCFDanMenColChg
;;010425MH; <処理概要>  : 図面中で断面指示されているアイテムを指定の色に替える
;;010425MH; <戻り値>    : なし
;;010425MH; <作成>      : 01/04/18 MH 書き換え
;;010425MH; <備考>      : 
;;010425MH;*************************************************************************>MOH<
;;010425MH(defun SCFDanMenColChg ( 
;;010425MH  &iCol ; 色番号
;;010425MH  / 
;;010425MH  #SS #i #eSYN #iDan 
;;010425MH  )
;;010425MH  (setq #SS (ssget "X" (list (list -3 (list "G_LSYM")))))
;;010425MH  (if (and #SS (< 0 (sslength #SS))) (progn
;;010425MH    (setq #i 0)
;;010425MH    (repeat (sslength #SS)
;;010425MH      (setq #eSYN (ssname #SS #i))
;;010425MH      (setq #iDan (nth 14 (CfGetXData #eSYN "G_LSYM")))
;;010425MH      ; G_LSYMをもち、断面指示=1のアイテムのみ指定の色に変色
;;010425MH      (if (= 1 #iDan) (command "_.chprop" (CFGetSameGroupSS #eSYN) "" "C" &iCol ""))
;;010425MH      (setq #i (1+ #i))
;;010425MH    );repeat
;;010425MH  )); if progn
;;010425MH  (princ)
;;010425MH) ; SCFDanMenColChg

;;010419MH;<HOM>*************************************************************************
;;010419MH; <関数名>    : C:SCFDanMen
;;010419MH; <処理概要>  : 断面指示／解除
;;010419MH; <戻り値>    : なし
;;010419MH; <作成>      : 1999-06-17
;;010419MH; <備考>      : なし
;;010419MH;*************************************************************************>MOH<
;;010419MH(defun C:SCFDanMen (
;;010419MH  /
;;010419MH  #iColSet #iColCan #eBen #En$ #eEn #ps #ss #iI #eGen #Ex$
;;010419MH  #eSym #iDan #iCol #sMsg #Ex_n$ #eSYm
;;010419MH  )
;;010419MH
;;010419MH  (SCFStartShori "SCFDanMen")  ; 2000/09/08 HT ADD
;;010419MH  (StartUndoErr)
;;010419MH
;;010419MH  (if (/= nil CG_KENMEI_PATH)
;;010419MH    (progn
;;010419MH      (setq #ps (getvar "PICKSTYLE"))
;;010419MH      (setvar "PICKSTYLE" 3)
;;010419MH      ;色設定
;;010419MH      (setq #iColSet 4)   ; 設定
;;010419MH      (setq #iColCan 7)   ; 解除
;;010419MH      ;基準アイテム獲得
;;010419MH      (setq #eBen (CFGetBaseSymXRec))
;;010419MH      ;基準アイテムがある場合、元の色に戻す
;;010419MH      (if (/= nil #eBen)
;;010419MH        (ResetBaseSym)
;;010419MH      )
;;010419MH      (command "_-layer" "on" "n_symbol" "")
;;010419MH      (SCFDanMenColChg #iColSet)
;;010419MH      (setq #En$ T)
;;010419MH      (while #En$
;;010419MH        ;削除矢視選択
;;010419MH        ; 2000/07/17 HT 「設備」は使わない 「アイテム」を使う
;;010419MH        ; (setq #En$ (SKGetPtByEn "設備を選択してください." "3DSOLID" "設備" nil))
;;010419MH        (setq #En$ (SKGetPtByEn "アイテムを選択" "3DSOLID" "アイテム" nil))
;;010419MH        (if (/= nil #En$)
;;010419MH          (progn
;;010419MH            ;指定された図形のグループを獲得
;;010419MH            (setq #eEn (car (car #En$)))
;;010419MH            (command "_select" #eEn "")
;;010419MH            (setq #ss (ssget "P"))
;;010419MH
;;010419MH            ;シンボル図形獲得
;;010419MH            (setq #iI 0)
;;010419MH            (repeat (sslength #ss)
;;010419MH              (setq #eGen (ssname #ss #iI))
;;010419MH              (setq #Ex$ (CfGetXData #eGen "G_LSYM"))
;;010419MH              (if (/= nil #Ex$)
;;010419MH                (progn
;;010419MH                  (setq #eSym #eGen)
;;010419MH                  (setq #iDan (nth 14 #Ex$))
;;010419MH                )
;;010419MH              )
;;010419MH              (setq #iI (1+ #iI))
;;010419MH            )
;;010419MH            (command "_select" #eSym "")
;;010419MH            (setq #ss (ssget "P"))
;;010419MH
;;010419MH            (if (/= nil #iDan)
;;010419MH              (progn
;;010419MH                ;色、断面ﾌﾗｸﾞ、表示ﾒｯｾｰｼﾞ設定
;;010419MH                (if (= 1 #iDan)
;;010419MH                  (progn         ; 断面指示されているとき解除
;;010419MH                    (setq #iCol #iColCan)
;;010419MH                    (setq #iDan 0)
;;010419MH                    (setq #sMsg "\n断面指示を解除しました.")
;;010419MH                  )
;;010419MH                  (progn         ; 断面指示されていないとき設定
;;010419MH                    (setq #iCol #iColSet)
;;010419MH                    (setq #iDan 1)
;;010419MH                    (setq #sMsg "\n断面指示を設定しました.")
;;010419MH                  )
;;010419MH                )
;;010419MH                ;色変更
;;010419MH                ;(command "_change" #ss "" "P" "C" #iCol "")
;;010419MH                (command "_change" (ssname #ss 0) "" "P" "C" #iCol "")
;;010419MH                ;拡張ﾃﾞｰﾀ更新
;;010419MH                (setq #Ex_n$
;;010419MH                  (append (reverse (cdr (reverse (CfGetXData #eSYm "G_LSYM")))) (list #iDan))
;;010419MH                )
;;010419MH                (CfSetXData #eSym "G_LSYM" #Ex_n$)
;;010419MH                ;ﾒｯｾｰｼﾞ表示
;;010419MH                (princ #sMsg)
;;010419MH              )
;;010419MH              (progn
;;010419MH                ; 2000/07/17 HT 「設備」は使わない 「アイテム」を使う
;;010419MH                ;(CFAlertMsg "\n設備ではありません.")
;;010419MH                (CFAlertMsg "\nアイテムではありません.")
;;010419MH              )
;;010419MH            )
;;010419MH          )
;;010419MH        )
;;010419MH      )
;;010419MH      (if (/= nil #eBen)
;;010419MH        (GroupInSolidChgCol #eBen CG_BaseSymCol)
;;010419MH      )
;;010419MH      (SCFDanMenColChg #iColCan)
;;010419MH      (setvar "PICKSTYLE" #ps)
;;010419MH    )
;;010419MH    (progn
;;010419MH      (CFAlertMsg "物件が呼び出されていません.")
;;010419MH    )
;;010419MH  )
;;010419MH  ; 終了処理  2000/09/07 HT
;;010419MH  (SCFEndShori)
;;010419MH  
;;010419MH  (princ)
;;010419MH) ; C:SCFDanMen
;;010419MH
;;010419MH
;;010419MH;<HOM>*************************************************************************
;;010419MH; <関数名>    : SCFDanMenColChg
;;010419MH; <処理概要>  : 断面指示されている設備を指定の色にする
;;010419MH; <戻り値>    : なし
;;010419MH; <作成>      : 1999-06-30
;;010419MH; <備考>      : なし
;;010419MH;*************************************************************************>MOH<
;;010419MH(defun SCFDanMenColChg (
;;010419MH  &iCol       ; 色番号
;;010419MH  /
;;010419MH  #ps #xSp #iI #eSym #Ex$ #iDan #ss #en
;;010419MH  )
;;010419MH  (setq #ps (getvar "PICKSTYLE"))
;;010419MH  (setvar "PICKSTYLE" 3)
;;010419MH  (setq #xSp (ssget "X" (list (list -3 (list "G_LSYM")))))
;;010419MH  (if (/= nil #xSp)
;;010419MH    (progn
;;010419MH      (setq #iI 0)
;;010419MH      (repeat (sslength #xSp)
;;010419MH        (setq #eSym (ssname #xSp #iI))
;;010419MH        (setq #Ex$ (CfGetXData #eSym "G_LSYM"))
;;010419MH        (setq #iDan (nth 14 #Ex$))
;;010419MH        (if (/= nil #iDan)
;;010419MH          (progn
;;010419MH            (if (= 1 #iDan)
;;010419MH              (progn
;;010419MH                (command "_select" #eSym "")
;;010419MH                (setq #ss (ssget "P"))
;;010419MH                ;色変更
;;010419MH                ;(command "_change" #ss "" "P" "C" &iCol "")
;;010419MH                (command "_change" (ssname #ss 0) "" "P" "C" &iCol "")
;;010419MH
;;010419MH              )
;;010419MH            )
;;010419MH          )
;;010419MH        )
;;010419MH        (setq #iI (1+ #iI))
;;010419MH      )
;;010419MH    )
;;010419MH  )
;;010419MH  (setvar "PICKSTYLE" #ps)
;;010419MH
;;010419MH  (princ)
;;010419MH) ; SCFDanMenColChg

