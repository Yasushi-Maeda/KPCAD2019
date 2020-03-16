;;;<<作動の変更>> 02/04/11 MH 
;;;
;;;●プラン検索自動作図で、I型で、マウントレンジフードが中間にくるプランは、
;;;  マウントレンジフードの左右で分割してフィラーを作成するように作動を変更。
;;;
;;;●プラン検索自動作図で、直前に フリープランからI型 で背面の指定の
;;;  ある天井フィラーを作成した後、I型、天井フィラー有りのプランを
;;;  作図させると不要な背面が作図される不具合を修正
;;;  
;;;<<プログラムの編集>>
;;;
;;;●フィラー範囲を求める部分でキャビネットの扉厚を26mmにキメウチして
;;;  いた部分をグローバル変数 SKW_FILLER_DOOR にして ファイルの先頭に
;;;  明記。現在は値 26 を設定（作図上の扉は20で書かれている）
;;;
;;;●フィラー領域からフィラー作図元ポリラインを算出する
;;;  関数 PcGetFilerOfsP&PL$ の内容がわかりにくかったので、関数を
;;;  分割して作動の内容にコメント追加。



;; 天井フィラー用グローバル変数
(setq SKW_FILLER_DOOR 25);扉厚  2008/08/12 YM MOD ﾌｨﾗｰの出を344=>355にする

(setq SKW_FILLER_SIDE 0)
(setq SKW_FILLER_LSIDE 0)
(setq SKW_FILLER_RSIDE 0)
(setq SKW_FILLER_BSIDE 0)
(setq SKW_FILLER_LLEN 0.0);00/10/25 SN ADD 左奥行処理の長さ PcGetFilerOfsP&PL$内で設定
(setq SKW_FILLER_RLEN 0.0);00/10/25 SN ADD 右奥行処理の長さ PcGetFilerOfsP&PL$内で設定
(setq SKW_FILLER_AUTO 'T) ; 自動生成なら T 手動手入力なら nil

;;;01/12/17YM@DEL(defun C:PosFiler  ( ) (setq SKW_FILLER_AUTO 'T)  (PosUpFiler 2 1))
;;;01/12/17YM@MOD(defun C:MakeFiler ( ) (setq SKW_FILLER_AUTO nil) (PosUpFiler 2 1))

; 01/12/17 YM MOD-S PosUpFiler関数書き換え
(defun C:PosFiler  ( ) (setq SKW_FILLER_AUTO 'T)  (PosUpFiler))
(defun C:MakeFiler ( ) (setq SKW_FILLER_AUTO nil) (PosUpFiler))
; 01/12/17 YM MOD-E

;<HOM>***********************************************************************
; <関数名>    : PosUpFiler
; <処理概要>  : 天井フィラー自動生成
; <戻り値>    : なし
; <作成>      : 01/02/06 MH MOD
; <備考>      : 01/12/17 YM ADD ﾌｨﾗｰを選択できるように修正(ﾀﾞｲｱﾛｸﾞを1つにまとめた)
; ﾌﾟﾗﾝ検索でここはとおらない→PKW_UpperFiller
;             : 02/04/10 MH I型でフィラーが外向きにはみ出して貼られる不具合（レア）
;             : についてはPcGetFilerOfsP&PL$関数中の注意書きを参照してください
;***********************************************************************>HOM<
(defun PosUpFiler (
  /
;-- 2011/07/21 A.Satoh Mod - S
;  #BLR$ #ECAB #ELV #FD #FH #HEIGHT #HINBAN #HINBAN$ #MSG #OF&PT$ #OFDIST #OFSETP$
;  #OPT$$ #PLWID #PT$ #QLY$ #QRY$$ #SIDE_L #SIDE_R #SITEM #SOPHIN #SQL$ #UPHEIGHT
  #BLR$ #ECAB #ELV #FD #FH #HEIGHT #MSG #OF&PT$ #OFDIST #OFSETP$ #kosu #en
  #OPT$$ #PLWID #PT$ #QLY$ #qry$ #SIDE_L #SIDE_R #SITEM #SOPHIN #SQL$ #UPHEIGHT
;-- 2011/07/21 A.Satoh Mod - S
;-- 2011/08/11 A.Satoh Mod - S
  #syokei
;-- 2011/08/11 A.Satoh Mod - E
	#sa_H #ERR ;2011/12/19 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PosUpFiler ////")
  (CFOutStateLog 1 1 " ")

  ;// コマンドの初期化
  (StartUndoErr) ;00/08/24 SN MOD Undo処理を先に呼びす
  (CFCmdDefBegin 6);00/09/26 SN ADD

  (setq #plWid (getvar "PLINEWID"))
  (setvar "PLINEWID" 0)

;;;02/03/29YM@DEL ;// ビューを登録 02/03/27 YM ADD-S
;;;02/03/29YM@DEL  (command "_view" "S" "TEMP_PF")
;;;02/03/29YM@DEL ;// ビューを登録 02/03/27 YM ADD-S

  ;// 天井フィラー品番候補の取得
  ;// プラ管OPテーブルを検索する
;;;  (setq #sql$
;;;    (list
;;;     (list "OP品区分"     "2"  'INT)
;;;     (list "ユニット記号" "K"  'STR)
;;;   )
;;;
;;;
;;;  )
;;;  (setq #qry$$ (CFGetDBSQLRec CG_DBSESSION "プラ管OP" #sql$))
;;;
;;; (if (= #qry$$ nil)
;;;   (progn
;;;     (CFAlertMsg msg8)
;;;     (quit)
;;;   )
;;; );_if

;;; (if #qry$$
;;;   (progn
;;;     (setq #Hinban$ nil)
;;;     (foreach #qry$ #qry$$
;;;       ;// オプション管理IDでプラ構OPテーブルを検索する
;;;       (setq #opt$$
;;;         (CFGetDBSQLRec CG_DBSESSION "プラ構OP"
;;;           (list (list "OPTID" (rtois (car #qry$)) 'INT))
;;;         )
;;;       )
;;;       (if (= #opt$$ nil)
;;;         (progn
;;;           (setq #msg (strcat "『プラ構OP』にレコードがありません。"))
;;;           (CFOutStateLog 0 1 #msg)
;;;           (CFAlertMsg #msg)
;;;           (*error*)
;;;         )
;;;         (progn
;;;           (setq #Hinban (nth 2 (car #opt$$)))
;;;           (setq #Hinban$ (append #Hinban$ (list #Hinban)))
;;;         )
;;;       );_if
;;;
;;;     );foreach
;;;   )
;;;   (progn
;;;      (CFAlertMsg "\"ﾌﾟﾗ管OP\"にﾚｺｰﾄﾞがありません。")
;;;      (exit)
;;;   )
;;; );_if

;-- 2011/07/21 A.Satoh Mod - S
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "天井フィラ"
      (list (list "扉シリ記号" CG_DRSeriCode 'STR))
    )
  )
  (if (= #qry$ nil)
    (progn
      (CFAlertMsg "天井フィラ情報を取得できません。")
      (exit)
    )
  )

; ;天幕の品番きめうち 2009/10/07 YM ADD
; (setq #Hinban$ '("HSCM240R-@@"))
;-- 2011/07/21 A.Satoh Mod - E

  ; ﾌｨﾗｰ高さﾃﾞﾌｫﾙﾄを求める
  (setq #UpHeight CG_UpCabHeight)
  (setq #elv (getvar "ELEVATION"))
  (setvar "ELEVATION" #UpHeight)

  ; 天井からの空隙と部材の高さ比較。
  (setq #fH (- CG_CeilHeight #UpHeight))


	;2013/11/19 YM ADD-S
	(setq #lis$$ nil);天井幕板の候補を、天井－吊元から絞り込む
	(foreach #qry #qry$
		(setq #HH (fix (+ (nth 1 #qry) 0.001))) ;100,200,300
		(setq #lis$$ (append #lis$$ (list (list #HH #qry))))
	)
	(cond
		((and (< 0.001 #fH)(> 100.001 #fH)) ;0<#fH<100
			(setq #qry$ (cdr (assoc 100 #lis$$)))
	 	)
		((and (< 100.001 #fH)(> 200.001 #fH)) ;0<#fH<200
			(setq #qry$ (cdr (assoc 200 #lis$$)))
	 	)
		((and (< 200.001 #fH)(> 300.001 #fH)) ;0<#fH<300
			(setq #qry$ (cdr (assoc 300 #lis$$)))
	 	)
		(T ;それ以外あり得ない
			(CFAlertMsg "天井幕板を作成できません。天井高さと吊元高さの差をご確認下さい。")
			(exit)
	 	)
	);cond
	;2013/11/19 YM ADD-E


  ; ﾌﾟﾗ管OP 検索,ﾌｨﾗｰ選択,ﾌｨﾗｰ高さなどのﾀﾞｲｱﾛｸﾞを表示

  ; 奥行き側面部の有無
  ; &PLNFLG プラン検索から起動されたなら'T  フリー設計ならnil
  ; フリー設計からだったらユーザーから左右の有無を求める 01/04/04 背面指定可能に変更
  (setq #SIDE_L SKW_FILLER_LSIDE)
  (setq #SIDE_R SKW_FILLER_RSIDE)
;-- 2011/07/21 A.Satoh Mod - S
;  (if (not (setq #BLR$ (PcGetFilerALLDlg #Hinban$ #fH)))
  (if (not (setq #BLR$ (PcGetFilerALLDlg #qry$)))
;-- 2011/07/21 A.Satoh Mod - E
    (progn
;;;01/12/19YM@DEL     (command "_Undo" "B")
      (exit)
    )
  );_if
  (setq SKW_FILLER_BSIDE (nth 0 #BLR$))
  (setq SKW_FILLER_LSIDE (nth 1 #BLR$))
  (setq SKW_FILLER_RSIDE (nth 2 #BLR$))
  (setq #sOPHIN          (nth 3 #BLR$))
  (setq #height          (nth 4 #BLR$))
;-- 2011/07/22 A.Satoh Add - S
  (setq #kosu            (nth 5 #BLR$))
;-- 2011/07/22 A.Satoh Add - E
;-- 2011/08/11 A.Satoh Add - S
  (setq #syokei          (nth 6 #BLR$))
;-- 2011/08/11 A.Satoh Add - E


;2011/12/19 YM ADD-S 天幕ﾁｪｯｸ
	(setq #sa_H (- CG_CeilHeight CG_UpCabHeight))
	(setq #ERR nil)
	;2013/11/19 YM MOD-S
	(if (and (< -0.001 (- #height #sa_H ))(> 100.001 (- #height #sa_H )))
;;;	(if (< 0.0001 (+ (- #sa_H #height) 0.01))
	;2013/11/19 YM MOD-E
		nil ;OK
	 	;else
	 	(setq #ERR T)
 	);_if

	(if #ERR
		(progn
      (CFAlertMsg "\n天井幕板を作成できません。天井高さと吊元高さの差をご確認下さい。")
      (quit) ;強制終了
		)
	);_if


  (setq #QLY$
    (CFGetDBSQLRec CG_DBSESSION "品番図形" (list (list "品番名称" #sOPHIN 'STR)))
  )
  (setq #QLY$ (KcChkQLY$ #QLY$ "品番図形" (strcat "品番名称=" #sOPHIN)))

  (setq #sItem   "天井フィラー")  ; 名称
;;;  ; 必須項目 厚み#fD 高さ#fH 取得
  (setq #fD      (nth 4 #QLY$)) ; ﾌｨﾗｰの厚みは品番図形を参照 ;2008/06/28 YM OK!
  (setq #ofDIST  SKW_FILLER_SIDE) ; オフセット量

  ; グローバル変数SKW_FILLER_AUTOで範囲自動計算か手入力か判定
  (cond
    (SKW_FILLER_AUTO
      ;; フィラー設置基準図形をユーザーから求める
      (setq #eCAB (PcSelItemForFiller #sItem))
      ;; 図形が取得されなかったら処理終了
      (if (/= 'ENAME (type #eCAB)) (exit))
      ;; 自動配置フィラー設置基準ポリライン点リスト取得
      (setq #of&pt$ (PcGetFilerOfsP&PL$ #eCAB #ofDIST nil))
    )
    ;; 手入力でフィラー設置基準ポリライン点リスト獲得
    (t (setq #of&pt$ (list (PcDrawPlinePtWithOffset 1 #ofDIST))))
  ); cond

  (CFNoSnapReset);00/08/24 SN ADD 00/08/28 MH MOD ユーザ点取得に干渉を防ぐため位置移動。
  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart)

  ; 天井フィラー設置実行
  (foreach #o&p$ #of&pt$
    (setq #ofsetP$ (car #o&p$))
    (setq #pt$ (cadr #o&p$))
;-- 2011/07/22 A.Satoh Mod - S
;    (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height #UpHeight) ; 01/12/17 YM 引数削除
;-- 2011/08/11 A.Satoh Mod - S
;    (setq #en (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height #UpHeight))

		;2013/11/19 YM MOD-S
;;;    setq #en (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height #UpHeight #syokei))
    (setq #en (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #sa_H #UpHeight #syokei))
		;2013/11/19 YM MOD-E

;-- 2011/08/11 A.Satoh Mod - E

    ; 個数を拡張データに設定
    (if (>= #kosu 2)
      (SetOpt #en (list (list #sOPHIN (1- #kosu))))
    )
;-- 2011/07/22 A.Satoh Mod - E
;;;01/12/17YM@MOD    (PcMakeFiler #sOPHIN &iOPTID #pt$ #ofsetP$ #fD #height #UpHeight)
  ); foreach

;;;02/03/29YM@DEL  ;// ビューを戻す
;;;02/03/29YM@DEL  (command "_view" "R" "TEMP_PF") ; 02/03/27 YM ADD

  (princ (strcat "\n" #sItem ":["))
  (princ #sOPHIN)
  (princ "]")
  ;(setq SKW_FILLER_SIDE #FSIDE); グローバル設定を戻す ; 01/01/19 MH 使用してない
  (setvar "ELEVATION" #elv) ; 元の高さに戻す
  (setvar "PLINEWID" #plWid)
  ;// Ｏスナップ関連システム変数を元に戻す
  (CFNoSnapEnd)
  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)

);PosUpFiler

;;;01/12/17 YM ADD ﾌｨﾗｰを選択できるように修正(ﾀﾞｲｱﾛｸﾞを1つにまとめた)


;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_UpperFiller
;;; <処理概要>  : （プラン検索用）天井フィラーを生成する
;;; <戻り値>    :
;;; <作成>      : 02/04/05 MH
;;; <備考>      : ﾏｳﾝﾄﾌｰﾄﾞが間にあり、設置領域が2つあるプランに対応
;;;*************************************************************************>MOH<
(defun PKW_UpperFiller (/ #QLY$ #sOPHIN #eBASE #eBASE$)

;2009/11/21 YM DEL
;;;  ;; 天井ﾌｨﾗｰ自動生成後にnilになるのでここで再定義
;;;  (setq SKW_FILLER_LSIDE 0)
;;;  (setq SKW_FILLER_RSIDE 0)
;;;  (setq SKW_FILLER_BSIDE 0)
(if (= nil SKW_FILLER_LSIDE)(setq SKW_FILLER_LSIDE 0))
(if (= nil SKW_FILLER_RSIDE)(setq SKW_FILLER_RSIDE 0))
(if (= nil SKW_FILLER_BSIDE)(setq SKW_FILLER_BSIDE 0))

  ;; フィラー作成基準アイテムリストを取得（各フィラー領域につき1図形）
  (setq #eBASE$ (PKW_GetFillerBaseItemList))

  (foreach #eBASE #eBASE$
    (PcMkFillerInPLAN
      #eBASE                            ; 基準とするアイテムの図形名
      CG_CeilHeight                     ; 天井高さ=2400mm
      CG_UpCabHeight                    ; 取り付け高さ=2300mm
    )
  ) ;_ if

  (WebOutLog "天井ﾌｨﾗｰを生成しました"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  (princ)
) ;_PKW_UpperFiller

;<HOM>*************************************************************************
; <関数名>    : PKW_GetFillerBaseItemList
; <処理概要>  : （プラン検索用）天井フィラー設置基準図形リスト作成
;                ﾏｳﾝﾄﾌｰﾄﾞが間にあり、設置領域が2つあるプランに対応
; <戻り値>    :  図形名リスト または nil
; <作成>      : 02/04/05 MH
; <備考>      : 分割＝ I型でﾏｳﾝﾄ型ﾌｰﾄﾞを含み左端右端両方ﾏｳﾝﾄ型ﾌｰﾄﾞでないプラン
;*************************************************************************>MOH<
(defun PKW_GetFillerBaseItemList (
  /
  #sym$ #eBASE$ #eMount #enL #enR #enX$ #eWALL #iCORNER #sym 
  )
  
  ;; 現図面中のウォール高さのアイテム全図形名リスト提出
  (setq #sym$ (KcSameLevelItem CG_SKK_TWO_UPP)) ; 吊戸ｼﾝﾎﾞﾙﾘｽﾄ(ﾚﾝｼﾞﾌｰﾄﾞ含む)  

  ;; I 型でかつﾏｳﾝﾄ型ﾌｰﾄﾞがあるか判定
  (setq #EnX$ nil)   ; (基点X値  図形名) リスト
  (setq #eWall nil)  ; 吊戸型ｷｬﾋﾞ図形名
  (setq #eMount nil) ; ﾏｳﾝﾄ型ﾌｰﾄﾞ図形名
  (setq #iCorner 0)  ; ｺｰﾅｰｷｬﾋﾞの数

  (foreach #sym #sym$
    ;; ｺｰﾅｰｷｬﾋﾞの数をカウント
    (if (= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3)) (setq #iCorner (1+ #iCorner)))

    ;; 吊戸ｷｬﾋﾞ図形名取得
    (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #sym 1)) (setq #eWall #sym)) 

    ;; ﾏｳﾝﾄ型ﾌｰﾄﾞ図形名取得
    (if (= 328 (nth 9 (CFGetXData #sym "G_LSYM"))) (setq #eMount #sym))

    ;; 構成ｱｲﾃﾑの(X値 図形名)リスト作成
    (setq #EnX$ (cons (list (car (cdr (assoc 10 (entget #sym)))) #sym) #EnX$))
  )

  ;; Ｉ型でマウントフード有りなら分割配置の処理判定
  (setq #eBASE$ nil) 
  (if (and (= 0 #iCorner) (= 'ENAME (type #eMount)))
    (progn
      ;; リストを基点のX値順で並べ替え
      (setq #EnX$ (PcListOrderByNumInList #EnX$ 0))
      ;; 頭car(左端) と 最後last(右端) のアイテムを取得 
      (setq #enL (cadr (car #EnX$)))
      (setq #enR (cadr (last #EnX$)))
      ;; 両端ともマウント型フード以外なら この２アイテムで２回フィラー設置を行う
      (if (and (not (eq #enL #eMount))
               (not (eq #enR #eMount))
          )
        (setq #eBASE$ (list #enL #enR))
      );_ if
    )
  )

  ;; 一般処理は１回フィラー設置を行う。吊戸型ｷｬﾋﾞ図形名設定
  (if (and (= nil #eBASE$) (= 'ENAME (type #eWall)))
    (setq #eBASE$ (list #eWall))
  )

  ;; 図形名リストを返す（設置図形がなかった場合はnilが返る）
  #eBASE$
);_PKW_GetFillerBaseItemList

;<HOM>*************************************************************************
; <関数名>    : PcMkFillerInPLAN
; <処理概要>  : 天井フィラーを生成（プラン検索用）
; <戻り値>    :
; <作成>      : 00/10/06 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcMkFillerInPLAN (
  &eBASE          ;(LIST)ベースキャビ基準シンボルの図形リスト
  &CeilHeight     ;(REAL)天井高さ
  &UpCabHeight    ;(REAL)取り付け高さ
  /
  #QLY$ #fD #height #of&pt$ #o&p$ #ofsetP$ #pt$ #CFG$ #sCOL #sOPHIN #QLY$$ #kosu
  )
  (WebOutLog "天井ﾌｨﾗｰの生成処理(PcMkFillerInPLAN)"); 02/09/04 YM ADD ﾛｸﾞ出力追加

  (if (= nil (tblsearch "LAYER" SKW_AUTO_SECTION))
    (command "_layer" "N" SKW_AUTO_SECTION "C" 2 SKW_AUTO_SECTION "L"
      SKW_AUTO_LAY_LINE SKW_AUTO_SECTION "")
  ); if

  (if (= "K" (nth  3 CG_GLOBAL$));ｷｯﾁﾝのとき
    (progn
      ;天井幕板の品番取得
      (setq #QLY$$
        (CFGetDBSQLRec CG_DBSESSION "天井幕板"
          (list
            (list "シンク側間口" (nth 4  CG_GLOBAL$) 'STR)
            (list "形状"         (nth 5  CG_GLOBAL$) 'STR)
            (list "変換値"       (nth 46 CG_GLOBAL$) 'STR)
            (list "扉シリ記号"   (nth 12 CG_GLOBAL$) 'STR)
          )
        )
      )
      (setq #kosu (length #QLY$$))
      (setq #sOPHIN  (nth 4 (car #QLY$$))) ; 品番
    )
    (progn ;"D"収納

      (cond
        ;((= CG_SeriesDB "SDA") ;2011/02/01 YM MOD【PG分岐】
        ((= BU_CODE_0002 "1") 
          ;天井幕板の品番取得
          (setq #QLY$$
            (CFGetDBSQLRec CG_DBSESSION "天井幕板D"
              (list
                (list "変換値"       (nth 72 CG_GLOBAL$) 'STR)
              )
            )
          )
        )
        ;((= CG_SeriesDB "SDB") ;2011/02/01 YM MOD【PG分岐】
        ((= BU_CODE_0002 "2")  
          ;天井幕板の品番取得
          (setq #QLY$$
            (CFGetDBSQLRec CG_DBSESSION "天井幕板D"
              (list
                (list "変換値"       (nth 72 CG_GLOBAL$) 'STR)
                (list "扉シリ記号"   (nth 62 CG_GLOBAL$) 'STR);2009/10/27 YM ADD KEY追加
              )
            )
          )
        )
        (T ;__OTHER
          ;天井幕板の品番取得
          (setq #QLY$$
            (CFGetDBSQLRec CG_DBSESSION "天井幕板D"
              (list
                (list "変換値"       (nth 72 CG_GLOBAL$) 'STR)
                (list "扉シリ記号"   (nth 62 CG_GLOBAL$) 'STR);2009/10/27 YM ADD KEY追加
              )
            )
          )
        )
      );_cond

      (setq #kosu (length #QLY$$))
      (setq #sOPHIN  (nth 2 (car #QLY$$))) ; 品番
    )
  );_if

  ;品番図形テーブルからクエリ取得
  (setq #QLY$
    (CFGetDBSQLRec CG_DBSESSION "品番図形" (list (list "品番名称" #sOPHIN 'STR)))
  )
  (setq #QLY$ (KcChkQLY$ #QLY$ "品番図形" (strcat "品番名称=" #sOPHIN)))
  ; 必須項目 厚み#fD 取得
  (setq #fD (nth 4 #QLY$));2008/06/28 YM OK!

  ; 高さ取得


;2011/12/19 YM ADD-S 天幕ﾁｪｯｸ
;特性ID	表示順	特性値	特性値名
;PLAN46	1	X	-----
;PLAN46	2	N	取付けない
	(setq #height (- &CeilHeight &UpCabHeight))

;2013/11/19 YM DEL-S
;;;	(if (and CG_GLOBAL$ (nth 46 CG_GLOBAL$) (/= (nth 46 CG_GLOBAL$) "N")(/= (nth 46 CG_GLOBAL$) "X"))
;;;		(progn ;天井高さ,吊元高さﾁｪｯｸ CG_CeilHeight , CG_UpCabHeight
;;;			(cond
;;;				((= "A" (nth 46 CG_GLOBAL$))
;;;  				(setq #height 100.0)
;;;			 	)
;;;				((= "B" (nth 46 CG_GLOBAL$))
;;;  				(setq #height 200.0)
;;;			 	)
;;;				((= "C" (nth 46 CG_GLOBAL$))
;;;  				(setq #height 300.0)
;;;			 	)
;;;				(T
;;;  				(setq #height (- &CeilHeight &UpCabHeight))
;;;			 	)
;;;			);_cond
;;;		)
;;;	);_if
;;;
;;;	(if (and CG_GLOBAL$ (nth 72 CG_GLOBAL$) (/= (nth 72 CG_GLOBAL$) "N")(/= (nth 72 CG_GLOBAL$) "X"))
;;;		(progn ;天井高さ,吊元高さﾁｪｯｸ CG_CeilHeight , CG_UpCabHeight
;;;			(cond
;;;				((= "A" (nth 72 CG_GLOBAL$))
;;;  				(setq #height 100.0)
;;;			 	)
;;;				((= "B" (nth 72 CG_GLOBAL$))
;;;  				(setq #height 200.0)
;;;			 	)
;;;				((= "C" (nth 72 CG_GLOBAL$))
;;;  				(setq #height 300.0)
;;;			 	)
;;;				(T
;;;  				(setq #height (- &CeilHeight &UpCabHeight))
;;;			 	)
;;;			);_cond
;;;		)
;;;	);_if
;2013/11/19 YM DEL-E

  ; フィラー領域アイテムの図形名と領域点列(補正有)のリストを算出
  (setq #of&pt$
    (PcGetFilerOfsP&PL$
    &eBASE            ; 基準とするウォールキャビの図形名
    SKW_FILLER_SIDE   ; 扉なしのオフセット値
    'T                ; プラン検索から起動= 'T  フリー設計ならnil
    )
  ); setq



  ; フィラー作図&データセット実行
  (foreach #o&p$ #of&pt$
    (setq #ofsetP$ (car #o&p$))
    (setq #pt$ (cadr #o&p$))

    ;2011/05/21 YM MOD 吊戸下OPEN_BOXのときZ=2150mmに補正する
    (if (and (= CG_PlanType "SD")(/= (nth 59 CG_GLOBAL$) nil)(/= (nth 59 CG_GLOBAL$) "N"))
;-- 2011/08/11 A.Satoh Mod - S
;      ;吊戸下OPEN_BOXあり
;      (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height CG_WallUnderOpenBoxHeight)
;      ;else
;      (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height CG_UpCabHeight)
      ; プラン検索時は、初期値を「キッチン("A")」で設定
      ;吊戸下OPEN_BOXあり
      (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height CG_WallUnderOpenBoxHeight "A")
      ;else
      (PcMakeFiler #sOPHIN #pt$ #ofsetP$ #fD #height CG_UpCabHeight "A")
;-- 2011/08/11 A.Satoh Mod - E
    );_if


  ); foreach

  (princ)
) ;PcMkFillerInPLAN

;<HOM>***********************************************************************
; <関数名>    : KcChkQLY$
; <処理概要>  : 単一前提のクエリの結果チェック
; <戻り値>    : クエリリスト または nil
; <作成>      : 01/02/06 MH MOD
; <備考>      : クエリ数 0 または複数の場合 エラーメッセージ表示終了
;***********************************************************************>HOM<
(defun KcChkQLY$ (&QLY$ &sTable &addMSG / #msg)
  (cond
    ((not &QLY$)
      (setq #msg (strcat "『" &sTable "』にﾚｺｰﾄﾞがありません。\n" &addMSG))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    ((< 1 (length &QLY$))
      (setq #msg (strcat "『" &sTable "』にﾚｺｰﾄﾞが複数存在します。\n" &addMSG))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
    (t (car &QLY$))
  ); cond
); KcChkQLY$

;<HOM>*************************************************************************
; <関数名>    : PcDrawPlinePtWithOffset
; <処理概要>  : 連続する線を作図させその端点のリストを取得する
; <戻り値>    : (オフセット基準点   作成した点列リスト）
; <作成>      : 00-04-17 MH
; <備考>      : オフセット間隔も設定するように変更 00/12/25 MH MOD
;*************************************************************************>MOH<
(defun PcDrawPlinePtWithOffset (
  &mode         ;(INT) 閉じるを有効とするか(メッセージのみ)0:無効 1:有効
  &defoD        ; デフォルトのオフセット量
  /
  #en$ #loop #msg #p1 #p2 #pt$ #os #eDEL #subP$ #dist$ #pt$ #crosP
  #i #i2 #ofANG$ #pt$2 #new$ #ofP$ #C_FLG #ePL #clseFLG #midP #ofP2
  #dist #ofP ;02/03/29MH@ADD
  )
  (setq #dist (fix &defoD))
  (setq #loop T)
  (setq #p1 (getpoint (strcat "\n始点: ")))
  (setq #dist$ (list 0))
  (setq #pt$ (list #p1))
  (while (= T #loop)
    (cond
      ; C有効モード
      ((and (= &mode 1) (/= nil #p1) (< 3 (length #pt$)))
        (initget 128 "-a 1a 2a 3a 4a 5a 6a 7a 8a 9a U C")
        (setq #p2 (getpoint #p1 (strcat "\n次点 /U=戻す/C=閉じる/: ")))
        (if (and (= 'STR (type #p2)) (numberp (read #p2))) (progn
          (setq #dist (fix (read #p2)))
          (initget "U C")
          (setq #p2 (getpoint #p1 (strcat "\n次点 /U=戻す/C=閉じる/: ")))
        )); if progn
      )
      ((/= nil #p1) ; Cなしモード
        (initget 128 "-a 1a 2a 3a 4a 5a 6a 7a 8a 9a U")
        (setq #p2 (getpoint #p1 (strcat "\n次点 /U=戻す/: ")))
        (if (and (= 'STR (type #p2)) (numberp (read #p2))) (progn
          (setq #dist (fix (read #p2)))
          (initget "U")
          (setq #p2 (getpoint #p1 (strcat "\n次点 /U=戻す/: ")))
        )); if
      )
    ); cond
    (cond
      ((= nil #p2)
        (setq #loop nil)
      )
      ((= "U" #p2)
        (setq #p1 (trans (cdr (assoc 10 (entget (car #en$)))) 0 1))
        (entdel (car #en$))
        (setq #en$ (cdr #en$))
        (setq #pt$ (cdr #pt$))
        (setq #dist$ (cdr #dist$))
      )
      (T
        (if (= "C" #p2) (progn
          (setq #loop nil)
          (setq #p2 (last #pt$))
        )); if progn
        (setq #dist$ (cons #dist #dist$))
        (setq #pt$ (cons #p2 #pt$))
        (setq #os (getvar "OSMODE"))
        (setvar "OSMODE" 0)
        (command "_line" #p1 #p2 "")
        (command "_change" (entlast) "" "P" "C" "1" "")
        (setvar "OSMODE" #os)
        (setq #p1 #p2)
        (setq #en$ (cons (entlast) #en$))
      )
    )
  )

  (setq #ofP (getpoint "設置する内側方向を指示 :")) ; HOPE-0359 01/03/02 MH MOD
  ;(setq #ofP (getpoint "設置する天井処理アイテムの内側方向を指示 ："))
  ; 距離の一点目の値は0(使用しない)ので除去
  (mapcar 'entdel #en$)
  (setq #dist$ (cdr (reverse #dist$)))
  (setq #pt$ (reverse #pt$))

  ; 00/12/25 MH ADD 取得されたポリラインにオフセットした点リストを算出
  (if (not (equal &defoD 0 0.01)) (progn
    (setq #clseFLG (equal (car #pt$) (last #pt$) 0.01))
    (if #clseFLG
      (MakeLwPolyLine (cdr #pt$) 1 CG_UpCabHeight) ; 閉じたポリライン
      (MakeLwPolyLine #pt$ 0 CG_UpCabHeight)       ; 開いたポリライン
    )
    (setq #ePL (entlast))
    ; オフセット量がマイナス値の場合、オフセット点をポリラインの外に出す
    (if (> 0 &defoD)
      (progn
        (setq #midP (inters #ofP
          (pcpolar #ofP (+ (* 0.5 pi) (angle (car #pt$)(cadr #pt$))) 100)
          (car #pt$)(cadr #pt$) nil))
        (setq #ofP2 (pcpolar #midP (angle #ofP #midP) (distance #ofP #midP)))
      ); progn
      (setq #ofP2 (list (car #ofP)(cadr #ofP)))
    ); if
    (command "_offset" (abs &defoD) #ePL #ofP2 "")
    (setq #pt$ (GetLWPolyLinePt (entlast)))
    (entdel #ePL)
    (entdel (entlast))
    (if #clseFLG (progn
      (setq #p2 (last #pt$))
      (setq #pt$ (cons #p2 #pt$))
    )); if progn
  )); if progn

  (list (list (car #ofP)(cadr #ofP)) #pt$)
); PcDrawPlinePtWithOffset

;<HOM>*************************************************************************
; <関数名>    : KcSameLevelItem
; <処理概要>  : 現図面中の特定高さのアイテムの図形名リスト提出
; <戻り値>    : 図形名のリストか nil
; <作成>      : 01/02/02 MH
; <備考>      :
;*************************************************************************>MOH<
(defun KcSameLevelItem (
    &iHIGH     ; 高さを示す整数(性格CODE2桁目の数字)
    /
    #ss #i #eONE #eSEL$
  )
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if #ss (progn
    (setq #i 0)
    (repeat (sslength #ss)
      (setq #eONE (ssname #ss #i))
      (if (= &iHIGH (CFGetSymSKKCode #eONE 2)) (setq #eSEL$ (cons #eONE #eSEL$)))
      (setq #i (1+ #i))
    ); repeat
  )) ; if progn
  #eSEL$
);_KcSameLevelItem

;;;<HOM>*************************************************************************
;;; <関数名>    : PcSelItemForFiller
;;; <処理概要>  : 天井フィラー設置の基準となるアイテムをユーザーに選択させる
;;; <戻り値>    : 図形名か nil (キャンセルされた場合)
;;; <作成>      : 02/04/05 MH
;;; <備考>     * ｳｫｰﾙ位置のｷｬﾋﾞﾈｯﾄかﾚﾝｼﾞﾌｰﾄﾞ、ﾏｳﾝﾄ型ﾌｰﾄﾞは不可とする
;;;            * ﾀﾞｲﾆﾝｸﾞが指示されたなら、他の図形に基準を移す
;;;*************************************************************************>MOH<
(defun PcSelItemForFiller (
  &sItem       ; フィラーの名称
  /
  #en #NEXT$ #chgCAB #i
  )

  (setq #en 'T)
  (while (and #en (not (= 'ENAME (type #en))))

    ;; ユーザーに図形を選択させる 02/03/27 YM MOD ﾌｰﾄﾞは選ばせない
    (setq #en (car (entsel (strcat "\n" &sItem "を設置するキャビネットを選択 ："))))

    ;; 設置可能図形か検査
    (if #en
      (progn
        (setq #en (SearchGroupSym #en))
        (cond
          ;; アイテム以外の図形およびウォール位置以外の図形はメッセージ出し再取得
          ((not #en)
            (CFAlertMsg "設置するキャビネットを選択してください。")
            (setq #en 'T)
          )
          ((not (= CG_SKK_TWO_UPP (CFGetSymSKKCode #en 2)))
            (CFAlertMsg "吊戸を選択してください。")
            (setq #en 'T)
          )
          ;; マウント型フード"328" が指定されたならばメッセージ出し再取得
          ((= 328 (nth 9 (CFGetXData #en "G_LSYM")))
            (CFAlertMsg "ﾏｳﾝﾄ型ﾌｰﾄﾞは対象から除外されます\n吊戸をｸﾘｯｸしてください")
            (setq #en 'T)
          )
        ) ;_cond
        ;; 上記の条件以外は設置可能
      )
    ) ;_ if
    ;; #en = 'T ならばループ再開
  ) ;_ while

  ;; ﾀﾞｲﾆﾝｸﾞのあるL型対策。ﾀﾞｲﾆﾝｸﾞｷｬﾋﾞが指定されていたらそれ以外に移す
  (if (and (= 'ENAME (type #en))
           (= CG_SKK_THR_DIN (CFGetSymSKKCode #en 3))
      )
    (progn
      ;; フィラー領域アイテムの図形名と領域点列(補正有)のリストを算出
      (setq #NEXT$ (PcGetFillerAreaItem$ #en))
      (setq #chgCAB nil)
      (setq #i 0)
      ;; フィラー設置可能隣接図形リストの中からﾀﾞｲﾆﾝｸﾞ以外の図形を取得
      (while (and (not #chgCAB) (< #i (length #NEXT$)))
        (setq #chgCAB (car (nth #i #NEXT$)))
        ;; ﾀﾞｲﾆﾝｸﾞ以外のｷｬﾋﾞﾈｯﾄ は許可
        (if (not (and (= CG_SKK_ONE_CAB (CFGetSymSKKCode #chgCAB 1)) ; ｷｬﾋﾞ
                      (/= CG_SKK_THR_DIN (CFGetSymSKKCode #chgCAB 3)); 非ﾀﾞｲﾆﾝｸﾞ
            ))
          (setq #chgCAB nil)
        )
        (setq #i (1+ #i))
      ) ;_ while
      ;; 隣接のﾀﾞｲﾆﾝｸﾞ以外キャビが取得されていれば、結果図形を移す。
      ;; (取得されなければそのまま)
      (if #chgCAB
        (setq #en #chgCAB)
      )
    )
  ) ;_ if

  ;; 結果図形名 または nil 返す
  #en
)

;<HOM>*************************************************************************
; <関数名>    : PcGetFillerAreaItem$
; <処理概要>  : フィラー領域アイテム図形名と扉分補正済点列のリストを算出
; <戻り値>    : ((図形名 (外形線P点)) (図形名 (外形線P点))･･･)
; <作成>      : 02/04/04 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcGetFillerAreaItem$ (
  &eCAB       ; 基準図形名
  /
  #CHK$ #CHKREST$ #EADD$ #I #NEXT$ #NEXTFLG #REST$ #STOPFLG #UPPER$
  )  
  ;; フィラー設置可能 全アイテム外形線P点リスト作成
  ;; ((図形名 (外形線P点)) (図形名 (外形線P点))･･･)
  (setq #UPPER$ (PcGetUpperItemPL$))
  
  ; 基準図形の外形線P点リストを全アイテムリストから摘出、隣接基準1として取得
  (setq #eADD$ (assoc &eCAB #UPPER$))
  (setq #NEXT$ (list #eADD$))
  (setq #REST$ (PcDelInList (list #eADD$) #UPPER$))

  ; 外形線P点リストから、基準図形の隣接図形リスト#NEXT$を取得する
  (setq #stopFLG nil)
  (while (and (not #stopFLG) (setq #chkREST$ #REST$))
    (setq #stopFLG 'T)
    (while (and #stopFLG (setq #CHK$ (car #chkREST$)))
      ; #CHK$ の領域が #NEXT$ の全領域と隣接するかチェックする
      (setq #nextFLG nil)
      (setq #i 0)
      (while (and (not #nextFLG) (< #i (length #NEXT$)))
        (setq #nextFLG (PcJudgeCrossing (cadr #CHK$) (cadr (nth #i #NEXT$))))
        (setq #i (1+ #i))
      ); while
      ; 隣接だった
      (if #nextFLG (progn
        ; #NEXT$ 隣接リストにこのリストを加える
        (setq #NEXT$ (cons #CHK$ #NEXT$))
        ; #REST$からこのリストを抜く
        (setq #REST$ (PcDelInList (list #CHK$) #REST$))
        ; フラグ変更
        (setq #stopFLG nil)
      )); if progn
      (setq #chkREST$ (cdr #chkREST$))
    ); while
  ); while

  #NEXT$
); PcGetFillerAreaItem$

;<HOM>*************************************************************************
; <関数名>    : PcGetEn$CrossItemArea
; <処理概要>  : 図形名リスト中あるアイテムの指定範囲に重複位置する名を提出
; <戻り値>    : 図形名のリスト なし= nil
; <作成>      : 00/09/14 MH
; <備考>      : 接する位置の図形も取得するかどうかフラグで判断
;*************************************************************************>MOH<
(defun PcGetEn$CrossItemArea (
  &eONE       ; チェック元になる図形名
  &iL &iR &iF &iB ; 範囲を指定する左右前後の伸縮値(0で元図形範囲と同値)
  &flgNX      ; このフラグが 'T なら、指定範囲に接する位置の図形も取得
  &eCHK$      ; チェックする対象となる図形名リスト
  /
  #eCHK$ #dSQR$ #TEMP$ #eCHK #dCHK$ #pFLG #RES$
  )
  (setq #RES$ nil)
  (setq #eCHK$ &eCHK$)
  ;;; 範囲に接する図形を取得しないのなら、範囲全体を1mm縮小する。
  (if (not &flgNX) (progn
    (setq &iL (1- &iL))
    (setq &iR (1- &iR))
    (setq &iF (1- &iF))
    (setq &iB (1- &iB))))
  (setq #dSQR$ (PcGetItem4P$ &eONE &iL &iR &iF &iB))
  ; チェック対象の図形リストから比較元の図形を除く
  (setq #eCHK$ (PcDelInList (list &eONE) #eCHK$))
  ; 元矩形と各図形の辺が交わるか、点は範囲内に入るか、をチェック
  (while (setq #eCHK (car #eCHK$))
    ;;; チェックするアイテムの矩形領域４点を求める
    (setq #dCHK$ (PcGetItem4P$ #eCHK 0 0 0 0))
    (setq #pFLG (PcJudgeCrossing #dSQR$ #dCHK$))
    (if #pFLG (setq #RES$ (cons #eCHK #RES$)))
    (setq #eCHK$ (cdr #eCHK$))
  ); end of while
  ; 結果を返す nil か リスト
  #RES$
); PcGetEn$CrossArea

;<HOM>*************************************************************************
; <関数名>    : PcDelInList
; <処理概要>  : リスト中の指定のリスト内の要素を抜く
; <戻り値>    : リスト か nil
; <作成>      : 00/09/14 MH
;*************************************************************************>MOH<
(defun PcDelInList (#DEL$ #ORG$ / #TEMP$)
  (setq #TEMP$ nil)
  (foreach #OG #ORG$
    (if (not (member #OG #DEL$))
      (setq #TEMP$ (append #TEMP$ (list #OG))))
    )
  #TEMP$
); PcDelInList

;;;<HOM>*************************************************************************
;;; <関数名>    : PcGetUpperItemPL$
;;; <処理概要>  : フィラー複合領域取得用 対象図形+領域点列リスト作成
;;;             : 対象図形名リストから 天井フィラー不可アイテム除外
;;;             : 扉厚を抜いた外形線リストを算出して追加
;;; <戻り値>    : ((図形名 (外形線点列)) (図形名 (外形線点列))･･･) または nil
;;; <作成>      : 02/04/04 MH
;;; <備考>   * ﾏｳﾝﾄ型ﾚﾝｼﾞﾌｰﾄﾞ,ｻｲﾄﾞﾊﾟﾈﾙはリストから除外
;;;          * ﾚﾝｼﾞﾌｰﾄﾞ は隣接図形から奥行き取得
;;;          * ｺｰﾅｰｷｬﾋﾞのみP面から点列算出,他図形はLSYMの値で点列算出
;;;*************************************************************************>MOH<
(defun PcGetUpperItemPL$ (
  /
  #DPL$ #DPT #DUM$$ #ECNR$ #EITEM$ #EUPPER$ #FD #GSYM$ #LSYM$ #RES$ 
  )

  ;; 図面中から全アッパー高さのアイテムリスト取得
  (setq #eUPPER$ (KcSameLevelItem CG_SKK_TWO_UPP))

  ;; ﾌｨﾗｰ設置対象にならない図形除外とｺｰﾅｰｷｬﾋﾞ分別
  (setq #dum$$ nil)
  (setq #eCNR$ nil)  ;; ｺｰﾅｰｷｬﾋﾞ図形リスト 
  (foreach #en #eUPPER$
    (cond
      ;; ｻｲﾄﾞﾊﾟﾈﾙ 除外 02/01/16 YM ADD-S
      ((= CG_SKK_ONE_SID (CFGetSymSKKCode #en 1))
      )
      ;; ﾏｳﾝﾄ型ﾌｰﾄﾞ"328" 除外 02/03/29MH@ADD
      ((= 328 (nth 9 (CFGetXData #en "G_LSYM")))
      )
      ;; ｺｰﾅｰｷｬﾋﾞは 図形リスト取得
      ((= CG_SKK_THR_CNR (CFGetSymSKKCode #en 3))
        (setq #eCNR$ (cons #en #eCNR$))
      )
       ;; ｺｰﾅｰｷｬﾋﾞ以外のフィラー設置可能図形リスト
      (t (setq #dum$$ (cons #en #dum$$)))
    )
  )
  (setq #eITEM$ #dum$$)

  (setq #Res$ nil) ; 結果リスト初期化

  ;; ｺｰﾅｰｷｬﾋﾞ (図形名 (外形線点列)) 結果リスト追加
  (foreach #en #eCNR$
    (setq #dPL$ (PcCornerCabPLByPMen #en))
    (setq #Res$ (cons (list #en #dPL$) #Res$))
  )

  ;; ｺｰﾅｰｷｬﾋﾞ以外のフィラー設置図形 (図形名 (外形線点列)) 結果リスト追加
  (foreach #en #eITEM$
    (setq #dPT (cdr (assoc 10 (entget #en))))
    (setq #LSYM$ (CFGetXData #en "G_LSYM"))
    (setq #GSYM$ (CFGetXData #en "G_SYM"))
    ;; 奥行値取得
    ;; 図形がレンジフードであれば隣接図形のD値取得
    (if (= CG_SKK_ONE_RNG (CFGetSymSKKCode #en 1))
      (setq #fD (PcGetRange&SideFilrD #en #eUPPER$)) 
      ; それ以外の図形
      (setq #fD (nth 4 #GSYM$))
    )
    ;; 算出された奥行きとGSYM LSYMから点列を出す
    (setq #dPL$ (PcMk4P$byWD&Ang #dPT (nth 3 #GSYM$) #fD (nth 2 #LSYM$)))
    (setq #Res$ (cons (list #en #dPL$) #Res$))
  );_ foreach

  ;; 結果リストを返す
  #Res$

);_ PcGetUpperItemPL$

;;;<HOM>*************************************************************************
;;; <関数名>    : PcCornerCabPLByPMen
;;; <処理概要>  : ｺｰﾅｰｷｬﾋﾞのP面点列から扉面を除いた外形点リスト算出
;;; <戻り値>    : 扉厚除く点列（算出に失敗した場合P面構成点列を返す）
;;; <作成>      : 02/04/04 MH
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PcCornerCabPLByPMen (
  &eCNR         ; ｺｰﾅｰｷｬﾋﾞ図形名
  /
  #D0 #D1 #D2 #D2NEW #D3NEW #D4 #D4NEW #D5 #DNEW$ #DPMEN$
  #EN #EPMEN #ERR #FANG #GSYM$ #I #LSYM$ #PXD$ #UP-SS 
  )

  ;; 使用区分=2 のP面を図形のグループ内から検索
  (setq #up-ss (CFGetSameGroupSS &eCNR))
  (setq #i 0)
  (setq #ePMEN nil)
  (while (and (not #ePMEN) (< #i (sslength #up-ss)))
    (setq #en (ssname #up-ss #i))
    (setq #pxd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
    (if (and #pxd$ (= 2 (car #pxd$))) (setq #ePMEN #en))
    (setq #i (1+ #i))
  )
  ;; Ｐ面２外形領域点列
  (setq #dPmen$ (GetLWPolyLinePt #ePMEN))
  
;;; ｺｰﾅｰｷｬﾋﾞP面の構成点を基点と設置角度から判定して変数に割当て
;;;
;;;       設置角度                設置角度
;;;  #d0     →    #d1      #d1     ←     #d0
;;;   *-------------*         *-------------*
;;;   ｜            ｜        ｜            ｜
;;;   ｜    #d3     ｜        ｜    #d3     ｜
;;;   ｜     *------*         *------*      ｜   
;;;   ｜     ｜    #d2       #d2     ｜     ｜
;;;   ｜     ｜                      ｜     ｜
;;;   *------*                       *------*
;;;  #d5    #d4                     #d4     #d5
;;;
  (setq #err nil)
  (setq #LSYM$ (CFGetXData &eCNR "G_LSYM"))
  (setq #GSYM$ (CFGetXData &eCNR "G_SYM"))

  (setq #fANG (read (angtos (caddr #LSYM$) 0 3))); 判定角度
  (setq #d0 (cdr (assoc 10 (entget &eCNR)))) ; コーナーキャビの基点座標
  (setq #d0 (list (car #d0) (cadr #d0)))

  ;; #d0から設置角度上にある点 #d1
  (setq #d1 (PcFindAnglePnt #d0 #fANG #dPmen$ nil))
  (if (= nil #d1) (setq #err T))

  ;; #d0から設置角度+-90度 にある点 #d5
  (if (= nil #err)
    (progn
      (setq #d5 (PcFindAnglePnt #d0 #fANG #dPmen$ 'T))
      (if (= nil #d5) (setq #err T))
    )
  )  
  ; #d5から設置角度上にある点 #d4 を求める
  (if (= nil #err)
    (progn
      (setq #d4 (PcFindAnglePnt #d5 #fANG #dPmen$ nil))
      (if (= nil #d4) (setq #err T))
    )
  )
  ;; #d1から設置角度+-90度 にある点 #d2
  (if (= nil #err)
    (progn
      (setq #d2 (PcFindAnglePnt #d1 #fANG #dPmen$ 'T))
      (if (= nil #d2) (setq #err T))
    )
  )  

  ; #d0 #d1 #d2 #d4 #d5 まで取得されていれば新点算出
  (if (= nil #err)
    (progn
      (setq #d2new (pcpolar #d1 (angle #d1 #d2) (+ (distance #d1 #d2) (- SKW_FILLER_DOOR))))
      (setq #d4new (pcpolar #d5 (angle #d5 #d4) (+ (distance #d5 #d4) (- SKW_FILLER_DOOR))))
      (setq #d3new (inters #d2new (pcpolar #d2new (angle #d1 #d0) 100)
                           #d4new (pcpolar #d4new (angle #d5 #d0) 100) nil)
      ); setq
      (setq #dNEW$ (list #d0 #d1 #d2new #d3new #d4new #d5 #d0))
    )
    ; 点がでていなければ、元の点リストをそのまま返す
    (setq #dNEW$ #dPmen$)
  )
  #dNEW$
);_ PcCornerCabPLByPMen

;;;<HOM>*************************************************************************
;;; <関数名>    : PcFindAnglePnt
;;; <処理概要>  : 点列リスト中、角度条件にあう最初の点を返す
;;; <戻り値>    : 点リストまたは nil
;;; <作成>      : 02/04/04 MH
;;; <備考> フラグnil = 基準点から検査角度 上にある点を返す
;;;        フラグ T  = 基準点から検査角度±90度 上にある点を返す
;;;*************************************************************************>MOH<
(defun PcFindAnglePnt (
  &chkP            ; 基準点
  &fA              ; 検査角度
  &dALL$           ; 検査点リスト
  &90FLG           ; 90度フラグ
  /
  #resP #i #P #fANG90 #fANG270
  )
  (setq #resP nil)
  (setq #i 0)
  (while (and (= nil #resP) (< #i (length &dALL$)))
    (setq #P (nth #i &dALL$))
    ;; 同一点以外だったら角度判定
    (if (not (equal 0 (distance &chkP #P) 0.1))
      (cond
        ;; フラグ T = 指示角度±90度に点があれば取得
        (&90FLG
         (setq #fANG90 (read (angtos (+ (angle &chkP #P) (* 0.5 pi)) 0 3)))
         (setq #fANG270 (read (angtos (+ (angle &chkP #P) (* -0.5 pi)) 0 3)))
         (if (or (equal &fA #fANG90 0.01)
                 (equal &fA #fANG270 0.01)
             )
           (setq #resP #P)
         )
        )
        ;; 指示角度上だったら取得
        (t
         (if (equal &fA (read (angtos (angle &chkP #P) 0 3)) 0.01)
           (setq #resP #P)
         )
        )
      ) ;_ cond
    ) ;_if
    (setq #i (1+ #i))
  ) ;_ while

  #resP
) ;_ PcFindAnglePnt

;<HOM>*************************************************************************
; <関数名>    : PcGetRange&SideFilrD
; <処理概要>  : レンジフード,サイドパネル 隣接アイテムからフィラー用補正奥行値を算出
; <戻り値>    : 数値
; <作成>      : 00/10/02 MH
;*************************************************************************>MOH<
(defun PcGetRange&SideFilrD (
  &eONE       ; 対象となる図形名(レンジかサイドパネル)
  &eUPPER$    ; 図中のアッパーアイテムリスト
  /
  #eNT_L$ #eNT_R$ #jANG #eN #eNT_L #eNT_R #fD #eNT$ ##difANG
  )
  (defun ##difANG (&ent$ &jANG / #eN #temp$)
    (setq #temp$ nil)
    (foreach #eN &ent$
      (if (equal &jANG (atof (angtos (nth 2 (CFGetXData #eN "G_LSYM")) 0 3)) 0.001)
        (setq #temp$ (cons #eN #temp$))
      ); if
    ); foreach
    #temp$
  ); ##difANG

  ; まず、アイテムの右左隣接を取る(スペーサー対策で20mm拡張)
  (setq #eNT_L$ (PcGetEn$CrossItemArea &eONE 20 0 0 0 'T &eUPPER$))
  (setq #eNT_R$ (PcGetEn$CrossItemArea &eONE 0 20 0 0 'T &eUPPER$))
  ; 01/04/09 MH MOD 隅収納庫対策で角度の違う図形は参照しないよう変更
  ; 取得された隣接図形中、設置角度が異なる図形を除外
  (setq #jANG (atof (angtos (nth 2 (CFGetXData &eONE "G_LSYM")) 0 3)))
  (setq #eNT_L$ (##difANG #eNT_L$ #jANG))
  (setq #eNT_R$ (##difANG #eNT_R$ #jANG))

  (if (car #eNT_L$) (setq #eNT$ (cons (car #eNT_L$) #eNT$)))
  (if (car #eNT_R$) (setq #eNT$ (cons (car #eNT_R$) #eNT$)))

  (cond
    ; 二つともレンジ以外のアイテムならば小の方の奥行き
    ((and #eNT$ (< 1 (length #eNT$))
          (not (= CG_SKK_ONE_RNG (CFGetSymSKKCode (car #eNT$) 1)))
          (not (= CG_SKK_ONE_RNG (CFGetSymSKKCode (cadr #eNT$) 1)))
     ); and
      (setq #fD (min (PcChk750CentrItemD (car #eNT$))
                     (PcChk750CentrItemD (cadr #eNT$))))
    )
    ; 一方のみ取得で一般アイテムまたは、二つとれた内の最初が一般アイテム
    ((and #eNT$ (< 0 (length #eNT$))
                (not (= CG_SKK_ONE_RNG (CFGetSymSKKCode (car #eNT$) 1))))
      (setq #fD (PcChk750CentrItemD (car #eNT$)))
    )
    ; 二つとれた内の二つめが一般アイテム
    ((and #eNT$ (< 1 (length #eNT$))
                (not (= CG_SKK_ONE_RNG (CFGetSymSKKCode (cadr #eNT$) 1))))
      (setq #fD (PcChk750CentrItemD (cadr #eNT$)))
    )
    ; 対象アイテムがサイドパネルでレンジフードが隣接なら本関数を回帰させる
    ((and #eNT$ (= CG_SKK_ONE_SID (CFGetSymSKKCode &eONE 1))
                (= CG_SKK_ONE_RNG (CFGetSymSKKCode (car #eNT$) 1)))
      (setq #fD (PcGetRange&SideFilrD (car #eNT$) &eUPPER$))
    )
    ; ここまでで取得できなかったら所属列最小値を提出。取れなければアイテム自体のD値が入る
    ; サイドパネル自体の奥行き補正？？？
    (t (setq #fD (PcGetMinDinRow &eONE &eUPPER$))
    )
  ); cond
  #fD
); PcGetRange&SideFilrD

;<HOM>*************************************************************************
; <関数名>    : PcGetMinDinRow
; <処理概要>  : 基準図形の左右隣接図形中、最小の奥行値を出す
; <戻り値>    : 数値
; <作成>      : 01/02/04 MH 変更
;*************************************************************************>MOH<
(defun PcGetMinDinRow (
  &eONE       ; 基準とする図形名
  &eCHK$      ; チェック対象図形名リスト
  /
  #fD ;02/03/29MH@ADD
  #eNEXT$ #minD #eNT
  )
  (setq #eNEXT$ (PcGetNextSimilarItem$ "SameAng" "L" &eONE nil &eCHK$))
  (setq #eNEXT$ (PcGetNextSimilarItem$ "SameAng" "R" &eONE #eNEXT$ &eCHK$))

  ; 取得された隣接アイテムのうち最小のD値を提出
  ; 基準キャビのD値をまず設定
  (setq #minD (nth 4 (CFGetXData &eONE "G_SYM")))
  (foreach #eNT #eNEXT$
    (if (> #minD (setq #fD (nth 4 (CFGetXData #eNT "G_SYM"))))
      (setq #minD #fD)
    ); if
  ); foreach
  #minD
); PcGetMinDinRow

;<HOM>*************************************************************************
; <関数名>    : PcMk4P$byWD&Ang
; <処理概要>  : W値とD値と角度から2次元の4点リストを作成
; <戻り値>    : ４点リスト (基点 右点 前右点 前左点)
; <作成>      : 00-10-03 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcMk4P$byWD&Ang (&dB &fW &fD &fANG / #spP1 #spP4 #RES$ )
  (if (and (numberp (car &dB)) (numberp (cadr &dB))
           (numberp &fW) (numberp &fD) (numberp &fANG))
    (progn
      (setq #spP1 (list (car &dB) (cadr &dB)))
      ; 01/01/19 MH MOD 処理元ポリラインに扉情報を加え オフセット値を統一
      (setq #spP4 (Pcpolar #spP1 (+ (* -0.5 pi) &fANG) (- &fD SKW_FILLER_DOOR)))
      (setq #RES$
        (list #spP1 (Pcpolar #spP1 &fANG &fW) (Pcpolar #spP4 &fANG &fW) #spP4))
    ); progn
    (setq #RES$ nil)
  );_ if
  #RES$
); PcMk4P$byWD&Ang

;;;<HOM>*************************************************************************
;;; <関数名>    : PcGetFilerOfsP&PL$
;;; <処理概要>  : フィラー設置領域点列(扉厚なし)とオフセット点の算出
;;; <戻り値>    : ((ofs点  (点列)) (ofs点  (点列)))
;;; <作成>      : 00/10/04 MH  02/04/05 MH 書き直し
;;; <作業手順> ① 基準図形と隣接するフィラー設置可能図形 全体の領域構成点列取得   
;;;            ② 隣接するフィラー設置可能図形中の全ｺｰﾅｰｷｬﾋﾞﾘｽﾄを作成
;;;            ③ ｺｰﾅｰｷｬﾋﾞの数により I型、L型U型のタイプを判定、領域構成点列から
;;;               フィラー設置点列とオフセット点を算出させ結果リストとする。
;;;
;;; <備考>  * フィラー領域は、ｺｰﾅｰｷｬﾋﾞのみ図形Ｐ面から算出
;;;           その他の図形は、G_SYMの基点、D値、W値によるものとする。
;;;         * I 型で前面、背面のみ左右なしのプランのみ2組のリストになる
;;;           その他は常に1組のリストが返る
;;;         * I 型で背面に指示があった場合のみ閉じた点列になる
;;;          （その場合、点列リストの頭と最後が同点）
;;;*************************************************************************>MOH<
(defun PcGetFilerOfsP&PL$ (
  &eCAB       ; 基準のウォール位置図形名
  &fOF        ; オフセット値
  &PLNFLG     ; プラン検索から起動されたなら'T  フリー設計ならnil
  /
  #BSP #DPL$ #DUM$$ #ECAB #ECNR$ #FANG #LFRPT$ #NEXT$ #OFP&PL$ #RES$ #XLD$
  )
  ;;****************************************************************
  ;; 基準図形の隣接する図形領域の点列リスト（反時計まわり）を作成
  ;;****************************************************************  
  
  ;; 基準図形から必要値取得
  (setq #XLD$ (CFGetXData &eCAB "G_LSYM"))
  (setq #bsP (cdr (assoc 10 (entget &eCAB))))
  (setq #bsP (list (car #bsP) (cadr #bsP)))
  (setq #fANG (nth 2 #XLD$))

  ;; フィラー領域アイテムの図形名と領域点列(補正有)のリストを算出
  ;; ((図形名 (外形線P点)) (図形名 (外形線P点))･･･)
  (setq #NEXT$ (PcGetFillerAreaItem$ &eCAB))
  ;; リストの点列でﾘｰｼﾞｮﾝ作成、結合、領域全体の外形領域点列取得
  (setq #dum$$ (mapcar 'cadr #NEXT$)); 点列のみリストに変換
  (setq #dPL$ (PcUnionRegion #dum$$))

  ;; 点列を反時計回りにする。基準図形の角度を比較,時計回りならリバース実行
  (setq #dPL$ (PcReverseClockWisePL #dPL$ #bsP #fANG))    

  ;; 隣接図形リスト中からｺｰﾅｰｷｬﾋﾞﾘｽﾄ((図形名 LR文字) (図形名 LR文字)) 所得
  (setq #dum$$ (mapcar 'car #NEXT$))
  (setq #eCNR$ (PcGetCornerList #dum$$ #fANG))

  ;;*******************************************************************
  ;; フィラー領域構成点列からｵﾌｾｯﾄ点とフィラー作成用点列リストを作成
  ;;******************************************************************* 
  ;; 領域中のｺｰﾅｰｷｬﾋﾞの数によりＩ型 Ｌ型 Ｕ型 分岐
  (cond
    ;; Ｉ型 (隅用キャビなし)
    ((= 0 (length #eCNR$))
     (setq #RES$ (PcGetOffsetPAndPLtypeI #dPL$ #fANG &fOF))
     (setq #LFRpt$ (car #RES$))
     (setq #ofP&PL$ (cadr #RES$))
    );_ Ｉ型

    ;; Ｌ型 Ｕ型共通 (隅用キャビの数 １か２)
    ((>= 2 (length #eCNR$))
     (setq #ofP&PL$ (PcGetOffsetPAndPLtypeLU #dPL$ #eCNR$ &fOF))
     (setq #LFRpt$ (cadr (car #ofP&PL$)))
    );_ Ｌ型 Ｕ型

    ;; それ以上はエラー中止
    (t
     (CFAlertMsg "範囲中に隅用キャビネットが2つ以上検出されました")
     (exit)
    )
  );_ cond
  
  ;;**********************************
  ;; 奥行処理長さグローバル変数設定
  ;;**********************************  
  ;; #LFRpt$ = 左側辺‐中央‐右側辺 のポリライン点列(逆時計まわり)

  ;; 左奥行処理あり
  (if (= SKW_FILLER_LSIDE 1)
    ;; THEN 点ﾘｽﾄの先頭２点を左奥行処理の長さとする。
    (setq SKW_FILLER_LLEN (distance (car #LFRpt$) (cadr #LFRpt$)))
    ;; ELSE なければ0
    (setq SKW_FILLER_LLEN 0.0)
  );_ end if
  
  ;; 右奥行処理あり
  (if (= SKW_FILLER_RSIDE 1)
    ;; THEN 点ﾘｽﾄの最後尾２点を右奥行処理の長さとする。
    (progn
      ;; 最後尾の２点を取るために点列リバース、２点間を奥行とする。
      (setq #LFRpt$ (reverse #LFRpt$))
      (setq SKW_FILLER_RLEN (distance (car #LFRpt$) (cadr #LFRpt$)))
    )
    ;; ELSE なければ0
    (setq SKW_FILLER_RLEN 0.0)
  );_ end if

;;確認用
;;;(princ "SKW_FILLER_LSIDE")
;;;(princ SKW_FILLER_LSIDE)
;;;(princ SKW_FILLER_LLEN)
;;;(princ "SKW_FILLER_RSIDE")
;;;(princ SKW_FILLER_RSIDE)
;;;(princ SKW_FILLER_RLEN )
  
  (setq SKW_FILLER_LSIDE 0)
  (setq SKW_FILLER_RSIDE 0)

  ;; 結果リストを返す ((ofs点  (点列))･･･････)
  #ofP&PL$
)
;_ PcGetFilerOfsP&PL$

;;;<HOM>*************************************************************************
;;; <関数名>    : PcGetOffsetPAndPLtypeI
;;; <処理概要>  : I 型配列 天井フィラー設置ポリライン点列とオフセット点取得
;;; <戻り値>    : 後で使う  #LFRpt$  点列と、 フィラー指示リスト↓の リスト 
;;;             : ((ｵﾌｾｯﾄ点 (点列))) または ((ｵﾌｾｯﾄ点 (点列)) (ｵﾌｾｯﾄ点 (点列)))  
;;; <作成>      : 02/04/05 MH
;;; <備考>  * 背面あり 左右なしのプランのみ 2組のリストになるその他は常に1組
;;;         * 背面あり、左右ありの指示の場合のみ閉じた点列になる。
;;;*************************************************************************>MOH<
(defun PcGetOffsetPAndPLtypeI (
  &dPL$       ; 領域点列（閉じたポリラインで反時計回り）
  &fANG       ; 基準図形の角度
  &fOF        ; オフセット値
  /
  #ALLPL$ #BACKFLG #BACKPL$ #BCLP #BCRP #CHKANG #DPL$ #DUM$$ #FA1 #FRONTPL$
  #I #OFP&PL$ #OFSP #STOPFLG #LFRPT$ 
  )

  ;; 背面設置フラグ #backFLG 背面あり= 'T
  (if (= 1 SKW_FILLER_BSIDE) ;; ダイアログの背面トグルがオン
    (setq #backFLG 'T)
    (setq #backFLG nil)
  )

  ;;*******************************************************************
  ;; 領域構成点列と、基準図形の角度を比較、背面最右点、背面最左点をだし
  ;; 構成線を反時計まわりの背面ポリラインと前面ポリラインに分割する
  ;; （前面、背面ともに凸凹している可能性がある）
  ;;*******************************************************************
;;;     背面最左点              ←     背面最右点
;;;       #bcLP       背面ポリライン     #bcRP
;;;        + ----------------------------- +   
;;;                 
;;;        ｜                              ｜    背面ポリライン以外
;;;     ↓ ｜                              ｜ ↑    = 前面ポリライン
;;;        + ----------------------------- +
;;;                         →
  
  (setq #dPL$ &dPL$)
  ;; 判定角度をアングルに変換
  (setq #fA1 (read (angtos &fANG 0 3)))
  ;; 判定用に点列から構成線リスト作成
  (setq #allPL$ (PcMkLine$byPL$ #dPL$ 'T))
  
  ;; 背面線リスト#backL$ 取得   判定= 基準図形と角度180度逆の線
  (setq #backPL$ nil)
  (foreach #chkL #allPL$
    ;; 終点→始点角度
    (setq #chkANG (angle (cadr #chkL) (car #chkL)))
    ;; チェック図形角度をアングルに変換 
    (setq #chkANG (read (angtos #chkANG 0 3)))
    (if (equal #fA1 #chkANG 0.01)
      (setq #backPL$ (cons #chkL #backPL$)))
  );_ foreach

  ;; 背面線リスト#backPL$ 中の 最左点 と最右点 を算出
  (setq #bcLP (PcGetSidePinPL$ #backPL$ &fANG "L")) ; #backPL$中の 最左点
  (setq #bcRP (PcGetSidePinPL$ #backPL$ &fANG "R")) ; #backPL$中の 最右点

  ;; 外形領域点列 #dPL$ を 背面最左点 #bcLP が頭にくるよう並べ替え
  (setq #dPL$ (PcOrderPL$byOneP #dPL$ #bcLP))

  ;; 反時計回り外形領域点列 #dPL$ を、背面ポリラインと前面ポリラインに分割

  ;; #backPL$ 背面ポリラインリスト
  (setq #dum$$ #dPL$)
  (while (and (car #dum$$)
              (not (equal #bcRP (car #dum$$) 0.01))
         )
    (setq #dum$$ (cdr #dum$$))
  ); while
  (setq #backPL$ (append #dum$$ (list (car #dPL$))))

  ; #frontPL$ = 前面ポリライン
  (setq #i 0)
  (setq #dum$$ nil)
  (setq #stopFLG nil)
  (while (and (not #stopFLG) (< #i (length #dPL$)))
    (setq #dum$$ (append #dum$$ (list (nth #i #dPL$))))
    (if (equal #bcRP (nth #i #dPL$) 0.01)
      (setq #stopFLG 'T)
    )
    (setq #i (1+ #i))
  ); while
  (setq #frontPL$ #dum$$)

  ;;**********************************************
  ;; 前面、背面、点列を指示空間分オフセット実行
  ;;**********************************************
  ;; 02/04/10MH 注意書き  
  ;; I型のｵﾌｾｯﾄ点をプラン全体の中央でとっていますが、以下の不具合があります。
  ;; ※D値の異なるキャビネットが2個のプラン、および 凸部、凹部があり
  ;;   ﾌｨﾗｰ領域が左右対称なプランでｵﾌｾｯﾄが指示点と逆に掛かる。
  ;; 中央というのが誤作動をよぶようなので、この件が問題になったときは
  ;; 領域の基準キャビネット一個の中央点をｵﾌｾｯﾄ点にするよう本関数を変更してみてください。
  
  ;; オフセット点 = 前面ポリライン#frontPL$ 全体の中央
  (setq #ofsP (Pcpolar (car #frontPL$) (angle (car #frontPL$) (last #frontPL$))
                       (* 0.5 (distance (car #frontPL$) (last #frontPL$))))
  )
  (setq #ofsP (Pcpolar #ofsP (+ &fANG (* -0.5 pi))
                       (* 0.5 (distance (car #frontPL$) (cadr #frontPL$))))
  )

  ;; 前面と背面のオフセット処理実行
  ;; 背面設置ありなら、背面ポリラインをオフセット処理
  (if #backFLG
    (setq #backPL$ (PcOffsetFilerBCPL$ #backPL$ #ofsP &fOF &fANG))
  )
  ;; 前面ポリライン空間分オフセット 処理
  (setq #frontPL$ (PcOffsetFilerPL$  #frontPL$ #ofsP &fOF nil nil))

  ;;***************************************************
  ;; 側面、背面の指定に応じて提出リストの加工分岐
  ;;***************************************************
  ;; 背面ポリラインと前面ポリラインを加工して以下のケースに対応
  ;; ①左右側面なし  前面 ＋ 側面  （分割 2リスト）        
  ;; ②左右側面なし  前面のみ       (前面リストのみ)
  ;; ③左右側面あり  前面 ＋ 側面   (一つの閉じたポリラインに加工)
  ;; ④左側面のみ    前面 ＋ 側面   (前面から最後の点を抜いて、背面ポリラインと結合)         
  ;; ⑤右側面のみ    前面 ＋ 側面   (前面から最初の点を抜いて、背面ポリラインと結合) 
  ;; ⑥左側面のみ    前面のみ       (前面から最後の点を抜く）
  ;; ⑦右側面のみ    前面のみ       (前面から最初の点を抜く）
  
  (setq #LFRpt$  nil) ;_ サイド奥行き取得用の点列リスト
  (setq #ofP&PL$ nil)
  (if (= 0 (+ SKW_FILLER_LSIDE SKW_FILLER_RSIDE))
    ;; ①左右側面なし  前面 ＋ 側面  （分割 2リスト）        
    ;; ②左右側面なし  前面のみ       (前面リストのみ)
    (progn
      ;; 背面設置あり（背面ポリラインと前面ポリラインで２つリスト必要）
      ;; 結果リストに背面ポリラインリストを設定
      (if #backFLG
        (setq #ofP&PL$ (list (list #ofsP #backPL$)))  
      )
      ;; Ｐ点リストから左右側壁点を抜いた点列作成
      (setq #i 1)
      (setq #dum$$ nil)
      (while (< #i (1- (length #frontPL$)))
        (setq #dum$$ (append #dum$$ (list (nth #i #frontPL$))))
        (setq #i (1+ #i))
      );_ while

      ;; 結果リストに前面ポリラインのリストを加える
      (setq #ofP&PL$ (cons (list #ofsP #dum$$) #ofP&PL$))
    )
    (progn
      ;; 00/10/25 SN ADD 左奥-前部-右奥の順に並んだと想定した点ﾘｽﾄ
      (setq #LFRpt$ #frontPL$)
      ;; 前面ポリライン加工 側面左右フラグから側面部の点除去処理
      ;; ⑥左側面のみ    前面のみ       (前面から最後の点を抜く）
      ;; ⑦右側面のみ    前面のみ       (前面から最初の点を抜く）
      (setq #frontPL$ (PcPL$SidePart #frontPL$ &fOF))

      ;; 背面ありの場合、背面点列 #backPL$ を結合処理
      ;; ③左右側面あり  前面 ＋ 側面   (一つの閉じたポリラインに加工)
      ;; ④左側面のみ    前面 ＋ 側面   (前面から重複点を抜き、背面ポリラインと結合)         
      ;; ⑤右側面のみ    前面 ＋ 側面   (前面から重複点を抜き、背面ポリラインと結合) 
      (cond
        ;; 左側面のみあり
        ((and #backFLG (= 0 SKW_FILLER_RSIDE))
          (setq #frontPL$ (append (reverse (cdr (reverse #backPL$))) #frontPL$))
        )
        ;; 右側面のみあり、あるいは 左右側面ともにある
        (#backFLG
          (setq #frontPL$ (append #frontPL$ (cdr #backPL$)))
        )
      ); cond

      ;; 結果をリストにセット
      (setq #ofP&PL$ (list (list #ofsP #frontPL$)))
    ) 
  );_ if

  ;; 結果リストを返す  #LFRpt$ は 左右 なしの場合は使用されないため nil値
  (list #LFRpt$ #ofP&PL$)
)
;_ PcGetOffsetPAndPLtypeI

;;;<HOM>*************************************************************************
;;; <関数名>    : PcGetOffsetPAndPLtypeLU
;;; <処理概要>  : Ｌ型Ｕ型配列共通 天井フィラー設置ポリライン点列とｵﾌｾｯﾄ点取得
;;; <戻り値>    : リスト ((#LFRpt$点列)   (ｵﾌｾｯﾄ点 (点列)) ) 
;;; <作成>      : 02/04/08 MH
;;; <備考>      
;;;*************************************************************************>MOH<
(defun PcGetOffsetPAndPLtypeLU (
  &dPL$       ; 領域点列（閉じたポリラインで反時計回り）
  &eCNR$      ; ((図形名 LR文字) (図形名 LR文字)) L型 は要素は一つ
  &fOF        ; オフセット値
  /
  #BSP #DPL$ #EBASE #ECNR$ #ENCHK #FRONTPL$ #OFSP #SLR #XD$ #XLD$
  )
  (setq #eCNR$ &eCNR$)
  
  ;; U型の場合、ｺｰﾅｰｷｬﾋﾞのリストを(左側ｷｬﾋﾞ  右側ｷｬﾋﾞ) に並べ替え
  (if (= 2 (length #eCNR$))
    (progn
      (setq #enChk (car (last #eCNR$)))
      (setq #XLD$ (CFGetXData #enChk "G_LSYM"))
      (setq #bsP (cdr (assoc 10 (entget #enChk))))
      (setq #bsP (list (car #bsP) (cadr #bsP)))
      ;; 二つ目キャビの基点から設置角度の延長線上に一つ目キャビの基点が
      ;; ある場合は順番を入れ替え
      (if (PcIsExistPOnLine (list #bsP (Pcpolar #bsP (nth 2 #XLD$) 10000))
                            (list (cdr (assoc 10 (entget (car (car #eCNR$)))))))
        (setq #eCNR$ (reverse #eCNR$))
      );_ if
    )
  );_if
  
  ;; L型の場合そのまま U型の場合、右側のｺｰﾅｰｷｬﾋﾞを基準図形に指定
  (setq #eBASE (car (last #eCNR$))) 
  (setq #sLR (cadr (last #eCNR$))) 
  (setq #dPL$ &dPL$)
  (setq #XD$ (CFGetXData #eBASE "G_SYM"))
  (setq #XLD$ (CFGetXData #eBASE "G_LSYM"))

  (setq #bsP (cdr (assoc 10 (entget #eBASE))))
  (setq #bsP (list (car #bsP) (cadr #bsP)))

  ;; コーナーとしてダイニングキャビが渡ってきた場合の基点移動
  (if (= CG_SKK_THR_DIN (CFGetSymSKKCode #eBASE 3))
    (progn
      (setq #bsP (Pcpolar #bsP (- (nth 2 #XLD$) (* 0.5 pi)) (- (nth 4 #XD$) SKW_FILLER_DOOR)))
      (if (= "R" #sLR) ; 右だった
        (setq #bsP (Pcpolar #bsP (nth 2 #XLD$) (nth 3 #XD$)))
      ); if
    )
  );_ if

  ;;*******************************************************************
  ;; 領域構成点列（反時計回り）をｺｰﾅｰｷｬﾋﾞ基点先頭に並びかえ
  ;; 前面ポリラインのみの点列を取得する。
  ;;*******************************************************************
;;;
;;; Ｕ型は、領域構成点列を右ｺｰﾅｰｷｬﾋﾞ基点先頭に並べ替えた後、
;;; 先頭の2点を削除することで、前面ポリライン点列作成
;;;
;;;    左ｺｰﾅｰｷｬﾋﾞ基点     ←     #点列先頭 = 右ｺｰﾅｰｷｬﾋﾞ基点
;;;     点列2点目                   点列1点目           
;;;        ●･ ･ ･ ･ ･ ･ ･ ･ ･ ･ ･ ･ ･ ●   
;;;        ･                            ･  
;;;     ↓ ･                            ･                                
;;;        ･     +---------------+      ･
;;;        ･     ｜       →     ｜     ･ ↑
;;;        ･     ｜前面          ｜     ･
;;;        ･     ｜ポリライン点列｜     ･
;;;        +-----+               +------+
;;;
;;; Ｌ型は、領域構成点列を右ｺｰﾅｰｷｬﾋﾞ基点先頭に並べ替えた後、
;;; 先頭の1点を削除することで、前面ポリライン点列作成                          
;;;
;;;  #点列先頭(ｺｰﾅｰｷｬﾋﾞ基点)           
;;;        ●･ ･ ･ ･ ･ ･ ･ ･ ･ ･ +  
;;;        ･                     ｜  
;;;     ↓ ･                     ｜                                  
;;;        ･     +---------------+
;;;        ･     ｜           →       
;;;        ･     ｜ ↑           
;;;        ･     ｜      前面ポリライン点列 
;;;        +-----+   
;;;
  
  ;; 反時計まわり外形領域点列を隅用キャビの基点が頭にくるよう並べ替え
  (setq #dPL$ (PcOrderPL$byOneP #dPL$ #bsP))
  ;; 隅用キャビの基点を抜いて、開いた前面ポリライン点リストに加工
  (repeat (length #eCNR$) (setq #dPL$ (cdr #dPL$)))
  (setq #frontPL$ #dPL$)

  ;; オフセット点取得 (AutoCadのバグなのか、元線の仮想交点をオフセット点に
  ;; すると逆方向に実行される｡ 元線に近いオフセット基点しかダメ)
  (setq #ofsP (pcpolar (car #frontPL$) (angle (car #frontPL$) (cadr #frontPL$))
    (* 0.5 (distance (car #frontPL$) (cadr #frontPL$)))))
  (setq #ofsP (pcpolar #ofsP (angle (cadr #frontPL$) (caddr #frontPL$))
    (* 0.5 (distance (cadr #frontPL$) (caddr #frontPL$)))))

  ;;********************************
  ;; 前面、指示空間分オフセット
  ;;********************************  
  (setq #frontPL$ (PcOffsetFilerPL$ #frontPL$ #ofsP &fOF (mapcar 'car #eCNR$) nil))

  ;;***********************************************
  ;; 側面の指定に応じて前面ポリラインリストの加工
  ;;***********************************************
  (setq #frontPL$ (PcPL$SidePart #frontPL$ &fOF))

  ;; 結果を返す
  (list (list #ofsP #frontPL$))
)
;_ PcGetOffsetPAndPLtypeLU 

;;;<HOM>*************************************************************************
;;; <関数名>    : PcChkCornerDinning
;;; <処理概要>  : チェック対象図形が隅配置のダイニングキャビならば 'T
;;; <戻り値>    : T or nil
;;; <作成>      : 02/04/08 MH
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PcChkCornerDinning (
  &eCHK
  &NEXT$
  /
  #FLG #eBF #eBF$
  )
  (setq #FLG nil)
  (cond
    ; ﾀﾞｲﾆﾝｸﾞ用か?
    ((/= CG_SKK_THR_DIN (CFGetSymSKKCode &eCHK 3))
     (setq #FLG nil)
    )
    ;_ 図形 前後の隣接が基準角度でなおかつダイニング以外の場合 T
    (t
     (setq #eBF$ (PcGetEn$CrossArea &eCHK -5 -5 0 0 'T)) ; 図形の前後の図形名摘出
     ; 隣接リスト中に前後図形があればT
     (foreach #eBF #eBF$
       (if (member #eBF &NEXT$) (setq #FLG 'T)) 
     )
    )
  );_ cond
  #FLG
)
;_ PcChkCornerDinning

;;;<HOM>*************************************************************************
;;; <関数名>    : PcUnionRegion
;;; <処理概要>  : 隣接リストの点列すべてリージョン化結合、全体の点列を出す
;;; <戻り値>    : 閉じた点列リスト
;;; <作成>      : 02/04/05 MH
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun PcUnionRegion (
  &dPL$       ; 結合するポリライン点列リスト
  /
  #dRES$ #NT_regn #OutPline #r-ss 
  )
  ;; 
  (setq #NT_regn (ssadd))
                           
  ;; 全隣接図形の外形線をリージョン化
  (foreach #NT$ &dPL$
    (MakeLwPolyLine #NT$ 1 0)
    (command "_region" (entlast) "")
    (ssadd (entlast) #NT_regn)
  );_ foreach

  ;; リージョンが1ケ以上なら結合して一つにする
  (if (< 1 (sslength #NT_regn)) (command "_union" #NT_regn ""))
  ;; REGIONを分解し、分解した線分をポリライン化する
  (command "_explode" (entlast))
  (setq #r-ss (ssget "P"))

  (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
  (setq #OutPline (entlast))

  ;; 全外形領域点列を求める
  (setq #dRES$ (GetLWPolyLinePt #OutPline))
  (entdel #OutPline )

  ;; 結果の点列を返す
  #dRES$
)
;_ PcUnionRegion

;;;<HOM>*************************************************************************
;;; <関数名>    : PcReverseClockWisePL
;;; <処理概要>  : 点列と基準図形の設置角度を比較,時計回りならリバース実行
;;; <戻り値>    : 逆時計回りの点列リスト
;;; <作成>      : 02/04/05 MH
;;; <備考>      * 基点上にある構成線(背面線)の角度が基準角度と同じなら、
;;;               時計回りと判定してリバース実行
;;;*************************************************************************>MOH<
(defun PcReverseClockWisePL (
  &dPL$      ; ポリライン点列リスト
  &dPT       ; 基準図形の基点
  &fAng      ; 基準図形の角度(ラジアン)
  /
  #ANG #CHKANG #CHKL #I #LINE$ #LINEALL$ #ONLINE #REVFLG #dRES$
  )
  ;; 判定点リストをバラ線リストに変換
  (setq #Line$ (PcMkLine$byPL$ &dPL$ 'T))

  ;; 判定用に角度をアングル化
  (setq #ang (read (angtos &fAng 0 3)))

  (setq #i 0)
  (setq #revFLG nil)
  (while (and (= nil #revFLG) (< #i (length #Line$)))
    (setq #chkL (nth #i #Line$))
    ;; 基点上の線か判定 点上だったら 'T
    (setq #OnLine (PcIsExistPOnLine #chkL (list &dPT)))
    ;; 基点上の線でかつ角度が基準図形と同じであれば、時計回りと判定
    (if #OnLine
      (progn
        (setq #chkAng (read (angtos (angle (car #chkL) (cadr #chkL)) 0 3)))
        (If (equal #ang #chkAng 0.01)
          (setq #revFLG 'T)
        )
      )
    ) ;_ if
    ;; インクリメント
    (setq #i (1+ #i))
  ) ;_ while

  ;; #revFLG = 'T  点列リバース実行
  (if #revFLG
    (setq #dRES$ (reverse &dPL$))
    (setq #dRES$ &dPL$)
  )

  ;; 結果の点列を返す
  #dRES$
)
 ;_ PcReverseClockWisePL 

;;;<HOM>*************************************************************************
;;; <関数名>    : PcGetCornerList
;;; <処理概要>  : フィラー設置図形リスト中から、隅用キャビ摘出
;;; <戻り値>    : リスト ((図形名 LR文字) (図形名 LR文字) …)  または  nil
;;; <作成>      : 02/04/05 MH
;;; <備考>  
;;;              
;;;*************************************************************************>MOH<
(defun PcGetCornerList (
  &eUPPER$      ; フィラー設置領域の図形名リスト
  &fANG         ; 判定の基準になる 基準図形の設置角度（ラジアン）
  /
  #CHKANG #ECNR$ #FANG #RES$ #SLR #SLR$
  )
  ;; 判定角度をアングルに変換
  (setq #fANG (read (angtos &fANG 0 3)))
  (setq #Res$ nil); ((LR文字  図形名) (LR文字 図形名)…) 

  (foreach #en &eUPPER$
    (setq #chkANG (nth 2 (CFGetXData #en "G_LSYM")))
    ;; チェック図形角度をアングルに変換 
    (setq #chkANG (read (angtos #chkANG 0 3)))
    ;; ｺｰﾅｰｷｬﾋﾞの判定
    (if
      (or
        ;; ｺｰﾅｰｷｬﾋﾞ
        (= CG_SKK_THR_CNR (CFGetSymSKKCode #en 3)); ｺｰﾅｰｷｬﾋﾞ
        ;; 隅配置のﾀﾞｲﾆﾝｸﾞｷｬﾋﾞ（基準角度と角度が異なるもの）
        (and (not (equal #fANG #chkANG 0.01)) ; 基準角度と異なる
             (PcChkCornerDinning #en &eUPPER$); 隅配置のﾀﾞｲﾆﾝｸﾞｷｬﾋﾞ
        );_ and
      );_ or
      (progn
        ;; 設置方向をもとめる 注：全部に"L"になるのでは？？？
        (if (and (= CG_SKK_THR_DIN (CFGetSymSKKCode #en 3))
                 (equal #fANG #chkANG 0.01)
            )
          (setq #sLR "R")
          (setq #sLR "L")
        ); if
        (setq #Res$ (cons (list #en #sLR) #Res$))
      ); progn
    ); if
  ); foreach

  ;;リストの結果を返す
  #Res$
)
;_ PcGetCornerList 

;<HOM>*************************************************************************
; <関数名>    : PcGetFilerBLRDlg
; <処理概要>  : 左か右かユーザーに選ばせる
; <戻り値>    : リスト (B L R) の位置に T か nil
; <作成>      : 01/04/04 MH
;*************************************************************************>MOH<
(defun PcGetFilerBLRDlg ( / #dcl_id #BLR$ X)
  ;;; ダイアログの実行部
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "GetFilerBLRDlg" #dcl_id)) (exit))
  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept"
    "(setq #BLR$ (list (get_tile \"B\") (get_tile \"L\") (get_tile \"R\"))) (done_dialog)")
  (action_tile "cancel" "(setq #BLR$ nil) (done_dialog)")
  ;;;デフォ値代入
  (set_tile "B" "0")
  (set_tile "L" "1")
  (set_tile "R" "1")
  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; 結果リストを返す
  (if #BLR$ (mapcar '(lambda (X) (= "1" X)) #BLR$) nil)
); PcGetFilerBLRDlg

;<HOM>*************************************************************************
; <関数名>    : PcGetFilerALLDlg
; <処理概要>  : 左か右かユーザーに選ばせる
; <戻り値>    : リスト (B L R) の位置に T か nil
; <作成>      : 01/12/17 YM ADD ﾌｨﾗｰ選択,ﾌｨﾗｰ高さ指定も1つのﾀﾞｲｱﾛｸﾞで行う
;*************************************************************************>MOH<
(defun PcGetFilerALLDlg ( 
;-- 2011/07/21 A.Satoh Mod - S
; &Hinban$
;  &H
  &qry$
;-- 2011/07/21 A.Satoh Mod - S
  /
  #dcl_id #BLR$
;-- 2011/07/21 A.Satoh Add - S
  #hinban$ #syoki_index #height$ #idx #takasa
;-- 2011/07/21 A.Satoh Add - E
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #BLR$ #H #RET #SFILR
;-- 2011/07/22 A.Satoh Add - S
            #kosu #flag #kitchin #syunou
;-- 2011/07/22 A.Satoh Add - E
;-- 2011/08/11 A.Satoh Add - S
            #syokei #kitchin
;-- 2011/08/11 A.Satoh Add - E
            )
            (setq #BLR$
              (list
                (atoi (get_tile "B"))
                (atoi (get_tile "L"))
                (atoi (get_tile "R"))
              )
            )

;-- 2011/07/21 A.Satoh Mod - S
;           (setq #sFilr (nth (atoi (get_tile "FILR")) &Hinban$)) ; ﾌｨﾗｰ品番
;            (setq #H (read (get_tile "edtBOX"))) ; ﾌｨﾗｰ高さ
;
;            (if (and (or (= (type #H) 'INT)(= (type #H) 'REAL))
;                     (> #H 0.0001))
;              (progn
;                (done_dialog) ; 半角実数だった
;                (setq #ret (append #BLR$ (list #sFilr #H))) ; 戻り値 B,L,R,品番,高さ
;              )
;              (progn
;                (alert "0より大きな値を入力して下さい")
;                (set_tile "edtBOX" "")
;                (mode_tile "edtBOX" 2)
;                (princ)
;              )
;            );_if

            (setq #flag T)
            (setq #sFilr (nth (atoi (get_tile "FILR")) #hinban$)) ; ﾌｨﾗｰ品番
            (setq #H (read (get_tile "edtBOX")))        ; ﾌｨﾗｰ高さ
            (setq #kosu (read (get_tile "edtBOX2")))    ; 個数
;-- 2011/08/11 A.Satoh Add - S
            (setq #kitchin (get_tile "radio_A"))
            (if (= #kitchin "1")
              (setq #syokei "A")
              (setq #syokei "D")
            )
;-- 2011/08/11 A.Satoh Add - E

            ; 高さ入力値チェック
            (if (/= #H nil)
              (if (or (= (type #H) 'INT) (= (type #H) 'REAL))
                (if (> #H 0.0001)
                  (if (> #H #takasa)
                    (progn
                      (setq #flag nil)
                      (alert (strcat "高さ：" (rtos #takasa) " 以下の値を入力して下さい"))
                      (set_tile "edtBOX" "")
                      (mode_tile "edtBOX" 2)
                      (princ)
                    )
                  )
                  (progn
                    (setq #flag nil)
                    (alert "0より大きな値を入力して下さい")
                    (set_tile "edtBOX" "")
                    (mode_tile "edtBOX" 2)
                    (princ)
                  )
                )
                (progn
                  (setq #flag nil)
                  (alert "数値を入力して下さい")
                  (set_tile "edtBOX" "")
                  (mode_tile "edtBOX" 2)
                  (princ)
                )
              )
              (progn
                (setq #flag nil)
                (alert "高さが入力されていません")
                (mode_tile "edtBOX" 2)
                (princ)
              )
            )

            ; 個数入力値チェック
            (if (= #flag T)
              (if (/= #kosu nil)
                (if (= (type #kosu) 'INT)
                  (if (<= #kosu 0)
                    (progn
                      (setq #flag nil)
                      (alert "0より大きな値を入力して下さい")
                      (set_tile "edtBOX2" "")
                      (mode_tile "edtBOX2" 2)
                      (princ)
                    )
                  )
                  (progn
                    (setq #flag nil)
                    (alert "整数値で入力して下さい")
                    (set_tile "edtBOX2" "")
                    (mode_tile "edtBOX2" 2)
                    (princ)
                  )
                )
                (progn
                  (setq #flag nil)
                  (alert "個数が入力されていません")
                  (mode_tile "edtBOX2" 2)
                  (princ)
                )
              )
            )

            (if (= #flag T)
              (progn
                (done_dialog)
;-- 2011/08/11 A.Satoh Mod - S
;                (setq #ret (append #BLR$ (list #sFilr #H #kosu))
                (setq #ret (append #BLR$ (list #sFilr #H #kosu #syokei)))
;-- 2011/08/11 A.Satoh Mod - E
              )
            )
;-- 2011/07/21 A.Satoh Mod - E

          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/07/21 A.Satoh Mod - S
;          (defun ##Addpop ( /  ) ; 材質ポップアップリスト
;           (start_list "FILR" 3)
;           (foreach #Hinban &Hinban$
;             (add_list #Hinban)
;           )
;           (end_list)
;           (set_tile "FILR" "0") ; 最初にﾌｫｰｶｽ
;           (princ)
;          );##Addpop
          (defun ##Addpop (
            /
            #hinban
            )

            (start_list "FILR" 3)
            (foreach #hinban #Hinban$
              (add_list #hinban)
            )
            (end_list)

            (set_tile "FILR" #syoki_index)
            (princ)
          );##Addpop
;-- 2011/07/21 A.Satoh Mod - E
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/07/21 A.Satoh Add - S
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 品番選択
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##SelectFilr (
            /
            #index
            )

            (setq #index (atoi (get_tile "FILR")))

            (setq #takasa (nth #index #height$))
            (set_tile "edtBOX" (rtos #takasa))
            (princ)
          );##SelectFilr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/07/21 A.Satoh Add - E

;-- 2011/07/21 A.Satoh Add - S
  (setq #idx 0)
  (setq #hinban$ nil)
  (setq #syoki_index "")
  (setq #height$ nil)
  (repeat (length &qry$)
    (setq #height$ (append #height$ (list (nth 1 (nth #idx &qry$)))))
    (setq #hinban$ (append #hinban$ (list (nth 2 (nth #idx &qry$)))))
    (if (= (nth 5 (nth #idx &qry$)) 1)
      (setq #syoki_index (itoa #idx))
    )
    (setq #idx (1+ #idx))
  )
;-- 2011/07/21 A.Satoh Add - E

  ;;; ダイアログの実行部
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "GetFilerALLDlg" #dcl_id)) (exit))

  ; 初期値
;-- 2011/07/22 A.Satoh Mod - S
  (setq #takasa (nth (atoi #syoki_index) #height$))
  (set_tile "edtBOX" (rtos #takasa))
;  (set_tile "edtBOX" (rtos &H))
;-- 2011/07/22 A.Satoh Mod - S

  ; 01/12/19 YM ADD-S
  (if SKW_FILLER_AUTO ; 自動生成のとき
    (progn
      ;;;デフォ値代入
      (set_tile "B" "0")
      (set_tile "L" "1")
      (set_tile "R" "1")
    )
    (progn ; 個別生成
      ; ﾁｪｯｸﾎﾞｯｸｽをｸﾞﾚｰｱｳﾄ
      ;;;デフォ値代入
      (set_tile "F" "0")
      (set_tile "B" "0")
      (set_tile "L" "0")
      (set_tile "R" "0")
      (mode_tile "Check" 1)   ; 使用不可
    )
  );_if
  ; 01/12/19 YM ADD-E

;-- 2011/08/11 A.Satoh Add - S
  ; キッチン/収納区分
  (set_tile "radio_A" "1")
;-- 2011/08/11 A.Satoh Add - E

  ;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
  (##Addpop)

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
;-- 2011/07/21 A.Satoh Add - S
  (action_tile "FILR" "(##SelectFilr)")
;-- 2011/07/21 A.Satoh Add - E
  (action_tile "accept" "(setq #BLR$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #BLR$ nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; 結果リストを返す
  #BLR$
); PcGetFilerALLDlg

;<HOM>*************************************************************************
; <関数名>    : PcGetFilerLRDlg
; <処理概要>  : 左か右かユーザーに選ばせる
; <戻り値>    : リスト (L R) の位置に T か nil
; <作成>      : 00/07/04 MH
;*************************************************************************>MOH<
(defun PcGetFilerLRDlg ( / #dcl_id #LR$ X)
  ;;; ダイアログの実行部
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "GetFilerLRDlg" #dcl_id)) (exit))
  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept"
    "(setq #LR$ (list (get_tile \"L\") (get_tile \"R\"))) (done_dialog)")
  (action_tile "cancel" "(setq #LR$ nil) (done_dialog)")
  ;;;デフォ値代入
  (set_tile "L" "1")
  (set_tile "R" "1")
  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; 結果リストを返す
  (if #LR$ (if #LR$ (mapcar '(lambda (X) (= "1" X)) #LR$) nil) nil)
); PcGetFilerLRDlg

;<HOM>*************************************************************************
; <関数名>    : PcGetSidePinPL$
; <処理概要>  : 背面の線座標中で基準角度の方向に一番端となる点を摘出
; <戻り値>    :
; <作成>      : 00-10-10 MH
; <備考>      : 背面からみると、基準角度は右方向です。
;*************************************************************************>MOH<
(defun PcGetSidePinPL$ (
  &backPL$    ; 処理対象の線点列
  &bsANG      ; 基準となる角度
  &dirFLG     ; 取得する端のフラグ "L" or "R"
  /
  #chkD ;02/03/29MH@ADD
  #chkP$ #fANG #jdgP1 #jdgP2 #resP #minD #chP
  )
  (setq #chkP$ (apply 'append &backPL$))
  (setq #fANG &bsANG)
  (if (= "L" &dirFLG) (setq #fANG (+ pi #fANG)))
  ; 基準線設定
  (setq #jdgP1 (Pcpolar (car #chkP$) #fANG 100000))
  (setq #jdgP2 (Pcpolar #jdgP1 (+ (* 0.5 pi)  #fANG) 100))
  (setq #resP (car #chkP$))
  (setq #minD (distance #resP (inters #resP (pcpolar #resP #fANG 100) #jdgP1 #jdgP2 nil)))
  (foreach #chP #chkP$
    (setq #chkD (distance #chP (inters #chP (pcpolar #chP #fANG 100) #jdgP1 #jdgP2 nil)))
    (if (> #minD #chkD) (progn
      (setq #resP #chP)
      (setq #minD #chkD)
    )) ; if progn
  ); foreach
  #resP
); PcGetSidePinPL$

;<HOM>*************************************************************************
; <関数名>    : PcOffsetFilerBCPL$
; <処理概要>  : 背面の領域点列をオフセット処理
; <戻り値>    :
; <作成>      : 00-10-10 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcOffsetFilerBCPL$ (
  &dPL$       ; 処理対象の領域点列
  &ofsP       ; 全体からみたオフセット点
  &fOF        ; オフセット値
  &baseANG    ; 基準図形の角度
  /
  #dPL$ #ofANG$ #jdgANG$ #jANG
  )
  (setq #dPL$ &dPL$)
  ; 各線に対するオフセット方向リスト #ofANG$ を算出
  (setq #ofANG$ (PcGetPLOffsetAng$ #dPL$ &ofsP))
  (setq #jdgANG$ nil)
  (setq #jANG (read (angtos (+ &baseANG (* -0.5 pi)) 0 3)))
  (repeat (1- (length #dPL$)) (setq #jdgANG$ (cons #jANG #jdgANG$)))
  ; 正面方向の各点オフセット処理
  (setq #dPL$ (PcOffsetPL$ #dPL$ #ofANG$ #jdgANG$ &fOF 'T))
  ; 段差部分のオフセット処理
  (setq #dPL$ (PcOffsetPL$ #dPL$ #ofANG$ #jdgANG$ &fOF nil))
  #dPL$
); PcOffsetFilerBCPL$

;<HOM>*************************************************************************
; <関数名>    : PcOffsetFilerPL$
; <処理概要>  : 背面を除いた後の領域点列をオフセット処理
; <戻り値>    :
; <作成>      : 00-10-05 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcOffsetFilerPL$ (
  &dPL$       ; 処理対象の領域点列
  &ofsP       ; 全体からみたオフセット点
  &fOF        ; オフセット値
  &eCONR$     ; 領域中のコーナーキャビの図形名リスト
  &backFLG    ; 背面のあるなしフラグ (ある= 'T))
  /
  #dPL$ #dL #dR #TEMP$ #i #ofANG$ #dCONR$ #eCN #dCB #minD #dCCP #dP #dCONR$
  #jdgANG$ #iCP #jANG1 #jANG2 #jANG3 #jANG #chkXD$ #chkP #chkANG
  )
  (setq #dPL$ &dPL$)
  ; 左右側壁点を除いておく
  (setq #dL (car #dPL$))
  (setq #dR (last #dPL$))
  (setq #TEMP$ nil)
  (setq #i 1)
  (while (< #i (1- (length #dPL$)))
    (setq #TEMP$ (append #TEMP$ (list (nth #i #dPL$))))
    (setq #i (1+ #i))
  ); while

  (setq #dPL$ #TEMP$) ; 頭と最後が除かれた領域点列
  ; 各線に対するオフセット方向リスト #ofANG$ を算出
  (setq #ofANG$ (PcGetPLOffsetAng$ #dPL$ &ofsP))

  ; コーナーキャビの数だけ内角点 #dCONR$ を取得リスト化
  (setq #dCONR$ nil)
  (foreach #eCN &eCONR$
    (setq #chkXD$ (CFGetXData #eCN "G_LSYM"))
    ; 02/03/29MH@MOD 基点をLSYMから取っていたので変更
    (setq #chkP (cdr (assoc 10 (entget #eCN))))
    ; 02/03/29MH@DEL (setq #chkP (cadr #chkXD$))
    ; コーナーキャビ
    (if (= CG_SKK_THR_CNR (CFGetSymSKKCode #eCN 3))
      (progn
        ; #dPL$中のコーナーキャビの基点に一番近い点が基準内角点
        (setq #minD 10000); 仮値
        (setq #dCCP nil)
        (foreach #dP #dPL$
          (if (> #minD (distance #chkP #dP))
            (progn
              (setq #minD (distance #chkP #dP))
              (setq #dCCP #dP)
          )); if
        )
      );progn
      (progn
      ; ダイニングキャビを使用する場合はキャビ基点の延長線上にある点で距離が短い方
        (setq #chkANG (atof (angtos (nth 2 #chkXD$) 0 3)))
        (setq #dCCP nil)
        (foreach #dP #dPL$
          (if (equal #chkANG (atof (angtos (angle #chkP #dP) 0 3)) 0.001)
            (cond
              ((not #dCCP) (setq #dCCP #dP))
              ((< (distance #chkP #dP) (distance #chkP #dCCP))(setq #dCCP #dP))
            ); cond
          ); if
        ); foreach
      );progn
    ); if
    (setq #dCONR$ (append #dCONR$ (list #dCCP)))
  ); foreach
  ; 左→右の順に コーナーキャビ角点を判断基準に各バラ線対応の正面角度リストを作成
  (setq #jdgANG$ nil)
  (setq #iCP (length #dCONR$))
  (cond
    ; I型
    ((= 0 #iCP)
      (setq #jANG (read (angtos (angle (car #dPL$) #dL) 0 3)))
      (repeat (1- (length #dPL$)) (setq #jdgANG$ (cons #jANG #jdgANG$)))
    ); I型
    ; L型
    ((= 1 #iCP)
      (setq #jANG1 (read (angtos (angle (car #dPL$) #dL) 0 3)))
      (setq #jANG2 (read (angtos (angle (last #dPL$) #dR) 0 3)))
      (setq #i 1)
      (setq #jANG #jANG1)
      (while (< #i (length #dPL$))
        (setq #jdgANG$ (append #jdgANG$ (list #jANG)))
        (if (equal 0 (distance (nth #i #dPL$) (car #dCONR$)) 0.1) (setq #jANG #jANG2))
        (setq #i (1+ #i))
      ); while
    ); L型
    ; U型
    ((= 2 #iCP)
      ; 中間部分の角度を取得しておく
      ; コーナーキャビの基点２点と、基準内角点の交点を求める
      (setq #jANG1 (read (angtos (angle (car #dPL$) #dL) 0 3)))
      ; 02/03/29MH@MOD 基点をLSYMから取っていたので変更
      (setq #jANG2 (read (angtos (+ (* 0.5 pi)
        (angle (cdr (assoc 10 (entget (car &eCONR$))))
               (cdr (assoc 10 (entget (cadr &eCONR$)))))) 0 3)))
      ; 02/03/29MH@DEL(setq #jANG2 (read (angtos (+ (* 0.5 pi)
      ; 02/03/29MH@DEL  (angle (cadr (CFGetXData (car &eCONR$) "G_LSYM"))
      ; 02/03/29MH@DEL         (cadr (CFGetXData (cadr &eCONR$) "G_LSYM")))) 0 3)))
      (setq #jANG3 (read (angtos (angle (last #dPL$) #dR) 0 3)))
      (setq #i 1)
      (setq #jANG #jANG1)
      (while (< #i (length #dPL$))
        (setq #jdgANG$ (append #jdgANG$ (list #jANG)))
        (if (or (equal (nth #i #dPL$) (car #dCONR$) 0.01)
                (equal (nth #i #dPL$) (cadr #dCONR$) 0.01))
          (if (= #jANG #jANG1) (setq #jANG #jANG2) (setq #jANG #jANG3))
        ); if
        (setq #i (1+ #i))
      ); while
    ); U型
  ); cond
  ; 正面方向の各点オフセット処理
  (setq #dPL$ (PcOffsetPL$ #dPL$ #ofANG$ #jdgANG$ &fOF 'T))
  (setq #dPL$ (PcOffsetPL$ #dPL$ #ofANG$ #jdgANG$ &fOF nil))
  ; 背面方向の各点オフセット処理
  (if &backFLG (progn
    (setq #dL (Pcpolar #dL (angle #dL (car #dPL$)) &fOF))
    (setq #dR (Pcpolar #dR (angle #dR (last #dPL$)) &fOF))
  )); if progn
  ; 左右側壁点を戻す
  (append (list #dL) #dPL$ (list #dR))
); PcOffsetFilerPL$

;<HOM>*************************************************************************
; <関数名>    : PcGetPLOffsetAng$
; <処理概要>  : ポリライン点リストとそれに対応する１個のオフセット点から
;             : ポリラインを構成する各線に対応する オフセット角度リストを作成
; <戻り値>    : 構成線分の角度リスト
; <作成>      : 00-07-03 MH
; <備考>      : オフセット距離がマイナスの場合、180度回転角度を設定
;*************************************************************************>MOH<
(defun PcGetPLOffsetAng$ (
  &pt$        ; ポリライン点リスト
  &ofP        ; オフセット基準点
  /
  #ofANG$     ; ポリラインを構成する各線に対応するオフセット角度
  #dRES$      ; ポリラインを構成する各線に対応するオフセット点リスト
  #eDEL #subP$ #i #i2 #stP1 #nxP1 #stP2 #nxP2 #crsP1 #crsP2 #ofANG #ofANG$ #view$
  )
  ; まず、ユーザの示した#ofP点でオフセットした仮ポリ線点リスト取得
  (MakeLwPolyLine &pt$ 0 CG_UpCabHeight)
  (setq #eDEL (entlast))
  ;;; 00/07/22 MH ADD オフセットの際の角度を平面にする
  (setq #view$ (getvar "VIEWDIR"));;; 要視点操作
  (command "_vpoint" '(0 0 1))
  (command "_offset" 10 (entlast) (list (car &ofP) (cadr &ofP)) "")
;(command "_change" (entlast) "" "P" "C" "green" "");テスト用色つけ
  (command "_vpoint" #view$);;;視点を元にもどす
  (setq #subP$ (GetLWPolyLinePt (entlast))) ;仮ポリ線点リスト#subP$
  (entdel (entlast)) ;リスト取得に使用した図形は消去
  (entdel #eDEL)

  ; 線に対するオフセット方向リスト #ofANG$ を算出
  (setq #i 0)
  (while (setq #nxP1 (nth (1+ #i) &pt$))
    (setq #stP1 (nth #i &pt$))
    (setq #ofANG (angle #stP1 #nxP1))
    (setq #crsP1 (pcpolar #stP1 #ofANG (* 0.5 (distance #stP1 #nxP1))))
    (setq #crsP2 nil)
    (setq #i2 0)
    (while (and (not #crsP2) (setq #nxP2 (nth (1+ #i2) #subP$)))
      (setq #crsP2 (inters (nth #i2 #subP$) #nxP2 #crsP1
        (pcpolar #crsP1 (+ #ofANG (DTR 90)) 100) nil))
      (if (not (and #crsP2 (equal 10 (distance #crsP1 #crsP2) 0.1)))
        (setq #crsP2 nil)
      )
      (setq #i2 (1+ #i2))
    ); while
    (if #crsP2
      (setq #ofANG (angle #crsP1 #crsP2))
      (setq #ofANG (+ (angle #stP1 #nxP1) (DTR 90)))
    )
    ; #ofANG算出ここまで。リストに取得
    (setq #ofANG$ (append #ofANG$ (list #ofANG)))
    (setq #i (1+ #i))
  ); while
  #ofANG$
); PcGetPLOffsetAng$

;<HOM>*************************************************************************
; <関数名>    : PcGetPLOffsetAngEach$
; <処理概要>  : P点リストとそれに対応するオフセット点から個別角度リスト作成
; <戻り値>    : 構成線分の角度リスト
; <作成>      : 00-07-03 MH
; <備考>      : 一本の線にしか使えない
;*************************************************************************>MOH<
(defun PcGetPLOffsetAngEach$ (
  &pt$        ; ポリライン点リスト
  &ofP        ; オフセット基準点
  /
  #ofANG$     ; ポリラインを構成する各線に対応するオフセット角度
  #dRES$      ; ポリラインを構成する各線に対応するオフセット点リスト
  #eDEL #subP$ #i #i2 #stP1 #nxP1 #stP2 #nxP2 #crsP1 #crsP2 #ofANG #ofANG$ #view$
  )
  ;;; 00/07/22 MH ADD オフセットの際の角度を平面にする
  (setq #view$ (getvar "VIEWDIR"));;; 要視点操作
  (command "_vpoint" '(0 0 1))

  ; 線に対するオフセット方向リスト #ofANG$ を算出
  (setq #i 0)
  (while (setq #nxP1 (nth (1+ #i) &pt$))
    ; まず、ユーザの示した#ofP点でオフセットした仮ポリ線点リスト取得
    (MakeLwPolyLine (list (nth #i &pt$) #nxP1) 0 CG_UpCabHeight)
    (setq #eDEL (entlast))
    (command "_offset" 50 (entlast) (list (car &ofP) (cadr &ofP)) "")
    (setq #subP$ (GetLWPolyLinePt (entlast))) ;仮ポリ線点リスト#subP$
    (entdel (entlast)) ;リスト取得に使用した図形は消去
    ;(command "_change" (entlast) "" "P" "C" "green" "");テスト用色つけ
    (entdel #eDEL)

    (setq #stP1 (nth #i &pt$))
    (setq #ofANG (angle #stP1 #nxP1))
    (setq #crsP1 (pcpolar #stP1 #ofANG (* 0.5 (distance #stP1 #nxP1))))
    (setq #crsP2 nil)
    (setq #i2 0)
    (while (and (not #crsP2) (setq #nxP2 (nth (1+ #i2) #subP$)))
      (setq #crsP2 (inters (nth #i2 #subP$) #nxP2 (list (car #crsP1) (cadr #crsP1))
        (pcpolar #crsP1 (+ #ofANG (DTR 90)) 100) nil))
      (if (not (and #crsP2 (equal 50 (distance #crsP1 #crsP2) 0.1)))
        (setq #crsP2 nil)
      )
      (setq #i2 (1+ #i2))
    ); while
    (if #crsP2
      (setq #ofANG (angle #crsP1 #crsP2))
      (setq #ofANG (+ (angle #stP1 #nxP1) (DTR 90)))
    )
    ; #ofANG算出ここまで。リストに取得
    (setq #ofANG$ (append #ofANG$ (list #ofANG)))
    (setq #i (1+ #i))
  ); while
  (command "_vpoint" #view$);;;視点を元にもどす

  #ofANG$
); PcGetPLOffsetAngEach$

;<HOM>*************************************************************************
; <関数名>    : PcPL$SidePart
; <処理概要>  : 左右側壁部の有無をグローバルから判断しフィラー領域点列を変更
; <戻り値>    : 領域点列リスト
; <作成>      : 00-10-05 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcPL$SidePart (
  &dPL$       ; 対象の領域点列
  &fOF        ; オフセット値
  /
  #dPL$ #ofANG #i #oPL #TEMP$ #dPL$
  )
  ; 側面左右フラグをみてオフセット&除去処理
  (setq #dPL$ &dPL$)
  (if (= 1 SKW_FILLER_LSIDE)
  ; 左側面有り
    (progn
      (setq #ofANG (angle (cadr #dPL$) (caddr #dPL$)))
      (setq #TEMP$ nil)
      (setq #i 0)
      (foreach #oPL #dPL$
        (if (> 2 #i)
          (setq #TEMP$ (append #TEMP$ (list (Pcpolar #oPL #ofANG &fOF))))
          (setq #TEMP$ (append #TEMP$ (list #oPL)))
        ); if
        (setq #i (1+ #i))
      ); foreach
      (setq #dPL$ #TEMP$)
    ); progn
    ; 左側面なし
    (setq #dPL$ (cdr #dPL$))
  ); 左
  (if (= 1 SKW_FILLER_RSIDE)
    ; 右側面有り
    (progn
      (setq #ofANG (angle (nth (- (length #dPL$) 2) #dPL$)
                          (nth (- (length #dPL$) 3) #dPL$)))
      (setq #TEMP$ nil)
      (setq #i 0)
      (foreach #oPL #dPL$
        (if (< (- (length #dPL$) 3) #i)
          (setq #TEMP$ (append #TEMP$ (list (Pcpolar #oPL #ofANG &fOF))))
          (setq #TEMP$ (append #TEMP$ (list #oPL)))
        ); if
        (setq #i (1+ #i))
      ); foreach
      (setq #dPL$ #TEMP$)
    ); progn
    ; 右側面なし
    (setq #dPL$ (reverse (cdr (reverse #dPL$))))
  ); 右
  #dPL$
); PcPL$SidePart

;<HOM>*************************************************************************
; <関数名>    : PcPL$SidePart2
; <処理概要>  : 背面線：左右側壁部の有無をグローバルから判断しフィラー領域点列変更
; <戻り値>    : 領域点列リスト
; <作成>      : 00-10-05 MH
; <備考>      : 背面用
;*************************************************************************>MOH<
(defun PcPL$SidePart2 (
  &fANG       ; 基準角度
  &dPL$       ; 対象の領域点列
  &fOF        ; オフセット値
  /
  #dPL$ #ofANG #newP
  )
  (setq #dPL$ &dPL$)
  ; 左側面有り  オフセット&除去処理
  (if (= 1 SKW_FILLER_LSIDE) (progn
    (setq #ofANG &fANG)
    (setq #newP (pcpolar (last #dPL$) #ofANG &fOF))
    (setq #dPL$ (reverse (cons #newP (cdr (reverse #dPL$)))))
  )); 左
  ; 右側面有り  オフセット&除去処理
  (if (= 1 SKW_FILLER_RSIDE) (progn
      (setq #ofANG (+ pi &fANG))
      (setq #newP (pcpolar (car #dPL$) #ofANG &fOF))
      (setq #dPL$ (cons #newP (cdr #dPL$)))
  )); 右
  #dPL$
); PcPL$SidePart2

;<HOM>*************************************************************************
; <関数名>    : PcOffsetPL$
; <処理概要>  : 領域点列を角度(正面or他)を確認しながらオフセットされた位置に移動
; <戻り値>    : 加工済み点リスト
; <作成>      : 00-10-06 MH
; <備考>      :
;*************************************************************************>MOH<;
(defun PcOffsetPL$ (
  &dPL$       ; 処理対象領域点列
  &fANG$      ; 線ごとのオフセット角度リスト
  &jdgANG$    ; 正面かどうか確認するための角度（加工済み）リスト
  &fOF        ; オフセット値
  &frontFLG   ; 正面方向のオフセットならT 側面ならnil
  /
  #dPL$ #i #ii #angFLG #P1 #P2 #TEMP$ #dP
  )
  (setq #dPL$ &dPL$)
  (setq #i 0)
  (while (< #i (1- (length #dPL$)))
    (setq #angFLG (equal (read (angtos (nth #i &fANG$) 0 3)) (nth #i &jdgANG$) 0.01))
    (if (or (and &frontFLG #angFLG) (and (not &frontFLG) (not #angFLG)))(progn
      (setq #P1 (pcpolar (nth #i #dPL$) (nth #i &fANG$) &fOF))
      (setq #P2 (pcpolar (nth (1+ #i) #dPL$) (nth #i &fANG$) &fOF))
      ; コーナーキャビ部内角対応のため随時オリジナル#dPL$を更新する必要有
      (setq #TEMP$ nil)
      (setq #ii 0)
      (foreach #dP #dPL$
        (cond
          ((= #i #ii) (setq #TEMP$ (append #TEMP$ (list #P1))))
          ((= (1+ #i) #ii) (setq #TEMP$ (append #TEMP$ (list #P2))))
          (t (setq #TEMP$ (append #TEMP$ (list #dP))))
        ); cond
        (setq #ii (1+ #ii))
      ); foreach
      (setq #dPL$ #TEMP$) ; オリジナル#dPL$を更新
    )); if progn
    (setq #i (1+ #i))
  ); while
  #dPL$
); PcOffsetPL$

;<HOM>*************************************************************************
; <関数名>    : PcMkPL$byLine$
; <処理概要>  : 連続した線のリストをポリライン点リストにもどす
; <戻り値>    : 点リスト
; <作成>      : 00/10/05 MH
; <備考>      : Ｐ点リストは頭の点と最後の点が同じ場合のみ閉じたポリライン扱い
;*************************************************************************>MOH<
(defun PcMkPL$byLine$ (&LINE$ / #i #PL$)
  (setq #i 0)
  (setq #PL$ (list (car &LINE$)))
  (while (< #i (1- (length &LINE$)))
    (setq #PL$ (append #PL$ (list (cadr (nth #i &LINE$)))))
    (setq #i (1+ #i))
  ); while
  #PL$
); PcMkPL$byLine$

;<HOM>*************************************************************************
; <関数名>    : PcOrderPL$byOneP
; <処理概要>  : 閉じたＰ点リストをある点が1番目の位置にくるよう並べ替え
; <戻り値>    : 並べ替えたＰ点リスト
; <作成>      : 00/10/10 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcOrderPL$byOneP (
  &CPL$       ; 閉じたP点リスト   (a b c d e f g)
  &topP       ; トップにくる点
  /
  #CPL$ #i #stopF #aMOV
  )
  (setq #CPL$ &CPL$)
  (setq #stopF (if (equal (car #CPL$) &topP 0.01) 'T nil))
  (setq #i 0)
  (while (and (not #stopF) (< #i (length #CPL$)))
    (setq #aMOV (car #CPL$))
    (setq #CPL$ (append (cdr #CPL$) (list #aMOV)))
    (setq #stopF (if (equal (car #CPL$) &topP 0.01) 'T nil))
    (setq #i (1+ #i))
  ); while
  #CPL$
); PcOrderPL$byOneP

;<HOM>*************************************************************************
; <関数名>    : PcGetFilerHeight
; <処理概要>  : アッパー用図形から、上部基点のZ値をだす
; <戻り値>    : Z値
; <作成>      : 00/08/01 MH
; <備考>      : 途中 nil が検出されれば、ユーザーに高さをたずねる。
;*************************************************************************>MOH<
(defun PcGetFilerHeight (
  &eITEM      ; 設置の基準となる図形名
  /
  #eITEM #LXD$ #XD$ #NEXT$ #NX #sCHK #eMC #fZ #elv #height
  )
  (setq #eITEM &eITEM)
  (if (= 'ENAME (type #eITEM)) (progn
    (setq #LXD$ (CFGetXData #eITEM "G_LSYM"))
    ; アイテムの基点のZ値を取得
    ; 02/03/29MH@MOD 基点をLSYMから取っていたので変更
    (setq #fZ (caddr (cdr (assoc 10 (entget #eITEM)))))
    ; 02/03/29MH@DEL(setq #fZ (caddr (cadr #LXD$)))
    (setq #XD$ (CFGetXData #eITEM "G_SYM"))
    (if (= 1 (nth 10 #XD$)) (setq #fZ (+ #fZ (nth 5 #XD$))))
  )); if&progn
  ; ここまでで  #fZ が取れてなければ、ユーザーに決めさせる。
  (if (not (numberP #fZ)) (progn
    (setq #elv (getvar "ELEVATION"))
    (setvar "ELEVATION" CG_UpCabHeight)
    (setq #height (getreal (strcat "\n \n高さ<" (itoa (fix CG_UpCabHeight)) ">: ")))
    (setq #fZ (if (not #height) CG_UpCabHeight #height))
    (setvar "ELEVATION" #elv) ; 元の高さに戻す
  )); if
  #fZ
); PcGetFilerHeight

;<HOM>***********************************************************************
; <関数名>    : PcMakeFiler
; <処理概要>  : 基準ポリラインから天井フィラー図形作成、拡張データセット
; <戻り値>    : 図形名
; <作成>      : 00/04/24 MH
; <備考>      : 00/10/10 MH 最初と最後が同一なら閉P線とみなし処理するように変更
;***********************************************************************>HOM<
(defun PcMakeFiler (
    &sOPHIN   ; フィラー品番
;;;01/12/17YM@MOD    &iFR      ; フィラー種類番号 引数削除
    &pt$      ; フィラー作成の元となるPLINEを表す点リスト
    &ofP      ; オフセットの方向点（Nilだと自動算出する）
    &fD       ; フィラーの厚み
    &fH       ; フィラーの高さ
    &fUPHeight ; フィラーの設置高度
;-- 2011/08/11 A.Satoh Add - S
    &syokei   ; 小計区別 "A":キッチン "D":収納
;-- 2011/08/11 A.Satoh Add - E
    /
   #os #view$ #FLG #pt$ #ofP #closeFLG #ePL #eOFSPL #pt2$ #e1 #e2
   #e1AREA #e2AREA #eOUT #eIN #en #FLG
#AORD ;2011/08/12 YM ADD
  )
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (setq #view$ (getvar "VIEWDIR"));;; 要視点操作
  (setq #FLG (if (equal #view$ '(0.0 -1.0 0.0) 0.01) 'T nil))
  (if #FLG (command "_vpoint" '(0 0 1)))

  (setq #pt$ &pt$)
  (if (not &ofP)
    (setq &ofP (polar (car #pt$) (+ (dtr 90) (angle (car #pt$) (cadr #pt$))) 100)))
  (setq #ofP (list (car &ofP) (cadr &ofP) &fUPHeight))

  ; フィラー3DSOLIDの作成と積算用のポリライン#ePL取得
  (setq #closeFLG (if (equal (car #pt$) (last #pt$) 0.01) 'T nil))
  (if #closeFLG
    (MakeLwPolyLine (cdr #pt$) 1 &fUPHeight) ; 閉じたポリライン
    (MakeLwPolyLine #pt$ 0 &fUPHeight)       ; 開いたポリライン
  ); (command "_change" (entlast) "" "P" "C" "red" "") ;確認用
  (setq #ePL (entlast))
  ; 厚み分オフセットしたポリライン作成，点リスト取得
  (command "_offset" &fD (entlast) #ofP "")
  (setq #eOFSPL (entlast))
  (setq #pt2$ (GetLWPolyLinePt #eOFSPL))
  (if #closeFLG
    ; 閉じたポリライン
    (progn
      ;// 天井フィラーの外形領域(リージョン)を生成
      ; 外側の閉ポリライン
      (entmake (entget #ePL))
      (command "_region" (entlast) "")
      (setq #e1 (entlast))
      (command "_AREA" "O" (entlast))
      (setq #e1AREA (getvar "AREA"))
      ;(command "_change" (entlast) "" "P" "C" "red" "") ;確認用
      ; 内側の閉ポリライン
      (command "_region" #eOFSPL "")
      ;(command "_change" (entlast) "" "P" "C" "blue" "") ;確認用
      (setq #e2 (entlast))
      (command "_AREA" "O" (entlast))
      (setq #e2AREA (getvar "AREA"))
      (cond
        ((> #e1AREA #e2AREA) (setq #eOUT #e1) (setq #eIN #e2))
        ((< #e1AREA #e2AREA) (setq #eOUT #e2) (setq #eIN #e1))
        (t (CFAlertMsg "フィラー作図用 閉ポリラインが作成できませんでした")(exit))
      ); cond
      (command "_subtract" #eOUT "" #eIN "")
    ); progn
    ; 開いたポリライン
    (progn
      (entdel #eOFSPL)
      ;;; 部材厚分の点リストも足して領域点リスト作成
      (setq #pt2$ (reverse #pt2$))
      (setq #pt$ (append #pt$ #pt2$))
      ;// 天井フィラーの外形領域(閉ポリライン)を生成
      (MakeLwPolyLine #pt$ 1 &fUPHeight)
    );progn
  ); if
  ;// 天井フィラーの押し出し
  ;2008/07/28 YM MOD 2009対応
  (command "_extrude" (entlast) "" &fH )
;;;  (command "_extrude" (entlast) "" &fH "")
  (setq #en (entlast))
  (entmod (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #en)) (entget #en)))

  (if #FLG (command "_vpoint" #view$))
  (setvar "OSMODE" #os)

  ;// 天井フィラー拡張データの付加
  (if (= nil (tblsearch "APPID" "G_FILR"))(regapp "G_FILR"))


	;2011/08/12 YM ADD プラン検索のときの小計(ｷｯﾁﾝ or 収納)の値を上書き
	(if (and CG_GLOBAL$ (nth 46 CG_GLOBAL$) (/= (nth 46 CG_GLOBAL$) "N")(/= (nth 46 CG_GLOBAL$) "X"))
		(setq &syokei "A");ｷｯﾁﾝ
	);_if
	(if (and CG_GLOBAL$ (nth 72 CG_GLOBAL$) (/= (nth 72 CG_GLOBAL$) "N")(/= (nth 72 CG_GLOBAL$) "X"))
		(setq &syokei "D");収納
	);_if


  (if #en (CFSetXData #en "G_FILR"
;-- 2011/08/11 A.Satoh Mod - S
;    (list &sOPHIN SKW_AUTO_SOLID #ePL 1 0.0 SKW_FILLER_LLEN SKW_FILLER_RLEN)))
    (list &sOPHIN SKW_AUTO_SOLID #ePL 1 0.0 SKW_FILLER_LLEN SKW_FILLER_RLEN &syokei)))
;-- 2011/08/11 A.Satoh Mod - E
  ; オプション設置  01/04/03 MH ADD
  (KcSetG_OPT #en)
  #en
); PcMakeFiler

; <HOM>***********************************************************************************
; <関数名>   : PcListOrderByNumInList
; <処理概要> : リスト中の数値を含んだリストを指定の位置の数の大きさ順でソートする。
; <戻り値>   : 内容がソートされたリスト (基準の数字 小→大)
; <備考>     : 数値以外が入っていると元のリストが返ります。
; ***********************************************************************************>MOH<
(defun PcListOrderByNumInList (
  &NUM$      ; リストの集合
  &iLO       ; ソートの基準にする数値の位置（左から 0）
  /
  #X #iA #iB #NUM #STOP #TEMP$ #NUM$ #DEC$ #NEW$
  )
  (foreach #NUM &NUM$ (if (not (numberp (nth &iLO #NUM))) (setq #STOP 'T)))
  (if (= 'T #STOP)
    (setq #NEW$ &NUM$)
    (progn
      (setq #NUM$ &NUM$)
      (while (car #NUM$)
        (setq #TEMP$ (mapcar '(lambda (#X) (nth &iLO #X)) #NUM$))
        (setq #iA (- (length #TEMP$) (length (member (apply 'min #TEMP$) #TEMP$))))
        (setq #NEW$ (append #NEW$ (list (nth #iA #NUM$))))
        (setq #iB 0)
        (setq #DEC$ nil)
        (while (< #iB (length #NUM$))
          (if (/= #iB #iA)
            (setq #DEC$ (append #DEC$ (list (nth #iB #NUM$))))
          ); end of if
          (setq #iB (1+ #iB))
        ); end of while
        (setq #NUM$ #DEC$)
      ); end of while
    ); end of progn
  ); end of if
  #NEW$
); end of defun

;<HOM>*************************************************************************
; <関数名>    : PcMkLine$byPL$
; <処理概要>  : ポリライン点リストを バラ線のリストに編集
; <戻り値>    : 点順のままの 線リスト
; <作成>      : 00/10/04 MH
; <備考>      : フラグが Tなら 閉じたポリライン点として最後と頭の点の線を加える
;*************************************************************************>MOH<
(defun PcMkLine$byPL$ (&PL$ &C_FLG / #i #LINE$)
  (setq #i 0)
  (while (< #i (1- (length &PL$)))
    (setq #LINE$ (append #LINE$ (list (list (nth #i &PL$) (nth (1+ #i) &PL$)))))
    (setq #i (1+ #i))
  ); while
  (if &C_FLG (setq #LINE$ (append #LINE$ (list (list (last &PL$) (car &PL$))))))
  #LINE$
); PcMkLine$byPL$
;;;02/04/04MH@DEL<HOM>*************************************************************************
;;;02/04/04MH@DEL <関数名>    : PcGetUpperItemPL$
;;;02/04/04MH@DEL <処理概要>  : アッパーアイテムの図形名リストから、外形線P点リスト作成
;;;02/04/04MH@DEL <戻り値>    : ((図形名 (外形線P点)) (図形名 (外形線P点))･･･)
;;;02/04/04MH@DEL <作成>      : 00-10-03 MH
;;;02/04/04MH@DEL <備考>      : センターキャビ,レンジフード,サイドパネルD380は要領域縮小
;;;02/04/04MH@DEL*************************************************************************>MOH<
;;;02/04/04MH@DEL(defun PcGetUpperItemPL$ (
;;;02/04/04MH@DEL  &eUPPER$    ; アッパーアイテムリスト
;;;02/04/04MH@DEL  /
;;;02/04/04MH@DEL  #RES$ #eUP #LSYM$ #up-ss #i #ePMEN #en #pxd$ #dAREA$ #fD #GSYM$ #dSymPT
;;;02/04/04MH@DEL  #eUPPER0$ ;02/04/03MH@ADD
;;;02/04/04MH@DEL  )
;;;02/04/04MH@DEL ; 02/01/16 YM ADD-S ｻｲﾄﾞﾊﾟﾈﾙを対象外にする
;;;02/04/04MH@DEL (setq #eUPPER0$ nil) ; ｻｲﾄﾞﾊﾟﾈﾙを除外したもの
;;;02/04/04MH@DEL  (foreach #eUP &eUPPER$
;;;02/04/04MH@DEL    (if (= CG_SKK_ONE_SID (CFGetSymSKKCode #eUP 1))
;;;02/04/04MH@DEL     nil
;;;02/04/04MH@DEL     (setq #eUPPER0$ (append #eUPPER0$ (list #eUP)))
;;;02/04/04MH@DEL   );_if
;;;02/04/04MH@DEL )
;;;02/04/04MH@DEL ; 02/01/16 YM ADD-E ｻｲﾄﾞﾊﾟﾈﾙを対象外にする
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL02/01/16 YM MOD  (foreach #eUP &eUPPER$
;;;02/04/04MH@DEL  (foreach #eUP #eUPPER0$
;;;02/04/04MH@DEL    ; 天井ﾌｨﾗｰ不具合対応 01/11/26 YM ADD G_LSYMの挿入点を使用せず、実際のｼﾝﾎﾞﾙ座標値を使用
;;;02/04/04MH@DEL    (setq #dSymPT (cdr (assoc 10 (entget #eUP)))) ; 01/11/26 YM ADD
;;;02/04/04MH@DEL    (setq #LSYM$ (CFGetXData #eUP "G_LSYM"))
;;;02/04/04MH@DEL    (setq #GSYM$ (CFGetXData #eUP "G_SYM"))
;;;02/04/04MH@DEL    ; ポリライン点リスト取得
;;;02/04/04MH@DEL    (if (= CG_SKK_THR_CNR (CFGetSymSKKCode #eUP 3))
;;;02/04/04MH@DEL      ; コーナーキャビのみＰ面から取得させる
;;;02/04/04MH@DEL      (progn
;;;02/04/04MH@DEL        ; 使用区分=2 のP面をグループ内から検索
;;;02/04/04MH@DEL        (setq #up-ss (CFGetSameGroupSS #eUP))
;;;02/04/04MH@DEL        (setq #i 0)
;;;02/04/04MH@DEL        (setq #ePMEN nil)
;;;02/04/04MH@DEL        (while (and (not #ePMEN) (< #i (sslength #up-ss)))
;;;02/04/04MH@DEL          (setq #en (ssname #up-ss #i))
;;;02/04/04MH@DEL          (setq #pxd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
;;;02/04/04MH@DEL          (if (and #pxd$ (= 2 (car #pxd$))) (setq #ePMEN #en))
;;;02/04/04MH@DEL          (setq #i (1+ #i))
;;;02/04/04MH@DEL        )
;;;02/04/04MH@DEL        (setq #dAREA$ (GetLWPolyLinePt #ePMEN)); Ｐ面２外形領域点列を求める
;;;02/04/04MH@DEL        (setq #dAREA$ (PcChgCornerCabD$ #dSymPT #LSYM$ #dAREA$));;02/03/29MH@MODフィラー誤作動
;;;02/04/04MH@DEL        ;;; (setq #dAREA$ (PcChgCornerCabD$ #LSYM$ #dAREA$)); 扉分補正 01/01/28 MH ADD
;;;02/04/04MH@DEL      ); progn
;;;02/04/04MH@DEL      ; コーナーキャビ以外のアイテム処理
;;;02/04/04MH@DEL      (progn
;;;02/04/04MH@DEL        ; 奥行値
;;;02/04/04MH@DEL        (cond
;;;02/04/04MH@DEL          ; アイテムがレンジフード、サイドパネルだった (隣接から取得)
;;;02/04/04MH@DEL          ((= CG_SKK_ONE_RNG (CFGetSymSKKCode #eUP 1))
;;;02/04/04MH@DEL            (setq #fD (PcGetRange&SideFilrD #eUP &eUPPER$)) ; #eUPPER$ → &eUPPER$ 02/01/16 YM MOD
;;;02/04/04MH@DEL;;;02/01/16 YM MOD            (setq #fD (PcGetRange&SideFilrD #eUP #eUPPER$)) ; 変数#eUPPER$はここで初めてでてきた.おかしいのでは?
;;;02/04/04MH@DEL          )
;;;02/04/04MH@DEL          ; それ以外（要センターキャビ補正）
;;;02/04/04MH@DEL          (t (setq #fD (nth 4 #GSYM$)))
;;;02/04/04MH@DEL        )
;;;02/04/04MH@DEL        ; 範囲点算出 (角度と基点は図形から共通で取得)
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL       ; 天井ﾌｨﾗｰ不具合対応 01/11/26 YM ADD G_LSYMの挿入点を使用せず、実際のｼﾝﾎﾞﾙ座標値を使用
;;;02/04/04MH@DEL        (setq #dAREA$ (PcMk4P$byWD&Ang #dSymPT (nth 3 #GSYM$) #fD (nth 2 #LSYM$)))
;;;02/04/04MH@DEL;;;01/11/26YM@MOD        (setq #dAREA$ (PcMk4P$byWD&Ang (cadr #LSYM$) (nth 3 #GSYM$) #fD (nth 2 #LSYM$)))
;;;02/04/04MH@DEL      ); progn
;;;02/04/04MH@DEL    ); if
;;;02/04/04MH@DEL    (setq #RES$ (cons (list #eUP #dAREA$) #RES$))
;;;02/04/04MH@DEL  ); foreach
;;;02/04/04MH@DEL  #RES$
;;;02/04/04MH@DEL); PcGetUpperItemPL$
;;;02/04/04MH@DEL<HOM>*************************************************************************
;;;02/04/04MH@DEL <関数名>    : PcChgCornerCabD$
;;;02/04/04MH@DEL <処理概要>  : コーナーキャビの扉面を除いた外形点リスト作成
;;;02/04/04MH@DEL <戻り値>    :
;;;02/04/04MH@DEL <作成>      : 01-01-19 MH
;;;02/04/04MH@DEL <備考>      :
;;;02/04/04MH@DEL*************************************************************************>MOH<
;;;02/04/04MH@DEL(defun PcChgCornerCabD$ (
;;;02/04/04MH@DEL  &dSymPT     ; コーナーキャビ基点  ;; 02/03/29MH@ADD
;;;02/04/04MH@DEL  &LSYM$      ; コーナーキャビのLSYM
;;;02/04/04MH@DEL  &dAREA$     ; P面点リスト
;;;02/04/04MH@DEL  / 
;;;02/04/04MH@DEL  #err #jANG #LINE$ #i #TEMP$ #chkL #d0 #d1 #d2 #d3 #d4 #d5 #d6
;;;02/04/04MH@DEL  #d2new #d3new #d4new #dNEW$
;;;02/04/04MH@DEL  )
;;;02/04/04MH@DEL  (defun ##findPnt (&LN$ &dCHK / #chkL #TEMP$ #resP #resL$)
;;;02/04/04MH@DEL    (setq #resP nil)
;;;02/04/04MH@DEL    (setq #TEMP$ nil)
;;;02/04/04MH@DEL    (foreach #chkL &LN$
;;;02/04/04MH@DEL      (cond
;;;02/04/04MH@DEL        ((equal 0 (distance (car #chkL) &dCHK) 0.1)  (setq #resP (cadr #chkL)))
;;;02/04/04MH@DEL        ((equal 0 (distance (cadr #chkL) &dCHK) 0.1) (setq #resP (car #chkL)))
;;;02/04/04MH@DEL        (t (setq #TEMP$ (cons #chkL #TEMP$)))
;;;02/04/04MH@DEL      ); cond
;;;02/04/04MH@DEL    ); foreach
;;;02/04/04MH@DEL    (if #resP (setq #LINE$ #TEMP$) (setq #err nil))
;;;02/04/04MH@DEL    #resP
;;;02/04/04MH@DEL  ); defun
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL  (setq #err 'T)
;;;02/04/04MH@DEL  (setq #jANG (read (angtos (caddr &LSYM$) 0 3))); 設置角度
;;;02/04/04MH@DEL  ;;02/03/29MH@MOD 扉分オフセット不可の不具合対応
;;;02/04/04MH@DEL  (setq #d0 &dSymPT) ; コーナーキャビの基点座標
;;;02/04/04MH@DEL  ;;;(setq #d0 (cadr &LSYM$)) ; コーナーキャビの基点座標
;;;02/04/04MH@DEL  (setq #d0 (list (car #d0) (cadr #d0)))
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL  (setq #i 1)
;;;02/04/04MH@DEL  (setq #LINE$ (list (list (car &dAREA$) (last &dAREA$))))
;;;02/04/04MH@DEL  (while (< #i (length &dAREA$))
;;;02/04/04MH@DEL    (setq #LINE$ (cons (list (nth (1- #i) &dAREA$) (nth #i &dAREA$)) #LINE$))
;;;02/04/04MH@DEL    (setq #i (1+ #i))
;;;02/04/04MH@DEL  ); while
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL  ; 基点から設置角度上にある点 #d1
;;;02/04/04MH@DEL  (setq #TEMP$ nil)
;;;02/04/04MH@DEL  (foreach #chkL #LINE$
;;;02/04/04MH@DEL    (cond
;;;02/04/04MH@DEL      ((and (equal 0 (distance (car #chkL) #d0) 0.1)
;;;02/04/04MH@DEL            (equal #jANG (read (angtos (angle #d0 (cadr #chkL)) 0 3)) 0.001))
;;;02/04/04MH@DEL        (setq #d1 (cadr #chkL))
;;;02/04/04MH@DEL      )
;;;02/04/04MH@DEL      ((and (equal 0 (distance (cadr #chkL) #d0) 0.1)
;;;02/04/04MH@DEL            (equal #jANG (read (angtos (angle #d0 (car #chkL)) 0 3)) 0.001))
;;;02/04/04MH@DEL        (setq #d1 (car #chkL))
;;;02/04/04MH@DEL      )
;;;02/04/04MH@DEL      (t (setq #TEMP$ (cons #chkL #TEMP$)))
;;;02/04/04MH@DEL    ); cond
;;;02/04/04MH@DEL  ); foreach
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL  (if #d1 (setq #LINE$ #TEMP$) (setq #err nil))
;;;02/04/04MH@DEL  ; #d1から直角の線上にある点 #d2
;;;02/04/04MH@DEL  (if #err (setq #d2 (##findPnt #LINE$ #d1)))
;;;02/04/04MH@DEL  ; 基点から基点角度＋直角の線上にある点 #d5
;;;02/04/04MH@DEL  (if #err (setq #d5 (##findPnt #LINE$ #d0)))
;;;02/04/04MH@DEL  ; #d5から直角の線上にある点 #d4
;;;02/04/04MH@DEL  (if #err (setq #d4 (##findPnt #LINE$ #d5)))
;;;02/04/04MH@DEL
;;;02/04/04MH@DEL  ; #d0 #d1 #d2 #d4 #d5 まで取得されていれば新点算出
;;;02/04/04MH@DEL  (if #err
;;;02/04/04MH@DEL    (progn
;;;02/04/04MH@DEL      (setq #d2new (pcpolar #d1 (angle #d1 #d2) (+ (distance #d1 #d2) -26)))
;;;02/04/04MH@DEL      (setq #d4new (pcpolar #d5 (angle #d5 #d4) (+ (distance #d5 #d4) -26)))
;;;02/04/04MH@DEL      (setq #d3new (inters #d2new (pcpolar #d2new (angle #d1 #d0) 100)
;;;02/04/04MH@DEL                           #d4new (pcpolar #d4new (angle #d5 #d0) 100) nil)
;;;02/04/04MH@DEL      ); setq
;;;02/04/04MH@DEL      (setq #dNEW$ (list #d0 #d1 #d2new #d3new #d4new #d5 #d0))
;;;02/04/04MH@DEL    )
;;;02/04/04MH@DEL    ; 点がでていなければ、元の点リストをそのまま返す
;;;02/04/04MH@DEL    (setq #dNEW$ &dAREA$)
;;;02/04/04MH@DEL  )
;;;02/04/04MH@DEL  #dNEW$
;;;02/04/04MH@DEL); PcChgCornerCabD$

;;;02/04/05MH@DEL;<HOM>*************************************************************************
;;;02/04/05MH@DEL; <関数名>    : PcSelItemForFiller
;;;02/04/05MH@DEL; <処理概要>  : ウォール位置にあるアイテムを選択させる
;;;02/04/05MH@DEL; <戻り値>    : 図形名か nil (キャンセルされた場合)
;;;02/04/05MH@DEL; <作成>      : 01/02/02 MH
;;;02/04/05MH@DEL; <備考>      :
;;;02/04/05MH@DEL;*************************************************************************>MOH<
;;;02/04/05MH@DEL(defun PcSelItemForFiller (
;;;02/04/05MH@DEL    &sItem    ; フィラーの名称
;;;02/04/05MH@DEL    &sFLG     ; 高さ取得="H" 設置対象所得"I"
;;;02/04/05MH@DEL    /
;;;02/04/05MH@DEL    #dum$ ;;02/03/29MH@ADD
;;;02/04/05MH@DEL    #en #sMsg #sMsg2 #NEXT$ #eCAB #i #eNT
;;;02/04/05MH@DEL  )
;;;02/04/05MH@DEL  (setq #sMsg2
;;;02/04/05MH@DEL    (cond
;;;02/04/05MH@DEL      ((= "I" &sFLG)
;;;02/04/05MH@DEL        (strcat "\n" &sItem "を設置するキャビネットを選択 ：")) ; 02/03/27 YM MOD ﾌｰﾄﾞは選ばせない
;;;02/04/05MH@DEL;;;02/03/27YM@MOD        (strcat "\n" &sItem "を設置するキャビネットまたはレンジフードを選択 ："))
;;;02/04/05MH@DEL      ((= "H" &sFLG) (strcat "\n" &sItem
;;;02/04/05MH@DEL        "を設置するキャビネットを選択 /Enter=高さ<"             ; 02/03/27 YM MOD ﾌｰﾄﾞは選ばせない
;;;02/04/05MH@DEL;;;02/03/27YM@MOD        "を設置するキャビネットまたはレンジフードを選択 /Enter=高さ<"
;;;02/04/05MH@DEL        (itoa (fix CG_UpCabHeight)) ">："))
;;;02/04/05MH@DEL      (t "")
;;;02/04/05MH@DEL    ); cond
;;;02/04/05MH@DEL  ); setq
;;;02/04/05MH@DEL  (setq #sMsg "設置するキャビネットを選択してください。")
;;;02/04/05MH@DEL  (setq #en 'T)
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  ; 02/03/27 YM ADD-S
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  (command "vpoint""0,0,1") ; 真上からの視点
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  ; 02/03/27 YM ADD-E
;;;02/04/05MH@DEL
;;;02/04/05MH@DEL  (while (and #en (not (= 'ENAME (type #en))))
;;;02/04/05MH@DEL   ; 02/03/27 YM ADD-S
;;;02/04/05MH@DEL   (setq #dum$ (entsel #sMsg2))
;;;02/04/05MH@DEL    (setq #en (car  #dum$))
;;;02/04/05MH@DEL;;;02/03/29YM@DEL    (setq CG_CLICK_PT (cadr #dum$))
;;;02/04/05MH@DEL;;;02/03/29YM@DEL    (setq CG_CLICK_PT (list (car (cadr #dum$)) (cadr (cadr #dum$)) ))
;;;02/04/05MH@DEL   ; 02/03/27 YM ADD-E
;;;02/04/05MH@DEL;;;02/03/27YM@MOD    (setq #en (car (entsel #sMsg2)))
;;;02/04/05MH@DEL    (if #en (progn
;;;02/04/05MH@DEL      (setq #en (SearchGroupSym #en))
;;;02/04/05MH@DEL      (if (or (not #en) (not (= CG_SKK_TWO_UPP (CFGetSymSKKCode #en 2)))) (progn
;;;02/04/05MH@DEL        (CFAlertMsg #sMsg)
;;;02/04/05MH@DEL        (setq #en 'T)
;;;02/04/05MH@DEL      )) ;if progn
;;;02/04/05MH@DEL    )) ;if progn
;;;02/04/05MH@DEL  );while
;;;02/04/05MH@DEL
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  ; 02/03/27 YM ADD-S
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  (command "zoom" "p") ; 視点を元に戻す
;;;02/04/05MH@DEL;;;02/03/29YM@DEL  ; 02/03/27 YM ADD-E
;;;02/04/05MH@DEL
;;;02/04/05MH@DEL  ;;;02/04/05MH@DEL02/03/29MH@ADD
;;;02/04/05MH@DEL  ; マウント型フード"328" が指定されたならばメッセージを出し作業中止
;;;02/04/05MH@DEL  (if (and (= 'ENAME (type #en))
;;;02/04/05MH@DEL           (= 328 (nth 9 (CFGetXData #en "G_LSYM")))
;;;02/04/05MH@DEL      )
;;;02/04/05MH@DEL    (progn
;;;02/04/05MH@DEL      (CFAlertMsg "ﾏｳﾝﾄ型ﾌｰﾄﾞは対象から除外されます\n吊戸をｸﾘｯｸしてください")
;;;02/04/05MH@DEL      (exit)
;;;02/04/05MH@DEL    )
;;;02/04/05MH@DEL  );_if
;;;02/04/05MH@DEL  ;;;02/03/29MH@ADD
;;;02/04/05MH@DEL
;;;02/04/05MH@DEL  ; ダイニングのあるL型対策。基準図形をダイニング以外に移す
;;;02/04/05MH@DEL  (if (and (= 'ENAME (type #en)) (= CG_SKK_THR_DIN (CFGetSymSKKCode #en 3)))(progn
;;;02/04/05MH@DEL    (setq #NEXT$ (PcGetFillerAreaItem$ #en))
;;;02/04/05MH@DEL    (setq #eCAB nil)
;;;02/04/05MH@DEL    (setq #i 0)
;;;02/04/05MH@DEL    (while (and (not #eCAB) (< #i (length #NEXT$)))
;;;02/04/05MH@DEL      (setq #eNT (car (nth #i #NEXT$)))
;;;02/04/05MH@DEL      (if (and (= CG_SKK_ONE_CAB (CFGetSymSKKCode #eNT 1))   ; ｷｬﾋﾞ
;;;02/04/05MH@DEL               (/= CG_SKK_THR_DIN (CFGetSymSKKCode #eNT 3))) ; 非ﾀﾞｲﾆﾝｸﾞ
;;;02/04/05MH@DEL        (setq #eCAB #eNT)
;;;02/04/05MH@DEL      )
;;;02/04/05MH@DEL      (setq #i (1+ #i))
;;;02/04/05MH@DEL    ); while
;;;02/04/05MH@DEL    (setq #en (if #eCAB #eCAB #en))
;;;02/04/05MH@DEL  )); if progn
;;;02/04/05MH@DEL  #en
;;;02/04/05MH@DEL);PcSelItemForFiller

;;;02/04/08MH@MOD;<HOM>*************************************************************************
;;;02/04/08MH@MOD; <関数名>    : PcGetFilerOfsP&PL$
;;;02/04/08MH@MOD; <処理概要>  : フィラー領域全図形名と領域点列からフィラー作図線リスト作成
;;;02/04/08MH@MOD; <戻り値>    : ((ofs点  (P線点)) (ofs点  (P線点))･･･)
;;;02/04/08MH@MOD; <作成>      : 00-10-04 MH
;;;02/04/08MH@MOD; <備考>      : P線点リストの頭と最後が同点の場合、閉じたP線であると判断させる
;;;02/04/08MH@MOD;*************************************************************************>MOH<
;;;02/04/08MH@MOD(defun PcGetFilerOfsP&PL$ (
;;;02/04/08MH@MOD  &eCAB       ; 基準とするウォールキャビの図形名(センター用かどうかの判定用)
;;;02/04/08MH@MOD  &NEXT$      ; (図形名 (外形線P点)) (図形名 (外形線P点))･･･)
;;;02/04/08MH@MOD  &fOF        ; オフセット値
;;;02/04/08MH@MOD  &PLNFLG     ; プラン検索から起動されたなら'T  フリー設計ならnil
;;;02/04/08MH@MOD  /
;;;02/04/08MH@MOD  #NEXT$ #baseXD$ #bsP #bsANG #BchkANG #SIDE_L #SIDE_R #LR #NT_regn #NT$ #r-ss
;;;02/04/08MH@MOD  #dPL$ #revFLG #chkL$ #LINEall$ #i #BchkANG  #chkL$ #cL #revFLG #revFLG #eCNR$
;;;02/04/08MH@MOD  #backPL$ #backL #ofsP #resPL$ #centerF #TEMP$ #ofP&PL$ #XD$ #ANG #eCNR$ #eNT #eCAB
;;;02/04/08MH@MOD  #jANG #sLR$ #chkANG #LFRpt$;00/10/25 SN ADD
;;;02/04/08MH@MOD  #BACKL$ #BCLP #BCRP #DBCPL$ #RESBCPL$ #STOPFLG ;02/03/29MH@MOD
;;;02/04/08MH@MOD  #DUMPT$ #OUTPLINE #OUTPLINE$ #R-SS-LINE #REGION ; 02/03/27 YM ADD
;;;02/04/08MH@MOD  )
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ;; U型 L型の共通部
;;;02/04/08MH@MOD  (defun ##GetLUofP&PL ( &dPL$ &fOF &eCNR$ &sLR$ / ##BSP ##dPL$ ##ofsP ##XD$ ##XLD$)
;;;02/04/08MH@MOD    (setq ##dPL$ &dPL$)
;;;02/04/08MH@MOD    (setq ##XD$ (CFGetXData (last &eCNR$) "G_SYM"))
;;;02/04/08MH@MOD    (setq ##XLD$ (CFGetXData (last &eCNR$) "G_LSYM"))
;;;02/04/08MH@MOD    ;; 02/03/29MH@MOD 基点をLSYMから取っていたので変更
;;;02/04/08MH@MOD    (setq ##BSP (cdr (assoc 10 (entget (last &eCNR$)))))
;;;02/04/08MH@MOD    ;;02/03/29MH@DEL(setq ##BSP (cadr ##XLD$))
;;;02/04/08MH@MOD    (setq ##BSP (list (car ##BSP) (cadr ##BSP)))
;;;02/04/08MH@MOD    ; コーナーとしてダイニングキャビが渡ってきた場合の基点移動
;;;02/04/08MH@MOD    (if (= CG_SKK_THR_DIN (CFGetSymSKKCode (last &eCNR$) 3))(progn
;;;02/04/08MH@MOD      (setq ##BSP (Pcpolar ##BSP (- (nth 2 ##XLD$) (* 0.5 pi)) (- (nth 4 ##XD$) 26)))
;;;02/04/08MH@MOD      (if (= "R" (last &sLR$)) ; 右だった
;;;02/04/08MH@MOD        (setq ##BSP (Pcpolar ##BSP (nth 2 ##XLD$) (nth 3 ##XD$)))
;;;02/04/08MH@MOD      ); if
;;;02/04/08MH@MOD    )); if progn
;;;02/04/08MH@MOD    ; 閉じた外形領域点列を隅用キャビの基点が頭にくるよう並べ替え
;;;02/04/08MH@MOD    (setq ##dPL$ (PcOrderPL$byOneP ##dPL$ ##BSP))
;;;02/04/08MH@MOD    ; 隅用キャビの基点を抜いて、開いた正面線点リストに加工
;;;02/04/08MH@MOD    (repeat (length &eCNR$) (setq ##dPL$ (cdr ##dPL$)))
;;;02/04/08MH@MOD    ; オフセット点取得 (AutoCadのバグなのか、元線の仮想交点をオフセット点に
;;;02/04/08MH@MOD    ; すると逆方向に実行される｡ 元線に近いオフセット基点しかダメ)
;;;02/04/08MH@MOD    (setq ##ofsP (pcpolar (car ##dPL$) (angle (car ##dPL$) (cadr ##dPL$))
;;;02/04/08MH@MOD      (* 0.5 (distance (car ##dPL$) (cadr ##dPL$)))))
;;;02/04/08MH@MOD    (setq ##ofsP (pcpolar ##ofsP (angle (cadr ##dPL$) (caddr ##dPL$))
;;;02/04/08MH@MOD      (* 0.5 (distance (cadr ##dPL$) (caddr ##dPL$)))))
;;;02/04/08MH@MOD    ; ポリラインオフセット処理
;;;02/04/08MH@MOD    (setq ##dPL$ (PcOffsetFilerPL$ ##dPL$ ##ofsP &fOF &eCNR$ nil))
;;;02/04/08MH@MOD    ; 側面左右フラグをみてオフセット&除去
;;;02/04/08MH@MOD    (setq ##dPL$ (PcPL$SidePart ##dPL$ &fOF))
;;;02/04/08MH@MOD    ; 結果を返す
;;;02/04/08MH@MOD    (list (list ##ofsP ##dPL$))
;;;02/04/08MH@MOD  ); ##GetLUofP&PL
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; チェック対象図形が隅配置のダイニングキャビならば 'T
;;;02/04/08MH@MOD  (defun ##ChkCornerDinning (&eCHK &NEXT$ / #FLG #eBF #eBF$ )
;;;02/04/08MH@MOD    (setq #FLG nil)
;;;02/04/08MH@MOD    (cond
;;;02/04/08MH@MOD      ((/= CG_SKK_THR_DIN (CFGetSymSKKCode &eCHK 3)) (setq #FLG nil)); ﾀﾞｲﾆﾝｸﾞ用か
;;;02/04/08MH@MOD      ; 図形 前後の隣接が基準角度でなおかつダイニング以外
;;;02/04/08MH@MOD      (t (setq #eBF$ (PcGetEn$CrossArea &eCHK -5 -5 0 0 'T)) ; 図形の前後の図形名摘出
;;;02/04/08MH@MOD         (foreach #eBF #eBF$ (if (assoc #eBF &NEXT$) (setq #FLG 'T))); 隣接リスト中にある？
;;;02/04/08MH@MOD      )
;;;02/04/08MH@MOD    ); cond
;;;02/04/08MH@MOD    #FLG
;;;02/04/08MH@MOD  ); defun
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; 共通で利用する基準図形の情報
;;;02/04/08MH@MOD  (setq #NEXT$ &NEXT$)
;;;02/04/08MH@MOD  (setq #baseXD$ (CFGetXData &eCAB "G_LSYM"))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ;; 02/03/29MH@MOD 基点をLSYMから取っていたので変更
;;;02/04/08MH@MOD  (setq #bsP (cdr (assoc 10 (entget &eCAB))))
;;;02/04/08MH@MOD  (setq #bsP (list (car #bsP) (cadr #bsP)))
;;;02/04/08MH@MOD  ;;02/03/29MH@DEL (setq #bsP (list (car (cadr #baseXD$)) (cadr (cadr #baseXD$))))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  (setq #bsANG (nth 2 #baseXD$))
;;;02/04/08MH@MOD  (setq #BchkANG (read (angtos #bsANG 0 3)))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD; PosUpFiler の書き換えに伴う 01/12/17 YM DEL-S --------------------------------------------
;;;02/04/08MH@MOD;;;01/12/17YM@DEL  ; 奥行き側面部の有無
;;;02/04/08MH@MOD;;;01/12/17YM@DEL  (if (not &PLNFLG) (progn
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    ; フリー設計からだったらユーザーから左右の有無を求める 01/04/04 背面指定可能に変更
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (setq #SIDE_L SKW_FILLER_LSIDE)
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (setq #SIDE_R SKW_FILLER_RSIDE)
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (if (not (setq #BLR (PcGetFilerBLRDlg))) (progn (command "_Undo" "B") (exit)))
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (setq SKW_FILLER_BSIDE (if (car #BLR) 1 0))
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (setq SKW_FILLER_LSIDE (if (cadr #BLR) 1 0))
;;;02/04/08MH@MOD;;;01/12/17YM@DEL    (setq SKW_FILLER_RSIDE (if (caddr #BLR) 1 0))
;;;02/04/08MH@MOD;;;01/12/17YM@DEL  )); if progn
;;;02/04/08MH@MOD; PosUpFiler の書き換えに伴う 01/12/17 YM DEL-E --------------------------------------------
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; 全隣接図形の外形線をリージョン化
;;;02/04/08MH@MOD  (setq #NT_regn (ssadd))
;;;02/04/08MH@MOD  (foreach #NT$ &NEXT$
;;;02/04/08MH@MOD    (MakeLwPolyLine (cadr #NT$) 1 0)
;;;02/04/08MH@MOD    (command "_region" (entlast) "")
;;;02/04/08MH@MOD    (ssadd (entlast) #NT_regn)
;;;02/04/08MH@MOD  ); foreach
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; リージョンが1ケ以上なら結合して一つにする
;;;02/04/08MH@MOD  (if (< 1 (sslength #NT_regn)) (command "_union" #NT_regn ""))
;;;02/04/08MH@MOD  ; REGIONを分解し、分解した線分をポリライン化する
;;;02/04/08MH@MOD  (command "_explode" (entlast))
;;;02/04/08MH@MOD  (setq #r-ss (ssget "P"))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  ; 02/03/25 YM ADD-S マウント型ﾌｰﾄﾞ除外処理のｴﾗｰ処理
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  (setq #OutPline$ nil) ; 外形PLINEのﾘｽﾄ
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  (if (and #r-ss (< 0 (sslength #r-ss))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL           (= "REGION" (cdr (assoc 0 (entget (ssname #r-ss 0))))))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    (progn ; "REGION"が含まれていた
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (setq #i 0)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (repeat (sslength #r-ss)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #region (ssname #r-ss #i))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (command "_explode" #region)  ; 各REGIONを分解
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #r-ss-line (ssget "P")) ;LINEの選択ｾｯﾄ
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (command "_pedit" (entlast) "Y" "J" #r-ss-line "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了 PLINE化
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #OutPline$ (append #OutPline$ (list (entlast))))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #i (1+ #i))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL;;;02/03/27YM@DEL     (CFAlertMsg "このｷｬﾋﾞﾈｯﾄ配列では天井ﾌｨﾗｰを自動生成できません.\n(ﾏｳﾝﾄ型ﾌｰﾄﾞは対象から除外されます)")
;;;02/04/08MH@MOD;;;02/03/29YM@DEL;;;02/03/27YM@DEL     (exit)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  );_if
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  ; 02/03/25 YM ADD-E
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  ; 02/03/27 YM MOD-S if文で分岐
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  (if #OutPline$
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    (progn
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      ; CG_CLICK_PT が含まれる領域の方に天井ﾌｨﾗｰを貼る
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (command "vpoint" "0,0,1") ; 真上からの視点
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (foreach OutPline #OutPline$
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (command "_offset" 50 OutPline '(99999 99999) "") ; PLINEを少し大きくする
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #dum_PLINE (entlast))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #dumPT$ (GetLWPolyLinePt #dum_PLINE))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (setq #dumPT$ (AddPtList #dumPT$)) ; 末尾に始点を追加する
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (if (JudgeNaigai CG_CLICK_PT #dumPT$)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL          (progn
;;;02/04/08MH@MOD;;;02/03/29YM@DEL            (setq #OutPline OutPline) ; こちらの領域に天井ﾌｨﾗｰを貼る
;;;02/04/08MH@MOD;;;02/03/29YM@DEL          )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL          (entdel OutPline)           ; こちらの領域に天井ﾌｨﾗｰを貼らないのでPLINEを削除する
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        );_if
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (entdel #dum_PLINE)           ; ｵﾌｾｯﾄしたPLINEを削除する
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (if (= nil #OutPline)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        (progn
;;;02/04/08MH@MOD;;;02/03/29YM@DEL;;;02/03/27YM@MOD         (CFAlertMsg "このｷｬﾋﾞﾈｯﾄ配列では天井ﾌｨﾗｰを自動生成できません.\n(ﾏｳﾝﾄ型ﾌｰﾄﾞは対象から除外されます)")
;;;02/04/08MH@MOD;;;02/03/29YM@DEL          (CFAlertMsg "ﾏｳﾝﾄ型ﾌｰﾄﾞは対象から除外されます\n吊戸をｸﾘｯｸしてください")
;;;02/04/08MH@MOD;;;02/03/29YM@DEL          (exit)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL        )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      );_if
;;;02/04/08MH@MOD;;;02/03/29YM@DEL
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (command "zoom" "p") ; 視点を元に戻す
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (setq CG_CLICK_PT nil)
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    (progn ; 今までどおり
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
;;;02/04/08MH@MOD;;;02/03/29YM@DEL      (setq #OutPline (entlast))
;;;02/04/08MH@MOD;;;02/03/29YM@DEL    )
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  );_if
;;;02/04/08MH@MOD;;;02/03/29YM@DEL  ; 02/03/27 YM MOD-E if文で分岐
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD ; 02/03/29 YM MOD-S もとに戻した
;;;02/04/08MH@MOD  (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
;;;02/04/08MH@MOD  (setq #OutPline (entlast))
;;;02/04/08MH@MOD ; 02/03/29 YM MOD-E
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; 全外形領域点列を求める
;;;02/04/08MH@MOD  (setq #dPL$ (GetLWPolyLinePt #OutPline))
;;;02/04/08MH@MOD  (entdel #OutPline )
;;;02/04/08MH@MOD  ; 点順列を左→右にするため、線の角度が基準図形角度と同じなら全外形領域点列リバース
;;;02/04/08MH@MOD  (setq #i 0)
;;;02/04/08MH@MOD  (setq #revFLG nil)
;;;02/04/08MH@MOD  (setq #chkL$ nil)
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  (setq #LINEall$ (PcMkLine$byPL$ #dPL$ 'T)) ; バラ線リストに変換
;;;02/04/08MH@MOD  (while (and (not #chkL$) (< #i (length #LINEall$)))
;;;02/04/08MH@MOD    (setq #cL (nth #i #LINEall$))
;;;02/04/08MH@MOD    ; 基準キャビの基点上にあり、角度が同じか180度逆の線を摘出
;;;02/04/08MH@MOD    (if (PcIsExistPOnLine #cL (list #bsP))
;;;02/04/08MH@MOD      (cond
;;;02/04/08MH@MOD        ((equal #BchkANG (read (angtos (angle (car #cL) (cadr #cL)) 0 3)) 0.01)
;;;02/04/08MH@MOD          (setq #chkL$ #cL)
;;;02/04/08MH@MOD          (setq #revFLG 'T)
;;;02/04/08MH@MOD        )
;;;02/04/08MH@MOD        ((equal #BchkANG (read (angtos (angle (cadr #cL) (car #cL)) 0 3)) 0.01)
;;;02/04/08MH@MOD          (setq #chkL$ #cL)
;;;02/04/08MH@MOD        )
;;;02/04/08MH@MOD        (t nil)
;;;02/04/08MH@MOD      ); cond
;;;02/04/08MH@MOD    ); if
;;;02/04/08MH@MOD    (setq #i (1+ #i))
;;;02/04/08MH@MOD  ); while
;;;02/04/08MH@MOD  ; 線の角度が基準図形角度と同じなら全外形領域点列リバース
;;;02/04/08MH@MOD  (if #revFLG (setq #dPL$ (reverse #dPL$)))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; 隣接図形リスト中から、隅用キャビを摘出 #eCNR$
;;;02/04/08MH@MOD  (setq #jANG (read (angtos (nth 2 (CFGetXData &eCAB "G_LSYM")) 0 3)))
;;;02/04/08MH@MOD  (setq #eCNR$ nil)
;;;02/04/08MH@MOD  (setq #sLR$ nil)
;;;02/04/08MH@MOD  (foreach #NT$ #NEXT$
;;;02/04/08MH@MOD    (setq #eNT (car #NT$))
;;;02/04/08MH@MOD    (setq #chkANG (nth 2 (CFGetXData #eNT "G_LSYM")))
;;;02/04/08MH@MOD    (if (or
;;;02/04/08MH@MOD      (and (= CG_SKK_THR_CNR (CFGetSymSKKCode #eNT 3)); ｺｰﾅｰｷｬﾋﾞ
;;;02/04/08MH@MOD           (not (member #eNT #eCNR$)))
;;;02/04/08MH@MOD      (and (not (equal #jANG (atof (angtos #chkANG 0 3)) 0.1)) ; 基準角度と異なる
;;;02/04/08MH@MOD           (not (member #eNT #eCNR$))
;;;02/04/08MH@MOD           (##ChkCornerDinning #eNT #NEXT$); 図形前後の隣接に基準角度の図形がある
;;;02/04/08MH@MOD      ); and
;;;02/04/08MH@MOD        ); or
;;;02/04/08MH@MOD      (progn
;;;02/04/08MH@MOD        (setq #eCNR$ (cons #eNT #eCNR$))
;;;02/04/08MH@MOD        (if (and (= CG_SKK_THR_DIN (CFGetSymSKKCode #eNT 3))
;;;02/04/08MH@MOD                 (equal #jANG (atof (angtos (+ #chkANG (* -0.5 pi)) 0 3)) 0.001))
;;;02/04/08MH@MOD          (setq #sLR$ (cons "R" #sLR$))
;;;02/04/08MH@MOD          (setq #sLR$ (cons "L" #sLR$))
;;;02/04/08MH@MOD        ); if
;;;02/04/08MH@MOD      ); progn
;;;02/04/08MH@MOD    ); if
;;;02/04/08MH@MOD  ); foreach
;;;02/04/08MH@MOD  (if (< 2 (length #eCNR$)) (progn
;;;02/04/08MH@MOD    (CFAlertMsg "対象領域に隅用ウォールキャビネットが2つ以上検出されました") (exit))
;;;02/04/08MH@MOD  ); if
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD  ; オフセット点とポリ点リストを作成 #ofP&PL$
;;;02/04/08MH@MOD  (cond
;;;02/04/08MH@MOD    ; Ｉ型 (隅用キャビなし)
;;;02/04/08MH@MOD    ((not #eCNR$)
;;;02/04/08MH@MOD      ; 背面線取得
;;;02/04/08MH@MOD      (setq #i 0)
;;;02/04/08MH@MOD      (setq #backL$ nil)
;;;02/04/08MH@MOD      (setq #LINEall$ (PcMkLine$byPL$ #dPL$ 'T)) ; バラ線リストに変換
;;;02/04/08MH@MOD      (while (< #i (length #LINEall$))
;;;02/04/08MH@MOD        (setq #cL (nth #i #LINEall$))
;;;02/04/08MH@MOD        ; 角度が基準図形とは180度逆向きの線が背面線(複数取得)
;;;02/04/08MH@MOD        (if (equal #BchkANG (read (angtos (angle (cadr #cL) (car #cL)) 0 3)) 0.01)
;;;02/04/08MH@MOD          (setq #backPL$ (cons #cL #backPL$))) ;if
;;;02/04/08MH@MOD        (setq #i (1+ #i))
;;;02/04/08MH@MOD      ); while
;;;02/04/08MH@MOD      ;; センターキャビには前面合わせの場合有。
;;;02/04/08MH@MOD      ;; 全体を、背面パートと前面パートに分ける
;;;02/04/08MH@MOD      ; 背面リスト#backPL$中の 最左点 と最右点で 分ける
;;;02/04/08MH@MOD      (setq #bcLP (PcGetSidePinPL$ #backPL$ #bsANG "L")) ; #backPL$中の 最左点
;;;02/04/08MH@MOD      (setq #bcRP (PcGetSidePinPL$ #backPL$ #bsANG "R")) ; #backPL$中の 最右点
;;;02/04/08MH@MOD      ; 閉じた外形領域点列 #dPL$ を 背面線中の最左点が頭にくるよう並べ替える
;;;02/04/08MH@MOD      (setq #dPL$ (PcOrderPL$byOneP #dPL$ #bcLP))
;;;02/04/08MH@MOD      ; #dBCPL$ 背面パート
;;;02/04/08MH@MOD      (setq #TEMP$ #dPL$)
;;;02/04/08MH@MOD      (while (and (car #TEMP$) (not (equal #bcRP (car #TEMP$) 0.01)))
;;;02/04/08MH@MOD        (setq #TEMP$ (cdr #TEMP$))
;;;02/04/08MH@MOD      ); while
;;;02/04/08MH@MOD      (setq #dBCPL$ (append #TEMP$ (list (car #dPL$))))
;;;02/04/08MH@MOD      ; #dPL$ = 前面パート
;;;02/04/08MH@MOD      (setq #i 0)
;;;02/04/08MH@MOD      (setq #TEMP$ nil)
;;;02/04/08MH@MOD      (setq #stopFLG nil)
;;;02/04/08MH@MOD      (while (and (not #stopFLG) (< #i (length #dPL$)))
;;;02/04/08MH@MOD        (setq #TEMP$ (append #TEMP$ (list (nth #i #dPL$))))
;;;02/04/08MH@MOD        (if (equal #bcRP (nth #i #dPL$) 0.01) (setq #stopFLG 'T))
;;;02/04/08MH@MOD        (setq #i (1+ #i))
;;;02/04/08MH@MOD      ); while
;;;02/04/08MH@MOD      (setq #dPL$ #TEMP$)
;;;02/04/08MH@MOD      ; Ｉ型共通オフセット点：全体の中央
;;;02/04/08MH@MOD      (setq #ofsP (Pcpolar (car #dPL$) (angle (car #dPL$) (last #dPL$))
;;;02/04/08MH@MOD        (* 0.5 (distance (car #dPL$) (last #dPL$)))))
;;;02/04/08MH@MOD      (setq #ofsP (Pcpolar #ofsP (+ #bsANG (* -0.5 pi))
;;;02/04/08MH@MOD        (* 0.5 (nth 4 (CFGetXData &eCAB "G_SYM")))))
;;;02/04/08MH@MOD      ; 基準がセンター用かどうかのフラグ。センター用= 'T
;;;02/04/08MH@MOD      (setq #centerF (= 1 SKW_FILLER_BSIDE)) ;01/04/04 背面指定可能に変更
;;;02/04/08MH@MOD      ; センター用なら、背面オフセット処理
;;;02/04/08MH@MOD      (if #centerF (setq #resBCPL$ (PcOffsetFilerBCPL$ #dBCPL$ #ofsP &fOF #bsANG)))
;;;02/04/08MH@MOD      ;010204MHDEL(setq #centerF (PcChkCenterUpper &eCAB))
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD      ;ポリライン前面オフセット処理
;;;02/04/08MH@MOD      (setq #resPL$ (PcOffsetFilerPL$ #dPL$ #ofsP &fOF nil nil))
;;;02/04/08MH@MOD      (setq #ofP&PL$ nil)
;;;02/04/08MH@MOD      (cond
;;;02/04/08MH@MOD        ; 側面左右なし
;;;02/04/08MH@MOD        ((= 0 (+ SKW_FILLER_LSIDE SKW_FILLER_RSIDE))
;;;02/04/08MH@MOD          ; センター用だった（正面と背面でリストが２つ必要）
;;;02/04/08MH@MOD          (if #centerF (setq #ofP&PL$ (list (list #ofsP #resBCPL$)))); 背面リスト取得
;;;02/04/08MH@MOD          ; Ｐ点リストから左右側壁点削除
;;;02/04/08MH@MOD          (setq #i 1)
;;;02/04/08MH@MOD          (setq #TEMP$ nil)
;;;02/04/08MH@MOD          (while (< #i (1- (length #resPL$)))
;;;02/04/08MH@MOD            (setq #TEMP$ (append #TEMP$ (list (nth #i #resPL$))))
;;;02/04/08MH@MOD            (setq #i (1+ #i))
;;;02/04/08MH@MOD          ); while
;;;02/04/08MH@MOD          (setq #resPL$ #TEMP$)
;;;02/04/08MH@MOD          ; 結果に正面リストをセット
;;;02/04/08MH@MOD          (setq #ofP&PL$ (cons (list #ofsP #resPL$) #ofP&PL$))
;;;02/04/08MH@MOD        ) ; 側面左右なし
;;;02/04/08MH@MOD        (t
;;;02/04/08MH@MOD          ; 側面左右フラグをみて側面部のオフセット&除去処理
;;;02/04/08MH@MOD          (setq #resPL$ (PcPL$SidePart #resPL$ &fOF))
;;;02/04/08MH@MOD          ;(if #resBCPL$ (setq #resBCPL$ (PcPL$SidePart2 #bsANG #resBCPL$ &fOF)))
;;;02/04/08MH@MOD          (setq #LFRpt$ #resPL$);00/10/25 SN ADD 左奥-前部-右奥の順に並んだと想定した点ﾘｽﾄ
;;;02/04/08MH@MOD          ; センター用であった場合の背面点追加
;;;02/04/08MH@MOD          (if #centerF
;;;02/04/08MH@MOD            (cond
;;;02/04/08MH@MOD              ; 左側面のみだった
;;;02/04/08MH@MOD              ((= 0 SKW_FILLER_RSIDE)
;;;02/04/08MH@MOD                (setq #resPL$ (append (reverse (cdr (reverse #resBCPL$))) #resPL$)))
;;;02/04/08MH@MOD              ; 右側面のみ、あるいは 左右側面ともにある
;;;02/04/08MH@MOD              (t (setq #resPL$ (append #resPL$ (cdr #resBCPL$)))); t
;;;02/04/08MH@MOD            ); cond
;;;02/04/08MH@MOD          ); if センター
;;;02/04/08MH@MOD          ; 結果をセット
;;;02/04/08MH@MOD          (setq #ofP&PL$ (list (list #ofsP #resPL$)))
;;;02/04/08MH@MOD        ) ; 側面あり
;;;02/04/08MH@MOD      ); cond
;;;02/04/08MH@MOD    ); Ｉ
;;;02/04/08MH@MOD    ; Ｌ型 (隅用キャビの数 １)
;;;02/04/08MH@MOD    ((= 1 (length #eCNR$))
;;;02/04/08MH@MOD      (setq #ofP&PL$ (##GetLUofP&PL #dPL$ &fOF #eCNR$ #sLR$))
;;;02/04/08MH@MOD      (setq #LFRpt$ (car (cdr (car #ofP&PL$))));00/10/25 SN ADD 左奥-前部-右奥の順に並んだと想定した点ﾘｽﾄ
;;;02/04/08MH@MOD    ); Ｌ
;;;02/04/08MH@MOD    ; Ｕ型 (隅用キャビの数 ２)
;;;02/04/08MH@MOD    ((= 2 (length #eCNR$))
;;;02/04/08MH@MOD     ; #eCNR$ 向かって左側に位置するキャビが一つ目にくるよう並べ替え
;;;02/04/08MH@MOD      (setq #XD$ (CFGetXData (cadr #eCNR$) "G_LSYM"))
;;;02/04/08MH@MOD     ; 02/03/29MH@MOD 基点をLSYMから取っていたので変更
;;;02/04/08MH@MOD      (setq #bsP (cdr (assoc 10 (entget (cadr #eCNR$)))))
;;;02/04/08MH@MOD      (setq #bsP (list (car #bsP) (cadr #bsP)))
;;;02/04/08MH@MOD     ; 二つ目のキャビの基点から設置角度の延長線上に一つ目のキャビ基点が
;;;02/04/08MH@MOD     ; あれば順番を入れ替える
;;;02/04/08MH@MOD     (if (PcIsExistPOnLine (list #bsP (Pcpolar #bsP (nth 2 #XD$) 10000))
;;;02/04/08MH@MOD            (list (cdr (assoc 10 (entget (car #eCNR$))))))
;;;02/04/08MH@MOD        (setq #eCNR$ (list (cadr #eCNR$)(car #eCNR$)))
;;;02/04/08MH@MOD      ); if
;;;02/04/08MH@MOD     ;;02/03/29MH@DEL (setq #bsP (list (car (cadr #XD$)) (cadr (cadr #XD$))))
;;;02/04/08MH@MOD     ;;02/03/29MH@DEL (if (PcIsExistPOnLine (list #bsP (Pcpolar #bsP (nth 2 #XD$) 10000))
;;;02/04/08MH@MOD     ;;02/03/29MH@DEL       (list (cadr (CFGetXData (car #eCNR$) "G_LSYM"))))
;;;02/04/08MH@MOD     ;;02/03/29MH@DEL   (setq #eCNR$ (list (cadr #eCNR$)(car #eCNR$)))
;;;02/04/08MH@MOD     ;;02/03/29MH@DEL ); if
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD     (setq #ofP&PL$ (##GetLUofP&PL #dPL$ &fOF #eCNR$ #sLR$))
;;;02/04/08MH@MOD      (setq #LFRpt$ (car (cdr (car #ofP&PL$))));00/10/25 SN ADD 左奥-前部-右奥の順に並んだと想定した点ﾘｽﾄ
;;;02/04/08MH@MOD    ); Ｕ
;;;02/04/08MH@MOD  ); cond
;;;02/04/08MH@MOD  ; 00/10/25 SN S-ADD 奥行処理の長さを取得する。
;;;02/04/08MH@MOD  (if (= SKW_FILLER_LSIDE 1);左奥行処理あり
;;;02/04/08MH@MOD    ; THEN 点ﾘｽﾄの先頭２点を左奥行処理の長さとする。
;;;02/04/08MH@MOD    (setq SKW_FILLER_LLEN
;;;02/04/08MH@MOD      (distance (car #LFRpt$) (cadr #LFRpt$))
;;;02/04/08MH@MOD    )
;;;02/04/08MH@MOD    ; ELSE なければ0
;;;02/04/08MH@MOD    (setq SKW_FILLER_LLEN 0.0)
;;;02/04/08MH@MOD  );end if
;;;02/04/08MH@MOD  (if (= SKW_FILLER_RSIDE 1);右奥行処理あり
;;;02/04/08MH@MOD    ; THEN 点ﾘｽﾄの後尾２点を右奥行処理の長さとする。
;;;02/04/08MH@MOD    (setq SKW_FILLER_RLEN
;;;02/04/08MH@MOD      ;最後尾の２点間を奥行とする。
;;;02/04/08MH@MOD      (distance (nth (- (length #LFRpt$) 2) #LFRpt$) (nth (- (length #LFRpt$) 1) #LFRpt$))
;;;02/04/08MH@MOD    )
;;;02/04/08MH@MOD    ; ELSE なければ0
;;;02/04/08MH@MOD    (setq SKW_FILLER_RLEN 0.0)
;;;02/04/08MH@MOD  );end if
;;;02/04/08MH@MOD  ; 00/10/25 SN E-ADD 奥行処理の長さを取得する。
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD;;;01/12/19YM@MOD  (if (not &PLNFLG) (progn
;;;02/04/08MH@MOD;;;01/12/19YM@MOD    (setq SKW_FILLER_LSIDE #SIDE_L) ;グローバルを戻す
;;;02/04/08MH@MOD;;;01/12/19YM@MOD    (setq SKW_FILLER_RSIDE #SIDE_R) ;グローバルを戻す
;;;02/04/08MH@MOD;;;01/12/19YM@MOD  )); if progn
;;;02/04/08MH@MOD
;;;02/04/08MH@MOD ; 01/12/19 YM MOD-S
;;;02/04/08MH@MOD (setq SKW_FILLER_LSIDE 0) ; 元に戻す
;;;02/04/08MH@MOD (setq SKW_FILLER_RSIDE 0) ; 元に戻す
;;;02/04/08MH@MOD ; 01/12/19 YM MOD-S
;;;02/04/08MH@MOD(setq ##ofP&PL$ #ofP&PL$)
;;;02/04/08MH@MOD  #ofP&PL$
;;;02/04/08MH@MOD); PcGetFilerOfsP&PL$

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KP_SETFilerKOSU
;;; <処理概要>  : 天井ﾌｨﾗｰ個数入力
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 02/11/10 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KP_SETFilerKOSU (
  /
  #FILER #HINBAN #KOSU #KOSU_NEW #LOOP #RET #XD$ #XDOPT$ #DUM #DUM$ #I #LIS$ #OPT_OLD$
;-- 2011/08/11 A.Satoh Add - S
  #syokei #ret$
;-- 2011/08/11 A.Satoh Add - E
  )

  ;// コマンドの初期化
  (StartUndoErr)
  (CFCmdDefBegin 6);00/09/26 SN ADD

  ;// 天井フィラーの指示
  (setq #xd$ nil)
  (setq #loop T)
  (while #loop
    (setq #Filer (car (entsel "\n天井フィラーを選択: ")))
    (if #Filer
      (setq #xd$ (CFGetXData #Filer "G_FILR"))
      (setq #xd$ nil)
    );_if

    (if (= #xd$ nil)
      (CFAlertMsg "天井フィラーではありません。")
      (setq #loop nil)
    );_if
  );while

;-- 2011/08/11 A.Satoh Add - S
  (setq #syokei (nth 7 #xd$))
;-- 2011/08/11 A.Satoh Add - E

  ; Xdata regapp
  (if (= (tblsearch "APPID" "G_OPT") nil) (regapp "G_OPT"))

  (setq #HINBAN (nth 0 #xd$)) ; 天井ﾌｨﾗｰ品番
  (setq #xdOPT$ (CFGetXData #Filer "G_OPT")) ; 既存のｾｯﾄ個数
;;;(-3 (G_OPT (1070 . 1) (1000 . SDKA105SCK) (1070 . 1))

  (setq #lis$ (cdr #xdOPT$)) ; 品番1,個数1,品番2,個数2,...のﾘｽﾄ
  (setq #opt_old$ nil)       ; (品番1,個数1)(品番2,個数2),...
  (setq #i 0)
  (foreach #lis #lis$
    ; 品番,個数,品番,個数,...の順番
    (if (= 0 (rem #i 2))
      (setq #dum #lis)
      (setq #opt_old$ (append #opt_old$ (list (list #dum #lis))))
    );_if
    (setq #i (1+ #i))
  );foreach

  (if #xdOPT$
    (progn
      (setq #dum$ (assoc #hinban #opt_old$))
      (if #dum$
        (setq #KOSU (1+ (cadr #dum$))) ; 個数を取得
      ; else
        (setq #KOSU 1) ; 個数取得できない
      );_if
    )
    (progn
      (setq #KOSU 1)
    )
  );_if

  ; 個数入力画面表示
;-- 2011/08/11 A.Satoh Mod - S
;  (setq #ret (KPGetFilerKOSUDlg #Hinban #KOSU)) ; 必要合計個数
  (setq #ret$ (KPGetFilerKOSUDlg #Hinban #KOSU #syokei))
;-- 2011/08/11 A.Satoh Mod - E

;-- 2011/08/11 A.Satoh Mod - S
;  (if (and #ret (/= #ret #KOSU))
;    (progn ; 個数更新が必要
;      (setq #KOSU_new (1- #ret))
;      ;;; PcSetOpt$G_OPT (図形,内容ﾘｽﾄ) 内容ﾘｽﾄ=((品番  数) (品番  数) (品番  数)…)
;      (SetOpt #Filer (list (list #Hinban #KOSU_new)))
;      (princ "\n天井ﾌｨﾗｰの個数を変更しました。")
;    )
;  ; else
;    (princ "\n天井ﾌｨﾗｰの個数を変更しませんでした。")
;  );_if
  (if #ret$
    (progn
      (CFSetXData #Filer "G_FILR"
        (list
          (nth 0 #xd$)  ; 品番
          (nth 1 #xd$)  ; 画層
          (nth 2 #xd$)  ; PLINEハンドル
          (nth 3 #xd$)  ; 固定値
          (nth 4 #xd$)  ; 固定値
          (nth 5 #xd$)  ; 左サイドの長さ
          (nth 6 #xd$)  ; 右サイドの長さ
          (nth 1 #ret$) ; 小計分類
        )
      )

      (if (/= (nth 0 #ret$) #KOSU)
        (progn ; 個数更新が必要
          (setq #KOSU_new (1- (nth 0 #ret$)))
          ;;; PcSetOpt$G_OPT (図形,内容ﾘｽﾄ) 内容ﾘｽﾄ=((品番  数) (品番  数) (品番  数)…)
          (SetOpt #Filer (list (list #Hinban #KOSU_new)))
          (princ "\n天井ﾌｨﾗｰの個数を変更しました。")
        )
      ; else
        (princ "\n天井ﾌｨﾗｰの個数を変更しませんでした。")
      );_if
    )
  )
;-- 2011/08/11 A.Satoh Mod - E


  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)

);C:KP_SETFilerKOSU

;<HOM>*************************************************************************
; <関数名>    : SetOpt
; <処理概要>  : 渡されたリストの内容を"G_OPT"に追加/削除/または新規設置する
; <戻り値>    : なし
; <作成>      : 02/11/11 YM
; <備考>      : リスト形式 ((品番  数) (品番  数) (品番  数)…)
;               数が0なら削除する.既に登録されている品番なら数を追加する
;*************************************************************************>MOH<
(defun SetOpt (
  &eEN       ; 設定対象の図形名
  &OPT$      ; 追加(or 新規)オプション内容リスト
  /
  #GOP$ #HINBAN #HINBAN$ #I #IHIN #LIS$ #NUM #OP$ #OPFLG #OPT$ #XD$
  #ELM #KOSU$ #OPT_OLD$
  )

  (setq #xd$ (CFGetXData &eEN "G_OPT"))
  
  (if #xd$
    (progn ; "G_OPT"が存在する→既に登録されている品番と個数を取得する
      (setq #num  (car #xd$)) ; ｵﾌﾟｼｮﾝ品の種類の数
      (setq #lis$ (cdr #xd$)) ; 品番1,個数1,品番2,個数2,...のﾘｽﾄ
      (setq #opt_old$ nil)    ; (品番1,個数1)(品番2,個数2),...
      (setq #i 0)
      (foreach #lis #lis$
        ; 品番,個数,品番,個数,...の順番
        (if (= 0 (rem #i 2))
          (setq #hinban #lis)
          (setq #opt_old$ (append #opt_old$ (list (list #hinban #lis))))
        );_if
        (setq #i (1+ #i))
      );foreach

      (setq #hinban$ (mapcar  'car #opt_old$)) ; 品番1,品番2,...
      (setq #kosu$   (mapcar 'cadr #opt_old$)) ; 個数1,個数2,...

      (foreach OPT &OPT$
        (if (member (car OPT) #hinban$)
          (progn ; 既に同じ品番が登録されている
            (setq #elm (assoc (car OPT) #opt_old$)) ; 対象の要素
            (if (= 0 (cadr OPT))
              (progn ; ﾘｽﾄから要素を削除する
                (setq #opt_old$ (vl-remove #elm #opt_old$))
                (if (= #opt_old$ nil)
                  (progn ; 要素がなくなったら"G_OPT"を削除する
                    (DelAppXdata &eEN "G_OPT")
                  )
                );_if
              )
              (progn ; 個数を変更する
                (setq #opt_old$ (subst OPT #elm #opt_old$))
              )
            );_if
          )
        ; else
          (progn ; "G_OPT"はあるが対象の品番がまだ登録されていない
            (if (= 0 (cadr OPT))
              nil ; 個数0なら何もしない
            ; else
              (setq #opt_old$ (append #opt_old$ (list OPT)))
            );_if
          )
        );_if

      );foreach

      (if (= #opt_old$ nil)
        nil ; "G_OPT"削除済み
      ; else
        (progn
          (setq #GOP$ (cons (length #opt_old$) (apply 'append #opt_old$)))
          (CFSetXData &eEN "G_OPT" #GOP$) ;変形させたﾘｽﾄで"G_OPT"設定
        )
      );_if
;;;     (PcSetOpt$G_OPT 図形 ﾘｽﾄ)
    )
  ; else
    (progn ; オプション情報無し = 新規設置
      (if (= (tblsearch "APPID" "G_OPT") nil) (regapp "G_OPT"))
      (setq #OP$ (append (list (length &OPT$)) (apply 'append &OPT$)))
      (CFSetXData &eEN "G_OPT" #OP$)
    )
  );_if
  (princ)
);PcSetOpt$G_OPT

;<HOM>*************************************************************************
; <関数名>    : KPGetFilerKOSUDlg
; <処理概要>  : ﾌｨﾗｰ個数入力ﾀﾞｲｱﾛｸﾞ
; <戻り値>    : 個数
; <作成>      : 02/11/10 YM
;*************************************************************************>MOH<
(defun KPGetFilerKOSUDlg ( 
  &Hinban
  &KOSU
;-- 2011/08/11 A.Satoh Add - S
  &SYOKEI
;-- 2011/08/11 A.Satoh Add - E
  /
  #DCL_ID #RET
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #KOSU #ret
;-- 2011/08/11 A.Satoh Add - S
            #kitchin #syokei
;-- 2011/08/11 A.Satoh Add - E
            )
            (setq #KOSU (read (get_tile "edtBOX"))) ; ﾌｨﾗｰ個数
;-- 2011/08/11 A.Satoh Add - S
            (setq #kitchin (get_tile "radio_A"))
            (if (= #kitchin "1")
              (setq #syokei "A")
              (setq #syokei "D")
            )
;-- 2011/08/11 A.Satoh Add - E

            (if (and (= (type #KOSU) 'INT)(> #KOSU 0))
              (progn
                (done_dialog)     ; 半角整数1以上だった
;-- 2011/08/11 A.Satoh Add - S
;                (setq #ret #KOSU) ; 戻り値 個数
                (setq #ret (list #KOSU #syokei)) ; 戻り値 (個数 小計区別)
;-- 2011/08/11 A.Satoh Add - E
              )
              (progn
                (alert "1以上の半角整数を入力して下さい")
                (set_tile "edtBOX" "")
                (mode_tile "edtBOX" 2)
                (princ)
              )
            );_if

          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;; ダイアログの実行部
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "GetFilerKOSUDlg" #dcl_id)) (exit))

  ; 初期値
  (set_tile "text2" &Hinban)       ; 文字列(品番)
  (set_tile "edtBOX" (rtos &KOSU)) ; 文字列(個数初期値)
;-- 2011/08/11 A.Satoh Add - S
  (if (= &SYOKEI "A")
    (set_tile "radio_A" "1")     ; キッチン
    (set_tile "radio_D" "1")     ; 収納
  )
;-- 2011/08/11 A.Satoh Add - E

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #ret (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; 結果リストを返す
  #ret
); KPGetFilerKOSUDlg

(princ)

