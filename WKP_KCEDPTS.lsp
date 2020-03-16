;;; 関数検索用
;;;(defun PKStartCOMMAND ( / )
;;;(defun PKEndCOMMAND ( &lst / )

; 編集コマンド
;;;(defun C:MoveParts
;;;(defun Move
;;;(defun C:SurfaceMoveParts
;;;(defun SurfaceMove
;;;(defun C:RotateParts
;;;(defun Rotate
;;;(defun C:CopyParts
;;;(defun Copy
;;;(defun C:CopyRotateParts
;;;(defun CopyRotate
;;;(defun C:Z_MoveParts
;;;(defun Z_Move
;;;(defun C:Z_CopyParts
;;;(defun Z_Copy

; <関数名>    : C:RotateCAB その場でｷｬﾋﾞﾈｯﾄを回転させる(正面、背面が入れ替わる)
; <関数名>    : PcCabCutCall 選択したｷｬﾋﾞﾈｯﾄ部材の底をカットするコマンド(呼び出し用)


; H800 伸縮処理

;;;(defun PcCabCutSub
;;;(defun PcRemakePrim_CabCut
;;;(defun PcSlice_Down

;;;<HOM>*************************************************************************
;;; <関数名>    : PKStartCOMMAND
;;; <処理概要>  : ｼｽﾃﾑ変数の設定
;;; <引数>      : なし
;;; <戻り値>    : ｼｽﾃﾑ変数ﾘｽﾄ
;;; <作成>      : 2000.6.9 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKStartCOMMAND ( / #sm)

;;; ｼｽﾃﾑ変数設定
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (setq #sm (getvar "SNAPMODE" ))
  (setvar "SNAPMODE"  0)
  (list #sm)
);PKStartCOMMAND

;;;<HOM>*************************************************************************
;;; <関数名>    : PKEndCOMMAND
;;; <処理概要>  : ｼｽﾃﾑ変数の設定を戻す
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.9 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKEndCOMMAND ( &lst / #sm)
;;; ｼｽﾃﾑ変数設定を戻す
  (setq #sm (nth 0 &lst))
  (setvar "SNAPMODE" #sm)
  (princ)
);PKEndCOMMAND

;<HOM>*************************************************************************
; <関数名>    : C:MoveParts
; <処理概要>  : 設備移動コマンド
; <戻り値>    :
; <作成>      : 1999-12-2
; <備考>      :
;*************************************************************************>MOH<
(defun C:MoveParts(
  /
  #ss             ; 選択したすべてのグループの選択セット(移動対象)
#SYS$ #RET$
  )
  (StartUndoErr);00/10/02 SN MOD UNDO処理関数変更
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  ;00/09/22 SN MOD ｱｲﾃﾑ選択関数を変更
  (setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_ConfSymCol))
  ;00/09/22 SN MOD 選択ｾｯﾄのｵﾌﾞｼﾞｪｸﾄ数をﾁｪｯｸする。
  (if (> (sslength #ss) 0)
		(progn
	    (setq #ret$ (Move #ss))                         ; 要素の移動 基点,目的点ﾘｽﾄ
			; "G_LSYM"(挿入点)更新 01/04/27 YM 高速化
	    (ChgLSYM1 #ss)
	    (SetG_WRKT "MOVE" #ss (car #ret$)(cadr #ret$)) ; "G_WRKT"(WT左上点)拡張データの変更
  	)
	);_if
  (setq *error* nil)                              ; 後処理
  (setq EditFlag nil)
  (CFCmdDefFinish);00/09/13 SN ADD
  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
	(princ "\n移動しました。")
  (princ)
);C:MoveParts

;<HOM>*************************************************************************
; <関数名>    : Move
; <処理概要>  : 設備移動
; <戻り値>    : なし
; <作成>      : 1999-12-2
; <備考>      :
;*************************************************************************>MOH<
(defun Move(
  &ss
  /
  #bpt            ; 移動の基点
  #lpt            ; 移動点
  #org            ; 元の挿入点
  #os #SS
  )

  (setq #bpt (getpoint "\n基点 : "))
  (princ "\n目的点: ")

  ;00/09/22 SN MOD 色戻し処理別関数
  (ChangeItemColor &ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; 色を戻す
  ;)

  (setq EditFlag 1)
        ;;; 06/21 SN MOD 基準ｱｲﾃﾑ無しの時移動不可の不具合正
  (if (and (CFGetXRecord "BASESYM")                          ; 基準ｱｲﾃﾑが未設定
      (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss)) ; 基準ｱｲﾃﾑが &ss に入っていた
  ;;; 06/10 YM ADD 基準ｱｲﾃﾑの場合矢印も移動
  ;(if (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss) ; 基準ｱｲﾃﾑが &ss に入っていた
    (progn
      (setq #ss (ssget "X" '((-3 ("G_ARW"))))) ; 矢印も移動する
      (CMN_ssaddss #ss &ss)
    )
  );_if

  (command ".MOVE" &ss "" #bpt PAUSE)
  (setq #lpt (getvar "LASTPOINT"))
  (if (= nil (equal (caddr #lpt) (caddr #bpt) 0.0001))
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command ".MOVE" &ss "" "0,0,0" (list 0 0 (- (caddr #bpt) (caddr #lpt))))
      (setvar "OSMODE" #os)
    );_progn
  );_if
  (list #bpt #lpt) ; 基点,目的点ﾘｽﾄ
)

;<HOM>*************************************************************************
; <関数名>    : C:SurfaceMoveParts
; <処理概要>  : 設備面合わせ移動コマンド
; <戻り値>    :
; <作成>      : 1999-12-2 YM
; <備考>      :
;*************************************************************************>MOH<
(defun C:SurfaceMoveParts(
  /
  #v_angbase
  #v_angdir
  #ss             ; 選択したすべてのグループの選択セット(移動対象)
  #sa_ang         ; 回転角度
#SYS$
  )
  (StartUndoErr);00/10/02 SN MOD UNDO処理関数変更
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  (setq #v_angbase (getvar "ANGBASE"))
  (setvar "ANGBASE" 0)                         ; ANGBASEのデフォルト化
  (setq #v_angdir (getvar "ANGDIR"))
  (setvar "ANGDIR" 0)                          ; ANGDIRのデフォルト化
  ;00/09/22 SN MOD ｱｲﾃﾑ選択関数を変更
  (setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
  ;00/09/22 SN MOD 選択ｾｯﾄのｵﾌﾞｼﾞｪｸﾄ数をﾁｪｯｸする。
  (if (> (sslength #ss) 0)
		(progn
	    (setq #sa_ang (SurfaceMove #ss))             ; 要素の移動
 			; "G_LSYM"(挿入点,回転角度)更新 01/04/27 YM
	    (ChgLSYM12 #ss #sa_ang) ; 高速化

	    (setvar "ANGBASE" #v_angbase)                ; ANGBASEを戻す
	    (setvar "ANGDIR" #v_angdir)                  ; ANGDIRを戻す
  	)
	);end if - progn
  (setq *error* nil)                           ; 後処理
  (setq EditFlag nil)
  (CFCmdDefFinish);00/09/13 SN ADD
  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
	(princ "\n面合わせしました。")
  (princ)

);_(defun

;<HOM>*************************************************************************
; <関数名>    : SurfaceMove
; <処理概要>  : 設備面合わせ移動
; <戻り値>    : 回転角度
; <作成>      : 1999-12-2 YM
; <備考>      :
;*************************************************************************>MOH<
(defun SurfaceMove(
  &ss
  /
  #sa_ang         ; 回転角度
  #bpt            ; 移動の基点(1)
  #rpt            ; 移動元面合わせ方向(2)
  #rptn           ; #rptに対応する点
  #lpt            ; 移動先基準点(3)
  #os
  #pt1            ; 回転前参照点
  #pt2            ; 回転後参照点
  #en_cf #SS
  #bsym           ; 00/08/22 SN ADD 基準ｱｲﾃﾑ
#hand #sym ;-- 2012/03/08 A.Satoh Add 配置角度設定不正の対応
  )

  (initget 1)
  (setq #bpt (getpoint "\n移動元基準点: "))            ; (1)
  (initget 1)
  (setq #rpt (getpoint #bpt "\n移動元面合わせ方向: ")) ; (2) #bptからラバーバンドを引く.
  (princ "\n移動先基準点: ")

  ;00/09/22 SN MOD 色戻し処理別関数
  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; 色を戻す
  ;)
  (setq EditFlag 1)
  ;;; 06/10 YM ADD 基準ｱｲﾃﾑの場合矢印も動
  ; 00/08/22 SN MOD 基準ｱｲﾃﾑの存在を事前ﾁｪｯｸ
  (if (and (setq #bsym (car (CFGetXRecord "BASESYM"))); 基準ｱｲﾃﾑ設定あり 且つ
      (ssmemb (handent #bsym) &ss))                   ; 基準ｱｲﾃﾑが &ss に入っていた
;  (if (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss) ; 基準ｱｲﾃﾑが &ss に入っていた
    (progn
      (setq #ss (ssget "X" '((-3 ("G_ARW"))))) ; 矢印も移動する
      (CMN_ssaddss #ss &ss)
    )
  );_if

  (command ".MOVE" &ss "" #bpt PAUSE)
  (setq #lpt (getvar "LASTPOINT"))                      ; (3)

  (if (= nil (equal (caddr #lpt) (caddr #bpt) 0.0001))
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command ".MOVE" &ss "" "0,0,0" (list 0 0 (- (caddr #bpt) (caddr #lpt)))) ; 基点のｚ座標に合わせる.
      (setvar "OSMODE" #os)
    ); _progn
  );_if

  (setq #rptn (mapcar '+ #rpt (mapcar '- #lpt #bpt)))

  (princ "\n移動先面合わせ方向: ")
  ;;; 回転前参照点 ;;;
;-- 2012/03/08 A.Satoh Mod 配置角度設定不正の対応 - S
;;;;;  (setq #pt1 (cdr (assoc 10 (entget (SearchGroupSym (ssname &ss 0))))))
	(setq #sym (SearchGroupSym (ssname &ss 0)))
  (setq #pt1 (cdr (assoc 10 (entget #sym))))
  (setq #hand (cdr (assoc 5 (entget #sym))))
;-- 2012/03/08 A.Satoh Mod 配置角度設定不正の対応 - E
  (setq #en_cf nil)
  (if (< (distance #pt1 #lpt) 0.1)                                        ; 基点が親図形点と同じ場合
    (progn
      (setq #pt1 (mapcar '+ #pt1 '(50.0 50.0 0.0)))                       ; 参照点の平行移動
      (entmake (list (cons 0 "POINT") (cons 62 2) (list 10 (car #pt1) (cadr #pt1) (caddr #pt1)) )) ; 参照点を図面に作成
      (setq #en_cf (entlast))
      (setq &ss (ssadd #en_cf &ss)) ; 作成した参照点も一緒に回転する.
    );_(progn
  );if

  (command ".ROTATE" &ss "" #lpt "R" #lpt #rptn PAUSE)
  ;;; 回転後参照点 ;;;
;-- 2012/03/08 A.Satoh Mod 配置角度設定不正の対応 - S
;;;;;  (setq #pt2 (cdr (assoc 10 (entget (SearchGroupSym (ssname &ss 0))))))
	(if (= (handent #hand) nil)
		(setq #pt2 (cdr (assoc 10 (entget (SearchGroupSym (ssname &ss 0))))))
  	(setq #pt2 (cdr (assoc 10 (entget (handent #hand)))))
	)
;-- 2012/03/08 A.Satoh Mod 配置角度設定不正の対応 - E
  (if #en_cf
    (progn
      (setq #pt2 (cdr (assoc 10 (entget #en_cf))))
      (entdel #en_cf) ; 参照点を削除
    );_(progn
  );if

  (setq #sa_ang (- (angle #lpt #pt2) (angle #lpt #pt1))) ; 回転前参照点,回転後参照点の角度差

)

;<HOM>*************************************************************************
; <関数名>    : C:RotateParts
; <処理概要>  : 設備回転コマンド
; <戻り値>    :
; <作成>      : 1999-12-2 YM
; <備考>      :
;*************************************************************************>MOH<
(defun C:RotateParts(
  /
  #v_angbase
  #v_angdir
  #ss             ; 選択したすべてのグループの選択セット(回転対象)
  #sa_ang         ; 回転角度
#sys$ #BPT #RET$
  )
  (StartUndoErr);00/10/02 SN MOD UNDO処理関数変更
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  (setq #v_angbase (getvar "ANGBASE"))
  (setvar "ANGBASE" 0)                         ; ANGBASEのデフォルト化
  (setq #v_angdir (getvar "ANGDIR"))
  (setvar "ANGDIR" 0)                          ; ANGDIRのデフォルト化
  ;00/09/22 SN MOD ｱｲﾃﾑ選択関数を変更
  (setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_ConfSymCol)) ; WTも対象 01/04/27 YM MOD
  ;00/09/22 SN MOD 選択ｾｯﾄのｵﾌﾞｼﾞｪｸﾄ数をﾁｪｯｸする。
  (if (> (sslength #ss) 0)
		(progn
	    (setq #ret$ (Rotate #ss))  ; 要素の回転
	    (setq #bpt    (car  #ret$)) ; 基点
	    (setq #sa_ang (cadr #ret$)) ; 角度
 			; "G_LSYM"(挿入点,回転角度)更新 01/04/27 YM
	    (ChgLSYM12 #ss #sa_ang) ; 高速化

	    (SetG_WRKT "ROT" #ss (car #ret$)(cadr #ret$)) ; "G_WRKT"(WT左上点)拡張データの変更

	    (setvar "ANGBASE" #v_angbase)                ; ANGBASEを戻す
	    (setvar "ANGDIR" #v_angdir)                  ; ANGDIRを戻す
  	)
	);end if - progn
  (setq *error* nil)                           ; 後処理
  (setq EditFlag nil)
  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
  (CFCmdDefFinish);00/09/13 SN ADD
	(princ "\n回転しました。")
  (princ)
);C:RotateParts

;<HOM>*************************************************************************
; <関数名>    : Rotate
; <処理概要>  : 設備回転
; <戻り値>    : 回転角度
; <作成>      : 1999-12-2 YM
; <備考>      :
;*************************************************************************>MOH<
(defun Rotate(
  &ss
  /
  #sa_ang         ; 回転角度
  #bpt            ; 基点
  #pt1            ; 回転前参照点
  #pt2            ; 回転後参照点
  #en_cf #ss #num #I #LOOP #SYM
#hand ;-- 2012/03/08 A.Satoh Add 配置角度設定不正の対応
  )

  ;;; 回転前参照点 ;;;
	(setq #i 0 #loop T)
	(while (and #loop (< #i (sslength &ss)))
		(if (setq #sym (SearchGroupSym (ssname &ss #i)))
			(progn
		  	(setq #pt1 (cdr (assoc 10 (entget #sym))))
;-- 2012/03/08 A.Satoh Add 配置角度設定不正の対応 - S
				(setq #hand (cdr (assoc 5 (entget #sym))))
;-- 2012/03/08 A.Satoh Add 配置角度設定不正の対応 - E
				(setq #loop nil)
				(setq #num #i)
			)
		);_if
		(setq #i (1+ #i))
	)
	(if #loop
		(progn
			(CFAlertMsg "キャビネットが含まれていないので回転できません。")
			(quit)
		)
	);_if

  (setq #bpt (getpoint "\n基点: "))
	(princ "\n回転角度: ") ; 01/05/10 YM ADD

  ;00/09/22 SN MOD 色戻し処理別関数
;;;01/04/27YM@  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
  (ChangeItemColor &ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; 色を戻す
  ;)
  (setq EditFlag 1)
  (setq #en_cf nil)
  (if (< (distance #pt1 #bpt) 0.1)                                        ; 基点が親図形点と同じ場合
    (progn
      (setq #pt1 (mapcar '+ #pt1 '(50.0 50.0 0.0)))                       ; 参照点の平行移動
      (entmake (list (cons 0 "POINT") (cons 62 2) (list 10 (car #pt1) (cadr #pt1) (caddr #pt1)) )) ; 参照点を図面に作成
      (setq #en_cf (entlast))
      (setq &ss (ssadd #en_cf &ss)) ; 作成した参照点も一緒に回転する.
    );_(progn
  );if

  ;;; 06/21 SN MOD 基準ｱｲﾃﾑ無しの時移動不可の不具合正
  (if (and (CFGetXRecord "BASESYM")                          ; 基準ｱｲﾃﾑが未設定
      (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss)) ; 基準ｱｲﾃﾑが &ss に入っていた
    (progn
      (setq #ss (ssget "X" '((-3 ("G_ARW"))))) ; 矢印も移動する
      (CMN_ssaddss #ss &ss)
    )
  );_if

  (command ".ROTATE" &ss "" #bpt PAUSE)
  ;;; 回転後参照点 ;;;
;-- 2012/03/08 A.Satoh Mod 配置角度設定不正の対応 - S
;;;;;  (setq #pt2 (cdr (assoc 10 (entget (SearchGroupSym (ssname &ss #num))))))
	(if (= (handent #hand) nil)
		(setq #pt2 (cdr (assoc 10 (entget (SearchGroupSym (ssname &ss #num))))))
  	(setq #pt2 (cdr (assoc 10 (entget (handent #hand)))))
	)
;-- 2012/03/08 A.Satoh Mod 配置角度設定不正の対応 - E
  (if #en_cf
    (progn
      (setq #pt2 (cdr (assoc 10 (entget #en_cf))))
      (entdel #en_cf) ; 参照点を削除
    );_(progn
  );if

  (setq #sa_ang (- (angle #bpt #pt2) (angle #bpt #pt1)))      ; 回転前参照点,回転後参照点の角度差
	(list #bpt #sa_ang) ; 基点,角度
);Rotate


;-- 2012/03/19 A.Satoh Mod コピーコマンドエラー対応 - S
;;;;;;<HOM>*************************************************************************
;;;;;; <関数名>    : C:CopyParts
;;;;;; <処理概要>  : 設備コピーコマンド
;;;;;; <戻り値>    :
;;;;;; <作成>      : 1999-12-2 YM
;;;;;; <備考>      :
;;;;;;*************************************************************************>MOH<
;;;;;(defun C:CopyParts(
;;;;;  /
;;;;;  #ss             ; 選択したすべてのグループの選択セット(コピー対象)
;;;;;  #ss2            ; コピーした図形の選択セット
;;;;;  #en_lis_#ss     ; コピー前図形名リスト
;;;;;  #en_lis_#ss2    ; コピー後図形名リスト
;;;;;#sys$
;;;;;  )
;;;;;
;;;;;  (StartUndoErr);00/10/02 SN MOD UNDO処理関数変更
;;;;;  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
;;;;;  (CFCmdDefBegin 6);00/09/13 SN ADD
;;;;;  ;00/09/22 SN MOD ｱｲﾃﾑ選択関数を変更
;;;;;  (setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
;;;;;;;;  (setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_ConfSymCol))
;;;;;  ;00/09/22 SN MOD 選択ｾｯﾄのｵﾌﾞｼﾞｪｸﾄ数をﾁｪｯｸする。
;;;;;  (if (> (sslength #ss) 0)
;;;;;		(progn
;;;;;	    (setq #ss2 (Copy #ss))                       ; 要素のコピー
;;;;;	    (setq #en_lis_#ss  (CMN_ss_to_en  #ss))      ; コピー前選択セットを渡して図形名のリストを得る.
;;;;;	    (setq #en_lis_#ss2 (CMN_ss_to_en #ss2))      ; コピー後選択セットを渡して図形名のリストを得る.
;;;;;	    (SetG_PRIM22 #en_lis_#ss #en_lis_#ss2)       ; "G_PRIM"(底面図形)拡張データの変更
;;;;;	    (SetG_BODY   #en_lis_#ss #en_lis_#ss2)       ; "G_BODY"(穴図形)拡張データの変更
;;;;;;;;01/05/01YM@	    (SetG_LSYM11 #en_lis_#ss #en_lis_#ss2)       ; "G_LSYM"(挿入点)拡張データの変更
;;;;;	    (ChgLSYM1_copy #en_lis_#ss #en_lis_#ss2)       ; "G_LSYM"(挿入点)拡張データの変更 01/05/01 YM 高速化
;;;;;			(AfterCopySetDoorGroup #en_lis_#ss #en_lis_#ss2) ; 01/08/31 YM "ADD DoorGroup" のｾｯﾄ
;;;;;
;;;;;  	)
;;;;;	);end if - progn
;;;;;  (setq *error* nil)                           ; 後処理
;;;;;  (setq EditFlag nil)
;;;;;  (CFCmdDefFinish);00/09/13 SN ADD
;;;;;  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
;;;;;	(princ "\nコピーしました。")
;;;;;  (princ)
;;;;;
;;;;;);_(defun
;;;;;
;;;;;
;<HOM>*************************************************************************
; <関数名>    : C:CopyParts
; <処理概要>  : 設備コピーコマンド
; <戻り値>    :
; <作成>      : 2012/03/15 A.Satoh
; <備考>      : 旧コピーコマンドでは、属性情報の内容により正常にコピー
;             : できない部材がある為、新規に作り直し
;*************************************************************************>MOH<
(defun C:CopyParts(
  /
	#cmdecho #osmode #pickstyle #sys$ #ss #cp_list$ #idx #sym$ #sym #fig$ #en
	#ItemInfo$ #ins_pt$ #ang #w_brk$ #d_brk$ #h_brk$
	)

	;****************************************************
	; エラー処理
	;****************************************************
	(defun CopyPartsUndoErr( &msg )
		(command "_undo" "b")
		(CFCmdDefFinish)
		(setq *error* nil)
		(princ)
	)
	;****************************************************

	(setq *error* CopyPartsUndoErr)
	(setq #cmdecho (getvar "CMDECHO"))
	(setq #osmode (getvar "OSMODE"))
	(setq #pickstyle (getvar "PICKSTYLE"))
	(setvar "CMDECHO" 0)
	(setvar "OSMODE" 0)
	(setvar "PICKSTYLE" 0)
	(command "_undo" "M")
	(command "_undo" "a" "off")

	(setq #sys$ (PKStartCOMMAND))
	(CFCmdDefBegin 6)

	; コピーするアイテムの選択
	(setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
	(if (> (sslength #ss) 0)
		(progn
			; 選択図形のコピー処理を行う
			; 　配置基点を求める為に図形を仮作成する。
			; 　仮作成した図形は、配置基点取得後に削除する。
			; 返り値：コピー情報リスト
			;   ((基点座標リスト "G_LSYM"情報リスト) () () ・・・)
			(setq #cp_list$ (CopyParts_Copy #ss))

			; 選択したアイテムからシンボル基点リストを作成する
			(setq #idx 0)
			(setq #sym$ nil)
			(repeat (sslength #ss)
				(if (CFGetXData (ssname #ss #idx) "G_LSYM")
					(if (not (member (ssname #ss #idx) #sym$))
						(setq #sym$ (append #sym$ (list (ssname #ss #idx))))
					)
				)
				(setq #idx (1+ #idx))
			)

			(setq #idx 0)
			(repeat (length #sym$)
				; コピー元図形のグループシンボルを取り出す
				(setq #sym (nth #idx #sym$))

				; 品番情報を作成する
				(setq #ItemInfo$ (CopyParts_GetItemInfo #sym #cp_list$))

				; シンボル配置
				(setq #fig$    (nth 0 #ItemInfo$))
				(setq #ins_pt$ (nth 1 #ItemInfo$))
				(setq #ang     (nth 2 #ItemInfo$))
				(setq #w_brk$  (nth 3 #ItemInfo$))
				(setq #d_brk$  (nth 4 #ItemInfo$))
				(setq #h_brk$  (nth 5 #ItemInfo$))

				; シンボルの配置を行う
				(CopyParts_PcSetItem #fig$ #ins_pt$ #ang #sym #w_brk$ #d_brk$ #h_brk$)

				(setq #idx (1+ #idx))
			)
		)
	)

	; 終了処理
	(CFCmdDefFinish)
	(PKEndCOMMAND #sys$)
	(setvar "CMDECHO" #cmdecho)
	(setvar "OSMODE" #osmode)
  (setvar "PICKSTYLE" #pickstyle)
	(setq *error* nil)
	(princ "\nコピーしました。")
	(princ)

) ; C:CopyParts
;-- 2012/03/15 A.Satoh Mod コピーコマンドエラー対応 - E


;-- 2012/03/15 A.Satoh Add コピーコマンドエラー対応 - S
;<HOM>*************************************************************************
; <関数名>    : CopyParts_Copy
; <処理概要>  : 部材のコピー処理を行い、コピー図形のシンボル基点座標及び
;             : "G_LSYM"情報を返す
; <戻り値>    : コピー情報リスト
;             :   ((基点座標リスト "G_LSYM"情報リスト) () () ・・・)
; <作成>      : 2012/03/15 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun CopyParts_Copy (
	&ss   ; コピー対象部材の選択セット
	/
	#idx #bpt #sym #ss_old #ss_new #ss #BaseEn #old_list$ #new_list$ #cp_list$
	#ret$ #pt$ #xd_LSYM$
	)

	; コピー前の図面から"G_LSYM"を持つ図形を取り出す
	(setq #ss_old (ssget "X" '((-3 ("G_LSYM")))))
	(setq #old_list$ nil)
	(setq #idx 0)
	(repeat (sslength #ss_old)
		(setq #old_list$ (append #old_list$ (list (ssname #ss_old #idx))))
		(setq #idx (1+ #idx))
	)

	; コピー処理を行う
	(setq #bpt (getpoint "\n基点: "))
	(princ "\n目的点: ")

	; 色戻し処理
	(ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)

	(setq #BaseEn nil)
	(if (and
				(CFGetXRecord "BASESYM")                          ; 基準ｱｲﾃﾑがある 且つ
				(ssmemb (setq #BaseEn (handent (car (CFGetXRecord "BASESYM")))) &ss)) ; 基準ｱｲﾃﾑが &ss に入っていた
		(GroupInSolidChgCol2 #BaseEn "BYLAYER")   ;BYLAYER色に変更
	)

	(command ".COPY" &ss "" #bpt PAUSE)

	; コピー後の図面から"G_LSYM"を持つ図形を取り出す
	(setq #ss_new (ssget "X" '((-3 ("G_LSYM")))))
	(setq #new_list$ nil)
	(setq #idx 0)
	(repeat (sslength #ss_new)
		(setq #new_list$ (append #new_list$ (list (ssname #ss_new #idx))))
		(setq #idx (1+ #idx))
	)

	; コピー図形のみのリストを作成する
	(setq #cp_list$ nil)
	(setq #idx 0)
	(repeat (length #new_list$)
		(setq #sym (nth #idx #new_list$))
		(if (not (member #sym #old_list$))
			(setq #cp_list$ (append #cp_list$ (list #sym)))
		)
		(setq #idx (1+ #idx))
	)

	; シンボル基点及び"G_LSYM"情報を取得
	(setq #ret$ nil)
	(setq #idx 0)
	(repeat (length #cp_list$)
		(setq #pt$ (cdr (assoc 10 (entget (nth #idx #cp_list$)))))
		(setq #xd_LSYM$ (CFGetXData (nth #idx #cp_list$) "G_LSYM"))
		(setq #ret$ (append #ret$ (list (list #pt$ #xd_LSYM$))))
		(setq #idx (1+ #idx))
	)

	(if #BaseEn
		(GroupInSolidChgCol #BaseEn CG_BaseSymCol) ;基準ｱｲﾃﾑ色に変更
	)

	; コピー処理で配置した図形を削除
	(setq #idx 0)
	(repeat (length #cp_list$)
		(setq #sym (nth #idx #cp_list$))
		(setq #ss (CFGetSameGroupSS #sym))
		(command "_.ERASE" #ss "")
		(setq #idx (1+ #idx))
	)

	#ret$

) ;CopyParts_Copy


;<HOM>*************************************************************************
; <関数名>    : CopyParts_GetItemInfo
; <処理概要>  : 品番情報リストを作成する
; <戻り値>    : 品番情報リスト
;               (品番情報リスト 挿入点 配置角度(ラジアン) Wブレークライン Dブレークライン Hブレークライン)
; <作成>      : 2012/03/15 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun CopyParts_GetItemInfo (
	&sym       ; コピー元グループシンボル図形名
	&cp_list$  ; コピー情報リスト
	/
	#idx #width #depth #height #str_flg #xd_LSYM$ #xd_SYM$ #xd_TOKU$ #xd_REG$
	#new_LSYM$ #pt$ #w_brk$ #d_brk$ #h_brk$ #fig$ #ret$ #ang #doorID
	)

	(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
	(setq #xd_SYM$  (CFGetXData &sym "G_SYM"))
	(setq #xd_TOKU$ (CFGetXData &sym "G_TOKU"))
	(setq #xd_REG$  (CFGetXData &sym "G_REG"))

	; 挿入点（配置位置）座標
	(setq #idx 0)
	(repeat (length &cp_list$)
		(setq #new_LSYM$ (cadr (nth #idx &cp_list$)))
		(if (and (equal (nth  0 #new_LSYM$) (nth  0 #xd_LSYM$))   ; 図形ID
						 (equal (nth  1 #new_LSYM$) (nth  1 #xd_LSYM$))   ; 挿入点
						 (equal (nth  2 #new_LSYM$) (nth  2 #xd_LSYM$))   ; 回転角度
						 (equal (nth  6 #new_LSYM$) (nth  6 #xd_LSYM$))   ; 品番名称
						 (equal (nth  7 #new_LSYM$) (nth  7 #xd_LSYM$))   ; L/R区分
						 (equal (nth 10 #new_LSYM$) (nth 10 #xd_LSYM$)))  ; 性格コード
			(setq #pt$ (car (nth #idx &cp_list$)))
		)
		(setq #idx (1+ #idx))
	)

	; 配置角度
	(setq #ang (nth  2 #xd_LSYM$))

	; サイズ
	(setq #width  (nth 3 #xd_SYM$))
	(setq #depth  (nth 4 #xd_SYM$))
	(setq #height (nth 5 #xd_SYM$))

	; 特注部材である場合（"G_TOKU" "G_REG"）
	; 伸縮フラグ、ブレークライン位置の取得
	(setq #str_flg "")
	(setq #w_brk$ nil)
	(setq #d_brk$ nil)
	(setq #h_brk$ nil)
	(if (/= #xd_TOKU$ nil)
		(progn
			(setq #str_flg "Yes")
			(setq #w_brk$ (nth 20 #xd_TOKU$))
			(setq #d_brk$ (nth 21 #xd_TOKU$))
			(setq #h_brk$ (nth 22 #xd_TOKU$))
		)
	)
	(if (/= #xd_REG$ nil)
		(progn
			(setq #str_flg "Yes")
			(setq #w_brk$ (nth 20 #xd_REG$))
			(setq #d_brk$ (nth 21 #xd_REG$))
			(setq #h_brk$ (nth 22 #xd_REG$))
		)
	)

	; 品番情報リストの作成
	(setq #fig$
		(list
			(nth  5 #xd_LSYM$)    ; 品番名称
			(nth  0 #xd_LSYM$)    ; 図形ID
			0                     ; 階層タイプ
			(nth 12 #xd_LSYM$)    ; 用途番号
			(nth  6 #xd_LSYM$)    ; L/R区分
			#width                ; 寸法W
			#depth                ; 寸法D
			#height               ; 寸法H
			(nth  9 #xd_LSYM$)    ; 性格CODE
			#str_flg              ; 伸縮
			(nth  8 #xd_LSYM$)    ; 展開ID=図形ID
			(nth 15 #xd_LSYM$)    ; ｷｯﾁﾝ or 収納
			"0"                   ; 入力コード
		)
	)

	(setq #ret$ (list #fig$ #pt$ #ang #w_brk$ #d_brk$ #h_brk$))

	#ret$

) ; CopyParts_GetItemInfo


;<HOM>*************************************************************************
; <関数名>    : CopyParts_PcSetItem
; <処理概要>  : コピーコマンド用部材配置処理
; <戻り値>    : 設置された図形名
; <作成>      : 2012/03/15 A.Satoh
; <備考>      : PCSetItemを改造
;             : 既存のPCSetItemは処理上使用出来ない為、新規関数として作成
;             : コピーコマンドに特化した関数である為、他コマンドでは使用不可
;*************************************************************************>MOH<
(defun CopyParts_PcSetItem (
	&FIG$       ; 品番情報リスト
	&dINS       ; 挿入点
	&fANG       ; 挿入角度(ラジアン)
	&sym        ; コピー元図形グループシンボル図形名
	&w_brk$     ; 幅ブレークライン位置リスト
	&d_brk$     ; 奥行幅ブレークライン位置リスト
	&h_brk$     ; 高さブレークライン位置リスト
  /
	#door$ #DRSeriCode #DRColCode #Hikite #FIG$ #elv #elv2 #posZ #fname #ss #eNEW
	#xd_SYM$ #xd_LSYM$ #xd_TOKU$ #xd_REG$ #pt #ang #idx #cab_size$ #sabun #eD
	#BrkW #XLINE_W$ #XLINE_W #BrkD #XLINE_D$ #XLINE_D #BrkH #XLINE_H$ #XLINE_H
	#eDelBRK_W$ #eDelBRK_D$ #eDelBRK_H$
#xd_LSYM_OLD$ #xd_SYM_OLD$  ;-- 2012/03/23 A.Satoh Add
  )

	; グローバル変数の初期化
	(setq CG_BASE_UPPER nil)
	(setq CG_POS_STR nil)
	(setq CG_TOKU nil)
  (KP_TOKU_GROBAL_RESET)

	; 現在の扉情報をコピー元図形の扉図形IDの内容に変更する
	(setq #door$ (StrParse (nth 7 (CFGetXData &sym "G_LSYM")) ","))

	; 扉情報をバックアップ
	(setq #DRSeriCode CG_DRSeriCode)
	(setq #DRColCode  CG_DRColCode)
	(setq #Hikite     CG_HIKITE)

	; 扉情報を変更
	(setq CG_DRSeriCode (car   #door$))
	(setq CG_DRColCode  (cadr  #door$))
	(setq CG_HIKITE     (caddr #door$))

	(setq #FIG$ &FIG$)

	; 作図用の画層設置
	(MakeLayer "Z_00_00_00_01" 7 "CONTINUOUS")

	; 設置高さ設定
	(setq #elv (getvar "ELEVATION"))
	(cond
		((= (SKY_DivSeikakuCode (nth 8 #FIG$) 2) CG_SKK_TWO_UPP)
			(setvar "ELEVATION" CG_UpCabHeight)
		)
		(T
			(setvar "ELEVATION" 0)
		)
	)
	(setq #elv2 (getvar "ELEVATION"))

	(setvar "ELEVATION" #elv2)
	(setq #posZ #elv2)

	; 図形ファイル名
	(setq #fname (strcat (cadr #FIG$) ".dwg"))

	; 挿入予定のIDファイル名作成&チェック
	(Pc_CheckInsertDwg #fname CG_MSTDWGPATH)

	; 図形挿入
	(command "_insert" (strcat CG_MSTDWGPATH #fname) &dINS 1 1 (rtd &fANG))

  ; (実行位置変更) 施工情報線が見えるのを防ぐ
	(command "_.layer" "F" "Z_*" "")
	(command "_.layer" "T" "Z_00*" "")
	(command "_.layer" "T" "Z_KUTAI" "")

	; 図形 分解、グループ化、データセット
	(command "_explode" (entlast))
	(setq #ss (ssget "P"))

	; 分解した図形群で名前のないグループ作成
	(SKMkGroup #ss)
	(command "_layer" "u" "N_*" "")

	; グループシンボル図形の取得
	(setq #eNEW (SearchGroupSym (ssname #ss 0)))

	; "G_LSYM"情報を設定する
;-- 2012/03/23 A.Satoh Mod - S
;;;;;	(SKY_SetZukeiXData #FIG$ #eNEW &dINS &fANG)
	(setq #xd_LSYM_OLD$ (CFGetXData &sym "G_LSYM"))
	(CFSetXData #eNew "G_LSYM" (CFModList #xd_LSYM_OLD$ (list (list 1 &dINS))))
	(KcSetDanmenSymXRec #eNew)
;-- 2012/03/23 A.Satoh Mod - E

	; ｺｰﾅｰｷｬﾋﾞ"115"はPMEN2の頂点数をﾁｪｯｸする
	(if (CheckSKK$ #eNEW (list (itoa CG_SKK_ONE_CAB) "?" (itoa CG_SKK_THR_CNR)))
		(KP_MakeCornerPMEN2 #eNEW)
	)

	; 全共通画層処理
	(command "_.layer" "on" "M_*" "")

	; 扉面貼り付け
	(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

	; 特注伸縮後部材の場合は、配置後に伸縮処理を行う
	; 特注キャビコマンドと同一処理
	(if (= (nth 9 #FIG$) "Yes")
		(progn
			; 陰線処理時に扉の伸縮が不正。
　　　; 強制的にワイヤフレーム表示に変更する。
			(C:2DWire)

;-- 2012/03/23 A.Satoh Add - S
			(setq #xd_SYM_OLD$ (CFGetXData &sym "G_SYM"))
;-- 2012/03/23 A.Satoh Add - E
			(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM"))
			(setq #xd_LSYM$ (CFGetXData #eNEW "G_LSYM"))
			(setq #pt  (cdr (assoc 10 (entget #eNEW))))
			(setq #ang (nth 2 #xd_LSYM$))
			(setq CG_SizeH (nth 13 #xd_LSYM$))
			; 上基点フラグを有効に設定
			(if (> 0 (nth 10 #xd_SYM$))
				(setq CG_BASE_UPPER T)
			)
			(setq CG_TOKU T)

			; コピー元図形から"G_TOKU"又は"G_REG"情報を取得する
			(setq #xd_TOKU$ (CFGetXData &sym "G_TOKU"))
			(setq #xd_REG$ (CFGetXData &sym "G_REG"))

			; ブレークライン関連変数の初期化
			(setq #BrkW nil)
			(setq #XLINE_W$ nil)
			(setq #BrkD nil)
			(setq #XLINE_D$ nil)
			(setq #BrkH nil)
			(setq #XLINE_H$ nil)

			; 既存のブレークラインを削除する
			(setq #eDelBRK_W$ (PcRemoveBreakLine #eNEW "W")) ; W方向ブレーク除去
			(setq #eDelBRK_D$ (PcRemoveBreakLine #eNEW "D")) ; D方向ブレーク除去
			(setq #eDelBRK_H$ (PcRemoveBreakLine #eNEW "H")) ; H方向ブレーク除去

			; ブレークライン位置を取得
			;;; 幅ブレークライン
			(if &w_brk$
				(progn
					(setq #idx 0)
					(repeat (length &w_brk$)
						(if (> (nth #idx &w_brk$) 0.0)
							(setq #XLINE_W$ (append #XLINE_W$ (list (nth #idx &w_brk$))))
						)
						(setq #idx (1+ #idx))
					)
				)
				(setq #XLINE_W$ nil)
			)

			;;; 奥行ブレークライン
			(if &d_brk$
				(progn
					(setq #idx 0)
					(repeat (length &d_brk$)
						(if (> (nth #idx &d_brk$) 0.0)
							(setq #XLINE_D$ (append #XLINE_D$ (list (nth #idx &d_brk$))))
						)
						(setq #idx (1+ #idx))
					)
				)
				(setq #XLINE_D$ nil)
			)

			;;; 高さブレークライン
			(if &h_brk$
				(progn
					(setq #idx 0)
					(repeat (length &h_brk$)
						(if (> (nth #idx &h_brk$) 0.0)
							(setq #XLINE_H$ (append #XLINE_H$ (list (nth #idx &h_brk$))))
						)
						(setq #idx (1+ #idx))
					)
				)
			)

			; 伸縮処理
			(if (= CG_SKK_THR_CNR (CFGetSymSKKCode &sym 3))
				(progn    ; コーナーキャビ
					; 伸縮量の取得
					(setq #cab_size$ (CopyParts_GetCabSize #xd_TOKU$ #xd_REG$))

					; [A]伸縮量
					(if (and #XLINE_W$ (not (equal (nth 0 #cab_size$) 0.0 0.0001)))
						(if (not (equal (nth 3 #cab_size$) 0.0 0.0001))
							(progn
								; ブレークラインの作成→グローバル変数に設定
								(if (= (length #XLINE_W$) 2)
									(setq #BrkW (nth 1 #XLINE_W$))
									(setq #BrkW (nth 0 #XLINE_W$))
								)
								(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
								(CFSetXData #XLINE_W "G_BRK" (list 1))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_W "")	; ブレークラインのグループ化
       		  		(setq CG_TOKU_BW #BrkW)
		 	        	(setq CG_TOKU_BD nil)
	  		 	      (setq CG_TOKU_BH nil)

								; 最新情報を使用する
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

								; キャビネット本体の伸縮を行う
    			      (SKY_Stretch_Parts #eNEW (+ (nth 3 #xd_SYM$) (nth 0 #cab_size$)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

								; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
								(entdel #XLINE_W)

								; 扉図形の伸縮
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
							(progn
								(setq #sabun (/ (nth 0 #cab_size$) (length #XLINE_W$)))

								(foreach #BrkW #XLINE_W$
									; ブレークラインの作成→グローバル変数に設定
									(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
									(CFSetXData #XLINE_W "G_BRK" (list 1))
									(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_W "")	; ブレークラインのグループ化
       					  (setq CG_TOKU_BW #BrkW)
		 	        		(setq CG_TOKU_BD nil)
	  		 	      	(setq CG_TOKU_BH nil)

									; 最新情報を使用する
									(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

									; キャビネット本体の伸縮を行う
  			  	      (SKY_Stretch_Parts #eNEW (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

									; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
									(entdel #XLINE_W)

									; 扉図形の伸縮
									(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

									(KP_TOKU_GROBAL_RESET)
								)
							)
						)
    		  )

					; [B]伸縮量
					(if (and #XLINE_D$ (not (equal (nth 1 #cab_size$) 0.0 0.0001))) ; W2(D)
						(if (not (equal (nth 2 #cab_size$) 0.0 0.0001))
							(progn
								; ブレークラインの作成→グローバル変数に設定
								(if (= (length #XLINE_D$) 2)
									(setq #BrkD (nth 1 #XLINE_D$))
									(setq #BrkD (nth 0 #XLINE_D$))
								)
								(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
								(CFSetXData #XLINE_D "G_BRK" (list 2))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_D "")
		       	  	(setq CG_TOKU_BW nil)
	 			        (setq CG_TOKU_BD #BrkD)
  	 	  		    (setq CG_TOKU_BH nil)

								; 最新情報を使用する
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

								; キャビネット本体の伸縮を行う
								(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) (nth 1 #cab_size$)) (nth 5 #xd_SYM$))

								; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
								(entdel #XLINE_D)

								; 扉図形の伸縮
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
							(progn
								(setq #sabun (/ (nth 1 #cab_size$) (length #XLINE_D$)))

								(foreach #BrkD #XLINE_D$
									; ブレークラインの作成→グローバル変数に設定
									(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
									(CFSetXData #XLINE_D "G_BRK" (list 2))
									(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_D "")
    		   		  	(setq CG_TOKU_BW nil)
	 	    		  	  (setq CG_TOKU_BD #BrkD)
  	 	      			(setq CG_TOKU_BH nil)

									; 最新情報を使用する
									(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

									; キャビネット本体の伸縮を行う
									(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

									; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
									(entdel #XLINE_D)

									; 扉図形の伸縮
									(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

									(KP_TOKU_GROBAL_RESET)
								)
							)
						)
					)

					; [C]伸縮量
					(if (and #XLINE_D$ (not (equal (nth 2 #cab_size$) 0.0 0.0001))) ; D1(D)
						(if (not (equal (nth 1 #cab_size$) 0.0 0.0001))
							(progn
								; ブレークラインの作成→グローバル変数に設定
								(setq #BrkD (nth 0 #XLINE_D$))
								(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
								(CFSetXData #XLINE_D "G_BRK" (list 2))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_D "")
    	   	  		(setq CG_TOKU_BW nil)
		 	    	    (setq CG_TOKU_BD #BrkD)
   			    	  (setq CG_TOKU_BH nil)

								; 最新情報を使用する
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

								; キャビネット本体の伸縮を行う
								(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) (nth 2 #cab_size$)) (nth 5 #xd_SYM$))

								; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
								(entdel #XLINE_D)

								; 扉図形の伸縮
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
							(progn
								(setq #sabun (/ (nth 2 #cab_size$) (length #XLINE_D$)))

								(foreach #BrkD #XLINE_D$
									; ブレークラインの作成→グローバル変数に設定
									(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
									(CFSetXData #XLINE_D "G_BRK" (list 2))
									(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_D "")
    			  	 	  (setq CG_TOKU_BW nil)
 	    			  	  (setq CG_TOKU_BD #BrkD)
   	    	  			(setq CG_TOKU_BH nil)

									; 最新情報を使用する
									(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

									; キャビネット本体の伸縮を行う
									(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

									; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
									(entdel #XLINE_D)

									; 扉図形の伸縮
									(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

									(KP_TOKU_GROBAL_RESET)
								)
							)
						)
					)

					; [D]伸縮量
					(if (and #XLINE_W$ (not (equal (nth 3 #cab_size$) 0.0 0.0001))) ; D2(W)
						(if (not (equal (nth 0 #cab_size$) 0.0 0.0001))
							(progn
								; ブレークラインの作成→グローバル変数に設定
								(setq #BrkW (nth 0 #XLINE_W$))
								(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
								(CFSetXData #XLINE_W "G_BRK" (list 1))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_W "")
  	     	  		(setq CG_TOKU_BW #BrkW)
		 	  	      (setq CG_TOKU_BD nil)
   			  	    (setq CG_TOKU_BH nil)

								; 最新情報を使用する
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

								; キャビネット本体の伸縮を行う
  			        (SKY_Stretch_Parts #eNEW (+ (nth 3 #xd_SYM$) (nth 3 #cab_size$)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

								; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
								(entdel #XLINE_W)

								; 扉図形の伸縮
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
							(progn
								(setq #sabun (/ (nth 3 #cab_size$) (length #XLINE_W$)))

								(foreach #BrkW #XLINE_W$
									; ブレークラインの作成→グローバル変数に設定
									(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
									(CFSetXData #XLINE_W "G_BRK" (list 1))
									(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_W "")
  	  	   			  (setq CG_TOKU_BW #BrkW)
		 	  	  	    (setq CG_TOKU_BD nil)
   			  	  	  (setq CG_TOKU_BH nil)

									; 最新情報を使用する
									(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

									; キャビネット本体の伸縮を行う
  				        (SKY_Stretch_Parts #eNEW (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

									; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
									(entdel #XLINE_W)

									; 扉図形の伸縮
									(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

									(KP_TOKU_GROBAL_RESET)
								)
							)
    		    )
		      )

					; 高さ伸縮量
					(if (and #XLINE_H$ (not (equal (nth 4 #cab_size$) 0.0 0.0001))) ; H
						(progn
							(setq CG_SizeH (+ CG_SizeH (nth 4 #cab_size$)))
							(setq #sabun (/ (nth 4 #cab_size$) (length #XLINE_H$)))
							(foreach #BrkH #XLINE_H$
								; 吊戸の場合の高さ変換
								(if CG_BASE_UPPER
									(setq #BrkH (- (caddr #pt) #BrkH))
								)

								; ブレークラインの作成→グローバル変数に設定
								(setq #XLINE_H (PK_MakeBreakH #pt #BrkH))
								(CFSetXData #XLINE_H "G_BRK" (list 3))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_H "")
								(setq CG_TOKU_BW nil)
								(setq CG_TOKU_BD nil)
								(setq CG_TOKU_BH #BrkH)

								; 最新情報を使用する
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))

								; キャビネット本体の伸縮を行う
								(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (nth 4 #xd_SYM$) (+ (nth 5 #xd_SYM$) #sabun))

;-- 2012/03/23 A.Satoh Del - S
;;;;;								; 寸法Hの更新
;;;;;			    		  (CFSetXData #eNEW "G_LSYM" (CFModList #xd_LSYM$ (list (list 13 CG_SizeH))))
;-- 2012/03/23 A.Satoh Del - E

								; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
								(entdel #XLINE_H)

								; 扉図形の伸縮
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
						)
					)

;-- 2012/03/23 A.Satoh Add - S
					(setq #xd_LSYM$ (CFGetXData #eNEW "G_LSYM"))
					(CFSetXData #eNew "G_LSYM" (CFModList #xd_LSYM$ (list (list 13 (nth 13 #xd_LSYM_OLD$)))))

					; G_SYMの伸縮フラグをコピー元図形に合わせる
					(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))
					(CFSetXData #eNEW "G_SYM"
						(CFModList #xd_SYM$
							(list
								(list 11 (nth 11 #xd_SYM_OLD$))
								(list 12 (nth 12 #xd_SYM_OLD$))
								(list 13 (nth 13 #xd_SYM_OLD$))
							)
						)
					)
;-- 2012/03/23 A.Satoh Add - E
				)
				(progn    ; コーナーキャビ以外
					; 幅方向
					(if (and #XLINE_W$ (not (equal (nth 5 #FIG$) (nth 3 #xd_SYM$) 0.0001)))
						(progn
							(setq #sabun (/ (- (nth 5 #FIG$) (nth 3 #xd_SYM$)) (length #XLINE_W$)))
							(foreach #BrkW #XLINE_W$
								; ブレークラインの作成→グローバル変数に設定
								(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
								(CFSetXData #XLINE_W "G_BRK" (list 1))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_W "")
		       		  (setq CG_TOKU_BW #BrkW)
 	  		      	(setq CG_TOKU_BD nil)
	   	  		    (setq CG_TOKU_BH nil)

								; キャビネット本体の伸縮を行う
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))
								(SKY_Stretch_Parts #eNEW (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

								; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
								(entdel #XLINE_W)

								; 扉図形の伸縮
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
						)
					)

					; 奥行方向
					(if (and #XLINE_D$ (not (equal (nth 6 #FIG$) (nth 4 #xd_SYM$) 0.0001)))
						(progn
							(setq #sabun (/ (- (nth 6 #FIG$) (nth 4 #xd_SYM$)) (length #XLINE_D$)))
							(foreach #BrkD #XLINE_D$
								; ブレークラインの作成→グローバル変数に設定
								(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
								(CFSetXData #XLINE_D "G_BRK" (list 2))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_D "")
       			  	(setq CG_TOKU_BW nil)
	 	        		(setq CG_TOKU_BD #BrkD)
		  	 	      (setq CG_TOKU_BH nil)

								; キャビネット本体の伸縮を行う
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))
								(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

								; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
								(entdel #XLINE_D)

								; 扉図形の伸縮
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
						)
					)

					; 高さ方向
					(if (and #XLINE_H$ (not (equal (nth 7 #FIG$) (nth 5 #xd_SYM$) 0.0001)))
						(progn
							(setq #sabun (/ (- (nth 7 #FIG$) (nth 5 #xd_SYM$)) (length #XLINE_H$)))
							(foreach #BrkH #XLINE_H$
								; 吊戸の場合の高さ変換
								(if CG_BASE_UPPER
									(setq #BrkH (- (caddr #pt) #BrkH))
								)
								; ブレークラインの作成→グローバル変数に設定
								(setq #XLINE_H (PK_MakeBreakH #pt #BrkH))
								(CFSetXData #XLINE_H "G_BRK" (list 3))
								(command "-group" "A" (SKGetGroupName #eNEW) #XLINE_H "")
    		   	  	(setq CG_TOKU_BW nil)
	 	    		    (setq CG_TOKU_BD nil)
  	 	      		(setq CG_TOKU_BH #BrkH)

								; キャビネット本体の伸縮を行う
								(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))
								(SKY_Stretch_Parts #eNEW (nth 3 #xd_SYM$) (nth 4 #xd_SYM$) (+ (nth 5 #xd_SYM$) #sabun))

								; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
								(entdel #XLINE_H)

								; 扉図形の伸縮
								(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #eNEW) 3 T))

								(KP_TOKU_GROBAL_RESET)
							)
						)
					)

;-- 2012/03/23 A.Satoh Add - S
					(setq #xd_LSYM$ (CFGetXData #eNEW "G_LSYM"))
					(CFSetXData #eNew "G_LSYM" (CFModList #xd_LSYM$ (list (list 13 (nth 13 #xd_LSYM_OLD$)))))

					; G_SYMの伸縮フラグをコピー元図形に合わせる
					(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM" ))
					(CFSetXData #eNEW "G_SYM"
						(CFModList #xd_SYM$
							(list
								(list 11 (nth 11 #xd_SYM_OLD$))
								(list 12 (nth 12 #xd_SYM_OLD$))
								(list 13 (nth 13 #xd_SYM_OLD$))
							)
						)
					)
;-- 2012/03/23 A.Satoh Add - E
				)
			)

			; 元のﾌﾞﾚｰｸﾗｲﾝ復活
			; W方向
			(foreach #eD #eDelBRK_W$ (if (= (entget #eD) nil) (entdel #eD)))
			; D方向
			(foreach #eD #eDelBRK_D$ (if (= (entget #eD) nil) (entdel #eD)))
			; H方向
			(foreach #eD #eDelBRK_H$ (if (= (entget #eD) nil) (entdel #eD)))

			; 特注情報の登録
			(if #xd_TOKU$
				(CFSetXData #eNEW "G_TOKU" #xd_TOKU$)
			)
			(if #xd_REG$
				(CFSetXData #eNEW "G_REG" #xd_REG$)
			)
		)
	)

	; 拡張ﾃﾞｰﾀ "G_OPT" セット
	(KcSetG_OPT #eNEW)

	; 新アイテム中の側面図移動が必要かどうか判定して実行 (コンロ)
	(KcMoveToSGCabinet #eNEW)

	(command "_.layer" "F" "Z_01*" "")
	(command "_layer" "F" "Y_00*" "")
	(command "_layer" "OFF" "Y_00*" "")

	; Ｏスナップ関連システム変数を元に戻す
	(CFNoSnapEnd)

	; グローバル変数を元に戻す
	(setq CG_BASE_UPPER nil)
	(setq CG_TOKU_BW nil)
	(setq CG_TOKU_BD nil)
	(setq CG_TOKU_BH nil)
	(setq CG_POS_STR nil)
	(setq CG_TOKU nil)
	(setq CG_DRSeriCode #DRSeriCode)
	(setq CG_DRColCode #DRColCode)
	(setq CG_HIKITE #Hikite)

	(command "_.layer" "F" "Z_*" "")
	(command "_.layer" "T" "Z_00*" "")
	(command "_.layer" "T" "Z_KUTAI" "")

	; 元の高さに戻す
	(setvar "ELEVATION" #elv)

  #eNEW

) ; CopyParts_PcSetItem


;<HOM>*************************************************************************
; <関数名>    : CopyParts_GetCabSize
; <処理概要>  : コーナーキャビの伸縮量を取得する
; <戻り値>    : 伸縮量リスト
;               ([A]伸縮量 [B]伸縮量 [C]伸縮量 [D]伸縮量 高さ伸縮量)
; <作成>      : 2012/03/16 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun CopyParts_GetCabSize (
	&xd_TOKU$  ; 特注情報
	&xd_REG$   ; 特注規格品情報
	/
	#err_flag #xd_TOKUTYU$ #ret$ #str_a #str_b #str_c #str_d #str_h
	#org_width #org_depth #org_height #new_width #new_depth #new_height
	)

	(setq #err_flag nil)
	(setq #xd_TOKUTYU$ nil)

	(if &xd_TOKU$
		(setq #xd_TOKUTYU$ &xd_TOKU$)
		(if &xd_REG$
			(setq #xd_TOKUTYU$ &xd_REG$)
		)
	)

	; 特注情報が存在しない場合は、伸縮量を全て0.0で返す
	(if (= #xd_TOKUTYU$ nil)
		(progn
			(setq #ret$ (list 0.0 0.0 0.0 0.0 0.0))
			(setq #err_flag T)
		)
	)

	(if (= #err_flag nil)
		(progn
			; サイズ情報を取得
			(setq #org_width  (nth 12 #xd_TOKUTYU$))
			(setq #org_depth  (nth 13 #xd_TOKUTYU$))
			(setq #org_height (nth 14 #xd_TOKUTYU$))
			(setq #str_d      (nth 15 #xd_TOKUTYU$))
			(setq #str_c      (nth 16 #xd_TOKUTYU$))
			(setq #new_width  (nth 17 #xd_TOKUTYU$))
			(setq #new_depth  (nth 18 #xd_TOKUTYU$))
			(setq #new_height (nth 19 #xd_TOKUTYU$))

			; [A]、[B]、高さの伸縮量を算出
			(setq #str_a (- (- #new_width #org_width) #str_d))
			(setq #str_b (- (- #new_depth #org_depth) #str_c))
			(setq #str_h (- #new_height #org_height))

			(setq #ret$ (list #str_a #str_b #str_c #str_d #str_h))
		)
	)

	#ret$

) ; CopyParts_GetCabSize
;-- 2012/03/15 A.Satoh Mod コピーコマンドエラー対応 - E


;<HOM>*************************************************************************
; <関数名>    : Copy
; <処理概要>  : 設備コピー
; <戻り値>    : コピー後の選択セット
; <作成>      : 1999-12-2 YM
; <備考>      :
;*************************************************************************>MOH<
(defun Copy(
  &ss
  /
  #i
  #ss2            ; コピーした図形の選択セット
  #old_lis        ; コピー前の図面上全図形リスト
  #new_lis        ; コピー後の図面上全図形リスト
  #bpt            ; コピーの基点
  #lpt            ; 目的点
  #os
  #baseen #basess;00/10/04 SN ADD
#idx #old_list$ #new_list$ #flag #en_new  ;-- 2012/03/14 A.Satoh Add コピーコマンド修正
  )

  (setq #old_lis (CMN_all_en_list))            ; (図面上の全ての図形名リスト(<図形名1>,2,3,...,n)
  (setq #bpt (getpoint "\n基点: "))
  (princ "\n目的点: ")

  ;00/09/22 SN MOD 色戻し処理別関数
  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
;;;  (ChangeItemColor &ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; 色を戻す
  ;)

  ;00/10/04 SN ADD 基準ｱｲﾃﾑは一旦Bylaerにする。
  (setq #baseen nil)
  (if (and (CFGetXRecord "BASESYM")                          ; 基準ｱｲﾃﾑがある 且つ
      (ssmemb (setq #baseen (handent (car (CFGetXRecord "BASESYM")))) &ss)) ; 基準ｱｲﾃﾑが &ss に入っていた
      (GroupInSolidChgCol2 #baseen "BYLAYER")   ;BYLAYER色に変更
  );_if

  (setq EditFlag 1)
  (command ".COPY" &ss "" #bpt PAUSE)
  (setq #lpt (getvar "LASTPOINT"))
  (setq #new_lis (CMN_all_en_list))            ; (図面上の全ての図形名リスト(<図形名1>,2,3,...,n)

;;; コピー後の選択セット#ss2 ;;;
  (setq #ss2 (ssadd))
  (setq #i (+ (car #old_lis) 1))
  (while (<= #i (car #new_lis))
    (setq #ss2 (ssadd (nth #i #new_lis) #ss2))
    (setq #i (1+ #i))
  );_(while

  ;00/10/04 SN ADD 基準ｱｲﾃﾑは一旦色をBylayerにしているので、基準色にする。
  (if #baseen (progn
    (GroupInSolidChgCol #baseen CG_BaseSymCol) ;基準ｱｲﾃﾑ色に変更
    ;baseresetにより矢印は再作図されるが対象外にする。
    (setq #basess (ssget "X" '((-3 ("G_ARW")))))
    (setq #i 0)
    (repeat (sslength #basess)
      (ssdel (ssname #basess #i) #ss2)
      (setq #i (1+ #i))
    )
  ))

  (if (= nil (equal (caddr #lpt) (caddr #bpt) 0.0001))
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command ".MOVE" #ss2 "" "0,0,0" (list 0 0 (- (caddr #bpt) (caddr #lpt))))
      (setvar "OSMODE" #os)
    );_progn
  );_if

  #ss2

);_defun

;<HOM>*************************************************************************
; <関数名>    : C:CopyRotateParts
; <処理概要>  : 方向コピーコマンド
; <戻り値>    :
; <作成>      : 1999-12-2 YM
; <備考>      :
;*************************************************************************>MOH<
(defun C:CopyRotateParts(
  /
  #v_angbase
  #v_angdir
  #i
  #ss             ; 選択したすべてのグループの選択セット(コピー対象)
  #ss2            ; コピーした図形の選択セット
  #ret
  #sa_ang         ; 回転角度
  #en_lis_#ss     ; コピー前図形名リスト
  #en_lis_#ss2    ; コピー後図形名リスト
#sys$
  )
  (StartUndoErr);00/10/02 SN MOD UNDO処理関数変更
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  (setq #v_angbase (getvar "ANGBASE"))
  (setvar "ANGBASE" 0)                                 ; ANGBASEのデフォルト化
  (setq #v_angdir (getvar "ANGDIR"))
  (setvar "ANGDIR" 0)                                  ; ANGDIRのデフォルト化
  ;00/09/22 SN MOD ｱｲﾃﾑ選択関数を変更
  (setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
;;;  (setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_ConfSymCol))
  ;00/09/22 SN MOD 選択ｾｯﾄのｵﾌﾞｼﾞｪｸﾄ数をﾁｪｯｸする。
  (if (> (sslength #ss) 0)
		(progn
	    (setq #ret (CopyRotate #ss))                         ; 要素の方向コピー
	    (setq #ss2    (car  #ret))
	    (setq #sa_ang (cadr #ret))
	    (setq #en_lis_#ss  (CMN_ss_to_en #ss ))              ; コピー前選択セットを渡して図形名のリストを得る.
	    (setq #en_lis_#ss2 (CMN_ss_to_en #ss2))              ; コピー後選択セットを渡して図形名のリストを得る.
	    (SetG_PRIM22 #en_lis_#ss  #en_lis_#ss2)              ; "G_PRIM"(底面図形)拡張データの変更
	    (SetG_BODY   #en_lis_#ss #en_lis_#ss2)               ; "G_BODY"(穴図形)拡張データの変更

;;;01/05/01YM@	    (SetG_LSYM11 #en_lis_#ss  #en_lis_#ss2)              ; "G_LSYM"(挿入点)拡張データの変更
;;;01/05/01YM@	    (SetG_LSYM22 #en_lis_#ss2 #en_lis_#ss2 #sa_ang)      ; "G_LSYM"(回転角度)拡張データの変更

	    (ChgLSYM12_copy #en_lis_#ss #en_lis_#ss2 #sa_ang) ; "G_LSYM"(挿入点,回転角度)拡張データの変更 01/05/01 YM 高速化

			(AfterCopySetDoorGroup #en_lis_#ss #en_lis_#ss2) ; 01/09/10 YM "ADD DoorGroup" のｾｯﾄ

	    (setvar "ANGBASE" #v_angbase)                        ; ANGBASEを戻す
	    (setvar "ANGDIR" #v_angdir)                          ; ANGDIRを戻す
	  )
	);_if
  (setq *error* nil)                                   ; 後処理
  (setq EditFlag nil)
  (CFCmdDefFinish);00/09/13 SN ADD
  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
	(princ "\n方向コピーしました。")
  (princ)
);_(defun

;<HOM>*************************************************************************
; <関数名>    : CopyRotate
; <処理概要>  : 方向コピー
; <戻り値>    : (コピー後の選択セット,回転角度)
; <作成>      : 1999-12-2 YM
; <備考>      :
;*************************************************************************>MOH<
(defun CopyRotate(
  &ss
  /
  #i
  #ss2            ; コピーした図形の選択セット
  #old_lis        ; コピー前の図面上全図形リスト
  #new_lis        ; コピー後の図面上全図形リスト
  #bpt            ; コピーの基点
  #lpt            ; 目的点
  #os
  #rpt
  #rptn
  #pt1
  #pt2
  #sa_ang         ; 回転角度
  #en_cf
  #baseen #basess;00/10/04 SN ADD
  )

  (setq #old_lis (CMN_all_en_list)) ; (図面上の全ての図形名リスト(<図形名1>,2,3,...,n)
  (initget 1)
  (setq #bpt (getpoint "\nコピー元基準点: "))            ; (1)
  (initget 1)
  (setq #rpt (getpoint #bpt "\nコピー元面合わせ方向: ")) ; (2) #bptからラバーバンドを引く.
  (princ "\nコピー先基準点: ")

  ;00/09/22 SN MOD 色戻し処理別関数
  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; 色を戻す
  ;)
  ;00/10/04 SN ADD 基準ｱｲﾃﾑは一旦Bylaerにする。
  (setq #baseen nil)
  (if (and (CFGetXRecord "BASESYM")                          ; 基準ｱｲﾃﾑがある 且つ
      (ssmemb (setq #baseen (handent (car (CFGetXRecord "BASESYM")))) &ss)) ; 基準ｱｲﾃﾑが &ss に入っていた
      (GroupInSolidChgCol2 #baseen "BYLAYER")   ;BYLAYER色に変更
  );_if

  (setq EditFlag 1)
  (command ".COPY" &ss "" #bpt PAUSE)
  (setq #lpt (getvar "LASTPOINT"))                      ; (3)

  (setq #rptn (mapcar '+ #rpt (mapcar '- #lpt #bpt)))
  (setq #new_lis (CMN_all_en_list)) ; (図面上の全ての図形名リスト(<図形名1>,2,3,...,n)

;;; コピー後の選択セット#ss2 ;;;
  (setq #ss2 (ssadd))
  (setq #i (+ (car #old_lis) 1))
  (while (<= #i (car #new_lis))
    (setq #ss2 (ssadd (nth #i #new_lis) #ss2))
    (setq #i (1+ #i))
  );_(while

  ;00/10/04 SN ADD 基準ｱｲﾃﾑは一旦色をBylayerにしているので、基準色にする。
  (if #baseen (progn
    (GroupInSolidChgCol #baseen CG_BaseSymCol) ;基準ｱｲﾃﾑ色に変更
    ;baseresetにより矢印は再作図されるが対象外にする。
    (setq #basess (ssget "X" '((-3 ("G_ARW")))))
    (setq #i 0)
    (repeat (sslength #basess)
      (ssdel (ssname #basess #i) #ss2)
      (setq #i (1+ #i))
    )
  ))

  (if (= nil (equal (caddr #lpt) (caddr #bpt) 0.0001))
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command ".MOVE" #ss2 "" "0,0,0" (list 0 0 (- (caddr #bpt) (caddr #lpt))))
      (setvar "OSMODE" #os)
    ); _progn
  );_if

  (princ "\nコピー先面合わせ方向: ")
  ;;; 回転前参照点 in #ss2 ;;;
  (setq #pt1 (cdr (assoc 10 (entget (SearchGroupSym (ssname #ss2 0)))))) ; #ss2の中の1つの親図形の点
  (setq #en_cf nil)
  (if (< (distance #pt1 #lpt) 0.1)                                        ; 基点が親図形点と同じ場合
    (progn
      (setq #pt1 (mapcar '+ #pt1 '(50.0 50.0 0.0)))                       ; 参照点の平行移動
      (entmake (list (cons 0 "POINT") (cons 62 2) (list 10 (car #pt1) (cadr #pt1) (caddr #pt1)) )) ; 参照点を図面に作成
      (setq #en_cf (entlast))
      (setq #ss2 (ssadd #en_cf &ss)) ; 作成した参照点も一緒に回転する.
    );_(progn
  );if

  (command ".ROTATE" #ss2 "" #lpt "R" #lpt #rptn PAUSE)
  ;;; 回転後参照点 in #ss2 ;;;
  (setq #pt2 (cdr (assoc 10 (entget (SearchGroupSym (ssname #ss2 0)))))) ; #ss2の中の1つの親図形の点
  (if #en_cf
    (progn
      (setq #pt2 (cdr (assoc 10 (entget #en_cf))))
      (entdel #en_cf) ; 参照点を削除
    );_(progn
  );if

  (setq #sa_ang (- (angle #lpt #pt2) (angle #lpt #pt1)))                 ; 回転前参照点,回転後参照点の角度差
  (list #ss2 #sa_ang)

);_defun

;<HOM>*************************************************************************
; <関数名>    : C:Z_MoveParts
; <処理概要>  : 設備Z移動コマンド
; <戻り値>    :
; <作成>      : 1999-12-2 YM
; <備考>      :
;*************************************************************************>MOH<
(defun C:Z_MoveParts(
  /
  #ss             ; 選択要素をメンバーにもつグループの、全図形の選択セット(移動対象)
	#SYS$ #dist
  )
  (StartUndoErr);00/10/02 SN MOD UNDO処理関数変更
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  ;00/09/22 SN MOD ｱｲﾃﾑ選択関数を変更
;;;  (setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
  (setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_ConfSymCol))
  ;00/09/22 SN MOD 選択ｾｯﾄのｵﾌﾞｼﾞｪｸﾄ数をﾁｪｯｸする。
  (if (> (sslength #ss) 0)
		(progn
	    (setq #dist (Z_Move #ss))                                 ; 要素の移動
			; "G_LSYM"(挿入点)更新 01/04/27 YM 高速化
	    (ChgLSYM1 #ss)
	    (SetG_PRIM1 #ss)  ; "G_PRIM" (取り付け高さ)拡張データの変更
	    (SetG_WRKT "Z_MOVE" #ss #dist nil)   ; "G_WRKT"(WT取付け高さ)拡張データの変更
	  )
	);end if - progn
  (setq *error* nil)                           ; 後処理
  (setq EditFlag nil)
  (CFCmdDefFinish);00/09/13 SN ADD
  (PKEndCOMMAND #sys$) ; 06/09 YM ADD
	(princ "\nＺ移動しました。")
  (princ)

);_(defun

;<HOM>*************************************************************************
; <関数名>    : Z_Move
; <処理概要>  : 設備Z移動
; <戻り値>    : なし
; <作成>      : 1999-12-2 YM
; <備考>      :
;*************************************************************************>MOH<
(defun Z_Move(
  &ss
  /
  #os
  #buf            ; ｚ移動相対座標の文字列化
  #dist #SS
  )

; 00/09/27 SN MOD OSMODEのOFFはCommand MOVE の直前に行う
; 00/06/26 SN MOD OSMODEは距離入力前にOFFする。
;  (setq #os (getvar "OSMODE"))
;  (setvar "OSMODE" 0)
  ;// 距離を入力
  (setq #dist (getdist (strcat "\n距離<" (itoa (fix CG_ZMOVEDIST)) ">: ")));00/06/27 SN MOD ﾒｯｾｰｼﾞ変更
  ;(setq #dist (getdist (strcat "\n距離を入力<" (rtos CG_ZMOVEDIST) ">:")));00/06/27 SN MOD
  (if (/= #dist nil) (setq CG_ZMOVEDIST #dist))  ; グローバル変数で記憶
	(if (=  #dist nil) (setq #dist CG_ZMOVEDIST))  ; 02/08/28 YM ADD

; 00/06/26 SN MOD OSMODEは距離入力前にOFFする。
;  (setq #os (getvar "OSMODE"))
;  (setvar "OSMODE" 0)
  (setq #buf (strcat "0,0," (rtos CG_ZMOVEDIST))) ; ｚ方向移動相対座標

  ;00/09/22 SN MOD 色戻し処理別関数
;;;  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
  (ChangeItemColor &ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; 色を戻す
  ;)
  (setq EditFlag 1)
  ;;; 06/10 YM ADD 基準ｱｲﾃﾑの場合矢印も動
        ;00/06/27 SN MOD 基準ｱｲﾃﾑが無い時の不具合修正
  (if (and (CFGetXRecord "BASESYM")                          ; 基準ｱｲﾃﾑがある 且つ
      (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss)) ; 基準ｱｲﾃﾑが &ss に入っていた
; (if (ssmemb (handent (car (CFGetXRecord "BASESYM"))) &ss) ; 基準ｱｲﾃﾑが &ss に入っていた
    (progn
      (setq #ss (ssget "X" '((-3 ("G_ARW"))))) ; 矢印も移動する
      (CMN_ssaddss #ss &ss)
    )
  );_if

  (setq #os (getvar "OSMODE"));00/09/27 SN ADD
  (setvar "OSMODE" 0)         ;00/09/27 SN ADD
  (command "._MOVE" &ss "" "0,0,0" #buf)
  (setvar "OSMODE" #os)
  #dist
)

;<HOM>*************************************************************************
; <関数名>    : C:Z_CopyParts
; <処理概要>  : 設備Ｚコピーコマンド
; <戻り値>    :
; <作成>      : 1999-12-2 YM
; <備考>      : 拡張データ"G_LSYM","G_PRIM"のみ変更.
;*************************************************************************>MOH<
(defun C:Z_CopyParts(
  /
  #ss             ; 選択したすべてのグループの選択セット(移動対象)
  #ss2            ; コピーした図形の選択セット
  #en_lis_#ss     ; コピー前図形名リスト
  #en_lis_#ss2    ; コピー後図形名リスト
#sys$
  )
  (StartUndoErr);00/10/02 SN MOD UNDO処理関数変更
  (setq #sys$ (PKStartCOMMAND)) ; 06/09 YM ADD
  (CFCmdDefBegin 6);00/09/13 SN ADD
  ;00/09/22 SN MOD ｱｲﾃﾑ選択関数を変更
  (setq #ss (ItemSel '(()("G_LSYM")) CG_ConfSymCol))
  ;00/09/22 SN MOD 選択ｾｯﾄのｵﾌﾞｼﾞｪｸﾄ数をﾁｪｯｸする。
  (if (> (sslength #ss) 0)
		(progn
	    (setq #ss2 (Z_Copy #ss))                     ; 要素のZコピー
	    (setq #en_lis_#ss  (CMN_ss_to_en #ss ))      ; コピー前選択セットを渡して図形名のリストを得る.
	    (setq #en_lis_#ss2 (CMN_ss_to_en #ss2))      ; コピー後選択セットを渡して図形名のリストを得る.
;;;01/05/01YM@	    (SetG_LSYM11 #en_lis_#ss  #en_lis_#ss2)      ; "G_LSYM"(挿入点)拡張データの変更

	    (ChgLSYM1_copy #en_lis_#ss #en_lis_#ss2)     ; "G_LSYM"(挿入点)拡張データの変更 01/05/01 YM 高速化
			(AfterCopySetDoorGroup #en_lis_#ss #en_lis_#ss2) ; 01/09/10 YM "ADD DoorGroup" のｾｯﾄ
	    (SetG_PRIM22 #en_lis_#ss  #en_lis_#ss2)      ; "G_PRIM"(底面図形)拡張データの変更
	    (SetG_PRIM11 #en_lis_#ss2 #en_lis_#ss2)      ; "G_PRIM"(取り付け高さ)拡張データの変更
	    (SetG_BODY   #en_lis_#ss #en_lis_#ss2)       ; "G_BODY"(穴図形)拡張データの変更
  	)
	);_if
  (setq *error* nil)                           ; 後処理
  (setq EditFlag nil)
  (CFCmdDefFinish);00/09/13 SN ADD
  (PKEndCOMMAND #sys$); 00/08/25 SN ADD
	(princ "\nＺコピーしました。")
  (princ)

);_(defun

;<HOM>*************************************************************************
; <関数名>    : Z_Copy
; <処理概要>  : 設備Ｚコピー
; <戻り値>    : コピー後の選択セット
; <作成>      : 1999-12-2 YM
; <備考>      :
;*************************************************************************>MOH<
(defun Z_Copy(
  &ss
  /
  #i
  #ss2            ; コピーした図形の選択セット
  #old_lis        ; コピー前の図面上全図形リスト
  #new_lis        ; コピー後の図面上全図形リスト
  #os
  #dist
  #buf            ; ｚ移動相対座標の文字列化
  #baseen #basess;00/10/04 SN ADD
  )

; 00/09/27 SN MOD OSMODEのOFFはCommand Copy 直前に行う
; 00/06/26 SN MOD OSMODEは距離入力前にOFFする。
;  (setq #os (getvar "OSMODE"))
;  (setvar "OSMODE" 0)
  (setq #old_lis (CMN_all_en_list))                  ; (図面上の全ての図形名リスト(<図形名1>,2,3,...,n)
  ;// 距離を入力
  (setq #dist (getdist (strcat "\n距離<" (itoa (fix CG_ZMOVEDIST)) ">: ")));00/06/27 SN MOD ﾒｯｾｰｼﾞ変更
  ;(setq #dist (getdist (strcat "\n距離を入力<" (rtos CG_ZMOVEDIST) ">:")));00/06/27 SN MOD ﾒｯｾｰｼﾞ変更
  (if (/= #dist nil) (setq CG_ZMOVEDIST #dist))      ; グローバル変数で記憶
	(if (=  #dist nil) (setq #dist CG_ZMOVEDIST))  ; 02/08/28 YM ADD

; 00/06/26 SN MOD OSMODEは距離入力前にOFFする。
;  (setq #os (getvar "OSMODE"))
;  (setvar "OSMODE" 0)
  (setq #buf (strcat "0,0," (rtos CG_ZMOVEDIST)))    ; ｚ方向移動相対座標

  ;00/09/22 SN MOD 色戻し処理別関数
  (ChangeItemColor &ss '(("G_FILR")("G_LSYM")) nil)
  ;(repeat (- EditUndoM EditUndoU)
  ;  (command "_.undo" "B") ; 色を戻す
  ;)
  ;00/10/04 SN ADD 基準ｱｲﾃﾑは一旦Bylaerにする。
  (setq #baseen nil)
  (if (and (CFGetXRecord "BASESYM")                          ; 基準ｱｲﾃﾑがある 且つ
      (ssmemb (setq #baseen (handent (car (CFGetXRecord "BASESYM")))) &ss)) ; 基準ｱｲﾃﾑが &ss に入っていた
      (GroupInSolidChgCol2 #baseen "BYLAYER")   ;BYLAYER色に変更
  );_if

  (setq EditFlag 1)
  (setq #os (getvar "OSMODE"));00/09/27 SN ADD
  (setvar "OSMODE" 0)         ;00/09/27 SN ADD
  (command "._COPY" &ss "" "0,0,0" #buf)
  (setvar "OSMODE" #os)

  (setq #new_lis (CMN_all_en_list))                  ; (図面上の全ての図形名リスト(<図形名1>,2,3,...,n)

;;; コピー後の選択セット#ss2 ;;;
  (setq #ss2 (ssadd))
  (setq #i (+ (car #old_lis) 1))
  (while (<= #i (car #new_lis))
    (setq #ss2 (ssadd (nth #i #new_lis) #ss2))
    (setq #i (1+ #i))
  );_(while

  ;00/10/04 SN ADD 基準ｱｲﾃﾑは一旦色をBylayerにしているので、基準色にする。
  (if #baseen (progn
    (GroupInSolidChgCol #baseen CG_BaseSymCol) ;基準ｱｲﾃﾑ色に変更
    ;baseresetにより矢印は再作図されるが対象外にする。
    (setq #basess (ssget "X" '((-3 ("G_ARW")))))
    (setq #i 0)
    (repeat (sslength #basess)
      (ssdel (ssname #basess #i) #ss2)
      (setq #i (1+ #i))
    )
  ))

  #ss2

);_defun

;///////////////////////////////////////////////
(defun C:rrr ( / )
	(C:RotateCAB)
)
;<HOM>*************************************************************************
; <関数名>    : C:RotateCAB
; <処理概要>  : その場でｷｬﾋﾞﾈｯﾄを回転させる(正面、背面が入れ替わる)
; <戻り値>    : なし
; <作成>      : 01/03/16 YM
; <備考>      : 回転+移動のみ(G_LSYM回転角度のみ)
;*************************************************************************>MOH<
(defun C:RotateCAB (
  /
	#ANG #CAB-EN #D #DIST #DUM1 #ENGRP #LOOP #LPT #LU_PT #MIN #O #PMEN2 #PT$
	#SNKCAB #SS #SYM #SYS$ #W #XD$_LSYM #XD$_SYM
	#EG$ #ELM #FIG$ #I #SSARW #SSSYM #GR #OS #OT #SM
  )
  (StartUndoErr);00/10/02 SN MOD UNDO処理関数変更
  (setq #os (getvar "OSMODE"))
  (setq #sm (getvar "SNAPMODE"))
  (setq #gr (getvar "GRIDMODE"))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"     0)
  (setvar "SNAPMODE"   0)
  (setvar "GRIDMODE"   0)
  (setvar "ORTHOMODE"  0)

  (setq CG_BASESYM (CFGetBaseSymXRec))

  ;// シンクキャビネットを指示させる
  (setq #loop T)
  (while #loop
    (setq #cab-en (car (entsel "\nアイテムを選択: ")))
    (if #cab-en
      (progn ; 何か選ばれた
        (setq #sym (CFSearchGroupSym #cab-en)) ; ｼﾝﾎﾞﾙ図形名
				(if (and #sym (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB) "?" "?"))) ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
					(progn
						(GroupInSolidChgCol2 #sym CG_InfoSymCol)    ; 色を赤くする
						(setq #xd$_LSYM (CFGetXData #sym "G_LSYM")) ; 拡張ﾃﾞｰﾀ"G_LSYM"取得
						(setq #xd$_SYM  (CFGetXData #sym "G_SYM"))  ; 拡張ﾃﾞｰﾀ"G_SYM" 取得
						(setq #ang (nth 2 #xd$_LSYM)) ; 回転角度

					  (setq #fig$
					    (CFGetDBSQLRec CG_DBSESSION "品番図形"
					      (list
					        (list "品番名称" (nth 5 #xd$_LSYM)         'STR)
					        (list "LR区分"   (nth 6 #xd$_LSYM)         'STR)
					        (list "用途番号" (itoa (nth 12 #xd$_LSYM)) 'INT)
					      )
					    )
					  )
					  (setq #fig$ (DBCheck #fig$ "『品番図形』" "C:RotateCAB"))
			      (setq #w (nth 3 #fig$));2008/06/28 YM OK!
			      (setq #d (nth 4 #fig$));2008/06/28 YM OK!

;;;						(setq #W   (nth 3 #xd$_SYM))  ; 寸法D
;;;						(setq #D   (nth 4 #xd$_SYM))  ; 寸法W
						(setq #O (cdr (assoc 10 (entget #sym)))) ; ｼﾝﾎﾞﾙ基準点
						(setq #pmen2 (PKGetPMEN_NO #sym 2))      ; ｷｬﾋﾞPMEN2
			      (setq #pt$ (GetLWPolyLinePt #pmen2))     ; ｷｬﾋﾞPMEN2 外形領域
;  p1               p2
;  +----------------+
;  *ｼﾝﾎﾞﾙ           |
;  |                |
;  |                |
;  |                |
;  +----------------+
;  p4               p3
						; ｼﾝﾎﾞﾙとの最短距離と一番近い点
						(setq #min 1.0e+10)
						(foreach pt #pt$
							(setq #dist (distance pt #O))
							(if (< #dist #min)
								(progn
									(setq #min #dist)
									(if (equal #min 0 0.001)(setq #min 0))
;;;									(setq #LU_PT pt)
								)
							);_if
						)
;;;						(setq #pt$ (GetPtSeries #LU_PT #pt$))
          	(setq #loop nil)
					)
        	(CFAlertMsg "この部材はキャビネットではありません。")
        );_if
      )
      (CFAlertMsg "部材を選択してください。")
    );_if
  );_while

	(setq #ss (CFGetSameGroupSS #sym)) ; 同一グループ内の全図形選択セット

	(if (equal CG_BASESYM #sym);基準ｱｲﾃﾑ
		(progn
		  (setq #ssARW (ssget "X" '((-3 ("G_ARW"))))) ; 矢印も移動する
		  (CMN_ssaddss #ssARW #ss)
		)
	);_if

;;;	; 基準ｼﾝﾎﾞﾙ図形を抜き取る
;;;	(setq #ssSYM (ssadd))
;;;	(setq #i 0)
;;;	(repeat (sslength #ss)
;;;		(setq #elm (ssname #ss #i))
;;;		(setq #eg$ (entget #elm))
;;;		(if (and (= (cdr (assoc 0 #eg$)) "POINT")
;;;						 (< (distance #O (cdr (assoc 10 #eg$))) 0.1))
;;;			(ssadd #elm #ssSYM)
;;;		);_if
;;;		(setq #i (1+ #i))
;;;	)

	(if (and #ss (< 0 (sslength #ss)))
		(progn
			; 回転処理
			(command "._rotate" #ss "" #O 180) ;回転
			; 移動処理
			(setq #dum1 (polar #O #ang #W))
			(setq #lpt  (polar #dum1 (+ #ang (dtr -90)) (- #D (* 2 #min))))
			(command "_.MOVE" #ss "" #O #lpt)
		)
	);_if

;;;	;;; ｼﾝﾎﾞﾙ基準点を移動する
;;;	(command "_.MOVE" #ssSYM "" #lpt #O)

  ;// 色を戻す
	(if (equal CG_BASESYM #sym);基準ｱｲﾃﾑ
	  (GroupInSolidChgCol2 #sym CG_BaseSymCol) ; 矢印を作図しないで色を変更
	  (GroupInSolidChgCol2 #sym "BYLAYER")
	);_if

;;;	(setq #ss (CMN_enlist_to_ss #elm$)) ; 図形ﾘｽﾄ--->選択ｾｯﾄ

;;;  ;// 拡張データの更新
  (CFSetXData #sym "G_LSYM"
    (CFModList #xd$_LSYM
      (list (list 2 (Angle0to360 (+ #ang (dtr 180))))) ; 配置角度
    )
  )

  (setq *error* nil)   ; 後処理
  (setq EditFlag nil)
  (setvar "OSMODE"     #os)
  (setvar "SNAPMODE"   #sm)
  (setvar "GRIDMODE"   #gr)
  (setvar "ORTHOMODE"  #ot)
  (princ)
);C:RotateCAB

;<HOM>*************************************************************************
; <関数名>    : PcCabCutCall
; <処理概要>  : 選択したｷｬﾋﾞﾈｯﾄ部材の底をカットするコマンド(呼び出し用)
; <引数>      :なし
; <戻り値>    :なし
; <作成>      : 00/03/17 YM
; <備考>      :
;*************************************************************************>MOH<
(defun PcCabCutCall
  (
  &sym ; ｷｬﾋﾞﾈｯﾄｼﾝﾎﾞﾙ図形
  /
  #GR #OS #OT #SEIKAKU1 #SEIKAKU2 #SM #SYM #UF #UV #XD$ #clayer
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PcCabCutCall ////")
  (CFOutStateLog 1 1 " ")
;;;09/21YM  (command "._shademode" "3D") ; 隠線処理 解除(ｽﾋﾟｰﾄﾞｱｯﾌﾟ)07/07 YM ADD
	(setq #clayer (getvar "CLAYER"   )) ; 現在の画層をキープ ; 00/09/22 YM ADD
  (setq #os (getvar "OSMODE"))
  (setq #sm (getvar "SNAPMODE"))
  (setq #uf (getvar "UCSFOLLOW"))
  (setq #uv (getvar "UCSVIEW"))
  (setq #gr (getvar "GRIDMODE"))
  (setq #ot (getvar "ORTHOMODE"))
;;;  (setq #wv (getvar "WORLDVIEW"))
  (setvar "OSMODE"     0)
  (setvar "SNAPMODE"   0)
  (setvar "UCSFOLLOW"  1)
  (setvar "UCSVIEW"    0)
  (setvar "GRIDMODE"   0)
  (setvar "ORTHOMODE"  0)
;;;  (setvar "WORLDVIEW"  0)

  (command "_view" "S" "TEMP")
  (PcCabCutSub &sym)        ; ｶｯﾄ処理および拡張ﾃﾞｰﾀのｾｯﾄを行う
  (command "_layer" "F" SKD_TEMP_LAYER "") ; ﾃﾝﾎﾟﾗﾘｰ画層のﾌﾘｰｽﾞ

  (setvar "OSMODE"     #os)
  (setvar "SNAPMODE"   #sm)
  (setvar "UCSFOLLOW"  #uf)
  (setvar "UCSVIEW"    #uv)
  (setvar "GRIDMODE"   #gr)
  (setvar "ORTHOMODE"  #ot)
;;; (setvar "WORLDVIEW"  #wv)
	(setvar "CLAYER" #clayer)   ; 元の画層に戻す ; 00/09/22 YM ADD
;;;09/21YM  (command "._shademode" "H") ; 隠線処理 解除(ｽﾋﾟｰﾄﾞｱｯﾌﾟ)07/07 YM ADD
  (setq *error* nil)
  (princ)
)
;PcCabCutCall

;;;<HOM>*************************************************************************
;;; <関数名>    : PcCabCutSub
;;; <処理概要>  : ｷｬﾋﾞﾈｯﾄ部材の底をカット
;;; <引数>      :
;;; <戻り値>    :
;;; <作成>      : 2000.2.28 YM
;;; <備考>      :
;;;             : 前田康志
;;;*************************************************************************>MOH<
(defun PcCabCutSub (
  &sym ; 部材ｼﾝﾎﾞﾙ図形
  /
  #BASEPT
  #BRK #BRK_LINE
  #DD
  #DUM_BP #DUM_P0 #DUM_P1
  #ELM #EN_LAYER_LIS
  #ET #GNAM #H #T
  #I #LOOP
  #LST$$
  #MSG
  #P0 #P1 #P2
  #PT$
  #RAD
  #SS #SS2 #SS_3D #SS_NO3D
  #SYM
  #XD$_BRK #XD$_LSYM #XD$_PMEN #XD$_SYM
  #YOBIX #YOBIY
  #210 #HH #TEI #TT #XD$_PRIM #zu_id #LIS_DIM
  )

;;; ビューを元に保存する
  (command "_view" "S" "TEMP")

  (setq #sym &sym)
  (setq #xd$_BRK nil)
  (setq #xd$_LSYM (CFGetXData #sym "G_LSYM"))        ; 拡張ﾃﾞｰﾀ"G_LSYM"取得
  (setq #BasePt (nth 1 #xd$_LSYM))                   ; 挿入点
  (setq #rad    (nth 2 #xd$_LSYM))                   ; 回転角度 radian
  (setq #xd$_SYM (CFGetXData #sym "G_SYM"))          ; 拡張ﾃﾞｰﾀ "G_SYM"取得
  (setq #H   (nth 5 #xd$_SYM))                       ; ｼﾝﾎﾞﾙ基準値H
  (setq #T   (nth 6 #xd$_SYM))                       ; ｼﾝﾎﾞﾙ取付け高さ

  (setq #ss (CFGetSameGroupSS #sym))                 ; 同一グループ内の全図形選択セット

;;; 3DSOLID とそれ以外を分ける
  (setq #i 0)
  (setq #ss_3D   (ssadd))
  (setq #ss_NO3D (ssadd)); 移動のみ
  (setq #lis_DIM '())
  (setq #loop T)
  (repeat (sslength #ss) ; 同一グループ内の全図形
    (setq #elm (ssname #ss #i)) ; 各要素
    (setq #et  (entget #elm))
    (if (= (cdr (assoc 0 #et)) "3DSOLID") ; 3DSOLID   ;----------------------------------------
      (progn
        (ssadd #elm #ss_3D) ; SOLIDの集まり
      )
      (progn                              ; 3DSOLID以外;---------------------------------------
        (if (/= (cdr (assoc 0 #et)) "DIMENSION") ; 寸法以外 00/03/22 YM ADD
          (ssadd #elm #ss_NO3D) ; 2D図形の集まり
          (setq #lis_DIM (append #lis_DIM (list #elm))) ; DIMENSION図形の集まりﾘｽﾄ
        );_if
;;;       (if (and (= (cdr (assoc 0 #et)) "XLINE") (= (cdr (assoc 8 #et)) "C_BREAKH"))  ; 00/03/23 BL なし 保留中
;;;         (progn                                         ; XLINEなら
;;;           (setq #brk #elm)                             ; 図形名
;;;           (setq #xd$_BRK (CFGetXData #brk "G_BRK"))    ; 拡張ﾃﾞｰﾀ"G_BRK"取得
;;;         )
;;;       );_if
        ;;; PMEN 2 領域点列の取得
        (setq #xd$_PMEN (CFGetXData #elm "G_PMEN"))
        (if (and #xd$_PMEN #loop)
          (progn
            (if (= 2 (car #xd$_PMEN))
              (progn
                (setq #pt$ (GetLWPolyLinePt #elm))                  ; キャビネットのＰ面２外形領域点列を求める
                (foreach #pt #pt$                                   ; 基準点から座標の遠い順にソートする
                  (setq #dd (distance #BasePt #pt))
                  (setq #lst$$ (cons (list #pt #dd) #lst$$))
                )
                (setq #lst$$ (reverse (CFListSort #lst$$ 1)))
                (setq #p1 (append (car (nth 0 #lst$$)) (list #T)) ) ; BPから1番遠い点 ---> 3D点
                (setq #loop nil)
              );_progn
            );_if
          );_progn
        );_if
      )
    );_if
    (setq #i (1+ #i))
  );_(repeat

  (if #loop ; 00/03/21 YM ADD
    (progn
      (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; 図形ID
      (setq #msg (strcat "図形ID=" #zu_id "に PMEN2 がありません。\nPcCabCutSub"))
      (CFOutStateLog 0 1 #msg)
      (CFAlertMsg #msg)
      (*error*)
    )
  );_if     ; 00/03/21 YM ADD

;;; #BasePt , #p1 から #p0を求めるstretchに使用   ; 03/23 MOD YM
  (setq #dum_BP (mapcar '- #BasePt #BasePt))     ; 平行移動
  (setq #dum_P1 (mapcar '- #p1 #BasePt))         ; 平行移動
  (setq #dum_P1 (RotatePoint #dum_P1 (- #rad)))  ; 回転
  (setq #dum_P0 (list (car #dum_BP) (cadr #dum_P1) (caddr #dum_P1)))
  (setq #dum_P0 (RotatePoint #dum_P0 #rad))  ; 回転
  (setq #p0 (mapcar '+ #dum_P0 #BasePt))     ; 平行移動
  (setq #p2 (list (car #p0) (cadr #p0) #H))

  (setq #en_Layer_lis (Chg_SStoEnLayer #ss_NO3D))       ; 選択ｾｯﾄ--->(<図形名> 画層)のﾘｽﾄのﾘｽﾄに変換
  (MakeTempLayer)                                       ; 伸縮作業用テンポラリ画層の作成
  (command "chprop" #ss_NO3D "" "LA" SKD_TEMP_LAYER "") ; 対象ｷｬﾋﾞﾈｯﾄ(3DSOLID除く)全体をﾃﾝﾎﾟﾗﾘｰ画層へ移動

;;; 3DSOLID以外の処理
;;; 部材を正面からみて左隅を原点としてucs作成
;;; 底面部分ssget--->stretch(3DSOLIDﾌﾘｰｽﾞして除く)
  (command "_.ucs" "3"                           ; #p1 は底面上で挿入点から一番遠い点
    #p0 ; 原点
    #p1 ; x方向
    #p2 ; y方向
  )

  (if (and #xd$_BRK (= 3 (car #xd$_BRK)) )
    (progn
      (setq #brk_line (caddr (cdr (assoc 10 (entget #brk)))) )
    )
    (progn
;;;     (CFAlertErr "このアイテムには伸縮ラインがありませんでした")(*error*)   ; 00/03/19 臨時
      (princ "\nこのアイテムには伸縮ラインがありませんでした.")   ; 00/03/19 臨時
      (setq #brk_line 100) ; 00/03/19 臨時
    )
  );_if

;;; ｽﾄﾚｯﾁ 少し広めに選択する
  (setq #yobix 1000.0)
  (setq #yobiy 1.0)

  (command "_.stretch"
    (ssget "C"
      (list (+ (distance #p1 #p0) #yobix) (+ #brk_line #yobiy))
      (list (- #yobiy) (- #yobiy))
      (list (cons 8 SKD_TEMP_LAYER)) ; ﾃﾝﾎﾟﾗﾘｰ画層
    )
    ""
    '(1 -1)
    (strcat "@" "0," (rtos CG_CabCut))
  )

  (setq #ss2 (ssget "X" (list (cons 8 SKD_TEMP_LAYER))))
;;; (command "chprop" #ss2 "" "C" "2" "") ; 黄色
;;; (command "_.move" #ss2 "" "0,0" (list 0 (- CG_CabCut))) ; stretchで移動してしまった各図形の移動
  (BackLayer #en_Layer_lis) ; 画層を元に戻す
  (command "_.ucs" "P")

;;; 3DSOLIDの処理 底面も含めて2D図形を伸縮した後に3DSOLID再作成(要注意)
  (setq #i 0)
  (setq #gnam (SKGetGroupName (ssname #ss_3D 0))) ; ｸﾞﾙｰﾌﾟ名
  (command "._UCS" "W")

  (repeat (sslength #ss_3D)
    (setq #elm (ssname #ss_3D #i))  ; 各SOLID
;;;    (setq #xd$_PRIM (entget #elm '("G_PRIM")))
;;;    (setq #gnam (SKGetGroupName #elm)) ; ｸﾞﾙｰﾌﾟ名
;;;   (command "._UCS" "W")
;;;    (setq #elm (SKS_RemakePrim #elm)) ; #elm  "G_PRIM"を持った"3DSOLID"で、画層"Z_00_00_00_01"
    (setq #elm (PcRemakePrim_CabCut #elm)) ; #elm  "G_PRIM"を持った"3DSOLID"で、画層"Z_00_00_00_01"
;;;   (command "._UCS" "P")
    (command "-group" "A" #gnam #elm "") ; グループに入れる
    (setq #i (1+ #i))
  )

;;; この時点ではZ=50の位置にキャビネットがある
;;; (1)押し出し'(0 0 1) and 取り付け高さ0上向き押し出し or 取り付け高さ0<下向き押し出し
  (setq #ss (CFGetSameGroupSS #sym))  ; 同一グループ内の全図形選択セット
;;; #ss_DIM を除く

  (setq #i 0)
  (repeat (length #lis_DIM)
    (setq #elm (nth #i #lis_DIM))
    (ssdel #elm #ss)
    (setq #i (1+ #i))
  )

;;; (setq #i 0)
;;; (setq #ss_3D  (ssadd))
;;; (repeat (sslength #ss)                             ; 同一グループ内の全図形
;;;   (setq #elm (ssname #ss #i))
;;;   (setq #et  (entget #elm))
;;;   (if (= (cdr (assoc 0 #et)) "3DSOLID")            ; SOLID
;;;     (progn
;;;       (setq #xd$_PRIM (CFGetXData #elm "G_PRIM"))  ; 拡張ﾃﾞｰﾀ"G_PRIM"取得
;;;       (setq #TEI (nth 10 #xd$_PRIM))               ; 底面図形
;;;       (setq #210 (cdr (assoc 210 (entget #TEI))))  ; 押し出し方向
;;;       (if (equal #210 '(0 0 1))                    ; 底面押し出し'(0 0 1)
;;;         (progn
;;;           (setq #HH  (nth  6 #xd$_PRIM)) ; 取り付け高さ
;;;           (setq #TT  (nth  7 #xd$_PRIM)) ; 要素厚み
;;;           (if (or (and (< (abs (- #HH 0.0)) 0.1) (> #TT CG_CabCut)) ; 取り付け高さ0.0 要素厚み>50.0
;;;                   (and (> #HH CG_CabCut) (<= #TT (- #HH))))         ; 取り付け高さ>50.0 要素厚み<-取り付け高さ
;;;             (progn
;;;               (ssadd #elm #ss_3D) ; 該当SOLID
;;;             )
;;;           );_if
;;;         )
;;;       );_if
;;;     )
;;;   );_if
;;;   (setq #i (1+ #i))
;;; )
  (command "_.move" #ss "" "0,0" (list 0 0 (- CG_CabCut))) ; "DIMENSION"は除く

;;; (PcSlice_Down #BasePt #ss_3D CG_CabCut)

;;; ｼﾝﾎﾞﾙ基準値Hの更新
  (CFSetXData #sym "G_SYM"
    (list
      (nth  0 #xd$_SYM)
      (nth  1 #xd$_SYM)
      (nth  2 #xd$_SYM)
      (nth  3 #xd$_SYM)
      (nth  4 #xd$_SYM)
      (- (nth  5 #xd$_SYM) CG_CabCut) ; ｼﾝﾎﾞﾙ基準値H 50 小さくなる
      (nth  6 #xd$_SYM)
      (nth  7 #xd$_SYM)
      (nth  8 #xd$_SYM)
      (nth  9 #xd$_SYM)
      (nth 10 #xd$_SYM)
      (nth 11 #xd$_SYM)
      (nth 12 #xd$_SYM)
      (- (nth  5 #xd$_SYM) CG_CabCut) ; ｼﾝﾎﾞﾙ基準値H 50 小さくなる 00/07/10 MH MOD
      ;(nth  5 #xd$_SYM) ; 伸縮Ｈ --- 元のｼﾝﾎﾞﾙ基準値Ｈを残す 00/03/23 YM MOD
      (nth 14 #xd$_SYM)
      (nth 15 #xd$_SYM)
      (nth 16 #xd$_SYM)
    )
  )

;;; ビューを元に戻す
  (command "_view" "R" "TEMP")

  (setq *error* nil)
  (princ)
);PcCabCutSub


;<HOM>*************************************************************************
; <関数名>    : PcRemakePrim_CabCut
; <処理概要>  : 要素図形の拡張データ情報から要素を再作成する(H800 PcCabCutSub専用)
; <ヒキスウ>  : 図形名"G_PRIM"を持った"3DSOLID"で、画層"Z_00_00_00_01"にあるもの
; <作成日>    : 1998-07-30 S.Kawamoto →2000.4.1 YM MOD→2000.8.17 MH MOD
; <備考>      : 要素図形(G_PRIM)、要素底面図形(G_BODY)、要素穴底面図形(G_ANA)の
;               情報を元に再作成する
;               04/01 YM 押し出し方向の判断を付加した
;               08/17 MH 底面領域がXY平面で厚値がCG_CabCutより小のケースの処理追加
;*************************************************************************>MOH<
(defun PcRemakePrim_CabCut (
  &prm        ;(ENAME)要素ｴﾝﾃｨﾃｨ名   "G_PRIM"を持った"3DSOLID"で、画層"Z_00_00_00_01"
  /
  #prxd$ #dn #eg$ #prm #bdxd$ #ana$ #i #ana #anxd$ #typ
  #38 #EN_KOSU1 #EN_KOSU2 #teimen #NEW_SOLID #pt$ #FLG #chkZ
  #NEW_INTER #NEW_INTER_HAND #NEW_SOLID_HAND
  #210 #ELM_T #EN #HH #TT
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PcRemakePrim_CabCut ////")
  (CFOutStateLog 1 1 " ")

  (command "vpoint" "1,-1,1")
  ;// ﾌﾟﾘﾐﾃｨﾌﾞの拡張ﾃﾞｰﾀを取得
  (setq #prxd$ (CFGetXData &prm "G_PRIM"))
  (setq #dn (nth 10 #prxd$))   ;// 3DSOLIDの底面領域図形名(ポリライン)
  (if (/= #dn nil)
    (progn
      ;// 底面領域のｺﾋﾟｰをｿﾘｯﾄﾞに展開する
      (setq #eg$ (entget #dn)) ; 底面領域図形(ポリライン)情報
      (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER = "Z_00_00_00_01"
      (setq #teimen (entlast))
      (setq #eg$ (entget #teimen)); コピーした底面領域図形情報(画層は同じでもﾊﾝﾄﾞﾙは変わる) ---> (entlast)
      (setvar "CLAYER" SG_PCLAYER)  ; 現在の画層をSG_PCLAYERに設定
      ;// 要素の再作成
      (if (/= (car #prxd$) 3) ; "G_PRIM" ﾀｲﾌﾟが単一面でない 厚み付き or 線識面
        (progn
					;2020/01/08 YM MOD AutoCAD2009対応
          (command "_extrude" #teimen "" "T" (nth 9 #prxd$) (nth 7 #prxd$))  ;// 厚み"7"とﾃｰﾊﾟ角度"9"で押出し
;;;          (command "_extrude" #teimen "" (nth 7 #prxd$) (nth 9 #prxd$))  ;// 厚み"7"とﾃｰﾊﾟ角度"9"で押出し
          (setq #new_SOLID (entlast))
          (setq #new_SOLID_HAND (cdr (assoc 5 (entget #new_SOLID))))

          ;;; 00/08/17 MH ADD
          ;;; 底面領域図形がXY平面で厚み値がストレッチ移動量CG_CabCutより小の場合
          ;;; 判定前にオリジナル3DSOLIDを移動させる
          ;(setq #FLG nil)
          ;(if (>= CG_CabCut (nth 7 #prxd$)) (progn
          ;  (setq #pt$ (GetLWPolyLinePt #teimen))
          ;  (setq #FLG 'T)
          ;  (setq #chkZ (caddr (car #pt$)))
          ;  ;;; ポリラインを構成する点のZ値が同一だった= XY平面図形
          ;  (foreach #pt #pt$
          ;    (if (not (equal #ChkZ (caddr #pt) 0.001)) (setq #FLG nil))
          ;  ) ; foreach
          ;  ;;; オリジナル3DSOLIDを移動
          ;  (if #FLG (command "_move" &prm "" '(0 0 0) (list 0 0 CG_CabCut) ""))
          ;)); if progn

          ;;; この時点で新しいSOLIDと古いSOLIDの両方ある
          (setq #en_kosu1 (CMN_all_en_kosu)) ; 図面上にある図形の総数
          ;;; 新しいSOLIDと古いSOLIDの共通部分
          (command "._intersect" #new_SOLID &prm "") ; 共通部分があるかどうか
          ;(if (and #FLG (entget &prm))
          ;  (command "_move" &prm "" (list 0 0 CG_CabCut) '(0 0 0) ""))
          ;;; #new_SOLID &prm の順番重要 #new_SOLID ⊂ &prm の場合
          ;;; #new_SOLIDが残り、&prmが消える
          (setq #en_kosu2 (CMN_all_en_kosu)) ; 図面上にある図形の総数
          (setq #new_INTER (entlast))
          (setq #prm (entlast)) ; "3DSOLID" #new_SOLID ⊂ &prm の場合
          (setq #new_INTER_HAND (cdr (assoc 5 (entget #new_INTER))))

          ;;; 総数が-1==>共通部分あり   総数が-2==>共通部分なし
          (if (= (- #en_kosu1 #en_kosu2) 2) ; OK!
            (progn
              ;;; 押し出し方向が反対だったので反対方向に改めて作成
              (entmake #eg$) ; SG_PCLAYER = "Z_00_00_00_01"
              (setq #teimen (entlast))
              ;00/08/23 SN MOD
              ;底面押し出しの厚みが小さい要素は反対にしない
              (setq #HH  (nth  6 #prxd$)) ; 取り付け高さ
              (setq #TT  (nth  7 #prxd$)) ; 要素厚み
              (setq #210 (cdr (assoc 210 (entget #dn))))  ; 押し出し方向
              (if (and (equal #210 '(0 0 1))              ; 底面押し出し'(0 0 1)
                       (< #TT CG_CabCut))                 ; 要素厚み<50.0
                #TT
                (setq #TT (- #TT))
              )
              (command "_extrude" #teimen "" #TT (nth 9 #prxd$))
              ;(command "_extrude" #teimen "" (- (nth 7 #prxd$)) (nth 9 #prxd$))
              (setq #prm (entlast)) ; "3DSOLID"
            )
          );_if

          (if (= (- #en_kosu1 #en_kosu2) 1) ; 古いSOLID∩新しいSOLID＝新しいSOLID
            (progn ; G_PRIM更新
              (if (equal #new_INTER_HAND #new_SOLID_HAND) ; ﾊﾝﾄﾞﾙが同じ
                (progn
                  (setq #210 (cdr (assoc 210 (entget #dn))))  ; 押し出し方向
                  (if (equal #210 '(0 0 1))                    ; 底面押し出し'(0 0 1)
                    (progn
                      (setq #HH  (nth  6 #prxd$)) ; 取り付け高さ
                      (setq #TT  (nth  7 #prxd$)) ; 要素厚み
                      (if (or (and (< (abs (- #HH 0.0)) 0.1) (> #TT CG_CabCut)) ; 取り付け高さ0.0 要素厚み>50.0
                              (and (> #HH CG_CabCut) (<= #TT (- #HH))))         ; 取り付け高さ>50.0 要素厚み<-取り付け高さ
                        (progn
                          (if (< #TT 0.0)
                            (setq #elm_T (+ #TT CG_CabCut))  ; 要素厚み 負の場合 押し出し距離＋
                            (setq #elm_T (- #TT CG_CabCut))  ; 要素厚み 正の場合 押し出し距離－
                          );_if
                          (setq #prxd$ (CFModList #prxd$ (list (list 7 #elm_T))))
                        )
                      );_if
                    )
                  );_if
                )
                (progn
                  (entdel (entlast)) ; 共通部分SOLID削除 古いSOLID∩新しいSOLID＜新しいSOLID
                  ;;; 正しかったのでもう一度作成
                  (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER = "Z_00_00_00_01"
                  (setq #teimen (entlast))
									;2010/01/08 YM MOD AutoCAD2009対応
                  (command "_extrude" #teimen "" "T" (nth 9 #prxd$) (nth 7 #prxd$))  ;// 厚み"7"とﾃｰﾊﾟ角度"9"で押出し
;;;                  (command "_extrude" #teimen "" (nth 7 #prxd$) (nth 9 #prxd$))  ;// 厚み"7"とﾃｰﾊﾟ角度"9"で押出し
                  (setq #prm (entlast)) ; "3DSOLID"
                )
              );_if
            )
          );_if


          ;// 元のﾌﾟﾘﾐﾃｨﾌﾞを削除
;;;          (entdel &prm) ; 引数 3DSOLID
          (CFSetXData #prm "G_PRIM" #prxd$) ; 押し出しｿﾘｯﾄﾞに拡張ﾃﾞｰﾀ"G_PRIM"をｾｯﾄ
          ;// 穴の作り直し
          (setq #bdxd$ (CFGetXData #dn "G_BODY")); 底面図形(ポリライン)の"G_BODY" : PLINE 底面 or 上面に付加する情報
          (if (/= #bdxd$ nil)
            (progn
              (setq #ana$ nil)
              (setq #i 2)
              (repeat (nth 1 #bdxd$)        ; 穴ﾃﾞｰﾀ数分繰り返す
                (setq #ana (nth #i #bdxd$)) ; 穴図形名 #i=2
                (setq #anxd$ (CFGetXData #ana "G_ANA"))
                (setq #eg$ (entget #ana)) ; 穴図形情報
                ;// 穴の押出し
                (setq #typ (nth 1 #anxd$)) ; 穴深さﾀｲﾌﾟ

;;;                (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; 00/02/29 YM ADD ; 穴図形のｺﾋﾟｰSG_PCLAYER="Z_00_00_00_01"
                (cond
                  ((= #typ 0)  ;// 貫通穴
                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$))       ; 穴図形のｺﾋﾟｰ  SG_PCLAYER="Z_00_00_00_01"
										;2010/01/08 YM MOD AutoCAD2009対応
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) (nth 7 #prxd$)) ; 穴の押し出し nth 7厚み  nth 3ﾃｰﾊﾟ角度
;;;                    (command "_extrude" (entlast) "" (nth 7 #prxd$) (nth 3 #anxd$)) ; 穴の押し出し nth 7厚み  nth 3ﾃｰﾊﾟ角度
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 0 (nth 2 #anxd$) (nth 3 #anxd$))) ; 穴深さﾀｲﾌﾟ 0 貫通穴
                  )
                  ((= #typ 1)  ;// 底面くり貫き
                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER="Z_00_00_00_01"
										;2010/01/08 YM MOD AutoCAD2009対応
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) (nth 2 #anxd$)) ; 穴の押し出し nth 2穴深さ  nth 3ﾃｰﾊﾟ角度
;;;                    (command "_extrude" (entlast) "" (nth 2 #anxd$) (nth 3 #anxd$)) ; 穴の押し出し nth 2穴深さ  nth 3ﾃｰﾊﾟ角度
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 1 (nth 2 #anxd$) (nth 3 #anxd$))) ; 穴深さﾀｲﾌﾟ 1 底面くり貫き
                  )
                  ((= #typ 2)  ;// 上面くり貫き
                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER="Z_00_00_00_01"
										;2010/01/08 YM MOD AutoCAD2009対応
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) (nth 2 #anxd$)) ; 穴の押し出し nth 2穴深さ  nth 3ﾃｰﾊﾟ角度
;;;                    (command "_extrude" (entlast) "" (nth 2 #anxd$) (nth 3 #anxd$)) ; 穴の押し出し nth 2穴深さ  nth 3ﾃｰﾊﾟ角度
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 2 (nth 2 #anxd$) (nth 3 #anxd$))) ; 穴深さﾀｲﾌﾟ 2 貫通穴
                  )
                )

                ;// 要素との差をとる
                (command "_subtract" #prm "" (entlast) "")
                (setq #i (1+ #i))
              );_(repeat
            )
          );_if
          #prm ; 戻り値
        );_progn ; "G_PRIM" ﾀｲﾌﾟが単一面でない 厚み付き or 線識面
      ;else
        nil      ; "G_PRIM" ﾀｲﾌﾟが単一面のとき
      );_if
    )
  )
)
; PcRemakePrim_CabCut

;;;<HOM>*************************************************************************
;;; <関数名>    : PcSlice_Down
;;; <処理概要>  : 部材のｽﾗｲｽ+下方移動(前面の板)
;;; <戻り値>    : なし
;;; <作成>      : 2000.2.28 YM 3/22改良
;;; <備考>      :
;;;             : 前田康志
;;;*************************************************************************>MOH<
(defun PcSlice_Down (
  &pt   ; 円包丁の中心点
  &ss   ; ｽﾗｲｽ前SOLID選択ｾｯﾄ
  &dist ; ｽﾗｲｽ面の底面からの距離
  /
  #CIR #CUT #EN #EN2 #I #NEW_LIS #OLD_LIS #XD$_PRIM #KOSU #tei #ELM_T #TT
  )
  (if (and &ss (> (sslength &ss) 0))
    (progn
      (command "._circle" &pt "1000")         ; 中心が挿入点、半径1000の円
      (setq #cir (entlast))
      (command "._region" #cir "")            ; 円--->region(ｽﾗｲｽする包丁の役目)
      (setq #cut (entlast))
      (command "._move" #cut "" (list 0 0 0) (list 0 0 &dist))   ; 包丁をｶｯﾄ位置に移動
      (setq #old_lis (CMN_all_en_list))       ; (図面上の全ての図形名リスト(<図形名1>,2,3,...,n)
      (command "._slice" &ss "" "O" #cut "B") ; ｽﾗｲｽ元 &enをｶｯﾄ
      (setq #new_lis (CMN_all_en_list))       ; (図面上の全ての図形名リスト(<図形名1>,2,3,...,n) #old_lisより1つ多い

      (setq #i (+ (car #old_lis) 1))
      (setq #kosu (- (length (cdr #new_lis)) (length (cdr #old_lis))))
      (repeat #kosu
        (setq #en2 (nth #i #new_lis))           ; ｽﾗｲｽ後追加ｿﾘｯﾄﾞ #en2
        (entdel #en2) ; ｽﾗｲｽしたものを削除
        (setq #i (1+ #i))
      )
      (entdel #cut) ; 包丁削除
      (command "._move" &ss "" "0,0,0" (list 0 0 (- &dist))) ; ｽﾗｲｽ元を移動

    ;;; 要素厚みの変更(影響のあるSOLIDのみ) 00/03/22 YM MOD
    ;;; 底面領域は stretch 図形ﾊﾝﾄﾞﾙ変化なし
      (setq #i 0)
      (setq #kosu (sslength &ss))
      (repeat #kosu
        (setq #en (ssname &ss #i))                  ; 各ｿﾘｯﾄﾞ #en
        (setq #xd$_PRIM (CFGetXData #en "G_PRIM"))  ; 拡張ﾃﾞｰﾀ"G_PRIM"取得
        (setq #TT (nth  7 #xd$_PRIM))               ; 要素厚み
        (if (< #TT 0.0)
          (setq #elm_T (+ (nth  7 #xd$_PRIM) &dist))  ; 要素厚み 負の場合 押し出し距離＋
          (setq #elm_T (- (nth  7 #xd$_PRIM) &dist))  ; 要素厚み 正の場合 押し出し距離－
        );_if

        (CFSetXData #en "G_PRIM"                    ; "G_PRIM"取り付け高さの更新   ; 下向き要変更
          (list
            (nth  0 #xd$_PRIM)
            (nth  1 #xd$_PRIM)
            (nth  2 #xd$_PRIM)
            (nth  3 #xd$_PRIM)
            (nth  4 #xd$_PRIM)
            (nth  5 #xd$_PRIM)
            (nth  6 #xd$_PRIM)
            #elm_T             ; 要素厚み ; 下向き要変更
            (nth  8 #xd$_PRIM) ; 傾斜角度
            (nth  9 #xd$_PRIM)
            (nth 10 #xd$_PRIM) ; 底面図形
          )
        )
        (setq #i (1+ #i))
      );_(repeat
    )
  );_if

  (princ)
);PcSlice_Down

;<HOM>*************************************************************************
; <関数名>    : ItemSelKEKOMI
; <処理概要>  : ｱｲﾃﾑ選択関数
;               指定点下にｱｲﾃﾑがある場合はｱｲﾃﾑ選択
;               指定点下にｱｲﾃﾑがない場合
;               　左から右窓：範囲内に全て入っているｱｲﾃﾑを選択
;               　右から左窓：範囲内に一部でも入っているｱｲﾃﾑを選択
; <引数>      : &XDataLst$$ 選択対象ｱｲﾃﾑのXDATA群
;               (("G_WRKT" "G_FILR")("G_LSYM")) nth 1はｸﾞﾙｰﾌﾟ処理用
;               &iCol 選択ｱｲﾃﾑ表示色
; <戻り値>    : 選択ｾｯﾄ
; <作成>      : 00/09/06 SN ADD 01/01/18 YM 改造
; <備考>      :(ｹｺﾐ伸縮ｺﾏﾝﾄﾞ用)
;*************************************************************************>MOH<
(defun ItemSelKEKOMI(
	&XDataLst$$
	&iCol
	&SKK$ ; 性格ｺｰﾄﾞﾘｽﾄ ﾌﾛｱｷｬﾋﾞ("1" "1" "?"),ｼﾝｸｷｬﾋﾞ("1" "1" "2")
  /
  #enp #pp1 #pp2 #en
  #ssRet #ss #sswork
  #gmsg #i #ii #setflag
  #engrp #ssgrp
  #xd$ #ENR #RET$
  )

  ;*********************************************
  ; 繰り返しｱｲﾃﾑの選択
  ;*********************************************
  (setq #ssRet (ssadd))
  (setq #pp1 T)
  (while #pp1
    ;---------------------------------------------
    ; ｱｲﾃﾑ一回選択の処理
    ;---------------------------------------------
    (setq org*error* *error*)   ;ItemSel特殊処理 元々の*error*関数を記憶
    (setq *error* cancel*error*);ItemSel特殊処理 *error*関数にItemSel用の関数を被せる
    (setq #enp (entselpoint "\nアイテムを選択:"))
    (setq *error* org*error*)   ;ItemSel特殊処理 元々の*error*関数に戻す
    (setq #pp1 (cadr #enp))
    ;左ﾎﾞﾀﾝ押下
    (if #pp1 (progn
      (setq #en #enp)
      ;選択点にｵﾌﾞｼﾞｪｸﾄあり
      (if (car #en)
        (progn;then
          ;選択ｵﾌﾞｼﾞｪｸﾄを選択ｾｯﾄに加算
          (setq #ss (ssadd))
          (ssadd (car #en) #ss)
        );end progn
        (progn;else
          ;窓指定処理
          (setq #pp2 nil)
          (setq #gmsg " もう一方のｺｰﾅｰを指定:")
          (while (not #pp2);ｺｰﾅｰが選択されるまでﾙｰﾌﾟ
            (setq #pp2 (getcorner #pp1 #gmsg))
            (if #pp2
              ;左ﾎﾞﾀﾝ押下
              (progn
                (if (< (car (trans #pp1 0 2)) (car (trans #pp2 0 2)))
                  ;左→右選択
                  (progn;then
                    (setq #sswork (ssget "W" #pp1 #pp2))
                    (setq #ss (ItemSurplus #sswork &XDataLst$$))
                    (setq #sswork  nil)
                  );end progn
                  ;右→左
                  (progn;else
                    (setq #ss (ssget "C" #pp1 #pp2))
                  );end progn
                );end if
              );end progn
              ;右ﾎﾞﾀﾝ押下
              (progn
                (princ "\n窓の指定が無効です.")
                (setq #gmsg "\nアイテムを選択: もう一方のｺｰﾅｰを指定:")
              )
            );end if
          );end while
        );end progn
      );end if
    ));end if - progn
    ;---------------------------------------------
    ;選択アイテムの色を変える
    ;---------------------------------------------
    (if #ss (progn
      (setq #ret$ (ChangeItemColorKEKOMI #ss &iCol &SKK$))
      (setq #ssGrp (car  #ret$))
      ;色を変えたｱｲﾃﾑを戻り値選択ｾｯﾄへ加算
      (setq #i 0)
      (repeat (sslength #ssGrp)
        (ssadd (ssname #ssGrp #i) #ssRet)
        (setq #i (1+ #i))
      )
      ;選択ｾｯﾄあり且つ色変更したアイテムが無い場合、選択不可のアイテムとみなす。
      (if (and (> (sslength #ss) 0) (<= (sslength #ssGrp) 0))
        (CFAlertErr "このアイテムは選択できません。")
;;;        (CFAlertErr "シンボルが含まれていません。")
      )
      (setq #ss nil)
      (setq #ssGrp nil)
    ));end if - progn
  );end while

  ;*********************************************
  ; 対象除去ｱｲﾃﾑ選択
  ;*********************************************
  (setq #enR 'T)
  ;右ﾎﾞﾀﾝ押下or戻り値選択ｾｯﾄがなくなったら終了
  (while (and #enR (> (sslength #ssRet) 0))
    (setq #enR (car (entsel "\n対象から除くアイテムを選択:")))
    ;戻り値選択ｾｯﾄのﾒﾝﾊﾞｰのみ処理する。
    (if (and #enR (ssmemb #enR #ssRet))(progn
      ;一時的に選択ｾｯﾄを作成
      (setq #sswork (ssadd))
      (ssadd #enR #sswork)
      ;選択ｱｲﾃﾑの色を戻す
      (setq #ret$ (ChangeItemColorKEKOMI #sswork nil &SKK$))
      (setq #ssGrp (car  #ret$))
;;;      (setq #ssGrp (ChangeItemColor #sswork &XDataLst$$ nil))
      ;色を戻したｱｲﾃﾑを戻り値選択ｾｯﾄから除去
      (setq #i 0)
      (repeat (sslength #ssGrp)
        (ssdel (ssname #ssGrp #i) #ssRet)
        (setq #i (1+ #i))
      )
      (setq #sswork nil)
      (setq #ssGrp nil)
    ));end if - progn
  ); while

  #ssRet
);ItemSelKEKOMI

;<HOM>*************************************************************************
; <関数名>    : ChangeItemColorKEKOMI
; <処理概要>  : 選択ｾｯﾄに含まれるｱｲﾃﾑの色を変える
;             : 選択ｾｯﾄに一部でも含まれているとそのｸﾞﾙｰﾌﾟを探しだす。
;             :
; <戻り値>    : (色を変えた全てのｵﾌﾞｼﾞｪｸﾄを含む選択ｾｯﾄ,ｼﾝﾎﾞﾙﾘｽﾄ)
;             :
; <作成>      : 00/09/22 SN ADD 01/01/17 YM 改造
; <備考>      : &iCol=nilで なにも選択していない状態に戻す。
;               性格ｺｰﾄﾞ"11?"のみ色を変える(ｹｺﾐ伸縮ｺﾏﾝﾄﾞ用)
;               ｼﾝｸ,水栓,ｺﾝﾛも選択可能(寸法伸縮+Ｚ移動するため)
;*************************************************************************>MOH<
(defun ChangeItemColorKEKOMI(
	&ss
	&iCol
	&SKK$ ; 性格ｺｰﾄﾞﾘｽﾄ ﾌﾛｱｷｬﾋﾞ("1" "1" "?"),ｼﾝｸｷｬﾋﾞ("1" "1" "2")
  /
	#ENGRP #ENR #I #II #J #SSGRP #SSRET #ssdum #engrp$
  )
  (setq #i 0)
	(setq #engrp$ nil)
  (setq #ssRet (ssadd))
  (setq #ssdum (ssadd))

  (setq CG_BASESYM (CFGetBaseSymXRec))
  (repeat (sslength &ss)
;;;		(princ "\n#i = ")(princ #i)
    (setq #enR (ssname &ss #i))
    (if (not (ssmemb #enR #ssdum))
      ;ｸﾞﾙｰﾌﾟｱｲﾃﾑの処理
      (if (and (setq #engrp (SearchGroupSym #enR))      ; ｼﾝﾎﾞﾙあり
							 (setq #ssGrp (CFGetSameGroupSS #engrp))) ; ｸﾞﾙｰﾌﾟ全体
		 		(progn
;;;					(if (CheckFloorCAB #engrp) ; "11?"
;;;					(if (CheckSKK$ #engrp &SKK$) ; &SKK$="11?"等 01/02/22 YM
					(if (or (CheckSKK$ #engrp &SKK$)
									(CheckSKK$ #engrp (list (itoa CG_SKK_ONE_GAS)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_ETC)))  ; ｺﾝﾛ ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
									(CheckSKK$ #engrp (list (itoa CG_SKK_ONE_SNK)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_ETC)))  ; ｼﾝｸ ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
									(CheckSKK$ #engrp (list (itoa CG_SKK_ONE_WTR)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_ETC)))) ; 水栓; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
						(progn
							(setq #engrp$ (cons #engrp #engrp$)) ; ｼﾝﾎﾞﾙﾘｽﾄ
			        (if &iCol;色変更指示
			          (GroupInSolidChgCol2 #engrp &iCol)
			          (if (equal CG_BASESYM #engrp);基準ｱｲﾃﾑ
			            (GroupInSolidChgCol #engrp CG_BaseSymCol)
			            (GroupInSolidChgCol2 #engrp "BYLAYER")
			          )
			        );_if
		          ;戻り値選択ｾｯﾄに加算
		          (setq #ii 0)
		          (repeat (sslength #ssGrp)
		            (ssadd (ssname #ssGrp #ii) #ssRet)
		            (setq #ii (1+ #ii))
		          );end repeat
						)
					);_if

					;一度探しだしたｸﾞﾙｰﾌﾟをｽﾄｯｸしておく(選択ｾｯﾄに加算)
          (setq #j 0)
          (repeat (sslength #ssGrp)
            (ssadd (ssname #ssGrp #j) #ssdum)
            (setq #j (1+ #j))
          )
          (setq #ssGrp nil)
        )
      );_if
    );_if
    (setq #i (1+ #i))
  );end repeat
  (list #ssRet #engrp$)
);ChangeItemColorKEKOMI

;;;<HOM>*************************************************************************
;;; <関数名>    : C:H800
;;; <処理概要>  : ｹｺﾐ部分をﾕｰｻﾞｰ指定長さ伸縮するｺﾏﾝﾄﾞ
;;; <戻り値>    : なし
;;; <作成>      : 01/01/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:H800 (
  /
	#210$ #410$ #510$ #BASE #BASEPT #BASESYM #DUM$ #DUMPT$ #I #PT$ #RET$ #SKK #SS
	#SSDUM #SSWT #SYM$ #SYS$ #WT #WTH #XDWT$ #XDWTSET$ #pdsize #pd
  )

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
		  (defun TempErr ( msg / #msg )
				(setq KEKOMI_COM nil) ; ｹｺﾐ伸縮中
				(setq KEKOMI_BRK nil)
			  (command "_undo" "b")
				(setvar "pdmode" #PD)
			  (setvar "PDSIZE" #pdsize)
		    (setq *error* nil)
		    (princ)
		  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

;///////////////////////////////////////////////////////////////////////////////////
; ｼﾝﾎﾞﾙ==>PMEN2外形領域
;///////////////////////////////////////////////////////////////////////////////////
			(defun ##GetPMEN_PT$ (
				&sym
			  /
				#PMEN2 #PT$
			  )
	      (setq #pmen2 (PKGetPMEN_NO &sym 2))  ; PMEN2
	      (if (= #pmen2 nil)
	        (setq #pmen2 (PK_MakePMEN2 &sym))  ; PMEN2 がなければ作成
	      );_if
	      (setq #pt$ (GetLWPolyLinePt #pmen2)) ; PMEN2 外形領域

				#pt$
			)
;///////////////////////////////////////////////////////////////////////////////////

	; 前処理
  (setq *error* TempErr)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")
;;;	(StartUndoErr)

	; 01/10/25 YM ADD-S
	(setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "PDSIZE" 10)
	(setvar "pdmode" 34)
	; 01/10/25 YM ADD-E

; 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
; 02/04/23 YM Lippleでも使いたい
;;;02/04/23YM@DEL(if (equal (KPGetSinaType) 2 0.1)
;;;02/04/23YM@DEL	(progn
;;;02/04/23YM@DEL    (CFAlertMsg msg8)
;;;02/04/23YM@DEL    (quit)
;;;02/04/23YM@DEL	)
;;;02/04/23YM@DEL	(progn


	(setq KEKOMI_COM T) ; ｹｺﾐ伸縮中
	(setq KEKOMI_BRK nil)
	(setq #ssWT (ssadd))
  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
	(setq #BASESYM (CFGetBaseSymXRec)) ; 基準ｱｲﾃﾑ

	;;; ｹｺﾐ伸縮用ﾌﾛｱｷｬﾋﾞのみ赤色にする
	(setq #ss (ItemSelKEKOMI '(("DUMMY")("G_LSYM")) CG_InfoSymCol '("1" "1" "?")))
	; 色を戻す
	(setq #sym$ (cadr (ChangeItemColorKEKOMI #ss nil '("1" "1" "?"))))
;;;	(foreach sym #sym$
;;;    (if (equal CG_BASESYM sym);基準ｱｲﾃﾑ
;;;      (GroupInSolidChgCol sym CG_BaseSymCol)
;;;      (GroupInSolidChgCol2 sym "BYLAYER")
;;;    );_if
;;;	)

	(command "vpoint" "0,0,1"); 視点を真上から
	; ｼﾝｸｷｬﾋﾞ,ｺﾝﾛｷｬﾋﾞにｼﾝｸ,水栓,ｺﾝﾛがあれば追加する(2重追加しないようにする)
	(setq #dum$ #sym$)
	(setq #210$ nil #410$ nil #510$ nil)
	(foreach #sym #sym$
		(if (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB) (itoa CG_SKK_TWO_BAS) "?")) ; ﾌﾛｱｷｬﾋﾞ ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
			(progn
				(setq #pt$ (##GetPMEN_PT$ #sym)) ; ｷｬﾋﾞ外形点列
				(setq #base (cdr (assoc 10 (entget #sym)))) ; ｼﾝﾎﾞﾙ位置
        (setq #dumpt$ (GetPtSeries #base #pt$))     ; #base を先頭に時計周り
				(if #dumpt$
					(setq #pt$ #dumpt$) ; nil でない
					(progn ; 外形点列上にｼﾝﾎﾞﾙがない場合
						(setq #BASEPT (PKGetBaseI4 #pt$ (list #sym))) ; 点列とｼﾝﾎﾞﾙ基点１つ
						(setq #pt$ (GetPtSeries #BASEPT #pt$))        ; #base を先頭に時計周り
					)
				);_if
				;点列(通常ｷｬﾋﾞ4点,ｺｰﾅｰｷｬﾋﾞ6点)と変更したい側("L","R","U","D")と変更ｻｲｽﾞ
				;       "U"
				;   @----------+
				;   | 真上から |
				;"L"|          |"R"
				;   |          |
				;   +----------+
				;      "D"
				(setq #pt$ (KPChangeArea$ #pt$ "L" -5)) ; ｷｬﾋﾞ外形点列左5mm狭める
				(setq #pt$ (KPChangeArea$ #pt$ "R" -5)) ; ｷｬﾋﾞ外形点列右5mm狭める
	      (setq #pt$ (AddPtList #pt$))            ; 末尾に始点を追加する

				; WTを探す
			  (setq #ssDUM (ssget "CP" #pt$ (list (list -3 (list "G_WRKT"))))) ; 領域内のWT図形
			  (if (and #ssDUM (> (sslength #ssDUM) 0))
					(progn
						(setq #i 0)
						(repeat (sslength #ssDUM)
							(ssadd (ssname #ssDUM #i) #ssWT)
							(setq #i (1+ #i))
						)
					)
				);_if
			)
		);_if

		(setq #SKK (nth 9 (CFGetXData #sym "G_LSYM")))
		(cond
			((= #SKK CG_SKK_INT_SCA) ; ｼﾝｸｷｬﾋﾞ ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
				(setq #410$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SNK)) ; 領域内ｼﾝｸ ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
				(setq #510$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; 領域内水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
			)
			((= #SKK CG_SKK_INT_GCA) ; ｺﾝﾛｷｬﾋﾞ ; 01/08/31 YM MOD 113-->ｸﾞﾛｰﾊﾞﾙ化
				(setq #210$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_GAS)) ; 領域内ｺﾝﾛ ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
			)
		);_cond
	);foreach
	(command "zoom" "p") ; 視点を戻す

	(foreach #dum (append #210$ #410$ #510$)
		(if (member #dum #sym$)
			nil ; 既に選択されている
			(setq #sym$ (cons #dum #sym$))
		);_if
	);foreach

	; 伸縮処理
	(if #sym$
		(progn
			;;; ﾀﾞｲｱﾛｸﾞ表示
			(setq #ret$ (PcGetStretchKEKOMISizeDlg))
			(setq KEKOMI_COM  (car  #ret$))
			(setq KEKOMI_BRK  (cadr #ret$))

			(if (> (abs KEKOMI_COM) 0.1) ; 0のとき処理
				(foreach #sym #sym$
					(PcCabCutCall2 #sym KEKOMI_COM KEKOMI_BRK)
					(PCD_MakeViewAlignDoor (list #sym) 3 T)
					(if (equal #sym #BASESYM)
						(GroupInSolidChgCol #sym CG_BaseSymCol) ; 基準ｼﾝﾎﾞﾙなら緑色をつける
					);_if
				)
				(CFAlertMsg "\n伸縮しませんでした。")
			);_if
		)
		(CFAlertMsg "\n伸縮対象の図形がありません。")
	);_if

	; WT移動
  (if (and #ssWT (> (sslength #ssWT) 0))
		(progn
			(setq #i 0)
			(repeat (sslength #ssWT)
				(setq #WT (ssname #ssWT #i))
				(command "_move" #WT "" '(0 0 0) (strcat "@0,0," (rtos (- KEKOMI_COM))))
				(setq #xdWT$    (CFGetXData #WT "G_WRKT"))
				(setq #xdWTSET$ (CFGetXData #WT "G_WTSET"))
				(setq #WTH (- (nth 8 #xdWT$) KEKOMI_COM))
				(if #xdWT$
			    (CFSetXData #WT "G_WRKT"
			      (CFModList #xdWT$
			        (list (list 8 #WTH)) ; WT取り付け高さ
			      )
			    )
				);_if
				(if #xdWT$
			    (CFSetXData #WT "G_WTSET"
			      (CFModList #xdWTSET$
			        (list (list 2 #WTH)) ; WT取り付け高さ
			      )
			    )
				);_if

				(setq #i (1+ #i))
			)
		)
	);_if

;;;02/04/23YM@DEL	); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
;;;02/04/23YM@DEL);_if

	; 後処理
  (setq *error* nil)
  (CFCmdDefFinish)
  (PKEndCOMMAND #sys$)
	(setq KEKOMI_COM nil)
	(setq KEKOMI_BRK nil)

	; 01/10/25 YM ADD-S
	(setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)
	; 01/10/25 YM ADD-E

	(princ)

);C:H800

;;;<HOM>*************************************************************************
;;; <関数名>    : KPCallKekomi
;;; <処理概要>  : 引数ｼﾝﾎﾞﾙﾘｽﾄをｹｺﾐ伸縮 関数call用
;;; <戻り値>    : なし
;;; <作成>      : 01/03/22 YM
;;; <備考>      : ｼﾝｸ,ｺﾝﾛが引数になくても存在すれば自動伸縮
;;;               ﾐﾗｰ反転でcall用
;;;*************************************************************************>MOH<
(defun KPCallKekomi (
	&sym$ ; ｼﾝﾎﾞﾙﾘｽﾄ
  /
	#210$ #410$ #510$ #BASESYM #DUM$ #I #PT$ #SKK #SSDUM #SSWT #SYM$
  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
		  (defun TempErr ( msg / )
				(setq KEKOMI_COM nil) ; ｹｺﾐ伸縮中
				(setq KEKOMI_BRK nil)
			  (command "_undo" "b")
		    (setq *error* nil)
		    (princ)
		  )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

;///////////////////////////////////////////////////////////////////////////////////
; ｼﾝﾎﾞﾙ==>PMEN2外形領域
;///////////////////////////////////////////////////////////////////////////////////
			(defun ##GetPMEN_PT$ (
				&sym
			  /
				#PMEN2 #PT$
			  )
	      (setq #pmen2 (PKGetPMEN_NO &sym 2))  ; PMEN2
	      (if (= #pmen2 nil)
	        (setq #pmen2 (PK_MakePMEN2 &sym))  ; PMEN2 がなければ作成
	      );_if
	      (setq #pt$ (GetLWPolyLinePt #pmen2)) ; PMEN2 外形領域
	      (setq #pt$ (AddPtList #pt$))         ; 末尾に始点を追加する
				#pt$
			)
;///////////////////////////////////////////////////////////////////////////////////

	(setq #sym$ &sym$)
	; 前処理
  (setq *error* TempErr)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")
;;;	(StartUndoErr)
;;;	(setq KEKOMI_BRK nil)
;;;	(setq KEKOMI_COM T)
	(setq #ssWT (ssadd))
	(setq #BASESYM (CFGetBaseSymXRec)) ; 基準ｱｲﾃﾑ

;;;	;;; ｹｺﾐ伸縮用ﾌﾛｱｷｬﾋﾞのみ赤色にする
;;;	(setq #ss (ItemSelKEKOMI '(("DUMMY")("G_LSYM")) CG_InfoSymCol '("1" "1" "?")))
;;;	; 色を戻す
;;;	(setq #sym$ (cadr (ChangeItemColorKEKOMI #ss nil '("1" "1" "?"))))

	(command "vpoint" "0,0,1"); 視点を真上から
	; ｼﾝｸｷｬﾋﾞ,ｺﾝﾛｷｬﾋﾞにｼﾝｸ,水栓,ｺﾝﾛがあれば追加する(2重追加しないようにする)
	(setq #dum$ #sym$)
	(setq #210$ nil #410$ nil #510$ nil)
	(foreach #sym #sym$
		(if (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB) (itoa CG_SKK_TWO_BAS) "?")) ; ﾌﾛｱｷｬﾋﾞ ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
			(progn
				(setq #pt$ (##GetPMEN_PT$ #sym)) ; ｷｬﾋﾞ外形点列
;;;				; WTを探す
;;;			  (setq #ssDUM (ssget "CP" #pt$ (list (list -3 (list "G_WRKT"))))) ; 領域内のWT図形
;;;			  (if (and #ssDUM (> (sslength #ssDUM) 0))
;;;					(progn
;;;						(setq #i 0)
;;;						(repeat (sslength #ssDUM)
;;;							(ssadd (ssname #ssDUM #i) #ssWT)
;;;							(setq #i (1+ #i))
;;;						)
;;;					)
;;;				);_if
			)
		);_if

		(setq #SKK (nth 9 (CFGetXData #sym "G_LSYM")))
		(cond
			((= #SKK CG_SKK_INT_SCA) ; ｼﾝｸｷｬﾋﾞ ; 01/08/31 YM MOD 112-->ｸﾞﾛｰﾊﾞﾙ化
				(setq #410$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SNK)) ; 領域内ｼﾝｸ ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
				(setq #510$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; 領域内水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
			)
			((= #SKK CG_SKK_INT_GCA) ; ｺﾝﾛｷｬﾋﾞ ; 01/08/31 YM MOD 113-->ｸﾞﾛｰﾊﾞﾙ化
				(setq #210$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_GAS)) ; 領域内ｺﾝﾛ ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
			)
		);_cond
	);foreach
	(command "zoom" "p") ; 視点を戻す

	; あらかじめ伸縮量分反対方向に移動しておく(2回伸縮した高さになってしまうため)
	(foreach #dum (append #210$ #410$ #510$)
		(setq #ssdum (CFGetSameGroupSS #dum)) ; 同一グループ内の全図形選択セット
		(command "_move" #ssdum "" '(0 0 0) (strcat "@0,0," (rtos KEKOMI_COM)))
	);foreach

	(foreach #dum (append #210$ #410$ #510$)
		(if (member #dum #sym$)
			nil ; 既に選択されている
			(setq #sym$ (cons #dum #sym$))
		);_if
	);foreach

	; 伸縮処理
	(if #sym$
		(progn
;;;			;;; ﾀﾞｲｱﾛｸﾞ表示
;;;			(setq #ret$ (PcGetStretchKEKOMISizeDlg))
;;;			(setq KEKOMI_COM  (car  #ret$))
;;;			(setq KEKOMI_BRK  (cadr #ret$))

;;;	KEKOMI_COM
;;;	KEKOMI_BRK

			(if (> (abs KEKOMI_COM) 0.1) ; 0のとき処理
				(foreach #sym #sym$
					(PcCabCutCall2 #sym KEKOMI_COM KEKOMI_BRK)
					(PCD_MakeViewAlignDoor (list #sym) 3 T)
					(if (equal #sym #BASESYM)
						(GroupInSolidChgCol #sym CG_BaseSymCol) ; 基準ｼﾝﾎﾞﾙなら緑色をつける
					);_if
				)
				(CFAlertMsg "\n伸縮しませんでした。")
			);_if
		)
		(CFAlertMsg "\n伸縮対象の図形がありません。")
	);_if

;;;	; WT移動
;;;  (if (and #ssWT (> (sslength #ssWT) 0))
;;;		(progn
;;;			(setq #i 0)
;;;			(repeat (sslength #ssWT)
;;;				(setq #WT (ssname #ssWT #i))
;;;				(command "_move" #WT "" '(0 0 0) (strcat "@0,0," (rtos (- KEKOMI_COM))))
;;;				(setq #xdWT$    (CFGetXData #WT "G_WRKT"))
;;;				(setq #xdWTSET$ (CFGetXData #WT "G_WTSET"))
;;;				(setq #WTH (- (nth 8 #xdWT$) KEKOMI_COM))
;;;				(if #xdWT$
;;;			    (CFSetXData #WT "G_WRKT"
;;;			      (CFModList #xdWT$
;;;			        (list (list 8 #WTH)) ; WT取り付け高さ
;;;			      )
;;;			    )
;;;				);_if
;;;				(if #xdWT$
;;;			    (CFSetXData #WT "G_WTSET"
;;;			      (CFModList #xdWTSET$
;;;			        (list (list 2 #WTH)) ; WT取り付け高さ
;;;			      )
;;;			    )
;;;				);_if
;;;
;;;				(setq #i (1+ #i))
;;;			)
;;;		)
;;;	);_if

	; 後処理
  (setq *error* nil)
	(setq KEKOMI_COM nil)
	(setq KEKOMI_BRK nil)
	(princ)
);KPCallKekomi

;<HOM>*************************************************************************
; <関数名>    : PcGetStretchKEKOMISizeDlg
; <処理概要>  : ｹｺﾐ部分をﾕｰｻﾞｰ指定長さ獲得
; <戻り値>    : 長さ(実数)
; <作成>      : 01/01/12 YM
; <備考>      :
;*************************************************************************>MOH<
(defun PcGetStretchKEKOMISizeDlg (
  /
  #dcl_id #iH #RES #IB
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		(defun ##GetDlgItem ( / #H #B); ﾀﾞｲｱﾛｸﾞの結果を取得する
			(setq #H (atoi (get_tile "H")))
			(setq #B (atoi (get_tile "B")))
  		(done_dialog)
			(list #H #B)
		);##GetDlgItem

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 半角数値かどうか ;;; 必須項目をﾁｪｯｸ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CHK_edit (
		&sKEY ; key
		&DEF  ; ﾃﾞﾌｫﾙﾄ値
		&flg  ; 判定基準ﾌﾗｸﾞ 0:半角数値 , 1:半角数値>0 , 2:nilでない文字列
		/
		#val
		)
		(setq #val (read (get_tile &sKEY)))
		(cond
			((and (= &flg 2)(= #val nil))
        (alert "文字列を入力して下さい。")
        (set_tile &sKEY &DEF)
        (mode_tile &sKEY 2)
			)
			((= &flg 0)
		    (if (or (= (type #val) 'INT)
								(= (type #val) 'REAL))
					(princ) ; 半角実数だった
					(progn
		        (alert "半角実数値を入力して下さい。")
		        (set_tile &sKEY &DEF)
		        (mode_tile &sKEY 2)
					)
				);_if
			)
			((= &flg 1)
		    (if (and (or (= (type #val) 'INT)
										 (= (type #val) 'REAL))
								 (> #val 0.001)) ; 更に正かどうか調べる(0は不可)
					(princ) ; OK
					(progn
		        (alert "0より大きな半角実数値を入力して下さい。")
		        (set_tile &sKEY &DEF)
		        (mode_tile &sKEY 2)
					)
				);_if
		 	)
    );_cond
		(princ)
  );##CHK_edit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; ダイアログの実行部
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (not (new_dialog "GetStretchKEKOMISizeDlg" #dcl_id)) (exit))

  ;;; ﾃﾞﾌｫﾙﾄ値の設定
  (setq #iH 50)
  (setq #iB 30)
  (set_tile "H" (itoa #iH))
  (set_tile "B" (itoa #iB))

  ;;; タイルのリアクション設定
;;;  (action_tile "H" "(PcCheckIntStrSetDefo $key #iH)")
	(action_tile "H" "(##CHK_edit \"H\" #iH 0)")
	(action_tile "B" "(##CHK_edit \"B\" #iB 0)")
;;;  (action_tile "accept" "(setq #RES (##StretchCabSizeData))")
;;;  (action_tile "cancel" "(setq #RES nil)(done_dialog)")
  (action_tile "accept" "(setq #RES (##GetDlgItem))")   ; OK
  (action_tile "cancel" "(setq #RES nil)(done_dialog)") ; cancel

  (start_dialog)
  (unload_dialog #dcl_id)
  #RES
); PcGetStretchKEKOMISizeDlg

;;;01/01/27YM@;;;<HOM>*************************************************************************
;;;01/01/27YM@;;; <関数名>    : C:StretchCab
;;;01/01/27YM@;;; <処理概要>  : 特注ｷｬﾋﾞｺﾏﾝﾄﾞ
;;;01/01/27YM@;;; <戻り値>    : なし
;;;01/01/27YM@;;; <作成>      : 01/01/26 YM
;;;01/01/27YM@;;; <備考>      :
;;;01/01/27YM@;;;*************************************************************************>MOH<
;;;01/01/27YM@(defun C:StretchCab (
;;;01/01/27YM@  /
;;;01/01/27YM@	#DIST #SS #SYS$ #sym$ #i #elm #ret$ #Brk #BASESYM
;;;01/01/27YM@  )
;;;01/01/27YM@	; 前処理
;;;01/01/27YM@	(StartUndoErr)
;;;01/01/27YM@  (setq #sys$ (PKStartCOMMAND))
;;;01/01/27YM@  (CFCmdDefBegin 6)
;;;01/01/27YM@	(setq #BASESYM (CFGetBaseSymXRec)) ; 基準ｱｲﾃﾑ
;;;01/01/27YM@	(setq TOKU_COM T)   ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中ﾌﾗｸﾞ
;;;01/01/27YM@	(setq CG_TOKU_W nil); 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中
;;;01/01/27YM@	(setq CG_TOKU_D nil); 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中
;;;01/01/27YM@	(setq CG_TOKU_H nil); 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中
;;;01/01/27YM@
;;;01/01/27YM@	;;; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ用(ｷｬﾋﾞﾈｯﾄ性格ｺｰﾄﾞ'("1" "?" "?")のみ赤色にする)
;;;01/01/27YM@	(setq #ss (ItemSelKEKOMI '(("DUMMY")("G_LSYM")) CG_InfoSymCol '("1" "?" "?")))
;;;01/01/27YM@	; 色を戻す
;;;01/01/27YM@	(setq #sym$ (cadr (ChangeItemColorKEKOMI #ss nil '("1" "?" "?"))))
;;;01/01/27YM@
;;;01/01/27YM@	; 伸縮処理
;;;01/01/27YM@	(if #sym$
;;;01/01/27YM@		(progn
;;;01/01/27YM@			;;; ﾀﾞｲｱﾛｸﾞ表示
;;;01/01/27YM@			(setq #ret$ (PcGetStretchTOKUSizeDlg))
;;;01/01/27YM@			(setq #distW (nth 0 #ret$))
;;;01/01/27YM@			(setq #distD (nth 1 #ret$))
;;;01/01/27YM@			(setq #distH (nth 2 #ret$))
;;;01/01/27YM@			(setq #BrkW  (nth 3 #ret$))
;;;01/01/27YM@			(setq #BrkD  (nth 4 #ret$))
;;;01/01/27YM@			(setq #BrkH  (nth 5 #ret$))
;;;01/01/27YM@
;;;01/01/27YM@			(foreach #sym #sym$
;;;01/01/27YM@				(PcCabCutCall3 #sym #distW #distD #distH #BrkW #BrkD #BrkH)
;;;01/01/27YM@				(PCD_MakeViewAlignDoor (list #sym) 3 T)
;;;01/01/27YM@				(if (equal #sym #BASESYM)
;;;01/01/27YM@					(GroupInSolidChgCol #sym CG_BaseSymCol) ; 基準ｼﾝﾎﾞﾙなら緑色をつける
;;;01/01/27YM@				);_if
;;;01/01/27YM@			)
;;;01/01/27YM@		)
;;;01/01/27YM@		(CFAlertMsg "\n伸縮対象の図形がありません。")
;;;01/01/27YM@	);_if
;;;01/01/27YM@	; 後処理
;;;01/01/27YM@  (setq *error* nil)
;;;01/01/27YM@  (setq EditFlag nil)
;;;01/01/27YM@  (CFCmdDefFinish)
;;;01/01/27YM@  (PKEndCOMMAND #sys$)
;;;01/01/27YM@	(setq TOKU_COM nil)    ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中ﾌﾗｸﾞ
;;;01/01/27YM@	(setq CG_TOKU_W nil)
;;;01/01/27YM@	(setq CG_TOKU_D nil)
;;;01/01/27YM@	(setq CG_TOKU_H nil)
;;;01/01/27YM@	(princ)
;;;01/01/27YM@);C:StretchCab
;;;01/01/27YM@
;;;01/01/27YM@;<HOM>*************************************************************************
;;;01/01/27YM@; <関数名>    : PcGetStretchTOKUSizeDlg
;;;01/01/27YM@; <処理概要>  : 特注ｷｬﾋﾞ伸縮情報取得ﾀﾞｲｱﾛｸﾞ表示
;;;01/01/27YM@; <戻り値>    : W,D,H ﾌﾞﾚｰｸﾗｲﾝ位置W,D,H
;;;01/01/27YM@; <作成>      : 01/01/26 YM
;;;01/01/27YM@; <備考>      :
;;;01/01/27YM@;*************************************************************************>MOH<
;;;01/01/27YM@(defun PcGetStretchTOKUSizeDlg (
;;;01/01/27YM@  /
;;;01/01/27YM@  #BD #BH #BW #D #DCL_ID #H #IB #IBD #IBH #IBW #ID #IH #IW #RES #W
;;;01/01/27YM@  )
;;;01/01/27YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/01/27YM@		(defun ##GetDlgItem ( / #RES); ﾀﾞｲｱﾛｸﾞの結果を取得する
;;;01/01/27YM@			(setq #W  (atoi (get_tile "W" )))
;;;01/01/27YM@			(setq #BW (atoi (get_tile "BW")))
;;;01/01/27YM@			(setq #D  (atoi (get_tile "D" )))
;;;01/01/27YM@			(setq #BD (atoi (get_tile "BD")))
;;;01/01/27YM@			(setq #H  (atoi (get_tile "H" )))
;;;01/01/27YM@			(setq #BH (atoi (get_tile "BH")))
;;;01/01/27YM@  		(done_dialog)
;;;01/01/27YM@			(list #W #D #H #BW #BD #BH)
;;;01/01/27YM@		); 必須項目をﾁｪｯｸ
;;;01/01/27YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/01/27YM@	  (defun ##CHK_edit (&sKEY / #val #ret)
;;;01/01/27YM@	    (setq #ret nil)
;;;01/01/27YM@			(setq #val (read (get_tile &sKEY)))
;;;01/01/27YM@	    (if (or (= (type (read (get_tile &sKEY))) 'INT)
;;;01/01/27YM@							(= (type (read (get_tile &sKEY))) 'REAL))
;;;01/01/27YM@				(princ) ; OK!
;;;01/01/27YM@				(progn
;;;01/01/27YM@	        (alert "半角の実数値を入力して下さい。")
;;;01/01/27YM@	        (set_tile &sKEY "")
;;;01/01/27YM@	        (mode_tile &sKEY 2)
;;;01/01/27YM@				)
;;;01/01/27YM@	    );_if
;;;01/01/27YM@			#ret
;;;01/01/27YM@	  );##CHK_edit
;;;01/01/27YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/01/27YM@;;;01/01/12YM@	  (defun ##StretchCabSizeData ( / #RES$ #DUMMY$)
;;;01/01/27YM@;;;01/01/12YM@	    ; 必須項目を順にチェック。未入力であればメッセージを出し、その欄にフォーカスを戻す。
;;;01/01/27YM@;;;01/01/12YM@	    (cond
;;;01/01/27YM@;;;01/01/12YM@	      ((or (= "" (get_tile "H")) (= "0" (get_tile "H")))
;;;01/01/27YM@;;;01/01/12YM@	        (PcRequireInput "H" "キャビネットの高さ値"
;;;01/01/27YM@;;;01/01/12YM@	                               "\n 0 以上の数値を入力して下さい")
;;;01/01/27YM@;;;01/01/12YM@			 	)
;;;01/01/27YM@;;;01/01/12YM@	      (t  ;;;必須入力確認できたら、結果リスト作成。
;;;01/01/27YM@;;;01/01/12YM@	        (setq #RES (atoi (get_tile "H")))
;;;01/01/27YM@;;;01/01/12YM@	        (done_dialog)
;;;01/01/27YM@;;;01/01/12YM@	      )
;;;01/01/27YM@;;;01/01/12YM@	    )
;;;01/01/27YM@;;;01/01/12YM@	    #RES
;;;01/01/27YM@;;;01/01/12YM@	  )
;;;01/01/27YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/01/27YM@  ;;; ダイアログの実行部
;;;01/01/27YM@  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
;;;01/01/27YM@  (if (not (new_dialog "GetStretchTOKUSizeDlg" #dcl_id)) (exit))
;;;01/01/27YM@
;;;01/01/27YM@  ;;; タイルのリアクション設定
;;;01/01/27YM@;;;  (action_tile "H" "(PcCheckIntStrSetDefo $key #iH)")
;;;01/01/27YM@	(action_tile "W"  "(##CHK_edit \"W\") ")
;;;01/01/27YM@	(action_tile "BW" "(##CHK_edit \"BW\")")
;;;01/01/27YM@	(action_tile "D"  "(##CHK_edit \"D\") ")
;;;01/01/27YM@	(action_tile "BD" "(##CHK_edit \"BD\")")
;;;01/01/27YM@	(action_tile "H"  "(##CHK_edit \"H\") ")
;;;01/01/27YM@	(action_tile "BH" "(##CHK_edit \"BH\")")
;;;01/01/27YM@;;;  (action_tile "accept" "(setq #RES (##StretchCabSizeData))")
;;;01/01/27YM@;;;  (action_tile "cancel" "(setq #RES nil)(done_dialog)")
;;;01/01/27YM@  (action_tile "accept" "(setq #RES (##GetDlgItem))")   ; OK
;;;01/01/27YM@  (action_tile "cancel" "(setq #RES nil)(done_dialog)") ; cancel
;;;01/01/27YM@
;;;01/01/27YM@  ;;; ﾃﾞﾌｫﾙﾄ値の設定
;;;01/01/27YM@  (setq #iW  0)
;;;01/01/27YM@  (setq #iBW 20)
;;;01/01/27YM@  (setq #iD  0)
;;;01/01/27YM@  (setq #iBD 20)
;;;01/01/27YM@  (setq #iH  0)
;;;01/01/27YM@  (setq #iBH 20)
;;;01/01/27YM@  (set_tile "W"  (itoa #iW ))
;;;01/01/27YM@  (set_tile "BW" (itoa #iBW))
;;;01/01/27YM@  (set_tile "D"  (itoa #iD ))
;;;01/01/27YM@  (set_tile "BD" (itoa #iBD))
;;;01/01/27YM@  (set_tile "H"  (itoa #iH ))
;;;01/01/27YM@  (set_tile "BH" (itoa #iBH))
;;;01/01/27YM@  (start_dialog)
;;;01/01/27YM@  (unload_dialog #dcl_id)
;;;01/01/27YM@  #RES
;;;01/01/27YM@); PcGetStretchTOKUSizeDlg

;<HOM>*************************************************************************
; <関数名>    : PKGetSS_SYMFromSS
; <処理概要>  : 選択ｾｯﾄ==>"11?"のｼﾝﾎﾞﾙ図形ﾘｽﾄ
; <戻り値>    : "11?"のｼﾝﾎﾞﾙ図形ﾘｽﾄ
; <作成>      : 01/01/17 YM
; <備考>      : ｹｺﾐ伸縮用
;*************************************************************************>MOH<
(defun PKGetSS_SYMFromSS (
	&ss
  /
	#I #SS #RET$ #XD$
  )
	(setq #i 0 #RET$ nil)
	(repeat (sslength &ss)
		(if (setq #xd$ (CFGetXData (ssname &ss #i) "G_LSYM"))
			(if (and (>= (nth 9 #xd$) 110)(<= (nth 9 #xd$) 119))
				(setq #RET$ (cons (ssname &ss #i) #RET$))
			);_if
		);_if
		(setq #i (1+ #i))
	);_repeat
	#RET$
);PKGetSS_SYMFromSS

;;;<HOM>*************************************************************************
;;; <関数名>    : CheckSS_FloorCAB
;;; <処理概要>  : 選択ｾｯﾄ内でﾌﾛｱｷｬﾋﾞ(性格ｺｰﾄﾞが"11?")のものを抜き出す
;;; <戻り値>    : 選択ｾｯﾄ
;;; <作成>      : 01/01/17 YM
;;; <備考>      : CheckSKK$ よりも高速
;;;*************************************************************************>MOH<
(defun CheckSS_FloorCAB (
	&SS
	/
	#I #SS #XD$
	)
	(setq #ss (ssadd))
	(if (and &SS (> (sslength &SS) 0))
		(progn
			(setq #i 0)
			(repeat (sslength &SS)
;;;				(princ "\n #i = ")(princ #i)
				(if (setq #xd$ (CFGetXData (ssname &ss #i) "G_LSYM"))
					(if (and (>= (nth 9 #xd$) 110)(<= (nth 9 #xd$) 119))
						(ssadd (ssname &ss #i) #ss)
					);_if
				);_if
				(setq #i (1+ #i))
			)
		)
		(setq #ss nil)
	);_if
	#ss
);CheckSS_FloorCAB

;;;<HOM>*************************************************************************
;;; <関数名>    : CheckSKK$
;;; <処理概要>  : ｼﾝﾎﾞﾙ &SYM の性格ｺｰﾄﾞが &SKK$ と合ってるならT
;;;             : 合っていないならnilを返す
;;; <戻り値>    : T or nil
;;; <作成>      : 01/01/17 YM
;;; <備考>      : 性格ｺｰﾄﾞﾘｽﾄ &SKK$ '("2" "1" "0") '("1" "1" "?") などを指定
;;;*************************************************************************>MOH<
(defun CheckSKK$ (
	&SYM
	&SKK$
	/
	#ONE #RET #SKKONE #SKKTHR #SKKTWO #THR #TWO #XD$
	)
	(setq #RET nil)
	(if (CFGetXData &sym "G_LSYM")
		(progn
			(setq #RET T)
			(setq #one (itoa (CfGetSymSKKCode &SYM 1))) ; 'STR
			(setq #two (itoa (CfGetSymSKKCode &SYM 2))) ; 'STR
			(setq #thr (itoa (CfGetSymSKKCode &SYM 3))) ; 'STR
			(setq #SKKone (nth 0 &SKK$)) ; 'STR
			(setq #SKKtwo (nth 1 &SKK$)) ; 'STR
			(setq #SKKthr (nth 2 &SKK$)) ; 'STR

			(if (or (= #one #SKKone)(= #SKKone "?"))
				(princ)
				(setq #RET nil)
			);_if
			(if (or (= #two #SKKtwo)(= #SKKtwo "?"))
				(princ)
				(setq #RET nil)
			);_if
			(if (or (= #thr #SKKthr)(= #SKKthr "?"))
				(princ)
				(setq #RET nil)
			);_if
		)
	);_if
	#ret
);CheckSKK$

;;;<HOM>*************************************************************************
;;; <関数名>    : CheckFloorCAB
;;; <処理概要>  : &sym がﾌﾛｱｷｬﾋﾞ(性格ｺｰﾄﾞが"11?")かどうか判定
;;; <戻り値>    : T or nil
;;; <作成>      : 01/01/17 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun CheckFloorCAB (
	&sym
	/
	#RET #XD$
	)
	(setq #ret nil)
	(if (setq #xd$ (CFGetXData &sym "G_LSYM")) ; ｼﾝﾎﾞﾙか
		(if (and (>= (nth 9 #xd$) 110)(<= (nth 9 #xd$) 119)) ; "11?"か
			(setq #ret T)
		);_if
	);_if
	#ret
);CheckFloorCAB

;<HOM>*************************************************************************
; <関数名>    : PcCabCutCall3
; <処理概要>  : 選択したｷｬﾋﾞﾈｯﾄ部材を伸縮するコマンド
; <戻り値>    : なし
; <作成>      : 01/01/26 YM
; <備考>      : ｷｬﾋﾞが対象
;               W,D,H方向ﾌﾞﾚｰｸﾗｲﾝありの場合一時的に除去
;*************************************************************************>MOH<
(defun PcCabCutCall3 (
	&sym
  &distW
  &distD
  &distH
  &BrkW
  &BrkD
  &BrkH
  /
	#EDELBRK_D$ #EDELBRK_H$ #EDELBRK_W$ #GNAM #PT #XD_SYM$ #XLINE #XLINE_D #XLINE_H #XLINE_W
	#ANG
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PcCabCutCall3 ////")
  (CFOutStateLog 1 1 " ")

;;;  (command "._shademode" "3D") ; 隠線処理 解除(ｽﾋﾟｰﾄﾞｱｯﾌﾟ)07/07 YM ADD
  (setq #eDelBRK_W$ (PcRemoveBreakLine &sym "W")) ; W方向ブレーク除去
  (setq #eDelBRK_D$ (PcRemoveBreakLine &sym "D")) ; D方向ブレーク除去
  (setq #eDelBRK_H$ (PcRemoveBreakLine &sym "H")) ; H方向ブレーク除去
	(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
	(setq #pt  (cdr (assoc 10 (entget &sym)))) ; ｼﾝﾎﾞﾙ基準点
	(setq #ANG (nth 2 (CFGetXData &sym "G_LSYM")))
	(setq	#gnam (SKGetGroupName &sym))

	;;; 伸縮処理_W
	(if (> (abs &distW) 0.1)
		(progn
			(setq CG_TOKU_W &distW)
			;;; ﾌﾞﾚｰｸﾗｲﾝの作図
			(setq #XLINE_W (PK_MakeBreakW #pt #ANG &BrkW))
			(CFSetXData #XLINE_W "G_BRK" (list 1))
			;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
			(command "-group" "A" #gnam #XLINE_W "")
			(SKY_Stretch_Parts &sym (- (nth 3 #xd_SYM$) &distW)(nth 4 #xd_SYM$)(nth 5 #xd_SYM$))
			(entdel #XLINE_W)
		)
	);_if
	;;; 伸縮処理_D
	(if (> (abs &distD) 0.1)
		(progn
			(setq CG_TOKU_D &distD)
			;;; ﾌﾞﾚｰｸﾗｲﾝの作図
			(setq #XLINE_D (PK_MakeBreakD #pt #ANG &BrkD))
			(CFSetXData #XLINE_D "G_BRK" (list 2))
			;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
			(command "-group" "A" #gnam #XLINE_D "")
			(SKY_Stretch_Parts &sym (nth 3 #xd_SYM$)(- (nth 4 #xd_SYM$) &distD)(nth 5 #xd_SYM$))
			(entdel #XLINE_D)
		)
	);_if
	;;; 伸縮処理_H
	(if (> (abs &distH) 0.1)
		(progn
			(setq CG_TOKU_H &distH)
			;;; ﾌﾞﾚｰｸﾗｲﾝの作図
			(setq #XLINE_H (PK_MakeBreakH #pt &BrkH))
			(CFSetXData #XLINE_H "G_BRK" (list 3))
			;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
			(command "-group" "A" #gnam #XLINE_H "")
			(SKY_Stretch_Parts &sym (nth 3 #xd_SYM$)(nth 4 #xd_SYM$)(- (nth 5 #xd_SYM$) &distH))
			(entdel #XLINE_H)
		)
	);_if
  (foreach #eD #eDelBRK_W$ (entdel #eD)) ; W方向ブレーク復活
  (foreach #eD #eDelBRK_D$ (entdel #eD)) ; D方向ブレーク復活
  (foreach #eD #eDelBRK_H$ (entdel #eD)) ; H方向ブレーク復活
;;;  (command "._shademode" "H") ; 隠線処理 解除(ｽﾋﾟｰﾄﾞｱｯﾌﾟ)07/07 YM ADD
  (princ)
);PcCabCutCall3

;<HOM>*************************************************************************
; <関数名>    : PcCabCutCall2
; <処理概要>  : 選択したｷｬﾋﾞﾈｯﾄ部材のｹｺﾐ部分を50mmカットするコマンド(呼び出し用)
; <引数>      : ｼﾝﾎﾞﾙ図形
; <戻り値>    :なし
; <作成>      : 2000/11月 YM
; <備考>      : ﾌﾛｱｷｬﾋﾞが対象でH方向ﾌﾞﾚｰｸﾗｲﾝなしを想定
;               H方向ﾌﾞﾚｰｸﾗｲﾝありの場合一時的に除去(00/12/22 ADD MH)
;
;;;＜仕様詳細　SG/SNケコミUP＞
;;;※ケコミUPの場合に限り下台は規格品のままで付台輪がひもつくようにする
;;;　(図形的な伸縮処理は従来通り行う)
;;;03/06/12 仕様変更→★SPLANに限り実際に台輪を配置してZ移動する
;;;         ｹｺﾐ50mmUP以外のときは台輪自体の伸縮をする
;;;※付台輪は全て\8,000
;;;※付台輪は「追加部材」にも登録
;;;※下台が４つなら付台輪も４つひもつける→ひもつけずに実際に配置
;;;※下台の品番が"～045～"なら付台輪の品番も"～045～"となる OK
;;;※+50mmUPの場合のみ付台輪は規格品扱いで、それ以外(+30mmなど)のケコミUP
;;;　のときは付台輪が"トク)"付きの特注品となる。OK
;;;※付台輪(現在コードなし)はSET品見積りの対象になるOK
;;;※特注付台輪もSET品見積りの対象になる。OK
;;;※S-PLANのときに限り、付台輪とキャビとの境界線を表示する→表示しない(誤解を招く)
;;;　★GSMでＰ面９(付台輪境界線)を追加し、SPLAN下台のみに追加。
;;;　　パース図、展開図でＰ面９図形をＺ移動して可視画層に変更する→しない
;;;　　パース図"0_PURS"では、Ｐ面図形は無条件で"0_HIDE"画層に変更して
;;;　　見えないようにしていたが、新規Ｐ面９は例外的に"0_PURS"のままとする
;;; 2003/06/12 YM PMEN9はSPLANにのみｾｯﾄする.SPLANかどうかの区別に使うだけ
;;;※ｹｺﾐDOWNの場合は従来通り(\8,000ﾌﾟﾗｽ)とする
;;;※キッチンカフェの対面(118)やダイニング(117)は
;;;　従来通りトク付き(\8,000ﾌﾟﾗｽ)とする
;*************************************************************************>MOH<
(defun PcCabCutCall2 (
  &sym  ; ｷｬﾋﾞﾈｯﾄｼﾝﾎﾞﾙ図形
	&dist ; 伸縮長さ(正:縮む 負:伸ばす)
	&Brk  ; ﾌﾞﾚｰｸﾗｲﾝ高さ
  /
  #PT #SS #SYM #XD_LSYM$ #XD_SYM$ #XLINE #GNAM #eD #eDelBRK$
	#HINBAN #LR #PRICE #QRY$ #KEKOMI_PLUS #ORG_PRICE
	#DAIWA #DAIWAREC$ #DAIWAREC$$ #DOORHANDLE #DRINFO #DRINFO$ #DUM #DUM$ #I
	#KEKOMI_HINBAN #KOSU #LIS$ #MAGNUM #OPT_OLD$ #SET$ #XD$_OPT
	#DAIWAHINBAN #EG$ #EN #LOOP #PMEN9 #SYURUI #XD$ #skk #CNR #SPLAN #OS #SSGRP
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PcCabCutCall2 ////")
  (CFOutStateLog 1 1 " ")

  (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))

	; 情報取得
	(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
	(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
	; 03/06/10 YM ADD
	(setq #skk (nth 9 #xd_LSYM$)) ; 性格ｺｰﾄﾞ

	(setq #HINBAN (nth 5 #xd_LSYM$))
	(setq #LR     (nth 6 #xd_LSYM$))
	; 03/06/04 YM ADD-S
	(setq #DrInfo (nth 7 #xd_LSYM$))
	(setq #DrInfo$ (strparse #DrInfo ","))
	(setq #DoorHandle (nth 2 #DrInfo$))
	; 03/06/04 YM ADD-E
	
	; 03/09/09 YM ADD-S
	(if (= nil #DoorHandle)(setq #DoorHandle ""))
	; 03/09/09 YM ADD-E

 	; ﾌﾛｱｷｬﾋﾞで食洗でない場合金額など特注情報ｾｯﾄ 01/02/27 YM ADD ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
	(if (and (CheckSKK$ &sym (list (itoa CG_SKK_ONE_CAB) (itoa CG_SKK_TWO_BAS) "?")) ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
					 (not (CheckSKK$ &sym (list (itoa CG_SKK_ONE_CAB) (itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_ETC)))))
		(progn
;;;01/05/30YM@			; ｼﾝｸ水栓ｺﾝﾛ以外のとき、ｷｬﾋﾞ価格を検索
;;;01/05/30YM@		  (setq #Qry$
;;;01/05/30YM@		    (CFGetDBSQLRec CG_DBSESSION "品番シリ"
;;;01/05/30YM@		      (list
;;;01/05/30YM@		        (list "品番名称"     #HINBAN       'STR)
;;;01/05/30YM@		        (list "LR区分"       #LR           'STR)
;;;01/05/30YM@		        (list "把手記号"     CG_DoorGrip   'STR)
;;;01/05/30YM@		        (list "扉シリ記号"   CG_DRSeriCode 'STR)
;;;01/05/30YM@		      )
;;;01/05/30YM@		    )
;;;01/05/30YM@		  )
;;;01/05/30YM@			(if (and #Qry$ (= (length #Qry$) 1))
;;;01/05/30YM@				(setq #ORG_price (nth 8 (car #Qry$)))
;;;01/05/30YM@				(progn
;;;01/05/30YM@					(CFAlertErr (strcat "キャビネットの価格が求まりません。\n【品番シリ】に" #HINBAN "のレコードがありません。"))
;;;01/05/30YM@					(setq #ORG_price 0) ; ﾚｺｰﾄﾞなしor複数
;;;01/05/30YM@				)
;;;01/05/30YM@			);_if

			(setq #KEKOMI_Plus (CFgetini "KEKOMI" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
;;;01/05/30YM@			(if #KEKOMI_Plus
;;;01/05/30YM@				(if (> #ORG_price 0)
;;;01/05/30YM@					(setq #price (+ #ORG_price (atoi #KEKOMI_Plus)))
;;;01/05/30YM@					(setq #price 0)
;;;01/05/30YM@				);_if
;;;01/05/30YM@				(setq #price 0)
;;;01/05/30YM@			);_if


			; 03/06/04 YM ADD
 			(if (equal (KPGetSinaType) 3 0.1)
				(progn ; SX ｼﾘｰｽﾞはｹｺﾐUP,DOWNとも+8000しない

					;/// 伸縮処理(ｹｺﾐUPでSPLANのときは伸縮しない) ////
					(KP_KekomiStretch &sym &Brk #xd_SYM$ &dist)

					; ｹｺﾐ金額
		  		(setq #price 0.0)
					; ｹｺﾐ伸縮品番
					(if (equal KEKOMI_COM -50 0.01)
						(progn ;+50UPに限り
							(if (= #LR "Z") ; 01/06/27 YM ADD LR追加
								(setq #kekomi_hinban (strcat "ﾄｸｷ" #HINBAN     " " #DoorHandle " H900ﾖｳ"))
								(setq #kekomi_hinban (strcat "ﾄｸｷ" #HINBAN #LR " " #DoorHandle " H900ﾖｳ"))
							);_if
						)
						(progn ; 従来通り
							(if (= #LR "Z") ; 01/06/27 YM ADD LR追加
								(setq #kekomi_hinban (strcat "ﾄｸ" #HINBAN))     ; 品番
								(setq #kekomi_hinban (strcat "ﾄｸ" #HINBAN #LR)) ; 品番
							);_if
						)
					);_if

					; ｹｺﾐ伸縮後の品番から()を取る
					(setq #kekomi_hinban (KP_DelHinbanKakko #kekomi_hinban)) ; 03/06/18 YM ADD

					; G_TOKU のｾｯﾄ
				  (CFSetXData &sym "G_TOKU"
				    (list
							#kekomi_hinban
				      #price     ; SX以外は+8000円価格
							(list (nth 3 #xd_SYM$)(nth 4 #xd_SYM$)(- (nth 5 #xd_SYM$) &dist))
							0 ; 1:特注ｷｬﾋﾞｺﾏﾝﾄﾞ 0:ｹｺﾐ伸縮 2:ｶｳﾝﾀｰﾄｯﾌﾟ
				      KEKOMI_BRK ; ﾌﾞﾚｰｸﾗｲﾝ位置
				      KEKOMI_COM ; 伸縮量
							#HINBAN    ; 元の品番
				    )
				  )

				)
;---------------------------------------------------------------------------------
				(progn ; その他ｼﾘｰｽﾞ(SG/SN)

					(if (and (> 0.0 KEKOMI_COM) ; 負ならｹｺﾐUP
									 (not (equal #skk CG_SKK_INT_DNG 0.1)) ; ﾀﾞｲﾆﾝｸﾞ117でない
									 (not (equal #skk CG_SKK_INT_OTR 0.1)));対面118でない

						(progn ;ｹｺﾐUP  SPLAN⇒規格品Z移動+ﾂｹﾀﾞｲﾜ配置  それ以外⇒伸縮,G_OPTｾｯﾄ

							; SPLAN 判定(PMEN 9を検索)
							(setq #pmen9 (Pmen9Hantei &sym)) ; P面9
							(if #pmen9
								(setq #SPLAN "1") ; SPLAN
								(setq #SPLAN "0") ; それ以外
							);_if

							(if #pmen9
								nil ; 伸縮しない
								;else
								(progn ; SPLANではないなら伸縮
									;/// 伸縮処理(ｹｺﾐUPでSPLANのときは伸縮しない) ////
									(KP_KekomiStretch &sym &Brk #xd_SYM$ &dist)
								)
							);_if

							(if (equal CG_SKK_INT_CNR #skk 0.1)
								(setq #cnr "1") ; ｺｰﾅｰｷｬﾋﾞだった
								(setq #cnr "0")
							);_if

							; #HINBAN から間口部分(数値)の文字列を取得する
							(setq #magnum (CFGetNumFromStr #HINBAN))

							(if (equal KEKOMI_COM -50 0.01);+50UPに限り付台輪は規格品
								(setq #daiwa "0") ; 規格品
								(setq #daiwa "1") ; 特注品
							);_if

							; ひもつける(SPLANは配置する)付台輪品番を取得する
							(setq #daiwaHINBAN (KP_GetDaiwaHinban #magnum #daiwa #SPLAN #cnr #HINBAN))

							(if #pmen9
								(progn ; SPLAN Z移動+ﾀﾞｲﾜ配置(必要なら伸縮)
									;台輪の配置,伸縮
									(if #daiwaHINBAN (KPPutDaiwa #daiwaHINBAN "Z" &sym #daiwa)) ; #daiwa:特注="1"

									; &sym Z移動
									(setq #ssGRP (CFGetSameGroupSS &sym)); 同一グループ内の全図形選択セット
								  (if (and (CFGetXRecord "BASESYM") ; 基準ｱｲﾃﾑがある 且つ
								    			 (ssmemb (handent (car (CFGetXRecord "BASESYM"))) #ssGRP)) ; 基準ｱｲﾃﾑが #ssGRP に入っていた
								    (progn
								      (setq #ss (ssget "X" '((-3 ("G_ARW"))))) ; 矢印も移動する
								      (CMN_ssaddss #ss #ssGRP)
								    )
								  );_if

								  (setq #os (getvar "OSMODE"))
								  (setvar "OSMODE" 0)
								  (command "._MOVE" #ssGRP "" "0,0,0" (strcat "@0,0," (rtos (abs KEKOMI_COM))))
								  (setvar "OSMODE" #os)

									;03/06/13 YM ADD-S "G_TOKU"をつけないｹｺﾐUPの部材につける
									(if (= (tblsearch "APPID" "G_KUP") nil) (regapp "G_KUP"))
		  						(CFSetXData &sym "G_KUP" (list 1)) ; SLPANは 1
									;03/06/13 YM ADD-E

								)
								(progn
									;ひもつけ(SLPAN以外)
									(KP_SetDaiwaG_OPT &sym #daiwaHINBAN)
									;03/06/13 YM ADD-S "G_TOKU"をつけないｹｺﾐUPの部材につける
									(if (= (tblsearch "APPID" "G_KUP") nil) (regapp "G_KUP"))
		  						(CFSetXData &sym "G_KUP" (list 0)) ; SLPAN以外は 0
									;03/06/13 YM ADD-E
								)
							);_if

; 03/06/12 YM 仕様変更 境界線の表示はしない(誤解を招く)
;;;							; SPLAN (PMEN 9が存在する)だったら付台輪境界線を表示する
;;;							(if #pmen9
;;;								(progn
;;;									; 可視画層でﾊﾟｰｽ図に表示できる画層(SG_PCLAYER)へ変更する
;;;									(setq #eg$ (entget #pmen9))
;;;									(entmod (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)); SG_PCLAYER="Z_00_00_00_01"
;;;									(command "chprop" #pmen9 "" "C" "WHITE" "")
;;;									; 伸縮量に応じて移動する
;;;									(command "_move" #pmen9 "" '(0 0 0) (strcat "@0,0," (rtos (abs KEKOMI_COM))))
;;;								)
;;;							);_if

						)
						;else
						(progn ; DOWN 従来通り
							;/// 伸縮処理(ｹｺﾐUPでSPLANのときは伸縮しない) ////
							(KP_KekomiStretch &sym &Brk #xd_SYM$ &dist)

							(setq #price (atof #KEKOMI_Plus)) ; 01/05/30 YM ADD 価格は上乗せ金額を入れる
							(if (= #LR "Z") ; 01/06/27 YM ADD LR追加
								(setq #kekomi_hinban (strcat "ﾄｸ" #HINBAN))     ; 品番
								(setq #kekomi_hinban (strcat "ﾄｸ" #HINBAN #LR)) ; 品番
							);_if

							; ｹｺﾐ伸縮後の品番から()を取る
							(setq #kekomi_hinban (KP_DelHinbanKakko #kekomi_hinban)) ; 03/06/18 YM ADD

							; G_TOKU のｾｯﾄ
						  (CFSetXData &sym "G_TOKU"
						    (list
									#kekomi_hinban
						      #price     ; SX以外は+8000円価格
									(list (nth 3 #xd_SYM$)(nth 4 #xd_SYM$)(- (nth 5 #xd_SYM$) &dist))
									0 ; 1:特注ｷｬﾋﾞｺﾏﾝﾄﾞ 0:ｹｺﾐ伸縮 2:ｶｳﾝﾀｰﾄｯﾌﾟ
						      KEKOMI_BRK ; ﾌﾞﾚｰｸﾗｲﾝ位置
						      KEKOMI_COM ; 伸縮量
									#HINBAN    ; 元の品番
						    )
						  )

						)
					);_if

				)
			);_if

		)
		;else ｺﾝﾛ,水栓など伸縮(Z移動)する(G_TOKUはつけない)
		(progn
			;/// 伸縮処理(ｹｺﾐUPでSPLANのときは伸縮しない) ////
			(KP_KekomiStretch &sym &Brk #xd_SYM$ &dist)
		)
	);_if

  (princ)
);PcCabCutCall2

;;;<HOM>*************************************************************************
;;; <関数名>    : KPPutDaiwa
;;; <処理概要>  : 部材を配置する
;;; <戻り値>    : なし
;;; <作成>      : 03/06/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KPPutDaiwa (
	&DaiwaHinban ; 台輪品番名称
	&LR          ; 台輪LR ("Z")
	&sym         ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形
	&daiwa       ; 特注:"1" 規格:"0"
	/
	#ANG #FIG$ #FIG$$ #FIGBASE$ #FIGBASE$$ #HH #ID #PT #SKK
	#D #DAIWAREC$ #DAIWAREC$$ #H #KIKAKU_DAIWA #SYM #TOKU_DAIWA #W #XD_SYM$
#LR #ORG_PRICE #RET$
	)
	; 特注台輪の場合規格品品番を取得
	(if (= "1" &daiwa)
		(progn ; 特注
		  (setq #daiwaREC$$
		    (CFGetDBSQLRec CG_DBSESSION "付台輪"
		      (list
						(list "品番名称"  &DaiwaHinban  'STR)
		      )
		    )
		  )
			(if (and #daiwaREC$$ (= 1 (length #daiwaREC$$)))
				(progn
					(setq #daiwaREC$ (car #daiwaREC$$))
					(setq #Kikaku_daiwa (nth 6 #daiwaREC$)) ; 規格品品番
					(setq #Toku_daiwa   &DaiwaHinban)       ; 特注品品番
				)
				(progn
					(CFAlertMsg (strcat "付台輪にﾚｺｰﾄﾞがないかまたは複数存在します"
															"\n" &DaiwaHinban))
					(setq #Kikaku_daiwa nil) ; 規格品品番
					(setq #Toku_daiwa   nil) ; 特注品品番
				)
			);_if
		)
		(progn
			(setq #Kikaku_daiwa &DaiwaHinban) ; 規格品品番
			(setq #Toku_daiwa   nil)          ; 特注品品番
		)
	);_if

	;情報取得
	; ﾍﾞｰｽｷｬﾋﾞ挿入点,角度
	(if &sym
		(progn
			(setq #pt (cdr (assoc 10 (entget &sym))))
			(setq #ang (nth 2 (CFGetXData &sym "G_LSYM"))) ; 回転角度
		)
		;else
		(setq #pt nil #ang nil)
	);_if

	;品番基本 -----------------------------------------------
  (setq #figBase$$
    (CFGetDBSQLRec CG_DBSESSION "品番基本"
       (list
         (list "品番名称" #Kikaku_daiwa 'STR)
       )
    )
  )
	(if (and #figBase$$ (= 1 (length #figBase$$)))
		(progn ; 品番基本OK
			(setq #figBase$ (car #figBase$$))
			(setq #skk (fix (nth 3 #figBase$))) ; 性格ｺｰﾄﾞ
		)
		(progn
			(CFAlertMsg (strcat "品番基本にﾚｺｰﾄﾞがないかまたは複数存在します"
													"\n" #Kikaku_daiwa))
			(setq #skk nil)
		)
	);_if

	;品番図形 -----------------------------------------------
  (setq #fig$$
    (CFGetDBSQLHinbanTable "品番図形"
       #Kikaku_daiwa ;品番名称
       (list
         (list "品番名称"  #Kikaku_daiwa 'STR)
         (list "LR区分"    &LR     'STR)
         (list "用途番号"  "0"     'INT)
       )
    )
  )
	(if (and #fig$$ (= 1 (length #fig$$)))
		(progn ; 品番基本OK
			(setq #fig$ (car #fig$$))
			(setq #hh (fix (nth 5 #fig$))) ; 寸法H   ;2008/06/28 YM OK!
			(setq #id (nth 6 #fig$))       ; 図形ID  ;2008/06/28 YM OK!
		)
		(progn
			(CFAlertMsg (strcat "品番図形にﾚｺｰﾄﾞがないかまたは複数存在します"
													"\n" #Kikaku_daiwa))
			(setq #hh nil)
			(setq #id nil)
		)
	);_if

	; #daiwaHINBAN 配置
;;;	&id     ; 図形ID  STR "???????"  ".dwg"以外の部分
;;;	&pt     ; 挿入点　LIST
;;;	&ang    ; 角度    REAL
;;;	&hinban ; 品番名称
;;;	&LR     ; LR区分
;;;	&skk    ; [品番基本].性格ｺｰﾄﾞ
;;; &hh     ; [品番図形].寸法Ｈ
	(if (and #id #pt #ang #Kikaku_daiwa &LR #skk #hh)
		(setq #sym (KP_BuzaiHaiti #id #pt #ang #Kikaku_daiwa &LR #skk #hh))
	);_if

	; #daiwaHINBAN 伸縮
	(if (= "1" &daiwa)
		(progn ; 特注
			(setq #xd_SYM$ (CFGetXData #sym "G_SYM"))
			(setq #W (nth 3 #xd_SYM$))
			(setq #D (nth 4 #xd_SYM$))
			(setq #H (nth 5 #xd_SYM$))
			;;; 台輪にﾌﾞﾚｰｸﾗｲﾝがあることを前提に伸縮
			(SKY_Stretch_Parts #sym #W #D (abs KEKOMI_COM))
			; 特注情報ｾｯﾄ
		  (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))

			; 規格品価格
			(setq #ret$ (KPGetPrice #Kikaku_daiwa #LR))
			(setq #ORG_price (nth 0 #ret$))

		  (CFSetXData #sym "G_TOKU"
		    (list
					#Toku_daiwa          ; 特注品番
		      (atof #ORG_price)    ; 価格 実数
		      (list 0 0 0)
					1  ; 1:特注ｷｬﾋﾞｺﾏﾝﾄﾞ 0:ｹｺﾐ伸縮
					1  ; W ﾌﾞﾚｰｸﾗｲﾝ位置
					1  ; D ﾌﾞﾚｰｸﾗｲﾝ位置
					50 ; H ﾌﾞﾚｰｸﾗｲﾝ位置
					#Kikaku_daiwa ; 品番
		    )
		  )
		)
	);_if

	(princ)
);KPPutDaiwa

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_SetDaiwaG_OPT
;;; <処理概要>  : 付台輪品番をG_OPTにｾｯﾄする
;;; <戻り値>    : なし
;;; <作成>      : 03/06/12 YM
;;; <備考>      : ｹｺﾐUPでSPLANでない場合(但し性格ｺｰﾄﾞ117,118を除く)
;;;*************************************************************************>MOH<
(defun KP_SetDaiwaG_OPT (
	&sym         ; 親部材
	&daiwaHINBAN ; 付台輪品番
  /
	#DUM #DUM$ #I #LIS$ #OPT_OLD$ #SET$ #SYURUI #XD$_OPT
#DAIWAREC$$ ; 03/06/13 YM ADD
  )
	(if (= (tblsearch "APPID" "G_OPT") nil) (regapp "G_OPT"))
	(setq #xd$_OPT  (CFGetXData &sym "G_OPT"))

	(if &daiwaHINBAN
		(progn
			(if #xd$_OPT
				(progn ; 既存ｵﾌﾟｼｮﾝに追加する
					(setq #syurui (car #xd$_OPT)) ; OPTION 種類の数
					(setq #lis$ (cdr #xd$_OPT)) ; 品番1,個数1,品番2,個数2,...のﾘｽﾄ
					(setq #opt_old$ nil)        ; (品番1,個数1)(品番2,個数2),...
					(setq #i 0)
					(foreach #lis #lis$
						; 品番,個数,品番,個数,...の順番
						(if (= 0 (rem #i 2))
							(progn
								(setq #dum #lis) ; 品番
								;03/06/13 YM ADD-S 付台輪TBに存在するか
							  (setq #daiwaREC$$
							    (CFGetDBSQLRec CG_DBSESSION "付台輪"
							      (list (list "品番名称"  #dum  'STR))
							    )
							  )
								(if #daiwaREC$$
									(progn ; もし存在したら"G_OPT"から削除するため、#dum=nilとする
										(setq #dum nil)
										(setq #syurui (1- #syurui)) ; ｵﾌﾟｼｮﾝ品の個数を1つ減らす
									)
								);_if
							)
							;else
							(progn
								(if #dum ; 付台輪ではない
									(setq #opt_old$ (append #opt_old$ (list #dum #lis)))
								);_if
							)
						);_if
						(setq #i (1+ #i))
					);foreach

					(setq #Set$ (append (list (1+ #syurui)) #opt_old$ (list &daiwaHINBAN 1))) ; 末尾に追加

				)
				(progn ; 新規ｾｯﾄ(1つ)
					(setq #Set$ (list 1 &daiwaHINBAN 1))
				)
			);_if

			; G_OPTにｾｯﾄする
		  (if #Set$ (CFSetXData &sym "G_OPT" #Set$))

		)
	);_if
	(princ)
);KP_SetDaiwaG_OPT

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_GetDaiwaHinban
;;; <処理概要>  : 付台輪品番を取得する
;;; <戻り値>    : 付台輪品番
;;; <作成>      : 03/06/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_GetDaiwaHinban (
	&magnum &daiwa &SPLAN &cnr &HINBAN
  /
	#DAIWAHINBAN #DAIWAREC$ #DAIWAREC$$
  )
  (setq #daiwaREC$$
    (CFGetDBSQLRec CG_DBSESSION "付台輪"
      (list
        (list "間口"  &magnum 'INT)
        (list "特注"  &daiwa  'INT)
				(list "SPLAN" &SPLAN  'INT)
				(list "隅用"  &cnr  'INT)
      )
    )
  )
  (if #daiwaREC$$
		(progn
			(if (= 1 (length #daiwaREC$$))
				(progn
					(setq #daiwaREC$ (car #daiwaREC$$))
					(setq #daiwaHINBAN (nth 5 #daiwaREC$))
				)
				;else
				(progn ; 複数HITしたらﾕｰｻﾞｰに選択させる
					(setq #daiwaHINBAN (GetDaiwa_Dlg #daiwaREC$$ &HINBAN)) ; 台輪選択肢,下台品番
					(if (= nil #daiwaHINBAN)(quit))
				)
			);_if
		)
		(progn
			(CFAlertMsg "付台輪ﾃｰﾌﾞﾙにﾚｺｰﾄﾞがありません")
			(setq #daiwaHINBAN nil)
		)
	);_if
	#daiwaHINBAN
);KP_GetDaiwaHinban

;;;<HOM>*************************************************************************
;;; <関数名>    : Pmen9Hantei
;;; <処理概要>  : PMEN9が存在するか判定(SPLANかどうか)
;;; <戻り値>    : T(存在) or nil
;;; <作成>      : 03/06/12 YM
;;; <備考>      : SPLANだけPMEN9が存在する
;;;*************************************************************************>MOH<
(defun Pmen9Hantei (
	&sym
  /
	#EN #I #LOOP #PMEN9 #SS #XD$
  )
	(setq #pmen9 nil) ; P面9
	(setq #ss (CFGetSameGroupSS &sym))
	(setq #i 0)
	(setq #loop T)
	(while (and #loop (< #i (sslength #ss)))
	  (setq #en (ssname #ss #i)) ; ｼﾝｸｷｬﾋﾞの同一ｸﾞﾙｰﾌﾟ
	  (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
	  (if #xd$
	    (progn
	      (if (= 9 (car #xd$))
	        (progn
	          (setq #pmen9 #en) ; P面9
	          (setq #loop nil)
	        )
	      );_if
	    )
	  );_if
	  (setq #i (1+ #i))
	)
	#pmen9
);Pmen9Hantei

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_KekomiStretch
;;; <処理概要>  : ｹｺﾐ伸縮処理をまとめて関数化
;;; <戻り値>    : なし
;;; <作成>      : 03/06/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_KekomiStretch (
	&sym &Brk &xd_SYM$ &dist
  /
	#EDELBRK$ #GNAM #PT #XLINE
  )
;;;  (command "._shademode" "3D") ; 隠線処理 解除(ｽﾋﾟｰﾄﾞｱｯﾌﾟ)07/07 YM ADD
  (setq #eDelBRK$ (PcRemoveBreakLine &sym "H")) ; 00/12/22 ADD MH H方向ブレーク除去
	;;; ﾌﾞﾚｰｸﾗｲﾝの作図
	(setq #pt (cdr (assoc 10 (entget &sym)))) ; ｼﾝﾎﾞﾙ基準点
	(setq #XLINE (PK_MakeBreakH #pt &Brk))

	(CFSetXData #XLINE "G_BRK" (list 3))
	(setq	#gnam (SKGetGroupName &sym))
	;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
	(command "-group" "A" #gnam #XLINE "")
	;;; 伸縮
	(SKY_Stretch_Parts &sym (nth 3 &xd_SYM$)(nth 4 &xd_SYM$)(- (nth 5 &xd_SYM$) &dist))

	(entdel #XLINE)
  (foreach #eD #eDelBRK$ (entdel #eD)) ; 00/12/22 ADD MH H方向ブレーク復活
	(princ)
);KP_KekomiStretch

;;;<HOM>*************************************************************************
;;; <関数名>    : GetDaiwa_Dlg
;;; <処理概要>  : 付台輪を選択する画面を表示する
;;; <戻り値>    : 付台輪品番
;;; <作成>      : 03/06/09 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun GetDaiwa_Dlg (
	&lis$   ; 付台輪選択肢
	&HINBAN ; 上に配置する下台
  /
	#DCL_ID #MSG #POP$ #RET
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #ret
            )
            (setq #ret (nth (atoi (get_tile "daiwa")) #pop$)) ; 付台輪品番
						(done_dialog)
            #ret
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( /	#hin) ; ﾃﾞｰﾀｿｰｽﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
						(setq #pop$ '())
					  (start_list "daiwa" 3)
					  (foreach #lis &lis$
							(setq #hin (nth 5 #lis))
					    (add_list #hin)
							(setq #pop$ (append #pop$ (list #hin)))
					  )
					  (end_list)
						(set_tile "daiwa" "0") ; 最初にﾌｫｰｶｽ
						(princ)
          );##Addpop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "Daiwa_Dlg" #dcl_id)) (exit))

	; メッセージを表示
	(setq #msg1 (strcat "品番 ＝ " &HINBAN))
	(set_tile "text1" #msg1)
	(setq #msg2 "に取付ける付台輪を選択してください")
	(set_tile "text2" #msg2)

	;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
	(##Addpop)

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #ret (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret
);GetDaiwa_Dlg

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_MakeBreakH
;;; <処理概要>  : H800処理用に一時的にH方向ﾌﾞﾚｰｸﾗｲﾝを作図
;;; <戻り値>    : XLINE 図形名
;;; <作成>      : 00/11/21 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PK_MakeBreakH (
	&SYM_PT ; ｼﾝﾎﾞﾙ基準点位置座標
	&Brk    ; ﾌﾞﾚｰｸﾗｲﾝ高さ
  /
	#pt
  )
	(setq #pt (list (car &SYM_PT) (cadr &SYM_PT) &Brk))
	(entmake
		(list
			(cons 0 "XLINE")
			(cons 100 "AcDbEntity")
			(cons 67 0)
			(cons 8 "N_BREAKH")
			(cons 100 "AcDbXline")
			(cons 10 #pt) ; 通過点
			(cons 11 (list 0.5 0.5 0.0)) ; 方向
		)
	)
	(entlast)
);PK_MakeBreakH

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_MakeBreakW
;;; <処理概要>  : 特注ｷｬﾋﾞｺﾏﾝﾄﾞ用に一時的にW方向ﾌﾞﾚｰｸﾗｲﾝを作図
;;; <戻り値>    : XLINE 図形名
;;; <作成>      : 01/01/26 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PK_MakeBreakW (
	&SYM_PT ; ｼﾝﾎﾞﾙ基準点位置座標
	&ANG    ; ｼﾝﾎﾞﾙ配置角度
	&Brk    ; ﾌﾞﾚｰｸﾗｲﾝ位置
  /
	#pt
  )
	(setq #pt (polar &SYM_PT &ANG &Brk))
	(entmake
		(list
			(cons 0 "XLINE")
			(cons 100 "AcDbEntity")
			(cons 67 0)
			(cons 8 "N_BREAKH")
			(cons 100 "AcDbXline")
			(cons 10 #pt) ; 通過点
			(cons 11 (list 0 1 1)) ; 方向
		)
	)
	(entlast)
);PK_MakeBreakW

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_MakeBreakD
;;; <処理概要>  : 特注ｷｬﾋﾞｺﾏﾝﾄﾞ用に一時的にD方向ﾌﾞﾚｰｸﾗｲﾝを作図
;;; <戻り値>    : XLINE 図形名
;;; <作成>      : 01/01/26 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PK_MakeBreakD (
	&SYM_PT ; ｼﾝﾎﾞﾙ基準点位置座標
	&ANG    ; ｼﾝﾎﾞﾙ配置角度
	&Brk    ; ﾌﾞﾚｰｸﾗｲﾝ位置
  /
	#pt
  )
	(setq #pt (polar &SYM_PT (- &ANG (dtr 90)) &Brk))
	(entmake
		(list
			(cons 0 "XLINE")
			(cons 100 "AcDbEntity")
			(cons 67 0)
			(cons 8 "N_BREAKH")
			(cons 100 "AcDbXline")
			(cons 10 #pt) ; 通過点
			(cons 11 (list 1 0 -1)) ; 方向
		)
	)
	(entlast)
);PK_MakeBreakD

;;;<HOM>***********************************************************************
;;; <関数名>    : PcRemoveBreakLine
;;; <処理概要>  : グループからブレークラインを消去、復元用に図形名リスト提出
;;; <戻り値>    : 消去した図形名リスト
;;; <作成>      : 00-12-22 MH
;;; <備考>      :
;;;***********************************************************************>MOH<
(defun PcRemoveBreakLine (
  &eEN          ; 図形名
  &sFLG         ; 削除させるブレークラインの種類 "H" "W" "D"
  /
  #G$ #GRP$ #Temp$ #BrkW$ #BrkD$ #BrkH$ #eD #eDEL$
  )
  (if (= 'ENAME (type &eEN)) ; G_SYMである条件削除 01/02/09 YM
		(progn
	    (setq #GRP$ (entget (cdr (assoc 330 (entget &eEN)))))
	    (foreach #G$ #GRP$
	      ;; グループ構成図形がブレークラインかどうかのチェック
	      (if (and (= (car #G$) 340)
	               (= (cdr (assoc 0 (entget (cdr #G$)))) "XLINE")
	               (setq #Temp$ (CFGetXData (cdr #G$) "G_BRK"))
	          ); and
	          ;; H,W,D 各ブレークラインの種類毎に図形名を格納する
	        (cond
	          ;; W 方向ブレークラインだった
	          ((= (nth 0 #Temp$) 1) (setq #BrkW$ (cons (cdr #G$) #BrkW$)))
	          ;; D 方向ブレークラインだった
	          ((= (nth 0 #Temp$) 2) (setq #BrkD$ (cons (cdr #G$) #BrkD$)))
	          ;; H 方向ブレークラインだった
	          ((= (nth 0 #Temp$) 3) (setq #BrkH$ (cons (cdr #G$) #BrkH$)))
	        ); cond
	      ); if
	    ); foreach
	    (cond
	      ((= "W" &sFLG) (setq #eDEL$ #BrkW$))
	      ((= "D" &sFLG) (setq #eDEL$ #BrkD$))
	      ((= "H" &sFLG) (setq #eDEL$ #BrkH$))
	    ); cond
	    ; 取得されたブレークライン削除
	    (foreach #eD #eDEL$ (entdel #eD))
  	)
	); if progn
  #eDEL$
); PcRemoveBreakLine

;;;<HOM>***********************************************************************
;;; <関数名>    : ChgDrCALL
;;; <処理概要>  : 扉面の変更(Genic==>Notilｼﾘｰｽﾞ変換時に使用する)
;;; <戻り値>    : なし
;;; <作成>      : 01/04/03 YM
;;; <備考>      :
;;;***********************************************************************>MOH<
(defun ChgDrCALL (
	&seri$
  /
	#EN$ #I #RET$ #SS #SYMNORMAL$ #SYMTOKU$ #TOKU #TOKU$ #XREC$
  )
  ;// 現在の商品情報を取得する
  (setq #XRec$ &seri$)

	; 扉面一括変更
;;;      CG_DRSeriCode ; 4.扉SERIES記号
;;;      CG_DRColCode  ; 5.扉COLOR記号
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
	(if (and #ss (< 0 (sslength #ss)))
		(progn

		  (setq #i 0)
		  (repeat (sslength #ss)
		    (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode (ssname #ss #i) 1))
		      (setq #en$ (cons (ssname #ss #i) #en$))
		    )
		    (setq #i (1+ #i))
		  )
			; 01/03/12 YM ADD 特注ｷｬﾋﾞと一般ｷｬﾋﾞを分ける
			(setq #symTOKU$ nil #symNORMAL$ nil #TOKU nil)
			(foreach en #en$
				(if (and (setq #TOKU$ (CFGetXData en "G_TOKU"))
								 (= (nth 3 #TOKU$) 1))
					(progn
						(setq #TOKU T) ; 特注ｷｬﾋﾞがあった
						(setq #symTOKU$ (append #symTOKU$ (list en))) ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞを使用
					)
					(setq #symNORMAL$ (append #symNORMAL$ (list en)))
				);_if
			)
			(if #TOKU ; 01/03/22 YM ADD
				(CFAlertErr "特注キャビネットは扉面の変更を行えません。")
			);_if

		  ;// 扉面の貼り付け(特注以外の場合)
			(if #symNORMAL$
		  	(PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
			);_if

		  ;00/08/25 SN ADD 基準ｱｲﾃﾑが存在する場合は基準ｱｲﾃﾑを再表示
		  (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
		    (progn
		      (setq CG_BASESYM (CFGetBaseSymXRec))
		      (ResetBaseSym)
		      (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
		    ); progn
		  )
		  (princ "\n扉面のSERIESを変更しました。")

		)
	);_if
	(princ)
);ChgDrCALL

;///////////////////////////////////////////////
(defun C:ccc ( / )
	(C:KPChangeSeries)
)

;;;<HOM>***********************************************************************
;;; <関数名>    : KP_CheckGtoN
;;; <処理概要>  : ｼﾘｰｽﾞ変更可否をﾁｪｯｸ
;;; <戻り値>    : なし
;;; <作成>      : 01/04/05 YM
;;; <備考>      : Genic<==>Notilのみ可能
;;;               01/05/09 YM 修正 CAD上でｼﾘｰｽﾞ変更し、
;;;               XrecordとPlanInfo.cfgを更新する
;;;***********************************************************************>MOH<
(defun KP_CheckGtoN (
  /
  #MSG1 #MSG2 #MSG3 #MSG4 #SERI$
	#FP #PLANINFO$ #QRY$ #RET$ #SFNAME #QLY$$
  )

	; 現在のｼﾘｰｽﾞ記号を取得
	(setq #msg1 "SERIES記号を取得できませんでした。")
	(setq #msg2 "現在のSERIESを変更できません。")
	(setq #msg3 "SERIESをGenicに変更しますか？")
	(setq #msg4 "SERIESをNotilに変更しますか？")

  (if (setq #seri$ (CFGetXRecord "SERI"))
		(progn
			; 変更前のもの
      (setq CG_SeriesCode  (nth 1 #seri$)) ; 2.SERIES記号

			(cond
				((= CG_SeriesCode "SG"); Genic==>Noitl
          (if (CFYesNoDialog #msg4)
						(progn
						 	(setq Ch_Seri "GN"); ｸﾞﾛｰﾊﾞﾙ設定
							(setq CG_SeriesCode "N") ; 2.SERIES記号
						)
						(*error*)
          );_if
			 	)
				((= CG_SeriesCode "N") ; Noitl==>Genic
          (if (CFYesNoDialog #msg3)
						(progn
					 		(setq Ch_Seri "NG"); ｸﾞﾛｰﾊﾞﾙ設定
							(setq CG_SeriesCode "SG") ; 2.SERIES記号
						)
						(*error*)
          );_if
			 	)
				(T
					(CFAlertErr #msg2)
					(princ #msg2)
					(*error*)
			 	)
			);_cond
		)
		(progn
			(CFAlertErr #msg1)
			(princ #msg1)
			(*error*)
		)
  );_if

  ;// 共通データベースへの接続
  (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
	; 01/11/04 HN MOD SERIES検索キーを追加
  ;@MOD@(setq #qry$ (CFGetDBSQLRecChk CG_CDBSESSION "SERIES"
	;@MOD@	(list (list "SERIES記号" CG_SeriesCode 'STR)))
	;@MOD@)
;;;01/11/27YM@MOD	(setq #qry$	(CFGetDBSQLRecChk CG_CDBSESSION "SERIES" (list (list "略称" CG_DBNAME 'STR))))

	; 複数HITあり 02/03/21 YM MOD
  (setq #QLY$$
    (CFGetDBSQLRec CG_CDBSESSION "SERIES"
      (list (list "SERIES記号" CG_SeriesCode 'STR))
  	)
	)

;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #QLY$$)
;;;		;ｼﾘｰｽﾞ別DB,共通DB再接続
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E

;;;  (setq #qry$ (CFGetDBSQLRecChk CG_CDBSESSION "SERIES"
;;;		(list (list "SERIES記号" CG_SeriesCode 'STR)))
;;;	)

  (if (= nil #QLY$$)
		(progn
    	(CFAlertErr "SERIESテーブルが見つかりません")
			(*error*)
		)
  );_if

	; ｼﾘｰｽﾞ名称選択ﾀﾞｲｱﾛｸﾞ ｼﾘｰｽﾞDB更新対応 SGA,SGB,SGC,... or SNA,SNB,SNC,...
	; たとえばGenic-->Notilの場合 MK_SNA,MK_SNB,MK_SNCのどれを参照するかﾕｰｻﾞｰに選択させる
	; 02/03/21 YM ADD-S
	(setq #ret$ (KP_ChSeriDlg #QLY$$))
	(setq CG_SeriesDB (nth 0 #ret$))
	(setq CG_DBNAME   (nth 1 #ret$))

	; 02/03/21 YM ADD-E

;;;	(setq CG_SeriesDB (nth 0 #qry$))
;;;	(setq CG_DBNAME   (nth 7 #qry$))

	; 扉記号,ｶﾗｰの選択
  (setq #ret$
    (SRSelectDoorSeriesDlg
      "扉面変更"
      CG_DBNAME     ; 変更後
      CG_SeriesCode
      nil ; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄのﾃﾞﾌｫﾙﾄは一番上
      nil ; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄのﾃﾞﾌｫﾙﾄは一番上
    )
  )
	; ｷｬﾝｾﾙ対応 01/07/23 YM ADD
	(if (= nil #ret$)
		(progn
			(princ"\nｺﾏﾝﾄﾞをｷｬﾝｾﾙしました。") ; ｷｬﾝｾﾙ時 01/07/23 YM
			(*error*)
		)
	);_if

	; ｼﾘｰｽﾞ変更後扉記号ｶﾗｰ
  (setq CG_DRSeriCode (car #ret$))  ;扉SERIES記号
  (setq CG_DRColCode  (cadr #ret$)) ;扉COLOR記号

	; Xrecord更新 ｼﾘｰｽﾞ変更後のもの
  (setq #seri$
    (list
      CG_DBNAME       ; 1.DB名称
      CG_SeriesCode   ; 2.SERIES記号
      CG_BrandCode    ; 3.ブランド記号
      CG_DRSeriCode   ; 4.扉SERIES記号
      CG_DRColCode    ; 5.扉COLOR記号
      CG_UpCabHeight  ; 6.取付高さ
      CG_CeilHeight   ; 7.天井高さ
      CG_RoomW        ; 8.間口
      CG_RoomD        ; 9.奥行
      CG_GasType      ;10.ガス種
      CG_ElecType     ;11.電気種
      CG_KikiColor    ;12.機器色
      CG_KekomiCode   ;13.ケコミ飾り
    )
  )
	(CFSetXRecord "SERI" #seri$)
	; PlanInfo.cfgを更新
  ;// 現在のプラン情報(PLANINFO.CFG)を読み込む
  (setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
	; 項目の更新
	(setq #PLANINFO$ (subst (list "SeriesDB"       CG_SeriesDB)   (assoc "SeriesDB"       #PLANINFO$) #PLANINFO$))
	(setq #PLANINFO$ (subst (list "SeriesCode"     CG_SeriesCode) (assoc "SeriesCode"     #PLANINFO$) #PLANINFO$))
	(setq #PLANINFO$ (subst (list "DoorSeriesCode" CG_DRSeriCode) (assoc "DoorSeriesCode" #PLANINFO$) #PLANINFO$))
	(setq #PLANINFO$ (subst (list "DoorColorCode"  CG_DRColCode)  (assoc "DoorColorCode"  #PLANINFO$) #PLANINFO$))

  (setq #sFname (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
  (setq #fp  (open #sFname "w"))
  (if (/= nil #fp)
    (progn
      (foreach #elm #PLANINFO$
        (if (= ";" (substr (car #elm) 1 1))
          (princ (car #elm) #fp)
          ;else
          (progn
            (if (= (car #elm) "") ; if文分岐 03/07/22 YM ADD
              nil ; 空行(何も書かない)
							;else
							(progn
								(if (= (cadr #elm) nil) ; if文分岐 2011/10/14 YM ADD
									(princ (car #elm) #fp)
									;else
            			(princ (strcat (car #elm) "=" (cadr #elm)) #fp)
								);_if
							)
            );_if
          )
        );_if
        (princ "\n" #fp)
      );foreach
	  	(close #fp)
		)
		(progn
			(CFAlertMsg "PLANINFO.CFGへの書き込みに失敗しました。")
			(*error*)
		)
	);_if
	#seri$
);KP_CheckGtoN

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_ChSeriDlg
;;; <処理概要>  : ｼﾘｰｽﾞ変更時のダイアログ
;;; <戻り値>    : MK_SGA,MK_SGB...などの参照DB名
;;; <作成>      : 02/03/21 YM
;;; <備考>      : ｼﾘｰｽﾞ変更時ｼﾘｰｽﾞ別DBが数世代あったときの対応
;;;*************************************************************************>MOH<
(defun KP_ChSeriDlg (
	&QLY$$ ; ｼﾘｰｽﾞTBﾚｺｰﾄﾞ
  /
	#DB #DCL_ID #DUM$$ #POP1$ #POP2$ #QRY$$ #ret$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KP_ChSeriDlg ////")
  (CFOutStateLog 1 1 " ")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #DB
            )
            (setq #SERI(nth (atoi (get_tile "seri")) #pop1$)) ; ｼﾘｰｽﾞ名称
            (setq #DB  (nth (atoi (get_tile "seri")) #pop2$)) ; 略称(DB名)
            (done_dialog)
						(list #SERI #DB)
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( /	) ; ｼﾘｰｽﾞﾘｽﾄﾎﾞｯｸｽ
						(setq #pop1$ '() #pop2$ '()) ; ｼﾘｰｽﾞ名称,略称
					  (start_list "seri" 3)
					  (foreach #Qry$ #Qry$$
					    (add_list (strcat (nth 0 #Qry$) " : " (nth 6 #Qry$))) ; SGA : Genic など
							(setq #pop1$ (append #pop1$ (list (nth 0 #Qry$))))    ; ｼﾘｰｽﾞ名称を保存
							(setq #pop2$ (append #pop2$ (list (nth 7 #Qry$))))    ; 略称を保存
					  )
					  (end_list)
						(set_tile "seri" "0")                                   ; 最初にﾌｫｰｶｽ
						(princ)
          );##Addpop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; 廃盤Fが1でないもの
	(setq #dum$$ nil)
  (foreach #Qry$ &QLY$$
		(if (/= 1 (nth 10 #Qry$))
			(setq #dum$$ (append #dum$$ (list #Qry$)))
		);_if
  )
	(setq #Qry$$ #dum$$)

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "ChSeriDlg" #dcl_id)) (exit))

	;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
	(##Addpop)

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret$
);KP_ChSeriDlg

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_ChSeriDlg2
;;; <処理概要>  : ｼﾘｰｽﾞ変更時のダイアログ
;;; <戻り値>    : MK_SGA,MK_SGB...などの参照DB名
;;; <作成>      : 02/03/21 YM
;;; <備考>      : ｼﾘｰｽﾞ変更時ｼﾘｰｽﾞ別DBが数世代あったときの対応
;;;               ｼﾘｰｽﾞ記号も返す
;;;*************************************************************************>MOH<
(defun KP_ChSeriDlg2 (
	&QLY$$ ; ｼﾘｰｽﾞTBﾚｺｰﾄﾞ
  /
	#DB #DCL_ID #DUM$$ #POP1$ #POP2$ #QRY$$ #ret$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KP_ChSeriDlg2 ////")
  (CFOutStateLog 1 1 " ")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #DB
            )
            (setq #SERI (nth (atoi (get_tile "seri")) #pop1$)) ; ｼﾘｰｽﾞ名称
            (setq #DB   (nth (atoi (get_tile "seri")) #pop2$)) ; 略称(DB名)
						(setq #KIGO (nth (atoi (get_tile "seri")) #pop3$)) ; ｼﾘｰｽﾞ記号
            (done_dialog)
						(list #SERI #DB #KIGO)
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( /	) ; ｼﾘｰｽﾞﾘｽﾄﾎﾞｯｸｽ
						(setq #pop1$ '() #pop2$ '() #pop3$ '()) ; ｼﾘｰｽﾞ名称,略称,ｼﾘｰｽﾞ記号
					  (start_list "seri" 3)
						(setq #n 0 #focus 0)
					  (foreach #Qry$ #Qry$$
					    (add_list (strcat (nth 4 #Qry$) " : " (nth 0 #Qry$) " : " (nth 6 #Qry$))) ; SG : SGA : Genic など
							(setq #pop1$ (append #pop1$ (list (nth 0 #Qry$))))    ; ｼﾘｰｽﾞ名称を保存
							(setq #pop2$ (append #pop2$ (list (nth 7 #Qry$))))    ; 略称を保存
							(setq #pop3$ (append #pop3$ (list (nth 4 #Qry$))))    ; ｼﾘｰｽﾞ記号を保存
							(if (= CG_SeriesCode (nth 4 #Qry$))
								(setq #focus #n)
							);_if
							(setq #n (1+ #n))
					  )
					  (end_list)
						(set_tile "seri" (itoa #focus))                                   ; 最初にﾌｫｰｶｽ
						(princ)
          );##Addpop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; 廃盤Fが1でないもの
	(setq #dum$$ nil)
  (foreach #Qry$ &QLY$$
		(if (/= 1 (nth 10 #Qry$))
			(setq #dum$$ (append #dum$$ (list #Qry$)))
		);_if
  )
	(setq #Qry$$ #dum$$)

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "ChSeriDlg" #dcl_id)) (exit))

	;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
	(##Addpop)

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret$
);KP_ChSeriDlg2

;;;<HOM>***********************************************************************
;;; <関数名>    : C:KPChangeSeries
;;; <処理概要>  : 図面上のｷｬﾋﾞをNotil品番にする
;;; <戻り値>    : なし
;;; <作成>      : 01/04/03 YM
;;; <備考>      : Genic==>Notilのみ可能
;;;***********************************************************************>MOH<
(defun C:KPChangeSeries (
  /
  #CG_DRCOLCODE #SERI$ #SERIESCODE #SS #I #SYM #WT
	#SSFILR #STR #ssTOKU #flgTOKU #TOKU$
	NG$ ; 品番未変更ﾘｽﾄ
#ssLSYM #CNT_EXIST #CODE$ #XD_LSYM$ ; 02/08/29 YM ADD
  )
	(setq Ch_Seri nil NG$ nil)
  (StartUndoErr);00/10/02 SN MOD UNDO処理関数変更

;;;          (setq #DBNAME (nth  0 #seri$)) ; 1.DB名称
;;;          ;// SERIES別データベースへの接続
;;;          (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))

	(setq #ssTOKU (ssget "X" '((-3 ("G_TOKU")))))

	; 02/08/29 YM ADD-S ﾜｰｸﾄｯﾌﾟ化していないｶｳﾝﾀｰがあれば警告表示する
	(setq #ssLSYM (ssget "X" '((-3 ("G_LSYM")))))
	(if (and #ssLSYM (< 0 (sslength #ssLSYM)))
		(progn
			(setq #i 0)
			(setq #CNT_exist nil) ; ｶｳﾝﾀｰが存在する
			(repeat (sslength #ssLSYM)
				(setq #sym (ssname #ssLSYM #i))
    		(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
			 	(if #xd_LSYM$
					(progn ; LSYMあり
						(setq #code$ (CFGetSymSKKCode #sym nil))    ; 性格ｺｰﾄﾞ
  					(if (and (= CG_SKK_ONE_CNT (nth 0 #code$))
										 (= CG_SKK_THR_CNT (nth 2 #code$))) ; 7?9(ｶｳﾝﾀｰだったら)
							(setq #CNT_exist T) ; ｶｳﾝﾀｰが存在する
						);_if
					)
				);_if
				(setq #i (1+ #i))
			);repeat

			(if #CNT_exist
				(progn
					(CFAlertMsg (strcat "図面上にワークトップ化されていないカウンターが存在します。"
															"\nワークトップ化してからSERIES変更してください。"))
					(quit)
				)
			);_if
		)
	);_if
	; 02/08/29 YM ADD-E

	(setq #flgTOKU nil)
	(if (and #ssTOKU (< 0 (sslength #ssTOKU)))
		(progn ; 特注ｷｬﾋﾞ(ｹｺﾐ伸縮でない)が存在すると終了 01/05/15 YM ADD
			; 01/08/28 YM ADD-S ﾍﾞﾙﾌｫﾝﾃは"SV","SK"なのでｼﾘｰｽﾞ変更はありえないが追加
			(setq #i 0)
			(repeat (sslength #ssTOKU)
				(if (and (setq #TOKU$ (CFGetXData (ssname #ssTOKU #i) "G_TOKU"))
								 (/= (nth 3 #TOKU$) 2)) ; ｶｳﾝﾀｰ以外(ｹｺﾐ伸縮 or 特注)
					(setq #flgTOKU T)
				);_if
				(setq #i (1+ #i))
			)
			; 01/08/28 YM ADD-E

;;;01/08/28YM@DEL			(setq #flgTOKU T)
			(if #flgTOKU
				(progn
					(CFAlertErr "図面上に特注キャビネットが存在するため、SERIES変更できません。")
					(*error*)
				)
			);_if
		)
	);_if

	; ｺﾏﾝﾄﾞ実行可否をﾁｪｯｸ
	(setq #seri$ (KP_CheckGtoN))

	; 図面上のG_FILRを取得～品番変更
  (setq #ssFILR (ssget "X" '((-3 ("G_FILR")))))

	(if (and #ssFILR (< 0 (sslength #ssFILR)))
		(progn
			(setq #i 0)
			(repeat (sslength #ssFILR)
				(setq #sym (ssname #ssFILR #i))
				(KPChSeriFILR #sym Ch_Seri) ; 品番変更拡張ﾃﾞｰﾀ更新
				(setq #i (1+ #i))
			)
		)
	);_if


	; 図面上のLSYMを取得～品番変更
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))

	(if (and #ss (< 0 (sslength #ss)))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #sym (ssname #ss #i))
				(KPChSeriHin #sym Ch_Seri) ; 品番変更拡張ﾃﾞｰﾀ更新
				(setq #i (1+ #i))
			)
		)
	);_if

	; 警告表示
	(if NG$
		(progn
			(setq #i 0)
			(foreach NG NG$
				(if (= #i 0)
					(setq #STR NG)
					(setq #STR (strcat #STR "," NG))
				);_if
				(setq #i (1+ #i))
			)
			(CFAlertErr (strcat "品番名称：\"" #STR "\"はデータベースによる品番変更を行うことができませんでした。"))
		)
	);_if

	; 図面上のWRKTを取得～拡張ﾃﾞｰﾀ更新
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
	(if (and #ss (< 0 (sslength #ss)))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #WT (ssname #ss #i))
				(KPChSeriWT #WT Ch_Seri) ; 品番変更拡張ﾃﾞｰﾀ更新
				(setq #i (1+ #i))
			)
		)
	);_if

	; 扉変更 Genic==>Notil
	(ChgDrCALL #seri$)
  (command "_purge" "BL" "*" "N") ; 01/05/14 YM ADD

	;2011/04/22 YM MOD
	(setvar "MODEMACRO"
		(strcat "ｼﾘｰｽﾞ: " CG_SeriesDB " / 扉ｸﾞﾚｰﾄﾞ: " CG_DRSeriCode " / 扉ｶﾗｰ: " CG_DRColCode " / 引手: " CG_HIKITE)
	)

	; 01/05/18 YM ADD ﾌﾘｰﾌﾟﾗﾝ設計ﾀﾞｲｱﾛｸﾞを終了する
	(C:arxStartApp (strcat CG_SysPATH "KillPlan.exe") 0)
	(princ)

	(setq Ch_Seri nil NG$ nil)
  (setq *error* nil)
	(princ)
); C:KPChangeSeries

;;;<HOM>***********************************************************************
;;; <関数名>    : KPChSeriG_OPT
;;; <処理概要>  : G_OPT品番をNotil or Genic 品番に変換する
;;; <戻り値>    : G_OPTｾｯﾄ用ﾘｽﾄ #Set$
;;; <作成>      : 01/04/12 YM 階層??を参照する
;;; <備考>      :
;;;***********************************************************************>MOH<
(defun KPChSeriG_OPT (
	&xd$_OPT
  /
	#HINKOSU #HINNAME #I #KOSU #NEWHINNAME #QLY$ #SET$ #XD$_OPT
  )
	(setq #xd$_OPT &xd$_OPT)
	(setq #i 1)
	(setq #kosu (nth 0 #xd$_OPT))
	(setq #Set$ (list #kosu))
	(repeat #kosu
		(setq #HINname (nth #i #xd$_OPT))      ; OPT品番名称
		(setq #HINkosu (nth (1+ #i) #xd$_OPT)) ; OPT品個数

	  (setq #QLY$
	    (CFGetDBSQLRec CG_DBSESSION (strcat "階層" CG_SeriesCode)
	      (list (list "階層名称2" #HINname 'STR))
	  	)
		)
		(if (and #QLY$ (= (length #QLY$) 1)
						 (nth 2 (car #QLY$))
						 (/= "" (nth 2 (car #QLY$))))
			(setq #newHINname (nth 2 (car #QLY$))) ; 変換後の品番
			(progn ; 変換後の品番が求まらない
				(setq #newHINname #HINname) ; 元のまま
				(princ (strcat "\n品番\"" #HINname "\"は未変更です。"))
				(setq NG$ (append NG$ (list #HINname)))
			)
		);_if
		(setq #Set$ (append #Set$ (list #newHINname #HINkosu)))
		(setq #i (+ #i 2))
	);repeat
	#Set$
);KPChSeriG_OPT

;;;<HOM>***********************************************************************
;;; <関数名>    : KPChSeriFILR
;;; <処理概要>  : G_FILR品番をNotil or Genic 品番に変換する
;;; <戻り値>    : G_FILR図形
;;; <作成>      : 01/04/12 YM 階層??を参照する G_OPTも変換する
;;; <備考>      :
;;;***********************************************************************>MOH<
(defun KPChSeriFILR (
	&sym
	&Ch_Seri
  /
	#HINKOSU #HINNAME #I #KOSU #NEWHINNAME #QLY$ #SERIES #SET$ #SYM #XD$_FILR #XD$_OPT
  )
	(if (= &Ch_Seri "GN")(setq #series "N" ))
	(if (= &Ch_Seri "NG")(setq #series "SG"))

	(setq #sym &sym)
	(setq #xd$_OPT  (CFGetXData #sym "G_OPT"))  ; 拡張ﾃﾞｰﾀ"G_OPT"取得
	(setq #xd$_FILR  (CFGetXData #sym "G_FILR"))  ; 拡張ﾃﾞｰﾀ"G_FILR" 取得
	(setq #HINname (nth 0 #xd$_FILR)) ; 品番名称

  (setq #QLY$
    (CFGetDBSQLRec CG_DBSESSION (strcat "階層" CG_SeriesCode)
      (list (list "階層名称2" #HINname 'STR))
  	)
	)
	(if (and #QLY$ (= (length #QLY$) 1)
					 (nth 2 (car #QLY$))
					 (/= "" (nth 2 (car #QLY$))))
		(progn
			(setq #newHINname (nth 2 (car #QLY$))) ; 変換後の品番
		  ;// 拡張データの更新
		  (CFSetXData #sym "G_FILR"
		    (CFModList #xd$_FILR
		      (list (list 0 #newHINname))
		    )
		  )
		)
		(progn ; 変換後の品番が求まらない
			(setq #newHINname #HINname) ; 元のまま
			(princ (strcat "\n品番\"" #HINname "\"は未変更です。"))
			(setq NG$ (append NG$ (list #HINname)))
		)
	);_if

;;;＜"G_OPT"＞
;;; 1. ｵﾌﾟｼｮﾝ品番の種類数
;;; 2. OP品番名称
;;; 3. 個数
;;; 以下1.種類数回2.3.を繰り返す

	; ｵﾌﾟｼｮﾝ品があれば変換する
	(if #xd$_OPT
		(progn
			(setq #Set$ (KPChSeriG_OPT #xd$_OPT))
		  ;// 拡張データの更新
		  (CFSetXData #sym "G_OPT" #Set$)
		)
	);_if

	#sym
);KPChSeriFILR

;;;<HOM>***********************************************************************
;;; <関数名>    : KPChSeriHin
;;; <処理概要>  : ｷｬﾋﾞのG_SYM,G_LSYMをNotil or Genic 品番にする
;;; <戻り値>    : ｼﾝﾎﾞﾙ図形
;;; <作成>      : 01/04/03 YM
;;; <備考>      : 01/04/11 YM 階層??を参照する G_OPTも変換する
;;;***********************************************************************>MOH<
(defun KPChSeriHin (
	&sym
	&Ch_Seri
  /
  #HINNAME #LR #NEWHINNAME #QLY$$ #SYM #XD$_LSYM #XD$_SYM #series #SKK
	#HINKOSU #I #KOSU #SET$ #XD$_OPT #XD$_KUTAI
  )
		;///////////////////////////////////////////////////////////////////////////
		; 01/12/12 YM ADD 階層TB検索結果のうち上位階層ID<0のものを除く
		;///////////////////////////////////////////////////////////////////////////
		(defun ##DelRec (
			&Rec$$
		  /
			#RET
		  )
			(setq #ret nil) ; 戻り値
			(if &Rec$$
				(foreach #Rec$ &Rec$$
;;;01/12/26YM@MOD					(if (< (nth 1 #Rec$) 0) ; 上位階層ID<0
					(if (or (> (nth 1 #Rec$) 9000)(< (nth 1 #Rec$) 0)) ; 上位階層ID<0 or >9000
						nil
						(setq #ret (append #ret (list #Rec$)))
					);_if
				)
				(setq #ret nil)
			);_if
			#ret
		)
		;///////////////////////////////////////////////////////////////////////////

	(setq #sym &sym)
	(setq #xd$_KUTAI(CFGetXData #sym "G_KUTAI")); 拡張ﾃﾞｰﾀ"G_KUTAI"取得
	(if #xd$_KUTAI
		nil
		(progn ; 躯体は無視 01/05/10 YM ADD

			(if (= &Ch_Seri "GN")(setq #series "N" ))
			(if (= &Ch_Seri "NG")(setq #series "SG"))

			(setq #xd$_OPT  (CFGetXData #sym "G_OPT"))  ; 拡張ﾃﾞｰﾀ"G_OPT"取得
			(setq #xd$_SYM  (CFGetXData #sym "G_SYM"))  ; 拡張ﾃﾞｰﾀ"G_SYM" 取得
		;;;	(setq #SYMname (nth 0 #xd$_SYM)) ; ｼﾝﾎﾞﾙ名称
			(setq #xd$_LSYM (CFGetXData #sym "G_LSYM")) ; 拡張ﾃﾞｰﾀ"G_LSYM"取得
			(setq #HINname (nth 5 #xd$_LSYM)) ; 品番名称
		;;;	(setq #LR      (nth 6 #xd$_LSYM)) ; LR区分
			(setq #SKK     (nth 9 #xd$_LSYM)) ; 性格ｺｰﾄﾞ

		  (setq #QLY$$
		    (CFGetDBSQLRec CG_DBSESSION (strcat "階層" CG_SeriesCode)
		      (list (list "階層名称2" #HINname 'STR))
		  	)
			)
			; 01/12/12 YM ADD-S
			; #QLY$$が複数の場合上位階層ID<0は除く
			(setq #QLY$$ (##DelRec #QLY$$))
			; 01/12/12 YM ADD-E

			(if (and #QLY$$ (= (length #QLY$$) 1)
							 (nth 2 (car #QLY$$))
							 (/= "" (nth 2 (car #QLY$$))))
				(progn
					(setq #newHINname (nth 2 (car #QLY$$))) ; 変換後の品番
				  ;// 拡張データの更新
				  (CFSetXData #sym "G_LSYM"
				    (CFModList #xd$_LSYM
				      (list
								(list 4 #series)
								(list 5 #newHINname)
							)
				    )
				  )
				)
				(progn ; 変換後の品番が求まらない
					(setq #newHINname #HINname) ; 元のまま
					(if (equal #SKK CG_SKK_INT_SNK) ; ｼﾝｸなら ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
						(progn ; ｼﾝｸはｼﾘｰｽﾞ記号だけ更新する
						  ;// 拡張データの更新
						  (CFSetXData #sym "G_LSYM"
						    (CFModList #xd$_LSYM
						      (list	(list 4 #series))
						    )
						  )
						)
						(progn
							(princ (strcat "\n品番\"" #HINname "\"は未変更です。"))
							(setq NG$ (append NG$ (list #HINname)))
						)
					);_if
				)
			);_if

		;;;＜"G_OPT"＞
		;;; 1. ｵﾌﾟｼｮﾝ品番の種類数
		;;; 2. OP品番名称
		;;; 3. 個数
		;;; 以下1.種類数回2.3.を繰り返す

			; ｵﾌﾟｼｮﾝ品があれば変換する
			(if #xd$_OPT
				(progn
					(setq #Set$ (KPChSeriG_OPT #xd$_OPT))
				  ;// 拡張データの更新
				  (CFSetXData #sym "G_OPT" #Set$)
				)
			);_if

		)
	);_if
	(princ)
);KPChSeriHin

;;;<HOM>***********************************************************************
;;; <関数名>    : KPChSeriWT
;;; <処理概要>  : WTのｼﾘｰｽﾞ,材質をNotilに変更する
;;; <戻り値>    : WT図形
;;; <作成>      : 01/04/03 YM
;;; <備考>      : Genic==>Notilのみ可能
;;;***********************************************************************>MOH<
(defun KPChSeriWT (
	&WT
	&Ch_Seri
  /
  #DLOG$ #NWT_PRI #SERIES #SWT_ID #WT #WTSET$ #XD$_WT #XD$_WTSET #ZAICODE #ZAIF
#QRY$
  )
	(setq #WT &WT)
  (PCW_ChColWT #WT "MAGENTA" nil) ; 01/07/06 YM ADD
	(setq #xd$_WT    (CFGetXData #WT "G_WRKT"))
	(setq #xd$_WTSET (CFGetXData #WT "G_WTSET"))

	(setq #series  (nth 1 #xd$_WT)) ; ｼﾘｰｽﾞ
	(setq #ZaiCode (nth 2 #xd$_WT)) ; 材質記号

  (setq #qry$
	  (CFGetDBSQLRec CG_DBSESSION "WT材質"
	    (list (list "材質記号" #ZaiCode 'STR))
	  )
	)

	(if (and #qry$ (= (length #qry$) 1))
		(setq #ZaiF (nth 4 (car #qry$))) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
		(setq #ZaiF 0) ; DBになかったら人大扱い
	);_if

	(if (= &Ch_Seri "GN")
		(if (= #series "SG")(setq #series "N"))
	);_if

	(if (= &Ch_Seri "NG")
		(if (= #series "N")(setq #series "SG"))
	);_if

  ;// 材質記号の選択(ﾀﾞｲｱﾛｸﾞの表示)
	(if (equal #ZaiF 1 0.1)
		nil ; ｽﾃﾝﾚｽはそのまま
		(progn
  		(setq #ZaiCode (PKW_ZaiDlg nil)) ; #ZAI0
			; ｷｬﾝｾﾙ対応 01/07/23 YM ADD
			(if (= nil #ZaiCode)
				(progn
					(princ"\nｺﾏﾝﾄﾞをｷｬﾝｾﾙしました。") ; ｷｬﾝｾﾙ時 01/07/23 YM
					(*error*)
				)
			);_if
		)
	);_if

  (CFSetXData #WT "G_WRKT"
    (CFModList #xd$_WT
      (list
				(list 1 #series)
				(list 2 #ZaiCode)
			)
    )
  )

	; 品番確定されていたら
	(if #xd$_WTSET
		(progn
			(setq #xd$_WT (CFGetXData #WT "G_WRKT"))
			; ﾀﾞｲｱﾛｸﾞ表示 品番,価格を入力
		  (setq #DLOG$
;;; 				(KPW_GetWorkTopInfoDlg
				(KPW_GetWorkTopInfoDlg_ChSeri ; 01/04/05 YM
					#xd$_WT
					(nth 1 #xd$_WTSET)
					(fix (+ (nth 3 #xd$_WTSET) 0.001))
				) ; G_WRKT,品番,価格
			)
		  (if (= 'LIST (type #DLOG$))
		    (progn
		      (setq #sWT_ID (car #DLOG$))           ; 品番文字列

					; 全角ｽﾍﾟｰｽを半角ｽﾍﾟｰｽに置きかえる 01/06/27 YM ADD
					(setq #sWT_ID (vl-string-subst "  " "　" #sWT_ID)) ; ﾕｰｻﾞｰ入力品番

		      (setq #nWT_PRI (float (cadr #DLOG$))) ; 価格結果実数
		    )
				(progn
					(princ"\nｺﾏﾝﾄﾞをｷｬﾝｾﾙしました。") ; ｷｬﾝｾﾙ時 01/07/23 YM
		    ; ﾘｽﾄが取れなかった場合、ｷｬﾝｾﾙされたと判断。quit
		    	(*error*) ; ｷｬﾝｾﾙ時 01/07/23 YM
				)
		  );_if

		  (CFSetXData #WT "G_WTSET"
		    (CFModList #xd$_WTSET
		      (list
						(list 1 #sWT_ID)
						(list 3 #nWT_PRI)
					)
		    )
		  )
		)
	);_if

  ; ワークトップの色を確定色に変える ; 01/07/06 YM ADD
  (if #xd$_WTSET
  	(command "_.change" #WT "" "P" "C" CG_WorkTopCol "")
		(command "_.change" #WT "" "P" "C" "BYLAYER" "")
	);_if
	#WT
);KPChSeriWT

;;;01/04/11YM@;;;<HOM>***********************************************************************
;;;01/04/11YM@;;; <関数名>    : KPChSeriHin
;;;01/04/11YM@;;; <処理概要>  : ｷｬﾋﾞのG_SYM,G_LSYMをNotil品番にする
;;;01/04/11YM@;;; <戻り値>    : ｼﾝﾎﾞﾙ図形
;;;01/04/11YM@;;; <作成>      : 01/04/03 YM
;;;01/04/11YM@;;; <備考>      : Genic==>Notilのみ可能
;;;01/04/11YM@;;;***********************************************************************>MOH<
;;;01/04/11YM@(defun KPChSeriHin (
;;;01/04/11YM@	&sym
;;;01/04/11YM@	&Ch_Seri
;;;01/04/11YM@  /
;;;01/04/11YM@  #HINNAME #SYM #SYMNAME #XD$_LSYM #XD$_SYM
;;;01/04/11YM@  )
;;;01/04/11YM@
;;;01/04/11YM@;;; CG_SeriesCode
;;;01/04/11YM@
;;;01/04/11YM@		;///////////////////////////////////////////////////////////////////
;;;01/04/11YM@		(defun ##HINBANGtoN (	&HIN / )
;;;01/04/11YM@			(setq &HIN (strcat "N" (substr &HIN 2 (1- (strlen &HIN)))))
;;;01/04/11YM@		)
;;;01/04/11YM@		;///////////////////////////////////////////////////////////////////
;;;01/04/11YM@		(defun ##HINBANNtoG (	&HIN / )
;;;01/04/11YM@			(setq &HIN (strcat "G" (substr &HIN 2 (1- (strlen &HIN)))))
;;;01/04/11YM@		)
;;;01/04/11YM@		;///////////////////////////////////////////////////////////////////
;;;01/04/11YM@
;;;01/04/11YM@	(setq #sym &sym)
;;;01/04/11YM@	(setq #xd$_LSYM (CFGetXData #sym "G_LSYM")) ; 拡張ﾃﾞｰﾀ"G_LSYM"取得
;;;01/04/11YM@	(setq #HINname (nth 5 #xd$_LSYM)) ; 品番名称
;;;01/04/11YM@
;;;01/04/11YM@	(if (= &Ch_Seri "GN")
;;;01/04/11YM@		(progn
;;;01/04/11YM@			; 品番先頭を"G"==>"N"
;;;01/04/11YM@			(if (= (substr #HINname 1 1) "G")
;;;01/04/11YM@				(setq #HINname (##HINBANGtoN #HINname))
;;;01/04/11YM@			);_if
;;;01/04/11YM@			(setq #xd$_SYM  (CFGetXData #sym "G_SYM"))  ; 拡張ﾃﾞｰﾀ"G_SYM" 取得
;;;01/04/11YM@			(setq #SYMname (nth 0 #xd$_SYM)) ; ｼﾝﾎﾞﾙ名称
;;;01/04/11YM@			; 品番先頭を"G"==>"N"
;;;01/04/11YM@			(if (= (substr #SYMname 1 1) "G")
;;;01/04/11YM@				(setq #SYMname (##HINBANGtoN #SYMname))
;;;01/04/11YM@			);_if
;;;01/04/11YM@		)
;;;01/04/11YM@	);_if
;;;01/04/11YM@
;;;01/04/11YM@	(if (= &Ch_Seri "NG")
;;;01/04/11YM@		(progn
;;;01/04/11YM@			; 品番先頭を"N"==>"G"
;;;01/04/11YM@			(if (= (substr #HINname 1 1) "N")
;;;01/04/11YM@				(setq #HINname (##HINBANNtoG #HINname))
;;;01/04/11YM@			);_if
;;;01/04/11YM@			(setq #xd$_SYM  (CFGetXData #sym "G_SYM"))  ; 拡張ﾃﾞｰﾀ"G_SYM" 取得
;;;01/04/11YM@			(setq #SYMname (nth 0 #xd$_SYM)) ; ｼﾝﾎﾞﾙ名称
;;;01/04/11YM@			; 品番先頭を"N"==>"G"
;;;01/04/11YM@			(if (= (substr #SYMname 1 1) "N")
;;;01/04/11YM@				(setq #SYMname (##HINBANNtoG #SYMname))
;;;01/04/11YM@			);_if
;;;01/04/11YM@		)
;;;01/04/11YM@	);_if
;;;01/04/11YM@
;;;01/04/11YM@  ;// 拡張データの更新
;;;01/04/11YM@  (CFSetXData #sym "G_LSYM"
;;;01/04/11YM@    (CFModList #xd$_LSYM
;;;01/04/11YM@      (list (list 5 #HINname))
;;;01/04/11YM@    )
;;;01/04/11YM@  )
;;;01/04/11YM@  (CFSetXData #sym "G_SYM"
;;;01/04/11YM@    (CFModList #xd$_SYM
;;;01/04/11YM@      (list (list 0 #SYMname))
;;;01/04/11YM@    )
;;;01/04/11YM@  )
;;;01/04/11YM@	#sym
;;;01/04/11YM@);KPChSeriHin

;;;01/04/25YM@;;;<HOM>*************************************************************************
;;;01/04/25YM@;;; <関数名>    : C:KP_WrBlock
;;;01/04/25YM@;;; <処理概要>  : ﾀﾞｲﾆﾝｸﾞﾌﾟﾗﾝのﾌﾞﾛｯｸを保存する
;;;01/04/25YM@;;; <引数>      :
;;;01/04/25YM@;;; <戻り値>    :
;;;01/04/25YM@;;; <作成>      : 01/04/25 YM
;;;01/04/25YM@;;; <備考>      :
;;;01/04/25YM@;;;*************************************************************************>MOH<
;;;01/04/25YM@(defun C:KP_WrBlock (
;;;01/04/25YM@	/
;;;01/04/25YM@	#BASE #I #P1 #P2 #SFNAME #SS #SSSYM #SYM
;;;01/04/25YM@	)
;;;01/04/25YM@
;;;01/04/25YM@  (StartUndoErr);// コマンドの初期化
;;;01/04/25YM@;;;  (CFCmdDefBegin 6)
;;;01/04/25YM@;;;  (CFNoSnapReset)
;;;01/04/25YM@
;;;01/04/25YM@	(command "vpoint" "0,0,1"); 視点を真上から
;;;01/04/25YM@  (setq #p1 (getpoint  "\n一点目を指示: "))
;;;01/04/25YM@  (setq #p2 (getcorner #p1 "\n二点目を指示: "))
;;;01/04/25YM@  (setq #ssSYM (ssget "C" #p1 #p2 '((-3 ("G_LSYM"))))) ; 窓選択
;;;01/04/25YM@	(command "zoom" "p") ; 視点を戻す
;;;01/04/25YM@  (setq #base (getpoint  "\n挿入基点を指示: "))
;;;01/04/25YM@
;;;01/04/25YM@	(if (and #ssSYM (> (sslength #ssSYM) 0))
;;;01/04/25YM@		(progn
;;;01/04/25YM@			(setq #i 0 #ss$ nil)
;;;01/04/25YM@			(repeat (sslength #ssSYM)
;;;01/04/25YM@				(setq #sym (ssname #ssSYM #i))
;;;01/04/25YM@;;;        (GroupInSolidChgCol2 #sym CG_InfoSymCol) ; 色を変える
;;;01/04/25YM@				(setq #ss (CFGetSameGroupSS #sym)); 同一ｸﾞﾙｰﾌﾟ内の全図形選択ｾｯﾄ
;;;01/04/25YM@				(setq #ss$ (append #ss$ (list #ss)))
;;;01/04/25YM@				(setq #i (1+ #i))
;;;01/04/25YM@			)
;;;01/04/25YM@		)
;;;01/04/25YM@	);_if
;;;01/04/25YM@
;;;01/04/25YM@	; 選択ｾｯﾄのﾘｽﾄ==>選択ｾｯﾄ
;;;01/04/25YM@	(setq #ssALL (ssadd))
;;;01/04/25YM@	(foreach #ss #ss$
;;;01/04/25YM@		(setq #i 0)
;;;01/04/25YM@		(repeat (sslength #ss)
;;;01/04/25YM@			(setq #elm (ssname #ss #i))
;;;01/04/25YM@			(ssadd #elm #ssALL)
;;;01/04/25YM@			(setq #i (1+ #i))
;;;01/04/25YM@		)
;;;01/04/25YM@	)
;;;01/04/25YM@
;;;01/04/25YM@
;;;01/04/25YM@	; ﾌｧｲﾙ指定
;;;01/04/25YM@	(setq #sFname (getfiled "ブロック保存" (strcat CG_SYSPATH "tmp\\") "dwg" 1))
;;;01/04/25YM@	(if (and #sFname #base #ssALL (> (sslength #ssALL) 0))
;;;01/04/25YM@		(progn
;;;01/04/25YM@			; ﾌﾞﾛｯｸ保存
;;;01/04/25YM@			(setvar "FILEDIA" 0)
;;;01/04/25YM@			(command "._wblock" #sFname "" #base #ssALL "")
;;;01/04/25YM@			(command "._oops") ; 図形復活
;;;01/04/25YM@		)
;;;01/04/25YM@		(progn
;;;01/04/25YM@			(CFAlertMsg "\nブロックの保存に失敗しました。")
;;;01/04/25YM@			(quit)
;;;01/04/25YM@		)
;;;01/04/25YM@	);_if
;;;01/04/25YM@
;;;01/04/25YM@  ;// Ｏスナップ関連システム変数の解除
;;;01/04/25YM@;;;  (CFNoSnapStart)
;;;01/04/25YM@  (setq *error* nil)
;;;01/04/25YM@;;;  (CFCmdDefFinish)
;;;01/04/25YM@	(princ "\nブロックを定義しました。")
;;;01/04/25YM@);C:KP_WrBlock

;;;<HOM>*************************************************************************
;;; <関数名>    : c:clear
;;; <処理概要>  : 図面ｸﾘｱｰｺﾏﾝﾄﾞ(初期図面状態に戻す)
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 01/05/15 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun c:clear (
	/
	#I #SS #SS0 #SSALL #MSG #SSROOM
	)
  (StartUndoErr);// コマンドの初期化

;;;	(setq #msg "図面をクリアーしますか？")
;;;  (if (CFYesNoDialog #msg)
;;;		(progn

			(setvar "CLAYER" "0") ; 現在画層"0"
			(C:ALP);全画層表示
		  (setq #ssROOM (ssget "X" '((-3 ("G_ROOM"))))) ; 残したい
			(setq #ssALL (ssget "X")) ; 全図形
			(setq #i 0)
			(repeat (sslength #ssROOM)
				(ssdel (ssname #ssROOM #i) #ssALL)
				(setq #i (1+ #i))
			)
			(command "_.erase" #ssALL "") ; 図形削除
			; ﾌﾞﾛｯｸﾊﾟｰｼﾞ
			(command "_purge" "A" "*" "N")

		  (if (not (tblsearch "LAYER" "N_SYMBOL"))
		    (command "_layer" "N" "N_SYMBOL" "C" 4 "N_SYMBOL" "L" SKW_AUTO_LAY_LINE "N_SYMBOL" "")
		  );_if
		  (if (not (tblsearch "LAYER" "N_BREAKW"))
		    (command "_layer" "N" "N_BREAKW" "C" -6 "N_BREAKW" "L" SKW_AUTO_LAY_LINE "N_BREAKW" "")
		  );_if
		  (if (not (tblsearch "LAYER" "N_BREAKD"))
		    (command "_layer" "N" "N_BREAKD" "C" -6 "N_BREAKD" "L" SKW_AUTO_LAY_LINE "N_BREAKD" "")
		  );_if
		  (if (not (tblsearch "LAYER" "N_BREAKH"))
		    (command "_layer" "N" "N_BREAKH" "C" -6 "N_BREAKH" "L" SKW_AUTO_LAY_LINE "N_BREAKH" "")
		  );_if
		  (if (not (tblsearch "LAYER" "Z_KUTAI"))
		    (command "_layer" "N" "Z_KUTAI" "C" 55 "Z_KUTAI" "L" SKW_AUTO_LAY_LINE "Z_KUTAI" "")
		  );_if

			(CFSetXRecord "BASESYM" nil) ; 基準ｱｲﾃﾑのｸﾘｱｰ 01/05/16 YM ADD

;;;  (setq #APPname$ '())
;;;  (setq #APPdata (tblnext "APPID" T))
;;;  (while #APPdata
;;;    (setq #APPname$ (append #APPname$ (list (cdr (assoc 2 #APPdata)))))
;;;    (setq #APPdata (tblnext "APPID" nil))
;;;  )
;;;	; "ACAD","G_ARW","G_LSYM","G_ROOM"以外のｱﾌﾟﾘｹｰｼｮﾝ名は不要

;;;		)
;;;		(*error*)
;;;  );_if

  (command "pdmode" "0")
  (setq *error* nil)
	(princ)
);c:clear

;;;<HOM>*************************************************************************
;;; <関数名>    : C:CabHide
;;; <処理概要>  : 選択ｷｬﾋﾞﾈｯﾄを非表示にする
;;; <戻り値>    : なし
;;; <作成>      : 01/01/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:CabHide (
  /
	#ELM #I #LAY #SS #SSSELECT #SYM$
	#LAYERDATA #LAYERNAME$ #EED #EG$
  )
	; 前処理
	(StartUndoErr)
  (CFCmdDefBegin 6)

;;;01/06/01YM@  ;現在使用中の画層一覧を取得
;;;01/06/01YM@  ;ﾌﾘｰｽﾞor非表示状態の画層は省く
;;;01/06/01YM@  (setq #layername$ '())
;;;01/06/01YM@  (setq #layerdata (tblnext "LAYER" T))
;;;01/06/01YM@  (while #layerdata
;;;01/06/01YM@    (if (and (=  (cdr (assoc 70 #layerdata)) 0) ;画層がﾌﾘｰｽﾞではなく
;;;01/06/01YM@             (>= (cdr (assoc 62 #layerdata)) 0));非表示でもない
;;;01/06/01YM@      (setq #layername$ (append #layername$ (list (cdr (assoc 2 #layerdata)))))
;;;01/06/01YM@    )
;;;01/06/01YM@    (setq #layerdata (tblnext "LAYER" nil))
;;;01/06/01YM@  )

	;;; 選択ｷｬﾋﾞのみ赤色にする
;;;	(setq #ssSELECT (ItemSelKEKOMI '(("DUMMY")("G_LSYM")) CG_InfoSymCol '("?" "?" "?")))
	(setq #ss (ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_InfoSymCol))
	; 色を戻す
;;;	(setq #sym$ (cadr (ChangeItemColorKEKOMI #ssSELECT nil '("?" "?" "?"))))
  (ChangeItemColor #ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil)

;;;  (setvar "PICKAUTO" 1) ; 1:窓表示
;;;  (setvar "PICKSTYLE" 0) ; ｸﾞﾙｰﾌﾟも選択

	(if (= (tblsearch "APPID" "G_HIDELAY") nil) (regapp "G_HIDELAY"))

  ; 非表示用画層の作成
  (if (= nil (tblsearch "LAYER" SKW_TMP_HIDE))
    (command "_.layer" "N" "HIDE" "F" "HIDE" "")
  )
	(if (and #ss (> (sslength #ss) 0))
		(progn
			(princ "\n非表示中 ... \n")
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #eg$ (entget (ssname #ss #i)))
				(setq #lay (cdr (assoc 8 #eg$)))
	      (setq #eed (list "G_HIDELAY" (cons 1000 #lay)))
;;;				(if (member #lay #layername$);ｵﾌﾞｼﾞｪｸﾄ画層が現在使用中
;;;					(progn
			      (entmod
							(append
								(subst (cons 8 SKW_TMP_HIDE) (cons 8 #lay) #eg$) ; 画層変更
								(list (list -3 #eed))
							)
						)
;;;					)
;;;				);_if
				(setq #i (1+ #i))
			)
		)
		(princ "\n非表示にする部材はありません。\n")
	);_if

	; 後処理
  (setq *error* nil)
  (CFCmdDefFinish)
	(princ)
);C:CabHide

;;;<HOM>*************************************************************************
;;; <関数名>    : C:CabShow
;;; <処理概要>  : 選択ｷｬﾋﾞﾈｯﾄを非表示にする
;;; <戻り値>    : なし
;;; <作成>      : 01/01/12 YM
;;; <備考>      : 01/09/03 YM 主要部分関数化
;                 別の場所からundo処理を含まない部分をcallできるようにした
;;;*************************************************************************>MOH<
(defun C:CabShow (
  /
  )
	; 前処理
	(StartUndoErr)

	(CabShow_sub) ; 01/09/03 YM MOD 関数化

	; 後処理
  (setq *error* nil)
	(princ)
);C:CabShow

;;;<HOM>*************************************************************************
;;; <関数名>    : CabShow_sub
;;; <処理概要>  : 選択ｷｬﾋﾞﾈｯﾄを非表示にする
;;; <戻り値>    : なし
;;; <作成>      : 01/09/03 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun CabShow_sub (
  /
	#EG$ #I #LAY #SS #EG #HAND #HAND$ #J #SHAND
  )
	(setq #ss (ssget "X" '((8 . "HIDE"))))
	(if (and #ss (> (sslength #ss) 0))
		(progn
			(princ "\n表示中 ... \n")
			(setq #i 0)
			(setq #hand$ nil)
			(repeat (sslength #ss)
				(setq #eg$ (entget (ssname #ss #i)))
				(if (setq #lay (CFGetXData (ssname #ss #i) "G_HIDELAY")) ; nilの場合対応 01/08/24 YM ADD
					(progn
						(setq #lay (car #lay))
						(entmod (subst (cons 8 #lay) (assoc 8 #eg$) #eg$)) ; 画層を元に戻す
						; 拡張ﾃﾞｰﾀを削除
		        (CFSetXData (ssname #ss #i) "G_HIDELAY" nil)
					)
					(progn
						(setq #hand (cdr (assoc 5 (entget (ssname #ss #i))))) ; 図形ﾊﾝﾄﾞﾙ
						(setq #hand$ (append #hand$ (list #hand)))
					)
				);_if

				(setq #i (1+ #i))
			);repeat

			(if #hand$
				(progn
					(setq #sHAND "")
					(setq #j 0)
					(foreach hand #hand$
						(if (= #j 0)
							(setq #sHAND (strcat #sHAND hand))
							(setq #sHAND (strcat #sHAND "," hand))
						);_if
						(setq #j (1+ #j))
					)
					(princ (strcat "\n次の図形は元の画層が不明です。現在の画層は\"HIDE\"です。\n" #sHAND)) ; 01/11/28 YM MOD
;;;01/11/28YM@MDO					(CFAlertMsg (strcat "次の図形は元の画層が不明です。現在の画層は\"HIDE\"です。\n" #sHAND))
				)
			);_if

		)
		(princ "\n非表示のキャビネットはありません。\n")
	);_if

	(princ)
);CabShow_sub

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KP_TOKUCabShow
;;; <処理概要>  : 特注キャビに色をつけて表示する
;;; <戻り値>    : なし
;;; <作成>      : 01/09/26 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KP_TOKUCabShow (
  /
	#ELM #I #SS #SYM
  )
	; 前処理
	(StartUndoErr)

	(setq #ss (ssget "X" '((-3 ("G_TOKU")))))
	(if (and #ss (< 0 (sslength #ss)))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #sym (ssname #ss #i))
				(GroupInSolidChgCol2 #sym "Yellow") ; 赤,青,水色以外
				(setq #i (1+ #i))
			)
		)
		(progn
			(CFAlertMsg "図面上に特注キャビネットは存在しません。")
		)
	);_if

	; 後処理
  (setq *error* nil)
	(princ)
);C:KP_TOKUCabShow

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KP_TOKUCabHide
;;; <処理概要>  : 特注キャビの色を元に戻す
;;; <戻り値>    : なし
;;; <作成>      : 01/09/26 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KP_TOKUCabHide (
  /
	#I #SS #SYM
  )
	; 前処理
	(StartUndoErr)

	(setq #ss (ssget "X" '((-3 ("G_TOKU")))))
	(if (and #ss (< 0 (sslength #ss)))
		(progn
			(setq CG_BASESYM (CFGetBaseSymXRec)) ; 基準ｱｲﾃﾑ
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #sym (ssname #ss #i))
				; 色を戻す
				(if (equal CG_BASESYM #sym) ;基準ｱｲﾃﾑ
				  (GroupInSolidChgCol #sym CG_BaseSymCol)
				  (GroupInSolidChgCol2 #sym "BYLAYER")
				);_if
				(setq #i (1+ #i))
			)
		)
		(progn
			(CFAlertMsg "図面上に特注キャビネットは存在しません。")
		)
	);_if

	; 後処理
  (setq *error* nil)
	(princ)
);C:KP_TOKUCabHide

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KP_ChLogo
;;; <処理概要>  : 出力図面のロゴを入れ替える
;;; <戻り値>    : なし
;;; <作成>      : 01/09/27 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KP_ChLogo (
  /
	#P1 #P2 #POS #SFNAME #SS #ANG #SCLX #SCLY #DEFSCLX #DEFSCLY #OS #OT #SM #PS
	#EN #I #SS0 #SS1 #SSP
  )
	; 前処理
	(StartUndoErr)
	; ｼｽﾃﾑ変数設定
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"    1)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
;;;	(command "_zoom" "e")

  ;// グループ選択モードにしてグループ全体を取得する
  (setq #ps (getvar "PICKSTYLE"))
  (setvar "PICKSTYLE" 3)

	; ﾛｺﾞ削除範囲
	(princ "\nロゴ枠を四角で囲って下さい")
	(setq #p1 (getpoint))
	(setq #p2 (getcorner #p1))

	; #p1,#p2を互いに5mm近づける(ﾛｺﾞ枠を消さないため)
	(setq #p1 (polar #p1 (angle #p1 #p2) 5))
	(setq #p2 (polar #p2 (angle #p2 #p1) 5))
  (setvar "OSMODE"    0)
;;;	(command "rectang" #p1 #p2)

	; ﾛｺﾞ挿入点
;;;	(setq #pos '( 720 450))
	(setq #ang 0.0)

	; ﾛｺﾞをｽﾞｰﾑする(ｽﾞｰﾑしないとﾛｺﾞ枠も消える)
	(command "_.zoom" "W" #p1 #p2)

	(princ "\nロゴを削除中...")

;;;	(setq #ss (ssget "C" #p1 #p2))

	; グループ選択で削除
	(command "_.erase" (ssget "C" #p1 #p2) "") ; 既存ﾛｺﾞの削除

	; ｽﾞｰﾑ前に戻る
	(command "_.zoom" "P")

	; ﾛｺﾞの選択
	(setq #sFname (getfiled "ロゴ図面の選択" (strcat CG_SYSPATH "TEMPLATE\\LOGO\\") "dwg" 8))

	(if (= nil #sFname)(quit)) ; 01/10/15 YM

	; 尺度を入力
	(setq #defSCLX "1.0") ; ﾃﾞﾌｫﾙﾄｽｹｰﾙ
	(setq #defSCLY "1.0") ; ﾃﾞﾌｫﾙﾄｽｹｰﾙ

  (setq #sclX (getreal (strcat "\nX方向の倍率<" #defSCLX ">: ")))
	(if (= #sclX nil)
		(setq #sclX (atof #defSCLX))
	); if

  (setq #sclY (getreal (strcat "\nY方向の倍率<" #defSCLY ">: ")))
	(if (= #sclY nil)
		(setq #sclY (atof #defSCLY))
	); if

	(princ "\n挿入点を指示: ")
	(command "_.INSERT" #sFname PAUSE #sclX #sclY #ang)

  ;分解&グループ化
  (command "_explode" (entlast)) ;インサート図形分解
	(setq #ss0 (ssget "P"))
	(setq #i 0)
	(repeat (sslength #ss0)
		(setq #en (ssname #ss0 #i))
		(if (= "INSERT" (cdr (assoc 0 (entget #en))))
			(progn
			  (command "_explode" #en) ;インサート図形分解
				(setq #ss1 (ssget "P"))
			)
		);_if
		(setq #i (1+ #i))
	)

	(command "_purge" "bl" "*" "N")
	(command "_purge" "bl" "*" "N")

	; ss1,ss0を合わせる
  (setq #ssP (ssadd)) ; 空の選択セット
  (setq #ssP (CMN_ssaddss #ss0 #ss1)) ; 全選択セットを１つにまとめる.


	; 枠からはみでたﾛｺﾞを削除するときのためｸﾞﾙｰﾌﾟ化しておく
	; 01/10/12 YM ｸﾞﾙｰﾌﾟ化したら一部が白抜きになる
;;;01/10/12YM@DEL	(command "-group" "C" "LOGO" "LOGO" #ssP "")   ;分解した図形群でグループ化
;;;  (SKMkGroup #ss1)

	; 後処理
  (setq *error* nil)
	; ｼｽﾃﾑ変数設定を戻す
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)
  (setvar "PICKSTYLE" #ps)

	(princ)
);C:KP_ChLogo

;<HOM>*************************************************************************
; <関数名>    : C:KP_COPYCLIP
; <処理概要>  : COPYCLIPコマンド
; <戻り値>    : なし
; <作成>      : 02/02/01 YM
; <備考>      :
;*************************************************************************>MOH<
(defun C:SK_COPYCLIP(
  /
	#pickauto #PICKFIRST
  )
	; コマンドの初期化
  (StartUndoErr)
	(setq #PICKAUTO (getvar "PICKAUTO"))
	(setq #PICKFIRST (getvar "PICKFIRST"))
	(setvar "PICKAUTO" 1)
	(setvar "PICKFIRST" 1)

	(command "._COPYCLIP")

	(setvar "PICKAUTO" #pickauto)
	(setvar "PICKFIRST" #PICKFIRST)
  (setq *error* nil)
  (princ)
);C:SK_COPYCLIP

;<HOM>*************************************************************************
; <関数名>    : C:KP_PASTECLIP
; <処理概要>  : PASTECLIPコマンド
; <戻り値>    : なし
; <作成>      : 02/02/01 YM
; <備考>      :
;*************************************************************************>MOH<
(defun C:SK_PASTECLIP(
  /
	#pickauto #PICKFIRST
  )
	; コマンドの初期化
	(setq #PICKAUTO (getvar "PICKAUTO"))
	(setq #PICKFIRST (getvar "PICKFIRST"))
	(setvar "PICKAUTO" 1)
	(setvar "PICKFIRST" 1)

	(command "._PASTECLIP")

	(princ "\n貼り付けました.")
	(setvar "PICKAUTO" #pickauto)
	(setvar "PICKFIRST" #PICKFIRST)
  (setq *error* nil)
  (princ)
);C:SK_PASTECLIP

(princ)
