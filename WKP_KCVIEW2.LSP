(defun C:M1 ()  (Make1ViewPort)     (princ))
;;;;３面ビューポート表示（Ｌ）
(defun C:M3L () (Make3ViewPort "L") (princ))
;;;;３面ビューポート表示（Ｒ）
(defun C:M3R () (Make3ViewPort "R") (princ))
;;;;４面ビューポート表示
(defun C:M4 ()  (Make4ViewPort)     (princ))

;;;<HOM>*************************************************************************
;;; <関数名>    : NRMake1ViewPort
;;; <処理概要>  : 適正な１ビューポートを作成する
;;; <戻り値>    :
;;; <作成>      : 00/02/14 YM 全面修正 00/03/10 (setvar "GRIDMODE" 1)
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun Make1ViewPort (
    /
  )

  (setvar "TILEMODE" 1) ; ﾓﾃﾞﾙﾀﾌﾞ YM
  (setvar "tabmode" 0)
  (command "_vports" "SI") ; ｼﾝｸﾞﾙﾋﾞｭｰ
  (setvar "GRIDMODE" 1) ;00/02/03 HN ADD システム変数変更処理追加  00/03/10 0 ==> 1

  ; 00/04/26 MH DEL 直前のカレントビューポートのままにする
  ;(SKChgView "0,0,1") ; 平面図にする

	;04/05/26 YM ADD
	(command "_REGEN")

  ;// UCSアイコンの非表示
  (command "_UCSICON" "A" "OF") ;UCSアイコンの非表示
)
;Make1ViewPort

;;;<HOM>*************************************************************************
;;; <関数名>    : NRMake3ViewPort
;;; <処理概要>  : 適正な3ビューポートを作成する
;;; <戻り値>    :
;;; <作成>      : 00/02/14 YM 全面修正
;;; <備考>      :
;;;ID_SKVpointTop [_Button("平面図", "ICON_16_VIETOP", "ICON_24_VIETOP")]^C^C^P(SKChgView "0,0,1") ^P
;;;ID_SKVpointBot [_Button("下面図", "ICON_16_VIEBOT", "ICON_24_VIEBOT")]^C^C^P(SKChgView "0,0,-1") ^P
;;;ID_SKVpointLef [_Button("左側面図", "ICON_16_VIELEF", "ICON_24_VIELEF")]^C^C^P(SKChgView "-1,0,0") ^P
;;;ID_SKVpointRig [_Button("右側面図", "ICON_16_VIERIG", "ICON_24_VIERIG")]^C^C^P(SKChgView "1,0,0") ^P
;;;ID_SKVpointFro [_Button("正面図", "ICON_16_VIEFRO", "ICON_24_VIEFRO")]^C^C^P(SKChgView "0,-1,0") ^P
;;;ID_SKVpointBac [_Button("背面図", "ICON_16_VIEBAC", "ICON_24_VIEBAC")]^C^C^P(SKChgView "0,1,0") ^P
;;;               [--]
;;;ID_SKVpointSW  [_Button("南西等角図", "ICON_16_VIESWI", "ICON_24_VIESWI")]^C^C^P(SKChgView "-2,-2,1") ^P
;;;ID_SKVpointSE  [_Button("南東等角図", "ICON_16_VIESEI", "ICON_24_VIESEI")]^C^C^P(SKChgView "2,-2,1") ^P
;;;ID_SKVpointNE  [_Button("北東等角図", "ICON_16_VIENEI", "ICON_24_VIENEI")]^C^C^P(SKChgView "1,1,1") ^P
;;;ID_SKVpointNW  [_Button("北西等角図", "ICON_16_VIENWI", "ICON_24_VIENWI")]^C^C^P(SKChgView "-1,1,1") ^P
;;;        |
;;;  正面  |
;;;________|  南東
;;;        |
;;;  平面  |
;;;        |
;;;
;;;|       |
;;;|       |  正面
;;;| 南東  |________
;;;|       |
;;;|       |  平面
;;;|       |

;*************************************************************************>MOH<
(defun Make3ViewPort (
    &lr       ;(STR)右左判定　"R" "L"
    /
    #os #vp #view$ #cv #cv2 #pt
  )

  (setq #vp (list "1,0,0" "0,-1,0" "0,0,1"  "2,-2,1")) ; 右側面,正面,平面,南東等角図

  (setvar "TILEMODE" 1) ; ﾓﾃﾞﾙﾀﾌﾞ YM
  (setvar "tabmode" 0)
  (command "_vports" "SI") ; ｼﾝｸﾞﾙﾋﾞｭｰ
  (setvar "GRIDMODE" 0) ;00/02/03 HN ADD システム変数変更処理追加

  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)

  (cond
    ((= &lr "L")    ;左が大画面
      (command "_vports" "3" &lr)

      (foreach #view$ (vports)
        (setq #cv (car  #view$))
        (setq #pt (cadr #view$))
        (cond
          ((equal #pt (list 0.5 0.5) 0.01);右上ビュー 正面
           (setvar "cvport" #cv)
           (SKChgView (nth 1 #vp))
           (setvar "GRIDMODE" 0) ;00/02/03 HN ADD システム変数変更処理追加
          )
          ((equal #pt (list 0.0 0.0) 0.01);左ビュー 南東
           (setvar "cvport" #cv)
           (setq #cv2 #cv)
           (SKChgView (nth 3 #vp))
           (setvar "GRIDMODE" 0) ;00/02/03 HN ADD システム変数変更処理追加
          )
          ((equal #pt (list 0.5 0.0) 0.01);右下ビュー 平面
           (setvar "cvport" #cv)
           (SKChgView (nth 2 #vp))
           (setvar "GRIDMODE" 1) ;00/02/03 HN ADD システム変数変更処理追加
          )
        );_(cond
      );_(foreach

    )
    ((= &lr "R")    ;右が大画面
      (command "_vports" "3" &lr)

      (foreach #view$ (vports)
        (setq #cv (car  #view$))
        (setq #pt (cadr #view$))
        (cond
          ((equal #pt (list 0.0 0.5) 0.01);左上ビュー 正面
           (setvar "cvport" #cv)
           (SKChgView (nth 1 #vp))
           (setvar "GRIDMODE" 0) ;00/02/03 HN ADD システム変数変更処理追加
          )
          ((equal #pt (list 0.0 0.0) 0.01);左下ビュー 平面
           (setvar "cvport" #cv)
           (SKChgView (nth 2 #vp))
           (setvar "GRIDMODE" 1) ;00/02/03 HN ADD システム変数変更処理追加
          )
          ((equal #pt (list 0.5 0.0) 0.01);右ビュー 南東
           (setvar "cvport" #cv)
           (setq #cv2 #cv)
           (SKChgView (nth 3 #vp))
           (setvar "GRIDMODE" 0) ;00/02/03 HN ADD システム変数変更処理追加
          )
        );_(cond
      );_(foreach

    )
  );_(cond

  (setvar "cvport" #cv2)
  (setvar "OSMODE" #os)

	;04/05/26 YM ADD
	(command "_REGEN")

  ;// UCSアイコンの非表示
  (command "_UCSICON" "A" "OF") ;UCSアイコンの非表示
)
;Make3ViewPort

;;;<HOM>*************************************************************************
;;; <関数名>    : NRMake4ViewPort
;;; <処理概要>  : 適正な４ビューポートを作成する
;;; <戻り値>    :
;;; <作成>      : 00/02/14 YM 全面修正
;;; <備考>      :
;;;        |
;;;  正面  | 右側面
;;;________|________
;;;        |
;;;  平面  |  南東
;;;        |
;;;*************************************************************************>MOH<
(defun Make4ViewPort (
    /
    #os #vp #view$ #cv #cv2 #pt
  )

  (setq #vp (list "1,0,0" "0,-1,0" "0,0,1"  "2,-2,1")) ; 右側面,正面,平面,南東

  (setvar "TILEMODE" 1) ; ﾓﾃﾞﾙﾀﾌﾞ YM
  (setvar "tabmode" 0)
  (command "_vports" "SI") ; ｼﾝｸﾞﾙﾋﾞｭｰ
  (setvar "GRIDMODE" 0) ;00/02/03 HN ADD システム変数変更処理追加

  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)

  ;// ﾋﾞｭｰﾎﾟｰﾄを作成し、視点を設定する
  (command "_vports" "4" ) ; 4分割

  (foreach #view$ (vports)
    (setq #cv (car  #view$))
    (setq #pt (cadr #view$))
    (cond
      ((equal #pt (list 0.5 0.5) 0.01);右上ビュー 右側面
       (setvar "cvport" #cv)
       (SKChgView (nth 0 #vp))
       (setvar "GRIDMODE" 0) ;00/02/03 HN ADD システム変数変更処理追加
      )
      ((equal #pt (list 0.0 0.5) 0.01);左上ビュー 正面
       (setvar "cvport" #cv)
       (SKChgView (nth 1 #vp))
       (setvar "GRIDMODE" 0) ;00/02/03 HN ADD システム変数変更処理追加
      )
      ((equal #pt (list 0.0 0.0) 0.01);左下ビュー 平面
       (setvar "cvport" #cv)
       (SKChgView (nth 2 #vp))
       (setvar "GRIDMODE" 1) ;00/02/03 HN ADD システム変数変更処理追加
      )
      ((equal #pt (list 0.5 0.0) 0.01);右下ビュー 南東
       (setvar "cvport" #cv)
       (setq #cv2 #cv)
       (SKChgView (nth 3 #vp))
       (setvar "GRIDMODE" 0) ;00/02/03 HN ADD システム変数変更処理追加
      )
    );_(cond
  );_(foreach

  (setvar "cvport" #cv2)
  (setvar "OSMODE" #os)

	;04/05/26 YM ADD
	(command "_REGEN")

  ;// UCSアイコンの非表示
  (command "_UCSICON" "A" "OF") ;UCSアイコンの非表示
)
;Make4ViewPort

;;;<HOM>*************************************************************************
;;; <関数名>    : GetViewSize
;;; <処理概要>  : 現在のビューの最大、最小の座標を求める
;;; <戻り値>    :
;;;        LIST : 1.最小 x 値
;;;             : 2.最大 x 値
;;;             : 3.最小 y 値
;;;             : 4.最大 y 値
;;; <作成>      : 99-12-20
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun GetViewSize (
    /
    #vctr #vsize #ssize #x #xmin #xmax #ymin #ymax
  )

  (setq #vctr  (getvar "VIEWCTR"))    ; 現在のビューポート内のビューの中心を格納します。UCS 座標で表現 '(5.72083 4.00833 0.0)
  (setq #vsize (getvar "VIEWSIZE"))   ; 現在のビューポートのビューの高さを格納します。作図単位で表現 '8.74613
  (setq #ssize (getvar "SCREENSIZE")) ; 現在のビューポートのサイズ (X 方向および Y 方向)をピクセル数で格納します。'(1179.0 692.0)
  (setq #x (/ (* #vsize (car #ssize)) (cadr #ssize))) ; '(-1.72981 13.1715 -0.364733 8.3814)

  (setq #xmin (- (car  #vctr) (/ #x 2)))
  (setq #xmax (+ (car  #vctr) (/ #x 2)))
  (setq #ymin (- (cadr #vctr) (/ #vsize 2)))
  (setq #ymax (+ (cadr #vctr) (/ #vsize 2)))

  ;// 値を帰す
  (list #xmin #xmax #ymin #ymax) ; '(-1.72981 13.1715 -0.364733 8.3814)
)
;GetViewSize

;;;<HOM>*************************************************************************
;;; <関数名>    : SKAllFitVp
;;; <処理概要>  : 3 or 4ビューの表示を全て最適化する
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun SKAllFitVp (
    /
    #vid
    #os
  )

  (if (> 3 (length (vports)))
    (progn
      (command "_zoom" "e")
;;;      (command "_zoom" "0.9x") ; 06/05 YM
    )
  ;else
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (setq #vid (getvar "CVPORT"))
      (foreach #view$ (vports)
        (if (/= (car #view$) 1)
          (progn
            (setvar "CVPORT" (car #view$))
            (command "_zoom" "e")
;;;            (command "_zoom" "0.9x") ; 06/05 YM
          )
        )
      )
      (setvar "CVPORT" #vid) ; 最初のﾋﾞｭｰに戻す
      (setvar "OSMODE" #os)
    )
  )
  (princ)
)
;SKAllFitVp
(defun C:AllFitVp ()(SKAllFitVp));00/06/29 SN ADD

;<HOM>*************************************************************************
; <関数名>    : MakeWorkView
; <処理概要>  : ワークビューを作成する
; <備考>      :
;*************************************************************************>MOH<
(defun MakeWorkView (
    /
    #viewEn
    #os #gr #sn
    #res$
    #xmax #ymax
    #wid
  )
  ;// システム変数を設定
  (setq #os (getvar "OSMODE"))
  (setq #gr (getvar "GRIDMODE"))
  (setq #sn (getvar "SNAPMODE"))
  (setvar "OSMODE"   0)
  (setvar "GRIDMODE" 0)
  (setvar "SNAPMODE" 0)
  (command "_.UCSICON" "A" "OF")  ;UCSアイコンを全て非表示

  (if (= 0 (getvar "TILEMODE"))
    (progn
      ;// ビューのサイズを取得する
      (command "_.pspace")
      (setvar "SNAPMODE" 0)
      (setvar "OSMODE"   0)
      (setvar "GRIDMODE" 0)

      (setq #res$ (GetViewSize))
      (setq #xmax (nth 1 #res$))
      (setq #ymax (nth 3 #res$))
      (setq #xwid (/ (- #xmax (car #res$)) 10.))
      (setq #ywid (/ (- #ymax (nth 2 #res$)) 10.))

      (command "_.mview" (list #xmax #ymax) (list (- #xmax #xwid) (- #ymax #ywid)))
      (setq #viewEn (entlast))
      (command "_.mspace")
      (command "_.vpoint" "0,0,1")
      ;(setvar "OSMODE"   0)
      ;(setvar "GRIDMODE" 0)
      ;(setvar "SNAPMODE" 0)
    )
  )
  ;// システム変数を元に戻す
  (setvar "OSMODE"   #os)
  (setvar "GRIDMODE" #gr)
  (setvar "SNAPMODE" #sn)

  #viewEn
)
;MakeWorkView

(princ)

