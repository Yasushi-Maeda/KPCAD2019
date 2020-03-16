;<HOM>*************************************************************************
; <関数名>    : C:StretchCabW
; <処理概要>  : 特注ｷｬﾋﾞｺﾏﾝﾄﾞ(ｳｯﾄﾞﾜﾝ)
; <戻り値>    : なし
; <作成>      : 
; <備考>      : 
;*************************************************************************>MOH<
(defun C:StretchCabW (
  /
	#cmdecho #osmode #pickstyle #sys$ #en #err_flag #sym #ss #bsym
	#err_flag #xd_LSYM$ #hinban #qry$$ #taisyo #taisyo_str #chk
  )

	;****************************************************
	; エラー処理
	;****************************************************
  (defun StretchCabWUndoErr( &msg )
    (command "_undo" "b")
    (CFCmdDefFinish)
    (setq *error* nil)
    (princ)
  )
	;****************************************************

 	;****************************************************
  ;	2018/03/13 YK ADD-STR　角度がおかしいときの対応
 (defun LsymRadChg(
    /
    #ss_LSYM #sym #i #xd$ #rad
;	  #basePT #baseX #baseY #baseZ
    )
	  (setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM")))))
    (if (and #ss_LSYM (< 0 (sslength #ss_LSYM)))
      (progn
		  	(setq #i 0)
		  	(repeat (sslength #ss_LSYM)
		  		(setq #sym (ssname #ss_LSYM #i))
		  		(setq #xd$ (CFGetXData #sym "G_LSYM"))
          (setq #rad  (nth 2 #xd$))     ; 配置角度

					;2018/09/05 YM MOD
;;;				  (if (equal #rad      0 0.0001) (setq #rad    0)) ;2018/08/30 YM これは有効だが、０以外も対応必要
				  (if (equal #rad      0 0.0001) (setq #rad  0.0)) ;2018/08/30 YM これは有効だが、０以外も対応必要
					;2018/09/05 YM MOD
					
          (CFSetXData #sym "G_LSYM"
            (CFModList #xd$
              (list
                (list 2 #rad)
              )
            )
          )
			  	(setq #i (+ #i 1)) 
  	  	)
	  	)
	  )
    (princ)
  );_(defun c:oya()
   (LsymRadChg)
	
  ;	2018/03/13 YK ADD-END　角度がおかしいときの対応
 	;****************************************************
	
  (setq *error* StretchCabWUndoErr)
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
	(setq CG_BASE_UPPER nil)
	(setq CG_POS_STR nil)
	(setq CG_TOKU T)
  (KP_TOKU_GROBAL_RESET)
	(setq #err_flag nil)
	(setq #taisyo_str "")

	(setq #en T)
	(while #en
		(setq #err_flag nil)
		(setq #sym nil)
		(setq #en (car (entsel "\n部材を選択 : ")))
		(if #en (setq #sym (CFSearchGroupSym #en)))
		(if (and #en (not #sym)) (CFAlertMsg "この部材は特注化できません"))
		(if #sym ; ｼﾝﾎﾞﾙが存在
			(cond
				((CFGetXData #sym "G_KUTAI")
					nil
				)
				(T
					(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
					(setq #hinban (nth 5 #xd_LSYM$))

					(setq #qry$$
						(CFGetDBSQLRec CG_DBSESSION "品番基本"
							(list
								(list "品番名称" #hinban 'STR)
							)
						)
					)

					(if (/= #qry$$ nil)
						(if (= (length #qry$$) 1)
							(setq #taisyo (nth 10 (nth 0 #qry$$)))
							(progn
								(CFAlertMsg "品番基本情報の取得に失敗しました。処理を終了します。")
								(setq #err_flag T)
							)
						)
						(progn
							(CFAlertMsg "品番基本情報の取得に失敗しました。処理を終了します。")
							(setq #err_flag T)
						)
					)

					(if (= #err_flag nil)
						(if (or (= #taisyo "X") (= #taisyo "") (= #taisyo nil))
							(progn
								(cond
									((= #taisyo "")
										(setq #taisyo_str "空白")
									)
									((= #taisyo nil)
										(setq #taisyo_str "空白")
									)
									(T
										(setq #taisyo_str "X")
									)
								)
								(CFAlertMsg "この部材は特注化できません")
								(princ (strcat "\n★★★★ 品番基本：品番名称 = " #hinban "  特注対象 = " #taisyo_str))
								(setq #err_flag T)
							)
						)
					)

;-- 2011/12/16 A.Satoh Add - S
					(if (= #err_flag nil)
						(progn
							; 選択した部材の特注化可否判定を行う
							(setq #chk (StretchCabW_CheckExec #sym #taisyo))
							(if (= #chk nil)
								(progn
									(CFAlertMsg "この部材はこれ以上特注化できません")
									(setq #err_flag T)
								)
							)
						)
					)
;-- 2011/12/16 A.Satoh Add - E

					(if (= #err_flag nil)
						(progn
							; 図形色を変更
							(setq #ss (CFGetSameGroupSS #sym))
							(command "_change" #ss "" "P" "C" CG_InfoSymCol "")

;-- 2012/02/23 A.Satoh Add - S
							; 陰線処理時に扉の伸縮が不正。
				      ; 強制的にワイヤフレーム表示に変更する。
							(C:2DWire)
;-- 2012/02/23 A.Satoh Add - E

							(if (= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3))
								; コーナーキャビである場合
								(StretchCabW_CNR_sub #sym #taisyo #chk)
								; コーナーキャビ以外である場合
								(StretchCabW_sub #sym #taisyo #chk)
							)

							;色を戻す
;-- 2012/02/15 A.Satoh Add - S
							(setq #ss (CFGetSameGroupSS #sym))
;-- 2012/02/15 A.Satoh Add - E
							(command "_change" #ss "" "P" "C" "BYLAYER" "")

							;基準ｱｲﾃﾑの場合は基準ｱｲﾃﾑ色にする。
							(if (and (setq #bsym (car (CFGetXRecord "BASESYM"))) (equal (handent #bsym) #sym))
								(progn
									(ResetBaseSym)
									(GroupInSolidChgCol #sym CG_BaseSymCol)
								)
							)

							(setq #en nil)
						)
					)
				)
			)
		)
	)

  (setq CG_TOKU nil)
  (setq CG_TOKU_BW nil)
  (setq CG_TOKU_BD nil)
  (setq CG_TOKU_BH nil)
	(setq CG_BASE_UPPER nil)
	(setq CG_POS_STR nil)
  (KP_TOKU_GROBAL_RESET)

	(CFCmdDefFinish)
	(PKEndCOMMAND #sys$)
	(setvar "CMDECHO" #cmdecho)
	(setvar "OSMODE" #osmode)
  (setvar "PICKSTYLE" #pickstyle)
	(setq *error* nil)

;  (alert "★★★　工事中　★★★")

  (princ)
);C:StretchCabW


;-- 2011/12/16 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : StretchCabW_CheckExec
; <処理概要>  : 選択した部材の特注化可否判定を行う
; <戻り値>    : T  : 特注化可能
;             : nil: 特注化不可
; <作成>      : 11/12/16 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_CheckExec (
	&en		; シンボル図形名
	&taisyo	; 特注対象
  /
;-- 2012/02/16 A.Satoh Mod CG対応 - S
;;;;;	#ret #W_f #D_f #H_f #xd_TOKU$ #xd_SYM$
	#ret #W_f #D_f #H_f #xd_TOKU$ #xd_REG$
;-- 2012/02/16 A.Satoh Mod CG対応 - E
  )

	(setq #ret nil)

	(if (= &taisyo "A")
		(progn
			(setq #W_f T)
			(setq #D_f T)
			(setq #H_f T)
		)
		(if (= (strlen &taisyo) 4)
			(progn
				(if (= (substr &taisyo 2 1) "W")
					(setq #W_f T)
					(setq #W_f nil)
				)
				(if (= (substr &taisyo 3 1) "D")
					(setq #D_f T)
					(setq #D_f nil)
				)
				(if (= (substr &taisyo 4 1) "H")
					(setq #H_f T)
					(setq #H_f nil)
				)
			)
			(progn
				(setq #W_f T)
				(setq #D_f T)
				(setq #H_f T)
			)
		)
	)

	(setq #xd_TOKU$ (CFGetXData &en "G_TOKU"))
	(if #xd_TOKU$
		(progn	; 特注情報(G_TOKU)が設定されている場合
;-- 2012/02/22 A.Satoh Mod - S
;;;;;			(if (and (= #W_f T) (not (equal (nth 4 #xd_TOKU$) (nth 12 #xd_TOKU$) 0.001)))
			(if (and (= #W_f T) (not (equal (nth 17 #xd_TOKU$) (nth 12 #xd_TOKU$) 0.001)))
;-- 2012/02/22 A.Satoh Add - E
				(setq #W_f nil)
			)
;-- 2012/02/22 A.Satoh Mod - S
;;;;;			(if (and (= #D_f T) (not (equal (nth 6 #xd_TOKU$) (nth 13 #xd_TOKU$) 0.001)))
			(if (and (= #D_f T) (not (equal (nth 18 #xd_TOKU$) (nth 13 #xd_TOKU$) 0.001)))
;-- 2012/02/22 A.Satoh Add - E
				(setq #D_f nil)
			)
;-- 2012/02/22 A.Satoh Mod - S
;;;;;			(if (and (= #H_f T) (not (equal (nth 5 #xd_TOKU$) (nth 14 #xd_TOKU$) 0.001)))
			(if (and (= #H_f T) (not (equal (nth 19 #xd_TOKU$) (nth 14 #xd_TOKU$) 0.001)))
;-- 2012/02/22 A.Satoh Add - E
				(setq #H_f nil)
			)
		)
		(progn	; 特注情報(G_TOKU)が設定されていない場合
;-- 2012/02/16 A.Satoh Mod - S
;;;;;			(setq #xd_SYM$ (CFGetXData &en "G_SYM"))
;;;;;			(if #xd_SYM$
;;;;;				(progn
;;;;;					(if (and (= #W_f T) (not (equal (nth 11 #xd_SYM$) 0.0 0.001)))
;;;;;						(setq #W_f nil)
;;;;;					)
;;;;;					(if (and (= #D_f T) (not (equal (nth 12 #xd_SYM$) 0.0 0.001)))
;;;;;						(setq #D_f nil)
;;;;;					)
;;;;;					(if (and (= #H_f T) (not (equal (nth 13 #xd_SYM$) 0.0 0.001)))
;;;;;						(setq #H_f nil)
;;;;;					)
;;;;;				)
;;;;;				(progn
;;;;;					(setq #W_f nil)
;;;;;					(setq #D_f nil)
;;;;;					(setq #H_f nil)
;;;;;				)
;;;;;			)
			(setq #xd_REG$ (CFGetXData &en "G_REG"))
			(if #xd_REG$
				(progn
;-- 2012/02/22 A.Satoh Mod - S
;;;;;					(if (and (= #W_f T) (not (equal (nth 4 #xd_REG$) (nth 12 #xd_REG$) 0.001)))
					(if (and (= #W_f T) (not (equal (nth 17 #xd_REG$) (nth 12 #xd_REG$) 0.001)))
;-- 2012/02/22 A.Satoh Mod - E
						(setq #W_f nil)
					)
;-- 2012/02/22 A.Satoh Mod - S
;;;;;					(if (and (= #D_f T) (not (equal (nth 6 #xd_REG$) (nth 13 #xd_REG$) 0.001)))
					(if (and (= #D_f T) (not (equal (nth 18 #xd_REG$) (nth 13 #xd_REG$) 0.001)))
;-- 2012/02/22 A.Satoh Mod - E
						(setq #D_f nil)
					)
;-- 2012/02/22 A.Satoh Mod - S
;;;;;					(if (and (= #H_f T) (not (equal (nth 5 #xd_REG$) (nth 14 #xd_REG$) 0.001)))
					(if (and (= #H_f T) (not (equal (nth 19 #xd_REG$) (nth 14 #xd_REG$) 0.001)))
;-- 2012/02/22 A.Satoh Mod - E
						(setq #H_f nil)
					)
				)
			)
;-- 2012/02/16 A.Satoh Mod - E
		)
	)

	(if (or (= #W_f T) (= #D_f T) (= #H_f T))
		(setq #ret (list #W_f #D_f #H_f))
		(setq #ret nil)
	)

	#ret

);StretchCabW_CheckExec
;-- 2011/12/16 A.Satoh Add - E


;-- 2012/02/15 A.Satoh Add CG対応 - S
;<HOM>*************************************************************************
; <関数名>    : InputGRegData
; <処理概要>  : 指定のシンボルに対して伸縮レギュラーキャビキャビ情報(G_REG)
;             : を設定する
; <戻り値>    : T:正常終了 nil キャンセル終了
; <作成>      : 12/02/15 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun InputGRegData (
  &sym				; 対象シンボル図形
	&org_size$	; 修正前サイズリスト (幅 奥行 高さ)
	&XLINE_W$
	&XLINE_D$
	&XLINE_H$
	&chk
	&cab_size$
	&flag       ; コーナーキャビ：T    コーナーキャビ以外：nil
  /
	#ret #err_flag #org_width #org_depth #org_height #hinban #hinban2 #lr #hin_last #hinban$
	#xd_REG$ #XLINE_W$ #XLINE_D$ #XLINE_H$ #xd_SYM$ #xd_LSYM$
	#maguti1 #maguti2 #maguti3 #oku1 #oku2 #oku3 #height1 #height2 #height3
;-- 2012/02/22 A.Satoh Mod - S
;;;;;#hin_last$ #hin_width #hin_depth #hin_takasa #width_diff #height_diff #depth_diff  ;-- 2012/02/21 A.Satoh Add
#hin_last$ #hin_width #hin_depth #hin_takasa
;-- 2012/02/22 A.Satoh Mod - S
#W_sabun #D_sabun #H_sabun #W_f #D_f #H_f  ;-- 2012/02/22 A.Satoh Add
#str_d #str_c    ;-- 2012/03/16 A.Satoh Add
#DOOR_INFO$ #DRCOLCODE #DRHIKITE #DRSERICODE #RET$ #SET_CG ;2013/08/05 YM ADD
  )

	(setq #ret T)
	(setq #err_flag nil)
	(setq #set_cg nil)
	(setq #org_width  (nth 0 &org_size$))
	(setq #org_depth  (nth 1 &org_size$))
	(setq #org_height (nth 2 &org_size$))
;-- 2012/02/22 A.Satoh Add - S
	(setq #W_sabun 0.0)
	(setq #D_sabun 0.0)
	(setq #H_sabun 0.0)

	(setq #W_f T)
	(setq #D_f T)
	(setq #H_f T)

	(if (= (nth 0 &chk) nil)
		(setq #W_f nil)
	)
	(if (= (nth 1 &chk) nil)
		(setq #D_f nil)
	)
	(if (= (nth 2 &chk) nil)
		(setq #H_f nil)
	)
;-- 2012/02/22 A.Satoh Add - E

	(setq #xd_REG$ (CFGetXData &sym "G_REG"))
	(if (= #xd_REG$ nil)
		(progn
			(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
			(if (= #xd_LSYM$ nil)
				(setq #err_flag T)
			)

			(if (= #err_flag nil)
				(progn
					(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
					(if (= #xd_SYM$ nil)
						(setq #err_flag T)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
					; 伸縮前後のシンボルサイズの差を取得
;-- 2012/02/22 A.Satoh Del - S
;;;;;;-- 2012/02/21 A.Satoh Add - S
;;;;;					(setq #width_diff  (- (nth 3 #xd_SYM$) #org_width))
;;;;;					(setq #depth_diff  (- (nth 4 #xd_SYM$) #org_depth))
;;;;;					(setq #height_diff (- (nth 5 #xd_SYM$) #org_height))
;;;;;;-- 2012/02/21 A.Satoh Add - E
;-- 2012/02/22 A.Satoh Del - E
					(setq #hinban (nth 5 #xd_LSYM$))
					(setq #lr     (nth 6 #xd_LSYM$))

					; 品番名称から括弧を除外
					(setq #hinban2 (KP_DelHinbanKakko #hinban))

					; 最終品番を取得
;-- 2012/02/21 A.Satoh Mod - S
;;;;;					(setq #hin_last (car (StretchCabW_GetHinbanLast #hinban2 #lr)))
;;;;;					(if (= #hin_last nil)
;;;;;						(setq #err_flag T)
;;;;;					)

					;2013/08/05 YM MOD-S
					(setq #Door_Info$     (nth 7 #xd_LSYM$))
					(setq #ret$ (StrParse #Door_Info$ ","))
					(setq #DRSeriCode (car   #ret$))(if (= #DRSeriCode nil)(setq #DRSeriCode ""))
					(setq #DRColCode  (cadr  #ret$))(if (= #DRColCode nil)(setq #DRColCode ""))
					(setq #DRHikite   (caddr #ret$))(if (= #DRHikite nil)(setq #DRHikite ""))

					(if (= #DRSeriCode "")
						(progn
							(setq #DRSeriCode CG_DRSeriCode)
							(setq #DRColCode  CG_DRColCode)
							(setq #DRHikite   CG_Hikite)
						)
					);_if

;;;					(setq #hin_last$ (StretchCabW_GetHinbanLast #hinban2 #lr))
					(setq #hin_last$ (StretchCabW_GetHinbanLast_HIKISU #hinban2 #lr #DRSeriCode #DRColCode #DRHikite))
					;2013/08/05 YM MOD-E


					(if (= #hin_last$ nil)
						(progn
							(setq #hin_last #hinban)
							(setq #hin_width  (nth 3 #xd_SYM$))
							(setq #hin_depth  (nth 4 #xd_SYM$))
							(setq #hin_takasa (nth 5 #xd_SYM$))
						)
						(progn
							(setq #hin_last (car #hin_last$))
;-- 2012/02/22 A.Satoh Mod - S
;;;;;							(setq #hin_width  (+ (atof (nth 1 #hin_last$)) #width_diff))
;;;;;							(setq #hin_takasa (+ (atof (nth 2 #hin_last$)) #height_diff))
;;;;;							(setq #hin_depth  (+ (atof (nth 3 #hin_last$)) #depth_diff))
							(if (= #W_f T)
								(setq #W_sabun (- (nth 3 #xd_SYM$) #org_width))
							)
							(if (= #D_f T)
								(setq #D_sabun (- (nth 4 #xd_SYM$) #org_depth))
							)
							(if (= #H_f T)
								(setq #H_sabun (-(nth 5 #xd_SYM$) #org_height ))
							)
							(setq #hin_width  (+ (atof (nth 1 #hin_last$)) #W_sabun))
							(setq #hin_takasa (+ (atof (nth 2 #hin_last$)) #H_sabun))
							(setq #hin_depth  (+ (atof (nth 3 #hin_last$)) #D_sabun))
;-- 2012/02/22 A.Satoh Mod - S
						)
					)
;-- 2012/02/21 A.Satoh Mod - E
				)
			)

			(if (= #err_flag nil)
				(setq #hinban$
					(list
						""										; 特注品番
						0.0										; 金額
						""										; 品名
						""										; 特注コード　特注コード-連番
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(nth 3 #xd_SYM$)			; 巾
;;;;;						(nth 5 #xd_SYM$)			; 高さ
;;;;;						(nth 4 #xd_SYM$)			; 奥行
						#hin_width						; 巾
						#hin_takasa						; 高さ
						#hin_depth						; 奥行
;-- 2012/02/21 A.Satoh Mod - E
					)
				)
			)
		)
		(progn
			(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
			(if (= #xd_LSYM$ nil)
				(setq #err_flag T)
			)

			(if (= #err_flag nil)
				(progn
					(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
					(if (= #xd_SYM$ nil)
						(setq #err_flag T)
					)
				)
			)

;-- 2012/02/22 A.Satoh Mod - S
;;;;;			(if (= #err_flag nil)
;;;;;				(setq #hinban$
;;;;;					(list
;;;;;						(nth 0 #xd_REG$)			; 特注品番
;;;;;						(nth 1 #xd_REG$)			; 金額
;;;;;						(nth 2 #xd_REG$)			; 品名
;;;;;						(nth 3 #xd_REG$)			; 特注コード
;;;;;;-- 2012/02/21 A.Satoh Mod - S
;;;;;;;;;;						(nth 3 #xd_SYM$)			; 巾
;;;;;;;;;;						(nth 5 #xd_SYM$)			; 高さ
;;;;;;;;;;						(nth 4 #xd_SYM$)			; 奥行
;;;;;						(nth 4 #xd_REG$)			; 巾
;;;;;						(nth 5 #xd_REG$)			; 高さ
;;;;;						(nth 6 #xd_REG$)			; 奥行
;;;;;;-- 2012/02/21 A.Satoh Mod - E
;;;;;					)
;;;;;				)
;;;;;			)
			(if (= #err_flag nil)
				(progn
					(if (= #W_f T)
						(setq #W_sabun (- (nth 3 #xd_SYM$) #org_width))
					)
					(if (= #D_f T)
						(setq #D_sabun (- (nth 4 #xd_SYM$) #org_depth))
					)
					(if (= #H_f T)
						(setq #H_sabun (- (nth 5 #xd_SYM$) #org_height ))
					)
					(setq #hin_width  (+ (nth 4 #xd_REG$) #W_sabun))
					(setq #hin_takasa (+ (nth 5 #xd_REG$) #H_sabun))
					(setq #hin_depth  (+ (nth 6 #xd_REG$) #D_sabun))

					(setq #hinban$
						(list
							(nth 0 #xd_REG$)			; 特注品番
							(nth 1 #xd_REG$)			; 金額
							(nth 2 #xd_REG$)			; 品名
							(nth 3 #xd_REG$)			; 特注コード
							#hin_width						; 巾
							#hin_takasa						; 高さ
							#hin_depth						; 奥行
						)
					)
				)
			)
;-- 2012/02/22 A.Satoh Mod - E
		)
	)

	(if (= #err_flag nil)
		(progn
			(if &XLINE_W$
				(progn
					; ブレークライン位置情報を昇順でソートする
					(setq #XLINE_W$ (SortBrkLineDist &XLINE_W$))

					(setq #maguti1 (car #XLINE_W$))
					(if (= #maguti1 nil)
						(setq #maguti1 0.0)
					)
					(setq #maguti2 (cadr #XLINE_W$))
					(if (= #maguti2 nil)
						(setq #maguti2 0.0)
					)
					(setq #maguti3 (caddr #XLINE_W$))
					(if (= #maguti3 nil)
						(setq #maguti3 0.0)
					)
				)
				(progn
					(setq #maguti1 0.0)
					(setq #maguti2 0.0)
					(setq #maguti3 0.0)
				)
			)
			(if &XLINE_D$
				(progn
					; ブレークライン位置情報を昇順でソートする
					(setq #XLINE_D$ (SortBrkLineDist &XLINE_D$))

					(setq #oku1 (car #XLINE_D$))
					(if (= #oku1 nil)
						(setq #oku1 0.0)
					)
					(setq #oku2 (cadr #XLINE_D$))
					(if (= #oku2 nil)
						(setq #oku2 0.0)
					)
					(setq #oku3 (caddr #XLINE_D$))
					(if (= #oku3 nil)
						(setq #oku3 0.0)
					)
				)
				(progn
					(setq #oku1 0.0)
					(setq #oku2 0.0)
					(setq #oku3 0.0)
				)
			)
			(if &XLINE_H$
				(progn
					; ブレークライン位置情報を昇順でソートする
					(setq #XLINE_H$ (SortBrkLineDist &XLINE_H$))

					(setq #height1 (car #XLINE_H$))
					(if (= #height1 nil)
						(setq #height1 0.0)
					)
					(setq #height2 (cadr #XLINE_H$))
					(if (= #height2 nil)
						(setq #height2 0.0)
					)
					(setq #height3 (caddr #XLINE_H$))
					(if (= #height3 nil)
						(setq #height3 0.0)
					)
				)
				(progn
					(setq #height1 0.0)
					(setq #height2 0.0)
					(setq #height3 0.0)
				)
			)

			; 伸縮レギュラーキャビ情報(G_REG)の設定
			(if #xd_REG$
				(progn
;-- 2012/03/16 A.Satoh Add - S
					(if &flag
						(if (> (nth 15 #xd_REG$) 0.0)
							(setq #str_d (nth 15 #xd_REG$))
							(setq #str_d (nth 3 &cab_size$))
						)
						(setq #str_d (nth 15 #xd_REG$))
					)
					(if &flag
						(if (> (nth 16 #xd_REG$) 0.0)
							(setq #str_c (nth 16 #xd_REG$))
							(setq #str_c (nth 2 &cab_size$))
						)
						(setq #str_c (nth 16 #xd_REG$))
					)
;-- 2012/03/16 A.Satoh Add - E

					(CFSetXData &sym "G_REG"
						(CFModList #xd_REG$
							(list
								(list  0 (nth 0 #hinban$))										; [ 0]特注品番
								(list  1 (nth 1 #hinban$))										; [ 1]金額
								(list  2 (nth 2 #hinban$))										; [ 2]品名
								(list  3 (nth 3 #hinban$))										; [ 3]特注コード
								(list  4 (nth 4 #hinban$))										; [ 4]巾
								(list  5 (nth 5 #hinban$))										; [ 5]高さ
								(list  6 (nth 6 #hinban$))										; [ 6]奥行
;-- 2012/03/16 A.Satoh Add - S
								(list 15 #str_d)															; [15]Ｄの伸縮量
								(list 16 #str_c)															; [16]Ｃの伸縮量
;-- 2012/03/16 A.Satoh Add - E
								(list 17 (nth 3 #xd_SYM$))										; [17]伸縮後図形サイズＷ
								(list 18 (nth 4 #xd_SYM$))										; [18]伸縮後図形サイズＤ
								(list 19 (nth 5 #xd_SYM$))										; [19]伸縮後図形サイズＨ
								(if &XLINE_W$
									(list 20 (list #maguti1 #maguti2 #maguti3))	; [20]ブレークライン位置Ｗ
									(list 20 (nth 20 #xd_REG$))
								)
								(if &XLINE_D$
									(list 21 (list #oku1    #oku2    #oku3))		; [21]ブレークライン位置Ｄ
									(list 21 (nth 21 #xd_REG$))
								)
								(if &XLINE_H$
									(list 22 (list #height1 #height2 #height3))	; [22]ブレークライン位置Ｈ
									(list 22 (nth 22 #xd_REG$))
								)
							)
						)
					)
				)
				(CFSetXData &sym "G_REG"
					(list
						(nth 0 #hinban$)													; [ 0]特注品番
						(nth 1 #hinban$)													; [ 1]金額
						(nth 2 #hinban$)													; [ 2]品名
						(nth 3 #hinban$)													; [ 3]特注コード
						(nth 4 #hinban$)													; [ 4]巾
						(nth 5 #hinban$)													; [ 5]高さ
						(nth 6 #hinban$)													; [ 6]奥行
						""																				; [ 7]予備１
						""																				; [ 8]予備２
						""																				; [ 9]予備３
						#hinban																		; [10]元品番名称
						#hin_last																	; [11]元最終品番
						#org_width																; [12]元図形サイズＷ
						#org_depth																; [13]元図形サイズＤ
						#org_height																; [14]元図形サイズＨ
;-- 2012/03/16 A.Satoh Mod -S
;;;;;						""																				; [15]予備４
;;;;;						""																				; [16]予備５
						(if &flag
							(nth 3 &cab_size$)											; [15]Ｄの伸縮量
							0.0																			; [15]Ｄの伸縮量
						)
						(if &flag
							(nth 2 &cab_size$)											; [16]Ｃの伸縮量
							0.0																			; [16]Ｃの伸縮量
						)
;-- 2012/03/16 A.Satoh Mod -E
						(nth 3 #xd_SYM$)													; [17]伸縮後図形サイズＷ
						(nth 4 #xd_SYM$)													; [18]伸縮後図形サイズＤ
						(nth 5 #xd_SYM$)													; [19]伸縮後図形サイズＨ
						(list #maguti1 #maguti2 #maguti3)					; [20]ブレークライン位置Ｗ
						(list #oku1    #oku2    #oku3)						; [21]ブレークライン位置Ｄ
						(list #height1 #height2 #height3)					; [22]ブレークライン位置Ｈ
					)
				)
			)
		)
		(setq #ret nil)
	)

	#ret

);InputGRegData


;<HOM>*************************************************************************
; <関数名>    : SortBrkLineDist
; <処理概要>  : ブレークライン位置情報リストの内容をソートする
; <戻り値>    : ソート後のブレークライン位置情報リスト
; <作成>      : 12/02/17 A.Satoh
; <備考>      : 3項目のリストを想定
;             : 0.0はソート対象外
;*************************************************************************>MOH<
(defun SortBrkLineDist (
	&XLINE$
  /
	#ret$ #flag #item1 #item2 #item3 #wk_item
  )

	(setq #ret$ nil)
	(setq #flag nil)

	(setq #item1 (car   &XLINE$))
	(if (= #item1 nil)
		(setq #item1 0.0)
	)
	(setq #item2 (cadr  &XLINE$))
	(if (= #item2 nil)
		(setq #item2 0.0)
	)
	(setq #item3 (caddr &XLINE$))
	(if (= #item3 nil)
		(setq #item3 0.0)
	)

	; 値が全て0.0である場合は、処理を行わない
	(if (and (equal #item1 0.0 0.001) (equal #item2 0.0 0.001) (equal #item3 0.0 0.001))
		(progn
			(setq #ret$ &XLINE$)
			(setq #flag T)
		)
	)

	(if (= #flag nil)
		(progn
			(if (and (equal #item2 0.0 0.001) (not (equal #item3 0.0 0.001)))
				(progn
					(setq #item2 #item3)
					(setq #item3 0.0)
				)
			)

			(if (and (equal #item1 0.0 0.001) (not (equal #item2 0.0 0.001)))
				(progn
					(setq #item1 #item2)
					(setq #item2 0.0)
				)
			)

			; #item1と#item2で大小比較
			(if (and (not (equal #item1 0.0 0.001)) (not (equal #item2 0.0 0.001)))
				(if (> #item1 #item2)
					(progn
						(setq #wk_item #item2)
						(setq #item2 #item1)
						(setq #item1 #wk_item)
					)
				)
			)

			; 大小比較後の#item1と#item3で大小比較を行う
			(if (and (not (equal #item1 0.0 0.001)) (not (equal #item3 0.0 0.001)))
				(if (> #item1 #item3)
					(progn
						(setq #wk_item #item3)
						(setq #item3 #item1)
						(setq #item1 #wk_item)
					)
				)
			)

			; #item2と#item3で大小比較を行う
			(if (and (not (equal #item2 0.0 0.001)) (not (equal #item3 0.0 0.001)))
				(if (> #item2 #item3)
					(progn
						(setq #wk_item #item3)
						(setq #item3 #item2)
						(setq #item2 #wk_item)
					)
				)
			)

			(setq #ret$ (list #item1 #item2 #item3))
		)
	)

	#ret$

);SortBrkLineDist
;-- 2012/02/15 A.Satoh Add CG対応 - E


;-- 2011/12/05 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : StretchCabW_CNR_sub
; <処理概要>  : コーナーキャビネット伸縮処理
; <戻り値>    : なし
; <作成>      : 11/12/05 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_CNR_sub (
  &en         ; 伸縮対象ｼﾝﾎﾞﾙ図形
	&taisyo			; 特注対象
	&chk				; 入力可否チェック
  /
	#XLINE_W$ #XLINE_D$ #XLINE_H$ #xd_LSYM$ #xd_SYM$ #xd_TOKU$
	#pnt$ #ang #gnam #err_flag #flag #pmen2 #pt$ #base
	#p1 #p2 #p3 #p4 #p5 #p6 #w1 #w2 #d1 #d2 #a1 #a2 #h
	#org_size$ #org_width #org_depth #org_height #wdh$ #cab_size$
	#eDelBRK_W$ #eDelBRK_D$ #eDelBRK_H$ #eD #BrkW #BrkD #BrkH
	#XLINE_W #XLINE_D #XLINE_H #str_flag #expData$ #clayer
	#hinban #qry$
	#item1 #item2 #sabun
#doorID  ;-- 2012/03/23 A.Satoh Add
  )

	(setq #XLINE_W$ nil)
	(setq #XLINE_D$ nil)
	(setq #XLINE_H$ nil)

	(setq #xd_LSYM$ (CFGetXData &en "G_LSYM"))
	(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))
	(setq #xd_TOKU$ (CFGetXData &en "G_TOKU"))
	(setq #pnt$  (cdr (assoc 10 (entget &en))))      ; ｼﾝﾎﾞﾙ基準点
	(setq #ang (nth 2 #xd_LSYM$))                  ; ｼﾝﾎﾞﾙ配置角度

	;2018/09/05 YM MOD
;;;  (if (equal #ang      0 0.0001) (setq #ang    0)) ;2018/03/12  ;2018/08/30 YM これは有効だが、０以外も対応必要
  (if (equal #ang      0 0.0001) (setq #ang  0.0)) ;2018/03/12  ;2018/08/30 YM これは有効だが、０以外も対応必要
	;2018/09/05 YM MOD

	(setq #hinban (nth 5 #xd_LSYM$))
;-- 2012/03/23 A.Satoh Add - S
	(setq #doorID (nth 7 #xd_LSYM$))
;-- 2012/03/23 A.Satoh Add - E
	(setq #gnam (SKGetGroupName &en))              ; ｸﾞﾙｰﾌﾟ名
	(setq #err_flag nil)
	(setq #str_flag nil)
;-- 2012/02/17 A.Satoh Add CG対応 - S
	(setq CG_SizeH (nth 13 #xd_LSYM$))
;-- 2012/02/17 A.Satoh Add CG対応 - E

	(if (> 0 (nth 10 #xd_SYM$))
		(setq CG_BASE_UPPER T)
	)

      ; ｺｰﾅｰｷｬﾋﾞ        w1=p1～p2
      ; p1          p2  w2=p1～p6
      ; +-----------+   d1=p2～p3
      ; |           |   d2=p5～p6
      ; |           |   a1=p3～p4
      ; |     +-----+   a2=p4～p5
      ; |     |p4   p3
      ; |     |
      ; +-----+
      ; p6    p5

	(setq #pmen2 (PKGetPMEN_NO &en 2))  ; PMEN2を求める
	(setq #pt$ (GetLWPolyLinePt #pmen2)) ; PMEN2 外形領域
	(setq #base (PKGetBaseL6 #pt$))      ; ｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙを見ない)
	(setq #pt$ (GetPtSeries #base #pt$)) ; #base を先頭に時計周り
	(setq #p1 (nth 0 #pt$))
	(setq #p2 (nth 1 #pt$))
	(setq #p3 (nth 2 #pt$))
	(setq #p4 (nth 3 #pt$))
	(setq #p5 (nth 4 #pt$))
	(setq #p6 (nth 5 #pt$))

	(setq #w1 (distance #p1 #p2))
	(setq #w2 (distance #p1 #p6))
	(setq #d1 (distance #p2 #p3))
	(setq #d2 (distance #p5 #p6))
	(setq #a1 (distance #p3 #p4))
	(setq #a2 (distance #p4 #p5))
	(setq #h  (nth 5 #xd_SYM$)) ; 寸法H

	(if #xd_TOKU$
		(progn
			(setq #org_width  (nth 12 #xd_TOKU$))
			(setq #org_depth  (nth 13 #xd_TOKU$))
			(setq #org_height (nth 14 #xd_TOKU$))
		)
		(progn
			(setq #org_width  #w1)
			(setq #org_depth  #w2)
			(setq #org_height #h)
		)
	)
	(setq #org_size$ (list #org_width #org_depth #org_height))

	(if (= &taisyo "B")
		(setq #cab_size$ (list 0.0 0.0 0.0 0.0 0.0))
		(progn
			; ダイアログ表示
			(setq #wdh$ (list #w1 #w2 #d1 #d2 #h #org_width #org_depth #org_height))
			(setq #cab_size$ (StretchCabW_SetTOKUCNRCABSizeDlg &en #wdh$ &taisyo &chk))
			(if (= #cab_size$ nil)
				(setq #err_flag T)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
			(setq #eDelBRK_W$ (PcRemoveBreakLine &en "W")) ; W方向ブレーク除去
			(setq #eDelBRK_D$ (PcRemoveBreakLine &en "D")) ; D方向ブレーク除去
			(setq #eDelBRK_H$ (PcRemoveBreakLine &en "H")) ; H方向ブレーク除去

			; ブレークライン位置を求める
;			(if (or (not (equal (nth 0 #cab_size$) (nth 0 #wdh$) 0.0001))
;							(not (equal (nth 1 #cab_size$) (nth 1 #wdh$) 0.0001))
;							(not (equal (nth 2 #cab_size$) (nth 2 #wdh$) 0.0001))
;							(not (equal (nth 3 #cab_size$) (nth 3 #wdh$) 0.0001))
;							(not (equal (nth 4 #cab_size$) (nth 4 #wdh$) 0.0001)))
			(if (or (not (equal (nth 0 #cab_size$) 0.0 0.0001))
							(not (equal (nth 1 #cab_size$) 0.0 0.0001))
							(not (equal (nth 2 #cab_size$) 0.0 0.0001))
							(not (equal (nth 3 #cab_size$) 0.0 0.0001))
							(not (equal (nth 4 #cab_size$) 0.0 0.0001)))
				(progn
					(setq #str_flag T)

					; 指定のシンボル図形をワーク画層に移動する
					(setq #expData$ (StretchCabW_MoveCabToWorkLayer &en))

					; ワーク画層以外を非表示にする
					; 現在画層を取得
					(setq #clayer (getvar "CLAYER"))

					; 引数画層(なければ作成)を現在画層にしてそれ以外をﾌﾘｰｽﾞ 色番号1-255,線種
					(KPSetClayerOtherFreeze "EXP_TEMP_LAYER" 1 SKW_AUTO_LAY_LINE)
				)
			)

			; ブレークライン位置を求める
			; Ｗ方向
;			(if (or (not (equal (nth 0 #cab_size$) (nth 0 #wdh$) 0.0001))
;							(not (equal (nth 3 #cab_size$) (nth 3 #wdh$) 0.0001)))
			(if (or (not (equal (nth 0 #cab_size$) 0.0 0.0001))
							(not (equal (nth 3 #cab_size$) 0.0 0.0001)))
				(progn
					; Ｗ方向ブレークライン位置を求める
					(setq #XLINE_W$ (StretchCabW_MakeBreakLineW #pnt$ #ang))
					(if (= (length #XLINE_W$) 2)
						(progn
							(setq #item1 (nth 0 #XLINE_W$))
							(setq #item2 (nth 1 #XLINE_W$))
							(if (> #item2 #item1)
								(setq #XLINE_W$ (list #item2 #item1))
							)
						)
					)
				)
			)

			; Ｄ方向
;			(if (or (not (equal (nth 1 #cab_size$) (nth 1 #wdh$) 0.0001))
;							(not (equal (nth 2 #cab_size$) (nth 2 #wdh$) 0.0001)))
			(if (or (not (equal (nth 1 #cab_size$) 0.0 0.0001))
							(not (equal (nth 2 #cab_size$) 0.0 0.0001)))
				(progn
					; Ｄ方向ブレークライン位置を求める
					(setq #XLINE_D$ (StretchCabW_MakeBreakLineD #pnt$ #ang))
					(if (= (length #XLINE_D$) 2)
						(progn
							(setq #item1 (nth 0 #XLINE_D$))
							(setq #item2 (nth 1 #XLINE_D$))
							(if (< #item1 #item2)
								(setq #XLINE_D$ (list #item2 #item1))
							)
						)
					)
				)
			)

			; Ｈ方向
;			(if (not (equal (nth 4 #cab_size$) (nth 4 #wdh$) 0.0001))
			(if (not (equal (nth 4 #cab_size$) 0.0 0.0001))
				; Ｈ方向ブレークライン位置を求める
				(setq #XLINE_H$ (StretchCabW_MakeBreakLineH #pnt$ #ang))
			)

			(if (= #str_flag T)
				(progn
					(setq #str_flag nil)

					; ワーク画層へ移動したシンボルを元の画層に戻す
					(StretchCabW_MoveCabBackOrgLayer #expData$)

					; 図面の表示状態を元に戻す
					(SetLayer)

				  (setvar "CLAYER" #clayer) ; 現在画層を戻す

					(SetLayer)

					(if (and (= #XLINE_W$ nil) (= #XLINE_D$ nil) (= #XLINE_H$ nil))
						(progn
							(CFAlertErr "ブレークラインが設定されていません。\n特注化処理を中断します。")
							(setq #err_flag T)
						)
					)
;-- 2011/12/16 A.Satoh Add - S
					(if (= #err_flag nil)
						(progn
							(if (and (= #XLINE_W$ nil)
										(or (not (equal (nth 0 #cab_size$) 0.0 0.0001))
												(not (equal (nth 3 #cab_size$) 0.0 0.0001))))
								(CFAlertMsg "幅方向のブレークラインが設定されていません。\n右側間口および左側奥行は伸縮されません。")
							)
							(if (and (= #XLINE_D$ nil)
										(or (not (equal (nth 1 #cab_size$) 0.0 0.0001))
												(not (equal (nth 2 #cab_size$) 0.0 0.0001))))
								(CFAlertMsg "奥行方向のブレークラインが設定されていません。\n左側間口および右側奥行は伸縮されません。")
							)
							(if (and (= #XLINE_H$ nil)
										(not (equal (nth 4 #cab_size$) 0.0 0.0001)))
								(CFAlertMsg "高さ方向のブレークラインが設定されていません。\n高さは伸縮されません。")
							)
						)
					)
;-- 2011/12/16 A.Satoh Add - E
				)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
			; 伸縮処理
;	    ;// <W1右側ｷｬﾋﾞ間口>
;			(if (not (equal (nth 0 #cab_size$) #w1 0.0001)) ; W1(W)
;				(foreach #BrkW #XLINE_W$
	    ;// [A] 伸縮量
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (nth 0 #cab_size$) 0.0 0.0001)) ; W1(W)
			(if (and #XLINE_W$ (not (equal (nth 0 #cab_size$) 0.0 0.0001))) ; W1(W)
;-- 2011/12/16 A.Satoh Mod - E
				(if (not (equal (nth 3 #cab_size$) 0.0 0.0001))
					(progn
						(setq #BrkW (nth 0 #XLINE_W$))
						(setq #XLINE_W (PK_MakeBreakW #pnt$ #ang #BrkW))
						(CFSetXData #XLINE_W "G_BRK" (list 1))
						(command "-group" "A" #gnam #XLINE_W "")	; ブレークラインのグループ化

       		  (setq CG_TOKU_BW #BrkW)
 	        	(setq CG_TOKU_BD nil)
	   	      (setq CG_TOKU_BH nil)

						; 最新情報を使用する
						(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

						; キャビネット本体の伸縮を行う
;          (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$)(- (nth 0 #cab_size$) #w1)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))
    	      (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$) (nth 0 #cab_size$)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

						; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
						(entdel #XLINE_W)

						; 扉図形の伸縮
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
					(progn
						(setq #sabun (/ (nth 0 #cab_size$) (length #XLINE_W$)))

						(foreach #BrkW #XLINE_W$
							(setq #XLINE_W (PK_MakeBreakW #pnt$ #ang #BrkW))
							(CFSetXData #XLINE_W "G_BRK" (list 1))
							(command "-group" "A" #gnam #XLINE_W "")	; ブレークラインのグループ化

       			  (setq CG_TOKU_BW #BrkW)
 	        		(setq CG_TOKU_BD nil)
	   	      	(setq CG_TOKU_BH nil)

							; 最新情報を使用する
							(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

							; キャビネット本体の伸縮を行う
  	  	      (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

							; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
							(entdel #XLINE_W)

							; 扉図形の伸縮
							(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

							(KP_TOKU_GROBAL_RESET)
						)
					)
				)
      )

;			;// <W2左側ｷｬﾋﾞ間口>
;			(if (not (equal (nth 1 #cab_size$) #w2 0.0001)) ; W2(D)
;				(foreach #BrkD #XLINE_D$
			;// [B] 伸縮量
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (nth 1 #cab_size$) 0.0 0.0001)) ; W2(D)
			(if (and #XLINE_D$ (not (equal (nth 1 #cab_size$) 0.0 0.0001))) ; W2(D)
;-- 2011/12/16 A.Satoh Mod - E
				(if (not (equal (nth 2 #cab_size$) 0.0 0.0001))
					(progn
						(setq #BrkD (nth 0 #XLINE_D$))

						(setq #XLINE_D (PK_MakeBreakD #pnt$ #ang #BrkD))
						(CFSetXData #XLINE_D "G_BRK" (list 2))

						; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
						(command "-group" "A" #gnam #XLINE_D "")

       	  	(setq CG_TOKU_BW nil)
	 	        (setq CG_TOKU_BD #BrkD)
  	 	      (setq CG_TOKU_BH nil)

						; 最新情報を使用する
						(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

						; キャビネット本体の伸縮を行う
;					(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$)(- (nth 1 #cab_size$) #w2)) (nth 5 #xd_SYM$))
						(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) (nth 1 #cab_size$)) (nth 5 #xd_SYM$))

						; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
						(entdel #XLINE_D)

						; 扉図形の伸縮
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
					(progn
						(setq #sabun (/ (nth 1 #cab_size$) (length #XLINE_D$)))

						(foreach #BrkD #XLINE_D$
							(setq #XLINE_D (PK_MakeBreakD #pnt$ #ang #BrkD))
							(CFSetXData #XLINE_D "G_BRK" (list 2))

							; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
							(command "-group" "A" #gnam #XLINE_D "")

       		  	(setq CG_TOKU_BW nil)
	 	      	  (setq CG_TOKU_BD #BrkD)
  	 	      	(setq CG_TOKU_BH nil)

							; 最新情報を使用する
							(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

							; キャビネット本体の伸縮を行う
							(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

							; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
							(entdel #XLINE_D)

							; 扉図形の伸縮
							(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

							(KP_TOKU_GROBAL_RESET)
						)
					)
				)
			)

;			;// <D1右側ｷｬﾋﾞ奥行き>
;			(if (not (equal (nth 2 #cab_size$) #d1 0.0001)) ; D1(D)
;				(foreach #BrkD #XLINE_D$
			;// [C] 伸縮量
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (nth 2 #cab_size$) 0.0 0.0001)) ; D1(D)
			(if (and #XLINE_D$ (not (equal (nth 2 #cab_size$) 0.0 0.0001))) ; D1(D)
;-- 2011/12/16 A.Satoh Mod - E
				(if (not (equal (nth 1 #cab_size$) 0.0 0.0001))
					(progn
						(if (= (length #XLINE_D$) 2)
							(setq #BrkD (nth 1 #XLINE_D$))
							(setq #BrkD (nth 0 #XLINE_D$))
						)

						(setq #XLINE_D (PK_MakeBreakD #pnt$ #ang #BrkD))
						(CFSetXData #XLINE_D "G_BRK" (list 2))

						; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
						(command "-group" "A" #gnam #XLINE_D "")

    	   	  (setq CG_TOKU_BW nil)
 	    	    (setq CG_TOKU_BD #BrkD)
   	    	  (setq CG_TOKU_BH nil)

						; 最新情報を使用する
						(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

						; キャビネット本体の伸縮を行う
						(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) (nth 2 #cab_size$)) (nth 5 #xd_SYM$))

						; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
						(entdel #XLINE_D)

						; 扉図形の伸縮
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
					(progn
						(setq #sabun (/ (nth 2 #cab_size$) (length #XLINE_D$)))

						(foreach #BrkD #XLINE_D$
							(setq #XLINE_D (PK_MakeBreakD #pnt$ #ang #BrkD))
							(CFSetXData #XLINE_D "G_BRK" (list 2))

							; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
							(command "-group" "A" #gnam #XLINE_D "")

    	  	 	  (setq CG_TOKU_BW nil)
 	    	  	  (setq CG_TOKU_BD #BrkD)
   	    	  	(setq CG_TOKU_BH nil)

							; 最新情報を使用する
							(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

							; キャビネット本体の伸縮を行う
							(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

							; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
							(entdel #XLINE_D)

							; 扉図形の伸縮
							(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

							(KP_TOKU_GROBAL_RESET)
						)
					)
				)
			)

;			;// <D2左側ｷｬﾋﾞ奥行き>
;			(if (not (equal (nth 3 #cab_size$) #d2 0.0001)) ; D2(W)
;				(foreach #BrkW #XLINE_W$
			;// [D] 伸縮量
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (nth 3 #cab_size$) 0.0 0.0001)) ; D2(W)
			(if (and #XLINE_W$ (not (equal (nth 3 #cab_size$) 0.0 0.0001))) ; D2(W)
;-- 2011/12/16 A.Satoh Mod - E
				(if (not (equal (nth 0 #cab_size$) 0.0 0.0001))
					(progn
						(if (= (length #XLINE_W$) 2)
							(setq #BrkW (nth 1 #XLINE_W$))
							(setq #BrkW (nth 0 #XLINE_W$))
						)

						(setq #XLINE_W (PK_MakeBreakW #pnt$ #ang #BrkW))
						(CFSetXData #XLINE_W "G_BRK" (list 1))
						(command "-group" "A" #gnam #XLINE_W "")	; ブレークラインのグループ化

  	     	  (setq CG_TOKU_BW #BrkW)
 	  	      (setq CG_TOKU_BD nil)
   	  	    (setq CG_TOKU_BH nil)

						; 最新情報を使用する
						(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

						; キャビネット本体の伸縮を行う
;          (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$)(- (nth 3 #cab_size$) #d2)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))
  	        (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$) (nth 3 #cab_size$)) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

						; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
						(entdel #XLINE_W)

						; 扉図形の伸縮
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
					(progn
						(setq #sabun (/ (nth 3 #cab_size$) (length #XLINE_W$)))

						(foreach #BrkW #XLINE_W$
							(setq #XLINE_W (PK_MakeBreakW #pnt$ #ang #BrkW))
							(CFSetXData #XLINE_W "G_BRK" (list 1))
							(command "-group" "A" #gnam #XLINE_W "")	; ブレークラインのグループ化

  	  	   	  (setq CG_TOKU_BW #BrkW)
 	  	  	    (setq CG_TOKU_BD nil)
   	  	  	  (setq CG_TOKU_BH nil)

							; 最新情報を使用する
							(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

							; キャビネット本体の伸縮を行う
  		        (SKY_Stretch_Parts &en (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

							; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
							(entdel #XLINE_W)

							; 扉図形の伸縮
							(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

							(KP_TOKU_GROBAL_RESET)
						)
					)
        )
      )

			;// <H方向>
;			(if (not (equal (nth 4 #cab_size$) #h 0.0001)) ; H
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (nth 4 #cab_size$) 0.0 0.0001)) ; H
			(if (and #XLINE_H$ (not (equal (nth 4 #cab_size$) 0.0 0.0001))) ; H
;-- 2011/12/16 A.Satoh Mod - E
				(progn
;-- 2012/02/20 A.Satoh Add - S
					(setq CG_SizeH (+ CG_SizeH (nth 4 #cab_size$)))
;-- 2012/02/20 A.Satoh Add - E
					(setq #sabun (/ (nth 4 #cab_size$) (length #XLINE_H$)))
					(foreach #BrkH #XLINE_H$
;-- 2012/01/25 A.Satoh Add - S
						(if CG_BASE_UPPER
							(setq #BrkH (- (caddr #pnt$) #BrkH))
						)
;-- 2012/01/25 A.Satoh Add - E
						(setq #XLINE_H (PK_MakeBreakH #pnt$ #BrkH))
						(CFSetXData #XLINE_H "G_BRK" (list 3))

						; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
						(command "-group" "A" #gnam #XLINE_H "")

	       	  (setq CG_TOKU_BW nil)
 		        (setq CG_TOKU_BD nil)
   		      (setq CG_TOKU_BH #BrkH)

						; 最新情報を使用する
						(setq #xd_SYM$  (CFGetXData &en "G_SYM" ))

						; キャビネット本体の伸縮を行う
						(SKY_Stretch_Parts &en (nth 3 #xd_SYM$) (nth 4 #xd_SYM$) (+ (nth 5 #xd_SYM$) #sabun))

;-- 2012/02/22 A.Satoh Add : 品番図形DBの登録H寸法値を更新する - S
	    		  (CFSetXData &en "G_LSYM"
	  	    	  (CFModList #xd_LSYM$
		    	  	  (list (list 13 CG_SizeH))
    	    		)
      			)
;-- 2012/02/22 A.Satoh Add : 品番図形DBの登録H寸法値を更新する - E

						; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
						(entdel #XLINE_H)

						; 扉図形の伸縮
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list &en) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
				)
			)

			; 元のﾌﾞﾚｰｸﾗｲﾝ復活
			; W方向
			(foreach #eD #eDelBRK_W$ (if (= (entget #eD) nil) (entdel #eD)))
			; D方向
			(foreach #eD #eDelBRK_D$ (if (= (entget #eD) nil) (entdel #eD)))
			; H方向
			(foreach #eD #eDelBRK_H$ (if (= (entget #eD) nil) (entdel #eD)))

;-- 2012/03/23 A.Satoh Add - S
			(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
			(CFSetXData #sym "G_LSYM" (CFModList #xd_LSYM$ (list (list 7 #doorID))))
;-- 2012/03/23 A.Satoh Add - E

			(setq #qry$
				(CFGetDBSQLRec CG_DBSESSION "特注規格品"
					(list
						(list "品番名称" #hinban 'STR)
					)
				)
			)
			(if (= #qry$ nil)
				(progn
					; 指定のシンボルに対して特注キャビ情報を設定する
					(if (= nil (tblsearch "APPID" "G_TOKU")) (regapp "G_TOKU"))
					(setq #flag (StretchCabW_InputTokuData &en #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ &chk #cab_size$ T))
					(if (= #flag nil)
						(command "_undo" "b")
					)
				)
				(progn
					(princ (strcat "\n★★★★特注規格品 品番名称 = " #hinban))
;-- 2012/02/15 A.Satoh Add CG対応 - S
					(if (= nil (tblsearch "APPID" "G_REG")) (regapp "G_REG"))
					(InputGRegData &en #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ &chk #cab_size$ T)
;-- 2012/02/15 A.Satoh Add CG対応 - E
				)
			)
		)
	)

	(setq CG_BASE_UPPER nil)
;-- 2012/02/17 A.Satoh Add CG対応 - S
	(setq CG_SizeH nil)
;-- 2012/02/17 A.Satoh Add CG対応 - E
  (princ)

) ;StretchCabW_CNR_sub


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_SetTOKUCNRCABSizeDlg
; <処理概要>  : コーナーキャビ用特注キャビサイズ変更画面処理を行う
; <戻り値>    : サイズリスト:(右側間口,左側間口,右側奥行,左側奥行,高さ)
;             : nil キャンセル押下
; <作成>      : 11/12/05 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_SetTOKUCNRCABSizeDlg (
	&en		; シンボル図形名
	&wdh$	; サイズ情報リスト
	&taisyo	; 特注対象
	&chk
  /
	#dcl_id #x #y #next #ret$
	#W_f #D_f #H_f
  )

	;***********************************************************************
	; ＯＫボタン押下処理
	; 戻り値:サイズ変更情報リスト (右側間口 左側間口 右側奥行 左側奥行 高さ)
	;***********************************************************************
	(defun ##SetTOKUCNRCABSize_CallBack (
		/
		#err_flag #width1 #width2 #depth1 #depth2 #height #data$
		)

    (setq #err_flag nil)

    ; [A]伸縮量チェック
		(setq #width1 (get_tile "edtWT_Width_A"))
		(if (or (= #width1 "") (= #width1 nil))
			(progn
				(set_tile "error" "[A] 伸縮量が入力されていません")
				(mode_tile "edtWT_Width_A" 2)
				(setq #err_flag T)
			)
;|
			(if (or (= (type (read #width1)) 'INT) (= (type (read #width1)) 'REAL))
				(if (or (> -1000 (read #width1)) (< 1000 (read #width1)))
					(progn
						(set_tile "error" "右側間口は 99999 以下の数値を入力して下さい")
						(mode_tile "edtWT_Width_A" 2)
						(setq #err_flag T)
					)
					(if (> (read #width1) 99999)
						(progn
							(set_tile "error" "右側間口は 99999 以下の数値を入力して下さい")
							(mode_tile "edtWT_Width_A" 2)
							(setq #err_flag T)
						)
					)
				)
				(progn
					(set_tile "error" "右側間口は 99999 以下の数値を入力して下さい")
					(mode_tile "edtWT_Width_A" 2)
					(setq #err_flag T)
				)
			)
|;
		)

		; [B] 伸縮量チェック
		(if (= #err_flag nil)
			(progn
				(setq #width2 (get_tile "edtWT_Width_B"))
				(if (or (= #width2 "") (= #width2 nil))
					(progn
						(set_tile "error" "[B] 伸縮量が入力されていません")
						(mode_tile "edtWT_Width_B" 2)
						(setq #err_flag T)
					)
;|
					(if (or (= (type (read #width2)) 'INT) (= (type (read #width2)) 'REAL))
						(if (> 0 (read #width2))
							(progn
								(set_tile "error" "左側間口は 99999 以下の数値を入力して下さい")
								(mode_tile "edtWT_Width_B" 2)
								(setq #err_flag T)
							)
							(if (> (read #width2) 99999)
								(progn
									(set_tile "error" "左側間口は 99999 以下の数値を入力して下さい")
									(mode_tile "edtWT_Width_B" 2)
									(setq #err_flag T)
								)
							)
						)
						(progn
							(set_tile "error" "左側間口は 99999 以下の数値を入力して下さい")
							(mode_tile "edtWT_Width_B" 2)
							(setq #err_flag T)
						)
					)
|;
				)
			)
		)

		; [C] 伸縮量チェック
		(if (= #err_flag nil)
			(progn
				(setq #depth1 (get_tile "edtWT_Depth_C"))
				(if (or (= #depth1 "") (= #depth1 nil))
					(progn
						(set_tile "error" "[C] 伸縮量が入力されていません")
						(mode_tile "edtWT_Depth_C" 2)
						(setq #err_flag T)
					)
;|
					(setq #depth1 "")
					(if (or (= (type (read #depth1)) 'INT) (= (type (read #depth1)) 'REAL))
						(if (> 0 (read #depth1))
							(progn
								(set_tile "error" "右側奥行は 99999 以下の数値を入力して下さい")
								(mode_tile "edtWT_Depth_C" 2)
								(setq #err_flag T)
							)
							(if (> (read #depth1) 99999)
								(progn
									(set_tile "error" "右側奥行は 99999 以下の数値を入力して下さい")
									(mode_tile "edtWT_Depth_C" 2)
									(setq #err_flag T)
								)
							)
						)
						(progn
							(set_tile "error" "右側奥行は 99999 以下の数値を入力して下さい")
							(mode_tile "edtWT_Depth_C" 2)
							(setq #err_flag T)
						)
					)
|;
				)
			)
		)

		; [D] 伸縮量チェック
		(if (= #err_flag nil)
			(progn
				(setq #depth2 (get_tile "edtWT_Depth_D"))
				(if (or (= #depth2 "") (= #depth2 nil))
					(progn
						(set_tile "error" "[C] 伸縮量が入力されていません")
						(mode_tile "edtWT_Depth_D" 2)
						(setq #err_flag T)
					)
;|
					(setq #depth2 "")
					(if (or (= (type (read #depth2)) 'INT) (= (type (read #depth2)) 'REAL))
						(if (> 0 (read #depth2))
							(progn
								(set_tile "error" "奥行は 99999 以下の数値を入力して下さい")
								(mode_tile "edtWT_Depth_D" 2)
								(setq #err_flag T)
							)
							(if (> (read #depth2) 99999)
								(progn
									(set_tile "error" "奥行は 99999 以下の数値を入力して下さい")
									(mode_tile "edtWT_Depth_D" 2)
									(setq #err_flag T)
								)
							)
						)
						(progn
							(set_tile "error" "奥行は 99999 以下の数値を入力して下さい")
							(mode_tile "edtWT_Depth_D" 2)
							(setq #err_flag T)
						)
					)
|;
				)
			)
		)

		; 高さ 伸縮量チェック
		(if (= #err_flag nil)
			(progn
				(setq #height (get_tile "edtWT_Height"))
				(if (or (= #height "") (= #height nil))
					(progn
						(set_tile "error" "高さ 伸縮量が入力されていません")
						(mode_tile "edtWT_Height" 2)
						(setq #err_flag T)
					)
;|
					(setq #height "")
					(if (or (= (type (read #height)) 'INT) (= (type (read #height)) 'REAL))
						(if (> 0 (read #height))
							(progn
								(set_tile "error" "高さは 99999 以下の数値を入力して下さい")
								(mode_tile "edtWT_Height" 2)
								(setq #err_flag T)
							)
							(if (> (read #height) 99999)
								(progn
									(set_tile "error" "高さは 99999 以下の数値を入力して下さい")
									(mode_tile "edtWT_Height" 2)
									(setq #err_flag T)
								)
							)
						)
						(progn
							(set_tile "error" "高さは 99999 以下の数値を入力して下さい")
							(mode_tile "edtWT_Height" 2)
							(setq #err_flag T)
						)
					)
|;
				)
			)
		)

		; サイズ変更情報リストの作成
		(if (= #err_flag nil)
			(progn
				(setq #data$ (list (atof #width1) (atof #width2) (atof #depth1) (atof #depth2) (atof #height)))
				(done_dialog)
				#data$
			)
		)

	)
	;***********************************************************************

	; 高さ一括変更画面表示
	(setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kcmain.dcl")))
	(if (not (new_dialog "SetTOKUCNRCABSizeDlg" #dcl_id)) (exit))

	; 初期表示処理
	(set_tile "txt2"
		(strcat "右側間口=" (rtos (nth 0 &wdh$)) " , 左側間口=" (rtos (nth 1 &wdh$)))
	)
	(set_tile "txt3"
		(strcat "右側奥行=" (rtos (nth 2 &wdh$)) " , 左側奥行=" (rtos (nth 3 &wdh$)))
	)
	(set_tile "txt4"
		(strcat "高さ=" (rtos (nth 4 &wdh$)))
	)

;	(set_tile "edtWT_Width_A" (rtos (nth 0 &wdh$)))
;	(set_tile "edtWT_Width_B" (rtos (nth 1 &wdh$)))
;	(set_tile "edtWT_Depth_C" (rtos (nth 2 &wdh$)))
;	(set_tile "edtWT_Depth_D" (rtos (nth 3 &wdh$)))
;	(set_tile "edtWT_Height" (rtos (nth 4 &wdh$)))
	(set_tile "edtWT_Width_A" "0")
	(set_tile "edtWT_Width_B" "0")
	(set_tile "edtWT_Depth_C" "0")
	(set_tile "edtWT_Depth_D" "0")
	(set_tile "edtWT_Height"  "0")

	(if (= &taisyo "A")
		(progn
			(setq #W_f T)
			(setq #D_f T)
			(setq #H_f T)
		)
		(if (= (strlen &taisyo) 4)
			(progn
				(if (= (substr &taisyo 2 1) "W")
					(setq #W_f T)
					(setq #W_f nil)
				)
				(if (= (substr &taisyo 3 1) "D")
					(setq #D_f T)
					(setq #D_f nil)
				)
				(if (= (substr &taisyo 4 1) "H")
					(setq #H_f T)
					(setq #H_f nil)
				)
			)
			(progn
				(setq #W_f T)
				(setq #D_f T)
				(setq #H_f T)
			)
		)
	)

	(if (= (nth 0 &chk) nil)
		(setq #W_f nil)
	)
	(if (= (nth 1 &chk) nil)
		(setq #D_f nil)
	)
	(if (= (nth 2 &chk) nil)
		(setq #H_f nil)
	)

	(if (= #W_f nil)
		(progn
			(mode_tile "edtWT_Width_A" 1)
			(mode_tile "edtWT_Depth_D" 1)
		)
	)
	(if (= #D_f nil)
		(progn
			(mode_tile "edtWT_Width_B" 1)
			(mode_tile "edtWT_Depth_C" 1)
		)
	)
	(if (= #H_f nil)
		(mode_tile "edtWT_Height" 1)
	)

	(if (not (equal (nth 0 &wdh$) (nth 5 &wdh$) 0.0001))
		(progn
			(mode_tile "edtWT_Width_A" 1)
			(mode_tile "edtWT_Depth_D" 1)
		)
	)
	(if (not (equal (nth 1 &wdh$) (nth 6 &wdh$) 0.0001))
		(progn
			(mode_tile "edtWT_Width_B" 1)
			(mode_tile "edtWT_Depth_C" 1)
		)
	)
	(if (not (equal (nth 4 &wdh$) (nth 7 &wdh$) 0.0001))
		(mode_tile "edtWT_Height" 1)
	)

	; スライド
	(setq #x (dimx_tile "slide1")
				#y (dimy_tile "slide1")
	)
	(start_image "slide1")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\CNR"))
	(end_image)

	(setq #next 99)
	(while (and (/= 1 #next) (/= 0 #next))
		; ボタン押下処理
  	(action_tile "accept" "(setq #ret$ (##SetTOKUCNRCABSize_CallBack))")
  	(action_tile "cancel" "(setq #ret$ nil) (done_dialog 0)")

  	(setq #next (start_dialog))
	)

  (unload_dialog #dcl_id)

	#ret$

);StretchCabW_SetTOKUCNRCABSizeDlg


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_sub
; <処理概要>  : 通常キャビネットの伸縮処理
; <戻り値>    : なし
; <作成>      : 11/12/05 A.Satoh
; <備考>      : コーナーキャビ以外のキャビネットを対象
;*************************************************************************>MOH<
(defun StretchCabW_sub (
  &en         ; 伸縮対象ｼﾝﾎﾞﾙ図形
	&taisyo			; 特注対象
	&chk				; 入力可否チェック
  /
	#sym #err_flag #xd_LSYM$ #xd_SYM$ #xd_TOKU$ #pt #ang #gnam
	#width #depth #height #org_width #org_depth #org_height #org_size$
	#wdh$ #cab_size$ #XLINE_W$ #BrkW #XLINE_D$ #BrkD #XLINE_H$ #BrkH #brk$
	#eD #eDelBRK_W$ #XLINE_W #eDelBRK_D$ #XLINE_D #eDelBRK_H$ #XLINE_H
	#flag #str_flag #expData$ #clayer #sabun
	#hinban #qry$
#doorID  ;-- 2012/03/23 A.Satoh Add
 )
	(setq CG_ORG_Layer$ nil);2017/04/17 YM ADD

	(setq #sym &en)
	(setq #str_flag nil)
	(setq #err_flag nil)
	(setq #XLINE_W$ nil)
	(setq #XLINE_D$ nil)
	(setq #XLINE_H$ nil)

	(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
	(setq #xd_SYM$  (CFGetXData #sym "G_SYM" ))
	(setq #xd_TOKU$ (CFGetXData #sym "G_TOKU"))
	(setq #pt  (cdr (assoc 10 (entget #sym))))      ; ｼﾝﾎﾞﾙ基準点
	(setq #ang (nth 2 #xd_LSYM$))                  ; ｼﾝﾎﾞﾙ配置角度

	;2018/09/05 YM MOD
;;;  (if (equal #ang      0 0.0001) (setq #ang    0)) ;2018/03/12  ;2018/08/30 YM これは有効だが、０以外も対応必要
  (if (equal #ang      0 0.0001) (setq #ang  0.0)) ;2018/03/12  ;2018/08/30 YM これは有効だが、０以外も対応必要
	;2018/09/05 YM MOD

	(setq #gnam (SKGetGroupName #sym))              ; ｸﾞﾙｰﾌﾟ名
	(setq #hinban (nth 5 #xd_LSYM$))
;-- 2012/03/23 A.Satoh Add - S
	(setq #doorID (nth 7 #xd_LSYM$))
;-- 2012/03/23 A.Satoh Add - E
;-- 2012/02/17 A.Satoh Add CG対応 - S
	(setq CG_SizeH (nth 13 #xd_LSYM$))		; 品番図形DBの登録Ｈ寸法値
;-- 2012/02/17 A.Satoh Add CG対応 - E

	; 上基点フラグを有効に設定
	(if (> 0 (nth 10 #xd_SYM$))
		(setq CG_BASE_UPPER T)
	)

	(setq #width  (nth 3 #xd_SYM$))
	(setq #depth  (nth 4 #xd_SYM$))
	(setq #height (nth 5 #xd_SYM$))

	(if #xd_TOKU$
		(progn
			(setq #org_width  (nth 12 #xd_TOKU$))
			(setq #org_depth  (nth 13 #xd_TOKU$))
			(setq #org_height (nth 14 #xd_TOKU$))
		)
		(progn
			(setq #org_width  #width)
			(setq #org_depth  #depth)
			(setq #org_height #height)
		)
	)
	(setq #org_size$ (list #org_width #org_depth #org_height))

	(if (= &taisyo "B")
		(setq #cab_size$ (list #width #depth #height))
		(progn
			; ダイアログ表示
			(setq #wdh$ (list #width #depth #height #org_width #org_depth #org_height))
			(setq #cab_size$ (StretchCabW_SetTOKUCABSizeDlg #sym #wdh$ &taisyo &chk))
			(if (= #cab_size$ nil)
				(setq #err_flag T)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
			(setq #eDelBRK_W$ (PcRemoveBreakLine #sym "W")) ; W方向ブレーク除去
			(setq #eDelBRK_D$ (PcRemoveBreakLine #sym "D")) ; D方向ブレーク除去
			(setq #eDelBRK_H$ (PcRemoveBreakLine #sym "H")) ; H方向ブレーク除去

			; ブレークライン位置を求める
			(if (or (not (equal (car #cab_size$) (nth 3 #xd_SYM$) 0.0001))
							(not (equal (cadr #cab_size$) (nth 4 #xd_SYM$) 0.0001))
							(not (equal (caddr #cab_size$) (nth 5 #xd_SYM$) 0.0001)))
				(progn
					(setq #str_flag T)

					; 指定のシンボル図形をワーク画層に移動する
					(setq #expData$ (StretchCabW_MoveCabToWorkLayer #sym))
					(setq CG_ORG_Layer$ #expData$);元の画層格納 2017/04/17 YM ADD

					; ワーク画層以外を非表示にする
					; 現在画層を取得
					(setq #clayer (getvar "CLAYER"))

					; 引数画層(なければ作成)を現在画層にしてそれ以外をﾌﾘｰｽﾞ 色番号1-255,線種
					(KPSetClayerOtherFreeze "EXP_TEMP_LAYER" 1 SKW_AUTO_LAY_LINE)

				)
			)

			; Ｗ方向
			(if (not (equal (car #cab_size$) (nth 3 #xd_SYM$) 0.0001))
				; Ｗ方向ブレークライン位置を求める
				(setq #XLINE_W$ (StretchCabW_MakeBreakLineW #pt #ang))
;				(progn
;					;;;;; 試験用暫定処理
;					;******************
;					(setq #BrkW (fix (* (fix (nth 3 #xd_SYM$)) 0.5)))
;					(setq #XLINE_W$ (list #BrkW))
;					;******************
;				)
			)

			; Ｄ方向
			(if (not (equal (cadr #cab_size$) (nth 4 #xd_SYM$) 0.0001))
				; Ｄ方向ブレークライン位置を求める
				(setq #XLINE_D$ (StretchCabW_MakeBreakLineD #pt #ang))
;				(progn
;					;;;;; 試験用暫定処理
;					;******************
;					(setq #BrkD (fix (* (fix (nth 4 #xd_SYM$)) 0.5)))
;					(setq #XLINE_D$ (list #BrkD))
;					;******************
;				)
			)

			; Ｈ方向
			(if (not (equal (caddr #cab_size$) (nth 5 #xd_SYM$) 0.0001))
				; Ｈ方向ブレークライン位置を求める
				(setq #XLINE_H$ (StretchCabW_MakeBreakLineH #pt #ang))
;				(progn
;					;;;;; 試験用暫定処理
;					;******************
;					(setq #BrkH (fix (* (fix (nth 5 #xd_SYM$)) 0.5)))
;					(setq #XLINE_H$ (list #BrkH))
;					;******************
;				)
			)

			(if (= #str_flag T)
				(progn
					(setq #str_flag nil)

					; ワーク画層へ移動したシンボルを元の画層に戻す
					(StretchCabW_MoveCabBackOrgLayer #expData$)

					; 図面の表示状態を元に戻す
					(SetLayer)

				  ; 現在画層を戻す
				  (setvar "CLAYER" #clayer)
					(SetLayer)

					(if (and (= #XLINE_W$ nil) (= #XLINE_D$ nil) (= #XLINE_H$ nil))
						(progn
							(CFAlertErr "ブレークラインが設定されていません。\n特注化処理を中断します。")
							(setq #err_flag T)
						)
					)
;-- 2011/12/16 A.Satoh Add - S
					(if (= #err_flag nil)
						(progn
							(if (and (= #XLINE_W$ nil)
										(not (equal (car #cab_size$) (nth 3 #xd_SYM$) 0.0001)))
								(CFAlertMsg "幅方向のブレークラインが設定されていません。\n幅は伸縮されません。")
							)
							(if (and (= #XLINE_D$ nil)
										(not (equal (cadr #cab_size$) (nth 4 #xd_SYM$) 0.0001)))
								(CFAlertMsg "奥行方向のブレークラインが設定されていません。\n奥行は伸縮されません。")
							)
							(if (and (= #XLINE_H$ nil)
										(not (equal (caddr #cab_size$) (nth 5 #xd_SYM$) 0.0001)))
								(CFAlertMsg "高さ方向のブレークラインが設定されていません。\n高さは伸縮されません。")
							)
						)
					)
;-- 2011/12/16 A.Satoh Add - E
				)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (car #cab_size$) (nth 3 #xd_SYM$) 0.0001))
			(if (and #XLINE_W$ (not (equal (car #cab_size$) (nth 3 #xd_SYM$) 0.0001)))
;-- 2011/12/16 A.Satoh Mod - S
				(progn
					(setq #sabun (/ (- (car #cab_size$) (nth 3 #xd_SYM$)) (length #XLINE_W$)))
					(foreach #BrkW #XLINE_W$
						(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
						(CFSetXData #XLINE_W "G_BRK" (list 1))
						(command "-group" "A" #gnam #XLINE_W "")	; ブレークラインのグループ化

       		  (setq CG_TOKU_BW #BrkW)
 	        	(setq CG_TOKU_BD nil)
	   	      (setq CG_TOKU_BH nil)

						; キャビネット本体の伸縮を行う
						;(SKY_Stretch_Parts #sym (car #cab_size$) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))
						(setq #xd_SYM$  (CFGetXData #sym "G_SYM" ))
						(SKY_Stretch_Parts #sym (+ (nth 3 #xd_SYM$) #sabun) (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))

						; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
						(entdel #XLINE_W)

						; 扉図形の伸縮
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #sym) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
				)
			)

;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (cadr #cab_size$) (nth 4 #xd_SYM$) 0.0001))
			(if (and #XLINE_D$ (not (equal (cadr #cab_size$) (nth 4 #xd_SYM$) 0.0001)))
;-- 2011/12/16 A.Satoh Mod - E
				(progn
					(setq #sabun (/ (- (cadr #cab_size$) (nth 4 #xd_SYM$)) (length #XLINE_D$)))
					(foreach #BrkD #XLINE_D$
						(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
						(CFSetXData #XLINE_D "G_BRK" (list 2))

						; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
						(command "-group" "A" #gnam #XLINE_D "")

       	  	(setq CG_TOKU_BW nil)
	 	        (setq CG_TOKU_BD #BrkD)
  	 	      (setq CG_TOKU_BH nil)

						; キャビネット本体の伸縮を行う
						;(SKY_Stretch_Parts #sym (car #cab_size$) (cadr #cab_size$) (nth 5 #xd_SYM$))
						(setq #xd_SYM$  (CFGetXData #sym "G_SYM" ))
						(SKY_Stretch_Parts #sym (nth 3 #xd_SYM$) (+ (nth 4 #xd_SYM$) #sabun) (nth 5 #xd_SYM$))

						; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
						(entdel #XLINE_D)

						; 扉図形の伸縮
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #sym) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
				)
			)

;-- 2011/12/16 A.Satoh Mod - S
;;;;;			(if (not (equal (caddr #cab_size$) (nth 5 #xd_SYM$) 0.0001))
			(if (and #XLINE_H$ (not (equal (caddr #cab_size$) (nth 5 #xd_SYM$) 0.0001)))
;-- 2011/12/16 A.Satoh Mod - E
				(progn
					(setq #sabun (/ (- (caddr #cab_size$) (nth 5 #xd_SYM$)) (length #XLINE_H$)))
					(foreach #BrkH #XLINE_H$
;-- 2011/12/13 A.Satoh Add - S
						(if CG_BASE_UPPER
							(setq #BrkH (- (caddr #pt) #BrkH))
						)
;-- 2011/12/13 A.Satoh Add - E
						(setq #XLINE_H (PK_MakeBreakH #pt #BrkH))
						(CFSetXData #XLINE_H "G_BRK" (list 3))

						; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
						(command "-group" "A" #gnam #XLINE_H "")

       	  	(setq CG_TOKU_BW nil)
	 	        (setq CG_TOKU_BD nil)
  	 	      (setq CG_TOKU_BH #BrkH)

						; キャビネット本体の伸縮を行う
						(setq #xd_SYM$  (CFGetXData #sym "G_SYM" ))
						;(SKY_Stretch_Parts #sym (car #cab_size$) (cadr #cab_size$) (caddr #cab_size$))
						(SKY_Stretch_Parts #sym (nth 3 #xd_SYM$) (nth 4 #xd_SYM$) (+ (nth 5 #xd_SYM$) #sabun))

;-- 2012/03/23 A.Satoh Add : 品番図形DBの登録H寸法値を更新する - S
	    		  (CFSetXData &en "G_LSYM"
	  	    	  (CFModList #xd_LSYM$
		    	  	  (list (list 13 CG_SizeH))
    	    		)
      			)
;-- 2012/03/23 A.Satoh Add : 品番図形DBの登録H寸法値を更新する - E

						; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
						(entdel #XLINE_H)

						; 扉図形の伸縮
						(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #sym) 3 T))

						(KP_TOKU_GROBAL_RESET)
					)
				)
			)

			; 元のﾌﾞﾚｰｸﾗｲﾝ復活
			; W方向
			(foreach #eD #eDelBRK_W$ (if (= (entget #eD) nil) (entdel #eD)))
			; D方向
			(foreach #eD #eDelBRK_D$ (if (= (entget #eD) nil) (entdel #eD)))
			; H方向
			(foreach #eD #eDelBRK_H$ (if (= (entget #eD) nil) (entdel #eD)))

;-- 2012/03/23 A.Satoh Add - S
			(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
			(CFSetXData #sym "G_LSYM" (CFModList #xd_LSYM$ (list (list 7 #doorID))))
;-- 2012/03/23 A.Satoh Add - E

			(setq #qry$
				(CFGetDBSQLRec CG_DBSESSION "特注規格品"
					(list
						(list "品番名称" #hinban 'STR)
					)
				)
			)
			(if (= #qry$ nil)
				(progn
					; 指定のシンボルに対して特注キャビ情報を設定する
					(if (= nil (tblsearch "APPID" "G_TOKU")) (regapp "G_TOKU"))
					(setq #flag (StretchCabW_InputTokuData #sym #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ &chk nil nil))
					(if (= #flag nil)
						(command "_undo" "b")
					)
				)
				(progn
					(princ (strcat "\n★★★★特注規格品 品番名称 = " #hinban))
;-- 2012/02/15 A.Satoh Mod CG対応 - S
					(if (= nil (tblsearch "APPID" "G_REG")) (regapp "G_REG"))
					(InputGRegData &en #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ &chk nil nil)
;-- 2012/02/15 A.Satoh Mod CG対応 - E
				)
			)
		)
	)

;-- 2012/02/17 A.Satoh Add CG対応 - S
	(setq CG_SizeH nil)
	(setq CG_BASE_UPPER nil)
;-- 2012/02/17 A.Satoh Add CG対応 - E
	(princ)

) ;StretchCabW_sub


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_SetTOKUCABSizeDlg
; <処理概要>  : 通常キャビ用特注キャビサイズ変更画面処理を行う
; <戻り値>    : サイズリスト:(間口,奥行,高さ)
;             : nil キャンセル押下
; <作成>      : 11/12/05 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_SetTOKUCABSizeDlg (
	&en		; 対象シンボル図形名
	&wdh$	; サイズ情報リスト
	&taisyo	; 特注対象
	&chk				; 入力可否チェック
  /
	#dcl_id #next #ret$
	#W_f #D_f #H_f
  )

	;***********************************************************************
	; ＯＫボタン押下処理
	; 戻り値:サイズ変更情報リスト (幅 奥行 高さ)
	;***********************************************************************
	(defun ##SetTOKUCNRCABSize_CallBack (
		/
		#err_flg #width #depth #height #data$
		#wk_height  ;-- 2012/02/20 A.Satoh Add
		)

    (setq #err_flg nil)

    ; 幅チェック
		(setq #width (get_tile "edtWT_Width"))
		(if (or (= #width "") (= #width nil))
			(setq #width "")
			(if (or (= (type (read #width)) 'INT) (= (type (read #width)) 'REAL))
				(if (> 0 (read #width))
					(progn
						(set_tile "error" "巾は 99999 以下の数値を入力して下さい")
						(mode_tile "edtWT_Width" 2)
						(setq #err_flg T)
					)
					(if (>= (read #width) 99999)
						(progn
							(set_tile "error" "巾は 99999 以下の数値を入力して下さい")
							(mode_tile "edtWT_Width" 2)
							(setq #err_flg T)
						)
					)
				)
				(progn
					(set_tile "error" "巾は 99999 以下の数値を入力して下さい")
					(mode_tile "edtWT_Width" 2)
					(setq #err_flg T)
				)
			)
		)

		; 奥行チェック
		(if (= #err_flg nil)
			(progn
				(setq #depth (get_tile "edtWT_Depth"))
				(if (or (= #depth "") (= #depth nil))
					(setq #depth "")
					(if (or (= (type (read #depth)) 'INT) (= (type (read #depth)) 'REAL))
						(if (> 0 (read #depth))
							(progn
;-- 2012/01/24 A.Satoh Mod - S
;;;;;								(set_tile "error" "奥行は 1000 未満の数値を入力して下さい")
								(set_tile "error" "奥行は 0 以上の数値を入力して下さい")
;-- 2012/01/24 A.Satoh Mod - E
								(mode_tile "edtWT_Depth" 2)
								(setq #err_flg T)
							)
;-- 2012/01/24 A.Satoh Del - S
;;;;;							(if (>= (read #depth) 1000)
;;;;;								(progn
;;;;;									(set_tile "error" "奥行は 1000 未満の数値を入力して下さい")
;;;;;									(mode_tile "edtWT_Depth" 2)
;;;;;									(setq #err_flg T)
;;;;;								)
;;;;;							)
;-- 2012/01/24 A.Satoh Del - E
						)
						(progn
;-- 2012/01/24 A.Satoh Mod - S
;;;;;							(set_tile "error" "奥行は 1000 未満の数値を入力して下さい")
							(set_tile "error" "奥行は 0 以上の数値を入力して下さい")
;-- 2012/01/24 A.Satoh Mod - E
							(mode_tile "edtWT_Depth" 2)
							(setq #err_flg T)
						)
					)
				)
			)
		)

		; 高さチェック
		(if (= #err_flg nil)
			(progn
				(setq #height (get_tile "edtWT_Height"))
				(if (or (= #height "") (= #height nil))
					(setq #height "")
					(if (or (= (type (read #height)) 'INT) (= (type (read #height)) 'REAL))
						(if (> 0 (read #height))
							(progn
								(set_tile "error" "高さは 99999 以下の数値を入力して下さい")
								(mode_tile "edtWT_Height" 2)
								(setq #err_flg T)
							)
							(if (>= (read #height) 99999)
								(progn
									(set_tile "error" "高さは 99999 以下の数値を入力して下さい")
									(mode_tile "edtWT_Height" 2)
									(setq #err_flg T)
								)
							)
						)
						(progn
							(set_tile "error" "高さは 99999 以下の数値を入力して下さい")
							(mode_tile "edtWT_Height" 2)
							(setq #err_flg T)
						)
					)
				)
			)
		)

		; サイズ変更情報リストの作成
		(if (= #err_flg nil)
			(progn
;-- 2012/02/20 A.Satoh Mod - S
;;;;;				(setq #data$ (list (atof #width) (atof #depth) (atof #height)))
				(setq #wk_height (- (atof #height) CG_SizeH))
				(setq CG_SizeH (atof #height))
				(setq #height (+ (nth 2 &wdh$) #wk_height))
				(setq #data$ (list (atof #width) (atof #depth) #height))
;-- 2012/02/20 A.Satoh Mod - E
				(done_dialog)
				#data$
			)
		)
	)
	;***********************************************************************

;|
	(setq #seigyo$ (StretchCabW_CheckTokuSeigyo &en))
	(setq #sei_W (car   #seigyo$))
	(setq #sei_D (cadr  #seigyo$))
	(setq #sei_H (caddr #seigyo$))
|;

	; 特注キャビサイズ変更画面表示
	(setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kcmain.dcl")))
	(if (not (new_dialog "SetTOKUCABSizeDlg" #dcl_id)) (exit))

	; 初期表示処理
;-- 2012/02/20 A.Satoh Mod - S
;;;;;	(set_tile "txt2"
;;;;;		(strcat "幅=" (rtos (nth 0 &wdh$)) " , 奥行=" (rtos (nth 1 &wdh$)) " , 高さ=" (rtos (nth 2 &wdh$)))
;;;;;	)
	(set_tile "txt2"
		(strcat "幅=" (rtos (nth 0 &wdh$)) " , 奥行=" (rtos (nth 1 &wdh$)) " , 高さ=" (rtos CG_SizeH))
	)
;-- 2012/02/20 A.Satoh Mod - S

	(set_tile "edtWT_Width" (rtos (nth 0 &wdh$)))
	(set_tile "edtWT_Depth" (rtos (nth 1 &wdh$)))
;-- 2012/02/20 A.Satoh Mod - S
;;;;;	(set_tile "edtWT_Height" (rtos (nth 2 &wdh$)))
	(set_tile "edtWT_Height" (rtos CG_SizeH))
;-- 2012/02/20 A.Satoh Mod - E
;|
	;**************************************************
	; 12/8時点での暫定処理
	; 後日、mdb参照による処理に変更
	;**************************************************
	(if (/= CG_DRSeriCode "UF")
		(mode_tile "edtWT_Width" 1)
	)
	;**************************************************
|;

	; 特注対象による入力制御
	(if (= &taisyo "A")
		(progn
			(setq #W_f T)
			(setq #D_f T)
			(setq #H_f T)
		)
		(if (= (strlen &taisyo) 4)
			(progn
				(if (= (substr &taisyo 2 1) "W")
					(setq #W_f T)
					(setq #W_f nil)
				)
				(if (= (substr &taisyo 3 1) "D")
					(setq #D_f T)
					(setq #D_f nil)
				)
				(if (= (substr &taisyo 4 1) "H")
					(setq #H_f T)
					(setq #H_f nil)
				)
			)
			(progn
				(setq #W_f T)
				(setq #D_f T)
				(setq #H_f T)
			)
		)
	)

	(if (= (nth 0 &chk) nil)
		(setq #W_f nil)
	)
	(if (= (nth 1 &chk) nil)
		(setq #D_f nil)
	)
	(if (= (nth 2 &chk) nil)
		(setq #H_f nil)
	)

	(if (= #W_f nil)
		(mode_tile "edtWT_Width" 1)
	)
	(if (= #D_f nil)
		(mode_tile "edtWT_Depth" 1)
	)
	(if (= #H_f nil)
		(mode_tile "edtWT_Height" 1)
	)

	(if (not (equal (nth 0 &wdh$) (nth 3 &wdh$) 0.0001))
		(mode_tile "edtWT_Width" 1)
	)
	(if (not (equal (nth 1 &wdh$) (nth 4 &wdh$) 0.0001))
		(mode_tile "edtWT_Depth" 1)
	)
	(if (not (equal (nth 2 &wdh$) (nth 5 &wdh$) 0.0001))
		(mode_tile "edtWT_Height" 1)
	)

	(setq #next 99)
	(while (and (/= 1 #next) (/= 0 #next))
		; ボタン押下処理
  	(action_tile "accept" "(setq #ret$ (##SetTOKUCNRCABSize_CallBack))")
  	(action_tile "cancel" "(setq #ret$ nil) (done_dialog 0)")

  	(setq #next (start_dialog))
	)

  (unload_dialog #dcl_id)

	#ret$

);StretchCabW_SetTOKUCABSizeDlg


;|
;<HOM>*************************************************************************
; <関数名>    : StretchCabW_CheckTokuSeigyo
; <処理概要>  : 特注制御情報を参照し、方向制御の有無をチェックする
; <戻り値>    : 方向制御リスト:(W方向 D方向 H方向)
; <作成>      : 11/12/08 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_CheckTokuSeigyo (
	&en		; 対象シンボル図形名
  /
  )

	(setq #ret$ nil)

	; 指定のシンボル図形から性格コードを取得
	(setq #xd_LSYM$ (CFGetXData &en "G_LSYM"))
	(setq #seikaku (nth 9 #xd_LSYM$))

	; 特注制御情報を取得する
	(setq #qry$$ (DBSqlAutoQuery CG_DBSESSION "select * from 特注制御")))
	(if (= #qry$$ nil)
		(progn
			; レコードが存在しない場合は、制御なし
			(setq #ret$ (list 0 0 0))
		)
		(progn
			(foreach #qry$ #qry$$
				(setq #seikaku (nth 0 #qry$))
				(if (/= #seikaku "ALL")
					(setq #seikaku$ (StrParse #seikaku ","))
				)
				(setq #seikaku_chk (nth 1 #qry$))
				(setq #door (nth 2 #qry$))
				(if (/= #door "ALL")
					(setq #door$ (StrParse #door ","))
				)
				(setq #door_chk (nth 3 #qry$))
				(setq #houkou$ (StrParse (nth 4 #qry$) ","))
				(setq #seigyo (nth 5 #qry$))

				
			)
		)
	)


	#ret$

);StretchCabW_CheckTokuSeigyo
|;


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_InputTokuData
; <処理概要>  : 指定のシンボルに対して特注キャビ情報を設定する
; <戻り値>    : T:正常終了 nil キャンセル終了
; <作成>      : 11/12/01 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_InputTokuData (
  &sym				; 対象シンボル図形
	&org_size$	; 修正前サイズリスト (幅 奥行 高さ)
	&XLINE_W$
	&XLINE_D$
	&XLINE_H$
	&chk
	&cab_size$
	&flag       ; コーナーキャビ：T    コーナーキャビ以外：nil
  /
	#ret #err_flag #org_width #org_depth #org_height
	#xd_TOKU$ #xd_LSYM$ #xd_SYM$ #XLINE_W$ #XLINE_D$ #XLINE_H$
	#hinban #hinban2 #lr #skk #syuyaku #hin_last #toku_hin
	#qry$$ #qry2$$ #hinban$ #hinban2$
	#maguti1 #maguti2 #maguti3 #oku1 #oku2 #oku3 #height1 #height2 #height3
#hin_last$ #hin_width #hin_depth #hin_takasa  ;-- 2012/02/21 A.Satoh Add
#W_f #D_f #H_f #W_sabun #D_sabun #H_sabun  ;-- 2012/02/22 A.Satoh Add
#str_d #str_c   ;-- 2012/03/16 A.Satoh Add
#DOOR_INFO$ #DRCOLCODE #DRHIKITE #DRSERICODE #RET$ ;2013/08/05 YM ADD
#CG_TOKU_HINBAN #REG_D #REG_H #REG_W #XD_REG$ ;2018/05/17 YM ADD
#BRK_TOKU_W$ #BRK_TOKU_D$ #BRK_TOKU_H$ #BRK_REG_W$ #BRK_REG_D$ #BRK_REG_H$ ;2018/05/25 YM ADD
#HEIGHT1_REG #MAGUTI1_REG #OKU1_REG  ;2018/05/25 YM ADD
  )

	(setq #ret T)
	(setq #err_flag nil)
	(setq #org_width  (nth 0 &org_size$))
	(setq #org_depth  (nth 1 &org_size$))
	(setq #org_height (nth 2 &org_size$))

	;2018/05/18 YM ADD-S G_REG 存在確認
	(setq #xd_REG$ (CFGetXData &sym "G_REG"))
	(if #xd_REG$
		(progn ;G_REG あり
			(setq #org_width  (nth 12 #xd_REG$))
			(setq #org_depth  (nth 13 #xd_REG$))
			(setq #org_height (nth 14 #xd_REG$))
		)
	);_if

	;2018/05/18 YM ADD-E G_REG 存在確認

;-- 2012/02/22 A.Satoh Add - S
	(setq #W_sabun 0.0)
	(setq #D_sabun 0.0)
	(setq #H_sabun 0.0)

	(setq #W_f T)
	(setq #D_f T)
	(setq #H_f T)

	(if (= (nth 0 &chk) nil)
		(setq #W_f nil)
	)
	(if (= (nth 1 &chk) nil)
		(setq #D_f nil)
	)
	(if (= (nth 2 &chk) nil)
		(setq #H_f nil)
	)
;-- 2012/02/22 A.Satoh Add - E

	(setq #xd_TOKU$ (CFGetXData &sym "G_TOKU"))
	(if (= #xd_TOKU$ nil)
		(progn ;G_TOKU なし
			(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
			(if (= #xd_LSYM$ nil)
				(setq #err_flag T)
			)

			(if (= #err_flag nil)
				(progn
					(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
					(if (= #xd_SYM$ nil)
						(setq #err_flag T)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
					(setq #hinban (nth 5 #xd_LSYM$))
					(setq #lr     (nth 6 #xd_LSYM$))
					(setq #skk    (nth 9 #xd_LSYM$))

					(setq #qry$$
						(CFGetDBSQLRec CG_DBSESSION "品番基本"
							(list
								(list "品番名称" #hinban 'STR)
								(list "性格CODE" (itoa (fix #skk)) 'INT)
							)
						)
					)

					(if (/= #qry$$ nil)
						(if (= (length #qry$$) 1)
							(setq #syuyaku (nth 5 (nth 0 #qry$$)))
							(setq #err_flag T)
						)
						(setq #err_flag T)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
;-- 2011/12/14 A.Satoh Mod - S
;;;;;					(setq #qry$$
;;;;;						(CFGetDBSQLRec CG_DBSESSION "品番最終"
;;;;;							(list
;;;;;								(list "品番名称"   #hinban       'STR)
;;;;;								(list "LR区分"     #lr           'STR)
;;;;;								(list "扉シリ記号" CG_DRSeriCode 'STR)
;;;;;								(list "扉カラ記号" CG_DRColCode  'STR)
;;;;;								(list "引手記号"   CG_Hikite     'STR)
;;;;;							)
;;;;;						)
;;;;;					)
;;;;;
;;;;;					(if (/= #qry$$ nil)
;;;;;						(if (= (length #qry$$) 1)
;;;;;							(setq #hin_last (nth 10 (car #qry$$)))
;;;;;							(setq #err_flag T)
;;;;;						)
;;;;;;-- 2011/12/13 A.Satoh Mod - S
;;;;;;						(setq #err_flag T)
;;;;;						(progn
;;;;;							(setq #qry2$$
;;;;;								(CFGetDBSQLRec CG_DBSESSION "品番最終"
;;;;;									(list
;;;;;										(list "品番名称"   #hinban       'STR)
;;;;;										(list "LR区分"     #lr           'STR)
;;;;;										(list "扉シリ記号" CG_DRSeriCode 'STR)
;;;;;										(list "扉カラ記号" CG_DRColCode  'STR)
;;;;;									)
;;;;;								)
;;;;;							)
;;;;;
;;;;;							(if (/= #qry2$$ nil)
;;;;;								(if (= (length #qry2$$) 1)
;;;;;									(setq #hin_last (nth 10 (car #qry2$$)))
;;;;;									(setq #err_flag T)
;;;;;								)
;;;;;								(setq #err_flag T)
;;;;;							)
;;;;;						)
;;;;;;-- 2011/12/13 A.Satoh Mod - E
;;;;;					)
					; 品番名称から括弧を除外
					(setq #hinban2 (KP_DelHinbanKakko #hinban))

					; 最終品番を取得
;-- 2012/02/21 A.Satoh Mod - S
;;;;;					(setq #hin_last (car (StretchCabW_GetHinbanLast #hinban2 #lr)))
;;;;;					(if (= #hin_last nil)
;;;;;						(setq #err_flag T)
;;;;;					)

					;2013/08/05 YM MOD-S
					(setq #Door_Info$     (nth 7 #xd_LSYM$))
					(setq #ret$ (StrParse #Door_Info$ ","))
					(setq #DRSeriCode (car   #ret$))(if (= #DRSeriCode nil)(setq #DRSeriCode ""))
					(setq #DRColCode  (cadr  #ret$))(if (= #DRColCode nil)(setq #DRColCode ""))
					(setq #DRHikite   (caddr #ret$))(if (= #DRHikite nil)(setq #DRHikite ""))

					(if (= #DRSeriCode "")
						(progn
							(setq #DRSeriCode CG_DRSeriCode)
							(setq #DRColCode  CG_DRColCode)
							(setq #DRHikite   CG_Hikite)
						)
					);_if

;;;					(setq #hin_last$ (StretchCabW_GetHinbanLast #hinban2 #lr))
					(setq #hin_last$ (StretchCabW_GetHinbanLast_HIKISU #hinban2 #lr #DRSeriCode #DRColCode #DRHikite))
					;2013/08/05 YM MOD-E

					(if (= #hin_last$ nil)
						(progn
							(setq #hin_last #hinban)
							(setq #hin_width (nth 3 #xd_SYM$))
							(setq #hin_depth (nth 4 #xd_SYM$))
							(setq #hin_takasa (nth 5 #xd_SYM$))
						)
						(progn
							(setq #hin_last (car #hin_last$))
;-- 2012/02/22 A.Satoh Mod - S
;;;;;							(setq #hin_width  (atof (nth 1 #hin_last$)))
;;;;;							(setq #hin_takasa (atof (nth 2 #hin_last$)))
;;;;;							(setq #hin_depth  (atof (nth 3 #hin_last$)))
							(if (= #W_f T)
								(setq #W_sabun (- (nth 3 #xd_SYM$) #org_width))
							)
							(if (= #D_f T)
								(setq #D_sabun (- (nth 4 #xd_SYM$) #org_depth))
							)
							(if (= #H_f T)
								(setq #H_sabun (- (nth 5 #xd_SYM$) #org_height))
							)
							(setq #hin_width  (+ (atof (nth 1 #hin_last$)) #W_sabun))
							(setq #hin_takasa (+ (atof (nth 2 #hin_last$)) #H_sabun))
							(setq #hin_depth  (+ (atof (nth 3 #hin_last$)) #D_sabun))
;-- 2012/02/22 A.Satoh Mod - E
						)
					)
;-- 2012/02/21 A.Satoh Mod - E
;-- 2011/12/14 A.Satoh Mod - E
				)
			)

			(if (= #err_flag nil)
				(progn
		      (setq #qry$$
    		    (CFGetDBSQLRec CG_CDBSESSION "集約名称"
        		  (list
            		(list "集約ID" #syuyaku 'STR)
		          )
    		    )
		      )
					(if (/= #qry$$ nil)
						(if (= (length #qry$$) 1)
							(setq #toku_hin (nth 2 (car #qry$$)))
							(setq #err_flag T)
						)
						(setq #err_flag T)
					)
				)
			)

			;2016/10/06 YM ADD 機器かどうかの判定
			(if (KikiHantei (nth 5 #xd_LSYM$) (nth 9 #xd_LSYM$)) ;品番,性格ｺｰﾄﾞ
				(progn
					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_KIKI)
				)
				;機器以外
				(progn
					;2018/07/27 YM MOD-S
;;;					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN)
					(cond
						((= BU_CODE_0013 "1") ; PSKCの場合
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
						)
						((= BU_CODE_0013 "2") ; PSKDの場合
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
						)
						(T ;それ以外
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
						)
					);_if
					;2018/07/27 YM MOD-E
				)
			);_if
; 2017/11/13 KY ADD-S
; フレームキッチン 集成カウンター対応
			(if (IsFKLWCounter (nth 5 #xd_LSYM$))
				(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_LWCT)
			);if
; 2017/11/13 KY ADD-E

			(if (= #err_flag nil)
				(progn
					(setq #hinban$
						(list
;;;							#toku_hin													; 特注品番
							#CG_TOKU_HINBAN										; 特注品番 2016/08/30 YM MOD (2)
							0																	; 金額
;;;							(strcat "ﾄｸﾁｭｳ(" #hin_last ")")		; 品名
							(strcat "ﾄｸ(" #hin_last ")")      ; 品名 2016/08/30 YM MOD
							""																; 特注コード　特注コード-連番
;-- 2012/02/21 A.Satoh Mod - S
;;;;;							(nth 3 #xd_SYM$)									; 巾
;;;;;							(nth 5 #xd_SYM$)									; 高さ
;;;;;							(nth 4 #xd_SYM$)									; 奥行
							#hin_width												; 巾
							#hin_takasa												; 高さ
							#hin_depth												; 奥行
;-- 2012/02/21 A.Satoh Mod - E
						)
					)
				)
			)
		)
		;else
		(progn ;G_TOKU あり
			(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
			(if (= #xd_LSYM$ nil)
				(setq #err_flag T)
			)

			(if (= #err_flag nil)
				(progn
					(setq #xd_SYM$ (CFGetXData &sym "G_SYM"))
					(if (= #xd_SYM$ nil)
						(setq #err_flag T)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
;-- 2012/02/22 A.Satoh Add - S
					(if (= #W_f T)
						(setq #W_sabun (- (nth 3 #xd_SYM$) #org_width))
					)
					(if (= #D_f T)
						(setq #D_sabun (- (nth 4 #xd_SYM$) #org_depth))
					)
					(if (= #H_f T)
						(setq #H_sabun (- (nth 5 #xd_SYM$) #org_height))
					)
					(setq #hin_width  (+ (nth 4 #xd_TOKU$) #W_sabun))
					(setq #hin_takasa (+ (nth 5 #xd_TOKU$) #H_sabun))
					(setq #hin_depth  (+ (nth 6 #xd_TOKU$) #D_sabun))
;-- 2012/02/22 A.Satoh Add - E

					(setq #hinban$
						(list
							(nth 0 #xd_TOKU$)				; 特注品番
							(fix (nth 1 #xd_TOKU$))	; 金額
							(nth 2 #xd_TOKU$)				; 品名
							(nth 3 #xd_TOKU$)				; 特注コード
;-- 2012/02/22 A.Satoh Add - S
;;;;;;-- 2012/02/21 A.Satoh Mod - S
;;;;;;;;;;							(nth 3 #xd_SYM$)				; 巾
;;;;;;;;;;							(nth 5 #xd_SYM$)				; 高さ
;;;;;;;;;;							(nth 4 #xd_SYM$)				; 奥行
;;;;;							(nth 4 #xd_TOKU$)				; 巾
;;;;;							(nth 5 #xd_TOKU$)				; 高さ
;;;;;							(nth 6 #xd_TOKU$)				; 奥行
;;;;;;-- 2012/02/21 A.Satoh Mod - E
							#hin_width
							#hin_takasa
							#hin_depth
;-- 2012/02/22 A.Satoh Add - E
						)
					)
				)
			)
		)
	);(if (= #xd_TOKU$ nil)

	(if (= #err_flag nil)
		(progn
			; 特注キャビ情報入力画面処理
			(setq #hinban2$ (Toku_HeightChange_SetTokuDataDlg #hinban$))
			(if #hinban2$
				(progn
					(if &XLINE_W$
						(progn
							; ブレークライン位置情報を昇順でソートする
							(setq #XLINE_W$ (SortBrkLineDist &XLINE_W$))

							(setq #maguti1 (car #XLINE_W$))
							(if (= #maguti1 nil)
								(setq #maguti1 0.0)
							)
							(setq #maguti2 (cadr #XLINE_W$))
							(if (= #maguti2 nil)
								(setq #maguti2 0.0)
							)
							(setq #maguti3 (caddr #XLINE_W$))
							(if (= #maguti3 nil)
								(setq #maguti3 0.0)
							)
						)
						(progn
							(setq #maguti1 0.0)
							(setq #maguti2 0.0)
							(setq #maguti3 0.0)
						)
					)
					(if &XLINE_D$
						(progn
							; ブレークライン位置情報を昇順でソートする
							(setq #XLINE_D$ (SortBrkLineDist &XLINE_D$))

							(setq #oku1 (car #XLINE_D$))
							(if (= #oku1 nil)
								(setq #oku1 0.0)
							)
							(setq #oku2 (cadr #XLINE_D$))
							(if (= #oku2 nil)
								(setq #oku2 0.0)
							)
							(setq #oku3 (caddr #XLINE_D$))
							(if (= #oku3 nil)
								(setq #oku3 0.0)
							)
						)
						(progn
							(setq #oku1 0.0)
							(setq #oku2 0.0)
							(setq #oku3 0.0)
						)
					)
					(if &XLINE_H$
						(progn
							; ブレークライン位置情報を昇順でソートする
							(setq #XLINE_H$ (SortBrkLineDist &XLINE_H$))

							(setq #height1 (car #XLINE_H$))
							(if (= #height1 nil)
								(setq #height1 0.0)
							)
							(setq #height2 (cadr #XLINE_H$))
							(if (= #height2 nil)
								(setq #height2 0.0)
							)
							(setq #height3 (caddr #XLINE_H$))
							(if (= #height3 nil)
								(setq #height3 0.0)
							)
						)
						(progn
							(setq #height1 0.0)
							(setq #height2 0.0)
							(setq #height3 0.0)
						)
					)

					; 特注情報(G_TOKU)の設定
					(if #xd_TOKU$
						(progn
;-- 2012/03/16 A.Satoh Add - S
							(if &flag
								(if (> (nth 15 #xd_TOKU$) 0.0)
									(setq #str_d (nth 15 #xd_TOKU$))
									(setq #str_d (nth 3 &cab_size$))
								)
								(setq #str_d (nth 15 #xd_TOKU$))
							)
							(if &flag
								(if (> (nth 16 #xd_TOKU$) 0.0)
									(setq #str_c (nth 16 #xd_TOKU$))
									(setq #str_c (nth 2 &cab_size$))
								)
								(setq #str_c (nth 16 #xd_TOKU$))
							)
;-- 2012/03/16 A.Satoh Add - E

							(CFSetXData &sym "G_TOKU"
								(CFModList #xd_TOKU$
									(list
										(list  0 (nth 0 #hinban2$))													; [ 0]特注品番
										(list  1 (nth 1 #hinban2$))													; [ 1]金額
										(list  2 (nth 2 #hinban2$))													; [ 2]品名
										(list  3 (nth 3 #hinban2$))													; [ 3]特注コード
										(list  4 (nth 4 #hinban2$))													; [ 4]巾
										(list  5 (nth 5 #hinban2$))													; [ 5]高さ
										(list  6 (nth 6 #hinban2$))													; [ 6]奥行
;-- 2012/03/16 A.Satoh Add - S
										(list 15 #str_d)																		; [15]Ｄの伸縮量
										(list 16 #str_c)																		; [16]Ｃの伸縮量
;-- 2012/03/16 A.Satoh Add - E
										(list 17 (nth 3 #xd_SYM$))													; [17]伸縮後図形サイズＷ
										(list 18 (nth 4 #xd_SYM$))													; [18]伸縮後図形サイズＤ
										(list 19 (nth 5 #xd_SYM$))													; [19]伸縮後図形サイズＨ
										(if &XLINE_W$
											(list 20 (list #maguti1 #maguti2 #height3))				; [20]ブレークライン位置Ｗ
											(list 20 (nth 20 #xd_TOKU$))
										)
										(if &XLINE_D$
											(list 21 (list #oku1    #oku2    #oku3))					; [21]ブレークライン位置Ｄ
											(list 21 (nth 21 #xd_TOKU$))
										)
										(if &XLINE_H$
											(list 22 (list #height1 #height2 #height3))				; [22]ブレークライン位置Ｈ
											(list 22 (nth 22 #xd_TOKU$))
										)
									)
								)
							)
						)
						(progn ; "G_TOKU" がない場合


	;2018/05/23 YM ADD-S G_REG 存在確認

	;特注ｺﾏﾝﾄﾞで追加されたﾌﾞﾚｰｸﾗｲﾝ
	(setq #BRK_TOKU_W$ (list #maguti1 #maguti2 #maguti3)) ; [20]ブレークライン位置Ｗ
	(setq #BRK_TOKU_D$ (list #oku1    #oku2    #oku3))    ; [21]ブレークライン位置Ｄ
	(setq #BRK_TOKU_H$ (list #height1 #height2 #height3)) ; [22]ブレークライン位置Ｈ

	(if #xd_REG$
		(progn ;G_REG あり

			;図形が最初から持っているﾌﾞﾚｰｸﾗｲﾝ
			(setq #BRK_REG_W$ (nth 20 #xd_REG$))(setq #maguti1_reg (car #BRK_REG_W$))
			(setq #BRK_REG_D$ (nth 21 #xd_REG$))(setq #oku1_reg    (car #BRK_REG_D$))
			(setq #BRK_REG_H$ (nth 22 #xd_REG$))(setq #height1_reg (car #BRK_REG_H$))

			(if (and (equal #maguti1 0 0.01) (not (equal #maguti1_reg 0 0.01))) (setq #BRK_TOKU_W$ #BRK_REG_W$) )
			(if (and (equal #oku1    0 0.01) (not (equal #oku1_reg    0 0.01))) (setq #BRK_TOKU_D$ #BRK_REG_D$) )
			(if (and (equal #height1 0 0.01) (not (equal #height1_reg 0 0.01))) (setq #BRK_TOKU_H$ #BRK_REG_H$) )

		)
	);_if

;     G_REG があればﾌﾞﾚｰｸﾗｲ位置を入れる


;;;	;2018/05/18 YM ADD-E G_REG 存在確認

							(CFSetXData &sym "G_TOKU"
								(list
									(nth 0 #hinban2$)													; [ 0]特注品番
									(nth 1 #hinban2$)													; [ 1]金額
									(nth 2 #hinban2$)													; [ 2]品名
									(nth 3 #hinban2$)													; [ 3]特注コード
									(nth 4 #hinban2$)													; [ 4]巾
									(nth 5 #hinban2$)													; [ 5]高さ
									(nth 6 #hinban2$)													; [ 6]奥行
									""																				; [ 7]予備１
									""																				; [ 8]予備２
									""																				; [ 9]予備３
									#hinban																		; [10]元品番名称
									#hin_last																	; [11]元最終品番
									#org_width																; [12]元図形サイズＷ
									#org_depth																; [13]元図形サイズＤ
									#org_height																; [14]元図形サイズＨ
;-- 2012/03/16 A.Satoh Mod -S
;;;;;									""																				; [15]予備４
;;;;;									""																				; [16]予備５
									(if &flag
										(nth 3 &cab_size$)											; [15]Ｄの伸縮量
										0.0																			; [15]Ｄの伸縮量
									)
									(if &flag
										(nth 2 &cab_size$)											; [16]Ｃの伸縮量
										0.0																			; [16]Ｃの伸縮量
									)
;-- 2012/03/16 A.Satoh Mod -E
									(nth 3 #xd_SYM$)													; [17]伸縮後図形サイズＷ
									(nth 4 #xd_SYM$)													; [18]伸縮後図形サイズＤ
									(nth 5 #xd_SYM$)													; [19]伸縮後図形サイズＨ

;2018/05/25 YM MOD-S
;;;									(list #maguti1 #maguti2 #maguti3)					; [20]ブレークライン位置Ｗ
;;;									(list #oku1    #oku2    #oku3)						; [21]ブレークライン位置Ｄ
;;;									(list #height1 #height2 #height3)					; [22]ブレークライン位置Ｈ
#BRK_TOKU_W$
#BRK_TOKU_D$
#BRK_TOKU_H$
;2018/05/25 YM MOD-E

								)
							)

						)
					)
				)
				(setq #ret nil)
			)
		)
	);_if

	#ret

);StretchCabW_InputTokuData


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_GetHinbanLast
; <処理概要>  : 指定の品番名称とLR区分より最終品番を求める
; <戻り値>    : 最終品番 or nil
; <作成>      : 11/12/14 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_GetHinbanLast (
	&hinban			; 品番名称（括弧無し）
	&lr					; LR区分
  /
	#flag #ret$ #qry$$ #qry$
  )

	(setq #flag nil)
	(setq #ret$ nil)

	; 品番名称 LR区分 扉シリ記号 扉カラ記号 引手記号 ガス種で検索
	(setq #qry$$
		(CFGetDBSQLRec CG_DBSESSION "品番最終"
			(list
				(list "品番名称"   &hinban       'STR)
				(list "LR区分"     &lr           'STR)
				(list "扉シリ記号" CG_DRSeriCode 'STR)
				(list "扉カラ記号" CG_DRColCode  'STR)
				(list "引手記号"   CG_Hikite     'STR)
				(list "ガス種"     CG_GasType    'STR)
			)
		)
	)

	(if (/= #qry$$ nil)
		(if (= (length #qry$$) 1)
			(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

				;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
				;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加
;-- 2012/02/21 A.Satoh Mod - E
				(setq #flag T)
			)
			(progn
				(princ "\n該当データが複数抽出されました。")
				(princ (strcat "\n★★★★品番名称　 = " &hinban))
				(princ (strcat "\n★★★★LR区分　　 = " &lr))
				(princ (strcat "\n★★★★扉シリ記号 = " CG_DRSeriCode))
				(princ (strcat "\n★★★★扉カラ記号 = " CG_DRColCode))
				(princ (strcat "\n★★★★引手記号　 = " CG_Hikite))
				(princ (strcat "\n★★★★ガス種　　 = " CG_GasType))
				(setq #ret$ nil)
				(setq #flag T)
			)
		)
	)

	; 品番名称 LR区分 扉シリ記号 扉カラ記号 引手記号で検索
	(setq #qry$$
		(CFGetDBSQLRec CG_DBSESSION "品番最終"
			(list
				(list "品番名称"   &hinban       'STR)
				(list "LR区分"     &lr           'STR)
				(list "扉シリ記号" CG_DRSeriCode 'STR)
				(list "扉カラ記号" CG_DRColCode  'STR)
				(list "引手記号"   CG_Hikite     'STR)
			)
		)
	)

	(if (/= #qry$$ nil)
		(if (= (length #qry$$) 1)
			(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

				;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
				;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
				(setq #flag T)
			)
			(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;				(repeat #qry$ #qry$$
				(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
					(if (= #flag nil)
						(if (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil))
							(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

								;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
								;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
								(setq #flag T)
							)
						)
					)
				)
				(if (= #flag nil)
					(progn
						(princ "\n該当データが複数抽出されました。")
						(princ (strcat "\n★★★★品番名称　 = " &hinban))
						(princ (strcat "\n★★★★LR区分　　 = " &lr))
						(princ (strcat "\n★★★★扉シリ記号 = " CG_DRSeriCode))
						(princ (strcat "\n★★★★扉カラ記号 = " CG_DRColCode))
						(princ (strcat "\n★★★★引手記号　 = " CG_Hikite))
						(setq #ret$ nil)
						(setq #flag T)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; 品番名称 LR区分 扉シリ記号 扉カラ記号で検索
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"   &hinban       'STR)
						(list "LR区分"     &lr           'STR)
						(list "扉シリ記号" CG_DRSeriCode 'STR)
						(list "扉カラ記号" CG_DRColCode  'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n該当データが複数抽出されました。")
								(princ (strcat "\n★★★★品番名称　 = " &hinban))
								(princ (strcat "\n★★★★LR区分　　 = " &lr))
								(princ (strcat "\n★★★★扉シリ記号 = " CG_DRSeriCode))
								(princ (strcat "\n★★★★扉カラ記号 = " CG_DRColCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; 品番名称 LR区分 扉シリ記号で検索
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"   &hinban       'STR)
						(list "LR区分"     &lr           'STR)
						(list "扉シリ記号" CG_DRSeriCode 'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n該当データが複数抽出されました。")
								(princ (strcat "\n★★★★品番名称　 = " &hinban))
								(princ (strcat "\n★★★★LR区分　　 = " &lr))
								(princ (strcat "\n★★★★扉シリ記号 = " CG_DRSeriCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; 品番名称 LR区分 扉カラ記号で検索
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"   &hinban      'STR)
						(list "LR区分"     &lr          'STR)
						(list "扉カラ記号" CG_DRColCode 'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n該当データが複数抽出されました。")
								(princ (strcat "\n★★★★品番名称　 = " &hinban))
								(princ (strcat "\n★★★★LR区分　　 = " &lr))
								(princ (strcat "\n★★★★扉カラ記号 = " CG_DRColCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; 品番名称 LR区分 ガス種で検索
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称" &hinban    'STR)
						(list "LR区分"   &lr        'STR)
						(list "ガス種"   CG_GasType 'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
												 (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n該当データが複数抽出されました。")
								(princ (strcat "\n★★★★品番名称　 = " &hinban))
								(princ (strcat "\n★★★★LR区分　　 = " &lr))
								(princ (strcat "\n★★★★ガス種　　 = " CG_GasType))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; 品番名称 LR区分で検索
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称" &hinban 'STR)
						(list "LR区分"   &lr     'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(progn
									(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
													 (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
													 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
													 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
										(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

											;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
											;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
											(setq #flag T)
										)
									)
								)
							)
						)

						(if (= #flag nil)
							(progn
								(princ "\n該当データが複数抽出されました。")
								(princ (strcat "\n★★★★品番名称　 = " &hinban))
								(princ (strcat "\n★★★★LR区分　　 = " &lr))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)


	#ret$

);StretchCabW_GetHinbanLast


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_GetHinbanLast_HIKISU
; <処理概要>  : 指定の品番名称とLR区分より最終品番を求める
; <戻り値>    : 最終品番 or nil
; <作成>      : 11/12/14 A.Satoh
; <備考>      : 2013/08/05 YM ADD 引数の次扉情報で品番最終を検索する
;*************************************************************************>MOH<
(defun StretchCabW_GetHinbanLast_HIKISU (
	&hinban			; 品番名称（括弧無し）
	&lr					; LR区分
	&DRSeriCode ; 扉シリ記号
	&DRColCode  ; 扉カラ記号
	&Hikite     ; 引手記号
  /
	#flag #ret$ #qry$$ #qry$
  )

	(setq #flag nil)
	(setq #ret$ nil)

	; 品番名称 LR区分 扉シリ記号 扉カラ記号 引手記号 ガス種で検索
	(setq #qry$$
		(CFGetDBSQLRec CG_DBSESSION "品番最終"
			(list
				(list "品番名称"   &hinban       'STR)
				(list "LR区分"     &lr           'STR)
				(list "扉シリ記号" &DRSeriCode   'STR)
				(list "扉カラ記号" &DRColCode    'STR)
				(list "引手記号"   &Hikite       'STR)
				(list "ガス種"     CG_GasType    'STR)
			)
		)
	)

	(if (/= #qry$$ nil)
		(if (= (length #qry$$) 1)
			(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

				;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
				;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加
;-- 2012/02/21 A.Satoh Mod - E
				(setq #flag T)
			)
			(progn
				(princ "\n該当データが複数抽出されました。")
				(princ (strcat "\n★★★★品番名称　 = " &hinban))
				(princ (strcat "\n★★★★LR区分　　 = " &lr))
				(princ (strcat "\n★★★★扉シリ記号 = " &DRSeriCode))
				(princ (strcat "\n★★★★扉カラ記号 = " &DRColCode))
				(princ (strcat "\n★★★★引手記号　 = " &Hikite))
				(princ (strcat "\n★★★★ガス種　　 = " CG_GasType))
				(setq #ret$ nil)
				(setq #flag T)
			)
		)
	)

	; 品番名称 LR区分 扉シリ記号 扉カラ記号 引手記号で検索
	(setq #qry$$
		(CFGetDBSQLRec CG_DBSESSION "品番最終"
			(list
				(list "品番名称"   &hinban       'STR)
				(list "LR区分"     &lr           'STR)
				(list "扉シリ記号" &DRSeriCode   'STR)
				(list "扉カラ記号" &DRColCode    'STR)
				(list "引手記号"   &Hikite       'STR)
			)
		)
	)

	(if (/= #qry$$ nil)
		(if (= (length #qry$$) 1)
			(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

				;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
				(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
				;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
				(setq #flag T)
			)
			(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;				(repeat #qry$ #qry$$
				(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
					(if (= #flag nil)
						(if (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil))
							(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

								;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
								(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
								;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
								(setq #flag T)
							)
						)
					)
				)
				(if (= #flag nil)
					(progn
						(princ "\n該当データが複数抽出されました。")
						(princ (strcat "\n★★★★品番名称　 = " &hinban))
						(princ (strcat "\n★★★★LR区分　　 = " &lr))
						(princ (strcat "\n★★★★扉シリ記号 = " &DRSeriCode))
						(princ (strcat "\n★★★★扉カラ記号 = " &DRColCode))
						(princ (strcat "\n★★★★引手記号　 = " &Hikite))
						(setq #ret$ nil)
						(setq #flag T)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; 品番名称 LR区分 扉シリ記号 扉カラ記号で検索
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"   &hinban       'STR)
						(list "LR区分"     &lr           'STR)
						(list "扉シリ記号" &DRSeriCode   'STR)
						(list "扉カラ記号" &DRColCode    'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n該当データが複数抽出されました。")
								(princ (strcat "\n★★★★品番名称　 = " &hinban))
								(princ (strcat "\n★★★★LR区分　　 = " &lr))
								(princ (strcat "\n★★★★扉シリ記号 = " &DRSeriCode))
								(princ (strcat "\n★★★★扉カラ記号 = " &DRColCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; 品番名称 LR区分 扉シリ記号で検索
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"   &hinban       'STR)
						(list "LR区分"     &lr           'STR)
						(list "扉シリ記号" &DRSeriCode   'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n該当データが複数抽出されました。")
								(princ (strcat "\n★★★★品番名称　 = " &hinban))
								(princ (strcat "\n★★★★LR区分　　 = " &lr))
								(princ (strcat "\n★★★★扉シリ記号 = " &DRSeriCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; 品番名称 LR区分 扉カラ記号で検索
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"   &hinban      'STR)
						(list "LR区分"     &lr          'STR)
						(list "扉カラ記号" &DRColCode   'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
												 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n該当データが複数抽出されました。")
								(princ (strcat "\n★★★★品番名称　 = " &hinban))
								(princ (strcat "\n★★★★LR区分　　 = " &lr))
								(princ (strcat "\n★★★★扉カラ記号 = " &DRColCode))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; 品番名称 LR区分 ガス種で検索
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称" &hinban    'STR)
						(list "LR区分"   &lr        'STR)
						(list "ガス種"   CG_GasType 'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
												 (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
												 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil)))
									(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

										;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
										(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
										;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
										(setq #flag T)
									)
								)
							)
						)
						(if (= #flag nil)
							(progn
								(princ "\n該当データが複数抽出されました。")
								(princ (strcat "\n★★★★品番名称　 = " &hinban))
								(princ (strcat "\n★★★★LR区分　　 = " &lr))
								(princ (strcat "\n★★★★ガス種　　 = " CG_GasType))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)

	(if (= #flag nil)
		(progn
			; 品番名称 LR区分で検索
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称" &hinban 'STR)
						(list "LR区分"   &lr     'STR)
					)
				)
			)

			(if (/= #qry$$ nil)
				(if (= (length #qry$$) 1)
					(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

						;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
						(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
						;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
						(setq #flag T)
					)
					(progn
;-- 2012/02/27 A.Satoh Mod - S
;;;;;						(repeat #qry$ #qry$$
						(foreach #qry$ #qry$$
;-- 2012/02/27 A.Satoh Mod - E
							(if (= #flag nil)
								(progn
									(if (and (or (= (nth 2 #qry$) "") (= (nth 2 #qry$) nil))
													 (or (= (nth 3 #qry$) "") (= (nth 3 #qry$) nil))
													 (or (= (nth 4 #qry$) "") (= (nth 4 #qry$) nil))
													 (or (= (nth 5 #qry$) "") (= (nth 5 #qry$) nil)))
										(progn
;-- 2012/02/21 A.Satoh Mod - S
;;;;;											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 12 (car #qry$$))))

											;2013/01/30 YM MOD-S (nth  8 (car #qry$$))を追加
;;;											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$))))
											(setq #ret$ (list (nth 10 (car #qry$$)) (nth 11 (car #qry$$)) (nth 12 (car #qry$$)) (nth 13 (car #qry$$)) (fix (nth  8 (car #qry$$))) ))
											;2013/01/30 YM MOD-E (nth  8 (car #qry$$))を追加

;-- 2012/02/21 A.Satoh Mod - E
											(setq #flag T)
										)
									)
								)
							)
						)

						(if (= #flag nil)
							(progn
								(princ "\n該当データが複数抽出されました。")
								(princ (strcat "\n★★★★品番名称　 = " &hinban))
								(princ (strcat "\n★★★★LR区分　　 = " &lr))
								(setq #ret$ nil)
								(setq #flag T)
							)
						)
					)
				)
			)
		)
	)


	#ret$

);StretchCabW_GetHinbanLast_HIKISU


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_MoveCabToWorkLayer
; <処理概要>  : 指定のシンボル図形をワークレイヤ（"EXP_TEMP_LAYER")へ移動する
; <戻り値>    : 移動図形情報リスト(図形名 元画層名)
; <作成>      : 11/12/08 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_MoveCabToWorkLayer (
	&enSym	; シンボル図形名
  /
	#ss #idx #en #Temp$ #strLayer #expData$
  )

	(setq #expData$ nil)

	(setq #ss (CFGetSameGroupSS &enSym))
	(setq #idx 0)
	(repeat (sslength #ss)
		(setq #en (ssname #ss #idx))
		(setq #Temp$ (entget #en))

		(setq #strLayer (cdr (assoc 8 #Temp$)))
;-- 2011/12/16 A.Satoh Mod - S
;;;;;		(if (or (= (substr #strLayer 1 4) "Z_00") (= (substr #strLayer 1 3) "M_5"))
		(if (or (= (substr #strLayer 1 4) "Z_00") (= (substr #strLayer 1 2) "M_"))
;-- 2011/12/16 A.Satoh Mod - E
			(progn
				; 図形名と画層名を1リストにして格納する(図形名 画層名)
				(setq #expData$ (cons (list #en #strLayer) #expData$))

				; 伸縮対称図形を伸縮処理画層に移動する
				(entmod (subst (cons 8 "EXP_TEMP_LAYER") (assoc 8 #Temp$) #Temp$))
			)
		)

		(setq #idx (1+ #idx))
	)

	#expData$

) ;StretchCabW_MoveCabToWorkLayer


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_MoveCabBackOrgLayer
; <処理概要>  : ワークレイヤのシンボル図形を元レイヤへ戻す
; <戻り値>    : 移動図形情報リスト(図形名 元画層名)
; <作成>      : 11/12/08 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_MoveCabBackOrgLayer (
	&expData$
  /
	#nn #Temp$
  )

	(foreach #nn &expData$ ; 伸縮作業画層から元の画層に図形データを移動する
		(setq #Temp$ (entget (nth 0 #nn) '("*")))
		(entmod (subst (cons 8 (nth 1 #nn)) (cons 8 "EXP_TEMP_LAYER") #Temp$))
	)

	(princ)

) ;StretchCabW_MoveCabBackOrgLayer


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_MakeBreakLineW
; <処理概要>  : Ｗ方向ブレークラインを作成する
; <戻り値>    : Ｗ方向ブレークライン位置リスト
; <作成>      : 11/12/06 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_MakeBreakLineW (
	&base_pnt$	; シンボル挿入基点
	&ang				; 回転角度（ラジアン）
  /
	#orthomode #clayer
	#ret$ #ename$ #cnt #flag #dp #dist #en #pnt$ #ang
  )

	; 直行モードの設定
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)

;	; 現在画層の変更
;	(setq #clayer (getvar "CLAYER"))
;	
;  (command "_layer" "T" "N_BREAKW" "")
;  (command "_layer" "ON" "N_BREAKW" "")
;	(setvar "CLAYER" "N_BREAKW")
;EXP_TEMP_LAYER
	; 視点の変更
	;(command "_vpoint" "0,-1,0")
;-- 2011/12/15 A.Satoh Mod - S
;;;;;	(C:ChgViewFront)
	(setq #ang (fix (rtd &ang)))	; ラジアンを角度に変換
	(cond
		((= #ang 90)
			(C:ChgViewSideR)
		)
		((= #ang 180)
			(C:ChgViewBack)
		)
		((= #ang 270)
			(C:ChgViewSideL)
		)
		(T
			(C:ChgViewFront)
		)
	)
;-- 2011/12/15 A.Satoh Mod - E
	(command "._zoom" "E")
	(command "_.ZOOM" "0.5x")
	(command "_.UCS" "V")

	(setq #ret$ nil)
	(setq #ename$ nil)
	(setq #cnt 0)
	(setq #flag T)
	(setq #pnt$ (trans &base_pnt$ 0 1))

	(while #flag
		(setq #dp (getvar "lastpoint"))
		(princ "\nブレークライン位置を指示/終了[ENTER]：")
		(command ".XLINE" "V" PAUSE)
		(if (= nil (equal 0.0 (distance #dp (getvar "lastpoint")) 0.0001))
			(progn
				(command "")
				(setq #cnt (1+ #cnt))

				(if (>= 2 #cnt)
					(progn
						(setq #ename$ (append #ename$ (list (entlast))))
;						(setq #dist (abs (fix (- (car (getvar "lastpoint")) (car &base_pnt$)))))
						(setq #dist (abs (fix (- (car (getvar "lastpoint")) (car #pnt$)))))
						(setq #ret$ (append #ret$ (list #dist)))
					)
					(progn
						(CFAlertErr "ブレークラインは２箇所以上指示できません")
						(entdel (entlast))
					)
				)
			)
			(setq #flag nil)
		)
	)

	(foreach #en #ename$
		(entdel #en)
	)

	; 視点を戻す
	(command "_.UCS" "W")

	(command "_zoom" "P")
	(command "_zoom" "P")
	(command "_zoom" "P")

	; 直行モードを戻す
  (setvar "ORTHOMODE" #orthomode)
;  (command "_layer" "OF" "N_BREAKW" "")
;
;	; 現在画層を戻す
;	(setvar "CLAYER" #clayer)

	#ret$

) ;StretchCabW_MakeBreakLineW


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_MakeBreakLineD
; <処理概要>  : Ｄ方向ブレークラインを作成する
; <戻り値>    : Ｄ方向ブレークライン位置リスト
; <作成>      : 11/12/06 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_MakeBreakLineD (
	&base_pnt$
	&ang				; 回転角度（ラジアン）
  /
	#orthomode #clayer
	#ret$ #ename$ #cnt #flag #dp #dist #en #pnt$ #ang
  )

	; 直行モードの設定
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)

;	; 現在画層の変更
;	(setq #clayer (getvar "CLAYER"))
;  (command "_layer" "T" "N_BREAKW" "")
;  (command "_layer" "ON" "N_BREAKW" "")
;	(setvar "CLAYER" "N_BREAKW")

	; 視点の変更
	;(command "_vpoint" "1,0,0")
;-- 2011/12/15 A.Satoh Mod - E
;;;;;	(C:ChgViewSideR)
	(setq #ang (fix (rtd &ang)))	; ラジアンを角度に変換
	(cond
		((= #ang 90)
			(C:ChgViewBack)
		)
		((= #ang 180)
			(C:ChgViewSideL)
		)
		((= #ang 270)
			(C:ChgViewFront)
		)
		(T
			(C:ChgViewSideR)
		)
	)
;-- 2011/12/15 A.Satoh Mod - E
	(command "._zoom" "E")
	(command "_.ZOOM" "0.5x")
	(command "_.UCS" "V")

	(setq #ret$ nil)
	(setq #ename$ nil)
	(setq #cnt 0)
	(setq #flag T)
	(setq #pnt$ (trans &base_pnt$ 0 1))

	(while #flag
		(setq #dp (getvar "lastpoint"))
		(princ "\nブレークライン位置を指示/終了[ENTER]：")
		(command ".XLINE" "V" PAUSE)
		(if (= nil (equal 0.0 (distance #dp (getvar "lastpoint")) 0.0001))
			(progn
				(command "")
				(setq #cnt (1+ #cnt))

				(if (>= 2 #cnt)
					(progn
						(setq #ename$ (append #ename$ (list (entlast))))
;						(setq #dist (abs (fix (- (car (getvar "lastpoint")) (car &base_pnt$)))))
						(setq #dist (abs (fix (- (car (getvar "lastpoint")) (car #pnt$)))))
						(setq #ret$ (append #ret$ (list #dist)))
					)
					(progn
						(CFAlertErr "ブレークラインは２箇所以上指示できません")
						(entdel (entlast))
					)
				)
			)
			(setq #flag nil)
		)
	)

	(foreach #en #ename$
		(entdel #en)
	)

	; 視点を戻す
	(command "_.UCS" "W")

	(command "_zoom" "P")
	(command "_zoom" "P")
	(command "_zoom" "P")

	; 直行モードを戻す
  (setvar "ORTHOMODE" #orthomode)
;  (command "_layer" "OF" "N_BREAKW" "")
;
;	; 現在画層を戻す
;	(setvar "CLAYER" #clayer)

	#ret$

) ;StretchCabW_MakeBreakLineD


;<HOM>*************************************************************************
; <関数名>    : StretchCabW_MakeBreakLineH
; <処理概要>  : Ｈ方向ブレークラインを作成する
; <戻り値>    : Ｈ方向ブレークライン位置リスト
; <作成>      : 11/12/06 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun StretchCabW_MakeBreakLineH (
	&base_pnt$
	&ang				; 回転角度（ラジアン）
  /
	#orthomode #clayer
	#ret$ #ename$ #cnt #flag #dp #dist #en #pnt$ #ang
  )

	; 直行モードの設定
  (setq #orthomode (getvar "ORTHOMODE"))
  (setvar "ORTHOMODE" 1)

;	; 現在画層の変更
;	(setq #clayer (getvar "CLAYER"))
;  (command "_layer" "T" "N_BREAKW" "")
;  (command "_layer" "ON" "N_BREAKW" "")
;	(setvar "CLAYER" "N_BREAKW")

	; 視点の変更
	;(command "_vpoint" "0,-1,0")
;-- 2011/12/15 A.Satoh Mod - S
;;;;;	(C:ChgViewFront)
	(setq #ang (fix (rtd &ang)))	; ラジアンを角度に変換
	(cond
		((= #ang 90)
			(C:ChgViewSideR)
		)
		((= #ang 180)
			(C:ChgViewBack)
		)
		((= #ang 270)
			(C:ChgViewSideL)
		)
		(T
			(C:ChgViewFront)
		)
	)
;-- 2011/12/15 A.Satoh Mod - E
	(command "._zoom" "E")
	(command "_.ZOOM" "0.5x")
	(command "_.UCS" "V")

	(setq #ret$ nil)
	(setq #ename$ nil)
	(setq #cnt 0)
	(setq #flag T)
	(setq #pnt$ (trans &base_pnt$ 0 1))

	(while #flag
		(setq #dp (getvar "lastpoint"))
		(princ "\nブレークライン位置を指示/終了[ENTER]：")
		(command ".XLINE" "H" PAUSE)
		(if (= nil (equal 0.0 (distance #dp (getvar "lastpoint")) 0.0001))
			(progn
				(command "")
				(setq #cnt (1+ #cnt))

				(if (>= 2 #cnt)
					(progn
						(setq #ename$ (append #ename$ (list (entlast))))
;						(setq #dist (abs (fix (- (cadr (getvar "lastpoint")) (cadr &base_pnt$)))))
						(setq #dist (abs (fix (- (cadr (getvar "lastpoint")) (cadr #pnt$)))))
						(setq #ret$ (append #ret$ (list #dist)))
					)
					(progn
						(CFAlertErr "ブレークラインは２箇所以上指示できません")
						(entdel (entlast))
					)
				)
			)
			(setq #flag nil)
		)
	)

	(foreach #en #ename$
		(entdel #en)
	)

	; 視点を戻す
	(command "_.UCS" "W")

	(command "_zoom" "P")
	(command "_zoom" "P")
	(command "_zoom" "P")

	; 直行モードを戻す
  (setvar "ORTHOMODE" #orthomode)
;  (command "_layer" "OF" "N_BREAKW" "")
;
;	; 現在画層を戻す
;	(setvar "CLAYER" #clayer)

	#ret$

) ;StretchCabW_MakeBreakLineH
;-- 2011/12/05 A.Satoh Add - E


;<HOM>*************************************************************************
; <関数名>    : StretchCab_sub
; <処理概要>  : 特注ｷｬﾋﾞｺﾏﾝﾄﾞ(引数=ｼﾝﾎﾞﾙ名)バージョン
; <戻り値>    : なし
; <作成>      : 02/10/21 YM
; <備考>      : NAS用 特注ｷｬﾋﾞｺﾏﾝﾄﾞ
;*************************************************************************>MOH<
(defun StretchCab_sub (
  &SYM
  /
  #EN #HINBAN #LR #LXD$ #SYS$ #XD$
  )
  ; 前処理
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)

  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
  (setq CG_TOKU T); 特注ｷｬﾋﾞ実行中
  (KP_TOKU_GROBAL_RESET)
  (setq CG_BASE_UPPER nil)

  (if (and &SYM (= 'ENAME (type &SYM))) ; ｼﾝﾎﾞﾙ
    (progn
      (setq #LXD$ (CFGetXData &SYM "G_LSYM"))
      (setq #HINBAN (nth 5 #LXD$))
      (setq #LR     (nth 6 #LXD$))
      (setq #XD$ (CFGetXData &SYM "G_SYM"))

      ; 特注寸法ﾃｰﾌﾞﾙを検索 01/10/09 YM MOD-S @@@@@@@@@@@@@@@@@@@@@
      (if (setq CG_QRY$ (GetTokuDim #HINBAN #LR)) ; ｸﾞﾛｰﾊﾞﾙ
        (progn ; ｷｬﾋﾞﾈｯﾄ伸縮実行(ﾚｺｰﾄﾞがある場合のみ対象)
          (PcStretchCab_N &SYM)
          (setq #en nil)
        )
        (progn ; 特注寸法ﾃｰﾌﾞﾙにﾚｺｰﾄﾞがない場合
          (setq #en nil) ; 02/07/09 YM MOD
          ; 02/07/09 YM ADD-S 品番,価格変更ﾀﾞｲｱﾛｸﾞを表示する
          (KPGetHinbanMoney &SYM)
        )
      );_if
      ; 特注寸法ﾃｰﾌﾞﾙを検索 01/10/09 YM MOD-E @@@@@@@@@@@@@@@@@@@@@

    )
    (progn
      (CFAlertMsg "この図形は処理対象にできません")
      (setq #en T)
    )
  );_if


  ; 後処理
  (CFCmdDefFinish)
  (PKEndCOMMAND #sys$)
  (setq CG_TOKU nil)
  (setq CG_TOKU_BW nil)
  (setq CG_TOKU_BD nil)
  (setq CG_TOKU_BH nil)
  (setq CG_QRY$  nil)
  (KP_TOKU_GROBAL_RESET)

  (setq CG_BASE_UPPER nil)
  (princ)

); StretchCab_sub

;<HOM>*************************************************************************
; <関数名>    : C:StretchCab
; <処理概要>  : キャビネット伸縮処理
; <戻り値>    : なし
; <作成>      : 01/10/09 YM
; <備考>      : NAS用 特注ｷｬﾋﾞｺﾏﾝﾄﾞ
;*************************************************************************>MOH<
(defun C:StretchCab (
  /
  #EN #HINBAN #LR #LXD$ #SYM #SYS$ #XD$
  )

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
      (defun TempErr ( msg / #msg )
        (setq CG_TOKU nil)
        (setq CG_TOKU_BW nil)
        (setq CG_TOKU_BD nil)
        (setq CG_TOKU_BH nil)
        (setq CG_QRY$  nil)
        (KP_TOKU_GROBAL_RESET)
        (setq CG_BASE_UPPER nil)
        (command "_undo" "b")
        (setq *error* nil)
        (princ)
      )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

  ; 前処理
  (setq *error* TempErr)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")

  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
  (setq CG_TOKU T); 特注ｷｬﾋﾞ実行中
  (KP_TOKU_GROBAL_RESET)
  (setq CG_BASE_UPPER nil)

  (setq #en 'T)
  (while #en
    (setq #sym nil)
    (setq #en (car (entsel "\n処理対象のキャビネットを選択 : ")))
    (if #en (setq #sym (CFSearchGroupSym #en)))

    (if #sym ; ｼﾝﾎﾞﾙが存在
      (progn
        (setq #LXD$ (CFGetXData #sym "G_LSYM"))
        (setq #HINBAN (nth 5 #LXD$))
        (setq #LR     (nth 6 #LXD$))
        (setq #XD$ (CFGetXData #sym "G_SYM"))

        ; 特注寸法ﾃｰﾌﾞﾙを検索 01/10/09 YM MOD-S @@@@@@@@@@@@@@@@@@@@@
        (if (setq CG_QRY$ (GetTokuDim #HINBAN #LR)) ; ｸﾞﾛｰﾊﾞﾙ
          (progn ; ｷｬﾋﾞﾈｯﾄ伸縮実行(ﾚｺｰﾄﾞがある場合のみ対象)
            (PcStretchCab_N #sym)
            (setq #en nil)
          )
          (progn ; 特注寸法ﾃｰﾌﾞﾙにﾚｺｰﾄﾞがない場合
            (setq #en nil) ; 02/07/09 YM MOD
            ; 02/07/09 YM ADD-S 品番,価格変更ﾀﾞｲｱﾛｸﾞを表示する
            (KPGetHinbanMoney #sym)
          )
        );_if
        ; 特注寸法ﾃｰﾌﾞﾙを検索 01/10/09 YM MOD-E @@@@@@@@@@@@@@@@@@@@@

      )
      (progn
        (CFAlertMsg "この図形は処理対象にできません")
        (setq #en T)
      )
    );_if

  );while

  ;04/05/26 YM ADD
  (command "_REGEN")

  ; 後処理
  (setq *error* nil)
  (CFCmdDefFinish)
  (PKEndCOMMAND #sys$)
  (setq CG_TOKU nil)
  (setq CG_TOKU_BW nil)
  (setq CG_TOKU_BD nil)
  (setq CG_TOKU_BH nil)
  (setq CG_QRY$  nil)
  (KP_TOKU_GROBAL_RESET)

  (setq CG_BASE_UPPER nil)
  (princ)

); C:StretchCab

;<HOM>*************************************************************************
; <関数名>    : C:RegularCab
; <処理概要>  : 特注ｷｬﾋﾞﾈｯﾄを元のｷｬﾋﾞﾈｯﾄに戻す
; <戻り値>    : なし
; <作成>      : 
; <備考>      : 
;*************************************************************************>MOH<
(defun C:RegularCab (
  /
	#cmdecho #osmode #sys$
	#ss #sym$ #eCH #FIG$ #en
	#xd_LSYM$ #xd_TOKU$ #pt #ang
	#org_w #org_d #org_h #str_w #str_d #str_h
#xd_REG$	;-- 2012/02/16 A.Satoh Add CG対応
#hin_last$  ;-- 2012/02/22 A.Satoh Add
  )

	;****************************************************
	; エラー処理
	;****************************************************
  (defun RegularCabUndoErr( &msg )
    (command "_undo" "b")
    (CFCmdDefFinish)
    (setq *error* nil)
    (princ)
  )
	;****************************************************

  (setq *error* RegularCabUndoErr)
	(command "_UNDO" "M")
	(command "_UNDO" "A" "OFF")
	(setq #cmdecho (getvar "CMDECHO"))
	(setq #osmode (getvar "OSMODE"))
	(setvar "CMDECHO" 0)
	(setvar "OSMODE" 0)
  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
	(setq CG_REGULAR nil)

  (setq CG_BASESYM (CFGetBaseSymXRec))

	; 部材選択処理を行う
;-- 2012/02/15 A.Satoh Mod CG対応 - S
;;;;;	(setq #ss (RegularCab_ItemSel '(()("G_TOKU")) CG_InfoSymCol))
	(setq #ss (RegularCab_ItemSel '(()("G_TOKU" "G_REG")) CG_InfoSymCol))
;-- 2012/02/15 A.Satoh Mod CG対応 - E

	; 選択した部材の色を元に戻し、部材のシンボル図形名リストを返す
	(setq #sym$ (Toku_HeightChange_ChangeItemColor #ss '(()("G_LSYM")) nil))

	; 特注部材を伸縮前の部材（標準部材）に入れ替える
	(foreach #eCH #sym$
		(setq #xd_LSYM$ (CFGetXData #eCH "G_LSYM"))
		(setq #pt (cdr (assoc 10 (entget #eCH))))
		(setq #ang (nth 2 #xd_LSYM$))
		(setq #xd_TOKU$ (CFGetXData #eCH "G_TOKU"))
;-- 2012/02/15 A.Satoh Mod CG対応 - S
;;;;;		(setq #org_w (nth 12 #xd_TOKU$))
;;;;;		(setq #org_d (nth 13 #xd_TOKU$))
;;;;;		(setq #org_h (nth 14 #xd_TOKU$))
;;;;;		(setq #str_w (nth 17 #xd_TOKU$))
;;;;;		(setq #str_d (nth 18 #xd_TOKU$))
;;;;;		(setq #str_h (nth 19 #xd_TOKU$))
		(if #xd_TOKU$ 
			(progn
				(setq #org_w (nth 12 #xd_TOKU$))
				(setq #org_d (nth 13 #xd_TOKU$))
				(setq #org_h (nth 14 #xd_TOKU$))
				(setq #str_w (nth 17 #xd_TOKU$))
				(setq #str_d (nth 18 #xd_TOKU$))
				(setq #str_h (nth 19 #xd_TOKU$))
			)
			(progn
				(setq #xd_REG$ (CFGetXData #eCH "G_REG"))
				(setq #org_w (nth 12 #xd_REG$))
				(setq #org_d (nth 13 #xd_REG$))
				(setq #org_h (nth 14 #xd_REG$))
				(setq #str_w (nth 17 #xd_REG$))
				(setq #str_d (nth 18 #xd_REG$))
				(setq #str_h (nth 19 #xd_REG$))
			)
		)
;-- 2012/02/15 A.Satoh Mod CG対応 - E
		(if (or (/= #org_w #str_w) (/= #org_d #str_d) (/= #org_h #str_h))
			(progn
;-- 2012/02/24 A.Satoh Add - S
;-- 2012/02/22 A.Satoh Add - S
;;;;;					(setq #hin_last$ (StretchCabW_GetHinbanLast (nth 5 #xd_LSYM$) (nth 6 #xd_LSYM$)))
;;;;;					(if (= #hin_last$ nil)
;;;;;						(progn
;;;;;							(setq #hin_width  #org_w)
;;;;;							(setq #hin_takasa #org_d)
;;;;;							(setq #hin_depth  #org_h)
;;;;;						)
;;;;;						(progn
;;;;;							(setq #hin_width  (atof (nth 1 #hin_last$)))
;;;;;							(setq #hin_takasa (atof (nth 2 #hin_last$)))
;;;;;							(setq #hin_depth  (atof (nth 3 #hin_last$)))
;;;;;						)
;;;;;					)
;-- 2012/02/22 A.Satoh Add - E
				(setq #hin_last$
					(CFGetDBSQLRec CG_DBSESSION "品番図形"
						(list
							(list "品番名称" (nth  5 #xd_LSYM$)        'STR)
							(list "LR区分"   (nth  6 #xd_LSYM$)        'STR)
							(list "用途番号" (itoa (nth 12 #xd_LSYM$)) 'INT)
						)
					)
				)
				(if (and #hin_last$ (= 1 (length #hin_last$)))
					(progn
						(setq #hin_width  (nth 3 (car #hin_last$)))
						(setq #hin_depth  (nth 4 (car #hin_last$)))
						(setq #hin_takasa (nth 5 (car #hin_last$)))
					)
					(progn
						(setq #hin_width  #org_w)
						(setq #hin_depth  #org_h)
						(setq #hin_takasa #org_d)
					)
				)
;-- 2012/02/24 A.Satoh Add - E

;-- 2012/02/23 A.Satoh Add - S
				; 陰線処理時に扉の伸縮が不正。
; 強制的にワイヤフレーム表示に変更する。
				(C:2DWire)
;-- 2012/02/23 A.Satoh Add - E

				(setq #FIG$
					(list
						(nth 5 #xd_LSYM$)
						(nth 0 #xd_LSYM$)
						0
						(nth 12 #xd_LSYM$)
						(nth 6 #xd_LSYM$)
;-- 2012/02/22 A.Satoh Mod - S
;;;;;						#org_w
;;;;;						#org_d
;;;;;						#org_h
						#hin_width
						#hin_depth
						#hin_takasa
;-- 2012/02/22 A.Satoh Mod - E
						(nth 9 #xd_LSYM$)
						""
						(nth 8 #xd_LSYM$)
						(nth 15 #xd_LSYM$)
					)
				)
				(setq CG_REGULAR T)
				(setq #en (PcSetItem "CHG" nil #FIG$ #pt #ang nil #eCH))
				(setq #eCH nil)
			)
			(progn
				(if #xd_TOKU$
					(CFSetXData #eCH "G_TOKU" nil)
				)
				(if #xd_REG$
					(CFSetXData #eCH "G_REG" nil)
				)
			)
		)
	)

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

  (CFCmdDefFinish)
  (PKEndCOMMAND #sys$)
	(setvar "CMDECHO" #cmdecho)
	(setvar "OSMODE" #osmode)
	(setq CG_REGULAR nil)
	(setq *error* nil)

;  (alert "★★★　工事中　★★★")

  (princ)
);C:RegularCab


;-- 2011/12/03 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : RegularCab_ItemSel
; <処理概要>  : 高さ一括変更対象の部材選択を行う
; <戻り値>    : 選択部材の選択セット or nil(未選択)
; <作成>      : 11/11/30 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun RegularCab_ItemSel (
	&XDataLst$$
	&iCol
  /
	#enp #pp1 #pp2 #en #ssRet #ss #sswork #gmsg #i #ii #setflag
	#engrp #ssgrp #xd$ #ENR
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
    (if #pp1 
			(progn
      	(setq #en #enp)
	      ;選択点にｵﾌﾞｼﾞｪｸﾄあり
  	    (if (car #en)
    	    (progn
      	    ;選択ｵﾌﾞｼﾞｪｸﾄを選択ｾｯﾄに加算
        	  (setq #ss (ssadd))
          	(ssadd (car #en) #ss)
	        )
  	      (progn
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
          	        (progn
            	        (setq #sswork (ssget "W" #pp1 #pp2))
              	      (setq #ss (ItemSurplus #sswork &XDataLst$$))
                	    (setq #sswork  nil)
                  	)
	                  ;右→左
  	                (progn
    	                (setq #ss (ssget "C" #pp1 #pp2))
      	            )
        	        )
          	    )
            	  ;右ﾎﾞﾀﾝ押下
              	(progn
                	(princ "\n窓の指定が無効です.")
	                (setq #gmsg "\nアイテムを選択: もう一方のｺｰﾅｰを指定:")
  	            )
    	        )
      	    )
        	)
	      )
  	  )
		)

    ;---------------------------------------------
    ;選択アイテムの色を変える
    ;---------------------------------------------
    (if #ss
			(progn
				; 選択したアイテムが特注部材であるかをチェックする
				(setq #ssGrp (RegularCab_CheckItemToku #ss))

				; 選択したアイテムの色を選択色(RED)に変える
				(if #ssGrp
	      	(setq #ssGrp (ChangeItemColor #ssGrp &XDataLst$$ &iCol))
				)

      	;色を変えたｱｲﾃﾑを戻り値選択ｾｯﾄへ加算
	      (setq #i 0)
  	    (repeat (sslength #ssGrp)
    	    (ssadd (ssname #ssGrp #i) #ssRet)
      	  (setq #i (1+ #i))
      	)

				; 選択したアイテムが品番基本に登録されているかをチェック
  	    ;選択ｾｯﾄあり且つ色変更したアイテムが無い場合、選択不可のアイテムとみなす。
    	  (if (and (> (sslength #ss) 0) (<= (sslength #ssGrp) 0))
      	  (CFAlertErr "このアイテムは選択できません。")
	      )
  	    (setq #ss nil)
    	  (setq #ssGrp nil)
	    )
		)
  )

  ;*********************************************
  ; 対象除去ｱｲﾃﾑ選択
  ;*********************************************
  (setq #enR 'T)
  ;右ﾎﾞﾀﾝ押下or戻り値選択ｾｯﾄがなくなったら終了
  (while (and #enR (> (sslength #ssRet) 0))
    (setq #enR (car (entsel "\n対象から除くアイテムを選択:")))
    ;戻り値選択ｾｯﾄのﾒﾝﾊﾞｰのみ処理する。
    (if (and #enR (ssmemb #enR #ssRet))
			(progn
	      ;一時的に選択ｾｯﾄを作成
  	    (setq #sswork (ssadd))
    	  (ssadd #enR #sswork)
      	;選択ｱｲﾃﾑの色を戻す
	      (setq #ssGrp (ChangeItemColor #sswork &XDataLst$$ nil))
  	    ;色を戻したｱｲﾃﾑを戻り値選択ｾｯﾄから除去
    	  (setq #i 0)
      	(repeat (sslength #ssGrp)
        	(ssdel (ssname #ssGrp #i) #ssRet)
	        (setq #i (1+ #i))
  	    )
    	  (setq #sswork nil)
      	(setq #ssGrp nil)
	    )
		)
  )

  #ssRet

);RegularCab_ItemSel


;<HOM>*************************************************************************
; <関数名>    : RegularCab_CheckItemToku
; <処理概要>  : 選択したアイテムが特注部材であるかどうかをチェックする
; <戻り値>    : 特注部材選択セット or nil
; <作成>      : 11/12/03 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun RegularCab_CheckItemToku (
  &ss
  /
	#ssRet #idx #idx2 #en #engrp #ssGrp
  )

	(setq #ssRet (ssadd))
	(setq #idx 0)

	(repeat (sslength &ss)
		(setq #en (ssname &ss #idx))
		(if (not (ssmemb #en #ssRet))
;-- 2012/02/15 A.Satoh Mod CG対応 - S
;;;;;			(if (and (setq #engrp (SearchGroupSym #en))
;;;;;							 (setq #ssGrp (CFGetSameGroupSS #engrp))
;;;;;							 (CheckXData #engrp (list "G_TOKU")))
			(if (and (setq #engrp (SearchGroupSym #en))
							 (setq #ssGrp (CFGetSameGroupSS #engrp))
							 (or (CheckXData #engrp (list "G_TOKU"))
							     (CheckXData #engrp (list "G_REG"))))
;-- 2012/02/15 A.Satoh Mod CG対応 - E
				(progn
					;戻り値選択ｾｯﾄに加算
					(setq #idx2 0)
					(repeat (sslength #ssGrp)
						(ssadd (ssname #ssGrp #idx2) #ssRet)
						(setq #idx2 (1+ #idx2))
					)
					(setq #ssGrp nil)
				)
			)
		)
		(setq #idx (1+ #idx))
	)

	#ssRet

);RegularCab_CheckItemToku
;-- 2011/12/03 A.Satoh Add - E


;<HOM>*************************************************************************
; <関数名>    : C:Toku_HeightChange
; <処理概要>  : ﾌﾟﾗﾝごと一括して高さ変更する(ﾐｶﾄﾞｹｺﾐ伸縮)
; <戻り値>    : なし
; <作成>      : 
; <備考>      : ﾐｶﾄﾞｹｺﾐ伸縮ｺﾏﾝﾄﾞと似ているがｹｺﾐではなく扉面を伸縮する
;*************************************************************************>MOH<
(defun C:Toku_HeightChange (
  /
	#BASESYM #err_flag #cmdecho #osmode
	#planinfo$ #wt_height #size #ss #sym$$ #buzai$$ #action
	#flag
  )

	;****************************************************
	; エラー処理
	;****************************************************
	(defun TempErr ( msg / #msg )
		(command "_undo" "b")
		(setvar "CMDECHO" #cmdecho)
		(setvar "OSMODE" #osmode)
;-- 2012/02/20 A.Satoh Add CG対応 - S
		(setq CG_SizeH nil)
;-- 2012/02/20 A.Satoh Add CG対応 - E
		(setq *error* nil)
		(princ)
	)
	;****************************************************

	; 前処理
	(setq *error* TempErr)
	(command "_UNDO" "M")
	(command "_UNDO" "A" "OFF")
	(setq #cmdecho (getvar "CMDECHO"))
	(setq #osmode (getvar "OSMODE"))
	(setvar "CMDECHO" 0)
	(setvar "OSMODE" 0)

	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)

	; SERIES別データベースへの接続
	(if (= CG_DBSESSION nil)
		(progn
			(princ "\n☆☆☆ SERIES別データベースへの再接続 ☆☆☆")
			(setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
		)
	)

	; データベースへの再接続
	; 再接続失敗時の処理
	(if (= CG_DBSESSION nil)
		(progn
			(princ "\n☆☆☆ セッション再取得 ☆☆☆")
      (princ (strcat "\n☆☆☆　asilisp.arxを再ロードしてDBにCONNECT　☆☆☆"))

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
			)

			(setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))
		)
	)
	(princ "\n☆☆☆　CG_DBSESSION　☆☆☆ :")(princ CG_DBSESSION)

	(setq #BASESYM (CFGetBaseSymXRec)) ; 基準ｱｲﾃﾑ
	(setq #err_flag nil)

	; 高さ一括変更画面処理を行う
	(setq #size (Toku_HeightChange_SelectStrechSizeDlg))
	(if (= #size nil)
		(setq #err_flag T)
	)

	;2013/04/01 YM ADD-S
	(Kakunin)
	;2013/04/01 YM ADD-E

	(if (= #err_flag nil)
		(progn
			; 部材選択処理を行う
			(setq #ss (Toku_HeightChange_ItemSel '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) CG_InfoSymCol #size))

			; 選択部材の色を元に戻す
			(setq #sym$$ (Toku_HeightChange_ChangeItemColor #ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) nil))

			; 選択したアイテムの処理情報を取得
			(setq #buzai$$ (Toku_HeightChange_GetItemHinbanKihon #sym$$ #size))

;-- 2012/02/23 A.Satoh Add - S
			; 陰線処理時に扉の伸縮が不正。
      ; 強制的にワイヤフレーム表示に変更する。
			(C:2DWire)
;-- 2012/02/23 A.Satoh Add - E

			; 部材の伸縮または移動を行う
			(TokuBuzaiStretch #buzai$$ #size)

			; 特注キャビ情報入力
			(if (= nil (tblsearch "APPID" "G_TOKU")) (regapp "G_TOKU"))
			(setq #flag T)
			(foreach #buzai$ #buzai$$
				(if (= #flag T)
					(progn
						(setq #action (cadr #buzai$))
						(if (/= #action "M")
							(progn
								(setq #flag (TokuCab_InputTokuData #buzai$ #size #BASESYM))
								(if (= #flag nil)
									(command "_undo" "b")
								)
							)
						)
					)
				)
			)
		)
	)
;-- 2012/02/20 A.Satoh Add CG対応 - S
	(setq CG_SizeH nil)
;-- 2012/02/20 A.Satoh Add CG対応 - E
	(setvar "CMDECHO" #cmdecho)
	(setvar "OSMODE" #osmode)
	(setq *error* nil)

;  (alert "★★★　工事中　★★★")

  (princ)
);C:Toku_HeightChange


;<HOM>*************************************************************************
; <関数名>    : Kakunin
; <処理概要>  : 高さ一括変更のときに下台EPが存在すればメッセージを表示する
; <戻り値>    : なし
; <作成>      : 2013/04/01 YM ADD
; <備考>      :
;*************************************************************************>MOH<
(defun Kakunin (
  /
	#BASE_FLG #ENSS$ #I #SKK$
  )
	(setq #BASE_FLG nil);下台EP存在ﾌﾗｸﾞ
	
  (setq #enSS$ (ssget "X" '((-3 ("G_LSYM")))))
  (setq #i 0)
  (repeat (sslength #enSS$)
		(ssname #enSS$ #i)
    (setq #skk$ (CFGetSymSKKCode (ssname #enSS$ #i) nil))
    (if (and (= (car #skk$) CG_SKK_ONE_SID)(= (cadr #skk$) CG_SKK_TWO_BAS))
      (setq #BASE_FLG T) ;下台があれば T
    );_if
;;;    (if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) CG_SKK_TWO_UPP))
;;;      (setq #UPPER_FLG T);上台があれば T
;;;    );_if
    (setq #i (1+ #i))
  );repeat

	;下台EPが存在すればメッセージ表示
	(if #BASE_FLG
		(CFYesDialog "\必要に応じてエンドパネルの高さ変更を行なって下さい。")
	);_if
	(princ)
);Kakunin

;-- 2011/11/25 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : Toku_HeightChange_SelectStrechSizeDlg
; <処理概要>  : 高さ一括変更画面からの指定により、伸縮高さを求める
; <戻り値>    : 天板高さ80cm：-50mm伸縮
;             : 天板高さ90cm：50mm伸縮
;             : キャンセルボタン押下：nil
; <作成>      : 11/11/25 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_SelectStrechSizeDlg (
  /
	#dcl_id #next #ret
  )

	;***********************************************************************
	; ＯＫボタン押下処理
	; 戻り値:伸縮サイズ(50 or -50)
	;***********************************************************************
	(defun ##SelectStrechSize_CallBack (
		/
		#err_flag #size #wt_80 #wt_90
		)

		(setq #err_flag nil)
		(setq #size nil)

		(setq #wt_80 (get_tile "WT80"))
		(setq #wt_90 (get_tile "WT90"))

		; 入力チェック
		; ラジオボタンが選択されていない
		(if (and (= #wt_80 "0") (= #wt_90 "0"))
			(progn
				(set_tile "error" "天板高さが選択されていません。")
				(setq #err_flag T)
			)
		)

		(if (= #err_flag nil)
			(progn
				(if (= #wt_80 "1")
					(setq #size -50)
					(setq #size 50)
				)

				(done_dialog 1)
			)
		)

		#size
	)
	;***********************************************************************

	; 高さ一括変更画面表示
	(setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kcmain.dcl")))
	(if (not (new_dialog "SelectStrechSizeDlg" #dcl_id)) (exit))

	(setq #next 99)
	(while (and (/= 1 #next) (/= 0 #next))
		; ボタン押下処理
  	(action_tile "accept" "(setq #ret (##SelectStrechSize_CallBack))")
  	(action_tile "cancel" "(setq #ret nil) (done_dialog 0)")

  	(setq #next (start_dialog))
	)

  (unload_dialog #dcl_id)

	#ret

);Toku_HeightChange_SelectStrechSizeDlg


;<HOM>*************************************************************************
; <関数名>    : Toku_HeightChange_ItemSel
; <処理概要>  : 高さ一括変更対象の部材選択を行う
; <戻り値>    : 選択部材の選択セット or nil(未選択)
; <作成>      : 11/11/30 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_ItemSel (
	&XDataLst$$
	&iCol
	&size
  /
	#enp #pp1 #pp2 #en #ssRet #ss #sswork #gmsg #i #ii #setflag
	#engrp #ssgrp #xd$
	#Item$ #err_flag #enR
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
    (if #pp1 
			(progn
      	(setq #en #enp)
	      ;選択点にｵﾌﾞｼﾞｪｸﾄあり
  	    (if (car #en)
    	    (progn
      	    ;選択ｵﾌﾞｼﾞｪｸﾄを選択ｾｯﾄに加算
        	  (setq #ss (ssadd))
          	(ssadd (car #en) #ss)
	        )
  	      (progn
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
          	        (progn
            	        (setq #sswork (ssget "W" #pp1 #pp2))
              	      (setq #ss (ItemSurplus #sswork &XDataLst$$))
                	    (setq #sswork  nil)
                  	)
	                  ;右→左
  	                (progn
    	                (setq #ss (ssget "C" #pp1 #pp2))
      	            )
        	        )
          	    )
            	  ;右ﾎﾞﾀﾝ押下
              	(progn
                	(princ "\n窓の指定が無効です.")
	                (setq #gmsg "\nアイテムを選択: もう一方のｺｰﾅｰを指定:")
  	            )
    	        )
      	    )
        	)
	      )
  	  )
		)

    ;---------------------------------------------
    ;選択アイテムの色を変える
    ;---------------------------------------------
    (if #ss
			(progn
				; 選択したアイテムが品番基本に登録されているか否かをチェック
				(setq #Item$ (Toku_HeightChange_CheckItemHinbanKihon #ss &size))
				(setq #ssGrp (car #Item$))
				(setq #err_flag (cadr #Item$))

				(if #ssGrp
	      	(setq #ssGrp (ChangeItemColor #ssGrp &XDataLst$$ &iCol))
				)

      	;色を変えたｱｲﾃﾑを戻り値選択ｾｯﾄへ加算
	      (setq #i 0)
  	    (repeat (sslength #ssGrp)
    	    (ssadd (ssname #ssGrp #i) #ssRet)
      	  (setq #i (1+ #i))
      	)

				; 選択したアイテムが品番基本に登録されているかをチェック
  	    ;選択ｾｯﾄあり且つ色変更したアイテムが無い場合、選択不可のアイテムとみなす。
    	  (if (and (> (sslength #ss) 0) (<= (sslength #ssGrp) 0))
					(if (= #err_flag 0)
						(CFAlertErr "このアイテムは選択できません。")
						(CFAlertErr "既に高さ変更が行われています。")
					)
	      )
  	    (setq #ss nil)
    	  (setq #ssGrp nil)
	    )
		)
  )

  ;*********************************************
  ; 対象除去ｱｲﾃﾑ選択
  ;*********************************************
  (setq #enR 'T)
  ;右ﾎﾞﾀﾝ押下or戻り値選択ｾｯﾄがなくなったら終了
  (while (and #enR (> (sslength #ssRet) 0))
    (setq #enR (car (entsel "\n対象から除くアイテムを選択:")))
    ;戻り値選択ｾｯﾄのﾒﾝﾊﾞｰのみ処理する。
    (if (and #enR (ssmemb #enR #ssRet))
			(progn
	      ;一時的に選択ｾｯﾄを作成
  	    (setq #sswork (ssadd))
    	  (ssadd #enR #sswork)
      	;選択ｱｲﾃﾑの色を戻す
	      (setq #ssGrp (ChangeItemColor #sswork &XDataLst$$ nil))
  	    ;色を戻したｱｲﾃﾑを戻り値選択ｾｯﾄから除去
    	  (setq #i 0)
      	(repeat (sslength #ssGrp)
        	(ssdel (ssname #ssGrp #i) #ssRet)
	        (setq #i (1+ #i))
  	    )
    	  (setq #sswork nil)
      	(setq #ssGrp nil)
	    )
		)
  )

  #ssRet

);Toku_HeightChange_ItemSel


;<HOM>*************************************************************************
; <関数名>    : Toku_HeightChange_ChangeItemColor
; <処理概要>  : 選択部材を所定の色に変更し、対象のシンボルリストを返す
; <戻り値>    : シンボルリスト
; <作成>      : 11/12/01
; <備考>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_ChangeItemColor(
	&ss
	&XDataLst$$
	&iCol
  /
	#ss #engrp$ #ssdum #idx #idx2 #engrp #ssGrp #en
  )

	; 選択セットに含まれる部材の色を変更する
	(setq #ss (ChangeItemColor &ss &XDataLst$$ &iCol))

	(setq #engrp$ nil)
	(setq #ssdum (ssadd))
	(setq #idx 0)

	(repeat (sslength #ss)
		(setq #en (ssname #ss #idx))
		(if (not (ssmemb #en #ssdum))
			(if (and (setq #engrp (SearchGroupSym #en))				; ｼﾝﾎﾞﾙあり
							 (setq #ssGrp (CFGetSameGroupSS #engrp)))	; ｸﾞﾙｰﾌﾟ全体
		 		(progn
					(setq #engrp$ (cons #engrp #engrp$))
					(setq #idx2 0)
					(repeat (sslength #ssGrp)
						(ssadd (ssname #ssGrp #idx2) #ssdum)
						(setq #idx2 (1+ #idx2))
					)
					(setq #ssGrp nil)
				)
				(progn
					(setq #engrp$ (cons #en #engrp$))
					(ssadd #en #ssdum)
				)
			)
		)
		(setq #idx (1+ #idx))
	)

	#engrp$

);Toku_HeightChange_ChangeItemColor


;<HOM>*************************************************************************
; <関数名>    : Toku_HeightChange_CheckItemHinbanKihon
; <処理概要>  : 選択したアイテムが品番基本に登録されて且つ高さ変更の対象で
;             : であるかをチェックする
; <戻り値>    : 高さ変更対象アイテム選択セット or nil
; <作成>      : 11/11/30 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_CheckItemHinbanKihon (
  &ss
	&size
  /
	#ssRet #idx #idx2 #idx3 #en #en2 #enR
	#sym #engrp #ssGrp #xd_LSYM$ #hinban #seikaku #action
	#qry$$ #xd_WRKT$ #sswork #xd_SYM$
	#err_flag #xd_TOKU$ #org_height #str_height
  )

	(setq #ssRet (ssadd))
	(setq #idx 0)
	(setq #err_flag 0)

	(repeat (sslength &ss)
		(setq #en (ssname &ss #idx))
		(if (not (ssmemb #en #ssRet))
			(if (and (setq #sym (SearchGroupSym #en))
							 (setq #ssGrp (CFGetSameGroupSS #sym)))
				(progn
					(setq #xd_TOKU$ (CFGetXData #sym "G_TOKU"))
					(if (/= #xd_TOKU$ nil)
						(progn
							(setq #org_height (nth 14 #xd_TOKU$))		; 元図形サイズＨ
							(setq #str_height (nth 19 #xd_TOKU$))		; 伸縮後図形サイズＨ
							; 図形サイズＨ(高さ)が伸縮されていれば高さ変更を行わない
							(if (not (equal #org_height #str_height 0.0001))
								(setq #err_flag 1)
							)
						)
;-- 2011/12/16 A.Satoh Add - S
						(progn
							(setq #xd_SYM$ (CFGetXData #sym "G_SYM"))
							(if #xd_SYM$
								(if (not (equal (nth 13 #xd_SYM$) 0.0 0.0001))
									(setq #err_flag 1)
								)
								(setq #err_flag 1)
							)
						)
;-- 2011/12/16 A.Satoh Add - E
					)

					(if (= #err_flag 0)
						(progn
							(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
							(if #xd_LSYM$
								(progn
									(setq #hinban (nth 5 #xd_LSYM$))
									(setq #seikaku (nth 9 #xd_LSYM$))

									(setq #qry$$
										(CFGetDBSQLRec CG_DBSESSION "品番基本"
											(list
												(list "品番名称" #hinban 'STR)
												(list "性格CODE" (itoa (fix #seikaku)) 'INT)
											)
										)
									)

									(if (/= #qry$$ nil)
										(if (= (length #qry$$) 1)
											(progn
												(if (> 0 &size)
													(setq #action (nth 8 (nth 0 #qry$$)))
													(setq #action (nth 9 (nth 0 #qry$$)))
												)
												(if (/= #action "X")
													(progn
														;戻り値選択ｾｯﾄに加算
														(setq #idx2 0)
														(repeat (sslength #ssGrp)
															(ssadd (ssname #ssGrp #idx2) #ssRet)
															(setq #idx2 (1+ #idx2))
														)
														(setq #ssGrp nil)
													)
												)
											)
										)
									)
								)
							)
						)
					)
				)
				(if (setq #xd_WRKT$ (CFGetXData #en "G_WRKT"))
					(progn
						; 視点を上に設定
						(command "vpoint" "0,0,1")
						(setq #sswork (Toku_HeightChange_PCW_ChColWTItemSSret #en))

						; 視点を戻す
						(command "zoom" "p")

						(if (/= (setq #enR (nth 49 #xd_WRKT$)) "")
							; BG図形を選択セットに加算
							(ssadd #enR #ssRet)
						)
						(if (/= (setq #enR (nth 50 #xd_WRKT$)) "")
							; FG図形を選択セットに加算
							(ssadd #enR #ssRet)
						)

						; ワークトップを選択セットに加算
						(ssadd #en #ssRet)

						(setq #idx2 0)
						(repeat (sslength #sswork)
							(setq #en2 (ssname #sswork #idx2))
							(if (not (ssmemb #en2 #ssRet))
								(cond
									;ｸﾞﾙｰﾌﾟｱｲﾃﾑ ｼﾝｸなど
									((and (setq #engrp (SearchGroupSym #en2))
												(setq #ssGrp (CFGetSameGroupSS #engrp))
												(CheckXData #engrp (list "G_LSYM")))
										;戻り値選択ｾｯﾄに加算
										(setq #idx3 0)
										(repeat (sslength #ssGrp)
											(ssadd (ssname #ssGrp #idx3) #ssRet)
											(setq #idx3 (1+ #idx3))
										)
										(setq #ssGrp nil)
									)
									(T; ﾊﾞｯｸｶﾞｰﾄﾞなど
										; 選択ｾｯﾄに加算
										(ssadd (ssname #sswork #idx2) #ssRet)
									)
								)
							)
							(setq #idx2 (1+ #idx2))
						)
						(setq #sswork nil)
					)
				)
			)
		)

		(setq #idx (1+ #idx))
	)

	(list #ssRet #err_flag)

);Toku_HeightChange_CheckItemHinbanKihon


;<HOM>*************************************************************************
; <関数名>    : Toku_HeightChange_PCW_ChColWTItemSSret
; <処理概要>  : ワークトップを渡して、WT,BG,FG,及びそれらの底面図形+水栓穴の
;             : 選択セットを返す
;             : 元関数である「PCW_ChColWTItemSSret」は色変えを行うが、本関数は
;             : 色変えを行わない
; <戻り値>    : 選択セット
; <作成>      : 11/12/05 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_PCW_ChColWTItemSSret (
  &wtEn  ;(ENAME)WT図形
  /
	#ssRet #xd_WRKT$ #tei #pt$ #pt2$ #sym$ #sym #hole
	#ssGrp #idx #G_WTR$ #G_WTR #cut1 #cut2 #cut3 #cut4
  )

	(setq #ssRet (ssadd)) ; 戻り値選択ｾｯﾄ

	(setq #xd_WRKT$ (CFGetXData &wtEn "G_WRKT"))
	(ssadd &wtEn #ssRet)
	(ssadd (nth 38 #xd_WRKT$) #ssRet) ; WT底面

	; [60]外形も加える START
	(if (and (nth 59 #xd_WRKT$) (/= "" (nth 59 #xd_WRKT$)) (entget (nth 59 #xd_WRKT$)))
		(ssadd (nth 59 #xd_WRKT$) #ssRet) ; WT底面
	)

	; WT底面図形ﾊﾝﾄﾞﾙ
	(setq #tei (nth 38 #xd_WRKT$))

	; 外形点列
	(setq #pt$ (GetLWPolyLinePt #tei))

	; 終点の次に始点を追加して領域を囲う
	(setq #pt2$ (append #pt$ (list (car #pt$))))

	; 領域に含まれる、シンク,水栓を検索する
	(setq #sym$ (PKGetSinkSuisenSymCP #pt2$))
	(foreach #sym #sym$
		(if (= (nth 9 (CFGetXData #sym "G_LSYM")) CG_SKK_INT_SNK)
			(progn
				(setq #hole (nth 3 (CFGetXData #sym "G_SINK")))
				(if (and #hole (/= #hole "")(entget #hole))
					(ssadd #hole #ssRet)
				)
			)
		)

		(setq #ssGrp (CFGetSameGroupSS #sym))
		(setq #idx 0)
		(repeat (sslength #ssGrp)
			(ssadd (ssname #ssGrp #idx) #ssRet)
			(setq #idx (1+ #idx))
		)
		(setq #ssGrp nil)
	)

	; 領域に含まれる水栓穴"G_WTR"ﾘｽﾄ
	(setq #G_WTR$ (PKGetG_WTRCP #pt2$)) 
	(foreach #G_WTR #G_WTR$
		(ssadd #G_WTR #ssRet)
	)

	(setq #cut1 (nth 60 #xd_WRKT$))
	(if (and #cut1 (/= #cut1 "") (handent #cut1) (entget (handent #cut1)))
		(ssadd (handent #cut1) #ssRet)
	)

	(setq #cut2 (nth 61 #xd_WRKT$))
	(if (and #cut2 (/= #cut2 "") (handent #cut2) (entget (handent #cut2)))
		(ssadd (handent #cut2) #ssRet)
	)

	(setq #cut3 (nth 62 #xd_WRKT$))
	(if (and #cut3 (/= #cut3 "") (handent #cut3) (entget (handent #cut3)))
		(ssadd (handent #cut3) #ssRet)
	)

	(setq #cut4 (nth 63 #xd_WRKT$))
	(if (and #cut4 (/= #cut4 "") (handent #cut4) (entget (handent #cut4)))
		(ssadd (handent #cut4) #ssRet)
	)

	; BG1
	(if (/= (nth 49 #xd_WRKT$) "")
		(progn
			(ssadd (nth 49 #xd_WRKT$) #ssRet)

			(if (= (cdr (assoc 0 (entget (nth 49 #xd_WRKT$)))) "3DSOLID")
				(ssadd (nth  1 (CFGetXData (nth 49 #xd_WRKT$) "G_BKGD")) #ssRet)
			)
		)
	)

	; BG2
	(if (/= (nth 50 #xd_WRKT$) "")
		(progn
			(ssadd (nth 50 #xd_WRKT$) #ssRet)

			(if (= (cdr (assoc 0 (entget (nth 50 #xd_WRKT$)))) "3DSOLID")
				(ssadd (nth 1 (CFGetXData (nth 50 #xd_WRKT$) "G_BKGD")) #ssRet)
			)
		)
	)

	; FG1
	(if (/= (nth 51 #xd_WRKT$) "")
		(ssadd (nth 51 #xd_WRKT$) #ssRet)
	)

	; FG2
	(if (/= (nth 52 #xd_WRKT$) "")
		(ssadd (nth 52 #xd_WRKT$) #ssRet)
	)

	; 水栓穴  上で処理をした
	(setq #idx 23)
	(repeat (nth 22 #xd_WRKT$)
		(if (nth #idx #xd_WRKT$)
			(if (entget (nth #idx #xd_WRKT$))
				(ssadd (nth #idx #xd_WRKT$) #ssRet)
			)
		)
		(setq #idx (1+ #idx))
	)

  #ssRet

);Toku_HeightChange_PCW_ChColWTItemSSret


;<HOM>*************************************************************************
; <関数名>    : Toku_HeightChange_GetItemHinbanKihon
; <処理概要>  : 選択したアイテムに該当するブレークライン位置をが品番基本から
;             : 取得する
; <戻り値>    : 部材図形名とブレークライン、集約ID情報リスト
;             :  ((図形名 "S30" "A20") (図形名 "M" "A30")・・(図形名 "S30" "A40"))
; <作成>      : 11/12/01 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_GetItemHinbanKihon (
  &en$
	&size
  /
	#ret$ #idx #en #xd_LSYM$ #xd_SYM$ #XD_WRKT$ #hinban #seikaku
	#qry$$ #syuyaku #action #width #depth #height
  )

	(setq #ret$ nil)
	(setq #idx 0)

	(repeat (length &en$)
		(setq #en (nth #idx &en$))
		(setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
		(if #xd_LSYM$
			(progn
				(setq #xd_SYM$ (CFGetXData #en "G_SYM"))
				(setq #hinban (nth 5 #xd_LSYM$))
				(setq #seikaku (nth 9 #xd_LSYM$))
				(setq #width  (nth 3 #xd_SYM$))
				(setq #depth  (nth 4 #xd_SYM$))
				(setq #height (nth 5 #xd_SYM$))

				; シンクおよび水栓は対象に含めない
				(if (and (/= #seikaku CG_SKK_INT_SUI)
								 (/= #seikaku CG_SKK_INT_SNK))
					(progn
						(setq #qry$$
							(CFGetDBSQLRec CG_DBSESSION "品番基本"
								(list
									(list "品番名称" #hinban 'STR)
									(list "性格CODE" (itoa (fix #seikaku)) 'INT)
								)
							)
						)

						(if (/= #qry$$ nil)
							(if (= (length #qry$$) 1)
								(progn
									(setq #syuyaku (nth 5 (car #qry$$)))
									(if (> 0 &size)
										(setq #action (nth 8 (car #qry$$)))
										(setq #action (nth 9 (car #qry$$)))
									)

									(setq #ret$ (append #ret$ (list (list #en #action #syuyaku (list #width #depth #height)))))
								)
							)
						)
					)
				)
			)
			(if (setq #xd_WRKT$ (CFGetXData #en "G_WRKT"))
				(setq #ret$ (append #ret$ (list (list #en "M" "" '()))))
			)
		)
		(setq #idx (1+ #idx))
	)

	#ret$

);Toku_HeightChange_GetItemHinbanKihon


;<HOM>*************************************************************************
; <関数名>    : TokuBuzaiStretch
; <処理概要>  : 指定部材の伸縮・移動を行う
; <戻り値>    : なし
; <作成>      : 11/12/01 A.Satoh
; <備考>      : 12/2 時点ではH方向のみ対応
;             : 特注キャビ対応時にW方向、D方向も合わせて対応
;*************************************************************************>MOH<
(defun TokuBuzaiStretch (
  &buzai$$
	&size
  /
	#sym #action #buzai$
	#ss #ss_arw #buf #iCol #xd_WRKT$ #sswork 	#en
	#idx #ssdum #engrp #ssGrp #idx2 #xd$ #wt_flg
	#xd_SYM$ #xd_LSYM$
	#str_width #str_depth #str_height #pt #ang #gnam #eD
	#BrkW #eDelBRK_W$ #XLINE_W
	#BrkD #eDelBRK_D$ #XLINE_D
	#BrkH #eDelBRK_H$ #XLINE_H
#doorID  ;-- 2012/03/23 A.Satoh Add
#CG_SizeH ;2013/01/07 YM ADD
#HINBAN #QRY$ #SKK #TOKU_KIGO ;2013/11/04 YM ADD
  )

	(foreach #buzai$ &buzai$$
		(setq #sym (car #buzai$))
		(setq #action (cadr #buzai$))
		(setq #wt_flg nil)
		(setq #xd_WRKT$ nil)

		(if (= #action "M")
			(progn
				; 部材をサイズ分Ｚ方向に移動する
				; シンボル図形を元に移動する選択セットを求める
				(cond
					((CFGetXData #sym "G_LSYM")
						(setq #ss (CFGetSameGroupSS #sym))
					)
					((setq #xd_WRKT$ (CFGetXData #sym "G_WRKT"))
						(setq #wt_flg T)

						; 視点を上に設定
						(command "vpoint" "0,0,1")

						; ワークトップに紐付く図形選択セットを求める
						(setq #ss (Toku_HeightChange_PCW_ChColWTItemSSret #sym))

						; 視点を戻す
						(command "zoom" "p")
					)
				)

				(if #ss
					(progn
						; 基準アイテムがあり、基準アイテムが指定部材に含まれる場合
						; 矢印も移動する
						(if (and (CFGetXRecord "BASESYM")
										 (ssmemb (handent (car (CFGetXRecord "BASESYM"))) #ss))
							(progn
								(setq #ss_arw (ssget "X" '((-3 ("G_ARW"))))) ; 矢印も移動する
								(CMN_ssaddss #ss_arw #ss)
							)
						)

						; Ｚ方向にサイズ分移動する
						(setq #buf (strcat "0,0," (rtos &size)))
						(command "._MOVE" #ss "" "0,0,0" #buf)
					)
				)

				(if (= #wt_flg T)
					; ワークトップ取付高さを修正する
          (CFSetXData #sym "G_WRKT" (CFModList #xd_WRKT$ (list (list 8 (+ (nth 8 #xd_WRKT$) &size)))))
				)
			)
			(progn
				; 部材をサイズ分Ｚ方向に伸縮する
				(setq CG_BASE_UPPER nil)
				(setq CG_POS_STR nil)
				(setq CG_TOKU nil)

        (setq #xd_SYM$ (CFGetXData #sym "G_SYM"))
;-- 2012/02/20 A.Satoh Del - S
;;;;;;-- 2012/02/17 A.Satoh Add CG対応 - S
;;;;;				(setq CG_SizeH (nth 5 #xd_SYM$))
;;;;;;-- 2012/02/17 A.Satoh Add CG対応 - E
;-- 2012/02/20 A.Satoh Del - E
				(setq #str_width  (nth 3 #xd_SYM$))	; 伸縮後巾　　☆☆☆←特注キャビ対応時に修正
				(setq #str_depth  (nth 4 #xd_SYM$))	; 伸縮後奥行　☆☆☆←特注キャビ対応時に修正
				(setq #str_height (+ (nth 5 #xd_SYM$) &size))	; 伸縮後高さ
				(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))

				;2013/11/04  YM ADD-S DEEP食洗の場合に警告を表示する
				(setq #hinban (nth 5 #xd_LSYM$));品番
				(setq #SKK (nth 9 #xd_LSYM$));性格ｺｰﾄﾞ
				;;;・ディープ食洗の判定　性格コード１１０ かつ 品番基本の特注対象が"X"でない場合
				(if (equal #SKK 110 0.001)
					(progn
					  (setq #qry$
					    (CFGetDBSQLRec CG_DBSESSION "品番基本"
					      (list
					        (list "品番名称" #hinban 'STR)
					      )
					    )
					  )
					  (if (and #qry$ (= 1 (length #qry$)))
							(progn
								(setq #TOKU_KIGO (nth 10 (car #qry$))) ;特注対象
								(if (/= "X" #TOKU_KIGO)
									;DEEP食洗を含むかどうか?
									(if (= 50 &size) ;H900の場合
										(CFYesDialog "\nケコミパネルを特注品番に置き換えてください。")
									);_if
								);_if
							)
						);_if
					)
				);_if
				;2013/11/04 YM ADD-E DEEP食洗の場合に警告を表示する

				(setq #pt (cdr (assoc 10 (entget #sym))))      ; ｼﾝﾎﾞﾙ基準点
				(setq #ang (nth 2 #xd_LSYM$))                  ; ｼﾝﾎﾞﾙ配置角度
;-- 2012/03/23 A.Satoh Add - S
				(setq #doorID (nth 7 #xd_LSYM$))
;-- 2012/03/23 A.Satoh Add - E
				(setq #gnam (SKGetGroupName #sym))             ; ｸﾞﾙｰﾌﾟ名
;-- 2012/02/20 A.Satoh Add CG対応 - S
;;; 2013/01/07YM@MOD				(setq CG_SizeH (nth 13 #xd_LSYM$))
;;; 2013/01/07YM@MOD				(setq CG_SizeH (+ CG_SizeH &size))
;-- 2012/02/20 A.Satoh Add CG対応 - E

;2013/01/07 YM MOD
				(setq #CG_SizeH (nth 13 #xd_LSYM$))
				(setq #CG_SizeH (+ #CG_SizeH &size))
;2013/01/07 YM MOD

				(setq #BrkW (fix (* (fix (nth 3 #xd_SYM$)) 0.5)))
				(setq #BrkD (fix (* (fix (nth 4 #xd_SYM$)) 0.5)))
				(if (> 0 (nth 10 #xd_SYM$))
					(setq CG_BASE_UPPER T)
				)
				(if CG_BASE_UPPER
					(setq #BrkH (- (+ (fix (atof (substr #action 2))) (caddr #pt)) (nth 5 #xd_SYM$)))
					(setq #BrkH (fix (atof (substr #action 2))))
				)
        (if (not (equal #str_width (nth 3 #xd_SYM$) 0.0001))
					(progn
						(setq CG_TOKU T)
						(setq #eDelBRK_W$ (PcRemoveBreakLine #sym "W")) ; W方向ブレーク除去
						(setq #XLINE_W (PK_MakeBreakW #pt #ang #BrkW))
						(CFSetXData #XLINE_W "G_BRK" (list 1))
						;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
						(command "-group" "A" #gnam #XLINE_W "")
	          (setq CG_TOKU_BW #BrkW)
	          (SKY_Stretch_Parts #sym #str_width (nth 4 #xd_SYM$) (nth 5 #xd_SYM$))
            ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
            (entdel #XLINE_W)
            ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
            (foreach #eD #eDelBRK_W$
              (if (= (entget #eD) nil) (entdel #eD)) ;W方向ブレーク復活
            )
					)
        )
        (if (not (equal #str_depth (nth 4 #xd_SYM$) 0.0001))
					(progn
						(setq CG_TOKU T)
						(setq #eDelBRK_D$ (PcRemoveBreakLine #sym "D")) ; D方向ブレーク除去
						(setq #XLINE_D (PK_MakeBreakD #pt #ang #BrkD))
						(CFSetXData #XLINE_D "G_BRK" (list 2))
						;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
						(command "-group" "A" #gnam #XLINE_D "")
  	        (setq CG_TOKU_BD #BrkD)
	          (SKY_Stretch_Parts #sym #str_width #str_depth (nth 5 #xd_SYM$))
            ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
            (entdel #XLINE_D)
            ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
            (foreach #eD #eDelBRK_D$
              (if (= (entget #eD) nil) (entdel #eD)) ;D方向ブレーク復活
            );for
					)
        )
        (if (not (equal #str_height (nth 5 #xd_SYM$) 0.0001))
					(progn
						(setq CG_TOKU T)
						(setq #eDelBRK_H$ (PcRemoveBreakLine #sym "H")) ; H方向ブレーク除去
						(setq #XLINE_H (PK_MakeBreakH #pt #BrkH))
						(CFSetXData #XLINE_H "G_BRK" (list 3))
						;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
						(command "-group" "A" #gnam #XLINE_H "")
    	      (setq CG_TOKU_BH #BrkH)
	          (SKY_Stretch_Parts #sym #str_width #str_depth #str_height)
            ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
            (entdel #XLINE_H)
            ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
            (foreach #eD #eDelBRK_H$
              (if (= (entget #eD) nil) (entdel #eD)) ;H方向ブレーク復活
            );for
					)
        )

;-- 2012/02/22 A.Satoh Add : 品番図形DBの登録H寸法値を更新する - S
	      (CFSetXData #sym "G_LSYM"
  	      (CFModList #xd_LSYM$
						;2013/01/07 YM MOD-S
;	    	    (list (list 13 CG_SizeH))
	    	    (list (list 13 #CG_SizeH))
						;2013/01/07 YM MOD-E
        	)
      	)
;-- 2012/02/22 A.Satoh Add : 品番図形DBの登録H寸法値を更新する - E

				(if CG_AutoAlignDoor (PCD_MakeViewAlignDoor (list #sym) 3 T))

;-- 2012/03/23 A.Satoh Add - S
				(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
	      (CFSetXData #sym "G_LSYM" (CFModList #xd_LSYM$ (list (list  7 #doorID))))
;-- 2012/03/23 A.Satoh Add - E

				(setq CG_BASE_UPPER nil)
				(setq CG_POS_STR nil)
				(setq CG_TOKU nil)
;-- 2012/02/20 A.Satoh Add - S
;;;;;;-- 2012/02/17 A.Satoh Add CG対応 - S
;;;;;				(setq CG_SizeH nil)
;;;;;;-- 2012/02/17 A.Satoh Add CG対応 - E
;-- 2012/02/20 A.Satoh Add - E
			)
		)
	)

	(princ)

);TokuBuzaiStretch


;;;(KikiHantei (nth 5 #xd_LSYM$) (nth 9 #xd_LSYM$)) ;品番,性格ｺｰﾄﾞ

;<HOM>*************************************************************************
; <関数名>    : KikiHantei
; <処理概要>  : 機器かどうか判定
; <戻り値>    : T:機器 nil 機器以外
; <作成>      : 2016/10/06 YM ADD-S
; <備考>      : 
;*************************************************************************>MOH<
(defun KikiHantei (
  &hinban ;品番
	&skk    ;性格ｺｰﾄﾞ
  /
	#RET
  )
	(setq #ret nil)
	
;;;性格コード
;;;110　食洗
;;;113　ガスキャビ　または　オーブン　（★注）
;;;210　ガスコンロ　または　ＩＨ
;;;320　レンジフード
;;;510　水栓(該当なし)
;;;
;;;（★注）
;;;オーブン　は、品番名称=HD～
;;;ガスキャビは、品番名称=H$～
;;;で区別可

	(if (or (= &skk 110)(= &skk 210)(= &skk 320)(= &skk 510))
		(setq #ret T)
	);_if

	(if (and (= &skk 113)(wcmatch &hinban "HD*"))
		(setq #ret T)
	);_if

	#ret
);KikiHantei


;<HOM>*************************************************************************
; <関数名>    : TokuCab_InputTokuData
; <処理概要>  : 指定のシンボルに対して特注キャビ情報を設定する
; <戻り値>    : T:正常終了 nil キャンセル終了
; <作成>      : 11/12/01 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun TokuCab_InputTokuData (
  &buzai$
	&size
	&base_sym
  /
	#err_flag #en #action #syuyaku
	#xd_LSYM$ #xd_SYM$ #xd_TOKU$
	#hin_last$ #hinban #hinban2 #lr #hin_last #toku_hin
	#hin_takasa #org_width #org_depth #org_height
	#qry$ #hinban$ #hinban2$
	#ret #ssGrp
#XLINE_W$ #XLINE_D$ #XLINE_H$ #org_size$ ;-- 2012/12/15 A.Satoh CG対応
#hin_width #hin_depth ;-- 2012/02/21 A.Satoh Add 
#chk ;-- 2012/02/22 A.Satoh Add
#DOOR_INFO$ #DRCOLCODE #DRHIKITE #DRSERICODE #HIN_KAKAKU #RET$ ;2013/08/05 YM ADD
#CG_TOKU_HINBAN ;2018/07/27 YM ADD
  )

	(setq #ret T)
	(setq #err_flag nil)
	(setq #en         (nth 0 &buzai$))
	(setq #action     (nth 1 &buzai$))
	(setq #syuyaku    (nth 2 &buzai$))
	(setq #org_width  (nth 0 (nth 3 &buzai$)))
	(setq #org_depth  (nth 1 (nth 3 &buzai$)))
	(setq #org_height (nth 2 (nth 3 &buzai$)))

	; 対象シンボルの色変え
	(setq #ssGrp (CFGetSameGroupSS #en))
	(setq #ssGrp (ChangeItemColor #ssGrp '(()("G_LSYM")) CG_ConfSymCol))

	(setq #xd_TOKU$ (CFGetXData #en "G_TOKU"))
	(if (= #xd_TOKU$ nil)
		(progn
			(setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
			(if (= #xd_LSYM$ nil)
				(setq #err_flag T)
			)

			(if (= #err_flag nil)
				(progn
					(setq #xd_SYM$ (CFGetXData #en "G_SYM"))
					(if (= #xd_SYM$ nil)
						(setq #err_flag T)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
					(setq #hinban (nth 5 #xd_LSYM$))
					(setq #lr     (nth 6 #xd_LSYM$))

;-- 2011/12/15 A.Satoh Mod - S
;;;;;					(setq #qry$$
;;;;;						(CFGetDBSQLRec CG_DBSESSION "品番最終"
;;;;;							(list
;;;;;								(list "品番名称"   #hinban       'STR)
;;;;;								(list "LR区分"     #lr           'STR)
;;;;;								(list "扉シリ記号" CG_DRSeriCode 'STR)
;;;;;								(list "扉カラ記号" CG_DRColCode  'STR)
;;;;;								(list "引手記号"   CG_Hikite     'STR)
;;;;;							)
;;;;;						)
;;;;;					)
;;;;;
;;;;;					(if (/= #qry$$ nil)
;;;;;						(if (= (length #qry$$) 1)
;;;;;							(progn
;;;;;								(setq #hin_last (nth 10 (car #qry$$)))
;;;;;								(setq #hin_takasa (atof (nth 12 (car #qry$$))))
;;;;;							)
;;;;;							(setq #err_flag T)
;;;;;						)
;;;;;						(progn
;;;;;;-- 2011/12/13 A.Satoh Add - S
;;;;;;							(setq #hin_last #hinban)
;;;;;;							(setq #hin_takasa #org_height)
;;;;;;-- 2011/12/13 A.Satoh Add - S
;;;;;							(setq #qry2$$
;;;;;								(CFGetDBSQLRec CG_DBSESSION "品番最終"
;;;;;									(list
;;;;;										(list "品番名称"   #hinban       'STR)
;;;;;										(list "LR区分"     #lr           'STR)
;;;;;										(list "扉シリ記号" CG_DRSeriCode 'STR)
;;;;;										(list "扉カラ記号" CG_DRColCode  'STR)
;;;;;									)
;;;;;								)
;;;;;							)
;;;;;
;;;;;							(if (/= #qry2$$ nil)
;;;;;								(if (= (length #qry2$$) 1)
;;;;;									(progn
;;;;;										(setq #hin_last (nth 10 (car #qry2$$)))
;;;;;										(setq #hin_takasa (atof (nth 12 (car #qry2$$))))
;;;;;									)
;;;;;									(setq #err_flag T)
;;;;;								)
;;;;;								(progn
;;;;;									(setq #hin_last #hinban)
;;;;;									(setq #hin_takasa #org_height)
;;;;;								)
;;;;;							)
;;;;;						)
;;;;;					)
					; 特注規格品チェックを行う
					(setq #qry$
						(CFGetDBSQLRec CG_DBSESSION "特注規格品"
							(list
								(list "品番名称" #hinban 'STR)
							)
						)
					)
					(if (/= #qry$ nil)
						(progn
							(princ (strcat "\n★★★★特注規格品 品番名称 = " #hinban))
							(setq #err_flag T)
;-- 2012/02/15 A.Satoh Add CG対応 - S
							(if (= nil (tblsearch "APPID" "G_REG")) (regapp "G_REG"))
							(setq #org_size$ (list #org_width #org_depth #org_height))
							(setq #XLINE_W$  (list nil nil))								; ブレークライン位置Ｗ
							(setq #XLINE_D$	 (list nil nil))								; ブレークライン位置Ｄ
							(setq #XLINE_H$  (list (atof (substr #action 2)) nil))	; ブレークライン位置Ｈ
;-- 2012/02/22 A.Satoh Add - S
							(setq #chk (list nil nil T))
;-- 2012/02/22 A.Satoh Add - E
							(InputGRegData #en #org_size$ #XLINE_W$ #XLINE_D$ #XLINE_H$ #chk nil nil)
;-- 2012/02/15 A.Satoh Add CG対応 - E
						)
					)
				)
			)

			(if (= #err_flag nil)
				(progn
					; 品番名称から括弧を除外
					(setq #hinban2 (KP_DelHinbanKakko #hinban))

					;2013/08/05 YM MOD-S
					(setq #Door_Info$     (nth 7 #xd_LSYM$))
					(setq #ret$ (StrParse #Door_Info$ ","))
					(setq #DRSeriCode (car   #ret$))(if (= #DRSeriCode nil)(setq #DRSeriCode ""))
					(setq #DRColCode  (cadr  #ret$))(if (= #DRColCode nil)(setq #DRColCode ""))
					(setq #DRHikite   (caddr #ret$))(if (= #DRHikite nil)(setq #DRHikite ""))

					(if (= #DRSeriCode "")
						(progn
							(setq #DRSeriCode CG_DRSeriCode)
							(setq #DRColCode  CG_DRColCode)
							(setq #DRHikite   CG_Hikite)
						)
					);_if

					; 最終品番を取得
;;;					(setq #hin_last$ (StretchCabW_GetHinbanLast #hinban2 #lr))
					(setq #hin_last$ (StretchCabW_GetHinbanLast_HIKISU #hinban2 #lr #DRSeriCode #DRColCode #DRHikite))
					;2013/08/05 YM MOD-E




					(if (= #hin_last$ nil)
						(progn
							(setq #hin_last #hinban)
;-- 2012/02/21 A.Satoh Add - S
							(setq #hin_width #org_width)
							(setq #hin_depth #org_height)
;-- 2012/02/21 A.Satoh Add - E
							(setq #hin_takasa #org_height)
							;2013/01/30 YM ADD
							(setq #hin_KAKAKU 0)
						)
						(progn
							(setq #hin_last (car #hin_last$))
;-- 2012/02/21 A.Satoh Mod - S
;;;;;							(setq #hin_takasa (atof (cadr #hin_last$)))
							(setq #hin_width  (atof (nth 1 #hin_last$)))
							(setq #hin_takasa (atof (nth 2 #hin_last$)))
							(setq #hin_depth  (atof (nth 3 #hin_last$)))
;-- 2012/02/21 A.Satoh Mod - E

							;2013/01/30 YM ADD
							(setq #hin_KAKAKU (nth 4 #hin_last$))
						)
					)
;-- 2011/12/15 A.Satoh Mod - S
				)
			)

			(if (= #err_flag nil)
				(progn
		      (setq #qry$
    		    (CFGetDBSQLRec CG_CDBSESSION "集約名称"
        		  (list
            		(list "集約ID" #syuyaku 'STR)
		          )
    		    )
		      )
					(if (/= #qry$ nil)
						(if (= (length #qry$) 1)
							(setq #toku_hin (nth 2 (car #qry$)))
							(setq #err_flag T)
						)
						(setq #err_flag T)
					)
				)
			)


			;2016/10/06 YM ADD 機器かどうかの判定
			(if (KikiHantei (nth 5 #xd_LSYM$) (nth 9 #xd_LSYM$)) ;品番,性格ｺｰﾄﾞ
				(progn
					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_KIKI)
				)
				;機器以外
				(progn
					;2018/07/27 YM MOD-S
;;;					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN)
					(cond
						((= BU_CODE_0013 "1") ; PSKCの場合
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
						)
						((= BU_CODE_0013 "2") ; PSKDの場合
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
						)
						(T ;それ以外
							(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
						)
					);_if
					;2018/07/27 YM MOD-E
				)
			);_if


			(if (= #err_flag nil)
				(progn
					(setq #hinban$
						(list
;;;							#toku_hin													; 特注品番
							#CG_TOKU_HINBAN										; 特注品番 2016/08/30 YM MOD (3)
							;2013/01/30 YM MOD 金額を表示する
;;;							0																	; 金額
							#hin_KAKAKU           						; 金額

;;;							(strcat "ﾄｸﾁｭｳ(" #hin_last ")")		; 品名
							(strcat "ﾄｸ(" #hin_last ")")      ; 品名 2016/08/30 YM MOD
							""																; 特注コード　特注コード-連番
;-- 2012/02/21 A.Satoh Mod - S
;;;;;							(nth 3 #xd_SYM$)									; 巾
							#hin_width												; 巾
;-- 2012/02/21 A.Satoh Mod - S
;							(+ (nth 5 #xd_SYM$) &size)				; 高さ
							(+ #hin_takasa &size)							; 高さ
;-- 2012/02/21 A.Satoh Mod - S
;;;;;							(nth 4 #xd_SYM$)									; 奥行
							#hin_depth												; 奥行
;-- 2012/02/21 A.Satoh Mod - E
						)
					)
				)
			)
		)
		(progn
;-- 2012/02/22 A.Satoh Add - S
			(setq #xd_SYM$ (CFGetXData #en "G_SYM"))
			(if (= #xd_SYM$ nil)
				(setq #err_flag T)
			)
;-- 2012/02/22 A.Satoh Add - E

			(setq #hinban$
				(list
					(nth 0 #xd_TOKU$)				; 特注品番
					(fix (nth 1 #xd_TOKU$))	; 金額
					(nth 2 #xd_TOKU$)				; 品名
					(nth 3 #xd_TOKU$)				; 特注コード
					(nth 4 #xd_TOKU$)				; 巾
					(nth 5 #xd_TOKU$)				; 高さ
					(nth 6 #xd_TOKU$)				; 奥行
				)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
			; 特注キャビ情報入力画面処理
			(setq #hinban2$ (Toku_HeightChange_SetTokuDataDlg #hinban$))
			(if #hinban2$
				(progn
					; 特注情報(G_TOKU)の設定
					(if #xd_TOKU$
						(progn
							(CFSetXData #en "G_TOKU"
								(CFModList #xd_TOKU$
									(list
										(list  0 (nth 0 #hinban2$))													; [ 0]特注品番
										(list  1 (nth 1 #hinban2$))													; [ 1]金額
										(list  2 (nth 2 #hinban2$))													; [ 2]品名
										(list  3 (nth 3 #hinban2$))													; [ 3]特注コード
										(list  4 (nth 4 #hinban2$))													; [ 4]巾
										(list  5 (nth 5 #hinban2$))													; [ 5]高さ
										(list  6 (nth 6 #hinban2$))													; [ 6]奥行
										(list 17 (nth 3 #xd_SYM$))													; [17]伸縮後図形サイズＷ
										(list 18 (nth 4 #xd_SYM$))													; [18]伸縮後図形サイズＤ
										(list 19 (nth 5 #xd_SYM$))													; [19]伸縮後図形サイズＨ
;-- 2012/03/16 A.Satoh Mod - S
;;;;;										(list 20 (list 0.0 0.0 0.0))												; [20]ブレークライン位置Ｗ
;;;;;										(list 21 (list 0.0 0.0 0.0))												; [21]ブレークライン位置Ｄ
										(list 20 (nth 20 #xd_TOKU$))												; [20]ブレークライン位置Ｗ
										(list 21 (nth 21 #xd_TOKU$))												; [21]ブレークライン位置Ｄ
;-- 2012/03/16 A.Satoh Mod - S
										(list 22 (list (atof (substr #action 2)) 0.0 0.0))	; [22]ブレークライン位置Ｈ
									)
								)
							)
						)
						(progn
							(CFSetXData #en "G_TOKU"
								(list
									(nth 0 #hinban2$)													; [ 0]特注品番
									(nth 1 #hinban2$)													; [ 1]金額
									(nth 2 #hinban2$)													; [ 2]品名
									(nth 3 #hinban2$)													; [ 3]特注コード
									(nth 4 #hinban2$)													; [ 4]巾
									(nth 5 #hinban2$)													; [ 5]高さ
									(nth 6 #hinban2$)													; [ 6]奥行
									""																				; [ 7]予備１
									""																				; [ 8]予備２
									""																				; [ 9]予備３
									#hinban																		; [10]元品番名称
									#hin_last																	; [11]元最終品番
									#org_width																; [12]元図形サイズＷ
									#org_depth																; [13]元図形サイズＤ
									#org_height																; [14]元図形サイズＨ
;-- 2012/03/16 A.Satoh Mod - S
;;;;;									""																				; [15]予備４
;;;;;									""																				; [16]予備５
									0.0																				; [15]Ｄの伸縮量
									0.0																				; [16]Ｃの伸縮量
;-- 2012/03/16 A.Satoh Mod - E
									(nth 3 #xd_SYM$)													; [17]伸縮後図形サイズＷ
									(nth 4 #xd_SYM$)													; [18]伸縮後図形サイズＤ
									(nth 5 #xd_SYM$)													; [19]伸縮後図形サイズＨ
									(list 0.0 0.0 0.0)												; [20]ブレークライン位置Ｗ
									(list 0.0 0.0 0.0)												; [21]ブレークライン位置Ｄ
									(list (atof (substr #action 2)) 0.0 0.0)	; [22]ブレークライン位置Ｈ
								)
							)
						)
					)
				)
				(setq #ret nil)
			)
		)
	)

	(if (equal &base_sym #en)
		(GroupInSolidChgCol #en CG_BaseSymCol)
		(GroupInSolidChgCol2 #en "BYLAYER")
	)

	#ret
);TokuCab_InputTokuData


;<HOM>*************************************************************************
; <関数名>    : Toku_HeightChange_SetTokuDataDlg
; <処理概要>  : 特注キャビ情報入力画面を表示し、指定の部材（シンボル図形）
;             : に対して特注情報を設定する
; <戻り値>    : 入力情報  : 設定
;             : nil: キャンセル（特注高さ一括変更をキャンセルする）
; <作成>      : 11/12/01 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun Toku_HeightChange_SetTokuDataDlg (
	&hinban$
  /
	#hinban #price #hinmei #toku_cd #toku1 #toku2 #width #height #depth
	#dcl_id #next #ret
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// Toku_HeightChange_SetTokuDataDlg ////")
  (CFOutStateLog 1 1 " ")

	;***********************************************************************
	; 所定の文字列に対し、全角が含まれるかをチェックする
	; 戻り値:T 全角あり　nil:半角のみ
	; 文字コードが127(0x80)より大きい場合は全角文字とみなす
	;***********************************************************************
	(defun ##CheckStr (
		&str
		/
		#idx #flg #code
		)

		(setq #flg nil)
		(setq #idx 1)

		(while (and (<= #idx (strlen &str)) (not #flg))
			(setq #code (ascii(substr &str #idx 1)))
			(if (> #code 127); 0x80(127)より大の場合は全角文字とみなす
				; 半角カナ(161～223)は対象外とする
				(if (or (< #code 161) (> #code 223))
					(setq #flg T)
				)
			)
			(setq #idx (1+ #idx))
		)

		#flg
	)

	;***********************************************************************
	; ＯＫボタン押下処理
	; 戻り値:伸縮サイズ(50 or -50)
	;***********************************************************************
	(defun ##SetTokuData_CallBack (
		/
    #hinban #price #hinmei #tokucd #width #height #depth
    #err_flg #data$ #tokucd1 #tokucd2 #flg1 #flg2
		#wk_height  ;-- 2012/02/20 A.Satoh Add
    )

    (setq #err_flg nil)
		(setq #data$ nil)

    ; 特注品番チェック
    (setq #hinban (get_tile "edtWT_NAME"))
    (if (or (= #hinban "") (= #hinban nil))
      (progn
        (set_tile "error" "特注品番が入力されていません")
        (mode_tile "edtWT_NAME" 2)
        (setq #err_flg T)
      )
			(progn
;      	(setq #hinban (strcase #hinban))
				(if (> (strlen #hinban) 15)
					(progn
						(set_tile "error" "特注品番は15桁以下で入力して下さい")
						(mode_tile "edtWT_NAME" 2)
						(setq #err_flg T)
					)
					;2014/02/10 YM ADD
					(progn ;品番にｶﾝﾏあり
						(if (vl-string-search "," #hinban)
							(progn
								(set_tile "error" "品番にｶﾝﾏを使用しないで下さい")
								(mode_tile "edtWT_NAME" 2)
								(setq #err_flg T)
							)
						);_if
					)
				);_if
			)
    );_if

    ; 金額チェック
    (if (= #err_flg nil)
      (progn
        (setq #price (get_tile "edtWT_PRI"))
        (if (or (= #price "") (= #price nil))
          (progn
            (set_tile "error" "金額が入力されていません")
            (mode_tile "edtWT_PRI" 2)
            (setq #err_flg T)
          )
          (if (= (type (read #price)) 'INT)
            (if (> 0 (read #price))
              (progn
                (set_tile "error" "0以上の整数値を入力して下さい")
                (mode_tile "edtWT_PRI" 2)
                (setq #err_flg T)
              )
							(if (> (read #price) 9999999)
								(progn
	                (set_tile "error" "金額は 9999999 以下の整数値を入力して下さい")
  	              (mode_tile "edtWT_PRI" 2)
    	            (setq #err_flg T)
								)
							)
            )
            (progn
              (set_tile "error" "金額は 9999999 以下の整数値を入力して下さい")
              (mode_tile "edtWT_PRI" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; 品名取得
    (if (= #err_flg nil)
			(progn
      	(setq #hinmei (get_tile "edtWT_HINMEI"))
				(if (> (strlen #hinmei) 30)
          (progn
            (set_tile "error" "品名は30桁以下で入力して下さい")
            (mode_tile "edtWT_HINMEI" 2)
            (setq #err_flg T)
          )
					(if (##CheckStr #hinmei)
						(progn
	            (set_tile "error" "品名は半角のみ入力可能です")
  	          (mode_tile "edtWT_HINMEI" 2)
    	        (setq #err_flg T)
						)
						;2014/02/10 YM ADD
						(progn ;品番にｶﾝﾏあり
							(if (vl-string-search "," #hinmei)
								(progn
									(set_tile "error" "品名にｶﾝﾏを使用しないで下さい")
									(mode_tile "edtWT_HINMEI" 2)
									(setq #err_flg T)
								)
							);_if
						)
					)
				)
			)
    )

    ; 特注コードチェック
    (if (= #err_flg nil)
      (progn
        (setq #tokucd1 (get_tile "edtWT_Toku1"))
        (setq #tokucd2 (get_tile "edtWT_Toku2"))

        (if (or (= #tokucd1 "") (= #tokucd1 nil))
          (setq #flg1 nil)
          (setq #flg1 T)
        )
        (if (or (= #tokucd2 "") (= #tokucd2 nil))
          (setq #flg2 nil)
          (setq #flg2 T)
        )

        (cond
          ((and (= #flg1 nil) (= #flg2 nil))
            (setq #tokucd "")
          )
          ((and (= #flg1 T) (= #flg2 nil))
            (set_tile "error" "特注コードが入力されていません")
            (mode_tile "edtWT_Toku2" 2)
            (setq #err_flg T)
          )
          ((and (= #flg1 nil) (= #flg2 T))
            (set_tile "error" "特注コードが入力されていません")
            (mode_tile "edtWT_Toku1" 2)
            (setq #err_flg T)
          )
          (T
            (if (= (type (read #tokucd2)) 'INT)
              (if (> 1 (read #tokucd2))
                (progn
                  (set_tile "error" "1以上の整数値を入力して下さい")
                  (mode_tile "edtWT_Toku2" 2)
                  (setq #err_flg T)
                )
              )
              (progn
                (set_tile "error" "1以上の整数値を入力して下さい")
                (mode_tile "edtWT_Toku2" 2)
                (setq #err_flg T)
              )
            )

            (if (= #err_flg nil)
              (if (< (strlen #tokucd1) 12)
                (progn
                  (set_tile "error" "ｺｰﾄﾞは12桁で入力して下さい")
                  (mode_tile "edtWT_Toku1" 2)
                  (setq #err_flg T)
                )
                (progn
                  (setq #tokucd1 (strcase #tokucd1))
                  (if (= (strlen #tokucd2) 1)
                    (setq #tokucd2 (strcat "00" #tokucd2))
                    (if (= (strlen #tokucd2) 2)
                      (setq #tokucd2 (strcat "0" #tokucd2))
                    )
                  )
                  (setq #tokucd (strcat #tokucd1 "-" #tokucd2))
                )
              )
            )
          )
        )
      )
    )

    ; 巾チェック
    (if (= #err_flg nil)
      (progn
        (setq #width (get_tile "edtWT_Width"))
        (if (or (= #width "") (= #width nil))
          (setq #width "")
          (if (or (= (type (read #width)) 'INT) (= (type (read #width)) 'REAL))
            (if (> 0 (read #width))
              (progn
                (set_tile "error" "0以上の数値を入力して下さい")
                (mode_tile "edtWT_Width" 2)
                (setq #err_flg T)
              )
							(if (> (read #width) 99999)
								(progn
	                (set_tile "error" "巾は 99999 以下の数値を入力して下さい")
  	              (mode_tile "edtWT_Width" 2)
    	            (setq #err_flg T)
								)
							)
            )
            (progn
              (set_tile "error" "0以上の数値を入力して下さい")
              (mode_tile "edtWT_Width" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; 高さチェック
    (if (= #err_flg nil)
      (progn
        (setq #height (get_tile "edtWT_Height"))
        (if (or (= #height "") (= #height nil))
          (setq #height "")
          (if (or (= (type (read #height)) 'INT) (= (type (read #height)) 'REAL))
            (if (> 0 (read #height))
              (progn
                (set_tile "error" "0以上の数値を入力して下さい")
                (mode_tile "edtWT_Height" 2)
                (setq #err_flg T)
              )
;;;;;							(if (>= (read #height) 1000)
							(if (> (read #height) 99999)
								(progn
;;;;;	                (set_tile "error" "高さは 1000 未満の数値を入力して下さい")
	                (set_tile "error" "高さは 99999 以下の数値を入力して下さい")
  	              (mode_tile "edtWT_Height" 2)
    	            (setq #err_flg T)
								)
							)
            )
            (progn
              (set_tile "error" "0以上の数値を入力して下さい")
              (mode_tile "edtWT_Height" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; 奥行チェック
    (if (= #err_flg nil)
      (progn
        (setq #depth (get_tile "edtWT_Depth"))
        (if (or (= #depth "") (= #depth nil))
          (setq #depth "")
          (if (or (= (type (read #depth)) 'INT) (= (type (read #depth)) 'REAL))
            (if (> 0 (read #depth))
              (progn
                (set_tile "error" "0以上の数値を入力して下さい")
                (mode_tile "edtWT_Depth" 2)
                (setq #err_flg T)
              )
;;;;;							(if (> (read #depth) 99999)
							(if (>= (read #depth) 1000)
								(progn
;;;;;	                (set_tile "error" "奥行は 99999 以下の数値を入力して下さい")
	                (set_tile "error" "奥行は 1000 未満の数値を入力して下さい")
  	              (mode_tile "edtWT_Depth" 2)
    	            (setq #err_flg T)
								)
							)
            )
            (progn
              (set_tile "error" "0以上の数値を入力して下さい")
              (mode_tile "edtWT_Depth" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; 価格0円の確認
    (if (= #err_flg nil)
      (if (equal (atof #price) 0.0 0.0001)
        (if (= (CFYesNoDialog "価格は0円で良いですか？") nil)
          (setq #err_flg T)
        )
      )
    )

    ; 特注情報リストの作成
    (if (= #err_flg nil)
      (progn
        (setq #data$ (list #hinban (atof #price) #hinmei #tokucd (atof #width) (atof #height) (atof #depth)))
        (done_dialog)
        #data$
      )
    )

		#data$
	)
	;***********************************************************************

  (setq #hinban  (nth 0 &hinban$)) ; 品番
  (setq #price   (nth 1 &hinban$)) ; 金額
  (setq #hinmei  (nth 2 &hinban$)) ; 品名
  (setq #toku_cd (nth 3 &hinban$)) ; 特注コード
  (if (/= #toku_cd "")
    (progn
      (setq #toku1 (substr #toku_cd 1 12))
      (setq #toku2 (substr #toku_cd 14 3))
    )
    (progn
      (setq #toku1 "")
      (setq #toku2 "")
    )
  )
  (setq #width   (nth 4 &hinban$)) ; 巾
  (setq #height  (nth 5 &hinban$)) ; 高さ
  (setq #depth   (nth 6 &hinban$)) ; 奥行

	; 特注キャビ情報入力画面表示
	(setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kcmain.dcl")))
	(if (not (new_dialog "SetTOKUCABInfoDlg" #dcl_id)) (exit))

	; 初期設定
	(set_tile "edtWT_NAME"   #hinban)							; 特注品番
	(set_tile "edtWT_PRI"    (itoa #price))				; 金額
	(set_tile "edtWT_HINMEI" #hinmei)							; 品名
	(set_tile "edtWT_Toku1"  #toku1)							; 特注コード１
	(set_tile "edtWT_Toku2"  #toku2)							; 特注コード２
	(set_tile "edtWT_Width"  (rtos #width 2 1))		; 巾
;2013/01/04 YM MOD-S
	(set_tile "edtWT_Height" (rtos #height 2 1))	; 高さ
;;;;-- 2012/02/20 A.Satoh Add - S
;;;;;;;;	(set_tile "edtWT_Height" (rtos #height 2 1))	; 高さ
;;;	(set_tile "edtWT_Height" (rtos CG_SizeH 2 1))	; 高さ
;;;;-- 2012/02/20 A.Satoh Add - E
;2013/01/04 YM MOD-E
	(set_tile "edtWT_Depth"  (rtos #depth 2 1))		; 奥行

	(setq #next 99)
	(while (and (/= 1 #next) (/= 0 #next))
		; ボタン押下処理
  	(action_tile "accept" "(setq #ret (##SetTokuData_CallBack))")
  	(action_tile "cancel" "(setq #ret nil) (done_dialog 0)")

  	(setq #next (start_dialog))
	)

  (unload_dialog #dcl_id)

	#ret

);Toku_HeightChange_SetTokuDataDlg


;-- 2011/11/25 A.Satoh Add - E


;<HOM>*************************************************************************
; <関数名>    : KPGetHinbanMoney
; <処理概要>  : 品番,価格の入力ﾀﾞｲｱﾛｸﾞを表示してXdata"G_TOKU"にｾｯﾄする
; <戻り値>    : なし
; <作成>      : 02/07/09 YM
; <備考>      : NAS特注ｷｬﾋﾞｺﾏﾝﾄﾞ用
;*************************************************************************>MOH<
(defun KPGetHinbanMoney (
  &SYM
  /
  #HINBAN #LR #LXD$ #ORG_PRICE #RET$ #SBIKOU #SHINMEI #SS #SYM #USERHINBAN
#USERBIKOU #USERHINMEI ; 02/07/10 YM ADD
  )
  (setq #sym &SYM)
  (setq #LXD$ (CFGetXData #sym "G_LSYM"))
  (setq #HINBAN (nth 5 #LXD$))
  (setq #LR     (nth 6 #LXD$))

;;; ｷｬﾋﾞ価格を検索
  (setq #ret$ (KPGetPrice #HINBAN #LR))
  (setq #ORG_price (nth 0 #ret$))
  (setq #sHINMEI   (nth 1 #ret$)) ; 品名
  (setq #sBIKOU    (nth 2 #ret$)) ; 備考

  ; 図形色を変更
  (setq #ss (CFGetSameGroupSS #sym))
  (command "_change" #ss "" "P" "C" CG_InfoSymCol "")

  ;;; 確認ﾀﾞｲｱﾛｸﾞ
  (setq #ret$
    (ShowTOKUCAB_Dlog_N
      #HINBAN
      "0"
      nil        ; 現在使っていない
      #ORG_price ; 元の価格
      #sHINMEI   ; 品名
      #sBIKOU    ; 備考
    )
  ); 品番,価格

  (if (= nil #ret$)
    (quit)
  );_if

  ; 全角ｽﾍﾟｰｽを半角ｽﾍﾟｰｽに置きかえる
  (setq #userHINBAN (vl-string-subst "  " "　" (nth 0 #ret$))) ; ﾕｰｻﾞｰ入力品番
  ; 02/07/10 YM ADD-S
  (setq #userHINMEI (nth 2 #ret$)) ; ﾕｰｻﾞｰ入力品名
  (setq #userBIKOU  (nth 3 #ret$)) ; ﾕｰｻﾞｰ入力備考
  ; 02/07/10 YM ADD-E

  ;;; ダイアログから獲得されたリストを特注キャビ拡張データに格納
  (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))
  (CFSetXData #sym "G_TOKU"
    (list
      #userHINBAN   ; ﾕｰｻﾞｰ入力品番
      (nth 1 #ret$) ; 価格
        "" ; (W1,W2,W3)を覚えておく(次回使用)ｺｰﾅｰｷｬﾋﾞは""
      1    ; 1:特注ｷｬﾋﾞｺﾏﾝﾄﾞ 0:ｹｺﾐ伸縮
      ""   ; W ﾌﾞﾚｰｸﾗｲﾝ位置 ﾀﾞﾐｰ
      ""   ; D ﾌﾞﾚｰｸﾗｲﾝ位置 ﾀﾞﾐｰ
      ""   ; H ﾌﾞﾚｰｸﾗｲﾝ位置 ﾀﾞﾐｰ
      #HINBAN    ; 元の品番
      ; 02/07/10 YM ADD-S 品番、価格に加えて品名と備考も保持する
      #userHINMEI   ; 品名(見積明細,仕様表での「名称」)
      #userBIKOU    ; 備考(見積明細での「備考」,仕様表での「仕様」)
      ; 02/07/10 YM ADD-E
    )
  )

  ;色を戻す
  (command "_change" #ss "" "P" "C" "BYLAYER" "")

  (princ)
);KPGetHinbanMoney

;<HOM>*************************************************************************
; <関数名>    : GetTokuDim
; <処理概要>  : 品番,LRから特注寸法ﾃｰﾌﾞﾙを検索
; <戻り値>    : ﾚｺｰﾄﾞ(LIST) ただし1件のとき以外はnil
; <作成>      : 01/10/09 YM
; <備考>      : NAS特注ｷｬﾋﾞｺﾏﾝﾄﾞ用
;*************************************************************************>MOH<
(defun GetTokuDim (
  &HINBAN
  &LR
  /
  #QRY$ #RET
  )
  (setq #Qry$
    (CFGetDBSQLRec CG_DBSESSION "特注寸法"
      (list
        (list "品番名称" &HINBAN 'STR)
        (list "LR区分"   &LR     'STR)
      )
    )
  )
  (if (and #Qry$ (= (length #Qry$) 1))
    (setq #ret (car #Qry$))
    (setq #ret nil)
  );_if

  #ret
);GetTokuDim

;<HOM>*************************************************************************
; <関数名>    : PcStretchCab_N
; <処理概要>  : キャビネット伸縮処理
; <戻り値>    : なし
; <作成>      : 00/04/07 MH 01/01/27 YM ﾌﾞﾚｰｸﾗｲﾝなしでもOKに改造
; <備考>      : ｼﾝﾎﾞﾙ上付きの場合考慮 01/02/21 YM
;               NAS用改造 01/10/09 YM
;               この関数にくるには[特注寸法]いﾚｺｰﾄﾞが存在することが必要
;*************************************************************************>MOH<
(defun PcStretchCab_N (
  &en         ; 伸縮対象ｼﾝﾎﾞﾙ図形
  /
  #DLOG$ #sym #LXD$ #XD$ #WDH$ #ss #bsym
  #ANG #BRKD #BRKH #BRKW #EDELBRK_D$ #EDELBRK_H$ #EDELBRK_W$ #GNAM
  #PT #XLINE_D #XLINE_H #XLINE_W #HINBAN #RET$ #flg #CNTZ #FHMOV
  #LR #ORG_PRICE #QRY$ #userHINBAN
  #DBASE #RZ #SBIKOU #SHINMEI ; 01/08/20 YM ADD ﾚﾝｼﾞ高さ方向伸縮不具合
  #A1 #A2 #BASE #BRKW1 #BRKW2 #BRKW3 #D #D1 #D2 #H #P1 #P2 #P3 #P4 #P5 #P6 ; 02/07/09 YM ADD
  #PMEN2 #PT$ #TCNRFLG #TOKU_XD$ #W1 #W2 #W3 #XLINE_W1 #XLINE_W2 #XLINE_W3 ; 02/07/09 YM ADD
#USERBIKOU #USERHINMEI ; 02/07/10 YM ADD
#BRKW4 #W4 #XLINE_W4 ;03/11/28
  )
  (setq #flg nil) ; 伸縮処理をしない=T
  (setq #sym &en)

  (setq #dBASE (cdr (assoc 10 (entget #sym)))) ; ｼﾝﾎﾞﾙ位置
  (setq #rZ (caddr #dBASE)) ; 取付け高さ
  (if (= #rZ nil)(setq #rZ 0.0))
  (setq #LXD$ (CFGetXData #sym "G_LSYM"))
  (setq #HINBAN (nth 5 #LXD$))
  (setq #LR     (nth 6 #LXD$))
  (setq #XD$  (CFGetXData #sym "G_SYM" ))
  (setq #TOKU_XD$ (CFGetXData #sym "G_TOKU"))

  (if (> 0 (nth 10 #XD$))  ; ｼﾝﾎﾞﾙが上付き===>T,下つき=nil
    (setq CG_BASE_UPPER T) ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中のｸﾞﾛｰﾊﾞﾙ
  );_if

; 既存ﾌﾞﾚｰｸﾗｲﾝ除去
  (setq #eDelBRK_W$ (PcRemoveBreakLine #sym "W")) ; W方向ブレーク除去
  (setq #eDelBRK_D$ (PcRemoveBreakLine #sym "D")) ; D方向ブレーク除去
  (setq #eDelBRK_H$ (PcRemoveBreakLine #sym "H")) ; H方向ブレーク除去
  (setq #pt  (cdr (assoc 10 (entget #sym))))      ; ｼﾝﾎﾞﾙ基準点
  (setq #ANG (nth 2 #LXD$))                       ; ｼﾝﾎﾞﾙ配置角度
  (setq #gnam (SKGetGroupName #sym))              ; ｸﾞﾙｰﾌﾟ名

;;; ｷｬﾋﾞ価格を検索
  (setq #ret$ (KPGetPrice #HINBAN #LR))
  (setq #ORG_price (nth 0 #ret$))
  (setq #sHINMEI   (nth 1 #ret$)) ; 品名
  (setq #sBIKOU    (nth 2 #ret$)) ; 備考

  ; 図形色を変更
  (setq #ss (CFGetSameGroupSS #sym))
  (command "_change" #ss "" "P" "C" CG_InfoSymCol "")

  ; 01/10/10 YM ｺｰﾅｰｷｬﾋﾞかどうかで分岐
  (if (= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3))
    (progn ; ｺｰﾅｰｷｬﾋﾞのとき
      (setq #tCNRflg T)
      ; ｺｰﾅｰｷｬﾋﾞ        W1=p1～p2
      ; p1          p2  W2=p1～p6
      ; +-----------+   D1=p2～p3
      ; |           |   D2=p5～p6
      ; |           |   A1=p3～p4
      ; |     +-----+   A2=p4～p5
      ; |     |p4   p3
      ; |     |
      ; +-----+
      ; p6    p5

      (setq #pmen2 (PKGetPMEN_NO #sym 2))  ; PMEN2を求める
      (setq #pt$ (GetLWPolyLinePt #pmen2)) ; PMEN2 外形領域
      (setq #base (PKGetBaseL6 #pt$))      ; ｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙを見ない)
      (setq #pt$ (GetPtSeries #base #pt$)) ; #base を先頭に時計周り
      (setq #p1 (nth 0 #pt$))
      (setq #p2 (nth 1 #pt$))
      (setq #p3 (nth 2 #pt$))
      (setq #p4 (nth 3 #pt$))
      (setq #p5 (nth 4 #pt$))
      (setq #p6 (nth 5 #pt$))

      (setq #W1 (distance #p1 #p2))
      (setq #W2 (distance #p1 #p6))
      (setq #D1 (distance #p2 #p3))
      (setq #D2 (distance #p5 #p6))
      (setq #A1 (distance #p3 #p4))
      (setq #A2 (distance #p4 #p5))

      (setq #H  (nth 5 #XD$)) ; 寸法H

      ; ダイアログ表示情報取得 01/10/09 YM ADD-E

      ; ダイアログ表示
      (setq #WDH$ (list #D2 #D1 #H #W1 #W2)) ; 隅用ｷｬﾋﾞ用 ; NAS用 01/10/10 YM @@@@@@@@@@@@@@@@@@@@@
      (setq #DLOG$ (PcGetStretchCabInfoDlg_N_CNR #WDH$))      ; NAS用 01/10/10 YM @@@@@@@@@@@@@@@@@@@@@
      (if (not #DLOG$)
        (quit)
      );_if

      ; #DLOG$ 戻り値 = D2,D1,H,W1,W2


      ; 伸縮実行 D2,D1,H,W1,W2 の順番に最高５回行う

    ;/////////////////////////////////////////////////////////////////////// <D2左側ｷｬﾋﾞ奥行き>
      (if (not (equal (nth 0 #DLOG$) #D2 0.0001)) ; D2(W)
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (setq #BrkW (* #D2 0.5))

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))

          (CFSetXData #XLINE_W "G_BRK" (list 1))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_W "")

          (setq CG_TOKU_BW #BrkW)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 0 #DLOG$) #D2)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_W)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <D1右側ｷｬﾋﾞ奥行き>
      (if (not (equal (nth 1 #DLOG$) #D1 0.0001)) ; D1(D)
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (setq #BrkD (* #D1 0.5))

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))

          (CFSetXData #XLINE_D "G_BRK" (list 2))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_D "")

          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD #BrkD)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; 最新情報を使用する
          (SKY_Stretch_Parts #sym (nth 3 #XD$) (+ (nth 4 #XD$)(- (nth 1 #DLOG$) #D1)) (nth 5 #XD$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_D)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <H方向>
      (if (not (equal (nth 2 #DLOG$) #H 0.0001)) ; H
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (if CG_BASE_UPPER ; 上基点
            (setq #BrkH (- #rZ 150)) ; ｼﾝﾎﾞﾙ取り付け高さ-150mm(fix)
;-- 2011/08/24 A.Satoh Mod - S
;            (setq #BrkH 100) ; 下基点 H=100mm(fix)
            (setq #BrkH 480) ; 下基点 H=480mm 暫定
;-- 2011/08/24 A.Satoh Mod - S
          );_if

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))

          (CFSetXData #XLINE_H "G_BRK" (list 3))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_H "")

          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH #BrkH)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; 最新情報を使用する
          (SKY_Stretch_Parts #sym (nth 3 #XD$) (nth 4 #XD$) (nth 2 #DLOG$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_H)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <W1右側ｷｬﾋﾞ間口>
      (if (not (equal (nth 3 #DLOG$) #W1 0.0001)) ; W1(W)
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (setq #BrkW (+ #D2 (* #A1 0.5)))

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))

          (CFSetXData #XLINE_W "G_BRK" (list 1))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_W "")

          (setq CG_TOKU_BW #BrkW)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; 最新情報を使用する
          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 3 #DLOG$) #W1)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_W)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <W2左側ｷｬﾋﾞ間口>
      (if (not (equal (nth 4 #DLOG$) #W2 0.0001)) ; W2(D)
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (setq #BrkD (+ #D1 (* #A2 0.5)))

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))

          (CFSetXData #XLINE_D "G_BRK" (list 2))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_D "")

          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD #BrkD)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; 最新情報を使用する
          (SKY_Stretch_Parts #sym (nth 3 #XD$) (+ (nth 4 #XD$)(- (nth 4 #DLOG$) #W2)) (nth 5 #XD$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_D)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;//////////////////////////////////////////////////////////////////////////////////////////////

    )
    (progn ; ｺｰﾅｰｷｬﾋﾞ以外のとき
      (setq #tCNRflg nil)

      (if #TOKU_XD$
        (progn
          (setq #W1 (car   (nth 2 #TOKU_XD$))) ; 寸法W1
          (setq #W2 (cadr  (nth 2 #TOKU_XD$))) ; 寸法W2
          (setq #W3 (caddr (nth 2 #TOKU_XD$))) ; 寸法W3
          ;03/10/17 YM ADD 4枚目扉幅追加
          (setq #W4 (nth 10 #TOKU_XD$)) ; 寸法W4
        )
        (progn
          (setq #W1 (nth 2 CG_QRY$)) ; 寸法W1
          (setq #W2 (nth 3 CG_QRY$)) ; 寸法W2
          (setq #W3 (nth 4 CG_QRY$)) ; 寸法W3
          (setq #W4 (nth 5 CG_QRY$)) ; 寸法W4 03/10/17 YM ADD
        )
      );_if

      ;03/10/17 YM ADD 4枚目扉幅追加
      (if (= nil #W4)
        (setq #W4 0)
      );_if

      (setq #D  (nth 4 #XD$)) ; 寸法D
      (setq #H  (nth 5 #XD$)) ; 寸法H

      ; ダイアログ表示
      (setq #WDH$ (list #D #H #W1 #W2 #W3 #W4)) ; 通常ｷｬﾋﾞ用 ; NAS用 01/10/09 YM #W4追加 03/10/17 YM
      (setq #DLOG$ (PcGetStretchCabInfoDlg_N #WDH$))     ; NAS用 01/10/09 YM @@@@@@@@@@@@@@@@@@@@@
      (if (not #DLOG$)
        (quit)
      );_if

      ; #DLOG$ 戻り値 = D,H,W1,W2,W3

      ; 伸縮実行 W1,W2,W3,D,H の順番に最高５回行う

    ;/////////////////////////////////////////////////////////////////////// <W方向1>
      (if (not (equal (nth 2 #DLOG$) #W1 0.0001)) ; W1
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (setq #BrkW1 (* #W1 0.5))

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_W1 (PK_MakeBreakW #pt #ANG #BrkW1))

          (CFSetXData #XLINE_W1 "G_BRK" (list 1))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_W1 "")

          (setq CG_TOKU_BW #BrkW1)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 2 #DLOG$) #W1)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_W1)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <W方向2>
      (if (and (not (equal #W2 0 0.0001))
               (not (equal (nth 3 #DLOG$) #W2 0.0001))) ; W2
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (setq #BrkW2 (+ (nth 2 #DLOG$)(* #W2 0.5)))

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_W2 (PK_MakeBreakW #pt #ANG #BrkW2))

          (CFSetXData #XLINE_W2 "G_BRK" (list 1))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_W2 "")

          (setq CG_TOKU_BW #BrkW2)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; 最新情報を使用する
          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 3 #DLOG$) #W2)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_W2)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <W方向3>
      (if (and (not (equal #W3 0 0.0001))
               (not (equal (nth 4 #DLOG$) #W3 0.0001))) ; W3
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (setq #BrkW3 (+ (nth 2 #DLOG$)(nth 3 #DLOG$)(* #W3 0.5)))

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_W3 (PK_MakeBreakW #pt #ANG #BrkW3))

          (CFSetXData #XLINE_W3 "G_BRK" (list 1))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_W3 "")

          (setq CG_TOKU_BW #BrkW3)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; 最新情報を使用する
          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 4 #DLOG$) #W3)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_W3)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;03/10/17 YM ADD-S
    ;/////////////////////////////////////////////////////////////////////// <W方向4> 4枚扉対応
      (if (and (not (equal #W4 0 0.0001))
               (not (equal (nth 5 #DLOG$) #W4 0.0001))) ; W4
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (setq #BrkW4 (+ (nth 2 #DLOG$)(nth 3 #DLOG$)(nth 4 #DLOG$)(* #W4 0.5)))

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_W4 (PK_MakeBreakW #pt #ANG #BrkW4))

          (CFSetXData #XLINE_W4 "G_BRK" (list 1))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_W4 "")

          (setq CG_TOKU_BW #BrkW4)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; 最新情報を使用する
          (SKY_Stretch_Parts #sym (+ (nth 3 #XD$)(- (nth 5 #DLOG$) #W4)) (nth 4 #XD$) (nth 5 #XD$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_W4)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)
    ;03/10/17 YM ADD-E 4枚扉対応

    ;/////////////////////////////////////////////////////////////////////// <D方向>
      (if (not (equal (nth 0 #DLOG$) #D 0.0001)) ; D
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (setq #BrkD (* #D 0.5))

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))

          (CFSetXData #XLINE_D "G_BRK" (list 2))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_D "")

          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD #BrkD)
          (setq CG_TOKU_BH nil)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; 最新情報を使用する
          (SKY_Stretch_Parts #sym (nth 3 #XD$) (nth 0 #DLOG$) (nth 5 #XD$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_D)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;/////////////////////////////////////////////////////////////////////// <H方向>
      (if (not (equal (nth 1 #DLOG$) #H 0.0001)) ; H
        (progn
          (setq #flg T) ; 伸縮処理をする
          ;;; ﾌﾞﾚｰｸﾗｲﾝ位置取得
          (if CG_BASE_UPPER ; 上基点
            (setq #BrkH (- #rZ 150)) ; ｼﾝﾎﾞﾙ取り付け高さ-150mm(fix)
;-- 2011/08/24 A.Satoh Mod - S
;            (setq #BrkH 100) ; 下基点 H=100mm(fix)
            (setq #BrkH 480) ; 下基点 H=480mm 暫定
;-- 2011/08/24 A.Satoh Mod - E
          );_if

          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))

          (CFSetXData #XLINE_H "G_BRK" (list 3))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_H "")

          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH #BrkH)

          (setq #XD$  (CFGetXData #sym "G_SYM" )) ; 最新情報を使用する
          (SKY_Stretch_Parts #sym (nth 3 #XD$) (nth 4 #XD$) (nth 1 #DLOG$))

          ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
          (entdel #XLINE_H)
          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      (KP_TOKU_GROBAL_RESET)

    ;//////////////////////////////////////////////////////////////////////////////////////////////

    )
  );_if


  ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
  (foreach #eD #eDelBRK_W$ (entdel #eD)) ; W方向ブレーク復活
  (foreach #eD #eDelBRK_D$ (entdel #eD)) ; D方向ブレーク復活
  (foreach #eD #eDelBRK_H$ (entdel #eD)) ; H方向ブレーク復活

  ;色を戻す
  (command "_change" #ss "" "P" "C" "BYLAYER" "")

  ;基準ｱｲﾃﾑの場合は基準ｱｲﾃﾑ色にする。
  (if (and (setq #bsym (car (CFGetXRecord "BASESYM")))
           (equal (handent #bsym) #sym))
    (progn
      (ResetBaseSym)
      (GroupInSolidChgCol #sym CG_BaseSymCol)
    )
  );_if

  ;;; 確認ﾀﾞｲｱﾛｸﾞ(品番,価格入力画面)は常に表示する
; 02/07/09 YM DEL-S
;;; (if #flg
;;;   (progn
; 02/07/09 YM DEL-E

      (setq #ret$
        (ShowTOKUCAB_Dlog_N

          #HINBAN ; 01/10/17 YM MOD

;;;01/10/17YM@DEL         (if (= #LR "Z")
;;;01/10/17YM@DEL           (strcat #HINBAN) ; 品番
;;;01/10/17YM@DEL           (strcat #HINBAN #LR) ; 品番
;;;01/10/17YM@DEL         );_if

          "0"
          (list (nth 0 #DLOG$)(nth 1 #DLOG$)(nth 2 #DLOG$)) ; 通常ｷｬﾋﾞ ; 使っていない
          #ORG_price ; 元の価格
          #sHINMEI ; 品名
          #sBIKOU  ; 備考
        )
      ); 品番,価格

      ; 01/10/17 YM ADD-S
      (if (= nil #ret$)
        (quit)
      );_if
      ; 01/10/17 YM ADD-E

      ; 全角ｽﾍﾟｰｽを半角ｽﾍﾟｰｽに置きかえる 01/06/27 YM ADD
      (setq #userHINBAN (vl-string-subst "  " "　" (nth 0 #ret$))) ; ﾕｰｻﾞｰ入力品番
      ; 02/07/10 YM ADD-S
      (setq #userHINMEI (nth 2 #ret$)) ; ﾕｰｻﾞｰ入力品名
      (setq #userBIKOU  (nth 3 #ret$)) ; ﾕｰｻﾞｰ入力備考
      ; 02/07/10 YM ADD-E

      ;;; ダイアログから獲得されたリストを特注キャビ拡張データに格納
      (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))
      (CFSetXData #sym "G_TOKU"
        (list
          #userHINBAN   ; ﾕｰｻﾞｰ入力品番
          (nth 1 #ret$) ; 価格
;;;         (list (nth 0 #DLOG$)(nth 1 #DLOG$)(nth 2 #DLOG$))

          (if #tCNRflg ; 01/10/10 YM MOD
            "" ; ｺｰﾅｰｷｬﾋﾞ
            (list (nth 2 #DLOG$)(nth 3 #DLOG$)(nth 4 #DLOG$)) ; (W1,W2,W3)を覚えておく(次回使用)
          );_if

          1 ; 1:特注ｷｬﾋﾞｺﾏﾝﾄﾞ 0:ｹｺﾐ伸縮
;;;         CG_TOKU_BW ; W ﾌﾞﾚｰｸﾗｲﾝ位置
;;;         CG_TOKU_BD ; D ﾌﾞﾚｰｸﾗｲﾝ位置
;;;         CG_TOKU_BH ; H ﾌﾞﾚｰｸﾗｲﾝ位置
          "" ; W ﾌﾞﾚｰｸﾗｲﾝ位置 ﾀﾞﾐｰ
          "" ; D ﾌﾞﾚｰｸﾗｲﾝ位置 ﾀﾞﾐｰ
          "" ; H ﾌﾞﾚｰｸﾗｲﾝ位置 ﾀﾞﾐｰ
          #HINBAN    ; 元の品番

          ; 02/07/10 YM ADD-S 品番、価格に加えて品名と備考も保持する
          #userHINMEI   ; 品名(見積明細,仕様表での「名称」)
          #userBIKOU    ; 備考(見積明細での「備考」,仕様表での「仕様」)
          ; 02/07/10 YM ADD-E

          (nth 5 #DLOG$);4枚目扉幅 #W4 03/10/17 YM ADD

        )
      )

; 02/07/09 YM DEL-S
;;;   )
;;;   (princ "\n伸縮しませんでした。")
;;; );_if
; 02/07/09 YM DEL-E

  ; 02/07/09 YM ADD-S
  (if (= #flg nil)
    (princ "\n伸縮しませんでした。")
  )
  ; 02/07/09 YM ADD-E

  (princ)
); PcStretchCab_N

;<HOM>*************************************************************************
; <関数名>    : PcGetStretchCabInfoDlg_N
; <処理概要>  : 伸縮キャビネットのサイズと拡張データ内容獲得(通常ｷｬﾋﾞ)
; <戻り値>    : 結果リスト
; <作成>      : 01/10/09 YM NAS用
; <備考>      :
;*************************************************************************>MOH<
(defun  PcGetStretchCabInfoDlg_N (
  &Defo$
;;;(list #D #H #W1 #W2 #W3) 引数
  /
  #DCL_ID #ID #IH #IW1 #IW2 #IW3 #RES$
#iW4 ;03/10/17 YM ADD
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 半角数値かどうか
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
(defun ##GetDlgItem (
  / ; ﾀﾞｲｱﾛｸﾞの結果を取得する
  #RES$
  )
  (setq #RES$ (list
    (atoi (get_tile "D"))
    (atoi (get_tile "H"))
    (atoi (get_tile "W1"))
    (atoi (get_tile "W2"))
    (atoi (get_tile "W3"))
    (atoi (get_tile "W4")));03/10/17 YM ADD
  )
  (done_dialog)
  #RES$
);##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; デフォWDH
  (setq #iD  (fix (nth 0 &Defo$)))
  (setq #iH  (fix (nth 1 &Defo$)))
  (setq #iW1 (fix (nth 2 &Defo$)))
  (setq #iW2 (fix (nth 3 &Defo$)))
  (setq #iW3 (fix (nth 4 &Defo$)))
  ;03/10/17 YM ADD-S
  (if (nth 5 &Defo$)
    (setq #iW4 (fix (nth 5 &Defo$)))
    (setq #iW4 0)
  );_if
  ;03/10/17 YM ADD-E

  ;;; ダイアログの実行部
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (not (new_dialog "GetStretchCabInfoDlg_N" #dcl_id)) (exit))

  ;;; デフォ文字列の設定
;;;  (set_tile "Msg1" "   対象キャビネット のサイズは")
;;;  (set_tile "Msg2" (strcat "   現在 幅= " (itoa #iW) ", 奥行= " (itoa #iD) ", 高さ= " (itoa #iH) " です"))
  (set_tile "D"  (itoa #iD))
  (set_tile "H"  (itoa #iH))
  (set_tile "W1" (itoa #iW1))

  (if (equal #iW2 0 0.1)
    (progn
      (set_tile "W2" "0")
      (mode_tile "W2" 1) ; 使用不可能
    )
    (progn
      (set_tile "W2" (itoa #iW2))
    )
  );_if

  (if (equal #iW3 0 0.1)
    (progn
      (set_tile "W3" "0")
      (mode_tile "W3" 1) ; 使用不可能
    )
    (progn
      (set_tile "W3" (itoa #iW3))
    )
  );_if

  ;03/10/17 YM ADD-S
  (if (equal #iW4 0 0.1)
    (progn
      (set_tile "W4" "0")
      (mode_tile "W4" 1) ; 使用不可能
    )
    (progn
      (set_tile "W4" (itoa #iW4))
    )
  );_if
  ;03/10/17 YM ADD-E

  ;;; タイルのリアクション設定 半角実数のﾁｪｯｸ
  (action_tile "D"  "(##CHK_edit \"D\"  (itoa #iD ) 1)")
  (action_tile "H"  "(##CHK_edit \"H\"  (itoa #iH ) 1)")
  (action_tile "W1"  "(##CHK_edit \"W1\"  (itoa #iW1 ) 1)")
  (action_tile "W2"  "(##CHK_edit \"W2\"  (itoa #iW2 ) 1)")
  (action_tile "W3"  "(##CHK_edit \"W3\"  (itoa #iW3 ) 1)")
  (action_tile "W4"  "(##CHK_edit \"W4\"  (itoa #iW4 ) 1)");03/10/17 YM ADD

  (action_tile "accept" "(setq #RES$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #RES$ nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #RES$
);PcGetStretchCabInfoDlg_N

;<HOM>*************************************************************************
; <関数名>    : PcGetStretchCabInfoDlg_N_CNR
; <処理概要>  : 伸縮キャビネットのサイズと拡張データ内容獲得(隅用ｷｬﾋﾞ)
; <戻り値>    : 結果リスト
; <作成>      : 01/10/10 YM NAS用
; <備考>      :
;*************************************************************************>MOH<
(defun  PcGetStretchCabInfoDlg_N_CNR (
  &Defo$
;;;(list #D2 #D1 #H #W1 #W2) 引数
  /
  #DCL_ID #ID1 #ID2 #IH #IW1 #IW2 #RES$
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 引数のキー以外はｸﾞﾚｰｱｳﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##STOP (
    &sKEY ; key
    /
    )
    (cond
      ((= &sKEY "D2")
        (mode_tile "D1" 1) ; 使用不可能
        (mode_tile "H"  1) ; 使用不可能
        (mode_tile "W1" 1) ; 使用不可能
        (mode_tile "W2" 1) ; 使用不可能
      )
      ((= &sKEY "D1")
        (mode_tile "D2" 1) ; 使用不可能
        (mode_tile "H"  1) ; 使用不可能
        (mode_tile "W1" 1) ; 使用不可能
        (mode_tile "W2" 1) ; 使用不可能
      )
      ((= &sKEY "H")
        (mode_tile "D1" 1) ; 使用不可能
        (mode_tile "D2" 1) ; 使用不可能
        (mode_tile "W1" 1) ; 使用不可能
        (mode_tile "W2" 1) ; 使用不可能
      )
      ((= &sKEY "W1")
        (mode_tile "D1" 1) ; 使用不可能
        (mode_tile "D2" 1) ; 使用不可能
        (mode_tile "H"  1) ; 使用不可能
        (mode_tile "W2" 1) ; 使用不可能
      )
      ((= &sKEY "W2")
        (mode_tile "D1" 1) ; 使用不可能
        (mode_tile "D2" 1) ; 使用不可能
        (mode_tile "H"  1) ; 使用不可能
        (mode_tile "W1" 1) ; 使用不可能
      )
    );_cond
    (princ)
  );##STOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 初期値に戻す
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##clear (
    /
    #ID1 #ID2 #IH #IW1 #IW2
    )
    (mode_tile "D1" 0) ; 使用可
    (mode_tile "D2" 0) ; 使用可
    (mode_tile "H"  0) ; 使用可
    (mode_tile "W1" 0) ; 使用可
    (mode_tile "W2" 0) ; 使用可
    (setq #iD2 (fix (nth 0 &Defo$)))
    (setq #iD1 (fix (nth 1 &Defo$)))
    (setq #iH  (fix (nth 2 &Defo$)))
    (setq #iW1 (fix (nth 3 &Defo$)))
    (setq #iW2 (fix (nth 4 &Defo$)))
    ;;; デフォ文字列の設定
    (set_tile "D2" (itoa #iD2))
    (set_tile "D1" (itoa #iD1))
    (set_tile "H"  (itoa #iH))
    (set_tile "W1" (itoa #iW1))
    (set_tile "W2" (itoa #iW2))
    (princ)
  );##clear

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 半角数値かどうか
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
          (progn ; 03/02/05 YM ADD-S
            ; 編集したボックス以外は編集不可とする
            (cond
              ((= &sKEY "D2")
                (if (= #val (nth 0 &Defo$))
                  nil ; 初期値と同じなら何もしない
                  (##STOP "D2") ; 引数以外を使用禁止
                );_if
              )
              ((= &sKEY "D1")
                (if (= #val (nth 1 &Defo$))
                  nil ; 初期値と同じなら何もしない
                  (##STOP "D1") ; 引数以外を使用禁止
                );_if
              )
              ((= &sKEY "H")
                (if (= #val (nth 2 &Defo$))
                  nil ; 初期値と同じなら何もしない
                  (##STOP "H") ; 引数以外を使用禁止
                );_if
              )
              ((= &sKEY "W1")
                (if (= #val (nth 3 &Defo$))
                  nil ; 初期値と同じなら何もしない
                  (##STOP "W1") ; 引数以外を使用禁止
                );_if
              )
              ((= &sKEY "W2")
                (if (= #val (nth 4 &Defo$))
                  nil ; 初期値と同じなら何もしない
                  (##STOP "W2") ; 引数以外を使用禁止
                );_if
              )
            );_cond
          ) ; 03/02/05 YM ADD-E
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
(defun ##GetDlgItem (
  / ; ﾀﾞｲｱﾛｸﾞの結果を取得する
  #RES$
  )
  (setq #RES$ (list
    (atoi (get_tile "D2"))
    (atoi (get_tile "D1"))
    (atoi (get_tile "H"))
    (atoi (get_tile "W1"))
    (atoi (get_tile "W2")))
  )
  (done_dialog)
  #RES$
);##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;(list #D2 #D1 #H #W1 #W2) 引数
  (setq #iD2 (fix (nth 0 &Defo$)))
  (setq #iD1 (fix (nth 1 &Defo$)))
  (setq #iH  (fix (nth 2 &Defo$)))
  (setq #iW1 (fix (nth 3 &Defo$)))
  (setq #iW2 (fix (nth 4 &Defo$)))

  ;;; ダイアログの実行部
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (not (new_dialog "GetStretchCabInfoDlg_N_CNR" #dcl_id)) (exit))

  ;;; デフォ文字列の設定
  (set_tile "D2" (itoa #iD2))
  (set_tile "D1" (itoa #iD1))
  (set_tile "H"  (itoa #iH))
  (set_tile "W1" (itoa #iW1))
  (set_tile "W2" (itoa #iW2))

  ;;; タイルのリアクション設定 半角実数のﾁｪｯｸ
  (action_tile "D2" "(##CHK_edit \"D2\" (itoa #iD2 ) 1)")
  (action_tile "D1" "(##CHK_edit \"D1\" (itoa #iD1 ) 1)")
  (action_tile "H"  "(##CHK_edit \"H\"  (itoa #iH  ) 1)")
  (action_tile "W1" "(##CHK_edit \"W1\" (itoa #iW1 ) 1)")
  (action_tile "W2" "(##CHK_edit \"W2\" (itoa #iW2 ) 1)")
  (action_tile "BUTTON"  "(##CLEAR)")

  (action_tile "accept" "(setq #RES$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #RES$ nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #RES$
);PcGetStretchCabInfoDlg_N_CNR

;<HOM>*************************************************************************
; <関数名>    : ShowTOKUCAB_Dlog_N
; <処理概要>  : 特注ｷｬﾋﾞｺﾏﾝﾄﾞ価格,品番確認ﾀﾞｲｱﾛｸﾞ
; <戻り値>    : 価格,品番
; <作成>      : 01/01/29 YM
; <備考>      :
; ***********************************************************************************>MOH<
(defun ShowTOKUCAB_Dlog_N (
  &HINBAN
  &PRICE ; 価格ﾃﾞﾌｫﾙﾄ値
  &WDH
  &ORG_price ; 元の価格
  &sHINMEI ; 品名 01/08/20 YM ADD
  &sBIKOU  ; 備考 01/08/20 YM ADD
  /
  #SDCLID #RES$
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckNum (&sKEY / #val #ret)
    (setq #ret nil)
    (setq #val (read (get_tile &sKEY)))
    (if (= (type (read (get_tile &sKEY))) 'INT)
      (if (< #val -0.00001)
        (progn
          (alert "0以上の整数値を入力して下さい")
          (set_tile &sKEY "")
          (mode_tile &sKEY 2)
        )
        (setq #ret T)
      );_if
      (progn
        (alert "0以上の整数値を入力して下さい")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckStr (&sKEY / #ret)
    (setq #ret nil)
; 03/01/27 YM DEL-S
;;;    (if (= (type (read (get_tile &sKEY))) 'SYM)
;;;     (progn
; 03/01/27 YM DEL-E

        (if (= (get_tile &sKEY) &HINBAN)
          (progn
            (alert "特注品番を入力して下さい")
;;;           (set_tile &sKEY "")
            (mode_tile &sKEY 2)
          )
          (setq #ret T)
        );_if

; 03/01/27 YM DEL-S
;;;     )
;;;     (progn
;;;        (alert "文字列を入力して下さい")
;;;        (set_tile &sKEY "")
;;;        (mode_tile &sKEY 2)
;;;     )
;;;    );_if
; 03/01/27 YM DEL-E

    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; 全項目チェック。通れば結果リストに加工して返す。
  (defun ##Check&GetAllVal ( / #DLG$)
    (cond
      ((not (##CheckNum "edtTOKU_PRI"))  nil) ; 項目にｴﾗｰがあるとnilを返す
      ((not (##CheckStr "edtTOKU_ID")) nil)   ; 項目にｴﾗｰがあるとnilを返す
;;;     ; 02/07/10 YM ADD-S
;;;     ((not (##CheckStr "edtHINMEI")) nil)    ; 項目にｴﾗｰがあるとnilを返す
;;;     ((not (##CheckStr "edtBIKOU")) nil)     ; 項目にｴﾗｰがあるとnilを返す
;;;     ; 02/07/10 YM ADD-E

      (T ; 項目にｴﾗｰなし
        (setq #DLG$
          (list
            (strcase (get_tile "edtTOKU_ID"))  ; 品番 大文字にする
;;;02/01/21YM@MOD           (atoi (get_tile "edtTOKU_PRI"))      ; 価格(円)
            (atof (get_tile "edtTOKU_PRI")) ; 価格 02/01/21 YM 実数にする(整数16bit)
            ; 02/07/10 YM ADD-S
            (get_tile "edtHINMEI")  ; 品名
            (get_tile "edtBIKOU")   ; 備考
            ; 02/07/10 YM ADD-E
          )
        )
        (done_dialog)
        #DLG$
      )
    );_cond
  ); end of ##Check&GetAllVal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; 全項目チェック。通れば結果リストに加工して返す。
  (defun ##Exit ( / )
    (done_dialog)
    nil
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;; ダイアログの実行部
  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "ShowTOKUCABDlg_N" #sDCLID)) (exit))

  ; 初期値の設定 ; txtORG_PRICE
  (set_tile "edtTOKU_ID" &HINBAN) ; 品番
  (set_tile "edtTOKU_PRI" &PRICE) ; 価格
  (set_tile "txtORG_PRICE" (strcat "　元の価格： " &ORG_price "円"))

  ; 02/07/10 YM MOD-S ｴﾃﾞｨｯﾄﾎﾞｯｸｽに変更
;;;  (set_tile "txtHINMEI"    (strcat "　品　名　　： " &sHINMEI)) ; 品名 01/08/20 YM ADD
;;;  (set_tile "txtBIKOU"     (strcat "　備　考　　： " &sBIKOU))  ; 備考 01/08/20 YM ADD
  (set_tile "edtHINMEI" &sHINMEI) ; 品名
  (set_tile "edtBIKOU"  &sBIKOU)  ; 備考
  ; 02/07/10 YM MOD-E

;;;01/10/17YM@DEL (mode_tile "edtTOKU_PRI" 2)
  (mode_tile "edtTOKU_ID" 2)

;;;  (set_tile "edtTOKU_W" (nth 0 &WDH))
;;;  (set_tile "edtTOKU_D" (nth 1 &WDH))
;;;  (set_tile "edtTOKU_H" (nth 2 &WDH))

  ;;; タイルのリアクション設定
;;;  (action_tile "edtTOKU_ID"  "(##CHK_edit \"edtTOKU_ID\"  &HINBAN 2)")
;;;  (action_tile "edtTOKU_PRI" "(##CHK_edit \"edtTOKU_PRI\" &PRICE  1)")

  ; OKボタンが押されたら全項目をチェック。通れば結果リストに加工して返す。
  (action_tile "accept" "(setq #RESULT$ (##Check&GetAllVal))")
  (action_tile "cancel" "(setq #RESULT$ (##Exit))") ; cancel

  (start_dialog)
  (unload_dialog #sDCLID)
  ; リストを返す
  #RESULT$
);ShowTOKUCAB_Dlog_N

;<HOM>*************************************************************************
; <関数名>    : PhSelColorMixPatternDlg
; <処理概要>  : COLORミックスパターンの選択
; <戻り値>    : COLORミックスパターン(STR)
; <作成>      : 01/10/11 YM
; <備考>      : なし(ｸﾞﾛｰﾊﾞﾙ変数にｾｯﾄ) CG_ColMix ="[扉Mix名].ﾐｯｸｽ名称"
;               PHCAD以外は何もしない
;*************************************************************************>MOH<
(defun PhSelColorMixPatternDlg (
  /

  )
  nil
);PhSelColorMixPatternDlg

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_ZaisituDlg
;;; <処理概要>  : 材質選択ダイアログ
;;; <戻り値>    : 材質記号
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKW_ZaisituDlg (
  /
  #DCL_ID #POP$ #QRY$$ #ZAI #ZCODE #SINA_Type #dum$$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_ZaisituDlg ////")
  (CFOutStateLog 1 1 " ")

  (setq #SINA_Type (KPGetSinaType)) ; 商品ﾀｲﾌﾟ=3(Sophy & Shera)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #zai #cut
            )
            (setq #zai (nth (atoi (get_tile "zai")) #pop$)) ; 材質記号

            (setq #cut nil)
            (cond
              ((= (get_tile "radio1") "1")(setq #cut 0))
              ((= (get_tile "radio2") "1")(setq #cut 1))
              ((= (get_tile "radio3") "1")(setq #cut 2))
              ((= (get_tile "radio4") "1")(setq #cut 3))
            );_cond

            (if #cut
              (progn
                (done_dialog)
                (list #zai #cut)
              )
              (progn
                (CFAlertMsg "カットの種類を選択して下さい。")
                (princ)
              )
            );_if

          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( / #dum$$) ; 材質ポップアップリスト
            (setq #pop$ '())
            (start_list "zai" 3)
						(setq #dum$$ nil)
            (foreach #Qry$ #Qry$$
							;2011/09/18 YM ADD-S 形状で材質を絞り込む
							(if (wcmatch CG_W2CODE (nth 9 #Qry$)) ;対応可能な形状(ｶﾝﾏ区切り) Z,L,U
								(progn
	              	(add_list (strcat (nth 1 #Qry$) " : " (nth 2 #Qry$)))
									(setq #dum$$ (append #dum$$ (list #Qry$)))
              		(setq #pop$ (append #pop$ (list (nth 1 #Qry$)))) ; 材質記号のみ保存
								)
							);_if
            )
						;2011/09/18 YM ADD 形状で材質を絞り込む
						(setq #Qry$$ #dum$$);絞り込んだものに更新
            (end_list)
            (set_tile "zai" "0") ; 最初にﾌｫｰｶｽ
            (setq #Zcode (nth (atoi (get_tile "zai")) #pop$))  ; 現在選択中の材質
            (princ)
          );##Addpop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 材質によってｶｯﾄ種類を制御
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Check_CUT ( / #zK #ZaiF #ZCODE #qry_zai$ #cut_typ)
            (setq #Zcode (nth (atoi (get_tile "zai")) #pop$))  ; 現在選択中の材質
            (setq #ZaiF (KCGetZaiF #Zcode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ

            (cond
              ((= CG_W2CODE "Z")
                (set_tile "radio1" "1") ; ｶｯﾄなし
                (mode_tile "cut"  1) ; 使用不可能 ｶｯﾄ種類ﾗｼﾞｵ
              )
              (T
                (mode_tile "cut"  0)    ; 使用可能 ｶｯﾄ種類ﾗｼﾞｵ
								;L型,U型
                ;mdb検索
                (setq #qry_zai$
                  (CFGetDBSQLRec CG_DBSESSION "WT材質"
                    (list
                      (list "材質記号" #Zcode 'STR)
                    )
                  )
                )
							 	(setq #cut_typ (nth 6 (car #qry_zai$)));X,J,N
							 	(cond
									((= #cut_typ "N")
                  	(set_tile  "radio1" "1") ; ｶｯﾄなし
										(mode_tile "radio2" 1)
										(mode_tile "radio3" 1)
										(mode_tile "radio4" 1)
								 	)
									((= #cut_typ "X")
										(mode_tile "radio1" 1)
                  	(set_tile  "radio2" "1") ; 斜めｶｯﾄ
										(mode_tile "radio3" 1)
										(mode_tile "radio4" 1)
								 	)
									((= #cut_typ "J")
										(mode_tile "radio1" 1)
										(mode_tile "radio2" 1)
                  	(set_tile  "radio3" "1") ; 方向ｶｯﾄ KDA対応 03/10/13 YM ADD
										(mode_tile "radio4" 1)
								 	)
									((= #cut_typ "S")
										(mode_tile "radio1" 1)
										(mode_tile "radio2" 1)
										(mode_tile "radio3" 1)
                  	(set_tile  "radio4" "1") ; 方向ｶｯﾄ KDA対応 03/10/13 YM ADD
								 	)
									(T
                  	(set_tile  "radio1" "1") ; ｶｯﾄなし
										(mode_tile "radio2" 1)
										(mode_tile "radio3" 1)
										(mode_tile "radio4" 1)
								 	)
								);_cond

              )
            );_cond

            (princ)
          );##Check_CUT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;// 材質記号の選択
  (setq #Qry$$
    (DBSqlAutoQuery CG_DBSESSION
      (strcat "select * from WT材質 where 廃番F=0")
    )
  )
  (setq #Qry$$ (CFListSort #Qry$$ 0)) ; (nth 0 が小さいもの順にｿｰﾄ 01/05/28 YM ADD

  ; 廃盤Fが1でないもの 01/08/10 YM ADD START
  (setq #dum$$ nil)
  (foreach #Qry$ #Qry$$
    (setq #dum$$ (append #dum$$ (list #Qry$)))
  )
  (setq #Qry$$ #dum$$)
  ; 廃盤Fが1でないもの 01/08/10 YM ADD END

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "ZaisituDlg" #dcl_id)) (exit))

  ;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
  (##Addpop)
  ;;; 初期ｶｯﾄ種類設定
  (##Check_CUT)

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "zai" "(##Check_CUT)")
  (action_tile "accept" "(setq #zai (##GetDlgItem))")
  (action_tile "cancel" "(setq #zai nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #zai
);PKW_ZaisituDlg

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_DansaHantei
;;; <処理概要>  : （任意配置）ワークトップ自動生成 I型,L型,U型対応,Dｶｯﾄ対応
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_DansaHantei (
  &base$ ;
  /
  #EN_LOW$ #H #HND #HNDB #SS_DEL #THR
  )
  (setq #hndB (car (CFGetXRecord "BASESYM"))) ; 基準ｱｲﾃﾑ
  (setq #en_LOW$ nil)
  (setq #ss_del (ssadd))
  ;;; ﾛｰｷｬﾋﾞ部材を自動的に除外(寸法Hを見ている)
  (foreach #en &base$
    (setq #thr (CFGetSymSKKCode #en 3))
    (cond
      ; 02/03/28 YM MOD-S
      ((or (= #thr CG_SKK_THR_GAS)(= #thr CG_SKK_THR_NRM))
        (setq #h (nth 5 (CFGetXData #en "G_SYM")))
        (if (and (> #h 450) (< #h 550)) ; もしﾛｰﾀｲﾌﾟのｷｬﾋﾞﾈｯﾄがあれば段差ﾌﾟﾗﾝ
          (progn ; 段差ｷｬﾋﾞ除外
            (setq CG_Type2Code "D") ; "F","D"
            (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ﾛｰﾀｲﾌﾟｷｬﾋﾞﾈｯﾄｼﾝﾎﾞﾙ図形ﾘｽﾄ
            ;;; 基準ｱｲﾃﾑなら緑
            (setq #hnd  (cdr (assoc 5 (entget #en))))
            (if (equal #hnd #hndB)
              (GroupInSolidChgCol #en CG_BaseSymCol) ; 緑
              (GroupInSolidChgCol2 #en "BYLAYER") ; 色を戻す
            );_if
            (ssadd #en #ss_del) ; 後で除外する
          )
        );_if
      )
      ; 02/03/28 YM MOD-E
    );_cond
  );_(foreach #en #en$   ;// ﾛｰｷｬﾋﾞ部材を省く
  (list #ss_del #en_LOW$)
);KP_DansaHantei


; ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ 02/09/03 YM ADD

;<HOM>*************************************************************************
; <関数名>    : SKAutoError1
; <処理概要>  : ｴﾗｰ関数 ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ
;*************************************************************************>MOH<
(defun SKAutoError1 ( msg / #msg )
;;;  (princ "\n自動レイアウト処理が中断されました.")
  (setq #msg "メイン画面に戻ります")
  (CFAlertMsg #msg)

;;;  ;// エラーログを出力する
;;;  (CFOutErrLog)
;;;  (foreach #msg CG_ERRMSG
;;;    (CFOutLog 0 1 #msg)
;;;  )
  (setvar "FILEDIA" 1)
  (if (/= CG_DBSESSION nil)
    (DBDisConnect CG_DBSession)
  )
  (if (/= CG_CDBSESSION nil)
    (DBDisConnect CG_CDBSession)
  )
  (setq CG_DBSESSION nil)
  (setq CG_CDBSESSION nil)
;;;  (startapp (strcat CG_SYSPATH "WARN.EXE"))
;;;  (if (= CG_AUTOFLAG "1")
    (command "_quit" "y")
;;;  )
  (princ)
);SKAutoError1

; WEB版 02/09/03 YM ADD

;<HOM>*************************************************************************
; <関数名>    : SKAutoError2
; <処理概要>  : ｴﾗｰ関数 WEB版CADｻｰﾊﾞｰ
;*************************************************************************>MOH<
(defun SKAutoError2 ( msg / #msg )
  (princ "\n自動レイアウト処理が中断されました.")

;;;(WebOutLog "msg=")
;;;(WebOutLog msg)
;;;(WebOutLog "CG_ERRMSG=")
;;;(WebOutLog CG_ERRMSG)

  ;// エラーログ出力用文字列に追加する
  (if (/= msg CG_ERRMSG)
    (setq CG_ERRMSG (append CG_ERRMSG (list msg)))
  );_if

;;;  (CFAlertMsg msg) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@ 後で削除する!!!

;;; ; 通常ﾛｸﾞに書き込み
;;;  (foreach #msg CG_ERRMSG
;;;   (WebOutLog CG_ERRMSG)    ; 02/09/04 YM ADD ﾛｸﾞ出力追加
;;;  )

  ; ｴﾗｰﾛｸﾞに書き込み
  (CFOutErrLog)

  (setvar "FILEDIA" 1)
  (if (/= CG_DBSESSION nil)
    (DBDisConnect CG_DBSession)
  )
  (if (/= CG_CDBSESSION nil)
    (DBDisConnect CG_CDBSession)
  )

  (setq CG_DBSESSION nil)
  (setq CG_CDBSESSION nil)

;;;  (startapp (strcat CG_SYSPATH "WARN.EXE"))
;;;  (if (= CG_AUTOFLAG "1")
    (command "_quit" "y")
;;;  )
  (princ)
);SKAutoError2

;////////////////////////////////////////////////////////////////////////////////
; ﾌﾟﾗﾝ挿入ｺﾏﾝﾄﾞ
(defun C:ib ()
  (C:KP_InBlock)
)
; ﾌﾟﾗﾝ保存ｺﾏﾝﾄﾞ
(defun C:wb ()
  (C:KP_WrBlock)
)
;////////////////////////////////////////////////////////////////////////////////

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KP_WrBlock
;;; <処理概要>  : 既存ﾌﾟﾗﾝを名前を付けて保存する(後で再利用する)
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 01/04/25 YM
;;; <備考>      : 図面上にアイテムがないとダメ,基準アイテムの色は"BYLAYER"で保存する
;;;*************************************************************************>MOH<
(defun C:KP_WrBlock (
  /
  #EN #FLGTOKU #HAND #HNDB #I #IFILEDIA #J #N #PICKSTYLE #RET #SFNAME #SS #SSARW
  #SSKUTAI #SSROOM #SSTOKU #SSYASI #SS_DUM #TENDFLG #XDYASI$
#MODEL #MODEL_BACK ; 03/05/12 YM ADD
#PATH #PATH0       ; 03/07/04 YM
  )
    ;//////////////////////////////////////////////////////////////////////
    ;ｻﾌﾞﾙｰﾁﾝ化 03/05/13 YM
    ;//////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL_SUB ( &ss / #i )
      (if (and &ss (> (sslength &ss) 0)) ; 基準アイテムの矢印
        (progn
          ;// 新たに追加された基準アイテムの矢印を削除する
          (setq #i 0)
          (repeat (sslength &ss)
            (entdel (ssname &ss #i))
            (setq #i (1+ #i))
          )
        )
      );_if
      (princ)
    );##ENTDEL_SUB
    ;//////////////////////////////////////////////////////////////////////
    ;ｻﾌﾞﾙｰﾁﾝ化&扉の一時削除追加 03/05/13 YM
    ;//////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL ( / )
      ;基準アイテムの矢印を一時削除する
      (##ENTDEL_SUB #ssARW)
      ;図面枠と天井の点を一時削除する
      (##ENTDEL_SUB #ssROOM)
      ;図面上の扉を一時削除する
      (##ENTDEL_SUB #ssDOOR)
      (princ)
    );##ENTDEL
    ;//////////////////////////////////////////////////////////////////////

  (StartUndoErr);// コマンドの初期化
  (setq #iFILEDIA (getvar "FILEDIA"))
  (setvar "FILEDIA" 1)

  ; 02/11/11 YM ADD 躯体のみ書き出しモードを選択可能
  (setq #ret (KPGetBlockWrInsModeDlg))
  (if (= #ret nil)
    (*error*)
  ; else
    (if (= "1" #ret)
      (progn ; 今までどおり図面全体を保存 ----------------------------------------------

        (setq #ssTOKU (ssget "X" '((-3 ("G_TOKU")))))
        (setq #flgTOKU nil)
        (if (and #ssTOKU (< 0 (sslength #ssTOKU)))
          (progn ; 特注ｷｬﾋﾞ(ｹｺﾐ伸縮でない)が存在すると終了 01/05/15 YM ADD
            (setq #i 0)
            (repeat (sslength #ssTOKU)
              (if (= 1 (nth 3 (CFGetXData (ssname #ssTOKU #i) "G_TOKU")))
                (setq #flgTOKU T)
              );_if
              (setq #i (1+ #i))
            )
            (if #flgTOKU
              (progn
                (CFAlertErr "図面上に特注キャビネットが存在するため、プラン保存できません。")
                (*error*)
              )
            );_if
          )
        );_if

        (setq #ssARW  (ssget "X" '((-3 ("G_ARW")))))
        (setq #ssROOM (ssget "X" '((-3 ("G_ROOM")))))
        ; 03/05/13 YM ADD-S 図面上の全扉図形
        (setq #ssDOOR (KP_GetAllDoor))
        ; 03/05/13 YM ADD-S
        (setq #PICKSTYLE (getvar "PICKSTYLE"))
        (setvar "PICKSTYLE" 3)

        ;現在存在する作図領域番号を獲得
        (setq #ssYASI (ssget "X" (list (list -3 (list "RECT")))))
        ; 矢視があれば削除する
        (if (and #ssYASI (> (sslength #ssYASI) 0)) ; 矢視
          (if (CFYesNoDialog "保存前に矢視を削除する必要があります。\n矢視を削除しますか？")
            (progn
              ; 矢視削除
              (setq #i 0)
              (repeat (sslength #ssYASI) ; 矢視複数あり
                (setq #en (ssname #ssYASI #i))
                (setq #xdYASI$ (CFGetXData #en "RECT")) ; 拡張ﾃﾞｰﾀ
                (setq #n 3 #hand (nth #n #xdYASI$))
                (while #hand
                  (command "_erase" (handent #hand) "")
                  (setq #n (1+ #n))
                  (setq #hand (nth #n #xdYASI$))
                )
                (command "_erase" #en "")
                (setq #i (1+ #i))
              )
            )
            (*error*)
          );_if
        );_if

        ; 枠、天井の点、矢印を一時的に削除する 01/05/10 YM ADD
        (##ENTDEL) ; 03/05/13 YM 扉も一時削除

        (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
        (if (and #ss (> (sslength #ss) 0))
          (progn ; 図面上に何か部材があるとき
            ; 基準アイテムの色を一時的に元に戻す
            (setq #hndB (car (CFGetXRecord "BASESYM"))) ; 基準ｱｲﾃﾑ
            (if (and #hndB (/= #hndB ""))
              (GroupInSolidChgCol2 (handent #hndB) "BYLAYER")  ;BYLAYER色に変更
            )

          ; CG_DBNAME DB名のﾌｫﾙﾀﾞがあればそこに、なければ従来通りｼﾘｰｽﾞ記号のﾌｫﾙﾀﾞに保存する
          ; 03/07/04 YM MOD-S
          (setq #path0 (strcat CG_SYSPATH "PLAN\\" CG_DBNAME))
          (if (findfile #path0)
            ;新ｼﾘｰｽﾞ NK_KSA,NK_KGA など
            (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\"))
            ;else   従来ｼﾘｰｽﾞ(NK_CKC,NK_CKN など)
            (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
          );_if
;;;         (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\")) ; 03/07/04 YM MOD
          ; CG_DBNAME DB名 03/07/04 YM MOD-E

            ; ﾌｧｲﾙ指定
            (setq #sFname (getfiled "名前を付けて保存" #path "dwg" 1))
            (if #sFname
              (progn
      ;;;01/05/14YM@          (command "_purge" "A" "*" "N") ; 全てをﾊﾟｰｼﾞする 01/05/14

                ; 03/07/09 YM ADD 不要なｸﾞﾙｰﾌﾟ定義を削除する
                (KP_DelUnusedGroup)

                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")

                ; MODEL.DWGのSAVE 01/10/24 ADD-S
                (command "_.QSAVE")
                ; MODEL.DWGのSAVE 01/10/24 ADD-E

      ;;;         (command "_.save" #sFname) ; 復活 01/08/31 YM MOD
      ;;;         (command "_.SAVEAS" "2000" #sFname) ; saveas だと現在図面が"Model.dwg"ではなくなる

                ; 01/10/24 YM ADD-S ｺﾋﾟｰ元,ｺﾋﾟｰ先 -->ﾌｧｲﾙ既存ならｺﾋﾟｰに失敗
                (setq #tEndFlg (vl-file-copy  (strcat CG_KENMEI_PATH "MODEL.DWG") #sFname nil))
                (if (= nil #tEndFlg)
                  (progn ; 既存ﾌｧｲﾙありｺﾋﾟｰ不可の場合
                    (vl-file-delete #sFname)
                    (vl-file-copy  (strcat CG_KENMEI_PATH "MODEL.DWG") #sFname nil)
                  )
                );_if
                ; 01/10/24 YM ADD-E

      ;;;         ; 01/08/31 YM ADD-S MODEL.dwgを開く
      ;;;         (CfDwgOpenByScript (strcat CG_KENMEI_PATH "MODEL.DWG"))
      ;;;         ; 01/08/31 YM ADD-E
              )
              (progn
                (CFAlertMsg "\n保存しませんでした。")
                (*error*)
              )
            );_if

            ; 基準アイテムの色を元の緑に戻す
            (if (and #hndB (/= #hndB ""))
              (GroupInSolidChgCol2 (handent #hndB) CG_BaseSymCol) ;緑色に変更
            )
          )
          (progn
            (CFAlertMsg "\n図面上に部材がありません。")
            (*error*)
          )
        );_if

        ; 枠、天井の点、矢印を復活させる 01/05/10 YM ADD
        (##ENTDEL)
      )
      (progn ; 躯体のみ保存する ---------------------------------------------------------------------------------------

        ; 現在のMODEL.dwgを保存して別名で開く 03/01/24 YM ADD
        (command "_.QSAVE") ; 現状を保存(Model.dwg)

        (setq #MODEL      (strcat CG_KENMEI_PATH "MODEL.DWG"))
        (setq #MODEL_BACK (strcat CG_KENMEI_PATH "MODEL_BACK.DWG"))

        (if (findfile #MODEL_BACK)(vl-file-delete #MODEL_BACK)) ; "Model_BACK.dwg"があれば消す
        (command "_.SAVEAS" "2000" #MODEL_BACK) ; 現在図面が"Model_BACK.dwg"になる
;;;       (setq #tEndFlg (vl-file-copy #MODEL #MODEL_BACK nil))   ; ｺﾋﾟｰを作成

        ; 躯体以外を全て削除してから保存する
        (setq #ss (ssget "X" '((-3 ("G_KUTAI")))))
        (if (and #ss (> (sslength #ss) 0))
          (progn ; 図面上に躯体があるとき
            (DelwithoutKUTAI) ; 躯体以外は全て削除する

            ; ﾌｧｲﾙ指定
            (setq #sFname (getfiled "名前を付けて保存" (strcat CG_SYSPATH "PLAN\\" "KUTAI" "\\") "dwg" 1))
            (if #sFname
              (progn
                ; 03/07/09 YM ADD 不要なｸﾞﾙｰﾌﾟ定義を削除する
                (KP_DelUnusedGroup)

                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")

                (command "_.QSAVE")
                (setq #tEndFlg (vl-file-copy #MODEL_BACK #sFname nil))
                (if (= nil #tEndFlg)
                  (progn ; 既存ﾌｧｲﾙありｺﾋﾟｰ不可の場合
                    (vl-file-delete #sFname)
                    (vl-file-copy #MODEL_BACK #sFname nil)
                  )
                );_if

                ; 保存したのでﾊﾞｯｸｱｯﾌﾟしていた元図面  #MODEL_BACK　を開く
;;;               (CfDwgOpenByScript #MODEL)
                (SCFCmnFileOpen #MODEL 1)

              )
              (progn
                (CFAlertMsg "\n保存しませんでした。")
                (*error*)
              )
            );_if

          )
          (progn
            (CFAlertMsg "\n図面上に躯体がありません。")
            (*error*)
          )
        );_if

      ) ; 躯体のみ保存する ---------------------------------------------------------------------------------------
    )
  );_if

  (setvar "FILEDIA" #iFILEDIA)
  (setq *error* nil)
  (princ "\nブロックを保存しました。")
  (princ)
);C:KP_WrBlock

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_WrBlock
;;; <処理概要>  : ﾌﾟﾗﾝ保存(関数CALL用)
;;; <引数>      : 保存ファイル名
;;; <戻り値>    : なし
;;; <作成>      : 01/04/25 YM
;;; <備考>      : 図面上にアイテムがないとダメ,基準アイテムの色は"BYLAYER"で保存する
;;;*************************************************************************>MOH<
(defun sub_WrBlock (
  &sFname ; 保存ファイル名
  /
  )

  ; 03/05/07 YM ADD 不要なｸﾞﾙｰﾌﾟ定義を削除する
  (KP_DelUnusedGroup)
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")

  ; ﾌｧｲﾙ指定
  (command "_.saveas" "2000" &sFname)
  (princ "\nブロックを保存しました。")
  (princ)
);sub_WrBlock

;;;<HOM>*************************************************************************
;;; <関数名>    : DelwithoutKUTAI
;;; <処理概要>  : 躯体以外(ｷｬﾋﾞ,WRKT,FILR,図面枠,天井の点,基準ｷｬﾋﾞ矢印,矢視)を削除する
;;; <戻り値>    : なし
;;; <作成>      : 03/01/24 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun DelwithoutKUTAI (
  /
  #I #II #SSDEL #SSFILR #SSGRP #SSLSYM #SSWRKT #SYM #XD$ #EN #SSARW #SSHOLE #SSROOM #SSYASI
  )
  (setq #ssDEL (ssadd)) ; 削除対象選択ｾｯﾄ
  (setq #ssWRKT (ssget "X" '((-3 ("G_WRKT")))))
  (setq #ssLSYM (ssget "X" '((-3 ("G_LSYM")))))
  (setq #ssFILR (ssget "X" '((-3 ("G_FILR")))))
  (setq #ssHOLE (ssget "X" '((-3 ("G_HOLE")))))

  ; WRKT
  (if (and #ssWRKT (< 0 (sslength #ssWRKT)))
    (progn
      (setq #i 0)
      (repeat (sslength #ssWRKT)
        (setq #sym (ssname #ssWRKT #i)) ; WT本体
        (setq #ssGrp (PCW_ChColWTItemSSret #sym "BYLAYER")) ;ﾜｰｸﾄｯﾌﾟ関連も同時選択
        ; 削除対象選択ｾｯﾄに加算
        (if (and #ssGrp (< 0 (sslength #ssGrp)))
          (progn
            (setq #ii 0)
            (repeat (sslength #ssGrp)
              (ssadd (ssname #ssGrp #ii) #ssDEL)
              (setq #ii (1+ #ii))
            )
          )
        );_if
        (setq #ssGrp nil)
        (setq #i (1+ #i))
      )
    )
  );_if

  ; G_LSYM
  (if (and #ssLSYM (< 0 (sslength #ssLSYM)))
    (progn
      (setq #i 0)
      (repeat (sslength #ssLSYM)
        (setq #sym (ssname #ssLSYM #i)) ; ｼﾝﾎﾞﾙ
        (if (= nil (CFGetXData #sym "G_KUTAI"))
          (setq #ssGrp (CFGetSameGroupSS #sym)) ; ｸﾞﾙｰﾌﾟ図形
          (setq #ssGrp nil)
        );_if

        ; 削除対象選択ｾｯﾄに加算
        (if (and #ssGrp (< 0 (sslength #ssGrp)))
          (progn
            (setq #ii 0)
            (repeat (sslength #ssGrp)
              (ssadd (ssname #ssGrp #ii) #ssDEL)
              (setq #ii (1+ #ii))
            )
          )
        );_if
        (setq #ssGrp nil)
        (setq #i (1+ #i))
      )
    )
  );_if

  ; 天井ﾌｨﾗｰ
  (if (and #ssFILR (< 0 (sslength #ssFILR)))
    (progn
      (setq #i 0)
      (repeat (sslength #ssFILR)
        (setq #sym (ssname #ssFILR #i)) ; 本体
        (setq #xd$ (CFGetXData #sym "G_FILR"))
        ; 削除対象選択ｾｯﾄに加算
        (ssadd #sym #ssDEL)         ;天井ﾌｨﾗｰ本体を削除対象選択ｾｯﾄに加算
        (ssadd (nth 2 #xd$) #ssDEL) ;底面も削除対象選択ｾｯﾄに加算
        (setq #i (1+ #i))
      )
    )
  );_if

  ; G_HOLE
  (if (and #ssHOLE (< 0 (sslength #ssHOLE)))
    (command "_.erase" #ssHOLE "")
  );_if

  ; 全て削除
  (if (and #ssDEL (< 0 (sslength #ssDEL)))
    (command "_.erase" #ssDEL "")
  );_if

  ; 矢印,図面枠,天井の点削除
  (setq #ssARW  (ssget "X" '((-3 ("G_ARW")))))
  (setq #ssROOM (ssget "X" '((-3 ("G_ROOM")))))

  (if (and #ssARW (< 0 (sslength #ssARW)))
    (command "_.erase" #ssARW "")
  );_if

  (if (and #ssROOM (< 0 (sslength #ssROOM)))
    (command "_.erase" #ssROOM "")
  );_if

  ; 矢視削除
  ;現在存在する作図領域番号を獲得
  (setq #ssYASI (ssget "X" (list (list -3 (list "RECT")))))
  ; 矢視があれば削除する
  (if (and #ssYASI (> (sslength #ssYASI) 0)) ; 矢視
    (progn
      ; 矢視削除
      (setq #i 0)
      (repeat (sslength #ssYASI) ; 矢視複数あり
        (setq #en (ssname #ssYASI #i))
        (KCFDeleteYashi #en)
        (setq #i (1+ #i))
      )
    )
  );_if
  (princ)
);DelwithoutKUTAI

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KP_InBlock
;;; <処理概要>  : 既存のプランを挿入して再利用する
;;; <戻り値>    : なし
;;; <作成>      : C:PC_InsertPlan を元に作成 01/04/25 YM
;;; <備考>      : 挿入後にG_ARW , G_ROOMを削除
;;;*************************************************************************>MOH<
(defun C:KP_InBlock (
  /
  #ANG #EN #EN$ #FLG #I #INSPT #N #PURGE #SERI$ #SERIES #SETANG #SETPT #SFNAME
  #STR #SYMNORMAL$ #SYMTOKU$ #TOKU #TOKU$ #WTBASE #XD$ #PATH #RET #SKK
#PATH0 ; 03/07/04 YM
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KP_InBlock ////")
  (CFOutStateLog 1 1 " ")
  (StartUndoErr);// コマンドの初期化
  (CFCmdDefBegin 7);00/09/13 SN ADD

  ; 02/11/11 YM ADD 躯体のみ書き出しモードを選択可能
  (setq #ret (KPGetBlockWrInsModeDlg))
  (if (= #ret nil)
    (*error*)
  ; else
    (progn

      ;// 現在の商品情報を取得する
      (if (setq #seri$ (CFGetXRecord "SERI"))
        (progn
          (setq CG_SeriesCode  (nth 1 #seri$))  ;SERIES記号
          (setq CG_DRSeriCode  (nth 3 #seri$))  ;扉SERIES記号
          (setq CG_DRColCode   (nth 4 #seri$))  ;扉COLOR記号
        )
      );_if

      (if (or (= nil CG_SeriesCode)(= nil CG_DRSeriCode)(= nil CG_DRColCode))
        (progn
          (CFAlertMsg "商品情報が取得できませんでした。\n図面を再オープンしてください。")
          (*error*)
        )
      );_if

      ;// 現在のシンボル図形を求める
      (setq CG_PREV_SYMSS (ssget "X" '((-3 ("G_LSYM")))))
      (setq CG_PREV_WTSS  (ssget "X" '((-3 ("G_WRKT")))))
      (setq CG_PREV_ARW   (ssget "X" '((-3 ("G_ARW" )))))
      (setq CG_PREV_ROOM  (ssget "X" '((-3 ("G_ROOM")))))

      (if (= nil CG_PREV_SYMSS) (setq CG_PREV_SYMSS (ssadd)))
      (if (= nil CG_PREV_WTSS)  (setq CG_PREV_WTSS  (ssadd)))
      (if (= nil CG_PREV_ARW )  (setq CG_PREV_ARW   (ssadd)))
      (if (= nil CG_PREV_ROOM)  (setq CG_PREV_ROOM  (ssadd)))

      (if (= "1" #ret)
        (progn
          ; CG_DBNAME DB名 03/07/04 YM MOD-S
          (setq #path0 (strcat CG_SYSPATH "PLAN\\" CG_DBNAME))
          (if (findfile #path0)
            ;新ｼﾘｰｽﾞ NK_KSA,NK_KGA など
            (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\"))
            ;else   従来ｼﾘｰｽﾞ(NK_CKC,NK_CKN など)
            (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
          );_if
;;;         (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\")) ; 03/07/04 YM MOD
          ; CG_DBNAME DB名 03/07/04 YM MOD-E
        )
      ; else
        (setq #path (strcat CG_SYSPATH "PLAN\\" "KUTAI" "\\"))
      );_if

        ; 既存dwgの検索
        (if (vl-directory-files #path "*.dwg")
          (progn
            ; ﾌｧｲﾙ指定
            (setq #sFname (getfiled "ブロック挿入" #path "dwg" 8))
            (if #sFname
              (progn
                (command "vpoint" "0,0,1"); 視点を真上から
                (princ "\n配置点: ")
                (command "_Insert" #sFname pause "" "")
                (princ "\n角度: ")
                (command pause)

                (setq #insPt (getvar "LASTPOINT"))
                (setq #ang (cdr (assoc 50 (entget (entlast)))))

                (command "_explode" (entlast))

  ; ｸﾞﾙｰﾌﾟ分解 03/07/09 YM ADD
  (KP_DelUnusedGroup)

                ;// 配置した基準シンボルG_LSYM の配置点、配置角度を置き換える
                ;// 現在のシンボル図形を求める
                (setq CG_AFTER_SYMSS (ssget "X" '((-3 ("G_LSYM")))))

                ;// 新たに追加されたシンボル図形を求める
                (setq #i 0 #en$ nil)
                (repeat (sslength CG_AFTER_SYMSS)
                  (setq #en (ssname CG_AFTER_SYMSS #i))
                  (if (= nil (ssmemb #en CG_PREV_SYMSS))
                    (progn
                      (setq #setpt (cdr (assoc 10 (entget #en))))

                      (setq #xd$ (CFGetXData #en "G_LSYM"))
                      (setq #series (nth 4 #xd$)) ; 挿入ﾌﾟﾗﾝのｼﾘｰｽﾞ
                      (setq #skk    (nth 9 #xd$)) ; 性格ｺｰﾄﾞ ; 03/03/29 YM ADD

(setq CG_SKK_ONE_KUT 9);駆体
(setq CG_SKK_TWO_KUT 9);駆体
(setq CG_SKK_THR_KUT 9);駆体

                      (if (and (= #ret "1")(/= CG_SeriesCode #series) ; 02/11/11 YM MOD
                               (/= #skk CG_SKK_INT_KUT)) ; 03/03/29 YM ADD 駆体は除く
;;;                     (if (/= CG_SeriesCode #series) ; 02/11/11 YM MOD
                        (progn
                          (CFAlertMsg (strcat "SERIESが異なるため、ブロックを挿入できません。"
                            "\n現在の図面のSERIES：   " CG_SeriesCode
                            "\n挿入ブロックのSERIES ："#series)
                          )
                          (*error*)
                        )
                      );_if
                      (setq #setang (+ #ang (nth 2 #xd$)))

                      ;// 拡張データの更新
                      (CFSetXData #en "G_LSYM"
                        (list
                          (nth  0 #xd$)  ;1 :本体図形ID      :
                          #setpt         ;2 :挿入点          :  更新
                          #setang        ;3 :回転角度        :  更新
                          (nth  3 #xd$)  ;4 :工種記号        :
                          (nth  4 #xd$)  ;5 :SERIES記号    :
                          (nth  5 #xd$)  ;6 :品番名称        :
                          (nth  6 #xd$)  ;7 :L/R区分         :
                          (nth  7 #xd$)  ;8 :扉図形ID        :
                          (nth  8 #xd$)  ;9 :扉開き図形ID    :
                          (nth  9 #xd$)  ;10:性格CODE      :
                          (nth 10 #xd$)  ;11:複合フラグ      :
                          (nth 11 #xd$)  ;12:配置順番号      :
                          (nth 12 #xd$)  ;13:用途番号        :
                          (nth 13 #xd$)  ;14:寸法Ｈ          :
                          (nth 14 #xd$)  ;15.断面指示の有無  :
                          (nth 15 #xd$)  ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
                        )
                      )
                      (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
                        (setq #en$ (cons #en #en$)) ; 扉貼り直し対象ｷｬﾋﾞ
                      );_if

                    )
                  )
                  (setq #i (1+ #i))
                )
                (command "zoom" "p") ; 視点を戻す

                ; 図面の扉記号,ｶﾗｰに張りかえる ----------------------------------------START

                ; 特注ｷｬﾋﾞと一般ｷｬﾋﾞを分ける
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
                (if #TOKU
                  (CFAlertErr "特注キャビネットは扉面の変更を行えません。")
                );_if

                ;// 扉面の貼り付け(特注以外の場合)
                (if #symNORMAL$
                  ;プラン挿入時に部材が消えることがあるため扉削除しない MICADO版に同じ
                  (PCD_MakeViewAlignDoor #symNORMAL$ 3 nil);03/12/05 YM MOD
;;;                 (PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
                );_if

                ; 図面の扉記号,ｶﾗｰに張りかえる ----------------------------------------END

                ;// 最新のワークトップを取得する
                ;// 配置した基準シンボルG_LSYM の配置点、配置角度を置き換える
                ;// 現在のシンボル図形を求める
                (setq CG_AFTER_WTSS (ssget "X" '((-3 ("G_WRKT")))))
                (setq CG_AFTER_ARW  (ssget "X" '((-3 ("G_ARW")))))
                (setq CG_AFTER_ROOM (ssget "X" '((-3 ("G_ROOM")))))

                (if (/= CG_AFTER_WTSS nil)
                  (progn
                    ;// 新たに追加されたWTを求める
                    (setq #i 0)
                    (repeat (sslength CG_AFTER_WTSS)
                      (setq #en (ssname CG_AFTER_WTSS #i))
                      (if (= nil (ssmemb #en CG_PREV_WTSS))
                        (progn
                          (setq #xd$ (CFGetXData #en "G_WRKT"))
                          (setq #WTbase (PKGetWTLeftUpPT #insPt #ang (nth 32 #xd$))) ; 09/11 YM
                          ;// 拡張データの更新
                          (CFSetXData #en "G_WRKT"
                            (CFModList #xd$
                              (list (list 32 #WTbase))
                            )
                          )
                        )
                      );_if
                      (setq #i (1+ #i))
                    )
                  )
                );_if

                (if (/= CG_AFTER_ARW nil) ; 基準アイテムの矢印
                  (progn
                    ;// 新たに追加された基準アイテムの矢印を削除する
                    (setq #i 0)
                    (repeat (sslength CG_AFTER_ARW)
                      (setq #en (ssname CG_AFTER_ARW #i))
                      (if (= nil (ssmemb #en CG_PREV_ARW))
                        (entdel #en)
                      );_if
                      (setq #i (1+ #i))
                    )
                  )
                );_if

                (if (/= CG_AFTER_ROOM nil) ; 図面枠と天井の点
                  (progn
                    ;// 新たに追加された図面枠と天井の点を削除する
                    (setq #i 0)
                    (repeat (sslength CG_AFTER_ROOM)
                      (setq #en (ssname CG_AFTER_ROOM #i))
                      (if (= nil (ssmemb #en CG_PREV_ROOM))
                        (entdel #en)
                      );_if
                      (setq #i (1+ #i))
                    )
                  )
                );_if

                ; dwgパス名の文字列からﾌﾞﾛｯｸ名を取得
                (setq #n 0)
                (setq #purge "" #flg nil)
                (repeat (1- (strlen #sFname))
                  (setq #str (substr #sFname (- (strlen #sFname) #n) 1)) ; 末尾から

                  (if (= #str "\\")(setq #flg nil))
                  (if #flg (setq #purge (strcat #str #purge)))
                  (if (= #str ".")(setq #flg T))
                  (setq #n (1+ #n))
                )

                ;// インサートしたブロック定義をパージする
                (command "_purge" "BL" #purge "N")

                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")
                (command "_purge" "BL" "*" "N")

      ;;;01/05/14YM@          (command "_purge" "A" "*" "N") ; 全てをﾊﾟｰｼﾞする 01/05/14 YM ADD
                (princ "\nブロックを挿入しました。")
              )
            );_if
          )
          (progn
            (CFAlertMsg (strcat "挿入するプランが登録されていません。" )) ; 02/11/11 YM MOD
;;;           (CFAlertMsg (strcat "挿入するプランが登録されていません。\nSERIES記号:" CG_SeriesCode)) ; 02/11/11 YM MOD
            (quit)
          )
        );_if

    )
  );_if

  ;04/05/26 YM ADD
  (command "_REGEN")

  (CFCmdDefFinish)
  (setq *error* nil)
  (princ)
);C:KP_InBlock

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_KP_InBlock
;;; <処理概要>  : 既存のプランを挿入する(関数CALL用)
;;; <戻り値>    : なし
;;; <作成>      : 03/12/06 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun sub_KP_InBlock (
  &path ;挿入dwgﾌﾙ名
  /
  #ANG #EN #EN$ #FLG #I #INSPT #N #PURGE #SERI$ #SERIES #SETANG #SETPT #SFNAME 
  #SKK #STR #WTBASE #XD$
  )
  (CFCmdDefBegin 7)
  ;// 現在の商品情報を取得する
  (if (setq #seri$ (CFGetXRecord "SERI"))
    (progn
      (setq CG_SeriesCode  (nth 1 #seri$))  ;SERIES記号
      (setq CG_DRSeriCode  (nth 3 #seri$))  ;扉SERIES記号
      (setq CG_DRColCode   (nth 4 #seri$))  ;扉COLOR記号
    )
  );_if

  (if (or (= nil CG_SeriesCode)(= nil CG_DRSeriCode)(= nil CG_DRColCode))
    (progn
      (CFAlertMsg "商品情報が取得できませんでした。\n図面を再オープンしてください。")
      (*error*)
    )
  );_if

  ;// 現在のシンボル図形を求める
  (setq CG_PREV_SYMSS (ssget "X" '((-3 ("G_LSYM")))))
  (setq CG_PREV_WTSS  (ssget "X" '((-3 ("G_WRKT")))))
  (setq CG_PREV_ARW   (ssget "X" '((-3 ("G_ARW" )))))
  (setq CG_PREV_ROOM  (ssget "X" '((-3 ("G_ROOM")))))

  (if (= nil CG_PREV_SYMSS) (setq CG_PREV_SYMSS (ssadd)))
  (if (= nil CG_PREV_WTSS)  (setq CG_PREV_WTSS  (ssadd)))
  (if (= nil CG_PREV_ARW )  (setq CG_PREV_ARW   (ssadd)))
  (if (= nil CG_PREV_ROOM)  (setq CG_PREV_ROOM  (ssadd)))

  (command "vpoint" "0,0,1"); 視点を真上から
  (command "_.INSERT" &path "0,0,0" 1 1 "0")
  (setq #insPt '(0 0 0))
  (setq #ang 0.0)
  (command "_explode" (entlast))

  ; ｸﾞﾙｰﾌﾟ分解 03/07/09 YM ADD
  (KP_DelUnusedGroup)

  ;// 配置した基準シンボルG_LSYM の配置点、配置角度を置き換える
  ;// 現在のシンボル図形を求める
  (setq CG_AFTER_SYMSS (ssget "X" '((-3 ("G_LSYM")))))

  ;// 新たに追加されたシンボル図形を求める
  (setq #i 0 #en$ nil)
  (repeat (sslength CG_AFTER_SYMSS)
    (setq #en (ssname CG_AFTER_SYMSS #i))
    (if (= nil (ssmemb #en CG_PREV_SYMSS))
      (progn
        (setq #setpt (cdr (assoc 10 (entget #en))))

        (setq #xd$ (CFGetXData #en "G_LSYM"))
        (setq #series (nth 4 #xd$)) ; 挿入ﾌﾟﾗﾝのｼﾘｰｽﾞ
        (setq #skk    (nth 9 #xd$)) ; 性格ｺｰﾄﾞ ; 03/03/29 YM ADD

        (setq #setang (+ #ang (nth 2 #xd$)))

        ;// 拡張データの更新
        (CFSetXData #en "G_LSYM"
          (list
            (nth  0 #xd$)  ;1 :本体図形ID      :
            #setpt         ;2 :挿入点          :  更新
            #setang        ;3 :回転角度        :  更新
            (nth  3 #xd$)  ;4 :工種記号        :
            (nth  4 #xd$)  ;5 :SERIES記号    :
            (nth  5 #xd$)  ;6 :品番名称        :
            (nth  6 #xd$)  ;7 :L/R区分         :
            (nth  7 #xd$)  ;8 :扉図形ID        :
            (nth  8 #xd$)  ;9 :扉開き図形ID    :
            (nth  9 #xd$)  ;10:性格CODE      :
            (nth 10 #xd$)  ;11:複合フラグ      :
            (nth 11 #xd$)  ;12:配置順番号      :
            (nth 12 #xd$)  ;13:用途番号        :
            (nth 13 #xd$)  ;14:寸法Ｈ          :
            (nth 14 #xd$)  ;15.断面指示の有無  :
            (nth 15 #xd$)  ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
          )
        )
        (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
          (setq #en$ (cons #en #en$)) ; 扉貼り直し対象ｷｬﾋﾞ
        );_if

      )
    )
    (setq #i (1+ #i))
  );repeat
;;;               (command "zoom" "p") ; 視点を戻す

  ;// 最新のワークトップを取得する
  ;// 配置した基準シンボルG_LSYM の配置点、配置角度を置き換える
  ;// 現在のシンボル図形を求める
  (setq CG_AFTER_WTSS (ssget "X" '((-3 ("G_WRKT")))))
  (setq CG_AFTER_ARW  (ssget "X" '((-3 ("G_ARW")))))
  (setq CG_AFTER_ROOM (ssget "X" '((-3 ("G_ROOM")))))

  (if (/= CG_AFTER_WTSS nil)
    (progn
      ;// 新たに追加されたWTを求める
      (setq #i 0)
      (repeat (sslength CG_AFTER_WTSS)
        (setq #en (ssname CG_AFTER_WTSS #i))
        (if (= nil (ssmemb #en CG_PREV_WTSS))
          (progn
            (setq #xd$ (CFGetXData #en "G_WRKT"))
            (setq #WTbase (PKGetWTLeftUpPT #insPt #ang (nth 32 #xd$))) ; 09/11 YM
            ;// 拡張データの更新
            (CFSetXData #en "G_WRKT"
              (CFModList #xd$
                (list (list 32 #WTbase))
              )
            )
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (if (/= CG_AFTER_ARW nil) ; 基準アイテムの矢印
    (progn
      ;// 新たに追加された基準アイテムの矢印を削除する
      (setq #i 0)
      (repeat (sslength CG_AFTER_ARW)
        (setq #en (ssname CG_AFTER_ARW #i))
        (if (= nil (ssmemb #en CG_PREV_ARW))
          (entdel #en)
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (if (/= CG_AFTER_ROOM nil) ; 図面枠と天井の点
    (progn
      ;// 新たに追加された図面枠と天井の点を削除する
      (setq #i 0)
      (repeat (sslength CG_AFTER_ROOM)
        (setq #en (ssname CG_AFTER_ROOM #i))
        (if (= nil (ssmemb #en CG_PREV_ROOM))
          (entdel #en)
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  ;// インサートしたブロック定義をパージする
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (princ "\nブロックを挿入しました。")

  (CFCmdDefFinish)
  (princ)
);sub_KP_InBlock

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_KP_WrBlock
;;; <処理概要>  : 既存ﾌﾟﾗﾝを名前を付けて保存する
;;; <引数>      : なし(ﾌｧｲﾙのはｸﾞﾛｰﾊﾞﾙ変数 CG_SAVE-DWG)
;;; <戻り値>    : なし
;;; <作成>      : 03/12/06 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun sub_KP_WrBlock (
  /
  #EN #HAND #HNDB #I #IFILEDIA #N #PICKSTYLE #SS #SSARW #SSDOOR #SSROOM 
  #SSYASI #TENDFLG #XDYASI$
  )
    ;//////////////////////////////////////////////////////////////////////
    ;ｻﾌﾞﾙｰﾁﾝ化 03/05/13 YM
    ;//////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL_SUB ( &ss / #i )
      (if (and &ss (> (sslength &ss) 0)) ; 基準アイテムの矢印
        (progn
          ;// 新たに追加された基準アイテムの矢印を削除する
          (setq #i 0)
          (repeat (sslength &ss)
            (entdel (ssname &ss #i))
            (setq #i (1+ #i))
          )
        )
      );_if
      (princ)
    );##ENTDEL_SUB
    ;//////////////////////////////////////////////////////////////////////
    ;ｻﾌﾞﾙｰﾁﾝ化&扉の一時削除追加 03/05/13 YM
    ;//////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL ( / )
      ;基準アイテムの矢印を一時削除する
      (##ENTDEL_SUB #ssARW)
      ;図面枠と天井の点を一時削除する
      (##ENTDEL_SUB #ssROOM)
      ;図面上の扉を一時削除する
      (##ENTDEL_SUB #ssDOOR)
      (princ)
    );##ENTDEL
    ;//////////////////////////////////////////////////////////////////////


  (setq #iFILEDIA (getvar "FILEDIA"))
  (setvar "FILEDIA" 1)


  (setq #ssARW  (ssget "X" '((-3 ("G_ARW")))))
  (setq #ssROOM (ssget "X" '((-3 ("G_ROOM")))))
  ; 03/05/13 YM ADD-S 図面上の全扉図形
  (setq #ssDOOR (KP_GetAllDoor))
  ; 03/05/13 YM ADD-S
  (setq #PICKSTYLE (getvar "PICKSTYLE"))
  (setvar "PICKSTYLE" 3)

  ;現在存在する作図領域番号を獲得
  (setq #ssYASI (ssget "X" (list (list -3 (list "RECT")))))
  ; 矢視があれば削除する
  (if (and #ssYASI (> (sslength #ssYASI) 0)) ; 矢視
    (if (CFYesNoDialog "保存前に矢視を削除する必要があります。\n矢視を削除しますか？")
      (progn
        ; 矢視削除
        (setq #i 0)
        (repeat (sslength #ssYASI) ; 矢視複数あり
          (setq #en (ssname #ssYASI #i))
          (setq #xdYASI$ (CFGetXData #en "RECT")) ; 拡張ﾃﾞｰﾀ
          (setq #n 3 #hand (nth #n #xdYASI$))
          (while #hand
            (command "_erase" (handent #hand) "")
            (setq #n (1+ #n))
            (setq #hand (nth #n #xdYASI$))
          )
          (command "_erase" #en "")
          (setq #i (1+ #i))
        )
      )
      (*error*)
    );_if
  );_if

  ; 枠、天井の点、矢印を一時的に削除する 01/05/10 YM ADD
  (##ENTDEL) ; 03/05/13 YM 扉も一時削除

  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss (> (sslength #ss) 0))
    (progn ; 図面上に何か部材があるとき
      ; 基準アイテムの色を一時的に元に戻す
      (setq #hndB (car (CFGetXRecord "BASESYM"))) ; 基準ｱｲﾃﾑ
      (if (and #hndB (/= #hndB ""))
        (GroupInSolidChgCol2 (handent #hndB) "BYLAYER")  ;BYLAYER色に変更
      )

      ; ﾌｧｲﾙｺﾋﾟｰ

      ; 03/07/09 YM ADD 不要なｸﾞﾙｰﾌﾟ定義を削除する
      (KP_DelUnusedGroup)
      (command "_purge" "BL" "*" "N")
      (command "_purge" "BL" "*" "N")
      (command "_.QSAVE")
      ; 01/10/24 YM ADD-S ｺﾋﾟｰ元,ｺﾋﾟｰ先 -->ﾌｧｲﾙ既存ならｺﾋﾟｰに失敗
      (setq #tEndFlg (vl-file-copy  (strcat CG_KENMEI_PATH "MODEL.DWG") CG_SAVE-DWG nil))
      (if (= nil #tEndFlg)
        (progn ; 既存ﾌｧｲﾙありｺﾋﾟｰ不可の場合
          (vl-file-delete CG_SAVE-DWG)
          (vl-file-copy  (strcat CG_KENMEI_PATH "MODEL.DWG") CG_SAVE-DWG nil)
        )
      );_if
      ; 01/10/24 YM ADD-E

      ; 基準アイテムの色を元の緑に戻す
      (if (and #hndB (/= #hndB ""))
        (GroupInSolidChgCol2 (handent #hndB) CG_BaseSymCol) ;緑色に変更
      )
    )
    (progn
      (CFAlertMsg "\n図面上に部材がありません。")
      (*error*)
    )
  );_if

  ; 枠、天井の点、矢印を復活させる 01/05/10 YM ADD
  (##ENTDEL)

  (setvar "FILEDIA" #iFILEDIA)
  (princ "\nブロックを保存しました。")
  (princ)
);sub_KP_WrBlock

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_InBlock_sub
;;; <処理概要>  : プラン挿入関数呼び出し用(挿入位置,角度固定)
;;; <戻り値>    : なし
;;; <作成>      : 03/05/09 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_InBlock_sub (
  &sFname ; DWG名
  /
  #ANG #EN #EN$ #FLG #I #INSPT #N #PATH #PURGE #RET #SERI$ #SERIES #SETANG #SETPT
  #SKK #STR #SYMNORMAL$ #SYMTOKU$ #TOKU #TOKU$ #WTBASE #XD$
  )
  ;// 現在の商品情報を取得する
  (if (setq #seri$ (CFGetXRecord "SERI"))
    (progn
      (setq CG_SeriesCode  (nth 1 #seri$))  ;SERIES記号
      (setq CG_DRSeriCode  (nth 3 #seri$))  ;扉SERIES記号
      (setq CG_DRColCode   (nth 4 #seri$))  ;扉COLOR記号
    )
  );_if

  (if (or (= nil CG_SeriesCode)(= nil CG_DRSeriCode)(= nil CG_DRColCode))
    (progn
      (CFAlertMsg "商品情報が取得できませんでした。\n図面を再オープンしてください。")
      (*error*)
    )
  );_if

  ;// 現在のシンボル図形を求める
  (setq CG_PREV_SYMSS (ssget "X" '((-3 ("G_LSYM")))))
  (setq CG_PREV_WTSS  (ssget "X" '((-3 ("G_WRKT")))))
  (setq CG_PREV_ARW   (ssget "X" '((-3 ("G_ARW" )))))
  (setq CG_PREV_ROOM  (ssget "X" '((-3 ("G_ROOM")))))

  (if (= nil CG_PREV_SYMSS) (setq CG_PREV_SYMSS (ssadd)))
  (if (= nil CG_PREV_WTSS)  (setq CG_PREV_WTSS  (ssadd)))
  (if (= nil CG_PREV_ARW )  (setq CG_PREV_ARW   (ssadd)))
  (if (= nil CG_PREV_ROOM)  (setq CG_PREV_ROOM  (ssadd)))

  (command "_insert" &sFname "0,0,0" 1 1 "0")
  (setq #insPt '(0 0 0))
  (setq #ang 0)
  (command "_explode" (entlast))

  ;// 配置した基準シンボルG_LSYM の配置点、配置角度を置き換える
  ;// 現在のシンボル図形を求める
  (setq CG_AFTER_SYMSS (ssget "X" '((-3 ("G_LSYM")))))

  ;// 新たに追加されたシンボル図形を求める
  (setq #i 0 #en$ nil)
  (repeat (sslength CG_AFTER_SYMSS)
    (setq #en (ssname CG_AFTER_SYMSS #i))
    (if (= nil (ssmemb #en CG_PREV_SYMSS))
      (progn
        (setq #setpt (cdr (assoc 10 (entget #en))))

        (setq #xd$ (CFGetXData #en "G_LSYM"))
        (setq #series (nth 4 #xd$)) ; 挿入ﾌﾟﾗﾝのｼﾘｰｽﾞ
        (setq #skk    (nth 9 #xd$)) ; 性格ｺｰﾄﾞ ; 03/03/29 YM ADD

        (if (and (= #ret "1")(/= CG_SeriesCode #series) ; 02/11/11 YM MOD
                 (/= #skk CG_SKK_INT_KUT)) ; 03/03/29 YM ADD 駆体は除く
          (progn
            (CFAlertMsg (strcat "SERIESが異なるため、ブロックを挿入できません。"
              "\n現在の図面のSERIES：   " CG_SeriesCode
              "\n挿入ブロックのSERIES ："#series)
            )
            (*error*)
          )
        );_if
        (setq #setang (+ #ang (nth 2 #xd$)))

        ;// 拡張データの更新
        (CFSetXData #en "G_LSYM"
          (list
            (nth  0 #xd$)  ;1 :本体図形ID      :
            #setpt         ;2 :挿入点          :  更新
            #setang        ;3 :回転角度        :  更新
            (nth  3 #xd$)  ;4 :工種記号        :
            (nth  4 #xd$)  ;5 :SERIES記号    :
            (nth  5 #xd$)  ;6 :品番名称        :
            (nth  6 #xd$)  ;7 :L/R区分         :
            (nth  7 #xd$)  ;8 :扉図形ID        :
            (nth  8 #xd$)  ;9 :扉開き図形ID    :
            (nth  9 #xd$)  ;10:性格CODE      :
            (nth 10 #xd$)  ;11:複合フラグ      :
            (nth 11 #xd$)  ;12:配置順番号      :
            (nth 12 #xd$)  ;13:用途番号        :
            (nth 13 #xd$)  ;14:寸法Ｈ          :
            (nth 14 #xd$)  ;15.断面指示の有無  :
            (nth 15 #xd$)  ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
          )
        )
        (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
          (setq #en$ (cons #en #en$)) ; 扉貼り直し対象ｷｬﾋﾞ
        );_if

      )
    );_if
    (setq #i (1+ #i))
  );repeat

  ; 図面の扉記号,ｶﾗｰに張りかえる ----------------------------------------START

; 03/05/15 YM DEL 扉は貼らないでPLAN.DWGを作成→MODEL.DWGに挿入してから扉を貼る
;;;03/05/15YM@DEL ; 特注ｷｬﾋﾞと一般ｷｬﾋﾞを分ける
;;;03/05/15YM@DEL (setq #symTOKU$ nil #symNORMAL$ nil #TOKU nil)
;;;03/05/15YM@DEL (foreach en #en$
;;;03/05/15YM@DEL   (if (and (setq #TOKU$ (CFGetXData en "G_TOKU"))
;;;03/05/15YM@DEL            (= (nth 3 #TOKU$) 1))
;;;03/05/15YM@DEL     (progn
;;;03/05/15YM@DEL       (setq #TOKU T) ; 特注ｷｬﾋﾞがあった
;;;03/05/15YM@DEL       (setq #symTOKU$ (append #symTOKU$ (list en))) ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞを使用
;;;03/05/15YM@DEL     )
;;;03/05/15YM@DEL     (setq #symNORMAL$ (append #symNORMAL$ (list en)))
;;;03/05/15YM@DEL   );_if
;;;03/05/15YM@DEL )
;;;03/05/15YM@DEL (if #TOKU
;;;03/05/15YM@DEL   (CFAlertErr "特注キャビネットは扉面の変更を行えません。")
;;;03/05/15YM@DEL );_if
;;;03/05/15YM@DEL
;;;03/05/15YM@DEL  ;// 扉面の貼り付け(特注以外の場合)
;;;03/05/15YM@DEL (if #symNORMAL$
;;;03/05/15YM@DEL   (PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
;;;03/05/15YM@DEL );_if

  ; 図面の扉記号,ｶﾗｰに張りかえる ----------------------------------------END

  ;// 最新のワークトップを取得する
  ;// 配置した基準シンボルG_LSYM の配置点、配置角度を置き換える
  ;// 現在のシンボル図形を求める
  (setq CG_AFTER_WTSS (ssget "X" '((-3 ("G_WRKT")))))
  (setq CG_AFTER_ARW  (ssget "X" '((-3 ("G_ARW")))))
  (setq CG_AFTER_ROOM (ssget "X" '((-3 ("G_ROOM")))))

  (if (/= CG_AFTER_WTSS nil)
    (progn
      ;// 新たに追加されたWTを求める
      (setq #i 0)
      (repeat (sslength CG_AFTER_WTSS)
        (setq #en (ssname CG_AFTER_WTSS #i))
        (if (= nil (ssmemb #en CG_PREV_WTSS))
          (progn
            (setq #xd$ (CFGetXData #en "G_WRKT"))
            (setq #WTbase (PKGetWTLeftUpPT #insPt #ang (nth 32 #xd$))) ; 09/11 YM
            ;// 拡張データの更新
            (CFSetXData #en "G_WRKT"
              (CFModList #xd$
                (list (list 32 #WTbase))
              )
            )
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (if (/= CG_AFTER_ARW nil) ; 基準アイテムの矢印
    (progn
      ;// 新たに追加された基準アイテムの矢印を削除する
      (setq #i 0)
      (repeat (sslength CG_AFTER_ARW)
        (setq #en (ssname CG_AFTER_ARW #i))
        (if (= nil (ssmemb #en CG_PREV_ARW))
          (entdel #en)
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (if (/= CG_AFTER_ROOM nil) ; 図面枠と天井の点
    (progn
      ;// 新たに追加された図面枠と天井の点を削除する
      (setq #i 0)
      (repeat (sslength CG_AFTER_ROOM)
        (setq #en (ssname CG_AFTER_ROOM #i))
        (if (= nil (ssmemb #en CG_PREV_ROOM))
          (entdel #en)
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  ; dwgパス名の文字列からﾌﾞﾛｯｸ名を取得
  (setq #n 0)
  (setq #purge "" #flg nil)
  (repeat (1- (strlen &sFname))
    (setq #str (substr &sFname (- (strlen &sFname) #n) 1)) ; 末尾から

    (if (= #str "\\")(setq #flg nil))
    (if #flg (setq #purge (strcat #str #purge)))
    (if (= #str ".")(setq #flg T))
    (setq #n (1+ #n))
  )

  ;// インサートしたブロック定義をパージする
  (command "_purge" "BL" #purge "N")

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
;;; (princ "\nブロックを挿入しました。")
  (princ)
);KP_InBlock_sub

;<HOM>*************************************************************************
; <関数名>    : KPGetBlockWrInsModeDlg
; <処理概要>  : 【ﾌﾟﾗﾝ保存】【ﾌﾟﾗﾝ挿入】時のﾓｰﾄﾞ選択ﾀﾞｲｱﾛｸﾞ
; <戻り値>    : 1:図面全体,0:躯体のみ
; <作成>      : 02/11/11 YM
;*************************************************************************>MOH<
(defun KPGetBlockWrInsModeDlg (
  /
  #DCL_ID #RET
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #ret
            )
            (setq #ret (get_tile "radioALL")) ; ﾌｨﾗｰ個数
            (done_dialog)     ; 半角整数1以上だった
            #ret
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;; ダイアログの実行部
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (= nil (new_dialog "SelBlockWrInsModeDlg" #dcl_id)) (exit))

; 02/11/28 YM ADD 未完成につき使用禁止-->使用可能に03/01/24
;*************************************
;;;(mode_tile "radioKUTAI" 1) ; 使用不可能
;*************************************

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #ret (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; 結果リストを返す
  #ret
); KPGetBlockWrInsModeDlg

;<HOM>*************************************************************************
; <関数名>    : SKFGetCabiEntity
; <処理概要>  : キャビネットごとの指定画層の図形をリストにまとめる
; <戻り値>    : 図形名リスト
;               （
;                 （
;                     断面指示         0
;                     シンボル図形名   1
;                     モデルフラグ     2
;                     モデル番号       3
;                     正面フラグ       4
;                     正面方向フラグ   5
;                     図形名リスト     6
;                 ）
;                 …
;               ）
; <作成>      : 1998-07-15   ->   1999-06-21
; <備考>      : コーナーキャビネットの正面フラグは無条件でONに設定
;*************************************************************************>MOH<

(defun SKFGetCabiEntity (
  &kind       ; 図面種類（平面:"P" 展開Ａ:"A" 展開Ｂ:"B" 展開Ｃ:"C" 展開Ｄ:"D"） 展開Ｅ:"E"追加
  &zcode$     ; 図面種類
  &ss         ; ダミー領域選択エンティティ
  &ang        ; 回転角度
  /
  #iI #den #i #ed$ #ModelFlg #ModelNo #han #sym #code$ #eed$ #ano
  #vcode #fcode #ang #vcode$ #wd #zcode #layer #en$ #en #8 #layen$
  #dflg #ret$ #Ret$$ #ret_n$ #lst$ #ret_n$$
  ; 2000/07/06 HT YASHIAC  矢視領域判定変更
  #next
  #pt0 #pt1 #pt2 #pt3   ; 四隅の座標  01/04/10 TM
  #pt$
  #xSp          ; 矢視図形選択セット
  #sPt          ; 矢視の基点
  #eYas         ; 矢視図形名
  #xYas$        ; 矢視領域点列
  )

  ; 01/07/19 HN ADD オブジェクト範囲のズーム処理を追加
  (command "_.ZOOM" (getvar "EXTMIN") (getvar "EXTMAX"))

  ; 矢視取得
  (setq #xSp (ssget "X" '((-3 ("RECT")))))
  (if #xSp
    (progn
      (cond
        ((or (= &kind "E") (= &kind "F"))
          (setq #xSp (SCFIsYashiType #xSp (strcat "*" &kind "*")))
        )
        ((wcmatch &kind "*[ABCD]*")
          (setq #xSp (SCFIsYashiType #xSp "*[ABCD]*"))
        )
      )
      (setq #eYas (ssname #xSp 0))
      (if (not #eYas)
        (princ "\n矢視が異常？")
      )
    )
  )

  ; ダミー図形領域選択セットごとに拡張データ
  (setq #iI 0)
  (repeat (sslength &ss)
    (setq #den (ssname &ss #iI))
    (setq #ed$ (CfGetXData #den "G_SKDM"))
    (setq #ModelFlg (nth 0 #ed$))   ; 1. モデルフラグ
    (setq #ModelNo  (nth 1 #ed$))   ; 2. モデル番号

    (foreach #sym (cddr #ed$)       ; 3.以降 ダミー図形領域のエンティティ
      (CFDispStar) ; "計算中"表示 01/07/23 HN ADD

      ; 矢視方向のチェック
      (setq #next T)
      (if (and #xSp (/= &kind "P") (/= &kind "M"))
        (progn
          ; 底面の４点を作成
          (setq #sPt (cdr (assoc 10 (entget #sym))))
          (setq #pt$ (GetSym4Pt #sym))
          (setq #pt0 (nth 0 #pt$))  ; 原点
          (setq #pt1 (nth 1 #pt$))  ; W
          (setq #pt3 (nth 2 #pt$))  ; D
          (setq #pt2 (polar #pt1 (angle #pt0 #pt3) (distance #pt0 #pt3)))

          (setq #next (KCFIsAreaMatchYashi &kind #eYas (list #pt0 #pt1 #pt2 #pt3) #sym))
          ; DEBUG(princ " 結果: ")
          ; DEBUG(princ #next)
        )
      )

      ; 2000/10/19 HT "G_PANEL"が付加されている図形は、(GetWtAndFilr)
      ; 取得されるので2重にならないようにここでは省く
      (if (CfGetXData #sym "G_PANEL")
        (setq #next nil)
      )

      (if (= #next T)
        (progn

          ; 性格CODE取得
          (setq #code$ (CFGetSymSKKCode #sym nil))
          ; シンボルの拡張データ取得
          (setq #eed$ (cadr (assoc -3 (entget #sym '("G_LSYM")))))
          (if (/= nil #eed$)
            (progn
              (cond
                ; 平面図の場合
                ((equal "P" &kind)
                  ;視点種類       ... 平面図
                  (setq #vcode "01")
                  ;正面方向フラグ ... 必ず正面
                  (setq #wd "W")
                  ;正面フラグ
                  (setq #ang   (cdr (nth  3 #eed$)))
                  (setq #ang   (Angle0to360 (+ #ang &ang)))
                  (setq #vcode$ (SKFGetViewByAngle #ang "A"))
                  (if (and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_THR_CNR (nth 2 #code$)))
                    (progn
                        (setq #fcode 1)
                    )
                    (cond
                      ((or (= "03" (car  #vcode$))(= "04" (car  #vcode$)))
                        (setq #fcode 1)
                      )
                      ((or (= "05" (car  #vcode$))(= "06" (car  #vcode$)))
                      (setq #fcode 0)
                      )
                    )
                  )
                )
                ; 展開図の場合
                ((wcmatch &kind "[ABCDEF]")
                  ; 配置角度を取得
                  (if (/= nil (nth 3 #eed$))
                    (progn
                      ; 正面角度を計算
                      (setq #ang   (cdr (nth  3 #eed$)))
                      (setq #ang   (Angle0to360 (+ #ang &ang)))
                      ; 視点種類・領域フラグ取得
                      (setq #vcode$ (SKFGetViewByAngle #ang &kind))

                       ;DEBUG(princ "\n矢視: ")
                       ;DEBUG(princ &kind)
                       ;DEBUG(princ " 向きコード・幅奥方向: ")
                       ;DEBUG(princ #vcode$)

                      (setq #vcode  (car  #vcode$))
                      (setq #wd     (cadr #vcode$))

                      ; 正面フラグ
                      ; コーナーキャビネットは常にON
                      (if (and (= CG_SKK_ONE_CAB (nth 0 #code$)) (= CG_SKK_THR_CNR (nth 2 #code$)))
                        (progn
                            (setq #fcode 1)
                        )
                        (cond

                          ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                          ; 04/03/24 SK ADD-S 対面プラン対応
                          ((= "04" #vcode)
                            (setq #fcode -1)
                          )
                          ; 04/03/24 SK ADD-E 対面プラン対応
                          ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

                          ((or (= "03" #vcode)(= "04" #vcode))
                            (setq #fcode 1)
                          )
                          ((or (= "05" #vcode)(= "06" #vcode))
                            (setq #fcode 0)
                          )
                        )
                      )
                    )
                  )
                )
                (T (setq #vcode ""))
              )
              (setq #en$ (CFGetGroupEnt #sym)) ;00/09/12 HN ADD 高速化対応
              (mapcar
               '(lambda ( #zcode )
                  ; 画層名取得
                  (if (= 'STR (type #zcode))
                    (progn
                    ; 2000/09/12 HT 暫定対応 レンジフードその他が商品図施工図に表示されない
                    ; フードにおいては、用途番号=4でZ_05_00_04_## となりますが、
                    ; ＧＳＭ図面では商品図・施工図の図形がZ_05_00_00_## に作図され
                    ; ているため、展開元図の対象外となりました。
                    ;
                    ; 現状、**版のＧＳＭ図面では、商品図は全て"00"となっています
                    ; が、施工図は"00"になっていたり"11"等その他の番号になっていた
                    ; りでまちまちの状態です。
                    ;
                    ; 関戸さんと協議の結果、本来はデータ側を修正するべきですが、フ
                    ; ード回りは数も多いので、展開図作成時には用途番号を見ない仕様
                    ; に（とりあえず）変更することにします。
                    ;
                    ; 用途番号**を何でも対象とするように変更しててください。
                    ; Z_05_00_**_##
                    (setq #layer (strcat "Z_" #vcode "_" #zcode "_" "##_##"))
                    ; (setq #layer (strcat "Z_" #vcode "_" #zcode "_" #ano "_##"))
                    )
                  )
                  ;@@@(setq #en$ (CFGetGroupEnt #sym)) ;00/09/12 HN DEL 高速化対応
                  (mapcar
                   '(lambda ( #en )
                      (setq #8 (cdr (assoc 8 (entget #en))))
                      (if (wcmatch #8 #layer)
                        (setq #layen$ (cons #en #layen$))
                      )
                    )
                    #en$
                  )
                  ; 断面指示
                  (if (/= nil (nth 15 #eed$))
                    (progn
                      (setq #dflg (cdr (nth 15 #eed$)))
                    )
                  )
                  ;--- リストに格納 ---
                  (setq #ret$
                    (cons
                      (list
                        #dflg      ; 断面指示
                        #sym       ; シンボル図形名
                        #ModelFlg  ; モデルフラグ
                        #ModelNo   ; モデル番号
                        #fcode     ; 正面フラグ
                        #wd        ; 正面方向フラグ
                        #layen$    ; 図形名リスト
                      )
                      #ret$
                    )
                  )
                  ;--------------------
                  (setq #layen$ nil)
                )
                &Zcode$
              )
              (setq #Ret$$ (cons (reverse #ret$) #Ret$$))
              (setq #ret$ nil)
            )
          )
        )
;DEBUG        (progn
;DEBUG
;DEBUG          ; 正面角度を計算
;DEBUG          (setq #eed$ (cadr (assoc -3 (entget #sym '("G_LSYM")))))
;DEBUG          (setq #ang   (cdr (nth  3 #eed$)))
;DEBUG          (setq #ang   (Angle0to360 (+ #ang &ang)))
;DEBUG          ; 視点種類・領域フラグ取得
;DEBUG          (setq #vcode$ (SKFGetViewByAngle #ang &kind))
;DEBUG
;DEBUG         (princ "\n矢視: ")
;DEBUG         (princ &kind)
;DEBUG         (princ " 向きコード・幅奥方向: ")
;DEBUG         (princ #vcode$)
;DEBUG
;DEBUG        )
      )
    )
    (setq #iI (1+ #iI))
  )
  (setq #iI 0)
  (repeat (length &zcode$)
    (setq #ret_n$
      (mapcar
       '(lambda ( #lst$ )
          (nth #iI #lst$)
        )
        #Ret$$
      )
    )
    (setq #ret_n$$ (cons #ret_n$ #ret_n$$))
    (setq #ret_n$ nil)
    (setq #iI (1+ #iI))
  )

  (reverse #ret_n$$)
) ; SKFGetCabiEntity




;<HOM>*************************************************************************
; <関数名>    : C:COMM04
; <処理概要>  : ﾊﾟﾈﾙﾎﾜｲﾄ(MW)化ｺﾏﾝﾄﾞ
; <戻り値>    :
; <作成>      : 2008/03/21 YM ADD ｷﾗｰﾗWS対応追加ｺﾏﾝﾄﾞ
; <備考>      : ﾊﾟﾈﾙは【選択変更】できない.ﾎﾜｲﾄ(MW),ﾎﾜｲﾄ以外共存が必要なため
;               ﾊﾟﾈﾙをﾎﾜｲﾄ色にするｺﾏﾝﾄﾞを追加
;*************************************************************************>MOH<
(defun C:COMM04 (
  /
  #EN #EN$ #RET #XD$ #XREC$ #series
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ChgPanelWhite ////")
  (CFOutStateLog 1 1 " ")

  ;ｼﾘｰｽﾞ判定(ｷﾗｰﾗWS限定ｺﾏﾝﾄﾞ) Errmsg.iniを参照
  (setq #series (CFgetini "PANEL_WHITE" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
  (if (wcmatch CG_SeriesDB #series)
    nil
    ;else
    (progn
      (CFAlertMsg msg8)
      (quit)
    )
  );_if

  ;// コマンドの初期化
  (StartUndoErr)
  (CFCmdDefBegin 6)
  (CabShow_sub) ; 非表示ｷｬﾋﾞを表示する 01/05/31 YM ADD

  ;// 現在の商品情報を取得する
  (setq #XRec$ (CFGetXRecord "SERI"))
  (if (= #XRec$ nil)
    (CFAlertErr "一度も商品設定がされていません\n商品設定を行って下さい")
  )



  ;// 貼り付ける扉の指示と貼り付け
  (setq #en T)
  (command "_undo" "m")
  (while #en
    (initget "E Undo");00/07/21 SN MOD Undo入力を許可
    (setq #en (entsel "\nﾓﾉﾄ-ﾝﾎﾜｲﾄ(MW)にするﾊﾟﾈﾙを選択/Enter=決定/U=戻す/: "))
    ;(initget "E")
    ;(setq #en (entsel "\n扉面を変更するキャビネットを選択/Enter=決定/ "))
    (cond
      ((and (= #en nil) #en$)
        (setq #ret (CFYesNoCancelDialog "これでよろしいですか？ホワイトに固定されます。\n※色変更の場合、削除/再配置が必要です。"))
        (cond
          ((= #ret IDYES)
            (command "_undo" "b")
            (setq #en nil)
            (repeat (length #en$);00/07/21 SN ADD 選択した数だけもとに戻す
              (command "_undo" "b")
            )
          )
          ((= #ret IDNO)
            (setq #en T)
          )
          (T
            (quit)
          )
        )
      )
      ; 00/07/21 SN ADD Undo 処理
      ((= #en "Undo")
        (if (> (length #en$) 0 )(progn
          (command "_undo" "b")
          (if (> (length #en$) 1 )
            (setq #en$ (cdr #en$))
            (setq #en$ '())
          )
        ))
      )
      ((/= #en nil)
        (setq #en (car #en))
        (setq #en (CFSearchGroupSym #en)) ; 選択部材のｼﾝﾎﾞﾙ図形名 #en
        (if (= #en nil)
          (progn
            (CFAlertMsg "キャビネットではありません")
            (setq #en T)
          )
        ;else
          (progn
            (setq #xd$ (CFGetXData #en "G_LSYM"))

;;;02/09/04YM@DEL                (if (/= CG_SKK_ONE_CAB (CFGetSeikakuToSKKCode (nth 9 #xd$) 1))
;;;02/09/04YM@DEL                  (CFAlertMsg "キャビネットではありません")
;;;02/09/04YM@DEL                  (progn
                (if (not (member #en #en$))
                  (progn;00/07/21 SN ADD 既に選択済みのものは対象外とする。
                    (setq #en$ (cons #en #en$)) ; 選択部材のｼﾝﾎﾞﾙ図形名ﾘｽﾄ
                    (command "_undo" "m");00/07/21 SN ADD 後で色を戻すため
                    ;// グループの図形を色替え
                    ;(GroupInSolidChgCol #en CG_InfoSymCol);00/07/21 SN MOD 基準ｱｲﾃﾑ用
                    (GroupInSolidChgCol2 #en CG_InfoSymCol);00/07/21 SN MOD
                  )
                );_if
;;;02/09/04YM@DEL                  )
;;;02/09/04YM@DEL                )
          )
        );_if
      )
      (T
        (setq #en T)
      )
    );_cond
  )
  ;ﾎﾜｲﾄ "MA,MWA"の情報を埋め込む
  (foreach #sym #en$
    (setq #xd$ (CFGetXData #sym "G_LSYM"))
    (CFSetXData
      #sym
      "G_LSYM"
      (CFModList
        #xd$
        (list 
          (list 7 "MA,MWA")
        )
      )
    )
  );foreach

  (CFCmdDefFinish)
  (setq *error* nil)
  (princ)
);C:COMM04


;<HOM>*************************************************************************
; <関数名>    : ChgWS_Hikite
; <処理概要>  : ｷﾗｰﾗWSで引手を自動変更
; <戻り値>    :
; <作成>      : 2008/03/27 YM ADD ｷﾗｰﾗWS対応追加ｺﾏﾝﾄﾞ
; <備考>      : ﾂｰﾄﾝ対応でない機種は引手記号を変更する必要がある
;*************************************************************************>MOH<
(defun ChgWS_Hikite (
  /
  #COL #DOOR #DUM$ #HIKI #HINBAN #I #QRY_A$ #QRY_N$ #SERI #SERIES #SS #SYM #XD$ #XREC$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// ChgWS_Hikite ////")
  (CFOutStateLog 1 1 " ")


        ;************************************************
        ; G_LSYMの扉情報を更新する 2008/03/27 YM ADD
        ;************************************************
        (defun ##KOUSIN (
           &seri &col &str &sym &xd$
          /
          #COL #DOOR #SERI
          )
          (setq #seri (strcat (substr &seri 1 1) &str (substr &seri 3 10)) );扉ｼﾘ
          (setq #col  (strcat (substr &col 1 2) &str) ) ;扉ｶﾗ
          (setq #door (strcat #seri "," #col))
          ;情報を埋め込む
          (CFSetXData
            &sym
            "G_LSYM"
            (CFModList
              &xd$
              (list 
                (list 7 #door)
              )
            )
          )
          (princ)
        );defun




  ;ｼﾘｰｽﾞ判定(ｷﾗｰﾗWS限定ｺﾏﾝﾄﾞ) Errmsg.iniを参照
  (setq #series (CFgetini "PANEL_WHITE" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
  (if (wcmatch CG_SeriesDB #series)
    (progn

      ;// コマンドの初期化
      (StartUndoErr)
      (CFCmdDefBegin 6)
      (CabShow_sub) ; 非表示ｷｬﾋﾞを表示する 01/05/31 YM ADD

      ;// 現在の商品情報を取得する
      (setq #XRec$ (CFGetXRecord "SERI"))
      (if (= #XRec$ nil)
        (CFAlertErr "一度も商品設定がされていません\n商品設定を行って下さい")
      )


    ;;; CG_DRSeriCode
    ;;; CG_DRColCode

      ;図形ｼﾝﾎﾞﾙを集める
      (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; G_LSYM 図形選択ｾｯﾄ

      (if (and #ss (> (sslength #ss) 0))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i))
            (setq #xd$ (CFGetXData #sym "G_LSYM"))
            (setq #hinban (nth 5 #xd$))
            ;品番に"@@#"を含むかどうか
            (if (or (/= nil (vl-string-search "@@#" #hinban) )
                    (/= nil (vl-string-search "AA#" #hinban) ))
              (progn ;含む場合
                
                (setq #door (nth 7 #xd$));扉ｼﾘ,扉ｶﾗ(MA,MWA)
                (setq #dum$ (StrParse #door ","))
                (setq #seri (nth 0 #dum$))     ;扉ｼﾘ
                (setq #col  (nth 1 #dum$))     ;扉ｶﾗ
                (setq #hiki (substr #seri 2 1));引手記号
                
                ;mdb検索
                (setq #qry_N$
                  (CFGetDBSQLRec CG_DBSESSION "引手自動変更"
                    (list
                      (list "品番名称" #hinban 'STR)
                      (list "特殊処理"   "N"   'STR);ﾂｰﾄﾝ対応機種
                    )
                  )
                )

                ;mdb検索
                (setq #qry_A$
                  (CFGetDBSQLRec CG_DBSESSION "引手自動変更"
                    (list
                      (list "品番名称" #hinban 'STR)
                      (list "特殊処理"   "A"   'STR);ﾂｰﾄﾝ非対応機種の例外　K,R,U→Y に変更する
                    )
                  )
                )

                (if (and (= nil #qry_N$)(= nil #qry_A$))
                  (progn ; 通常の引手変更
                    ;引手=A,Y,C,Dなら何もしない
                    (if (or (= #hiki "A")(= #hiki "Y")(= #hiki "C")(= #hiki "D"))
                      (progn
                        nil
                      )
                      (progn ;それ以外
                        ;　　　K,R,U→Y に変更する
                        ;　　　L,S,V→C に変更する
                        ;　　　M,T,W→D に変更する
                        (cond
                          ((or (= #hiki "K")(= #hiki "R")(= #hiki "U"))
                            (##KOUSIN #seri #col "Y" #sym #xd$)
                          )
                          ((or (= #hiki "L")(= #hiki "S")(= #hiki "V"))
                            (##KOUSIN #seri #col "C" #sym #xd$)
                          )
                          ((or (= #hiki "M")(= #hiki "T")(= #hiki "W"))
                            (##KOUSIN #seri #col "D" #sym #xd$)
                          )
                        );_cond
                      )
                    );_if
                  )
                );_if
                
                (if (and (= nil #qry_N$)(/= nil #qry_A$))
                  (progn ; 例外の引手変更
                    ;引手=A,Y,なら何もしない
                    (if (or (= #hiki "A")(= #hiki "Y"))
                      (progn
                        nil
                      )
                      (progn ;それ以外
                        ; K,R,U→Y
                        ; C,D,L,M,S,T,V,W→A
                        (cond
                          ((or (= #hiki "K")(= #hiki "R")(= #hiki "U"))
                            (##KOUSIN #seri #col "Y" #sym #xd$)
                          )
                          ((or (= #hiki "C")(= #hiki "D")(= #hiki "L")(= #hiki "M")
                               (= #hiki "S")(= #hiki "T")(= #hiki "V")(= #hiki "W"))
                            (##KOUSIN #seri #col "A" #sym #xd$)
                          )
                        );_cond
                      )
                    );_if
                  )
                );_if

              )
            );_if

            (setq #i (1+ #i))
          );_(repeat

        )
      );_if

      (CFCmdDefFinish)
      (setq *error* nil)
      (princ "\n引手を更新しました")
    )
  );_if
  (princ)
);ChgWS_Hikite



;;;<HOM>*************************************************************************
;;; <関数名>    : C:KPInsertBlock
;;; <処理概要>  : パースを挿入して分解する(パース挿入コマンド)
;;; <戻り値>    : なし
;;; <作成>      : 01/03/13 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KPInsertBlock (
  /
  #BLOCK #OT #69 #8 #90 #EG$ #I #OK #SSVIEW #EVIEW
  #ORTHOMODE #OSMODE #SNAPMODE ;2010/01/08 YM ADD
  )
  ;// コマンドの初期化
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (StartUndoErr)
  );_if

  (setq #ssVIEW (ssget "X" '((0 . "VIEWPORT"))))
  (setq #i 0 #OK nil)
  (if #ssVIEW
    (progn
      (repeat (sslength #ssVIEW)
        (setq #eg$ (entget (ssname #ssVIEW #i)))
        (setq #8  (cdr (assoc  8 #eg$)))
;;;01/12/05YM@DEL       (setq #90 (cdr (assoc 90 #eg$)))
;;;01/12/05YM@MOD       (if (and (= #8 "VIEW1")(= #90 34881)) ; 透視図ON
        (if (= #8 "VIEW2") ; 01/12/05 YM MOD 検索条件変更 画層のみをみる
          (progn
            (setq #OK T)
            (setq #69 (cdr (assoc 69 #eg$))) ; VIEWPORT ID
            ; 02/01/31 YM ADD-S 隠線処理ON
            (setq #eVIEW (ssname #ssVIEW #i)) ; VIEWPORT図形
            ; 02/01/31 YM ADD-E 隠線処理ON
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

;;;  (setq #ot (getvar "ORTHOMODE"))
;;;  (setvar "ORTHOMODE"  1)

  (if #OK
    (progn
      (setvar "ELEVATION" 0.0)              ; 01/12/06 HN ADD
      (setvar "TILEMODE" 1)
      (setq #block (strcat CG_KENMEI_PATH "BLOCK\\" "M_0.dwg"))
      (if (findfile #block)
        (progn
          ; 02/03/11 YM ADD-S purgeしないと前のパースを挿入してしまう
          (command "_purge" "bl" "*" "N")
          (command "_purge" "bl" "*" "N")
          (command "_purge" "bl" "*" "N")
          ; 02/03/11 YM ADD-E purgeしないと前のパースを挿入してしまう

          (princ "\nパース挿入位置: ")
          (command "_Insert" #block pause "" "")
          (princ "\n配置角度: ")
          (command pause)
          (command "_explode" (entlast))
        )
        (progn
          (CFAlertMsg "\nパースがありません。")
          (quit)
        )
      );_if
      (setvar "TILEMODE" 0) ; ﾚｲｱｳﾄ図に移行

      ; 02/01/31 YM ADD-S ﾊﾟｰｽ用ﾋﾞｭｰﾎﾟｰﾄ隠線処理ON
      (command "_.pspace") ; ﾍﾟｰﾊﾟｰ空間

      ; 02/02/08 YM ADD-S
      (command "zoom" "E") ; 画面いっぱいにズーム
      ; 02/02/08 YM ADD-E

      (command "_layer" "U" "VIEW2" "ON" "VIEW2" "") ; ﾛｯｸ解除,表示
      (command "_.MVIEW" "H" "ON" #eVIEW "")
      ; 06/08/07 T.Ari Add ビューポートがロックされていて3DORBITが効かない場合があるため。
      (command "_.MVIEW" "L" "OFF" #eVIEW "")
      (command "_layer" "LO" "VIEW2" "OF" "VIEW2" "") ; ﾛｯｸ,非表示
      ; 02/01/31 YM ADD-E ﾊﾟｰｽ用ﾋﾞｭｰﾎﾟｰﾄ隠線処理ON

      (princ "\n向きの調整を行って下さい。")
      (princ "\n")
      (command "_mspace")
      (setvar "CVPORT" #69)
      (command "_3DORBIT")
      (setvar "ELEVATION" 0.0)
    )
    (progn ; ﾊﾟｰｽのﾌﾘｰ配置を行う
      ; 03/01/21 YM MOD-S
;;;     (CFAlertMsg "\nこの図面にはパース用のビューポートが設定されていません。")
;;;     (quit)

      ;05/07/04 YM ADD osnap,直行ﾓｰﾄﾞ解除
      (setq #OSMODE    (getvar "OSMODE"   ))
      (setq #SNAPMODE  (getvar "SNAPMODE" ))
      (setq #ORTHOMODE (getvar "ORTHOMODE"))
      (setvar "OSMODE"    0)
      (setvar "SNAPMODE"  0)
      (setvar "ORTHOMODE" 0)

      (KPFreeInsertBlock)

      ;05/07/04 YM ADD osnap,直行ﾓｰﾄﾞ戻す
      (setvar "OSMODE"    #OSMODE)
      (setvar "SNAPMODE"  #SNAPMODE)
      (setvar "ORTHOMODE" #ORTHOMODE)

    )
  );_if

  ;;;  (setvar "ORTHOMODE" #ot)
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (setq *error* nil)
  );_if
  (princ)
);C:KPInsertBlock

;<HOM>*************************************************************************
; <関数名>    : PCM_MirrorParts
; <処理概要>  : ミラー反転処理
; <戻り値>    :
; <作成日>    : 1999-06-14
; <備考>      : 03/05/28 YM Kcmrr.lsp からここへ移動
;*************************************************************************>MOH<
(defun PCM_MirrorParts (
  &SymSS            ;(PICKSET)反転対称の部材
  &p1               ;(LIST)対称軸の一点目
  &p2               ;(LIST)対称軸の二点目
  &EraseFlg         ;(INT) T:反転元を削除 nil:反転元を残す
  /
  #ANG #BPT #BPT1 #BPT2 #DROPPT #DWG #HOLE #I
  #LR #M1PT #M2PT #SEIKAKU #SETLR #SKK$ #SNK_ANA
  #SS #SSYM #SYM #SYM$ #WID #XD-LSYM$ #XD-SNK$ #XD-SYM$ #EN_LIS$
  #DIMD #DIMH #DIMW #ANA #DUM$ #KEI #LAST #O #PTEN5 #XD_PTEN5 #ZOKUP
  #ANA_layer #CRT #RET$ #xd-opt$ #TOKU #XD-TOKU$ #XD-KUTAI$
  #GASSYM #GASCABSYM #SNKSYM #SNKCABSYM #CT_TOP
#RD #RH #RNEW_D #RNEW_H #RNEW_W #RW #XDNEWSYM$ ; 02/03/25 YM
#KIKAKU #TOKUSUN #HH #XDNEWLSYM$ #QRY$ ; 03/05/28 YM
#PTEN5$ #PTEN5$$ #QRY$$ #SINK_KIGO #SINK_LR #SINK_SYM #ZURASHI_W ;2018/10/30 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PCM_MirrorParts ////")
  (CFOutStateLog 1 1 " ")

;;; 水栓よりもシンクを先に移動しなければならない
;;; ｹｺﾐ伸縮が必要なときに備えて,水栓,ｺﾝﾛも優先する 01/03/22 YM ADD
  (if (equal (KPGetSinaType) 2 0.1) ; 01/06/29 YM ADD Lippleはｺﾝﾛｷｬﾋﾞ優先
    (setq #en_lis$ (PKMoveSNKbeforeOther_Lipple &SymSS)) ; 選択ｾｯﾄ--->図形ﾘｽﾄ
    (setq #en_lis$ (PKMoveSNKbeforeOther        &SymSS)) ; 選択ｾｯﾄ--->図形ﾘｽﾄ
  );_if

  ; 特注ｷｬﾋﾞを含むかどうか判定する 含む==>強制終了
  (setq #TOKU nil #CT_TOP nil #TOKUSUN nil) ; 03/05/27 YM #TOKUSUN 追加
;03/05/27 YM DEL-S 特注を含んでいても処理を継続する
;;;  (foreach #sym #en_lis$
;;;    (setq #xd-toku$ (CFGetXData #sym "G_TOKU")) ; 01/03/22 YM ADD
;;;   (if (and #xd-toku$ (= (nth 3 #xd-toku$) 1))
;;;     (setq #TOKU T) ; 特注ｷｬﾋﾞを含んでいる
;;;   );_if
;;;   ; 洗面を含むかどうか 01/08/28 YM ADD-S これはミカド仕様
;;;   (if (and #xd-toku$ (= (nth 3 #xd-toku$) 2))
;;;     (setq #CT_TOP T) ; 特注ｷｬﾋﾞを含んでいる
;;;   );_if
;;;   ; 洗面を含むかどうか 01/08/28 YM ADD-E
;;; )
;;; (if #TOKU
;;;   (progn
;;;     (CFAlertErr "特注キャビネットはミラー反転できません。")
;;;     (quit)
;;;   )
;;; );_if
;;;
;;;   ; 01/08/28 YM ADD-S
;;; (if #CT_TOP
;;;   (CFAlertErr "\n反転後の洗面用カウンタートップは品番確定が解除されます。\n品番確定し直して下さい。")
;;; );_if
;;;   ; 01/08/28 YM ADD-E
;03/05/27 YM DEL-E

  ; 躯体は無視することにした 01/04/23 YM ADD START
  (setq #dum$ nil)
  (foreach #sym #en_lis$
    (setq #xd-kutai$ (CFGetXData #sym "G_KUTAI"))
    (if #xd-kutai$
      nil ; 躯体図形
      (setq #dum$ (append #dum$ (list #sym)))
    );_if
  )
  (setq #en_lis$ #dum$)
  (setq #dum$ nil)
  ; 躯体は無視することにした 01/04/23 YM ADD END

  ; 側面図移動に使う 01/07/17 YM ADD
  (setq #GASSYM    nil)
  (setq #GASCABSYM nil)
  (setq #SNKSYM    nil)
  (setq #SNKCABSYM nil)

;/// main 処理 /////////////////////////////////////////////////////////////////////
  (foreach #sym #en_lis$
    (setq #xd-lsym$ (CFGetXData #sym "G_LSYM"))
    (setq #xd-sym$  (CFGetXData #sym "G_SYM"))
    (setq #xd-opt$  (CFGetXData #sym "G_OPT"))  ; 01/02/28 YM ADD
    (setq #xd-toku$ (CFGetXData #sym "G_TOKU")) ; 01/03/22 YM ADD ★特注★

    ; 03/05/28 YM ADD 特寸を含むかどうか判定
    (setq #KIKAKU nil) ; #KIKAKU=Tなら、特寸なので特注==>規格品にする("G_TOKU"を付加しない)
    (if (and #xd-toku$ (= (nth 3 #xd-toku$) 1))
      (progn
        (if (or (not (equal (nth 11 #xd-sym$) 0 0.001)) ; 伸縮ﾌﾗｸﾞW
                (not (equal (nth 12 #xd-sym$) 0 0.001)) ; 伸縮ﾌﾗｸﾞD
                (not (equal (nth 13 #xd-sym$) 0 0.001))); 伸縮ﾌﾗｸﾞH
          (setq #TOKUSUN T #KIKAKU T) ; #TOKUSUN = Tならﾒｯｾｰｼﾞ表示 , #KIKAKU = T
        )
      )
    );_if

    (setq #bpt1     (cdr (assoc 10 (entget #sym))))
    (setq #seikaku  (nth 9 #xd-lsym$))   ;性格CODE

    (if (= #seikaku CG_SKK_INT_SNK) ; ｼﾝｸの場合 ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
      (progn
        (setq #xd-snk$  (CFGetXData #sym "G_SINK"))

				;2013/01/28 YM ADD-S
				(setq #SINK_KIGO (nth 0 #xd-snk$)) ; ｼﾝｸ記号

			  (setq #qry$$
			    (CFGetDBSQLRec CG_DBSESSION "WTシンク"
			      (list
			        (list "シンク記号" #SINK_KIGO 'STR)
			      )
			    )
			  )
				(if #qry$$
					(setq #SINK_LR (nth 4 (car #qry$$)))
					(setq #SINK_LR 1.0)
				);_if
				;2013/01/28 YM ADD-E

        (setq #HOLE (nth 3 #xd-snk$)) ; ｼﾝｸ穴図形名
        (if (and #HOLE (/= #HOLE ""))
          (progn
            (if (= &EraseFlg T) ; T:削除
              (progn
                (command "_mirror" #HOLE "" &p1 &p2 "Y") ; 移動
                (setq #SNK_ANA #HOLE)     ;ﾐﾗｰ反転後ｼﾝｸ穴図形名
              )
              (progn
                (command "_mirror" #HOLE "" &p1 &p2 "N") ; ｺﾋﾟｰ
                (setq #SNK_ANA (entlast)) ;ﾐﾗｰ反転後ｼﾝｸ穴図形名
              )
            );_if
          )
        );_if
      )
    );_if

    (setq #ang  (nth 2 #xd-lsym$))   ;回転角度
    (setq #dwg  (nth 0 #xd-lsym$))   ;

;下から移動　先に #rW を求めて補正する
    ; 02/03/25 YM ADD-S
    (setq #rW (nth 3 #xd-sym$))
    (setq #rD (nth 4 #xd-sym$))
    (setq #rH (nth 5 #xd-sym$))
    ; 02/03/25 YM ADD-E

		;2018/10/30 YM ADD ｶｳﾝﾀｰＷ値の補正　品番 (nth 5 #xd-lsym$)
		;2018/10/30 YM ADD-S
		(setq #ZURASHI_W (Counter_ZURASHI_W (nth 5 #xd-lsym$) )) ;ｶｳﾝﾀｰW量 or nil

		(if #ZURASHI_W ;ｶｳﾝﾀｰ基点ずらしがあった
			(setq #rW #ZURASHI_W) ;両側ﾄｯﾌﾟ勝ち、片側ﾄｯﾌﾟ勝ちｶｳﾝﾀｰ基点ずれ,反転移動対応
		);_if
		;2018/10/30 YM ADD-E




;2018\10\30 YM MOD-S
;;;		(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
;;;			(progn
;;;				(if (= #seikaku CG_SKK_INT_SUI) ;水栓ならW=0
;;;		    	(setq #wid  0)    ;
;;;					;else
;;;					(setq #wid  (nth 3 #xd-sym$))    ;水栓以外そのまま
;;;				);_if
;;;			)
;;;			;else ﾌﾚｰﾑｷｯﾁﾝ以外
;;;			(progn
;;;		    (setq #wid  (nth 3 #xd-sym$))    ;
;;;			)
;;;		);_if

		(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
			(progn
				(if (= #seikaku CG_SKK_INT_SUI) ;水栓ならW=0
		    	(setq #rW  0)    ;
					;else
					nil
				);_if
			)
			;else ﾌﾚｰﾑｷｯﾁﾝ以外
			(progn
		    nil
			)
		);_if
;2018\10\30 YM MOD-E


    (setq #bpt2 (polar #bpt1 #ang #rW))




    ;// 対称軸とシンボル基点の垂点を求める
    (setq &p1 (list (car &p1) (cadr &p1) (caddr #bpt1)))
    (setq &p2 (list (car &p2) (cadr &p2) (caddr #bpt1)))
    (setq #DropPt (CFGetDropPt #bpt1 (list &p1 &p2)))

    ;// 反転後の仮原点を求める
    (setq #m1pt (polar #bpt1 (angle #bpt1 #DropPt) (* 2. (distance #bpt1 #DropPt))))

    ;// 対称軸とシンボル基点の垂点を求める
    (setq #DropPt (CFGetDropPt #bpt2 (list &p1 &p2)))

    ;// 反転後の仮原点を求める
    (setq #m2pt (polar #bpt2 (angle #bpt2 #DropPt) (* 2. (distance #bpt2 #DropPt))))
    (setq #ang  (angle #m2pt #m1pt))

    ;// L/R区分の取得
    (setq #LR (nth 6 #xd-lsym$))
    (if (/= #LR "Z")   ;L/R区分あり ; 00/02/18 YM MOD
      (progn
        ;// 左勝手部材を取得しなおし、再配置
        ; 01/02/28 YM MOD START
        (setq #ret$ (PKC_GetLRParts #xd-lsym$))
        (setq #dwg #ret$)
;;;2008/08/04YM@DEL        (setq #dwg (car   #ret$))
;;;2008/08/04YM@DEL        (setq #CRT (cadr  #ret$)) ; 展開ID
        ; 01/02/28 YM MOD END
      )
    )
    (setq #skk$ (CFGetSeikakuToSKKCode #seikaku nil))

		;2017/09/25 YM MOD-S ﾌﾚｰﾑｷｯﾁﾝは飛ばす ｼﾝｸ図形がないため。そのまま水栓を反転させると少しずれる。
		;水栓間口サイズ>0のため、水栓間口サイズ=0とみなす
		(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
			(progn
				nil ;SKIP
			)
			(progn

		    (cond
		      ((= (caddr #skk$) CG_SKK_THR_CNR)
		        (setq #m2pt #m1pt)
		        (setq #ang (- #ang (dtr 90)))
		      )
		      ((or (= (car #skk$) CG_SKK_ONE_SNK) (= (car #skk$) CG_SKK_ONE_WTR))
					 	;ｼﾝｸ or 水栓
						(if (= (car #skk$) CG_SKK_ONE_SNK)
							;ｼﾝｸ
		      		(setq #m2pt #m1pt)
							;else 水栓
							(progn
								;ｼﾝｸにL/Rがあればこれでいい
								(if (equal #SINK_LR 1.0 0.001)
									(progn
				        		(setq #m2pt #m1pt)
									)
									(progn
										;ｼﾝｸにL/Rがなければ水栓穴位置(1つだけを想定)に配置する
							      ;// シンクに設定されている水栓取付け点（Ｐ点=５）の情報を取得する
							      (setq #pten5$$ (PKGetPTEN_NO #SINK_SYM 5)) ; 戻り値(PTEN図形,G_PTEN)のﾘｽﾄのﾘｽﾄ
										(setq #pten5$ (car #pten5$$))
										(setq #pten5 (nth 0 #pten5$))
										(setq #m2pt (cdr (assoc 10 (entget #pten5)))) ; 中心点座標
									)
								);_if
							)
						);_if
		      )
		    );_cond

			)
		);_if
		;2017/09/25 YM MOD-E ﾌﾚｰﾑｷｯﾁﾝは飛ばす

    (setq #ssym (CFGetSameGroupSS #sym))
    (if (= &EraseFlg T)
      (command "_erase" #ssym "")
    )
    (command "_insert" (strcat CG_MSTDWGPATH #dwg) #m2pt 1 1 (rtd #ang))
    (command "_explode" (entlast))  ;インサート図形分解
    (setq #ssym (ssget "P"))
    (setq #last (ssname #ssym 0))


    (SKMkGroup #ssym)               ;分解した図形群で名前のないグループ作成
;;;    (setq #sym (SKC_GetSymInGroup #last)) ; ｼﾝﾎﾞﾙ取得
       (setq #sym (PKC_GetSymInGroup #ssym))      ;;  2005/08/03 G.YK ADD



    ; 02/03/25 YM ADD-S
    (setq #xdNEWSYM$  (CFGetXData #sym "G_SYM"))
    (setq #rNEW_W (nth 3 #xdNEWSYM$))
    (setq #rNEW_D (nth 4 #xdNEWSYM$))
    (setq #rNEW_H (nth 5 #xdNEWSYM$))
    ; 02/03/25 YM ADD-E

		;2018/10/30 YM ADD ｶｳﾝﾀｰＷ値の補正　品番 (nth 5 #xd-lsym$)
		;2018/10/30 YM ADD-S
		(setq #ZURASHI_W (Counter_ZURASHI_W (nth 5 #xd-lsym$) )) ;ｶｳﾝﾀｰW量 or nil

		(if #ZURASHI_W ;ｶｳﾝﾀｰ基点ずらしがあった
			(setq #rNEW_W #ZURASHI_W) ;両側ﾄｯﾌﾟ勝ち、片側ﾄｯﾌﾟ勝ちｶｳﾝﾀｰ基点ずれ,反転移動対応
		);_if
		;2018/10/30 YM ADD-E


    (if (= #LR "Z")       ; 00/02/18 YM MOD
      (setq #setLR "Z")   ; 00/02/18 YM MOD
      (if (= #LR "L")     ; 00/02/18 YM MOD
        (setq #setLR "R") ; 00/02/18 YM MOD
        (setq #setLR "L") ; 00/02/18 YM MOD
      )
    )
    (setq #bpt (cdr (assoc 10 (entget #sym))))

;;;   (if (= #seikaku CG_SKK_INT_SCA) ; ｼﾝｸｷｬﾋﾞの場合 ; 01/08/31 YM MOD 112-->ｸﾞﾛｰﾊﾞﾙ化
;;;     (setq #snkCAB #sym)
;;;   )

    ;// 拡張データの再設定
    (CFSetXData #sym "G_LSYM"
      (list
        #dwg                ;1 :本体図形ID      :『品番図形』.図形ID
        #bpt                ;2 :挿入点          :配置基点
        #ang                ;3 :回転角度        :配置回転角度
        (nth 3  #xd-lsym$)  ;4 :工種記号        :CG_Kcode
        (nth 4  #xd-lsym$)  ;5 :SERIES記号    :CG_SeriesCode
        (nth 5  #xd-lsym$)  ;6 :品番名称        :『品番図形』.品番名称
        #setLR              ;7 :L/R区分         :『品番図形』.部材L/R区分
        (nth 7  #xd-lsym$)  ;8 :扉図形ID        :
      (if (/= #LR "Z")
        ""                ;9 :扉開き図形ID    : HOPE-0351 2008/08/04 YM MOD
        (nth 8  #xd-lsym$)
      );_if
        (nth 9  #xd-lsym$)  ;10:性格CODE      :『品番基本』.性格CODE
        (nth 10 #xd-lsym$)  ;11:複合フラグ      :０固定（単独部材）
        (nth 11 #xd-lsym$)  ;12:配置順番号      :配置順番号(1～)
        (nth 12 #xd-lsym$)  ;13:用途番号        :『品番図形』.用途番号
        (nth 13 #xd-lsym$)  ;14:寸法Ｈ          :『品番図形』.寸法Ｈ
        (nth 14 #xd-lsym$)  ;15:断面指示の有無  :断面指示の有無
        (nth 15 #xd-lsym$)  ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
      )
    )
    (if #xd-opt$ (CFSetXData #sym "G_OPT" #xd-opt$)) ; 01/02/28 YM ADD

    ; 03/05/28 YM ADD-S
    ; 特注品なら元の特注情報を付与する.但し特寸品(#KIKAKU=T)は付加しない
    (if (and (= nil #KIKAKU) #xd-toku$)
      (CFSetXData #sym "G_TOKU" #xd-toku$)
    );_if

    ;特寸品==>規格品にしたものは"G_SYM"の伸縮ﾌﾗｸﾞを0ｸﾘｱする
    ;;;[12]:伸縮ﾌﾗｸﾞW                               (1040 . 1250.0)-->0
    ;;;[13]:伸縮ﾌﾗｸﾞD                               (1070 . 0)
    ;;;[14]:伸縮ﾌﾗｸﾞH                               (1070 . 900)-->0
    (if (and (= T #KIKAKU) #xd-toku$)
      (progn
        ;// 拡張データの"G_SYM"の更新
        (CFSetXData #sym "G_SYM"
          (CFModList #xdNEWSYM$
            (list
              (list 11 0)
              (list 12 0)
              (list 13 0)
            )
          )
        )
        ;// 拡張データの"G_LSYM"の更新
        ;品番図形.寸法Hを取得して置き換える
        (setq #xdNEWLSYM$ (CFGetXData #sym "G_LSYM")) ; 反転後の新しい"G_LSYM"
        (setq #qry$
          (car
            (CFGetDBSQLHinbanTable "品番図形"
               (nth 5 #xdNEWLSYM$)
               (list
                 (list "品番名称" (nth 5 #xdNEWLSYM$)          'STR)
                 (list "LR区分"   (nth 6 #xdNEWLSYM$)          'STR)
                 (list "用途番号" (rtois (nth 12 #xdNEWLSYM$)) 'INT)
               )
            )
          )
        )
        (CFSetXData #sym "G_LSYM"
          (CFModList #xdNEWLSYM$
            (list
              (list 13 (nth 5 #qry$));2008/06/28 YM OK!
            )
          )
        )
      )
    );_if
    ; 03/05/28 YM ADD-E


    ; 01/06/20 YM "G_SINK"ｾｯﾄ不具合修正
    (if (= nil #SNK_ANA)(setq #SNK_ANA ""))

    (if (= #seikaku CG_SKK_INT_SNK) ; ｼﾝｸの場合 ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
			(progn
				;2013/01/28 YM ADD-S
				(setq #SINK_SYM #sym);シンク図形を記憶しておく
				;2013/01/28 YM ADD-E
	      (CFSetXData #sym "G_SINK"
	        (CFModList
	          #xd-snk$
	          (list
	            (list 3 #SNK_ANA)
	;;;           (list 4 #snkCAB)
	          )
	        )
	      )
			)
    );_if

    (if (and #xd-toku$ (= (nth 3 #xd-toku$) 0))
      (progn ; ｹｺﾐ伸縮が必要
        (setq KEKOMI_BRK (nth 4 #xd-toku$)); ﾌﾞﾚｰｸﾗｲﾝ位置
        (setq KEKOMI_COM (nth 5 #xd-toku$)); 伸縮量
        (KPCallKekomi (list #sym)) ; ｹｺﾐ伸縮処理
      )
    );_if

    ; 側面図移動に使う 01/07/17 YM ADD
    (cond
      ((= #seikaku CG_SKK_INT_GAS)(setq #GASSYM    #sym)) ; ｺﾝﾛの場合 ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
      ((= #seikaku CG_SKK_INT_GCA)(setq #GASCABSYM #sym)) ; ｺﾝﾛｷｬﾋﾞの場合 ; 01/08/31 YM MOD 113-->ｸﾞﾛｰﾊﾞﾙ化
      ((= #seikaku CG_SKK_INT_SNK)(setq #SNKSYM    #sym)) ; ｼﾝｸの場合 ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
      ((= #seikaku CG_SKK_INT_SCA)(setq #SNKCABSYM #sym)) ; ｼﾝｸｷｬﾋﾞの場合 ; 01/08/31 YM MOD 112-->ｸﾞﾛｰﾊﾞﾙ化
    );_cond

    ; 02/03/25 YM ADD-S 伸縮していたものは再伸縮する(ただしｺｰﾅｰｷｬﾋﾞﾈｯﾄ以外に限る-->ｺｰﾅｰｷｬﾋﾞL/Rで不具合)
    (if (and (= CG_SKK_ONE_CAB (CFGetSymSKKCode #sym 1))
             (= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3)))
      nil ; ｺｰﾅｰｷｬﾋﾞﾈｯﾄだった
      (progn

        ;特寸品==>規格品にしたものは対象外とする 03/05/28 YM ADD
        (if (and (= T #KIKAKU) #xd-toku$)
          nil ; 03/05/28 YM ADD
          ;else
          (progn ; 従来ﾛｼﾞｯｸ
            (if (not (equal #rNEW_W #rW 0.0001))
              (SKY_Stretch_Parts #sym #rW #rNEW_D #rNEW_H)
            );_if
            (if (not (equal #rNEW_D #rD 0.0001))
              (SKY_Stretch_Parts #sym #rW #rD #rNEW_H)
            );_if
            (if (not (equal #rNEW_H #rH 0.0001))
              (SKY_Stretch_Parts #sym #rW #rD #rH)
            );_if
          )
        );_if

      )
    );_if
    ; 02/03/25 YM ADD-E 伸縮していたものは再伸縮する

    (setq #sym$ (cons #sym #sym$))
  );_foreach
;/// main 処理 /////////////////////////////////////////////////////////////////////

  ;03/05/27 YM MOD-S 特注でも処理を行う(quitしない)
  (if #TOKUSUN
    (progn
      (CFYesDialog "特寸キャビは規格品に戻るため、反転後再調整が必要です")
    )
  );_if
  ;03/05/27 YM MOD-E

  ; 側面図移動 01/07/17 YM ADD
  (if (and #GASSYM #GASCABSYM)
    (PKC_MoveToSGCabinetSub #GASSYM #GASCABSYM)
  );_if
  (if (and #SNKSYM #SNKCABSYM)
    (PKC_MoveToSGCabinetSub #SNKSYM #SNKCABSYM)
  );_if

  ;// 反転後の設備部材図形リストを返す
  #sym$
);PCM_MirrorParts

;<HOM>*************************************************************************
; <関数名>    : SKFSetHidePLayer
; <処理概要>  : Ｐ面、Ｐ線、Ｐ点を非表示とする
; <戻り値>    : 図形名リスト
; <作成>      : 1998-09-10 2003/06/06 YM Kcfcmn.lsp からそのまま移動
;*************************************************************************>MOH<
(defun SKFSetHidePLayer (
    /
  #ss
  #EG #EN #I #SUBST ;03/11/28 YM ADD
  )
  (setq #ss (ssget "X" '((-3 ("G_PMEN,G_PSEN,G_PTEN")))))
  (If (/= #ss nil)
    (progn

      (if (= nil (tblsearch "LAYER" "O_HIDE")) (MakeLayer "O_HIDE" 7 "CONTINUOUS"))
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #eg (entget #en '("*")))
        (setq #subst (subst (cons 8 "O_HIDE")(assoc 8 #eg) #eg))
        (entmod #subst)
        (setq #i (1+ #i))
      )
      (command "_.layer" "OFF" "O_HIDE" "")
    )
  )
)

;<HOM>*************************************************************************
; <関数名>    : KP_GetOpt2Info
; <処理概要>  : "G_OPT2" ==> (特注品番,元品番,金額,SET品ﾌﾗｸﾞ,品名,備考)のﾘｽﾄ nilあり
; <戻り値>    : 特注ｵﾌﾟｼｮﾝ品情報 (特注品番,元品番,金額,SET品ﾌﾗｸﾞ,品名,備考)のﾘｽﾄ nilあり
; <作成>      : 03/06/17 YM
; <備考>      : ダミーの関数
; ***********************************************************************************>MOH<
(defun KP_GetOpt2Info (
  &xdOPT2$ ; 特注ｵﾌﾟｼｮﾝ品情報 nilあり得る
  /
  #opt2$$
  )
  (setq #opt2$$ nil)
  #opt2$$
);KP_GetOpt2Info

;<HOM>*************************************************************************
; <関数名>    : SCFGetBlockKindDlg
; <処理概要>  : 出力展開元図設定ダイアログ
; <戻り値>    : ダイアログ返り値
; <作成>      : 1999-06-21
; <備考>      : なし
;*************************************************************************>MOH<

(defun SCFGetBlockKindDlg (
  &no$        ; 領域番号リスト
  /
  #xSp #iI #Ex$ #No$ #iMode #sNo #iId  #Ret$ #iRet
  )

  (defun ##OK_Click(
    /
    #Ret$ #sPln #sExa #sExb #sExc #sExd #sTab
    )

    ; 2000/07/06 HT YASHIAC  矢視領域判定変更 DEL START
    ;;領域番号獲得
    ;(if (/= nil #No$)
    ;  (progn
    ;    (if (/= 1 (length #No$))
    ;      (if (= "0" (get_tile "popRyo"))
    ;        (setq #No$ (cdr #No$))
    ;        (setq #No$ (list (nth (atoi (get_tile "popRyo")) #No$)))
    ;      )
    ;    )
    ;  )
    ;)
    ; 2000/07/06 HT YASHIAC  矢視領域判定変更 END

    (if (= "1" (get_tile "tglAll"))
      (progn
        (setq #Ret$ (list 1 1 1))
        ; 2000/07/06 HT YASHIAC  矢視領域判定変更 MOD
        ;(setq #Ret$ (list #Ret$ #No$))
        (setq #Ret$ (list #Ret$ (list "0")))
        (done_dialog 1)
      )
      (progn
        (setq #sPln (get_tile "tglPln"))
        (setq #sExt (get_tile "tglExt"))
        (setq #sTab (get_tile "tglTab"))
        (if (and (= "0" #sPln)(= "0" #sExt)(= "0" #sTab))
          (CFAlertMsg "何も選択されていません,")
          (progn
            ;図面種類
            (setq #Ret$ (list #sPln #sExt #sTab))
            (setq #Ret$ (mapcar 'atoi #Ret$))
            ; 2000/07/06 HT YASHIAC  矢視領域判定変更 MOD
            ; (setq #Ret$ (list #Ret$ #No$))
            (setq #Ret$ (list #Ret$ (list "0")))
            (done_dialog 1)
          )
        )
      )
    )
    #Ret$
  )

  (defun ##AllTgl (
    /
    )
    (if (= "1" (get_tile "tglAll"))
      (progn
        (mode_tile "tglPln" 1)
        (mode_tile "tglExt" 1)
        (mode_tile "tglTab" 1)
      )
      (progn
        (mode_tile "tglPln" 0)
        (mode_tile "tglExt" 0)
        (mode_tile "tglTab" 0)
      )
    )
  )

  ; 2000/07/06 HT YASHIAC  矢視領域判定変更 DEL START
  ;;領域NO獲得
  ;(if (/= nil &no$)
  ;  (progn
  ;    (mapcar
  ;     '(lambda ( #no )
  ;        (if (= 'STR (type #no))
  ;          (setq #No$ (cons #no #No$))
  ;        )
  ;      )
  ;      &no$
  ;    )
  ;    (if (/= nil #No$)
  ;      (progn
  ;        (setq #No$ (acad_strlsort #No$))
  ;        (setq #No$ (ExceptToList #No$))
  ;        (if (/= 1 (length #No$))
  ;          (progn
  ;            (setq #No$ (cons "ALL" #No$))
  ;            (setq #iMode 0)
  ;          )
  ;          (setq #iMode 1)
  ;        )
  ;      )
  ;      (progn
  ;        (setq #No$ nil)
  ;        (setq #sNo "1")
  ;        (setq #iMode 1)
  ;      )
  ;    )
  ;  )
  ;  (progn
  ;    (setq #No$ nil)
  ;    (setq #sNo "1")
  ;    (setq #iMode 1)
  ;  )
  ;)

  ;;ﾘｽﾄﾎﾞｯｸｽに値を表示する
  ;(defun ##SetList ( &SCFey &List$ / #vAl )
  ;  (start_list &SCFey)
  ;  (foreach #vAl &List$
  ;    (add_list #vAl)
  ;  )
  ;  (end_list)
  ;)
  ; 2000/07/06 HT YASHIAC  矢視領域判定変更 DEL END

  ;ﾀﾞｲｱﾛｸﾞ表示
  (setq #iId (GetDlgID "CSFmat"))
  (if (not (new_dialog "GetMat" #iId))(exit))

    (##AllTgl)
    ; 2000/07/06 HT YASHIAC  矢視領域判定変更 DEL
    ;(##SetList "popRyo" #No$)
    ;(mode_tile "popRyo" #iMode)
    (action_tile "tglAll" "(##AllTgl)")
    (action_tile "accept" "(setq #Ret$ (##OK_Click))")
    (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OKボタン押下
    #Ret$
    nil
  )
) ; SCFGetBlockKindDlg

;<HOM>*************************************************************************
; <関数名>    : KP_MakeDummyPoint
; <処理概要>  : ﾃﾝﾌﾟﾚｰﾄにPOINTを作図
; <戻り値>    : なし
; <作成>      : 03/07/26 YM
; <備考>      : なし NASはダミー関数(処理なし)
;*************************************************************************>MOH<
(defun KP_MakeDummyPoint ( / )
  (princ)
)


;<HOM>*************************************************************************
; <関数名>    : c:SCFDispOnOff
; <処理概要>  : 表示制御コマンド
; <戻り値>    : なし
; <作成>      : 00/03/15
; <備考>      : なし
;*************************************************************************>MOH<

(defun c:SCFDispOnOff (
  /
  #DT #EG #IID #IRET #KEY #LAY$ #LAYER #LAYER$$ #RET$
  )
  ;2011/07/06 YM MOD-S 項目変更
;;; (setq #layer$$
;;;   (list
;;;     (list "0_DOOR"   "tgl1")
;;;     (list "0_PLIN_1" "tgl2")
;;;     (list "0_PLIN_2" "tgl3")
;;;     (list "0_WALL"   "tgl4")
;;;     (list "0_REFNO"  "tgl5")
;;;   )
;;; )
  (setq #layer$$
    (list
      (list "0_DOOR"    "tgl0")  ;扉模様表示    2013/09/17 ｺﾒﾝﾄ解除 tgl1==>tgl0
      (list "0_pline_1" "tgl1")  ;扉開き線表示
      (list "0_KUTAI"   "tgl2")  ;躯体表示
      (list "0_WALL"    "tgl3")  ;ｳｫｰﾙ平面表示
      (list "0_REFNO"   "tgl4")  ;仕様表番号表示
    )
  )
  ;2011/07/06 YM MOD-E 項目変更

  ;////////////////////////////////////////////////////////////////
  (defun ##OK_Click(
    /
    )
    (list
      (list "0_DOOR"   (get_tile "tgl0"))  ; 扉模様表示 ;2013/09/17 ｺﾒﾝﾄ解除 tgl1==>tgl0
      (list "0_pline_1" (get_tile "tgl1"))  ; 扉模様表示
      (list "0_KUTAI"  (get_tile "tgl2"))  ; 躯体表示
      (list "0_WALL"   (get_tile "tgl3"))  ; 2000/06/20 HT 本来のｳｫｰﾙ平面表示  追加
      (list "0_REFNO"  (get_tile "tgl4"))  ; 01/05/01 YM ADD 仕様表番号表示  追加
    )
  )
  ;////////////////////////////////////////////////////////////////

  (SCFStartShori "SCFDispOnOff")  ; 2000/09/08 HT ADD

  ;ﾀﾞｲｱﾛｸﾞ表示
  (setq #iId (GetDlgID "CSFdisp"))
  (if (not (new_dialog "SCFDispOnOff" #iId))(exit))

  ; 初期ﾄｸﾞﾙ設定 01/05/01 YM
  (foreach #layer$ #layer$$
    (setq #layer (car  #layer$))
    (setq #key   (cadr #layer$))
    (if (tblsearch "LAYER" #layer) ; 62 : 色番号(負の場合、画層は非表示)
      (if (= 1 (cdr (assoc 70 (tblsearch "LAYER" #layer)))) ; (70.1)ﾌﾘｰｽﾞ 01/05/18 YM MOD
;;;01/05/18YM@      (if (minusp (cdr (assoc 62 (tblsearch "LAYER" #layer)))) ; 数値が負かどうかを調べます
        (set_tile #key "0") ; 非表示==>ﾁｪｯｸを入れない
        (set_tile #key "1") ; 表示==>ﾁｪｯｸを入れる
      );_if
      (mode_tile #key 1) ; 使用不可能
    );_if
  )

  ; ｱｸｼｮﾝ
  (action_tile "accept" "(setq #Ret$ (##OK_Click))(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OKボタン押下
    (progn
      (mapcar
       '(lambda ( #lay$ )
          (setq #layer (car #lay$))
          (if (tblsearch "LAYER" #layer)
            (progn
              ; 01/05/18 YM MOD START
;;;             (setq #eg (entget (tblobjname "LAYER" #layer)))
              (cond
                ((= "1" (cadr #lay$))
                  (command "_.layer" "T" #layer "")
;;;                 (entmod (subst (cons 70 0) (assoc 70 #eg) #eg))
                )
                ((= "0" (cadr #lay$))
                  (command "_.layer" "F" #layer "")
;;;                 (entmod (subst (cons 70 1) (assoc 70 #eg) #eg)) ; ﾌﾘｰｽﾞ
                )
              );_cond
              ; 01/05/18 YM MOD END

;;;01/05/18YM@; 62 : 色番号(負の場合、画層は非表示)
;;;01/05/18YM@            (if (or (and (minusp (cdr (assoc 62 (tblsearch "LAYER" #layer)))) ; 数値が負かどうかを調べます
;;;01/05/18YM@                         (= "1" (cadr #lay$)))
;;;01/05/18YM@                    (and (not (minusp (cdr (assoc 62 (tblsearch "LAYER" #layer)))))
;;;01/05/18YM@                         (= "0" (cadr #lay$))))
;;;01/05/18YM@              (progn
;;;01/05/18YM@                (setq #eg (entget (tblobjname "LAYER" #layer)))
;;;01/05/18YM@                (setq #dt (* -1 (cdr (assoc 62 #eg))))
;;;01/05/18YM@                (entmod (subst (cons 62 #dt) (assoc 62 #eg) #eg))
;;;01/05/18YM@              )
;;;01/05/18YM@            );_if

            )
          );_if
        )
        #Ret$
      )
    )
  );_if
  (princ)
) ; SCFGetPatDlg

;<HOM>*************************************************************************
; <関数名>    : SCAutoFDispOnOff
; <処理概要>  : 自動表示制御(特定の扉ｼﾘｰｽﾞのときだけ「扉開き勝手線」をOFFにする)
; <戻り値>    : なし
; <作成>      : 03/09/30
; <備考>      : 特定の扉ｼﾘｰｽﾞは"Errmsg.ini"で定義する
;               図面参照時にCALLするNASは何もしない
;*************************************************************************>MOH<
(defun SCAutoFDispOnOff ( / )
  (princ)
); SCAutoFDispOnOff

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_DanmenDlg
;;; <処理概要>  : WT断面ダイアログ
;;; <戻り値>    : 断面情報(WT断面ﾚｺｰﾄﾞ,(2枚目BG有無,FGﾀｲﾌﾟ,3枚目BG有無,FGﾀｲﾌﾟ))
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKW_DanmenDlg (
  &ZaiCode ; 材質
  &CutId   ; ｶｯﾄID
  /
  #DCL_ID #DAN$$ #QRY$$ #REC$
#FULLFLAT ;03/11/28 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_DanmenDlg ////")
  (CFOutStateLog 1 1 " ")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1,2,3枚目WT設定使用可,不可ﾀｲﾙﾓｰﾄﾞｾｯﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##MODE123 (&flg1 &flg2 &flg3 / )
            ; 0:使用可 1:使用不可
            (mode_tile "box1"    &flg1)
            (mode_tile "BGtext1" &flg1)
            (mode_tile "FGtext1" &flg1)
            (mode_tile "box2"    &flg2)
            (mode_tile "BGtext2" &flg2)
            (mode_tile "FGtext2" &flg2)
            (mode_tile "box3"    &flg3)
            (mode_tile "BGtext3" &flg3)
            (mode_tile "FGtext3" &flg3)
            (princ)
          );##MODE123
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1,2,3枚目WT設定ﾗｼﾞｵﾎﾞﾀﾝｾｯﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##SET123 (&flg1 &flg2 &flg3 &flg4 &flg5 &flg6 /  )
            (set_tile "BGradio1-1" &flg1) ; 1枚目BG有無
            (set_tile "FGradio1-1" &flg2) ; 1枚目FGﾀｲﾌﾟ前側,両側
            (set_tile "BGradio2-1" &flg3) ; 2枚目BG有無
            (set_tile "FGradio2-1" &flg4) ; 2枚目FGﾀｲﾌﾟ前側,両側
            (set_tile "BGradio3-1" &flg5) ; 3枚目BG有無
            (set_tile "FGradio3-1" &flg6) ; 3枚目FGﾀｲﾌﾟ前側,両側
            (princ)
          );##SET123
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; WT断面ﾚｺｰﾄﾞを取得
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( /
            #BG1-1 #BG2-1 #BG3-1 #BG_S1 #BG_S2 #BG_S3 #BG_TYPE1 #BG_TYPE2 #BG_TYPE3
            #FG1-1 #FG1-2 #FG1-3 #FG1-4 #FG2-1 #FG2-2 #FG2-3 #FG3-1 #FG3-2 #FG3-3
            #FG_TYPE1 #FG_TYPE2 #FG_TYPE3 #WTINFO1 #WTINFO2 #WTINFO3
            )
            (if (= (get_tile "rad2") "1") ; 断面個別設定にﾁｪｯｸ
              (progn ; 断面個別設定
                (setq #BG1-1 (get_tile "BGradio1-1"))        ; 1枚目BG有無
                (setq #BG2-1 (get_tile "BGradio2-1"))        ; 2枚目BG有無
                (setq #BG3-1 (get_tile "BGradio3-1"))        ; 3枚目BG有無

                (setq #FG1-1 (get_tile "FGradio1-1"))        ; 1枚目FGﾀｲﾌﾟ前側
                (setq #FG1-2 (get_tile "FGradio1-2"))        ; 1枚目FGﾀｲﾌﾟ前後
;;;               (setq #FG1-3 (get_tile "FGradio1-3"))        ; 1枚目FGﾀｲﾌﾟ前後右
;;;               (setq #FG1-4 (get_tile "FGradio1-4"))        ; 1枚目FGﾀｲﾌﾟ前側左
                (setq #FG2-1 (get_tile "FGradio2-1"))        ; 2枚目FGﾀｲﾌﾟ前側
                (setq #FG2-2 (get_tile "FGradio2-2"))        ; 2枚目FGﾀｲﾌﾟ前後
;;;               (setq #FG2-3 (get_tile "FGradio2-3"))        ; 2枚目FGﾀｲﾌﾟ前後右
                (setq #FG3-1 (get_tile "FGradio3-1"))        ; 3枚目FGﾀｲﾌﾟ前側
                (setq #FG3-2 (get_tile "FGradio3-2"))        ; 3枚目FGﾀｲﾌﾟ前後
;;;               (setq #FG3-3 (get_tile "FGradio3-3"))        ; 3枚目FGﾀｲﾌﾟ前後右

                (setq #BG_S1 (atof (get_tile "WT_EXT1"))) ; 1枚目WT奥行拡張
                (setq #BG_S2 (atof (get_tile "WT_EXT2"))) ; 2枚目WT奥行拡張
                (setq #BG_S3 (atof (get_tile "WT_EXT3"))) ; 3枚目WT奥行拡張

                (if (= #BG1-1 "1")  ; 1枚目BG有無
                  (setq #BG_Type1 1); BGあり
                  (setq #BG_Type1 0); BGなし
                );_if
                (if (= #BG2-1"1")   ; 2枚目BG有無
                  (setq #BG_Type2 1); BGあり
                  (setq #BG_Type2 0); BGなし
                );_if
                (if (= #BG3-1 "1")  ; 3枚目BG有無
                  (setq #BG_Type3 1); BGあり
                  (setq #BG_Type3 0); BGなし
                );_if

                (cond
                  ((= #FG1-1 "1")     ; 1枚目FGﾀｲﾌﾟ
                    (setq #FG_Type1 1); FG前
                  )
                  ((= #FG1-2 "1")     ; 1枚目FGﾀｲﾌﾟ
                    (setq #FG_Type1 2); FG前後
                  )
                  ((= #FG1-3 "1")     ; 1枚目FGﾀｲﾌﾟ
                    (setq #FG_Type1 3); FG前後右
                  )
                  ((= #FG1-4 "1")     ; 1枚目FGﾀｲﾌﾟ
                    (setq #FG_Type1 4); FG前後左
                  )
                );_cond

                (cond
                  ((= #FG2-1 "1")     ; 2枚目FGﾀｲﾌﾟ
                    (setq #FG_Type2 1); FG前
                  )
                  ((= #FG2-2 "1")     ; 2枚目FGﾀｲﾌﾟ
                    (setq #FG_Type2 2); FG前後
                  )
                  ((= #FG2-3 "1")     ; 2枚目FGﾀｲﾌﾟ
                    (setq #FG_Type2 3); FG前後右
                  )
                );_cond

                (cond
                  ((= #FG3-1 "1")     ; 3枚目FGﾀｲﾌﾟ
                    (setq #FG_Type3 1); FG前
                  )
                  ((= #FG3-2 "1")     ; 3枚目FGﾀｲﾌﾟ
                    (setq #FG_Type3 2); FG前後
                  )
                  ((= #FG3-3 "1")     ; 3枚目FGﾀｲﾌﾟ
                    (setq #FG_Type3 3); FG前後右
                  )
                );_cond

                (setq #WTInfo1 (list #BG_S1 #BG_Type1 #FG_Type1));1枚目WT奥行拡張,1枚目BG有無,1枚目FGﾀｲﾌﾟ
                (setq #WTInfo2 (list #BG_S2 #BG_Type2 #FG_Type2));2枚目
                (setq #WTInfo3 (list #BG_S3 #BG_Type3 #FG_Type3));3枚目
              )
              (progn ; 断面共通
                (setq #WTInfo1
                  (list (nth 10 #rec$)(nth 3 #rec$)(nth 6 #rec$));後垂れｼﾌﾄ,BG有無,前垂れﾀｲﾌﾟ
                )
                (setq #WTInfo2 #WTInfo1)
                (setq #WTInfo3 #WTInfo1)
              )
            );_if

            (done_dialog)
            (list #rec$ #WTInfo1 #WTInfo2 #WTInfo3)
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 個別設定表示open
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##open ( / #flg1 #flg2)

;03/11/27 YM ｱｲﾌﾙﾎｰﾑ対応 MOD-S

        ;03/10/14 YM ADD
        (setq #FullFlat (nth 12 #rec$))
        (cond 
          ;ｱｲﾌﾙﾎｰﾑﾓﾃﾞﾙﾌﾟﾗﾝ
          ((or (equal #FullFlat 51 0.1)(equal #FullFlat 52 0.1))
            ;ﾌﾙﾌﾗｯﾄ初期値定義
            (set_tile "rad2" "1")
            (mode_tile "BGradio1" 1)
            (mode_tile "FGradio1" 1)
;-- 2011/08/25 A.Satoh Mod - S
;            (set_tile "WT_EXT1" "450")
            (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
          )
          ;ﾃﾞｨﾌﾟﾛｱﾌﾙﾌﾗｯﾄﾌﾟﾗﾝ
          ((or (equal #FullFlat  2 0.1)(equal #FullFlat  3 0.1)
               (equal #FullFlat 22 0.1)(equal #FullFlat 33 0.1))
            ;ﾌﾙﾌﾗｯﾄ初期値定義
            (set_tile "rad2" "1")
            (mode_tile "BGradio1" 1)
            (mode_tile "FGradio1" 1)
;-- 2011/08/25 A.Satoh Mod - S
;            (set_tile "WT_EXT1" "410")
            (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
          )
          ;07/07/11 YM ADD ｸﾚｽﾀﾌﾗｯﾄﾌﾟﾗﾝD=880
          ((or (equal #FullFlat 82 0.1)(equal #FullFlat 83 0.1))
            ;ﾌﾙﾌﾗｯﾄ初期値定義
            (set_tile "rad2" "1")
            (mode_tile "BGradio1" 1)
            (mode_tile "FGradio1" 1)
;-- 2011/08/25 A.Satoh Mod - S
;            (set_tile "WT_EXT1" "230")
            (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
          )
          (T
            (if (= (get_tile "rad2") "1")
              (progn ; 個別設定
                (cond ; 使用ﾓｰﾄﾞ制御
                  ((= CG_W2CODE "Z")(##MODE123 0 1 1))
                  ((= CG_W2CODE "L")
                    (if (= &CutId 0)
                      (##MODE123 0 0 1) ; L型ｶｯﾄなし 01/08/27 YM MOD
                      (##MODE123 0 0 1) ; L型ｶｯﾄあり
                    );_if
                  )
                  ((= CG_W2CODE "U")(##MODE123 0 0 0))
                  (T (##MODE123 0 0 0))
                );_cond
                (##FG_SEIGYO) ; 前垂れﾗｼﾞｵ制御
              )
              (progn ; 断面共通
                (if (equal (nth 3 #rec$) 1 0.1)
                  (setq #flg1 "1") ; BGあり
                  (setq #flg1 "0") ; BGなし
                );_if
                (if (= #flg1 "1")
                  (setq #flg2 "1") ; BGあり==>前垂れ前側
                  (if (equal (nth 6 #rec$) 1 0.1)
                    (setq #flg2 "1") ; 前垂れ前側
                    (setq #flg2 "0") ; 前垂れ両側
                  )
                );_if

                (##SET123 #flg1 #flg2 #flg1 #flg2 #flg1 #flg2) ; ﾗｼﾞｵﾎﾞﾀﾝｾｯﾄ
                (set_tile "WT_EXT1" "0") ; 1枚目WT奥行拡張
                (set_tile "WT_EXT2" "0") ; 2枚目WT奥行拡張
                (set_tile "WT_EXT3" "0") ; 3枚目WT奥行拡張
                (##MODE123 1 1 1) ; ﾗｼﾞｵﾎﾞﾀﾝﾓｰﾄﾞ変更(全て使用不可)
              )
            );_if

          )
        );_cond

;03/11/27 YM ｱｲﾌﾙﾎｰﾑ対応 MOD-E

;03/11/27 YM MOD ｱｲﾌﾙﾎｰﾑ対応
;;;       ;03/10/14 YM ADD
;;;       (setq #FullFlat (nth 12 #rec$))
;;;       (if (or (equal #FullFlat  2 0.1)(equal #FullFlat  3 0.1)
;;;               (equal #FullFlat 22 0.1)(equal #FullFlat 33 0.1))
;;;         (progn ;ﾌﾙﾌﾗｯﾄ初期値定義
;;;           (set_tile "rad2" "1")
;;;            (mode_tile "BGradio1" 1)
;;;            (mode_tile "FGradio1" 1)
;;;           (set_tile "WT_EXT1" "410")
;;;         )
;;;         (progn
;;;
;;;           (if (= (get_tile "rad2") "1")
;;;             (progn ; 個別設定
;;;               (cond ; 使用ﾓｰﾄﾞ制御
;;;                 ((= CG_W2CODE "Z")(##MODE123 0 1 1))
;;;                 ((= CG_W2CODE "L")
;;;                   (if (= &CutId 0)
;;;;;;01/08/27YM@                     (##MODE123 0 1 1) ; L型ｶｯﾄなし
;;;                     (##MODE123 0 0 1) ; L型ｶｯﾄなし 01/08/27 YM MOD
;;;                     (##MODE123 0 0 1) ; L型ｶｯﾄあり
;;;                   );_if
;;;                 )
;;;                 ((= CG_W2CODE "U")(##MODE123 0 0 0))
;;;                 (T (##MODE123 0 0 0))
;;;               );_cond
;;;               (##FG_SEIGYO) ; 前垂れﾗｼﾞｵ制御
;;;             )
;;;             (progn ; 断面共通
;;;               (if (equal (nth 3 #rec$) 1 0.1)
;;;                 (setq #flg1 "1") ; BGあり
;;;                 (setq #flg1 "0") ; BGなし
;;;               );_if
;;;               (if (= #flg1 "1")
;;;                 (setq #flg2 "1") ; BGあり==>前垂れ前側
;;;                 (if (equal (nth 6 #rec$) 1 0.1)
;;;                   (setq #flg2 "1") ; 前垂れ前側
;;;                   (setq #flg2 "0") ; 前垂れ両側
;;;                 )
;;;               );_if
;;;
;;;               (##SET123 #flg1 #flg2 #flg1 #flg2 #flg1 #flg2) ; ﾗｼﾞｵﾎﾞﾀﾝｾｯﾄ
;;;               (set_tile "WT_EXT1" "0") ; 1枚目WT奥行拡張
;;;               (set_tile "WT_EXT2" "0") ; 2枚目WT奥行拡張
;;;               (set_tile "WT_EXT3" "0") ; 3枚目WT奥行拡張
;;;               (##MODE123 1 1 1) ; ﾗｼﾞｵﾎﾞﾀﾝﾓｰﾄﾞ変更(全て使用不可)
;;;             )
;;;           );_if
;;;
;;;         )
;;;       );_if

            (princ)
          );##open
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( / dum$$)

						;2011/09/18 YM ADD-S &ZaiCode 現在の材質で絞り込む
						;表示可能断面IDを【WT材質】から取得する
					  (setq #Qry_zai$
					    (CFGetDBSQLRec CG_DBSESSION "WT材質"
					      (list
					        (list "材質記号" &ZaiCode 'STR)
					      )
					    )
					  )
						;断面IDﾘｽﾄ
						;;;	(setq #danmenID$ (StrParse (nth 7 (car #Qry_zai$)) ","))
						(setq #danmenID (nth 7 (car #Qry_zai$)))
						;2011/09/18 YM ADD-E &ZaiCode 現在の材質で絞り込む

            (start_list "dan1" 3)
						(setq dum$$ nil)
            (foreach #Qry$ #Qry$$
							(if (wcmatch (nth 0 #Qry$) #danmenID)
								(progn
              		(add_list (nth 1 #Qry$))
									(setq dum$$ (append dum$$ (list #Qry$)))
								)
							);_if
            )
						(setq #Qry$$ dum$$);絞り込んだものに置き換える
            (end_list)
            (set_tile "dan1" "0") ; 最初にﾌｫｰｶｽ
            (##Addtext)
            (princ)
          );##Addpop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 選択中の断面ﾘｽﾄに従ってWT情報ﾃｷｽﾄ表示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addtext ( /  #dum1 #dum2)
            (setq #rec$ (nth (atoi (get_tile "dan1")) #Qry$$)) ; 現在選択断面ﾚｺｰﾄﾞ
            (set_tile "text11" (itoa (fix (+ (nth 2  #rec$))))) ; ﾜｰｸﾄｯﾌﾟ厚み
            (set_tile "text22" (itoa (fix (+ (nth 4  #rec$))))) ; ﾊﾞｯｸｶﾞｰﾄﾞ高さ
            (set_tile "text33" (itoa (fix (+ (nth 5  #rec$))))) ; ﾊﾞｯｸｶﾞｰﾄﾞ厚み
            (set_tile "text44" (itoa (fix (+ (nth 7  #rec$))))) ; 前垂れ高さ
            (set_tile "text55" (itoa (fix (+ (nth 8  #rec$))))) ; 前垂れ厚み
            (set_tile "text66" (itoa (fix (+ (nth 9  #rec$))))) ; 前垂れｼﾌﾄ

            (if (equal (nth  3  #rec$) 0 0.1)(setq #dum1 "ﾊﾞｯｸｶﾞｰﾄﾞなし"))
            (if (equal (nth  3  #rec$) 1 0.1)(setq #dum1 "ﾊﾞｯｸｶﾞｰﾄﾞあり"))

            (if (equal (nth  6  #rec$) 1 0.1)(setq #dum2 "前側のみ"))
            (if (equal (nth  6  #rec$) 2 0.1)(setq #dum2 "両側"))

            (set_tile "text77" #dum1) ; ﾊﾞｯｸｶﾞｰﾄﾞ有無
            (set_tile "text88" #dum2) ; 前垂れﾀｲﾌﾟ

            ;03/10/14 YM ADD
            (setq #FullFlat (nth 12 #rec$))

;07/07/11 YM MOD ｸﾘｴｽﾀﾌﾗｯﾄD=880対応
            (cond
              ((or (equal #FullFlat  2 0.1)(equal #FullFlat  3 0.1)
                    (equal #FullFlat 22 0.1)(equal #FullFlat 33 0.1))
              ;ﾌﾙﾌﾗｯﾄ初期値定義
                (set_tile "rad2" "1")
                (##open)
                (mode_tile "BGradio1" 1)
                (mode_tile "FGradio1" 1)
;-- 2011/08/25 A.Satoh Mod - S
;                (set_tile "WT_EXT1" "410")
                (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
              )

              ((or (equal #FullFlat 82 0.1)(equal #FullFlat 83 0.1))
              ;ﾌﾙﾌﾗｯﾄ初期値定義
                (set_tile "rad2" "1")
                (##open)
                (mode_tile "BGradio1" 1)
                (mode_tile "FGradio1" 1)
;-- 2011/08/25 A.Satoh Mod - S
;                (set_tile "WT_EXT1" "230")
                (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
              )

              (T  ;ﾌﾙﾌﾗｯﾄ以外初期値定義
                (set_tile "rad1" "1")
;-- 2011/08/25 A.Satoh Mod - S
;                (set_tile "WT_EXT1" "0")
                (set_tile "WT_EXT1" (rtos (nth 10 #rec$)))
;-- 2011/08/25 A.Satoh Mod - E
                (##open)
              )
            );_cond


;07/07/11 YM MOD ｸﾘｴｽﾀﾌﾗｯﾄD=880対応
;;;           (if (or (equal #FullFlat  2 0.1)(equal #FullFlat  3 0.1)
;;;                   (equal #FullFlat 22 0.1)(equal #FullFlat 33 0.1))
;;;             (progn ;ﾌﾙﾌﾗｯﾄ初期値定義
;;;               (set_tile "rad2" "1")
;;;               (##open)
;;;               (mode_tile "BGradio1" 1)
;;;               (mode_tile "FGradio1" 1)
;;;               (set_tile "WT_EXT1" "410")
;;;             )
;;;             (progn ;ﾌﾙﾌﾗｯﾄ以外初期値定義
;;;               (set_tile "rad1" "1")
;;;               (set_tile "WT_EXT1" "0")
;;;               (##open)
;;;             )
;;;           );_if



            (princ)
          );##Addtext
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; BG有無による前垂れ選択肢制御 BGあり==>両面前垂れ不可
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##FG_SEIGYO ( / )
            (if (= (get_tile "BGradio1-1") "1") ; 1枚目BG有無
              (progn ; BGあり
                (set_tile  "FGradio1-1" "1") ; 1枚目FGﾀｲﾌﾟ前側
                (mode_tile "FGradio1-2" 1)   ; 使用不可
;;;               (mode_tile "FGradio1-3" 1)   ; 使用不可
;;;               (mode_tile "FGradio1-4" 1)   ; 使用不可
              )
              (progn
                (mode_tile "FGradio1-2" 0)   ; 使用可
;;;               (mode_tile "FGradio1-3" 0)   ; 使用可
;;;               (if (or (= CG_W2CODE "Z") ; I型 or L型ｶｯﾄなし
;;;                       (and (= CG_W2CODE "L")(= &CutId 0)))
;;;                 (mode_tile "FGradio1-4" 0)   ; 使用可
;;;                 (mode_tile "FGradio1-4" 1)   ; 使用不可
;;;               );_if
              )
            );_if
            (if (= (get_tile "BGradio2-1") "1") ; 2枚目BG有無
              (progn
                (set_tile  "FGradio2-1" "1") ; 1枚目FGﾀｲﾌﾟ前側
                (mode_tile "FGradio2-2" 1)   ; 使用不可
;;;               (mode_tile "FGradio2-3" 1)   ; 使用不可
              )
              (progn
                (mode_tile "FGradio2-2" 0)   ; 使用可
;;;               (if (= CG_W2CODE "U")
;;;                 (mode_tile "FGradio2-3" 1) ; 使用不可
;;;                 (mode_tile "FGradio2-3" 0) ; 使用可
;;;               );_if
              )
            );_if
            (if (= (get_tile "BGradio3-1") "1") ; 3枚目BG有無
              (progn
                (set_tile  "FGradio3-1" "1") ; 1枚目FGﾀｲﾌﾟ前側
                (mode_tile "FGradio3-2" 1)   ; 使用不可
;;;               (mode_tile "FGradio3-3" 1)   ; 使用不可
              )
              (progn
                (mode_tile "FGradio3-2" 0)   ; 使用可
;;;               (mode_tile "FGradio3-3" 0)   ; 使用可
              )
            );_if
            (princ)
          );##FG_SEIGYO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #Qry$$
    (DBSqlAutoQuery CG_DBSESSION "select * from WT断面")
  )
  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "DanmenDlg" #dcl_id)) (exit))
  ;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
  (##Addpop)

  ;;; 初期設定
  (set_tile "rad1" "1") ; 初期はﾗｼﾞｵ="断面共通"
  (##open) ; 個別設定(ﾀﾞｲｱﾛｸﾞ右側)の制御

; ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "rad"  "(##open))") ; 断面共通rad1,個別rad2
  (action_tile "dan1" "(##Addtext))")
  (action_tile "accept" "(setq #dan$$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #dan$$ nil) (done_dialog)")
  (action_tile "BGradio1" "(##FG_SEIGYO))"); 前垂れﾀｲﾌﾟ選択制御
  (action_tile "BGradio2" "(##FG_SEIGYO))"); 前垂れﾀｲﾌﾟ選択制御
  (action_tile "BGradio3" "(##FG_SEIGYO))"); 前垂れﾀｲﾌﾟ選択制御
  (start_dialog)
  (unload_dialog #dcl_id)
  #dan$$
);PKW_DanmenDlg




;↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
;↓↓↓　以下ミカド版特注ｷｬﾋﾞｺﾏﾝﾄﾞ ↓↓↓
;<HOM>*************************************************************************
; <関数名>    : C:StretchCab
; <処理概要>  : キャビネット伸縮処理
; <戻り値>    : なし
; <作成>      : 00/04/07 MH
; <備考>      :
;*************************************************************************>MOH<
(defun C:StretchCabM (
  /
  #en #Gen #LXD$ #XD$ #sys$
  )

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
      (defun TempErr ( msg / #msg )
        (setq CG_TOKU nil)
        (setq CG_TOKU_BW nil)
        (setq CG_TOKU_BD nil)
        (setq CG_TOKU_BH nil)
        (KP_TOKU_GROBAL_RESET)
        (setq CG_BASE_UPPER nil)
        (command "_undo" "b")
        (setq *error* nil)
        (princ)
      )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

  ; 前処理
  (setq *error* TempErr)
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")

  (setq #sys$ (PKStartCOMMAND))
  (CFCmdDefBegin 6)
  (setq CG_TOKU T)
  (KP_TOKU_GROBAL_RESET)
  (setq CG_BASE_UPPER nil)

  (setq #en 'T)
  (while #en
    (setq #Gen nil)
    (setq #en (car (entsel "\n処理対象のキャビネットを選択 : ")))
    (if #en (setq #Gen (CFSearchGroupSym #en)))
    (if (and #en (not #Gen)) (CFAlertMsg "この図形は処理対象にできません"))
    (if #Gen
      (progn
        (setq #LXD$ (CFGetXData #Gen "G_LSYM"))
        (setq #XD$ (CFGetXData #Gen "G_SYM"))
        (cond
          ((CFGetXData #Gen "G_KUTAI")
            nil
          )

          ;;; キャビネット伸縮実行
          (t (PcStretchCab #Gen)(setq #en nil))
        ); cond
      )
    ) ; progn if
  );while

;;;02/04/23YM@DEL ); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
;;;02/04/23YM@DEL);_if

  ; 後処理
  (setq *error* nil)
  (CFCmdDefFinish);00/09/07 SN MOD
  (PKEndCOMMAND #sys$)
  (setq CG_TOKU nil)
  (setq CG_TOKU_BW nil)
  (setq CG_TOKU_BD nil)
  (setq CG_TOKU_BH nil)
;;;01/09/25YM@DEL (setq CG_DOOR_MOVE nil) ; 01/05/31 YM ADD
  ; 01/09/25 YM ADD-S
  (KP_TOKU_GROBAL_RESET)
  ; 01/09/25 YM ADD-E

  (setq CG_BASE_UPPER nil); 01/08/20 YM ADD
  (princ)

); C:StretchCab

;<HOM>*************************************************************************
; <関数名>    : PcStretchCab
; <処理概要>  : キャビネット伸縮処理
; <戻り値>    : なし
; <作成>      : 00/04/07 MH 01/01/27 YM ﾌﾞﾚｰｸﾗｲﾝなしでもOKに改造
; <備考>      : ｼﾝﾎﾞﾙ上付きの場合考慮 01/02/21 YM
;*************************************************************************>MOH<
(defun PcStretchCab (
  &en ; 伸縮対象ｼﾝﾎﾞﾙ図形
  /
  #DLOG$ #sym #LXD$ #XD$ #WDH$ #ss #bsym
  #ANG #BRKD #BRKH #BRKW #EDELBRK_D$ #EDELBRK_H$ #EDELBRK_W$ #GNAM
  #PT #XLINE_D #XLINE_H #XLINE_W #HINBAN #RET$ #flg #CNTZ #FHMOV
  #LR #ORG_PRICE #QRY$ #userHINBAN
  #DBASE #RZ #SBIKOU #SHINMEI ; 01/08/20 YM ADD ﾚﾝｼﾞ高さ方向伸縮不具合
  #USERBIKOU #USERHINMEI ; 03/07/17 YM ADD
  #hinban$ #cannot$ #dlg #mp #eD$
  )
  (setq #flg nil) ; 伸縮処理をしない=T
  (setq #sym &en)

;;;  ;↓↓↓ 05/03/31 SZ ADD ↓↓↓
;;;  ;ERRMSG.INIの[BREAKLINE]項目を取得
;;;  (setq #hinban$ (CFgetini "BREAKLINE" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
;;;  (if (strp #hinban$) (setq #hinban$ (strparse #hinban$ ",")))
;;;  (setq #cannot$ (CFgetini "BREAKLINE" "0002" (strcat CG_SKPATH "ERRMSG.INI")))
;;;  (if (strp #cannot$) (setq #cannot$ (strparse #cannot$ ",")))
;;;  ;↑↑↑ 05/03/31 SZ ADD ↑↑↑

  ; 01/08/20 YM ADD-S
  (setq #dBASE (cdr (assoc 10 (entget #sym)))) ; ｼﾝﾎﾞﾙ位置
  (setq #rZ (caddr #dBASE)) ; 取付け高さ
  (if (= #rZ nil)(setq #rZ 0.0))
  ; 01/08/20 YM ADD-E
  (setq #LXD$ (CFGetXData #sym "G_LSYM"))
  (setq #HINBAN (nth 5 #LXD$))
  (setq #LR     (nth 6 #LXD$))
  (setq #XD$  (CFGetXData #sym "G_SYM" ))
  ; 01/08/20 YM ADD-S
  (if (> 0 (nth 10 #XD$)) ; ｼﾝﾎﾞﾙが上付き===>T,下つき=nil
    (setq CG_BASE_UPPER T) ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中のｸﾞﾛｰﾊﾞﾙ
  );_if
  ; 01/08/20 YM ADD-E

  (setq #eDelBRK_W$ (PcRemoveBreakLine #sym "W")) ; W方向ブレーク除去
  (setq #eDelBRK_D$ (PcRemoveBreakLine #sym "D")) ; D方向ブレーク除去
  (setq #eDelBRK_H$ (PcRemoveBreakLine #sym "H")) ; H方向ブレーク除去
  (setq #pt  (cdr (assoc 10 (entget #sym))))      ; ｼﾝﾎﾞﾙ基準点
  (setq #ANG (nth 2 #LXD$))                       ; ｼﾝﾎﾞﾙ配置角度
  (setq #gnam (SKGetGroupName #sym))              ; ｸﾞﾙｰﾌﾟ名

;;; ;伸縮不可品番 05/03/31 ADD SZ
;;; (if (member #hinban #cannot$)
;;;   (progn
;;;     (CFAlertMsg "この図形は処理対象にできません")
;;;     (exit)
;;;   )
;;; )

;;; ｷｬﾋﾞ価格を検索
;;;01/08/20YM@  (setq #ORG_price (KPGetPrice #HINBAN #LR)) ; 戻り値追加
  ; 01/08/20 YM MOD-S
  (setq #ret$ (KPGetPrice #HINBAN #LR))
  (setq #ORG_price (nth 0 #ret$))
  (setq #sHINMEI   (nth 1 #ret$)) ; 品名
  (setq #sBIKOU    (nth 2 #ret$)) ; 備考
  ; 01/08/20 YM MOD-E

  ; 図形色を変更
  (setq #ss (CFGetSameGroupSS #sym))
  (command "_change" #ss "" "P" "C" CG_InfoSymCol "")

  ; W,D,H
  (setq #WDH$ (list (nth 3 #XD$) (nth 4 #XD$) (nth 5 #XD$)))

;;; (if (not (member #hinban #hinban$))
;;;   (progn
      ;ユーザ設定ダイアログ
      (setq #dlg T) ;フラグON
      (setq #DLOG$ (PcGetStretchCabInfoDlg #WDH$))
      (if (not #DLOG$) (quit))
      ;ブレークライン位置取得
      (setq #BrkW (nth 3 #DLOG$))
      (setq #BrkD (nth 4 #DLOG$))
      (if CG_BASE_UPPER
        ;上基点
        (setq #BrkH (- (+ (nth 5 #DLOG$) #rZ) (nth 5 #XD$))) ;シンボル取付高さを考慮
        ;下基点
        (setq #BrkH (nth 5 #DLOG$))
      );if
;;;   )
;;;   ;else
;;;   ;ブレークラインを除去しない場合あり 05/03/31 ADD SZ
;;;   ;※ERRMSG.INI設定済の図形(洗面ラウンドタイプ天板等)
;;;   (progn
;;;     ;ブレークラインの復活
;;;     (foreach #eD$ (list #eDelBRK_W$ #eDelBRK_D$ #eDelBRK_H$)
;;;       (foreach #eD #eD$ (if (= (entget #eD) nil) (entdel #eD)))
;;;     )
;;;     ;ブレークラインを基点から近い順にソートする
;;;     (setq #eDelBRK_W$ (reverse (SKESortBreakLine (list 0 #eDelBRK_W$) #pt)))
;;;     (setq #eDelBRK_D$ (reverse (SKESortBreakLine (list 1 #eDelBRK_D$) #pt)))
;;;     (setq #eDelBRK_H$ (reverse (SKESortBreakLine (list 2 #eDelBRK_H$) #pt)))
;;;     ;ユーザ選択->伸縮後の値リストを取得
;;;     (setq #DLOG$
;;;       (list
;;;         (UserSelectBreakLine "W" (car   #WDH$) #eDelBRK_W$)
;;;         (UserSelectBreakLine "D" (cadr  #WDH$) #eDelBRK_D$)
;;;         (UserSelectBreakLine "H" (caddr #WDH$) #eDelBRK_H$)
;;;       )
;;;     )
;;;   )
;;; );if

;;;01/09/25YM@DEL (setq CG_TOKU_BW #BrkW)
;;;01/09/25YM@DEL (setq CG_TOKU_BD #BrkD)
;;;01/09/25YM@DEL (setq CG_TOKU_BH #BrkH)

;;;01/02/27YM@  ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
;;;01/02/27YM@  (setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))
;;;01/02/27YM@  (setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))
;;;01/02/27YM@  (setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))
;;;01/02/27YM@  (CFSetXData #XLINE_W "G_BRK" (list 1))
;;;01/02/27YM@  (CFSetXData #XLINE_D "G_BRK" (list 2))
;;;01/02/27YM@  (CFSetXData #XLINE_H "G_BRK" (list 3))
;;;01/02/27YM@  ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
;;;01/02/27YM@  (command "-group" "A" #gnam #XLINE_W "")
;;;01/02/27YM@  (command "-group" "A" #gnam #XLINE_D "")
;;;01/02/27YM@  (command "-group" "A" #gnam #XLINE_H "")

  ; 伸縮実行
  (if (or (not (equal (car   #WDH$) (car   #DLOG$) 0.1))
          (not (equal (cadr  #WDH$) (cadr  #DLOG$) 0.1))
          (not (equal (caddr #WDH$) (caddr #DLOG$) 0.1)))
    (progn
      (setq #flg T) ; 伸縮処理をする

      (if #dlg ; 05/03/31 ADD SZ
        (progn
          ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
          (setq #XLINE_W (PK_MakeBreakW #pt #ANG #BrkW))
          (setq #XLINE_D (PK_MakeBreakD #pt #ANG #BrkD))
          (setq #XLINE_H (PK_MakeBreakH #pt      #BrkH))
          (CFSetXData #XLINE_W "G_BRK" (list 1))
          (CFSetXData #XLINE_D "G_BRK" (list 2))
          (CFSetXData #XLINE_H "G_BRK" (list 3))
          ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
          (command "-group" "A" #gnam #XLINE_W "")
          (command "-group" "A" #gnam #XLINE_D "")
          (command "-group" "A" #gnam #XLINE_H "")
        )
      )

;;;      (SKY_Stretch_Parts #sym (car #DLOG$) (cadr #DLOG$) (caddr #DLOG$))
      (setq #fHmov (- (caddr #DLOG$) (nth 5 #XD$)))
; 01/02/27 YM MOD
      (if (not (equal (car #DLOG$)  (nth 3 #XD$) 0.0001)) ; W
        (progn
          (setq CG_TOKU_BW #BrkW)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH nil)
          (SKY_Stretch_Parts #sym (car #DLOG$) (nth 4 #XD$) (nth 5 #XD$))

          (if #dlg ; 05/03/31 ADD SZ
            (progn
              ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
              (entdel #XLINE_W)
              ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
              (foreach #eD #eDelBRK_W$
                (if (= (entget #eD) nil) (entdel #eD)) ;W方向ブレーク復活
              );for
            )
            ;else ↓ 05/03/31 ADD SZ
            (progn
              (setq #eD$ nil)
              ;W方向ブレーク復活
              (foreach #eD #eDelBRK_W$
                (if (= (entget #eD) nil)
                  (entdel #eD)
                  ;else
                  (setq #eD$ (append #eD$ (list #eD)))
                )
              );for
              ;ブレークラインの移動後の座標を求める
              (cond
                ;★★★ブレークラインが２個以上ユーザ選択された場合は、未だ中途半端な対応
                ((< 1 (length #eD$))
                  ;差分伸縮値の半分の値で移動する
                  (setq #mp (list (fix (* 0.5 (- (car #DLOG$) (car #WDH$)))) 0 0))
                  ;W方向ブレーク移動
                  (foreach #eD #eDelBRK_W$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;ユーザ選択ブレークラインが１つで、最も基点寄りの場合
                ((and (= 1 (length #eD$)) (equal (car #eD$) (car #eDelBRK_W$)))
                  ;差分伸縮値そのままの値で移動する
                  (setq #mp (list (fix (- (car #DLOG$) (car #WDH$))) 0 0))
                  ;W方向ブレーク移動
                  (foreach #eD #eDelBRK_W$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;ユーザ選択ブレークラインが１つで、最も基点から遠い場合
                ((and (= 1 (length #eD$)) (equal (car #eD$) (last #eDelBRK_W$)))
                  ;移動しない
                )
                ;その他の場合
                (T
                  ;移動しない
                )
              );cond
            )
          );if

          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      ; 01/09/25 YM ADD-S
      (KP_TOKU_GROBAL_RESET)
      ; 01/09/25 YM ADD-E

      (if (not (equal (cadr #DLOG$) (nth 4 #XD$) 0.0001)) ; D
        (progn
          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD #BrkD)
          (setq CG_TOKU_BH nil)
          (SKY_Stretch_Parts #sym (car #DLOG$) (cadr #DLOG$) (nth 5 #XD$))

          (if #dlg ; 05/03/31 ADD SZ
            (progn
              ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
              (entdel #XLINE_D)
              ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
              (foreach #eD #eDelBRK_D$
                (if (= (entget #eD) nil) (entdel #eD)) ;D方向ブレーク復活
              );for
            )
            ;else ↓ 05/03/31 ADD SZ
            (progn
              (setq #eD$ nil)
              ;D方向ブレーク復活
              (foreach #eD #eDelBRK_D$
                (if (= (entget #eD) nil)
                  (entdel #eD)
                  ;else
                  (setq #eD$ (append #eD$ (list #eD)))
                )
              );for
              ;ブレークラインの移動後の座標を求める
              (cond
                ;★★★ブレークラインが２個以上ユーザ選択された場合は、未だ中途半端な対応
                ((< 1 (length #eD$))
                  ;差分伸縮値の半分の値で移動する
                  (setq #mp (list 0 (fix (* 0.5 (- (cadr #DLOG$) (cadr #WDH$)))) 0))
                  ;D方向ブレーク移動
                  (foreach #eD #eDelBRK_D$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;ユーザ選択ブレークラインが１つで、最も基点寄りの場合
                ((and (= 1 (length #eD$)) (equal (car #eD$) (car #eDelBRK_D$)))
                  ;差分伸縮値そのままの値で移動する
                  (setq #mp (list 0 (fix (- (cadr #DLOG$) (cadr #WDH$))) 0))
                  ;D方向ブレーク移動
                  (foreach #eD #eDelBRK_D$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;ユーザ選択ブレークラインが１つで、最も基点から遠い場合
                ((and (= 1 (length #eD$)) (equal (car #eD$) (last #eDelBRK_D$)))
                  ;移動しない
                )
                ;その他の場合
                (T
                  ;移動しない
                )
              );cond
            )
          );if

          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

      ; 01/09/25 YM ADD-S
      (KP_TOKU_GROBAL_RESET)
      ; 01/09/25 YM ADD-E

      (if (not (equal (caddr #DLOG$)(nth 5 #XD$) 0.0001)) ; H
        (progn
          (setq CG_TOKU_BW nil)
          (setq CG_TOKU_BD nil)
          (setq CG_TOKU_BH #BrkH)
          (SKY_Stretch_Parts #sym (car #DLOG$) (cadr #DLOG$) (caddr #DLOG$))

          (if #dlg ; 05/03/31 ADD SZ
            (progn
              ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
              (entdel #XLINE_H)
              ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
              (foreach #eD #eDelBRK_H$
                (if (= (entget #eD) nil) (entdel #eD)) ;H方向ブレーク復活
              );for
            )
            ;else ↓ 05/03/31 ADD SZ
            (progn
              (setq #eD$ nil)
              ;H方向ブレーク復活
              (foreach #eD #eDelBRK_H$
                (if (= (entget #eD) nil)
                  (entdel #eD)
                  ;else
                  (setq #eD$ (append #eD$ (list #eD)))
                )
              );for
              ;ブレークラインの移動後の座標を求める
              (cond
                ;★★★ブレークラインが２個以上ユーザ選択された場合は、未だ中途半端な対応
                ((< 1 (length #eD$))
                  ;差分伸縮値の半分の値で移動する
                  (setq #mp (list 0 0 (fix (* 0.5 (- (caddr #DLOG$) (caddr #WDH$))))))
                  ;H方向ブレーク移動
                  (foreach #eD #eDelBRK_H$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;ユーザ選択ブレークラインが１つで、最も基点寄りの場合
                ((and (= 1 (length #eD$)) (equal (car #eD$) (car #eDelBRK_H$)))
                  ;差分伸縮値そのままの値で移動する
                  (setq #mp (list 0 0 (fix (- (caddr #DLOG$) (caddr #WDH$)))))
                  ;H方向ブレーク移動
                  (foreach #eD #eDelBRK_H$
                    (command "move" #eD "" '(0 0 0) #mp)
                  );for
                )
                ;ユーザ選択ブレークラインが１つで、最も基点から遠い場合
                ((and (= 1 (length #eD$)) (equal (car #eD$) (last #eDelBRK_H$)))
                  ;移動しない
                )
                ;その他の場合
                (T
                  ;移動しない
                )
              );cond
            )
          );if

          (PCD_MakeViewAlignDoor (list #sym) 3 T)
        )
      );_if

;;;01/09/25YM@DEL     ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
;;;01/09/25YM@DEL     (entdel #XLINE_W)
;;;01/09/25YM@DEL     (entdel #XLINE_D)
;;;01/09/25YM@DEL     (entdel #XLINE_H)
;;;01/09/25YM@DEL     ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
;;;01/09/25YM@DEL     (foreach #eD #eDelBRK_W$ (entdel #eD)) ; W方向ブレーク復活
;;;01/09/25YM@DEL     (foreach #eD #eDelBRK_D$ (entdel #eD)) ; D方向ブレーク復活
;;;01/09/25YM@DEL     (foreach #eD #eDelBRK_H$ (entdel #eD)) ; H方向ブレーク復活

;;;01/09/25YM@DEL     (PCD_MakeViewAlignDoor (list #sym) 3 T)

; 展開図作成時に行わないと意味がないので下の処理は止めた
;;;01/03/12YM@      (setq CG_OUTCMDNAME "SCFMakeMaterial") ; 01/03/11 YM ADD 2D-PMEN7に画層"0_door"で扉を張るため
;;;01/03/12YM@      (PCD_MakeViewAlignDoor (list #sym) 2 nil)
;;;01/03/12YM@      (setq CG_OUTCMDNAME nil) ; 01/03/11 YM ADD
;;;01/03/12YM@      (command "_layer" "OFF" "0_door" "") ; 画層 "0_door" 非表示
    )
    (progn ; 処理しない
      (setq #flg T) ; 伸縮処理をしない  ; 品番のみ変えるときのため終了しない
;;;01/04/06YM@      (setq #flg nil) ; 伸縮処理をしない

;;;01/04/06YM@      (CFAlertMsg "\n伸縮しませんでした。")
      (princ "\n伸縮しませんでした。")
    )
  ); end of if

  ;色を戻す
  (command "_change" #ss "" "P" "C" "BYLAYER" "")

;;;01/02/27YM@  ;;; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
;;;01/02/27YM@  (entdel #XLINE_W)
;;;01/02/27YM@  (entdel #XLINE_D)
;;;01/02/27YM@  (entdel #XLINE_H)
;;;01/02/27YM@  ;;; 元のﾌﾞﾚｰｸﾗｲﾝ復活
;;;01/02/27YM@  (foreach #eD #eDelBRK_W$ (entdel #eD)) ; W方向ブレーク復活
;;;01/02/27YM@  (foreach #eD #eDelBRK_D$ (entdel #eD)) ; D方向ブレーク復活
;;;01/02/27YM@  (foreach #eD #eDelBRK_H$ (entdel #eD)) ; H方向ブレーク復活
;;;  (command "._shademode" "H") ; 隠線処理 解除(ｽﾋﾟｰﾄﾞｱｯﾌﾟ)07/07 YM ADD

  ;;; 01/02/21 YM ADD
  ; 上基点でH方向伸縮のあったアイテムは伸縮分H方向に移動 01/02/02 MH ADD
  ; この処理要らない？？？
;;;01/02/27YM@  (if (and (not (equal 0 #fHmov 0.1)) (= -1 (nth 10 (CFGetXData #sym "G_SYM"))))
;;;01/02/27YM@    (progn
;;;01/02/27YM@      ; 移動先点のZ値を取得
;;;01/02/27YM@      (setq #cntZ (- (caddr #pt) #fHmov))
;;;01/02/27YM@      (command "_move" (CFGetSameGroupSS #sym) "" #pt
;;;01/02/27YM@        (list (car #pt) (cadr #pt) #cntZ))
;;;01/02/27YM@    ); progn
;;;01/02/27YM@  ); if

  ;基準ｱｲﾃﾑの場合は基準ｱｲﾃﾑ色にする。
  (if (and (setq #bsym (car (CFGetXRecord "BASESYM")))
           (equal (handent #bsym) #sym))
    (progn
      (ResetBaseSym)
      (GroupInSolidChgCol #sym CG_BaseSymCol)
    )
  );_if

  ;;; 確認ﾀﾞｲｱﾛｸﾞ
  (if #flg
    (progn
      (setq #ret$
        (ShowTOKUCAB_Dlog

          (if (= #LR "Z") ; 01/06/27 YM ADD LR追加
            (strcat "ﾄｸ" #HINBAN) ; 品番
            (strcat "ﾄｸ" #HINBAN #LR) ; 品番
          );_if

;;;01/06/27YM@          (strcat "ﾄｸ" #HINBAN )
          "0"
          (list (nth 0 #DLOG$)(nth 1 #DLOG$)(nth 2 #DLOG$))
          #ORG_price ; 元の価格
          #sHINMEI ; 品名 01/08/20 YM ADD
          #sBIKOU  ; 備考 01/08/20 YM ADD
        )
      ); 品番,価格

      (if (= nil #ret$)
        (quit)
      );_if

      ; 全角ｽﾍﾟｰｽを半角ｽﾍﾟｰｽに置きかえる 01/06/27 YM ADD
      (setq #userHINBAN (vl-string-subst "  " "　" (nth 0 #ret$))) ; ﾕｰｻﾞｰ入力品番
      ; 03/06/19 YM ADD-S
      (setq #userHINMEI (nth 2 #ret$)) ; ﾕｰｻﾞｰ入力品名
      (setq #userBIKOU  (nth 3 #ret$)) ; ﾕｰｻﾞｰ入力備考
      ; 03/06/19 YM ADD-E

      ;;; ダイアログから獲得されたリストを特注キャビ拡張データに格納
      (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))
      (CFSetXData #sym "G_TOKU"
        (list
          #userHINBAN   ; ﾕｰｻﾞｰ入力品番
          (nth 1 #ret$) ; 価格
          (list (nth 0 #DLOG$)(nth 1 #DLOG$)(nth 2 #DLOG$))
    ;;;          (strcat (itoa (car #DLOG$)) "X" (itoa (cadr #DLOG$)) "X" (itoa (caddr #DLOG$)))
          1 ; 1:特注ｷｬﾋﾞｺﾏﾝﾄﾞ 0:ｹｺﾐ伸縮
          CG_TOKU_BW ; W ﾌﾞﾚｰｸﾗｲﾝ位置
          CG_TOKU_BD ; D ﾌﾞﾚｰｸﾗｲﾝ位置
          CG_TOKU_BH ; H ﾌﾞﾚｰｸﾗｲﾝ位置
          #HINBAN    ; 品番
          ; 03/06/19 YM ADD-S 品番、価格に加えて品名と備考も保持する
          #userHINMEI   ; 品名(見積明細,仕様表での「名称」)
          #userBIKOU    ; 備考(見積明細での「備考」,仕様表での「仕様」)
          ; 03/06/19 YM ADD-E
        )
      )
    )
  );_if
  (princ)
); PcStretchCab

;<HOM>*************************************************************************
; <関数名>    : PcGetStretchCabInfoDlg
; <処理概要>  : 伸縮キャビネットのサイズと拡張データ内容獲得
; <戻り値>    : 結果リスト
; <作成>      : 00/04/11 MH
; <備考>      : なし
;*************************************************************************>MOH<
(defun  PcGetStretchCabInfoDlg (
  &Defo$
  /
  #dcl_id #iW #iD #iH #iBW #iBD #iBH
  #RES$
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 半角数値かどうか
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
(defun ##GetDlgItem (
  / ; ﾀﾞｲｱﾛｸﾞの結果を取得する
  #RES$
)
  (setq #RES$ (list
    (atoi (get_tile "W"))
    (atoi (get_tile "D"))
    (atoi (get_tile "H"))
    (atoi (get_tile "BW"))
    (atoi (get_tile "BD"))
    (atoi (get_tile "BH")))
  )
  (done_dialog)
  #RES$
);##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; デフォWDH
  (setq #iW  (fix (nth 0 &Defo$)))
  (setq #iD  (fix (nth 1 &Defo$)))
  (setq #iH  (fix (nth 2 &Defo$)))
  (setq #iBW (fix (* #iW 0.5)))
  (setq #iBD (fix (* #iD 0.5)))
  (setq #iBH (fix (* #iH 0.5)))

  ;;; ダイアログの実行部
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (not (new_dialog "GetStretchCabInfoDlg" #dcl_id)) (exit))

  ;;; デフォ文字列の設定
  (set_tile "Msg1" "   対象キャビネット のサイズは")
  (set_tile "Msg2" (strcat "   現在 幅= " (itoa #iW) ", 奥行= " (itoa #iD) ", 高さ= " (itoa #iH) " です"))
  (set_tile "W"  (itoa #iW))
  (set_tile "D"  (itoa #iD))
  (set_tile "H"  (itoa #iH))
  (set_tile "BW" (itoa #iBW))
  (set_tile "BD" (itoa #iBD))
  (set_tile "BH" (itoa #iBH))

  ;;; タイルのリアクション設定 半角実数のﾁｪｯｸ
  (action_tile "W"  "(##CHK_edit \"W\"  (itoa #iW ) 1)")
  (action_tile "D"  "(##CHK_edit \"D\"  (itoa #iD ) 1)")
  (action_tile "H"  "(##CHK_edit \"H\"  (itoa #iH ) 1)")
  (action_tile "BW" "(##CHK_edit \"BW\" (itoa #iBW) 0)")
  (action_tile "BD" "(##CHK_edit \"BD\" (itoa #iBD) 0)")
  (action_tile "BH" "(##CHK_edit \"BH\" (itoa #iBH) 0)")

  (action_tile "accept" "(setq #RES$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #RES$ nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #RES$
);PcGetStretchCabInfoDlg

;<HOM>*************************************************************************
; <関数名>    : ShowTOKUCAB_Dlog
; <処理概要>  : 特注ｷｬﾋﾞｺﾏﾝﾄﾞ価格,品番確認ﾀﾞｲｱﾛｸﾞ
; <戻り値>    : 価格,品番
; <作成>      : 01/01/29 YM
; <備考>      :
; ***********************************************************************************>MOH<
(defun ShowTOKUCAB_Dlog (
  &HINBAN
  &PRICE ; 価格ﾃﾞﾌｫﾙﾄ値
  &WDH
  &ORG_price ; 元の価格
  &sHINMEI ; 品名 01/08/20 YM ADD
  &sBIKOU  ; 備考 01/08/20 YM ADD
  /
  #RESULT$ #SDCLID
  )
;;;02/01/21YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;02/01/21YM@DEL; 半角数値かどうか
;;;02/01/21YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;02/01/21YM@DEL  (defun ##CHK_edit (
;;;02/01/21YM@DEL   &sKEY ; key
;;;02/01/21YM@DEL   &DEF  ; ﾃﾞﾌｫﾙﾄ値
;;;02/01/21YM@DEL   &flg  ; 判定基準ﾌﾗｸﾞ 0:半角数値 , 1:半角数値>0 , 2:nilでない文字列
;;;02/01/21YM@DEL   /
;;;02/01/21YM@DEL   #val
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL   (setq #val (read (get_tile &sKEY)))
;;;02/01/21YM@DEL   (cond
;;;02/01/21YM@DEL     ((and (= &flg 2)(= #val nil))
;;;02/01/21YM@DEL        (alert "文字列を入力して下さい。")
;;;02/01/21YM@DEL        (set_tile &sKEY &DEF)
;;;02/01/21YM@DEL        (mode_tile &sKEY 2)
;;;02/01/21YM@DEL     )
;;;02/01/21YM@DEL     ((= &flg 0)
;;;02/01/21YM@DEL       (if (or (= (type #val) 'INT)
;;;02/01/21YM@DEL               (= (type #val) 'REAL))
;;;02/01/21YM@DEL         (princ) ; 半角実数だった
;;;02/01/21YM@DEL         (progn
;;;02/01/21YM@DEL           (alert "半角実数値を入力して下さい。")
;;;02/01/21YM@DEL           (set_tile &sKEY &DEF)
;;;02/01/21YM@DEL           (mode_tile &sKEY 2)
;;;02/01/21YM@DEL         )
;;;02/01/21YM@DEL       );_if
;;;02/01/21YM@DEL     )
;;;02/01/21YM@DEL     ((= &flg 1)
;;;02/01/21YM@DEL       (if (and (= (type #val) 'INT)
;;;02/01/21YM@DEL                (> #val -0.001)) ; 更に正かどうか調べる(0は不可) ; 02/01/21 YM MOD 0円も可能に
;;;02/01/21YM@DEL;;;02/01/21YM@DEL                 (> #val 0.001)) ; 更に正かどうか調べる(0は不可)
;;;02/01/21YM@DEL         (progn ; 02/01/21 YM ADD
;;;02/01/21YM@DEL           (if (equal 0.0 #val 0.0001)
;;;02/01/21YM@DEL             (progn
;;;02/01/21YM@DEL               (if (CFYesNoDialog "0円でもよろしいですか？") ; 0円のとき
;;;02/01/21YM@DEL                 nil ; OK
;;;02/01/21YM@DEL                 (progn
;;;02/01/21YM@DEL                   (set_tile &sKEY &DEF)
;;;02/01/21YM@DEL                   (mode_tile &sKEY 2)
;;;02/01/21YM@DEL                 )
;;;02/01/21YM@DEL               );_if
;;;02/01/21YM@DEL             )
;;;02/01/21YM@DEL           );_if
;;;02/01/21YM@DEL         ) ; 02/01/21 YM ADD
;;;02/01/21YM@DEL         (progn
;;;02/01/21YM@DEL;;;02/01/21YM@DEL            (alert "0より大きな半角整数値を入力して下さい。")
;;;02/01/21YM@DEL           (alert "0以上の半角整数値を入力して下さい。") ; 02/01/21 YM MOD 0円も可能に
;;;02/01/21YM@DEL           (set_tile &sKEY &DEF)
;;;02/01/21YM@DEL           (mode_tile &sKEY 2)
;;;02/01/21YM@DEL         )
;;;02/01/21YM@DEL       );_if
;;;02/01/21YM@DEL     )
;;;02/01/21YM@DEL    );_cond
;;;02/01/21YM@DEL   (princ)
;;;02/01/21YM@DEL  );##CHK_edit
;;;02/01/21YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;02/01/21YM@DEL   (defun ##GetDlgItem (
;;;02/01/21YM@DEL     / ; ﾀﾞｲｱﾛｸﾞの結果を取得する
;;;02/01/21YM@DEL     #RES$
;;;02/01/21YM@DEL     )
;;;02/01/21YM@DEL     (setq #RES$
;;;02/01/21YM@DEL       (list
;;;02/01/21YM@DEL         (get_tile "edtTOKU_ID")         ; 品番
;;;02/01/21YM@DEL         (atof (get_tile "edtTOKU_PRI")) ; 価格 01/03/01 YM 実数にする(整数16bit)
;;;02/01/21YM@DEL         &WDH ; W,D,H
;;;02/01/21YM@DEL       )
;;;02/01/21YM@DEL     )
;;;02/01/21YM@DEL     (done_dialog)
;;;02/01/21YM@DEL     #RES$
;;;02/01/21YM@DEL   );##GetDlgItem
;;;02/01/21YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckNum (&sKEY / #val #ret)
    (setq #ret nil)
    (setq #val (read (get_tile &sKEY)))
    (if (= (type (read (get_tile &sKEY))) 'INT)
      (if (< #val -0.00001) ; 整数
        (progn
          (alert "0以上の整数値を入力して下さい")
          (set_tile &sKEY "")
          (mode_tile &sKEY 2)
        )
;;;02/01/21YM@DEL       (setq #ret T)
        ; 02/01/21 YM ADD-S
        (progn
          (if (equal 0.0 #val 0.00001) ; 0円のとき
            (if (CFYesNoDialog "0円でもよろしいですか？") ; 0円のとき
              (setq #ret T)
              (mode_tile &sKEY 2)
            );_if
            (setq #ret T)
          );_if
        )
        ; 02/01/21 YM ADD-E
      );_if
      (progn ; 整数以外
        (alert "0以上の整数値を入力して下さい")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckStr (&sKEY / #ret)

;;;02/02/19YM@DEL    (setq #ret nil)
;;;02/02/19YM@DEL    (if (= (type (read (get_tile &sKEY))) 'SYM)
;;;02/02/19YM@DEL     (progn

;;;02/01/21YM@DEL       (if (= (get_tile &sKEY) &HINBAN)
;;;02/01/21YM@DEL         (progn
;;;02/01/21YM@DEL           (alert "特注品番を入力して下さい")
;;;02/01/21YM@DEL           (mode_tile &sKEY 2)
;;;02/01/21YM@DEL         )
          (setq #ret T)
;;;02/01/21YM@DEL       );_if

;;;02/02/19YM@DEL     )
;;;02/02/19YM@DEL     (progn
;;;02/02/19YM@DEL        (alert "文字列を入力して下さい")
;;;02/02/19YM@DEL        (set_tile &sKEY "")
;;;02/02/19YM@DEL        (mode_tile &sKEY 2)
;;;02/02/19YM@DEL     )
;;;02/02/19YM@DEL    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; 全項目チェック。通れば結果リストに加工して返す。
  (defun ##Check&GetAllVal ( / #DLG$)
    (cond
      ((not (##CheckNum "edtTOKU_PRI"))  nil) ; 項目にｴﾗｰがあるとnilを返す
      ((not (##CheckStr "edtTOKU_ID")) nil) ; 項目にｴﾗｰがあるとnilを返す
      (T ; 項目にｴﾗｰなし
        (setq #DLG$
          (list
            (get_tile "edtTOKU_ID")         ; 品番
            (atof (get_tile "edtTOKU_PRI")) ; 価格 01/03/01 YM 実数にする(整数16bit)
            ; 03/06/19 YM ADD-S
            (get_tile "edtHINMEI")  ; 品名
            (get_tile "edtBIKOU")   ; 備考
            ; 03/06/19 YM ADD-E
          )
        )
        (done_dialog)
        #DLG$
      )
    );_cond

  ); end of ##Check&GetAllVal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; 全項目チェック。通れば結果リストに加工して返す。
  (defun ##Exit ( / )
    (done_dialog)
    nil
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;; ダイアログの実行部
  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  ;03/06/19 YM ADD 品名、備考も編集可能に
;;;  (if (= nil (new_dialog "ShowTOKUCABDlg" #sDCLID)) (exit))
  (if (= nil (new_dialog "ShowTOKUCABDlg_N" #sDCLID)) (exit))

  ; 初期値の設定 ; txtORG_PRICE
  (set_tile "edtTOKU_ID" &HINBAN)
  (set_tile "edtTOKU_PRI" &PRICE)
  (set_tile "txtORG_PRICE" (strcat "　元の価格： " &ORG_price "円"))
  ;03/06/19 YM MOD-S 品名、備考も編集可能に
;;;  (set_tile "txtHINMEI"    (strcat "　品　名　　： " &sHINMEI)) ; 品名 01/08/20 YM ADD
;;;  (set_tile "txtBIKOU"     (strcat "　備　考　　： " &sBIKOU))  ; 備考 01/08/20 YM ADD
  (set_tile "edtHINMEI" &sHINMEI) ; 品名
  (set_tile "edtBIKOU"  &sBIKOU)  ; 備考
  ;03/06/19 YM MOD-E

  (mode_tile "edtTOKU_PRI" 2)
;;;  (set_tile "edtTOKU_W" (nth 0 &WDH))
;;;  (set_tile "edtTOKU_D" (nth 1 &WDH))
;;;  (set_tile "edtTOKU_H" (nth 2 &WDH))

  ;;; タイルのリアクション設定
;;;02/01/21YM@DEL  (action_tile "edtTOKU_ID"  "(##CHK_edit \"edtTOKU_ID\"  &HINBAN 2)")
;;;02/01/21YM@DEL  (action_tile "edtTOKU_PRI" "(##CHK_edit \"edtTOKU_PRI\" &PRICE  1)")
;;;02/01/21YM@DEL  (action_tile "accept" "(setq #RES$ (##GetDlgItem))")

  ; OKボタンが押されたら全項目をチェック。通れば結果リストに加工して返す。02/01/21 YM MOD
  (action_tile "accept" "(setq #RESULT$ (##Check&GetAllVal))")
  (action_tile "cancel" "(setq #RESULT$ (##Exit))") ; cancel

  (start_dialog)
  (unload_dialog #sDCLID)
  ; リストを返す
  #RESULT$
);ShowTOKUCAB_Dlog

;<HOM>*************************************************************************
; <関数名>    : C:CabSubtractKutai
; <処理概要>  : キャビ切り欠きコマンド
; <戻り値>    : なし
; <作成>      : A.Satoh
; <備考>      : 
;*************************************************************************>MOH<
(defun C:CabSubtractKutai (
  /
  #hndB #hnd #sym_lis$ #cab_lis$ #en #ss #idx
  #sym #ku_en #kutai_Lis$ #cab_en #kutai
  )

;**********************************
    ;; エラー処理
    (defun CabSubtractKutaiErr (msg)
      (command "_.UNDO" "B")
      (setq *error* nil)
      (princ)
    )
;**********************************

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:CabSubtractKutai ////")
  (CFOutStateLog 1 1 " ")

  (setq *error* CabSubtractKutaiErr)
  (command "_.UNDO" "M")
  (command "_.UNDO" "A" "OFF")

  ; キャビネット選択
  (setq #hndB (car (CFGetXRecord "BASESYM"))) ; 基準ｱｲﾃﾑ
  (setq #sym_lis$ nil)
  (setq #cab_lis$ nil)
  (setq #en T)
  (while #en
    (initget "U")
    (setq #en (entsel "\n部材を選択してください: "))
    (cond
      ((= #en "U")
        ;;; 基準ｱｲﾃﾑなら緑
        (if (> (length #sym_lis$) 0)
          (progn
            (setq #hnd (cdr (assoc 5 (entget (car #sym_lis$)))))
            (if (equal #hnd #hndB)
              (GroupInSolidChgCol (car #sym_lis$) CG_BaseSymCol) ; 緑
              (GroupInSolidChgCol2 (car #sym_lis$) "BYLAYER")    ; 色を戻す
            )
            ; リストから直前のものを削除
            (setq #sym_lis$ (cdr #sym_lis$))
          )
        )
      )
      ((= #en nil)
        (if (= (length #sym_lis$) 0)
          (progn
            (CFAlertErr "部材が選択されていません")
            (setq #en T)
          )
        )
      )
      (T
        (setq #sym (CFSearchGroupSym (car #en)))
        (if (= #sym nil)
          (CFAlertMsg "部材が選択されていません")
          (if (= (CFGetXData #sym "G_LSYM") nil)
            (CFAlertMsg "部材が選択されていません")
            (progn
              (GroupInSolidChgCol2 #sym CG_InfoSymCol)
              (setq #sym_lis$ (cons #sym #sym_lis$))

              ; シンボル図形と同一グループメンバー図形を取り出す
              (setq #ss (CFGetSameGroupSS #sym))
              (setq #idx 0)
              (repeat (sslength #ss)
                (setq #cab_en (ssname #ss #idx))
                (if (= (cdr (assoc 0 (entget #cab_en))) "3DSOLID")
                  (setq #cab_lis$ (cons #cab_en #cab_lis$))
                )
                (setq #idx (1+ #idx))
              )
            )
          )
        )
      )
    )
  )

  ; 切り欠く躯体を選択
  (setq #en T)
  (setq #kutai_lis$ nil)
  (while #en
    (setq #en (car (entsel "\n切り欠く躯体を選択してください: ")))
    (if (= #en nil)
      (progn
        (CFAlertErr "躯体が選択されていません")
        (setq #en T)
      )
      (progn
        ; 親シンボルの取得
        (setq #sym (SearchGroupSym #en))
        (if (= #sym nil)
          (CFAlertMsg "躯体が選択されていません")
          ; 性格コードチェック
          (if (/= (nth 9 (CFGetXData #sym "G_LSYM")) 999)
            (CFAlertMsg "躯体ではありません")
            (progn
              (setq #ss (CFGetSameGroupSS #sym))
              (setq #idx 0)
              (repeat (sslength #ss)
                (setq #ku_en (ssname #ss #idx))
                (if (= (cdr (assoc 0 (entget #ku_en))) "3DSOLID")
                  (setq #kutai_lis$ (cons #ku_en #kutai_lis$))
                )
                (setq #idx (1+ #idx))
              )
              (setq #ku_en (car #kutai_lis$))
              (setq #en nil)
            )
          )
        )
      )
    )
  )

  ; キャビ切り欠き処理を行う
  (foreach #cab_en #cab_lis$
    (command "._COPY" #ku_en "" "0,0,0" "0,0,0")
    (setq #kutai (entlast))
    (command "_.SUBTRACT" #cab_en "" #kutai "")
    (command "_REGEN")
  )

  ; キャビネットの色を元に戻す
  (foreach #en #sym_lis$
    ;;; 基準ｱｲﾃﾑなら緑
    (setq #hnd (cdr (assoc 5 (entget #en))))
    (if (equal #hnd #hndB)
      (GroupInSolidChgCol #en CG_BaseSymCol) ; 緑
      (GroupInSolidChgCol2 #en "BYLAYER") ; 色を戻す
    )
  )

  (setq *error* nil)

; (alert "★★★　工事中　★★★")
;
  (princ)
);C:CabSubtractKutai

; 2017/11/13 KY ADD-S
; フレームキッチン 集成カウンター対応
;<HOM>*************************************************************************
; <関数名>    : IsFKLWCounter
; <処理概要>  : 品番が集成カウンターかどうか
; <戻り値>    : T=集成カウンター / nil=他
; <作成>      : KY
; <備考>      : 
;*************************************************************************>MOH<
(defun IsFKLWCounter (
	&hinban
	/
	#ret
	#qry$
	)

	(setq #ret nil)
	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn
			(setq #qry$ (CFGetDBSQLRec CG_DBSESSION "集成カウンタ"
								(list (list "品番名称" &hinban 'STR))))
			(if (and #qry$ (= (length #qry$) 1))
				(setq #ret T)
			);if
		);progn
	);if

	#ret
)
; 2017/11/13 KY ADD-E

(princ)