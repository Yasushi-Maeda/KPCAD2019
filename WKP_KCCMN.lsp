;<HOM>*************************************************************************
; <関数名>    : ResetBaseSym
; <処理概要>  : 基準アイテムシンボルの色を元に戻す。
; <戻り値>    :
; <作成>      : 98-04-28
; <備考>      :
;*************************************************************************>MOH<
(defun ResetBaseSym (
    /
    #ps #ss
  )
  ;// 基準アイテムシンボル図形を取得
  (setq CG_BASESYM (CFGetBaseSymXRec))
  (if (/= CG_BASESYM nil)
    (progn
      (setq #ps (getvar "PICKSTYLE"))
      (setvar "PICKSTYLE" 3)
;;;01/04/04YM@      (command "_select" CG_BASESYM "")
;;;01/04/04YM@      (setq #ss (ssget "P"))

      ;01/04/04 YM 遅いので変更 START
      (if (entget CG_BASESYM)
        (command "_chprop" CG_BASESYM "" "C" "BYLAYER" "")
      );_if
      ;01/04/04 YM 遅いので変更 END

      (setvar "PICKSTYLE" #ps)
      (setq #ss (ssget "X" '((-3 ("G_ARW")))))
      (command-s "_erase" #ss "")
    )
  )
)
;ResetBaseSym

;隠線処理
; 00/06/04 HN 隠線処理を変更
;@@@(defun C:SCHide  () (setvar "DISPSILH" 1) (command "_hide") (setvar "DISPSILH" 0))
(defun C:SCHide  () (command-s "_shademode" "H") (princ))
;シェード
; 00/06/05 HN シェード処理の最後に(princ)を追加
(defun C:SCShade () (setvar "SHADEDGE" 1) (command-s "_shade") (setvar "SHADEDGE" 3) (princ))

;00/06/29 SN S-ADD
;2Dﾜｲﾔｰﾌﾚｰﾑ
(defun C:2DWire()
  (if (and (eq (getvar "tilemode") 0) (eq (getvar "cvport") 1))
    (command-s "shademode" "")
    (command-s "shademode" "2D")
  )
  (princ)
)
;ﾌﾗｯﾄｼｪｰﾃﾞｨﾝｸﾞｴｯｼﾞ
(defun C:FlatEdge()
  (if (and (eq (getvar "tilemode") 0)(eq (getvar "cvport") 1))
    (command-s "_shademode" "")
    (command-s "_shademode" "L")
  )
  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : C:UndoB
; <処理概要>  : UNDOマーキングされた位置まで戻す
; <戻り値>    : なし
; <備考>      : マーキングがない場合はメッセージを表示する
;*************************************************************************>MOH<
(defun C:UndoB ()
  ;00/09/02 HN S-MOD マーキングがない場合はメッセージを表示
  ;@@@(command "_undo" "b")
  (if (< 0 (getvar "UNDOMARKS"))
    (command-s "_undo" "b")
    (prompt "\nすべての操作が取り消されました.")
  )
  ;00/09/02 HN E-MOD マーキングがない場合はメッセージを表示
  (princ)
)
;C:UndoB

;<HOM>*************************************************************************
; <関数名>    : C:KP_ST_Fillet
; <処理概要>  : "Fillet"ｺﾏﾝﾄﾞ前処理
; <戻り値>    : なし
; <作成>      : 01/09/07 YM
; <備考>      : KPCAD.MNU "Fillet"ｺﾏﾝﾄﾞで使用
;*************************************************************************>MOH<
(defun C:KP_ST_Fillet ()
  (setvar "FILLETRAD" 150) ; ﾌｨﾚｯﾄ半径
  (CFNoSnapStart)
  (StartUndoErr)
  (princ)
)
;C:KP_ST_Fillet

;<HOM>*************************************************************************
; <関数名>    : C:KP_ED_Fillet
; <処理概要>  : "Fillet"ｺﾏﾝﾄﾞ後処理
; <戻り値>    : なし
; <作成>      : 01/09/07 YM
; <備考>      : KPCAD.MNU "Fillet"ｺﾏﾝﾄﾞで使用
;*************************************************************************>MOH<
(defun C:KP_ED_Fillet ()
  (CFNoSnapEnd)
  (setq *error* nil)
  (princ)
)
;C:KP_ED_Fillet

;<HOM>*************************************************************************
; <関数名>    : StartCmnErr
; <処理概要>  : 共通エラー定義
; <戻り値>    :
; <作成>      : 99-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun StartCmnErr ()
  ;@@@(setq *error* CmnErr) ;00/01/30 中村 MOD CG_DEBUG判定を追加
  (if (= CG_DEBUG nil)
    (setq *error* CmnErr)
    (setq *error* nil)
  )
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command-s "_undo" "M")
  (command-s "_undo" "a" "off")
)
;StartCmnErr

;<HOM>*************************************************************************
; <関数名>    : StartUndoErr
; <処理概要>  : Undoエラー定義
; <戻り値>    :
; <作成>      : 99-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun StartUndoErr ()
  ;@@@(setq *error* UndoErr) ;00/01/30 中村 MOD CG_DEBUG判定を追加
  (if (= CG_DEBUG nil)
    (setq *error* UndoErr)
    (setq *error* nil)
  )
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (if (or (= "23" CG_ACADVER)(= "19" CG_ACADVER)(= "18" CG_ACADVER)); 2020/02/17 YM MOD
		(progn
	    (setvar "3DOSMODE"  1) ;2011/06/30 YM ADD 現在の定常 3D オブジェクト スナップを無効にします。
			(setvar "UCSDETECT" 0) ;ダイナミック UCS をアクティブにしない 2011/10/11 YM ADD
		)
  );_if

	; 2020/02/17 YM MOD command --> command-s
  (command-s "_undo" "M")
  (command-s "_undo" "a" "off"); 自動モードオフ
	; 2020/02/17 YM MOD
)
;StartUndoErr

;06/07/24 T.Ari ADD-S パースキャンセルエラー対応
;<HOM>*************************************************************************
; <関数名>    : StartUndoReOpenModelErr
; <処理概要>  : Undoエラー定義
; <戻り値>    :
; <作成>      : 99-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun StartUndoReOpenModelErr ()
  (if (= CG_DEBUG nil)
    (setq *error* UndoReOpenModelErr)
    (setq *error* nil)
  )
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command-s "_undo" "M")
  (command-s "_undo" "a" "off")
)
;StartUndoReOpenModelErr
;06/07/24 T.Ari ADD-E パースキャンセルエラー対応

;<HOM>*************************************************************************
; <関数名>    : CmnErr
; <処理概要>  : 共通エラーコールバック関数
; <戻り値>    :
; <作成>      : 99-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun CmnErr ( &msg )
  ;(setq SCF_OpenMode nil) 2000/08/23 HT DEL 現在未使用
  ; グローバル変数をnilにする 2000/09/08 HT ADD
  (CmnClearGlobal)
  (setq *error* nil)
  (princ)
)
;CmnErr


;<HOM>*************************************************************************
; <関数名>    : CmnClearGlobal
; <処理概要>  : グローバル変数をクリアする
; <戻り値>    : なし
; <作成>      : 2000/09/08
; <備考>      :
;*************************************************************************>MOH<
(defun CmnClearGlobal (
  /
  )
  ; グローバル変数をnilにする
  ; 出力関係のグローバルnil
  (SCF_ClearGlobal)

) ;CmnClearGlobal


;<HOM>*************************************************************************
; <関数名>    : UndoErr
; <処理概要>  : Undoエラーコールバック関数
; <戻り値>    :
; <作成>      : 99-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun UndoErr ( &msg )
;(defun UndoErr ()
  (command-s "_undo" "b");2020/02/17 YM MOD
  ; (setq SCF_OpenMode nil)  2000/08/23 HT DEL 現在未使用
  (setq *error* nil)
  (princ)
)
;UndoErr

;<HOM>*************************************************************************
; <関数名>    : UndoOpenModelErr
; <処理概要>  : Undoエラーコールバック関数
; <戻り値>    :
; <作成>      : 06-07-24
; <備考>      :
;*************************************************************************>MOH<
(defun UndoReOpenModelErr ( &msg )
  (setq CG_OpenMode 0)
  (setq #sFname (strcat CG_KENMEI_PATH "MODEL.dwg"))
  (SCFCmnFileOpen #sFName 1)
  (command-s "_undo" "b")
  (setq *error* nil)
  (princ)
)
;UndoReOpenModelErr

;<HOM>*************************************************************************
; <関数名>    : GetViewSize
; <処理概要>  : 現在のビューポートのサイズを取得する
; <戻り値>    :
;      リスト : (x最小座標 x最大座標 y最小座標 y最大座標)
; <作成>      : 98-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun GetViewSize (
    /
    #vctr #vsize #ssize #x #xmin #xmax #ymin #ymax
  )
  (setq #vctr  (getvar "VIEWCTR"))
  (setq #vsize (getvar "VIEWSIZE"))
  (setq #ssize (getvar "SCREENSIZE"))
  (setq #x (/ (* #vsize (car #ssize)) (cadr #ssize)))
  (setq #xmin (- (car #vctr) (/ #x 2)))
  (setq #xmax (+ (car #vctr) (/ #x 2)))
  (setq #ymin (- (cadr #vctr) (/ #vsize 2)))
  (setq #ymax (+ (cadr #vctr) (/ #vsize 2)))

  (list #xmin #xmax #ymin #ymax)
)
;GetViewSize

;<HOM>*************************************************************************
; <関数名>    : SetListToTile
; <処理概要>  : DCL定義のポップアップにリストの内容を設定する
; <戻り値>    : なし
; <作成>      : 1999-06-14
; <備考>      :
;*************************************************************************>MOH<
(defun SetListToTile (
  &key               ;DCL定義のポップアップ（プルダウン）のキー名称
  &lst$$             ;リストのリスト (("01" "内容1")("02" "内容2")...)
  /
  #lst$
  )
  (start_list &key 3)
  (foreach #lst$ &lst$$
    (add_list (strcat (car #lst$) "：" (cadr #lst$)))
    ;(add_list (cadr #lst$))
  )
  (end_list)
)
;SetListToTile

;<HOM>*************************************************************************
; <関数名>    : SetCodeToTile
; <処理概要>  : DCL定義のポップアップに指定項目を反転表示させる
; <戻り値>    : なし
; <作成>      : 1999-10-05
; <備考>      : 指定項目はリストのリストの１番目の要素とする
;*************************************************************************>MOH<
(defun SetCodeToTile (
    &key               ;DCL定義のポップアップ（プルダウン）のキー名称
    &code              ;反転させる指定コード
    &lst$$             ;リストのリスト (("01" "内容1")("02" "内容2")...)
    /
    #i
    #loop
    #lst$
  )
  (if (/= nil &lst$$)
    (progn
      (setq #i 0)
      (setq #loop T)
      (while (and #loop (< #i (length &lst$$)))
        (setq #lst$ (nth #i &lst$$))
        (if (= (car #lst$) &code)
          (progn
            (set_tile &key (itoa #i))
            (setq #loop nil)
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
)
;SetCodeToTile

;<HOM>*************************************************************************
; <関数名>    : SetCodeToTile2
; <処理概要>  : DCL定義のポップアップに指定項目を反転表示させる
; <戻り値>    : なし
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun SetCodeToTile2 (
    &key                ;DCL定義のポップアップ（プルダウン）のキー名称
    &code$              ;反転させる指定コード
    &lst$$              ;リストのリスト (("01" "内容1" "内容11")("02" "内容2" "内容22")...)
    /
    #i #j
    #loop
    #lst$
  )
  (if (/= nil &lst$$)
    (progn
      (setq #i 0)
      (setq #j 0)
      (setq #loop T)
      (while (and #loop (< #i (length &lst$$)))
        (setq #lst$ (nth #i &lst$$))
        (if (= (caddr #lst$) (cadr &code$))
          (progn
            (if (= (car #lst$) (car &code$))
              (progn
                (set_tile &key (itoa #j))
                (setq #loop nil)
              )
            )
            (setq #j (1+ #j))
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
)
;SetCodeToTile2

;<HOM>*************************************************************************
; <関数名>    : GroupInSolidChgCol
; <処理概要>  : 基点シンボルと同グループの図形を色替えする
; <戻り値>    : なし
; <作成>      : 1999-06-14
; <備考>      :
;*************************************************************************>MOH<
(defun GroupInSolidChgCol (
    &sym     ;(ENAME)シンボル図形
    &col     ;(STR)色
    /
    #en #en$
    #ss
    #ps
  )
  ;// グループ選択モードにしてグループ全体を色替えする
  (setq #ps (getvar "PICKSTYLE"))
  (setvar "PICKSTYLE" 3)
;  (command "_select" &sym "")
;  (setq #ss (ssget "P"))

  ;// 色替え "_change" はUCS に平行でない図形が漏れるので"_chprop"使用
  (command-s "_chprop" &sym "" "C" &col "")

  ;// 矢印を作図
  (MakeSymAxisArw &sym)
  (setvar "PICKSTYLE" #ps)
  (princ)
)
;GroupInSolidChgCol

;<HOM>*************************************************************************
; <関数名>    : SKChgView
; <処理概要>  : 指定視点に変更後、Ｚｏｏｍを0.9xする
; <戻り値>    : なし
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun SKChgView ( &view / #os)

  (setq #os (getvar "OSMODE")) ; 00/02/28 YM ADD
  (setvar "OSMODE" 0)          ; 00/02/28 YM ADD

  ;04/05/26 YM ADD
  (command-s "_REGEN")

  (command-s "_vpoint" &view)
;;;  (command "_zoom" "0.9x") ; 06/05 YM

  (setvar "OSMODE" #os)        ; 00/02/28 YM ADD

  (princ)
);SKChgView

;00/06/29 SN S-ADD
; 02/03/28 HN S-MOD 印刷ずれ対応
;@MOD@(defun C:ChgViewPlaneUp() (SKChgView "0,0,1")) ;平面上
(defun C:ChgViewPlaneUp() (SKChgView "0,0,1")(command-s "_.dview" "all" "" "ca" "" 0.0 "X")) ;平面上
; 02/03/28 HN E-MOD 印刷ずれ対応
(defun C:ChgViewPlaneUd() (SKChgView "0,0,-1"));平面下
(defun C:ChgViewSideL() (SKChgView "-1,0,0"))  ;側面左
(defun C:ChgViewSideR() (SKChgView "1,0,0"))   ;側面右
(defun C:ChgViewFront() (SKChgView "0,-1,0"))  ;正面
(defun C:ChgViewBack() (SKChgView "0,1,0"))    ;背面
(defun C:ChgViewSW() (SKChgView "-2,-2,1"))    ;南西
(defun C:ChgViewSE() (SKChgView "2,-2,1"))     ;南東
;;;01/05/11YM@(defun C:ChgViewNE() (SKChgView "1,1,1"))      ;北東
;;;01/05/11YM@(defun C:ChgViewNW() (SKChgView "-1,1,1"))     ;北西
(defun C:ChgViewNE() (SKChgView "2,2,1"))      ;北東 ; 01/05/11 YM
(defun C:ChgViewNW() (SKChgView "-2,2,1"))     ;北西 ; 01/05/11 YM

;00/06/29 SN E-ADD

;<HOM>*************************************************************************
; <関数名>    : CFGetBaseSymXRec
; <処理概要>  : XRecordから基準アイテムシンボルを検索する
; <戻り値>    :
;       ENAME : 基準アイテムシンボル図形名
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun CFGetBaseSymXRec ( / #hnd )
  (setq #hnd (car (CFGetXRecord "BASESYM")))
  (if (/= #hnd nil)
    (handent #hnd)
  )
)
;CFGetBaseSymXRec

;<HOM>*************************************************************************
; <関数名>    : CFGetBaseSymXRec
; <処理概要>  : XRecordに基準アイテムシンボル図形名を設定する
; <戻り値>    :
;       ENAME : 基準アイテムシンボル図形名
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun CFSetBaseSymXRec ( &en / #hnd )
  (setq #hnd (cdr (assoc 5 (entget &en))))
  (CFSetXRecord "BASESYM" (list #hnd))
)
;CFSetBaseSymXRec

;;;<HOM>***********************************************************************
;;; <関数名>    : KcDelNoExistXRec
;;; <処理概要>  : Xrecordの指定の項目の内容を検査、図面にない=消去済ハンドル削除
;;; <戻り値>    : Xrecordに収納させた、処理済のリスト
;;; <作成>      : 01/04/25 MH
;;; <備考>      :
;;;***********************************************************************>MOH<
(defun KcDelNoExistXRec (
  &sOBDIC       ; XRecord の項目（オブジェクトディクショナリー）文字列
  /
  #HDL$ #TEMP$ #CHK #eCH #HDL$
  )
  ;図面中の削除されたハンドルは除去
  (setq #HDL$ (CFGetXRecord &sOBDIC))
  (setq #TEMP$ nil)
  (foreach #CHK #HDL$
    (if (and (setq #eCH (handent #CHK)) (entget #eCH)) (setq #TEMP$ (cons #CHK #TEMP$)))
  ); foreach
  (setq #HDL$ #TEMP$)
  (CFSetXRecord &sOBDIC #HDL$)
  #HDL$
); KcDelNoExistXRec

;<HOM>*************************************************************************
; <関数名>    : CFPosOKDialog
; <処理概要>  : 配置確認ダイアログ
; <戻り値>    :
;             :    T:(OK)
;             :  nil:(NO)
;             :
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun CFPosOKDialog (
    &msg        ;確認メッセージ
    /
    #dcl_id
    #ret
  )
  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "COMMON.DCL")))
  (if (not (new_dialog "PosOKDlg" #dcl_id)) (exit))
  (set_tile "msg" &msg)
  (action_tile "accept" "(setq #ret T)  (done_dialog)")
  (action_tile "cancel" "(setq #ret nil)(done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)

  ;// 結果を返す
  #ret
)
;CFPosOKDialog

;<HOM>*************************************************************************
; <グローバル定義> :
; <備考>           :
;*************************************************************************>MOH<
(setq CG_XROTATE_ANG 10.0)    ;Ｘ方向回転角度
(setq CG_YROTATE_ANG 10.0)    ;Ｙ方向回転角度
(setq CG_ZoomUp      "1.2x")  ;ｽﾞｰﾑｱｯﾌﾟｻｲｽﾞ
(setq CG_ZoomDn      "0.8x")  ;ｽﾞｰﾑﾀﾞｳﾝｻｲｽﾞ

;;;<HOM>************************************************************************
;;; <関数名>  : SKXRotatePlus
;;; <処理概要>: ビュー視点を少し右回転
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKXRotatePlus ( / #os)
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (SKXRotate CG_XROTATE_ANG)
  (setvar "OSMODE" #os)
  (princ)
);SKXRotatePlus
(defun C:XRotatePlusVp (/) (SKXRotatePlus))

;;;<HOM>************************************************************************
;;; <関数名>  : SKXRotateMinus
;;; <処理概要>: ビュー視点を少し左回転
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKXRotateMinus ( / #os)
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (SKXRotate (* -1.0 CG_XROTATE_ANG))
  (setvar "OSMODE" #os)
  (princ)
);SKXRotateMinus
(defun C:XRotateMinusVp (/) (SKXRotateMinus))

;;;<HOM>************************************************************************
;;; <関数名>  : SKYRotatePlus
;;; <処理概要>: ビュー視点を少し上回転
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKYRotatePlus ( / #os)
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (SKYRotate CG_YROTATE_ANG)
  (setvar "OSMODE" #os)
  (princ)
);SKYRotatePlus
(defun C:YRotatePlusVp () (SKYRotatePlus))

;;;<HOM>*************************************************************************
;;; <関数名>    : SKYRotateMinus
;;; <処理概要>  : ビュー視点を少し下回転
;;; <備考>      : なし
;;;*************************************************************************>MOH<
(defun SKYRotateMinus ( / #os)
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (SKYRotate (* -1 CG_YROTATE_ANG))
  (setvar "OSMODE" #os)
  (princ)
);SKYRotateMinus
(defun C:YRotateMinusVp () (SKYRotateMinus))

;<HOM>*************************************************************************
; <関数名>    : SKFitVp
; <処理概要>  : 現在のビューの表示を最適化する
; <備考>      :
;*************************************************************************>MOH<
(defun SKFitVp ()
  (command-s "_zoom" "e")
;;;  (command "_zoom" "0.9x") ; 06/05 YM
  (princ)
)
;SKFitVp
(defun C:FitVp ()(SKFitVp));00/06/29 SN ADD

;<HOM>*************************************************************************
; <関数名>    : SKZoomUp
; <処理概要>  : ビューを少し拡大する
; <備考>      :
;*************************************************************************>MOH<
(defun SKZoomUp (
  )
  (command-s "_zoom" CG_ZoomUp)
  (princ)
)
;SKZoomUp
(defun C:ZoomUp ()(SKZoomUp));00/06/29 SN ADD

;<HOM>*************************************************************************
; <関数名>    : SKZoomDn
; <処理概要>  : ビューを少し縮小する
; <備考>      :
;*************************************************************************>MOH<
(defun SKZoomDn (
  )
  (command-s "_zoom" CG_ZoomDn)
  (princ)
)
;SKZoomDn
(defun C:ZoomDn ()(SKZoomDn));00/06/29 SN ADD

;<HOM>*************************************************************************
; <関数名>    : SKResetVp
; <処理概要>  : 全てのビューポートの表示を最適化する
; <備考>      :
;*************************************************************************>MOH<
(defun SKResetVp (
    /
    #vid #os
  )
  (command-s "_vports" "SI")
  (command-s "_vpoint" "0,0,1")
  (princ)
)
;SKResetVp
(defun C:ResetVp()(SKResetVp));00/06/29 SN ADD


;<HOM>*************************************************************************
; <関数名>    : CFGetDBSQLRec
; <処理概要>  : 指定テーブルを検索条件により検索する
; <戻り値>    :
; <作成>      : 1999-10-19
; <備考>      :
;*************************************************************************>MOH<
(defun CFGetDBSQLRec (
    &session     ;セッション
    &tbl         ;(STR)テーブル名称
    &list$       ;(LIST)検索条件
    /
    #listCode
    #sql
    #nn
    #i
  )

  (setq #sql (strcat "select * from " &tbl " where"))
  (setq #i 0)

  (foreach #lst &list$

    (if (= (nth 2 #lst) 'ADDSTR)
      (progn
        (setq #sql (strcat #sql " " (car #lst)))
      )
      (progn
        (if (/= #i 0)
          (progn ; 最初以外
            (setq #sql (strcat #sql " and "))
          )
          (progn ; 最初だけ
            (setq #sql (strcat #sql " "))
          )
        )
        (cond
          ((= (nth 2 #lst) 'INT)
            (setq #sql (strcat #sql (car #lst) "=" (cadr #lst)))
          )
          ((= (nth 2 #lst) 'STR)
            (setq #sql (strcat #sql (car #lst) "='" (cadr #lst) "'"))
          )
        )
      )
    )
    (setq #i (1+ #i))
;;;   (princ #i)(terpri)
  )

  (if (= CG_DEBUG 1)
    (progn
      (princ "\n== CFGetDBSQLRec =============================================")
      (princ "\n #sql =")(princ #sql)
      (princ "\n==============================================================")
    )
  )

  ;// クエリーの実行結果を返す
  (DBSqlAutoQuery &session #sql)
)
;CFGetDBSQLRec

;<HOM>*************************************************************************
; <関数名>    : CFGetSymSKKCode
; <処理概要>  : 指定部材の性格CODEを取得する
; <戻り値>    :
;     FLG=nil :
;        LIST : (一桁目 二桁目 三桁目)
;    FLG/=nil :
;         INT : 指定の桁目の値を返す
;
; <作成>      : 1999-10-19
; <備考>      :
;*************************************************************************>MOH<
(defun CFGetSymSKKCode (
    &enS         ;(ENAME)基準シンボル
    &flg         ;(INT)取得フラグ
                 ;      1:一桁目
                 ;      2:一桁目
                 ;      3:一桁目
                 ;    nil:全て
    /
    #seikaku
    #LSYM$       ; 拡張データ
    #Ret         ; 返り値  （エラーの時nil)
  )
  (setq #LSYM$ (CFGetXData &enS "G_LSYM"))
  (if (= #LSYM$ nil)
    (progn
    (princ "\n拡張データを取得できませんでした。(G_LSYM)")
    (princ "\n図形データ ：")
    (princ (cdr (cadr (assoc -3 (entget &enS '("*"))))))
    (setq #Ret nil)
    (princ "\n")
    )
    (progn
    (setq #seikaku (nth 9 #LSYM$))
    (setq #Ret (CFGetSeikakuToSKKCode #seikaku &flg))
    )
  )
  ; 2000/06/07 土屋 図形拡張データ不正の場合エラーメッセージ+  nilを返すように変更
  ; (setq #seikaku (nth 9 (CFGetXData &enS "G_LSYM")))
  ; (CFGetSeikakuToSKKCode #seikaku &flg)
  #Ret
)
;CFGetSymSKKCode

;<HOM>*************************************************************************
; <関数名>    : CFGetSeikakuToSKKCode
; <処理概要>  : 指定部材の性格CODEを取得する
; <戻り値>    :
;     FLG=nil :
;        LIST : (一桁目 二桁目 三桁目)
;    FLG/=nil :
;         INT : 指定の桁目の値を返す
;
; <作成>      : 1999-10-19
; <備考>      :
;*************************************************************************>MOH<
(defun CFGetSeikakuToSKKCode (
    &seikaku     ;(INT)3桁の性格CODE  111
    &flg         ;(INT)取得フラグ
                 ;      1:1桁目
                 ;      2:2桁目
                 ;      3:3桁目
                 ;    nil:全て
    /
  )
  (setq &seikaku (itoa (fix &seikaku)))
  (if &flg
    (progn
      (atoi (substr &seikaku &flg 1))
    )
    (progn ; &flg=nil
      (list (atoi (substr &seikaku 1 1))
            (atoi (substr &seikaku 2 1))
            (atoi (substr &seikaku 3 1))
      )
    )
  )
)
;CFGetSymSKKCode

;<HOM>***********************************************************************
; <関数名>    : MakeArrow
; <処理概要>  : 始点側に円、終点側に矢印を持つ線の描画
; <戻り値>    : 線の構成要素全てのエンティティリスト
; <作成>      : 1998/05/29 -> 1998/05/29  松木 健太郎
; <備考>      : 矢印は"0"画層にかく 00/08/01 YM
;***********************************************************************>HOM<
(defun MakeArrow
  (
    &pos1     ; 始点
    &pos2     ; 終点
    &recH     ; 始点円の半径
    &Arlngh   ; 矢印線の長さ
    &Arrec    ; 矢印の内径角
    &color    ; 描画色
    /
    #cir
    #line
    #Aln1
    #Aln2
    #TempColor
    #os #clayer
  )
  (setq #clayer (getvar "CLAYER"   ))         ; 現在の画層をキープ 00/08/01 YM
  (command-s "_layer" "T" "0" "")  ; ﾌﾘｰｽﾞ解除
  (command-s "_layer" "ON" "0" "") ; 画層ON
  (command-s "_layer" "U" "0" "")  ; ﾛｯｸ解除
  (command-s "_layer" "S" "0" "")  ; 現在画層の変更     00/08/01 YM

  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (setq #TempColor (getvar "CECOLOR"))
  (setvar "CECOLOR" (itoa &color))
  (command-s "_circle" &pos1 &recH)
  (setq #cir (entlast))

  (command-s "_pline" &pos1 &pos2 "")
  (setq #line (entlast))

  (command-s
    "_pline"
    &pos2
    (strcat
      "@"
      (rtos &Arlngh)
      "<"
      (rtos
        (+
          &Arrec
          (+
            180
            (/ (* (angle &pos1 &pos2) 180) pi)
          )
        )
      )
    )
    ""
  )
  (setq #Aln1 (entlast))

  (command-s
    "_pline"
    &pos2
    (strcat
      "@"
      (rtos &Arlngh)
      "<"
      (rtos
        (+
          (* &Arrec -1)
          (+
            180
            (/ (* (angle &pos1 &pos2) 180) pi)
          )
        )
      )
    )
    ""
  )
  (setq #Aln2 (entlast))
  (setvar "CECOLOR" #TempColor)
  (setvar "OSMODE" #os)

  (CFSetXData #cir  "G_ARW" (list 0))
  (CFSetXData #line "G_ARW" (list 0))
  (CFSetXData #Aln1 "G_ARW" (list 0))
  (CFSetXData #Aln2 "G_ARW" (list 0))
  (setvar "CLAYER" #clayer) ; 元の画層に戻す 00/08/01 YM
  (list #cir #line #Aln1 #Aln2)
)
;MakeArrow

;<HOM>*************************************************************************
; <関数名>    : NRMakePrimAxisArw
; <処理概要>  : 要素図形の軸矢印を作成する
; <戻り値>    :
;        LIST : 作成し矢印の構成図形リスト
; <作成>      : 1999-12-20
; <備考>      :
;*************************************************************************>MOH<
(defun MakeSymAxisArw (
    &sym    ;(ENAME)シンボル図形名
    /
    #w #ang #en$ #pt1 #pt2
  )
  (setq #w   (nth 3 (CFGetXData &sym "G_SYM")))
  (setq #ang (nth 2 (CFGetXData &sym "G_LSYM")))
  (setq #pt1 (cdr (assoc 10 (entget &sym))))
  (setq #pt2 (polar #pt1 #ang #w))

  ;// 矢印を作成する
  (setq #en$ (MakeArrow #pt1 #pt2 CG_AXISARWRAD CG_AXISARWLEN CG_AXISARWANG CG_AXISARWCOLOR))

  #en$
)
;MakeSymAxisArw

;<HOM>*************************************************************************
; <関数名>    : GetDlgID
; <処理概要>  : ﾀﾞｲｱﾛｸﾞID獲得
; <戻り値>    : ﾀﾞｲｱﾛｸﾞID
; <作成>      : 森本
; <備考>      : なし
;*************************************************************************>MOH<
(defun GetDlgID (
  &sFname     ; ﾀﾞｲｱﾛｸﾞﾌｧｲﾙ名（拡張子なし）
  /
  )
  (load_dialog (strcat CG_DCLPATH &sFname ".dcl"))
)
;GetDlgID

;<HOM>*************************************************************************
; <関数名>    : MakeCmLwPolyLine
; <処理概要>  : 点列からﾗｲﾄｳｪｲﾄﾎﾟﾘﾗｲﾝを作成する
; <戻り値>    :
;       ENAME : 作成したﾗｲﾄｳｪｲﾄﾎﾟﾘﾗｲﾝｴﾝﾃｨﾃｨ名
; <作成>      : 98-03-25 川本成二
; <備考>      : ｺﾏﾝﾄﾞ関数を使用
;*************************************************************************>MOH<
(defun MakeCmLwPolyLine (
    &pt$  ;(LIST)構成座標点ﾘｽﾄ
    &cls  ;(INT) "C" : ポリラインを閉じる
          ;       "" : ポリラインを閉じない
    /
    #vn #eg #pt #os #ret
  )
  (setq #ret nil)
  (if (< 1 (length &pt$))
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command "_PLINE" (car &pt$))
      (foreach #pt (cdr &pt$)
        (command #pt)
      )
      (command &cls)
      (setvar "OSMODE" #os)
      (entlast)
    )
  ;else
    nil
  )
)
;MakeCmLwPolyLine

;<HOM>*************************************************************************
; <関数名>    : PKAutoHinbanKakutei
; <処理概要>  : 自動品番確定(ﾕｰｻﾞｰ判断)
; <戻り値>    :
; <作成>      : 01/06/?? YM
; <備考>      :
;*************************************************************************>MOH<
(defun PKAutoHinbanKakutei (
  /
  #I #SS #WT$
;-- 2011/09/14 A.Satoh Add - S
  #set_cnt
;-- 2011/09/14 A.Satoh Add - E
  )
;-- 2011/09/14 A.Satoh Add - S
  (setq #set_cnt 0)
;-- 2011/09/14 A.Satoh Add - E
  (setq #WT$ '())
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (and #ss (> (sslength #ss) 0))
    (progn ; WTあり
      (setq #i 0 #WT$ '()) ; 品番確定していないＷＴを調べる
      (repeat (sslength #ss)
        (if (= nil (CFGetXData (ssname #ss #i) "G_WTSET"))
          (setq #WT$ (append #WT$ (list (ssname #ss #i)))) ; 品番確定していないＷＴﾘｽﾄ
        );_if
        (setq #i (1+ #i))
      );_repeat

      (if #WT$
;-- 2011/08/31 A.Satoh Mod - S
;        (if (CFYesNoDialog "ワークトップの品番確定を行います。【工事中】")
        (if (CFYesNoDialog "ワークトップの品番確定を行います。")
;-- 2011/08/31 A.Satoh Mod - E
          (progn
            (CFCmdDefBegin 0); 04/06/28 YM ADD
            (CFNoSnapReset)
            (foreach #WT #WT$
              (PCW_ChColWT #WT "MAGENTA" nil)
;;;              (KPW_DesideWorkTop3 #WT) ; ｼﾝｸ、ｺﾝﾛ複数対応
;-- 2011/09/14 A.Satoh Mod - S
;              (KPW_DesideWorkTop_FREE #WT);2011/08/12 YM ADD
              (if (= (KPW_DesideWorkTop_FREE #WT) nil)
                (setq #set_cnt (1+ #set_cnt))
              )
;-- 2011/09/14 A.Satoh Mod - E
            )
            (CFNoSnapFinish); 04/06/28 YM ADD
            (CFCmdDefFinish)
          )
;-- 2011/09/14 A.Satoh Mod - S
;          ;else
;          (princ) ; No
          (setq #set_cnt (1+ #set_cnt))
;-- 2011/09/14 A.Satoh Mod - E
        );_if
      );_if
    )
  );_if

;-- 2011/09/14 A.Satoh Mod - S
;  (princ)
  (if (= #set_cnt 0)
    (setq #ret T)
    (setq #ret nil)
  )
  #ret
;-- 2011/09/14 A.Satoh Mod - E
);PKAutoHinbanKakutei

;<HOM>*************************************************************************
; <関数名>    : KPAutoCT_HINKakutei
; <処理概要>  : 洗面ｶｳﾝﾀｰﾄｯﾌﾟ自動品番確定(ﾕｰｻﾞｰ判断)
; <戻り値>    :
; <作成>      : 01/08/28 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KPAutoCT_HINKakutei (
  /
  #CT$ #I #SKK$ #SS
  )
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss (> (sslength #ss) 0))
    (progn
      (setq #i 0) ; ｶｳﾝﾀｰﾄｯﾌﾟを調べる
      (setq #CT$ nil)
      (repeat (sslength #ss)
        (setq #skk$ (CFGetSymSKKCode (ssname #ss #i) nil))
        (if (and (= (car   #skk$) CG_SKK_ONE_CNT) ; ｶｳﾝﾀｰ =7 ; 01/08/29 YM MOD
                 (= (cadr  #skk$) CG_SKK_TWO_BAS) ; ﾍﾞｰｽ  =1 ; 01/08/29 YM MOD
                 (= (caddr #skk$) CG_SKK_THR_ETC)); その他=0 ; 01/08/29 YM MOD
          (progn ; 洗面ｶｳﾝﾀｰだった  ; 01/08/29 YM MOD PMEN4の有無を見ない
            (if (= nil (CFGetXData (ssname #ss #i) "G_TOKU"))
              (setq #CT$ (append #CT$ (list (ssname #ss #i)))) ; 品番確定していないｶｳﾝﾀｰﾄｯﾌﾟﾘｽﾄ
            );_if
          )
        );_if
        (setq #i (1+ #i))
      );_repeat

      (if #CT$
        (if (CFYesNoDialog "洗面カウンタートップの品番確定を行います。")
          (foreach #CT #CT$
            (GroupInSolidChgCol2 #CT CG_InfoSymCol) ; 色を変える
            (KP_DesideCTTop #CT); 洗面ｶｳﾝﾀｰの品番を確定&確認&"G_TOKU"ｾｯﾄ
            (GroupInSolidChgCol2 #CT "BYLAYER")     ; 色を変える
          )
          (princ) ; ﾕｰｻﾞｰがNo
        )
      );_if
    )
  );_if
  (princ)
);KPAutoCT_HINKakutei

;;;<HOM>************************************************************************
;;; <関数名>  : CFAutoSave
;;; <処理概要>: 自動保存処理
;;; <戻り値>  : なし
;;; <改訂>    : 01/05/23
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun CFAutoSave
  (
  /
  #sFname     ; ファイル名
  )
  (setvar "ELEVATION" 0); 01/02/13 MH ADD

  (if (or (= CG_TESTMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3))
    nil
  ; else
    ; WEB版以外
    (if (= "MODEL.DWG" (strcase (getvar "DWGNAME")))
      (progn ; 01/03/09 YM ﾃﾝﾌﾟﾚｰﾄ読み込み後出力ﾒﾆｭｰ終了するときは処理を飛ばさないと落ちる

        (C:DELMEJI) ; ｼﾝﾎﾞﾙにひもついていないG_MEJIを削除

        (C:Del0door) ; 自動図面修復機能("0_door" "0_plane" "0_wall"画層削除、"0_door"存在→部材更新)

        ; 保存時にヘッダー情報書出し処理を追加
        (SKB_WriteHeadList);2008/06/24 YM DEL

        ; 保存時にCOLOR.CFGを書き出す。
        (SKB_WriteColorList);2008/06/24 YM DEL

        (CabShow_sub) ; 01/09/03 YM MOD 関数化

        ;// ワークトップが品番未確定なら自動確定する
;;;       (PKAutoHinbanKakutei);2008/06/24 YM DEL

        ;// カウンタートップが品番未確定なら自動確定する
;;;       (KPAutoCT_HINKakutei);2008/06/24 YM DEL

        ; 03/05/07 YM 未使用ｸﾞﾙｰﾌﾟ定義を削除する
        (KP_DelUnusedGroup)
      )
    );_if
  );_if

  (command-s "_purge" "bl" "*" "N")
  (command-s "_purge" "bl" "*" "N")
  (command-s "_purge" "bl" "*" "N")
  (command-s "_purge" "bl" "*" "N")

  ; 01/05/23 HN E-MOD 保存処理を変更
  ;@MOD@;;; @YM@ ST00/01/27  次の (command "new" ".")の"new"をファイル名として認識しないため
  ;@MOD@;;;     (command "_.QSAVE")
  ;@MOD@    ;(command "_.SAVE" "") ; @YM@ 00/02/01 ;00/06/20 SN MOD
  ;@MOD@(command "_.save" (strcat (getvar "dwgprefix") (getvar "dwgname")));00/06/20 SN MOD
;-- 2011/10/06 A.Satoh Mod - S
;;;;;  (command "_.QSAVE")
;;;;;
;;;;;  (if (wcmatch (getvar "CMDNAMES") "*QSAVE*")
;;;;;    (command "2000" "")
;;;;;  );_if
  (setq #sFname (strcat (getvar "dwgprefix") (getvar "dwgname")))
  (if (or (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
          (vl-string-search CG_PARSU_DWG_STR (getvar "DWGNAME")))
    (setq #ver CG_DWG_VER_MODEL)
    (setq #ver CG_DWG_VER_SEKOU)
  )
(princ #sFname)
  (command-s "_.SAVEAS" #ver #sFName)
;-- 2011/10/06 A.Satoh Mod - E

  (princ)
) ;_CFAutoSave

;<HOM>*************************************************************************
; <関数名>    : C:AutoSave
; <処理概要>  : 保存コマンド
; <戻り値>    : なし
; <作成>      : ???
; <修正>      : 01/09/03 YM
; <備考>      : (もし品番確定失敗するとｶｳﾝﾀｰの色が戻らないためｴﾗｰ処理を追加した)
;*************************************************************************>MOH<
(defun C:AutoSave()

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 前処理
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO処理追加

  (CFAutoSave)

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 後処理
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO処理追加

);00/06/29 SN ADD

;<HOM>*************************************************************************
; <関数名>    : CFGetDBSQLHinbanTable
; <処理概要>  : 品番関連テーブル検索処理
; <戻り値>    :
;        LIST : 品番関連テーブルのレコード内容リスト
; <作成>      :
; <備考>      :
;*************************************************************************>MOH<
(defun CFGetDBSQLHinbanTable (
    &tblName           ;(STR)テーブル名称
                       ;      1:品番図形
                       ;      2:品番基本
                       ;      3:品番最終
    &hinban            ;(STR)品番名称
    &sql$              ;(LIST)検索条件
    /
    #qry$ #qry$$ #dbSession
  )

;;; (princ "\n &tblName=")(princ &tblName)
;;; (princ "\n &hinban=") (princ &hinban)
;;; (princ "\n &sql$=")   (princ &sql$)

  ;// 品番名称で商品階層テーブルを検索し、データベースを決定する
  ;(setq #qry$
  ;  (car (CFGetDBSQLRec CG_DBSESSION "商品階層"
  ;          (list
  ;            (list "階層名称"     &hinban          'STR)
  ;          )
  ;       )
  ;  )
  ;)
  (setq #qry$ nil)
  (if (= #qry$ nil)
    (progn
      ;(princ "\n---------------------------------------------")
      ;(princ "\n商品階層テーブルに該当する品番がありません.")
      ;(princ "\n強制的に共通DB,SERIES別DBを検索します.")
      ;(princ "\n品番:[")
      ;(princ &hinban)
      ;(princ "]")
      ;(princ "\n---------------------------------------------")
      ;// 品番関連のテーブルを検索し、一致するレコードを返す
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION &tblName
           &sql$
        )
      )
      (if (= #qry$$ nil)
        (setq #qry$$
          (CFGetDBSQLRec CG_CDBSESSION &tblName
             &sql$
          )
        )
      )
    )
    (progn
      (if (= (fix (nth 3 #qry$)) 0)  ;SERIES別品番
        (progn
          (setq #dbSession CG_DBSESSION)
          ;(princ "\nSERIES別品番:")
          ;(princ &hinban)
          ;(princ "]")
        )
        (progn
          (setq #dbSession CG_CDBSESSION)
          ;(princ "\n共通品番:[")
          ;(princ &hinban)
          ;(princ "]")
        )
      )
      ;// 品番関連のテーブルを検索し、一致するレコードを返す
      (setq #qry$$
        (CFGetDBSQLRec #dbSession &tblName
          &sql$
        )
      )
    )
  )
  #qry$$
)
;CFGetDBSQLHinbanTable

;;;<HOM>************************************************************************
;;; <関数名>  : SKXRotate
;;; <処理概要>: ビュー視点を少し左右回転
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKXRotate (
  &ang        ;(INT) 1:プラス方向 2:マイナス方向
  /
  #vp
  #angX
  )

  (if (/= "MODEL.DWG" (strcase (getvar "DWGNAME")))
    (if (= (getvar "TILEMODE") 0)
      (command-s "_.MSPACE")
      (CFAlertErr "図面参照時は回転できません")
    )
  )
  (setq #vp  (getvar "VIEWDIR"))
  (if (and (equal (car #vp) 0 0.0001)(equal (cadr #vp) 0 0.0001))
    (progn ; 真上、真下から見ているとき
      (command-s "._ucs" "V")
      (setvar "ucsfollow" 1)
      (command-s "._ucs" "Z" &ang)
      (setvar "ucsfollow" 0)
      (command-s "._ucs" "W")
    )
    (progn
      (setq #angX (rtd (angle (list 0.0 0.0 0.0) (list (car #vp) (cadr #vp)))))
      (setq #angX (+ #angX &ang))
      (if (> #angX  180.0) (setq #angX (* -1.0 (- 360.0 #angX))))
      (if (< #angX -180.0) (setq #angX         (+ 360.0 #angX) ))

;;;     (princ "\n angX =")(princ #angX )(terpri)
      (command-s "_.dview" "all" "" "ca" "" #angX "X")
    )
  );_if

  (if (/= "MODEL.DWG" (strcase (getvar "DWGNAME")))
    (if (= (getvar "TILEMODE") 0)
      (command-s "_.PSPACE")
    )
  )
  (princ)
)
;;;SKXRotate

;<HOM>*************************************************************************
; <関数名>    : SKYRotate
; <処理概要>  : ビュー視点を少し上下回転
; <備考>      :
;*************************************************************************>MOH<
(defun SKYRotate (
  &ang  ;(INT) 1:プラス方向 2:マイナス方向
  /
  #vp #angX #angXY #sqrt
  )
  (if (/= "MODEL.DWG" (strcase (getvar "DWGNAME")))
    (if (= (getvar "TILEMODE") 0)
      (command-s "_.MSPACE")
      (CFAlertErr "図面参照時は回転できません")
    )
  )
  (setq #vp (getvar "VIEWDIR"))
  (setq #sqrt (sqrt (+ (* (car #vp) (car #vp)) (* (cadr #vp) (cadr #vp)))))
  ;(if (/= (atof (rtos #sqrt 2 2)) 0.0)
    (progn
      (setq #angXY (rtd (atan (/ (caddr #vp) #sqrt))))
      (setq #angXY (+ #angXY &ang))
      (if (>= #angXY  89.99999) (setq #angXY  90.0))
      (if (<= #angXY -89.99999) (setq #angXY -90.0))

;;;      (if (> #angXY  90) (setq #angXY  89.99999))
;;;      (if (< #angXY -90) (setq #angXY -89.99999))

      (setq #angX (rtd (angle (list 0.0 0.0 0.0) (list (car #vp) (cadr #vp)))))
      (if (> #angX  180.0) (setq #angX (* -1.0 (- 360.0 #angX))))
      (if (< #angX -180.0) (setq #angX         (+ 360.0 #angX) ))

;;;     (princ "\n angXY=")(princ #angXY)(terpri)
;;;     (princ "\n angX =")(princ #angX )(terpri)
      (command-s "_.dview" "all" "" "ca" #angXY #angX "")

;;;      (command "_.dview" "all" "" "ca" "XY" #ang "" "")
;;;      (command "_.dview" "all" "" "ca" #ang "" "X")
    )
  ;)
  (if (/= "MODEL.DWG" (strcase (getvar "DWGNAME")))
    (if (= (getvar "TILEMODE") 0)
      (command-s "_.PSPACE")
    )
  )
)
;SKYRotate

;-- 2011/09/13 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : PKAutoTokuTenban
; <処理概要>  : 自動天板特注化(ﾕｰｻﾞｰ判断)
; <戻り値>    : T  :2穴水栓の規格天板が存在しない（特注化を実行）
;             : nil:2穴水栓の規格天板が存在する（特注化をキャンセル）
; <作成>      : 11/09/13 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
;(defun C:qqq (
(defun PKAutoTokuTenban (
  /
  #set_cnt #ss #wt$ #wt #i
  #wt_en #xd$ #tei #toku #pt$ #pt2$ #sym$ #sym #sui_cnt
  #wt_xd$ #hinban_dat$ #BG1 #BG2 #ret
  )

  (setq #set_cnt 0)

  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (and #ss (> (sslength #ss) 0))
    (progn
      (command-s "vpoint" "0,0,1")

;-- 2011/12/26 A.Satoh Add - S
			(command-s "_ZOOM" "E")
			(command-s "_ZOOM" "0.8x")
;-- 2011/12/26 A.Satoh Add - E

      (setq #wt$ '())
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #wt_en (ssname #ss #i))
        (setq #xd$ (CFGetXData #wt_en "G_WRKT"))
        (setq #wt_xd$ (CFGetXData #wt_en "G_WTSET"))
        (setq #tei (nth 38 #xd$))          ; WT底面図形ﾊﾝﾄﾞﾙ
        (setq #toku (nth 58 #xd$))         ; 特注フラグ　"":規格天板　"TOKU":特注天板
        (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
        (setq #pt2$ (append #pt$ (list (car #pt$)))) ; 終点の次に始点を追加して領域を囲う
        ; 領域に含まれる、シンク,水栓を検索する
        (setq #sym$ (PKGetSinkSuisenSymCP #pt2$))

        ; 検索したシンク、水栓リストから水栓の個数を求める
        (setq #sui_cnt 0)
        (foreach #sym #sym$
          (if (= (nth 9 (CFGetXData #sym "G_LSYM")) CG_SKK_INT_SUI)   ; 水栓図形
            (setq #sui_cnt (1+ #sui_cnt))
          )
        )

;-- 2012/01/13 A.Satoh Add - S
(princ "\n★★★G_WTSET ：") (princ #wt_xd$)
(princ "\n★★★特注フラグ：") (princ #toku)
;-- 2012/01/13 A.Satoh Add - E
;-- 2011/12/26 A.Satoh Add - S
(princ "\n★★★水栓の数：") (princ #sui_cnt)
;-- 2011/12/26 A.Satoh Add - E

        (if (and #wt_xd$ (= #toku "") (/= #sui_cnt 1))
          (progn
            (setq #wt$ (append #wt$ (list #wt_en))) ; 規格天板で水栓が1個でないＷＴﾘｽﾄ
          )
        )

        (setq #i (1+ #i))
      );_repeat

;-- 2011/12/26 A.Satoh Add - S
      (command-s "zoom" "p")
      (command-s "zoom" "p")
;-- 2011/12/26 A.Satoh Add - E
      (command-s "zoom" "p")

;-- 2012/01/13 A.Satoh Add - S
(princ "\n★★★特注化対象天板：") (princ #wt$)


;-- 2012/01/13 A.Satoh Add - E
      (if #wt$
        (if (CFYesDialog "ワークトップの特注化を行います。")
          (progn

						; 2019/03/04 YM MOD 場合わけ
						(cond
							((= BU_CODE_0013 "1") ; PSKCの場合
								(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
							)
							((= BU_CODE_0013 "2") ; PSKDの場合
								(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
							)
							(T ;それ以外
								(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
							)
						);_if
						; 2019/03/04 YM MOD 場合わけ

            (CFCmdDefBegin 0)
            (CFNoSnapReset)
            (foreach #wt #wt$
              (setq #xd$ (CFGetXData #wt "G_WRKT"))
              (setq #wt_xd$ (CFGetXData #wt "G_WTSET"))
              (PCW_ChColWT #wt "MAGENTA" nil)
              (setq #hinban_dat$
                (list
                  0                  ; 特注フラグ
;;;                  "ZZ6500"           ; 品番
                  #CG_TOKU_HINBAN     ; 品番 2016/08/30 YM ADD (1)天板なので機器以外 2019/03/04 YM MOD 場合わけ
                  "0"                ; 金額
                  (nth 5 #wt_xd$)    ; 巾
                  (nth 6 #wt_xd$)    ; 高さ
                  (nth 7 #wt_xd$)    ; 奥行

                  (nth 4 #wt_xd$)    ; 品名 2016/10/31 YM MOD ★★★元に戻した EASYとの連携
;;;									CG_TOKU_HINMEI     ; 品名 2016/08/30 YM ADD　★★★ここは、処理的に、これにしてはいけない

                  (nth 8 #wt_xd$)    ; 特注コード
                )
              )

              ; 天板品名確定ダイアログ処理
;-- 2011/12/12 A.Satoh Mod - S
;;;;;              (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$))
              (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$ (nth 3 #xd$)))
;-- 2011/12/12 A.Satoh Mod - S
              (if (/= #hinban_dat$ nil)
                (progn
                  (CFSetXData #wt "G_WTSET" (CFModList #wt_xd$
                      (list
                        (list 0 (nth 0 #hinban_dat$))
                        (list 1 (nth 1 #hinban_dat$))
                        (list 3 (nth 2 #hinban_dat$))
                        (list 4 (nth 6 #hinban_dat$))
                        (list 5 (nth 3 #hinban_dat$))
                        (list 6 (nth 4 #hinban_dat$))
                        (list 7 (nth 5 #hinban_dat$))
                        (list 8 (nth 7 #hinban_dat$))
                      ))
                  )
                  (CFSetXData #wt "G_WRKT" (CFModList #xd$ (list (list 58 "TOKU"))))

                  (command-s "_.change" #wt "" "P" "C" CG_WorkTopCol "")
                  ;;; BG,FGも一緒に色替えする
                  (setq #BG1 (nth 49 #xd$))
                  (setq #BG2 (nth 50 #xd$))
                  (if (/= #BG1 "")
                    (progn
                      (if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
                        (command-s "_.change" #BG1 "" "P" "C" CG_WorkTopCol "")
                      )
                    )
                  );_if
                  (if (/= #BG2 "")
                    (progn
                      (if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
                        (command-s "_.change" #BG2 "" "P" "C" CG_WorkTopCol "")
                      )
                    )
                  );_if
                )
                (progn
                  (PCW_ChColWT #wt CG_WorkTopCol nil)
                  (setq #set_cnt (1+ #set_cnt))
                )
              )
            )
            (CFNoSnapFinish)
            (CFCmdDefFinish)
          )
        )
      );_if
    )
  )

  (if (= #set_cnt 0)
    (setq #ret T)
    (setq #ret nil)
  )

  #ret

);PKAutoTokuTenban
;-- 2011/09/13 A.Satoh Add - E

;-- 2011/10/14 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : KPCAD_StopCancelDlg
; <処理概要>  : 中断終了/破棄終了の選択ダイアログ処理を行う
; <戻り値>    : T  : 中断終了
;             : nil: 破棄終了
; <作成>      : 2011/10/14 (A.Satoh)
; <備考>      : なし
;*************************************************************************>MOH<
(defun KPCAD_StopCancelDlg (
  /
  #dcl_id #ret
  )

  ; DCLロード
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kscmain.dcl")))
  (if (not (new_dialog "KPCAD_StopOrCancelDlg" #dcl_id)) (exit))

  ; ボタン押下処理
  (action_tile "accept" "(setq #ret 2) (done_dialog)")
  (action_tile "haki"   "(setq #ret 3) (done_dialog)")
  (action_tile "cancel" "(setq #ret 0) (done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)

  #ret

) ;KPCAD_StopCancelDlg


;<HOM>*************************************************************************
; <関数名>    : KPCAD_FixEndDlg
; <処理概要>  : KPCAD終了ダイアログ処理を行う
; <戻り値>    : 1: 確定終了
;             : 2: 中断終了
;             : 3: 破棄終了
;             : 0: キャンセル
; <作成>      : 2011/10/14 (A.Satoh)
; <備考>      : なし
;*************************************************************************>MOH<
(defun KPCAD_FixEndDlg (
  /
  #dcl_id #ret
  )

  ; DCLロード
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kscmain.dcl")))
  (if (not (new_dialog "KPCAD_FixEndDlg" #dcl_id)) (exit))

  ; ボタン押下処理
  (action_tile "accept" "(setq #ret 1) (done_dialog)")
  (action_tile "stop"   "(setq #ret 2) (done_dialog)")
  (action_tile "haki"   "(setq #ret 3) (done_dialog)")
  (action_tile "cancel" "(setq #ret 0) (done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)

  #ret

) ;KPCAD_FixEndDlg


;<HOM>*************************************************************************
; <関数名>    : KPCAD_FixEnd
; <処理概要>  : 確定終了処理を行う
; <戻り値>    : T  : 正常終了
;             : nil: 異常終了
; <作成>      : 2011/10/14 (A.Satoh)
; <備考>      : なし
;*************************************************************************>MOH<
(defun KPCAD_FixEnd (
  /
	#cancel #ret #planinfo$$ #planinfo$ #flag
#err_flag
  )

	; 部材一括確認画面を表示する
	(C:ConfPartsAll)

	(setq #cancel nil)
	(setq #err_flag nil)

  ; 現在の扉情報等をInput.CFGに書き込む
	(setq #ret (CFOutInputCfg T))
	(if (= #ret nil)
		(progn
			(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
				(progn
					(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
					(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
				)
			)
			(setq #cancel T)
		)
	)

	(if (not (wcmatch CG_KENMEI_PATH "*BUKKEN*"))
		(progn
			(if (= #cancel nil)
				(if (findfile (strcat CG_SYSPATH "SelectUploadDWG.exe"))
					(progn
						(C:arxStartApp (strcat CG_SysPATH "SelectUploadDWG.exe") 1)
						(setq #planinfo$$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
						(if (= #planinfo$$ nil)
							(progn
								(princ (strcat "PLANINFO.CFGの読込に失敗しました。\n" CG_KENMEI_PATH "PLANINFO.CFG"))
								(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
									(progn
										(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
										(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
									)
								)
								(setq #err_flag T)
							)
							(progn
								(setq #flag nil)
								(foreach #planinfo$ #planinfo$$
									(if (= (nth 0 #planinfo$) "[PDF_DXF_TARGET]")
										(setq #flag T)
									)
								)

								(if (= #flag nil)
									(progn
										(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
											(progn
												(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
												(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
											)
										)
										(setq #cancel T)
									)
								)
							)
						)
					)
					(progn
						(princ "UPLOAD対象図面選択ﾓｼﾞｭｰﾙ(SelectUploadDWG.exe)がありません。")
						(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
							(progn
								(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
								(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
							)
						)
						(setq #err_flag T)
					)
				)
			)
		)
	)

	(if (= #cancel nil)
		(progn
			(if (= #err_flag T)
				(CFAlertMsg "KPCAD終了処理でエラーが発生しました。強制終了します。\n図面は現状の状態が保持されます。")
			)

			; running.flgを削除する
			(if (findfile (strcat CG_KENMEI_PATH "running.flg"))
				(vl-file-delete (strcat CG_KENMEI_PATH "running.flg"))
			)

			; input0.cfgを削除する
			(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
				(vl-file-delete (strcat CG_SYSPATH "Input0.cfg"))
			)

      ;// 自動保存
      (CFAutoSave)

      (setvar "PICKFIRST" 1) ;01/08/24 HN ADD コマンドの発行前にオブジェクトを選択
      (setvar "GRIPS"1) ;グリップを表示

      (command-s ".quit")
		)
	)

) ;KPCAD_FixEnd


;<HOM>*************************************************************************
; <関数名>    : KPCAD_StopEnd
; <処理概要>  : 中断終了処理を行う
; <戻り値>    : T  : 正常終了
;             : nil: 異常終了
; <作成>      : 2011/10/14 (A.Satoh)
; <備考>      : なし
;*************************************************************************>MOH<
(defun KPCAD_StopEnd (
  /
	#cancel #ret
  )

	(setq #cancel nil)

  ; 現在の扉情報等をInput.CFGに書き込む
	(setq #ret (CFOutInputCfg nil))
	(if (= #ret nil)
		(progn
			(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
				(progn
					(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
					(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
				)
			)
			(setq #cancel T)
		)
	)

	(if (= #cancel nil)
		(progn
			; input0.cfgを削除する
			(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
				(vl-file-delete (strcat CG_SYSPATH "Input0.cfg"))
			)

      ;// 自動保存
      (CFAutoSave)

      (setvar "PICKFIRST" 1) ;01/08/24 HN ADD コマンドの発行前にオブジェクトを選択
      (setvar "GRIPS"1) ;グリップを表示

      (command-s ".quit")
		)
	)

) ;KPCAD_StopEnd


;<HOM>*************************************************************************
; <関数名>    : KPCAD_CancelEnd
; <処理概要>  : 破棄終了処理を行う
; <戻り値>    : T  : 中断終了
;             : nil: 破棄終了
; <作成>      : 2011/10/14 (A.Satoh)
; <備考>      : なし
;*************************************************************************>MOH<
(defun KPCAD_CancelEnd (
  /
  #fid
  )

	(if (CFYesNoDialog "図面一式が破棄されます。本当によろしいですか？")
		(progn
			(setq #fid (open (strcat CG_KENMEI_PATH "Cancel.flg") "W"))
			(if #fid
				(progn
					(princ "Cancel.flg\n" #fid)
					(close #fid)

					(command-s ".quit" "Y")
				)
				(progn
					(CFAlertMsg "Cancel.flgの作成に失敗しました。")
				)
			)
		)
	)

) ;KPCAD_CancelEnd
;-- 2011/10/14 A.Satoh Add - E


;-- 2012/01/27 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : KPCAD_CheckErrBuzai
; <処理概要>  : 図面上にG_LSYMが不正に設定された図形を持つ部材が
;             : 存在するか否かのチェックを行う
; <戻り値>    : エラー部材シンボル図形リスト
;             : nil:エラー部材なし
; <作成>      : 2012/01/27 A.Satoh
; <備考>      : なし
;*************************************************************************>MOH<
(defun KPCAD_CheckErrBuzai (
  /
	#ename$ #ss #idx #en #xd_SYM$ #sym
  )

	(setq #ename$ nil)

	; G_LSYMを持つ図形を検索する
	(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
	(if (/= #ss nil)
		(progn
			(setq #idx 0)
			(repeat (sslength #ss)
				(setq #en (ssname #ss #idx))
				(setq #xd_SYM$ (CFGetXData #en "G_SYM"))
				(if (= #xd_SYM$ nil)
					(progn
						(setq #sym (SearchGroupSym #en))
						(setq #ename$ (append #ename$ (list #sym)))
					)
				)
				(setq #idx (1+ #idx))
			)
		)
	)

	#ename$

) ;KPCAD_CheckErrBuzai
;-- 2012/01/27 A.Satoh Add - E

;|

;<HOM>*************************************************************************
; <関数名>    : SearchGroupSym
; <処理概要>  : 指定図形のグループの親図形を検索する
; <戻り値>    :
;       ENAME : 親図形名
; <作成>      : 1999-06-14
; <備考>      : &en がnilなら落ちる-->&en がnilならnilを返す. 00/02/06 @YM@
;*************************************************************************>MOH<
(defun SearchGroupSym (
    &en
    /
;-- 2011/06/27 A.Satoh Mod - S
;    #en #330 #eg #eg$ #lsym #loop #i
    #lsym #eg1$ #eg1 #eg2$ #eg2 #i1 #i2 #loop1 #loop2 #330 #en
;-- 2011/06/27 A.Satoh Mod - E
  )

;-- 2011/06/27 A.Satoh Mod - S
  (setq #lsym nil)
  (if &en
    (progn
      (setq #eg1$ (entget &en))
      (setq #i1 0)
      (setq #loop1 T)
      (while (and #loop1 (< #i1 (length #eg1$)))
        (setq #eg1 (nth #i1 #eg1$))
        (if (= (car #eg1) 330)
          (progn
            (setq #330 (cdr #eg1))
            (if (/= #330 nil)
              (progn
                (setq #eg2$ (entget #330))
                (setq #i2 0)
                (setq #loop2 T)
                (while (and #loop2 (< #i2 (length #eg2$)))
                  (setq #eg2 (nth #i2 #eg2$))
                  (if (= (car #eg2) 340)
                    (progn
                      (setq #en (cdr #eg2))
                      (if (CFGetXData #en "G_SYM")
                        (progn
                          (setq #lsym #en)
                          (setq #loop1 nil)
                          (setq #loop2 nil)
                        )
                      )
                    )
                  )
                  (setq #i2 (1+ #i2))
                )
              )
            )
          )
        )
        (setq #i1 (1+ #i1))
      )
    )
  )

  #lsym

;  (if &en        ; 00/02/06 @YM@ ADD
;    (progn       ; 00/02/06 @YM@ ADD
;      (setq #330 (cdr (assoc 330 (entget &en))))
;      (if (/= #330 nil)
;        (progn
;          (setq #eg$ (entget #330))
;          (setq #i 0)
;          (setq #loop T)
;          (while (and #loop (< #i (length #eg$)))
;            (setq #eg (nth #i #eg$))
;            (if (= (car #eg) 340)
;              (progn
;                (setq #en (cdr #eg))
;                (if (CFGetXData #en "G_SYM")
;                  (progn
;                    (setq #lsym #en)
;                    (setq #loop nil)
;                  )
;                )
;              )
;            )
;            (setq #i (1+ #i))
;          )
;          #lsym
;        )
;        (progn   ; 00/02/06 @YM@ ADD
;          nil    ; 00/02/06 @YM@ ADD
;        )        ; 00/02/06 @YM@ ADD
;      );_(if     ; 00/02/06 @YM@ ADD
;    );_(progn    ; 00/02/06 @YM@ ADD
;    (progn       ; 00/02/06 @YM@ ADD
;      nil        ; 00/02/06 @YM@ ADD
;    );_(progn    ; 00/02/06 @YM@ ADD
;  );_(if &en     ; 00/02/06 @YM@ ADD
;-- 2011/06/27 A.Satoh Mod - E

)
;SearchGroupSym

;-- 2011/06/23 A.Satoh Mod - S
;(setq CFSearchGroupSym SearchGroupSym)
;<HOM>*************************************************************************
; <関数名>    : CFSearchGroupSym
; <処理概要>  : 指定図形のグループの親図形を検索する
; <戻り値>    :
;       ENAME : 親図形名
; <作成>      : 1999-06-14
; <備考>      : &en がnilなら落ちる-->&en がnilならnilを返す. 00/02/06 @YM@
;             : 2011/06/23 SearchGroupSymのコピーにより作成
;             : (setq CFSearchGroupSym SearchGroupSym)の代替
;*************************************************************************>MOH<
(defun CFSearchGroupSym (
    &en
    /
;-- 2011/06/27 A.Satoh Mod - S
;    #en #330 #eg #eg$ #lsym #loop #i
    #lsym #eg1$ #eg1 #eg2$ #eg2 #i1 #i2 #loop1 #loop2 #330 #en
;-- 2011/06/27 A.Satoh Mod - E
  )

;-- 2011/06/27 A.Satoh Mod - S
  (setq #lsym nil)
  (if &en
    (progn
      (setq #eg1$ (entget &en))
      (setq #i1 0)
      (setq #loop1 T)
      (while (and #loop1 (< #i1 (length #eg1$)))
        (setq #eg1 (nth #i1 #eg1$))
        (if (= (car #eg1) 330)
          (progn
            (setq #330 (cdr #eg1))
            (if (/= #330 nil)
              (progn
                (setq #eg2$ (entget #330))
                (setq #i2 0)
                (setq #loop2 T)
                (while (and #loop2 (< #i2 (length #eg2$)))
                  (setq #eg2 (nth #i2 #eg2$))
                  (if (= (car #eg2) 340)
                    (progn
                      (setq #en (cdr #eg2))
                      (if (CFGetXData #en "G_SYM")
                        (progn
                          (setq #lsym #en)
                          (setq #loop1 nil)
                          (setq #loop2 nil)
                        )
                      )
                    )
                  )
                  (setq #i2 (1+ #i2))
                )
              )
            )
          )
        )
        (setq #i1 (1+ #i1))
      )
    )
  )

  #lsym

;  (if &en        ; 00/02/06 @YM@ ADD
;    (progn       ; 00/02/06 @YM@ ADD
;      (setq #330 (cdr (assoc 330 (entget &en))))
;      (if (/= #330 nil)
;        (progn
;          (setq #eg$ (entget #330))
;          (setq #i 0)
;          (setq #loop T)
;          (while (and #loop (< #i (length #eg$)))
;            (setq #eg (nth #i #eg$))
;            (if (= (car #eg) 340)
;              (progn
;                (setq #en (cdr #eg))
;                (if (CFGetXData #en "G_SYM")
;                  (progn
;                    (setq #lsym #en)
;                    (setq #loop nil)
;                  )
;                )
;              )
;            )
;            (setq #i (1+ #i))
;          )
;          #lsym
;        )
;        (progn   ; 00/02/06 @YM@ ADD
;          nil    ; 00/02/06 @YM@ ADD
;        )        ; 00/02/06 @YM@ ADD
;      );_(if     ; 00/02/06 @YM@ ADD
;    );_(progn    ; 00/02/06 @YM@ ADD
;    (progn       ; 00/02/06 @YM@ ADD
;      nil        ; 00/02/06 @YM@ ADD
;    );_(progn    ; 00/02/06 @YM@ ADD
;  );_(if &en     ; 00/02/06 @YM@ ADD
;-- 2011/06/27 A.Satoh Mod - E

)
;SearchGroupSym
;-- 2011/06/23 A.Satoh Mod - E

;<HOM>*************************************************************************
; <関数名>    : SKC_GetSymInGroup
; <処理概要>  : グループ図形の中からシンボル基準点図形を抜き出す
; <戻り値>    : 図形名
; <作成>      : 1998-06-15
; <備考>      : なし
;*************************************************************************>MOH<
(defun SKC_GetSymInGroup (
    &en   ;(ENAME)グループの子図形名
    /
    #eg$
    #lst
    #en$
    #en
    #i
    #loop
  )
  (setq #eg$ (entget (cdr (assoc 330 (entget &en)))))  ;// 親図面情報を取得

  (setq #i 0)
  (setq #loop T)
  (while (and #loop (< #i (length #eg$)))
  ;(foreach #lst #eg$  ;// ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰ図形の取得
    (setq #lst (nth #i #eg$))
    (if (= 340 (car #lst))
      (progn
        (if (or
          (/= nil (assoc -3 (entget (cdr #lst) '("G_SYM"))))
          (/= nil (assoc -3 (entget (cdr #lst) '("G_WRKT"))))
          (/= nil (assoc -3 (entget (cdr #lst) '("G_FILR"))))
          )
          (progn
            (setq #en (cdr #lst))
            (setq #loop nil)
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
  ;// 図形名を返す
  #en
)
;SKC_GetSymInGroup

|;

;<HOM>*************************************************************************
; <関数名>    : SKC_GetSymInGroup
; <処理概要>  : グループ図形の中からシンボル基準点図形を抜き出す
; <戻り値>    : 図形名
; <作成>      : 1998-06-15
; <備考>      : なし
;*************************************************************************>MOH<
(defun SKC_GetSymInGroup (
    &en   ;(ENAME)グループの子図形名
    /
    #eg$
    #lst
    #en$
    #en
    #i
    #loop
  )
;|
  2014.02.06 収納庫のＣＧ作成できない件
             G_SYM取得不備 （最初のデータが、ハッチングの場合取得出来ない
  (setq #eg$ (entget (cdr (assoc 330 (entget &en)))))  ;// 親図面情報を取得
|;
; 
  (setq #eg$ (entget &en))
  (setq #i 0)
  (setq #loop T)
  (while (and #loop (< #i (length #eg$)))
    (setq #lst (nth #i #eg$))
    (if (= 330 (car #lst))
      (progn
        (if (= (cdr (assoc 0 (entget (cdr #lst)))) "GROUP")
          (progn
            (setq #eg$ (entget (cdr #lst)))
            (setq #loop nil)
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
  (setq #i 0)
  (setq #loop T)
  (while (and #loop (< #i (length #eg$)))
  ;(foreach #lst #eg$  ;// ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰ図形の取得
    (setq #lst (nth #i #eg$))
    (if (= 340 (car #lst))
      (progn
        (if (or
          (/= nil (assoc -3 (entget (cdr #lst) '("G_SYM"))))
          (/= nil (assoc -3 (entget (cdr #lst) '("G_WRKT"))))
          (/= nil (assoc -3 (entget (cdr #lst) '("G_FILR"))))
          )
          (progn
            (setq #en (cdr #lst))
            (setq #loop nil)
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
  ;// 図形名を返す
  #en
)
;SKC_GetSymInGroup

;2014/02/10 YM MDO-S 3つの関数を中身統一
(setq CFSearchGroupSym SKC_GetSymInGroup)
(setq SearchGroupSym   SKC_GetSymInGroup)
;2014/02/10 YM MDO-E 3つの関数を中身統一

(princ)
