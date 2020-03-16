;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ｾｯﾄ品ﾁｪｯｸｺﾏﾝﾄﾞ
;;;(defun c:sss (/)
;;;	(C:SetHINCheck)
;;;)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;; C:SetHINCheck ｺﾏﾝﾄﾞ内の全ﾒｯｾｰｼﾞ
	(setq msg1 "SERIES記号が見つかりません")
	(setq msg2 "SERIESテーブルにレコードがありません。")
	(setq msg3 "現在のプランは、セット品見積りができません。")
	(setq msg4 "\n処理を続けるにはワークトップを品番確定する必要があります。\n品番確定を行いますか？")
	(setq msg5 "コマンドを終了しました。")
	(setq msg6 "図面上にワークトップがありません。")
	(setq msg7 "セット構成確認を行いますか？")
	(setq msg8 "現在のSERIESでこのコマンドは使用できません。")

;<HOM>*************************************************************************
; <関数名>    : GetHinbanSYMList
; <処理概要>  : ｼﾝﾎﾞﾙﾘｽﾄ==>(品番,ｼﾝﾎﾞﾙ)ﾘｽﾄ
; <戻り値>    : (品番,ｼﾝﾎﾞﾙ)ﾘｽﾄ
; <作成>      : 00/01/31 YM
; <備考>      :
;*************************************************************************>MOH<
(defun GetHinbanSYMList (
	&sym$
	/
	#ret$ #HINBAN #XD_TOKU
	)
	(setq #ret$ nil)
	(foreach #sym &sym$
		(setq #HINBAN (nth 5 (CFGetXData #sym "G_LSYM")))
		(setq #ret$	(append #ret$
			(list
				(list
					(if (setq #xd_TOKU (CFGetXData #sym "G_TOKU"))
;;;01/06/28 YM					(if (and (setq #xd_TOKU (CFGetXData #sym "G_TOKU"))
;;;01/06/28 YM									 (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB)(itoa CG_SKK_TWO_BAS) "?")) ; 特注ｺﾝﾛがｾｯﾄ品からはじかれるのを防ぐため ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
;;;01/06/28 YM									 (not (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_ETC))))) ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
;;;01/05/31YM@						(strcat "ﾄｸ" #HINBAN)
						(nth 0 #xd_TOKU) ; 01/05/31 YM MOD
						#HINBAN ; 食洗,ｺﾝﾛ,水栓特注以外
					);_if
					#sym
				)
			)
		))
	);foreach
	#ret$
);GetHinbanSYMList

;<HOM>*************************************************************************
; <関数名>    : KcCheckSetMITUMORI
; <処理概要>  : ｼﾘｰｽﾞ記号から見積りﾀｲﾌﾟを調べｾｯﾄ品見積もりが有効かﾁｪｯｸする
; <戻り値>    : なし
; <作成>      : 01/02/01 YM
; <備考>      : ｾｯﾄ品見積もり有効条件に"G_WTSET"の存在追加 01/02/07 YM
;               Lippleかどうかで判定を分岐 01/06/27 YM MOD
;*************************************************************************>MOH<
(defun KcCheckSetMITUMORI (
  /
	#MTYPE #QRY$ #SS #WT_EXIST
  )
  (setq #ss (ssget "X" '((-3 ("G_WTSET"))))) ; 品番確定WT
  (if (and #ss (> (sslength #ss) 0))
    (setq #WT_EXIST T) ; 図面上品番確定WTあり
	);_if

	(setq #MType (KPGetMitumoriType)) ; 見積りﾀｲﾌﾟ取得

	(if (equal (KPGetSinaType) 2 0.1) ; Lipple
	  (if (equal #MTYPE 2 0.1)
			T ; 見積りﾀｲﾌﾟ=2 のときOK ===> ｾｯﾄ品見積もりが有効
			nil
		);_if
	  (if (and #WT_EXIST (equal #MTYPE 2 0.1))
			T ; 見積りﾀｲﾌﾟ=2 のときOK ===> ｾｯﾄ品見積もりが有効
			nil
		);_if
	)
);KcCheckSetMITUMORI

;<HOM>*************************************************************************
; <関数名>    : KPGetMitumoriType
; <処理概要>  : ｼﾘｰｽﾞ記号から見積りﾀｲﾌﾟを求める
; <戻り値>    : 見積りﾀｲﾌﾟ(実数値)
; <作成>      : 01/06/27 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KPGetMitumoriType (
  /
	#QRY$ #RET #SERI$
  )
  (if (setq #seri$ (CFGetXRecord "SERI"))
		(progn
	    (setq CG_SeriesCode (nth 1 #seri$))  ;SERIES記号
			(setq CG_DRColCode  (nth 4 #seri$))  ;扉COLOR記号
		)
		(progn
			(CFAlertErr msg1)
			(princ msg5)
			(*error*)
		)
  )

  ;// DBに接続する
  (if (= CG_CDBSESSION nil)(setq CG_CDBSESSION (dbconnect CG_CDBNAME "" "")))
  (if (= CG_DBSESSION nil) (setq CG_DBSESSION (dbconnect CG_DBNAME "" "")))
  ;ｼﾘｰｽﾞ記号から見積りﾀｲﾌﾟを調べる
  (setq #qry$ (CFGetDBSQLRecChk CG_CDBSESSION "SERIES" (list (list "SERIES記号" CG_SeriesCode 'STR)
																															 (list "SERIES名称" CG_SeriesDB   'STR)))) ; 02/03/18 YM ADD CG_SeriesDB追加

;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #qry$)
;;;		;ｼﾘｰｽﾞ別DB,共通DB再接続
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E

	(if #qry$
		(setq #ret (nth 8 #qry$))
	  (if (= nil #qry$)
			(progn
				(CFAlertErr msg2)
				(princ msg5)
				(*error*)
			)
		);_if
	);_if
	#ret
);KPGetMitumoriType

;<HOM>*************************************************************************
; <関数名>    : KcCheckWTSET
; <処理概要>  : 品番確定していないWTを調べる ﾕｰｻﾞｰYes==> WT品番確定処理
;                                            ﾕｰｻﾞｰ No==> ｺﾏﾝﾄﾞ終了
; <戻り値>    : 図面上の全WT選択ｾｯﾄ
; <作成>      : 01/02/01 YM
; <備考>      : 図面上にWTがない場合ｺﾏﾝﾄﾞ終了
;*************************************************************************>MOH<
(defun KcCheckWTSET (
  /
	#I #SS #WT$ #WTSET$
  )
	(setq #WT$ '())
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (and #ss (> (sslength #ss) 0))
    (progn ; 図面上WTあり
      (setq #i 0 #WT$ '() #WTSET$ '()) ; 品番確定していないＷＴを調べる
      (repeat (sslength #ss)
        (if (= nil (CFGetXData (ssname #ss #i) "G_WTSET"))
					(setq #WT$    (append #WT$    (list (ssname #ss #i)))) ; 品番確定していないWTﾘｽﾄ
        );_if
        (setq #i (1+ #i))
      );_repeat

			(if #WT$ ; 品番確定してないWT
				(if (CFYesNoDialog msg4)
					(foreach #WT #WT$ ; Yes
            (PCW_ChColWT #WT "MAGENTA" nil)
            (KPW_DesideWorkTop3 #WT)
					)
					(progn
						(princ msg5)
						(*error*) ; No
					)
				);_if
			);_if
    )
		(progn ; 図面上にWTがない場合
			(CFAlertErr msg6)
			(princ msg5)
			(*error*)
		)
  );_if
	#ss
);KcCheckWTSET

;<HOM>*************************************************************************
; <関数名>    : KcCheckSetStd
; <処理概要>  : SET標準かどうかﾁｪｯｸする
; <戻り値>    : T or nil
; <作成>      : 00/02/01 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KcCheckSetStd (
	&sym
  /
	#HIN #LR #QRY$ #RET #SYM #XD_LSYM$
  )
	(setq #qry$ nil)
	(setq #xd_LSYM$ (CFGetXData &sym "G_LSYM"))
	(setq #hin (nth 5 #xd_LSYM$))
	(setq #LR  (nth 6 #xd_LSYM$))
  (setq #qry$
	  (CFGetDBSQLRec CG_DBSESSION "SET標準"
	    (list
	      (list "品番名称" #hin 'STR)
	      (list "LR区分"   #LR  'STR)
	    )
	  )
	)
	(if #qry$
		(setq #ret T)
		(setq #ret nil)
	);_if
	#ret
);KcCheckSetStd

;<HOM>*************************************************************************
; <関数名>    : C:SetHINCheck
; <処理概要>  : ｾｯﾄ品ﾁｪｯｸｺﾏﾝﾄﾞ(table.cfg出力)
; <戻り値>    : なし
; <作成>      : 01/06/27 YM
; <備考>      : Lipple とそれ以外で分岐
;*************************************************************************>MOH<
(defun C:SetHINCheck ( / )
	(if (equal (KPGetSinaType) 2 0.1)
		(SetHINChecksub_Lipple) ; Lipple
		(SetHINChecksub)        ; Lipple以外
	);_if
	(princ)
);C:SetHINCheck

;<HOM>*************************************************************************
; <関数名>    : SetHINChecksub_Lipple
; <処理概要>  : ｾｯﾄ品ﾁｪｯｸｺﾏﾝﾄﾞ(table.cfg出力)
; <戻り値>    : なし
; <作成>      : 01/06/27 YM Lipple用
; <備考>      :
;*************************************************************************>MOH<
(defun SetHINChecksub_Lipple (
  /
	#110$ #112$ #210$ #410$ #510$ #ALL$ #BASE$ #DFNAME #DUMMY$$ #EXIST #GASCAB$ #I
	#OPTION$ #OPT_SET_OK #OP_HIN #OP_NUM #OS #OT #OTHER$ #PMEN2 #PT$ #RET$ #RETV$
	#SETCODE #SETHINOK$ #SM #SS #STAND$ #SYM #WT_HINBAN$ #XDOPT$ #xdOPT_$
  )
		;/////////////////////////////////////////
		(defun ##rtoa (	&R / ); 実数
			(itoa (fix (+ &R 0.0001)))
		)
		;/////////////////////////////////////////
		(defun ##GetMAG (	&MAG / #nMAG); 実数==>文字列
			(setq #nMAG (##rtoa &MAG))
			; "2550"=>"255","900"=>"90"
			(setq #nMAG (substr #nMAG 1 (1- (strlen #nMAG))))
			; "90"=>"090"
			(if (= (strlen #nMAG) 2)
				(setq #nMAG (strcat "0" #nMAG))
			);_if
			#nMAG
		)
		;/////////////////////////////////////////

	; 前処理
	(StartUndoErr)
	(setq CG_SetHIN T) ; ｾｯﾄ構成品確認ｺﾏﾝﾄﾞ実行中 01/05/15 YM

  ;Head.cfg出力
  (SKB_WriteHeadList)
  ;Table.cfg出力
	(if CG_TABLE ; 展開図作成ｺﾏﾝﾄﾞで出力済み
		(princ)
  	(SCFMakeBlockTable)
	)

	(setq #dfname (strcat CG_KENMEI_PATH "Dummy.cfg"))
  (if (findfile #dfname)
    (vl-file-delete #dfname)
  )

  ;①ｼﾘｰｽﾞ記号から見積りﾀｲﾌﾟを調べｾｯﾄ品見積りが有効かﾁｪｯｸする
	(if (equal (KPGetMitumoriType) 2 0.1)
		(princ)
		(progn ; 見積り無効ならｺﾏﾝﾄﾞ終了
			(CFAlertErr msg3)
			(princ msg5)
			(*error*)
		)
	);_if

	;②図面上の全ｺﾝﾛｷｬﾋﾞを取得
	(setq #GASCAB$ nil) ; ｺﾝﾛｷｬﾋﾞｼﾝﾎﾞﾙﾘｽﾄ
  (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; LSYM
	(setq #EXIST nil) ; 図面上にｺﾝﾛｷｬﾋﾞがある = T
	(if (and #ss (> (sslength #ss) 0))
		(progn
			(setq #i 0)
			(repeat (sslength #ss)
				(setq #sym (ssname #ss #i))
				(if (and (= CG_SKK_ONE_CAB (CFGetSymSKKCode #sym 1))
								 (= CG_SKK_TWO_BAS (CFGetSymSKKCode #sym 2))
								 (= CG_SKK_THR_GAS (CFGetSymSKKCode #sym 3)))
					(progn
						(setq #EXIST T) ; 図面上にｺﾝﾛｷｬﾋﾞがある
						(setq #GASCAB$ (append #GASCAB$ (list #sym)))
					)
				);_if
				(setq #i (1+ #i))
			)
		)
	);_if

	(if (= nil #EXIST)
		(progn ; ｾｯﾄﾌﾟﾗﾝが図面に存在しない
			(CFAlertErr msg3)
			(princ msg5)
			(*error*)
		)
		(progn ; 以下実行
			;;; ｼｽﾃﾑ変数設定,基準ｱｲﾃﾑｸﾞﾛｰﾊﾞﾙｾｯﾄ CG_BASESYM
		  (setq #os (getvar "OSMODE"   ))
		  (setq #sm (getvar "SNAPMODE" ))
		  (setq #ot (getvar "ORTHOMODE"))
		  (setvar "OSMODE"    0)
		  (setvar "SNAPMODE"  0)
		  (setvar "ORTHOMODE" 0)
			(setq CG_BASESYM (CFGetBaseSymXRec))

		  (setq #i 0 #Dummy$$ '())
			(setq #option$ nil)
		  (foreach #GASCAB #GASCAB$
				; PMEN2を取得
				(setq #pmen2 (PKGetPMEN_NO #GASCAB 2))
	      (setq #pt$ (GetLWPolyLinePt #pmen2)) ; PMEN2 外形領域
	      (setq #pt$ (AddPtList #pt$))         ; 末尾に始点を追加する
				(command "vpoint" "0,0,1")          ; 視点を真上から
			  (setq #ret$ (PKGetBaseSymCP_SYOKUSEN #pt$)) ; 領域内ﾍﾞｰｽｷｬﾋﾞ(11?)ｼﾝﾎﾞﾙ図形名ﾘｽﾄ,食洗"110"ﾘｽﾄ
			  (setq #base$ (car  #ret$))                  ; 領域内ﾍﾞｰｽｷｬﾋﾞ
			  (setq #110$  (cadr #ret$))                  ; 領域内食洗
				(setq #410$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SNK)) ; 領域内ｼﾝｸ ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
				(setq #112$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SCA)) ; 領域内ｼﾝｸｷｬﾋﾞ ; 01/08/31 YM MOD 112-->ｸﾞﾛｰﾊﾞﾙ化
				(setq #210$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_GAS)) ; 領域内ｺﾝﾛ ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
				(setq #510$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; 領域内水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
				(command "zoom" "p") ; 視点を戻す

				(setq #all$ (append #base$ #110$ #410$ #210$ #510$)) ; 検索した全ｼﾝﾎﾞﾙ図形ﾘｽﾄ
				;③ﾍﾞｰｽｷｬﾋﾞは色を赤くする CG_InfoSymCol
				(foreach #sym #base$
					(GroupInSolidChgCol2 #sym CG_InfoSymCol)
				)
				; 食洗,ｶﾞｽ,水栓は、SET標準にあれば色を赤くする
				(setq #other$ nil #stand$ nil)
				(foreach #sym (append #110$ #210$ #510$)
					(if (KcCheckSetStd #sym) ; SET標準かどうかﾁｪｯｸ
						(progn ; ﾚｺｰﾄﾞが存在すれば赤くする
							(GroupInSolidChgCol2 #sym CG_InfoSymCol)
							(setq #stand$ (append #stand$ (list #sym))) ; ﾘｽﾄ化(赤くしたもの)#stand$
						)
						; SET標準品ではない
						(setq #other$ (append #other$ (list #sym))) ; ﾘｽﾄ化(赤くしないもの)#other$
					);_if
				);foreach

		; ﾍﾞｰｽｷｬﾋﾞ             ==>赤 #base$
		; 食洗 SET標準か調査 OK==>赤 #110$
		; ｼﾝｸ ?                      #410$
		; ｺﾝﾛ  SET標準か調査 OK==>赤 #210$
		; 水栓 SET標準か調査 OK==>赤 #510$
		; #stand$ 赤色にした
		; #other$ 色変更なし

				;<ﾍﾞｰｽｾｯﾄ品番>を求める
				(setq #SetCode (KPGetBaseSetCode #pt$ #210$ #110$ #GASCAB))

				;;; ｾｯﾄ構成品一覧ﾀﾞｲｱﾛｸﾞでｾｯﾄ構成品をﾕｰｻﾞｰに確定させる

				(setq #RETV$
					(KcSetHinListDlg
						#SetCode    ; ｾｯﾄｺｰﾄﾞ
						#WT_HINBAN$ ; WT品番ﾘｽﾄ
						(GetHinbanSYMList	(append #base$ #stand$)) ; (ｷｬﾋﾞ品番,ｼﾝﾎﾞﾙ)ﾘｽﾄを引き渡す
				))
				(setq #SetHinOK$ (car  #RETV$))
				(setq #SetCode   (cadr #RETV$)) ; ﾀﾞｲｱﾛｸﾞｾｯﾄｺｰﾄﾞ戻り値

				(cond
					((= (type #SetHinOK$) 'STR)
						(*error*) ; ｷｬﾝｾﾙﾎﾞﾀﾝ
					)
					(T ; OKﾎﾞﾀﾝ
						; 確定後に色を戻す
						(foreach #elm (mapcar 'cadr #SetHinOK$) ; ｼﾝﾎﾞﾙ
							;;; 色を戻す
			        (if (equal CG_BASESYM #elm) ;基準ｱｲﾃﾑ
			          (GroupInSolidChgCol #elm CG_BaseSymCol)
			          (GroupInSolidChgCol2 #elm "BYLAYER")
			        );_if
						)
					 	(if (= #SetHinOK$ nil)
							(princ) ; ｾｯﾄ構成品なし
							(progn  ; ｾｯﾄ構成品あり
								; Dummy.cfg出力用変数保管

								; ｵﾌﾟｼｮﾝ品追加 01/03/02 YM ｵﾌﾟｼｮﾝ品もｾｯﾄ構成品かどうか区別が必要
								(foreach #e$ #SetHinOK$
									(setq #sym (cadr #e$))
									(if (setq #xdOPT$ (CFGetXData #sym "G_OPT"))
										(progn ; ｵﾌﾟｼｮﾝ品あり
									    (setq #xdOPT_$ #xdOPT$)
									    (repeat (car #xdOPT$)
									      (setq #xdOPT_$ (cdr #xdOPT_$))
									      (setq #OP_hin  (car #xdOPT_$)) ;品番
									      (setq #xdOPT_$ (cdr #xdOPT_$))
									      (setq #OP_num  (car #xdOPT_$)) ;個数

											  (setq #OPT_SET_OK
													(CFGetDBSQLRec CG_DBSESSION "SET標準" ; "SET標準"ﾃｰﾌﾞﾙに存在するか
											    	(list (list "品番名称" #OP_hin 'STR))
										  		)
												)
												(if #OPT_SET_OK ; ｾｯﾄ構成可能
													(repeat #OP_num
														(setq #option$ (append #option$ (list (list #OP_hin nil))))
													)
												);_if
											);repeat
										)
									);_if
								);foreach
								(setq #SetHinOK$ (append #SetHinOK$ #option$))

								(setq #Dummy$$ (append #Dummy$$
									(list
										(list #SetCode #WT_HINBAN$ #SetHinOK$)
									)
								)) ; (ｾｯﾄｺｰﾄﾞ,WT品番,(ｾｯﾄ構成品番,ｼﾝﾎﾞﾙ)ﾘｽﾄ)
							)
						);_if
					)
				);_cond
		    (setq #i (1+ #i))
		  );_repeat

			;;; Dummy.cfg に出力
			(if #Dummy$$ (KcWriteSetHIN_Info #Dummy$$)) ; 01/02/16 ｵﾌﾟｼｮﾝ品も出力

			; #SetHinOK$ はｾｯﾄ品なので見積りで全角ｽﾍﾟｰｽ分字下げする(ｿｰﾄに影響せずまとめて表示)
			;;; Dummy.cfg,Table.cfgからｾｯﾄ構成品を考慮したTable.cfgを作成
			(KcChangeTableCFGbySetInfo) ; 02/01 YM

			(setq CG_SetHIN nil) ; ｾｯﾄ構成品確認ｺﾏﾝﾄﾞ実行中 01/05/15 YM

			; 後処理
		  (setq *error* nil)
			;;; ｼｽﾃﾑ変数設定
			(setvar "OSMODE"    #os)
			(setvar "SNAPMODE"  #sm)
			(setvar "ORTHOMODE" #ot)

		)
	);_if


  (princ)
);SetHINChecksub_Lipple

;<HOM>*************************************************************************
; <関数名>    : KPGetSET4
; <処理概要>  : Lippleｾｯﾄ品ｺｰﾄﾞ4を求める
; <戻り値>    :
; <作成>      : 01/06/27 YM
; <備考>      : 外形領域の辺の最大値=間口
;*************************************************************************>MOH<
(defun KPGetSET4 (
	&pt$
  /
	#DIST #I #MAX #P1 #P2 #SK4 #STR
  )
	(setq #MAX -1.0e10 #i 0)
	(repeat (1- (length &pt$))
		(setq #p1 (nth (+ #i 0) &pt$))
		(setq #p2 (nth (+ #i 1) &pt$))
		(setq #dist (distance #p1 #p2))
		(if (<= #MAX #dist)
			(setq #MAX #dist)
		);_if
		(setq #i (1+ #i))
	);repeat
	(setq #str (itoa (fix (+ 0.001 #MAX))))
	(setq #sk4 (substr #str 1 3))
);KPGetSET4

;<HOM>*************************************************************************
; <関数名>    : KPGetSET5
; <処理概要>  : Lippleｾｯﾄ品ｺｰﾄﾞ5を求める
; <戻り値>    :
; <作成>      : 01/06/27 YM
; <備考>      : 調理器記号
;*************************************************************************>MOH<
(defun KPGetSET5 (
	&210$ ; ｺﾝﾛｼﾝﾎﾞﾙﾘｽﾄ
  /
	#GAS_SYM #HINBAN #QRY$ #SK5
  )
	(if &210$
		(progn
			(setq #GAS_SYM (car &210$))
			(setq #HINBAN (nth 5 (CFGetXData #GAS_SYM "G_LSYM")))

		  (setq #qry$
			  (CFGetDBSQLRec CG_DBSESSION "SK特性値"
			    (list
			      (list "特性値名" #HINBAN 'STR)
			      (list "特性ID" "PLAN20" 'STR)
			    )
			  )
			)
			(if (and #qry$ (= (length #qry$) 1))
				(setq #sk5 (nth 2 (car #qry$)))
				(progn
					(CFAlertErr (strcat "SK特性値テーブルが不正です。\n品番 = " #HINBAN))
					(setq #sk5 "?")
				)
			);_if
		)
		(setq #sk5 "?")
	);_if

);KPGetSET5

;<HOM>*************************************************************************
; <関数名>    : KPGetBaseSetCode
; <処理概要>  : Lippleｾｯﾄ品ｺｰﾄﾞを求める
; <戻り値>    : ｾｯﾄ品ｺｰﾄﾞ(文字列)
; <作成>      : 01/06/27 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KPGetBaseSetCode (
	&pt$    ; ｺﾝﾛｷｬﾋﾞ外形点列
	&210    ; ｺﾝﾛｼﾝﾎﾞﾙﾘｽﾄ
	&110    ; 食洗ｼﾝﾎﾞﾙﾘｽﾄ
	&GASCAB ; ｺﾝﾛｷｬﾋﾞｼﾝﾎﾞﾙﾘｽﾄ
  /
	#SETCODE #SK1 #SK2 #SK3 #SK4 #SK5 #SK6 #SK7 #SK8
  )

	; (1)ｼﾘｰｽﾞ
	(if CG_SeriesCode
		(setq #sk1 CG_SeriesCode)
		(setq #sk1 "?")
	);_if

	; (2)ﾄｯﾌﾟ形状 I(固定)
	(setq #sk2 "I")

	; (3)ｼﾝｸ S(固定)
	(setq #sk3 "S")

	; (4)間口
	(setq #sk4 (KPGetSET4 &pt$))

	; (5)調理機器記号(SK特性値を検索)
	(setq #sk5 (KPGetSET5 &210))

	; (6)食洗有無
	(if &110
		(setq #sk6 "A")
		(setq #sk6 "")
	);_if

	; (7)使い勝手=ｺﾝﾛｷｬﾋﾞのLR
	(setq #sk7 (nth 6 (CFGetXData &GASCAB "G_LSYM")))

	; (8)扉ｶﾗｰ
	(setq #sk8 CG_DRColCode)

	(setq #SetCode (strcat #sk1 #sk2 #sk3 "-" #sk4 #sk5 #sk6 #sk7 #sk8))
);KPGetBaseSetCode

;<HOM>*************************************************************************
; <関数名>    : SetHINChecksub
; <処理概要>  : ｾｯﾄ品ﾁｪｯｸｺﾏﾝﾄﾞ(table.cfg出力)
; <戻り値>    : なし
; <作成>      : 01/01/30 YM
; <備考>      : ｼﾝｸは1つと仮定
;*************************************************************************>MOH<
(defun SetHINChecksub (
  /
	#110$ #210$ #410$ #510$ #ALL$ #BASE$ #DUMMY$$ #I #OS #OT #OTHER$ #PT$ #QRY$ #RET$
	#SETCODE #SETHINDB$ #SETHINOK$ #SM #SS #SSMR #SSWT #STAND$ #SYOKUSEN #WT #WTMR #RETV$
	#XDWT$ #XDWTSET$ #DUM$ #J #SNKK #TYPE #WT_HINBAN$ #WT_TYPE #NMAG #NMAG1 #NMAG2 #NMAG3
	#WT_LR #ZaiCode #ZaiF #dfname
	#OPTION$ #OPT_SET_OK #OP_HIN #OP_NUM #SYM #XDOPT$ #xdOPT_$
	#112$ #SPLAN #SP_FLG ; 01/04/04 YM ADD
	#Dummy1$$ #Dummy2$$ #SNKFLG #ii #KOSU_PT$
  )
		;/////////////////////////////////////////
		(defun ##rtoa (	&R / ); 実数
			(itoa (fix (+ &R 0.0001)))
		)
		;/////////////////////////////////////////
		(defun ##GetMAG (	&MAG / #nMAG); 実数==>文字列
			(setq #nMAG (##rtoa &MAG))
			; "2550"=>"255","900"=>"90"
			(setq #nMAG (substr #nMAG 1 (1- (strlen #nMAG))))
			; "90"=>"090"
			(if (= (strlen #nMAG) 2)
				(setq #nMAG (strcat "0" #nMAG))
			);_if
			#nMAG
		)
		;/////////////////////////////////////////

	; 前処理
	(StartUndoErr)
	(setq CG_SetHIN T) ; ｾｯﾄ構成品確認ｺﾏﾝﾄﾞ実行中 01/05/15 YM

  ;Head.cfg出力
  (SKB_WriteHeadList)
  ;Table.cfg出力
	(if CG_TABLE ; 展開図作成ｺﾏﾝﾄﾞで出力済み
		(princ)
  	(SCFMakeBlockTable)
	)

	(setq #dfname (strcat CG_KENMEI_PATH "Dummy.cfg"))
  (if (findfile #dfname)
    (vl-file-delete #dfname)
  )

  ;①ｼﾘｰｽﾞ記号から見積りﾀｲﾌﾟを調べｾｯﾄ品見積りが有効かﾁｪｯｸする
	(if (KcCheckSetMITUMORI)
		(princ)
		(progn ; 見積り無効ならｺﾏﾝﾄﾞ終了
			(CFAlertErr msg3)
			(princ msg5)
			(*error*)
		)
	);_if

	;②品番確定していないWTを調べる
	(setq #ss (KcCheckWTSET)) ; 図面上の全WT

	;;; ｼｽﾃﾑ変数設定,基準ｱｲﾃﾑｸﾞﾛｰﾊﾞﾙｾｯﾄ CG_BASESYM
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
	(setq CG_BASESYM (CFGetBaseSymXRec))

	; 一番右のWTばかりの選択ｾｯﾄを求める
  (setq #i 0)
	(setq #ssMR (ssadd))
  (repeat (sslength #ss)
		(setq #WTMR (car (PKGetMostRightWT (ssname #ss #i)))) ; 一番右(1枚目)WT
		(ssadd #WTMR #ssMR)
    (setq #i (1+ #i))
  );_repeat

  (setq #i 0 #Dummy$$ '())
	(setq #option$ nil)
  (repeat (sslength #ssMR)
		(setq #WTMR (ssname #ssMR #i))
		(setq #xdWT$ (CFGetXData #WTMR "G_WRKT"))
		(setq #WT_Type (nth  3 #xdWT$)) ; 0,1,2=I,L,U 間口記号
		(setq #WT_LR   (nth 30 #xdWT$)) ; 左右勝手
		(setq #ZaiCode (nth  2 #xdWT$)) ; 材質記号
		(setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ

	  (cond
	    ((= #WT_Type 0)(setq #WT_type "I")) ; I型
	    ((= #WT_Type 1)(setq #WT_type "L")) ; L型
	    ((= #WT_Type 2)(setq #WT_type "U")) ; U型
			(T (setq #WT_type ""))
	  );_cond

		(setq #nMAG1 (##GetMAG (nth 42 #xdWT$))) ; 間口1
		(setq #nMAG2 (##GetMAG (nth 43 #xdWT$))) ; 間口2
		(setq #nMAG3 (##GetMAG (nth 44 #xdWT$))) ; 間口3

	  (cond
	    ((= #WT_Type "I")
			 	(setq #nMAG #nMAG1)
		 	)
	    ((= #WT_Type "L")
				(cond
					((= #WT_LR "R")(setq #nMAG (strcat #nMAG1 "." #nMAG2)))
					((= #WT_LR "L")(setq #nMAG (strcat #nMAG2 "." #nMAG1)))
					(T
						(setq #nMAG (strcat #nMAG1 "." #nMAG2))
					)
				);_cond
		 	)
	    ((= #WT_Type "U")
			 	(setq #nMAG (strcat #nMAG1 "." #nMAG2 "." #nMAG3))
		 	)
			(T (setq #nMAG ""))
	  );_cond

		(command "vpoint" "0,0,1") ; 視点を真上から
	  (setq #ssWT (PKGetWTSSFromWTEN #WTMR)); WT図形名からWT選択ｾｯﾄを取得する

;  離れたWTの対策 ;  01/07/04 YM MOD
		(if (and (nth 59 #xdWT$) (/= (nth 59 #xdWT$) "")); 新型"G_WRKT"[60]WT外形あり
			(progn
				(setq #pt$ (GetLWPolyLinePt (nth 59 #xdWT$))); 段差部も含んだWT外形領域
				(setq #pt$ (AddPtList #pt$))                 ; 末尾に始点を追加する
			)
		  (setq #pt$ (PK_WTSStoPlPt #ssWT)) ; WT外形点列を取得する(始点を末尾に追加済み)
		);_if

	  (setq #ret$ (PKGetBaseSymCP_SYOKUSEN #pt$)) ; 領域内ﾍﾞｰｽｷｬﾋﾞ(11?)ｼﾝﾎﾞﾙ図形名ﾘｽﾄ,食洗"110"ﾘｽﾄ
	  (setq #base$ (car  #ret$))                  ; 領域内ﾍﾞｰｽｷｬﾋﾞ
	  (setq #110$  (cadr #ret$))                  ; 領域内食洗
		(setq #410$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SNK)) ; 領域内ｼﾝｸ ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
		(setq #112$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SCA)) ; 領域内ｼﾝｸｷｬﾋﾞ ; 01/08/31 YM MOD 112-->ｸﾞﾛｰﾊﾞﾙ化
		(setq #210$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_GAS)) ; 領域内ｺﾝﾛ ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
		(setq #510$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; 領域内水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
		(command "zoom" "p") ; 視点を戻す

		(setq #all$ (append #base$ #110$ #410$ #210$ #510$)) ; 検索した全ｼﾝﾎﾞﾙ図形ﾘｽﾄ
		;③ﾍﾞｰｽｷｬﾋﾞは色を赤くする CG_InfoSymCol
		(foreach #sym #base$
			(GroupInSolidChgCol2 #sym CG_InfoSymCol)
		)
		; 食洗,ｶﾞｽ,水栓は、SET標準にあれば色を赤くする
		(setq #other$ nil #stand$ nil)
		(foreach #sym (append #110$ #210$ #510$)
			(if (KcCheckSetStd #sym) ; SET標準かどうかﾁｪｯｸ
				(progn ; ﾚｺｰﾄﾞが存在すれば赤くする
					(GroupInSolidChgCol2 #sym CG_InfoSymCol)
					(setq #stand$ (append #stand$ (list #sym))) ; ﾘｽﾄ化(赤くしたもの)#stand$
				)
				; SET標準品ではない
				(setq #other$ (append #other$ (list #sym))) ; ﾘｽﾄ化(赤くしないもの)#other$
			);_if
		);foreach

; ﾍﾞｰｽｷｬﾋﾞ             ==>赤 #base$
; 食洗 SET標準か調査 OK==>赤 #110$
; ｼﾝｸ ?                      #410$
; ｺﾝﾛ  SET標準か調査 OK==>赤 #210$
; 水栓 SET標準か調査 OK==>赤 #510$
; #stand$ 赤色にした
; #other$ 色変更なし

		; #ssWT 隣接WT含めたWT選択ｾｯﾄ
		(setq #j 0 #WT_HINBAN$ nil)
		(repeat (sslength #ssWT)
			(setq #WT_HINBAN$ (append #WT_HINBAN$
				(list (nth 1 (CFGetXData (ssname #ssWT #j) "G_WTSET")))
			)) ; WT品番ﾘｽﾄ
			(setq #j (1+ #j))
		)
		(if #110$
			(setq #SYOKUSEN "A")
			(setq #SYOKUSEN "")
		);_if
		; ｼﾝｸ記号
		(if #410$
			(setq #SNKK (nth 0 (CFGetXData (car #410$) "G_SINK")))
			(setq #SNKK "?")
		);_if
		;④ｾｯﾄｺｰﾄﾞを求める

		; ｽﾍﾟｱｽﾄｯｶｰﾌﾟﾗﾝ判定==>"K"を追加するかどうか 01/04/04 YM ADD
		(setq #SP_flg nil) ; ｽﾍﾟｱｽﾄｯｶｰﾌﾟﾗﾝのﾌﾗｸﾞ
		(if (= (length #112$) 1)
			(progn ; ｼﾝｸｷｬﾋﾞの判定
				(setq #SPLAN (CFgetini "SPLAN" "0002" (strcat CG_SKPATH "ERRMSG.INI")))
				(if (wcmatch (nth 5 (CFGetXData (car #112$) "G_LSYM")) #SPLAN)
;;;01/12/06YM@MOD					(setq #SP_flg "K") ; ｽﾍﾟｱｽﾄｯｶｰﾌﾟﾗﾝのﾌﾗｸﾞ
					(setq #SP_flg (CFgetini (strcat "SPLAN-" CG_SeriesCode) "0001" (strcat CG_SKPATH "ERRMSG.INI"))) ; 01/12/06 YM MOD
				);_if
			)
		);_if

		(setq #SetCode
			(strcat
				CG_SeriesCode ; ｼﾘｰｽﾞ記号
				#WT_type      ; ﾄｯﾌﾟ形状
				(if #SP_flg
					#SP_flg
					""
				);_if
				#SNKK         ; ｼﾝｸ記号
				"-"
				#nMAG         ; 間口ｻｲｽﾞ
				#SYOKUSEN     ; 食洗有無
			)
		)
;;;01/05/31YM@		; ｾｯﾄ構成品番名称を求める
;;;01/05/31YM@	  (setq #qry$
;;;01/05/31YM@		  (CFGetDBSQLRec CG_DBSESSION "SET構成"
;;;01/05/31YM@		    (list (list "セットCD" #SetCode 'STR))
;;;01/05/31YM@		  )
;;;01/05/31YM@		)
;;;01/05/31YM@		(setq #SetHinDB$ nil)
;;;01/05/31YM@		(if #qry$
;;;01/05/31YM@			(foreach #rec #qry$
;;;01/05/31YM@				(setq #SetHinDB$ (append #SetHinDB$ (list (nth 2 #rec))))
;;;01/05/31YM@			)
;;;01/05/31YM@			(setq #SetHinDB$ nil)
;;;01/05/31YM@		);_if

		(setq #SetCode (strcat #SetCode #WT_LR " " CG_DRColCode)) ; 01/02/05 YM 扉ｶﾗｰを追加
		; 人大ならｼﾘｰｽﾞ記号の後に材質記号を追加
		(if (or (= #ZaiF 0)(= #ZaiF -1))
			(setq #SetCode (vl-string-subst (strcat CG_SeriesCode #ZaiCode) CG_SeriesCode #SetCode))
		);_if

		;;; ｾｯﾄ構成品一覧ﾀﾞｲｱﾛｸﾞでｾｯﾄ構成品をﾕｰｻﾞｰに確定させる

;;;	    (setq #lis$ (list 1 "TEST_OPT" 777))
;;;	    (CFSetXData sym "G_OPT" #lis$)

		(setq #RETV$
			(KcSetHinListDlg
				#SetCode    ; ｾｯﾄｺｰﾄﾞ
				#WT_HINBAN$ ; WT品番ﾘｽﾄ
				(GetHinbanSYMList	(append #base$ #stand$)) ; (ｷｬﾋﾞ品番,ｼﾝﾎﾞﾙ)ﾘｽﾄを引き渡す
		))
		(setq #SetHinOK$ (car  #RETV$))
		(setq #SetCode   (cadr #RETV$)) ; ﾀﾞｲｱﾛｸﾞｾｯﾄｺｰﾄﾞ戻り値

		; #SetCode を"G_WRKT"にｾｯﾄする 01/02/09 YM
		(KcSetWTSetCode #WTMR #SetCode) ; 一番右WT,ｾｯﾄｺｰﾄﾞ

		(cond
			((= (type #SetHinOK$) 'STR)
				(*error*) ; ｷｬﾝｾﾙﾎﾞﾀﾝ
			)
			(T ; OKﾎﾞﾀﾝ
				; 確定後に色を戻す
				(foreach #elm (mapcar 'cadr #SetHinOK$) ; ｼﾝﾎﾞﾙ
					;;; 色を戻す
	        (if (equal CG_BASESYM #elm) ;基準ｱｲﾃﾑ
	          (GroupInSolidChgCol #elm CG_BaseSymCol)
	          (GroupInSolidChgCol2 #elm "BYLAYER")
	        );_if
				)
			 	(if (= #SetHinOK$ nil)
					(princ) ; ｾｯﾄ構成品なし
				;else
					(progn  ; ｾｯﾄ構成品あり
						; Dummy.cfg出力用変数保管

						; 02/02/07 YM ADD-S #SetHinOK$の品番の()を外す
						(setq #SetHin_DUM$ nil)
						(foreach #e$ #SetHinOK$
							; 03/11/29 YM ADD-S 特注品以外なら、#SetHinOK$の品番の()を外す
							(if (CFGetXData (cadr #e$) "G_TOKU")
								(progn
							    (setq #SetHin_DUM$
										(append #SetHin_DUM$ (list	#e$)) ;()はずさない
									)
								)
							; 03/11/29 YM ADD-E 特注品以外なら、#SetHinOK$の品番の()を外す
								;else
								(progn
							    (setq #SetHin_DUM$
										(append #SetHin_DUM$
											(list
												(CFModList #e$
													(list (list 0 (KP_DelHinbanKakko (car #e$))))
												)
											)
										)
									)
								)
							);_if
						)
						(setq #SetHinOK$ #SetHin_DUM$)
						; 02/02/07 YM ADD-E

						; ｵﾌﾟｼｮﾝ品追加 01/03/02 YM ｵﾌﾟｼｮﾝ品もｾｯﾄ構成品かどうか区別が必要
						(foreach #e$ #SetHinOK$
							(setq #sym (cadr #e$))
							(if (setq #xdOPT$ (CFGetXData #sym "G_OPT"))
								(progn ; ｵﾌﾟｼｮﾝ品あり
							    (setq #xdOPT_$ #xdOPT$)
							    (repeat (car #xdOPT$)
							      (setq #xdOPT_$ (cdr #xdOPT_$))
							      (setq #OP_hin  (car #xdOPT_$)) ;品番
							      (setq #xdOPT_$ (cdr #xdOPT_$))
							      (setq #OP_num  (car #xdOPT_$)) ;個数

									  (setq #OPT_SET_OK
											(CFGetDBSQLRec CG_DBSESSION "SET標準" ; "SET標準"ﾃｰﾌﾞﾙに存在するか
									    	(list (list "品番名称" #OP_hin 'STR))
								  		)
										)
										;"G_OPT2"を見て強制的にSET品にする 03/06/18 YM ADD-S
										;特注ｵﾌﾟｼｮﾝ品情報取得 "G_OPT2"(特注品番,元品番,金額,SET品ﾌﾗｸﾞ)
										(setq #xdOPT2$ (CFGetXData #sym "G_OPT2"))
										(setq #opt2$$ (KP_GetOpt2Info #xdOPT2$)) ; #xdOPT2$ ==>(特注品番,元品番,金額,SET品ﾌﾗｸﾞ)のﾘｽﾄ(nilあり)
										(if #opt2$$ ; nil ありえる
											(progn
												(if (assoc #OP_hin #opt2$$)
													(progn
														(if (= 1 (nth 3 (assoc #OP_hin #opt2$$))) ; SET品==>1 それ以外==>0
															(progn
																(setq #price (nth 2 (assoc #OP_hin #opt2$$)))
																(setq #OP_hin (strcat #OP_hin "@" #price))
																(setq #OPT_SET_OK T)   ; SET品にする
															)
															;else
															(setq #OPT_SET_OK nil) ; SET品にしない
														);_if
													)
												);_if
											)
										);_if
										; 03/06/18 YM ADD-E

										(if #OPT_SET_OK ; ｾｯﾄ構成可能
											(repeat #OP_num
												(setq #option$ (append #option$ (list (list #OP_hin nil))))
											)
										);_if
									);repeat
								)
							);_if
						);foreach
						(setq #SetHinOK$ (append #SetHinOK$ #option$))

						(setq #Dummy$$ (append #Dummy$$
							(list
								(list #SetCode #WT_HINBAN$ #SetHinOK$)
							)
						)) ; (ｾｯﾄｺｰﾄﾞ,WT品番,(ｾｯﾄ構成品番,ｼﾝﾎﾞﾙ)ﾘｽﾄ)
					)
				);_if
			)
		);_cond
    (setq #i (1+ #i))
  );_repeat

	; ｾｯﾄが複数の場合ｼﾝｸｷｬﾋﾞを含むものを優先優先させる 01/05/31 YM
	(setq #Dummy1$$ nil #Dummy2$$ nil)
	(if #Dummy$$
		(progn
			(foreach #Dummy$ #Dummy$$
				(setq #snkFLG nil)
				(foreach #Dummy (nth 2 #Dummy$)
					(if (and (cadr #Dummy)(CheckSKK$ (cadr #Dummy)(list (itoa CG_SKK_ONE_CAB)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_SNK)))) ; ｼﾝﾎﾞﾙ図形の性格ｺｰﾄﾞﾁｪｯｸ ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
						(setq #snkFLG T)
					);_if
				)
				(if #snkFLG
					(setq #Dummy1$$ (append #Dummy1$$ (list #Dummy$))) ; ｼﾝｸｷｬﾋﾞを含む
					(setq #Dummy2$$ (append #Dummy2$$ (list #Dummy$))) ; ｼﾝｸｷｬﾋﾞを含まない
				);_if
			)
			(setq #Dummy$$ (append #Dummy1$$ #Dummy2$$))
		)
	);_if


	;;; Dummy.cfg に出力
	(if #Dummy$$ (KcWriteSetHIN_Info #Dummy$$)) ; 01/02/16 ｵﾌﾟｼｮﾝ品も出力

;;;example@ Dummy.cfg
;;;example@ ;;; 各物件フォルダに置く
;;;example@ ;;;
;;;example@ ;;; (ｾｯﾄｺｰﾄﾞ,WT品番,ｾｯﾄ構成品ﾘｽﾄ)
;;;example@ ;;;
;;;example@ WTKOSU=1              --- ﾌﾟﾗﾝの数
;;;example@ SetCode=SGISA-255     --- ｾｯﾄｺｰﾄﾞ
;;;example@ WTHIN=SGISA-255T-R-40 --- ﾜｰｸﾄｯﾌﾟ品番
;;;example@ SINAKOSU=2            --- 構成品の数
;;;example@ HIN=GGT-120           --- 構成品品番名称1
;;;example@ HIN=GS-135A           --- 構成品品番名称2 ,..構成品の数繰り返す
;;;example@ ;;;END

	; #SetHinOK$ はｾｯﾄ品なので見積りで全角ｽﾍﾟｰｽ分字下げする(ｿｰﾄに影響せずまとめて表示)
	;;; Dummy.cfg,Table.cfgからｾｯﾄ構成品を考慮したTable.cfgを作成
	(KcChangeTableCFGbySetInfo) ; 02/01 YM

	(setq CG_SetHIN nil) ; ｾｯﾄ構成品確認ｺﾏﾝﾄﾞ実行中 01/05/15 YM

	; 後処理
  (setq *error* nil)
	;;; ｼｽﾃﾑ変数設定
	(setvar "OSMODE"    #os)
	(setvar "SNAPMODE"  #sm)
	(setvar "ORTHOMODE" #ot)

  (princ)
);SetHINChecksub

;<HOM>*************************************************************************
; <関数名>    : KcSetWTSetCode
; <処理概要>  : "G_WRKT"にｾｯﾄｺｰﾄﾞを使用する
; <戻り値>    : なし
; <作成>      : 01/02/09 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KcSetWTSetCode (
	&WTMR
	&SetCode
  /
	#WT1 #WT2
  )
;//////////////////////////////////////////////////////////////
; [59]にｾｯﾄｺｰﾄﾞをｾｯﾄする
		(defun ##Set ( &WT / )
		  (CFSetXData &WT "G_WRKT"
		    (CFModList (CFGetXData &WT "G_WRKT") (list (list 6 &SetCode)))
		  )
			(princ)
		)
;//////////////////////////////////////////////////////////////
	(##Set &WTMR) ; 1枚目WTにｾｯﾄ
	(setq #WT1 (nth 47 (CFGetXData &WTMR "G_WRKT")))
	(if (and #WT1 (/= #WT1 ""))
		(progn
			(##Set #WT1) ; 2枚目WTにｾｯﾄ
			(setq #WT2 (nth 47 (CFGetXData #WT1 "G_WRKT")))
			(if (and #WT2 (/= #WT2 ""))
				(##Set #WT2) ; 3枚目WTにｾｯﾄ
			);_if
		)
	);_if
	(princ)
);KcSetWTSetCode

;;;<HOM>************************************************************************
;;; <関数名>  : KcChangeTableCFGbySetInfo
;;; <処理概要>: Dummy.cfg,Table.cfgからｾｯﾄ構成品を考慮したTable.cfgを作成
;;; <戻り値>  : なし
;;; <備考>    : 01/05/31 YM ｾｯﾄ複数対応
;;;************************************************************************>MOH<
(defun KcChangeTableCFGbySetInfo (
  /
	#FILE1 #FILE2 #HINMEI #N #RET$ #SC_LIST
	#SETCODE #SPEC1$ #SPEC2$ #SPEC2$$ #STR #KOSU
	#HIN #NO
	#DUM$ #FP #I #LST$ #S #SPEC2_DUM$ ; 01/05/31 YM
  )
		;////////////////////////////////////////
		(defun ##GetstrNUM ( &moji &str ; &moji が &str の左から何番目か
			/
			#I #LOOP #RET #STR
			)
			(setq #i 1 #loop T #ret nil)
			(while (and #loop (< #i (1+ (strlen &str))))
				(setq #str (substr &str #i 1))
				(if (= #str &moji)(setq #ret #i #loop nil))
				(setq #i (1+ #i))
			)
			#ret
		)
		;////////////////////////////////////////

;//////////////////////////////////////////////////
; 個数>1なら要素を増やし個数=1になるようにする
;//////////////////////////////////////////////////
		(defun ##BUNKAI ( &lis$ / #RET$ #F #KOSU)
			(setq #ret$ nil)
			(foreach #e &lis$
				(setq #kosu (atoi (nth 4 #e)))
				(if (> #kosu 1)
					(progn
			      (setq #f
						 	(CFModList #e
				        (list (list 4 "1"))
				      )
						)
					 	(repeat #kosu ; 個数
							(setq #ret$ (append #ret$ (list #f)))
						)
					)
					(setq #ret$ (append #ret$ (list #e)))
				);_if
			);foreach
			#ret$
		);##BUNKAI
;//////////////////////////////////////////////////
; 同じ品番なら個数を増やす
;//////////////////////////////////////////////////
		(defun ##MATOME ( &lis$ /	#F #FNEW #HIN #HIN$ #I #LOOP #RET$ #kosu)
			(setq #ret$ nil #hin$ nil)
			(foreach #e &lis$
				(setq #hin (nth 1 #e))

				; 02/03/16 YM AMOD-S
				(if (member #hin #hin$)
				; 02/03/16 YM AMOD-E

;;;02/03/16YM@MOD				(if (and (member #hin #hin$)
;;;02/03/16YM@MOD								 (/= (substr #hin 1 2) "ﾄｸ"))

					(progn ; 同じものあり
						(setq #loop T #i 0)
						(setq #kosu (length #ret$))
						(while (and #loop (< #i #kosu))
							(setq #f (nth #i #ret$))
							(if (= (nth 1 #f) #hin)
								(progn
									(setq #loop nil)
						      (setq #fnew
									 	(CFModList #f
							        (list (list 4 (itoa (1+ (atoi (nth 4 #f)))))) ; 個数+1
							      )
									)
								)
							);_if
							(setq #i (1+ #i))
						)
						(setq #ret$ (subst #fnew #f #ret$)) ; 要素入替え
					)
					(progn ; 初めて
						(setq #hin$ (append #hin$ (list	(nth 1 #e)))) ; 品番ﾘｽﾄ
						(setq #ret$ (append #ret$ (list #e)))
					)
				);_if
			)
			#ret$
		);##MATOME
;//////////////////////////////////////////////////
; ﾘｽﾄから最初に見つかった要素を削除したﾘｽﾄを返す
; nth 0,1,2を比較して一致するか判定
;//////////////////////////////////////////////////
		(defun ##DEL_ELEM ( &lis &elm / #LOOP #RET$)
			(setq #loop nil #ret$ nil)
			(foreach #lis &lis
				(if (and (= (nth 0 #lis)(nth 0 &elm))  ; 通番
								 (= (nth 1 #lis)(nth 1 &elm))) ; 品番
					(progn
						(if #loop
							(setq #ret$ (append #ret$ (list #lis)))
						);_if
						(setq #loop T)
					)
					(setq #ret$ (append #ret$ (list #lis)))
				);_if
			)
			#ret$
		);##DEL_ELEM

;//////////////////////////////////////////////////
; &lis1$　からｾｯﾄ構成品 &lis2$ を抜き取る
;//////////////////////////////////////////////////
		(defun ##NUKITORI ( &lis1$ &lis2$
			/
			#FLG #HIN #RET1$ #RET2$ #DUM$ #I #LIS1 #LOOP
		  #N #PRICE #lis1$
			)
			(setq #lis1$ nil)
;;;(KP_DelHinbanKakko )
			(foreach #dum &lis1$
				(if (and (<= 100 (atoi (nth 5 #dum))) ; ﾌﾗｸﾞ100以上
						(= nil (##GetstrNUM "@" (nth 1 #dum)))) ; 既に@価格になってない
					(setq #lis1$ (append #lis1$
						(list
						 	(CFModList #dum
								;03/11/29 YM MOD 品番の()を外す処理追加→やめて元のまま特注品番をいじってはいけない
								;&lis2$ の方の品番に()がないのが問題
;;;				        (list (list 1 (strcat (KP_DelHinbanKakko (nth 1 #dum)) "@" (nth 8 #dum)))) ; 個数+1
				        (list (list 1 (strcat (nth 1 #dum) "@" (nth 8 #dum)))) ; 個数+1
				      )
						)
				 	))
					(setq #lis1$ (append #lis1$ (list #dum)))
				);_if
			)
			(setq #ret1$ nil #ret2$ nil #ret1$ #lis1$)
			(foreach #lis2 &lis2$ ; #lis1$ はﾙｰﾌﾟ毎に要素が減る
				(setq #i 0 #loop T #del_flg nil);03/11/29 YM ADD #del_flg追加
				(while (and #loop (< #i (length #lis1$)))
					(setq #lis1 (nth #i #lis1$))
					(if (= #lis2 (KP_DelDrSeri_sub (nth 1 #lis1) 1)) ; []なし+L/R 01/10/31 YM MOD
;;;01/10/31YM@DEL					(if (= #lis2 (nth 1 #lis1))
						(progn
				      (setq #lis1
							 	(CFModList #lis1
					        (list (list 2 (strcat "　" (nth 2 #lis1)))) ; 品番全角字下げ
				      ))
							(setq #ret2$ (append #ret2$ (list #lis1))) ; SET構成品(品番全角字下げ)
							(setq #del_flg T)
							(setq #loop nil)
						)
					);_if
					(setq #i (1+ #i))
				);while
				;03/11/29 YM if文 #del_flg 追加
				(if #del_flg
					(setq #lis1$ (##DEL_ELEM #lis1$ #lis1)) ; #lis1$ から#lis1を除く(一度選ばれたものは除外する)
				);_if
			);foreach

			(foreach #lis #ret2$
				(setq #dum$ (##DEL_ELEM #ret1$ #lis))
				(setq #ret1$ #dum$)
			)
			(list #ret1$ #ret2$)
		);##NUKITORI

;//////////////////////////////////////////////////
; ｿｰﾄのため nth 0 を整数にする
;//////////////////////////////////////////////////
		(defun ##INT0 ( &lis$
			/
			#DUM$
			)
			(setq #dum$ nil)
			(foreach #spec2 &lis$
	      (setq #spec2
				 	(CFModList #spec2
		        (list (list 0 (atoi (nth 0 #spec2))))
	      ))
				(setq #dum$ (append #dum$ (list #spec2)))
			)
			#dum$
		);##INT0

;//////////////////////////////////////////////////
; ｾｯﾄｺｰﾄﾞ行を追加する(Lipple 以外)
;//////////////////////////////////////////////////
		(defun ##AddSetCode ( &lis$ &SetCode
			/
			#DUM$ #HINMEI #SC_LIST
			)
			(setq #HINMEI (vl-string-right-trim "ワークトップ" (nth 2 (nth 0 &lis$)) ))
			(setq #HINMEI (strcat #HINMEI "ベースセット"))   ; "ワークトップ"==>"ベースセット"
			(setq #HINMEI (vl-string-subst "" "　" #HINMEI)) ; 全角ｽﾍﾟｰｽ削除
			(setq #SC_list
				(list
				 &SetCode ; ｾｯﾄｺｰﾄﾞ
				 #HINMEI  ; 品名
				 "0"      ; LR有無
				 "1"      ; 数量
				 "1"      ; ﾌﾗｸﾞ
				 "1"      ; 集約ID
				 ""       ; 寸法
				 "0"      ; 単価
				)
			)
			(setq #dum$ (cons #SC_list &lis$))
		);##AddSetCode

;//////////////////////////////////////////////////
; ｾｯﾄｺｰﾄﾞ行を追加する(Lipple)
;//////////////////////////////////////////////////
		(defun ##AddSetCode2 ( &lis$ &SetCode
			/
			#DUM$ #HINMEI #SC_LIST
			)
			(setq #HINMEI "ベースセット")
			(setq #SC_list
				(list
				 &SetCode ; ｾｯﾄｺｰﾄﾞ
				 #HINMEI  ; 品名
				 "0"      ; LR有無
				 "1"      ; 数量
				 "1"      ; ﾌﾗｸﾞ
				 "1"      ; 集約ID
				 ""       ; 寸法
				 "0"      ; 単価
				)
			)
			(setq #dum$ (cons #SC_list &lis$))
		);##AddSetCode2

;//////////////////////////////////////////////////

	;Table.cfgファイル読込み
  (setq #file1 (strcat CG_KENMEI_PATH "Table.cfg"))
  (setq #file2 (strcat CG_KENMEI_PATH "Dummy.cfg"))
	(setq #spec1$ nil #spec2$$ nil)
  (if (findfile #file1)
		(progn
			(setq #spec1$  (ReadCSVFile #file1))
;;;			; 01/10/31 YM ADD-S
;;;			(setq #spec1$ (KP_DelDrSeri #spec1$ 1)) ; []部なくしてあれば"L/R"を付ける
;;;			; 01/10/31 YM ADD-E
		)
	);if
  (if (findfile #file2)(setq #spec2$$ (ReadCSVFile #file2)))

	(if #spec2$$ ; ｾｯﾄ品があれば
		(progn
			; 個数>1なら要素を増やし個数=1になるようにする
			(setq #spec1$ (##BUNKAI #spec1$))

			; WT複数(ｾｯﾄ構成複数)対応 01/05/31 YM
			(setq #i 0)
			(repeat (/ (length #spec2$$) 2)
				(setq #SetCode (car (nth (* #i 2) #spec2$$)))
				(setq #spec2_dum$  (nth (1+ (* 2 #i)) #spec2$$)) ; ｾｯﾄ品のかたまり
				; ｾｯﾄ構成品を抜き取る
				(setq #ret$ (##NUKITORI #spec1$ #spec2_dum$))
				(setq #spec1$ (car  #ret$)) ; ﾙｰﾌﾟ中毎回要素数は減少する
				; 同じ品番なら個数を増やす(WTも同じ扱い)
				(setq #dum$ (##MATOME (cadr #ret$)))
				;ｿｰﾄのため nth 0 を整数にする 01/03/05 YM ADD
				(setq #dum$ (##INT0 #dum$))
				;nth 0 でｿｰﾄする
				(setq #dum$ (CFListSort #dum$ 0))

				; Lipple以外はｾｯﾄｺｰﾄﾞ行を追加する
				(if (equal 2 (KPGetSinaType) 0.1)
					(setq #dum$ (##AddSetCode2 #dum$ #SetCode)) ; Lipple
					(setq #dum$ (##AddSetCode  #dum$ #SetCode))
				);_if

				(setq #spec2$ (append #spec2$ #dum$)) ; 累積させる
				(setq #i (1+ #i))
			);repeat

			; 先頭の番号書き換え
			(setq #n 1 #ret$ nil)
			(foreach #spec2 #spec2$
				(if (= 'INT (type (nth 0 #spec2)))
					(progn ; ｾｯﾄｺｰﾄﾞ行以外
						(setq #spec2 (cdr #spec2))
						(setq #hin (nth 0 #spec2)) ; 品番名称
						(setq #no (##GetstrNUM "@" #hin)) ; 特注ｷｬﾋﾞは品番から@価格を除く
						(if #no
							(progn
								(setq #hin (substr #hin 1 (1- #no)))
							 	(setq #spec2 (CFModList #spec2
					        (list (list 0 #hin))
					      ))
							)
						);_if
					)
				);_if
				(setq #ret$ (append #ret$	(list (cons (itoa #n) #spec2))))
				(setq #n (1+ #n)) ; この変数#nは下で引き続き使用する
			)

			; 同じ品番なら個数を増やす(WTも同じ扱い)
			(setq #spec1$ (##MATOME #spec1$))
			; 先頭の番号削除
			(setq #spec1$ (mapcar 'cdr #spec1$))

			; 先頭の番号書き換え(ｾｯﾄ品以外)
			(foreach #spec1 #spec1$
				(setq #hin (nth 0 #spec1)) ; 品番名称
				(setq #no (##GetstrNUM "@" #hin)) ; 特注ｷｬﾋﾞは品番から@価格を除く
				(if #no
					(progn
						(setq #hin (substr #hin 1 (1- #no)))
					 	(setq #spec1 (CFModList #spec1
			        (list (list 0 #hin))
			      ))
					)
				);_if
				(setq #ret$ (append #ret$	(list (cons (itoa #n) #spec1))))
				(setq #n (1+ #n))
			)

;;;01/05/31YM@			(setq #SetCode (car (car #spec2$$)))
;;;01/05/31YM@			(setq #spec2$  (cadr #spec2$$))
;;;01/05/31YM@			; 個数>1なら要素を増やし個数=1になるようにする
;;;01/05/31YM@			(setq #spec1$ (BUNKAI #spec1$))
;;;01/05/31YM@			; ｾｯﾄ構成品を抜き取る
;;;01/05/31YM@			(setq #ret$ (##NUKITORI #spec1$ #spec2$))
;;;01/05/31YM@			(setq #spec1$ (car  #ret$))
;;;01/05/31YM@			(setq #spec2$ (cadr #ret$))
;;;01/05/31YM@			; 同じ品番なら個数を増やす(WTも同じ扱い) 01/02/01 YM
;;;01/05/31YM@			(setq #spec1$ (##MATOME #spec1$))
;;;01/05/31YM@			(setq #spec2$ (##MATOME #spec2$))
;;;01/05/31YM@			;ｿｰﾄのため nth 0 を整数にする 01/03/05 YM ADD
;;;01/05/31YM@			(Setq #dum$ nil)
;;;01/05/31YM@			(foreach #spec2 #spec2$
;;;01/05/31YM@	      (setq #spec2
;;;01/05/31YM@				 	(CFModList #spec2
;;;01/05/31YM@		        (list (list 0 (atoi (nth 0 #spec2))))
;;;01/05/31YM@	      ))
;;;01/05/31YM@				(setq #dum$ (append #dum$ (list #spec2)))
;;;01/05/31YM@			)
;;;01/05/31YM@			(setq #spec2$ #dum$)
;;;01/05/31YM@			;nth 0 でｿｰﾄする 01/03/05 YM ADD
;;;01/05/31YM@			(setq #spec2$ (CFListSort #spec2$ 0))
;;;01/05/31YM@
;;;01/05/31YM@			; 先頭の番号削除
;;;01/05/31YM@			(setq #spec1$ (mapcar 'cdr #spec1$))
;;;01/05/31YM@			(setq #spec2$ (mapcar 'cdr #spec2$))
;;;01/05/31YM@		;;;	(setq #dtlst$$ (ListSortLevel2 #dtlst$$ 10 0))
;;;01/05/31YM@
;;;01/05/31YM@			; 先頭に品番基本.ｿｰﾄｷｰを追加
;;;01/05/31YM@		;;;	(setq #spec1$ (KcAddSortKey #spec1$))
;;;01/05/31YM@		;;;	(setq #spec1$ (ListSortLevel2 #dtlst$$ 5 0)) ; 集約ID,ｿｰﾄｷｰでｿｰﾄする
;;;01/05/31YM@			; 先頭の番号削除
;;;01/05/31YM@		;;;	(setq #spec1$ (mapcar 'cdr #spec1$))
;;;01/05/31YM@
;;;01/05/31YM@			(setq #HINMEI (vl-string-right-trim "ワークトップ" (nth 1 (nth 0 #spec2$)) ))
;;;01/05/31YM@			(setq #HINMEI (strcat #HINMEI "ベースセット"))   ; "ワークトップ"==>"ベースセット"
;;;01/05/31YM@			(setq #HINMEI (vl-string-subst "" "　" #HINMEI)) ; 全角ｽﾍﾟｰｽ削除
;;;01/05/31YM@			; Table.cfg のﾍｯﾀﾞｰにｾｯﾄｺｰﾄﾞ行を追加する
;;;01/05/31YM@			(setq #SC_list
;;;01/05/31YM@				 (list
;;;01/05/31YM@;;;					 "1"      ; 番号
;;;01/05/31YM@					 #SetCode ; ｾｯﾄｺｰﾄﾞ
;;;01/05/31YM@					 #HINMEI  ; 品名
;;;01/05/31YM@					 "0"      ; LR有無
;;;01/05/31YM@					 "1"      ; 数量
;;;01/05/31YM@					 "1"      ; ﾌﾗｸﾞ
;;;01/05/31YM@					 "1"      ; 集約ID
;;;01/05/31YM@					 ""       ; 寸法
;;;01/05/31YM@					 "0"      ; 単価
;;;01/05/31YM@				 )
;;;01/05/31YM@			)
;;;01/05/31YM@			(setq #spec2$ (cons #SC_list #spec2$))
;;;01/05/31YM@
;;;01/05/31YM@			; 先頭の番号書き換え
;;;01/05/31YM@			(setq #n 1 #ret$ nil)
;;;01/05/31YM@			(foreach #spec2 #spec2$
;;;01/05/31YM@				(setq #hin (nth 0 #spec2)) ; 品番名称
;;;01/05/31YM@				(setq #no (##GetstrNUM "@" #hin)) ; 特注ｷｬﾋﾞは品番から@価格を除く
;;;01/05/31YM@				(if #no
;;;01/05/31YM@					(progn
;;;01/05/31YM@						(setq #hin (substr #hin 1 (1- #no)))
;;;01/05/31YM@					 	(setq #spec2 (CFModList #spec2
;;;01/05/31YM@			        (list (list 0 #hin))
;;;01/05/31YM@			      ))
;;;01/05/31YM@					)
;;;01/05/31YM@				);_if
;;;01/05/31YM@				(setq #ret$ (append #ret$	(list (cons (itoa #n) #spec2))))
;;;01/05/31YM@				(setq #n (1+ #n))
;;;01/05/31YM@			)
;;;01/05/31YM@			(foreach #spec1 #spec1$
;;;01/05/31YM@				(setq #hin (nth 0 #spec1)) ; 品番名称
;;;01/05/31YM@				(setq #no (##GetstrNUM "@" #hin)) ; 特注ｷｬﾋﾞは品番から@価格を除く
;;;01/05/31YM@				(if #no
;;;01/05/31YM@					(progn
;;;01/05/31YM@						(setq #hin (substr #hin 1 (1- #no)))
;;;01/05/31YM@					 	(setq #spec1 (CFModList #spec1
;;;01/05/31YM@			        (list (list 0 #hin))
;;;01/05/31YM@			      ))
;;;01/05/31YM@					)
;;;01/05/31YM@				);_if
;;;01/05/31YM@				(setq #ret$ (append #ret$	(list (cons (itoa #n) #spec1))))
;;;01/05/31YM@				(setq #n (1+ #n))
;;;01/05/31YM@			)

		  ;仕様表書き出し
		  (setq #fp  (open #file1 "w"))
		  (if (/= nil #fp)
		    (progn
		      (mapcar
		       '(lambda ( #Lst$ )
		          (setq #sTr "")
		          (mapcar
		           '(lambda ( #s )
		              (cond
		                ((= 'INT (type #s))
		                  (setq #s (itoa #s))
		                )
		                ((/= 'STR (type #s))
		                  (setq #s "")
		                )
		                ((= 'STR (type #s))
		                  (setq #s (DelFrontLastSpace #s))
		                )
		              )
		              (setq #sTr (strcat #sTr #s ","))
		            )
		            #Lst$
		          )
		          (princ (strcat (substr #sTr 1 (1- (strlen #sTr))) "\n") #fp)
		        )
		        #ret$
		      )
		    )
		  )
		  (close #fp)
		)
		(princ) ; ｾｯﾄ品がなければ何もしない
	);_if
  (princ)
);KcChangeTableCFGbySetInfo

;<HOM>*************************************************************************
; <関数名>    : KcAddSortKey
; <処理概要>  : ﾘｽﾄのﾘｽﾄにおいて、各ﾘｽﾄの先頭に品番基本.
; <戻り値>    : なし
; <作成>      : 00/01/31 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KcAddSortKey (
	&lst$$
  /
	#ret$ #HIN #KEY #QRY$ #RET$$
  )
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(defun ##DEL_LR ( &HIN / )
		(substr &HIN 1 (1- (strlen &HIN)))
	);##DEL_LR
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(setq #ret$$ nil)
  (foreach #lst$ &lst$$
		(setq #ret$ nil)
		(if (= (nth 4 #lst$) "1") ; WT
			(progn
				(setq #key "0")
			)
			(progn
				(if (= (nth 2 #lst$) "1")
					(setq #HIN (##DEL_LR (nth 0 #lst$))) ; LR区分あり==>品番から"L"/"R"を削除した品番で検索
					(setq #HIN (nth 0 #lst$))            ; そのまま
				);_if
		    (setq #qry$ ;// 『品番基本』を取得する
		      (car
		        (CFGetDBSQLHinbanTable "品番基本"
		          #HIN
		          (list (list "品番名称" #HIN 'STR))
		        )
		      )
		    )
				(setq #key (itoa (fix (nth 2 #qry$))))
			)
		);_if
		(setq #ret$ (cons #key #lst$)) ; ｿｰﾄｷｰ
		(setq #ret$$ (append #ret$$ (list #ret$)))
	)
	#ret$$
);KcAddSortKey

;<HOM>*************************************************************************
; <関数名>    : KcWriteSetHIN_Info
; <処理概要>  : (ｾｯﾄｺｰﾄﾞ,WT品番,ｾｯﾄ構成品ﾘｽﾄ)をDummy.cfgに出力
; <戻り値>    : なし
; <作成>      : 00/01/31 YM
; <備考>      : 01/02/16 YM ｵﾌﾟｼｮﾝ品も出力
;*************************************************************************>MOH<
(defun KcWriteSetHIN_Info (
	&Dummy$$
  /
	#FP #I #KOSU #SetCode #SETHIN$ #SFNAME #SINAKOSU #WTHIN #WTHIN$
	#HIN #LR #SYM #J #OPTION$ #OP_HIN #OP_NUM #XDOPT$ #xdOPT_$
  )
  (setq #sFname (strcat CG_KENMEI_PATH "Dummy.CFG"))
  (setq #fp  (open #sFname "w"))
	(setq #j 0)
	(foreach #Dummy$ &Dummy$$
		(setq #SetCode (nth 0 #Dummy$)) ; ｾｯﾄｺｰﾄﾞ+" "+扉ｶﾗｰ(ﾕｰｻﾞｰ手入力変更あり)
		(setq #WTHIN$  (nth 1 #Dummy$)) ; WT品番ﾘｽﾄ
		(setq #SetHIN$ (nth 2 #Dummy$)) ; SET品番,ｼﾝﾎﾞﾙﾘｽﾄ

		(princ (strcat #SetCode "\n") #fp)
		(foreach #e #WTHIN$	 (princ (strcat #e ",") #fp)) ; Lippleのときは出力しない

;;;01/03/02YM@		; ｵﾌﾟｼｮﾝ品追加
;;;01/03/02YM@ 		(setq #option$ nil)
;;;01/03/02YM@		(foreach #e$ #SetHIN$
;;;01/03/02YM@			(setq #sym (cadr #e$))
;;;01/03/02YM@			(if (setq #xdOPT$ (CFGetXData #sym "G_OPT"))
;;;01/03/02YM@				(progn ; ｵﾌﾟｼｮﾝ品あり
;;;01/03/02YM@			    (setq #xdOPT_$ #xdOPT$)
;;;01/03/02YM@			    (repeat (car #xdOPT$)
;;;01/03/02YM@			      (setq #xdOPT_$ (cdr #xdOPT_$))
;;;01/03/02YM@			      (setq #OP_hin  (car #xdOPT_$)) ;品番
;;;01/03/02YM@			      (setq #xdOPT_$ (cdr #xdOPT_$))
;;;01/03/02YM@			      (setq #OP_num  (car #xdOPT_$)) ;個数
;;;01/03/02YM@						(repeat #OP_num
;;;01/03/02YM@							(setq #option$ (append #option$ (list (list #OP_hin nil))))
;;;01/03/02YM@						)
;;;01/03/02YM@					);repeat
;;;01/03/02YM@				)
;;;01/03/02YM@			);_if
;;;01/03/02YM@		);foreach
;;;01/03/02YM@
;;;01/03/02YM@		(setq #SetHIN$ (append #SetHIN$ #option$))

		(setq #i 0)
		(foreach #e$ #SetHIN$
			(setq #hin (car  #e$))
			(setq #sym (cadr #e$))
			(if #sym
				(progn
					(if (setq #TOKU (CFGetXData #sym "G_TOKU"))
						(progn
							(setq #price (rtos (nth 1 #TOKU)))
							(setq #LR (nth 6 (CFGetXData #sym "G_LSYM")))
							(setq #hin (strcat #hin "@" #price))
						)
						(progn
							(setq #price nil)
							(setq #LR (nth 6 (CFGetXData #sym "G_LSYM")))
							(if (/= #LR "Z")(setq #hin (strcat #hin #LR)));_if
							(if #price (setq #hin (strcat #hin "@" #price)))
						)
					);_if
				)
				(progn
					nil
				)
			);_if

			(if (= #i (1- (length #SetHIN$)))
				(princ (strcat #hin "\n") #fp)
				(princ (strcat #hin ",") #fp)
			);_if
			(setq #i (1+ #i))
		)

		(setq #j (1+ #j))
	);foreach
  (close #fp)
  (princ)
);KcWriteSetHIN_Info

;;;01/02/02YM@;<HOM>*************************************************************************
;;;01/02/02YM@; <関数名>    : KcWriteSetHIN_Info
;;;01/02/02YM@; <処理概要>  : (ｾｯﾄｺｰﾄﾞ,WT品番,ｾｯﾄ構成品ﾘｽﾄ)をDummy.cfgに出力
;;;01/02/02YM@; <戻り値>    : なし
;;;01/02/02YM@; <作成>      : 00/01/31 YM
;;;01/02/02YM@; <備考>      :
;;;01/02/02YM@;*************************************************************************>MOH<
;;;01/02/02YM@(defun KcWriteSetHIN_Info (
;;;01/02/02YM@	&Dummy$$
;;;01/02/02YM@  /
;;;01/02/02YM@	#FP #I #KOSU #SETCODE #SETHIN$ #SFNAME #SINAKOSU #WTHIN
;;;01/02/02YM@  )
;;;01/02/02YM@  (setq #sFname (strcat CG_KENMEI_PATH "Dummy.CFG"))
;;;01/02/02YM@  (setq #fp  (open #sFname "w"))
;;;01/02/02YM@	(setq #i 0)
;;;01/02/02YM@	(foreach #Dummy$ &Dummy$$
;;;01/02/02YM@		(setq #SetCode (nth 0 #Dummy$))
;;;01/02/02YM@		(setq #WTHIN$  (nth 1 #Dummy$)) ; WT品番ﾘｽﾄ
;;;01/02/02YM@		(setq #SetHIN$ (nth 2 #Dummy$)) ; SET品番ﾘｽﾄ
;;;01/02/02YM@		(setq #k1 (length #WTHIN$))
;;;01/02/02YM@		(setq #k2 (length #SetHIN$))
;;;01/02/02YM@
;;;01/02/02YM@		(princ (strcat #SetCode ",") #fp)
;;;01/02/02YM@		(princ #k1 #fp)(princ "," #fp)
;;;01/02/02YM@		(foreach #e #WTHIN$	 (princ (strcat #e ",") #fp))
;;;01/02/02YM@		(princ #k2 #fp)(princ "," #fp)
;;;01/02/02YM@		(setq #i 0)
;;;01/02/02YM@		(foreach #e #SetHIN$
;;;01/02/02YM@			(if (= #i (1- #k2))
;;;01/02/02YM@				(princ (strcat #e "\n") #fp)
;;;01/02/02YM@				(princ (strcat #e ",") #fp)
;;;01/02/02YM@			);_if
;;;01/02/02YM@			(setq #i (1+ #i))
;;;01/02/02YM@		)
;;;01/02/02YM@		(setq #i (1+ #i))
;;;01/02/02YM@	)
;;;01/02/02YM@  (close #fp)
;;;01/02/02YM@  (princ)
;;;01/02/02YM@);KcWriteSetHIN_Info

;;;01/02/01YM@;<HOM>*************************************************************************
;;;01/02/01YM@; <関数名>    : KcWriteSetHIN_Info
;;;01/02/01YM@; <処理概要>  : (ｾｯﾄｺｰﾄﾞ,WT品番,ｾｯﾄ構成品ﾘｽﾄ)をDummy.cfgに出力
;;;01/02/01YM@; <戻り値>    : なし
;;;01/02/01YM@; <作成>      : 00/01/31 YM
;;;01/02/01YM@; <備考>      :
;;;01/02/01YM@;*************************************************************************>MOH<
;;;01/02/01YM@(defun KcWriteSetHIN_Info (
;;;01/02/01YM@	&Dummy$$
;;;01/02/01YM@  /
;;;01/02/01YM@	#FP #I #KOSU #SETCODE #SETHIN$ #SFNAME #SINAKOSU #WTHIN
;;;01/02/01YM@  )
;;;01/02/01YM@	(setq #kosu (length &Dummy$$))
;;;01/02/01YM@  (setq #sFname (strcat CG_KENMEI_PATH "Dummy.CFG"))
;;;01/02/01YM@  ;// ヘッダー情報ファイルへの書き込み
;;;01/02/01YM@  (setq #fp  (open #sFname "w"))
;;;01/02/01YM@  (princ   ";;; 各物件フォルダに置く"              #fp)
;;;01/02/01YM@  (princ "\n;;;"                                   #fp)
;;;01/02/01YM@  (princ "\n;;; (ｾｯﾄｺｰﾄﾞ,WT品番ﾘｽﾄ,ｾｯﾄ構成品ﾘｽﾄ)"  #fp)
;;;01/02/01YM@  (princ "\n;;;"                                   #fp)
;;;01/02/01YM@  (princ (strcat "\nKOSU="     (itoa #kosu))       #fp)
;;;01/02/01YM@	(setq #i 0)
;;;01/02/01YM@	(foreach #Dummy$ &Dummy$$
;;;01/02/01YM@		(setq #SetCode (nth 0 #Dummy$))
;;;01/02/01YM@		(setq #WTHIN$  (nth 1 #Dummy$)) ; WT品番ﾘｽﾄ
;;;01/02/01YM@		(setq #SetHIN$ (nth 2 #Dummy$)) ; SET品番ﾘｽﾄ
;;;01/02/01YM@
;;;01/02/01YM@	  (princ (strcat "\nSetCode="  #SetCode)         #fp)
;;;01/02/01YM@
;;;01/02/01YM@  	(princ (strcat "\nKOSU=" (itoa (length #WTHIN$ ))) #fp)
;;;01/02/01YM@		(foreach #elm #WTHIN$	(princ (strcat "\nWTHIN=" #elm) #fp))
;;;01/02/01YM@
;;;01/02/01YM@		(princ (strcat "\nKOSU=" (itoa (length #SetHIN$))) #fp)
;;;01/02/01YM@		(foreach #SetHIN #SetHIN$	(princ (strcat "\nHIN=" #SetHIN) #fp))
;;;01/02/01YM@		(setq #i (1+ #i))
;;;01/02/01YM@	)
;;;01/02/01YM@  (princ "\n;;;END\n"                              #fp)
;;;01/02/01YM@  (close #fp)
;;;01/02/01YM@  (princ)
;;;01/02/01YM@);KcWriteSetHIN_Info

;;;01/02/16YM@;<HOM>*************************************************************************
;;;01/02/16YM@; <関数名>    : KcSetHinListDlg
;;;01/02/16YM@; <処理概要>  : ｾｯﾄ構成品一覧ﾀﾞｲｱﾛｸﾞ表示
;;;01/02/16YM@; <戻り値>    : 確定後のｾｯﾄ品番
;;;01/02/16YM@; <作成>      : 00/01/31 YM
;;;01/02/16YM@; <備考>      : 追加ﾎﾞﾀﾝなしﾀﾞｲｱﾛｸﾞを閉じないﾊﾞｰｼﾞｮﾝ
;;;01/02/16YM@;*************************************************************************>MOH<
;;;01/02/16YM@(defun KcSetHinListDlg (
;;;01/02/16YM@	&SetCode    ; SETｺｰﾄﾞ
;;;01/02/16YM@	&WT_HINBAN$ ; WT品番
;;;01/02/16YM@	&HINSYM$    ; (品番名称,ｼﾝﾎﾞﾙ)ﾘｽﾄ
;;;01/02/16YM@  /
;;;01/02/16YM@	#DCL_ID #LIS$ #POP$ #RET$
;;;01/02/16YM@	#i #N #SETCODE #WHAT_NEXT
;;;01/02/16YM@  )
;;;01/02/16YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/02/16YM@          (defun ##GetDlgItem ( / #setcode)
;;;01/02/16YM@						(setq #setcode (get_tile "setcode"))
;;;01/02/16YM@            (done_dialog 1)
;;;01/02/16YM@            (list #pop$ #setcode); (品番,ｼﾝﾎﾞﾙ)形式のﾘｽﾄ
;;;01/02/16YM@          );##GetDlgItem
;;;01/02/16YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/02/16YM@;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ表示 引数は(品番,ｼﾝﾎﾞﾙ)形式
;;;01/02/16YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/02/16YM@          (defun ##Addpop0 ( &LIS$ / )
;;;01/02/16YM@						(setq #pop$ nil)
;;;01/02/16YM@					  (start_list "LIST" 3)
;;;01/02/16YM@;;;						(add_list &WT_HINBAN) ; 01/02/01 YM ADD
;;;01/02/16YM@					  (foreach #lis &LIS$
;;;01/02/16YM@					    (add_list (car #lis))
;;;01/02/16YM@							(setq #pop$ (append #pop$ (list #lis))) ;表示内容保存(品番,ｼﾝﾎﾞﾙ)形式(赤色)
;;;01/02/16YM@					  )
;;;01/02/16YM@					  (end_list)
;;;01/02/16YM@						(set_tile "LIST" "0") ; 最初にﾌｫｰｶｽ
;;;01/02/16YM@						(princ)
;;;01/02/16YM@          );##Addpop0
;;;01/02/16YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/02/16YM@          (defun ##DELETE (
;;;01/02/16YM@						/
;;;01/02/16YM@						#n #flg #COL #EG #ELM #I #K #LAYER #LAY_EN #LIS$ #SS
;;;01/02/16YM@						) ; 現在行削除+色を戻す
;;;01/02/16YM@						(setq #n (atoi (get_tile "LIST")))
;;;01/02/16YM@						(setq #i 0 #LIS$ nil)
;;;01/02/16YM@						(foreach #pop #pop$ ; (品番,ｼﾝﾎﾞﾙ)形式
;;;01/02/16YM@							(if (= #i #n)
;;;01/02/16YM@								(progn ; ﾕｰｻﾞｰ選択行
;;;01/02/16YM@									(if (equal CG_BASESYM (cadr #pop)) ;基準ｱｲﾃﾑ
;;;01/02/16YM@										(setq #flg nil #COL 3) ; "GREEN" CG_BaseSymCol
;;;01/02/16YM@										(setq #flg T) ;基準ｱｲﾃﾑでない
;;;01/02/16YM@									);_if
;;;01/02/16YM@
;;;01/02/16YM@									(setq #ss (CFGetSameGroupSS (cadr #pop))) ; 同一グループ内の全図形選択セット
;;;01/02/16YM@									(setq #k 0)
;;;01/02/16YM@									(repeat (sslength #ss)
;;;01/02/16YM@										(setq #elm (ssname #ss #k))
;;;01/02/16YM@										(setq #eg (entget #elm))
;;;01/02/16YM@										(if #flg ; 基準ｼﾝﾎﾞﾙでない"BYLAYER"
;;;01/02/16YM@											(progn
;;;01/02/16YM@												(setq #layer (cdr (assoc 8 #eg)))
;;;01/02/16YM@												(setq #lay_en (tblobjname "LAYER" #layer))
;;;01/02/16YM@												(setq #COL (cdr (assoc 62 (entget #lay_en)))) ; layer の色
;;;01/02/16YM@											)
;;;01/02/16YM@										);_if
;;;01/02/16YM@										(setq #eg (subst (cons 62 #COL) (assoc 62 #eg) #eg ))
;;;01/02/16YM@										(entmod #eg)
;;;01/02/16YM@										(setq #k (1+ #k))
;;;01/02/16YM@									)
;;;01/02/16YM@									(setq #del$ (append #del$ (list #pop)))	; 色が白くなったもの
;;;01/02/16YM@								)
;;;01/02/16YM@								(setq #lis$ (append #lis$ (list #pop)))
;;;01/02/16YM@							);_if
;;;01/02/16YM@							(setq #i (1+ #i))
;;;01/02/16YM@						)
;;;01/02/16YM@						(redraw)
;;;01/02/16YM@						(##Addpop0 #lis$) ; 行削除後ﾘｽﾄ表示
;;;01/02/16YM@						(princ)
;;;01/02/16YM@          );##DELETE
;;;01/02/16YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/02/16YM@          (defun ##RESET ( ; 初期状態(赤く)
;;;01/02/16YM@						/
;;;01/02/16YM@						#n #COL #EG #ELM #FLG #I #K #SS
;;;01/02/16YM@						) ; 元の状態に戻す
;;;01/02/16YM@						(setq #i 0)
;;;01/02/16YM@						(foreach #pop #del$ ; (品番,ｼﾝﾎﾞﾙ)形式(色を白くしたもの対象)
;;;01/02/16YM@							(setq #flg nil #COL 1) ; "RED"
;;;01/02/16YM@							(setq #ss (CFGetSameGroupSS (cadr #pop))) ; 同一グループ内の全図形選択セット
;;;01/02/16YM@							(setq #k 0)
;;;01/02/16YM@							(repeat (sslength #ss)
;;;01/02/16YM@								(setq #elm (ssname #ss #k))
;;;01/02/16YM@								(setq #eg (entget #elm))
;;;01/02/16YM@								(setq #eg (subst (cons 62 #COL) (assoc 62 #eg) #eg ))
;;;01/02/16YM@								(entmod #eg)
;;;01/02/16YM@								(setq #k (1+ #k))
;;;01/02/16YM@							)
;;;01/02/16YM@							(setq #i (1+ #i))
;;;01/02/16YM@						)
;;;01/02/16YM@						(redraw)
;;;01/02/16YM@						(setq #del$ nil) ; 色が白くなったもの
;;;01/02/16YM@						(##Addpop0 &HINSYM$) ; 初期ﾘｽﾄ表示
;;;01/02/16YM@						(princ)
;;;01/02/16YM@          );##DELETE
;;;01/02/16YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/02/16YM@
;;;01/02/16YM@  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
;;;01/02/16YM@  (if (not (new_dialog "SetHinListDlg" #dcl_id)) (exit))
;;;01/02/16YM@
;;;01/02/16YM@	; ｾｯﾄｺｰﾄﾞを表示
;;;01/02/16YM@	(set_tile "setcode" &SetCode)
;;;01/02/16YM@	; ﾜｰｸﾄｯﾌﾟ品番を表示
;;;01/02/16YM@	(set_tile "txt_WTHIN1" (strcat "ワークトップ品番： " (nth 0 &WT_HINBAN$)))
;;;01/02/16YM@	(if (nth 1 &WT_HINBAN$)
;;;01/02/16YM@		(set_tile "txt_WTHIN2" (strcat "ワークトップ品番： " (nth 1 &WT_HINBAN$)))
;;;01/02/16YM@	)
;;;01/02/16YM@	(if (nth 2 &WT_HINBAN$)
;;;01/02/16YM@		(set_tile "txt_WTHIN3" (strcat "ワークトップ品番： " (nth 2 &WT_HINBAN$)))
;;;01/02/16YM@	)
;;;01/02/16YM@	; 初期ﾀﾞｲｱﾛｸﾞﾘｽﾄ作成
;;;01/02/16YM@	(setq #pop$ nil #del$ nil)
;;;01/02/16YM@	(##Addpop0 &HINSYM$)
;;;01/02/16YM@
;;;01/02/16YM@  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
;;;01/02/16YM@  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
;;;01/02/16YM@  (action_tile "delete" "(##DELETE)")
;;;01/02/16YM@  (action_tile "reset"  "(##RESET)")
;;;01/02/16YM@  (action_tile "cancel" "(setq #ret$ \"CANSEL\")(done_dialog)")
;;;01/02/16YM@  (start_dialog)
;;;01/02/16YM@  (unload_dialog #dcl_id)
;;;01/02/16YM@  #ret$ ; 戻り値
;;;01/02/16YM@);KcSetHinListDlg

;<HOM>*************************************************************************
; <関数名>    : KcSetHinListDlg
; <処理概要>  : ｾｯﾄ構成品一覧ﾀﾞｲｱﾛｸﾞ表示
; <戻り値>    : 確定後のｾｯﾄ品番
; <作成>      : 00/01/31 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KcSetHinListDlg (
	&SetCode    ; SETｺｰﾄﾞ
	&WT_HINBAN$ ; WT品番
	&HINSYM$    ; (品番名称,ｼﾝﾎﾞﾙ)ﾘｽﾄ
  /
	#CHECK$ #DCL_ID #EN #I #LIS$ #LOOP #NEWHLN$ #NEWSYM #RET$ #WHAT_NEXT
	#N #POP$
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( / #setcode)
						(setq #setcode (get_tile "setcode"))
            (done_dialog 1)
            (list #pop$ #setcode); (品番,ｼﾝﾎﾞﾙ)形式のﾘｽﾄ
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ表示 引数は(品番,ｼﾝﾎﾞﾙ)形式
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop0 ( &LIS$ &nn / )
						(setq #pop$ nil)
					  (start_list "LIST" 3)
;;;						(add_list &WT_HINBAN) ; 01/02/01 YM ADD
					  (foreach #lis &LIS$
					    (add_list (car #lis))
							(setq #pop$ (append #pop$ (list #lis))) ;表示内容保存(品番,ｼﾝﾎﾞﾙ)形式
					  )
					  (end_list)
						(set_tile "LIST" (itoa &nn)) ; 最初にﾌｫｰｶｽ
						(princ)
          );##Addpop0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##NOWROW ( / ) ; 現在行
						(setq #n (atoi (get_tile "LIST")))
          );##DeleteRow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(setq #screenPT '(-1 -1)) ; 03/03/27 YM ADD

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
	(setq #what_next 2)
	(while (>= #what_next 2)
	  (if (not (new_dialog "SetHinListDlg" #dcl_id "" #screenPT)) (exit))

		; ｾｯﾄｺｰﾄﾞを表示
		(set_tile "setcode" &SetCode)
		; ﾜｰｸﾄｯﾌﾟ品番を表示
		(if (and &WT_HINBAN$ (= (type &WT_HINBAN$) 'LIST))
			(progn
				(if (nth 0 &WT_HINBAN$)
					(set_tile "txt_WTHIN1" (strcat "ワークトップ品番： " (nth 0 &WT_HINBAN$)))
				)
				(if (nth 1 &WT_HINBAN$)
					(set_tile "txt_WTHIN2" (strcat "ワークトップ品番： " (nth 1 &WT_HINBAN$)))
				)
				(if (nth 2 &WT_HINBAN$)
					(set_tile "txt_WTHIN3" (strcat "ワークトップ品番： " (nth 2 &WT_HINBAN$)))
				)
			)
		);_if

		; 初期ﾀﾞｲｱﾛｸﾞﾘｽﾄ作成
		(setq #pop$ nil)
		(cond
			((= #what_next 4) ; 削除
		 		(##Addpop0 #lis$
					(if (< 0 #n)
						(1- #n)
						0
					);_if
				)
			 	(setq #lis$ nil)
		 	)
			((= #what_next 5) ; 追加
		 		(##Addpop0 #lis$ (1- (length #lis$)))
			 	(setq #lis$ nil)
		 	)
			((= #what_next 6) ; ﾘｾｯﾄ
		 		(##Addpop0 &HINSYM$ 0)
		 	)
			((= #what_next 2) ; 初期
				(##Addpop0 &HINSYM$ 0)
		 	)
		);_cond

	  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
	  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
	  (action_tile "delete" "(##NOWROW)(setq #screenPT (done_dialog 4))")
	  (action_tile "add"    "(setq #screenPT (done_dialog 5))")
	  (action_tile "reset"  "(setq #screenPT (done_dialog 6))")
	  (action_tile "cancel" "(setq #ret$ \"CANSEL\") (setq #screenPT (done_dialog 0))")
	  (setq #what_next (start_dialog))

		(cond
			((= #what_next 5) ; 選択行を追加してﾘｽﾄ表示
			  ;// ﾌﾛｱｷｬﾋﾞﾈｯﾄを指示させる
			  (setq #loop T)
			  (while #loop
			    (setq #en (car (entsel "\nフロアキャビネットを選択: ")))
			    (if #en
		        (if (setq #newSYM (CFSearchGroupSym #en)) ; ｼﾝﾎﾞﾙ図形名
							(if (not (CheckSKK$ #newSYM (list (itoa CG_SKK_ONE_SNK)(itoa CG_SKK_TWO_BAS)(itoa CG_SKK_THR_ETC)))) ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
								(progn ; ﾌﾛｱｷｬﾋﾞだった
									(setq #check$ (mapcar 'cadr #pop$)) ; ｼﾝﾎﾞﾙﾘｽﾄ
									; 既に赤色かﾁｪｯｸ
									(if (not (member #newSYM #check$))
										(progn ; 赤色でない
											(cond
												((CFGetXData #newSYM "G_KUTAI")
													(CFAlertMsg "この部材は選択できません。") ; くたいだった
												)
												(T
													(setq #newHlN$ (car (GetHinbanSYMList (list #newSYM))))
													(GroupInSolidChgCol2 #newSYM CG_InfoSymCol) ; 赤にする
													(setq #lis$ (append #pop$ (list #newHlN$))) ; (品番,ｼﾝﾎﾞﾙ)形式
													(setq #loop nil)
												)
											);_cond
										)
										(progn
											(CFAlertMsg "既に選択されています。") ; 既に赤色
											(setq #newHlN$ (car (GetHinbanSYMList (list #newSYM))))
											(GroupInSolidChgCol2 #newSYM CG_InfoSymCol) ; 赤にする
											(setq #lis$ (append #pop$ (list #newHlN$))) ; (品番,ｼﾝﾎﾞﾙ)形式
											(setq #loop nil)
										)
									);_if
								)
								(CFAlertMsg "この部材は選択できません。") ; ﾌﾛｱｷｬﾋﾞでない
							);_if
	          	(CFAlertMsg "この部材は選択できません。")
		        );_if
			      (CFAlertMsg "部材が選択されていません。")
			    );_if
			  );_while
		 	)
			((= #what_next 4) ; 選択行を削除してﾘｽﾄ表示
				(setq #i 0)
				(foreach #pop #pop$ ; (品番,ｼﾝﾎﾞﾙ)形式
					(if (= #i #n)
						(progn ; ﾕｰｻﾞｰ選択行
							;;; 色を戻す
			        (if (equal CG_BASESYM (cadr #pop)) ;基準ｱｲﾃﾑ
			          (GroupInSolidChgCol (cadr #pop) CG_BaseSymCol)
			          (GroupInSolidChgCol2 (cadr #pop) "BYLAYER")
			        );_if
						)
						(setq #lis$ (append #lis$ (list #pop)))
					);_if
					(setq #i (1+ #i))
				)
		 	)
			((= #what_next 6) ; ﾘｾｯﾄ
				; 色を戻す
				(foreach #pop #pop$ ; (品番,ｼﾝﾎﾞﾙ)形式
	        (if (equal CG_BASESYM (cadr #pop)) ;基準ｱｲﾃﾑ
	          (GroupInSolidChgCol (cadr #pop) CG_BaseSymCol)
	          (GroupInSolidChgCol2 (cadr #pop) "BYLAYER")
	        );_if
				)
				(foreach #pop &HINSYM$
          (GroupInSolidChgCol2 (cadr #pop) CG_InfoSymCol) ; 赤にする
				)
		 	)
			((= #what_next 0) ; ｷｬﾝｾﾙ
				(prompt "\nﾕｰｻﾞｰによりﾀﾞｲｱﾛｸﾞがｷｬﾝｾﾙされました。")
		 	)
		);_cond

	)
  (unload_dialog #dcl_id)
  #ret$ ; 戻り値
);KcSetHinListDlg

;;;01/02/01YM@;<HOM>*************************************************************************
;;;01/02/01YM@; <関数名>    : KCGetSetCode
;;;01/02/01YM@; <処理概要>  : WT品番から、SET構成品ﾃｰﾌﾞﾙ検索Keyであるｾｯﾄｺｰﾄﾞを求める
;;;01/02/01YM@; <戻り値>    : ｾｯﾄｺｰﾄﾞ(文字列)
;;;01/02/01YM@; <作成>      : 01/01/31 YM
;;;01/02/01YM@; <備考>      : "G_WTSET"のWT品番各項目を見ているで
;;;01/02/01YM@;               ﾕｰｻﾞｰが勝手に入力したWT品番とは無関係
;;;01/02/01YM@;*************************************************************************>MOH<
;;;01/02/01YM@(defun KCGetSetCode (
;;;01/02/01YM@	&xdWTSET$
;;;01/02/01YM@	&SYOKUSEN
;;;01/02/01YM@  /
;;;01/02/01YM@	#N
;;;01/02/01YM@  )
;;;01/02/01YM@	(setq #n (+ 5 (nth 4 &xdWTSET$)))
;;;01/02/01YM@	(strcat
;;;01/02/01YM@		(nth (+ 1 #n) &xdWTSET$) ; ｼﾘｰｽﾞ記号
;;;01/02/01YM@		(nth (+ 2 #n) &xdWTSET$) ; ﾄｯﾌﾟ形状
;;;01/02/01YM@		(nth (+ 3 #n) &xdWTSET$) ; ｼﾝｸ記号
;;;01/02/01YM@		"-"
;;;01/02/01YM@		(nth (+ 4 #n) &xdWTSET$) ; 間口ｻｲｽﾞ
;;;01/02/01YM@		&SYOKUSEN ; 食洗有無
;;;01/02/01YM@	)
;;;01/02/01YM@);KCGetSetCode

;<HOM>*************************************************************************
; <関数名>    : C:Mitumori
; <処理概要>  : 明細書をEXCELで作成
; <戻り値>    : なし
; <作成>      : 1999-11-26 山田
; <備考>      :
;*************************************************************************>MOH<
(defun C:Mitumori (
  / #sFname #NO
  )
	;2008/03/27 YM ADD ｷﾗｰﾗWS対応 自動的に引手記号を修正する
	(ChgWS_Hikite);ｷﾗｰﾗWS専用処理

	(setq #NO nil)
	(if (KcCheckSetMITUMORI) ; ｾｯﾄ品見積りが有効(G_WTSET存在)
		(if (CFYesNoDialog msg7)
			(progn ; SET見積りﾕｰｻﾞｰYes
				(C:SetHINCheck) ; ｾｯﾄ品を考慮したTable.cfg出力
				(setq #NO "1") ; ここではTable.cfg更新なし
			)
			(setq #NO "2") ; SET見積りﾕｰｻﾞｰNo ここでは存在しないならTable.cfg更新
		);_if
		(setq #NO "3")   ; ｾｯﾄ品見積りが無効  ここではTable.cfg強制更新
	);_if

		  ;Head.cfgを書き出す。
;;;		  (setq #sFname (strcat CG_KENMEI_PATH "HEAD.CFG"))
;;;		  (if (= (findfile #sFname) nil)
		  	(SKB_WriteHeadList)
;;;			);_if

  ;WorkTop.cfgを書き出す 01/09/18 YM ADD-S
	(PKOutputWT_Info)
  ;WorkTop.cfgを書き出す 01/09/18 YM ADD-E

	(cond
		((= #NO "1")
			(princ) ; OLD_TABLE.CFG出力しない
		)
		((= #NO "2")
		  (setq #sFname (strcat CG_KENMEI_PATH "TABLE.CFG"))
		  (if (= (findfile #sFname) nil)
			  (SCFMakeBlockTable);Table.cfgを検索無ければ書き出す。
			);_if
		)
		((= #NO "3")
		  (SCFMakeBlockTable) ; 強制更新
		)
		(T
		  (SCFMakeBlockTable) ; 強制更新
		)
	);_cond

  ;特注ワークトップ情報書出し処理を追加
;;;  (PKOutputWTCT)

	; 01/10/30 YM ADD-S
	(PH_OutPutDoorInfo) ; 扉情報出力(PHCAD)
	; 01/10/30 YM ADD-E

  ;// 見積り画面を表示する
  ;00/08/19 HN MOD ＯＥＭ対応でモジュール呼び出し方法変更
  ;@@@(startapp (strcat CG_SysPATH "MITUMORI.EXE") "")
  ;00/09/08 HN MOD 子品番対応でモジュール呼び出し方法変更
  ;@@@(C:arxStartApp (strcat CG_SysPATH "MITUMORI.EXE") 0)
  (C:arxStartApp (strcat CG_SysPATH "MITUMORI.EXE /Child") 0)

  (princ)
)
;C:Mitumori


;;;<HOM>*************************************************************************
;;; <関数名>     : KCGetZaiCol$
;;; <処理概要>   : (素材名称,材質名称)を取得する
;;; <戻り値>     : (素材名称,材質名称)
;;; <作成>       : 01/09/18 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun KCGetZaiCol$ (
	&ZaiCode ; 材質記号
  /
	#QRY$ #RET$ #SCOL #SNAME
  )
	(setq #ret$ nil)
  (setq #qry$
	  (CFGetDBSQLRec CG_DBSESSION "WT材質"
	    (list
	      (list "材質記号" &ZaiCode 'STR)
	    )
	  )
	)

	(if (and #qry$ (= (length #qry$) 1))
		(progn
			(setq #sNAME (nth 4 (car #qry$))) ; 素材名称 ;2008/08/04 YM MOD
			(setq #sCOL  (nth 2 (car #qry$))) ; 材質名称 ;2008/08/04 YM MOD
			(setq #ret$ (list #sNAME #sCOL))
		)
		(progn
			(if (= CG_AUTOMODE 2) ; 02/09/02 YM WEB版自動ﾓｰﾄﾞは強制終了
				(*error*)
			; else
				(progn
					(CFAlertMsg	(strcat "材質記号が不正です。" "\n材質記号: " &ZaiCode))
					(setq #ret$ nil)
				)
			);_if
		)
	);_if
	#ret$
);KCGetZaiCol$

;;;<HOM>*************************************************************************
;;; <関数名>    : PKOutputWT_Info
;;; <処理概要>  : WT情報をWorkTop.cfgに吐き出す
;;; <戻り値>    : (T:出力した or nil:出力しなかった)
;;; <作成>      : 01/09/18 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKOutputWT_Info (
  /
	#410$ #F #FLG #HAIRETU #LIS$ #LR #PT$ #SFILE #SMAG #SMAG1 #SMAG2 #SMAG3
	#SNKK #SS #TOP_COLOR #TOP_IL #TOP_LR #TOP_MATERIAL #TOP_SHAPE #TOP_SINK
	#TOP_WIDTH #TYPE #WT #XDWT$ #XDWTSET$ #ZAI$ #ZAICODE
  )
	(setq #flg nil)
;;;;-----
;;;; ";"はｺﾒﾝﾄ
;;;;-----
;;;TOP_MATERIAL=ｽﾃﾝﾚｽﾍｱﾗｲﾝ
;;;TOP_COLOR=ｸﾞﾚｰ(ｽﾃﾝﾚｽのｶﾗｰは???)
;;;TOP_SHAPE=ﾌﾗｯﾄﾄｯﾌﾟ
;;;TOP_LR=R
;;;TOP_IL=U
;;;TOP_WIDTH=251625(U型の場合6桁?)
;;;TOP_SINK=B

  (setq #sFile (strcat CG_KENMEI_PATH "WorkTop.cfg"))
  (setq #flg nil #lis$ nil)
  (setq #ss (ssget "X" '((-3 ("G_WRKT"))))) ; 図面上の品番確定されたﾜｰｸﾄｯﾌﾟ
;;;01/09/21YM@DEL  (setq #ss (ssget "X" '((-3 ("G_WTSET"))))) ; 図面上の品番確定されたﾜｰｸﾄｯﾌﾟ

  (if (and #ss (> (sslength #ss) 0))
    (progn ; 1つ以上あった
      (setq #WT (ssname #ss 0)) ; 最初に見つかったWT
      (setq #xdWT$    (CFGetXData #WT "G_WRKT"))
      (setq #xdWTSET$ (CFGetXData #WT "G_WTSET"))

			(setq #ZaiCode (nth 2 #xdWT$))
			; WT材質 = (素材名称,材質名称)を取得する
			(setq #Zai$ (KCGetZaiCol$ #ZaiCode)) ; (人造大理石,ﾌｫﾙﾃｸﾞﾚｰ)(nth 3,nth 5)
			(setq #TOP_MATERIAL (strcat "TOP_MATERIAL=" (car  #Zai$))) ; 材質
			(setq #TOP_COLOR    (strcat "TOP_COLOR=" (cadr #Zai$)))    ; 色
			; WT形状
			(setq #Type (nth 4 #xdWT$)) ; "F" or "D"
			(cond
				((= #Type "F")(setq #TOP_SHAPE "TOP_SHAPE=ﾌﾗｯﾄﾄｯﾌﾟ"))
				((= #Type "D")(setq #TOP_SHAPE "TOP_SHAPE=ｼﾞｮｲﾄｯﾌﾟ"))
			);_cond

			; WT勝手
			(setq #LR (nth 30 #xdWT$))
			(if (and (/= #LR "R")(/= #LR "L"))(setq #LR "")) ; 01/09/21 YM ADD
			(setq #TOP_LR (strcat "TOP_LR=" #LR))
;;;(makeERR "PKOutputWT_Info") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B
			; WT配列
			(setq #HAIRETU (nth 3 #xdWT$))
			(cond
				((= #HAIRETU 0)
				 	(setq #TOP_IL "TOP_IL=I")
					(setq #sMAG1 (itoa (fix (+ (nth 42 #xdWT$) 0.1))))
					(setq #sMAG (substr #sMAG1 1 3))
			 	)
				((= #HAIRETU 1)
				 	(setq #TOP_IL "TOP_IL=L")
					(setq #sMAG1 (itoa (fix (+ (nth 42 #xdWT$) 0.1))))
					(setq #sMAG2 (itoa (fix (+ (nth 43 #xdWT$) 0.1))))
					(setq #sMAG1 (substr #sMAG1 1 2))
					(setq #sMAG2 (substr #sMAG2 1 2))
				 	(if (= #LR "L")
				 		(setq #sMAG (strcat #sMAG2 #sMAG1))
				 		(setq #sMAG (strcat #sMAG1 #sMAG2))
					);_if
			 	)
				((= #HAIRETU 2)
				 	(setq #TOP_IL "TOP_IL=U")
					(setq #sMAG1 (itoa (fix (+ (nth 42 #xdWT$) 0.1))))
					(setq #sMAG2 (itoa (fix (+ (nth 43 #xdWT$) 0.1))))
					(setq #sMAG3 (itoa (fix (+ (nth 44 #xdWT$) 0.1))))
					(setq #sMAG1 (substr #sMAG1 1 2))
					(setq #sMAG2 (substr #sMAG2 1 2))
					(setq #sMAG3 (substr #sMAG3 1 2))
				 	(setq #sMAG (strcat #sMAG1 #sMAG2 #sMAG3))
			 	)
			);_cond

  		; WT間口
		 	(setq #TOP_WIDTH (strcat "TOP_WIDTH=" #sMAG))

			; WT領域内のｼﾝｸ
			(setq #pt$ (GetLWPolyLinePt (nth 59 #xdWT$))); 段差部も含んだWT外形領域
			(setq #pt$ (AddPtList #pt$))                 ; 末尾に始点を追加する

      (command "vpoint" "0,0,1") ; 00/09/18 YM
			(setq #410$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SNK)) ; 領域内ｼﾝｸ
      (command "zoom" "p") ; 視点を元に戻す ; 00/09/18 YM

			; ｼﾝｸ記号(最初のｼﾝｸ)
			(if #410$
				(setq #SNKK (nth 0 (CFGetXData (car #410$) "G_SINK")))
				(setq #SNKK "")
			);_if
			(setq #TOP_SINK (strcat "TOP_SINK=" #SNKK))

			; 上書きﾓｰﾄﾞﾌｧｲﾙｵｰﾌﾟﾝ
      (setq #f (open #sFile "W"))

			(princ #TOP_MATERIAL #f)(princ "\n" #f)
			(princ #TOP_COLOR    #f)(princ "\n" #f)
			(princ #TOP_SHAPE    #f)(princ "\n" #f)
			(princ #TOP_LR       #f)(princ "\n" #f)
			(princ #TOP_IL       #f)(princ "\n" #f)
			(princ #TOP_WIDTH    #f)(princ "\n" #f)
			(princ #TOP_SINK     #f)(princ "\n" #f)
      (close #f) ; 上書き完了
      (setq #flg T)
    )
		(progn
			nil ; WTがないと何もしない
		)
  );_if

  #flg
);PKOutputWT_Info



;;<HOM>*************************************************************************
;; <関数名>    : C:Mitumori
;; <処理概要>  : 明細書をEXCELで作成
;; <戻り値>    : なし
;; <作成>      : 1999-11-26 山田
;; <備考>      :
;;*************************************************************************>MOH<
;(defun C:Mitumori (
;    /
;    #sApp #sFile #sMitumori #sTeisyutu #sKenmei #sNaiyou #sTantou
;    #sCfgH #sCfgT #Spec$$ #sSeries #sDrClr #sWTzai #sSink #Clst$ #Exc$
;    #i #s$ #sM$ #len #n6 #n7 #s #iC #iR #PageNo #Date #iC$ #iR_top #iR_max #R #loop
;    #Kingaku_total #Kingaku #sDrSeri #sDrClr
;  )
;  (StartCmnErr)
;  (setq #sApp   CG_EXCELPATH)
;  (setq #sFile  (strcat CG_KENMEI_PATH "見積.xls"))
;  ;(setq #sCfgH  (if (/= CG_KENMEI_PATH nil) (strcat CG_KENMEI_PATH "Head.cfg") ""))
;  (setq #sCfgT  (if (/= CG_KENMEI_PATH nil) (strcat CG_KENMEI_PATH "Table.cfg") ""))
;;  (if (and (findfile #sCfgH) (findfile #sCfgT))
;  (if (findfile #sCfgT)
;    (progn
;;      (setq #Spec$$ (SKreadCSV #sCfgH))
;      (setq #Spec$$ (SKB_GetHeadList))
;      (setq #sKenmei (nth 0 (nth 0 #Spec$$)))   ; CG_BukkenName
;      (setq #sTantou (nth 0 (nth 1 #Spec$$)))   ; CG_CNAME
;      (setq #sBranch (nth 0 (nth 2 #Spec$$)))
;      (setq #sSeries (nth 0 (nth 3 #Spec$$)))
;      (setq #sDrSeri (nth 0 (nth 4 #Spec$$)))
;      (setq #sDrClr  (nth 0 (nth 5 #Spec$$)))
;      (setq #sWTzai  (nth 0 (nth 6 #Spec$$)))
;      (setq #sSink   (nth 0 (nth 7 #Spec$$)))
;
;      (setq #sMitumori CG_BukkenNo)
;      (setq #sTeisyutu "")
;      (setq #sNaiyou   CG_Kname)
;
;      (setq #i 8)
;      (while (/= nil (setq #s$ (nth #i #Spec$$)))
;        (setq #len (length #s$) #n7 (1- #len) #n6 (1- #n7))
;
;        (setq #Clst$ (cons (if (/= nil (nth 0 #s$)) (nth 0 #s$) "") #Clst$))
;        (setq #Clst$ (cons (if (/= nil (nth 1 #s$)) (nth 1 #s$) "") #Clst$))
;        (setq #Clst$ (cons (if (/= nil (nth 2 #s$)) (nth 2 #s$) "") #Clst$))
;
;        (setq #sM$ (cons (if (/= nil (nth 3 #s$)) (nth 3 #s$) "") #sM$))
;        (setq #sM$ (cons (if (/= nil (nth 4 #s$)) (nth 4 #s$) "") #sM$))
;        (if (= #len 8)
;          (setq #sM$ (cons (if (/= nil (nth 5 #s$)) (nth 5 #s$) "") #sM$))
;        )
;        (setq #s (strcat (nth 1 #sM$) "," (nth 0 #sM$)))
;        (if (= #len 8)
;          (setq #s (strcat (nth 2 #sM$) "," #s))
;        )
;        (if (or (= #s ",") (= #s ",,")) (setq #s "0"))
;        (setq #Clst$ (cons #s #Clst$))
;
;        (setq #Clst$ (cons (if (/= nil (nth #n6 #s$)) (nth #n6 #s$) "") #Clst$))
;        (setq #Clst$ (cons (if (/= nil (nth #n7 #s$)) (nth #n7 #s$) "") #Clst$))
;
;        (setq #Exc$ (cons (reverse #Clst$) #Exc$))
;        (setq #Clst$ nil #sM$ nil)
;        (setq #i (1+ #i))
;      )
;      (setq #Exc$ (reverse #Exc$))
;
;      (setq #PageNo 1)
;;     (setq #Date "")
;
;      ;ファイルを開く
;      (startapp (strcat "\"" #sApp "\"") (strcat "\"" #sFile "\""))
;      (setq ExAppCmd$ (strcat "\"" #sApp "\" \"" #sFile "\""))
;      (setq ExSheetName$ "総表")  ;//"明細n"
;
;      ;DDEチャネルの作成
;      (chkdde)
;
;      ;文字の転送
;      ; 題名
;      (SCFPokeStr 1  4  #sMitumori)
;      (SCFPokestr 4  5  #sTeisyutu)
;      (SCFPokeStr 7  4  #sKenmei)
;      (SCFPokeStr 5  11 #sBranch)
;      (SCFPokeStr 12 11 #sTantou)
;      (SCFPokeStr 1  12 (itoa #PageNo))
;;     (SCFPokeStr 2  12 #Date)
;      ; 表
;      (setq #iC$ (list 2 3 6 7 8 10))
;      (setq #iR 0)
;      (while (< #iR (length #Exc$))
;        (setq #iC 0)
;        (while (< #iC (length #iC$))
;          (SCFPokeStr (+ #iR 19) (nth #iC #iC$) (nth #iC (nth #iR #Exc$)))
;          (setq #iC (1+ #iC))
;        )
;        (setq #iR (1+ #iR))
;      )
;
;
;      (setq #Exc$ nil)
;      (setq #Kingaku_total 0)
;      (setq #Spec$$ (SKreadCSV #sCfgT))
;      (setq #i 0)
;      (while (/= nil (setq #s$ (nth #i #Spec$$)))
;        (setq #Clst$ (cons (if (/= nil (nth 0 #s$)) (nth 0 #s$) "") #Clst$))
;        ;--
;        ;(setq #Clst$ (cons "xxxxxxx" #Clst$))
;        (setq #Clst$ (cons (if (/= nil (nth 6 #s$)) (nth 6 #s$) "") #Clst$))
;        ;--
;        (setq #Clst$ (cons (if (/= nil (nth 2 #s$)) (nth 2 #s$) "") #Clst$))
;        (setq #Clst$ (cons (if (/= nil (nth 1 #s$)) (nth 1 #s$) "") #Clst$))
;        (setq #Clst$ (cons (if (/= nil (nth 4 #s$)) (nth 4 #s$) "0") #Clst$))
;        (setq #Clst$ (cons (if (/= nil (nth 5 #s$)) (nth 5 #s$) "0") #Clst$))
;        (setq #Kingaku (* (atoi (nth 0 #Clst$)) (atoi (nth 1 #Clst$))))
;        (setq #Clst$ (cons (itoa #Kingaku) #Clst$))
;        (setq #Kingaku_total (+ #Kingaku_total #Kingaku))
;        (setq #Exc$ (cons (reverse #Clst$) #Exc$))
;        (setq #Clst$ nil)
;        (setq #i (1+ #i))
;      )
;      (setq #Exc$ (reverse #Exc$))
;
;      (setq #iR_top 14 #iR_max 21 #R 0)
;      (setq #iC$ (list 2 3 4 7 10 11 12))
;      (setq #PageNo 2)
;
;      (setq #loop T)
;      (while #loop
;        (setq ExSheetName$ (strcat "明細" (itoa (1- #PageNo))))  ;//"明細n"
;
;        ;DDEチャネルの作成
;        (chkdde)
;
;        ;文字の転送
;        ; 題名
;        (SCFPokeStr 1  4  #sMitumori)
;        (SCFPokeStr 1  15 (itoa #PageNo))
;;       (SCFPokeStr 2  15 #Date)
;        (if (= #PageNo 2)
;          (progn
;            (SCFPokeStr 4  4  #sKenmei)
;            (SCFPokeStr 5  4  #sNaiyou)
;            (SCFPokeStr 7  4  (strcat "SERIES："   #sSeries))
;            (SCFPokeStr 7  8  (strcat "扉グレード：" #sDrSeri))
;            (SCFPokeStr 7  12 (strcat "扉COLOR："   #sDrClr))
;            (SCFPokeStr 8  4  (strcat "ワークトップ材質：" #sWTzai))
;            (SCFPokeStr 8  8  (strcat "シンク：" #sSink))
;;           (SCFPokeStr 10 5 (strcat "\\" (itoa #Kingaku_total)))
;            (SCFPokeStr 10 5 (itoa #Kingaku_total))
;          )
;        )
;        ; 表
;        (setq #iR 0)
;        (while (and (< #R (length #Exc$)) (< #iR #iR_max))
;          (setq #iC 0)
;          (while (< #iC (length #iC$))
;            (SCFPokeStr (+ #iR #iR_top) (nth #iC #iC$) (nth #iC (nth #R #Exc$)))
;            (setq #iC (1+ #iC))
;          )
;          (setq #iR (1+ #iR) #R (1+ #R))
;        )
;        (if (>= #R (length #Exc$)) (setq #loop nil))
;        (setq #iR_top 7 #iR_max 29)
;        (setq #PageNo (1+ #PageNo))
;      )
;
;    )
;    (CFAlertMsg "本コマンドは仕様表を作成後に実行してください.")
;  )
;
;  (princ)
;)
;
;;<HOM>*************************************************************************
;; <関数名>    : SCFPokeStr
;; <処理概要>  : 文字列転送
;; <戻り値>    : なし
;; <作成>      : 1999-06-30
;; <備考>      : なし
;;*************************************************************************>MOH<
;(defun SCFPokeStr (
;  &iR         ; 行
;  &iC         ; 列
;  &sTr        ; 文字列
;  /
;  #item
;  )
;  (unadvise chnl "")
;  (setq #item (cellstr &iR &iC 1 1))
;  (poke chnl #item &sTr)
;  (princ)
;) ; SCFPokeStr
;
;;<HOM>************************************************************************
;;
;; <関数名>    : chkdde
;;
;; <処理概要>  : DDEチャネルの作成
;;
;; <戻り値>    : なし
;;
;; <備考>      : リモートアプリケーション(Excel)に対するDDEチャネルが既に存在
;;               しているかどうかを確認し、存在しなければ作成する。
;;
;;************************************************************************>MOH<
;;       Make sure we have a DDE channel.  Create one if not.
;(defun chkdde ()
;;	(setq chnl (getddechnl))			;Ask ddelisp.exe if we have a DDE
;										;	channel open
;	(setq chnl (appinit "excel" ExSheetName$ ExAppCmd$))
;	(if (= 0 chnl)
;		(progn
;			(setq chnl (ddeprompt))		;Try to load app, open channel.  If
;										;	fail, put up dialog for app,
;										;	topic, and command line.
;			(if (= 0 chnl)
;				(progn
;					(princ "DDEチャネルがオープンできません\n")
;					(quit)
;				)
;				(progn
;					(sethandles)
;					(setddeformat 1)
;				)
;			) ;if
;		) ;progn
;	) ;if
;) ;chkdde
;
;;******************************************************************************
;;	本lispファイルがロードされた際にddelispのロード処理を行なう
;;******************************************************************************
;;       Initialize when loading actoex.lsp.
;(if (null initiate)				;DDELISP.EXE not loaded.
;	(progn
;		(xload (strcat CG_LISPPATH "ddelisp.exe"))		;ADS program that contains the DDE
;								;	AutoLISP functions.
;	)
;)
