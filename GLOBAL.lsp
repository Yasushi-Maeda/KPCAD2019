;<HOM>*************************************************************************
; <ｸﾞﾛｰﾊﾞﾙ>   : グローバル変数定義
; <処理概要>  :
;*************************************************************************>MOH<

;;;J	NZ class
;;;B*	NZ浮造り 色未定 J
;;;N*	NZ框組 色未定 D,F,K
;;;
;;;C	SA class
;;;M*	木質柄 色未定 D,F,K,W
;;;A*	単色・抽象柄 CA色未定 D,F,K
;;;S*	単色・抽象柄 色未定 D,F,K,W

;;;		      (setq CG_DRSeriCode  "J")  ;扉SERIES記号
;;;		      (setq CG_DRColCode  "N*")  ;扉COLOR記号
;;;		      (setq CG_HIKITE      "D")  ;HIKITE記号

;2009/11 収納拡大
;;;	(setq CG_EP_THICKNESS 0)     ;ｴﾝﾄﾞﾊﾟﾈﾙ厚み初期化
;;;	(setq CG_COUNTER_INFO$$ nil) ;ｶｳﾝﾀｰ配置情報(ｶｳﾝﾀｰ接続に使用)---未使用==>Xdata "G_COUNTER"
;;; CG_LAST ;最終列

;PC_LayoutPlanExec 内でSDA,SDB分岐
;↓
;PD_StartLayout_EXTEND
;↓
;(PDC_ModelLayout_EXTEND) を５回繰り返す

;;;PDC_ModelLayout_EXTEND 内
;ｴﾝﾄﾞﾊﾟﾈﾙの取付け
;【ミラー反転】
;天井ﾌｨﾗｰの作成 (PKW_UpperFiller)

;PKC_LayoutOneParts ｶｳﾝﾀｰ接続(ｶｳﾝﾀｰ配置情報ｾｯﾄ)

;ﾌﾟﾗﾝ挿入
;(defun C:PC_InsertPlan (
;ｶｳﾝﾀｰ接続

;ｶｳﾝﾀｰ接続 2009/12/1 YM ADD 収納拡大
;(JOIN_COUNTER)

;;;SK01      :シリーズ    CG_SeriesCode ==> (nth  1 CG_GLOBAL$)
;;;SK02      :ｷｬﾋﾞﾈｯﾄﾌﾟﾗﾝ
;;;SK03      :ユニット
;;;SK04      :ｷｯﾁﾝ間口
;;;SK05      :形状        CG_W2CODE    ==> (nth  5 CG_GLOBAL$)
;;;SK06      :ﾌﾛｱｷｬﾋﾞﾀｲﾌﾟ
;;;SK07      :奥行き
;;;SK08      :ｿﾌﾄｸﾛｰｽﾞ
;;;SK09      :ｺﾝﾛ位置
;;;SK10      :食洗位置
;;;SK11      :左右勝手    CG_LRCode    ==> (nth 11 CG_GLOBAL$)
;;;SK12      :扉ｼﾘｰｽﾞ
;;;SK13      :扉カラー
;;;SK14      :取手
;;;SK16      :ﾜｰｸﾄｯﾌﾟ材質 CG_WTZaiCode ==> (nth 16 CG_GLOBAL$)
;;;SK17      :シンク      CG_SinkCode  ==> (nth 17 CG_GLOBAL$)
;;;SK18      :水栓穴加工
;;;SK19      :水栓機種
;;;SK20      :ｺﾝﾛ機種
;;;SK21      :コンロ下
;;;SK22      :水栓機種 2穴
;;;SK23      :ﾚﾝｼﾞﾌｰﾄﾞ機種
;;;SK24      :ガス種
;;;SK25      :ｺﾝﾛ種別(ﾒｰｶｰ)
;;;SK31      :ﾜｰｸﾄｯﾌﾟ高さ
;;;SK32      :吊戸高さ
;;;SK40      :水栓仕様
;;;SK42      :食洗機種
;;;SK45      :ｴﾝﾄﾞﾊﾟﾈﾙ
;;;SK46      :天井ﾌｨﾗｰ

;    SD51      :ユニット
;    SD52      :シリーズ
;    SD62      :扉ｼﾘｰｽﾞ
;    SD63      :扉カラー
;    SD64      :取手
;    SD53      :奥行き
;    SD54      :タイプ
;    SD55      :収納間口
;    SD56      :左右勝手
;    SD57      :ｶｳﾝﾀｰ色
;    SD58      :ｿﾌﾄｸﾛｰｽﾞ
;    SD59      :ｱﾙﾐ枠ｶﾞﾗｽ
;    SD71      :ｴﾝﾄﾞﾊﾟﾈﾙ
;    SD72      :天井ﾌｨﾗｰ

;使用しない
;;;  (setq CG_UnitBase  "1") ;ﾌﾛｱ配置ﾌﾗｸﾞ
;;;  (setq CG_UnitUpper "1") ;ｳｫｰﾙ配置ﾌﾗｸﾞ
;;;  (setq CG_UnitTop   "1") ;ﾜｰｸﾄｯﾌﾟ配置ﾌﾗｸﾞ
;;;  (setq CG_FilerCode       (cadr (assoc "SKOP04" &family$$))) ;天井ﾌｨﾗｰ
;;;  (setq CG_SidePanelCode   (cadr (assoc "SKOP05" &family$$))) ;ｻｲﾄﾞﾊﾟﾈﾙ ; 01/07/11 YM

;<取得方法>
;(nth 17 CG_GLOBAL$)     ;(STR)シンク記号

;【主要関数】
;プラン検索
;;;(defun C:SearchPlan (

;プラン検索　ｸﾞﾛｰﾊﾞﾙ変数ｾｯﾄ
;;;(defun PKG_SetFamilyCode (

;プラン検索　下台検索
;;;(defun PFGetCompBase (

;プラン検索　吊戸検索
;;;(defun PFGetCompUpper (

;プラン検索　構成部材配置
;;;(defun PKC_LayoutParts (

;プラン検索　複合構成部材配置
;;;(defun PKC_LayoutBlockParts (

;プラン検索　[複合管理][複合構成]検索
;;;(defun PKGetSQL_HUKU_KANRI (

;プラン検索　ｼﾝｸ配置
;;;(defun PKC_LayoutSink (

;;;  ;// ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝの配置 2009/10/26 YM ADD
;;;	(PKW_GLASS_PARTISYON)

;;;  ;// ｴﾝﾄﾞﾊﾟﾈﾙの取付け
;;;	(KP_PutEndPanel)

;プラン検索　MIRROR反転
;;;(defun PKC_MirrorParts (

;プラン検索　天板自動生成、天井フィラーの作成
;;;(defun PK_StartLayout (

;  ;// 天井ﾌｨﾗｰの作成
;	(PKW_UpperFiller);現在天井ﾌｨﾗｰ="A"のみ

;ｴﾝﾄﾞﾊﾟﾈﾙの取付け
;;;(defun KP_PutEndPanel (

;プラン検索　WT自動生成
;;;(defun PKW_WorkTop (

;;; 水栓を配置する(プラン検索)
;;;(defun PKW_PosWTR_plan (

;プラン検索　WT自動生成 底面設計
;;;(defun PKMakeTeimenPline_I (

;【ﾜｰｸﾄｯﾌﾟ品番確定処理要修正】
;;;(defun KPW_DesideWorkTop3 (

;矢視領域作図
;;;(defun GetMaterialData (

;;; <処理概要>: 配置部材の仕様表情報を設定する
;;;(defun SKB_SetSpecList (

;;; <処理概要>: 仕様表詳細情報を取得する
;;;(defun SKB_GetSpecInfo (

;;; <処理概要>: 図面レイアウト
;;;(defun C:SCFLayout (

;;; <処理概要>: 図面枠のタイトル文字列を獲得する
;;;(defun SCFGetTitleStr

; <処理概要>: レイアウト出力
;;;(defun SCFLayoutDrawBefore (

; <処理概要>: レイアウト図作成  パース図
;;;(defun SCFDrawPersLayout (

;;; <処理概要>: 図面枠のタイトルを作図する
;;;(defun SCFMakeTitleText

;;;  (list
;;;    (cadr (assoc "ART_NAME"             CG_KENMEIINFO$))  ; ★物件名称★ 0
;;;		(cadr (assoc "PLANNING_NO"          CG_KENMEIINFO$))  ; ★プラン番号★1
;;;    (cadr (assoc "VERSION_NO"           CG_KENMEIINFO$))  ; ★追番★     2
;;;		(cadr (assoc "BASE_BRANCH_NAME"     CG_KENMEIINFO$))  ; ★営業所名★  3
;;;    (cadr (assoc "BASE_CHARGE_NAME"     CG_KENMEIINFO$))  ; ★営業担当★ 4
;;;    (cadr (assoc "ADDITION_CHARGE_NAME" CG_KENMEIINFO$))  ; ★見積(積算担当)★5
;;;    (cadr (assoc "VERNO"      #VER$$))                    ; ★バージョン★6
;;;    ""                                                    ; プラン名
;;;    ""                                                    ; 件名コード
;;;		""                                                    ; 取扱店名
;;;		""                                                    ; 図面内記事欄
;;;    ""                                                    ; 系列
;;;    ""                                                    ; 扉
;;;    ""                                                    ; ワークトップ
;;;    ""                                                    ; ワークトップ2(ｶｳﾝﾀｰ)
;;;    ""                                                    ; システム名    未使用
;;;    ""                                                    ; 会社名        未使用
;;;	)


; <処理概要>  : Table.cfgの作成
;;;(defun SCFMakeBlockTable ( →　Skb_SetSpecList　→　SKB_GetSpecInfo　→　SKB_GetSpecList

;新Table.cfg
;;;             #i              ; 1.ソートキー
;;;             #LAST_HIN       ; 2.最終品番
;;;							#WWW            ; 3.巾
;;;							#HHH            ; 4.高さ
;;;							#DDD            ; 5.奥行
;;;							#HINMEI         ; 6.品名
;;;             1               ; 7.個数
;;;             #KAKAKU         ; 8.金額
;;;             "A10"           ; 9.集約ID  天板,ｶｳﾝﾀｰはきめうち"A10"
;;;             (list #hnd)     ;10.図形ハンドル


;;; <処理概要>: レイアウト図作成 仕様表
;;;(defun SCFDrawTableLayout

; <処理概要>: バルーン作図
;;;(defun DrawBaloon (


; <処理概要>  : 展開図の寸法自動生成
;;;(defun SCFDrawDimensionEx (

;矢視領域自動設定
;;;    	(KCFAutoMakeTaimenPlanYashi);P型なら矢視領域自動設定
;;;			;2008/12/22 YM ADD
;;;			(KCFAutoMakeIgataPlanYashi);I型なら矢視領域自動設定
;;;			;2008/12/23 YM ADD
;;;			(KCFAutoMakeDiningPlanYashi);収納I配列なら矢視領域自動設定


;;; <処理概要>: ２点の座標とＰ点リストから寸法線を作図し、文字列を追加する
;;;(defun SCFDrawDimLinAddStr (


;----------------------------------------------------------------------
;ファミリー品番関連
;----------------------------------------------------------------------
;;;(setq CG_SeriesCode       "PI" )   ;SERIES     HB
;;;(setq CG_BrandCode        "NR" )   ;ブランド     NR
;;;(setq CG_UnitCode         "K"  )   ;ユニット     K
;;;(setq CG_W1Code           "255")   ;間口1       180
;;;(setq CG_W2Code           "B"  )   ;間口2        A
;;;(setq CG_Type1Code        "S"  )   ;タイプ1      S
;;;(setq CG_Type2Code        "F"  )   ;タイプ2      F
;;;(setq CG_LRCode           "R"  )   ;LR区分       L
;;;(setq CG_DRSeriCode       "41" )   ;扉SERIES   41
;;;(setq CG_DRColCode        "B"  )   ;扉COLOR     Z
;;;(setq CG_UpCabCode        "M"  )   ;UPキャビ仕様 M
;;;(setq CG_LockCOde         "0"  )   ;ロックコード 0
;;;(setq CG_WTZaiCode        "SB" )   ;WT材質       SE
;;;
;;;(setq CG_CRCode           "A"  )   ;コンロ       1
;;;(setq CG_CRUnderCode      "A"  )   ;コンロ下     1
;;;(setq CG_RangeCode        "A"  )   ;レンジフード 0
(setq CG_KCode "K")                ;工種記号

;;;(setq CG_CeilHeight  2450)         ;天井高さ
;;;(setq CG_UpCabHeight 2350)         ;アッパーキャビ高さ ;2013/10/21 YM DEL
(setq CG_WallUnderOpenBoxHeight 2150);吊戸下OPEN BOX設置高さ
(setq CG_WallUnderOpenBox 200)       ;吊戸下OPEN BOXの場合吊元高さを下げる値

(setq CG_BaseSymCol "GREEN")       ;基準アイテムの色
(setq CG_InfoSymCol "RED")         ;設備の確認色
(setq CG_ConfSymCol "MAGENTA")     ;設備の確認色
(setq CG_WorkTopCol "40")          ;ワークトップ品番確定色

;----------------------------------------------------------------------
;各機器の性格CODE
;----------------------------------------------------------------------
;性格CODE一桁目
(setq CG_SKK_ONE_CAB 1)            ;キャビネット
(setq CG_SKK_ONE_GAS 2)            ;ガスコンロ
(setq CG_SKK_ONE_RNG 3)            ;レンジフード
(setq CG_SKK_ONE_SNK 4)            ;シンク
(setq CG_SKK_ONE_WTR 5)            ;水栓・浄水器
(setq CG_SKK_ONE_SID 6)            ;サイドパネル
(setq CG_SKK_ONE_CNT 7)            ;カウンター天板
(setq CG_SKK_ONE_FIG 8)            ;図のみ
(setq CG_SKK_ONE_ETC 9)            ;その他
(setq CG_SKK_ONE_KUT 9)            ;駆体(寸法作成対象外) 01/05/15 TM ADD

;性格CODE二桁目
(setq CG_SKK_TWO_ETC 0)            ;その他
(setq CG_SKK_TWO_BAS 1)            ;ベース
(setq CG_SKK_TWO_UPP 2)            ;アッパー
(setq CG_SKK_TWO_EYE 3)            ;アイレベル
(setq CG_SKK_TWO_MID 4)            ;ミドル
(setq CG_SKK_TWO_KUT 9)            ;駆体(寸法作成対象外) 01/05/15 TM ADD

;性格CODE三桁目
(setq CG_SKK_THR_ETC 0)            ;その他
(setq CG_SKK_THR_NRM 1)            ;通常キャビネット
(setq CG_SKK_THR_SNK 2)            ;シンクキャビネット
(setq CG_SKK_THR_GAS 3)            ;ガスキャビネット
(setq CG_SKK_THR_TOL 4)            ;トールキャビネット
(setq CG_SKK_THR_CNR 5)            ;コーナーキャビネット
(setq CG_SKK_THR_HUN 6)            ;不燃キャビネット
(setq CG_SKK_THR_DIN 7)            ;ダイニング用
(setq CG_SKK_THR_KUT 9)            ;駆体(寸法作成対象外) 01/05/15 TM ADD
; 01/08/31 YM ADD-S
(setq CG_SKK_INT_SUI 510)            ;水栓・浄水器
(setq CG_SKK_INT_GAS 210)            ;ガスコンロ
(setq CG_SKK_INT_SNK 410)            ;シンク
(setq CG_SKK_INT_RNG 320)            ;レンジフード
(setq CG_SKK_INT_RNG_MT 328)         ;マウント型レンジフード 02/03/27 YM ADD
(setq CG_SKK_INT_SCA 112)            ;シンクキャビ
(setq CG_SKK_INT_GCA 113)            ;コンロキャビ
(setq CG_SKK_INT_CNR 115)            ;コーナーキャビ
(setq CG_SKK_INT_SAK 939)            ;食器洗い乾燥機 HN ADD 02/05/31 HN MOD 02/06/05
(setq CG_SKK_INT_KUT 999)            ;躯体 03/03/29 YM ADD
; 01/08/31 YM ADD-E
;----------------------------------------------------------------------
;Ｐ面領域関連
;----------------------------------------------------------------------
(setq CG_PSINKTYPE 8)  ; Ｐ面シンクタイプ
(setq CG_PSINKCHK  6)  ; Ｐ面干渉チェック

;----------------------------------------------------------------------
;ワークトップ関連
;----------------------------------------------------------------------
(setq CG_WorkLPos nil)                ;ワークＬベースコーナーキャビネットの原点
(setq CG_BASEPT   nil)                ;ワークトップの基点

(setq CG_WT_T 23) ; WTの厚み
(setq CG_BG_H 50) ; BGの高さ
(setq CG_BG_T 20) ; BGの厚み
(setq CG_FG_H 40) ; FGの高さ
(setq CG_FG_T 20) ; FGの厚み
(setq CG_FG_S  7) ; 前垂れシフト量

;; 天井フィラー用グローバル変数
(setq SKW_FILLER_FRONT 46)            ;前部分余白
(setq SKW_FILLER_THICK 20)            ;フィラー厚み

(setq SKW_AUTO_SOLID    "Z_00")       ;自動生成ソリッド描画画層
(setq SKW_TMP_HIDE      "HIDE")       ;非表示用画層 01/05/31 YM ADD
(setq SKW_AUTO_SECTION  "Z_wtbase")   ;自動生成ソリッド作成用断面図形描画画層
(setq SKW_AUTO_LAY_LINE "CONTINUOUS") ;自動生成オブジェクト描画画層の線種
(setq SKW_PANEL_LAYER   "Z_01_01_*")  ;平面入力図の画層名
(setq SKW_OPTION_PARTS  nil)          ;オプション部品名格納グローバル変数
(setq SKW_UPPER_SYMBOL_HEIGHT nil)    ;アッパーキャビネットの高さ格納用グローバル変数

;; ワークトップタイプ
;;;(setq SKW_WK_TYPE_SINK    0)          ;シンク・ガス一体側
;;;(setq SKW_WK_TYPE_GUS     1)          ;ガス側
;;;(setq SKW_WK_TYPE_OPENGUS 2)          ;ガス開口部

(setq SKW_SINK_HOLE_CODE  4)          ;シンク穴領域コード番号
(setq SKW_COOK_HOLE_CODE  5)          ;コンロ穴領域コード番号
(setq SKW_WATER_HOLE_CODE 5)          ;水栓穴領域コード番号
(setq SKW_PMEN_OUT 2)                 ;テスト用外形領域ID
(setq SKW_GROUP_CODE "WtOpt_")        ;グループ化時のヘッダ
(setq SKW_GROUP_NO 0)                 ;グループ化時のインデックス番号

;; 展開図番号位置の配置方向
(setq SKW_DEV_X 1)
(setq SKW_DEV_Y 2)

;; 展開図番号LR区分
(setq SKW_DEV_L 1)
(setq SKW_DEV_R 2)

; 見積り明細時のWT名称
; 01/09/11 YM ADD-S
;;;(setq SKW_WT_NAME "ワークトップ")
(setq SKW_WT_NAME "ﾜｰｸﾄｯﾌﾟ")
; 01/09/11 YM ADD-E

;----------------------------------------------------------------------
;扉面関連
;----------------------------------------------------------------------
(setq SKD_DOOR_CODE        "DR")          ;扉図形デフォルト頭文字
(setq SKD_DOOR_FILE_EXT    ".DWG")        ;扉図形デフォルトファイル拡張子
(setq SKD_DOOR_VIEW_LAYER1 "Q_")          ;扉面デフォルト表示画層文字
(setq SKD_DOOR_VIEW_LAYER2 "_99_")        ;扉面デフォルト表示画層文字
(setq SKD_DOOR_VIEW_LAYER3 "_##")         ;扉面デフォルト表示画層文字

(setq SKD_GROUP_HEAD  "DoorGroup")        ;グループ名先頭文字列
(setq SKD_GROUP_INFO  "DoorGroup")        ;グループ名説明分
(setq SKD_MATCH_LAYER "Q_00_99_##_")      ;デフォルトマッチ画層名
(setq SKD_BREAK_LINE  "N_BREAK@")         ;ブレークライン判別コード
(setq SKD_EXP_APP     "G_DOOR")           ;扉図形用アプリケーションコード
(setq SKD_TEMP_LAYER  "SKD_TEMP_LAYER")   ;伸縮作業用テンポラリ画層名
(setq SKD_TEMP_LAYER_0 "SKD_TEMP_LAYER_0");伸縮作業用テンポラリ画層名(扉開き勝手線用)
(setq SKD_TEMP_LAYER_4 "SKD_TEMP_LAYER_4");伸縮作業用テンポラリ画層名(扉開き勝手線用)
(setq SKD_TEMP_LAYER_6 "SKD_TEMP_LAYER_6");伸縮作業用テンポラリ画層名(扉開き勝手線用)
(setq DOOR_OPEN "DOOR_OPEN")              ;扉開き勝手線(正面)の画層
(setq DOOR_OPEN_04 "DOOR_OPEN_04")        ;扉開き勝手線(背面)の画層
(setq DOOR_OPEN_06 "DOOR_OPEN_06")        ;扉開き勝手線(右側面)の画層

(setq SKD_GROUP_NO 0)                     ;グループ名連番

(setq CG_AutoAlignDoor T)                 ;設備配置関連コマンドにて自動扉貼り付け

;----------------------------------------------------------------------
;サイドパネル関連
;----------------------------------------------------------------------

;02/06/18 YM MOD-S
(setq CG_PanelThk     17.)                ;サイドパネルの厚み ; 02/06/18 YM
;;;(setq CG_PanelThk     20.)                ;サイドパネルの厚み ; 01/08/01 YM
;02/06/18 YM MOD-E

;;;01/08/01YM@(setq CG_PanelThk     19.)                ;サイドパネルの厚み
(setq CG_PANEL_OFFSET 0.0)                ;パネルオフセット 18mm-->0mm
;;;01/12/17YM@MOD(setq CG_PANEL_OFFSET 18.)                ;パネルオフセット

;----------------------------------------------------------------------
;仕様表バルーン関連
;----------------------------------------------------------------------
(setq CG_REF_SIZE   60.)                  ;バルーン円半径
(setq CG_BALOONTYPE 7)                    ;バルーン文字Ｐ点タイプ

;----------------------------------------------------------------------
;基準アイテムなどの矢印及び色定義
;----------------------------------------------------------------------
(setq CG_AXISCOLOR       1)      ;軸の色
(setq CG_AXISARWCOLOR    6)      ;軸矢印の色
(setq CG_AXISARWCOLOR2   4)      ;軸矢印の色
(setq CG_AXISARWLEN    100)      ;軸矢印の先端長さ
(setq CG_AXISARWANG     30)      ;軸矢印の先端長さ
(setq CG_AXISARWRAD     50)      ;軸視点の半径

(setq CG_SAXISCOLOR      4)      ;軸の色
(setq CG_SAXISARWCOLOR   4)      ;軸矢印の色
(setq CG_SAXISARWCOLOR2  4)      ;軸矢印の色
(setq CG_SAXISARWLEN    60)      ;軸矢印の先端長さ
(setq CG_SAXISARWANG    30)      ;軸矢印の先端長さ
(setq CG_SAXISARWRAD    30)      ;軸視点の半径

;--------------------------------------------------------------------------
;各種グローバル設定
;--------------------------------------------------------------------------
(setq CG_LOGDSP     nil)         ;ログを画面表示するか
(setq CG_STRETCH    T)           ;部材伸縮をするか
(setq CG_MKWORKTOP  T)           ;ワークトップ・フィラー生成するか
(setq CG_MKDOOR     T)           ;扉貼付け処理をするか
(setq CG_MKBALOON   T)           ;バルーン文字配置処理をするか
(setq CG_TENKAI     T)           ;展開処理をするか

;-- 2011/10/19 A.Satoh Add - S
(setq CG_PARSU_DWG_STR "立体")  ; パース図面識別文字
(setq CG_DWG_VER_MODEL "2007")  ; 図面保存時のDWGバージョン
(setq CG_DWG_VER_SEKOU "2000")  ; 図面保存時のDWGバージョン
;-- 2011/10/19 A.Satoh Add - E

;--------------------------------------------------------------------------
; シンク位置デフォルト
(setq CG_WSnkOf 65)
;--------------------------------------------------------------------------

;2016/08/30 YM ADD-S
;特注品番
;;;(setq CG_TOKU_HINBAN "ZZ6500")
;;;(setq CG_TOKU_HINBAN "ZZ6500-Dﾄｸﾁｭｳﾌﾞｻﾞｲ(D)")
(setq CG_TOKU_HINBAN      "ZZ6500-D");機器以外
(setq CG_TOKU_HINBAN_PSKC "ZZ6500-D");機器以外 PSKC ;2018/0727 YM ADD
(setq CG_TOKU_HINBAN_PSKD "ZZ6500-E");機器以外 PSKD ;2018/0727 YM ADD
(setq CG_TOKU_HINBAN_LWCT "ZZ6500-E");フレームキッチンの集成カウンター
(setq CG_TOKU_HINBAN_KIKI "ZZ6500-H");機器のみ 2016/10/06 YM ADD
;;;(setq CG_TOKU_HINMEI "特注部材（Ｄ）")
;;;(setq CG_TOKU_HINMEI "ﾄｸﾁｭｳﾌﾞｻﾞｲ(D)")
(setq CG_TOKU_HINMEI "ﾄｸ(D)")
;2016/08/30 YM ADD-E

;2017/07/10 フレームキッチンメッセージ
(setq CG_FK_MSG1 "現在のｼﾘｰｽﾞでこのｺﾏﾝﾄﾞは使用できません.")

(princ)

