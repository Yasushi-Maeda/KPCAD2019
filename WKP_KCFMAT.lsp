;(setq CG_KPDEPLOY_ARX_LOAD nil)  ;ARX対応版展開図作成で動作させるかどうか
(setq CG_KPDEPLOY_ARX_LOAD T)  ;ARX対応版展開図作成で動作させるかどうか
(setq CG_DoorZMove 650) ; 扉図形をZ方向(図面をXY平面として)に押し出す量 01/03/15 YM ADD
(setq CG_Yashi_OffY 250) ; 平面図矢視ﾏｰｸ位置ずらし 2011/06/14 YM ADD

;;;<HOF>************************************************************************
;;; <ファイル名>: SCFmat.LSP
;;; <システム名>: ******システム
;;; <最終更新日>: 00/03/13 中村 博伸
;;; <備考>      : なし
;;;************************************************************************>FOH<
;@@@(princ "\nSCFmat.fas をﾛｰﾄﾞ中...\n")

;<HOM>*************************************************************************
; <関数名>    : C:SCFMakeMaterial
; <処理概要>  : 展開元図作成
; <戻り値>    : なし
; <作成>      : 1999-06-21
; <備考>      : なし
;*************************************************************************>MOH<

(defun C:SCFMakeMaterial (
  /
#room_ss #room_en #idx
#ss #en #code$ #xd$
#D #W #ang #p1 #p2 #p3 #p4
#ss2 #idx2 #en2 #xdl2$
#lsymList$$
#qry$
#data$ #xdl$ #hinban #en2$ #eg #tmp
#enCp$ #enCpTmp$ #sym
  )
   ;;; 展開元図処理のメイン部分は、パース図レイアウトコマンドと共通のため、
   ;;; (SCFMakeMaterial2)関数に分離した 2000/10/10

  (WebOutLog "ｴﾗｰ関数 SKAutoError2 を定義します(C:SCFMakeMaterial)"); 02/09/04 YM ADD ﾛｸﾞ出力追加

  (cond
    ((= CG_AUTOMODE 1)
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError1)
      );_if
    )
    ((= CG_AUTOMODE 2)
      (if (= CG_DEBUG 1)
        nil
        ;else
        (setq *error* SKAutoError2)
      );_if
    )
    ((= CG_AUTOMODE 3)
      (if (= 1 CG_DEBUG)
        nil
        ;else
        (setq *error* SKAutoError1)
      );_if
    )
  );_cond

;-- 2011/09/27 A.Satoh Del - S
;;;;;;-- 2011/09/19 A.Satoh Add - S
;;;;;  ; 施工図出し分けを行う
;;;;;  (if (SCF_SekouLayer)
;;;;;    (progn
;;;;;;-- 2011/09/19 A.Satoh Add - E
;-- 2011/09/27 A.Satoh Del - E

;-- 2012/05/09 A.Satoh Add パース図部屋枠出力対応 - S
;;;; 展開図作成時に部屋枠図形のレイヤが"0"でなければ、強制的に"0"に変更する
	(setq #room_ss (ssget "X" '((-3 ("G_ROOM")))))
	(if #room_ss
		(progn
			(setq #idx 0)
			(repeat (sslength #room_ss)
				(setq #room_en (ssname #room_ss #idx))
				(if (/= (cdr (assoc 8 (entget #room_en))) "0")
					(command "_CHANGE" #room_en "" "P" "LA" "0" "")
				)
				(setq #idx (1+ #idx))
			)
		)
	)
;-- 2012/05/09 A.Satoh Add パース図部屋枠出力対応 - E

;;  2005/11/30 G.YK ADD-S
  (setq CG_Material_View (getvar "VIEWDIR"))
  (command "_vpoint" "0,0,1");
;;  2005/11/30 G.YK ADD-E
  ; 画層ﾊﾟｰｼﾞ 01/07/17 YM ADD START
  (command "_purge" "LA" "0_*"   "N") ; 使っていない画層を削除する.
  ; 画層ﾊﾟｰｼﾞ 01/07/17 YM ADD END

  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (StartUndoErr)
  );_if

;-- 2011/10/05 A.Satoh Add - S
  (setq CG_OSMODE_BAK (getvar "OSMODE"))
;-- 2011/10/05 A.Satoh Add - E

  (setq CG_TABLE nil) ; Table.cfg出力済みﾌﾗｸﾞ 01/02/07 YM

  ; (扉処理用のフラグにする)
  (SCFStartShori "SCFMakeMaterial")

	; 2017/09/14 KY ADD-S
	; フレームキッチン対応
	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn
			;201709/21 YM ADD-S 画層非表示にするとﾌﾚｰﾑのrotateで位置がおかしくなるを回避
		  (setvar "OSMODE"    0)
		  (setvar "GRIDMODE"  0)
		  (setvar "ORTHOMODE" 0)
		  (setvar "SNAPMODE"  0)
			;201709/21 YM ADD-E 画層非表示にするとﾌﾚｰﾑのrotateで位置がおかしくなるのを回避

			(command "_.ZOOM" "E")(command "_.ZOOM" "S" "0.8x")
			(setq #ss (ssget "X" '((-3 ("G_SYM")))))
			(if (and #ss (< 0 (sslength #ss)))
				(progn
					; 対象のカウンタの領域内のG_LSYMのリストの取得
					(setq #lsymList$$ nil)
					(setq #idx 0)
					(repeat (sslength #ss)
						(setq #en (ssname #ss #idx))
						(setq #code$ (CFGetSymSKKCode #en nil))
						(if (equal #code$ (list CG_SKK_ONE_CNT CG_SKK_TWO_BAS CG_SKK_THR_DIN) 0.1) ; カウンタ(717)
							(progn
								(setq #xd$ (CfGetXData #en "G_SYM"))
								(setq #D (nth 4 #xd$)) ; 寸法D

;;; 2017/10/17YM								(if (> #D 800)
;;; 2017/10/17YM									(progn
										; 図形領域の角４点
										(setq #W (nth 3 #xd$)) ; 寸法W
										(setq #ang (nth 2 (CfGetXData #en "G_LSYM"))) ; 回転角度
										(setq #p1 (cdr (assoc 10 (entget #en))))
										(setq #p2 (polar #p1 #ang #W))
										(setq #p3 (polar #p2 (- #ang (dtr 90)) #D))
										(setq #p4 (polar #p1 (- #ang (dtr 90)) #D))
										(setq #ss2 (ssget "CP" (list #p1 #p2 #p3 #p4 #p1) '((-3 ("G_LSYM")))))
										(if (and #ss2 (< 0 (sslength #ss2)))
											(progn
												(setq #idx2 0)
												(repeat (sslength #ss2)
													(setq #en2 (ssname #ss2 #idx2))
													(setq #xdl2$ (CfGetXData #en2 "G_LSYM"))
													(if (= nil (vl-position (list #en2 #xdl2$) #lsymList$$))
														(progn
															(setq #lsymList$$ (append #lsymList$$ (list (list #en2 #xdl2$))))
														);progn
													);if
													(setq #idx2 (1+ #idx2))
												);repeat
												(setq #ss2 nil)
											);progn
										);if

;;; 2017/10/17YM									);progn
;;; 2017/10/17YM								);if

							);progn
						);if
						(setq #idx (1+ #idx))
					);repeat
					(setq #ss nil)
					(if #lsymList$$ ; G_LSYMのリストがあれば
						(progn
							(setq #idx 0)
							(foreach #data$ #lsymList$$
								(setq #en (nth 0 #data$))
								(setq #xdl$ (nth 1 #data$))
								(setq #hinban (nth 5 #xdl$)) ; 品番
								(setq #qry$
												(CFGetDBSQLRec CG_DBSESSION "E展開図寸法対象"
													(list (list "品番名称" #hinban 'STR))))
								(if (and #qry$ (= (length #qry$) 1))
									(progn
										(setq #ss2 (CFGetSameGroupSS #en))
										(setq #idx2 0 #en2$ nil)
										(repeat (sslength #ss2)
											(setq #en2 (ssname #ss2 #idx2))
											(setq #eg (entget #en2))
											(setq #tmp (cdr (assoc 8 #eg)))
											(setq #tmp (substr #tmp 1 4))
											(if (or (= #tmp "Z_01") (= #tmp "Z_03"))
												(progn ;2017/10/03 YM ADD-S
													(if (CfGetXData #en2 "G_PMEN")
														(princ) ;PMENは無視する隠線領域が背面図を隠線してしまう
														;else
														(setq #en2$ (append #en2$ (list #en2)))
													);_if
												) ;2017/10/03 YM ADD-S
											);if
											(setq #idx2 (1+ #idx2))
										);repeat
										(setq #ss2 nil)
;;(princ #hinban)(princ " ")(princ #en)(princ " ")(princ #en2$)(princ "\n")
										(setq #p1 nil #p2 nil #enCpTmp$ nil)
										(mapcar '(lambda (#sym)
															(setq #xd$ (CfGetXData #sym "G_SYM"))
															(setq #xdl$ (CfGetXData #sym "G_LSYM"))
;;(princ (entget #sym))(princ "\n")
;;;;(princ #xd$)(princ "\n")
;;;;(princ "\n")
															(setq #en2 nil)
															; 回転複写
															(if #xd$
																(progn
																	(setq #p1 (cdr (assoc 10 (entget #sym))))
																	(setq #W (nth 3 #xd$)) ; 寸法W
																	(setq #ang (nth 2 #xdl$)) ; 回転角度
																	(setq #p2 (polar #p1 #ang (/ #W 2.0))) ; 回転基準点
																	(command "_.ROTATE" #sym "" #p2 "C" "180")
																	(setq #en2 (entlast))
																	(CFSetXData #en2 "G_SYM" #xd$)
																	(setq #p3 (mapcar '(lambda (#1 #2) (- (* #2 2.0) #1)) #p1 #p2)) ; 回転後の挿入点座標
																);progn
																;else
																(progn
																	(if (and #p1 #p2)
																		(progn
																			(command "_.ROTATE" #sym "" #p2 "C" "180")
																			(setq #en2 (entlast))
																		);progn
																	);if
																);progn
															);if
															(if #en2
																(progn
																	(setq #enCpTmp$ (append #enCpTmp$ (list #en2)))
																	(if (= nil (tblsearch "APPID" "G_DEL")) (regapp "G_DEL"))
																	(CFSetXData #en2 "G_DEL" (list 1))
																	(if #xdl$
																		(progn
																			(CFSetXData #en2 "G_LSYM"
																				(CFModList #xdl$
																					(list (list 1 #p3)
																								(list 2 (+ #ang PI))
																								(list 5 "ﾍﾞｰｽﾀﾞﾐｰ"))))
																		);progn
																	);if
																);progn
															);if
														)
													(cons #en #en2$) ; ｼﾝﾎﾞﾙ図形が最初になるように渡す(拡張データ取得のため)
												)
										; コピーした図形のグループ化
										(setq #ss (ssadd))
										(mapcar '(lambda (#sym) (ssadd #sym #ss)) #enCpTmp$)
										(SKMkGroup #ss)
										(setq #ss nil)
										(setq #enCp$ (append #enCp$ #enCpTmp$))
									);progn
								);if
								(setq #idx (1+ #idx))
							);foreach
						);progn
					);if
				);progn
			);if
		);progn
	);if
	; 2017/09/14 KY ADD-E

  ; 展開元図作成処理
    (if (= CG_KPDEPLOY_ARX_LOAD T)
      (setq CG_TENKAI_OK (SCFMakeMaterialArx))  ;展開図ARX対応版(現在はこちら）
      (setq CG_TENKAI_OK (SCFMakeMaterial2))    ;展開図LISP対応版
    )

		;2017/09/21 YM ADD OEM版で動きがおかしい
		(if CG_TENKAI_OK
			nil ;
			;else
;;;			(CFAlertErr "(SCFMakeMaterialArx) 戻り値 CG_TENKAI_OK が nil") ;2017/09/28 YM DEL
		);_if

;;;2008/08/02YM@DEL  ; 展開元図作成処理
;;;2008/08/02YM@DEL  (setq CG_TENKAI_OK (SCFMakeMaterial2)) ; 戻り値追加 01/02/20 YM

  ; ★★★★★  Openしなおさないといけない理由 ★★★★★
  ; 1. 開きなおしてグループ化が解除されてしまう障害（扉の取っ手が[レイアウト]で出力されない）を回避
  ; 2. 2000/06/22 扉図形作成時の速度改善に扉を"0_door"画層に作成し、展開元図用にはコピーするので
  ;    "0_door"画層に不要な図形が残っているのでOPENしなおさなければならない
  ; 3. ; 2000/06/21 扉削除モードに変更（[印刷]-[表示制御]改修対応）のために
  ;    SCFmat.lspの(PCD_MakeViewAlignDoor #Dooren$ 2 T)で、扉を削除するようにしたため
  ; 4. 陰線処理 された状態よりワイアフレームのほうが処理速度が速いため
  ;    コマンド最初にワイアフレームにする
  ; ★★★★★  Openしなおさないといけない理由 ★★★★★

;-- 2011/09/27 A.Satoh Add - S
  (if (= CG_TENKAI_OK nil)
    (progn
			; 2017/09/14 KY ADD-S
			; フレームキッチン対応
			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
				(progn
					(if #enCp$
						(progn
							; コピーした図形の削除
							(mapcar 'entdel #enCp$)
							(CfAutoSave)
						);progn
					);if
				);progn
			);if
			; 2017/09/14 KY ADD-E

      (princ "展開図作成処理をｷｬﾝｾﾙしました。")
      (command "_.ZOOM" "P")
    )
    (progn
;-- 2011/09/27 A.Satoh Add - E

  (CFNoSnapFinish)

  ; 終了処理
  (SCFEndShori)

  ; 図面をオープンしなおす
  (WebOutLog "ｵｰﾌﾟﾝﾓｰﾄﾞ=8 で図面再ｵｰﾌﾟﾝします"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  (setq CG_OPENMODE 8) ; 01/03/05 YM ADD ==>ACADDOC.LSP S::STARTUP

  ; 自動ﾓｰﾄﾞではSCFCmnFileOpenが効かない
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
    (progn
      (command "_.Open" "N" (strcat CG_KENMEI_PATH "MODEL.dwg"))
      (S::STARTUP)
    )
    ;else
    (SCFCmnFileOpen (strcat CG_KENMEI_PATH (getvar "DWGNAME")) 1) ; 2000/10/19 HT 関数化
  );_if

  ;＜開発用＞
  ;2010/11/30 YM ADD-S
  ;デバックモードなら矢視領域を残したい
  (if (and (= CG_DEBUG 1)(= CG_AUTOMODE 2))
    ;矢視領域作図(関数化)
    (DrawYashiArea);2010/11/30 YM ADD
  );_if
  ;2010/11/30 YM ADD-E

;-- 2011/09/19 A.Satoh Add - S
    )
  )
;-- 2011/09/19 A.Satoh Add - E
;-- 2011/10/05 A.Satoh Add - S
  (setvar "OSMODE" CG_OSMODE_BAK)
  (setq CG_OSMODE_BAK nil)
;-- 2011/10/05 A.Satoh Add - E

  (princ)
) ; C:SCFMakeMaterial


;-- 2011/09/19 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : SCF_SekouLayer
; <処理概要>  : 施工図出し出し分け処理
; <戻り値>    : なし
; <備考>      : なし
;*************************************************************************>MOH<
;(defun C:qqq (
(defun SCF_SekouLayer (
  /
  #dcl_id #layer5$ #layer6$ #layer19$ #layer20$ #layer21$
  #rec$$ #rec$ #layer #flag #rule$$
  #mode_flg5 #mode_flg6 #mode_flg19 #mode_flg20 #mode_flg21
  #wt_dat$$ #ss #idx #LR #oku$$ #oku$ #oku
  #delLay$
#sKatte ;2017/09/21 YM ADD
#KPCAD_KEY #LAYER19 #LAYER20 #LAYER21 #LAYER6 #RAD19M #RADFKL #RADFKM #RADFKR #RET #XD_WT$ ;2018/02/16 YM ADD
  )

;***********************************************************
  (defun ##DelLayer (
    &list$
    /
    #idx #no #string #layer$ #rec$ #layer #num #value #ret$
    #ss #i #en
;;; #rec$$はローカル定義しない
    )


    (setq #idx 0)
    (repeat (length &list$)
      (setq #no (nth 0 (nth #idx &list$)))
      (setq #string (nth 1 (nth #idx &list$)))

      (setq #layer$ nil)
      (foreach #rec$ #rec$$
        (setq #layer     (nth 0 #rec$))
        (setq #num (atoi (nth 1 #rec$)))
        (setq #value     (nth 2 #rec$))
        (if (= #no #num)
          (if (wcmatch #string #value)
            (progn
              ;","区切り考慮
              (setq #ret$ (StrParse #layer ","));画層のﾘｽﾄ
              (setq #layer$ (append #layer$ #ret$))
            )
          );_if
        )
      )

      ;特定の画層の図形を削除
      (foreach #layer #layer$
        (setq #ss (ssget "X" (list (cons 8 #layer))))
        (if (and #ss (/= 0 (sslength #ss)))
          (progn
            (setq #i 0)
            (repeat (sslength #ss)
              (setq #en (ssname #ss #i))
              (if (entget #en)
                (entdel #en)
              );_if
              (setq #i (1+ #i))
            );repeat
          )
        );_if
      );foreach

      (setq #idx (1+ #idx))
    )

  ) ; ##DelLayer
;***********************************************************
  (defun ##SekouExec (
    /
;;; #rule$$ #wt_dat$$はローカル宣言しない
    #delLayer$ #rule$ #value #err_flag #wt_dat$
    #rad5L #rad5R #rad20L #rad20R #rad6L #rad6R #rad21L #rad21R #rad19L 
    #rad19R
		#counters$$ #counter$
    )

    (setq #err_flag nil)
    (setq #delLayer$ nil)
    (setq #rad5L (get_tile "rad5L"))
    (setq #rad5R (get_tile "rad5R"))
    (setq #rad20L (get_tile "rad20L"))
    (setq #rad20R (get_tile "rad20R"))

		;2018/02/15 YM ADD-S
    (setq #radFKL (get_tile "radFKL"))
    (setq #radFKM (get_tile "radFKM"))
    (setq #radFKR (get_tile "radFKR"))
		;2018/02/15 YM ADD-E

    (setq #rad6L  (get_tile "rad6L"))
    (setq #rad6R  (get_tile "rad6R"))
    (setq #rad21L (get_tile "rad21L"))
    (setq #rad21R (get_tile "rad21R"))
    (setq #rad19L (get_tile "rad19L"))
    (setq #rad19M (get_tile "rad19M"))
    (setq #rad19R (get_tile "rad19R"))

    (if (and
          (= #rad5L  "0") (= #rad5R  "0")
          (= #rad20L "0") (= #rad20R "0")
          (= #radFKL "0") (= #radFKM "0") (= #radFKR "0") ;2018/02/15 YM ADD
          (= #rad6L  "0") (= #rad6R  "0")
          (= #rad21L "0") (= #rad21R "0")
          (= #rad19L "0") (= #rad19M "0") (= #rad19R "0")
        ) ;本当はいいチェックではない。全部選択してなかったときしかエラーが出ない。１つでも選択するとスルーしてしまう。
      (progn
        (setq #err_flag T)
        (alert "施工図出し分けが設定されていません。")
      )
    );_if

    (if (= #err_flag nil)
      (progn
        (foreach #rule$ #rule$$
          (cond
            ((= (atoi (nth 1 #rule$)) 5)
              (if (and (= #rad5L "1") (= #rad5R "0"))
                (progn
                  (setq #value (nth 3 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 5 #value))))
                )
              )
              (if (and (= #rad5L "0") (= #rad5R "1"))
                (progn
                  (setq #value (nth 5 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 5 #value))))
                )
              )
            )
            ((= (atoi (nth 1 #rule$)) 6)
              (if (and (= #rad6L "1") (= #rad6R "0"))
                (progn
                  (setq #value (nth 3 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 6 #value))))
                )
              )
              (if (and (= #rad6L "0") (= #rad6R "1"))
                (progn
                  (setq #value (nth 5 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 6 #value))))
                )
              )
            )
            ((= (atoi (nth 1 #rule$)) 19)

              (if (and (= #rad19L "1") (= #rad19M "0") (= #rad19R "0")) ;高木水栓250
                (progn
                  (setq #value (nth 3 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 19 #value))))
                )
              )

              (if (and (= #rad19L "0") (= #rad19M "0") (= #rad19R "1")); 高木以外１５０
                (progn
                  (setq #value (nth 5 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 19 #value))))
                )
              )


              (if (and (= #rad19L "0") (= #rad19M "1") (= #rad19R "0")) ;特殊振り幅２００
                (progn
                  (setq #value (nth 7 #rule$)) ;フィールド追加
                  (setq #delLayer$ (append #delLayer$ (list (list 19 #value))))
                )
              )


            )
            ((= (atoi (nth 1 #rule$)) 20)
              (if (and (= #rad20L "1") (= #rad20R "0"))
                (progn
                  (setq #value (nth 3 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 20 #value))))
                )
              )
              (if (and (= #rad20L "0") (= #rad20R "1"))
                (progn
                  (setq #value (nth 5 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 20 #value))))
                )
              )
            )
            ((= (atoi (nth 1 #rule$)) 21)
              (if (and (= #rad21L "1") (= #rad21R "0"))
                (progn
                  (setq #value (nth 3 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 21 #value))))
                )
              )
              (if (and (= #rad21L "0") (= #rad21R "1"))
                (progn
                  (setq #value (nth 5 #rule$))
                  (setq #delLayer$ (append #delLayer$ (list (list 21 #value))))
                )
              )
            )
          )
        )

        (foreach #wt_dat$ #wt_dat$$
          (setq #delLayer$ (append #delLayer$ (list (list 7 (nth 0 #wt_dat$)))))
          (setq #delLayer$ (append #delLayer$ (list (list 11 (nth 1 #wt_dat$)))))
        )
        (setq #delLayer$ (append #delLayer$ (list (list 18 "A"))))
        (setq #delLayer$ (append #delLayer$ (list (list 22 "C01"))))

        ; 対象画層上の図形を削除
        (##DelLayer #delLayer$)

				;2018/02/15 YM ADD-S FK対応【ST施工表示2】参照
;;;		    (setq #radFKL (get_tile "radFKL"))
;;;		    (setq #radFKM (get_tile "radFKM"))
;;;		    (setq #radFKR (get_tile "radFKR"))

;;;ラジオボタン順番
;;;◎背面壁用  ●右壁用(FK)  ○左壁用(FK)
				(cond
					((= #radFKL "1") ;◎背面壁用
					 	(setq #KPCAD_KEY "RADIO_1") ;【ST施工表示2】検索KEY
				 	)
					((= #radFKM "1") ;●右壁用(FK)
					 	(setq #KPCAD_KEY "RADIO_2") ;【ST施工表示2】検索KEY
				 	)
					((= #radFKR "1") ;○左壁用(FK)
					 	(setq #KPCAD_KEY "RADIO_3") ;【ST施工表示2】検索KEY
				 	)
					(T
					 	(setq #KPCAD_KEY "")
				 	)
				);cond

				;【ST施工表示2】検索
				;2018/02/16 YM ADD 2つの条件で施工図出しわけ IH (FK対応)【ST施工表示2】に説明が詳しい
			  (ST_DelLayer2 #KPCAD_KEY)


				

				;2018/02/15 YM ADD-E

        (done_dialog)

        T
      )
    )
  ) ; ##SekouExec
;***********************************************************


;***********************************************************
  (defun ##IH (    /	 #rad20L    )
    (setq #rad20L (get_tile "rad20L"))

    (if (= #rad20L "1") ;IHだった
      (progn ;活性
        (mode_tile "radFKL" 0)
        (mode_tile "radFKM" 0)
        (mode_tile "radFKR" 0)
      )
    );_if

    (if (= #rad20L "0") ;IH以外だった
      (progn ;非活性
        (mode_tile "radFKL" 1)
        (mode_tile "radFKM" 1)
        (mode_tile "radFKR" 1)
        (set_tile "radFKL" "0")
        (set_tile "radFKM" "0")
        (set_tile "radFKR" "0")
      )
    );_if


  ) ; ##IH
;***********************************************************


  ; 図面上の天板の奥行きを取得する
  (setq #wt_dat$$ nil)
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if #ss
    (progn
      (setq #idx 0)
      (repeat (sslength #ss)
        (setq #xd_wt$ (CFGetXData (ssname #ss #idx) "G_WRKT"))
        (setq #LR (nth 30 #xd_wt$))
        (setq #oku$$
          (CFGetDBSQLRec CG_DBSESSION "奥行"
            (list
              (list "奥行" (itoa (fix (+ (car (nth 57 #xd_wt$)) 0.01))) 'INT)
            )
          )
        )
        (if (and #oku$$ (= 1 (length #oku$$)))
          (progn
            (setq #oku$ (nth 0 #oku$$))
            (setq #oku (nth 1 #oku$))
          )
          (setq #oku "-")
        )

        ;(setq #wt_dat$$ (append #wt_dat$ (list (list #oku #LR)))) ; #wt_dat$ ==> #wt_dat$$ 訂正
        (setq #wt_dat$$ (append #wt_dat$$ (list (list #oku #LR)))) ; #wt_dat$ ==> #wt_dat$$ 訂正

        (setq #idx (1+ #idx))
      )
    )
  )
	; 2017/06/12 KY ADD-S
	; フレームキッチン対応(ワークトップがないため出し分けができない=>カウンターの奥行きで処理)
	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn
			(setq #oku "")
			(setq #counters$$ (GetFrameInfo$$ nil T))
			(setq #counters$$ (nth 1 #counters$$))
			(foreach #counter$ #counters$$
				(if (= #oku "")
					(progn
						(setq #oku (strcat "D" (itoa (fix (+ (nth 1 (nth 3 #counter$)) 0.1)))))
						;(princ "\nカウンター奥行き: ")(princ #oku)(princ "\n")
						(setq #LR "?")

						;ﾌﾚｰﾑｷｯﾁﾝ(天板がない) L/Rはユーザーに聞く ;2017/09/21 YM ADD-S
						(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
							(progn
								(setq #iType1 0) ;I型
					      (initget 1 "L R")
					      (setq #sKatte (getkword "\n左右勝手を指示 /L=左勝手/R=右勝手/:  "))
								(setq CG_FK_LP #sKatte);2017/09/21 YM ADD ﾌﾚｰﾑｷｯﾁﾝ左右勝手
								(setq #LR #sKatte)
							)
						);_if

						(setq #wt_dat$$ (append #wt_dat$$ (list (list #oku #LR))))
					);progn
				);if
			);foreach
		);progn
	);if
	; 2017/06/12 KY ADD-E

  ; KP施工表示条件リストを作成する
  (setq #rule$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "KP施工表示条件")))

  ; 施工表示対象画層リストを作成する
  (setq #layer5$ nil #layer6 nil #layer19 nil #layer20 nil #layer21 nil)
  (setq #mode_flg5 nil #mode_flg6 nil #mode_flg19 nil #mode_flg20 nil #mode_flg21 nil)
  (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "ST施工表示")))
  (foreach #rec$ #rec$$
    (setq #layer     (nth 0 #rec$))
    (setq #num (atoi (nth 1 #rec$)))
    (cond
      ((= #num 5)
        (setq #layer5$ (append #layer5$ (StrParse #layer ",")))
      )
      ((= #num 6)
        (setq #layer6$ (append #layer6$ (StrParse #layer ",")))
      )
      ((= #num 19)
        (setq #layer19$ (append #layer19$ (StrParse #layer ",")))
      )
      ((= #num 20)
        (setq #layer20$ (append #layer20$ (StrParse #layer ",")))
      )
      ((= #num 21)
        (setq #layer21$ (append #layer21$ (StrParse #layer ",")))
      )
    )
  )

  ; 使っていない画層を削除する
  (command "_purge" "LA" "*" "N")

  ; 施工表示対象画層上の図形存在チェック
  ;;; 条件番号5
  (setq #flag nil)
  (foreach #layer #layer5$
    (if (= #flag nil)
      (if (ssget "X" (list (cons 8 #layer)))
        (setq #flag T)
      )
    )
  )
  ;(if (= #flag1 nil) ; #flag1 ==> #flag 訂正
  (if (= #flag nil) ; #flag1 ==> #flag 訂正
    (setq #mode_flg5 T)
  )

  ;;; 条件番号6
  (setq #flag nil)
  (foreach #layer #layer6$
    (if (= #flag nil)
      (if (ssget "X" (list (cons 8 #layer)))
        (setq #flag T)
      )
    )
  )
  (if (= #flag nil)
    (setq #mode_flg6 T)
  )

  ;;; 条件番号19
  (setq #flag nil)
  (foreach #layer #layer19$
    (if (= #flag nil)
      (if (ssget "X" (list (cons 8 #layer)))
        (setq #flag T)
      )
    )
  )
  (if (= #flag nil)
    (setq #mode_flg19 T)
  )

  ;;; 条件番号20
  (setq #flag nil)
  (foreach #layer #layer20$
    (if (= #flag nil)
      (if (ssget "X" (list (cons 8 #layer)))
        (setq #flag T)
      )
    )
  )
  (if (= #flag nil)
    (setq #mode_flg20 T)
  )

  ;;; 条件番号21
  (setq #flag nil)
  (foreach #layer #layer21$
    (if (= #flag nil)
      (if (ssget "X" (list (cons 8 #layer)))
        (setq #flag T)
      )
    )
  )
  (if (= #flag nil)
    (setq #mode_flg21 T)
  )

  (if (and (= #mode_flg5 T) (= #mode_flg6 T) (= #mode_flg19 T) (= #mode_flg20 T) (= #mode_flg21 T))
    (progn
      (setq #delLay$ nil)
      (foreach #wt_dat$ #wt_dat$$
        (setq #delLay$ (append #delLay$ (list (list 7 (nth 0 #wt_dat$)))))
        (setq #delLay$ (append #delLay$ (list (list 11 (nth 1 #wt_dat$)))))
      )
      (setq #delLayer$ (append #delLay$ (list (list 18 "A"))))
      (setq #delLayer$ (append #delLay$ (list (list 22 "C01"))))

      ; 自動削除項目に該当する画層上の図形を削除
      (##DelLayer #delLay$)

      (setq #ret T)
    )
    (progn
      ; ダイアログ表示
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
      (if (= nil (new_dialog "SEKOU_Dlg" #dcl_id)) (exit))

      ; 出し分け対象画層に図形が存在しない場合は、ラジオボタンを非活性
      (if (= #mode_flg5 T)
        (progn ;P型 or I型,L型
          (mode_tile "rad5L" 1)
          (mode_tile "rad5R" 1)
        )
      )

      (if (= #mode_flg6 T)
        (progn ;ｵｰﾙｽﾗｲﾄﾞ,ｾﾐｽﾗｲﾄﾞ
          (mode_tile "rad6L" 1)
          (mode_tile "rad6R" 1)
        )
      )

      (if (= #mode_flg19 T)
        (progn ;水栓　給水給湯
          (mode_tile "rad19L" 1)
          (mode_tile "rad19M" 1)
          (mode_tile "rad19R" 1)
        )
      )

      (if (= #mode_flg20 T)
        (progn ;20L=IH,20R=ｶﾞｽ
          (mode_tile "rad20L" 1)
          (mode_tile "rad20R" 1)
					;2018/02/16 YM ADD
	        (mode_tile "radFKL" 1)
	        (mode_tile "radFKM" 1)
	        (mode_tile "radFKR" 1)
        )
      )

; ﾗｼﾞｵﾎﾞﾀﾝ選択状態にするには (set_tile "radFKR" "1")
; ﾗｼﾞｵﾎﾞﾀﾝの値を取得するには (setq #rad5L (get_tile "rad5L"))

;;;			;IHのとき
;;;			;2018/02/15 YM ADD-S
;;;      (if (= #mode_flg99 T)
;;;        (progn ;20L=IH,20R=ｶﾞｽ
;;;          (mode_tile "radFKL" 1)
;;;          (mode_tile "radFKM" 1)
;;;          (mode_tile "radFKR" 1)
;;;        )
;;;      )
;;;			;2018/02/15 YM ADD-E

      (if (= #mode_flg21 T)
        (progn ;ｵｰﾌﾞﾝ,ｺﾝﾛのみ
          (mode_tile "rad21L" 1)
          (mode_tile "rad21R" 1)
        )
      )


;2016/06/10 YM ADD 給水給湯ふり幅２００は一時的にラジオボタン非活性
(mode_tile "rad19M" 1)
;2016/06/10 YM ADD 給水給湯ふり幅２００は一時的にラジオボタン非活性

			;2018/02/15 YM ADD
      (action_tile "rad20L" "(setq #ret (##IH))")
      (action_tile "rad20R" "(setq #ret (##IH))")

      (action_tile "accept" "(setq #ret (##SekouExec))")
      (action_tile "cancel" "(setq #ret nil) (done_dialog)")

      (start_dialog)

      (unload_dialog #dcl_id)
    )
  )

  #ret

) ;SCF_SekouLayer
;-- 2011/09/19 A.Satoh Add - S

;;;<HOM>*************************************************************************
;;; <関数名>    : ST_DelLayer2
;;; <処理概要>  : 一部不要な施工図画層の図形を削除する
;;; <戻り値>    : なし
;;; <引数>      : 画層のﾘｽﾄ(ﾜｲﾙﾄﾞｶｰﾄﾞOK)
;;; <作成>      : 2018/02/16 YM ADD
;;; <備考>      : KPCAD用(EASY用と処理が違う)
;;;*************************************************************************>MOH<
(defun ST_DelLayer2 (
	&KPCAD_KEY ;検索KEY
  /
  #EN #I #LAYER #LAYER$ #NUM #REC$$ #SS #VALUE #RET$
	#NUM1 #NUM2 #QRY$ #VALUE1 #VALUE2
  )
  (setq #layer$ nil)

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "ST施工表示2"
      (list
        (list "KPCAD_KEY"  &KPCAD_KEY  'STR)
      )
    )
  )
	(if #qry$
		(progn
			
			(setq #qry$ (car #qry$))
		  (setq #layer (nth 0 #qry$))
		  ;","区切り考慮
		  (setq #layer$ (StrParse #layer ","));画層のﾘｽﾄ

		  ;特定の画層の図形を削除
		  (foreach #layer #layer$
		    (setq #ss (ssget "X" (list (cons 8 #layer))))
		    (if (and #ss (/= 0 (sslength #ss)))
		      (progn
		        (setq #i 0)
		        (repeat (sslength #ss)
		          (setq #en (ssname #ss #i))
		          (if (entget #en)
		            (entdel #en)
		          );_if
		          (setq #i (1+ #i))
		        );repeat
		      )
		    );_if
		  );foreach

    )
  );_if
  
  (princ)
);ST_DelLayer2


;<HOM>*************************************************************************
; <関数名>    : SCFMakeMaterial2
; <処理概要>  : 展開元図作成メイン処理
; <戻り値>    : なし
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCFMakeMaterial2 (
  /
  #clayer #cecolor #osmode #kind$$ #kind$ #ang$ #DclRet$ #Kind$ #zmove
  #Skind$ #no #ssD #yashi #ang #ssdoor #z$ #save
 #MSG ; 03/06/10 YM ADD
  ; 2000/07/06 HT YASHIAC  矢視領域判定変更
  #find #i #xSp #xSs
  #sView  ; 図面種類
  )
  ;03/07/17 YM ADD-S
  (setq CG_SUISEN_YUKA "N") ; "N"(従来の水栓壁だし)
  ;03/07/17 YM ADD-E

  (WebOutLog "展開元図作成メイン処理(SCFMakeMaterial2)"); 02/09/04 YM ADD ﾛｸﾞ出力追加

  ; 2000/06/14 HT 最初に図面保存して最後に開きなおす

  ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは保存しない-->saveのみ

  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
    (progn
      ; 自動ﾓｰﾄﾞのとき"MODEL.DWG"を破棄終了して"MODEL.DWG"をOPENできないため名前を変えて保存しておく
      ; 破棄終了しないとコンロの絵や扉が消えてしまう
;;;     (command ".qsave") ; 101/10/01 YM MOD
;;;     (if (findfile (strcat CG_SYSPATH "auto.dwg")) ; 01/10/02 YM ADD-S
      ;06/06/16 AO MOD 保存形式を2004に変更
      ;(command "_saveas" "2000" (strcat CG_SYSPATH "auto.dwg"))
;-- 2011/10/06 A.Satoh Mod - S
;;;;;      (command "_saveas" CG_DWG_VERSION (strcat CG_SYSPATH "auto.dwg"))
      (command "_saveas" CG_DWG_VER_MODEL (strcat CG_SYSPATH "auto.dwg"))
;-- 2011/10/06 A.Satoh Mod - E
    )
    (CFAutoSave)
  );_if
  ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞでは保存しない

  ; 06/09/20 T.Ari ADD 基点座標をG_LSYMに設定しなおし
  (SCFWFModGLSymPosAngle)

  (CFNoSnapReset);00/08/25 SN ADD
  (CFNoSnapStart);00/08/25 SN ADD

  ; 04/04/08 ADD-S 対面プラン対応
  ; 矢視ありの時でviewpoint の位置によっては処理中断される事があるため
  ; ビューを初期化する
  (command "_.VPOINT" "0,0,1")
  ; 04/04/08 ADD-E 対面プラン対応

  ; (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" "0")
  ; (setq #cecolor (getvar "CECOLOR"))
  (setvar "CECOLOR" "BYLAYER")
  ; (setq #osmode (getvar "OSMODE"))
  (setvar "OSMODE" 0)

  (setvar "GRIDMODE" 0)  ; 2000/09/12 速度改善
  (setvar "ORTHOMODE" 0) ; 2000/09/12 速度改善
  (setvar "SNAPMODE" 0)  ; 2000/09/12 速度改善

  ; 2000/07/06 HT YASHIAC  矢視領域判定変更 ADD
  (setq CG_UTypeWT nil)
  (setq CG_TABLE nil)

  (if (/= nil CG_KENMEI_PATH)
    (progn
      ; 2000/07/06 HT YASHIAC  矢視領域判定変更 START
      ;// 旧バージョンの矢視を警告
      (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))
      (if #xSp
        (progn
          (setq #i 0)
          (repeat (sslength #xSp)
            (if (= "LWPOLYLINE" (cdr (assoc 0 (entget (ssname #xSp #i)))))
              (CFAlertErr (strcat "旧バージョンのシステムＣＡＤで作成された矢視があります.\n"
                                  "矢視削除で矢視を削除してから展開図作成して下さい"))
            )
            (setq #i (1+ #i))
          )
        )
      );_if
      ; 2000/07/06 HT YASHIAC  矢視領域判定変更 END

      ; 01/05/30 TM ADD EF矢視があるのにABCD矢視がない場合は作図しない
      (if (and (SCFIsYashiType #xSp "*[EF]*") (not (SCFIsYashiType #xSp "*[ABCD]*")))
        (progn
          (CFAlertErr (strcat "ABCD矢視がありません.\n"
                              "矢視設定でABCD矢視を作成して下さい"))
        )
        (progn
;;;(makeERR "展開1-1") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 展開-1-1
          ;ダミー領域設定
          (WebOutLog "ダミー領域設定(SetDummyArea)"); 02/09/04 YM ADD ﾛｸﾞ出力追加
          (SetDummyArea)
          ;データ獲得
          (setq #kind$$ (GetMaterialData))
          (if (/= nil #kind$$)
            (progn
              (setq #kind$  (car  #kind$$))
              (setq #ang$   (cadr #kind$$))
              (if (/= CG_OUTCMDNAME "SCFLayPrs")
                (progn
                ;展開元図種類獲得
                ; ダイアログ表示

                  ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞではﾀﾞｲｱﾛｸﾞ表示しない
                  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
                ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
                    (setq #DclRet$ CG_AUTOMODE_TENKAI)
                    (setq #DclRet$ (SCFGetBlockKindDlg (mapcar 'car #kind$)))
                  );_if
                  ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞではﾀﾞｲｱﾛｸﾞ表示しない

                )
                (progn
                ; パース元図自動作成レイアウトの時
                ; 平面図が選択された状態とする
                  (setq #DclRet$ (list (list 1 0 0) (list "0")))
                )
              );_if

              ;03/07/17 YM ADD-S
              (if (and #DclRet$ (nth 2 #DclRet$))
                (setq CG_SUISEN_YUKA (nth 2 #DclRet$)) ; "Y"(床立上げ) or "N"(従来の壁だし)
                ;else
                (setq CG_SUISEN_YUKA "N") ; "N"(従来の壁だし)
              );_if
              ;03/07/17 YM ADD-E

              ; 展開図作成チェック
              ; 図面作成用データを
              ;   ((平面図用データ) (展開図用データのリスト) 仕様図作成有無)のリストに整理する
              (setq #Kind$ (SCFCheckExpand #kind$ #DclRet$))
              (if (/= nil #Kind$)
                (progn
                  ;; 作成済み展開元図を削除 01/07/27 HN ADD
                  ;; 確認ダイアログ表示
                  (KPfDelBlockDwg)

                  ; 2000/06/22 HT ADD 速度改善
                  ; 陰線処理 された状態よりワイアフレームのほうが処理速度が速い
                  ; ワイアフレームにする
                  (C:2DWire)
                  ; 断面指定図形及びバルーン文字のZ座標移動量
                  (setq #zmove 10000)
                  (princ "\n展開図作成中…\n")
                  ; コンロ及びシンク、水栓の断面をキャビ側面に移動
                  ; (PKC_MoveToSGCabinet) 2001/03/03 KS DEL

                  ;Head.cfgファイル書き出し
                  ; (SKB_WriteHeadList) 2000/10/12 HT DEL CfAutoSave内で対応

                  ;// 特注ワークトップ情報
                  (PKOutputWTCT)

                  ; 2000/06/30 HT 展開元図用画層がフリーズorロックされていたら解除する
                  ;               展開元図用画層が作成されている(本来ありえない?)場合の対応
                  (SCF_LayDispOn
                    (list "0_door" "0_plane" "0_dim" "0_plin_1" "0_plin_2" "0_pers"
                          "0_side_A" "0_side_B" "0_side_C" "0_side_D" "0_side_E" "O_sode_F" "0_KUTAI"))
;;;(makeERR "展開1-2") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 展開-1-2
                  ;領域毎に展開元図作成
                  ;-- 平面図 ... 最初のデータ
                  (if (/= nil (nth 0 #kind$))
                    (progn
                      (princ "\n平面図作成中…\n")
                      (WebOutLog "平面図作成中…"); 02/09/04 YM ADD ﾛｸﾞ出力追加
                      (mapcar
                       '(lambda ( #Skind$ )
                          (setq #no    (nth 0 #Skind$))           ; 領域番号
                          (setq #ssD   (nth 1 #Skind$))           ; ダミー領域選択エンティティ
                          (setq #yashi (nth 2 #Skind$))           ; 矢視領域図形名
                          ;(setq #ang   (cadr (assoc #no #ang$)))  ; 角度
                          (setq #ang (cadr (nth 0 #ang$)))  ; 角度

                          ;ダミー領域再作成  00/04/07
                          (SetDummyAgain #ssD #yashi)
                          (if (/= CG_OUTCMDNAME "SCFLayPrs")
                            (SCFMakeBlockPlan "P" #no #ssD #yashi #ang "0_PLANE" "0_DIM")
                          )
                          (SCFMakeBlockPers "M" #no #ssD #yashi #ang "0_PERS")
                        )
                        (nth 0 #kind$)
                      )
                    )
                  )
                  ;-- 仕様図を作成するか？
                  (if (/= nil (nth 2 #kind$))
                    (progn
                      (princ "\n仕様図作成中…\n")
                      (WebOutLog "仕様図作成中…"); 02/09/04 YM ADD ﾛｸﾞ出力追加
    ;;;01/03/25YM@                  ; 01/05/22 YM 2回目以降仕様表番号を書かなくなる
    ;;;01/03/25YM@                  (setq #sFname (strcat CG_KENMEI_PATH "TABLE.CFG"))
    ;;;01/03/25YM@                  (if (= (findfile #sFname) nil)
    ;;;01/03/25YM@                    (SCFMakeBlockTable);Table.cfgを検索無ければ書き出す。
    ;;;01/03/25YM@                  );_if
                      (SCFMakeBlockTable)  ;仕様書 古いタイプのTable.cfg出力しない

                      (setq CG_TABLE T) ; Table.cfg作成ﾌﾗｸﾞ 01/02/07 YM

                    )
                  )
                  ;-- 展開図 ... ２番目のデータ
                  (if (/= nil (nth 1 #kind$))
                    (progn
                      (princ "\n展開図作成中…\n")
                      (WebOutLog "展開図作成中…"); 02/09/04 YM ADD ﾛｸﾞ出力追加
                      ;2D扉面作成
                      ; 2000/06/22 HT ADD 速度改善
                      ;(setq #ssdoor (AlignDoorBySym$ (mapcar 'cadr (nth 1 #kind$))))
                      (AlignDoorBySym$ (mapcar 'cadr (nth 1 #kind$)))
                      ; M_画層の図形をすべて削除する HT 2000/09/12  START
                      ; パース図作成後 画層"M_*"の図形をすべて削除して速度改善をはかる
                      (setq #xSs (ssget "X" (list (cons 8 "M_*"))))
                      (if #xSs
                        (command "erase" #xSs "")
                      )
                      ; 01/06/06 TM MOD-S 図面の角度データ取得を変更
                      (foreach #Skind$ (nth 1 #kind$)
                        (setq #no    (nth 0 #Skind$))    ; 領域番号
                        (setq #ssD   (nth 1 #Skind$))    ; ダミー領域選択エンティティ
                        (setq #yashi (nth 2 #Skind$))    ; 矢視領域図形名;矢視領域判定変更により常にnil
                                                         ; これにより、ワークトップ取得時に旧領域では
                                                         ;  判定しなくなる
                        ; 01/06/06 TM MOD 角度は図面種類ごとに異なるので以下で取得するように変更
                        ;(setq #ang   (cadr (assoc #no #ang$)))  ; 角度
                        (setq #z$    (nth 3 #Skind$))    ; 図面種類

                        ;ダミー領域再作成  00/04/07
                        (SetDummyAgain #ssD #yashi)

                        (if (and (/= nil #ssD) (/= 0 (sslength #ssD)))
                          (progn
                            (foreach #sView #z$
                              (if (and #sView (/= 0 #sView)) ; 展開図ABCDEF
                                (progn
                                  ; 図面種類に対応した角度データを取得する
                                  (setq #ang (KCFGetExpandAngle #kind$$ #sView))
                                  (if #ang
                                    (progn
                                      ; 展開図を作図する
                                      (SCFMakeBlockExpand
                                        (strcat "S" #sView) #no #ssD #yashi #ang
                                        (strcat "0_SIDE_" #sView) "0_DIM" #sView #zmove #ssdoor)
                                    )
                                  );_if
                                )
                              );_if
                            );_foreach
                          )
                        );_if
                      );_ foreach
                      ; 01/06/06 TM MOD-E 図面の角度データ取得を変更
                    )
                  );_if (/= nil (nth 1 #kind$))

                  (princ "\n展開図作成中…終了")
                  (WebOutLog "展開図作成中…終了"); 02/09/04 YM ADD ﾛｸﾞ出力追加
                  (setq #save T)
                )
              );_if (/= nil #Kind$)
            )
          );_if (/= nil #kind$$)
          ;ダミー領域削除
          (DelDummyArea)
        )
      );_if (not (SCFIsYashiType #xSp "*[ABCD]*"))
    )
    (progn
      (setq #msg "物件が呼び出されていません")
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  )

  ; 2000/06/22 HT ADD  (扉処理用のフラグクリア)
  (setq CG_OUTCMDNAME nil)

  ; 2000/06/14 HT 最初に図面保存して開きなおす
  ; (if (/= nil #save)
  ;   ;強制的に保存
  ;  (CFAutoSave)
  ; )
  ; (setvar "CLAYER" #clayer)
  ; (setvar "CECOLOR" #cecolor)
  ; (setvar "OSMODE" #osmode)
  ; (setq *error* nil)

;;;(makeERR "展開1-3") ; 強制的にｴﾗｰ作成@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 展開-1-3

;;;  (princ)
  #Kind$ ; 01/02/20 YM ADD 引数追加
) ; SCFMakeMaterial2

;<HOM>*************************************************************************
; <関数名>    : KP_MakePrs
; <処理概要>  : ﾊﾟｰｽ図のみの作成(WEB版呼出し用)
; <戻り値>    : なし
; <作成>      : 03/05/16 YM
; <備考>      : \BLOCK\M_0.dwg
;*************************************************************************>MOH<
(defun KP_MakePrs (
  /
  #ANG #KIND$ #KIND$$ #NO #SSD #YASHI
  )
  (SetDummyArea)
  (setq #kind$$ (GetMaterialData));展開元図作成用のデータを獲得する
  (setq #kind$  (car (car #kind$$)))
  (setq #no     (nth 0 #kind$))   ; 領域番号
  (setq #ssD    (nth 1 #kind$))   ; ダミー領域選択エンティティ
  (setq #yashi  (nth 2 #kind$))   ; 矢視領域図形名
  (setq #ang 0.0)                 ; 角度
  (SCF_LayDispOn                  ;非表示orフリーズorロック解除する
    (list "0_door" "0_plane" "0_dim" "0_plin_1" "0_plin_2" "0_pers"
          "0_side_A" "0_side_B" "0_side_C" "0_side_D" "0_side_E" "O_sode_F" "0_KUTAI"))
  ;ダミー領域再作成
  (SetDummyAgain #ssD #yashi)
  (SCFMakeBlockPers "M" #no #ssD #yashi #ang "0_PERS")
  #ssD ; ダミー領域選択エンティティ
);KP_MakePrs

;<HOM>*************************************************************************
; <関数名>    : C:KP_MakePrsOnly
; <処理概要>  : ﾊﾟｰｽのみ再作成
; <戻り値>    : なし
; <作成>      : 03/06/09 YM
; <備考>      :
;*************************************************************************>MOH<
(defun C:KP_MakePrsOnly (
  /
  #GRIDMODE #ORTHOMODE #OSMODE #SNAPMODE #ssD #SSSKDM
  )
  ;// コマンドの初期化
  (StartUndoErr)

  ;// ビューを登録
  (command "_view" "S" "TEMP_MkPrs")

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)

  ;ﾊﾟｰｽ作成処理
  (setq #ssD (KP_MakePrs)) ; ダミー領域選択エンティティ

  (if (and #ssD (< 0 (sslength #ssD)))
    (command "_erase" #ssD "")
  );_if

  (setq #ssSKDM (ssget "X" '((-3 ("G_SKDM")))))

  (if (and #ssSKDM (< 0 (sslength #ssSKDM)))
    (command "_erase" #ssSKDM "")
  );_if

  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)

  ;// ビューを戻す
  (command "_view" "R" "TEMP_MkPrs")

  (setq *error* nil)
  (princ)
);C:KP_MakePrsOnly

;<HOM>*************************************************************************
; <関数名>    : KCFGetExpangAngle
; <処理概要>  : 展開元図／展開図の角度を取得する
; <戻り値>    : 角度
; <作成>      : 01/06/05 TM
; <備考>      : なし
;*************************************************************************>MOH<
(defun KCFGetExpandAngle (
  &kind$$   ; 展開元図作成用データ
  &sYashi   ; 対象となる矢視データ
  /
  #kind$    ; 展開元図作成用データの矢視部分
  #ang$     ; 展開元図作成用データの角度部分
  #skk$ #saa$ #sss ; 操作変数
  #rRet     ; 戻り値
  )
  ; データを分ける
  (setq #kind$  (car  &kind$$))
  (setq #ang$   (cadr &kind$$))

  ; 指定した図面種類の含まれるデータを探す
  (mapcar
    '(lambda (#skk$ #saa$)
      (foreach #sss (nth 3 #skk$)
        (if (= 'STR (type #sss))
          (progn
            (if (= &sYashi #sss)           ; 図面種類
              (progn
                (setq #rRet (cadr #saa$))
              )
            );_if
          )
        );_if
      );_foreach
    )
    #kind$ #ang$
  )
  #rRet

); KCFGetExpandAngle

;<HOM>*************************************************************************
; <関数名>    : GetMaterialData
; <処理概要>  : 展開元図作成用のデータを獲得する
; <戻り値>    : (((平面の 領域番号、ダミー領域選択エンティティー、矢視領域図形名)
;             :  (展開の 領域番号、ダミー領域選択エンティティー、矢視領域図形名)
;             :  (仕様表の 領域番号、ダミー領域選択エンティティー、矢視領域図形名))
;             :  (領域の角度 領域の角度 ・・・)
;             :  )
; <作成>      : 00/02/15
; <備考>      : なし
;*************************************************************************>MOH<

(defun GetMaterialData (
  /
  #xSp #no #ssD #sssym #sType #Skind$ #kind$ #ang$ #iI
  #eEn #ed$ #sDang #sYashi #sDy #ang
  #nII
  #ssTT
  #eTT$
  #eTT0$
  #eTTPrev
  #eTT
  #xTT$
  )

  (defun ##mergelists (
    &list_a$
    &list_b$
    /
    #atom
    #merged_list$
    )
    (setq #merged_list$ &list_a$)
    (foreach #atom &list_b$
      (if (not (member #atom #merged_list$))
        (setq #merged_list$ (cons #atom #merged_list$))
      )
    )
    #merged_list$
  )


  ; シンボル図形の選択セットを作成
  (setq #ssD (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_SKDM")))))
  (if (= nil #ssD) (setq #ssD (ssadd)))

;|
  ; 01/07/13 TM ADD 追加して調査中
  ; Ｊトップを検索する .... 遅すぎ。もう少し早くする方法は？
  (setq #ssTT (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_*")))))
  (setq #nII 0)
  (repeat (sslength #ssTT)
    (setq #eTT0$ (CFGetGroupEnt (ssname #ssTT #nII)))
    (if #eTT$
      (setq #eTT$ (##mergelists #eTT$ #eTT0$))
      (setq #eTT$ (list #eTT0$))
    )
    (setq #nII (1+ #nII))
  )

  ; 性格CODEが 717(=Jトップ) の図形を取得する
  (foreach #eTT #eTT$
    (if
      (and
        #eTT
        (not (equal #eTT #eTTPrev))
        (setq #xTT$ (CFGetXData #eTT "G_LSYM"))
        (equal (nth 9 #xTT$) 717)
      )
      (progn
        ; 該当の図形の４点座標を求める
        (setq #dTT (GetSym4Pt #eTT))

        ; ワークトップと領域が重なるか？

      )
    )
    (setq #eTTPrev #eTT)
  )
|;
  ; 01/07/13 TM ADD 追加して調査中


  ;2010/11/30 YM ADD-S
  (if (= CG_AUTOMODE 2)
    ;矢視領域作図(関数化)
    (DrawYashiArea);2010/11/30 YM ADD
  );_if
  ;2010/11/30 YM ADD-E


  ; 矢視図形獲得
  (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))
  (if (= nil #xSp)
    ; 矢視設定なしの場合
    (progn

      ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは警告しない
      (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
    ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
        nil
        (CFAlertMsg "矢視設定がされていません。自動で判断します")
      );_if
      ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞでは警告しない

      (setq #no   "0")
      ;(setq #ssD (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_SKDM")))))
      ;(if (= nil #ssD) (setq #ssD (ssadd)))
      ;シンボル図形から自動で判断
      (setq #sType (SKGetKichenType nil))
      (cond
        ((or (equal #sType "I-RIGHT") (equal #sType "I-LEFT"))
          (setq #Skind$    (list "A" "B"  0  "D"  0  0))
        )
        ;_(or (equal #sType "L-RIGHT") (equal #sType "W-LEFT"))
        ((equal #sType "L-RIGHT")
          (setq #Skind$    (list "A"  0   0  "D"  0  0))
        )
        ;_(or (equal #sType "L-LEFT")  (equal #sType "W-RIGHT"))
        ((equal #sType "L-LEFT")
          (setq #Skind$    (list "A" "B"  0   0   0  0))
        )
        ((or (equal #sType "D-RIGHT") (equal #sType "D-LEFT"))
          (setq #Skind$    (list "A" "B"  0  "D"  0  0))
        )
      )
      (if (/= nil #Skind$)
        (progn
          (setq #kind$
            (list
              (list #no #ssD nil (list "P"))    ; 平面図
              (list #no #ssD nil #Skind$)       ; ABCD方向展開図
            )
          )
          (setq #ang$
            (list
              (list "0" 0.0)    ; 平面図
              (list "0" 0.0)    ; 展開図
            )
          )
        )
      )
    )
    ; 矢視が存在する場合
    (progn
      (setq #iI 0)

      (repeat (sslength #xSp)

        ; 矢視図形の拡張データ
        (setq #eEn (ssname #xSp #iI))
        (setq #ed$    (CfGetXData #eEn "RECT"))
        ;(princ "\n矢視拡張(番号 角度 矢視種類): ")
        ;(princ #ed$)

        (setq #no     (nth 0 #ed$))              ; 領域番号
        (setq #sDang  (nth 1 #ed$))              ; 矢視角度
        (setq #sYashi (nth 2 #ed$))              ; 作成矢視記号 "ABD"

        ; 各方向に対応する方向データを作成する
        (setq #Skind$ nil)
        (foreach #sDy '("A" "B" "C" "D" "E" "F")
          (if (wcmatch #sYashi (strcat "*" #sDy "*"))
            (setq #Skind$ (cons #sDy #Skind$))
            (setq #Skind$ (cons 0    #Skind$))
          )
        )
        ; いずれかの方向の矢視が存在する場合、図面種類と角度のデータを追加する
        (if (/= nil #Skind$)
          (progn
            (setq #kind$ (cons (list #no #ssD nil (reverse #Skind$)) #kind$))

            ; 2000/07/06 HT YASHIAC  矢視領域判定変更 END
            (if (/= nil (angtof #sDang))
              (progn
                (setq #ang (Angle0to360 (- (* 0.5 PI) (angtof #sDang))))
                (setq #ang$ (cons (list #no #ang) #ang$))
              )
            );_if
          )
        );_if

        (setq #iI (1+ #iI))

      ) ; repeat

      ; 平面図を固定データとして追加する ; 01/05/25 TM 展開図なしはたぶんありえないけど
      (setq #kind$ (cons (list #no #ssD nil (list "P")) #kind$))
      (setq #ang$ (cons (list #no 0.0) #ang$))

      ; 01/05/25 TM 意図が不明なコード
;      (if (= nil #ang$)
;       (foreach #no (mapcar 'car #kind$)
;         (setq #ang$ (cons (list #no 0.0) #ang$))
;       )
;      )
;      (if (> (sslength #xSp) 1)
;        (progn
;         (setq #eEn (ssname #xSp 0))
;         (setq #ed$  (CfGetXData #eEn "RECT"))
;         (if (/= "E" (nth 2 #ed$))
;             (progn
;             (setq #ang$ (reverse #ang$))
;             (setq #kind$ (list (nth 1 #kind$)(nth 0 #kind$)(nth 2 #kind$)))
;           )
;         )
;       )
;      )

    )
  );_if (/= nil #xSp)

  (list #kind$ #ang$)
) ; GetMaterialData


;<HOM>*************************************************************************
; <関数名>    : DrawYashiArea
; <処理概要>  : 矢視領域を自動作図
; <戻り値>    : なし
; <作成>      : 2010/11/30
; <備考>      : 
;*************************************************************************>MOH<
(defun DrawYashiArea ( / )
  ; 対面プランは矢視自動矢視ＡＢＤＥとする
  (cond
    ((= CG_PlanType "SK")

      ; I型プランかどうかを判定する
      (if (= "I00" (nth  5 CG_GLOBAL$))
        (progn
          (if (= CG_HOOD_FLG "IP")
            ;I型でP型ﾌｰﾄﾞ
            (KCFAutoMakeTaimenPlanYashi);P型なら矢視領域自動設定
          ;else
            (KCFAutoMakeIgataPlanYashi);I型なら矢視領域自動設定
          );_if
        )
        ;I型以外のとき
        (progn
          ; 対面プランかどうかを判定する
          (setq #sfpType (SCFIsTaimenFlatPlan))
          (if #sfpType
            (KCFAutoMakeTaimenPlanYashi);P型なら矢視領域自動設定
          );_if
        )
      );_if

    )

    ;SK以外 収納のとき

    ;((= CG_SeriesDB "SDA") ;2011/02/01 YM MOD【PG分岐】
    ((= BU_CODE_0001 "1")
      (KCFAutoMakeDiningPlanYashi);収納I配列なら矢視領域自動設定
    )
    ;((= CG_SeriesDB "SDB") ;2011/02/01 YM MOD【PG分岐】
    ((= BU_CODE_0001 "2")
      ;2009/1/26 YM ADD 収納拡大
      (KCFAutoMakeDiningPlanYashi_EXTEND);収納拡大
    )
    (T ;__OTHER
      (KCFAutoMakeDiningPlanYashi_EXTEND);収納拡大
    )
  );_cond
  (princ)
);DrawYashiArea


;<HOM>*************************************************************************
; <関数名>    : GetDaByRyoiki
; <処理概要>  : 矢視領域内のダミー領域を獲得する
; <戻り値>    : 矢視領域内にあるダミー領域選択エンティティ
; <作成>      : 00/02/15
; <備考>      : なし
;*************************************************************************>MOH<

(defun GetDaByRyoiki (
  &en         ; 領域図形名
  /
  #ypt$ #ss #i #en #pt$ #flg #pt #en$
  )
  ;矢視領域図形の座標を獲得する
  (setq #ypt$ (mapcar 'car (get_allpt_H &en)))
  (setq #ypt$ (append #ypt$ (list (car #ypt$))))

  ;ダミー領域獲得
  (setq #ss (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_SKDM")))))

  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #pt$ (mapcar 'car (get_allpt_h #en)))
        (setq #flg T)
        (mapcar
         '(lambda ( #pt )
            (if (not (CFAreaInPt #pt #ypt$))
              (setq #flg nil)
            )
          )
          #pt$
        )
        (if (/= nil #flg)
          (setq #en$ (cons #en #en$))
        )
        (setq #i (1+ #i))
      )
    )
  )

  (En$2Ss #en$)
) ; GetDaByRyoiki


;<HOM>*************************************************************************
; <関数名>    : GetDaByRyoiki2
; <処理概要>  : ダミー領域を獲得する
; <戻り値>    : ダミー領域選択エンティティ
; <作成>      : 00/02/15
; <備考>      : 矢視領域の判定なしにした
;             : 2000/07/06 HT YASHIAC  矢視領域判定変更
;             : 関数追加
;*************************************************************************>MOH<

(defun GetDaByRyoiki2 (
  &en         ; 領域図形名
  /
  #ypt$ #ss #i #en #pt$ #flg #pt #en$
  )
  ;ダミー領域獲得
  (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_SKDM"))))
) ; GetDaByRyoiki2

;<HOM>*************************************************************************
; <関数名>    : GetDaByRyoiki3
; <処理概要>  : 矢視領域を獲得する
; <戻り値>    : 矢視領域図形エンティティ
; <作成>      : 01/04/20 TM
; <備考>      : 矢視領域データがある場合のみ返す
;*************************************************************************>MOH<
(defun GetDaByRyoiki3 (
  &eEn        ; 矢視図形名
  &sYashi     ; 矢視 "A" "B" "C" "D" "E" 等
  /
  #eXd$       ; 拡張データ(矢視)
  #eYas$      ; 領域エンティティ
  #nPos       ; 指定矢視の位置
  )

  ; 矢視座標
  ; DEBUG (princ "\n#dPt0 ")
  ; DEBUG (setq #dPt0 (cdr (assoc 10 (entget &eEn))))
  ; DEBUG (princ #dPt0)

  ; 矢視領域の拡張属性を取得
  ; DEBUG (princ "\nXdata: ")
  (setq #eXd$ (CFGetXData &eEn "RECT"))
  ; DEBUG (princ #eXd$)

  ; 3 番目の項目(矢視方向文字列) の中に指定する矢視が存在するか？
  (if (setq #nPos (vl-string-search &sYashi (nth 2 #eXd$)))

    ; 4 番目の項目(矢視領域指定図形ハンドル)の有無をチェック
    (if (nth (+ 3 #nPos) #eXd$)
      ; 矢視領域指定図形ハンドルがある場合は、その図形を返す
      (progn
        (setq #eYas$ (handent (nth (+ 3 #nPos) #eXd$)))
      )
    )
  )

  #eYas$

) ;_ GetDaByRyoiki3

;<HOM>*************************************************************************
; <関数名>    : KCFGetDaByYasReg
; <処理概要>  : 矢視領域を獲得する
; <戻り値>    : 矢視領域点列
; <作成>      : 01/04/23 TM
; <備考>      : 矢視領域データがある場合は領域の点列
;               ない場合は矢視基点から矢視方向、左、右に5000 ずつの矩形の４点
;               01/05/31 TM 平面図／パース図は対象外
;*************************************************************************>MOH<
(defun KCFGetDaByYasReg (
  &eEn        ; 矢視図形エンティティ
  &sType      ; 矢視 "A" "B" "C" "D" "E" "F"
  /
  #eYas           ; 領域エンティティ
  #dYas$          ; 領域点列
  #p1 #p2 #p3 #p4 ; 自動判定した領域の端点
  #dPt0           ; 矢視座標
  #rAng           ; 基準とする矢視の向き
  #rYsAng         ; 指定した矢視の向き
#SXD$ ; 03/06/10 YM ADD
  )
  ; 領域図形エンティティを取得
  (setq #eYas (GetDaByRyoiki3 &eEn &sType))

  ; DEBUG (princ "\n矢視:")
  ; DEBUG (princ &sType)
  ; 領域図形がある場合は点を取得する
  (if #eYas
    (progn
      (setq #dYas$ (GetLwPolyLinePt #eYas))
      ; DEBUG (princ " 矢視領域あり: ")
      ; DEBUG (princ #dYas$)
    )
  )
  ; 点列が存在しない場合、自動設定する
  (if (not #dYas$)
    (progn
      ; 矢視図形の基点と角度を取得
      (setq #dPt0 (cdr (assoc 10 (entget &eEn))))
      (setq #sXd$ (CFGetXData &eEn "RECT"))
      (setq #rAng (dtr (atoi (nth 1 #sXd$))))


    ;  矢視領域自動判定の基準
    ;
    ;
    ;                       10000
    ;         p3 ------------------------------- p2
    ;            |                             |
    ;            |                             |
    ;            |                             |
    ;            |         (&sType="P")        |
    ;            |             ↑              |
    ;     10000  |             ○              |   10000
    ;            |            (平面図の計算用) |
    ;            |                             |
    ;            |        指定矢視方向         |
    ;            |          (&sType)           |
    ;            |             ↑              |
    ;         p4 |-----------  ○  ----------- | p1   --> A方向
    ;
    ;       範囲に矢視が入っているかどうか
    ;

      ; A 矢視からの相対方向で計算する
      (cond
        ((wcmatch &sType "*A*")
          (setq #rYsAng #rAng)
        )
        ((wcmatch &sType "*B*")
          (setq #rYsAng (- #rAng (dtr 90)))
        )
        ((wcmatch &sType "*C*")
          (setq #rYsAng (- #rAng (dtr 180)))
        )
        ((wcmatch &sType "*D*")
          (setq #rYsAng (- #rAng (dtr 270)))
;         (setq #rYsAng (+ #rAng (dtr 90)))
        )
        ; 追加矢視
        ; 追加矢視には領域が必ずある
        ((wcmatch &sType "*[EF]*")
          (CfAlertErr "Ｅ矢視の矢視領域が設定されていません。\n追加矢視設定で設定し直してください。")
          (quit)
        )
        ; 01/05/31 TM DEL-S この部分は使用しない。このまま使うと現状平面図のWT が見えなくなる不具合あり
        ; 平面図 01/04/26 TM ZAN
        ;@DEL@ ((or (wcmatch &sType "*P*") (wcmatch &sType "*M*"))
        ;@DEL@  ; 平面図の計算上の矢視角度は 正面向き(=B 矢視と同角度)
        ;@DEL@  (setq #rYsAng (dtr (- 90)))
        ;@DEL@  ; 矢視座標が自動作成矢視領域の正方形の中心となるように調整
        ;@DEL@  (setq #dPt0  (polar #dPt0  0.0       5000))
        ;@DEL@ )
        ; 01/05/31 TM DEL-E この部分は使用しない。このまま使うと現状平面図のWT が見えなくなる不具合あり
      )
      ; 平面図／パース図、または指定矢視に領域がない展開図（=自動領域設定用矢視角度が生成済み）の場合
      (if #rYsAng
        (progn
          (setq #p1 (polar #dPt0 (- #rYsAng (dtr 90))  5000))
          (setq #p2 (polar #p1      #rYsAng           10000))
          (setq #p3 (polar #p2   (+ #rYsAng (dtr 90)) 10000))
          (setq #p4 (polar #dPt0 (+ #rYsAng (dtr 90))  5000))

          (setq #dYas$ (list #p1 #p2 #p3 #p4))
          ; DEBUG (princ "自動取得:")
          ; DEBUG (princ " 矢視角度:")
          ; DEBUG (princ #rYsAng)
          ; DEBUG (princ " 基準角度:")
          ; DEBUG (princ #rAng)
          ; DEBUG (princ " 領域:")
          ; DEBUG (princ #dYas$)
        )
        (progn
          ;(princ "\n矢視領域自動取得失敗")
        )
      )
    )
  )

  #dYas$

) ;_ KCFGetDaByYasReg


;<HOM>*************************************************************************
; <関数名>    : SCFCheckExpand
; <処理概要>  : 展開元図作成チェック
; <戻り値>    : 作成する図面種類
; <作成>      : 99/11/26
; <備考>      : なし
;*************************************************************************>MOH<

(defun SCFCheckExpand (
  &kind$      ; 作成できる領域番号と図面種類リスト
  &DclRet$    ; ダイアログ返り値
  /
  #shiyou #DclRet$ #str #no #plane #expand #kind #p #pkind$ #e #ekind$ #skind #kind$
  )
  ;---  仕様表チェック  ----
  (if (equal (list 1 0) (cdr (car &DclRet$)))
    (progn
      (setq #shiyou "展開図を作成すると自動的に仕様表も更新されます。")
      (setq #DclRet$ (list (cons (car (car &DclRet$)) (list 1 1)) (cadr &DclRet$)))
    )
    (progn
      (setq #DclRet$ &DclRet$)
    )
  );_if
  ;-------------------------
  (setq #str "")
  (mapcar
   '(lambda ( #no )
      (setq #plane  nil)
      (setq #expand nil)
      (mapcar
       '(lambda ( #kind )
            (if (= "P" (car (nth 3 #kind)))
              (setq #plane  (cons #kind #plane))
              (setq #expand (cons #kind #expand))
            )
        )
        &kind$
      )
      ;平面図
      (if (and (= 1 (nth 0 (car #DclRet$))) (/= nil #plane))
        (mapcar
         '(lambda ( #p )
            (setq #pkind$ (cons #p #pkind$))
          )
          #plane
        )
        (if (= 1 (nth 0 (car #DclRet$)))
          (setq #str (strcat #str "平面図\n"))
        )
      )
      ;展開図
      (if (and (= 1 (nth 1 (car #DclRet$))) (/= nil #expand))
        (mapcar
         '(lambda ( #e )
            (setq #ekind$ (cons #e #ekind$))
          )
          #expand
        )
        (if (= 1 (nth 1 (car #DclRet$)))
          (setq #str (strcat #str "展開図\n"))
        )
      )
      ;仕様表
      (if (= 1 (nth 2 (car #DclRet$)))
        (setq #skind T)
      )
    )
    (cadr #DclRet$)
  )

  ;---- エラー出力  ----
  ;矢視判定
  (if (/= 0 (strlen #str))
    (progn
      (CFAlertMsg (strcat #str "\nの展開元図は作成できません\n矢視設定をおこなってください"))
      (setq #kind$ nil)
    )
    (progn
      ;仕様表
      (if (/= nil #shiyou)
        (CfAlertMsg #shiyou)
      )
      (if (and (= nil #pkind$)(= nil #ekind$) (= nil #skind))
        (setq #kind$ nil)
        (setq #kind$ (list #pkind$ #ekind$ #skind))
      )
    )
  );_if

  #kind$
) ; SCFCheckExpand


;<HOM>*************************************************************************
; <関数名>    : SCFMakeBlockPers
; <処理概要>  : 展開元図作成 パース図
; <戻り値>    : なし
; <作成>      : 99/11/29
; <備考>      : なし
;*************************************************************************>MOH<

(defun SCFMakeBlockPers (
  &sType      ; 図面タイプ
  &sNo        ; 領域番号
  &ssD        ; ダミー領域選択エンティティ
  &yashi      ; 矢視領域図形名
  &ang        ; 回転角度
  &sLayer     ; パース図画層
  /
  #ss_n #i #enD #ed$ #sym #en$ #en #layer #eg #subst #xWt
#entlast ;-- 2011/12/27 A.Satoh Add
  )

  (setq #ss_n (ssadd))
  (setq #i 0)
  (repeat (sslength &ssD)
    (setq #enD (ssname &ssD #i))
    (setq #ed$ (CfGetXData #enD "G_SKDM"))
    (mapcar
     '(lambda ( #sym )
        ;シンボルと同じグループの図形を獲得
        (setq #en$ (CFGetGroupEnt #sym))
        (mapcar
         '(lambda ( #en )
            (setq #layer (strcase (cdr (assoc 8 (entget #en)))))
            (if
              (or
                (wcmatch #layer "Z_00*")
                (wcmatch #layer "M_*")
                (wcmatch #layer "Z_KUTAI")  ; 01/02/04 HN ADD パース図に躯体画層を追加
              )
              (progn
                ;図形データ取得
                (setq #eg (entget #en '("*")))
                (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
                ;図形コピー
                ;修正  00/04/12  START -----------
                (if (/= "POLYLINE" (cdr (assoc 0 #subst)))
                  (progn
                    (entmake #subst)
                  )
                  (progn
                    (entmake #subst)
                    (while (/= "SEQEND" (cdr (assoc 0 (entget (setq #en (entnext #en))))))
                      (setq #eg (entget #en '("*")))
                      (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                      (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
                      (entmake #subst)
                    )
                    (setq #eg (entget #en '("*")))
                    (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                    (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
                    (entmake #subst)
                  )
                )
                ;修正  00/04/12  END -----------
                ;選択セットに追加
                (ssadd (entlast) #ss_n)
              )
            )
          )
          #en$
        )
      )
      (cdr (cdr #ed$))
    )
    (setq #i (1+ #i))
  )

  (setq #xWt (GetWtAndFilr &yashi "M"))
  (if (/= nil #xWt)
    (progn
      (setq #i 0)
      (repeat (sslength #xWt)
        (setq #en (ssname #xWt #i))
        ;図形データ取得
        (setq #eg (entget #en '("*")))
        (setq #subst (OmitAssocNo #eg '(-1 330 5)))
        (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
        ;図形コピー
        (entmake #subst)
        ;選択セットに追加
        (setq #entlast (GetLastEntity))
        (if (= 'ENAME (type #entlast))
          (ssadd #entlast #ss_n)
        )
        (setq #i (1+ #i))
      )
    )
  )
  ;図形回転
  (if (and (/= nil #ss_n) (/= 0 (sslength #ss_n)))
    (progn
      ; (command "_.ROTATE" #ss_n "" "0,0,0" (angtos &ang)) 2000/10/03 HT MOD
      (command "_.ROTATE" #ss_n "" "0,0,0" (angtos &ang (getvar "AUNITS") CG_OUTAUPREC))
      (if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo ".dwg"))
        (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "" "0,0,0" #ss_n "")
        (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "" "0,0,0" #ss_n "")
      )
    )
  )

  (princ)
) ; SCFMakeBlockPers


;<HOM>*************************************************************************
; <関数名>    : GetLastEntity
; <処理概要>  : AutoCad2000対応 "entlast"
; <戻り値>    : 図形名
; <作成>      : 99-08-11 吉野圭一
; <備考>      ;
;*************************************************************************>MOH<

(defun GetLastEntity (
  /
  #en #en2
  )
  (setq #en (entlast));最後の図形名取得
  (if (and (/= nil #en) (= 'ENAME (type #en)))
    (if (equal (cdr (assoc 0 (entget #en))) "INSERT")
      (setq #en2 #en)
      ;現在の図形(#en)を#en2に格納し、それ以降(entnext)の図形を#enに格納、のループ
      (while #en (setq #en (entnext (setq #en2 #en))))
    )
  )
  #en2
) ; GetLastEntity


;<HOM>*************************************************************************
; <関数名>    : SCFMakeBlockPlan
; <処理概要>  : 展開元図作成 平面図
; <戻り値>    : なし
; <作成>      : 1999-06-21
; <備考>      : なし
;*************************************************************************>MOH<

(defun SCFMakeBlockPlan (
  &sType      ; 図面タイプ
  &sNo        ; 領域番号
  &ssD        ; ダミー領域選択エンティティ
  &yashi      ; 矢視領域図形名
  &ang        ; 回転角度
  &sLayer     ; 平面図画層
  &sDlayer    ; 寸法線画層
  /
  #Zcode$ #noen$$$ #ss_n$ #ss_n #noen$$ #noen$ #danmen #sym #ModelFlg
  #ModelNo #syou #wd #en$ #ModelAngle #eg #subst #sym_n #ed$ #ang #en
  #xWt #i #entlast #ssP #ss_b #sZcode #ss #sBname
  #Cons8sLayer    ; 2000/06/22 HT ADD 速度改善用
  #8              ; 2000/06/22 HT ADD 速度改用
  #ss #yashi #xYashi #j #dY #EgY$ #cecolor  ; 2000/07/13 HT ADD 矢視記号追加
  #i
  )
  (if (= nil (tblsearch "APPID" "G_SKDM")) (regapp "G_SKDM"))
  (setq #Zcode$ (list CG_OUTSHOHINZU CG_OUTSEKOUZU))  ; 2000/09/25 HT

  ;図形名リスト取得（断面指示 シンボル図形名 正面フラグ 図形名リスト）…）
  (setq #noen$$$ (SKFGetCabiEntity &sType #Zcode$ &ssD &ang))

  ;平面図図形をコピーする
  (repeat (length #Zcode$)
    (setq #ss_n$ (cons (ssadd) #ss_n$))
  )
  ;シンボル図形とシンボルのグループの図形コピー
  (mapcar
   '(lambda ( #ss_n #noen$$ )
      (mapcar
       '(lambda ( #noen$ )
          ;シンボル図形名
          (setq #danmen   (nth 0 #noen$))  ;断面指示
          (setq #sym      (nth 1 #noen$))  ;シンボル図形名
          (setq #ModelFlg (nth 2 #noen$))  ;モデルフラグ
          (setq #ModelNo  (nth 3 #noen$))  ;モデル番号
          (setq #syou     (nth 4 #noen$))  ;正面フラグ（０：側面 １：正面）
          (setq #wd       (nth 5 #noen$))  ;正面方向フラグ（"W" "D"）
          (setq #en$      (nth 6 #noen$))  ;シンボルと同じグループの図形名リスト
          ;ダミー拡張データの格納角度
          (if (= "K" #ModelFlg)
            (setq #ModelAngle 0.0)
            (setq #ModelAngle (nth 2 (CfGetXData #sym "G_LSYM")))
          )

          (setq #eg  (entget #sym '("*")))
          (setq #Cons8sLayer (cons 8 &sLayer)) ; 2000/06/22 HT ADD 速度改善
          ;(setq #subst (subst (cons 8 &sLayer) (assoc 8 #eg) #eg)) ; 2000/06/22 HT 速度改善
          (setq #subst (subst #Cons8sLayer (assoc 8 #eg) #eg)) ; 2000/06/22 HT 速度改善
          (entmake #subst)
          ;コピー後図形名取得
          (setq #sym_n (entlast))
          ;拡張データの回転角度変換
          (setq #ed$ (CfGetXData #sym_n "G_LSYM"))
          (setq #ang (Angle0to360 (+ (nth 2 #ed$) &ang)))
          (setq #ed$ (append (list (car #ed$)(cadr #ed$) #ang) (cdr (cdr (cdr #ed$)))))
          (CfSetXData #sym_n "G_LSYM" #ed$)
          ;拡張データにダミー格納
          (CfSetXData #sym_n "G_SKDM" (list 1 #ModelFlg #ModelNo #syou #ModelAngle #wd))
          ;選択セットに格納
          (ssadd #sym_n #ss_n)
          (mapcar
           '(lambda ( #en )
              ;図形データ取得
              (setq #eg (entget #en '("*")))
              (setq #8 (assoc 8 #eg)) ; 2000/06/22 HT 速度改善
              (setq #pl$ (CfGetXData #en "G_PLIN"))
              (cond
                ((equal "DIMENSION" (cdr (assoc 0 #eg)))
                  ; (setq #subst (subst (cons 8 &sDlayer)  (assoc 8 #eg) #eg)) ; 2000/06/22 HT 速度改善
                  (setq #subst (subst (cons 8 &sDlayer) #8 #eg))               ; 2000/06/22 HT 速度改善
                )
                ((= 3 (car #pl$))
                  ; (setq #subst (subst (cons 8 "0_plin_1") (assoc 8 #eg) #eg)) ; 2000/06/22 HT 速度改善
                  (setq #subst (subst (cons 8 "0_plin_1") #8 #eg))              ; 2000/06/22 HT 速度改善
                )
                ((= 4 (car #pl$))
                  ; (setq #subst (subst (cons 8 "0_plin_2") (assoc 8 #eg) #eg)) ; 2000/06/22 HT 速度改善
                  (setq #subst (subst (cons 8 "0_plin_2") #8 #eg))              ; 2000/06/22 HT 速度改善
                )
                (T
                  ;2011/07/06 YM MOD-S 躯体非表示 ; 躯体は、"0_KUTAI"画層に置く (表示制御コマンド対応のため)
                  (cond
                    ((= CG_SKK_TWO_UPP (CFGetSymSKKCode #Sym 2))
                      (setq #subst (subst (cons 8 "0_WALL") #8 #eg))
                    )
                    ((= CG_SKK_TWO_KUT (CFGetSymSKKCode #Sym 2))
                      (setq #subst (subst (cons 8 "0_KUTAI") #8 #eg))
                    )
                    (T
                      (setq #subst (subst (cons 8 &sLayer ) #8 #eg))
                    )
                  );_if

;;;                  ; 2000/06/20 ウオールキャビネットは、"0_WALL"画層に置く (表示制御コマンド対応のため)
;;;                  (if (= CG_SKK_TWO_UPP (CFGetSymSKKCode #Sym 2))
;;;                    (progn
;;;                     ; (setq #subst (subst (cons 8 "0_WALL") (assoc 8 #eg) #eg)) ; 2000/06/22 HT 速度改善
;;;                     (setq #subst (subst (cons 8 "0_WALL") #8 #eg))              ; 2000/06/22 HT 速度改善
;;;                    )
;;;                    (progn
;;;                     ; (setq #subst (subst (cons 8 &sLayer ) (assoc 8 #eg) #eg)) ; 2000/06/22 HT 速度改善
;;;                     (setq #subst (subst (cons 8 &sLayer ) #8 #eg))              ; 2000/06/22 HT 速度改善
;;;                    )
;;;                  );_if
                  ;2011/07/06 YM MOD-E 躯体非表示 ; 躯体は、"0_KUTAI"画層に置く (表示制御コマンド対応のため)

                )
              )
              ;図形コピー
              ;修正  00/04/12  START -----------
              (if (/= "POLYLINE" (cdr (assoc 0 #subst)))
                (progn
                  (entmake #subst)
                )
                (progn
                  (entmake #subst)
                  (while (/= "SEQEND" (cdr (assoc 0 (entget (setq #en (entnext #en))))))
                    (setq #eg (entget #en '("*")))
                    (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                    ;(setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst)) ; 2000/06/22 HT 速度改善
                    (setq #subst (subst #Cons8sLayer (assoc 8 #subst) #subst))      ; 2000/06/22 HT 速度改善
                    (entmake #subst)
                  )
                  (setq #eg (entget #en '("*")))
                  (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                  ; (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))  ; 2000/06/22 HT 速度改善
                  (setq #subst (subst #Cons8sLayer (assoc 8 #subst) #subst))        ; 2000/06/22 HT 速度改善
                  (entmake #subst)
                )
              )
              ;修正  00/04/12  END  -----------
              ;選択セットに追加
              (ssadd (entlast) #ss_n)
            )
            #en$
          )
        )
        #noen$$
      )
    )
    #ss_n$ #noen$$$
  )

  ;Z_00図形取得
  (setq #xWt (GetWtAndFilr &yashi "P"))
  (if (/= nil #xWt)
    (progn
      (mapcar
       '(lambda ( #ss_n )
          (setq #i 0)
          (repeat (sslength #xWt)
            (setq #en (ssname #xWt #i))
            (setq #eg (entget #en '("*")))
            (if (equal "DIMENSION" (cdr (assoc 0 #eg)))
              (setq #subst (subst (cons 8 &sDlayer) (assoc 8 #eg) #eg))
              (setq #subst (subst (cons 8  &sLayer) (assoc 8 #eg) #eg))
            )
            (entmake (cdr #subst))
            (setq #entlast (entlast))
            (ssadd #entlast #ss_n)
            (setq #i (1+ #i))
          )
        )
        #ss_n$
      )
    )
  )


  ;ダミー点図形取得
  (setq #ssP (ssget "X" (list (cons 0 "POINT")(list -3 (list "G_SKDM")))))
  (if (/= nil #ssP)
    (progn
      (setq #i 0)
      (repeat (sslength #ssP)
        (setq #en (ssname #ssP #i))
        (if (= "W" (nth 1 (CfGetXData #en "G_SKDM")))
          (progn
            (mapcar
             '(lambda ( #ss_n )
                (entmake (cdr (entget #en '("*"))))
                (ssadd (entlast) #ss_n)
              )
              #ss_n$
            )
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
  (setq #ss_b (ssadd))
  (mapcar
   '(lambda ( #sZcode #ss )
      (if (and (/= nil #ss) (/= 0 (sslength #ss)))
        (progn
          ; 平面図に矢視記号を作成する
          (KCFSetYashiInPlane #ss)
          ;ﾌﾞﾛｯｸ化
          (setq #sBname (strcat &sType #sZcode))
          ; (command "_.ROTATE" #ss "" "0,0,0" (angtos &ang)) 2000/10/03 HT MOD
          (command "_.ROTATE" #ss "" "0,0,0" (angtos &ang (getvar "AUNITS") CG_OUTAUPREC))
          (command "_block" #sBname "0,0,0" #ss "")
          (command "_insert" #sBname "0,0,0" 1 1 "0")
          (ssadd (entlast) #ss_b)
        )
      )
    )
    #Zcode$ #ss_n$
  )

  (if (and (/= nil #ss_b) (/= 0 (sslength #ss_b)))
    (if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo))
      (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "Y" "" "0,0,0" #ss_b "")
      (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "" "0,0,0" #ss_b "")
    )
  )

  (princ)
) ; SCFMakeBlockPlan


;<HOM>*************************************************************************
; <関数名>    : KCFSetYashiInPlane
; <処理概要>  : 平面図に矢視を設定する
; <戻り値>    : なし
; <作成>      : 2000/10/16 TH
; <備考>      : なし
;*************************************************************************>MOH<
(defun KCFSetYashiInPlane (
  &sS       ; 平面図図形選択セット
  /
  #xSs      ; 矢視図形選択セット
  #dY       ; 矢視基点
  #xYashi   ; 矢視図形（分解）選択セット
  #EgY$     ; 矢視図形（分解）
  #i #j     ; 操作変数
  #cecolor  ; 現在色
  )

  (setq #xSs (ssget "X" '((-3 ("RECT")))))
  (if (and #xSs (/= 0 (sslength #xSs)))
    (progn
    (setq #i 0)
    (repeat (sslength #xSs)
      (setq #dY (cdr (assoc 10 (entget (ssname #xSs #i)))))
      (entmake (cdr (entget (ssname #xSs #i) '("*"))))
      ; 文字回転 HT 2000/11/14 START
      (command "._EXPLODE" (entlast))
      (setq #xYashi (ssget "P"))
      (if #xYashi
        (progn
        (setq #j 0)
        (repeat (sslength #xYashi)
          (if (= (cdr (assoc 0 (setq #EgY$ (entget (ssname #xYashi #j))))) "TEXT")
            (progn
              (entmod (subst (cons 50 (- &ang)) (assoc 50 #EgY$) #EgY$))
            )
          )
          (setq #j (1+ #j))
        )
        (setq #cecolor (getvar "CECOLOR"))    ; 現在色
        (setvar "CECOLOR" "50")  ; 展開図
        ;再ブロック化
        (SKUblock #dY #xYashi)
        (setvar "CECOLOR" #cecolor)
        ; 文字回転 HT 2000/11/14 END
        )
      )
      (ssadd (entlast) &sS)
      (setq #i (1+ #i))
    )
    )
  )
)

;<HOM>*************************************************************************
; <関数名>    : SCFMakeBlockExpand
; <処理概要>  : 展開元図作成 展開図
; <戻り値>    : なし
; <作成>      : 1999-06-21
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCFMakeBlockExpand (
  &sType      ; 図面ﾀｲﾌﾟ
  &sNo        ; 領域番号
  &xSp        ; ダミー領域選択エンティティ
  &yashi      ; 矢視領域図形名
  &ang        ; 回転角度
  &sLayer     ; 平面図画層
  &sDlayer    ; 寸法線画層
  &sDy        ; 実際の矢視記号
  &zmove      ; Z方向移動量
  &ssdoor     ; 扉面選択エンティティ
  /
  #Kind #Zcode$ #ss_n$ #ss_d$ #noen$$$ #kind #addang #iI #ss_n #ss_d
  #noen$$ #noen$ #danmen #sym #ModelFlg #ModelNo #syou #wd #en$ #ModelAngle
  #ssup #eg #10 #subst #sym_n #ed$ #ang #en #entlast #xWt #i #ssP #ss_b
  #sZcode #ss #sBname
  #Cons8sLayer    ; 2000/06/22 HT ADD 速度改善用
  #8              ; 2000/06/22 HT ADD 速度改善用
  #dat$           ; 2000/06/22 HT ADD (シンボル図形名 (扉図形リスト) P面属性1)
  #Dooren$        ; 2000/06/22 HT ADD (扉図形リスト)
  #j              ; 2000/06/22 HT ADD (扉図形リスト) のカウンタ
  #iVP            ; 2000/06/22 HT ADD 視点種類(intで表現) 3 4 5 6
  #doorlst        ; 2000/06/22 HT ADD 速度改善用
  #elm #loop #SSdoorMOVE ; 01/03/15 YM 扉のみZ移動
  #ftpType                 ; フラットプランタイプ "SF":セミフラット "FF":フルフラット
  )
  ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  ; 04/05/17 SK ADD-S 対面プラン対応
  (setq #ftpType (SCFIsTaimenFlatPlan))
  ; 04/05/17 SK ADD-E 対面プラン対応
  ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

   ; 2000/06/22 HT DEL 速度改善
   ;(if (= nil &ssdoor)
   ; (setq &ssdoor (ssadd))
   ;)
  ;---初期設定---
  (if (= nil (tblsearch "APPID" "G_SKDM")) (regapp "G_SKDM"))
  (setq #Kind &sDy)
  (setq #Zcode$ (list CG_OUTSHOHINZU CG_OUTSEKOUZU)) ; 2000/09/25 HT

  (repeat (length #Zcode$)
    (setq #ss_n$ (cons (ssadd) #ss_n$))
    (setq #ss_d$ (cons (ssadd) #ss_d$))
  )
  ;@@@(princ "\nSKFGetCabiEntity: START")
  ;図形名リスト取得（（断面指示 シンボル図形名 正面フラグ 図形名リスト）…）
  (setq #noen$$$ (SKFGetCabiEntity #Kind #Zcode$ &xSp &ang))

  ;@@@(princ "\nSKFGetCabiEntity: END")
  (if (not (apply 'or #noen$$$))
    (progn
      (princ "\n")
      (princ #Kind)
      (princ " 矢視内に図形が存在しない...スキップ")
    )
    (progn

      ; 2D扉で取得したデータを使う
      (setq #doorlst CG_DOORLST) ; 2000/06/22 HT ADD 速度改善

      ;--------------
      ;矢視方向毎に足しこむ回転角度を設定
      ; 実際の矢視 DefaultのA方向=3
      ;            DefaultのB方向=4
      ;            DefaultのC方向=5
      ;            DefaultのD方向=6
      ; E F 矢視の場合は B と同様に扱う
      (cond
        ((= "A" #kind)
          (setq #addang (* PI 0.0))
          (cond
            ((equal &ang 0 0.1)       (setq #iVP 3)) ; OK!
            ((equal &ang 1.571 0.1)   (setq #iVP 4)) ;2001/03/15 MOD KS 01/03/17 YM MOD
            ((equal &ang 3.14159 0.1) (setq #iVP 5)) ;2001/03/15 MOD KS 01/03/17 YM MOD
            ((equal &ang 4.71239 0.1) (setq #iVP 6)) ;2001/03/15 MOD KS 01/03/17 YM MOD
          )
        )
        ; 01/05/25 TM MOD 矢視F 追加
        ((or (= "B" #kind) (= "E" #kind) (= "F" #kind))
          (setq #addang (* PI 0.5))
          (cond
            ((equal &ang 0 0.1)       (setq #iVP 4)) ; OK!
            ((equal &ang 1.571 0.1)   (setq #iVP 5)) ;2001/03/15 MOD KS 01/03/17 YM MOD
            ((equal &ang 3.14159 0.1) (setq #iVP 6))
            ((equal &ang 4.71239 0.1) (setq #iVP 3)) ;2001/03/15 MOD KS 01/03/17 YM MOD
          )
        )
        ((= "C" #kind)
          (setq #addang (* PI 1.0))
          (cond
            ((equal &ang 0 0.1)       (setq #iVP 5)) ; OK!
            ((equal &ang 1.571 0.1)   (setq #iVP 6)) ;2001/03/15 MOD KS 01/03/17 YM MOD
            ((equal &ang 3.14159 0.1) (setq #iVP 3))
            ((equal &ang 4.71239 0.1) (setq #iVP 4)) ;2001/03/15 MOD KS 01/03/17 YM MOD
          )
        )
        ((= "D" #kind)
          (setq #addang (* PI 1.5))
          (cond
            ((equal &ang 0 0.1)       (setq #iVP 6)) ; OK!
            ((equal &ang 1.571 0.1)   (setq #iVP 3)) ;2001/03/15 MOD KS 01/03/17 YM MOD
            ((equal &ang 3.14159 0.1) (setq #iVP 4))
            ((equal &ang 4.71239 0.1) (setq #iVP 5)) ;2001/03/15 MOD KS 01/03/17 YM MOD
          )
        )
      )
      (setq #iI 0)
      (mapcar
       '(lambda ( #ss_n #ss_d #noen$$ )
          (mapcar
            '(lambda ( #noen$ )
              (setq #danmen   (nth 0 #noen$))  ;断面指示
              (setq #sym      (nth 1 #noen$))  ;シンボル図形名
              (setq #ModelFlg (nth 2 #noen$))  ;モデルフラグ
              (setq #ModelNo  (nth 3 #noen$))  ;モデル番号
              (setq #syou     (nth 4 #noen$))  ;正面フラグ（０：側面 １：正面）
              (setq #wd       (nth 5 #noen$))  ;正面方向フラグ（"W" "D"）
              (setq #en$      (nth 6 #noen$))  ;シンボルと同じグループの図形名リスト
              ;ダミー拡張データの格納角度
              (if (= "K" #ModelFlg)
                (setq #ModelAngle 0.0)                                 ; キッチン
                (setq #ModelAngle (nth 2 (CfGetXData #sym "G_LSYM")))  ; ダイニング
              )
              ;断面指定選択セット
              (setq #ssup (ssadd))
              ;シンボル図形位置
              (setq #eg (entget #sym '("*")))
              (setq #10 (cdr (assoc 10 #eg)))
              (setq #Cons8sLayer (cons 8 &sLayer)) ; 2000/06/22 HT 速度改善
              ;画層変換
              ;(setq #subst (subst (cons 8 &sLayer) (assoc 8 #eg) #eg))

              ;2011/07/06 YM MOD 躯体かどうかで画層区別
              (if (= CG_SKK_TWO_KUT (CFGetSymSKKCode #sym 2))
                (setq #subst (subst (cons 8 "0_KUTAI") (assoc 8 #eg) #eg))
                ;else 従来通り
                (setq #subst (subst #Cons8sLayer       (assoc 8 #eg) #eg))
              );_if


              ;シンボル図形コピー
              (entmake #subst)
              ;コピー後図形名取得
              (setq #sym_n (entlast))

              ;拡張データの回転角度変換
              (setq #ed$ (CfGetXData #sym_n "G_LSYM"))
              (setq #ang (Angle0to360 (+ (nth 2 #ed$) &ang #addang)))
              (setq #ed$ (append (list (car #ed$)(cadr #ed$) #ang) (cdr (cdr (cdr #ed$)))))
              (CfSetXData #sym_n "G_LSYM" #ed$)

              ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
              ; 04/05/17 SK MOD-S 対面プラン対応
              ;拡張データにダミー格納
              (cond
                ; 対面プランでなく、正面フラグに背面値(-1)が入っている場合
                ; 正面値(1) に設定する
                ((and (= #ftpType nil) (= #syou -1))
                  (CfSetXData #sym_n "G_SKDM" (list 1 #ModelFlg #ModelNo 1 #ModelAngle #wd))
                )
                ; それ以外はそのまま正面フラグを設定
                (T
                  (CfSetXData #sym_n "G_SKDM" (list 1 #ModelFlg #ModelNo #syou #ModelAngle #wd))
                )
              )
              ; 04/05/17 SK MOD-E 対面プラン対応
              ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
              ;選択セットに格納
              (ssadd #sym_n #ss_n)
              (mapcar
               '(lambda ( #en )

                  ;図形データ取得
                  (setq #eg (entget #en '("*")))
                  (setq #8 (assoc 8 #eg))
                  ;画層変換
                  (setq #pl$ (CfGetXData #en "G_PLIN"))
                  (cond
                    ; 寸法？
                    ((equal "DIMENSION" (cdr (assoc 0 #eg)))
                      (setq #subst (subst (cons 8 &sDlayer) #8 #eg))
                    )
                    ; 番号3？
                    ((= 3 (car #pl$))
                      (setq #subst (subst (cons 8 "0_plin_1") #8 #eg))
                    )
                    ; 番号4？
                    ((= 4 (car #pl$))
                      (setq #subst (subst (cons 8 "0_plin_2") #8 #eg))
                    )
                    (T

                      ;2011/07/06 YM MOD-S 躯体かどうかで画層区別
                      (if (= CG_SKK_TWO_KUT (CFGetSymSKKCode #sym_n 2))
                        (setq #subst (subst (cons 8 "0_KUTAI") #8 #eg))
                        ;else 従来通り
                        (setq #subst (subst (cons 8 &sLayer ) #8 #eg))
                      );_if

;;;                     (setq #subst (subst (cons 8 &sLayer ) #8 #eg))
                      ;2011/07/06 YM MOD-E 躯体かどうかで画層区別

                    )
                  )
                  ; 図形コピー
                  (if (/= "POLYLINE" (cdr (assoc 0 #subst)))
                    (progn
                      (entmake #subst)
                    )
                    (progn
                      (entmake #subst)
                      (while (/= "SEQEND" (cdr (assoc 0 (entget (setq #en (entnext #en))))))
                        (setq #eg (entget #en '("*")))
                        (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                        (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
                        (entmake #subst)
                      )
                      (setq #eg (entget #en '("*")))
                      (setq #subst (OmitAssocNo #eg '(-1 330 5 102)))
                      (setq #subst (subst (cons 8 &sLayer) (assoc 8 #subst) #subst))
                      (entmake #subst)
                    )
                  )
                  ; コピーした図形
                  (setq #entlast (entlast))

                  (setq #eg (entget #entlast '("*")))
                  ; ブロックを構成する図形の画層を全て更新する
                  (if (equal "INSERT" (cdr (assoc 0 #eg)))
                    (setq #entlast (SKFReBlock #entlast))
                  )
                  ;施工胴縁寸法に正面フラグを追加
                  (setq #ed$ (CfGetXData #en "G_PTEN"))
                  (if (and (/= nil #ed$)(= 8 (nth 0 #ed$)))
                    (CfSetXData #en "G_PTEN" (list 8 #syou 0))
                  )
                  ;選択セットに追加
                  (ssadd #entlast #ss_n)
                  ;断面指定され、側面の図形をダミーの選択セットに追加
                  (if (and (= 1 #danmen) (= 0 #syou))
                    (ssadd #entlast #ss_d)
                  )
                )
                #en$
              )

              ; 2000/06/22 扉面図形のシンボル図形名と一致していたら0_door画層に
              ;  扉面図形をコピーし、選択セットに追加する
              ;  CG_DOORLST = ((シンボル図形名 (扉図形リスト) P面属性1)
              ;                (シンボル図形名 (扉図形リスト) P面属性1)・・・)
              (while (setq #dat$ (assoc #sym #doorlst))
                (setq #j 0)
                ; シンボル図形名は複数あるので、一度選択されると無効0にする
                (setq #doorlst (subst (list 0 (list 0) 0) #dat$ #doorlst))
                ; 扉図形すべてコピーする
                (repeat (length (setq #Dooren$ (cadr #dat$)))
                  ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                  ; 04/05/17 SK MOD-S 対面プラン対応
                  ; 背面キャビも扉を貼り付ける
                  ;(if (or (= 1 #syou) (= -1 #syou))
                  (if (or (= 1 #syou) (= -1 #syou))
                  ; 04/05/17 SK MOD-E 対面プラン対応
                  ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    (progn
                    (if (or (= 0 (caddr #dat$)) (= #iVP (caddr #dat$)))
                      (progn
                      ; 扉図形リストのうち、正面フラグONで、正面を向いた扉のみコピーする
                      ; コーナーに、正面向きの扉と側面向きの扉があるめ
                        (foreach #n #ss_n$
                          ; 商品図用と施工図用 両方作成
                          (entmake (cdr (entget (nth #j #Dooren$) '("*"))))
                          ; 選択セットに追加する
                          (ssadd (entlast) #n)
                        )
                      )
                    );_if
                    )
                  )
                  (setq #j (1+ #j))
                );repeat
              )
            )
            #noen$$
          )
          (setq #iI (1+ #iI))
        )
        #ss_n$ #ss_d$ #noen$$$
      )

      ;Z_00図形(ワークトップ／フィラー)取得

      (setq #xWt (GetWtAndFilr &yashi #kind))

      (if (/= nil #xWt)
        (progn
          (foreach #ss_n #ss_n$
            (setq #i 0)
            (repeat (sslength #xWt)
              (setq #en (ssname #xWt #i))
              (setq #eg (entget #en '("*")))
              (if (equal "DIMENSION" (cdr (assoc 8 #eg)))
                (setq #subst (subst (cons 8 &sDlayer) (assoc 8 #eg) #eg))
                (setq #subst (subst (cons 8 &sLayer ) (assoc 8 #eg) #eg))
              )

              (entmake (cdr #subst))
              (ssadd (entlast) #ss_n)
              (setq #i (1+ #i))
            );_repeat
          );_foreach
        )
      );_if (/= nil #xWt)

      ;ダミー点図形取得
      (setq #ssP (ssget "X" (list (cons 0 "POINT")(list -3 (list "G_SKDM")))))
      (if (/= nil #ssP)
        (progn
          (setq #i 0)
          (repeat (sslength #ssP)
            (setq #en (ssname #ssP #i))
            (if (= "W" (nth 1 (CfGetXData #en "G_SKDM")))
              (progn
                (mapcar
                 '(lambda ( #ss_n )
                    (entmake (cdr (entget #en '("*"))))
                    (ssadd (entlast) #ss_n)
                  )
                  #ss_n$
                )
              )
            )
            (setq #i (1+ #i))
          )
        )
      )
      (setq #ss_b (ssadd))

      ;ﾌﾞﾛｯｸ化
      (mapcar
       '(lambda ( #sZcode #ss #ss_d )
          ;図形回転
          ; (command "_.ROTATE" #ss "" "0,0,0" (angtos &ang)) 2000/10/03 HT MOD
          (command "_.ROTATE" #ss "" "0,0,0" (angtos &ang (getvar "AUNITS") CG_OUTAUPREC))
          ;図形の3D回転
          (cond
            ((= "A" #kind)
              (rotate3d #ss "X" "" -90)
            )
            ; 01/05/25 TM ADD 矢視F 追加
            ; ((or (= "B" #kind) (= "E" #kind)) ; 2000/10/06 HT E方向矢視
            ((or (= "B" #kind) (= "E" #kind) (= "F" #kind))
              (rotate3d #ss "Y" ""  90)
              (rotate3d #ss "Z" ""  90)
            )
            ((= "C" #kind)
              (rotate3d #ss "X" ""  90)
              (rotate3d #ss "Z" "" 180)
            )
            ((= "D" #kind)
              (rotate3d #ss "Y" "" -90)
              (rotate3d #ss "Z" "" -90)
            )
          )
          ;断面指定の図形に高さを与える
          (if (and (/= nil #ss_d) (/= 0 (sslength #ss_d)))
            (progn
              (command "_move" #ss_d "" "0,0,0" (list 0.0 0.0 &zmove))
            )
          )

; "0_door" だけZ移動 01/03/15 YM ADD START /////////////////////////////////////////////////
          (setq #loop 0 #SSdoorMOVE (ssadd))
          (repeat (sslength #ss)
            (setq #elm (ssname #ss #loop))
            (if (= (cdr (assoc 8 (entget #elm))) "0_door")  ; 画層
              (ssadd #elm #SSdoorMOVE)
            );_if
            (setq #loop (1+ #loop))
          )
          (if (and #SSdoorMOVE (< 0 (sslength #SSdoorMOVE)))
            (progn
              ; CG_DoorZMove ; 扉図形をZ方向(図面をXY平面として)に押し出す量
              (command "_move" #SSdoorMOVE "" "0,0,0" (list 0.0 0.0 CG_DoorZMove))
            )
          );_if
; "0_door" だけ移動 01/03/15 YM ADD END /////////////////////////////////////////////////

          (setq #sBname (strcat #Kind #sZcode))
          (command "_block" #sBname "0,0,0" #ss "")
          (command "_insert" #sBname "0,0,0" 1 1 "0")
          (ssadd (entlast) #ss_b)
        )
        #Zcode$ #ss_n$ #ss_d$
      )

      (if (findfile (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo))
        (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "Y" "" "0,0,0" #ss_b "")
        (command "_wblock" (strcat CG_KENMEI_PATH "BLOCK\\" &sType "_" &sNo) "" "0,0,0" #ss_b "")
      )
    )
  );_if (not (apply 'or #noen$$$))

  (princ)
) ; SCFMakeBlockExpand

;<HOM>*************************************************************************
; <関数名>    : SCFMakeBlockTable
; <処理概要>  : 展開元図作成 仕様表
; <戻り値>    : なし
; <作成>      : 1999-06-23
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCFMakeBlockTable (
  /
  #sFname #CG_SpecList$$ #fp #Lst$ #sTr #s
  #sFnameExt #fpExt #ssExt #iExt     ;00/08/03 SN ADD
  #symExt #xdExt$ #wlineExt #specExt$;00/08/03 SN ADD
  #noExt #nameExt                    ;00/08/03 SN ADD
  #Spec$ #newSpecList$$ #iSpec       ;00/08/03 SN ADD
#DUM$$ #HIN #HIN_OLD #I #KKK #LR #LR_OLD #NUM #NUM_CHANGE #NUM_CHANGE$ #DUM1$ #DUM2$ #k
  )
  ;仕様表ﾌｧｲﾙ名
  (setq #sFname (strcat CG_KENMEI_PATH "Table.cfg"))
  ;仕様表作成
  (setq #CG_SpecList$$ (Skb_SetSpecList))

  ;2009/12/08 YM ADD 品番が同じならL,Rの順番にする
  (setq #hin_old nil)
  (setq #LR_old  nil)
  (setq #num_CHANGE$ nil)
  ;入れ替え有無判定 同じ品番が連続し、R,Lの順番であればL,Rの順番にする
  (foreach #CG_SpecList$ #CG_SpecList$$
    (setq #num (nth  0 #CG_SpecList$));番号
;-- 2011/12/12 A.Satoh Mod - S
;;;;;    (setq #hin (nth  9 #CG_SpecList$))
;;;;;    (setq #LR  (nth 10 #CG_SpecList$))
    (setq #hin (nth 11 #CG_SpecList$))
    (setq #LR  (nth 12 #CG_SpecList$))
;-- 2011/12/12 A.Satoh Mod - E
    (if (and (= #hin #hin_old)
             (= "R" #LR_old)
             (= "L" #LR))
      (progn ;順番の入れ替えが必要
        (setq #num_CHANGE$ (append #num_CHANGE$ (list (atoi #num))));1つ手前と入れ替えが必要(整数)
      )
    );_if
    (setq #hin_old #hin)
    (setq #LR_old   #LR)
  );foreach

  ;入れ替え処理
  (if #num_CHANGE$
    (progn

;;;     (setq #dum$$ nil)
;;;     (foreach #CG_SpecList$ #CG_SpecList$$
;;;       (setq #num (atoi (nth  0 #CG_SpecList$)));番号(整数)
;;;       (setq #kkk #num)
;;;       (if (= #num (1- #num_CHANGE))
;;;         (progn ;番号をﾌﾟﾗｽ
;;;           (setq #CG_SpecList$
;;;              (CFModList #CG_SpecList$
;;;                (list (list 0 (itoa (1+ #num))))
;;;              )
;;;           )
;;;           (setq #kkk (1+ #num))
;;;         )
;;;       );_if
;;;       (if (= #num  #num_CHANGE)
;;;         (progn ;番号をﾏｲﾅｽ
;;;           (setq #CG_SpecList$
;;;              (CFModList #CG_SpecList$
;;;                (list (list 0 (itoa (1- #num))))
;;;              )
;;;           )
;;;           (setq #kkk (1- #num))
;;;         )
;;;       );_if
;;;
;;;       (setq #dum$$ (append #dum$$ (list (append #CG_SpecList$ (list #kkk)))))
;;;     );foreach

      ;2011/06/03 YM MOD-S
      (foreach #num_CHANGE #num_CHANGE$ ;#num_CHANGEの1つ前と入れ替える
        ;1つ前
        (setq #dum1$ (assoc (itoa (1- #num_CHANGE)) #CG_SpecList$$))
        ;番号をﾌﾟﾗｽ
        (setq #dum1$
          (CFModList #dum1$
            (list (list 0 (itoa #num_CHANGE)))
          )
        )

        ;その次
        (setq #dum2$ (assoc (itoa #num_CHANGE) #CG_SpecList$$))
        ;番号をﾏｲﾅｽ
        (setq #dum2$
          (CFModList #dum2$
            (list (list 0 (itoa (1- #num_CHANGE))))
          )
        )

        ;1つ前を#dum1$に入れ替える
        (setq #CG_SpecList$$
          (CFModList #CG_SpecList$$
            (list (list (- #num_CHANGE 2) #dum1$))
          )
        )
        ;その次を#dum2$に入れ替える
        (setq #CG_SpecList$$
          (CFModList #CG_SpecList$$
            (list (list (- #num_CHANGE 1) #dum2$))
          )
        )

      );(foreach

      ;2011/06/11 YM ADD 番号でｿｰﾄ 文字でｿｰﾄすると"1","10","11","2"となってしまうから数字でｿｰﾄしないとﾀﾞﾒ
      (setq #dum$$ nil)
      (foreach #CG_SpecList$ #CG_SpecList$$
        (setq #k (atoi (nth 0 #CG_SpecList$)))
        (setq #dum$$ (append #dum$$ (list (cons #k #CG_SpecList$ ))));番号を先頭に追加
      )

      ;数字の番号でｿｰﾄ
      (setq #dum$$ (CFListSort #dum$$ 0))

      (setq #CG_SpecList$$ nil);ｸﾘｱ
      (foreach #dum$ #dum$$
        (setq #CG_SpecList$ (cdr #dum$))
        (setq #CG_SpecList$$ (append #CG_SpecList$$ (list #CG_SpecList$)))
      )

    )
  );_if


  ;Table.cfg書き出し
  (setq #fp  (open #sFname "w"))
  (if (/= nil #fp)
    (progn
      (setq #i 0)
      (foreach #CG_SpecList$ #CG_SpecList$$
        (foreach #CG_SpecList #CG_SpecList$
          (princ #CG_SpecList #fp)(princ "," #fp)
        )
        (princ "\n" #fp)
        (setq #i (1+ #i))
      )
    )
  );_if
  (close #fp)
  (princ)
); SCFMakeBlockTable

;;;<HOM>*************************************************************************
;;; <関数名>  : CFDispStar
;;; <処理概要>: コマンドラインに"計算中"を表示する
;;; <戻り値>  : なし
;;; <作成>    : 01/07/19 HN
;;; <備考>    : グローバル CG_CntStar : 表示した個数
;;;             暫定的に本ファイルに置いています
;;;*************************************************************************>MOH<
(defun CFDispStar
  (
  /
  #iNum    ; コマンドライン表示桁数
  #sDisp   ; 表示文字列
  )
  (setq #iNum  50)
  (setq #sDisp "")
  (cond
    ((= nil CG_CntStar)
      (princ "\r")
      (princ "->")
      (setq CG_CntStar 0)
    )
    ((< 50 CG_CntStar)
      (princ "\r")                      ; 頭に復帰
      (repeat (+ 20 #iNum) (princ " ")) ; クリア
      (princ "\r")                      ; 頭に復帰
      (setq CG_CntStar 0)
    )
    (T
      (repeat CG_CntStar (setq #sDisp (strcat #sDisp ".")))
      (princ "\r")  ; 頭に復帰
      (princ (strcat #sDisp "φ(._.)計算中"))
      (setq CG_CntStar (1+ CG_CntStar))
    )
  )
  (princ)
) ;_CFDispStar

;<HOM>*************************************************************************
; <関数名>    : KCFIsAreaMatchYashi
; <処理概要>  : 指定した矢視に点列が含まれているか？
; <戻り値>    : T=含まれている nil=含まれていない
; <作成>      : 01/04/24 TM ADD
; <改訂>      : 01/07/19 HN 矢視領域内の図形取得前にZOOMを挿入
; <備考>      : グローバル
;               CG_sYKind       : 前回判定した矢視種類
;               CG_dArea$       : 矢視領域の座標リスト
;               CG_dAreaMinMax$ : 矢視領域の最小最大座標
;               CG_eSymArea$    : 3DSOLIDの図形名リスト
;               CG_eSym$Area$   : グループ内の全図形を含む図形名リスト
;*************************************************************************>MOH<
(defun KCFIsAreaMatchYashi (
  &sYKind   ; 矢視 ("A" "B" "C" "D" "E" "F")
  &eYashi   ; 矢視図形
  &dSym$    ; 指定領域座標
  &eSym     ; 判定アイテムの基準図形 01/06/11 HN ADD
  /
  #sXd$     ; 矢視の拡張データ
  #xBas     ; 矢視の基点
  #xBD      ; 矢視の基点からC矢視方向の点
  #xAC      ; 矢視の基点からD矢視方向の点
  #xPt      ; 操作変数
  #Ret      ; 操作変数
  #nPos     ; 拡張データの指定矢視の位置
  #hReg     ; 矢視領域図形ハンドル
  #ssSym    ; シンボル図形の選択セット
  #xYas$    ; 矢視領域殿座標     01/06/11 HN ADD
  #eSym     ; 3DSOLID の図形名
  #eSym$    ; グループ内の図形名リスト
  #iCnt     ; カウンタ
  )
  (CFDispStar) ; "計算中"表示

  ; 01/07/19 HN S-MOD 矢視が前回と違う場合は、矢視領域情報を取得
  ; 01/06/11 HN S-ADD
  ; 既に参照した図形と矢視領域情報を毎回取得すると処理時間に影響するので
  ; グローバル変数にて保持するようにした
  (if (/= &sYKind CG_sYKind)
    (progn
      (setq CG_sYKind &sYKind)  ; 矢視種類
      (setq CG_eSymArea$  nil)  ; 矢視領域内の3DSOLID図形名リスト
      (setq CG_eSym$Area$ nil)  ; 矢視領域内のグループ図形を含む全図形リスト

      (setq CG_dArea$ (KCFGetDaByYasReg &eYashi &sYKind)) ; 矢視領域座標を取得
      (setq CG_dAreaMinMax$ (GetPtMinMax CG_dArea$))      ; 矢視領域の最小最大座標
    )
  )
  ; 01/06/11 HN E-ADD
  ; 01/07/19 HN E-MOD 矢視が前回と違う場合は、矢視領域情報を取得

  ; 矢視の基点
  (setq #xBas (cdr (assoc 10 (entget &eYashi))))

  ; 矢視の拡張データを取得
  (setq #sXd$ (CFGetXData &eYashi "RECT"))

; 01/07/17 TM DEL
; ; 基点からC 矢視方向に向いた座標。100 に距離としての意味はない
; (setq #xC (polar #xBas (- (dtr (atoi (nth 1 #sXd$))) (dtr 180)) 100))
; ; 基点からD 矢視方向に向いた座標
; (setq #xD (polar #xBas (- (dtr (atoi (nth 1 #sXd$))) (dtr 90)) 100))
; 01/07/17 TM DEL

  ; 01/07/11 TM DEL 現在は全ての矢視で領域図形を取得できるため、判定は不要
  ;DEL ; 矢視領域図形取得
  ;DEL (setq #nPos (vl-string-search &sYKind (nth 2 #sXd$)))
  ;DEL (if #nPos
  ;DEL   (setq #hReg (nth (+ 3 #nPos) #sXd$))
  ;DEL )

; 01/07/11 TM DEL 現在は判定不要
; (if (and #hReg (/= "" #hReg))
;   ; 矢視領域図形がある場合
;   (progn
; 01/07/11 TM DEL 現在は判定不要

      ; 01/07/19 HN S-DEL 上に移動
      ;@DEL@; 矢視領域取得
      ;@DEL@(setq #xYas$ (KCFGetDaByYasReg &eYashi &sYKind))
      ;@DEL@; DEBUG(princ "\n#xYas$: ")(princ #xYas$)
      ; 01/07/19 HN E-DEL 上に移動

      ; 01/06/11 HN S-MOD
      ; 基準図形が参照済みであれば、含まれている
      (if (member &eSym CG_eSym$Area$)
        (progn
          (setq #Ret T)
        )
        (progn
          (setq #iCnt 0)
          ; 01/07/19 HN DEL ズーム処理を移動
          ;@DEL@; 01/07/19 HN ADD ズーム処理を追加
          ;@DEL@;@MOD@(command "_.ZOOM" (car CG_dAreaMinMax$) (cadr CG_dAreaMinMax$))
          ;@DEL@(command "_.ZOOM" (getvar "LIMMIN") (getvar "LIMMAX"))

          ; 矢視領域内の 3DSOLID を取得

          ;"3DSOLID"だけでなく"BODY"も含める 03/07/24 YM MOD-S
;;;          (setq #ssSym (ssget "CP" CG_dArea$ '((0 . "3DSOLID")))) ; 01/07/19 HN MOD #xYas$ → CG_dArea$

          (setq #ssSym (ssget "CP" CG_dArea$ '(
                                                (-4 . "<OR")
                                                  (0 . "3DSOLID")
                                                  (0 . "BODY")
                                                (-4 . "OR>")
                                              )
          )) ; 01/07/19 HN MOD #xYas$ → CG_dArea$

          ;"BODY"も含める 03/07/24 YM MOD-E

          (if #ssSym
            ; 3DSOLID が参照済みかどうか
            (while (and (= nil #Ret) (< #iCnt (sslength #ssSym)))
              (CFDispStar)  ; "計算中"表示
              (setq #eSym (ssname #ssSym #iCnt))
              ; 3DSOLID図形が参照されていなければ
              (if (not (member #eSym CG_eSymArea$))
                (progn
                  ; 参照済み図形の登録
                  (setq CG_eSymArea$ (cons #eSym CG_eSymArea$))
                  ; グループ図形も参照済みとして登録
                  (setq #eSym$ (CFGetGroupEnt #eSym))
                  (setq CG_eSym$Area$ (append #eSym$ CG_eSym$Area$))
                )
                ;@DEL@(setq #Ret T) ; 01/07/18 TM ADD  ; 01/07/19 HN DEL
              )
              ; 基準図形が参照済みであれば、含まれている
              (if (member &eSym CG_eSym$Area$)
                (progn
                  (setq #Ret T)
                )
              )
              (setq #iCnt (1+ #iCnt))
            )
          )
        )
      )
      ; 01/06/11 HN E-MOD

; 01/07/11 TM DEL 現在は判定不要
;    )
;
;   ; 矢視領域図形がない場合
;   (progn
;     ; 矢視と比較して有効かチェック
;     ; 01/06/08 TM 現状 A～D 矢視においても矢視領域を自動設定しているため、PとM 以外はここは通らないはず
;     (foreach #xPt &dSym$
;
;       (cond
;         ((= &sYKind "B")
;           (if (= 1 (CFArea_rl #xBas #xC #xPt))
;             (setq #Ret T)
;           )
;         )
;         ((= &sYKind "D")
;           (if (= -1 (CFArea_rl #xBas #xC #xPt))
;             (setq #Ret T)
;           )
;         )
;         ((= &sYKind "A")
;           (if (= 1 (CFArea_rl #xBas #xD #xPt))
;             (setq #Ret T)
;           )
;         )
;         ((= &sYKind "C")
;           (if (= -1 (CFArea_rl #xBas #xD #xPt))
;             (setq #Ret T)
;           )
;         )
;         ((or (= &sYKind "E") (= &sYKind "F"))
;           (princ "\n矢視が異常です。")
;         )
;         ; 平面図・パース図指定時はすべての点で T を返す
;         ((or (= &sYKing "M") (= &sYKind "P")) (setq #Ret T))
;
;         ; その他
;         (t (princ "\n異常な矢視: ") (princ &sYKind))
;       );_cond
;     );_foreach
;   )
; );_if #hReg
; 01/07/11 TM DEL 現在は判定不要

    #Ret

);_ KCFIsAreaMatchYashi

  ;;;<HOM>************************************************************************
  ;;; <関数名>  : KCFItemSurplus
  ;;; <処理概要>: ｱｲﾃﾑ選択関数
  ;;;           : 選択ｾｯﾄ内の一塊のｱｲﾃﾑを検索し
  ;;; <戻り値>  :
  ;;; <作成>    : 01/09/06 SN ADD
  ;;; <備考>    : ItemSurplus からﾌﾘｰｽﾞor非表示状態の画層も対象とする
  ;;;************************************************************************>MOH<
  (defun KCFItemSurplus
    (
    &ss
    &XDataLst$$
    /
    #ssGrp #ssRet #ssErr #ssWork
    #membFlag #wFlag
    #i #i2
    #en #engrp
    #layerdata #layername$
    )

    ;現在使用中の画層一覧を取得
    (setq #layername$ '())
    (setq #layerdata (tblnext "LAYER" T))
    (while #layerdata
      (setq #layername$ (append #layername$ (list (cdr (assoc 2 #layerdata)))))
      (setq #layerdata (tblnext "LAYER" nil))
    )

    (setq #i 0)
    (if &ss (progn
      (setq #ssRet (ssadd))
      (setq #ssErr (ssadd))
      ;選択ｾｯﾄ内の全てのEntityに対し処理を行う
      (repeat (sslength &ss)
        (setq #en (ssname &ss #i))
        ;戻り値選択ｾｯﾄに含まれていないEntityを対象にする。
        (if (and (not (ssmemb #en #ssRet))
                 (not (ssmemb #en #ssErr)))
          (cond
            ;ｸﾞﾙｰﾌﾟｱｲﾃﾑの処理
            ((and (setq #engrp (SearchGroupSym (ssname &ss #i)))
                  (setq #ssGrp (CFGetSameGroupSS #engrp))
                  (CheckXData #engrp (nth 1 &XDataLst$$)))
              (setq #ssWork (ssadd))
              (setq #i2 0)
              (setq #membFlag T)
              (setq #wFlag T)
              ;ｱｲﾃﾑのEntityが全て引数の選択ｾｯﾄに含まれているかﾁｪｯｸする。
              (repeat (sslength #ssGrp)
                (setq #en (ssname #ssGrp #i2))
                (if (and (not (ssmemb #en &ss))                            ;選択ｾｯﾄのﾒﾝﾊﾞｰでなければ
                         (member (cdr (assoc 8 (entget #en))) #layername$));ｵﾌﾞｼﾞｪｸﾄ画層が現在使用中
                  (if (/= (cdr (assoc 0 (entget #en))) "INSERT") ; 01/04/09 YM
                    (setq #membFlag nil)               ;"INSERT"でなければという条件を付加 01/04/09 YM
                  );_if                                          ; 01/04/09 YM
                  (ssadd (ssname #ssGrp #i2) #ssWork);
                );end if
                (setq #i2 (1+ #i2))
              );end repeat
              ;ｱｲﾃﾑの全てのﾒﾝﾊﾞｰが含まれていたら
              (if #membFlag
                (progn;THEN
                  ;ｱｲﾃﾑの全てのｵﾌﾞｼﾞｪｸﾄを戻り選択ｾｯﾄに加算
                  (setq #i2 0)
                  (repeat (sslength #ssGrp)
                    (ssadd (ssname #ssGrp #i2) #ssRet)
                    (setq #i2 (1+ #i2))
                  );end repeat
                );end progn
                (progn;ELSE
                  ;一部選択のｵﾌﾞｼﾞｪｸﾄをﾁｪｯｸ用選択ｾｯﾄに加算(速度ｱｯﾌﾟ用)
                  (setq #i2 0)
                  (repeat (sslength #ssWork)
                    (ssadd (ssname #ssWork #i2) #ssErr)
                    (setq #i2 (1+ #i2))
                  );end repeat
                );end progn
              );end if
              (setq #ssWork nil)
              (setq #ssGrp nil)
            );end progn
            ;ﾜｰｸﾄｯﾌﾟ･ﾌｨﾗｰなどｸﾞﾙｰﾌﾟ以外のｱｲﾃﾑ
            ((CheckXData #en (nth 0 &XDataLst$$))
              (ssadd #en #ssRet)
            )
          );end cond
        );end if
        (setq #i (1+ #i))
      );end repeat
      (setq #ssErr nil)
    ));end if - end progn
    #ssRet
  );ItemSurplus

; 02/02/04 HN S-MOD 回転角度から視点取得の処理を変更
;@DEL@  ;<HOM>*************************************************************************
;@DEL@  ; <関数名>    : SKFGetViewByAngle
;@DEL@  ; <処理概要>  : 回転角度から視点種類を獲得する
;@DEL@  ; <戻り値>    : （視点種類 WDフラグ）
;@DEL@  ; <作成>      : 1998-06-22
;@DEL@  ; <備考>      : 視点種類は以下の表から獲得する
;@DEL@  ;               回転角度     展開Ａ図    展開Ｂ図    展開Ｃ図    展開Ｄ図
;@DEL@  ;                   ０度       "03"        "05"        "04"        "06"
;@DEL@  ;                 ９０度       "05"        "04"        "06"        "03"
;@DEL@  ;               １８０度       "04"        "06"        "03"        "05"
;@DEL@  ;               ２７０度       "06"        "03"        "05"        "04"
;@DEL@  ;               それ以外        ""          ""          ""          ""
;@DEL@  ;*************************************************************************>MOH<
;@DEL@
;@DEL@  (defun SKFGetViewByAngle (
;@DEL@    &angle   ; (REAL)     回転角度
;@DEL@    &kind    ; (STR)      図面種類（展開Ａ図:"A" 展開Ｂ図:"B" 展開Ｃ図:"C" 展開Ｄ図:"D"）
;@DEL@    /
;@DEL@    #deg #ret #wd
;@DEL@    )
;@DEL@
;@DEL@    ;回転角度を度数表現に変換する
;@DEL@    (setq #deg (/ (* &angle 180.0) PI))
;@DEL@    (if (> 0.0 #deg)
;@DEL@      (while (= nil (< 0.0 #deg 360.0))
;@DEL@        (setq #deg (+ #deg 360.0))
;@DEL@      )
;@DEL@    )
;@DEL@    (if (< 360.0 #deg)
;@DEL@      (while (= nil (< 0.0 #deg 360.0))
;@DEL@        (setq #deg (- #deg 360.0))
;@DEL@      )
;@DEL@    )
;@DEL@    (if (equal #deg 360.0 0.01)
;@DEL@      (setq #deg 0.0)
;@DEL@    )
;@DEL@    ;角度に
;@DEL@    (cond
;@DEL@      ((or (<= 315.0 #deg 360.0) (<= 0.0 #deg 45.0)) (setq #deg   0.0)) ;0
;@DEL@      ((<=  45.0 #deg 135.0)                         (setq #deg  90.0)) ;90
;@DEL@      ((<= 135.0 #deg 225.0)                         (setq #deg 180.0)) ;180
;@DEL@      ((<= 225.0 #deg 315.0)                         (setq #deg 270.0)) ;270
;@DEL@    )
;@DEL@    ;視点方向を獲得
;@DEL@    (cond
;@DEL@      ((equal   0.0 #deg 0.01)                         ;    ０度
;@DEL@        (cond
;@DEL@          ((equal "A" &kind)  (setq #ret "03" #wd "W"))            ; 面
;@DEL@          ; 01/05/25 TM ADD 矢視F 追加
;@DEL@          ((or (equal "B" &kind) (equal "E" &kind) (equal "F" &kind))  (setq #ret "05" #wd "D"))
;@DEL@                                                                  ; L側面（左側面）
;@DEL@          ((equal "C" &kind)  (setq #ret "04" #wd "W"))            ; 背面
;@DEL@          ((equal "D" &kind)  (setq #ret "06" #wd "D"))            ; R側面（右側面）
;@DEL@        ) ; end cond
;@DEL@      )
;@DEL@      ((equal  90.0 #deg 0.01)                         ;  ９０度
;@DEL@        (cond
;@DEL@          ((equal "A" &kind)  (setq #ret "05" #wd "D"))            ; L側面（左側面）
;@DEL@          ((or (equal "B" &kind) (equal "E" &kind) (equal "F" &kind))  (setq #ret "04" #wd "W")) ; 背面
;@DEL@          ((equal "C" &kind)  (setq #ret "06" #wd "D"))            ; R側面（右側面）
;@DEL@          ((equal "D" &kind)  (setq #ret "03" #wd "W"))            ; 正面
;@DEL@        ) ; end cond
;@DEL@      )
;@DEL@      ((equal 180.0 #deg 0.01)                         ;１８０度
;@DEL@        (cond
;@DEL@          ((equal "A" &kind)  (setq #ret "04" #wd "W"))            ; 背面
;@DEL@          ((or (equal "B" &kind) (equal "E" &kind) (equal "F" &kind))  (setq #ret "06" #wd "D"))
;@DEL@                                                                    ; R側面（右側面）
;@DEL@          ((equal "C" &kind)  (setq #ret "03" #wd "W"))            ; 正面
;@DEL@          ((equal "D" &kind)  (setq #ret "05" #wd "D"))            ; L側面（左側面）
;@DEL@        ) ; end cond
;@DEL@      )
;@DEL@      ((equal 270.0 #deg 0.01)                         ;２７０度
;@DEL@        (cond
;@DEL@          ((equal "A" &kind)  (setq #ret "06" #wd "D"))            ; R側面（右側面）
;@DEL@          ((or (equal "B" &kind) (equal "E" &kind) (equal "F" &kind)) (setq #ret "03" #wd "W")); 正面
;@DEL@          ((equal "C" &kind)  (setq #ret "05" #wd "D"))            ; L側面（左側面）
;@DEL@          ((equal "D" &kind)  (setq #ret "04" #wd "W"))            ; 背面
;@DEL@        ) ; end cond
;@DEL@      )
;@DEL@    ) ; end cond
;@DEL@
;@DEL@    ;何も当てはまらなければ空文字列を返す
;@DEL@    (if (= nil #ret)
;@DEL@      (progn
;@DEL@        ; DEBUG (princ "\n該当する面なし？？")
;@DEL@      ; DEBUG (princ &angle)(princ ",")(princ &kind)
;@DEL@      (setq #ret "")
;@DEL@    )
;@DEL@  ) ; end if
;@DEL@
;@DEL@  (list #ret #wd) ; return
;@DEL@) ; SKFGetViewByAngle


;;;<HOM>************************************************************************
;;; <関数名>  : SKFGetViewByAngle
;;; <処理概要>: 回転角度から視点種類を獲得する
;;; <戻り値>  : （視点種類 WDフラグ）
;;; <改訂>    : 2002-02-01 HN
;;; <備考>    : 視点種類は以下の表から獲得する
;;;               回転角度     展開Ａ図    展開Ｂ図    展開Ｃ図    展開Ｄ図
;;;                   ０度       "03"        "05"        "04"        "06"
;;;                 ９０度       "05"        "04"        "06"        "03"
;;;               １８０度       "04"        "06"        "03"        "05"
;;;               ２７０度       "06"        "03"        "05"        "04"
;;;               それ以外        ""          ""          ""          ""
;;;************************************************************************>MOH<
(defun SKFGetViewByAngle
  (
  &rAng       ; 回転角度
  &sKind      ; 図面種類（展開Ａ図:"A" 展開Ｂ図:"B" 展開Ｃ図:"C" 展開Ｄ図:"D"）
  /
  #rDeg       ; 回転角度(度数表現)
  #sFace      ; 面種類
  #sWd        ;
  )

  ;回転角度を度数表現に変換する
  (setq #rDeg (/ (* &rAng 180.0) PI))
  (while (> 0.0 #rDeg)
    (setq #rDeg (+ #rDeg 360.0))
  )
  (while (< 360.0 #rDeg)
    (setq #rDeg (- #rDeg 360.0))
  )
  (if (equal #rDeg 360.0 0.01)
    (setq #rDeg 0.0)
  )

  ;視点方向を獲得
  (setq #sFace "")
  (cond
    ((equal 0.0 #rDeg 0.01)   ; ０度
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "03" #sWd "W")) ; 正面
        ((member &sKind (list "B" "E" "F")) (setq #sFace "05" #sWd "D")) ; 側面左
        ((member &sKind (list "C"        )) (setq #sFace "04" #sWd "W")) ; 背面
        ((member &sKind (list "D"        )) (setq #sFace "06" #sWd "D")) ; 側面右
      );_cond
    )
    ((equal 90.0 #rDeg 0.01)  ; ９０度
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "05" #sWd "D")) ; 側面左
        ((member &sKind (list "B" "E" "F")) (setq #sFace "04" #sWd "W")) ; 背面
        ((member &sKind (list "C"        )) (setq #sFace "06" #sWd "D")) ; 側面右
        ((member &sKind (list "D"        )) (setq #sFace "03" #sWd "W")) ; 正面
      );_cond
    )
    ((equal 180.0 #rDeg 0.01) ; １８０度
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "04" #sWd "W")) ; 背面
        ((member &sKind (list "B" "E" "F")) (setq #sFace "06" #sWd "D")) ; 側面右
        ((member &sKind (list "C"        )) (setq #sFace "03" #sWd "W")) ; 正面
        ((member &sKind (list "D"        )) (setq #sFace "05" #sWd "D")) ; 側面左
      );_cond
    )
    ((equal 270.0 #rDeg 0.01) ; ２７０度
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "06" #sWd "D")) ; 側面右
        ((member &sKind (list "B" "E" "F")) (setq #sFace "03" #sWd "W")) ; 正面
        ((member &sKind (list "C"        )) (setq #sFace "05" #sWd "D")) ; 側面左
        ((member &sKind (list "D"        )) (setq #sFace "04" #sWd "W")) ; 背面
      );_cond
    )
    ((< 0.0 #rDeg 90.0)       ; ０～９０度
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "03" #sWd "W")) ; 正面
        ((member &sKind (list "B" "E" "F")) (setq #sFace "04" #sWd "W")) ; 背面
        ((member &sKind (list "C"        )) (setq #sFace "04" #sWd "W")) ; 背面
        ((member &sKind (list "D"        )) (setq #sFace "03" #sWd "W")) ; 正面
      );_cond
    )
    ((< 90.0 #rDeg 180.0)     ; ９０～１８０度
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "04" #sWd "W")) ; 背面
        ((member &sKind (list "B" "E" "F")) (setq #sFace "04" #sWd "W")) ; 背面
        ((member &sKind (list "C"        )) (setq #sFace "03" #sWd "W")) ; 正面
        ((member &sKind (list "D"        )) (setq #sFace "03" #sWd "W")) ; 正面
      );_cond
    )
    ((< 180.0 #rDeg 270.0)    ; １８０～２７０度
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "04" #sWd "W")) ; 背面
        ((member &sKind (list "B" "E" "F")) (setq #sFace "03" #sWd "W")) ; 正面
        ((member &sKind (list "C"        )) (setq #sFace "03" #sWd "W")) ; 正面
        ((member &sKind (list "D"        )) (setq #sFace "04" #sWd "W")) ; 背面
      );_cond
    )
    ((< 270.0 #rDeg 360.0)    ; ２７０～３６０度
      (cond
        ((member &sKind (list "A"        )) (setq #sFace "03" #sWd "W")) ; 正面
        ((member &sKind (list "B" "E" "F")) (setq #sFace "03" #sWd "W")) ; 正面
        ((member &sKind (list "C"        )) (setq #sFace "04" #sWd "W")) ; 背面
        ((member &sKind (list "D"        )) (setq #sFace "04" #sWd "W")) ; 背面
      );_cond
    )
  );_cond

  (list #sFace #sWd)
);_defun
; 02/02/04 HN E-MOD 回転角度から視点取得の処理を変更

;<HOM>*************************************************************************
; <関数名>    : AlignDoorBySym$
; <処理概要>  : シンボルリストから2D-P面の扉面を配置する
; <戻り値>    : 作成された扉面
; <備考>      :
; <作成>      : 00/01/14
; <警告>      : 01/03/12 YM ｸﾞﾛｰﾊﾞﾙ CG_DOORLST の使い方に注意！
;               使い方を誤ると展開図で特注ｷｬﾋﾞに扉を張らなくなる
;*************************************************************************>MOH<
(defun AlignDoorBySym$ (
  &ss$        ; ダミー領域選択エンティティリスト
  /
  #ss #ssD #i #enD #ed$ #en #code #Dooren$ #entlast
  #ANG #DR_SS #DUM$ #MVPT #SYMD #SYMPT #TOKU$ #Dooren0$
  #SYMNORMAL$ #SYMTOKU$ #DOORLST$
  )

  ;//////////////////////////////////////////////////////////////
  ; 画層0_doorのものに絞る
  ;//////////////////////////////////////////////////////////////
    (defun ##0_door (
      &ss
      /
      #ELM #I #RET
      )
      (setq #i 0 #ret (ssadd))
      (repeat (sslength &ss)
        (setq #elm (ssname &ss #i))
        (if (= (cdr (assoc 8 (entget #elm))) "0_door") ; 画層"0_door"
          (ssadd #elm #ret)
        );_if
        (setq #i (1+ #i))
      )
      #ret
    );
  ;//////////////////////////////////////////////////////////////

  ;キャビネットの図形を選択エンティティで獲得
  (setq #ss (ssadd))
  (mapcar
   '(lambda ( #ssD )
      (setq #i 0)
      (repeat (sslength #ssD)
        (setq #enD (ssname #ssD #i))  ; ダミー図形名
        (setq #ed$ (CfGetXData #enD "G_SKDM"))
        (mapcar
         '(lambda ( #en )
            (if (not (ssmemb #en #ss))
              (progn
                (setq #code (CfGetSymSKKCode #en 1))
; 02/09/04 YM DEL ｷｬﾋﾞﾈｯﾄであるという条件を削除した
;;;02/09/04YM@DEL                (if (equal CG_SKK_ONE_CAB #code)
                  (ssadd #en #ss)
;;;02/09/04YM@DEL                )
              )
            )
          )
          (cdr (cdr #ed$))
        )
        (setq #i (1+ #i))
      )
    )
    &ss$
  )
  ;選択エンティティ→図形名リスト
  (setq #Dooren$ (Ss2En$ #ss))

  ; 01/03/12 YM ADD 特注ｷｬﾋﾞと一般ｷｬﾋﾞを分ける
  ; 特注ｷｬﾋﾞは、既存ﾌﾞﾚｰｸﾗｲﾝ一時削除、一時ﾌﾞﾚｰｸﾗｲﾝ作成しないと
  ; 扉が伸縮しないため、通常ｷｬﾋﾞと処理を分ける
  (setq #symTOKU$ nil #symNORMAL$ nil #doorlst$ nil)
  (foreach en #Dooren$
    (if (setq #TOKU$ (CFGetXData en "G_TOKU"));2011/12/09 YM MOD G_TOKU条件変更
      (setq #symTOKU$ (append #symTOKU$ (list en)))     ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞを使用
      (setq #symNORMAL$ (append #symNORMAL$ (list en))) ; 通常ｷｬﾋﾞ(ｹｺﾐ伸縮含む)
    );_if
  )
  ; 特注ｷｬﾋﾞ扉貼りつけは、特注ｷｬﾋﾞｺﾏﾝﾄﾞ時と同じ条件にして
  ; PCD_MakeViewAlignDoorに渡す(ﾌﾞﾚｰｸﾗｲﾝを一時追加)
  ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ実行中ﾌﾗｸﾞを立てる (CG_TOKU) 01/03/12 YM ADD
  (setq CG_TOKU T) ; 特注ｷｬﾋﾞ実行中
  (foreach #symTOKU #symTOKU$
    (setq #TOKU$ (CFGetXData #symTOKU "G_TOKU"))

; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中は扉の貼り直しをせずに既存扉を使用する 01/10/11 YM DEL
;;;01/10/11YM@DEL   (setq CG_TOKU_BW (nth 4 #TOKU$)) ; ﾌﾞﾚｰｸﾗｲﾝ位置
;;;01/10/11YM@DEL   (setq CG_TOKU_BD (nth 5 #TOKU$)) ; ﾌﾞﾚｰｸﾗｲﾝ位置
;;;01/10/11YM@DEL   (setq CG_TOKU_BH (nth 6 #TOKU$)) ; ﾌﾞﾚｰｸﾗｲﾝ位置
    ;// 扉面の貼り付け
    (PCD_MakeViewAlignDoor (list #symTOKU) 2 T)
    (setq #doorlst$ (append #doorlst$ CG_DOORLST))
  )
  (setq CG_TOKU nil) ; 特注ｷｬﾋﾞ実行中

  ;// 扉面の貼り付け(特注以外の場合)
  (if #symNORMAL$
    (progn
      (PCD_MakeViewAlignDoor #symNORMAL$ 2 T)
      (setq #doorlst$ (append #doorlst$ CG_DOORLST))
    )
  );_if

  (setq CG_DOORLST #doorlst$)

;;; ((<図形名: 199c4e0>  6)
;;;  (<図形名: 199d238>  6)
;;;  (<図形名: 199db88>  6)
;;;  (<図形名: 199efa0>  4)
;;;  (<図形名: 199efa0>  5)
;;;  (<図形名: 98f6988>  4)
;;;  (<図形名: 98f6988>  5)
;;;  (<図形名: 98f7640>  6)
;;; )

;;;01/03/12YM@  (setq #Dooren0$ #Dooren$)
;;;01/03/12YM@
;;;01/03/12YM@  ; 01/03/10 YM 図形名リストから特注ｷｬﾋﾞのみを取り除く
;;;01/03/12YM@  (setq #dum$ nil)
;;;01/03/12YM@  (foreach Dooren #Dooren$
;;;01/03/12YM@    (if (and (setq #TOKU$ (CfGetXData Dooren "G_TOKU"))
;;;01/03/12YM@             (= (nth 3 #TOKU$) 1)) ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞを使ったものかどうか
;;;01/03/12YM@      nil
;;;01/03/12YM@      (setq #dum$ (append #dum$ (list Dooren)))
;;;01/03/12YM@    );_if
;;;01/03/12YM@  );foreach
;;;01/03/12YM@  (setq #Dooren$ #dum$)

  ; 2000/06/22 HT DEL 速度改善
  ;(setq #ss (ssadd))
;;;01/03/12YM@  (if (/= nil #Dooren$)
;;;01/03/12YM@    (progn
      ; 2000/06/22 HT DEL 速度改善
      ;(setq #entlast (entlast))
      ; 2000/06/21 扉削除モードに変更（[印刷]-[表示制御]改修対応）
      ;(PCD_MakeViewAlignDoor #Dooren$ 2 nil)

;;;01/03/12YM@      (PCD_MakeViewAlignDoor #Dooren$ 2 T) ; 上で処理する

      ; 2000/06/22 HT DEL 速度改善 START
      ;(if (/= nil (setq #en (entnext #entlast)))
      ;  (progn
      ;    (ssadd #en #ss)
      ;    (while (setq #en (entnext #en))
      ;      (ssadd #en #ss)
      ;    )
      ;  )
      ;)
      ; 2000/06/22 HT DEL 速度改善 END
;;;01/03/12YM@    )
;;;01/03/12YM@  );_if

  ;扉位置を前面に寸法Dだけ移動 01/03/14 YM START
  ;背面扉は移動しない(扉図形はｸﾞﾛｰﾊﾞﾙ CG_DOORLST を利用)扉貼り付け時にｸﾞﾙｰﾌﾟ化しない 01/03/14 YM ADD
  (foreach DOORLST CG_DOORLST
    (setq #sym (car DOORLST))
    (if (and (not (CheckSKK$ #sym (list (itoa CG_SKK_ONE_CAB) "?" (itoa CG_SKK_THR_CNR)))) ; ｺｰﾅｰｷｬﾋﾞでない ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
             (not (CFGetXData #sym "G_TOKU")))         ; 特注ｷｬﾋﾞでない
      (progn
        (setq #DR_SS (CMN_enlist_to_ss (cadr DOORLST))) ; 扉図形ﾘｽﾄ==>選択ｾｯﾄ
        (setq #symPT (cdr (assoc 10 (entget #sym))))    ; 基準点
        (setq #symD (nth 4 (CfGetXData #sym "G_SYM")))  ; 寸法D
        (setq #ang  (nth 2 (CfGetXData #sym "G_LSYM"))) ; 配置角度
        (cond
          ((= (nth 2 DOORLST) 3)
            (setq #MVPT (polar #symPT (- #ang (dtr 90)) #symD)) ; 正面扉
          )
          ((= (nth 2 DOORLST) 4)
            (setq #MVPT (polar #symPT (+ #ang (dtr 90)) 0)) ; 背面扉
          )
          (T
            (setq #MVPT (polar #symPT (- #ang (dtr 90)) #symD)) ; その他???
          )
        );_cond
        (command "_move" #DR_SS "" #symPT #MVPT)
      )
    );_if
  );foreach
  ;扉位置を前面に寸法Dだけ移動 01/03/10 YM END

;;;01/03/14@  ;扉位置を前面に寸法Dだけ移動 01/03/10 YM START
;;;01/03/14@  (foreach sym #Dooren$
;;;01/03/14@    (if (not (CheckSKK$ sym (list (itoa CG_SKK_ONE_CAB) "?" (itoa CG_SKK_THR_CNR)))) ; 01/08/31 YM MOD ｸﾞﾛｰﾊﾞﾙ化
;;;01/03/14@      (progn ; ｺｰﾅｰｷｬﾋﾞは除外
;;;01/03/14@        (setq #DR_SS (KP_GetDoorSSFromSYM sym))
;;;01/03/14@        ;;;画層"0_door"のものに絞る
;;;01/03/14@        (setq #DR_SS (##0_door #DR_SS))
;;;01/03/14@        (setq #symPT (cdr (assoc 10 (entget sym))))    ; 基準点
;;;01/03/14@        (setq #symD (nth 4 (CfGetXData sym "G_SYM")))  ; 寸法D
;;;01/03/14@        (setq #ang  (nth 2 (CfGetXData sym "G_LSYM"))) ; 配置角度
;;;01/03/14@        (setq #MVPT (polar #symPT (- #ang (dtr 90)) #symD))
;;;01/03/14@        (command "_move" #DR_SS "" #symPT #MVPT)
;;;01/03/14@      )
;;;01/03/14@    );_if
;;;01/03/14@  );foreach
;;;01/03/14@  ;扉位置を前面に寸法Dだけ移動 01/03/10 YM END 特注ｷｬﾋﾞは対象外

  ; 2000/06/22 HT DEL 速度改善
  ;#ss
) ; AlignDoorBySym$

;<HOM>***********************************************************************
; <関数名>    : KP_GetDoorSSFromSYM
; <処理概要>  : ｼﾝﾎﾞﾙ図形を渡して既に存在する扉面図形の選択ｾｯﾄを取得する
; <引数>    :ｼﾝﾎﾞﾙ図形
; <戻り値>  :扉面図形の選択ｾｯﾄ
; <作成>    :01/03/09 YM
; <備考>    : PKD_EraseDoor の真似
;***********************************************************************>HOM<
(defun KP_GetDoorSSFromSYM (
  &sym
  /
  #300 #340 #EG$ #EG2 #RETSS #I #SS$
  )
  ;////////////////////////////////////////////////////////////////////
  ; 選択ｾｯﾄﾘｽﾄ==>選択ｾｯﾄにまとめる
  ;////////////////////////////////////////////////////////////////////
  (defun ##fromSS$toSS (
    &ss$
    /
    #ss #ELM #I #J
    )
    (setq #ss (ssadd))
    (foreach dum &ss$
      (if (> (sslength dum) 0)
        (progn
          (setq #j 0)
          (repeat (sslength dum)
            (setq #elm (ssname dum #j))
            (ssadd #elm #ss)
            (setq #j (1+ #j))
          )
        )
      );_if
    )
    #ss
  );
  ;////////////////////////////////////////////////////////////////////

  ;// シンボル基準図形をロック
  (command "_layer" "lo" "N_SYMBOL" "") ; LOﾛｯｸ
  (setvar "PICKSTYLE" 1)
  (setq #eg$ (entget &sym '("*")))
  (setq #i 0)
  (foreach #eg #eg$
    (if (= (car #eg) 330)
      (progn
        (setq #eg2 (entget (cdr #eg)))
        (setq #300 (cdr (assoc 300 #eg2))) ; グループの説明
        (setq #340 (cdr (assoc 340 #eg2)))
        (if (= #300 SKD_GROUP_INFO) ; グループの説明 01/06/27 YM "DoorGroup"-->SKD_GROUP_INFO ｸﾞﾛｰﾊﾞﾙを使用
          (setq #SS$ (append #SS$ (list (CFGetSameGroupSS #340))))
        );_if
      )
    );_if
    (setq #i (1+ #i))
  );foreach
  (setvar "PICKSTYLE" 0)
  (command "_layer" "u" "N_SYMBOL" "")
  (##fromSS$toSS #SS$)
);KP_GetDoorSSFromSYM

;<HOM>************************************************************************
; <関数名>  : GetWtAndFilr
; <処理概要>: ワークトップと天井フィラーを獲得
; <戻り値>  : 選択セット
; <作成>    : 00/01/20
; <備考>    : 平面図のときはワークトップのみ
;             矢視領域図形名がnilのとき、すべてが対象
;             コーナー基点にSKDMの図形を置く
;             2000/06/12 HT    "G_WRKT" "G_BKGD" "G_FILR" "G_PANEL" 00/10/18すべて取得
;                        分離型ワークトップにも対応
;************************************************************************>MOH<

(defun GetWtAndFilr (
  &en         ; 矢視図形名
  &type       ; 平面図、展開図フラグ（"M":パース図 "P":平面図 "E":展開図）
  /
  #ss
  #pt$
  #flg
  #ssw
  #i
  #en
  ;#ed$
  ;#wpt
  ;#wpt$
  #flg2
  #gen$
  #gen
  ;#pp
  #ssf
  #fben
  #fpt
  #sXAppName$  ; 対象図形のXData AppName
  #ij
  )
  (setq #ss (ssadd))
  (if (/= nil &en)
    (progn
      ; 01/04/25 TM MOD 矢視領域の仕様変更 ZANZANZAN
      ;矢視領域の構成座標を獲得
      ;(setq #pt$ (mapcar 'car (get_allpt_h &en)))
      (setq #pt$ (mapcar 'car (KCFGetDaByYasReg &en &type)))
      ; 01/04/25 TM MOD 矢視領域の仕様変更
      ; JudgeNaigai 対策
      (setq #pt$ (append #pt$ (list (car #pt$))))
      (setq #flg nil)
    )
    (progn
      ;(princ "\nフィラー・ワークトップなし")
      (setq #flg T)
    )
  )

  ; 2000/06/12  HT ワークトップとバックガードとフィラーとスペーサー
  ;             選択エンティティで獲得
  ; 01/04/28 MOD HN
  ;@DEL@(setq #XAppName$ (list "G_WRKT" "G_BKGD"))  ;00/10/18 HN MOD
  ; 01/05/31 TM MOD-S 平面図の場合はフィラーを入れないように変更
  (if (/= &type "P")
    (setq #XAppName$ (list "G_WRKT" "G_BKGD" "G_FILR"))
    ; 01/11/30 HN MOD 水栓穴図形も対象
    ;@MOD@(setq #XAppName$ (list "G_WRKT" "G_BKGD"))
    (setq #XAppName$ (list "G_WRKT" "G_BKGD" "G_WTHL"))
  )
  ; 01/05/31 TM MOD-E 平面図の場合はフィラーを入れないように変更
  (setq #ij 0)
  (repeat (length #XAppName$)
    ;ワークトップを選択エンティティで獲得
    (setq #ssw (ssget "X" (list (list -3 (list (nth #iJ #XAppName$))))))

    ; 2000/07/06 HT YASHIAC  矢視領域判定変更
    ;// 矢視方向から展開対象となるワークトップを抜きだす
    (command "_.VIEW" "T")
    (setq #ssw (GetWtAndFilrByYashi #ssw &type (nth #iJ #XAppName$)))
    (if (/= nil #ssw)
      (progn
        (setq #i 0)
        (repeat (sslength #ssw)
          (setq #en (ssname #ssw #i))
          ;(setq #ed$ (CfGetXData #en (nth #iJ #XAppName$)))
          ; 2000/06/13 HT
          ;(setq #flg2 "OK")
          ;ワークトップコーナー基点を得
          ;(if (and (/= nil #ed$) (= (nth #iJ #XAppName$) "G_WRKT"))
          ;  (progn
          ;    ;(if (> 50 (length #ed$))     ; 00/04/10 HN MOD
          ;    ;  (setq #wpt (nth 45 #ed$))  ; New G_WRKT
          ;    (setq #wpt (nth 32 #ed$))  ; Old G_WRKT  2000/06/10 HT 2000/07/03 HT
          ;     ;)
          ;    (setq #wpt$ (cons #wpt #wpt$))
          ;    ;領域範囲内か判断
          ;    (if (/= nil #flg)
          ;      (setq #flg2 "OK")
          ;      (if (JudgeNaigai #wpt #pt$)
          ;        (setq #flg2 "OK")
          ;        (setq #flg2 "NO")
          ;      )
          ;    )
          ;  )
          ;)
          ;(if (= "OK" #flg2)
          ;  (progn
              (if (or (= "M" &type) (= "P" &type))
                (progn             ;平面図
                  (ssadd #en #ss)
                )
                (progn             ; 展開図
                  (if (or (= (nth #iJ #XAppName$) "G_BKGD")
                          (= (nth #iJ #XAppName$) "G_FILR"))
                    (progn
                     (ssadd #en #ss)
                    )
                    (progn
                      (setq #gen$ (SKFGetGroupEnt #en))
                      (mapcar
                       '(lambda ( #gen )
                          ; 2000/10/19 HT インテリアパネル G_LSYM図形は省きたかったので
                          ; Z_??画層の図形のみとした。
                          (if (wcmatch (cdr (assoc 8 (entget #gen))) "Z_??")
                            (ssadd #gen #ss)
                          )
                        )
                        #gen$
                      )
                    )
                  );_if
                )
              )
          ;  )
          ;)
          ;;00/10/18 HN S-ADD
          ;(if (= (nth #iJ #XAppName$) "G_PANEL")
          ;  (progn
          ;    (ssadd #en #ss)
          ;  )
          ;)
          ;00/10/18 HN E-ADD
          (setq #i (1+ #i))
        )
        ; (setq #wpt$ (PtSort #wpt$ (angtof "5") T))
      )
    )
    (setq #ij (1+ #ij))
  ) ; repeat


  ;天井フィラー（展開図のみ）
  (if (/= "P" &type)
    (progn
      ; 01/05/31 TM ADD テスト
      (setq #ssf (ssget "X" (list (list -3 (list "G_FILR")))))
      ; 2000/07/06 HT YASHIAC  矢視領域判定変更
      ;// 矢視方向から展開対象となるワークトップを抜き出す
      (setq #ssf (GetWtAndFilrByYashi #ssf &type "G_FILR"))
      (if (/= nil #ssf)
        (progn
          (setq #i 0)
          (repeat (sslength #ssf)
            (setq #en (ssname #ssf #i))
            ;天井フィラー構成座標獲得
            (setq #fben (nth 2 (CfGetXData #en "G_FILR")))
            (setq #fpt (car (mapcar 'car (get_allpt_h #fben))))
            ;領域範囲内か判断
            (if (/= nil #flg)
              (setq #flg2 "OK")
              (if (JudgeNaigai #fpt #pt$)
                (setq #flg2 "OK")
                (setq #flg2 "NO")
              )
            )
;@@@(princ "\n#flg2: ")(princ #flg2)
            (if (= "OK" #flg2)
              (progn

;;;01/04/13Fri_YM@                (ssadd #en #ss)
;;;01/04/13Fri_YM@                ; 00/05/28 HN E-MOD 天井フィラーの図形取得方法を変更

;;;01/04/13Fri_YM@ 追加 START
                      (setq #gen$ (SKFGetGroupEnt #en))
                      (mapcar
                       '(lambda ( #gen )
                          ; 2000/10/19 HT インテリアパネル G_LSYM図形は省きたかったので
                          ; Z_??画層の図形のみとした。
                          (if (wcmatch (cdr (assoc 8 (entget #gen))) "Z_??")
                            (ssadd #gen #ss)
                          )
                        )
                        #gen$
                      )
;;;01/04/13Fri_YM@ 追加 END

              )
            )
            (setq #i (1+ #i))
          )
        )
      )
    )
  )

  ; 2000/06/22 HT 旧松下専用処理のため削除
  ;; 2000/06/12 HT サイドパネルも取得する
  ; DEL (setq #xSs (ssget "X" '((-3 ("G_LSYM")))))
  ; DEL (setq #i 0)
  ; DEL (if #xSs
  ; DEL   (progn
  ; DEL   (repeat (sslength #xSs)
  ; DEL     (if (= (CFGetSymSKKCode (setq #en (ssname #xSs #i)) 1) CG_SKK_ONE_SID)
  ; DEL       (progn
  ; DEL         (setq #gen$ (SKFGetGroupEnt #en))
  ; DEL         (mapcar
  ; DEL           '(lambda ( #gen )
  ; DEL              ; ブレークラインは不要
  ; DEL              (if (= (CfGetXData #gen "G_BRK") nil)
  ; DEL                (ssadd #gen #ss)
  ; DEL              )
  ; DEL            )
  ; DEL           #gen$
  ; DEL         )
  ; DEL       )
  ; DEL     )
  ; DEL     (setq #i (1+ #i))
  ; DEL   )
  ; DEL   )
  ; DEL )

  #ss
)


;<HOM>*************************************************************************
; <関数名>    : GetWtAndFilrByYashi
; <処理概要>  : 矢視方向から展開対象となるワークトップと天井フィラーを抜き出す
; <戻り値>    : 選択セット
; <作成>      : 00/01/20
; <備考>      : 平面図のときはワークトップのみ
;               矢視領域図形名がnilのとき、すべてが対象
;               コーナー基点にSKDMの図形を置く
;               2000/07/06 HT YASHIAC  矢視領域判定変更 関数追加
;*************************************************************************>MOH<

(defun GetWtAndFilrByYashi (
    &ssw    ;(PICKSET)ワークトップ選択セット
    &type   ;(STR)    平面図、展開方向記号（"M":パース図 "P":平面図 "A or B or C or D or E":展開図）
    &app    ;(STR) アプリケーション名(G_WRKT,G_FILR)
    /
    #p1 #p2 #p3 #p4 ; 領域の４隅の点
    #xReg   ; 矢視領域点列
    #sXp
    #sXd$   ; 拡張図形(??  Ａ矢視方向 設定矢視)
    #sPt    ; 基点
    #rAng   ; 矢視の向き(単位:rad)
    #ssw
    #eYas   ; 矢視図形
    #dGr    ; 矢視図形の中心？
  )

  ; 矢視選択セット取得
  (setq #sXp (ssget "X" '((-3 ("RECT")))))
  ; 方向別矢視取得
  ; 01/05/25 TM MOD-S 矢視F追加
  ;(if (= &type "E")
  ;  (setq #sXp (SCFIsYashiType #sXp "*E*"))
  ;  (setq #sXp (SCFIsYashiType #sXp "*[ABCD]*"))
  ;)
  (cond
    ((or (= &type "E") (= &type "F"))
      (setq #sXp (SCFIsYashiType #sXp (strcat "*" &type "*")))
    )
    (t (setq #sXp (SCFIsYashiType #sXp "*[ABCD]*")))
  )
  ; 01/05/25 TM MOD-E 矢視F追加

  ; 01/05/31 HN MOD 矢視判定を変更
  ;@MOD@(if #sXp
  (if (and (/= "M" &type) (/= "P" &type) #sXp)
    (progn
      (setq #eYas (ssname #sXp 0))
      ; 矢視拡張データ取得
      (setq #sXd$ (CFGetXData #eYas "RECT"))

      ; 矢視角度
      (setq #rAng (dtr (atoi (nth 1 #sXd$))))
      ; DEBUG (princ "\n矢視の向き: ")(princ #rAng)

      ; 矢視基点
      (setq #sPt (cdr (assoc 10 (entget #eYas))))

      ; 矢視に領域が指定されているか？
      (setq #xReg$ (KCFGetDaByYasReg #eYas &type))
      (if #xReg$
        (progn
          ; 01/04/26 TM ADD 矢視領域が設定されている場合、矢視基点を矢視内の適当な点に変更する
          (if (not (JudgeNaigai #sPt #xReg$))
            (progn
              (setq #xGr
                (list
                  (/ (apply '+ (mapcar 'car  #xReg$)) (length #xReg$))
                  (/ (apply '+ (mapcar 'cadr  #xReg$)) (length #xReg$))
                )
              )
              ; 01/04/26 TM ADD 全座標の中央位置 ZAN
              (setq #sPt #xGr)
            )
          )
          ; 指定図形を取得
          ; 04/04/08 MOD-S 対面プラン対応
          ; 10000では、３面ビュー内の縦長のビューでのズーム領域をはみ出る
          ;(command "ZOOM" "C" #sPt 10000)
          (command "ZOOM" "C" #sPt 20000)
          ; 04/04/08 MOD-S 対面プラン対応

          ;(ssget "CP" (list #p1 #p2 #p3 #p4) (list (list -3 (list &app))))
          (ssget "CP" #xReg$ (list (list -3 (list &app))))
        )
        ; 指定されていない場合、すべてのワークトップを返す
        &ssw
      )
    )
    (progn
      &ssw
    )
  )
) ; GetWtAndFilrByYashi

;/////////////////////////////////////


(defun c:iii ( / )
  (C:KPInsertBlock)
)

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KPDeleteBlock
;;; <処理概要>  : パースを削除する(パース削除コマンド)
;;; <戻り値>    : なし
;;; <作成>      : 01/03/13 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KPDeleteBlock (
  /
  #SS
  )
  ;// コマンドの初期化
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (StartUndoErr)
  );_if

  ; 03/01/21 YM ADD-S
  (setq #dwgname (getvar "DWGNAME"))
  (if (vl-string-search "立体" #dwgname) ; ﾊﾟｰｽ用ﾃﾝﾌﾟﾚｰﾄ
    (progn
      (CFAlertMsg "この図面はパースを削除できません")
      (quit)
    )
  );_if
  ; 03/01/21 YM ADD-E

  (setq #lay-view3 "VIEW3")
  ; VIEWPORT (VIEW3:ﾌﾘｰﾊﾟｰｽ挿入用)があれば削除
  (setq #ssVIEW (ssget "X" '((0 . "VIEWPORT"))))
  (setq #i 0)
  (if (and #ssVIEW (< 0 (sslength #ssVIEW)))
    (progn
      (repeat (sslength #ssVIEW)
        (setq #eg$ (entget (ssname #ssVIEW #i)))
        (setq #8  (cdr (assoc  8 #eg$)))
        (if (= #8 #lay-view3)
          (progn ; 過去にﾊﾟｰｽ追加した
            ; VIEWPORT図形を削除
            (command "_layer" "U" #lay-view3 "ON" #lay-view3 "") ; ﾛｯｸ解除,表示
            (entdel (ssname #ssVIEW #i))
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (setvar "TILEMODE" 1) ; ﾓﾃﾞﾙﾀﾌﾞ
  (setq #ss (ssget "X" '((8 . "0_PERS")))) ; ﾊﾟｰｽの画層
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (command "erase" #ss "")
      (princ "\nパースを削除しました。")
    )
    (CFAlertMsg "\n図面にパースが存在しません。")
  );_if

  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (setq *error* nil)
  );_if
  (princ)
);C:KPDeleteBlock

;;;<HOM>************************************************************************
;;; <関数名>  : KPfDelBlockDwg
;;; <処理概要>: 展開元図フォルダの全ファイルを削除
;;; <戻り値>  : LIST: 削除したファイル名
;;;             nil : ファイルなし、または、削除なし
;;; <作成>    : 01/07/27 HN
;;; <備考>    : 確認ダイアログを表示します。
;;;************************************************************************>MOH<
(defun KPfDelBlockDwg
  (
  /
  #sPath      ; 展開元図フォルダ（フルパス）
  #sFile      ; 削除する展開元図のファイル名（パスなし）
  #sFile$     ; 削除する展開元図のファイル名リスト
  )

  ;; 展開元図フォルダ内の全ファイルをリスト
  (setq #sPath (strcat CG_KENMEI_PATH "BLOCK\\"))
  (setq #sFile$ (vl-directory-files #sPath nil 1))

  ;; ファイルが存在する場合、確認ダイアログを表示
  (if #sFile$
    ;; 削除しない場合はファイル名リストをクリア
    ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは全て削除する
    (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
  ;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
      nil
      (if (= nil (CFYesNoDialog "作成済みの展開元図をすべて削除しますか？"))
        (setq #sFile$ nil)
      )
    );_if
    ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞでは全て削除する
  )

  ;; 展開元図ファイルを削除
  (foreach #sFile #sFile$
    (vl-file-delete (strcat #sPath #sFile))
  )

  ;; デバッグ用出力
  (if CG_DEBUG
    (progn
      (princ "\n**** KPfDelBlockDwg() ****")
      (foreach #sFile #sFile$
        (princ (strcat "\nﾌｧｲﾙ " #sPath #sFile "を削除しました."))
      )
    )
  )

  #sFile$
) ;_defun KPfDelBlockDwg




;;;<HOM>************************************************************************
;;; <関数名>  : ChViewport
;;; <処理概要>: VIEWPORT切り替え関数
;;; <引数>    : VIEWPORT ID
;;; <作成>    : 03/01/17 YM
;;; <備考>    :
;;;************************************************************************>MOH<
(defun ChViewport ( &ID / )
  (setvar "TILEMODE" 0); ﾚｲｱｳﾄﾀﾌﾞ切り替え
  (command "_.pspace") ; ﾍﾟｰﾊﾟｰ空間にする
  (command "_mspace")  ; ﾓﾃﾞﾙ空間にする
  (setvar "CVPORT" &ID); ﾋﾞｭｰﾎﾟｰﾄID
  (princ)
)

;///////////////// ﾃﾝﾌﾟﾚｰﾄ作成関数 //////////////////////////
(defun C:tt ( / #LAY-VIEW1)
  ; 2D用ﾋﾞｭｰﾎﾟｰﾄ画層"VIEW1"作成 A3-30
  (setq #lay-view1 "VIEW1")
  (if (tblsearch "layer" #lay-view1)
    (command "_layer"                "C" 1 #lay-view1 "L" SKW_AUTO_LAY_LINE #lay-view1 "")
    (command "_layer" "N" #lay-view1 "C" 1 #lay-view1 "L" SKW_AUTO_LAY_LINE #lay-view1 "")
  );_if

  (setvar "CLAYER" #lay-view1)

  ; 2Dﾋﾞｭｰﾎﾟｰﾄ作図
  (command "_mview" (list 8.7 4.2) (list 577.3 402.4)) ; A2
;;; (command "_mview" (list 5 5) (list 404.6 280.5)) ; A3

  (command "_mspace") ; 3Dﾋﾞｭｰﾎﾟｰﾄ内ﾓﾃﾞﾙ空間

  (princ)
)


;;;<HOM>*************************************************************************
;;; <関数名>    : KPFreeInsertBlock
;;; <処理概要>  : ﾌﾘｰﾃﾝﾌﾟﾚｰﾄにﾊﾟｰｽを挿入する(ﾌﾘｰﾊﾟｰｽ挿入ｺﾏﾝﾄﾞ)
;;; <戻り値>    : なし
;;; <作成>      : 02/11/18 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KPFreeInsertBlock (
  /
  #69 #BLOCK #CS #EG$ #EVIEW3D #LAY-0PERS #LAY-VIEW2 #P1 #P2
  #8 #CLAYER #DWGNAME #I #LAY-VIEW3 #SSVIEW #SS #xSp
  )
  (setq #dwgname (getvar "DWGNAME"))
  (if (vl-string-search "立体" #dwgname) ; ﾊﾟｰｽ用ﾃﾝﾌﾟﾚｰﾄ
    (progn
      (CFAlertMsg "この図面にはパースを挿入できません")
      (quit)
    )
  );_if

  ; ﾚｲｱｳﾄﾀﾌﾞ切り替え
  (setvar "TILEMODE" 0)
  ; 一度ﾊﾟｰｽをﾌﾘｰ挿入した場合状態をﾍﾟｰﾊﾟｰ空間にしてからﾊﾟｰｽ削除を行う
  (command "_.pspace") ; ﾍﾟｰﾊﾟｰ空間 03/01/21 YM ADD

  (setq #lay-0pers "0_pers")
  (setq #lay-view2 "VIEW2")
  (setq #lay-view3 "VIEW3")

  ; VIEWPORT(VIEW2ﾊﾟｰｽ挿入用,VIEW3ﾌﾘｰﾊﾟｰｽ挿入用) の検索
  (setq #ssVIEW (ssget "X" '((0 . "VIEWPORT"))))
  (setq #i 0)
  (if (and #ssVIEW (< 0 (sslength #ssVIEW)))
    (progn
      (repeat (sslength #ssVIEW)
        (setq #eg$ (entget (ssname #ssVIEW #i)))
        (setq #8  (cdr (assoc  8 #eg$)))
        (if (= #8 #lay-view3)
          (progn ; 過去にﾊﾟｰｽ追加した
            (if (CFYesNoDialog "挿入したパースを削除しますか?")
              (progn ; 過去にﾊﾟｰｽ追加した
                ; VIEWPORT図形を削除
                (command "_layer" "U" #lay-view3 "ON" #lay-view3 "") ; ﾛｯｸ解除,表示
                (entdel (ssname #ssVIEW #i))

                (setvar "TILEMODE" 1) ; ﾓﾃﾞﾙﾀﾌﾞ
                (setq #ss (ssget "X" '((8 . "0_PERS")))) ; ﾊﾟｰｽの画層
                (if (and #ss (< 0 (sslength #ss)))
                  (progn
                    (command "erase" #ss "")
                    (princ "\nパースを削除しました。")
                  )
                );_if

                  (setvar "TILEMODE" 0) ; ﾚｲｱｳﾄﾀﾌﾞ
              )
            ; else
              (quit) ; 終了
            );_if
          )
        );_if

        (setq #i (1+ #i))
      )
    )
  );_if

  ; 2D用ﾋﾞｭｰﾎﾟｰﾄ画層"VIEW1"作成 A3-30
  (setq #lay-view3 "VIEW3")
  (if (tblsearch "layer" #lay-view3)
    (command "_layer"                "C" 1 #lay-view3 "L" SKW_AUTO_LAY_LINE #lay-view3 "") ; 赤
    (command "_layer" "N" #lay-view3 "C" 1 #lay-view3 "L" SKW_AUTO_LAY_LINE #lay-view3 "") ; 赤
  );_if

  ; 3Dﾋﾞｭｰﾎﾟｰﾄ作図
  ;// カーソルサイズ
;;;  (setq #cs (getvar "CURSORSIZE"))
;;;  (setvar "CURSORSIZE" 100)
  ; 現在画層の変更
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" #lay-view3)

  (command "zoom" "E")  ; 画面いっぱいにズーム
  (princ "\nパース挿入枠を四角(2点)で囲ってください: ")
  (setq #p1 (getpoint))
  (setq #p2 (getcorner #p1))
  (command "_mview" #p1 #p2)

  (setq #eVIEW3D (entlast))
  (setq #eg$ (entget #eVIEW3D))
  (setq #69 (cdr (assoc 69 #eg$))) ; VIEWPORT ID

  ; 3Dﾓﾃﾞﾙ空間内はﾊﾟｰｽ画層以外をﾌﾘｰｽﾞ
  (command "_mspace") ; 3Dﾋﾞｭｰﾎﾟｰﾄ内ﾓﾃﾞﾙ空間
  (setvar "GRIDMODE" 0)
  (setvar "ORTHOMODE" 1)
  (setvar "SNAPMODE" 0)

  (command "_vplayer" "F" "*" "C" "")        ; 全画層ﾌﾘｰｽﾞ
  (command "_vplayer" "T" #lay-0pers "C" "") ; ﾊﾟｰｽ画層ﾌﾘｰｽﾞ解除

  ; ﾓﾃﾞﾙ空間でﾊﾟｰｽを挿入
  (SKChgView "2,-2,1") ; ﾋﾞｭｰ変更
  (command "zoom" "E") ; 画面いっぱいにズーム

  (setvar "TILEMODE" 1)
  (setq #block (strcat CG_KENMEI_PATH "BLOCK\\" "M_0.dwg"))
  (if (findfile #block)
    (progn
      (command "_purge" "bl" "*" "N")
      (command "_purge" "bl" "*" "N")
      (command "_purge" "bl" "*" "N")

      (setvar "ELEVATION" 0.0)
      (command "_Insert" #block '(0.0 0.0) 1 1 0.0)

; 固定位置に挿入
;;;      (princ "\nパース挿入位置: ")
;;;      (command "_Insert" #block pause "" "")
;;;      (princ "\n配置角度: ")
;;;      (command pause)

      (command "_explode" (entlast))
      (setq #xSp (ssget "P"))
      (setvar "ELEVATION" 0.0)
    )
    (progn
      (CFAlertMsg "\nパースがありません。")
      (quit)
    )
  );_if

  (setvar "TILEMODE" 0) ; ﾚｲｱｳﾄ図に移行
  (command "_.pspace")  ; ﾍﾟｰﾊﾟｰ空間
  (command "zoom" "E")  ; 画面いっぱいにズーム
  (command "_.MVIEW" "H" "ON" #eVIEW3D "")

  ; 3Dｵｰﾋﾞｯﾄ
  (princ "\n向きの調整を行って下さい。")
  (princ "\n")

  (ChViewport #69)

  (command "_mspace")
  (command "_camera" (list 6222 -6222 3411) (list -66 66 266)) ; 南東等角図カメラ位置
; (command "_.DVIEW" "ALL" "" "D" 7500 "X") ; 透視図
  (command "_.DVIEW" #xSp "" "D" 7500 "X") ; 透視図

;;; (command "zoom" "E")  ; 画面いっぱいにズーム
  (command "_3DORBIT")

  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (setq *error* nil)
  );_if

  ; 終了時設定
  (command "_.pspace") ; ﾍﾟｰﾊﾟｰ空間
  ; "VIEW2"をﾛｯｸ,非表示
;;; (command "_layer" "U" #lay-view3 "ON" #lay-view3 "") ; ﾛｯｸ解除,表示
  (command "_layer" "LO" #lay-view3 "OF" #lay-view3 "") ; ﾛｯｸ,非表示
  ;// カーソルサイズ
;;;  (setvar "CURSORSIZE" #cs)
  ; 現在画層の変更
  (setvar "CLAYER" #clayer)


  ; メッセージ表示:
;;;  (CFYesDialog (strcat "再度パースの向きを変更するには、"))
  (princ "\n")(princ "\n")
  (princ "\n★パースの向きを変更するには再度パース挿入を行ってください")
  (princ)
);KPFreeInsertBlock


;<HOM>*************************************************************************
; <関数名>    : KCFAutoMakeDiningPlanYashi
; <処理概要>  : 収納プラン用の矢視を自動で作成する(I型配列前提)
; <戻り値>    : なし
; <作成>      : 08/12/23 YM
; <備考>      : 矢視ABCを作成する
;               以下の配列を前提
;               +-----+------------+
;               |     |            |
;               +-----+------------+
;*************************************************************************>MOH<
(defun KCFAutoMakeDiningPlanYashi (
  /
  #AEN #BEN #DD #DEN #LR #OFFSET #P1 #P2 #P3 #P4 #PB1 #PB2 #PB3 #PB4 
  #PD1 #PD2 #PD3 #PD4 #PP1 #PP2 #PP3 #PP4 #SCECOLOR #WW #YEN #YPT
  )

  (if (= nil (tblsearch "APPID" "RECT")) (regapp "RECT"))

  ; 収納プランかどうかを判定する
  (if (= CG_UnitCode "D");収納
    (progn
      ; 図形色番号の変更
      (setq #sCECOLOR (getvar "CECOLOR"))
      (setvar "CECOLOR" "50")

      ;奥行き間口から展開B,D領域を求める
      (setq #DD (nth 53 CG_GLOBAL$));奥行き
      (setq #DD (- (atoi (substr #DD 2 10))))
      (setq #WW (nth 55 CG_GLOBAL$));間口
      (setq #WW (* (atoi (substr #WW 2 10)) 10))
      (setq #LR (nth 56 CG_GLOBAL$));L/R/N

      (if (or (= #LR "L")(= #LR "N"))
        (progn ;L勝手または勝手なし

          (setq #p1 (list 3600 0))
          (setq #p2 (list (+ 3600 #WW) 0))
          (setq #p3 (list (+ 3600 #WW) #DD))
          (setq #p4 (list 3600 #DD))

          ;I型領域を囲む領域の点を求める
    ; +p1                    +p2
    ;    @               @
    ;    |               |
    ;    @               @
    ; +p4                    +p3
          (setq #offset 200)
          (setq #pp1 (polar #p1 (dtr 135.) #offset))
          (setq #pp2 (polar #p2 (dtr  45.) #offset))
          (setq #pp3 (polar #p3 (dtr  -45.) #offset))
          (setq #pp4 (polar #p4 (dtr -135.) #offset))

          ;B領域
          (setq #pb1 #pp1)
          (setq #pb4 #pp4)
          (setq #pb2 (list (+ (nth 0 #pb1) 500) (nth 1 #pp1)))
          (setq #pb3 (list (+ (nth 0 #pb4) 500) (nth 1 #pp4)))

          ;D領域
          (setq #pd2 #pp2)
          (setq #pd3 #pp3)
          (setq #pd1 (list (- (nth 0 #pd2) 500) (nth 1 #pp2)))
          (setq #pd4 (list (- (nth 0 #pd3) 500) (nth 1 #pp3)))

        )
        (progn ;R勝手

          (setq #p1 (list (- 3600 #WW)   0))
          (setq #p2 (list 3600   0))
          (setq #p3 (list 3600 #DD))
          (setq #p4 (list (- 3600 #WW) #DD))

          ;I型領域を囲む領域の点を求める
    ; +p1                    +p2
    ;    @               @
    ;    |               |
    ;    @               @
    ; +p4                    +p3
          (setq #offset 200)
          (setq #pp1 (polar #p1 (dtr 135.) #offset))
          (setq #pp2 (polar #p2 (dtr  45.) #offset))
          (setq #pp3 (polar #p3 (dtr  -45.) #offset))
          (setq #pp4 (polar #p4 (dtr -135.) #offset))

          ;B領域
          (setq #pb1 #pp1)
          (setq #pb4 #pp4)
          (setq #pb2 (list (+ (nth 0 #pb1) 500) (nth 1 #pp1)))
          (setq #pb3 (list (+ (nth 0 #pb4) 500) (nth 1 #pp4)))

          ;D領域
          (setq #pd2 #pp2)
          (setq #pd3 #pp3)
          (setq #pd1 (list (- (nth 0 #pd2) 500) (nth 1 #pp2)))
          (setq #pd4 (list (- (nth 0 #pd3) 500) (nth 1 #pp3)))

        )
      );_if

      ; 矢視を配置する点を求める
      (setq #yPt  (polar #p3 (angle #p3 #p4) (/ (distance #p3 #p4) 2.0)))

      ; 矢視の作図
      (setq #yEn  (SCFDrawYashi "ABD" #yPt "90" CG_YASHI_LAYER))
      (setvar "CECOLOR" "60")

      ; 矢視ＡＢＤの領域作図
      (setq #aEn (MakeLwPolyLine (list #pp1 #pp2 #pp3 #pp4) 1 0))
      (setq #bEn (MakeLwPolyLine (list #pb1 #pb2 #pb3 #pb4) 1 0))
      (setq #dEn (MakeLwPolyLine (list #pd1 #pd2 #pd3 #pd4) 1 0))

      ; 拡張データの付加
      (CFSetXData #yEn "RECT"
        (list
          "0"
          "90"
          "ABD"
          (cdr (assoc 5 (entget #aEn)))
          (cdr (assoc 5 (entget #bEn)))
          (cdr (assoc 5 (entget #dEn)))
        )
      )

      ; システム変数を元に戻す
      (setvar "CECOLOR" #sCECOLOR)
      (command "zoom" "e")
      (command "_REGEN")
    )
  )
  (princ)
);KCFAutoMakeDiningPlanYashi

;<HOM>*************************************************************************
; <関数名>    : KCFAutoMakeDiningPlanYashi_EXTEND
; <処理概要>  : 収納プラン用の矢視を自動で作成する(I型配列収納拡大)
; <戻り値>    : なし
; <作成>      : 2009/11/27 YM ADD
; <備考>      : 矢視ABCを作成する
;               以下の配列を前提
;               +-----+------------+
;               |     |            |
;               +-----+------------+
;*************************************************************************>MOH<
(defun KCFAutoMakeDiningPlanYashi_EXTEND (
  /
  #AEN #BEN #DD #DEN #LR #OFFSET #P1 #P2 #P3 #P4 #PB1 #PB2 #PB3 #PB4 
  #PD1 #PD2 #PD3 #PD4 #PP1 #PP2 #PP3 #PP4 #SCECOLOR #WW #YEN #YPT
  #QRY$ #SWW
  )

  (if (= nil (tblsearch "APPID" "RECT")) (regapp "RECT"))

  ; 収納プランかどうかを判定する
  (if (= CG_UnitCode "D");収納
    (progn
      ; 図形色番号の変更
      (setq #sCECOLOR (getvar "CECOLOR"))
      (setvar "CECOLOR" "50")

      ;奥行き間口から展開B,D領域を求める
      (setq #DD 600);奥行き きめうち

      ;全体間口を求める
      (setq #WW 0.0)
      (foreach #i (list 1 2 3 4 5)
        (setq #sWW (nth (+ (* 100 #i) 55) CG_GLOBAL$));間口
        (if (= nil #sWW)(setq #sWW ""))
        (setq #qry$
          (CFGetDBSQLRec CG_DBSESSION "間口"
            (list (list "間口記号" #sWW 'STR))
          )
        )
        (if #qry$
          (progn
            (setq #WW (+ #WW (nth 2 (car #qry$))))
          )
        );_if

        (setq #sEP (nth (+ (* 100 #i) 71) CG_GLOBAL$));ｴﾝﾄﾞﾊﾟﾈﾙ有無
        (if (and (/= #sEP "N")(/= #sEP "X"))
          (setq #EP 20.0)
          ;else
          (setq #EP 0.0)
        );_if
        (setq #WW (+ #WW #EP))
        (setq #i (1+ #i))
      );foreach

      (setq #LR (nth 60 CG_GLOBAL$));左右基準
      (if (= #LR "LL")
        (progn ;左基準

          (setq #p1 (list 0 0))
          (setq #p2 (list (+ 0 #WW) 0))
          (setq #p3 (list (+ 0 #WW) (- 0 #DD)))
          (setq #p4 (list 0 (- 0 #DD)))

          ;I型領域を囲む領域の点を求める
    ; +p1                    +p2
    ;    @               @
    ;    |               |
    ;    @               @
    ; +p4                    +p3
          (setq #offset 50)
          (setq #pp1 (polar #p1 (dtr 135.) #offset))
          (setq #pp2 (polar #p2 (dtr  45.) #offset))
          (setq #pp3 (polar #p3 (dtr  -45.) #offset))
          (setq #pp4 (polar #p4 (dtr -135.) #offset))

          ;B領域
          (setq #pb1 #pp1)
          (setq #pb4 #pp4)
          ;側面矢視領域は全体 2009/12/10 YM MOD-S
;;;         (setq #pb2 (list (+ (nth 0 #pb1) 100) (nth 1 #pp1)))
;;;         (setq #pb3 (list (+ (nth 0 #pb4) 100) (nth 1 #pp4)))
          (setq #pb2 #pp2)
          (setq #pb3 #pp3)

          ;D領域
          (setq #pd2 #pp2)
          (setq #pd3 #pp3)
          ;側面矢視領域は全体 2009/12/10 YM MOD-S
;;;         (setq #pd1 (list (- (nth 0 #pd2) 100) (nth 1 #pp2)))
;;;         (setq #pd4 (list (- (nth 0 #pd3) 100) (nth 1 #pp3)))
          (setq #pd1 #pp1)
          (setq #pd4 #pp4)
        )
        (progn ;右基準

          (setq #p1 (list (- 0 #WW) 0))
          (setq #p2 (list 0 0))
          (setq #p3 (list 0 (- 0 #DD)))
          (setq #p4 (list (- 0 #WW) (- 0 #DD)))

          ;I型領域を囲む領域の点を求める
    ; +p1                    +p2
    ;    @               @
    ;    |               |
    ;    @               @
    ; +p4                    +p3
          (setq #offset 50)
          (setq #pp1 (polar #p1 (dtr 135.) #offset))
          (setq #pp2 (polar #p2 (dtr  45.) #offset))
          (setq #pp3 (polar #p3 (dtr  -45.) #offset))
          (setq #pp4 (polar #p4 (dtr -135.) #offset))

          ;B領域
          (setq #pb1 #pp1)
          (setq #pb4 #pp4)
          ;側面矢視領域は全体 2009/12/10 YM MOD-S
;;;         (setq #pb2 (list (+ (nth 0 #pb1) 100) (nth 1 #pp1)))
;;;         (setq #pb3 (list (+ (nth 0 #pb4) 100) (nth 1 #pp4)))
          (setq #pb2 #pp2)
          (setq #pb3 #pp3)

          ;D領域
          (setq #pd2 #pp2)
          (setq #pd3 #pp3)
          ;側面矢視領域は全体 2009/12/10 YM MOD-S
;;;         (setq #pd1 (list (- (nth 0 #pd2) 100) (nth 1 #pp2)))
;;;         (setq #pd4 (list (- (nth 0 #pd3) 100) (nth 1 #pp3)))
          (setq #pd1 #pp1)
          (setq #pd4 #pp4)
        )
      );_if

      ; 矢視を配置する点を求める
      (setq #yPt  (polar #p3 (angle #p3 #p4) (/ (distance #p3 #p4) 2.0)))

      ;2011/06/14 YM ADD 隠線されないようにする
      (setq #yPt (list (car #yPt) (- (cadr #yPt) CG_Yashi_OffY) 10000))

      ; 矢視の作図
      (setq #yEn  (SCFDrawYashi "ABD" #yPt "90" CG_YASHI_LAYER))
      (setvar "CECOLOR" "60")

      ; 矢視ＡＢＤの領域作図
      (setq #aEn (MakeLwPolyLine (list #pp1 #pp2 #pp3 #pp4) 1 0))
      (setq #bEn (MakeLwPolyLine (list #pb1 #pb2 #pb3 #pb4) 1 0))
      (setq #dEn (MakeLwPolyLine (list #pd1 #pd2 #pd3 #pd4) 1 0))

      ; 拡張データの付加
      (CFSetXData #yEn "RECT"
        (list
          "0"
          "90"
          "ABD"
          (cdr (assoc 5 (entget #aEn)))
          (cdr (assoc 5 (entget #bEn)))
          (cdr (assoc 5 (entget #dEn)))
        )
      )

      ; システム変数を元に戻す
      (setvar "CECOLOR" #sCECOLOR)
      (command "zoom" "e")
      (command "_REGEN")
    )
  );_if
  (princ)
);KCFAutoMakeDiningPlanYashi_EXTEND

;<HOM>*************************************************************************
; <関数名>    : KCFAutoMakeIgataPlanYashi★
; <処理概要>  : I型プラン用の矢視を自動で作成する
; <戻り値>    : なし
; <作成>      : 08/12/22 YM
; <備考>      : 矢視ABCを作成する
;*************************************************************************>MOH<
(defun KCFAutoMakeIgataPlanYashi (
  /
  #AEN #BEN #DEN #OFFSET #P1 #P2 #P3 #P4 #PG1 #PG2 #PG3 #PG4 #PP1 #PP2 #PP3 #PP4
  #PS1 #PS2 #PS3 #PS4 #PT$ #RET$ #SCECOLOR #SS #X_GAS #X_SNK #YEN #YPT
  )

  (if (= nil (tblsearch "APPID" "RECT")) (regapp "RECT"))

;;;2010/11/18DEL  ; I型プランかどうかを判定する
;;;2010/11/18DEL  (if (= "I00" (nth  5 CG_GLOBAL$))
;;;2010/11/18DEL    (progn

      ;ｼﾝｸ,ｺﾝﾛ配置位置座標
      (setq #ret$ (Get_snk_gas_XY))
      ;ｼﾝｸ配置位置座標
      (setq #X_snk (car  #ret$))
;;;     ;2009/01/10 YM ADD-S　ｼﾝﾎﾞﾙ基準点から少しずらす
;;;     (if (= "R" (nth 11 CG_GLOBAL$))
;;;       (setq #X_snk (+ #X_snk 100))
;;;       ;else
;;;       (setq #X_snk (- #X_snk 100))
;;;     );_if

      ;ｺﾝﾛ配置位置座標
      (setq #X_gas (cadr #ret$))
      ;2009/01/10 YM ADD-S　ｼﾝﾎﾞﾙ基準点から少しずらす 側面図でﾌｰﾄﾞと吊戸両方でてしまうのを避けるため
      (setq #X_gas (+ #X_gas 100))

      (if (and #X_snk #X_gas)
        (progn

          ; 図形色番号の変更
          (setq #sCECOLOR (getvar "CECOLOR"))
          (setvar "CECOLOR" "50")

          (if (= "L" (nth 11 CG_GLOBAL$))
            (progn
              (setq #pt_B #X_snk)
              (setq #pt_D #X_gas)
            )
            (progn
              (setq #pt_B #X_gas)
              (setq #pt_D #X_snk)
            )
          );_if

          (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
          (setq #pt$ (car (car (GetWorkTopArea (ssname #ss 0)))))
          (setq #offset 400)

          ; キッチンI型領域を囲む領域の点を求める
    ; +p1                    +p2
    ;    @               @
    ;    |               |
    ;    @               @
    ; +p4                    +p3
          (setq #p1 (polar (nth 0  #pt$) (dtr 135.) #offset))
          (setq #p2 (polar (nth 1  #pt$) (dtr  45.) #offset))
          (setq #p3 (polar (nth 2  #pt$) (dtr  -45.) #offset))
          (setq #p4 (polar (nth 3  #pt$) (dtr -135.) #offset))

          (setq #pp1 (polar #p1 (dtr 135.) #offset))
          (setq #pp2 (polar #p2 (dtr  45.) #offset))
          (setq #pp3 (polar #p3 (dtr  -45.) #offset))
          (setq #pp4 (polar #p4 (dtr -135.) #offset))

          ;D領域
          (setq #pd1 (list #pt_D (nth 1 #pp1)))
          (setq #pd2 #pp2)
          (setq #pd3 #pp3)
          (setq #pd4 (list #pt_D (nth 1 #pp4)))

          ;B領域
          (setq #pb1 #pp1)
          (setq #pb2 (list #pt_B (nth 1 #pp1)))
          (setq #pb3 (list #pt_B (nth 1 #pp4)))
          (setq #pb4 #pp4)

          ; 矢視を配置する点を求める
          (setq #yPt  (polar #p3 (angle #p3 #p4) (/ (distance #p3 #p4) 2.0)))

          ; 矢視の作図
          (setq #yEn  (SCFDrawYashi "ABD" #yPt "90" CG_YASHI_LAYER))
          (setvar "CECOLOR" "60")

          ;矢視A
          (setq #offset2 200)
          (setq #pA1 (polar #p1 (dtr 135.) #offset2))
          (setq #pA2 (polar #p2 (dtr  45.) #offset2))
          (setq #pA3 (polar #p3 (dtr  -45.) #offset2))
          (setq #pA4 (polar #p4 (dtr -135.) #offset2))

          ; 矢視ＡＢＤの領域作図
          (setq #aEn (MakeLwPolyLine (list #pA1 #pA2 #pA3 #pA4) 1 0))
          (setq #bEn (MakeLwPolyLine (list #pb1 #pb2 #pb3 #pb4) 1 0))
          (setq #dEn (MakeLwPolyLine (list #pd1 #pd2 #pd3 #pd4) 1 0))

          ; 拡張データの付加
          (CFSetXData #yEn "RECT"
            (list
              "0"
              "90"
              "ABD"
              (cdr (assoc 5 (entget #aEn)))
              (cdr (assoc 5 (entget #bEn)))
              (cdr (assoc 5 (entget #dEn)))
            )
          )
          (command "zoom" "e")
          (command "_REGEN")
          ; システム変数を元に戻す
          (setvar "CECOLOR" #sCECOLOR)
        )
      );_if

;;;2010/11/18DEL    )
;;;2010/11/18DEL  );_if
  (princ)
);KCFAutoMakeIgataPlanYashi★

;<HOM>*************************************************************************
; <関数名>    : KCFAutoMakeTaimenPlanYashi
; <処理概要>  : 対面プラン用の矢視を自動で作成する
; <戻り値>    : なし
; <作成>      : 04/04/13 SK
; <備考>      : 矢視ＡＢＤ及び追加矢視Ｅを作成する
;*************************************************************************>MOH<
(defun KCFAutoMakeTaimenPlanYashi (
  /
  #ss
  #pt$
  #offset
  #p1 #p2 #p3 #p4            
  #yPt #yePt                 ;矢視基点
  #yEn #yeEn                 ;矢視図形
  #aEn #bEn #cEn #dEn #eEn   ;矢視領域図形
  #sfpType                   ;対面フラットプランのタイプ
  #sCECOLOR                  ;現在色
  )

  (if (= nil (tblsearch "APPID" "RECT")) (regapp "RECT"))

;;;2010/11/18DEL  ; 対面プランかどうかを判定する
;;;2010/11/18DEL  (setq #sfpType (SCFIsTaimenFlatPlan))
;;;2010/11/18DEL  (if #sfpType
;;;2010/11/18DEL    (progn


      ; 図形色番号の変更
      (setq #sCECOLOR (getvar "CECOLOR"))
      (setvar "CECOLOR" "50")

      ; 対面プランは矢視自動矢視ＡＢＤＥとする
      (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
      (setq #pt$ (car (car (GetWorkTopArea (ssname #ss 0)))))

      ;2009/04/21 YM ADD if文追加
      (if (wcmatch (nth  5 CG_GLOBAL$) "G*" )
        (setq #offset 820);ｹﾞｰﾄﾀｲﾌﾟ
        ;else
        (setq #offset 400);従来
      );_if

      ; キッチン領域を囲む領域の点を求める
      (setq #p1 (polar (car    #pt$) (dtr 135.) #offset))
      (setq #p2 (polar (cadr   #pt$) (dtr  45.) #offset))

      ;2008/08/13 YM DEL
;;;      (if (= #sfpType "SF")
;;;        (progn
;;;          (setq #p1 (list (car #p1) (+ (cadr #p1) 600.)))
;;;          (setq #p2 (list (car #p2) (+ (cadr #p2) 600.)))
;;;        )
;;;      );_if

      (setq #p3 (polar (caddr  #pt$) (dtr  -45.) #offset))
      (setq #p4 (polar (nth 3  #pt$) (dtr -135.) #offset))

      ; 矢視を配置する点を求める
      (setq #yPt  (polar #p3 (angle #p3 #p4) (/ (distance #p3 #p4) 2.0)))
      (setq #yePt (polar #p1 (angle #p1 #p2) (/ (distance #p1 #p2) 2.0)))

      ; 矢視の作図
      (setq #yEn  (SCFDrawYashi "ABD" #yPt "90" CG_YASHI_LAYER))
      (setq #yeEn (SCFDrawYashi "E" #yePt "0" CG_YASHI_LAYER))

      (setvar "CECOLOR" "60")

      ; 矢視ＡＢＤの領域作図
      (setq #aEn (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))
      (setq #bEn (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))
      (setq #dEn (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))

      ; 矢視Ｅの領域作図
      (setq #eEn (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))

      ; 拡張データの付加
      (CFSetXData #yEn "RECT"
        (list
          "0"
          "90"
          "ABD"
          (cdr (assoc 5 (entget #aEn)))
          (cdr (assoc 5 (entget #bEn)))
          (cdr (assoc 5 (entget #dEn)))
        )
      )
      ; 矢視Ｅの領域作図
      (CFSetXData #yeEn "RECT"
        (list
          "0"
          "0"
          "E"
          (cdr (assoc 5 (entget #eEn)))
        )
      )
      ; システム変数を元に戻す
      (setvar "CECOLOR" #sCECOLOR)
      (command "zoom" "e")
      (command "_REGEN")


;;;2010/11/18DEL    )
;;;2010/11/18DEL  );_if

  (princ)
);KCFAutoMakeTaimenPlanYashi


;<HOM>*************************************************************************
; <関数名>    : Get_snk_gas_XY
; <処理概要>  : ｼﾝｸ,ｺﾝﾛの配置位置座標を求める
; <戻り値>    : ｼﾝｸ,ｺﾝﾛの配置位置座標
; <作成>      : 08/12/23 YM
; <備考>      : 矢視領域作成に使用する
;*************************************************************************>MOH<
(defun Get_snk_gas_XY (
  /
  #GASX #I #PT #RET$ #SEIKAKU #SNKX #SS_LSYM #SYM #XD-LSYM$
  )
  (setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM"))))) ; G_LSYM 図形選択ｾｯﾄ
  (if (and #ss_LSYM (< 0 (sslength #ss_LSYM)))
    (progn
      (setq #i 0)
      (setq #snkX nil)
      (setq #gasX nil)
      (repeat (sslength #ss_LSYM)
        (setq #sym (ssname #ss_LSYM #i))
        (setq #pt (cdr (assoc 10 (entget #sym))))
        (setq #xd-lsym$ (CFGetXData #sym "G_LSYM"))
        (setq #seikaku  (nth 9 #xd-lsym$)) ;性格CODE
;;;       ;2009/01/10 YM MOD-S
;;;       (if (= #seikaku CG_SKK_INT_SNK);ｼﾝｸ
        (if (= #seikaku CG_SKK_INT_SCA);ｼﾝｸｷｬﾋﾞ
          (progn
            (setq #snkX (car #pt));ｼﾝﾎﾞﾙ基点X座標

            (if (= "R" (nth 11 CG_GLOBAL$))
              (progn ;右勝手時ｼﾝｸｷｬﾋﾞｼﾝﾎﾞﾙ基点+50mm右側
                (setq #snkX (+ #snkX 50))
              )
              (progn ;左勝手時ｼﾝｸｷｬﾋﾞｼﾝﾎﾞﾙ基点+寸法W値右側
                ;寸法W値
                (setq #WW (nth 3 (CFGetXData #sym "G_SYM"))) ; 寸法W
                (setq #snkX (+ #snkX #WW))
                (setq #snkX (- #snkX 50))
              )
            );_if

          )
        );_if

        (if (= #seikaku CG_SKK_INT_GAS);210ｶﾞｽｺﾝﾛ
          (setq #gasX (car #pt))
        );_if
        (setq #i (1+ #i))
      );repeat
    )
  );_if
  (setq #ret$ (list #snkX #gasX))
  #ret$
);Get_snk_gas_XY

;<HOM>*************************************************************************
; <関数名>    : SCFWFModGLSymPosAngle
; <処理概要>  : G_LSYMの配置基点を現在の基点の位置に修正する。
; <戻り値>    : なし
; <備考>      : nil
;*************************************************************************>MOH<
(defun SCFWFModGLSymPosAngle (
  /
  #ss
  #en
  #xd$
  #bpt
  #angle
  )
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (foreach #en (Ss2En$ #ss)
    (setq #bpt (cdrassoc 10 (entget #en)))
    (setq #xd$ (CFGetXData #en "G_LSYM"))
    (setq #angle (nth 2 #xd$))
    (while (or (equal #angle (* PI 2) 0.001) (> #angle (* PI 2)))
      (setq #angle (- #angle (* PI 2)))
    )
    (while (and (not (equal #angle 0.0 0.001)) (< #angle 0.0))
      (setq #angle (+ #angle (* PI 2)))
    )
    (CFSetXData #en "G_LSYM"
      (CFModList #xd$
        (list (list 1 #bpt) (list 2 #angle))
      )
    )
  )
)
;SCFWFModGLSymPos








;<HOM>*************************************************************************
; <関数名>    : SCFMakeMaterialArx
; <処理概要>  : 展開元図作成メイン処理(ARX対応版)
; <戻り値>    : なし
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCFMakeMaterialArx (
  /
  #clayer #cecolor #osmode
  #kind$$ #kind$ #ang$ #DclRet$
  #Skind$ #ssD #save
  #msg      ; 03/06/10 YM ADD
  #sView    ; 図面種類
  #pCrtFlg  ; 平面図作成フラグ
  #eCrtFlg  ; 展開図作成フラグ
  #xSp
  #ZoomArea #PtS #PtE #cArea  ;;  2005/12/07 G.YK ADD
  )
  ;;  2005/12/07 G.YK ADD-S
  (defun ##NormYashi (
      &cArea &tArea
      /
      #cArea #cPtS #cPtE #cU #cD #cL #cR
      #tArea #tPtS #tPtE #tU #tD #tL #tR
      )
      (setq #cPtS (car &cArea))
      (setq #cPtE (cadr &cArea))
      (setq #cL (min (car #cPtS)(car #cPtE)))
      (setq #cR (max (car #cPtS)(car #cPtE)))
      (setq #cD (min (cadr #cPtS)(cadr #cPtE)))
      (setq #cU (max (cadr #cPtS)(cadr #cPtE)))

      (setq #tPtS (car &tArea))
      (setq #tPtE (cadr &tArea))
      (setq #tL (min (car #tPtS)(car #tPtE)))
      (setq #tR (max (car #tPtS)(car #tPtE)))
      (setq #tD (min (cadr #tPtS)(cadr #tPtE)))
      (setq #tU (max (cadr #tPtS)(cadr #tPtE)))

      (if (< #tU #cU)(progn
        nil
      )(progn
        (setq #tU (+ #cU 150))
        (setq #cU #tU)
      ))
      (if (< #tL #cL)(progn
        (setq #tL (- #cL 150))
        (setq #cL #tL)
      )(progn
        nil
      ))
      (if (< #tR #cR)(progn
        nil
      )(progn
        (setq #tR (+ #cR 150))
        (setq #cR #tR)
      ))
      (if (< #tD #cD)(progn
        (setq #tD (- #cD 150))
        (setq #cD #tD)
      )(progn
        nil
      ))

      (setq #cPtS (list #cL #cU))
      (setq #cPtE (list #cR #cD))
      (setq #cArea (list #cPtS #cPtE))

      (setq #tPtS (list #tL #tU))
      (setq #tPtE (list #tR #tD))
      (setq #tArea (list #tPtS #tPtE))

      (list #cArea #tArea)
  )
  ;;  2005/12/07 G.YK ADD-E

  (WebOutLog "展開元図作成メイン処理(SCFMakeMaterialArx)")
; T.Ari Add Start lispで作図側からコピー
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
    (progn
      ; 自動ﾓｰﾄﾞのとき"MODEL.DWG"を破棄終了して"MODEL.DWG"をOPENできないため名前を変えて保存しておく
      ; 破棄終了しないとコンロの絵や扉が消えてしまう
;;;     (command ".qsave") ; 101/10/01 YM MOD
;;;     (if (findfile (strcat CG_SYSPATH "auto.dwg")) ; 01/10/02 YM ADD-S
      ;06/06/16 AO MOD 保存形式を2004に変更
      ;(command "_saveas" "2000" (strcat CG_SYSPATH "auto.dwg"))
;-- 2011/10/06 A.Satoh Mod - S
;;;;;      (command "_saveas" CG_DWG_VERSION (strcat CG_SYSPATH "auto.dwg"))
      (command "_saveas" CG_DWG_VER_MODEL (strcat CG_SYSPATH "auto.dwg"))
;-- 2011/10/06 A.Satoh Mod - E
    )
    (CFAutoSave)
  );_if
  ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞでは保存しない
; T.Ari Add End

;-- 2011/09/27 A.Satoh Add - S
  ; 施工図出し分けを行う
  (if (SCF_SekouLayer)
    (progn
;-- 2011/09/27 A.Satoh Add - E

  ; 06/09/20 T.Ari ADD 基点座標をG_LSYMに設定しなおし
  (SCFWFModGLSymPosAngle)

  (CFNoSnapReset);00/08/25 SN ADD


;| T.Ari Del Start タカラ専用処理
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3))
    ;自動作図モードでは、矢視関連の前処理を行い一旦保存する
    (progn
      ;矢視の入力情報を取得する
      (setq CG_SKViewList (##CFgetiniCountList "SK_VIEW" "COUNT" "VIEW" 2))
      ;パースビューの作成
      (KCFMakeModelPersView)

    ;;  2005/12/07 G.YK ADD-S
      (SetLayer_sub "N_YASHI*"  "OF"  "F")
      (SetLayer_sub "G_RM*"  "OF"  "F")
      (command "zoom" "e")
      (setq #ZoomArea (list (getvar "EXTMIN")(getvar "EXTMAX")))
      (princ "\n aaa1")
      (princ "\nズーム領域: ")(princ #ZoomArea)
      (SetLayer_sub "N_YASHI*"  "ON"  "T")
      (SetLayer_sub "G_RM*"  "ON"  "T")

      (setq #PtS (car #ZoomArea))
      (setq #PtE (cadr #ZoomArea))
      (setq #cArea (list
          (list (car #PtS)(cadr #PtE))
          (list (car #PtE)(cadr #PtS))
      ))
    ;;  2005/12/07 G.YK ADD-E

      ;パース矢視を自動作成する（最終図面には保存しないため、上記で図面を保存してから）
    ;;(KCFAutoMakeSKViewYashiPers)  ;;  2005/12/07 G.YK DEL
      (setq #cArea (KCFAutoMakeSKViewYashiPers ##NormYashi #cArea)) ;;  2005/12/07 G.YK ADD

      ;パース以外の矢視を自動作成する
    ;;(KCFAutoMakeSKViewYashi)  ;;  2005/12/07 G.YK DEL
      (setq #cArea (KCFAutoMakeSKViewYashi ##NormYashi #cArea)) ;;  2005/12/07 G.YK ADD

      ;一旦図面を保存する
      (CFQSave)

      ; 自動ﾓｰﾄﾞのとき"MODEL.DWG"を破棄終了して"MODEL.DWG"をOPENできないため名前を変えて保存しておく
      ; 破棄終了しないとコンロの絵や扉が消えてしまう
      (command "_saveas" CG_DWG_VERSION (strcat CG_SYSPATH "auto.dwg"));04/08/12 YM MOD 2000==>2004
    )
  ;else
    ;カスタムTOP編集モードでは一旦保存する
    (progn
      (CFAutoSave)
    )
  );_if

  ;;; 04/04/14 SK DELL-S 見積処理は後で行う
  ;;;自動モードの時は先に見積り情報を更新しておく
  ;;;(if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
  ;;;  (progn
  ;;;    (SCFMakeBlockTable)    ;;  2005/04/12 G.YK ADD
  ;;;    (PKC_MitumoriPreSelect)  ;;  2005/04/12 G.YK ADD
  ;;;  )
  ;;;)
  ;;; 04/04/14 SK DELL-E 見積処理は後で行う

  ;--------------------------------------------------------------------------
  ;図面図作成用に図面を補正する
  ; (★重要)ここで変換されたデータは、展開図終了後に元の図面には影響しない
  ;--------------------------------------------------------------------------
  (SCFConvertMaterialDwg)
|; ; T.Ari Del End
  (setvar "CLAYER"    "0")
  (setvar "CECOLOR"   "BYLAYER")
  (setvar "OSMODE"    0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "SNAPMODE"  0)
  (command "_.SHADEMODE" "2D")  ;ワイアフレーム表示（速度向上）

  ; 矢視領域判定変更
  (setq CG_UTypeWT nil)
  (setq CG_TABLE nil)

  ; 矢視図形を取得する
  (setq #xSp (ssget "X" (list (list -3 (list "RECT")))))

  ; EF矢視があるのにABCD矢視がない場合は作図しない
  (if (and (SCFIsYashiType #xSp "*[EF]*") (not (SCFIsYashiType #xSp "*[ABCD]*")))
    (progn
      (CFAlertErr (strcat "ABCD矢視がありません.\n"
                          "矢視設定でABCD矢視を作成して下さい"))
    )
    (progn

      ;展開図作成の際には未配置部材をワークに移す
      ; -> 見積情報作成の際に元に戻す
      ; T.Ari コメント化
;     (SCFCnvWNSymbolApp CG_WG_WORK_CONVERT)

      ; ダミー領域設定
      (WebOutLog "ダミー領域設定(SetDummyArea)")
      (SetDummyArea)   ;ダミー領域設定

      ; データ獲得
      (setq #kind$$ (GetMaterialData))
      (if (/= nil #kind$$)
        (progn
          (setq #kind$  (car  #kind$$))
          (setq #ang$   (cadr #kind$$))

          (if (/= CG_OUTCMDNAME "SCFLayPrs")
            (progn

;2011/07/22 YM MOD-S ﾀﾞｲｱﾛｸﾞ表示しない
;;;              ; 自動ﾓｰﾄﾞではﾀﾞｲｱﾛｸﾞ表示しない
;;;              (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;;                (setq #DclRet$ CG_AUTOMODE_TENKAI)
;;;                (setq #DclRet$ (SCFGetBlockKindDlg (mapcar 'car #kind$)))
;;;              );_if
              (setq #DclRet$ CG_AUTOMODE_TENKAI)
;2011/07/22 YM MOD-S ﾀﾞｲｱﾛｸﾞ表示しない

            )
            (progn
              ; パース元図自動作成レイアウトの時
              ; 平面図が選択された状態とする
              (setq #DclRet$ (list (list 1 0 0) (list "0")))
            )
          )

          ; 展開図作成チェック
          ; 図面作成用データを
          ;   ((平面図用データ) (展開図用データのリスト) 仕様図作成有無)のリストに整理する
          (setq #Kind$ (SCFCheckExpand #kind$ #DclRet$))
          (if (/= nil #Kind$)
            (progn
              ;; 確認ダイアログ表示
              (KPfDelBlockDwg)

              (princ "\n展開図作成中…\n")

              ;// 特注ワークトップ情報
              (PKOutputWTCT)

              ; 展開元図用画層がフリーズorロックされていたら解除する
              ; 展開元図用画層が作成されている(本来ありえない?)場合の対応
              (SCF_LayDispOn
                (list "0_door" "0_plane" "0_dim" "0_plin_1" "0_plin_2" "0_pers"
                      "0_side_A" "0_side_B" "0_side_C" "0_side_D" "0_side_E" "0_side_F"
                      "0_side_G" "0_side_H" "0_side_I" "0_side_J" "0_kutai"
                )
              )

              ;----------------------------------------------------------
              ; ARX 展開図作成
              ;----------------------------------------------------------

              ;パース全体分も作成する
;-- 2012/01/27 A.Satoh Mod (元に戻す）- S
;-- 2011/07/11 A.Satoh Mod - S
;;;;              (command "SCFMakeExpandAll" 1 0 0)
              (command "SCFMakeExpandAll" 1 nil nil)
;-- 2011/07/11 A.Satoh Mod - E
;-- 2012/01/27 A.Satoh Mod (元に戻す）- E
;2009/04/20 YM
;;;              (if (= CG_ARX_DEPLOY_RET 0)
;;;                (progn
;;;                  (CFAlertMsg "展開図作成に失敗しました")
;;;                  (setq #Kind$ nil)
;;;                )
;;;              )

              ; ダミー領域再作成
              ; 領域にはいらないシンボルも存在するため、そのシンボルをダミー領域にいれてしまう
              (setq #ssD (ssget "X" (list (cons 0 "LWPOLYLINE")(list -3 (list "G_SKDM")))))

              (SetDummyAgain #ssD nil)

              ; 平面図作成有無
              (if (/= nil (nth 0 #kind$))
                (setq #pCrtFlg 1)     ; 平面図作成フラグ
              )
              ; 展開図作成有無
              (if (/= nil (nth 1 #kind$))
                (progn
                  ; 展開図を作成するときは、扉をはっておく
                  ; グローバル格納された扉情報は、ARXの展開図作成処理へ引き継がれる
                  ; CG_DOORLST
                  (AlignDoorBySym$ (mapcar 'cadr (nth 1 #kind$)))

                  ;// 展開図作成フラグ
                  (setq #eCrtFlg 1)
                )
              )
              ;-- 仕様図を作成するか？
              (if (/= nil (nth 2 #kind$))
                (progn
                  ;ローカルモードの時はダイアログチェック情報を元に見積処理を実行する
                  ;;;(if (= CG_AUTOMODE 0)
                  ;;;  (progn
                      ;見積情報作成の際には未配置部材の情報を元に戻す
                      ; T.Ari コメント化
;                     (SCFCnvWNSymbolApp CG_WG_REAL_CONVERT)

                      (princ "\n仕様図作成中…\n")
                      (WebOutLog "仕様図作成中…")
                      (SCFMakeBlockTable)         ; 仕様書 古いタイプのTable.cfg出力しない  ;;  2005/04/12 G.YK DEL
                      ; T.Ari コメント化
;                     (PKC_MitumoriPreSelect) ;;  2005/02/21 G.YK ADD ;;  2005/04/12 G.YK DEL
                      (setq CG_TABLE T)           ; Table.cfg作成ﾌﾗｸﾞ 01/02/07 YM
                  ;;; )
                  ;;;)
                )
              )
              ; DEBUG 展開図 ARX対応
              ;(if (CFYesNoDialog "\n処理をとめますか")
              ;  (progn
              ;    (setq *error* nil)
              ;    (*error*)
              ;  )
              ;-- 展開図作成処理　ARX対応処理部
              (if (or #eCrtFlg #pCrtFlg)
                (progn
                  (princ "\n展開図作成中…\n")

                  (WebOutLog "展開図作成中…")

                  ;; 04/04/14 SK ADD-S
                  ;展開図ＡＲＸ処理直前にワーク系の画層の図形を消しておく
                  ; T.Ari コメント化
;                 (SCFEraseWorkEnt)
                  ;; 04/04/14 SK ADD-E

                  ; T.Ari コメント化
;                 (SCFChgCutWtBasePolyline)

                  ;----------------------------------------------------------
                  ; ARX 展開図作成
                  ;----------------------------------------------------------
;-- 2012/01/27 A.Satoh Mod (元に戻す) - S
									;2012/01/17 YM MOD -S TSにあわせる
                  (command "SCFMakeExpandAll" 0 #pCrtFlg #eCrtFlg)
;;;;;									(command "SCFMakeExpandAll" #pCrtFlg #pCrtFlg #eCrtFlg)
									;2012/01/17 YM MOD -E TSにあわせる
;-- 2012/01/27 A.Satoh Mod (元に戻す) - E


									;2012/01/17 YM MOD -S TSからｺﾋﾟｰして追加
                  ;パース全体分も作成する
                  (if (ssget "X" '((-3 ("RECTPERS"))))
                    (progn
                      (command "_.ERASE" (ssget "X" '((-3 ("RECTPERS")))) "")
                      (command "SCFMakeExpandAll" 1 nil nil)
                    )
                  )
                  (if (= CG_ARX_DEPLOY_RET 0)
                    (progn
                      (CFAlertMsg "展開図作成に失敗しました")
                      (setq #Kind$ nil)
                    )
                  )
									;2012/01/17 YM MOD -E TSからｺﾋﾟｰして追加

                )
              );_if

              (princ "\n展開図作成中…終了")
              (WebOutLog "展開図作成中…終了")
              (setq #save T)
            )
          );_if (/= nil #Kind$)
        )
      )
    )
  )

  ; (扉処理用のフラグクリア)
  (setq CG_OUTCMDNAME nil)
;-- 2011/09/27 A.Satoh Add - S
    )
  )
;-- 2011/09/27 A.Satoh Add - E

  ;戻り値
  #Kind$
)
; SCFMakeMaterialArx

;<HOM>*************************************************************************
; <関数名>    : SCFModYoutoLayer
; <処理概要>  : 用途変換
; <戻り値>    : なし
; <備考>      :
;*************************************************************************>MOH<
(defun SCFModYoutoLayer (
  /
  #yid #toks #tokn
  #tokuseichi$$
  #tdata #tid #tval$ #tval
  #rec$$ #i #f #tid #modlist$
  #zlay #zlay$ #zlay1$ #zlay2$
  #eLay #eg$ #ss #ylay #vlay #zlaynew
  )
  (setq #yid 1)
  (setq #toks 2 #tokn 6)
  
  (setq #tokuseichi$$ (SCFGetTokuseichi))
  (if #tokuseichi$$
    (progn
      (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION "SELECT * FROM ST施工表示"))
      (foreach #rec$ #rec$$
        (setq #i 0 #f T)
        (while (and #f (< #i #tokn) (setq #tid (nth (+ (* #i 2) #toks) #rec$)))
          (setq #tdata$ (assoc #tid (nth 0 #tokuseichi$$)))
          (if (not #tdata$)
            (setq #tdata$ (assoc #tid (nth 1 #tokuseichi$$)))
          )
          (setq #tval$ (strparse (nth (+ (* #i 2) #toks 1) #rec$) ","))
          (if (or (not #tdata$) (not (member (nth 1 #tdata$) #tval$)))
            (setq #f nil)
          )
          (setq #i (1+ #i))
        )
        (if #f (setq #modlist$ (cons (nth #yid #rec$) #modlist$)))
      )
      (setq #zlay$ (SCFGetZLayer))
      (foreach #zlay #zlay$
        (setq #ylay (itoa (atoi (substr #zlay 9 2))))
        (cond
          ((= #ylay "0")
            nil
          )
          ((member #ylay #modlist$)
            (setq #zlay1$ (cons #zlay #zlay1$))
          )
          (T
            (setq #zlay2$ (cons #zlay #zlay2$))
          )
        )
      )
      (foreach #zlay #zlay2$
        (setq #ylay (itoa (atoi (substr #zlay 9 2))))
        (setq #rec$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "SELECT 画層番号 FROM 用途名称 WHERE 用途番号 = " #ylay )))
        (if (and #rec$$ (or (not (car (car #rec$$))) (equal (car (car #rec$$)) 0.0 0.01)))
          (progn
            (setq #ss (ssget "X" (list (cons 8 #zlay))))
            (if (and #ss (< 0 (sslength #ss)))
              (command "_.erase" #ss "")
            )
            (setq #eLay (tblobjname "LAYER" #zlay))
            (entdel #eLay)
          )
        )
      )
      (foreach #zlay #zlay1$
        (setq #ylay (itoa (atoi (substr #zlay 9 2))))
        (setq #vlay (itoa (atoi (substr #zlay 3 2))))
        (setq #rec$$ (DBSqlAutoQuery CG_CDBSESSION (strcat "SELECT 変換後用途 FROM 用途変換 WHERE 用途番号 = " #ylay " AND 視点区分 = " #vlay "")))
        (if #rec$$
          (progn
      (setq #ylay (itoa (fix (car (car #rec$$)))))
            (setq #zlaynew (strcat (substr #zlay 1 8) (if (= 1 (strlen #ylay)) "0" "") #ylay (substr #zlay 11)))
            (MakeLayer #zlaynew 7 "CONTINUOUS")
            (setq #ss (ssget "X" (list (cons 8 #zlay))))
            (if (and #ss (< 0 (sslength #ss)))
              (progn
                (setq #i 0)
                (repeat (sslength #ss)
                  (setq #eg$ (entget (ssname #ss #i)))
                  (entmod (subst (cons 8 #zlaynew) (assoc 8 #eg$) #eg$))
                  (setq #i (1+ #i))
                )
              )
            )
            (setq #eLay (tblobjname "LAYER" #zlay))
            (entdel #eLay)
          )
        )
      )
    )
  )
  T
)
;SCFChgCutWtBasePolyline


;<HOM>*************************************************************************
; <関数名>    : SCFWFBowlCabSetHeight
; <処理概要>  : 洗面ボウルキャビの高さを変更する（７５０固定）
; <戻り値>    : なし
; <備考>      : nil
;*************************************************************************>MOH<
(defun SCFWFBowlCabSetHeight (
  /
  #qry$
  #qry2$
  #skk$
  #ss
  #en
  #xd$
  #tkr$
  #wth
  )
  ; ユニット記号を取得する
  (setq #qry$
    (CFGetDBSQLRec CG_CDBSESSION "SERIES"
      (list
        (list "SERIES名称" CG_SeriesDB   'STR)
        (list "SERIES記号" CG_SeriesCode 'STR)
      )
    )
  )

;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #qry$)
;;;		;ｼﾘｰｽﾞ別DB,共通DB再接続
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E


  ;洗面の場合
  (if (or (= "S" (nth 3 (car #qry$))) (= "M" (substr (nth 0 (car #qry$)) 1 1)))
    (progn
      (setq #tkr$ (CFGetXRecord "TKR"))
      (if #tkr$
        (setq #wth (nth 0 #tkr$))
        (setq #wth CG_WFBowlCabHeight)
      )
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (foreach #en (Ss2En$ #ss)
        (setq #skk$ (CFGetSymSKKCode #en nil))
        (if (and
              (= (car #skk$) CG_SKK_ONE_CAB)
              (= (cadr #skk$) CG_SKK_TWO_BAS)
              (or
                (= (caddr #skk$) CG_SKK_THR_NRM)
                (= (caddr #skk$) CG_SKK_THR_SNK)
                (= (caddr #skk$) CG_SKK_THR_GAS)
                (= (caddr #skk$) CG_SKK_THR_CNR)
              )
            )
          (progn
            (setq #xd$ (CFGetXData #en "G_LSYM"))
            (CFSetXData #en "G_LSYM"
              (CFModList #xd$
                (if (= "S" (nth 3 (car #qry$)))
                  (progn
                    (if (= CG_CDBSESSION nil) (setq CG_DBSESSION (DBConnect CG_DBNAME "" "")))
                    (setq #qry2$
                      (CFGetDBSQLRec CG_CDBSESSION "拡張処理" 
                          (list (list "機能名" "wfbch" 'STR)
                                (list "項目１" (nth 5 #xd$) 'STR)
                          )
                      )
                    )
                    (if #qry2$
                      (list (list 13 (atoi (nth 3 (car #qry2$)))))
                      (list (list 13 (- #wth (nth 2 (nth 1 #xd$)))))
                    )
                  )
                  (list (list 13 CG_KSetBGCabHeight))
                )
              )
            )
          )
        )
      )
    )
  )
)
;SCFWFBowlCabSetHeight


;<HOM>*************************************************************************
; <関数名>    : SCFConvertMaterialDwg
; <処理概要>  : 展開図前に図形データを正規化する
; <戻り値>    : なし
; <備考>      : (★重要)ここで変換されたデータは、展開図終了後に
;                       元の図面を開きなおすため影響されない
;*************************************************************************>MOH<
(defun SCFConvertMaterialDwg (
  )
  ; ダミー領域が不正に残っていれば削除
  (DelDummyArea)

  ;;; 04/04/14 TM DEL-S
  ;;;ここでの処理は展開図ＡＲＸ呼び出し直前に呼び出す
  ;;;未配置部材をワークに移す
  ;;;(SCFEraseWorkEnt)
  ;;;(SCFCnvWNSymbolApp CG_WG_WORK_CONVERT)
  ;; 04/04/14 TM DEL-E

  (SCFWFModGLSymPosAngle)
;  (SCFWFModGWrktPos)
  
  ;キッチンパネルのサイズ情報を設定しなおす
  (SCFCnvKPSymbolWDH)

  ;矢視領域をずらす(ARX不具合の調整）
  ;内外判定処理で領域の基点とシンボルの基点が延長線上でも範囲内と
  ;みなしてしまうため、こちらでずらす
  (SCFMoveRectArea)

  ;洗面のボウルキャビがあれば高さを750にする
  (SCFWFBowlCabSetHeight)

  ;TAKARA用天井フィラーの拡張データの性格コードをアッパー部材とする
  (SCFCnvFilerSymbol)

  ;コーナートールキャビの性格コードを変更する
  (SCFCnvSkkCnrTallCab)

  ;サイドパネルの性格コードを変更する
  (SCFCnvSkkSidePanel)

  (SCFWtCut)
  
  (SCFModYoutoLayer)

)
;SCFConvertMaterialDwg

;<HOM>*************************************************************************
; <関数名>    : SCFCnvKPSymbolWDH
; <処理概要>  : キッチンパネル、躯体のサイズ情報を設定しなおす
; <戻り値>    : なし
; <備考>      : G_SYM(W,D,H) <- SK_KP(W,D,H)
;*************************************************************************>MOH<
(defun SCFCnvKPSymbolWDH (
  /
  #ss
  #en
  #kpXd$ #symXd$
  #w #d #h
  )
  ;キッチンパネルのW,D,Hを入れ替える
  (setq #ss (ssget "X" '((-3 ("SK_KP,SK_KUTAI")))))
  (foreach #en (Ss2En$ #ss)
    (setq #kpXd$  (CFGetXData #en "SK_KP"))
    (if (= #kpXd$ nil)
      (progn
        (setq #kpXd$  (CFGetXData #en "SK_KUTAI"))
        (setq #kpXd$ (list (nth 0 #kpXd$) (* (nth 1 #kpXd$) -1) (nth 2 #kpXd$)))
      )
    )
    (setq #symXd$ (CFGetXData #en "G_SYM"))
    (setq #w (nth 0 #kpXd$))
    (setq #d (nth 1 #kpXd$))
    (setq #h (nth 2 #kpXd$))
    (if #symXd$
      (progn
        ;// 拡張データの更新
        (CFSetXData #en "G_SYM"
          (CFModList #symXd$
            (list (list 3 #w)(list 4 #d)(list 5 #h))
          )
        )
      )
    )
  )
)
;SCFCnvKPSymbolWDH

;<HOM>*************************************************************************
; <関数名>    : SCFMoveRectArea
; <処理概要>  : 矢視領域をずらす
; <戻り値>    : なし
; <備考>      : 矢視領域をずらす(ARX不具合の調整）
;                内外判定処理で領域の基点とシンボルの基点が延長線上でも範囲内と
;                みなしてしまうため、こちらでずらす
;                0.5ずつずらしているので、他の部材の基点とあたる事は
;                まずないと思われるが 時期を見てARXの改修が必要
;*************************************************************************>MOH<
(defun SCFMoveRectArea (
  /
  #ss
  )
  (setq #ss (ssget "X" '((8 . "N_YASHI_AREA"))))
  (if #ss
    (command "_.MOVE" #ss "" (list 0 0 0) (list 0.5 0.5 0))
  )
)
;SCFMoveRectArea

;<HOM>*************************************************************************
; <関数名>    : SCFCnvFilerSymbol
; <処理概要>  : 天井フィラー部材に G_FILR 拡張データをダミー設定する
; <戻り値>    : なし
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCFCnvFilerSymbol (
  /
  #ss
  #en
  #xd$
  #filrSkk
  #en$
  )
  ;天井フィラーの性格コード
  (setq #filrSKK 920)

  ;キッチンパネルのW,D,Hを入れ替える
  (setq #ss (ssget "X" '((-3 ("G_TAKARA")))))
  (foreach #en (Ss2En$ #ss)
    (setq #xd$ (CFGetXData #en "G_TAKARA"))
    (if (= (nth 1 #xd$) 16)
      (progn
        (setq #xd$ (CFGetXData #en "G_LSYM"))
        ;// 拡張データの更新
        (CFSetXData #en "G_LSYM"
          (CFModList #xd$
            (list (list 9 #filrSkk))
          )
        )
      )
    )
  )
)
;SCFCnvFilerSymbol


;<HOM>*************************************************************************
; <関数名>    : SCFCnvSkkCnrTallCab
; <処理概要>  : コーナートールキャビの性格コードを変更する
; <戻り値>    : なし
; <備考>      : 性格コード 915 -> 117 に変更する
;             : 左勝手のコーナートールキャビは、下記処理を行う
;                 基点を左上から左下
;                 角度+90度
;                 W <-> D の変換
;*************************************************************************>MOH<
(defun SCFCnvSkkCnrTallCab (
  /
  #ss
  #en
  #skk$
  #lXd$
  #sXd$
  #w #d
  #ang
  #p1 #p2
  #eg
  #subLay1 #subLay2
  #gEn$
  #lay
  )
  (princ "\n一時的にコーナートールキャビの性格コードを変換します")
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (foreach #en (Ss2En$ #ss)

    (setq #skk$ (CFGetSymSKKCode #en nil))
    ;コーナートールキャビの場合
    (if (or (equal #skk$ (list 9 1 5)) (equal #skk$ (list 9 2 5)))
      (progn
        (setq #lXd$ (CFGetXData #en "G_LSYM"))
        (setq #sXd$ (CFGetXData #en "G_SYM"))

        ;性格コードの再設定
        (CFSetXData #en "G_LSYM"
          (CFModList #lXd$
            (list
              (list 9 (+ 107 (* (nth 1 #skk$) 10)))
            )
          )
        )
        ;コーナートールキャビのＬ型の時、登録上Ｗ，Ｄが入れ替えられているため、
        ;寸法が正常出力できないため、ここで正規化する
        (if (= "L" (nth 6 #lXd$))
          (progn
            (princ "\n一時的にＬ型コーナートールキャビの原点とサイズ情報を変換します")
            (setq #w (nth 3 #sXd$))
            (setq #d (nth 4 #sXd$))

            ;------------------------------------------------------------------
            ;WとDを入れ替える
            ;------------------------------------------------------------------
            (CFSetXData #en "G_SYM"
              (CFModList #sXd$
                (list (list 3 #d) (list 4 #w))
              )
            )
            (setq #ang (angle0to360 (+ (nth 2 #lXd$) (* 0.5 PI))))
            (setq #lXd$ (CFGetXData #en "G_LSYM"))

            ;------------------------------------------------------------------
            ;角度の設定
            ;------------------------------------------------------------------
            (CFSetXData #en "G_LSYM"
              (CFModList #lXd$
                (list
                  (list 2 #ang)
                )
              )
            )
            (setq #p1 (cdr (assoc 10 (entget #en))))
            (setq #p2 (polar #p1 (- #ang PI) #d))
            (command "_.move" #en "" #p1 #p2)

            ;画層もそれに合わせて変更する
            ; 03 -> 05
            ; 04 -> 06
            ; 05 -> 04
            ; 06 -> 03
            (setq #gEn$ (CFGetGroupEnt #en))

            ;------------------------------------------------------------------
            ; 基点と角度が変わるので、該当する画層も変更する
            ;------------------------------------------------------------------
            (command "_.LAYER" "T" "Z_03*" "T" "Z_04*" "T" "Z_05*" "T" "Z_06" "")
            (foreach #en #gEn$
              (setq #eg (entget #en))
              (setq #lay (cdr (assoc 8 (entget #en))))
              (if #lay
                (progn
                  (setq #subLay1 (substr #lay 1 4))
                  (setq #subLay2 (substr #lay 5))
                  (cond
                    ((= "Z_03" #subLay1)
                      (entmod (subst (cons 8 (strcat "Z_05" #subLay2)) (cons 8 #lay) #eg))
                    )
                    ((= "Z_04" #subLay1)
                      (entmod (subst (cons 8 (strcat "Z_06" #subLay2)) (cons 8 #lay) #eg))
                    )
                    ((= "Z_05" #subLay1)
                      (entmod (subst (cons 8 (strcat "Z_04" #subLay2)) (cons 8 #lay) #eg))
                    )
                    ((= "Z_06" #subLay1)
                      (entmod (subst (cons 8 (strcat "Z_03" #subLay2)) (cons 8 #lay) #eg))
                    )
                  )
                )
              )
            )
            (command "_.LAYER" "F" "Z_03*" "F" "Z_04*" "F" "Z_05*" "F" "Z_06" "")
          )
        )
      )
    )
  )
)
;SCFCnvSkkCnrTallCab

;<HOM>*************************************************************************
; <関数名>    : SCFCnvSkkSidePanel
; <処理概要>  : サイドパネルの性格コードを変更する
; <戻り値>    : なし
; <備考>      : 性格コード 610 -> 611 に変更する
;               変更するのはフラット対面および、シンクアイランドワークトップ下
;*************************************************************************>MOH<
(defun SCFCnvSkkSidePanel (
  /
  #sslsym
  #enlsym
  #sswkset
  #enwkset
  #skk$
  #lXd$
  #pt$$
  #pt$
  #10$
  #sp1
  #sp2
  #sp3
  #sp4
  #wkhin
  #flg
  #flg2
  #ryoiki
  )
  (princ "\n一時的にサイドパネルの性格コードを変換します")
  (setq #sswkset (ssget "X" '((-3 ("G_WTSET")))))
  (setq #sslsym (ssget "X" '((-3 ("G_LSYM")))))
  (foreach #enlsym (Ss2En$ #sslsym)

    (setq #skk$ (CFGetSymSKKCode #enlsym nil))
    ;コーナートールキャビの場合
    (if (equal #skk$ (list 6 1 0))
      (progn
        (setq #flg nil)
        (foreach #enwkset (Ss2En$ #sswkset)
          (setq #wkhin (CfGetXData #enwkset "G_WTSET"))
;          (if (= CG_SeriesCode "L")
;         (if #wkhin (setq #wkhin (substr (nth 1 #wkhin) 3 1)))
;         (if (and #wkhin (or (= #wkhin "V") (= #wkhin "H") (= #wkhin "P")))
;            (progn
              (setq #pt$$ (GetWorkTopArea #enwkset))
              (setq #flg2 nil)
              (foreach #pt$ #pt$$
                (setq #ryoiki (nth 0 #pt$))
                (setq #10$ (GetSym4PtDHelf #enlsym))
                (setq #sp1 (nth 0 #10$))
                (setq #sp2 (nth 1 #10$))
                (setq #sp3 (nth 2 #10$))
                (setq #flg T)
                (foreach #10 (list #sp1 #sp2 #sp3)
                  (setq #10 (list (car #10) (cadr #10) 0.0))
                  (if (and (not (JudgeNaigai #10 #ryoiki))(not (JudgeNaigai #10 (reverse #ryoiki))))
                    (setq #flg nil)
                  )
                )
                (if #flg
                  (setq #flg2 T)
                )
;|
                (setq #10$ (GetSym4Pt #enlsym))
                (setq #sp1 (nth 0 #10$))
                (setq #sp2 (nth 1 #10$))
                (setq #sp3 (nth 2 #10$))
                (setq #sp4 (polar #sp1 (angle #sp1 #sp2) (* 0.5 (distance #sp1 #sp2))))
                (setq #sp4 (polar #sp4 (- (angle #sp1 #sp2) (* 0.5 PI)) CG_MIKIRI_OFFSET))
                (foreach #10 (list #sp1 #sp2 #sp3 #sp4)
                  (setq #10 (list (car #10) (cadr #10) 0.0))
                  (if (or (JudgeNaigai #10 #ryoiki) (JudgeNaigai #10 (reverse #ryoiki)))
                    (setq #flg2 T)
                  )
                )
                (if #flg2
                  (setq #flg T)
                )
|;
              )
;            )
;          )
          (if #flg
            (progn
              (setq #lXd$ (CFGetXData #enlsym "G_LSYM"))

              ;性格コードの再設定
              (CFSetXData #enlsym "G_LSYM"
                (CFModList #lXd$
                  (list
                    (list 9 611)
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
;SCFCnvSkkSidePanel


;<HOM>*************************************************************************
; <関数名>    : SCFWtCut
; <処理概要>  : L型天板カット
; <戻り値>    : なし
; <備考>      :
;*************************************************************************>MOH<
(defun SCFWtCut (
  /
  #ss #i #en #ret$ #ret #j #enpl #enpld$
  )
  (if (not (tblsearch "APPID" "G_WTCUT")) (regapp "G_WTCUT"))
  (setq #ss (ssget "X" (list (list -3 (list "G_WRKT")))))
  (if #ss
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (if (and (= (nth  3 (CFGetXData #en "G_WRKT"))   1)
                 (> (nth 42 (CFGetXData #en "G_WRKT")) 750)
                 (> (nth 43 (CFGetXData #en "G_WRKT")) 750)
            )
          (progn
            (setq #ret$ (PKW_Tenban_Cut #en))
            (if #ret$
              (progn
                (setq #j 0)
                (foreach #ret #ret$
                  (setq #enpl (MakeLwPolyLine (cdr #ret) 1 0.0))
                  (setq #enpld$ (entget #enpl))
                  (entmod (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 #enpld$) #enpld$))
                  (CFSetXData (car #ret) "G_WTCUT" (list #j #enpl))
                  (SKMkGroup (CFCnvElistToSS (list (car #ret))))
                  (setq #j (1+ #j))
                )
              )
            )
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
  T
)
;SCFWtCut

;<HOM>*************************************************************************
; <関数名>    : SCFGetTokuseichi
; <処理概要>  : 特性値取得
; <戻り値>    : なし
; <備考>      :
;*************************************************************************>MOH<
(defun SCFGetTokuseichi (
  /
  #tokuseichi1$ #tokuseichi2$
  )
  (if (not CG_INPUTFILEPATH)
    (PKC_MitumoriSetEnv)
  )
  (setq #tokuseichi1$ (ReadIniFileSection (strcat CG_KENMEI_PATH "SRCPLN.CFG") "COMMON"))
  (if #tokuseichi1$
    (setq #tokuseichi1$ (ReadIniFileSection (strcat CG_KENMEI_PATH "SRCPLN.CFG") (nth 1 (assoc "PLANTYPE" #tokuseichi1$))))
  )
  (setq #tokuseichi2$ (SCFGetIniPutIdList))
  (list #tokuseichi1$ #tokuseichi2$)
)
;SCFGetTokuseichi

;<HOM>*************************************************************************
; <関数名>    : PKC_MitumoriSetEnv
; <処理概要>  : 環境設定
; <戻り値>    : なし
; <作成>      : 2004-09-09 G.YK
; <備考>      :
;*************************************************************************>MOH<
(defun PKC_MitumoriSetEnv (
  /
  #PlanInfo #DataFile
  )
  ;\CustomSK\WORK\ のﾊﾟｽ
  (setq CG_WORKPATH (cadr (assoc "WORKPATH" CG_INIINFO$)))
  (setq #PlanInfo (ReadIniFile (strcat CG_WORKPATH "PlanInfo.cfg")))
  (setq #DataFile (cadr (assoc "DATFILE" #PlanInfo)))
  ;～.top ﾌｧｲﾙのﾊﾟｽ
  (setq CG_INPUTFILEPATH (strcat CG_WORKPATH (cadr (assoc "DATFILE" #PlanInfo))))
)





(princ)
;;; end of KCFmat.lsp
