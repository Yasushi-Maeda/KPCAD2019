;;; 検索用
;;;(defun C:PosSink  　　　　      シンク・水栓の配置コマンド
;;;(defun SKW_OpPosSink2           シンク・水栓の配置関数(配置、変更用)
;;;(defun SKW_GetSinkInfoN         シンク情報、水栓穴情報、水栓種類情報を取得する
;;;(defun KPSelectSinkDlg          シンク選択ダイアログ
;;;(defun PK_MakeG_WTR             円"G_WTR"を作成する
;;;(defun PKW_PosWTR               水栓を配置する
;;;(defun PKWTSinkAnaEmbed         WT図形,ｼﾝｸｼﾝﾎﾞﾙ図形を渡してWTの穴を埋める
;;;(defun SKW_GetSnkCabAreaSym     シンクキャビネットの領域に含まれるシンボル図形を検索する

;;;(defun SKC_ConfSinkChkErr
;;;(defun SKC_GetTopRightBaseCabPt ベースキャビネットの最右の座標を求める
;;;(defun SKW_DelSink              シンク・水栓の削除 ｼﾝｸ変更時、削除に使用
;;;(defun C:ChgSink                シンク・水栓の変更コマンド
;;;(defun PKC_GetSuisenAnaPt       シンク内の水洗穴(PTEN5属性0)位置座標のリスト

;;;(defun PK_CheckExistSuisen      水栓が存在すればTを返すなければnil
;;;(defun PK_GetWTunderSuisen      水栓下のWTを返す
;;;(defun PK_GetPTEN5byPT          水栓下のWTを返す
;;;(defun PcSetWaterTap            水栓設置処理
;;;(defun PcInsSuisen&SetX         図形を挿入、拡張データ設置(当ファイル共通)

;;;<HOM>*************************************************************************
;;; <関数名>    : C:PosSink
;;; <処理概要>  : シンク・水栓の配置コマンド
;;; <戻り値>    :
;;; <作成>      : 1999-10-12
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:PosSink (
  /
  #SFLG #sys$ #PD #pdsize
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:PosSink ////")
  (CFOutStateLog 1 1 " ")

  ;// コマンドの初期化

  (StartUndoErr)
  (CFCmdDefBegin 6);00/09/26 SN ADD

	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)

  (setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "PDSIZE" 10)
  (setvar "pdmode" 34)

; 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn


  ;// シンクの配置
  (SKW_OpPosSink2 0)

;;;03/09/29YM@MOD  ;// 表示画層の設定 ; 00/09/18 YM ADD
;;;03/09/29YM@MOD  (command "_layer"
;;;03/09/29YM@MOD    "F"   "*"                ;全ての画層をフリーズ
;;;03/09/29YM@MOD    "T"   "Z_00*"            ;  Z_00立体ソリッド画層のフリーズ解除
;;;03/09/29YM@MOD    "T"   "N_*"              ;  N_*シンボル原点図形画層のフリーズ解除
;;;03/09/29YM@MOD    "T"   "M_*"              ;  M_*目地領域図形画層の解除
;;;03/09/29YM@MOD    "T"   "0"                ;  "0"画層の解除
;;;03/09/29YM@MOD    "ON"  "M_*"              ;  M_*目地領域図形画層の表示
;;;03/09/29YM@MOD    "OFF" "N_B*" ""          ;  N_B*ブレークライン図形の非表示
;;;03/09/29YM@MOD  )
;;;03/09/29YM@MOD  (command "_.layer" "T" "Z_KUTAI" "") ; 01/04/23 YM ADD
  (SetLayer);03/09/29 YM MOD

  (princ "\nシンクを配置しました.") ;00/01/30 HN ADD メッセージ表示を追加

  ); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
);_if

  (CFCmdDefFinish);00/09/26 SN ADD
  (setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)
  (setq *error* nil)
  (princ)

);C:PosSink

;;;<HOM>*************************************************************************
;;; <関数名>    : SKW_OpPosSink2
;;; <処理概要>  : シンク・水栓の配置
;;; <戻り値>    :
;;; <作成>      : 1999-10-12 04/10 YM 修正 00/05/02 YM 修正
;;; <備考>      : シンク配置、シンク変更コマンドをDelFlgにより区分している
;;;               &DelFlg=0(シンク配置)  &DelFlg=1(シンク変更)
;;;*************************************************************************>MOH<
(defun SKW_OpPosSink2 (
  &DelFlg ;(INT)元のシンク、水栓を削除するかどうかのフラグ ; 0:削除しない 1:削除する
  /
  #ANG #BASEPT #DUM$ #DUMPT$ #G_WTR$ #HDL_SNK #I #KOSU #LOOP #LR #NAME$
  #P1 #P2 #P3 #P4 #PLIS$ #PMEN2 #PTA$ #PTB$ #QRY$ #RET$ #SCAB-EN #SETXD$
  #SINK$ #SKK$ #SNK-EN #SNK_DIM #SPT #SS #SUI$ #SYM$ #W-EN #W-XD$
  #WSFLG #ZAICODE #ZAIF #POCKET
  #WTRSYM$ #retWTR$
;-- 2011/09/16 A.Satoh Add - S
  #width #kikaku_f #toku
;-- 2011/09/16 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKW_OpPosSink2 ////")
  (CFOutStateLog 1 1 " ")

  ;// ワークトップの指示
  (setq #loop T)
  (while #loop
    (setq #w-en (car (entsel "\nワークトップを選択: ")))
    (if #w-en
      (progn
        (setq #w-xd$ (CFGetXData #w-en "G_WRKT"))
        (if (= #w-xd$ nil)
          (CFAlertMsg "ワークトップではありません。")
          (progn ; WTの場合
            (if (CFGetXData #w-en "G_WTSET")
              (progn ; 品番確定済みの場合
                (if (CFYesNoDialog "ワークトップは既に品番確定されています。\n処理を続けますか？")
                  (progn ; YES なら WT穴埋め処理
                  ;;; "G_WTSET"を消す
                    (DelAppXdata #w-en "G_WTSET")
                    (setq #WSflg T) ; 穴埋め必要
                  )
                  (quit) ; NO
                );_if
              )
            );_if
            (setq #loop nil)
          )
        );_if
      )
      (CFAlertMsg "ワークトップではありません。")
    );_if
  )

  ;// 一時的に色を変える
  (PCW_ChColWT #w-en "MAGENTA" nil)
  ;// シンクキャビネットを指示させる
  (setq #loop T)
  (while #loop
    (setq #scab-en (car (entsel "\nシンクキャビネットを選択: ")))
    (if #scab-en
      (progn
        (setq #scab-en (CFSearchGroupSym #scab-en)) ; ｼﾝｸｼﾝﾎﾞﾙ図形名
        (if #scab-en
          (progn
            ;// 検索したキャビネットの性格CODEを取得する
            (setq #skk$ (CFGetSymSKKCode #scab-en nil))
            ;シンクキャビネット
            (if (= (caddr #skk$) CG_SKK_THR_SNK) ;  CG_SKK_THR_SNK defined in GROBAL
              (progn ; ｼﾝｸｷｬﾋﾞだった
                (setq #loop nil)
              )
              (CFAlertMsg "シンクキャビネットではありません")
            );_if
          )
          (CFAlertMsg "シンクキャビネットではありません")
        );_if
      )
      (CFAlertMsg "シンクキャビネットではありません")
    );_if
  );_while

  ;// 色を戻す
  (PCW_ChColWT #w-en "BYLAYER" nil)
;;; 既存のｼﾝｸがあるかどうか検索
  (command "vpoint" "0,0,1")
  (setq #sym$ '())
  ;;; ｼﾝｸ複数考慮 06/27 YM
  (setq #pmen2 (PKGetPMEN_NO #scab-en 2))   ; ｼﾝｸｷｬﾋﾞPMEN2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 #scab-en))   ; PMEN2 を作成
  );_if
  (setq #spt (cdr (assoc 10 (entget #scab-en)))) ; ｼﾝﾎﾞﾙ基点
  (setq #ptA$ (GetLWPolyLinePt #pmen2))     ; ｼﾝｸｷｬﾋﾞPMEN2 外形領域
  (setq #dumpt$ (GetPtSeries #spt #ptA$))   ; #BASEPT を先頭に時計周り (00/05/20 YM)
  (if #dumpt$
    (setq #ptA$ #dumpt$) ; nil でない
    (progn ; 外形点列上にｼﾝﾎﾞﾙがない場合
      (setq #BASEPT (PKGetBaseI4 #ptA$ (list #scab-en))) ; 点列とｼﾝﾎﾞﾙ基点１つ (00/05/20 YM)
      (setq #ptA$ (GetPtSeries #BASEPT #ptA$))           ; #BASEPT を先頭に時計周り (00/05/20 YM)
    )
  );_if

  (setq #p1 (nth 0 #ptA$))
  (setq #p2 (nth 1 #ptA$))
  (setq #p3 (nth 2 #ptA$))
  (setq #p4 (nth 3 #ptA$))
  ;;; D750 WT対応100mm後方に拡大 00/07/03 YM ADD
  (setq #ang (nth 2 (CFGetXData #scab-en "G_LSYM"))) ; 配置角度
  (setq #p1 (polar #p1 (+ #ang (dtr 90)) 100))
  (setq #p2 (polar #p2 (+ #ang (dtr 90)) 100))
  (setq #ptB$ (list #p1 #p2 #p3 #p4 #p1))
  (setq #hdl_SNK (PKGetSinkSymBySinkCabCP #scab-en)) ; ｼﾝｸｷｬﾋﾞ領域に含まれるｼﾝｸを検索する
  (setq #sym$ (PKGetSinkSuisenSymCP #ptB$))          ; ｼﾝｸ,水栓ｼﾝﾎﾞﾙ図形名ﾘｽﾄ

  (if (= &DelFlg 0)
    (if (> (length #sym$) 0) ; ｼﾝｸ+水栓

;;;01/03/23YM@      (if (CFYesNoDialog "既存のシンクを削除しますか？")
;;;01/03/23YM@        (progn
;;;01/03/23YM@          (if #WSflg         ; 穴埋め必要
;;;01/03/23YM@            (PKWTSinkAnaEmbed #w-en #hdl_SNK T) ; WT図形,ｼﾝｸｼﾝﾎﾞﾙ図形を渡してWTの穴を埋める
;;;01/03/23YM@          );_if
;;;01/03/23YM@
;;;01/03/23YM@          (foreach #sym #sym$
;;;01/03/23YM@            (setq #ss (CFGetSameGroupSS #sym))
;;;01/03/23YM@            (command "_erase" #ss "")    ; ｼﾝｸ、水栓を削除する
;;;01/03/23YM@          )
;;;01/03/23YM@        ;;; 領域に含まれる水栓穴"G_WTR"ﾘｽﾄ
;;;01/03/23YM@          (setq #G_WTR$ (PKGetG_WTRCP #ptB$))
;;;01/03/23YM@          (foreach #G_WTR #G_WTR$
;;;01/03/23YM@            (command "_erase" #G_WTR "") ; "G_WTR"を削除する
;;;01/03/23YM@          )
;;;01/03/23YM@        )
;;;01/03/23YM@        (progn
;;;01/03/23YM@          (CFAlertMsg "シンクが既に存在するため配置しませんでした。")
;;;01/03/23YM@          (*error*)
;;;01/03/23YM@        )
;;;01/03/23YM@      );_if
      (progn
        (CFAlertMsg "シンクが存在します。")
        (*error*)
      )
    );_if
  );_if

  (if (= &DelFlg 1)
    (progn
      (SKW_DelSink #WSflg #scab-en #w-en #w-xd$) ; 穴埋めﾌﾗｸﾞ,ｼﾝｸｷｬﾋﾞｼﾝﾎﾞﾙ図形名,WT図形名,"G_WRKT"
      ;;; 領域に含まれる水栓穴"G_WTR"ﾘｽﾄ
      (setq #G_WTR$ (PKGetG_WTRCP #ptB$))
      (foreach #G_WTR #G_WTR$
        (command "_erase" #G_WTR "") ; "G_WTR"を削除する
      )
    )
  );_if

  (command "zoom" "p")
  (setq #ZaiCode   (nth 2 #w-xd$))  ;材質記号
  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ
  ;// WTシンクのﾚｺｰﾄﾞを取得する ｼﾝｸ,水栓情報
;-- 2012/04/20 A.Satoh Add シンク配置不具合対応 - S
;;;;;  (setq #ret$ (SKW_GetSinkInfoN #w-xd$ #scab-en #ZaiCode #ZaiF))

;;;	(CFAlertMsg "★（１）★ ＜PG改修＞ SKW_GetSinkInfoN【シンク候補絞込み】ERRMSG.INIを見に行く") ;2017/01/19 YM ADD

  (setq #ret$ (SKW_GetSinkInfoN #w-xd$ #scab-en #ZaiCode #ZaiF #w-en))
;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 - E
  (if (= #ret$ nil)
    (*error*) ; cancelの場合
    (progn
      (setq #sink$   (nth 0 #ret$)) ; 0:選択された"SINK位置" ﾚｺｰﾄﾞ
      (setq #name$   (nth 1 #ret$)) ; 1:選択された"WTシンク" ﾚｺｰﾄﾞ
      (setq #SNK_DIM (nth 2 #ret$)) ; 2:選択されたｼﾝｸ脇寸法
      (setq #LR      (nth 3 #ret$)) ; 3:選択されたｼﾝｸﾀｲﾌﾟLRZ
      (setq #sui$    (nth 4 #ret$)) ; 4:選択された"WT水栓穴" ﾚｺｰﾄﾞ
      (setq #plis$   (nth 5 #ret$)) ; 5:選択された"WT水栓管" ﾚｺｰﾄﾞ (属性 -2,-1,0,1,2 の順) nil あり
      (setq #pocket  (nth 6 #ret$)) ; 6:ｼﾝｸﾎﾟｹｯﾄ有無"Y" or "N"
;-- 2011/09/17 A.Satoh Add - S
      (setq #width   (nth 7 #ret$)) ; ｼﾝｸｷｬﾋﾞｾﾝﾀｰ位置変更前
;-- 2011/09/17 A.Satoh Add - E
      ;// Ｏスナップ関連システム変数の解除
      (CFNoSnapStart)
      ;// 選択された情報を元にシンク及び水栓、浄水器などを配置する
      (setq #snk-en            ;(ENAME)シンク基点図形
        (KPW_PosSink2
          #name$
          #scab-en             ;(ENAME)ｼﾝｸｷｬﾋﾞ基点図形
          #w-xd$               ;(LIST)WT拡張データ
          #SNK_DIM             ;(REAL)Ｗ方向ｵﾌｾｯﾄ(ｼﾝｸ脇寸法)
          #LR                  ;ｼﾝｸﾀｲﾌﾟLRZ
          #ZaiF                ;素材F
          #pocket              ;ｼﾝｸﾎﾟｹｯﾄ有無"Y" or "N"
;-- 2011/09/17 A.Satoh Add - S
          #width               ;ｼﾝｸｷｬﾋﾞｾﾝﾀｰ位置変更前
;-- 2011/09/17 A.Satoh Add - E
        )
      ); end of setq
      ;;; ｼﾝｸの配置終了

;2014/08/11 YM ADD-S
(KcSetSinkG_OPT_KPCAD #snk-en #ZaiCode (nth 1 #name$)) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ
;2014/08/11 YM ADD-E

      (if (not (tblsearch "APPID" "G_SINK")) (regapp "G_SINK"))

; 01/07/17 YM ADD PKW_PosWTRの戻り値追加
;;;(list #WtrHoleEn$ #WTRSYM$) (水栓穴(G_WTR)底面図形,水栓SYM)

      ;// 水栓関連の配置
      (setq #retWTR$
        (PKW_PosWTR
          (nth 0 #w-xd$)       ;(STR)工種記号 "K"
          (nth 1 #w-xd$)       ;(STR)SERIES記号
          #snk-en              ;(ENAME)シンク図形
          (nth 1 #name$)       ;(STR)シンク記号 "K"
          #plis$               ;選択された"WT水栓管" ﾚｺｰﾄﾞ (属性 -2,-1,0,1,2 の順) nil あり
;-- 2011/09/18 A.Satoh Add - S
          #scab-en             ;(ENAME)ｼﾝｸｷｬﾋﾞ基点図形
          (nth 9 #name$)       ; 規格穴属性
;-- 2011/09/18 A.Satoh Add - E
        )
      )

      (setq #g_wtr$  (car  #retWTR$)) ; 戻り値 "G_WTR"
      (setq #WTRSYM$ (cadr #retWTR$)) ; 戻り値 水栓SYMﾘｽﾄ
;-- 2011/09/17 A.Satoh Add - S
      (setq #kikaku_f (caddr #retWTR$))
;-- 2011/09/17 A.Satoh Add - E

;;;00/12/20YM@      ;;; シンク穴記号を検索し、"G_SINK"に入れる
;;;00/12/20YM@      (setq #SNKANA_rec$ ; １つ引き当て
;;;00/12/20YM@        (CFGetDBSQLRec CG_DBSESSION "SINK穴記"
;;;00/12/20YM@          (list
;;;00/12/20YM@            (list "シンク記号" (nth 1 #name$) 'STR)
;;;00/12/20YM@            (list "水栓穴記号" (nth 1 #sui$)  'STR)
;;;00/12/20YM@          )
;;;00/12/20YM@        )
;;;00/12/20YM@      );_(setq
;;;00/12/20YM@      (setq #SNKANA_rec$ (DBCheck #SNKANA_rec$ "『シンク穴記』" "SKW_OpPosSink2")) ; nil or 複数時 ｴﾗｰ

      (CFSetXData #snk-en "G_SINK"
        (list
          (nth 1 #name$)  ; シンク記号
;-- 2011/06/29 A.Satoh Mod - S
;          (nth 1 #sui$)   ; 水栓穴記号
          (if #sui$
            (nth 1 #sui$)   ; 水栓穴記号
            ""
          )
;-- 2011/06/29 A.Satoh Mod - E
          (if (= #pocket "Y")
            1             ; ｼﾝｸﾎﾟｹｯﾄの有 1
            0             ; ｼﾝｸﾎﾟｹｯﾄの無 0
          );_if
          ""              ; シンク穴図形ハンドル(品番確定時)
        )
      );_CFSetXData

      ;;; ｼﾝｸ側面図形の移動 01/02/16 YM
      (PKC_MoveToSGCabinetSub #snk-en #scab-en) ; (ｼﾝｸ or 水栓 , ｼﾝｸｷｬﾋﾞ)

      ; 水栓は移動しない
;;;     ; 01/07/17 YM ADD 水栓も側面図移動 START
;;;     (foreach #WTRSYM #WTRSYM$
;;;       (PKC_MoveToSGCabinetSub #WTRSYM #scab-en) ; (ｼﾝｸ or 水栓 , ｼﾝｸｷｬﾋﾞ)
;;;     )
      ; 01/07/17 YM ADD 水栓も側面図移動 END

      ;// 水栓穴関連の拡張データを更新設定する 07/06 YM 削除してない水栓穴は残す処理を追加
      (setq #w-xd$ (CFGetXData #w-en "G_WRKT"))
;-- 2011/09/09 A.Satoh Del - S
;      (setq #i 23)
;      (repeat (nth 22 #w-xd$)
;        (if (/= (nth #i #w-xd$) "")
;          (if (entget (nth #i #w-xd$)); 無効な図形名でない
;            (setq #dum$ (append #dum$ (list (nth #i #w-xd$)))) ; 削除していないので残す"G_WTR"
;          );_if
;        );_if
;        (setq #i (1+ #i))
;      )
;
;      (if (> (length #g_wtr$) 0) ; 新しく配置した水栓穴の数
;        (foreach #en #g_wtr$
;          (setq #dum$ (append #dum$ (list #en)))
;        )
;      );_if
;      (setq #kosu (length #dum$))
;      (if (> 7 (length #dum$))
;        (repeat (- 7 (length #dum$)) (setq #dum$ (append #dum$ (list ""))))
;      );_if
;-- 2011/09/09 A.Satoh Del - E

;-- 2011/09/17 A.Satoh Add - S
      (if (= #kikaku_f T)
        (setq #toku "")
        (setq #toku "TOKU")
      )
;-- 2011/09/17 A.Satoh Add - E
      (setq #setxd$
        (list
;-- 2011/09/09 A.Satoh Mod - S
;          (list 22 #kosu)
;          (list 23 (nth 0 #dum$))
;          (list 24 (nth 1 #dum$))
;          (list 25 (nth 2 #dum$))
;          (list 26 (nth 3 #dum$))
;          (list 27 (nth 4 #dum$))
;          (list 28 (nth 5 #dum$))
;          (list 29 (nth 6 #dum$))
          (list 22 0)
          (list 23 "")
          (list 24 "")
          (list 25 "")
          (list 26 "")
          (list 27 "")
          (list 28 "")
          (list 29 "")
;-- 2011/09/09 A.Satoh Mod - E
;-- 2011/09/17 A.Satoh Add - S
          (list 58 #toku)
;-- 2011/09/17 A.Satoh Add - E
        )
      )
      ;// ワークトップ拡張データの更新
      (setq #w-xd$ (CFGetXData #w-en "G_WRKT"))
      (CFSetXData #w-en "G_WRKT"
        (CFModList #w-xd$ #setxd$)
      )
      (CFNoSnapFinish)
    )
  );_if
  (princ)
);SKW_OpPosSink2

;;; <HOM>***********************************************************************************
;;; <関数名>    : KP_SrcWTcolTbl
;;; <処理概要>  : WTｶﾗｰﾃｰﾌﾞﾙを検索し、「材質」を取得する
;;; <戻り値>    : 「材質」="G"
;;; <作成>      : 01/07/03 YM SKｼﾘｰｽﾞ用
;;; <備考>      :
;;; ***********************************************************************************>MOH<
(defun KP_SrcWTcolTbl ( &ZAICODE / #QRY$)
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "WTCOLOR"
      (list (list "材質記号" &ZAICODE 'STR))
    )
  )
  (if #qry$
    (nth 2 (car #qry$))
    "F"
  );_if
);KP_SrcWTcolTbl

;;;<HOM>*************************************************************************
;;; <関数名>    : KPSelectSinkDlg
;;; <処理概要>  : シンク選択ダイアログ
;;; <戻り値>    : (list #sink$ #name$ #SNK_DIM #LR)
;;;                 "SINK位置","WTシンク",ｼﾝｸ脇寸法,ｼﾝｸLRZ
;;; <作成>      : 2000.5.2 YM 新規作成 00/09/21 標準化
;;; <備考>      : DB変更 ｼﾝｸｷｬﾋﾞによりｼﾝｸを絞り込み、ｼﾝｸが決まると位置が絞れる
;;;  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;  !!! 子供の 関数　defun 定義順、local変数未定義 or 定義は重要   変更は要注意 !!!
;;;  !!! #sui$$ の初期化 #sui$,#snk の値重要                                     !!!
;;;  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;; 07/22 plis1,2,3 「水栓あり」で水栓がすべて「なし」の場合、999をセット
;;;*************************************************************************>MOH<
(defun KPSelectSinkDlg (
  &XD_WRKT   ; "G_WRKT"
  &ZAIF      ; 素材F
  &SNKCAB_LR ; ｼﾝｸｷｬﾋﾞLR区分 ; 0/12/14 YM MOD
  &sink$     ;(LIST)SINK位置テーブルの内容→★2011/09/14 ｼﾝｸ記号のみのﾘｽﾄに変更
  &name$$    ;(LIST)WTシンクテーブルの内容
;-- 2011/09/15 A.Satoh Add - S
  &CAB       ; シンクキャビネット図形名
;-- 2011/09/15 A.Satoh Add - E
  /
  #DCL_ID #DIM #I #J #RET$ #lst
  #HINBAN$$
  #POP1 #POP2 #POP3 #POP4 #POP5
  #plis1$ #plis2$ #plis3$ #plis4$ #plis5$
  #RET$ #SNK #sui$ #sui$$ #dimST #dimRP
  #dum$$ #i0 #dum #i1 #i2
  #DIMA #DIMST$ #dimRP$ #FOCUS #NMAG1 #NMAG2 #WT_TYPE #ZAIF #dimA$
  #POP1FLG #POP2FLG #POP3FLG #POP4FLG #POP5FLG ; 01/03/30YM ADD
;-- 2011/09/16 A.Satoh Add - S
#xd_G_LSYM$ #hinban #LR #youto #qry$$ #width #mode_f$
;-- 2011/09/16 A.Satoh Add - E
#umu_LR  ;-- 2012/05/18 A.Satoh Add LR有無制御不正
#WIDTH_CAB #WIDTH_SP ;2017/01/19 YM ADD
  )

  ;2011/09/14 YM ADD-S
  (setq #SNK_KATTE (nth 30 &XD_WRKT));ｼﾝｸ勝手
  ;2011/09/14 YM ADD-S

;;; (if (equal &ZAIF 1 0.1) ; 素材F
;;;   (setq #i0 3)  ; ｽﾃﾝﾚｽ
;;;   (setq #i0 13) ; 人大
;;; );_if
;;; (setq #i0 3)  ; ｽﾃﾝﾚｽ
  (setq #i1 2)  ; ｽﾃﾝﾚｽ
  (setq #i2 12) ; 人大


  (setq #nMAG1 (itoa (fix (+ (car  (nth 55 &XD_WRKT)) 0.1))))
  (setq #nMAG2 (itoa (fix (+ (cadr (nth 55 &XD_WRKT)) 0.1))))

  (setq #ZaiF (itoa (fix &ZaiF)))
  (cond
    ((= (nth 3 &XD_WRKT) 0)(setq #WT_type "I")) ; I型
    ((= (nth 3 &XD_WRKT) 1)
      (setq #WT_type "L")
    ) ; L型
    ((= (nth 3 &XD_WRKT) 2)(setq #WT_type "U")) ; U型
    (T (setq #WT_type nil))
  );_cond

;;;2011/09/14YM@DEL    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;2011/09/14YM@DEL    ; 標準ｼﾝｸ脇寸法を求める
;;;2011/09/14YM@DEL    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;2011/09/14YM@DEL    (defun ##GetDimA (
;;;2011/09/14YM@DEL      &snk  ; ｼﾝｸ記号
;;;2011/09/14YM@DEL      /
;;;2011/09/14YM@DEL      #qry$ #DimA
;;;2011/09/14YM@DEL      )
;;;2011/09/14YM@DEL      (setq #DimA nil)
;;;2011/09/14YM@DEL      (setq #qry$
;;;2011/09/14YM@DEL        (CFGetDBSQLRec CG_DBSESSION "標準WT寸法"
;;;2011/09/14YM@DEL          (list
;;;2011/09/14YM@DEL            (list "間口1"      #nMAG1   'INT)
;;;2011/09/14YM@DEL            (list "間口2"      #nMAG2   'INT)
;;;2011/09/14YM@DEL            (list "WT形状"     #WT_type 'STR)
;;;2011/09/14YM@DEL;;;           (list "タイプ"     (nth 4 &XD_WRKT) 'STR)
;;;2011/09/14YM@DEL            (list "素材F"      #ZaiF    'INT)
;;;2011/09/14YM@DEL            (list "シンク記号" &snk     'STR)
;;;2011/09/14YM@DEL          )
;;;2011/09/14YM@DEL        )
;;;2011/09/14YM@DEL      )
;;;2011/09/14YM@DEL      (if #qry$
;;;2011/09/14YM@DEL        (progn
;;;2011/09/14YM@DEL          ; 02/08/30 YM ADD-S ﾐｶﾄﾞR付天板対応
;;;2011/09/14YM@DEL          ; 間口2400mmのときｻｰｸﾙﾀｲﾌﾟ("ISC")ｽﾃｰｼﾞﾀｲﾌﾟ("IAR")で規格品のｼﾝｸ脇が異なる
;;;2011/09/14YM@DEL          (if (= 1 (nth 33 &XD_WRKT))
;;;2011/09/14YM@DEL            (progn ; R付き天板だった
;;;2011/09/14YM@DEL              ; 02/11/27 YM MOD ｼﾘｰｽﾞ記号材質記号の桁数=1,2桁に対応
;;;2011/09/14YM@DEL;;;             (setq #Rtype (substr (nth 34 &XD_WRKT) 1 7)) ; WT品番からWT種類を取得
;;;2011/09/14YM@DEL
;;;2011/09/14YM@DEL              ; 02/11/27 YM MOD-S
;;;2011/09/14YM@DEL              (setq #num1 (strlen CG_SeriesCode))    ; ｼﾘｰｽﾞ記号文字数
;;;2011/09/14YM@DEL              (setq #num2 (strlen (nth 2 &XD_WRKT))) ; 材質記号文字数
;;;2011/09/14YM@DEL              (setq #Rtype (substr (nth 34 &XD_WRKT) 1 (+ #num1 #num2 3))) ; WT品番からWT種類を取得
;;;2011/09/14YM@DEL              ; 02/11/27 YM MOD-E
;;;2011/09/14YM@DEL
;;;2011/09/14YM@DEL              (setq #dum$ nil)
;;;2011/09/14YM@DEL              (foreach qry #qry$
;;;2011/09/14YM@DEL                (if (= (nth 4 qry) #Rtype)
;;;2011/09/14YM@DEL                  (setq #dum$ (append #dum$ (list qry))) ; WTﾀｲﾌﾟが同じであるﾚｺｰﾄﾞに絞る
;;;2011/09/14YM@DEL                );_if
;;;2011/09/14YM@DEL              )
;;;2011/09/14YM@DEL              (setq #qry$ #dum$) ; 絞り込んだものに置き換え
;;;2011/09/14YM@DEL            )
;;;2011/09/14YM@DEL          );_if
;;;2011/09/14YM@DEL          ; 02/08/30 YM ADD-E ﾐｶﾄﾞR付天板対応
;;;2011/09/14YM@DEL
;;;2011/09/14YM@DEL          ; 02/11/15 YM ADD ｻｰｸﾙﾀｲﾌﾟで特注間口のときﾌﾘｰｽﾞする
;;;2011/09/14YM@DEL          ; #qry$=nilなら#DimA=nilを返す
;;;2011/09/14YM@DEL          (if (/= nil #qry$)
;;;2011/09/14YM@DEL            (setq #DimA (nth 7 (car #qry$))) ; 寸法A
;;;2011/09/14YM@DEL            (setq #DimA nil)                 ; 寸法A
;;;2011/09/14YM@DEL          );_if
;;;2011/09/14YM@DEL        )
;;;2011/09/14YM@DEL      );_if
;;;2011/09/14YM@DEL      #DimA
;;;2011/09/14YM@DEL    );##GetDimA


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/09/17 A.Satoh Del - E
;;;;;(defun ##SUISENpop ( ; ; 水栓品番ﾘｽﾄの変更
;;;;;;;; &snk  ; ｼﾝｸ記号
;;;;;;;; &sui$ ; WT水栓穴N ﾚｺｰﾄﾞ
;;;;;;;; #sui$ #snk #plis?$ をﾛｰｶﾙ変数定義してはならぬ
;;;;;  /
;;;;;  #i #dim #HINBAN$$ #HINBAN$ #plis #lis$
;;;;;  #DIMDR #HINBANDR$$ #HINBANDR$ #LAB
;;;;;  )
;;;;;;---------------------------------------------------
;;;;;; 文字列を15文字にそろえる(末尾に空白を追加する)
;;;;;;---------------------------------------------------
;;;;;  (defun ##Len15 ( &str / #LEN #ret)
;;;;;
;;;;;    ;07/08/22 YM ADD "()"を外す
;;;;;    (setq &str (KP_DelHinbanKakko &str))
;;;;;
;;;;;    (setq #len (strlen &str) #ret &str)
;;;;;    (repeat (- 15 #len)
;;;;;      (setq #ret (strcat #ret " "))
;;;;;    )
;;;;;    #ret
;;;;;  );##Len15
;;;;;;--------------------------------------------
;;;;;
;;;;;  (setq #i 3)
;;;;;  (setq #POP1 nil #POP2 nil #POP3 nil #POP4 nil #POP5 nil)
;;;;;  (setq #plis1$ '() #plis2$ '() #plis3$ '() #plis4$ '() #plis5$ '())
;;;;;
;;;;;  (repeat 10
;;;;;    (setq #dim (nth #i #sui$)) ; 穴1,2,...10
;;;;;    (if (/= #dim nil) ; -2,-1,0,1,2
;;;;;      (progn
;;;;;        (setq #HINBAN$$ ; 複数引き当て
;;;;;          (CFGetDBSQLRec CG_DBSESSION "WT水栓管"
;;;;;            (list
;;;;;              (list "水栓穴属性" (itoa (fix #dim)) 'INT)
;;;;;              (list "シンク記号" #snk 'STR) ; 初期シンク記号
;;;;;            )
;;;;;          )
;;;;;        );_(setq
;;;;;
;;;;;        (if #HINBAN$$
;;;;;          (progn
;;;;;            ;;; 水栓左 -1 ;;;
;;;;;            (cond
;;;;;              ((equal #dim -1  0.001)
;;;;;                (setq #lab "suiL")
;;;;;                (start_list #lab 3)
;;;;;                (add_list "な　し")
;;;;;                (foreach #HINBAN$ #HINBAN$$
;;;;;                  (setq #plis (strcat (##Len15 (nth 3 #HINBAN$)) (nth 4 #HINBAN$) " "))
;;;;;                  (setq #plis1$ (append #plis1$ (list #HINBAN$)))
;;;;;                  (add_list #plis)
;;;;;                )
;;;;;                (end_list)
;;;;;                (setq #pop1 T)
;;;;;              )
;;;;;              ;;; 水栓右 -2 ;;;
;;;;;              ((equal #dim -2 0.001)
;;;;;                (setq #lab "suiR") ; 通常
;;;;;                (start_list #lab 3)
;;;;;                (add_list "な　し")
;;;;;                (foreach #HINBAN$ #HINBAN$$
;;;;;                  (setq #plis (strcat (##Len15 (nth 3 #HINBAN$)) (nth 4 #HINBAN$) " "))
;;;;;                  (setq #plis2$ (append #plis2$ (list #HINBAN$)))
;;;;;                  (add_list #plis)
;;;;;                )
;;;;;                (end_list)
;;;;;                (setq #pop2 T)
;;;;;              )
;;;;;              ;;; 水栓 0 ;;;
;;;;;              ((equal #dim 0  0.001)
;;;;;                (start_list "sui" 3)
;;;;;                (add_list "な　し")
;;;;;                (foreach #HINBAN$ #HINBAN$$
;;;;;                  (setq #plis (strcat (##Len15 (nth 3 #HINBAN$)) (nth 4 #HINBAN$) " "))
;;;;;                  (setq #plis3$ (append #plis3$ (list #HINBAN$)))
;;;;;                  (add_list #plis)
;;;;;                )
;;;;;                (end_list)
;;;;;                (setq #pop3 T)
;;;;;              )
;;;;;              ;;; ｵﾌﾟｼｮﾝ左 1 ;;;
;;;;;              ((equal #dim 1  0.001)
;;;;;                (start_list "opL" 3)
;;;;;                (add_list "な　し")
;;;;;                (foreach #HINBAN$ #HINBAN$$
;;;;;                  (setq #plis (strcat (##Len15 (nth 3 #HINBAN$)) (nth 4 #HINBAN$)))
;;;;;                  (setq #plis4$ (append #plis4$ (list #HINBAN$)))
;;;;;                  (add_list #plis)
;;;;;                )
;;;;;                (end_list)
;;;;;                (setq #pop4 T)
;;;;;              )
;;;;;              ;;; ｵﾌﾟｼｮﾝ右 2 ;;;
;;;;;              ((equal #dim 2  0.001)
;;;;;                (start_list "opR" 3)
;;;;;                (add_list "な　し")
;;;;;                (foreach #HINBAN$ #HINBAN$$
;;;;;                  (setq #plis (strcat (##Len15 (nth 3 #HINBAN$)) (nth 4 #HINBAN$)))
;;;;;                  (setq #plis5$ (append #plis5$ (list #HINBAN$)))
;;;;;                  (add_list #plis)
;;;;;                )
;;;;;                (end_list)
;;;;;                (setq #pop5 T)
;;;;;              )
;;;;;            );_cond
;;;;;          )
;;;;;        );_if
;;;;;
;;;;;      )
;;;;;    );_if
;;;;;    (setq #i (1+ #i))
;;;;;  );_repeat
;;;;;
;;;;;  (set_tile  "suiL" "0")
;;;;;  (set_tile  "suiR" "0")
;;;;;  (set_tile  "sui" "0")
;;;;;  (set_tile  "opL" "0")
;;;;;  (set_tile  "opR" "0")
;;;;;
;;;;;;;;01/07/06YM@  (if (= #pop1 nil) ; -1
;;;;;;;;01/07/06YM@    (mode_tile "suiL" 1) ; 使用不可
;;;;;;;;01/07/06YM@    (mode_tile "suiL" 0) ; 使用可
;;;;;;;;01/07/06YM@  )
;;;;;;;;01/07/06YM@  (if (= #pop2 nil) ; -2
;;;;;;;;01/07/06YM@    (mode_tile "suiR" 1) ; 使用不可
;;;;;;;;01/07/06YM@    (mode_tile "suiR" 0)   ; 使用可
;;;;;;;;01/07/06YM@  )
;;;;;;;;01/07/06YM@  (if (= #pop3 nil) ; 0
;;;;;;;;01/07/06YM@    (mode_tile "sui" 1) ; 使用不可
;;;;;;;;01/07/06YM@    (mode_tile "sui" 0)   ; 使用可
;;;;;;;;01/07/06YM@  )
;;;;;;;;01/07/06YM@  (if (= #pop4 nil) ; 1
;;;;;;;;01/07/06YM@    (mode_tile "opL" 1) ; 使用不可
;;;;;;;;01/07/06YM@    (mode_tile "opL" 0)   ; 使用可
;;;;;;;;01/07/06YM@  )
;;;;;;;;01/07/06YM@  (if (= #pop5 nil) ; 2
;;;;;;;;01/07/06YM@    (mode_tile "opR" 1) ; 使用不可
;;;;;;;;01/07/06YM@    (mode_tile "opR" 0)   ; 使用可
;;;;;;;;01/07/06YM@  )
;;;;;
;;;;;  (if (= #pop1 nil) ; -1
;;;;;    (progn
;;;;;      (if #pop1flg
;;;;;        (progn
;;;;;          (start_list "suiL" 1 0) ;リストの 1 番目の項目を変更します。
;;;;;          (add_list "")
;;;;;          (end_list)
;;;;;        )
;;;;;      );_if
;;;;;      (mode_tile "suiL" 1) ; 使用不可
;;;;;    )
;;;;;    (progn
;;;;;      (mode_tile "suiL" 0) ; 使用可
;;;;;      (setq #pop1flg T)
;;;;;    )
;;;;;  );_if
;;;;;  (if (= #pop2 nil) ; -2
;;;;;    (progn
;;;;;      (if #pop2flg
;;;;;        (progn
;;;;;          (start_list "suiR" 1 0) ;リストの 1 番目の項目を変更します。
;;;;;          (add_list "")
;;;;;          (end_list)
;;;;;        )
;;;;;      );_if
;;;;;      (mode_tile "suiR" 1) ; 使用不可
;;;;;    )
;;;;;    (progn
;;;;;      (mode_tile "suiR" 0)   ; 使用可
;;;;;      (setq #pop2flg T)
;;;;;    )
;;;;;  );_if
;;;;;  (if (= #pop3 nil) ; 0
;;;;;    (progn
;;;;;      (if #pop3flg
;;;;;        (progn
;;;;;          (start_list "sui" 1 0) ;リストの 1 番目の項目を変更します。
;;;;;          (add_list "")
;;;;;          (end_list)
;;;;;        )
;;;;;      );_if
;;;;;      (mode_tile "sui" 1) ; 使用不可
;;;;;    )
;;;;;    (progn
;;;;;      (mode_tile "sui" 0)   ; 使用可
;;;;;      (setq #pop3flg T)
;;;;;    )
;;;;;  );_if
;;;;;  (if (= #pop4 nil) ; 1
;;;;;    (progn
;;;;;      (if #pop4flg
;;;;;        (progn
;;;;;          (start_list "opL" 1 0) ;リストの 1 番目の項目を変更します。
;;;;;          (add_list "")
;;;;;          (end_list)
;;;;;        )
;;;;;      );_if
;;;;;      (mode_tile "opL" 1) ; 使用不可
;;;;;    )
;;;;;    (progn
;;;;;      (mode_tile "opL" 0)   ; 使用可
;;;;;      (setq #pop4flg T)
;;;;;    )
;;;;;  );_if
;;;;;  (if (= #pop5 nil) ; 2
;;;;;    (progn
;;;;;      (if #pop5flg
;;;;;        (progn
;;;;;          (start_list "opR" 1 0) ;リストの 1 番目の項目を変更します。
;;;;;          (add_list "")
;;;;;          (end_list)
;;;;;        )
;;;;;      );_if
;;;;;      (mode_tile "opR" 1) ; 使用不可
;;;;;    )
;;;;;    (progn
;;;;;      (mode_tile "opR" 0)   ; 使用可
;;;;;      (setq #pop5flg T)
;;;;;    )
;;;;;  );_if
;;;;;
;;;;;  (princ)
;;;;;);##SUISENpop
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; #sui$$ #sui$をﾛｰｶﾙ変数定義してはならぬ
;;;;;;;;2011/09/14YM@DEL(defun ##CHG_sinkPOCKET ( / #NO); "radioPOCKET" key にｱｸｼｮﾝあり
;;;;;;;;2011/09/14YM@DEL  (if (= (get_tile "radioPY") "1") ; ｼﾝｸﾎﾟｹｯﾄあり
;;;;;;;;2011/09/14YM@DEL    (mode_tile "radio" 0) ; 使用可
;;;;;;;;2011/09/14YM@DEL    (progn
;;;;;;;;2011/09/14YM@DEL      (setq #no (atoi (get_tile "sink"))) ; #name$$ の何番目か
;;;;;;;;2011/09/14YM@DEL      ; 01/12/14 YM MOD-S
;;;;;;;;2011/09/14YM@DEL      (set_tile "radioR" "1") ; ﾃﾞﾌｫﾙﾄ"R"
;;;;;;;;2011/09/14YM@DEL      (mode_tile "radio" 0)   ; LR有無選択可能
;;;;;;;;2011/09/14YM@DEL      ; 01/12/14 YM MOD-E
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD     (if (equal (nth 9 (nth #no &name$$)) 0.0 0.1) ; 現在のｼﾝｸのLR有無
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD       (progn
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD         (set_tile "radioR" "1")
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD         (mode_tile "radio" 1) ; LR有無なし ; 使用不可
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD       )
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD       (mode_tile "radio" 0) ; LR有無あり ; 使用可
;;;;;;;;2011/09/14YM@DEL;;;01/12/14YM@MOD     );_if
;;;;;;;;2011/09/14YM@DEL
;;;;;;;;2011/09/14YM@DEL    )
;;;;;;;;2011/09/14YM@DEL  );_if
;;;;;;;;2011/09/14YM@DEL  (princ)
;;;;;;;;2011/09/14YM@DEL);##CHG_sinkPOCKET
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; #sui$$ #sui$をﾛｰｶﾙ変数定義してはならぬ
;;;;;(defun ##CHG_sinkLR ( / ); "radio" key にｱｸｼｮﾝあり
;;;;;  (set_tile "text2" "WT端からのシンク位置")
;;;;;;;;00/12/04YM@  (if (= (get_tile "radioR") "1")
;;;;;;;;00/12/04YM@    (set_tile "text2" "右端からのシンク位置")
;;;;;;;;00/12/04YM@    (set_tile "text2" "左端からのシンク位置")
;;;;;;;;00/12/04YM@  );_if
;;;;;  (princ)
;;;;;);##CHG_sinkLR
;;;;;
;-- 2011/09/17 A.Satoh Del - E
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; #sui$$ #sui$をﾛｰｶﾙ変数定義してはならぬ
;-- 2011/09/17 A.Satoh Mod - S
;;;;;(defun ##CHG_sink ( ; "sink" key にｱｸｼｮﾝあり
;;;;;  /
;;;;;  #no #dim #i #j
;;;;;  #pop1 #pop2 #pop3 #pop4 #pop5
;;;;;  #plis #dimST #dimRP #LR_EXIST #dum
;;;;;  #dimST$ #dimRP$ #focus #DIMA #dimA$
;;;;;
;;;;;  )
;;;;;
;;;;;  (setq #no (atoi (get_tile "sink"))) ; #name$$ の何番目か
;;;;;;;; ｼﾝｸ記号
;;;;;  (setq #snk (nth 1 (nth #no &name$$)))      ; ｼﾝｸ記号
;;;;;;;;01/12/14YM@MOD  (setq #LR_EXIST (nth 9 (nth #no &name$$))) ; ｼﾝｸLR有無
;;;;;
;;;;;
;;;;;;;;2011/09/14YM@DEL;;; ｼﾝｸ脇寸法ﾘｽﾄの変更
;;;;;;;;2011/09/14YM@DEL  (setq #dimST$ nil #dimRP$ nil) ; ｼﾝｸ位置ﾘｽﾄ内容
;;;;;;;;2011/09/14YM@DEL  (if &sink$$
;;;;;;;;2011/09/14YM@DEL    (progn
;;;;;;;;2011/09/14YM@DEL      (start_list "sinkpos" 3)
;;;;;;;;2011/09/14YM@DEL      (setq #i #i1)
;;;;;;;;2011/09/14YM@DEL      (setq #j #i2)
;;;;;;;;2011/09/14YM@DEL      (repeat 10
;;;;;;;;2011/09/14YM@DEL        (setq #dimST (nth #i (nth #no &sink$$))) ; SINK位置.脇寸法1,2,3ｽﾃﾝ  (&sink$$の最初のもの)
;;;;;;;;2011/09/14YM@DEL        (setq #dimRP (nth #j (nth #no &sink$$))) ; SINK位置.脇寸法1,2,3ﾗﾋﾟｽ (&sink$$の最初のもの)
;;;;;;;;2011/09/14YM@DEL        (if (> #dimST 0.1)
;;;;;;;;2011/09/14YM@DEL          (progn
;;;;;;;;2011/09/14YM@DEL            (add_list (strcat (itoa (fix (+ #dimST 0.001))) " ("
;;;;;;;;2011/09/14YM@DEL                              (itoa (fix (+ #dimRP 0.001))) ")"))
;;;;;;;;2011/09/14YM@DEL            (Setq #dimST$ (append #dimST$ (list #dimST)))
;;;;;;;;2011/09/14YM@DEL            (Setq #dimRP$ (append #dimRP$ (list #dimRP)))
;;;;;;;;2011/09/14YM@DEL          )
;;;;;;;;2011/09/14YM@DEL        )
;;;;;;;;2011/09/14YM@DEL        (setq #i (1+ #i))
;;;;;;;;2011/09/14YM@DEL        (setq #j (1+ #j))
;;;;;;;;2011/09/14YM@DEL;;;01/01/11YM@        (setq #dum (nth #i (nth #no &sink$$)))
;;;;;;;;2011/09/14YM@DEL;;;01/01/11YM@        (if (> #dum 0.1)
;;;;;;;;2011/09/14YM@DEL;;;01/01/11YM@          (add_list (itoa (fix (+ #dum 0.001))))
;;;;;;;;2011/09/14YM@DEL;;;01/01/11YM@        );_if
;;;;;;;;2011/09/14YM@DEL;;;01/01/11YM@        (setq #i (1+ #i))
;;;;;;;;2011/09/14YM@DEL      )
;;;;;;;;2011/09/14YM@DEL      (end_list)
;;;;;;;;2011/09/14YM@DEL    )
;;;;;;;;2011/09/14YM@DEL    (progn
;;;;;;;;2011/09/14YM@DEL      (princ) ; 00/11/30 YM ADD
;;;;;;;;2011/09/14YM@DEL    )
;;;;;;;;2011/09/14YM@DEL  );_if
;;;;;;;;2011/09/14YM@DEL  (setq #DimA (##GetDimA #snk)) ; 初期表示ｼﾝｸに対する標準寸法
;;;;;;;;2011/09/14YM@DEL  (setq #i 0 #focus 0) ; 02/11/15 YM MOD
;;;;;;;;2011/09/14YM@DEL;;; (setq #i 0 #focus nil) ; 02/11/15 YM MOD
;;;;;;;;2011/09/14YM@DEL  (if (= #ZaiF "1")
;;;;;;;;2011/09/14YM@DEL    (setq #dimA$ #dimST$)
;;;;;;;;2011/09/14YM@DEL    (setq #dimA$ #dimRP$)
;;;;;;;;2011/09/14YM@DEL  );_if
;;;;;;;;2011/09/14YM@DEL  (foreach dimA #dimA$
;;;;;;;;2011/09/14YM@DEL    (if (equal dimA #DimA 0.1)
;;;;;;;;2011/09/14YM@DEL      (setq #focus #i)
;;;;;;;;2011/09/14YM@DEL    );_if
;;;;;;;;2011/09/14YM@DEL    (setq #i (1+ #i))
;;;;;;;;2011/09/14YM@DEL  )
;;;;;;;;2011/09/14YM@DEL  (if #focus
;;;;;;;;2011/09/14YM@DEL    (set_tile "sinkpos" (itoa #focus)) ; 初期は最初の項目を表示 01/03/08 YM MOD 標準寸法にﾌｫｰｶｽ
;;;;;;;;2011/09/14YM@DEL    (set_tile "sinkpos" "0") ; 選択したｼﾝｸ脇寸法
;;;;;;;;2011/09/14YM@DEL  );_if
;;;;;
;;;;;
;;;;;  (##CHG_sinkpos) ; ｼﾝｸ位置ｴﾃﾞｨｯﾄﾎﾞｯｸｽ変更
;;;;;;;;  (set_tile "edit_sinkpos"
;;;;;;;;   (rtos (nth (+ (atoi (get_tile "sinkpos")) #i0) (nth #no &sink$$)) 2 0) ; 十進小数0
;;;;;;;; )
;;;;;;;; 水栓穴種類ﾘｽﾄの変更
;;;;;;-- 2011/06/29 A.Satoh Mod -S
;;;;;; ☆☆☆☆ 6/29時点での暫定処理
;;;;;; ☆☆☆☆ 仕様確定後に対応
;;;;;;|
;;;;;  (start_list "hole" 3)
;;;;;  (setq #sui$$ '())
;;;;;  (setq #i 10)
;;;;;  (repeat 5
;;;;;    (setq #dim (nth #i (nth #no &name$$)))
;;;;;    (if (> #dim 0.1)
;;;;;      (progn
;;;;;        (setq #sui$ ; １つ引き当て
;;;;;          (CFGetDBSQLRec CG_DBSESSION "WT水栓穴"
;;;;;            (list (list "水栓穴ID" (itoa (fix (+ #dim 0.001))) 'INT))
;;;;;          )
;;;;;        );_(setq
;;;;;        (setq #sui$ (DBCheck #sui$ "『WT水栓穴』" "KPSelectSinkDlg")) ; nil or 複数時 ｴﾗｰ
;;;;;        (setq #sui$$ (append #sui$$ (list #sui$)))
;;;;;        (add_list (nth 2 #sui$))
;;;;;      )
;;;;;    );_if
;;;;;    (setq #i (1+ #i))
;;;;;  )
;;;;;  (end_list)
;;;;;  (set_tile "hole" "0")
;;;;;;;; 水栓ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;  (setq #sui$ (car #sui$$))
;;;;;  (##SUISENpop)
;;;;;|;
;;;;;  (mode_tile "hole" 1)
;;;;;  (mode_tile "suiL" 1)
;;;;;  (mode_tile "suiR" 1)
;;;;;  (mode_tile "sui"  1)
;;;;;  (mode_tile "opL"  1)
;;;;;  (mode_tile "opR"  1)
;;;;;;-- 2011/06/29 A.Satoh Mod -E
;;;;;
;;;;;  ;;; ｼﾝｸLR選択
;;;;;  ;2011/09/14 YM ADD-S
;;;;;  (cond
;;;;;    ((= #SNK_KATTE "R")
;;;;;      (set_tile "radioR" "1") ; "R"
;;;;;    )
;;;;;    ((= #SNK_KATTE "L")
;;;;;      (set_tile "radioL" "1") ; "L"
;;;;;    )
;;;;;    (T
;;;;;      (set_tile "radioR" "1") ; "R"
;;;;;    )
;;;;;  );_cond
;;;;;  (mode_tile "radio" 0)   ; LR有無選択可能
;;;;;  ;2011/09/14 YM ADD-E
;;;;;
;;;;;;;;01/12/14YM@MOD (if (equal #LR_EXIST 0.0 0.1) ; LR有無 00/10/25 YM ADD
;;;;;;;;01/12/14YM@MOD   (if (= (get_tile "radioPY") "1") ; LR有無なし
;;;;;;;;01/12/14YM@MOD     (mode_tile "radio" 0) ; 使用可
;;;;;;;;01/12/14YM@MOD     (progn
;;;;;;;;01/12/14YM@MOD       (set_tile "radioR" "1")
;;;;;;;;01/12/14YM@MOD       (mode_tile "radio" 1) ; 使用不可
;;;;;;;;01/12/14YM@MOD     )
;;;;;;;;01/12/14YM@MOD   );_if
;;;;;;;;01/12/14YM@MOD   (mode_tile "radio" 0); LR有無あり ; 使用可
;;;;;;;;01/12/14YM@MOD );_if
;;;;;
;;;;;  (set_tile "text2" "WT端からのシンク位置")
;;;;;;;; (set_tile "text2" "右端からのシンク位置")
;;;;;
;;;;;;;;2011/09/14YM@DEL  (cond
;;;;;;;;2011/09/14YM@DEL    ((= (nth 16 (nth #no &name$$)) "P")
;;;;;;;;2011/09/14YM@DEL      (mode_tile "radioPOCKET" 0) ; 使用可能
;;;;;;;;2011/09/14YM@DEL    )
;;;;;;;;2011/09/14YM@DEL    (T
;;;;;;;;2011/09/14YM@DEL      (set_tile "radioPN" "1")
;;;;;;;;2011/09/14YM@DEL      (mode_tile "radioPOCKET" 1) ; 使用不可能
;;;;;;;;2011/09/14YM@DEL    )
;;;;;;;;2011/09/14YM@DEL  );_cond
;;;;;  ;;; ｼﾝｸLR選択
;;;;;  ;2011/09/14 YM ADD-S
;;;;;
;;;;;  (princ)
;;;;;);##CHG_sink
(defun ##CHG_sink ( ; "sink" key にｱｸｼｮﾝあり
  /
  #no #LR_umu
  #ana_type #type #kikaku #selno
  #idx #def_no #lst
  )

  (setq #no (atoi (get_tile "sink"))) ; #name$$ の何番目か

  (setq #LR_umu (nth 4 (nth #no &name$$)))  ; LR有無
  (if (= #LR_umu 0)
    (progn
      (set_tile "radioR" "0") ; "R"
      (set_tile "radioL" "0") ; "R"
      (mode_tile "radio" 1)   ; LR有無選択不可
    )
    (progn
;-- 2011/11/21 A.Satoh Mod - S
;;;;;      (cond
;;;;;        ((= #SNK_KATTE "R")
;;;;;          (set_tile "radioR" "1") ; "R"
;;;;;        )
;;;;;        ((= #SNK_KATTE "L")
;;;;;          (set_tile "radioL" "1") ; "L"
;;;;;        )
;;;;;        (T
;;;;;          (set_tile "radioR" "1") ; "R"
;;;;;        )
;;;;;      )
;;;;;      (mode_tile "radio" 0)   ; LR有無選択可能
      (cond
        ((= #SNK_KATTE "R")
          (set_tile "radioR" "1") ; "R"
		      (mode_tile "radio" 1)   ; LR有無選択不可
        )
        ((= #SNK_KATTE "L")
          (set_tile "radioL" "1") ; "L"
		      (mode_tile "radio" 1)   ; LR有無選択不可
        )
        (T
          (set_tile "radioL" "1") ; "L"
		      (mode_tile "radio" 0)   ; LR有無選択可能
        )
      )
;-- 2011/11/21 A.Satoh Mod - E
    )
  )

  ;;; 水栓ポップアップリスト初期設定
  (setq #ana_type (nth 7 (nth #no #name$$)))
  (setq #type     (nth 8 (nth #no #name$$)))
  (setq #kikaku   (nth 9 (nth #no #name$$)))

  ;(setq #selno (atoi (get_tile "hole")))

  ; 【WT水栓穴】から水栓穴情報を取り出す
  (setq #sui_ana$$
    (CFGetDBSQLRec CG_DBSESSION "WT水栓穴"
      (list (list "水栓穴タイプ種別" #ana_type 'STR))
    )
  )
  (if #sui_ana$$
    (progn
      (setq #sui_ana$$ (CFListSort #sui_ana$$ 0))
      (setq #idx 0)
      (setq #def_no1 0)
      (repeat (length #sui_ana$$)
        (if (= 1 (nth 8 (nth #idx #sui_ana$$)))
          (setq #def_no #idx)
        )
        (setq #idx (1+ #idx))
      )
    )
    (progn
      (setq #msg (strcat "『WT水栓穴』にﾚｺｰﾄﾞがありません。\n水栓穴タイプ種別=" #ana_type))
      (CFAlertMsg #msg)
      (quit)
    )
  )

  ; 水栓穴リストにアイテムを設定
  (start_list "hole" 3)
  (foreach #lst #sui_ana$$
    (add_list (nth 2 #lst))
  )
  (end_list)
  (set_tile "hole" (itoa #def_no))

  ; 【SINK水栓管理】から水栓情報を取り出す
  (setq #suisen$$
    (CFGetDBSQLRec CG_DBSESSION "WT水栓管"
      (list (list "選択肢種別" #type 'STR))
    )
  )
  (if #suisen$$
    (progn
      (setq #suisen$$ (CFListSort #suisen$$ 0))
    )
    (progn
      (setq #msg (strcat "『WT水栓管』にﾚｺｰﾄﾞがありません。\n選択肢種別=" #type))
      (CFAlertMsg #msg)
      (quit)
    )
  )

;  (##SetEnableList (nth #selno #sui_ana$$))
  (##SetEnableList (nth #def_no #sui_ana$$))

	;シンク画面でシンクを変更したときの対応
	;2017/01/19 YM ADD 追加　したからコピー(Errmsg.ini) ★★★★★★★★★★★★★
	; #snk
	(setq #snk (nth 1 (nth #no &name$$)))

	(setq #iii 0)
	(setq #width_SP nil);ｸﾘｱｰ
	(foreach #sSINK #sSINK$
		(if (= #sSINK #snk)
			(progn ;該当のｼﾝｸだった
				(setq #width_SP (atof (nth #iii #sDIST$)))
			)
		);_if
		(setq #iii (1+ #iii))
	);foreach

;;;	(CFAlertMsg "★（４）★ ＜PG改修＞ ERRMSG.INIを見に行った") ;2017/01/19 YM ADD

	;2017/01/19 YM ADD 追加　したからコピー(Errmsg.ini) ★★★★★★★★★★★★★

	(if #width_SP
		(progn
	  	(set_tile "edit_sinkpos" (rtos #width_SP 2 1));Pシンクなど特殊
;;;			(setq #width #width_SP);戻り値 2017/01/20 DEL
		)
		;else
		(progn
	  	(set_tile "edit_sinkpos" (rtos #width_CAB 2 1));ｼﾝｸｷｬﾋﾞｾﾝﾀｰ
;;;			(setq #width #width_CAB);戻り値 2017/01/20 DEL
		)
	);_if



  (princ)
);##CHG_sink
;-- 2011/09/17 A.Satoh Mod - E
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/09/17 A.Satoh Del - S
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; #sui$$ #sui$をﾛｰｶﾙ変数定義してはならぬ
;;;;;(defun ##CHG_sinkpos ( ; "sinkpos" key にｱｸｼｮﾝあり
;;;;;  /
;;;;;  #NO
;;;;;  )
;;;;;  (setq #no (atoi (get_tile "sink"))) ; #name$$ の何番目か
;;;;;  ; 選択したｼﾝｸ脇寸法
;;;;;  (set_tile "edit_sinkpos"
;;;;;;;;2011/09/14YM@DEL    (rtos (nth (+ (atoi (get_tile "sinkpos")) #i1) (nth #no &sink$$)) 2 0) ; 十進小数0
;;;;;    (rtos 777.7 2 1) ; 十進小数0 【暫定】
;;;;;  )
;;;;;  (princ)
;;;;;);##CHG_sinkpos
;-- 2011/09/17 A.Satoh Del - E
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defun ##CHK_edit (&sKEY / #val #ret)
    (setq #ret nil)
    (setq #val (read (get_tile &sKEY)))
    (if (or (= (type (read (get_tile &sKEY))) 'INT)
            (= (type (read (get_tile &sKEY))) 'REAL))
      (princ) ; OK!
      (progn
        (alert "半角の実数値を入力して下さい。")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  );##CHK_edit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; #sui$$ #sui$をﾛｰｶﾙ変数定義してはならぬ
(defun ##CHG_hole ( ; 水栓穴ﾀｲﾌﾟにｱｸｼｮﾝあり
  &sVAL
  /
  )
;-- 2011/09/17 A.Satoh Mod - S
;;;;;  (setq #sui$ (nth (atoi &sVAL) #sui$$))
;;;;;;;; 水栓ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;;-- 2011/06/29 A.Satoh Mod -S
;;;;;; ☆☆☆☆ 6/29時点での暫定処理
;;;;;; ☆☆☆☆ 仕様確定後に対応
;;;;;;|
;;;;;  (##SUISENpop)
;;;;;|;
;;;;;  (mode_tile "suiL" 1)
;;;;;  (mode_tile "suiR" 1)
;;;;;  (mode_tile "sui"  1)
;;;;;  (mode_tile "opL"  1)
;;;;;  (mode_tile "opR"  1)
;;;;;;-- 2011/06/29 A.Satoh Mod -E
  (##SetEnableList (nth (atoi &sVal) #sui_ana$$))
;-- 2011/09/17 A.Satoh Mod - E
  (princ)
);##CHG_hole
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2011/09/17 A.Satoh Mod - S
;;;;;(defun ##GetDlgItem ( / ; ﾀﾞｲｱﾛｸﾞの結果を取得する
;;;;;  #ret1 #ret2 #ret3 #ret4 #ret5
;;;;;  #ret6 #ret7 #ret8 #ret9 #ret0
;;;;;  #plis1 #plis2 #plis3 #plis4 #plis5
;;;;;  #sink$ #name$ #SNK_DIM #LR #sui$ #plis$
;;;;;  )
;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;    (defun Getplis ( &lis$ &ret &flg / #plis)
;;;;;      (if &lis$
;;;;;        (progn
;;;;;          (if &flg ; "な  し"はない
;;;;;            (progn
;;;;;              (if (/= &ret "")
;;;;;                (setq #plis (nth (atoi &ret) &lis$))
;;;;;                (setq #plis nil)
;;;;;              )
;;;;;            )
;;;;;            (progn ; "0"は"な  し"
;;;;;              (if (and (/= &ret "") (/= &ret "0"))
;;;;;                (setq #plis (nth (1- (atoi &ret)) &lis$))
;;;;;                (setq #plis nil)
;;;;;              )
;;;;;            )
;;;;;          );_if
;;;;;        )
;;;;;        (setq #plis nil)
;;;;;      );_if
;;;;;      #plis
;;;;;    )
;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;;  (setq #ret1 (get_tile "sink"))    ; ｼﾝｸ名称
;;;;;  (setq #ret2 (get_tile "edit_sinkpos")) ; ｼﾝｸ脇寸法
;;;;;  (setq #ret3 (get_tile "radioR"))  ; ｼﾝｸLR
;;;;;;;;2011/09/14YM@DEL  (setq #ret4 (get_tile "radioPY")) ; ｼﾝｸﾎﾟｹｯﾄあり
;;;;;
;;;;;;-- 2011/06/29 A.Satoh Mod -S
;;;;;; ☆☆☆☆ 6/29時点での暫定処理
;;;;;; ☆☆☆☆ 仕様確定後に対応
;;;;;;|
;;;;;  (setq #ret5 (get_tile "hole"))    ; 水栓穴ﾀｲﾌﾟ
;;;;;
;;;;;  (setq #ret6 (get_tile "suiL"))    ; 水栓左
;;;;;  (setq #ret7 (get_tile "suiR"))    ; 水栓右
;;;;;  (setq #ret8 (get_tile "sui"))     ; 水栓
;;;;;  (setq #ret9 (get_tile "opL"))     ; オプション右
;;;;;  (setq #ret0 (get_tile "opR"))     ; オプション左
;;;;;
;;;;;  (setq #plis1 (Getplis #plis1$ #ret6 nil)) ; 水栓穴属性-1 品番名称,備考
;;;;;  (setq #plis2 (Getplis #plis2$ #ret7 nil)) ; 水栓穴属性-2 品番名称,備考
;;;;;  (setq #plis3 (Getplis #plis3$ #ret8 nil)) ; 水栓穴属性 0 品番名称,備考
;;;;;  (setq #plis4 (Getplis #plis4$ #ret9 nil)) ; 水栓穴属性 1 品番名称,備考
;;;;;  (setq #plis5 (Getplis #plis5$ #ret0 nil)) ; 水栓穴属性 2 品番名称,備考
;;;;;
;;;;;  ;;; 07/22 YM ADD 水栓１　水栓右＝「なし」のような場合
;;;;;  (if (and #pop1 (= #plis1 nil))
;;;;;    (setq #plis1 "-1")
;;;;;  );_if
;;;;;  (if (and #pop2 (= #plis2 nil))
;;;;;    (setq #plis2 "-2")
;;;;;  );_if
;;;;;  (if (and #pop3 (= #plis3 nil))
;;;;;    (setq #plis3 "0")
;;;;;  );_if
;;;;;  (if (and #pop4 (= #plis4 nil))
;;;;;    (setq #plis4 "1")
;;;;;  );_if
;;;;;  (if (and #pop5 (= #plis5 nil))
;;;;;    (setq #plis5 "2")
;;;;;  );_if
;;;;;|;
;;;;;  (setq #plis1 nil)
;;;;;  (setq #plis2 nil)
;;;;;  (setq #plis3 nil)
;;;;;  (setq #plis4 nil)
;;;;;  (setq #plis5 nil)
;;;;;;-- 2011/06/29 A.Satoh Mod -E
;;;;;
;;;;;;-- 2011/06/29 A.Satoh Mod - S
;;;;;;  (setq #sui$ (nth (atoi #ret5) #sui$$))                  ; WT水栓穴N選択ﾚｺｰﾄﾞ
;;;;;  (if #sui$$
;;;;;    (setq #sui$ (nth (atoi #ret5) #sui$$))                ; WT水栓穴N選択ﾚｺｰﾄﾞ
;;;;;    (setq #sui$ nil)                                      ; WT水栓穴N選択ﾚｺｰﾄﾞ
;;;;;  )
;;;;;;-- 2011/06/29 A.Satoh Mod - E
;;;;;  (if &sink$$
;;;;;    (setq #sink$ (nth (atoi #ret1) &sink$$))              ; sink位置の選択ﾚｺｰﾄﾞ
;;;;;    (setq #sink$ nil)                                     ; sink位置の選択ﾚｺｰﾄﾞ
;;;;;  );_if
;;;;;  (setq #name$ (nth (atoi #ret1) &name$$))                ; WTｼﾝｸの選択ﾚｺｰﾄﾞ
;;;;;  (setq #SNK_DIM (atof #ret2)) ; 選択したｼﾝｸ脇寸法(ｴﾃﾞｨｯﾄﾎﾞｯｸｽ) "200(320)"==>200.0
;;;;;  (setq #plis$ (list #plis1 #plis2 #plis3 #plis4 #plis5)) ; 選択した水栓品番名称ﾘｽﾄ
;;;;;
;;;;;  ;;; ｼﾝｸLR選択
;;;;;  (if (= #ret3 "1") ; 選択したｼﾝｸLRﾀｲﾌﾟ
;;;;;    (setq #LR "R")
;;;;;    (setq #LR "L")
;;;;;  );_if
;;;;;
;;;;;;;;01/07/30YM@  (if (and (= #ret4 "0")(equal (nth 9 #name$) 0.0 0.1)) ; LR有無 且つﾎﾟｹｯﾄなし
;;;;;;;;01/07/30YM@    (setq #LR "Z")
;;;;;;;;01/07/30YM@  );_if
;;;;;;;;
;;;;;;;;2011/09/14YM@DEL  (if (= #ret4 "1") ; 選択したｼﾝｸﾎﾟｹｯﾄ
;;;;;;;;2011/09/14YM@DEL    (setq #POCKET "Y")
;;;;;;;;2011/09/14YM@DEL    (setq #POCKET "N")
;;;;;;;;2011/09/14YM@DEL  );_if
;;;;;
;;;;;  (done_dialog)
;;;;;  (list #sink$ #name$ #SNK_DIM #LR #sui$ #plis$ #POCKET)
;;;;;);##GetDlgItem
(defun ##GetDlgItem ( / ; ﾀﾞｲｱﾛｸﾞの結果を取得する
  #ret1 #ret2 #ret3 #ret4 #ret5
  #ret6 #ret7 #ret8 #ret9 #ret10
  #name$ #SNK_DIM #plis$ #LR #sink$ #sui$ 
  )

  (setq #ret1 (get_tile "sink"))    ; ｼﾝｸ名称
  (setq #ret2 (get_tile "edit_sinkpos")) ; ｼﾝｸ脇寸法
  (setq #ret3 (get_tile "radioR"))  ; ｼﾝｸLR
  (setq #ret4 (get_tile "radioL"))  ; ｼﾝｸLR

  (if #sui$$
    (setq #sui$ (nth (atoi #ret5) #sui$$))                ; WT水栓穴N選択ﾚｺｰﾄﾞ
    (setq #sui$ nil)                                      ; WT水栓穴N選択ﾚｺｰﾄﾞ
  )

  (if &sink$$
    (setq #sink$ (nth (atoi #ret1) &sink$$))              ; sink位置の選択ﾚｺｰﾄﾞ
    (setq #sink$ nil)                                     ; sink位置の選択ﾚｺｰﾄﾞ
  )

  (setq #name$ (nth (atoi #ret1) &name$$))                ; WTｼﾝｸの選択ﾚｺｰﾄﾞ
  (setq #SNK_DIM (atof #ret2)) ; 選択したｼﾝｸ脇寸法(ｴﾃﾞｨｯﾄﾎﾞｯｸｽ) "200(320)"==>200.0

  (setq #plis$ nil)
  (setq #ret5 (get_tile "hole"))    ; 水栓穴ﾀｲﾌﾟ
  (if (= #ret5 "0")
    (progn
      (setq #plis$ (list nil nil nil nil nil))
    )
    (progn
      (setq #ret6  (get_tile "opR"))     ; オプション左
      (setq #ret7  (get_tile "suiL"))    ; 水栓左
      (setq #ret8  (get_tile "sui"))     ; 水栓
      (setq #ret9  (get_tile "suiR"))    ; 水栓右
      (setq #ret10 (get_tile "opL"))     ; オプション右

      (if (/= #ret6 "")
        (if (= (nth 0 #mode_f$) 1)
          (if (= #ret6 "0")
            (setq #plis$ (append #plis$ (list nil)))
            (setq #plis$ (append #plis$ (list (nth 3 (nth (atoi #ret6) #suisen$$)))))
          )
        )
      )
      (if (/= #ret7 "")
        (if (= (nth 1 #mode_f$) 1)
          (if (= #ret7 "0")
            (setq #plis$ (append #plis$ (list nil)))
            (setq #plis$ (append #plis$ (list (nth 3 (nth (atoi #ret7) #suisen$$)))))
          )
        )
      )
      (if (/= #ret8 "")
        (if (= (nth 2 #mode_f$) 1)
          (if (= #ret8 "0")
            (setq #plis$ (append #plis$ (list nil)))
            (setq #plis$ (append #plis$ (list (nth 3 (nth (atoi #ret8) #suisen$$)))))
          )
        )
      )
      (if (/= #ret9 "")
        (if (= (nth 3 #mode_f$) 1)
          (if (= #ret9 "0")
            (setq #plis$ (append #plis$ (list nil)))
            (setq #plis$ (append #plis$ (list (nth 3 (nth (atoi #ret9) #suisen$$)))))
          )
        )
      )
      (if (/= #ret10 "")
        (if (= (nth 4 #mode_f$) 1)
          (if (= #ret10 "0")
            (setq #plis$ (append #plis$ (list nil)))
            (setq #plis$ (append #plis$ (list (nth 3 (nth (atoi #ret10) #suisen$$)))))
          )
        )
      )
    )
  )

  ;;; ｼﾝｸLR選択
  (if (= #ret3 "1") ; 選択したｼﾝｸLRﾀｲﾌﾟ
    (setq #LR "R")
    (if (= #ret4 "1")
      (setq #LR "L")
      (setq #LR "Z")
    )
  )

  (done_dialog)
  (list #sink$ #name$ #SNK_DIM #LR #sui$ #plis$ "N")

);##GetDlgItem
;-- 2011/09/17 A.Satoh Mod - S

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-- 2011/09/17 A.Satoh Add - S
(defun ##SetEnableList (
  &sui_ana$
  /
  #analst$ #idx #flg1 #flg2 #flg3 #flg4 #flg5
  )

  (setq #sui_type (nth 1 &sui_ana$))
  (setq #analst$ nil)
  (setq #idx 3)
  (repeat 5
    (if (/= (nth #idx &sui_ana$) nil)
      (setq #analst$ (append #analst$ (list (nth #idx &sui_ana$))))
    )
    (setq #idx (1+ #idx))
  )

  ; 各リストを一旦クリアする
  (setq #flg1 0 #flg2 0 #flg3 0 #flg4 0 #flg5 0)
  (mode_tile "opL"  1)
  (start_list "opL" 3)
  (add_list "")
  (end_list)
  (mode_tile "suiL" 1)
  (start_list "suiL" 3)
  (add_list "")
  (end_list)
  (mode_tile "sui"  1)
  (start_list "sui" 3)
  (add_list "")
  (end_list)
  (mode_tile "suiR" 1)
  (start_list "suiR" 3)
  (add_list "")
  (end_list)
  (mode_tile "opR"  1)
  (start_list "opR" 3)
  (add_list "")
  (end_list)

  ; WT水栓穴情報から有効/無効フラグリストを取得する
  ; 例 穴1=2 穴2=4 穴3～穴5=nilである場合→(2 4 0 0 0)
  (if #analst$
    (progn
      (setq #idx 0)
      (repeat (length #analst$)
        (cond
          ((= (nth #idx #analst$) 1)
            (mode_tile "opL" 0)

            (start_list "opL" 3)
            (foreach #lst #suisen$$
              (add_list (nth 2 #lst))
            )
            (end_list)
            (set_tile "opL" (itoa #def_no2))
            (setq #flg1 1)
          )
          ((= (nth #idx #analst$) 2)
            (mode_tile "suiL" 0)

            (start_list "suiL" 3)
            (foreach #lst #suisen$$
              (add_list (nth 2 #lst))
            )
            (end_list)
            (set_tile "suiL" (itoa #def_no2))
            (setq #flg2 1)
          )
          ((= (nth #idx #analst$) 3)
            (mode_tile "sui" 0)

            (start_list "sui" 3)
            (foreach #lst #suisen$$
              (add_list (nth 2 #lst))
            )
            (end_list)
            (set_tile "sui" (itoa #def_no2))
            (setq #flg3 1)
          )
          ((= (nth #idx #analst$) 4)
            (mode_tile "suiR" 0)

            (start_list "suiR" 3)
            (foreach #lst #suisen$$
              (add_list (nth 2 #lst))
            )
            (end_list)
            (set_tile "suiR" (itoa #def_no2))
            (setq #flg4 1)
          )
          ((= (nth #idx #analst$) 5)
            (mode_tile "opR" 0)

            (start_list "opR" 3)
            (foreach #lst #suisen$$
              (add_list (nth 2 #lst))
            )
            (end_list)
            (set_tile "opR" (itoa #def_no2))
            (setq #flg5 1)
          )
        )
        (setq #idx (1+ #idx))
      )
    )
  )

  (setq #mode_f$ (list #flg1 #flg2 #flg3 #flg4 #flg5))

  (princ)
)
;-- 2011/09/17 A.Satoh Add - E


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  ; 2012/08/02 YM ADD　ﾃｷｽﾄ表示
;;;  (defun ##SHOW_TEXT ( / #text_file)
;;;
;;;		(setq #text_file  (strcat CG_SYSPATH "SINK.txt"));ｼﾝｸ位置ﾌｧｲﾙ
;;;		(startapp "notepad.exe" #text_file)
;;;
;;;		(princ)
;;;  );##SHOW_TEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;  &sink$$   ;(LIST)SINK位置テーブルの内容
;;;  &name$$   ;(LIST)WTシンクテーブルの内容

  ;;; ﾀﾞｲｱﾛｸﾞの表示
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "SelectSinkDlg" #dcl_id)) (exit))
  ;;; 初期ｼﾝｸ名称ﾘｽﾄ
  (start_list "sink" 3)

  (foreach #lst &name$$ ; WTシンク
    (add_list (nth 2 #lst)) ; WTｼﾝｸ.ｼﾝｸ記号,ｼﾝｸ名称
  )
  (end_list)
  ;;; ﾀｲﾙの初期設定
  (set_tile "sink" "0")
  ;;; 初期ｼﾝｸ記号
  (setq #snk (nth 1 (car &name$$)))

;-- 2011/09/18 A.Satoh Add - S
  (setq #mode_f$ '(0 0 0 0 0))
;-- 2011/09/18 A.Satoh Add - E

;-- 2011/09/16 A.Satoh Del - S
;;;;;;; 初期ｼﾝｸ脇寸法ﾘｽﾄ
;;;;;  (setq #dimST$ nil #dimRP$ nil) ; ｼﾝｸ位置ﾘｽﾄ内容
;-- 2011/09/16 A.Satoh Del - S
;;;2011/09/14YM@DEL  (if &sink$$
;;;2011/09/14YM@DEL    (progn
;;;2011/09/14YM@DEL      (start_list "sinkpos" 3)
;;;2011/09/14YM@DEL;;;     (setq #i #i0)
;;;2011/09/14YM@DEL      (setq #i #i1)
;;;2011/09/14YM@DEL      (setq #j #i2)
;;;2011/09/14YM@DEL      (repeat 10
;;;2011/09/14YM@DEL        (setq #dimST (nth #i (car &sink$$))) ; SINK位置.脇寸法1,2,3ｽﾃﾝ  (&sink$$の最初のもの)
;;;2011/09/14YM@DEL        (setq #dimRP (nth #j (car &sink$$))) ; SINK位置.脇寸法1,2,3ﾗﾋﾟｽ (&sink$$の最初のもの)
;;;2011/09/14YM@DEL        (if (> #dimST 0.1)
;;;2011/09/14YM@DEL          (progn
;;;2011/09/14YM@DEL            (add_list (strcat (itoa (fix (+ #dimST 0.001))) " ("
;;;2011/09/14YM@DEL                              (itoa (fix (+ #dimRP 0.001))) ")"))
;;;2011/09/14YM@DEL            (Setq #dimST$ (append #dimST$ (list #dimST)))
;;;2011/09/14YM@DEL            (Setq #dimRP$ (append #dimRP$ (list #dimRP)))
;;;2011/09/14YM@DEL          )
;;;2011/09/14YM@DEL        )
;;;2011/09/14YM@DEL        (setq #i (1+ #i))
;;;2011/09/14YM@DEL        (setq #j (1+ #j))
;;;2011/09/14YM@DEL;;;01/01/11YM@        (setq #dum (nth #i (car &sink$$))) ; SINK位置
;;;2011/09/14YM@DEL;;;01/01/11YM@        (if (> #dum 0.1)
;;;2011/09/14YM@DEL;;;01/01/11YM@          (add_list (itoa (fix (+ #dum 0.001))))
;;;2011/09/14YM@DEL;;;01/01/11YM@        );_if
;;;2011/09/14YM@DEL;;;01/01/11YM@        (setq #i (1+ #i))
;;;2011/09/14YM@DEL      )
;;;2011/09/14YM@DEL      (end_list)
;;;2011/09/14YM@DEL    )
;;;2011/09/14YM@DEL    (progn
;;;2011/09/14YM@DEL      (princ) ; 00/11/30 YM ADD
;;;2011/09/14YM@DEL    )
;;;2011/09/14YM@DEL  );_if
;;;2011/09/14YM@DEL  (setq #DimA (##GetDimA #snk)) ; 初期表示ｼﾝｸに対する標準寸法
;;;2011/09/14YM@DEL  (if (= #ZaiF "1")
;;;2011/09/14YM@DEL    (setq #dimA$ #dimST$)
;;;2011/09/14YM@DEL    (setq #dimA$ #dimRP$)
;;;2011/09/14YM@DEL  );_if
;;;2011/09/14YM@DEL
;;;2011/09/14YM@DEL;;; (setq #i 0 #focus nil) ; 02/11/15 YM MOD
;;;2011/09/14YM@DEL  (setq #i 0 #focus 0) ; 02/11/15 YM MOD
;;;2011/09/14YM@DEL  (foreach dimA #dimA$
;;;2011/09/14YM@DEL    (if (equal dimA #DimA 0.1)
;;;2011/09/14YM@DEL      (setq #focus #i)
;;;2011/09/14YM@DEL    );_if
;;;2011/09/14YM@DEL    (setq #i (1+ #i))
;;;2011/09/14YM@DEL  )
;;;2011/09/14YM@DEL
;;;2011/09/14YM@DEL;;; ﾀｲﾙの初期設定
;;;2011/09/14YM@DEL;;;  (set_tile "sinkpos" "0") ; 初期は最初の項目を表示
;;;2011/09/14YM@DEL  (if #focus
;;;2011/09/14YM@DEL    (set_tile "sinkpos" (itoa #focus)) ; 初期は最初の項目を表示 01/03/08 YM MOD 標準寸法にﾌｫｰｶｽ
;;;2011/09/14YM@DEL    (set_tile "sinkpos" "0") ; 選択したｼﾝｸ脇寸法
;;;2011/09/14YM@DEL  );_if
;-- 2011/09/16 A.Satoh Mod - S
;;;;;
;;;;;  ; 選択したｼﾝｸ脇寸法
;;;;;  (set_tile "edit_sinkpos"
;;;;;;;;2011/09/14YM@DEL    (rtos (nth (+ (atoi (get_tile "sinkpos")) #i1) (car &sink$$)) 2 0) ; 十進小数0
;;;;;    (rtos 777.7 2 1) ; 十進小数0 【暫定】
;;;;;  )
  (setq #xd_G_LSYM$ (CFGetXData &CAB "G_LSYM"))
  (if #xd_G_LSYM$
    (progn
      (setq #hinban (nth  5 #xd_G_LSYM$))
      (setq #LR     (nth  6 #xd_G_LSYM$))
      (setq #youto  (itoa (nth 12 #xd_G_LSYM$)))
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "品番図形"
          (list
            (list "品番名称" #hinban 'STR)
            (list "LR区分"   #LR     'STR)
            (list "用途番号" #youto  'INT)
          )
        )
      )
      (if (and #qry$$ (= 1 (length #qry$$)))
        (setq #width_CAB (/ (nth 3 (car #qry$$)) 2))
				;else
        (setq #width_CAB 0.0)
      )
    )
		;else
    (setq #width_CAB 0.0)
  )

	;2017/01/11 YM ADD-S
	; Errmsg.ini 特定のｼﾝｸはｼﾝｸ脇きめうち　＜特殊処理＞

;;;	(CFAlertMsg "★（３）★ ＜PG改修＞ ERRMSG.INIを見に行く") ;2017/01/19 YM ADD

	(setq #sSINK$ (CFgetini "SINK_WAKI" "SINK" (strcat CG_SKPATH "ERRMSG.INI")))
	(setq #sDIST$ (CFgetini "SINK_WAKI" "DIST" (strcat CG_SKPATH "ERRMSG.INI")))

  (if (strp #sSINK$) (setq #sSINK$ (strparse #sSINK$ ",")))
  (if (strp #sDIST$) (setq #sDIST$ (strparse #sDIST$ ",")))
	; #snk
	(setq #iii 0)
	(setq #width_SP nil) 
	(foreach #sSINK #sSINK$
		(if (= #sSINK #snk)
			(progn ;該当のｼﾝｸだった
				(setq #width_SP (atof (nth #iii #sDIST$)))
			)
		);_if
		(setq #iii (1+ #iii))
	);foreach

;;;	(CFAlertMsg "★（４）★ ＜PG改修＞ ERRMSG.INIを見に行った") ;2017/01/19 YM ADD

	;2017/01/11 YM ADD-E


	(if #width_SP
		(progn
	  	(set_tile "edit_sinkpos" (rtos #width_SP 2 1));Pシンクなど特殊
;;;			(setq #width #width_SP);戻り値 2017/01/20 YM DEL
		)
		;else
		(progn
	  	(set_tile "edit_sinkpos" (rtos #width_CAB 2 1));ｼﾝｸｷｬﾋﾞｾﾝﾀｰ
;;;			(setq #width #width_CAB);戻り値 2017/01/20 YM DEL
		)
	);_if

;-- 2011/09/16 A.Satoh Mod - E

;-- 2011/09/17 A.Satoh Del - S
;;;;;;;; 初期水栓穴種類ﾘｽﾄ
;;;;;;-- 2011/06/29 A.Satoh Mod -S
;;;;;; ☆☆☆☆ 6/29時点での暫定処理
;;;;;; ☆☆☆☆ 仕様確定後に対応
;;;;;;|
;;;;;  (setq #sui$$ '())
;;;;;  (start_list "hole" 3)
;;;;;  (setq #i 10)
;;;;;  (repeat 5
;;;;;    (setq #dim (nth #i (car &name$$))) ; WTｼﾝｸ.水栓穴ID 1,2,3,4,5 (&name$$の最初のもの)
;;;;;    (if (> #dim 0.1)
;;;;;      (progn
;;;;;        (setq #sui$ ; １つ引き当て 水栓穴IDから水栓穴タイプ引き当て
;;;;;          (CFGetDBSQLRec CG_DBSESSION "WT水栓穴"
;;;;;            (list (list "水栓穴ID" (itoa (fix (+ #dim 0.001))) 'INT))
;;;;;          )
;;;;;        );_(setq
;;;;;        (setq #sui$ (DBCheck #sui$ "『WT水栓穴』" "KPSelectSinkDlg")) ; nil or 複数時 ｴﾗｰ
;;;;;        (setq #sui$$ (append #sui$$ (list #sui$))) ; ***
;;;;;        (add_list (nth 2 #sui$)) ; WT水栓穴N.水栓穴タイプ
;;;;;      )
;;;;;    );_if
;;;;;    (setq #i (1+ #i))
;;;;;  )
;;;;;  (end_list)
;;;;;
;;;;;;;; ﾀｲﾙの初期設定
;;;;;  (set_tile "hole" "0")    ; 初期は最初の項目を表示
;;;;;|;
;;;;;  (mode_tile "hole" 1)
;;;;;;-- 2011/06/29 A.Satoh Mod -E
;-- 2011/09/17 A.Satoh Del - E

  ;;; ｼﾝｸLR選択
;-- 2012/05/18 A.Satoh Mod LR有無制御不正 - S
;;;;;;-- 2011/11/21 A.Satoh Mod - S
;;;;;;;;;;  ;2011/09/14 YM ADD-S
;;;;;;;;;;  (cond
;;;;;;;;;;    ((= #SNK_KATTE "R")
;;;;;;;;;;      (set_tile "radioR" "1") ; "R"
;;;;;;;;;;    )
;;;;;;;;;;    ((= #SNK_KATTE "L")
;;;;;;;;;;      (set_tile "radioL" "1") ; "L"
;;;;;;;;;;    )
;;;;;;;;;;    (T
;;;;;;;;;;      (set_tile "radioR" "1") ; "R"
;;;;;;;;;;    )
;;;;;;;;;;  );_cond
;;;;;;;;;;  (mode_tile "radio" 0)   ; LR有無選択可能
;;;;;;;;;;  ;2011/09/14 YM ADD-E
;;;;;	(cond
;;;;;		((= #SNK_KATTE "R")
;;;;;			(set_tile "radioR" "1") ; "R"
;;;;;			(mode_tile "radio" 1)   ; LR有無選択不可
;;;;;		)
;;;;;		((= #SNK_KATTE "L")
;;;;;			(set_tile "radioL" "1") ; "L"
;;;;;			(mode_tile "radio" 1)   ; LR有無選択不可
;;;;;		)
;;;;;		(T
;;;;;			(set_tile "radioL" "1") ; "L"
;;;;;			(mode_tile "radio" 0)   ; LR有無選択可能
;;;;;		)
;;;;;	)
  (setq #umu_LR (nth 4 (nth 0 &name$$)))  ; LR有無
  (if (= #umu_LR 0)
    (progn
      (set_tile "radioR" "0") ; "R"
      (set_tile "radioL" "0") ; "R"
      (mode_tile "radio" 1)   ; LR有無選択不可
    )
    (progn
      (cond
        ((= #SNK_KATTE "R")
          (set_tile "radioR" "1") ; "R"
		      (mode_tile "radio" 1)   ; LR有無選択不可
        )
        ((= #SNK_KATTE "L")
          (set_tile "radioL" "1") ; "L"
		      (mode_tile "radio" 1)   ; LR有無選択不可
        )
        (T
          (set_tile "radioL" "1") ; "L"
		      (mode_tile "radio" 0)   ; LR有無選択可能
        )
      )
    )
  )
;;;;;;-- 2011/11/21 A.Satoh Mod - E
;-- 2012/05/18 A.Satoh Add LR有無制御不正 - E

;-- 2011/09/16 A.Satoh Mod - S
;;;;;;;01/12/14YM@MOD  (set_tile "radioR" "1")
;;;;;;;01/12/14YM@MOD (if (equal (nth 9 (car &name$$)) 0.0 0.1) ; LR有無 00/10/25 YM ADD
;;;;;;;01/12/14YM@MOD   (mode_tile "radio" 1) ; LR有無なし ; 使用不可
;;;;;;;01/12/14YM@MOD   (mode_tile "radio" 0) ; LR有無あり ; 使用可
;;;;;;;01/12/14YM@MOD );_if
;;;;  (set_tile "text2" "WT端からのシンク位置")
;;;;;;; (set_tile "text2" "右端からのシンク位置")
;;;;
;;;;2011/09/14YM@DEL; ｼﾝｸﾎﾟｹｯﾄ付きﾗｼﾞｵﾎﾞﾀﾝ 01/02/09 YM ADD
;;;;2011/09/14YM@DEL  (cond
;;;;2011/09/14YM@DEL    ((= (nth 16 (car &name$$)) "P")
;;;;2011/09/14YM@DEL      (mode_tile "radioPOCKET" 0) ; 使用可能
;;;;2011/09/14YM@DEL    )
;;;;2011/09/14YM@DEL    (T
;;;;2011/09/14YM@DEL      (set_tile "radioPN" "1")
;;;;2011/09/14YM@DEL      (mode_tile "radioPOCKET" 1) ; 使用不可能
;;;;2011/09/14YM@DEL    )
;;;;2011/09/14YM@DEL  );_cond
  (set_tile "text2" "ｼﾝｸｷｬﾋﾞｾﾝﾀｰ位置")
;-- 2011/09/16 A.Satoh Mod - E

;-- 2011/09/17 A.Satoh Mod - S
;;;;;;;; 初期水栓ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;;-- 2011/06/29 A.Satoh Mod -S
;;;;;; ☆☆☆☆ 6/29時点での暫定処理
;;;;;; ☆☆☆☆ 仕様確定後に対応
;;;;;;|
;;;;;  (setq #sui$ (car #sui$$))
;;;;;  (##SUISENpop) ; ｼﾝｸ記号,WT水栓穴Nﾚｺｰﾄﾞ #snk #sui$ を使用する
;;;;;|;
;;;;;  (mode_tile "suiL" 1)
;;;;;  (mode_tile "suiR" 1)
;;;;;  (mode_tile "sui"  1)
;;;;;  (mode_tile "opL"  1)
;;;;;  (mode_tile "opR"  1)
;;;;;;-- 2011/06/29 A.Satoh Mod -E
  ;;; 水栓ポップアップリスト初期設定
  (setq #ana_type (nth 7 (car #name$$)))
  (setq #type     (nth 8 (car #name$$)))
  (setq #kikaku   (nth 9 (car #name$$)))

  ; 【WT水栓穴】から水栓穴情報を取り出す
  (setq #sui_ana$$
    (CFGetDBSQLRec CG_DBSESSION "WT水栓穴"
      (list (list "水栓穴タイプ種別" #ana_type 'STR))
    )
  )
  (if #sui_ana$$
    (progn
      (setq #sui_ana$$ (CFListSort #sui_ana$$ 0))
      (setq #idx 0)
      (setq #def_no1 0)
      (repeat (length #sui_ana$$)
        (if (= 1 (nth 8 (nth #idx #sui_ana$$)))
          (setq #def_no1 #idx)
        )
        (setq #idx (1+ #idx))
      )
    )
    (progn
      (setq #msg (strcat "『WT水栓穴』にﾚｺｰﾄﾞがありません。\n水栓穴タイプ種別=" #ana_type))
      (CFAlertMsg #msg)
      (quit)
    )
  )

  ; 水栓穴リストにアイテムを設定
  (start_list "hole" 3)
  (foreach #lst #sui_ana$$
    (add_list (nth 2 #lst))
  )
  (end_list)
  (set_tile "hole" (itoa #def_no1))

  ; 【SINK水栓管理】から水栓情報を取り出す
  (setq #suisen$$
    (CFGetDBSQLRec CG_DBSESSION "WT水栓管"
      (list (list "選択肢種別" #type 'STR))
    )
  )
  (if #suisen$$
    (progn
      (setq #suisen$$ (CFListSort #suisen$$ 0))
      (setq #def_no2 0)
      (setq #idx 0)
      (repeat (length #suisen$)
        (if (= 1 (nth 5 (nth #idx #sui_ana$$)))
          (setq #def_no2 #idx)
        )
        (setq #idx (1+ #idx))
      )
    )
    (progn
      (setq #msg (strcat "『WT水栓管』にﾚｺｰﾄﾞがありません。\n選択肢種別=" #type))
      (CFAlertMsg #msg)
      (quit)
    )
  )

  (##SetEnableList (nth #def_no1 #sui_ana$$))
;-- 2011/09/17 A.Satoh Mod - E

;;;09/22YM@;;; 穴径の初期設定
;;;09/22YM@  (set_tile "kei1" "36")
;;;09/22YM@  (set_tile "kei2" "-")

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
;;;;;  (action_tile "radio" "(##CHG_sinkLR)")                 ; ｼﾝｸLRが変わると
;;;;;;;;2011/09/14YM@DEL  (action_tile "radioPOCKET" "(##CHG_sinkPOCKET)")       ; ｼﾝｸﾎﾟｹｯﾄ有無が変わると
  (action_tile "sink" "(##CHG_sink)")                    ; ｼﾝｸが変わると
;;;;;;;;2011/09/14YM@DEL  (action_tile "sinkpos" "(##CHG_sinkpos)")              ; ｼﾝｸ位置が変わると edit_sinkpos
  (action_tile "edit_sinkpos" "(##CHK_edit \"edit_sinkpos\")"); ｼﾝｸ位置位置ｴﾃﾞｨｯﾄﾎﾞｯｸｽﾁｪｯｸ
  (action_tile "hole" "(##CHG_hole $value)")             ; 水栓穴が変わると

;;;	;2012/08/02 YM ADD-S
;;;	(action_tile "BUTTON"  "(##SHOW_TEXT)")
;;;	;2012/08/02 YM ADD-E

  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")   ; OK
  (action_tile "cancel" "(setq #ret$ nil)(done_dialog)") ; cancel
  (start_dialog)
  (unload_dialog #dcl_id)
;-- 2011/09/17 A.Satoh Add - S
  (if #ret$
    (setq #ret$ (append #ret$ (list #width_CAB)))
  )
;-- 2011/09/17 A.Satoh Add - E
  #ret$
);KPSelectSinkDlg


;;;01/01/15/YM@;;;<HOM>*************************************************************************
;;;01/01/15/YM@;;; <関数名>    : PK_MakeG_WTR
;;;01/01/15/YM@;;; <処理概要>  : 円"G_WTR"を作成する
;;;01/01/15/YM@;;; <戻り値>    : 円図形名
;;;01/01/15/YM@;;; <作成>      : 00/07/22 YM
;;;01/01/15/YM@;;; <備考>      :
;;;01/01/15/YM@;;;*************************************************************************>MOH<
;;;01/01/15/YM@(defun PK_MakeG_WTR (
;;;01/01/15/YM@  &kei ; 直径
;;;01/01/15/YM@  &o   ; 中心座標
;;;01/01/15/YM@  /
;;;01/01/15/YM@  )
;;;01/01/15/YM@  (entmake ; 中心点と半径を利用してソリッドの元となる円を作る
;;;01/01/15/YM@    (list
;;;01/01/15/YM@      '(0 . "CIRCLE")
;;;01/01/15/YM@      '(100 . "AcDbEntity")
;;;01/01/15/YM@      '(67 . 0)
;;;01/01/15/YM@      (cons 8 SKW_AUTO_SECTION)
;;;01/01/15/YM@      '(62 . 2)
;;;01/01/15/YM@      '(100 . "AcDbCircle")
;;;01/01/15/YM@      (cons 10 &o) ; 中心点
;;;01/01/15/YM@      (cons 40 (/ &kei 2))
;;;01/01/15/YM@      '(210 0.0 0.0 1.0)
;;;01/01/15/YM@    )
;;;01/01/15/YM@  )
;;;01/01/15/YM@  (entlast)
;;;01/01/15/YM@);PK_MakeG_WTR

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_PosWTR
;;; <処理概要>  : 水栓を配置する
;;; <戻り値>    :
;;;        LIST : 水栓穴(G_WTR)図形のリスト
;;; <作成>      : 1999-10-21
;;; <備考>      : 水栓ありで「水栓」なしの場合 01/01/15 YM ADD
;;;*************************************************************************>MOH<
(defun PKW_PosWTR (
  &KCode        ;(STR)工種記号
  &SeriCode     ;(STR)SERIES記号
  &snk-en       ;(ENAME)シンク基準図形
  &snk-cd       ;(STR)シンク記号
;-- 2011/09/18 A.Satoh Mod(コメント変更) - S
;  &plis$        ;選択された"WT水栓管" ﾚｺｰﾄﾞ (属性 -2,-1,0,1,2 の順) nil あり
  &plis$        ;選択されたWT水栓管品番リスト (nil 品番 nil 品番 nil)
  &scab-en      ;(ENAME)ｼﾝｸｷｬﾋﾞ基点図形
  &kikaku_zok   ; 規格穴属性
;-- 2011/09/18 A.Satoh Mod(コメント変更) - E
  /
;-- 2011/09/18 A.Satoh Mod - S
;;;;;  #ANG #EN #FIG-QRY$ #HINBAN
;;;;;  #I #K #KEI #ANA_LAYER
;;;;;  #O #OS #PLIS
;;;;;  #PT #PTEN5 #PTEN5$ #PTEN5$$
;;;;;  #SM #WtrHoleEn$ #XD_PTEN$ #msg
;;;;;;-- 2011/09/09 A.Satoh Mod - S
;;;;;;  #ZOKU #ZOKUP #ZOKUP$ #dum #FLG #SS_DUM
;;;;;  #ZOKU #ZOKUP #ZOKUP$ #FLG #SS_DUM
;;;;;;-- 2011/09/09 A.Satoh Mod - E
;;;;;  #ANG0 #LR #WTRSYM$
  #kikaku_f #fig #WtrHoleEn$ #plis #flg #ANA_layer
  #os #sm #pten5$$ #xd_G_LSYM$ #basePnt #idx #idx2 #wk_pten5$$
  #pten5$ #dist #pten_pnt #plis_len #hinban #fig-qry$
  #xd_PTEN$ #pten5 #zokuP #o #ang #ang0 #LR #msg
  #ss_dum #en #WTRSYM$ #cnt #skip
;-- 2011/09/18 A.Satoh Mod - S
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_PosWTR ////")
  (CFOutStateLog 1 1 " ")

;-- 2011/09/12 A.Satoh Add - S
  ;;; 規格判定フラグ T:規格品 nil:特注品
  (setq #kikaku_f T)
;-- 2011/09/12 A.Satoh Add - E
  (setq #flg nil #WtrHoleEn$ '())
  (foreach #plis &plis$
    (if #plis
      (setq #flg T)
    )
  )
; 水栓ありで「水栓」なしの場合 01/01/15 YM ADD
;;;  (setq #ANA_layer "Z_00_00_00_01" ) ; 目に見える
  (setq #ANA_layer SKW_AUTO_SECTION) ; 目に見えない

  (setq #cnt 0)
  (if #flg
    (progn
      ;// システム変数保管
      (setq #os (getvar "OSMODE"))   ;Oスナップ
      (setq #sm (getvar "SNAPMODE")) ;スナップ
      (setvar "OSMODE"   0)
      (setvar "SNAPMODE" 0)

      (if (not (tblsearch "APPID" "G_WTR")) (regapp "G_WTR"))

      ;// シンクに設定されている水栓取付け点（Ｐ点=５）の情報を取得する
      (setq #pten5$$ (PKGetPTEN_NO &snk-en 5)) ; 戻り値(PTEN図形,G_PTEN)のﾘｽﾄのﾘｽﾄ

;-- 2011/09/18 A.Satou Mod - S
      ; シンクキャビの左上基点を取得する
      (setq #xd_G_LSYM$ (CFGetXData &scab-en "G_LSYM"))
      (setq #basePnt (nth 1 #xd_G_LSYM$))

      ; 取得したP点5図形をシンクキャビ基点との距離によりソートする
      (setq #idx 0)
      (setq #wk_pten5$$ nil)
      (setq #dist 0.0)
      (repeat (length #pten5$$)
        (setq #pten_pnt (cdr (assoc 10 (entget (car (nth #idx #pten5$$))))))
        (setq #dist (distance #basePnt #pten_pnt))
        (setq #wk_pten5$$ (append #wk_pten5$$ (list (cons #dist (nth #idx #pten5$$)))))
        (setq #idx (1+ #idx))
      )
      (setq #pten5$$ (CFListSort #wk_pten5$$ 0))

;-- 2011/10/04 A.Satoh Mod - S
      (setq #plis_len (length &plis$))
      (setq #idx 0)
      (setq #idx2 0)
      (repeat (length #pten5$$)
        (setq #skip nil)
        (setq #pten5$ (nth #idx #pten5$$))

        (setq #xd_PTEN$ (nth 2 #pten5$))
        (setq #pten5    (nth 1 #pten5$))
        (setq #zokuP (nth 2 #xd_PTEN$))    ; 属性
        (cond
          ((= #plis_len 1)
            (if (or (= #zokuP 1) (= #zokuP -1))
              (setq #skip T)
            )
          )
          ((= #plis_len 2)
            (if (= #zokuP 0)
              (setq #skip T)
            )
          )
        )

        (if (= #skip nil)
          (progn
            (if (/= (nth #idx2 &plis$) nil)
              (progn
                (setq #cnt (1+ #cnt))
                (setq #hinban (nth #idx2 &plis$))

                (setq #fig-qry$ ; 水栓金具の品番を１つ引き当て
                  (CFGetDBSQLRec CG_DBSESSION "品番図形"
                    (list (list "品番名称" #hinban 'STR))
                  )
                )
                (setq #fig-qry$ (DBCheck #fig-qry$ "『品番図形』" (strcat "品番名称:" #hinban)))

                (if (/= &kikaku_zok #zokuP)
                  (setq #kikaku_f nil)
                )
                (setq #o (cdr (assoc 10 (entget #pten5)))) ; 中心点座標

                ; 水栓金具の配置
                (setq #ang (nth 2 (CFGetXData &snk-en "G_LSYM"))) ; 配置角度
                (setq #LR  (nth 6 (CFGetXData &snk-en "G_LSYM"))) ; LRﾀｲﾌﾟ

                ; 図形が存在するか確認
                (if (= nil (findfile (strcat CG_MSTDWGPATH (nth 6 #fig-qry$) ".dwg")))
                  (progn
                    (setq #msg (strcat "水栓図形 : ID=" (nth 6 #fig-qry$) " がありません"))
                    (CFAlertMsg #msg)
                    (*error*)
                  )
                )
                (setq #ang0 #ang)

                ; インサート
                (command "_insert"
                  (strcat CG_MSTDWGPATH (nth 6 #fig-qry$)) ; 品番図形.図形ID
                  #o 1 1 (rtd #ang0)
                )
                (command "_purge" "bl" "*" "N")
                (command "_purge" "bl" "*" "N")
                (command "_purge" "bl" "*" "N")
                (command "_purge" "bl" "*" "N")

                (command "_explode" (entlast))
                (setq #ss_dum (ssget "P"))
                (SKMkGroup #ss_dum)
                (setq #en (PKC_GetSymInGroup #ss_dum))

                ; 拡張データの付加
                (CFSetXData #en "G_LSYM"
                  (list
                    (nth 6 #fig-qry$)          ;1 :本体図形ID  ; 品番図形.図形ＩＤ
                    #o                         ;2 :挿入点
                    #ang0                      ;3 :回転角度
                    &KCode                     ;4 :工種記号
                    &SeriCode                  ;5 :SERIES記号
                    (nth 0 #fig-qry$)          ;6 :品番名称
                    "Z"                        ;7 :L/R 区分
                    ""                         ;8 :扉図形ID
                    ""                         ;9 :扉開き図形ID
                    CG_SKK_INT_SUI             ;10:性格CODE
                    2                          ;11:複合フラグ
                    0                          ;12:レコード番号
                    (fix (nth 2 #fig-qry$))    ;13:用途番号
                    0.0                        ;14:寸法H
                    1                          ;15:断面指示の有無
                    "A"                        ;16:分類(ｷｯﾁﾝ"A" or 収納"D")
                  )
                );_CFSetXData
                (KcSetG_OPT #en) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ
                (setq #WTRSYM$ (append #WTRSYM$ (list #en)))
              )
            )
            (setq #idx2 (1+ #idx2))
          )
        )
        (setq #idx (1+ #idx))
      )
;;;;;      (setq #plis_len (length &plis$))
;;;;;      (setq #idx 0)
;;;;;      (repeat (length &plis$)
;;;;;        (if (/= (nth #idx &plis$) nil)
;;;;;          (progn
;;;;;            (setq #cnt (1+ #cnt))
;;;;;            (setq #hinban (nth #idx &plis$))
;;;;;
;;;;;            (setq #fig-qry$ ; 水栓金具の品番を１つ引き当て
;;;;;              (CFGetDBSQLRec CG_DBSESSION "品番図形"
;;;;;                (list (list "品番名称" #hinban 'STR))
;;;;;              )
;;;;;            )
;;;;;            (setq #fig-qry$ (DBCheck #fig-qry$ "『品番図形』" (strcat "品番名称:" #hinban)))
;;;;;
;;;;;;            (if (or (= &snk-cd "S_") (= &snk-cd "L1_"))
;;;;;            (if (or (= &snk-cd "S_") (= &snk-cd "L_"))
;;;;;              (setq #pten5$ (nth 1 #pten5$$))
;;;;;              (setq #pten5$ (nth #idx #pten5$$))
;;;;;            )
;;;;;
;;;;;            (setq #xd_PTEN$ (nth 2 #pten5$))
;;;;;            (setq #pten5    (nth 1 #pten5$))
;;;;;            (setq #zokuP (nth 2 #xd_PTEN$))    ; 属性
;;;;;            (if (/= &kikaku_zok #zokuP)
;;;;;              (setq #kikaku_f nil)
;;;;;            )
;;;;;            (setq #o (cdr (assoc 10 (entget #pten5)))) ; 中心点座標
;;;;;
;;;;;            ; 水栓金具の配置
;;;;;            (setq #ang (nth 2 (CFGetXData &snk-en "G_LSYM"))) ; 配置角度
;;;;;            (setq #LR  (nth 6 (CFGetXData &snk-en "G_LSYM"))) ; LRﾀｲﾌﾟ
;;;;;
;;;;;            ; 図形が存在するか確認
;;;;;            (if (= nil (findfile (strcat CG_MSTDWGPATH (nth 6 #fig-qry$) ".dwg")))
;;;;;              (progn
;;;;;                (setq #msg (strcat "水栓図形 : ID=" (nth 6 #fig-qry$) " がありません"))
;;;;;                (CFAlertMsg #msg)
;;;;;                (*error*)
;;;;;              )
;;;;;            )
;;;;;            (setq #ang0 #ang)
;;;;;
;;;;;            ; インサート
;;;;;            (command "_insert"
;;;;;              (strcat CG_MSTDWGPATH (nth 6 #fig-qry$)) ; 品番図形.図形ID
;;;;;              #o 1 1 (rtd #ang0)
;;;;;            )
;;;;;            (command "_purge" "bl" "*" "N")
;;;;;            (command "_purge" "bl" "*" "N")
;;;;;            (command "_purge" "bl" "*" "N")
;;;;;            (command "_purge" "bl" "*" "N")
;;;;;
;;;;;            (command "_explode" (entlast))
;;;;;            (setq #ss_dum (ssget "P"))
;;;;;            (SKMkGroup #ss_dum)
;;;;;            (setq #en (PKC_GetSymInGroup #ss_dum))
;;;;;
;;;;;            ; 拡張データの付加
;;;;;            (CFSetXData #en "G_LSYM"
;;;;;              (list
;;;;;                (nth 6 #fig-qry$)          ;1 :本体図形ID  ; 品番図形.図形ＩＤ
;;;;;                #o                         ;2 :挿入点
;;;;;                #ang0                      ;3 :回転角度
;;;;;                &KCode                     ;4 :工種記号
;;;;;                &SeriCode                  ;5 :SERIES記号
;;;;;                (nth 0 #fig-qry$)          ;6 :品番名称
;;;;;                "Z"                        ;7 :L/R 区分
;;;;;                ""                         ;8 :扉図形ID
;;;;;                ""                         ;9 :扉開き図形ID
;;;;;                CG_SKK_INT_SUI             ;10:性格CODE
;;;;;                2                          ;11:複合フラグ
;;;;;                0                          ;12:レコード番号
;;;;;                (fix (nth 2 #fig-qry$))    ;13:用途番号
;;;;;                0.0                        ;14:寸法H
;;;;;                1                          ;15:断面指示の有無
;;;;;                "A"                        ;16:分類(ｷｯﾁﾝ"A" or 収納"D")
;;;;;              )
;;;;;            );_CFSetXData
;;;;;            (KcSetG_OPT #en) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ
;;;;;            (setq #WTRSYM$ (append #WTRSYM$ (list #en)))
;;;;;          )
;;;;;        )
;;;;;        (setq #idx (1+ #idx))
;;;;;      )
;-- 2011/10/04 A.Satoh Mod - E
;;;;;      (setq #i 0)
;;;;;      ; 01/07/17 YM ADD
;;;;;      (setq #WTRSYM$ nil)
;;;;;      (repeat (length &plis$)
;;;;;        (setq #plis (nth #i &plis$))
;;;;;;;; #plis=num の場合
;;;;;        (if (and #plis (not (listp #plis))) ; ﾘｽﾄでない場合水栓がないが穴を開ける場合 00/09/19 YM MOD
;;;;;          (progn
;;;;;            (setq #zoku (atoi #plis))
;;;;;            (setq #k 0)
;;;;;            (setq #zokuP$ '())
;;;;;            (foreach #pten5$ #pten5$$
;;;;;              (setq #xd_PTEN$ (cadr #pten5$))    ; 拡張ﾃﾞｰﾀ"G_PTEN"
;;;;;              (setq #zokuP (nth 2 #xd_PTEN$))    ; 属性
;;;;;              (if (and (= #zokuP #zoku)               ; 属性が同じなら水栓配置
;;;;;                       (= (member #zokuP #zokuP$) nil))
;;;;;                (progn
;;;;;                  (setq #zokuP$ (append #zokuP$ (list #zokuP))) ; PTEN5図形名
;;;;;                  (setq #pten5 (car  #pten5$))   ; PTEN5図形名
;;;;;                  (setq #kei (nth 1 #xd_PTEN$))  ; 穴径
;;;;;                  (setq #o (cdr (assoc 10 (entget #pten5)))) ; 中心点座標
;;;;;;-- 2011/09/09 A.Satoh Del - S
;;;;;;                  (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"の円を作成する
;;;;;;                  ;// 水栓穴拡張データを設定
;;;;;;                  (CFSetXData #dum "G_WTR" (list #zokuP))
;;;;;;                  (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; 水栓穴図形名
;;;;;;-- 2011/09/09 A.Satoh Del - E
;;;;;                )
;;;;;              );_if
;;;;;            );_foreach
;;;;;          )
;;;;;        );_if
;;;;;;;; #plis='(LIST) の場合
;;;;;        (if (and #plis (listp #plis)) ; 水栓がある場合
;;;;;          (progn
;;;;;            (setq #zoku (fix (nth 2 #plis)))   ; 属性
;;;;;            (setq #hinban (nth 3 #plis))       ; 品番名称
;;;;;            (setq #fig-qry$ ; 水栓金具の品番を１つ引き当て
;;;;;              (CFGetDBSQLRec CG_DBSESSION "品番図形"
;;;;;                (list (list "品番名称" #hinban 'STR))
;;;;;              )
;;;;;            );_(setq
;;;;;            (setq #fig-qry$ (DBCheck #fig-qry$ "『品番図形』" (strcat "品番名称:" #hinban)))
;;;;;
;;;;;            (setq #k 0)
;;;;;            (setq #zokuP$ '())
;;;;;            (foreach #pten5$ #pten5$$
;;;;;              (setq #xd_PTEN$ (cadr #pten5$))    ; 拡張ﾃﾞｰﾀ"G_PTEN"
;;;;;              (setq #zokuP (nth 2 #xd_PTEN$))    ; 属性
;;;;;              (if (and (= #zokuP #zoku)               ; 属性が同じなら水栓配置
;;;;;                       (= (member #zokuP #zokuP$) nil))
;;;;;                (progn
;;;;;                  (setq #zokuP$ (append #zokuP$ (list #zokuP))) ; PTEN5図形名
;;;;;                  (setq #pten5 (car  #pten5$))   ; PTEN5図形名
;;;;;                  (setq #kei (nth 1 #xd_PTEN$))  ; 穴径
;;;;;                  (setq #o (cdr (assoc 10 (entget #pten5)))) ; 中心点座標
;;;;;;-- 2011/09/09 A.Satoh Del - S
;;;;;;                  (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"の円を作成する
;;;;;;                  ;// 水栓穴拡張データを設定
;;;;;;                  (CFSetXData #dum "G_WTR" (list #zokuP))
;;;;;;                  (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; 水栓穴図形名
;;;;;;-- 2011/09/09 A.Satoh Del - E
;;;;;                  ;// 水栓金具の配置
;;;;;                  (setq #ang (nth 2 (CFGetXData &snk-en "G_LSYM"))) ; 配置角度
;;;;;                  (setq #LR  (nth 6 (CFGetXData &snk-en "G_LSYM"))) ; LRﾀｲﾌﾟ
;;;;;
;;;;;                  ;;; 図形が存在するか確認
;;;;;                  (if (= nil (findfile (strcat CG_MSTDWGPATH (nth 6 #fig-qry$) ".dwg")));2008/06/28 YM OK!
;;;;;                    (progn
;;;;;                      (setq #msg (strcat "水栓図形 : ID=" (nth 6 #fig-qry$) " がありません"));2008/06/28 YM OK!
;;;;;;;;                      (CFOutLog 0 nil #msg)
;;;;;;;;                      (CFOutLog 0 nil (strcat "  +品番名称:" (nth 0 #fig-qry$)))
;;;;;                      (CFAlertMsg #msg)
;;;;;                      (*error*)
;;;;;                    )
;;;;;                  )
;;;;;                  (setq #ang0 #ang)
;;;;;                  ;// インサート
;;;;;                  (command "_insert"
;;;;;                    (strcat CG_MSTDWGPATH (nth 6 #fig-qry$)) ; 品番図形.図形ID ;2008/06/28 YM OK!
;;;;;                    #o
;;;;;                    1
;;;;;                    1
;;;;;                    (rtd #ang0)
;;;;;                  )
;;;;;                  (command "_purge" "bl" "*" "N") ; 00/10/17 YM ADD
;;;;;                  (command "_purge" "bl" "*" "N") ; 00/10/17 YM ADD
;;;;;                  (command "_purge" "bl" "*" "N") ; 00/10/17 YM ADD
;;;;;                  (command "_purge" "bl" "*" "N") ; 00/10/17 YM ADD
;;;;;
;;;;;                  (command "_explode" (entlast))
;;;;;                  (setq #ss_dum (ssget "P"))
;;;;;                  (SKMkGroup #ss_dum)
;;;;;                ;;(setq #en (SKC_GetSymInGroup (ssname #ss_dum 0))) ;;  2005/08/03 G.YK DEL
;;;;;                  (setq #en (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD
;;;;;
;;;;;                  ;// 拡張データの付加
;;;;;                  (CFSetXData #en "G_LSYM"
;;;;;                    (list
;;;;;                      (nth 6 #fig-qry$)          ;1 :本体図形ID  ; 品番図形.図形ＩＤ ;2008/06/28 YM OK!
;;;;;                      #o                         ;2 :挿入点
;;;;;                      #ang0                      ;3 :回転角度
;;;;;                      &KCode                     ;4 :工種記号
;;;;;                      &SeriCode                  ;5 :SERIES記号
;;;;;                      (nth 0 #fig-qry$)          ;6 :品番名称                          OK!
;;;;;                      "Z"                        ;7 :L/R 区分
;;;;;                      ""                         ;8 :扉図形ID
;;;;;                      ""                         ;9 :扉開き図形ID
;;;;;                      CG_SKK_INT_SUI             ;10:性格CODE ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
;;;;;                      2                          ;11:複合フラグ
;;;;;                      0                          ;12:レコード番号
;;;;;                      (fix (nth 2 #fig-qry$))    ;13:用途番号                          OK!
;;;;;                      0.0                        ;14:寸法H
;;;;;                      1                          ;15:断面指示の有無
;;;;;                      "A"                        ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
;;;;;                    )
;;;;;                  );_CFSetXData
;;;;;                  (KcSetG_OPT #en) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ 01/02/16 MH ADD
;;;;;                  ; 01/07/17 YM ADD
;;;;;                  (setq #WTRSYM$ (append #WTRSYM$ (list #en)))
;;;;;                )
;;;;;              );_if
;;;;;            );_foreach
;;;;;          )
;;;;;        );_if
;;;;;        (setq #i (1+ #i))
;;;;;      );_repeat
;-- 2011/09/18 A.Satou Mod - E

      ;// システム変数を元に戻す
      (setvar "OSMODE"   #os)
      (setvar "SNAPMODE" #sm)
    )
  );_if
;-- 2011/09/17 A.Satoh Mod - S
;;;;;  (list #WtrHoleEn$ #WTRSYM$) ;// 水栓穴(G_WTR)底面図形,水栓SYMを返す

  (if (and (= #kikaku_f T) (/= #cnt 1))
    (setq #kikaku_f nil)
  )

  (list #WtrHoleEn$ #WTRSYM$ #kikaku_f) ;// 水栓穴(G_WTR)底面図形,水栓SYMを返す
;-- 2011/09/17 A.Satoh Mod - E
);PKW_PosWTR


;;;<HOM>*************************************************************************
;;; <関数名>    : PKWTSinkAnaEmbed
;;; <処理概要>  : WT図形,ｼﾝｸｼﾝﾎﾞﾙ図形を渡してWTの穴を埋める
;;; <戻り値>    : なし
;;; <作成>      : 2000-05-12
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKWTSinkAnaEmbed (
  &WT  ; WT図形名
  &SNK ; sinkｼﾝﾎﾞﾙ図形名
  &flg ; 拡張ﾃﾞｰﾀの水栓穴を削除='T
  /
  #HOLE #SNK-XD$ #WT-XD$ #WT_T #setxd$
  #EG #I #WTXD$
#CT_FLG ;2017/01/19 YM ADD
  )

  (setq #SNK-xd$ (CFGetXData &SNK "G_SINK"))
  (setq #hole (nth 3 #SNK-xd$)) ; ｼﾝｸ穴領域
  (if (= #hole "")
    (progn
      (CFAlertMsg "\nシンク穴がありません。")(quit)
    )
    (progn
      (setq #WT-xd$ (CFGetXData &WT "G_WRKT"))
      (setq #WT_T (nth 10 #WT-xd$)) ; WT厚み

      ; 02/12/06 YM ADD-S ｷｯﾁﾝｶﾌｪなら厚み19mm→40mm ｼﾝｸ穴が埋まってないようにみえる
      (setq #CT_flg    (nth 33 #WT-xd$)) ; 元ｶｳﾝﾀｰﾌﾗｸﾞ(ｶｳﾝﾀｰをﾜｰｸﾄｯﾌﾟに変更:1)
      (if (= 1 #CT_flg) ; R付ｶｳﾝﾀｰかどうかで分岐
        (setq #WT_T 40) ; WT厚み=40
      );_if
      ; 02/12/06 YM ADD-E ｷｯﾁﾝｶﾌｪなら厚み19mm→40mm ｼﾝｸ穴が埋まってないようにみえる

      ;2008/07/28 YM MOD 2009対応
      (command "_extrude" #hole "" (- #WT_T) ) ;押し出し
;;;     (command "_extrude" #hole "" (- #WT_T) "") ;押し出し
      (command "_union" &WT (entlast) "")        ;和演算

      ;// 水栓穴領域を検索する
      (setq #i 23)
      (repeat (nth 22 #WT-xd$) ; 水栓穴の個数

        ; 02/04/16 YM MOD-S if文で分岐
        (if &flg ; 水栓穴のﾃﾞｰﾀを削除する
          (progn
            ; #holeはextrudeのとき消える
            (setq #hole (nth #i #WT-xd$)) ; 02/04/16 YM MOD
          )
          (progn
            (setq #eg (entget (nth #i #WT-xd$)))
            (setq #eg (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (cdr #eg)) (cdr #eg)))
            (setq #eg (subst (cons 62 2) (assoc 62 #eg) #eg))
            (entmake #eg) ; 穴のﾀﾞﾐｰ作成
            ; #holeはextrudeのとき消えるが、元の穴図形は残る
            (setq #hole (entlast))
          )
        );_if
        ; 02/04/16 YM MOD-E


        ;2008/07/28 YM MOD 2009対応
        (command "_extrude" #hole "" (- #WT_T) ) ;押し出し
;;;       (command "_extrude" #hole "" (- #WT_T) "") ;押し出し
        (command "_union" &WT (entlast) "")        ;和演算
        (setq #i (1+ #i))
      )
      (if &flg
        (progn
          ;;; 水栓穴がなくなったから
          (setq #setxd$
            (list
              (list 18 0)
              (list 19 "")
              (list 20 "")
              (list 21 "")
              (list 22 0)
              (list 23 "")
              (list 24 "")
              (list 25 "")
              (list 26 "")
              (list 27 "")
              (list 28 "")
              (list 29 "")
            )
          )
          ;// ワークトップ拡張データの更新
          (CFSetXData &WT "G_WRKT"
            (CFModList #WT-xd$ #setxd$)
          )
        )
      );_if
    )
  );_if
  (princ)
);PKWTSinkAnaEmbed

;;;<HOM>*************************************************************************
;;; <関数名>    : SKW_GetSnkCabAreaSym
;;; <処理概要>  : シンクキャビネットの領域に含まれるシンボル図形を検索する
;;; <戻り値>    :
;;;        LIST : 水栓、シンク図形のリスト
;;; <作成>      : 99-10-19
;;; <備考>      : 00/02/22 YM この関数は、ｼﾝｸが複数あってもよい
;;;*************************************************************************>MOH<
(defun SKW_GetSnkCabAreaSym (
  &snkEn          ;(ENAME)シンクキャビネット図形名
;;; &w-en           ; WT図形名
;;; &w-xd$          ; WT拡張データ
  /
  #pt
  #ang #wid #dep
  #xd$
  #p1 #p2 #p3 #p4
  #one
  #ss
  #retEn$
  #i #SETXD$ #SS_WTR
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKW_GetSnkCabAreaSym ////")
  (CFOutStateLog 1 1 " ")
  (command "vpoint" "0,0,1")  ; 00/04/25 YM
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))

  ;// 拡張データを取得
  (setq #ang (nth 2 (CFGetXData &snkEn "G_LSYM"))) ; ｼﾝｸｷｬﾋﾞ図形名に関連 YM
  (setq #xd$ (CFGetXData &snkEn "G_SYM"))          ; ｼﾝｸｷｬﾋﾞ図形名に関連 YM
  (setq #wid (nth 3 #xd$))                         ; ｼﾝｸｷｬﾋﾞ図形名に関連 YM
  (setq #dep (nth 4 #xd$))                         ; ｼﾝｸｷｬﾋﾞ図形名に関連 YM

  (setq #p1 (cdr (assoc 10 (entget &snkEn))))      ; ｼﾝｸｷｬﾋﾞ図形名に関連 YM
  (setq #p2 (polar #p1 #ang #wid))                 ; ｼﾝｸｷｬﾋﾞ図形名に関連 YM
  (setq #p3 (polar #p2 (- #ang (dtr 90)) #dep))    ; ｼﾝｸｷｬﾋﾞ図形名に関連 YM
  (setq #p4 (polar #p1 (- #ang (dtr 90)) #dep))    ; ｼﾝｸｷｬﾋﾞ図形名に関連 YM

  ;// 領域に含まれる、シンク、水栓を検索する
  (setq #i 0)
  (repeat (sslength #ss) ; #ss 図面上すべての "G_LSYM"を調べるのは無駄だがｼﾝｸが複数あってもよい YM
    (setq #pt (cdr (assoc 10 (entget (ssname #ss #i)))))
    (setq #pt (list (car #pt) (cadr #pt))) ; 2D点に変換 YM
    (setq #one (CFGetSymSKKCode (ssname #ss #i) 1)) ; 性格ｺｰﾄﾞ１桁目 YM

    ;// シンク、水栓
    (if (or (= #one CG_SKK_ONE_SNK) (= #one CG_SKK_ONE_WTR)) ; CG_SKK_ONE_SNK=4 , CG_SKK_ONE_WTR=5
      (progn
        ;// 領域内かチェック
        (if (IsPtInPolygon #pt (list #p1 #p2 #p3 #p4 #p1))
          (setq #retEn$ (cons (ssname #ss #i) #retEn$))
        )
      )
    )
    (setq #i (1+ #i))
  )
  (command "zoom" "p")
  #retEn$
)
;SKW_GetSnkCabAreaSym

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun SKC_ConfSinkChkErr (
    &area1$
    &area2$
    /
    #en$
    #cc
    #pw
  )
  (setq #pw (getvar "PLINEWID"))
  (setq #cc (getvar "CECOLOR"))
  (setvar "PLINEWID" 10)
  (setvar "CECOLOR" "2")
  (MakeLwPolyLine &area1$ 1 0)
  (setq #en$ (cons (entlast) #en$))
  (setvar "CECOLOR" "6")
  (MakeLwPolyLine &area2$ 1 0)
  (command "_.redraw")
  (setvar "PLINEWID" #pw)
  (setvar "CECOLOR" #cc)
  (setq #en$ (cons (entlast) #en$))
)

;;;<HOM>*************************************************************************
;;; <関数名>     : SKC_GetTopRightBaseCabPt
;;; <処理概要>   : ベースキャビネットの最右の座標を求める
;;; <戻り値>     :
;;; <作成>       : 2000.1.24修正KPCAD
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun SKC_GetTopRightBaseCabPt (
    &scab-en ; ｼﾝｸｷｬﾋﾞ図形名
    /
    #max #ss #i #xd$ #max #maxen #pt #en
    #BASE$ #EN$ #THR
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKC_GetTopRightBaseCabPt ////")
  (CFOutStateLog 1 1 " ")

      (setq #max 0.)

      (if (= &scab-en nil)
        (progn
          (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; "G_LSYM" を持つ選択セット取得  ; 複数あるとまずい 00/02/22 YM
        )
        (progn
        ;// 指定したキャビネットに隣接するベースキャビを検索する         ; 複数あるとまずい 00/02/22 YM ADD
          (setq #en$ (SKW_GetLinkBaseCab &scab-en))                      ; 複数あるとまずい 00/02/22 YM ADD
          ;// ダイニング部材を省く
          (foreach #en #en$                                              ; 複数あるとまずい 00/02/22 YM ADD
            (setq #thr (CFGetSymSKKCode #en 3))                          ; 複数あるとまずい 00/02/22 YM ADD
            (if (and (/= CG_SKK_THR_ETC #thr) (/= CG_SKK_THR_DIN #thr))  ; 複数あるとまずい 00/02/22 YM ADD
              (setq #base$ (cons #en #base$)) ; 図形名ﾘｽﾄ                ; 複数あるとまずい 00/02/22 YM ADD
            )
          )                                                              ; 複数あるとまずい 00/02/22 YM ADD
          (setq #ss (CMN_enlist_to_ss #base$)) ; 図形名-->選択セット     ; 複数あるとまずい 00/02/22 YM ADD
        )
      );_if

      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i)) ; 各図形名
        (setq #xd$ (CFGetXData #en "G_LSYM")) ; 拡張データのデータ部分のみ

        ;03/11/15 ﾀﾞｲﾆﾝｸﾞは除く
;;;        (if (= CG_SKK_TWO_BAS (CFGetSeikakuToSKKCode (nth 9 #xd$) 2)) ; 性格CODE2桁目=1 --> ﾍﾞｰｽ
        (if (and (/= CG_SKK_ONE_SID (CFGetSeikakuToSKKCode (nth 9 #xd$) 1)) ;03/11/15 ｻｲﾄﾞﾊﾟﾈﾙは除く
                 (=  CG_SKK_TWO_BAS (CFGetSeikakuToSKKCode (nth 9 #xd$) 2)) ; 性格CODE2桁目=1 --> ﾍﾞｰｽ
                 (/= CG_SKK_THR_DIN (CFGetSeikakuToSKKCode (nth 9 #xd$) 3)));03/11/15 ﾀﾞｲﾆﾝｸﾞは除く
          (progn
            (setq #pt (cdr (assoc 10 (entget #en))))
            (if (< #max (car #pt))
              (progn
                (setq #max (car #pt))
                (setq #maxen #en)
              )
            )
          )
        )
        (setq #i (1+ #i))
      )

      (cond
        (T                     ;Ｌ型
          (setq #xd$ (CFGetXData #maxen "G_SYM"))
          (+ #max (nth 3 #xd$)) ; シンボル基準値Ｗ
        )
      );_(cond

);SKC_GetTopRightBaseCabPt

;;;<HOM>*************************************************************************
;;; <関数名>    : SKW_DelSink
;;; <処理概要>  : シンク・水栓の削除
;;; <戻り値>    :
;;; <作成>      : 1999-10-12
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun SKW_DelSink (
  &WSflg   ; WT穴埋めﾌﾗｸﾞ
  &scab-en ; ｼﾝｸｷｬﾋﾞｼﾝﾎﾞﾙ図形名
  &w-en    ; WT図形名
  &w-xd$   ; "G_WRKT"
  /
  #relEn$
  #en
  #ss #SETXD$
	#EANA #I #WTXD$ ;2017/01/19 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKW_DelSink ////")
  (CFOutStateLog 1 1 " ")

  ;// シンクキャビの領域に収まっている水栓を求める
  (setq #relEn$ (SKW_GetSnkCabAreaSym &scab-en))
;;;  (setq #relEn$ (SKW_GetSnkCabAreaSym &scab-en &w-en &w-xd$))

  (foreach #en #relEn$
    (setq #ss (CFGetSameGroupSS #en))

    (if &WSflg ; 穴埋め必要
      (progn
        (if (= (nth 9 (CFGetXData #en "G_LSYM")) CG_SKK_INT_SNK) ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
          (PKWTSinkAnaEmbed &w-en #en T) ; WT図形,ｼﾝｸｼﾝﾎﾞﾙ図形を渡してWTの穴を埋める
        );_if
      )
      (progn ; 水栓穴削除に伴うG_WRKTの書き換え

        ; 02/04/17 YM ADD-S 水栓穴図形ハンドルを削除する
        (setq #wtXd$ (CFGetXData &w-en "G_WRKT"))
        (setq #i 23)
        (repeat (nth 22 #wtXd$) ; 水栓穴の個数
          (setq #eANA (nth #i #wtXd$))
          (if (/= nil (entget #eANA))
            (entdel #eANA)
          );_if
          (setq #i (1+ #i))
        )
        ; 02/04/17 YM ADD-E

;;;      ｼﾝｸ領域内の水栓穴は全て削除--->"G_WRKT"の変更が必要
        ;// 水栓穴関連の拡張データを更新設定する
        (setq #setxd$
          (list
            (list 22 0)
            (list 23 "")
            (list 24 "")
            (list 25 "")
            (list 26 "")
            (list 27 "")
          )
        )
        ;// ワークトップ拡張データの更新
        (CFSetXData
          &w-en
          "G_WRKT"
          (CFModList
            &w-xd$
            #setxd$
          )
        )
      )
    );_if

    (command "_erase" #ss "")
  )
)
;SKW_DelSink

;;;<HOM>*************************************************************************
;;; <関数名>    : C:ChgSink
;;; <処理概要>  : シンク・水栓の変更
;;; <戻り値>    :
;;; <作成>      : 1999-10-12
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:ChgSink (
  /
  #PD #pdsize
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ChgSink ////")
  (CFOutStateLog 1 1 " ")

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

  (CFCmdDefBegin 6);00/09/26 SN ADD
  (setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "PDSIZE" 10)
  (setvar "pdmode" 34)

  ;// シンクの配置(元のシンク、水栓は削除する)
;;;  (SKW_OpPosSink 1) ; 00/04/28 YM
  (SKW_OpPosSink2 1) ; 00/04/28 YM

;;;03/09/29YM@MOD  ;// 表示画層の設定 ; 00/09/18 YM ADD
;;;03/09/29YM@MOD  (command "_layer"
;;;03/09/29YM@MOD    "F"   "*"                ;全ての画層をフリーズ
;;;03/09/29YM@MOD    "T"   "Z_00*"            ;  Z_00立体ソリッド画層のフリーズ解除
;;;03/09/29YM@MOD    "T"   "N_*"              ;  N_*シンボル原点図形画層のフリーズ解除
;;;03/09/29YM@MOD    "T"   "M_*"              ;  M_*目地領域図形画層の解除
;;;03/09/29YM@MOD    "T"   "0"                ;  "0"画層の解除
;;;03/09/29YM@MOD    "ON"  "M_*"              ;  M_*目地領域図形画層の表示
;;;03/09/29YM@MOD    "OFF" "N_B*" ""          ;  N_B*ブレークライン図形の非表示
;;;03/09/29YM@MOD  )
;;;03/09/29YM@MOD  (command "_.layer" "T" "Z_KUTAI" "") ; 01/04/23 YM ADD
  (SetLayer);03/09/29 YM MOD

  (CFCmdDefFinish);00/09/26 SN ADD
  (setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)

  ); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
);_if

  (setq *error* nil)
  (princ)

)
;C:ChgSink

;;;<HOM>*************************************************************************
;;; <関数名>     : PKC_GetSuisenAnaPt
;;; <処理概要>   : ｼﾝｸにある水栓穴の座標ﾘｽﾄを求める
;;; <戻り値>     : 座標ﾘｽﾄ
;;; <作成>       : 2000.1.26 YM 00/05/04 &sym 追加修正
;;; <備考>       : 00/10/05 引数 PTENﾅﾝﾊﾞｰ 追加
;;;*************************************************************************>MOH<
(defun PKC_GetSuisenAnaPt (
  &sym ; ｼﾝｸｼﾝﾎﾞﾙ図形名
  &No  ; PTENﾅﾝﾊﾞｰ
  /
  #EN #I #PT #PT_LIS #SS #XD$ #msg #S-XD$
  )
  (setq #pt_lis '())
  (setq #ss (CFGetSameGroupSS &sym)) ; ｼﾝｸｸﾞﾙｰﾌﾟ図形選択ｾｯﾄ
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i)) ; ｼﾝｸｷｬﾋﾞの同一ｸﾞﾙｰﾌﾟの各要素
    (setq #xd$ (CFGetXData #en "G_PTEN")) ; G_TMEN拡張ﾃﾞｰﾀ
    (if #xd$
      (progn ; PTENがある場合
        (if (= (nth 0 #xd$) &No)  ; PTEN?
          (progn ; 水洗穴の場合
            (setq #pt (cdr (assoc 10 (entget #en))))
            (setq #pt_lis (append #pt_lis (list #pt) ))  ; pointは複数あってもＤ方向の位置は同じ
          );_progn
        );_if
      )
    );_if
    (setq #i (1+ #i))
  );_repeat
  (if (= #pt_lis nil)
    (progn
      (setq #s-xd$ (CFGetXData &sym "G_LSYM")) ; ｼﾝｸｷｬﾋﾞﾈｯﾄ拡張ﾃﾞｰﾀ
      (setq #msg
        (strcat "シンク 品番名称 : " (nth 5 #s-xd$) " に"
        "排水穴(P点)がありません。\n \nPKGetPTEN_NO"))
      (CFOutStateLog 0 5 #msg)
      (CFAlertMsg #msg)
      (*error*)
    )
  )
  #pt_lis
); PKC_GetSuisenAnaPt

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_CheckExistSuisen
;;; <処理概要>  : 水栓が存在すればTを返すなければnil
;;; <戻り値>    : T or nil
;;; <作成>      : 00/07/17 YM
;;; <備考>      : (ssget "CP" を使用している為 vpoint '(0 0 1)が必要
;;;*************************************************************************>MOH<
(defun PK_CheckExistSuisen (
  &pt ; ﾎﾟｲﾝﾄ
  /
  #I #ONE #P1 #P2 #P3 #P4 #PT$ #RET #SS
  )
  (setq #ret nil)
  (setq #p1 (polar &pt (dtr   45) 1))
  (setq #p2 (polar &pt (dtr  135) 1))
  (setq #p3 (polar &pt (dtr -135) 1))
  (setq #p4 (polar &pt (dtr  -45) 1))
  (setq #pt$ (list #p1 #p2 #p3 #p4 #p1))
  (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_LSYM")))))
  (if #ss
    (if (> (sslength #ss) 0)
      (progn
        (setq #i 0)
        (repeat (sslength #ss)
          (if (= CG_SKK_ONE_WTR (CFGetSymSKKCode (ssname #ss #i) 1)) ; 性格ｺｰﾄﾞ１桁目
            (setq #ret T)
          );_if
          (setq #i (1+ #i))
        )
      )
    );_if
  );_if
  #RET
);PK_CheckExistSuisen

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_GetWTunderSuisen
;;; <処理概要>  : 水栓下のWTを返す
;;; <戻り値>    : WT図形名
;;; <作成>      : 00/07/17 YM
;;; <備考>      : (ssget "CP" を使用している為 vpoint '(0 0 1)が必要
;;;*************************************************************************>MOH<
(defun PK_GetWTunderSuisen (
  &pt ; ﾎﾟｲﾝﾄ
  /
  #I #LOOP #PTWT$ #RET #SS #WT #PT
  )
  (setq #pt (list (car &pt) (cadr &pt)))
  (setq #ret nil)
  (setq #ss (ssget "X" (list (list -3 (list "G_WRKT"))))) ; 図面上全ＷＴ
  (if (and #ss (> (sslength #ss) 0))
    (progn
      (setq #i 0 #loop T)
      (while (and #loop (< #i (sslength #ss)))
        (setq #WT (ssname #ss #i))
        (setq #ptWT$ (PKGetWT_outPT #WT 1)) ; WT外形点列 ; 01/08/10 YM ADD(引数追加)
        (if (IsPtInPolygon #pt #ptWT$)    ; 内外判定
          (setq #ret #WT #loop nil)
        );_if
        (setq #i (1+ #i)) ; 01/04/06 YM ADD 無限ﾙｰﾌﾟ解消
      )
    )
  );_if
  #ret
);PK_GetWTunderSuisen

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_GetPTEN5byPT
;;; <処理概要>  : 点近傍のPTENを返す 引数=point座標
;;; <戻り値>    : PTEN図形名(１つだけ返す)
;;; <作成>      : 00/07/18 YM
;;; <備考>      : (ssget "CP" を使用している為 vpoint '(0 0 1)が必要
;;;*************************************************************************>MOH<
(defun PK_GetPTEN5byPT (
  &pt ; ﾎﾟｲﾝﾄ
  /
  #I #P1 #P2 #P3 #P4 #PT$ #PTEN #RET #SS #PT #XD$
  )
  (command "_.vpoint" (list 0 0 1))
  (command "_layer" "T" "Z_01*" "")
  (setq #pt (list (car &pt) (cadr &pt))) ; 2D化
  (setq #ret nil)
  (setq #p1 (polar #pt (dtr   45) 4))
  (setq #p2 (polar #pt (dtr  135) 4))
  (setq #p3 (polar #pt (dtr -135) 4))
  (setq #p4 (polar #pt (dtr  -45) 4))
  (setq #pt$ (list #p1 #p2 #p3 #p4 #p1))
  (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_PTEN")))))
  (if #ss
    (if (> (sslength #ss) 0)
      (progn
        (setq #i 0)
        (repeat (sslength #ss)
          (setq #pten (ssname #ss #i))
          (setq #xd$ (CFGetXData #pten "G_PTEN"))
          (if (= 5 (car #xd$))
            (setq #ret (list #pten #xd$))
          );_if
          (setq #i (1+ #i))
        )
      )
    );_if
  );_if
  (command "_layer" "F" "Z_01*" "")
  #RET
);PK_GetPTEN5byPT

;;;<HOM>*************************************************************************
;;; <関数名>    : GetPlusLinePT
;;; <処理概要>  : &oを中心に＋の線を引くときの始点、終点を返す
;;; <戻り値>    : t点座標ﾘｽﾄ
;;; <作成>      : 2011/07/19 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun GetPlusLinePT (
  &o ; 3Dﾎﾟｲﾝﾄ
  /
  #O1 #O2 #O3 #O4 #X #Y #Z
  )
  (setq #x (nth 0 &o))
  (setq #y (nth 1 &o))
  (setq #z (nth 2 &o))
  (setq #o1 (list (- #x 50) #y #z))
  (setq #o2 (list (+ #x 50) #y #z))
  (setq #o3 (list #x (+ #y 50) #z))
  (setq #o4 (list #x (- #y 50) #z)) 
  (list #o1 #o2 #o3 #o4)
);GetPlusLinePT

;;;<HOM>*************************************************************************
;;; <関数名>    : PcSetWaterTap
;;; <処理概要>  : 水栓設置処理
;;; <戻り値>    : 設置した図形名
;;; <作成>      : 00/06/01 MH
;;;               00/07/17 YM ADD "G_WTR"追加など
;;; <備考>      : 水洗穴位置に標点表示＆スナップ処理
;;;*************************************************************************>MOH<
(defun PcSetWaterTap (
  &selPT$     ; 設備部材の情報
  /
  #DIS #DPT #DUM$ #EN #ENS #ENSNK$ #I #II #KEI #O #OK #OMD #PMD #PSZ
  #PT$ #PTEN5 #PTEN5$ #SNK_ANA #SS #SSWT
  #WORKP$ #XD_PTEN5 #XD_PTEN5$ #ZOKUP #loop #WT
;-- 2011/09/09 A.Satoh Mod - S
;  #ANA #KOSU #SETXD$ #W-XD$ #ANA_layer #ret$
  #KOSU #SETXD$ #W-XD$ #ANA_layer #ret$
;-- 2011/09/09 A.Satoh Mod - E
  #sH         ; 高さ文字列
  #fH         ; 高さ
  #tSEKISAN   ; 積算F=1==>T 01/09/03 YM ADD
#O1 #O2 #O3 #O4 #SNAP #UNIT ;2017/01/19 YM ADD
  )
  (setq #enSNK$ nil #workP$ nil #pten5$ nil #xd_pten5$ nil)
  ;// コマンドの初期化
  (StartUndoErr)

  ; 01/09/03 YM ADD-S 水栓の積算Fを検索する
  (setq #tSEKISAN (KP_GetSekisanF (nth 0 &selPT$)))
  ; 01/09/03 YM ADD-E 水栓の積算Fを検索する

  ;ﾕﾆｯﾄ記号取得 ;06/08/23 YM ADD-S
  (setq #unit (KPGetUnit))
  ;ﾕﾆｯﾄ記号取得 ;06/08/23 YM ADD-E

  ; 現在のOスナップ、点モード、 点サイズ 取得
  (setq #oMD (getvar "OSMODE"))
;;;2011/07/19YM@DEL  (setq #pSZ (getvar "PDSIZE"))
;;;2011/07/19YM@DEL  (setq #pMD (getvar "PDMODE"))

;;;01/06/26YM@  ; 全シンク図形取得
;;;01/06/26YM@  (setq #ss (ssget "X" '((-3 ("G_SINK")))))
;;;01/06/26YM@
;;;01/06/26YM@  (if (or (= #ss nil)(= (sslength #ss) 0))
;;;01/06/26YM@    (progn
;;;01/06/26YM@      (CFAlertMsg "図面上にシンクがありません。")
;;;01/06/26YM@      (quit)
;;;01/06/26YM@    )
;;;01/06/26YM@  );_if

  (setq #ret$ (KPGetPTEN 5)) ; 01/06/27 YM 関数化
  (setq #pten5$    (car  #ret$)) ; PTEN5図形ﾘｽﾄ
  (setq #xd_pten5$ (cadr #ret$)) ; "G_PTEN"ﾘｽﾄ


;;;01/06/26YM@  ;// シンクに設定されている水栓取付け点（Ｐ点=５）の情報を取得する
;;;01/06/26YM@  (setq #i 0)
;;;01/06/26YM@  (repeat (sslength #ss)
;;;01/06/26YM@    (setq #enS (ssname #ss #i))
;;;01/06/26YM@    (setq #dum$ (PKGetPTEN_NO #enS 5)) ; 戻り値(PTEN図形,G_PTEN)のﾘｽﾄのﾘｽﾄ
;;;01/06/26YM@    (setq #pten5$    (append #pten5$    (mapcar 'car  #dum$))) ; PTEN5図形
;;;01/06/26YM@    (setq #xd_pten5$ (append #xd_pten5$ (mapcar 'cadr #dum$))) ; "G_PTEN"
;;;01/06/26YM@    (setq #i (1+ #i))
;;;01/06/26YM@  )

;;; 取得されたP点の座標に可視点を打つ
  (foreach #pten5 #pten5$
    (setq #o (cdr (assoc 10 (entget #Pten5))))

    ;2011/07/19 YM MOD 点の作図ではなく線
    (setq #ret$ (GetPlusLinePT #o)); #oを中心に＋の線を引くときの始点、終点を返す
    (setq #o1 (nth 0 #ret$))
    (setq #o2 (nth 1 #ret$))
    (setq #o3 (nth 2 #ret$))
    (setq #o4 (nth 3 #ret$))

    (entmake
      (list
        (cons   0 "LINE")
        (cons 100 "AcDbEntity")
        (cons 100 "AcDbPoint")
        (cons  10 #o1)
        (cons  11 #o2)
        (cons  62 1)
      )
    )
    (setq #workP$ (append #workP$ (list (entlast)))) ; 可視点図形ﾘｽﾄ(後で削除する為)

    (entmake
      (list
        (cons   0 "LINE")
        (cons 100 "AcDbEntity")
        (cons 100 "AcDbPoint")
        (cons  10 #o3)
        (cons  11 #o4)
        (cons  62 1)
      )
    )
    (setq #workP$ (append #workP$ (list (entlast)))) ; 可視点図形ﾘｽﾄ(後で削除する為)
;;;    (entmake
;;;      (list
;;;        (cons   0 "POINT")
;;;        (cons 100 "AcDbEntity")
;;;        (cons 100 "AcDbPoint")
;;;        (cons  10 #o)
;;;        (cons  62 1)
;;;      )
;;;    )

;;;    (setq #workP$ (append #workP$ (list (entlast)))) ; 可視点図形ﾘｽﾄ(後で削除する為)
  );_foreach

    (setvar "OSMODE" 32)
;;;2011/07/19YM@DEL  (setvar "OSMODE"   8)
;;;2011/07/19YM@DEL  (setvar "PDSIZE" 100)
;;;2011/07/19YM@DEL  (setvar "PDMODE"  35)

;;; 配置点取得(ユーザーに図を出させて角度を付けさせる)
  (setq #OK T #loop T)

  ; 02/07/10 YM ADD-S ｽﾅｯﾌﾟﾓｰﾄﾞOFF
  (setq #snap (getvar "SNAPMODE"))
  (setvar "SNAPMODE" 0)

  (while #OK

    (if (= #unit "T");「家具」だった場合 ;06/08/23 YM
      (setq #dPT (getpoint "\n引手の設置点を指定: \n"))
      (setq #dPT (getpoint "\n水栓の設置点を指定: \n"))
    );_if

    (setq #i 0)
    (while (and #loop (< #i (length #pten5$)))
      (setq #o (cdr (assoc 10 (entget (nth #i #Pten5$)))))
      (setq #dis (distance #o #dPT))
      (if (< #dis 0.1)
        (setq #ii #i #OK nil #loop nil) ; 何番目のPTEN5か？
      );_if
      (setq #i (1+ #i))
    );_foreach

    ; 01/05/24 HN S-MOD 水栓穴以外にも配置可能に変更
    ;@MOD@(if #OK ; PTEN上を選択しなかった
    ;@MOD@  (progn
    ;@MOD@    (setq #loop T) ; 遣り直し
    ;@MOD@    (CFAlertMsg "Ｐ点上に配置して下さい。")
    ;@MOD@  )
    ;@MOD@);_if
    (if #OK ; PTEN上を選択しなかった
      (progn

        (if (= #unit "T");「家具」だった場合 ;06/08/23 YM
          (CFAlertMsg "引手配置穴がない位置に設置します.")
          (CFAlertMsg "水栓穴がない位置に設置します.")
        );_if

        ; ワークトップ高さを配置位置のＺ値とする
        ; 01/06/12 HN S-MOD 高さ取得処理を変更
        ;@MOD@(setq #rec$
        ;@MOD@  (CFGetDBSQLRecChk CG_DBSESSION "SK特性値"
        ;@MOD@    (list
        ;@MOD@      (list "特性ID" "PLAN31"    'STR)
        ;@MOD@      (list "特性値" CG_WTHeight 'STR)
        ;@MOD@    )
        ;@MOD@  )
        ;@MOD@)
        ;@MOD@(setq #fH (getreal (strcat "高さ<" (nth 4 #rec$) ">: ")))
        ;@MOD@(if (= nil #fH)
        ;@MOD@  (setq #fH (atof (nth 4 #rec$)))
        ;@MOD@)
        (setq #sH (KCFGetWTHeight))
        (if (= #sH nil)(setq #sH "0")) ; 01/06/26 YM ADD 図面に何もないとき#sH=nilで落ちる
        (setq #fH (getreal (strcat "高さ<" #sH ">: ")))
        (if (= nil #fH)
          (setq #fH (atof #sH))
        )
        ; 01/06/12 HN E-MOD 高さ取得処理を変更

        (setq #dPT (list (car #dPT) (cadr #dPT) #fH))
        (setq #OK nil)
      )
    );_if
    ; 01/05/24 HN E-MOD 水栓穴以外にも配置可能に変更

    (if (= #OK nil) ; Ｐ点上を選択した場合
      (if (setq #OK (PK_CheckExistSuisen #dPT)) ; 水栓が存在すればTを返す
        (progn
          (setq #loop T) ; 遣り直し

          (if (= #unit "T");「家具」だった場合 ;06/08/23 YM
            (CFAlertMsg "既に引手が存在します。")
            (CFAlertMsg "既に水栓が存在します。")
          );_if

        )
      );_if
    );_if
  )

  ; 02/07/10 YM ADD-S ｽﾅｯﾌﾟﾓｰﾄﾞOFF
  (setvar "SNAPMODE" #snap)

  ;;; リストの点削除
  (foreach #P #workP$ (entdel #P))

  (if #ii     ; 01/05/24 HN MOD 水栓穴以外にも配置可能に変更
    (progn
      ; 穴作成 & "G_WTR"のｾｯﾄ
      (setq #xd_pten5 (nth #ii #xd_pten5$)) ; "G_PTEN"
      (setq #kei      (nth   1 #xd_pten5 )) ; 穴径
      (setq #zokuP    (nth   2 #xd_pten5 )) ; 属性
      (setq #pten5    (nth #ii #pten5$   )) ; PTEN5
      (setq #o (cdr (assoc 10 (entget #pten5))))

      ; 水栓ありで「水栓」なしの場合 01/01/15 YM ADD
      ;;;  (setq #ANA_layer "Z_00_00_00_01" ) ; 目に見える
      (setq #ANA_layer SKW_AUTO_SECTION) ; 目に見えない

;-- 2011/09/09 A.Satoh Del - S
;;;;01/09/03YM@MOD      (setq #ana (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"の円を作成する
;
;
;     ; 01/09/03 YM MOD-S
;;;;      (if #tSEKISAN ;06/08/23 YM MOD
;     (if (or #tSEKISAN (= #unit "T"));積算F=1または「家具」だった場合
;       nil ; 積算F=1なら水栓穴を作図しない
;       (setq #ana (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"の円を作成する
;     );_if
;     ; 0/09/03 YM MOD-E
;
;-- 2011/09/09 A.Satoh Del - E
    )
  ) ;_if 01/05/24 HN MOD 水栓穴以外にも配置可能に変更

  ; 水栓設置実行
  (setq #en (PcInsSuisen&SetX #dPT &selPT$ #tSEKISAN)) ; 設置した水栓図形名 01/09/03 YM MOD 引数#ana削除,積算F#tSEKISAN追加
;;;01/09/03YM@MOD  (setq #en (PcInsSuisen&SetX #dPT #ana &selPT$)) ; 設置した水栓図形名

  (if #ii     ; 01/05/24 HN MOD 水栓穴以外にも配置可能に変更
    (progn
      ;;; PTEN5 の親図形(=ｼﾝｸ図形)を取得
      ;;; (setq #SNK (SearchGroupSym #pten5))

      (command "vpoint" "0,0,1")            ; 必要処理 01/03/13 YM
      (setq #WT (PK_GetWTunderSuisen #dPT)) ; 水栓下のＷＴを返す
      (command "zoom" "p")                  ; 必要処理 01/03/13 YM

      ; 01/03/13 MH DEL 確定後WT設置可
      ;(if (CFGetXData #WT "G_WTSET")
      ;  (progn
      ;    (CFAlertMsg "ワークトップが品番確定されています。\n水栓を配置できません。")
      ;    (quit)
      ;  )
      ;);_if

;;;01/09/03YM@MOD     (if #WT ; 01/06/26 YM ADD WTがないとき落ちる
      (if (and #WT (= #tSEKISAN nil)) ; 01/09/03 YM MOD
        (progn ; WTが存在して水栓が積算F=1でないとき
;-- 2011/09/09 A.Satoh Del - S
;
;         ;// 水栓穴拡張データを設定
;         ;;;  (CFSetXData #ana "G_WTR" (list #zokuP #WT #SNK)) ; 07/17 YM WT図形名,ｼﾝｸ図形名をADD
;         (regapp "G_WTR") ; 00/08/09 MH ADD
;         (CFSetXData #ana "G_WTR" (list #zokuP))
;         ;;; #ana を"G_WRKT"に追加する
;-- 2011/09/09 A.Satoh Del - E
         (setq #w-xd$ (CFGetXData #WT "G_WRKT"))
;-- 2011/09/09 A.Satoh Del - S
;         (setq #i 23 #dum$ nil)
;         (repeat (nth 22 #w-xd$)
;           (if (/= (nth #i #w-xd$) "")
;             (if (entget (nth #i #w-xd$)); 無効な図形名でない
;               (setq #dum$ (append #dum$ (list (nth #i #w-xd$))))
;             ) ;_if
;           ) ;_if
;           (setq #i (1+ #i))
;         ) ;_repeat
;
;         (setq #kosu (1+ (length #dum$)))        ; 1つ増やす
;         (setq #dum$ (append #dum$ (list #ana))) ; 配置した水栓を追加
;
;         (if (> 7 (length #dum$))                ; 水栓穴は７個まで
;           (repeat (- 7 (length #dum$)) (setq #dum$ (append #dum$ (list ""))))
;         ) ;_if
;-- 2011/09/09 A.Satoh Del - E

          (setq #setxd$
            (list
;-- 2011/09/09 A.Satoh Mod - S
;             (list 22 #kosu)
;             (list 23 (nth 0 #dum$))
;             (list 24 (nth 1 #dum$))
;             (list 25 (nth 2 #dum$))
;             (list 26 (nth 3 #dum$))
;             (list 27 (nth 4 #dum$))
;             (list 28 (nth 5 #dum$))
;             (list 29 (nth 6 #dum$))
              (list 22 0)
              (list 23 "")
              (list 24 "")
              (list 25 "")
              (list 26 "")
              (list 27 "")
              (list 28 "")
              (list 29 "")
;-- 2011/09/09 A.Satoh Mod - E
            )
          )
          ;// ワークトップ拡張データの更新
          (CFSetXData #WT "G_WRKT"
            (CFModList #w-xd$ #setxd$)
          )
          ; 品番確定されていたら水栓穴開け処理 01/03/14 YM ADD
          (if (CFGetXData #WT "G_WTSET")
            (PKW_MakeHoleWorkTop2 #WT nil nil)
          ) ;_if

        ) ; 01/06/26 YM ADD WTがないとき落ちる
;-- 2011/09/09 A.Satoh Del - S
;
;       ; 02/07/10 YM ADD-S
;       (progn
;         (if (and #ana (entget #ana))
;           (entdel #ana)
;         );_if
;       )
;       ; 02/07/10 YM ADD-E
;
;-- 2011/09/09 A.Satoh Del - E
      );_if

    )
  ) ;_if  01/05/24 HN MOD 水栓穴以外にも配置可能に変更

  ; Oスナップ、点モード、 点サイズ を元に戻す
  (setvar "OSMODE" #oMD)
;;;2011/07/19YM@DEL  (setvar "PDSIZE" #pSZ)
;;;2011/07/19YM@DEL  (setvar "PDMODE" #pMD)
  (setq *error* nil)

  (if (= #unit "T");「家具」だった場合 ;06/08/23 YM
    (princ "\n引手を配置しました。")
    (princ "\n水栓を配置しました。")
  );_if

  #en
) ;_PcSetWaterTap

;;;<HOM>*************************************************************************
;;; <関数名>    : KPGetPTEN
;;; <処理概要>  : 図面上に存在する、引数の番号のPTENを取得
;;; <戻り値>    : (PTEN図形ﾘｽﾄ,PTEN Xdataﾘｽﾄ)
;;; <作成>      : 2011/07/19 YM ADD
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KPGetPTEN (
  &pten_no ;INT
  /
  #DUM$ #I #PTEN #PTEN$ #SSPTEN #XD_PTEN$
  )
  ; 01/06/26 YM ｼﾝｸが存在しなくても水栓配置可能にする
  (setq #ssPTEN (ssget "X" '((-3 ("G_PTEN")))))
  
  (if (and #ssPTEN (< 0 (sslength #ssPTEN)))
    (progn ; 図面上にPTENがあれば
      (setq #i 0)
      (repeat (sslength #ssPTEN)
        (setq #PTEN (ssname #ssPTEN #i))
        (setq #dum$ (CFGetXData #PTEN "G_PTEN"))
        (if (= (car #dum$) &pten_no)
          (progn
            (setq #pten$    (append #pten$    (list #PTEN))) ; PTEN図形
            (setq #xd_pten$ (append #xd_pten$ (list #dum$))) ; "G_PTEN"
          )
        );_if
        (setq #i (1+ #i))
      );repeat
    )
  );_if
  (list #pten$ #xd_pten$)
);KPGetPTEN

;;;<HOM>************************************************************************
;;; <関数名>  : PcInsSuisen&SetX
;;; <処理概要>: 図形を挿入、拡張データ設置（当ファイル共通）
;;; <戻り値>  : #en
;;; <作成>    : 00/03/27 MH
;;; <備考>    : 角度がnil値で渡ってきたら、ここでユーザーに入力させる。
;;;************************************************************************>MOH<
(defun PcInsSuisen&SetX (
  &bPT
;;;01/09/03YM@MOD  &ana    ; "G_WTR" 水栓穴(水栓のｸﾞﾙｰﾌﾟに入れる)
  &selPT$
  &tSEKISAN ; 積算F=1===>T それ以外nil 01/09/03 YM ADD 引数追加
  /
  #EN #FANG #OS #S #SFNAME #SS
  )
  (setq #s  (getvar "SNAPMODE"))
  (setvar "SNAPMODE" 0)
  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)

  ;;; 挿入図形選択
  (setq #sFNAME (strcat (cadr &selPT$) ".dwg"))
  (Pc_CheckInsertDwg #sFNAME CG_MSTDWGPATH)
  (command "_insert" (strcat CG_MSTDWGPATH #sFNAME) &bPT 1 1)
  (princ "\n配置角度: ")
  (command pause)
  (setq #fANG (cdr (assoc 50 (entget (entlast)))))

  ;;; 分解
  (command "_explode" (entlast))
  (setq #ss (ssget "P"))
;;;  (ssadd &ana #ss) ; "G_WTR" 水栓穴(水栓のｸﾞﾙｰﾌﾟに入れる)
  (SKMkGroup #ss)  ;分解した図形群で名前のないグループ作成
  (setq #en (SearchGroupSym (ssname #ss 0)))
  (SKY_SetXData_ &selPT$ #en &bPT #fANG &tSEKISAN) ; 01/09/03 YM ADD
  (PcChgH_GSYM #en &bPT)
  (command "_layer" "on" "M_*" "")
  (setvar "SNAPMODE" #s)
  (setvar "OSMODE" #os)
  #en
);PcInsSuisen&SetX


;;;<HOM>*************************************************************************
;;; <関数名>    : SKW_GetSinkInfoN
;;; <処理概要>  : シンク情報、水栓穴情報、水栓種類情報を取得する ｼﾝｸの選択ﾀﾞｲｱﾛｸﾞ
;;; <戻り値>    :
;;;      (LIST) : 1.WTシンクレコード
;;;               2.WT水栓穴レコード
;;;               3.SK特性値レコード(水栓)
;;; <作成>      : 00/05/02 YM 修正 00/12/02 YM SINK管理,SINK位置を検索
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun SKW_GetSinkInfoN (
  &XD_WRKT ; "G_WRKT"拡張ﾃﾞｰﾀ
  &CAB     ; ｷｬﾋﾞﾈｯﾄ図形名
  &ZaiCode ; 材質
  &ZaiF    ; 素材F
	&w-en    ;-- 2012/04/20 A.Satoh Add シンク配置不具合対応
  /
;-- 2011/09/15 A.Satoh Mod - S
;  #ERRFLG #FLG #I #MSG #NAME$ #NAME$$ #RET$ #SCAB_HIN #SINK$ #SINK$$
;  #SINK_KAN$$ #SNK_K #SNK_KG #SNK_LR #SNK_SYM #SQL #TYPE1CODE #XD_SNK$ #ZAICODE
;  #QRY$ #dum$
  #Errflg #msg #SNK_sym #xd_SNK$ #SCAB_HIN #SNK_LR
  #sink$ #OKU #idx #sink #name$$ #name$ #ret$
  #sink_KAN1$$ #sink_KAN1$ #sink_KAN1 #sink1$
  #sink_KAN2$$ #sink_KAN2$ #sink_KAN2 #sink2$
  #sink_KAN3$$ #sink_KAN3$ #sink_KAN3 #sink3$
  #qry$$ #qry$
;-- 2011/09/15 A.Satoh Mod - E
#SNK_DEP #SQL ;2017/01/19 YM ADD
  )

;-- 2011/09/15 A.Satoh Mod - S
;  (setq #Errflg nil #sink_KAN$$ nil #sink$$ nil #name$$ nil)
  (setq #Errflg nil
        #sink_KAN1$$ nil
        #sink_KAN2$$ nil
        #sink_KAN3$$ nil
        #name$$      nil
        #sink$       nil
        #sink1$      nil
        #sink2$      nil
        #sink3$      nil
  )
;-- 2011/09/15 A.Satoh Mod - E

  (setq #SNK_sym (SearchGroupSym &CAB)) ; ｼﾝｸｷｬﾋﾞﾈｯﾄ親図形名
  (setq #xd_SNK$ (CFGetXData #SNK_sym "G_LSYM"))
  (setq #SCAB_HIN (nth 5 #xd_SNK$)) ; 品番名称
  (setq #SNK_LR   (nth 6 #xd_SNK$)) ; LR区分(ｼﾝｸｷｬﾋﾞﾈｯﾄ)

;2011/09/14 YM
;----------------------------------------------------------------------------------------------------
;;; ｼﾝｸｷｬﾋﾞ品番から【SINKCAB管理】検索
  (setq #sink_KAN1$$
    (CFGetDBSQLRec CG_DBSESSION "SINKCAB管理"
			;2012/05/28 YM MOD-S
;;;      (list (list "品番名称" (KP_DelHinbanKakko #SCAB_HIN) 'STR)) ; 品番の()を外す
      (list (list "品番名称" #SCAB_HIN 'STR)) ; 品番の()を外す
			;2012/05/28 YM MOD-E
    )
  )
  ;;; ｴﾗｰ処理
  (if (and #sink_KAN1$$ (= 1 (length #sink_KAN1$$)))
    (progn
      (setq #sink_KAN1$ (car #sink_KAN1$$))
      (setq #sink_KAN1 (nth 2 #sink_KAN1$))
      (setq #sink1$ (strparse #sink_KAN1 ","))
    )
    (progn
      (setq #msg (strcat "『SINKCAB管理』にﾚｺｰﾄﾞがありません。\nｼﾝｸｷｬﾋﾞﾈｯﾄ品番名称=" #SCAB_HIN ))
      (CFAlertMsg #msg)
      (setq #Errflg T)
    )
  );_if
;----------------------------------------------------------------------------------------------------
;;; 材質から【SINK材質管理】検索
;;;  (setq #sink_KAN2$$
;-- 2011/09/15 A.Satoh Add - S
  (if (= #Errflg nil)
    (progn
      (setq #sink_KAN2$$
        (CFGetDBSQLRec CG_DBSESSION "SINK材質管理"
          (list (list "材質記号" &ZaiCode 'STR))
        )
      )

      (if (and #sink_KAN2$$ (= 1 (length #sink_KAN2$$)))
        (progn
          (setq #sink_KAN2$ (car #sink_KAN2$$))
          (setq #sink_KAN2 (nth 3 #sink_KAN2$))
          (setq #sink2$ (strparse #sink_KAN2 ","))
        )
        (progn
          ; ｴﾗｰ処理
          (setq #msg (strcat "『SINK材質管理』にﾚｺｰﾄﾞがありません。\n材質記号=" &ZaiCode))
          (CFAlertMsg #msg)
          (setq #Errflg T)
        )
      )
    )
  )
;-- 2011/09/15 A.Satoh Add - E
;----------------------------------------------------------------------------------------------------
;;; 奥行から【SINK奥行管理】検索
;;;  (setq #sink_KAN3$$
;-- 2011/09/15 A.Satoh Add - S
  (if (= #Errflg nil)
    (progn
      ; 奥行きを求める
;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 - S
;;;;;      (setq #qry$$
;;;;;        (CFGetDBSQLRec CG_DBSESSION "奥行"
;;;;;          (list
;;;;;            (list "奥行" (itoa (fix (+ (car (nth 57 &XD_WRKT)) 0.01))) 'INT)
;;;;;          )
;;;;;        )
;;;;;      )
			(setq #snk_dep (nth 39 &XD_WRKT))
			(if (or (= #snk_dep 0.0) (= #snk_dep nil))
				(progn
					(setq #snk_dep (getSinkDep &w-en))
					(if (or (= #snk_dep 0.0) (= #snk_dep nil))
						(setq #snk_dep 0.0)
					)
				)
			)
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "奥行"
          (list
            (list "奥行" (itoa (fix (+ #snk_dep 0.01))) 'INT)
          )
        )
      )
;;(princ "\n#snk_dep = ")(princ #snk_dep)
;;(princ "\n#qry$$ = ")(princ #qry$$)(princ)
;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 - E
      (if (and #qry$$ (= 1 (length #qry$$)))
        (progn
          (setq #qry$ (nth 0 #qry$$))
          (setq #OKU (nth 1 #qry$))
        )
        (setq #OKU "?")
      )

      (setq #sink_KAN3$$
        (CFGetDBSQLRec CG_DBSESSION "SINK奥行管理"
          (list (list "奥行" #OKU 'STR))
        )
      )

      (if (and #sink_KAN3$$ (= 1 (length #sink_KAN3$$)))
        (progn
          (setq #sink_KAN3$ (car #sink_KAN3$$))
          (setq #sink_KAN3 (nth 2 #sink_KAN3$))
          (setq #sink3$ (strparse #sink_KAN3 ","))
        )
        (progn
          ; ｴﾗｰ処理
          (setq #msg (strcat "『SINK奥行管理』にﾚｺｰﾄﾞがありません。\n奥行=" #OKU))
          (CFAlertMsg #msg)
          (setq #Errflg T)
        )
      )
    )
  )
;-- 2011/09/15 A.Satoh Add - E
;----------------------------------------------------------------------------------------------------

;-- 2011/09/15 A.Satoh Mod - S
;(setq #sink$ #sink1$);暫定ｼﾝｸ記号ﾘｽﾄ
  ; 【SINKCAB管理】【SINK材質管理】【SINK奥行管理】から抽出したシンクリストにより
  ; 全てのテーブルに存在するシンクのリストを作成する
  (if (= #Errflg nil)
    (progn
      (setq #idx 0)
      (repeat (length #sink1$)
        (setq #sink (nth #idx #sink1$))
        (if (and (member #sink #sink2$) (member #sink #sink3$))
          (setq #sink$ (append #sink$ (list #sink)))
        )
        (setq #idx (1+ #idx))
      )
    )
  )
;-- 2011/09/15 A.Satoh Mod - E

;2011/09/14 YM
;★ｼﾝｸ脇候補ﾘｽﾄが要らないので【SINK位置】ﾃｰﾌﾞﾙは不要
;★ｼﾝｸｷｬﾋﾞの中心にｼﾝｸを配置するので、逆にｼﾝｸ脇を求めて表示し、ﾕｰｻﾞｰが手修正できるようにする

;;; 2011/09/14YM@DEL  (if (= #Errflg nil)
;;; 2011/09/14YM@DEL    (progn
;;; 2011/09/14YM@DEL      (setq #i 2 #flg T)
;;; 2011/09/14YM@DEL      (while (and #flg (< #i 15));04/06/16 YM MDO
;;; 2011/09/14YM@DEL        (setq #snk_K (nth #i (car #sink_KAN$$))) ; ｼﾝｸ記号
;;; 2011/09/14YM@DEL        (if (= #snk_K nil)
;;; 2011/09/14YM@DEL          (setq #flg nil)
;;; 2011/09/14YM@DEL          (progn
;;; 2011/09/14YM@DEL            ;;; SINK位置検索
;;; 2011/09/14YM@DEL            (setq #sink$
;;; 2011/09/14YM@DEL              (CFGetDBSQLRec CG_DBSESSION "SINK位置"
;;; 2011/09/14YM@DEL                (list
;;; 2011/09/14YM@DEL                  (list "シンク記号" #snk_K 'STR)
;;; 2011/09/14YM@DEL                )
;;; 2011/09/14YM@DEL              )
;;; 2011/09/14YM@DEL            )
;;; 2011/09/14YM@DEL            (setq #sink$ (DBCheck #sink$ "『SINK位置』" (strcat "\nｼﾝｸ記号=" #snk_K))) ; nil or 複数時 ｴﾗｰ
;;; 2011/09/14YM@DEL            (setq #sink$$ (append #sink$$ (list #sink$)))
;;; 2011/09/14YM@DEL          )
;;; 2011/09/14YM@DEL        );_if
;;; 2011/09/14YM@DEL        (setq #i (1+ #i))
;;; 2011/09/14YM@DEL      );_while
;;; 2011/09/14YM@DEL    )
;;; 2011/09/14YM@DEL    (progn ; "SINK管理" 検索ｴﾗｰ
;;; 2011/09/14YM@DEL      ;;; SINK位置検索(全ﾚｺｰﾄﾞ取得)
;;; 2011/09/14YM@DEL      (setq #sql "select * from SINK位置")
;;; 2011/09/14YM@DEL      (setq #sink$$ (DBSqlAutoQuery CG_DBSession #sql))
;;; 2011/09/14YM@DEL    )
;;; 2011/09/14YM@DEL  );_if

;2011/09/14 YM
;★#sink_KAN1$$～#sink_KAN3$$　で絞り込んだ,ｼﾝｸ記号のﾘｽﾄ = #sink$ でﾙｰﾌﾟして【WTシンク】を検索する
  (if #sink$
    (progn
      (foreach #sink #sink$
        (setq #name$
          (CFGetDBSQLRec CG_DBSESSION "WTシンク"
            (list
              (list "シンク記号" #sink 'STR)
            )
          )
        )
        (setq #name$ (DBCheck #name$ "『WTシンク』" (strcat "シンク記号=" #sink))) ; nil or 複数時 ｴﾗｰ
        (setq #name$$ (append #name$$ (list #name$))) ; WTシンクレコード複数 ﾘｽﾄ表示用
      )
    )
    (progn
;2016/02/18 YM ADD ｴﾗｰ回避全部表示
      (setq #msg (strcat "SINK候補がありません。" "全SINKを表示します。" ))

;2016/02/18 YM ADD ｴﾗｰ回避全部表示
      (CFAlertMsg #msg)
;;;      (quit)
			(setq #sql (strcat "select * from WTシンク"))
		  (setq #name$$ (DBSqlAutoQuery CG_DBSESSION #sql))
    )
  );_if

;;; ｼﾝｸの選択ﾀﾞｲｱﾛｸﾞ
;-- 2011/09/14 A.Satoh Mod - S
;;;;; ;2011/09/14 YM MOD-S
;;;;;;;;  (setq #ret$ (KPSelectSinkDlg &XD_WRKT &ZaiF #SNK_LR #sink$$ #name$$))
;;;;;  (setq #ret$ (KPSelectSinkDlg &XD_WRKT &ZaiF #SNK_LR #sink$ #name$$));★#sink$$の代わりに#sink$(ｼﾝｸ記号のみ)
;;;;; ;2011/09/14 YM MOD-E

;;;	(CFAlertMsg "★（２）★ ＜PG改修＞ KPSelectSinkDlg【シンク選択画面】ERRMSG.INIを見に行く") ;2017/01/19 YM ADD

  (setq #ret$ (KPSelectSinkDlg &XD_WRKT &ZaiF #SNK_LR #sink$ #name$$ &CAB))
;-- 2011/09/14 A.Satoh Mod - E

;;;  戻り値 #ret$ (list #sink$ #name$ #SNK_DIM #LR #sui$ #plis$)
;;; 0:選択された"SINK位置" ﾚｺｰﾄﾞ
;;; 1:選択された"WTシンク" ﾚｺｰﾄﾞ
;;; 2:選択されたｼﾝｸ脇寸法
;;; 3:選択されたｼﾝｸﾀｲﾌﾟLRZ
;;; 4:選択された"WT水栓穴" ﾚｺｰﾄﾞ
;;; 5:選択された"WT水栓管" ﾚｺｰﾄﾞ (属性 -2,-1,0,1,2 の順) nil あり
  #ret$
);SKW_GetSinkInfoN

;;;<HOM>*************************************************************************
;;; <関数名>     : PKC_LayoutSink
;;; <処理概要>   : プラン検索【シンク自動配置】
;;; <戻り値>     : 
;;; <作成>       : 2000.1.27 @YM@
;;; <備考>       :  複数WTの心配 ﾌﾟﾗﾝ検索なので OK!
;;;*************************************************************************>MOH<
(defun PKC_LayoutSink (
  /
  #ANAQRY$ #ANG #AREA$ #D-OFF #D-VCT #DIMW2 #DWG #EN #EN$ 
  #FIG$ #FIG1$ #FIGID #GRP #H #H-NO #HINBAN #I #LISTCODE #LOOP #LR #LR_EXIST 
  #M1-WID #MOVE #P-EN1 #P-EN2 #P-SS #POS #PT #PT$ #PT_LIS #PT_SUISEN #QRY$ #RET 
  #SEIKAKU #SNK-EN #SS #SS_DUM #SS_SNK #SYM #W-OFF #WK-THK #WTRHOLECODE #XD$ #Y_SUISEN #ZAIF
  #SPLAN #YNO #HH #LIST$$ #MSG #QRY_CHG$ #QRY_CHG$$ #QRY_OFF$ #QRY_OFF$$ #sink_hinban
  )
  (setq CG_SINK nil)

  (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; ﾌﾟﾗﾝ検索なので OK!
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i))
    (setq #xd$ (CFGetXData #en "G_LSYM"))
    (if (= CG_SKK_THR_SNK (CFGetSeikakuToSKKCode (nth 9 #xd$) 3)) ; 性格CODEの3桁目=2 ｼﾝｸｷｬﾋﾞﾈｯﾄ
      (setq #snk-en #en) ; ｼﾝｸｷｬﾋﾞﾈｯﾄ図形名
    )
    (setq #i (1+ #i))
  )
  (setq #xd$ (CFGetXData #snk-en "G_LSYM")) ; ｼﾝｸｷｬﾋﾞﾈｯﾄ拡張ﾃﾞｰﾀ

  (setq #HH (nth 5 (CFGetXData #snk-en "G_SYM"))) ; G_SYM寸法H
  (setq #ang (nth 2 #xd$))  ; 回転角度
  (setq #HINBAN (nth 5 #xd$))


;;; (setq #LIST$$
;;;    (list
;;;      (list "BG有無" "1" 'INT) ; BGあり
;;;      (list "BG分離" "0" 'INT) ; BG一体型
;;;    )
;;; )
;;;  (setq #qry$
;;;   (CFGetDBSQLRec CG_DBSESSION "WT断面" #LIST$$)
;;; )
;;;  (setq #wk-thk (nth 2 (car #qry$)))


  ;2010/10/26 YM MOD-E 天板作図していないのに天板の厚みが知りたい
  ;関数化 2010/10/27 YM ADD
  (setq #qry$ (GetWtDanmen))

  (if (= nil #qry$)
    (progn
      (CFAlertMsg "\n[WT断面決定]が拾えない")
      (quit)
    )
  );_if

  (setq #wk-thk (nth  2 #qry$)) ; WTの厚み
;;;  (setq #wk-thk 19)


  ;2011/04/11 YM ADD-S 新ｽｲｰｼﾞｨ対応 場合わけ
  (cond
    ((= BU_CODE_0010 "1") 
      ;SKBの場合
      (cond
        ((= "Q" (substr #HINBAN 9 1))
          (setq #m1-wid 700)  ; 奥行量
        )
        ((= "J" (substr #HINBAN 9 1))
          (setq #m1-wid 650)  ; 奥行量
        )
        ((= "C" (substr #HINBAN 9 1))
          (setq #m1-wid 600)  ; 奥行量
        )
        (T ;想定外
          (setq #m1-wid 650)  ; 奥行量
        )
      );_cond
    )
    ;従来ﾛｼﾞｯｸ
    (T
      (setq #m1-wid 650)  ; 奥行量
    )
  );_cond
  ;2011/04/11 YM ADD-E




  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "WTシンク"
      (list
        (list "シンク記号"  (nth 17 CG_GLOBAL$) 'STR)
      )
    )
  );_(setq #qry$

  (setq #qry$ (DBCheck #qry$ "『WTシンク』" "PKC_LayoutSink"))

  ;//   Ｗ方向：『プラ管理』  .シンク位置オフセット量
  ;//   Ｄ方向：『ＷＴシンク』.シンクオフセット方向
  ;//           『ＷＴシンク』.シンクオフセット量
  (setq #w-off CG_WSnkOf)           ; CG_WSnkOf [プラ管理]から取得
  (setq #d-vct 1) ; WTシンク.オフセ方向 ==>1固定 ;2008/06/23 YM OK

  (setq #ZaiF (KCGetZaiF (nth 16 CG_GLOBAL$)))
  ; 用途番号決定
  (if (= #ZaiF 1) ; ｽﾃﾝﾚｽか
    (setq #YNO 0)
    (setq #YNO 1)
  )

  ; 人大,ｽﾃﾝﾚｽでｵﾌｾ量が変わる
  (if (= #ZaiF 1) ; WT前面から排水穴PTEN4 までの距離
    (setq #d-off (nth 5 #qry$)) ;(INT)『WTｼﾝｸ』.ｼﾝｸｵﾌｾｯﾄ量(ｽﾃﾝﾚｽ) ;2008/06/23 YM OK
    (setq #d-off (nth 6 #qry$)) ;(INT)『WTｼﾝｸ』.ｼﾝｸｵﾌｾｯﾄ量(人大)  ;2008/06/23 YM OK
  );_if

  ;2008/08/22 YM ADD-S 特定の奥行きでｵﾌｾ量が変わるため補正する
  ;[WTシンクオフセ量補正]
  (setq #qry_off$$
    (CFGetDBSQLRec CG_DBSESSION "WTシンクオフセ量補正"
      (list
        (list "形状"       (nth  5 CG_GLOBAL$) 'STR)
        (list "奥行き"     (nth  7 CG_GLOBAL$) 'STR)
        (list "シンク記号" (nth 17 CG_GLOBAL$) 'STR)
      )
    )
  )
  (if #qry_off$$
    (progn
      (setq #qry_off$ (car #qry_off$$))
      (if (= #ZaiF 1) ; WT前面から排水穴PTEN4 までの距離を補正する値
        (setq #d-off (+ #d-off (nth 3 #qry_off$))) ;ｼﾝｸｵﾌｾｯﾄ量補正(ｽﾃﾝﾚｽ) ;2008/08/22 YM
        ;else
        (setq #d-off (+ #d-off (nth 4 #qry_off$))) ;ｼﾝｸｵﾌｾｯﾄ量補正(人大)  ;2008/08/22 YM
      );_if

    )
  );_if
  ;2008/08/22 YM ADD-S 特定の奥行きでｵﾌｾ量が変わるため補正する


  (setq #LR_EXIST (nth 4 #qry$))    ; WTシンク.LR有無    ;2008/06/23 YM OK
  (setq #h-no     (nth 3 #qry$))    ; WTシンク.品番名称  ;2008/06/23 YM OK

  ;// 工種記号・SERIES記号およびシンクの品番名称より品番図形情報『品番図形』を検索し、
  ;// シンクの図形ID『品番図形』.図形IDを取得する

  (setq #listCode nil)
  (if (equal #LR_EXIST 0.0 0.1) ; LR有無なし
    (setq #LR "Z")
    (setq #LR "L");プラン検索はデフォルト左勝手なので"L"きめうち
  );_if

  (setq #YNO (itoa #YNO)) ; 用途番号

  (setq #LIST$$
    (list
      (list "品番名称"   (nth 3 #qry$)  'STR);2008/06/23 YM OK
      (list "LR区分"     #LR    'STR)
      (list "用途番号"   #YNO   'INT)
    )
  )

  (setq #fig$
    (CFGetDBSQLHinbanTable "品番図形" (nth 3 #qry$) #LIST$$);2008/06/23 YM OK
  )
  (setq #fig$ (DBCheck #fig$ "『品番図形』" "PKC_LayoutSink"))

  ; #fig$ 決定
  (setq #dimW2 (* 0.5 (nth 3 #fig$)));W値     ;2008/06/23 YM OK
  (setq #figID (nth 6 #fig$))        ;図形ID  ;2008/06/23 YM OK

  (setq #sink_hinban (nth 0  #fig$));2008/08/26 ｼﾝｸ品番

  (if (= #figID nil);ｼﾝｸ図形ID
    (progn
      (setq #msg (strcat "\n『品番図形』に図形IDが未登録です。\n" (nth 0 #fig$)))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_if

  ;対面のときに施工図の関係で、配置するｼﾝｸ図形IDを変更する必要あり
  ;2008/08/26 YM ADD-S
  ;[OP置換シンク]
  (setq #qry_chg$$
    (CFGetDBSQLRec CG_DBSESSION "OP置換シンク"
      (list
        (list "形状"         (nth  5 CG_GLOBAL$) 'STR)
        (list "奥行き"       (nth  7 CG_GLOBAL$) 'STR)
        (list "シンク記号"   (nth 17 CG_GLOBAL$) 'STR)
;;;        (list "左右勝手"     (nth 11 CG_GLOBAL$) 'STR);反転処理するからKEYにできない
        (list "置換前図形ID" #figID              'STR);このKEYが有効
      )
    )
  )
  (if (and #qry_chg$$ (= 1 (length #qry_chg$$)))
    (progn
      (setq #qry_chg$ (car #qry_chg$$))
      (setq #figID (nth 4 #qry_chg$))   ;置換後図形ID
      (setq #sink_hinban (nth 5 #qry_chg$));2008/08/26 ｼﾝｸ品番 反転処理のために必要
    )
  );_if
  ;2008/08/26 YM ADD-E



;;; ベースキャビネットの最右の座標を求める
;;;→WOODONEはﾃﾞﾌｫﾙﾄが左勝手なのでWT左端からｼﾝｸを配置する;08/06/23 YM MOD
  (setq #pt
    (list
      (+ CG_WSnkOf (/ (nth 3 #fig$) 2));X座標=ｼﾝｸ脇+ｼﾝｸの幅の1/2 ;2008/06/23 YM OK
      (* -1 #m1-wid)
    )
  )

  ;// シンク図形を呼出し、シンク図形配置基準点に配置する
  (setq #pt (polar #pt (+ (dtr  90) #ang) #d-off)) ; #ang : G_LSYMの３番目.回転角度(rad) 通常こちら

  (setq #pt (list (car #pt) (cadr #pt) #HH)) ; #HHは"G_SYM"寸法Hから
  (if (= nil (findfile (strcat CG_MSTDWGPATH #figID ".dwg"))) ; 品番図形、図形ＩＤ OK!
    (progn
      (setq #msg (strcat "ｼﾝｸ部材図形:" #figID "がありません"))
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  )

  (command "_insert" (strcat CG_MSTDWGPATH #figID) #pt 1 1 (rtd #ang)) ; 品番図形、図形ＩＤ OK!
  (command "_move" (entlast) "" "0,0,0" (list 0 0 #wk-thk))  ; ワークトップ厚み分 z軸方向に移動

  ;// 配置原点と角度を確保
  (setq #pos (cdr (assoc 10 (entget (entlast))))) ; "INSERT" 挿入点
  (setq #ang (cdr (assoc 50 (entget (entlast))))) ; "INSERT" 回転角度
  (setq #grp (nth 6 #fig$)) ; ;図形ID  ;2008/06/23 YM OK
  (command "_explode" (entlast))                    ;インサート図形分解
  (setq #ss_dum (ssget "P"))
  (SKMkGroup #ss_dum)
;;;  (setq #sym (SKC_GetSymInGroup (ssname #ss_dum 0))) ; グループ図形の中からシンボル基準点図形を抜き出す
     (setq #sym (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

  ;// 『品番基本』から性格CODEを取得する
  (setq #seikaku CG_SKK_INT_SNK) ; シンク ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化

  (WebOutLog "拡張ﾃﾞｰﾀ G_LSYM をｾｯﾄします"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  (CFSetXData #sym "G_LSYM"
    (list
      #figID                ;1 :本体図形ID      :『品番図形』.図形ID  ;2008/06/23 YM OK     2011/04/07 YM ADD
      #pos                  ;2 :挿入点          :配置基点
      #ang                  ;3 :回転角度        :配置回転角度
      CG_Kcode              ;4 :工種記号        :CG_Kcode
      CG_SeriesCode         ;5 :SERIES記号    :CG_SeriesCode
      #sink_hinban          ;6 :品番名称        :『品番図形』.品番名称   ; 品番図形、品番名称 OK!
      (nth 1  #fig$)        ;7 :L/R区分         :『品番図形』.部材L/R区分  ; 品番図形、LR区分 'STR OK!
      ""         ;8 :扉図形ID        :
      ""         ;9 :扉開き図形ID    :
      (fix #seikaku)        ;10:性格CODE      :『品番基本』.性格CODE
      0                     ;11:複合フラグ      :０固定（単独部材）
      0                     ;12:配置順番号      :配置順番号(1～)
      (fix (nth 2 #fig$))   ;13:用途番号        :『品番図形』.用途番号   ;2008/06/23 YM OK
      (fix (nth 5 #fig$))   ;14:寸法Ｈ          :『品番図形』.寸法Ｈ     ;2008/06/23 YM OK
      1                     ;15:断面有無
      "A"                   ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
    )
  )

  (KcSetG_OPT #sym) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ

  ;2010/10/13 YM ADD-S [ｼﾝｸOP]テーブル参照で紐付け
  (KcSetSinkG_OPT #sym) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ
  ;2010/10/13 YM ADD-E


;-- 2011/09/17 A.Satoh Mod - S
;;;;;;;; 新規 07/27 YM 水栓穴ID(key) から「WT水栓穴」."水栓穴記号"を求める
;;;;;  (setq #ANAqry$ ; １つ引き当て
;;;;;    (CFGetDBSQLRec CG_DBSESSION "WT水栓穴"
;;;;;      (list
;;;;;        (list "水栓穴ID" "1" 'INT)
;;;;;      )
;;;;;    )
;;;;;  );_(setq
;;;;;  (setq #ANAqry$ (DBCheck #ANAqry$ "『WT水栓穴』" "PKC_LayoutSink")) ; nil or 複数時 ｴﾗｰ
;;;;;  (setq #WtrHoleCode (cadr #ANAqry$))
  (setq #WtrHoleCode "0");2011/09/17 YM ADD きめうち使用しない
;-- 2011/09/17 A.Satoh Mod - E

  (if (not (tblsearch "APPID" "G_SINK")) (regapp "G_SINK"))

  ;// 拡張データの付加
  (WebOutLog "拡張ﾃﾞｰﾀ G_SINK をｾｯﾄします"); 02/09/04 YM ADD ﾛｸﾞ出力追加
  (CFSetXData #sym "G_SINK"
    (list
      (nth 17 CG_GLOBAL$)  ; シンク記号
      #WtrHoleCode ; 水栓穴記号
      0            ; ｼﾝｸﾎﾟｹｯﾄの無 0
      ""           ; シンク穴図形ハンドル
    )
  );_CFSetXData

;;; ここにきて初めて性格CODE"410" "G_PTEN" 水洗穴が取れる
  (setq #pt_lis (PKC_GetSuisenAnaPt #sym 4)) ; シンク内の水洗穴位置座標のリスト element 4個
  (setq #pt_SUISEN (car #pt_lis))
  (setq #y_SUISEN  (cadr #pt_SUISEN))
  (setq #move (- #y_SUISEN (cadr #pos)))

;;;;;; シンクオフセット量 (WT前面からシンク親図形)で配置したのをKPCAD用(WT前面から水栓穴位置)に修正移動する.
  (setq #ss_SNK (CFGetSameGroupSS #sym))   ; シンボル図形名を渡して選択セット(330図形名の340図形名)を得る.

;;; 3D要素編集の移動
  (command "_.move" #ss_SNK "" "0,0,0" (list 0 (- #move) 0))    ; 要素の移動
  (ChgLSYM1 #ss_SNK)

  (setq #i 0)
  (while (and #loop (< #i (length #pt$)))
    (setq #pt (nth #i #pt$))
    (if (= -1 (setq #ret (CFAreaInPt #pt (AddPtList #area$))))
      (setq #loop nil)
    )
    (setq #i (1+ #i))
  )


  (princ)
);PKC_LayoutSink

;;;<HOM>*************************************************************************
;;; <関数名>    : KcSetSinkG_OPT
;;; <処理概要>  : アイテムに拡張ﾃﾞｰﾀ "G_OPT"を追加セットする。[ｼﾝｸOP]参照
;;; <戻り値>    : なし
;;; <作成>      : 2010/10/13 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun KcSetSinkG_OPT (
  &eSYM   ; ｼﾝﾎﾞﾙ図形
  /
  #ADDOP$ #IHIN #IOP #QRY$$ #SHIN #SOPT
  )
  (setq #QRY$$ nil)  ; 初期化
  (setq #sHIN (nth 5 (CFGetXData &eSYM "G_LSYM"))) ; "品番名称"

  (setq #QRY$$ ; 複数HIT可
    (CFGetDBSQLRec CG_DBSESSION "シンクOP"
      (list
        (list "材質記号"   (nth 16 CG_GLOBAL$) 'STR)
        (list "シンク記号" (nth 17 CG_GLOBAL$) 'STR)
      )
    )
  )
  (if #QRY$$
    (progn
      (setq #addOP$ nil)
      (setq #iHIN 0) ; ｵﾌﾟｼｮﾝ品番種類数

      (foreach #QRY$ #QRY$$
        (setq #sOPT (nth 2 #QRY$))     ;ｵﾌﾟｼｮﾝ品番名称
        (setq #iOP (fix (nth 3 #QRY$)));個数
        ; オプション品個数が1以上ならOPT設置リストに取得
        (if (<= 1 #iOP)
          (progn
            (setq #addOP$ (append #addOP$ (list #sOPT #iOP))) ; 品番と個数
            (setq #iHIN (1+ #iHIN))
          )
        );_if

      ); foreach

      ; 最終的に品番個数が0なら結果リストnil代入 1以上なら品番個数をOPT設置リスト付加
      (setq #addOP$ (if (< 0 #iHIN) (cons #iHIN #addOP$) nil))

      ; アイテムにOPT付加実行
      (if #addOP$
        (progn
          (if (= (tblsearch "APPID" "G_OPT") nil)
            (regapp "G_OPT");アプリケーション名登録
          );_if
          (CFSetXData &eSYM "G_OPT" #addOP$)
        )
      );_if
    )
  );_if
  (princ)
); KcSetSinkG_OPT

;;;<HOM>*************************************************************************
;;; <関数名>    : KcSetSinkG_OPT_KPCAD
;;; <処理概要>  : アイテムに拡張ﾃﾞｰﾀ "G_OPT"を追加セットする。[ｼﾝｸOP]参照 
;;; <戻り値>    : なし
;;; <作成>      : 2010/10/13 YM
;;; <備考>      : KPCAD用に引数が必要
;;;*************************************************************************>MOH<
(defun KcSetSinkG_OPT_KPCAD (
  &eSYM   ; ｼﾝﾎﾞﾙ図形
	&zai
	&snk
  /
  #ADDOP$ #IHIN #IOP #QRY$$ #SHIN #SOPT
  )
  (setq #QRY$$ nil)  ; 初期化
  (setq #sHIN (nth 5 (CFGetXData &eSYM "G_LSYM"))) ; "品番名称"

  (setq #QRY$$ ; 複数HIT可
    (CFGetDBSQLRec CG_DBSESSION "シンクOP"
      (list
        (list "材質記号"   &zai 'STR)
        (list "シンク記号" &snk 'STR)
      )
    )
  )
  (if #QRY$$
    (progn
      (setq #addOP$ nil)
      (setq #iHIN 0) ; ｵﾌﾟｼｮﾝ品番種類数

      (foreach #QRY$ #QRY$$
        (setq #sOPT (nth 2 #QRY$))     ;ｵﾌﾟｼｮﾝ品番名称
        (setq #iOP (fix (nth 3 #QRY$)));個数
        ; オプション品個数が1以上ならOPT設置リストに取得
        (if (<= 1 #iOP)
          (progn
            (setq #addOP$ (append #addOP$ (list #sOPT #iOP))) ; 品番と個数
            (setq #iHIN (1+ #iHIN))
          )
        );_if

      ); foreach

      ; 最終的に品番個数が0なら結果リストnil代入 1以上なら品番個数をOPT設置リスト付加
      (setq #addOP$ (if (< 0 #iHIN) (cons #iHIN #addOP$) nil))

      ; アイテムにOPT付加実行
      (if #addOP$
        (progn
          (if (= (tblsearch "APPID" "G_OPT") nil)
            (regapp "G_OPT");アプリケーション名登録
          );_if
          (CFSetXData &eSYM "G_OPT" #addOP$)
        )
      );_if
    )
  );_if
  (princ)
); KcSetSinkG_OPT_KPCAD

;;;<HOM>*************************************************************************
;;; <関数名>     : MultiCabCut
;;; <処理概要>   : ﾏﾙﾁｼﾝｸ時、ｷｬﾋﾞﾈｯﾄ一部ｶｯﾄ
;;; <戻り値>     : なし
;;; <作成>       : 08/07/28 YM ADD
;;; <備考>       : "BLUE"の"3DSOLID","POINT"をあらかじめﾏﾙﾁｼﾝｸ図形に埋め込んでおく
;;;              : 
;;;*************************************************************************>MOH<
(defun MultiCabCut (
  /
  #EN #I #P1 #P1X #P2 #P2X #POINT1 #POINT2 #SEIKAKU #SINK #SSC
  #SS_BLUE_POINT #SS_BLUE_SOLID #SYM #XD-LSYM$
  #DEL_SOLID #LAST #SINK$
  )
  (setq #ss_BLUE_SOLID (ssget "X" (list (cons 0 "3DSOLID") (cons 8 "Z_00_00_00_01") (cons 62 5))))
  (setq #ss_BLUE_POINT (ssget "X" (list (cons 0 "POINT")   (cons 8 "Z_00_00_00_01") (cons 62 5))))
  
  (if (and #ss_BLUE_SOLID #ss_BLUE_POINT (< 0 (sslength #ss_BLUE_SOLID))(< 0 (sslength #ss_BLUE_POINT)))
    (progn

      ;取り除く3DSOLID図形
      (setq #DEL_SOLID (ssname #ss_BLUE_SOLID 0))

      ;ﾎﾟｲﾝﾄのX座標を比較
      (setq #p1 (cdr (assoc 10 (entget (ssname #ss_BLUE_POINT 0)))))
      (setq #p1X (car #p1))
      (setq #p2 (cdr (assoc 10 (entget (ssname #ss_BLUE_POINT 1)))))
      (setq #p2X (car #p2))

      (if (< #p1X #p2X)
        (progn ;X座標が大きい方が#point1
          (setq #point1 #p2)
          (setq #point2 #p1)
        )
        (progn
          (setq #point1 #p1)
          (setq #point2 #p2)
        )
      );_if

      ;領域内の"3DSOLID"
      (command "vpoint" "0,0,1")
      (setq #ssC (ssget "C" #point1 #point2 (list (cons 0 "3DSOLID") (cons 8 "Z_00_00_00_01"))))
      ;シンク図形は取り除く
      (setq #i 0)(setq #SINK$ nil)
      (repeat (sslength #ssC)
        (setq #en (ssname #ssC #i))
        (setq #sym (SearchGroupSym (ssname #ssC #i)))
        (setq #xd-lsym$ (CFGetXData #sym "G_LSYM"))
        (setq #seikaku  (nth 9 #xd-lsym$)) ;性格CODE
        (if (= #seikaku CG_SKK_INT_SNK)
          (setq #SINK$ (append #SINK$ (list #en)))
        );_if
        (setq #i (1+ #i))
      )
      (foreach #SINK #SINK$
        (ssdel #SINK #ssC)     ;ｶｯﾄするﾊﾟｰｽ(ｼﾝｸ図形を除く)
      )

      ;ｶｯﾄ処理を行う
      (command "vpoint" "1,-1,1")

      (setq #i 0)
      (repeat (sslength #ssC)
        (setq #en (ssname #ssC #i))
        (command "._COPY" #DEL_SOLID "" "0,0,0" "0,0,0")
        (setq #last (entlast))
        (command "_.subtract" #en "" #last "")
        (command "_REGEN")
        (setq #i (1+ #i))
      );repeat

      ;青い図形を削除する
      (command "_.ERASE" #DEL_SOLID "")
      (command "_.ERASE" #ss_BLUE_POINT "")
    )
  );_if

  (princ)
);MultiCabCut


;;;<HOM>*************************************************************************
;;; <関数名>     : KPW_PosSink2
;;; <処理概要>   : シンクを配置する
;;; <戻り値>     : シンク図形名
;;; <作成>       : 00/02/17  MH ADD
;;; <備考>       : 00/04/07 YM 修正 U型対応 新型WT用
;;;              : 00/05/04 ｼﾝｸ配置matrix対応
;;;                00/10/05 YM MOD ｼﾝｸｵﾌｾｯﾄ量 WT前面から排水穴PTEN4 までの距離
;;;                ｼﾝｸ位置はWTの端から(I型,L型対応) 00/12/02 YM MOD
;;;                I型の場合：ｼﾝｸR,Z==>WT右端から,ｼﾝｸL==>WT左端から
;;;                L型の場合：ｼﾝｸのある側のｺｰﾅｰでないWT端から
;;;*************************************************************************>MOH<
(defun KPW_PosSink2 (
  &name$
  &scab-en   ;(ENAME)シンクキャビ基点図形
  &w-xd$     ;(LIST)ワークトップ拡張データ
  &w-off     ;(REAL)Ｗ方向オフセット(ｼﾝｸ脇寸法)
  &LR        ; ｼﾝｸﾀｲﾌﾟLRZ
  &ZaiF      ;素材F
  &pocket    ;ｼﾝｸﾎﾟｹｯﾄ有無"Y" or "N"
;-- 2011/09/17 A.Satoh Add - S
  &width     ;ｼﾝｸｷｬﾋﾞｾﾝﾀｰ位置
;-- 2011/09/17 A.Satoh Add - E
  /
;-- 2011/09/17 A.Satoh Mod - S
;;;;;  #ANAPT #ANG #AREA$ #BASEP #BASEPT #D-OFF #DIMW2 #DUMPT$ #EN$ #FGSHIFT #FIG$ #FIGID 
;;;;;  #FSNKANG #FSNK_H #H-NO #I #IWTTHK #LOOP #LR #LR_EXIST #MOVE_Y #MSG1 #MSG2 #NAME$ #ORG_LR 
;;;;;  #P-SS #P3 #P4 #PMEN2 #PMEN6 #PMEN8 #POS #PT #PT$ #PT_LIS #RET #S-XD$ #SNK #SPLAN #SS_DUM 
;;;;;  #SS_SNK #SYM #TEI #TYPE1 #WTCUT #WTL #WTP1 #WTP2 #WTP3 #WTP4 #WTP5 #WTP6 #WTP7 #WTP8 
;;;;;  #WTPT #WTPT$ #WTR #WT_LR #X #XP #YNO
;;;;;#WTPLAST ; 02/09/04 YM ADD
  #name$ #SNK #h-no #d-off #LR #fSNK_H #iWTthk #FGSHIFT #s-xd$ #fSNKang #offset
  #pmen8 #pmen2 #pt$ #BASEPT #dumpt$ #dMin #dMax #dVm #p3 #p4 #YNO #SPLAN #fig$
  #figID #pt #pos #ang #ss_dum #sym #XP #pt_lis #AnaPt #move_Y #ss_SNK #p-ss #pmen6
  #area$ #loop #i #Msg1 #Msg2 #en$
;-- 2011/09/17 A.Satoh Mod - E
#p2 #XP1 #XP2 #move_X	;-- 2011/10/25 A.Satoh Add
#RET ;2017/01/19 YM ADD
  )

  (setq #name$ &name$)
;-- 2011/09/17 A.Satoh Mod - S
;;;;;;-- 2011/06/29 A.Satoh Mod - S
;;;;;;|
;;;;;  (setq #SNK      (nth 1 #name$)) ; ｼﾝｸ記号
;;;;;  (setq #LR_EXIST (nth 9 #name$)) ; LR有無
;;;;;  (setq #h-no     (nth 5 #name$)) ;(STR)『WTｼﾝｸ』.品番名称
;;;;;  (if (= &ZaiF 1) ; WT前面から排水穴PTEN4 までの距離 00/10/05 YM MOD
;;;;;    (setq #d-off (nth  8 #name$)) ;(INT)『WTｼﾝｸ』.ｼﾝｸｵﾌｾｯﾄ量(ｽﾃﾝﾚｽ)
;;;;;    (setq #d-off (nth 15 #name$)) ;(INT)『WTｼﾝｸ』.ｼﾝｸｵﾌｾｯﾄ量(人大)
;;;;;  );_if
;;;;;|;
;;;;;  (setq #SNK      (nth 1 #name$)) ; ｼﾝｸ記号
;;;;;  (setq #LR_EXIST (nth 4 #name$)) ; LR有無
;;;;;  (setq #h-no     (nth 3 #name$)) ;(STR)『WTｼﾝｸ』.品番名称
;;;;;  (if (= &ZaiF 1) ; WT前面から排水穴PTEN4 までの距離 00/10/05 YM MOD
;;;;;    (setq #d-off (nth 5 #name$)) ;(INT)『WTｼﾝｸ』.ｼﾝｸｵﾌｾｯﾄ量(ｽﾃﾝﾚｽ)
;;;;;    (setq #d-off (nth 6 #name$)) ;(INT)『WTｼﾝｸ』.ｼﾝｸｵﾌｾｯﾄ量(人大)
;;;;;  );_if
;;;;;;-- 2011/06/29 A.Satoh Mod - E
;;;;;
;;;;;  (setq #LR &LR) ; ｼﾝｸﾀｲﾌﾟLRZ
;;;;;  (setq #type1   (nth  3 &w-xd$))  ;WT形状ﾀｲﾌﾟ0,1,2
;;;;;  (setq #WTcut   (nth  7 &w-xd$))  ;WTｶｯﾄﾀｲﾌﾟ
;;;;;  (setq #fSNK_H  (nth  8 &w-xd$))  ;WT取り付け高さ
;;;;;  (setq #iWTthk  (nth 10 &w-xd$))  ;WT厚み 23
;;;;;  (setq #FGSHIFT (nth 17 &w-xd$))  ;WT前垂れｼﾌﾄ量
;;;;;  (setq #WT_LR   (nth 30 &w-xd$))  ;WT勝手
;;;;;  (setq #BaseP   (nth 32 &w-xd$))  ;WT左上点
;;;;;  (setq #tei     (nth 38 &w-xd$))  ;WT底面図形ﾊﾝﾄﾞﾙ
;;;;;  (setq #WTL     (nth 47 &w-xd$))  ;WT左
;;;;;  (setq #WTR     (nth 48 &w-xd$))  ;WT右

	;2017/01/20 YM ADD 天板の勝手でずらす方向を判断する
	(setq #WT_LR   (nth 30 &w-xd$))  ;WT勝手
	(cond
		((= #WT_LR "L")
			;そのままｼﾝｸｷｬﾋﾞ配置方向
			(setq #DirecFLG "L")
	 	)
		((= #WT_LR "R")
			;ｼﾝｸｷｬﾋﾞ配置方向とは逆方向
			(setq #DirecFLG "R")
	 	)
		(T
	    (initget 1 "L R")
	    (setq #DirecFLG (getkword "\nｼﾝｸ勝手を指示 /L=左ｼﾝｸ /R=右ｼﾝｸ /:  "))
	 	)
	);_cond

  (setq #SNK      (nth 1 #name$)) ; ｼﾝｸ記号
  (setq #h-no     (nth 3 #name$)) ;(STR)『WTｼﾝｸ』.品番名称
  (if (= &ZaiF 1) ; WT前面から排水穴PTEN4 までの距離
    (setq #d-off (nth 5 #name$)) ;(INT)『WTｼﾝｸ』.ｼﾝｸｵﾌｾｯﾄ量(ｽﾃﾝﾚｽ)
    (setq #d-off (nth 6 #name$)) ;(INT)『WTｼﾝｸ』.ｼﾝｸｵﾌｾｯﾄ量(人大)
  )

  (setq #LR &LR) ; ｼﾝｸﾀｲﾌﾟLRZ
  (setq #fSNK_H  (nth  8 &w-xd$))  ;WT取り付け高さ
  (setq #iWTthk  (nth 10 &w-xd$))  ;WT厚み 23
  (setq #FGSHIFT (nth 17 &w-xd$))  ;WT前垂れｼﾌﾄ量
;-- 2011/09/17 A.Satoh Mod - E

  ;// シンクキャビの拡張データを取り出す
  (setq #s-xd$ (CFGetXData &scab-en "G_LSYM")) ; ｼﾝｸｷｬﾋﾞﾈｯﾄ拡張ﾃﾞｰﾀ
  (setq #fSNKang (nth 2 #s-xd$))     ; 回転角度
;-- 2011/09/17 A.Satoh Add - S
  (setq #offset (- &w-off &width))
;-- 2011/09/17 A.Satoh Add - E

  ;// シンクキャビネットに設定されているシンク取付け領域PMEN8,外形領域PMEN2を取得
  (setq #pmen8 (PKGetPMEN_NO &scab-en 8)) ; &scab-en ｼﾝﾎﾞﾙ図形名 ｼﾝｸ取り付け領域 #pmen8
  (setq #pmen2 (PKGetPMEN_NO &scab-en 2)) ; &scab-en ｼﾝﾎﾞﾙ図形名 ｼﾝｸｷｬﾋﾞ外形領域 #pmen2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 &scab-en))   ; PMEN2 を作成
  );_if

;;; WTの配置角度とｼﾝｸｷｬﾋﾞの配置角度があっているか
;;; 隣接WTがあるかどうか
;;;+-----------------------+  +-------------------------+  +----------------+
;;;|                       |  |          +------+       |  |                |
;;;|     +---------+       |  |          |      |       |  |                |
;;;|     |ｼﾝｸ      |<----->|  |          |      |<----->端 |         +------+
;;;|     |         |       |  |          +------+       |  |  +----+ |
;;;|     +---------+       |  |     +-------------------+  |  |    | |
;;;+-----------------------+  |     |                      |  |    | |
;;;                           |     |                      |  |    | |
;;;                           +-----+                      |  +----+ |
;;;                                                        |         |
;;;                                                        +----端---+
;;;<I型>
;;;  p1                 pt             p2
;;;   +-----------------*--------------+
;;;   |     ｼﾝｸPMEN6                   | <--WT外形領域
;;;   |       +-------------------+ Rの場合ｼﾝｸ脇寸法 &w-off
;;;   |       |                   |<-->|
;;;   |       |          PTEN4    |    |
;;;   |       |            *----------------------+
;;;   |       |          ｼﾝﾎﾞﾙ    |    |          |
;;;   |       +---------@---------+    |        オフセ量 #d-off
;;;   |                                |          |
;;;   +--------WT前面------------------+----------*
;;;  p4                                p3

;;; ｼﾝｸｼﾝﾎﾞﾙは、W方向に関してｼﾝｸの真ん中にあると仮定
  (setq #pt$ (GetLWPolyLinePt #pmen2)) ; ｼﾝｸｷｬﾋﾞ外形領域点列
  (setq #BASEPT (cdr (assoc 10 (entget &scab-en)))) ; ｼﾝﾎﾞﾙ基準点
  (setq #dumpt$ (GetPtSeries #BASEPT #pt$)) ; 点列内の#BASEPTを先頭に時計周りにする
;-- 2011/09/17 A.Satoh Add - S
  ; ｼﾝｸｷｬﾋﾞ外形領域のｾﾝﾀｰ座標を求める
  (setq #dMin (list (apply 'min (mapcar 'car #pt$)) (apply 'min (mapcar 'cadr #pt$)) 0.0))
  (setq #dMax (list (apply 'max (mapcar 'car #pt$)) (apply 'max (mapcar 'cadr #pt$)) 0.0))
  (setq #dVm  (mapcar '* '(0.5 0.5 1.0) (mapcar '+ #dMin #dMax)))　; 中点算出

  ; シンク配置画面上で設定したシンクキャビｾﾝﾀｰ位置に座標を合わせる
;-- 2011/11/25 A.Satoh Mod - S
;  (setq #dVm  (list (+ (car #dVm) #offset) (cadr #dVm) (caddr #dVm)))

	;2017/01/20 YM ADD #DirecFLG
	(setq #p1 (nth 0 #dumpt$))
	(setq #p2 (nth 1 #dumpt$))
	(cond
		((= #DirecFLG "L")
;;;(setq #dPT1 (polar #p2 (angle #p2 #p1)(atoi CG_R)))
  		(setq #dVm (polar #dVm #fSNKang #offset))
	 	)
		((= #DirecFLG "R");逆向き
  		(setq #dVm (polar #dVm (angle #p2 #p1) #offset))
	 	)
		(T
  		(setq #dVm (polar #dVm #fSNKang #offset))
	 	)
	);_cond

;-- 2011/11/25 A.Satoh Mod - E
;-- 2011/09/17 A.Satoh Add - E

  (if #dumpt$ ; 06/26 YM ADD
    (setq #pt$ #dumpt$) ; nil でない
    (progn ; 外形点列上にｼﾝﾎﾞﾙがない場合
      (setq #BASEPT (PKGetBaseI4 #pt$ (list &scab-en))) ; 点列とｼﾝﾎﾞﾙ基点１つ (00/05/20 YM)
      (setq #pt$ (GetPtSeries #BASEPT #pt$))            ; #BASEPT を先頭に時計周り (00/05/20 YM)
    )
  );_if
;-- 2011/10/25 A.Satoh Add - S
	(setq #p2 (nth 1 #pt$))
;-- 2011/10/25 A.Satoh Add - E
  (setq #p3 (nth 2 #pt$)) ; PMEN2外形の前面(上図)
  (setq #p4 (nth 3 #pt$)) ; PMEN2外形の前面(上図)

;;; 用途番号
;;;  0: 標準(ステン)
;;;  1: 人大シンク
;;;  2: ポケット付シンク
;;;  3: ポケット付人大シンク
;;; 10: Sプランシンク
;;; 11: Sプラン人大シンク
;;; 12: SプランP付シンク
;;; 13: SプランP付人大シンク

;;; &ZaiF      ;素材F
;;; &pocket    ;ｼﾝｸﾎﾟｹｯﾄ有無"Y" or "N"
;;; (nth 5 #s-xd$)) ; ｼﾝｸｷｬﾋﾞ品番名称
;;; #SNK       ; ｼﾝｸ記号

  ; 用途番号決定 01/02/10 YM
  (if (= &ZaiF 1) ; ｽﾃﾝﾚｽか
    (setq #YNO 0)
    (setq #YNO 1)
  )
  (if (= &pocket "Y") ; ﾎﾟｹｯﾄ付きか
    (setq #YNO (+ 2 #YNO))
  )
  (setq #SPLAN (CFgetini "SPLAN" "0001" (strcat CG_SKPATH "ERRMSG.INI")))
  (if (and (= #SNK "SA")(wcmatch (nth 5 #s-xd$) #SPLAN))
    (setq #YNO (+ 10 #YNO)) ; Sﾌﾟﾗﾝ専用ｼﾞｬﾝﾎﾞｼﾝｸの場合
  );_if
  (setq #YNO (itoa #YNO)) ; 用途番号

;-- 2011/09/17 A.Satoh Del - S
;;;;;  (if (equal #LR_EXIST 0 0.1)
;;;;;    (setq #ORG_LR "Z")
;;;;;    (setq #ORG_LR #LR)
;;;;;  );_if
;-- 2011/09/17 A.Satoh Del - E

  (setq #fig$
    (CFGetDBSQLHinbanTable "品番図形" #h-no
      (list
        (list "品番名称"   #h-no  'STR)
        (list "LR区分"     #LR    'STR)
;-- 2011/06/29 A.Satoh Mod - S
; ☆☆☆☆☆ 用途番号を条件リストに復活
;;;        (list "用途番号"   #YNO   'INT)
        (list "用途番号"   #YNO   'INT)
;-- 2011/06/29 A.Satoh Mod - E
      )
    )
  )
  (if (and #fig$ (= (length #fig$) 1))
    (setq #fig$ (car #fig$))
    (progn
      (CFAlertMsg 
        (strcat "\n用途番号=" #YNO "のﾚｺｰﾄﾞが品番図形にないか、または複数存在します。"
        "\n品番: " #h-no " LR: " #LR)
      )
      (quit)
    )
  );_if

  ; #fig$ 決定
;  (setq #dimW2 (* 0.5 (nth 3 #fig$)));2008/06/28 YM OK!
  (setq #figID (nth 6 #fig$));2008/06/28 YM OK!
  (if (= #figID nil) ; 00/11/14 YM ADD
    (progn
      (CFAlertMsg (strcat "\n『品番図形』に図形IDが未登録です。\n" (nth 0 #fig$)))
      (quit)
    )
  );_if

;-- 2011/09/17 A.Satoh Del - S
;;;;;;|
;;;;;  (setq #wtpt$ (GetLWPolyLinePt #tei)); 外形点列
;;;;;;;; 外形点列&pt$を#BASEPを先頭に時計周りにする
;;;;;  (setq #wtpt$ (GetPtSeries #BaseP #wtpt$))
;;;;;  (setq #wtp1 (nth 0 #wtpt$))
;;;;;  (setq #wtp2 (nth 1 #wtpt$))
;;;;;  (setq #wtp3 (nth 2 #wtpt$))
;;;;;  (setq #wtp4 (nth 3 #wtpt$))
;;;;;  (setq #wtp5 (nth 4 #wtpt$))
;;;;;  (setq #wtp6 (nth 5 #wtpt$))
;;;;;  (setq #wtp7 (nth 6 #wtpt$))
;;;;;  (setq #wtp8 (nth 7 #wtpt$))
;;;;;  (setq #wtpLast (last #wtpt$)) ; 02/04/05 YMA ADD
;;;;;
;;;;;  ; ｼﾝｸ挿入点#ptを求める
;;;;;  (cond
;;;;;    ; L型ｶｯﾄなし
;;;;;    ; 1---------2
;;;;;    ; |         |
;;;;;    ; 4---------3
;;;;;    ((and (= #type1 0)(or (= #WTcut "00")(= #WTcut "04")(= #WTcut "40")))
;;;;;      (cond ; ｶｯﾄなし
;;;;;        ((= #WT_LR "R") ; WTの勝手をみる
;;;;;          (setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off))) ; 右端から
;;;;;        )
;;;;;        ((= #WT_LR "L") ; WTの勝手をみる
;;;;;          (setq #pt (polar #wtp1 (angle #wtp1 #wtp2) (+ #dimW2 &w-off))) ; 左端から
;;;;;        )
;;;;;        (T ; WTの勝手が不明のとき右勝手
;;;;;          (initget 1 "Left Right")
;;;;;          (setq #x (getkword "\n配置側を指示 /L=左/R=右/:  "))
;;;;;          (cond
;;;;;            ((= #x "Right")(setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off)))) ; 右端から
;;;;;            ((= #x "Left") (setq #pt (polar #wtp1 (angle #wtp1 #wtp2) (+ #dimW2 &w-off)))) ; 左端から
;;;;;          );_cond
;;;;;        )
;;;;;      );_cond
;;;;;    )
;;;;;    ; L型ｶｯﾄなし
;;;;;    ; 1---------2
;;;;;    ; |         |
;;;;;    ; |   4-----3
;;;;;    ; |   |
;;;;;    ; 6---5
;;;;;    ((and (= #type1 1)(or (= #WTcut "00")(= #WTcut "04")(= #WTcut "40")))
;;;;;      (if (= (CFArea_rl #wtp1 #wtp4 #BASEPT) -1)
;;;;;        ; 右側(ｺﾝﾛ側)
;;;;;        (setq #pt (polar #wtp6 (angle #wtp6 #wtp1) (+ #dimW2 &w-off))) ; 端から
;;;;;        ; else
;;;;;        ; 左側(ｼﾝｸ側)
;;;;;        (setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off))) ; 端から
;;;;;      );_if
;;;;;    )
;;;;;    ; U型ｶｯﾄなし
;;;;;    ; 1---------2
;;;;;    ; |         |
;;;;;    ; |   4-----3
;;;;;    ; |   |
;;;;;    ; |   5-----6
;;;;;    ; |         |
;;;;;    ; 8---------7
;;;;;    ((and (= #type1 2)(or (= #WTcut "00")(= #WTcut "04")(= #WTcut "40")))
;;;;;      (cond
;;;;;        ((equal (Angle0to360 (angle #wtp1 #wtp2)) (Angle0to360 #fSNKang) 0.001) ; 1枚目WTにｼﾝｸ配置する
;;;;;          (setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off)))          ; 右端から
;;;;;        )
;;;;;        ((equal (Angle0to360 (angle #wtp8 #wtp1)) (Angle0to360 #fSNKang) 0.001) ; 2枚目WTにｼﾝｸ配置する
;;;;;          (initget 1 "Left Right")
;;;;;          (setq #x (getkword "\n配置側を指示 /L=左/R=右/:  "))
;;;;;          (cond
;;;;;            ((= #x "Right")(setq #pt (polar #wtp1 (angle #wtp1 #wtp8) (+ #dimW2 &w-off)))) ; 右端から
;;;;;            ((= #x "Left") (setq #pt (polar #wtp8 (angle #wtp8 #wtp1) (+ #dimW2 &w-off)))) ; 左端から
;;;;;          );_cond
;;;;;        )
;;;;;        ((equal (Angle0to360 (angle #wtp7 #wtp8)) (Angle0to360 #fSNKang) 0.001) ; 3枚目WTにｼﾝｸ配置する
;;;;;          (setq #pt (polar #wtp7 (angle #wtp7 #wtp8) (+ #dimW2 &w-off)))          ; 左端から
;;;;;        )
;;;;;        (T ; その他(ありえない)
;;;;;          (setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off)))
;;;;;        )
;;;;;      );_cond
;;;;;    )
;;;;;; else ｶｯﾄあり斜めｶｯﾄ or Jｶｯﾄ or I型ｶｯﾄなし
;;;;;    (T
;;;;;      (cond
;;;;;        ((and (/= #WTR "")(= #WTL "")) ; 右：あり、左：なし
;;;;;          (setq #pt (polar #wtp1 (angle #wtp1 #wtp2) (+ #dimW2 &w-off))) ; 左端から
;;;;;        )
;;;;;        ((and (/= #WTL "")(= #WTR "")) ; 右：なし、左：あり
;;;;;          (setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off))) ; 右端から
;;;;;        )
;;;;;        (T ; 両側ｶｯﾄ
;;;;;          ; 01/12/26 YM ADD-S
;;;;;          (initget 1 "Left Right")
;;;;;          (setq #x (getkword "\n配置側を指示 /L=左/R=右/:  "))
;;;;;          (cond
;;;;;            ((= #x "Right")(setq #pt (polar #wtp2 (angle #wtp2 #wtp1) (+ #dimW2 &w-off)))) ; 右端から
;;;;;            ((= #x "Left") (setq #pt (polar #wtp1 (angle #wtp1 #wtp2) (+ #dimW2 &w-off)))) ; 左端から
;;;;;          );_cond
;;;;;          ; 01/12/26 YM ADD-E
;;;;;        )
;;;;;      );_cond
;;;;;    )
;;;;;  );_cond
;;;;;|;
;-- 2011/09/17 A.Satoh Del - E

  ; ｼﾝｸｷｬﾋﾞ寸法H + WT厚み分 Z方向に移動
;-- 2011/09/17 A.Satoh Mod - S
;  (setq #pt (list (car #pt) (cadr #pt) (+ #fSNK_H #iWTthk)))
  (setq #pt (list (car #dVm) (cadr #dVm) (+ #fSNK_H #iWTthk)))
;-- 2011/09/17 A.Satoh Mod - S

  ;;; 図形が存在するか確認
  (if (= nil (findfile (strcat CG_MSTDWGPATH #figID ".dwg")))
    (progn
;;;      (CFOutLog 0 nil (strcat "ｼﾝｸ部材図形:" #figID "がありません"))
;;;      (CFOutLog 0 nil (strcat "  +品番名称:" (nth 0 #fig$)))
      (*error*)
    )
  )
  ;;;図形挿入実行
  (command "_insert" (strcat CG_MSTDWGPATH #figID) #pt 1 1 (rtd #fSNKang))

  ;// 配置原点と角度を確保
  (setq #pos (cdr (assoc 10 (entget (entlast))))) ; "INSERT" 挿入点
  (setq #ang (cdr (assoc 50 (entget (entlast))))) ; "INSERT" 回転角度

  (command "_explode" (entlast))                    ;インサート図形分解
  (setq #ss_dum (ssget "P"))
  (SKMkGroup #ss_dum)
;;;  (setq #sym (SKC_GetSymInGroup (ssname #ss_dum 0))) ; グループ図形の中からシンボル基準点図形を抜き出す
  (setq #sym (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

  (CFSetXData #sym "G_LSYM"
    (list
      #figID                ;1 :本体図形ID      :『品番図形』.図形ID  ; 品番図形、図形ＩＤ OK!
      #pos                  ;2 :挿入点          :配置基点
      #ang                  ;3 :回転角度        :配置回転角度
      (nth 0 &w-xd$)        ;4 :工種記号        :CG_Kcode
      (nth 1 &w-xd$)        ;5 :SERIES記号    :CG_SeriesCode
      (nth 0 #fig$)         ;6 :品番名称        :『品番図形』.品番名称   ; 品番図形、品番名称 OK!
      (nth 1 #fig$)         ;7 :L/R区分         :『品番図形』.部材L/R区分  ; 品番図形、LR区分 'STR OK!
      ""         ;8 :扉図形ID        :                                   OK!
      ""         ;9 :扉開き図形ID    :                                   OK!
      (fix CG_SKK_INT_SNK)  ;10:性格CODE      :『品番基本』.性格CODE ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
      0                     ;11:複合フラグ      :０固定（単独部材）
      0                     ;12:配置順番号      :配置順番号(1～)
      (fix (nth 2 #fig$))   ;13:用途番号        :『品番図形』.用途番号           ;2008/06/28 YM OK!
      (fix (nth 5 #fig$))   ;14:寸法Ｈ          :『品番図形』.寸法Ｈ             ;2008/06/28 YM OK!
      1                     ;15:断面有無
      "A"                   ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
    )
  )
  
(KcSetG_OPT #sym)


;;; 最初に配置したところ  一度配置しないと水栓穴(*印)座標をとれない
;;; W方向のみ合わせて配置。後でｼﾝｸを移動してD方向を修正する。
;;;           +-------------------+
;;;           |   #AnaPt          |
;;;        sink    *  PTEN4       |
;;;           |    |             PMEN6
;;;           |    |     ｼﾝﾎﾞﾙ    |
;;;   +-------+---------*---------+----+p2
;;;  p1            |    #pos=#pt       |
;;;   |                                |
;;;   |            |                   |
;;;   |                                |
;;;   |            |                   |
;;;   |                                |<--ｼﾝｸｷｬﾋﾞ
;;;   |            |                   |
;;;   |            |                   |
;;;   +------------XP------------------+
;;;   +-------------------- WT前面 ----+

;-- 2011/09/17 A.Satoh Mod - S
;  ;;; PTEN4 位置座標を取得
;  (setq #pt_lis (PKC_GetSuisenAnaPt #sym 4)) ; シンク内の排水穴(PTEN4属性0)位置座標のリスト 00/10/05 引数"4"追加
;  (setq #AnaPt (car #pt_lis))                ; 排水穴どれか１つ
;  (setq #XP (CFGetDropPt #AnaPt (list #p3 #p4)))
;  (setq #move_Y (- #d-off (+ (distance #XP #AnaPt) #FGSHIFT)))
;  ;;;シンク図形 修正移動する.(WT前面から排水穴位置)
;  (setq #ss_SNK (CFGetSameGroupSS #sym))
;  (command "_.move" #ss_SNK "" "0,0,0" (polar '(0 0 0) (+ (dtr 90) #fSNKang) #move_Y))

  (if (wcmatch #SNK "K_*")
    (progn
      (setq #ss_SNK (CFGetSameGroupSS #sym))
    )
    (progn
      ;;; PTEN4 位置座標を取得
      (setq #pt_lis (PKC_GetSuisenAnaPt #sym 4)) ; シンク内の排水穴(PTEN4属性0)位置座標のリスト
      (setq #AnaPt (car #pt_lis))                ; 排水穴どれか１つ

;  (setq #move_Y (- (nth 1 #AnaPt) (nth 1 #pos)))
;#pos　ｼﾝｸ基点　 #AnaPt P点4

;-- 2011/09/20 A.Satoh コメントを復活 - S
      (setq #XP (CFGetDropPt #AnaPt (list #p3 #p4)))
      (setq #move_Y (- #d-off (+ (distance #XP #AnaPt) #FGSHIFT)))
;-- 2011/09/20 A.Satoh コメントを復活 - E
      ;;;シンク図形 修正移動する.(WT前面から排水穴位置)
      (setq #ss_SNK (CFGetSameGroupSS #sym))
;;;      (command "_.move" #ss_SNK "" "0,0,0" (polar '(0 0 0) (+ (dtr 90) #fSNKang) #move_Y))
;;;      (command "_.move" #ss_SNK "" #AnaPt #pos )
;-- 2011/10/25 A.Satoh Mod - S
      ;X方向だけ考慮して移動する
;;;;;      (command "_.move" #ss_SNK "" #AnaPt (list (nth 0 #pos) (nth 1 #AnaPt) (nth 2 #AnaPt) ))
			(setq #XP1 (CFGetDropPt #AnaPt (list #p2 #p3)))
			(setq #XP2 (CFGetDropPt #pos (list #p2 #p3)))
			(setq #move_X (- (distance #XP1 #AnaPt) (distance #XP2 #pos)))

		  (if (wcmatch #SNK "B_*") ;2013/04/15 YM ADD-S 分岐追加
				nil ;Bシンクは位置調整しない
				;else
	      (command "_.move" #ss_SNK "" "0,0,0" (polar '(0 0 0) #fSNKang #move_X))
			);_if

;-- 2011/10/25 A.Satoh Mod - E

;-- 2011/09/20 A.Satoh Add - S
			; Y方向(オフセット量分)に移動する
      (command "_.move" #ss_SNK "" "0,0,0" (polar '(0 0 0) (+ (dtr 90) #fSNKang) #move_Y))
;-- 2011/09/20 A.Satoh Add - E
    )
  )
;-- 2011/09/17 A.Satoh Mod - E
;;;01/05/01YM@  ; 選択セットを渡して図形名のリストを得る.
;;;01/05/01YM@  (setq #en_lis_#ss_SNK  (CMN_ss_to_en #ss_SNK ))
;;;01/05/01YM@  ; "G_LSYM" (挿入点)拡張データの変更
;;;01/05/01YM@  (SetG_LSYM1 #en_lis_#ss_SNK)

  ; "G_LSYM"(挿入点)更新 01/05/01 YM 高速化
  (ChgLSYM1 #ss_SNK)


  ;// シンク図形に設定されているＰ面（=６:干渉チェック領域）の情報を取得する
  ;// シンクキャビネットに設定されているシンク取付け領域（Ｐ面=８）の情報を取得する
  ;//
  ;//   ---> 矩形領域図形:LwPolyLine
;;;  (setq #p-ss (ssget "X" '((-3 ("G_PMEN"))))) ; 00/02/22 YM 複数あるとまずい
;;; (setq #p-ss (CFGetSameGroupSS &scab-en)); メンバー図形選択セット 複数あるとまずい 00/02/22 YM ADD P面6はｼﾝｸが持っているからこの行はだめ

  (setq #p-ss #ss_SNK) ;  00/02/22 YM ADD 上で移動した挿入ｼﾝｸｸﾞﾙｰﾌﾟ選択ｾｯﾄ
  (setq #pmen6 (PKGetPMEN_NO #sym 6)) ; #sym ｼﾝｸｼﾝﾎﾞﾙ図形名 #pmen6

;-- 2011/09/13 A.Satoh Mod - S
;  (setq #area$ (GetLwPolylinePt #pmen8))
  (if (= #pmen8 nil)
    (setq #area$ nil)
    (setq #area$ (GetLwPolylinePt #pmen8))
  )
;-- 2011/09/13 A.Satoh Mod - E
  (setq #pt$   (GetLwPolylinePt #pmen6))
  (setq #loop T)

  ;// シンクの干渉チェック領域がシンクキャビのシンク取付け領域内に収まっているかを平面上
  ;// でチェックする。

;-- 2011/09/13 A.Satoh Mod - S
;  (setq #i 0)
;  (while (and #loop (< #i (length #pt$)))
;    (setq #pt (nth #i #pt$))
;    (if (= -1 (setq #ret (CFAreaInPt #pt (AddPtList #area$))))
;      (setq #loop nil)
;    )
;    (setq #i (1+ #i))
;  )
  (if (/= #area$ nil)
    (progn
      (setq #i 0)
      (while (and #loop (< #i (length #pt$)))
        (setq #pt (nth #i #pt$))
        (if (= -1 (setq #ret (CFAreaInPt #pt (AddPtList #area$))))
          (setq #loop nil)
        )
        (setq #i (1+ #i))
      )
    )
  )
;-- 2011/09/13 A.Satoh Mod - E

  (if (= #loop nil)
    (progn
      (if (or (not #pt$) (not #area$))
        (progn
          (setq #Msg1 "  KPW_PosSink2:干渉チェック領域の取得に失敗しました")
          (setq #Msg2
            (strcat "シンクキャビネットの取付領域の干渉チェックができませんでした"
                    "\n強制的に配置しますか?")
          )
        ); progn
        (progn
          (setq #Msg1 "  KPW_PosSink2:干渉チェック領域がシンク取付領域の範囲を超えています")
          (setq #Msg2 "シンクキャビネットの取付領域に収まりません\n強制的に配置しますか?")
        ); progn
      )

      (setq #en$ (SKC_ConfSinkChkErr #pt$ #area$))

      ;2008/03/31 YM MOD
;;;      (if (CFYesNoDialog #Msg2)
;;;        (mapcar 'entdel #en$)
;;;        (quit)
;;;      )

      ;2008/03/31 YM MOD
      (mapcar 'entdel #en$)

    ); progn
  ); if

;;; シンク図形名を返す
  #sym
);KPW_PosSink2

;-- 2011/09/09 A.Satoh Del - S
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PK_MakeG_WTR
;;;; <処理概要>  : 円"G_WTR"を作成する
;;;; <戻り値>    : 円図形名
;;;; <作成>      : 00/07/22 YM
;;;; <備考>      : 画層も引数 "Z_00_00_00_01" or SKW_AUTO_SECTION 00/09/27 YM
;;;;               NAS-->穴図形に"G_WTHL",MICADO-->処理なし
;;;;*************************************************************************>MOH<
;(defun PK_MakeG_WTR (
;  &kei   ; 直径
;  &o     ; 中心座標
;  &layer ; 水栓穴画層
;  /
;#ELAST ; 02/09/04 YM ADD
;  )
; ; 01/08/07 YM ADD START 径=0対応
; (if (equal &kei 0 0.1)
;   (progn
;     (CFAlertMsg "\n水栓穴の直径が0mmです。水栓穴P点(属性1)に直径>0を設定して下さい。\n直径30mmとして水栓穴を作成します。")
;     (setq &kei 30)
;   )
; );_if
;
;  (entmake ; 中心点と半径を利用してソリッドの元となる円を作る
;    (list
;      '(0 . "CIRCLE")
;      '(100 . "AcDbEntity")
;      '(67 . 0)
;      (cons 8 &layer) ; ｼﾝｸｿﾘｯﾄﾞと同じにした 00/09/19 YM ADD
;;;;      (cons 8 "Z_00_00_00_01") ; ｼﾝｸｿﾘｯﾄﾞと同じにした 00/09/19 YM ADD
;;;;      (cons 8 SKW_AUTO_SECTION) ; "Z_wtbase" 00/09/19 YM DEL
;;;;      '(62 . 2) ; 黄色
;;;;      '(62 . 1) ; 赤色
;      '(62 . 7) ; 白色
;      '(100 . "AcDbCircle")
;      (cons 10 &o) ; 中心点
;      (cons 40 (/ &kei 2))
;      '(210 0.0 0.0 1.0)
;    )
;  )
; ; 01/11/30 YM ADD-S 水栓穴図形作成時に拡張データを付加 Xdata="G_WTHL" (WorkTop HoLeの略)
; (setq #eLast (entlast))
; (if (not (tblsearch "APPID" "G_WTHL")) (regapp "G_WTHL"))
;  (CFSetXData #eLast "G_WTHL"
;   (list 0 0 0)
; )
; ; 01/11/30 YM ADD-E 水栓穴図形作成時に拡張データを付加 Xdata="G_WTHL" (WorkTop HoLeの略)
;
;  #eLast
;);PK_MakeG_WTR
;-- 2011/09/09 A.Satoh Del - E

(princ)