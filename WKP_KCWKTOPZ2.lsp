

(setq CG_R "100")       ; 01/07/09 YM Rｴﾝﾄﾞの径ﾃﾞﾌｫﾙﾄ値
(setq CG_SELECT_WID 50) ; 間口伸縮で窓選択する幅
(setq CG_LenDircut 50)  ; 方向ｶｯﾄ切り込み幅

;;;関数検索用
;;;(defun C:SetWkTop ﾜｰｸﾄｯﾌﾟの品番を確定する KcwktopZ2_M(N)に移動
;;;(defun PKGetSinaCode ワークトップの品コードを返す

; 穴寸法を求める
;;;(defun PKGetANAdim-I2 ワークトップ穴情報を求める(I形状ﾜｰｸﾄｯﾌﾟ専用)ｼﾝｸ,ｺﾝﾛ複数対応

;;;(defun PKGetANAdim-U2 ワークトップ穴情報を求める(U型専用)ｼﾝｸ,ｺﾝﾛ複数対応
;;;(defun PKGetDimSeries2 寸法数列を返す(穴寸法の数列)
;;;(defun KPW_GetWorkTopInfoDlg ワークトップの品番取得ダイアログ
;;;(defun PKW_MakeHoleWorkTop2 シンク穴、コンロ穴、水栓穴に穴を開ける
;;;(defun PKY_ShowWTSET_Dlog ワークトップ情報表示ダイアログ
;;;(defun PKW_SQLResultCheck チェック強化関数
;;;(defun PKW_GetWorkTopAreaSym3 指定ワークトップ領域内のシンク、水栓、ガスコンロを取得する
;;;(defun PKMultiSnkGas ｼﾝｸ、ｺﾝﾛの数が３つ以上あるかどうかﾁｪｯｸする

; 間口伸縮
;;;(defun C:StretchWkTop ワークトップ間口伸縮
;;;(defun PKSTRETCH_TEI 底面図形を伸縮
;;;(defun PK_PtSTRETCHsub BG,FG底面外形点列を伸縮
;;;(defun SubStretchWkTop ワークトップ間口伸縮

; 材質変更
;;;(defun C:ChZaiWKTop 材質変更ｺﾏﾝﾄﾞ
;;;(defun PKW_ZaiDlg 材質変更ダイアログ表示

;;;(defun KP_Std_DimCHeckD 標準WTかどうかの寸法ﾁｪｯｸ( 段差用)
;;;(defun KP_Std_DimCHeckI 標準WTかどうかの寸法ﾁｪｯｸ( I型用)
;;;(defun KP_Std_DimCHeckL 標準WTかどうかの寸法ﾁｪｯｸ(ｽﾃﾝﾚｽL型用)
;;;(defun KP_Std_DimCHeck_RLS 標準WTかどうかの寸法ﾁｪｯｸ( 人大L型ｼﾝｸ側用)
;;;(defun KP_Std_DimCHeck_RLG 標準WTかどうかの寸法ﾁｪｯｸ( 人大L型ｺﾝﾛ側用)

(setq CG_TCUT 1) ; Jﾌﾟﾗﾝ段差接続部WT延長幅 01/07/10 YM ADD

;;;関数検索用
;;;(defun KPW_DesideWorkTop3 ワークトップの品番確定
;;;(defun KPW_GetWorkTopID2 ワークトップの品番取得


;;;<HOM>*************************************************************************
;;; <関数名>    : KP_CT_EXIST
;;; <処理概要>  : 洗面ｶｳﾝﾀｰの品番確定ｺﾏﾝﾄﾞの使用可否を判定
;;; <戻り値>    : T or nil
;;; <作成>      : 01/08/31 YM
;;; <備考>      : CT基本価格Tableが存在するかどうか
;;;*************************************************************************>MOH<
(defun KP_CT_EXIST (
  /
  #QRY_COL$$ #QRY_ZAI$$
  )
  ; CT材質
  (setq #Qry_zai$$
    (DBSqlAutoQuery CG_DBSESSION
      (strcat "select * from CT材質")
    )
  )
  ; ボウルCOLOR
  (setq #Qry_col$$
    (DBSqlAutoQuery CG_DBSESSION
      (strcat "select * from ボウルCOLOR" )
    )
  )
  (if (and #Qry_zai$$ #Qry_col$$)
    T
    nil
  );_if
);KP_CT_EXIST

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KP_SetCounter
;;; <処理概要>  : 洗面ｶｳﾝﾀｰの品番を確定する
;;; <戻り値>    :
;;; <作成>      : 01/08/27 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KP_SetCounter (
  /
  #ECOUNTER #LOOP #SKK$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KP_SetCounter ////")
  (CFOutStateLog 1 1 " ")
  ;// コマンドの初期化
  (StartUndoErr)
  (CFCmdDefBegin 0)
  (CFNoSnapReset)

  (if (= nil (KP_CT_EXIST)) ; CT基価格が存在する
;;;01/08/31YM@MOD (if (and (/= CG_SeriesCode "F")(/= CG_SeriesCode "V"))
    (progn ; セナでもＳＫでもなかったら
      (CFAlertMsg msg8)
      (quit)
    )
    (progn

      ;// シンクキャビネットを指示させる
      (setq #loop T)
      (while #loop
        (setq #eCOUNTER (car (entsel "\nカウンタートップを選択: ")))
        (if #eCOUNTER
          (progn
            (setq #eCOUNTER (CFSearchGroupSym #eCOUNTER)) ; ｼﾝｸｼﾝﾎﾞﾙ図形名
            (if #eCOUNTER
              (progn
                ;// 検索したキャビネットの性格CODEを取得する
                (setq #skk$ (CFGetSymSKKCode #eCOUNTER nil))
                (if (and (equal (car   #skk$) CG_SKK_ONE_CNT 0.01) ; ｶｳﾝﾀｰ =7 ; 01/08/29 YM MOD
                         (equal (cadr  #skk$) CG_SKK_TWO_BAS 0.01) ; ﾍﾞｰｽ  =1 ; 01/08/29 YM MOD
                         (equal (caddr #skk$) CG_SKK_THR_ETC 0.01)); その他=0 ; 01/08/29 YM MOD
                  (setq #loop nil) ; 洗面ｶｳﾝﾀｰだった  ; 01/08/29 YM MOD PMEN4の有無を見ない
                  (CFAlertMsg "カウンタートップではありません")
                );_if
              )
              (CFAlertMsg "カウンタートップではありません")
            );_if
          )
          (CFAlertMsg "カウンタートップではありません")
        );_if
      );_while

      (GroupInSolidChgCol2 #eCOUNTER CG_InfoSymCol) ; 色を変える
      (KP_DesideCTTop #eCOUNTER); 洗面ｶｳﾝﾀｰの品番を確定&確認&"G_TOKU"ｾｯﾄ
      (GroupInSolidChgCol2 #eCOUNTER "BYLAYER")     ; 色を変える
      (princ "\nカウンタートップの品番を確定しました。")
    )
  );_if

  (CFNoSnapFinish)
  (CFCmdDefFinish)
  (setq *error* nil)
  (princ)
);C:KP_SetCounter

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_DesideCTTop
;;; <処理概要>  : 洗面ｶｳﾝﾀｰの品番を確定&確認&"G_TOKU"ｾｯﾄ
;;; <戻り値>    : なし
;;; <作成>      : 01/08/28 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_DesideCTTop (
  &eCOUNTER ; ｶｳﾝﾀｰｼﾝﾎﾞﾙ図形
  /
  #ECOUNTER #LR #PMEN2 #RET$ #RPRICE #SHINBAN #SORG_HIN #SPRICE #XD_LSYM$
  )
  (setq #eCOUNTER &eCOUNTER)
  ; ｶｳﾝﾀｰの品番名称
  (setq #xd_LSYM$ (CFGetXData #eCOUNTER "G_LSYM"))
  (setq #sOrg_Hin (nth 5 #xd_LSYM$)) ; 品番
  (setq #LR       (nth 6 #xd_LSYM$)) ; LR
  (setq #pmen2 (PKGetPMEN_NO #eCOUNTER 2)) ; PMEN2 水栓検索用
  (if (= nil #pmen2)
    (progn
      nil ; 01/09/04 YM ADD
;;;     (CFAlertMsg "ｶｳﾝﾀｰﾄｯﾌﾟに外形領域(P面2)がありません。")
;;;01/09/04YM@DEL     (quit)
    )
  );_if

  ; ｶｳﾝﾀｰ品番確定処理
  (setq #ret$ (KP_DesideCTTop_sub #eCOUNTER #sOrg_Hin #LR #pmen2)) ; ｶｳﾝﾀｰｼﾝﾎﾞﾙ図形,元品番,LR,PMEN2
  (if (= #ret$ nil)
    (quit)
    (progn
      (setq #sHinban (car  #ret$))
      (setq #rPrice  (cadr #ret$))
    )
  );_if

  ; 確認ﾀﾞｲｱﾛｸﾞ
  (setq #sPrice (itoa (fix (+ 0.001 #rPrice))))
  (setq #ret$ (ShowCT_Dlog #sHinban #sPrice))
  (if (= #ret$ nil)
    (quit)
    (progn
      (setq #sHinban (car  #ret$))
      (setq #rPrice  (cadr #ret$))
    )
  );_if

  ; Xdata "G_TOKU" をｾｯﾄする
  (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))
  (CFSetXData #eCOUNTER "G_TOKU"
    (list
      #sHinban     ; ｶｳﾝﾀｰ品番
      #rPrice      ; 価格
      (list 0 0 0) ; ﾀﾞﾐｰ
      2 ; 1:特注ｷｬﾋﾞｺﾏﾝﾄﾞ 0:ｹｺﾐ伸縮 2:洗面ｶｳﾝﾀｰ
      0 ; W ﾌﾞﾚｰｸﾗｲﾝ位置(ﾀﾞﾐｰ)
      0 ; D ﾌﾞﾚｰｸﾗｲﾝ位置(ﾀﾞﾐｰ)
      0 ; H ﾌﾞﾚｰｸﾗｲﾝ位置(ﾀﾞﾐｰ)
      #sOrg_Hin    ; 品番
    )
  )
  (princ)
);KP_DesideCTTop

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_DesideCTTop_sub
;;; <処理概要>  : 洗面ｶｳﾝﾀｰの品番を確定する
;;; <戻り値>    : (品番,価格)
;;; <作成>      : 01/08/27 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_DesideCTTop_sub (
  &eCOUNTER ; ｶｳﾝﾀｰｼﾝﾎﾞﾙ図形
  &sOrg_Hin ; 元の品番名称
  &LR       ; LR区分
  &pmen2    ; 外形領域(水栓検索用)
  /
  #510$ #PT$ #QRY_PRICE$$ #QRY_SUI$$ #QRY_TYPE$$ #RET$ #RPRICE #SCOL #SSUI$ #SSUI$$
  #SSUI_HIN #SSUI_KIGO #STYPE #SZAI #LR #SHINBAN
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KP_DesideCTTop_sub ////")
  (CFOutStateLog 1 1 " ")
  ; ﾀﾞｲｱﾛｸﾞの表示
  (setq #ret$ (KP_CTZaiDlg &sOrg_Hin &LR))
  (if (= #ret$ nil)
    (quit)
    (progn
      (setq #sZAI (car  #ret$)) ; ｶｳﾝﾀｰ材質
      (setq #sCOL (cadr #ret$)) ; ﾎﾞｳﾙｶﾗｰ
    )
  );_if

  ; 価格のﾀｲﾌﾟを検索する
  (setq #qry_type$$
    (CFGetDBSQLRec CG_DBSESSION "CTタイプ"
      (list
        (list "材質記号"       #sZAI 'STR)
        (list "ボウルカラ記号" #sCOL 'STR)
      )
    )
  )
  (if (and #qry_type$$ (= 1 (length #qry_type$$)))
    (setq #sType (itoa (fix (+ 0.001 (nth 2 (car #qry_type$$)))))); 価格ﾀｲﾌﾟHIT(文字列化)
    (setq #sType "-999")                                ; 価格ﾀｲﾌﾟ
  );_if

  ; 水栓の検索
  (if (= &pmen2 nil) ; 01/09/04 YM ADD &pmen2=nilのときも続行
    (setq #510$ nil) ; 01/09/04 YM ADD &pmen2=nilのときも続行
    (progn ; PMEN2があるとき
      (setq #pt$ (GetLWPolyLinePt &pmen2))  ; ｼﾝｸｷｬﾋﾞPMEN2 外形領域
      (setq #pt$ (AddPtList #pt$))          ; 末尾に始点を追加する
      (command "vpoint" "0,0,1") ; 視点を真上から
      (setq #510$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; 領域内水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
      (command "zoom" "p") ; 視点を戻す
    )
  );_if

  (setq #sSUI$$ nil)
  (foreach #510 #510$
    (setq #sSUI_Hin (nth 5 (CFGetXData #510 "G_LSYM"))); 水栓の品番
    (setq #qry_sui$$
      (CFGetDBSQLRec CG_DBSESSION "CT水栓"
        (list (list "品番名称" #sSUI_Hin 'STR))
      )
    )
    (if (and #qry_sui$$ (= 1 (length #qry_sui$$)))
      (setq #sSUI$ (list (nth 0 (car #qry_sui$$))(nth 1 (car #qry_sui$$)))) ; ID,水栓記号
      (setq #sSUI$ (list 0 "?"))                                            ; ID,水栓記号
    );_if
    (setq #sSUI$$ (append #sSUI$$ (list #sSUI$)))
  );foreach

  (setq #sSUI$$ (CFListSort #sSUI$$ 0)) ; nth 0 (ID)が小さいもの順にｿｰﾄ
  ; CT基価格検索用の水栓記号
  (setq #sSUI_KIGO "")
  (foreach #sSUI$ #sSUI$$
    (setq #sSUI_KIGO (strcat #sSUI_KIGO (nth 1 #sSUI$)))
  )

  ; ｶｳﾝﾀｰ価格引き当て
  (setq #qry_price$$
    (CFGetDBSQLRec CG_DBSESSION "CT基価格"
      (list
        (list "品番基本部" &sOrg_Hin  'STR)
        (list "水栓記号"   #sSUI_KIGO 'STR)
        (list "価格タイプ" #sType     'INT)
      )
    )
  )
  (if (and #qry_price$$ (= 1 (length #qry_price$$)))
    (setq #rPrice (nth 4 (car #qry_price$$))) ; ｶｳﾝﾀｰ価格
    (setq #rPrice 0)                          ; ｶｳﾝﾀｰ価格
  );_if

  ; ｶｳﾝﾀｰ品番作成
  (if (= &LR "Z")
    (setq #LR "")
    (setq #LR &LR)
  );_if

  (if (= #sSUI_KIGO "")
    (setq #sSUI_KIGO "?")
  );_if

  (setq #sHinban (strcat &sOrg_Hin #LR #sSUI_KIGO #sZAI #sCOL))

  (list #sHinban #rPrice)
);KP_DesideCTTop_sub

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_CTZaiDlg
;;; <処理概要>  : ｶｳﾝﾀｰ材質,ﾎﾞｳﾙｶﾗｰ選択ﾀﾞｲｱﾛｸﾞ
;;; <戻り値>    : (ｶｳﾝﾀｰ材質,ﾎﾞｳﾙｶﾗｰ)
;;; <作成>      : 01/08/28 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_CTZaiDlg (
  &sOrg_Hin ; 元の品番名称
  &LR       ; LR区分
  /
  #DCL_ID #POP_COL$ #POP_ZAI$ #QRY_COL$$ #QRY_ZAI$$ #RET$ #dum$$
  #HINBAN
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KP_CTZaiDlg ////")
  (CFOutStateLog 1 1 " ")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #zai #col
            )
            (setq #zai (nth (atoi (get_tile "zai")) #pop_zai$)) ; ｶｳﾝﾀｰ材質記号
            (setq #col (nth (atoi (get_tile "col")) #pop_col$)) ; ﾎﾞｳﾙｶﾗｰ記号
            (done_dialog)
            (list #zai #col)
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( / ) ; 材質ポップアップリスト
            ; ｶｳﾝﾀｰ材質
            (setq #pop_zai$ '())
            (start_list "zai" 3)
            (foreach #Qry_zai$ #Qry_zai$$
              (add_list (strcat (nth 2 #Qry_zai$) "         " (nth 3 #Qry_zai$)))
              (setq #pop_zai$ (append #pop_zai$ (list (nth 2 #Qry_zai$)))) ; 材質記号のみ保存
            )
            (end_list)
            (set_tile "zai" "0") ; 最初にﾌｫｰｶｽ

            ; ﾎﾞｳﾙｶﾗｰ
            (setq #pop_col$ '())
            (start_list "col" 3)
            (foreach #Qry_col$ #Qry_col$$
              (add_list (strcat (nth 1 #Qry_col$) "         " (nth 2 #Qry_col$)))
              (setq #pop_col$ (append #pop_col$ (list (nth 1 #Qry_col$)))) ; 材質記号のみ保存
            )
            (end_list)
            (set_tile "col" "0") ; 最初にﾌｫｰｶｽ

            (princ)
          );##Addpop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ; 材質記号の選択
  (setq #Qry_zai$$
    (DBSqlAutoQuery CG_DBSESSION
      (strcat "select * from CT材質")
    )
  )
  (setq #Qry_zai$$ (CFListSort #Qry_zai$$ 0)) ; nth 0 (ID)が小さいもの順にｿｰﾄ

  ; 廃盤Fが1でないもの
  (setq #dum$$ nil)
  (foreach #Qry$ #Qry_zai$$
    (if (/= 1 (nth 6 #Qry$))
      (setq #dum$$ (append #dum$$ (list #Qry$)))
    );_if
  )
  (setq #Qry_zai$$ #dum$$)

  ; ボウルCOLORの選択
  (setq #Qry_col$$
    (DBSqlAutoQuery CG_DBSESSION
      (strcat "select * from ボウルCOLOR" )
    )
  )

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "CT_ZaiDlg" #dcl_id)) (exit))

  ;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
  (##Addpop)

  ; 品番表示
  (if (= &LR "Z")
    (setq #hinban &sOrg_Hin)
    (setq #hinban (strcat &sOrg_Hin "(" &LR ")"))
  )
  (set_tile "txt1" (strcat "カウンター品番: " #hinban))

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret$
);KP_CTZaiDlg

;<HOM>*************************************************************************
; <関数名>    : ShowCT_Dlog
; <処理概要>  : ｶｳﾝﾀｰﾄｯﾌﾟ品番確定ｺﾏﾝﾄﾞ価格,品番確認ﾀﾞｲｱﾛｸﾞ
; <戻り値>    : 価格,品番
; <作成>      : 01/08/28 YM
; <備考>      :
; ***********************************************************************************>MOH<
(defun ShowCT_Dlog (
  &HINBAN
  &PRICE ; 価格ﾃﾞﾌｫﾙﾄ値
  /
  #RES$ #SDCLID
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
        (if (and (= (type #val) 'INT)
                 (> #val 0.001)) ; 更に正かどうか調べる(0は不可)
          (princ) ; OK
          (progn
            (alert "0より大きな半角整数値を入力して下さい。")
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
      (setq #RES$
        (list
          (get_tile "edtTOKU_ID")         ; 品番
          (atof (get_tile "edtTOKU_PRI")) ; 価格
        )
      )
      (done_dialog)
      #RES$
    );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;; ダイアログの実行部
  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "ShowCTDlg" #sDCLID)) (exit))

  ; 初期値の設定 ; txtORG_PRICE
  (set_tile "edtTOKU_ID" &HINBAN)
  (set_tile "edtTOKU_PRI" &PRICE)

  (mode_tile "edtTOKU_PRI" 2)

  ;;; タイルのリアクション設定
  (action_tile "edtTOKU_ID"  "(##CHK_edit \"edtTOKU_ID\"  &HINBAN 2)")
  (action_tile "edtTOKU_PRI" "(##CHK_edit \"edtTOKU_PRI\" &PRICE  1)")
  (action_tile "accept" "(setq #RES$ (##GetDlgItem))")
  (start_dialog)
  (unload_dialog #sDCLID)
  ; リストを返す
  #RES$
);ShowCT_Dlog

;;; <HOM>***********************************************************************************
;;; <関数名>    : PKGetSinaCode
;;; <処理概要>  : ワークトップの品コードを返す
;;; <戻り値>    : 幅×奥行き×厚み(ｽﾃﾝﾚｽL型は、幅1×幅2×厚み)
;;; <作成>      : 2000-05-23  : YM
;;; <備考>      :
;;; ***********************************************************************************>MOH<
(defun PKGetSinaCode (
  #ZAIF  ; 素材F
  #WRKT$ ; "G_WRKT"
  /
  #DUM1 #DUM123 #DUM2 #DUM3
  #CUTL #CUTR #CUTTYPE
  )
  (setq #CutType (nth 7 #WRKT$)) ; ｶｯﾄﾀｲﾌﾟ
  (setq #cutL (substr #CutType 1 1))
  (setq #cutR (substr #CutType 2 1))

  (if (and (= #ZaiF 1)(= (nth 3 #WRKT$) 1)(= #cutL "0")(= #cutR "0"))
    (progn ; ｽﾃﾝﾚｽL形状
      (setq #dum1 (itoa (fix (+ (car  (nth 55 #WRKT$)) 0.001))))
      (setq #dum2 (itoa (fix (+ (cadr (nth 55 #WRKT$)) 0.001))))
      (if (/= (nth 10 #WRKT$) "") ; 厚み
        (setq #dum3 (itoa (fix (+ (nth 10 #WRKT$) 0.001))))
      )
      (setq #dum123 (strcat #dum1 "x " #dum2 "x " #dum3))
    )
    (progn ; ｽﾃﾝﾚｽL形状以外のとき
      (setq #dum1 (itoa (fix (+ (car (nth 55 #WRKT$)) 0.001))))
      (if (/= (car (nth 57 #WRKT$)) "") ; 奥行き
        (setq #dum2 (itoa (fix (+ (car (nth 57 #WRKT$)) 0.001))))
      )
      (if (/= (nth 10 #WRKT$) "") ; 厚み
        (setq #dum3 (itoa (fix (+ (nth 10 #WRKT$) 0.001))))
      )
      (setq #dum123 (strcat #dum1 "x " #dum2 "x " #dum3))
    )
  );_if
  #dum123
);PKGetSinaCode

;;; <HOM>***********************************************************************************
;;; <関数名>    : KPGetSinkANA
;;; <処理概要>  : 各ｼﾝｸの、WT材質に応じたｼﾝｸ穴領域PMEN4属性?のﾘｽﾄを返す(ｼﾝｸ複数対応)
;;; <戻り値>    : 各ｼﾝｸの適切なｼﾝｸ穴(実際に穴を開ける)
;;; <作成>      : 01/03/27 YM
;;; <備考>      : ｽﾃﾝﾚｽならPMEN4属性1,人大ならPMEN4属性0のもを各ｼﾝｸに対して1つ(ｼﾝｸ複数時は順番が重要)
;;; ***********************************************************************************>MOH<
(defun KPGetSinkANA (
  &eSNK_P4$$  ; 各ｼﾝｸ毎のPMEN4ﾘｽﾄのﾘｽﾄ
  &ZaiF       ; 素材F
  /
  #ESNK_P$ #ESNK_P4$$ #SETFLG #XDP4$ #ZAIF
  )
  (setq #eSNK_P4$$ &eSNK_P4$$ #ZaiF &ZaiF)

  (setq #eSNK_P$ nil)
  (foreach #eSNK_P4$ #eSNK_P4$$ ; ｼﾝｸの数ﾙｰﾌﾟ
    (cond
      ((= #ZaiF 1) ; ｽﾃﾝﾚｽ
        (setq #setFLG nil)
        (foreach PMEN4 #eSNK_P4$   ; ｼﾝｸ1つに複数のPMEN4 #eSNK_P4$
          (setq #xdP4$ (CFGetXData PMEN4 "G_PMEN"))
          (if (= (nth 1 #xdP4$) 1) ; PMEN4属性1のものばかり集める
            (if (= #setFLG nil)
              (progn
                (setq #eSNK_P$ (append #eSNK_P$ (list PMEN4))) ; 複数のｼﾝｸについて1つずつPMEN4属性1をｾｯﾄ#eSNK_P$
                (setq #setFLG T) ; 1つｾｯﾄすればもうｾｯﾄしない
              )
            );_if
          );_if
        )
        (if (and (< 0 (length #eSNK_P4$))(= #setFLG nil))
          (progn
            (CFAlertMsg "ｽﾃﾝﾚｽ用ｼﾝｸ穴領域(属性1)がｼﾝｸに定義されていません。")
            (quit)
          )
        );_if
      )
      ((or (= #ZaiF 0)(= #ZaiF -1)(= #ZaiF -2)) ; 人工大理石 01/07/03 YM
        (setq #setFLG nil)
        (foreach PMEN4 #eSNK_P4$   ; ｼﾝｸ1つに複数のPMEN4 #eSNK_P4$
          (setq #xdP4$ (CFGetXData PMEN4 "G_PMEN"))
          (if (= (nth 1 #xdP4$) 0) ; PMEN4属性0のものばかり集める
            (if (= #setFLG nil)
              (progn
                (setq #eSNK_P$ (append #eSNK_P$ (list PMEN4))) ; 複数のｼﾝｸについて1つずつPMEN4属性0をｾｯﾄ#eSNK_P$
                (setq #setFLG T) ; 1つｾｯﾄすればもうｾｯﾄしない
              )
            );_if
          );_if
        )
        (if (and (< 0 (length #eSNK_P4$))(= #setFLG nil))
          (progn
            (CFAlertMsg "人大用ｼﾝｸ穴領域(属性0)がｼﾝｸに定義されていません。")
            (quit)
          )
        );_if
      )
      (T
        (CFAlertMsg "\n『WT材質』の\"素材F\"が不正です。\n0または1ではありません。")(quit)
      )
    );_cond
  );foreach

  #eSNK_P$
);KPGetSinkANA

;<HOM>*************************************************************************
; <関数名>    : GetWT_MigiShitaPt
; <処理概要>  : 天板の外形点列を取得
; <戻り値>    : 天板の外形点列,天板間口
; <作成>      : 2010/11/09 YM
; <備考>      : 対象：I型、P型のみ
;*************************************************************************>MOH<
(defun GetWT_MigiShitaPt (
  &WT ;天板図形
  /
  #BASEP #P3 #PT$ #TEI #WTXD$
  )
  (setq #wtXd$ (CFGetXData &WT "G_WRKT"))

  ; CG_P_HOOD_SYM P型ﾌｰﾄﾞのｼﾝﾎﾞﾙ図形
  (setq #tei   (nth 38 #wtXd$))      ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BaseP (nth 32 #wtXd$))      ; WT左上点
  ;(setq #Magu  (nth 42 #wtXd$))      ; WT間口
  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
;;; 外形点列&pt$を#BASEPを先頭に時計周りにする
  (setq #pt$ (GetPtSeries #BaseP #pt$))

  #pt$ ;外形点列
);GetWT_MigiShitaPt


;;; <HOM>***********************************************************************************
;;; <関数名>    : PKGetANAdim-I2
;;; <処理概要>  : ワークトップ穴情報を求める(I形状ﾜｰｸﾄｯﾌﾟ専用)ｼﾝｸ,ｺﾝﾛ複数対応
;;; <戻り値>    : WT左からの寸法数列
;;; <作成>      : 00/09/25 YM 標準化
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;; ***********************************************************************************>MOH<
(defun PKGetANAdim-I2 (
  &eWT      ; WT図形名
  &WRKT$    ; G_WRKT
  &eSNK_P$  ; SNK-PMEN(複数ﾘｽﾄ)
  &eGAS_P$  ; GAS-PMEN(複数ﾘｽﾄ)
  /
  #ANA$ #ANGX #BASEP #DIM$ #LEN1 #LIS1$$ #MAX #MIN #P1 #P2 #PT$ #PTANA$
  #REG1$ #RET$ #TEI #X1
  )
  (setq #ANA$ (append &eSNK_P$ &eGAS_P$)) ; PMENｼﾝﾎﾞﾙ図形
;;; nilを除く
  (setq #ANA$ (NilDel_List #ANA$))

;;;   p1                           p2 両方Hｶｯﾄ,Jｶｯﾄ注意
;;;   +----------------------------+
;;;   |    +-------+    +---+     /
;;;   |    | S or G|    |   |    /
;;;   |    +-------+    +---+   /
;;;   +________________________/
;;;   |
;;;   |
;;;  x1     仮想点x1 (Hｶｯﾄのとき必要)

  (setq #tei   (nth 38 &WRKT$))      ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BaseP (nth 32 &WRKT$))      ; WT左上点
  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
;;; 外形点列&pt$を#BASEPを先頭に時計周りにする
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #angX (+ (angle #p1 #p2) (dtr -90)))
  (setq #x1 (polar #p1 #angX 100)) ; 仮想点1
  (setq #LEN1 (distance #p1 #p2))

  (command "_layer" "T" "Z_01*" "") ; PMEN画層ﾌﾘｰｽﾞ解除

  (setq #reg1$ (append #pt$ (list (car #pt$))))

  (setq #lis1$$ '())
  (if #ANA$ ; PMENあり
    (foreach #ANA #ANA$
      (setq #ptANA$ (GetLWPolyLinePt #ANA)) ; PMEN外形点列
      (if (IsEntInPolygon #ANA #reg1$ "CP") ; 領域1にPMENが存在すれば
        (progn
          (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p1 #x1)))
          (setq #min (car  #ret$)) ; 距離最小
          (setq #max (cadr #ret$)) ; 距離最大
          (setq #lis1$$ (append #lis1$$ (list (list #min) (list #max))))
        )
      );_if
    )
  );_if

;;; 領域1側寸法数列を求める(端から穴までの距離)
  (setq #dim$
    (PKGetDimSeries2
      #lis1$$  ; (距離最小,距離最大)のﾘｽﾄ
      #LEN1    ; 全長
    )
  )
  (command "_layer" "F" "Z_01*" "") ; PMEN画層ﾌﾘｰｽﾞ
  (setq #dim$ (append #dim$ (list #LEN1))) ; 全長を加える
  #dim$
);PKGetANAdim-I2


;;; <HOM>***********************************************************************************
;;; <関数名>    : PKGetANAdim-I1
;;; <処理概要>  : ワークトップ穴情報を求める(I形状ﾜｰｸﾄｯﾌﾟ専用)ｼﾝｸのみ対応
;;; <戻り値>    : WT左からの寸法数列
;;; <作成>      : 2017/01/13 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;; ***********************************************************************************>MOH<
(defun PKGetANAdim-I1 (
  &eWT      ; WT図形名
  &WRKT$    ; G_WRKT
  &eSNK_P$  ; SNK-PMEN(複数ﾘｽﾄ)
  /
  #ANA$ #ANGX #BASEP #DIM$ #LEN1 #LIS1$$ #MAX #MIN #P1 #P2 #PT$ #PTANA$
  #REG1$ #RET$ #TEI #X1
  )
  (setq #ANA$ (append &eSNK_P$ )) ; PMENｼﾝﾎﾞﾙ図形
;;; nilを除く
  (setq #ANA$ (NilDel_List #ANA$))

;;;   p1                           p2 両方Hｶｯﾄ,Jｶｯﾄ注意
;;;   +----------------------------+
;;;   |    +-------+              /
;;;   |    | S     |             /
;;;   |    +-------+            /
;;;   +________________________/
;;;   |
;;;   |
;;;  x1     仮想点x1 (Hｶｯﾄのとき必要)

  (setq #tei   (nth 38 &WRKT$))      ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BaseP (nth 32 &WRKT$))      ; WT左上点
  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
;;; 外形点列&pt$を#BASEPを先頭に時計周りにする
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #angX (+ (angle #p1 #p2) (dtr -90)))
  (setq #x1 (polar #p1 #angX 100)) ; 仮想点1
  (setq #LEN1 (distance #p1 #p2))

  (command "_layer" "T" "Z_01*" "") ; PMEN画層ﾌﾘｰｽﾞ解除

  (setq #reg1$ (append #pt$ (list (car #pt$))))

  (setq #lis1$$ '())
  (if #ANA$ ; PMENあり
    (foreach #ANA #ANA$
      (setq #ptANA$ (GetLWPolyLinePt #ANA)) ; PMEN外形点列
      (if (IsEntInPolygon #ANA #reg1$ "CP") ; 領域1にPMENが存在すれば
        (progn
          (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p1 #x1)))
          (setq #min (car  #ret$)) ; 距離最小
          (setq #max (cadr #ret$)) ; 距離最大
          (setq #lis1$$ (append #lis1$$ (list (list #min) (list #max))))
        )
      );_if
    )
  );_if

;;; 領域1側寸法数列を求める(端から穴までの距離)
  (setq #dim$
    (PKGetDimSeries2
      #lis1$$  ; (距離最小,距離最大)のﾘｽﾄ
      #LEN1    ; 全長
    )
  )
  (command "_layer" "F" "Z_01*" "") ; PMEN画層ﾌﾘｰｽﾞ
  (setq #dim$ (append #dim$ (list #LEN1))) ; 全長を加える
  #dim$
);PKGetANAdim-I1

;;; <HOM>***********************************************************************************
;;; <関数名>    : PKGetANAdim-U2
;;; <処理概要>  : ワークトップ穴情報を求める(U型専用)ｼﾝｸ,ｺﾝﾛ複数対応
;;; <戻り値>    : WT左からの寸法数列
;;; <作成>      : 00/09/25 YM 標準化
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;; ***********************************************************************************>MOH<
(defun PKGetANAdim-U2 (
  &eWT      ; WT図形名
  &WRKT$    ; G_WRKT
  &eSNK_P$  ; SNK-PMEN(複数ﾘｽﾄ)
  &eGAS_P$  ; GAS-PMEN(複数ﾘｽﾄ)
  /
  #ANA$ #BASEP #DIM$ #DIM1$ #DIM2$ #DIM3$ #LEN1 #LEN2 #LEN3 #LIS1$$ #LIS2$$ #LIS3$$ #MAX #MIN
  #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #PT$ #PTANA$ #PTANA1$$ #PTANA2$$ #PTANA3$$
  #REG1$ #REG2$ #REG3$ #RET$ #TEI #X1 #X2 #X3 #X4
  )
  (setq #ANA$ (append &eSNK_P$ &eGAS_P$)) ; PMENｼﾝﾎﾞﾙ図形
;;; nilを除く
  (setq #ANA$ (NilDel_List #ANA$))

;;; p1+----------+--LEN3-------------+p2
;;;   |          x1                  |
;;;   |          |     領域3         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |  領域2   |
;;;LEN2          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   +x3--------+-------------------+p6
;;;   |          p5                  |
;;;   |          |     領域1         |
;;;   |          x4                  |
;;; p8+----------+--LEN1-------------+p7

  (setq #tei   (nth 38 &WRKT$))      ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BaseP (nth 32 &WRKT$))      ; WT左上点
  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
;;; 外形点列&pt$を#BASEPを先頭に時計周りにする
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))
  (setq #p7 (nth 6 #pt$))
  (setq #p8 (nth 7 #pt$))
  (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
  (setq #x2 (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #x3 (CFGetDropPt #p5 (list #p1 #p8)))
  (setq #x4 (CFGetDropPt #p5 (list #p8 #p7)))
  (setq #LEN1 (distance #p7 #p8))
  (setq #LEN2 (distance #p1 #p8))
  (setq #LEN3 (distance #p1 #p2))

  (command "_layer" "T" "Z_01*" "") ; PMEN画層ﾌﾘｰｽﾞ解除

  (setq #reg1$ (list #x3 #p6 #p7 #p8 #x3)) ; 領域1
  (setq #reg2$ (list #p1 #x1 #x4 #p8 #p1)) ; 領域2
  (setq #reg3$ (list #p1 #p2 #p3 #x2 #p1)) ; 領域3

  (setq #lis1$$ '())
  (setq #lis2$$ '())
  (setq #lis3$$ '())
  (if #ANA$ ; PMENあり
    (progn
      (foreach #ANA #ANA$
        (setq #ptANA$ (GetLWPolyLinePt #ANA)) ; PMEN外形点列
        (if (IsEntInPolygon #ANA #reg1$ "CP") ; 領域1にPMENが存在すれば
          (progn
            (setq #ptANA1$$ (append #ptANA1$$ (list #ptANA$)))
            (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p6 #p7)))
            (setq #min (car  #ret$)) ; 距離最小
            (setq #max (cadr #ret$)) ; 距離最大
            (setq #lis1$$ (append #lis1$$ (list (list #min) (list #max))))
          )
        );_if
        (if (IsEntInPolygon #ANA #reg2$ "CP") ; 領域2にPMENが存在すれば
          (progn
            (setq #ptANA2$$ (append #ptANA2$$ (list #ptANA$)))
            (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p7 #p8)))
            (setq #min (car  #ret$))
            (setq #max (cadr #ret$))
            (setq #lis2$$ (append #lis2$$ (list (list #min) (list #max))))
          )
        );_if
        (if (IsEntInPolygon #ANA #reg3$ "CP") ; 領域3にPMENが存在すれば
          (progn
            (setq #ptANA3$$ (append #ptANA3$$ (list #ptANA$)))
            (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p1 #p8)))
            (setq #min (car  #ret$)) ; 距離最小
            (setq #max (cadr #ret$)) ; 距離最大
            (setq #lis3$$ (append #lis3$$ (list (list #min) (list #max))))
          )
        );_if
      )
    )
  );_if

;;; 領域1側寸法数列を求める(端から穴までの距離)
  (setq #dim1$
    (PKGetDimSeries2
      #lis1$$  ; (距離最小,距離最大)のﾘｽﾄ
      #LEN1    ; 全長
    )
  )
;;; 領域2側寸法数列を求める(端から穴までの距離)
  (setq #dim2$
    (PKGetDimSeries2
      #lis2$$  ; (距離最小,距離最大)のﾘｽﾄ
      #LEN2    ; 全長
    )
  )
;;; 領域2側寸法数列を求める(端から穴までの距離)
  (setq #dim3$
    (PKGetDimSeries2
      #lis3$$  ; (距離最小,距離最大)のﾘｽﾄ
      #LEN3    ; 全長
    )
  )

  (setq #dim$ (append #dim1$ #dim2$ #dim3$))
  (command "_layer" "F" "Z_01*" "") ; PMEN画層ﾌﾘｰｽﾞ
  (setq #dim$ (append #dim$ (list #LEN1 #LEN2 #LEN3)))
  #dim$
);PKGetANAdim-U2

;;; <HOM>***********************************************************************************
;;; <関数名>    : PKGetDimSeries2
;;; <処理概要>  : 寸法数列を返す(穴寸法の数列)
;;; <戻り値>    : (距離,距離,...)
;;; <作成>      : 00/06/28 YM
;;; <備考>      :
;;; ***********************************************************************************>MOH<
(defun PKGetDimSeries2 (
  &lis$$ ; ((穴までの距離最小),(穴までの距離最大),...) ﾘｽﾄのﾘｽﾄ
  &LEN   ; 全長
  /
  #DIM #DIM$ #DIS #DIS_OLD #I #LIS$$ #SUM
  )
;;; 距離の小さいもの順にｿｰﾄ
  (setq #lis$$ (CFListSort &lis$$ 0)) ; (nth 0 が小さいもの順にｿｰﾄ
  (setq #i 0 #dim$ '() #sum 0)
  (foreach #lis$ #lis$$
    (setq #dis (car #lis$))
    (if (= #i 0)
      (setq #dim #dis) ; 最初
      (setq #dim (- #dis #dis_old))
    )
    (setq #dim$ (append #dim$ (list #dim)))
    (setq #sum (+ #sum #dim))
    (setq #dis_old #dis)
    (setq #i (1+ #i))
  );_foreach
  (if (= #dim$ nil)
    (setq #dim$ (list &LEN))
    (setq #dim$ (append #dim$ (list (- &LEN #sum))))
  )
  #dim$
);PKGetDimSeries2

;;; <HOM>***********************************************************************************
;;; <関数名>    : KPW_GetWorkTopInfoDlg
;;; <処理概要>  : ワークトップの品番取得ダイアログ
;;; <戻り値>    : (品番  価格)
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      : キャンセル時は"canceled"が返る
;;; ***********************************************************************************>MOH<
(defun KPW_GetWorkTopInfoDlg (
  &WRKT$
  &DF_NAME    ; デフォルトの名前
  &DF_PRICE   ; デフォルトの価格
  /
  #RESULT$ #SDCLID #TYPE1 #WTLEN1 #WTLEN2 #WT_DEP1 #WT_DEP2 #WT_T
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KPW_GetWorkTopInfoDlg ////")
  (CFOutStateLog 1 1 " ")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckNum (&sKEY / #val #ret)
    (setq #ret nil)
    (setq #val (read (get_tile &sKEY)))
    (if (= (type (read (get_tile &sKEY))) 'INT)
      (if (<= #val 0)
        (progn
          (alert "0より大きな整数値を入力して下さい")
          (set_tile &sKEY "")
          (mode_tile &sKEY 2)
        )
        (setq #ret T)
      );_if
      (progn
        (alert "0より大きな整数値を入力して下さい")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckStr (&sKEY / #ret)
    (setq #ret nil)
    (if (= (type (read (get_tile &sKEY))) 'SYM)
      (setq #ret T)
      (progn
        (alert "文字列を入力して下さい")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; 全項目チェック。通れば結果リストに加工して返す。
  (defun ##Check&GetAllVal ( / #DLG$)
    (cond
      ((not (##CheckNum "edtWT_PRI"))  nil) ; 項目にｴﾗｰがあるとnilを返す
      ((not (##CheckStr "edtWT_NAME")) nil) ; 項目にｴﾗｰがあるとnilを返す
      (T ; 項目にｴﾗｰなし
        (setq #DLG$
          (list
            (strcase (get_tile "edtWT_NAME"))  ; 品番 大文字にする
            (atoi (get_tile "edtWT_PRI"))      ; 価格(円)
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
  ; 現在の品番に対して価格を検索する 01/04/05 YM
  (defun ##SerchPrice ( / #DLG$ #qry$ #PRICE #WTID)
    (setq #WTid (get_tile "edtWT_NAME"))
    (setq #qry$
      (CFGetDBSQLRec CG_DBSESSION "WT基価格"
        (list (list "最終品番" #WTid         'STR))
      )
    )
    (if (and #qry$ (= (length #qry$) 1))
      (progn
        (setq #price (nth 3 (car #qry$))) ; 価格文字列
        (set_tile "edtWT_PRI" (itoa (fix (+ #price 0.001))) )
      )
      (mode_tile "edtWT_PRI" 2)
    )
    (princ)
  );##SerchPrice
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
;;; (setq #type1   (nth 3 &WRKT$))    ; 形状ﾀｲﾌﾟ =1:L型
;;;  (setq #ZaiCode (nth 2 &WRKT$))    ;材質記号
;;; (setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
  (setq #WTLEN1  (itoa (fix (+ (car  (nth 55 &WRKT$)) 0.001)))) ; WT幅1
  (setq #WTLEN2  (itoa (fix (+ (cadr (nth 55 &WRKT$)) 0.001)))) ; WT幅2
  (setq #WT_DEP1 (itoa (fix (+ (car  (nth 57 &WRKT$)) 0.001)))) ; WT奥行き1
  (setq #WT_DEP2 (itoa (fix (+ (cadr (nth 57 &WRKT$)) 0.001)))) ; WT奥行き2
  (setq #WT_T    (itoa (fix (+       (nth 10 &WRKT$)  0.001)))) ; WT厚み

  (if (= nil (new_dialog "GetWorkTopInfoDlg" #sDCLID)) (exit)) ; L型用
;;; ﾀｲﾙ初期値設定
  (set_tile "edtWT_NAME" &DF_NAME)
  (set_tile "edtWT_PRI" (itoa &DF_PRICE))
  (set_tile "txt11" #WTLEN1)
  (set_tile "txt22" #WTLEN2)
  (set_tile "txt33" #WT_DEP1)
  (set_tile "txt44" #WT_DEP2)
  (set_tile "txt55" #WT_T)
  ; 項目 価格の入力値チェック(0以上の実数かどうか)
  (action_tile "edtWT_PRI"  "(##CheckNum \"edtWT_PRI\")")
  (action_tile "edtWT_NAME" "(##CheckStr \"edtWT_NAME\")")
  ; OKボタンが押されたら全項目をチェック。通れば結果リストに加工して返す。
  (action_tile "accept" "(setq #RESULT$ (##Check&GetAllVal))")
  (action_tile "cancel" "(setq #RESULT$ (##Exit))") ; cancel
  (start_dialog)
  (unload_dialog #sDCLID)
  #RESULT$
);KPW_GetWorkTopInfoDlg

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_MakeHoleWorkTop2
;;; <処理概要>  : シンク穴、コンロ穴、水栓穴に穴を開ける
;;; <戻り値>    :
;;; <作成>      : 99-10-19
;;; <備考>      : 07/06 YM ｼﾝｸ,ｺﾝﾛ複数対応
;;;*************************************************************************>MOH<
(defun PKW_MakeHoleWorkTop2 (
  &enWt         ;(ENAME)ワークトップ図形（カットの場合、シンク側）
  &snkPen$      ;(ENAME)シンクＰ面図形
  &gasPen$      ;(ENAME)ガスＰ面図形
  /
  #EG #GASPEN$ #HOLE #I #OBJ #SNK-XD$ #SNKPEN$ #SNK_SYM #WTXD$ #SETXD$
#EANA ; 02/12/04 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_MakeHoleWorkTop2 ////")
  (CFOutStateLog 1 1 " ")

;;; nilを除く
  (setq #snkPen$ &snkPen$)
  (setq #gasPen$ &gasPen$)
  (setq #wtXd$ (CFGetXData &enWt "G_WRKT"))
  (if (= nil (tblsearch "APPID" "G_HOLE")) (regapp "G_HOLE"))

  ; 02/05/22 YM 品番確定済みWT上に水栓を配置して穴あけを行う際に
  ; 必要なシンク穴も消してしまう不具合対応のためシンクに穴をあける必要がある
  ; ときに限って加工穴図形を削除する(それ以外&snkPen$=nilのときは削除しない
  ; 02/04/17 YM ADD-S 加工穴図形を削除する
  ; 品番確定済みWTを再品番確定するときに残ってしまう
  (if (/= nil &snkPen$)
    (progn ; 02/05/22 YM ADD if文

      (setq #i 19)
      (repeat (nth 18 #wtXd$)
        (setq #eANA (nth #i #wtXd$))
        (if (/= nil (entget #eANA))
          (entdel #eANA)
        );_if
        (setq #i (1+ #i))
      )

    ) ; 02/05/22 YM ADD if文
  );_if

;;; ｼﾝｸの場合
  (setq #SetXd$ nil)
  (if #snkPen$ ; 00/11/28 YM ADD
    (progn
      (setq #SetXd$ (list (list 18 (length #snkPen$)))) ; ｼﾝｸ穴個数
      (setq #i 19)
    )
  );_if
  (foreach #snkPen #snkPen$
;;;CG_SNK_HOLE_DEL
    (setq #eg (entget #snkPen))
    (setq #eg (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (cdr #eg)) (cdr #eg)))
    (setq #eg (subst (cons 62 2) (assoc 62 #eg) #eg))
    (entmake #eg)    ; 穴領域の複製作成(底面領域用)
    (setq #hole (entlast))
    (CFSetXData #hole "G_HOLE" ; ｼﾝｸの場合 "G_HOLE" を残す
      (list #snkPen)
    )
    (setq #obj (getvar "delobj"))
    (setvar "delobj" 0) ; 0 オブジェクトは保持されます。
    ;2008/07/28 YM MOD 2009対応
    (command "_extrude" #hole "" -3000 )             ;押し出し
;;;    (command "_extrude" #hole "" -3000 "")             ;押し出し
    (command "_move" (entlast) "" "0,0,0" "@0,0,1000") ;移動
    (command "_subtract" &enWt "" (entlast) "")        ;差演算
    (setvar "delobj" #obj) ; 0 アイテムは保持されます
    (setq #SNK_sym (SearchGroupSym #snkPen)) ; ｼﾝｸｷｬﾋﾞﾈｯﾄ親図形名
    (setq #SNK-xd$ (CFGetXData #SNK_sym "G_SINK"))
    (CFSetXData
      #SNK_sym
      "G_SINK"
      (CFModList
        #SNK-xd$
        (list (list 3 #hole))
      )
    )
    (setq #SetXd$ (append #SetXd$ (list (list #i #hole)))) ; "G_WRKT"ｾｯﾄ用 00/11/28 YM ADD
    (setq #i (1+ #i))
  );foreach

  ;;; ｼﾝｸ穴を"G_WRKT"にｾｯﾄする 00/11/28 YM ADD
  (if #SetXd$
    (CFSetXData &enWt "G_WRKT"
      (CFModList #wtXd$ #SetXd$)
    )
  );_if


;2008/10/23 YM DEL ｺﾝﾛ穴は開けない
;;; ｺﾝﾛの場合
;;; 2008/10/23YM@DEL  (foreach #gasPen #gasPen$
;;; 2008/10/23YM@DEL    (setq #eg (entget #gasPen))
;;; 2008/10/23YM@DEL    (setq #eg (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (cdr #eg)) (cdr #eg)))
;;; 2008/10/23YM@DEL    (setq #eg (subst (cons 62 2) (assoc 62 #eg) #eg))
;;; 2008/10/23YM@DEL    (entmake #eg)    ; 穴領域の複製作成(底面領域用)
;;; 2008/10/23YM@DEL    (setq #hole (entlast))
;;; 2008/10/23YM@DEL    ;2008/07/28 YM MOD 2009対応
;;; 2008/10/23YM@DEL    (command "_extrude" #hole "" -3000 )             ;押し出し
;;; 2008/10/23YM@DEL;;;    (command "_extrude" #hole "" -3000 "")             ;押し出し
;;; 2008/10/23YM@DEL    (command "_move" (entlast) "" "0,0,0" "@0,0,1000") ;移動
;;; 2008/10/23YM@DEL    (command "_subtract" &enWt "" (entlast) "")        ;差演算
;;; 2008/10/23YM@DEL  )

  ;// 水栓穴領域を検索する
;2010/01/07 YM ADD KPCAD品番確定時、(nth 22 #wtXd$)に図形名が入るので落ちるからｺﾒﾝﾄ
;;;  (setq #i 23)
;;;  (repeat (nth 22 #wtXd$)
;;;   (setq #eg (entget (nth #i #wtXd$)))
;;;    (setq #eg (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (cdr #eg)) (cdr #eg)))
;;;    (setq #eg (subst (cons 62 2) (assoc 62 #eg) #eg))
;;;    (entmake #eg)    ; 穴領域の複製作成(底面領域用)
;;;   ;2008/07/28 YM MOD 2009対応
;;;    (command "_extrude" (entlast) ""-1500 )         ;押し出し
;;;;;;    (command "_extrude" (entlast) ""-1500 "")         ;押し出し
;;;    (command "_move" (entlast) "" "0,0,0" "@0,0,200") ;移動
;;;    (command "_subtract" &enWt "" (entlast) "" )      ;差演算
;;;   (setq #i (1+ #i))
;;;  )

  (princ)
)
;PKW_MakeHoleWorkTop2

;<HOM>*************************************************************************
; <関数名>    : PKY_ShowWTSET_Dlog
; <処理概要>  : ワークトップ情報表示ダイアログ
; <戻り値>    : なし
; <作成>      : 2000-01-31 日高 美穂
; <備考>      :
; ***********************************************************************************>MOH<
(defun PKY_ShowWTSET_Dlog (
  &WRKT$
  &WTSET$
  /
  #SDCLID
  #loop
  #RESULT$
  )
  ; 2006/09/15 T.Ari MOD 確認画面の設定値を天板に設定する。&0円が入力された場合に再入力を促すように変更
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKY_ShowWTSET_Dlog ////")
  (CFOutStateLog 1 1 " ")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckNum (&val / #val #ret)
    (setq #ret nil)
    (setq #val (read &val))
    (if (= (type (read &val)) 'INT)
      (if (<= #val -0.001)
        (progn
          (alert "0以上の整数値を入力して下さい")
        )
        (setq #ret T)
      );_if
      (progn
        (alert "0以上の整数値を入力して下さい")
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckStr (&val / #ret)
    (setq #ret nil)
    (if (= (vl-string-search "?" &val) nil)
      (setq #ret T)
      (progn
        (alert "品番を入力して下さい")
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; 入力項目取得チェック。通れば結果リストに加工して返す。
  (defun ##GetAllVal ( / #DLG$)
    (setq #DLG$ (list (get_tile "edtWT_ID") (get_tile "edtWT_PRI")))
    (done_dialog)
    #DLG$
  ); end of ##GetAllVal
  (if (not &WTSET$)
    (progn (alert "ワークトップ品番情報の取得に失敗しました") (exit))
  );_if
  (if (= "" (nth 1 &WTSET$)) (set_tile "error" "品番が確定されていません"))
  (setq #RESULT$ (list (nth 1 &WTSET$) (rtos (nth 3 &WTSET$) 2 0)))
  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (setq #loop T)
  (while #loop
    (if (= nil (new_dialog "ShowWorkTopInfoDlg" #sDCLID)) (exit))
    ; 初期値の設定
    (set_tile "edtWT_ID" (nth 0 #RESULT$))
    (set_tile "edtWT_PRI" (nth 1 #RESULT$))
    ; 特注なら、寸法も設定
    (if (= 0 (car &WTSET$)) (set_tile "edtWT_LEN" (nth 4 &WTSET$)))
    (action_tile "accept" "(setq #RESULT$ (##GetAllVal))")
  
    (start_dialog)
    (cond
      ((not (##CheckStr (nth 0 #RESULT$)))
      )
      ((not (##CheckNum (nth 1 #RESULT$)))
      )
      ((equal (atof (nth 1 #RESULT$)) 0.0 0.0001)
        (if (CFYesNoDialog "価格は0円で良いですか？")
          (setq #loop nil)
        )
      )
      (T 
        (setq #loop nil)
      )
    )
  )
  (unload_dialog #sDCLID)
  (list (strcase (nth 0 #RESULT$)) (atof (nth 1  #RESULT$)))
);PKY_ShowWTSET_Dlog

;<HOM>*************************************************************************
; <関数名>    : PKW_SQLResultCheck
; <処理概要>  : チェック強化関数
; <戻り値>    : リスト (SQL結果リスト  エラー文字列)
; <作成>      : 00/02/17 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PKW_SQLResultCheck (
  &SQL_R$     ; SQLの結果リスト
  &sKANS      ; エラーに表示させる関数名
  &sNAME      ; エラーに表示させるテーブル名
  &sEMSG      ; メッセージ
  &iNUM       ; nthで 値のあるべき位置
  /
  #msg
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_SQLResultCheck ////")
  (CFOutStateLog 1 1 " ")

  (if (= &SQL_R$ nil)
    ; 結果リストが取れなかった場合、エラー文字列にテーブル名追加、そのまま進める
    (setq &sEMSG (strcat &sEMSG &sNAME))
    (progn
      (CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
      (CFOutStateLog 1 1 &SQL_R$)
      (if (= (length &SQL_R$) 1)
        (progn
        (setq &SQL_R$ (car &SQL_R$))
        (if (= nil (nth &iNUM &SQL_R$)) (setq &sEMSG (strcat &sEMSG &sNAME)))
        ); end of progn
        ; 結果リストが複数取れた場合、エラーを出しコマンドを終了させる
        (progn
          (setq #msg (strcat &sNAME "にレコードが複数ありました.\n" &sKANS))
          (CFOutStateLog 0 1 #msg)
          (CFAlertMsg #msg)
          (*error*)
        )
      )
    )
  )
  (list &SQL_R$ &sEMSG) ; チェック結果を返す
); end of PKW_SQLResultCheck

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_GetWorkTopAreaSym3
;;; <処理概要>  : 指定ワークトップ領域内のシンク、水栓、ガスコンロを取得する
;;; <戻り値>    : ((ｼﾝｸ,ｼﾝｸｷｬﾋﾞ,P面1,P面4)のﾘｽﾄ,(ｺﾝﾛ,ｺﾝﾛｷｬﾋﾞ,P面5)のﾘｽﾄ,水栓ﾘｽﾄ)
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      : ｼﾝｸ,ｺﾝﾛ複数対応
;;;               vpoint (0,0,1)前提
;;;               ｺﾝﾋﾞﾈｰｼｮﾝ対応 01/02 16 YM ADD
;;;*************************************************************************>MOH<
(defun PKW_GetWorkTopAreaSym3 (
  &enWt ;(ENAME)ワークトップ図形名
  /
;-- 2011/06/16 A.Satoh Mod(#CUTL #CUTRを削除) - S
; #BASEWT #CUTL #CUTR #EN #ENGAS #ENGASCAB$ #ENSNK #ENSNKCAB$ #EWTR$ #LOOP
  #BASEWT #EN #ENGAS #ENGASCAB$ #ENSNK #ENSNKCAB$ #EWTR$ #LOOP
;-- 2011/06/16 A.Satoh Mod(#CUTL #CUTRを削除) - S
  #GAS$$ #GASPEN5 #I #P-SS #PT$ #SNK$$ #SNKPEN1$ #SNKPEN4$ #TEIWT #XD$ #XDWT$
#GASPEN9 #LOOP5 #LOOP9 #RET ;2013/09/10 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_GetWorkTopAreaSym3 ////")
  (CFOutStateLog 1 1 " ")

  (setq #xdWT$ (CFGetXData &enWt "G_WRKT"))
  (setq #baseWT (nth 32 #xdWT$)) ; WT左上点
;-- 2011/06/16 A.Satoh Del - S
; (setq #cutL   (nth 36 #xdWT$)) ; WTｶｯﾄ左
; (setq #cutR   (nth 37 #xdWT$)) ; WTｶｯﾄ右
;-- 2011/06/16 A.Satoh Del - E
  (setq #teiWT  (nth 38 #xdWT$)) ; WT底面図形
  (setq #pt$ (GetLWPolyLinePt #teiWT))    ; WT外形点列
  (setq #pt$ (GetPtSeries #baseWT #pt$))  ; WT左上点 を先頭に時計周り
;-- 2011/06/16 A.Satoh Del - S
;;;; Dｶｯﾄ時に備えてＷＴがＩ形状のとき左右に領域を100mm延長する
; (if (= #cutL "D")
;   (setq #pt$ (PKExtendPTAreaRL100mm #pt$ "L"))
; );_if
; (if (= #cutR "D")
;   (setq #pt$ (PKExtendPTAreaRL100mm #pt$ "R"))
; );_if
;-- 2011/06/16 A.Satoh Del - E

  (setq #pt$ (AddPtList #pt$))

;;; (ｼﾝｸ,ｼﾝｸｷｬﾋﾞ,P面1,P面4)のﾘｽﾄを求める
  (setq #enSNKCAB$ '())
  (setq #SNK$$ '())

  (setq #enSNKCAB$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SCA)) ; ｼﾝｸｷｬﾋﾞ ; 01/08/31 YM MOD 112-->ｸﾞﾛｰﾊﾞﾙ化

  (if #enSNKCAB$
		(progn
			(princ "\n★★★　ｼﾝｸｷｬﾋﾞあり ")
	    (foreach #enSNKCAB #enSNKCAB$
	      (setq #enSNK   nil)
	      (setq #snkPen1$ nil)
	      (setq #snkPen4$ nil)

	      (setq #enSNK (PKGetSinkSymBySinkCabCP #enSNKCAB)) ; ｼﾝｸ
	      (if #enSNK ; ｼﾝｸがあったら PMEN1,PMEN4 を求める
	        (progn
						(princ "\n★★★　ｼﾝｸあり")
	          (setq #p-ss (CFGetSameGroupSS #enSNK))
	          (setq #i 0)
	          (repeat (sslength #p-ss)
	            (setq #en (ssname #p-ss #i))
	            (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
	            (if (and #xd$ (= 1 (car #xd$)))
	              (setq #snkPen1$ (append #snkPen1$ (list #en)))
	            );_(if
	            (if (and #xd$ (= 4 (car #xd$)))
	              (setq #snkPen4$ (append #snkPen4$ (list #en)))
	            );_(if
	            (setq #i (1+ #i))
	          )
	        )
					(progn
						(princ "\n★★★　ｼﾝｸなし")
					)
	      );_if
	      (setq #SNK$$ (append #SNK$$ (list (list #enSNK #enSNKCAB #snkPen1$ #snkPen4$))))
	    );_foreach

		)
		(progn
			(princ "\n★★★　ｼﾝｸｷｬﾋﾞなし")
		)
  );_if

;;; (ｺﾝﾛ,ｺﾝﾛｷｬﾋﾞ,P面5)のﾘｽﾄを求める
  (setq #enGASCAB$ '())
  (setq #GAS$$ '())
;;; 点列はWT左上点を始点とし、時計周り
  (setq #enGASCAB$ (PKGetSymBySKKCodeCP2 #pt$)) ; ｺﾝﾛｷｬﾋﾞ
  (if #enGASCAB$
    (foreach #enGASCAB #enGASCAB$
      (setq #enGAS   nil)
      (setq #GasPen5 nil)
      (setq #GasPen9 nil);2013/09/10 YM ADD
      (setq #enGAS (PKGetGasSymByGasCabCP #enGASCAB)) ; ｺﾝﾛ

      (if #enGAS
        (setq #p-ss (CFGetSameGroupSS #enGAS)) ; ｺﾝﾛがあったらｺﾝﾛ内で PMEN5 を求める
        (setq #p-ss (CFGetSameGroupSS #enGASCAB)) ; ｺﾝﾛがなかったらｺﾝﾛｷｬﾋﾞ内で探す
      );_if

      (setq #i 0 #loop T)
			(setq #loop5 nil)
			(setq #loop9 nil)
      (while (and #loop (< #i (sslength #p-ss)))
        (setq #en (ssname #p-ss #i))
        (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
        (if (and #xd$ (= 5 (car #xd$)))       ; PMEN5を使用する
					;2013/09/10 YM MOD-S
          (setq #GasPen5 #en #loop5 T)
;;;          (setq #GasPen5 #en #loop nil)
					;2013/09/10 YM MOD-E
        );_if

				;2013/09/10 YM ADD-S P面9を新規追加これを見る.しかしP面9がない場合はP面5を従来どおり参照したい
        (if (and #xd$ (= 9 (car #xd$)))       ; PMEN5を使用する
          (setq #GasPen9 #en #loop9 T)
        );_if

				(if (and #loop5 #loop9)
					(setq #loop nil)
				);_if
				;2013/09/10 YM ADD-E

        (setq #i (1+ #i))
      )

			;2013/09/10 YM MOD-S
			(if #GasPen9 ;P面9が存在したら優先
				(setq #RET #GasPen9)
				;else
				(setq #RET #GasPen5);なければP面5
			);_if
;;;      (setq #GAS$$ (append #GAS$$ (list (list #enGAS #enGASCAB #GasPen5))))
      (setq #GAS$$ (append #GAS$$ (list (list #enGAS #enGASCAB #RET))))
			;2013/09/10 YM MOD-E

    );_foreach
  );_if

;;; 水栓ｼﾝﾎﾞﾙﾘｽﾄを求める
  (setq #eWTR$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; 水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
  (list #SNK$$ #GAS$$ #eWTR$)
);PKW_GetWorkTopAreaSym3

;;;01/02/16YM@;;;<HOM>*************************************************************************
;;;01/02/16YM@;;; <関数名>    : PKW_GetWorkTopAreaSym3
;;;01/02/16YM@;;; <処理概要>  : 指定ワークトップ領域内のシンク、水栓、ガスコンロを取得する
;;;01/02/16YM@;;; <戻り値>    : ((ｼﾝｸ,ｼﾝｸｷｬﾋﾞ,P面1,P面4)のﾘｽﾄ,(ｺﾝﾛ,ｺﾝﾛｷｬﾋﾞ,P面5)のﾘｽﾄ,水栓ﾘｽﾄ)
;;;01/02/16YM@;;; <作成>      : 00/09/21 YM 標準化
;;;01/02/16YM@;;; <備考>      : ｼﾝｸ,ｺﾝﾛ複数対応
;;;01/02/16YM@;;;               vpoint (0,0,1)前提
;;;01/02/16YM@;;;*************************************************************************>MOH<
;;;01/02/16YM@(defun PKW_GetWorkTopAreaSym3 (
;;;01/02/16YM@  &enWt ;(ENAME)ワークトップ図形名
;;;01/02/16YM@  /
;;;01/02/16YM@  #BASEWT #CUTL #CUTR #EN #ENGAS #ENGASCAB$ #ENSNK #ENSNKCAB$ #EWTR$
;;;01/02/16YM@  #GAS$$ #GASPEN5 #I #P-SS #PT$ #SNK$$ #SNKPEN1 #SNKPEN4 #TEIWT #XD$ #XDWT$
;;;01/02/16YM@  )
;;;01/02/16YM@  (CFOutStateLog 1 1 " ")
;;;01/02/16YM@  (CFOutStateLog 1 1 "//// PKW_GetWorkTopAreaSym3 ////")
;;;01/02/16YM@  (CFOutStateLog 1 1 " ")
;;;01/02/16YM@
;;;01/02/16YM@  (setq #xdWT$ (CFGetXData &enWt "G_WRKT"))
;;;01/02/16YM@  (setq #baseWT (nth 32 #xdWT$)) ; WT左上点
;;;01/02/16YM@  (setq #cutL   (nth 36 #xdWT$)) ; WTｶｯﾄ左
;;;01/02/16YM@  (setq #cutR   (nth 37 #xdWT$)) ; WTｶｯﾄ右
;;;01/02/16YM@  (setq #teiWT  (nth 38 #xdWT$)) ; WT底面図形
;;;01/02/16YM@  (setq #pt$ (GetLWPolyLinePt #teiWT))    ; WT外形点列
;;;01/02/16YM@  (setq #pt$ (GetPtSeries #baseWT #pt$))  ; WT左上点 を先頭に時計周り
;;;01/02/16YM@;;; Dｶｯﾄ時に備えてＷＴがＩ形状のとき左右に領域を100mm延長する
;;;01/02/16YM@  (if (= #cutL "D")
;;;01/02/16YM@    (setq #pt$ (PKExtendPTAreaRL100mm #pt$ "L"))
;;;01/02/16YM@  );_if
;;;01/02/16YM@  (if (= #cutR "D")
;;;01/02/16YM@    (setq #pt$ (PKExtendPTAreaRL100mm #pt$ "R"))
;;;01/02/16YM@  );_if
;;;01/02/16YM@
;;;01/02/16YM@  (setq #pt$ (AddPtList #pt$))
;;;01/02/16YM@
;;;01/02/16YM@;;; (ｼﾝｸ,ｼﾝｸｷｬﾋﾞ,P面1,P面4)のﾘｽﾄを求める
;;;01/02/16YM@  (setq #enSNKCAB$ '())
;;;01/02/16YM@  (setq #SNK$$ '())
;;;01/02/16YM@
;;;01/02/16YM@  (setq #enSNKCAB$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SCA)) ; ｼﾝｸｷｬﾋﾞ ; 01/08/31 YM MOD 112-->ｸﾞﾛｰﾊﾞﾙ化
;;;01/02/16YM@
;;;01/02/16YM@  (if #enSNKCAB$
;;;01/02/16YM@    (foreach #enSNKCAB #enSNKCAB$
;;;01/02/16YM@      (setq #enSNK   nil)
;;;01/02/16YM@      (setq #snkPen1 nil)
;;;01/02/16YM@      (setq #snkPen4 nil)
;;;01/02/16YM@
;;;01/02/16YM@      (setq #enSNK (PKGetSinkSymBySinkCabCP #enSNKCAB)) ; ｼﾝｸ
;;;01/02/16YM@      (if #enSNK ; ｼﾝｸがあったら PMEN1,PMEN4 を求める
;;;01/02/16YM@        (progn
;;;01/02/16YM@          (setq #p-ss (CFGetSameGroupSS #enSNK))
;;;01/02/16YM@          (setq #i 0)
;;;01/02/16YM@          (repeat (sslength #p-ss)
;;;01/02/16YM@            (setq #en (ssname #p-ss #i))
;;;01/02/16YM@            (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
;;;01/02/16YM@            (if (and #xd$ (= 1 (car #xd$)))       ;  ｼﾝｸ取り付け領域 ｽﾃﾝﾚｽはPMEN1を使用する
;;;01/02/16YM@              (setq #snkPen1 #en)
;;;01/02/16YM@            );_(if
;;;01/02/16YM@            (if (and #xd$ (= 4 (car #xd$)))       ;  ｼﾝｸ取り付け領域 ﾗﾋﾟｽはPMEN4を使用する
;;;01/02/16YM@              (setq #snkPen4 #en)
;;;01/02/16YM@            );_(if
;;;01/02/16YM@            (setq #i (1+ #i))
;;;01/02/16YM@          )
;;;01/02/16YM@        )
;;;01/02/16YM@      );_if
;;;01/02/16YM@      (setq #SNK$$ (append #SNK$$ (list (list #enSNK #enSNKCAB #snkPen1 #snkPen4))))
;;;01/02/16YM@    );_foreach
;;;01/02/16YM@  );_if
;;;01/02/16YM@
;;;01/02/16YM@;;; (ｺﾝﾛ,ｺﾝﾛｷｬﾋﾞ,P面5)のﾘｽﾄを求める
;;;01/02/16YM@  (setq #enGASCAB$ '())
;;;01/02/16YM@  (setq #GAS$$ '())
;;;01/02/16YM@;;; 点列はWT左上点を始点とし、時計周り
;;;01/02/16YM@  (setq #enGASCAB$ (PKGetSymBySKKCodeCP2 #pt$)) ; ｺﾝﾛｷｬﾋﾞ
;;;01/02/16YM@  (if #enGASCAB$
;;;01/02/16YM@    (foreach #enGASCAB #enGASCAB$
;;;01/02/16YM@      (setq #enGAS   nil)
;;;01/02/16YM@      (setq #GasPen5 nil)
;;;01/02/16YM@
;;;01/02/16YM@      (setq #enGAS (PKGetGasSymByGasCabCP #enGASCAB)) ; ｺﾝﾛ
;;;01/02/16YM@
;;;01/02/16YM@      (if #enGAS ; ｺﾝﾛがあったら PMEN5 を求める
;;;01/02/16YM@        (progn
;;;01/02/16YM@          (setq #p-ss (CFGetSameGroupSS #enGAS))
;;;01/02/16YM@          (setq #i 0)
;;;01/02/16YM@          (repeat (sslength #p-ss)
;;;01/02/16YM@            (setq #en (ssname #p-ss #i))
;;;01/02/16YM@            (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
;;;01/02/16YM@            (if (and #xd$ (= 5 (car #xd$)))       ; PMEN5を使用する
;;;01/02/16YM@              (setq #GasPen5 #en)
;;;01/02/16YM@            );_(if
;;;01/02/16YM@            (setq #i (1+ #i))
;;;01/02/16YM@          )
;;;01/02/16YM@        )
;;;01/02/16YM@      );_if
;;;01/02/16YM@      (setq #GAS$$ (append #GAS$$ (list (list #enGAS #enGASCAB #GasPen5))))
;;;01/02/16YM@    );_foreach
;;;01/02/16YM@  );_if
;;;01/02/16YM@
;;;01/02/16YM@;;; 水栓ｼﾝﾎﾞﾙﾘｽﾄを求める
;;;01/02/16YM@  (setq #eWTR$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; 水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
;;;01/02/16YM@  (list #SNK$$ #GAS$$ #eWTR$)
;;;01/02/16YM@);PKW_GetWorkTopAreaSym3

;;;<HOM>*************************************************************************
;;; <関数名>    : PKMultiSnkGas
;;; <処理概要>  : ｼﾝｸ、ｺﾝﾛの数が３つ以上あるかどうかﾁｪｯｸする
;;; <戻り値>    : あればT なければnil
;;; <作成>      : 07/06 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKMultiSnkGas (
  &pt$ ;WT外形点列(始点を末尾に追加済み)
  /
  #GAS$ #SNK$
  )

  (setq #snk$ (PKGetSymBySKKCodeCP &pt$ CG_SKK_INT_SNK)) ; ｼﾝｸｼﾝﾎﾞﾙﾘｽﾄ ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
  (setq #gas$ (PKGetSymBySKKCodeCP &pt$ CG_SKK_INT_GAS)) ; ｺﾝﾛｼﾝﾎﾞﾙﾘｽﾄ ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
  (if (<= 3 (+ (length #snk$)(length #gas$)))
    T   ; ３つ以上
    nil ; OK
  );\if

);PKMultiSnkGas


;;;/////////////////////////////////////////////////////////////////////////////
;;;/////////////////////////////////////////////////////////////////////////////
;;;/////////////////////////////////////////////////////////////////////////////

;;;01/06/28YM@;<HOM>*************************************************************************
;;;01/06/28YM@; <関数名>    : C:StretchWkTop
;;;01/06/28YM@; <処理概要>  : ワークトップ間口伸縮
;;;01/06/28YM@; <戻り値>    :
;;;01/06/28YM@; <作成>      : 1999-10-21 新型WT対応 2000.4.13 YM
;;;01/06/28YM@; <備考>      : 底面を作り直す(stretchを使わない旧いﾊﾞｰｼﾞｮﾝ)
;;;01/06/28YM@;*************************************************************************>MOH<
;;;01/06/28YM@(defun C:StretchWkTop (
;;;01/06/28YM@  /
;;;01/06/28YM@  #55 #ANG #BASEPT #BASE_NEW #BG #BG0 #BG_H #BG_PT$ #BG_REGION #BG_SEP
;;;01/06/28YM@  #BG_SOLID #BG_T #BG_TEI #BG_TEI1 #BG_TEI2 #CL #CR #CUTL #CUTR #CUTTYPE
;;;01/06/28YM@  #D150BG #DEP #FG #FG01 #FG02 #FG1_PT$ #FG2_PT$ #FG_H #FG_REGION #FG_S
;;;01/06/28YM@  #FG_SOLID1 #FG_SOLID2 #FG_T #FG_TEI1 #FG_TEI2 #FLG #ISTRETCH #LOOP #P2 #PD
;;;01/06/28YM@  #PTS #RET$ #SS #TYPE0 #WT #WT0 #WTEN #WTL #WTLEN1 #WTLEN2 #WTLEN3 #WTR #WT_H
;;;01/06/28YM@  #WT_LEN$ #WT_PT$ #WT_REGION #WT_SOLID #WT_T #WT_TEI #XD$ #XD0$ #XDL$ #XDR$
;;;01/06/28YM@  #X #XD_NEW$ #ZAICODE #KAIJO #YESNOMSG #ZAIF
;;;01/06/28YM@  )
;;;01/06/28YM@
;;;01/06/28YM@; 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
;;;01/06/28YM@(if (equal (KPGetSinaType) 2 0.1)
;;;01/06/28YM@  (progn
;;;01/06/28YM@    (CFAlertMsg msg8)
;;;01/06/28YM@    (quit)
;;;01/06/28YM@  )
;;;01/06/28YM@  (progn
;;;01/06/28YM@
;;;01/06/28YM@  (CFOutStateLog 1 1 " ")
;;;01/06/28YM@  (CFOutStateLog 1 1 "//// C:StretchWkTop ////")
;;;01/06/28YM@  (CFOutStateLog 1 1 " ")
;;;01/06/28YM@  (setq #KAIJO nil)  ; 品番確定解除ﾌﾗｸﾞ
;;;01/06/28YM@
;;;01/06/28YM@  ;// コマンドの初期化
;;;01/06/28YM@  (StartUndoErr)
;;;01/06/28YM@  (CFCmdDefBegin 6);00/09/26 SN ADD
;;;01/06/28YM@  (setq #PD (getvar "pdmode")) ; 06/12 YM
;;;01/06/28YM@  (setvar "pdmode" 34)         ; 06/12 YM
;;;01/06/28YM@
;;;01/06/28YM@  ;// ワークトップの指示
;;;01/06/28YM@  (initget 0)
;;;01/06/28YM@  (setq #loop T)
;;;01/06/28YM@  (while #loop
;;;01/06/28YM@    (setq #wtEn (car (entsel "\nワークトップを選択: ")))
;;;01/06/28YM@    (if #wtEn
;;;01/06/28YM@      (setq #xd$ (CFGetXData #wten "G_WRKT"))
;;;01/06/28YM@      (setq #xd$ nil)
;;;01/06/28YM@    );_if
;;;01/06/28YM@    (if (= #xd$ nil)
;;;01/06/28YM@      (CFAlertMsg "ワークトップではありません。")
;;;01/06/28YM@    ;else
;;;01/06/28YM@      (cond
;;;01/06/28YM@        ((CFGetXData #wtEn "G_WTSET")
;;;01/06/28YM@          (setq #YesNoMsg "ワークトップは品番確定されています。\n処理を続けますか？")
;;;01/06/28YM@          (if (CFYesNoDialog #YesNoMsg)
;;;01/06/28YM@            (progn
;;;01/06/28YM@              (setq #loop nil) ; YES なら継続
;;;01/06/28YM@              (setq #KAIJO T)  ; 品番確定解除ﾌﾗｸﾞ
;;;01/06/28YM@            )
;;;01/06/28YM@            (*error*)        ; NO  ならSTOP
;;;01/06/28YM@          );_if
;;;01/06/28YM@        )
;;;01/06/28YM@        (T
;;;01/06/28YM@          (setq #loop nil)
;;;01/06/28YM@        )
;;;01/06/28YM@      );_cond
;;;01/06/28YM@    );_if
;;;01/06/28YM@
;;;01/06/28YM@  );while
;;;01/06/28YM@
;;;01/06/28YM@  (PCW_ChColWT #wtEn "MAGENTA" nil) ; 色を変える
;;;01/06/28YM@
;;;01/06/28YM@  (setq #CutType (nth 7 #xd$))         ; ｶｯﾄﾀｲﾌﾟ
;;;01/06/28YM@;;; ｶｯﾄ記号
;;;01/06/28YM@  (setq #CL (substr #CutType 1 1))
;;;01/06/28YM@  (setq #CR (substr #CutType 2 1))
;;;01/06/28YM@
;;;01/06/28YM@  (cond
;;;01/06/28YM@    ((and (= #CL "0") (= #CR "0")) ; ステンL型 or I型
;;;01/06/28YM@      (initget 1 "Left Right")
;;;01/06/28YM@;;;      (initget 1)
;;;01/06/28YM@;;;      (setq #pts (getpoint "\n伸縮側を指示: "))
;;;01/06/28YM@      (setq #x (getkword "\n伸縮側を指示 /L=左/R=右/:  "))
;;;01/06/28YM@    )
;;;01/06/28YM@    ((and (/= #CL "0") (/= #CR "0"))
;;;01/06/28YM@      (CFAlertMsg "このワークトップは伸縮できません。")(quit)
;;;01/06/28YM@    )
;;;01/06/28YM@    ((and (= #CL "0") (/= #CR "0"))
;;;01/06/28YM@      (setq #x "Left")
;;;01/06/28YM@    )
;;;01/06/28YM@    ((and (/= #CL "0") (= #CR "0"))
;;;01/06/28YM@      (setq #x "Right")
;;;01/06/28YM@    )
;;;01/06/28YM@  );_cond
;;;01/06/28YM@
;;;01/06/28YM@  (setq #iStretch (getdist "\n伸縮量: "))
;;;01/06/28YM@  (if (= #iStretch nil) (setq #iStretch 0))
;;;01/06/28YM@
;;;01/06/28YM@  (PCW_ChColWT #wtEn "BYLAYER" nil)
;;;01/06/28YM@
;;;01/06/28YM@  ;// Ｏスナップ関連システム変数の解除
;;;01/06/28YM@  (CFNoSnapStart) ; 00/02/07@YM@
;;;01/06/28YM@
;;;01/06/28YM@  (setq #ZaiCode (nth 2 #xd$))
;;;01/06/28YM@  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
;;;01/06/28YM@
;;;01/06/28YM@  (setq #WT_H (nth  8 #xd$))  ; WT高さ
;;;01/06/28YM@  (setq #WT_T (nth 10 #xd$))  ; WT厚み
;;;01/06/28YM@  (setq #BG_H (nth 12 #xd$))  ; BG高さ
;;;01/06/28YM@  (if (equal #BG_H 150 0.1)
;;;01/06/28YM@    (setq #D150BG T)
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (setq #BG_T (nth 13 #xd$))  ; BG厚み
;;;01/06/28YM@  (setq #FG_H (nth 15 #xd$))  ; FG高さ
;;;01/06/28YM@  (setq #FG_T (nth 16 #xd$))  ; FG厚み
;;;01/06/28YM@  (setq #FG_S (nth 17 #xd$))  ; FGｼﾌﾄ量
;;;01/06/28YM@  (setq #cutL (nth 36 #xd$))  ; カット左
;;;01/06/28YM@  (setq #cutR (nth 37 #xd$))  ; カット右
;;;01/06/28YM@  (setq #WT_LEN$  (nth 55 #xd$))    ; WT長さ
;;;01/06/28YM@  (setq #dep (car (nth 57 #xd$)))   ; WT奥行き
;;;01/06/28YM@
;;;01/06/28YM@  (setq #WT_tei (nth 38 #xd$))             ; WT底面図形ﾊﾝﾄﾞﾙ
;;;01/06/28YM@  (setq #BASEPT (nth 32 #xd$))             ; WT左上点
;;;01/06/28YM@  (setq #BG_tei1 (nth 49 #xd$))            ; BG SOLID1 or 底面1
;;;01/06/28YM@  (setq #BG_tei2 (nth 50 #xd$))            ; BG SOLID2 or 底面2 もしあればそのまま
;;;01/06/28YM@
;;;01/06/28YM@  (if (= (cdr (assoc 0 (entget #BG_tei1))) "3DSOLID") ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型 00/09/29 YM MOD
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (setq #BG_SEP 1) ; 分離型
;;;01/06/28YM@      (if (/= #BG_tei1 "")
;;;01/06/28YM@        (if (setq #xd0$ (CFGetXData #BG_tei1 "G_BKGD"))
;;;01/06/28YM@          (setq #BG_tei1 (nth 1 #xd0$)) ; BG1底面ﾎﾟﾘﾗｲﾝ
;;;01/06/28YM@        )
;;;01/06/28YM@      )
;;;01/06/28YM@      (if (/= #BG_tei2 "")
;;;01/06/28YM@        (if (setq #xd0$ (CFGetXData #BG_tei2 "G_BKGD"))
;;;01/06/28YM@          (setq #BG_tei2 (nth 1 #xd0$)) ; BG2底面ﾎﾟﾘﾗｲﾝ もしあればそのまま
;;;01/06/28YM@        );_if
;;;01/06/28YM@      );_if
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (setq #BG_pt$ nil #FG1_pt$ nil #FG2_pt$ nil)
;;;01/06/28YM@
;;;01/06/28YM@  (setq #FG_tei1 (nth 51 #xd$))               ; FG1底面 *
;;;01/06/28YM@  (setq #FG_tei2 (nth 52 #xd$))               ; F2G底面 *
;;;01/06/28YM@  (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))    ; WT外形点列
;;;01/06/28YM@  (if (/= #BG_tei1 "")
;;;01/06/28YM@    (setq #BG_pt$ (GetLWPolyLinePt #BG_tei1))   ; BG1外形点列
;;;01/06/28YM@  )
;;;01/06/28YM@  (if (/= #FG_tei1 "")
;;;01/06/28YM@    (setq #FG1_pt$ (GetLWPolyLinePt #FG_tei1))  ; FG1外形点列
;;;01/06/28YM@  );_if
;;;01/06/28YM@  (if (/= #FG_tei2 "")
;;;01/06/28YM@    (setq #FG2_pt$ (GetLWPolyLinePt #FG_tei2)); FG2外形点列
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  ;// 既存のワークトップを削除
;;;01/06/28YM@  (entdel #wtEn)
;;;01/06/28YM@  (if (/= #FG_tei1 "")(entdel #FG_tei1))
;;;01/06/28YM@  (if (/= #FG_tei2 "")(entdel #FG_tei2))
;;;01/06/28YM@  (if (/= #BG_tei1 "")(entdel #BG_tei1))
;;;01/06/28YM@  (entdel #WT_tei)
;;;01/06/28YM@
;;;01/06/28YM@; BGｿﾘｯﾄﾞ1の削除 1つのWTでBGが2つある場合、BGｿﾘｯﾄﾞ2は伸縮しないから消さない
;;;01/06/28YM@  (if (= #BG_SEP 1) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
;;;01/06/28YM@    (if (and (/= (nth 49 #xd$) "")
;;;01/06/28YM@             (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID"))
;;;01/06/28YM@      (entdel (nth 49 #xd$)) ; BGｿﾘｯﾄﾞ1の削除
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@;;; 底面をｽﾄﾚｯﾁ
;;;01/06/28YM@;;;  1                          2                  4  4                       2
;;;01/06/28YM@;;;  +--------------------------+   +--------------+  +-----------------------+
;;;01/06/28YM@;;;  |                          |   |              |  |                       |
;;;01/06/28YM@;;;  |                          |   |              |  |                       |
;;;01/06/28YM@;;;  |       5                  |   |              |  |                       |
;;;01/06/28YM@;;;  |       +------------------+   |       +------+  |                       |
;;;01/06/28YM@;;;  |       |                  1   |       |      3  +-----------------------+
;;;01/06/28YM@;;;  |       |                      |       |         3                       1
;;;01/06/28YM@;;;  |       |                      |       |
;;;01/06/28YM@;;;  +-------+                      |       |
;;;01/06/28YM@;;; 4        3                      |       |
;;;01/06/28YM@;;;                                 |       |
;;;01/06/28YM@;;;                                 |       |
;;;01/06/28YM@;;;                                 +-------+
;;;01/06/28YM@;;;                                2         1
;;;01/06/28YM@;;;
;;;01/06/28YM@
;;;01/06/28YM@;;; 底面をｽﾄﾚｯﾁ
;;;01/06/28YM@  (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT 左上点
;;;01/06/28YM@  (setq #p2 (nth 1 #WT_pt$))
;;;01/06/28YM@
;;;01/06/28YM@  (if (and (equal #ZaiF 1 0.1)(= (nth 3 #xd$) 1))
;;;01/06/28YM@    (progn ; L形状 00/09/28 YM
;;;01/06/28YM@      (setq #type0 "SL")
;;;01/06/28YM@      (if (= #x "Left") (setq #pts (last #WT_pt$)))
;;;01/06/28YM@      (if (= #x "Right") (setq #pts #p2))
;;;01/06/28YM@      (if (< (distance #pts #p2) (distance #pts (last #WT_pt$))) ; 伸縮方向
;;;01/06/28YM@        (progn
;;;01/06/28YM@          (setq #ang (angle #BASEPT #p2))
;;;01/06/28YM@          (setq #base_new #BASEPT)
;;;01/06/28YM@          (setq  #flg "R") ; 右方向
;;;01/06/28YM@        )
;;;01/06/28YM@        (progn
;;;01/06/28YM@          (setq #ang (angle #BASEPT (last #WT_pt$)))
;;;01/06/28YM@          (setq #base_new #BASEPT)
;;;01/06/28YM@          (setq #flg "L") ; L 下方向
;;;01/06/28YM@        )
;;;01/06/28YM@      )
;;;01/06/28YM@    )
;;;01/06/28YM@    (progn ; L形状以外
;;;01/06/28YM@      (setq #type0 nil)
;;;01/06/28YM@      (if (= #x "Left") (setq #pts #BASEPT))
;;;01/06/28YM@      (if (= #x "Right") (setq #pts #p2))
;;;01/06/28YM@      (if (< (distance #pts #p2) (distance #pts #BASEPT)) ; 伸縮方向
;;;01/06/28YM@        (progn
;;;01/06/28YM@          (setq #ang (angle #BASEPT #p2))
;;;01/06/28YM@          (setq #base_new #BASEPT)
;;;01/06/28YM@          (setq #flg "R") ; 右方向
;;;01/06/28YM@        )
;;;01/06/28YM@        (progn
;;;01/06/28YM@          (setq #ang (angle #p2 #BASEPT))
;;;01/06/28YM@          (setq #base_new (polar #BASEPT #ang #iStretch))
;;;01/06/28YM@          (setq #flg "L") ; 左方向
;;;01/06/28YM@        )
;;;01/06/28YM@      )
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (setq #ret$ (PKSTRETCH_TEI  #flg #type0 #WT_pt$ #BG_pt$ #FG1_pt$ #FG2_pt$ #BASEPT #ang #iStretch))
;;;01/06/28YM@  (setq #WT_pt$  (nth 0 #ret$))
;;;01/06/28YM@  (setq #BG_pt$  (nth 1 #ret$))
;;;01/06/28YM@  (setq #FG1_pt$ (nth 2 #ret$))
;;;01/06/28YM@  (setq #FG2_pt$ (nth 3 #ret$))
;;;01/06/28YM@
;;;01/06/28YM@  (setq #BG_SOLID nil #FG_SOLID1 nil #FG_SOLID2 nil)
;;;01/06/28YM@  (setq #BG0 nil #FG01 nil #FG02 nil)
;;;01/06/28YM@;;; WT再作成
;;;01/06/28YM@  (MakeLWPL #WT_pt$ 1)
;;;01/06/28YM@  (setq #WT0 (entlast)) ; 残す
;;;01/06/28YM@  (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #WT0)) (entget #WT0))) ; 底面ﾎﾟﾘﾗｲﾝ
;;;01/06/28YM@  (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT0)) (entget #WT0)))
;;;01/06/28YM@  (setq #WT (entlast)) ; 残す
;;;01/06/28YM@  (setq #WT_region (Make_Region2 #WT))
;;;01/06/28YM@  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
;;;01/06/28YM@;;; BG再作成
;;;01/06/28YM@  (if #BG_pt$
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (MakeLWPL #BG_pt$ 1)
;;;01/06/28YM@      (setq #BG0 (entlast)) ; 残す
;;;01/06/28YM@      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG0)) (entget #BG0))) ; 底面ﾎﾟﾘﾗｲﾝ
;;;01/06/28YM@      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG0)) (entget #BG0)))
;;;01/06/28YM@      (setq #BG (entlast)) ; 残す
;;;01/06/28YM@      (setq #BG_region (Make_Region2 #BG))
;;;01/06/28YM@      (setq #BG_SOLID  (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@;;; FG1再作成
;;;01/06/28YM@  (if #FG1_pt$
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (MakeLWPL #FG1_pt$ 1)
;;;01/06/28YM@      (setq #FG01 (entlast)) ; 残す
;;;01/06/28YM@      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG01)) (entget #FG01))) ; 底面ﾎﾟﾘﾗｲﾝ
;;;01/06/28YM@      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG01)) (entget #FG01)))
;;;01/06/28YM@      (setq #FG (entlast)) ; 残す
;;;01/06/28YM@      (setq #FG_region (Make_Region2 #FG))
;;;01/06/28YM@      (setq #FG_SOLID1  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@;;; FG2再作成
;;;01/06/28YM@  (if #FG2_pt$
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (MakeLWPL #FG2_pt$ 1)
;;;01/06/28YM@      (setq #FG02 (entlast)) ; 残す
;;;01/06/28YM@      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG02)) (entget #FG02))) ; 底面ﾎﾟﾘﾗｲﾝ
;;;01/06/28YM@      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG02)) (entget #FG02)))
;;;01/06/28YM@      (setq #FG (entlast)) ; 残す
;;;01/06/28YM@      (setq #FG_region (Make_Region2 #FG))
;;;01/06/28YM@      (setq #FG_SOLID2  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (setq #ss (ssadd))
;;;01/06/28YM@  (ssadd #WT_SOLID #ss)
;;;01/06/28YM@  (if #FG_SOLID1 (ssadd #FG_SOLID1 #ss))
;;;01/06/28YM@  (if #FG_SOLID2 (ssadd #FG_SOLID2 #ss))
;;;01/06/28YM@
;;;01/06/28YM@  (if (= #BG_SEP 1) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
;;;01/06/28YM@    (progn ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
;;;01/06/28YM@      (command "_union" #ss "") ; 交わらない領域でもＯＫ！
;;;01/06/28YM@      (if #BG_SOLID
;;;01/06/28YM@        (setq #BG_tei #BG_SOLID)
;;;01/06/28YM@        (setq #BG_tei "")
;;;01/06/28YM@      );_if
;;;01/06/28YM@    )
;;;01/06/28YM@    (progn ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型以外
;;;01/06/28YM@      (if #BG_SOLID
;;;01/06/28YM@        (ssadd #BG_SOLID #ss)
;;;01/06/28YM@      );_if
;;;01/06/28YM@      (command "_union" #ss "") ; 交わらない領域でもＯＫ！
;;;01/06/28YM@      (if #BG0
;;;01/06/28YM@        (setq #BG_tei #BG0)
;;;01/06/28YM@        (setq #BG_tei "")
;;;01/06/28YM@      );_if
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (if #FG01
;;;01/06/28YM@    (setq #FG_tei1 #FG01)
;;;01/06/28YM@    (setq #FG_tei1 "")
;;;01/06/28YM@  );_if
;;;01/06/28YM@  (if #FG02
;;;01/06/28YM@    (setq #FG_tei2 #FG02)
;;;01/06/28YM@    (setq #FG_tei2 "")
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (if (and (= #type0 "SL")(= #flg "L")) ; ｽﾃﾝﾚｽL型 のｺﾝﾛ側伸縮を行った場合
;;;01/06/28YM@    (setq #55 (mapcar '+ (nth 55 #xd$) (list 0.0 #iStretch 0.0)));[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 ***
;;;01/06/28YM@    (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 ***
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (setq #WTLEN1 (nth 0 #55))
;;;01/06/28YM@  (setq #WTLEN2 (nth 1 #55))
;;;01/06/28YM@  (setq #WTLEN3 (nth 2 #55))
;;;01/06/28YM@
;;;01/06/28YM@  (setq #xd_new$
;;;01/06/28YM@  (list
;;;01/06/28YM@    (list 32 #base_new) ; 33.コーナー原点  WT左上点
;;;01/06/28YM@    (list 38 #WT0)      ;[39]WT底面図形ﾊﾝﾄﾞﾙ
;;;01/06/28YM@    (list 49 #BG_tei)   ;[50]分離型の場合BG1 SOLID図形ﾊﾝﾄﾞﾙ  それ以外は底面図形ﾊﾝﾄﾞﾙ @@@ *
;;;01/06/28YM@    (list 51 #FG_tei1)  ;[52]FG1 底面図形ﾊﾝﾄﾞﾙ *
;;;01/06/28YM@    (list 52 #FG_tei2)  ;[53]FG2 底面図形ﾊﾝﾄﾞﾙ *
;;;01/06/28YM@    (list 55 #55)       ;[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 *** 00/05/01 YM
;;;01/06/28YM@  ))
;;;01/06/28YM@
;;;01/06/28YM@  ;// 拡張データの再設定
;;;01/06/28YM@  (CFSetXData #WT_SOLID "G_WRKT"
;;;01/06/28YM@    (CFModList #xd$ #xd_new$)
;;;01/06/28YM@  )
;;;01/06/28YM@
;;;01/06/28YM@  (setq #WTL (nth 47 #xd$)) ; ｶｯﾄ相手WT左
;;;01/06/28YM@  (setq #WTR (nth 48 #xd$)) ; ｶｯﾄ相手WT右
;;;01/06/28YM@
;;;01/06/28YM@  ;// 相手側ワークトップの拡張データも更新する
;;;01/06/28YM@  (if (and (/= #WTL "") (/= #WTL nil))
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; 左側
;;;01/06/28YM@      (CFSetXData #WTL "G_WRKT"
;;;01/06/28YM@        (CFModList #xdL$
;;;01/06/28YM@          (list
;;;01/06/28YM@            (list 48 #WT_SOLID)     ;[49]カット相手WTﾊﾝﾄﾞﾙ右 U型は左右にある
;;;01/06/28YM@          )
;;;01/06/28YM@        )
;;;01/06/28YM@      )
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (if (and (/= #WTR "") (/= #WTR nil))
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; 右側
;;;01/06/28YM@      (CFSetXData #WTR "G_WRKT"
;;;01/06/28YM@        (CFModList
;;;01/06/28YM@          #xdR$
;;;01/06/28YM@          (list
;;;01/06/28YM@            (list 47 #WT_SOLID)     ;[48]カット相手WTﾊﾝﾄﾞﾙ左 U型は左右にある
;;;01/06/28YM@          )
;;;01/06/28YM@        )
;;;01/06/28YM@      )
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@;;; 拡張ﾃﾞｰﾀ G_BKGDのｾｯﾄ
;;;01/06/28YM@;;; 1. 品番名称
;;;01/06/28YM@;;; 2. BG底面図形ﾊﾝﾄﾞﾙ
;;;01/06/28YM@;;; 3. 関連WT図形ﾊﾝﾄﾞﾙ
;;;01/06/28YM@  (if (= #BG_SEP 1) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (if #BG_SOLID
;;;01/06/28YM@        (progn
;;;01/06/28YM@          (PKSetBGXData
;;;01/06/28YM@            (list #BG_SOLID (nth 50 #xd$)) ; BG図形名ﾘｽﾄ (list #BG_SOLID1 #BG_SOLID2)
;;;01/06/28YM@            #cutL         ; WTｶｯﾄ左
;;;01/06/28YM@            #cutR         ; WTｶｯﾄ右
;;;01/06/28YM@            (nth 2 #xd$)  ; 材質記号
;;;01/06/28YM@            (list #BG0 #BG_tei2) ; BG底面図形名 (list #BG01 #BG02)
;;;01/06/28YM@            #WT_SOLID   ; 関連WT図形名
;;;01/06/28YM@            #D150BG ; D150BG
;;;01/06/28YM@          )
;;;01/06/28YM@        )
;;;01/06/28YM@      );_if
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (CFCmdDefFinish);00/09/26 SN ADD
;;;01/06/28YM@  (setvar "pdmode" #PD) ; 06/12 YM
;;;01/06/28YM@  (if #KAIJO
;;;01/06/28YM@    (princ "\n品番確定が解除されました。")
;;;01/06/28YM@  );_if
;;;01/06/28YM@  (princ)
;;;01/06/28YM@
;;;01/06/28YM@  ); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
;;;01/06/28YM@);_if
;;;01/06/28YM@
;;;01/06/28YM@);C:StretchWkTop

;<HOM>*************************************************************************
; <関数名>    : C:StretchWkTop
; <処理概要>  : ワークトップ間口伸縮
; <戻り値>    :
; <作成>      : 1999-10-21 新型WT対応 2000.4.13 YM
; <備考>      : 底面をstretchする(新しいﾊﾞｰｼﾞｮﾝ)
;*************************************************************************>MOH<
(defun C:StretchWkTop (
  /
  #55 #ANG #BASEPT #BASE_NEW #BG #BG0 #BG_H #BG_REGION #BG_SEP #BG_SOLID
  #BG_T #BG_TEI #BG_TEI1 #BG_TEI2 #CL #CR #CUTL #CUTR #CUTTYPE #D150BG #DEP
  #FG #FG01 #FG02 #FG_H #FG_REGION #FG_S #FG_SOLID1 #FG_SOLID2 #FG_T #FG_TEI1 #FG_TEI2
  #FLG #GRIDMODE #ISTRETCH #KAIJO #LOOP #ORTHOMODE #OSMODE #P1 #P2 #P3 #P4 #P5 #P6
  #PD #PTE #PTS #SNAPMODE #SS #SSTRETCH #TYPE0 #UF #WT #WT0 #WTEN #WTL #WTLEN1 #WTLEN2 #WTLEN3
  #WTR #WT_H #WT_LEN$ #WT_PT$ #WT_REGION #WT_SOLID #WT_T #WT_TEI #X
  #XD$ #XD0$ #XDL$ #XDR$ #XD_NEW$ #YESNOMSG #ZAICODE #ZAIF
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:StretchWkTop ////")
  (CFOutStateLog 1 1 " ")
  (setq #KAIJO nil)  ; 品番確定解除ﾌﾗｸﾞ

  ;// コマンドの初期化
  (StartUndoErr)

	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)

; 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)

  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM

  ;// ワークトップの指示
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\nワークトップを選択: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "ワークトップではありません。")
    ;else
      (cond
        ; 02/08/29 YM ADD-S R付天板は間口伸縮不可
        ((= 1 (nth 33 #xd$))
          (CFAlertMsg "このワークトップは間口伸縮できません。")
          (*error*)
        )
        ; 02/08/29 YM ADD-E
        ((CFGetXData #wtEn "G_WTSET")
          (setq #YesNoMsg "ワークトップは品番確定されています。\n処理を続けますか？")
          (if (CFYesNoDialog #YesNoMsg)
            (progn
              (setq #loop nil) ; YES なら継続
              (setq #KAIJO T)  ; 品番確定解除ﾌﾗｸﾞ
            )
            (*error*)        ; NO  ならSTOP
          );_if
        )
        (T
          (setq #loop nil)
        )
      );_cond
    );_if

  );while

  (PCW_ChColWT #wtEn "MAGENTA" nil) ; 色を変える

  (setq #CutType (nth 7 #xd$))         ; ｶｯﾄﾀｲﾌﾟ
;;; ｶｯﾄ記号
  (setq #CL (substr #CutType 1 1))
  (setq #CR (substr #CutType 2 1))

  ; ｶﾞｲﾀﾞﾝｽ表示
  (cond
    ((and (= #CL "0") (= #CR "0")) ; ステンL型 or I型
      (initget 1 "Left Right")
;;;      (initget 1)
;;;      (setq #pts (getpoint "\n伸縮側を指示: "))
      (setq #x (getkword "\n伸縮側を指示 /L=左/R=右/:  "))
    )
    ((and (/= #CL "0") (/= #CR "0"))
      (CFAlertMsg "このワークトップは伸縮できません。")(quit)
    )
    ((and (= #CL "0") (/= #CR "0"))
      (setq #x "Left")
    )
    ((and (/= #CL "0") (= #CR "0"))
      (setq #x "Right")
    )
  );_cond

  (setq #iStretch (getdist "\n伸縮量: "))
  (if (= #iStretch nil) (setq #iStretch 0))
  (cond
    ((= #x "Left")
      ; 01/08/29 YM ADD-S
      (if (< #iStretch 0)
        (setq #sStretch (strcat "@"  (rtos (abs #iStretch)) ",0")) ; 負のとき
        (setq #sStretch (strcat "@-" (rtos (abs #iStretch)) ",0")) ; 正のとき
      );_if
      ; 01/08/29 YM ADD-E
;;;01/08/29YM@DEL     (setq #sStretch (strcat "@-" (rtos #iStretch) ",0"))
    )
    ((= #x "Right")
      (setq #sStretch (strcat "@" (rtos #iStretch) ",0"))
    )
  );_cond

  (PCW_ChColWT #wtEn "BYLAYER" nil)

  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart) ; 00/02/07@YM@

  (setq #ZaiCode (nth 2 #xd$))
  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ

  (setq #WT_H (nth  8 #xd$))  ; WT高さ
  (setq #WT_T (nth 10 #xd$))  ; WT厚み
  (setq #BG_H (nth 12 #xd$))  ; BG高さ
  (if (equal #BG_H 150 0.1)
    (setq #D150BG T)
  );_if

  (setq #BG_T (nth 13 #xd$))  ; BG厚み
  (setq #FG_H (nth 15 #xd$))  ; FG高さ
  (setq #FG_T (nth 16 #xd$))  ; FG厚み
  (setq #FG_S (nth 17 #xd$))  ; FGｼﾌﾄ量
;-- 2011/09/01 A.Satoh Mod - S
;  (setq #cutL (nth 36 #xd$))  ; カット左
;  (setq #cutR (nth 37 #xd$))  ; カット右
  (setq #cutL "")  ; カット左
  (setq #cutR "")  ; カット右
;-- 2011/09/01 A.Satoh Mod - S
  (setq #WT_LEN$  (nth 55 #xd$)) ; WT長さ
  (setq #dep (car (nth 57 #xd$))); WT奥行き
  ; 各底面取得
  (setq #WT_tei (nth 38 #xd$))   ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BASEPT (nth 32 #xd$))   ; WT左上点
  (setq #BG_tei1 (nth 49 #xd$))  ; BG SOLID1 or 底面1
  (setq #BG_tei2 (nth 50 #xd$))  ; BG SOLID2 or 底面2 もしあればそのまま

  (if (and (/= #BG_tei1 "")
           (= (cdr (assoc 0 (entget #BG_tei1))) "3DSOLID")) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型 00/09/29 YM MOD
    (progn
      (setq #BG_SEP 1) ; 分離型
      (if (setq #xd0$ (CFGetXData #BG_tei1 "G_BKGD"))
        (setq #BG_tei1 (nth 1 #xd0$)) ; BG1底面ﾎﾟﾘﾗｲﾝ
      )
      (if (/= #BG_tei2 "")
        (if (setq #xd0$ (CFGetXData #BG_tei2 "G_BKGD"))
          (setq #BG_tei2 (nth 1 #xd0$)) ; BG2底面ﾎﾟﾘﾗｲﾝ もしあればそのまま
        );_if
      );_if
    )
  );_if

  (setq #FG_tei1 (nth 51 #xd$))               ; FG1底面 *
  (setq #FG_tei2 (nth 52 #xd$))               ; F2G底面 *

;;; ; 各底面点列取得
;;; (setq #BG_pt$ nil #FG1_pt$ nil #FG2_pt$ nil)
  (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))    ; WT外形点列
;;;  (if (/= #BG_tei1 "")
;;;   (setq #BG_pt$ (GetLWPolyLinePt #BG_tei1)) ; BG1外形点列
;;; )
;;;  (if (/= #FG_tei1 "")
;;;   (setq #FG1_pt$ (GetLWPolyLinePt #FG_tei1)); FG1外形点列
;;; );_if
;;;  (if (/= #FG_tei2 "")
;;;   (setq #FG2_pt$ (GetLWPolyLinePt #FG_tei2)); FG2外形点列
;;; );_if

  ;// 既存のワークトップ(前垂れ込み3DSOLID)を削除
  (entdel #wtEn)
;;;  (if (/= #FG_tei1 "")(entdel #FG_tei1))
;;;  (if (/= #FG_tei2 "")(entdel #FG_tei2))
;;;  (if (/= #BG_tei1 "")(entdel #BG_tei1))
;;;  (entdel #WT_tei)

; BGｿﾘｯﾄﾞ1の削除 1つのWTでBGが2つある場合、BGｿﾘｯﾄﾞ2は伸縮しないから消さない
  (if (= #BG_SEP 1) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
    (if (and (/= (nth 49 #xd$) "")
             (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID"))
      (entdel (nth 49 #xd$)) ; BGｿﾘｯﾄﾞ1の削除
    )
  );_if

;;; 底面をｽﾄﾚｯﾁ
;;;  1                          2                  4  4                       2
;;;  +--------------------------+   +--------------+  +-----------------------+
;;;  |                          |   |              |  |                       |
;;;  |                          |   |              |  |                       |
;;;  |       5                  |   |              |  |                       |
;;;  |       +------------------+   |       +------+  |                       |
;;;  |       |                  1   |       |      3  +-----------------------+
;;;  |       |                      |       |         3                       1
;;;  |       |                      |       |
;;;  +-------+                      |       |
;;; 4        3                      |       |
;;;                                 |       |
;;;                                 |       |
;;;                                 +-------+
;;;                                2         1
;;;

;;; 底面をｽﾄﾚｯﾁ

  (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT 左上点から時計周りに並び替える

  ; ucs変更後のﾋﾞｭｰを真上からにする
  (setq #uf (getvar "UCSFOLLOW"))
  (setvar "UCSFOLLOW"  1)
  ; WT底面画層ﾌﾘｰｽﾞ解除
  (command "_layer" "T" SKW_AUTO_SECTION "")

  ;// ビューを登録
  (command "_view" "S" "TEMP_MG")

;-- 2011/09/01 A.Satoh Mod - S
;  (if (and (not (equal (KPGetSinaType) -1 0.1))
;;;;          (equal #ZaiF 1 0.1) ;2010/01/08 YM DEL
;           (= (nth 3 #xd$) 1)(= (length #WT_pt$) 6))
;    (progn ; L形状 00/09/28 YM
;      (setq #type0 "SL")
;      (setq #p1 (nth 0 #WT_pt$))
;      (setq #p2 (nth 1 #WT_pt$))
;      (setq #p3 (nth 2 #WT_pt$))
;      (setq #p4 (nth 3 #WT_pt$))
;      (setq #p5 (nth 4 #WT_pt$))
;      (setq #p6 (nth 5 #WT_pt$))
;      (if (= #x "Left")
;        (progn
;          (setq #base_new #BASEPT)
;          (setq #flg "L") ; L 下方向
;          (setq #pts (polar #p6 (angle #p6 #p1) CG_SELECT_WID)) ; 窓選択点1
;          (setq #pte #p5) ; 窓選択点2
;          ;;; UCS
;          (command "._ucs" "3" #p6 #p1 (polar #p6 (angle #p2 #p1) 1000))
;        )
;      );_if
;      (if (= #x "Right")
;        (progn
;          (setq #base_new #BASEPT)
;          (setq  #flg "R") ; 右方向
;          (setq #pts #p2) ; 窓選択点1
;          (setq #pte (polar #p3 (angle #p2 #p1) CG_SELECT_WID)) ; 窓選択点2
;          ;;; UCS
;          (command "._ucs" "3" #p1 #p2 (polar #p1 (angle #p6 #p1) 1000))
;        )
;      );_if
;    )
;    (progn ; L形状以外
;      (setq #p1 (nth 0 #WT_pt$))
;      (setq #p2 (nth 1 #WT_pt$))
;      (setq #p3 (nth 2 #WT_pt$))
;
;      (setq #type0 nil)
;      (if (= #x "Left")
;        (progn
;          (setq #ang (angle #p2 #BASEPT))
;          (setq #base_new (polar #BASEPT #ang #iStretch))
;          (setq #flg "L") ; 左方向
;          (setq #pts (polar #p1 (angle #p1 #p2) CG_SELECT_WID)) ; 窓選択点1
;          (setq #pte (last #WT_pt$))                 ; 窓選択点2
;        )
;      );_if
;      (if (= #x "Right")
;        (progn
;          (setq #base_new #BASEPT)
;          (setq #flg "R") ; 右方向
;          (setq #pts #p2) ; 窓選択点1
;          (setq #pte (polar #p3 (angle #p2 #p1) CG_SELECT_WID)) ; 窓選択点2
;        )
;      );_if
;      ;;; UCS
;      (command "._ucs" "3" #p1 #p2 (polar #p1 (+ (angle #p1 #p2) (dtr 90)) 1000))
;    )
;  );_if
  (cond
    ((and (not (equal (KPGetSinaType) -1 0.1))
           (= (nth 3 #xd$) 1)(= (length #WT_pt$) 6))    ; L型
      (setq #type0 "SL")
      (setq #p1 (nth 0 #WT_pt$))
      (setq #p2 (nth 1 #WT_pt$))
      (setq #p3 (nth 2 #WT_pt$))
      (setq #p4 (nth 3 #WT_pt$))
      (setq #p5 (nth 4 #WT_pt$))
      (setq #p6 (nth 5 #WT_pt$))
      (if (= #x "Left")
        (progn
          (setq #base_new #BASEPT)
          (setq #flg "L") ; L 下方向
          (setq #pts (polar #p6 (angle #p6 #p1) CG_SELECT_WID)) ; 窓選択点1
          (setq #pte #p5) ; 窓選択点2
          ;;; UCS
          (command "._ucs" "3" #p6 #p1 (polar #p6 (angle #p2 #p1) 1000))
        )
      );_if
      (if (= #x "Right")
        (progn
          (setq #base_new #BASEPT)
          (setq  #flg "R") ; 右方向
          (setq #pts #p2) ; 窓選択点1
          (setq #pte (polar #p3 (angle #p2 #p1) CG_SELECT_WID)) ; 窓選択点2
          ;;; UCS
          (command "._ucs" "3" #p1 #p2 (polar #p1 (angle #p6 #p1) 1000))
        )
      );_if
    )
    ((and (not (equal (KPGetSinaType) -1 0.1))
           (= (nth 3 #xd$) 2)(= (length #WT_pt$) 8))    ; U型
      (setq #type0 "SL")
      (setq #p1 (nth 0 #WT_pt$))
      (setq #p2 (nth 1 #WT_pt$))
      (setq #p3 (nth 2 #WT_pt$))
      (setq #p4 (nth 3 #WT_pt$))
      (setq #p5 (nth 4 #WT_pt$))
      (setq #p6 (nth 5 #WT_pt$))
      (setq #p7 (nth 6 #WT_pt$))
      (setq #p8 (nth 7 #WT_pt$))
      (if (= #x "Left")
        (progn
          (setq #base_new #BASEPT)
          (setq #flg "L") ; L 下方向
          (setq #pts (polar #p7 (angle #p7 #p8) CG_SELECT_WID)) ; 窓選択点1
          (setq #pte #p6) ; 窓選択点2
          ;;; UCS
          (command "._ucs" "3" #p7 #p8 (polar #p7 (angle #p8 #p1) 1000))
        )
      );_if
      (if (= #x "Right")
        (progn
          (setq #base_new #BASEPT)
          (setq  #flg "R") ; 右方向
          (setq #pts #p2) ; 窓選択点1
          (setq #pte (polar #p3 (angle #p2 #p1) CG_SELECT_WID)) ; 窓選択点2
          ;;; UCS
          (command "._ucs" "3" #p1 #p2 (polar #p1 (angle #p8 #p1) 1000))
        )
      );_if
    )
    (T  ; 上記以外(Ｉ形状）
      (setq #p1 (nth 0 #WT_pt$))
      (setq #p2 (nth 1 #WT_pt$))
      (setq #p3 (nth 2 #WT_pt$))

      (setq #type0 nil)
      (if (= #x "Left")
        (progn
          (setq #ang (angle #p2 #BASEPT))
          (setq #base_new (polar #BASEPT #ang #iStretch))
          (setq #flg "L") ; 左方向
          (setq #pts (polar #p1 (angle #p1 #p2) CG_SELECT_WID)) ; 窓選択点1
          (setq #pte (last #WT_pt$))                 ; 窓選択点2
        )
      );_if
      (if (= #x "Right")
        (progn
          (setq #base_new #BASEPT)
          (setq #flg "R") ; 右方向
          (setq #pts #p2) ; 窓選択点1
          (setq #pte (polar #p3 (angle #p2 #p1) CG_SELECT_WID)) ; 窓選択点2
        )
      );_if
      ;;; UCS
      (command "._ucs" "3" #p1 #p2 (polar #p1 (+ (angle #p1 #p2) (dtr 90)) 1000))
    )
  )
;-- 2011/09/01 A.Satoh Mod - E

  ;; ストレッチ実行
  ; 02/04/17 YM MOD-S ｼﾝｸ穴,水栓穴はのぞく
  (command
    "_.stretch"
      (ssget "C"
        (trans #pts 0 1)
        (trans #pte 0 1)
        (list
          (cons 8 SKW_AUTO_SECTION)
          (cons -4 "<NOT")
            (list -3 '("G_HOLE"))
          (cons -4 "NOT>")

          (cons -4 "<NOT")
            (list -3 '("G_WTR"))
          (cons -4 "NOT>")
        )
      )
    ""    ; 選択確定
    (trans #pts 0 1)  ; 伸縮開始点
    #sStretch    ; 伸縮量
  )
  ; 02/04/17 YM MOD-E

  ; 02/04/17 YM DEL-S
;;;  (command
;;;    "_.stretch"
;;;     (ssget "C"
;;;       (trans #pts 0 1)
;;;       (trans #pte 0 1)
;;;       (list (cons 8 SKW_AUTO_SECTION)) ; WT底面の画層
;;;     )
;;;    ""    ; 選択確定
;;;    (trans #pts 0 1)  ; 伸縮開始点
;;;    #sStretch    ; 伸縮量
;;;  )
  ; 02/04/17 YM DEL-E

;;;  ;; UCS 戻す
  (command "_.UCS" "P") ; 直前に戻す
;;; (command "zoom" "p") ; 視点を戻す
  (setvar "UCSFOLLOW"  #uf) ; システム変数を戻す

;;;  #WT_tei  ; WT底面図形ﾊﾝﾄﾞﾙ
;;;  #BG_tei1 ; BG SOLID1 or 底面1
;;;  #BG_tei2 ; BG SOLID2 or 底面2 もしあればそのまま
;;;  #FG_tei1 ; FG1底面 *
;;;  #FG_tei2 ; F2G底面 *

  (setq #BG_SOLID nil #FG_SOLID1 nil #FG_SOLID2 nil)
  (setq #BG0 nil #FG01 nil #FG02 nil)

;;; (setq #delobj (getvar "delobj")) ; extrude後の底面を保持する"delobj"=0
;;; (setvar "delobj" 0) ; extrude後の底面を保持する"delobj"=0

;;; WT再作成
  (setq #WT0 #WT_tei) ; 残す
  (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #WT0)) (entget #WT0))) ; 底面ﾎﾟﾘﾗｲﾝ
  (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT0)) (entget #WT0)))
  (setq #WT (entlast)) ; 残す
  (setq #WT_region (Make_Region2 #WT))
  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
;;; BG再作成
  (if (and #BG_tei1 (/= #BG_tei1 ""))
    (progn
      (setq #BG0 #BG_tei1) ; 残す
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG0)) (entget #BG0))) ; 底面ﾎﾟﾘﾗｲﾝ
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG0)) (entget #BG0)))
      (setq #BG (entlast)) ; 残す
      (setq #BG_region (Make_Region2 #BG))
      (setq #BG_SOLID  (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
    )
  );_if
;;; FG1再作成
  (if (and #FG_tei1 (/= #FG_tei1 ""))
    (progn
      (setq #FG01 #FG_tei1) ; 残す
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG01)) (entget #FG01))) ; 底面ﾎﾟﾘﾗｲﾝ
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG01)) (entget #FG01)))
      (setq #FG (entlast)) ; 残す
      (setq #FG_region (Make_Region2 #FG))
      (setq #FG_SOLID1  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if
;;; FG2再作成
  (if (and #FG_tei2 (/= #FG_tei2 ""))
    (progn
      (setq #FG02 #FG_tei2) ; 残す
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG02)) (entget #FG02))) ; 底面ﾎﾟﾘﾗｲﾝ
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG02)) (entget #FG02)))
      (setq #FG (entlast)) ; 残す
      (setq #FG_region (Make_Region2 #FG))
      (setq #FG_SOLID2  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if

;;; (setvar "delobj" #delobj) ; システム変数を戻す

  (setq #ss (ssadd))
  (ssadd #WT_SOLID #ss)
  (if #FG_SOLID1 (ssadd #FG_SOLID1 #ss))
  (if #FG_SOLID2 (ssadd #FG_SOLID2 #ss))

  (if (= #BG_SEP 1) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
    (progn ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
      (command "_union" #ss "") ; 交わらない領域でもＯＫ！
      (if #BG_SOLID
        (setq #BG_tei #BG_SOLID)
        (setq #BG_tei "")
      );_if
    )
    (progn ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型以外
      (if #BG_SOLID
        (ssadd #BG_SOLID #ss)
      );_if
      (command "_union" #ss "") ; 交わらない領域でもＯＫ！
      (if #BG0
        (setq #BG_tei #BG0)
        (setq #BG_tei "")
      );_if
    )
  );_if

  (if #FG01
    (setq #FG_tei1 #FG01)
    (setq #FG_tei1 "")
  );_if
  (if #FG02
    (setq #FG_tei2 #FG02)
    (setq #FG_tei2 "")
  );_if

  (if (and (= #type0 "SL")(= #flg "L")) ; ｽﾃﾝﾚｽL型 のｺﾝﾛ側伸縮を行った場合
    (setq #55 (mapcar '+ (nth 55 #xd$) (list 0.0 #iStretch 0.0)));[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 ***
    (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 ***
  );_if

  (setq #WTLEN1 (nth 0 #55))
  (setq #WTLEN2 (nth 1 #55))
  (setq #WTLEN3 (nth 2 #55))

  (setq #xd_new$
  (list
    (list 32 #base_new) ; 33.コーナー原点  WT左上点
;;;    (list 38 #WT0)      ;[39]WT底面図形ﾊﾝﾄﾞﾙ
;;;    (list 49 #BG_tei)   ;[50]分離型の場合BG1 SOLID図形ﾊﾝﾄﾞﾙ  それ以外は底面図形ﾊﾝﾄﾞﾙ @@@ *
;;;    (list 51 #FG_tei1)  ;[52]FG1 底面図形ﾊﾝﾄﾞﾙ *
;;;    (list 52 #FG_tei2)  ;[53]FG2 底面図形ﾊﾝﾄﾞﾙ *
    (list 55 #55)       ;[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 *** 00/05/01 YM
;-- 2011/09/01 A.Satoh Add - S
    (list 58 "TOKU")
;-- 2011/09/01 A.Satoh Add - E
  ))

  ;// 拡張データの再設定
  (CFSetXData #WT_SOLID "G_WRKT"
    (CFModList #xd$ #xd_new$)
  )

  (setq #WTL (nth 47 #xd$)) ; ｶｯﾄ相手WT左
  (setq #WTR (nth 48 #xd$)) ; ｶｯﾄ相手WT右

  ;// 相手側ワークトップの拡張データも更新する
  (if (and (/= #WTL "") (/= #WTL nil))
    (progn
      (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; 左側
      (CFSetXData #WTL "G_WRKT"
        (CFModList #xdL$
          (list
            (list 48 #WT_SOLID)     ;[49]カット相手WTﾊﾝﾄﾞﾙ右 U型は左右にある
;-- 2011/09/01 A.Satoh Add - S
            (list 58 "TOKU")
;-- 2011/09/01 A.Satoh Add - E
          )
        )
      )
    )
  );_if

  (if (and (/= #WTR "") (/= #WTR nil))
    (progn
      (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; 右側
      (CFSetXData #WTR "G_WRKT"
        (CFModList
          #xdR$
          (list
            (list 47 #WT_SOLID)     ;[48]カット相手WTﾊﾝﾄﾞﾙ左 U型は左右にある
;-- 2011/09/01 A.Satoh Add - S
            (list 58 "TOKU")
;-- 2011/09/01 A.Satoh Add - E
          )
        )
      )
    )
  );_if

;;; 拡張ﾃﾞｰﾀ G_BKGDのｾｯﾄ
;;; 1. 品番名称
;;; 2. BG底面図形ﾊﾝﾄﾞﾙ
;;; 3. 関連WT図形ﾊﾝﾄﾞﾙ
  (if (= #BG_SEP 1) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
    (progn
      (if #BG_SOLID
        (progn
          (PKSetBGXData
            (list #BG_SOLID (nth 50 #xd$)) ; BG図形名ﾘｽﾄ (list #BG_SOLID1 #BG_SOLID2)
            #cutL         ; WTｶｯﾄ左
            #cutR         ; WTｶｯﾄ右
            (nth 2 #xd$)  ; 材質記号
            (list #BG0 #BG_tei2) ; BG底面図形名 (list #BG01 #BG02)
            #WT_SOLID   ; 関連WT図形名
            #D150BG ; D150BG
          )
        )
      );_if
    )
  );_if

  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)
  (setvar "pdmode" #PD) ; 06/12 YM
  (if #KAIJO
    (princ "\n品番確定が解除されました。")
  );_if

  ; WT底面画層ﾌﾘｰｽﾞ
  (command "_layer" "F" SKW_AUTO_SECTION "")


	  ;// ビューを戻す
	  (command "_view" "R" "TEMP_MG")

  ); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
);_if

  (setq *error* nil)
  (princ)

);C:StretchWkTop

;<HOM>*************************************************************************
; <関数名>    : KPMakeFGTeimen
; <処理概要>  : FG底面作成
; <戻り値>    : FG底面図形PLINE
; <作成>      : 01/07/10 YM
; <備考>      : Rｴﾝﾄﾞ両側
;*************************************************************************>MOH<
(defun KPMakeFGTeimen (
  &flg
  &WT_pt$  ;WT外形点列
  &arc1    ; 円弧右上
  &arc2    ; 円弧左上
  &FG_T    ; 前垂れ厚み
  &rr      ; R(円弧の半径)
  /
  #A0 #A1 #A2 #A3 #A4 #A5 #A6 #A7 #ARC11 #ARC11_IN #ARC22 #ARC22_IN
  #CLAYER #FG0 #LAST #LINE1 #LINE1_IN #LINE2 #LINE2_IN #LINE3 #LINE3_IN #LINE4 #LINE5
  #OFPT #P1 #P2 #P3 #P4 #P5 #SSFG
  )
; p1                p2
; +-----------------+arc1
; |                 |
; |    p5           |"Right"ﾀｲﾌﾟ
; +----+            |
;p6      +----------+arc2
;       p4          p3

;      p1                p2
; arc1 +-----------------+
;      |                 |
;      |            p4   |"Left"ﾀｲﾌﾟ
;      |            +----+
; arc2 +----------+      p3
;      p6         p5

  ; 現在画層の変更
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKW_AUTO_SOLID)

  (setq #p1   (nth 0 &WT_pt$)) ; WT左上点
  (setq #p2   (nth 1 &WT_pt$)) ; WT右上点
  (setq #p3   (nth 2 &WT_pt$))
  (setq #p4   (nth 3 &WT_pt$))
  (setq #p5   (nth 4 &WT_pt$))
  (setq #last (last  &WT_pt$))

  (setq #ssFG (ssadd))
  ; 円弧部分作成
  (entmake (entget &arc1))
  (setq #arc11 (entlast))
  (entmake (entget &arc2))
  (setq #arc22 (entlast))

  (setq #ofPT (mapcar '+ #p1 #p3))
  (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
  (command "_offset" &FG_T #arc11 #ofPT "")
  (setq #arc11_in (entlast))
  (command "_offset" &FG_T #arc22 #ofPT "")
  (setq #arc22_in (entlast))

  (cond
    ((= &flg "Right")
      ; 左側Jｶｯﾄ
      ; a1               a2
      ; +----------------+
      ; +a0--------------+　<--内側ARC11_in,外側ARC11
      ; |  "Right"         + +a3
      ; |                  | |
      ; |  a7          a8  + +a4
      ; +---+------------+　<--内側ARC22_in,外側ARC22
      ;     +------------+
      ;    a6            a5

      (setq #a0 (polar #p1 (angle #p2 #p3) &FG_T))
      (setq #a1 #p1)
      (setq #a2 (polar #p2 (angle #p2 #p1) (atof &rr)))
      (setq #a3 (polar #p2 (angle #p2 #p3) (atof &rr)))
      (setq #a4 (polar #p3 (angle #p3 #p2) (atof &rr)))
      (setq #a5 (polar #p3 (angle #p2 #p1) (atof &rr)))
      (setq #a6 #p4)
      (setq #a7 (polar #a6 (angle #p3 #p2) &FG_T))
    )
    ((= &flg "Left")
      ; 右側Jｶｯﾄ
      ;    a2             a1
      ;    +---------------+
      ;a3  +---------------+a0
      ; ++ "Left"          |
      ; ||                 |
      ; ++            a7   |
      ;a4 +------------+---+a3
      ;   +------------+
      ;   a5          a6

      (setq #a0 (polar #p2   (angle #p2 #p3) &FG_T))
      (setq #a1 #p2)
      (setq #a2 (polar #p1   (angle #p1 #p2) (atof &rr)))
      (setq #a3 (polar #p1   (angle #p2 #p3) (atof &rr)))
      (setq #a4 (polar #last (angle #p3 #p2) (atof &rr)))
      (setq #a5 (polar #last (angle #p1 #p2) (atof &rr)))
;;;     (setq #a6 #p5)
      (setq #a6 #p3);2008/09/27 YM MOD
      (setq #a7 (polar #a6   (angle #p3 #p2) &FG_T))
    )
  );_cond

  (command "._line" #a1 #a2 "")
  (setq #line1 (entlast))
  (command "_offset" &FG_T #line1 #ofPT "")
  (setq #line1_in (entlast))

  (command "._line" #a3 #a4 "")
  (setq #line2 (entlast))
  (command "_offset" &FG_T #line2 #ofPT "")
  (setq #line2_in (entlast))

  (command "._line" #a5 #a6 "")
  (setq #line3 (entlast))
  (command "_offset" &FG_T #line3 #ofPT "")
  (setq #line3_in (entlast))

  (command "._line" #a6 #a7 "")
  (setq #line4 (entlast))

  (command "._line" #a1 #a0 "")
  (setq #line5 (entlast))

  (ssadd #arc11 #ssFG)
  (ssadd #arc22 #ssFG)
  (ssadd #arc11_in #ssFG)
  (ssadd #arc22_in #ssFG)

  (ssadd #line1 #ssFG)
  (ssadd #line1_in #ssFG)
  (ssadd #line2 #ssFG)
  (ssadd #line2_in #ssFG)
  (ssadd #line3 #ssFG)
  (ssadd #line3_in #ssFG)
  (ssadd #line4 #ssFG)
  (ssadd #line5 #ssFG)

  (command "_pedit" #arc11 "Y" "J" #ssFG "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
  (setq #FG0 (entlast))

  ; 現在画層を戻す
  (setvar "CLAYER" #clayer)

  #FG0
);KPMakeFGTeimen

;<HOM>*************************************************************************
; <関数名>    : KPMakeFGTeimen_L2
; <処理概要>  : FG底面作成
; <戻り値>    : FG底面図形PLINE
; <作成>      : 01/07/10 YM
; <修正>        01/08/02 YM MOD
;               1:両側,2:左側,3:右側をRｴﾝﾄﾞ可能にした(複雑になった)
;               "Left" 左側のみRｴﾝﾄﾞのｹｰｽ
;*************************************************************************>MOH<
(defun KPMakeFGTeimen_L2 (
  &WT_pt$  ;WT外形点列
  &arc1    ; 円弧左上
  &FG_T    ; 前垂れ厚み
  &rr      ; R(円弧の半径)
  /
  #A0 #A1 #A2 #A3 #A3_IN #A4 #A4_IN #A5 #A6 #A7 #ARC11 #ARC11_IN #CLAYER #FG0
  #LAST #LINE1 #LINE1_IN #LINE2 #LINE2_IN #LINE3 #LINE3_IN #LINE4 #LINE5 #OFPT
  #P1 #P2 #P3 #P4 #P5 #P6 #SSFG
  )
; p1                p2
; +-----------------+arc1
; |                 |
; |    p5           |"Right"ﾀｲﾌﾟ
; +----+            |
;p6      +----------+arc2
;       p4          p3

;      p1                p2
; arc1 +-----------------+
;      |                 |
;      |            p4   |"Left"ﾀｲﾌﾟ
;      |            +----+
; arc2 +----------+      p3
;      p6         p5

  ; 現在画層の変更
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKW_AUTO_SOLID)

  (setq #p1   (nth 0 &WT_pt$)) ; WT左上点
  (setq #p2   (nth 1 &WT_pt$)) ; WT右上点
  (setq #p3   (nth 2 &WT_pt$))
  (setq #p4   (nth 3 &WT_pt$))
  (setq #p5   (nth 4 &WT_pt$))
  (setq #last (last  &WT_pt$))

  (setq #ssFG (ssadd))
  ; 円弧部分作成
  (entmake (entget &arc1))
  (setq #arc11 (entlast))
;;; (entmake (entget &arc2))
;;; (setq #arc22 (entlast))

  (setq #ofPT (mapcar '+ #p1 #p3))
  (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))

  (command "_offset" &FG_T #arc11 #ofPT "")
  (setq #arc11_in (entlast))
;;; (command "_offset" &FG_T #arc22 #ofPT "")
;;; (setq #arc22_in (entlast))

  ; 右側Jｶｯﾄ
  ;    a2             a1
  ;    +---------------+
  ;a3  +---------------+a0
  ; ++ "Left"          |
  ; ||                 |
  ; ++            a7   |
  ;a4 +------------+---+a3
  ;   +------------+
  ;   a5          a6

  (setq #a0 (polar #p2   (angle #p2 #p3) &FG_T))
  (setq #a1 #p2)
  (setq #a2 (polar #p1   (angle #p1 #p2) (atof &rr)))
  (setq #a3 (polar #p1   (angle #p2 #p3) (atof &rr)))
;;; (setq #a4 (polar #last (angle #p3 #p2) (atof &rr)))
  (setq #a4 #last)
;;; (setq #a5 (polar #last (angle #p1 #p2) (atof &rr)))
  (setq #a5 #last)
  (setq #a6 #p5)
  (setq #a7 (polar #a6   (angle #p3 #p2) &FG_T))

  (command "._line" #a1 #a2 "")
  (setq #line1 (entlast))
  (command "_offset" &FG_T #line1 #ofPT "")
  (setq #line1_in (entlast))

  (command "._line" #a3 #a4 "")
  (setq #line2 (entlast))
;;; (command "_offset" &FG_T #line2 #ofPT "")
  (setq #a3_in (polar #a3 (angle #p1 #p2) &FG_T))
  (setq #a4_in (polar #a4 (angle #p1 #p2) &FG_T))
  (setq #a4_in (polar #a4_in (angle #p3 #p2) &FG_T))
  (command "._line" #a3_in #a4_in "")
  (setq #line2_in (entlast))

  (command "._line" #a5 #a6 "")
  (setq #line3 (entlast))
;;; (command "_offset" &FG_T #line3 #ofPT "")
  (command "._line" #a7 #a4_in "")
  (setq #line3_in (entlast))

  (command "._line" #a6 #a7 "")
  (setq #line4 (entlast))

  (command "._line" #a1 #a0 "")
  (setq #line5 (entlast))

  (ssadd #arc11 #ssFG)
;;; (ssadd #arc22 #ssFG)
  (ssadd #arc11_in #ssFG)
;;; (ssadd #arc22_in #ssFG)

  (ssadd #line1 #ssFG)
  (ssadd #line1_in #ssFG)
  (ssadd #line2 #ssFG)
  (ssadd #line2_in #ssFG)
  (ssadd #line3 #ssFG)
  (ssadd #line3_in #ssFG)
  (ssadd #line4 #ssFG)
  (ssadd #line5 #ssFG)

  (command "_pedit" #arc11 "Y" "J" #ssFG "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
  (setq #FG0 (entlast))

  ; 現在画層を戻す
  (setvar "CLAYER" #clayer)
  #FG0
);KPMakeFGTeimen_L2

;<HOM>*************************************************************************
; <関数名>    : KPMakeFGTeimen_L3
; <処理概要>  : FG底面作成
; <戻り値>    : FG底面図形PLINE
; <作成>      : 01/07/10 YM
; <修正>        01/08/02 YM MOD
;               1:両側,2:左側,3:右側をRｴﾝﾄﾞ可能にした(複雑になった)
;               "Left" 右側のみRｴﾝﾄﾞのｹｰｽ
;*************************************************************************>MOH<
(defun KPMakeFGTeimen_L3 (
  &WT_pt$  ;WT外形点列
  &arc2    ; 円弧左下
  &FG_T    ; 前垂れ厚み
  &rr      ; R(円弧の半径)
  /
  #A0 #A1 #A2 #A2_IN #A3 #A4 #A5 #A6 #A7 #ARC22 #ARC22_IN #CLAYER #FG0
  #LAST #LINE1 #LINE2 #LINE2_IN #LINE3 #LINE3_IN #LINE4 #OFPT #P1 #P2 #P3 #P4 #P5
  #SSFG
  )
; p1                p2
; +-----------------+arc1
; |                 |
; |    p5           |"Right"ﾀｲﾌﾟ
; +----+            |
;p6      +----------+arc2
;       p4          p3

;      p1                p2
; arc1 +-----------------+
;      |                 |
;      |            p4   |"Left"ﾀｲﾌﾟ
;      |            +----+
; arc2 +----------+      p3
;      p6         p5

  ; 現在画層の変更
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKW_AUTO_SOLID)

  (setq #p1   (nth 0 &WT_pt$)) ; WT左上点
  (setq #p2   (nth 1 &WT_pt$)) ; WT右上点
  (setq #p3   (nth 2 &WT_pt$))
  (setq #p4   (nth 3 &WT_pt$))
  (setq #p5   (nth 4 &WT_pt$))
  (setq #last (last  &WT_pt$))

  (setq #ssFG (ssadd))
  ; 円弧部分作成
;;; (entmake (entget &arc1))
;;; (setq #arc11 (entlast))
  (entmake (entget &arc2))
  (setq #arc22 (entlast))

  (setq #ofPT (mapcar '+ #p1 #p3))
  (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))

;;; (command "_offset" &FG_T #arc11 #ofPT "")
;;; (setq #arc11_in (entlast))
  (command "_offset" &FG_T #arc22 #ofPT "")
  (setq #arc22_in (entlast))

  ; 右側Jｶｯﾄ
  ;    a2             a1
  ;    +---------------+
  ;a3  +---------------+a0
  ; ++ "Left"          |
  ; ||                 |
  ; ++            a7   |
  ;a4 +------------+---+a3
  ;   +------------+
  ;   a5          a6

  (setq #a0 (polar #p2   (angle #p2 #p3) &FG_T))
  (setq #a1 #p2)
  (setq #a2 #p1)
;;; (setq #a2 (polar #p1   (angle #p1 #p2) (atof &rr)))
  (setq #a3 #p1)
;;; (setq #a3 (polar #p1   (angle #p2 #p3) (atof &rr)))
  (setq #a4 (polar #last (angle #p3 #p2) (atof &rr)))
  (setq #a5 (polar #last (angle #p1 #p2) (atof &rr)))
  (setq #a6 #p5)
  (setq #a7 (polar #a6   (angle #p3 #p2) &FG_T))

  (setq #a2_in (polar #p1 (angle #p1 #p2) &FG_T))
  (command "._line" #a2 #a2_in "")
  (setq #line1 (entlast))
;;; (command "_offset" &FG_T #line1 #ofPT "")
;;; (setq #line1_in (entlast))

  (command "._line" #a3 #a4 "")
  (setq #line2 (entlast))
  (command "_offset" &FG_T #line2 #ofPT "")
;;; (setq #a3_in (polar #a3 (angle #p1 #p2) &FG_T))
;;; (setq #a4_in (polar #a4 (angle #p1 #p2) &FG_T))
;;; (command "._line" #a2_in #a4_in "")
  (setq #line2_in (entlast))

  (command "._line" #a5 #a6 "")
  (setq #line3 (entlast))
  (command "_offset" &FG_T #line3 #ofPT "")
;;; (command "._line" #a7 #a4_in "")
  (setq #line3_in (entlast))

  (command "._line" #a6 #a7 "")
  (setq #line4 (entlast))

;;; (command "._line" #a1 #a0 "")
;;; (setq #line5 (entlast))

;;; (ssadd #arc11 #ssFG)
  (ssadd #arc22 #ssFG)
;;; (ssadd #arc11_in #ssFG)
  (ssadd #arc22_in #ssFG)

  (ssadd #line1 #ssFG)
;;; (ssadd #line1_in #ssFG)
  (ssadd #line2 #ssFG)
  (ssadd #line2_in #ssFG)
  (ssadd #line3 #ssFG)
  (ssadd #line3_in #ssFG)
  (ssadd #line4 #ssFG)
;;; (ssadd #line5 #ssFG)

  (command "_pedit" #arc22 "Y" "J" #ssFG "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
  (setq #FG0 (entlast))

  ; 現在画層を戻す
  (setvar "CLAYER" #clayer)
  #FG0
);KPMakeFGTeimen_L3

;<HOM>*************************************************************************
; <関数名>    : KPMakeFGTeimen_R2
; <処理概要>  : FG底面PLINE作成
; <戻り値>    : FG底面図形PLINE
; <作成>      : 01/07/10 YM
; <備考>      : Rｴﾝﾄﾞ両側前垂れ用
; <修正>        01/08/02 YM MOD
;               1:両側,2:左側,3:右側をRｴﾝﾄﾞ可能にした(複雑になった)
;               "Right" 左側のみRｴﾝﾄﾞのｹｰｽ
;*************************************************************************>MOH<
(defun KPMakeFGTeimen_R2 (
  &WT_pt$  ;WT外形点列
  &arc2    ; 円弧左上
  &FG_T    ; 前垂れ厚み
  &rr      ; R(円弧の半径)
  /
  #A0 #A1 #A2 #A2_IN #A3 #A4 #A4_IN #A5 #A6 #A7 #ARC22 #ARC22_IN #CLAYER #FG0 #LAST
  #LINE1 #LINE1_IN #LINE2 #LINE2_IN #LINE3 #LINE3_IN #LINE4 #LINE5 #OFPT
  #P1 #P2 #P3 #P4 #P5 #SSFG
  )
; p1                p2
; +-----------------+arc1
; |                 |
; |    p5           |"Right"ﾀｲﾌﾟ
; +----+            |
;p6      +----------+arc2
;       p4          p3

;      p1                p2
; arc1 +-----------------+
;      |                 |
;      |            p4   |"Left"ﾀｲﾌﾟ
;      |            +----+
; arc2 +----------+      p3
;      p6         p5

  ; 現在画層の変更
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKW_AUTO_SOLID)

  (setq #p1   (nth 0 &WT_pt$)) ; WT左上点
  (setq #p2   (nth 1 &WT_pt$)) ; WT右上点
  (setq #p3   (nth 2 &WT_pt$))
  (setq #p4   (nth 3 &WT_pt$))
  (setq #p5   (nth 4 &WT_pt$))
  (setq #last (last  &WT_pt$))

  (setq #ssFG (ssadd))
  ; 円弧部分作成
;;; (entmake (entget &arc1))
;;; (setq #arc11 (entlast))
  (entmake (entget &arc2))
  (setq #arc22 (entlast))

  (setq #ofPT (mapcar '+ #p1 #p3))
  (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
;;; (command "_offset" &FG_T #arc11 #ofPT "")
;;; (setq #arc11_in (entlast))
  (command "_offset" &FG_T #arc22 #ofPT "")
  (setq #arc22_in (entlast))

  ; 左側Jｶｯﾄ
  ; a1               a2
  ; +----------------+
  ; +a0--------------+　<--内側ARC11_in,外側ARC11
  ; |  "Right"         + +a3
  ; |                  | |
  ; |  a7          a8  + +a4
  ; +---+------------+　<--内側ARC22_in,外側ARC22
  ;     +------------+
  ;    a6            a5

  (setq #a0 (polar #p1 (angle #p2 #p3) &FG_T))
  (setq #a1 #p1)
  (setq #a2 #p2)
;;;     (setq #a2 (polar #p2 (angle #p2 #p1) (atof &rr)))
  (setq #a3 #p2)
;;;     (setq #a3 (polar #p2 (angle #p2 #p3) (atof &rr)))
  (setq #a4 (polar #p3 (angle #p3 #p2) (atof &rr)))
  (setq #a5 (polar #p3 (angle #p2 #p1) (atof &rr)))
  (setq #a6 #p4)
  (setq #a7 (polar #a6 (angle #p3 #p2) &FG_T))

  (setq #a2_in (polar #p2    (angle #p2 #p1) &FG_T))
  (command "._line" #a2 #a2_in "")
  (setq #line1 (entlast))

;;; (command "._line" #a1 #a2 "")
;;; (setq #line1 (entlast))
;;;
;;; (setq #a2_in (polar #p2    (angle #p2 #p1) &FG_T))
;;; (setq #a2_in (polar #a2_in (angle #p2 #p3) &FG_T))
;;; (command "._line" #a0 #a2_in "")
;;; (setq #line1_in (entlast))

  (command "._line" #a3 #a4 "")
  (setq #line2 (entlast))

  (command "_offset" &FG_T #line2 #ofPT "")
  (setq #line2_in (entlast))

;;; (setq #a4_in (polar #a4    (angle #p2 #p1) &FG_T))
;;; (command "._line" #a2_in #a4_in "")
;;; (setq #line2_in (entlast))

  (command "._line" #a5 #a6 "")
  (setq #line3 (entlast))
  (command "_offset" &FG_T #line3 #ofPT "")
  (setq #line3_in (entlast))

  (command "._line" #a6 #a7 "")
  (setq #line4 (entlast))

  (command "._line" #a1 #a0 "")
  (setq #line5 (entlast))

;;; (ssadd #arc11 #ssFG)
  (ssadd #arc22 #ssFG)
;;; (ssadd #arc11_in #ssFG)
  (ssadd #arc22_in #ssFG)

  (ssadd #line1 #ssFG)
;;; (ssadd #line1_in #ssFG)
  (ssadd #line2 #ssFG)
  (ssadd #line2_in #ssFG)
  (ssadd #line3 #ssFG)
  (ssadd #line3_in #ssFG)
  (ssadd #line4 #ssFG)
  (ssadd #line5 #ssFG)

  (command "_pedit" #arc22 "Y" "J" #ssFG "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
  (setq #FG0 (entlast))

  ; 現在画層を戻す
  (setvar "CLAYER" #clayer)
  #FG0
);KPMakeFGTeimen_R2

;<HOM>*************************************************************************
; <関数名>    : KPMakeFGTeimen_R3
; <処理概要>  : FG底面PLINE作成
; <戻り値>    : FG底面図形PLINE
; <作成>      : 01/07/10 YM
; <備考>      : Rｴﾝﾄﾞ両側前垂れ用
; <修正>        01/08/02 YM MOD
;               1:両側,2:左側,3:右側をRｴﾝﾄﾞ可能にした(複雑になった)
;               "Right" 右側のみRｴﾝﾄﾞのｹｰｽ
;*************************************************************************>MOH<
(defun KPMakeFGTeimen_R3 (
  &WT_pt$  ;WT外形点列
  &arc1    ; 円弧右上
  &FG_T    ; 前垂れ厚み
  &rr      ; R(円弧の半径)
  /
  #A0 #A1 #A2 #A3 #A3_IN #A4 #A4_IN #A5 #A5_IN #A6 #A7 #ARC11 #ARC11_IN #ARC22
  #CLAYER #FG0 #LAST #LINE1 #LINE1_IN #LINE2 #LINE2_IN #LINE3 #LINE3_IN #LINE4 #LINE5
  #OFPT #P1 #P2 #P3 #P4 #P5 #SSFG
  )
; p1                p2
; +-----------------+arc1
; |                 |
; |    p5           |"Right"ﾀｲﾌﾟ
; +----+            |
;p6      +----------+arc2
;       p4          p3

;      p1                p2
; arc1 +-----------------+
;      |                 |
;      |            p4   |"Left"ﾀｲﾌﾟ
;      |            +----+
; arc2 +----------+      p3
;      p6         p5

  ; 現在画層の変更
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKW_AUTO_SOLID)

  (setq #p1   (nth 0 &WT_pt$)) ; WT左上点
  (setq #p2   (nth 1 &WT_pt$)) ; WT右上点
  (setq #p3   (nth 2 &WT_pt$))
  (setq #p4   (nth 3 &WT_pt$))
  (setq #p5   (nth 4 &WT_pt$))
  (setq #last (last  &WT_pt$))

  (setq #ssFG (ssadd))
  ; 円弧部分作成
  (entmake (entget &arc1))
  (setq #arc11 (entlast))
;;; (entmake (entget &arc2))
;;; (setq #arc22 (entlast))

  (setq #ofPT (mapcar '+ #p1 #p3))
  (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
  (command "_offset" &FG_T #arc11 #ofPT "")
  (setq #arc11_in (entlast))
;;; (command "_offset" &FG_T #arc22 #ofPT "")
;;; (setq #arc22_in (entlast))

  ; 左側Jｶｯﾄ
  ; a1               a2
  ; +----------------+
  ; +a0--------------+　<--内側ARC11_in,外側ARC11
  ; |  "Right"         + +a3
  ; |                  | |
  ; |  a7          a8  + +a4
  ; +---+------------+　<--内側ARC22_in,外側ARC22
  ;     +------------+
  ;    a6            a5

  (setq #a0 (polar #p1 (angle #p2 #p3) &FG_T))
  (setq #a1 #p1)
;;; (setq #a2 #p2)
  (setq #a2 (polar #p2 (angle #p2 #p1) (atof &rr)))
;;; (setq #a3 #p2)
  (setq #a3 (polar #p2 (angle #p2 #p3) (atof &rr)))
  (setq #a4 #p3)
;;; (setq #a4 (polar #p3 (angle #p3 #p2) (atof &rr)))
  (setq #a5 #p3)
;;; (setq #a5 (polar #p3 (angle #p2 #p1) (atof &rr)))
  (setq #a6 #p4)
  (setq #a7 (polar #a6 (angle #p3 #p2) &FG_T))

;;; (setq #a2_in (polar #p2    (angle #p2 #p1) &FG_T))
;;; (command "._line" #a2 #a2_in "")
;;; (setq #line1 (entlast))

  (command "._line" #a1 #a2 "")
  (setq #line1 (entlast))

  (command "_offset" &FG_T #line1 #ofPT "")
  (setq #line1_in (entlast))

;;; (setq #a2_in (polar #p2    (angle #p2 #p1) &FG_T))
;;; (setq #a2_in (polar #a2_in (angle #p2 #p3) &FG_T))
;;; (command "._line" #a0 #a2_in "")
;;; (setq #line1_in (entlast))

  (command "._line" #a3 #a4 "")
  (setq #line2 (entlast))

;;; (command "_offset" &FG_T #line2 #ofPT "")
;;; (setq #line2_in (entlast))

  (setq #a3_in (polar #a3    (angle #p2 #p1) &FG_T))
  (setq #a4_in (polar #a4    (angle #p3 #p2) &FG_T))
  (setq #a4_in (polar #a4_in (angle #p2 #p1) &FG_T))
  (command "._line" #a3_in #a4_in "")
  (setq #line2_in (entlast))

  (command "._line" #a5 #a6 "")
  (setq #line3 (entlast))
;;; (command "_offset" &FG_T #line3 #ofPT "")
;;; (setq #line3_in (entlast))
  (command "._line" #a7 #a4_in "")
  (setq #line3_in (entlast))

  (command "._line" #a6 #a7 "")
  (setq #line4 (entlast))

  (command "._line" #a1 #a0 "")
  (setq #line5 (entlast))

  (ssadd #arc11 #ssFG)
;;; (ssadd #arc22 #ssFG)
  (ssadd #arc11_in #ssFG)
;;; (ssadd #arc22_in #ssFG)

  (ssadd #line1 #ssFG)
  (ssadd #line1_in #ssFG)
  (ssadd #line2 #ssFG)
  (ssadd #line2_in #ssFG)
  (ssadd #line3 #ssFG)
  (ssadd #line3_in #ssFG)
  (ssadd #line4 #ssFG)
  (ssadd #line5 #ssFG)

  (command "_pedit" #arc11 "Y" "J" #ssFG "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
  (setq #FG0 (entlast))

  ; 現在画層を戻す
  (setvar "CLAYER" #clayer)
  #FG0
);KPMakeFGTeimen_R3

;<HOM>*************************************************************************
; <関数名>    : PKSTRETCH_TEI
; <処理概要>  : 底面図形を伸縮
; <戻り値>    :
; <作成>      : 1999-10-21 新型WT対応 2000.4.13 YM
; <備考>      :
;*************************************************************************>MOH<
(defun PKSTRETCH_TEI (
  &flg      ; 伸縮側ﾌﾗｸﾞ
  &type0    ; ="SL" ｽﾃﾝﾚｽL型 =nil それ以外
  &WTpt$    ; 底面点列 WT
  &BGpt$    ; 底面点列 BG
  &FGpt1$   ; 底面点列 FG1
  &FGpt2$   ; 底面点列 FG2
  &BasePt   ; WTコーナー基点
  &ang      ; 伸縮方向角度
  &iStretch ; ｽﾄﾚｯﾁ幅
  /
  #BGPT$ #DIST #END #FGPT$ #I #LST$$
  #P11 #P11BG #P1BG #P2 #P22 #P22BG #P22FG #P2BG #P2FG
  #P3 #P33 #P33BG #P33FG #P3BG #P3FG #P44 #P44BG #P4BG
  #PT #PT$ #WTPT$ #FGPT1$ #FGPT2$
  )

  (setq #WTPT$ nil #BGPT$ nil #FGPT1$ nil #FGPT2$ nil)
  (setq #pt$ (GetPtSeries &BasePt &WTpt$)) ; WT 左上点
  (setq #p2  (nth 1 #pt$))
  (setq #p3  (nth 2 #pt$))
  (setq #end (last  #pt$))

;;; base               --->伸縮方向
;;;  +----------------+p2----*p22
;;;  |                |      |
;;;  |                |      |
;;;  |                |      |
;;;  +----------------+p3----*p33
;;;                一番ﾍﾞｰｽから遠い点
  (if (= &flg "R")
    (progn ; 右側伸縮
      ;;; WT ;;;
      (setq #p22 (polar #p2 &ang &iStretch))
      (setq #p33 (polar #p3 &ang &iStretch))
      (setq #WTPT$ '())
      (setq #i 0)
      (repeat (length &WTpt$)
        (setq #pt (nth #i &WTpt$))
        (if (< (distance #pt #p2) 0.1)
          (setq #pt #p22) ; #p1の変わりに#p22を入れ替える
        )
        (if (< (distance #pt #p3) 0.1)
          (setq #pt #p33) ; #p2の変わりに#p33を入れ替える
        )
        (setq #WTPT$ (append #WTPT$ (list #pt)))
        (setq #i (1+ #i))
      )
      ;;; BG ;;;
      (if &BGpt$
        (setq #BGPT$ (PK_PtSTRETCHsub &BGpt$ #p2 &ang &iStretch))
      );_if

      ;;; FG ;;;
      (if &FGpt1$
        (setq #FGPT1$ (PK_PtSTRETCHsub  &FGpt1$ #p3 &ang &iStretch)) ; 通常
      );_if

      (if &FGpt2$
        (setq #FGPT2$ (PK_PtSTRETCHsub &FGpt2$ #p2 &ang &iStretch))
      );_if

    )
  );_if

;;;   <---伸縮方向                |          |
;;; p11 *----+base------------+   |    L     |
;;;          |                |   |          |
;;;          |                |   +----------+p5
;;;          |                |   |end       |
;;; p44 *----+end-------------+   |          |
;;;                               *          *
;;;                              p11         p44
  (if (= &flg "L")
    (progn ; 左側 or L型の下側伸縮
;;;      (if (and (= &type0 "SL")(= (length #pt$) 6)) ; ｽﾃﾝﾚｽL型 01/08/23 YM MOD
      (if (= &type0 "SL") ; ｽﾃﾝﾚｽL型
        (progn
          (setq #p11 (polar #end &ang &iStretch))
          (setq #p44 (polar (nth 4 #pt$) &ang &iStretch))

          (setq #WTPT$ '() #i 0)
          (repeat (length &WTpt$)
            (setq #pt (nth #i &WTpt$))
            (if (< (distance #pt #end) 0.1)
              (setq #pt #p11)
            )
            (if (< (distance #pt (nth 4 #pt$)) 0.1)
              (setq #pt #p44)
            )
            (setq #WTPT$ (append #WTPT$ (list #pt)))
            (setq #i (1+ #i))
          )
      ;;; BG ;;;
          (if &BGpt$
            (setq #BGPT$ (PK_PtSTRETCHsub &BGpt$ #end &ang &iStretch))
          );_if

      ;;; FG ;;;
          (if &FGpt1$
            (setq #FGPT1$ (PK_PtSTRETCHsub &FGpt1$ (nth 4 #pt$) &ang &iStretch))
          );_if

          (if &FGpt2$
            (setq #FGPT2$ (PK_PtSTRETCHsub &FGpt2$ #end &ang &iStretch))
          );_if

        )
        ;;; else
        (progn            ; ｽﾃﾝﾚｽL型以外
          (setq #p11 (polar &BasePt &ang &iStretch))
          (setq #p44 (polar #end &ang &iStretch))

          (setq #WTPT$ '())
          (setq #i 0)
          (repeat (length &WTpt$)
            (setq #pt (nth #i &WTpt$))
            (if (< (distance #pt &BasePt) 0.1)
              (setq #pt #p11)
            )
            (if (< (distance #pt #end) 0.1)
              (setq #pt #p44)
            )
            (setq #WTPT$ (append #WTPT$ (list #pt)))
            (setq #i (1+ #i))
          )
      ;;; BG ;;;
          (if &BGpt$
            (setq #BGPT$ (PK_PtSTRETCHsub &BGpt$ &BasePt &ang &iStretch))
          );_if

      ;;; FG ;;;
          (if &FGpt1$
            (setq #FGPT1$ (PK_PtSTRETCHsub &FGpt1$ #end &ang &iStretch))
          );_if

          (if &FGpt2$
            (setq #FGPT2$ (PK_PtSTRETCHsub &FGpt2$ &BasePt &ang &iStretch))
          );_if

        )
      );_if
    )
  );_if

  (list #WTPT$ #BGPT$ #FGPT1$ #FGPT2$)
);PKSTRETCH_TEI

;<HOM>*************************************************************************
; <関数名>    : PK_PtSTRETCHsub
; <処理概要>  : BG,FG底面外形点列を伸縮
; <戻り値>    : 伸縮後の点列
; <作成>      : 00/06/13 YM
; <備考>      :
;*************************************************************************>MOH<
(defun PK_PtSTRETCHsub (
  &pt$ ; BG or FG 伸縮前の点列
  &BP  ; 基点
  &ang
  &iStretch
  /
  #DIST #I #LST$$ #P0 #P00 #P1 #P11 #PT #RETPT$
  )
  ;;; 基準点から座標の近い順にソートする
  (setq #lst$$ '())
  (foreach #pt &pt$
    (setq #dist (distance &BP #pt))
    (setq #lst$$ (cons (list #pt #dist) #lst$$))
  )
  (setq #lst$$ (CFListSort #lst$$ 1))
  (setq #p0 (car (nth 0 #lst$$)))
  (setq #p1 (car (nth 1 #lst$$)))
  (setq #p00 (polar #p0 &ang &iStretch))
  (setq #p11 (polar #p1 &ang &iStretch))

  ;;; 点の入れ替え
  (setq #retPT$ '())
  (setq #i 0)
  (repeat (length &pt$)
    (setq #pt (nth #i &pt$))
    (if (< (distance #pt #p0) 0.1)
      (setq #pt #p00) ; #p0 の変わりに #p00 を入れ替える
    )
    (if (< (distance #pt #p1) 0.1)
      (setq #pt #p11) ; #p1 の変わりに #p11 を入れ替える
    )
    (setq #retPT$ (append #retPT$ (list #pt)))
    (setq #i (1+ #i))
  )
  #retPT$
);PK_PtSTRETCHsub

;<HOM>*************************************************************************
; <関数名>    : SubStretchWkTop
; <処理概要>  : ワークトップ間口伸縮 call用
; <戻り値>    : 間口伸縮後のワークトップ
; <作成>      :  01/03/23 YM
; <備考>      :
;*************************************************************************>MOH<
(defun SubStretchWkTop (
  &wtEn ; WT図形名
  &LR   ; 伸縮方向
  &size ; 伸縮ｻｲｽﾞ
  /
  #55 #ANG #BASEPT #BASE_NEW #BG #BG0 #BG_H #BG_PT$ #BG_REGION #BG_SEP #BG_SOLID
  #BG_T #BG_TEI #BG_TEI1 #BG_TEI2 #CUTL #CUTR #D150BG #DEP #FG #FG01 #FG02 #FG1_PT$
  #FG2_PT$ #FG_H #FG_REGION #FG_S #FG_SOLID1 #FG_SOLID2 #FG_T #FG_TEI1 #FG_TEI2 #FLG
  #ISTRETCH #P2 #PTS #RET$ #SS #TYPE0 #WT #WT0 #WTEN #WTL #WTLEN1 #WTLEN2 #WTLEN3 #WTR
  #WT_H #WT_LEN$ #WT_PT$ #WT_REGION #WT_SOLID #WT_T #WT_TEI #XD$ #XD0$ #XDL$ #XDR$ #XD_NEW$
  #ZAICODE #ZAIF #WTLR
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SubStretchWkTop ////")
  (CFOutStateLog 1 1 " ")

  (setq #wtEn &wtEn)
  (setq #xd$ (CFGetXData #wtEn "G_WRKT"))
  ;// コマンドの初期化
;;;  (StartUndoErr)
  (setq #iStretch &size) ; Tｶｯﾄ用

  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart)

  (setq #ZaiCode (nth 2 #xd$))
  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ

  (setq #WT_H (nth  8 #xd$))  ; WT高さ
  (setq #WT_T (nth 10 #xd$))  ; WT厚み
  (setq #BG_H (nth 12 #xd$))  ; BG高さ
  (setq #D150BG nil)

  (setq #BG_T (nth 13 #xd$))  ; BG厚み
  (setq #FG_H (nth 15 #xd$))  ; FG高さ
  (setq #FG_T (nth 16 #xd$))  ; FG厚み
  (setq #FG_S (nth 17 #xd$))  ; FGｼﾌﾄ量
  (setq #WTLR (nth 30 #xd$))  ; WTLR
  (setq #cutL (nth 36 #xd$))  ; カット左 I,H,X,P,K,L,V,S,Z
  (setq #cutR (nth 37 #xd$))  ; カット右
  (setq #WT_LEN$  (nth 55 #xd$))    ; WT長さ
  (setq #dep (car (nth 57 #xd$)))   ; WT奥行き

  (setq #WT_tei (nth 38 #xd$))             ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BASEPT (nth 32 #xd$))             ; WT左上点
  (setq #BG_tei1 (nth 49 #xd$))            ; BG SOLID1 or 底面1 *
  (setq #BG_tei2 (nth 50 #xd$))            ; BG SOLID2 or 底面2 * もしあればそのまま

  (if (= (cdr (assoc 0 (entget #BG_tei1))) "3DSOLID") ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
    (setq #BG_SEP 1) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型ﾌﾗｸﾞ 1:分離型
    (setq #BG_SEP 0) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型ﾌﾗｸﾞ 1:分離型
  );_if

  (if (/= #BG_tei1 "")
    (if (setq #xd0$ (CFGetXData #BG_tei1 "G_BKGD"))
      (setq #BG_tei1 (nth 1 #xd0$)) ; BG1底面ﾎﾟﾘﾗｲﾝ
    )
  )
  (if (/= #BG_tei2 "")
    (if (setq #xd0$ (CFGetXData #BG_tei2 "G_BKGD"))
      (setq #BG_tei2 (nth 1 #xd0$)) ; BG2底面ﾎﾟﾘﾗｲﾝ もしあればそのまま
    );_if
  );_if

  (setq #BG_pt$ nil #FG1_pt$ nil #FG2_pt$ nil)

  (setq #FG_tei1 (nth 51 #xd$))               ; FG1底面 *
  (setq #FG_tei2 (nth 52 #xd$))               ; F2G底面 *
  (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))    ; WT外形点列
  (if (/= #BG_tei1 "")
    (setq #BG_pt$ (GetLWPolyLinePt #BG_tei1))   ; BG1外形点列
  )
  (if (/= #FG_tei1 "")
    (setq #FG1_pt$ (GetLWPolyLinePt #FG_tei1))  ; FG1外形点列
  );_if
  (if (/= #FG_tei2 "")
    (setq #FG2_pt$ (GetLWPolyLinePt #FG_tei2)); FG2外形点列
  );_if

  ;// 既存のワークトップを削除
  (entdel #wtEn)
  (if (/= #FG_tei1 "")(entdel #FG_tei1))
  (if (/= #FG_tei2 "")(entdel #FG_tei2))
  (if (/= #BG_tei1 "")(entdel #BG_tei1))
  (entdel #WT_tei)

; BGｿﾘｯﾄﾞ1の削除 1つのWTでBGが2つある場合、BGｿﾘｯﾄﾞ2は伸縮しないから消さない
; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
  (if (and (/= (nth 49 #xd$) "")
           (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID"))
    (entdel (nth 49 #xd$)) ; BGｿﾘｯﾄﾞ1の削除
  )

;;; 底面をｽﾄﾚｯﾁ
;;;  1                          2                  4  4                       2
;;;  +--------------------------+   +--------------+  +-----------------------+
;;;  |                          |   |              |  |                       |
;;;  |                          |   |              |  |                       |
;;;  |       5                  |   |              |  |                       |
;;;  |       +------------------+   |       +------+  |                       |
;;;  |       |                  1   |       |      3  +-----------------------+
;;;  |       |                      |       |         3                       1
;;;  |       |                      |       |
;;;  +-------+                      |       |
;;; 4        3                      |       |
;;;                                 |       |
;;;                                 |       |
;;;                                 +-------+
;;;                                2         1
;;;

;;; 底面をｽﾄﾚｯﾁ
  (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT 左上点
  (setq #p2 (nth 1 #WT_pt$))

  ; 01/08/23 YM MOD-S L型ｽﾃﾝ両側接続段差WTの分離したI形状WT対応のため
  (if (and (not (equal (KPGetSinaType) -1 0.1))(= (nth 3 #xd$) 1)(= #ZaiF 1)(= (length #WT_pt$) 6))
    (progn ; ｽﾃﾝﾚｽL形状 00/09/28 YM
      (setq #type0 "SL")
  ; 01/08/23 YM MOD-E L型ｽﾃﾝ両側接続段差WTの分離したI形状WT対応のため

;;;01/08/23YM@  (if (and (not (equal (KPGetSinaType) -1 0.1))(= (nth 3 #xd$) 1)(= #ZaiF 1))
;;;01/08/23YM@    (progn ; ｽﾃﾝﾚｽL形状 00/09/28 YM
;;;01/08/23YM@      (setq #type0 "SL")

      (if (= &LR "L") (setq #pts (last #WT_pt$)))
      (if (= &LR "R") (setq #pts #p2))

      (if (< (distance #pts #p2) (distance #pts (last #WT_pt$))) ; 伸縮方向
        (progn
          (setq #ang (angle #BASEPT #p2))
          (setq #base_new #BASEPT)
          (setq  #flg "R") ; 右方向
        )
        (progn
          (setq #ang (angle #BASEPT (last #WT_pt$)))
          (setq #base_new #BASEPT)
          (setq #flg "L") ; L 下方向
        )
      )
    )
    (progn ; L形状以外

      (if (= &LR "L") (setq #pts #BASEPT))
      (if (= &LR "R") (setq #pts #p2))

      (setq #type0 nil)
      (if (< (distance #pts #p2) (distance #pts #BASEPT)) ; 伸縮方向
        (progn
          (setq #ang (angle #BASEPT #p2))
          (setq #base_new #BASEPT)
          (setq #flg "R") ; 右方向
        )
        (progn
          (setq #ang (angle #p2 #BASEPT))
          (setq #base_new (polar #BASEPT #ang #iStretch))
          (setq #flg "L") ; 左方向
        )
      );_if
    )
  );_if

  (setq #ret$ (PKSTRETCH_TEI #flg #type0 #WT_pt$ #BG_pt$ #FG1_pt$ #FG2_pt$ #BASEPT #ang #iStretch))
  (setq #WT_pt$  (nth 0 #ret$))
  (setq #BG_pt$  (nth 1 #ret$))
  (setq #FG1_pt$ (nth 2 #ret$))
  (setq #FG2_pt$ (nth 3 #ret$))

  (setq #BG_SOLID nil #FG_SOLID1 nil #FG_SOLID2 nil)
  (setq #BG0 nil #FG01 nil #FG02 nil)
;;; WT再作成
  (MakeLWPL #WT_pt$ 1)
  (setq #WT0 (entlast)) ; 残す
  (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #WT0)) (entget #WT0))) ; 底面ﾎﾟﾘﾗｲﾝ
  (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT0)) (entget #WT0)))
  (setq #WT (entlast)) ; 残す
  (setq #WT_region (Make_Region2 #WT))
  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
;;; BG再作成
  (if #BG_pt$
    (progn
      (MakeLWPL #BG_pt$ 1)
      (setq #BG0 (entlast)) ; 残す
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG0)) (entget #BG0))) ; 底面ﾎﾟﾘﾗｲﾝ
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG0)) (entget #BG0)))
      (setq #BG (entlast)) ; 残す
      (setq #BG_region (Make_Region2 #BG))
      (setq #BG_SOLID  (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
    )
  );_if
;;; FG1再作成
  (if #FG1_pt$
    (progn
      (MakeLWPL #FG1_pt$ 1)
      (setq #FG01 (entlast)) ; 残す
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG01)) (entget #FG01))) ; 底面ﾎﾟﾘﾗｲﾝ
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG01)) (entget #FG01)))
      (setq #FG (entlast)) ; 残す
      (setq #FG_region (Make_Region2 #FG))
      (setq #FG_SOLID1  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if
;;; FG2再作成
  (if #FG2_pt$
    (progn
      (MakeLWPL #FG2_pt$ 1)
      (setq #FG02 (entlast)) ; 残す
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG02)) (entget #FG02))) ; 底面ﾎﾟﾘﾗｲﾝ
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG02)) (entget #FG02)))
      (setq #FG (entlast)) ; 残す
      (setq #FG_region (Make_Region2 #FG))
      (setq #FG_SOLID2  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if

  (setq #ss (ssadd))
  (ssadd #WT_SOLID #ss)
  (if #FG_SOLID1 (ssadd #FG_SOLID1 #ss))
  (if #FG_SOLID2 (ssadd #FG_SOLID2 #ss))

  (if (equal #BG_SEP 0 0.1) ; 分離型ではない
    (if #BG_SOLID (ssadd #BG_SOLID #ss))
  );_if

  (command "_union" #ss "") ; 交わらない領域でもＯＫ！
  (if (and (entget #BG_SOLID)
           (= (cdr (assoc 0 (entget #BG_SOLID))) "3DSOLID"))
    (setq #BG_tei #BG_SOLID) ; BG 3DSOLID
    (setq #BG_tei #BG0)      ; BG 底面
  );_if

  (if #FG01
    (setq #FG_tei1 #FG01)
    (setq #FG_tei1 "")
  );_if
  (if #FG02
    (setq #FG_tei2 #FG02)
    (setq #FG_tei2 "")
  );_if

  (if (= #WTLR "R") ; 右勝手 01/07/06 YM ADD
    (cond
      ((and (= #type0 "SL")(= #flg "L")) ; ｽﾃﾝﾚｽL型 のｺﾝﾛ側伸縮を行った場合
        (setq #55 (mapcar '+ (nth 55 #xd$) (list 0.0 #iStretch 0.0)));[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 ***
      )
      ((and (= #type0 "SL")(= #flg "R")) ; ｽﾃﾝﾚｽL型 のｺﾝﾛ側伸縮を行った場合
        (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 ***
      )
      (T
        (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 ***
      )
    );_cond
;else 左勝手
    (cond
      ((and (= #type0 "SL")(= #flg "L")) ; ｽﾃﾝﾚｽL型 のｺﾝﾛ側伸縮を行った場合
        (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 ***
      )
      ((and (= #type0 "SL")(= #flg "R")) ; ｽﾃﾝﾚｽL型 のｺﾝﾛ側伸縮を行った場合
        (setq #55 (mapcar '+ (nth 55 #xd$) (list 0.0 #iStretch 0.0)));[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 ***
      )
      (T
        (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 ***
      )
    );_cond
  );_if

  (setq #WTLEN1 (nth 0 #55))
  (setq #WTLEN2 (nth 1 #55))
  (setq #WTLEN3 (nth 2 #55))
  (setq #ZaiCode (nth 2 #xd$))

  (setq #xd_new$
  (list
    (list 32 #base_new) ; 33.コーナー原点  WT左上点
    (list 38 #WT0)      ;[39]WT底面図形ﾊﾝﾄﾞﾙ
    (list 49 #BG_tei)   ;[50]分離型の場合BG1 SOLID図形ﾊﾝﾄﾞﾙ  それ以外は底面図形ﾊﾝﾄﾞﾙ @@@ *
    (list 51 #FG_tei1)  ;[52]FG1 底面図形ﾊﾝﾄﾞﾙ *
    (list 52 #FG_tei2)  ;[53]FG2 底面図形ﾊﾝﾄﾞﾙ *
    (list 55 #55)       ;[56]現在のWTの押し出し長さ *** ﾘｽﾄ形式 *** 00/05/01 YM
  ))

  ;// 拡張データの再設定
  (CFSetXData #WT_SOLID "G_WRKT"
    (CFModList
      #xd$ #xd_new$
    )
  )

  (setq #WTL (nth 47 #xd$)) ; ｶｯﾄ相手WT左
  (setq #WTR (nth 48 #xd$)) ; ｶｯﾄ相手WT右

  ;// 相手側ワークトップの拡張データも更新する
  (if (and (/= #WTL "") (/= #WTL nil))
    (progn
      (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; 左側
      (CFSetXData #WTL "G_WRKT"
        (CFModList #xdL$
          (list
            (list 48 #WT_SOLID)     ;[49]カット相手WTﾊﾝﾄﾞﾙ右 U型は左右にある
          )
        )
      )
    )
  );_if

  (if (and (/= #WTR "") (/= #WTR nil))
    (progn
      (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; 右側
      (CFSetXData #WTR "G_WRKT"
        (CFModList #xdR$
          (list
            (list 47 #WT_SOLID)     ;[48]カット相手WTﾊﾝﾄﾞﾙ左 U型は左右にある
          )
        )
      )
    )
  );_if

;;; 拡張ﾃﾞｰﾀ G_BKGDのｾｯﾄ
;;; 1. 品番名称
;;; 2. BG底面図形ﾊﾝﾄﾞﾙ
;;; 3. 関連WT図形ﾊﾝﾄﾞﾙ
  (if #BG_SOLID
    (progn
      (PKSetBGXData
        (list #BG_SOLID (nth 50 #xd$)) ; BG図形名ﾘｽﾄ (list #BG_SOLID1 #BG_SOLID2)
        #cutL         ; WTｶｯﾄ左
        #cutR         ; WTｶｯﾄ右
        (nth 2 #xd$); 材質記号
        (list #BG0 #BG_tei2) ; BG底面図形名 (list #BG01 #BG02)
        #WT_SOLID   ; 関連WT図形名
        #D150BG ; D150BG
      )
    )
  );_if

  ;// Ｏスナップ関連システム変数を元に戻す
  (CFNoSnapEnd) ; 00/02/07@YM@

  #WT_SOLID
);SubStretchWkTop

;<HOM>*************************************************************************
; <関数名>    : C:ChZaiWkTop
; <処理概要>  : 材質変更ｺﾏﾝﾄﾞ
; <戻り値>    :
; <作成>      : 1999-11-15
; <備考>      : 2000.4.30 YM 修正
;*************************************************************************>MOH<
(defun C:ChZaiWKTop (
  /
  #wtEn #wtxd$ #XD$
  #loop #ZAI0 #zai
  #WTL #WTR #WTXD0$ #set_flg #ZaiF #ERRMSG
#HINBAN #NUM1 #NUM2 ; 02/12/04 YM ADD
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ChZaiWKTop ////")
  (CFOutStateLog 1 1 " ")
  ;// コマンドの初期化
  (StartUndoErr)
  (CFCmdDefBegin 6);00/09/26 SN ADD

	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)

; 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn

  ;// ワークトップの指示
  (initget 0)
  (setq #set_flg nil)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\nワークトップを選択: ")))
    (if #wtEn
      (setq #wtxd$ (CFGetXData #wtEn "G_WRKT"))
      (setq #wtxd$ nil)
    );_if

    (if (= #wtxd$ nil)
      (CFAlertMsg "ワークトップではありません。")
      (progn
        (setq #ZAI0 (nth 2 #wtXd$))
        (setq #ZaiF (KCGetZaiF #ZAI0)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
;;; 関連WTで品番確定されているものがあるか探す
        (setq #xd$ (CFGetXData #wtEn "G_WTSET"))
        (if #xd$ (setq #set_flg T))

        ;;; ｶｯﾄ相手左
        (setq #WTL (nth 47 #wtxd$)) ; 左WT図形ﾊﾝﾄﾞﾙ
        (while (and #WTL (/= #WTL "")) ; 左にWTがあれば
          (setq #wtxd0$ (CFGetXData #WTL "G_WRKT"))
          (setq #xd$ (CFGetXData #WTL "G_WTSET"))
          (if #xd$ (setq #set_flg T))
          (setq #WTL (nth 47 #wtxd0$))     ; 更に左にあるか
          (if (= #WTL "") (setq #WTL nil)) ; なかったら nil
        )
        ;;; ｶｯﾄ相手右
        (setq #WTR (nth 48 #wtxd$)) ; 右WT図形ﾊﾝﾄﾞﾙ
        (while (and #WTR (/= #WTR "")) ; 右にWTがあれば
          (setq #wtxd0$ (CFGetXData #WTR "G_WRKT"))
          (setq #xd$ (CFGetXData #WTR "G_WTSET"))
          (if #xd$ (setq #set_flg T))
          (setq #WTR (nth 48 #wtxd0$))     ; 更に右にあるか
          (if (= #WTR "") (setq #WTR nil)) ; なかったら nil
        )
;;;01/11/22YM@DEL        (if (= #ZaiF 1)
;;;01/11/22YM@DEL          (progn
;;;01/11/22YM@DEL            (CFAlertMsg "ステンレスを他の材質に変更できません。")
;;;01/11/22YM@DEL            (quit)
;;;01/11/22YM@DEL          )
          (setq #loop nil)
;;;01/11/22YM@DEL        );_if

        (if #set_flg
          (progn
            (if (CFYesNoDialog "ワークトップは既に品番確定されています。\n処理を続けますか？")
              (progn ; YES なら色を戻す
                (PCW_ChColWT #wtEn "BYLAYER" T)
              )
              (quit) ; NO
            );_if
          )
        )

      )
    );_if
  );while

  (PCW_ChColWT #wtEn "MAGENTA" T) ; 色を変える 00/04/27 YM
  ;// 材質記号の選択(ﾀﾞｲｱﾛｸﾞの表示)

  ; 02/08/29 YM ADD R付き天板対応 ﾀﾞｲｱﾛｸﾞ分岐[CT材質]参照
  (if (= 1 (nth 33 #wtXd$))

    ; 材質ﾀﾞｲｱﾛｸﾞ表示(R付き天板の場合)
    (setq #zai (PKW_CTZaiDlg #ZAI0)) ; 02/08/29 YM ADD
; else
    ;;;01/11/22YM@DEL  (setq #zai (PKW_ZaiDlg #ZAI0)) ; #ZAI0
    ; 現在ｽﾃﾝﾚｽでｽﾃﾝﾚｽの選択肢が2つ以上あるときはｽﾃﾝﾚｽ同士材質変更可能
    ; 通常どおり
;-- 2011/09/18 A.Satoh Mod - S
;;;;;    (setq #zai (PKW_ZaiDlgS #ZAI0)) ; 01/11/22 YM ADD
    (setq #zai (PKW_ZaiDlgS #ZAI0 #wtEn #wtxd$)) ; 01/11/22 YM ADD
;-- 2011/09/18 A.Satoh Mod - E

  );_if

  (PCW_ChColWT #wtEn "BYLAYER" T)

  ; ｺﾏﾝﾄﾞﾗｲﾝﾒｯｾｰｼﾞ表示 0/08/29 YM ADD-S
  ;// 材質の更新
  (if (and #zai (/= #ZAI0 #zai))
    ; 戻り値が nil でなくて元の材質と違う場合
    (princ "\n材質を変更しました。")
  ; else
    (princ "\n材質を変更しませんでした。")
  );_if
  ; ｺﾏﾝﾄﾞﾗｲﾝﾒｯｾｰｼﾞ表示 0/08/29 YM ADD-E

  ;// 材質の更新
  (if #zai
    (progn ; 戻り値が nil でない
      (command "vpoint" "0,0,1")          ; 視点を真上から
      (setq CG_WorkTop (substr #zai 2 1)) ; 色柄グローバル設定 06/02 YM

      ; 02/08/29 YM ADD-S
      (if (= 1 (nth 33 #wtXd$))
        (progn ; R付き天板だったら品番更新する
          (setq #hinban (nth 34 #wtXd$))
          ; 02/11/27 YM MOD-S ｼﾘｰｽﾞ記号1,2桁 材質1,2桁に対応
          (setq #num1 (strlen CG_SeriesCode)) ; ｼﾘｰｽﾞ記号文字数
          (setq #num2 (strlen #ZAI0))         ; 材質記号文字数
          (setq #hinban
            (strcat (substr #hinban 1 #num1)
              #zai
              (substr #hinban (1+ (+ #num1 #num2)) (- (strlen #hinban) (+ #num1 #num2)))
            )
          )
          ; 02/11/27 YM MOD-E

          ; 02/11/27 YM MOD ｼﾘｰｽﾞ記号1,2桁 材質1,2桁に対応
;;;         (setq #hinban
;;;           (strcat (substr #hinban 1 2)
;;;                   #zai
;;;                   (substr #hinban 5 (- (strlen #hinban) 4))
;;;           )
;;;         )

        )
      );_if
      ; 02/08/29 YM ADD-E

      ; 02/09/02 YM MOD R付かどうかで分岐するように変更
      (if (= 1 (nth 33 #wtXd$))
        (progn
          (CFSetXData #wtEn "G_WRKT"
            (CFModList #wtxd$
              (list
                (list  2 #zai)
                (list 18 0)       ; 01/11/22 YM ADD
                (list 19 "")      ; 01/11/22 YM ADD
                (list 34 #hinban) ; ★R付き天板の場合★
              )
            )
          )
        )
        (progn
          (CFSetXData #wtEn "G_WRKT"
            (CFModList #wtxd$
              (list
                (list  2 #zai)
                (list 18 0)  ; 01/11/22 YM ADD
                (list 19 "") ; 01/11/22 YM ADD
              )
            )
          )
        )
      );_if

      ; 01/06/08 YM ADD ｼﾝｸ,水栓穴を埋める START
      (if (CFGetXData #wtEn "G_WTSET")
        (progn
          (KPSrcSNKembedANA #wtEn)
          (DelAppXdata #wtEn "G_WTSET")  ; "G_WTSET"を消す
        )
      );_if
      ; 01/06/08 YM ADD ｼﾝｸ,水栓穴を埋める END

      ;;; ｶｯﾄ相手左
      (setq #WTL (nth 47 #wtxd$))    ; 左WT図形ﾊﾝﾄﾞﾙ
      (while (and #WTL (/= #WTL "")) ; 左にWTがあれば
        (setq #wtxd0$ (CFGetXData #WTL "G_WRKT"))
        (CFSetXData #WTL "G_WRKT"
          (CFModList #wtxd0$
            (list
              (list  2 #zai)
              (list 18 0)  ; 01/11/22 YM ADD
              (list 19 "") ; 01/11/22 YM ADD
            )
          )
        )
        ; 01/06/08 YM ADD ｼﾝｸ,水栓穴を埋める START
        (if (CFGetXData #WTL "G_WTSET")
          (progn
            (KPSrcSNKembedANA #WTL)
            (DelAppXdata #WTL "G_WTSET")     ; "G_WTSET"を消す
          )
        );_if
        ; 01/06/08 YM ADD ｼﾝｸ,水栓穴を埋める END

        (setq #WTL (nth 47 #wtxd0$))     ; 更に左にあるか
        (if (= #WTL "") (setq #WTL nil)) ; なかったら nil
      )
      ;;; ｶｯﾄ相手右
      (setq #WTR (nth 48 #wtxd$))    ; 右WT図形ﾊﾝﾄﾞﾙ
      (while (and #WTR (/= #WTR "")) ; 右にWTがあれば
        (setq #wtxd0$ (CFGetXData #WTR "G_WRKT"))
        (CFSetXData #WTR "G_WRKT"
          (CFModList #wtxd0$
            (list
              (list  2 #zai)
              (list 18 0)  ; 01/11/22 YM ADD
              (list 19 "") ; 01/11/22 YM ADD
            )
          )
        )
        ; 01/06/08 YM ADD ｼﾝｸ,水栓穴を埋める START
        (if (CFGetXData #WTR "G_WTSET")
          (progn
            (KPSrcSNKembedANA #WTR)
            (DelAppXdata #WTR "G_WTSET")     ; "G_WTSET"を消す
          )
        );_if
        ; 01/06/08 YM ADD ｼﾝｸ,水栓穴を埋める END

        (setq #WTR (nth 48 #wtxd0$))     ; 更に右にあるか
        (if (= #WTR "") (setq #WTR nil)) ; なかったら nil
      )
      (command "zoom" "p") ; 視点を戻す
    )
    (quit) ; 更新しない
  );_if

  ); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
);_if

  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)


);C:ChZaiWKTop

;<HOM>*************************************************************************
; <関数名>    : KPSrcSNKembedANA
; <処理概要>  : WT外形からｼﾝｸを探してｼﾝｸ穴を埋める
; <戻り値>    : なし
; <作成>      : 01/06/08 YM
; <備考>      : ! ssget "CP"が必要 !
;*************************************************************************>MOH<
(defun KPSrcSNKembedANA (
  &wtEn
  /
  #410$ #PT$ #TEIWT #WTEN #WTXD$
  )
  (setq #wtxd$ (CFGetXData &wtEn "G_WRKT"))
  (setq #teiWT  (nth 38 #wtxd$))      ; WT底面図形
  (setq #pt$ (GetLWPolyLinePt #teiWT)); WT外形点列
  (setq #pt$ (AddPtList #pt$))
  (setq #410$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SNK)) ; 領域内ｼﾝｸ ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
  (foreach #410 #410$
    (PKWTSinkAnaEmbed &wtEn #410 nil) ; WT図形,ｼﾝｸｼﾝﾎﾞﾙ図形を渡してWTの穴を埋める
  )
  (princ)
);KPSrcSNKembedANA

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_ZaiDlg
;;; <処理概要>  : 材質変更ダイアログ表示
;;; <戻り値>    : 材質記号
;;; <作成>      : 00/09/29 YM 標準化
;;; <備考>      : ｽﾃﾝﾚｽ<==>人大の変更は禁止 01/04/12 YM
;;;*************************************************************************>MOH<
(defun PKW_ZaiDlg (
  &wtZai
  /
  #dcl_id ##GetDlgItem
  #Qry$ #Qry$$ #dum$$
  #no #i #ZAI #BG_KEI #ELM #I
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( / #zai)
            (setq #zai
              (caddr (nth (atoi (get_tile "zai")) #dum$$))
            )
            (if (/= &wtZai #zai)
              (progn ; 変更があった場合
                (princ "\n材質を変更しました。")
                (done_dialog)
                #zai
              )
              (progn
                (princ "\n材質を変更しませんでした。")
                (done_dialog)
                nil
              )
            );_if
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// 材質記号の選択
  (setq #Qry$$
    (DBSqlAutoQuery CG_DBSESSION (strcat "select * from WT材質 where SERIES記号='" CG_SeriesCode "'"))
  )
  (setq #Qry$$ (CFListSort #Qry$$ 0)) ; (nth 0 が小さいもの順にｿｰﾄ 01/05/30 YM ADD

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "ChgZaiDlg" #dcl_id)) (exit))

  ; ｽﾃﾝﾚｽは表示しない 01/04/12 YM ADD
  (setq #dum$$ nil)
  (foreach #Qry$ #Qry$$
;;;01/08/10YM@    (if (/= 1 (nth 4 #Qry$))
    (if (and (/= 1 (nth 4 #Qry$))(/= 1 (nth 6 #Qry$))) ; 廃盤Fが1でないもの 01/08/10 YM ADD
      (setq #dum$$ (append #dum$$ (list #Qry$)))
    );_if
  )

  (start_list "zai" 3)
  (setq #i 0 #no 0)
  (foreach #dum$ #dum$$
    (add_list (strcat (nth 2 #dum$) " ： " (nth 3 #dum$)))
    (if (= (nth 2 #dum$) &wtZai)
      (setq #no #i)
    )
    (setq #i (1+ #i))
  )
  (end_list)
  (set_tile "zai" (itoa #no))

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #zai (##GetDlgItem))")
  (action_tile "cancel" "(setq #zai nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)

  ;// シンク、水栓穴、水栓種類の選択番号及び穴径、予備穴径を返す
  #zai ; 戻り値 00/03/19 (材質記号,ﾌﾗｸﾞ#CG_WtDepth) #CG_WtDepth=0,1,10,100の和

);PKW_ZaiDlg

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_ZaiDlgS
;;; <処理概要>  : 材質変更専用newダイアログ表示
;;; <戻り値>    : (材質記号)
;;; <作成>      : 00/09/29 YM 標準化
;;; <備考>      : 現在ｽﾃﾝﾚｽでｽﾃﾝﾚｽの選択肢が2つ以上あるときはｽﾃﾝﾚｽ同士材質変更可能 01/11/22 YM
;;;*************************************************************************>MOH<
(defun PKW_ZaiDlgS (
  &wtZai
;-- 2011/09/18 A.Satoh Add - S
  &eWTP
  &wtxd$
;-- 2011/09/18 A.Satoh Add - S
  /
;-- 2011/09/18 A.Satoh Mod - S
;;;;;  #dcl_id ##GetDlgItem
;;;;;  #Qry$ #Qry$$ #dum$$
;;;;;  #no #i #ZAI #BG_KEI #ELM #I
  #Qry$$ #qry$ #err_flg #ret$ #SNK$$ #SNK$ #eSNK$ #zai #xd_SNK$ #snk_kigou
  #oku$$ #oku$ #oku #msg #zai_Kanri$$ #zai_Kanri$ #zai$ #dcl_id #dum$$ #dum$
  #idx #no
;-- 2011/09/18 A.Satoh Mod - E
  #ZAI_DUM$$ #ZAI_TYP #ZAI_KANRI ;2011/09/19 YM ADD
#snk_dep   ;-- 2012/04/20 A.Satoh Add シンク配置不具合対応
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( / #zai)
            (setq #zai
              (nth 1 (nth (atoi (get_tile "zai")) #dum$$))
            )
; 02/08/29 YM DEL-S
;;;            (if (/= &wtZai #zai)
;;;              (progn ; 変更があった場合
;;;                (princ "\n材質を変更しました。")
;;;                (done_dialog)
;;;                #zai
;;;              )
;;;              (progn
;;;                (princ "\n材質を変更しませんでした。")
;;;                (done_dialog)
;;;                nil
;;;              )
;;;            );_if
; 02/08/29 YM DEL-E

            (done_dialog)
            #zai

          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// 材質記号の選択
  (setq #Qry$$
    (DBSqlAutoQuery CG_DBSESSION (strcat "select * from WT材質 where 廃番F=0"))
  )
  (setq #Qry$$ (CFListSort #Qry$$ 0)) ; (nth 0 が小さいもの順にｿｰﾄ 01/05/30 YM ADD

;-- 2011/09/18 A.Satoh Add - S
  ; 天板底面図形から底面図形領域を求める
  (setq #err_flg nil)
  (setq #zai nil)

  (command "vpoint" "0,0,1")

  (setq #ret$ (PKW_GetWorkTopAreaSym3 &eWTP)); 引数 = 処理の対象ワークトップ図形名

  (command "zoom" "p")

  (setq #SNK$$ (nth 0 #ret$))
  (foreach #SNK$ #SNK$$
    (setq #eSNK$ (append #eSNK$ (list (nth 0 #SNK$))))
  )
  (setq #eSNK$ (NilDel_List #eSNK$))
  (if (= #eSNK$ nil)
    (progn
      nil ;2011/09/19 YM ｼﾝｸがなくても処理を行う
;;;2011/09/19YM      (setq #err_flg T)
;;;2011/09/19YM      (CFAlertMsg "指定された天板にはｼﾝｸがありません")
    )
    (progn
      ; シンク記号を取り出す
      (setq #xd_SNK$ (CFGetXData (car #eSNK$) "G_LSYM"))
      (if #xd_SNK$
        (setq #snk_kigou (nth 5 #xd_SNK$))
        (progn
          (setq #err_flg T)
          (CFAlertMsg "ｼﾝｸ情報が存在しません")
        )
      )
    )
  )

  (if (= #err_flg nil)
    (progn
;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 - S
      ; 奥行き
;;;;;      (setq #oku$$
;;;;;        (CFGetDBSQLRec CG_DBSESSION "奥行"
;;;;;          (list
;;;;;            (list "奥行" (itoa (fix (+ (car (nth 57 &wtxd$)) 0.01))) 'INT)
;;;;;          )
;;;;;        )
;;;;;      )
			(setq #snk_dep (nth 39 &wtxd$))
			(if (or (= #snk_dep 0.0) (= #snk_dep nil))
				(progn
					(setq #snk_dep (getSinkDep &eWTP))
					(if (or (= #snk_dep 0.0) (= #snk_dep nil))
						(setq #snk_dep (car (nth 57 &wtxd$)))
					)
				)
			)
      (setq #oku$$
        (CFGetDBSQLRec CG_DBSESSION "奥行"
          (list
            (list "奥行" (itoa (fix (+ #snk_dep 0.01))) 'INT)
          )
        )
      )
;;(princ "\n#snk_dep = ")(princ #snk_dep)
;;(princ "\n#oku$$ = ")(princ #oku$$)(princ)
;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 - E
      (if (and #oku$$ (= 1 (length #oku$$)))
        (progn
          (setq #oku$ (nth 0 #oku$$))
          (setq #oku (nth 1 #oku$))
        )
        (progn
          (setq #err_flg T)
;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 - S
;;;;;          (setq #msg (strcat "『奥行』にﾚｺｰﾄﾞがありません。\nｼﾝｸｷｬﾋﾞﾈｯﾄ品番名称=" (itoa (fix (+ (car (nth 57 &wtxd$)) 0.01)))))
          (setq #msg (strcat "『奥行』にﾚｺｰﾄﾞがありません。\n奥行サイズ=" (itoa (fix (+ #snk_dep 0.01)))))
;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 - E
          (CFAlertMsg #msg)
        )
      )
    )
  )

  (if (= #err_flg nil)
    (progn
      (if #eSNK$
        (progn

          ; 材質変更管理テーブルから材質記号リストを作成する
          (setq #zai_Kanri$$
            (CFGetDBSQLRec CG_DBSESSION "材質変更管理"
              (list
                (list "奥行"   #oku 'STR)
                (list "シンク" #snk_kigou 'STR)
              )
            )
          )

          ;;; ｴﾗｰ処理
          (if (and #zai_Kanri$$ (= 1 (length #zai_Kanri$$)))
            (progn
              (setq #zai_Kanri$ (car #zai_Kanri$$))
              (setq #zai_Kanri (nth 3 #zai_Kanri$))
              (setq #zai$ (strparse #zai_Kanri ","))
            )
            (progn
              (setq #err_flg T)
              (setq #msg (strcat "『材質変更管理』にﾚｺｰﾄﾞがありません。\n奥行=" #oku "  ｼﾝｸ=" #snk_kigou))
              (CFAlertMsg #msg)
            )
          );_if

        )
        (progn ;ｼﾝｸがないとき

          (setq #zai_dum$$
            (CFGetDBSQLRec CG_DBSESSION "WT材質"
              (list
                (list "材質記号"   &wtZai 'STR)
              )
            )
          )
          (setq #zai_typ (nth 8 (car #zai_dum$$)))
          (if (or (= #zai_typ nil)(= #zai_typ ""))
            (progn
              (setq #msg "\n現在の材質は変更できません")
              (CFAlertMsg #msg)
              (setq #err_flg T)
            )
            (progn
              (setq #zai_Kanri$$
                (CFGetDBSQLRec CG_DBSESSION "WT材質"
                  (list
                    (list "材質変更候補"   #zai_typ 'STR)
                  )
                )
              )
              (foreach #zai_Kanri$ #zai_Kanri$$
                (nth 1 #zai_Kanri$)
                (setq #zai$ (append #zai$ (list (nth 1 #zai_Kanri$))))
              )
            )
          );_if
        )
      );_if

    )
  );_if

  (if (= #err_flg nil)
    (progn
;-- 2011/09/18 A.Satoh Mod - E
  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "ChgZaiDlg" #dcl_id)) (exit))

;-- 2011/09/18 A.Satoh Mod - S
      (setq #dum$$ nil)
      (setq #idx 0)
      (repeat (length #zai$)
        (foreach #qry$ #QRY$$
          (if (= (nth #idx #zai$) (nth 1 #qry$))
            (setq #dum$$ (append #dum$$ (list #qry$)))
          )
        )
        (setq #idx (1+ #idx))
      )

      (setq #idx 0 #no 0)
      (start_list "zai" 3)
      (foreach #dum$ #dum$$
        (add_list (strcat (nth 1 #dum$) " ： " (nth 2 #dum$)))
        (if (= (nth 1 #dum$) &wtZai)
          (setq #no #idx)
        )
        (setq #idx (1+ #idx))
      )
      (end_list)
      (set_tile "zai" (itoa #no))
;;;;;  ; 現在ｽﾃﾝﾚｽでｽﾃﾝﾚｽの選択肢が2つ以上あるときはｽﾃﾝﾚｽ同士材質変更可能
;;;;;  (setq #ZaiF (KCGetZaiF &wtZai)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
;;;;;  (if (= #ZaiF 1)
;;;;;    (progn ; ｽﾃﾝﾚｽ
;;;;;      (setq #dum$$ nil)
;;;;;      (foreach #Qry$ #Qry$$
;;;;;        (if (= 1 (nth 3 #Qry$)) ;ｽﾃﾝﾚｽ
;;;;;          (setq #dum$$ (append #dum$$ (list #Qry$)))
;;;;;        );_if
;;;;;      )
;;;;;    )
;;;;;    (progn ; ｽﾃﾝﾚｽ以外
;;;;;      (setq #dum$$ nil)
;;;;;      (foreach #Qry$ #Qry$$
;;;;;        (if (= 0 (nth 3 #Qry$)) ;人大
;;;;;          (setq #dum$$ (append #dum$$ (list #Qry$)))
;;;;;        );_if
;;;;;      )
;;;;;    )
;;;;;  );_if
;;;;;
;;;;;  (start_list "zai" 3)
;;;;;  (setq #i 0 #no 0)
;;;;;  (foreach #dum$ #dum$$
;;;;;    (add_list (strcat (nth 1 #dum$) " ： " (nth 2 #dum$)))
;;;;;    (if (= (nth 1 #dum$) &wtZai)
;;;;;      (setq #no #i)
;;;;;    )
;;;;;    (setq #i (1+ #i))
;;;;;  )
;;;;;  (end_list)
;;;;;  (set_tile "zai" (itoa #no))
;-- 2011/09/18 A.Satoh Mod - E

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #zai (##GetDlgItem))")
  (action_tile "cancel" "(setq #zai nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
;-- 2011/09/18 A.Satoh Add - S
    )
  )
;-- 2011/09/18 A.Satoh Add - E

  ;// シンク、水栓穴、水栓種類の選択番号及び穴径、予備穴径を返す
  #zai ; 戻り値 00/03/19 (材質記号,ﾌﾗｸﾞ#CG_WtDepth) #CG_WtDepth=0,1,10,100の和

);PKW_ZaiDlgS

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckD
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(WK 段差用)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 00/12/19 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckD (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &SnkP     ; SINK PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  &cutTYPE  ; WTｶｯﾄﾀｲﾌﾟ
  /
  #DIMA #DIMB1 #DIMB2 #DIMC #DISTL #DISTR #L1 #L2 #R1 #R2 #SNKPT$
  #STD_FLG #WTPT$
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #DimA  (nth 0 &ret$)) ; 寸法A
  (setq #DimB1 (nth 1 &ret$)) ; 寸法B1
  (setq #WTpt$ &WTpt$)

;L1+------------------+R1
;  | B +--------+  A  |
;  |<->|  ｼﾝｸ   |<--->|
;  |   +--------+     |
;L2+------------------+R2

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; ｼﾝｸ外形点列

  (if (= (substr &cutTYPE 1 1) "4")
    (progn ; 左側が段差のとき
      ; 右側のﾁｪｯｸ
      (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " 段差WT右側-ｼﾝｸ標準寸法: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " 段差WT右側-ｼﾝｸ実寸法:   " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")
      ; 左側のﾁｪｯｸ
      (setq #distL (GetDistLineToPline (list #L1 #L2) #SNKpt$))
      (if (not (equal #distL #DimB1 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " 段差WT左側-ｼﾝｸ標準寸法: " (rtos #DimB1)))
      (CFOutStateLog 1 1 (strcat " 段差WT左側-ｼﾝｸ実寸法:   " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")
    )
  );_if

  (if (= (substr &cutTYPE 2 1) "4")
    (progn ; 右側が段差
      ; 右側のﾁｪｯｸ
      (setq #distR (GetDistLineToPline (list #L1 #L2) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " 段差WT左側-ｼﾝｸ標準寸法: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " 段差WT左側-ｼﾝｸ実寸法:   " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")
      ; 左側のﾁｪｯｸ
      (setq #distL (GetDistLineToPline (list #R1 #R2) #SNKpt$))
      (if (not (equal #distL #DimB1 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " 段差WT右側-ｼﾝｸ標準寸法: " (rtos #DimB1)))
      (CFOutStateLog 1 1 (strcat " 段差WT右側-ｼﾝｸ実寸法:   " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckD

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckI
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(ﾐｶﾄﾞ I型用)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 01/02/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckI (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &SnkP     ; SINK PMEN PLINE
  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  &WTLR     ; 左右の勝手
  /
  #ANG #DIMA #DIMB #DIMB1 #DIMB2 #DIMC #DIST #DISTL #DISTR #GASPT$
  #L1 #L2 #R1 #R2 #SNKPT$ #STD_FLG #WTBASE #WTPT$ #X1 #Y1 #Errflg
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA  (nth 0 &ret$)) ; 寸法A
  (setq #DimB  (nth 1 &ret$)) ; 寸法B
  (setq #DimC  (nth 2 &ret$)) ; 寸法C
;L1+---------------------------+R1
;  | B +----+ C +--------+  A  |
;  |<->|ｺﾝﾛ |<->|  ｼﾝｸ   |<--->|
;  |   +----+   +--------+     |
;L2+---------------------------+R2

;;; PLINE と直線の距離を求めるための、直線の端点座標
  (setq #x1 (nth 1 #WTpt$)) ; WT右上点
  ;;; WT左上(0,0)とするUCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; ｼﾝｸ外形点列
  (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ｺﾝﾛ外形点列

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; 判定できない==>"ﾄｸ"
    (progn
      (cond
        ((= &WTLR "R") ; 右勝手のとき
          (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))
        )
        ((= &WTLR "L") ; 左勝手のとき
          (setq #distR (GetDistLineToPline (list #L1 #L2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #R1 #R2) #GASpt$))
        )
        (T ; それ以外 01/12/12 YM ADD "?"対応
          (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))
        )
      );_if

;;;01/12/12YM@MOD     (if (= &WTLR "R")
;;;01/12/12YM@MOD       (progn ; 右勝手のとき
;;;01/12/12YM@MOD         (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
;;;01/12/12YM@MOD         (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))
;;;01/12/12YM@MOD       )
;;;01/12/12YM@MOD       (progn ; 左勝手のとき
;;;01/12/12YM@MOD         (setq #distR (GetDistLineToPline (list #L1 #L2) #SNKpt$))
;;;01/12/12YM@MOD         (setq #distL (GetDistLineToPline (list #R1 #R2) #GASpt$))
;;;01/12/12YM@MOD       )
;;;01/12/12YM@MOD     );_if

      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      ; ｼﾝｸ-ｺﾝﾛ間のﾁｪｯｸ
      (setq #dist (GetDistPlineToPlineX #SNKpt$ #GASpt$)) ; UCS後ＷＴ配置角度=0を前提
      (if (not (equal #dist  #DimC 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ標準寸法: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ実寸法:   " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ標準寸法: " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ実寸法:   " (rtos #distL)))
      (CFOutStateLog 1 1 (strcat "ｼﾝｸ-ｺﾝﾛ標準寸法: " (rtos #DimC)))
      (CFOutStateLog 1 1 (strcat "ｼﾝｸ-ｺﾝﾛ実寸法:   " (rtos #dist)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-ｼﾝｸ標準寸法:  " (rtos #DimA)))
      (princ (strcat "\n WT-ｼﾝｸ実寸法:    " (rtos #distR)))
      (princ (strcat "\n WT-ｺﾝﾛ標準寸法:  " (rtos #DimB)))
      (princ (strcat "\n WT-ｺﾝﾛ実寸法:    " (rtos #distL)))
      (princ (strcat "\n ｼﾝｸ-ｺﾝﾛ標準寸法: " (rtos #DimC)))
      (princ (strcat "\n ｼﾝｸ-ｺﾝﾛ実寸法:   " (rtos #dist)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n標準ﾜｰｸﾄｯﾌﾟではありません。"))
      (command "._ucs" "P")
    )
  );_if

  ; 02/08/23 YM ADD-S 規格品と判定された寸法をｸﾞﾛｰﾊﾞﾙ保存する
  (if #STD_flg
    (setq CG_DIMSEQ &ret$)
  );_if
  ; 02/08/23 YM ADD-E

  #STD_flg
);KP_Std_DimCHeckI

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckI-G
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(ﾐｶﾄﾞ I型ｺﾝﾛのみ用)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 02/12/06 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckI-G (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  &WTLR     ; 左右の勝手
  /
  #ANG #DIMA #DIMB #DISTL #DISTR #ERRFLG #GASPT$ #L1 #L2 #R1 #R2 #STD_FLG #WTBASE
  #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA  (nth 0 &ret$)) ; 寸法A
  (setq #DimB  (nth 1 &ret$)) ; 寸法B
;L1+------------------+R1
;  | B +----+    A    |
;  |<->|ｺﾝﾛ |<------->|
;  |   +----+         |
;L2+------------------+R2

;;; PLINE と直線の距離を求めるための、直線の端点座標
  (setq #x1 (nth 1 #WTpt$)) ; WT右上点
  ;;; WT左上(0,0)とするUCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ｺﾝﾛ外形点列

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; 判定できない==>"ﾄｸ"
    (progn
      (setq #distR (GetDistLineToPline (list #R1 #R2) #GASpt$))
      (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ脇右標準寸法: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ脇右実寸法:   " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ脇左標準寸法: " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ脇左実寸法:   " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-ｺﾝﾛ脇右標準寸法:  " (rtos #DimA)))
      (princ (strcat "\n WT-ｺﾝﾛ脇右実寸法:    " (rtos #distR)))
      (princ (strcat "\n WT-ｺﾝﾛ脇左標準寸法:  " (rtos #DimB)))
      (princ (strcat "\n WT-ｺﾝﾛ脇左実寸法:    " (rtos #distL)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n標準ﾜｰｸﾄｯﾌﾟではありません。"))
      (command "._ucs" "P")
    )
  );_if

  ; 02/08/23 YM ADD-S 規格品と判定された寸法をｸﾞﾛｰﾊﾞﾙ保存する
  (if #STD_flg
    (setq CG_DIMSEQ &ret$)
  );_if
  ; 02/08/23 YM ADD-E

  #STD_flg
);KP_Std_DimCHeckI-G

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_DimCHeckI-G
;;; <処理概要>  : (ミカドI型ｺﾝﾛのみｺﾝﾛ脇寸法を返す)
;;; <戻り値>    : (右ｺﾝﾛ脇,左ｺﾝﾛ脇)
;;; <作成>      : 02/12/06 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_DimCHeckI-G (
  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  /
  #ANG #DISTL #DISTR #GASPT$ #L1 #L2 #R1 #R2 #WTBASE #WTPT$ #X1 #Y1 #RET$
  )
  (if (= nil &GasP)
    (progn ; 02/12/19 YM ADD ｶﾞｽ開口あしのとき落ちる-->ｴﾗｰ処理
      (setq #ret$ (list 0 0))
    )
    (progn
      (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
    ;L1+------------------+R1
    ;  | B +----+    A    |
    ;  |<->|ｺﾝﾛ |<------->|
    ;  |   +----+         |
    ;L2+------------------+R2

    ;;; PLINE と直線の距離を求めるための、直線の端点座標
      (setq #x1 (nth 1 #WTpt$)) ; WT右上点
      ;;; WT左上(0,0)とするUCS
      (setq #ang (angle #WTbase #x1))
      (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
      (command "._ucs" "3" #WTbase #x1 #y1)

      (setq #L1  (nth 0 #WTpt$))
      (setq #L2  (last  #WTpt$))
      (setq #R1  (nth 1 #WTpt$))
      (setq #R2  (nth 2 #WTpt$))

      (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ｺﾝﾛ外形点列
      (setq #distR (GetDistLineToPline (list #R1 #R2) #GASpt$)) ; 右ｺﾝﾛ脇
      (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$)) ; 左ｺﾝﾛ脇
      (command "._ucs" "P")
      (setq #ret$ (list #distR #distL))
    )
  );_if
);KP_DimCHeckI-G

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckI-ISC
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(ﾐｶﾄﾞ I型ｻｰｸﾙﾀｲﾌﾟ天板)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 02/08/30 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckI-ISC (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &SnkP     ; SINK PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  &WTLR     ; 左右の勝手
  /
  #ANG #DIMA #DIMB #DIMC #DISTL #DISTR #ERRFLG #L1 #L2 #R1 #R2 #SNKPT$ #STD_FLG
  #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA  (nth 0 &ret$)) ; 寸法A
  (setq #DimB  (nth 1 &ret$)) ; 寸法B
  (setq #DimC  (nth 2 &ret$)) ; 寸法C
;L1+---------------------------+R1
;  |     C      +--------+  A  |
;  |<---------->|  ｼﾝｸ   |<--->|
;  |            +--------+     |
;L2+---------------------------+R2

;;; PLINE と直線の距離を求めるための、直線の端点座標
  (setq #x1 (nth 1 #WTpt$)) ; WT右上点
  ;;; WT左上(0,0)とするUCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; ｼﾝｸ外形点列

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; 判定できない==>"ﾄｸ"
    (progn
      (cond
        ((= &WTLR "R") ; 右勝手のとき
          (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #L1 #L2) #SNKpt$))
        )
        ((= &WTLR "L") ; 左勝手のとき
          (setq #distR (GetDistLineToPline (list #L1 #L2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #R1 #R2) #SNKpt$))
        )
        (T ; それ以外 01/12/12 YM ADD "?"対応
          (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #L1 #L2) #SNKpt$))
        )
      );_if

      (if (or (and (equal #distR #DimA 0.1)(equal #distL #DimC 0.1))
              (and (equal #distR #DimC 0.1)(equal #distL #DimA 0.1)))
        nil ; 規格品
      ; else
        (setq #STD_flg nil)
      );_if

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ右実寸法:    " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ左実寸法:    " (rtos #distL)))
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ横標準寸法1: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ横標準寸法2: " (rtos #DimB)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat " WT-ｼﾝｸ右実寸法:    " (rtos #distR)))
      (princ (strcat " WT-ｼﾝｸ左実寸法:    " (rtos #distL)))
      (princ (strcat " WT-ｼﾝｸ横標準寸法1: " (rtos #DimA)))
      (princ (strcat " WT-ｼﾝｸ横標準寸法2: " (rtos #DimB)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n標準ﾜｰｸﾄｯﾌﾟではありません。"))
      (command "._ucs" "P")
    )
  );_if

  #STD_flg
);KP_Std_DimCHeckI-ISC

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckIDAN
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(ﾐｶﾄﾞ I型段差ﾌﾟﾗﾝ用)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 01/02/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckIDAN (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &SnkP     ; SINK PMEN PLINE
;;;  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  #CutType  ; ｶｯﾄﾀｲﾌﾟ"40","04"など
  /
  #ANG #DIMA #DIMB #DISTL #DISTR #ERRFLG #L1 #L2 #R1 #R2 #SNKPT$ #STD_FLG #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA  (nth 0 &ret$)) ; 寸法A
  (setq #DimB  (nth 1 &ret$)) ; 寸法B(段差接続部との距離)

;;; PLINE と直線の距離を求めるための、直線の端点座標
  (setq #x1 (nth 1 #WTpt$)) ; WT右上点
  ;;; WT左上(0,0)とするUCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; ｼﾝｸ外形点列
;;;  (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ｺﾝﾛ外形点列

;              L1
;  +-----------+------------------+R1
;  |   +----+  | B +--------+  A  |
;  |   |ｺﾝﾛ |  |<->|  ｼﾝｸ   |<--->|
;  |   +----+  |   +--------+     |
;  +-----------+------------------+R2
;              L2

;  L1
;  +------------------+------------+R1
;  |     +--------+ B |  +------+  |
;  |<-A->|ｼﾝｸ     |<->|  |  ｺﾝﾛ |  |
;  |     +--------+   |  +------+  |
;  +------------------+------------+R2
; L2

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; 判定できない==>"ﾄｸ"
    (progn
      (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
      (setq #distL (GetDistLineToPline (list #L1 #L2) #SNKpt$))

      (if (= (substr #CutType 1 1) "4") ; 左側段差接続部(右勝手)
        (progn
          (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
          (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

          (CFOutStateLog 1 1 "--------------------------------------------------")
          (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ標準寸法:         " (rtos #DimA)))
          (CFOutStateLog 1 1 (strcat " WT右-ｼﾝｸ実寸法:         " (rtos #distR)))
          (CFOutStateLog 1 1 (strcat " 段差接続部-ｼﾝｸ標準寸法: " (rtos #DimB)))
          (CFOutStateLog 1 1 (strcat " WT左-ｼﾝｸ実寸法:         " (rtos #distL)))
          (CFOutStateLog 1 1 "--------------------------------------------------")

          (princ "\n--------------------------------------------------")
          (princ (strcat "\n WT-ｼﾝｸ標準寸法:         " (rtos #DimA)))
          (princ (strcat "\n WT右-ｼﾝｸ実寸法:         " (rtos #distR)))
          (princ (strcat "\n 段差接続部-ｼﾝｸ標準寸法: " (rtos #DimB)))
          (princ (strcat "\n WT左-ｼﾝｸ実寸法:         " (rtos #distL)))
          (princ "\n--------------------------------------------------")

        )
        (progn ; 右側段差接続部(左勝手)
          (if (not (equal #distR #DimB 0.1))(setq #STD_flg nil))
          (if (not (equal #distL #DimA 0.1))(setq #STD_flg nil))

          (CFOutStateLog 1 1 "--------------------------------------------------")
          (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ標準寸法:         " (rtos #DimA)))
          (CFOutStateLog 1 1 (strcat " WT右-ｼﾝｸ実寸法:         " (rtos #distL)))
          (CFOutStateLog 1 1 (strcat " 段差接続部-ｼﾝｸ標準寸法: " (rtos #DimB)))
          (CFOutStateLog 1 1 (strcat " WT左-ｼﾝｸ実寸法:         " (rtos #distR)))
          (CFOutStateLog 1 1 "--------------------------------------------------")

          (princ "\n--------------------------------------------------")
          (princ (strcat "\n WT-ｼﾝｸ標準寸法:         " (rtos #DimA)))
          (princ (strcat "\n WT右-ｼﾝｸ実寸法:         " (rtos #distL)))
          (princ (strcat "\n 段差接続部-ｼﾝｸ標準寸法: " (rtos #DimB)))
          (princ (strcat "\n WT左-ｼﾝｸ実寸法:         " (rtos #distR)))
          (princ "\n--------------------------------------------------")
        )
      );_if

      (if (= #STD_flg nil)(princ "\n標準ﾜｰｸﾄｯﾌﾟではありません。"))
      (command "._ucs" "P")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckIDAN

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckIS
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(ﾐｶﾄﾞ L型人大ｼﾝｸ側用)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 01/02/13 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckIS (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &SnkP     ; SINK PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  &WTLR     ; 左右の勝手
  /
  #ANG #DIMA #DISTR #ERRFLG #L1 #L2 #R1 #R2 #SNKPT$ #STD_FLG #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA  (nth 0 &ret$)) ; 寸法A
;L1+---------------------------+R1
;  |            +--------+  A  |
;  |            |  ｼﾝｸ   |<--->|
;  |            +--------+     |
;L2+---------------------------+R2

;;; PLINE と直線の距離を求めるための、直線の端点座標
  (setq #x1 (nth 1 #WTpt$)) ; WT右上点
  ;;; WT左上(0,0)とするUCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

; 02/12/06 YM ロジック変更斜めｶｯﾄで誤動作
  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (polar #L1 (- #ang (dtr 90)) 1000))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (polar #R1 (- #ang (dtr 90)) 1000))

; 02/12/06 YM ロジック変更斜めｶｯﾄで誤動作
;;;  (setq #L1  (nth 0 #WTpt$))
;;;  (setq #L2  (last  #WTpt$))
;;;  (setq #R1  (nth 1 #WTpt$))
;;;  (setq #R2  (nth 2 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; ｼﾝｸ外形点列
  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; 判定できない==>"ﾄｸ"
    (progn
      (cond
        ((= &WTLR "R")(setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$)));右勝手のとき
        ((= &WTLR "L")(setq #distR (GetDistLineToPline (list #L1 #L2) #SNKpt$)));左勝手のとき
        (T            (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$)));？勝手のとき 01/12/12 YM ADD
      );_cond
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ標準寸法: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ実寸法:   " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-ｼﾝｸ標準寸法: " (rtos #DimA)))
      (princ (strcat "\n WT-ｼﾝｸ実寸法:   " (rtos #distR)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n標準ﾜｰｸﾄｯﾌﾟではありません。"))
      (command "._ucs" "P")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckIS

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckIG
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(ﾐｶﾄﾞ I型用)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 01/02/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckIG (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  &WTLR     ; 左右の勝手
  /
  #ANG #DIMB #DISTL #ERRFLG #GASPT$ #L1 #L2 #R1 #R2 #STD_FLG #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimB  (nth 1 &ret$)) ; 寸法B
;L1+---------------------------+R1
;  | B +----+                  |
;  |<->|ｺﾝﾛ |                  |
;  |   +----+                  |
;L2+---------------------------+R2

;;; PLINE と直線の距離を求めるための、直線の端点座標
  (setq #x1 (nth 1 #WTpt$)) ; WT右上点
  ;;; WT左上(0,0)とするUCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

; 02/12/06 YM ロジック変更斜めｶｯﾄで誤動作
  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (polar #L1 (- #ang (dtr 90)) 1000))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (polar #R1 (- #ang (dtr 90)) 1000))

; 02/12/06 YM ロジック変更斜めｶｯﾄで誤動作
;;;  (setq #L1  (nth 0 #WTpt$))
;;;  (setq #L2  (last  #WTpt$))
;;;  (setq #R1  (nth 1 #WTpt$))
;;;  (setq #R2  (nth 2 #WTpt$))

  (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ｺﾝﾛ外形点列
  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; 判定できない==>"ﾄｸ"
    (progn
      (cond
        ((= &WTLR "R")(setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))); 右勝手のとき
        ((= &WTLR "L")(setq #distL (GetDistLineToPline (list #R1 #R2) #GASpt$))); 左勝手のとき
        (T            (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))); ? 勝手のとき→右勝手 01/12/12 YM
      );_cond
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ標準寸法: " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ実寸法:   " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-ｺﾝﾛ標準寸法: " (rtos #DimB)))
      (princ (strcat "\n WT-ｺﾝﾛ実寸法:   " (rtos #distL)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n標準ﾜｰｸﾄｯﾌﾟではありません。"))
      (command "._ucs" "P")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckIG

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckIGDAN
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(ﾐｶﾄﾞ 人大L型Jﾌﾟﾗﾝｺﾝﾛ側)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 01/03/24 YM
;;; <備考>      : 段差ｺﾝﾛ側ｺﾝﾛなし斜めｶｯﾄ
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckIGDAN (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  /
  #ANG #DIMB #DIST #ERRFLG #L1 #L2 #R1 #R2 #STD_FLG #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimB  (nth 0 &ret$)) ; 寸法B(ｺﾝﾛ側間口)
;         B
;L1+---------------+R1
;  |
;  |  右勝手
;  |
;L2+------+R2

;         B
;L1+---------------+R1
;   .              |
;    .  右勝手     |
;     .            |
;       L2+--------+R2

;;; PLINE と直線の距離を求めるための、直線の端点座標
  (setq #x1 (nth 1 #WTpt$)) ; WT右上点
  ;;; WT左上(0,0)とするUCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; 判定できない==>"ﾄｸ"
    (progn
      (setq #dist (distance #L1 #R1))
      (if (not (equal #dist #DimB 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " ｺﾝﾛ標準間口: " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " ｺﾝﾛ間口実寸: " (rtos #dist)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n ｺﾝﾛ標準間口: " (rtos #DimB)))
      (princ (strcat "\n ｺﾝﾛ間口実寸: " (rtos #dist)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n標準ﾜｰｸﾄｯﾌﾟではありません。"))
      (command "._ucs" "P")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckIGDAN

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckIGDAN2
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(ﾐｶﾄﾞ 人大L型Jﾌﾟﾗﾝｺﾝﾛ側)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 01/07/06 YM
;;; <備考>      : SKｽﾃﾝﾚｽ段差ｺﾝﾛ側ｺﾝﾛなし斜めｶｯﾄ(寸法Aは短い方)
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckIGDAN2 (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  /
  #ANG #DIMB #DIST #ERRFLG #L1 #L2 #R1 #R2 #STD_FLG #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimB  (nth 0 &ret$)) ; 寸法B(ｺﾝﾛ側間口)
;         B
;L1+---------------+R1
;  |
;  |  右勝手
;  |
;L2+------+R2

;         B
;L1+---------------+R1
;   .              |
;    .  右勝手     |
;     .            |
;       L2+--------+R2

;;; PLINE と直線の距離を求めるための、直線の端点座標
  (setq #x1 (nth 1 #WTpt$)) ; WT右上点
  ;;; WT左上(0,0)とするUCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; 判定できない==>"ﾄｸ"
    (progn
      (setq #dist (distance #L2 #R2))
;;;     (setq #dist (distance #L1 #R1))
      (if (not (equal #dist #DimB 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " ｺﾝﾛ標準間口: " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " ｺﾝﾛ間口実寸: " (rtos #dist)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n ｺﾝﾛ標準間口: " (rtos #DimB)))
      (princ (strcat "\n ｺﾝﾛ間口実寸: " (rtos #dist)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n標準ﾜｰｸﾄｯﾌﾟではありません。"))
      (command "._ucs" "P")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckIGDAN2

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckL
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(ﾐｶﾄﾞ ｽﾃﾝﾚｽL型用)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 01/02/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckL (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &SnkP     ; SINK PMEN PLINE
  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  &WTLR     ; 左右の勝手
  /
  #DIMA #DIMB #DISTL #DISTR #GASPT$ #P1 #P2 #P3 #P4 #P5 #P6 #SNKPT$ #STD_FLG #WTBASE #WTPT$
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA (nth 0 &ret$)) ; 寸法A
  (setq #DimB (nth 1 &ret$)) ; 寸法B

; 右勝手   X1
;  p1------*-------------------+p2
;  |       |    +--------+  A  |
;  |       |    |  ｼﾝｸ   |<--->|
;  |       |    +--------+     |
;X2*------ p4------------------+p3
;  |       |
;  |       |
;  | +---+ |
;  | |ｺﾝﾛ| |
;  | +---+ |
;  |   |   |
;  |   |B  |
;  |   |   |
;  p6------p5

;;; PLINE と直線の距離を求めるための、直線の端点座標
  (setq #p1 (nth 0 #WTpt$))
  (setq #p2 (nth 1 #WTpt$))
  (setq #p3 (nth 2 #WTpt$))
  (setq #p4 (nth 3 #WTpt$))
  (setq #p5 (nth 4 #WTpt$))
  (setq #p6 (nth 5 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; ｼﾝｸ外形点列
  (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ｺﾝﾛ外形点列

  ; 01/12/12 YM ADD "?"勝手対応
  (cond
    ((= &WTLR "R") ; 右勝手のとき
      ; 右側のﾁｪｯｸ
      (setq #distR (GetDistLineToPline (list #p2 #p3) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      ; 左側のﾁｪｯｸ
      (setq #distL (GetDistLineToPline (list #p5 #p6) #GASpt$))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ標準寸法      : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ実寸法        : " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ標準寸法      : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ実寸法        : " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-ｼﾝｸ標準寸法      : " (rtos #DimA)))
      (princ (strcat "\n WT-ｼﾝｸ実寸法        : " (rtos #distR)))
      (princ (strcat "\n WT-ｺﾝﾛ標準寸法      : " (rtos #DimB)))
      (princ (strcat "\n WT-ｺﾝﾛ実寸法        : " (rtos #distL)))
      (princ "\n--------------------------------------------")
    )
    ((= &WTLR "L") ; 左勝手のとき
      ; 右側のﾁｪｯｸ
      (setq #distL (GetDistLineToPline (list #p5 #p6) #SNKpt$))
      (if (not (equal #distL #DimA 0.1))(setq #STD_flg nil))
      ; 左側のﾁｪｯｸ
      (setq #distR (GetDistLineToPline (list #p2 #p3) #GASpt$))
      (if (not (equal #distR #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ標準寸法      : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ実寸法        : " (rtos #distL)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ標準寸法      : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ実寸法        : " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-ｼﾝｸ標準寸法      : " (rtos #DimA)))
      (princ (strcat "\n WT-ｼﾝｸ実寸法        : " (rtos #distL)))
      (princ (strcat "\n WT-ｺﾝﾛ標準寸法      : " (rtos #DimB)))
      (princ (strcat "\n WT-ｺﾝﾛ実寸法        : " (rtos #distR)))
      (princ "\n--------------------------------------------")

    )
    (T  ; ?勝手のとき
      ; 右側のﾁｪｯｸ
      (setq #distR (GetDistLineToPline (list #p2 #p3) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      ; 左側のﾁｪｯｸ
      (setq #distL (GetDistLineToPline (list #p5 #p6) #GASpt$))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ標準寸法      : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-ｼﾝｸ実寸法        : " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ標準寸法      : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-ｺﾝﾛ実寸法        : " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-ｼﾝｸ標準寸法      : " (rtos #DimA)))
      (princ (strcat "\n WT-ｼﾝｸ実寸法        : " (rtos #distR)))
      (princ (strcat "\n WT-ｺﾝﾛ標準寸法      : " (rtos #DimB)))
      (princ (strcat "\n WT-ｺﾝﾛ実寸法        : " (rtos #distL)))
      (princ "\n--------------------------------------------")
    )

  );_if
  (if (= #STD_flg nil)(princ "\n標準ﾜｰｸﾄｯﾌﾟではありません。"))
  #STD_flg
);KP_Std_DimCHeckL

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeckLDAN
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(ﾐｶﾄﾞ ｽﾃﾝﾚｽL型Jﾌﾟﾗﾝ用)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 01/03/23 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckLDAN (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &SnkP     ; SINK PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  &WTLR     ; 左右の勝手
  /
  #DIMA #DIMB #DISTL #DISTR #P1 #P2 #P3 #P4 #P5 #P6 #SNKPT$ #STD_FLG #WTBASE #WTPT$
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA (nth 0 &ret$)) ; 寸法A
  (setq #DimB (nth 1 &ret$)) ; 寸法B

; 右勝手
;  p1--------------------------+p2
;  |            +--------+  A  |
;  |            |  ｼﾝｸ   |<--->|
; B|            +--------+     |
;  |       p4------------------+p3
;  |       |
;  p6------p5

; 左勝手
;  p1----------+p2
;  |           |
;  |           |B
;  |           |
;  |       p4--+p3
;  |       |
;  | +---+ |
;  | |   | |
;  | +---+ |
;  |       |
;  |   A   |
;  |       |
;  p6------p5

;;; PLINE と直線の距離を求めるための、直線の端点座標
  (setq #p1 (nth 0 #WTpt$))
  (setq #p2 (nth 1 #WTpt$))
  (setq #p3 (nth 2 #WTpt$))
  (setq #p4 (nth 3 #WTpt$))
  (setq #p5 (nth 4 #WTpt$))
  (setq #p6 (nth 5 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; ｼﾝｸ外形点列

  ; 01/12/12 YM ADD "?"勝手対応
  (cond
    ((= &WTLR "R") ; 右勝手のとき
      ; 右側のﾁｪｯｸ
      (setq #distR (GetDistLineToPline (list #p2 #p3) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      ; ｺﾝﾛ側のﾁｪｯｸ
      (setq #distL (distance #p1 #p6))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " 標準ｼﾝｸ脇寸法   : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " 実ｼﾝｸ脇実寸法   : " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " 標準ｺﾝﾛ側間口   : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " 実ｺﾝﾛ側間口     : " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n-----------------------------------------")
      (princ (strcat "\n 標準ｼﾝｸ脇寸法   : " (rtos #DimA)))
      (princ (strcat "\n 実ｼﾝｸ脇実寸法   : " (rtos #distR)))
      (princ (strcat "\n 標準ｺﾝﾛ側間口   : " (rtos #DimB)))
      (princ (strcat "\n 実ｺﾝﾛ側間口     : " (rtos #distL)))
      (princ "\n-----------------------------------------")

    )
    ((= &WTLR "L") ; 左勝手のとき
      ; ｼﾝｸ脇(左側)のﾁｪｯｸ
      (setq #distL (GetDistLineToPline (list #p5 #p6) #SNKpt$))
      (if (not (equal #distL #DimA 0.1))(setq #STD_flg nil))
      ; 反対側(右側)のﾁｪｯｸ
      (setq #distR (distance #p1 #p2))
      (if (not (equal #distR #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " 標準ｼﾝｸ脇寸法   : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " ｼﾝｸ左脇実寸法   : " (rtos #distL)))
      (CFOutStateLog 1 1 (strcat " 標準ｺﾝﾛ側間口   : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " ｺﾝﾛ側間口実寸法 : " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n-----------------------------------------")
      (princ (strcat "\n 標準ｼﾝｸ脇寸法   : " (rtos #DimA)))
      (princ (strcat "\n ｼﾝｸ左脇実寸法   : " (rtos #distL)))
      (princ (strcat "\n 標準ｺﾝﾛ側間口   : " (rtos #DimB)))
      (princ (strcat "\n ｺﾝﾛ側間口実寸法 : " (rtos #distR)))
      (princ "\n-----------------------------------------")

    )
    (T ; ?勝手のとき
      ; 右側のﾁｪｯｸ
      (setq #distR (GetDistLineToPline (list #p2 #p3) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      ; ｺﾝﾛ側のﾁｪｯｸ
      (setq #distL (distance #p1 #p6))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " 標準ｼﾝｸ脇寸法   : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " 実ｼﾝｸ脇実寸法   : " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " 標準ｺﾝﾛ側間口   : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " 実ｺﾝﾛ側間口     : " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n-----------------------------------------")
      (princ (strcat "\n 標準ｼﾝｸ脇寸法   : " (rtos #DimA)))
      (princ (strcat "\n 実ｼﾝｸ脇実寸法   : " (rtos #distR)))
      (princ (strcat "\n 標準ｺﾝﾛ側間口   : " (rtos #DimB)))
      (princ (strcat "\n 実ｺﾝﾛ側間口     : " (rtos #distL)))
      (princ "\n-----------------------------------------")

    )

  );_if

  #STD_flg
);KP_Std_DimCHeckLDAN

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeck_RLS
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(WK ﾗﾋﾟｽL型ｼﾝｸ側用)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 00/12/20 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeck_RLS (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &SnkP     ; SINK PMEN PLINE
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  &cutTYPE  ; WTｶｯﾄﾀｲﾌﾟ
  /
  #DIMA #DIMB1 #DISTL #DISTR #L1 #L2 #R1 #R2 #SNKPT$ #STD_FLG #WTPT$ #X1
  )
  (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
  (setq #WTpt$ &WTpt$)
  (setq #DimA  (nth 0 &ret$)) ; 寸法A
  (setq #DimB1 (nth 1 &ret$)) ; 寸法B1

; 斜めｶｯﾄ(右勝手)
;L1+----@X1--------------------+R1
;       |       +--------+  A  |
;       |  B1   |  ｼﾝｸ   |<--->|
;       <------>+--------+     |
;     L2+----------------------+R2

; 斜めｶｯﾄ(左勝手)
;L1+----------------------@X1--+R1
;  |   A   +--------+     |
;  |<----->|  ｼﾝｸ   |  B1 |
;  |       +--------+<---->
;L2+----------------------+R2

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))
  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; ｼﾝｸ外形点列

  (if (= (substr &cutTYPE 1 1) "3")
    (progn ; 右勝手のとき(左が斜めｶｯﾄ)
      (setq #x1 (CFGetDropPt #L2 (list #L1 #R1)))
      ; 右側のﾁｪｯｸ
      (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｼﾝｸ標準寸法A: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｼﾝｸ実寸法:    " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")
      ; 左側のﾁｪｯｸ
      (setq #distL (GetDistLineToPline (list #X1 #L2) #SNKpt$))
      (if (not (equal #distL #DimB1 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｼﾝｸ標準寸法B1: " (rtos #DimB1)))
      (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｼﾝｸ実寸法:     " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")
    )
  );_if

  (if (= (substr &cutTYPE 2 1) "3")
    (progn ; 左勝手のとき(右が斜めｶｯﾄ)
      (setq #x1 (CFGetDropPt #R2 (list #L1 #R1)))
      ; 右側のﾁｪｯｸ
      (setq #distR (GetDistLineToPline (list #X1 #R2) #SNKpt$))
      (if (not (equal #distR #DimB1 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｼﾝｸ標準寸法B1: " (rtos #DimB1)))
      (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｼﾝｸ実寸法:     " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")
      ; 左側のﾁｪｯｸ
      (setq #distL (GetDistLineToPline (list #L1 #L2) #SNKpt$))
      (if (not (equal #distL #DimA 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｼﾝｸ標準寸法A: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｼﾝｸ実寸法:    " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeck_RLS

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_Std_DimCHeck_RLG
;;; <処理概要>  : 標準WTかどうかの寸法ﾁｪｯｸ(WK ﾗﾋﾟｽL型ｺﾝﾛ側用)
;;; <戻り値>    : 標準:T 標準以外:nil
;;; <作成>      : 00/12/20 YM
;;; <備考>      : ｺﾝﾛ穴W600でないと判定不要(標準WTでない)
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeck_RLG (
  &ret$     ; 標準条件寸法ﾘｽﾄ
  &GasP     ; GAS  PMEN PLINE
  &eGAS     ; ｺﾝﾛｼﾝﾎﾞﾙ図形
  &WTpt$    ; WT外形点列(WT左上点から時計まわり)
  &cutTYPE  ; WTｶｯﾄﾀｲﾌﾟ
  /
  #DIMB2 #DIMC #DISTL #DISTR #GASPT$ #L1 #L2 #R1 #R2 #STD_FLG #WTPT$ #X1
  )
  (if (equal (nth 3 (CFGetXData &eGAS "G_SYM")) 600 0.1) ; ｺﾝﾛ寸法W
    (progn ; 判定を行う
      (setq #STD_flg T) ; 標準寸法==>T 標準でない==>nil 最初標準と仮定
      (setq #WTpt$ &WTpt$)
      (setq #DimB2 (nth 2 &ret$)) ; 寸法B2
      (setq #DimC  (nth 3 &ret$)) ; 寸法C

    ; 斜めｶｯﾄ(右勝手)
    ;L1+----@X1--------------------+R1
    ;       |       +--------+  C  |
    ;       |  B2   |  ｺﾝﾛ   |<--->|
    ;       <------>+--------+     |
    ;     L2+----------------------+R2

    ; 斜めｶｯﾄ(左勝手)
    ;L1+----------------------@X1--+R1
    ;  |   C   +--------+     |
    ;  |<----->|  ｺﾝﾛ   |  B2 |
    ;  |       +--------+<---->
    ;L2+----------------------+R2

      (setq #L1  (nth 0 #WTpt$))
      (setq #L2  (last  #WTpt$))
      (setq #R1  (nth 1 #WTpt$))
      (setq #R2  (nth 2 #WTpt$))
      (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ｺﾝﾛ外形点列

      (if (= (substr &cutTYPE 1 1) "3")
        (progn ; 右勝手のとき(左が斜めｶｯﾄ)
          (setq #x1 (CFGetDropPt #L2 (list #L1 #R1)))
          ; 右側のﾁｪｯｸ
          (setq #distR (GetDistLineToPline (list #R1 #R2) #GASpt$))
          (if (not (equal #distR #DimC 0.1))(setq #STD_flg nil))
          (CFOutStateLog 1 1 "--------------------------------------------")
          (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｺﾝﾛ標準寸法C: " (rtos #DimC)))
          (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｺﾝﾛ実寸法:    " (rtos #distR)))
          (CFOutStateLog 1 1 "--------------------------------------------")
          ; 左側のﾁｪｯｸ
          (setq #distL (GetDistLineToPline (list #X1 #L2) #GASpt$))
          (if (not (equal #distL #DimB2 0.1))(setq #STD_flg nil))
          (CFOutStateLog 1 1 "--------------------------------------------")
          (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｺﾝﾛ標準寸法B2: " (rtos #DimB2)))
          (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｺﾝﾛ実寸法:     " (rtos #distL)))
          (CFOutStateLog 1 1 "--------------------------------------------")
        )
      );_if

      (if (= (substr &cutTYPE 2 1) "3")
        (progn ; 左勝手のとき(右が斜めｶｯﾄ)
          (setq #x1 (CFGetDropPt #R2 (list #L1 #R1)))
          ; 右側のﾁｪｯｸ
          (setq #distR (GetDistLineToPline (list #X1 #R2) #GASpt$))
          (if (not (equal #distR #DimB2 0.1))(setq #STD_flg nil))
          (CFOutStateLog 1 1 "--------------------------------------------")
          (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｺﾝﾛ標準寸法B2: " (rtos #DimB2)))
          (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｺﾝﾛ実寸法:     " (rtos #distR)))
          (CFOutStateLog 1 1 "--------------------------------------------")
          ; 左側のﾁｪｯｸ
          (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))
          (if (not (equal #distL #DimC 0.1))(setq #STD_flg nil))
          (CFOutStateLog 1 1 "--------------------------------------------")
          (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｺﾝﾛ標準寸法C: " (rtos #DimC)))
          (CFOutStateLog 1 1 (strcat " L型ﾗﾋﾟｽWT-ｺﾝﾛ実寸法:    " (rtos #distL)))
          (CFOutStateLog 1 1 "--------------------------------------------")
        )
      );_if
    )
    (progn ; 判定不要
      (setq #STD_flg nil)
    )
  );_if
  #STD_flg
);KP_Std_DimCHeck_RLG

;;;<HOM>*************************************************************************
;;; <関数名>    : GetDistLineToPline
;;; <処理概要>  : PLINEの各点から直線に下ろした垂線長さの最小を求める
;;;               両者が交われば　-999 を返す
;;; <戻り値>    : PLINEの各点から直線に下ろした垂線長さの最小(実数)
;;; <作成>      : 00/10/27 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun GetDistLineToPline (
  &line$ ; 直線の始点,終点ﾘｽﾄ
  &pt$   ; PLINE外形点列
  /
  #DIS #DIS_MIN
  )
  (setq #dis_min 1.0e+10)
  (if (PKDirectPT &pt$ &line$) ; 点列がすべて直線&ret_lis$の同じ側にある = nil ない T
    (setq #dis_min -999)
    (progn
      (foreach #pt &pt$
        (setq #dis (distance #pt (CFGetDropPt #pt &line$))) ; 直線におろした垂線の長さ
        (if (<= #dis #dis_min)
          (setq #dis_min #dis) ; 線分とPMENの最短距離 = #dis_min
        );_if
      )
    )
  );_if
  #dis_min
);GetDistLineToPline

;;;<HOM>*************************************************************************
;;; <関数名>    : GetDistPlineToPlineX
;;; <処理概要>  : PLINEとPLINEの最短距離(実数)を求める(ｼﾝｸ側)
;;; <戻り値>    : PLINEとPLINEの最短距離(実数)
;;; <作成>      : 00/10/27 YM
;;; <備考>      : UCS後ＷＴ配置角度=0を前提
;;;*************************************************************************>MOH<
(defun GetDistPlineToPlineX (
  &pt1$   ; ｼﾝｸPLINE外形点列
  &pt2$   ; ｺﾝﾛPLINE外形点列
  /
  #DIS_MIN #MAX1 #MAX2 #MIN1 #MIN2 #X1$ #X2$ #PT1$ #PT2$
  )
  (setq #pt1$ '())
  (setq #pt2$ '())
  (foreach #p1 &pt1$
    (setq #pt1$ (append #pt1$ (list (trans #p1 0 1)))) ; ﾕｰｻﾞｰ座標系に変換
  )
  (foreach #p2 &pt2$
    (setq #pt2$ (append #pt2$ (list (trans #p2 0 1)))) ; ﾕｰｻﾞｰ座標系に変換
  )
  (setq #x1$ (mapcar 'car #pt1$))
  (setq #x2$ (mapcar 'car #pt2$))
  (setq #max1 (apply 'max #x1$))
  (setq #min1 (apply 'min #x1$))
  (setq #max2 (apply 'max #x2$))
  (setq #min2 (apply 'min #x2$))
  (if (< #max1 #min2)
    (setq #dis_min (- #min2 #max1))
    (setq #dis_min (- #min1 #max2))
  );_if
);GetDistPlineToPlineX

;;;<HOM>*************************************************************************
;;; <関数名>    : GetDistPlineToPlineY
;;; <処理概要>  : PLINEとPLINEの最短距離(実数)を求める(ｺﾝﾛ側)
;;; <戻り値>    : PLINEとPLINEの最短距離(実数)
;;; <作成>      : 00/10/27 YM
;;; <備考>      : UCS後ＷＴ配置角度=0を前提
;;;*************************************************************************>MOH<
(defun GetDistPlineToPlineY (
  &pt1$   ; ｼﾝｸPLINE外形点列
  &pt2$   ; ｺﾝﾛPLINE外形点列
  /
  #DIS_MIN #MAX1 #MAX2 #MIN1 #MIN2 #Y1$ #Y2$ #PT1$ #PT2$
  )
  (setq #pt1$ '())
  (setq #pt2$ '())
  (foreach #p1 &pt1$
    (setq #pt1$ (append #pt1$ (list (trans #p1 0 1)))) ; ﾕｰｻﾞｰ座標系に変換
  )
  (foreach #p2 &pt2$
    (setq #pt2$ (append #pt2$ (list (trans #p2 0 1)))) ; ﾕｰｻﾞｰ座標系に変換
  )
  (setq #y1$ (mapcar 'cadr #pt1$))
  (setq #y2$ (mapcar 'cadr #pt2$))
  (setq #max1 (apply 'max #y1$))
  (setq #min1 (apply 'min #y1$))
  (setq #max2 (apply 'max #y2$))
  (setq #min2 (apply 'min #y2$))
  (if (< #max1 #min2)
    (setq #dis_min (- #min2 #max1))
    (setq #dis_min (- #min1 #max2))
  );_if
);GetDistPlineToPlineY

;;; <HOM>***********************************************************************************
;;; <関数名>    : KP_GetStdDim
;;; <処理概要>  : 標準WTかどうか判定する各種寸法値を得る
;;; <戻り値>    : リスト (寸法A,寸法B,寸法C)
;;; <作成>      : 01/02/12 YM
;;; <備考>      : 間口1,2はｼﾝｸ側,ｺﾝﾛ側の順で引き渡す
;                  Genic,Notil,Cena用
;;; ***********************************************************************************>MOH<
(defun KP_GetStdDim (
  &MAG1    ; 間口1 "2550"
  &MAG2    ; 間口2 "0" "1650"
  &WT_type ; WTﾀｲﾌﾟ "I","L"
  &ZaiF    ; 素材 0,1
  &SNK     ; ｼﾝｸ記号"SA"
  &WTLR    ; 勝手
  &Type    ; ﾀｲﾌﾟ "F" or "J"
  /
  #DIMA #DIMB #DIMC #ERR1 #QRY$$ #RET$ #ZAIF #msg
  )
  (setq #msg "標準WTの判定ができませんでした。")
  ; 引数ﾁｪｯｸ
  (if (and &MAG1 &MAG2 &WT_type &ZaiF &SNK &WTLR &Type)
    (progn
      (setq #Err1 nil)
      (setq #ZaiF (itoa (fix &ZaiF)))
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "標準WT寸法"
          (list
            (list "間口1"      &MAG1    'INT)
            (list "間口2"      &MAG2    'INT)
            (list "WT形状"     &WT_type 'STR)
            (list "タイプ"     &Type    'STR)
            (list "素材F"      #ZaiF    'INT)
            (list "シンク記号" &SNK     'STR)
          )
        )
      )
      (if #qry$$
        (progn
          (CFOutStateLog 1 1 "---標準WTシンク-----------------------------")
          (CFOutStateLog 1 1 #qry$$)
          (CFOutStateLog 1 1 (strcat "間口1     :" &MAG1))
          (CFOutStateLog 1 1 (strcat "間口2     :" &MAG2))
          (CFOutStateLog 1 1 (strcat "WT形状    :" &WT_type))
          (CFOutStateLog 1 1 (strcat "タイプ    :" &Type))
          (CFOutStateLog 1 1 (strcat "素材F     :" #ZaiF))
          (CFOutStateLog 1 1 (strcat "シンク記号:" &SNK))

          (setq #ret$ nil)
          (foreach #qry$ #qry$$
            (CFOutStateLog 1 1 "--------------------------------------------")
            (setq #DimA (nth 7 #qry$)) ; 寸法A
            (setq #DimB (nth 8 #qry$)) ; 寸法B
            (setq #DimC (nth 9 #qry$)) ; 寸法C
            (setq #ret$ (append #ret$ (list (list #DimA #DimB #DimC))))
            (CFOutStateLog 1 1 (strcat "寸法A     :" (rtos #DimA)))
            (CFOutStateLog 1 1 (strcat "寸法B     :" (rtos #DimB)))
            (CFOutStateLog 1 1 (strcat "寸法C     :" (rtos #DimC)))
          )
          (CFOutStateLog 1 1 "--------------------------------------------")
        )
        (progn
          (setq #Err1 T) ; ﾚｺｰﾄﾞなし
          (CFAlertMsg (strcat #msg "ﾚｺｰﾄﾞがありません。"))
        )
      );_if
    )
    (progn
      (setq #Err1 T) ; 引数nil
      (CFAlertMsg (strcat #msg  "検索ｷｰがありません。"))
    )
  );_if

  (if #Err1
    nil
    #ret$
  );_if
);KP_GetStdDim

;;; <HOM>***********************************************************************************
;;; <関数名>    : KP_GetStdDimS&S
;;; <処理概要>  : 標準WTかどうか判定する各種寸法値を得る
;;; <戻り値>    : リスト (寸法A,寸法B,寸法C)
;;; <作成>      : 01/07/03 YM
;;; <備考>      :
;;; ***********************************************************************************>MOH<
(defun KP_GetStdDimS&S (
  &MAG1    ; 間口1 "2550"
  &WT_type ; WTﾀｲﾌﾟ "I","L"
  &ZaiF    ; 素材 0,1
  &SNK     ; ｼﾝｸ記号"SA"
  &WTLR    ; 勝手
  &Type    ; ﾀｲﾌﾟ "F" or "J"
  /
  #DIMA #DIMB #DIMC #ERR1 #QRY$$ #RET$ #ZAIF #msg
  )
  (setq #msg "標準WTの判定ができませんでした。")
  ; 引数ﾁｪｯｸ
  (if (and &MAG1 &WT_type &ZaiF &SNK &WTLR &Type)
    (progn
      (setq #Err1 nil)
      (setq #ZaiF (itoa (fix &ZaiF)))
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "標準WT寸法"
          (list
            (list "間口1"      &MAG1    'INT)
            (list "WT形状"     &WT_type 'STR)
            (list "タイプ"     &Type    'STR)
            (list "素材F"      #ZaiF    'INT)
            (list "シンク記号" &SNK     'STR)
          )
        )
      )
      (if #qry$$
        (progn
          (CFOutStateLog 1 1 "---標準WTシンク-----------------------------")
          (CFOutStateLog 1 1 #qry$$)
          (CFOutStateLog 1 1 (strcat "間口1     :" &MAG1))
          (CFOutStateLog 1 1 (strcat "WT形状    :" &WT_type))
          (CFOutStateLog 1 1 (strcat "タイプ    :" &Type))
          (CFOutStateLog 1 1 (strcat "素材F     :" #ZaiF))
          (CFOutStateLog 1 1 (strcat "シンク記号:" &SNK))

          (setq #ret$ nil)
          (foreach #qry$ #qry$$
            (CFOutStateLog 1 1 "--------------------------------------------")
            (setq #DimA (nth 7 #qry$)) ; 寸法A
            (setq #DimB (nth 8 #qry$)) ; 寸法B
            (setq #DimC (nth 9 #qry$)) ; 寸法C
            (setq #ret$ (append #ret$ (list (list #DimA #DimB #DimC))))
            (CFOutStateLog 1 1 (strcat "寸法A     :" (rtos #DimA)))
            (CFOutStateLog 1 1 (strcat "寸法B     :" (rtos #DimB)))
            (CFOutStateLog 1 1 (strcat "寸法C     :" (rtos #DimC)))
          )
          (CFOutStateLog 1 1 "--------------------------------------------")
        )
        (progn
          (setq #Err1 T) ; ﾚｺｰﾄﾞなし
          (CFAlertMsg (strcat #msg "ﾚｺｰﾄﾞがありません。"))
        )
      );_if
    )
    (progn
      (setq #Err1 T) ; 引数nil
      (CFAlertMsg (strcat #msg  "検索ｷｰがありません。"))
    )
  );_if

  (if #Err1
    nil
    #ret$
  );_if
);KP_GetStdDimS&S

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; 以下未使用 WT加工ｺﾏﾝﾄﾞ 01/07/25 YM
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;01/07/25YM@;;; <HOM>***********************************************************************************
;;;01/07/25YM@;;; <関数名>    : KPRendDig
;;;01/07/25YM@;;; <処理概要>  : Ｒエンド加工情報ダイアログ
;;;01/07/25YM@;;; <戻り値>    : (加工側,R[径]) 加工側="1"左上,"2"右上,"3"右下,"4"左下
;;;01/07/25YM@;;; <作成>      : 00/07/25 YM
;;;01/07/25YM@;;; <備考>      : 未使用
;;;01/07/25YM@;;; ***********************************************************************************>MOH<
;;;01/07/25YM@(defun KPRendDig (
;;;01/07/25YM@  &sX ; Rｴﾝﾄﾞ可能側 "Right","Left","LeftRight"
;;;01/07/25YM@  &CutType ; "00","30"など 0:ｶｯﾄなし,1:Jｶｯﾄ,2:Yｶｯﾄ,3:45度ｶｯﾄ,4:段差接続(形状)
;;;01/07/25YM@  &rDid$   ; Rｴﾝﾄﾞ可否判定寸法ﾘｽﾄ(WT奥行き,WT下辺長さ)
;;;01/07/25YM@  /
;;;01/07/25YM@  #DCL_ID #FX #FY #RET$
;;;01/07/25YM@  )
;;;01/07/25YM@  (CFOutStateLog 1 1 " ")
;;;01/07/25YM@  (CFOutStateLog 1 1 "//// KPRendDig ////")
;;;01/07/25YM@  (CFOutStateLog 1 1 " ")
;;;01/07/25YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/07/25YM@          (defun ##GetDlgItem (
;;;01/07/25YM@            /
;;;01/07/25YM@
;;;01/07/25YM@            )
;;;01/07/25YM@            ; Rｴﾝﾄﾞ加工
;;;01/07/25YM@            (setq #tgl_LU (get_tile "tgl_LU"))
;;;01/07/25YM@            (setq #tgl_RU (get_tile "tgl_RU"))
;;;01/07/25YM@            (setq #tgl_LD (get_tile "tgl_LD"))
;;;01/07/25YM@            (setq #tgl_RD (get_tile "tgl_RD"))
;;;01/07/25YM@            ; ﾊﾞｯｸｶﾞｰﾄﾞ
;;;01/07/25YM@            (setq #tgl_BG_U  (get_tile "tgl_BG_U"))
;;;01/07/25YM@            (setq #tgl_BG_L  (get_tile "tgl_BG_L"))
;;;01/07/25YM@            (setq #tgl_BG_R  (get_tile "tgl_BG_R"))
;;;01/07/25YM@            ; 前垂れ
;;;01/07/25YM@            (setq #tgl_FG_L  (get_tile "tgl_FG_L"))
;;;01/07/25YM@            (setq #tgl_FG_U  (get_tile "tgl_FG_U"))
;;;01/07/25YM@            (setq #tgl_FG_D  (get_tile "tgl_FG_D"))
;;;01/07/25YM@            (setq #tgl_FG_R  (get_tile "tgl_FG_R"))
;;;01/07/25YM@            ; R(径)
;;;01/07/25YM@            (setq #r-kei (get_tile "r-kei"))
;;;01/07/25YM@
;;;01/07/25YM@            (list #tgl_LU #tgl_RU #tgl_LD #tgl_RD #tgl_U #tgl_L #tgl_R)
;;;01/07/25YM@          )
;;;01/07/25YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/07/25YM@          ; Rｴﾝﾄﾞ加工の有無によりFG取付け可否を変更
;;;01/07/25YM@          (defun ##Check_BGtgl ( / )
;;;01/07/25YM@            ; R(径)
;;;01/07/25YM@            (if (or (= "1" (get_tile "tgl_LU"))(= "1" (get_tile "tgl_LD"))
;;;01/07/25YM@                    (= "1" (get_tile "tgl_RU"))(= "1" (get_tile "tgl_RD")))
;;;01/07/25YM@              (mode_tile "r-kei" 0) ; Rｴﾝﾄﾞどれかにﾁｪｯｸが入った==>使用可能
;;;01/07/25YM@              (progn
;;;01/07/25YM@                (set_tile "r-kei" "")
;;;01/07/25YM@                (mode_tile "r-kei" 1) ; 使用禁止
;;;01/07/25YM@              )
;;;01/07/25YM@            );_if
;;;01/07/25YM@
;;;01/07/25YM@            ; 左上or下,右上or下Rｴﾝﾄﾞ加工あり==>右 or 左前垂れ強制的につける
;;;01/07/25YM@            (if (or (= "1" (get_tile "tgl_LU"))(= "1" (get_tile "tgl_LD")))
;;;01/07/25YM@              (progn ; ﾁｪｯｸが入った
;;;01/07/25YM@                (set_tile  "tgl_FG_L" "1") ; ﾁｪｯｸ
;;;01/07/25YM@                (mode_tile "tgl_FG_L" 1)   ; 使用禁止
;;;01/07/25YM@              )
;;;01/07/25YM@              (progn
;;;01/07/25YM@                (set_tile  "tgl_FG_L" "0") ; ﾁｪｯｸなし
;;;01/07/25YM@                (if (= #cutR "0") ; ｶｯﾄなし
;;;01/07/25YM@                  (mode_tile "tgl_FG_R" 0) ; 使用可能
;;;01/07/25YM@                  (mode_tile "tgl_FG_R" 1) ; 使用禁止
;;;01/07/25YM@                );_if
;;;01/07/25YM@              )
;;;01/07/25YM@            );_if
;;;01/07/25YM@            (if (or (= "1" (get_tile "tgl_RU"))(= "1" (get_tile "tgl_RD")))
;;;01/07/25YM@              (progn ; ﾁｪｯｸが入った
;;;01/07/25YM@                (set_tile  "tgl_FG_R" "1") ; ﾁｪｯｸ
;;;01/07/25YM@                (mode_tile "tgl_FG_R" 1)   ; 使用禁止
;;;01/07/25YM@              )
;;;01/07/25YM@              (progn
;;;01/07/25YM@                (set_tile  "tgl_FG_R" "0") ; ﾁｪｯｸなし
;;;01/07/25YM@                ; 左右FGはｶｯﾄなしのときのみ使用可能
;;;01/07/25YM@                (if (= #cutL "0") ; ｶｯﾄなし
;;;01/07/25YM@                  (mode_tile "tgl_FG_L" 0) ; 使用可能
;;;01/07/25YM@                  (mode_tile "tgl_FG_L" 1) ; 使用禁止
;;;01/07/25YM@                );_if
;;;01/07/25YM@              )
;;;01/07/25YM@            );_if
;;;01/07/25YM@
;;;01/07/25YM@            (princ)
;;;01/07/25YM@          );##Check_BGtgl
;;;01/07/25YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/07/25YM@          ; 初期ﾀﾞｲｱﾛｸﾞ設定(最後まで変わらない)項目のｸﾞﾚｲｱｳﾄを行う
;;;01/07/25YM@          (defun ##firstSET ( / )
;;;01/07/25YM@            ; 左右BGは Jｶｯﾄのときのみ使用可能
;;;01/07/25YM@            (if (= #cutL "1") ; Jｶｯﾄ
;;;01/07/25YM@              (mode_tile "tgl_BG_L" 0) ; 使用可能
;;;01/07/25YM@              (mode_tile "tgl_BG_L" 1) ; 使用禁止
;;;01/07/25YM@            );_if
;;;01/07/25YM@            ; 右側BG Jｶｯﾄのときのみ使用可能
;;;01/07/25YM@            (if (= #cutR "1") ; Jｶｯﾄ
;;;01/07/25YM@              (mode_tile "tgl_BG_R" 0) ; 使用可能
;;;01/07/25YM@              (mode_tile "tgl_BG_R" 1) ; 使用禁止
;;;01/07/25YM@            );_if
;;;01/07/25YM@
;;;01/07/25YM@            ; 左右FGはｶｯﾄなしのときのみ使用可能
;;;01/07/25YM@            (if (= #cutL "0") ; ｶｯﾄなし
;;;01/07/25YM@              (mode_tile "tgl_FG_L" 0) ; 使用可能
;;;01/07/25YM@              (mode_tile "tgl_FG_L" 1) ; 使用禁止
;;;01/07/25YM@            );_if
;;;01/07/25YM@            (if (= #cutR "0") ; ｶｯﾄなし
;;;01/07/25YM@              (mode_tile "tgl_FG_R" 0) ; 使用可能
;;;01/07/25YM@              (mode_tile "tgl_FG_R" 1) ; 使用禁止
;;;01/07/25YM@            );_if
;;;01/07/25YM@
;;;01/07/25YM@            ; 右側のみRｴﾝﾄﾞ可能==>左側不可 右側BG不可
;;;01/07/25YM@            ; 左側のみRｴﾝﾄﾞ可能==>右側不可 左側BG不可
;;;01/07/25YM@            (cond
;;;01/07/25YM@              ((= &sX "Right")
;;;01/07/25YM@                (set_tile "tgl_LU" "0")
;;;01/07/25YM@                (set_tile "tgl_LD" "0")
;;;01/07/25YM@                (mode_tile "tgl_LU" 1)
;;;01/07/25YM@                (mode_tile "tgl_LD" 1)
;;;01/07/25YM@              )
;;;01/07/25YM@              ((= &sX "Left")
;;;01/07/25YM@                (set_tile "tgl_RU" "0")
;;;01/07/25YM@                (set_tile "tgl_RD" "0")
;;;01/07/25YM@                (mode_tile "tgl_RU" 1) ; 使用禁止
;;;01/07/25YM@                (mode_tile "tgl_RD" 1) ; 使用禁止
;;;01/07/25YM@              )
;;;01/07/25YM@              (T
;;;01/07/25YM@                nil
;;;01/07/25YM@              )
;;;01/07/25YM@            );_cond
;;;01/07/25YM@
;;;01/07/25YM@            ; R(径)ｴﾃﾞｨｯﾄﾎﾞｯｸｽ
;;;01/07/25YM@            (mode_tile "r-kei" 1) ; 使用禁止
;;;01/07/25YM@            (princ)
;;;01/07/25YM@          );##Check_BGtgl
;;;01/07/25YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/07/25YM@
;;;01/07/25YM@  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
;;;01/07/25YM@  (if (not (new_dialog "RendDlg" #dcl_id)) (exit))
;;;01/07/25YM@
;;;01/07/25YM@;;; 初期ﾀｲﾙ設定
;;;01/07/25YM@  (setq #cutL (substr &CutType 1 1))
;;;01/07/25YM@  (setq #cutR (substr &CutType 2 1))
;;;01/07/25YM@  (##firstSET)
;;;01/07/25YM@
;;;01/07/25YM@  ; ﾀｲﾙのﾘｱｸｼｮﾝ設定
;;;01/07/25YM@  (action_tile "tgl_LU" "(##Check_BGtgl)") ; 左上R加工
;;;01/07/25YM@  (action_tile "tgl_LD" "(##Check_BGtgl)") ; 左下R加工
;;;01/07/25YM@  (action_tile "tgl_RU" "(##Check_BGtgl)") ; 右上R加工
;;;01/07/25YM@  (action_tile "tgl_RD" "(##Check_BGtgl)") ; 右下R加工
;;;01/07/25YM@
;;;01/07/25YM@  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
;;;01/07/25YM@  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
;;;01/07/25YM@
;;;01/07/25YM@  (setq #fX (dimx_tile "image"))
;;;01/07/25YM@  (setq #fY (dimy_tile "image"))
;;;01/07/25YM@  (start_image "image")
;;;01/07/25YM@  (fill_image  0 0 #fX #fY -0)
;;;01/07/25YM@
;;;01/07/25YM@  ;ｽﾗｲﾄﾞﾌｧｲﾙ
;;;01/07/25YM@  (setq #sSLIDE (strcat CG_SYSPATH  "WT" &CutType ".sld"))
;;;01/07/25YM@  (cond
;;;01/07/25YM@    ((findfile #sSLIDE)
;;;01/07/25YM@      (slide_image 0 0 #fX (- #fY 10) #sSLIDE)
;;;01/07/25YM@    )
;;;01/07/25YM@    (t
;;;01/07/25YM@      (slide_image 0 0 #fX (- #fY 10) (strcat CG_SYSPATH "notfile.sld"))
;;;01/07/25YM@    )
;;;01/07/25YM@  );_cond
;;;01/07/25YM@  (end_image)
;;;01/07/25YM@
;;;01/07/25YM@  (start_dialog)
;;;01/07/25YM@  (unload_dialog #dcl_id)
;;;01/07/25YM@
;;;01/07/25YM@  #ret$ ; 戻り値 (加工側,R[径]) 加工側="1"左上,"2"右上,"3"右下,"4"左下
;;;01/07/25YM@);KPRendDig
;;;01/07/25YM@
;;;01/07/25YM@;<HOM>*************************************************************************
;;;01/07/25YM@; <関数名>    : C:RendWT_test
;;;01/07/25YM@; <処理概要>  : ワークトップの端をＲｴﾝﾄﾞにする(ﾃｽﾄ用)
;;;01/07/25YM@; <戻り値>    : なし
;;;01/07/25YM@; <作成>      : 01/07/25 YM
;;;01/07/25YM@; <備考>      :
;;;01/07/25YM@;*************************************************************************>MOH<
;;;01/07/25YM@(defun C:RendWT_test (
;;;01/07/25YM@  /
;;;01/07/25YM@  #ARC1 #ARC2 #BASEPT #BG_H #BG_SOLID #BG_T #CL #CR #CUTTYPE #DELOBJ
;;;01/07/25YM@  #FG_H #FG_S #FG_T #GRIDMODE #KAIJO #LAST #LINE$ #LOOP #ORTHOMODE #OSMODE
;;;01/07/25YM@  #P1 #P2 #P3 #PD #RR #SNAPMODE #SS #SS_DUM #WTEN #WTL #WTR #WT_H #WT_PT$
;;;01/07/25YM@  #WT_REGION #WT_SOLID #WT_T #WT_TEI #sX #XD$ #XDL$ #XDR$ #XD_NEW$ #YESNOMSG
;;;01/07/25YM@  #BG #BG0 #BG_REGION #DUM1 #DUM2 #BG_TEI1 #BG_TEI2 #FG_TEI1 #FG_TEI2
;;;01/07/25YM@  #dist1 #dist2 #DEP #FG0 #FG_REGION #FG_SOLID #P4 #P5
;;;01/07/25YM@  )
;;;01/07/25YM@  (CFOutStateLog 1 1 " ")
;;;01/07/25YM@  (CFOutStateLog 1 1 "//// C:RendWT ////")
;;;01/07/25YM@  (CFOutStateLog 1 1 " ")
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    ;&ss("LINE"選択ｾｯﾄ)のうち始点or終点が&ptと一致する図形ﾘｽﾄを返す
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    (defun ##GETLINE (
;;;01/07/25YM@      &ss
;;;01/07/25YM@      &pt
;;;01/07/25YM@      /
;;;01/07/25YM@      #EN #I #LIST$
;;;01/07/25YM@      )
;;;01/07/25YM@      (setq #list$ nil)
;;;01/07/25YM@      (if (and &ss (< 0 (sslength &ss)))
;;;01/07/25YM@        (progn
;;;01/07/25YM@          (setq #i 0)
;;;01/07/25YM@          (repeat (sslength &ss)
;;;01/07/25YM@            (setq #en (ssname &ss #i))
;;;01/07/25YM@            (if (or (< (distance (cdr (assoc 10 (entget #en))) &pt) 0.1)
;;;01/07/25YM@                    (< (distance (cdr (assoc 11 (entget #en))) &pt) 0.1))
;;;01/07/25YM@              (setq #list$ (append #list$ (list #en)))
;;;01/07/25YM@            );_if
;;;01/07/25YM@            (setq #i (1+ #i))
;;;01/07/25YM@          )
;;;01/07/25YM@        )
;;;01/07/25YM@      );_if
;;;01/07/25YM@      #list$
;;;01/07/25YM@    )
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    ;&en("LINE"図形)-->始点,終点の中点を返す
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    (defun ##CENTER_PT ( &en / #DUM)
;;;01/07/25YM@      (setq #dum (mapcar '+ (cdr (assoc 10 (entget &en)))
;;;01/07/25YM@                            (cdr (assoc 11 (entget &en)))))
;;;01/07/25YM@      (setq #dum (mapcar '* #dum '(0.5 0.5 0.5)))
;;;01/07/25YM@    )
;;;01/07/25YM@
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    ;引数:&en(既存底面図形 or "")を削除する
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    (defun ##ENTDEL ( &en / )
;;;01/07/25YM@      (if (and &en (/= &en "")(entget &en))
;;;01/07/25YM@        (entdel &en)
;;;01/07/25YM@      );_if
;;;01/07/25YM@      (princ)
;;;01/07/25YM@    )
;;;01/07/25YM@
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    ;fillet処理
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    (defun ##FILLET ( &line$ / #ARC #EN1 #EN2 #SP1 #SP2)
;;;01/07/25YM@      (if &line$
;;;01/07/25YM@        (progn
;;;01/07/25YM@          (setq #en1 (car  &line$))
;;;01/07/25YM@          (setq #en2 (cadr &line$))
;;;01/07/25YM@          (setq #sp1 (##CENTER_PT #en1))
;;;01/07/25YM@          (setq #sp2 (##CENTER_PT #en2))
;;;01/07/25YM@          (command "_fillet" (list #en1 #sp1)(list #en2 #sp2))
;;;01/07/25YM@          (setq #arc (entlast))
;;;01/07/25YM@        )
;;;01/07/25YM@        (progn
;;;01/07/25YM@          (CFAlertMsg "フィレット処理ができませんでした。")(quit)
;;;01/07/25YM@        )
;;;01/07/25YM@      );_if
;;;01/07/25YM@      #arc
;;;01/07/25YM@    )
;;;01/07/25YM@
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////
;;;01/07/25YM@
;;;01/07/25YM@  (setq #KAIJO nil)  ; 品番確定解除ﾌﾗｸﾞ
;;;01/07/25YM@  ;// コマンドの初期化
;;;01/07/25YM@  (StartUndoErr)
;;;01/07/25YM@; 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 SK以外実行不可
;;;01/07/25YM@(if (not (equal (KPGetSinaType) -1 0.1))
;;;01/07/25YM@  (progn
;;;01/07/25YM@    nil ; ｼﾘｰｽﾞによる制限をなくす 01/07/25 YM MOD
;;;01/07/25YM@;;;01/07/25@    (CFAlertMsg msg8)
;;;01/07/25YM@;;;01/07/25@    (quit)
;;;01/07/25YM@  )
;;;01/07/25YM@  (progn
;;;01/07/25YM@    (setq #SNAPMODE  (getvar "SNAPMODE"))
;;;01/07/25YM@    (setq #GRIDMODE  (getvar "GRIDMODE"))
;;;01/07/25YM@    (setq #ORTHOMODE (getvar "ORTHOMODE"))
;;;01/07/25YM@    (setq #OSMODE    (getvar "OSMODE"))
;;;01/07/25YM@    (setvar "SNAPMODE"  0)
;;;01/07/25YM@    (setvar "GRIDMODE"  0)
;;;01/07/25YM@    (setvar "ORTHOMODE" 0)
;;;01/07/25YM@    (setvar "OSMODE"    0)
;;;01/07/25YM@    (setq #PD (getvar "pdmode")) ; 06/12 YM
;;;01/07/25YM@    (setvar "pdmode" 34)         ; 06/12 YM
;;;01/07/25YM@    ;// ワークトップの指示
;;;01/07/25YM@    (initget 0)
;;;01/07/25YM@    (setq #loop T)
;;;01/07/25YM@    (while #loop
;;;01/07/25YM@      (setq #wtEn (car (entsel "\nワークトップを選択: ")))
;;;01/07/25YM@      (if #wtEn
;;;01/07/25YM@        (setq #xd$ (CFGetXData #wten "G_WRKT"))
;;;01/07/25YM@        (setq #xd$ nil)
;;;01/07/25YM@      );_if
;;;01/07/25YM@      (if (= #xd$ nil)
;;;01/07/25YM@        (CFAlertMsg "ワークトップではありません。")
;;;01/07/25YM@      ;else
;;;01/07/25YM@        (cond
;;;01/07/25YM@          ((CFGetXData #wtEn "G_WTSET")
;;;01/07/25YM@            (setq #YesNoMsg "ワークトップは品番確定されています。\n処理を続けますか？")
;;;01/07/25YM@            (if (CFYesNoDialog #YesNoMsg)
;;;01/07/25YM@              (progn
;;;01/07/25YM@                (setq #loop nil) ; YES なら継続
;;;01/07/25YM@                (setq #KAIJO T)  ; 品番確定解除ﾌﾗｸﾞ
;;;01/07/25YM@              )
;;;01/07/25YM@              (*error*)        ; NO  ならSTOP
;;;01/07/25YM@            );_if
;;;01/07/25YM@          )
;;;01/07/25YM@          (T
;;;01/07/25YM@            (setq #loop nil)
;;;01/07/25YM@          )
;;;01/07/25YM@        );_cond
;;;01/07/25YM@      );_if
;;;01/07/25YM@
;;;01/07/25YM@    );while
;;;01/07/25YM@
;;;01/07/25YM@    ; 条件判定 人大JｶｯﾄならRｴﾝﾄﾞ可能
;;;01/07/25YM@    (setq #CutType (nth 7 #xd$)) ; ｶｯﾄﾀｲﾌﾟ
;;;01/07/25YM@    ; ｶｯﾄ記号
;;;01/07/25YM@    (setq #CL (substr #CutType 1 1))
;;;01/07/25YM@    (setq #CR (substr #CutType 2 1))
;;;01/07/25YM@
;;;01/07/25YM@    (cond
;;;01/07/25YM@      ((and (/= #CL "0") (= #CR "0"))
;;;01/07/25YM@        (setq #sX "Right") ; Rｴﾝﾄﾞ側=右
;;;01/07/25YM@      )
;;;01/07/25YM@      ((and (= #CL "0") (/= #CR "0"))
;;;01/07/25YM@        (setq #sX "Left") ; Rｴﾝﾄﾞ側=左
;;;01/07/25YM@      )
;;;01/07/25YM@      ((and (= #CL "0") (= #CR "0"))
;;;01/07/25YM@        (setq #sX "LeftRight") ; Rｴﾝﾄﾞ側=どちらも可能
;;;01/07/25YM@      )
;;;01/07/25YM@      (T
;;;01/07/25YM@        (CFAlertMsg "このワークトップはＲエンド加工できません。")(quit)
;;;01/07/25YM@      )
;;;01/07/25YM@    );_cond
;;;01/07/25YM@
;;;01/07/25YM@;;;01/07/25YM@    (cond
;;;01/07/25YM@;;;01/07/25YM@      ((and (= #CL "1") (= #CR "0"))
;;;01/07/25YM@;;;01/07/25YM@        (setq #sX "Right") ; Rｴﾝﾄﾞ側=右
;;;01/07/25YM@;;;01/07/25YM@      )
;;;01/07/25YM@;;;01/07/25YM@      ((and (= #CL "0") (= #CR "1"))
;;;01/07/25YM@;;;01/07/25YM@        (setq #sX "Left") ; Rｴﾝﾄﾞ側=左
;;;01/07/25YM@;;;01/07/25YM@      )
;;;01/07/25YM@;;;01/07/25YM@      (T
;;;01/07/25YM@;;;01/07/25YM@        (CFAlertMsg "このワークトップはＲエンド加工できません。")(quit)
;;;01/07/25YM@;;;01/07/25YM@      )
;;;01/07/25YM@;;;01/07/25YM@    );_cond
;;;01/07/25YM@
;;;01/07/25YM@    (PCW_ChColWT #wtEn "MAGENTA" nil) ; 色を変える
;;;01/07/25YM@
;;;01/07/25YM@    ; WT情報取得
;;;01/07/25YM@    (setq #WT_H (nth  8 #xd$))  ; WT高さ
;;;01/07/25YM@    (setq #WT_T (nth 10 #xd$))  ; WT厚み
;;;01/07/25YM@    (setq #BG_H (nth 12 #xd$))  ; BG高さ
;;;01/07/25YM@    (setq #BG_T (nth 13 #xd$))  ; BG厚み
;;;01/07/25YM@    (setq #FG_H (nth 15 #xd$))  ; FG高さ
;;;01/07/25YM@    (setq #FG_T (nth 16 #xd$))  ; FG厚み
;;;01/07/25YM@    (setq #FG_S (nth 17 #xd$))  ; FGｼﾌﾄ量
;;;01/07/25YM@
;;;01/07/25YM@    ; 各底面取得
;;;01/07/25YM@    (setq #WT_tei (nth 38 #xd$))   ; WT底面図形ﾊﾝﾄﾞﾙ
;;;01/07/25YM@    (setq #BASEPT (nth 32 #xd$))   ; WT左上点
;;;01/07/25YM@    (setq #BG_tei1 (nth 49 #xd$))  ; BG SOLID1 or 底面1
;;;01/07/25YM@    (setq #BG_tei2 (nth 50 #xd$))  ; BG SOLID2 or 底面2 もしあればそのまま
;;;01/07/25YM@    (setq #FG_tei1 (nth 51 #xd$))  ; FG1底面 *
;;;01/07/25YM@    (setq #FG_tei2 (nth 52 #xd$))  ; F2G底面 *
;;;01/07/25YM@    (setq #dep (car (nth 57 #xd$))); WT奥行き
;;;01/07/25YM@
;;;01/07/25YM@    ; WT底面点列取得
;;;01/07/25YM@    (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))     ; WT外形点列
;;;01/07/25YM@    (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT 左上点から時計周りに並び替える
;;;01/07/25YM@    (setq #p1 (nth 0 #WT_pt$)) ; WT左上点
;;;01/07/25YM@    (setq #p2 (nth 1 #WT_pt$)) ; WT右上点
;;;01/07/25YM@    (setq #p3 (nth 2 #WT_pt$))
;;;01/07/25YM@    (setq #p4 (nth 3 #WT_pt$))
;;;01/07/25YM@    (setq #p5 (nth 4 #WT_pt$))
;;;01/07/25YM@    (setq #p6 (nth 5 #WT_pt$))
;;;01/07/25YM@
;;;01/07/25YM@    ; #rDist1=奥行き #rDist2=WT外形の下辺
;;;01/07/25YM@    (setq #rDid$ (KPGetRendDist #WT_pt$ #CutType))
;;;01/07/25YM@    ; Rｴﾝﾄﾞﾀﾞｲｱﾛｸﾞを表示
;;;01/07/25YM@    (setq #ret$ (KPRendDig #sX #CutType #rDid$))
;;;01/07/25YM@
;;;01/07/25YM@    ; filletの可否を判定するため距離を求める 01/07/18 YM ADD
;;;01/07/25YM@
;;;01/07/25YM@    (cond
;;;01/07/25YM@      ((= #sX "Right")
;;;01/07/25YM@        (setq #dist1 (* 0.5 (distance #p2 #p3)))
;;;01/07/25YM@        (setq #dist2 (distance #p3 #p4))
;;;01/07/25YM@      )
;;;01/07/25YM@      ((= #sX "Left")
;;;01/07/25YM@        (setq #dist1 (* 0.5 (distance #p1 #last)))
;;;01/07/25YM@        (setq #dist2 (distance #p5 #last))
;;;01/07/25YM@      )
;;;01/07/25YM@    );_cond
;;;01/07/25YM@
;;;01/07/25YM@    ; R(径)を入力
;;;01/07/25YM@    (setq #loop T)
;;;01/07/25YM@    (while #loop
;;;01/07/25YM@      (setq #rr (getreal (strcat "\nＲを入力<" CG_R ">: ")))
;;;01/07/25YM@      (if (= #rr nil)
;;;01/07/25YM@        (progn
;;;01/07/25YM@          (setq #rr CG_R)
;;;01/07/25YM@          (setq #loop nil)
;;;01/07/25YM@        )
;;;01/07/25YM@        (progn
;;;01/07/25YM@          (if (or (<= #dist1 #rr)(<= #dist2 #rr)) ; 奥行きの半分を超えてはいけない
;;;01/07/25YM@            (progn
;;;01/07/25YM@              (setq #loop T)
;;;01/07/25YM@              (princ "\n値が大きすぎてフィレットできません。")
;;;01/07/25YM@            )
;;;01/07/25YM@            (progn
;;;01/07/25YM@              (setq #rr (rtos #rr)) ; string
;;;01/07/25YM@              (setq #loop nil)
;;;01/07/25YM@            )
;;;01/07/25YM@          );_if
;;;01/07/25YM@        )
;;;01/07/25YM@      ); if
;;;01/07/25YM@    )
;;;01/07/25YM@
;;;01/07/25YM@    (command "_fillet" "R" #rr)
;;;01/07/25YM@
;;;01/07/25YM@    ; 色を戻す
;;;01/07/25YM@    (PCW_ChColWT #wtEn "BYLAYER" nil)
;;;01/07/25YM@
;;;01/07/25YM@    ;// 既存のワークトップ(前垂れ込み3DSOLID)を削除
;;;01/07/25YM@    (entdel #wtEn)
;;;01/07/25YM@    ; 既存底面削除
;;;01/07/25YM@    (##ENTDEL #BG_tei1)
;;;01/07/25YM@    (##ENTDEL #BG_tei2)
;;;01/07/25YM@    (##ENTDEL #FG_tei1)
;;;01/07/25YM@    (##ENTDEL #FG_tei2)
;;;01/07/25YM@
;;;01/07/25YM@    ; WT底面をｺﾋﾟｰして分解
;;;01/07/25YM@    (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT_tei)) (entget #WT_tei)))
;;;01/07/25YM@    (command "_explode" (entlast))
;;;01/07/25YM@    (setq #ss_dum (ssget "P")) ; LINEの集まり
;;;01/07/25YM@    ; 底面をFillet処理
;;;01/07/25YM@    (cond
;;;01/07/25YM@      ((= #sX "Right")
;;;01/07/25YM@        (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2を端点に持つ"LINE"のﾘｽﾄを取得
;;;01/07/25YM@        (setq #arc1  (##FILLET #line$))       ; Filletして"ARC"を取得
;;;01/07/25YM@        (setq #line$ (##GETLINE #ss_dum #p3))
;;;01/07/25YM@        (setq #arc2  (##FILLET #line$))
;;;01/07/25YM@        ; BG底面作成
;;;01/07/25YM@        (setq #dum1 (polar #p1   (angle #p1 #p2) #BG_T))
;;;01/07/25YM@        (setq #dum2 (polar #last (angle #p1 #p2) #BG_T))
;;;01/07/25YM@        (setq #BG0 (MakeTEIMEN (list #p1 #dum1 #dum2 #last))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面作成
;;;01/07/25YM@        ; FG底面作成 01/07/10 YM ADD
;;;01/07/25YM@        (setq #FG0 (KPMakeFGTeimen #sX #WT_pt$ #arc1 #arc2 #FG_T #rr))
;;;01/07/25YM@      )
;;;01/07/25YM@      ((= #sX "Left")
;;;01/07/25YM@        (setq #line$ (##GETLINE #ss_dum #p1))
;;;01/07/25YM@        (setq #arc1  (##FILLET #line$))
;;;01/07/25YM@        (setq #line$ (##GETLINE #ss_dum #last))
;;;01/07/25YM@        (setq #arc2  (##FILLET #line$))
;;;01/07/25YM@        ; BG底面作成
;;;01/07/25YM@        (setq #dum1 (polar #p2 (angle #p2 #p1) #BG_T))
;;;01/07/25YM@        (setq #dum2 (polar #p3 (angle #p2 #p1) #BG_T))
;;;01/07/25YM@        (setq #BG0 (MakeTEIMEN (list #p2 #p3 #dum2 #dum1))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;;;01/07/25YM@        ; FG底面作成 01/07/10 YM ADD
;;;01/07/25YM@        (setq #FG0 (KPMakeFGTeimen #sX #WT_pt$ #arc1 #arc2 #FG_T #rr))
;;;01/07/25YM@      )
;;;01/07/25YM@    );_cond
;;;01/07/25YM@    ; Filletによって作成された"ARC"を追加する-->pedit
;;;01/07/25YM@    (ssadd #arc1 #ss_dum)
;;;01/07/25YM@    (ssadd #arc2 #ss_dum)
;;;01/07/25YM@
;;;01/07/25YM@    ; Pedit ﾎﾟﾘﾗｲﾝ化 WT 再作成
;;;01/07/25YM@    (command "_pedit" #arc1 "Y" "J" #ss_dum "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
;;;01/07/25YM@
;;;01/07/25YM@    (setq #delobj (getvar "delobj")) ; extrude後の底面を保持する  "delobj"=0
;;;01/07/25YM@    (setvar "delobj" 1)              ; extrude後の底面を保持しない"delobj"=1
;;;01/07/25YM@
;;;01/07/25YM@    (setq #WT_region (Make_Region2 (entlast)))
;;;01/07/25YM@    (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
;;;01/07/25YM@
;;;01/07/25YM@  ;;; BG_SOLID再作成
;;;01/07/25YM@    (if #BG0
;;;01/07/25YM@      (progn
;;;01/07/25YM@        (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG0)) (entget #BG0))) ; 底面ﾎﾟﾘﾗｲﾝ(画層を変えて残す)
;;;01/07/25YM@        (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG0)) (entget #BG0))) ; SOLID画層にする-->押し出し用
;;;01/07/25YM@        (setq #BG (entlast)) ; extrude用
;;;01/07/25YM@        (setq #BG_region (Make_Region2 #BG))
;;;01/07/25YM@        (setq #BG_SOLID  (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
;;;01/07/25YM@      )
;;;01/07/25YM@    );_if
;;;01/07/25YM@
;;;01/07/25YM@    ; FG_SOLID再作成
;;;01/07/25YM@    (if #FG0
;;;01/07/25YM@      (progn
;;;01/07/25YM@  ;;;     (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG0)) (entget #FG0))) ; 底面ﾎﾟﾘﾗｲﾝ(残す)
;;;01/07/25YM@  ;;;     (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG0)) (entget #FG0)))
;;;01/07/25YM@  ;;;     (setq #FG (entlast)) ; extrude用
;;;01/07/25YM@  ;;;     (setq #FG_region (Make_Region2 #FG))
;;;01/07/25YM@        (setq #FG_region (Make_Region2 #FG0))
;;;01/07/25YM@        (setq #FG_SOLID  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
;;;01/07/25YM@      )
;;;01/07/25YM@    );_if
;;;01/07/25YM@
;;;01/07/25YM@    (setvar "delobj" #delobj) ; システム変数を戻す
;;;01/07/25YM@
;;;01/07/25YM@    (setq #ss (ssadd))
;;;01/07/25YM@    (ssadd #WT_SOLID #ss)
;;;01/07/25YM@    (if #BG_SOLID (ssadd #BG_SOLID #ss)) ; BG_SOLIDを追加
;;;01/07/25YM@    (if #FG_SOLID (ssadd #FG_SOLID #ss)) ; FG_SOLIDを追加
;;;01/07/25YM@
;;;01/07/25YM@    ;BG,WTの和をとる
;;;01/07/25YM@    (command "_union" #ss "") ; 交わらない領域でもＯＫ！
;;;01/07/25YM@
;;;01/07/25YM@    ;// 拡張データの再設定
;;;01/07/25YM@    (setq #xd_new$
;;;01/07/25YM@    (list
;;;01/07/25YM@      (list 49 #BG0);[50]:BG SOLID底面図形ﾊﾝﾄﾞﾙ1
;;;01/07/25YM@      (list 50   "");[51]:BG SOLID底面図形ﾊﾝﾄﾞﾙ2
;;;01/07/25YM@      (list 51   "");[52]:FG 底面図形ﾊﾝﾄﾞﾙ1
;;;01/07/25YM@      (list 51   "");[52]:FG 底面図形ﾊﾝﾄﾞﾙ1
;;;01/07/25YM@      (list 52   "");[53]:FG 底面図形ﾊﾝﾄﾞﾙ2
;;;01/07/25YM@    ))
;;;01/07/25YM@    (CFSetXData #WT_SOLID "G_WRKT"
;;;01/07/25YM@      (CFModList #xd$ #xd_new$)
;;;01/07/25YM@    )
;;;01/07/25YM@
;;;01/07/25YM@    (setq #WTL (nth 47 #xd$)) ; ｶｯﾄ相手WT左
;;;01/07/25YM@    (setq #WTR (nth 48 #xd$)) ; ｶｯﾄ相手WT右
;;;01/07/25YM@
;;;01/07/25YM@    ;左側WTの拡張データも更新する
;;;01/07/25YM@    (if (and (/= #WTL "") (/= #WTL nil))
;;;01/07/25YM@      (progn
;;;01/07/25YM@        (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; 左側
;;;01/07/25YM@        (CFSetXData #WTL "G_WRKT"
;;;01/07/25YM@          (CFModList #xdL$
;;;01/07/25YM@            (list
;;;01/07/25YM@              (list 48 #WT_SOLID)     ;[49]カット相手WTﾊﾝﾄﾞﾙ右 U型は左右にある
;;;01/07/25YM@            )
;;;01/07/25YM@          )
;;;01/07/25YM@        )
;;;01/07/25YM@      )
;;;01/07/25YM@    );_if
;;;01/07/25YM@
;;;01/07/25YM@    ;右側WTの拡張データも更新する
;;;01/07/25YM@    (if (and (/= #WTR "") (/= #WTR nil))
;;;01/07/25YM@      (progn
;;;01/07/25YM@        (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; 右側
;;;01/07/25YM@        (CFSetXData #WTR "G_WRKT"
;;;01/07/25YM@          (CFModList
;;;01/07/25YM@            #xdR$
;;;01/07/25YM@            (list
;;;01/07/25YM@              (list 47 #WT_SOLID)     ;[48]カット相手WTﾊﾝﾄﾞﾙ左 U型は左右にある
;;;01/07/25YM@            )
;;;01/07/25YM@          )
;;;01/07/25YM@        )
;;;01/07/25YM@      )
;;;01/07/25YM@    );_if
;;;01/07/25YM@
;;;01/07/25YM@    (setvar "SNAPMODE"  #SNAPMODE)
;;;01/07/25YM@    (setvar "GRIDMODE"  #GRIDMODE)
;;;01/07/25YM@    (setvar "ORTHOMODE" #ORTHOMODE)
;;;01/07/25YM@    (setvar "OSMODE"    #OSMODE)
;;;01/07/25YM@    (setvar "pdmode" #PD) ; 06/12 YM
;;;01/07/25YM@    (if #KAIJO
;;;01/07/25YM@      (princ "\n品番確定が解除されました。")
;;;01/07/25YM@    );_if
;;;01/07/25YM@
;;;01/07/25YM@  ); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
;;;01/07/25YM@);_if
;;;01/07/25YM@
;;;01/07/25YM@  (setq *error* nil)
;;;01/07/25YM@  (princ)
;;;01/07/25YM@
;;;01/07/25YM@);C:RendWT_test

;-- 2011/12/17 A.Satoh Mod - S
;;;;;;;;<HOM>*************************************************************************
;;;;;;;; <関数名>    : KPGetRendDist
;;;;;;;; <処理概要>  : Rｴﾝﾄﾞ可否判定のための寸法を取得
;;;;;;;; <戻り値>    : (距離1,距離2)=(WT奥行き,WT外形の下辺長さ)
;;;;;;;; <作成>      : 01/07/25 YM
;;;;;;;; <備考>      : <未使用>
;;;;;;;;*************************************************************************>MOH<
;;;;;(defun KPGetRendDist (
;;;;;  &WT_pt$  ; WT外形点列
;;;;;  &CutType ; WTｶｯﾄﾀｲﾌﾟ"00","20"など"左右" 0:ｶｯﾄなし,1:Jｶｯﾄ,2:Yｶｯﾄ,3:45度ｶｯﾄ,4:段差接続
;;;;;  /
;;;;;  #P1 #P2 #P3 #P4 #P5 #P6 #RDIS1 #RDIS2
;;;;;  )
;;;;;  ; filletの可否を判定するため距離を求める
;;;;;  ; p1                p2
;;;;;  ; +-----------------+
;;;;;  ; |                 |
;;;;;  ; |    p5           |"Right"ﾀｲﾌﾟ
;;;;;  ; +----+            |
;;;;;  ;p6      +----------+
;;;;;  ;       p4          p3
;;;;;
;;;;;  ; p1                p2
;;;;;  ; +-----------------+
;;;;;  ; |                 |
;;;;;  ; |            p4   |"Left"ﾀｲﾌﾟ
;;;;;  ; |            +----+
;;;;;  ; +----------+      p3
;;;;;  ; p6         p5
;;;;;
;;;;;  (setq #p1 (nth 0 &WT_pt$)) ; WT左上点
;;;;;  (setq #p2 (nth 1 &WT_pt$)) ; WT右上点
;;;;;  (setq #p3 (nth 2 &WT_pt$))
;;;;;  (setq #p4 (nth 3 &WT_pt$))
;;;;;  (setq #p5 (nth 4 &WT_pt$))
;;;;;  (setq #p6 (nth 5 &WT_pt$))
;;;;;
;;;;;  (cond
;;;;;    ((or (= &CutType "00")(= &CutType "10")(= &CutType "20")(= &CutType "30")(= &CutType "00"))
;;;;;      (setq #rDis1 (distance #p2 #p3)) ; 奥行き
;;;;;      (setq #rDis2 (distance #p3 #p4)) ; WT下辺
;;;;;    )
;;;;;    ((= &CutType "01")
;;;;;      (setq #rDis1 (distance #p1 #p6)) ; 奥行き
;;;;;      (setq #rDis2 (distance #p5 #p6)) ; WT下辺
;;;;;    )
;;;;;    ((= &CutType "02")
;;;;;      (setq #rDis1 (distance #p1 #p5)) ; 奥行き
;;;;;      (setq #rDis2 (distance #p4 #p5)) ; WT下辺
;;;;;    )
;;;;;    ((or (= &CutType "03")(= &CutType "04"))
;;;;;      (setq #rDis1 (distance #p1 #p4)) ; 奥行き
;;;;;      (setq #rDis2 (distance #p3 #p4)) ; WT下辺
;;;;;    )
;;;;;    (T
;;;;;      (CFAlertMsg "Ｒエンド加工の判定が出来ません。")
;;;;;    )
;;;;;  );_cond
;;;;;  (list #rDis1 #rDis2)
;;;;;);KPGetRendDist
;;;<HOM>*************************************************************************
;;; <関数名>    : KPGetRendDist
;;; <処理概要>  : Rｴﾝﾄﾞ可否判定のための寸法を取得
;;; <戻り値>    : (距離1,距離2)=(WT奥行き,WT外形の下辺長さ)
;;; <作成>      : 01/07/25 YM
;;; <備考>      : 11/12/17 A.Satoh Modify
;;;*************************************************************************>MOH<
(defun KPGetRendDist (
	&WT_pt$		; WT外形点列
	&pnt$			; 指定位置座標（WT外形点列内の座標）
	/
	#idx #pnt1$ #pnt2$
	)

	(setq #idx 0)
	(repeat (length &WT_pt$)
		(if (= &pnt$ (nth #idx &WT_pt$))
			(if (= #idx 0)
				(progn
					(setq #pnt1$ (nth (1- (length &WT_pt$)) &WT_pt$))
					(setq #pnt2$ (nth 1 &WT_pt$))
				)
				(if (= #idx (1- (length &WT_pt$)))
					(progn
						(setq #pnt1$ (nth (1- #idx) &WT_pt$))
						(setq #pnt2$ (nth 0 &WT_pt$))
					)
					(progn
						(setq #pnt1$ (nth (1- #idx) &WT_pt$))
						(setq #pnt2$ (nth (1+ #idx) &WT_pt$))
					)
				)
			)
		)

		(setq #idx (1+ #idx))
	)

	(list (distance &pnt$ #pnt1$) (distance &pnt$ #pnt2$))

) ;KPGetRendDist
;-- 2011/12/17 A.Satoh Mod - E

;;;<HOM>*************************************************************************
;;; <関数名>    : KPSetClayerOtherFreeze
;;; <処理概要>  : 引数画層(なければ作成)を現在画層にしてそれ以外をﾌﾘｰｽﾞ
;;; <戻り値>    : なし
;;; <作成>      : 01/07/25 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KPSetClayerOtherFreeze (
  &LAYER ; 画層名(string)
  &col   ; 色番号=1-255(nil===>白)
  &line  ; 線種文字列  (nil===>"CONTINUOUS")
  /
  )
  (if (= nil &col)(setq &col 7))
  (if (= nil &line)(setq &line "CONTINUOUS"))
  ; テンポラリ画層の作成
  (if (tblsearch "LAYER" &LAYER)
    (progn
      (command "_layer" "U" &LAYER "") ; 警告メッセージ対策で2文に分けた  Uﾛｯｸ解除
      (command "_layer" "ON" &LAYER "T" &LAYER "")  ; ON表示 Tﾌﾘｰｽﾞ解除
     )
    (command "_layer" "N" &LAYER "C" &col &LAYER "L" &line &LAYER "")
  )
  (setvar "CLAYER" &LAYER)
  ; 現在画層(=SKD_TEMP_LAYER)以外をﾌﾘｰｽﾞ
  (command "_layer" "F" "*" "") ;全ての画層をﾌﾘｰｽﾞ
  (princ)
);KPSetClayerOtherFreeze

;;;<HOM>*************************************************************************
;;; <関数名>    : KPMakeDummyLineBG
;;; <処理概要>  : ﾕｰｻﾞｰ選択用にBG位置にLINEを作図
;;; <戻り値>    : 作図したLINE図形ﾘｽﾄ
;;; <作成>      : 01/07/25 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KPMakeDummyLineBG (
  &CutType ; WT左右ｶｯﾄﾀｲﾌﾟ"00","30"など 0]なし,1:Jｶｯﾄ,2:Yｶｯﾄ,3:45度ｶｯﾄ
  &WT_pt$  ; WT外形点列
  &WT_T    ; WT高さ
  /
  #CUTTYPE #EPL$ #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #WT_PT$
  )
    ;----------------------------------------------------------------------
    ; lineを作図して図形を返す
    (defun ##Line ( &p1 &p2 / )
      (command "_line" &p1 &p2 "")
      (entlast)
    )
    ;----------------------------------------------------------------------
    ; 座標値のＺを編集
    (defun ##ADDZ ( &p &Z / )
      (list (car &p) (cadr &p) &Z)
    )
    ;----------------------------------------------------------------------

  (setq #WT_pt$ &WT_pt$ #CutType &CutType)
  (setq #p1 (##ADDZ (nth 0 #WT_pt$) &WT_T)) ; WT左上点
  (setq #p2 (##ADDZ (nth 1 #WT_pt$) &WT_T)) ; WT右上点
  (setq #p3 (##ADDZ (nth 2 #WT_pt$) &WT_T))
  (setq #p4 (##ADDZ (nth 3 #WT_pt$) &WT_T))
  (setq #p5 (##ADDZ (nth 4 #WT_pt$) &WT_T))
  (setq #p6 (##ADDZ (nth 5 #WT_pt$) &WT_T))
  (setq #p7 (##ADDZ (nth 6 #WT_pt$) &WT_T))
  (setq #p8 (##ADDZ (nth 7 #WT_pt$) &WT_T))

  (setq #ePL$ nil)
  (cond
    ((= #CutType "11")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p8 #p1)
        )
      )
    )
    ((= #CutType "12")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p1 #p7)
        )
      )
    )
    ((= #CutType "00")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p3 #p4)
          (##Line #p4 #p1)
        )
      )
    )
    ((= #CutType "10")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p6 #p1)
        )
      )
    )
    ((or (= #CutType "01")(= #CutType "21"))
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
        )
      )
    )
    (T ; それ以外は上側のみ選択
      (setq #ePL$ (list (##Line #p1 #p2)))
    )
  );_cond
  #ePL$
);KPMakeDummyLineBG

;;;<HOM>*************************************************************************
;;; <関数名>    : KPMakeDummyLineFG
;;; <処理概要>  : ﾕｰｻﾞｰ選択用にFG位置にLINEを作図
;;; <戻り値>    : 作図したLINE図形ﾘｽﾄ
;;; <作成>      : 01/07/26 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KPMakeDummyLineFG (
  &CutType ; WT左右ｶｯﾄﾀｲﾌﾟ"00","30"など 0]なし,1:Jｶｯﾄ,2:Yｶｯﾄ,3:45度ｶｯﾄ
  &WT_pt$  ; WT外形点列
  &WT_T    ; WT高さ
  /
  #CUTTYPE #EPL$ #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #WT_PT$
  )
    ;----------------------------------------------------------------------
    ; lineを作図して図形を返す
    (defun ##Line ( &p1 &p2 / )
      (command "_line" &p1 &p2 "")
      (entlast)
    )
    ;----------------------------------------------------------------------
    ; 座標値のＺを編集
    (defun ##ADDZ ( &p &Z / )
      (list (car &p) (cadr &p) &Z)
    )
    ;----------------------------------------------------------------------

  (setq #WT_pt$ &WT_pt$ #CutType &CutType)
  (setq #p1 (##ADDZ (nth 0 #WT_pt$) &WT_T)) ; WT左上点
  (setq #p2 (##ADDZ (nth 1 #WT_pt$) &WT_T)) ; WT右上点
  (setq #p3 (##ADDZ (nth 2 #WT_pt$) &WT_T))
  (setq #p4 (##ADDZ (nth 3 #WT_pt$) &WT_T))
  (setq #p5 (##ADDZ (nth 4 #WT_pt$) &WT_T))
  (setq #p6 (##ADDZ (nth 5 #WT_pt$) &WT_T))
  (setq #p7 (##ADDZ (nth 6 #WT_pt$) &WT_T))
  (setq #p8 (##ADDZ (nth 7 #WT_pt$) &WT_T))

  (setq #ePL$ nil)
  (cond
    ((= #CutType "00")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p3 #p4)
          (##Line #p4 #p1)
        )
      )
    )
    ((= #CutType "01")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p5 #p6)
          (##Line #p6 #p1)
        )
      )
    )
    ((= #CutType "02")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p4 #p5)
          (##Line #p5 #p1)
        )
      )
    )
    ((or (= #CutType "03")(= #CutType "04"))
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p3 #p4)
          (##Line #p4 #p1)
        )
      )
    )
    ((= #CutType "10")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p3 #p4)
          (##Line #p6 #p1)
        )
      )
    )
    ((or (= #CutType "20")(= #CutType "30")(= #CutType "40"))
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p3 #p4)
        )
      )
    )
    ((= #CutType "11")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p5 #p6)
          (##Line #p8 #p1)
        )
      )
    )
    ((= #CutType "22")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p4 #p5)
        )
      )
    )
    ((= #CutType "33")
      (setq #ePL$
        (list
          (##Line #p3 #p4)
        )
      )
    )
    ((= #CutType "33")
      (setq #ePL$
        (list
          (##Line #p3 #p4)
        )
      )
    )
    ((= #CutType "12")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p4 #p5)
          (##Line #p7 #p1)
        )
      )
    )
    ((= #CutType "21")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p5 #p6)
        )
      )
    )
    (T ; それ以外は上側のみ選択
      (setq #ePL$ (list (##Line #p1 #p2)))
    )
  );_cond
  #ePL$
);KPMakeDummyLineFG

;;;<HOM>*************************************************************************
;;; <関数名>    : KPMakeDummyLineRend
;;; <処理概要>  : ﾕｰｻﾞｰ選択用にRend位置にLINEを作図
;;; <戻り値>    : 作図したLINE図形ﾘｽﾄ
;;; <作成>      : 01/07/26 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KPMakeDummyLineRend (
  &LR     ; Rend側 "Left" or "Right"
  &WT_pt$ ; WT外形点列
  &WT_T   ; WT高さ
  /
  #DPT1 #DPT2 #DPT3 #DPT4 #DPT5 #DPT6 #EPL$ #LAST #P1 #P2 #P3 #WT_PT$
  )
  ;----------------------------------------------------------------------
  ; lineを作図して図形を返す
  (defun ##Line ( &p1 &p2 / )
    (command "_line" &p1 &p2 "")
    (entlast)
  )
  ;----------------------------------------------------------------------
  ; 座標値のＺを編集
  (defun ##ADDZ ( &p &Z / )
    (list (car &p) (cadr &p) &Z)
  )
  ;----------------------------------------------------------------------

  (setq #WT_pt$ &WT_pt$)
  (setq #p1 (##ADDZ (nth 0 #WT_pt$) &WT_T)) ; WT左上点
  (setq #p2 (##ADDZ (nth 1 #WT_pt$) &WT_T)) ; WT右上点
  (setq #p3 (##ADDZ (nth 2 #WT_pt$) &WT_T))
  (setq #last (##ADDZ (last #WT_pt$) &WT_T))

  (setq #ePL$ nil)
  (cond
    ((= &LR "Right")
      (setq #dPT1 (polar #p2 (angle #p2 #p1)(atoi CG_R)))
      (setq #dPT2 #p2)
      (setq #dPT3 (polar #p2 (angle #p2 #p3)(atoi CG_R)))
      (setq #dPT4 (polar #p3 (angle #p3 #p2)(atoi CG_R)))
      (setq #dPT5 #p3)
      (setq #dPT6 (polar #p3 (angle #p2 #p1)(atoi CG_R)))

      (setq #ePL$
        (list
          (list (##Line #dPT1 #dPT2) #p2)
          (list (##Line #dPT2 #dPT3) #p2)
          (list (##Line #dPT4 #dPT5) #p3)
          (list (##Line #dPT5 #dPT6) #p3)
        )
      )
    )
    ((= &LR "Left")
      (setq #dPT1 (polar #p1   (angle #p1 #p2)  (atoi CG_R)))
      (setq #dPT2 #p1)
      (setq #dPT3 (polar #p1   (angle #p1 #last)(atoi CG_R)))
      (setq #dPT4 (polar #last (angle #last #p1)(atoi CG_R)))
      (setq #dPT5 #last)
      (setq #dPT6 (polar #last (angle #p1 #p2)  (atoi CG_R)))

      (setq #ePL$
        (list
          (list (##Line #dPT1 #dPT2) #p1)
          (list (##Line #dPT2 #dPT3) #p1)
          (list (##Line #dPT4 #dPT5) #last)
          (list (##Line #dPT5 #dPT6) #last)
        )
      )
    )
    (T
      (CFAlertMsg "Ｒエンド加工ません。")(*error*)
    )
  );_cond
  #ePL$
);KPMakeDummyLineRend

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KPAdd_BG
;;; <処理概要>  : 既存WTにBGを追加する
;;; <戻り値>    : なし
;;; <作成>      : 01/07/25 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KPAdd_BG (
  /
  #BASEPT #BG0 #BG_H #BG_REGION #BG_SOLID #BG_T
  #CL #CLAYER #CR #CUTTYPE #EPL #EPL$ #EPL_OFFSET #FG_H #FG_S
  #FG_T #GRIDMODE #LOOP #OFPT #ORTHOMODE #OSMODE
  #PD #SNAPMODE #SS #WTEN #WT_H #WT_PT$ #WT_T
  #WT_TEI #XD$ #AUTOSNAP
  )
    ;----------------------------------------------------------------------
    ; 座標値のＺを編集
    (defun ##ADDZ ( &p &Z / )
      (list (car &p) (cadr &p) &Z)
    )
    ;----------------------------------------------------------------------

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPAdd_BG ////")
  (CFOutStateLog 1 1 " ")
  ;// コマンドの初期化
  (StartUndoErr)

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setq #AUTOSNAP  (getvar "AUTOSNAP"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)
  (setvar "AUTOSNAP"  0)
  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM
  ;// ワークトップの指示
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\nワークトップを選択: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "ワークトップではありません。")
      (setq #loop nil)
    );_if

  );while

  ; WT左右ｶｯﾄﾀｲﾌﾟ0:なし,1:Jｶｯﾄ,2:Yｶｯﾄ,3:45ｶｯﾄ,4:段差接続
  (setq #CutType (nth 7 #xd$)) ; ｶｯﾄﾀｲﾌﾟ
  ; ｶｯﾄ記号
  (setq #CL (substr #CutType 1 1))
  (setq #CR (substr #CutType 2 1))
  (if (or (= "3" #CL)(= "3" #CR))
    (progn
      (CFAlertMsg "このワークトップはバックガードを追加できません。")
      (*error*)
    )
    (progn
      ; WT情報取得
      (setq #WT_H (nth  8 #xd$))  ; WT高さ
      (setq #WT_T (nth 10 #xd$))  ; WT厚み
      (setq #BG_H (nth 12 #xd$))  ; BG高さ
      (setq #BG_T (nth 13 #xd$))  ; BG厚み
      (setq #FG_H (nth 15 #xd$))  ; FG高さ
      (setq #FG_T (nth 16 #xd$))  ; FG厚み
      (setq #FG_S (nth 17 #xd$))  ; FGｼﾌﾄ量

      ; 各底面取得
      (setq #WT_tei (nth 38 #xd$))   ; WT底面図形ﾊﾝﾄﾞﾙ
      (setq #BASEPT (nth 32 #xd$))   ; WT左上点

      ; WT底面点列取得
      (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))     ; WT外形点列
      (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT 左上点から時計周りに並び替える

      (setq #clayer (getvar "CLAYER")); 現在画層
      ; 引数画層(なければ作成)を現在画層にしてそれ以外をﾌﾘｰｽﾞ 色番号1-255,線種
      (KPSetClayerOtherFreeze SKD_TEMP_LAYER 1 SKW_AUTO_LAY_LINE)
      ; BG作成側をﾕｰｻﾞｰに選択させるためのLINEを作図 画層=SKD_TEMP_LAYERのみ表示
      (setq #ePL$ (KPMakeDummyLineBG #CutType #WT_pt$ (+ #WT_H #WT_T))) ; 戻り値=ﾕｰｻﾞｰ選択用に作図したLINE図形ﾘｽﾄ
      ; BG側の指示(LINEの指示)
      (if (< 1 (length #ePL$)) ; 選択肢が複数
        (progn
          (initget 0)
          (setq #loop T)
          (while #loop
            (setq #ePL (car (entsel "\nバックガード追加側を指示: ")))
            (if #ePL
              (progn
                (foreach #e #ePL$
                  (if (equal #ePL #e)
                    (setq #loop nil)
                  );_if
                )
              )
            );_if
          );while
        )
        (setq #ePL (car #ePL$))
      );_if

      ; 線分をZ=0に移動(ｵﾌｾｯﾄがうまくいかないから)
      (command "_move" #ePL "" '(0 0 0) (strcat "@0,0," (rtos (- (+ #WT_H #WT_T)))))

      ; ｵﾌｾｯﾄして線分を追加
      (setq #ofPT (mapcar '+ (nth 0 #WT_pt$)(nth 2 #WT_pt$)))
      (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
      (command "_offset" #BG_T #ePL #ofPT "")
      (setq #ePL_offset (entlast))

      ; BG底面作成
      (setq #BG0
        (MakeTEIMEN
          (list
            (##ADDZ (cdr (assoc 10 (entget #ePL))) 0)
            (##ADDZ (cdr (assoc 11 (entget #ePL))) 0)
            (##ADDZ (cdr (assoc 11 (entget #ePL_offset))) 0)
            (##ADDZ (cdr (assoc 10 (entget #ePL_offset))) 0)
          )
        )
      )
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG0)) (entget #BG0))) ; 底面ﾎﾟﾘﾗｲﾝ

      ; ﾕｰｻﾞｰ選択用LINEとｵﾌｾｯﾄLINEの削除
      (foreach #e #ePL$
        (entdel #e)
      )
      (entdel #ePL_offset)
      ; 表示画層の設定(元に戻す)
      (SetLayer)
      (setvar "CLAYER" #clayer) ; 現在画層を戻す
      ; BGSOLID作成
      (setvar "delobj" 1) ; 押し出し後に底面を削除する
      (setq #BG_region (Make_Region2 #BG0))
      (setq #BG_SOLID  (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
      ;BG,WTの和をとる
      (setq #ss (ssadd))
      (ssadd #wtEn #ss)
      (if #BG_SOLID (ssadd #BG_SOLID #ss)) ; BG_SOLIDを追加
      (command "_union" #ss "")
      ; 品番確定されていれば色替え
      (if (CFGetXData #wtEn "G_WTSET")
        (command "_.change" #wtEn "" "P" "C" CG_WorkTopCol "")
      );_if
    )
  );_if

  (setvar "SNAPMODE"  #SNAPMODE )
  (setvar "GRIDMODE"  #GRIDMODE )
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE   )
  (setvar "AUTOSNAP"  #AUTOSNAP )
  (setvar "pdmode" #PD) ; 06/12 YM

  (setq *error* nil)
  (princ)

);C:KPAdd_BG

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KPAdd_FG
;;; <処理概要>  : 既存WTにBGを追加する
;;; <戻り値>    : なし
;;; <作成>      : 01/07/25 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KPAdd_FG (
  /
  #AUTOSNAP #BASEPT #BG_H #BG_T #CL #CLAYER #CR #CUTTYPE #EPL #EPL$ #EPL_OFFSET
  #FG0 #FG_H #FG_REGION #FG_S #FG_SOLID #FG_T #GRIDMODE #LOOP #OFPT #ORTHOMODE
  #OSMODE #PD #SNAPMODE #SS #WTEN #WT_H #WT_PT$ #WT_T #WT_TEI #XD$
  )
    ;----------------------------------------------------------------------
    ; 座標値のＺを編集
    (defun ##ADDZ ( &p &Z / )
      (list (car &p) (cadr &p) &Z)
    )
    ;----------------------------------------------------------------------

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPAdd_FG ////")
  (CFOutStateLog 1 1 " ")
  ;// コマンドの初期化
  (StartUndoErr)

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setq #AUTOSNAP  (getvar "AUTOSNAP"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)
  (setvar "AUTOSNAP"  0)
  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM
  ;// ワークトップの指示
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\nワークトップを選択: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "ワークトップではありません。")
      (setq #loop nil)
    );_if

  );while

  ; WT左右ｶｯﾄﾀｲﾌﾟ0:なし,1:Jｶｯﾄ,2:Yｶｯﾄ,3:45ｶｯﾄ,4:段差接続
  (setq #CutType (nth 7 #xd$)) ; ｶｯﾄﾀｲﾌﾟ
  ; ｶｯﾄ記号
  (setq #CL (substr #CutType 1 1))
  (setq #CR (substr #CutType 2 1))
  (if (or (= "3" #CL)(= "3" #CR))
    (progn
      nil ; 制限なし
;;;     (CFAlertMsg "このワークトップはバックガードを追加できません。")
;;;     (*error*)
    )
    (progn
      ; WT情報取得
      (setq #WT_H (nth  8 #xd$))  ; WT高さ
      (setq #WT_T (nth 10 #xd$))  ; WT厚み
      (setq #BG_H (nth 12 #xd$))  ; BG高さ
      (setq #BG_T (nth 13 #xd$))  ; BG厚み
      (setq #FG_H (nth 15 #xd$))  ; FG高さ
      (setq #FG_T (nth 16 #xd$))  ; FG厚み
      (setq #FG_S (nth 17 #xd$))  ; FGｼﾌﾄ量

      ; 各底面取得
      (setq #WT_tei (nth 38 #xd$))   ; WT底面図形ﾊﾝﾄﾞﾙ
      (setq #BASEPT (nth 32 #xd$))   ; WT左上点

      ; WT底面点列取得
      (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))     ; WT外形点列
      (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT 左上点から時計周りに並び替える

      (setq #clayer (getvar "CLAYER")); 現在画層
      ; 引数画層(なければ作成)を現在画層にしてそれ以外をﾌﾘｰｽﾞ 色番号1-255,線種
      (KPSetClayerOtherFreeze SKD_TEMP_LAYER 1 SKW_AUTO_LAY_LINE)
      ; BG作成側をﾕｰｻﾞｰに選択させるためのLINEを作図 画層=SKD_TEMP_LAYERのみ表示
      (setq #ePL$ (KPMakeDummyLineFG #CutType #WT_pt$ (+ #WT_H #WT_T))) ; 戻り値=ﾕｰｻﾞｰ選択用に作図したLINE図形ﾘｽﾄ
      ; BG側の指示(LINEの指示)
      (if (< 1 (length #ePL$)) ; 選択肢が複数
        (progn
          (initget 0)
          (setq #loop T)
          (while #loop
            (setq #ePL (car (entsel "\n前垂れ追加側を指示: ")))
            (if #ePL
              (progn
                (foreach #e #ePL$
                  (if (equal #ePL #e)
                    (setq #loop nil)
                  );_if
                )
              )
            );_if
          );while
        )
        (setq #ePL (car #ePL$))
      );_if

      ; 線分をZ=0に移動(ｵﾌｾｯﾄがうまくいかないから)
      (command "_move" #ePL "" '(0 0 0) (strcat "@0,0," (rtos (- (+ #WT_H #WT_T)))))

      ; ｵﾌｾｯﾄして線分を追加
      (setq #ofPT (mapcar '+ (nth 0 #WT_pt$)(nth 2 #WT_pt$)))
      (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
      (command "_offset" #BG_T #ePL #ofPT "")
      (setq #ePL_offset (entlast))

      ; FG底面作成
      (setq #FG0
        (MakeTEIMEN
          (list
            (##ADDZ (cdr (assoc 10 (entget #ePL))) 0)
            (##ADDZ (cdr (assoc 11 (entget #ePL))) 0)
            (##ADDZ (cdr (assoc 11 (entget #ePL_offset))) 0)
            (##ADDZ (cdr (assoc 10 (entget #ePL_offset))) 0)
          )
        )
      )
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG0)) (entget #FG0))) ; 底面ﾎﾟﾘﾗｲﾝ

      ; ﾕｰｻﾞｰ選択用LINEとｵﾌｾｯﾄLINEの削除
      (foreach #e #ePL$
        (entdel #e)
      )
      (entdel #ePL_offset)
      ; 表示画層の設定(元に戻す)
      (SetLayer)
      (setvar "CLAYER" #clayer) ; 現在画層を戻す
      ; BGSOLID作成
      (setvar "delobj" 1) ; 押し出し後に底面を削除する
      (setq #FG_region (Make_Region2 #FG0))
      (setq #FG_SOLID  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
      ;FG,WTの和をとる
      (setq #ss (ssadd))
      (ssadd #wtEn #ss)
      (if #FG_SOLID (ssadd #FG_SOLID #ss)) ; FG_SOLIDを追加
      (command "_union" #ss "")
      ; 品番確定されていれば色替え
      (if (CFGetXData #wtEn "G_WTSET")
        (command "_.change" #wtEn "" "P" "C" CG_WorkTopCol "")
      );_if
    )
  );_if

  (setvar "SNAPMODE"  #SNAPMODE )
  (setvar "GRIDMODE"  #GRIDMODE )
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE   )
  (setvar "AUTOSNAP"  #AUTOSNAP )
  (setvar "pdmode" #PD) ; 06/12 YM

  (setq *error* nil)
  (princ)

);C:KPAdd_FG

;<HOM>*************************************************************************
; <関数名>    : C:KPRendWT
; <処理概要>  : ワークトップの端をＲｴﾝﾄﾞにする
; <戻り値>    : なし
; <作成>      : 01/07/09 YM
; <備考>      : 底面をFILLET->extrude BG一体型を想定
; <Ver.UP>      01/08/02 YM
;               ｼﾘｰｽﾞによる制限なくす.片側Jｶｯﾄのみ.BG形状は元のWTを引き継ぐ
;               前垂れはRｴﾝﾄﾞに沿って作成
;*************************************************************************>MOH<
(defun C:KPRendWT (
  /
;-- 2011/12/17 A.Satoh Mod - S
;-- 2011/08/09 A.Satoh Mod - S
;  #ARC1 #ARC2 #BASEPT #BG_H #BG_SOLID #BG_T #CL #CR #CUTTYPE #DELOBJ
;  #FG_H #FG_S #FG_T #GRIDMODE #KAIJO #LAST #LINE$ #LOOP #ORTHOMODE #OSMODE
;  #P1 #P2 #P3 #PD #RR #SNAPMODE #SS #SS_DUM #WTEN #WTL #WTR #WT_H #WT_PT$
;  #WT_REGION #WT_SOLID #WT_T #WT_TEI #X #XD$ #XDL$ #XDR$ #XD_NEW$ #YESNOMSG
;  #BG #BG0 #BG_REGION #DUM1 #DUM2 #BG_TEI1 #BG_TEI2 #FG_TEI1 #FG_TEI2
;  #dist1 #dist2 #DEP #FG0 #FG_REGION #FG_SOLID #P4 #P5
;  #BG_SOLID1 #BG_SOLID2 #DIST$ #ITYPE
  #SNAPMODE #GRIDMODE #ORTHOMODE #OSMODE #PD #CMDECHO
  #def_rr #rr #ssWT #idx #eWTP #WRKT$ #kaku #BG1 #BG2
;-- 2011/08/09 A.Satoh Mod - E
;|
	#SNAPMODE #GRIDMODE #ORTHOMODE #OSMODE #PD #CMDECHO #loop #wtEn$ #wtEn #xd_WRKT$
	#sel_pnt$ #xd_WTEST$ #kaku #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #WT_tei
	#BASEPT #BG_tei1 #BG_tei2 #FG_tei1 #FG_tei2 #dep #WT_pt$ #pt$ #dist$ #def_rr #rr
	#ss_dum #line$ #arc #FG0 #delobj #WT_region #WT_SOLID #BG_SOLID1 #BG_SOLID2 #BG
	#BG_region #FG_region #FG_SOLID #ss #xd_new$ #WTL #WTR #xdL$ #xdR$ #clayer
|;
;-- 2011/12/17 A.Satoh Mod - E
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPRendWT ////")
  (CFOutStateLog 1 1 " ")

;-- 2011/12/13 A.Satoh Add - S
;|
    ;//////////////////////////////////////////////////////////
		;//////////////////////////////////////////////////////////////////////////
		; ユーザー入力Ｒ(径)が妥当か判定(戻り値:T or nil)
		;//////////////////////////////////////////////////////////////////////////
		(defun ##RENDhantei (
			&dist$ ; (奥行き,WT下辺)
			&R     ; R(径)
			/
			#ret #dist1 #dist2
			)

			(setq #dist1 (car  &dist$))
			(setq #dist2 (cadr &dist$))

			(if (and (< &R #dist1)(< &R #dist2))
				(setq #ret T)
				(setq #ret nil)
			)

			#ret
		) ;##RENDhantei

		;//////////////////////////////////////////////////////////////////////////
		; &ss("LINE"選択ｾｯﾄ)のうち始点or終点が&ptと一致する図形ﾘｽﾄを返す
		;//////////////////////////////////////////////////////////////////////////
		(defun ##GETLINE (
			&ss
			&pt
			/
			#list$ #idx #en
			)

			(setq #list$ nil)
			(if (and &ss (< 0 (sslength &ss)))
				(progn
					(setq #idx 0)
					(repeat (sslength &ss)
						(setq #en (ssname &ss #idx))
						(if (or (< (distance (cdr (assoc 10 (entget #en))) &pt) 0.1)
										(< (distance (cdr (assoc 11 (entget #en))) &pt) 0.1))
							(setq #list$ (append #list$ (list #en)))
						)
						(setq #idx (1+ #idx))
					)
				)
			)

			#list$
		)

		;//////////////////////////////////////////////////////////////////////////
		; &en("LINE"図形)-->始点,終点ｎ中点を返す
		;//////////////////////////////////////////////////////////////////////////
		(defun ##CENTER_PT (
			&en
			/
			#dum
			)

			(setq #dum (mapcar '+ (cdr (assoc 10 (entget &en))) (cdr (assoc 11 (entget &en)))))

      (setq #dum (mapcar '* #dum '(0.5 0.5 0.5)))

    )

		;//////////////////////////////////////////////////////////////////////////
		; &en(既存底面図形 or "")を削除する
		;//////////////////////////////////////////////////////////////////////////
		(defun ##ENTDEL (
			&en
			)

			(if (and &en (/= &en "")(entget &en))
				(entdel &en)
			)

			(princ)
		)

		;//////////////////////////////////////////////////////////////////////////
		; fillet処理
		;//////////////////////////////////////////////////////////////////////////
		(defun ##FILLET (
			&line$
			/
			#en1 #en2 #sp1 #sp2 #arc
			)

			(if &line$
				(progn
					(setq #en1 (car  &line$))
					(setq #en2 (cadr &line$))
					(setq #sp1 (##CENTER_PT #en1))
					(setq #sp2 (##CENTER_PT #en2))
					(command "_fillet" (list #en1 #sp1)(list #en2 #sp2))
					(setq #arc (entlast))
				)
				(progn
					(CFAlertMsg "フィレット処理ができませんでした。")(quit)
				)
			)

			#arc
		)
    ;//////////////////////////////////////////////////////////////////////////
|;
;-- 2011/12/13 A.Satoh Add - E

;-- 2011/08/09 A.Satoh Mod - S
  ;// コマンドの初期化
  (StartUndoErr)

	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setq #PD        (getvar "PDMODE"))
  (setq #CMDECHO   (getvar "CMDECHO"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)
  (setvar "PDMODE"   34)
  (setvar "CMDECHO"   0)

;-- 2011/12/13 A.Satoh Mod - S
;|
  ; 現在画層を取得
  (setq #clayer (getvar "CLAYER"))

  ; 引数画層(なければ作成)を現在画層にしてそれ以外をﾌﾘｰｽﾞ 色番号1-255,線種
  (KPSetClayerOtherFreeze SKW_AUTO_SOLID 1 SKW_AUTO_LAY_LINE)

	; 上からの視線に変更
  (command "vpoint" "0,0,1")
  (command "zoom" "0.8x")

	(setq #loop T)
	(while #loop
		(setq #wtEn$ (entsel "\nワークトップ上のＲ加工位置を選択"))
		(setq #wtEn (car #wtEn$))
		(if #wtEn
			(setq #xd_WRKT$ (CFGetXData #wten "G_WRKT"))
      (setq #xd_WRKT$ nil)
    )

		(if (= #xd_WRKT$ nil)
			(CFAlertMsg "ワークトップではありません。")
			(progn
				(setq #sel_pnt$ (cadr #wtEn$))
				(setq #xd_WTEST$ (CFGetXData #wtEn "G_WTSET"))
				(if #xd_WTSET$
					(setq #kaku T)
					(setq #kaku nil)
				)
				(setq #loop nil)
			)
		)
	)

	; 画層の表示状態を元に戻す
	(SetLayer)

  ; 現在画層を戻す
  (setvar "CLAYER" #clayer)

	; 視線を元に戻す
  (command "zoom" "p")
  (command "zoom" "p")

(princ "\nWT選択位置座標 = ")(princ #sel_pnt$)

	; WT情報取得
	(setq #WT_H    (nth  8 #xd_WRKT$))		; WT高さ
	(setq #WT_T    (nth 10 #xd_WRKT$))		; WT厚み
	(setq #BG_H    (nth 12 #xd_WRKT$))		; BG高さ
	(setq #BG_T    (nth 13 #xd_WRKT$))		; BG厚み
	(setq #FG_H    (nth 15 #xd_WRKT$))		; FG高さ
	(setq #FG_T    (nth 16 #xd_WRKT$))		; FG厚み
	(setq #FG_S    (nth 17 #xd_WRKT$))		; FGｼﾌﾄ量

	; 各底面取得
	(setq #WT_tei  (nth 38 #xd_WRKT$))		; WT底面図形ﾊﾝﾄﾞﾙ
	(setq #BASEPT  (nth 32 #xd_WRKT$))		; WT左上点
	(setq #BG_tei1 (nth 49 #xd_WRKT$))		; BG SOLID1 or 底面1
	(setq #BG_tei2 (nth 50 #xd_WRKT$))		; BG SOLID2 or 底面2 もしあればそのまま
	(setq #FG_tei1 (nth 51 #xd_WRKT$))		; FG1底面 *
	(setq #FG_tei2 (nth 52 #xd_WRKT$))		; F2G底面 *
	(setq #dep (car (nth 57 #xd_WRKT$)))	; WT奥行き

	; WT底面点列取得
	(setq #WT_pt$ (GetLWPolyLinePt #WT_tei))			; WT外形点列
	(setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$))	; WT 左上点から時計周りに並び替える
(princ "\nWT底面点列リスト = ") (princ #WT_pt$)

	; WT底面点列リストから選択位置に最も近い座標点を求める
	(setq #pt$ (GetNearPoint #WT_pt$ #sel_pnt$))

(princ "\n加工位置座標 = ") (princ #pt$)

	; Ｒエンド（フィレット）可否チェック用寸法取得
	(setq #dist$ (KPGetRendDist #WT_pt$ #pt$))

	; R(径)を入力
	(setq #def_rr "60")
	(setq #loop T)
	(while #loop
		(setq #rr (getreal (strcat "\n半径Rを入力<" #def_rr ">: ")))
		(if (= #rr nil)
			(progn
				(setq #rr (atoi #def_rr))
				(setq #loop nil)
			)
			(if (##RENDhantei #dist$ #rr) ; 奥行きの半分を超えてはいけない
				(setq #loop nil)
				(progn
					(setq #loop T)
					(princ "\n値が大きすぎてフィレットできません。")
				)
			)
		)
	)

	; フィレット円弧の半径を設定
  (command "_fillet" "R" #rr)

	; 既存のワークトップ(前垂れ込み3DSOLID)を削除
	(entdel #wtEn)

	; 既存底面削除
	(##ENTDEL #FG_tei1)
	(##ENTDEL #FG_tei2)

	; WT底面をｺﾋﾟｰして分解
	(entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT_tei)) (entget #WT_tei)))
	(command "_explode" (entlast))
	(setq #ss_dum (ssget "P"))

	; 底面をFillet処理
	(setq #line$ (##GETLINE #ss_dum #pt$))
	(setq #arc (##FILLET #line$))
	(ssadd #arc #ss_dum)

	; FG底面作成
	(setq #FG0 (KPMakeFGTeimen_WT #WT_pt$ #arc #FG_T #rr #pt$))

	(setq #delobj (getvar "delobj"))
	(setvar "delobj" 1)

	; Pedit ﾎﾟﾘﾗｲﾝ化 WT 再作成
	(command "_pedit" (ssname #ss_dum 0) "Y" "J" #ss_dum "" "X")

	(setq #WT_region (Make_Region2 (entlast)))
	(setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))

	; BG_SOLID再作成
	(setq #BG_SOLID1 nil #BG_SOLID2 nil)
	(if (and #BG_tei1 (/= #BG_tei1 ""))
		(progn
			(entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG_tei1)) (entget #BG_tei1)))
			(setq #BG (entlast))
			(setq #BG_region (Make_Region2 #BG))
			(setq #BG_SOLID1 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
		)
	)

	(if (and #BG_tei2 (/= #BG_tei2 ""))
		(progn
			(entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG_tei2)) (entget #BG_tei2)))
			(setq #BG (entlast))
			(setq #BG_region (Make_Region2 #BG))
			(setq #BG_SOLID2 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
		)
	)

  ; FG_SOLID再作成
	(if #FG0
		(progn
			(setq #FG_region (Make_Region2 #FG0))
			(setq #FG_SOLID  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
		)
	);_if

	; システム変数を戻す
	(setvar "delobj" #delobj)

	(setq #ss (ssadd))
	(ssadd #WT_SOLID #ss)

	; BG_SOLIDを追加
	(if #BG_SOLID1
		(ssadd #BG_SOLID1 #ss)
	)

	; BG_SOLIDを追加
	(if #BG_SOLID2
		(ssadd #BG_SOLID2 #ss)
	)

	; FG_SOLIDを追加
	(if #FG_SOLID
		(ssadd #FG_SOLID #ss)
	)

	;BG,WTの和をとる（交わらない領域でもＯＫ！）
	(command "_union" #ss "")

	;// 拡張データの再設定 前垂れなし
	(setq #xd_new$ (list (list 51 "") (list 52 "")))
	(CFSetXData #WT_SOLID "G_WRKT" (CFModList #xd_WRKT$ #xd_new$))

	(setq #WTL (nth 47 #xd_WRKT$)) ; ｶｯﾄ相手WT左
	(setq #WTR (nth 48 #xd_WRKT$)) ; ｶｯﾄ相手WT右

	;左側WTの拡張データも更新する
	(if (and (/= #WTL "") (/= #WTL nil))
		(progn
			(setq #xdL$ (CFGetXData #WTL "G_WRKT"))
			(CFSetXData #WTL "G_WRKT" (CFModList #xdL$ (list (list 48 #WT_SOLID))))
		)
	)

  ;右側WTの拡張データも更新する
  (if (and (/= #WTR "") (/= #WTR nil))
    (progn
      (setq #xdR$ (CFGetXData #WTR "G_WRKT"))
      (CFSetXData #WTR "G_WRKT" (CFModList #xdR$ (list (list 47 #WT_SOLID))))
		)
	)
|;

  ; フィレットを実行
  (princ "\n天板の角を選択: ")
  (command "_.FILLET" pause)

  ; R(径)を入力
  (setq #def_rr "60")
  (setq #rr (getreal (strcat "\n半径Rを入力<" #def_rr ">: ")))
  (if (= #rr nil)
    (setq #rr (atoi #def_rr))
  )
  (command #rr "")

  ; ワークトップ:フィレット部分の色を変える
  (setq #ssWT (ssget "X" '((-3 ("G_WRKT")))))
  (if (and #ssWT (> (sslength #ssWT) 0))
    (progn
      (setq #idx 0)
      (repeat (sslength #ssWT)
        (setq #eWTP (ssname #ssWT #idx))

        (setq #WRKT$ (CFGetXData #eWTP "G_WRKT"))

        (if (CFGetXData #eWTP "G_WTSET")
          (setq #kaku T)
          (setq #kaku nil)
        )

        (if (= #kaku T)
          (progn
            (command "_.change" #eWTP "" "P" "C" CG_WorkTopCol "")

            ; BG,FGも一緒に色替えする
            (setq #BG1 (nth 49 #WRKT$))
            (setq #BG2 (nth 50 #WRKT$))
            (if (/= #BG1 "")
              (if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
                (command "_.change" #BG1 "" "P" "C" CG_WorkTopCol "")
              )
            );_if
            (if (/= #BG2 "")
              (if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
                (command "_.change" #BG2 "" "P" "C" CG_WorkTopCol "")
              )
            )
          )
          (progn
            (command "_.change" #eWTP "" "P" "C" "BYLAYER" "")
          )
        )

        (setq #idx (1+ #idx))
      )
    )
  )
;-- 2011/12/13 A.Satoh Mod - E

  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)
  (setvar "PDMODE"    #PD)
  (setvar "CMDECHO"   #CMDECHO)

  (setq *error* nil)
  (princ)

;|
    ;//////////////////////////////////////////////////////////////////////////
    ;ﾕｰｻﾞｰ入力R(径)が妥当か判定(戻り値:T or nil)
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##RENDhantei (
      &dist$ ; (奥行き,WT下辺)
      &iType ; Rｴﾝﾄﾞﾀｲﾌﾟ 1:両側 , 2:右側 , 3:左側
      &R     ; R(径)
      /
      #ret #dist1 #dist2
      )
      (setq #dist1 (car  &dist$))
      (setq #dist2 (cadr &dist$))
      (cond
        ((or (= &iType 2)(= &iType 3))
          (if (and (< &R #dist1)(< &R #dist2))
            (setq #ret T)
            (setq #ret nil)
          );_if
        )
        ((= &iType 1) ; 両側
          (if (and (< &R (* 0.5 #dist1))(< &R #dist2))
            (setq #ret T)
            (setq #ret nil)
          );_if
        )
      );_cond
      #ret
    );##RENDhantei
    ;//////////////////////////////////////////////////////////////////////////
    ;&ss("LINE"選択ｾｯﾄ)のうち始点or終点が&ptと一致する図形ﾘｽﾄを返す
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##GETLINE (
      &ss
      &pt
      /
      #EN #I #LIST$
      )
      (setq #list$ nil)
      (if (and &ss (< 0 (sslength &ss)))
        (progn
          (setq #i 0)
          (repeat (sslength &ss)
            (setq #en (ssname &ss #i))
            (if (or (< (distance (cdr (assoc 10 (entget #en))) &pt) 0.1)
                    (< (distance (cdr (assoc 11 (entget #en))) &pt) 0.1))
              (setq #list$ (append #list$ (list #en)))
            );_if
            (setq #i (1+ #i))
          )
        )
      );_if
      #list$
    )
    ;//////////////////////////////////////////////////////////////////////////
    ;&en("LINE"図形)-->始点,終点ｎ中点を返す
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##CENTER_PT ( &en / #DUM)
      (setq #dum (mapcar '+ (cdr (assoc 10 (entget &en)))
                            (cdr (assoc 11 (entget &en)))))
      (setq #dum (mapcar '* #dum '(0.5 0.5 0.5)))
    )

    ;//////////////////////////////////////////////////////////////////////////
    ;&en(既存底面図形 or "")を削除する
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL ( &en / )
      (if (and &en (/= &en "")(entget &en))
        (entdel &en)
      );_if
      (princ)
    )

    ;//////////////////////////////////////////////////////////////////////////
    ;fillet処理
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##FILLET ( &line$ / #ARC #EN1 #EN2 #SP1 #SP2)
      (if &line$
        (progn
          (setq #en1 (car  &line$))
          (setq #en2 (cadr &line$))
          (setq #sp1 (##CENTER_PT #en1))
          (setq #sp2 (##CENTER_PT #en2))
          (command "_fillet" (list #en1 #sp1)(list #en2 #sp2))
          (setq #arc (entlast))
        )
        (progn
          (CFAlertMsg "フィレット処理ができませんでした。")(quit)
        )
      );_if
      #arc
    )

    ;//////////////////////////////////////////////////////////

  (setq #KAIJO nil)  ; 品番確定解除ﾌﾗｸﾞ
  ;// コマンドの初期化
  (StartUndoErr)
  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)
  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM
  ;// ワークトップの指示
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\nワークトップを選択: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "ワークトップではありません。")
    ;else
      (cond
        ((CFGetXData #wtEn "G_WTSET")
          (setq #YesNoMsg "ワークトップは品番確定されています。\n処理を続けますか？")
          (if (CFYesNoDialog #YesNoMsg)
            (progn
              (setq #loop nil) ; YES なら継続
              (setq #KAIJO T)  ; 品番確定解除ﾌﾗｸﾞ
            )
            (*error*)        ; NO  ならSTOP
          );_if
        )
        (T
          (setq #loop nil)
        )
      );_cond
    );_if

  );while

  ; 条件判定 人大JｶｯﾄならRｴﾝﾄﾞ可能
  (setq #CutType (nth 7 #xd$)) ; ｶｯﾄﾀｲﾌﾟ
  ; ｶｯﾄ記号
  (setq #CL (substr #CutType 1 1))
  (setq #CR (substr #CutType 2 1))

  (cond
    ((and (= #CL "1") (= #CR "0"))
      (setq #x "Right") ; Rｴﾝﾄﾞ側=右
    )
    ((and (= #CL "0") (= #CR "1"))
      (setq #x "Left") ; Rｴﾝﾄﾞ側=左
    )
    (T
      (CFAlertMsg "このワークトップはＲエンド加工できません。")(quit)
    )
  );_cond

  (PCW_ChColWT #wtEn "MAGENTA" nil) ; 色を変える

  ; WT情報取得
  (setq #WT_H (nth  8 #xd$))  ; WT高さ
  (setq #WT_T (nth 10 #xd$))  ; WT厚み
  (setq #BG_H (nth 12 #xd$))  ; BG高さ
  (setq #BG_T (nth 13 #xd$))  ; BG厚み
  (setq #FG_H (nth 15 #xd$))  ; FG高さ
  (setq #FG_T (nth 16 #xd$))  ; FG厚み
  (setq #FG_S (nth 17 #xd$))  ; FGｼﾌﾄ量

  ; 各底面取得
  (setq #WT_tei (nth 38 #xd$))   ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BASEPT (nth 32 #xd$))   ; WT左上点
  (setq #BG_tei1 (nth 49 #xd$))  ; BG SOLID1 or 底面1
  (setq #BG_tei2 (nth 50 #xd$))  ; BG SOLID2 or 底面2 もしあればそのまま
  (setq #FG_tei1 (nth 51 #xd$))  ; FG1底面 *
  (setq #FG_tei2 (nth 52 #xd$))  ; F2G底面 *
  (setq #dep (car (nth 57 #xd$))); WT奥行き

  ; WT底面点列取得
  (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))     ; WT外形点列
  (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT 左上点から時計周りに並び替える
  (setq #p1 (nth 0 #WT_pt$)) ; WT左上点
  (setq #p2 (nth 1 #WT_pt$)) ; WT右上点
  (setq #p3 (nth 2 #WT_pt$))
  (setq #p4 (nth 3 #WT_pt$))
  (setq #p5 (nth 4 #WT_pt$))
  (setq #last (last #WT_pt$))
  ; Rｴﾝﾄﾞ可否ﾁｪｯｸ用寸法 WTｶｯﾄﾀｲﾌﾟ"10","01"
  (setq #dist$ (KPGetRendDist #WT_pt$ #CutType)) ; (奥行き,WT下辺)
;;; &WT_pt$  ; WT外形点列
;;; &CutType ; WTｶｯﾄﾀｲﾌﾟ"00","20"など"左右" 0:ｶｯﾄなし,1:Jｶｯﾄ,2:Yｶｯﾄ,3:45度ｶｯﾄ,4:段差接続

  ; 加工ﾀｲﾌﾟを入力
  (setq #loop T)
  (while #loop
    (setq #iType (getint "\nRｴﾝﾄﾞﾀｲﾌﾟ /1=両側/2=左側/3=右側/ <両側>:  "))
    (if (= #iType nil)
      (progn
        (setq #iType 1)
        (setq #loop nil)
      )
      (progn
        (if (or (= #iType 1)(= #iType 2)(= #iType 3))
          (setq #loop nil)
          (setq #loop T)
        );_if
      )
    ); if
  )

  ; R(径)を入力
  (setq #loop T)
  (while #loop
    (setq #rr (getreal (strcat "\nＲを入力<" CG_R ">: ")))
    (if (= #rr nil)
      (progn
        (setq #rr CG_R)
        (setq #loop nil)
      )
      (progn
        (if (##RENDhantei #dist$ #iType #rr) ; 奥行きの半分を超えてはいけない
          (progn ; 判定ｸﾘｱｰ
            (setq #rr (rtos #rr)) ; string
            (setq #loop nil)
          )
          (progn
            (setq #loop T)
            (princ "\n値が大きすぎてフィレットできません。")
          )
        );_if
      )
    ); if
  )

  (command "_fillet" "R" #rr)

  ; 色を戻す
  (PCW_ChColWT #wtEn "BYLAYER" nil)

  ;// 既存のワークトップ(前垂れ込み3DSOLID)を削除
  (entdel #wtEn)
  ; 既存底面削除
;;; (##ENTDEL #BG_tei1)
;;; (##ENTDEL #BG_tei2)
  (##ENTDEL #FG_tei1)
  (##ENTDEL #FG_tei2)

  ; WT底面をｺﾋﾟｰして分解
  (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT_tei)) (entget #WT_tei)))
  (command "_explode" (entlast))
  (setq #ss_dum (ssget "P")) ; LINEの集まり
  ; 底面をFillet処理
  (cond
    ((= #x "Right")
      (cond
        ((= #iType 1) ; 両側Rｴﾝﾄﾞ
          (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2を端点に持つ"LINE"のﾘｽﾄを取得
          (setq #arc1  (##FILLET #line$))       ; Filletして"ARC"を取得
          (setq #line$ (##GETLINE #ss_dum #p3))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc1 #ss_dum)
          (ssadd #arc2 #ss_dum)
          ; FG底面作成 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen #x #WT_pt$ #arc1 #arc2 #FG_T #rr))
        )
        ((= #iType 2) ; 左側Rｴﾝﾄﾞ
;;;         (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2を端点に持つ"LINE"のﾘｽﾄを取得
;;;         (setq #arc1  (##FILLET #line$))       ; Filletして"ARC"を取得
          (setq #line$ (##GETLINE #ss_dum #p3))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc2 #ss_dum)
          ; FG底面作成 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen_R2 #WT_pt$ #arc2 #FG_T #rr))
        )
        ((= #iType 3) ; 右側Rｴﾝﾄﾞ
          (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2を端点に持つ"LINE"のﾘｽﾄを取得
          (setq #arc1  (##FILLET #line$))       ; Filletして"ARC"を取得
;;;         (setq #line$ (##GETLINE #ss_dum #p3))
;;;         (setq #arc2  (##FILLET #line$))
          ; FG底面作成 01/07/10 YM ADD
          (ssadd #arc1 #ss_dum)
          (setq #FG0 (KPMakeFGTeimen_R3 #WT_pt$ #arc1 #FG_T #rr))
        )
      );_cond
    )
    ((= #x "Left")
      (cond
        ((= #iType 1) ; 両側Rｴﾝﾄﾞ
          (setq #line$ (##GETLINE #ss_dum #p1))
          (setq #arc1  (##FILLET #line$))
          (setq #line$ (##GETLINE #ss_dum #last))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc1 #ss_dum)
          (ssadd #arc2 #ss_dum)
          ; FG底面作成 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen #x #WT_pt$ #arc1 #arc2 #FG_T #rr))
        )
        ((= #iType 2) ; 左側Rｴﾝﾄﾞ
          (setq #line$ (##GETLINE #ss_dum #p1))
          (setq #arc1  (##FILLET #line$))
;;;         (setq #line$ (##GETLINE #ss_dum #last))
;;;         (setq #arc2  (##FILLET #line$))
          ; FG底面作成 01/07/10 YM ADD
          (ssadd #arc1 #ss_dum)
          (setq #FG0 (KPMakeFGTeimen_L2 #WT_pt$ #arc1 #FG_T #rr))
        )
        ((= #iType 3) ; 右側Rｴﾝﾄﾞ
;;;         (setq #line$ (##GETLINE #ss_dum #p1))
;;;         (setq #arc1  (##FILLET #line$))
          (setq #line$ (##GETLINE #ss_dum #last))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc2 #ss_dum)
          ; FG底面作成 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen_L3 #WT_pt$ #arc2 #FG_T #rr))
        )
      );_cond
    )
  );_cond

;;; ; Filletによって作成された"ARC"を追加する-->pedit
;;; (ssadd #arc1 #ss_dum)
;;; (ssadd #arc2 #ss_dum)

  (setq #delobj (getvar "delobj")) ; extrude後の底面を保持する  "delobj"=0
  (setvar "delobj" 1)              ; extrude後の底面を保持しない"delobj"=1

  ; Pedit ﾎﾟﾘﾗｲﾝ化 WT 再作成
  (command "_pedit" (ssname #ss_dum 0) "Y" "J" #ss_dum "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了

  (setq #WT_region (Make_Region2 (entlast)))
  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))

;;; BG_SOLID再作成
;;; #BG_tei1
;;; #BG_tei2
  (setq #BG_SOLID1 nil #BG_SOLID2 nil)
  (if (and #BG_tei1 (/= #BG_tei1 ""))
    (progn
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG_tei1)) (entget #BG_tei1))) ; SOLID画層にする-->押し出し用
      (setq #BG (entlast)) ; extrude用
      (setq #BG_region (Make_Region2 #BG))
      (setq #BG_SOLID1 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
    )
  );_if

  (if (and #BG_tei2 (/= #BG_tei2 ""))
    (progn
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG_tei2)) (entget #BG_tei2))) ; SOLID画層にする-->押し出し用
      (setq #BG (entlast)) ; extrude用
      (setq #BG_region (Make_Region2 #BG))
      (setq #BG_SOLID2 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
    )
  );_if

  ; FG_SOLID再作成
  (if #FG0
    (progn
      (setq #FG_region (Make_Region2 #FG0))
      (setq #FG_SOLID  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if

  (setvar "delobj" #delobj) ; システム変数を戻す

  (setq #ss (ssadd))
  (ssadd #WT_SOLID #ss)
  (if #BG_SOLID1 (ssadd #BG_SOLID1 #ss)) ; BG_SOLIDを追加
  (if #BG_SOLID2 (ssadd #BG_SOLID2 #ss)) ; BG_SOLIDを追加
  (if #FG_SOLID  (ssadd #FG_SOLID #ss))  ; FG_SOLIDを追加

  ;BG,WTの和をとる
  (command "_union" #ss "") ; 交わらない領域でもＯＫ！

  ;// 拡張データの再設定 前垂れなし
  (setq #xd_new$
  (list
    (list 51   "");[52]:FG 底面図形ﾊﾝﾄﾞﾙ1
    (list 52   "");[53]:FG 底面図形ﾊﾝﾄﾞﾙ2
  ))
  (CFSetXData #WT_SOLID "G_WRKT"
    (CFModList #xd$ #xd_new$)
  )

  (setq #WTL (nth 47 #xd$)) ; ｶｯﾄ相手WT左
  (setq #WTR (nth 48 #xd$)) ; ｶｯﾄ相手WT右

  ;左側WTの拡張データも更新する
  (if (and (/= #WTL "") (/= #WTL nil))
    (progn
      (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; 左側
      (CFSetXData #WTL "G_WRKT"
        (CFModList #xdL$
          (list
            (list 48 #WT_SOLID)     ;[49]カット相手WTﾊﾝﾄﾞﾙ右 U型は左右にある
          )
        )
      )
    )
  );_if

  ;右側WTの拡張データも更新する
  (if (and (/= #WTR "") (/= #WTR nil))
    (progn
      (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; 右側
      (CFSetXData #WTR "G_WRKT"
        (CFModList
          #xdR$
          (list
            (list 47 #WT_SOLID)     ;[48]カット相手WTﾊﾝﾄﾞﾙ左 U型は左右にある
          )
        )
      )
    )
  );_if

  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)
  (setvar "pdmode" #PD) ; 06/12 YM
  (if #KAIJO
    (princ "\n品番確定が解除されました。")
  );_if

  (setq *error* nil)
  (princ)
|;
;-- 2011/08/09 A.Satoh Mod - E

);C:KPRendWT


;-- 2011/12/17 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <関数名>    : GetNearPoint
;;; <処理概要>  : 点列リストから指定の座標に最も近い座標点を求める
;;; <戻り値>    : 座標点
;;; <作成>      : 11/12/17 A.Satoh
;;; <備考>      : 2Dのみ対応（距離を求める際、Ｚ座標は考慮しない）
;;;*************************************************************************>MOH<
(defun GetNearPoint (
	&point$		; 点列リスト
	&pnt$				; 検索時の指定座標
	/
	#pnt$ #ret$ #wk_dist #idx #dist
	)

	(setq #pnt$ (list (car &pnt$) (cadr &pnt$)))

	(setq #ret$ (car &point$))
	(setq #wk_dist (distance #pnt$ (car &point$)))
	(setq #idx 1)
	(repeat (1- (length &point$))
		(setq #dist (distance #pnt$ (nth #idx &point$)))
		(if (> #wk_dist #dist)
			(progn
				(setq #ret$ (nth #idx &point$))
				(setq #wk_dist #dist)
			)
		)
		(setq #idx (1+ #idx))
	)

	#ret$

) ;GetNearPoint


;<HOM>*************************************************************************
; <関数名>    : KPMakeFGTeimen_WT
; <処理概要>  : FG底面PLINE作成
; <戻り値>    : FG底面図形PLINE
; <作成>      : 11/12/17 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun KPMakeFGTeimen_WT (
	&WT_pt$  ;WT外形点列
	&arc     ; 円弧左上
	&FG_T    ; 前垂れ厚み
	&rr      ; R(円弧の半径)
	&pnt$    ; R加工位置座標
  /
  )

	; 現在画層の変更
	(setq #clayer (getvar "CLAYER"))
	(setvar "CLAYER" SKW_AUTO_SOLID)

	(setq #idx 0)
	(repeat (length &WT_pt$)
		(if (= &pnt$ (nth #idx &WT_pt$))
			(if (= #idx 0)
				(progn
					(setq #p1$ (nth (1- (length &WT_pt$)) &WT_pt$))
					(setq #p2$ (nth 1 &WT_pt$))
				)
				(if (= #idx (1- (length &WT_pt$)))
					(progn
						(setq #p1$ (nth (1- #idx) &WT_pt$))
						(setq #p2$ (nth 0 &WT_pt$))
					)
					(progn
						(setq #p1$ (nth (1- #idx) &WT_pt$))
						(setq #p2$ (nth (1+ #idx) &WT_pt$))
					)
				)
			)
		)
		(setq #idx (1+ #idx))
	)

	(setq #p1   (nth 0 &WT_pt$)) ; WT左上点
	(setq #p2   (nth 1 &WT_pt$)) ; WT右上点
	(setq #p3   (nth 2 &WT_pt$))
	(setq #p4   (nth 3 &WT_pt$))
	(setq #p5   (nth 4 &WT_pt$))
	(setq #last (last  &WT_pt$))

	(setq #ssFG (ssadd))

	; 円弧部分作成
	(entmake (entget &arc))
	(setq #arc (entlast))

	(setq #ofPT (mapcar '+ #p1$ #p2$))
	(setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
	(command "_offset" &FG_T #arc #ofPT "")
	(setq #arc_in (entlast))

  ; 左側Jｶｯﾄ
  ; a1               a2
  ; +----------------+
  ; +a0--------------+　<--内側ARC11_in,外側ARC11
  ; |  "Right"         + +a3
  ; |                  | |
  ; |  a7          a8  + +a4
  ; +---+------------+　<--内側ARC22_in,外側ARC22
  ;     +------------+
  ;    a6            a5

	(setq #a0 (polar #p1 (angle #p2 #p3) &FG_T))
	(setq #a1 #p1)
	(setq #a2 #p2)
	(setq #a3 #p2)
	(setq #a4 (polar #p3 (angle #p3 #p2) (atof &rr)))
	(setq #a5 (polar #p3 (angle #p2 #p1) (atof &rr)))
	(setq #a6 #p4)
	(setq #a7 (polar #a6 (angle #p3 #p2) &FG_T))

	(setq #a2_in (polar #p2    (angle #p2 #p1) &FG_T))
	(command "._line" #a2 #a2_in "")
	(setq #line1 (entlast))

	(command "._line" #a3 #a4 "")
	(setq #line2 (entlast))

	(command "_offset" &FG_T #line2 #ofPT "")
	(setq #line2_in (entlast))

	(command "._line" #a5 #a6 "")
	(setq #line3 (entlast))
	(command "_offset" &FG_T #line3 #ofPT "")
	(setq #line3_in (entlast))

	(command "._line" #a6 #a7 "")
	(setq #line4 (entlast))

	(command "._line" #a1 #a0 "")
	(setq #line5 (entlast))

	(ssadd #arc #ssFG)
	(ssadd #arc_in #ssFG)

	(ssadd #line1 #ssFG)
	(ssadd #line2 #ssFG)
	(ssadd #line2_in #ssFG)
	(ssadd #line3 #ssFG)
	(ssadd #line3_in #ssFG)
	(ssadd #line4 #ssFG)
	(ssadd #line5 #ssFG)

	(command "_pedit" #arc "Y" "J" #ssFG "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
	(setq #fg0 (entlast))

	; 現在画層を戻す
	(setvar "CLAYER" #clayer)

	#fg0

) ;KPMakeFGTeimen_WT
;-- 2011/12/17 A.Satoh Add - E


;;;<HOM>*************************************************************************
;;; <関数名>    : C:KPCutWKTOP
;;; <処理概要>  : ワークトップの切り欠きを行う
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 01/08/17 YM
;;; <備考>      : 切り欠く部分のSOLIDはﾕｰｻﾞｰが作成したPLINEを押し出す
;;;*************************************************************************>MOH<
(defun C:KPCutWKTOP (
  /
  #EREC #ESOLID #ITYPE #LOOP #OBJ #REC$ #SCECOLOR #STYPE #TCLOSE #WTEN #XD$
;-- 2011/09/07 A.Satoh Add - S
  #wt_xd$
;-- 2011/09/07 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPCutWKTOP ////")
  (CFOutStateLog 1 1 " ")
  ;// コマンドの初期化
  (StartUndoErr)

	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)

  ;// ワークトップの指示
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\nワークトップを選択: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "ワークトップではありません。")
      (setq #loop nil)
    );_if

  );while

  ;// ビューを登録
  (command "_view" "S" "TEMP_WTCUT")
  (command "vpoint" "0,0,1")

  ; 図形色番号の変更
  (setq #sCECOLOR (getvar "CECOLOR"))

  (if (CFGetXData #wtEn "G_WTSET")
    (setvar "CECOLOR" CG_WorkTopCol)
    (setvar "CECOLOR" "7")
  );_if

  ; 対象領域図形の種類を選択
  (princ "\n切り欠き範囲の指定: ")
  (initget "1 2")
  (setq #sType (getkword "\n矩形(1)/領域(2)<1>: "))
  (if (= nil #sType)
    (setq #sType "1")
  )
  (setq #iType (atoi #sType))
  ; 押出し領域の作成
  (if (< 0 #iType)
    (progn
      ; 領域選択・作図
      (setq #Rec$ (CFDrawRectOrRegionTransUcs #iType))
      (setq #eRec (entlast))
      ; 70番が1かどうか(閉じているか)
      (setq #tClose (cdr (assoc 70 (entget #eRec))))
      (if (= #tClose 1)
        (progn
          (setq #obj (getvar "delobj"))
          (setvar "delobj" 1) ; 0 オブジェクトは保持されます。
          ;2008/07/28 YM MOD 2009対応
;-- 2011/06/23 A.Satoh - S
          (command "_.extrude" #eRec "" 3000) ; 閉じたPLINEをZ方向に押し出し
;         (command "_.extrude" #eRec "" 3000 "") ; 閉じたPLINEをZ方向に押し出し
;-- 2011/06/23 A.Satoh - E
;;;         (command "_.extrude" #eRec "" 3000 "") ; 閉じたPLINEをZ方向に押し出し
          (setq #eSOLID (entlast)) ; SOLID 図形名
          (command "_subtract" #wtEn "" #eSOLID "") ;差演算
          (setvar "delobj" #obj) ; 0 アイテムは保持されます

;--2011/09/07 A.Satoh Add - S
          (setq #wt_xd$ (CFGetXData #wtEn "G_WTSET"))
          (if (/= #wt_xd$ nil)
            (CFSetXData #wtEn "G_WTSET" (CFModList #wt_xd$ (list (list 0 0))))
          )
          (CFSetXData #wtEn "G_WRKT" (CFModList #xd$ (list (list 58 "TOKU"))))
;--2011/09/07 A.Satoh Add - E
        )
        (progn
          (CFAlertMsg "\n閉じたポリラインを作成して下さい。")
          (quit)
        )
      );_if
    )
  )

  ;// ビューを戻す
  (command "_view" "R" "TEMP_WTCUT")

  ; システム変数を元に戻す
  (setvar "CECOLOR" #sCECOLOR)

  (setq *error* nil)
  (princ)
);C:KPCutWKTOP

;;;<HOM>*************************************************************************
;;; <関数名>    : C:BG_FG_ADD
;;; <処理概要>  : ★BG_前垂れ追加コマンド
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 11/09/27 A.Satoh
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun C:BG_FG_ADD (
  /
  #err_flg #SNAPMODE #GRIDMODE #ORTHOMODE #OSMODE
  #ssWT #loop #wtEn #xd$ #syori #iHEIGH #iTHIN
  #list$ #msg #inp_flg
  )

;-- 2012/03/01 A.Satoh Add - S
	;****************************************************
	; エラー処理
	;****************************************************
  (defun BG_FG_ADDUndoErr( &msg )
    (command "_undo" "b")
    (CFCmdDefFinish)
    (setq *error* nil)
    (princ)
  )
	;****************************************************
;-- 2012/03/01 A.Satoh Add - E

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:BG_FG_ADD ////")
  (CFOutStateLog 1 1 " ")

	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)

;-- 2012/03/01 A.Satoh Del - S
;;;;;  ; コマンドの初期化
;;;;;  (StartUndoErr)
;-- 2012/03/01 A.Satoh Del - E

;-- 2012/03/01 A.Satoh Add - S
  (setq *error* BG_FG_ADDUndoErr)
;-- 2012/03/01 A.Satoh Add - E
  (setq #err_flg nil)
  (setq #inp_flg nil)
  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)
;-- 2012/03/01 A.Satoh Add - S
  (command "_undo" "M")
  (command "_undo" "a" "off")
  (CFCmdDefBegin 6)
;-- 2012/03/01 A.Satoh Add - E

  (setq #ssWT (ssget "X" '((-3 ("G_WRKT")))))
  (if (or (= nil #ssWT)(= 0 (sslength #ssWT)))
    (progn
      (CFAlertMsg "\n図面上にワークトップがありません。")
      (setq #err_flg T)
    )
  )

  (if (= #err_flg nil)
    (progn
      ; ワークトップの指示
      (setq #loop T)
      (while #loop
        (setq #wtEn (car (entsel "\nワークトップを選択: ")))
        (if #wtEn
          (setq #xd$ (CFGetXData #wten "G_WRKT"))
          (setq #xd$ nil)
        )

        (if (= #xd$ nil)
          (CFAlertMsg "ワークトップではありません。")
          (setq #loop nil)
        )
      )

      ; BG/前垂れ選択ダイアログ処理
      (setq #syori (BG_FG_ADD_Dlg))
      (if (/= #syori nil)
        (progn
          (if (= #syori 1)
            (progn
              (setq #iHEIGH (nth 12 #xd$)) ; SOLID押し出し高さ
              (setq #iTHIN (nth 13 #xd$))  ; SOLID厚み
            )
            (progn
              (setq #iHEIGH (- 0 (nth 15 #xd$))) ; SOLID押し出し高さ
              (setq #iTHIN (nth 16 #xd$))              ; SOLID厚み
            )
          )

          (if (or (equal #iHEIGH 0 0.01) (equal #iTHIN 0 0.01))
            (progn
              (setq #list$ (BG_FG_ADD_InputDlg #syori #iHEIGH #iTHIN))
              (if (= #list$ nil)
                (progn
                  (if (= #syori 1)
                    (setq #msg "ﾊﾞｯｸｶﾞｰﾄﾞの高さ、厚みが設定されていません。\n処理をｷｬﾝｾﾙします。")
                    (setq #msg "前垂れの高さ、厚みが設定されていません。\n処理をｷｬﾝｾﾙします。")
                  )
                  (CFAlertMsg #msg)
                  (setq #err_flg T)
                )
                (progn
                  (setq #iHEIGH (nth 0 #list$)) ; SOLID押し出し高さ
                  (setq #iTHIN  (nth 1 #list$)) ; SOLID厚み
                  (setq #inp_flg T)
                )
              )
            )
          )
;;;;;          (BG_FG_ADD_MakeBGinsertSUB #wtEn #syori #iHEIGH #iTHIN)
        )
      )
    )
  )

  (if (= #err_flg nil)
    (progn
      (BG_FG_ADD_MakeBGinsertSUB #wtEn #syori #iHEIGH #iTHIN)
      (if (= #inp_flg T)
        (if (= #syori 1)
          (CFSetXData #wtEn "G_WRKT"
            (CFModList #xd$
              (list
                (list 12 (* #iHEIGH 1.0))
                (list 13 (* #iTHIN 1.0))
              )
            )
          )
          (CFSetXData #wtEn "G_WRKT"
            (CFModList #xd$
              (list
                (list 15 (* #iHEIGH 1.0))
                (list 16 (* #iTHIN 1.0))
              )
            )
          )
        )
      )
    )
  )

;-- 2012/03/01 A.Satoh Add - S
	(CFCmdDefFinish)
;-- 2012/03/01 A.Satoh Add - E
  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)

  (setq *error* nil)

;  (alert "★★★　工事中　★★★")
  (princ)
) ;C:BG_FG_ADD

;-- 2011/09/27 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <関数名>    : BG_FG_ADD_Dlg
;;; <処理概要>  : BG/前垂れ選択ダイアログ処理
;;; <引数>      : なし
;;; <戻り値>    : 1:バックガード 2:前垂れ nil:キャンセル
;;; <作成>      : 11/09/27 A.Satoh
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun BG_FG_ADD_Dlg (
  /
  #dcl_id #ret
  )

;***************************************************************
  (defun ##GetItemData (
    /
    #err_flg #syori #bg #fg
    )

    (setq #err_flg nil)
    (setq #syori nil)

    (setq #bg (get_tile "radBG"))
    (setq #fg (get_tile "radFG"))

    ; 入力チェック
    (if (and (= #bg "0") (= #fg "0"))
      (progn
        (alert "ﾊﾞｯｸｶﾞｰﾄﾞ/前垂れが選択されていません。")
        (setq #err_flg T)
      )
    )

    (if (= #err_flg nil)
      (progn
        (if (= #bg "1")
          (setq #syori 1)
          (setq #syori 2)
        )

        (done_dialog)
      )
    )

    #syori

  ) ; ##GetItemData
;***************************************************************

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))

  (if (= nil (new_dialog "BG_FG_Dlg" #dcl_id)) (exit))

  (action_tile "accept" "(setq #ret (##GetItemData))")
  (action_tile "cancel" "(setq #ret nil)(done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)

  #ret

) ;BG_FG_ADD_Dlg


;;;<HOM>*************************************************************************
;;; <関数名>    : BG_FG_ADD_InputDlg
;;; <処理概要>  : BG/前垂れ 高さ・厚さ入力ダイアログ処理
;;; <引数>      : &syori : 1:ﾊﾞｯｸｶﾞｰﾄﾞ 2:前垂れ
;;;             : &iHEIGH: SOLID押し出し高さ
;;;             : &iTHIN : SOLID厚み
;;; <戻り値>    : 入力値リスト or nil
;;; <作成>      : 11/09/30 A.Satoh
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun BG_FG_ADD_InputDlg (
  &syori   ; 1:ﾊﾞｯｸｶﾞｰﾄﾞ 2:前垂れ
  &iHEIGH  ; SOLID押し出し高さ
  &iTHIN   ; SOLID厚み
  /
  #dcl_id #list$
  )

;***************************************************************
  (defun ##GetItemData (
    /
    #err_flg #ret$ #iHEIGH_STR #iHEIGH #iTHIN_STR #iTHIN
    )

    (setq #err_flg nil)

    (setq #iHEIGH_STR (get_tile "height"))
    (setq #iTHIN_STR  (get_tile "width"))

    ; 入力チェック
    (if (or (= #iHEIGH_STR "") (= #iHEIGH_STR nil))
      (progn
        (alert "高さが入力されていません")
        (mode_tile "height" 2)
        (setq #err_flg T)
      )
      (if (= (type (read #iHEIGH_STR)) 'INT)
        (progn
          (setq #iHEIGH (read #iHEIGH_STR))
          (if (<= #iHEIGH 0)
            (progn
              (alert "1以上の整数値を入力して下さい")
              (mode_tile "height" 2)
              (setq #err_flg T)
            )
          )
        )
        (progn
          (alert "整数値を入力して下さい")
          (mode_tile "height" 2)
          (setq #err_flg T)
        )
      )
    )

    (if (= #err_flg nil)
      (if (or (= #iTHIN_STR "") (= #iTHIN_STR nil))
        (progn
          (alert "厚みが入力されていません")
          (mode_tile "width" 2)
          (setq #err_flg T)
        )
        (if (= (type (read #iTHIN_STR)) 'INT)
          (progn
            (setq #iTHIN (read #iTHIN_STR))
            (if (<= #iTHIN 0)
              (progn
                (alert "1以上の整数値を入力して下さい")
                (mode_tile "width" 2)
                (setq #err_flg T)
              )
            )
          )
          (progn
            (alert "整数値を入力して下さい")
            (mode_tile "width" 2)
            (setq #err_flg T)
          )
        )
      )
    )

    (if (= #err_flg nil)
      (progn
        (setq #ret$ (list #iHEIGH #iTHIN))
        (done_dialog)
      )
    )

    #ret$

  ) ; ##GetItemData
;***************************************************************

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (= nil (new_dialog "BG_FG_InputDlg" #dcl_id)) (exit))

  (if (= &syori 1)
    (set_tile "lab" "ﾊﾞｯｸｶﾞｰﾄﾞ 高さ/厚み入力")
    (set_tile "lab" "前垂れ 高さ/厚み入力")
  )
  (set_tile "height" (rtos &iHEIGH))
  (set_tile "width"  (rtos &iTHIN))

  (action_tile "accept" "(setq #list$ (##GetItemData))")
  (action_tile "cancel" "(setq #list$ nil)(done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)

  #list$

) ;BG_FG_ADD_InputDlg


;;;<HOM>*************************************************************************
;;; <関数名>    : BG_FG_ADD_MakeBGinsertSUB
;;; <処理概要>  : BG,FG作成＆挿入＆WTとUNION
;;; <引数>      : &wtEn   : ワークトップ図形名
;;;             : &syori  : 作成コード 1:ﾊﾞｯｸｶﾞｰﾄﾞ 2:前垂れ
;;;             : &iHIGH  : SOLID押し出し高さ
;;;             : &iTHIN  : SOLID厚み
;;; <戻り値>    : なし
;;; <作成>      : 11/09/27 A.Satoh
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun BG_FG_ADD_MakeBGinsertSUB (
  &wtEn      ; ワークトップ図形名
  &syori     ; 作成コード 1:ﾊﾞｯｸｶﾞｰﾄﾞ 2:前垂れ
  &iHIGH     ; SOLID押し出し高さ
  &iTHIN     ; SOLID厚み
  /
  #xd_WRKT$ #height #wt_h #tei_pt$ #clayer #sCECOLOR
  #pt$$ #en$ #pt1$ #dST_PT #dEN_PT #pt_en
  #loop #ofP #ofP2 #ePL #midP #ePL2 #pt2$ 
  #bg_pt$ #bg_en #obj #eBG_SOLID #dINS_PT #dBpt #ss
  )

  ; ワークトップ底面図形点列を求める
  (setq #xd_WRKT$ (CFGetXData &wtEn "G_WRKT"))
  (setq #height (nth 8 #xd_WRKT$))
  (setq #wt_h (nth 10 #xd_WRKT$))
  (setq #tei_pt$ (GetPtSeries (nth 32 #xd_WRKT$) (GetLWPolyLinePt (nth 38 #xd_WRKT$))))
;-- 2011/11/21 A.Satoh Add - S
	(setq #tei_pt$ (append #tei_pt$ (list (nth 0 #tei_pt$))))
;-- 2011/11/21 A.Satoh Add - E

  ; 現在画層を取得
  (setq #clayer (getvar "CLAYER"))

  ; 引数画層(なければ作成)を現在画層にしてそれ以外をﾌﾘｰｽﾞ 色番号1-255,線種
  (KPSetClayerOtherFreeze SKW_AUTO_SOLID 1 SKW_AUTO_LAY_LINE)

  ; 図形色番号の変更
  (setq #sCECOLOR (getvar "CECOLOR"))

  (if (CFGetXData &wtEn "G_WTSET")
    (setvar "CECOLOR" CG_WorkTopCol)
    (setvar "CECOLOR" "7")
  )

  (setvar "OSMODE" 1) ; 端点

  ; ﾊﾞｯｸｶﾞｰﾄﾞ/前垂れ追加位置の指定
  ; （点列指定）
  (setq #pt$$ (BG_FG_ADD_DrawPline #height &iTHIN))
  (setq #en$ (car #pt$$))
  (setq #pt1$ (cadr #pt$$))
  (setq #dST_PT (car #pt1$))
  (setq #dEN_PT (last #pt1$))

  (setvar "OSMODE"    0)

; 試験用暫定処理
  ; 内側方向は自動で算出する
  (command "vpoint" "0,0,1")
  (command "zoom" "0.8x")
  (setq #loop T)
  (while #loop
    (setq #ofP (getpoint "\n設置する内側方向を指示 :"))
    (if (= (JudgeNaigai #ofP #tei_pt$) nil)
      (CFAlertMsg "ワークトップの内側を指示して下さい。")
      (progn
        (mapcar 'entdel #en$)
        (setq #loop nil)
      )
    )
  )

  (if (not (equal &iTHIN 0 0.01))
    (progn
      (setq #ePL (MakeLwPolyLine #pt1$ 0 #height))

      ; オフセット量がマイナス値の場合、オフセット点をポリラインの外に出す
      (if (> 0 &iTHIN)
        (progn
          (setq #midP (inters #ofP
            (pcpolar #ofP (+ (* 0.5 pi) (angle (car #pt1$)(cadr #pt1$))) 100)
            (car #pt1$)(cadr #pt1$) nil)
          )
          (setq #ofP2 (pcpolar #midP (angle #ofP #midP) (distance #ofP #midP)))
        )
        (setq #ofP2 (list (car #ofP)(cadr #ofP)))
      )

      (command "_offset" (abs &iTHIN) #ePL #ofP2 "")
      (setq #ePL2 (entlast))
      (setq #pt2$ (GetLWPolyLinePt #ePL2))
      (setq #pt2$ (reverse #pt2$))
      (entdel #ePL)
      (entdel #ePL2)
      (setq #pt1$ (append #pt1$ #pt2$))
    )
  )
  (command "zoom" "p")
  (command "zoom" "p")

  (setq #bg_pt$ nil)
  (foreach #pt #pt1$
    (setq #bg_pt$
      (append #bg_pt$ (list (list (car #pt) (cadr #pt) #height)))
    )
  )

  (setq #bg_en (MakeTEIMEN #bg_pt$)) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面

  (setq #obj (getvar "delobj"))
  (setvar "delobj" 1) ; 0 オブジェクトは保持されます

  ; BG_SOLID作成
;-- 2012/03/01 A.Satoh Mod - S
;;;;;  (command "_.extrude" #bg_en "" &iHIGH) ; 閉じたPLINEをZ方向に押し出し
  (if (= (vl-cmdf "_.extrude" #bg_en "" &iHIGH) nil) ; 閉じたPLINEをZ方向に押し出し
		(progn
			(vl-cmdf)
			(exit)
		)
	)
;-- 2012/03/01 A.Satoh Mod - E
  (setq #eBG_SOLID (entlast)) ; SOLID 図形名

  ; SOLID 移動
  (setq #dINS_PT (car #bg_pt$))
  (setq #dBpt (list (nth 0 #dST_PT) (nth 1 #dST_PT) (+ #height #wt_h)))
  (command "._MOVE" #eBG_SOLID "" #dINS_PT #dBpt)

  ; WTとBGのUNIONをとる
  (setq #ss (ssadd))
  (ssadd &wtEn #ss)
  (ssadd #eBG_SOLID #ss)
  (command "_union" #ss "") ; 交わらない領域でもＯＫ！

  (setvar "delobj" #obj) ; 0 アイテムは保持されます

  ; 表示画層の設定(元に戻す)
  (SetLayer)
  (setvar "CLAYER" #clayer) ; 現在画層を戻す

  ; システム変数を元に戻す
  (setvar "CECOLOR" #sCECOLOR)

);BG_FG_ADD_MakeBGinsertSUB

;<HOM>*************************************************************************
; <関数名>    : BG_FG_ADD_DrawPline
; <処理概要>  : 連続する線を作図させその端点のリストを取得する
; <戻り値>    : 作成した点列リスト
; <作成>      : 11/09/27 A.Satoh
; <備考>      :
;*************************************************************************>MOH<
(defun BG_FG_ADD_DrawPline (
  &height       ; ＷＴ取り付け高さ
  &defoD        ; デフォルトのオフセット量(BG厚み又はFG厚み)
  /
  #loop #p1 #pt$ #p2 #en$ #os #ret$
  )

  (setq #loop T)
  (setq #p1 (getpoint (strcat "\n始点: ")))
  (setq #pt$ (list #p1))
  (while (= T #loop)
    (if (/= nil #p1) ; Cなしモード
      (progn
        (initget 128 "-a 1a 2a 3a 4a 5a 6a 7a 8a 9a U")
        (setq #p2 (getpoint #p1 (strcat "\n次点 /U=戻す/: ")))
        (if (and (= 'STR (type #p2)) (numberp (read #p2)))
          (progn
            (initget "U")
            (setq #p2 (getpoint #p1 (strcat "\n次点 /U=戻す/: ")))
          )
        )
      )
    )

    (cond
      ((= nil #p2)
        (setq #loop nil)
      )
      ((= "U" #p2)
        (setq #p1 (trans (cdr (assoc 10 (entget (car #en$)))) 0 1))
        (entdel (car #en$))
        (setq #en$ (cdr #en$))
        (setq #pt$ (cdr #pt$))
      )
      (T
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

  (setq #pt$ (reverse #pt$))

  (setq #ret$ nil)
  (foreach #pt #pt$
    (setq #ret$
      (append #ret$ (list (list (car #pt) (cadr #pt))))
    )
  )

  (list #en$ #ret$)

); BG_FG_ADD_DrawPline
;-- 2011/09/27 A.Satoh Add - E

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KP_MakeBGinsert
;;; <処理概要>  : BG作成＆挿入＆WTとUNION
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 01/09/10 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KP_MakeBGinsert (
  /

  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KP_MakeBGinsert ////")
  (CFOutStateLog 1 1 " ")
  ;// コマンドの初期化
  (StartUndoErr)
  ; BG高さ=50 BG厚み=20mm
  (KP_MakeBGinsertSUB 1 CG_BG_H CG_BG_T) ; BG基点が底面の左上

  (setq *error* nil)
  (princ)
);C:KP_MakeBGinsert

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KP_MakeFGinsert
;;; <処理概要>  : FG作成＆挿入＆WTとUNION
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 01/09/10 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:KP_MakeFGinsert (
  /

  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KP_MakeFGinsert ////")
  (CFOutStateLog 1 1 " ")
  ;// コマンドの初期化
  (StartUndoErr)
  ; 前垂れ高さ-WT厚み=40-19=21 前垂れ厚み=20mm
  (KP_MakeBGinsertSUB 2 (- CG_FG_H CG_WT_T) CG_FG_T) ; FG基点が上面の左上

  (setq *error* nil)
  (princ)
);C:KP_MakeFGinsert

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_MakeBGinsertSUB
;;; <処理概要>  : BG作成＆挿入＆WTとUNION
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 01/08/30 YM
;;; <備考>      : BG長さ入力-->BG_SOLID作成-->ﾕｰｻﾞｰ挿入-->WTとUNION
;;; <修正>        FG配置ｺﾏﾝﾄﾞにも使用,操作簡略化
;;;*************************************************************************>MOH<
(defun KP_MakeBGinsertSUB (
  &tflg  ; 挿入時の基点 1:左上(底面), 2:左上(上面)
  &iHIGH ; SOLID押し出し高さ
  &iTHIN ; SOLID厚み
  /
  #BG_EN #CLAYER #EBG_SOLID #GRIDMODE #ITYPE #LOOP #OBJ #ORTHOMODE #OSMODE #P1 #P2 #P3 #P4
  #RLEN #SCECOLOR #SNAPMODE #SS #SSWT #WTEN #XD$ #LPT #DEN_PT #DST_PT
#DINS_PT
  )

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)

  (setq #ssWT (ssget "X" '((-3 ("G_WRKT")))))
  (if (or (= nil #ssWT)(= 0 (sslength #ssWT)))
    (progn
      (CFAlertMsg "\n図面上にワークトップがありません。")
      (quit)
    )
  );_if

  ;// ワークトップの指示
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\nワークトップを選択: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "ワークトップではありません。")
      (setq #loop nil)
    );_if

  );while

  (setq #clayer (getvar "CLAYER")); 現在画層
  ; 引数画層(なければ作成)を現在画層にしてそれ以外をﾌﾘｰｽﾞ 色番号1-255,線種
  (KPSetClayerOtherFreeze SKW_AUTO_SOLID 1 SKW_AUTO_LAY_LINE)

  ; 図形色番号の変更
  (setq #sCECOLOR (getvar "CECOLOR"))

  (if (CFGetXData #wtEn "G_WTSET")
    (setvar "CECOLOR" CG_WorkTopCol)
    (setvar "CECOLOR" "7")
  );_if

  (setvar "OSMODE"    1) ; 端点

  ; 01/09/10 YM MOD-S
  (setq #dST_PT (getpoint "\n1点目(左端)を指示: "))
  (setq #dEN_PT (getpoint "\n2点目(右端)を指示: "))
  (setq #rLEN (distance #dST_PT #dEN_PT))
  ; 左上(底面)基点(固定) --- BG
  ; 左上(上面)基点(固定) --- 前垂れ
  (setq #iType &tflg)
  ; 01/09/10 YM MOD-E

;;;01/09/06YM@MOD (setq #rLEN (getreal "\nﾊﾞｯｸｶﾞｰﾄﾞの長さを入力: "))
;;;01/09/10YM@MOD ; 01/09/06 YM MOD-S
;;;01/09/10YM@MOD (setq #rLEN (getdist "\nﾊﾞｯｸｶﾞｰﾄﾞの長さを入力または2点指示: "))
;;;01/09/10YM@MOD ; 01/09/06 YM MOD-E
;;;01/09/10YM@MOD
;;;01/09/10YM@MOD ; ﾊﾞｯｸｶﾞｰﾄﾞの基点を入力
;;;01/09/10YM@MOD (setq #loop T)
;;;01/09/10YM@MOD (while #loop
;;;01/09/10YM@MOD   (setq #iType (getint "\nﾊﾞｯｸｶﾞｰﾄﾞの基点 /1=左上/2=右上/3=右下/4=左下/ <左上>:  "))
;;;01/09/10YM@MOD   (if (= #iType nil)
;;;01/09/10YM@MOD     (progn
;;;01/09/10YM@MOD       (setq #iType 1)
;;;01/09/10YM@MOD       (setq #loop nil)
;;;01/09/10YM@MOD     )
;;;01/09/10YM@MOD     (progn
;;;01/09/10YM@MOD       (if (or (= #iType 1)(= #iType 2)(= #iType 3)(= #iType 4))
;;;01/09/10YM@MOD         (setq #loop nil)
;;;01/09/10YM@MOD         (setq #loop T)
;;;01/09/10YM@MOD       );_if
;;;01/09/10YM@MOD     )
;;;01/09/10YM@MOD   ); if
;;;01/09/10YM@MOD )

  (setvar "OSMODE"    0) ; 01/9/10 YM ADD OSNAP 解除

  (setq #p1 (list 0     0))
  (setq #p2 (list #rLEN 0))
  (setq #p3 (list #rLEN (- &iTHIN)))
  (setq #p4 (list 0     (- &iTHIN)))
  (setq #bg_en (MakeTEIMEN (list #p1 #p2 #p3 #p4))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面

  (setq #obj (getvar "delobj"))
  (setvar "delobj" 1) ; 0 オブジェクトは保持されます
  ; BG_SOLID作成
  ;2008/07/28 YM MOD 2009対応
  (command "_.extrude" #bg_en "" &iHIGH "") ; 閉じたPLINEをZ方向に押し出し
;;;  (command "_.extrude" #bg_en "" &iHIGH "") ; 閉じたPLINEをZ方向に押し出し
  (setq #eBG_SOLID (entlast)) ; SOLID 図形名
  ; SOLID 移動

;;;01/09/10YM@MOD (princ "\n挿入点: ") ; 01/08/31 YM ADD

  ; 01/09/10 YM MOD-S
  (cond
    ((= #iType 1)(setq #dINS_PT #p1))
    ((= #iType 2)(setq #dINS_PT (list 0 0 &iHIGH)))
  );_cond
  (command "._MOVE" #eBG_SOLID "" #dINS_PT #dST_PT)
  ; 01/09/10 YM MOD-E

;;;01/09/10YM@MOD (cond
;;;01/09/10YM@MOD   ((= #iType 1)(command ".MOVE" #eBG_SOLID "" #p1 PAUSE))
;;;01/09/10YM@MOD   ((= #iType 2)(command ".MOVE" #eBG_SOLID "" #p2 PAUSE))
;;;01/09/10YM@MOD   ((= #iType 3)(command ".MOVE" #eBG_SOLID "" #p3 PAUSE))
;;;01/09/10YM@MOD   ((= #iType 4)(command ".MOVE" #eBG_SOLID "" #p4 PAUSE))
;;;01/09/10YM@MOD );_cond

;;;01/09/10YM@MOD (setq #lpt (getvar "LASTPOINT"))
;;;01/09/10YM@MOD (princ "\n配置角度: ") ; 01/08/31 YM ADD
;;;01/09/10YM@MOD (command ".ROTATE" #eBG_SOLID "" #lpt PAUSE)

  (command ".ROTATE" #eBG_SOLID "" #dST_PT #dEN_PT)

  ; 01/09/10 YM ADD-S 前垂れの場合、BG高さ+WT厚み分下に下げる
;;; (command ".MOVE" &ss "" "0,0,0" (list 0 0 (- (caddr #bpt) (caddr #lpt))))

  ; 01/09/10 YM ADD-E 前垂れの場合、BG高さ+WT厚み分下に下げる

  ; WTとBGのUNIONをとる
  (setq #ss (ssadd))
  (ssadd #wtEn #ss)
  (ssadd #eBG_SOLID #ss)
  (command "_union" #ss "") ; 交わらない領域でもＯＫ！
  (setvar "delobj" #obj) ; 0 アイテムは保持されます

  ; 表示画層の設定(元に戻す)
  (SetLayer)
  (setvar "CLAYER" #clayer) ; 現在画層を戻す

  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)

  ; システム変数を元に戻す
  (setvar "CECOLOR" #sCECOLOR)

  (setq *error* nil)
  (princ)
);KP_MakeBGinsertSUB


;;;<HOM>*************************************************************************
;;; <関数名>    : C:SetWkTop
;;; <処理概要>  : ﾜｰｸﾄｯﾌﾟの品番を確定する
;;; <戻り値>    :
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:SetWkTop (
  /
  #WT #LOOP #XD$ #WTL #WTLL #WTR #WTRR #XDWTL$ #XDWTR$
;-- 2011/08/26 A.Satoh Add - S
  #wk_xd$
;-- 2011/08/26 A.Satoh Add - E
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:SetWkTop ////")
  (CFOutStateLog 1 1 " ")
  ;// コマンドの初期化
  (StartUndoErr)
  (CFCmdDefBegin 0); 01/07/02 YM ADD
  (CFNoSnapReset)

	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)

; 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn

;-- 2011/08/26 A.Satoh Mod - S
;  ;// ワークトップの指示
;  (initget 0)
;  (setq #loop T)
;  (while #loop
;    (setq #WT (car (entsel "\nワークトップを選択: ")))
;    (if #WT
;      (setq #xd$ (CFGetXData #WT "G_WRKT"))
;      (setq #xd$ nil)
;    );_if
;
;    (cond
;      ((= #xd$ nil)
;        (CFAlertMsg "ワークトップではありません。")
;      )
;;;;01/08/20YM@      ((CFGetXData #WT "G_WTSET")
;;;;01/08/20YM@        (CFAlertMsg "ワークトップは既に品番確定されています。")
;;;;01/08/20YM@      )
;      (T
;        (setq #loop nil)
;      )
;    )
;  )
  ;// ワークトップの指示
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #WT (car (entsel "\nワークトップを選択: ")))
    (if #WT
      (setq #xd$ (CFGetXData #WT "G_WRKT"))
      (setq #xd$ nil)
    );_if

    (if (/= #xd$ nil)
      (progn
        (setq #wk_xd$ (CFGetXData #WT "G_WTSET"))
        (if (/= #wk_xd$ nil)
          (if (= (nth 0 #wk_xd$) 0)
            (progn  ; 特注品である場合
              (PCW_ChColWT #WT "MAGENTA" nil)
              (setq #loop nil)
            )
            (progn  ; 規格品である場合
              (CFAlertMsg "指定したワークトップは規格品であり、品番が確定されています。")
              (exit)
            )
          )
          (setq #loop nil)
        )
      )
      (progn
        (CFAlertMsg "ワークトップではありません。")
      )
    )
  )
;-- 2011/08/26 A.Satoh Mod - E

;;; (command "vpoint" "0,0,1")

  ;// 品番確定処理 プラン検索以外
;-- 2011/09/01 A.Satoh Mod - S
;  (KPW_DesideWorkTop_FREE #WT)
  (setq #data$ (KPW_DesideWorkTop_FREE #WT))
;-- 2011/09/01 A.Satoh Mod - S

;;; ; 隣接ｷｬﾋﾞも品番確定
;;; (setq #WTL (nth 47 #xd$)) ; WTL
;;; (setq #WTR (nth 48 #xd$)) ; WTR
;;; (if (and #WTL (/= #WTL "")(= nil (CFGetXData #WTL "G_WTSET")))
;;;   (progn ; 左にあれば
;;;     (setq #xdWTL$ (CFGetXData #WTL "G_WRKT"))
;;;     (KPW_DesideWorkTop3 2 #WTL)
;;;     (setq #WTLL (nth 47 #xdWTL$)) ; WTLL
;;;     (if (and #WTLL (/= #WTLL ""))(KPW_DesideWorkTop3 2 #WTLL))
;;;   )
;;; );_if
;;; (if (and #WTR (/= #WTR "")(= nil (CFGetXData #WTR "G_WTSET")))
;;;   (progn ; 右にあれば
;;;     (setq #xdWTR$ (CFGetXData #WTR "G_WRKT"))
;;;     (KPW_DesideWorkTop3 2 #WTR)
;;;     (setq #WTRR (nth 48 #xdWTR$)) ; WTRR
;;;     (if (and #WTRR (/= #WTRR ""))(KPW_DesideWorkTop3 2 #WTRR))
;;;   )
;;; );_if

;;; (command "zoom" "p")

;-- 2011/09/01 A.Satoh Mod - S
;  (princ "\nワークトップの品番を確定しました。")
  (if (/= #data$ nil)
    (princ "\nワークトップの品番を確定しました。")
  )
;-- 2011/09/01 A.Satoh Mod - E
  ); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
);_if

  (CFNoSnapFinish)
  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)

);C:SetWkTop


;;; <HOM>***********************************************************************************
;;; <関数名>    : KPW_DesideWorkTop3
;;; <処理概要>  : ワークトップの品番確定(woodone) プラン検索用
;;; <戻り値>    :
;;; <作成>      : 08/06/25 YM
;;; <備考>      : 
;;; ***********************************************************************************>MOH<
(defun KPW_DesideWorkTop3 (
  &eWTP ; 処理の対象ワークトップ図形名
  /
  #BG1 #BG2 #CHECK #DB_NAME #DIM$ #EGAS$ #EGAS_P5$ #ESNK$ #ESNK_P$ #ESNK_P1$ #ESNK_P4$$ #GAS$$
  #LIST$$ #PD #PDSIZE #QRY$ #QRY$$ #RET$ #SNK$$ #SNKCAB$ #WRKT$ #WTSET$ #WT_HABA #WT_HINBAN
  #WT_HINMEI #WT_OKUYUKI #WT_PRI #WT_TAKASA #ZAICODE #ZAIF
	#CG_TOKU_HINBAN ;2018/07/27 YM ADD
  )
  (setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "PDSIZE" 10)
  (setvar "pdmode" 34)
  (command "vpoint" "0,0,1")

  ; ワークトップの拡張データを変数に取得
  (setq #WRKT$ (CFGetXData &eWTP "G_WRKT"))
  (setq #ZaiCode (nth 2 #WRKT$))
  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ

  ; ワークトップ領域にあるシンク、水栓、ガスコンロを全て検索しておく
  (setq #ret$ (PKW_GetWorkTopAreaSym3 &eWTP)); 引数 = 処理の対象ワークトップ図形名
  (setq #SNK$$  (nth 0 #ret$))
  (setq #GAS$$  (nth 1 #ret$))
;;; 変数へ代入<ｼﾝｸ>
  (foreach #SNK$ #SNK$$
    (setq #eSNK$    (append #eSNK$    (list (nth 0 #SNK$)))) ; ｼﾝｸｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
    (setq #SNKCAB$  (append #SNKCAB$  (list (nth 1 #SNK$)))) ; ｼﾝｸｷｬﾋﾞｼﾝﾎﾞﾙﾘｽﾄ
    (setq #eSNK_P4$$ (append #eSNK_P4$$ (list (nth 3 #SNK$)))) ; ｼﾝｸPMEN4ｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
  )

  (setq #eSNK$    (NilDel_List #eSNK$    ))
  (setq #SNKCAB$  (NilDel_List #SNKCAB$  ))
  (setq #eSNK_P1$ (NilDel_List #eSNK_P1$ ))
  (setq #eSNK_P4$$ (NilDel_List #eSNK_P4$$ ))

  ; 各ｼﾝｸの材質に応じたｼﾝｸ穴領域のﾘｽﾄを返す(ｼﾝｸ複数対応)
  ;ｼﾝｸ穴領域の属性をみて判断
  (setq #eSNK_P$ (KPGetSinkANA #eSNK_P4$$ #ZaiF)) ; 各ｼﾝｸ毎のPMEN4ﾘｽﾄのﾘｽﾄ

;;; 変数へ代入<ｺﾝﾛ>
  (foreach #GAS$ #GAS$$
    (setq #eGAS$    (append #eGAS$    (list (nth 0 #GAS$)))) ; ｺﾝﾛﾘｽﾄ(nil)含む
    (setq #eGAS_P5$ (append #eGAS_P5$ (list (nth 2 #GAS$)))) ; ｺﾝﾛPMEN5ｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
  )
  (setq #eGAS$    (NilDel_List #eGAS$    ))
  (setq #eGAS_P5$ (NilDel_List #eGAS_P5$ ))

  ; ﾜｰｸﾄｯﾌﾟ穴情報を求める &eWTP
  (if (= (nth 3 #WRKT$) 1) ; 1:L型
    (setq #dim$ (PKGetANAdim-L2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; L形状の場合
    (setq #dim$ (PKGetANAdim-I2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; I形状の場合
  );_if

  ;;; ワークトップの品番取得
  (setq #LIST$$
    (list
      (list "材質記号"       (nth 16 CG_GLOBAL$) 'STR)
      (list "形状"           (nth  5 CG_GLOBAL$) 'STR)
      (list "シンク記号"     (nth 17 CG_GLOBAL$) 'STR)
      (list "シンク側間口"   (nth  4 CG_GLOBAL$) 'STR)
      (list "奥行き"         (nth  7 CG_GLOBAL$) 'STR)
      (list "シンク位置"     (nth  2 CG_GLOBAL$) 'STR)
      (list "コンロ位置"     (nth  9 CG_GLOBAL$) 'STR)
      (list "LR区分"         (nth 11 CG_GLOBAL$) 'STR)
    )
  )
  (setq #DB_NAME "天板価格")

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$)
  )

  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #qry$ (car #qry$$))
      (setq #WT_HINBAN  (nth 1 #qry$))   ; 品番
      (setq #WT_PRI     (nth 2 #qry$))   ; 金額
      (setq #WT_HABA    (nth 3 #qry$))   ; 巾
      (setq #WT_TAKASA  (nth 4 #qry$))   ; 高さ
      (setq #WT_OKUYUKI (nth 5 #qry$))   ; 奥行
      (setq #WT_HINMEI  (nth 6 #qry$))   ; 品名
    )
    (progn ;HITしない若しくは複数
      (setq #WT_HINBAN  "ERROR")   ; 品番
      (setq #WT_PRI           0)   ; 金額
      (setq #WT_HABA        "0")   ; 巾
      (setq #WT_TAKASA      "0")   ; 高さ
      (setq #WT_OKUYUKI     "0")   ; 奥行
      (setq #WT_HINMEI  "ERROR")   ; 品名
    )
  );_if


  ; 獲得されたフラグ、品番、価格、コード（寸法）を拡張データに格納
  (if (= (tblsearch "APPID" "G_WTSET") nil) (regapp "G_WTSET"))

  (setq #WTSET$
    (list
      1              ; G_WTSET 特注フラグ (0:特注,1:規格)
      #WT_HINBAN     ; G_WTSET 品番
      (nth 8 #WRKT$) ; G_WTSET 取付け高さ(ここだけWT図形情報からとる)
      #WT_PRI        ; G_WTSET 金額(実数)
      #WT_HINMEI     ; 品名
      #WT_HABA       ; 巾
      #WT_TAKASA     ; 高さ
      #WT_OKUYUKI    ; 奥行
      ""             ; 予備1
      ""             ; 予備2
      ""             ; 予備3
    )
  )

  ; 穴寸法追加(可変)
  (setq #WTSET$ (append #WTSET$ (list (length #dim$)))) ; WT穴情報寸法数列個数
  (foreach #dim #dim$
    (setq #WTSET$ (append #WTSET$ (list #dim))) ; 穴寸法
  )

  (CFSetXData &eWTP "G_WTSET" #WTSET$)
  ; ワークトップの色を確定色に変える（拡張データを確認の上）
  (if (CFGetXData &eWTP "G_WTSET")
    (progn
      (command "_.change" &eWTP "" "P" "C" CG_WorkTopCol "")
      ;;; BG,FGも一緒に色替えする
      (setq #BG1 (nth 49 #WRKT$))
      (setq #BG2 (nth 50 #WRKT$))
      (if (/= #BG1 "")
        (progn
          (if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
            (command "_.change" #BG1 "" "P" "C" CG_WorkTopCol "")
          )
        )
      );_if
      (if (/= #BG2 "")
        (progn
          (if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
            (command "_.change" #BG2 "" "P" "C" CG_WorkTopCol "")
          )
        )
      );_if
    )
    (progn
      (command "_.change" &eWTP "" "P" "C" "BYLAYER" "")
    )
  );_if

  ; 内容表示(実際に現ワークトップに入った値)
  ; 2006/09/15 T.Ari MOD 確認画面の設定値を天板に設定するように変更
  (if (< 1 &nFLG) 
    (progn
      (setq #CHECK (PKY_ShowWTSET_Dlog #WRKT$ (CFGetXData &eWTP "G_WTSET")))
      (setq #WTSET$ (CFModList (CFGetXData &eWTP "G_WTSET") (list (list 1 (nth 0 #CHECK)) (list 3 (nth 1 #CHECK)))))
      (CFSetXData &eWTP "G_WTSET" #WTSET$)
    )
  )
;-- 2011/10/29 A.Satoh Add - S
      (CFSetXData &eWTP "G_WRKT" (CFModList (CFGetXData &eWTP "G_WRKT") (list (list 35 (nth  2 CG_GLOBAL$)))))
;-- 2011/10/29 A.Satoh Add - E
  ;;; ｼﾝｸ、ｺﾝﾛ、水栓穴あけ処置
  (PKW_MakeHoleWorkTop2 &eWTP #eSNK_P$ #eGAS_P5$) ; #eSNK_P$ #eGAS_P5$ (nil)有り得る

  (command "zoom" "p")
  (setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)
  (princ)
);KPW_DesideWorkTop3

;;; <HOM>***********************************************************************************
;;; <関数名>    : KPW_DesideWorkTop_FREE
;;; <処理概要>  : ワークトップの品番確定(woodone) プラン検索以外用
;;; <戻り値>    :
;;; <作成>      : 2010/01/07 YM ADD
;;; <備考>      : 
;;; ***********************************************************************************>MOH<
(defun KPW_DesideWorkTop_FREE (
  &eWTP ; 処理の対象ワークトップ図形名
  /
;-- 2011/09/14 A.Satoh Mod - S
;  #BG1 #BG2 #CHECK #DIM$ #EGAS$ #EGAS_P5$ #ESNK$ #ESNK_P$ #ESNK_P1$ #ESNK_P4$$
;  #GAS$$ #PD #PDSIZE #QRY$ #QRY$$ #RET$ #SNK$$ #SNKCAB$ #WRKT$ #WTSET$ #WT_HABA
;  #WT_HINBAN #WT_HINMEI #WT_OKUYUKI #WT_PRI #WT_TAKASA #ZAICODE #ZAIF
;;-- 2011/06/23 A.Satoh Add - S
;  #TYPE #WTLR #WTL #WTR #SINK #MAGUCHI #OKU #len$ #dep$ #SINK_ITI #HINBAN #TOKU_FLG
;;-- 2011/06/23 A.Satoh Add - E
;;-- 2011/08/26 A.Satoh Add - S
;  #syori_flg #tori_height #SetXd$ #WTSET2$
;  #toku_f
;  #baseP #tei #WTpt$ #GASpt$ #p1 #p2 #p3 #p4 #p5 #p6 #distGas
;;-- 2011/08/26 A.Satoh Add - E
  #PD #pdsize #WRKT$ #tori_height #syori_flg #WTSET2$ #hinban_dat$
  #ZaiCode #ZaiF #TYPE #WTLR #WTL #WTR #len$ #dep$ #keijo #ret$ #toku_f
  #SNK$ #SNK$$ #eSNK$ #SNKCAB$ #eSNK_P1$ #eSNK_P4$$ #eSNK_P$
  #GAS$ #GAS$$ #eGAS$ #eGAS_P5$ #baseP #tei #WTpt$ #GASpt$
  #p1 #p2 #p3 #p4 #p5 #p6 #distGas #SINK #sink$ #SINK_ITI
  #qry$$ #qry$ #MAGUCHI #OKU #LIST$$ #TOKU_FLG #WT_HINBAN #WT_PRI #WT_HABA
  #WT_TAKASA #WT_OKUYUKI #WT_HINMEI #SetXd$ #BG1 #BG2 #WTSET$ #dim #dim$
  #CutDirect #cut1 #cut2 #cut$$ #cut$

#GAS_ANA #GAS_PMEN5 #IH_NUM #LAYER #MSG #QRY_CUT$$ #QRY_SNK$$ #SQL #XDPMEN$ ;2014/12/04 YM ADD
;-- 2011/09/14 A.Satoh Mod - S
;-- 2011/09/30 A.Satoh Add - S
  #distSink
;-- 2011/09/30 A.Satoh Add - E
#wt_type$ #dan_f #dan_LR ;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応
#eGASCAB$ ;2017/01/14
  )
  (setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "PDSIZE" 10)
  (setvar "pdmode" 34)
  (command "vpoint" "0,0,1")

  ; ワークトップの拡張データを変数に取得
  (setq #WRKT$ (CFGetXData &eWTP "G_WRKT"))
;-- 2011/08/26 A.Satoh Add - S
  (setq #tori_height (nth 8 #WRKT$))
  (setq #syori_flg nil)
  (setq #WTSET2$ (CFGetXData &eWTP "G_WTSET"))
  (if (= #WTSET2$ nil)
    (setq #syori_flg T)
  )

  (if (= #syori_flg nil)
    (progn
      (setq #hinban_dat$
        (list
          (nth 0 #WTSET2$)         ; 特注フラグ
          (nth 1 #WTSET2$)         ; 品番
          (rtos (nth 3 #WTSET2$))  ; 金額
          (nth 5 #WTSET2$)         ; 巾
          (nth 6 #WTSET2$)         ; 高さ
          (nth 7 #WTSET2$)         ; 奥行
          (nth 4 #WTSET2$)         ; 品名
          (nth 8 #WTSET2$)         ; 特注コード
        )
      )
    )
    (progn
;-- 2011/08/26 A.Satoh Add - E
  (setq #ZaiCode (nth 2 #WRKT$))
  (princ "\n★★★　材質= ")(princ #ZaiCode)

  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
;-- 2011/06/23 A.Satoh Add - S
  (setq #TYPE (nth  3 #WRKT$)) ; 形状ﾀｲﾌﾟ
  (setq #WTLR (nth 30 #WRKT$)) ; 左右勝手
  (princ "\n★★★　左右勝手= ")(princ #WTLR)
  (setq #WTL  (nth 47 #WRKT$)) ; WTハンドル左
  (setq #WTR  (nth 48 #WRKT$)) ; WTハンドル右
  (setq #len$ (nth 55 #WRKT$)) ; WTの幅リスト
  (setq #dep$ (nth 57 #WRKT$)) ; WTの奥行リスト
;-- 2011/09/19 A.Satoh Add - S
  (setq #CutDirect (nth  9 #WRKT$)) ; カット方向
  (if (and (/= (nth 60 #WRKT$) nil) (/= (nth 60 #WRKT$) ""))
    (setq #cut1  (handent (nth 60 #WRKT$)))
    (setq #cut1 "")
  )
  (if (and (/= (nth 61 #WRKT$) nil) (/= (nth 61 #WRKT$) ""))
    (setq #cut2  (handent (nth 61 #WRKT$)))
    (setq #cut2 "")
  )
;-- 2011/09/19 A.Satoh Add - E

  ; 形状を取得する
  (setq #keijo (WKP_GetWorkTop_KEIJO #TYPE #dep$ #len$))
  (princ "\n★★★　形状= ")(princ #keijo)
;-- 2011/06/23 A.Satoh Add - E

  ; ワークトップ領域にあるシンク、水栓、ガスコンロを全て検索しておく
  (setq #ret$ (PKW_GetWorkTopAreaSym3 &eWTP)); 引数 = 処理の対象ワークトップ図形名
  (setq #SNK$$  (nth 0 #ret$))
  (setq #GAS$$  (nth 1 #ret$)); 小間口コンロなしのとき(nil , ｶﾞｽｷｬﾋﾞ図形 , nil)

;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - S
			(setq #toku_f nil)
;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - E
;-- 2011/08/29 A.Satoh Add - S
      (if (= (nth 58 #WRKT$) "TOKU")
        (progn
          (setq #toku_f T)
          (princ "\n★★★　天板に既に特注の目印あり")
        )
        (progn
          (setq #toku_f nil)
        )
      )

;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - S
			(setq #dan_f nil)
			(if (= #toku_f nil)
				(if (and (= #WTLR "Z") (= #TYPE 0) (= (length #SNK$$) 1) (= (length #GAS$$) 0))
					(progn
						(princ "\n★★★　段落ち確認ダイアログ処理を行う")
						; 段落ち確認ダイアログ処理を行う
						(setq #wt_type$ (KPW_CheckDanotiWorkTopDlg))
						(if (= #wt_type$ nil)
							(progn
								; 品番確定処理を終了する
								(exit)
							)
							(progn
								(setq #dan_f (nth 0 #wt_type$))
								(setq #dan_LR (nth 1 #wt_type$))
							)
						)
					)
				)
			)

			(if (= #dan_f nil)
				(progn
;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - E
      (if (= #toku_f nil)

;2012/05/25 YM MOD-S
				(cond
					((= (length #SNK$$) 0)
            (setq #toku_f T)
            (princ "\n★★★　ｼﾝｸなし特注")
				 	)
					((= (length #SNK$$) 1)
            (princ "\n★★★　ｼﾝｸ1つ")
				 	)
					(T
            (setq #toku_f T)
            (princ "\n★★★　ｼﾝｸ複数特注")
				 	)
				);_cond

;;;        (if (/= (length #SNK$$) 1);(list #enSNK #enSNKCAB #snkPen1$ #snkPen4$)
;;;          (progn
;;;            (setq #toku_f T)
;;;            (princ "\n★★★　ｼﾝｸ複数特注")
;;;          )
;;;          ;else
;;;          (if (= nil (nth 0 (car #SNK$$)))
;;;            (progn
;;;              (setq #toku_f T)
;;;              (princ "\n★★★　ｼﾝｸなし特注")
;;;            )
;;;          );_if
;;;        );_if
;2012/05/25 YM MOD-E

      );_if


      (if (= #toku_f nil)

;2012/05/25 YM MOD-S
				(cond
					((= (length #GAS$$) 0)
            (setq #toku_f T)
            (princ "\n★★★　GASなし特注")
				 	)
					((= (length #GAS$$) 1)
            (princ "\n★★★　GAS1つ") ;小間口ｼﾝｸのみはｶﾞｽｷｬﾋﾞがあるので(nil 図形 nil) GAS1つ と判断される
				 	)
					(T
            (setq #toku_f T)
            (princ "\n★★★　GAS複数特注")
				 	)
				);_cond

;;;        (if (/= (length #GAS$$) 1);(list #enGAS #enGASCAB #GasPen5)
;;;          (progn
;;;            (setq #toku_f T)
;;;            (princ "\n★★★　GAS複数特注")
;;;          )
;;;          ;else
;;;          (progn
;;;            (if (= nil (nth 0 (car #GAS$$)))
;;;              (progn
;;;                (setq #toku_f T)
;;;                (princ "\n★★★　GASなし特注")
;;;              )
;;;            );_if
;;;          )
;;;        );_if
;2012/05/25 YM MOD-E

      );_if
;-- 2011/08/29 A.Satoh Add - E
;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - S
				)
			)
;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - E

;;; 変数へ代入<ｼﾝｸ>
  (foreach #SNK$ #SNK$$
    (setq #eSNK$     (append #eSNK$     (list (nth 0 #SNK$)))) ; ｼﾝｸｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
    (setq #SNKCAB$   (append #SNKCAB$   (list (nth 1 #SNK$)))) ; ｼﾝｸｷｬﾋﾞｼﾝﾎﾞﾙﾘｽﾄ
    (setq #eSNK_P4$$ (append #eSNK_P4$$ (list (nth 3 #SNK$)))) ; ｼﾝｸPMEN4ｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
  )

  (setq #eSNK$     (NilDel_List #eSNK$    ))
  (setq #SNKCAB$   (NilDel_List #SNKCAB$  ))
  (setq #eSNK_P1$  (NilDel_List #eSNK_P1$ ))
  (setq #eSNK_P4$$ (NilDel_List #eSNK_P4$$ ))

  ; 各ｼﾝｸの材質に応じたｼﾝｸ穴領域のﾘｽﾄを返す(ｼﾝｸ複数対応)
  ;ｼﾝｸ穴領域の属性をみて判断
  (setq #eSNK_P$ (KPGetSinkANA #eSNK_P4$$ #ZaiF)) ; 各ｼﾝｸ毎のPMEN4ﾘｽﾄのﾘｽﾄ

;-- 2011/09/30 A.Satoh Add - S
  ; シンク脇寸法を求める
;  (if (/= nil (nth 0 (car #SNK$$)))
  (if (/= nil #eSNK_P$)
    (progn
;-- 2012/05/18 A.Satoh Mod 段落ち天板品番確定対応 - S
;;;;;      (setq #distSink (KPW_GetDispSink #WRKT$ (car #eSNK_P$)))
;;;;;      (if (/= #type 2)
;;;;;        (if (< #distSink 75.0)
;;;;;          (progn
;;;;;            (CFAlertMsg "ｼﾝｸ脇が75mm以上無い為、天板の製作ができません。")
;;;;;            (exit)
;;;;;          )
;;;;;        )
;;;;;				)
;;;;;      )
      (setq #distSink (KPW_GetDispSink #WRKT$ (car #eSNK_P$) #dan_f #dan_LR))
      (if (/= #type 2)
				(if (< #distSink 75.0)
					(if (not (equal (- 75.0 #distSink) 0 0.0001))
						(progn
							(CFAlertMsg "ｼﾝｸ脇が75mm以上無い為、天板の製作ができません。")
							(exit)
						)
					)
				)
      )
;-- 2012/05/18 A.Satoh Mod 段落ち天板品番確定対応 - E
    )
  )
;-- 2011/09/30 A.Satoh Add - E

;;; 変数へ代入<ｺﾝﾛ>
	(setq #eGAS$    nil)
	(setq #eGASCAB$ nil) 
	(setq #eGAS_P5$ nil)

  (foreach #GAS$ #GAS$$
    (setq #eGAS$    (append #eGAS$    (list (nth 0 #GAS$)))) ; ｺﾝﾛﾘｽﾄ(nil)含む
		;2017/01/13 YM ADD #eGASCAB$ 追加 小間口はｶﾞｽｷｬﾋﾞあり
    (setq #eGASCAB$ (append #eGASCAB$ (list (nth 1 #GAS$)))) ; ｶﾞｽｷｬﾋﾞ
    (setq #eGAS_P5$ (append #eGAS_P5$ (list (nth 2 #GAS$)))) ; ｺﾝﾛPMEN5ｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
  )
  (setq #eGAS$    (NilDel_List #eGAS$    ))
  (setq #eGAS_P5$ (NilDel_List #eGAS_P5$ ))

  ; ﾜｰｸﾄｯﾌﾟ穴情報を求める &eWTP
;-- 2011/09/01 A.Satoh Mod - S
;  (if (= (nth 3 #WRKT$) 1) ; 1:L型
;    (setq #dim$ (PKGetANAdim-L2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; L形状の場合
;    (setq #dim$ (PKGetANAdim-I2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; I形状の場合
;  );_if
	(setq #dim$ nil)
	(if (and #eSNK_P$ #eGAS_P5$)
		(progn ;2014/11/29 YM ADD nil対策
			(princ "\n★★★　ｼﾝｸあり、ｶﾞｽあり")

		  (cond
		    ((= (nth 3 #WRKT$) 1) ; 1:L型
					(princ "\n★★★　L型穴寸法計測")
		      (setq #dim$ (PKGetANAdim-L2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; L形状の場合
		    )
		    ((= (nth 3 #WRKT$) 2) ; 2:U型
					(princ "\n★★★　U型穴寸法計測")
		      (setq #dim$ (PKGetANAdim-U2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; U形状の場合
		    )
		    (T    ; 上記以外(0:I型)
					(princ "\n★★★　I型穴寸法計測")
		      (setq #dim$ (PKGetANAdim-I2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; I形状の場合
		    )
		  );cond
		)
		(progn ;シンクかコンロがない

			;2017/01/13 YM MOD-S  小間口ｼﾝｸのみとそれ以外を分岐
			(if (and #eGASCAB$ (= nil #eGAS_P5$) (= nil #eGAS$))
				(progn ;小間口ｼﾝｸのみ I型想定
					(princ "\n★★★　小間口ｼﾝｸのみで通る(穴寸法計測)")
					(setq #dim$ (PKGetANAdim-I1 &eWTP #WRKT$ #eSNK_P$)) ; I形状ｼﾝｸのみの場合を想定
				)
				(progn ;特注
					(setq #dim$ nil)
					(setq #toku_f T)
					(princ "\n★★★　GAS or SINKなし特注")
				)
			);_if

		)
	);_if

			(princ "\n★★★　穴寸法= ")(princ #dim$)

;-- 2011/09/01 A.Satoh Mod - E

;-- 2011/08/30 A.Satoh Add - S
      (if (= #toku_f nil)
        (progn
;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - S
					(if (= #dan_f nil)
						(progn
;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - E
          ;;; コンロ脇寸法を求める
		          (setq #baseP (nth 32 #WRKT$)) ; WT左上点
		          (setq #tei (nth 38 #WRKT$))   ; WT底面図形ﾊﾝﾄﾞﾙ
		          (setq #WTpt$ (GetLWPolyLinePt #tei))
		          (setq #WTpt$ (GetPtSeries #BaseP #WTpt$)) ; WT底面座標点列を時計周りに
							(if #eGAS_P5$ ;2012/0810 YM ADD ｶﾞｽなしのときnil
		          	(setq #GASpt$ (GetLWPolyLinePt (car #eGAS_P5$))) ; ｺﾝﾛ外形点列
								(setq #GASpt$ nil)
							);_if

		          (cond
		            ((= #TYPE 0)  ; I型
		              (setq #p1 (nth 0 #WTpt$))
		              (setq #p2 (nth 1 #WTpt$))
		              (setq #p3 (nth 2 #WTpt$))
		              (setq #p4 (last  #WTpt$))

		              ; コンロ脇寸法の算出
		              (cond
		                ((= #WTLR "R") ; 右勝手のとき
											(if #GASpt$ ;2012/0810 YM ADD ｶﾞｽなしのときnil
												(progn
				                  (setq #distGas (GetDistLineToPline (list #p1 #p4) #GASpt$))
				                  (princ "\n★★★　実際のGAS脇= ")(princ #distGas)
												)
												;else
												(progn
													(setq #distGas 0)(princ "\n★★★　GASなし(GAS脇=0)")
												)
											);_if
		                )
		                ((= #WTLR "L") ; 左勝手のとき
											(if #GASpt$ ;2012/0810 YM ADD ｶﾞｽなしのときnil
												(progn
				                  (setq #distGas (GetDistLineToPline (list #p2 #p3) #GASpt$))
				                  (princ "\n★★★　実際のGAS脇= ")(princ #distGas)
												)
												;else
												(progn
													(setq #distGas 0)(princ "\n★★★　GASなし(GAS脇=0)")
												)
											);_if
		                )
		                (T ; それ以外
											(if #GASpt$ ;2012/0810 YM ADD ｶﾞｽなしのときnil
												(progn
				                  (setq #distGas (GetDistLineToPline (list #p1 #p4) #GASpt$))
				                  (princ "\n★★★　実際のGAS脇= ")(princ #distGas)
												)
												;else
												(progn
													(setq #distGas 0)(princ "\n★★★　GASなし(GAS脇=0)")
												)
											);_if
		                )
		              );_cond

              ; コンロ脇寸法が150mm以外であれば特注
              ;2011/09/15 YM MOD "/="を使うと10のﾏｲﾅｽ13乗の誤差で誤判定するのでequal 誤差許容=0.001に修正
;;; 2011/09/20YM              (if (equal #distGas 150.0 0.001)
;;; 2011/09/20YM                nil
;;; 2011/09/20YM                ;else
;;; 2011/09/20YM                (progn
;;; 2011/09/20YM                  (setq #toku_f T)
;;; 2011/09/20YM                  (princ "\n★★★　GAS脇150以外特注")
;;; 2011/09/20YM                )
;;; 2011/09/20YM              );_if
            )
            ((= #TYPE 1)  ; L型
              (setq #p1 (nth 0 #WTpt$))
              (setq #p2 (nth 1 #WTpt$))
              (setq #p3 (nth 2 #WTpt$))
              (setq #p4 (nth 3 #WTpt$))
              (setq #p5 (nth 4 #WTpt$))
              (setq #p6 (nth 5 #WTpt$))

              ; コンロ脇寸法の算出
              (cond
                ((= #WTLR "R") ; 右勝手のとき
                  (setq #distGas (GetDistLineToPline (list #p5 #p6) #GASpt$))
                  (princ "\n★★★　実際のGAS脇= ")(princ #distGas)
                )
                ((= #WTLR "L") ; 左勝手のとき
                  (setq #distGas (GetDistLineToPline (list #p2 #p3) #GASpt$))
                  (princ "\n★★★　実際のGAS脇= ")(princ #distGas)
                )
                (T ; それ以外
                  (setq #distGas (GetDistLineToPline (list #p5 #p6) #GASpt$))
                  (princ "\n★★★　実際のGAS脇= ")(princ #distGas)
                )
              )

              ; コンロ脇寸法が150mm以外であれば特注
;;; 2011/09/20YM              (if (equal #distGas 150.0 0.001)
;;; 2011/09/20YM                (progn
;;; 2011/09/20YM                  (setq #toku_f T)
;;; 2011/09/20YM                  (princ "\n★★★　GAS脇150以外特注")
;;; 2011/09/20YM                )
;;; 2011/09/20YM              )
            )
            (T            ; その他(U型)
              (setq #toku_f T)
              (princ "\n★★★　U型特注")
            )
          )
;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - S
						)
            (setq #distGas nil)
					)
;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - E
        )
      )

			;2018/07/27 YM ADD-S
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
			;2018/07/27 YM ADD-E


      (if (= #toku_f nil)
        (progn
;-- 2011/08/30 A.Satoh Add - E
;-- 2011/09/14 A.Satoh Mod - S
;-- 2011/06/29 A.Satoh Add - S
;  ; シンク記号を求める
;  (setq #SINK (WKP_GetWorkTop_SINK_KIGO #eSNK$ #eGAS_P5$))
;  (if (= #SINK nil)
;    (setq #SINK "")
;  )
;
;  ; シンク側間口を求める
;  (if #len$
;    (setq #MAGUCHI (strcat "W" (substr (itoa (fix (+ (car  #len$) 0.01))) 1 3)))
;    (setq #MAGUCHI "?")
;  )
;
;  ; 奥行きを求める
;  (if #dep$
;    (setq #OKU (strcat "D" (itoa (fix (+ (car #dep$) 0.01)))))
;    (setq #OKU "?")
;  )
;
;  ; シンク位置を求める
;  (setq #SINK_ITI (WKP_GetWorkTop_SINK_ITI #WRKT$ (car #eSNK_P$)))
;  (if (= #SINK_ITI nil)
;    (setq #SINK_ITI "")
;  )
;
;-- 2011/06/29 A.Satoh Add - E
;
;  ;;; ワークトップの品番取得
;  (setq #QRY$$ nil)
          ; シンク記号を求める
          (setq #SINK (WKP_GetWorkTop_SINK_KIGO #eSNK$ #eGAS_P5$))
          (if (= #SINK nil)
            (setq #SINK "?")
          )
          (princ "\n★★★　シンク記号= ")(princ #SINK)

          ; シンク側間口を求める
          (if #len$
            (progn
              (setq #qry$$
                (CFGetDBSQLRec CG_DBSESSION "間口"
                  (list
                    (list "間口" (itoa (fix (+ (car  #len$) 0.01))) 'INT)
                  )
                )
              )
              (if (and #qry$$ (= 1 (length #qry$$)))
                (progn
                  (setq #qry$ (nth 0 #qry$$))
                  (setq #MAGUCHI (nth 1 #qry$))
                )
                (setq #MAGUCHI "?")
              )
            )
            (setq #MAGUCHI "?")
          )
          (princ "\n★★★　シンク側間口= ")(princ #MAGUCHI)

          ; 奥行きを求める
          (if #dep$
            (progn
              (setq #qry$$
                (CFGetDBSQLRec CG_DBSESSION "奥行"
                  (list
                    (list "奥行" (itoa (fix (+ (car  #dep$) 0.01))) 'INT)
                  )
                )
              )
              (if (and #qry$$ (= 1 (length #qry$$)))
                (progn
                  (setq #qry$ (nth 0 #qry$$))
                  (setq #OKU (nth 1 #qry$))
                )
                (setq #OKU "?")
              )
            )
            (setq #OKU "?")
          )
          (princ "\n★★★　奥行き= ")(princ #OKU)

          (setq #sink$ (list #MAGUCHI #keijo #OKU #SINK #distGas))

          ; シンク位置を求める
;-- 2011/09/30 A.Satoh Mod - S
;;;;;          (setq #SINK_ITI (WKP_GetWorkTop_SINK_ITI #WRKT$ (car #eSNK_P$) #sink$ #ZaiF))
;-- 2012/05/17 A.Satoh Mod 段落ち天板品番確定対応 - S
;;;;;          (setq #SINK_ITI (WKP_GetWorkTop_SINK_ITI #distSink #sink$ #ZaiF))
          (setq #SINK_ITI (WKP_GetWorkTop_SINK_ITI #distSink #sink$ #ZaiF #dan_f))
;-- 2012/05/17 A.Satoh Mod 段落ち天板品番確定対応 - E
;-- 2011/09/30 A.Satoh Mod - E
;-- 2011/09/14 A.Satoh Mod - E

;2011/09/16 YM ADD-S
          (setq #qry_SNK$$
            (CFGetDBSQLRec CG_DBSESSION "WTシンク"
              (list
                (list "シンク記号" #SINK 'STR)
              )
            )
          )
					;2012/08/02 YM ADD-S ｼﾝｸがないと品番確定できない
					(if #qry_SNK$$
	          ;【天板価格】検索用のｼﾝｸ記号に変換する. "H_105"などでは検索できない
	          (setq #SINK (nth 10 (car #qry_SNK$$)))
						;else
						(setq #SINK "?");ｼﾝｸなし(不明)
					);_if
					;2012/08/02 YM ADD-E ｼﾝｸがないと品番確定できない

;2011/09/16 YM ADD-E

;-- 2011/06/23 A.Satoh - S
;-- 2012/05/18 A.Satoh Mod 段落ち天板品番確定対応 - S
;;;;;  (setq #LIST$$
;;;;;    (list
;;;;;      (list "材質記号"       #ZaiCode 'STR)
;;;;;      (list "形状"           #keijo 'STR)
;;;;;      (list "シンク記号"     #SINK 'STR)
;;;;;      (list "シンク側間口"   #MAGUCHI 'STR)
;;;;;      (list "奥行き"         #OKU 'STR)
;;;;;      (list "シンク位置"     #SINK_ITI 'STR)
;;;;;      (list "コンロ位置"     "S" 'STR)
;;;;;      (list "LR区分"         #WTLR 'STR)
;;;;;    )
;;;;;  )

	;2014/05/13 YM ADD-S
	(setq #GAS_ANA "S")
	(if #eGAS_P5$ ;ｶﾞｽｺﾝﾛあり
		(progn
			(setq #GAS_PMEN5 (car #eGAS_P5$))
      (setq #xdPMEN$ (CFGetXData #GAS_PMEN5 "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
      (if (and #xdPMEN$ (= 5 (car #xdPMEN$)))
				(progn
        	(setq #IH_NUM (nth 1 #xdPMEN$));海外製IHは天板ｶﾞｽ穴開口が異なる
					(if (= #IH_NUM 492)
						(setq #GAS_ANA "G")
						;else
						(setq #GAS_ANA "S")
					);_if
				)
      );_if
		)
		(progn
			(setq #GAS_ANA "S")
		)
	);_if
	;2014/05/13 YM ADD-E

	(if (= #dan_f T)
		(setq #LIST$$
			(list
				(list "材質記号"       #ZaiCode 'STR)
				(list "形状"           #keijo 'STR)
				(list "シンク記号"     #SINK 'STR)
				(list "シンク側間口"   #MAGUCHI 'STR)
				(list "奥行き"         #OKU 'STR)
				(list "シンク位置"     #SINK_ITI 'STR)
				(list "コンロ位置"     #GAS_ANA 'STR)
				(list "LR区分"         #dan_LR 'STR)
			)
		)
		(setq #LIST$$
			(list
				(list "材質記号"       #ZaiCode 'STR)
				(list "形状"           #keijo 'STR)
				(list "シンク記号"     #SINK 'STR)
				(list "シンク側間口"   #MAGUCHI 'STR)
				(list "奥行き"         #OKU 'STR)
				(list "シンク位置"     #SINK_ITI 'STR)
				(list "コンロ位置"     #GAS_ANA 'STR)
				(list "LR区分"         #WTLR 'STR)
			)
		)
	)
;-- 2012/05/18 A.Satoh Mod 段落ち天板品番確定対応 - E

  (setq #QRY$$
    (CFGetDBSQLRec CG_DBSESSION "天板価格" #LIST$$)
  )

	(princ "\n")
	(princ "\n★★★　【天板価格】検索KEY")
	(princ "\n---------------------------------------")
	(princ (strcat "\n材質記号= "        #ZaiCode ))
	(princ (strcat  "\n形状= "           #keijo   ))
	(princ (strcat  "\nシンク記号= "     #SINK    ))
	(princ (strcat  "\nシンク側間口= "   #MAGUCHI ))
	(princ (strcat  "\n奥行き= "         #OKU     ))
	(princ (strcat  "\nシンク位置= "     #SINK_ITI))
	(princ (strcat  "\nコンロ位置= "     #GAS_ANA ))
	(if #dan_f					
		(princ (strcat  "\nLR区分= "       #dan_LR  ))
		;else
		(princ (strcat  "\nLR区分= "       #WTLR    ))
	);_if
	(princ "\n---------------------------------------")
	(princ "\n")

	(princ "\n★★★　【天板価格】検索結果=")(princ #QRY$$)
	

;-- 2011/06/23 A.Satoh - E
;今は実装しない 2010/01/07 YM
;;;     (setq #LIST$$
;;;       (list
;;;         (list "材質記号"       (nth 16 CG_GLOBAL$) 'STR)
;;;         (list "形状"           (nth  5 CG_GLOBAL$) 'STR)
;;;         (list "シンク記号"     (nth 17 CG_GLOBAL$) 'STR)
;;;         (list "シンク側間口"   (nth  4 CG_GLOBAL$) 'STR)
;;;         (list "奥行き"         (nth  7 CG_GLOBAL$) 'STR)
;;;         (list "シンク位置"     (nth  2 CG_GLOBAL$) 'STR)
;;;         (list "コンロ位置"     (nth  9 CG_GLOBAL$) 'STR)
;;;         (list "LR区分"         (nth 11 CG_GLOBAL$) 'STR)
;;;       )
;;;     )
;;;     (setq #DB_NAME "天板価格")
;;;
;;;     (setq #qry$$
;;;       (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$)
;;;     )

;-- 2011/07/04 A.Satoh Mod - S
; (if (and #QRY$$ (= 1 (length #QRY$$)))
;   (progn
;     (setq #QRY$ (car #QRY$$))
;     (setq #WT_HINBAN  (nth 1 #QRY$))   ; 品番
;     (setq #WT_PRI     (nth 2 #QRY$))   ; 金額
;     (setq #WT_HABA    (nth 3 #QRY$))   ; 巾
;     (setq #WT_TAKASA  (nth 4 #QRY$))   ; 高さ
;     (setq #WT_OKUYUKI (nth 5 #QRY$))   ; 奥行
;     (setq #WT_HINMEI  (nth 6 #QRY$))   ; 品名
;   )
;   (progn ;HITしない若しくは複数
;     (setq #WT_HINBAN  "ERROR")   ; 品番
;     (setq #WT_PRI           0)   ; 金額
;     (setq #WT_HABA        "0")   ; 巾
;     (setq #WT_TAKASA      "0")   ; 高さ
;     (setq #WT_OKUYUKI     "0")   ; 奥行
;     (setq #WT_HINMEI  "ERROR")   ; 品名
;   )
; );_if

  (if #QRY$$
    (progn
      (if (= 1 (length #QRY$$))
        (progn
;-- 2011/09/19 A.Satoh Add - S
          ; ｶｯﾄ線方向の確認、修正
          (if (and (= #TYPE 1) (/= #CutDirect ""))        ; L型であり、カット方向が存在する
            (progn


							;2014/12/04 YM ADD S 直線ｶｯﾄ対応
							;材質から直線ｶｯﾄかどうか判断
						  (setq #Qry_cut$$ 
						    (DBSqlAutoQuery CG_DBSESSION
									(setq #sql (strcat "select カットタイプ from WT材質 where 材質記号='"  #ZaiCode "'"))
						    )
						  )
							(if (and (= 1 (length #Qry_cut$$)) (= "S" (car (car #Qry_cut$$))) )
								(progn ;直線ｶｯﾄだった(WTカット方向検索不要 ｼﾝｸ側"S"が常に規格側)

									;(alert (strcat "ｶｯﾄ方向 = " (nth 4 #cut$) "\n#CutDirect = " #CutDirect))
                  (if (/= #CutDirect "S");ｼﾝｸ側でなかったら(つまり"G"だったら)無理やりカット側を変更
                    (progn
											(CFAlertMsg "直線カットの方向が特注側(コンロ側)になっています。シンク側に変更します。")
                      ; ｶｯﾄ線１のレイヤを確認し、そのレイヤを元にｶｯﾄ線１、ｶｯﾄ線２のレイヤを入れ替える
                      (setq #layer (cdr (assoc 8 (entget #cut1))))
                      (if (= #layer "WTCUT_HIDE")
                        (progn
                          (command "_.CHANGE" #cut1 "" "P" "LA" SKW_AUTO_SOLID "")
                          (command "_.CHANGE" #cut2 "" "P" "LA" "WTCUT_HIDE" "")
                        )
                        (progn
                          (command "_.CHANGE" #cut1 "" "P" "LA" "WTCUT_HIDE" "")
                          (command "_.CHANGE" #cut2 "" "P" "LA" SKW_AUTO_SOLID "")
                        )
                      );_if
                      (setq #CutDirect "S")
                      (setq #TOKU_FLG 1);規格
                    )
										(progn
											nil ;シンク側だったら何もしない
										)
                  );_if

								)
								;else 直線ｶｯﾄ以外(従来ﾛｼﾞｯｸ)
								(progn

		              (setq #cut$$
		                (CFGetDBSQLRec CG_DBSESSION "WTカット方向"
		                  (list
		                    (list "シンク側間口" (substr #MAGUCHI 1 4)  'STR)
		                    (list "形状"         #keijo    'STR)
		                    (list "シンク位置"   #SINK_ITI 'STR)
		                    (list "奥行き"       #OKU      'STR)
		                  )
		                )
		              )
		              (if (and #cut$$ (= 1 (length #cut$$)))
		                (progn
		                  (setq #cut$ (nth 0 #cut$$))
											;(alert (strcat "ｶｯﾄ方向 = " (nth 4 #cut$) "\n#CutDirect = " #CutDirect))
		                  (if (/= #CutDirect (nth 4 #cut$))
		                    (progn
		                      (if (CFYesNoDialog "Jｶｯﾄの方向が特注側になっています。規格側に変更しますか？")
		                        (progn
		                          ; ｶｯﾄ線１のレイヤを確認し、そのレイヤを元にｶｯﾄ線１、ｶｯﾄ線２のレイヤを入れ替える
		                          (setq #layer (cdr (assoc 8 (entget #cut1))))
		                          (if (= #layer "WTCUT_HIDE")
		                            (progn
		                              (command "_.CHANGE" #cut1 "" "P" "LA" SKW_AUTO_SOLID "")
		                              (command "_.CHANGE" #cut2 "" "P" "LA" "WTCUT_HIDE" "")
		                            )
		                            (progn
		                              (command "_.CHANGE" #cut1 "" "P" "LA" "WTCUT_HIDE" "")
		                              (command "_.CHANGE" #cut2 "" "P" "LA" SKW_AUTO_SOLID "")
		                            )
		                          );_if
		                          (setq #CutDirect (nth 4 #cut$))
		                          (setq #TOKU_FLG 1);規格
		                        )
														;else
		                        (setq #TOKU_FLG 0);特注
		                      );_if CFYesNoDialog
		                    )
												;else
		                    (setq #TOKU_FLG 1);規格
		                  )
		                )
		                (progn
		                  (setq #msg (strcat "『WTカット方向』にﾚｺｰﾄﾞがありません。\n特注天板として登録します。"))
		                  (setq #msg (strcat #msg "\nシンク側間口=" #MAGUCHI " 形状=" #keijo " シンク位置=" #SINK_ITI " 奥行き=" #OKU))
		                  (CFAlertMsg #msg)
		                  (setq #TOKU_FLG 0)
		                )
		              );_if

								);直線ｶｯﾄ以外(従来ﾛｼﾞｯｸ)
							);_if


            )
            (progn
              (setq #TOKU_FLG 1)
            )
          );_if  ; L型であり、方向カットである


          (if (= #TOKU_FLG 0)
            (progn
              (setq #TOKU_FLG          0)   ; 特注フラグ
;;;              (setq #WT_HINBAN  "ZZ6500")   ; 品番
              (setq #WT_HINBAN  #CG_TOKU_HINBAN)   ; 品番 2016/08/30 YM ADD (5)天板なので機器以外
              (setq #WT_PRI          "0")   ; 金額
              (setq #WT_HABA          "")   ; 巾
              (setq #WT_TAKASA        "")   ; 高さ
              (setq #WT_OKUYUKI       "")   ; 奥行
;;;              (setq #WT_HINMEI "ﾄｸﾁｭｳ(ZZ6500)")   ; 品名
              (setq #WT_HINMEI CG_TOKU_HINMEI)   ; 品名 2016/08/30 YM ADD
            )
            (progn
;-- 2011/09/19 A.Satoh Add - E
          (setq #QRY$ (car #QRY$$))
          (setq #TOKU_FLG    1)                   ; 特注フラグ
          (setq #WT_HINBAN  (nth 1 #QRY$))        ; 品番
          (setq #WT_PRI     (rtos (nth 2 #QRY$))) ; 金額
          (setq #WT_HABA    (nth 3 #QRY$))        ; 巾
          (setq #WT_TAKASA  (nth 4 #QRY$))        ; 高さ
          (setq #WT_OKUYUKI (nth 5 #QRY$))        ; 奥行
		          (setq #WT_HINMEI  (nth 6 #QRY$))        ; 品名
;-- 2011/09/19 A.Satoh Add - S
            )
          );_if

;-- 2011/09/19 A.Satoh Add - E
        )
        (progn
          (setq #TOKU_FLG          0)   ; 特注フラグ
;;;          (setq #WT_HINBAN  "ZZ6500")   ; 品番
          (setq #WT_HINBAN  #CG_TOKU_HINBAN)   ; 品番 2016/08/30 YM ADD (5)天板なので機器以外
          (setq #WT_PRI          "0")   ; 金額
          (setq #WT_HABA          "")   ; 巾
          (setq #WT_TAKASA        "")   ; 高さ
          (setq #WT_OKUYUKI       "")   ; 奥行
;;;          (setq #WT_HINMEI "ﾄｸﾁｭｳ(ZZ6500)")   ; 品名
          (setq #WT_HINMEI CG_TOKU_HINMEI)   ; 品名 2016/08/30 YM ADD
        )
      )
    )
    (progn
      (setq #TOKU_FLG          0)   ; 特注フラグ
;;;      (setq #WT_HINBAN  "ZZ6500")   ; 品番
      (setq #WT_HINBAN  #CG_TOKU_HINBAN)   ; 品番 2016/08/30 YM ADD (5)天板なので機器以外
      (setq #WT_PRI          "0")   ; 金額
      (setq #WT_HABA          "")   ; 巾
      (setq #WT_TAKASA        "")   ; 高さ
      (setq #WT_OKUYUKI       "")   ; 奥行
;;;      (setq #WT_HINMEI "ﾄｸﾁｭｳ(ZZ6500)")   ; 品名
			(setq #WT_HINMEI CG_TOKU_HINMEI)   ; 品名 2016/08/30 YM ADD
    )
  )
;-- 2011/07/04 A.Satoh Mod - E
;-- 2011/08/29 A.Satoh Add - S
    )
    (progn
      (setq #TOKU_FLG          0)   ; 特注フラグ
;;;      (setq #WT_HINBAN  "ZZ6500")   ; 品番
      (setq #WT_HINBAN  #CG_TOKU_HINBAN)   ; 品番 2016/08/30 YM ADD (5)天板なので機器以外
      (setq #WT_PRI          "0")   ; 金額
      (setq #WT_HABA          "")   ; 巾
      (setq #WT_TAKASA        "")   ; 高さ
      (setq #WT_OKUYUKI       "")   ; 奥行
;;;      (setq #WT_HINMEI "ﾄｸﾁｭｳ(ZZ6500)")   ; 品名
      (setq #WT_HINMEI CG_TOKU_HINMEI)   ; 品名 2016/08/30 YM ADD
    )
  )
;-- 2011/08/29 A.Satoh Add - E

;-- 2011/08/26 A.Satoh Add - S
      (setq #hinban_dat$
        (list
          #TOKU_FLG     ; 特注フラグ
          #WT_HINBAN    ; 品番
          #WT_PRI       ; 金額
          #WT_HABA      ; 巾
          #WT_TAKASA    ; 高さ
          #WT_OKUYUKI   ; 奥行
          #WT_HINMEI    ; 品名
          ""            ; 特注コード
        )
      )
    )
  )

  ; 天板品名確定ダイアログ処理
;-- 2011/12/12 A.Satoh Mod - S
;;;;;  (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$))
  (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$ #TYPE))
;-- 2011/12/12 A.Satoh Mod - E
  (if (/= #hinban_dat$ nil)
    (progn
;-- 2011/08/26 A.Satoh Add - E

  ; 獲得されたフラグ、品番、価格、コード（寸法）を拡張データに格納
  (if (= (tblsearch "APPID" "G_WTSET") nil) (regapp "G_WTSET"))

;-- 2011/08/26 A.Satoh Mod - S
;  (setq #WTSET$
;    (list
;;-- 2011/07/04 A.Satoh Mod - S
;;     1              ; G_WTSET 特注フラグ (0:特注,1:規格)
;      #TOKU_FLG      ; G_WTSET 特注フラグ (0:特注,1:規格)
;;-- 2011/07/04 A.Satoh Mod - E
;      #WT_HINBAN     ; G_WTSET 品番
;      (nth 8 #WRKT$) ; G_WTSET 取付け高さ(ここだけWT図形情報からとる)
;      #WT_PRI        ; G_WTSET 金額(実数)
;      #WT_HINMEI     ; 品名
;      #WT_HABA       ; 巾
;      #WT_TAKASA     ; 高さ
;      #WT_OKUYUKI    ; 奥行
;      ""             ; 予備1
;      ""             ; 予備2
;      ""             ; 予備3
;    )
;  )
;
;  ; 穴寸法追加(可変)
;  (setq #WTSET$ (append #WTSET$ (list (length #dim$)))) ; WT穴情報寸法数列個数
;  (foreach #dim #dim$
;    (setq #WTSET$ (append #WTSET$ (list #dim))) ; 穴寸法
;  )
;  (CFSetXData &eWTP "G_WTSET" #WTSET$)
      (if (= #syori_flg nil)
        (CFSetXData &eWTP "G_WTSET" (CFModList #WTSET2$
            (list
              (list 1 (nth 1 #hinban_dat$))
              (list 3 (nth 2 #hinban_dat$))
              (list 4 (nth 6 #hinban_dat$))
              (list 5 (nth 3 #hinban_dat$))
              (list 6 (nth 4 #hinban_dat$))
              (list 7 (nth 5 #hinban_dat$))
              (list 8 (nth 7 #hinban_dat$))
							(if (= (nth 9 #WTSET2$) "")
								(list 9 (nth 1 #hinban_dat$))
								(list 9 (nth 9 #WTSET2$))
							)
            ))
        )
        (progn
          (setq #WTSET$
            (list
              (nth 0 #hinban_dat$)
              (nth 1 #hinban_dat$)
              #tori_height   ; G_WTSET 取付け高さ(ここだけWT図形情報からとる)
              (nth 2 #hinban_dat$)
              (nth 6 #hinban_dat$)
              (nth 3 #hinban_dat$)
              (nth 4 #hinban_dat$)
              (nth 5 #hinban_dat$)
              (nth 7 #hinban_dat$)
							(nth 1 #hinban_dat$)
;              ""             ; 予備2
              ""             ; 予備3
            )
          )

          ; 穴寸法追加(可変)
          (setq #WTSET$ (append #WTSET$ (list (length #dim$)))) ; WT穴情報寸法数列個数
          (foreach #dim #dim$
            (setq #WTSET$ (append #WTSET$ (list #dim))) ; 穴寸法
          )

          (CFSetXData &eWTP "G_WTSET" #WTSET$)
        )
      )

      (setq #SetXd$ (CFGetXData &eWTP "G_WRKT"))
;-- 2011/09/19 A.Satoh Add - S
;;;;;      (if (= (nth 0 #hinban_dat$) 0)
;;;;;        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 58 "TOKU"))))
;;;;;        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 58 ""))))
;;;;;      )
;-- 2011/10/28 A.Satoh Mod - S
;;;;;      (if (= (nth 0 #hinban_dat$) 0)
;;;;;        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 9 #CutDirect) (list 58 "TOKU"))))
;;;;;        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 9 #CutDirect) (list 58 ""))))
;;;;;      )
      (if (= (nth 0 #hinban_dat$) 0)
        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 9 #CutDirect) (list 35 "")        (list 58 "TOKU"))))
        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 9 #CutDirect) (list 35 #SINK_ITI) (list 58 ""))))
      )
;-- 2011/10/28 A.Satoh Mod - S
;-- 2011/09/19 A.Satoh Add - S

;-- 2011/08/31 A.Satoh Add - S
      ; ｼﾝｸ、ｺﾝﾛ、水栓穴あけ処置
      (PKW_MakeHoleWorkTop2 &eWTP #eSNK_P$ #eGAS_P5$) ; #eSNK_P$ #eGAS_P5$ (nil)有り得る
;-- 2011/08/31 A.Satoh Add - E
    )
  )
;-- 2011/08/26 A.Satoh Mod - E

  ; ワークトップの色を確定色に変える（拡張データを確認の上）
  (if (CFGetXData &eWTP "G_WTSET")
    (progn
      (command "_.change" &eWTP "" "P" "C" CG_WorkTopCol "")
      ;;; BG,FGも一緒に色替えする
      (setq #BG1 (nth 49 #WRKT$))
      (setq #BG2 (nth 50 #WRKT$))
      (if (/= #BG1 "")
        (progn
          (if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
            (command "_.change" #BG1 "" "P" "C" CG_WorkTopCol "")
          )
        )
      );_if
      (if (/= #BG2 "")
        (progn
          (if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
            (command "_.change" #BG2 "" "P" "C" CG_WorkTopCol "")
          )
        )
      );_if
    )
    (progn
      (command "_.change" &eWTP "" "P" "C" "BYLAYER" "")
    )
  );_if

;-- 2011/08/26 A.Satoh Del - S
;  ; 内容表示(実際に現ワークトップに入った値)
;  ; 2006/09/15 T.Ari MOD 確認画面の設定値を天板に設定するように変更
;  (setq #CHECK (PKY_ShowWTSET_Dlog #WRKT$ (CFGetXData &eWTP "G_WTSET")))
;  (setq #WTSET$ (CFModList (CFGetXData &eWTP "G_WTSET") (list (list 1 (nth 0 #CHECK)) (list 3 (nth 1 #CHECK)))))
;  (CFSetXData &eWTP "G_WTSET" #WTSET$)
;-- 2011/08/26 A.Satoh Del - E

;-- 2011/08/31 A.Satoh Del - S
;  ;;; ｼﾝｸ、ｺﾝﾛ、水栓穴あけ処置
;  (PKW_MakeHoleWorkTop2 &eWTP #eSNK_P$ #eGAS_P5$) ; #eSNK_P$ #eGAS_P5$ (nil)有り得る
;-- 2011/08/31 A.Satoh Del - E

  (command "zoom" "p")
  (setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)
;-- 2011/09/01 A.Satoh Mod - S
;  (princ)
  #hinban_dat$
;-- 2011/09/01 A.Satoh Mod - S
);KPW_DesideWorkTop_FREE

;;; <HOM>***********************************************************************************
;;; <関数名>    : KP_GetSinkKIGO
;;; <処理概要>  : Xdata"G_SINK"のｼﾝｸ記号からWT品番用のｼﾝｸ記号を取得する
;;; <戻り値>    : WT品番用のｼﾝｸ記号
;;; <作成>      : NAS用 02/09/13
;;; <備考>      : 検索失敗-->"?"
;;; ***********************************************************************************>MOH<
(defun KP_GetSinkKIGO (
  &Sink_KIGO  ; ｼﾝｸ記号
  /
  #NAME$ #RET
  )
  (setq #name$ ; １つ引き当て
    (CFGetDBSQLRec CG_DBSESSION "WTシンク"
      (list (list "シンク記号" &Sink_KIGO 'STR))
    )
  )
  (if (and #name$ (= 1 (length #name$)))
;-- 2011/08/29 A.Satoh Mod - S
;    (setq #ret (nth 17 (car #name$)))
    (setq #ret (nth 1 (car #name$)))
;-- 2011/08/29 A.Satoh Mod - S
    (setq #ret "?")
  );_if
  #ret
);KP_GetSinkKIGO

;;; <HOM>***********************************************************************************
;;; <関数名>    : PKGetANAdim-L2
;;; <処理概要>  : ワークトップ穴情報を求める(L型専用)ｼﾝｸ,ｺﾝﾛ複数対応
;;; <戻り値>    : WT左からの寸法数列
;;; <作成>      : 00/09/25 YM 標準化
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;; ***********************************************************************************>MOH<
(defun PKGetANAdim-L2 (
  &eWT      ; WT図形名
  &WRKT$    ; G_WRKT
  &eSNK_P$  ; SNK-PMEN(複数ﾘｽﾄ)
  &eGAS_P$  ; GAS-PMEN(複数ﾘｽﾄ)
  /
  #ANA$ #BASEP #DIM$ #DIM1$ #DIM2$ #HABA1$ #HABA2$ #LEN1 #LEN2 #LIS1$$ #LIS2$$
  #MAX #MIN #P1 #P2 #P3 #P4 #P5 #P6 #PT$ #PTANA$ #PTANA1$$ #PTANA2$$
  #REG1$ #REG2$ #RET$ #TEI #X1 #X2
  )
  (setq #ANA$ (append &eSNK_P$ &eGAS_P$)) ; PMENｼﾝﾎﾞﾙ図形
;;; nilを除く
  (setq #ANA$ (NilDel_List #ANA$))

;;; p1+----------+--LEN2-------------+p2
;;;   |          x1                  |
;;;   |          |     領域2         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |          |
;;;   |  領域1   |
;;;LEN1          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   |          |
;;; p6+----------+p5

  (setq #tei   (nth 38 &WRKT$))      ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BaseP (nth 32 &WRKT$))      ; WT左上点
  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
;;; 外形点列&pt$を#BASEPを先頭に時計周りにする
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))
  (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
  (setq #x2 (CFGetDropPt #p4 (list #p1 #p6)))
  (setq #LEN1 (distance #p1 #p6))
  (setq #LEN2 (distance #p1 #p2))

  (command "_layer" "T" "Z_01*" "") ; PMEN画層ﾌﾘｰｽﾞ解除

  (setq #reg1$ (list #p1 #x1 #p5 #p6 #p1)) ; 領域1
  (setq #reg2$ (list #p1 #p2 #p3 #x2 #p1)) ; 領域2

  (setq #lis1$$ '())
  (setq #lis2$$ '())
  (if #ANA$ ; PMENあり
    (progn
      (foreach #ANA #ANA$
        (setq #ptANA$ (GetLWPolyLinePt #ANA)) ; PMEN外形点列
        (if (IsEntInPolygon #ANA #reg1$ "CP") ; 領域1にPMENが存在すれば
          (progn
            (setq #ptANA1$$ (append #ptANA1$$ (list #ptANA$)))
            (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p5 #p6)))
            (setq #min (car  #ret$)) ; 距離最小
            (setq #max (cadr #ret$)) ; 距離最大
            (setq #lis1$$ (append #lis1$$ (list (list #min) (list #max))))
          )
        );_if
        (if (IsEntInPolygon #ANA #reg2$ "CP") ; 領域2にPMENが存在すれば
          (progn
            (setq #ptANA2$$ (append #ptANA2$$ (list #ptANA$)))
            (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p1 #p6)))
            (setq #min (car  #ret$))
            (setq #max (cadr #ret$))
            (setq #lis2$$ (append #lis2$$ (list (list #min) (list #max))))
          )
        );_if
      )
    )
  );_if

;;; 領域1側寸法数列を求める(端から穴までの距離)
  (setq #dim1$
    (PKGetDimSeries2
      #lis1$$  ; (距離最小,距離最大)のﾘｽﾄ
      #LEN1    ; 全長
    )
  )
;;; 領域2側寸法数列を求める(端から穴までの距離)
  (setq #dim2$
    (PKGetDimSeries2
      #lis2$$  ; (距離最小,距離最大)のﾘｽﾄ
      #LEN2    ; 全長
    )
  )

  (setq #dim$ (append #dim1$ #dim2$))
  (command "_layer" "F" "Z_01*" "") ; PMEN画層ﾌﾘｰｽﾞ
  (setq #dim$ (append #dim$ (list #LEN1 #LEN2)))
  #dim$
);PKGetANAdim-L2

;;; <HOM>***********************************************************************************
;;; <関数名>    : KPGetSK4
;;; <処理概要>  : WT品番項目4を求める
;;; <戻り値>    : 文字列ﾘｽﾄ
;;; <作成>      : 01/07/10 YM
;;; <備考>      : NAS用
;;; ***********************************************************************************>MOH<
(defun KPGetSK4 (
  &len$     ; WT実際の幅(段差部分は含まない)
  &ZaiF     ; 素材F 0:人大,1:ｽﾃﾝﾚｽ
  &WT_type  ; I,L
  &FD       ; "F" or "D"段差
  &PLINE    ; 段差部分も含めたWT外形ﾎﾟﾘﾗｲﾝ
  &BaseP    ; WT左上点
  /
  #NMAG1 #NMAG2 #SK4 #SMAG1 #SMAG2 #SSMAG1 #SSMAG2 #DIST1 #DIST2 #WTPT$
  )
  (setq #nMAG1 (fix (+ (car  &len$) 0.1))) ; 'INT 2550
  (setq #nMAG2 (fix (+ (cadr &len$) 0.1)))

  (if (and (equal &ZaiF 1 0.1)(= &WT_type "L")(= &FD "D"))
    (progn ; ｽﾃﾝﾚｽL型のとき段差部も含む外形から全体間口を求める
      ; 標準WT判定にWT外形点列が必要
      (setq #WTpt$ (GetLWPolyLinePt &PLINE)) ; 外形点列
      ; 外形点列&pt$を#BASEPを先頭に時計周りにする
      (setq #WTpt$ (GetPtSeries &BaseP #WTpt$))
      ; 02/04/17 YM ADD-S エラー回避 #WTpt$=nil時
      (if #WTpt$
        (progn
          (setq #dist1 (+ (distance (nth 0 #WTpt$)(nth 1 #WTpt$)) 0.001))
          (setq #dist2 (+ (distance (nth 0 #WTpt$)(nth 5 #WTpt$)) 0.001))
          (if (<= #dist1 #dist2)
            (setq #nMAG2 (fix (+ #dist1 0.001))) ; 'INT 2550
            (setq #nMAG2 (fix (+ #dist2 0.001))) ; 'INT 2550
          );_if
        )
        (progn ; ｽﾃﾝﾚｽL型段差斜めｶｯﾄ,方向ｶｯﾄなどのとき
          (setq #nMAG2 0)
        )
      );_if

    )
  );_if

  ; 01/12/07 YM ADD-S ｽﾃﾝﾚｽI型ｼﾞｮｲﾄｯﾌﾟ対応
  (if (and (equal &ZaiF 1 0.1)(= &WT_type "I")(= &FD "D"))
    (progn ; ｽﾃﾝﾚｽI型のとき段差部も含む外形から全体間口を求める
      ; 標準WT判定にWT外形点列が必要
      (setq #WTpt$ (GetLWPolyLinePt &PLINE)) ; 外形点列
      (setq #dist1 (+ (distance (nth 0 #WTpt$)(nth 1 #WTpt$)) 0.001))
      (setq #dist2 (+ (distance (nth 1 #WTpt$)(nth 2 #WTpt$)) 0.001))
      (if (<= #dist1 #dist2)
        (setq #nMAG1 (fix (+ #dist2 0.001))) ; 'INT 2550
        (setq #nMAG1 (fix (+ #dist1 0.001))) ; 'INT 2550
      );_if
    )
  );_if
  ; 01/12/07 YM ADD-E ｽﾃﾝﾚｽI型ｼﾞｮｲﾄｯﾌﾟ対応

  (setq #sMAG1 (itoa #nMAG1)) ; 'STR "2550"

  (setq #sMAG2 (itoa #nMAG2))
  (setq #ssMAG1 (substr #sMAG1 1 (1- (strlen #sMAG1)))) ; "2550"==>"255"
  (setq #ssMAG2 (substr #sMAG2 1 (1- (strlen #sMAG2))))

  (if (and (equal &ZaiF 1 0.1)(= &WT_type "L"))
    (progn ; ｽﾃﾝﾚｽL型
      (setq #sk4 (strcat (substr #ssMAG1 1 2)(substr #ssMAG2 2 1))) ; 255×165==>256
    )
    (progn ; それ以外(I形状I,L,U型)
      (setq #sk4 #ssMAG1)
      (if (= (strlen #sk4) 2)
        (setq #sk4 (strcat "0" #sk4))
      );_if
    )
  );_if
  #sk4
);KPGetSK4

;;; <HOM>***********************************************************************************
;;; <関数名>    : KPGetSK5
;;; <処理概要>  : WT品番項目4を求める
;;; <戻り値>    : 文字列ﾘｽﾄ
;;; <作成>      : 03/10/14 YM
;;; <備考>      : NAS ﾃﾞｨﾌﾟﾛｱ用
;;; ***********************************************************************************>MOH<
(defun KPGetSK5 (
  &Fullflat ; ﾌﾙﾌﾗｯﾄﾌﾗｸﾞ
  &len$     ; WT実際の幅(段差部分は含まない)
  &ZaiF     ; 素材F 0:人大,1:ｽﾃﾝﾚｽ
  &WT_type  ; I,L
  &FD       ; "F" or "D"段差
  &PLINE    ; 段差部分も含めたWT外形ﾎﾟﾘﾗｲﾝ
  &BaseP    ; WT左上点
  /
  #NMAG1 #NMAG2 #SK4 #SMAG1 #SMAG2 #SSMAG1 #SSMAG2 #DIST1 #DIST2 #WTPT$
  )
  (setq #nMAG1 (fix (+ (car  &len$) 0.1))) ; 'INT 2550
  (setq #nMAG2 (fix (+ (cadr &len$) 0.1)))
  ;ﾌﾙﾌﾗｯﾄは23mm引く
  ;04/04/0 YM MOD ﾌﾙﾌﾗｯﾄは21mm引く
  (if &Fullflat
    (setq #nMAG1 (- #nMAG1 23));04/06/14 YM MOD
;;;   (setq #nMAG1 (- #nMAG1 21));04/04/09 YM MOD
  );_if

  (if (and (equal &ZaiF 1 0.1)(= &WT_type "L")(= &FD "D"))
    (progn ; ｽﾃﾝﾚｽL型のとき段差部も含む外形から全体間口を求める
      ; 標準WT判定にWT外形点列が必要
      (setq #WTpt$ (GetLWPolyLinePt &PLINE)) ; 外形点列
      ; 外形点列&pt$を#BASEPを先頭に時計周りにする
      (setq #WTpt$ (GetPtSeries &BaseP #WTpt$))
      ; 02/04/17 YM ADD-S エラー回避 #WTpt$=nil時
      (if #WTpt$
        (progn
          (setq #dist1 (+ (distance (nth 0 #WTpt$)(nth 1 #WTpt$)) 0.001))
          (setq #dist2 (+ (distance (nth 0 #WTpt$)(nth 5 #WTpt$)) 0.001))
          (if (<= #dist1 #dist2)
            (setq #nMAG2 (fix (+ #dist1 0.001))) ; 'INT 2550
            (setq #nMAG2 (fix (+ #dist2 0.001))) ; 'INT 2550
          );_if
        )
        (progn ; ｽﾃﾝﾚｽL型段差斜めｶｯﾄ,方向ｶｯﾄなどのとき
          (setq #nMAG2 0)
        )
      );_if

    )
  );_if

  ; 01/12/07 YM ADD-S ｽﾃﾝﾚｽI型ｼﾞｮｲﾄｯﾌﾟ対応
  (if (and (equal &ZaiF 1 0.1)(= &WT_type "I")(= &FD "D"))
    (progn ; ｽﾃﾝﾚｽI型のとき段差部も含む外形から全体間口を求める
      ; 標準WT判定にWT外形点列が必要
      (setq #WTpt$ (GetLWPolyLinePt &PLINE)) ; 外形点列
      (setq #dist1 (+ (distance (nth 0 #WTpt$)(nth 1 #WTpt$)) 0.001))
      (setq #dist2 (+ (distance (nth 1 #WTpt$)(nth 2 #WTpt$)) 0.001))
      (if (<= #dist1 #dist2)
        (setq #nMAG1 (fix (+ #dist2 0.001))) ; 'INT 2550
        (setq #nMAG1 (fix (+ #dist1 0.001))) ; 'INT 2550
      );_if
    )
  );_if
  ; 01/12/07 YM ADD-E ｽﾃﾝﾚｽI型ｼﾞｮｲﾄｯﾌﾟ対応

  (setq #sMAG1 (itoa #nMAG1)) ; 'STR "2550"

  (setq #sMAG2 (itoa #nMAG2))
  (setq #ssMAG1 (substr #sMAG1 1 (1- (strlen #sMAG1)))) ; "2550"==>"255"
  (setq #ssMAG2 (substr #sMAG2 1 (1- (strlen #sMAG2))))

  (if (and (equal &ZaiF 1 0.1)(= &WT_type "L"))
    (progn ; ｽﾃﾝﾚｽL型
      (setq #sk4 (strcat (substr #ssMAG1 1 2)(substr #ssMAG2 2 1))) ; 255×165==>256
    )
    (progn ; それ以外(I形状I,L,U型)
      (setq #sk4 #ssMAG1)
      (if (= (strlen #sk4) 2)
        (setq #sk4 (strcat "0" #sk4))
      );_if
    )
  );_if
  #sk4
);KPGetSK5

;;; <HOM>***********************************************************************************
;;; <関数名>    : KPGetSK5_eyefull
;;; <処理概要>  : WT品番項目4を求める
;;; <戻り値>    : 文字列ﾘｽﾄ
;;; <作成>      : 03/11/28 YM
;;; <備考>      : NAS ｱｲﾌﾙﾎｰﾑ用
;;; ***********************************************************************************>MOH<
(defun KPGetSK5_eyefull (
  &Fullflat ; ﾌﾙﾌﾗｯﾄﾌﾗｸﾞ
  &len$     ; WT実際の幅(段差部分は含まない)
  &ZaiF     ; 素材F 0:人大,1:ｽﾃﾝﾚｽ
  &WT_type  ; I,L
  &FD       ; "F" or "D"段差
  &PLINE    ; 段差部分も含めたWT外形ﾎﾟﾘﾗｲﾝ
  &BaseP    ; WT左上点
  /
  #NMAG1 #NMAG2 #SK4 #SMAG1 #SSMAG1
  )
  (setq #nMAG1 (fix (+ (car  &len$) 0.1))) ; 'INT 2550
  (setq #nMAG2 (fix (+ (cadr &len$) 0.1)))
  ;ﾌﾙﾌﾗｯﾄは23mm引く
  (if &Fullflat
    (progn
      (cond
        ((equal #nMAG1 2440.0 0.001)
          (setq #nMAG1 2411)
        )
        ((equal #nMAG1 2590.0 0.001)
          (setq #nMAG1 2511)
        )
      );_cond
      (setq #sMAG1 (itoa #nMAG1)) ; 'STR "2550"
      (setq #sk4 #sMAG1)
    )
    (progn
      (setq #sMAG1 (itoa #nMAG1)) ; 'STR "2550"
      (setq #ssMAG1 (substr #sMAG1 1 (1- (strlen #sMAG1)))) ; "2550"==>"255"
      (setq #sk4 #ssMAG1)
      (if (= (strlen #sk4) 2)
        (setq #sk4 (strcat "0" #sk4))
      );_if
    )
  );_if

  #sk4
);KPGetSK5_eyefull


;;;<HOM>*************************************************************************
;;; <関数名>    : PKResetWTSETdim$
;;; <処理概要>  : WTSETの穴寸法情報を再セット 品番10,11桁目入れ替え
;;; <戻り値>    : なし
;;; <作成日>    : 00/06/02 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKResetWTSETdim$ (
  &wt      ; WT図形名
  &xdWT    ; 新ＷＴ"G_WRKT"
  &xdWTSET ; 更新前"G_WTSET"
  &zai     ; WT材質
  /
  #CUTL #CUTR #CUTTYPE #DIM$ #DLOG$ #EGAS$ #EGAS_P5$ #ESNK$ #ESNK_P$ #ESNK_P1$ #ESNK_P4$$
  #GAS$$ #HOLE #I #NWT_FLG #NWT_PRI #RET$ #SETXD$ #SNK$$ #SNKCAB$ #SWT_ID #WTSET$
  #WT_HINBAN #XD-SNK$ #ZAIF
#DF_BIKOU #DF_HINMEI #BIKOU #DUM1 #DUM2 #HINMEI #XDWRKT$ ; 03/01/28 YM ADD
;-- 2011/09/19 A.Satoh Add - S
  #hinban_dat$
;-- 2011/09/19 A.Satoh Add - E
  )
  (setq #CutType (nth 7 &xdWT)) ; ｶｯﾄﾀｲﾌﾟ
  (setq #cutL (substr #CutType 1 1))
  (setq #cutR (substr #CutType 2 1))

;;; ｽﾃﾝﾚｽならPMEN1 それ以外はPMEN4==>仕様変更01/03/27 YM ｽﾃﾝﾚｽならPMEN4属性1 人大はPMEN4属性0
  (setq #ZaiF (KCGetZaiF &zai)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ

  ;;; 寸法数列
  (setq #ret$ (PKW_GetWorkTopAreaSym3 &wt)); 引数=処理の対象ワークトップ図形名
  (setq #SNK$$ (nth 0 #ret$))
  (setq #GAS$$ (nth 1 #ret$))
;;; 変数へ代入<ｼﾝｸ>
  (foreach #SNK$ #SNK$$
    (setq #eSNK$    (append #eSNK$    (list (nth 0 #SNK$)))) ; ｼﾝｸｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
    (setq #SNKCAB$  (append #SNKCAB$  (list (nth 1 #SNK$)))) ; ｼﾝｸｷｬﾋﾞｼﾝﾎﾞﾙﾘｽﾄ
    (setq #eSNK_P1$ (append #eSNK_P1$ (list (nth 2 #SNK$)))) ; ｼﾝｸPMEN1ｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
    (setq #eSNK_P4$$ (append #eSNK_P4$$ (list (nth 3 #SNK$)))) ; ｼﾝｸPMEN4ｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
  )
  (setq #eSNK$    (NilDel_List #eSNK$    ))
  (setq #SNKCAB$  (NilDel_List #SNKCAB$  ))
  (setq #eSNK_P1$ (NilDel_List #eSNK_P1$ ))
  (setq #eSNK_P4$$ (NilDel_List #eSNK_P4$$ ))

  ; 各ｼﾝｸの材質に応じたｼﾝｸ穴領域のﾘｽﾄを返す(ｼﾝｸ複数対応)
  ;01/03/27 YM MOD ｼﾝｸ穴領域の属性をみて判断 STRAT
  (setq #eSNK_P$ (KPGetSinkANA #eSNK_P4$$ #ZaiF)) ; 各ｼﾝｸ毎のPMEN4ﾘｽﾄのﾘｽﾄ
  ;01/03/27 YM MOD ｼﾝｸ穴領域の属性をみて判断 END

;;;01/03/27YM@  (cond ; 00/09/26 YM
;;;01/03/27YM@    ((equal #ZaiF 1 0.1)
;;;01/03/27YM@      (setq #eSNK_P$ #eSNK_P1$) ; ｽﾃﾝﾚｽ
;;;01/03/27YM@    )
;;;01/03/27YM@    ((equal #ZaiF 0 0.1)
;;;01/03/27YM@      (setq #eSNK_P$ #eSNK_P4$) ; 人工大理石
;;;01/03/27YM@    )
;;;01/03/27YM@    (T
;;;01/03/27YM@      (CFAlertMsg "\n『WT材質』の\"素材F\"が不正です。")(quit)
;;;01/03/27YM@    )
;;;01/03/27YM@  );_cond

;;; 変数へ代入<ｺﾝﾛ>
  (foreach #GAS$ #GAS$$
    (setq #eGAS$    (append #eGAS$    (list (nth 0 #GAS$)))) ; ｺﾝﾛﾘｽﾄ(nil)含む
    (setq #eGAS_P5$ (append #eGAS_P5$ (list (nth 2 #GAS$)))) ; ｺﾝﾛPMEN5ｼﾝﾎﾞﾙﾘｽﾄ(nil)含む
  )
  (setq #eGAS$    (NilDel_List #eGAS$    ))
  (setq #eGAS_P5$ (NilDel_List #eGAS_P5$ ))

;;; ; ﾜｰｸﾄｯﾌﾟ穴情報を求める &wt
;;; (if (and (= #ZaiF 1)(= (nth 3 &xdWT) 1))
;;;   (setq #dim$ (PKGetANAdim-L2 &wt &xdWT #eSNK_P$ #eGAS_P5$)) ; L形状の場合(ｽﾃﾝﾚｽL型)
;;;   (setq #dim$ (PKGetANAdim-I2 &wt &xdWT #eSNK_P$ #eGAS_P5$)) ; I形状の場合
;;; );_if

  ; ﾜｰｸﾄｯﾌﾟ穴情報を求める
  (if (and (= #ZaiF 1)(= (nth 3 &xdWT) 1)(= #cutL "0")(= #cutR "0")) ; 01/02/13 YM 修正
    (setq #dim$ (PKGetANAdim-L2 &wt &xdWT #eSNK_P$ #eGAS_P5$)) ; L形状の場合(ｽﾃﾝﾚｽL型ｶｯﾄなし)
    (setq #dim$ (PKGetANAdim-I2 &wt &xdWT #eSNK_P$ #eGAS_P5$)) ; I形状の場合
  );_if

;;;   ((= (nth 3 #WRKT$) 2) ; U形状の場合
;;;     (setq #dim$ (PKGetANAdim-U2 &wt &xdWT #eSNK_P$ #eGAS_P5$))
;;;   )

;;; 価格をﾕｰｻﾞｰが入力
  (cond
    ((= "L" (nth 30 &xdWT)) ; 左勝手になった
      (setq #WT_HINBAN (vl-string-subst "TL" "TR" (nth 1 &xdWTSET)))
      (setq #WT_HINBAN (vl-string-subst "T-L" "T-R" (nth 1 &xdWTSET)))
    )
    ((= "R" (nth 30 &xdWT)) ; 右勝手になった
      (setq #WT_HINBAN (vl-string-subst "TR" "TL" (nth 1 &xdWTSET)))
      (setq #WT_HINBAN (vl-string-subst "T-R" "T-L" (nth 1 &xdWTSET)))
    )
    (T
      (setq #WT_HINBAN (nth 1 &xdWTSET))
    )
  );_cond

  ; 03/01/27 YM ADD-S
  ; [46]品名があれば優先して表示する
  (setq #DF_HINMEI (KPGetWTHinmei &zai)); WT材質からWT品名を求める
  (setq #dum1 (nth 45 &xdWT))
  (if (and #dum1 (/= "" #dum1))
    (setq #DF_HINMEI #dum1)
  );_if

  (setq #dum2 (nth 46 &xdWT)) ; 備考
  (if (and #dum2 (/= "" #dum2))
    (setq #DF_BIKOU #dum2)
  ; else
    (setq #DF_BIKOU "")
  );_if
  ; 03/01/27 YM ADD-E

;-- 2011/09/19 A.Satoh Mod - S
  ; 天板情報リストを作成する
  (setq #hinban_dat$
    (list
      (nth 0 &xdWTSET)  ; 特注フラグ(整数) 0:特注 1:規格
      #WT_HINBAN        ; 品番(文字列)
      (rtos (nth 3 &xdWTSET)) ; 金額(文字列)
      (nth 5 &xdWTSET)  ; 巾(文字列)
      (nth 6 &xdWTSET)  ; 高さ(文字列)
      (nth 7 &xdWTSET)  ; 奥行(文字列)
      (nth 4 &xdWTSET)  ; 品名(文字列)
      (nth 8 &xdWTSET)  ; 特注コード(文字列)
    )
  )

;-- 2011/12/12 A.Satoh Add - S
;;;;;  (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$))
  (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$ (nth 3 &xdWT)))
;-- 2011/12/12 A.Satoh Add - E
  (if (/= #hinban_dat$ nil)
    (progn
      (if (= (tblsearch "APPID" "G_WTSET") nil) (regapp "G_WTSET"))
      (setq #WTSET$
        (list
          (nth 0 #hinban_dat$)
          (nth 1 #hinban_dat$)
          (nth 8 &xdWT)   ; G_WTSET 取付け高さ(ここだけWT図形情報からとる)
          (nth 2 #hinban_dat$)
          (nth 6 #hinban_dat$)
          (nth 3 #hinban_dat$)
          (nth 4 #hinban_dat$)
          (nth 5 #hinban_dat$)
          (nth 7 #hinban_dat$)
					(nth 1 #hinban_dat$)
;         	""             ; 予備2
          ""             ; 予備3
        )
      )
      (setq #WTSET$ (append #WTSET$ (list (length #dim$)))) ; WT穴情報寸法数列個数
      (foreach #dim #dim$
        (setq #WTSET$ (append #WTSET$ (list #dim))) ; 穴寸法
      )
      (CFSetXData &wt "G_WTSET" #WTSET$)
    )
;-- 2011/10/07 A.Satoh Add - S
    (exit)
;-- 2011/10/07 A.Satoh Add - E
  )

;;;;;  (setq #DLOG$
;;;;;;;;01/04/12YM@    (KPW_GetWorkTopInfoDlg &xdWT
;;;;;    (KPW_GetWorkTopInfoDlg_ChSeri &xdWT ; 価格検索ﾎﾞﾀﾝ付き 01/04/12 YM MOD
;;;;;      #WT_HINBAN (fix (+ (nth 3 &xdWTSET) 0.001))
;;;;;      #DF_HINMEI #DF_BIKOU ; 03/01/27 YM ADD
;;;;;    )
;;;;;  ) ; Xdata,名前,価格
;;;;;  (if (= 'LIST (type #DLOG$))
;;;;;    (progn
;;;;;;-- 2011/08/31 A.Satoh Mod - S
;;;;;;      (setq #nWT_FLG 1)                     ; 特注ﾌﾗｸﾞ整数 0:特注 @@@@@@@@@@@@@きめうち 09/22 YM
;;;;;      (setq #nWT_FLG (nth 0 &xdWTSET))
;;;;;;-- 2011/08/31 A.Satoh Mod - E
;;;;;      (setq #sWT_ID (car #DLOG$))           ; 品番文字列
;;;;;
;;;;;      ; 全角ｽﾍﾟｰｽを半角ｽﾍﾟｰｽに置きかえる 01/06/27 YM ADD
;;;;;      (setq #sWT_ID (vl-string-subst "  " "　" #sWT_ID)) ; ﾕｰｻﾞｰ入力品番
;;;;;
;;;;;      (setq #nWT_PRI (float (cadr #DLOG$))) ; 価格結果実数
;;;;;    ); end of progn
;;;;;    ; ﾘｽﾄが取れなかった場合、ｷｬﾝｾﾙされたと判断。quit
;;;;;    (quit)
;;;;;  ); end of if
;;;;;
;;;;;  ;03/01/27 YM ADD-S 品名、備考をXdataに保持する
;;;;;  (setq #HINMEI (nth 2 #DLOG$)) ; 品名
;;;;;  (if (= nil #HINMEI)(setq #HINMEI ""))
;;;;;  (setq #BIKOU  (nth 3 #DLOG$)) ; 備考
;;;;;  (if (= nil #BIKOU)(setq #BIKOU ""))
;;;;;  ;03/01/27 YM ADD-E
;;;;;
;;;;;  ; 獲得されたフラグ、品番、価格、コード（寸法）を拡張データに格納
;;;;;  (if (= (tblsearch "APPID" "G_WTSET") nil) (regapp "G_WTSET"))
;;;;;  (setq #WTSET$
;;;;;    (list
;;;;;      #nWT_FLG       ; G_WTSET 特注フラグ
;;;;;      #sWT_ID        ; G_WTSET 品番文字列
;;;;;      (nth 8 &xdWT)  ; G_WTSET 取付け高さ(ここだけWT図形情報からとる)
;;;;;      #nWT_PRI       ; G_WTSET 価格実数
;;;;;      (nth 4 &xdWTSET) ; 品ｺｰﾄﾞ 01/03/26 YM MOD
;;;;;;-- 2011/06/22 A.Satoh Add - S
;;;;;      (nth 5 &xdWTSET)  ; G_WTSET 巾
;;;;;      (nth 6 &xdWTSET)  ; G_WTSET 高さ
;;;;;      (nth 7 &xdWTSET)  ; G_WTSET 奥行
;;;;;      (nth 8 &xdWTSET)  ; G_WTSET 予備１
;;;;;      (nth 9 &xdWTSET)  ; G_WTSET 予備２
;;;;;      (nth 10 &xdWTSET) ; G_WTSET 予備３
;;;;;;-- 2011/06/22 A.Satoh Add - E
;;;;;    )
;;;;;  )
;;;;;  ; 穴寸法追加
;;;;;  (setq #WTSET$ (append #WTSET$ (list (length #dim$)))) ; WT穴情報寸法数列個数
;;;;;  (foreach #dim #dim$
;;;;;    (setq #WTSET$ (append #WTSET$ (list #dim))) ; 穴寸法
;;;;;  )
;;;;;  (CFSetXData &wt "G_WTSET" #WTSET$)
;;;;;  ;;; 01/01/22 YM ADD
;;;;;  ;;; ｼﾝｸ穴を"G_WRKT"にｾｯﾄする
;;;;;  (if #eSNK$
;;;;;    (progn
;;;;;      (setq #i 0)
;;;;;      (setq #SetXd$ nil)
;;;;;      (repeat (length #eSNK$)
;;;;;        (setq #xd-snk$ (CFGetXData (nth #i #eSNK$) "G_SINK"))
;;;;;        (setq #HOLE (nth 3 #xd-snk$)) ; ｼﾝｸ穴図形名
;;;;;        (if (and #HOLE (/= #HOLE "")) ; "G_WRKT"にｾｯﾄ
;;;;;          (setq #SetXd$ (append #SetXd$ (list (list (+ #i 19) #HOLE))))
;;;;;        );_if
;;;;;        (setq #i (1+ #i))
;;;;;      );repeat
;;;;;      (setq #SetXd$ (cons (list 18 (length #eSNK$)) #SetXd$))
;;;;;
;;;;;      (CFSetXData &wt "G_WRKT"
;;;;;        (CFModList &xdWT #SetXd$)
;;;;;      )
;;;;;    )
;;;;;  );_if
;;;;;
;;;;;  ; 03/01/28 YM ADD-S
;;;;;  (setq #xdWRKT$ (CFGetXData &wt "G_WRKT"))
;;;;;  (CFSetXData &wt "G_WRKT"
;;;;;    (CFModList #xdWRKT$
;;;;;      (list
;;;;;        (list 45 #HINMEI) ;[46]品名
;;;;;        (list 46 #BIKOU)  ;[47]備考
;;;;;      )
;;;;;    )
;;;;;  )
;;;;;  ; 03/01/28 YM ADD-E
;-- 2011/09/19 A.Satoh Mod - E

  (princ)
);PKResetWTSETdim$

;;; <HOM>***********************************************************************************
;;; <関数名>    : KPW_GetWorkTopInfoDlg_ChSeri
;;; <処理概要>  : ワークトップの品番取得ダイアログ
;;; <戻り値>    : (品番  価格)
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      : キャンセル時は"canceled"が返る
;;; ***********************************************************************************>MOH<
(defun KPW_GetWorkTopInfoDlg_ChSeri (
  &WRKT$
  &DF_NAME    ; デフォルトの品番
  &DF_PRICE   ; デフォルトの価格
  &DF_HINMEI  ; デフォルトの品名
  &DF_BIKOU   ; デフォルトの備考
  /
  #RESULT$ #SDCLID #TYPE1 #WTLEN1 #WTLEN2 #WT_DEP1 #WT_DEP2 #WT_T
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KPW_GetWorkTopInfoDlg_ChSeri ////")
  (CFOutStateLog 1 1 " ")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckNum (&sKEY / #val #ret)
    (setq #ret nil)
    (setq #val (read (get_tile &sKEY)))
    (if (= (type (read (get_tile &sKEY))) 'INT)
      (if (<= #val -0.001)
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
;;;01/11/27YM@MOD    (if (= (type (read (get_tile &sKEY))) 'SYM)

; 数値許容 03/01/27 YM MOD-S
;;;    (if (and (= (type (read (get_tile &sKEY))) 'SYM)
;;;            (= (vl-string-search "?" (get_tile &sKEY)) nil)) ; "?"を含んでいない 01/11/27 YM ADD
    (if (= (vl-string-search "?" (get_tile &sKEY)) nil)
; 数値許容 03/01/27 YM MOD-E

      (setq #ret T)
      (progn
        (alert "品番を入力して下さい")
;;;01/11/27YM@MOD        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; 全項目チェック。通れば結果リストに加工して返す。
  (defun ##Check&GetAllVal ( / #DLG$)
    (cond
      ((not (##CheckNum "edtWT_PRI"))  nil) ; 項目にｴﾗｰがあるとnilを返す
      ((not (##CheckStr "edtWT_NAME")) nil) ; 項目にｴﾗｰがあるとnilを返す
      (T ; 項目にｴﾗｰなし
        (setq #DLG$
          (list
            (strcase (get_tile "edtWT_NAME"))  ; 品番 大文字にする
            (atoi (get_tile "edtWT_PRI"))      ; 価格(円)
            ; 03/01/27 YM ADD-S
            (get_tile "edtWT_HINMEI")
            (get_tile "edtWT_BIKOU")
            ; 03/01/27 YM ADD-E
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
  ; 現在の品番に対して価格を検索する 01/04/05 YM
  (defun ##SerchPrice ( / #DLG$ #qry$ #PRICE #WTID)
    (setq #WTid (get_tile "edtWT_NAME"))
    (repeat (strlen #WTid)
      (setq #WTid (vl-string-subst "" "-" #WTid))
    )
    (setq #qry$
      (CFGetDBSQLRec CG_DBSESSION "WT基価格"
        (list (list "品目CD" #WTid 'STR))
      )
    )
    (if (and #qry$ (= (length #qry$) 1))
      (progn
;;;       (setq #price (nth 3 (car #qry$))) ; 価格文字列

        ;2007/10/29 YM MOD 新旧価格を見て区別する
        (cond
          ((= (new_old_kakaku_hantei) "NEW")
            (setq #price (nth 8 (car #qry$))) ; 金額2
          )
          ((= (new_old_kakaku_hantei) "OLD");従来
            (setq #price (nth 3 (car #qry$))) ; 金額
          )
          (T ;従来
            (setq #price (nth 3 (car #qry$))) ; 金額
          )
        );_cond

        ; 価格ﾌﾞﾗﾝｸ対応 01/07/02 YM ADD
        (if (or (= nil #price)(= "" #price))
          (setq #price 0) ; 価格文字列
        );_if
        (set_tile "edtWT_PRI" (itoa (fix (+ #price 0.001))) )
      )
      (mode_tile "edtWT_PRI" 2)
    )
    (princ)
  );##SerchPrice
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))

  (setq #WTLEN1  (itoa (fix (+ (car  (nth 55 &WRKT$)) 0.001)))) ; WT幅1
  (setq #WTLEN2  (itoa (fix (+ (cadr (nth 55 &WRKT$)) 0.001)))) ; WT幅2
  (setq #WT_DEP1 (itoa (fix (+ (car  (nth 57 &WRKT$)) 0.001)))) ; WT奥行き1
  (setq #WT_DEP2 (itoa (fix (+ (cadr (nth 57 &WRKT$)) 0.001)))) ; WT奥行き2
  (setq #WT_T    (itoa (fix (+       (nth 10 &WRKT$)  0.001)))) ; WT厚み

  (if (= nil (new_dialog "GetWorkTopInfoDlg_ChSeriADD" #sDCLID)) (exit)) ; L型用 品名、備考追加
;;; (if (= nil (new_dialog "GetWorkTopInfoDlg_ChSeri" #sDCLID)) (exit)) ; L型用
;;; ﾀｲﾙ初期値設定
  (set_tile "edtWT_NAME" &DF_NAME)
  (set_tile "edtWT_PRI" (itoa &DF_PRICE))

  ; 03/01/27 YM ADD-S
  (set_tile "edtWT_HINMEI" &DF_HINMEI)
  (set_tile "edtWT_BIKOU"  &DF_BIKOU)
  ; 03/01/27 YM ADD-E

  (set_tile "txt11" #WTLEN1)
  (set_tile "txt22" #WTLEN2)
  (set_tile "txt33" #WT_DEP1)
  (set_tile "txt44" #WT_DEP2)
  (set_tile "txt55" #WT_T)
  ; 項目 価格の入力値チェック(0以上の実数かどうか)
  (action_tile "BUTTON"  "(##SerchPrice)")
;;;  (action_tile "edtWT_PRI"  "(##CheckNum \"edtWT_PRI\")")
;;;  (action_tile "edtWT_NAME" "(##CheckStr \"edtWT_NAME\")")
  ; OKボタンが押されたら全項目をチェック。通れば結果リストに加工して返す。
  (action_tile "accept" "(setq #RESULT$ (##Check&GetAllVal))")
  (action_tile "cancel" "(setq #RESULT$ (##Exit))") ; cancel
  (start_dialog)
  (unload_dialog #sDCLID)
  #RESULT$
);KPW_GetWorkTopInfoDlg_ChSeri

;-- 2011/06/23 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : WKP_GetWorkTop_KEIJO
; <処理概要>  : ワークトップ形状決定
; <戻り値>    : 形状ID
; <備考>      : 
;*************************************************************************>MOH<
(defun WKP_GetWorkTop_KEIJO (
  &TYPE     ; 形状タイプ
  &dep$     ; 奥行リスト
  &len$     ; 幅リスト
  /
  #KEIJO
  )

  (cond
    ;Ｉ型判定
		;2018/06/20 YM MOD-S
    ((= &TYPE 0) ;I形状,ﾌﾗｯﾄ含む(人大orｽﾃﾝ)
      (if (and (car &dep$) (< 725.0 (car &dep$)))
        (setq #KEIJO "IPA")
        (setq #KEIJO "I00")
      )
    )
;;;    ((= &TYPE 0) ;I形状,ﾌﾗｯﾄ含む(人大orｽﾃﾝ)
;;;      (if (and (car &dep$) (< 750.0 (car &dep$)))
;;;        (setq #KEIJO "IPA")
;;;        (setq #KEIJO "I00")
;;;      )
;;;    )
		;2018/06/20 YM MOD-E

    ;Ｌ型判定
    ((= &TYPE 1) ;L,ｽﾃﾝ
      (if (cadr &len$)
        (cond
          ((equal (cadr &len$) 1650 0.01)
            (setq #KEIJO "L16")
          )
          ((equal (cadr &len$) 1800 0.01)
            (setq #KEIJO "L18")
          )
          ((equal (cadr &len$) 1950 0.01)
            (setq #KEIJO "L19")
          )
          ((equal (cadr &len$) 2100 0.01)
            (setq #KEIJO "L21")
          )
          (T
            (setq #KEIJO "?")
          )
        )
      )
    )
    (T
      (setq #KEIJO "?")
    )
  );_cond

  #KEIJO
);WKP_GetWorkTop_KEIJO


;<HOM>*************************************************************************
; <関数名>    : WKP_GetWorkTop_SINK_KIGO
; <処理概要>  : シンク記号決定
; <戻り値>    : シンク記号
; <備考>      : 
;*************************************************************************>MOH<
(defun WKP_GetWorkTop_SINK_KIGO (
  &eSNK$
  &eGAS_P5$
  /
  #SINK #xd_SINK$
  )

  (if (< 0 (length &eSNK$))
    (progn ; ｼﾝｸあり
      (if (= 1 (length &eSNK$)) ; ｼﾝｸ1つ
        (if (setq #xd_SINK$ (CFGetXData (car &eSNK$) "G_SINK"))
          (progn
            (setq #SINK (nth 0 #xd_SINK$))
            (setq #SINK (KP_GetSinkKIGO #SINK))
          )
          ;else
          (setq #SINK "?")
        );_if
        ;else
        (setq #SINK "?")
      );_if
    )
    ;else
    (progn ; ｼﾝｸなし
      (if (< 0 (length &eGAS_P5$))
        (setq #SINK "GG") ; ｼﾝｸなしでｶﾞｽあり
        ;else
        (setq #SINK "N") ; ｼﾝｸなしでｶﾞｽなし
      );_if
    )
  );_if

  #SINK
);WKP_GetWorkTop_SINK_KIGO


;<HOM>*************************************************************************
; <関数名>    : WKP_GetWorkTop_SINK_ITI
; <処理概要>  : シンク位置を求める
; <戻り値>    : シンク位置 or nil
; <備考>      : 
;*************************************************************************>MOH<
(defun WKP_GetWorkTop_SINK_ITI (
;-- 2011/09/30 A.Satoh Mod - S
;;;;;  &WRKT$
;;;;;  &eSNK
  &distSink
;-- 2011/09/30 A.Satoh Mod - E
;-- 2011/09/14 A.Satoh Add - S
  &sink$  ; (間口 形状 奥行き シンク記号 コンロ脇寸法)
  &ZaiF   ; 0:人造大理石 1:ステンレス
;-- 2011/09/14 A.Satoh Add - E
	&dan_f  ;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - S
  /
;-- 2011/09/30 A.Satoh Mod - S
;;;;;  #SINK_ITI #Type #WTLR #baseP #tei #WTpt$ #SINKpt$
;;;;;  #p1 #p2 #p3 #p4 #p5 #p6 #distSink
;;;;;;-- 2011/09/14 A.Satoh Add - S
;;;;;  #qry$$ #qry$ #culm
;;;;;;-- 2011/09/14 A.Satoh Add - E
  #SINK_ITI #culm #qry$$ 
;-- 2011/09/30 A.Satoh Mod - E
  )
	;2012/08/02 YM ADD-S ｼﾝｸがないと品番確定できない
	(if (= &distSink nil)
		(setq &distSink 0.0)
	);_if
	;2012/08/02 YM ADD-E ｼﾝｸがないと品番確定できない

  (setq #SINK_ITI nil)

;-- 2011/09/30 A.Satoh Del - S
;;;;;  ;;; シンク脇寸法を求める
;;;;;  (setq #Type  (nth  3 &WRKT$)) ; 形状ﾀｲﾌﾟ
;;;;;  (setq #WTLR  (nth 30 &WRKT$)) ; 左右勝手
;;;;;  (setq #baseP (nth 32 &WRKT$)) ; WT左上点
;;;;;  (setq #tei   (nth 38 &WRKT$))   ; WT底面図形ﾊﾝﾄﾞﾙ
;;;;;  (setq #WTpt$ (GetLWPolyLinePt #tei))
;;;;;  (setq #WTpt$ (GetPtSeries #BaseP #WTpt$)) ; WT底面座標点列を時計周りに
;;;;;  (setq #SINKpt$ (GetLWPolyLinePt &eSNK)) ; シンク外形点列
;;;;;
;;;;;  (cond
;;;;;    ((= #Type 0)  ; I型
;;;;;      (setq #p1 (nth 0 #WTpt$))
;;;;;      (setq #p2 (nth 1 #WTpt$))
;;;;;      (setq #p3 (nth 2 #WTpt$))
;;;;;      (setq #p4 (last  #WTpt$))
;;;;;
;;;;;      ; シンク脇寸法の算出
;;;;;      (cond
;;;;;        ((= #WTLR "R") ; 右勝手のとき
;;;;;          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
;;;;;          (princ "\n★★★　SINK脇= ")(princ #distSink)
;;;;;        )
;;;;;        ((= #WTLR "L") ; 左勝手のとき
;;;;;          (setq #distSink (GetDistLineToPline (list #p1 #p4) #SINKpt$))
;;;;;          (princ "\n★★★　SINK脇= ")(princ #distSink)
;;;;;        )
;;;;;        (T ; それ以外
;;;;;          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
;;;;;          (princ "\n★★★　SINK脇= ")(princ #distSink)
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;    ((= #Type 1)  ; L型
;;;;;      (setq #p1 (nth 0 #WTpt$))
;;;;;      (setq #p2 (nth 1 #WTpt$))
;;;;;      (setq #p3 (nth 2 #WTpt$))
;;;;;      (setq #p4 (nth 3 #WTpt$))
;;;;;      (setq #p5 (nth 4 #WTpt$))
;;;;;      (setq #p6 (nth 5 #WTpt$))
;;;;;
;;;;;      ; シンク脇寸法の算出
;;;;;      (cond
;;;;;        ((= #WTLR "R") ; 右勝手のとき
;;;;;          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
;;;;;          (princ "\n★★★　SINK脇= ")(princ #distSink)
;;;;;        )
;;;;;        ((= #WTLR "L") ; 左勝手のとき
;;;;;          (setq #distSink (GetDistLineToPline (list #p5 #p6) #SINKpt$))
;;;;;          (princ "\n★★★　SINK脇= ")(princ #distSink)
;;;;;        )
;;;;;        (T ; それ以外
;;;;;          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
;;;;;          (princ "\n★★★　SINK脇= ")(princ #distSink)
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;    (T            ; その他(U型)
;;;;;      (setq #distSink 0.0)
;;;;;      (princ "\n★★★　U型特注 SINK脇= ")(princ #distSink)
;;;;;    )
;;;;;  )
;-- 2011/09/30 A.Satoh Del - E

  ; シンク位置を取得する
;-- 2011/09/14 A.Satoh Add - S
  (cond
    ((= &ZaiF 0)  ; 人造大理石
      (setq #culm "人大シンク脇")
    )
    ((= &ZaiF 1)  ; ステンレス
      (setq #culm "ステンシンク脇")
    )
  )

;-- 2012/05/17 A.Satoh Mod 段落ち天板品番確定対応 - S
;;;;;  (setq #qry$$
;;;;;    (CFGetDBSQLRec CG_DBSESSION "規格天板脇寸法"
;;;;;      (list
;;;;;        (list "間口"         (nth 0 &sink$)        'STR)
;;;;;        (list "形状"         (nth 1 &sink$)        'STR)
;;;;;        (list "奥行き"       (nth 2 &sink$)        'STR)
;;;;;        (list "シンク記号"   (nth 3 &sink$)        'STR)
;;;;;;        (list "シンク脇寸法" (rtos #distSink)      'INT)
;;;;;        (list #culm          (rtos &distSink)      'INT)
;;;;;        (list "コンロ脇寸法" (rtos (nth 4 &sink$)) 'INT)
;;;;;      )
;;;;;    )
;;;;;  )
	(if (= &dan_f nil)
		(progn
;;;			(princ "\n★★★　コンロ脇寸法= ")(princ (rtos (nth 4 &sink$)))
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "規格天板脇寸法"
					(list
						(list "間口"         (nth 0 &sink$)        'STR)
						(list "形状"         (nth 1 &sink$)        'STR)
						(list "奥行き"       (nth 2 &sink$)        'STR)
						(list "シンク記号"   (nth 3 &sink$)        'STR)
						(list #culm          (rtos &distSink)      'INT)
						(list "コンロ脇寸法" (rtos (nth 4 &sink$)) 'INT)
					)
				)
			)
		)
		(progn
;;;			(princ (strcat "\n★★★" #culm "= "))(princ (rtos &distSink))
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "規格天板脇寸法"
					(list
						(list "間口"         (nth 0 &sink$)        'STR)
						(list "形状"         (nth 1 &sink$)        'STR)
						(list "奥行き"       (nth 2 &sink$)        'STR)
						(list "シンク記号"   (nth 3 &sink$)        'STR)
						(list #culm          (rtos &distSink)      'INT)
					)
				)
			)
		)
	);_if

	(princ "\n")
	(princ "\n★★★　【規格天板脇寸法】検索KEY")
	(princ "\n---------------------------------------")
	(princ (strcat   "\n間口= "         (nth 0 &sink$)        ))
	(princ (strcat   "\n形状= "         (nth 1 &sink$)        ))
	(princ (strcat   "\n奥行き= "       (nth 2 &sink$)        ))
	(princ (strcat   "\nシンク記号= "   (nth 3 &sink$)        ))
	(princ (strcat   "\n" #culm "= "    (rtos &distSink)      ))
	(if (= &dan_f nil)
		(princ (strcat "\nコンロ脇寸法= " (rtos (nth 4 &sink$)) ))
	);_if
	(princ "\n---------------------------------------")
	(princ "\n")


;-- 2012/05/17 A.Satoh Mod 段落ち天板品番確定対応 - E

  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #qry$ (nth 0 #qry$$))
      (setq #SINK_ITI (nth 3 #qry$))
    )
		(progn
			;2017/01/13 YM ADD 分岐追加
			;複数HITした場合(小間口２口 or ３口)どれかユーザーに尋ねる
			(if (< 1 (length #qry$$))
				(progn
					;;; S2T , S2N , S3S
					(initget 1 "1 2 3 ")
					(setq #WORD (getkword "\n加熱機器形状を指示 /1=2口縦 /2=2口斜め /3=3口 /: "))
				  (cond
						((= #WORD "1")(setq #SINK_ITI "S2T"))
						((= #WORD "2")(setq #SINK_ITI "S2N"))
						((= #WORD "3")(setq #SINK_ITI "S3S"))
						(T
							(setq #SINK_ITI "?")
					 	)
					);_cond
				)
				(progn ;HITしない場合
					(princ "\n★★★　【規格天板脇寸法】HITしない")
    			(setq #SINK_ITI "?")
				)
			);_if
		)
  );_if

  (princ "\n★★★　規格天板ｼﾝｸ脇= ")(princ #SINK_ITI)

;-- 2011/09/14 A.Satoh Add - E

;-- 2011/09/14 A.Satoh Del - S
;;*********************************
;; 暫定処理
;  (setq #SINK_ITI "E")
;;*********************************
;-- 2011/09/14 A.Satoh Del - E

  #SINK_ITI

);WKP_GetWorkTop_SINK_ITI
;-- 2011/06/23 A.Satoh Add - E


;-- 2011/09/30 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : KPW_GetDispSink
; <処理概要>  : シンク脇寸法を算出する
; <戻り値>    : シンク脇寸法値(数値)
; <備考>      : 
;*************************************************************************>MOH<
(defun KPW_GetDispSink (
  &WRKT$
  &eSNK
;-- 2012/05/18 A.Satoh Add 段落ち天板対応 - S
	&dan_f
	&dan_LR
;-- 2012/05/18 A.Satoh Add 段落ち天板対応 - E
  /
  #Type #WTLR #baseP #tei #WTpt$ #SINKpt$ #p1 #p2 #p3 #p4 #distSink
  )

  (setq #Type  (nth  3 &WRKT$)) ; 形状ﾀｲﾌﾟ
  (setq #WTLR  (nth 30 &WRKT$)) ; 左右勝手
  (setq #baseP (nth 32 &WRKT$)) ; WT左上点
  (setq #tei   (nth 38 &WRKT$))   ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #WTpt$ (GetLWPolyLinePt #tei))
  (setq #WTpt$ (GetPtSeries #BaseP #WTpt$)) ; WT底面座標点列を時計周りに
  (setq #SINKpt$ (GetLWPolyLinePt &eSNK)) ; シンク外形点列

  (cond
    ((= #Type 0)  ; I型
      (setq #p1 (nth 0 #WTpt$))
      (setq #p2 (nth 1 #WTpt$))
      (setq #p3 (nth 2 #WTpt$))
      (setq #p4 (last  #WTpt$))

      ; シンク脇寸法の算出
      (cond
        ((= #WTLR "R") ; 右勝手のとき
          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
          (princ "\n★★★　実際のSINK脇= ")(princ #distSink)
        )
        ((= #WTLR "L") ; 左勝手のとき
          (setq #distSink (GetDistLineToPline (list #p1 #p4) #SINKpt$))
          (princ "\n★★★　実際のSINK脇= ")(princ #distSink)
        )
        (T ; それ以外
;-- 2012/05/18 A.Satoh Mod 段落ち天板対応 - S
;;;;;          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
					(if &dan_f
						(if (= &dan_LR "L")
          		(setq #distSink (GetDistLineToPline (list #p1 #p4) #SINKpt$))
							(setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
						)
						(setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
					)
;-- 2012/05/18 A.Satoh Mod 段落ち天板対応 - E
          (princ "\n★★★　実際のSINK脇= ")(princ #distSink)
        )
      )
    )
    ((= #Type 1)  ; L型
      (setq #p1 (nth 0 #WTpt$))
      (setq #p2 (nth 1 #WTpt$))
      (setq #p3 (nth 2 #WTpt$))
      (setq #p4 (nth 3 #WTpt$))
      (setq #p5 (nth 4 #WTpt$))
      (setq #p6 (nth 5 #WTpt$))

      ; シンク脇寸法の算出
      (cond
        ((= #WTLR "R") ; 右勝手のとき
          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
          (princ "\n★★★　実際のSINK脇= ")(princ #distSink)
        )
        ((= #WTLR "L") ; 左勝手のとき
          (setq #distSink (GetDistLineToPline (list #p5 #p6) #SINKpt$))
          (princ "\n★★★　実際のSINK脇= ")(princ #distSink)
        )
        (T ; それ以外
          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
          (princ "\n★★★　実際のSINK脇= ")(princ #distSink)
        )
      )
    )
    (T            ; その他(U型)
      (setq #distSink 0.0)
      (princ "\n★★★　U型特注 SINK脇= ")(princ #distSink)
    )
  )

  #distSink
) ; KPW_GetDispSink
;-- 2011/09/30 A.Satoh Add - E


;-- 2011/08/26 A.Satoh Add - S
;<HOM>*************************************************************************
; <関数名>    : KPW_SetWorkTopInfoDlg
; <処理概要>  : 天板品名確定ダイアログ処理
; <戻り値>    : 天板入力情報リスト or nil
; <備考>      : &hinban_dat$
;             :  引数　：金額→文字列
;             :  戻り値：金額→数値
;
;*************************************************************************>MOH<
(defun KPW_SetWorkTopInfoDlg (
  &hinban_dat$  ; 天板情報リスト
                ; [0] 特注フラグ(整数) 0:特注 1:規格
                ; [1] 品番(文字列)
                ; [2] 金額(文字列)
                ; [3] 巾(文字列)
                ; [4] 高さ(文字列)
                ; [5] 奥行(文字列)
                ; [6] 品名(文字列)
                ; [7] 特注コード(文字列)
	&type					; 形状タイプ　0:I型 1:L型 2:U型
  /
  #dcl_id #ret$
  #TOKU_FLG #WT_HINBAN #WT_PRI #WT_HABA #WT_TAKASA #WT_OKUYUKI #WT_HINMEI #TOKU_CD
  #TOKU1 #TOKU2
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KPW_SetWorkTopInfoDlg ////")
  (CFOutStateLog 1 1 " ")

	;***********************************************************************
	; 所定の文字列に対し、全角が含まれるかをチェックする
	; 戻り値:T 全角あり　nil:半角のみ
	; 文字コードが127(0x80)より大きい場合は全角文字とみなす
	;***********************************************************************
	(defun ##CheckStr (
		&str
		/
		#idx #flg
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; 全項目チェック。通れば結果リストに加工して返す。
  (defun ##GetItemData (
    /
    #hinban #price #hinmei #tokucd #width #height #depth
    #err_flg #data$ #tokucd1 #tokucd2 #flg1 #flg2
    )

    (setq #err_flg nil)

    ; 最終品番チェック
    (setq #hinban (get_tile "edtWT_NAME"))
    (if (or (= #hinban "") (= #hinban nil))
      (progn
        (set_tile "error" "品番が入力されていません")
        (mode_tile "edtWT_NAME" 2)
        (setq #err_flg T)
      )
			(progn
      	(setq #hinban (strcase #hinban))
				(if (> (strlen #hinban) 15)
					(progn
            (set_tile "error" "品番は15桁以下で入力して下さい")
            (mode_tile "edtWT_NAME" 2)
            (setq #err_flg T)
					)
				)
			)
    )

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
                (set_tile "error" "金額は 9999999 以下の整数値を入力して下さい")
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
	      (if (= #TOKU_FLG 1)
					(progn	; 規格天板である場合
						(if (> (strlen #hinmei) 38)
    		      (progn
		            (set_tile "error" "品名は38桁以下で入力して下さい")
		            (mode_tile "edtWT_HINMEI" 2)
    		        (setq #err_flg T)
        		  )
						)
					)
					(progn	; 特注天板である場合
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
							)
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
							(if (= &type 1)	; L型である場合
								(if (>= (read #height) 99999)
									(progn
	  	              (set_tile "error" "高さは 99999 以下の数値を入力して下さい")
  	  	            (mode_tile "edtWT_Height" 2)
    	  	          (setq #err_flg T)
									)
								)

								;2019/03/19 YM MOD
;;;								(if (>= (read #height) 1000)
								(if (>= (read #height) 3000);2019/03/19 YM MOD
									(progn
;;;	                	(set_tile "error" "高さは 1000 未満の数値を入力して下さい")
	                	(set_tile "error" "高さは 3000 未満の数値を入力して下さい");2019/03/19 YM MOD
	  	              (mode_tile "edtWT_Height" 2)
  	  	            (setq #err_flg T)
									)
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
							(if (= &type 1)
								(if (> (read #depth) 1000)
									(progn
	  	              (set_tile "error" "奥行は 1000 未満の数値を入力して下さい")
  	  	            (mode_tile "edtWT_Depth" 2)
    	  	          (setq #err_flg T)
									)
								)
								(if (> (read #depth) 99999)
									(progn
	                	(set_tile "error" "奥行は 99999 以下の数値を入力して下さい")
	  	              (mode_tile "edtWT_Depth" 2)
  	  	            (setq #err_flg T)
									)
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

    ; 規格品である場合の入力差異チェック
    (if (= #err_flg nil)
      (if (= #TOKU_FLG 1)
        (if (or
              (/= #WT_HINBAN  #hinban)   ; 最終品番
              (/= #WT_PRI     #price)    ; 金額
              (/= #WT_HINMEI  #hinmei)   ; 品名
              (/= #TOKU_CD    #tokucd)   ; 特注コード
              (/= #WT_HABA    #width)    ; 巾
              (/= #WT_TAKASA  #height)   ; 高さ
              (/= #WT_OKUYUKI #depth)    ; 奥行き
            )
          (if (= (CFYesNoDialog "内容が変更されていますがよろしいですか？") nil)
            (setq #err_flg T)
          )
        )
      )
    )

    ; 天板情報リストの作成
    (if (= #err_flg nil)
      (progn
        (setq #data$ (list #TOKU_FLG #hinban (atof #price) #width #height #depth #hinmei #tokucd))
        (done_dialog)
        #data$
      )
    )

  ); end of GetItemData
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #TOKU_FLG   (nth 0 &hinban_dat$)) ; 特注フラグ
  (setq #WT_HINBAN  (nth 1 &hinban_dat$)) ; 品番
  (setq #WT_PRI     (nth 2 &hinban_dat$)) ; 金額
  (setq #WT_HABA    (nth 3 &hinban_dat$)) ; 巾
  (setq #WT_TAKASA  (nth 4 &hinban_dat$)) ; 高さ
  (setq #WT_OKUYUKI (nth 5 &hinban_dat$)) ; 奥行
  (setq #WT_HINMEI  (nth 6 &hinban_dat$)) ; 品名
  (setq #TOKU_CD    (nth 7 &hinban_dat$)) ; 特注コード
  (if (/= #TOKU_CD "")
    (progn
      (setq #TOKU1 (substr #TOKU_CD 1 12))
      (setq #TOKU2 (substr #TOKU_CD 14 3))
    )
    (progn
      (setq #TOKU1 "")
      (setq #TOKU2 "")
    )
  )

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))

  (if (= nil (new_dialog "SetWorkTopInfoDlg" #dcl_id)) (exit))

  ; ダイアログタイトル設定
  (if (= #TOKU_FLG 0)
    (set_tile "lab" "特注天板情報入力")
    (set_tile "lab" "天板情報入力")
  )

  ; 初期値設定
;  (if (= #TOKU_FLG 0)
;    (progn  ; 特注
  (set_tile "edtWT_NAME"   #WT_HINBAN)    ; 最終品番
  (set_tile "edtWT_PRI"    #WT_PRI)       ; 金額
  (set_tile "edtWT_HINMEI" #WT_HINMEI)    ; 品名
  (set_tile "edtWT_Toku1"  #TOKU1)        ; 特注コード１
  (set_tile "edtWT_Toku2"  #TOKU2)        ; 特注コード２
  (set_tile "edtWT_Width"  #WT_HABA)      ; 巾
  (set_tile "edtWT_Height" #WT_TAKASA)    ; 高さ
  (set_tile "edtWT_Depth"  #WT_OKUYUKI)   ; 奥行き
  (mode_tile "edtWT_NAME"   0)
  (mode_tile "edtWT_PRI"    0)
  (mode_tile "edtWT_HINMEI" 0)
  (if (= #TOKU_FLG 0)
    (progn  ; 特注
      (mode_tile "edtWT_Toku1"  0)
      (mode_tile "edtWT_Toku2"  0)
    )
    (progn  ; 規格
      (mode_tile "edtWT_Toku1"  1)
      (mode_tile "edtWT_Toku2"  1)
    )
  )
  (mode_tile "edtWT_Width"  0)
  (mode_tile "edtWT_Height" 0)
  (mode_tile "edtWT_Depth"  0)
;    )
;    (progn  ; 規格
;      (set_tile "edtWT_NAME"   #WT_HINBAN)    ; 最終品番
;      (set_tile "edtWT_PRI"    #WT_PRI)       ; 金額
;      (set_tile "edtWT_HINMEI" #WT_HINMEI)    ; 品名
;      (set_tile "edtWT_Toku1"  "")            ; 特注コード１
;      (set_tile "edtWT_Toku2"  "")            ; 特注コード２
;      (set_tile "edtWT_Width"  #WT_HABA)      ; 巾
;      (set_tile "edtWT_Height" #WT_TAKASA)    ; 高さ
;      (set_tile "edtWT_Depth"  #WT_OKUYUKI)   ; 奥行き
;      (mode_tile "edtWT_NAME"   1)
;      (mode_tile "edtWT_PRI"    1)
;      (mode_tile "edtWT_HINMEI" 1)
;      (mode_tile "edtWT_Toku1"  1)
;      (mode_tile "edtWT_Toku2"  1)
;      (mode_tile "edtWT_Width"  1)
;      (mode_tile "edtWT_Height" 1)
;      (mode_tile "edtWT_Depth"  1)
;    )
;  )

  (action_tile "accept" "(setq #ret$ (##GetItemData))")
  (action_tile "cancel" "(setq #ret$ nil)(setq #loop nil)(done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)

  #ret$

);KPW_SetWorkTopInfoDlg
;-- 2011/08/26 A.Satoh Add - E


;-- 2012/05/17 A.Satoh Add 段落ち天板品番確定対応 - S
;<HOM>*************************************************************************
; <関数名>    : KPW_CheckDanotiWorkTopDlg
; <処理概要>  : 段落ち確認ダイアログ処理を行う
; <戻り値>    : 段落ち確認情報リスト or nil
;             :  (天板種類フラグ LR区分)
;             :    天板種類フラグ：T 通常天板  nil 段落ち天板
;             :    ＬＲ区分　："L" 左勝手  "R" 右勝手  "Z" 不明
;             :   例:
;             :     通常天板である場合　(nil "Z")
;             :     段落ち天板である場合 (T "L")
; <備考>      :
;*************************************************************************>MOH<
(defun KPW_CheckDanotiWorkTopDlg (
  /
	#dcl_id #ret$
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KPW_CheckDanotiWorkTopDlg ////")
  (CFOutStateLog 1 1 " ")

	;***********************************************************************
	; 天板種類ラジオボタン選択時のダイアログ制御処理を行う
	; ・通常を選択
	;     左右勝手ラジオボタンの非活性化
	; ・段落ちを選択
	;     左右勝手ラジオボタンの活性化
	;
	; 戻り値: なし
	;***********************************************************************
	(defun ##SetLREnable (
		/
		#Reguler #Danoti
		)

		; エラータイルの初期化
		(set_tile "error" "")

		(setq #Reguler (get_tile "Reguler"))	; 通常
		(setq #Danoti  (get_tile "Danoti"))		; 段落ち

		; 「通常」天板が選択された場合
		(if (= #Reguler "1")
			(progn
				(set_tile "Left" "0")
				(set_tile "Right" "0")
				(mode_tile "Left" 1)
				(mode_tile "Right" 1)
			)
		)

		; 「段落ち」天板が選択された場合
		(if (= #Danoti "1")
			(progn
				(set_tile "Left" "0")
				(set_tile "Right" "0")
				(mode_tile "Left" 0)
				(mode_tile "Right" 0)
			)
		)

  ); end of ##SetLREnable

	;***********************************************************************
	; 段落ち確認ダイアログのＯＫボタン押下処理を行う
	; ・入力チェック
	; ・段落ち確認情報作成
	;
	; 戻り値: 段落ち確認情報リスト
	;           フォーマット：(天板種類フラグ LR区分)
	;             天板種類フラグ：T 段落ち天板  nil 通常天板
	;             LR区分　　　　："L" 左勝手  "R" 右勝手  "Z" 不明
	;***********************************************************************
  (defun ##KPW_CheckDanotiWorkTopDlg_CallBack (
    /
		#err_flg #Reguler #Danoti #Left #Right #dan_f #LR #ret$
    )

    (setq #err_flg nil)

		; 天板種類入力チェック
		(setq #Reguler (get_tile "Reguler"))	; 通常
		(setq #Danoti  (get_tile "Danoti"))		; 段落ち
		(if (and (= #Reguler "0") (= #Danoti "0"))
			(progn
				(set_tile "error" "天板種類が選択されていません")
				(setq #err_flg T)
			)
		)

		; 左右勝手入力チェック
		(if (= #err_flg nil)
			(if (= #Danoti "1")
				(progn
					(setq #Left  (get_tile "Left"))		; Ｌ：左
					(setq #Right (get_tile "Right"))	; Ｒ：右
					(if (and (= #Left "0") (= #Right "0"))
						(progn
							(set_tile "error" "左右勝手が選択されていません")
							(setq #err_flg T)
						)
					)
				)
			)
		)

		; 段落ち確認情報の作成
		(if (= #err_flg nil)
			(progn
				(if (= #Danoti "1")
					(setq #dan_f T)
					(setq #dan_f nil)
				)

				(if (= #dan_f T)
					(if (= #Left "1")
						(setq #LR "L")
						(setq #LR "R")
					)
					(setq #LR "Z")
				)

				(setq #ret$ (list #dan_f #LR))
				(done_dialog)
				#ret$
			)
		)
  ); end of ##KPW_CheckDanotiWorkTopDlg_CallBack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
	(if (= nil (new_dialog "CheckDanotiWorkTopDlg" #dcl_id)) (exit))

	; 操作処理
	(action_tile "Reguler" "(##SetLREnable)")
	(action_tile "Danoti"  "(##SetLREnable)")
	(action_tile "accept"  "(setq #ret$ (##KPW_CheckDanotiWorkTopDlg_CallBack))")
	(action_tile "cancel"  "(setq #ret$ nil)(done_dialog)")

	(start_dialog)

	(unload_dialog #dcl_id)

	#ret$

);KPW_CheckDanotiWorkTopDlg


(princ)
