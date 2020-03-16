;;; ****************************************************
;;; ** 重要:WT自動生成時の座標位置(変数名の"#"は省略) **
;;; ****************************************************
; BG厚み=p2,p22の距離
; FG厚み=p33,p333の距離
;;; ＜I型＞
;;;                        ptA<--Dｶｯﾄ用
;;;  BASE=p4----------+-----+-+-----+p2   <---BG背面(PMEN2の頂点位置)
;;;  |                |     | |     |
;;;  +p44             | ptAA+ |     +p22  <---BG前面
;;;  |                |     | |     |
;;;  |                | ｷｬﾋﾞ| |     |
;;;  +p333            | ptBB+ |     +p111 <---FG背面
;;;  |                |     | |     |
;;;  +p3              |     | |     +p1   <---PMEN2の頂点位置
;;;  +p33-------------+-----+-+-----+p11  <---FG前面(前垂れｼﾌﾄ量ﾌﾟﾗｽ)
;;;                        ptB<--Dｶｯﾄ用

;;; ＜L型＞            x11  x1            (Dｶｯﾄ位置)
;;; p1+---+-------------*---*------------A--------+p2   <---BG背面(PMEN2の頂点位置)
;;;   |   end1          |   |            |        |
;;;   +   +p11----------|dum|------------AA-------+p22  <---BG前面
;;; end2  |             |   |            |        |
;;;   |   |             |   |            |        | x1,x2 x11,x22はいれ変わるかもしれない
;;;   |   |             |   |            |        |
;;;   |   |     +p444---|---|------------BB-------+p333 <---FG背面
;;;   |   |     |       |   |            |        |
;;;x22*---dum---------- *sp1|            |        |
;;;   |   |     |           |            |        |
;;;   |   |     |       p4+-|- - - - - - | - - - -+p3   <---PMEN2の頂点位置
;;; x2*-------------------- *p44---------B--------+p33  <---FG前面(前垂れｼﾌﾄ量ﾌﾟﾗｽ)
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   A---AA----BB--------|-B(Dｶｯﾄ位置)
;;;   |   |     |           |
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55

;;; ＜U型＞
;;;       end1     x11 x1
;;; p1+(BASE1)-----*---*------------------------+p2   <---BG背面(PMEN2の頂点位置)
;;;   |   |        |   |                        |
;;; end2--+p11-----dum1|------------------------+p22  <---BG前面
;;;   |   |        |   |                        |
;;;   |   |     +p444--|------------------------+p333 <---FG背面
;;;   |   |     |  |   |                        |
;;;x22* - dum2- - -*sp1|             ｼﾝｸ側      | x1,x2 x11,x22はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp1はJｶｯﾄ時の分岐点
;;;   |   |     |      |                        |
;;;   |   |     |    +p4------------------------+p3   <---PMEN2の頂点位置
;;; x2* - - - - - - - -+------------------------+p33  <---FG前面(前垂れｼﾌﾄ量ﾌﾟﾗｽ)
;;;   |   |     |    | |p44
;;;   |   |     |    | |
;;;   |   |ｺﾝﾛ側|    | |
;;;   |   |     |    | |
;;;   |   |     |    | |
;;; x3* - - - - - - - -+p55----------------------+p66  <---FG前面(前垂れｼﾌﾄ量ﾌﾟﾗｽ)
;;;   |   |     |    +p5-------------------------+p6   <---PMEN2の頂点位置
;;;   |   |     |      |                         |
;;;x33* - dum3- - -*sp2|          その他         | x3,x4 x33,x44はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp2はJｶｯﾄ時の分岐点
;;;   |   |     |  |   |                         |
;;;   |   |     +p555--|-------------------------+p666 <---FG背面
;;;   |   |        |   |                         |
;;; end3--+p88-----dum4|-------------------------+p77  <---BG前面
;;;   |   |        |   |                         |
;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG背面(PMEN2の頂点位置)
;;;       end4    x44 x4

;;; <検索用関数一覧>
; WT生成関連
;;;(defun C:PosWKTOP              ワークトップ自動生成（任意配置）
;;;(defun C:MakeWKTOP （任意配置）ワークトップ個別生成 I型のみ対応
;;;(defun PKStartWKTOP            ｸﾞﾛｰﾊﾞﾙ,ｼｽﾃﾑ変数の設定など
;;;(defun PKEndWKTOP              ｸﾞﾛｰﾊﾞﾙ,ｼｽﾃﾑ変数の設定などを戻す
;;;(defun PKCheckBaseCab          entsel図形がﾍﾞｰｽｷｬﾋﾞかﾁｪｯｸ
;;;(defun PKExistWTDel            既存WTがあるかどうか調べる あったら削除するかどうか聞く
;;;(defun PKExistWTDelSmallArea   既存WTがあるかどうか調べる  あったら削除するかどうか聞く
; 隣接ｷｬﾋﾞの検索
;;;(defun SKW_GetLinkBaseCab
;;;(defun SKW_GetLinkUpperCab
;;;(defun SKW_GetLinkCab
;;;(defun SKW_SearchLinkBaseSym
;;;(defun SKW_IsExistPRectCross
; 外形領域取得
;;;(defun PKW_MakeSKOutLine2      キッチンの外形領域を結ぶポリラインを返す
;;;(defun PKW_MakeSKOutLine3      キッチンの外形領域を結ぶポリラインを返す 奥行き違い対応
;;;(defun PKDepDiffDecide         ﾌﾛｱｷｬﾋﾞｼﾝﾎﾞﾙ図形ﾘｽﾄを渡して奥行き違いｷｬﾋﾞの有無を判定
;;;(defun PKDDD_I                 ﾌﾛｱｷｬﾋﾞｼﾝﾎﾞﾙ図形ﾘｽﾄを渡して奥行き違いｷｬﾋﾞの有無を判定 (I型用)
;;;(defun PKDDD_L                 ﾌﾛｱｷｬﾋﾞｼﾝﾎﾞﾙ図形ﾘｽﾄを渡して奥行き違いｷｬﾋﾞの有無を判定 (L型用)
;;;(defun PKDDD_U                 ﾌﾛｱｷｬﾋﾞｼﾝﾎﾞﾙ図形ﾘｽﾄを渡して奥行き違いｷｬﾋﾞの有無を判定 (U型用)
;;;(defun PKGetBaseI4             頂点数4のI型形状外形ﾎﾟﾘﾗｲﾝのｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙを参考にする)
;;;(defun PKGetBaseL6             頂点数6のL型形状外形ﾎﾟﾘﾗｲﾝのｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙをみない)
;;;(defun PKGetBaseU8             頂点数8のU型形状外形ﾎﾟﾘﾗｲﾝのｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙをみない)
; 間口２記号
;;;(defun PKW_SetGlobalFromBaseCab2    間口２記号,左右勝手の判定
;;;(defun PKGetWTInfo                  WT情報を得る
;;;(defun PKGetBASEPT_L                CG_BASEPT1,2 ｺｰﾅｰ基点1,2 を求める

; ﾜｰｸﾄｯﾌﾟの生成
;;;(defun PK_MakeWorktop3              ﾜｰｸﾄｯﾌﾟの生成
; WT断面ダイアログ
;;;(defun PKW_DanmenDlg
; 材質選択ダイアログ
;;;(defun PKW_ZaisituDlg
; WT情報ダイアログ
;;;(defun PKWT_INFO_Dlg
;;;(defun MakeTEIMEN (  &pt$ /  )   点リスト-->底面ﾎﾟﾘﾗｲﾝ図形名を返す
;;;(defun PKSLOWPLCP       点のまわりのﾛｰﾀｲﾌﾟｷｬﾋﾞ外形ﾎﾟﾘﾗｲﾝを検索  品番:KSPX090ABR(or L)-Hも検索

; *** 底面作成 ***
;;;(defun PKMakeWT_BG_FG_Pline   WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成
;;;(defun PKMakeTeimenPline_I
; <L型>
;;;(defun PKMakeTeimenPline_L
;;;(defun PKLcut0  WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成  L型ｶｯﾄなし(ID=0)
;;;(defun PKLcut1                            L型斜めｶｯﾄ(ID=1)
;;;(defun PKLcut2                            L型方向ｶｯﾄ(ID=2)
;;;(defun PKLcut2-1                          L型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ1
;;;(defun PKLcut2-2                          L型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ2
; <U型>
;;;(defun PKMakeTeimenPline_U
;;;(defun PKUcut0   WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 U型ｶｯﾄなし(ID=0) 使用することはない
;;;(defun PKUcut1                            U型斜めｶｯﾄ(ID=1)
;;;(defun PKUcut2                            U型方向ｶｯﾄ(ID=2)
;;;(defun PKGetBG_TEIMEN BG底面ﾎﾟﾘﾗｲﾝ作成
;;;(defun PKGetFG_TEIMEN FG底面ﾎﾟﾘﾗｲﾝ作成
;;;(defun PKUcut2-1                          U型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ1
;;;(defun PKUcut2-2                          U型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ2
;;;(defun PKUcut2-3                          U型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ3
;;;(defun PKUcut2-4                          U型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ4

;;;(defun PKDecideLRCODE       LR勝手をきくﾀﾞｲｱﾛｸﾞを表示
;;;(defun GetBGLEN             BG底面図形--->BG長さ(BG底面辺の長さの最大値)

; "G_BKGD"のｾｯﾄ
;;;(defun PKSetBGXData     拡張ﾃﾞｰﾀ G_BKGDのｾｯﾄ
;;;(defun PKGetBGPrice     BG品番からBG価格を求める
;;;(defun PKMoveTempLayer
;;;(defun PKMKWT           ﾜｰｸﾄｯﾌﾟの生成 Z方向移動
;;;(defun PKMKFG2          ﾌﾛﾝﾄｶﾞｰﾄﾞの生成 Z方向移動
;;;(defun PKMKBG2          ﾊﾞｯｸｶﾞｰﾄﾞの生成 Z方向移動
;;;(defun Make_Region2

; プラン検索
;;;(defun PKW_WorkTop      プラン検索内
;;;(defun PKGetWTInfo_plan
;;;(defun PKW_MakeSKOutLine キッチンの外形領域を結ぶポリラインを返す
;;;(defun SKW_ReGetBasePt   ステップタイプの場合、基準点を再設定する
;;;(defun SKW_ChkStepType   ステップタイプか調べる
;;;(defun PKW_GetLinkBaseCab 指定図形の属するキャビに隣接するﾍﾞｰｽｷｬﾋﾞを取得する
;;;(defun PKW_SLinkBaseSym 指定図形の属するベースキャビに隣接するベースキャビネットを取得する
;;;(defun C:kosu (/ #ss) 同一ﾒﾝﾊﾞｰの図形個数を表示する

;;;<HOM>*************************************************************************
;;; <関数名>    : C:PosWKTOP
;;; <処理概要>  : （任意配置）ワークトップ自動生成 I型,L型,U型対応,Dｶｯﾄ対応
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:PosWKTOP (
  /
  #BASE$ #BASE_NEW$ #CLAYER #DEL #DUM$ #EN #EN$ #ENWT$ #EN_LOW$ #FFLG #HND #HNDB #K #LOOP
  #OUTPL$ #OUTPL_LOW #PT$ #PT$$ #PT_LOW$ #SS_DEL #SYM #THR #WTINFO$ #XD_SYM$ #H
  #WTBASE
#RET_DANSA$ ; 02/09/04 YM ADD
  )

  (StartUndoErr);// コマンドの初期化
  (CFCmdDefBegin 6);00/09/26 SN ADD
  (CFNoSnapReset);00/08/24 SN ADD

	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)


; 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:PosWKTOP ////")
  (CFOutStateLog 1 1 " ")

  ;// ビューを登録 01/07/26 YMA ADD
  (command "_view" "S" "TEMP_WT")

  (setq #hndB (car (CFGetXRecord "BASESYM"))) ; 基準ｱｲﾃﾑ
  (PKStartWKTOP)                              ; ｼｽﾃﾑ変数,ｸﾞﾛｰﾊﾞﾙの設定など
  (MakeTempLayer)                             ; 作業用ﾃﾝﾎﾟﾗﾘ画層の作成
  (setq #clayer (getvar "CLAYER"   ))         ; 現在の画層をキープ
  (command "_layer" "S" SKD_TEMP_LAYER "")    ; 現在画層の変更

  (setq #base$  '())
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #en (car (entsel "\nフロアキャビネットを選択: ")))
    (setq #dum$ (PKCheckBaseCab #en))
    (setq #fflg (car  #dum$))
    (setq #sym  (cadr #dum$))
    (if (= #fflg nil) ; ﾁｪｯｸに引っかからなかった場合
      (progn
        (command "vpoint" "0,0,1")  ; 00/04/17 YM 品番確定で検索する
        (setq #en$ (PKW_GetLinkBaseCab #sym))
        ;;; ダイニング部材を省く
        (foreach #en #en$
          (setq #thr (CFGetSymSKKCode #en 3))
          (setq #xd_SYM$ (CFGetXData #en "G_SYM"))
          ; 01/08/09 YM MOD "117"でも"118"でもない
          (if (and (/= CG_SKK_THR_DIN #thr) ; 3桁目 7でないものを集める
                   (/= 8 #thr)) ; 01/07/30 YM ADD 118除外
;;;           (equal (nth 6 #xd_SYM$) 0 0.01))
            (progn
              (GroupInSolidChgCol2 #en CG_InfoSymCol) ; 色を変える
              (setq #base$ (cons #en #base$))         ; ﾀﾞｲﾆﾝｸﾞ以外のｼﾝﾎﾞﾙ
              ; 01/09/27 YM ADD-S 広角度ｷｬﾋﾞを探す
              (if (and (= #thr CG_SKK_THR_CNR)(= (nth 0 #xd_SYM$) "WIDE-ANG-F-CAB"))
                (setq CG_WIDECAB_EXIST T)
              );_if
              ; 01/09/27 YM ADD-E 広角度ｷｬﾋﾞを探す
            )
          );_if
        )

        (if #base$
          (progn
            (foreach base #base$
              (KPMovePmen2_Z_0 base) ; ｼﾝﾎﾞﾙ位置Zが0でないとき、PMEN2の高さをZ=0にする
            )
            (setq #outpl$ (PKW_MakeSKOutLine3 #base$)) ; ｷｬﾋﾞ除外前の外形領域を求める
          )
          (progn
            (CFAlertMsg "ワークトップを生成するフロアキャビネットがありません。")
            (quit)
          )
        );_if

;;;01/08/27YM@DEL       ; 01/07/04 YM ADD START
;;;01/08/27YM@DEL        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget (car #outpl$))) (entget (car #outpl$))))
;;;01/08/27YM@DEL        (setq #WTBASE (entlast)) ; 残す(段差部も含んだWT外形)
        (setq #pt$ (GetLWPolyLinePt (car #outpl$))) ; 除外前の外形点列
        ; 01/07/03 YM ADD L+I型真ん中段差ﾌﾟﾗﾝ用特殊処理

        ; 外形点列を後でPLINEにしてから"G_WRKT"にｾｯﾄする段差部も含んだ全外形点列
        ; (この時点では前垂れやWT奥行き拡張を含んでいないがあとで考慮する)
        (setq CG_GAIKEI #pt$) ; 01/08/24 YM MOD
        ; 01/07/04 YM ADD END

        ;;; 既存WTがあるかどうか調べる  あったら削除するかどうか聞く
        (PKExistWTDel #pt$)
        (PKW_SetGlobalFromBaseCab2 #base$) ; 間口２記号 CG_W2CODE の判定  ＬＲ区分 (nth 11 CG_GLOBAL$) 決定

        ; 02/06/04 YM MOD 以下メーカーごとに分岐する MOD-S
        (setq #Ret_Dansa$ (KP_DansaHantei #base$)) ; 段差キャビ判定
        (setq #ss_del   (car #Ret_Dansa$))
        (setq #en_LOW$ (cadr #Ret_Dansa$))
        ; 02/06/04 YM MOD 以下メーカーごとに分岐する MOD-E

        ; 02/06/04 YM MOD 以下メーカーごとに分岐する DEL-S
;;;        (setq #ss_del (ssadd))
;;;       ;;; ﾛｰｷｬﾋﾞ部材を自動的に除外(寸法Hを見ている)
;;;        (foreach #en #base$
;;;          (setq #thr (CFGetSymSKKCode #en 3))
;;;          (cond
;;;           ; 02/03/287 YM MOD-S
;;;            ((or (= #thr CG_SKK_THR_GAS)(= #thr CG_SKK_THR_NRM))
;;;              (setq #h (nth 5 (CFGetXData #en "G_SYM")))
;;;              (if (and (> #h 450) (< #h 550)) ; もしﾛｰﾀｲﾌﾟのｷｬﾋﾞﾈｯﾄがあれば段差ﾌﾟﾗﾝ
;;;                (progn ; 段差ｷｬﾋﾞ除外
;;;                  (setq CG_Type2Code "D") ; "F","D"
;;;                  (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ﾛｰﾀｲﾌﾟｷｬﾋﾞﾈｯﾄｼﾝﾎﾞﾙ図形ﾘｽﾄ
;;;                 ;;; 基準ｱｲﾃﾑなら緑
;;;                 (setq #hnd  (cdr (assoc 5 (entget #en))))
;;;                 (if (equal #hnd #hndB)
;;;                   (GroupInSolidChgCol #en CG_BaseSymCol) ; 緑
;;;                   (GroupInSolidChgCol2 #en "BYLAYER") ; 色を戻す
;;;                 );_if
;;;                  (ssadd #en #ss_del) ; 後で除外する
;;;                )
;;;              );_if
;;;            )
;;;           ; 02/03/287 YM MOD-E
;;;
;;;;;;02/03/28YM@MOD            ;ガスキャビネット
;;;;;;02/03/28YM@MOD            ((= #thr CG_SKK_THR_GAS)
;;;;;;02/03/28YM@MOD              (setq #h (nth 5 (CFGetXData #en "G_SYM")))
;;;;;;02/03/28YM@MOD              (if (and (> #h 450) (< #h 550)) ; もしﾛｰﾀｲﾌﾟのｺﾝﾛｷｬﾋﾞﾈｯﾄがあれば段差ﾌﾟﾗﾝ
;;;;;;02/03/28YM@MOD                (progn ; 段差ｷｬﾋﾞ除外
;;;;;;02/03/28YM@MOD                  (setq CG_Type2Code "D") ; "F","D"
;;;;;;02/03/28YM@MOD                  (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ﾛｰﾀｲﾌﾟｷｬﾋﾞﾈｯﾄｼﾝﾎﾞﾙ図形ﾘｽﾄ
;;;;;;02/03/28YM@MOD                  ;;; 基準ｱｲﾃﾑなら緑
;;;;;;02/03/28YM@MOD                  (setq #hnd  (cdr (assoc 5 (entget #en))))
;;;;;;02/03/28YM@MOD                  (if (equal #hnd #hndB)
;;;;;;02/03/28YM@MOD                    (GroupInSolidChgCol #en CG_BaseSymCol) ; 緑
;;;;;;02/03/28YM@MOD                    (GroupInSolidChgCol2 #en "BYLAYER") ; 色を戻す
;;;;;;02/03/28YM@MOD                  );_if
;;;;;;02/03/28YM@MOD                  (ssadd #en #ss_del) ; 後で除外する
;;;;;;02/03/28YM@MOD                )
;;;;;;02/03/28YM@MOD              );_if
;;;;;;02/03/28YM@MOD            )
;;;;;;02/03/28YM@MOD            ;通常キャビネット
;;;;;;02/03/28YM@MOD            ((= #thr CG_SKK_THR_NRM)
;;;;;;02/03/28YM@MOD              (setq #h (fix (nth 5 (CFGetXData #en "G_SYM"))))
;;;;;;02/03/28YM@MOD              (if (and (> #h 650) (< #h 750)) ; もしﾛｰﾀｲﾌﾟの通常ｷｬﾋﾞﾈｯﾄがあれば段差ﾌﾟﾗﾝ
;;;;;;02/03/28YM@MOD                (progn ; 段差ｷｬﾋﾞ除外
;;;;;;02/03/28YM@MOD                  (setq CG_Type2Code "D") ; "F","D"
;;;;;;02/03/28YM@MOD                  (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ﾛｰﾀｲﾌﾟｷｬﾋﾞﾈｯﾄｼﾝﾎﾞﾙ図形ﾘｽﾄ
;;;;;;02/03/28YM@MOD                  ;;; 基準ｱｲﾃﾑなら緑
;;;;;;02/03/28YM@MOD                  (setq #hnd  (cdr (assoc 5 (entget #en))))
;;;;;;02/03/28YM@MOD                  (if (equal #hnd #hndB)
;;;;;;02/03/28YM@MOD                    (GroupInSolidChgCol #en CG_BaseSymCol) ; 緑
;;;;;;02/03/28YM@MOD                    (GroupInSolidChgCol2 #en "BYLAYER") ; 色を戻す
;;;;;;02/03/28YM@MOD                  );_if
;;;;;;02/03/28YM@MOD                  (ssadd #en #ss_del) ; 後で除外する
;;;;;;02/03/28YM@MOD                )
;;;;;;02/03/28YM@MOD              );_if
;;;;;;02/03/28YM@MOD            )
;;;          );_cond
;;;        );_(foreach #en #en$   ;// ﾛｰｷｬﾋﾞ部材を省く
        ; 02/06/04 YM MOD 以下メーカーごとに分岐する DEL-E

;;; 段差部材を省いた.  *** この時点で段差プランかどうか判明した ***

        (command "zoom" "p") ; 視点を元に戻す
        (setq #del T) ; WTを張りたくないｷｬﾋﾞを繰り返し選択
        (setq #del (car (entsel "\n除外するフロアキャビネットを選択: "))) ; Returnを押すまで繰り返す
        (while #del
          (setq #fflg nil)
          (setq #sym (CFSearchGroupSym #del)) ; ｼﾝﾎﾞﾙ図形
          (if (= #sym nil)
            (progn
              (CFAlertMsg "フロアキャビネットではありません。") ; 選ばれるまで繰り返す
              (setq #fflg T)
            )
            (progn ; #sym が nil でない
              (if (or (/= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)  ; ｷｬﾋﾞでない
                      (/= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS)) ; ﾍﾞｰｽでない
                (progn
                  (CFAlertMsg "フロアキャビネットではありません。") ; 選ばれるまで繰り返す
                  (setq #fflg T)
                )
              )
            )
          );_if

          (if (= #fflg nil) ; ﾁｪｯｸに引っかからなかった場合
            (progn
              (setq #sym (CFSearchGroupSym #del))
              ;;; 基準ｱｲﾃﾑなら緑
              (setq #hnd  (cdr (assoc 5 (entget #sym))))
              (if (equal #hnd #hndB)
                (GroupInSolidChgCol #sym CG_BaseSymCol) ; 緑
                (GroupInSolidChgCol2 #sym "BYLAYER") ; 色を戻す
              );_if
              (ssadd #sym #ss_del) ; 後で除外する
            )
          );_if
          (setq #del (car (entsel "\n除外するフロアキャビネットを選択: ")))
        );_while #del

        (setq #base_new$ '())
        (if (and (/= #ss_del nil) (/= (sslength #ss_del) 0))
          (progn
            (setq #base_new$ (ListDel #base$ #ss_del)) ; 除外した後のｼﾝﾎﾞﾙ図形ﾘｽﾄ #base_new$
            (entdel (car #outpl$))
          )
        ) ; ﾘｽﾄ1から選択ｾｯﾄの要素をとる

        (if (and (>= (sslength #ss_del)(length #base$))
                 (= #base_new$ nil))
          (progn
            (CFAlertMsg "ワークトップを生成するフロアキャビネットがありません。")
            (quit)
          )
        );_if

        ;// ベースキャビの外形領域の組み合わせポリラインを求める
        (princ "\nキッチンの構成を確認しています...")

        (if #base_new$ ; nilなら最初の#outpl$を使用する
          (setq #outpl$ (PKW_MakeSKOutLine3 #base_new$)) ; 外形領域を求める.複数の場合あり
          (setq #base_new$ #base$)                       ; 除外した後のｼﾝﾎﾞﾙ図形ﾘｽﾄ #base_new$
        );_if

        ;;; ﾛｰﾀｲﾌﾟｷｬﾋﾞがあれば
        (if #en_LOW$ ; ﾛｰﾀｲﾌﾟｷｬﾋﾞｼﾝﾎﾞﾙ図形名ﾘｽﾄ
          (progn
            (setq #outpl_LOW (car (PKW_MakeSKOutLine2 #en_LOW$))) ; ﾛｰﾀｲﾌﾟｷｬﾋﾞ外形領域を求める
            (setq #pt_LOW$ (GetLWPolyLinePt #outpl_LOW))          ; ﾛｰﾀｲﾌﾟｷｬﾋﾞ外形点列
          )
        );_if

        (setq #k 0)
        (repeat (length #outpl$)
          (setq #pt$$ (append #pt$$ (list (GetLWPolyLinePt (nth #k #outpl$))))) ; 外形点列 (@@@)
          (entdel (nth #k #outpl$))
          (setq #k (1+ #k))
        )
        (setq #loop nil)
      )
    );_if
  );_while

  (setvar "CLAYER" #clayer) ; 元の画層に戻す

  (foreach #en #base$
    ;;; 基準ｱｲﾃﾑなら緑
    (setq #hnd  (cdr (assoc 5 (entget #en))))
    (if (equal #hnd #hndB)
      (GroupInSolidChgCol #en CG_BaseSymCol) ; 緑
      (GroupInSolidChgCol2 #en "BYLAYER")    ; 色を戻す
    );_if
  )

  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart)

;;; WT情報
  (setq #WTInfo$ (PKGetWTInfo #pt$ #pt$$ #base$ #base_new$ #outpl_LOW #en_LOW$))
  ;// ワークトップの生成 U型対応,Dｶｯﾄ対応 Z方向に押し出し
  (setq #enWT$
    (PK_MakeWorktop3
      #WTInfo$  ; (list #WTInfo #retWT_BG_FG$ #SetXd$ #CUT_KIGO$)
      #en_LOW$  ; ﾛｰﾀｲﾌﾟｷｬﾋﾞﾘｽﾄ
      #pt_LOW$  ; ﾛｰﾀｲﾌﾟｷｬﾋﾞ外形点列
    )
  )
;;; ;2011/09/18 YM ADD-S
;;; ;D1050ならばRｴﾝﾄﾞ処理   ★Rｴﾝﾄﾞ側左右が分からないので落ちる★
;;; (if (= 1 (length #enWT$))
;;;   (progn
;;;     (setq #oku$ (nth 4 (car (nth 1 #WTInfo$))));奥行きﾘｽﾄ
;;;     (if (and (equal (car #oku$) 1050.0 0.001)(equal (cadr #oku$) 0.0 0.001))
;;;       ;IPA D1050
;;;       (setq #WT (subKPRendWT (car #enWT$))) ;戻り値=天板図形名
;;;     );_if
;;;   )
;;; );_if
;;; ;2011/09/18 YM ADD-E

;;; ﾛｰﾀｲﾌﾟｷｬﾋﾞ外形ﾎﾟﾘﾗｲﾝを削除
  (if #en_LOW$
    (entdel #outpl_LOW)
  );_if

  (princ "\nワークトップを自動生成しました。")
  ;// ビューを戻す
  (command "_view" "R" "TEMP_WT")

  (setq CG_WorkTop (substr (nth 2 (nth 2 #WTInfo$)) 2 1)) ; 色柄グローバル設定

  ); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
);_if

  (setq *error* nil)
  (PKEndWKTOP)
  (CFCmdDefFinish);00/09/26 SN ADD
  (princ)
);C:PosWKTOP

;;;<HOM>*************************************************************************
;;; <関数名>    : C:MakeWKTOP
;;; <処理概要>  : （任意配置）ワークトップ個別生成 I型のみ対応
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      : 単独or隣接した複数のｷｬﾋﾞを１つずつ選択する
;;;*************************************************************************>MOH<
(defun C:MakeWKTOP (
  /
  #BASE$ #CLAYER #DUM$ #EN #ENWT$ #EN_LOW$ #FFLG #H #HND #HNDB #I #OUTPL$ #OUTPL$$ #PT$ #PT_LOW$ #SYM #SYM_LIS
  #THR #WTINFO$ #XD_SYM$
  )

  ; コマンドの初期化
  (StartUndoErr)
  (CFCmdDefBegin 6);00/09/26 SN ADD
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

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:MakeWKTOP ////")
  (CFOutStateLog 1 1 " ")

  (setq #hndB (car (CFGetXRecord "BASESYM"))) ; 基準ｱｲﾃﾑ
  (PKStartWKTOP)                              ; ｼｽﾃﾑ変数,ｸﾞﾛｰﾊﾞﾙの設定など
  (MakeTempLayer)                             ; 作業用ﾃﾝﾎﾟﾗﾘ画層の作成 05/31 YM ADD
  (setq #clayer (getvar "CLAYER"   ))         ; 現在の画層をキープ
  (command "_layer" "S" SKD_TEMP_LAYER "")    ; 現在画層の変更

;;; ｷｬﾋﾞﾈｯﾄを複数個選択する
  (setq #base$ '())
  (setq #i 0)
  (setq #en T)
  (while #en
    (initget "U")
    (setq #en (entsel "\nフロアキャビネットを選択: "))
    (cond
      ((= #en "U")
        ;;; 基準ｱｲﾃﾑなら緑
        (if (> (length #sym_lis) 0)
          (progn
            (setq #hnd (cdr (assoc 5 (entget (car #sym_lis)))))
            (if (equal #hnd #hndB)
              (GroupInSolidChgCol (car #sym_lis) CG_BaseSymCol) ; 緑
              (GroupInSolidChgCol2 (car #sym_lis) "BYLAYER")    ; 色を戻す
            );_if
           ; リストから直前のものを削除 ;
            (setq #sym_lis (cdr #sym_lis))
          )
        );_if
      )
      ((= #en nil)
        (if (= (length #sym_lis) 0)
          (progn
            (CFAlertErr "フロアキャビネットが選択されていません。")
            (setq #en T)
          )
        );_if
      )
      (T
        (setq #dum$ (PKCheckBaseCab (car #en))) ; ﾌﾛｱｷｬﾋﾞかどうかﾁｪｯｸ
        (setq #fflg (car  #dum$))
        (setq #sym  (cadr #dum$))

        (if #sym
          (progn
            (setq #thr (CFGetSymSKKCode #sym 3))
            (setq #h (fix (nth 5 (CFGetXData #sym "G_SYM"))))
            (if (= #fflg nil) ; ﾁｪｯｸに引っかからなかった場合
              (if #sym
                (if (= (member #sym #sym_lis) nil)
                  (if (= CG_SKK_THR_DIN (CFGetSymSKKCode #sym 3))
                    (if (CFYesNoDialog "ダイニングですがワークトップを生成しますか？")
                      (progn
                        (GroupInSolidChgCol2 #sym CG_InfoSymCol) ; 色を変える
                        (setq #sym_lis (cons #sym #sym_lis))
                        (setq #i (1+ #i))
                      )
                    );_if
                    (progn  ; ﾀﾞｲﾆﾝｸﾞ以外の場合
                      (GroupInSolidChgCol2 #sym CG_InfoSymCol) ; 色を変える
                      (setq #sym_lis (cons #sym #sym_lis))
                      (setq #i (1+ #i))
                    )
                  );_if
                );_if
              );_if
            );_if
          )
        );_if
      );T
    );_cond
  );_while #en

  (setq #base$ #sym_lis)

  ; 01/08/01 YM ADD PMEN2の高度を0にする(Be-Free対応) START
  (if #base$
    (progn
      (foreach base #base$
        (KPMovePmen2_Z_0 base) ; ｼﾝﾎﾞﾙ位置Zが0でないとき、PMEN2の高さをZ=0にする
      )
      (setq #outpl$$ (PKW_MakeSKOutLine3 #base$))  ; 外形領域を求める
    )
  );_if
  ; 01/08/01 YM ADD PMEN2の高度を0にする(Be-Free対応) END

;;;  (setq #outpl$$ (PKW_MakeSKOutLine3 #base$))  ; 外形領域を求める
  (if (= (length #outpl$$) 1)
    (setq #outpl$ (car #outpl$$))
    (progn ; 外形が複数の場合
      (CFAlertErr "個別にワークトップを作成してください。")
      (quit)
    )
  )
  (setq #pt$ (GetLWPolyLinePt #outpl$)) ; 外形点列

  (setq CG_GAIKEI #pt$) ; 01/08/27 YM MOD

  ;;; 既存WTがあるかどうか調べる  あったら削除するかどうか聞く
  (command "vpoint" "0,0,1") ;  "LWPOLYLINE"  画層: "Z_wtbase"

;;; 既存WTがあるかどうか調べる  あったら削除するかどうか聞く
  (PKExistWTDelSmallArea #pt$) ; 引数削除
;;;01/08/27TM@DEL (PKExistWTDelSmallArea #pt$ #base$)

  ; 01/08/27 YM ADD CG_W2CODEのきめうちなくす
  (PKW_SetGlobalFromBaseCab2 #base$) ; 間口２記号 CG_W2CODE の判定  ＬＲ区分 (nth 11 CG_GLOBAL$) 決定

  (command "zoom" "p")

  ; ベースキャビの外形領域の組み合わせポリラインを求める
  (princ "\nキッチンの構成を確認しています...")

  (setvar "CLAYER" #clayer) ; 元の画層に戻す

  (foreach #en #base$
    ;;; 基準ｱｲﾃﾑなら緑
    (setq #hnd  (cdr (assoc 5 (entget #en))))
    (if (equal #hnd #hndB)
      (GroupInSolidChgCol #en CG_BaseSymCol) ; 緑
      (GroupInSolidChgCol2 #en "BYLAYER") ; 色を戻す
    );_if
  )
  ; Ｏスナップ関連システム変数の解除
  (CFNoSnapStart)
;;; WT情報
  (setq #WTInfo$ (PKGetWTInfo #pt$ (list #pt$) #base$ #base$ nil nil))
  (setq #enWT$
    (PK_MakeWorktop3
      #WTInfo$  ; (list #WTInfo #retWT_BG_FG$ #SetXd$ #CUT_KIGO$)
      #en_LOW$  ; ﾛｰﾀｲﾌﾟｷｬﾋﾞﾘｽﾄ
      #pt_LOW$  ; ﾛｰﾀｲﾌﾟｷｬﾋﾞ外形点列
    )
  )

    (princ "\nワークトップを生成しました。")
    (setq CG_WorkTop (substr (nth 2 (nth 2 #WTInfo$)) 2 1)) ; 色柄グローバル設定

  ); 01/06/28 YM ADD ｺﾏﾝﾄﾞの制御 Lipple
);_if

  (setq *error* nil)
  (entdel #outpl$)
  (PKEndWKTOP)
  (CFCmdDefFinish);00/09/26 SN ADD
  (princ)

);C:MakeWKTOP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKStartWKTOP
;;; <処理概要>  : ｸﾞﾛｰﾊﾞﾙ,ｼｽﾃﾑ変数の設定など
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.6 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKStartWKTOP ( / )
  (setq CG_Type2Code "F") ; "F","D"  ﾃﾞﾌｫﾙﾄ=ﾌﾗｯﾄ
  (setq CG_BASEPT1 nil)
  (setq CG_BASEPT2 nil)
  (setq CG_MAG1 nil)
  (setq CG_MAG2 nil)
  (setq CG_MAG3 nil)
  (setq CG_GAIKEI nil)        ; 01/07/04 YM ADD
  (setq CG_WIDECAB_EXIST nil) ; ｺｰﾅｰｷｬﾋﾞに広角度を含んでいる==>T 01/09/27 YM ADD

;;; ｼｽﾃﾑ変数設定
  (setq os (getvar "OSMODE"   ))
  (setq sm (getvar "SNAPMODE" ))
  (setq ot (getvar "ORTHOMODE"))
  (setq uf (getvar "UCSFOLLOW")) ; 05/24 YM ADD UCS変更 viewに影響しない
  (setq el (getvar "ELEVATION"))

  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "UCSFOLLOW" 0)
  (setvar "ELEVATION" 0.0)
  (setvar "pdmode" 34)         ; 06/12 YM
  (setvar "pdsize" 5)
  (princ)
);PKStartWKTOP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKEndWKTOP
;;; <処理概要>  : ｸﾞﾛｰﾊﾞﾙ,ｼｽﾃﾑ変数の設定などを戻す
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.6 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKEndWKTOP ( / )
;;; ｼｽﾃﾑ変数設定を戻す
  (setvar "OSMODE"    os)
  (setvar "SNAPMODE"  sm)
  (setvar "ORTHOMODE" ot)
  (setvar "UCSFOLLOW" uf) ; 05/24 YM ADD UCS変更 viewに影響しない
  (setvar "ELEVATION" el)
  (setvar "pdmode" 0)    ; 06/12 YM

  (setq CG_Type2Code nil) ; "F","D"  ﾃﾞﾌｫﾙﾄ=ﾌﾗｯﾄ
  (setq CG_BASEPT1 nil)
  (setq CG_BASEPT2 nil)
  (setq CG_MAG1 nil)
  (setq CG_MAG2 nil)
  (setq CG_MAG3 nil)
  (setq CG_GAIKEI nil) ; 01/07/04 YM ADD
  (setq CG_WIDECAB_EXIST nil) ; ｺｰﾅｰｷｬﾋﾞに広角度を含んでいる==>T 01/09/27 YM ADD
  (setq os nil sm nil ot nil uf nil el nil)

  (princ)
);PKEndWKTOP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKCheckBaseCab
;;; <処理概要>  : entsel図形がﾍﾞｰｽｷｬﾋﾞかﾁｪｯｸ
;;; <引数>      : entsel図形
;;; <戻り値>    : ダメ==>T OK==>nil
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKCheckBaseCab (
  &en ; entsel図形名
  /
  #FFLG #SYM
  )
  (setq #fflg nil)
  (if (= &en nil)
    (progn
      (CFAlertMsg "フロアキャビネットではありません。") ; 選ばれるまで繰り返す
      (setq #fflg T)
    )
  ;else
    (progn ; &en が nil でない
      (setq #sym (CFSearchGroupSym &en)) ; ｼﾝﾎﾞﾙ図形
      (if (= #sym nil)
        (progn
          (CFAlertMsg "フロアキャビネットではありません。") ; 選ばれるまで繰り返す
          (setq #fflg T)
        )
        (progn ; #sym が nil でない
          (if (= (nth 9 (CFGetXData #sym "G_LSYM")) 118)
            (progn
              (CFAlertMsg "フロアキャビネットではありません。") ; 選ばれるまで繰り返す
              (setq #fflg T)
            )
            (if (or (/= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)  ; ｷｬﾋﾞでない
                    (/= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS)) ; ﾍﾞｰｽでない
                (progn
                  (CFAlertMsg "フロアキャビネットではありません。") ; 選ばれるまで繰り返す
                  (setq #fflg T)
                )
              ;);_if
            );_if
          );_if
        )
      );_if
    )
  );_if
  (list #fflg #sym)
);PKCheckBaseCab

;;;<HOM>*************************************************************************
;;; <関数名>    : PKExistWTDel
;;; <処理概要>  : 既存WTがあるかどうか調べる あったら削除するかどうか聞く
;;; <戻り値>    : (ｺﾝﾛﾘｽﾄ,ｺﾝﾛｷｬﾋﾞﾘｽﾄ)
;;; <作成>      : 2000.6.6 YM
;;; <備考>      : (ｺﾝﾛ複数対応 00/06/27 YM)
;;;*************************************************************************>MOH<
(defun PKExistWTDel (
  &pt$ ; 除外前の外形点列
  /
  #DUM1$ #DUM2$ #DUM3$ #DUM4$ #KK #PTA$ #PTWT$ #SSWT #SS_DUM #WT
  )
  (setq #ptA$ (AddPtList &pt$)) ; 末尾に始点を追加する
  (setq #ssWT (ssget "CP" #ptA$ (list (list -3 (list "G_WRKT"))))) ; 領域内のWT図形

  (if #ssWT
    (if (> (sslength #ssWT) 0)
      (if (CFYesNoDialog "既存のワークトップを削除しますか？")
        (progn
          (setq #kk 0)
          (repeat (sslength #ssWT)
            (setq #WT (ssname #ssWT #kk))
            ;;; WT外形点列を求める
            (setq #ptWT$ (PKGetWT_outPT #WT 1)) ; 01/08/10 YM ADD(引数追加)
            (PKDelWkTopONE (ssname #ssWT #kk)) ; 削除ｺﾏﾝﾄﾞ時ﾌﾗｸﾞ=1(確認ﾒｯｾｰｼﾞを表示) 0:表示なし
            (setq #kk (1+ #kk))
          );_repeat
        )
        (progn
          (CFAlertMsg "ワークトップが既に存在するため自動生成を行いませんでした。")
          (*error*)
        )
      );_if
    );_if
  );_if
  (princ)
);PKExistWTDel

;;;<HOM>*************************************************************************
;;; <関数名>    : PKExistWTDelSmallArea
;;; <処理概要>  : 既存WTがあるかどうか調べる  あったら削除するかどうか聞く
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.8 YM
;;; <備考>      : 領域外形点列4点横幅を狭くして隣接WTを含まないようにする
;;;               外形点列はI形状のみ
;;; <修正>        01/08/27 既存WT削除するかどうかはﾕｰｻﾞｰの判断に委ねる
;;;*************************************************************************>MOH<
(defun PKExistWTDelSmallArea (
  &pt$   ; 除外前の外形点列
;;;01/08/27TM@DEL &base$ ; ｼﾝﾎﾞﾙﾘｽﾄ ; 引数削除
  /
  #BPT #O #P1 #P2 #P3 #P4 #PTA$ #SSWT #KK #PTWT$ #WT
  )
;;;01/08/27TM@DEL ;;; 外形点列左上基点を求める
;;;01/08/27TM@DEL (foreach #sym &base$
;;;01/08/27TM@DEL   (setq #BPT (cdr (assoc 10 (entget #sym))))
;;;01/08/27TM@DEL   (foreach #pt &pt$
;;;01/08/27TM@DEL     (if (< (distance #BPT #pt) 0.01)
;;;01/08/27TM@DEL       (setq #O #pt)
;;;01/08/27TM@DEL     );_if
;;;01/08/27TM@DEL   )
;;;01/08/27TM@DEL )
;;;01/08/27TM@DEL;;; 1+----------+2
;;;01/08/27TM@DEL;;;  |          |
;;;01/08/27TM@DEL;;;  |          |
;;;01/08/27TM@DEL;;; 4+----------+3
;;;01/08/27TM@DEL;;;  (setq #ptA$ (AddPtList &pt$))       ; 末尾に始点を追加する
;;;01/08/27TM@DEL;;; 領域4点横幅を狭くして隣接WTを除く処理
;;;01/08/27TM@DEL (setq #ptA$ (GetPtSeries #O &pt$)) ; 先頭に時計周り
;;;01/08/27TM@DEL (setq #p1 (nth 0 #ptA$))
;;;01/08/27TM@DEL (setq #p2 (nth 1 #ptA$))
;;;01/08/27TM@DEL (setq #p3 (nth 2 #ptA$))
;;;01/08/27TM@DEL (setq #p4 (nth 3 #ptA$))
;;;01/08/27TM@DEL (setq #p1 (polar #p1 (angle #p4 #p3) 30))
;;;01/08/27TM@DEL (setq #p2 (polar #p2 (angle #p3 #p4) 30))
;;;01/08/27TM@DEL (setq #p3 (polar #p3 (angle #p2 #p1) 30))
;;;01/08/27TM@DEL (setq #p4 (polar #p4 (angle #p1 #p2) 30))
;;;01/08/27TM@DEL (setq #ptA$ (list #p1 #p2 #p3 #p4 #p1))
;;;01/08/27TM@DEL  (setq #ssWT (ssget "CP" #ptA$ (list (list -3 (list "G_WRKT"))))); 領域内のWT図形
  (setq #ssWT (ssget "CP" &pt$ (list (list -3 (list "G_WRKT"))))); 領域内のWT図形 ; 01/08/27 YM MOD

  (if #ssWT
    (if (> (sslength #ssWT) 0)
      (if (CFYesNoDialog "既存のワークトップを削除しますか？")
        (progn
          (setq #kk 0)
          (repeat (sslength #ssWT)
            (setq #WT (ssname #ssWT #kk))
            ;;; WT外形点列を求める
            (setq #ptWT$ (PKGetWT_outPT #WT 1)) ; 01/08/10 YM ADD(引数追加)
            (PKDelWkTopONE (ssname #ssWT #kk)) ; 削除ｺﾏﾝﾄﾞ時ﾌﾗｸﾞ=1(確認ﾒｯｾｰｼﾞを表示) 0:表示なし
            (setq #kk (1+ #kk))
          );_repeat
        )
;;;01/08/27TM@DEL        (progn
;;;01/08/27TM@DEL          (CFAlertMsg "ワークトップが既に存在するため自動生成を行いませんでした。")
;;;01/08/27TM@DEL          (*error*)
;;;01/08/27TM@DEL        )
      );_if
    );_if
  );_if

;;;01/03/23YM@  (if #ssWT
;;;01/03/23YM@    (if (> (sslength #ssWT) 0) ; 1つ以上あった場合
;;;01/03/23YM@      (progn
;;;01/03/23YM@        (CFAlertMsg "ワークトップが既に存在します。")
;;;01/03/23YM@        (quit)
;;;01/03/23YM@      )
;;;01/03/23YM@    );_if
;;;01/03/23YM@  );_if

  (princ)
);PKExistWTDelSmallArea

;<HOM>*************************************************************************
; <関数名>    : SKW_GetLinkBaseCab
; <処理概要>  : 指定図形の属するベースキャビに隣接するベースキャビネットを取得する
; <戻り値>    : キャビネット図形(G_LSYM)のリスト
; <作成>      : 1999-10-19
; <備考>      : 再帰により 隣接する基準シンボルを
;                 CG_LinkSym
;               に格納する
;*************************************************************************>MOH<
(defun SKW_GetLinkBaseCab (
    &en       ;(ENAME)任意の図形
  )
  (SKW_GetLinkCab &en CG_SKK_TWO_BAS)
)
;SKW_GetLinkBaseCab

;<HOM>*************************************************************************
; <関数名>    : SKW_GetLinkUpperCab
; <処理概要>  : 指定図形の属するアッパーキャビに隣接するアッパーキャビネットを取得する
; <戻り値>    : キャビネット図形(G_LSYM)のリスト
; <作成>      : 1999-10-19
; <備考>      : 再帰により 隣接する基準シンボルを
;                 CG_LinkSym
;               に格納する
;*************************************************************************>MOH<
(defun SKW_GetLinkUpperCab (
    &en       ;(ENAME)任意の図形
  )
  (SKW_GetLinkCab &en CG_SKK_TWO_UPP)
)
;SKW_GetLinkBaseCab

;<HOM>*************************************************************************
; <関数名>    : SKW_GetLinkCab
; <処理概要>  : 指定図形の属するキャビに隣接するベースキャビネットを取得する
; <戻り値>    : キャビネット図形(G_LSYM)のリスト
; <作成>      : 1999-10-19
; <備考>      : 再帰により 隣接する基準シンボルを
;                 CG_LinkSym
;               に格納する
;*************************************************************************>MOH<
(defun SKW_GetLinkCab (
    &en       ;(ENAME)任意の図形
    &code     ;(INT)ベース、アッパーの性格CODE(CG_SKK_TWO_BAS,CG_SKK_TWO_UPP)
    /
    #enSS$
    #enS1
    #xd$
    #skk$
    #ss #i
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKW_GetLinkCab ////")
  (CFOutStateLog 1 1 " ")

  (setq CG_LinkSym nil)

  ;基準シンボルを検索する
  (setq #enS1 (CFSearchGroupSym &en))

  ;2000/06/13  HT 基準シンボルを検索失敗はエラーメッセージ
  (if #enS1
    (progn
  ;// キャビかどうかの判定
  (if (= &code (CFGetSymSKKCode #enS1 2))
    (progn
      (setq #enSS$ (ssget "X" '((-3 ("G_LSYM")))))
      (setq #i 0)
      (setq #ss (ssadd))                 ; 追加 絞り込み 00/03/10 MOD YM
      (repeat (sslength #enSS$)          ; 00/03/10 ADD YM
        (setq #skk$ (CFGetSymSKKCode (ssname #enSS$ #i) nil))
        ; 00/06/23 SN MOD レンジフードも対象とする。
        (if (and (or (= (car #skk$) CG_SKK_ONE_CAB)(= (car #skk$) CG_SKK_ONE_RNG))(= (cadr #skk$) &code))  ; &code のみﾋﾟｯｸｱｯﾌﾟ
        ;(if (and (= (car #skk$) CG_SKK_ONE_CAB)(= (cadr #skk$) &code))  ; &code のみﾋﾟｯｸｱｯﾌﾟ
          (progn
            (ssadd (ssname #enSS$ #i) #ss) ; ベースキャビネットばかり 性格ｺｰﾄﾞ=11?
          )
        );_if
        (setq #i (1+ #i))
      );_(repeat (sslength #ss)                         ; 00/03/10 ADD YM

      ;// 再帰により隣接するベースキャビを検索する ---> CG_LinkSym に入れる
      (SKW_SearchLinkBaseSym #ss #enS1)

      ;// 隣接するキャビの基準シンボル図形を返す
      CG_LinkSym
    )
    nil
  )
  ) ; progn
  (progn
    ;2000/06/13  HT 基準シンボルを検索失敗はエラーメッセージ
    (princ "\n基準シンボルを検索失敗G_SYM(0)=")
    (princ (nth 5 (CfGetXData &en "G_LSYM")))
    nil
  )
  )
)
;SKW_GetLinkCab

;<HOM>*************************************************************************
; <関数名>    : SKW_SearchLinkBaseSym
; <処理概要>  : 指定図形の属するベースキャビに隣接するベースキャビネットを取得する
; <戻り値>    : なし
; <作成>      : 1999-04-13
; <備考>      : 00/05/08アッパーの場合はZ値なしの2次元点での判定とする(フード対策)
;             :
;*************************************************************************>MOH<
(defun SKW_SearchLinkBaseSym (
  &enSS$     ;(PICKSET)ベースキャビネットのリスト
  &enS1      ;(ENAME)キャビネット１
  /
  #ANG #D #ENS2 #H #I #CODE$
  #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #PT$ #PT0$ #UPPER #W #XD$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKW_SearchLinkBaseSym ////")
  (CFOutStateLog 1 1 " ")

  ; 00/05/08 ADD MH アッパーかどうかのフラグ 00/07/03 ADD ハイミドルの処理
  (if (or (= CG_SKK_TWO_UPP (CFGetSymSKKCode &enS1 2))
      )   ;(wcmatch (nth 5 (CFGetXData &enS1 "G_LSYM")) "KH###PC*"))
   (setq #Upper 'T))

  ; 2000/09/11 HT ハイミドルの処理と同様メラミンワークトップも２次元比較とする START
  (setq #code$ (CFGetSymSKKCode &enS1 nil))
  ; 2006/09/19 HT カウンターとの比較が上手くいかないため全て2次元で判断する。
  (if T
; (if (and (= CG_SKK_ONE_CNT (nth 0 #code$)) (= CG_SKK_TWO_BAS (nth 1 #code$)))
    (progn
    (setq #Upper 'T)
    )
  )
  ; 2000/09/11 HT ハイミドルの処理と同様メラミンワークトップも２次元比較とする END

  (setq #xd$ (CFGetXData &enS1 "G_SYM"))
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #h (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &enS1 "G_LSYM")))
  ;// 矩形領域を求める
  (setq #p1 (cdr (assoc 10 (entget &enS1))))
  ; 00/05/08 ADD MH アッパーなら2次元点に変換(高さ違うフード対策)
  (if #Upper (setq #p1 (list (car #p1) (cadr #p1))))
  (setq #p2 (polar #p1 #ang #w))
  (setq #p3 (polar #p2 (- #ang (dtr 90)) #d))
  (setq #p4 (polar #p1 (- #ang (dtr 90)) #d))
  (setq #pt0$ (list #p1 #p2 #p3 #p4))

  (setq #i 0)
  (repeat (sslength &enSS$)
    (setq #enS2 (ssname &enSS$ #i))
    (setq #xd$ (CFGetXData #enS2 "G_SYM"))
    (setq #w (nth 3 #xd$))
    (setq #d (nth 4 #xd$))
    (setq #h (nth 5 #xd$))
    (setq #ang (nth 2 (CFGetXData #enS2 "G_LSYM")))

    ;// 矩形領域を求める
    (setq #p5 (cdr (assoc 10 (entget #enS2))))
    ; 00/05/08 ADD MH アッパーなら2次元点に変換(高さ違うフード対策)
    (if #Upper (setq #p5 (list (car #p5) (cadr #p5))))
    (setq #p6 (polar #p5 #ang #w))
    (setq #p7 (polar #p6 (- #ang (dtr 90)) #d))
    (setq #p8 (polar #p5 (- #ang (dtr 90)) #d))
    (setq #pt$ (list #p5 #p6 #p7 #p8))

;;; 隣接するかどうかの判断をゆるめる 00/05/10 YM
;;;    (if (or (SKW_IsExistPRectCross    (list #p1 #p2 #p3 #p4)     (list #p5 #p6 #p7 #p8))  ; 従来判定
;;;           (SKW_IsExistPRectCross2CP (list #p1 #p2 #p3 #p4 #p1) (list #p5 #p6 #p7 #p8))  ; 追加判定00/05/10 YM
;;;           (SKW_IsExistPRectCross2CP (list #p5 #p6 #p7 #p8 #p5) (list #p1 #p2 #p3 #p4))) ; 追加判定00/05/10 YM

    (if (SKW_IsExistPRectCross #pt0$ #pt$)  ; 従来判定
      (progn
        (if (= nil (member #enS2 CG_LinkSym))
          (progn
            (setq CG_LinkSym (cons #enS2 CG_LinkSym))
            (SKW_SearchLinkBaseSym &enSS$ #enS2)
          )
        )
      )
    )
    (setq #i (1+ #i))
  );_repeat
)
;SKW_SearchLinkBaseSym

;<HOM>*************************************************************************
; <関数名>    : SKW_IsExistPRectCross
; <処理概要>  : ２つの点リストに同一点があるか調べる
; <戻り値>    :
;           T : ある
;         nil : ない
; <作成>      : 99-10-19
; <備考>      :
;*************************************************************************>MOH<
(defun SKW_IsExistPRectCross (
    &pl1$      ;(LIST) 座標リスト１
    &pl2$      ;(LIST) 座標リスト２
    /
    #i #j #pl1 #pl2 #loop1 #loop2
  )

  (setq #loop1 T)
  (setq #i 0)
  (while (and #loop1 (< #i (length &pl1$)))
    (setq #pl1 (nth #i &pl1$))
    (setq #loop2 T)
    (setq #j 0)
    (while (and #loop2 (< #j (length &pl2$)))
      (setq #pl2 (nth #j &pl2$))
      (if (< (distance #pl1 #pl2) 7.01) ; 許容誤差 7mm
        (progn
          (setq #loop2 nil)
          (setq #loop1 nil)
        )
      );_if
      (setq #j (1+ #j))
    );_while
    (setq #i (1+ #i))
  ) ; while
  (if #loop2
    nil
    T
  )
);SKW_IsExistPRectCross

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_MakeSKOutLine2
;;; <処理概要>  : キッチンの外形領域を結ぶポリラインを返す
;;; <戻り値>    :
;;;       ENAME : キッチンの外形領域ポリライン
;;; <作成>      : 2000.3.27 YM 修正
;;; <備考>      : 交わらない領域が複数できる場合を想定
;;;               除外ｷｬﾋﾞ考慮
;;;
;;; +-------+     +-------+
;;; |       |段差 |       |
;;; |   +---+     +---+   |
;;; |   |             |   |
;;; |   |             |   |
;;; +---+             +---+
;;;
;;; 奥行き違いも考慮
;;;*************************************************************************>MOH<
(defun PKW_MakeSKOutLine2 (
    &BaseSym$
    /
    #sym #qry$ #en #p-en$ #p-en
    #r-pl #r-ss #i #pt #pt$ #spt
    #dist$ #lst$ #lst #loop #p2 #p3
    #r-width #r-depth
    #38 #210 #en$ #xd$ #ang #hand #msg
    #ELM #R-SS0 #RET #RET$ #zu_id
    #skk$ #D_MAX #PMEN2
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_MakeSKOutLine2 ////")
  (CFOutStateLog 1 1 " ")

  ;// ワークトップの外形領域(P面=2)を検索する

  (foreach #sym &BaseSym$
    (setq #pmen2 (PKGetPMEN_NO #sym 2)) ; PMEN2
    (if (= #pmen2 nil)
      (setq #pmen2 (PK_MakePMEN2 #sym)) ; PMEN2 を作成
    );_if
    (setq #lst$ (cons (list #sym #pmen2) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞとPMEN2のリスト
  )

  ;// 求めた外形領域のクローンをREGIONとして作成する
  ;// 外形領域を４点のREGIONに変換する
  (setq #r-ss (ssadd))
  (foreach #lst #lst$
    (setq #sym  (car #lst))  ; ﾍﾞｰｽｷｬﾋﾞ
    (setq #p-en (cadr #lst)) ; PMEN=2,押し出し方向 0,0,1のﾎﾟﾘﾗｲﾝ
    (setq #38  (cdr (assoc 38 (entget #p-en)))) ; #38 高度
    (setq #spt (cdr (assoc 10 (entget #sym )))) ; 親図形挿入基点
    (setq #xd$ (CFGetXData #sym "G_LSYM"))
    (setq #ang (nth 2 #xd$)) ; 回転角度

    ;// コーナーキャビはそのままの外形線
    (cond
      ((= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3)) ; CG_SKK_THR_CNR = 5 コーナーキャビ
        (entmake (cdr (entget #p-en)))
      )
      (T
        (if (= CG_SKK_ONE_RNG (CFGetSeikakuToSKKCode (nth 9 #xd$) 1)) ; CG_SKK_ONE_RNG=3 ﾚﾝｼﾞﾌｰﾄﾞ
          (progn
            (setq #p2 (polar #spt #ang #r-width))
            (setq #p3 (polar #spt (- #ang (dtr 90)) #r-depth))
            (setq #pt (polar #p3 #ang #r-width))
          )
          (progn
            (setq #pt$ (GetLWPolyLinePt #p-en)) ; <--- 通常
            (setq #dist$ nil)
            (foreach #pt #pt$
              (setq #dist$ (cons (list #pt (distance #spt #pt)) #dist$)); ｼﾝﾎﾞﾙ基準点からの距離
            )
            (setq #dist$ (CFListSort #dist$ 1))

            ;// 一番遠い点
            (setq #pt (car (last #dist$))) ; リストの最後の要素を返します。ｼﾝﾎﾞﾙ基準点から一番遠い点

            (setq #p2 (CFGetDropPt #spt (list #pt (polar #pt (- #ang (dtr 90)) 10))))
            (setq #p3 (CFGetDropPt #spt (list #pt (polar #pt #ang 10))))
          )
        )
        (MakeLwPolyLine (list #spt #p2 #pt #p3) 1 0)
;;;    MakeLwPolyLine
;;;    &pt$  ;(LIST)構成座標点ﾘｽﾄ
;;;    &cls  ;(INT) 0=開く/1=閉じる
;;;    &elv  ;(REAL)高度
        (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
      )
    );_(cond

    (command "_region" (entlast) "")
    (ssadd (entlast) #r-ss)
  );_(foreach #lst #lst$

  ;// 作成したREGIONをUNIONで連結したREGIONとする
  (command "_union" #r-ss "") ; 交わらない領域でもＯＫ！

  ;// REGIONを分解し、分解した線分をポリライン化する
  (command "_explode" (entlast))
  (setq #r-ss (ssget "P"))

;;;交わらない領域の場合はregionがばらばらになる           ; 00/03/28 YM ADD
  (if (= "REGION" (cdr (assoc 0 (entget (ssname #r-ss 0)))))
    (progn
      (setq #i 0)
      (setq #ret$ '())
      (repeat (sslength #r-ss)
        (setq #elm (ssname #r-ss #i)) ; 各region
        (command "_explode" #elm); region分解
        (setq #r-ss0 (ssget "P"))
        (command "_pedit" (entlast) "Y" "J" #r-ss0 "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
        (setq #ret (entlast))
        (setq #ret$ (append #ret$ (list #ret))) ; PLINEのﾘｽﾄ
        (setq #i (1+ #i))
      )
      #ret$ ; PLINE 図形名ﾘｽﾄを返す
    )                                                     ; 00/03/28 YM ADD
    (progn ; 今までどおり(通常)
      (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
      (list (entlast)) ; 通常 ;// 外形ポリライン図形名ﾘｽﾄを返す
    )
  );_if

);PKW_MakeSKOutLine2

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_MakeSKOutLine3
;;; <処理概要>  : キッチンの外形領域を結ぶポリラインを返す@@@<奥行き違い対応>@@@
;;; <戻り値>    : ENAME キッチンの外形領域ポリライン
;;; <作成>      : 2000.3.27 YM 修正 00/05/10 YM 修正
;;; <備考>      : 交わらない領域が複数できる場合を想定
;;;               除外ｷｬﾋﾞ考慮
;;;
;;; +-------+     +-------+
;;; |       |段差 |       |
;;; |   +---+     +---+   |
;;; |   |             |   |
;;; |   |             |   |
;;; +---+             +---+
;;;
;;; 奥行き違いも考慮  WT前面でつらが合っている場合
;;;*************************************************************************>MOH<
(defun PKW_MakeSKOutLine3 (
  &BaseSym$
  /
  #38 #ANG #BASE #BASEPT #CORNERD1 #CORNERD2 #DEP_MAXL #DEP_MAXO #DEP_MAXR
  #DUMPT$ #ELM #I #ICOUNT #LST$ #OKU$ #OKU1_DIFF #OKU2_DIFF #OKU3_DIFF
  #P-EN #P1 #P2 #P3 #P4 #P5 #P6 #PFLG #PT$ #R-SS #R-SS0 #RET #RET$ #SPT #SYM #XD$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_MakeSKOutLine3 ////")
  (CFOutStateLog 1 1 " ")

  (setq #oku$ (PKDepDiffDecide &BaseSym$)) ; 戻り値
; ｺｰﾅｰｷｬﾋﾞ個数,ｼﾝｸ側奥行違い(T or nil),奥行き最大,
;              ｺﾝﾛ側奥行違い(T or nil),奥行き最大,(SYM PMEN2)
  (setq #icount    (nth 0 #oku$)) ; ｺｰﾅｰｷｬﾋﾞ個数
  (setq #oku1_diff (nth 1 #oku$)) ; ｼﾝｸ側奥行違い(T or nil)
  (setq #dep_maxL  (nth 2 #oku$)) ; 奥行き最大
  (setq #oku2_diff (nth 3 #oku$)) ; ｺﾝﾛ側奥行違い(T or nil)
  (setq #dep_maxR  (nth 4 #oku$)) ; 奥行き最大
  (setq #oku3_diff (nth 5 #oku$)) ; ｺﾝﾛ側奥行違い(T or nil)
  (setq #dep_maxO  (nth 6 #oku$)) ; 奥行き最大
  (setq #lst$      (nth 7 #oku$)) ; (SYM PMEN2)ﾘｽﾄ

  ;// 求めた外形領域のクローンをREGIONとして作成する
  ;// 外形領域を４点のREGIONに変換する
  (setq #r-ss (ssadd))
  (foreach #lst #lst$
    (setq #sym  (car   #lst)) ; ﾍﾞｰｽｷｬﾋﾞ
    (setq #p-en (cadr  #lst)) ; PMEN=2,押し出し方向 0,0,1のﾎﾟﾘﾗｲﾝ
    (setq #pflg (caddr #lst)) ; 0:位置区別なし 1:ｼﾝｸ側ｷｬﾋﾞ  2:ｺﾝﾛ側ｷｬﾋﾞ  3:その他側ｷｬﾋﾞ
    (setq #38  (cdr (assoc 38 (entget #p-en)))) ; #38 高度
    (setq #spt (cdr (assoc 10 (entget #sym )))) ; 親図形挿入基点
    (setq #xd$ (CFGetXData #sym "G_LSYM"))
    (setq #ang (nth 2 #xd$)) ; 回転角度

    (if (= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3)) ; CG_SKK_THR_CNR = 5 コーナーキャビ
      (progn
        (setq #pt$ (GetLWPolyLinePt #p-en))    ; PMEN2  <--- 通常の場合
        (setq #base (PKGetBaseL6 #pt$))        ; ｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙを見ない)
        (setq #pt$ (GetPtSeries #base #pt$))   ; #base を先頭に時計周り
;;;        (setq #pt$ (GetPtSeries #spt #pt$))    ; #spt を先頭に時計周り
        (setq #p1 (nth 0 #pt$))
        (setq #p2 (nth 1 #pt$))
        (setq #p3 (nth 2 #pt$))
        (setq #p4 (nth 3 #pt$))
        (setq #p5 (nth 4 #pt$))
        (setq #p6 (nth 5 #pt$))

        (setq #cornerD1 (distance #p2 #p3))
        (setq #cornerD2 (distance #p5 #p6))
;;; 1       2
;;; +-------+
;;; |   4   | コーナーキャビの場合
;;; |   +---+
;;; |   |   3
;;; +---+
;;; 6   5

        (if (and (= #pflg 12)(= #icount 2)) ; U型のｺｰﾅｰ2
          (progn
            (cond
              ((and (= #oku2_diff nil)(= #oku3_diff nil))
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; そのまま
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
              )
              ((and (= #oku2_diff T)(= #oku3_diff nil)) ; ｼﾝｸ側のみ奥行き違い L
                (if (> #dep_maxR #cornerD1) ; 奥行き最大値>ｺｰﾅｰｷｬﾋﾞｼﾝｸ側奥行きの場合
                  (progn ; #p1 #p2 書き換え
                    (setq #p2 (polar #p3 (angle #p5 #p4) #dep_maxR))
                    (setq #p1 (CFGetDropPt #p2 (list #p1 #p6)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; そのまま
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
              )
              ((and (= #oku2_diff nil)(= #oku3_diff T)) ; ｺﾝﾛ側のみ奥行き違い
                (if (> #dep_maxO #cornerD2) ; 奥行き最大値>ｺｰﾅｰｷｬﾋﾞｺﾝﾛ側奥行きの場合
                  (progn ; #p1 #p6 書き換え
                    (setq #p6 (polar #p5 (angle #p3 #p4) #dep_maxR))
                    (setq #p1 (CFGetDropPt #p6 (list #p1 #p2)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; そのまま
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
              )
              ((and (= #oku2_diff T)(= #oku3_diff T)) ; ｼﾝｸ側,ｺﾝﾛ側 奥行き違い
                (if (> #dep_maxO #cornerD1) ; 奥行き最大値>ｺｰﾅｰｷｬﾋﾞｼﾝｸ側奥行きの場合
                  (progn ; #p1 #p2 書き換え
                    (setq #p2 (polar #p3 (angle #p5 #p4) #dep_maxO))
                    (setq #p1 (CFGetDropPt #p2 (list #p1 #p6)))
                  )
                );_if
                (if (> #dep_maxO #cornerD2) ; 奥行き最大値>ｺｰﾅｰｷｬﾋﾞｺﾝﾛ側奥行きの場合
                  (progn ; #p1 #p6 書き換え
                    (setq #p6 (polar #p5 (angle #p3 #p4) #dep_maxO))
                    (setq #p1 (CFGetDropPt #p6 (list #p1 #p2)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; そのまま
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
              )
            );_cond
          )
        );_if

        (if (or (= #icount 1)                    ; L型のｺｰﾅｰもしくは
                (and (= #pflg 11)(= #icount 2))) ; U型のｺｰﾅｰ1
          (progn
            (cond
              ((and (= #oku1_diff nil)(= #oku2_diff nil))
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; そのまま
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
              )
              ((and (= #oku1_diff T)(= #oku2_diff nil)) ; ｼﾝｸ側のみ奥行き違い L
                (if (> #dep_maxL #cornerD1) ; 奥行き最大値>ｺｰﾅｰｷｬﾋﾞｼﾝｸ側奥行きの場合
                  (progn ; #p1 #p2 書き換え
                    (setq #p2 (polar #p3 (angle #p5 #p4) #dep_maxL))
                    (setq #p1 (CFGetDropPt #p2 (list #p1 #p6)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; そのまま
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
              )
              ((and (= #oku1_diff nil)(= #oku2_diff T)) ; ｺﾝﾛ側のみ奥行き違い
                (if (> #dep_maxR #cornerD2) ; 奥行き最大値>ｺｰﾅｰｷｬﾋﾞｺﾝﾛ側奥行きの場合
                  (progn ; #p1 #p6 書き換え
                    (setq #p6 (polar #p5 (angle #p3 #p4) #dep_maxR))
                    (setq #p1 (CFGetDropPt #p6 (list #p1 #p2)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; そのまま
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
              )
              ((and (= #oku1_diff T)(= #oku2_diff T)) ; ｼﾝｸ側,ｺﾝﾛ側 奥行き違い
                (if (> #dep_maxL #cornerD1) ; 奥行き最大値>ｺｰﾅｰｷｬﾋﾞｼﾝｸ側奥行きの場合
                  (progn ; #p1 #p2 書き換え
                    (setq #p2 (polar #p3 (angle #p5 #p4) #dep_maxL))
                    (setq #p1 (CFGetDropPt #p2 (list #p1 #p6)))
                  )
                );_if
                (if (> #dep_maxR #cornerD2) ; 奥行き最大値>ｺｰﾅｰｷｬﾋﾞｺﾝﾛ側奥行きの場合
                  (progn ; #p1 #p6 書き換え
                    (setq #p6 (polar #p5 (angle #p3 #p4) #dep_maxR))
                    (setq #p1 (CFGetDropPt #p6 (list #p1 #p2)))
                  )
                );_if
                (MakeLwPolyLine (list #p1 #p2 #p3 #p4 #p5 #p6) 1 0) ; そのまま
                (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
              )
            );_cond
          )
        );_if

      )
;;; else
      (progn ; ｺｰﾅｰｷｬﾋﾞ以外(通常ｷｬﾋﾞ)
;;; spt       p2
;;;  +--------+
;;;  |        |
;;;  |        |
;;;  +--------+
;;; p3        pt

;;; 奥行き違いなしの場合
        (setq #pt$ (GetLWPolyLinePt #p-en))               ; PMEN2  <--- 通常の場合
        (setq #dumpt$ (GetPtSeries #spt #pt$))            ; #BASEPT を先頭に時計周り (00/05/20 YM)
        (if #dumpt$
          (setq #pt$ #dumpt$) ; nil でない
          (progn ; 外形点列上にｼﾝﾎﾞﾙがない場合
            (setq #BASEPT (PKGetBaseI4 #pt$ (list #sym))) ; 点列とｼﾝﾎﾞﾙ基点１つ (00/05/20 YM)
            (setq #pt$ (GetPtSeries #BASEPT #pt$))        ; #BASEPT を先頭に時計周り (00/05/20 YM)
          )
        );_if
        (setq #p1 (nth 0 #pt$))
        (setq #p2 (nth 1 #pt$))
        (setq #p3 (nth 2 #pt$))
        (setq #p4 (nth 3 #pt$))

        (cond
          ((and (or (= #pflg 1)(= #pflg 0))
                (= #oku1_diff T)) ; ｼﾝｸ側奥行き違い
            (setq #p2 (polar #p3 (+ #ang (dtr 90)) #dep_maxL))
            (setq #p1 (polar #p4 (+ #ang (dtr 90)) #dep_maxL))
          )
          ((and (= #pflg 2)(= #oku2_diff T)) ; ｺﾝﾛ側奥行き違い
            (setq #p2 (polar #p3 (+ #ang (dtr 90)) #dep_maxR))
            (setq #p1 (polar #p4 (+ #ang (dtr 90)) #dep_maxR))
          )
          ((and (= #pflg 3)(= #oku3_diff T)) ; その他側奥行き違い
            (setq #p2 (polar #p3 (+ #ang (dtr 90)) #dep_maxO))
            (setq #p1 (polar #p4 (+ #ang (dtr 90)) #dep_maxO))
          )
        );_cond

;;;    MakeLwPolyLine
;;;    &pt$  ;(LIST)構成座標点ﾘｽﾄ
;;;    &cls  ;(INT) 0=開く/1=閉じる
;;;    &elv  ;(REAL)高度

        (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0)
        (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
      )
    );_if

    (command "_region" (entlast) "")
    (ssadd (entlast) #r-ss)
  );_(foreach #lst #lst$

  ;// 作成したREGIONをUNIONで連結したREGIONとする
  (command "_union" #r-ss "") ; 交わらない領域でもＯＫ！

  ;// REGIONを分解し、分解した線分をポリライン化する
  (command "_explode" (entlast))
  (setq #r-ss (ssget "P"))

;;;交わらない領域の場合はregionがばらばらになる
  (if (= "REGION" (cdr (assoc 0 (entget (ssname #r-ss 0)))))
    (progn
      (setq #i 0)
      (setq #ret$ '())
      (repeat (sslength #r-ss)
        (setq #elm (ssname #r-ss #i)) ; 各region
        (command "_explode" #elm); region分解
        (setq #r-ss0 (ssget "P"))
        (command "_pedit" (entlast) "Y" "J" #r-ss0 "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
        (setq #ret (entlast))
        (setq #ret$ (append #ret$ (list #ret))) ; PLINEのﾘｽﾄ
        (setq #i (1+ #i))
      )
      #ret$ ; PLINE 図形名ﾘｽﾄを返す
    )                                                     ; 00/03/28 YM ADD
    (progn ; 今までどおり(通常)
      (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
      (setq #ret$ (list (entlast))) ; 通常 ;// 外形ポリライン図形名ﾘｽﾄを返す
    )
  );_if

  #ret$ ; PLINE 図形名ﾘｽﾄを返す

);PKW_MakeSKOutLine3

;;;<HOM>*************************************************************************
;;; <関数名>    : PKDepDiffDecide
;;; <処理概要>  : ﾌﾛｱｷｬﾋﾞｼﾝﾎﾞﾙ図形ﾘｽﾄを渡して奥行き違いｷｬﾋﾞの有無を判定
;;; <戻り値>    : 奥行き最大,奥行き有無など(詳細は関数の末尾)
;;; <作成>      : 2000.5.10 YM I,L型対応 05/17 U型対応
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKDepDiffDecide (
  &BaseSym$
  /
  #BASE #BASE1 #BASE2
  #CORNER #CORNER1 #CORNER2
  #DEP #DEP_MAXL #DEP_MAXO #DEP_MAXR #DEP_MINL #DEP_MINO #DEP_MINR
  #DUM #ICOUNT #LR #LST$
  #OKU1_DIFF #OKU2_DIFF #OKU3_DIFF
  #PMEN2 #PMEN2-1 #PMEN2-2
  #PT$ #PT1$ #PT2$ #SKK$ #corner$ #ret$
  )

; ｺｰﾅｰｷｬﾋﾞの数をカウント
  (setq #icount 0) ; ｺｰﾅｰｷｬﾋﾞの個数
  (foreach #sym &BaseSym$
    (setq #skk$ (CFGetSymSKKCode #sym nil))
    (if (= (nth 2 #skk$) CG_SKK_THR_CNR)    ; コーナーキャビかどうかの判定
      (progn
        (setq #icount (1+ #icount))
        (setq #corner$ (append #corner$ (list #sym))) ; ｺｰﾅｰｷｬﾋﾞｼﾝﾎﾞﾙ図形名ﾘｽﾄ
      )
    )
  )
; 奥行き違い判定
  (cond
    ((= #icount 0) ; I型の場合
      (setq #ret$ (PKDDD_I &BaseSym$))
    )
    ((= #icount 1) ; L型の場合
      (setq #ret$ (PKDDD_L &BaseSym$ #corner$))
    )
    ((= #icount 2) ; U型の場合
      (setq #ret$ (PKDDD_U &BaseSym$ #corner$))
    )
  );_cond

; ｺｰﾅｰｷｬﾋﾞ個数,ｼﾝｸ側   奥行違い(T or nil),奥行き最大,ｺｰﾅｰｷｬﾋﾞｼﾝｸ側   奥行き,
;              ｺﾝﾛ側   奥行違い(T or nil),奥行き最大,ｺｰﾅｰｷｬﾋﾞｺﾝﾛ側   奥行き,
;              その他側奥行違い(T or nil),奥行き最大,ｺｰﾅｰｷｬﾋﾞその他側奥行き,(SYM PMEN2)
;;; (list #icount #oku1_diff #dep_maxL #oku2_diff #dep_maxR #oku3_diff #dep_maxO #lst$)
  (cons #icount #ret$)
);PKDepDiffDecide

;;;<HOM>*************************************************************************
;;; <関数名>    : PKDDD_I
;;; <処理概要>  : ﾌﾛｱｷｬﾋﾞｼﾝﾎﾞﾙ図形ﾘｽﾄを渡して奥行き違いｷｬﾋﾞの有無を判定 (I型用)
;;; <戻り値>    : 奥行き最大,奥行き有無など(詳細は関数の末尾)
;;; <作成>      : 05/17 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKDDD_I (
  &BaseSym$ ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形
  /
  #BASE #DEP #DEP_MAXL #DEP_MAXO #DEP_MAXR #DEP_MINL #DEP_MINO #DEP_MINR
  #LST$ #OKU1_DIFF #OKU2_DIFF #OKU3_DIFF #PMEN2 #PT$ #BASEPT #DUMPT$
  )
  (setq #dep_maxL -99999)
  (setq #dep_minL  99999)
  (setq #dep_maxR -99999)
  (setq #dep_minR  99999)
  (setq #dep_maxO -99999)
  (setq #dep_minO  99999)

  (setq #oku1_diff nil)
  (setq #oku2_diff nil)
  (setq #oku3_diff nil)
  (setq #lst$ nil)

  (foreach #sym &BaseSym$
    (setq #pmen2 (PKGetPMEN_NO #sym 2))             ; PMEN2
    (if (= #pmen2 nil)
;-- 2011/10/21 A.Satoh Mod - S
;;;;;      (setq #pmen2 (PK_MakePMEN2 #sym))   ; PMEN2 を作成
			(if (/= (nth 9 (CFGetXData #sym "G_LSYM")) 110)
      	(setq #pmen2 (PK_MakePMEN2 #sym))   ; PMEN2 を作成
			)
;-- 2011/10/21 A.Satoh Mod - E
    );_if
;-- 2011/10/21 A.Satoh Add - S
    (if (/= #pmen2 nil)
			(progn
;-- 2011/10/21 A.Satoh Add - E
    (setq #lst$ (cons (list #sym #pmen2 0) #lst$))  ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞのリスト
    (setq #base (cdr (assoc 10 (entget #sym))))     ; ｼﾝﾎﾞﾙ基点
    (setq #pt$  (GetLWPolyLinePt #pmen2))           ; PMEN2 外形領域
    (setq #dumpt$ (GetPtSeries #base #pt$))         ; #base を先頭に時計周り     (00/05/20 YM)
    (if #dumpt$
      (setq #pt$ #dumpt$) ; nil でない
      (progn ; 外形点列上にｼﾝﾎﾞﾙがない場合
        (setq #basePT (PKGetBaseI4 #pt$ (list #sym))) ; PMEN2左上にｼﾝﾎﾞﾙがなくても可 (00/05/20 YM)
        (setq #pt$  (GetPtSeries #basePT #pt$))       ; #base を先頭に時計周り       (00/05/20 YM)
      )
    );_if

    (setq #dep  (distance (nth 1 #pt$)(nth 2 #pt$))); 真の奥行き(寸法Dは駄目)

    (if (<= #dep_maxL #dep)
      (setq #dep_maxL #dep) ; 奥行きの最大値を求める
    );_if
    (if (>= #dep_minL #dep)
      (setq #dep_minL #dep) ; 奥行きの最小値を求める
    );_if
;-- 2011/10/21 A.Satoh Add - S
			)
		)
;-- 2011/10/21 A.Satoh Add - E
  )
  (if (= nil (equal #dep_maxL #dep_minL 0.01))
    (setq #oku1_diff T) ; 奥行き違いあり
  );_if

  (list #oku1_diff #dep_maxL #oku2_diff #dep_maxR #oku3_diff #dep_maxO #lst$)
);PKDDD_I

;;;<HOM>*************************************************************************
;;; <関数名>    : PKDDD_L
;;; <処理概要>  : ﾌﾛｱｷｬﾋﾞｼﾝﾎﾞﾙ図形ﾘｽﾄを渡して奥行き違いｷｬﾋﾞの有無を判定 (L型用)
;;; <戻り値>    : 奥行き最大,奥行き有無など(詳細は関数の末尾)
;;; <作成>      : 05/17 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKDDD_L (
  &BaseSym$ ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形
  &corner$  ; ｺｰﾅｰｷｬﾋﾞﾘｽﾄ
  /
  #BASE #CORNER #CORNER$
  #DEP #DEP1 #DEP2 #DEP_MAXL #DEP_MAXO #DEP_MAXR #DEP_MINL #DEP_MINO #DEP_MINR
  #LR #LST$ #BASEPT #PT0$ #DUMPT$
  #OKU1_DIFF #OKU2_DIFF #OKU3_DIFF #PMEN2 #PT$ #SKK$
  )
  (setq #dep_maxL -99999)
  (setq #dep_minL  99999)
  (setq #dep_maxR -99999)
  (setq #dep_minR  99999)
  (setq #dep_maxO -99999)
  (setq #dep_minO  99999)

  (setq #oku1_diff nil)
  (setq #oku2_diff nil)
  (setq #oku3_diff nil)
  (setq #lst$ nil)
  (setq #corner$ &corner$)

;;; p1からp4へ向かうﾍﾞｸﾄﾙの左側に奥行き違いがあれば#oku1_diff=T
;;; p1からp4へ向かうﾍﾞｸﾄﾙの右側に奥行き違いがあれば#oku2_diff=T
;;;  p1             p2
;;;  +--------------+------------+
;;;  |              |            |
;;;  | ｺｰﾅｰｷｬﾋﾞ     | #oku1_diff |
;;;  |         p4   |            |
;;;  |          +---+------------+
;;;  |          |  p3
;;;p6+----------+p5
;;;  |          |
;;;  |          |
;;;  |#oku2_diff|
;;;  |          |
;;;  +----------+

  (setq #corner (car #corner$)); ｺｰﾅｰｷｬﾋﾞｼﾝﾎﾞﾙ図形
;;; PMEN2 を探す
  (setq #pmen2 (PKGetPMEN_NO #corner 2))            ; PMEN2
  (setq #lst$ (cons (list #corner #pmen2 0) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞのリスト
;;;  (setq #base (cdr (assoc 10 (entget #corner))))    ; ｼﾝﾎﾞﾙ基点
  (setq #pt0$ (GetLWPolyLinePt #pmen2))             ; PMEN2 外形領域
  (setq #base (PKGetBaseL6 #pt0$))                  ; ｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙを見ない)
  (setq #pt0$ (GetPtSeries #base #pt0$))            ; #base を先頭に時計周り

  (setq #dep1 (distance (nth 1 #pt0$) (nth 2 #pt0$)))
  (setq #dep2 (distance (nth 4 #pt0$) (nth 5 #pt0$)))

  (if (<= #dep_maxL #dep1)
    (setq #dep_maxL #dep1) ; ｼﾝｸ側奥行きの最大値を求める
  );_if
  (if (>= #dep_minL #dep1)
    (setq #dep_minL #dep1) ; ｼﾝｸ側奥行きの最小値を求める
  );_if

  (if (<= #dep_maxR #dep2)
    (setq #dep_maxR #dep2) ; ｺﾝﾛ側奥行きの最大値を求める
  );_if
  (if (>= #dep_minR #dep2)
    (setq #dep_minR #dep2) ; ｺﾝﾛ側奥行きの最小値を求める
  );_if

  (foreach #sym &BaseSym$
    (setq #skk$ (CFGetSymSKKCode #sym nil))
    (if (/= (nth 2 #skk$) CG_SKK_THR_CNR)               ; ｺｰﾅｰｷｬﾋﾞかどうかの判定
      (progn ; ｺｰﾅｰｷｬﾋﾞでない
        (setq #pmen2 (PKGetPMEN_NO #sym 2))             ; PMEN2
        (if (= #pmen2 nil)
;-- 2011/10/21 A.Satoh Mod - S
;;;;;          (setq #pmen2 (PK_MakePMEN2 #sym))             ; PMEN2 を作成
					(if (/= (nth 9 (CFGetXData #sym "G_LSYM")) 110)
      			(setq #pmen2 (PK_MakePMEN2 #sym))   ; PMEN2 を作成
					)
;-- 2011/10/21 A.Satoh Mod - E
        );_if
;-- 2011/10/21 A.Satoh Add - S
		    (if (/= #pmen2 nil)
					(progn
;-- 2011/10/21 A.Satoh Add - E
        (setq #base (cdr (assoc 10 (entget #sym))))     ; ｼﾝﾎﾞﾙ基点
        (setq #pt$ (GetLWPolyLinePt #pmen2))            ; PMEN2 外形領域
        (setq #dumpt$ (GetPtSeries #base #pt$))         ; #basePT を先頭に時計周り (00/05/20 YM)
        (if #dumpt$
          (setq #pt$ #dumpt$) ; nil でない
          (progn ; 外形点列上にｼﾝﾎﾞﾙがない場合
            (setq #BASEPT (PKGetBaseI4 #pt$ (list #sym))) ; 点列とｼﾝﾎﾞﾙ基点１つ      (00/05/20 YM)
            (setq #pt$ (GetPtSeries #BASEPT #pt$))        ; #basePT を先頭に時計周り (00/05/20 YM)
          )
        );_if

        (setq #dep (distance (nth 1 #pt$)(nth 2 #pt$))) ; 真の奥行き(寸法Dは駄目)

        (setq #lr (CFArea_rl (nth 0 #pt0$) (nth 3 #pt0$) #base))
        (if (= #lr -1)
          (progn ; 右側であった場合
            (setq #lst$ (cons (list #sym #pmen2 2) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞ(ｺﾝﾛ側=2)のリスト
            (if (<= #dep_maxR #dep)
              (setq #dep_maxR #dep) ; ｺﾝﾛ側奥行きの最大値を求める
            );_if
            (if (>= #dep_minR #dep)
              (setq #dep_minR #dep) ; ｺﾝﾛ側奥行きの最小値を求める
            );_if
          )
          (progn ; 左側であった場合
            (setq #lst$ (cons (list #sym #pmen2 1) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞ(ｼﾝｸ側=1)のリスト
            (if (<= #dep_maxL #dep)
              (setq #dep_maxL #dep) ; ｼﾝｸ側奥行きの最大値を求める
            );_if
            (if (>= #dep_minL #dep)
              (setq #dep_minL #dep) ; ｼﾝｸ側奥行きの最小値を求める
            );_if
          )
        );_if
;-- 2011/10/21 A.Satoh Add - S
					)
				)
;-- 2011/10/21 A.Satoh Add - E
      )
    );_if
  )
  (if (= nil (equal #dep_maxL #dep_minL 0.01))
    (setq #oku1_diff T) ; 奥行き違いあり
  );_if
  (if (= nil (equal #dep_maxR #dep_minR 0.01))
    (setq #oku2_diff T) ; 奥行き違いあり
  );_if

  (list #oku1_diff #dep_maxL #oku2_diff #dep_maxR #oku3_diff #dep_maxO #lst$)
);PKDDD_L

;;;<HOM>*************************************************************************
;;; <関数名>    : PKDDD_U
;;; <処理概要>  : ﾌﾛｱｷｬﾋﾞｼﾝﾎﾞﾙ図形ﾘｽﾄを渡して奥行き違いｷｬﾋﾞの有無を判定 (U型用)
;;; <戻り値>    : 奥行き最大,奥行き有無など(詳細は関数の末尾)
;;; <作成>      : 05/17 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKDDD_U (
  &BaseSym$ ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形
  &corner$  ; ｺｰﾅｰｷｬﾋﾞﾘｽﾄ
  /
  #BASE #BASEPT #BASE1 #BASE2 #CORNER$ #CORNER1 #CORNER2
  #DEP #DEP1 #DEP2 #DEP3 #DEP4 #DEP_MAXL #DEP_MAXO #DEP_MAXR #DEP_MINL
  #DEP_MINO #DEP_MINR #DUMPT$
  #DUM #LR #LR2 #LST$ #OKU1_DIFF #OKU2_DIFF #OKU3_DIFF
  #PMEN2 #PMEN2-1 #PMEN2-2 #PT$ #PT1$ #PT2$ #SKK$ PKDDD_U
  )
  (setq #dep_maxL -99999)
  (setq #dep_minL  99999)
  (setq #dep_maxR -99999)
  (setq #dep_minR  99999)
  (setq #dep_maxO -99999)
  (setq #dep_minO  99999)

  (setq #oku1_diff nil)
  (setq #oku2_diff nil)
  (setq #oku3_diff nil)
  (setq #lst$ nil)
  (setq #corner$ &corner$)

;;; p1からp4へ向かうﾍﾞｸﾄﾙのどちら側にｺｰﾅｰｷｬﾋﾞ2があるか

;;;  p1
;;;  +--------------+------------+
;;;  |              |            |
;;;  | ｺｰﾅｰｷｬﾋﾞ1    | #oku1_diff |
;;;  |              |            |
;;;  |          +---+------------+
;;;  |          |p4
;;;  +----------+
;;;  |          |
;;;  |#oku2_diff|
;;;  |          |
;;;  +----------+
;;;  |          |
;;;  |          +---+------------+
;;;  |              |            |
;;;  | ｺｰﾅｰｷｬﾋﾞ2    | #oku3_diff |
;;;  |              |            |
;;;  +--------------+------------+

  (setq #corner1 (car  #corner$)); ｺｰﾅｰｷｬﾋﾞｼﾝﾎﾞﾙ図形1(仮)
  (setq #base1 (cdr (assoc 10 (entget #corner1))))    ; ｼﾝﾎﾞﾙ基点1
  (setq #pmen2-1 (PKGetPMEN_NO #corner1 2))           ; PMEN2(ｺｰﾅｰ1)
  (setq #pt1$ (GetLWPolyLinePt #pmen2-1))             ; PMEN2 外形領域(ｺｰﾅｰ1)
  (setq #pt1$ (GetPtSeries #base1 #pt1$))             ; #base を先頭に時計周り(ｺｰﾅｰ1)

  (setq #corner2 (cadr #corner$)); ｺｰﾅｰｷｬﾋﾞｼﾝﾎﾞﾙ図形2(仮)
  (setq #base2 (cdr (assoc 10 (entget #corner2))))    ; ｼﾝﾎﾞﾙ基点2
  (setq #pmen2-2 (PKGetPMEN_NO #corner2 2))           ; PMEN2(ｺｰﾅｰ2)
  (setq #pt2$ (GetLWPolyLinePt #pmen2-2))             ; PMEN2 外形領域(ｺｰﾅｰ2)
  (setq #pt2$ (GetPtSeries #base2 #pt2$))             ; #base を先頭に時計周り(ｺｰﾅｰ2)

  (setq #lr (CFArea_rl (nth 0 #pt1$) (nth 3 #pt1$) #base2)) ; ｺｰﾅｰ2が、ｺｰﾅｰ1対角線のどちらか判断

  (if (= #lr 1)
    (progn ; 左側であった場合、ｺｰﾅｰｷｬﾋﾞ1(仮)が実はｺｰﾅｰｷｬﾋﾞ2だったので外形点列を入れ替え
      (setq #dum #pt1$)
      (setq #pt1$ #pt2$)
      (setq #pt2$ #dum)
      (setq #lst$ (cons (list #corner1 #pmen2-1 12) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞのリスト
      (setq #lst$ (cons (list #corner2 #pmen2-2 11) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞのリスト
    )
    (progn
      (setq #lst$ (cons (list #corner1 #pmen2-1 11) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞのリスト
      (setq #lst$ (cons (list #corner2 #pmen2-2 12) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞのリスト
    )
  );_if

  (setq #dep1 (distance (nth 1 #pt1$) (nth 2 #pt1$))) ; ｺｰﾅｰ1ｼﾝｸ側奥行き
  (setq #dep2 (distance (nth 4 #pt1$) (nth 5 #pt1$))) ; ｺｰﾅｰ1ｺﾝﾛ側奥行き
  (setq #dep3 (distance (nth 1 #pt2$) (nth 2 #pt2$))) ; ｺｰﾅｰ2ｺﾝﾛ側奥行き
  (setq #dep4 (distance (nth 4 #pt2$) (nth 5 #pt2$))) ; ｺｰﾅｰ2その他側奥行き

  (if (<= #dep_maxL #dep1)
    (setq #dep_maxL #dep1) ; ｼﾝｸ側奥行きの最大値を求める
  );_if
  (if (>= #dep_minL #dep1)
    (setq #dep_minL #dep1) ; ｼﾝｸ側奥行きの最小値を求める
  );_if

  (if (<= #dep_maxR #dep2)
    (setq #dep_maxR #dep2) ; ｺﾝﾛ側奥行きの最大値を求める
  );_if
  (if (>= #dep_minR #dep2)
    (setq #dep_minR #dep2) ; ｺﾝﾛ側奥行きの最小値を求める
  );_if

  (if (<= #dep_maxR #dep3)
    (setq #dep_maxR #dep3) ; ｺﾝﾛ側奥行きの最大値を求める
  );_if
  (if (>= #dep_minR #dep3)
    (setq #dep_minR #dep3) ; ｺﾝﾛ側奥行きの最小値を求める
  );_if

  (if (<= #dep_maxO #dep4)
    (setq #dep_maxO #dep4) ; その他側奥行きの最大値を求める
  );_if
  (if (>= #dep_minO #dep4)
    (setq #dep_minO #dep4) ; その他側奥行きの最小値を求める
  );_if

  (foreach #sym &BaseSym$
    (setq #skk$ (CFGetSymSKKCode #sym nil))
    (if (/= (nth 2 #skk$) CG_SKK_THR_CNR)               ; ｺｰﾅｰｷｬﾋﾞかどうかの判定
      (progn ; ｺｰﾅｰｷｬﾋﾞでない
        (setq #pmen2 (PKGetPMEN_NO #sym 2))             ; 各PMEN2(ｺｰﾅｰｷｬﾋﾞ以外)
        (if (= #pmen2 nil)
;-- 2011/10/21 A.Satoh Mod - S
;;;;;          (setq #pmen2 (PK_MakePMEN2 #sym))   ; PMEN2 を作成
					(if (/= (nth 9 (CFGetXData #sym "G_LSYM")) 110)
      			(setq #pmen2 (PK_MakePMEN2 #sym))   ; PMEN2 を作成
					)
;-- 2011/10/21 A.Satoh Mod - E
        );_if
;-- 2011/10/21 A.Satoh Add - S
		    (if (/= #pmen2 nil)
					(progn
;-- 2011/10/21 A.Satoh Add - E
        (setq #base (cdr (assoc 10 (entget #sym))))     ; ｼﾝﾎﾞﾙ基点
        (setq #pt$ (GetLWPolyLinePt #pmen2))            ; PMEN2 外形領域
        (setq #dumpt$ (GetPtSeries #base #pt$))         ; #base を先頭に時計周り
        (if #dumpt$
          (setq #pt$ #dumpt$) ; nil でない
          (progn ; 外形点列上にｼﾝﾎﾞﾙがない場合
            (setq #BASEPT (PKGetBaseI4 #pt$ (list #sym))) ; 点列とｼﾝﾎﾞﾙ基点１つ    (00/05/20 YM)
            (setq #pt$ (GetPtSeries #BASEPT #pt$))        ; #base を先頭に時計周り (00/05/20 YM)
          )
        );_if

        (setq #dep (distance (nth 1 #pt$)(nth 2 #pt$))) ; 真の奥行き(寸法Dは駄目)

        (setq #lr (CFArea_rl (nth 3 #pt1$) (nth 2 #pt1$) #base))
        (if (= #lr 1) ; 左
          (progn ; 左側であった場合 ｼﾝｸ側にあるｷｬﾋﾞである
            (setq #lst$ (cons (list #sym #pmen2 1) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞ(ｼﾝｸ側=1)のリスト
            (if (<= #dep_maxL #dep)
              (setq #dep_maxL #dep) ; ｼﾝｸ側奥行きの最大値を求める
            );_if
            (if (>= #dep_minL #dep)
              (setq #dep_minL #dep) ; ｼﾝｸ側奥行きの最小値を求める
            );_if
          )
          (progn ; それ以外
            (setq #lr (CFArea_rl (nth 3 #pt2$) (nth 4 #pt2$) #base)) ; ｺｰﾅｰｷｬﾋﾞ2で判断
            (if (= #lr -1) ; 右
              (progn ; 右側であった場合 その他側にあるｷｬﾋﾞである
                (setq #lst$ (cons (list #sym #pmen2 3) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞ(その他側=3)のリスト
                (if (<= #dep_maxO #dep)
                  (setq #dep_maxO #dep) ; その他側奥行きの最大値を求める
                );_if
                (if (>= #dep_minO #dep)
                  (setq #dep_minO #dep) ; その他側奥行きの最小値を求める
                );_if
              )
              (progn ; それ以外 ｺﾝﾛ側ｷｬﾋﾞである
                (setq #lst$ (cons (list #sym #pmen2 2) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞ,PMEN2,側ﾌﾗｸﾞ(ｺﾝﾛ側=2)のリスト
                (if (<= #dep_maxR #dep)
                  (setq #dep_maxR #dep) ; ｺﾝﾛ側奥行きの最大値を求める
                );_if
                (if (>= #dep_minR #dep)
                  (setq #dep_minR #dep) ; ｺﾝﾛ側奥行きの最小値を求める
                );_if
              )
            );_if

          )
        );_if
;-- 2011/10/21 A.Satoh Add - S
					)
				)
;-- 2011/10/21 A.Satoh Add - E
      )
    );_if
  )
  (if (= nil (equal #dep_maxL #dep_minL 0.01))
    (setq #oku1_diff T) ; 奥行き違いあり
  );_if
  (if (= nil (equal #dep_maxR #dep_minR 0.01))
    (setq #oku2_diff T) ; 奥行き違いあり
  );_if
  (if (= nil (equal #dep_maxO #dep_minO 0.01))
    (setq #oku3_diff T) ; 奥行き違いあり
  );_if

  (list #oku1_diff #dep_maxL #oku2_diff #dep_maxR #oku3_diff #dep_maxO #lst$)
);PKDDD_U

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetBaseI4
;;; <処理概要>  : 頂点数4のI型形状外形ﾎﾟﾘﾗｲﾝのｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙ図形ﾘｽﾄも渡す)
;;; <戻り値>    : ｺｰﾅｰ基点座標
;;; <作成>      : 2000.5.19 YM
;;; <備考>      :
;;;               部材挿入角度はみない(ﾗｼﾞｱﾝで2*PIを超えたりﾏｲﾅｽや0.0付近の角度の処理がめんどう)
;;;
;;; 求めるｺｰﾅｰ
;;;  *----@-----@----+
;;;  |    |     |    | 奥行き違いＷＴ(@はｼﾝﾎﾞﾙ基準点)
;;;  @----+     |    @----+
;;;  |    |     |    |    |
;;;  |    |     |    |    |
;;;  +----+-----+----+----+
;;;
;;; (car #vect1)*------>*(cadr #vect1) ｷｬﾋﾞﾈｯﾄ配置角度の方向ﾍﾞｸﾄﾙ
;;;
;;; (car #vect2)*------>*(cadr #vect2)
;;;*************************************************************************>MOH<
(defun PKGetBaseI4 (
  &pt$   ; 外形点列
  &Base$ ; ｼﾝﾎﾞﾙ基準点ﾘｽﾄ
  /
  #ANG #BASE #BASEPT #BASEX #BASEXY #DIST #I #LST$ #LST$$ #SYM #X1 #Y1
  )
  (setq #lst$$ '())
;;; ﾘｽﾄの最初のｼﾝﾎﾞﾙを原点(0,0)とする
  (setq #basePT (cdr (assoc 10 (entget (car &Base$)))))
  (setq #ang (nth 2 (CFGetXData (car &Base$) "G_LSYM"))) ; 配置角度
  (setq #x1 (polar #basePT #ang 1000))
  (setq #y1 (polar #basePT (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #basePT #x1 #y1)
;;; ｼﾝﾎﾞﾙｘ座標のﾘｽﾄを求める
  (setq #i 0)
  (foreach #sym &Base$
    (setq #baseXY (cdr (assoc 10 (entget #sym)))) ; ｼﾝﾎﾞﾙのx座標
    (setq #baseX (car (trans #baseXY 0 1)))       ; ﾕｰｻﾞｰ座標系に変換
    (setq #lst$ (list #baseX #sym))
    (setq #lst$$ (append #lst$$ (list #lst$)))
    (setq #i (1+ #i))
  )
  (command "._ucs" "P")
  (setq #lst$$ (CFListSort #lst$$ 0)) ; (nth 0 が小さいもの順にｿｰﾄ
;;; 一番左のｼﾝﾎﾞﾙ
  (setq #sym (cadr (car #lst$$)))
  (setq #baseXY (cdr (assoc 10 (entget #sym))))
;;; 外形点列とｼﾝﾎﾞﾙの距離のﾘｽﾄを求める
  (setq #i 0)
  (setq #lst$$ '())
  (foreach #pt &pt$
    (setq #dist (distance #pt #baseXY))
    (setq #lst$ (list #dist #pt))
    (setq #lst$$ (append #lst$$ (list #lst$)))
    (setq #i (1+ #i))
  )
  (setq #lst$$ (CFListSort #lst$$ 0)) ; (nth 0 が小さいもの順にｿｰﾄ
  (setq #base (cadr (car #lst$$)))
  #base ; I型ｺｰﾅｰ基点
);PKGetBaseI4

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetBaseL6
;;; <処理概要>  : 頂点数6のL型形状外形ﾎﾟﾘﾗｲﾝのｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙをみない)
;;; <戻り値>    : point
;;; <作成>      : 2000.5.15 YM
;;; <備考>      :
;;;
;;; ｺｰﾅｰ
;;;  *-------------+
;;;  |             |
;;;  |    +--------+
;;;  |    |
;;;  |    |
;;;  +----+
;;;
;;; a*------>*b
;;;
;;;          *c : #aから#bへ向かうベクトルの右
;;; <説明>
;;; 連続する3点から、左右のどちらに曲がっているかをみる
;;; 時計周りに見ていった場合、内側コーナーのみ左曲がりとなる。
;;; そこから3つ目の点が求めるコーナー基点
;;;*************************************************************************>MOH<
(defun PKGetBaseL6 (
  &pt0$ ; 外形点列
  /
  #A #B #C #FLG #FLG$ #I #PT$ #BASE #NO$ #SUM X #MSG
  )
;;;  (setq #pt0$ (GetLWPolyLinePt &OutPline)) ; 外形点列
  (setq #pt$ (append &pt0$ &pt0$))
  (if (= (length #pt$) 12)
    (progn
      (setq #i 1)
      (setq #flg$ '())
      ;;; #cが#aから#bへ向かうベクトルの右か左か
      (repeat 10
        (setq #a (nth (1- #i) #pt$)) ; 前の点
        (setq #b (nth #i      #pt$)) ; 現在の点
        (setq #c (nth (1+ #i) #pt$)) ; 次の点
        (setq #flg (CFArea_rl #a #b #c)) ; -1:右 , 1:左
        (setq #flg$ (append #flg$ (list #flg)))
        (setq #i (1+ #i))
      )
    )
    (progn
      (setq #msg "外形領域ﾎﾟﾘﾗｲﾝの頂点の数が６ではありません。")
      (if (= CG_AUTOMODE 2) ; 02/09/04 YM ADD
        (WebOutLog #msg)    ; 02/09/04 YM ADD
        (CFAlertMsg #msg)
      )
    )
  );_if

  (setq #sum 0)
  (foreach #flg #flg$  ; ﾘｽﾄの和
    (setq #sum (+ #sum #flg))
  )

  (if (< #sum 0)
    (setq #flg$ (mapcar '(lambda (x) (* x -1)) #flg$)) ; 時計回りなら
  );_if

  (setq #i 0)
  (foreach #flg #flg$
    (if (= #flg -1)
      (setq #no$ (append #no$ (list #i))) ; -1が何番目か
    )
    (setq #i (1+ #i))
  )

  (if (> (- (car #no$) 2) 0)
    (setq #base (nth (- (car  #no$) 2) #pt$))
    (setq #base (nth (- (cadr #no$) 2) #pt$))
  );_if
  #base ; L型ｺｰﾅｰ基点
);PKGetBaseL6

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetBaseU8
;;; <処理概要>  : 頂点数8のU型形状外形ﾎﾟﾘﾗｲﾝのｺｰﾅｰ基点を求める(ｼﾝﾎﾞﾙをみない)
;;; <戻り値>    : point list(ｺｰﾅｰ1 , ｺｰﾅｰ2)
;;; <作成>      : 2000.5.16 YM
;;; <備考>      :
;;;
;;; ｺｰﾅｰ1
;;;  *-------------+
;;;  |             |
;;;  |    +--------+
;;;  |    |
;;;  |    |
;;;  |    +------+
;;;  |           |
;;;  *-----------+
;;; ｺｰﾅｰ2
;;;
;;; a*------>*b
;;;
;;;          *c : #aから#bへ向かうベクトルの右
;;;*************************************************************************>MOH<
(defun PKGetBaseU8 (
  &pt0$ ; 外形点列
  /
  #A #B #BASE$ #C #FLG #FLG$ #I #NO #NO$ #PT$ #SUM #TIME_DIR X #MSG
  )
;;;  (setq #pt0$ (GetLWPolyLinePt &OutPline)) ; 外形点列
  (setq #pt$ (append &pt0$ &pt0$))
  (if (= (length #pt$) 16)
    (progn
      (setq #i 1)
      (setq #flg$ '())
      ;;; #cが#aから#bへ向かうベクトルの右か左か
      (repeat 14
        (setq #a (nth (1- #i) #pt$)) ; 前の点
        (setq #b (nth #i      #pt$)) ; 現在の点
        (setq #c (nth (1+ #i) #pt$)) ; 次の点
        (setq #flg (CFArea_rl #a #b #c)) ; -1:右 , 1:左
        (setq #flg$ (append #flg$ (list #flg)))
        (setq #i (1+ #i))
      )
    )
    (progn
      (setq #msg "ワークトップ外形領域が取得できませんでした。")
      (if (= CG_AUTOMODE 2) ; 02/09/04 YM ADD
        (WebOutLog #msg)    ; 02/09/04 YM ADD
        (CFAlertMsg #msg)
      )
    )
  );_if

  (setq #sum 0)
  (foreach #flg #flg$  ; ﾘｽﾄの和
    (setq #sum (+ #sum #flg))
  )

  (if (< #sum 0)
    (progn
      (setq #flg$ (mapcar '(lambda (x) (* x -1)) #flg$)) ; 時計回りなら
      (setq #time_dir T) ; 時計周り
    )
  );_if

  (setq #i 0)
  (foreach #flg #flg$
    (if (= #flg -1)
      (setq #no$ (append #no$ (list #i))) ; -1が何番目か
    )
    (setq #i (1+ #i))
  )

  (if (> (length #no$) 2)
    (progn
      (cond
        ((> (- (nth 1 #no$) (nth 0 #no$)) 6)
          (setq #no (nth 0 #no$))
        )
        ((> (- (nth 2 #no$) (nth 1 #no$)) 6)
          (setq #no (nth 1 #no$))
        )
        (T
          (setq #no (nth 2 #no$))
        )
      );_cond
    )
  );_if

  (if (= (length #no$) 2)
    (setq #no (nth 1 #no$))
  );_if

  (if #time_dir
    (setq #base$ (list (nth (+ #no 5) #pt$) (nth (+ #no 4) #pt$))) ; 時計周り
    (setq #base$ (list (nth (+ #no 4) #pt$) (nth (+ #no 5) #pt$))) ; 反時計周り
  );_if

  #base$ ; U型ｺｰﾅｰ基点ﾘｽﾄ

);PKGetBaseU8

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_SetGlobalFromBaseCab2
;;; <処理概要>  : 間口２記号の判定
;;; <戻り値>    : なし
;;; <作成>      : 修正 00/03/24 YM
;;; <備考>      : 設定されるグローバル変数
;;;                 (nth 11 CG_GLOBAL$)     :ＬＲ区分コード("L" "R")           判定不能ﾊﾟﾀｰﾝあり
;;;                 CG_Type2Code  :形状タイプ２("F" "D")             ｺﾝﾛあり前提
;;;                 CG_W2Code     :間口２記号                        ｺｰﾅｰｷｬﾋﾞ個数  0:I , 1:L , 2:U <--- 最低でも決定
;;;                 ｼﾝｸ、ｺﾝﾛｷｬﾋﾞがあることが前提 --->なくてもWTを貼る
;;;                 左右の勝手をここで決めてしまう 不明==>右勝手
;;;                 ｼﾝｸ複数,ｺﾝﾛ複数時考慮 00/06/27 YM
;;;*************************************************************************>MOH<
(defun PKW_SetGlobalFromBaseCab2 (
    &Base$       ;(LIST)ベースキャビの基準シンボルリスト
    /
  #BASEPT$ #COUNT #DUM1 #DUM2 #S-EN #SKK$ #SNK_PT #H #en_LOW$ #basept
  #G-ANG #G-EN #G-PT #G-XD$ #G_KOSU #LR #S_KOSU #MSG
  )
  (setq CG_LRCODE    "?") ; "L" "R" "Z":なし 01/08/31 YM MOD
  (setq CG_W2CODE    "Z")    ; "I","L","U"

  ;// 間口２記号の判定   ｺｰﾅｰｷｬﾋﾞの個数でI,L,U型を判定する
  (setq #g_kosu 0 #s_kosu 0)
  (setq #count 0) ; ｺｰﾅｰｷｬﾋﾞの数

  ; 01/08/31 YM MOD-S ﾛｼﾞｯｸ変更
  (foreach #en &Base$ ; 各ﾍﾞｰｽｷｬﾋﾞ
    (setq #skk$ (CFGetSymSKKCode #en nil)) ; 検索したキャビネットの性格CODEを取得する
    (cond
      ; コーナーキャビ
      ((= (nth 2 #skk$) CG_SKK_THR_CNR) ; コーナーキャビかどうかの判定
        (setq #count (1+ #count)) ; ｺｰﾅｰｷｬﾋﾞの数
      )
      ;ガスキャビネット
      ((= (nth 2 #skk$) CG_SKK_THR_GAS)
        (setq #g-en #en) ; ｶﾞｽｷｬﾋﾞあり 複数の場合ありﾙｰﾌﾟの最後
        (setq #g_kosu (1+ #g_kosu)) ; ｶﾞｽｷｬﾋﾞ個数
      )
      ;シンクキャビネット
      ((= (nth 2 #skk$) CG_SKK_THR_SNK)
        (setq #s-en #en) ; ｼﾝｸｷｬﾋﾞあり 複数の場合ありﾙｰﾌﾟの最後
        (setq #s_kosu (1+ #s_kosu)) ; ｼﾝｸｷｬﾋﾞ個数
      )
    );_cond
  );foreach

  ; 間口２記号
  (cond
    ((= 0 #count)(setq CG_W2CODE "Z"))
    ((= 1 #count)(setq CG_W2CODE "L"))
    ((= 2 #count)(setq CG_W2CODE "U"))
    (T
      (setq #msg "このキッチン構成は対応していません")
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_cond

  ; 01/08/31 YM MOD-E ﾛｼﾞｯｸ変更

  ; ｺｰﾅｰｷｬﾋﾞの数確定

  ;//----------------------------------
  ;// ＬＲ区分の判定 I,L II型U型は判定不能
  ;//   ガスキャビのＤ方向ベクトルの
  ;//     1.左側にシンクがあれば右勝手
  ;//     2.右側にシンクがあれば左勝手
  ;//----------------------------------

;;; 右勝手、左勝手が決まらない場合 ===>  ｼﾝｸｷｬﾋﾞ,ｺﾝﾛｷｬﾋﾞがないか複数存在する場合
  (if (or (= CG_W2CODE "U")(= #s_kosu 0)(= #g_kosu 0)(> #s_kosu 1)(> #s_kosu 1))
;-- 2011/06/28 A.Satoh Mod - S
    (setq CG_LRCODE "Z");2011/09/23 YM MOD
;-- 2011/06/28 A.Satoh Mod - E
    (progn ; ｼﾝｸｷｬﾋﾞとｺﾝﾛｷｬﾋﾞも1つ ; I型 か L型
      (setq #g-xd$ (CFGetXData #g-en "G_LSYM"))
      (setq #g-ang (nth 2 #g-xd$))
      (setq #g-pt (cdr (assoc 10 (entget #g-en))))
      (setq #lr ; INT : 1:左 -1:右 0:延長線上
        (CFArea_rl
          #g-pt
          (polar #g-pt (- #g-ang (dtr 90)) 10)
          (cdr (assoc 10 (entget #s-en)))
        )
      )
      (if (= #lr 1)  ;ガスDベクトルの左側であった場合
        (setq CG_LRCODE "R") ; 右勝手 ;2011/09/23 YM MOD
        (setq CG_LRCODE "L")          ;2011/09/23 YM MOD
      )
    )
  );_if

);PKW_SetGlobalFromBaseCab2

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetWTInfo プラン検索以外用
;;; <処理概要>  : 材質記号選択ﾀﾞｲｱﾛｸﾞ   WT情報ダイアログ確認表示
;;;               不要部分削除  WT素材の検索はしない
;;; <戻り値>    : #WTInfo : (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S) WT情報
;;;               #retWT_BG_FG$ : PKMakeWT_BG_FG_Pline の戻り値
;;;               #SetXd$ : G_WRKT の雛形
;;;               #CUT_KIGO$ : 左右ｶｯﾄ記号
;;;               #CG_WtDepth : WT750拡張ﾌﾗｸﾞ
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      :
;;; #CG_WtDepth = 0 延長なし --- 固定
;;; #CG_WtDepth = 1 シンク側のみ
;;; #CG_WtDepth = 10 コンロ側のみ
;;; #CG_WtDepth = 100 その他
;;;*************************************************************************>MOH<
(defun PKGetWTInfo (
  &pt$       ; 元のｷｬﾋﾞﾈｯﾄ外形ﾎﾟﾘﾗｲﾝの点列
  &pt$$      ; WT外形ﾎﾟﾘﾗｲﾝの点列
  &base$     ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形名ﾘｽﾄ
  &base_new$ ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形名ﾘｽﾄ(ｷｬﾋﾞﾈｯﾄの除外後)
  &outpl_LOW ; ﾛｰﾀｲﾌﾟｷｬﾋﾞ外形ﾎﾟﾘﾗｲﾝ図形名
  &en_LOW$   ; ﾛｰﾀｲﾌﾟｷｬﾋﾞｼﾝﾎﾞﾙ図形名ﾘｽﾄ
  /
  #BG_H #BG_S #BG_SEP #BG_T #BG_TYPE #CG_WTDEPTH #CUTID #DAN$$ #DAN$ #FG_H #FG_S #FG_T #FG_TYPE #type1
  #IHEIGHT$ #RET$ #RETWT_BG_FG$ #SETXD$ #WTINFO #WTINFO1 #WTINFO2 #WTINFO3 #WT_H #WT_T #ZAI$ #ZAICODE
#RH #RZ ; 01/08/24 YM ADD
#TOP_FLG ;03/10/14 YM ADD
;-- 2011/08/25 A.Satoh Add - S
#qry$ #offsetL #offsetR
;-- 2011/08/25 A.Satoh Add - E
  )
  (PKGetBASEPT_L &pt$ &base$) ; 00/09/29 YM ADD ﾍﾞｰｽｸﾞﾛｰﾊﾞﾙを求める

  (cond
    ((= CG_W2CODE "Z") ; I型
      (setq #type1 "0")
    )
    ((= CG_W2CODE "L") ; L型
      (setq #type1 "1")
    )
    ((= CG_W2CODE "U") ; U型
      (setq #type1 "2")
    )
  );_cond

  ; 01/06/25 YM 下から移動 START
  ;// 材質記号の選択
  (setq #zai$ (PKW_ZaisituDlg)) ; ダイアログボックスの表示
  (if (= #zai$ nil)
    (*error*)
  )
  (setq #ZaiCode (nth 0 #zai$)) ; 材質記号
  (setq #CutId   (nth 1 #zai$)) ; カット記号
  ; 01/06/25 YM 下から移動 END

  ;// ワークトップの取り付け高さを求める 01/07/30 YM MOD 寸法H==>寸法H+ｼﾝﾎﾞﾙ基準点Z座標に変更
  (foreach #en &base$
    (setq #rZ (caddr (cdr (assoc 10 (entget #en))))) ; ｼﾝﾎﾞﾙZ座標
    (setq #rH (+ #rZ (nth 5 (CFGetXData #en "G_SYM"))))
    (setq #iHeight$ (cons #rH #iHeight$)) ; シンボル基準値Ｈ (825.0 825.0 630.0 825.0) 630ｶﾞｽ
  )
  (setq #WT_H (apply 'max #iHeight$)) ; 取り付け高さの最大値

  ;// 断面の選択
  (setq #dan$$ (PKW_DanmenDlg #ZaiCode #CutId))  ; ダイアログボックスの表示
  (if (= #dan$$ nil)
    (*error*)
  )
  (setq #dan$    (nth 0 #dan$$))
  (setq #WTInfo1 (nth 1 #dan$$))
  (setq #WTInfo2 (nth 2 #dan$$))
  (setq #WTInfo3 (nth 3 #dan$$))

; #WTInfo1 1枚目天板
;奥行き延長量 
;BG有無 0 or 1
;FG有無 0 or 1 or 2
;天板延長量左
;天板延長量右


;-- 2011/08/25 A.Satoh Add - S
  ; 断面情報１(#WTInfo1)にサイドシフト左、サイドシフト右を追加する
  (setq #qry$
    (DBSqlAutoQuery CG_DBSESSION (strcat "select * from WT断面 where 断面ID='" (nth 0 #dan$) "'"))
  )

  (if #qry$
    (progn
      (setq #offsetL (nth 13 (car #qry$)))
      (setq #offsetR (nth 14 (car #qry$)))
    )
    (progn
      (setq #offsetL 0)
      (setq #offsetR 0)
    )
  )
  (setq #WTInfo1 (append #WTInfo1 (list #offsetL #offsetR)))


  (setq #WT_T    (nth  2 #dan$)) ; WTの厚み
  (setq #BG_H    (nth  4 #dan$)) ; BGの高さ
  (setq #BG_T    (nth  5 #dan$)) ; BGの厚み
  (setq #FG_H    (nth  7 #dan$)) ; FGの高さ
  (setq #FG_T    (nth  8 #dan$)) ; FGの厚み
  (setq #FG_S    (nth  9 #dan$)) ; 前垂れシフト量
  (setq #BG_S    (nth 10 #dan$)) ; 後垂れシフト量
  ;03/09/22 YM ADD 特異天板ﾌﾗｸﾞ
  ;0:標準 1:BGが左右に回り込む 2:前垂れが左側面背面に回りこむ 3:前垂れが右側面背面に回りこむ
  (setq #TOP_FLG (nth 12 #dan$)) ; 特異天板ﾌﾗｸﾞ
  ;03/10/14 YM ADD

;;;  (setq #BG_Type (nth  3 #dan$)) ; BG有無
;;;  (setq #FG_Type (nth  6 #dan$)) ; 前垂れﾀｲﾌﾟ
  (setq #BG_Sep  (nth 11 #dan$)) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離
;-- 2011/08/25 A.Satoh Mod - S
;  (setq #WTInfo  (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))

;2016/02/23 YM MOD-S #LRは使用しない
;;;  (setq #WTInfo  (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG #LR))
  (setq #WTInfo  (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG ))
;2016/02/23 YM MOD-E #LRは使用しない

;-- 2011/08/25 A.Satoh Mod - E
;;;  (setq #WTInfo1 (list #BG_S #BG_Type #FG_Type))

  (setq #CG_WtDepth 0)
  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart)

;;;09/21YM  (setq #WTInfo (PKWT_INFO_Dlg)) ; ダイアログ確認表示
;;;09/21YM  (if (= #WTInfo nil)
;;;09/21YM    (*error*) ; cancelの場合
;;;09/21YM    (progn
;;;09/21YM      (setq #WT_T (nth 0 #WTInfo)) ; WTの厚み
;;;09/21YM      (setq #BG_H (nth 1 #WTInfo)) ; BGの高さ
;;;09/21YM      (setq #BG_T (nth 2 #WTInfo)) ; BGの厚み
;;;09/21YM      (setq #FG_H (nth 3 #WTInfo)) ; FGの高さ
;;;09/21YM      (setq #FG_T (nth 4 #WTInfo)) ; FGの厚み
;;;09/21YM      (setq #FG_S (nth 5 #WTInfo)) ; 前垂れシフト量
;;;09/21YM      (setq #WTInfo (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S))
;;;09/21YM    )
;;;09/21YM  );_if

;;; ワークトップ用画層の作成
  (command "_layer" "N" SKW_AUTO_SECTION "C" 2 SKW_AUTO_SECTION "L" SKW_AUTO_LAY_LINE SKW_AUTO_SECTION "")
  (command "_layer" "N" SKW_AUTO_SOLID   "C" 7 SKW_AUTO_SOLID   "L" SKW_AUTO_LAY_LINE SKW_AUTO_SOLID   "")
  (command "_layer" "T" SKW_AUTO_SECTION "") ; 画層解除
  (command "_layer" "T" SKW_AUTO_SOLID   "") ; 画層解除

;;;DBで得た情報からWT,BG,FG底面ﾎﾟﾘﾗｲﾝを求める.
;;;WTｼﾌﾄ量分WT底面領域を修正する
  (setq #retWT_BG_FG$
    (PKMakeWT_BG_FG_Pline
      &pt$$
      &base_new$
      #CG_WtDepth
      #WTInfo  ; 共通情報
      #WTInfo1 ; 1枚目
      #WTInfo2 ; 2枚目
      #WTInfo3 ; 3枚目
      #CutId
      &outpl_LOW
      #ZaiCode
    )
  )

  (if (= nil (tblsearch "APPID" "G_WRKT")) (regapp "G_WRKT"))
  (if (= nil (tblsearch "APPID" "G_BKGD")) (regapp "G_BKGD"))
  (if (= nil (tblsearch "APPID" "G_OPT" )) (regapp "G_OPT" ))

;;; "G_WRKT" *** 共通項目設定 *** nil をｾｯﾄできないため "" に修正

(if (= CG_MAG1 nil)(setq CG_MAG1 0))
(if (= CG_MAG2 nil)(setq CG_MAG2 0))
(if (= CG_MAG3 nil)(setq CG_MAG3 0))

;;; 新G_WRKT の雛形 現段階で入力可能なもののみ
  (setq #SetXd$                ; 未設定項目は-999 or "-999"
    (list "K"                  ;1. 工種記号
;-- 2011/06/16 A.Satoh Mod - S
          ;CG_SeriesCode        ;2. SERIES記号
          CG_SeriesDB          ;2. SERIES名称
;-- 2011/06/16 A.Satoh Mod - E
          #ZaiCode             ;3. 材質記号
          (atoi #type1)        ;4. 形状タイプ１          0,1,2(I,L,U) この時点で未決定
          CG_Type2Code         ;5. 形状タイプ２          F,D
;-- 2011/06/16 A.Satoh Mod - S
;          0                    ;6. 未使用
          ""                   ;6. 未使用
;-- 2011/06/16 A.Satoh Mod - E
          ""                   ;7. 未使用
          ""                   ;8. カットタイプ番号      0:なし,1:VPK,2:X,3:H 左右
          #WT_H                ;9. 下端取付け高さ        827
;-- 2011/06/16 A.Satoh Mod - S
;          "旧WT奥行き"         ;10.未使用
          ""                   ;10.未使用
;-- 2011/06/16 A.Satoh Mod - E
          #WT_T                ;11.カウンター厚さ        23
          1                    ;12.未使用
          #BG_H                ;13.バックガードの高さ    50
          #BG_T                ;14.バックガード厚み      20
          1                    ;15.未使用
          #FG_H                ;16.前垂れ高さ            40
          #FG_T                ;17.前垂れ厚さ            20
          #FG_S                ;18.前垂れシフト量         7
          0 "" "" ""           ;19.ｼﾝｸ穴加工
          0 "" "" "" "" "" "" "" ;23.水栓穴データ数  水栓穴図形ハンドル1～5
;-- 2011/06/28 A.Satoh Mod - S
;         (if (= nil CG_GLOBAL$);2010/01/07 YM MOD
;           "L"
;           (nth 11 CG_GLOBAL$)  ;31.ＬＲ勝手フラグ
;         );_if
          CG_LRCODE ;2011/09/23 YM MODE
;-- 2011/06/28 A.Satoh Mod - E
;-- 2011/06/16 A.Satoh Mod - S
;;;;;          0.0                  ;32.未使用
          ""                   ;32.未使用
;-- 2011/06/16 A.Satoh Mod - E
          ""                   ;33.WT左上点
          ""                   ;34.未使用
          ""                   ;35.未使用
;-- 2011/06/16 A.Satoh Mod - S
;          "旧ｶｯﾄ相手ﾊﾝﾄﾞﾙ"     ;36.未使用
          ""                   ;36.カットライン図形ハンドル
;-- 2011/06/16 A.Satoh Mod - E
          ""                   ;37.カットライン図形ハンドル２
          ""                   ;38.カット右(未使用)
          ""                   ;[39]WT底面図形ﾊﾝﾄﾞﾙ
          0.0                  ;[40]未使用
          0.0                  ;[41]未使用
          0.0                  ;[42]未使用
          CG_MAG1              ;[43]間口1 1枚目WT
          CG_MAG2              ;[44]間口2 2枚目WT
          CG_MAG3              ;[45]間口3 3枚目WT
          ""                   ;[46]品名
          ""                   ;[47]備考
          ""                   ;[48]カット相手WTﾊﾝﾄﾞﾙ左
          ""                   ;[49]カット相手WTﾊﾝﾄﾞﾙ右
          ""                   ;[50]BG底面図形ﾊﾝﾄﾞﾙ1
          ""                   ;[51]BG底面図形ﾊﾝﾄﾞﾙ2
          ""                   ;[52]FG底面図形ﾊﾝﾄﾞﾙ
          ""                   ;[53]素材ID
          0.0                  ;[54]間口伸縮量1 ｼﾝｸ側 (旧"G_SIDE"ｶｳﾝﾀｰ伸縮量) 品番確定に必要
          0.0                  ;[55]間口伸縮量2 ｺﾝﾛ側 (旧"G_SIDE"ｶｳﾝﾀｰ伸縮量) 品番確定に必要
          '(0.0 0.0)           ;[56]現在のWTの幅 (旧"G_SIDE"ｶｳﾝﾀｰ押し出し) 品番確定に必要 WT拡張前、ｶｯﾄ前のｺｰﾅｰ基点から角まで
          0.0                  ;[57]現在のWTの伸縮量
          '(0.0 0.0)           ;[58]現在のWTの奥行き
          ""                   ;[59]上面溝加工の有無    "A" 上面溝加工なし or "B" 上面溝加工あり
          ""                   ;[60]段差部分も含めたWT外形PLINEハンドル
          ""                   ;[61]カットラインハンドル1
          ""                   ;[62]カットラインハンドル2
          ""                   ;[63]カットラインハンドル3
          ""                   ;[64]カットラインハンドル4
    )
  )

  (setq #ret$ (list #WTInfo #retWT_BG_FG$ #SetXd$ nil #CG_WtDepth #CutId))
  #ret$
);PKGetWTInfo

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetBASEPT_L
;;; <処理概要>  : CG_BASEPT1,2 ｺｰﾅｰ基点1,2 を求める
;;; <戻り値>    : なし
;;; <作成>      : 00/09/29 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKGetBASEPT_L (
  &pt$        ; 除外前の外形領域点列
  &base$      ; 除外前の外形領域内ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ
  /
  #BASEPT #BASEPT$ #KOSU
  )
  ;;; 外形点列 #pt$ から奥行きを求める
  (setq #kosu (length &pt$))

  (cond
    ((= #kosu 4) ; I型
      (setq #BASEPT (PKGetBaseI4 &pt$ &base$)) ; 点列とｼﾝﾎﾞﾙ基点１つ
      (setq CG_BASEPT1 #BASEPT)    ; ｺｰﾅｰ基点1
      (setq CG_BASEPT2 "")         ; ｺｰﾅｰ基点2
    )
    ((= #kosu 6) ; L型
      ;;; 新ﾛｼﾞｯｸ 05/15 YM 外形点列-->ｺｰﾅｰ基点 PKGetBaseL6
      (setq #BASEPT (PKGetBaseL6 &pt$))
      (setq CG_BASEPT1 #BASEPT)    ; ｺｰﾅｰ基点1
      (setq CG_BASEPT2 "")         ; ｺｰﾅｰ基点2
    )
    ((= #kosu 8) ; U型
      ;;; 新ﾛｼﾞｯｸ 05/15 YM 外形点列-->ｺｰﾅｰ基点 PKGetBaseL6
      (setq #BASEPT$ (PKGetBaseU8 &pt$))
      (setq CG_BASEPT1 (car  #BASEPT$)) ; ｺｰﾅｰ基点1
      (setq CG_BASEPT2 (cadr #BASEPT$)) ; ｺｰﾅｰ基点2
    )
  );_cond
  (princ)
);PKGetDep123F

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_MakeWorktop3
;;; <処理概要>  : ﾜｰｸﾄｯﾌﾟの生成 Z方向に extrude
;;; <戻り値>    : WT SOLID図形名ﾘｽﾄ
;;; <作成>      : 2000.3.15 YM  修正 2000.4.4 ｶｯﾄ済み領域を渡す
;;; <備考>      : KPCAD I型,L型,U型対応
;;;               平面 Z=0 上にあるものとする.
;;;               BG,FGはWTと別作成、必要ならUNIONをとる
;;;               ｶｯﾄ記号はDBに頼らずともよい
;;;*************************************************************************>MOH<
(defun PK_MakeWorktop3 (
  &WTInfo$  ; (list #WTInfo  #retWT_BG_FG$  #SetXd$  #CUT_KIGO$  #CG_WtDepth)
  &en_LOW$  ; ﾛｰﾀｲﾌﾟｷｬﾋﾞﾘｽﾄ
  &pt_LOW$  ; ﾛｰﾀｲﾌﾟｷｬﾋﾞ外形点列
  /
  #BG$ #BG0$ #BG01 #BG02 #BG1 #BG2 #BG_ALL_LEN #BG_H #BG_LEN #BG_REGION #BG_SEP
  #BG_SOLID #BG_SOLID$ #BG_SOLID1 #BG_SOLID2 #BG_T #BG_TEI1 #BG_TEI2 #CG_WTDEPTH
  #CL #CR #CUTID #CUTL #CUTR #CUTTYPE #CUT_KIGO$ #CUT_LEN$ #CUT_LENL #CUT_LENR #DEP$
  #ED #FG$ #FG0$ #FG01 #FG02 #FG1 #FG2 #FG_H #FG_REGION #FG_S #DANFLG
  #FG_SOLID #FG_SOLID$ #FG_SOLID1 #FG_SOLID2 #FG_T #FG_TEI1 #FG_TEI2 #I #KOSU #MSGD
  #OS #OT #RAPDANWT #RETWT_BG_FG$ #SERI #SETXD$ #SM #SS #TCUTL #TCUTR #WT #WT0 #WT0$
  #WTINFO #WTL #WTR #WT_BASE #WT_H #WT_LEN$ #WT_REGION #WT_SOLID #WT_SOLID$ #WT_T #ZAICODE
  #ii #EWT_GAIKEI ;#SYSTEM_POLE -- 2011/06/16 A.Satoh '#SYSTEM_POLE Delete
;-- 2011/07/28 A.Satoh Add - S
  #Keijo #handle$ #oku$
;-- 2011/07/28 A.Satoh Add - S
;-- 2011/10/21 A.Satoh Add - S
#WT_FlatType
;-- 2011/10/21 A.Satoh Add - E
#snk_dep ;-- 2012/04/20 A.Satoh Add シンク配置不具合対応
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (defun ##NiltoStr ( &dum / )
      (if (= &dum nil)
        (setq &dum "")
      )
      &dum
    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #msgD "段差部のプランをご確認ください。")
;;; ｼｽﾃﾑ変数設定
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setq #ed (getvar "EDGEMODE" ))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "EDGEMODE"  0)

  (setq #BG_SOLID nil #BG_SOLID$ '())
  (setq #FG_SOLID nil #FG_SOLID$ '())
  (setq #WT_SOLID nil #WT_SOLID$ '())
  (setq #WT0$ '())
  (setq #BG0$ '())
  (setq #FG0$ '())
  (setq #BG_LEN 0)

  (setq #WTInfo       (nth 0 &WTInfo$))
  (setq #retWT_BG_FG$ (nth 1 &WTInfo$))
  (setq #SetXd$       (nth 2 &WTInfo$))
  (setq #CUT_KIGO$    (nth 3 &WTInfo$)) ; nil 有り得る
  (setq #CG_WtDepth   (nth 4 &WTInfo$))
  (setq #CutID        (nth 5 &WTInfo$))

;;;(setq #WTInfo  (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep))
  (setq #WT_H   (nth 0 #WTInfo)) ; WT高さ
  (setq #WT_T   (nth 1 #WTInfo)) ; WT厚み
  (setq #BG_H   (nth 2 #WTInfo)) ; BG高さ
  (setq #BG_T   (nth 3 #WTInfo)) ; BG厚み
  (setq #FG_H   (nth 4 #WTInfo)) ; FG高さ
  (setq #FG_T   (nth 5 #WTInfo)) ; FG厚み
  (setq #FG_S   (nth 6 #WTInfo)) ; FGｼﾌﾄ量
  (setq #BG_Sep (nth 7 #WTInfo)) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離

  (setq #seri    (nth  1 #SetXd$)) ; SERIES記号
  (setq #ZaiCode (nth  2 #SetXd$)) ; 材質
;-- 2011/09/30 A.Satoh Del - S
;;;;;;-- 2011/07/28 A.Satoh Add - S
;;;;;  (setq #Keijo   (nth  3 #SetXd$)) ; 形状 0:I型　1:L型　2:U型
;;;;;;-- 2011/07/28 A.Satoh Add - E
;-- 2011/09/30 A.Satoh Del - S

  (setq #i 0)
  (setq #kosu (length #retWT_BG_FG$))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1回目のﾙｰﾌﾟSOLIDを作成する ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (repeat #kosu
    (setq #WT  (nth 0 (nth #i #retWT_BG_FG$))) ; WT底面
    (setq #BG$ (nth 1 (nth #i #retWT_BG_FG$))) ; BG底面
    (setq #BG1 (car  #BG$)) ; BG底面1
    (setq #BG2 (cadr #BG$)) ; BG底面2
    (setq #FG$ (nth 2 (nth #i #retWT_BG_FG$))) ; FG底面
    (setq #FG1 (car  #FG$)) ; FG底面1
    (setq #FG2 (cadr #FG$)) ; FG底面2
;;; WT押し出し処理+移動
    (if #WT
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #WT)) (entget #WT)))
        (setq #WT0 (entlast)) ; 残す
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT)) (entget #WT))) ; WT専用の画層
        (setq #WT0$ (append #WT0$ (list #WT0)))
        (setq #WT_region (Make_Region2 #WT))
        (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
        (setq #WT_SOLID$ (append #WT_SOLID$ (list #WT_SOLID)))
      )
    );_if

;;; BG1 押し出し処理+移動 1つのﾜｰｸﾄｯﾌﾟにﾊﾞｯｸｶﾞｰﾄﾞが2つ有り得る為ﾘｽﾄ化 00/04/21 YM
    (setq #BG01 nil #BG_SOLID1 nil)
    (if #BG1
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG1)) (entget #BG1)))
        (setq #BG01 (entlast)) ; 残す BG底面
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG1)) (entget #BG1))) ; WT専用の画層
        (setq #BG_region (Make_Region2 #BG1))
        (setq #BG_SOLID1 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
      )
    );_if

;;; BG2 押し出し処理+移動
    (setq #BG02 nil #BG_SOLID2 nil)
    (if #BG2
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG2)) (entget #BG2)))
        (setq #BG02 (entlast)) ; 残す BG底面
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG2)) (entget #BG2))) ; WT専用の画層
        (setq #BG_region (Make_Region2 #BG2))
        (setq #BG_SOLID2 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
      )
    );_if

    (setq #BG_SOLID$ (append #BG_SOLID$ (list (list #BG_SOLID1 #BG_SOLID2))))
    (setq #BG0$ (append #BG0$ (list (list #BG01 #BG02))))

;;; 前垂れ1押し出し処理+移動
    (setq #FG01 nil #FG_SOLID1 nil)
    (if #FG1
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG1)) (entget #FG1)))
        (setq #FG01 (entlast)) ; 残す
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG1)) (entget #FG1))) ; WT専用の画層
        (setq #FG_region (Make_Region2 #FG1))
        (setq #FG_SOLID1 (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
      )
    );_if

;;; 前垂れ2押し出し処理+移動
    (setq #FG02 nil #FG_SOLID2 nil)
    (if #FG2
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG2)) (entget #FG2)))
        (setq #FG02 (entlast)) ; 残す
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG2)) (entget #FG2))) ; WT専用の画層
        (setq #FG_region (Make_Region2 #FG2))
        (setq #FG_SOLID2 (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
      )
    );_if

    (setq #FG_SOLID$ (append #FG_SOLID$ (list (list #FG_SOLID1 #FG_SOLID2))))
    (setq #FG0$ (append #FG0$ (list (list #FG01 #FG02))))

    (setq #i (1+ #i))
  );_repeat

  (setq #i 0 #DANFLG nil)
  (setq #TCUTL nil #TCUTR nil) ; 初期化が必要(WT間口伸縮量)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2回目のﾙｰﾌﾟｶｯﾄ記号　　　　 ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (repeat #kosu
    (setq #RAPDANWT nil) ; ﾗﾋﾟｽ段差WT
    (setq #WTL  nil)
    (setq #WTR  nil)
    (setq #cutL nil)
    (setq #cutR nil)
    (setq #CUT_LENL 0.0)
    (setq #CUT_LENR 0.0)

    (setq #CutType (nth 3 (nth #i #retWT_BG_FG$))) ; ｶｯﾄﾀｲﾌﾟ
    (setq #dep$    (nth 4 (nth #i #retWT_BG_FG$))) ; 奥行き
    (setq #WT_LEN$ (nth 5 (nth #i #retWT_BG_FG$))) ; WT長さ
    (setq #WT_BASE (nth 6 (nth #i #retWT_BG_FG$))) ; WT左上点座標
;;;    (setq #TYPE    (nth 7 (nth #i #retWT_BG_FG$))) ; WT形状 0:I,1:L,2:U 未使用0固定

    (setq #WT0 (nth #i #WT0$))           ; WT底面
    (setq #BG01 (car  (nth #i #BG0$)))   ; BG底面ﾊﾝﾄﾞﾙ1
    (setq #BG02 (cadr (nth #i #BG0$)))   ; BG底面2 nil あり
    (setq #BG01 (##NiltoStr #BG01))
    (setq #BG02 (##NiltoStr #BG02))

    (setq #FG01 (car  (nth #i #FG0$)))   ; FG1底面
    (setq #FG02 (cadr (nth #i #FG0$)))   ; FG2底面
    (setq #FG01 (##NiltoStr #FG01))
    (setq #FG02 (##NiltoStr #FG02))

    (setq #WT_SOLID (nth #i #WT_SOLID$))

    (setq #BG_SOLID1 (car  (nth #i #BG_SOLID$)))
    (setq #BG_SOLID2 (cadr (nth #i #BG_SOLID$))) ; nil あり
    (setq #BG_SOLID1 (##NiltoStr #BG_SOLID1))
    (setq #BG_SOLID2 (##NiltoStr #BG_SOLID2))

    (setq #FG_SOLID1 (car  (nth #i #FG_SOLID$)))
    (setq #FG_SOLID2 (cadr (nth #i #FG_SOLID$)))
    (setq #FG_SOLID1 (##NiltoStr #FG_SOLID1))
    (setq #FG_SOLID2 (##NiltoStr #FG_SOLID2))

    (setq #ss (ssadd))
    (ssadd #WT_SOLID #ss)
    (if (/= #FG_SOLID1 "")
      (ssadd #FG_SOLID1 #ss)
    )
    (if (/= #FG_SOLID2 "")
      (ssadd #FG_SOLID2 #ss)
    )

    (setq #FG_tei1 #FG01)
    (setq #FG_tei2 #FG02)

    (if (equal #BG_Sep 1 0.1)
      (progn ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
        (command "_union" #ss "") ; 交わらない領域でもＯＫ！
        (setq #BG_tei1 #BG_SOLID1)
        (setq #BG_tei2 #BG_SOLID2)
      )
      (progn ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型以外
        (if (and #BG_SOLID1 (/= #BG_SOLID1 ""))
          (ssadd #BG_SOLID1 #ss)
        )
        (if (and #BG_SOLID2 (/= #BG_SOLID2 "")) ; 01/07/26 YM ADD
          (ssadd #BG_SOLID2 #ss)
        )
        (command "_union" #ss "") ; 交わらない領域でもＯＫ！
        (setq #BG_tei1 #BG01)
        (setq #BG_tei2 #BG02)
      )
    );_if

;;;    (GroupInSolidChgCol2 #WT_SOLID CG_InfoSymCol) ; 一時的にWTの色を変える

;;; ｶｯﾄ記号のｾｯﾄ
    (setq #CL (substr #CutType 1 1))
    (setq #CR (substr #CutType 2 1))
;;;   (CFAlertMsg #msg)
;LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
    (cond
      ((= #CL "0")
        (setq #cutL "0")
      )
      ((= #CL "1")
        (setq #WTL (nth (1+ #i) #WT_SOLID$))
        (setq #cutL "1")
      )
      ((= #CL "2")
        (setq #WTL (nth (1+ #i) #WT_SOLID$))
        (setq #cutL "2")
      )
      ((= #CL "3")
        (setq #WTL (nth (1+ #i) #WT_SOLID$))
        (setq #cutL "3")
      )
      ((= #CL "4") ; 段差対応
        (setq #TCUTL CG_TCUT)
;;;01/03/22YM@        (if #DANFLG
;;;01/03/22YM@          (progn
;;;01/03/22YM@            (setq #TCUTL 20)              ; 段差部処理済み
;;;01/03/22YM@          )
;;;01/03/22YM@          (progn
;;;01/03/22YM@            (setq #TCUTL 20)              ; 段差部処理済み
;;;01/03/22YM@            (KP_PutDansaSWT &en_LOW$ "R") ; 段差部ｽﾃﾝﾚｽ
;;;01/03/22YM@            (setq #DANFLG T)
;;;01/03/22YM@          )
;;;01/03/22YM@        );_if
        (setq #cutL "4")
      )
      ((= #CL "5") ; 広角度
        (setq #WTL (nth (1+ #i) #WT_SOLID$))
        (setq #cutL "5")
      )
      ((= #CL "6") ; ｸﾞﾗﾘｯﾁDｶｯﾄ
        (setq #WTL (nth (1+ #i) #WT_SOLID$))
        (setq #cutL "6")
      )
    );_cond
;RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
    (cond
      ((= #CR "0")
        (setq #cutR "0")
      )
      ((= #CR "1")
        (setq #WTR (nth (1- #i) #WT_SOLID$))
        (setq #cutR "1")
      )
      ((= #CR "2")
        (setq #WTR (nth (1- #i) #WT_SOLID$))
        (setq #cutR "2")
      )
      ((= #CR "3")
        (setq #WTR (nth (1- #i) #WT_SOLID$))
        (setq #cutR "3")
      )
      ((= #CR "4") ; 段差対応
        (setq #TCUTR CG_TCUT)
        (setq #cutR "4")
      )
      ((= #CR "5") ; 広角度
        (setq #WTR (nth (1- #i) #WT_SOLID$))
        (setq #cutR "5")
      )
      ((= #CR "6") ; ｸﾞﾗﾘｯﾁDｶｯﾄ
        (setq #WTR (nth (1- #i) #WT_SOLID$))
        (setq #cutR "6")
      )
    );_cond

    (setq #WT0  (##NiltoStr #WT0))
    (setq #WTL  (##NiltoStr #WTL))
    (setq #WTR  (##NiltoStr #WTR))
    (setq #cutL (##NiltoStr #cutL))
    (setq #cutR (##NiltoStr #cutR))
    (setq #dep$ (##NiltoStr #dep$))
    (setq #CUT_LEN$ (list #CUT_LENL #CUT_LENR))

    ;04/04/09 YM ADD-S ﾌﾙﾌﾗｯﾄ,ｾﾐﾌﾗｯﾄ判定
    ;2009/04/17 YM DEL ｳｯﾄﾞﾜﾝは未使用
;;;   (setq #WT_FlatType (FullSemiFlatHantei #dep$))

;-- 2011/06/16 A.Satoh Del - S
; ;2009/04/17 YM ADD-S
; (setq #WT_FlatType "")
;
; ;2010/01/07 YM MOD
; (if (= nil CG_GLOBAL$)
;   (progn
;     (setq #WT_FlatType "")
;   )
;   (progn
;     
;     (cond
;       ((= "D105" (nth 7 CG_GLOBAL$))
;         (setq #WT_FlatType "D105");P型
;       )
;       ((= "D970" (nth 7 CG_GLOBAL$))
;         (setq #WT_FlatType "D970");P型
;       )
;       ((= "D900" (nth 7 CG_GLOBAL$))
;         (setq #WT_FlatType "D900");P型
;       )
;       (T
;         ;2009/04/17 YM ADD-S ｹﾞｰﾄﾀｲﾌﾟ
;         (if (wcmatch (nth  5 CG_GLOBAL$) "G*" )
;           (setq #WT_FlatType "D650"); ｹﾞｰﾄﾀｲﾌﾟ;P型
;         );_if
;         ;2009/04/17 YM ADD-E
;
;       )
;     );_cond
;     ;2009/04/17 YM ADD-E
;
;   )
; );_if
;-- 2011/06/16 A.Satoh Del - E

;;; 拡張ﾃﾞｰﾀ "G_WRKT" のｾｯﾄ
    (CFSetXData #WT_SOLID "G_WRKT"
      (CFModList #SetXd$
        (list
;--2011/06/16 A.Satoh Del - S
;          (list  5 #SYSTEM_POLE) ;6. 未使用==>ｼﾝｸﾎﾟｰﾙ穴ありのとき"P"
;--2011/06/16 A.Satoh Del - E
          (list  7 #CutType) ;8. カットタイプ番号      0:なし,1:VPK,2:X,3:H 左右 "20"など
;--2011/06/16 A.Satoh Del - S
;          (list 31 #WT_FlatType) ;32."SF"：ｾﾐﾌﾗｯﾄ,"FF"：ﾌﾙﾌﾗｯﾄ
;--2011/06/16 A.Satoh Del - E
          (list 32 #WT_BASE) ;33.WT左上点座標
;--2011/08/26 A.Satoh Del - S
;          (list 36 #cutL)    ;37.カット左 I,H,X,P,K,L,V,S,Z
;          (list 37 #cutR)    ;38.カット右
;--2011/08/26 A.Satoh Del - E
          (list 38 #WT0)     ;[39]WT底面図形ﾊﾝﾄﾞﾙ
          (list 47 #WTL)     ;[48]カット相手WTﾊﾝﾄﾞﾙ左
          (list 48 #WTR)     ;[49]カット相手WTﾊﾝﾄﾞﾙ右
          (list 49 #BG_tei1) ;[50]分離型の場合BG SOLID図形ﾊﾝﾄﾞﾙ1  それ以外は底面図形ﾊﾝﾄﾞﾙ1
          (list 50 #BG_tei2) ;[51]分離型の場合BG SOLID図形ﾊﾝﾄﾞﾙ2  それ以外は底面図形ﾊﾝﾄﾞﾙ2
          (list 51 #FG_tei1) ;[52]FG 底面図形ﾊﾝﾄﾞﾙ
          (list 52 #FG_tei2) ;[53]FG 底面図形ﾊﾝﾄﾞﾙ
          (list 55 #WT_LEN$) ;[56]現在のWTの押し出し長さ(旧"G_SIDE"ｶｳﾝﾀｰ押し出し)
          (list 57 #dep$)    ;[58]現在のWTの奥行き
        )
      )
    )

;;; 拡張ﾃﾞｰﾀ G_BKGDのｾｯﾄ
    (if (equal #BG_Sep 1 0.1)
      (progn ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
        (setq #BG_ALL_LEN 0)
        (if (and #BG_SOLID1 (/= #BG_SOLID1 ""))
          (setq #BG_ALL_LEN
            (PKSetBGXData
              (list #BG_SOLID1 #BG_SOLID2)
              #cutL #cutR #ZaiCode
              (list #BG01 #BG02)
              #WT_SOLID nil
            )
          )
        )
        (setq #BG_LEN (+ #BG_LEN #BG_ALL_LEN))
      )
      (setq #BG_LEN 0)
    );_if
;;;    (GroupInSolidChgCol2 #WT_SOLID "BYLAYER") ; WTの色を戻す
;;; 段差接続部間口伸縮
    (if #TCUTL
      (progn
        (setq #WT_SOLID (SubStretchWkTop #WT_SOLID "L" #TCUTL))     ; 戻り値 伸縮後のWT
        (setq #WT_SOLID$ (CFModList #WT_SOLID$ (list (list #i #WT_SOLID)))) ; 新しいWTに入れ替える
      )
    );_if
    (if #TCUTR
      (progn
        (setq #WT_SOLID (SubStretchWkTop #WT_SOLID "R" #TCUTR))     ; 戻り値 伸縮後のWT
        (setq #WT_SOLID$ (CFModList #WT_SOLID$ (list (list #i #WT_SOLID)))) ; 新しいWTに入れ替える
      )
    );_if
    (setq #TCUTL nil #TCUTR nil) ; 初期化が必要
    (setq #i (1+ #i))
  );_repeat

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ loop終了


  (setq #eWT_GAIKEI (MakeTEIMEN CG_GAIKEI)) ; 外形PLINE
  (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #eWT_GAIKEI)) (entget #eWT_GAIKEI)))

  (foreach WT_SOLID #WT_SOLID$
    (setq #setxd$ (CFGetXData WT_SOLID "G_WRKT"))
;-- 2011/09/30 A.Satoh Mod - S
;;;;;;-- 2011/09/09 A.Satoh Mod - S
;;;;;;    (setq #setxd$ (append #setxd$ (list #eWT_GAIKEI))) ; 01/08/24 YM MOD
;;;;;;    (CFSetXData WT_SOLID "G_WRKT" #setxd$)
;;;;;    (CFSetXData WT_SOLID "G_WRKT" (CFModList #SetXd$ (list (list 59 #eWT_GAIKEI))))
;;;;;;-- 2011/09/09 A.Satoh Mod - E
    (setq #oku$ (nth 57 #Setxd$))        ; 奥行き
    (cond
      ; U型
      ((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (> (nth 2 #oku$) 0.0))
        (setq #Keijo 2)
      )
      ; L型
      ((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (= (nth 2 #oku$) 0.0))
        (setq #Keijo 1)
      )
      ; I型
      (T
        (setq #Keijo 0)
      )
    )

    (CFSetXData WT_SOLID "G_WRKT"
      (CFModList #SetXd$
        (list
          (list  3 #Keijo)
          (list 59 #eWT_GAIKEI)
        )
      )
    )
;-- 2011/09/30 A.Satoh Mod - E
  )

;-- 2011/09/22 A.Satoh Mod - S
;;;;;;-- 2011/07/28 A.Satoh Add - S
;;;;;  ; カット線作図
;;;;;  (if (= #Keijo 1)  ; L型である場合
;;;;;    (progn
;;;;;      (setq #handle$ (AddWTCutLineL (car #WT_SOLID$) #WTInfo #CutID))
;;;;;      (if (/= #handle$ nil)
;;;;;        (foreach #WT_SOLID #WT_SOLID$
;;;;;          (setq #setxd$ (CFGetXData #WT_SOLID "G_WRKT"))
;;;;;          (CFSetXData #WT_SOLID "G_WRKT" (CFModList #SetXd$
;;;;;            (list
;;;;;              (list  9 (nth 4 #handle$))
;;;;;              (list 60 (nth 0 #handle$))
;;;;;              (list 61 (nth 1 #handle$))
;;;;;              (list 62 (nth 2 #handle$))
;;;;;              (list 63 (nth 3 #handle$))
;;;;;            )
;;;;;          ))
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;;-- 2011/08/25 A.Satoh Add - S
;;;;;    (if (= #Keijo 2) ; U型である場合
;;;;;      (progn
;;;;;        (setq #handle$ (AddWTCutLineU (car #WT_SOLID$) #WTInfo #CutID))
;;;;;        (if (/= #handle$ nil)
;;;;;          (foreach #WT_SOLID #WT_SOLID$
;;;;;            (setq #setxd$ (CFGetXData #WT_SOLID "G_WRKT"))
;;;;;            (CFSetXData #WT_SOLID "G_WRKT" (CFModList #SetXd$
;;;;;              (list
;;;;;                (list  9 (nth 4 #handle$))
;;;;;                (list 60 (nth 0 #handle$))
;;;;;                (list 61 (nth 1 #handle$))
;;;;;                (list 62 (nth 2 #handle$))
;;;;;                (list 63 (nth 3 #handle$))
;;;;;              )
;;;;;            ))
;;;;;          )
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;;-- 2011/08/25 A.Satoh Add - E
;;;;;  )
;;;;;;-- 2011/07/28 A.Satoh Add - E
  ; カット線作図
  (foreach WT_SOLID #WT_SOLID$
    (setq #Setxd$ (CFGetXData WT_SOLID "G_WRKT"))
    (setq #oku$ (nth 57 #Setxd$))        ; 奥行き
    (cond
      ((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (> (nth 2 #oku$) 0.0))
        (setq #handle$ (AddWTCutLineU WT_SOLID #WTInfo #CutID))
        (if (/= #handle$ nil)
          (progn
            (CFSetXData WT_SOLID "G_WRKT" (CFModList #SetXd$
              (list
                (list  9 (nth 4 #handle$))
                (list 60 (nth 0 #handle$))
                (list 61 (nth 1 #handle$))
                (list 62 (nth 2 #handle$))
                (list 63 (nth 3 #handle$))
              )
            ))
          )
        )
      )
      ((and (> (nth 0 #oku$) 0.0) (> (nth 1 #oku$) 0.0) (= (nth 2 #oku$) 0.0))
        (setq #handle$ (AddWTCutLineL WT_SOLID #WTInfo #CutID))
        (if (/= #handle$ nil)
          (progn
            (CFSetXData WT_SOLID "G_WRKT" (CFModList #SetXd$
              (list
                (list  9 (nth 4 #handle$))
                (list 60 (nth 0 #handle$))
                (list 61 (nth 1 #handle$))
                (list 62 (nth 2 #handle$))
                (list 63 (nth 3 #handle$))
              )
            ))
          )
        )
      )
    )
  )
;-- 2011/09/22 A.Satoh Mod - E

;-- 2012/04/20 A.Satoh Add シンク配置不具合対応 - S
  (foreach WT_SOLID #WT_SOLID$
		(setq #Setxd$ (CFGetXData WT_SOLID "G_WRKT"))
		(setq #snk_dep (getSinkDep WT_SOLID))
		(if (= #snk_dep nil)
			(setq #snk_dep 0.0)
		)

		(CFSetXData WT_SOLID "G_WRKT" (CFModList #SetXd$ (list (list 39 #snk_dep))))
	)
;-- 2012/04/20 A.Satoh Add シンク配置不具合対応 - E

  ;// 画層のフリーズ 底面画層
  (command "_layer" "F" SKW_AUTO_SECTION "")

;;; ｼｽﾃﾑ変数設定
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)
  (setvar "EDGEMODE"  #ed)
  #WT_SOLID$
);PK_MakeWorktop3

;-- 2011/07/28 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <関数名>    : AddWTCutLineL
;;; <処理概要>  : L型の場合天板にｶｯﾄﾗｲﾝを入れる(WT自動作成用)
;;; <戻り値>    : カットライン図形ハンドル
;;; <作成>      : 2011/07/28 A.Satoh
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun AddWTCutLineL (
  &WT       ; 天板図形
  &WTInfo   ; WTｼﾌﾄ量
  &CutID    ; カットID　0:カット無し 1:斜めカット 2:方向カット
  /
  #xd$ #hh #lr_flg #tei #BaseP #pt$ #p1 #p2 #p3 #p4 #p5 #p6 #p33 #p44 #p55
  #ddd1 #ddd2 #clayer #dumpt #x1 #x2 #y1 #y2 #CutDirect #BG_Width #BG_Height
  #wt_hand #handle1 #handle2 #handle$ #en #en_dum1 #en_dum2 #CutPt
  #BG_Type #dirt
  )

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

  (setq #handle$ nil)

  (setq #xd$ (CFGetXData &WT "G_WRKT"))
  (setq #hh     (nth  8 #xd$))        ; 天板高さ(下端取付高さ)
  (setq #hh (+ #hh (nth 10 #xd$)))    ; 天板高さに天板厚みを加算
  (setq #lr_flg (nth 30 #xd$))        ; 左右勝手フラグ
  (setq #tei    (nth 38 #xd$))        ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BaseP  (nth 32 #xd$))        ; WT左上点
  (setq #BG_Height (nth 12 #xd$))     ; バックガード高さ
  (setq #BG_Width (nth 13 #xd$))      ; バックガード厚さ
  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列

  ; 外形点列&pt$を#BASEPを先頭に時計周りにする
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))

  (setq #p1 (list (car #p1) (cadr #p1) #hh))
  (setq #p2 (list (car #p2) (cadr #p2) #hh))
  (setq #p3 (list (car #p3) (cadr #p3) #hh))
  (setq #p4 (list (car #p4) (cadr #p4) #hh))
  (setq #p5 (list (car #p5) (cadr #p5) #hh))
  (setq #p6 (list (car #p6) (cadr #p6) #hh))

  (setq #p33  (polar #p3   (angle #p2 #p3) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #p55  (polar #p5   (angle #p6 #p5) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #ddd1 (polar #p4   (angle #p2 #p3) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #ddd2 (polar #p4   (angle #p6 #p5) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #p44  (inters #p33 #ddd1 #p55 #ddd2 nil))

  ;;; 垂線の足を求める #x1,#x2
  (setq #x1 (CFGetDropPt #p44 (list #p1 #p2)))
  (setq #x2 (CFGetDropPt #p44 (list #p1 #p6)))

  ; 方向カットである場合、カット方向を求める
  (if (or (= &CutID 2)(= &CutID 3));2014/10/16 直線ｶｯﾄも方向指示
    (progn
      ; 現在のビュー情報を保存する
      (command "_.VIEW" "S" "TEMP_MRR")

      (command "_.VPOINT" (list 0 0 1))

      ; ｶｯﾄ方向指示する
      (MakeLWPL (list #p44 (polar #x1 (angle #p6 #p1) 100)) 0)
      (setq #en_dum1 (entlast))
      (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; 色を変える

      (MakeLWPL (list #p44 (polar #x2 (angle #p2 #p1) 100)) 0)
      (setq #en_dum2 (entlast))
      (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; 色を変える

      (setq #CutPt (getpoint "\nｶｯﾄ方向を指示:> "))
      (entdel #en_dum1)
      (entdel #en_dum2)

      (command "_.VIEW" "R" "TEMP_MRR")

      (if (< (distance #CutPt #x1) (distance #CutPt #x2))
        (setq #CutDirect "G")
        (setq #CutDirect "S")
      )
    )
    (setq #CutDirect "")
  )

  ;ﾗｲﾝ作図
  (if (/= 0 &CutID)
    (progn
      (setq #clayer (getvar "CLAYER"))
      (setvar "CLAYER" SKW_AUTO_SOLID)

;      ; 平面図
;      ;**************************************************************************
;      (defun AddWorkTopPlaneCutLine (
;        &WT ;天板図形
;        &pt$
;        /
;        #i #j #layer #sstmp #ss
;        )
;        (setq #ss (ssadd))
;        (foreach #i (list 1 2)
;          (setq #sstmp (ssadd))
;          (setq #layer (if (= #i 1) "Z_01_02_00_00" "Z_01_04_00_00"))
;          (MakeLayer #layer 7 "CONTINUOUS")
;          (setq #j 0)
;          (repeat (- (length &pt$) 1)
;            (command "_.line" (nth #j &pt$) (nth (+ #j 1) &pt$) "")
;            (ssadd (entlast) #ss)
;            (ssadd (entlast) #sstmp)
;            (setq #j (+ #j 1))
;          )
;          (command "chprop" #sstmp "" "LA" #layer "")
;        )
;        (ssadd &WT #ss)
;        (SKMkGroup #ss)
;      )
;      ;**************************************************************************
;
;(alert (strcat "#CutDirect = " #CutDirect "\n#lr_flg = " #lr_flg))
      (cond
        ((= &CutID 1)
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;斜めｶｯﾄ
          (command "_.3DPOLY" #p4 #p1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "X"))

          (setq #handle2 "")

          (setq #handle$ (list #handle1 "" "" "" ""))
;
;          ; 平面図
;          (AddWorkTopPlaneCutLine &WT (list #p4 #p1))
        )

        ((or (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "S")) ;上方向
             (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "S")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;右勝手でｼﾝｸ側ｶｯﾄ or 左勝手でｺﾝﾛ側ｶｯﾄ
          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #dumpt #x1 "")
          (setq #en (entlast))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #dumpt #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (if (and (= "L" #lr_flg) (= #CutDirect "S"))
            (setq #dirt "S")
            (setq #dirt "G")
          )
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
;          (setq #handle$ (list #handle1 #handle2 "" ""))
;
;          ; 平面図
;          (AddWorkTopPlaneCutLine &WT (list #p4 #dumpt #x1))
        )
        ((or (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "G")) ;左方向
             (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "G")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #dumpt #x1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #dumpt #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
            (setq #dirt "G")
            (setq #dirt "S")
          )
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
;
;          ; 平面図
;          (AddWorkTopPlaneCutLine &WT (list #p4 #dumpt #x2))
        )

				;2014/10/16 YM ADD 直線カット追加

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

        ((or (and (= "R" #lr_flg) (= &CutID 3) (= #CutDirect "S")) ;上方向
             (and (= "L" #lr_flg) (= &CutID 3) (= #CutDirect "S")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;右勝手でｼﾝｸ側ｶｯﾄ or 左勝手でｺﾝﾛ側ｶｯﾄ
          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #x1 "")
          (setq #en (entlast))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (setq #x2 (CFGetDropPt #p4 (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (if (and (= "L" #lr_flg) (= #CutDirect "S"))
            (setq #dirt "S")
            (setq #dirt "G")
          )
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))

        )
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

        ((or (and (= "L" #lr_flg) (= &CutID 3) (= #CutDirect "G")) ;左方向
             (and (= "R" #lr_flg) (= &CutID 3) (= #CutDirect "G")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #x1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (setq #x2 (CFGetDropPt #p4 (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
            (setq #dirt "G")
            (setq #dirt "S")
          )
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))

        )


        (T
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #dumpt #x1 "")
          (setq #en (entlast))

          (if (= #CutDirect "S")
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #dumpt #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (= #CutDirect "G")
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
            (setq #dirt "G")
            (setq #dirt "S")
          )
          (setq #handle$ (list #handle1 #handle2 "" "" ""))
;          (setq #handle$ nil)
        )
      );_cond

      (setvar "CLAYER" #clayer)
    )
    (setq #handle$ nil)
  );_if

  #handle$

);AddWTCutLineL
;-- 2011/07/28 A.Satoh Add - E



;;;<HOM>*************************************************************************
;;; <関数名>    : AddWTCutLineL
;;; <処理概要>  : L型の場合天板にｶｯﾄﾗｲﾝを入れる(WT自動作成用)
;;; <戻り値>    : カットライン図形ハンドル
;;; <作成>      : 2011/07/28 A.Satoh
;;; <備考>      : ★★★2015/01/09 EASYからコピーして関数名変更（引数が値違う）★★★_AUTO プラン検索用
;;;*************************************************************************>MOH<
(defun AddWTCutLineL_AUTO (
  &WT        ; 天板図形
  &WTInfo    ; WTｼﾌﾄ量
  &CutID     ; カットID　0:カット無し 1:斜めカット 2:方向カット 3:直線ｶｯﾄ
	&CutDirect ; カット方向(Jｶｯﾄ時のみ)
  /
  #xd$ #hh #lr_flg #tei #BaseP #pt$ #p1 #p2 #p3 #p4 #p5 #p6 #p33 #p44 #p55
  #ddd1 #ddd2 #clayer #dumpt #x1 #x2 #y1 #y2 #CutDirect #BG_Width #BG_Height
  #wt_hand #handle1 #handle2 #handle$ #en_dum1 #en_dum2 #CutPt
  #BG_Type #dirt #en
  )

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

  (setq #handle$ nil)

  (setq #xd$ (CFGetXData &WT "G_WRKT"))
  (setq #hh     (nth  8 #xd$))        ; 天板高さ(下端取付高さ)
  (setq #hh (+ #hh (nth 10 #xd$)))    ; 天板高さに天板厚みを加算
  (setq #lr_flg (nth 30 #xd$))        ; 左右勝手フラグ
  (setq #tei    (nth 38 #xd$))        ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BaseP  (nth 32 #xd$))        ; WT左上点
  (setq #BG_Height (nth 12 #xd$))     ; バックガード高さ
  (setq #BG_Width (nth 13 #xd$))      ; バックガード厚さ
  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列

  ; 外形点列&pt$を#BASEPを先頭に時計周りにする
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))

  (setq #p1 (list (car #p1) (cadr #p1) #hh))
  (setq #p2 (list (car #p2) (cadr #p2) #hh))
  (setq #p3 (list (car #p3) (cadr #p3) #hh))
  (setq #p4 (list (car #p4) (cadr #p4) #hh))
  (setq #p5 (list (car #p5) (cadr #p5) #hh))
  (setq #p6 (list (car #p6) (cadr #p6) #hh))

  (setq #p33  (polar #p3   (angle #p2 #p3) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #p55  (polar #p5   (angle #p6 #p5) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #ddd1 (polar #p4   (angle #p2 #p3) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #ddd2 (polar #p4   (angle #p6 #p5) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #p44  (inters #p33 #ddd1 #p55 #ddd2 nil))

  ;;; 垂線の足を求める #x1,#x2
  (setq #x1 (CFGetDropPt #p44 (list #p1 #p2)))
  (setq #x2 (CFGetDropPt #p44 (list #p1 #p6)))

	;2014/12/15 YM DEL-S 引数で渡す
;;;  ; 方向カットである場合、カット方向を求める
  (if (= &CutID 2) ;2014/10/16 直線ｶｯﾄも方向指示
    (progn
        (setq #CutDirect &CutDirect);引数
;;;      ; 現在のビュー情報を保存する
;;;      (command "_.VIEW" "S" "TEMP_MRR")
;;;
;;;      (command "_.VPOINT" (list 0 0 1))
;;;
;;;      ; ｶｯﾄ方向指示する
;;;      (MakeLWPL (list #p44 (polar #x1 (angle #p6 #p1) 100)) 0)
;;;      (setq #en_dum1 (entlast))
;;;      (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;;;      (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; 色を変える
;;;
;;;      (MakeLWPL (list #p44 (polar #x2 (angle #p2 #p1) 100)) 0)
;;;      (setq #en_dum2 (entlast))
;;;      (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;;;      (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; 色を変える
;;;
;;;      (setq #CutPt (getpoint "\nｶｯﾄ方向を指示:> "))
;;;      (entdel #en_dum1)
;;;      (entdel #en_dum2)
;;;
;;;      (command "_.VIEW" "R" "TEMP_MRR")
;;;
;;;      (if (< (distance #CutPt #x1) (distance #CutPt #x2))
;;;        (setq #CutDirect "G")
;;;        (setq #CutDirect "S")
;;;      )
    )
		;else
    (setq #CutDirect "")
  );_if

  (if (= &CutID 3) ;2014/10/16 直線ｶｯﾄはｼﾝｸ側固定
    (setq #CutDirect "S");ｼﾝｸ側
	);_if
	;2014/12/15 YM DEL-E 引数で渡す


  ;ﾗｲﾝ作図
  (if (/= 0 &CutID)
    (progn
      (setq #clayer (getvar "CLAYER"))
      (setvar "CLAYER" SKW_AUTO_SOLID)

      (cond
        ((= &CutID 1);斜めｶｯﾄ
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;斜めｶｯﾄ
          (command "_.3DPOLY" #p4 #p1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "X"))

          (setq #handle2 "")

          (setq #handle$ (list #handle1 "" "" "" ""))
        )

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

        ((or (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "S")) ;上方向(Jｶｯﾄ)
             (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "G")))

          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;右勝手でｼﾝｸ側ｶｯﾄ or 左勝手でｺﾝﾛ側ｶｯﾄ
          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS");ﾌﾘｰｽﾞするｶｯﾄﾗｲﾝ画層

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))

          (command "_.3DPOLY" #p4 #dumpt #x1 "");上側ｶｯﾄﾗｲﾝ(ﾌﾘｰｽﾞしない)
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))
          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))


          (command "_.3DPOLY" #p4 #dumpt #x2 "");左側ｶｯﾄﾗｲﾝ
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "");画層をﾌﾘｰｽﾞ画層に変更
          (command "_.LAYER" "F" "WTCUT_HIDE" "");画層をﾌﾘｰｽﾞ

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))


				 ;2015/01/09 YM MOD-S
				 (setq #dirt #CutDirect)
;;;          (if (and (= "L" #lr_flg) (= #CutDirect "S"))
;;;            (setq #dirt "S")
;;;            (setq #dirt "G")
;;;          )
				 ;2015/01/09 YM MOD-E
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
        )

        ((or (and (= "L" #lr_flg) (= &CutID 2) (= #CutDirect "S")) ;左方向(Jｶｯﾄ)
             (and (= "R" #lr_flg) (= &CutID 2) (= #CutDirect "G")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))

          (command "_.3DPOLY" #p4 #dumpt #x1 "");上側ｶｯﾄﾗｲﾝ(ﾌﾘｰｽﾞする)
          (setq #en (entlast))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle1 (cdr (assoc 5 (entget #en))))
          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))


          (command "_.3DPOLY" #p4 #dumpt #x2 "")
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

				 ;2015/01/09 YM MOD-S
				 (setq #dirt #CutDirect)
;;;          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
;;;            (setq #dirt "G")
;;;            (setq #dirt "S")
;;;          )
				 ;2015/01/09 YM MOD-E
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))
        )


				;2014/10/16 YM ADD 直線カット追加

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

        ((or (and (= "R" #lr_flg) (= &CutID 3) (= #CutDirect "S")) ;上方向(直線ｶｯﾄ)
             (and (= "L" #lr_flg) (= &CutID 3) (= #CutDirect "G")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ;右勝手でｼﾝｸ側ｶｯﾄ or 左勝手でｺﾝﾛ側ｶｯﾄ
          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #x1 "")
          (setq #en (entlast))

          (setq #handle1 (cdr (assoc 5 (entget #en))))
          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (setq #x2 (CFGetDropPt #p4 (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #x2 "")
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

				 ;2015/01/09 YM MOD-S
				 (setq #dirt #CutDirect)
;;;          (if (and (= "L" #lr_flg) (= #CutDirect "S"))
;;;            (setq #dirt "S")
;;;            (setq #dirt "G")
;;;          )
				 ;2015/01/09 YM MOD-E
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))

        )
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

        ((or (and (= "L" #lr_flg) (= &CutID 3) (= #CutDirect "S")) ;左方向(直線ｶｯﾄ)
             (and (= "R" #lr_flg) (= &CutID 3) (= #CutDirect "G")))
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #x1 "")
          (setq #en (entlast))

          (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
          (command "_.LAYER" "F" "WTCUT_HIDE" "")

          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

          (setq #x2 (CFGetDropPt #p4 (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #x2 "")
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "S"))

				 ;2015/01/09 YM MOD-S
				 (setq #dirt #CutDirect)
;;;          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
;;;            (setq #dirt "G")
;;;            (setq #dirt "S")
;;;          )
				 ;2015/01/09 YM MOD-E
          (setq #handle$ (list #handle1 #handle2 "" "" #dirt))

        )


        (T
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")

          (setq #dumpt (polar #p4 (angle #p3 #p2) #BG_Height))
          (setq #dumpt (polar #dumpt (angle #p2 #p1) #BG_Height))
          (setq #x1 (CFGetDropPt #dumpt (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #dumpt #x1 "")
          (setq #en (entlast))

          (if (= #CutDirect "S")
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (setq #wt_hand (cdr (assoc 5 (entget &WT))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (setq #x2 (CFGetDropPt #dumpt (list #p1 #p6)))
          (command "_.3DPOLY" #p4 #dumpt #x2 "")
          (setq #en (entlast))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (= #CutDirect "G")
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #handle2 (cdr (assoc 5 (entget #en))))

;;;          (if (and (= "L" #lr_flg) (= #CutDirect "G"))
;;;            (setq #dirt "G")
;;;            (setq #dirt "S")
;;;          )
          (setq #handle$ (list #handle1 #handle2 "" "" ""))
        )
      )

      (setvar "CLAYER" #clayer)
    )
    (setq #handle$ nil)
  )

  #handle$

);AddWTCutLineL


;-- 2011/08/25 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <関数名>    : AddWTCutLineU
;;; <処理概要>  : U型の場合天板にｶｯﾄﾗｲﾝを入れる(WT自動作成用)
;;; <戻り値>    : カットライン図形ハンドルリスト
;;; <作成>      : 2011/08/25 A.Satoh
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun AddWTCutLineU (
  &WT       ; 天板図形
  &WTInfo   ; WTｼﾌﾄ量
  &CutID    ; カットID　0:カット無し 1:斜めカット 2:方向カット
  /
  #handle$ #CutPt1 #CutPt2 #en_dum1 #en_dum2
  #xd$ #hh #lr_flg #tei #BaseP #BG_Height #BG_Width #pt$
  #pt$ #p1 #p2 #p3 #p4 #p5 #p6 #p7 #p8
  #p33 #p44 #p55 #p66 #ddd #ddd1 #ddd2 #ddd3 #ddd4 #ang #x1 #x2 #x3 #x4
  #ptn #clayer #wt_hand #en #handle1 #handle2
  )

  (setq #handle$ nil)

;;; p1+----------+-------------------+p2
;;;   |          x1     +----+       |
;;;   |          |      | S  |       |
;;;   |          |      +----+       |
;;;   +x2--------+-------------------+p3
;;;   |          |p4
;;;   |          |
;;;   |          |
;;;   |          |p5
;;;   +x3--------+-------------------+p6
;;;   |          |                   |
;;;   |          |                   |
;;;   |          x4                  |
;;; p8+----------+-------------------+p7

  (setq #xd$ (CFGetXData &WT "G_WRKT"))
  (setq #hh     (nth  8 #xd$))        ; 天板高さ(下端取付高さ)
  (setq #hh (+ #hh (nth 10 #xd$)))    ; 天板高さに天板厚みを加算
  (setq #lr_flg (nth 30 #xd$))        ; 左右勝手フラグ
  (setq #tei    (nth 38 #xd$))        ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #BaseP  (nth 32 #xd$))        ; WT左上点
  (setq #BG_Height (nth 12 #xd$))     ; バックガード高さ
  (setq #BG_Width (nth 13 #xd$))      ; バックガード厚さ
  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列

  ; 外形点列&pt$を#BASEPを先頭に時計周りにする
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))
  (setq #p7 (nth 6 #pt$))
  (setq #p8 (nth 7 #pt$))

  (setq #p1 (list (car #p1) (cadr #p1) #hh))
  (setq #p2 (list (car #p2) (cadr #p2) #hh))
  (setq #p3 (list (car #p3) (cadr #p3) #hh))
  (setq #p4 (list (car #p4) (cadr #p4) #hh))
  (setq #p5 (list (car #p5) (cadr #p5) #hh))
  (setq #p6 (list (car #p6) (cadr #p6) #hh))
  (setq #p7 (list (car #p7) (cadr #p7) #hh))
  (setq #p8 (list (car #p8) (cadr #p8) #hh))

  (setq #p33  (polar #p3   (angle #p2 #p3) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #p66  (polar #p6   (angle #p7 #p6) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #ddd (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #ang (angle #ddd #p4))
  (setq #ddd1 (polar #p4   (angle #p2 #p3) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #ddd2 (polar #p4   #ang            (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #ddd3 (polar #p5   #ang            (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #ddd4 (polar #p5   (angle #p7 #p6) (nth 6 &WTInfo))) ; WTｼﾌﾄ量分
  (setq #p44  (inters #p33 #ddd1 #ddd2 #ddd3 nil))
  (setq #p55  (inters #ddd2 #ddd3 #p66 #ddd4 nil))

  ;;; 垂線の足を求める #x1,#x2
  (setq #x1 (CFGetDropPt #p44 (list #p1 #p2)))
  (setq #x2 (CFGetDropPt #p44 (list #p1 #p8)))
  (setq #x3 (CFGetDropPt #p55 (list #p1 #p8)))
  (setq #x4 (CFGetDropPt #p55 (list #p7 #p8)))

  ; 方向カットである場合、カット方向を求める
  (if (= &CutID 2)
    (progn
      ; 現在のビュー情報を保存する
      (command "_.VIEW" "S" "TEMP_MRR")

      (command "_.VPOINT" (list 0 0 1))

      ;;; ﾕｰｻﾞｰにｶｯﾄ方向を指示
      (setq #CutPt1 nil)
      (setq #CutPt2 nil)

      (MakeLWPL (list #p44 (polar #x1 (angle #p8 #p1) 100)) 0) ; 01/06/25 YM MOD
      (setq #en_dum1 (entlast))
      (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; 色を変える

      (MakeLWPL (list #p44 (polar #x2 (angle #p2 #p1) 100)) 0) ; 01/06/25 YM MOD
      (setq #en_dum2 (entlast))
      (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; 色を変える

      (setq #CutPt1 (getpoint "\nカット方向を指示: "))
      (entdel #en_dum1)
      (entdel #en_dum2)

      (MakeLWPL (list #p55 (polar #x3 (angle #p2 #p1) 100)) 0) ; 01/06/25 YM MOD
      (setq #en_dum1 (entlast))
      (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; 色を変える

      (MakeLWPL (list #p55 (polar #x4 (angle #p1 #p8) 100)) 0) ; 01/06/25 YM MOD
      (setq #en_dum2 (entlast))
      (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
      (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; 色を変える

      (setq #CutPt2 (getpoint "\nカット方向を指示: "))
      (entdel #en_dum1)
      (entdel #en_dum2)

      (command "_.VIEW" "R" "TEMP_MRR")

;;; Xｶｯﾄの方向指示 U配列の場合、方向指示を2回行う
;;;   +--------(1)-----------------+
;;;   |         |                  |
;;;   |         |                  |
;;;  (2)--------+------------------+
;;;   |         | ﾊﾟﾀｰﾝ (1)と(3)=>#ptn=1
;;;   |         |       (1)と(4)=>#ptn=2
;;;   |         |       (2)と(3)=>#ptn=3
;;;   |         |       (2)と(4)=>#ptn=4
;;;  (3)--------+------------------+
;;;   |         |                  |
;;;   |         |                  |
;;;   +--------(4)-----------------+

      (if (< (distance #CutPt1 #x1) (distance #CutPt1 #x2))
        (progn
          (if (< (distance #CutPt2 #x3) (distance #CutPt2 #x4))
            (setq #ptn 1)
            (setq #ptn 2)
          )
        )
        (progn
          (if (< (distance #CutPt2 #x3) (distance #CutPt2 #x4))
            (setq #ptn 3)
            (setq #ptn 4)
          )
        )
      );_if
    )
  )

  ;ﾗｲﾝ作図
  (if (/= 0 &CutID)
    (progn
      (setq #clayer (getvar "CLAYER"))
      (setvar "CLAYER" SKW_AUTO_SOLID)

      (cond
        ((= &CutID 1)
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          ; 斜めｶｯﾄ
          (setq #wt_hand (cdr (assoc 5 (entget &WT))))

          (command "_.3DPOLY" #p4 #p1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "X"))

          (command "_.3DPOLY" #p5 #p8 "")
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))

          (CFSetXData #en "G_CUTLINE" (list #wt_hand "X"))

          (setq #handle$ (list #handle1 "" #handle2 "" ""))
        )
        ((= &CutID 2)
          (if (not (tblsearch "APPID" "G_CUTLINE")) (regapp "G_CUTLINE"))

          (MakeLayer "WTCUT_HIDE" 7 "CONTINUOUS")
          (setq #wt_hand (cdr (assoc 5 (entget &WT))))

          (setq #sp1 (polar #p44 (angle #p8 #p1) #BG_Height))
          (setq #sp1 (polar #sp1 (angle #p2 #p1) #BG_Height))
          (setq #sp2 (polar #p55 (angle #p2 #p1) #BG_Height))
          (setq #sp2 (polar #sp2 (angle #p1 #p8) #BG_Height))

          (setq #x1 (CFGetDropPt #sp1 (list #p1 #p2)))
          (command "_.3DPOLY" #p4 #sp1 #x1 "")
          (setq #en (entlast))
          (setq #handle1 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (or (= #ptn 3) (= #ptn 4))
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #x2 (CFGetDropPt #sp1 (list #p1 #p8)))
          (command "_.3DPOLY" #p4 #sp1 #x2 "")
          (setq #en (entlast))
          (setq #handle2 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (or (= #ptn 1) (= #ptn 2))
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #x3 (CFGetDropPt #sp2 (list #p1 #p8)))
          (command "_.3DPOLY" #p5 #sp2 #x3 "")
          (setq #en (entlast))
          (setq #handle3 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (or (= #ptn 2) (= #ptn 4))
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #x4 (CFGetDropPt #sp2 (list #p7 #p8)))
          (command "_.3DPOLY" #p5 #sp2 #x4 "")
          (setq #en (entlast))
          (setq #handle4 (cdr (assoc 5 (entget #en))))
          (CFSetXData #en "G_CUTLINE" (list #wt_hand "J"))

          (if (or (= #ptn 1) (= #ptn 3))
            (progn
              (command "_.CHANGE" #en "" "P" "LA" "WTCUT_HIDE" "")
              (command "_.LAYER" "F" "WTCUT_HIDE" "")
            )
          )

          (setq #handle$ (list #handle1 #handle2 #handle3 #handle4 ""))

        )
        (T
          (setq #handle$ nil)
        )
      );_cond

      (setvar "CLAYER" #clayer)
    )
    (setq #handle$ nil)
  );_if

  #handle$

);AddWTCutLineU
;-- 2011/08/25 A.Satoh Add - E

;<HOM>*************************************************************************
; <関数名>    : FullSemiFlatHantei
; <処理概要>  : ﾌﾙﾌﾗｯﾄ,ｾﾐﾌﾗｯﾄ判定
; <戻り値>    : "SF"：ｾﾐﾌﾗｯﾄ,"FF"：ﾌﾙﾌﾗｯﾄ,""：それ以外
; <作成>      : 04/04/09 YM
; <備考>      : Errmsg.ini参照
;               ★★★　2009/04/17 YM 未使用★★★
;*************************************************************************>MOH<
(defun FullSemiFlatHantei (
  &dep$ ; WT奥行き
  /
  #FULLFLAT #RET #SEMIFLAT
  )
  (setq #ret "")
  (cond
    ((= "D105" (nth 7 CG_GLOBAL$))
      (setq #ret "D105")
    )
    ((= "D970" (nth 7 CG_GLOBAL$))
      (setq #ret "D970")
    )
    ((= "D900" (nth 7 CG_GLOBAL$))
      (setq #ret "D900")
    )
    (T
      (setq #ret "")
    )
  );_cond

  #ret
);FullSemiFlatHantei

;<HOM>*************************************************************************
; <関数名>    : KPGetLowCabDimW
; <処理概要>  : ﾛｰｷｬﾋﾞの間口を返す
; <戻り値>    : ﾛｰｷｬﾋﾞの間口(実数)
; <作成>      : 01/03/23 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KPGetLowCabDimW (
  &en_LOW$ ; ﾛｰｷｬﾋﾞｼﾝﾎﾞﾙ図形ﾘｽﾄ
  /
  #RET
  )
  (setq #ret 0)
  (foreach en &en_LOW$
    (setq #ret (+ #ret (nth 3 (CFGetXData en "G_SYM"))))
  )
  #ret
);KPGetLowCabDimW


;<HOM>*************************************************************************
; <関数名>    : PKWT_INFO_Dlg
; <処理概要>  : WT情報ダイアログ
;               WT素材検索でレコードがとれなかったときに表示する
; <作成>      : 2000.3.29  YM
;*************************************************************************>MOH<
(defun PKWT_INFO_Dlg (
  /
  #WTInfo #dcl_id ##GetDlgItem
  )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( /
            #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #WTInfo
            #BG_SEP #WT_H)

            (cond
              ((##Check "WT_H" (get_tile "WT_H") "ﾜｰｸﾄｯﾌﾟ高さ")   nil)
              ((##Check "WT_T" (get_tile "WT_T") "ﾜｰｸﾄｯﾌﾟ厚み")   nil)
              ((##Check "BG_H" (get_tile "BG_H") "ﾊﾞｯｸｶﾞｰﾄﾞ高さ") nil)
              ((##Check "BG_T" (get_tile "BG_T") "ﾊﾞｯｸｶﾞｰﾄﾞ厚み") nil)
              ((##Check "FG_H" (get_tile "FG_H") "前垂れ高さ")    nil)
              ((##Check "FG_T" (get_tile "FG_T") "前垂れ厚み")    nil)
              ((##Check "FG_S" (get_tile "FG_S") "前垂れｼﾌﾄ")     nil)
              (t ; ｴﾗｰがない場合
                  (setq #WT_H (atoi (get_tile "WT_H"))) ; WTの高さ
                  (setq #WT_T (atoi (get_tile "WT_T"))) ; WTの厚み
                  (setq #BG_H (atoi (get_tile "BG_H"))) ; BGの高さ
                  (setq #BG_T (atoi (get_tile "BG_T"))) ; BGの厚み
                  (setq #FG_H (atoi (get_tile "FG_H"))) ; FGの高さ
                  (setq #FG_T (atoi (get_tile "FG_T"))) ; FGの厚み
                  (setq #FG_S (atoi (get_tile "FG_S"))) ; 前垂れｼﾌﾄ量
                  (if (= (get_tile "BG_Sep") "1") ; ﾊﾞｯｸｶﾞｰﾄﾞ分離
                    (setq #BG_Sep "Y" )
                    (setq #BG_Sep "N" )
                  );_if
                  (setq #WTInfo (list #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep))
                (done_dialog)
              )
            );_cond
            #WTInfo
          )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Check (&sKEY &sVAL &sNAME / )
            (if (= nil (and (numberp (read &sVAL)) (< 0 (read &sVAL))))
              (progn
                (alert (strcat &sNAME "欄に" "\n 数値を入力してください (1～9 の半角数字)"))
                (mode_tile &sKEY 2)
                (eval 'T) ; ｴﾗｰあり
              );end of progn
            ); end of if
          ); end of ##Check
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "WT_INFO_Dlg" #dcl_id)) (exit))

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #WTInfo (##GetDlgItem))")
  (action_tile "cancel" "(setq #WTInfo nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #WTInfo
);PKWT_INFO_Dlg

;;;<HOM>*************************************************************************
;;; <関数名>    : MakeTEIMEN
;;; <処理概要>  : 点リスト-->閉じた底面ﾎﾟﾘﾗｲﾝ図形名を返す
;;; <戻り値>    : 図形名
;;; <作成>      : 2000.4.20 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun MakeTEIMEN ( &pt$ /  )
  (MakeLWPL &pt$ 1)
  (entlast)
)

;;;<HOM>*************************************************************************
;;; <関数名>    : PKSLOWPLCP
;;; <処理概要>  : 点 &pt のまわりに&outpl_LOW(ﾛｰﾀｲﾌﾟｷｬﾋﾞ外形ﾎﾟﾘﾗｲﾝ)があれば  #res1=T なければ nil
;;; <戻り値>    : T or nil
;;; <作成>      : 2000.4.13 YM ｶｯﾄ記号"T","L"対応 4.17修正
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;*************************************************************************>MOH<
(defun PKSLOWPLCP (
  &pt
  &outpl
  /
  #ELM
  #HAND #HAND0
  #I #P0$
  #P01 #P02 #P03 #P04
  #RET1 #RET2 #SS00
  #HINBAN #SYM
  )

  (setq #hand0 (cdr (assoc 5 (entget &outpl))))       ; ﾎﾟﾘﾗｲﾝﾊﾝﾄﾞﾙ
  (setq #p01 (list (- (car &pt) 1) (+ (cadr &pt)   1))) ; 左上
  (setq #p02 (list (- (car &pt) 1) (- (cadr &pt) 101))) ; 左下
  (setq #p03 (list (+ (car &pt) 1) (- (cadr &pt) 101))) ; 右下
  (setq #p04 (list (+ (car &pt) 1) (+ (cadr &pt)   1))) ; 右上

  (setq #p0$ (list #p01 #p02 #p03 #p04 #p01))

  (setq #ss00 (ssget "CP" #p0$))

  (setq #i 0 #ret1 nil)
  (while (< #i (sslength #ss00))
    (setq #elm (ssname #ss00 #i))
    (setq #hand (cdr (assoc 5 (entget #elm))))
    (if (equal #hand0 #hand) ; ﾛｰﾀｲﾌﾟｷｬﾋﾞ外形ﾎﾟﾘﾗｲﾝと一致したら
      (setq #ret1 T)
    );_if
    (setq #i (1+ #i))
  )
  #ret1 ; 00/04/17 YM 品番確定で検索する
);PKSLOWPLCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKMakeWT_BG_FG_Pline
;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成
;;; <戻り値>    : ((WT底面図形名,BG底面図形名,FG底面図形名,cut type),...)
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKMakeWT_BG_FG_Pline (
  &pt$$        ; WTを貼る外形PLINE点列のﾘｽﾄ
  &base_new$   ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ
  &CG_WtDepth  ; 0,1,10,100 WT拡張フラグ
  &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
  &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
  &WTInfo2     ; WT情報2  (#BG_S2 #BG_Type2 #FG_Type2)
  &WTInfo3     ; WT情報3  (#BG_S3 #BG_Type3 #FG_Type3)
  &CutId       ; ｶｯﾄID 0,1,2 なし,斜めH,方向指示
  &outpl_LOW   ;
  &ZaiCode     ; 材質記号
  /
  #FLG #K #KOSU #LIS$
  #PT$ #RET$ #RET0$
  #DEP #dep$ #RAPIS #MSG
  #BASE_NEW$ #I #SSLSYM ; 01/08/20 YM ADD
  )
  (command "vpoint" "0,0,1")
  (setq #lis$ (FlagToList &CG_WtDepth)) ; WT拡張ﾌﾗｸﾞをﾘｽﾄ化 (? ? ?)
  (setq #k 0)
  (setq #ret$ '() #flg nil)
  (repeat (length &pt$$)       ; 外形領域の数だけ繰り返し
    (setq #pt$ (nth #k &pt$$)) ; PLINE点列 (@@@)
    (setq #kosu (length #pt$))
;;;****************************************************************************
    (cond
      ((= #kosu 4) ; I形状
        ; 01/08/20 BGが横を向く不具合対応 START --------------
        (if (< 1 (length &pt$$)) ; 01/08/27 YM MOD
          (progn ; WT複数のとき
            (setq #ssLSYM (ssget "CP" (AddPtList #pt$) (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
            (if (and #ssLSYM (> (sslength #ssLSYM) 0))
              (progn ; &base_new$ の中で #ssLSYM と一致するものを取得
                (setq #base_new$ nil)
                (foreach base_new &base_new$
                  (setq #i 0)
                  (repeat (sslength #ssLSYM)
                    (if (equal base_new (ssname #ssLSYM #i))
                      (setq #base_new$ (append #base_new$ (list base_new)))
                    );_if
                    (setq #i (1+ #i))
                  )
                );foreach
              )
              (setq #base_new$ &base_new$)
            );_if
          )
          (setq #base_new$ &base_new$) ; 今まで通りWT1枚だけ
        );_if
        ; 01/08/20 BGが横を向く不具合対応 END -----------------

        (setq #ret0$
          (PKMakeTeimenPline_I
            #pt$
;;;01/08/20YM@            &base_new$   ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ   Iのみ
            #base_new$   ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ   Iのみ ; 01/08/20 YM BGが横を向く不具合対応
;;;            #lis$        ; WT拡張フラグ ; 01/08/27 YM DEL
            &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
            &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
            &outpl_LOW   ;
            &ZaiCode     ; 材質記号
          )
        )
      )
      ((= #kosu 6) ; L形状
        (setq #ret0$
          (PKMakeTeimenPline_L
            #pt$
;;;            #lis$        ; WT拡張フラグ ; 01/08/27 YM DEL
            &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
            &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
            &WTInfo2     ; WT情報2  (#BG_S2 #BG_Type2 #FG_Type2)
            &WTInfo3     ; WT情報3  (#BG_S3 #BG_Type3 #FG_Type3)
            &CutId       ; ｶｯﾄID 0,1,2 なし,斜めH,方向指示  L,Uのみ
            &outpl_LOW   ;
            &ZaiCode     ; 材質記号
          )
        )
      )
      ((= #kosu 8) ; U形状
        (setq #ret0$
          (PKMakeTeimenPline_U
            #pt$
;;;            #lis$        ; WT拡張フラグ ; 01/08/27 YM DEL
            &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
            &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
            &WTInfo2     ; WT情報2  (#BG_S2 #BG_Type2 #FG_Type2)
            &WTInfo3     ; WT情報3  (#BG_S3 #BG_Type3 #FG_Type3)
            &CutId       ; ｶｯﾄID 0,1,2 なし,斜めH,方向指示  L,Uのみ
            &outpl_LOW   ;
            &ZaiCode     ; 材質記号
          )
        )
      )
      (T
        (setq #msg "ｷｬﾋﾞﾈｯﾄの前面が合っていないか、外形領域が正しくありません")
        (CMN_OutMsg #msg) ; 02/09/05 YM ADD
;-- 2011/09/09 A.Satoh Add - S
        (exit)
;-- 2011/09/09 A.Satoh Add - E
      )
    );_cond
;;;****************************************************************************
    (setq #ret$ (append #ret$ #ret0$)) ; #ret$ に #ret0$ を追加する
    (setq #k (1+ #k))
  );_repeat

  ; 段差部も含めたWT外形点列に前垂れ,WT奥行き拡張を考慮する 01/08/24 YM ADD-S
    (setq #kosu (length CG_GAIKEI)) ; 点列個数
    (cond
      ((= #kosu 4) ; I形状
        nil ; 何もしない
      )
      ((= #kosu 6) ; L形状
        (PKMakeTeimenPline_L_ALL
          &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
          &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
          &WTInfo2     ; WT情報2  (#BG_S2 #BG_Type2 #FG_Type2)
        )
      )
      ((= #kosu 8) ; U形状
        (PKMakeTeimenPline_U_ALL
          &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
          &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
          &WTInfo2     ; WT情報2  (#BG_S2 #BG_Type2 #FG_Type2)
          &WTInfo3     ; WT情報3  (#BG_S3 #BG_Type3 #FG_Type3)
        )
      )
      (T
        nil ; 何もしない
      )
    );_cond
;;;****************************************************************************


  ; 段差部も含めたWT外形に前垂れ,WT奥行き拡張を考慮する 01/08/24 YM ADD-E

  (command "zoom" "p")
  #ret$
);PKMakeWT_BG_FG_Pline

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_GetBG_FG_Teimen
;;; <処理概要>  : BG,FGﾌﾗｸﾞからBG,FG底面ﾎﾟﾘﾗｲﾝを求める
;;; <戻り値>    : (BGﾘｽﾄ,FGﾘｽﾄ)
;;; <作成>      : 00/09/25 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PK_GetBG_FG_Teimen (
  &bg_en$  ;BGﾘｽﾄ
  &fg_en$  ;FGﾘｽﾄ
  &BG_Type ;BG有無 0:なし,1:あり
  &FG_Type ;FGﾀｲﾌﾟ 1:背面,2:両面
  /
  #BG_EN$ #FG_EN$ #FG_EN2
  )
  (if (equal &FG_Type 2 0.1)
    (progn ; FG両側
      (setq #fg_en2 (car &bg_en$))
      (setq #fg_en$ (list (car &fg_en$) #fg_en2))
    )
    (setq #fg_en$ &fg_en$) ; FG通常
  );_if

  (if (equal &BG_Type 0 0.1)
    (setq #bg_en$ nil)     ; BGなし
    (setq #bg_en$ &bg_en$) ; BGあり
  );_if

  (list #bg_en$ #fg_en$)
);PK_GetBG_FG_Teimen

;;;<HOM>*************************************************************************
;;; <関数名>    : PKMakeTeimenPline_I
;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成
;;; <戻り値>    :
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKMakeTeimenPline_I (
  &pt$         ; 各WT外形点列 4,6,8点のみ
  &base_new$   ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ   Iのみ
;;;  &lis$        ; WT拡張フラグ ; 01/08/27 YM DEL
;;;  &WTInfo      ; WT情報(#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S)
  &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
  &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
  &outpl_LOW   ;
  &ZaiCode     ; 材質記号
  /
	#BASEPT #BG_EN$ #BG_EN1 #BG_EN2 #BG_S #BG_T #BG_TYPE #CUT_TYPE #DEP
	#DUMPT1 #DUMPT2 #FG_EN$ #FG_EN1 #FG_EN2 #FG_S #FG_T #FG_TYPE #OFFSETL #OFFSETR
	#P1 #P11 #P111 #P111WTR #P11WTR #P1WTR
	#P2 #P22                #P22WTR #P2WTR
	#P3 #P33 #P333 #P333WTL #P33WTL #P3WTL
	#P4 #P44                #P44WTL #P4WTL
	#PA #PAFGR
	#PB #PBFGR
	#PC #PCFGL
	#PD #PDFGL
	#PE #PEFGR
	#PF #PFFGL
	#PGFGR
	#PHFGL
	#PT$ #RET #RET$ #SA #TOP_FLG #WT_BASE #WT_EN #WT_LEN
  )
  (setq #pt$ &pt$)
  (setq #BG_T    (nth 3 &WTInfo )) ; BGの厚み <<<12mm>>>
  (setq #FG_T    (nth 5 &WTInfo )) ; FGの厚み <<<20mm>>>

	;2016/02/23 もしBG厚み=0なら前垂れ厚みの値を代入しておく　#BG_Type=1のとき使用
	(if (equal #BG_T 0.0 0.1)
		(if (equal #FG_T 0.0 0.1)
			(setq #BG_T 20);ダミー落ちるのを防止
			;else
			(setq #BG_T #FG_T)
		);_if
	);_if ;2016/02/16 YM ADD

  (setq #FG_S    (nth 6 &WTInfo )) ; 前垂れシフト量
  (setq #TOP_FLG (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
  (setq #BG_S    (nth 0 &WTInfo1)) ; 後垂れシフト量

  (setq #BG_Type (nth 1 &WTInfo1)) ; BG有無 1:あり 0:なし
  (setq #FG_Type (nth 2 &WTInfo1)) ; FGﾀｲﾌﾟ 1:FG前側 2:FG両側

  (setq #offsetL  (nth 3 &WTInfo1)) ; 左勝手時ｼﾝｸ側(左側)ｵﾌｾｯﾄ値
  (setq #offsetR  (nth 4 &WTInfo1)) ; 左勝手時ｺﾝﾛ側(右側)ｵﾌｾｯﾄ値
  

  ;;; 新ﾛｼﾞｯｸ 外形点列-->ｺｰﾅｰ基点 PKGetBaseL6
  (setq #BASEPT (PKGetBaseI4 #pt$ &base_new$)) ; 点列とｼﾝﾎﾞﾙﾘｽﾄ(ｼﾝﾎﾞﾙとｺｰﾅｰ基点は必ずしも一致しない)
  ;;; 外形点列を求める.I型
  (setq #pt$ (GetPtSeries #BASEPT #pt$)) ; 点列内の#BASEPTを先頭に時計周りにする
  (setq #p4 (nth 0 #pt$)) ; #p1,2,3,4 順番注意
  (setq #p2 (nth 1 #pt$))
  (setq #p1 (nth 2 #pt$))
  (setq #p3 (nth 3 #pt$))
  ;;; WT拡張対応 必要なら#p2 #p4を求め直し
  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL (if (> #BG_S 0.1)
;;;02/01/21YM@DEL    (progn

;;; ＜I型＞奥行き延長量を考慮
;;;  BASE=p4------------------------+p2   <---BG背面
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  +p3----------------------------+p1
      (setq #sa #BG_S);奥行き延長量
      (setq #p2 (polar #p2 (angle #p1 #p2) #sa))
      (setq #p4 (polar #p4 (angle #p3 #p4) #sa))
;;;02/01/21YM@DEL    )
;;;02/01/21YM@DEL  );_if



  ;;; WT,BG,FG 底面外形の各点を求める
;-- 2011/10/25 A.Satoh Mod(元に戻す) - S
;;;;;-- 2011/09/30 A.Satoh Mod - S

;;; ＜I型＞
;;;  BASE=p4------------------------+p2   <---BG背面
;;;  |                              |
;;;  +p44                           +p22  <---BG前面
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  +p3----------------------------+p1
;★2016/02/16 YM #BG_T を有効に
	(if (equal #BG_Type 1 0.1) ; BGあり
		(progn
		  (setq #p22  (polar #p2  (angle #p2 #p1) #BG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
		  (setq #p44  (polar #p4  (angle #p4 #p3) #BG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
		)
		(progn ;BGなし　前垂れ回り込みに使う点
		  (setq #p22  (polar #p2  (angle #p2 #p1) #FG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
		  (setq #p44  (polar #p4  (angle #p4 #p3) #FG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
		)
	);_if
;★2016/02/16 YM #BG_T を有効に
;;;;;;-- 2011/09/30 A.Satoh Mod - E
;-- 2011/10/25 A.Satoh Mod(元に戻す) - E

;;; ＜I型＞
;;;  BASE=p4------------------------+p2   <---BG背面
;;;  |                              |
;;;  |                              |
;;;  |                              |
;;;  +p333                          +p111 <---FG背面
;;;  |                              |
;;;  +p3                            +p1  <--天板外形もとの位置
;;;  +p33---------------------------+p11  <---FG前面

  (setq #p11  (polar #p1  (angle #p2 #p1) #FG_S)) ; 前垂れシフト量分前に移動
  (setq #p33  (polar #p3  (angle #p4 #p3) #FG_S)) ; 前垂れシフト量分前に移動
  (setq #p333 (polar #p33 (angle #p3 #p4) #FG_T)) ; FG厚み分後ろに移動
  (setq #p111 (polar #p11 (angle #p1 #p2) #FG_T)) ; FG厚み分後ろに移動

  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;-- 2011/10/25 A.Satoh Mod(元に戻す) - S
;;;;;;-- 2011/09/30 A.Satoh Mod - S

;;; ＜I型＞ 【BG回り込み用の点pA,pB,pC,pDを追加】
;;;  BASE=p4------------------------------+p2   <---BG背面
;;;  |                                    |
;;;  +p44    +pC                    pB+   +p22  <---BG前面
;;;  |                                    |
;;;  |                                    |
;;;  +p333   +pF                    pE+   +p111 <---FG背面
;;;  |                                    |
;;;  +p3                                  +p1
;;;  +p33----+pD--------------------pA+---+p11  <---FG前面

			;2016/02/24 YM BG回り込みにしか使わない変数
		  (setq #pA (polar #p11  (angle #p2 #p4) #BG_T))
		  (setq #pB (polar #p22  (angle #p2 #p4) #BG_T))
		  (setq #pC (polar #p44  (angle #p4 #p2) #BG_T))
		  (setq #pD (polar #p33  (angle #p4 #p2) #BG_T))
		  (setq #pE (polar #p111 (angle #p2 #p4) #BG_T))
		  (setq #pF (polar #p333 (angle #p4 #p2) #BG_T))

;;; ＜I型＞ 【天板延長】
;;;     p4WTL *<--- BASE=p4--------------------+p2---->*p2WTR
;;;           |     |                          |       |
;;;    p44WTL *<--- +p44                       +p22--->*p22WTR
;;;           |     |                          |       |
;;;           |     |                          |       |
;;;   p333WTL *<--- +p333                      +p111-->*p111WTR
;;;           |     |                          |       |
;;;     p3WTL |     +p3                        +p1     *p1WTR
;;;    p33WTL *<--- +p33-----------------------+p11--->*p11WTR

					;★天板延長分★ 2016/02/24 YM  変数名の変更 ffL=>WTR ffR=>WTL
          (setq #p2WTR   (polar #p2   (angle #p4 #p2) #offsetR));右側天板延長
          (setq #p22WTR  (polar #p22  (angle #p4 #p2) #offsetR))
          (setq #p111WTR (polar #p111 (angle #p4 #p2) #offsetR))
          (setq #p1WTR   (polar #p1   (angle #p4 #p2) #offsetR))
          (setq #p11WTR  (polar #p11  (angle #p4 #p2) #offsetR))

          (setq #p4WTL   (polar #p4   (angle #p2 #p4) #offsetL));左側天板延長
          (setq #p44WTL  (polar #p44  (angle #p2 #p4) #offsetL))
          (setq #p333WTL (polar #p333 (angle #p2 #p4) #offsetL))
          (setq #p3WTL   (polar #p3   (angle #p2 #p4) #offsetL))
          (setq #p33WTL  (polar #p33  (angle #p2 #p4) #offsetL))



  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;★2016/02/16 YM #BG_T を有効に

;;; ＜I型＞
;;;     p4WTL *---- p4----+HFGL-----------------GFGR+--+p2-----*p2WTR
;;;           |     |                                  |       |
;;;    p44WTL *---- +p44  +CFGL                 BFGR+  +p22----*p22WTR
;;;           |     |                                  |       |
;;;           |     |                                  |       |
;;;   p333WTL *---- +p333 +FFGL                 EFGR+  +p111---*p111WTR
;;;           |     |                                  |       |
;;;     p3WTL |     +p3                                +p1     *p1WTR
;;;    p33WTL *---- +p33--+DFGL-----------------AFGR+--+p11----*p11WTR

			;2016/02/24 YM 前垂れ回り込み点変数変更 ffL==>FGR ffR==>FGL
		  (setq #pAFGR (polar #p11WTR  (angle #p2 #p4) #FG_T))
		  (setq #pBFGR (polar #p22WTR  (angle #p2 #p4) #FG_T))
		  (setq #pCFGL (polar #p44WTL  (angle #p4 #p2) #FG_T))
		  (setq #pDFGL (polar #p33WTL  (angle #p4 #p2) #FG_T))
		  (setq #pEFGR (polar #p111WTR (angle #p2 #p4) #FG_T))
		  (setq #pFFGL (polar #p333WTL (angle #p4 #p2) #FG_T))
		  (setq #pGFGR (polar #p2WTR   (angle #p2 #p4) #FG_T))
		  (setq #pHFGL (polar #p4WTL   (angle #p4 #p2) #FG_T))

  ;BG底面作図 ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
  (cond
    ((equal #BG_Type 1 0.1) ; BGあり
      (cond       
        ((equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
          (setq #bg_en1 (MakeTEIMEN (list #p4 #p2 #p11 #pA #pB #pC #pD #p33))); ﾊﾞｯｸｶﾞｰﾄﾞ底面
        )
        ((or (equal #TOP_FLG  2 0.1)(equal #TOP_FLG  3 0.1));ﾌﾗｯﾄ対面
          (setq #bg_en1 nil); ﾊﾞｯｸｶﾞｰﾄﾞなし
        )
        ;2010/10/27 YM ADD-S 新スイージィﾀｲﾙ天板I型の前垂れ横だけ回り込み　BGあり
 				;2016/02/24 変数変更 ffL=>WTR ffR=>WTL
        ((or (equal #TOP_FLG 4 0.1)(equal #TOP_FLG 5 0.1));左右勝手共通
          (setq #bg_en1 (MakeTEIMEN (list #p4WTL #p2WTR #p22WTR #p44WTL))); BG底面
        )
        ;2010/10/27 YM ADD-E 新スイージィﾀｲﾙ天板I型の前垂れ横だけ回り込みで　BGあり
        (T ;通常
          (setq #bg_en1 (MakeTEIMEN (list #p4 #p2 #p22 #p44))); ﾊﾞｯｸｶﾞｰﾄﾞ底面
        )
      );_cond
      (setq #bg_en2 nil)
      (setq #bg_en$ (list #bg_en1 #bg_en2))
    )
    ((equal #BG_Type 0 0.1) ; BGなし
      (setq #bg_en$ (list nil nil))
    )
    (T
      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
    )
  );_cond

  ;FG底面作図 ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

;;; ＜I型＞　古い変数の図
;;;     p4ffR *---- p4----+HffR--------------------GffL+--+p2-----*p2ffL
;;;           |     |                                     |       |
;;;    p44ffR *---- +p44  +CffR                    BffL+  +p22----*p22ffL
;;;           |     |                                     |       |
;;;           |     |                                     |       |
;;;   p333ffR *---- +p333 +FffR                    EffL+  +p111---*p111ffL  前垂れシフトから前垂れ厚みを引いた位置
;;;           |     |                                     |       |
;;;     p3ffR |     +p3                                   +p1     *p1ffL　  元の外形位置
;;;    p33ffR *---- +p33--+DffR--------------------AffL+--+p11----*p11ffL   前垂れシフト


;;; ＜I型＞ 2016/02/24 YM 変数変更　新しい変数の図
;;;     p4WTL *---- p4----+HFGL-----------------GFGR+--+p2-----*p2WTR
;;;           |     |                                  |       |
;;;    p44WTL *---- +p44  +CFGL                 BFGR+  +p22----*p22WTR
;;;           |     |                                  |       |
;;;           |     |                                  |       |
;;;   p333WTL *---- +p333 +FFGL                 EFGR+  +p111---*p111WTR
;;;           |     |                                  |       |
;;;     p3WTL |     +p3                                +p1     *p1WTR
;;;    p33WTL *---- +p33--+DFGL-----------------AFGR+--+p11----*p11WTR

  (cond
    ((equal #FG_Type 1 0.1) ; 通常片側
      (cond ;変数変更 ffL==>WTR ffR==>WTL    [ABCDEFG]ffL==>FGR ffR==>FGL
        ((or (equal #TOP_FLG 2 0.1));左勝手
          (setq #fg_en1 (MakeTEIMEN (list #p2WTR #p4WTL #p33WTL #p11WTR #p111WTR #pFFGL #pCFGL #p22WTR))); 前垂れ底面 コの字
        )
        ((or (equal #TOP_FLG 3 0.1));右勝手
          (setq #fg_en1 (MakeTEIMEN (list #p4WTL #p2WTR #p11WTR #p33WTL #p333WTL #pEFGR #pBFGR #p44WTL))); 前垂れ底面 逆コの字
        )

        ;2010/10/27 YM ADD-S 新スイージィﾀｲﾙ天板I型の前垂れ横だけ回り込み
        ((or (equal #TOP_FLG 4 0.1));左勝手左のみ回りこみ 2016/02/24 YM MOD
;;;          (setq #fg_en1 (MakeTEIMEN (list #p4ffR #p33ffR #p11ffL #p111ffL #pFffR #pHffR))); 前垂れ底面
          (setq #fg_en1 (MakeTEIMEN (list #p4WTL #p33WTL #p11WTR #p111WTR #pFFGL #pHFGL))); 前垂れ底面  Ｌの字
        )
        ((or (equal #TOP_FLG 5 0.1));右勝手右のみ回りこみ 2016/02/24 YM MOD
;;;          (setq #fg_en1 (MakeTEIMEN (list #p2ffL #p11ffL #p33ffR #p333ffR #pEffL #pGffL))); 前垂れ底面
          (setq #fg_en1 (MakeTEIMEN (list #p2WTR #p11WTR #p33WTL #p333WTL #pEFGR #pGFGR))); 前垂れ底面  逆Ｌの字
        )
        ;2010/10/27 YM ADD-E 新スイージィﾀｲﾙ天板I型の前垂れ横だけ回り込み

        (T ;通常
          (setq #fg_en1 (MakeTEIMEN (list #p11 #p33 #p333 #p111)))  ; 前垂れ底面
        )
      );_cond
      (setq #fg_en2 nil)
    )
    ((equal #FG_Type 2 0.1) ; FG前後
      (setq #fg_en1 (MakeTEIMEN (list #p11 #p33 #p333 #p111)))  ; 前垂れ底面
      (setq #fg_en2 (MakeTEIMEN (list #p4 #p2 #p22 #p44))) ; 前垂れ両側
    )
    ((equal #FG_Type 3 0.1) ; FG前後右
      (setq #dumPT1 (polar #p111 (angle #p2 #p4) #FG_T))
      (setq #dumPT2 (polar #p22  (angle #p2 #p4) #FG_T))
      (setq #fg_en1 (MakeTEIMEN (list #p4 #p2 #p11 #p33 #p333 #dumPT1 #dumPT2 #p44)))
      (setq #fg_en2 nil)
    )
    ((equal #FG_Type 4 0.1) ; FG前後左
      (setq #dumPT1 (polar #p333 (angle #p4 #p2) #FG_T))
      (setq #dumPT2 (polar #p44  (angle #p4 #p2) #FG_T))
      (setq #fg_en1 (MakeTEIMEN (list #p2 #p4 #p33 #p11 #p111 #dumPT1 #dumPT2 #p22)))
      (setq #fg_en2 nil)
    )
    (T
      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
    )
  );_cond

  (setq #fg_en$ (list #fg_en1 #fg_en2))

;;; ＜I型＞ ﾌﾙﾌﾗｯﾄ用に23mm(#offset)延長点追加
;;;     p4ffR *----------- BASE=p4------------------------+p2------------*p2ffL
;;;           |            |                              |              |
;;;    p44ffR *----*CffR-- +p44 +C                    B+  +p22---*BffL---*p22ffL
;;;           |            |                              |              |
;;;           |            |                              |              |
;;;   p333ffR *----*FffR-- +p333+F                    E+  +p111--*EffL---*p111ffL
;;;           |            |                              |              |
;;;     p3ffR |            +p3                            +p1            *p1ffL
;;;    p33ffR *----------- +p33-+D--------------------A+--+p11-----------*p11ffL


;;; ＜I型＞ 2016/02/24 YM 変数変更　新しい変数の図
;;;     p4WTL *---- p4----+HFGL-----------------GFGR+--+p2-----*p2WTR
;;;           |     |                                  |       |
;;;    p44WTL *---- +p44  +CFGL                 BFGR+  +p22----*p22WTR
;;;           |     |                                  |       |
;;;           |     |                                  |       |
;;;   p333WTL *---- +p333 +FFGL                 EFGR+  +p111---*p111WTR
;;;           |     |                                  |       |
;;;     p3WTL |     +p3                                +p1     *p1WTR
;;;    p33WTL *---- +p33--+DFGL-----------------AFGR+--+p11----*p11WTR

  ; ﾜｰｸﾄｯﾌﾟ底面 ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
  (cond
    ((or (equal #TOP_FLG 2 0.1)(equal #TOP_FLG 4 0.1));ﾌﾗｯﾄ対面(左勝手) 2010/10/27 YM ADD BGあり前垂れ回り込み追加
      (setq #wt_en (MakeTEIMEN (list #p4WTL #p2WTR #p11WTR #p33WTL)))
      (setq #WT_LEN (distance #p4WTL #p2WTR))
      (setq #WT_base #p4WTL);WT左上点
    )
    ((or (equal #TOP_FLG 3 0.1)(equal #TOP_FLG 5 0.1));ﾌﾗｯﾄ対面(右勝手) 2010/10/27 YM ADD BGあり前垂れ回り込み追加
      (setq #wt_en (MakeTEIMEN (list #p4WTL #p2WTR #p11WTR #p33WTL)))
      (setq #WT_LEN (distance #p4WTL #p2WTR))
      (setq #WT_base #p4WTL);WT左上点
    )
    (T ;通常
      (setq #wt_en (MakeTEIMEN (list #p4 #p2 #p11 #p33)))
      (setq #WT_LEN (distance #p4 #p2))
      (setq #WT_base #p4);WT左上点
    )
  );_cond

;;;  (setq #WT_LEN (distance #p4 #p2)) ;03/10/14 上に移動
  (setq CG_MAG1 #WT_LEN)
  (setq #cut_type "00")
  (if (= CG_Type2Code "D") ; ﾛｰｷｬﾋﾞの検索
    (progn
      ;;; 左側 #p4 のまわりに&outpl_LOWがあればT なければ nil
      (if (PKSLOWPLCP #p4 &outpl_LOW) ; T or nil
        (setq #cut_type "40")        ; 段差だった
      );_if
      (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
        (setq #cut_type "04")        ; 段差だった
      );_if
    )
  );_if
  (setq #dep (distance #p11 #p2))
  ;03/10/14 YM ADD WT左上点 #WT_base ﾌﾙﾌﾗｯﾄ対応
  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #WT_base 0))
;;;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p4 0))
  (setq #ret$ (append #ret$ (list #ret)))

  #ret$
);PKMakeTeimenPline_I



;;; 2016/02/16YM MOD 前垂れ厚みでなくＢＧ厚みを使う
;;; 2016/02/16YM MOD;;;<HOM>*************************************************************************
;;; 2016/02/16YM MOD;;; <関数名>    : PKMakeTeimenPline_I
;;; 2016/02/16YM MOD;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成
;;; 2016/02/16YM MOD;;; <戻り値>    :
;;; 2016/02/16YM MOD;;; <作成>      : 00/09/21 YM 標準化
;;; 2016/02/16YM MOD;;; <備考>      :
;;; 2016/02/16YM MOD;;;*************************************************************************>MOH<
;;; 2016/02/16YM MOD(defun PKMakeTeimenPline_I (
;;; 2016/02/16YM MOD  &pt$         ; 各WT外形点列 4,6,8点のみ
;;; 2016/02/16YM MOD  &base_new$   ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ   Iのみ
;;; 2016/02/16YM MOD;;;  &lis$        ; WT拡張フラグ ; 01/08/27 YM DEL
;;; 2016/02/16YM MOD;;;  &WTInfo      ; WT情報(#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S)
;;; 2016/02/16YM MOD  &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
;;; 2016/02/16YM MOD  &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
;;; 2016/02/16YM MOD  &outpl_LOW   ;
;;; 2016/02/16YM MOD  &ZaiCode     ; 材質記号
;;; 2016/02/16YM MOD  /
;;; 2016/02/16YM MOD  #BASEPT #BG_EN$ #BG_EN #CUT_TYPE #DEP
;;; 2016/02/16YM MOD  #FG_EN$ #FG_EN #LIS$ #BG_EN1 #BG_EN2 #FG_EN1 #FG_EN2
;;; 2016/02/16YM MOD  #P1 #P11 #P111 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #PT$
;;; 2016/02/16YM MOD  #RET$ #RET #SA #wt_en #WT_LEN #BGFG$
;;; 2016/02/16YM MOD  #BG_S #BG_T #BG_TYPE #FG_S #FG_T #FG_TYPE
;;; 2016/02/16YM MOD  #DUMPT1 #DUMPT2
;;; 2016/02/16YM MOD  #P111FFL #P11FFL #P1FFL #P22FFL #P2FFL #P333FFL #P333FFR #P33FFL #P33FFR #P3FFL
;;; 2016/02/16YM MOD  #P44FFL #P44FFR #P4FFL #P4FFR #PA #PB #PC #PD #PE #PF #TOP_FLG
;;; 2016/02/16YM MOD#P3FFR #PAFFL #PBFFL #PCFFR #PDFFR #PEFFL #PFFFR #WT_BASE
;;; 2016/02/16YM MOD#OFFSET #P111EYEL #P11EYEL #P1EYEL #P22EYEL #P2EYEL #P333EYER #P33EYER #P3EYER 
;;; 2016/02/16YM MOD#P44EYER #P4EYER #PAEYEL #PBEYEL #PCEYER #PDEYER #PEEYEL #PFEYER
;;; 2016/02/16YM MOD#OFFSETL #OFFSETR ;2010/01/08 YM ADD
;;; 2016/02/16YM MOD#PLLL #PRRR       ;2010/11/08 YM ADD
;;; 2016/02/16YM MOD  )
;;; 2016/02/16YM MOD  (setq #pt$ &pt$)
;;; 2016/02/16YM MOD  (setq #BG_T    (nth 3 &WTInfo )) ; BGの厚み
;;; 2016/02/16YM MOD  (setq #FG_T    (nth 5 &WTInfo )) ; FGの厚み
;;; 2016/02/16YM MOD  (setq #FG_S    (nth 6 &WTInfo )) ; 前垂れシフト量
;;; 2016/02/16YM MOD  (setq #TOP_FLG (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;;; 2016/02/16YM MOD  (setq #BG_S    (nth 0 &WTInfo1)) ; 後垂れシフト量
;;; 2016/02/16YM MOD  (setq #BG_Type (nth 1 &WTInfo1)) ; BG有無 1:あり 0:なし
;;; 2016/02/16YM MOD  (setq #FG_Type (nth 2 &WTInfo1)) ; FGﾀｲﾌﾟ 1:FG前側 2:FG両側
;;; 2016/02/16YM MOD  (setq #offsetL  (nth 3 &WTInfo1)) ; 左勝手時ｼﾝｸ側(左側)ｵﾌｾｯﾄ値
;;; 2016/02/16YM MOD  (setq #offsetR  (nth 4 &WTInfo1)) ; 左勝手時ｺﾝﾛ側(右側)ｵﾌｾｯﾄ値
;;; 2016/02/16YM MOD  
;;; 2016/02/16YM MOD;;; ＜I型＞ BG回り込み用の点pA,pB,pC,pDを追加
;;; 2016/02/16YM MOD;;;  BASE=p4------------------------+p2   <---BG背面
;;; 2016/02/16YM MOD;;;  |                              |
;;; 2016/02/16YM MOD;;;  +p44 +C                    B+  +p22  <---BG前面
;;; 2016/02/16YM MOD;;;  |                              |
;;; 2016/02/16YM MOD;;;  |                              |
;;; 2016/02/16YM MOD;;;  +p333+F                    E+  +p111 <---FG背面
;;; 2016/02/16YM MOD;;;  |                              |
;;; 2016/02/16YM MOD;;;  +p3                            +p1
;;; 2016/02/16YM MOD;;;  +p33-+D--------------------A+--+p11  <---FG前面
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;;; 新ﾛｼﾞｯｸ 外形点列-->ｺｰﾅｰ基点 PKGetBaseL6
;;; 2016/02/16YM MOD  (setq #BASEPT (PKGetBaseI4 #pt$ &base_new$)) ; 点列とｼﾝﾎﾞﾙﾘｽﾄ(ｼﾝﾎﾞﾙとｺｰﾅｰ基点は必ずしも一致しない)
;;; 2016/02/16YM MOD  ;;; 外形点列を求める.I型
;;; 2016/02/16YM MOD  (setq #pt$ (GetPtSeries #BASEPT #pt$)) ; 点列内の#BASEPTを先頭に時計周りにする
;;; 2016/02/16YM MOD  (setq #p4 (nth 0 #pt$)) ; #p1,2,3,4 順番注意
;;; 2016/02/16YM MOD  (setq #p2 (nth 1 #pt$))
;;; 2016/02/16YM MOD  (setq #p1 (nth 2 #pt$))
;;; 2016/02/16YM MOD  (setq #p3 (nth 3 #pt$))
;;; 2016/02/16YM MOD  ;;; WT拡張対応 必要なら#p2 #p4を求め直し
;;; 2016/02/16YM MOD  ; 02/01/21 YM 奥行き拡張<0も許す
;;; 2016/02/16YM MOD;;;02/01/21YM@DEL (if (> #BG_S 0.1)
;;; 2016/02/16YM MOD;;;02/01/21YM@DEL    (progn
;;; 2016/02/16YM MOD      (setq #sa #BG_S)
;;; 2016/02/16YM MOD      (setq #p2 (polar #p2 (angle #p1 #p2) #sa))
;;; 2016/02/16YM MOD      (setq #p4 (polar #p4 (angle #p3 #p4) #sa))
;;; 2016/02/16YM MOD;;;02/01/21YM@DEL    )
;;; 2016/02/16YM MOD;;;02/01/21YM@DEL  );_if
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;;; WT,BG,FG 底面外形の各点を求める
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(元に戻す) - S
;;; 2016/02/16YM MOD;;;;;-- 2011/09/30 A.Satoh Mod - S
;;; 2016/02/16YM MOD  (setq #p22  (polar #p2  (angle #p2 #p1) #FG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD  (setq #p44  (polar #p4  (angle #p4 #p3) #FG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #p22  (polar #p2  (angle #p2 #p1) #BG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #p44  (polar #p4  (angle #p4 #p3) #BG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;;-- 2011/09/30 A.Satoh Mod - E
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(元に戻す) - E
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  (setq #p11  (polar #p1  (angle #p2 #p1) #FG_S)) ; WTｼﾌﾄ量分
;;; 2016/02/16YM MOD  (setq #p33  (polar #p3  (angle #p4 #p3) #FG_S)) ; WTｼﾌﾄ量分
;;; 2016/02/16YM MOD  (setq #p333 (polar #p33 (angle #p3 #p4) #FG_T)) ; FG厚み分
;;; 2016/02/16YM MOD  (setq #p111 (polar #p11 (angle #p1 #p2) #FG_T)) ; FG厚み分
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(元に戻す) - S
;;; 2016/02/16YM MOD;;;;;;-- 2011/09/30 A.Satoh Mod - S
;;; 2016/02/16YM MOD  (setq #pA (polar #p11  (angle #p2 #p4) #FG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD  (setq #pB (polar #p22  (angle #p2 #p4) #FG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD  (setq #pC (polar #p44  (angle #p4 #p2) #FG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD  (setq #pD (polar #p33  (angle #p4 #p2) #FG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #pA (polar #p11  (angle #p2 #p4) #BG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #pB (polar #p22  (angle #p2 #p4) #BG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #pC (polar #p44  (angle #p4 #p2) #BG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;  (setq #pD (polar #p33  (angle #p4 #p2) #BG_T)) ; BG厚み分==>FG厚み2010/11/08 YM MOD
;;; 2016/02/16YM MOD;;;;;;-- 2011/09/30 A.Satoh Mod - E
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(元に戻す) - E
;;; 2016/02/16YM MOD  (setq #pE (polar #p111 (angle #p2 #p4) #FG_T)) ; FG厚み分
;;; 2016/02/16YM MOD  (setq #pF (polar #p333 (angle #p4 #p2) #FG_T)) ; FG厚み分
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;;; ＜I型＞ ﾌﾙﾌﾗｯﾄ用に23mm延長点追加
;;; 2016/02/16YM MOD;;;     p4ffR *---- BASE=p4------------------------+p2-----*p2ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;    p44ffR *---- +p44 +C                    B+  +p22----*p22ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;   p333ffR *---- +p333+F                    E+  +p111---*p111ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;     p3ffR |     +p3                            +p1     *p1ffL
;;; 2016/02/16YM MOD;;;    p33ffR *---- +p33-+D--------------------A+--+p11----*p11ffL
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;(nth 11 CG_GLOBAL$)勝手
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;2010/01/07 YM MOD
;;; 2016/02/16YM MOD  (if (= nil CG_GLOBAL$)
;;; 2016/02/16YM MOD    (progn ;KPCADの場合
;;; 2016/02/16YM MOD;-- 2011/08/25 A.Satoh Mod - S
;;; 2016/02/16YM MOD;      (setq #offsetR 0 #offsetL 0)
;;; 2016/02/16YM MOD;      (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD;      (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD;      (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD;      (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD;      (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD;
;;; 2016/02/16YM MOD;      (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD;      (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD;      (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD;      (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD;      (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD      (if (= "L" (nth 9 &WTInfo))
;;; 2016/02/16YM MOD        (progn ;左勝手
;;; 2016/02/16YM MOD          (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD          (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      )
;;; 2016/02/16YM MOD      (if (= "R" (nth 9 &WTInfo))
;;; 2016/02/16YM MOD        (progn ;右勝手
;;; 2016/02/16YM MOD          (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD          (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      )
;;; 2016/02/16YM MOD      (if (= "Z" (nth 9 &WTInfo))
;;; 2016/02/16YM MOD        (progn
;;; 2016/02/16YM MOD          (setq #offsetR 0 #offsetL 0)
;;; 2016/02/16YM MOD          (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD          (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      )
;;; 2016/02/16YM MOD;-- 2011/08/25 A.Satoh Mod - E
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    (progn ;自動作図の場合
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD      (if (= "L" (nth 11 CG_GLOBAL$))
;;; 2016/02/16YM MOD        (progn ;左勝手
;;; 2016/02/16YM MOD          (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD          (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        (progn ;右勝手
;;; 2016/02/16YM MOD          (setq #p2ffL   (polar #p2   (angle #p4 #p2) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p22ffL  (polar #p22  (angle #p4 #p2) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p111ffL (polar #p111 (angle #p4 #p2) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p1ffL   (polar #p1   (angle #p4 #p2) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD          (setq #p11ffL  (polar #p11  (angle #p4 #p2) #offsetL));ｻｲﾄﾞﾊﾟﾈﾙ分(ｺﾝﾛ側)
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD          (setq #p4ffR   (polar #p4   (angle #p2 #p4) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p44ffR  (polar #p44  (angle #p2 #p4) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p333ffR (polar #p333 (angle #p2 #p4) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p3ffR   (polar #p3   (angle #p2 #p4) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD          (setq #p33ffR  (polar #p33  (angle #p2 #p4) #offsetR));ｻｲﾄﾞﾊﾟﾈﾙ分(ｼﾝｸ側)
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      );_if
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD  );_if
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(元に戻す) - S
;;; 2016/02/16YM MOD;;;;;;-- 2011/09/30 A.Satoh Mod - S
;;; 2016/02/16YM MOD  (setq #pAffL (polar #p11ffL  (angle #p2 #p4) #FG_T)) ; FG厚み分 2010/10/27 YM MOD BG==>FG
;;; 2016/02/16YM MOD  (setq #pBffL (polar #p22ffL  (angle #p2 #p4) #FG_T)) ; FG厚み分 2010/10/27 YM MOD BG==>FG ●使用
;;; 2016/02/16YM MOD  (setq #pCffR (polar #p44ffR  (angle #p4 #p2) #FG_T)) ; FG厚み分 2010/10/27 YM MOD BG==>FG ●使用
;;; 2016/02/16YM MOD  (setq #pDffR (polar #p33ffR  (angle #p4 #p2) #FG_T)) ; FG厚み分 2010/10/27 YM MOD BG==>FG
;;; 2016/02/16YM MOD;;;;;  (setq #pAffL (polar #p11ffL  (angle #p2 #p4) #BG_T)) ; FG厚み分 2010/10/27 YM MOD BG==>FG
;;; 2016/02/16YM MOD;;;;;  (setq #pBffL (polar #p22ffL  (angle #p2 #p4) #BG_T)) ; FG厚み分 2010/10/27 YM MOD BG==>FG ●使用
;;; 2016/02/16YM MOD;;;;;  (setq #pCffR (polar #p44ffR  (angle #p4 #p2) #BG_T)) ; FG厚み分 2010/10/27 YM MOD BG==>FG ●使用
;;; 2016/02/16YM MOD;;;;;  (setq #pDffR (polar #p33ffR  (angle #p4 #p2) #BG_T)) ; FG厚み分 2010/10/27 YM MOD BG==>FG
;;; 2016/02/16YM MOD;;;;;;-- 2011/09/30 A.Satoh Mod - E
;;; 2016/02/16YM MOD;-- 2011/10/25 A.Satoh Mod(元に戻す) - E
;;; 2016/02/16YM MOD  (setq #pEffL (polar #p111ffL (angle #p2 #p4) #FG_T)) ; FG厚み分 ●使用
;;; 2016/02/16YM MOD  (setq #pFffR (polar #p333ffR (angle #p4 #p2) #FG_T)) ; FG厚み分 ●使用
;;; 2016/02/16YM MOD  ;2010/10/27 YM ADD-S 新スイージィﾀｲﾙ天板I型の前垂れ横だけ回り込み
;;; 2016/02/16YM MOD  (setq #pLLL (polar #p4ffR    (angle #p4 #p2) #FG_T)) ; FG厚み分 ●使用
;;; 2016/02/16YM MOD  (setq #pRRR (polar #p2ffL    (angle #p2 #p4) #FG_T)) ; FG厚み分 ●使用
;;; 2016/02/16YM MOD  ;2010/10/27 YM ADD-E 新スイージィﾀｲﾙ天板I型の前垂れ横だけ回り込み
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;;; ＜I型＞ ﾌﾙﾌﾗｯﾄ用に23mm延長点追加
;;; 2016/02/16YM MOD;;;     p4ffR *---- BASE=p4------------------------+p2-----*p2ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;    p44ffR *---- +p44 +C                    B+  +p22----*p22ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;   p333ffR *---- +p333+F                    E+  +p111---*p111ffL
;;; 2016/02/16YM MOD;;;           |     |                              |       |
;;; 2016/02/16YM MOD;;;     p3ffR |     +p3                            +p1     *p1ffL
;;; 2016/02/16YM MOD;;;    p33ffR *---- +p33-+D--------------------A+--+p11----*p11ffL
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;BG底面作図
;;; 2016/02/16YM MOD  (cond
;;; 2016/02/16YM MOD    ((equal #BG_Type 1 0.1) ; BGあり
;;; 2016/02/16YM MOD      (cond       
;;; 2016/02/16YM MOD        ((equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;;; 2016/02/16YM MOD          (setq #bg_en1 (MakeTEIMEN (list #p4 #p2 #p11 #pA #pB #pC #pD #p33))); ﾊﾞｯｸｶﾞｰﾄﾞ底面
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG  2 0.1)(equal #TOP_FLG  3 0.1));ﾌﾗｯﾄ対面
;;; 2016/02/16YM MOD          (setq #bg_en1 nil); ﾊﾞｯｸｶﾞｰﾄﾞなし
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ;2010/10/27 YM ADD-S 新スイージィﾀｲﾙ天板I型の前垂れ横だけ回り込み　BGあり
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG 4 0.1)(equal #TOP_FLG 5 0.1));左右勝手共通
;;; 2016/02/16YM MOD          (setq #bg_en1 (MakeTEIMEN (list #p4ffR #p2ffL #p22ffL #p44ffR))); BG底面
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ;2010/10/27 YM ADD-E 新スイージィﾀｲﾙ天板I型の前垂れ横だけ回り込みで　BGあり
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD        (T ;通常
;;; 2016/02/16YM MOD          (setq #bg_en1 (MakeTEIMEN (list #p4 #p2 #p22 #p44))); ﾊﾞｯｸｶﾞｰﾄﾞ底面
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      );_cond
;;; 2016/02/16YM MOD      (setq #bg_en2 nil)
;;; 2016/02/16YM MOD      (setq #bg_en$ (list #bg_en1 #bg_en2))
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    ((equal #BG_Type 0 0.1) ; BGなし
;;; 2016/02/16YM MOD      (setq #bg_en$ (list nil nil))
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    (T
;;; 2016/02/16YM MOD      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD  );_cond
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ;FG底面作図
;;; 2016/02/16YM MOD;;; ＜I型＞ ﾌﾙﾌﾗｯﾄ用に23mm(#offset)延長点追加
;;; 2016/02/16YM MOD;;;     p4ffR *----@LLL--- BASE=p4------------------------+p2----@RRR----*p2ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;    p44ffR *----*CffR-- +p44 +C                    B+  +p22---*BffL---*p22ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;   p333ffR *----*FffR-- +p333+F                    E+  +p111--*EffL---*p111ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;     p3ffR |            +p3                            +p1            *p1ffL
;;; 2016/02/16YM MOD;;;    p33ffR *----------- +p33-+D--------------------A+--+p11-----------*p11ffL
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  (cond
;;; 2016/02/16YM MOD    ((equal #FG_Type 1 0.1) ; 通常片側
;;; 2016/02/16YM MOD      (cond
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG 2 0.1));左勝手
;;; 2016/02/16YM MOD          (setq #fg_en1 (MakeTEIMEN (list #p2ffL #p4ffR #p33ffR #p11ffL #p111ffL #pFffR #pCffR #p22ffL))); 前垂れ底面
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG 3 0.1));右勝手
;;; 2016/02/16YM MOD          (setq #fg_en1 (MakeTEIMEN (list #p4ffR #p2ffL #p11ffL #p33ffR #p333ffR #pEffL #pBffL #p44ffR))); 前垂れ底面
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD        ;2010/10/27 YM ADD-S 新スイージィﾀｲﾙ天板I型の前垂れ横だけ回り込み
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG 4 0.1));左勝手
;;; 2016/02/16YM MOD          (setq #fg_en1 (MakeTEIMEN (list #p4ffR #p33ffR #p11ffL #p111ffL #pFffR #pLLL))); 前垂れ底面
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ((or (equal #TOP_FLG 5 0.1));右勝手
;;; 2016/02/16YM MOD          (setq #fg_en1 (MakeTEIMEN (list #p2ffL #p11ffL #p33ffR #p333ffR #pEffL #pRRR))); 前垂れ底面
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD        ;2010/10/27 YM ADD-E 新スイージィﾀｲﾙ天板I型の前垂れ横だけ回り込み
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD        (T ;通常
;;; 2016/02/16YM MOD          (setq #fg_en1 (MakeTEIMEN (list #p11 #p33 #p333 #p111)))  ; 前垂れ底面
;;; 2016/02/16YM MOD        )
;;; 2016/02/16YM MOD      );_cond
;;; 2016/02/16YM MOD      (setq #fg_en2 nil)
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    ((equal #FG_Type 2 0.1) ; FG前後
;;; 2016/02/16YM MOD      (setq #fg_en1 (MakeTEIMEN (list #p11 #p33 #p333 #p111)))  ; 前垂れ底面
;;; 2016/02/16YM MOD      (setq #fg_en2 (MakeTEIMEN (list #p4 #p2 #p22 #p44))) ; 前垂れ両側
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    ((equal #FG_Type 3 0.1) ; FG前後右
;;; 2016/02/16YM MOD      (setq #dumPT1 (polar #p111 (angle #p2 #p4) #FG_T))
;;; 2016/02/16YM MOD      (setq #dumPT2 (polar #p22  (angle #p2 #p4) #FG_T))
;;; 2016/02/16YM MOD      (setq #fg_en1 (MakeTEIMEN (list #p4 #p2 #p11 #p33 #p333 #dumPT1 #dumPT2 #p44)))
;;; 2016/02/16YM MOD      (setq #fg_en2 nil)
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    ((equal #FG_Type 4 0.1) ; FG前後左
;;; 2016/02/16YM MOD      (setq #dumPT1 (polar #p333 (angle #p4 #p2) #FG_T))
;;; 2016/02/16YM MOD      (setq #dumPT2 (polar #p44  (angle #p4 #p2) #FG_T))
;;; 2016/02/16YM MOD      (setq #fg_en1 (MakeTEIMEN (list #p2 #p4 #p33 #p11 #p111 #dumPT1 #dumPT2 #p22)))
;;; 2016/02/16YM MOD      (setq #fg_en2 nil)
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    (T
;;; 2016/02/16YM MOD      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD  );_cond
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  (setq #fg_en$ (list #fg_en1 #fg_en2))
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;;; ＜I型＞ ﾌﾙﾌﾗｯﾄ用に23mm(#offset)延長点追加
;;; 2016/02/16YM MOD;;;     p4ffR *----------- BASE=p4------------------------+p2------------*p2ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;    p44ffR *----*CffR-- +p44 +C                    B+  +p22---*BffL---*p22ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;   p333ffR *----*FffR-- +p333+F                    E+  +p111--*EffL---*p111ffL
;;; 2016/02/16YM MOD;;;           |            |                              |              |
;;; 2016/02/16YM MOD;;;     p3ffR |            +p3                            +p1            *p1ffL
;;; 2016/02/16YM MOD;;;    p33ffR *----------- +p33-+D--------------------A+--+p11-----------*p11ffL
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  ; ﾜｰｸﾄｯﾌﾟ底面
;;; 2016/02/16YM MOD  (cond
;;; 2016/02/16YM MOD    ((or (equal #TOP_FLG 2 0.1)(equal #TOP_FLG 4 0.1));ﾌﾗｯﾄ対面(左勝手) 2010/10/27 YM ADD BGあり前垂れ回り込み追加
;;; 2016/02/16YM MOD      (setq #wt_en (MakeTEIMEN (list #p4ffR #p2ffL #p11ffL #p33ffR)))
;;; 2016/02/16YM MOD      (setq #WT_LEN (distance #p4ffR #p2ffL))
;;; 2016/02/16YM MOD      (setq #WT_base #p4ffR);WT左上点
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    ((or (equal #TOP_FLG 3 0.1)(equal #TOP_FLG 5 0.1));ﾌﾗｯﾄ対面(右勝手) 2010/10/27 YM ADD BGあり前垂れ回り込み追加
;;; 2016/02/16YM MOD      (setq #wt_en (MakeTEIMEN (list #p4ffR #p2ffL #p11ffL #p33ffR)))
;;; 2016/02/16YM MOD      (setq #WT_LEN (distance #p4ffR #p2ffL))
;;; 2016/02/16YM MOD      (setq #WT_base #p4ffR);WT左上点
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD    (T ;通常
;;; 2016/02/16YM MOD      (setq #wt_en (MakeTEIMEN (list #p4 #p2 #p11 #p33)))
;;; 2016/02/16YM MOD      (setq #WT_LEN (distance #p4 #p2))
;;; 2016/02/16YM MOD      (setq #WT_base #p4);WT左上点
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD  );_cond
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD;;;  (setq #WT_LEN (distance #p4 #p2)) ;03/10/14 上に移動
;;; 2016/02/16YM MOD  (setq CG_MAG1 #WT_LEN)
;;; 2016/02/16YM MOD  (setq #cut_type "00")
;;; 2016/02/16YM MOD  (if (= CG_Type2Code "D") ; ﾛｰｷｬﾋﾞの検索
;;; 2016/02/16YM MOD    (progn
;;; 2016/02/16YM MOD      ;;; 左側 #p4 のまわりに&outpl_LOWがあればT なければ nil
;;; 2016/02/16YM MOD      (if (PKSLOWPLCP #p4 &outpl_LOW) ; T or nil
;;; 2016/02/16YM MOD        (setq #cut_type "40")        ; 段差だった
;;; 2016/02/16YM MOD      );_if
;;; 2016/02/16YM MOD      (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;;; 2016/02/16YM MOD        (setq #cut_type "04")        ; 段差だった
;;; 2016/02/16YM MOD      );_if
;;; 2016/02/16YM MOD    )
;;; 2016/02/16YM MOD  );_if
;;; 2016/02/16YM MOD  (setq #dep (distance #p11 #p2))
;;; 2016/02/16YM MOD  ;03/10/14 YM ADD WT左上点 #WT_base ﾌﾙﾌﾗｯﾄ対応
;;; 2016/02/16YM MOD  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #WT_base 0))
;;; 2016/02/16YM MOD;;;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p4 0))
;;; 2016/02/16YM MOD  (setq #ret$ (append #ret$ (list #ret)))
;;; 2016/02/16YM MOD
;;; 2016/02/16YM MOD  #ret$
;;; 2016/02/16YM MOD);PKMakeTeimenPline_I



;;;<HOM>*************************************************************************
;;; <関数名>    : PKMakeTeimenPline_L
;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成
;;; <戻り値>    :
;;; <作成>      : 00/09/26 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKMakeTeimenPline_L (
  &pt$         ; 各WT外形点列 4,6,8点のみ
;;;  &lis$        ; WT拡張フラグ ; 01/08/27 YM DEL
  &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
  &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
  &WTInfo2     ; WT情報2  (#BG_S2 #BG_Type2 #FG_Type2)
  &WTInfo3     ; WT情報3  (#BG_S3 #BG_Type3 #FG_Type3)
  &CutId       ; ｶｯﾄID 0:なし 1:斜めH,W 2:方向指示  L,Uのみ
  &outpl_LOW   ;
  &ZaiCode     ; 材質記号
  /
  #BASEPT #BGFG_INFO #BG_S1 #BG_S2 #BG_S3 #BG_T #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #ddd1 #ddd2
  #FG_S #FG_T #FG_TYPE1 #FG_TYPE2 #FG_TYPE3 #LIS$
  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #POINT$ #PT$ #RET$
  #BG_SEP #MSG #TOP_FLG
  )
  (setq #pt$ &pt$)

  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ

	;2014/07/09 YM ADD
  (setq #offset  (nth 3 &WTInfo1)) ; ｼﾝｸ側回り込みｵﾌｾｯﾄ値


  ;03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 FG前後左(ﾃﾞｨﾌﾟﾛｱ)
  (if (or (equal #TOP_FLG 2 0.1)(equal #TOP_FLG 3 0.1)(equal #TOP_FLG 22 0.1)(equal #TOP_FLG 33 0.1))
    (progn
      ;2008/08/18 YM ADD ﾀﾞｲｱﾛｸﾞが表示されたままになる
      (cond
        ((= CG_AUTOMODE 0)
          (CFAlertMsg "この配列はﾌﾙﾌﾗｯﾄ天板に対応していません")
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog "この配列はﾌﾙﾌﾗｯﾄ天板に対応していません")
          (quit)
        )
      );_cond
    )
  );_if

  (setq #BG_S1    (nth 0 &WTInfo1)) ; 後垂れシフト量
  (setq #BG_Type1 (nth 1 &WTInfo1)) ; BG有無 1:あり 0:なし
  (setq #FG_Type1 (nth 2 &WTInfo1)) ; FGﾀｲﾌﾟ 1:片側 2:両側

  (setq #BG_S2    (nth 0 &WTInfo2)) ; 後垂れシフト量
  (setq #BG_Type2 (nth 1 &WTInfo2)) ; BG有無 1:あり 0:なし
  (setq #FG_Type2 (nth 2 &WTInfo2)) ; FGﾀｲﾌﾟ 1:片側 2:両側

  (setq #BG_S3    (nth 0 &WTInfo3)) ; 後垂れシフト量
  (setq #BG_Type3 (nth 1 &WTInfo3)) ; BG有無 1:あり 0:なし
  (setq #FG_Type3 (nth 2 &WTInfo3)) ; FGﾀｲﾌﾟ 1:片側 2:両側

;;; ＜L型＞            x11  x1
;;; p1+---end1---------*---*---------------------+p2   <---BG背面
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|---------------------+p22  <---BG前面
;;;   |   |             |   |                     |
;;;   |   |             |   |  ｼﾝｸ側              | x11,x22はｶｯﾄ指示方向による
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333 <---FG背面
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44------------------+p33  <---FG前面
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ｺﾝﾛ側   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55

;;; 新ﾛｼﾞｯｸ 外形点列-->ｺｰﾅｰ基点 PKGetBaseL6
  (setq #BASEPT (PKGetBaseL6 #pt$))
  (if (= nil #BASEPT)
    (progn
      ;2008/08/20 YM MOD-S CADｻｰﾊﾞｰで表示が出ないようにする
      (setq #msg "ｺｰﾅｰ基点を取得できませんでした")      
      (cond
        ((= CG_AUTOMODE 0)
          (CMN_OutMsg #msg)
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog #msg)
          (quit)
        )
      );_cond
      ;2008/08/20 YM MOD-S CADｻｰﾊﾞｰで表示が出ないようにする
    )
  );_if
  (setq #pt$ (GetPtSeries #BASEPT #pt$)) ; 外形点列&pt$を#BASEPTを先頭に時計周りにする
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))

  ; 警告追加 01/08/24 YM ADD-S
  ; 薄型ｺｰﾅｰｷｬﾋﾞ単独では配置不可
  (if (or (<= (distance #p3 #p4) (+ #FG_S 0.1))(<= (distance #p4 #p5) (+ #FG_S 0.1)))
    (progn
      (setq #msg "このコーナーキャビでは前垂れが作成できないため、単独でワークトップを作成できません")
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_if
  ; 警告追加 01/08/24 YM ADD-E

  ;;; U型,L形状(U型段差でL配列が2つできる場合)の場合でｺｰﾅｰ基点2を含む場合
  (if (and (= CG_W2CODE "U") (> (distance CG_BASEPT1 #p1) (distance CG_BASEPT2 #p1)))
    (progn
      (setq #BG_S1 #BG_S2)
      (setq #BG_Type1 #BG_Type2) ; BG有無 1:あり 0:なし
      (setq #FG_Type1 #FG_Type2) ; FGﾀｲﾌﾟ 1:片側 2:両側

      (setq #BG_S2 #BG_S3)
      (setq #BG_Type2 #BG_Type3) ; BG有無 1:あり 0:なし
      (setq #FG_Type2 #FG_Type3) ; FGﾀｲﾌﾟ 1:片側 2:両側
    )
  );_if

  ;;; WT拡張対応 必要なら#p2 #p4を求め直し(L形状)
  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL  (if (> #BG_S1 0.1) ; ｼﾝｸ側
;;;02/01/21YM@DEL   (progn
      (setq #p2 (polar #p2 (angle #p3 #p2) #BG_S1))
      (setq #p1 (polar #p1 (angle #p6 #p1) #BG_S1))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL  (if (> #BG_S2 0.1) ; ｺﾝﾛ側
;;;02/01/21YM@DEL   (progn
      (setq #p6 (polar #p6 (angle #p5 #p6) #BG_S2))
      (setq #p1 (polar #p1 (angle #p2 #p1) #BG_S2))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if
  (setq #p22  (polar #p2   (angle #p2 #p3) #BG_T)) ; BG厚み分
  (setq #p66  (polar #p6   (angle #p6 #p5) #BG_T)) ; BG厚み分
  (setq #ddd1 (polar #p1   (angle #p2 #p3) #BG_T)) ; BG厚み分
  (setq #ddd2 (polar #p1   (angle #p6 #p5) #BG_T)) ; BG厚み分
  (setq #p11  (inters #p22 #ddd1 #p66 #ddd2 nil))
  (setq #p33  (polar #p3   (angle #p2 #p3) #FG_S)) ; WTｼﾌﾄ量分
  (setq #p55  (polar #p5   (angle #p6 #p5) #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd1 (polar #p4   (angle #p2 #p3) #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd2 (polar #p4   (angle #p6 #p5) #FG_S)) ; WTｼﾌﾄ量分
  (setq #p44  (inters #p33 #ddd1 #p55 #ddd2 nil))

  (setq #p333 (polar #p33  (angle #p3 #p2) #FG_T)) ; FG厚み分
  (setq #p555 (polar #p55  (angle #p5 #p6) #FG_T)) ; FG厚み分
  (setq #ddd1 (polar #p44  (angle #p3 #p2) #FG_T)) ; FG厚み分
  (setq #ddd2 (polar #p44  (angle #p5 #p6) #FG_T)) ; FG厚み分
  (setq #p444 (inters #p333 #ddd1 #p555 #ddd2 nil))

  (setq #point$ (list #p1 #p2 #p3 #p4 #p5 #p6 #p11 #p22 #p33 #p44 #p55 #p66 #p333 #p444 #p555))
  (setq #BGFG_Info (list #BG_Type1 #FG_Type1 #BG_Type2 #FG_Type2 #BG_SEP #TOP_FLG));03/09/22 YM #TOP_FLG ADD

  (setq CG_MAG1 (distance #p1 #p2)) ; 勝手ｼﾝｸ位置に無関係
  (setq CG_MAG2 (distance #p1 #p6)) ; 勝手ｼﾝｸ位置に無関係
;-- 2011/07/14 A.Satoh Mod - S
  (setq #ret$ (PKLcut0 &WTInfo &WTInfo1 &outpl_LOW #point$ #BGFG_Info))
;  (cond
;    ((= &CutId 0) ; ｶｯﾄなし L型 ｽﾃﾝﾚｽ
;      (setq #ret$ (PKLcut0 &WTInfo          &outpl_LOW #point$ #BGFG_Info))
;    )
;    ((= &CutId 1) ; 斜めｶｯﾄ
;      (setq #ret$ (PKLcut1 &WTInfo &ZaiCode &outpl_LOW #point$ #BGFG_Info))
;    )
;    ((= &CutId 2) ; 方向ｶｯﾄ
;      (setq #ret$ (PKLcut2 &WTInfo &ZaiCode &outpl_LOW #point$ #BGFG_Info))
;    )
;  );_cond
;-- 2011/07/14 A.Satoh Mod - E
  #ret$
);PKMakeTeimenPline_L

;;;<HOM>*************************************************************************
;;; <関数名>    : PKMakeTeimenPline_L_ALL
;;; <処理概要>  : 段差部も含む全体WT外形点列をｸﾞﾛｰﾊﾞﾙにｾｯﾄ
;;; <戻り値>    : なし
;;; <作成>      : 01/08/24 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKMakeTeimenPline_L_ALL (
  &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
  &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
  &WTInfo2     ; WT情報2  (#BG_S2 #BG_Type2 #FG_Type2)
  /
  #BASEPT #BG_S1 #BG_S2 #DDD1 #DDD2 #FG_S #P1 #P2 #P3 #P33 #P4 #P44 #P5 #P55 #P6 #PT$ #MSG
  )
  (setq #pt$ CG_GAIKEI)
  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
  (setq #BG_S1    (nth 0 &WTInfo1)) ; 後垂れシフト量
  (setq #BG_S2    (nth 0 &WTInfo2)) ; 後垂れシフト量

;;; ＜L型＞            x11  x1
;;; p1+---end1---------*---*---------------------+p2   <---BG背面
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|---------------------+p22  <---BG前面
;;;   |   |             |   |                     |
;;;   |   |             |   |  ｼﾝｸ側              | x11,x22はｶｯﾄ指示方向による
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333 <---FG背面
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44------------------+p33  <---FG前面
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ｺﾝﾛ側   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55

;;; 新ﾛｼﾞｯｸ 外形点列-->ｺｰﾅｰ基点 PKGetBaseL6
  (setq #BASEPT (PKGetBaseL6 #pt$))
  (if (= nil #BASEPT)
    (progn
      ;2008/08/20 YM MOD-S CADｻｰﾊﾞｰで表示が出ないようにする
      (setq #msg "ｺｰﾅｰ基点を取得できませんでした")      
      (cond
        ((= CG_AUTOMODE 0)
          (CMN_OutMsg #msg)
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog #msg)
          (quit)
        )
      );_cond
      ;2008/08/20 YM MOD-S CADｻｰﾊﾞｰで表示が出ないようにする
    )
  );_if
  (setq #pt$ (GetPtSeries #BASEPT #pt$)) ; 外形点列&pt$を#BASEPTを先頭に時計周りにする
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))

  ; 警告追加 01/08/24 YM ADD-S
  ; 薄型ｺｰﾅｰｷｬﾋﾞ単独では配置不可
  (if (or (<= (distance #p3 #p4) (+ #FG_S 0.1))(<= (distance #p4 #p5) (+ #FG_S 0.1)))
    (progn
      (setq #msg "\nこのコーナーキャビでは前垂れが作成できないため、単独でワークトップを作成できません")
      (CMN_OutMsg #msg) ; 02/09/05 YM ADD
    )
  );_if
  ; 警告追加 01/08/24 YM ADD-E

  ;;; WT拡張対応 必要なら#p2 #p4を求め直し(L形状)
  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL  (if (> #BG_S1 0.1) ; ｼﾝｸ側
;;;02/01/21YM@DEL   (progn
      (setq #p2 (polar #p2 (angle #p3 #p2) #BG_S1))
      (setq #p1 (polar #p1 (angle #p6 #p1) #BG_S1))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL  (if (> #BG_S2 0.1) ; ｺﾝﾛ側
;;;02/01/21YM@DEL   (progn
      (setq #p6 (polar #p6 (angle #p5 #p6) #BG_S2))
      (setq #p1 (polar #p1 (angle #p2 #p1) #BG_S2))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  (setq #p33  (polar #p3   (angle #p2 #p3) #FG_S)) ; WTｼﾌﾄ量分
  (setq #p55  (polar #p5   (angle #p6 #p5) #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd1 (polar #p4   (angle #p2 #p3) #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd2 (polar #p4   (angle #p6 #p5) #FG_S)) ; WTｼﾌﾄ量分
  (setq #p44  (inters #p33 #ddd1 #p55 #ddd2 nil))

  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (setq CG_GAIKEI (list #p1 #p2 #p33 #p44 #p55 #p6))
  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (princ)
);PKMakeTeimenPline_L_ALL

;;;<HOM>*************************************************************************
;;; <関数名>    : PKLcut0
;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 L型ｶｯﾄなし(ID=0)
;;; <戻り値>    :
;;; <作成>      : 00/09/26 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKLcut0 (
  &WTInfo
	&WTInfo1 ;2014/07/09 YM ADD
  &outpl_LOW
  &point$
  &BGFG_Info
  /
  #BG_EN$ #BG_EN1 #BG_EN2 #CUT_TYPE #DEP1 #DEP2 #FG_EN$ #FG_EN1 #FG_EN2
  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66
  #RET$ #RET #WTLEN$ #wt_en #WT_LEN1 #WT_LEN2 #BG_TYPE1 #BG_TYPE2 #FG_TYPE1 #FG_TYPE2
  #end1 #end2
  #BG_SEP #BG_T #DUMPT1 #DUMPT2 #FG_S #FG_T
#PA #PB #PC #PD #TOP_FLG ;03/10/14 YM ADD
;-- 2011/06/28 A.Satoh Add - S
  #DL
;-- 2011/06/28 A.Satoh Add - S
#OFFSET #P22FF #P2FF #P333FF #P33FF #P3FF #P555FF #P55FF #P5FF #P66FF #P6FF ;2014/07/089 YM ADD
  )
  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ

	;2014/07/09 YM ADD
;2017/06/12 YM DEL
;;;  (setq #offset  (nth 3 &WTInfo1)) ; ｼﾝｸ側回り込みｵﾌｾｯﾄ値


;★★★　2017/06/12 YM ADD-S I型からｺﾋﾟｰ
;;;  (setq #BG_S    (nth 0 &WTInfo1)) ; 後垂れシフト量
;;;
;;;  (setq #BG_Type (nth 1 &WTInfo1)) ; BG有無 1:あり 0:なし
;;;  (setq #FG_Type (nth 2 &WTInfo1)) ; FGﾀｲﾌﾟ 1:FG前側 2:FG両側

  (setq #offsetL  (nth 3 &WTInfo1)) ; 左勝手時ｼﾝｸ側(左側)ｵﾌｾｯﾄ値
  (setq #offsetR  (nth 4 &WTInfo1)) ; 左勝手時ｺﾝﾛ側(右側)ｵﾌｾｯﾄ値
;★★★　2017/06/12 YM ADD-E I型からｺﾋﾟｰ


;;; ＜L型＞            x11  x1
;;; p1+---end1---------*---*---------------------+p2   <---BG背面
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|-----------------B+--+p22  <---BG前面
;;;   |   |             |   |                     |
;;;   |   |             |   |  ｼﾝｸ側              | x11,x22はｶｯﾄ指示方向による
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333 <---FG背面
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44--------------A+--+p33  <---FG前面
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ｺﾝﾛ側   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   +C    |           +D
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55

  (setq #p1 (nth 0 &point$))
  (setq #p2 (nth 1 &point$))
  (setq #p3 (nth 2 &point$))
  (setq #p4 (nth 3 &point$))
  (setq #p5 (nth 4 &point$))
  (setq #p6 (nth 5 &point$))

  (setq #p11 (nth  6 &point$))
  (setq #p22 (nth  7 &point$))
  (setq #p33 (nth  8 &point$))
  (setq #p44 (nth  9 &point$))
  (setq #p55 (nth 10 &point$))
  (setq #p66 (nth 11 &point$))

  (setq #p333 (nth 12 &point$))
  (setq #p444 (nth 13 &point$))
  (setq #p555 (nth 14 &point$))
  (setq #end1 (inters #p11 #p66 #p2 #p1 nil))
  (setq #end2 (inters #p11 #p22 #p1 #p6 nil))

  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
  ; BG回り込み用の点pA,pB,pC,pDを追加
  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG厚み分
  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG厚み分
  (setq #pC  (polar #p66  (angle #p6 #p1) #BG_T)) ; BG厚み分
  (setq #pD  (polar #p55  (angle #p6 #p1) #BG_T)) ; BG厚み分

  (setq #BG_Type1 (nth 0 &BGFG_Info)); 1:あり 0:なし
  (setq #FG_Type1 (nth 1 &BGFG_Info)); 1:片側 2:両側

	;★★★　2017/06/12 YM ADD-S
          (setq #p2ff   (polar #p2   (angle #p1 #p2) #offsetR))
          (setq #p22ff  (polar #p22  (angle #p1 #p2) #offsetR))
          (setq #p333ff (polar #p333 (angle #p1 #p2) #offsetR))
          (setq #p3ff   (polar #p3   (angle #p1 #p2) #offsetR))
          (setq #p33ff  (polar #p33  (angle #p1 #p2) #offsetR))

          (setq #p6ff   (polar #p6   (angle #p1 #p6) #offsetL))
          (setq #p66ff  (polar #p66  (angle #p1 #p6) #offsetL))
          (setq #p555ff (polar #p555 (angle #p1 #p6) #offsetL))
          (setq #p5ff   (polar #p5   (angle #p1 #p6) #offsetL))
          (setq #p55ff  (polar #p55  (angle #p1 #p6) #offsetL))
	;★★★　2017/06/12 YM ADD-E

;;;2017/06/21YM@DEL	;2014/07/09 YM ADD-S
;;;2017/06/21YM@DEL          (setq #p2ff   (polar #p2   (angle #p1 #p2) #offset))
;;;2017/06/21YM@DEL          (setq #p22ff  (polar #p22  (angle #p1 #p2) #offset))
;;;2017/06/21YM@DEL          (setq #p333ff (polar #p333 (angle #p1 #p2) #offset))
;;;2017/06/21YM@DEL          (setq #p3ff   (polar #p3   (angle #p1 #p2) #offset))
;;;2017/06/21YM@DEL          (setq #p33ff  (polar #p33  (angle #p1 #p2) #offset))
;;;2017/06/21YM@DEL
;;;2017/06/21YM@DEL          (setq #p6ff   (polar #p6   (angle #p1 #p6) #offset))
;;;2017/06/21YM@DEL          (setq #p66ff  (polar #p66  (angle #p1 #p6) #offset))
;;;2017/06/21YM@DEL          (setq #p555ff (polar #p555 (angle #p1 #p6) #offset))
;;;2017/06/21YM@DEL          (setq #p5ff   (polar #p5   (angle #p1 #p6) #offset))
;;;2017/06/21YM@DEL          (setq #p55ff  (polar #p55  (angle #p1 #p6) #offset))
;;;2017/06/21YM@DEL	;2014/07/09 YM ADD-E


;-- 2011/08/25 A.Satoh Mod - S
;;;01/06/25YM@  (setq #BG_Type2 (nth 2 &BGFG_Info)); 1:あり 0:なし
;;;01/06/25YM@  (setq #FG_Type2 (nth 3 &BGFG_Info)); 1:片側 2:両側
;
;  ;BG底面作図
;  (cond
;    ((equal #BG_Type1 1 0.1)
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11 #pC #pD #p55 #p6))) ; ﾊﾞｯｸｶﾞｰﾄﾞあり
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p66 #p6))) ; ﾊﾞｯｸｶﾞｰﾄﾞあり
;      );_if
;    )
;    ((equal #BG_Type1 0 0.1)                                        ; ﾊﾞｯｸｶﾞｰﾄﾞなし
;      (setq #bg_en1 nil)
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  ;FG底面作図
;  (cond
;    ((equal #FG_Type1 1 0.1)                                        ; 通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p555 #p444 #p333))) ; 前垂れ底面ﾘｽﾄ 全部
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type1 2 0.1)
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p555 #p444 #p333))) ; 前垂れ底面ﾘｽﾄ 全部
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p66 #p6))) ; 前垂れ前後
;    )
;    ((equal #FG_Type1 3 0.1) ; FG前後右
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p6 #p1 #p2 #p33 #p44 #p55 #p555 #p444 #dumPT1 #dumPT2 #p11 #p66)))
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type1 4 0.1) ; FG前後左
;      (setq #dumPT1 (polar #p555 (angle #p6 #p1) #FG_T))
;      (setq #dumPT2 (polar #p66  (angle #p6 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p2 #p1 #p6 #p55 #p44 #p33 #p333 #p444 #dumPT1 #dumPT2 #p11 #p22)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
  (setq #BG_Type2 (nth 2 &BGFG_Info)); 1:あり 0:なし
  (setq #FG_Type2 (nth 3 &BGFG_Info)); 1:片側 2:両側


;;; ＜L型＞            x11  x1
;;; p1+---end1---------*---*---------------------+p2   --- #p2ff    <---BG背面
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|-----------------B+--+p22 --- #p22ff   <---BG前面
;;;   |   |             |   |                     |
;;;   |   |             |   |  ｼﾝｸ側              | x11,x22はｶｯﾄ指示方向による
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333    #p333ff <---FG背面
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44--------------A+--+p33     #p33ff  <---FG前面
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ｺﾝﾛ側   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   +C    |           +D
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55
;                               
;	 #p6ff      #p555ff      #p55ff

  ;BG底面作図

  (cond
    ((and (equal #BG_Type1 1 0.1) (equal #BG_Type2 1 0.1))

      (cond
				((equal #TOP_FLG 1 0.1) ; 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11 #pC #pD #p55 #p6)))
          (setq #bg_en2 nil)
				)
				((equal #TOP_FLG 4 0.1) ;左勝手
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p66ff #p6ff)))
          (setq #bg_en2 nil)
				)
				((equal #TOP_FLG 5 0.1) ;右勝手
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2ff #p22ff #p11 #p66 #p6)))
          (setq #bg_en2 nil)
				)
        (T
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p66 #p6)))
          (setq #bg_en2 nil)
        )
      );_cond


    )
    ((and (equal #BG_Type1 1 0.1) (equal #BG_Type2 0 0.1))
      (if (equal #TOP_FLG 1 0.1) ; 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
        (progn
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #end2))) ; ﾊﾞｯｸｶﾞｰﾄﾞあり
          (setq #bg_en2 nil)
        )
        ;else 通常
        (progn
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2))) ; ﾊﾞｯｸｶﾞｰﾄﾞあり
          (setq #bg_en2 nil)
        )
      );_if
    )
    ((and (equal #BG_Type1 0 0.1) (equal #BG_Type2 1 0.1))
      (if (equal #TOP_FLG 1 0.1) ; 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
        (progn
          (setq #bg_en1 nil)
          (setq #bg_en2 (MakeTEIMEN (list #p1 #end1 #pC #pD #p55 #p6))) ; ﾊﾞｯｸｶﾞｰﾄﾞあり
        )
        ;else 通常
        (progn
          (setq #bg_en1 nil)
          (setq #bg_en2 (MakeTEIMEN (list #p1 #end1 #p66 #p6))) ; ﾊﾞｯｸｶﾞｰﾄﾞあり
        )
      );_if
    )
    ((and (equal #BG_Type1 0 0.1) (equal #BG_Type2 0 0.1))  ; ﾊﾞｯｸｶﾞｰﾄﾞなし
      (setq #bg_en1 nil)
      (setq #bg_en2 nil)
    )
    (T
      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
    )
  );_cond
  (setq #bg_en$ (list #bg_en1 #bg_en2))


	;2014/07/09 YM ADD-S

;;; ＜L型＞            x11  x1
;;; p1+---end1---------*---*---------------------+p2   --- #p2ff    <---BG背面
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|-----------------B+--+p22 --- #p2ff   <---BG前面
;;;   |   |             |   |                     |
;;;   |   |             |   |  ｼﾝｸ側              | x11,x22はｶｯﾄ指示方向による
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333    #p333ff <---FG背面
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44--------------A+--+p33     #p33ff  <---FG前面
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ｺﾝﾛ側   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   +C    |           +D
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55
;                               
;	 #p6ff      #p555ff      #p55ff

	;2014/07/09 YM ADD-E

  ;FG底面作図
;;;  (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p555 #p444 #p333))) ; 前垂れ底面ﾘｽﾄ 全部

			;2014/07/09 YM
      (cond
        ;2014/07/09 YM ADD-S 新スイージィ前垂れ横だけ回り込み
        ((equal #TOP_FLG 4 0.1);左勝手
          (setq #fg_en1 (MakeTEIMEN (list #p333 #p33 #p44 #p55ff #p6ff #p6 #p555 #p444))); 前垂れ底面
        )
        ((equal #TOP_FLG 5 0.1);右勝手
          (setq #fg_en1 (MakeTEIMEN (list #p2ff #p33ff #p44 #p55 #p555 #p444 #p333 #p2))); 前垂れ底面
        )
        ;2014/07/09 YM ADD-E 新スイージィ前垂れ横だけ回り込み

        (T ;通常
  				(setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p555 #p444 #p333))) ; 前垂れ底面ﾘｽﾄ 全部
        )
      );_cond



  (cond
    ((and (equal #FG_Type1 1 0.1) (equal #FG_Type2 1 0.1))    ; 通常片側
      (setq #fg_en2 nil)
    )
    ((and (equal #FG_Type1 1 0.1) (equal #FG_Type2 2 0.1))
      (setq #fg_en2 (MakeTEIMEN (list #p1  #p6  #p66  #p11)))
    )
    ((and (equal #FG_Type1 2 0.1) (equal #FG_Type2 1 0.1))
      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11))) ; ｼﾝｸ側FG両側
    )
    ((and (equal #FG_Type1 2 0.1) (equal #FG_Type2 2 0.1))
      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p66 #p6))) ; 前垂れ前後
    )
    (T
      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
    )
  );_cond

  (setq #fg_en$ (list #fg_en1 #fg_en2))
;-- 2011/08/25 A.Satoh Mod - E


  ; ﾜｰｸﾄｯﾌﾟ底面

;;;  (setq #wt_en (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p55 #p6)))        ; ﾜｰｸﾄｯﾌﾟ底面 全部

	;2014/07/09 YM　分岐

;;; ＜L型＞            x11  x1
;;; p1+---end1---------*---*---------------------+p2   --- #p2ff    <---BG背面
;;;   |   |             |   |                     |
;;;end2-- +p11----------|---|-----------------B+--+p22 --- #p2ff   <---BG前面
;;;   |   |             |   |                     |
;;;   |   |             |   |  ｼﾝｸ側              | x11,x22はｶｯﾄ指示方向による
;;;   |   |             |   |                     |
;;;   |   |     +p444---|---|---------------------+p333    #p333ff <---FG背面
;;;   |   |     |       |   |                     |
;;;x22*---------------- *sp1|                     |
;;;   |   |     |           |                     |
;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;; x2*-------------------- *p44--------------A+--+p33     #p33ff  <---FG前面
;;;   |   |     |         | |
;;;   |   |     |           |
;;;   |   |     | ｺﾝﾛ側   | |
;;;   |   |     |           |
;;;   |   |     |         | |
;;;   |   +C    |           +D
;;;   +---+-----+---------+-+
;;; p6   p66   p555      p5 p55
;                               
;	 #p6ff      #p555ff      #p55ff

  (cond
    ((equal #TOP_FLG 4 0.1) ;(左勝手) 前垂れ回り込み追加
;;;(list #p333 #p33 #p44 #p55ff #p6ff #p6 #p555 #p444)
      (setq #wt_en (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p55ff #p6ff)))
		  (setq #WT_LEN1 (distance #p1 #p2))
		  (setq #WT_LEN2 (distance #p1 #p6ff))
    )
    ((equal #TOP_FLG 5 0.1) ;(右勝手) 前垂れ回り込み追加
;;;(list #p2ff #p33ff #p44 #p55 #p555 #p444 #p333 #p2)
      (setq #wt_en (MakeTEIMEN (list #p1 #p2ff #p33ff #p44 #p55 #p6)))
		  (setq #WT_LEN1 (distance #p1 #p2ff))
		  (setq #WT_LEN2 (distance #p1 #p6))
    )
    (T ;通常(従来通り)
			(setq #wt_en (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p55 #p6))) ; ﾜｰｸﾄｯﾌﾟ底面 全部
		  (setq #WT_LEN1 (distance #p1 #p2))
		  (setq #WT_LEN2 (distance #p1 #p6))
    )
  );_cond

  (setq #dep1 (distance #p33 #p2))
  (setq #dep2 (distance #p55 #p6))

  (setq #cut_type "00")
  (if (= CG_Type2Code "D")            ; ﾛｰｷｬﾋﾞの検索
    (progn
      ;;; 左側 #p6 のまわりに&outpl_LOWがあればT なければ nil
      (if (PKSLOWPLCP #p6 &outpl_LOW) ; T or nil
        (setq #cut_type "40")        ; 段差だった
      );_if
      ;;; 右側 #p2 のまわりに&outpl_LOWがあればT なければ nil
      (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
        (setq #cut_type "04")        ; 段差だった
      );_if
    )
  );_if

;;;  (setq #WT_LEN1 (distance #p1 #p2))
;;;  (setq #WT_LEN2 (distance #p1 #p6))
;;;  (setq #dep1 (distance #p33 #p2))
;;;  (setq #dep2 (distance #p55 #p6))

;-- 2011/06/28 A.Satoh Mod - S
; (setq #WTLEN$ (PKGetWTLEN$ #dep1 #dep2 #WT_LEN1 #WT_LEN2))
  (if (= nil CG_GLOBAL$)
    (setq #DL CG_LRCODE);2011/09/23 YM MOD
    (setq #DL (nth 11 CG_GLOBAL$))
  )
  (if (= #DL "L")
    (setq #WTLEN$ (list #WT_LEN2 #WT_LEN1))
    (setq #WTLEN$ (list #WT_LEN1 #WT_LEN2))
  )
;-- 2011/06/28 A.Satoh Mod - E
;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 (処理を元に戻す) - S
;;;;;;-- 2011/07/11 A.Satoh Mod - S
  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep1 #dep2) #WTLEN$ #p1 1))
;;;;;  (if (= #DL "L")
;;;;;    (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep2 #dep1) #WTLEN$ #p1 1))
;;;;;    (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep1 #dep2) #WTLEN$ #p1 1))
;;;;;  )
;;;;;;-- 2011/07/11 A.Satoh Mod - E
;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 (処理を元に戻す) - E
  (setq #ret$ (append #ret$ (list #ret)))
  #ret$
);PKLcut0

;-- 2011/08/25 A.Satoh Del - S
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PKLcut1
;;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 L型斜めｶｯﾄ(ID=1)
;;;; <戻り値>    :
;;;; <作成>      : 00/09/26 YM 標準化
;;;; <備考>      :
;;;;*************************************************************************>MOH<
;(defun PKLcut1 (
;  &WTInfo
;  &ZaiCode
;  &outpl_LOW
;  &point$
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #CUT_TYPE #DEP #FG_EN$ #FG_EN1 #FG_EN2
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66
;  #RET$ #RET #wt_en #WT_LEN #BG_TYPE1 #BG_TYPE2 #FG_TYPE1 #FG_TYPE2
;  #BG_SEP #BG_T #DUMPT1 #DUMPT2 #FG_S #FG_T
;#PA #PB #PC #PD #TOP_FLG ;03/10/14 YM ADD
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
;  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
;  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;
;;;; ＜L型＞            x11  x1
;;;; p1+---end1---------*---*---------------------+p2   <---BG背面
;;;;   |   |             |   |                     |
;;;;end2-- +p11----------|---|-----------------B+--+p22  <---BG前面
;;;;   |   |             |   |                     |
;;;;   |   |             |   |  ｼﾝｸ側              | x11,x22はｶｯﾄ指示方向による
;;;;   |   |             |   |                     |
;;;;   |   |     +p444---|---|---------------------+p333 <---FG背面
;;;;   |   |     |       |   |                     |
;;;;x22*---------------- *sp1|                     |
;;;;   |   |     |           |                     |
;;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;;; x2*-------------------- *p44--------------A+--+p33  <---FG前面
;;;;   |   |     |         | |
;;;;   |   |     |           |
;;;;   |   |     | ｺﾝﾛ側   | |
;;;;   |   |     |           |
;;;;   |   |     |         | |
;;;;   |   +C    |           +D
;;;;   +---+-----+---------+-+
;;;; p6   p66   p555      p5 p55
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;
;  (setq #p11 (nth  6 &point$))
;  (setq #p22 (nth  7 &point$))
;  (setq #p33 (nth  8 &point$))
;  (setq #p44 (nth  9 &point$))
;  (setq #p55 (nth 10 &point$))
;  (setq #p66 (nth 11 &point$))
;
;  (setq #p333 (nth 12 &point$))
;  (setq #p444 (nth 13 &point$))
;  (setq #p555 (nth 14 &point$))
;
;  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;  ; BG回り込み用の点pA,pB,pC,pDを追加
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pC  (polar #p66  (angle #p6 #p1) #BG_T)) ; BG厚み分
;  (setq #pD  (polar #p55  (angle #p6 #p1) #BG_T)) ; BG厚み分
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;
;;;;;;;;; (ｼﾝｸ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG底面作図
;  (cond
;    ((equal #BG_Type1 1 0.1)
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11))) ; ﾊﾞｯｸｶﾞｰﾄﾞあり
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11))) ; ｼﾝｸ側BGあり
;      );_if
;    )
;    ((equal #BG_Type1 0 0.1)
;      (setq #bg_en1 nil)                                   ; ｼﾝｸ側BGなし
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; FG前側
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p444 #p333))) ; 前垂れ底面ﾘｽﾄ ｼﾝｸ側
;      (setq #fg_en2 nil)                                   ; ｼﾝｸ側FG通常
;    )
;    ((equal #FG_Type1 2 0.1) ; FG両側
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p444 #p333))) ; 前垂れ底面ﾘｽﾄ ｼﾝｸ側
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11))) ; ｼﾝｸ側FG両側
;    )
;    ((equal #FG_Type1 3 0.1) ; FG前後右
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #p11)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (list #p1  #p2  #p33  #p44 )))  ; ﾜｰｸﾄｯﾌﾟ底面1 H,Wｶｯﾄ
;  (setq #WT_LEN (distance #p1  #p2))
;  (setq #dep    (distance #p33 #p2))
;  (setq #cut_type "30")            ; Hｶｯﾄ
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;      (setq #cut_type "34")        ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p1 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (ｺﾝﾛ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG底面作図
;  (cond
;    ((equal #BG_Type2 1 0.1) ; BGあり
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p6 #p55 #pD #pC #p11))); ﾊﾞｯｸｶﾞｰﾄﾞあり
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p6 #p66 #p11))) ; ｺﾝﾛ側BGあり
;      );_if
;    )
;    ((equal #BG_Type2 0 0.1)
;      (setq #bg_en1 nil)                                      ; ｺﾝﾛ側BGなし
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; FG前側
;      (setq #fg_en1 (MakeTEIMEN (list #p44 #p55 #p555 #p444)))    ; 前垂れ底面ﾘｽﾄ ｺﾝﾛ側
;      (setq #fg_en2 nil)                                      ; ｺﾝﾛ側FG通常
;    )
;    ((equal #FG_Type2 2 0.1) ; FG両側
;      (setq #fg_en1 (MakeTEIMEN (list #p44 #p55 #p555 #p444)))    ; 前垂れ底面ﾘｽﾄ ｺﾝﾛ側
;      (setq #fg_en2 (MakeTEIMEN (list #p1  #p6  #p66  #p11))) ; ｺﾝﾛ側FG両側
;    )
;    ((equal #FG_Type2 3 0.1) ; FG前後左
;      (setq #dumPT1 (polar #p555 (angle #p6 #p1) #FG_T))
;      (setq #dumPT2 (polar #p66  (angle #p6 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p1 #p6 #p55 #p44 #p444 #dumPT1 #dumPT2 #p11)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (list #p1  #p6  #p55  #p44)))  ; ﾜｰｸﾄｯﾌﾟ底面2
;  (setq #WT_LEN (distance #p1  #p6))
;  (setq #dep    (distance #p55 #p6))
;  (setq #cut_type "03")            ; Hｶｯﾄ
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p6 &outpl_LOW) ; T or nil
;      (setq #cut_type "43")        ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p6 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKLcut1
;
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PKLcut2
;;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 L型方向ｶｯﾄ(ID=2)
;;;; <戻り値>    :
;;;; <作成>      : 00/09/26 YM 標準化
;;;; <備考>      :
;;;;*************************************************************************>MOH<
;(defun PKLcut2 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$
;  &BGFG_Info
;  /
;  #CUTPT1 #EN_DUM1 #EN_DUM2 #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66
;  #RET$ #SP1 #X1 #X11 #X2 #X22 #cutin
;  #BG_T #DUMPT1 #DUMPT2 #FG_S #FG_T #BG_SEP #TOP_FLG
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
;  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
;  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;
;  (setq #p11 (nth  6 &point$))
;  (setq #p22 (nth  7 &point$))
;  (setq #p33 (nth  8 &point$))
;  (setq #p44 (nth  9 &point$))
;  (setq #p55 (nth 10 &point$))
;  (setq #p66 (nth 11 &point$))
;
;  (setq #p333 (nth 12 &point$))
;  (setq #p444 (nth 13 &point$))
;  (setq #p555 (nth 14 &point$))
;
;  ;;; 垂線の足を求める #x1,#x2
;  (setq #x1 (CFGetDropPt #p44 (list #p1 #p2)))
;  (setq #x2 (CFGetDropPt #p44 (list #p1 #p6)))
;
;  ; (nth 11 CG_GLOBAL$) 左右使い勝手
;
;  (if CG_Srcpln ; ﾌﾟﾗﾝ検索
;    (progn ; ﾌﾟﾗﾝ検索
;      (if (= (nth 11 CG_GLOBAL$) "R") ; ｶｯﾄ方向の例外処理
;        (setq #CutPt1 #x2) ; ｺﾝﾛ側(実際にｺﾝﾛがあるかどうかとは無関係)
;        (setq #CutPt1 #x1) ; 原則ｼﾝｸ側
;      );_if
;    )
;; else
;    (progn ; ﾌﾟﾗﾝ検索以外
;      ; ｶｯﾄ方向指示する
;      (MakeLWPL (list #p44 (polar #x1 (angle #p6 #p1) 100)) 0) ; 01/06/11 YM MOD
;      (setq #en_dum1 (entlast))
;      (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;      (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; 色を変える
;
;      (MakeLWPL (list #p44 (polar #x2 (angle #p2 #p1) 100)) 0) ; 01/06/11 YM MOD
;      (setq #en_dum2 (entlast))
;      (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;      (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; 色を変える
;
;      (setq #CutPt1 (getpoint "\nカット方向を指示: "))
;      (entdel #en_dum1)
;      (entdel #en_dum2)
;    )
;  );_if
;
;  ;03/10/13 YM ADD-S KDA対応 方向ｶｯﾄの切り込み幅
;  (if (equal (KPGetSinaType) 4 0.1);KDA対応
;    (setq CG_LenDircut 75);KDA
;    (setq CG_LenDircut 50);KSA,KGA,KNA
;  );_if
;
;  (setq #cutin CG_LenDircut) ; 切り込み幅固定
;
;;;;01/07/02YM@  (if CG_Srcpln ; ﾌﾟﾗﾝ検索
;;;;01/07/02YM@    (progn ; ﾌﾟﾗﾝ検索
;;;;01/07/02YM@      (setq #cutin CG_LenDircut) ; 切り込み幅固定
;;;;01/07/02YM@    )
;;;;01/07/02YM@    (progn ; ﾌﾟﾗﾝ検索以外
;;;;01/07/02YM@      ; 切り込み幅入力
;;;;01/07/02YM@      (setq #cutin nil)
;;;;01/07/02YM@      (setq #cutin (getreal "\n切り込み幅<0.0>: "))
;;;;01/07/02YM@      (if (= #cutin nil)(setq #cutin 0.0))
;;;;01/07/02YM@    )
;;;;01/07/02YM@  );_if
;
;  (setq #x11 (polar #x1  (angle #p2 #p1) #cutin))
;  (setq #x22 (polar #x2  (angle #p6 #p1) #cutin))
;  (setq #sp1 (polar #p44 (angle #p6 #p1) #cutin))
;  (setq #sp1 (polar #sp1 (angle #p2 #p1) #cutin))
;
;  (if (< (distance #CutPt1 #x11) (distance #CutPt1 #x22)) ; ここでDｶｯﾄの有無を決める
;    (progn
;;;;01/06/22YM@      (setq #sp1 (polar #p44 (angle #p6 #p1) 50)) ; 01/06/11 YM ADD
;      (setq #ret$ (PKLcut2-1 &WTINFO &ZaiCode &outpl_LOW &point$ #x11 #x22 #sp1 &BGFG_Info)); ***** ｶｯﾄ方向x11 *****
;    )
;    (progn
;;;;01/06/22YM@      (setq #sp1 (polar #p44 (angle #p2 #p1) 50)) ; 01/06/11 YM ADD
;      (setq #ret$ (PKLcut2-2 &WTINFO &ZaiCode &outpl_LOW &point$ #x11 #x22 #sp1 &BGFG_Info)); ***** ｶｯﾄ方向x22 *****
;    )
;  )
;  #ret$
;);PKLcut2
;
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PKLcut2-1
;;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 L型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ1
;;;; <戻り値>    :
;;;; <作成>      : 00/09/26 YM 標準化
;;;; <備考>      : MICADO方向ｶｯﾄは直線
;;;;*************************************************************************>MOH<
;(defun PKLcut2-1 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$ ;点列
;  &x11
;  &x22
;  &sp1
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #CUT_TYPE #DEP #FG_EN$ #FG_EN1 #FG_EN2
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66
;  #RET$ #RET #SP1 #wt_en #WT_LEN #X11 #X22 #BG_TYPE1 #BG_TYPE2 #FG_TYPE1 #FG_TYPE2
;  #BG_SEP #dum #end1 #end2 #LIS1 #LIS2
;  #BG_T #DUMPT1 #DUMPT2 #FG_S #FG_T
;#PA #PB #PC #PD #TOP_FLG ;03/10/14 YM ADD
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
;  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
;  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;
;;;; ＜L型＞            x11  x1
;;;; p1+---end1---------*---*---------------------+p2   <---BG背面
;;;;   |   |             |   |                     |
;;;;end2-- +p11----------*dum|-----------------B+--+p22  <---BG前面
;;;;   |   |             |   |                     |
;;;;   |   |             |   |  ｼﾝｸ側              | x11,x22はｶｯﾄ指示方向による
;;;;   |   |             |   |                     |
;;;;   |   |     +p444---|---|---------------------+p333 <---FG背面
;;;;   |   |     |       |   |                     |
;;;;x22*---------------- *sp1|                     |
;;;;   |   |     |           |                     |
;;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;;; x2*-------------------- *p44--------------A+--+p33  <---FG前面
;;;;   |   |     |         | |
;;;;   |   |     |           |
;;;;   |   |     | ｺﾝﾛ側   | |
;;;;   |   |     |           |
;;;;   |   |     |         | |
;;;;   |   +C    |           +D
;;;;   +---+-----+---------+-+
;;;; p6   p66   p555      p5 p55
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;
;  (setq #p11 (nth  6 &point$))
;  (setq #p22 (nth  7 &point$))
;  (setq #p33 (nth  8 &point$))
;  (setq #p44 (nth  9 &point$))
;  (setq #p55 (nth 10 &point$))
;  (setq #p66 (nth 11 &point$))
;
;  (setq #p333 (nth 12 &point$))
;  (setq #p444 (nth 13 &point$))
;  (setq #p555 (nth 14 &point$))
;  (setq #end1 (inters #p11 #p66 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p6 nil))
;
;  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;  ; BG回り込み用の点pA,pB,pC,pDを追加
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pC  (polar #p66  (angle #p6 #p1) #BG_T)) ; BG厚み分
;  (setq #pD  (polar #p55  (angle #p6 #p1) #BG_T)) ; BG厚み分
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_SEP   (nth 4 &BGFG_Info)) ; 分離型:1 一体型:0
;
;  (setq #x11 &x11)
;  (setq #x22 &x22)
;  (setq #sp1 &sp1)
;  (setq #dum (CFGetDropPt #p22 (list #sp1 #x11)))
;;;;;;;;; (ｼﾝｸ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG底面作図
;  (cond
;    ((equal #BG_Type1 1 0.1) ; BGあり
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #pA #pB #dum))) ; ﾊﾞｯｸｶﾞｰﾄﾞあり
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p22 #dum))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;      );_if
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type1 0 0.1) ; BGなし
;      (setq #bg_en$ (list nil nil))
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; 1枚目通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; 前垂れ前
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type1 2 0.1) ; 1枚目FG前後
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; 前垂れ前
;      (setq #fg_en2 (MakeTEIMEN (list #x11 #p2 #p22 #dum))) ; 前垂れ後ろ
;    )
;    ((equal #FG_Type1 3 0.1) ; 1枚目FG前後右
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #dum)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x11 #p2 #p33))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #p2 #x11))
;  (setq #WT_LEN (distance #p44 #p33)) ; 01/07/02 Y-CUT
;  (setq #cut_type "20")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")            ; ﾛｰｷｬﾋﾞの検索
;    (progn
;      (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;        (setq #cut_type "24")         ; 段差だった
;      );_if
;    )
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #x11 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (ｺﾝﾛ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG底面作図
;  (cond
;    ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;      (cond
;        ((equal #BG_Type1 0 0.1) ; 1枚目BGなし 01/07/26 YM ADD
;          (setq #bg_en1 (MakeTEIMEN (list #end1 #p1 #p6 #p66)))          ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;        )
;        ((equal #BG_Type1 1 0.1) ; 1枚目BGあり 01/07/26 YM ADD
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;            (setq #bg_en1 (MakeTEIMEN (list #x11 #p1 #p6 #p55 #pD #pC #p11 #dum))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;            ;else 通常
;            (setq #bg_en1 (MakeTEIMEN (list #x11 #p1 #p6 #p66 #p11 #dum))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;          );_if
;        )
;      );_cond
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;      (cond
;        ((equal #BG_Type1 1 0.1) ; 1枚目BGあり 01/07/26 YM ADD
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #x11 #dum #end2)))         ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;        )
;        ((equal #BG_Type1 0 0.1) ; 1枚目BGなし 01/07/26 YM ADD
;          (setq #bg_en1 nil)                                             ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;        )
;      );_cond
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; 2枚目通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44)))
;      (cond
;        ((equal #FG_Type1 2 0.1) ; 1枚目FG前後 01/07/26 YM ADD
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #x11 #dum #end2)))
;        )
;        ((equal #FG_Type1 1 0.1) ; 1枚目FG前 01/07/26 YM ADD
;          (setq #fg_en2 nil)
;        )
;      );_cond
;    )
;    ((equal #FG_Type2 2 0.1) ; 2枚目FG前後
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; 前垂れ前
;      (cond
;        ((equal #FG_Type1 2 0.1) ; 1枚目FG前後 01/07/26 YM ADD
;          (setq #fg_en2 (MakeTEIMEN (list #x11 #p1 #p6 #p66 #p11 #dum))) ; 前垂れ後ろ右
;        )
;        ((equal #FG_Type1 1 0.1) ; 1枚目FG前 01/07/26 YM ADD
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #p66 #p6))) ; 前垂れ後ろ
;        )
;      );_cond
;    )
;    ((equal #FG_Type2 3 0.1) ; 2枚目FG前後右
;      (setq #dumPT1 (polar #p555 (angle #p6 #p1) #FG_T))
;      (setq #dumPT2 (polar #p66  (angle #p6 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x11 #p1 #p6 #p55 #p44 #p444 #dumPT1 #dumPT2 #p11 #dum)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x11 #p1 #p6 #p55))))
;  (setq #WT_LEN (distance #p1 #p6))
;  (setq #cut_type "01")
;  (setq #dep (distance #p55 #p6))
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p6 &outpl_LOW) ; T or nil
;      (setq #cut_type "41")         ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p6 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKLcut2-1
;
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PKLcut2-2
;;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 L型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ2
;;;; <戻り値>    :
;;;; <作成>      : 00/09/26 YM 標準化
;;;; <備考>      : MICADO方向ｶｯﾄは直線
;;;;*************************************************************************>MOH<
;(defun PKLcut2-2 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$ ;点列
;  &x11
;  &x22
;  &sp1
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #CUT_TYPE #DEP #FG_EN$ #FG_EN1 #FG_EN2
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66
;  #RET$ #RET #SP1 #wt_en #WT_LEN #X11 #X22 #BG_TYPE1 #BG_TYPE2 #FG_TYPE1 #FG_TYPE2
;  #dum #end1 #end2 #LIS1 #LIS2
;  #BG_SEP #BG_T #DUMPT1 #DUMPT2 #FG_S #FG_T
;#PA #PB #PC #PD #TOP_FLG ;03/10/14 YM ADD
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
;  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
;  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;
;;;; ＜L型＞            x11  x1
;;;; p1+---end1---------*---*---------------------+p2   <---BG背面
;;;;   |   |             |   |                     |
;;;;end2-- +p11--------------|-----------------B+--+p22  <---BG前面
;;;;   |   |             |   |                     |
;;;;   |   |             |   |  ｼﾝｸ側              | x11,x22はｶｯﾄ指示方向による
;;;;   |   |             |   |                     |
;;;;   |   |     +p444---|---|---------------------+p333 <---FG背面
;;;;   |   |     |       |   |                     |
;;;;x22*---*dum--------- *sp1|                     |
;;;;   |   |     |           |                     |
;;;;   |   |     |       p4+-|- - - - - - - - - - -+p3
;;;; x2*-------------------- *p44--------------A+--+p33  <---FG前面
;;;;   |   |     |         | |
;;;;   |   |     |           |
;;;;   |   |     | ｺﾝﾛ側   | |
;;;;   |   |     |           |
;;;;   |   |     |         | |
;;;;   |   +C    |           +D
;;;;   +---+-----+---------+-+
;;;; p6   p66   p555      p5 p55
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;
;  (setq #p11 (nth  6 &point$))
;  (setq #p22 (nth  7 &point$))
;  (setq #p33 (nth  8 &point$))
;  (setq #p44 (nth  9 &point$))
;  (setq #p55 (nth 10 &point$))
;  (setq #p66 (nth 11 &point$))
;
;  (setq #p333 (nth 12 &point$))
;  (setq #p444 (nth 13 &point$))
;  (setq #p555 (nth 14 &point$))
;  (setq #end1 (inters #p11 #p66 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p6 nil))
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_SEP   (nth 4 &BGFG_Info)) ; 分離型:1 一体型:0
;
;  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;  ; BG回り込み用の点pA,pB,pC,pDを追加
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pC  (polar #p66  (angle #p6 #p1) #BG_T)) ; BG厚み分
;  (setq #pD  (polar #p55  (angle #p6 #p1) #BG_T)) ; BG厚み分
;
;  (setq #x11 &x11)
;  (setq #x22 &x22)
;  (setq #sp1 &sp1)
;  (setq #dum (CFGetDropPt #p66 (list #sp1 #x22)))
;;;;;;;;; (ｼﾝｸ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG底面作図
;  (cond
;    ((equal #BG_Type1 1 0.1) ; 1枚目BGあり
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #pA #pB #p11 #dum))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;            ;else 通常
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;          );_if
;        )
;        ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;        )
;      );_cond
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type1 0 0.1) ; 1枚目BGなし
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #dum #x22)))
;          (setq #bg_en2 nil)
;          (setq #bg_en$ (list #bg_en1 #bg_en2))
;        )
;        ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;          (setq #bg_en$ (list nil nil))
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; 1枚目通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; 前垂れ前
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2枚目通常片側
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type2 2 0.1) ; 2枚目両側
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #dum #x22))) ; 前垂れ後ろ左
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 2 0.1) ; 1枚目FG前後
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; 前垂れ前
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2枚目通常片側
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #end2))) ; 前垂れ後ろ
;        )
;        ((equal #FG_Type2 2 0.1) ; 2枚目両側
;          (setq #fg_en2 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum))) ; 前垂れ後ろ左
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 3 0.1) ; 1枚目FG前後右
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #p11 #dum)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x22 #p1 #p2 #p33))))
;  (setq #WT_LEN (distance #p2 #p1))
;  (setq #cut_type "10")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;      (setq #cut_type "14")         ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p1 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (ｺﾝﾛ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG底面作図
;  (cond
;    ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #x22 #p6 #p55 #pD #pC #dum))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #x22 #p6 #p66 #dum))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;      );_if
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;      (setq #bg_en$ (list nil nil))
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; 2枚目通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; 前垂れ前
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type2 2 0.1) ; 2枚目FG前後
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; 前垂れ前
;      (setq #fg_en2 (MakeTEIMEN (list #x22 #p6 #p66 #dum)))    ; 前垂れ後ろ
;    )
;    ((equal #FG_Type2 3 0.1) ; 2枚目FG前後左
;      (setq #dumPT1 (polar #p555 (angle #p6 #p1) #FG_T))
;      (setq #dumPT2 (polar #p66  (angle #p6 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x22 #p6 #p55 #p44 #p444 #dumPT1 #dumPT2 #dum)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x22 #p6 #p55))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #x22 #p6))
;  (setq #WT_LEN (distance #p44 #p55)) ; 01/07/02 Y-CUT
;  (setq #cut_type "02")
;  (setq #dep (distance #p55 #p6))
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p6 &outpl_LOW) ; T or nil
;      (setq #cut_type "42")         ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p6 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKLcut2-2
;-- 2011/08/25 A.Satoh Del - E

;;;<HOM>*************************************************************************
;;; <関数名>    : PKMakeTeimenPline_U
;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成
;;; <戻り値>    :
;;; <作成>      : 00/09/27 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKMakeTeimenPline_U (
  &pt$         ; 各WT外形点列 4,6,8点のみ
;;;  &lis$        ; WT拡張フラグ ; 01/08/27 YM DEL
  &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep))
  &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
  &WTInfo2     ; WT情報2  (#BG_S2 #BG_Type2 #FG_Type2)
  &WTInfo3     ; WT情報3  (#BG_S3 #BG_Type3 #FG_Type3)
  &CutId       ; ｶｯﾄID 0,1,2 なし,斜めH,方向指示  L,Uのみ
  &outpl_LOW   ;
  &ZaiCode     ; 材質記号
  /
  #ANG #BASEPT$ #BGFG_INFO #BG_S1 #BG_S2 #BG_S3 #BG_SEP #BG_T #BG_TYPE1 #BG_TYPE2 #BG_TYPE3
  #ddd #ddd1 #ddd2 #ddd3 #ddd4 #FG_S #FG_T #FG_TYPE1 #FG_TYPE2 #FG_TYPE3 #LIS$
  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
  #POINT$ #PT$ #RET$ #WT_LEN1 #WT_LEN2 #WT_LEN3 #X2 #TOP_FLG #MSG
  )
  (setq #pt$ &pt$)

  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ

  ;03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 FG前後左(ﾃﾞｨﾌﾟﾛｱ)
  (if (or (equal #TOP_FLG 2 0.1)(equal #TOP_FLG 3 0.1)(equal #TOP_FLG 22 0.1)(equal #TOP_FLG 33 0.1))
    (progn
      ;2008/08/18 YM ADD ﾀﾞｲｱﾛｸﾞが表示されたままになる
      (cond
        ((= CG_AUTOMODE 0)
          (CFAlertMsg "この配列はﾌﾙﾌﾗｯﾄ天板に対応していません")
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog "この配列はﾌﾙﾌﾗｯﾄ天板に対応していません")
          (quit)
        )
      );_cond
    )
  );_if

  (setq #BG_S1    (nth 0 &WTInfo1)) ; 後垂れシフト量
  (setq #BG_Type1 (nth 1 &WTInfo1)) ; BG有無 1:あり 0:なし
  (setq #FG_Type1 (nth 2 &WTInfo1)) ; FGﾀｲﾌﾟ 1:片側 2:両側

  (setq #BG_S2    (nth 0 &WTInfo2)) ; 後垂れシフト量
  (setq #BG_Type2 (nth 1 &WTInfo2)) ; BG有無 1:あり 0:なし
  (setq #FG_Type2 (nth 2 &WTInfo2)) ; FGﾀｲﾌﾟ 1:片側 2:両側

  (setq #BG_S3    (nth 0 &WTInfo3)) ; 後垂れシフト量
  (setq #BG_Type3 (nth 1 &WTInfo3)) ; BG有無 1:あり 0:なし
  (setq #FG_Type3 (nth 2 &WTInfo3)) ; FGﾀｲﾌﾟ 1:片側 2:両側

;;; ＜U型＞
;;;       end1     x11 x1
;;; p1+(BASE1)-----*---*------------------------+p2   <---BG背面
;;;   |   |        |   |                        |
;;; end2--+p11-----dum1|------------------------+p22  <---BG前面
;;;   |   |        |   |                        |
;;;   |   |     +p444--|------------------------+p333 <---FG背面
;;;   |   |     |  |   |                        |
;;;x22* - dum2- - -*sp1|             ｼﾝｸ側      | x1,x2 x11,x22はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp1はJｶｯﾄ時の分岐点
;;;   |   |     |      |                        |
;;;   |   |     |    +p4------------------------+p3
;;; x2* - - - - - - - -+------------------------+p33  <---FG前面
;;;   |   |     |    | |p44
;;;   |   |     |    | |
;;;   |   |ｺﾝﾛ側|    | |
;;;   |   |     |    | |
;;;   |   |     |    | |
;;; x3* - - - - - - - -+p55----------------------+p66  <---FG前面
;;;   |   |     |    +p5-------------------------+p6
;;;   |   |     |      |                         |
;;;x33* - dum3- - -*sp2|          その他         | x3,x4 x33,x44はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp2はJｶｯﾄ時の分岐点
;;;   |   |     |  |   |                         |
;;;   |   |     +p555--|-------------------------+p666 <---FG背面
;;;   |   |        |   |                         |
;;; end3--+p88-----dum4|-------------------------+p77  <---BG前面
;;;   |   |        |   |                         |
;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG背面
;;;       end4    x44 x4

;;; 新ﾛｼﾞｯｸ YM 外形点列-->ｺｰﾅｰ基点 PKGetBaseL6
  (setq #BASEPT$ (PKGetBaseU8 #pt$))
  (if (or (= nil (car #BASEPT$)) (= nil (cadr #BASEPT$)))
    (progn
      ;2008/08/20 YM MOD-S CADｻｰﾊﾞｰで表示が出ないようにする
      (setq #msg "ｺｰﾅｰ基点を取得できませんでした")      
      (cond
        ((= CG_AUTOMODE 0)
          (CMN_OutMsg #msg)
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog #msg)
          (quit)
        )
      );_cond
      ;2008/08/20 YM MOD-S CADｻｰﾊﾞｰで表示が出ないようにする
    )
  );_if
  (setq #pt$ (GetPtSeries (car #BASEPT$) #pt$)) ; 外形点列&pt$を#BASEPTを先頭に時計周りにする
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))
  (setq #p7 (nth 6 #pt$))
  (setq #p8 (nth 7 #pt$))
  (setq #WT_LEN1 (distance #p1 #p2))
  (setq #WT_LEN2 (distance #p1 #p8))
  (setq #WT_LEN3 (distance #p8 #p7))
;;; WT拡張対応
  (setq #x2 (CFGetDropPt #p4 (list #p1 #p8)))

  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL  (if (> #BG_S1 0.1) ; ｼﾝｸ側
;;;02/01/21YM@DEL   (progn
      (setq #p2 (polar #p2 (angle #p3 #p2) #BG_S1))
      (setq #p1 (polar #p1 (angle #p8 #p1) #BG_S1))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL  (if (> #BG_S2 0.1) ; ｺﾝﾛ側
;;;02/01/21YM@DEL   (progn
      (setq #p1 (polar #p1 (angle #p2 #p1) #BG_S2))
      (setq #p8 (polar #p8 (angle #p7 #p8) #BG_S2))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL  (if (> #BG_S3 0.1) ; その他側
;;;02/01/21YM@DEL   (progn
      (setq #p8 (polar #p8 (angle #p6 #p7) #BG_S3))
      (setq #p7 (polar #p7 (angle #p6 #p7) #BG_S3))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  (setq #p22  (polar #p2   (angle #p2 #p3) #BG_T)) ; BG厚み分
  (setq #p77  (polar #p7   (angle #p7 #p6) #BG_T)) ; BG厚み分
  (setq #ddd (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #ang (angle #ddd #p4))
  (setq #ddd1 (polar #p1   (angle #p2 #p3) #BG_T)) ; BG厚み分
  (setq #ddd2 (polar #p1   #ang            #BG_T)) ; BG厚み分
  (setq #ddd3 (polar #p8   #ang            #BG_T)) ; BG厚み分
  (setq #ddd4 (polar #p8   (angle #p7 #p6) #BG_T)) ; BG厚み分
  (setq #p11  (inters #p22 #ddd1 #ddd2 #ddd3 nil))
  (setq #p88  (inters #ddd2 #ddd3 #p77 #ddd4 nil))

  (setq #p33  (polar #p3   (angle #p2 #p3) #FG_S)) ; WTｼﾌﾄ量分
  (setq #p66  (polar #p6   (angle #p7 #p6) #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #ddd1 (polar #p4   (angle #p2 #p3) #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd2 (polar #p4   #ang            #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd3 (polar #p5   #ang            #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd4 (polar #p5   (angle #p7 #p6) #FG_S)) ; WTｼﾌﾄ量分
  (setq #p44  (inters #p33 #ddd1 #ddd2 #ddd3 nil))
  (setq #p55  (inters #ddd2 #ddd3 #p66 #ddd4 nil))

  (setq #p333 (polar #p33  (angle #p3 #p2) #FG_T))
  (setq #p666 (polar #p66  (angle #p6 #p7) #FG_T))
  (setq #ang (angle #p4 #ddd))
  (setq #ddd1 (polar #p44  (angle #p3 #p2) #FG_T)) ; FG厚み分
  (setq #ddd2 (polar #p44  #ang            #FG_T)) ; FG厚み分
  (setq #ddd3 (polar #p55  #ang            #FG_T)) ; FG厚み分
  (setq #ddd4 (polar #p55  (angle #p6 #p7) #FG_T)) ; FG厚み分
  (setq #p444 (inters #p333 #ddd1 #ddd2 #ddd3 nil))
  (setq #p555 (inters #ddd2 #ddd3 #p666 #ddd4 nil))

  (setq #point$ (list #p1   #p2   #p3   #p4  #p5  #p6  #p7  #p8
                      #p11  #p22  #p33  #p44 #p55 #p66 #p77 #p88
                      #p333 #p444 #p555 #p666))
  (setq #BGFG_Info (list #BG_Type1 #FG_Type1 #BG_Type2 #FG_Type2 #BG_Type3 #FG_Type3 #BG_SEP))

  (setq CG_MAG1 (distance #p1 #p2)) ; 勝手ｼﾝｸ位置に無関係1枚目間口
  (setq CG_MAG2 (distance #p1 #p8)) ; 勝手ｼﾝｸ位置に無関係2枚目間口
  (setq CG_MAG3 (distance #p7 #p8)) ; 勝手ｼﾝｸ位置に無関係3枚目間口

;-- 2011/07/14 A.Satoh Mod - S
  (setq #ret$ (PKUcut0 &WTInfo #point$ #BGFG_Info))
;  (cond
;    ((= &CutId 0) ; ｶｯﾄなし
;      (setq #ret$ (PKUcut0 &WTInfo                     #point$ #BGFG_Info))
;    )
;    ((= &CutId 1) ; 斜めｶｯﾄ
;      (setq #ret$ (PKUcut1 &WTInfo &ZaiCode &outpl_LOW #point$ #BGFG_Info))
;    )
;    ((= &CutId 2) ; 方向ｶｯﾄ
;      (setq #ret$ (PKUcut2 &WTInfo &ZaiCode &outpl_LOW #point$ #BGFG_Info))
;    )
;  );_cond
;-- 2011/07/14 A.Satoh Mod - S

  #ret$
);PKMakeTeimenPline_U

;;;<HOM>*************************************************************************
;;; <関数名>    : PKMakeTeimenPline_U_ALL
;;; <処理概要>  : 段差部も含む全体WT外形点列をｸﾞﾛｰﾊﾞﾙにｾｯﾄ
;;; <戻り値>    : なし
;;; <作成>      : 01/08/24 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKMakeTeimenPline_U_ALL (
  &WTInfo      ; WT情報   (#WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #BG_Sep #TOP_FLG))
  &WTInfo1     ; WT情報1  (#BG_S1 #BG_Type1 #FG_Type1)
  &WTInfo2     ; WT情報2  (#BG_S2 #BG_Type2 #FG_Type2)
  &WTInfo3     ; WT情報3  (#BG_S3 #BG_Type3 #FG_Type3)
  /
  #ANG #BASEPT$ #BG_S1 #BG_S2 #BG_S3 #DDD #DDD1 #DDD2 #DDD3 #DDD4
  #FG_S #P1 #P2 #P3 #P33 #P4 #P44 #P5 #P55 #P6 #P66 #P7 #P8 #PT$ #X2 #MSG
  )
  (setq #pt$ CG_GAIKEI)
  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
  (setq #BG_S1    (nth 0 &WTInfo1)) ; 後垂れシフト量
  (setq #BG_S2    (nth 0 &WTInfo2)) ; 後垂れシフト量
  (setq #BG_S3    (nth 0 &WTInfo3)) ; 後垂れシフト量

;;; ＜U型＞
;;;       end1     x11 x1
;;; p1+(BASE1)-----*---*------------------------+p2   <---BG背面
;;;   |   |        |   |                        |
;;; end2--+p11-----dum1|------------------------+p22  <---BG前面
;;;   |   |        |   |                        |
;;;   |   |     +p444--|------------------------+p333 <---FG背面
;;;   |   |     |  |   |                        |
;;;x22* - dum2- - -*sp1|             ｼﾝｸ側      | x1,x2 x11,x22はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp1はJｶｯﾄ時の分岐点
;;;   |   |     |      |                        |
;;;   |   |     |    +p4------------------------+p3
;;; x2* - - - - - - - -+------------------------+p33  <---FG前面
;;;   |   |     |    | |p44
;;;   |   |     |    | |
;;;   |   |ｺﾝﾛ側|    | |
;;;   |   |     |    | |
;;;   |   |     |    | |
;;; x3* - - - - - - - -+p55----------------------+p66  <---FG前面
;;;   |   |     |    +p5-------------------------+p6
;;;   |   |     |      |                         |
;;;x33* - dum3- - -*sp2|          その他         | x3,x4 x33,x44はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp2はJｶｯﾄ時の分岐点
;;;   |   |     |  |   |                         |
;;;   |   |     +p555--|-------------------------+p666 <---FG背面
;;;   |   |        |   |                         |
;;; end3--+p88-----dum4|-------------------------+p77  <---BG前面
;;;   |   |        |   |                         |
;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG背面
;;;       end4    x44 x4

;;; 新ﾛｼﾞｯｸ YM 外形点列-->ｺｰﾅｰ基点 PKGetBaseL6
  (setq #BASEPT$ (PKGetBaseU8 #pt$))
  (if (or (= nil (car #BASEPT$)) (= nil (cadr #BASEPT$)))
    (progn
      ;2008/08/20 YM MOD-S CADｻｰﾊﾞｰで表示が出ないようにする
      (setq #msg "ｺｰﾅｰ基点を取得できませんでした")      
      (cond
        ((= CG_AUTOMODE 0)
          (CMN_OutMsg #msg)
          (quit)
        )
        ((= CG_AUTOMODE 2)
          (WebOutLog #msg)
          (quit)
        )
      );_cond
      ;2008/08/20 YM MOD-S CADｻｰﾊﾞｰで表示が出ないようにする
    )
  );_if
  (setq #pt$ (GetPtSeries (car #BASEPT$) #pt$)) ; 外形点列&pt$を#BASEPTを先頭に時計周りにする
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))
  (setq #p7 (nth 6 #pt$))
  (setq #p8 (nth 7 #pt$))
;;; WT拡張対応
  (setq #x2 (CFGetDropPt #p4 (list #p1 #p8)))

  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL  (if (> #BG_S1 0.1) ; ｼﾝｸ側
;;;02/01/21YM@DEL   (progn
      (setq #p2 (polar #p2 (angle #p3 #p2) #BG_S1))
      (setq #p1 (polar #p1 (angle #p8 #p1) #BG_S1))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL  (if (> #BG_S2 0.1) ; ｺﾝﾛ側
;;;02/01/21YM@DEL   (progn
      (setq #p1 (polar #p1 (angle #p2 #p1) #BG_S2))
      (setq #p8 (polar #p8 (angle #p7 #p8) #BG_S2))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  ; 02/01/21 YM 奥行き拡張<0も許す
;;;02/01/21YM@DEL  (if (> #BG_S3 0.1) ; その他側
;;;02/01/21YM@DEL   (progn
      (setq #p8 (polar #p8 (angle #p6 #p7) #BG_S3))
      (setq #p7 (polar #p7 (angle #p6 #p7) #BG_S3))
;;;02/01/21YM@DEL   )
;;;02/01/21YM@DEL  );_if

  (setq #ddd (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #ang (angle #ddd #p4))

  (setq #p33  (polar #p3   (angle #p2 #p3) #FG_S)) ; WTｼﾌﾄ量分
  (setq #p66  (polar #p6   (angle #p7 #p6) #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #ddd1 (polar #p4   (angle #p2 #p3) #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd2 (polar #p4   #ang            #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd3 (polar #p5   #ang            #FG_S)) ; WTｼﾌﾄ量分
  (setq #ddd4 (polar #p5   (angle #p7 #p6) #FG_S)) ; WTｼﾌﾄ量分
  (setq #p44  (inters #p33 #ddd1 #ddd2 #ddd3 nil))
  (setq #p55  (inters #ddd2 #ddd3 #p66 #ddd4 nil))

  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (setq CG_GAIKEI (list #p1 #p2 #p33 #p44 #p55 #p66 #p7 #p8))
  ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

);PKMakeTeimenPline_U_ALL

;;;<HOM>*************************************************************************
;;; <関数名>    : PKUcut0
;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 U型ｶｯﾄなし(ID=0)
;;; <戻り値>    :
;;; <作成>      : 00/09/27 YM 標準化
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKUcut0 (
  &WTInfo
  &point$
  &BGFG_Info
  /
  #BG_EN$ #BG_EN1 #BG_EN2 #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP1 #DEP2 #DEP3
  #end1 #end2 #end3 #end4 #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
  #RET #RET$ #WT_EN #WT_LEN1 #WT_LEN2 #WT_LEN3 #X11 #FG_T
#BG_T #PA #PB #PC #PD #TOP_FLG #BG_SEP #FG_S ;03/10/14 YM ADD
  )
  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ

;;; ＜U型＞
;;;       end1     x11 x1
;;; p1+(BASE1)-----*---*------------------------+p2   <---BG背面
;;;   |   |        |   |                        |
;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG前面
;;;   |   |        |   |                        |
;;;   |   |     +p444--|------------------------+p333 <---FG背面
;;;   |   |     |  |   |                        |
;;;x22* - dum2- - -*sp1|             ｼﾝｸ側      | x1,x2 x11,x22はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp1はJｶｯﾄ時の分岐点
;;;   |   |     |      |                        |
;;;   |   |     |    +p4------------------------+p3
;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG前面
;;;   |   |     |    | |p44
;;;   |   |     |    | |
;;;   |   |ｺﾝﾛ側|    | |
;;;   |   |     |    | |
;;;   |   |     |    | |
;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG前面
;;;   |   |     |    +p5-------------------------+p6
;;;   |   |     |      |                         |
;;;x33* - dum3- - -*sp2|          その他         | x3,x4 x33,x44はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp2はJｶｯﾄ時の分岐点
;;;   |   |     |  |   |                         |
;;;   |   |     +p555--|-------------------------+p666 <---FG背面
;;;   |   |        |   |                         |
;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG前面
;;;   |   |        |   |                         |
;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG背面
;;;       end4    x44 x4

  (setq #p1 (nth 0 &point$))
  (setq #p2 (nth 1 &point$))
  (setq #p3 (nth 2 &point$))
  (setq #p4 (nth 3 &point$))
  (setq #p5 (nth 4 &point$))
  (setq #p6 (nth 5 &point$))
  (setq #p7 (nth 6 &point$))
  (setq #p8 (nth 7 &point$))

  (setq #p11 (nth  8 &point$))
  (setq #p22 (nth  9 &point$))
  (setq #p33 (nth 10 &point$))
  (setq #p44 (nth 11 &point$))
  (setq #p55 (nth 12 &point$))
  (setq #p66 (nth 13 &point$))
  (setq #p77 (nth 14 &point$))
  (setq #p88 (nth 15 &point$))

  (setq #p333 (nth 16 &point$))
  (setq #p444 (nth 17 &point$))
  (setq #p555 (nth 18 &point$))
  (setq #p666 (nth 19 &point$))

  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
  ; BG回り込み用の点pA,pB,pC,pDを追加
  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG厚み分
  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG厚み分
  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG厚み分
  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG厚み分

  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG有無 1:あり 0:なし
  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG有無 1:あり 0:なし
  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG有無 1:あり 0:なし
  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側

  (setq #end1 (inters #p11 #p88 #p2 #p1 nil))
  (setq #end2 (inters #p11 #p22 #p1 #p8 nil))
  (setq #end3 (inters #p77 #p88 #p1 #p8 nil))
  (setq #end4 (inters #p11 #p88 #p8 #p7 nil))

;-- 2011/08/25 A.Satoh Mod - S
;  (cond
;    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 1 0.1)) ; 111
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11 #p88 #pC #pD #p66 #p7 #p8)))
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p88 #p77 #p7 #p8)))
;      );_if
;    )
;    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 0 0.1)) ; 110
;      (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #end4 #p8)))
;    )
;    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 1 0.1)) ; 101
;      (CFAlertMsg "\nこのﾊﾞｯｸｶﾞｰﾄﾞの組み合わせは、対応していません。")(quit)
;    )
;    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 0 0.1)) ; 100
;      (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;    )
;    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 1 0.1)) ; 011
;      (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #p88 #p77 #p7 #p8)))
;    )
;    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 0 0.1)) ; 010
;      (setq #bg_en1 (MakeTEIMEN (list #p8 #p1 #end1 #end4)))
;    )
;    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 1 0.1)) ; 001
;      (setq #bg_en1 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
;    )
;    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 0 0.1)) ; 000 ; BGなし
;      (setq #bg_en1 nil)
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;  (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p66 #p666 #p555 #p444 #p333))) ; 前垂れ底面
;
;  (cond
;    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 2 0.1)) ; 222
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p88 #p77 #p7 #p8)))
;    )
;    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 1 0.1)) ; 221
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #end4 #p8)))
;    )
;    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 2 0.1)) ; 212
;      (CFAlertMsg "\nこのﾊﾞｯｸｶﾞｰﾄﾞの組み合わせは、対応していません。")(quit)
;    )
;    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 1 0.1)) ; 211
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;    )
;    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 2 0.1)) ; 122
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #p88 #p77 #p7 #p8)))
;    )
;    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 1 0.1)) ; 121
;      (setq #fg_en2 (MakeTEIMEN (list #p8 #p1 #end1 #end4)))
;    )
;    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 2 0.1)) ; 112
;      (setq #fg_en2 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
;    )
;    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 1 0.1)) ; 111 通常前垂れ
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
  (cond
    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 1 0.1)) ; 111
      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
        (progn
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11 #p88 #pC #pD #p66 #p7 #p8)))
          (setq #bg_en2 nil)
        )
        ;else 通常
        (progn
          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p88 #p77 #p7 #p8)))
          (setq #bg_en2 nil)
        )
      );_if
    )
    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 0 0.1)) ; 110
      (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #end4 #p8)))
      (setq #bg_en2 nil)
    )
    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 1 0.1)) ; 101
      (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
      (setq #bg_en2 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
    )
    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 1 0.1)) ; 011
      (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #p88 #p77 #p7 #p8)))
      (setq #bg_en2 nil)
    )
    ((and (equal #BG_Type1 1 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 0 0.1)) ; 100
      (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
      (setq #bg_en2 nil)
    )
    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 1 0.1)(equal #BG_Type3 0 0.1)) ; 010
      (setq #bg_en1 (MakeTEIMEN (list #p8 #p1 #end1 #end4)))
      (setq #bg_en2 nil)
    )
    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 1 0.1)) ; 001
      (setq #bg_en1 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
      (setq #bg_en2 nil)
    )
    ((and (equal #BG_Type1 0 0.1)(equal #BG_Type2 0 0.1)(equal #BG_Type3 0 0.1)) ; 000 ; BGなし
      (setq #bg_en1 nil)
      (setq #bg_en2 nil)
    )
    (T
      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
    )
  );_cond
  (setq #bg_en$ (list #bg_en1 #bg_en2))

  (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p55 #p66 #p666 #p555 #p444 #p333))) ; 前垂れ底面
  (cond
    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 2 0.1)) ; 222
      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #p88 #p77 #p7 #p8)))
    )
    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 1 0.1)) ; 221
      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11 #end4 #p8)))
    )
    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 2 0.1)) ; 212
      (CFAlertMsg "\nこの前垂れの組み合わせは、対応していません。")(quit)
    )
    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 2 0.1)) ; 122
      (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #p88 #p77 #p7 #p8)))
    )
    ((and (equal #FG_Type1 2 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 1 0.1)) ; 211
      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
    )
    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 2 0.1)(equal #FG_Type3 1 0.1)) ; 121
      (setq #fg_en2 (MakeTEIMEN (list #p8 #p1 #end1 #end4)))
    )
    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 2 0.1)) ; 112
      (setq #fg_en2 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
    )
    ((and (equal #FG_Type1 1 0.1)(equal #FG_Type2 1 0.1)(equal #FG_Type3 1 0.1)) ; 111 通常前垂れ
      (setq #fg_en2 nil)
    )
    (T
      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
    )
  );_cond

  (setq #fg_en$ (list #fg_en1 #fg_en2))
;-- 2011/08/25 A.Satoh Mod - E

  (setq #wt_en (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p55 #p66 #p7 #p8)))         ; ﾜｰｸﾄｯﾌﾟ底面 全部
  (setq #cut_type "00")
  (setq #dep1 (distance #p2 #p33))
  (setq #dep2 (distance (CFGetDropPt #p44 (list #p1 #p8)) #p44))
  (setq #dep3 (distance #p7 #p66))
  (setq #WT_LEN1 (distance #p1 #p2))
  (setq #WT_LEN2 (distance #p1 #p8))
  (setq #WT_LEN3 (distance #p7 #p8))
  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep1 #dep2 #dep3) (list #WT_LEN1 #WT_LEN2 #WT_LEN3) #p1 2))
  (setq #ret$ (append #ret$ (list #ret)))
  #ret$
);PKUcut0

;-- 2011/08/25 A.Satoh Del - S
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PKUcut1
;;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 U型斜めｶｯﾄ(ID=1)
;;;; <戻り値>    :
;;;; <作成>      : 00/09/27 YM 標準化
;;;; <備考>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut1 (
;  &WTInfo
;  &ZaiCode
;  &outpl_LOW
;  &point$
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP
;  #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #RET #RET$ #WT_EN #WT_LEN
;  #DUMPT1 #DUMPT2 #FG_T
;#BG_T #PA #PB #PC #PD #TOP_FLG #BG_SEP #FG_S ;03/10/14 YM ADD
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
;  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
;  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;
;;;; ＜U型＞
;;;;       end1     x11 x1
;;;; p1+(BASE1)-----*---*------------------------+p2   <---BG背面
;;;;   |   |        |   |                        |
;;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG前面
;;;;   |   |        |   |                        |
;;;;   |   |     +p444--|------------------------+p333 <---FG背面
;;;;   |   |     |  |   |                        |
;;;;x22* - dum2- - -*sp1|             ｼﾝｸ側      | x1,x2 x11,x22はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp1はJｶｯﾄ時の分岐点
;;;;   |   |     |      |                        |
;;;;   |   |     |    +p4------------------------+p3
;;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG前面
;;;;   |   |     |    | |p44
;;;;   |   |     |    | |
;;;;   |   |ｺﾝﾛ側|    | |
;;;;   |   |     |    | |
;;;;   |   |     |    | |
;;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG前面
;;;;   |   |     |    +p5-------------------------+p6
;;;;   |   |     |      |                         |
;;;;x33* - dum3- - -*sp2|          その他         | x3,x4 x33,x44はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp2はJｶｯﾄ時の分岐点
;;;;   |   |     |  |   |                         |
;;;;   |   |     +p555--|-------------------------+p666 <---FG背面
;;;;   |   |        |   |                         |
;;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG前面
;;;;   |   |        |   |                         |
;;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG背面
;;;;       end4    x44 x4
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;  ; BG回り込み用の点pA,pB,pC,pDを追加
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG厚み分
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;
;;;;;;;;; (ｼﾝｸ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG底面作図
;  (cond
;    ((equal #BG_Type1 1 0.1)
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #pA #pB #p11))) ; ｼﾝｸ側BGあり
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #p11))) ; ｼﾝｸ側BGあり
;      );_if
;    )
;    ((equal #BG_Type1 0 0.1)
;      (setq #bg_en1 nil)                                   ; ｼﾝｸ側BGなし
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; FG前側
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p444 #p333))) ; 前垂れ底面ﾘｽﾄ ｼﾝｸ側
;      (setq #fg_en2 nil)                                   ; ｼﾝｸ側FG通常
;    )
;    ((equal #FG_Type1 2 0.1) ; FG両側
;      (setq #fg_en1 (MakeTEIMEN (list #p33 #p44 #p444 #p333))) ; 前垂れ底面ﾘｽﾄ ｼﾝｸ側
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #p11))) ; ｼﾝｸ側FG両側
;    )
;    ((equal #FG_Type1 3 0.1) ; FG前後右
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p1 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #p11)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (list #p1  #p2  #p33  #p44)))   ; ﾜｰｸﾄｯﾌﾟ底面
;  (setq #WT_LEN (distance #p1 #p2))
;  (setq #dep (distance #p33 #p2))
;  (setq #cut_type "30")             ; Hｶｯﾄ
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;      (setq #cut_type "34")         ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p1 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (ｺﾝﾛ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG底面作図
;  (cond
;    ((equal #BG_Type2 1 0.1) ; BGあり
;      (setq #bg_en1 (MakeTEIMEN (list #p1 #p8 #p88 #p11))) ; ｺﾝﾛ側BGあり
;    )
;    ((equal #BG_Type2 0 0.1)
;      (setq #bg_en1 nil)                                      ; ｺﾝﾛ側BGなし
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; FG前側
;      (setq #fg_en1 (MakeTEIMEN (list #p44 #p55 #p555 #p444)))    ; 前垂れ底面ﾘｽﾄ ｺﾝﾛ側
;      (setq #fg_en2 nil)                                      ; ｺﾝﾛ側FG通常
;    )
;    ((equal #FG_Type2 2 0.1) ; FG両側
;      (setq #fg_en1 (MakeTEIMEN (list #p44 #p55 #p555 #p444))) ; 前垂れ底面ﾘｽﾄ ｺﾝﾛ側前
;      (setq #fg_en2 (MakeTEIMEN (list #p1 #p8 #p88 #p11)))     ; ｺﾝﾛ側FG後ろ
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (list #p1  #p8  #p55  #p44)))      ; ﾜｰｸﾄｯﾌﾟ底面
;  (setq #WT_LEN (distance #p1 #p8))
;  (setq #dep (distance #p44 (CFGetDropPt #p44 (list #p1 #p8))))
;  (setq #cut_type "33")
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p8 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (その他) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  ;BG底面作図
;  (cond
;    ((equal #BG_Type3 1 0.1) ; BGあり
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #p8 #p7 #p66 #pD #pC #p88))) ; 3枚目BGあり
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #p8 #p7 #p77 #p88))) ; 3枚目BGあり
;      );_if
;    )
;    ((equal #BG_Type3 0 0.1)
;      (setq #bg_en1 nil)                                   ; 3枚目BGなし
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type3 1 0.1) ; FG前側
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); 前垂れ底面ﾘｽﾄ 3枚目
;      (setq #fg_en2 nil)                                      ; 3枚目FG通常
;    )
;    ((equal #FG_Type3 2 0.1) ; FG両側
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); 前垂れ底面ﾘｽﾄ 3枚目前
;      (setq #fg_en2 (MakeTEIMEN (list #p8 #p7 #p77 #p88)))    ; 3枚目FG両側後ろ
;    )
;    ((equal #FG_Type3 3 0.1) ; FG前後左
;      (setq #dumPT1 (polar #p666 (angle #p7 #p8) #FG_T))
;      (setq #dumPT2 (polar #p77  (angle #p7 #p8) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #p8 #p7 #p66 #p55 #p555 #dumPT1 #dumPT2 #p88)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (list #p8  #p7  #p66  #p55)))      ; ﾜｰｸﾄｯﾌﾟ底面
;  (setq #dep (distance #p7 #p66))
;  (setq #WT_LEN (distance #p7 #p8))
;  (setq #cut_type "03")             ; Hｶｯﾄ
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p7 &outpl_LOW) ; T or nil
;      (setq #cut_type "43")         ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p7 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKUcut1
;
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PKUcut2
;;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 U型方向ｶｯﾄ(ID=2)
;;;; <戻り値>    :
;;;; <作成>      : 00/09/27 YM 標準化
;;;; <備考>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut2 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$
;  &BGFG_Info
;  /
;  #CUTPT1 #CUTPT2 #EN_DUM1 #EN_DUM2 #CUTIN #FG_T
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #POINT2$ #PTN #RET$ #SP1 #SP2 #X1 #X11 #X2 #X22 #X3 #X33 #X4 #X44
;  #BG_SEP #BG_T #FG_S #TOP_FLG
;  )
;  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
;  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
;  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  ;;; 垂線の足を求める #x1,#x2
;  (setq #x1 (CFGetDropPt #p44 (list #p1 #p2)))
;  (setq #x2 (CFGetDropPt #p44 (list #p1 #p8)))
;  (setq #x3 (CFGetDropPt #p55 (list #p1 #p8)))
;  (setq #x4 (CFGetDropPt #p55 (list #p7 #p8)))
;
;  ;;; ﾕｰｻﾞｰにｶｯﾄ方向を指示
;  (setq #CutPt1 nil)
;  (setq #CutPt2 nil)
;
;;;;01/06/25YM@  (MakeLWPL (list #p44 #sp1 #x11) 0)
;  (MakeLWPL (list #p44 (polar #x1 (angle #p8 #p1) 100)) 0) ; 01/06/25 YM MOD
;  (setq #en_dum1 (entlast))
;  (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;  (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; 色を変える
;
;;;;01/06/25YM@  (MakeLWPL (list #p44 #sp1 #x22) 0)
;  (MakeLWPL (list #p44 (polar #x2 (angle #p2 #p1) 100)) 0) ; 01/06/25 YM MOD
;  (setq #en_dum2 (entlast))
;  (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;  (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; 色を変える
;
;  (setq #CutPt1 (getpoint "\nカット方向を指示: "))
;  (entdel #en_dum1)
;  (entdel #en_dum2)
;
;;;;01/06/25YM@  (MakeLWPL (list #p55 #sp2 #x33) 0)
;  (MakeLWPL (list #p55 (polar #x3 (angle #p2 #p1) 100)) 0) ; 01/06/25 YM MOD
;  (setq #en_dum1 (entlast))
;  (command "_move" #en_dum1 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;  (GroupInSolidChgCol2 #en_dum1 CG_InfoSymCol) ; 色を変える
;
;;;;01/06/25YM@  (MakeLWPL (list #p55 #sp2 #x44) 0)
;  (MakeLWPL (list #p55 (polar #x4 (angle #p1 #p8) 100)) 0) ; 01/06/25 YM MOD
;  (setq #en_dum2 (entlast))
;  (command "_move" #en_dum2 "" '(0 0 0) (strcat "@0,0," (rtos (+ (nth 0 &WTInfo) (nth 1 &WTInfo)))))
;  (GroupInSolidChgCol2 #en_dum2 CG_InfoSymCol) ; 色を変える
;
;  (setq #CutPt2 (getpoint "\nカット方向を指示: "))
;  (entdel #en_dum1)
;  (entdel #en_dum2)
;
;;;; Xｶｯﾄの方向指示 U配列の場合、方向指示を2回行う
;;;;   +--------(1)-----------------+
;;;;   |         |                  |
;;;;   |         |                  |
;;;;  (2)--------+------------------+
;;;;   |         | ﾊﾟﾀｰﾝ (1)と(3)=>#ptn=1
;;;;   |         |       (1)と(4)=>#ptn=2
;;;;   |         |       (2)と(3)=>#ptn=3
;;;;   |         |       (2)と(4)=>#ptn=4
;;;;  (3)--------+------------------+
;;;;   |         |                  |
;;;;   |         |                  |
;;;;   +--------(4)-----------------+
;
;  (if (< (distance #CutPt1 #x1) (distance #CutPt1 #x2))
;    (progn
;      (if (< (distance #CutPt2 #x3) (distance #CutPt2 #x4))
;        (setq #ptn 1)
;        (setq #ptn 2)
;      );_if
;    )
;    (progn
;      (if (< (distance #CutPt2 #x3) (distance #CutPt2 #x4))
;        (setq #ptn 3)
;        (setq #ptn 4)
;      );_if
;    )
;  );_if
;
;  ;03/10/13 YM ADD-S KDA対応 方向ｶｯﾄの切り込み幅
;  (if (equal (KPGetSinaType) 4 0.1);KDA対応
;    (setq CG_LenDircut 75);KDA
;    (setq CG_LenDircut 50);KSA,KGA,KNA
;  );_if
;
;  (setq #cutin CG_LenDircut) ; 切り込み幅固定
;
;;;;01/07/02YM@  ; 切り込み幅入力
;;;;01/07/02YM@  (setq #cutin nil)
;;;;01/07/02YM@  (setq #cutin (getreal "\n切り込み幅<0.0>: "))
;;;;01/07/02YM@  (if (= #cutin nil)(setq #cutin 0.0))
;
;  ;;; WTｼﾌﾄ量分移動
;  (setq #x11 (polar #x1 (angle #p2 #p1) #cutin))
;  (setq #x22 (polar #x2 (angle #p8 #p1) #cutin))
;  (setq #x33 (polar #x3 (angle #p1 #p8) #cutin))
;  (setq #x44 (polar #x4 (angle #p7 #p8) #cutin))
;  (setq #sp1 (polar #p44 (angle #p8 #p1) #cutin))
;  (setq #sp1 (polar #sp1 (angle #p2 #p1) #cutin))
;  (setq #sp2 (polar #p55 (angle #p2 #p1) #cutin))
;  (setq #sp2 (polar #sp2 (angle #p1 #p8) #cutin))
;  (setq #point2$ (list #x1 #x2 #x3 #x4 #x11 #x22 #x33 #x44 #sp1 #sp2))
;
;  (cond
;    ((= #ptn 1)
;      (setq #ret$ (PKUcut2-1 &WTInfo &ZaiCode &outpl_LOW &point$ #point2$ &BGFG_Info))
;    )
;    ((= #ptn 2)
;      (setq #ret$ (PKUcut2-2 &WTInfo &ZaiCode &outpl_LOW &point$ #point2$ &BGFG_Info))
;    )
;    ((= #ptn 3)
;      (setq #ret$ (PKUcut2-3 &WTInfo &ZaiCode &outpl_LOW &point$ #point2$ &BGFG_Info))
;    )
;    ((= #ptn 4)
;      (setq #ret$ (PKUcut2-4 &WTInfo &ZaiCode &outpl_LOW &point$ #point2$ &BGFG_Info))
;    )
;  );_cond
;  #ret$
;);PKUcut2
;-- 2011/08/25 A.Satoh Del - E

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetBG_TEIMEN
;;; <処理概要>  : BG底面ﾎﾟﾘﾗｲﾝ作成
;;; <戻り値>    : BG底面ﾎﾟﾘﾗｲﾝ
;;; <作成>      : 00/09/28 YM
;;; <備考>      : ｿｰｽ短縮
;;;*************************************************************************>MOH<
(defun PKGetBG_TEIMEN (
  &BG_Type  ; BG有無 0:なし 1:あり
  &BG_SEP   ; BG分離 0:一体 1:分離
  &lis1     ; BG一体時の底面頂点ﾘｽﾄ
  &lis2     ; BG分離時の底面頂点ﾘｽﾄ
  /
  #BG_EN1
  )
  (cond
    ((equal &BG_Type 1 0.1)
      (cond
        ((equal &BG_SEP 0 0.1)
          (setq #bg_en1 (MakeTEIMEN &lis1)) ; (一体型)
        )
        ((equal &BG_SEP 1 0.1)
          (setq #bg_en1 (MakeTEIMEN &lis2)) ; (分離型)
        )
        (T
          (CFAlertMsg "\nBG分離型ﾀｲﾌﾟが不正です。")(quit)
        )
      );_cond
    )
    ((equal &BG_Type 0 0.1)
      (setq #bg_en1 nil)                    ; BGなし
    )
    (T
      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
    )
  );_cond
  #bg_en1
);PKGetBG_TEIMEN

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetFG_TEIMEN
;;; <処理概要>  : FG底面ﾎﾟﾘﾗｲﾝ作成
;;; <戻り値>    : FG底面ﾎﾟﾘﾗｲﾝ
;;; <作成>      : 00/09/28 YM
;;; <備考>      : ｿｰｽ短縮
;;;*************************************************************************>MOH<
(defun PKGetFG_TEIMEN (
  &FG_Type  ; FGﾀｲﾌﾟ 1:前側 2:両側
  &BG_SEP   ; BG分離 0:一体 1:分離
  &lis1     ; BG一体時の底面頂点
  &lis2     ; BG分離時の底面頂点
  /
  #FG_EN2
  )
  (cond
    ((equal &FG_Type 2 0.1) ; 両側ﾀｲﾌﾟ
      (cond
        ((equal &BG_SEP 0 0.1)
          (setq #fg_en2 (MakeTEIMEN &lis1)) ; 一体型
        )
        ((equal &BG_SEP 1 0.1)
          (setq #fg_en2 (MakeTEIMEN &lis2)) ; 分離
        )
        (T
          (CFAlertMsg "\nBG分離型ﾀｲﾌﾟが不正です。")(quit)
        )
      );_cond
    )
    ((equal &FG_Type 1 0.1)
      (setq #fg_en2 nil)                    ; FG通常
    )
    (T
      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
    )
  );_cond
  #fg_en2
);PKGetFG_TEIMEN

;-- 2011/08/25 A.Satoh Del - S
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PKUcut2-1
;;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 U型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ1
;;;; <戻り値>    :
;;;; <作成>      : 00/09/27 YM 標準化
;;;; <備考>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut2-1 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$  ;点列
;  &point2$ ;点列2
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #BG_SEP #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP
;  #DUM1 #DUM2 #DUM3 #DUM4 #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #RET #RET$ #SP1 #SP2 #WT_EN #WT_LEN #X1 #X11 #X2 #X22 #X3 #X33 #X4 #X44 #end1 #end2 #end3 #end4
;  #LIS1 #LIS2
;  #DUMPT1 #DUMPT2 #FG_T
;#BG_T #PA #PB #PC #PD #TOP_FLG #FG_S ;03/10/14 YM ADD
;  )
;;;; ＜U型＞
;;;;       end1     x11 x1
;;;; p1+(BASE1)-----*---*------------------------+p2   <---BG背面
;;;;   |   |        |   |                        |
;;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG前面
;;;;   |   |        |   |                        |
;;;;   |   |     +p444--|------------------------+p333 <---FG背面
;;;;   |   |     |  |   |                        |
;;;;x22* - dum2- - -*sp1|             ｼﾝｸ側      | x1,x2 x11,x22はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp1はJｶｯﾄ時の分岐点
;;;;   |   |     |      |                        |
;;;;   |   |     |    +p4------------------------+p3
;;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG前面
;;;;   |   |     |    | |p44
;;;;   |   |     |    | |
;;;;   |   |ｺﾝﾛ側|    | |
;;;;   |   |     |    | |
;;;;   |   |     |    | |
;;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG前面
;;;;   |   |     |    +p5-------------------------+p6
;;;;   |   |     |      |                         |
;;;;x33* - dum3- - -*sp2|          その他         | x3,x4 x33,x44はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp2はJｶｯﾄ時の分岐点
;;;;   |   |     |  |   |                         |
;;;;   |   |     +p555--|-------------------------+p666 <---FG背面
;;;;   |   |        |   |                         |
;;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG前面
;;;;   |   |        |   |                         |
;;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG背面
;;;;       end4    x44 x4
;
;  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
;  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
;  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  (setq #x1  (nth 0 &point2$))
;  (setq #x2  (nth 1 &point2$))
;  (setq #x3  (nth 2 &point2$))
;  (setq #x4  (nth 3 &point2$))
;  (setq #x11 (nth 4 &point2$))
;  (setq #x22 (nth 5 &point2$))
;  (setq #x33 (nth 6 &point2$))
;  (setq #x44 (nth 7 &point2$))
;  (setq #sp1 (nth 8 &point2$))
;  (setq #sp2 (nth 9 &point2$))
;  (setq #dum1 (CFGetDropPt #p22 (list #sp1 #x11)))
;  (setq #dum2 (CFGetDropPt #p11 (list #sp1 #x22)))
;  (setq #dum3 (CFGetDropPt #p11 (list #sp2 #x33)))
;  (setq #dum4 (CFGetDropPt #p77 (list #sp2 #x44)))
;  (setq #end1 (inters #p11 #p88 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p8 nil))
;  (setq #end3 (inters #p77 #p88 #p1 #p8 nil))
;  (setq #end4 (inters #p11 #p88 #p8 #p7 nil))
;
;  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;  ; BG回り込み用の点pA,pB,pC,pDを追加
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG厚み分
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_SEP   (nth 6 &BGFG_Info)) ; 分離型:1 一体型:0
;
;;;;;;;;; (ｼﾝｸ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type1 1 0.1) ; BGあり
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #pA #pB #dum1))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p22 #dum1))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;      );_if
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type1 0 0.1) ; BGなし
;      (setq #bg_en$ (list nil nil))
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; 通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; 前垂れ前
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type1 2 0.1) ; FG前後
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; 前垂れ前
;      (setq #fg_en2 (MakeTEIMEN (list #x11 #p2 #p22 #dum1))) ; 前垂れ後ろ
;    )
;    ((equal #FG_Type1 3 0.1) ; FG前後右
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #dum1)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x11 #p2 #p33))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #p2 #x11))
;  (setq #WT_LEN (distance #p44 #p33)) ; 01/07/02 Y-CUT
;  (setq #cut_type "20")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;      (setq #cut_type "24")         ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #x11 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (ｺﾝﾛ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;      (cond
;        ((equal #BG_Type1 1 0.1) ; 1枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #x11 #p1 #x33 #dum3 #p11 #dum1)))
;        )
;        ((equal #BG_Type1 0 0.1) ; 1枚目BGなし
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #dum3 #x33)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type2 0 0.1) ; BGなし
;      (cond
;        ((equal #BG_Type1 1 0.1) ; 1枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #x11 #dum1 #end2)))
;        )
;        ((equal #BG_Type1 0 0.1) ; 1枚目BGなし
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; 通常片側
;      (cond
;        ((equal #FG_Type1 1 0.1) ; 1枚目FG前のみ
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type1 2 0.1) ; 1枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #x11 #dum1 #end2)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type2 2 0.1) ; FG前後
;      (cond
;        ((equal #FG_Type1 1 0.1) ; 1枚目FG前のみ
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #dum3 #x33)))
;        )
;        ((equal #FG_Type1 2 0.1) ; 1枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #x11 #p1 #x33 #dum3 #p11 #dum1))) ; 前垂れ後ろ
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; 前垂れ前
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p1 #x33 #sp2 #p55 #p44 #sp1 #x11))))
;  (setq #WT_LEN (distance #p1 #x33))
;  (setq #cut_type "21")
;  (setq #dep (distance #p55 #x3))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #x33 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (その他) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type3 1 0.1) ; 3枚目BGあり
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;            (setq #bg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p66 #pD #pC #p88 #dum3)))
;            ;else 通常
;            (setq #bg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p77 #p88 #dum3)))
;          );_if
;        )
;        ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;          (setq #bg_en1 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type3 0 0.1)
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #x33 #dum3 #end4 #p8)))
;        )
;        ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type3 1 0.1) ; 3枚目FG前側
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2枚目FG前のみ
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type2 2 0.1) ; 2枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #x33 #dum3 #end4 #p8)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type3 2 0.1) ; 3枚目FG両側
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2枚目FG前のみ
;          (setq #fg_en2 (MakeTEIMEN (list #end3 #p8 #p7 #p77)))
;        )
;        ((equal #FG_Type2 2 0.1) ; 2枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #x33 #p8 #p7 #p77 #p88 #dum3)))
;        )
;      );_cond
;
;
;    )
;    ((equal #FG_Type3 3 0.1) ; 3枚目FG前後左
;      (setq #dumPT1 (polar #p666 (angle #p7 #p8) #FG_T))
;      (setq #dumPT2 (polar #p77  (angle #p7 #p8) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p66 #p55 #p555 #dumPT1 #dumPT2 #p88 #dum3)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); 前垂れ底面ﾘｽﾄ 3枚目
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p8 #x33 #sp2 #p55 #p66 #p7))))
;  (setq #WT_LEN (distance #p8 #p7))
;  (setq #cut_type "01")
;  (setq #dep (distance #p66 #p7))
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p7 &outpl_LOW) ; T or nil
;      (setq #cut_type "41")         ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p7 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKUcut2-1
;
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PKUcut2-2
;;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 U型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ2
;;;; <戻り値>    :
;;;; <作成>      : 00/09/27 YM 標準化
;;;; <備考>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut2-2 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$  ;点列
;  &point2$ ;点列2
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #BG_SEP #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP
;  #DUM1 #DUM2 #DUM3 #DUM4 #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #RET #RET$ #SP1 #SP2 #WT_EN #WT_LEN #X1 #X11 #X2 #X22 #X3 #X33 #X4 #X44 #end1 #end2 #end3 #end4
;  #LIS1 #LIS2
;  #DUMPT1 #DUMPT2 #FG_T
;#BG_T #PA #PB #PC #PD #TOP_FLG #FG_S ;03/10/14 YM ADD
;  )
;;;; ＜U型＞
;;;;       end1     x11 x1
;;;; p1+(BASE1)-----*---*------------------------+p2   <---BG背面
;;;;   |   |        |   |                        |
;;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG前面
;;;;   |   |        |   |                        |
;;;;   |   |     +p444--|------------------------+p333 <---FG背面
;;;;   |   |     |  |   |                        |
;;;;x22* - dum2- - -*sp1|             ｼﾝｸ側      | x1,x2 x11,x22はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp1はJｶｯﾄ時の分岐点
;;;;   |   |     |      |                        |
;;;;   |   |     |    +p4------------------------+p3
;;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG前面
;;;;   |   |     |    | |p44
;;;;   |   |     |    | |
;;;;   |   |ｺﾝﾛ側|    | |
;;;;   |   |     |    | |
;;;;   |   |     |    | |
;;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG前面
;;;;   |   |     |    +p5-------------------------+p6
;;;;   |   |     |      |                         |
;;;;x33* - dum3- - -*sp2|          その他         | x3,x4 x33,x44はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp2はJｶｯﾄ時の分岐点
;;;;   |   |     |  |   |                         |
;;;;   |   |     +p555--|-------------------------+p666 <---FG背面
;;;;   |   |        |   |                         |
;;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG前面
;;;;   |   |        |   |                         |
;;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG背面
;;;;       end4    x44 x4
;
;  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
;  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
;  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  (setq #x1  (nth 0 &point2$))
;  (setq #x2  (nth 1 &point2$))
;  (setq #x3  (nth 2 &point2$))
;  (setq #x4  (nth 3 &point2$))
;  (setq #x11 (nth 4 &point2$))
;  (setq #x22 (nth 5 &point2$))
;  (setq #x33 (nth 6 &point2$))
;  (setq #x44 (nth 7 &point2$))
;  (setq #sp1 (nth 8 &point2$))
;  (setq #sp2 (nth 9 &point2$))
;  (setq #dum1 (CFGetDropPt #p22 (list #sp1 #x11)))
;  (setq #dum2 (CFGetDropPt #p11 (list #sp1 #x22)))
;  (setq #dum3 (CFGetDropPt #p11 (list #sp2 #x33)))
;  (setq #dum4 (CFGetDropPt #p77 (list #sp2 #x44)))
;  (setq #end1 (inters #p11 #p88 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p8 nil))
;  (setq #end3 (inters #p77 #p88 #p1 #p8 nil))
;  (setq #end4 (inters #p11 #p88 #p8 #p7 nil))
;
;  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;  ; BG回り込み用の点pA,pB,pC,pDを追加
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG厚み分
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_SEP   (nth 6 &BGFG_Info)) ; 分離型:1 一体型:0
;
;;;;;;;;; (ｼﾝｸ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type1 1 0.1) ; BGあり
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #pA #pB #dum1))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #x11 #p2 #p22 #dum1))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;      );_if
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type1 0 0.1) ; BGなし
;      (setq #bg_en$ (list nil nil))
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; 通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; 前垂れ前
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type1 2 0.1) ; FG前後
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44))) ; 前垂れ前
;      (setq #fg_en2 (MakeTEIMEN (list #x11 #p2 #p22 #dum1))) ; 前垂れ後ろ
;    )
;    ((equal #FG_Type1 3 0.1) ; FG前後右
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x11 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #dum1)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x11 #p2 #p33))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #p2 #x11))
;  (setq #WT_LEN (distance #p44 #p33)) ; 01/07/02 Y-CUT
;  (setq #cut_type "20")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p2 &outpl_LOW) ; T or nil
;      (setq #cut_type "24")         ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #x11 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (ｺﾝﾛ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type2 1 0.1) ; BGあり
;      (cond
;        ((and (equal #BG_Type1 1 0.1)(equal #BG_Type3 1 0.1)) ; 1,3枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #x11 #p1 #p8 #x44 #dum4 #p88 #p11 #dum1)))
;        )
;        ((and (equal #BG_Type1 0 0.1)(equal #BG_Type3 0 0.1)) ; 1,3枚目BGなし
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #end4 #p8)))
;        )
;        ((and (equal #BG_Type1 1 0.1)(equal #BG_Type3 0 0.1)) ; 1枚目BGあり,3枚目BGなし
;          (setq #bg_en1 (MakeTEIMEN (list #x11 #p1 #p8 #end4 #p11 #dum1)))
;        )
;        ((and (equal #BG_Type1 0 0.1)(equal #BG_Type3 1 0.1)) ; 1枚目BGなし,3枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #p8 #x44 #dum4 #p88 #end1)))
;        )
;      );_cond
;      (setq #bg_en2 nil)
;    )
;    ((equal #BG_Type2 0 0.1) ; BGなし
;      (cond
;        ((and (equal #BG_Type1 1 0.1)(equal #BG_Type3 1 0.1)) ; 1,3枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #x11 #dum1 #end2)))
;          (setq #bg_en2 (MakeTEIMEN (list #end3 #dum4 #x44 #p8)))
;        )
;        ((and (equal #BG_Type1 0 0.1)(equal #BG_Type3 0 0.1)) ; 1,3枚目BGなし
;          (setq #bg_en1 nil)
;          (setq #bg_en2 nil)
;        )
;        ((and (equal #BG_Type1 1 0.1)(equal #BG_Type3 0 0.1)) ; 1枚目BGあり,3枚目BGなし
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #x11 #dum1 #end2)))
;          (setq #bg_en2 nil)
;        )
;        ((and (equal #BG_Type1 0 0.1)(equal #BG_Type3 1 0.1)) ; 1枚目BGなし,3枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #end3 #dum4 #x44 #p8)))
;          (setq #bg_en2 nil)
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; 通常片側
;      (cond
;        ((and (equal #FG_Type1 1 0.1)(equal #FG_Type3 1 0.1)) ; 1,3枚目FG前
;          (setq #fg_en2 nil)
;        )
;        ((and (equal #FG_Type1 2 0.1)(equal #FG_Type3 2 0.1)) ; 1,3枚目FG前後
;          (CFAlertMsg "このﾊﾟﾀｰﾝは対応できません。\n別のﾊﾟﾀｰﾝでﾜｰｸﾄｯﾌﾟを作成後、前垂れ追加ｺﾏﾝﾄﾞを使用して下さい。")
;          (*error*)
;        )
;        ((and (equal #FG_Type1 1 0.1)(equal #FG_Type3 2 0.1)) ; 1枚目FG前,3枚目BG前後
;          (setq #fg_en2 (MakeTEIMEN (list #end3 #dum4 #x44 #p8)))
;        )
;        ((and (equal #FG_Type1 2 0.1)(equal #FG_Type3 1 0.1)) ; 1枚目FG前後,3枚目BG前
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #x11 #dum1 #end2)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type2 2 0.1) ; FG前後
;      (cond
;        ((and (equal #FG_Type1 1 0.1)(equal #FG_Type3 1 0.1)) ; 1,3枚目FG前
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #end4 #p8)))
;        )
;        ((and (equal #FG_Type1 2 0.1)(equal #FG_Type3 2 0.1)) ; 1,3枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #x11 #p1 #p8 #x44 #dum4 #p88 #p11 #dum1)))
;        )
;        ((and (equal #FG_Type1 1 0.1)(equal #FG_Type3 2 0.1)) ; 1枚目FG前,3枚目BG前後
;          (setq #fg_en2 (MakeTEIMEN (list #end1 #p1 #p8 #x44 #dum4 #p88)))
;        )
;        ((and (equal #FG_Type1 2 0.1)(equal #FG_Type3 1 0.1)) ; 1枚目FG前後,3枚目BG前
;          (setq #fg_en2 (MakeTEIMEN (list #x11 #p1 #p8 #end4 #p11 #dum1)))
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; 前垂れ前
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p1 #p8 #x44 #sp2 #p55 #p44 #sp1 #x11))))
;  (setq #WT_LEN (distance #p1 #p8))
;  (setq #cut_type "11")
;  (setq #dep (distance #x2 #p44))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p8 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (その他) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type3 1 0.1) ; BGあり
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #x44 #p7 #p66 #pD #pC #dum4))) ; 3枚目BGあり
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #x44 #p7 #p77 #dum4))) ; 3枚目BGあり
;      );_if
;    )
;    ((equal #BG_Type3 0 0.1)
;      (setq #bg_en1 nil)                                   ; 3枚目BGなし
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type3 1 0.1) ; FG前側
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); 前垂れ底面ﾘｽﾄ 3枚目
;      (setq #fg_en2 nil)                                      ; 3枚目FG通常
;    )
;    ((equal #FG_Type3 2 0.1) ; FG両側
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); 前垂れ底面ﾘｽﾄ 3枚目前
;      (setq #fg_en2 (MakeTEIMEN (list #x44 #p7 #p77 #dum4)))    ; 3枚目FG両側後ろ
;    )
;    ((equal #FG_Type3 3 0.1) ; FG前後左
;      (setq #dumPT1 (polar #p666 (angle #p7 #p8) #FG_T))
;      (setq #dumPT2 (polar #p77  (angle #p7 #p8) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x44 #p7 #p66 #p55 #p555 #dumPT1 #dumPT2 #dum4)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #x44 #sp2 #p55 #p66 #p7))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #x44 #p7))
;  (setq #WT_LEN (distance #p55 #p66)) ; 01/07/02 Y-CUT
;  (setq #cut_type "02")
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p7 &outpl_LOW) ; T or nil
;      (setq #cut_type "42")         ; 段差だった
;    );_if
;  );_if
;  (setq #dep (distance #p66 #p7))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p7 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKUcut2-2
;
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PKUcut2-3
;;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 U型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ3
;;;; <戻り値>    :
;;;; <作成>      : 00/09/27 YM 標準化
;;;; <備考>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut2-3 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$  ;点列
;  &point2$ ;点列2
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #BG_SEP #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP
;  #DUM1 #DUM2 #DUM3 #DUM4 #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #RET #RET$ #SP1 #SP2 #WT_EN #WT_LEN #X1 #X11 #X2 #X22 #X3 #X33 #X4 #X44 #end1 #end2 #end3 #end4
;  #LIS1 #LIS2
;  #DUMPT1 #DUMPT2 #FG_T
;#BG_T #PA #PB #PC #PD #TOP_FLG #FG_S ;03/10/14 YM ADD
;  )
;;;; ＜U型＞
;;;;       end1     x11 x1
;;;; p1+(BASE1)-----*---*------------------------+p2   <---BG背面
;;;;   |   |        |   |                        |
;;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG前面
;;;;   |   |        |   |                        |
;;;;   |   |     +p444--|------------------------+p333 <---FG背面
;;;;   |   |     |  |   |                        |
;;;;x22* - dum2- - -*sp1|             ｼﾝｸ側      | x1,x2 x11,x22はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp1はJｶｯﾄ時の分岐点
;;;;   |   |     |      |                        |
;;;;   |   |     |    +p4------------------------+p3
;;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG前面
;;;;   |   |     |    | |p44
;;;;   |   |     |    | |
;;;;   |   |ｺﾝﾛ側|    | |
;;;;   |   |     |    | |
;;;;   |   |     |    | |
;;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG前面
;;;;   |   |     |    +p5-------------------------+p6
;;;;   |   |     |      |                         |
;;;;x33* - dum3- - -*sp2|          その他         | x3,x4 x33,x44はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp2はJｶｯﾄ時の分岐点
;;;;   |   |     |  |   |                         |
;;;;   |   |     +p555--|-------------------------+p666 <---FG背面
;;;;   |   |        |   |                         |
;;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG前面
;;;;   |   |        |   |                         |
;;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG背面
;;;;       end4    x44 x4
;
;  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
;  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
;  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  (setq #x1  (nth 0 &point2$))
;  (setq #x2  (nth 1 &point2$))
;  (setq #x3  (nth 2 &point2$))
;  (setq #x4  (nth 3 &point2$))
;  (setq #x11 (nth 4 &point2$))
;  (setq #x22 (nth 5 &point2$))
;  (setq #x33 (nth 6 &point2$))
;  (setq #x44 (nth 7 &point2$))
;  (setq #sp1 (nth 8 &point2$))
;  (setq #sp2 (nth 9 &point2$))
;  (setq #dum1 (CFGetDropPt #p22 (list #sp1 #x11)))
;  (setq #dum2 (CFGetDropPt #p11 (list #sp1 #x22)))
;  (setq #dum3 (CFGetDropPt #p11 (list #sp2 #x33)))
;  (setq #dum4 (CFGetDropPt #p77 (list #sp2 #x44)))
;  (setq #end1 (inters #p11 #p88 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p8 nil))
;  (setq #end3 (inters #p77 #p88 #p1 #p8 nil))
;  (setq #end4 (inters #p11 #p88 #p8 #p7 nil))
;
;  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;  ; BG回り込み用の点pA,pB,pC,pDを追加
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG厚み分
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_SEP   (nth 6 &BGFG_Info)) ; 分離型:1 一体型:0
;
;;;;;;;;; (ｼﾝｸ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type1 1 0.1) ; 1枚目BGあり
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #pA #pB #p11 #dum2)))
;            ;else 通常
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum2)))
;          );_if
;        )
;        ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type1 0 0.1) ; 1枚目BGなし
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #dum2 #x22)))
;        )
;        ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; 通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44)))
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2枚目FG前
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type2 2 0.1) ; 2枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #dum2 #x22)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 2 0.1) ; FG前後
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44)))
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2枚目FG前
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;        )
;        ((equal #FG_Type2 2 0.1) ; 2枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum2)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 3 0.1) ; FG前後右
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #p11 #dum2)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x22 #p1 #p2 #p33))))
;  (setq #WT_LEN (distance #p2 #p1))
;  (setq #cut_type "10")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")           ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p2 &outpl_LOW)  ; T or nil
;      (setq #cut_type "14")          ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p1 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (ｺﾝﾛ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type2 1 0.1) ; BGあり
;      (setq #bg_en1 (MakeTEIMEN (list #x22 #x33 #dum3 #dum2))) ; ﾊﾞｯｸｶﾞｰﾄﾞ底面
;      (setq #bg_en2 nil)
;      (setq #bg_en$ (list #bg_en1 #bg_en2))
;    )
;    ((equal #BG_Type2 0 0.1) ; BGなし
;      (setq #bg_en$ (list nil nil))
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; 通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; 前垂れ前
;      (setq #fg_en2 nil)
;    )
;    ((equal #FG_Type2 2 0.1) ; FG前後
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; 前垂れ前
;      (setq #fg_en2 (MakeTEIMEN (list #x22 #x33 #dum3 #dum2))) ; 前垂れ後ろ
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #x22 #x33 #sp2 #p55 #p44 #sp1))))
;  (setq #WT_LEN (distance #p44 #p55))
;;;;01/07/09YM@  (setq #WT_LEN (distance #x22 #x33))
;  (setq #cut_type "22")
;  (setq #dep (distance #x2 #p44))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #x33 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (その他) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type3 1 0.1) ; 3枚目BGあり
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;            (setq #bg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p66 #pD #pC #p88 #dum3)))
;            ;else 通常
;            (setq #bg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p77 #p88 #dum3)))
;          );_if
;        )
;        ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;          (setq #bg_en1 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type3 0 0.1)
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #x33 #p8 #end4 #dum3)))
;        )
;        ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type3 1 0.1) ; FG前側
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); 前垂れ底面ﾘｽﾄ 3枚目
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2枚目FG前
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type2 2 0.1) ; 2枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #x33 #dum3 #end4 #p8)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type3 2 0.1) ; FG両側
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); 前垂れ底面ﾘｽﾄ 3枚目前
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2枚目FG前
;          (setq #fg_en2 (MakeTEIMEN (list #end3 #p77 #p7 #p8)))
;        )
;        ((equal #FG_Type2 2 0.1) ; 2枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #x33 #p8 #p7 #p77 #p88 #dum3)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type3 3 0.1) ; FG前後左
;      (setq #dumPT1 (polar #p666 (angle #p7 #p8) #FG_T))
;      (setq #dumPT2 (polar #p77  (angle #p7 #p8) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x33 #p8 #p7 #p66 #p55 #p555 #dumPT1 #dumPT2 #p88 #dum3)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p8 #x33 #sp2 #p55 #p66 #p7))))
;  (setq #WT_LEN (distance #p8 #p7))
;  (setq #cut_type "01")
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p7 &outpl_LOW) ; T or nil
;      (setq #cut_type "41")         ; 段差だった
;    );_if
;  );_if
;  (setq #dep (distance #p66 #p7))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p7 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKUcut2-3
;
;;;;<HOM>*************************************************************************
;;;; <関数名>    : PKUcut2-4
;;;; <処理概要>  : WT,BG,FG底面ﾎﾟﾘﾗｲﾝの作成 U型方向ｶｯﾄ(ID=2) ﾊﾟﾀｰﾝ4
;;;; <戻り値>    :
;;;; <作成>      : 00/09/27 YM 標準化
;;;; <備考>      :
;;;;*************************************************************************>MOH<
;(defun PKUcut2-4 (
;  &WTINFO
;  &ZaiCode
;  &outpl_LOW
;  &point$  ;点列
;  &point2$ ;点列2
;  &BGFG_Info
;  /
;  #BG_EN$ #BG_EN1 #BG_EN2 #BG_SEP #BG_TYPE1 #BG_TYPE2 #BG_TYPE3 #CUT_TYPE #DEP
;  #DUM1 #DUM2 #DUM3 #DUM4 #FG_EN$ #FG_EN1 #FG_EN2 #FG_TYPE1 #FG_TYPE2 #FG_TYPE3
;  #P1 #P11 #P2 #P22 #P3 #P33 #P333 #P4 #P44 #P444 #P5 #P55 #P555 #P6 #P66 #P666 #P7 #P77 #P8 #P88
;  #RET #RET$ #SP1 #SP2 #WT_EN #WT_LEN #X1 #X11 #X2 #X22 #X3 #X33 #X4 #X44 #end1 #end2 #end3 #end4
;  #LIS1 #LIS2
;  #DUMPT1 #DUMPT2 #FG_T
;#BG_T #PA #PB #PC #PD #TOP_FLG #FG_S ;03/10/14 YM ADD
;  )
;;;; ＜U型＞
;;;;       end1     x11 x1
;;;; p1+(BASE1)-----*---*------------------------+p2   <---BG背面
;;;;   |   |        |   |                        |
;;;; end2--+p11-----dum1|--------------------B+--+p22  <---BG前面
;;;;   |   |        |   |                        |
;;;;   |   |     +p444--|------------------------+p333 <---FG背面
;;;;   |   |     |  |   |                        |
;;;;x22* - dum2- - -*sp1|             ｼﾝｸ側      | x1,x2 x11,x22はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp1はJｶｯﾄ時の分岐点
;;;;   |   |     |      |                        |
;;;;   |   |     |    +p4------------------------+p3
;;;; x2* - - - - - - - -+--------------------A+--+p33  <---FG前面
;;;;   |   |     |    | |p44
;;;;   |   |     |    | |
;;;;   |   |ｺﾝﾛ側|    | |
;;;;   |   |     |    | |
;;;;   |   |     |    | |
;;;; x3* - - - - - - - -+p55------------------D+--+p66  <---FG前面
;;;;   |   |     |    +p5-------------------------+p6
;;;;   |   |     |      |                         |
;;;;x33* - dum3- - -*sp2|          その他         | x3,x4 x33,x44はｶｯﾄ方向(ﾕｰｻﾞｰ指示)により変化 sp2はJｶｯﾄ時の分岐点
;;;;   |   |     |  |   |                         |
;;;;   |   |     +p555--|-------------------------+p666 <---FG背面
;;;;   |   |        |   |                         |
;;;; end3--+p88-----dum4|---------------------C+--+p77  <---BG前面
;;;;   |   |        |   |                         |
;;;; p8+(BASE2)-----*---*-------------------------+p7   <---BG背面
;;;;       end4    x44 x4
;
;  (setq #BG_T     (nth 3 &WTInfo )) ; BGの厚み
;  (setq #FG_T     (nth 5 &WTInfo )) ; FGの厚み
;  (setq #FG_S     (nth 6 &WTInfo )) ; 前垂れシフト量
;  (setq #BG_Sep   (nth 7 &WTInfo )) ; BG分離
;  (setq #TOP_FLG  (nth 8 &WTInfo )) ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ
;
;  (setq #p1 (nth 0 &point$))
;  (setq #p2 (nth 1 &point$))
;  (setq #p3 (nth 2 &point$))
;  (setq #p4 (nth 3 &point$))
;  (setq #p5 (nth 4 &point$))
;  (setq #p6 (nth 5 &point$))
;  (setq #p7 (nth 6 &point$))
;  (setq #p8 (nth 7 &point$))
;
;  (setq #p11 (nth  8 &point$))
;  (setq #p22 (nth  9 &point$))
;  (setq #p33 (nth 10 &point$))
;  (setq #p44 (nth 11 &point$))
;  (setq #p55 (nth 12 &point$))
;  (setq #p66 (nth 13 &point$))
;  (setq #p77 (nth 14 &point$))
;  (setq #p88 (nth 15 &point$))
;
;  (setq #p333 (nth 16 &point$))
;  (setq #p444 (nth 17 &point$))
;  (setq #p555 (nth 18 &point$))
;  (setq #p666 (nth 19 &point$))
;
;  (setq #x1  (nth 0 &point2$))
;  (setq #x2  (nth 1 &point2$))
;  (setq #x3  (nth 2 &point2$))
;  (setq #x4  (nth 3 &point2$))
;  (setq #x11 (nth 4 &point2$))
;  (setq #x22 (nth 5 &point2$))
;  (setq #x33 (nth 6 &point2$))
;  (setq #x44 (nth 7 &point2$))
;  (setq #sp1 (nth 8 &point2$))
;  (setq #sp2 (nth 9 &point2$))
;  (setq #dum1 (CFGetDropPt #p22 (list #sp1 #x11)))
;  (setq #dum2 (CFGetDropPt #p11 (list #sp1 #x22)))
;  (setq #dum3 (CFGetDropPt #p11 (list #sp2 #x33)))
;  (setq #dum4 (CFGetDropPt #p77 (list #sp2 #x44)))
;  (setq #end1 (inters #p11 #p88 #p2 #p1 nil))
;  (setq #end2 (inters #p11 #p22 #p1 #p8 nil))
;  (setq #end3 (inters #p77 #p88 #p1 #p8 nil))
;  (setq #end4 (inters #p11 #p88 #p8 #p7 nil))
;
;  ;03/09/22 YM ADD 特異ﾄｯﾌﾟﾌﾗｸﾞ対応
;  ; BG回り込み用の点pA,pB,pC,pDを追加
;  (setq #pA  (polar #p33  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pB  (polar #p22  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pC  (polar #p77  (angle #p2 #p1) #BG_T)) ; BG厚み分
;  (setq #pD  (polar #p66  (angle #p2 #p1) #BG_T)) ; BG厚み分
;
;  (setq #BG_Type1 (nth 0 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type1 (nth 1 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type2 (nth 2 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type2 (nth 3 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_Type3 (nth 4 &BGFG_Info)) ; BG有無 1:あり 0:なし
;  (setq #FG_Type3 (nth 5 &BGFG_Info)) ; FGﾀｲﾌﾟ 1:片側 2:両側
;  (setq #BG_SEP   (nth 6 &BGFG_Info)) ; 分離型:1 一体型:0
;
;;;;;;;;; (ｼﾝｸ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type1 1 0.1) ; 1枚目BGあり
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;          (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #pA #pB #p11 #dum2)))
;            ;else 通常
;            (setq #bg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum2)))
;          );_if
;        )
;        ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type1 0 0.1) ; 1枚目BGなし
;      (cond
;        ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #p1 #end1 #dum2 #x22)))
;        )
;        ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type1 1 0.1) ; 通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44)))
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2枚目FG前
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type2 2 0.1) ; 2枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #end1 #dum2 #x22)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 2 0.1) ; FG前後
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p333 #p33 #p44)))
;      (cond
;        ((equal #FG_Type2 1 0.1) ; 2枚目FG前
;          (setq #fg_en2 (MakeTEIMEN (list #p1 #p2 #p22 #end2)))
;        )
;        ((equal #FG_Type2 2 0.1) ; 2枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #x22 #p1 #p2 #p22 #p11 #dum2)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type1 3 0.1) ; FG前後右
;      (setq #dumPT1 (polar #p333 (angle #p2 #p1) #FG_T))
;      (setq #dumPT2 (polar #p22  (angle #p2 #p1) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x22 #p1 #p2 #p33 #p44 #p444 #dumPT1 #dumPT2 #p11 #dum2)))
;      (setq #fg_en2 nil)
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #p44 #sp1 #x22 #p1 #p2 #p33))))
;  (setq #WT_LEN (distance #p2 #p1))
;  (setq #cut_type "10")
;  (setq #dep (distance #p33 #p2))
;  (if (= CG_Type2Code "D")           ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p2 &outpl_LOW)  ; T or nil
;      (setq #cut_type "14")          ; 段差だった
;    );_if
;  );_if
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p1 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (ｺﾝﾛ側) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type2 1 0.1) ; 2枚目BGあり
;      (cond
;        ((equal #BG_Type3 1 0.1) ; 3枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #x22 #p8 #x44 #dum4 #p88 #dum2)))
;        )
;        ((equal #BG_Type3 0 0.1) ; 3枚目BGなし
;          (setq #bg_en1 (MakeTEIMEN (list #x22 #dum2 #end4 #p8)))
;        )
;      );_cond
;    )
;    ((equal #BG_Type2 0 0.1) ; 2枚目BGなし
;      (cond
;        ((equal #BG_Type3 1 0.1) ; 3枚目BGあり
;          (setq #bg_en1 (MakeTEIMEN (list #end3 #dum4 #x44 #p8)))
;        )
;        ((equal #BG_Type3 0 0.1) ; 3枚目BGなし
;          (setq #bg_en1 nil)
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\nﾊﾞｯｸｶﾞｰﾄﾞﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type2 1 0.1) ; 通常片側
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44)))
;      (cond
;        ((equal #FG_Type3 1 0.1) ; 3枚目FG前
;          (setq #fg_en2 nil)
;        )
;        ((equal #FG_Type3 2 0.1) ; 3枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #end3 #dum4 #x44 #p8)))
;        )
;      );_cond
;    )
;    ((equal #FG_Type2 2 0.1) ; FG前後
;      (setq #fg_en1 (MakeTEIMEN (list #p444 #p555 #p55 #p44))) ; 前垂れ前
;      (cond
;        ((equal #FG_Type3 1 0.1) ; 3枚目FG前
;          (setq #fg_en2 (MakeTEIMEN (list #x22 #dum2 #end4 #p8)))
;        )
;        ((equal #FG_Type3 2 0.1) ; 3枚目FG前後
;          (setq #fg_en2 (MakeTEIMEN (list #x22 #p8 #x44 #dum4 #p88 #dum2)))
;        )
;      );_cond
;    )
;    (T
;      (CFAlertMsg "\n前垂れﾀｲﾌﾟが不正です。")(quit)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #x22 #p8 #x44 #sp2 #p55 #p44 #sp1))))
;  (setq #WT_LEN (distance #x22 #p8))
;  (setq #cut_type "12")
;  (setq #dep (distance #x2 #p44))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p8 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;;;;;;;;; (その他) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  (cond
;    ((equal #BG_Type3 1 0.1) ; BGあり
;      (if (equal #TOP_FLG 1 0.1);03/09/22 YM ADD 特異ﾄｯﾌﾟ対応 BG回り込み(ﾃﾞｨﾌﾟﾛｱ)
;        (setq #bg_en1 (MakeTEIMEN (list #x44 #p7 #p66 #pD #pC #dum4))) ; 3枚目BGあり
;        ;else 通常
;        (setq #bg_en1 (MakeTEIMEN (list #x44 #p7 #p77 #dum4))) ; 3枚目BGあり
;      );_if
;    )
;    ((equal #BG_Type3 0 0.1)
;      (setq #bg_en1 nil)                                   ; 3枚目BGなし
;    )
;  );_cond
;
;  (setq #bg_en2 nil)
;  (setq #bg_en$ (list #bg_en1 #bg_en2))
;
;  (cond
;    ((equal #FG_Type3 1 0.1) ; FG前側
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); 前垂れ底面ﾘｽﾄ 3枚目
;      (setq #fg_en2 nil)                                      ; 3枚目FG通常
;    )
;    ((equal #FG_Type3 2 0.1) ; FG両側
;      (setq #fg_en1 (MakeTEIMEN (list #p66 #p55 #p555 #p666))); 前垂れ底面ﾘｽﾄ 3枚目前
;      (setq #fg_en2 (MakeTEIMEN (list #x44 #p7 #p77 #dum4)))    ; 3枚目FG両側後ろ
;    )
;    ((equal #FG_Type3 3 0.1) ; FG前後左
;      (setq #dumPT1 (polar #p666 (angle #p7 #p8) #FG_T))
;      (setq #dumPT2 (polar #p77  (angle #p7 #p8) #FG_T))
;      (setq #fg_en1 (MakeTEIMEN (list #x44 #p7 #p66 #p55 #p555 #dumPT1 #dumPT2 #dum4)))
;      (setq #fg_en2 nil)
;    )
;  );_cond
;
;  (setq #fg_en$ (list #fg_en1 #fg_en2))
;
;  (setq #wt_en (MakeTEIMEN (RemoveSamePT (list #x44 #sp2 #p55 #p66 #p7))))
;;;;01/07/02YM@  (setq #WT_LEN (distance #x44 #p7))
;  (setq #WT_LEN (distance #p55 #p66)) ; 01/07/02 Y-CUT
;  (setq #cut_type "02")
;  (if (= CG_Type2Code "D")          ; ﾛｰｷｬﾋﾞの検索
;    (if (PKSLOWPLCP #p7 &outpl_LOW) ; T or nil
;      (setq #cut_type "42")         ; 段差だった
;    );_if
;  );_if
;  (setq #dep (distance #p66 #p7))
;  (setq #ret (list #wt_en #bg_en$ #fg_en$ #cut_type (list #dep 0) (list #WT_LEN 0) #p7 0))
;  (setq #ret$ (append #ret$ (list #ret)))
;  #ret$
;);PKUcut2-4
;-- 2011/08/25 A.Satoh Del - E

;<HOM>*************************************************************************
; <関数名>    : PKDecideLRCODE
; <処理概要>  : LR勝手をきくﾀﾞｲｱﾛｸﾞを表示
; <作成>      : 2000.4.18  YM
;*************************************************************************>MOH<
(defun PKDecideLRCODE (
  /
   #dcl_id ##GetDlgItem #ret
  )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( / #L #R #ret)

            (setq #L (get_tile "L"))
            (setq #R (get_tile "R"))

            (cond
              ((= #L "1")
               (setq #ret "L")
              )
              ((= #R "1")
               (setq #ret "R")
              )
            );_cond
            (done_dialog)
            #ret
          )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (= nil (new_dialog "LRCODE_Dlg" #dcl_id)) (exit))

  (action_tile "accept" "(setq #ret (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret nil) (done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)
  #ret
);PKDecideLRCODE

;<HOM>***********************************************************************
; <関数名>    : GetBGLEN
; <処理概要>  : BG底面図形--->BG長さ(BG底面辺の長さの最大値)
; <引数>      : BG底面図形
; <戻り値>    : BG長さ
; <作成>      : 00/04/23 YM
; <備考>      :
;***********************************************************************>HOM<
(defun GetBGLEN (
  &BG  ; BG底面図形名
  /
  #DIS #I #KOSU #MAX #PT$ #PT2$
  )
  (setq #pt$ (GetLWPolyLinePt &BG)) ; BGの外形点列
  (setq #pt2$ (AddPtList #pt$)) ; 末尾に始点を追加する

  (setq #kosu (length #pt$)) ; 通常4
  (setq #i 0 #max -99999)
  (repeat #kosu ;=4
    (setq #dis (distance (nth #i #pt2$) (nth (1+ #i) #pt2$)))
    (if (>= #dis #max)(setq #max #dis)) ; 長さの最大を求める
    (setq #i (1+ #i))
  )
  #max ; BGの長さ
);GetBGLEN

;;;<HOM>***********************************************************************
;;; <関数名>    : PKSetBGXData
;;; <処理概要>  :
;;; 拡張ﾃﾞｰﾀ G_BKGDのｾｯﾄ
;;; 1. 品番名称("dummy")
;;; 2. BG底面図形ﾊﾝﾄﾞﾙﾘｽﾄ
;;; 3. 関連WT図形ﾊﾝﾄﾞﾙ
;;; 4. BG長さ
;;; 5. BG金額
;;; <戻り値>    : なし
;;; <作成>      : 00/09/21 YM 標準化
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun PKSetBGXData (
  &BG_SOLID$ ; BG図形名ﾘｽﾄ (list #BG_SOLID1 #BG_SOLID2)
  &cutL      ; WTｶｯﾄ左
  &cutR      ; WTｶｯﾄ右
  &ZAI       ; 材質記号
  &BG0$      ; BG底面図形名 (list #BG01 #BG02)
  &WT_SOLID  ; 関連WT図形名
  &D150      ; 段差用ＢＧ==> T(Tなら段差部分のＷＴと判断)
  /
  #BG01 #BG02 #BG_ALL_LEN #BG_LEN1 #BG_LEN2 #BG_PRICE #BG_SOLID1 #BG_SOLID2 #BKGDCODE1 #BKGDCODE2
  )
  (setq #BG_ALL_LEN 0 #BG_LEN1 nil #BG_LEN2 nil) ; BG_ALL_LEN この関数でｾｯﾄしたBG長さのtotal
  (setq #BG_SOLID1 (car  &BG_SOLID$))
  (setq #BG_SOLID2 (cadr &BG_SOLID$)) ; nil あり
  (setq #BG01 (car  &BG0$))           ; BG底面1
  (setq #BG02 (cadr &BG0$))           ; nil あり

  (if (and #BG_SOLID1 (/= #BG_SOLID1 ""))
    (progn
    ;;; BGの長さを求る
      (if (/= #BG01 "") (setq #BG_LEN1 (GetBGLEN #BG01)))
      (if (/= #BG02 "") (setq #BG_LEN2 (GetBGLEN #BG02)))

      (setq #BKGDCode1 "dummy") ; 00/09/21 YM ダミー
      (setq #BG_PRICE 0)        ; 00/09/21 YM ダミー
      (CFSetXData #BG_SOLID1 "G_BKGD"
        (list
          #BKGDCode1
          #BG01
          &WT_SOLID
          #BG_LEN1
          #BG_PRICE
        )
      )
      (setq #BG_ALL_LEN (+ #BG_ALL_LEN #BG_LEN1))

      (if (and (/= #BG02 "") (/= #BG_SOLID2 "")(/= #BG_LEN2 nil))
        (progn
          (setq #BKGDCode2 "dummy")
          (setq #BG_PRICE 0)
          (CFSetXData #BG_SOLID2 "G_BKGD"
            (list
              #BKGDCode2
              #BG02
              &WT_SOLID
              #BG_LEN2
              #BG_PRICE
            )
          )
          (setq #BG_ALL_LEN (+ #BG_ALL_LEN #BG_LEN2))
        )
      )
    )
  );_if
  #BG_ALL_LEN ; この関数でG_BKGDをｾｯﾄしたBGのtotal長さ
);PKSetBGXData

;<HOM>***********************************************************************
; <関数名>    : PKGetBGPrice
; <処理概要>  : BG品番からBG価格を求める
; <戻り値>    : BG価格
; <作成>      : 00/05/31 YM
; <備考>      :
;***********************************************************************>HOM<
(defun PKGetBGPrice (
  &BKGDCode ; BG品番
  /
  #BG_PRICE #QRY$
  )
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "WT基価格"
      (list
        (list "品番基本部" (substr &BKGDCode  1 8) 'STR)
        (list "色柄記号"   (substr &BKGDCode 12 1)  'STR)
      )
    )
  );_(setq #qry$$
  (setq #qry$ (DBCheck #qry$ "『WT基価格』" (strcat "品番基本部=" (substr &BKGDCode  1 8) " 色柄記号=" (substr &BKGDCode 12 1))))
  (setq #BG_PRICE (nth 3 #qry$)) ; BG価格
  #BG_PRICE
);PKGetBGPrice

;;;<HOM>*************************************************************************
;;; <関数名>    : PKMoveTempLayer
;;; <処理概要>  : 引数図形をすべてﾃﾝﾎﾟﾗﾘ画層に移動
;;; <戻り値>    : なし
;;; <作成>      : 2000.3.22 YM
;;; <備考>      : なし
;;;*************************************************************************>MOH<
(defun PKMoveTempLayer (
  &lis$ ; 図形名ﾘｽﾄ
  &flg  ; nil(1以外):元を消す 1:元を残す
  /
  #EG$ #I #LIS$
  )
  (setq #i 0)
  (repeat (length &lis$)
    (setq #eg$ (entget (nth #i &lis$)))
    (entmake (subst (cons 8 SKD_TEMP_LAYER) (assoc 8 #eg$) #eg$))
    (setq #lis$ (append #lis$ (list (entlast)))) ; 戻り値
    (if (= &flg 1)
      (entdel (nth #i &lis$)) ; 元を削除
    )
    (setq #i (1+ #i))
  )
  #lis$ ; 戻り値
);PKMoveTempLayer

;;;<HOM>*************************************************************************
;;; <関数名>    : PKMKWT
;;; <処理概要>  : ﾜｰｸﾄｯﾌﾟの生成 Z方向移動
;;; <戻り値>    : SOLID図形名
;;; <作成>      : 2000.3.15 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKMKWT (
  &region      ; ﾜｰｸﾄｯﾌﾟregion図形名
  &WT_T        ; 押し出し高さ
  &WT_H        ; ﾜｰｸﾄｯﾌﾟ取り付け高さ
  /
  #RET
  )
  ;2008/07/28 YM MOD 2009対応
  (command "_.extrude" &region "" &WT_T) ; region を Z方向に押し出し
;;;  (command "_.extrude" &region "" &WT_T "") ; region を Z方向に押し出し

  (setq #ret (entlast)) ; SOLID 図形名
  (command "_move" #ret "" '(0 0 0) (strcat "@0,0," (rtos &WT_H)))
  (entmod (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #ret)) (entget #ret))) ; WT専用の画層
  (entlast)
);PKMKWT

;;;<HOM>*************************************************************************
;;; <関数名>    : PKMKFG2
;;; <処理概要>  : ﾌﾛﾝﾄｶﾞｰﾄﾞの生成 Z方向移動
;;; <戻り値>    : SOLID図形名
;;; <作成>      : 2000.3.15 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKMKFG2 (
    &region      ; ﾊﾞｯｸｶﾞｰﾄﾞregion図形名ﾘｽﾄ
    &FG_H        ; 押し出し高さ
    &WT_H        ; ﾜｰｸﾄｯﾌﾟ取り付け高さ
    &WT_T        ; ﾜｰｸﾄｯﾌﾟ厚み
    /
    #FrontPline #i #RET #ss_ret
  )
  ;2008/07/28 YM MOD 2009対応
  (command "_.extrude" &region "" (- &WT_T &FG_H) ) ; region を -Z方向に押し出し
;;;  (command "_.extrude" &region "" (- &WT_T &FG_H) "") ; region を -Z方向に押し出し
  (setq #ret (entlast)) ; SOLID 図形名
  (command "_move" #ret "" '(0 0 0) (strcat "@0,0," (rtos &WT_H)))
  (entmod (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #ret)) (entget #ret))) ; WT専用の画層
  (entlast)
);PKMKFG2

;;;<HOM>*************************************************************************
;;; <関数名>    : PKMKBG2
;;; <処理概要>  : ﾊﾞｯｸｶﾞｰﾄﾞの生成 Z方向移動
;;; <戻り値>    : SOLID図形名
;;; <作成>      : 2000.3.15 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKMKBG2 (
  &region      ; ﾊﾞｯｸｶﾞｰﾄﾞregion図形名ﾘｽﾄ
  &BG_H        ; 押し出し高さ
  &WT_T        ; ﾜｰｸﾄｯﾌﾟ厚み
  &WT_H        ; ﾜｰｸﾄｯﾌﾟ取り付け高さ
  /
  #BackPline #i #MOVE #RET
  )
  ;2008/07/28 YM MOD 2009対応
  (command "_.extrude" &region "" &BG_H) ; region を Z方向に押し出し
;;;  (command "_.extrude" &region "" &BG_H "") ; region を Z方向に押し出し
  (setq #ret (entlast)) ; SOLID 図形名
  (setq #move (+ &WT_T &WT_H))
  (command "_move" #ret "" '(0 0 0) (strcat "@0,0," (rtos #move)))
  (entmod (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #ret)) (entget #ret))) ; WT専用の画層
  (entlast)
);PKMKBG2

;;;<HOM>*************************************************************************
;;; <関数名>    : Make_Region2
;;; <処理概要>  : ﾜｰｸﾄｯﾌﾟの生成(extrude)に必要なregionを作成する
;;; <戻り値>    : region図形名
;;; <作成>      : 2000.3.15 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun Make_Region2 ( &OutPline / )
  (command "_.region" &OutPline "") 
  (entlast)
);Make_Region2

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_PosWTR_plan
;;; <処理概要>  : 水栓を配置する(プラン検索)
;;; <戻り値>    :
;;;        LIST : 水栓穴(G_WTR)図形のリスト
;;; <作成>      : 1999-10-21
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKW_PosWTR_plan (
  &KCode        ;(STR)工種記号
  &SeriCode     ;(STR)SERIES記号
  &snk-en       ;(ENAME)シンク基準図形 (Lipple のときは nil)
  &snk-cd       ;(STR)シンク記号
  &qry$$        ;水栓構成ﾚｺｰﾄﾞのﾘｽﾄ nilあり
  /
;-- 2011/09/09 A.Satoh Mod - S
;  #ANG #DUM #EN #FIG-QRY$ #FLG #HINBAN #K #KEI #MSG #O #OS #ANA_layer
  #ANG #EN #FIG-QRY$ #FLG #HINBAN #K #KEI #MSG #O #OS #ANA_layer
;-- 2011/09/09 A.Satoh Mod - E
  #PTEN5 #PTEN5$$ #SM #SS_DUM #WTRHOLEEN$ #XD_PTEN$ #ZOKU #ZOKUP #ZOKUP$
  #DWG #I #PTEN5$ #RET$ #XD_PTEN5$
  #DUM_EN #II #KIKI$ #LOOP ;07/10/05 YM ADD
  )

  ;// システム変数保管
  (setq #os (getvar "OSMODE"))   ;Oスナップ
  (setq #sm (getvar "SNAPMODE")) ;スナップ
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)

  (if (not (tblsearch "APPID" "G_WTR")) (regapp "G_WTR"))

  ;// シンクに設定されている水栓取付け点（Ｐ点=５）の情報を取得する
  (setq #pten5$$ nil)
  (if &snk-en
    (setq #pten5$$ (PKGetPTEN_NO &snk-en 5)) ; 戻り値(PTEN図形,G_PTEN)のﾘｽﾄのﾘｽﾄ
    (progn
      (setq #ret$ (KPGetPTEN 5)) ; 01/06/27 YM 関数化
      (setq #pten5$    (car  #ret$)) ; PTEN5図形ﾘｽﾄ
      (setq #xd_pten5$ (cadr #ret$)) ; "G_PTEN"ﾘｽﾄ
      (setq #i 0)
      (repeat (length #pten5$) ; ﾘｽﾄを合わせる
        (setq #pten5$$ (append #pten5$$ (list (list (nth #i #pten5$)(nth #i #xd_pten5$)))))
        (setq #i (1+ #i))
      )
    )
  );_if

  ;複合水栓から品番を取得する
  (setq #DB_NAME "複合水栓")
  (setq #LIST$$ (list (list "記号" (nth 19 CG_GLOBAL$)'STR)));水栓の種類
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$))
  (setq #qry$ (DBCheck #qry$ "『複合水栓』" "PKW_WorkTop"))
  (setq #hinban (nth 1 #qry$))       ; 品番名称
  (setq #LR     (nth 2 #qry$))       ; LR区分

  (setq #fig-qry$
    (CFGetDBSQLRec CG_DBSESSION "品番図形"
      (list
        (list "品番名称" #hinban  'STR)
        (list "LR区分"   #LR      'STR)
      )
    )
  )
  (setq #fig-qry$ (DBCheck #fig-qry$ "『品番図形』" (strcat "品番名称=" #hinban)))
  ;水栓図形ID
  (setq #dwg (nth 6 #fig-qry$));2008/06/28 OK!

  ;[水栓位置]を検索して配置位置の水栓穴属性を求める
  (setq #sui-qry$
    (CFGetDBSQLRec CG_DBSESSION "水栓位置"
      (list
        (list "シンク記号" (nth 17 CG_GLOBAL$) 'STR)
        (list "シンク勝手" (nth 11 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #sui-qry$ (DBCheck #sui-qry$ "『水栓位置』" (strcat "シンク=" (nth 17 CG_GLOBAL$))))

  (setq #zoku (nth 3 #sui-qry$))   ; 水栓1の配置位置属性

  ;2009/02/06 YM ADD-S 水栓2穴対応
  ;水栓穴２が選択されていてしかもﾏﾙﾁｼﾝｸなら主水栓の位置が変わる
  (if (and (= "B" (nth 18 CG_GLOBAL$))(wcmatch (nth 17 CG_GLOBAL$) "G*" ))
    (progn
      (setq #zoku (nth 4 #sui-qry$))   ; 水栓1の配置位置属性
    )
  );_if
  ;2009/02/06 YM ADD-E 水栓2穴対応

  (setq #k 0)
  (setq #zokuP$ '())
  (foreach #pten5$ #pten5$$
    (setq #xd_PTEN$ (cadr #pten5$))    ; 拡張ﾃﾞｰﾀ"G_PTEN"
    (setq #zokuP (nth 2 #xd_PTEN$))    ; 属性
    (if (and (= #zokuP #zoku)               ; 属性が同じなら水栓配置
             (= (member #zokuP #zokuP$) nil))
      (progn
        (setq #zokuP$ (append #zokuP$ (list #zokuP))) ; PTEN5図形名
        (setq #pten5 (car  #pten5$))   ; PTEN5図形名
        (setq #kei (nth 1 #xd_PTEN$))  ; 穴径
        (setq #o (cdr (assoc 10 (entget #pten5)))) ; 中心点座標
        ; 水栓ありで「水栓」なしの場合 01/01/15 YM ADD
        ;;;  (setq #ANA_layer "Z_00_00_00_01" ) ; 目に見える
        (setq #ANA_layer SKW_AUTO_SECTION) ; 目に見えない
;-- 2011/09/09 A.Satoh Del - S
;        (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"の円を作成する
;
;
;        ;// 水栓穴拡張データを設定
;        (CFSetXData #dum "G_WTR" (list #zokuP))
;        (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; 水栓穴図形名
;-- 2011/09/09 A.Satoh Del - E
        ;// 水栓金具の配置
        (if &snk-en
          (setq #ang (nth 2 (CFGetXData &snk-en "G_LSYM"))) ; 配置角度
          (setq #ang 0.0) ; ｼﾝｸが存在しないとき配置角度0固定
        );_if




        ;;; 図形が存在するか確認
        (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")));2008/06/28 OK!
          (progn
            (setq #msg (strcat "水栓図形 : ID=" #dwg " がありません"));2008/06/28 OK!
            (CMN_OutMsg #msg) ; 02/09/05 YM ADD
          )
        )

        ;// インサート
        (WebOutLog "水栓を挿入します(PKW_PosWTR_plan)")
        (command "_insert"
          (strcat CG_MSTDWGPATH #dwg) ; 品番図形.図形ID ;2008/06/28 OK!
          #o
          1
          1
          (rtd #ang)
        )
        (command "_explode" (entlast))
        (setq #ss_dum (ssget "P"))

        ;2008/09/01 YM ADD-S 正面図だけ抽出する
        (setq #ss_syomen (ssget "P" (list (cons 8 "Z_03_04_*"))));正面施工図の画層
        ;2008/09/01 YM ADD-E 正面図だけ抽出する


        (SKMkGroup #ss_dum)

        ;04/01/24 YM ADD-S (ssname #ss_dum 0)の図形が不正な場合の回避
        (setq #ii 0 #loop T)
        (while (and #loop (< #ii 10))
          (setq #dum_en (ssname #ss_dum #ii))
          (if (and (= 'ENAME (type #dum_en))(entget #dum_en))
            (setq #loop nil)
          );_if
          (setq #ii (1+ #ii))
        )
        ;04/01/24 YM ADD-E (ssname #ss_dum 0)の図形が不正な場合の回避
        
;;;        (setq #en (SKC_GetSymInGroup #dum_en));04/01/24 YM MOD
         (setq #en (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

        ;// 拡張データの付加
        (WebOutLog "拡張ﾃﾞｰﾀ G_LSYM を設定します(PKW_PosWTR_plan)")
        (CFSetXData #en "G_LSYM"
          (list
            (nth 6 #fig-qry$)          ;1 :本体図形ID  ; 品番図形.図形ＩＤ ;2008/06/28 OK!
            #o                         ;2 :挿入点
            0.0                        ;3 :回転角度
            &KCode                     ;4 :工種記号
            &SeriCode                  ;5 :SERIES記号
            (nth 0 #fig-qry$)          ;6 :品番名称
            "Z"                        ;7 :L/R 区分
            ""                         ;8 :扉図形ID
            ""                         ;9 :扉開き図形ID
            CG_SKK_INT_SUI             ;10:性格CODE ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
            2                          ;11:複合フラグ
            0                          ;12:レコード番号
            (fix (nth 2 #fig-qry$))    ;13:用途番号 ;2008/06/28 OK!
            0.0                        ;14:寸法H
            1                          ;15:断面指示の有無
            "A"                        ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
          )
        );_CFSetXData
      )
    );_if
  );_foreach

  ;2008/09/01 YM ADD 水栓正面壁だしの絵の高さを天板高さに応じて調整する
  ;天板高さ
  (setq #HH (atoi (substr (nth 31 CG_GLOBAL$) 2 3)));H850,H900,H800
  ;水栓配置高さ
  (setq #ZZ (nth 2 #o))
  (setq #SA (- #HH #ZZ))
  ;もし差がある場合に正面図だけ移動する
  (if (< 0.1 (abs #sa))
    (command "._MOVE" #ss_syomen "" "0,0,0" (strcat "@0,0," (rtos #SA)) ) ; 図形移動
  );_if

  ;// システム変数を元に戻す
  (setvar "OSMODE"   #os)
  (setvar "SNAPMODE" #sm)

  #WtrHoleEn$  ;// 水栓穴(G_WTR)底面図形を返す
);PKW_PosWTR_plan


;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_PosWTR_plan_2
;;; <処理概要>  : 水栓2を配置する(プラン検索)
;;; <戻り値>    :
;;;        LIST : 水栓穴(G_WTR)図形のリスト
;;; <作成>      : 1999-10-21
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKW_PosWTR_plan_2 (
  &KCode        ;(STR)工種記号
  &SeriCode     ;(STR)SERIES記号
  &snk-en       ;(ENAME)シンク基準図形 (Lipple のときは nil)
  &snk-cd       ;(STR)シンク記号
  &qry$$        ;水栓構成ﾚｺｰﾄﾞのﾘｽﾄ nilあり
  /
;-- 2011/09/09 A.Satoh Mod - S
;  #ANG #DUM #EN #FIG-QRY$ #FLG #HINBAN #K #KEI #MSG #O #OS #ANA_layer
  #ANG #EN #FIG-QRY$ #FLG #HINBAN #K #KEI #MSG #O #OS #ANA_layer
;-- 2011/09/09 A.Satoh Mod - E
  #PTEN5 #PTEN5$$ #SM #SS_DUM #WTRHOLEEN$ #XD_PTEN$ #ZOKU #ZOKUP #ZOKUP$
  #DWG #I #PTEN5$ #RET$ #XD_PTEN5$
  #DUM_EN #II #KIKI$ #LOOP ;07/10/05 YM ADD
  )

  ;// システム変数保管
  (setq #os (getvar "OSMODE"))   ;Oスナップ
  (setq #sm (getvar "SNAPMODE")) ;スナップ
  (setvar "OSMODE"   0)
  (setvar "SNAPMODE" 0)

  (if (not (tblsearch "APPID" "G_WTR")) (regapp "G_WTR"))

  ;// シンクに設定されている水栓取付け点（Ｐ点=５）の情報を取得する
  (setq #pten5$$ nil)
  (if &snk-en
    (setq #pten5$$ (PKGetPTEN_NO &snk-en 5)) ; 戻り値(PTEN図形,G_PTEN)のﾘｽﾄのﾘｽﾄ
    (progn
      (setq #ret$ (KPGetPTEN 5)) ; 01/06/27 YM 関数化
      (setq #pten5$    (car  #ret$)) ; PTEN5図形ﾘｽﾄ
      (setq #xd_pten5$ (cadr #ret$)) ; "G_PTEN"ﾘｽﾄ
      (setq #i 0)
      (repeat (length #pten5$) ; ﾘｽﾄを合わせる
        (setq #pten5$$ (append #pten5$$ (list (list (nth #i #pten5$)(nth #i #xd_pten5$)))))
        (setq #i (1+ #i))
      )
    )
  );_if

  ;複合水栓から品番を取得する
  (setq #DB_NAME "複合水栓")
  (setq #LIST$$ (list (list "記号" (nth 22 CG_GLOBAL$)'STR)));水栓2 "PLAN22"
  (setq #qry$ (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$))
  (setq #qry$ (DBCheck #qry$ "『複合水栓』" "PKW_WorkTop"))
  (setq #hinban (nth 1 #qry$))       ; 品番名称
  (setq #LR     (nth 2 #qry$))       ; LR区分

  (setq #fig-qry$
    (CFGetDBSQLRec CG_DBSESSION "品番図形"
      (list
        (list "品番名称" #hinban  'STR)
        (list "LR区分"   #LR      'STR)
      )
    )
  )
  (setq #fig-qry$ (DBCheck #fig-qry$ "『品番図形』" (strcat "品番名称=" #hinban)))
  ;水栓図形ID
  (setq #dwg (nth 6 #fig-qry$));2008/06/28 OK!

  ;[水栓位置]を検索して配置位置の水栓穴属性を求める
  (setq #sui-qry$
    (CFGetDBSQLRec CG_DBSESSION "水栓位置"
      (list
        (list "シンク記号" (nth 17 CG_GLOBAL$) 'STR)
        (list "シンク勝手" (nth 11 CG_GLOBAL$) 'STR)
      )
    )
  )
  (setq #sui-qry$ (DBCheck #sui-qry$ "『水栓位置』" (strcat "シンク=" (nth 17 CG_GLOBAL$))))

  (setq #zoku (nth 5 #sui-qry$))   ; 水栓2の配置位置属性

  (setq #k 0)
  (setq #zokuP$ '())
  (foreach #pten5$ #pten5$$
    (setq #xd_PTEN$ (cadr #pten5$))    ; 拡張ﾃﾞｰﾀ"G_PTEN"
    (setq #zokuP (nth 2 #xd_PTEN$))    ; 属性
    (if (and (= #zokuP #zoku)               ; 属性が同じなら水栓配置
             (= (member #zokuP #zokuP$) nil))
      (progn
        (setq #zokuP$ (append #zokuP$ (list #zokuP))) ; PTEN5図形名
        (setq #pten5 (car  #pten5$))   ; PTEN5図形名
        (setq #kei (nth 1 #xd_PTEN$))  ; 穴径
        (setq #o (cdr (assoc 10 (entget #pten5)))) ; 中心点座標
        ; 水栓ありで「水栓」なしの場合 01/01/15 YM ADD
        ;;;  (setq #ANA_layer "Z_00_00_00_01" ) ; 目に見える
        (setq #ANA_layer SKW_AUTO_SECTION) ; 目に見えない
;-- 2011/09/09 A.Satoh Del - S
;       (setq #dum (PK_MakeG_WTR #kei #o #ANA_layer)) ; "G_WTR"の円を作成する
;
;
;        ;// 水栓穴拡張データを設定
;        (CFSetXData #dum "G_WTR" (list #zokuP))
;        (setq #WtrHoleEn$ (append #WtrHoleEn$ (list #dum))) ; 水栓穴図形名
;-- 2011/09/09 A.Satoh Del - E
        ;// 水栓金具の配置
        (if &snk-en
          (setq #ang (nth 2 (CFGetXData &snk-en "G_LSYM"))) ; 配置角度
          (setq #ang 0.0) ; ｼﾝｸが存在しないとき配置角度0固定
        );_if




        ;;; 図形が存在するか確認
        (if (= nil (findfile (strcat CG_MSTDWGPATH #dwg ".dwg")));2008/06/28 OK!
          (progn
            (setq #msg (strcat "水栓図形 : ID=" #dwg " がありません"));2008/06/28 OK!
            (CMN_OutMsg #msg) ; 02/09/05 YM ADD
          )
        )

        ;// インサート
        (WebOutLog "水栓を挿入します(PKW_PosWTR_plan)")
        (command "_insert"
          (strcat CG_MSTDWGPATH #dwg) ; 品番図形.図形ID ;2008/06/28 OK!
          #o
          1
          1
          (rtd #ang)
        )
        (command "_explode" (entlast))
        (setq #ss_dum (ssget "P"))

        ;2008/09/01 YM ADD-S 正面図だけ抽出する
        (setq #ss_syomen (ssget "P" (list (cons 8 "Z_03_04_*"))));正面施工図の画層
        ;2008/09/01 YM ADD-E 正面図だけ抽出する


        (SKMkGroup #ss_dum)

        ;04/01/24 YM ADD-S (ssname #ss_dum 0)の図形が不正な場合の回避
        (setq #ii 0 #loop T)
        (while (and #loop (< #ii 10))
          (setq #dum_en (ssname #ss_dum #ii))
          (if (and (= 'ENAME (type #dum_en))(entget #dum_en))
            (setq #loop nil)
          );_if
          (setq #ii (1+ #ii))
        )
        ;04/01/24 YM ADD-E (ssname #ss_dum 0)の図形が不正な場合の回避
        
;;;        (setq #en (SKC_GetSymInGroup #dum_en));04/01/24 YM MOD
         (setq #en (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

        ;// 拡張データの付加
        (WebOutLog "拡張ﾃﾞｰﾀ G_LSYM を設定します(PKW_PosWTR_plan)")
        (CFSetXData #en "G_LSYM"
          (list
            (nth 6 #fig-qry$)          ;1 :本体図形ID  ; 品番図形.図形ＩＤ ;2008/06/28 OK!
            #o                         ;2 :挿入点
            0.0                        ;3 :回転角度
            &KCode                     ;4 :工種記号
            &SeriCode                  ;5 :SERIES記号
            (nth 0 #fig-qry$)          ;6 :品番名称
            "Z"                        ;7 :L/R 区分
            ""                         ;8 :扉図形ID
            ""                         ;9 :扉開き図形ID
            CG_SKK_INT_SUI             ;10:性格CODE ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
            2                          ;11:複合フラグ
            0                          ;12:レコード番号
            (fix (nth 2 #fig-qry$))    ;13:用途番号 ;2008/06/28 OK!
            0.0                        ;14:寸法H
            1                          ;15:断面指示の有無
            "A"                        ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
          )
        );_CFSetXData
      )
    );_if
  );_foreach

  ;2008/09/01 YM ADD 水栓正面壁だしの絵の高さを天板高さに応じて調整する
  ;天板高さ
  (setq #HH (atoi (substr (nth 31 CG_GLOBAL$) 2 3)));H850,H900,H800
  ;水栓配置高さ
  (setq #ZZ (nth 2 #o))
  (setq #SA (- #HH #ZZ))
  ;もし差がある場合に正面図だけ移動する
  (if (< 0.1 (abs #sa))
    (command "._MOVE" #ss_syomen "" "0,0,0" (strcat "@0,0," (rtos #SA)) ) ; 図形移動
  );_if

  ;// システム変数を元に戻す
  (setvar "OSMODE"   #os)
  (setvar "SNAPMODE" #sm)

  #WtrHoleEn$  ;// 水栓穴(G_WTR)底面図形を返す
);PKW_PosWTR_plan_2


;<HOM>*************************************************************************
; <関数名>    : PKW_MakeSKOutLine
; <処理概要>  : キッチンの外形領域を結ぶポリラインを返す
; <戻り値>    :
;       ENAME : キッチンの外形領域ポリライン
; <作成>      : 99-10-19
; <備考>      : 03/31 YM ｳｫｰﾙｷｬﾋﾞ600天井ﾌｨﾗｰ生成不具合修正
;               ﾚﾝｼﾞﾌｰﾄﾞを100mm下に移動する--->PMEN2も移動する--->ｱｯﾊﾟｰｷｬﾋﾞ外形領域が正しく求まらない--->修正
;*************************************************************************>MOH<
(defun PKW_MakeSKOutLine (
  &BaseSym$
  &step                ;(STR)ステップタイプフラグ (T or nil) ; 00/03/13 ADD step 段差
  /
  #210 #38 #38_MAX #ANG #DIST$ #EN #EN$ #H #H$ #I #LOOP #LST$ #MSG #P-EN #P2 #P3 #PT #PT$
  #R-DEPTH #R-SS #R-WIDTH #SPT #SYM #XD$ #ZU_ID
#xd_LSYM$	;- 2011/10/21 A.Satoh Add
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_MakeSKOutLine ////")
  (CFOutStateLog 1 1 " ")

  ;// ワークトップの外形領域(P面=2)を検索する
  (setq #38_MAX -99999) ; 高度の最大値を求める アッパー天井フィラー用 ; 00/03/31 YM ADD
  (foreach #sym &BaseSym$
    (setq #spt (cdr (assoc 10 (entget #sym))))
    (setq #h$ (cons (nth 5 (CFGetXData #sym "G_SYM")) #h$))                ; 00/03/13 ADD step 段差
    (setq #en$ (CFGetGroupEnt #sym)) ; 各ﾍﾞｰｽｷｬﾋﾞの同一ｸﾞﾙｰﾌﾟ
    (setq #i 0)
    ;// レンジフードは他のキャビと奥行きを合わせる
    (if (= CG_SKK_ONE_RNG (CFGetSymSKKCode #sym 1)) ; CG_SKK_ONE_RNG = 3
      (progn
        (setq #r-width (nth 3 (CFGetXData #sym "G_SYM"))) ; 幅
        (setq #r-depth (nth 4 (CFGetXData #sym "G_SYM"))) ; 奥行き
      )
    )

    (setq #loop T)
    (while (and #loop (< #i (length #en$)))
      (setq #en (nth #i #en$))
      (if (= 2 (car (CFGetXData #en "G_PMEN")))
        (progn
          (setq #210 (cdr (assoc 210 (entget #en)))) ; 押し出し方向 0,0,1
          (setq #38  (cdr (assoc 38  (entget #en)))) ; PLINE 高度
          (if (<= #38_MAX #38) ; 高度の最大値 #38_MAX
            (setq #38_MAX #38)
          );_if
          (if (and (= (fix (car #210)) 0) (= (fix (cadr #210)) 0) (= (fix (caddr #210)) 1))
            (progn
              (setq #lst$ (cons (list #sym #en) #lst$)) ; ﾍﾞｰｽｷｬﾋﾞと押し出し方向 0,0,1のﾎﾟﾘﾗｲﾝのリスト
              (setq #loop nil) ; １つ見つけたらループを抜ける
            )
          )
        )
      )
      (setq #i (1+ #i))
    );_(while (and #loop (< #i (length #en$)))

    (if #loop            ; 00/03/11 YM チェック強化
      (progn
;-- 2011/10/21 A.Satoh Mod - S
;;;;;        (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; 図形ID
;;;;;        (setq #msg (strcat "図形ID=" #zu_id "に 外形領域 PMEN2 がありません。\nPKW_MakeSKOutLine"))
;;;;;        (CMN_OutMsg #msg) ; 02/09/05 YM ADD
				(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
				(if (/= (nth 9 #xd_LSYM$) 110)
					(progn
						(setq #zu_id (nth 0 #xd_LSYM$))	; 図形ID
		        (setq #msg (strcat "図形ID=" #zu_id "に 外形領域 PMEN2 がありません。\nPKW_MakeSKOutLine"))
    		    (CMN_OutMsg #msg)
					)
				)
;-- 2011/10/21 A.Satoh Mod - S
      )
    );_if

  );_(foreach #sym &BaseSym$

  ;// 求めた外形領域のクローンをREGIONとして作成する
  ;// 外形領域を４点のREGIONに変換する
  (setq #r-ss (ssadd))
  (foreach #lst #lst$
    (setq #sym  (car #lst))  ; ﾍﾞｰｽｷｬﾋﾞ
    (setq #p-en (cadr #lst)) ; PMEN=2,押し出し方向 0,0,1のﾎﾟﾘﾗｲﾝ
    ;// コーナーキャビはそのままの外形線
    (cond
      ((= CG_SKK_THR_CNR (CFGetSymSKKCode #sym 3)) ; CG_SKK_THR_CNR = 5 コーナーキャビ
        (entmake (cdr (entget #p-en)))
        (command "_region" (entlast) "")
        (ssadd (entlast) #r-ss)
      )
      (T ; コーナーキャビ以外
        (setq #38 (cdr (assoc 38 (entget #p-en)))) ; #38 高度
        (setq #spt (cdr (assoc 10 (entget #sym)))) ; 親図形挿入基点
        (setq #xd$ (CFGetXData #sym "G_LSYM"))
        (setq #h   (nth 5 (CFGetXData #sym "G_SYM")))

        (if (or (= &step nil)
                (and (= &step T) (> #h 728))  ;段差でもWTを貼る高いキャビの場合
;;;               (and (= &step T) (< #h 360))) ;ﾌﾟﾙｵｰﾌﾟﾝ食洗収納ｷｬﾋﾞの場合 ; 03/01/16 YM MOD
                (and (= &step T) (< #h 375))) ;ﾌﾟﾙｵｰﾌﾟﾝ食洗収納ｷｬﾋﾞの場合   ; 03/01/16 YM MOD
          (progn
            (setq #ang (nth 2 #xd$)) ; 回転角度
            (if (= CG_SKK_ONE_RNG (CFGetSeikakuToSKKCode (nth 9 #xd$) 1)) ; CG_SKK_ONE_RNG=3 ﾚﾝｼﾞﾌｰﾄﾞ
              (progn
                (setq #p2 (polar #spt #ang #r-width))
                (setq #p3 (polar #spt (- #ang (dtr 90)) #r-depth))
                (setq #pt (polar #p3 #ang #r-width))
              )
              (progn
                (setq #pt$ (GetLWPolyLinePt #p-en))
                (setq #dist$ nil)
                (foreach #pt #pt$
                  (setq #dist$ (cons (list #pt (distance #spt #pt)) #dist$))
                )
                (setq #dist$ (CFListSort #dist$ 1))

                ;// 一番遠い点
                (setq #pt (car (last #dist$))) ; リストの最後の要素を返します。
                (setq #p2 (CFGetDropPt #spt (list #pt (polar #pt (- #ang (dtr 90)) 10))))
                (setq #p3 (CFGetDropPt #spt (list #pt (polar #pt #ang 10))))
              )
            )

    ;;;    MakeLwPolyLine
    ;;;    &pt$  ;(LIST)構成座標点ﾘｽﾄ
    ;;;    &cls  ;(INT) 0=開く/1=閉じる
    ;;;    &elv  ;(REAL)高度
            (MakeLwPolyLine (list #spt #p2 #pt #p3) 1 0)

            (if (= (CFGetSeikakuToSKKCode (nth 9 (CFGetXData (car &BaseSym$) "G_LSYM")) 2) CG_SKK_TWO_UPP) ; アッパーなら
              (setq #38 #38_MAX) ; 他のｷｬﾋﾞと高度を合わせる
            );_if
            (entmod (subst (cons 38 #38) (assoc 38 (entget (entlast))) (entget (entlast))))  ; 高度を#38に変更
            (command "_region" (entlast) "")
            (ssadd (entlast) #r-ss)
          );段差でもWTを貼る高いキャビの場合
        );_if
      );_(T
    );_(cond

  );_(foreach #lst #lst$

  ;// 作成したREGIONをUNIONで連結したREGIONとする
  (command "_union" #r-ss "")
  ;// REGIONを分解し、分解した線分をポリライン化する
  (command "_explode" (entlast))
  (setq #r-ss (ssget "P"))
  (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了
  (entlast);// 外形ポリラインを返す
);PKW_MakeSKOutLine

;<HOM>*************************************************************************
; <関数名>    : SKW_ReGetBasePt
; <処理概要>  : ステップタイプの場合、基準点を再設定する
; <戻り値>    :
; <作成>      : 1999-12-20 川本成二
; <備考>      :
;*************************************************************************>MOH<
(defun SKW_ReGetBasePt (
  &basePt
  &OutPline
  /
  #dist #minDist
  #pt #pt$
  #retPt
  )
  (setq #minDist 100000)
  (setq #pt$ (GetLWPolyLinePt &outPline))
  (foreach #pt #pt$
    (setq #dist (distance &basePt #pt))
    (if (> #minDist #dist)
      (progn
        (setq #minDist #dist)
        (setq #retPt #pt)
      )
    )
  )
  (list (car #retPt) (cadr #retPt) 0.0)
)
;SKW_ReGetBasePt

;<HOM>*************************************************************************
; <関数名>    : SKW_ChkStepType
; <処理概要>  : ステップタイプか調べる
; <戻り値>    :
; <作成>      : 1999-12-20 川本成二
; <備考>      :
;*************************************************************************>MOH<
(defun SKW_ChkStepType (
    &BaseSym$       ;(LIST)ベースキャビの基準シンボルリスト
    /
    #sym
    #step
    #h
  )
  (if (= CG_SKK_THR_GAS (CFGetSymSKKCode (car &BaseSym$) 3)) ; CG_SKK_THR_GAS=3ｶﾞｽｷｬﾋﾞ
    (setq &BaseSym$ (reverse &BaseSym$))
  )
  (setq #h (fix (nth 5 (CFGetXData (car &BaseSym$) "G_SYM"))))
  (foreach #sym (cdr &BaseSym$)
    (if (/= CG_SKK_THR_GAS (CFGetSymSKKCode #sym 3))
      (progn
        (if (/= #h (fix (nth 5 (CFGetXData #sym "G_SYM"))))
          (setq #step T)
        )
      )
    )
  )
  #step
);SKW_ChkStepType

;;;<HOM>*************************************************************************
;;; <関数名>    : KPMovePmen2_Z_0
;;; <処理概要>  : PMEN2の高度をZ=0にする
;;; <戻り値>    : なし
;;; <作成>      : 01/07/30 YM
;;; <備考>      : MICAD CENAﾋﾞｰﾌﾘｰﾀｲﾌﾟWT自動生成で隣接キャビからWT外形regionを求めるのに必要
;;;               PMEN2があることを前提
;;;*************************************************************************>MOH<
(defun KPMovePmen2_Z_0 (
  &sym    ;ｼﾝﾎﾞﾙ図形
  /
  #RZ #ePMEN2$
  )
  (setq #ePMEN2$ (PKGetPMEN_NO_ALL &sym 2)) ; pmen2(外形領域)
  (foreach #ePMEN2 #ePMEN2$
    (setq #rZ (cdr (assoc 38 (entget #ePMEN2)))) ; ｼﾝﾎﾞﾙZ座標
    (if (< (abs #rZ) 0.1)
      nil
      (progn
        (if (< 0 #rZ)
          (command "_move" #ePMEN2 "" '(0 0 0) (strcat "@0,0," (rtos (- #rZ)))) ; 正
          (command "_move" #ePMEN2 "" '(0 0 0) (strcat "@0,0," (rtos #rZ)))     ; 負
        );_if
      )
    );_if
  )
  (princ)
);KPMovePmen2_Z_0

;;; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;; 以下PMEN2を使用するように変更 00/05/16 YM PMEN2取得は非常に遅い
;;; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_GetLinkBaseCab
;;; <処理概要>  : 指定図形の属するキャビに隣接するﾍﾞｰｽｷｬﾋﾞを取得する
;;; <戻り値>    : ﾍﾞｰｽｷｬﾋﾞ図形(G_LSYM)のリスト
;;; <作成>      : 1999-10-19 00/05/17 YM 奥行き違い対策 05/18 YM 高速化
;;; <備考>      : 再帰により 隣接する基準シンボルを CG_LinkSym に格納する
;;;*************************************************************************>MOH<
(defun PKW_GetLinkBaseCab (
  &sym       ;(ENAME)辺ー図ｷｬﾋﾞｼﾝﾎﾞﾙ図形
  /
  #ELM #ENSS$ #I #PMEN2 #PT$ #PT$$ #PT0$ #SKK$ #SYM
#MSG ; 02/09/04 YM ADD
;-- 2011/09/09 A.Satoh Add - S
#ss #en
;-- 2011/09/09 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_GetLinkBaseCab ////")
  (CFOutStateLog 1 1 " ")

  (setq CG_LinkSym nil)
  (setq #pt$$ nil)
  (setq #pmen2 (PKGetPMEN_NO &sym 2))   ; pmen2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 &sym))   ; PMEN2 を作成
  );_if
  (setq #pt0$ (GetLWPolyLinePt #pmen2)) ; pmen2外形点列
;-- 2011/09/09 A.Satoh Mod - S
;  (setq #enSS$ (ssget "X" '((-3 ("G_PMEN"))))) ; 図面上PMEN
;
;  (setq #i 0)
;  (repeat (sslength #enSS$)
;    (setq #elm (ssname #enSS$ #i))             ; PMEN図形
;    (setq #sym (CFSearchGroupSym #elm))        ; ｼﾝﾎﾞﾙ図形
;    (if (= #sym nil)
;      (progn
;        (setq #msg "Ｐ面にシンボル図形がありません。図面のアイテムが不正です。\n PKW_GetLinkBaseCab")
;        (CMN_OutMsg #msg) ; 02/09/05 YM ADD
;      )
;    )
;
;    (setq #skk$ (CFGetSymSKKCode #sym nil))       ; 性格ｺｰﾄﾞをみる
;
;;;    (if (or (and (= (car #skk$) CG_SKK_ONE_CAB)
;;;                 (= (cadr #skk$) CG_SKK_TWO_BAS)) ; ﾍﾞｰｽｷｬﾋﾞ
;;;        )
;
;    ; 01/07/30 YM MOD "118"ｷｬﾋﾞは除く
;    (if (and (= (car #skk$) CG_SKK_ONE_CAB) ; 01/04/04 YM
;             (= (cadr #skk$) CG_SKK_TWO_BAS); ﾍﾞｰｽｷｬﾋﾞ
;             (/= (caddr #skk$) 8))
;
;      (if (= (car (CFGetXData #elm "G_PMEN")) 2)     ; PMEN2
;        (progn
;          (setq #pt$ (GetLWPolyLinePt #elm))
;          (setq #pt$$ (cons (list #sym #pt$) #pt$$)) ; (sym,外形点列)
;        )
;      );_if
;    );_if
;    (setq #i (1+ #i))
;  );_(repeat (sslength #ss)
  (setq #enSS$ (ssget "X" '((-3 ("G_PMEN"))))) ; 図面上PMEN
  (setq #i 0)
  (setq #ss (ssadd))
  (repeat (sslength #enSS$)
    (setq #en (ssname #enSS$ #i))
    (if (= (car (CFGetXData #en "G_PMEN")) 2)
      (setq #ss (ssadd #en #ss))
    )
    (setq #i (1+ #i))
  )

  (setq #i 0)
  (repeat (sslength #ss)
    (setq #elm (ssname #ss #i))             ; PMEN図形
    (setq #sym (CFSearchGroupSym #elm))        ; ｼﾝﾎﾞﾙ図形
    (if (= #sym nil)
      (progn
        (setq #msg "Ｐ面にシンボル図形がありません。図面のアイテムが不正です。\n PKW_GetLinkBaseCab")
        (CMN_OutMsg #msg)
      )
    )

    (setq #skk$ (CFGetSymSKKCode #sym nil))       ; 性格ｺｰﾄﾞをみる

    ; "118"ｷｬﾋﾞは除く
    (if (and (= (car #skk$) CG_SKK_ONE_CAB)
             (= (cadr #skk$) CG_SKK_TWO_BAS); ﾍﾞｰｽｷｬﾋﾞ
             (/= (caddr #skk$) 8))
      (progn
        (setq #pt$ (GetLWPolyLinePt #elm))
        (setq #pt$$ (cons (list #sym #pt$) #pt$$)) ; (sym,外形点列)
      )
    );_if
    (setq #i (1+ #i))
  )
;-- 2011/09/09 A.Satoh Mod - E

  (PKW_SLinkBaseSym #pt$$ #pt0$);// 再帰により隣接するベースキャビを検索する
  CG_LinkSym                    ;// 隣接するキャビの基準シンボル図形を返す
);PKW_GetLinkBaseCab

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_SLinkBaseSym
;;; <処理概要>  : 指定図形の属するベースキャビに隣接するベースキャビネットを取得する
;;; <戻り値>    : なし
;;; <作成>      : 1999-04-13 00/05/16 YM 修正 PMEN2を見る
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKW_SLinkBaseSym (
  &pt$$     ;(ｼﾝﾎﾞﾙ,ｷｬﾋﾞ外形点列)のﾘｽﾄ
  &pt0$     ;ｷｬﾋﾞ外形点列
  /
  #ENS2 #I #PT$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_SLinkBaseSym ////")
  (CFOutStateLog 1 1 " ")

  (setq #i 0)
  (repeat (length &pt$$)
    (setq #enS2 (nth 0 (nth #i &pt$$))) ; ｼﾝﾎﾞﾙ図形
    (setq #pt$  (nth 1 (nth #i &pt$$)))
;;; 隣接するかどうかの判断をゆるめる 00/05/10 YM
;;;    (if (or (SKW_IsExistPRectCross    (list #p1 #p2 #p3 #p4)     (list #p5 #p6 #p7 #p8))  ; 従来判定
;;;           (SKW_IsExistPRectCross2CP (list #p1 #p2 #p3 #p4 #p1) (list #p5 #p6 #p7 #p8))  ; 追加判定00/05/10 YM
;;;           (SKW_IsExistPRectCross2CP (list #p5 #p6 #p7 #p8 #p5) (list #p1 #p2 #p3 #p4))) ; 追加判定00/05/10 YM

    (if (SKW_IsExistPRectCross &pt0$ #pt$)  ; 従来判定 点列ﾘｽﾄに同じ点があるかどうか
      (progn
        (if (= nil (member #enS2 CG_LinkSym))
          (progn
            (setq CG_LinkSym (cons #enS2 CG_LinkSym)) ; CG_LinkSym になかったら追加していく
            (PKW_SLinkBaseSym &pt$$ #pt$)
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
)
;PKW_SLinkBaseSym

;;; 同一ﾒﾝﾊﾞｰの図形個数を表示する
(defun C:kosu (/ #ss)
  (setq #ss (CFGetSameGroupSS (car(entsel "\n 図形を指示: "))))
  (princ "\n同一ﾒﾝﾊﾞｰの図形個数")(terpri)
  (sslength #ss)
)

;///////////////////////////////////////////////
(defun C:www ( / )
  (C:KPMakeFreeWT)
)

;;;<HOM>*************************************************************************
;;; <関数名>    : C:KPMakeFreeWT
;;; <処理概要>  : 自由な形状のﾜｰｸﾄｯﾌﾟを作成するｺﾏﾝﾄﾞ
;;; <戻り値>    : WT SOLID図形名
;;; <作成>      : 01/04/13 YM
;;; <備考>      : KPCAD
;;;*************************************************************************>MOH<
(defun C:KPMakeFreeWT (
  /
  #BG_PL1 #BG_PL2 #ED #FG_PL1 #FG_PL2 #MSG1 #MSG2 #MSG3 #OS #OT #SM #WT_PL
  )
;;; ｼｽﾃﾑ変数設定
  (StartUndoErr);// コマンドの初期化
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setq #ed (getvar "EDGEMODE" ))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "EDGEMODE"  0)

  (setq #msg1 "\nワークトップの外形ポリラインを選択: ")
  (setq #msg2 "\nバックガードの外形ポリラインを選択: ")
  (setq #msg3 "\n前垂れの外形ポリラインを選択: ")

    ;///////////////////////////////////////////////////////
    ; 閉じたﾎﾟﾘﾗｲﾝを選択させる
    ;///////////////////////////////////////////////////////
    (defun ##GetPLINE (
      &msg
      /
      #EG$ #LOOP #MSG #PLINE
      )
      ;// 外形領域の指示
      (setq #loop T)
      (while #loop
        (setq #PLINE (car (entsel &msg)))
        (if #PLINE
          (if (and (setq #eg$ (entget #PLINE)) ; 何か選ばれた
                   (= (cdr (assoc 0 #eg$)) "LWPOLYLINE")
                   (= (cdr (assoc 70 #eg$)) 1))
            (progn
              (setq #loop nil) ; 条件満たす
              (GroupInSolidChgCol2 #PLINE CG_InfoSymCol) ; 色を変える
            )
            (CFAlertMsg "閉じたポリラインではありません。")
          );_if
          (progn
            (setq #loop nil)
            (princ "\nポリラインは選択されませんでした。")
          )
        );_if
      );while
      #PLINE
    );##GetPLINE
    ;///////////////////////////////////////////////////////

  ; 各外形領域の選択(選択しやすいように一部画層をﾌﾘｰｽﾞ)
  ; 画層"2","3"ﾌﾘｰｽﾞ
  (command "_layer" "T" "1" "") ; 画層ﾌﾘｰｽﾞ解除
  (command "_layer" "F" "2" "") ; 画層ﾌﾘｰｽﾞ
  (command "_layer" "F" "3" "") ; 画層ﾌﾘｰｽﾞ
  (setq #WT_PL  (##GetPLINE #msg1))
  (if (= nil #WT_PL)
    (progn
      (CFAlertMsg "ワークトップを生成するフロアキャビネットがありません。")
      (quit)
    )
  );_if

  ; 画層"1","3"ﾌﾘｰｽﾞ
  (command "_layer" "F" "1" "") ; 画層ﾌﾘｰｽﾞ
  (command "_layer" "T" "2" "") ; 画層ﾌﾘｰｽﾞ解除
  (command "_layer" "F" "3" "") ; 画層ﾌﾘｰｽﾞ
  (setq #BG_PL1 (##GetPLINE #msg2))
  (setq #BG_PL2 (##GetPLINE #msg2))
  ; 画層"1","2"ﾌﾘｰｽﾞ
  (command "_layer" "F" "1" "") ; 画層ﾌﾘｰｽﾞ
  (command "_layer" "F" "2" "") ; 画層ﾌﾘｰｽﾞ
  (command "_layer" "T" "3" "") ; 画層ﾌﾘｰｽﾞ解除
  (setq #FG_PL1 (##GetPLINE #msg3))
  (setq #FG_PL2 (##GetPLINE #msg3))
  (command "_layer" "T" "1" "") ; 画層ﾌﾘｰｽﾞ解除
  (command "_layer" "T" "2" "") ; 画層ﾌﾘｰｽﾞ解除

  ; SOLIDの作成
  (FreeWTsub #WT_PL (list #BG_PL1 #BG_PL2)(list #FG_PL1 #FG_PL2))

  ; ｼｽﾃﾑ変数設定
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)
  (setvar "EDGEMODE"  #ed)
  (setq *error* nil)
  (princ "\nワークトップを生成しました。")
);C:KPMakeFreeWT

;;;<HOM>*************************************************************************
;;; <関数名>    : FreeWTsub
;;; <処理概要>  : 自由な形状のﾜｰｸﾄｯﾌﾟを作成
;;; <戻り値>    : WT SOLID図形名
;;; <作成>      : 01/04/13 YM
;;; <備考>      : KPCAD
;;;*************************************************************************>MOH<
(defun FreeWTsub (
  &WT_LINE  ; WT外形ﾎﾟﾘﾗｲﾝ
  &BG_LINE$ ; BG外形ﾎﾟﾘﾗｲﾝﾘｽﾄ
  &FG_LINE$ ; FG外形ﾎﾟﾘﾗｲﾝﾘｽﾄ
  /
  #BG0 #BG0$ #BG01 #BG02 #BG1 #BG2 #BG_H #BG_REGION #BG_SEP
  #BG_SOLID #BG_SOLID$ #BG_SOLID1 #BG_SOLID2 #ED
  #FG0 #FG0$ #FG01 #FG02 #FG1 #FG2 #FG_H #FG_REGION
  #FG_S #FG_SOLID #FG_SOLID$ #FG_SOLID1 #FG_SOLID2 #SETXD$
  #OS #OT #SM #SS #WT #WT0 #WT0$ #WTINFO #WT_H #WT_REGION #WT_SOLID #WT_T #ZaiCode
  )
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (defun ##NiltoStr ( &dum / )
      (if (= &dum nil)
        (setq &dum "")
      )
      &dum
    )
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ; WT情報の取得
  (setq #WTInfo (KPWTINFODlg_FreeWT)) ; ダイアログ確認表示
  (if (= #WTInfo nil)
    (*error*) ; cancelの場合
    (progn
      (setq #WT_H   (nth 0 #WTInfo)) ; WT高さ *
      (setq #WT_T   (nth 1 #WTInfo)) ; WT厚み *
      (setq #BG_H   (nth 2 #WTInfo)) ; BG高さ *
      (setq #FG_H   (nth 3 #WTInfo)) ; FG高さ *
      (setq #BG_Sep (nth 4 #WTInfo)) ; ﾊﾞｯｸｶﾞｰﾄﾞ分離
    )
  );_if

  ;// 材質記号の選択(ﾀﾞｲｱﾛｸﾞの表示)
  (setq #ZaiCode (PKW_ZaiDlg nil)) ; #ZAI0

; SOLIDを作成する
  (setq #WT  &WT_LINE) ; WT底面
  (setq #BG1 (car  &BG_LINE$)) ; BG底面1
  (setq #BG2 (cadr &BG_LINE$)) ; BG底面2
  (setq #FG1 (car  &FG_LINE$)) ; FG底面1
  (setq #FG2 (cadr &FG_LINE$)) ; FG底面2
;;; WT押し出し処理+移動
  (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #WT)) (entget #WT)))
  (setq #WT0 (entlast)) ; 残す WT底面
  (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT)) (entget #WT))) ; WT専用の画層
  (setq #WT0$ (append #WT0$ (list #WT0)))
  (setq #WT_region (Make_Region2 #WT))
  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
;;; BG1,BG2 押し出し処理+移動
  (foreach #BG (list #BG1 #BG2)
    (if #BG
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG)) (entget #BG)))
        (setq #BG0 (entlast)) ; 残す BG底面
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG)) (entget #BG))) ; WT専用の画層
        (setq #BG_region (Make_Region2 #BG))
        (setq #BG_SOLID (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
      )
      (setq #BG0 nil #BG_SOLID nil)
    );_if
    (setq #BG_SOLID$ (append #BG_SOLID$ (list #BG_SOLID)))
    (setq #BG0$ (append #BG0$ (list #BG0)))
  )
;;; FG1,FG2 押し出し処理+移動
  (foreach #FG (list #FG1 #FG2)
    (if #FG
      (progn
        (entmake (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG)) (entget #FG)))
        (setq #FG0 (entlast)) ; 残す
        (entmod  (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG)) (entget #FG))) ; WT専用の画層
        (setq #FG_region (Make_Region2 #FG))
        (setq #FG_SOLID (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
      )
      (setq #FG0 nil #FG_SOLID nil)
    );_if
    (setq #FG_SOLID$ (append #FG_SOLID$ (list #FG_SOLID)))
    (setq #FG0$ (append #FG0$ (list #FG0)))
  )

  (setq #WT0  (##NiltoStr #WT0))
  (setq #BG01 (##NiltoStr (car  #BG0$)))
  (setq #BG02 (##NiltoStr (cadr #BG0$)))
  (setq #FG01 (##NiltoStr (car  #FG0$)))
  (setq #FG02 (##NiltoStr (cadr #FG0$)))

  (setq #WT_SOLID  (##NiltoStr #WT_SOLID))
  (setq #BG_SOLID1 (##NiltoStr (car  #BG_SOLID$)))
  (setq #BG_SOLID2 (##NiltoStr (cadr #BG_SOLID$)))
  (setq #FG_SOLID1 (##NiltoStr (car  #FG_SOLID$)))
  (setq #FG_SOLID2 (##NiltoStr (cadr #FG_SOLID$)))

  (setq #ss (ssadd))
  (if (/= #WT_SOLID  "")(ssadd #WT_SOLID  #ss))
  (if (/= #FG_SOLID1 "")(ssadd #FG_SOLID1 #ss))
  (if (/= #FG_SOLID2 "")(ssadd #FG_SOLID2 #ss))

  (if (= #BG_Sep "Y")
    (progn ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
      (command "_union" #ss "") ; 交わらない領域でもＯＫ！
    )
    (progn ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型以外
      (if (/= #BG_SOLID1 "")(ssadd #BG_SOLID1 #ss))
      (if (/= #BG_SOLID2 "")(ssadd #BG_SOLID2 #ss))
      (command "_union" #ss "") ; 交わらない領域でもＯＫ！
    )
  );_if

;;; 拡張ﾃﾞｰﾀ "G_WRKT" のｾｯﾄ

;;; 新G_WRKT の雛形 現段階で入力可能なもののみ
  (setq #SetXd$                ; 未設定項目は-999 or "-999"
    (list "K"                  ;1. 工種記号
          CG_SeriesCode        ;2. SERIES記号
          #ZaiCode             ;3. 材質記号
          0                    ;4. 形状タイプ１          0,1,2(I,L,U) この時点で未決定
          "F"                  ;5. 形状タイプ２          F,D
          0                    ;6. 未使用
          ""                   ;7. 未使用
          ""                   ;8. カットタイプ番号      0:なし,1:VPK,2:X,3:H 左右
          #WT_H                ;9..下端取付け高さ        827
          "旧WT奥行き"         ;10.未使用
          #WT_T                ;11.カウンター厚さ        23
          1                    ;12.未使用
          #BG_H                ;13.バックガードの高さ    50
          20                   ;14.バックガード厚み      20
          1                    ;15.未使用
          #FG_H                ;16.前垂れ高さ            40
          20                   ;17.前垂れ厚さ            20
          0                    ;18.前垂れシフト量         7
          0 "" "" ""           ;19.ｼﾝｸ穴加工
          0 "" "" "" "" "" "" "" ;23.水栓穴データ数  水栓穴図形ハンドル1～5
          "R"                  ;31.ＬＲ勝手フラグ
          0.0                  ;32.未使用
          ""                   ;33.WT左上点
          ""                   ;34.未使用
          ""                   ;35.未使用
          "旧ｶｯﾄ相手ﾊﾝﾄﾞﾙ"     ;36.未使用
          ""                   ;37.カット左
          ""                   ;38.カット右
          ""                   ;[39]WT底面図形ﾊﾝﾄﾞﾙ
          0.0                  ;[40]未使用
          0.0                  ;[41]未使用
          0.0                  ;[42]未使用
          0                    ;[43]間口1 1枚目WT
          0                    ;[44]間口2 2枚目WT
          0                    ;[45]間口3 3枚目WT
          ""                   ;[46]未使用
          ""                   ;[47]未使用
          ""                   ;[48]カット相手WTﾊﾝﾄﾞﾙ左
          ""                   ;[49]カット相手WTﾊﾝﾄﾞﾙ右
          ""                   ;[50]BG底面図形ﾊﾝﾄﾞﾙ1
          ""                   ;[51]BG底面図形ﾊﾝﾄﾞﾙ2
          ""                   ;[52]FG底面図形ﾊﾝﾄﾞﾙ
          ""                   ;[53]素材ID
          0.0                  ;[54]間口伸縮量1 ｼﾝｸ側 (旧"G_SIDE"ｶｳﾝﾀｰ伸縮量) 品番確定に必要
          0.0                  ;[55]間口伸縮量2 ｺﾝﾛ側 (旧"G_SIDE"ｶｳﾝﾀｰ伸縮量) 品番確定に必要
          '(0.0 0.0)           ;[56]現在のWTの幅 (旧"G_SIDE"ｶｳﾝﾀｰ押し出し) 品番確定に必要 WT拡張前、ｶｯﾄ前のｺｰﾅｰ基点から角まで
          0.0                  ;[57]現在のWTの伸縮量
          '(0.0 0.0)           ;[58]現在のWTの奥行き
          ""                   ;[59]上面溝加工の有無    "A" 上面溝加工なし or "B" 上面溝加工あり
    )
  )

  (if (= nil (tblsearch "APPID" "G_WRKT")) (regapp "G_WRKT"))
  (CFSetXData #WT_SOLID "G_WRKT" #SetXd$)

;;; 拡張ﾃﾞｰﾀ G_BKGDのｾｯﾄ
;;;  (if (equal #BG_Sep 1 0.1)
;;;    (progn ; ﾊﾞｯｸｶﾞｰﾄﾞ分離型
;;;     (setq #BG_ALL_LEN 0)
;;;     (if (and #BG_SOLID1 (/= #BG_SOLID1 ""))
;;;       (setq #BG_ALL_LEN
;;;         (PKSetBGXData
;;;           (list #BG_SOLID1 #BG_SOLID2)
;;;           #cutL #cutR #ZaiCode
;;;           (list #BG01 #BG02)
;;;           #WT_SOLID nil
;;;         )
;;;       )
;;;     )
;;;      (setq #BG_LEN (+ #BG_LEN #BG_ALL_LEN))
;;;    )
;;;    (setq #BG_LEN 0)
;;;  );_if

  ;// 画層のフリーズ 底面画層
  (command "_layer" "F" SKW_AUTO_SECTION "")
  #WT_SOLID
);FreeWTsub

;<HOM>*************************************************************************
; <関数名>    : KPWTINFODlg_FreeWT
; <処理概要>  : WT情報ダイアログ
;               WT素材検索でレコードがとれなかったときに表示する
; <作成>      : 2000.3.29  YM
;*************************************************************************>MOH<
(defun KPWTINFODlg_FreeWT (
  /
  #WTInfo #dcl_id ##GetDlgItem
  )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( /
            #WT_T #BG_H #FG_H #WTInfo
            #BG_SEP #WT_H)

            (cond
              ((##Check "WT_H" (get_tile "WT_H") "ﾜｰｸﾄｯﾌﾟ高さ")   nil)
              ((##Check "WT_T" (get_tile "WT_T") "ﾜｰｸﾄｯﾌﾟ厚み")   nil)
              ((##Check "BG_H" (get_tile "BG_H") "ﾊﾞｯｸｶﾞｰﾄﾞ高さ") nil)
              ((##Check "FG_H" (get_tile "FG_H") "前垂れ高さ")    nil)
              (t ; ｴﾗｰがない場合
                  (setq #WT_H (atoi (get_tile "WT_H"))) ; WTの高さ
                  (setq #WT_T (atoi (get_tile "WT_T"))) ; WTの厚み
                  (setq #BG_H (atoi (get_tile "BG_H"))) ; BGの高さ
                  (setq #FG_H (atoi (get_tile "FG_H"))) ; FGの高さ
                  (if (= (get_tile "BG_SEP_YES") "1") ; ﾊﾞｯｸｶﾞｰﾄﾞ分離
                    (setq #BG_Sep "Y" )
                    (setq #BG_Sep "N" )
                  );_if
                  (setq #WTInfo (list #WT_H #WT_T #BG_H #FG_H #BG_Sep))
                (done_dialog)
              )
            );_cond
            #WTInfo
          )
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Check (&sKEY &sVAL &sNAME / )
            (if (= nil (and (numberp (read &sVAL)) (< 0 (read &sVAL))))
              (progn
                (alert (strcat &sNAME "欄に" "\n 数値を入力してください (1～9 の半角数字)"))
                (mode_tile &sKEY 2)
                (eval 'T) ; ｴﾗｰあり
              );end of progn
            ); end of if
          ); end of ##Check
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "WTINFODlg_FreeWT" #dcl_id)) (exit))

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #WTInfo (##GetDlgItem))")
  (action_tile "cancel" "(setq #WTInfo nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  #WTInfo
);KPWTINFODlg_FreeWT



;<HOM>*************************************************************************
; <関数名>    : subKPRendWT
; <処理概要>  : ワークトップの端をＲｴﾝﾄﾞにする(woodone対応)
; <戻り値>    : なし
; <作成>      : 2008/09/27 YM ADD
; <備考>      : 底面をFILLET->extrude BG一体型を想定
; <Ver.UP>      
;               前垂れはRｴﾝﾄﾞに沿って作成
;*************************************************************************>MOH<
(defun subKPRendWT (
  &WT ;天板図形 D1050 P型
  /
  #ARC1 #ARC2 #BASEPT #BG #BG_H #BG_REGION #BG_SOLID1 #BG_SOLID2 #BG_T #BG_TEI1 #BG_TEI2
  #CUTTYPE #DELOBJ #DEP #DIST$ #FG0 #FG_H #FG_REGION #FG_S #FG_SOLID #FG_T #FG_TEI1 #FG_TEI2
  #ITYPE #LAST #LINE$ #P1 #P2 #P3 #P4 #P5 #RR #SS #SS_DUM #WTL #WTR #WT_H #WT_PT$ #WT_REGION
  #WT_SOLID #WT_T #WT_TEI #X #XD$ #XDL$ #XDR$ #XD_NEW$
  )

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

  ;天板 図形名= &WT

  ;ｶｯﾄ側(左右)判断
  (cond
    ((= (nth 11 CG_GLOBAL$) "L")
      (setq #x "Left")  ; Rｴﾝﾄﾞ側=左
    )
    ((= (nth 11 CG_GLOBAL$) "R")
      (setq #x "Right") ; Rｴﾝﾄﾞ側=右
    )
  );_cond

  ;Xdata "G_WRKT"
  (setq #xd$ (CFGetXData &WT "G_WRKT"))

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
  (setq #FG_tei2 (nth 52 #xd$))  ; FG2底面 *
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
;;; (setq #dist$ (KPGetRendDist #WT_pt$ #CutType)) ; (奥行き,WT下辺)

  ; 加工ﾀｲﾌﾟ Rｴﾝﾄﾞのﾀｲﾌﾟ /1=両側/2=左側/3=右側/
  (setq #iType 1)
  ; RｴﾝﾄﾞのR(径)
  (setq #rr "60")
  (command "_fillet" "R" #rr)

  ;// 既存のワークトップ(前垂れ込み3DSOLID)を削除
  (entdel &WT)
  ; 既存底面削除
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
          (setq #line$ (##GETLINE #ss_dum #p3))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc2 #ss_dum)
          ; FG底面作成 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen_R2 #WT_pt$ #arc2 #FG_T #rr))
        )
        ((= #iType 3) ; 右側Rｴﾝﾄﾞ
          (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2を端点に持つ"LINE"のﾘｽﾄを取得
          (setq #arc1  (##FILLET #line$))       ; Filletして"ARC"を取得
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
          ; FG底面作成 01/07/10 YM ADD
          (ssadd #arc1 #ss_dum)
          (setq #FG0 (KPMakeFGTeimen_L2 #WT_pt$ #arc1 #FG_T #rr))
        )
        ((= #iType 3) ; 右側Rｴﾝﾄﾞ
          (setq #line$ (##GETLINE #ss_dum #last))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc2 #ss_dum)
          ; FG底面作成 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen_L3 #WT_pt$ #arc2 #FG_T #rr))
        )
      );_cond
    )
  );_cond

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
  #WT_SOLID ; WT図形
);subKPRendWT

;<HOM>*************************************************************************
; <関数名>    : C:TOKU_TENBAN
; <処理概要>  : 天板特注化
; <戻り値>    : なし
; <作成>      : 
; <備考>      : 
;*************************************************************************>MOH<
(defun C:TOKU_TENBAN (
  /
  #loop #WT #xd$ #wk_xd$ #hinban_dat$ #BG1 #BG2 #CG_TOKU_HINBAN
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:TOKU_TENBAN ////")
  (CFOutStateLog 1 1 " ")

  ; コマンドの初期化
  (StartUndoErr)
  (CFCmdDefBegin 0)
  (CFNoSnapReset)


	; 2019/03/04 YM MOD 場合わけ
	(cond
		((= BU_CODE_0013 "1") ; PSKCの場合
			(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
		)
		((= BU_CODE_0013 "2") ; PSKDの場合
			(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
		)
		(T ;それ以外
			(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
		)
	);_if
	; 2019/03/04 YM MOD 場合わけ


	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)

  (if (equal (KPGetSinaType) 2 0.1)
    (progn
      (CFAlertMsg msg8)
      (quit)
    )
    (progn
      ; ワークトップの指示
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
              (progn
                (PCW_ChColWT #WT "MAGENTA" nil)
                (setq #loop nil)
              )
;              (if (= (nth 0 #wk_xd$) 1)
;                (progn
;                  (PCW_ChColWT #WT "MAGENTA" nil)
;                  (setq #loop nil)
;                )
;                (progn
;                  (CFAlertMsg "指定したワークトップは特注品です。")
;                  (exit)
;                )
;              )
              (CFAlertMsg "指定したワークトップは品番が確定されていません。")
            )
          )
          (CFAlertMsg "ワークトップではありません。")
        )

        (if (= (nth 0 #wk_xd$) 1)
          ; 規格→特注
          (setq #hinban_dat$
            (list
              0                  ; 特注フラグ
;;;              "ZZ6500"           ; 品番
              #CG_TOKU_HINBAN     ; 品番 2016/08/30 YM ADD (4)天板なので機器以外 2019/03/04 YM MOD 場合わけ
              "0"                ; 金額
              (nth 5 #wk_xd$)    ; 巾
              (nth 6 #wk_xd$)    ; 高さ
              (nth 7 #wk_xd$)    ; 奥行
;              (nth 4 #wk_xd$)    ; 品名
;;;              (strcat "ﾄｸﾁｭｳ(" (nth 1 #wk_xd$) ")")    ; 品名
							CG_TOKU_HINMEI     ; 品名 2016/08/30 YM ADD
              (nth 8 #wk_xd$)    ; 特注コード
            )
          )
          ; 特注→特注
          (setq #hinban_dat$
            (list
              0                       ; 特注フラグ
;;;              "ZZ6500"                ; 品番
              #CG_TOKU_HINBAN     ; 品番 2016/08/30 YM ADD (4)天板なので機器以外 2019/03/04 YM MOD 場合わけ
              (rtos (nth 3 #wk_xd$))  ; 金額
              (nth 5 #wk_xd$)         ; 巾
              (nth 6 #wk_xd$)         ; 高さ
              (nth 7 #wk_xd$)         ; 奥行
;;;              (nth 4 #wk_xd$)         ; 品名
							CG_TOKU_HINMEI     ; 品名 2016/08/30 YM ADD
              (nth 8 #wk_xd$)         ; 特注コード
            )
          )
        )

        ; 天板品名確定ダイアログ処理
;-- 2011/12/12 A.Satoh Mod - S
;;;;;        (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$))
        (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$ (nth 3 #xd$)))
;-- 2011/12/12 A.Satoh Mod - E
        (if (= #hinban_dat$ nil)
          (exit)
        )

        (CFSetXData #WT "G_WTSET" (CFModList #wk_xd$
            (list
              (list 0 (nth 0 #hinban_dat$))
              (list 1 (nth 1 #hinban_dat$))
              (list 3 (nth 2 #hinban_dat$))
              (list 4 (nth 6 #hinban_dat$))
              (list 5 (nth 3 #hinban_dat$))
              (list 6 (nth 4 #hinban_dat$))
              (list 7 (nth 5 #hinban_dat$))
              (list 8 (nth 7 #hinban_dat$))
							(if (= (nth 9 #wk_xd$) "")
              	(list 9 (nth 1 #wk_xd$))
              	(list 9 (nth 9 #wk_xd$))
							)
            ))
        )
        (CFSetXData #WT "G_WRKT" (CFModList #xd$ (list (list 58 "TOKU"))))

        (command "_.change" #WT "" "P" "C" CG_WorkTopCol "")
        ;;; BG,FGも一緒に色替えする
        (setq #BG1 (nth 49 #xd$))
        (setq #BG2 (nth 50 #xd$))
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
    )
  )

;  (alert "★★★　工事中　★★★")

  (CFNoSnapFinish)
  (CFCmdDefFinish)
  (setq *error* nil)
  (princ)
);C:TOKU_TENBAN


;-- 2012/04/20 A.Satoh Add シンク配置不具合対応 - S
;;;<HOM>*************************************************************************
;;; <関数名>    : getSinkDep
;;; <処理概要>  : シンクキャビネットが配置された天板の奥行を取得する
;;; <戻り値>    : 奥行 or nil
;;; <作成>      : 2012/04/20 A.Satoh
;;; <備考>      : シンクが複数ある場合は、最初に見つかったシンク側の奥行を返す
;;;*************************************************************************>MOH<
(defun getSinkDep (
	&wk_en			; ワークトップ図形
	/
	#xd_WRKT$ #wt_pnt$ #snk$$ #snk$ #snkcab$ #sink_pnt$ #kei #chk_flg #err_flag
	#p1 #p2 #p3 #p4 #p5 #p6 #p7 #p8 #ret
	#PD #PDSIZE
	)

	;2012/06/25 YM ADD-S JudgeNaigaiの結果が常にnil⇒奥行き求められず、シンク配置できない
  (setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "pdmode" 34)
  (setvar "PDSIZE" 10)
	;2012/06/25 YM ADD-E JudgeNaigaiの結果が常にnil⇒奥行き求められず、シンク配置できない

	(setq #err_flag nil)

	; 天板の点列情報を求める
	(setq #xd_WRKT$ (CFGetXData &wk_en "G_WRKT"))
	(setq #wt_pnt$ (GetLWPolyLinePt (nth 38 #xd_WRKT$)))			; WT外形点列
	(setq #wt_pnt$ (GetPtSeries (nth 32 #xd_WRKT$) #wt_pnt$))	; WT左上点を先頭に時計周り

	; 視点を真上に設定する
	(command "vpoint" "0,0,1")

	; 天板内にあるシンクキャビを取得⇒天板配置基点を取得
	(setq #snkcab$ nil)
;;;	(setq #snk$$ (nth 0 (PKW_GetWorkTopAreaSym3 &wk_en)))
;;;	(foreach #snk$ #snk$$
;;;		(setq #snkcab$ (append #snkcab$ (list (nth 1 #snk$))))
;;;	)

	;2014/07/02 YM MOD-S
	(setq #snkcab$ (PKGetSymBySKKCodeCP #wt_pnt$ CG_SKK_INT_SCA)) ; 天板領域内ｼﾝｸｷｬﾋﾞ
	(setq #snkcab$ (NilDel_List #snkcab$))

	(if #snkcab$
		(progn
			nil
;;;			;シンクキャビシンボル基点を求めている
;;;			(setq #sink_pnt$ (nth 1 (CFGetXData (car #snkcab$) "G_LSYM")))
;;;			;2012/06/25 YM ADD-S JudgeNaigaiの結果が常にnil⇒奥行き求められず、シンク配置できない
;;;			(setq #sink_pnt$ (list (nth 0 #sink_pnt$) (nth 1 #sink_pnt$)))
;;;			;2012/06/25 YM ADD-E JudgeNaigaiの結果が常にnil⇒奥行き求められず、シンク配置できない
		)
		(progn
			(setq #err_flag T)
			(setq #ret nil)
		)
	);_if

	(if (= #err_flag nil)
		(progn
			; 天板の点列数による処理の振り分け
			(setq #kei (nth 3 #xd_WRKT$))
			(setq #chk_flg nil)
			(cond
				((= #kei 1)	; L型
					(setq #p1 (nth 0 #wt_pnt$))
					(setq #p2 (nth 1 #wt_pnt$))
					(setq #p3 (nth 2 #wt_pnt$))
					(setq #p4 (nth 3 #wt_pnt$))
					(setq #p5 (nth 4 #wt_pnt$))
					(setq #p6 (nth 5 #wt_pnt$))

					; 第１領域チェック
;;;					(if (JudgeNaigai #sink_pnt$ (list #p1 #p2 #p3 #p4 #p1))
;;;						(progn
;;;							(setq #ret (car (nth 57 #xd_WRKT$)))
;;;							(setq #chk_flg T)
;;;						)
;;;					)

				 	; 第１領域チェック
					(setq #exist (PKGetSymBySKKCodeCP (list #p1 #p2 #p3 #p4 #p1) CG_SKK_INT_SCA)) ; 天板領域内ｼﾝｸｷｬﾋﾞ
					(if #exist
						(progn
							(setq #ret (car (nth 57 #xd_WRKT$)));2番目
							(setq #chk_flg T)
						)
					);_if

					(if (= #chk_flg nil)
						(progn
						; 第２領域チェック
;;;						(if (JudgeNaigai #sink_pnt$ (list #p4 #p5 #p6 #p1 #p4))
;;;							(progn
;;;								(setq #ret (cadr (nth 57 #xd_WRKT$)))
;;;								(setq #chk_flg T)
;;;							)
;;;						);_if

							; 第２領域チェック
							(setq #exist (PKGetSymBySKKCodeCP (list #p4 #p5 #p6 #p1 #p4) CG_SKK_INT_SCA)) ; 天板領域内ｼﾝｸｷｬﾋﾞ
							(if #exist
								(progn
									(setq #ret (cadr (nth 57 #xd_WRKT$)));2番目
									(setq #chk_flg T)
								)
							);_if

						)
					);_if

				)
				((= #kei 2)	; U型
					(setq #p1 (nth 0 #wt_pnt$))
					(setq #p2 (nth 1 #wt_pnt$))
					(setq #p3 (nth 2 #wt_pnt$))
					(setq #p4 (nth 3 #wt_pnt$))
					(setq #p5 (nth 4 #wt_pnt$))
					(setq #p6 (nth 5 #wt_pnt$))
					(setq #p7 (nth 6 #wt_pnt$))
					(setq #p8 (nth 7 #wt_pnt$))

					; 第１領域チェック
;;;					(if (JudgeNaigai #sink_pnt$ (list #p1 #p2 #p3 #p4 #p1))
;;;						(progn
;;;							(setq #ret (car (nth 57 #xd_WRKT$)))
;;;							(setq #chk_flg T)
;;;						)
;;;					);_if

				 	; 第１領域チェック
					(setq #exist (PKGetSymBySKKCodeCP (list #p1 #p2 #p3 #p4 #p1) CG_SKK_INT_SCA)) ; 天板領域内ｼﾝｸｷｬﾋﾞ
					(if #exist
						(progn
							(setq #ret (car (nth 57 #xd_WRKT$)));2番目
							(setq #chk_flg T)
						)
					);_if

					(if (= #chk_flg nil)
						(progn
							
						; 第２領域チェック
;;;						(if (JudgeNaigai #sink_pnt$ (list #p4 #p5 #p8 #p1 #p4))
;;;							(progn
;;;								(setq #ret (cadr (nth 57 #xd_WRKT$)))
;;;								(setq #chk_flg T)
;;;							)
;;;						);_if

							; 第２領域チェック
							(setq #exist (PKGetSymBySKKCodeCP (list #p4 #p5 #p8 #p1 #p4) CG_SKK_INT_SCA)) ; 天板領域内ｼﾝｸｷｬﾋﾞ
							(if #exist
								(progn
									(setq #ret (cadr (nth 57 #xd_WRKT$)));2番目
									(setq #chk_flg T)
								)
							);_if
						)
					);_if

					(if (= #chk_flg nil)
						(progn

						; 第３領域チェック
;;;						(if (JudgeNaigai #sink_pnt$ (list #p5 #p6 #p7 #p8 #p5))
;;;							(progn
;;;								(setq #ret (caddr (nth 57 #xd_WRKT$)))
;;;								(setq #chk_flg T)
;;;							)
;;;						);_if

								; 第３領域チェック
								(setq #exist (PKGetSymBySKKCodeCP (list #p5 #p6 #p7 #p8 #p5) CG_SKK_INT_SCA)) ; 天板領域内ｼﾝｸｷｬﾋﾞ
								(if #exist
									(progn
										(setq #ret (caddr (nth 57 #xd_WRKT$)));3番目
										(setq #chk_flg T)
									)
								);_if
							)

					);_if
				)
				(T						; I型
					(setq #ret (car (nth 57 #xd_WRKT$)))
				)
			)
		)
	)

	;2012/06/25 YM ADD-S JudgeNaigaiの結果が常にnil⇒奥行き求められず、シンク配置できない
  (setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)
	;2012/06/25 YM ADD-E JudgeNaigaiの結果が常にnil⇒奥行き求められず、シンク配置できない

	; 視点を元に戻す
	(command "ZOOM" "P")

;;(princ "\n#ret = ")(princ #ret)(princ)
	#ret

) ;getSinkDep
;-- 2012/04/20 A.Satoh Add シンク配置不具合対応 - E

(princ)