;;;<HOF>************************************************************************
;;; <ファイル名>: Kcbaloon.LSP
;;; <システム名>: KitchenPlanシステム
;;; <最終更新日>: 01/02/13 中村 博伸
;;; <備考>      : なし
;;;************************************************************************>FOH<
;@@@(princ "\nKcbaloon.fas をﾛｰﾄﾞ中...\n")

;01/02/13 HN ADD 天井フィラーの見積り枚数設定を追加
; 0= 図形長さより自動積算
; 1< 枚数固定
(setq CG_FillerNum 1)


;;;<HOM>************************************************************************
;;; <関数名>  : C:WriteBaloon
;;; <処理概要>: 現在の商品情報をファイルに書き出す
;;; <戻り値>  : なし
;;; <備考>    : プランフォルダの下記ファイルを作成します
;;;               HEAD.CFG   ヘッダー情報
;;;               TABLE.CFG  仕様表情報
;;;************************************************************************>MOH<
(defun C:WriteBaloon (
  /
  )

  ;// コマンドの初期化
  (StartUndoErr)

  ;// ヘッダー情報書き出し
  (SKB_WriteHeadList)

  ;// 特注ワークトップ情報
  (PKOutputWTCT)

  ;// 仕様表ファイル名
  (SCFMakeBlockTable)

  (setq *error* nil)
  (princ)
)
;;;C:WriteBaloon

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_WriteHeadList
;;; <処理概要>: 現在の商品のヘッダー情報をファイルに書き出す
;;; <戻り値>  : なし
;;; <備考>    : プランフォルダの HEAD.CFG に書き出します
;;;************************************************************************>MOH<
(defun SKB_WriteHeadList (
  /
  #sFname     ; ファイル名
  #head$      ; ヘッダー情報
  #fp         ; ファイル ポインタ
  )
  (setq #sFname (strcat CG_KENMEI_PATH "HEAD.CFG"))

  ;// ヘッダー情報を取得する
  (setq #head$  (SKB_GetHeadList))

  ;// ヘッダー情報ファイルへの書き込み
  (setq #fp  (open #sFname "w"))
  (princ   ";;; 各物件フォルダに置く"                  #fp)
  (princ "\n;;;"                                       #fp)
  (princ "\n;;; SeriesCD       : SERIES記号"         #fp)
  (princ "\n;;; Series         : SERIES名称"         #fp)
  (princ "\n;;; DrSeriesCD     : 扉SERIES記号"       #fp)
  (princ "\n;;; DrSeries       : 扉SERIES名称"       #fp)
  (princ "\n;;; DrColorCD      : 扉COLOR記号"         #fp)
  (princ "\n;;; DrColor        : 扉COLOR名称"         #fp)
  (princ "\n;;; WT_zaiCD       : ワークトップ材質記号" #fp)
  (princ "\n;;; WT_zai         : ワークトップ材質名称" #fp)
  (princ "\n;;; WT_height      : ワークトップ高さ"     #fp) ; 01/06/01 YM ADD
  (princ "\n;;; SinkCD         : シンク記号"           #fp)
  (princ "\n;;; Sink           : シンク名称"           #fp)
  (princ "\n;;; ElecType       : 電気種"               #fp)
  (princ "\n;;; GasType        : ガス種"               #fp)
  (princ "\n;;; HandleType     : 耐震記号(把手記号)"   #fp)
  (princ "\n;;; EquipmentColor : 機器色"               #fp)
  (princ "\n;;;"                                       #fp)
  (princ (strcat "\nSeriesCD="       (nth  0 #head$))  #fp)
  (princ (strcat "\nSeries="         (nth  1 #head$))  #fp)
  (princ (strcat "\nDrSeriesCD="     (nth  2 #head$))  #fp)
  (princ (strcat "\nDrSeries="       (nth  3 #head$))  #fp)
  (princ (strcat "\nDrColorCD="      (nth  4 #head$))  #fp)
  (princ (strcat "\nDrColor="        (nth  5 #head$))  #fp)
  (princ (strcat "\nWT_zaiCD="       (nth  6 #head$))  #fp)
  (princ (strcat "\nWT_zai="         (nth  7 #head$))  #fp)
  (princ (strcat "\nWT_height="      (nth  8 #head$))  #fp) ; 01/06/01 YM ADD
  (princ (strcat "\nSinkCD="         (nth  9 #head$))  #fp)
  (princ (strcat "\nSink="           (nth 10 #head$))  #fp)
;;;  (princ (strcat "\nElecType="       (nth 11 #head$))  #fp)

  (princ (strcat "\nGasType="        "P")  #fp) ;2008/08/04 YM MOD
;;;  (princ (strcat "\nGasType="        (nth 12 #head$))  #fp) ;2008/08/04 YM MOD

;;;  (princ (strcat "\nHandleType="     (nth 13 #head$))  #fp)

  (princ (strcat "\nEquipmentColor=" "K")  #fp) ;2008/08/04 YM MOD
;;;  (princ (strcat "\nEquipmentColor=" (nth 14 #head$))  #fp) ;2008/08/04 YM MOD

  (princ (strcat "\nWT_Sozai="       (nth 15 #head$))  #fp) ; 2000/08/10 HT ADD
  (princ (strcat "\nWT_zai2="        (nth 16 #head$))  #fp) ; 2000/09/25 HT ADD
  (princ (strcat "\nWT_Sozai2="      (nth 17 #head$))  #fp) ; 2000/09/25 HT ADD
  (princ "\n;;;END\n"                                  #fp)
  (close #fp)

  (princ)
)
;;;SKB_WriteHeadList

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_WriteColorList
;;; <処理概要>: 現在の商品のCOLOR情報をファイルに書き出す
;;; <戻り値>  : なし
;;; <備考>    : プランフォルダの COLOR.CFG に書き出します
;;;************************************************************************>MOH<
(defun SKB_WriteColorList (
  /
  #sFname     ; ファイル名
  #fp         ; ファイル ポインタ
  #COLOR$$    ; 元ﾃﾞｰﾀ
  #RollScreen
  #PanelSlim
  #Panel
  #WorkTop
  )
  ; //COLOR情報ファイルを読み込む一旦
  (setq #sFname (strcat CG_KENMEI_PATH "COLOR.CFG"))
  (if (findfile #sFname)
    (progn
      (setq #COLOR$$ (ReadIniFile #sFname))
      (setq #RollScreen  (cadr (assoc "RollScreen" #COLOR$$)))
      (setq #PanelSlim   (cadr (assoc "PanelSlim"  #COLOR$$)))
      (setq #Panel       (cadr (assoc "Panel"      #COLOR$$)))
      (setq #WorkTop     (cadr (assoc "WorkTop"    #COLOR$$)))
    )
    (progn;ELSE
      (setq #RollScreen nil)
      (setq #PanelSlim nil)
      (setq #Panel nil)
      (setq #WorkTop nil)
    )
  );END IF

  ; //外部変数にデータがあれば入れ替える。
  (if CG_RollScreen (setq #RollScreen CG_RollScreen) )
  (if CG_PanelSlim  (setq #PanelSlim CG_PanelSlim) )
  (if CG_Panel      (setq #Panel CG_Panel) )
  (if CG_WorkTop    (setq #WorkTop CG_WorkTop) )

  ; // ヘッダー情報ファイルへの書き込み
  (setq #fp  (open #sFname "w"))
  (princ ";;; 各物件フォルダに置く"                               #fp)
  (princ "\n;;;"                                                  #fp)
  (princ "\n;;; CG_RollScreen : ロールスクリーン(GV,PH)"          #fp)
  (princ "\n;;; CG_PanelSlim  : インテリアパネルスリム(PH,PV,PW)" #fp)
  (princ "\n;;; CG_Panel      : インテリアパネル(SH,SV,SW)"       #fp)
  (princ "\n;;; CG_WorkTop    : ワークトップ色(H,X,A,F,S,J,P)"    #fp)
  (princ "\n;;;"                                                  #fp)
  (if #RollScreen
    (princ (strcat "\nRollScreen=" #RollScreen) #fp)
    (princ "\nRollScreen=" #fp)
  )
  (if #PanelSlim
    (princ (strcat "\nPanelSlim=" #PanelSlim) #fp)
    (princ "\nPanelSlim=" #fp)
  )
  (if #Panel
    (princ (strcat "\nPanel=" #Panel) #fp)
    (princ "\nPanel=" #fp)
  )
  (if #WorkTop
    (princ (strcat "\nWorkTop=" #WorkTop) #fp)
    (princ "\nWorkTop=" #fp)
  )
  (princ "\n;;;END\n" #fp)
  (close #fp)

  (princ)
)
;;;SKB_WriteColorList


;;;<HOM>************************************************************************
;;; <関数名>  : SKB_SetSpecList
;;; <処理概要>: 配置部材の仕様表情報を設定する
;;; <戻り値>  : (SKB_GetSpecList) の戻り値と同じ
;;; <備考>    : 下記グローバル変数を設定
;;;               CG_DBNAME      : DB名称
;;;               CG_SeriesCode  : SERIES記号
;;;               CG_BrandCode   : ブランド記号
;;;************************************************************************>MOH<
(defun SKB_SetSpecList (
  /
  #seri$
  #spec$$
  )

  ;// 現在の商品情報を設定
  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DBNAME      (nth 0 #seri$))  ; DB名称
      (setq CG_SeriesCode  (nth 1 #seri$))  ; SERIES記号
      (setq CG_BrandCode   (nth 2 #seri$))  ; ブランド記号
    )
  )
  ;// 共通データベースへの接続
  (if (= CG_CDBSESSION nil)
    (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  )
  ;// SERIES別データベースへの接続
  (if (= CG_DBSESSION nil)
    (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  )

  ;// 配置部材仕様情報を取得
  (princ "\n配置部材の仕様情報を取得しています...")

  ;// 仕様表詳細情報を取得
  (setq #spec$$ (SKB_GetSpecInfo))

  ;// 仕様表詳細情報を取得
  (setq #spec$$ (SKB_GetSpecList #spec$$))

  ;// 仕様番号Ｐ点に品番名称を設定
  (SKB_SetBalPten)

  #spec$$
)
;;;SKB_SetSpecList

;;;<HOM>************************************************************************
;;; <関数名>  : KP_DelPTWF
;;; <処理概要>: 既存の"G_PTWF"を削除する
;;; <戻り値>  : なし
;;; <備考>    : 01/11/30 YM ADD
;;;************************************************************************>MOH<
(defun KP_DelPTWF (
  /
	#I #SS
  )
  (setq #ss (ssget "X" '((-3 ("G_PTWF"))))) ; 図面上のWT,FILRのPTEN7全て
  (if (and #ss (> (sslength #ss) 0))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (entdel (ssname #ss #i))
				(setq #i (1+ #i))
			)
		)
	);_if
	(princ)
);KP_DelPTWF

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_GetSpecInfo
;;; <処理概要>: 仕様表詳細情報を取得する
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                 1.連番(1～)
;;;                 2.ソートキー
;;;                 3.ワークトップ品番名称
;;;                 4.図形ハンドル
;;;                 5.入力配置用品番名称
;;;                 6.出力名称コード
;;;                 7.仕様名称コード
;;;                 8.個数
;;;                 9.金額
;;;                10.品コード
;;;                11.部材種類フラグ (0:標準部材 1:特注WT 2:天井フィラー 3:補足部材)
;;;                12.集約ID
;;;                13.寸法
;;;                14.掛率or上乗せ額
;;;               )
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKB_GetSpecInfo (
  /
  #wtlst$$
  #bzlst$$
  #all-lst$$
  #dtlst$$
  #lst$
  #no
  #filer$
  #hosoku$
  #option$
  #SpecInfo$$ #BGLST$$ #KEKOMI$
  )

;//////////////////////////////////////////////////
; 同じ品番なら個数を増やす  ; 02/03/26 YM ADD
;//////////////////////////////////////////////////
		(defun ##MATOME (
			&lis$
			/
			#F #FNEW #HIN #HIN$ #I #KOSU #LOOP #RET$
;-- 2011/12/12 A.Satoh Add - S
			#bunrui
;-- 2011/12/12 A.Satoh Add - E
			)
			(setq #ret$ nil #hin$ nil)
			(foreach #e &lis$
				(setq #hin (nth 1 #e))
				(setq #LR  (nth 3 #e)) ; 02/04/08 YM ADD LR  追加
				(setq #ko  (nth 6 #e)) ; 02/12/21 YM ADD 個数追加
;-- 2011/12/12 A.Satoh Add - S
				(setq #bunrui (nth 11 #e))
				(setq #t_flg (nth 13 #e))
;-- 2011/12/12 A.Satoh Add - E

;-- 2011/12/12 A.Satoh Mod - S
;;;;;				(setq #dum$ (list #hin #LR)) ; 02/12/21 YM ADD
				(setq #dum$ (list #hin #LR #bunrui))
;-- 2011/12/12 A.Satoh Mod - E
				(if (member #dum$ #hin$) ; 02/12/21 YM MOD
;-- 2011/12/12 A.Satoh Add - S
					(if (= #t_flg 0)
;-- 2011/12/12 A.Satoh Add - E
					(progn ; 同じものあり
						(setq #loop T #i 0)
						(setq #kosu (length #ret$))
						(while (and #loop (< #i #kosu))
							(setq #f (nth #i #ret$))
							(if (and (= (nth 1 #f) #hin)(= (nth 3 #f) #LR))
								(progn
									(setq #loop nil)
						      (setq #fnew
									 	(CFModList #f
											; 02/12/21 YM MOD-S 単純に+1するのではなく個数同士を加える
							        (list (list 6 (+ #ko (nth 6 #f)))) ; 個数+個数
											; 02/12/21 YM MOD-E
							      )
									)
								)
							);_if
							(setq #i (1+ #i))
						)
						(setq #ret$ (subst #fnew #f #ret$)) ; 要素入替え
					)
;-- 2011/12/12 A.Satoh Add - S
						(progn
	            (setq #hin$ (append #hin$ (list (list #hin #LR #bunrui)))) ; 品番ﾘｽﾄ
	            (setq #ret$ (append #ret$ (list #e)))
						)
					)
;-- 2011/12/12 A.Satoh Add - E
					(progn ; 初めて
;-- 2011/12/12 A.Satoh Mod - S
;;;;;						; 02/12/21 YM MOD-S
;;;;;						(setq #hin$ (append #hin$ (list	(list #hin #LR)))) ; 品番ﾘｽﾄ
;;;;;						; 02/12/21 YM MOD-E
						(setq #hin$ (append #hin$ (list (list #hin #LR #bunrui))))
;-- 2011/12/12 A.Satoh Mod - E
						(setq #ret$ (append #ret$ (list #e)))
					)
				);_if
			)
			#ret$
		);##MATOME
;//////////////////////////////////////////////////

	; SET構成確認ｺﾏﾝﾄﾞのときは作図しない 01/05/15 YM ADD
  ;// ワークトップ、天井フィラーの仕様番号点を作図
	(if (= nil CG_SetHIN)
		(progn
			(KP_DelPTWF) ; 01/11/30 YM ADD 既存の"G_PTWF"を削除する
  		(SKB_MakeWkTopBaloonPoint)
		)
	);_if

  ;// ワークトップ図形のＷＴ品番情報を検索し、ワークトップ名称を取得
  ;// WT素材.DBより現在の素材IDの出力名称コード・仕様名称コードを取得
  ;// ワークトップ品番名称・図形ハンドル・出力名称コード・仕様名称コードの一覧表作成
  ;// ワークトップが２種類以上ある場合には拡張データ内のWTタイプの番号に並べ替え
  ;// ソートキーは０、入力配置用品番名称は品番名称と同じ内容、個数は１を格納
  (setq #wtlst$$ (SKB_GetWKTopList))

	;#wtlst$$
	;例:((0 "HQSI255H-ALQ-L" "2550" "40" "650" "ｽﾃﾝﾚｽSLﾄｯﾌﾟ I 型 D650 H     　Ｌ" 1 126000.0 "A10" ("4C27")))

  ;// 配置済み部材の工種記号・SERIES記号・品番名称・Ｌ／Ｒ区分より品番図形.DBを検索
  ;// 品番名称・入力配置用品番名称・図形ハンドルの一覧表を作成
  ;// ただし、入力配置用品番名称が同一の場合は１行にまとめて個数＋１
  (setq #bzlst$$ (SKB_GetBuzaiList))

	;#bzlst$$
	;例 ("H$030WFB-7%#-@@[J:BW]" "L" ("4937") 1 "0")

  (if #bzlst$$
		(progn
    ;// 一覧表の品番名称と工種記号・SERIES記号をキーにして品番基本.DBを検索
    ;// ソートキー・出力名称コード・仕様名称コードを取得して一覧表に追加
    (setq #dtlst$$ (SCB_GetDetailList #bzlst$$))

    ;// 一覧表作成後、集約IDおよびソートキーで昇順に並び替え

		; 一覧表作成後、第1key=集約ID(nth 10),第2key=品番基本.ｿｰﾄｷｰ(nth 0)で昇順に並び替え
		(if #dtlst$$
    	(setq #dtlst$$ (ListSortLevel2 #dtlst$$ 10 0))
		);_if

  ))

	;#dtlst$$
	;例:(1011 "H$090S2A-JN#-@@[J:BW]" ("426D") "Z" 0 0 1 0 "xxxxxxx" "0" "A20")

  ;// ワークトップ一覧に部材一覧を追加
  (setq #all-lst$$ (append #wtlst$$ #dtlst$$))


	;#bzlst$$
	;例 ("H$030WFB-7%#-@@[J:BW]" "L" ("4937") 1 "0")

  ;// フィラー関連の仕様情報を追加
  (if (/= nil (setq #filer$ (SKB_GetFillerInfo)))
    (setq #all-lst$$ (append #all-lst$$ #filer$))
  )
	;#filer$
	;例: ((2046 "HSCM240R-@@" ("4E76") "Z" 0 0 1 0 "xxxxxxx" "2" "A60"))

  ;// 追加部材の仕様情報を追加
  (if (/= nil (setq #hosoku$ (SKB_GetHosokuInfo)))
    (setq #all-lst$$ (append #all-lst$$ #hosoku$))
  )

  ;// オプションアイテムの仕様情報を追加
  (if (/= nil (setq #option$ (SKB_GetOptionInfo)))
    (setq #all-lst$$ (append #all-lst$$ #option$))
  )
	(setq #all-lst$$ (##MATOME #all-lst$$))

  ;// 一覧表作成後、集約IDおよびソートキーで昇順に並びえ
  (if #all-lst$$
		; 一覧表作成後、第1key=集約ID(nth 10),第2key=品番基本.ｿｰﾄｷｰ(nth 0)で昇順に並び替え
    (setq #all-lst$$ (ListSortLevel2 #all-lst$$ 10 0))
  )

	;2011/04/25 YM ADD 扉個別指定対応  同じ集約ID(nth 10),ｿｰﾄｷｰ(nth 0)の場合,品番名称(nth 1)でｿｰﾄする
	(if #all-lst$$
		(setq #all-lst$$ (LisSortHin #all-lst$$ 10 0 1))
	)

  (setq #SpecInfo$$ nil)
  (setq #no 1)

  ;//  仕様表情報リストをグローバルに設定
  (foreach #lst$ #all-lst$$
    (setq #SpecInfo$$ (append #SpecInfo$$ (list (cons #no #lst$))))
    (setq #no (1+ #no))
  )

  ;// 仕様表情報
  #SpecInfo$$
);SKB_GetSpecInfo



;;;<HOM>************************************************************************
;;; <関数名>  : LisSortHin
;;; <処理概要>: ;同じ集約ID,ｿｰﾄｷｰの場合,品番名称でｿｰﾄする
;;; <戻り値>  : ｿｰﾄ後のﾘｽﾄ
;;; <備考>    : 
;;;             2011/04/25 YM ADD
;;;************************************************************************>MOH<
(defun LisSortHin (
  &Lst$$ ; 仕様情報リスト
	&KEY1  ; 第1KEY(nil不可)
	&KEY2  ; 第2KEY(nil不可)
	&KEY3  ; 第2KEY(nil不可)
  /
	#DUM$$ #LST$$ #RSLT$$ #SID1 #SID2 #SRT1 #SRT2
  )
;;;引数
;;;(
;;; (2021 "R$90S0B-MN#-@@[RS:G:D]" ("45D67") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (2021 "R$90S0B-MN#-@@[RP:G:D]" ("46040") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (2021 "R$90S0B-MN#-@@[RJ:MB:D]" ("4631C") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (3003 "R$90NHB-MN#-@@[RS:G:D]" ("45DE5") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (3003 "R$90NHB-MN#-@@[RP:G:D]" ("460BE") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (3003 "R$90NHB-MN#-@@[RJ:MB:D]" ("4639A") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (4007 "R$90UHB-MN#-@@[RJ:MB:D]" ("46408") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (4007 "R$90UHB-MN#-@@[RP:G:D]" ("4612C") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;; (4007 "R$90UHB-MN#-@@[RS:G:D]" ("45E53") "Z" 0 0 1 0 "xxxxxxx" "0" "D10")
;;;)

	(setq #Lst$$ &Lst$$)

	(setq #dum$$ (list (car #Lst$$))) ;最初のﾘｽﾄ
  (setq #srt1 (nth &KEY2 (car #Lst$$)));ｿｰﾄｷｰ
  (setq #sid1 (nth &KEY1 (car #Lst$$)));集約ID

  (foreach #Lst$ (cdr #Lst$$)
    (setq #srt2 (nth &KEY2 #Lst$));ｿｰﾄｷｰ
    (setq #sid2 (nth &KEY1 #Lst$));集約ID

    (if (and (= #srt1 #srt2)(= #sid1 #sid2))
			(progn
      	(setq #dum$$ (append #dum$$ (list #Lst$)))
			)
			;else
      (progn
				(setq #dum$$ (CFListSort #dum$$ &KEY3));品番でｿｰﾄする
        (setq #rslt$$ (append #rslt$$ #dum$$))
        (setq #dum$$ (list #Lst$))
        (setq #srt1 #srt2)
        (setq #sid1 #sid2)
      )
    );_if
  )
  (if (/= #dum$$ nil)
    (setq #rslt$$ (append #rslt$$ (CFListSort #dum$$ &KEY3))) ;品番でｿｰﾄする
  );_if

	#rslt$$
);LisSortHin




;;;<HOM>************************************************************************
;;; <関数名>  : ListSortLevel2
;;; <処理概要>: ﾘｽﾄのﾘｽﾄを第2KEY(nth ? の番号で指定)まで指定してｿｰﾄ
;;; <戻り値>  : ｿｰﾄ後のﾘｽﾄ
;;; <備考>    : nth 10 集約ID , nth 0 品番基本.ｿｰﾄｷｰ
;;;             関数SCB_SortDetailList の一般化 01/02/02 YM
;;;************************************************************************>MOH<
(defun ListSortLevel2 (
  &Lst$$ ; 仕様情報リスト
	&KEY1  ; 第1KEY(nil不可)
	&KEY2  ; 第2KEY(nil不可)
  /
	#DUM$$ #ID1 #ID2 #LST$$ #RSLT$$
  )
	(if (= (type &KEY1) 'INT)
		(progn
		  ;// 第1KEYでソートする
		  (setq #Lst$$ (CFListSort &Lst$$ &KEY1))
		  (setq #id1 (nth &KEY1 (car #Lst$$)))
		  (setq #dum$$ (list (car #Lst$$)))
		  (foreach #Lst$ (cdr #Lst$$)
		    (setq #id2 (nth &KEY1 #Lst$))
		    (if (= #id1 #id2)
		      (setq #dum$$ (append #dum$$ (list #Lst$)))
		      (progn
		        ;// 第2KEYでソートする
						(if (= (type &KEY2) 'INT)(setq #dum$$ (CFListSort #dum$$ &KEY2)))
		        (setq #rslt$$ (append #rslt$$ #dum$$))
		        (setq #dum$$ (list #Lst$))
		        (setq #id1 #id2)
		      )
		    );_if
		  )
		  (if (/= #dum$$ nil)
		    (setq #rslt$$ (append #rslt$$
					(if (= (type &KEY1) 'INT)
						(CFListSort #dum$$ &KEY2)
						#dum$$
					)
				))
		  );_if
		)
		(setq #rslt$$ &Lst$$)
	);_if
  #rslt$$
);ListSortLevel2

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_SetBalPten
;;; <処理概要>: 仕様番号Ｐ点に品番名称を設定する
;;; <戻り値>  :
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKB_SetBalPten (
  /
	#CABANG #DOORANG #EG$ #EN #HIN #I #P-EN #PRICE #QRY$ #SS #TOKU$
	#VECTOR #XD$ #XDOPT$ #XDPTEN$ #ZOKU #ZOKU2 #HINBAN #LR_OYA #NEWHINBAN
	#DRCOLCODE #OPT2$$ #XDOPT2$
#org_hin ;2018/10/25 YM ADD-S
  )
  (setq CG_FuncName "\nSKB_SetBalPten")

  ;// 図面上のＰ点を全て取得
  (setq #ss (ssget "X" '((-3 ("G_PTEN")))))
  (setq #i 0)
  (if #ss ;00/08/01 SN ADD
  (repeat (sslength #ss)
    (setq #p-en (ssname #ss #i))
		(setq #xdPTEN$ (CFGetXData #p-en "G_PTEN")) ; 01/04/05 YM #xdPTEN$ 追加
    ;// 仕様番号のＰ点のみに絞り込む
    (if (= (car #xdPTEN$) CG_BALOONTYPE) ; 01/04/05 YM 追加
      (progn
        ;// Ｐ点の親図形（G_LSYM,G_WTSET,G_FILR)の図形を取得する
        (setq #en (SKC_GetSymInGroup #p-en)) ; 親図形ｼﾝﾎﾞﾙ(これからG_OPTを取得)

				(if (and #en (CFGetXData #en "G_LSYM"))
					(progn
						; 定義不正PTEN7をentmodする(背面用なのに押し出し方向が正面を向いているもの)
						; 01/05/02 YM ADD STRAT ----------------------------------------------------
						(setq #CABang (nth 2 (CFGetXData #en "G_LSYM"))) ; ｷｬﾋﾞ配置角度
						(setq #eg$ (entget #p-en))
						(if (= "04" (substr (cdr (assoc 8 #eg$)) 3 2))
							(progn ; 背面用だった
								(setq #vector (cdr (assoc 210 #eg$))) ; PTEN7押し出し方向
								(setq #DoorANG (angle '(0 0 0) #vector)) ; 扉法線ﾍﾞｸﾄﾙの向き
								(setq #DoorANG (Angle0to360 #DoorANG)) ; 0～360度の値にする

								(if (equal (Angle0to360 (+ #CABang (dtr 90))) #DoorANG 0.001) ; PTEN7が正しく定義されているか
									nil ; 何もしない

									(entmod ; PTEN7不正==>entmod
										(subst
											(cons 210	(polar '(0 0 0) (Angle0to360 (+ #CABang (dtr 90))) 100))
											(assoc 210 #eg$)
											#eg$
										)
									)

								);_if

							)
						);_if
					)
				);_if
				; 01/05/02 YM ADD END ----------------------------------------------------

        ;// 品番名称を取得する
        (if (/= nil #en)
          (progn
            (cond
;-- 2011/12/12 A.Satoh Add - S
							((/= nil (setq #xd_TOKU$ (CFGetXData #en "G_TOKU")))	; 特注部材
								(setq #xd$ (CFGetXData #en "G_LSYM"))
							  (setq #qry$
								  (CFGetDBSQLRec CG_DBSESSION "品番図形"
								    (list
                      (list "品番名称"        (nth  5 #xd$)  'STR)
                      (list "LR区分"          (nth  6 #xd$)  'STR)
                      (list "用途番号" (rtois (nth 12 #xd$)) 'INT)
								    )
								  )
								)

							  (if (and #qry$ (= 1 (length #qry$)))
								  (progn
										(setq #qry$ (car #qry$))
										(setq #DRColCode  (nth 7 #xd$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"

										(if (and (/= #DRColCode nil)(/= #DRColCode ""))
											(progn
												(if (and #DRColCode (vl-string-search "," #DRColCode))
													(progn
														(setq #DRColCode (CMN_string-subst "," ":" #DRColCode))
														(setq #hin (strcat (nth 0 #xd_TOKU$) "[" #DRColCode "]"))
													)
													(progn
														(setq #hin (nth 0 #xd_TOKU$))
													)
												)
											)
											(progn
												(setq #hin (nth 0 #xd_TOKU$))
											)
										)

										;2018/10/25 YM MOD-S 特注品番の元品番が(%)付き品番のときの対応 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
										;(%)付き品番は、L/RありとしてMDB登録されるが、(%)を外した品番に%がなければLR=Zとみなして処理をしなければ展開番号がうまくつかない
		                (if (or (= "R" (nth 1 #qry$))(= "L" (nth 1 #qry$)));2018/10/25 YM MOD-S 特注品番の元品番が(%)付き品番のときの対応
											(progn
												(setq #org_hin (nth 10 #xd_TOKU$))
												;2018/10/25 YM MOD 品番に%を含んでいなかったら"Z"扱い
								        (if (vl-string-search "%" (KP_DelHinbanKakko #org_hin)); ()外して"%"有無判定
		                  		(setq #hin (strcat #hin (nth 1 #qry$))) ; LRを末尾に
													;else
													nil
												);_if
;;;		                  	(setq #hin (strcat #hin (nth 1 #qry$)));2018/10/25 YM MOD ; LRを末尾に
											)
											;else
		                  nil
		                )

										(setq #hnd  (cdr (assoc 5 (entget #en))))
										(setq #hin (strcat #hin #hnd))
									)
								)
							)
;-- 2011/12/12 A.Satoh Add - E
              ((/= nil (setq #xd$ (CFGetXData #en "G_LSYM")))  ;部材設備


							  (setq #qry$
								  (CFGetDBSQLRec CG_DBSESSION "品番図形"
								    (list
                      (list "品番名称"        (nth  5 #xd$)  'STR)
                      (list "LR区分"          (nth  6 #xd$)  'STR)
                      (list "用途番号" (rtois (nth 12 #xd$)) 'INT)
								    )
								  )
								)

							  (if (and #qry$ (= 1 (length #qry$)))
								  (progn
										(setq #qry$ (car #qry$))

;;;										(if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
;;;											(progn ; ｷｬﾋﾞのとき
										(setq #DRColCode  (nth 7 #xd$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"

										;2011/06/15 YM MOD 条件変更
										(if (and (/= #DRColCode nil)(/= #DRColCode ""))
											(progn
												; 01/11/01 YM MOD ","が含まれるかどうかﾁｪｯｸ
												(if (and #DRColCode (vl-string-search "," #DRColCode))
													(progn ; もし","が含まれていたら

														(setq #DRColCode (CMN_string-subst "," ":" #DRColCode))
														(setq #hin (strcat (nth 0 #qry$) "[" #DRColCode "]"))
													)
													(progn
														(setq #hin (nth 0 #qry$)) ; 01/11/07 YM ADD 条件=nil の場合が抜けていた(次のPTENに前の品番を登録→ﾊﾞﾙﾝ不正)
													)
												);_if
											)
											(progn
												(setq #hin (nth 0 #qry$)) ; 01/11/05 YM ADD ｷｬﾋﾞ以外のときが抜けていた-->水栓バルン不正
											)
										);_if

		                (if (or (= "R" (nth 1 #qry$))(= "L" (nth 1 #qry$)))
											(progn
												;2018/01/09 YM ADD 品番に%を含んでいなかったら"Z"扱い
												
								        (if (vl-string-search "%" (KP_DelHinbanKakko #hin));()外して"%"有無判定
;;;													(setq #LR 1);L/Rあり
		                  		(setq #hin (strcat #hin (nth 1 #qry$))) ; LRを末尾に
													;else
;;;													(setq #LR 0);L/Rなし
													nil
												);_if

											)
											;else
											(progn
		                  	nil ; そのまま
											)
		                );_if
									 	; 01/10/30 YM MOD-E

									)
								);_if

;;;										; 01/03/10 YM ADD 特注ｷｬﾋﾞだったら "ﾄｸ"品番@価格
;;;										(if (setq #TOKU$ (CFGetXData #en "G_TOKU"))
;;;											(progn
;;;												(setq #price (itoa (fix (+ (nth 1 #TOKU$) 0.001))))
;;;										;;;										(setq #hin (strcat "ﾄｸ" #hin "@" #price)) ; 01/05/17 YM MOD
;;;												(setq #hin (strcat (nth 0 #TOKU$) "@" #price)) ; 01/05/17 YM MOD
;;;											)
;;;										);_if
;;;							  	)
;;;									(setq #hin "DUM")
;;;							  );_if

              )
              ((/= nil (setq #xd$ (CFGetXData #en "G_WTSET")))     ;ワークトップ
                (setq #hin (nth 1 #xd$))
              )
              ((/= nil (setq #xd$ (CFGetXData #en "G_FILR")))      ;天井フィラー
                (setq #hin (nth 0 #xd$))
              )
            );_cond


						; 01/12/03 YM ADD-S 品番に含まれる()を削除する
						(if #hin ;03/12/10 YM ADD WT品番確定していないと見積書作成で落ちる
							(setq #hin (KP_DelHinbanKakko #hin))
							;else
							(setq #hin "")
						);_if
						; 01/12/03 YM ADD-E

						; 01/07/19 MOD ｵﾌﾟｼｮﾝ品個数制限をなくした START
						(setq #zoku  (nth 2 #xdPTEN$))
						(setq #zoku2 (1- (* 2 #zoku)))
						(if	(= 0 #zoku)
            	(CFSetXData #p-en "G_PTEN" (list 7 #hin 0)) ; 今まで通り
							(progn ; それ以外
								(if (and (setq #xdOPT$ (CFGetXData #en "G_OPT")) ; ｵﾌﾟｼｮﾝ品があったら
												 (nth #zoku2 #xdOPT$))
									(progn
										(setq #hinban (nth #zoku2 #xdOPT$)) ; "ﾄｸFP-2C10-75"など

										; 03/06/18 YM ADD ｵﾌﾟｼｮﾝ特注化情報 "G_OPT2"参照
										(setq #xdOPT2$ (CFGetXData #en "G_OPT2")) ; nil ありえる
										(setq #opt2$$ (KP_GetOpt2Info #xdOPT2$)) ; #xdOPT2$==>(特注品番,元品番,金額,SET品ﾌﾗｸﾞ)のﾘｽﾄ(nilあり)
										(if #opt2$$ ; nil ありえる
											(progn
												(if (assoc #hinban #opt2$$)
													(progn
														(setq #price (nth 2 (assoc #hinban #opt2$$)))
														(setq #hinban (strcat #hinban "@" #price))
													)
												);_if
											)
										);_if


										(setq #newhinban (KP_GetOPTnewHINBAN #hinban #en))    ; OPT品番+親ｼﾝﾎﾞﾙ+親LR-->新品番
		            		(CFSetXData #p-en "G_PTEN" (list 7 #newhinban #zoku)) ; #zoku個目のｵﾌﾟｼｮﾝ品をｾｯﾄ
									)
		            	(CFSetXData #p-en "G_PTEN" (list 7 #hin #zoku)) ; 今まで通り
								);_if
							)
						);_if
						; 01/07/19 MOD ｵﾌﾟｼｮﾝ品個数制限をなくした END
          )
        );_if
      )
    )
    (setq #i (1+ #i))
  )
  );end if 00/08/01 SN ADD
);SKB_SetBalPten

;;;<HOM>************************************************************************
;;; <関数名>  : KP_GetOPTnewHINBAN
;;; <処理概要>: ｵﾌﾟｼｮﾝ品番にLR区分があれば親品番のLRを末尾につけて返す
;;; <戻り値>  : ｵﾌﾟｼｮﾝ品番文字列
;;;             01/07/19 YM
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun KP_GetOPTnewHINBAN (
	&hinbanOPT ; ｵﾌﾟｼｮﾝ品番
	&sym       ; 親ｼﾝﾎﾞﾙ図形
  /
	#QRY$ #RET #LR_OYA
  )
	(setq #LR_oya (nth 6 (CFGetXData &sym "G_LSYM"))); 親図形のLR
  (setq #qry$
    (car (CFGetDBSQLHinbanTable "品番基本" &hinbanOPT
    (list (list "品番名称" &hinbanOPT 'STR))))
  )
	(if (and #qry$ (= 1 (nth 1 #qry$))) ; LR区分あれば親図形のLRを付ける
		(setq #ret (strcat &hinbanOPT #LR_oya))
		(setq #ret &hinbanOPT)
	);_if
	#ret
);KP_GetOPTnewHINBAN

;;;<HOM>************************************************************************
;;;<関数名>   : SKB_GetSpecList
;;; <処理概要>: 仕様表情報を取得する
;;; <戻り値>  : Table.cfgに出力するﾘｽﾄ
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKB_GetSpecList (
  &SpecInfo$$ ; (LIST)仕様表情報
  /
	#DDD #HANDLE #HHH #HINMEI #I #INFO$ #KAKAKU #KOSU #LAST_HIN #LAST_REC$ #LR 
	#LRCD #NAME #NAME1 #SHINBAN #SORT_KEY #SPECLIST$ #SPECLIST$$ #SYUYAKU_ID #TENKAI_ID #WWW
#DoorInfo$ #DRHINBAN ;2011/04/23 YM ADD
#Toku_CD #Toku_FLG #xd_TOKU$	;-- 2011/12/12 A.Satoh Add
  )

  (setq #SpecList$$ nil)
  (setq #i 1)
  (foreach #info$ &SpecInfo$$

    (if (< (nth 1 #info$) 10);ソートキーが10以下なら天板とみなす
      ; ワークトップの場合
			(progn
				(setq #SORT_KEY   (nth 1 #info$))
				(setq #LAST_HIN   (nth 2 #info$))
				(setq #WWW        (nth 3 #info$))
				(setq #HHH        (nth 4 #info$))
				(setq #DDD        (nth 5 #info$))
				(setq #HINMEI     (nth 6 #info$))
				(setq #KOSU       (nth 7 #info$))
				(setq #KAKAKU     (nth 8 #info$))
				(setq #SYUYAKU_ID (nth 9 #info$))
				(setq #HANDLE     (nth 10 #info$))
				(setq #sHinban    #LAST_HIN)
				(setq #LR         "")
				(setq #drHinban   #sHinban)
;-- 2011/12/12 A.Satoh Add - S
				(setq #Tenkai_ID -1)
        (setq #Toku_CD    (nth 13 #info$))
				(setq #Toku_FLG   (nth 14 #info$))
;-- 2011/12/12 A.Satoh Add - E
			)
			(progn
				(setq #SORT_KEY   (nth 1 #info$))
				(setq #sHinban    (nth 2 #info$));CAD品番
				(setq #drHinban #sHinban);[]付き品番

				;2011/04/23 YM ADD-S
				;ここで部材ごとの扉情報があれば取得する
				(setq #DoorInfo$ (KP_GetSeriStr #sHinban));扉ｸﾞﾚｰﾄﾞ,扉色,引手のﾘｽﾄ

				;2011/06/17 YM MOD-S
				(setq #sHinban    (KP_DelDrSeriStr #sHinban))
				(if (= #DoorInfo$ nil)(setq #drHinban #sHinban))
				;2011/06/17 YM MOD-E

				(setq #HANDLE     (nth 3 #info$))
				(setq #LR         (nth 4 #info$))
				(setq #SYUYAKU_ID (nth 11 #info$))
				(setq #KOSU       (nth 7 #info$));???
				(setq #Tenkai_ID (GetTenkaiID #sHinban));整数を返す

				;2011/06/03 YM ADD-S
				(if (or (= #LR "L")(= #LR "R"))
					(setq #drHinban (strcat #drHinban #LR))
				);_if

;-- 2011/12/12 A.Satoh Add - S
        (setq #Toku_CD    (nth 13 #info$))
				(setq #Toku_FLG   (nth 14 #info$))

				(if (= #Toku_FLG 1)
					(setq #drHinban (strcat #drHinban (car #HANDLE)))
				)
;-- 2011/12/12 A.Satoh Add - E
							 
				(cond
					((= #Tenkai_ID 0)
						;品番最終を検索
						(if #DoorInfo$
							(progn ;扉情報(扉ｸﾞﾚｰﾄﾞ,扉色,引手)があれば専用処理
							 	;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
								(setq #Last_Rec$ (GetLast_Rec_DoorInfo #sHinban #LR #DoorInfo$));品番最終のﾚｺｰﾄﾞを返す
							)
							(progn
							 	;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
								(setq #Last_Rec$ (GetLast_Rec #sHinban #LR 0));品番最終のﾚｺｰﾄﾞを返す
							)
						);_if
				 	)
					((= #Tenkai_ID 1)
					 	;品番,LR
					 	(setq #Last_Rec$ (GetLast_Rec #sHinban #LR 1));品番最終のﾚｺｰﾄﾞを返す
				 	)
					((= #Tenkai_ID 2)
					 	;品番,LR,ｶﾞｽ種
						(setq #Last_Rec$ (GetLast_Rec #sHinban #LR 2));品番最終のﾚｺｰﾄﾞを返す
				 	)
					((= #Tenkai_ID nil)
					 	;ERROR
						(setq #Last_Rec$ nil)
				 	)
				);_cond

				(if #Last_Rec$
					(progn
						(setq #LAST_HIN   (nth 10 #Last_Rec$))
						(setq #WWW        (nth 11 #Last_Rec$))
						(setq #HHH        (nth 12 #Last_Rec$))
						(setq #DDD        (nth 13 #Last_Rec$))
						(setq #HINMEI     (nth 14 #Last_Rec$))
						(setq #KAKAKU     (nth  8 #Last_Rec$))
					)
					(progn
;-- 2011/12/12 A.Satoh Add - S
						(if (= #Toku_FLG 1)
							(progn
								(setq #xd_TOKU$ (CFGetXData (handent (car #HANDLE)) "G_TOKU"))
								(if #xd_TOKU$
									(progn
				            (setq #LAST_HIN   (nth 0 #xd_TOKU$))
        				    (setq #WWW        (itoa (fix (nth 4 #xd_TOKU$))))
				            (setq #HHH        (itoa (fix (nth 5 #xd_TOKU$))))
        				    (setq #DDD        (itoa (fix (nth 6 #xd_TOKU$))))
				            (setq #HINMEI     (nth 2 #xd_TOKU$))
        				    (setq #KAKAKU     (nth 1 #xd_TOKU$))
									)
									(progn
				            (setq #LAST_HIN   "")
        				    (setq #WWW        "")
				            (setq #HHH        "")
        				    (setq #DDD        "")
				            (setq #HINMEI     "")
        				    (setq #KAKAKU     "")
									)
								)
							)
							(progn
;-- 2011/12/12 A.Satoh Add - E
						(setq #LAST_HIN   "")
						(setq #WWW        "")
						(setq #HHH        "")
						(setq #DDD        "")
						(setq #HINMEI     "")
						(setq #KAKAKU     "")
;-- 2011/12/12 A.Satoh Add - S
							)
						)
;-- 2011/12/12 A.Satoh Add - E
					)
				);_if

			)
		);_if

  	;// 仕様表情報リストを作成する
    (setq #SpecList$
      (list
				(itoa #i)   ;明細番号
				#LAST_HIN   ;最終品番
				#WWW        ;巾
				#HHH        ;高さ
				#DDD        ;奥行
				#HINMEI     ;品名
				#KOSU       ;個数
				#KAKAKU     ;価格
;-- 2011/12/12 A.Satoh Mod - S
;;;;;				#SYUYAKU_ID ;集約ID
;;;;;				#sHinban    ;CAD品番
;;;;;				#LR         ;LR区分
;;;;;				#drHinban   ;[]付き品番
        #bunrui     ;分類
        #SYUYAKU_ID ;集約ID
				#Tenkai_ID	; 展開タイプ
        #sHinban    ;CAD品番
        #LR         ;LR区分
				#drHinban   ;[]付き品番
				#Toku_CD		;特注コード
				#Toku_FLG		;特注フラグ
;-- 2011/12/12 A.Satoh Mod - E
      )
    )
    (setq #SpecList$$ (append #SpecList$$ (list #SpecList$)))

		(setq #i (1+ #i))
	);foreach

  ;// 仕様表リストを返す
  #SpecList$$
)
;;;SKB_GetSpecList

;;;<HOM>************************************************************************
;;; <関数名>  : GetLast_Rec_DoorInfo
;;; <処理概要>: [品番最終]を検索してredordを取得
;;; <戻り値>  : redord
;;;             2011/04/23 YM ADD
;;; <備考>    : 展開ﾀｲﾌﾟ=0のみを想定
;;;************************************************************************>MOH<
(defun GetLast_Rec_DoorInfo (
  &hinban
	&LR
	&DoorInfo$ ;扉情報(扉ｸﾞﾚｰﾄﾞ,扉色,引手)
  /
	#QRY$ #RET
  )
	(if (= nil &DoorInfo$)
		(setq &DoorInfo$ (list "" "" ""))
	);_if

 	;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
	(setq #qry$
	 	(CFGetDBSQLRec CG_DBSESSION "品番最終"
			(list
				(list "品番名称"               &hinban 'STR)
				(list "LR区分"                 &LR     'STR)
				(list "扉シリ記号" (nth 0 &DoorInfo$)  'STR)
				(list "扉カラ記号" (nth 1 &DoorInfo$)  'STR)
				(list "引手記号"   (nth 2 &DoorInfo$)  'STR)
			)
		)
	)
 	(if (= nil #qry$)
		(progn ;吊戸の場合ﾋｷﾃ記号なしで検索しなければいけない
		 	;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
			(setq #qry$
			 	(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"               &hinban 'STR)
						(list "LR区分"                 &LR     'STR)
						(list "扉シリ記号" (nth 0 &DoorInfo$)  'STR)
						(list "扉カラ記号" (nth 1 &DoorInfo$)  'STR)
					)
				)
			)
		)
	);_if
 	(if (= nil #qry$)
		(progn ;吊戸の場合ﾋｷﾃ記号なしで検索しなければいけない
		 	;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
			(setq #qry$
			 	(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"               &hinban 'STR)
						(list "LR区分"                 &LR     'STR)
					)
				)
			)
		)
	);_if
		 
	(if (and #qry$ (= (length #qry$) 1))
		(progn ;1件HIT
			(setq #ret (car #qry$))
		)
		(progn
			(setq #ret nil)
		)
	);_if
	#ret
);GetLast_Rec_DoorInfo


;;;<HOM>************************************************************************
;;; <関数名>  : GetLast_Rec
;;; <処理概要>: [品番最終]を検索してredordを取得
;;; <戻り値>  : redord
;;;             2008/08/07 YM ADD
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun GetLast_Rec (
  &hinban
	&LR
	&Tenaki_ID ;0,1,2
  /
	#QRY$ #RET #GAS
  )

;;;	(setq CG_DRSeriCode (nth 62 CG_GLOBAL$))
;;;	(setq CG_DRColCode  (nth 63 CG_GLOBAL$))
;;;	(setq CG_Hikite     (nth 64 CG_GLOBAL$))

	(cond
		((= &Tenaki_ID 0)
		 	;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
			(setq #qry$
			 	(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"               &hinban 'STR)
						(list "LR区分"                 &LR     'STR)
						(list "扉シリ記号" CG_DRSeriCode 'STR);2008/09/12 YM MOD 収納対応
						(list "扉カラ記号" CG_DRColCode  'STR);2008/09/12 YM MOD 収納対応
						(list "引手記号"   CG_Hikite     'STR);2008/09/12 YM MOD 収納対応
					)
				)
			)
		 	(if (= nil #qry$)
				(progn ;吊戸の場合ﾋｷﾃ記号なしで検索しなければいけない
				 	;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
					(setq #qry$
					 	(CFGetDBSQLRec CG_DBSESSION "品番最終"
							(list
								(list "品番名称"               &hinban 'STR)
								(list "LR区分"                 &LR     'STR)
								(list "扉シリ記号" CG_DRSeriCode 'STR);2008/09/12 YM MOD 収納対応
								(list "扉カラ記号" CG_DRColCode  'STR);2008/09/12 YM MOD 収納対応
							)
						)
					)
				)
			);_if
		 	(if (= nil #qry$)
				(progn ;吊戸の場合ﾋｷﾃ記号なしで検索しなければいけない
				 	;品番,LR,扉ｼﾘ,扉ｶﾗ,ﾋｷﾃ
					(setq #qry$
					 	(CFGetDBSQLRec CG_DBSESSION "品番最終"
							(list
								(list "品番名称"               &hinban 'STR)
								(list "LR区分"                 &LR     'STR)
							)
						)
					)
				)
			);_if
	 	)
		((= &Tenaki_ID 1)
		 	;品番,LR
			(setq #qry$
			 	(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"               &hinban 'STR)
						(list "LR区分"                 &LR     'STR)
					)
				)
			)
	 	)
		((= &Tenaki_ID 2)
		 	;品番,LR,ｶﾞｽ種
			;2010/11/08 YM ADD-S 展開図作成で落ちる

;2014/05/29 YM DEL ガス種はグローバルを見る
;;;		 	(if CG_GLOBAL$
;;;				(setq #GAS (nth 24 CG_GLOBAL$))
;;;				;else
				(setq #GAS CG_GasType);最後にﾌﾟﾗﾝ検索したもの
;;;			);_if

			;2010/11/08 YM ADD-E

			(setq #qry$
			 	(CFGetDBSQLRec CG_DBSESSION "品番最終"
					(list
						(list "品番名称"               &hinban 'STR)
						(list "LR区分"                 &LR     'STR)
;2010/11/08 YM MOD-S
;;;						(list "ガス種"     (nth 24 CG_GLOBAL$) 'STR)
						(list "ガス種"     #GAS                'STR)
;2010/11/08 YM MOD-E
					)
				)
			)
	 	)
		(T ;それ以外
			(setq #qry$ nil)
	 	)
	);_cond
		 
	(if (and #qry$ (= (length #qry$) 1))
		(progn ;1件HIT
			(setq #ret (car #qry$))
		)
		(progn
			(setq #ret nil)
		)
	);_if

	#ret
);GetLast_Rec



;;;<HOM>************************************************************************
;;; <関数名>  : GetTenkaiID
;;; <処理概要>: [品番基本]を検索して展開IDを取得
;;; <戻り値>  : 展開ID
;;;             2008/08/07 YM ADD
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun GetTenkaiID (
  &hinban
  /
	#QRY$ #RET
  )
	(setq #qry$
	 	(CFGetDBSQLRec CG_DBSESSION "品番基本"
			(list
				(list "品番名称" &hinban 'STR)
			)
		)
	)
	(if (and #qry$ (= (length #qry$) 1))
		(progn ;1件HIT
			(setq #ret (nth 4 (car #qry$)))  ;実数
			(setq #ret (fix (+ #ret 0.0001)));整数
		)
		;else
		(setq #ret nil)
	);_if
	#ret
);GetTenkaiID

;;;<HOM>*************************************************************************
;;; <関数名>    : PKResetWTSETdim$
;;; <処理概要>  : WT材質からWT品名を求める
;;; <引数>      : WT材質
;;; <戻り値>    : WT品名
;;; <作成日>    : 03/01/28 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KPGetWTHinmei (
	&zai ; WT材質
  /
	#NAME #QRY$ #SQL
  )
  (setq #sql (strcat "select * from WT材質 where 材質記号='" &zai "'"))
  (setq #qry$ (DBSqlAutoQuery CG_DBSESSION #sql))
	(setq #qry$ (DBCheck #qry$ "『WT材質』" "KPGetWTHinmei"))
  (setq #name (strcat (nth 4 #qry$) SKW_WT_NAME));2008/07/29 YM MOD
	#name
);KPGetWTHinmei

;<HOM>*************************************************************************
; <関数名>    : SKB_MakeBalNo
; <処理概要>  : バルーン番号を作成配置する
; <戻り値>    :
; <作成>      : 2000-01-12
; <備考>      :
;*************************************************************************>MOH<
(defun SKB_MakeBalNo (
    &en    ;(ENAME)点の図形名
    &no    ;(STR)表示文字
    /
    #en
    #eg #eg2 #gnam
    #pt1 #pt2
    #210 #300 #330
    #cir
    #ss
    #lay
    #z
  )

  (setq #ss (ssadd))
  (setq #eg (entget &en))
  (setq #330 (cdr (assoc 330 #eg)))
  (setq #eg2 (entget #330))
  (setq #gnam (SKGetGroupName &en))

  (setq #pt1 (cdr (assoc 10 #eg)))
  (setq #lay (cdr (assoc 8 #eg)))
  (setq #210 (cdr (assoc 210 #eg)))

  (setvar "CLAYER" #lay)

  ;// バルーンの円を作図
  (command "_.circle" #pt1 CG_REF_SIZE)

  (setq #ss (ssadd (entlast) #ss))
  (setq #eg (entget (entlast)))
  (setq #eg (subst (cons 210 #210) (assoc 210 #eg) #eg))
  (entmod #eg)

  (setq #pt2 (trans #pt1 1 (entlast)))
  (entmod (subst (cons 10 #pt2) (assoc 10 #eg) #eg))

  ;// バルーン内の数文字を作図
  (command "_.text" "S" "REF_NO" "J" "MC" #pt2 "" &no)
  (setq #ss (ssadd (entlast) #ss))
  (setq #eg (entget (entlast)))
  (setq #eg (subst (cons 210 #210) (assoc 210 #eg) #eg))
  (entmod #eg)
  (entmod (subst (cons 10 #pt2) (assoc 10 #eg) #eg))

  ;// ブロック化
  (CFublock #pt1 #ss)

  (command "_.-group" "A" #gnam (entlast) "")
)
;SKB_MakeBalNo

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_GetWKTopList
;;; <処理概要>: ワークトップの仕様詳細情報を取得する
;;; <戻り値>  :
;;;               ; 1.ソートキー
;;;               ; 2.最終品番
;;;					      ; 3.巾
;;;					      ; 4.高さ
;;;					      ; 5.奥行
;;;					      ; 6.品名
;;;               ; 7.個数
;;;               ; 8.金額
;;;               ; 9.集約ID  天板,ｶｳﾝﾀｰはきめうち"A10"
;;;               ;10.図形ハンドル
;;;************************************************************************>MOH<
(defun SKB_GetWKTopList (
  /
	#DDD #EN #HHH #HINMEI #HND #I #KAKAKU #LAST_HIN #LST$$ #MAG #MAG$ #SS #WT$ #WWW #XD$
#TOKU_CD	;-- 2011/12/12 A.Satoh Add
  )
  (setq CG_FuncName "\nSKB_GetWKTopList")

  ;// ワークトップを検索する
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (/= #ss nil)
    (progn
			; 間口でｿｰﾄする 01/07/05 YM ADD START
      (setq #i 0 #WT$ nil)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        ;// 拡張データを取得
        (setq #xd$ (CFGetXData #en "G_WRKT"))
        ;// 間口
        (setq #MAG$ (nth 55 #xd$))
        (setq #MAG  (car #MAG$))
				(setq #WT$ (append #WT$ (list (list #MAG #en))))
        (setq #i (1+ #i))
			)
			(setq #WT$ (CFListSort #WT$ 0))
			(setq #WT$ (reverse #WT$))
			; 間口でｿｰﾄする 01/07/05 YM ADD END

      (setq #i 0)
      (repeat (length #WT$)
        (setq #en (cadr (nth #i #WT$)))
        ;// 拡張データを取得
        (setq #xd$ (CFGetXData #en "G_WTSET"))
        (setq #LAST_HIN (nth 1 #xd$));最終品番
        (setq #KAKAKU   (nth 3 #xd$));金額
        (setq #HINMEI   (nth 4 #xd$));品名
        (setq #WWW      (nth 5 #xd$));巾
        (setq #HHH      (nth 6 #xd$));高さ
        (setq #DDD      (nth 7 #xd$));奥行
;-- 2011/12/12 A.Satoh Add - S
				(setq #TOKU_CD  (nth 8 #xd$));特注コード
;-- 2011/12/12 A.Satoh Add - E

        ;// ワークトップハンドル
        (setq #hnd (cdr (assoc 5 (entget #en))))
        ;// ワークトップの情報リストを格納
        (setq #lst$$
          (cons
            (list
              #i              ; 1.ソートキー
              #LAST_HIN       ; 2.最終品番
							#WWW            ; 3.巾
							#HHH            ; 4.高さ
							#DDD            ; 5.奥行
							#HINMEI         ; 6.品名
              1               ; 7.個数
              #KAKAKU         ; 8.金額
              "A10"           ; 9.集約ID  天板,ｶｳﾝﾀｰはきめうち"A10"
              (list #hnd)     ;10.図形ハンドル
;-- 2011/12/12 A.Satoh Add - S
              ""
              "A"
							#TOKU_CD				;13.特注コード
							(if (= (nth 0 #xd$) 0)
								1
								0
							)
;-- 2011/12/12 A.Satoh Add - E
            )
            #lst$$
          )
        )
        (setq #i (1+ #i))
      )
    )
  )

  ;// ワークトップの情報リストを返す
  #lst$$
)
;;;SKB_GetWKTopList

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_GetBackGuardList
;;; <処理概要>: バックガードの仕様詳細情報を取得する
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                  1.ソートキー
;;;                  2.ワークトップ品番名称
;;;                  3.図形ハンドル
;;;                  4.入力配置用品番名称
;;;                  5.出力名称コード
;;;                  6.仕様名称コード
;;;                  7.個数
;;;                  8.金額
;;;                  9.寸法
;;;                 10.部材種類フラグ(4:バックガード)
;;;                 11.集約ID
;;;               )
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKB_GetBackGuardList (
  /
  #ss
  #en
  #xd$
  #wname
  #hnd
  #lst$$
  #i
  #flg
  #sDim
  )
  (setq CG_FuncName "\nSKB_GetBackGuardList")

  ;// バックガードを検索する
  (setq #ss (ssget "X" '((-3 ("G_BKGD")))))
  (if (/= #ss nil)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en    (ssname #ss #i))
        (setq #xd$   (CFGetXData #en "G_BKGD"))
        (setq #wname (nth 0 #xd$))                ; 品番名称
        (setq #hnd   (cdr (assoc 5 (entget #en))))  ; 図形ハル
	;00/08/10 SN MOD 段差ﾌﾟﾗﾝ18Hの時は高さ150
	(if (equal "18H" (substr #wname 6 3))
          (setq #sDim  (strcat (rtos (nth 3 #xd$) 2 0) "x 20x150"))
          (setq #sDim  (strcat (rtos (nth 3 #xd$) 2 0) "x 20x 50"))
	)

        ;// ワークトップの情報リストを格納
        (setq #lst$$
          (cons
            (list
              #i              ; 1.ソートキー
              #wname          ; 2.BG品番名称
              (list #hnd)     ; 3.図形ハンドル
              #wname          ; 4.入力配置用品番名称
              1               ; 5.出力名称コード
              -1              ; 6.仕様名称コード
              1               ; 7.個数
              (nth 4 #xd$)    ; 8.金額
              #sDim           ; 9.寸法
              "4"             ;10.部材種類フラグ
              1               ;11.集約ID
            )
            #lst$$
          )
        )
        (setq #i (1+ #i))
      )
    )
  )

  ;// バックガードの情報リストを返す
  #lst$$
)
;;;SKB_GetBackGuardList

;小数点以下切上げ
(defun CfFix2 (
  &fNum
  /
  #iNum
  )
  (if (equal &fNum (fix &fNum) 0.001)
    (setq #iNum     (fix &fNum) )
    (setq #iNum (1+ (fix &fNum)))
  )

  #iNum
)
;00/09/22 SN ADD
;無条件に小数点以下切上げ
(defun CfFix3 (
  &fNum
  /
  #iNum
  )
  (if (= &fNum (fix &fNum))
    (setq #iNum     (fix &fNum) )
    (setq #iNum (1+ (fix &fNum)))
  )

  #iNum
)

(defun CfGetLWPolyLineLen (
  &en
  /
  #fLen
  #pt$
  )
  (setq #fLen 0.0)

  (setq #pt$ (GetLWPolyLinePt &en))
  (repeat (1- (length #pt$))
    (setq #fLen (+ #fLen (distance (car #pt$) (cadr #pt$))))
    (setq #pt$ (cdr #pt$))
  )

  #fLen
)


;;;<HOM>************************************************************************
;;; <関数名>  : SKB_GetFillerInfo
;;; <処理概要>: 天井処理関連アイテムの仕様詳細情報を取得する
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                  1.ソートキー
;;;                  2.品番名称
;;;                  3.図形ハンドル群
;;;                  4.入力配置用品番名称
;;;                  5.出力名称コード
;;;                  6.仕様名称コード
;;;                  7.個数
;;;                  8.金額
;;;                  9.品コード
;;;                 10.アイテム種類(0:標準 1:特注WT 2:天井関連 3:補足)
;;;                 11.集約ID
;;;               )
;;;               …
;;;             )
;;; <備考>    : 01/01/12 HN 新規作成
;;;************************************************************************>MOH<
(defun SKB_GetFillerInfo (
  /
;-- 2011/12/12 A.Satoh Mod - S
;;;;;  #sKind      ; アイテム種類
;;;;;  #Flr$       ; アイテム情報
;;;;;  #FlrN$      ; アイテム情報
;;;;;  #Flr$$      ; アイテム情報群
;;;;;  #fLen       ; 天井アイテム長さ
;;;;;  #fLen1      ; 天井アイテム単品長さ
;;;;;  #fLen2      ; 天井アイテム単品長さ(２枚セット)
;;;;;  #fLen3      ; 天井アイテム単品長さ(×２)
;;;;;  #iType      ; 天井アイテム種類
;;;;;  #iCnt       ; ループカウンタ
;;;;;  #iCnt1      ; 天井アイテム個数
;;;;;  #iCnt2      ; 天井アイテム個数(２枚セット)
;;;;;  #xFlr       ; アイテム選択セット
;;;;;  #eName      ; 図形名
;;;;;  #sHnd       ; 図形ハンドル
;;;;;  #sHnd$      ; 図形ハンドル群
;;;;;  #eed$       ; 拡張データ
;;;;;  #sCode      ; 品番名称
;;;;;  #sCode2     ; 品番名称(２枚セット)
;;;;;  #rec$       ; 品番図形レコード
;;;;;  #rec2$      ; 品番図形レコード(２枚セット)
;;;;;  #out$       ; 出力情報
;;;;;  #out$$      ; 出力情報群
	#sKind #Flr$$ #iCnt #fLen #out$$ #xFlr #eName #sHnd #eed$ #sCode
	#iType #bunrui #xdOPT$ #kosu #Flr$ #idx #upd_flg #wk_flr1$ #sHnd$
	#FlrN$ #rec$
;-- 2011/12/12 A.Satoh Mod - E
  )

  (setq #sKind "2") ; 天井関連(固定)
  (setq #Flr$$ nil)
  (setq #iCnt  0  )
  (setq #fLen  0.0)
  (setq #out$$ nil)

  ;//
  ;// 天井関連の図形を検索
  ;//
  (setq #xFlr (ssget "X" (list (list -3 (list "G_FILR")))))
  (if #xFlr
    (repeat (sslength #xFlr)
      (setq #eName (ssname #xFlr #iCnt))
      (setq #sHnd  (cdr (assoc 5 (entget #eName))))
      (setq #eed$  (CFGetXData #eName "G_FILR"))
      (setq #sCode                     (nth 0 #eed$))
      (setq #iType                     (nth 3 #eed$))
      (if (/= 7 #iType)
        (setq #fLen  (CfGetLWPolyLineLen (nth 2 #eed$)))
        (setq #fLen  (nth 4 #eed$))
      )
;-- 2011/12/12 A.Satoh Add - S
      ; 分類の取得
      (if (= (length #eed$) 8)
        (setq #bunrui (nth 7 #eed$))
        (setq #bunrui "A") ; キッチン("A")固定
      )

      ; 個数取得
      (setq #xdOPT$ (CFGetXData #eName "G_OPT"))
      (if #xdOPT$
        (setq #kosu (1+ (nth 2 #xdOPT$)))
        (setq #kosu 1)
      )
;-- 2011/12/12 A.Satoh Add - E

;-- 2011/12/12 A.Satoh Mod - S
;;;;;      ;// #iType
;;;;;      ;// 1:天井ﾌｨﾗｰ 2:支輪 3:飾り縁 4:ｹｺﾐ飾り 5:幅木 6:ｱｲﾚﾍﾞﾙﾊﾝｶﾞｰｼｽﾃﾑの飾り縁 7:壁処理用ｽﾍﾟｰｻｰ
;;;;;
;;;;;      ;// 同一品番がない場合、リストに新規登録
;;;;;      ;// 同一品番がある場合、長さと図形ハンドルを加算して更新
;;;;;      (setq #Flr$ (assoc #sCode #Flr$$))
;;;;;      (if (= nil #Flr$)
;;;;;        (progn
;;;;;          (setq #Flr$  (list #sCode #iType #fLen (list #sHnd)))
;;;;;          (setq #Flr$$ (cons #Flr$ #Flr$$))
;;;;;        )
;;;;;        (progn
;;;;;          (setq #fLen  (+ #fLen    (nth 2 #Flr$)))
;;;;;          (setq #sHnd$ (cons #sHnd (nth 3 #Flr$)))
;;;;;          (setq #FlrN$ (list #sCode #iType #fLen #sHnd$))
;;;;;          (setq #Flr$$ (subst #FlrN$ #Flr$ #Flr$$))
;;;;;        )
;;;;;      )
      ; 同一品番が無い又は同一品番はあるが分類区分が異なる場合は、リストに新規登録
      ; 同一品番があり、分類区分が同じであれば個数を加算して更新
      (if (= #Flr$$ nil)
        (progn
          (setq #Flr$  (list #sCode #iType #fLen (list #sHnd) #kosu #bunrui))
          (setq #Flr$$ (cons #Flr$ #Flr$$))
        )
        (progn
          (setq #idx 0)
          (setq #upd_flg nil)
          (repeat (length #Flr$$)
            (if (= #upd_flg nil)
              (progn
                (setq #wk_flr1$ (nth #idx #Flr$$))
                (if (and (= #sCode (nth 0 #wk_flr1$)) (= #bunrui (nth 5 #wk_flr1$)))
                  (progn
                    (setq #wk_flr$ #wk_flr1$)
                    (setq #upd_flg T)
                  )
                )
              )
            )
            (setq #idx (1+ #idx))
          )

          (if (= #upd_flg T)
            (progn
              (setq #fLen  (+ #fLen    (nth 2 #wk_flr$)))
              (setq #sHnd$ (cons #sHnd (nth 3 #wk_flr$)))
              (setq #kosu  (+ #kosu    (nth 4 #wk_flr$)))
              (setq #FlrN$ (list #sCode #iType #fLen #sHnd$ #kosu #bunrui))
              (setq #Flr$$ (subst #FlrN$ #wk_flr$ #Flr$$))
            )
            (progn
              (setq #Flr$  (list #sCode #iType #fLen (list #sHnd) #kosu #bunrui))
              (setq #Flr$$ (cons #Flr$ #Flr$$))
            )
          )
        )
      )
;-- 2011/12/12 A.Satoh Mod - E

      (setq #iCnt (1+ #iCnt))
    ) ;repeat
  ) ; #xFlr


  ;//
  ;// アイテムごとに個数計算
  ;//

  (foreach #Flr$ #Flr$$
    (setq #sCode (nth 0 #Flr$))
    (setq #iType (nth 1 #Flr$))
;-- 2011/12/12 A.Satoh Mod - S
;;;;;    (setq #fLen  (nth 2 #Flr$))
;-- 2011/08/11 A.Satoh Add - S
    (setq #kosu  (nth 4 #Flr$))
    (setq #bunrui (nth 5 #Flr$))
;-- 2011/12/12 A.Satoh Mod - E
    (setq #sHnd$ (nth 3 #Flr$))

    ;// 品番基本テーブルからアイテム単品の長さを取得
    (setq #rec$ (CFGetDBSQLHinbanTableChk "品番図形" #sCode (list (list "品番名称" #sCode 'STR))))
;-- 2011/12/12 A.Satoh Mod - S
    (if #rec$
      (setq #out$$ (cons (list #sCode (nth 1 #rec$) #bunrui #sHnd$ #kosu #sKind "" 0 "") #out$$))
    )
;;;;;    (if #rec$
;;;;;      (if (= 7 #iType)
;;;;;        (setq #fLen1 (nth 5 #rec$)) ; 壁処理用スペーサー ;2008/06/28 OK!
;;;;;        (setq #fLen1 (nth 3 #rec$)) ; その他             ;2008/06/28 OK!
;;;;;      )
;;;;;    )
;;;;;
;;;;;    ;01/02/13 HN S-ADD 天井フィラーの見積り枚数設定を追加
;;;;;    (if (< 0 CG_FillerNum)
;;;;;      (setq #fLen (* #fLen1 CG_FillerNum))
;;;;;    )
;;;;;    ;01/02/13 HN E-ADD 天井フィラーの見積り枚数設定を追加
;;;;;
;;;;;    ;// ２枚セットがあれば、品番基本テーブルからアイテム単品の長さを取得
;;;;;    (setq #sCode2 nil)
;;;;;    (setq #fLen2  0.0)
;;;;;    (setq #fLen3  0.0)
;;;;;    
;;;;;
;;;;;    (setq #iCnt1 0)
;;;;;    (setq #iCnt2 0)
;;;;;    (if (< 0.0 #fLen2)
;;;;;      (while (< 0.0 #fLen)
;;;;;        (cond
;;;;;          ((>= #fLen1 #fLen)
;;;;;            (setq #iCnt1 (+ 1 #iCnt1))
;;;;;            (setq #fLen  0.0)
;;;;;          )
;;;;;          ((>= #fLen2 #fLen)
;;;;;            (setq #iCnt2 (+ 1 #iCnt2))
;;;;;            (setq #fLen  0.0)
;;;;;          )
;;;;;          ((>= #fLen3 #fLen)
;;;;;            (setq #iCnt1 (+ 2 #iCnt1))
;;;;;            (setq #fLen  0.0)
;;;;;          )
;;;;;          (T
;;;;;            (setq #iCnt2 (+ 1     #iCnt2))
;;;;;            (setq #fLen  (- #fLen #fLen2))
;;;;;          )
;;;;;        )
;;;;;      )
;;;;;      (while (< 0.0 #fLen)
;;;;;        (cond
;;;;;          ((>= #fLen1 #fLen)
;;;;;            (setq #iCnt1 (+ 1 #iCnt1))
;;;;;            (setq #fLen  0.0)
;;;;;          )
;;;;;          (T
;;;;;            (setq #iCnt1 (+ 1     #iCnt1))
;;;;;            (setq #fLen  (- #fLen #fLen1))
;;;;;          )
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;
;;;;;
;;;;;		(setq #out$$ (cons (list #sCode  (nth 1 #rec$)  #sHnd$ #iCnt1 #sKind) #out$$))
;;;;;
;-- 2011/12/12 A.Satoh Mod - E
  ) ;foreach



	;SCB_GetDetailList　に渡す形式
	;#bzlst$$
	;例 ("H$030WFB-7%#-@@[J:BW]" "L" ("4937") 1 "0")

  ;// 天井フィラーの詳細情報を取得
  (if #out$$
    (reverse (SCB_GetDetailList #out$$))

  )
);SKB_GetFillerInfo

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_GetHosokuInfo
;;; <処理概要>: 補足部材の仕様詳細情報を取得
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                  1.ソートキー
;;;                  2.品番名称
;;;                  3.図形ハンドル
;;;                  4.入力配置用品番名称
;;;                  5.出力名称コード
;;;                  6.仕様名称コード
;;;                  7.個数
;;;                  8.金額
;;;                  9.品コード
;;;                 10.部材種類フラグ
;;;                    (0:標準部材 1:特注WT 2:天井フィラー 3:補足部材)
;;;                 11.集約ID
;;;               )
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKB_GetHosokuInfo (
  /
;-- 2011/12/12 A.Satoh Mod - S
;;;;;  #xrec$
;;;;;  #i
;;;;;  #hin
;;;;;  #num
;;;;;  #fig$
;;;;;  #lst$$
  #lst$$ #lst$ #fname #spec$$ #spec$ #hinban #num #name #bunrui #fig$
;-- 2011/12/12 A.Satoh Mod - E
#qry$ #syuyaku ;-- 2012/02/09 A.Satoh Add
  )
  (setq CG_FuncName "\nSKB_GetHosokuInfo")

;-- 2011/12/12 A.Satoh Mod - S
  (setq #lst$$ nil)

  ; HOSOKU.cfgの読込
  (setq #fname (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
  (if (findfile #fname)
    (progn
      (setq #spec$$ (ReadCSVFile #fname))
      (if #spec$$
        (foreach #spec$ #spec$$
          (setq #hinban (nth 0 (StrParse (nth 0 #spec$) "=")))
          (setq #num (atoi (nth 1 (StrParse (nth 0 #spec$) "="))))
          (setq #name (nth 1 #spec$))
          (setq #bunrui (nth 2 #spec$))
          (if (> (strlen #bunrui) 1)
            (setq #bunrui (substr #bunrui 1 1))
          )

          ; 品番基本テーブルからｵﾌﾟｼｮﾝ品情報を取得
          (setq #fig$ (car (CFGetDBSQLHinbanTable "品番基本" #hinban (list (list "品番名称" #hinban 'STR)))))
          (if (/= #fig$ nil)
            (progn
;-- 2012/02/09 A.Satoh Add - S
							(if (and (= (nth 2 #spec$) "D") (= (substr (nth 5 #fig$) 1 1) "A"))
								(progn
									(setq #qry$
										(car (CFGetDBSQLHinbanTable "集約ID変換" #hinban
										(list (list "品番名称" #hinban 'STR))))
									)

									(if (/= #qry$ nil)
										(setq #syuyaku (nth 1 #qry$))
										(setq #syuyaku (nth 5 #fig$))
									)
								)
								(setq #syuyaku (nth 5 #fig$))
							)
;-- 2012/02/09 A.Satoh Add - E

              (setq #lst$
                (list
                  (fix (nth 2 #fig$))  ;  1.ソートキー
                  #hinban              ;  2.品番名称
                  (list "")            ;  3.図形ハンドル
                  "Z"                  ;  4.L/R
                  0                    ;  5.出力名称コード
                  0                    ;  6.仕様名称コード
                  #num                 ;  7.個数
                  0                    ;  8.金額(見積り処理で取得)
                  "xxxxxxx"            ;  9.品コード
                  "3"                  ; 10.部材種類フラグ
;-- 2012/02/09 A.Satoh Mod - S
;;;;;                  (nth 5 #fig$)        ; 11.集約ID
									#syuyaku             ; 11.集約ID
;-- 2012/02/09 A.Satoh Mod - E
									""
									0
                )
              )
              (setq #lst$$ (append #lst$$ (list #lst$)))
            )
          )
        )
      )
    )
  )
;;;;;  ;// 補足部材の品番と個数を取得する
;;;;;  (setq #xrec$ (CFGetXRecord "SUB_PARTS"))
;;;;;  (setq #i 0)
;;;;;  (repeat (/ (length #xrec$) 2)
;;;;;    (setq #hin (nth #i #xrec$))
;;;;;    (setq #num (nth (+ #i 1) #xrec$))
;;;;;    ;// 品番基本テーブルから情報を取得
;;;;;    (setq
;;;;;      #fig$
;;;;;      (CFGetDBSQLHinbanTableChk "品番基本"
;;;;;        #hin
;;;;;        (list (list "品番名称" #hin 'STR))
;;;;;      )
;;;;;    )
;;;;;    (if (= #fig$ nil)
;;;;;      (progn
;;;;;        (princ "\n補足部材:[")
;;;;;        (princ #hin)
;;;;;        (princ "]の品番関連情報がありません")
;;;;;      )
;;;;;      (progn
;;;;;        (setq #lst$$
;;;;;          (append #lst$$
;;;;;            (list
;;;;;              (list
;;;;;                ""                 ;1.工種記号
;;;;;                ""                 ;2.SERIES記号
;;;;;                #hin               ;3.品番名称
;;;;;                (nth 2 #fig$)      ;4.入力配置用品番名称
;;;;;                (list "")          ;5.図形ハンドルは、なし
;;;;;                #num               ;6.補足部材の数
;;;;;                "3"                ;7.部材種類フラグ
;;;;;              )
;;;;;            )
;;;;;          )
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;    (setq #i (+ #i 2))
;;;;;  )
;;;;;  ;// 補足部材の詳細情報を取得する
;;;;;  (if (/= #lst$$ nil)
;;;;;    (reverse (SCB_GetDetailList #lst$$))
;;;;;;;;01/07/19YM@    (reverse (SCB_GetDetailList #lst$$ 0))
;;;;;    nil
;;;;;  )
;-- 2011/12/12 A.Satoh Mod - E
);SKB_GetHosokuInfo

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_GetOptionInfo
;;; <処理概要>: オプション部材の仕様詳細情報を取得
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                  1.ソートキー
;;;                  2.品番名称
;;;                  3.図形ハンドル
;;;                  4.入力配置用品番名称
;;;                  5.出力名称コード
;;;                  6.仕様名称コード
;;;                  7.個数
;;;                  8.金額
;;;                  9.品コード
;;;                 10.部材種類フラグ
;;;                    (0:標準部材 1:特注WT 2:天井フィラー 3:補足部材)
;;;                 11.集約ID
;;;               )
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKB_GetOptionInfo (
  /
;-- 2011/12/12 A.Satoh Mod - S
;;;;;  #ss
;;;;;  #sslen
;;;;;  #sym
;;;;;  #xd$
;;;;;  #xd2$
;;;;;  #i
;;;;;  #hin
;;;;;  #num
;;;;;  #fig$
;;;;;  #lst$$ #hand #LR_oya
;;;;;#OYA_FIG$ #OYA_HINBAN #XDLSYM$ #ORG_OPT #ORG_OPT #TOKU_OPT #TOKU_OPT$$ #XDOPT2$ ; 03/06/14 YM ADD
;;;;;#KAKAKU ; 03/06/14 YM ADD
;;;;;#Err_msg ; 04/01/09 YM ADD
  #ss #sslen #i #sym #xdLSYM$ #oya_hinban #LR_oya #hand #xd$ #xd2$
  #hin #num #fig$ #lst$$ #xdFILR$
;-- 2011/12/12 A.Satoh Mod - E
#qry$ #syuyaku ;-- 2012/02/09 A.Satoh Add
  )
  (setq CG_FuncName "\nSKB_GetOptionInfo")

;-- 2011/12/12 A.Satoh Mod - S
  ; G_OPTを持つ設備部材を検索
  (setq #ss (ssget "X" '((-3 ("G_OPT")))))
  (if (= nil #ss)
    (setq #sslen 0)
    (setq #sslen (sslength #ss))
  )

  (setq #i 0)
  (repeat #sslen
    (setq #sym (ssname #ss #i))
    (setq #xdFILR$ (CFGetXData #sym "G_FILR"))
    (if (= #xdFILR$ nil)  ; 2個以上の天井フィラーを対象外に
      (progn
        (setq #xdLSYM$ (CFGetXData #sym "G_LSYM"))

        ; 親図形品番
        (if #xdLSYM$
          (setq #oya_hinban (nth 5 #xdLSYM$))
          (setq #oya_hinban "")
        )

        ; L/R区分
        (if #xdLSYM$
          (setq #LR_oya (nth 6 #xdLSYM$))
          (setq #LR_oya "Z")
        )

        (setq #hand (cdr (assoc 5 (entget #sym))))
        (setq #xd$  (CFGetXData #sym "G_OPT"))

        (setq #xd2$ #xd$)
        (repeat (car #xd$)
          (setq #xd2$ (cdr #xd2$))
          (setq #hin  (car #xd2$))  ;品番
          (setq #xd2$ (cdr #xd2$))
          (setq #num  (car #xd2$))  ;個数

          ;// 品番基本テーブルからｵﾌﾟｼｮﾝ品情報を取得
          (setq #fig$ (car (CFGetDBSQLHinbanTable "品番基本" #hin (list (list "品番名称" #hin 'STR)))))
;-- 2012/02/09 A.Satoh Mod - S
					(if (/= #fig$ nil)
						(progn
							(if (and #xdLSYM$ (= (nth 15 #xdLSYM$) "D") (= (substr (nth 5 #fig$) 1 1) "A"))
								(progn
									(setq #qry$
										(car (CFGetDBSQLHinbanTable "集約ID変換" #hin
										(list (list "品番名称" #hin 'STR))))
									)

									(if (/= #qry$ nil)
										(setq #syuyaku (nth 1 #qry$))
										(setq #syuyaku (nth 5 #fig$))
									)
								)
								(setq #syuyaku (nth 5 #fig$))
							)

							(setq #lst$$
								(append #lst$$
									(list
										(list
											(fix (nth 2 #fig$))             ; 1.ソートキー
											(KP_DelHinbanKakko #hin)        ; 2.品番名称 ()外す
											(list "")                       ; 3.図形ハンドル
											(if (equal (nth 1 #fig$) 1 0.1) ; 4.L/R
												#LR_oya                       ;   親図形のLR
												"Z"                           ;   LRなし
											)
											0                               ; 5.出力名称コード
											0                               ; 6.仕様名称コード
											#num                            ; 7.個数
											0                               ; 8.金額(見積り処理で取得)
											"xxxxxxx"                       ; 9.品コード
											"3"                             ;10.部材種類フラグ
											#syuyaku                   			;11.集約ID
											(nth 15 #xdLSYM$)               ;12.分類
											""
											0
										)
									)
								)
							)
						)
					)
;;;;;          (if (= #fig$ nil)
;;;;;            nil
;;;;;            (setq #lst$$
;;;;;              (append #lst$$
;;;;;                (list
;;;;;                  (list
;;;;;                    (fix (nth 2 #fig$))             ; 1.ソートキー
;;;;;                    (KP_DelHinbanKakko #hin)        ; 2.品番名称 ()外す
;;;;;                    (list "")                       ; 3.図形ハンドル
;;;;;                    (if (equal (nth 1 #fig$) 1 0.1) ; 4.L/R
;;;;;                      #LR_oya                       ;   親図形のLR
;;;;;                      "Z"                           ;   LRなし
;;;;;                    )
;;;;;                    0                               ; 5.出力名称コード
;;;;;                    0                               ; 6.仕様名称コード
;;;;;                    #num                            ; 7.個数
;;;;;                    0                               ; 8.金額(見積り処理で取得)
;;;;;                    "xxxxxxx"                       ; 9.品コード
;;;;;                    "3"                             ;10.部材種類フラグ
;;;;;                    (nth 5 #fig$)                   ;11.集約ID
;;;;;                    (nth 15 #xdLSYM$)               ;12.分類
;;;;;										""
;;;;;										0
;;;;;                  )
;;;;;                )
;;;;;              )
;;;;;            )
;;;;;          )
;-- 2012/02/09 A.Satoh Mod - E
        )
      )
    )
    (setq #i (+ #i 1))
  )
;;;;;  ;// G_OPTを持つ設備部材を検索
;;;;;  (setq #ss (ssget "X" '((-3 ("G_OPT")))))
;;;;;  (if (= nil #ss)
;;;;;    (setq	#sslen 0)
;;;;;    (setq	#sslen (sslength #ss))
;;;;;  )
;;;;;  (setq #i 0)
;;;;;  (repeat #sslen
;;;;;    (setq #sym (ssname #ss #i))
;;;;;		(setq #xdLSYM$ (CFGetXData #sym "G_LSYM"))
;;;;;		;03/06/14 YM ADD-S
;;;;;		(if #xdLSYM$
;;;;;			(setq #oya_hinban (nth 5 #xdLSYM$)) ; 親図形品番
;;;;;			(setq #oya_hinban "") ; 親図形品番
;;;;;		);_if
;;;;;		;03/06/14 YM ADD-E
;;;;;		(if #xdLSYM$
;;;;;			(setq #LR_oya (nth 6 #xdLSYM$)); 01/07/19 YM ADD 親図形のLR
;;;;;			(setq #LR_oya "Z") ; ｼﾝﾎﾞﾙをもたない"G_OPT"
;;;;;		);_if
;;;;;		(setq #hand (cdr (assoc 5 (entget #sym))))
;;;;;    (setq #xd$     (CFGetXData #sym "G_OPT"))
;;;;;
;;;;;    (setq #xd2$ #xd$)
;;;;;    (repeat (car #xd$)
;;;;;      (setq #xd2$ (cdr #xd2$))
;;;;;      (setq #hin  (car #xd2$))  ;品番
;;;;;      (setq #xd2$ (cdr #xd2$))
;;;;;      (setq #num  (car #xd2$))  ;個数
;;;;;
;;;;;      ;// 品番基本テーブルからｵﾌﾟｼｮﾝ品情報を取得
;;;;;      (setq #fig$
;;;;;        (car (CFGetDBSQLHinbanTable "品番基本" #hin
;;;;;       		   (list (list "品番名称" #hin 'STR)))
;;;;;      ))
;;;;;      (if (= #fig$ nil)
;;;;;        (progn
;;;;;					nil
;;;;;;;;					(setq #Err_msg (strcat "以下の品番がﾃﾞｰﾀﾍﾞｰｽに存在しませんでした。\n" #hin
;;;;;;;;																 "\n現在のﾃﾞｰﾀﾍﾞｰｽが古い可能性があります。"
;;;;;;;;																 "\n★新しい情報で見積した場合、明細に表示されませんのでご注意ください。"))
;;;;;;;;					(CFAlertErr #Err_msg)
;;;;;        )
;;;;;        (progn
;;;;;
;;;;;          (setq #lst$$
;;;;;            (append #lst$$
;;;;;              (list
;;;;;                (list
;;;;;									(fix (nth 2 #fig$))            ; 1.ソートキー
;;;;;									(KP_DelHinbanKakko #hin)       ; 2.品番名称 ()外す
;;;;;									(list "")                      ; 3.図形ハンドル
;;;;;									(if (equal (nth 1 #fig$) 1 0.1); 4.L/R
;;;;;										#LR_oya            ; 親図形のLR
;;;;;										"Z"                ; LRなし
;;;;;									);_if
;;;;;
;;;;;	               	0             ; 5.出力名称コード
;;;;;	               	0             ; 6.仕様名称コード
;;;;;	                #num          ; 7.個数
;;;;;			            0             ; 8.金額(見積り処理で取得)
;;;;;	                "xxxxxxx"     ; 9.品コード
;;;;;	                "3"           ;10.部材種類フラグ
;;;;;		            	(nth 5 #fig$) ;11.集約ID   2008/07/28 YM MOD  (FIX 削除
;;;;;
;;;;;                )
;;;;;              )
;;;;;            )
;;;;;          )
;;;;;
;;;;;
;;;;;;;;		          (list
;;;;;;;;	            	(fix (nth 2 #qry$)) ; 1.ソートキー
;;;;;;;;               	(KP_DelHinbanKakko (nth 0 #lst$))  ; 2.品番名称 ; 02/01/09 YM ADD ()外す
;;;;;;;;                (nth 2 #lst$)  ; 3.図形ハンドル
;;;;;;;;                (nth 1 #lst$)  ; 4.L/R?
;;;;;;;;               	0  ; 5.出力名称コード
;;;;;;;;               	0  ; 6.仕様名称コード
;;;;;;;;                (nth 3 #lst$)  ; 7.個数
;;;;;;;;		            0             ; 8.金額(見積り処理で取得)
;;;;;;;;                "xxxxxxx"      ; 9.品コード
;;;;;;;;                (nth 4 #lst$)  ;10.部材種類フラグ
;;;;;;;;	            	(nth 5 #qry$)     ;11.集約ID   2008/07/28 YM MOD  (FIX 削除
;;;;;;;;		          )
;;;;;;;;
;;;;;
;;;;;        )
;;;;;      )
;;;;;    );repeat
;;;;;    (setq #i (+ #i 1))
;;;;;  );repeat
;;;;;
;;;;;
;;;;;
;;;;;;2008/08/14 YM DEL
;;;;;;// オプションアイテムの詳細情報を取得する
;;;;;;;;  (if (/= #lst$$ nil)
;;;;;;;;    (reverse (SCB_GetDetailListOPT #lst$$)) ; 専用ﾛｼﾞｯｸ
;;;;;;;;    nil
;;;;;;;;  );_if
;-- 2011/12/12 A.Satoh Mod - E

	#lst$$ ;2008/08/14 YM MOD そのまま返す
);;;SKB_GetOptionInfo

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_GetKekomiInfo
;;; <処理概要>: ケコミ飾りの仕様詳細情報を取得
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                  1.ソートキー
;;;                  2.品番名称
;;;                  3.図形ハンドル(なし)
;;;                  4.入力配置用品番名称
;;;                  5.出力名称コード
;;;                  6.仕様名称コード
;;;                  7.個数
;;;                  8.金額
;;;                  9.品コード
;;;                 10.部材種類フラグ(3:補足部材)
;;;                 11.集約ID
;;;               )
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SKB_GetKekomiInfo (
  /
  #sCode
  #sCode2
  #rec$
  #fSort
  #fWidth
  #iCnt
  #lst$$
  #data$
  #data2$
  )
  (setq CG_FuncName "\nSKB_GetKekomiInfo")
  (if (= nil CG_KekomiW)
    (setq CG_KekomiW 0.0)
  )

  ;00/08/09 SN S-MOD
  ;CG_KekomiFlag=T   且つ CG_KekomiW>0.0 の時ｹｺﾐ飾りを積算
  ;CG_KekomiFlag=nil 且つ CG_KekomiW>0.0 の時足元ｽﾄｯｶｰ用ﾌｨﾗｰﾊﾟｯｷﾝを積算
  (if CG_KekomiFlag
    (progn
      (setq #sCode  "KB-K270V-K" )
      (setq #sCode2 "KB-K270V2-K")
    )
    (progn
      (setq #sCode  "KB-FP270P-K")
      (setq #sCode2 "KB-FP270P-K")
    )
  )
  ;(setq #sCode  "KB-K270V-K" )
  ;(setq #sCode2 "KB-K270V2-K")
  ;00/08/09 SN E-MOD
  ;// 品番基本テーブルから情報を取得
  (setq #rec$ (car (CFGetDBSQLHinbanTable "品番基本" #sCode (list (list "品番名称" #sCode 'STR)))))
  (if (/= nil #rec$)
    (progn
      (setq #fSort (nth 2 #rec$)) ; ソートキー
      (setq #rec$ (car (CFGetDBSQLHinbanTable "品番図形" #sCode (list (list "品番名称" #sCode 'STR)))))
      (if (/= nil #rec$)
        (progn
          (setq #fWidth (nth 3 #rec$)) ; 幅 ;2008/06/28 OK!
          (setq #iCnt (CfFix2 (/ CG_KekomiW #fWidth)))
          (if CG_KekomiFlag
            ;00/08/09 SN ADD ｹｺﾐ飾りの処理
            (progn
              (if (< 1 #iCnt)
                (progn
                  (setq #rec$ (car (CFGetDBSQLHinbanTable "品番基本" #sCode2 (list (list "品番名称" #sCode2 'STR)))))
                  (setq #data2$
                    (list
                      ""              ;1.工種記号
                      ""              ;2.SERIES記号
                      #sCode2         ;3.品番名称
                      (nth 2 #rec$)   ;4.入力配置用品番名称
                      (list "")       ;5.図形ハンドルは、なし
                      (/ #iCnt 2)     ;6.ケコミ飾りの数
                      "3"             ;7.部材種類フラグ
                    )
                  )
                )
              )
              (if (= 1 (rem #iCnt 2))
                (progn
                  (setq #data$
                    (list
                      ""              ;1.工種記号
                      ""              ;2.SERIES記号
                      #sCode          ;3.品番名称
                      #fSort          ;4.入力配置用品番名称
                      (list "")       ;5.図形ハンドルは、なし
                      1               ;6.ケコミ飾りの数
                      "3"             ;7.部材種類フラグ
                    )
                  )
                )
              )
            );progn ｹｺﾐ飾りの処理
            ;00/08/09 SN ADD 足元ｽﾄｯｶｰ用ﾌｨﾗｰﾊﾟｯｷﾝ処理
            (progn
              (if (> #iCnt 0)
                (setq #data$
                  (list
                    ""              ;1.工種記号
                    ""              ;2.SERIES記号
                    #sCode          ;3.品番名称
                    #fSort          ;4.入力配置用品番名称
                    (list "")       ;5.図形ハンドルは、なし
                    #iCnt           ;6.足元ｽﾄｯｶｰ用ﾌｨﾗｰﾊﾟｯｷﾝの数
                    "3"             ;7.部材種類フラグ
                  )
                )
              );end if
            );progn 足元ｽﾄｯｶｰ用ﾌｨﾗｰﾊﾟｯｷﾝ処理
          );end if
        )
      )

      (if (/= nil #data2$)
        (setq #lst$$ (append #lst$$ (list #data2$)))
      )
      (if (/= nil #data$)
        (setq #lst$$ (append #lst$$ (list #data$ )))
      )
    )
    (progn
      (princ (strcat "\nオプションアイテム:[" #sCode "]の品番関連情報がありません"))
    )
  )

  ;// ケコミ飾りの詳細情報を取得する
  (if (/= #lst$$ nil)
    (reverse (SCB_GetDetailList #lst$$))
;;;01/07/19YM@    (reverse (SCB_GetDetailList #lst$$ 0))
    nil
  )
)
;;;SKB_GetKekomiInfo

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_GetBuzaiList
;;; <処理概要>: 品番名称・入力配置用品番名称・図形ハンドルの一覧表作成
;;; <戻り値>  :
;;;             (list
;;;               (list
;;;                 1.工種記号
;;;                 2.SERIES記号
;;;                 3.品番名称
;;;                 4.入力配置用品番名称
;;;                 5.図形ハンドル
;;;                 6.個数
;;;                 7.部材種類フラグ (0:標準部材 1:特注WT 2:天井フィラー 3:補足部材 +100:特注)
;;;                 8.寸法(※)
;;;                 9.掛率or上乗せ額(※)
;;;               )
;;;             )
;;;             ※8,9は特注キャビネットの場合のみ付加
;;; <備考>    :
;;;             1)配置済み部材の工種記号・SERIES記号・品番名称・Ｌ／Ｒ区分より
;;;               品番図形.DBを検索する。
;;;             2)入力配置用品番名称が同一の場合は１行にまとめて個数を１増分する。
;;;************************************************************************>MOH<
(defun SKB_GetBuzaiList (
  /
	#DRCOLCODE #HND #I #LRCD #LST$ #LST$$ #LST5$$ #LST7$$ #NAME #NUM #SORT-LST$$ #SS #SYM #XD$
#bunrui #xd_TOKU$ #toku_cd #toku_flg	;--2011/12/12 A.Satoh Add
#name_hantei ;2018/10/25 YM ADD-S
  )

;/////////////////////////////////////////////////////////////////////////////
; 同じ品番なら個数を増やす
;/////////////////////////////////////////////////////////////////////////////
			(defun ##MATOME1 (
			 	&lis$
				/
				#F #FNEW #HIN #HINLR #HINLR$ #I #KOSU #LOOP #LR #RET$
;-- 2011/12/12 A.Satoh Add - S
				#toku_f
;-- 2011/12/12 A.Satoh Add - E
				)
				(setq #hinLR$ nil)
				(foreach #e &lis$
					(setq #hin (nth 0 #e))
					(setq #LR  (nth 1 #e))
					(setq #hinLR (list #hin #LR))
;-- 2011/12/12 A.Satoh Mod - S
;;;;;					(if (member #hinLR #hinLR$)
					(setq #toku_f (nth 7 #e))
	        (if (and (member #hinLR #hinLR$) (= #toku_f 0))
;-- 2011/12/12 A.Satoh Mod - E
						(progn ; 同じものが過去にあり
							(setq #loop T #i 0)
							(setq #kosu (length #ret$))
							(while (and #loop (< #i #kosu))
								(setq #f (nth #i #ret$))
								(if (and (= (nth 0 #f) #hin)(= (nth 1 #f) #LR))
									(progn
										(setq #loop nil)
							      (setq #fnew
										 	(CFModList #f
								        (list
;-- 2011/12/12 A.Satoh Mod - S
;;;;;													(list 2 (append (nth 2 #f) (nth 2 #e))) ; 図形ﾊﾝﾄﾞﾙ追加
;;;;;													(list 3 (1+ (nth 3 #f)))                ; 個数+1
													(list 3 (append (nth 3 #f) (nth 3 #e))) ; 図形ﾊﾝﾄﾞﾙ追加
													(list 4 (1+ (nth 4 #f)))                ; 個数+1
;-- 2011/12/12 A.Satoh Mod - E
												)
								      )
										)
									)
								);_if
								(setq #i (1+ #i))
							);while
							(setq #ret$ (subst #fnew #f #ret$)) ; 要素入替え
						)
						(progn ; 初めてでてきた要素
							(setq #hinLR$ (append #hinLR$ (list #hinLR))) ; (品番,LR)ﾘｽﾄ
							(setq #ret$ (append #ret$ (list #e)))
						)
					);_if
				);foreach
				#ret$
			);##MATOME1
;/////////////////////////////////////////////////////////////////////////////

  (setq CG_FuncName "\nSKB_GetBuzaiList")

  ;// G_LSYMを持つ設備部材を検索
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
	(if (and #ss (< 0 (sslength #ss)))
		(progn

		  (setq #i 0)
		  (repeat (sslength #ss)
		    (setq #sym (ssname #ss #i))
				(if (CfGetXData #sym "G_KUTAI") ; 躯体は無視
					(progn
						nil
					)
					(progn
				    (setq #xd$ (CFGetXData #sym "G_LSYM"))

;;;;;				    (setq #name (nth  5 #xd$))                    ; 品番名称
						(setq #xd_TOKU$ (CFGetXData #sym "G_TOKU"))
						(if #xd_TOKU$
	            (setq #name (nth  0 #xd_TOKU$)) ; 品番名称
  	          (setq #name (nth  5 #xd$)) ; 品番名称
						)

						;2018/10/25 YM ADD-S 特注品番も考慮　#name_hantei　は、()外して"%"有無判定　だけに使う
						(if #xd_TOKU$
	            (setq #name_hantei (nth  10 #xd_TOKU$)) ; 特注前の元品番名称
  	          (setq #name_hantei (nth  5 #xd$)) ; 品番名称
						);_if
						;2018/10/25 YM ADD-E 特注品番も考慮

						;2018/1/18 YM ADD-S
						;2018/10/11 YM ｺﾒﾝﾄ
;;;						(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
;;;				      (progn

								;2018/01/09 YM ADD 品番に%を含んでいなかったら"Z"扱い
				        (if (vl-string-search "%" (KP_DelHinbanKakko #name_hantei));()外して"%"有無判定
									;そのまま
									(setq #lrcd (nth  6 #xd$))                    ; ＬＲ区分
									;else %がないので"Z"にする
              		(setq #lrcd "Z")                    ; ＬＲ区分
								);_if

;;;							)
;;;							;else ｽｲｰｼﾞｨ
;;;							(progn ;そのまま
;;;				    		(setq #lrcd (nth  6 #xd$))                    ; ＬＲ区分
;;;							)
;;;						);_if
						;2018/10/11 YM ｺﾒﾝﾄ
						;2018/1/18 YM ADD-E




						(setq #DRColCode  (nth 7 #xd$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"
            (setq #bunrui    (nth 15 #xd$)) ; 分類(A:キッチン D:収納)
						(if #xd_TOKU$
							(progn
								(setq #toku_cd (nth 3 #xd_TOKU$))
								(setq #toku_flg 1)
							)
							(progn
								(setq #toku_cd "")
								(setq #toku_flg 0)
							)
						)
;-- 2011/12/12 A.Satoh Add - E

						(if (and #DRColCode (vl-string-search "," #DRColCode))
							(progn ; もし","が含まれていたら
		 						; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号" 01/10/11 YM ADD ","-->":"
								(setq #DRColCode (CMN_string-subst "," ":" #DRColCode))
								(setq #name (strcat #name "[" #DRColCode "]"))
							)
						);_if

				    (setq #hnd  (cdr (assoc 5 (entget #sym))))    ; 図形ハンドル

				    (setq #lst$
				      (list
				        #name                 ; 品番名称
				        #lrcd                 ; LR区分
;-- 2011/12/12 A.Satoh Add - S
								#bunrui
;-- 2011/12/12 A.Satoh Add - E
				        (list #hnd)           ; 図形ハンドル
;-- 2011/12/12 A.Satoh Add - S
								1
								"0"
								#toku_cd		; 特注コード
								#toku_flg		; 特注フラグ
								(nth  5 #xd$)	; 品番名称（特注処理用)
;-- 2011/12/12 A.Satoh Add - E
				      )
				    )
				    (setq #lst$$ (append #lst$$ (list #lst$)))
					) ; 躯体は無視
				);_if
		    (setq #i (1+ #i))
		  );repeat

		  ;// 品番名称でソートして同一部材の個数を取得する
		  (setq #lst$$ (CFListSort #lst$$ 0))

			; 規格品のみの前提
			(setq #lst5$$ nil #lst7$$ nil)
;-- 2011/12/12 A.Satoh Del - S
;;;;;			(setq #num 1)
;-- 2011/12/12 A.Satoh Del - E
			(foreach #lst$ #lst$$
;-- 2011/12/12 A.Satoh Del - S
;;;;;				(setq #lst$ (append #lst$ (list #num "0")))
;-- 2011/12/12 A.Satoh Del - E
				(setq #lst5$$ (append #lst5$$ (list #lst$))) ; 規格品のみの前提
			);foreach

			; 標準品処理(同一ｱｲﾃﾑ個数加算) ------------------------------------------------------------------
			(setq #sort-lst$$ (##MATOME1 #lst5$$))

			;2017/12/19 YM ADD-S
			;2018/10/15 YM MOD-S
;;;			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
	      (setq #sort-lst$$ (##HINBAN_MATOME2 #sort-lst$$))
;;;			);_if
			;2018/10/15 YM MOD-E
			;2017/12/19 YM ADD-E

		)
		(progn
			(princ "図面上に部材がありません。")
		)
	);_if

  ;// リストを返す
  #sort-lst$$
);SKB_GetBuzaiList

;;;<HOM>************************************************************************
;;; <関数名>  : SCB_GetDetailList
;;; <処理概要>: 設備部材の詳細情報を取得する
;;; <戻り値>  :
;;;             (list
;;;                (list
;;;                   1.ソートキー
;;;                   2.品番名称
;;;                   3.図形ハンドル
;;;                   4.入力配置用品番名称
;;;                   5.出力名称コード
;;;                   6.仕様名称コード
;;;                   7.個数
;;;                   8.金額
;;;                   9.品コード
;;;                  10.部材種類フラグ
;;;                  11.集約ID
;;;                )
;;;                ...
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SCB_GetDetailList (
  &lst$$  ;(LIST)
          ;  (list
          ;    (list
          ;      1.工種記号
          ;      2.SERIES記号
          ;      3.品番名称
          ;      4.入力配置用品番名称
          ;      5.図形ハンドル
          ;      6.個数
          ;      7.部材種類フラグ
          ;    )
          ;  )
	; 01/07/19 YM DEL
;;;  &flg    ; 0: 品番名称のみで検索 1:品番名称、SERIES記号、工種記号で検索

  /
;-- 2011/12/12 A.Satoh Mod - S
;;;;;  #lst$ #listCode #sql #nn #qry$ #qry2$ #dlst$$ #dlst$
;;;;;	#TOKU_FLG #hinban #FVALUE #TOKU_SYM
;;;;;	#dlstent$;00/07/10 SN ADD
;;;;;  #newent$ ;00/07/10 SN ADD
;;;;;  #dupflag ;00/07/10 SN ADD
;;;;;  #newnum  ;00/07/13 SN ADD
;;;;;	#SYM #XDTOKU$ #dum
;;;;;#BASEHINBAN$ #ERRMSG #I
	#i #lst$ #hinban #qry$ #dupflag #dlst$$ #dlstent$
	#newent$ #dlst$$ #qry2$ #syuyaku #dlst$ #sym
	#Errmsg #BaseHinban$ #BaseHinban
;-- 2011/12/12 A.Satoh Mod - E
  )
  (setq CG_FuncName "\nSCB_GetDetailList")

	(setq #BaseHinban$ nil) ; 03/06/05 YM ADD 品番基本検索に失敗した品番
	(setq #i 0)
  (foreach #lst$ &lst$$

		(setq #hinban (nth 0 #lst$))
		(WebOutLog (strcat (itoa #i) "-" #hinban))
		; []部分を取り除く
		(setq #hinban (KP_DelDrSeriStr #hinban))
;-- 2011/12/12 A.Satoh Add - S
		; 特注品番である場合
		(if (= (nth 7 #lst$) 1)
			(setq #hinban (nth 8 #lst$))
		)
;-- 2011/12/12 A.Satoh Add - S

    ;// 『品番基本』を取得する
    (setq #qry$
      (car (CFGetDBSQLHinbanTable "品番基本" #hinban
      (list (list "品番名称" #hinban 'STR))))
    )
    (if (and (/= nil #qry$)(not (equal 1.0 (nth 6 #qry$) 0.1))) ;  品番基本.積算F=1は除外する処理を追加 ★OK
      (progn
        ;重複品番は数量を加算する。
        (setq #dupflag nil)                          ;重複ﾌﾗｸﾞOFF
        (foreach #dlstent$ #dlst$$                   ;作成済み一覧分ﾙｰﾌﾟ
          (if (and #dlstent$
	        				 (= (nth 3 #dlstent$) (nth 1 #lst$)) ;"L" or "R"を比較。
              		 (= (nth 1 #dlstent$)(KP_DelHinbanKakko (nth 0 #lst$))) ;品番名称を比較。 前者()なし,後者も()なし
;-- 2011/08/11 A.Satoh Add - S
                   (= (nth 11 #dlstent$) (nth 5 #lst$)) ; 分類 "A" or "D" を比較
;-- 2011/08/11 A.Satoh Add - E
									 )
            (progn                                   ;同じ品番があった時
              (setq #newent$                         ;新しくﾘｽﾄを作り直す
                (list
                  (nth  0 #dlstent$)                ; 1.ソートキー
                  (nth  1 #dlstent$)                ; 2.品番名称
                  (append (nth  2 #dlstent$)        ; 3.元の図形ﾊﾝﾄﾞﾙに
                          (nth  2 #lst$))           ; 3.図形ﾊﾝﾄﾞﾙ 2009/12/08 YM MOD 収納拡大
                  (nth  3 #dlstent$)                ; 4.入力配置用品番名称
                  (nth  4 #dlstent$)                ; 5.出力名称ｺｰﾄﾞ
                  (nth  5 #dlstent$)                ; 6.仕様名称ｺｰﾄﾞ
                  (+
                    (nth 6 #dlstent$)               ; 7.元の個数に
                    (nth 3 #lst$))                 ; 7.現在の個数を加算する。 2009/12/08 YM MOD 収納拡大
                  (nth  7 #dlstent$)                ; 8.金額(見積もり処理で取得)
                  (nth  8 #dlstent$)                ; 9.品ｺｰﾄﾞ
                  (nth  9 #dlstent$)                ;10.部材種類ﾌﾗｸﾞ
                  (nth 10 #dlstent$)                ;11.集約ID
                )
              )
              (setq #dlst$$ (subst #newent$ #dlstent$ #dlst$$));新旧要素情報入替
              (setq #dupflag T)                    ;重複ﾌﾗｸﾞON
            )
          )
        )

        (if (not #dupflag)
					(progn ;00/07/10 SN MOD 重複あれば情報追加はしない
;-- 2011/12/12 A.Satoh Add - S
            (if (and (= (nth 2 #lst$) "D") (= (substr (nth 5 #qry$) 1 1) "A"))
              (progn
                (setq #qry2$
                  (car (CFGetDBSQLHinbanTable "集約ID変換" #hinban
                  (list (list "品番名称" #hinban 'STR))))
                )

                (if (/= #qry2$ nil)
                  (setq #syuyaku (nth 1 #qry2$))
                  (setq #syuyaku (nth 5 #qry$))
                )
              )
              (setq #syuyaku (nth 5 #qry$))
            )
;-- 2011/12/12 A.Satoh Add - E

		        (setq #dlst$
		          (list
	            	(fix (nth 2 #qry$)) ; 1.ソートキー
               	(KP_DelHinbanKakko (nth 0 #lst$))  ; 2.品番名称 ; 02/01/09 YM ADD ()外す
;-- 2011/12/12 A.Satoh Mod - S
;;;;;                (nth 2 #lst$)  ; 3.図形ハンドル
                (nth 3 #lst$)  ; 3.図形ハンドル
;-- 2011/12/12 A.Satoh Mod - E
                (nth 1 #lst$)  ; 4.L/R?
               	0  ; 5.出力名称コード
               	0  ; 6.仕様名称コード
;-- 2011/12/12 A.Satoh Mod - S
;;;;;                (nth 3 #lst$)  ; 7.個数
                (nth 4 #lst$)  ; 7.個数
;-- 2011/12/12 A.Satoh Mod - E
		            0             ; 8.金額(見積り処理で取得)
                "xxxxxxx"      ; 9.品コード
;-- 2011/12/12 A.Satoh Mod - S
;;;;;                (nth 4 #lst$)  ;10.部材種類フラグ
;;;;;	            	(nth 5 #qry$)     ;11.集約ID   2008/07/28 YM MOD  (FIX 削除
                (nth 5 #lst$)  ;10.部材種類フラグ
                #syuyaku                          ; 11.集約ID
                (nth 2 #lst$)                     ; 12.分類
								(nth 6 #lst$)											; 13.特注コード
								(nth 7 #lst$)											; 14.特注フラグ
;-- 2011/12/12 A.Satoh Mod - S
		          )
		        )
		        (setq #dlst$$ (append #dlst$$ (list #dlst$)))
        	)
				)
      )
			;else 品番基本になかったか or あっても積算F=1 の場合
			(progn
				;ｼﾝｸかどうか判定する
;-- 2011/12/12 A.Satoh Mod - S
;;;;;				(setq #sym (handent (car (nth 2 #lst$))))
				(setq #sym (handent (car (nth 3 #lst$))))
;-- 2011/12/12 A.Satoh Mod - S
				(if (or (and #sym (equal CG_SKK_INT_SNK (nth 9 (CFGetXData #sym "G_LSYM")) 0.1 )) ; 性格ｺｰﾄﾞ=410(ｼﾝｸ)の場合
						    (and (/= nil #qry$)(equal 1.0 (nth 6 #qry$) 0.1))) ; 品番基本にあるが、積算F=1の場合 ★OK
		      nil ; 元々[品番基本]に登録されていないので例外的に除外する 積算F=1は対象にしない
					; else
					(progn
						(setq #BaseHinban$ (append #BaseHinban$ (list #hinban)))
					)
				);_if
			)
    );_if
		(setq #i (1+ #i))
  );_foreach


	(if #BaseHinban$
		(progn
			(setq #Errmsg "\n")
			(foreach #BaseHinban #BaseHinban$
				(setq #Errmsg (strcat #Errmsg #BaseHinban "\n"))
			)
			(CFYesDialog (strcat "\n以下の品番がﾃﾞｰﾀﾍﾞｰｽにありませんでした。"
													 "\n※見積明細に表示されませんのでご注意ください。"
													 "\n  "
													 "\n＜原因＞  "
													 "\n商品が廃版になったか、ﾃﾞｰﾀﾍﾞｰｽのﾊﾞｰｼﾞｮﾝが古いか"
													 "\n或いはﾃﾞｰﾀﾍﾞｰｽに誤りがあることが考えられます。"
													 "\n  "
													 #Errmsg))
		)
	);_if
	#dlst$$
);SCB_GetDetailList

;;;<HOM>************************************************************************
;;; <関数名>  : SCB_GetDetailListOPT
;;; <処理概要>: 設備部材の詳細情報を取得する(ｵﾌﾟｼｮﾝ品専用)
;;; <戻り値>  :
;;;             (list
;;;                (list
;;;                   1.ソートキー
;;;                   2.品番名称
;;;                   3.図形ハンドル
;;;                   4.入力配置用品番名称
;;;                   5.出力名称コード
;;;                   6.仕様名称コード
;;;                   7.個数
;;;                   8.金額
;;;                   9.品コード
;;;                  10.部材種類フラグ
;;;                  11.集約ID
;;;                )
;;;                ...
;;;             )
;;; 03/06/14 YM ｵﾌﾟｼｮﾝ品を特注化した場合の専用ﾛｼﾞｯｸ
;;;************************************************************************>MOH<
(defun SCB_GetDetailListOPT (
  &lst$$  ;(LIST) ★ｵﾌﾟｼｮﾝ品のみ 特注あり
          ;  (list
          ;    (list
          ;      1.工種記号
          ;      2.SERIES記号
          ;      3.品番名称
          ;      4.入力配置用品番名称
          ;      5.図形ハンドル
          ;      6.個数
          ;      7.部材種類フラグ
          ;    )
          ;  )
  /
	#DLST$ #DLST$$ #DUPFLAG #FVALUE #HINBAN #NEWENT$ #QRY$ #SYM #TOKU_FLG #ORG_OPT
	#BIKOU #DLST1$ #DLST2$ #HINMEI
  )
  (setq CG_FuncName "\nSCB_GetDetailList")

  (foreach #lst$ &lst$$
		(setq #TOKU_FLG nil) ; 初期化
		(setq #sym nil) ; ｵﾌﾟｼｮﾝ品なので #sym なし
		(setq #hinban (nth 2 #lst$))

    (setq #qry$ ; 特注品の場合 nil ありえる
      (car (CFGetDBSQLHinbanTable "品番基本" #hinban
      (list (list "品番名称" #hinban 'STR))))
    )
		(if (= #qry$ nil)
			(progn
				; 初期化
				(setq #org_opt nil)
				(setq #fValue  nil)

				(setq #TOKU_FLG T)
				(setq #org_opt (nth  7 #lst$)) ; 元の品番
				(setq #fValue  (nth  8 #lst$)) ; 金額
				(setq #hinmei  (nth  9 #lst$)) ; 品名
				(setq #bikou   (nth 10 #lst$)) ; 備考
				(if (= nil #org_opt)(setq #org_opt ""))
				(if (= nil #hinmei )(setq #hinmei  ""))
				(if (= nil #bikou  )(setq #bikou   ""))
				(if (= nil #fValue )(setq #fValue 0.0))

				;元の品番で品番基本を検索する
		    (setq #qry$ ; 特注品の場合 nil ありえる
		      (car (CFGetDBSQLHinbanTable "品番基本" #org_opt
		      (list (list "品番名称" #org_opt 'STR))))
		    )
			)
		);_if

    ;00/07/10 SN S-ADD 重複品番は数量を加算する。
    (setq #dupflag nil)                          ;重複ﾌﾗｸﾞOFF
    (foreach #dlstent$ #dlst$$                   ;作成済み一覧分ﾙｰﾌﾟ
      (if (and #dlstent$
      				 (= (nth 3 #dlstent$) (nth 3 #lst$)) ;00/07/12 SN ADD "L" or "R"を比較。
          		 (= (nth 1 #dlstent$)(KP_DelHinbanKakko (nth 2 #lst$)))) ;品番名称を比較。 前者()なし,後者も()なし
        (progn                                   ;同じ品番があった時
          (setq #newent$                         ;新しくﾘｽﾄを作り直す
            (list
              (nth  0 #dlstent$)                ; 1.ソートキー
              (nth  1 #dlstent$)                ; 2.品番名称
              (append (nth  2 #dlstent$)        ; 3.元の図形ﾊﾝﾄﾞﾙに「
                      (nth  4 #lst$))          ; 3.図形ﾊﾝﾄﾞﾙ
              (nth  3 #dlstent$)                ; 4.入力配置用品番名称
              (nth  4 #dlstent$)                ; 5.出力名称ｺｰﾄﾞ
              (nth  5 #dlstent$)                ; 6.仕様名称ｺｰﾄﾞ
              (+
                (nth 6 #dlstent$)               ; 7.元の個数に
                (nth 5 #lst$))                 ; 7.現在の個数を加算する。
              (nth  7 #dlstent$)                ; 8.金額(見積もり処理で取得)
              (nth  8 #dlstent$)                ; 9.品ｺｰﾄﾞ
              (nth  9 #dlstent$)                ;10.部材種類ﾌﾗｸﾞ
              (nth 10 #dlstent$)                ;11.集約ID
            )
          )
          (setq #dlst$$ (subst #newent$ #dlstent$ #dlst$$));新旧要素情報入替
          (setq #dupflag T)                    ;重複ﾌﾗｸﾞON
        )
      )
    )

    ;00/07/10 SN E-ADD
    (if (not #dupflag)
			(progn ;00/07/10 SN MOD 重複あれば情報追加はしない
        (setq #dlst1$
          (list
						(fix (nth 2 #qry$)) ; 1.ソートキー

						(if #TOKU_FLG
							(nth 2 #lst$) ; 特注は()を外さない
	         		(KP_DelHinbanKakko (nth 2 #lst$))  ; ()外す
						);_if

						(nth 4 #lst$)  ; 3.図形ハンドル
						(nth 3 #lst$)  ; 4.入力配置用品番名称  LR区分
						(nth 6 #qry$)  ; 5.出力名称コード
						(nth 7 #qry$)  ; 6.仕様名称コード
						(nth 5 #lst$)  ; 7.個数

						(if #TOKU_FLG
		        	#fValue           ; 特注ｷｬﾋﾞ
		          0                 ; 8.金額(見積り処理で取得)
						);_if

						"xxxxxxx"      ; 9.品コード

						(if #TOKU_FLG
							(strcat "101 " #org_opt) ; "101" + 特注品番
	         		(nth 6 #lst$)            ;10.部材種類フラグ
						);_if

	      		(fix (nth 8 #qry$)) ;11.集約ID
          )
        )

        (setq #dlst2$
          (list
						"" ; 特注
						#fValue   ; 特注金額
						#hinmei   ; ★品名★
						#bikou    ; ★備考★
					)
				)

				(if #TOKU_FLG
					(setq #dlst$ (append #dlst1$ #dlst2$))
					(setq #dlst$ #dlst1$)
				);_if
        (setq #dlst$$ (append #dlst$$ (list #dlst$)))
    	)
		);00/07/10 SN MOD 重複あれば情報追加はしない
  );_foreach
	#dlst$$
);SCB_GetDetailListOPT

;;;<HOM>************************************************************************
;;; <関数名>  : SCB_GetDetailList_OPT
;;; <処理概要>: 設備部材の詳細情報を取得する(ｵﾌﾟｼｮﾝ品専用)
;;; <戻り値>  :
;;;             (list
;;;                (list
;;;                   1.ソートキー
;;;                   2.品番名称
;;;                   3.図形ハンドル
;;;                   4.入力配置用品番名称
;;;                   5.出力名称コード
;;;                   6.仕様名称コード
;;;                   7.個数
;;;                   8.金額
;;;                   9.品コード
;;;                  10.部材種類フラグ
;;;                  11.集約ID
;;;                )
;;;                ...
;;;             )
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun SCB_GetDetailList_OPT (
  &lst$$  ;(LIST)
          ;  (list
          ;    (list
          ;      1.工種記号
          ;      2.SERIES記号
          ;      3.品番名称
          ;      4.入力配置用品番名称
          ;      5.親のｼﾝﾎﾞﾙ図形ハンドル
          ;      6.個数
          ;      7.部材種類フラグ
          ;    )
          ;  )
  /
	#DLST$ #DLST$$ #DUPFLAG #HINBAN #NEWENT$ #NEWNUM #QRY$ #SYM #LR_oya
	#NEWDLST$ #NEWDLST$$ #NEWHIN
  )
  (setq CG_FuncName "\nSCB_GetDetailList_OPT")

  (foreach #lst$ &lst$$
		(if (nth 4 #lst$)
			(setq #sym (handent (car (nth 4 #lst$))))
			(setq #sym nil)
		);_if

		(if (and #sym (CFGetXData #sym "G_LSYM")) ; 親図形
			(setq #LR_oya (nth 6 (CFGetXData #sym "G_LSYM"))); 01/07/19 YM ADD 親図形のLR
			(setq #LR_oya "")
		);_if

		(setq #hinban (nth 2 #lst$))
    (setq #qry$
      (car (CFGetDBSQLHinbanTable "品番基本" #hinban
      (list (list "品番名称" #hinban 'STR))))
    )
    (if (/= nil #qry$)
      (progn
        ;00/07/10 SN S-ADD 重複品番は数量を加算する。
        (setq #dupflag nil)                          ;重複ﾌﾗｸﾞOFF
        (foreach #dlstent$ #dlst$$                   ;作成済み一覧分ﾙｰﾌﾟ
          (if (and #dlstent$
	        				 (= (nth 3 #dlstent$) (nth 3 #lst$)) ;00/07/12 SN ADD "L" or "R"を比較。
              		 (= (nth 1 #dlstent$) (nth 2 #lst$)));品番名称を比較。
            (progn                          ;同じ品番があった時
              (setq #newent$                         ;新しくﾘｽﾄを作り直す
                (list
                  (nth  0 #dlstent$)        ; 1.ソートキー

                  (nth  1 #dlstent$)        ; 2.品番名称
;;;									; 01/07/19 YM ADD START
;;;									(if (and #qry$ (= 1 (nth 1 #qry$))) ; LR区分あれば親図形のLRを付ける
;;;                  	(strcat (nth 1 #dlstent$) #LR_oya) ; 2.品番名称
;;;                  	(nth  1 #dlstent$)                 ; 2.品番名称
;;;									);_if
;;;									; 01/07/19 YM ADD END

                  (append (nth  2 #dlstent$); 3.元の図形ﾊﾝﾄﾞﾙに
                          (nth  4 #lst$))   ; 3.図形ﾊﾝﾄﾞﾙ
                  (nth  3 #dlstent$)        ; 4.入力配置用品番名称
                  (nth  4 #dlstent$)        ; 5.出力名称ｺｰﾄﾞ
                  (nth  5 #dlstent$)        ; 6.仕様名称ｺｰﾄﾞ
                  (+
                    (nth 6 #dlstent$)       ; 7.元の個数に
                    (nth 5 #lst$))          ; 7.現在の個数を加算する。
                  (nth  7 #dlstent$)        ; 8.金額(見積もり処理で取得)
                  (nth  8 #dlstent$)        ; 9.品ｺｰﾄﾞ
                  (nth  9 #dlstent$)        ;10.部材種類ﾌﾗｸﾞ
                  (nth 10 #dlstent$)        ;11.集約ID
                )
              )
              (setq #dlst$$ (subst #newent$ #dlstent$ #dlst$$));新旧要素情報入替
              (setq #dupflag T)                    ;重複ﾌﾗｸﾞON
            )
          )
        )
        ;00/07/10 SN E-ADD
        (if (not #dupflag)
					(progn ;00/07/10 SN MOD 重複あれば情報追加はしない
		        (setq #dlst$
		          (list
							; 01/02/02 YM KPCAD 品番基本のソートキーは(nth 2 #qry$)
	            	(fix (nth 2 #qry$)) ; 1.ソートキー

								(nth 2 #lst$)  ; 2.品番名称

;;;								; 01/07/19 YM ADD START
;;;								(if (and #qry$ (= 1 (nth 1 #qry$))) ; LR区分あれば親図形のLRを付ける
;;;                	(strcat (nth 2 #lst$) #LR_oya)    ; 2.品番名称
;;;                	(nth 2 #lst$)                     ; 2.品番名称
;;;								);_if
;;;								; 01/07/19 YM ADD END

								(nth 4 #lst$)  ; 3.図形ハンドル
								(nth 3 #lst$)  ; 4.入力配置用品番名称
               	(nth 6 #qry$)  ; 5.出力名称コード
               	(nth 7 #qry$)  ; 6.仕様名称コード
                (nth 5 #lst$)  ; 7.個数
	              0                 ; 8.金額(見積り処理で取得)
               "xxxxxxx"      ; 9.品コード
								(nth 6 #lst$)  ;10.部材種類フラグ
								(fix (nth 8 #qry$)) ;11.集約ID
		          )
		        )
		        (if (< 7 (length #lst$))
		          (progn
		            (setq #dlst$
		              (append #dlst$
		                (list
		                  (nth 7 #lst$) ;12.寸法
		                  (nth 8 #lst$) ;13.掛率or上乗せ額
		                )
		              )
		            )
		          )
		        )
		        (setq #dlst$$ (append #dlst$$ (list #dlst$)))
        	)
				);00/07/10 SN MOD 重複あれば情報追加はしない
      )
			(progn
				(princ (strcat "\n品番基本に" #hinban "のﾚｺｰﾄﾞがありません。"))
			)
    );_if

  );_foreach

  ;00/07/13 SN S-ADD
  ;二個一組のアイテムの数量を１／２する。
  (foreach #dlstent$ #dlst$$                        ;作成済み一覧分ﾙｰﾌﾟ
    (if (and #dlstent$
             (= (nth 1 #dlstent$) "KS-ZK65P"));) ;壁固定カナグ。   ;00/07/14 SN MOD )をｺﾒﾝﾄに・・
      (progn                                  ;二個一組の品番
        (setq #newnum (fix (/ (1+ (nth 6 #dlstent$)) 2)));個数を半分にする。1→1､2→1､3→2
        (setq #newent$                              ;新しくﾘｽﾄを作り直す
          (list
            (nth  0 #dlstent$)                      ; 1.ソートキー
            (nth  1 #dlstent$)                      ; 2.品番名称
            (nth  2 #dlstent$)                      ; 3.図形ﾊﾝﾄﾞﾙ
            (nth  3 #dlstent$)                      ; 4.入力配置用品番名称
            (nth  4 #dlstent$)                      ; 5.出力名称ｺｰﾄﾞ
            (nth  5 #dlstent$)                      ; 6.仕様名称ｺｰﾄﾞ
            #newnum                                 ; 7.個数
            (nth  7 #dlstent$)                      ; 8.金額(見積もり処理で取得)
            (nth  8 #dlstent$)                      ; 9.品ｺｰﾄﾞ
            (nth  9 #dlstent$)                      ;10.部材種類ﾌﾗｸﾞ
            (nth 10 #dlstent$)                      ;11.集約ID
          )
        )
        (setq #dlst$$ (subst #newent$ #dlstent$ #dlst$$));新旧要素情報入替
      )
    );END IF
  );END FOREACH
  ;00/07/13 SN E-ADD

	; 01/07/19 YM LRを追加する START
	(setq #newdlst$$ nil)
	(foreach #dlst$ #dlst$$
		(setq #hinban (nth 1 #dlst$))
    (setq #qry$
      (car (CFGetDBSQLHinbanTable "品番基本" #hinban
      (list (list "品番名称" #hinban 'STR))))
    )
    (if (/= nil #qry$)
      (progn
				(if (= 1 (nth 1 #qry$)) ; LR区分あれば親図形のLRを付ける
		    	(setq #newHIN (strcat (nth 1 #dlst$) #LR_oya)) ; 2.品番名称
		    	(setq #newHIN (nth  1 #dlst$))                 ; 2.品番名称
				);_if
        (setq #newdlst$ (CFModList #dlst$
          (list (list 1 #newHIN))
        ))
				(setq #newdlst$$ (append #newdlst$$ (list #newdlst$)))
			)
    );_if
	)
	; 01/07/19 YM LRを追加する END

;;;  #dlst$$
	#newdlst$$
);SCB_GetDetailList_OPT

;<HOM>*************************************************************************
; <関数名>    : SKB_GetGroupPFig
; <処理概要>  : 指定設備部材の仕様番号のＰ点を取得する
; <戻り値>    :
;        LIST : Ｐ点図形のリスト
;
; <作成>      : 2000-01-12
; <備考>      :
;*************************************************************************>MOH<
(defun SKB_GetGroupPFig (
    &hnd             ;(STR)指定設備部材の図形ハンドル
    /
    #en #en$
    #p-en$
    #i
    #xd$
  )

  (setq #en (handent &hnd))
  (setq #en$ (CFGetGroupEnt #en))
  (if (/= #en nil)
    (progn
      (setq #p-en$ nil)
      (setq #i 0)
      (while (< #i (length #en$))
        (setq #en (nth #i #en$))
        (if (/= nil (setq #xd$ (CFGetXData #en "G_PTEN")))
          (if (= (nth 0 #xd$) CG_BALOONTYPE)
            (setq #p-en$ (cons #en #p-en$))
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
  ;// ｐ点図形リストを返す
  #p-en$
)
;SKB_GetGroupPFig

;<HOM>*************************************************************************
; <関数名>    : SKB_MakeWkTopBaloonPoint
; <処理概要>  : ワークトップ・天井フィラーの仕様表番号
; <戻り値>    :
; <作成>      : 2000-01-12
; <備考>      :
;*************************************************************************>MOH<
(defun SKB_MakeWkTopBaloonPoint (
  /
	#BASEPT #DIST1 #DIST2 #EFILR #EN #I #LAY #P1 #P2 #P22 #PT$ #PUSHPLINE #SS
	#TEI #WTR_PT #WTTYPE #XD$ #ZAICODE #ZAIF #DIST #DISTMAX #N
	#nII
	#eMRWT	; 最右ワークトップ
	#xMRWT$	; 最右ワークトップの拡張データ
  )

  ;// ワークトップ
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (/= #ss nil)
    (progn


      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_WRKT"))
				(setq #ZaiCode (nth 2 #xd$))
				(setq #WTtype  (nth 3 #xd$))
				(setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
        (setq #BasePt (nth 32 #xd$)) ; WT左上点
				(setq #tei    (nth 38 #xd$)) ; WT底面図形ﾊﾝﾄﾞﾙ
				(setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列

				;;; 外形点列&pt$を#BASEPを先頭に時計周りにする
				(setq #pt$ (GetPtSeries #BasePt #pt$))

				; 02/06/25 YM ADD 警告追加
				(if (= nil #pt$)
					(progn
						(CFAlertMsg (strcat "\nﾜｰｸﾄｯﾌﾟが持っている情報に誤りがあり、このまま処理を続けるとｴﾗｰが発生します。\n"
																"ﾜｰｸﾄｯﾌﾟをもう一度張りなおすと問題が解決する場合があります。"))
;;;						(command "undo" "b" )
						(quit)
					)
				);_if
				; 02/06/25 YM ADD 警告追加

			  (setq #WTR_PT (nth 1 #pt$)) ; WT右上点
				; ｽﾃﾝﾚｽL型:WTの一番長い間口の真ん中にかく 01/04/16 YM MOD
				; ｽﾃﾝﾚｽL型以外:WTの間口の真ん中にかく     01/04/16 YM MOD
				(cond
					((and (not (equal (KPGetSinaType) -1 0.1))(= #ZaiF 1)(= (length #pt$) 6)) ; ｽﾃﾝﾚｽL型 #pt$個数で判断 01/07/05 YM
					;((and (= #ZaiF 1)(= #WTtype 1)) ; ｽﾃﾝﾚｽL型
						(setq #dist1 (distance (nth 0 #pt$)(nth 1 #pt$)))
						(setq #dist2 (distance (nth 0 #pt$)(nth 5 #pt$)))
						(if (<= #dist2 #dist1)
							(progn
								(setq #p1 (GetCenterPT (nth 0 #pt$) (nth 1 #pt$)))
		        		(setq #p2 (polar #p1 (+ (angle #BasePt #WTR_PT) (dtr 90)) 100))
							)
							(progn
								(setq #p1 (GetCenterPT (nth 5 #pt$) (nth 0 #pt$)))
		        		(setq #p2 (polar #p1 (+ (angle (nth 5 #pt$) (nth 0 #pt$)) (dtr 90)) 100))
							)
						);_if
					)
					(T
						(setq #p1 (GetCenterPT #BasePt #WTR_PT))
		        (setq #p2 (polar #p1 (+ (angle #BasePt #WTR_PT) (dtr 90)) 100))
				 	)
				);_cond

;;;01/04/16YM@			  (setq #WTR_PT (nth 1 #pt$)) ; WT右上点
;;;01/04/16YM@				; WTの仕様表番号を右上にする
;;;01/04/16YM@        (setq #p1 (list (car #WTR_PT) (cadr #WTR_PT) 0))
;;;01/04/16YM@        (setq #p1 (polar #p1 (angle #WTR_PT #BasePt) (* CG_REF_SIZE 1))) ; 120mm左にずらす
;;;01/04/16YM@        (setq #p2 (polar #p1 (+ (angle #BasePt #WTR_PT) (dtr 90)) 100))

        (setq #lay "Z_03")
        ;// 仕様番号Ｐ点の生成
        (SKW_MakeBaloonPTen
					#p1
          #p1          ;(LIST)シンク側基点
          #p2          ;(LIST)ガス側基点
          #lay         ;(STR) 配置画層
          900          ;(REAL)配置高さ
        )
        ;// 拡張データの付加
        (CFSetXData (entlast) "G_PTEN" (list 7 0 0))
        ;// Ｐ点とワークトップをグループ化
        (SKMkGroup (CFCnvElistToSS (list (entlast) #en)))
        (setq #i (1+ #i))
      )
    )
  )

  ;// 天井フィラー
  (setq #ss (ssget "X" '((0 . "3DSOLID") (-3 ("G_FILR")))))
  (if (/= #ss nil)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_FILR"))
        ;// 天井フィラーの押出しポリライン（隠しデータ）を取得
        (setq #pushPline (nth 2 #xd$))
        ; "G_FILR" に拡張データを収納するアイテムでは、
        ;「壁処理用スペーサー」だけが3DPOLYでポリラインを作成するため、
        ; POLYLINE が入るようになっています。
        ; それ以外の "G_FILR" 使用の図形はすべて LWPOLYLINE を
        ; 使用しています。
        ; また、「壁処理用スペーサー」だけは、"G_FILR"の5番目のデータに
        ; ポリライン長さが格納されています。
        ; (ほかのアイテムの"G_FILR"にはないです)
        ;(setq #pt$ (GetLWPolylinePt #pushPline))
        ; 2000/06/09  土屋 ポリラインの頂点取得関数は、"LWPOLYLINE" と "POLYLINE"対応版に変更。

				; 天井ﾌｨﾗｰの一番長い線分の真ん中にかく 01/04/26 YM MOD
				; 天井ﾌｨﾗｰは左から書くのが前提
				(if (or (= nil #p1)(= nil #p2))
					(progn
		        (setq #pt$ (GetPolyVertex #pushPline))
						(setq #n 0 #distMAX -1.0e10)
;;;01/04/27YM@						(repeat (1- (length #pt$))
;;;01/04/27YM@							(setq #dist (distance (nth #n #pt$)(nth (1+ #n) #pt$)))
;;;01/04/27YM@							(if (<= #distMAX #dist)
;;;01/04/27YM@								(progn
;;;01/04/27YM@									(setq #distMAX #dist)
;;;01/04/27YM@									(setq #p1 (GetCenterPT (nth #n #pt$) (nth (1+ #n) #pt$) ))
;;;01/04/27YM@			        		(setq #p2 (polar #p1 (+ (angle (nth #n #pt$) (nth (1+ #n) #pt$)) (dtr 90)) 100))
;;;01/04/27YM@								)
;;;01/04/27YM@							);_if
;;;01/04/27YM@							(setq #n (1+ #n))
;;;01/04/27YM@						);repeat


						; 天井ﾌｨﾗｰの一番長い線分の真ん中にかく 01/04/26 YM MOD
						; 最大のものが複数ある場合には線分の左から見ていって最初のものに書きたいため
						; 点列を逆向きにする 01/04/27 YM MOD
						(setq #pt$ (reverse #pt$)) ; 点列を逆向きにする
						(repeat (1- (length #pt$))
							(setq #dist (distance (nth #n #pt$)(nth (1+ #n) #pt$)))
							(if (<= #distMAX #dist)
								(progn
									(setq #distMAX #dist)
									(setq #p1 (GetCenterPT (nth #n #pt$) (nth (1+ #n) #pt$) ))
			        		(setq #p2 (polar #p1 (+ (angle (nth (1+ #n) #pt$) (nth #n #pt$)) (dtr 90)) 100))
								)
							);_if
							(setq #n (1+ #n))
						);repeat

					)
				);_if

;;;01/04/16YM@        (setq #p1 (polar #p1 (angle #p1 #p2) (* CG_REF_SIZE 1)))
;;;01/04/16YM@        (setq #p22 (polar #p1 (+ (angle #p1 #p2) (dtr 90)) 100))

;;;01/04/16YM				; I型,L型右折り返しなし対応 01/04/16 YM MOD
;;;01/04/16YM        (setq #p2 (polar #p2 (angle #p2 #p1) (* CG_REF_SIZE 1)))
;;;01/04/16YM        (setq #p22 (polar #p2 (+ (angle #p1 #p2) (dtr 90)) 100))

; #p1,#p2 はWTのものを使用する
        (setq #lay "Z_03")
        ;// 仕様表番号の生成
        (setq #eFilr
          (SKW_MakeBaloonPTen
            #p1                   ;(LIST)コーナー基点
            #p1                   ;(LIST)シンク側基点
            #p2                   ;(LIST)ガス側基点
            #lay                  ;(STR) 配置画層
            (- CG_CeilHeight (* CG_REF_SIZE 2)) ;(REAL)配置高さ
          )
        )
        (if (/= nil #eFilr)
          (progn
            ;// 拡張データの付加
				    (CFSetXData (entlast) "G_PTEN" (list 7 0 0))
            ;//Ｐ点と天井フィラーをグループ化
            (SKMkGroup (CFCnvElistToSS (list (entlast) #en)))      ;分解した図形群で名前のないグループ作成
          )
        )

        (setq #i (1+ #i))
      )
    )
  );_if

	(princ)
)
;SKB_MakeWkTopBaloonPoint

;<HOM>*************************************************************************
; <関数名>    : SKW_MakeBaloonPTen
; <処理概要>  : ワークトップ・天井フィラーの仕様表番号作図
; <戻り値>    :
;       ENAME : 仕様番号点図形名
; <作成>      : 2000-01-12
; <備考>      :
;*************************************************************************>MOH<
(defun SKW_MakeBaloonPTen (
  &BasePt           ;(LIST)コーナー基点
  &p1               ;(LIST)シンク側基点
  &p2               ;(LIST)ガス側基点
  &lay              ;(STR) 配置画層
  &Height           ;(REAL)配置高さ
  /
  #pt
  #view
  #enTemp$
#eLast ; 01/11/30 YM ADD
  )

  (setq #pt (polar &BasePt (angle &BasePt &p2) (/ (distance &BasePt &p2) 2)))
  (setq #pt (list (car #pt) (cadr #pt) (+ &Height CG_REF_SIZE)))
  (cond
    ((or (= &lay "Z_03")(= &lay "Z_00")) ;正面
      (setq #view (polar &p1 (angle &p2 (list 0 0)) (distance &p2 (list 0 0))))
    )
    ((or (= &lay "Z_04") (= &lay "Z_05")(= &lay "Z_06")) ;背面・側面
      (setq #view (polar &p2 (angle &p1 (list 0 0)) (distance &p1 (list 0 0))))
    )
  )

	; 01/11/30 YM ADD WTとﾌｨﾗｰのPTEN7には、XDATA"G_PTWF"を付ける→後で削除しやすくするため
	(if (= nil (tblsearch "APPID" "G_PTWF")) (regapp "G_PTWF"))

  (if (and (/= nil (car #view)) (/= nil (cadr #view)))
    (progn
      (setq #view (list (car #view) (cadr #view) 0))
      ;// 点を作成
      (command "_.point" #pt)
			(setq #eLast (entlast)) ; POINT 01/11/30 YM ADD
	    (setq #enTemp$ (subst (cons 8  &lay) (assoc 8 (entget (entlast))) (entget  (entlast))))
	    (entmod (subst (cons 210 #view) (assoc 210 #enTemp$) #enTemp$))
			(CFSetXData (entlast) "G_PTWF" (list 0 0 0)) ; 01/11/30 YM ADD
      (entlast)
    )
    nil
  )
);SKW_MakeBaloonPTen

;;;<HOM>************************************************************************
;;; <関数名>  : CFGetDBSQLHinbanTableChk
;;; <処理概要>: 品番関連テーブル検索処理
;;; <戻り値>  : 1レコード分のリスト
;;; <備考>    : 0件または複数件取得した場合、エラー表示後、(*error*)を実行します
;;;************************************************************************>MOH<
(defun CFGetDBSQLHinbanTableChk (
  &sTblName   ; テーブル名称
              ;   1:品番図形
              ;   2:品番基本
              ;   3:品番最終
  &sHinban    ; 品番名称
  &cond$      ; 検索条件
  /
  #sFuncName  ; 呼出し元関数名
  #result$$   ; 検索結果
  #sErrMsg    ; エラーメッセージ
  )
  (if (= 'STR (type CG_FuncName))
    (setq #sFuncName (strcat "\n" CG_FuncName))
    (setq #sFuncName "")
  )

	(setq #result$$ (CFGetDBSQLHinbanTable &sTblName &sHinban &cond$))
  (cond
    ((= 0 (length #result$$))
			(setq #sErrMsg (strcat "『" &sTblName "』にレコードがありません。" #sFuncName))
;;;      (CFOutStateLog 0 1 #sErrMsg)
			(CFAlertMsg #sErrMsg)
      (princ "\n")(princ &cond$)
      (*error*)
    )
    ((= 1 (length #result$$))
		 	nil
;;;      (CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
;;;      (CFOutStateLog 1 1 #result$$)
    )
    ((< 1 (length #result$$)) ; 複数ﾋｯﾄしたときはｴﾗｰ
;;;			(CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
;;;			(CFOutStateLog 1 1 #result$$)
			(setq #sErrMsg (strcat "『" &sTblName "』にレコードが複数ありました." #sFuncName))
;;;		  (CFOutStateLog 0 1 #sErrMsg)
			(CFAlertMsg #sErrMsg)
		  (*error*)
    )
  )

  (car #result$$)
)
;;;CFGetDBSQLHinbanTableChk

;;;<HOM>************************************************************************
;;; <関数名>  : CFGetDBSQLRecChk
;;; <処理概要>: 指定テーブルを検索条件により検索する
;;; <戻り値>  : 1レコード分のリスト
;;; <備考>    : 0件または複数件取得した場合、エラー表示後、(*error*)を実行します
;;;************************************************************************>MOH<
(defun CFGetDBSQLRecChk (
  &session$   ; セッション
  &sTblName   ; テーブル名称
  &cond$      ; 検索条件
  /
  #sFuncName  ; 呼出し元関数名
  #result$$   ; 検索結果
  #sErrMsg    ; エラーメッセージ
  )
  (if (= 'STR (type CG_FuncName))
    (setq #sFuncName (strcat "\n" CG_FuncName))
    (setq #sFuncName "")
  )

  (setq #result$$ (CFGetDBSQLRec &session$ &sTblName &cond$))
  (cond
    ((= 0 (length #result$$))
			(setq #sErrMsg (strcat "『" &sTblName "』にレコードがありません。" #sFuncName))
;;;      (CFOutStateLog 0 1 #sErrMsg)
			(CFAlertMsg #sErrMsg)
      (princ "\n")(princ &cond$)
      (*error*)
    )
    ((= 1 (length #result$$))
		 	nil
;;;      (CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
;;;      (CFOutStateLog 1 1 #result$$)
    )
    ((< 1 (length #result$$)) ; 複数ﾋｯﾄしたときはｴﾗｰ
;;;			(CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
;;;			(CFOutStateLog 1 1 #result$$)
			(setq #sErrMsg (strcat "『" &sTblName "』にレコードが複数ありました." #sFuncName))
;;;		  (CFOutStateLog 0 1 #sErrMsg)
			(CFAlertMsg #sErrMsg)
		  (*error*)
    )
  )

  (car #result$$)
)
;;;CFGetDBSQLRecChk

;;;<HOM>************************************************************************
;;; <関数名>  : SKB_GetHeadList
;;; <処理概要>: 仕様表ヘッダー情報を取得する
;;; <戻り値>  :
;;;             (list
;;;                1.SERIES記号
;;;                2.SERIES名称
;;;                3.扉SERIES記号
;;;                4.扉SERIES名称
;;;                5.扉COLOR記号
;;;                6.扉COLOR名称
;;;                7.WT材質記号
;;;                8.WT材質名称
;;;                9.WT高さ       01/06/01 YM ADD
;;;               10.シンク記号
;;;               11.シンク名称
;;;               12.電気種
;;;               13.ガス種
;;;               14.耐震記号
;;;               15.機器色
;;; <備考>    : ｼﾝｸを1つと仮定し、最初に見つかったものを採用している YM
;;;************************************************************************>MOH<
(defun SKB_GetHeadList (
  /
	#BRAND #DRCOLNAME #DRSERINAME #I #LOOP #QRY$ #SERI$ #SNKCD #SNKNAME
	#SOZAINAME #SOZAINAME2 #SOZAIZAINAME #SOZAIZAINAME$ #SRNAME #SS #XREC$
	#ZAICD #ZAINAME #ZAINAME2 #MSG
  )
  (setq CG_FuncName "\nSKB_GetHeadList")

  ;// 現在の商品情報を設定する
  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DBNAME      (nth 0 #seri$))  ;DB名称
      (setq CG_SeriesCode  (nth 1 #seri$))  ;SERIES記号
      (setq CG_BrandCode   (nth 2 #seri$))  ;ブランド記号
      (setq CG_DRSeriCode  (nth 3 #seri$))  ;扉SERIES記号
      (setq CG_DRColCode   (nth 4 #seri$))  ;扉COLOR記号
      (setq CG_HIKITE      (nth 5 #seri$))  ;ヒキテ記号
    )
  )

  ;// データベースに接続する
  (if (= CG_CDBSESSION nil)
    (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  )
  (if (= CG_DBSESSION nil)
    (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  )

  ;// シンクを検索
	(setq CG_WTHeight "850") ; WT高さ(図面上にシンクが存在しないとき)
  (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; 図面上の全シンクを検索
  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (setq #loop T)
      (while (and #loop (< #i (sslength #ss)))
        (if (= CG_SKK_ONE_SNK (CFGetSymSKKCode (ssname #ss #i) 1))
          (progn
            (setq #snkCd (nth 5 (CFGetXData (ssname #ss #i) "G_LSYM"))) ; ｼﾝｸの品番名称
						(setq CG_WTHeight (caddr (cdr (assoc 10 (entget (ssname #ss #i)))))) ; WT高さ取得 01/06/01 YM ADD
						(setq CG_WTHeight (itoa (fix (+ CG_WTHeight 0.001)))) ; WT高さ取得 01/06/01 YM ADD
            (setq #loop nil)
          )
        )
        (setq #i (1+ #i))
      )
    )
    ;@@@(progn
    ;@@@  (CFAlertErr "アイテム部材がありません")
    ;@@@)
  )

  ;// SERIES名称
  (setq #qry$ (CFGetDBSQLRecChk CG_CDBSESSION "SERIES" (list (list "SERIES記号" CG_SeriesCode 'STR)
																															 (list "SERIES名称" CG_SeriesDB   'STR)))) ; 02/03/18 YM ADD CG_SeriesDB追加
;;;	;2011/12/05 YM ADD-S
;;;  (if (= nil #qry$)
;;;		;ｼﾘｰｽﾞ別DB,共通DB再接続
;;;		(ALL_DBCONNECT)
;;;	);_if
;;;	;2011/12/05 YM ADD-E

  (if (= nil #qry$)
    (CFAlertErr "SERIESテーブルが見つかりません(SKB_GetHeadList)")
  )

  (setq #srname (nth 13 #qry$)) ; 参照先を変更　正式名称から見積正式名称へ
	(if (= nil #srname)
		(setq #srname (nth 5 #qry$)) ; 従来通り(ﾐｶﾄﾞ版)
	);_if


  ;// 扉SERIES名称
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "扉シリズ" (list (list "扉シリ記号" CG_DRSeriCode 'STR))));04/04/23 YM

  (if (= nil #qry$)
		(progn
  		(setq #msg "扉SERIESテーブルから現在の扉SERIESが見つけられませんでした(SKB_GetHeadList)")
			(if (= CG_AUTOMODE 2) ; 02/09/04 YM ADD
				(WebOutLog #msg)    ; 02/09/04 YM ADD
      	(CFAlertMsg #msg)
			);_if
		)
		(progn
			(setq #qry$ (car #qry$))
		)
  )
  (setq #drseriname (nth 1 #qry$)) ; 2008/07/29 YM MOD

  ;// 扉COLOR名称
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "扉COLOR" (list (list "扉カラ記号" CG_DRColCode 'STR))));04/04/23 YM
  (if (= nil #qry$)
		(progn
  		(setq #msg "扉COLORテーブルから現在の扉COLORが見つけられませんでした(SKB_GetHeadList)")
			(if (= CG_AUTOMODE 2) ; 02/09/04 YM ADD
				(WebOutLog #msg)    ; 02/09/04 YM ADD
      	(CFAlertMsg #msg)
			);_if
		)
		(progn
			(setq #qry$ (car #qry$))
		)
  )
  (setq #drcolname (nth 1 #qry$))

  ;// ワークトップ材質
  (setq #ss (ssget "X" '((-3 ("G_WRKT")))))
  (if (/= #ss nil)
    (progn
			(setq #SozaiZaiName$ '() #i 0)

			(repeat (sslength #ss)
				;// 材質名称
				(setq #zaiCd (nth 2 (CFGetXData (ssname #ss #i) "G_WRKT")))
				(setq #qry$
				  (CFGetDBSQLRecChk CG_DBSESSION "WT材質"
				    (list
				      (list "材質記号"  #zaiCd  'STR)
				    )
				  )
				)
		    (setq #zaiName (nth 2 #qry$))  ;2008/06/24 YM MOD
		    (setq #SozaiName (nth 4 #qry$));2008/06/24 YM MOD
		    (setq #SozaiZaiName$ (append #SozaiZaiName$ (list (list #SozaiName #zaiName))))
		    (setq #i (1+ #i))
			); repeat
			; 2000/09/26 HT 図面表題のワークトップ欄表示変更
			; ステンレス ラピス順に並び替える
			(setq #SozaiZaiName$ (CFListSort #SozaiZaiName$ 0))
			; 先頭の WT材質 素材名称
			(setq #zaiName (cadr (car #SozaiZaiName$)))
			(setq #SozaiName (car (car #SozaiZaiName$)))

      (if (= (length #SozaiZaiName$) 1)
				(progn
					(setq #zaiName2 "")
					(setq #SozaiName2 "")
        )
			 	(progn
	       	(if (= "ステンレス" (car(car #SozaiZaiName$)))
						(progn
							; ステンレスがある場合
							(if (setq #SozaiZaiName (assoc "ラピス" #SozaiZaiName$))
							  (progn
							    ; ラピスがある場合
							    (setq #zaiName2 (cadr #SozaiZaiName))
							    (setq #SozaiName2 (car #SozaiZaiName))
							  )
							  (progn
							    (setq #zaiName2 "")
							    (setq #SozaiName2 "")
							  )
						  );_if
		   			)
		   			(progn
		   ; ステンレスがない場合
	           	; 素材でソート
		   				(setq #SozaiZaiName$ (CFListSort #SozaiZaiName$ 1))
		   ; 同一素材でないとき
	           	(if (/= (cadr (car #SozaiZaiName$)) (cadr (last #SozaiZaiName$)))
	            	(progn
		              (setq #zaiName (cadr (car #SozaiZaiName$)))
		              (setq #SozaiName (car (car #SozaiZaiName$)))
		              (setq #zaiName2 (cadr (last #SozaiZaiName$)))
		              (setq #SozaiName2 (car (last #SozaiZaiName$)))
					      )
			    			(progn
			            (setq #zaiName2 "")
			            (setq #SozaiName2 "")
						    )
							);_if
						)
		 			);_if ; ステンレス
				)
      ); if (length ) 1

      ;// シンク名称
      (if (and (/= nil #snkCd) (/= "" #snkCd))
        (progn
 		; ===>@@@シンク穴記号は廃止する 00/11/17 YM
;;;00/11/25 YM	  (setq #qry$ (car (CFGetDBSQLRec CG_DBSESSION "SINK穴記" (list (list "シンク穴記号" #gsink3 'STR))))) ; 将来変更
;;;00/11/25 YM          (setq #snkName (nth 3 #qry$))
          (setq #qry$ (car (CFGetDBSQLRec CG_DBSESSION "WTシンク" (list (list "品番名称" #snkCd 'STR)))))
          (setq #snkName (nth 2 #qry$))
        )
        (progn
          (setq #snkCd   "")
          (setq #snkName "")
        )
      )
    )
    (progn
			;04/08/20 YM ADD 例外処理 ｱｾｯﾄ21なら"ｽﾃﾝﾚｽ"きめうち
			(if (= CG_SeriesCode "A")
				(progn
		      (setq #zaiCd   "SE")
		      (setq #snkCd   "")
		      (setq #zaiName "ｽﾃﾝﾚｽ" #zaiName2 "ｽﾃﾝﾚｽ")
		      (setq #snkName "" )
		      (setq #SozaiName "ｽﾃﾝﾚｽ" #SozaiName2 "ｽﾃﾝﾚｽ")
				)
				(progn
		      (setq #zaiCd   "")
		      (setq #snkCd   "")
		      (setq #zaiName "" #zaiName2 "")
		      (setq #snkName "" )
		      (setq #SozaiName "" #SozaiName2 "")
				)
			);_if
    )
  );_if

  (list
    CG_SeriesCode             ; 1.SERIES記号
    (ai_strrtrim #srName)     ; 2.SERIES名称
    CG_DRSeriCode             ; 3.扉SERIES記号
    (ai_strrtrim #drseriName) ; 4.扉SERIES名称
    CG_DRColCode              ; 5.扉COLOR記号
    (ai_strrtrim #drcolName)  ; 6.扉COLOR名称
    (ai_strrtrim #zaiCd)      ; 7.WT材質記号
    (ai_strrtrim #zaiName)    ; 8.WT材質名称
    CG_WTHeight               ; 9.WT高さ     01/06/01 YM ADD
    (ai_strrtrim #snkCd)      ;10.シンク記号
    (ai_strrtrim #snkName)    ;11.シンク名称
    (if (< (length #seri$) 10) "" (nth 10 #seri$)) ;12.電気種 XRECORDなし時ｴﾗｰが発生する。
    (if (< (length #seri$)  9) "" (nth  9 #seri$)) ;13.ガス種 XRECORDなし時ｴﾗｰが発生する。
    CG_DoorGrip               ;14.耐震記号
    CG_KiKiColor              ;15.機器色
    (ai_strrtrim #SozaiName)  ;16.WT素材名称  2000/08/10 HT ADD
    (ai_strrtrim #zaiName2)   ;17.WT材質名称 2000/09/25 HT ADD
    (ai_strrtrim #SozaiName2) ;18.WT素材名称 2000/09/25 HT ADD
  )
)
;SKB_GetHeadList

;;;01/09/25YM@DEL;;;<HOM>***********************************************************************
;;;01/09/25YM@DEL;;; <関数名>    : PH_OutPutDoorInfo
;;;01/09/25YM@DEL;;; <処理概要>  : 扉選択変更の情報を出力する
;;;01/09/25YM@DEL;;; <戻り値>    : なし
;;;01/09/25YM@DEL;;; <作成>      : 01/09/19 YM
;;;01/09/25YM@DEL;;; <備考>      : DoorInfo.CFG
;;;01/09/25YM@DEL;;;***********************************************************************>HOM<
;;;01/09/25YM@DEL(defun PH_OutPutDoorInfo (
;;;01/09/25YM@DEL	&sym$ ; ｼﾝﾎﾞﾙ図形ﾘｽﾄ
;;;01/09/25YM@DEL  /
;;;01/09/25YM@DEL	#FP #HINBAN #KOSU #LR #SFNAME
;;;01/09/25YM@DEL	)
;;;01/09/25YM@DEL	(if &sym$
;;;01/09/25YM@DEL		(progn
;;;01/09/25YM@DEL			(setq #sFname (strcat CG_KENMEI_PATH "DoorInfo.CFG"))
;;;01/09/25YM@DEL			(setq #kosu (itoa (length &sym$)))
;;;01/09/25YM@DEL		  ;// ファイルへの書き込み
;;;01/09/25YM@DEL		  (setq #fp  (open #sFname "w"))
;;;01/09/25YM@DEL		  (princ   ";;; 各物件フォルダに置く"           #fp)
;;;01/09/25YM@DEL		  (princ "\n;;;"                                #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; DRSeriCode= : 扉SERIES記号"   #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; DRColCode=  : 扉COLOR記号"     #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; KOSU=       : 個数"             #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; HINBAN=     : 品番名称"         #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; LR=         : LR区分"           #fp)
;;;01/09/25YM@DEL		  (princ "\n;;; 以下個数分繰り返す"             #fp)
;;;01/09/25YM@DEL		  (princ "\n;;;"                                #fp)
;;;01/09/25YM@DEL		  (princ (strcat "\nDRSeriCode=" CG_DRSeriCode) #fp)
;;;01/09/25YM@DEL		  (princ (strcat "\nDRColCode="   CG_DRColCode) #fp)
;;;01/09/25YM@DEL		  (princ (strcat "\nKOSU="               #kosu) #fp)
;;;01/09/25YM@DEL			(foreach #sym &sym$
;;;01/09/25YM@DEL		    (setq #hinban (nth 5 (CFGetXData #sym "G_LSYM")))
;;;01/09/25YM@DEL		    (setq #LR     (nth 6 (CFGetXData #sym "G_LSYM")))
;;;01/09/25YM@DEL			  (princ (strcat "\nHINBAN="         #hinban) #fp)
;;;01/09/25YM@DEL			  (princ (strcat "\nLR="                 #LR) #fp)
;;;01/09/25YM@DEL			)
;;;01/09/25YM@DEL		  (princ "\n;;;END\n"                                  #fp)
;;;01/09/25YM@DEL		  (close #fp)
;;;01/09/25YM@DEL		)
;;;01/09/25YM@DEL	);_if
;;;01/09/25YM@DEL  (princ)
;;;01/09/25YM@DEL);PH_OutPutDoorInfo

;;;<HOM>***********************************************************************
;;; <関数名>    : PH_OutPutDoorInfo
;;; <処理概要>  : 扉選択変更の情報を出力する
;;; <戻り値>    : なし
;;; <作成>      : 01/09/25 YM
;;; <備考>      : DoorInfo.CFG
;;;               01/10/05 YM 全面書き換え(ﾌｫｰﾏｯﾄ変更)
;;;***********************************************************************>HOM<
(defun PH_OutPutDoorInfo (
  /
	#DRCOLCODE #FP #HINBAN #HIN_LR$ #I #J #KOSU #LIS$ #LR #SFNAME #SS #XD$ #SERI$
	#DRSERICODE #HIN_LR$$ #K #RET$
	)

		;--------------------------------------------------------------------
		; 01/10/05 YM 同じｶﾗｰでﾘｽﾄを分ける
		;--------------------------------------------------------------------
		(defun ##SameColList (
			&lis$$
			; 引数例
			;(("AG" "MSK14324" "R")
			; ("AG" "MSK14322" "R")
			; ("AJ" "MSK14322" "R")
			; ("AJ" "MSK14324" "R"))
		  /
			#COL #COL$$ #COL$$$ #DUM$$
			)
			(setq #dum$$ nil)
			(setq #col$$$ nil)
			(foreach #lis$ &lis$$
				(if (member #lis$ #dum$$)
					nil ; 既に考慮した
					(progn
						(setq #col (car #lis$)) ; ｶﾗｰ
						; 同じｶﾗｰだけ集める
						(setq #col$$ nil)
						(foreach #elm$ &lis$$
							(if (= #col (car #elm$)) ; ｶﾗｰ
								(progn
									(setq #col$$ (append #col$$ (list #elm$))) ; 集めたものを格納
									(setq #dum$$ (append #dum$$ (list #elm$))) ; 既に考慮したもの
								)
							);_if
						);foreach
						(setq #col$$$ (append #col$$$ (list #col$$)))
					)
				);_if
			);foreach
			#col$$$
		);##SameColList
		;--------------------------------------------------------------------

  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DRSeriCode (nth 3 #seri$)); 4.扉SERIES記号
      (setq CG_DRColCode  (nth 4 #seri$)); 5.扉COLOR記号
		)
	);_if

  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
			(setq #i 0)
			(setq #HIN_LR$ nil)
			(repeat (sslength #ss)
      	(if (= CG_SKK_ONE_CAB (CFGetSymSKKCode (ssname #ss #i) 1))
					(progn ; ｷｬﾋﾞﾈｯﾄだった
						(setq #xd$ (CFGetXData (ssname #ss #i) "G_LSYM"))
				    (setq #hinban     (nth 5 #xd$))
				    (setq #LR         (nth 6 #xd$))
						(setq #DRColCode  (nth 7 #xd$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"
						(setq #ret$ (StrParse #DRColCode ",")) ; 01/10/11 YM MOD ":"->","
						(setq #DRSeriCode (car  #ret$))
						(setq #DRColCode  (cadr #ret$))
; Xdataのｾｯﾄ個所は PCD_AlignDoor ---> 01/09/25 YM ADD-S G_LSYMに扉ｶﾗｰをｾｯﾄする
						(if (and #DRColCode (/= #DRColCode "")
										 (/= #DRColCode  CG_DRColCode ))
							(progn
								; #DRColCode,#DRSeriCode 追加　01/10/05 YM
								(setq #lis$ (list #DRColCode #DRSeriCode #hinban #LR))
								(setq #HIN_LR$ (append #HIN_LR$ (list #lis$)))
							)
						);_if
					)
				);_if
        (setq #i (1+ #i))
      )
    )
  );_if

	(setq #HIN_LR$ (CFListSort #HIN_LR$ 0)) ; (ｶﾗｰ,品番,LR)のﾘｽﾄをｶﾗｰでｿｰﾄする
	(setq #HIN_LR$$ (##SameColList #HIN_LR$)) ; 同じｶﾗｰごとにﾘｽﾄで分ける

	(setq #sFname (strcat CG_KENMEI_PATH "DoorInfo.CFG"))

;;;01/10/30YM@DEL	; 01/10/25 HN S-ADD
;;;01/10/30YM@DEL	(if (= nil CG_ColMix)
;;;01/10/30YM@DEL		(setq CG_ColMix (cadr (assoc "Patname" (ReadIniFile #sFname))))
;;;01/10/30YM@DEL	)
;;;01/10/30YM@DEL	; 01/10/25 HN S-ADD

  ;// ファイルへの書き込み
  (setq #fp  (open #sFname "w"))
  (princ ";;; 各物件フォルダに置く(見積りのタイミングで更新)" #fp)
  (princ "\n;;;"                                              #fp)
  (princ "\n;;; *** 図面とは異なる(扉ｼﾘｰｽﾞ,扉ｶﾗｰ) ***"        #fp)
  (princ "\n;;; DRSeriCode= : 扉SERIES記号"                 #fp)
  (princ "\n;;; DRColCode=  : 扉COLOR記号"                   #fp)
  (princ "\n;;; KOSU=       : ｷｬﾋﾞﾈｯﾄの数"                    #fp)
  (princ "\n;;; HINBAN?=    : 品番名称"                       #fp)
  (princ "\n;;; LR?=        : LR区分"                         #fp)
  (princ "\n;;; 以下個数分繰り返す"                           #fp)
  (princ "\n;;; *************************************"        #fp)
  (princ "\n;;; 以下図面と異なる(扉ｼﾘｰｽﾞ,扉ｶﾗｰ)の分繰り返す"  #fp)
  (princ "\n;;;"                                              #fp)
  (princ "\n;;;-----------------------------------------"     #fp)

	(if #HIN_LR$$
		(progn
			(setq #j 1)
			(foreach #HIN_LR$ #HIN_LR$$
				(setq #kosu (itoa (length #HIN_LR$)))
				(setq #DRColCode  (car  (car #HIN_LR$)))
				(setq #DRSeriCode (cadr (car #HIN_LR$)))
			  (princ (strcat "\n[Info" (itoa #j) "]" ) #fp)
			  (princ (strcat "\nDRSeriCode="           #DRSeriCode) #fp)
			  (princ (strcat "\nDRColCode="             #DRColCode) #fp)
			  (princ (strcat "\nKOSU="                       #kosu) #fp)
				(setq #k 1)
				(foreach #HIN_LR #HIN_LR$
			    (setq #hinban (nth 2 #HIN_LR))
			    (setq #LR     (nth 3 #HIN_LR))
				  (princ (strcat "\nHINBAN" (itoa #k) "=" #hinban)    #fp)
				  (princ (strcat "\nLR"     (itoa #k) "=" #LR)        #fp)
					(setq #k (1+ #k))
				)
				(setq #j (1+ #j))
			)

;;;01/10/30YM@DEL			; 01/10/11 YM ADD-S
;;;01/10/30YM@DEL			(if (= nil CG_ColMix)(setq CG_ColMix ""))
;;;01/10/30YM@DEL		  (princ "\n[ColorMixPattern]"   #fp)
;;;01/10/30YM@DEL		  (princ (strcat "\nPatname=" CG_ColMix) #fp)
;;;01/10/30YM@DEL;;;[ColorMixPattern]
;;;01/10/30YM@DEL;;;Patname=【扉MIX名】.ミックス名称 <--- ﾕｰｻﾞｰが扉部分変更時に選択
;;;01/10/30YM@DEL			; 01/10/11 YM ADD-E


		  (princ "\n;;;END\n"                                     #fp)
		  (close #fp)
		)
	);_if
  (princ)
);PH_OutPutDoorInfo

(princ)

