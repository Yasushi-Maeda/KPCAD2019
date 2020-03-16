
(defun C:uu()
  (command "undo" "b" )
)
(defun C:de1() ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞにする
  (Setq CG_DEBUG 1)
)
(defun C:de0() ; ﾕｰｻﾞｰﾓｰﾄﾞにする
  (Setq CG_DEBUG nil)
)

;;---------------------------------------------------------
;;;関数検索用
;;;(defun PK_MakePMEN2 PMEN2を作成してｼﾝﾎﾞﾙのｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰとする
;;;(defun PKGetWT$FromMRWT 一番右WT==>右から順に関連WTﾘｽﾄを返す
; 一番右のＷＴ
;;;(defun PKGetMostRightWT WT図形名を渡して一番右のWTを返す
;;;(defun PKGetWTLEN$ 650×650 の場合長辺寸法,短辺寸法の順
;;;                   750×650,650×750の場合750側を先に
;;;                   その他の場合長辺寸法,短辺寸法の順

;;;(defun PKFind_HINBAN_AreaCP  領域点列ﾘｽﾄ,品番名称を渡して領域内の同品番ｼﾝﾎﾞﾙ図形名ﾘｽﾄを返す
;;;(defun PKSStoMRWT$           WT選択ｾｯﾄ-->最右WT図形ﾘｽﾄに変換
;;;(defun PKGetSuisenAna        WT図形を渡して水栓穴の(中心座標,直径,水栓穴属性)を返す
; WT領域ｷｬﾋﾞ寸法
;;;(defun PK_GetWTUnderCabDimCP ﾜｰｸﾄｯﾌﾟ図形選択ｾｯﾄを渡して、領域内にあるｷｬﾋﾞﾈｯﾄ寸法Ｗ数列を返す
;;;(defun PKWTCabDim_I          ｷｬﾋﾞﾈｯﾄ寸法Ｗ数列を返す(I型)
;;;(defun PKWTCabDim_L          ｷｬﾋﾞﾈｯﾄ寸法Ｗ数列を返す(L型)
;;;(defun PKWTCabDim_U          ｷｬﾋﾞﾈｯﾄ寸法Ｗ数列を返す(U型)
; 関連ＷＴ
;;;(defun PKGetWTSSFromWTEN     ﾜｰｸﾄｯﾌﾟ図形--->関連WT選択ｾｯﾄ
;;;(defun PK_WTSStoPlPt         ﾜｰｸﾄｯﾌﾟ図形選択ｾｯﾄを渡して、その外形点列を戻す
;;;(defun PKDelWkTopONE         引数WTとそのｼﾝｸ,水栓,BG,底面のみを削除(関連WTは削除しない)
;;;(defun DelAppXdata           図形名 &en の拡張ﾃﾞｰﾀ(APP名 &app)を消去する
;;;(defun CMN_VAL_MINMAX        実数値のリストから最大,最小値を求める  未使用
;;;(defun PKGetPMEN_NO          ｼﾝﾎﾞﾙ図形,PMEN番号を渡してPMEN(&NO)図形名を得る
;;;(defun PKGetPTEN_NO          ｼﾝﾎﾞﾙ図形,PTEN番号を渡してPTEN(&NO)図形名を得る
;;;(defun PKGetWTSymCP          領域点列ﾘｽﾄを渡して領域に含まれるＷＴを検索する
;;;(defun PKGetHinbanSSCP       領域点列ﾘｽﾄを渡して領域に含まれる、ｼﾝｸｻﾎﾟｰﾄｼｽﾃﾑを検索する
;;;(defun PKGetSinkSuisenSymCP  領域点列ﾘｽﾄを渡して領域に含まれる、シンク,水栓を検索する
;;;(defun PKGetG_WTRCP 領域点列ﾘｽﾄを渡して領域に含まれる、"G_WTR"を検索する
;;;(defun PKGetSinkSymBySinkCabCP ｼﾝｸｷｬﾋﾞ領域に含まれるｼﾝｸを検索する
;;;(defun PKGetSuisenSymBySinkCabCP ｼﾝｸｷｬﾋﾞ領域に含まれる水栓を検索する
;;;(defun PKGetGasSymByGasCabCP ｺﾝﾛｷｬﾋﾞ領域に含まれるｺﾝﾛを検索する
;;;(defun PKGetSymBySKKCodeCP   領域点列ﾘｽﾄ,性格ｺｰﾄﾞを渡して領域内のｼﾝﾎﾞﾙ図形名ﾘｽﾄを返す
;;;(defun PKGetBaseSymCP        領域点列ﾘｽﾄを渡して領域内のﾍﾞｰｽｷｬﾋﾞ(11?)ｼﾝﾎﾞﾙ図形名ﾘｽﾄを返す
;;;(defun PKGetLowCabSym        ｼﾝﾎﾞﾙ図形名ﾘｽﾄを渡してﾛｰｷｬﾋﾞｼﾝﾎﾞﾙ図形名ﾘｽﾄを返す
;;;(defun StrLisToRealLis       文字列ﾘｽﾄを実数値ﾘｽﾄにする
;;;(defun StrToLisBySpace       文字列をspaceで区切ってﾘｽﾄ化する
;;;(defun StrToLisByBrk         文字列を#brkで区切ってﾘｽﾄ化する
;;;(defun GetPtSeries           閉じたﾎﾟﾘﾗｲﾝ外形点列を、点列内の&baseを先頭に時計周りにならべる
;;;(defun PCW_ChColWT           ﾜｰｸﾄｯﾌﾟ図形名を渡して、関連WTの色変えを行う.
;;;(defun RotatePoint           &ptを原点中心に#rad回転する
;;;(defun FromSSDelEnLis        選択ｾｯﾄから図形名ﾘｽﾄにある図形を除外する
;;;(defun MakeTempLayer         伸縮作業用テンポラリ画層の作成
;;;(defun BackLayer             (<図形名> 画層)を元に、画層をSKD_TEMP_LAYERから元に戻す
;;;(defun Chg_SStoEnLayer       選択ｾｯﾄ--->(<図形名> 画層)のﾘｽﾄのﾘｽﾄに変換
;;;(defun CMN_select_element    要素を複数回選択(entsel)して選択セットを返す  直前の選択取り消し可能
;;;(defun SetG_LSYM1
;;;(defun SetG_LSYM11
;;;(defun SetG_LSYM2
;;;(defun SetG_LSYM22
;;;(defun SetG_PRIM1
;;;(defun SetG_PRIM11
;;;(defun SetG_PRIM22
;;;(defun SetG_BODY

;;;(defun CMN_ss_to_en  選択セットを渡して図形名のリストを得る.
;;;(defun CMN_ssaddss   old選択セットにnew選択セット追加して新しい選択セットを作成.
;;;(defun CMN_enlist_to_ss  図形名のリストから選択セットを作成
;;;(defun CMN_all_en_list   図面上の全ての図形名のリスト(古い順)を戻す。
;;;(defun CMN_subs_elem_list リスト(&list$)の"&i"(0,1,2...)番目の要素を"&element"に変更する.
;;;(defun CMN_search_en_lis  図形名が、図形名リストの何番目にあるか.
;;;(defun advance (&val &nick / #ret) &val を150刻みにする 例 2325--->2400 但し0-->0
;;;(defun DBCheck  ＤＢ検索チェック強化

;;;(defun AddPline
;;;(defun GetLwPolyLineStEnPt   ライトウェイトポリラインの始点、終点を取得する
;;;(defun MakeLWPL              太さ0のLWPOLYLINEをかく
;;;(defun ListEdit
;;;(defun ListDel               引数1(ﾘｽﾄ)から引数2(ﾘｽﾄ)の要素を削除
;;;(defun GroupInSolidChgCol2   図形を色替えする
;;;(defun GetMinMaxLineToPT$    ﾎﾟﾘﾗｲﾝの各点と線分(始点,終点)との距離の最小値,最大値のﾘｽﾄを返す
;;;(defun FlagToList (  &int / )    3桁の整数を0つきリスト化
;;;(defun PKGetWT_outPT (&WT / #pt$) ﾜｰｸﾄｯﾌﾟ図形名を渡して外形点列を戻す 点列(始点を末尾に追加済み)
;;;(defun AddPtList (&pt$ / )点列の末尾に始点を加えて返す
;;;(defun NotNil_length ( &lis / #kosu) listのnilでない要素数を返す
;;;(defun NilDel_List  ﾘｽﾄからnilを除く
;;;(defun PKDirectPT  点列の各点が全て直線の同じ側にあれば nil
;;;(defun MakeRectanglePT 中心&pt,辺の長さ&a*2の正方形外形点列(末尾に始点を追加)を返す
;;;(defun KCGetZaiF       材質記号から素材Fを取得する
;;;(defun c:all 　　　　　選択した図形のｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰの全図形のﾀｲﾌﾟ、ﾊﾝﾄﾞﾙ、拡張ﾃﾞｰﾀを表示
;;;(defun c:oya　　　　　選択した図形の親図形情報を表示
;;;(defun C:ALP( / )　KPCAD 全ての画層を表示
;;;(defun C:HCOL　　　図形ﾊﾝﾄﾞﾙを入力--->その図形が赤になる
;;;(defun C:ddd ( / ) KPCAD　c:alpの後に画層を元に戻すコマンド
;;;(defun c:PTN(　　図面上で"G_PRIM"の底面図形が正しくｾｯﾄされていないｱｲﾃﾑの図形IDを探す
;;;(defun c:clZ 図面のゴミ削除
;;;(defun c:PM2N (　　　図面上で"G_PMEN"2がｾｯﾄされていないｱｲﾃﾑの図形IDを返す
;;;(defun c:ChgSKK      選択されたアイテムの性格CODEを変更する。



;;---------------------------------------------------------

(setq CG_ZMOVEDIST 1000.) ; Z移動距離 ﾃﾞﾌｫﾙﾄ値
(setq CG_CABCUT      50.) ; 底面からのｷｬﾋﾞﾈｯﾄｶｯﾄ位置

;;;<HOM>*************************************************************************
;;; <関数名>     : PKExtendPTAreaRL100mm
;;; <処理概要>   : PMEN2を作成してｼﾝﾎﾞﾙのｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰとする
;;; <戻り値>     : なし
;;; <作成>       : 00/06/19 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun PKExtendPTAreaRL100mm (
  &pt$ ; 外形領域点列(始点を末尾に追加した5点)
  &LR  ; 延長側
  /
  #P1 #P2 #P3 #PA #PB #PT$ #PTSET
  )
  (setq #pt$ '())

  (if (= &LR "L")
    (progn
;;;p1+----------------+p2
;;;  |
;;;  |
;;;  |
;;;p3+
      (setq #p1 (nth 0 &pt$))
      (setq #p2 (nth 1 &pt$))
      (setq #p3 (last  &pt$))
      (setq #pA (polar #p1 (angle #p2 #p1) 100))
      (setq #pB (polar #p3 (angle #p2 #p1) 100))
      (foreach #pt &pt$
        (cond
          ((< (distance #pt #p1) 0.1)
            (setq #ptset #pA)
          )
          ((< (distance #pt #p3) 0.1)
            (setq #ptset #pB)
          )
          (T
            (setq #ptset #pt)
          )
        );_cond
        (setq #pt$ (append #pt$ (list #ptset)))
      )
    )
  );_if

  (if (= &LR "R")
    (progn
;;;p1+----------------+p2
;;;                   |
;;;                   |
;;;                   |
;;;                   +p3
      (setq #p1 (nth 0 &pt$))
      (setq #p2 (nth 1 &pt$))
      (setq #p3 (nth 2 &pt$))
      (setq #pA (polar #p2 (angle #p1 #p2) 100))
      (setq #pB (polar #p3 (angle #p1 #p2) 100))
      (foreach #pt &pt$
        (cond
          ((< (distance #pt #p2) 0.1)
            (setq #ptset #pA)
          )
          ((< (distance #pt #p3) 0.1)
            (setq #ptset #pB)
          )
          (T
            (setq #ptset #pt)
          )
        );_cond
        (setq #pt$ (append #pt$ (list #ptset)))
      )
    )
  );_if
  #pt$
);PKExtendPTAreaRL100mm

;;;<HOM>*************************************************************************
;;; <関数名>     : PK_MakePMEN2
;;; <処理概要>   : PMEN2を作成してｼﾝﾎﾞﾙのｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰとする
;;; <戻り値>     : なし
;;; <作成>       : 00/06/19 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun PK_MakePMEN2 (
  &sym ;(ENAME)ｼﾝｸｼﾝﾎﾞﾙ図形
  /
  #ANG #D #P1 #P2 #P3 #P4 #PMEN2 #W #GRNAME
  )
  (setq #p1 (cdr (assoc 10 (entget &sym))))      ; ｼﾝﾎﾞﾙ基点座標
  (setq #ang (nth 2 (CFGetXData &sym "G_LSYM"))) ; 配置角度
  (setq #W   (nth 3 (CFGetXData &sym "G_SYM")))  ; 寸法W
  (setq #D   (nth 4 (CFGetXData &sym "G_SYM")))  ; 寸法D
  (setq #p2 (polar #p1 #ang #W))
  (setq #p3 (polar #p2 (- #ang (dtr 90)) #D))
  (setq #p4 (polar #p1 (- #ang (dtr 90)) #D))
  (setq #GRname (SKGetGroupName &sym))      ; ｸﾞﾙｰﾌﾟ名取得

  (setq #pmen2 (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))
  (entmod (subst (cons 8 "Z_01_02_00_02") (assoc 8 (entget #pmen2)) (entget #pmen2)))
  (CFSetXData #pmen2 "G_PMEN" (list 2 0 0)) ; "G_PMEN" 2 のセット
  (command "_.-group" "A" #GRname #pmen2 ""); #pmen2 を &sym と同じｸﾞﾙｰﾌﾟにする

  (setq #pmen2 (MakeLwPolyLine (list #p1 #p2 #p3 #p4) 1 0))
  (entmod (subst (cons 8 "Z_01_03_00_12") (assoc 8 (entget #pmen2)) (entget #pmen2)))
  (CFSetXData #pmen2 "G_PMEN" (list 2 0 0)) ; "G_PMEN" 2 のセット
  (command "_.-group" "A" #GRname #pmen2 ""); #pmen2 を &sym と同じｸﾞﾙｰﾌﾟにする

  #pmen2
);PK_MakePMEN2

;;;<HOM>*************************************************************************
;;; <関数名>     : KP_MakeCornerPMEN2
;;; <処理概要>   : ｺｰﾅｰｷｬﾋﾞPMEN2の頂点数が不正なら再作成してｼﾝﾎﾞﾙのｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰとする
;;; <戻り値>     : なし
;;; <作成>       : 01/04/11 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun KP_MakeCornerPMEN2 (
  &sym ;(ENAME)ｺｰﾅｰｷｬﾋﾞｼﾝﾎﾞﾙ図形
  /
  #EN #GRNAME #I #LAYER #P1 #P2 #P3 #P4 #P5 #P6 #PMEN$ #PMEN2 #PT$ #SS #XD$ #flg #pmen2$
#LAST ; 02/09/04 YM ADD
  )
  (setq #flg nil)
  (setq #pmen2$ nil)
  (setq #ss (CFGetSameGroupSS &sym))
  (setq #i 0)
  (setq #pmen$ nil)
  (while (< #i (sslength #ss))
    (setq #en (ssname #ss #i)) ; 同一ｸﾞﾙｰﾌﾟ
    (if (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
      (if (= 2 (car #xd$))
        (setq #pmen$ (append #pmen$ (list #en)))
      );_if
    );_if
    (setq #i (1+ #i))
  )
  (foreach #pmen #pmen$
    (setq #layer (assoc 8 (entget #pmen)))
    (setq #pt$ (GetLWPolyLinePt #pmen)) ; ｼﾝｸｷｬﾋﾞPMEN2 外形領域
    (if (< 6 (length #pt$)) ; 頂点数不正
      (progn
        (setq #p1 (nth 0 #pt$))
        (setq #p2 (nth 1 #pt$))
        (setq #p3 (nth 2 #pt$))
        (setq #p4 (nth 3 #pt$))
        (setq #p5 (nth 4 #pt$))
        (setq #p6 (nth 5 #pt$))

        ; 始点終点が同一点のときのみ終点を間引く処理 01/05/22 YM ADD
        (setq #last (last #pt$))
        (if (and (= (length #pt$) 7)(< (distance #p1 #last) 0.1))
          (progn
            (setq #GRname (SKGetGroupName &sym))      ; ｸﾞﾙｰﾌﾟ名取得
            (setq #pmen2 (MakeLWPL (list #p1 #p2 #p3 #p4 #p5 #p6) 1))
            (setq #pmen2$ (append #pmen2$ (list #pmen2))) ; 01/06/19 YM ADD
            (entmod (subst #layer (assoc 8 (entget #pmen2)) (entget #pmen2)))
            (CFSetXData #pmen2 "G_PMEN" (list 2 0 0)) ; "G_PMEN" 2 のセット
            (command "_.-group" "A" #GRname #pmen2 ""); #pmen2 を &sym と同じｸﾞﾙｰﾌﾟにする
            (entdel #pmen) ; 頂点数不正PMEN2を削除
          )
          (setq #flg T)
        );_if
      )
    );_if
  );foreach

  (if #flg
    (princ (strcat "\nキャビネットの外形領域(PMEN2)の頂点数が正しくありません。"
      "\nワークトップ自動生成時に不具合が発生します。"))
;;;   (CFAlertMsg (strcat "キャビネットの外形領域(PMEN2)の頂点数が正しくありません。"
;;;     "\nワークトップ自動生成時に不具合が発生します。"))
  );_if
  #pmen2$ ; nil or 新しく作成したPMEN2
);KP_MakeCornerPMEN2

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetWT$FromMRWT
;;; <処理概要>  : 一番右WT==>右から順に関連WTﾘｽﾄを返す
;;; <戻り値>    : WT図形ﾘｽﾄ
;;; <作成>      : 2000.6.21 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKGetWT$FromMRWT (
  &WTMR
  /
  #WT$ #WTL #WTXD$ #WTXD0$
  )
  (setq #WT$ '())
  (setq #WT$ (append #WT$ (list &WTMR)))
  (setq #wtxd$ (CFGetXData &WTMR "G_WRKT"))
  ;;; ｶｯﾄ相手左
  (setq #WTL (nth 47 #wtxd$))    ; 左WT図形ﾊﾝﾄﾞﾙ
  (while (and #WTL (/= #WTL "")) ; 左にWTがあれば
    (setq #WT$ (append #WT$ (list #WTL)))
    (setq #wtxd0$ (CFGetXData #WTL "G_WRKT"))
    (setq #WTL (nth 47 #wtxd0$))     ; 更に左にあるか
    (if (= #WTL "") (setq #WTL nil)) ; なかったら nil
  )
  #WT$
);PKGetWT$FromMRWT

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetMostRightWT
;;; <処理概要>  : WT図形名を渡して一番右のWTを返す
;;; <戻り値>    : (WT図形名,ﾌﾗｸﾞ 0:ｽﾃﾝﾚｽ or 接続なし 1:左接続あり)
;;; <作成>      : 05/23 YM
;;; <備考>      : ｽﾃﾝﾚｽ or 左右接続しないWTの場合はnilを返す
;;;*************************************************************************>MOH<
(defun PKGetMostRightWT (
  &WT ; WT図形名
  /
  #RET #WTR #WTXD$ #WTXD0$ #FLG
  )
  (setq #wtxd$ (CFGetXData &WT "G_WRKT"))
  (cond
    ((and (= (nth 47 #wtxd$) "")(= (nth 48 #wtxd$) "")); 左右にWTがない場合
      (setq #ret &WT)
      (setq #flg 0)
    )
    ((and (/= (setq #WTR (nth 48 #wtxd$)) "") ; 右WT図形ﾊﾝﾄﾞﾙが存在る
           #WTR)                              ;00/08/07 SN MOD nilの場合もある。
    ;((/= (setq #WTR (nth 48 #wtxd$)) "") ; 右WT図形ﾊﾝﾄﾞﾙが存在する
      (setq #flg 1)
      (while (and #WTR (/= #WTR ""))
        (setq #ret #WTR)
        (setq #wtxd0$ (CFGetXData #WTR "G_WRKT"))
        (if (= (nth 48 #wtxd0$) "")
          (setq #WTR nil) ; もう右にない場合
          (setq #WTR (nth 48 #wtxd0$))
        );_if
      );_while
    )
    (T
      (setq #flg 1)
      (setq #ret &WT) ; 引数WTが一番右
    )
  );_cond
  (list #ret #flg)
);PKGetMostRightWT

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetWTLEN$
;;; <処理概要>  : 650×650 の場合長辺寸法,短辺寸法の順
;;;               750×650,650×750の場合750側を先に
;;;               その他の場合長辺寸法,短辺寸法の順
;;; <戻り値>    : WT長さﾘｽﾄ
;;; <作成>      : 00/06/02 YM
;;; <備考>      : ｽﾃﾝﾚｽL型専用
;;;*************************************************************************>MOH<
(defun PKGetWTLEN$ (
  &dep1; ｼﾝｸ側奥行き
  &dep2; ｺﾝﾛ側奥行き
  &WTLEN1; ｼﾝｸ側WT長さ
  &WTLEN2; ｺﾝﾛ側WT長さ
  /
  #WTLEN$
  )
  (cond
    ((and (equal &dep1 650 0.1)(equal &dep2 650 0.1)) ; 650×650 これは正
      (if (>= &WTLEN1 &WTLEN2) ; 650×650 の場合長辺寸法,短辺寸法の順にする
        (setq #WTLEN$ (list &WTLEN1 &WTLEN2))
        (setq #WTLEN$ (list &WTLEN2 &WTLEN1))
      );_if
    )
    ((and (equal &dep1 750 0.1)(equal &dep2 650 0.1)) ; 750×650 これは正
      (setq #WTLEN$ (list &WTLEN1 &WTLEN2))
    )
    ((and (equal &dep1 650 0.1)(equal &dep2 750 0.1)) ; 650×750 この処理？
      (setq #WTLEN$ (list &WTLEN2 &WTLEN1))
    )
    (T
      (if (>= &WTLEN1 &WTLEN2) ; 長辺寸法,短辺寸法の順にする
        (setq #WTLEN$ (list &WTLEN1 &WTLEN2))
        (setq #WTLEN$ (list &WTLEN2 &WTLEN1))
      );_if
    )
  );_cond
  #WTLEN$
);PKGetWTLEN$

;;;<HOM>*************************************************************************
;;; <関数名>    : PKFind_HINBAN_AreaCP  ;;;KSPX090AB
;;; <処理概要>  : 領域点列ﾘｽﾄ,品番名称を渡して領域内の同品番ｼﾝﾎﾞﾙ図形名ﾘｽﾄを返す
;;; <戻り値>    : ｼﾝﾎﾞﾙ図形ﾘｽﾄ
;;; <作成>      : 2000.5.31 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;               ｱｲﾃﾑのｼﾝﾎﾞﾙが領域内部に含まれるときのみカウントする
;;;*************************************************************************>MOH<
(defun PKFind_HINBAN_AreaCP (
  &pt$
  &HINBAN
  /
  #HINBAN #I #SS #SYM #SYM$
  )
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; 領域内の各ｼﾝﾎﾞﾙ
            (setq #hinban (nth 5 (CFGetXData #sym "G_LSYM")))
            (if (wcmatch #hinban &HINBAN) ; 品番名称
              (setq #sym$ (append #sym$ (list #sym))) ; 挿入点
            )
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if
  #sym$ ; ｼﾝﾎﾞﾙ図形ﾘｽﾄ
);PKFind_HINBAN_AreaCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKSStoMRWT$
;;; <処理概要>  : WT選択ｾｯﾄ-->最右WT図形ﾘｽﾄに変換
;;; <戻り値>    : 最右WT図形ﾘｽﾄに変換
;;; <作成日>    : 00/06/02 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKSStoMRWT$ (
  &wtSS          ;(PICKSET)ワークトップの選択セット
  /
  #I #K #MRWT #MRWT$ #RELSS #SSWT #WT
  )

  (setq #MRWT$ '())
  (setq #relSS (ssadd)) ; 空の選択ｾｯﾄ 処理済みWTを格納
  (setq #i 0)
  (repeat (sslength &wtSS)
    (setq #WT (ssname &wtSS #i)) ; 各WT
    (if (= nil (ssmemb #WT #relSS)) ; 処理済みでない
      (progn
        (setq #ssWT (PKGetWTSSFromWTEN #WT)) ; 関連WT選択ｾｯﾄ
        (setq #k 0)
        (repeat (sslength #ssWT)
          (ssadd (ssname #ssWT #k) #relSS) ; 処理済み
          (setq #k (1+ #k))
        )
        (setq #MRWT (car (PKGetMostRightWT #WT))) ; 最も右WT
        (setq #MRWT$ (append #MRWT$ (list #MRWT)))
      )
    );_if
    (setq #i (1+ #i))
  );_repeat
  #MRWT$
);PKSStoMRWT$

;;;<HOM>*************************************************************************
;;; <関数名>    : PKOutputWTCT
;;; <処理概要>  : 図面上に、"G_WTCT","G_WTSET"がｾｯﾄされたWTがあれば、
;;;               WT品番と"G_WTCT"の内容を","で区切った文字列を全て&cfgに出力する
;;; <戻り値>    : (T:出力した or nil:出力しなかった)
;;; <作成>      : 05/24 YM
;;; <備考>      : 00/05/29 HN 引数を削除
;;;*************************************************************************>MOH<
(defun PKOutputWTCT (
  /
  #sFile #BRK #CTXD$ #ELM #F #I #N #OUTSTR #SS #SS0 #STXD$ #WT #lis$ #FLG
  )
  (setq #sFile (strcat CG_KENMEI_PATH "WorkTop.cfg"))
  (setq #flg nil #lis$ nil)
  (setq #ss (ssget "X" '((-3 ("G_WTCT"))))) ; 図面上の特注ﾜｰｸﾄｯﾌﾟ "G_WTCT"
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn ; 1つ以上あった
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #WT (ssname #ss #i))
            (if (and (CFGetXData #WT "G_WTCT")
                     (CFGetXData #WT "G_WTSET"))
              (setq #lis$ (append #lis$ (list #WT))) ; 出力対象WTﾘｽﾄ
            )
            (setq #i (1+ #i))
          );_repeat

          (if (> (length #lis$) 0)
            (progn ; 出力するものが1つ以上あった
              (setq #f (open #sFile "W")) ; 上書きﾓｰﾄﾞﾌｧｲﾙｵｰﾌﾟﾝ
              (setq #i 0)
              (foreach #WT #lis$
                (setq #ctxd$ (CFGetXData #WT "G_WTCT"))
                (setq #stxd$ (CFGetXData #WT "G_WTSET"))
                (setq #outstr (nth 1 #stxd$)) ; WT品番--->出力文字列
                (setq #brk ",")
                (setq #n 0)
                (repeat (length #ctxd$)
                  (setq #elm (nth #n #ctxd$)) ; 各要素
                  (if (numberp #elm) ; 実数 or 整数かどうか
                    (setq #elm (itoa (fix (+ #elm 0.00001)))) ; 文字列化
                  );_if
                  (setq #outstr (strcat #outstr #brk #elm))
                  (setq #n (1+ #n))
                );repeat
                (princ #outstr #f)
                (princ "\n" #f)
                (setq #i (1+ #i))
              );_foreach
              (close #f) ; 上書き完了
              (setq #flg T)
            )
          );_if
        )
      );_if
    )
  );_if
  #flg
);PKOutputWTCT

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetSuisenAna
;;; <処理概要>  : WT図形を渡して水栓穴の(中心座標,直径,水栓穴属性)を返す
;;;               水栓穴がないと nilを返す
;;; <戻り値>    : (中心座標,直径,水栓穴属性)のﾘｽﾄ  左の穴から順番 --->(中心座標,直径) 05/22 YM
;;; <作成>      : 05/20 YM
;;; <備考>      : 選択WTの領域にはｼﾝｸｷｬﾋﾞは１つと仮定している
;;;*************************************************************************>MOH<
(defun PKGetSuisenAna (
  &enWT  ;WT図形名
  /
  #ANA$ #ANA$$ #ANG #BASEPT #EN #ET #PX #PY #RET$
  #I #KOSU #O #OX #PMEN2 #PT$ #R #SNKCAB #SS #WTRXD$ #X1 #Y1 #ZOKU
  )
  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapStart)
;;; (command "vpoint" "0,0,1")
  (setq #ret$  '())
  (setq #ana$  '())
  (setq #ana$$ '())

  (setq #pt$ (PKGetWT_outPT &enWT 1))                   ; WT外形点列(始点末尾追加) ; 01/08/10 YM ADD(引数追加)
  (setq #snkCAB (car (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_GAS)))   ; ｼﾝｸｷｬﾋﾞｼﾝﾎﾞﾙ図形 ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
  (if #snkCAB
    (progn
      (setq #basePT (cdr (assoc 10 (entget #snkCAB))))  ; 挿入基点
      (setq #pmen2 (PKGetPMEN_NO #snkCAB 2))            ; ｼﾝｸｷｬﾋﾞPMEN2
      (if (= #pmen2 nil)
        (setq #pmen2 (PK_MakePMEN2 #snkCAB))            ; PMEN2 がなければ作成
      );_if
      (setq #pt$ (GetLWPolyLinePt #pmen2))              ; ｼﾝｸｷｬﾋﾞPMEN2 外形領域
      (setq #pt$ (AddPtList #pt$))                      ; 末尾に始点を追加する
      (command "_layer" "T" "Z_wtbase" "")
      (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_WTR"))))) ; 領域内の G_WTR
      (command "_layer" "F" "Z_wtbase" "")
      ;;; ﾕｰｻﾞｰ座標系利用
      (setq #ang (nth 2 (CFGetXData #snkCAB "G_LSYM"))) ; ｼﾝｸｷｬﾋﾞ配置角度
      (setq #x1 (polar #basePT #ang 1000))
      (setq #y1 (polar #basePT (+ #ang (dtr 90)) 1000))
      (command "._ucs" "3" #basePT #x1 #y1)             ; ﾕｰｻﾞｰ座標系

      (if #ss ; "G_WTR" があったら
        (progn
          (setq #kosu (sslength #ss))                   ; 穴個数
          (setq #i 0)
          (repeat #kosu ; "G_WTR" の数繰り返し
            (setq #en (ssname #ss #i))
            (setq #wtrxd$ (CFGetXData #en "G_WTR"))
            (setq #zoku (nth 0 #wtrxd$))
            (setq #et (entget #en))
            (if (= (cdr (assoc 0 #et)) "CIRCLE")
              (progn
                (setq #o  (cdr (assoc 10 #et)))         ; 中心座標(trans 不要)
                (setq #PX (car  (cdr (assoc 10 #et))))  ; 中心X座標(trans 不要)
                (setq #PY (cadr (cdr (assoc 10 #et))))  ; 中心Y座標(trans 不要)
                (setq #oX (car (trans #o 0 1)))         ; 中心x座標をﾕｰｻﾞｰ座標系に変換
                (setq #r (* 2.0 (cdr (assoc 40 #et))))  ; 直径
;;;               (setq #ana$ (list #oX #o #r #zoku))     ; (ﾕｰｻﾞｰ座標系での穴中心x座標,中心,直径,属性)
                (setq #ana$ (list #oX #PX #PY #r))      ; (ﾕｰｻﾞｰ座標系での穴中心x座標,中心X,Y,直径)
                (setq #ana$$ (append #ana$$ (list #ana$)))
              )
            );_if
            (setq #i (1+ #i))
          );_repeat #kosu
          (setq #ana$$ (CFListSort #ana$$ 0))           ; #oX = (nth 0 が小さいもの順にｿｰﾄ
          (setq #ana$$ (mapcar 'cdr #ana$$))            ; (中心X,Y,直径)だけにする
          ;;; ﾘｽﾄのﾘｽﾄ--->ﾘｽﾄ
          (foreach #ana$ #ana$$
            (setq #ret$ (append #ret$ #ana$))
          )
        )
      );_if
      (command "._ucs" "P")
    )
  );_if
;;; (command "zoom" "p")
  ;// Ｏスナップ関連システム変数の解除
  (CFNoSnapEnd);00/08/24 SN MOD
  ;(CFNoSnapStart)
  #ret$ ; 穴がなければ nil
);PKGetSuisenAna

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_GetWTUnderCabDimCP
;;; <処理概要>  : ﾜｰｸﾄｯﾌﾟ図形を渡して,そのWT直下にあるｷｬﾋﾞﾈｯﾄだけ寸法Ｗ数列を返す
;;; <戻り値>    : 寸法W数列ﾘｽﾄ(左から)
;;; <作成>      : 00/06/22 YM
;;; <備考>      :
;;;
;;; <I配列>
;;;  +-------+----+-------+
;;;  |       |    |       |
;;;  |       |    |       |
;;;  |       |    |       |
;;;  +-------+----+-------+
;;;  |   1   |  2 |   3   |
;;;
;;; (戻り値): (ｷｬﾋﾞ1寸法W,ｷｬﾋﾞ2寸法W,ｷｬﾋﾞ3寸法W)
;;;
;;; <L配列> ｽﾃﾝﾚｽのみ                 <L配列ｶｯﾄありｼﾝｸ側>      <L配列ｶｯﾄありｺﾝﾛ側>
;;;   |    3    |  4  |5 |              |    1    |  2  |3 |
;;; --+---------+-----+--+            --+---------+-----+--+   --+------------------+
;;;   |ｺｰﾅｰｷｬﾋﾞ |     |  |              |         |     |  |     |                  |
;;; 2 |         |     |  |              |         |     |  |   2 |                  |
;;;   |     +---+-----+--+              |     +---+-----+--+     |     +------------+
;;;   |     |                           |     |                  |     |
;;; --+-----+                           |     |                --+-----+
;;; 1 |     |                           |     |                1 |     |
;;;   |     |                           |     |                  |     |
;;; --+-----+                           +-----+                --+-----+
;;;
;;; 戻り値: (ｷｬﾋﾞ1寸法W,2,3,4,5)      (ｷｬﾋﾞ1寸法W,2,3)        (ｷｬﾋﾞ1寸法W,2)
;;; 関連ＷＴ全体の下にあるキャビネット寸法Ｗを求める ===> 06/21 YM 改める
;;; ｶｯﾄされたWTの場合WT外形の直下にあるキャビネット寸法Ｗを求める
;;;*************************************************************************>MOH<
(defun PK_GetWTUnderCabDimCP (
  &enWT  ;WT図形名
  /
  #BASE$ #CORNER$ #ICOUNT #NUM$ #PT$ #SKK$ #SS
  #LEN #OS #OT #RET$ #SM #FLG #WTXD$ #kosu_pt$ #xdWT$ #ii #WTMR
  )
;;; ｼｽﾃﾑ変数設定
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)

  ; 離れたWT対応 01/07/03 YM ADD PK_WTSStoPlPtは使えない START
  (setq #WTMR (car (PKGetMostRightWT &enWT))) ; 一番右(1枚目)WT
  (setq #xdWT$ (CFGetXData #WTMR "G_WRKT"))

  (if (and (nth 59 #xdWT$) (/= (nth 59 #xdWT$) "")) ; 新型"G_WRKT"[60]WT外形あり 01/07/04 YM MOD
    (progn
      (setq #pt$ (GetLWPolyLinePt (nth 59 #xdWT$))); 段差部も含んだWT外形領域
      (setq #pt$ (AddPtList #pt$)); 末尾に始点を追加する
    )
    (progn
      (setq #ss (PKGetWTSSFromWTEN &enWT)); WT図形名からWT選択ｾｯﾄを取得する
      (setq #pt$ (PK_WTSStoPlPt #ss))     ; WT外形点列を取得する(始点を末尾に追加済み)
    )
  );_if

  (setq #base$ (PKGetBaseSymCP #pt$)) ; 領域内ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙﾘｽﾄ
; ｺｰﾅｰｷｬﾋﾞの数 #icount ==>I,L,Uの判定
  (setq #icount 0)
  (foreach #sym #base$
    (setq #skk$ (CFGetSymSKKCode #sym nil))
    (if (= (nth 2 #skk$) CG_SKK_THR_CNR)
      (progn
        (setq #icount (1+ #icount))
        (setq #corner$ (append #corner$ (list #sym))) ; ｺｰﾅｰｷｬﾋﾞｼﾝﾎﾞﾙ図形名ﾘｽﾄ
      )
    )
  )

  (cond ; ｺｰﾅｰｷｬﾋﾞの数で判定
    ((= #icount 0) ; I型の場合
      (setq #num$ (PKWTCabDim_I #base$))
    )
    ((= #icount 1) ; L型の場合 &enWT が #flg = 0:ｼﾝｸ側 1:ｺﾝﾛ側 を渡す
      (setq #wtxd$ (CFGetXData &enWT "G_WRKT"))
      (cond
        ((/= (nth 47 #wtxd$) "") ; 左WT図形ﾊﾝﾄﾞﾙ
          (setq #flg 0) ; ｼﾝｸ側ｷｬﾋﾞ寸法W
        )
        ((/= (nth 48 #wtxd$) "") ; 右WT図形ﾊﾝﾄﾞﾙ
          (setq #flg 1) ; ｺﾝﾛ側ｷｬﾋﾞ寸法W
        )
        (T ; ｽﾃﾝﾚｽL型
          (setq #flg 999) ; 全ｷｬﾋﾞ寸法W
        )
      );_cond
      (setq #num$ (PKWTCabDim_L #base$ #corner$ #flg))
    )
    ((= #icount 2) ; U型の場合 &enWT が #flg = 0:ｼﾝｸ側 1:ｺﾝﾛ側 2:その他側 を渡す
      (setq #wtxd$ (CFGetXData &enWT "G_WRKT"))
      (cond
        ((and (/= (nth 47 #wtxd$) "")(= (nth 48 #wtxd$) "")) ; 左WT図形ﾊﾝﾄﾞﾙのみ存在
          (setq #flg 0) ; ｼﾝｸ側ｷｬﾋﾞ寸法W
        )
        ((and (/= (nth 47 #wtxd$) "")(/= (nth 48 #wtxd$) "")) ; 左右にWTが存在
          (setq #flg 1) ; ｺﾝﾛ側ｷｬﾋﾞ寸法W
        )
        ((and (= (nth 47 #wtxd$) "")(/= (nth 48 #wtxd$) "")) ; 右WT図形ﾊﾝﾄﾞﾙのみ存在
          (setq #flg 2) ; その側ｷｬﾋﾞ寸法W
        )
      );_cond
      (setq #num$ (PKWTCabDim_U #base$ #corner$ #flg))
    )
  );_cond

;;; ｼｽﾃﾑ変数設定
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)
  #num$
);PK_GetWTUnderCabDimCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKWTCabDim_I
;;; <処理概要>  : ｷｬﾋﾞﾈｯﾄ寸法Ｗ数列を返す(I型)
;;; <戻り値>    : 寸法数列ﾘｽﾄ(左から)全長含まず
;;; <作成>      : 05/18 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKWTCabDim_I (
  &Base$    ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形
  /
  #ANG #BASEPT #BASEX #BASEX1 #BASEX2 #BASEXY
  #I #LEN #LST$ #LST$$ #NUM$ #SYM #W #X1 #Y1
  )
;;; ﾘｽﾄの最初のｼﾝﾎﾞﾙを原点(0,0)とする
  (setq #basePT (cdr (assoc 10 (entget (car &Base$)))))
  (setq #ang (nth 2 (CFGetXData (car &Base$) "G_LSYM"))) ; 配置角度
  (setq #x1 (polar #basePT #ang 1000))
  (setq #y1 (polar #basePT (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #basePT #x1 #y1)
;;; ｼﾝﾎﾞﾙｘ座標のﾘｽﾄを求める
  (setq #i 0)
  (foreach #sym &Base$
    (setq #baseXY (cdr (assoc 10 (entget #sym))))        ; ｼﾝﾎﾞﾙのx座標
    (setq #baseX  (car (trans #baseXY 0 1)))             ; ﾕｰｻﾞｰ座標系に変換
    (setq #lst$ (list #baseX #sym))
    (setq #lst$$ (append #lst$$ (list #lst$)))
    (setq #i (1+ #i))
  )
  (setq #lst$$ (CFListSort #lst$$ 0))                    ; (nth 0 が小さいもの順にｿｰﾄ
;;; 左からの寸法Ｗ数列を求める
  (setq #i 0)
;;; (setq #LEN 0) ; 全長
  (repeat (length #lst$$)
    (setq #sym (cadr (nth #i #lst$$)))
    (setq #W (nth 3 (CFGetXData #sym "G_SYM"))) ; 寸法W
;;;   (setq #LEN (+ #LEN #W))
    (setq #num$ (append #num$ (list #W)))
    (setq #i (1+ #i))
  )
  (command "._ucs" "P")
;;; (list #num$ #LEN)
  #num$
);PKWTCabDim_I

;;;<HOM>*************************************************************************
;;; <関数名>    : PKWTCabDim_L
;;; <処理概要>  : ｷｬﾋﾞﾈｯﾄ寸法Ｗ数列を返す(L型)
;;; <戻り値>    : 寸法数列ﾘｽﾄ(左から)全長含まず
;;; <作成>      : 05/19 YM
;;; <備考>      : WTがｺｰﾅｰｷｬﾋﾞだけに張られている場合対応
;;;*************************************************************************>MOH<
(defun PKWTCabDim_L (
  &Base$    ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形
  &corner$  ; ｺｰﾅｰｷｬﾋﾞﾘｽﾄ
  &flg      ; 0:ｼﾝｸ側 1:ｺﾝﾛ側 999:両方
  /
  #BASE #BASEL$ #BASER$
  #CORNER
  #LENL #LENR #LR #num$
  #NUML$ #NUMR$ #PMEN2 #PT0$ #RET$ #SKK$ #W1 #W2
  )

  (setq #corner (car &corner$))                       ; ｺｰﾅｰｷｬﾋﾞｼﾝﾎﾞﾙ図形
  (setq #base (cdr (assoc 10 (entget #corner))))      ; ｼﾝﾎﾞﾙ基点
;;; PMEN2 を探す
  (setq #pmen2 (PKGetPMEN_NO #corner 2))              ; PMEN2
  (setq #pt0$ (GetLWPolyLinePt #pmen2))               ; PMEN2 外形領域
  (setq #pt0$ (GetPtSeries #base #pt0$))              ; #base を先頭に時計周り

  (if (= (length &Base$)(length &corner$))
    (progn ; ｺｰﾅｰｷｬﾋﾞしかない 00/07/19 YM ADD
      (setq #W1 (distance (nth 0 #pt0$) (last  #pt0$)))   ; ｺｰﾅｰｺﾝﾛ側寸法Ｗ 頂点数7 OK!
      (setq #W2 (distance (nth 0 #pt0$) (nth 1 #pt0$)))   ; ｺｰﾅｰｼﾝｸ側寸法Ｗ 頂点数7 OK!
      (setq #num$ (list #W1 #W2))
    )
    (progn
      ;;; ﾍﾞｰｽｷｬﾋﾞが、ｼﾝｸ,ｺﾝﾛのどの側か振り分ける
      (foreach #sym &Base$
        (setq #skk$ (CFGetSymSKKCode #sym nil))
        (if (/= (nth 2 #skk$) CG_SKK_THR_CNR)             ; ｺｰﾅｰｷｬﾋﾞかどうかの判定
          (progn ; ｺｰﾅｰｷｬﾋﾞでない
            (setq #base (cdr (assoc 10 (entget #sym))))   ; ｼﾝﾎﾞﾙ基点
            (setq #lr (CFArea_rl (nth 3 #pt0$) (nth 2 #pt0$) #base)) ; 頂点数7 OK!
            (if (= #lr -1) ; 右かどうか
              (setq #baseR$ (append #baseR$ (list #sym)))
              (setq #baseL$ (append #baseL$ (list #sym)))
            );_if
          )
        );_if
      )
      (setq #W1 (distance (nth 0 #pt0$) (last  #pt0$)))   ; ｺｰﾅｰｺﾝﾛ側寸法Ｗ 頂点数7 OK!
      (setq #W2 (distance (nth 0 #pt0$) (nth 1 #pt0$)))   ; ｺｰﾅｰｼﾝｸ側寸法Ｗ 頂点数7 OK!

      (if #baseR$ ;00/08/25 SN ADD ｺｰﾅｰから右が無い時は処理しない
      (setq #numR$  (PKWTCabDim_I #baseR$))
      )
      (if #baseL$ ;00/08/25 SN ADD ｺｰﾅｰから左が無い時は処理しない
      (setq #numL$  (PKWTCabDim_I #baseL$))
      )
      (cond
        ((= &flg 0)
          (setq #num$ (append (list #W2) #numL$))
        )
        ((= &flg 1)
          (setq #num$ (append #numR$ (list #W1)))
        )

        ((= &flg 999)
          (setq #num$ (append #numR$ (list #W1 #W2) #numL$))
        )
      );_cond
    )
  );_if

;;; (setq #numR$ (car  #ret$)) ; 寸法Ｗ数列
;;; (setq #LENR  (cadr #ret$)) ; 全長
;;; (setq #numR$ (append #numR$ (list #W1))) ; 全長なし
;;; (setq #numL$ (car  #ret$)) ; 寸法Ｗ数列
;;; (setq #LENL  (cadr #ret$)) ; 全長
;;; (setq #numL$ (append (list #W2) #numL$)) ; 全長なし
;;; (append #numR$ #numL$ (list #LENR #LENL)) ; 末尾に左側全長,右側全長
;;; (append #numR$ #numL$)
  #num$
);PKWTCabDim_L

;;;<HOM>*************************************************************************
;;; <関数名>    : PKWTCabDim_U
;;; <処理概要>  : ｷｬﾋﾞﾈｯﾄ寸法Ｗ数列を返す(U型)
;;; <戻り値>    : 寸法数列ﾘｽﾄ(左から)全長含まず
;;; <作成>      : 05/19 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKWTCabDim_U (
  &Base$    ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形
  &corner$  ; ｺｰﾅｰｷｬﾋﾞﾘｽﾄ
  &flg      ; 0:ｼﾝｸ側 1:ｺﾝﾛ側 2:その他側
  /
  #BASE #BASE1 #BASE2 #BASEL$ #BASEO$ #BASER$
  #CORNER1 #CORNER2
  #DUM #LENL #LENO #LENR #LR
  #NUML$ #NUMO$ #NUMR$ #PMEN2 #PMEN2-1 #PMEN2-2
  #PT1$ #PT2$ #PT3$ #RET$ #SKK$
  #W1 #W2 #W3 #W4 #num$
  )
  (setq #corner1 (car &corner$))                      ; ｺｰﾅｰｷｬﾋﾞｼﾝﾎﾞﾙ図形1(仮)
  (setq #base1 (cdr (assoc 10 (entget #corner1))))    ; ｼﾝﾎﾞﾙ基点1
  (setq #pmen2-1 (PKGetPMEN_NO #corner1 2))           ; PMEN2(ｺｰﾅｰ1)
  (setq #pt1$ (GetLWPolyLinePt #pmen2-1))             ; PMEN2 外形領域(ｺｰﾅｰ1)
  (setq #pt1$ (GetPtSeries #base1 #pt1$))             ; #base を先頭に時計周り(ｺｰﾅｰ1)

  (setq #corner2 (cadr &corner$))                     ; ｺｰﾅｰｷｬﾋﾞｼﾝﾎﾞﾙ図形2(仮)
  (setq #base2 (cdr (assoc 10 (entget #corner2))))    ; ｼﾝﾎﾞﾙ基点2
  (setq #pmen2-2 (PKGetPMEN_NO #corner2 2))           ; PMEN2(ｺｰﾅｰ2)
  (setq #pt2$ (GetLWPolyLinePt #pmen2-2))             ; PMEN2 外形領域(ｺｰﾅｰ2)
  (setq #pt2$ (GetPtSeries #base2 #pt2$))             ; #base を先頭に時計周り(ｺｰﾅｰ2)

  (setq #lr (CFArea_rl (nth 0 #pt1$) (nth 3 #pt1$) #base2)) ; ｺｰﾅｰ2が、ｺｰﾅｰ1対角線のどちら側か判断
  (if (= #lr 1)
    (progn ; 左側であった場合、ｺｰﾅｰｷｬﾋﾞ1(仮)が実はｺｰﾅｰｷｬﾋﾞ2だったので外形点列を入れ替え
      (setq #dum #pt1$)
      (setq #pt1$ #pt2$)
      (setq #pt2$ #dum)
    )
  );_if
  (setq #pt3$ (append (list (car #pt2$))(reverse (cdr #pt2$))))

;;; この時点でｺｰﾅｰ1,2確定
;;; ﾍﾞｰｽｷｬﾋﾞが、ｼﾝｸ,ｺﾝﾛ,その他のどの側か振り分ける
  (foreach #sym &Base$
    (setq #skk$ (CFGetSymSKKCode #sym nil))
    (if (/= (nth 2 #skk$) CG_SKK_THR_CNR)                ; ｺｰﾅｰｷｬﾋﾞかどうかの判定
      (progn ; ｺｰﾅｰｷｬﾋﾞでない
        (setq #base (cdr (assoc 10 (entget #sym))))      ; ｼﾝﾎﾞﾙ基点
        (setq #lr (CFArea_rl (nth 3 #pt1$) (nth 2 #pt1$) #base)) ; 頂点7 OK!
        (if (= #lr 1) ; 左
          (setq #baseL$ (append #baseL$ (list #sym)))    ; 左側であった場合 ｼﾝｸ側にあるｷｬﾋﾞである
          (progn ; それ以外
            (setq #lr (CFArea_rl (nth 3 #pt3$) (nth 2 #pt3$) #base)) ; ｺｰﾅｰｷｬﾋﾞ2で判断 頂点7 OK!
            (if (= #lr -1) ; 右
              (setq #baseO$ (append #baseO$ (list #sym))); 右側であった場合 その他側にあるｷｬﾋﾞである
              (setq #baseR$ (append #baseR$ (list #sym))); 右側であった場合 ｺﾝﾛ側にあるｷｬﾋﾞである
            );_if
          )
        );_if
      )
    );_if
  )

  (setq #W1 (distance (nth 0 #pt2$) (last  #pt2$))) ; ｺｰﾅｰ2その他側寸法Ｗ
  (setq #W2 (distance (nth 0 #pt2$) (nth 1 #pt2$))) ; ｺｰﾅｰ2ｺﾝﾛ側   寸法Ｗ
  (setq #W3 (distance (nth 0 #pt1$) (last  #pt1$))) ; ｺｰﾅｰ1ｺﾝﾛ側   寸法Ｗ
  (setq #W4 (distance (nth 0 #pt1$) (nth 1 #pt1$))) ; ｺｰﾅｰ1ｼﾝｸ側   寸法Ｗ

  (setq #numO$  (PKWTCabDim_I #baseO$))
  (setq #numR$  (PKWTCabDim_I #baseR$))
  (setq #numL$  (PKWTCabDim_I #baseL$))

  (cond
    ((= &flg 0)
      (setq #num$ (append (list #W4) #numL$))
    )
    ((= &flg 1)
      (setq #num$ (append (list #W2) #numR$ (list #W3)))
    )
    ((= &flg 2)
      (setq #num$ (append #numO$ (list #W1)))
    )
  );_cond

;;; (setq #numO$ (car  #ret$)) ; 寸法Ｗ数列
;;; (setq #LENO  (cadr #ret$)) ; 全長
;;; (setq #LENO  (+ #LENO #W1))
;;; (setq #numO$ (append #numO$ (list #W1 #LENO))) ; 全長追加
;;; (setq #numO$ (append #numO$ (list #W1))) ; 全長なし

;;; (setq #numR$ (car  #ret$)) ; 寸法Ｗ数列
;;; (setq #LENR  (cadr #ret$)) ; 全長
;;; (setq #LENR  (+ #LENR #W2 #W3))
;;; (setq #numR$ (append (list #W2) #numR$ (list #W3 #LENR))) ; 全長追加
;;; (setq #numR$ (append (list #W2) #numR$ (list #W3))) ; 全長なし

;;; (setq #numL$ (car  #ret$)) ; 寸法Ｗ数列
;;; (setq #LENL  (cadr #ret$)) ; 全長
;;; (setq #LENL  (+ #LENL #W4))
;;; (setq #numL$ (append (list #W4) #numL$ (list #LENL))) ; 全長追加
;;; (setq #numL$ (append (list #W4) #numL$)) ; 全長なし

;;; (append #numO$ #numR$ #numL$ (list #LENO #LENR #LENL)) ; 末尾に全長をつける
;;; (append #numO$ #numR$ #numL$)
  #num$
);PKWTCabDim_U

;<HOM>*************************************************************************
; <関数名>    : PKGetWTSSFromWTEN
; <処理概要>  : ﾜｰｸﾄｯﾌﾟ図形--->関連WT選択ｾｯﾄ
; <戻り値>    : 選択ｾｯﾄ
; <作成>      : 00/05/18 YM
; <備考>      :
;*************************************************************************>MOH<
(defun PKGetWTSSFromWTEN (
  &enWT  ;WT図形名
  /
  #SS #WTL #WTR #WTXD$ #WTXD0$
  )
  (setq #ss (ssadd))
  (ssadd &enWT #ss)
  (setq #wtxd$ (CFGetXData &enWT "G_WRKT"))
  (if #wtxd$
    (progn
      ;;; ｶｯﾄ相手左
      (setq #WTL (nth 47 #wtxd$))    ; 左WT図形ﾊﾝﾄﾞﾙ
      (while (and #WTL (/= #WTL "")) ; 左にWTがあれば
        (ssadd #WTL #ss)
        (setq #wtxd0$ (CFGetXData #WTL "G_WRKT"))
        (setq #WTL (nth 47 #wtxd0$))     ; 更に左にあるか
        (if (= #WTL "") (setq #WTL nil)) ; なかったら nil
      )
      ;;; ｶｯﾄ相手右
      (setq #WTR (nth 48 #wtxd$))    ; 右WT図形ﾊﾝﾄﾞﾙ
      (while (and #WTR (/= #WTR "")) ; 右にWTがあれば
        (ssadd #WTR #ss)
        (setq #wtxd0$ (CFGetXData #WTR "G_WRKT"))
        (setq #WTR (nth 48 #wtxd0$))     ; 更に右にあるか
        (if (= #WTR "") (setq #WTR nil)) ; なかったら nil
      )
    )
    (progn
      (CFAlertMsg "ワークトップではありません。\n PKGetWTSSFromWTEN")
      (quit)
    )
  );_if
  #ss
);PKGetWTSSFromWTEN

;<HOM>*************************************************************************
; <関数名>    : PK_WTSStoPlPt
; <処理概要>  : ﾜｰｸﾄｯﾌﾟ図形選択ｾｯﾄを渡して、その外形点列を戻す
; <戻り値>    : 外形点列(末尾に始点を追加)
; <作成>      : 00/05/16 YM ADD
; <備考>      :
;*************************************************************************>MOH<
(defun PK_WTSStoPlPt (
  &ss  ;WT選択ｾｯﾄ
  /
  #I #PT$ #R-SS #SS #TEI #WT #XD$
  )
  (setq #i 0)
  (setq #ss (ssadd))
  (repeat (sslength &ss)
    (setq #WT (ssname &ss #i))
    (setq #xd$ (CFGetXData #WT "G_WRKT"))
    (setq #tei (nth 38 #xd$))
    (entmake (entget #tei))
    (command "._region" (entlast) "")
    (ssadd (entlast) #ss)
    (setq #i (1+ #i))
  )
  (if (> (sslength #ss) 1)(command "._union" #ss ""))
  ;// REGIONを分解し、分解した線分をポリライン化する
  (command "_explode" (entlast))
  (setq #r-ss (ssget "P"))
  (command "_pedit" (entlast) "Y" "J" #r-ss "" "X") ; "X" ﾎﾟﾘﾗｲﾝの選択を終了

  (setq #pt$ (GetLWPolyLinePt (entlast)))
  (entdel (entlast))
  (setq #pt$ (append #pt$ (list (car #pt$))))
);PK_WTSStoPlPt

;<HOM>*************************************************************************
; <関数名>    : PKDelWkTopONE
; <処理概要>  : 引数WTとそのｼﾝｸ,水栓,BG,底面のみを削除(関連WTは削除しない)
; <戻り値>    :
; <作成>      : 2000-05-08 YM
; <備考>      :
;*************************************************************************>MOH<
(defun PKDelWkTopONE (
  &wtEn ;(ENAME)ﾜｰｸﾄｯﾌﾟ図形(ﾊﾞｯｸｶﾞｰﾄﾞ図形のこともあり)
  /
  #SS #WTEN #XD$ #XD_WT
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKDelWkTopONE ////")
  (CFOutStateLog 1 1 " ")
  ;// 色替え確認
  (setq #ss (PCW_ChColWTItemSSret &wtEn CG_InfoSymCol)) ; ｼﾝｸがあれば一緒に取る 04/25 YM
  (command "_.erase" #ss "") ; 削除処理
  (princ)
)
;PKDelWkTopONE

; <HOM>***********************************************************************************
; <関数名>    : DelAppXdata
; <処理概要>  : 図形名 &en の拡張ﾃﾞｰﾀ(APP名 &app)を消去する
; <戻り値>    : なし
; <作成>      : 2000-05-11
; <作成者>    : 05/11 YM
; <備考>      :
; ***********************************************************************************>MOH<
(defun DelAppXdata (
  &en
  &app
  /
  #xd$ #xd0$ #EN #ET
  )

  (setq #xd0$ '())
  (setq #et (entget &en '("*")))
  (setq #xd$ (assoc -3 #et))
  (foreach #elm #xd$
    (if (= (type #elm) 'LIST)
      (progn
        (if (/= (car #elm) &app)
          (setq #xd0$ (append #xd0$ (list #elm)))
          (setq #xd0$ (append #xd0$ (list (list &app))))
        )
      )
      (setq #xd0$ (append #xd0$ (list #elm)))
    );_if
  )
  (entmod (subst #xd0$ #xd$ #et))
  (princ)
);DelAppXdata

;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_VAL_MINMAX
;;; <処理概要>  : 実数値のリストから最大,最小値を求める
;;; <引数>      : リスト
;;; <戻り値>    : (max,min)
;;; <作成>      :     2000.1.25 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun CMN_VAL_MINMAX (
  &lis
  /
  #i #elm #min #max
  )

  (setq #min 1.0e+10)
  (setq #max 1.0e-10)
  (setq #i 0)
  (repeat (length &lis)
    (setq #elm (nth #i &lis))

    (if (<= #elm #min)
        (setq #min #elm)
    )

    (if (>= #elm #max)
        (setq #max #elm)
    )

    (setq #i (1+ #i))
  );_(repeat (length &lis)

  (list #max #min)

)

;<HOM>*************************************************************************
; <関数名>     : PKGetPMEN_NO
; <処理概要>   : ｼﾝｸｼﾝﾎﾞﾙ図形,PMEN番号を渡してPMEN(&NO)図形名を得る
; <戻り値>     : PMEN(&NO)図形名
; <作成>       : 00/05/04 YM
; <備考>       :
;*************************************************************************>MOH<
(defun PKGetPMEN_NO (
  &scab-en   ;(ENAME)ｷｬﾋﾞｼﾝﾎﾞﾙ図形
  &NO        ;PMEN の番号
  /
  #EN #I #MSG #PMEN #S-XD$ #SS #XD$ #LOOP #NAME
  )
  (cond
    ((= &NO 1)(setq #NAME "(隠線領域)"))
    ((= &NO 2)(setq #NAME "(外形領域)"))
    ((= &NO 3)(setq #NAME "(特殊ｶｳﾝﾀｰ領域)"))
    ((= &NO 4)(setq #NAME "(ｼﾝｸ穴領域)"))
    ((= &NO 5)(setq #NAME "(ｺﾝﾛ穴領域)"))
    ((= &NO 6)(setq #NAME "(干渉ﾁｪｯｸ領域)"))
    ((= &NO 7)(setq #NAME "(正面用扉領域)"))
    ((= &NO 8)(setq #NAME "(ｼﾝｸ取付領域)"))
    (T (setq #NAME ""))
  );_cond
  (setq #ss (CFGetSameGroupSS &scab-en))
  (setq #i 0)
  (setq #loop T #pmen nil)
  (while (and #loop (< #i (sslength #ss)))
    (setq #en (ssname #ss #i)) ; ｼﾝｸｷｬﾋﾞの同一ｸﾞﾙｰﾌﾟ
    (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
    (if #xd$
      (progn
        (if (= &NO (car #xd$))
          (progn
            (setq #pmen #en)
            (setq #loop nil)
          )
        );_if
      );_(progn
    );_(if
    (setq #i (1+ #i))
  )
  (if (= #pmen nil)
;-- 2011/09/13 A.Satoh Add - S
    (if (/= &NO 8)
;-- 2011/09/13 A.Satoh Add - E
    (progn
      (setq #s-xd$ (CFGetXData &scab-en "G_LSYM")) ; ｼﾝｸｷｬﾋﾞﾈｯﾄ拡張ﾃﾞｰﾀ
;-- 2011/10/21 A.Satoh Add - S
			(if (/= (nth 9 #s-xd$) 110)
				(progn
;-- 2011/10/21 A.Satoh Add - E
      (setq #msg
        (strcat "品番名称: " (nth 5 #s-xd$) " に、P面" (itoa &NO) #NAME "がありません。")
      )
      (CFOutStateLog 0 5 #msg)
      (CFAlertMsg #msg)
      (if (/= &NO 2) ; PMEN2のときはPMEN2を作成するのでエラーにしない
        (*error*)
      );_if
;-- 2011/10/21 A.Satoh Add - S
				)
			)
;-- 2011/10/21 A.Satoh Add - E
    )
;-- 2011/09/13 A.Satoh Add - S
    )
;-- 2011/09/13 A.Satoh Add - E
  )
  #pmen ; PMEN がないときはnil を返す
);PKGetPMEN_NO

;<HOM>*************************************************************************
; <関数名>     : PKGetFstPMEN
; <処理概要>   : ｼﾝﾎﾞﾙ図形,PMEN番号を渡して最初に見つかったPMEN(&NO)図形名取得
;                なければnil
; <戻り値>     : PMEN(&NO)図形名 or nil
; <作成>       : 01/08/28 YM
; <備考>       :
;*************************************************************************>MOH<
(defun PKGetFstPMEN (
  &sym ;(ENAME)ｷｬﾋﾞｼﾝﾎﾞﾙ図形
  &NO  ;PMEN の番号
  /
  #EN #I #LOOP #PMEN #SS #XD$
  )
  (setq #ss (CFGetSameGroupSS &sym))
  (setq #i 0)
  (setq #loop T #pmen nil)
  (while (and #loop (< #i (sslength #ss)))
    (setq #en (ssname #ss #i))
    (if (setq #xd$ (CFGetXData #en "G_PMEN"))
      (if (= &NO (car #xd$))
        (setq #pmen #en #loop nil)
      );_if
    );_if
    (setq #i (1+ #i))
  )
  #pmen ; PMEN がないときはnil を返す
);PKGetFstPMEN

;<HOM>*************************************************************************
; <関数名>     : PKGetPMEN_NO_ALL
; <処理概要>   : ｼﾝﾎﾞﾙ図形,PMEN番号を渡してPMEN(&NO)図形名(すべて)を得る
; <戻り値>     : PMEN(&NO)図形名ﾘｽﾄ
; <作成>       : 00/05/04 YM
; <備考>       :
;*************************************************************************>MOH<
(defun PKGetPMEN_NO_ALL (
  &scab-en   ;(ENAME)ｷｬﾋﾞｼﾝﾎﾞﾙ図形
  &NO        ;PMEN の番号
  /
  #EN #I #MSG #PMEN$ #S-XD$ #SS #XD$ #LOOP #NAME
  )
  (cond
    ((= &NO 1)(setq #NAME "(隠線領域)"))
    ((= &NO 2)(setq #NAME "(外形領域)"))
    ((= &NO 3)(setq #NAME "(特殊ｶｳﾝﾀｰ領域)"))
    ((= &NO 4)(setq #NAME "(ｼﾝｸ穴領域)"))
    ((= &NO 5)(setq #NAME "(ｺﾝﾛ穴領域)"))
    ((= &NO 6)(setq #NAME "(干渉ﾁｪｯｸ領域)"))
    ((= &NO 7)(setq #NAME "(正面用扉領域)"))
    ((= &NO 8)(setq #NAME "(ｼﾝｸ取付領域)"))
    (T (setq #NAME ""))
  );_cond
  (setq #ss (CFGetSameGroupSS &scab-en))
  (setq #i 0)
  (setq #pmen$ nil)
  (while (< #i (sslength #ss))
    (setq #en (ssname #ss #i)) ; ｼﾝｸｷｬﾋﾞの同一ｸﾞﾙｰﾌﾟ
    (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN拡張ﾃﾞｰﾀ
    (if #xd$
      (if (= &NO (car #xd$))
        (setq #pmen$ (append #pmen$ (list #en)))
      );_if
    );_if
    (setq #i (1+ #i))
  )
  (if (= #pmen$ nil)
    (progn
      (setq #s-xd$ (CFGetXData &scab-en "G_LSYM")) ; ｼﾝｸｷｬﾋﾞﾈｯﾄ拡張ﾃﾞｰﾀ
;-- 2011/10/21 A.Satoh Add - S
			(if (/= (nth 9 #s-xd$) 110)
				(progn
;-- 2011/10/21 A.Satoh Add - E
      (setq #msg
        (strcat "品番名称: " (nth 5 #s-xd$) " に、P面" (itoa &NO) #NAME "がありません。")
      )
      (CFOutStateLog 0 5 #msg)
      (CFAlertMsg #msg)
      (if (/= &NO 2) ; PMEN2のときはPMEN2を作成するのでエラーにしない
        (*error*)
      );_if
;-- 2011/10/21 A.Satoh Add - S
				)
			)
;-- 2011/10/21 A.Satoh Add - E
    )
  )
  #pmen$ ; PMEN がないときはnil を返す
);PKGetPMEN_NO_ALL

;<HOM>*************************************************************************
; <関数名>     : PKGetPLIN_NO
; <処理概要>   : ｼﾝﾎﾞﾙ図形,PLIN番号を渡してPLIN(&NO)図形名を得る
; <戻り値>     : PLIN(&NO)図形名
; <作成>       : 00/12/05 YM
; <備考>       :
;*************************************************************************>MOH<
(defun PKGetPLIN_NO (
  &scab-en   ;(ENAME)ｷｬﾋﾞｼﾝﾎﾞﾙ図形
  &NO        ;PLIN の番号
  /
  #EN #I #MSG #PLIN #S-XD$ #SS #XD$ #LOOP
  )

  (setq #ss (CFGetSameGroupSS &scab-en))
  (setq #i 0)
  (setq #loop T #plin nil)
  (while (and #loop (< #i (sslength #ss)))
    (setq #en (ssname #ss #i)) ; ｷｬﾋﾞの同一ｸﾞﾙｰﾌﾟ
    (setq #xd$ (CFGetXData #en "G_PLIN")) ; G_PLIN拡張ﾃﾞｰﾀ
    (if #xd$
      (progn
        (if (= &NO (car #xd$))
          (progn
            (setq #plin #en)
            (setq #loop nil)
          )
        );_if
      );_(progn
    );_(if
    (setq #i (1+ #i))
  )
;;;01/08/22YM@  (if (= #plin nil)
;;;01/08/22YM@    (progn
;;;01/08/22YM@      (setq #s-xd$ (CFGetXData &scab-en "G_LSYM"))
;;;01/08/22YM@      (setq #msg
;;;01/08/22YM@        (strcat "キャビネット 品番名称 : " (nth 5 #s-xd$) " に、\nP線" (itoa &NO) "がありません。\nPKGetPLIN_NO"))
;;;01/08/22YM@      (CFOutStateLog 0 5 #msg)
;;;01/08/22YM@      (CFAlertMsg #msg)
;;;01/08/22YM@    )
;;;01/08/22YM@  );_if
  #plin
);PKGetPLIN_NO

;<HOM>*************************************************************************
; <関数名>     : PKGetPTEN_NO
; <処理概要>   : ｼﾝｸｼﾝﾎﾞﾙ図形,PTEN番号を渡してPTEN(&NO)図形名を得る
; <戻り値>     : ((PTEN図形名,G_PTEN),...) ﾘｽﾄのﾘｽﾄ
; <作成>       : 00/05/04 YM
; <備考>       :
;*************************************************************************>MOH<
(defun PKGetPTEN_NO (
  &snk-en   ;(ENAME)ｼﾝｸｼﾝﾎﾞﾙ図形
  &NO        ;PTEN の番号
  /
  #EN #I #MSG #PTEN$ #S-XD$ #SS #XD$
  )

  (setq #ss (CFGetSameGroupSS &snk-en))
  (setq #i 0 #pten$ '())
  (repeat (sslength #ss)
    (setq #en (ssname #ss #i)) ; ｼﾝｸｷｬﾋﾞの同一ｸﾞﾙｰﾌﾟ
    (setq #xd$ (CFGetXData #en "G_PTEN")) ; G_TMEN拡張ﾃﾞｰﾀ
    (if #xd$
      (progn
        (if (= &NO (car #xd$))   ; CG_PSINKTYPE = 8 ｼﾝｸ取り付け領域
          (setq #pten$ (append #pten$ (list (list #en #xd$))))
        )
      );_(progn
    );_(if
    (setq #i (1+ #i))
  )
  (if (= #pten$ nil)
    (progn
      (setq #s-xd$ (CFGetXData &snk-en "G_LSYM")) ; ｼﾝｸｷｬﾋﾞﾈｯﾄ拡張ﾃﾞｰﾀ
      (setq #msg
        (strcat "キャビネット 品番名称 : " (nth 5 #s-xd$) " に\nP点" (itoa &NO) "がありません。\n \nPKGetPTEN_NO"))
      (CFOutStateLog 0 5 #msg)
      (CFAlertMsg #msg)
      (*error*)
    )
  )
  #pten$
);PKGetPTEN_NO

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetWTSymCP
;;; <処理概要>  : 領域点列ﾘｽﾄを渡して領域に含まれるＷＴを検索する
;;; <戻り値>    : WT図形名ﾘｽﾄ
;;; <作成>      : 2000.5.9 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;*************************************************************************>MOH<
(defun PKGetWTSymCP (
  &pt$
  /
  #I #SS #SYM #SYM$
  )
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_WRKT"))))) ; 領域内のG_WRKT
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i))                  ; 領域内の各ｼﾝﾎﾞﾙ
            (setq #sym$ (append #sym$ (list #sym)))      ; ｺﾝﾛのｼﾝﾎﾞﾙ図形名
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if
  #sym$ ; ｼﾝｸ,水栓ｼﾝﾎﾞﾙ図形ﾘｽﾄ
);GetGasSym

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetHinbanSSCP
;;; <処理概要>  : 領域点列ﾘｽﾄを渡して領域に含まれる、ｼﾝｸｻﾎﾟｰﾄｼｽﾃﾑを検索する
;;; <戻り値>    : ｼﾝｸｻﾎﾟｰﾄｼｽﾃﾑｸﾞﾙｰﾌﾟ選択ｾｯﾄ
;;; <作成>      : 2000.5.22 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;*************************************************************************>MOH<
(defun PKGetHinbanSSCP (
  &pt$
  &HINBAN ; ワイルドカード文字っを含む品番名称
  /
  #HIN #I #SS #SYM #RES_SS
  )
  (setq #res_ss nil)
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; 領域内の各ｼﾝﾎﾞﾙ
            (setq #hin (nth 5 (CFGetXData #sym "G_LSYM"))) ; 品番図形
            (if (= #hin &HINBAN)
              (setq #res_ss (CFGetSameGroupSS #sym))
            );_if
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if

  #res_ss ; ｼﾝｸｻﾎﾟｰﾄｼｽﾃﾑｸﾞﾙｰﾌﾟ選択ｾｯﾄ
);PKGetHinbanSSCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetSinkSuisenSymCP
;;; <処理概要>  : 領域点列ﾘｽﾄを渡して領域に含まれる、シンク,水栓を検索する
;;; <戻り値>    :
;;; <作成>      : 2000.5.9 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;*************************************************************************>MOH<
(defun PKGetSinkSuisenSymCP (
  &pt$
  /
  #I #SS #SYM #SYM$
  )
  (setq #ss    (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; 領域内の各ｼﾝﾎﾞﾙ
            (if (or (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_SNK)  ; 性格ｺｰﾄﾞ1桁 CG_SKK_ONE_SNK = 4(ｼﾝｸ)
                    (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_WTR)) ; 性格ｺｰﾄﾞ1桁 CG_SKK_ONE_WTR = 5(水栓)
              (setq #sym$ (append #sym$ (list #sym))) ; 挿入点
            );_if
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if
  #sym$
);PKGetSinkSuisenSymCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetG_WTRCP
;;; <処理概要>  : 領域点列ﾘｽﾄを渡して領域に含まれる、"G_WTR"を検索する
;;; <戻り値>    :
;;; <作成>      : 2000.7.22 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;*************************************************************************>MOH<
(defun PKGetG_WTRCP ( &pt$ / #ss )
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_WTR")))))  ; 領域内のG_WTR図形
  (CMN_ss_to_en #ss); 水栓穴G_WTR図形ﾘｽﾄ or nil
);PKGetG_WTRCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetSinkSymBySinkCabCP
;;; <処理概要>  : ｼﾝｸｷｬﾋﾞ領域に含まれるｼﾝｸを検索する
;;; <戻り値>    : ｼﾝｸｼﾝﾎﾞﾙ図形名
;;; <作成>      : 2000.6.27 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;*************************************************************************>MOH<
(defun PKGetSinkSymBySinkCabCP (
  &scab-en ; ｼﾝｸｷｬﾋﾞｼﾝﾎﾞﾙ図形
  /
  #I #PMEN2 #PTA$ #RET #SS #SYM #LOOP
  )
  ;2011/04/07 YM ADD
  (setq #PD (getvar "pdmode"))
  (setq #PDS (getvar "PDSIZE"))
  (setvar "pdmode" 34)
  (setvar "pdsize" 20)


  (setq #pmen2 (PKGetPMEN_NO &scab-en 2))   ; ｼﾝｸｷｬﾋﾞPMEN2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 &scab-en))   ; PMEN2 を作成
  );_if
  (setq #ptA$ (GetLWPolyLinePt #pmen2))     ; ｼﾝｸｷｬﾋﾞPMEN2 外形領域
  (setq #ptA$ (AddPtList #ptA$))            ; 末尾に始点を追加する
  (setq #ss (ssget "CP" #ptA$ (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
  (setq #i 0 #loop T #ret nil)
  (if #ss
    (if (> (sslength #ss) 0)
      (while (and #loop (< #i (sslength #ss)))
        (setq #sym (ssname #ss #i)) ; 領域内の各ｼﾝﾎﾞﾙ
        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_SNK)  ; 性格ｺｰﾄﾞ1桁 CG_SKK_ONE_SNK = 4(ｼﾝｸ)
          (setq #ret #sym #loop nil)
        );_if
        (setq #i (1+ #i))
      )
    );_if
  );_if

  (setvar "pdmode" #PD)
  (setvar "pdsize" #PDS)

  #ret ; ｼﾝｸｼﾝﾎﾞﾙ図形 or nil
);PKGetSinkSymBySinkCabCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetSuisenSymBySinkCabCP
;;; <処理概要>  : ｼﾝｸｷｬﾋﾞ領域に含まれる水栓を検索する
;;; <戻り値>    : 水栓ｼﾝﾎﾞﾙ図形名ﾘｽﾄ
;;; <作成>      : 2000.7.6 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;*************************************************************************>MOH<
(defun PKGetSuisenSymBySinkCabCP (
  &scab-en ; ｼﾝｸｷｬﾋﾞｼﾝﾎﾞﾙ図形
  /
  #PMEN2 #PTA$ #RET$ #SS
  )
  (setq #pmen2 (PKGetPMEN_NO &scab-en 2))   ; ｼﾝｸｷｬﾋﾞPMEN2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 &scab-en))   ; PMEN2 を作成
  );_if
  (setq #ptA$ (GetLWPolyLinePt #pmen2))     ; ｼﾝｸｷｬﾋﾞPMEN2 外形領域
  (setq #ptA$ (AddPtList #ptA$))            ; 末尾に始点を追加する
  (setq #ss (ssget "CP" #ptA$ (list (list -3 (list "G_WTR"))))) ; 領域内のｼﾝﾎﾞﾙ図形
  (setq #ret$ (CMN_ss_to_en #ss)); 水栓ｼﾝﾎﾞﾙ図形 or nil
);PKGetSuisenSymBySinkCabCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetGasSymByGasCabCP
;;; <処理概要>  : ｺﾝﾛｷｬﾋﾞ領域に含まれるｺﾝﾛを検索する
;;; <戻り値>    : ｺﾝﾛｼﾝﾎﾞﾙ図形名
;;; <作成>      : 2000.6.27 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;*************************************************************************>MOH<
(defun PKGetGasSymByGasCabCP (
  &scab-en ; ｺﾝﾛｷｬﾋﾞｼﾝﾎﾞﾙ図形
  /
  #I #LOOP #PMEN2 #PTA$ #RET #SS #SYM
  )
  (setq #pmen2 (PKGetPMEN_NO &scab-en 2))   ; ｺﾝﾛｷｬﾋﾞPMEN2
  (if (= #pmen2 nil)
    (setq #pmen2 (PK_MakePMEN2 &scab-en))   ; PMEN2 を作成
  );_if
  (setq #ptA$ (GetLWPolyLinePt #pmen2))     ; ｺﾝﾛｷｬﾋﾞPMEN2 外形領域
  (setq #ptA$ (AddPtList #ptA$))            ; 末尾に始点を追加する
  (setq #ss (ssget "CP" #ptA$ (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
  (setq #i 0 #loop T #ret nil)
  (if #ss
    (if (> (sslength #ss) 0)
      (while (and #loop (< #i (sslength #ss)))
        (setq #sym (ssname #ss #i)) ; 領域内の各ｼﾝﾎﾞﾙ
        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_GAS)  ; 性格ｺｰﾄﾞ1桁 CG_SKK_ONE_GAS = 2(ｺﾝﾛ)
          (setq #ret #sym #loop nil)
        );_if
        (setq #i (1+ #i))
      )
    );_if
  );_if

  #ret ; ｺﾝﾛｼﾝﾎﾞﾙ図形 or nil
);PKGetGasSymByGasCabCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetSymBySKKCodeCP
;;; <処理概要>  : 領域点列ﾘｽﾄ,性格ｺｰﾄﾞを渡して領域内のｼﾝﾎﾞﾙ図形名ﾘｽﾄを返す
;;; <戻り値>    :
;;; <作成>      : 2000.5.9 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;*************************************************************************>MOH<
(defun PKGetSymBySKKCodeCP (
  &pt$
  &SKK
  /
  #I #SKK #SS #SYM #SYM$
  )
  ;2011/04/07 YM ADD
  (setq #PD (getvar "pdmode"))
  (setq #PDS (getvar "PDSIZE"))
  (setvar "pdmode" 34)
  (setvar "pdsize" 20)
  (command "_.layer" "ON" "N_SYMBOL" "")

  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; 領域内の各ｼﾝﾎﾞﾙ
            (setq #skk (nth 9 (CFGetXData #sym "G_LSYM")))
            (if (= #skk &SKK) ; 性格ｺｰﾄﾞ &SKK
              (setq #sym$ (append #sym$ (list #sym))) ; 挿入点
            )
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if

  (setvar "pdmode" #PD)
  (setvar "pdsize" #PDS)

  #sym$ ; ｼﾝﾎﾞﾙ図形ﾘｽﾄ
);PKGetSymBySKKCodeCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetSymBySKKCodeCP2
;;; <処理概要>  : WT外形領域点列ﾘｽﾄ(WT左上点を始点とし、時計周り)を渡して
;;;               領域内のｺﾝﾛｷｬﾋﾞ図形名ﾘｽﾄを返す
;;; <戻り値>    :
;;; <作成>      : 2000.9.6 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;               ｺﾝﾛｷｬﾋﾞ取得専用(PKGetSymBySKKCodeCPだと段差ｺﾝﾛｷｬﾋﾞが取れてしまう)
;;;*************************************************************************>MOH<
(defun PKGetSymBySKKCodeCP2 (
  &pt$
  /
  #I #RU_PT #SKK #SS #SYM #SYM$ #SYM_PT
  )
;;; P---+----------------*--------+  * の段差部ﾛｰﾀｲﾌﾟｺﾝﾛｷｬﾋﾞを
;;; |   |                |        |    含めないようにする
;;; |   |   ﾚｷﾞｭﾗｰ部WT   | 段差部 |
;;; |   |                |        |
;;; |   |                |        |
;;; +---+----------------+--------+
  (setq #RU_PT (nth 1 &pt$))
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; 領域内の各ｼﾝﾎﾞﾙ
            (setq #sym_PT (cdr (assoc 10 (entget #sym)))) ; ｼﾝﾎﾞﾙ座標
            (setq #skk (nth 9 (CFGetXData #sym "G_LSYM")))
            (if (= #skk CG_SKK_INT_GCA) ; 性格ｺｰﾄﾞ &SKK ; 01/08/31 YM MOD 113-->ｸﾞﾛｰﾊﾞﾙ化
              (if (< (distance #sym_PT #RU_PT) 0.1)
                (princ) ; WT外形領域の右上隅と一致する場合は除外する
                (setq #sym$ (append #sym$ (list #sym))) ; 挿入点
              );_if
            );_if
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if
  #sym$ ; ｼﾝﾎﾞﾙ図形ﾘｽﾄ
);PKGetSymBySKKCodeCP2

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetBaseSymCP
;;; <処理概要>  : 領域点列ﾘｽﾄを渡して領域内のﾍﾞｰｽｷｬﾋﾞ(11?)ｼﾝﾎﾞﾙ図形名ﾘｽﾄを返す
;;; <戻り値>    :
;;; <作成>      : 2000.5.18 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;               取り付け高さ=0のものを取得
;;;*************************************************************************>MOH<
(defun PKGetBaseSymCP (
  &pt$
  /
  #I #SS #SYM #SYM$
  )
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
  (setq #i 0)
  (if #ss
    (progn
      (if (> (sslength #ss) 0)
        (progn
          (repeat (sslength #ss)
            (setq #sym (ssname #ss #i)) ; 領域内の各ｼﾝﾎﾞﾙ
            (if (or (and (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)  ; ｷｬﾋﾞ
                         (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS)) ; ﾍﾞｰｽ
                )
              (if (equal (nth 6 (CFGetXData #sym "G_SYM")) 0 0.01) ; 取り付け高さ
                (setq #sym$ (append #sym$ (list #sym))) ; 挿入点
              );_if
            );_if
            (setq #i (1+ #i))
          );_repeat
        )
      );_if
    )
  );_if
  #sym$ ; ｼﾝﾎﾞﾙ図形ﾘｽﾄ
);PKGetBaseSymCP

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetBaseSymCP_SYOKUSEN
;;; <処理概要>  : 領域点列ﾘｽﾄを渡して領域内のﾍﾞｰｽｷｬﾋﾞ(11?)で食洗"110"以外の
;;;               ｼﾝﾎﾞﾙ図形名ﾘｽﾄと食洗"110"のﾘｽﾄを返す
;;; <戻り値>    : ((110以外ｼﾝﾎﾞﾙ)(110ｼﾝﾎﾞﾙ))
;;; <作成>      : 01/01/31 YM
;;; <備考>      : 領域点列ﾘｽﾄは閉じている(始点=終点)ことが必要
;;;               ssget "CP"を使うため vpoint (0,0,1)～ zoom "P" が必要
;;;               取り付け高さ=0のものを取得
;;;*************************************************************************>MOH<
(defun PKGetBaseSymCP_SYOKUSEN (
  &pt$
  /
  #I #SS #SYM #SYM$ #SYM110$
#FIG$ #HIN #SKK #SYM_NEW$ ; 02/01/24 YM ADD
  )
  (setq #ss (ssget "CP" &pt$ (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
  (setq #i 0)
  (if (and #ss (> (sslength #ss) 0))
    (repeat (sslength #ss)
      (setq #sym (ssname #ss #i)) ; 領域内の各ｼﾝﾎﾞﾙ
      (if (and (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)  ; ｷｬﾋﾞ
               (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS)  ; ﾍﾞｰｽ
               (/= (CFGetSymSKKCode #sym 3) CG_SKK_THR_DIN)) ; ﾀﾞｲﾆﾝｸﾞ以外
        ; "1" "1" "7以外"のとき
        (if (= (CFGetSymSKKCode #sym 3) CG_SKK_THR_ETC)
          (setq #sym110$ (append #sym110$ (list #sym))) ; "110"
          (setq #sym$    (append #sym$    (list #sym))) ; "110"以外
        );_if
      );_if
      (setq #i (1+ #i))
    );_repeat
  );_if

  ; 02/01/24 YM ADD-S "113"で品番基本.品番ﾀｲﾌﾟ=2のときはSET標準をみる
  (setq #sym_new$ nil)
  (foreach #sym #sym$
    (setq #hin (nth 5 (CFGetXData #sym "G_LSYM"))) ; 品番
    (setq #skk (nth 9 (CFGetXData #sym "G_LSYM"))) ; 性格ｺｰﾄﾞ
    (if (= #skk CG_SKK_INT_GCA) ; 性格ｺｰﾄﾞ113
      (progn ; 品番基本
        ;// 品番基本テーブルから情報を取得
        (setq #fig$ (car
          (CFGetDBSQLHinbanTable "品番基本" #hin
            (list (list "品番名称" #hin 'STR))
        )))
        (if #fig$
          (progn
            (if (equal 2 (nth 4 #fig$) 0.1) ; 品番ﾀｲﾌﾟ
              (if (KcCheckSetStd #sym) ; SET標準かどうかﾁｪｯｸ
                (setq #sym_new$ (append #sym_new$ (list #sym))) ; SET品
                nil                                             ; SET品でないから除外
              );_if
              ; 品番ﾀｲﾌﾟが2でないとき→ｾｯﾄ品扱いで赤くする
              (setq #sym_new$ (append #sym_new$ (list #sym))) ; SET品
            );_if
          )
          ; 品番基本に存在しないとき判定できない→ｾｯﾄ品扱いで赤くする
          (setq #sym_new$ (append #sym_new$ (list #sym))) ; SET品
        );_if
      )
      (progn
        (setq #sym_new$ (append #sym_new$ (list #sym)))
      )
    );_if
  );foreach
  ; 02/01/24 YM ADD-E

;;;  (list #sym$ #sym110$); ｼﾝﾎﾞﾙ図形ﾘｽﾄ  02/01/24 YM MOD
  (list #sym_new$ #sym110$); ｼﾝﾎﾞﾙ図形ﾘｽﾄ 02/01/24 YM MOD
);PKGetBaseSymCP_SYOKUSEN

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetLowCabSym
;;; <処理概要>  : ｼﾝﾎﾞﾙ図形名ﾘｽﾄを渡してﾛｰｷｬﾋﾞｼﾝﾎﾞﾙ図形名ﾘｽﾄを返す
;;; <戻り値>    :
;;; <作成>      : 2000.5.9 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKGetLowCabSym (
  &BaseSym$   ; ﾍﾞｰｽｷｬﾋﾞｼﾝﾎﾞﾙ図形名ﾘｽﾄ
  /
  #EN_LOW$ #H #THR #SS_DEL
  )

  (setq #en_LOW$ '())
  (foreach #en &BaseSym$
    (setq #thr (CFGetSymSKKCode #en 3))
    (cond
      ;ガスキャビネット
      ((= #thr CG_SKK_THR_GAS)
        (setq #h (fix (nth 5 (CFGetXData #en "G_SYM"))))
        (if (and (> #h 472) (< #h 523)) ; もしﾛｰﾀｲﾌﾟのｺﾝﾛｷｬﾋﾞﾈｯﾄがあれば段差ﾌﾟﾗﾝ
          (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ﾛｰﾀｲﾌﾟｷｬﾋﾞﾈｯﾄｼﾝﾎﾞﾙ図形ﾘｽﾄ
          (ssadd #en #ss_del) ; 後で除外する
        );_if
      )
      ;通常キャビネット
      ((= #thr CG_SKK_THR_NRM)
        (setq #h (fix (nth 5 (CFGetXData #en "G_SYM"))))
        (if (and (> #h 676) (< #h 728)) ; もしﾛｰﾀｲﾌﾟの通常ｷｬﾋﾞﾈｯﾄがあれば段差ﾌﾟﾗﾝ
          (setq #en_LOW$ (append #en_LOW$ (list #en))) ; ﾛｰﾀｲﾌﾟｷｬﾋﾞﾈｯﾄｼﾝﾎﾞﾙ図形ﾘｽﾄ
        );_if
      )
    );_cond
  );_(foreach

#en_LOW$
);PKGetLowCabSym

;;;<HOM>*************************************************************************
;;; <関数名>    : StrLisToRealLis
;;; <処理概要>  : 文字列ﾘｽﾄを実数値ﾘｽﾄにする
;;;               (例) (" 12"   "333" "99 ") ---> (12.0  333.0  99.0)
;;; <戻り値>    : 実数値ﾘｽﾄ
;;; <作成>      : 2000.4.30 YM
;;; <備考>      : ｴﾗｰ処理なし
;;;*************************************************************************>MOH<
(defun StrLisToRealLis (
  &str$ ; 文字列ﾘｽﾄ
  /
  #RET$
  )
  (setq #ret$ '())
  (foreach #elm &str$
    (setq #ret$ (append #ret$ (list (atof #elm))))
  )
  #ret$
);StrLisToRealLis

;;;<HOM>*************************************************************************
;;; <関数名>    : StrtoLisBySpace
;;; <処理概要>  : 文字列をspaceで区切ってﾘｽﾄ化する
;;;               (例) " 12   333 a  99 "--->("12" "333" "a" "99")
;;; <戻り値>    : 文字列ﾘｽﾄ
;;; <作成>      : 2000.4.29 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun StrToLisBySpace (
  &str ; 文字列
  /
  #ret$ #dum #flg #i #str
  )
  (setq #ret$ '())
  (if (= 'STR (type &str))
    (progn
      (setq #i 1 #dum " " #flg nil)
      (repeat (strlen &str)
        (setq #str (substr &str #i 1))
        (cond
          ((/= #str " ")
            (setq #flg T #dum (strcat #dum #str))
          )
          (T ; space
            (if #flg
              (progn
                (setq #dum (substr #dum 2 (1- (strlen #dum))))
                (setq #ret$ (append #ret$ (list #dum)))
                (setq #dum " ")
                (setq #flg nil)
              )
            );_if
          )
        );_cond

        (if (= #i (strlen &str))
          (if (and #flg (/= #dum " "))
            (progn
              (setq #dum (substr #dum 2 (1- (strlen #dum))))
              (setq #ret$ (append #ret$ (list #dum)))
            )
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret$
);StrtoListSpace

;;;<HOM>*************************************************************************
;;; <関数名>    : StrtoLisByBrk
;;; <処理概要>  : 文字列を#brkで区切ってﾘｽﾄ化する
;;;               (例) " 12  , 333, a,  99 "--->("12" "333" "a" "99") space は無視する
;;; <戻り値>    : 文字列ﾘｽﾄ
;;; <作成>      : 2000.4.30 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun StrToLisByBrk (
  &str ; 文字列
  &brk
  /
  #ret$ #dum #flg #i #str
  )
  (setq #ret$ '())
  (if (= 'STR (type &str))
    (progn
      (setq #i 1 #dum " " #flg nil)
      (repeat (strlen &str)
        (setq #str (substr &str #i 1))
        (cond
          ((and (/= #str " ")(/= #str &brk))
            (setq #flg T #dum (strcat #dum #str))
          )
          ((= #str " ")
            (princ)
          )
          (T ; &brk
            (if #flg
              (progn
                (setq #dum (substr #dum 2 (1- (strlen #dum))))
                (setq #ret$ (append #ret$ (list #dum)))
                (setq #dum " ")
                (setq #flg nil)
              )
            );_if
          )
        );_cond
        (setq #i (1+ #i))
      )
      (setq #dum (substr #dum 2 (1- (strlen #dum))))
      (setq #ret$ (append #ret$ (list #dum)))
    )
  );_if


  #ret$
);StrToLisByBrk

;;;<HOM>*************************************************************************
;;; <関数名>    : GetPtSeries
;;; <処理概要>  : 閉じたﾎﾟﾘﾗｲﾝ外形点列を、点列内の&baseを先頭に時計周りにならべる
;;; <戻り値>    : 点列
;;; <作成>      : 2000.4.27 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun GetPtSeries (
  &Base   ; 基点
  &pt$    ; 除外前の外形領域点列
  /
  #BASEPT #I #KOSU #NO #PT #PT$ #PT$$
  )

  (setq #i 0)
  (setq #kosu (length &pt$))
  (setq #pt$$ (append &pt$ &pt$))
  (repeat #kosu
    (setq #pt (nth #i &pt$))
    (if (< (distance #pt &Base) 0.1)
      (setq #no #i) ; #base が点列のnth 何番目か
    );_if
    (setq #i (1+ #i))
  )
;;; (if (= #no nil)
;;;   (progn
;;;     (CFAlertErr "PMEN2にシンボルが見つかりませんでした。\n GetPtSeries")
;;;     (quit)  ; 00/06/15 YM
;;;   )
;;; );_if

  (setq #pt$ '())
  (if #no
    (progn  ; PMEN2にシンボルあった
    ;;; 並べ替えｺｰﾅｰ基点が点列の最初くる
      (setq #i #no)
      (repeat #kosu
        (setq #pt$ (append #pt$ (list (nth #i #pt$$))))
        (setq #i (1+ #i))
      )
    ;;; 時計周りにする
      (if (= (CFArea_rl (nth 0 #pt$) (nth 1 #pt$) (last #pt$)) 1)   ; -1:右 , 1:左
        (setq #pt$ (append (list (car #pt$)) (reverse (cdr #pt$)))) ; 時計周りに直す
      );_if
    )
  );_if

#pt$  ; 外形点列上に基点がなかったら nil を返す
);GetPtSeries

;<HOM>*************************************************************************
; <関数名>    : PCW_ChColWT
; <処理概要>  : ﾜｰｸﾄｯﾌﾟ図形名を渡して、関連WTの色変えを行う.
;               BG SOLIDがあればそれも色を変える
;               &flg=T: 隣接WT全て    &flg=nil: 引数WTとBGのみ
; <戻り値>    : なし
; <作成>      : 00/04/27 YM ADD
; <備考>      :
;*************************************************************************>MOH<
(defun PCW_ChColWT (
  &wten  ;(ENAME)WT図形
  &col
  &flg
  /
  #WTL #WTR #XD$ #XD0$ #BGflg #BG1 #BG2 #ZAI
  )

  (setq #BGflg nil)
  (setq #xd$ (CFGetXData &wtEn "G_WRKT"))
  (command "_.change" &wtEn "" "P" "C" &col "") ; 引数WT

  ;;; BG底面が"3DSOLID"==>BG分離型
  (if (and (/= (nth 49 #xd$) "")
           (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID")) ; 01/01/19 YM ADD
    (setq #BGflg T)
  );_if

  (if #BGflg ; BG がSOLID
    (progn
      (setq #BG1 (nth 49 #xd$)) ; BG1
      (setq #BG2 (nth 50 #xd$)) ; BG2
      (if (/= #BG1 "")(command "_.change" #BG1 "" "P" "C" &col ""))
      (if (/= #BG2 "")(command "_.change" #BG2 "" "P" "C" &col ""))
    )
  );_if

  (if &flg
    (progn
      ;;; ｶｯﾄ相手左
      (setq #WTL (nth 47 #xd$)) ; 左WT図形ﾊﾝﾄﾞﾙ
      (while (and #WTL (/= #WTL "")) ; 左にWTがあれば
        (command "_.change" #WTL "" "P" "C" &col "")
        (setq #xd0$ (CFGetXData #WTL "G_WRKT"))
        (if #BGflg ; BG がSOLID
          (progn
            (setq #BG1 (nth 49 #xd0$)) ; BG1
            (setq #BG2 (nth 50 #xd0$)) ; BG2
            (if (/= #BG1 "")(command "_.change" #BG1 "" "P" "C" &col ""))
            (if (/= #BG2 "")(command "_.change" #BG2 "" "P" "C" &col ""))
          )
        );_if

        (setq #WTL (nth 47 #xd0$)) ; 更に左にあるか

        (if (= #WTL "") (setq #WTL nil)) ; なかったら nil
      )

      ;;; ｶｯﾄ相手右
      (setq #WTR (nth 48 #xd$)) ; 右WT図形ﾊﾝﾄﾞﾙ
      (while (and #WTR (/= #WTR "")) ; 右にWTがあれば
        (command "_.change" #WTR "" "P" "C" &col "")
        (setq #xd0$ (CFGetXData #WTR "G_WRKT"))
        (if #BGflg ; BG がSOLID
          (progn
            (setq #BG1 (nth 49 #xd0$)) ; BG1
            (setq #BG2 (nth 50 #xd0$)) ; BG2
            (if (/= #BG1 "")(command "_.change" #BG1 "" "P" "C" &col ""))
            (if (/= #BG2 "")(command "_.change" #BG2 "" "P" "C" &col ""))
          )
        );_if

        (setq #WTR (nth 48 #xd0$)) ; 更に右にあるか
        (if (= #WTR "") (setq #WTR nil)) ; なかったら nil
      )
    )
  )
  (princ)
);PCW_ChColWT

;;;<HOM>*************************************************************************
;;; <関数名>    : RotatePoint
;;; <処理概要>  : &ptを原点中心に#rad回転する
;;; <戻り値>    : #pt
;;; <作成>      : 2000.3.23 YM
;;; <備考>      : 2D or 3D 点
;;;*************************************************************************>MOH<
(defun RotatePoint (
  &pt  ; 回転する点 2D or 3D
  &rad ; 回転角度
  /
  #RET #X #XX #Y #YY
  )
  (setq #x (car  &pt) #y (cadr &pt))
  (setq #xx (- (* #x (cos &rad)) (* #y (sin &rad)) ))
  (setq #yy (+ (* #x (sin &rad)) (* #y (cos &rad)) ))
  (if (= (length &pt) 2) (setq #ret (list #xx #yy)) )
  (if (= (length &pt) 3) (setq #ret (list #xx #yy (caddr &pt))) )
  #ret
)

;;;<HOM>*************************************************************************
;;; <関数名>    : MakeTempLayer
;;; <処理概要>  : 伸縮作業用テンポラリ画層の作成
;;; <戻り値>    : なし
;;; <作成>      : 2000.3.2 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun MakeTempLayer ( / #ss #EN #I)

  (if (tblsearch "LAYER" SKD_TEMP_LAYER)
    (progn                            ; テンポラリ画層があったら
      (setq #ss (ssget "X" (list (cons 8 SKD_TEMP_LAYER))))
      (if (/= #ss nil)
        (progn
          (if (/= (sslength #ss) 0)
            (progn                        ; テンポラリ画層にある図形の削除
              (setq #i 0)
              (repeat (sslength #ss)
                (setq #en (ssname #ss #i))
                (entdel #en)
                (setq #i (1+ #i))
              )
            )
          );_if
        )
      );_if
      (command "_layer" "U" SKD_TEMP_LAYER "")  ; 警告メッセージ対策で2文に分けた  Uﾛｯｸ解除
      (command "_layer" "T" SKD_TEMP_LAYER "ON" SKD_TEMP_LAYER "")  ; ON表示 Tﾌﾘｰｽﾞ解除
    )
    (progn                            ; テンポラリ画層がなかったら
      (command "_layer" "N" SKD_TEMP_LAYER "C" 1 SKD_TEMP_LAYER "L" SKW_AUTO_LAY_LINE SKD_TEMP_LAYER "")
    )
  );_if
  (princ)
);MakeTempLayer

;;;<HOM>*************************************************************************
;;; <関数名>    : MakeTempLayer2
;;; <処理概要>  : 伸縮作業用テンポラリ画層の作成
;;; <戻り値>    : なし
;;; <作成>      : 2001.3.12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun MakeTempLayer2 (
  &layer
  /
  #ss #EN #I
  )
  (if (tblsearch "LAYER" &layer)
    (progn                            ; テンポラリ画層があったら
      (setq #ss (ssget "X" (list (cons 8 &layer))))
      (if (/= #ss nil)
        (progn
          (if (/= (sslength #ss) 0)
            (progn                        ; テンポラリ画層にある図形の削除
              (setq #i 0)
              (repeat (sslength #ss)
                (setq #en (ssname #ss #i))
                (entdel #en)
                (setq #i (1+ #i))
              )
            )
          );_if
        )
      );_if
      (command "_layer" "U" &layer "")  ; 警告メッセージ対策で2文に分けた  Uﾛｯｸ解除
      (command "_layer" "T" &layer "ON" &layer "")  ; ON表示 Tﾌﾘｰｽﾞ解除
    )
    (progn                            ; テンポラリ画層がなかったら
      (command "_layer" "N" &layer "C" 1 &layer "L" SKW_AUTO_LAY_LINE &layer "")
    )
  );_if
  (princ)
);MakeTempLayer2

;;;<HOM>*************************************************************************
;;; <関数名>    : BackLayer
;;; <処理概要>  : (<図形名> 画層)を元に、画層をSKD_TEMP_LAYERから元に戻す
;;; <引数>      : (<図形名> 画層)のﾘｽﾄのﾘｽﾄ
;;; <戻り値>    : なし
;;; <作成>      : 2000.3.2 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun BackLayer (
  &lis$$
  /
  #ELM #EN #I #LAYER
  )
  (setq #i 0)
  (repeat (length &lis$$)
    (setq #elm (nth #i &lis$$))
    (setq #en     (car  #elm))
    (setq #layer  (cadr #elm))
    (command "chprop" #en "" "LA" #layer "")
    (setq #i (1+ #i))
  )
);BackLayer

;;;<HOM>*************************************************************************
;;; <関数名>    : Chg_SStoEnLayer
;;; <処理概要>  : 選択ｾｯﾄ--->(<図形名> 画層)のﾘｽﾄのﾘｽﾄに変換
;;; <引数>      : ﾘｽﾄのﾘｽﾄ
;;; <戻り値>    : (<図形名> 画層)のﾘｽﾄのﾘｽﾄ
;;; <作成>      : 2000.3.2 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun Chg_SStoEnLayer (
  &ss
  /
  #ELM #ET #I #LAYER #RET
  )

  (setq #i 0)
  (setq #ret '())
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))
    (setq #et  (entget #elm))
    (setq #layer (cdr (assoc 8 #et)))
    (setq #ret (append #ret (list (list #elm #layer))))
    (setq #i (1+ #i))
  )
  #ret
);Chg_SStoEnLayer

;;;<HOM>*************************************************************************
;;; <関数名>    : Chg_LISTtoEnLayer
;;; <処理概要>  : 図形ﾘｽﾄ--->(<図形名> 画層)のﾘｽﾄのﾘｽﾄに変換
;;; <引数>      : ﾘｽﾄのﾘｽﾄ
;;; <戻り値>    : (<図形名> 画層)のﾘｽﾄのﾘｽﾄ
;;; <作成>      : 2001.3.12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun Chg_LISTtoEnLayer (
  &lis$
  /
  #ET #LAYER #RET #RET$
  )
  (setq #ret '())
  (foreach #elm &lis$
    (setq #et (entget #elm))
    (setq #layer (cdr (assoc 8 #et)))
    (setq #ret$ (append #ret$ (list (list #elm #layer))))
  )
  #ret$
);Chg_LISTtoEnLayer

;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_select_element
;;; <処理概要>  : 要素を複数回選択(entsel)して選択セットを返す  直前の選択取り消し可能
;;;               ワークトップ編集不可のメッセージ
;;; <引数>      : なし
;;; <戻り値>    : 選択セット
;;; <備考>      : YM
;;;*************************************************************************>MOH<
(defun CMN_select_element(
  /
  #en #en0 #ss_lis #ss #i
  )

  (setq EditUndoM 0) ; 選択回数をｶｳﾝﾄ
  (setq EditUndoU 0) ; 取消回数をｶｳﾝﾄ
  (setq #i 0)
  (setq #en T)
  (while #en
    (initget "U")
    (setq #en (entsel "\nアイテムを選択/U=戻す/: "))

      (cond
        ((= #en "U")
          (setq EditUndoU (1+ EditUndoU)) ; 選択回数をｶｳﾝﾄ
          (command "_.undo" "b")          ; 色を戻す
         ; 選択セットリストのリストから直前のものを削除 ;
          (setq #ss_lis (cdr #ss_lis))
        )
        ((= #en nil)

          (if (= #i 0)
            (progn
              (CFAlertErr "部材が選択されませんでした")(quit)
            )
            (princ)
          );_if
        )
        (T
          (setq EditUndoM (1+ EditUndoM)) ; 選択回数をｶｳﾝﾄ
          (setq #en (car #en))
          (cond
            ((CFGetXData #en "G_WRKT"); ワークトップの場合
              ; 00/07/13 SN E-MOD ﾜｰｸﾄｯﾌﾟも選択可能にする。
              (command "_.undo" "m")
              (GroupInSolidChgCol2 #en CG_ConfSymCol)
              (setq #ss (ssadd))               ;空の選択ｾｯﾄ作成
              (setq #ss (ssadd #en #ss))       ;天井ﾌｨﾗｰ選択ｾｯﾄ作成
              (setq #ss_lis (cons #ss #ss_lis));選択ｾｯﾄﾘｽﾄに追加
              ;(CFAlertErr "基準アイテムは編集できません")
              ; 00/07/13 SN E-MOD ﾜｰｸﾄｯﾌﾟも選択可能にする。
            )
            ((CFGetXData #en "G_FILR") ; 天井フィラーの場合
              ; 00/06/27 SN S-MOD 天井フィラーも選択可にする。
              (command "_.undo" "m")
              (GroupInSolidChgCol2 #en CG_ConfSymCol)
              (setq #ss (ssadd))               ;空の選択ｾｯﾄ作成
              (setq #ss (ssadd #en #ss))       ;天井ﾌｨﾗｰ選択ｾｯﾄ作成
              (setq #ss_lis (cons #ss #ss_lis));選択ｾｯﾄﾘｽﾄに追加
              ;(CFAlertErr "基準アイテムは編集できません")
              ; 00/06/27 SN E-MOD 天井フィラーも選択可にする。
            )
            ((CFGetXData #en "G_ROOM") ; ???
              (CFYesDialog "選択した図形は間口領域です　")
            )
            ((CFGetXData #en "RECT") ; ???
              (CFYesDialog "選択した図形は矢視領域です　")
            )
            (T
              (setq #en (CFSearchGroupSym #en)) ; それ以外の部材
              (if #en ; 戻り値親図形名
                (progn
                  (command "_.undo" "m")
                  (setq #ss (CFGetSameGroupSS #en)); メンバー図形選択セット
                  (command "_.change" #ss "" "P" "C" CG_ConfSymCol "")
                  (setq #ss_lis (cons #ss #ss_lis))    ; 選択セットリスト
                )
              )
            )
          );_(cond
        )
      );_(cond
    (setq #i (1+ #i))
  );_(while #en

  (setq #i 0)
  (setq #ss (ssadd)) ; 空の選択セット
  (repeat (length #ss_lis)
    (setq #ss (CMN_ssaddss (nth #i #ss_lis) #ss)) ; 全選択セットを１つにまとめる.
  (setq #i (1+ #i))
  );_(repeat (length #ss_ret_lis)
  #ss
);CMN_select_element

;<HOM>*************************************************************************
; <関数名>    : SetG_WRKT
; <処理概要>  : "G_WRKT"(WT左上点)(WT取付け高さ)拡張データの変更
; <戻り値>    : なし
; <作成>      : 00/09/14 YM 01/01/15 YM MOD
; <備考>      : 移動系コマンド用
;*************************************************************************>MOH<
(defun SetG_WRKT(
  &MOD ; 編集ﾓｰﾄﾞ"MOVE":移動ｺﾏﾝﾄﾞ "Z_MOVE":Z移動ｺﾏﾝﾄﾞ
  &ss  ; 選択要素全図形選択ｾｯﾄ
  &bpt ; 基点(Z移動の場合、移動距離)
  &lpt ; 目的点 &MOD="ROT"なら回転角度
  /
  #ELM #I #ORG #PLUS #WTPT #XD0 #WTH #XD1
  #DUM_BP #DUM_P1
  )

  (setq #i 0)
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))  ; リストの各要素（図形名）
    (if (setq #xd0 (CFGetXData #elm "G_WRKT"))
      (progn
        (cond
          ((= &MOD "ROT") ; 回転ｺﾏﾝﾄﾞ
            (setq #org (nth 32 #xd0)) ; 元のWT左上点

            (setq #dum_BP (mapcar '- &bpt &bpt))     ; 平行移動して(0,0)とする
            (setq #dum_P1 (mapcar '- #org &bpt))     ; 元の左上点を同様に平行移動
            (setq #dum_P1 (RotatePoint #dum_P1 &lpt)); &lpt回転する
            ; 新しいWT左上点
            (setq #WTPT (mapcar '+ #dum_P1 &bpt))      ; 平行移動して戻す

            ; 拡張ﾃﾞｰﾀ "G_WRKT" のｾｯﾄ
            (CFSetXData #elm "G_WRKT"
              (CFModList #xd0
                (list (list 32 #WTPT)) ;33.WT左上点座標
              )
            )
          )
          ((= &MOD "MOVE") ; 移動ｺﾏﾝﾄﾞ
            (setq #org (nth 32 #xd0)) ; 元のWT左上点
            (setq #plus (mapcar '- &lpt &bpt))
            (setq #WTPT (mapcar '+ #org #plus)) ; 新しいWT左上点
            ; 拡張ﾃﾞｰﾀ "G_WRKT" のｾｯﾄ
            (CFSetXData #elm "G_WRKT"
              (CFModList #xd0
                (list (list 32 #WTPT)) ;33.WT左上点座標
              )
            )
          )
          ((= &MOD "Z_MOVE") ; Z移動ｺﾏﾝﾄﾞ
            (setq #WTH (nth 8 #xd0))  ; 元のWT取付け高さ
            (setq #WTH (+ #WTH &bpt)) ; 新しいWT取付け高さ
            ; 拡張ﾃﾞｰﾀ "G_WRKT" のｾｯﾄ
            (CFSetXData #elm "G_WRKT"
              (CFModList #xd0
                (list (list 8 #WTH)) ;33.WT取付け高さ
              )
            )
            (if (setq #xd1 (CFGetXData #elm "G_WTSET")) ; 品番確定されている
              ; 拡張ﾃﾞｰﾀ "G_WTSET" のｾｯﾄ
              (CFSetXData #elm "G_WTSET"
                (CFModList #xd1
                  (list (list 2 #WTH)) ;WT取付け高さ
                )
              )
            )
          )
        );_cond
      )
    );_if

  (setq #i (1+ #i))
  );_(repeat
  (princ)
);SetG_WRKT

;<HOM>*************************************************************************
; <関数名>    : PcGetOpNumDlg
; <処理概要>  : ユーザーにオプション品の有無を求めるダイアログ
; <戻り値>    : 1 か 0
; <作成>      : 00/08/04 MH 書き換え
; <備考>      :
;*************************************************************************>MOH<
(defun PcGetOpNumDlg (
  &sHin       ; オプション品番
  &sDefo      ; "Yes" "No" デフォルト指定
  /
  #sMSG #sNAME #iOP
  )
  (setq #sNAME (PcGetPrintName &sHin))
  (setq #sMSG (if (= "" #sNAME) &sHin (strcat &sHin " （" #sNAME "） ")))
  (setq #iOP
    (if (CfYesNoJpDlg (strcat #sMSG "を使用しますか？") &sDefo) 1 0)
  )
  #iOP
);PcGetOpNumDlg

;<HOM>*************************************************************************
; <関数名>    : PFGetLorRDlg
; <処理概要>  : 左か右かユーザーに選ばせる
; <戻り値>    : "L" か "R" か nil（キャンセルされた場合）
; <作成>      : 00/07/13 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PFGetLorRDlg (
   &sDPATH
   &sDNAME
   &sHIN
   /
   #dcl_id #LR$
  )
  ;;; ダイアログの実行部
  (setq #dcl_id (load_dialog &sDPATH))
  (if (= nil (new_dialog &sDNAME #dcl_id)) (exit))
  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept"
    "(setq #LR$ (if (= \"1\" (get_tile \"L\")) \"L\" \"R\")) (done_dialog)")
  (action_tile "cancel" "(setq #LR$ nil) (done_dialog)")
  ;;;デフォ値代入
  (set_tile "Hin"  (strcat "     品番 ： " &sHIN))
  (set_tile "Name" (strcat "     品名 ： " (PcGetPrintName &sHIN)))
  (set_tile "L" "1")
  (start_dialog)
  (unload_dialog #dcl_id)
  ;;; 結果リストを返す
  #LR$
); PFGetLorRDlg

;;;;<HOM>*************************************************************************
;;;; <関数名>    : SetG_LSYM1
;;;; <処理概要>  : "G_LSYM" (挿入点)拡張データの変更
;;;; <戻り値>    : なし
;;;; <作成>      : 1999-12-2 YM
;;;; <備考>      : 移動系コマンド用
;;;;*************************************************************************>MOH<
;;;(defun SetG_LSYM1(
;;;  &lst    ; 選択要素の全グループ図形名リスト
;;;  /
;;;  #i
;;;  #org ; 挿入点
;;;  #elm
;;;  #xd
;;;  #xd0
;;;  )
;;;
;;;  (setq #i 0)
;;;  (repeat (length &lst)
;;;    (setq #elm (nth #i &lst))                                ; リストの各要素（図形名）
;;;    (setq #xd0 (CFGetXData #elm "G_LSYM"))
;;;    (if #xd0
;;;      (progn
;;;        (setq #org (cdr (assoc 10 (entget #elm))))
;;;        (setq #xd (CMN_subs_elem_list 1 #org #xd0))          ; 変更後拡張データ
;;;        (CFSetXData (nth #i &lst) "G_LSYM" #xd)              ; 変更後拡張データのセット
;;;      );_(progn
;;;    );_(if xd
;;;  (setq #i (1+ #i))
;;;  );_(repeat
;;;  (princ)
;;;);SetG_LSYM1

;<HOM>*************************************************************************
; <関数名>    : ChgLSYM1
; <処理概要>  : "G_LSYM" (挿入点)拡張データの変更
; <戻り値>    : なし
; <作成>      : 1999-12-2 YM　01/04/27 YM 高速化
; <備考>      : 移動系コマンド用
;*************************************************************************>MOH<
(defun ChgLSYM1(
  &ss     ; 選択要素全図形選択ｾｯﾄ
  /
  #ELM #I #J #ORG #SSDUM #SSGRP #SYM #XD0
  )
  (setq #ssdum (ssadd))
  (setq #i 0)
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))
    (if (not (ssmemb #elm #ssdum))
      ;ｸﾞﾙｰﾌﾟｱｲﾃﾑの処理
      (if (and (setq #sym (SearchGroupSym #elm))      ; ｼﾝﾎﾞﾙあり
               (setq #ssGrp (CFGetSameGroupSS #sym))) ; ｸﾞﾙｰﾌﾟ全体
        (progn
          (if (setq #xd0 (CFGetXData #sym "G_LSYM"))
            (progn
              (setq #org (cdr (assoc 10 (entget #sym))))
              ;// 拡張データの更新
              (CFSetXData #sym "G_LSYM"
                (CFModList #xd0
                  (list
                    (list 1 #org) ; 挿入点
                  )
                )
              )
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
  );repeat
  (princ)
);ChgLSYM1

;<HOM>*************************************************************************
; <関数名>    : ChgLSYM12
; <処理概要>  : "G_LSYM" (挿入点)(回転角度)拡張データの変更
; <戻り値>    : なし
; <作成>      : 01/04/27 YM 高速化
; <備考>      : 移動系コマンド用
;*************************************************************************>MOH<
(defun ChgLSYM12(
  &ss     ; 選択要素全図形選択ｾｯﾄ
  &sa_ang ; 回転角度
  /
  #ELM #I #J #ORG #SSDUM #SSGRP #SYM #XD0
#sym$ ;-- 2012/03/07 A.Satoh Add 配置角度設定不正の対応
  )
  (setq #ssdum (ssadd))
  (setq #i 0)
;-- 2012/03/07 A.Satoh Add 配置角度設定不正の対応 - S
	(setq #sym$ nil)
;-- 2012/03/07 A.Satoh Add 配置角度設定不正の対応 - E
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))
    (if (not (ssmemb #elm #ssdum))
      ;ｸﾞﾙｰﾌﾟｱｲﾃﾑの処理
      (if (and (setq #sym (SearchGroupSym #elm))      ; ｼﾝﾎﾞﾙあり
               (setq #ssGrp (CFGetSameGroupSS #sym))) ; ｸﾞﾙｰﾌﾟ全体
        (progn
;-- 2012/03/07 A.Satoh Add 配置角度設定不正の対応 - S
					(if (not (member #sym #sym$))
						(progn
;-- 2012/03/07 A.Satoh Add 配置角度設定不正の対応 - S
          (if (setq #xd0 (CFGetXData #sym "G_LSYM"))
            (progn
              (setq #org (cdr (assoc 10 (entget #sym))))
              ;// 拡張データの更新
              (CFSetXData #sym "G_LSYM"
                (CFModList #xd0
                  (list
                    (list 1 #org) ; 挿入点
                    (list 2 (Angle0to360 (+ (nth 2 #xd0) &sa_ang))) ; 配置角度
                  )
                )
              )
;-- 2012/03/07 A.Satoh Add 配置角度設定不正の対応 - S
							(setq #sym$ (append #sym$ (list #sym)))
;-- 2012/03/07 A.Satoh Add 配置角度設定不正の対応 - E
            )
          );_if

          ;一度探しだしたｸﾞﾙｰﾌﾟをｽﾄｯｸしておく(選択ｾｯﾄに加算)
          (setq #j 0)
          (repeat (sslength #ssGrp)
            (ssadd (ssname #ssGrp #j) #ssdum)
            (setq #j (1+ #j))
          )
          (setq #ssGrp nil)
;-- 2012/03/07 A.Satoh Add 配置角度設定不正の対応 - S
						)
					)
;-- 2012/03/07 A.Satoh Add 配置角度設定不正の対応 - E
        )
      );_if
    );_if
    (setq #i (1+ #i))
  );repeat
  (princ)
);ChgLSYM12

;<HOM>*************************************************************************
; <関数名>    : ChgLSYM1_copy
; <処理概要>  : "G_LSYM" (挿入点)拡張データの変更
; <戻り値>    : なし
; <作成>      : 1999-12-2 YM　01/05/01 YM 高速化
; <備考>      : コピー系コマンド用
;*************************************************************************>MOH<
(defun ChgLSYM1_copy(
  &lst    ; 選択要素の全グループ図形名リスト,拡張データ変更元
  &lst2   ; 選択要素の全グループ図形名リスト,拡張データセット先
  /
  #ELM #I #J #LOOP #NO #ORG #SSDUM #SSGRP #SYM #SYM2 #XD0 #K
  )
  (setq #ssdum (ssadd))
  (setq #i 0)
  (repeat (length &lst)
    (setq #elm (nth #i &lst)) ; リストの各要素（図形名）
    (if (not (ssmemb #elm #ssdum))
      ;ｸﾞﾙｰﾌﾟｱｲﾃﾑの処理
      (if (and (setq #sym (SearchGroupSym #elm))      ; ｼﾝﾎﾞﾙあり
               (setq #ssGrp (CFGetSameGroupSS #sym))) ; ｸﾞﾙｰﾌﾟ全体
        (progn
          (if (setq #xd0 (CFGetXData #sym "G_LSYM"))
            (progn

              ; #sym が&lstの何番目か
              (setq #loop T #j 0)
              (while (and #loop (< #j (length &lst)))
                (if (equal (nth #j &lst) #sym)
                  (progn
                    (setq #loop nil)
                    (setq #no #j)
                  )
                );_if
                (setq #j (1+ #j))
              )
              (if #no
                (progn
                  (setq #sym2 (nth #no &lst2))
                  (setq #org (cdr (assoc 10 (entget #sym2))))
                  ;// 拡張データの更新
                  (CFSetXData #sym2 "G_LSYM"
                    (CFModList #xd0
                      (list (list 1 #org)) ; 挿入点
                    )
                  )
                )
                (princ "\n挿入点座標の更新ができませんでした。")
              );_if

            )
          );_if

          ;一度探しだしたｸﾞﾙｰﾌﾟをｽﾄｯｸしておく(選択ｾｯﾄに加算)
          (setq #k 0)
          (repeat (sslength #ssGrp)
            (ssadd (ssname #ssGrp #k) #ssdum)
            (setq #k (1+ #k))
          )
          (setq #ssGrp nil)
        )
      );_if
    );_if
    (setq #i (1+ #i))
  );repeat
  (princ)
);ChgLSYM1_copy

;;;01/05/01YM@;<HOM>*************************************************************************
;;;01/05/01YM@; <関数名>    : SetG_LSYM11
;;;01/05/01YM@; <処理概要>  : "G_LSYM" (挿入点)拡張データの変更
;;;01/05/01YM@; <戻り値>    : なし
;;;01/05/01YM@; <作成>      : 1999-12-2 YM
;;;01/05/01YM@; <備考>      : コピー系コマンド用
;;;01/05/01YM@;*************************************************************************>MOH<
;;;01/05/01YM@(defun SetG_LSYM11(
;;;01/05/01YM@  &lst    ; 選択要素の全グループ図形名リスト,拡張データ変更元
;;;01/05/01YM@  &lst2   ; 選択要素の全グループ図形名リスト,拡張データセット先
;;;01/05/01YM@  /
;;;01/05/01YM@  #i
;;;01/05/01YM@  #org ; 挿入点
;;;01/05/01YM@  #elm
;;;01/05/01YM@  #elm2
;;;01/05/01YM@  #xd
;;;01/05/01YM@  #xd0
;;;01/05/01YM@  )
;;;01/05/01YM@
;;;01/05/01YM@  (setq #i 0)
;;;01/05/01YM@  (repeat (length &lst)
;;;01/05/01YM@    (setq #elm (nth #i &lst))                                       ; リストの各要素（図形名）
;;;01/05/01YM@    (setq #xd0 (CFGetXData #elm "G_LSYM"))
;;;01/05/01YM@    (if #xd0
;;;01/05/01YM@      (progn
;;;01/05/01YM@        (setq #elm2 (nth #i &lst2))                                 ; リストの各要素（図形名）
;;;01/05/01YM@        (setq #org (cdr (assoc 10 (entget #elm2))))
;;;01/05/01YM@        (setq #xd (CMN_subs_elem_list 1 #org #xd0))                 ; 変更後拡張データ
;;;01/05/01YM@        (CFSetXData (nth #i &lst2) "G_LSYM" #xd)                    ; 変更後拡張データのセット
;;;01/05/01YM@      );_(progn
;;;01/05/01YM@    );_(if xd
;;;01/05/01YM@
;;;01/05/01YM@  (setq #i (1+ #i))
;;;01/05/01YM@  );_(repeat
;;;01/05/01YM@  (princ)
;;;01/05/01YM@)

;;;;<HOM>*************************************************************************
;;;; <関数名>    : SetG_LSYM2
;;;; <処理概要>  : "G_LSYM" (回転角度)拡張データの変更
;;;; <戻り値>    : なし
;;;; <作成>      : 1999-12-2 YM
;;;; <備考>      : 移動系コマンド用
;;;;*************************************************************************>MOH<
;;;(defun SetG_LSYM2(
;;;  &lst    ; 選択要素の全グループ図形名リスト
;;;  &sa_ang ; 回転角度
;;;  /
;;;  #i
;;;  #elm
;;;  #xd
;;;  #xd0
;;;  #deg
;;;  )
;;;
;;;  (setq #i 0)
;;;  (repeat (length &lst)
;;;    (setq #elm  (nth #i &lst))                                      ; リストの各要素（図形名）
;;;    (setq #xd0 (CFGetXData #elm "G_LSYM"))
;;;    (if #xd0
;;;      (progn
;;;        (setq #deg (nth 2 #xd0))                                    ; 元の拡張データの3番目の要素(挿入角度)
;;;        (setq #xd (CMN_subs_elem_list 2 (+ #deg &sa_ang) #xd0))     ; 変更後拡張データ
;;;        (CFSetXData (nth #i &lst) "G_LSYM" #xd)                     ; 変更後拡張データのセット
;;;      );_(progn
;;;    );_(if xd
;;;
;;;  (setq #i (1+ #i))
;;;  );_(repeat
;;;  (princ)
;;;)

;;;;<HOM>*************************************************************************
;;;; <関数名>    : SetG_LSYM22
;;;; <処理概要>  : "G_LSYM" (回転角度)拡張データの変更
;;;; <戻り値>    : なし
;;;; <作成>      : 1999-12-2 YM
;;;; <備考>      : コピー系コマンド用
;;;;*************************************************************************>MOH<
;;;(defun SetG_LSYM22(
;;;  &lst    ; 選択要素の全グループ図形名リスト,拡張データ変更元
;;;  &lst2   ; 選択要素の全グループ図形名リスト,拡張データセット先
;;;  &sa_ang ; 回転角度
;;;  /
;;;  #i
;;;  #elm
;;;  #xd
;;;  #xd0
;;;  #deg
;;;  )
;;;
;;;  (setq #i 0)
;;;  (repeat (length &lst)
;;;    (setq #elm  (nth #i &lst))                                      ; リストの各要素（図形名）
;;;    (setq #xd0 (CFGetXData #elm "G_LSYM"))
;;;    (if #xd0
;;;      (progn
;;;        (setq #deg (nth 2 #xd0))                                    ; 元の拡張データの3番目の要素(挿入角度)
;;;        (setq #xd (CMN_subs_elem_list 2 (+ #deg &sa_ang) #xd0))     ; 変更後拡張データ
;;;        (CFSetXData (nth #i &lst2) "G_LSYM" #xd)                    ; 変更後拡張データのセット
;;;      );_(progn
;;;    );_(if xd
;;;    (setq #i (1+ #i))
;;;  );_(repeat
;;;
;;;  (princ)
;;;)

;<HOM>*************************************************************************
; <関数名>    : ChgLSYM12_copy
; <処理概要>  : "G_LSYM" (挿入点,回転角度)拡張データの変更
; <戻り値>    : なし
; <作成>      : 1999-12-2 YM　01/05/01 YM 高速化
; <備考>      : コピー系コマンド用
;*************************************************************************>MOH<
(defun ChgLSYM12_copy(
  &lst    ; 選択要素の全グループ図形名リスト,拡張データ変更元
  &lst2   ; 選択要素の全グループ図形名リスト,拡張データセット先
  &sa_ang ; 回転角度
  /
  #ELM #I #J #LOOP #NO #ORG #SSDUM #SSGRP #SYM #SYM2 #XD0 #K
  )
  (setq #ssdum (ssadd))
  (setq #i 0)
  (repeat (length &lst)
    (setq #elm (nth #i &lst)) ; リストの各要素（図形名）
    (if (not (ssmemb #elm #ssdum))
      ;ｸﾞﾙｰﾌﾟｱｲﾃﾑの処理
      (if (and (setq #sym (SearchGroupSym #elm))      ; ｼﾝﾎﾞﾙあり
               (setq #ssGrp (CFGetSameGroupSS #sym))) ; ｸﾞﾙｰﾌﾟ全体
        (progn
          (if (setq #xd0 (CFGetXData #sym "G_LSYM"))
            (progn

              ; #sym が&lstの何番目か
              (setq #loop T #j 0)
              (while (and #loop (< #j (length &lst)))
                (if (equal (nth #j &lst) #sym)
                  (progn
                    (setq #loop nil)
                    (setq #no #j)
                  )
                );_if
                (setq #j (1+ #j))
              )
              (if #no
                (progn
                  (setq #sym2 (nth #no &lst2))
                  (setq #org (cdr (assoc 10 (entget #sym2))))
                  ;// 拡張データの更新
                  (CFSetXData #sym2 "G_LSYM"
                    (CFModList #xd0
                      (list
                        (list 1 #org) ; 挿入点
                        (list 2 (Angle0to360 (+ (nth 2 #xd0) &sa_ang))) ; 配置角度
                      )
                    )
                  )
                )
                (princ "\n挿入点座標の更新ができませんでした。")
              );_if

            )
          );_if

          ;一度探しだしたｸﾞﾙｰﾌﾟをｽﾄｯｸしておく(選択ｾｯﾄに加算)
          (setq #k 0)
          (repeat (sslength #ssGrp)
            (ssadd (ssname #ssGrp #k) #ssdum)
            (setq #k (1+ #k))
          )
          (setq #ssGrp nil)
        )
      );_if
    );_if
    (setq #i (1+ #i))
  );repeat
  (princ)
);ChgLSYM12_copy

;<HOM>*************************************************************************
; <関数名>    : SetG_PRIM1
; <処理概要>  : "G_PRIM"(取り付け高さ)拡張データの変更
; <戻り値>    : なし
; <作成>      : 1999-12-2 YM
; <備考>      : 移動系コマンド用
;*************************************************************************>MOH<
(defun SetG_PRIM1(
  &ss     ; 選択要素全図形選択ｾｯﾄ
  /
  #i
  #elm
  #xd
  #xd0
  #high0
  #high
  )
  (setq #i 0)
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))

    (if (setq #xd0 (CFGetXData #elm "G_PRIM"))
      (progn
        (setq #high0 (nth 6 #xd0))                   ; 取りつけ高さ
        (setq #high  (+ #high0 CG_ZMOVEDIST))        ; 変更後の取り付け高さ
        (setq #xd (CMN_subs_elem_list 6 #high #xd0)) ; 変更後拡張データ
        (CFSetXData (ssname &ss #i) "G_PRIM" #xd)
      )
    );_if
    (setq #i (1+ #i))
  );_(repeat
  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : SetG_PRIM11
; <処理概要>  : "G_PRIM"(取り付け高さ)拡張データの変更
; <戻り値>    : なし
; <作成>      : 1999-12-2 YM
; <備考>      : コピー系コマンド用
;*************************************************************************>MOH<
(defun SetG_PRIM11(
  &lst    ; 選択要素の全グループ図形名リスト,拡張データ変更元
  &lst2   ; 選択要素の全グループ図形名リスト,拡張データセット先
  /
  #i
  #elm
  #xd
  #xd0
  #high0
  #high
  )

  (setq #i 0)
  (repeat (length &lst)
    (setq #elm (nth #i &lst))                                 ; リストの各要素（図形名）
    (setq #xd0 (CFGetXData #elm "G_PRIM"))
    (if #xd0
      (progn
        (setq #high0 (nth 6 #xd0))                            ; 取りつけ高さ
        (setq #high  (+ #high0 CG_ZMOVEDIST))                 ; 変更後の取り付け高さ
        (setq #xd (CMN_subs_elem_list 6 #high #xd0))          ; 変更後拡張データ
        (CFSetXData (nth #i &lst2) "G_PRIM" #xd)
      );_(progn
    );_(if xd0
  (setq #i (1+ #i))
  );_(repeat
  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : SetG_PRIM22
; <処理概要>  : "G_PRIM"(底面図形)拡張データの変更
; <戻り値>    : なし
; <作成>      : 1999-12-2 YM
; <備考>      : コピー系コマンド用
;*************************************************************************>MOH<
(defun SetG_PRIM22(
  &lst    ; 選択要素の全グループ図形名リスト,拡張データ変更元
  &lst2   ; 選択要素の全グループ図形名リスト,拡張データセット先
  /
  #i
  #elm
  #xd
  #xd0
  #n1
  #n2
  #en_tei
  #en_tei0 #MSG #SYM #ZUKEI_ID
  )

;;; "G_PRIM" の位置検索+変更 ;;;
  (setq #i 0)
  (repeat (length &lst)
    (setq #elm (nth #i &lst))                                 ; リストの各要素（図形名）
    (setq #xd0 (CFGetXData #elm "G_PRIM"))
    ;;; リストの#n1番目の("G_PRIM")のハンドル名項目を、
    ;;; リストの#n2番目の("G_PRIM")の図形ハンドルに変更する.
    (if #xd0
      (progn
        (setq #n1 #i)
        (setq #en_tei0 (nth 10 #xd0))                         ; 底面図形名
;;; 00/04/08 たまに底面図形が"0"のときがあるのでチェック追加図面上はコピーできるようにする
        (if (or (= #en_tei0 nil) (= #en_tei0 "0"))  ; 00/04/08 YM ADD
          (progn
            (setq #sym (SearchGroupSym #elm)) ; #elm ; SOLID図形名
            (setq #ZUKEI_ID (nth 0 (CFGetXData #sym "G_LSYM"))) ; 図形ID
            (setq #msg
              (strcat "\nアイテムの\"G_PRIM\"が不正です。\n作成元に連絡してください.\n図形ID="
              #ZUKEI_ID)
            )
            (CFAlertMsg #msg)
          )
          (progn
            (setq #n2 (CMN_search_en_lis #en_tei0 &lst))          ; 引数１が引数２のリストの何番目の要素か
            (setq #en_tei (nth #n2 &lst2))                        ; ｺﾋﾟｰ後底面図形名
            (setq #xd (CMN_subs_elem_list 10 #en_tei #xd0))
            (CFSetXData (nth #n1 &lst2) "G_PRIM" #xd)
          )
        );_if
      )
    );_if

  (setq #i (1+ #i))
  );_(repeat
  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : AfterCopySetDoorGroup
; <処理概要>  : ｺﾋﾟｰ後の扉ｸﾞﾙｰﾌﾟに"DoorGroup"をつける
; <戻り値>    : なし
; <作成>      : 01/08/31 YM
; <備考>      : コピー系コマンド用
; 01/08/31 特注ｷｬﾋﾞをｺﾋﾟｰした後の部材が展開図作成途中で落ちる不具合あり.
; ｺﾋﾟｰ後の扉のｸﾞﾙｰﾌﾟが名前のないｸﾞﾙｰﾌﾟとなってしまうため人為的に"DoorGroup"
; をｾｯﾄするのがこの関数の目的である.
;*************************************************************************>MOH<
(defun AfterCopySetDoorGroup(
  &lst    ; 選択要素の全グループ図形名リスト,拡張データ変更元
  &lst2   ; 選択要素の全グループ図形名リスト,拡張データセット先
  /
  #DOOR$ #ELM #I #K #SSDOOR$ #SSDUM #SSGRP #SYM
  #ENNAME$ #J #LOOP #NO #SLAYER #SSDOOR
#SGRNAME ; 02/09/04 YM ADD
  )
  (setq #ssdum (ssadd))
  (setq #i 0)
  (setq #ssDOOR$ nil)
  (repeat (length &lst)
    (setq #elm (nth #i &lst)) ; リストの各要素（図形名）
    (if (not (ssmemb #elm #ssdum))
      ;ｸﾞﾙｰﾌﾟｱｲﾃﾑの処理
      (if (and (setq #sym (SearchGroupSym #elm))     ; ｼﾝﾎﾞﾙあり
               (setq #ssGrp (CFGetSameGroupSS #sym)) ; ｸﾞﾙｰﾌﾟ全体
               (setq #Door$ (KPGetDoorGroup #sym)))  ;"DoorGroup" "GROUP"図形ﾘｽﾄ
        (progn

          (setq #k 0)
          (repeat (sslength #ssGrp)
            (ssadd (ssname #ssGrp #k) #ssdum)
            (setq #k (1+ #k))
          )

          (foreach #Door #Door$
            (setq #ssDOOR (KP_Get340SSFromDrgroup #Door)) ; 同じ扉ﾒﾝﾊﾞｰ
            ;一度探しだしたｸﾞﾙｰﾌﾟをｽﾄｯｸしておく(選択ｾｯﾄ#ssdumに加算)
            (setq #k 0)
            (repeat (sslength #ssDOOR)
              (ssadd (ssname #ssDOOR #k) #ssdum)
              (setq #k (1+ #k))
            )
            (setq #ssDOOR$ (append #ssDOOR$ (list #ssDOOR))) ; 扉図形ﾒﾝﾊﾞｰ選択ｾｯﾄのﾘｽﾄ
            (setq #ssGrp nil)
          )
        )
      );_if
    );_if
    (setq #i (1+ #i))
  );repeat

  (foreach #ssDOOR #ssDOOR$ ; ｺﾋﾟｰ元の扉ﾒﾝﾊﾞｰ選択ｾｯﾄ
    (setq SKD_GROUP_NO (SCD_GetDoorGroupName)) ; ｸﾞﾙｰﾌﾟ毎の番号
    (setq #sLAYER (substr (SKGetGroupName (ssname #ssDOOR 0)) 10 1)) ; ｸﾞﾙｰﾌﾟ名-->LAYER番号取得

    (setq #k 0)
    (setq #enName$ nil) ; ｺﾋﾟｰ後の扉ﾒﾝﾊﾞｰ
    (repeat (sslength #ssDOOR)
      ; (ssname #ssDOOR #k) が&lstの何番目か(#no)
      (setq #loop T #j 0)
      (while (and #loop (< #j (length &lst)))
        (if (equal (ssname #ssDOOR #k)(nth #j &lst))
          (setq #no #j #loop nil)
        );_if
        (setq #j (1+ #j))
      )
      (setq #enName$ (append #enName$ (list (nth #no &lst2))))
      (setq #k (1+ #k))
    )

    ; ｺﾋﾟｰ後の扉 名前のないｸﾞﾙｰﾌﾟ名
    (setq #sGrName (SKGetGroupName (nth 0 #enName$)))
;;;01/09/18YM@MOD   (command "-group" "E" #sGrName) ; 分解

  ;02/01/30 YM ｺﾋﾟｰ後にｸﾞﾙｰﾌﾟ解除はせず、名前のない扉ｸﾞﾙｰﾌﾟ名を変更("gruop" "REN")
  ;            してｸﾞﾙｰﾌﾟの説明"DoorGroup"の追加(entmod)を行う.

;;;02/01/30YM@DEL   ; 01/09/18 YM ADD-S
;;;02/01/30YM@DEL    (if (/= "ACAD" (strcase (getvar "PROGRAM")))
;;;02/01/30YM@DEL      (command "_.-group" "U" #sGrName)
;;;02/01/30YM@DEL      (command "_.-group" "E" #sGrName)
;;;02/01/30YM@DEL    );_if
;;;02/01/30YM@DEL   ; 01/09/18 YM ADD-E

;;;02/01/30YM@DEL    ; 格納した移動後図形の全てを同一のグループにする(グループ化)
;;;02/01/30YM@DEL    (command "-group" "C" (strcat SKD_GROUP_HEAD #sLAYER (itoa SKD_GROUP_NO)) SKD_GROUP_INFO) ; "C","名前","説明"
;;;02/01/30YM@DEL    (foreach #nn #enName$
;;;02/01/30YM@DEL      (command #nn)
;;;02/01/30YM@DEL    )
;;;02/01/30YM@DEL    (command "")

    ; 02/01/30 YM ADD-S ; ｸﾞﾙｰﾌﾟ名変更 "REN","元の名前","新しい名前"
    (command "-group" "REN" #sGrName (strcat SKD_GROUP_HEAD #sLAYER (itoa SKD_GROUP_NO)))
    ; ｸﾞﾙｰﾌﾟの説明"DoorGroup"の追加
    (KPChgGrpSETUMEI (nth 0 #enName$) SKD_GROUP_INFO) ; (扉代表図形,ｸﾞﾙｰﾌﾟの説明)
    ; 02/01/30 YM ADD-E

  );foreach

  (princ)
);AfterCopySetDoorGroup

;<HOM>*************************************************************************
; <関数名>    : KPChgGrpSETUMEI
; <処理概要>  : ｸﾞﾙｰﾌﾟの説明"DoorGroup"の追加
; <戻り値>    : なし
; <作成>      : 02/01/30 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KPChgGrpSETUMEI(
  &enDoor
  &sSETUMEI
  /
  #330 #ED #EG$ #ET
  )
  (setq #eg$ (entget &enDoor))
  ; 330図形のうち"GROUP"を取得
  (setq #330 nil)
  (foreach #eg #eg$
    (if (and (= (car #eg) 330)(= "GROUP" (strcase (cdr (assoc 0 (entget (cdr #eg)))))))
      (setq #330 (cdr #eg))
    );_if
  )
  ; 300="" ｸﾞﾙｰﾌﾟ名変更
  (setq #et (entget #330))
  (setq #ed (subst (cons 300 &sSETUMEI) (assoc 300 #et) #et))
  (entmod #ed)
  (princ)
);KPChgGrpSETUMEI

;<HOM>*************************************************************************
; <関数名>    : SetG_BODY
; <処理概要>  : "G_BODY"(穴図形)拡張データの変更
; <戻り値>    : なし
; <作成>      : 2000-3-3 YM
; <備考>      : コピー系コマンド用
;*************************************************************************>MOH<
(defun SetG_BODY(
  &lst    ; 選択要素の全グループ図形名リスト,拡張データ変更元
  &lst2   ; 選択要素の全グループ図形名リスト,拡張データセット先
  /
  #i
  #elm
  #xd
  #xd0
  #n1
  #n2
  #en_tei
  #en_tei0
  #ANA #ANA0 #K #KOSU
  )

;;; "G_BODY" の位置検索+変更 ;;;
  (setq #i 0)
  (repeat (length &lst)
    (setq #elm (nth #i &lst))                                 ; リストの各要素（図形名）
    (setq #xd0 (CFGetXData #elm "G_BODY"))
    ;;; リストの#n1番目の("G_PRIM")のハンドル名項目を、
    ;;; リストの#n2番目の("G_PRIM")の図形ハンドルに変更する.
    (if #xd0
      (progn
        (setq #xd #xd0) ; 01/01/06 YM
        (setq #n1 #i)
        (setq #kosu (nth 1 #xd0))                             ; 穴図形数
        (setq #k 2)
        (repeat #kosu
          (setq #ana0 (nth #k #xd0))                          ; 穴図形ﾊﾝﾄﾞﾙ
          (setq #n2 (CMN_search_en_lis #ana0 &lst))           ; 引数1が引数2のリストの何番目の要素か
          (setq #ana (nth #n2 &lst2))                         ; ｺﾋﾟｰ後穴図形名
          (setq #xd (CMN_subs_elem_list #k #ana #xd))         ; ﾘｽﾄの要素変更 ; 01/01/06 YM
          (setq #k (1+ #k))
        )
        (if (= #kosu 0)
;;;01/05/01YM@          (CFSetXData (nth #n1 &lst2) "G_BODY" #xd0) ; 01/01/06 YM MOD
          nil ; 何もしない
          (CFSetXData (nth #n1 &lst2) "G_BODY" #xd ) ; 01/01/06 YM MOD
        );_if
      )
    );_if

  (setq #i (1+ #i))
  );_(repeat
  (princ)
)


;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_ss_to_en
;;; <処理概要>  : 選択セットを渡して図形名のリストを得る.
;;; <引数>      : 選択セット
;;; <戻り値>    : (図形名1,2,...,n)
;;; <備考>      : YM
;;;*************************************************************************>MOH<
(defun CMN_ss_to_en(
  &ss     ; 選択セット
  /
  #en_lis ; (図形名1,2,...,n)
  #i
  )
  (setq #i 0 #en_lis nil)
  (if &ss
    (if (> (sslength &ss) 0)
      (repeat (sslength &ss)
        (setq #en_lis (append #en_lis (list (ssname &ss #i)) ))
        (setq #i (1+ #i))
      );_(while (< #i #l)
    );_if
  );_if
  #en_lis
);CMN_ss_to_en()

;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_ssaddss
;;; <処理概要>  : old選択セットにnew選択セット追加して新しい選択セットを作成.
;;; <引数>      : new選択セット,old選択セット
;;; <戻り値>    : 追加後の選択セット
;;; <備考>      : YM
;;;*************************************************************************>MOH<
(defun CMN_ssaddss(
  &ss_new ;
  &ss_old ;
  /
  #i      ;
  #kosu
  #lis
  )

  (if (and (= &ss_new nil) (= &ss_old nil)) ; 引数が両方 nil
    (progn
      (princ "\nCMN_ssaddss 引数が違います。 [(= &ss_new nil) (= &ss_old nil)]")(quit)
    )
  )

  (cond
   ((= &ss_new nil) &ss_old) ; 片方が nil
   ((= &ss_old nil) &ss_new) ; 片方が nil
   (t
      (setq #i 0)
      (setq #lis  (CMN_ss_to_en &ss_new))
      (setq #kosu (length #lis))
      (repeat #kosu
        (ssadd (nth #i #lis) &ss_old)
        (setq #i (1+ #i))
      );_(repeat
      &ss_old
    )
  )


);CMN_ssaddss()

;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_enlist_to_ss
;;; <処理概要>  : 図形名のリストから選択セットを作成
;;; <引数>      : 図形名のリスト
;;; <戻り値>    : 選択セット
;;; <備考>      : YM
;;;*************************************************************************>MOH<
(defun CMN_enlist_to_ss(
  &nm_lis  ; 図形名のリスト
  /
  #ss      ; 選択セット
  #i
  )

  (setq #i 0)
  (setq #ss (ssadd)) ; 空の選択セット作成

  (while (< #i (length &nm_lis))
    (ssadd (nth #i &nm_lis) #ss)
    (setq #i (1+ #i))
  );_(while
  #ss
);CMN_enlist_to_ss

;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_all_en_list
;;; <処理概要>  : 図面上の全ての図形名のリスト(古い順)を戻す。
;;; <引数>      : なし
;;; <戻り値>    : (図形名1,2,...,n)
;;; <備考>      : visual lisp window 「表示」「図面データベースを参照」
;;;              「すべての図形を参照」でもみれる。YM
;;;*************************************************************************>MOH<
(defun CMN_all_en_list(
  /
  #zu0
  #zu
  #z_lis
  #i
  )

  (setq #zu nil)
  (setq #zu0 nil)
  (setq #z_lis nil)

  (setq #zu0 (entlast)) ; 最後の図形
  (setq #zu  (entnext)) ; 最初の図形

  (setq #i 0)
  (while #zu
    (setq #z_lis (cons #zu #z_lis)) ; リストに追加
    (setq #zu (entnext #zu))
    (setq #i (1+ #i))
  );_(while #zu

;-- 2012/01/05 A.Satoh Mod - S
;;;;;  (cons #i (reverse #z_lis)) ; リストに追加
  (cons #i #z_lis) ; リストに追加
;-- 2012/01/05 A.Satoh Mod - E

);CMN_all_en_list(

;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_all_en_kosu
;;; <処理概要>  : 図面上の全ての図形個数を戻す.
;;; <引数>      : 図面上の全ての図形個数
;;; <戻り値>    :
;;; <備考>      : 2000.4.1 YM
;;;*************************************************************************>MOH<
(defun CMN_all_en_kosu(
  /
  #zu0
  #zu
  #i
  )

  (setq #zu0 (entlast)) ; 最後の図形
  (setq #zu  (entnext)) ; 最初の図形

  (setq #i 0)
  (while #zu
    (setq #zu (entnext #zu))
    (setq #i (1+ #i))
  );_(while #zu
  #i
);CMN_all_en_kosu(

;<HOM>*************************************************************************
; <関数名>    : CMN_subs_elem_list
; <処理概要>  : リスト(&list$)の"&i"(0,1,2...)番目の要素を"&element"に変更する.
; <引数>      : 要素番号,新しい要素,変更対象リスト
; <戻り値>    : 変更後のリスト
; <作成>      : 1999-11-22 YM
; <備考>      :
;*************************************************************************>MOH<
(defun CMN_subs_elem_list(
  &i
  &element
  &list$
  /
  #i
  #element
  #ret$
  )

  (if (= (type &list$) 'LIST) ; 引数がリストかどうか
    (progn
      (setq #ret$ '())
      (setq #i 0)
      (repeat (length &list$)
        (setq #element (nth #i &list$))
        (if (= #i &i)
          (progn
            (setq #ret$ (append #ret$ (list &element)))
          );_(progn
          (progn
            (setq #ret$ (append #ret$ (list #element)))
          );_(progn
        );_(if (= #i &i)
      (setq #i (1+ #i))
      );_(repeat (length &list$))
      #ret$
    );_(progn
    (progn
      (princ "\nCMN_subs_elem_list 引数が違います。 :")(quit)
    );_(progn
  );_(if

);CMN_subs_elem_list

;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_search_en_lis
;;; <処理概要>  : 図形名が、図形名リストの何番目にあるか.
;;; <引数>      : 図形名、  図形名リスト(重複なし)
;;; <戻り値>    : 整数(0,1,2,...)
;;; <備考>      : YM
;;;*************************************************************************>MOH<
(defun CMN_search_en_lis(
  &en       ;
  &en_lis   ;
  /
  #i
  #n
  #en
  #flg
  #hdl
  #hdl0
  )

  (if (and (= (type &en) 'ENAME) (= (type &en_lis) 'LIST))
    (progn
      (setq #i 0)
      (setq #n nil)
      (setq #flg T)
      (setq #hdl0  (cdr (assoc 5 (entget &en))))
      (while #flg
        (setq #en (nth #i &en_lis))
        (setq #hdl (cdr (assoc 5 (entget #en))))

        (if (= #hdl0 #hdl)
          (progn
            (setq #n #i)
            (setq #flg nil)
          );_(progn
        );_(if (= #en &en)

        (setq #i (1+ #i))
        (if (= #i (length &en_lis))(setq #flg nil))
      )
      #n
    );_(progn
    (progn
      (princ "\nCMN_search_en_lis 引数が違います。 :")(quit)
    );_(progn
  );_(if

);CMN_search_en_lis()

;;;<HOM>*************************************************************************
;;; <関数名>    : advance
;;; <処理概要>  : 刻み(nick)で数値の繰り上げ
;;; <引数>      : 数値(val),刻み(nick)
;;; <戻り値>    : 数値
;;; <作成>      :     2000.1.25 YM
;;; <備考>      : (advance 625 50) --> 650 , (advance 43 6) --> 48
;;;*************************************************************************>MOH<

(defun advance (&val &nick / #ret)
  (if (equal &val 0.0 0.001)
    (setq #ret 0.0)
    (setq #ret (* &nick (+ (fix (/ (- &val 0.001) &nick)) 1)))
  );_if
)

;<HOM>*************************************************************************
; <関数名>    : DBCheck
; <処理概要>  : ＤＢ検索チェック強化
; <戻り値>    : ﾚｺｰﾄﾞ
; <作成>      : 2000.3.16 YM
; <備考>      :
;;; (setq #qry$ (DBCheck #qry$ "『プラ管理』" "PFGetCompBase")); 00/03/16 @YM@ ﾁｪｯｸ強化
;;; CFGetDBSQLRec 検索 Pclosnk.lsp まで Pcwktop
;;; 02/09/04 YM ADD WEB版では警告表示しない
;*************************************************************************>MOH<
(defun DBCheck (
  &lis$ ; ﾚｺｰﾄﾞ
  &msg1 ; table名
  &msg2 ; 関数名
  /
  #MSG
  )

  (if (= &lis$ nil)
    (progn
      (setq #msg (strcat &msg1 "にレコードがありません。\n" &msg2))
      (CMN_OutMsg #msg)
    )
    (progn
;;;      (CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
;;;      (CFOutStateLog 1 1 &lis$)
      
      (WebOutLog "*** 取得ﾚｺｰﾄﾞ ***********************************************************************")
      (WebOutLog &lis$)
      (WebOutLog "*************************************************************************************")
      

      (if (= (length &lis$) 1)
        (progn
          (setq &lis$ (car &lis$))
        )
        (progn ; 複数ﾋｯﾄしたときはｴﾗｰ
          (setq #msg (strcat &msg1 "にレコードが複数ありました.\n" &msg2))
          (CMN_OutMsg #msg) ; 02/09/05 YM ADD
        )
      );_if
    )
  );_if
  &lis$
)

;<HOM>*************************************************************************
; <関数名>    : CMN_OutMsg
; <処理概要>  : ｴﾗｰ時のﾒｯｾｰｼﾞ出力
; <戻り値>    : なし
; <作成>      : 02/09/05 YM ADD
; <備考>      : CG_AUTOMODEにより処理を分ける
;*************************************************************************>MOH<
(defun CMN_OutMsg (
  &msg
  /
  #MSG
  )
  (CFOutStateLog 0 1 &msg) ; ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞ用
  (if (= CG_AUTOMODE 2)
    (WebOutLog &msg)  ; WEB版通常ﾛｸﾞ
    (CFAlertMsg &msg) ; 警告画面
  )
  (setq CG_ERRMSG (list &msg))
  (*error* CG_ERRMSG)
);CMN_OutMsg

;;;<HOM>*************************************************************************
;;; <関数名>    : DBCheck2
;;; <処理概要>  : ＤＢ検索チェック
;;; <戻り値>    :
;;; <作成>      : 00/11/04 YM
;;; <備考>      : ｴﾗｰでも落ちない
;;;*************************************************************************>MOH<
(defun DBCheck2 (
  &lis$ ; ﾚｺｰﾄﾞ
  &msg1 ; table名
  &msg2 ; key
  /
  #MSG #RET
  )

  (if (= &lis$ nil)
    (progn
      (setq #msg (strcat &msg1 "にレコードがありません" &msg2))
      (CFOutStateLog 0 1 #msg)
      (CFOutLog 1 nil #msg)
      (setq #ret nil)
    )
    (progn
      (CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
      (CFOutStateLog 1 1 &lis$)
      (if (= (length &lis$) 1)
        (progn
          (setq #ret (car &lis$))
        )
        (progn ; 複数ﾋｯﾄしたときはｴﾗｰ
          (setq #msg (strcat &msg1 "にレコードが複数ありました" &msg2))
          (CFOutStateLog 0 1 #msg)
          (CFOutLog 1 nil #msg)
          (setq #ret nil)
        )
      );_if
    )
  );_if
  #ret
);_DBCheck2

;;;<HOM>*************************************************************************
;;; <関数名>    : DBCheck3
;;; <処理概要>  : ＤＢ検索チェック強化
;;; <戻り値>    : ﾚｺｰﾄﾞ
;;; <作成>      : 01/01/22 YM
;;; <備考>      : ﾚｺｰﾄﾞ複数==>落ちずにｺﾏﾝﾄﾞﾗｲﾝにﾒｯｾｰｼﾞ(car で取得
;;;*************************************************************************>MOH<
(defun DBCheck3 (
  &lis$ ; ﾚｺｰﾄﾞ
  &msg1 ; table名
  &msg2 ; 関数名
  /
  #MSG
  )

  (if (= &lis$ nil)
    (progn
      (setq #msg (strcat &msg1 "にレコードがありません。\n" &msg2))
      (CFOutStateLog 0 1 #msg)
      (CFAlertMsg #msg)
      (*error*)
    )
    (progn
      (CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
      (CFOutStateLog 1 1 &lis$)
      (if (= (length &lis$) 1)
        (progn
          (setq &lis$ (car &lis$))
        )
        (progn ; 複数ﾋｯﾄしたときはｴﾗｰ
          (setq #msg (strcat "\n" &msg1 "にレコードが複数ありました.\n"))
          (CFOutStateLog 0 1 #msg)
          (princ #msg) ; ｺﾏﾝﾄﾞﾗｲﾝに表示
          (setq &lis$ (car &lis$))
        )
      );_if
    )
  );_if
  &lis$
);DBCheck3

;;;<HOM>*************************************************************************
;;; <関数名>     : AddPline
;;; <処理概要>   : ﾎﾟﾘﾗｲﾝを1本化 pedit
;;; <引数>       : ﾎﾟﾘﾗｲﾝ図形名ﾘｽﾄ
;;; <戻り値>     : 1本化されたﾎﾟﾘﾗｲﾝ
;;; <作成>       : 2000.3.16 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun AddPline (
  &en_lis ; ﾎﾟﾘﾗｲﾝ図形名ﾘｽﾄ
  /
  #EN #I
  )

  (command "pedit")
  (setq #i 0)
  (repeat (length &en_lis)
    (setq #en (nth #i &en_lis))
    (command #en)
    (if (= #i 0) ; 最初の図形
      (command "J")
    );if
    (setq #i (1+ #i))
  )
  (command "" "")
  (car &en_lis)
);AddPline

;;;<HOM>*************************************************************************
;;; <関数名>    : GetLwPolyLineStEnPt
;;; <処理概要>  : ライトウェイトポリラインの始点、終点を取得する
;;; <戻り値>    : (始点、終点)
;;; <作成>      : 00/03/15 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun GetLwPolyLineStEnPt (
  &en
  /
  #ELM #END #ET #FLG #I #KOSU #START
  )
  (setq #et (entget &en))

  (setq #kosu (length #et))
  (setq #i 0)
  (setq #flg nil)
  (repeat #kosu
    (setq #elm (nth #i #et))
    (if (= (car #elm) 10)
      (progn
        (if (= #flg nil)
          (progn
            (setq #START (cdr #elm))
            (setq #flg T)
          )
        );_if
        (setq #END (cdr #elm))
      )
    );_if
    (setq #i (1+ #i))
  )
  (list #START #END)
);GetLwPolyLineStEnPt

;;;<HOM>*************************************************************************
;;; <関数名>    : MakeLWPL
;;; <処理概要>  : 太さ0のLWPOLYLINEをかく
;;; <戻り値>    :
;;; <作成>      : 2000.3.27 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun MakeLWPL (
  &pt$       ;点列
  &flg ; 0:開く 1:閉じる
  /
  #i
  )
  (setq #i 0)
  (repeat (length &pt$)
    (if (= #i 0) (command "._PLINE" (nth #i &pt$) "W" "0" "0"))
    (if (> #i 0) (command (nth #i &pt$)))
    (setq #i (1+ #i))
  )
  (if (= &flg 0)
    (command "") ; 開く
    (command "CL") ; 閉じる
  );_if

  (entlast)
);MakeLWPL

;;;<HOM>*************************************************************************
;;; <関数名>    : ListEdit
;;; <処理概要>  : 引数1(ﾘｽﾄ)に引数2(ﾘｽﾄ)の要素を足し、引数3の要素を削除
;;; <戻り値>    : ﾘｽﾄ
;;; <作成>      : 2000.3.16 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun ListEdit (
  &lis
  &lis2
  &elm
  /
  #AAA #BBB #RET
)
  (setq #RET (append &lis &lis2))
  (setq #aaa (cdr (member &elm #RET)))
  (setq #bbb (cdr (member &elm (reverse #RET))))
  (setq #RET (append #aaa #bbb))
);ListEdit

;;;<HOM>*************************************************************************
;;; <関数名>    : ListDel
;;; <処理概要>  : 引数1(ﾘｽﾄ)から引数2(選択ｾｯﾄ)の要素を削除
;;; <戻り値>    : ﾘｽﾄ
;;; <作成>      : 2000.3.27 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun ListDel (
  &lis1
  &ss   ; 選択ｾｯﾄ
  /
  #ELM #I #RET$ #LIS
)

  (setq #lis (CMN_ss_to_en &ss)) ; 図形名ﾘｽﾄに変える
  (setq #i 0)
  (repeat (length &lis1)
    (setq #elm (nth #i &lis1))
    (if (= (member #elm #lis) nil)
      (setq #ret$ (append #ret$ (list #elm)))
    )
    (setq #i (1+ #i))
  )
  #ret$
);ListDel

;<HOM>*************************************************************************
; <関数名>    : GroupInSolidChgCol2
; <処理概要>  : 図形を色替えする
; <戻り値>    : なし
; <作成>      : 1999-06-14
; <備考>      :
;*************************************************************************>MOH<
(defun GroupInSolidChgCol2 (
    &sym     ;(ENAME)図形
    &col     ;(STR)色
    /
    #en #en$
    #ss
    #ps
  )

  (setq #ps (getvar "PICKSTYLE"))
  (setvar "PICKSTYLE" 3)
  (if (entget &sym) ; 00/07/03 YM ADD
    ;(command "_change" &sym "" "P" "C" &col "")
    ; 00/10/26 MOD MH "_change" はUCS に平行でない図形が漏れるため
    (command "_chprop" &sym "" "C" &col "")
  );_if

;;;  (MakeSymAxisArw &sym) ; 矢印を作図
  (setvar "PICKSTYLE" #ps)
  (princ)
);GroupInSolidChgCol2

; <HOM>***********************************************************************************
; <関数名>    : GetMinMaxLineToPT$
; <処理概要>  : ﾎﾟﾘﾗｲﾝの各点と線分(始点,終点)との距離の最小値,最大値のﾘｽﾄを返す
; <戻り値>    : (距離最小,距離最大)
; <作成>      : 2000-04-29  : YM
; <備考>      :
; ***********************************************************************************>MOH<
(defun GetMinMaxLineToPT$ (
  &PT$   ; ﾎﾟﾘﾗｲﾝ外形点列
  &LINE$ ; 線分点列ﾘｽﾄ(始点,終点)
  /
  #DIS #DIS_MAX #DIS_MIN #RET$
  )
  (setq #dis_min 1.0e+10 #dis_max -999999)
  (foreach #pt &PT$
    (setq #dis (distance #pt (CFGetDropPt #pt &LINE$)))
    (if (>= #dis_min #dis)(setq #dis_min #dis))
    (if (<= #dis_max #dis)(setq #dis_max #dis))
  )
  (setq #ret$ (list #dis_min #dis_max))
);GetMinMaxLineToPT$

;;;<HOM>*************************************************************************
;;; <関数名>    : FlagToList
;;; <処理概要>  : 3桁の整数を0つきリスト化
;;; <引数>      : 整数
;;; <戻り値>    : リスト
;;;               23 --->(0 2 3) 123--->(1 2 3) 7--->(0 0 7)
;;; <作成>      : 2000.3.29 YM
;;;*************************************************************************>MOH<
(defun FlagToList ( &int / )

  (cond
    ((= (strlen (itoa &int)) 1)
        (list 0 0 &int)
    )
    ((= (strlen (itoa &int)) 2)
        (list 0 (atoi (substr (itoa &int) 1 1))
                (atoi (substr (itoa &int) 2 1))
        )
    )
    ((= (strlen (itoa &int)) 3)
        (list (atoi (substr (itoa &int) 1 1))
              (atoi (substr (itoa &int) 2 1))
              (atoi (substr (itoa &int) 3 1))
        )
    )
  );_cond
);FlagToList

;;;<HOM>*************************************************************************
;;; <関数名>    : PKGetWT_outPT
;;; <処理概要>  : ﾜｰｸﾄｯﾌﾟ図形名を渡して外形点列を戻す
;;; <戻り値>    : 点列(始点を末尾に追加済み)
;;; <作成>      : 2000.4.10 YM ; 01/08/10 YM ADD(引数追加)
;;;*************************************************************************>MOH<
(defun PKGetWT_outPT (
  &WT ; WT図形名
  &flg; ﾌﾗｸﾞ=T:始点を末尾に追加する,nil:しない ; 01/08/10 YM ADD(引数追加)
  /
  #pt$
  )
  (setq #pt$ (GetLWPolyLinePt (nth 38 (CFGetXData &WT "G_WRKT")))) ; WT底面外形領域点列取得
  (if &flg
    (AddPtList #pt$)
    #pt$
  );_if
);PKGetWT_outPT

;;;<HOM>*************************************************************************
;;; <関数名>    : AddPtList
;;; <処理概要>  : 点列の末尾に始点を加えて返す
;;; <戻り値>    : 点列
;;; <作成>      : 2000.4.10 YM
;;;*************************************************************************>MOH<
(defun AddPtList (&pt$ / )
  (append &pt$ (list (car &pt$)))
);AddPtList

;;; <HOM>***********************************************************************************
;;; <関数名>    : NotNil_length
;;; <処理概要>  : listのnilでない要素数を返す
;;; <戻り値>    :
;;; <作成>      : 2000.7.6　 YM
;;; <備考>      :
;;; ***********************************************************************************>MOH<
(defun NotNil_length ( &lis / #kosu)
  (setq #kosu 0)
  (foreach #elm &lis
    (if #elm (setq #kosu (1+ #kosu)))
  )
  #kosu
);NotNil_length

;;; <HOM>***********************************************************************************
;;; <関数名>    : NilDel_List
;;; <処理概要>  : ﾘｽﾄからnilを除く
;;; <戻り値>    : nilを除いたﾘｽﾄ
;;; <作成>      : 07/06 YM
;;; <備考>      :
;;; ***********************************************************************************>MOH<
(defun NilDel_List (
  &lis
  /
  #RET$ #elm
  )
  (setq #ret$ '())
  (foreach #elm &lis
    (if #elm (setq #ret$ (append #ret$ (list #elm))))
  )
  #ret$
);NilDel_List

;;; <HOM>***********************************************************************************
;;; <関数名>    : PKDirectPT
;;; <処理概要>  : 点列の各点が全て直線の同じ側にあれば nil
;;; <戻り値>    :
;;; <作成>      : 2000-05-12  : YM
;;; <備考>      :
;;; ***********************************************************************************>MOH<
(defun PKDirectPT (
  &pt$   ; 点列
  &line$ ; 直線の始点,終点ﾘｽﾄ
  /
  #FLG #LR #LR0
  )

  (setq #flg nil)
  (setq #lr0 (CFArea_rl (car &line$) (cadr &line$) (car &pt$))) ; 最初の点の側
  (foreach #pt &pt$
    (setq #lr (CFArea_rl (car &line$) (cadr &line$) #pt)) ; 右か左か
    (if (/= #lr #lr0)
      (setq #flg T)
    )
  )
  #flg
);PKDirectPT

;;;<HOM>*************************************************************************
;;; <関数名>    : MakeRectanglePT
;;; <処理概要>  : 中心&pt,辺の長さ&a*2の正方形外形点列(末尾に始点を追加)を返す
;;; <戻り値>    : 点列
;;; <作成>      : 2000.6.7 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun MakeRectanglePT (
  &pt
  &a
  /
  #P1 #P2 #P3 #P4
  )
  (setq #p1 (list (+ (car &pt) &a) (+ (cadr &pt) &a)))
  (setq #p2 (list (- (car &pt) &a) (+ (cadr &pt) &a)))
  (setq #p3 (list (- (car &pt) &a) (- (cadr &pt) &a)))
  (setq #p4 (list (+ (car &pt) &a) (- (cadr &pt) &a)))
  (list #p1 #p2 #p3 #p4 #p1)
);MakeRectanglePT

;;;<HOM>*************************************************************************
;;; <関数名>     : KCGetZaiF
;;; <処理概要>   : 材質記号から素材Fを取得する
;;; <戻り値>     : 素材F(数値)
;;; <作成>       : 01/01/15 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun KCGetZaiF (
  &ZaiCode ; 材質記号
  /
  #QRY$ #ZAIF
  )

  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "WT材質"
      (list
        (list "材質記号" &ZaiCode 'STR)
      )
    )
  )

  (if (and #qry$ (= (length #qry$) 1))
    (setq #ZaiF (nth 3 (car #qry$))) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ  ;2008/06/23 YM OK
  ;  else
    (progn ; WEB版ダイアログ表示しない 03/02/04 YM ADD
      (if (= CG_AUTOMODE 2) ; 02/09/02 YM WEB版自動ﾓｰﾄﾞは強制終了
        (*error*)
      ; else
        (progn
          (CFAlertMsg (strcat "材質記号が不正です。" "\n材質記号: " &ZaiCode))
          (setq #ZaiF nil)
        )
      );_if
    )
  );_if
  #ZaiF
);KCGetZaiF

;;;<HOM>*************************************************************************
;;; <関数名>    : KPChangeArea$
;;; <処理概要>  : 外形点列の指定側を指定ｻｲｽﾞ分拡大縮小
;;; <戻り値>    : 点列(ﾘｽﾄ)
;;; <作成>      : 01/03/30 YM
;;; <備考>      : 点列はPMEN2外形ﾎﾟﾘﾗｲﾝからとり、ｼﾝﾎﾞﾙ位置から時計まわりの順
;点列(通常ｷｬﾋﾞ4点,ｺｰﾅｰｷｬﾋﾞ6点)と変更したい側("L","R","U","D")と変更ｻｲｽﾞ
;       "U"
;   @----------+
;   | 真上から |
;"L"|          |"R"
;   |          |
;   +----------+
;      "D"
;;;*************************************************************************>MOH<
(defun KPChangeArea$ (
  &pt$
  &SIDE
  &SIZE
  /
  #KOSU #P1 #P2 #P3 #P4 #P5 #P6 #PT$
  #P11 #P22 #P33 #P44 #P55 #P66
  )
  (setq #kosu (length &pt$))
  (cond
    ((= #kosu 4)
      (setq #p1 (nth 0 &pt$))
      (setq #p2 (nth 1 &pt$))
      (setq #p3 (nth 2 &pt$))
      (setq #p4 (nth 3 &pt$))
      (cond
        ((= &SIDE "L")
          (setq #p11 (polar #p1 (angle #p2 #p1) &SIZE))
          (setq #p44 (polar #p4 (angle #p2 #p1) &SIZE))
          (setq #pt$ (list #p11 #p2 #p3 #p44))
        )
        ((= &SIDE "R")
          (setq #p22 (polar #p2 (angle #p1 #p2) &SIZE))
          (setq #p33 (polar #p3 (angle #p1 #p2) &SIZE))
          (setq #pt$ (list #p1 #p22 #p33 #p4))
        )
        ((= &SIDE "U")
          (setq #p11 (polar #p1 (angle #p3 #p2) &SIZE))
          (setq #p22 (polar #p2 (angle #p3 #p2) &SIZE))
          (setq #pt$ (list #p11 #p22 #p3 #p4))
        )
        ((= &SIDE "D")
          (setq #p33 (polar #p3 (angle #p2 #p3) &SIZE))
          (setq #p44 (polar #p4 (angle #p2 #p3) &SIZE))
          (setq #pt$ (list #p1 #p2 #p33 #p44))
        )
      );_cond
    )
    ((= #kosu 6)
      (setq #p1 (nth 0 &pt$))
      (setq #p2 (nth 1 &pt$))
      (setq #p3 (nth 2 &pt$))
      (setq #p4 (nth 3 &pt$))
      (setq #p5 (nth 4 &pt$))
      (setq #p6 (nth 5 &pt$))
      (cond
        ((= &SIDE "L")
          (setq #p11 (polar #p1 (angle #p2 #p1) &SIZE))
          (setq #p66 (polar #p6 (angle #p2 #p1) &SIZE))
          (setq #pt$ (list #p11 #p2 #p3 #p4 #p5 #p66))
        )
        ((= &SIDE "R")
          (setq #p22 (polar #p2 (angle #p1 #p2) &SIZE))
          (setq #p33 (polar #p3 (angle #p1 #p2) &SIZE))
          (setq #pt$ (list #p1 #p22 #p33 #p4 #p5 #p6))
        )
        ((= &SIDE "U")
          (setq #p11 (polar #p1 (angle #p3 #p2) &SIZE))
          (setq #p22 (polar #p2 (angle #p3 #p2) &SIZE))
          (setq #pt$ (list #p11 #p22 #p3 #p4 #p5 #p6))
        )
        ((= &SIDE "D")
          (setq #p55 (polar #p5 (angle #p2 #p3) &SIZE))
          (setq #p66 (polar #p6 (angle #p2 #p3) &SIZE))
          (setq #pt$ (list #p1 #p2 #p3 #p4 #p55 #p66))
        )
      );_cond
    )
  );_cond
  #pt$
);KPChangeArea$

;;;<HOM>***********************************************************************
;;; <関数名>    : GetCenterPT3D
;;; <処理概要>  : 2･の中点を返す
;;; <戻り値>    : 3D座標
;;; <作成>      : 01/04/04 YM
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun GetCenterPT (
  &p1
  &p2
  /
  #pt #X #Y #Z
  )
  (setq #pt (mapcar '+ &p1 &p2))
  (setq #x (* (car  #pt) 0.5))
  (setq #y (* (cadr #pt) 0.5))
  (if (caddr #pt)
    (progn
      (setq #z (* (caddr #pt) 0.5))
      (setq #pt (list #x #y #z))
    )
    (setq #pt (list #x #y))
  );_if
  #pt
);GetCenterPT

;;;<HOM>*************************************************************************
;;; <関数名>     : RemoveSameDirectPT
;;; <処理概要>   : 点列ﾘｽﾄの任意の隣り合う３点が同一直線上にある場合、点を削除する
;;; <戻り値>     : 不要点削除後の点列ﾘｽﾄ
;;; <作成>       : 01/06/26 YM
;;; <備考>       : 未使用
;;;*************************************************************************>MOH<
(defun RemoveSameDirectPT (
  &pt$ ; WT外形領域点列
  /
  #ANG1 #ANG2 #I #P1 #P2 #P3 #PT$ #RET_PT$
  )
  (setq #ret_pt$ '())
  (setq #pt$ (append (list (last &pt$)) &pt$ (list (nth 0 &pt$)))) ; 前後に2点追加する
  (setq #i 0)
  (repeat (length &pt$)
    ; 連続する3点
    (setq #p1 (nth (+ #i 0) #pt$))
    (setq #p2 (nth (+ #i 1) #pt$))
    (setq #p3 (nth (+ #i 2) #pt$))
    (setq #ang1 (angle #p1 #p2))
    (setq #ang2 (angle #p2 #p3))
    (if (equal #ang1 #ang2 0.001)
      nil ; 同一直線上にあるため真ん中の点を削除しないといけない
      (setq #ret_pt$ (append #ret_pt$ (list #p2))) ; 真ん中の点を追加していく
    );_if
    (setq #i (1+ #i))
  )
  #ret_pt$
);RemoveSameDirectPT

;;;<HOM>*************************************************************************
;;; <関数名>     : RemoveSamePT
;;; <処理概要>   : 点列ﾘｽﾄの任意の隣り合う2点が同一である場合点を削除する
;;; <戻り値>     : 不要点削除後の点列ﾘｽﾄ
;;; <作成>       : 01/06/26 YM
;;; <備考>       :
;;;*************************************************************************>MOH<
(defun RemoveSamePT (
  &pt$ ; WT外形領域点列
  /
  #I #P1 #P2 #PT$ #RET_PT$
  )
  (setq #ret_pt$ '())
  (setq #pt$ (append (list (last &pt$)) &pt$)) ; 前に1点追加する
  (setq #i 0)
  (repeat (length &pt$)
    ; 連続する2点
    (setq #p1 (nth (+ #i 0) #pt$))
    (setq #p2 (nth (+ #i 1) #pt$))
    (if (equal (distance #p1 #p2) 0 0.001)
      nil ; 同一点であるため点を削除
      (setq #ret_pt$ (append #ret_pt$ (list #p2))) ; 2つ目の点を追加していく
    );_if
    (setq #i (1+ #i))
  )
  #ret_pt$
);RemoveSamePT

;<HOM>*************************************************************************
; <関数名>    : KPCheckMiniKitchen
; <処理概要>  : Lipple でｺﾝﾛｷｬﾋﾞがある=T それ以外=nil
; <戻り値>    : T or nil
; <作成>      : 01/06/29 YM
;*************************************************************************>MOH<
(defun KPCheckMiniKitchen (
  &sym$ ; 寸法を作図するシンボル図形名（ベース アッパーその他）
  /
  #EXIST
  )
  (setq #EXIST nil) ; 図面上にｺﾝﾛｷｬﾋﾞがある
  (foreach #sym &sym$
    (if (and #sym  ; 01/07/19 TM ADD
             (= CG_SKK_ONE_CAB (CFGetSymSKKCode #sym 1))
             (= CG_SKK_TWO_BAS (CFGetSymSKKCode #sym 2))
             (= CG_SKK_THR_GAS (CFGetSymSKKCode #sym 3)))
      (setq #EXIST T) ; 図面上にｺﾝﾛｷｬﾋﾞ(113)がある
    );_if
  )

  (if (and (equal (KPGetSinaType) 2 0.1) #EXIST)
    T
    nil
  );_if
);KPCheckMiniKitchen











;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; 以下ﾁｪｯｸ用隠しｺﾏﾝﾄﾞ
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:ppp( / )
  ; 01/09/21 YM 開発用
  (setvar "pickfirst" 1)
  (setvar "pickauto" 1)
  (setvar "GRIPS"     1)
)

;;;<HOM>*************************************************************************
;;; <関数名>    : c:all
;;; <処理概要>  : 選択した図形のｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰの全図形のﾀｲﾌﾟ、ﾊﾝﾄﾞﾙ、拡張ﾃﾞｰﾀを表示
;;;             : "G_LSYM"がない部材の拡張ﾃﾞｰﾀも表示
;;; <作成>      : 99/12/02  00/02/11 修正 00/02/24 修正 YM
;;;*************************************************************************>MOH<
(defun c:all(
  /
  #DATE_TIME #EN #FIL #HAND #I #J #K #KOSU #LIS #NAME1 #NAME2 #SS #SYM
  #TYPE #XD #XD2 #XD_LSYM #XD_SYM #210 #LAYER #ZUKEI
  )

  (princ "部材を選択: ")
  (setq #en T)
  (while #en
    (setq #en (car (entsel)))
    (if (= #en nil)
      (progn
        (CFAlertErr "部材が選択されませんでした")
        (setq #en T)
      )
      (progn
        (setq #sym (SearchGroupSym #en))   ; ｼﾝﾎﾞﾙ図形名 ; 親図形名
        (setq #ZUKEI #en)
        (setq #en nil) ; 何か選択された
      )
    )
  );while

  ; ﾌｧｲﾙOPEN
  (setq #fil (open (strcat CG_SYSPATH "all.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n" #fil)

  (if #sym
    (progn ; ｼﾝﾎﾞﾙ図形
      (setq #ss (CFGetSameGroupSS #sym)) ; 全グループメンバー図形
      (if (or (= #ss nil)(= (sslength #ss) 0))
        (progn
          (CFAlertErr "ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰがありません")
          (if #fil (close #fil))
          (quit)
        )
      );_if

      (princ "-----------------------------------------------------------------"  #fil)
      (setq #xd_LSYM (car (cdr (assoc -3 (entget #sym '("G_LSYM"))))))
      (setq #xd_SYM  (car (cdr (assoc -3 (entget #sym '("G_SYM"))))))
      (setq #name1
        (list
          ":G_LSYM ｼﾝﾎﾞﾙ基準点                       ";0
          ":本体図形ID    :10ﾊﾞｲﾄ(dwgﾌｧｲﾙ名)         ";1
          ":挿入点        :配置基点 x,y,z            ";2
          ":回転角度      :ﾗｼﾞｱﾝ                     ";3
          ":工種記号      :2ﾊﾞｲﾄ                     ";4
          ":ｼﾘｰｽﾞ記号     :2ﾊﾞｲﾄ                     ";5
          ":品番名称      :20ﾊﾞｲﾄ                    ";6
          ":L/R区分       :Z,L,R                     ";7
          ":扉図形ID      :10ﾊﾞｲﾄ                    ";8
          ":扉開き図形ID  :10ﾊﾞｲﾄ                    ";9
          ":性格ｺｰﾄﾞ      :品番情報の性格ｺｰﾄﾞ       ";10
          ":複合ﾌﾗｸﾞ      :0(単独),1(複合),2(OP部材)";11
          ":配置順番号    :配置順番号(1～)          ";12
          ":用途番号      :0～99                    ";13
          ":寸法Ｈ        :品番図形DBの登録H寸法値  ";14
          ":断面指示有無  :0(なし),1(あり)          ";15
          ":分類          :キッチン(A) or 収納(D)   ";16
      ))
      (setq #name2
        (list
          ":G_SYM                                    "
          ":ｼﾝﾎﾞﾙ名称                                "
          ":ｺﾒﾝﾄ１                                   "
          ":ｺﾒﾝﾄ２                                   "
          ":ｼﾝﾎﾞﾙ基準値W                             "
          ":ｼﾝﾎﾞﾙ基準値D                             "
          ":ｼﾝﾎﾞﾙ基準値H                             "
          ":ｼﾝﾎﾞﾙ取付高さ                            "
          ":入力方法                                 "
          ":W方向ﾌﾗｸﾞ                                "
          ":D方向ﾌﾗｸﾞ                               "
          ":H方向ﾌﾗｸﾞ                               "
          ":伸縮ﾌﾗｸﾞW                               "
          ":伸縮ﾌﾗｸﾞD                               "
          ":伸縮ﾌﾗｸﾞH                               "
          ":ﾌﾞﾚｰｸﾗｲﾝ数W                             "
          ":ﾌﾞﾚｰｸﾗｲﾝ数D                             "
          ":ﾌﾞﾚｰｸﾗｲﾝ数H                             "
      ))

      (setq #j 0) ; 拡張データ"G_LSYM"
      (repeat (length #xd_LSYM)
        (princ "\n[" #fil)(princ #j #fil)(princ "]" #fil)
        (princ (nth #j #name1) #fil)
        (princ (nth #j #xd_LSYM) #fil)
        (setq #j (1+ #j))
      )
      (princ "\n -----------------------------------------------------------------"  #fil)
      (setq #j 0) ; 拡張データ"G_SYM"
      (repeat (length #xd_SYM)
        (princ "\n[" #fil)(princ #j #fil)(princ "]" #fil)
        (princ (nth #j #name2) #fil)
        (princ (nth #j #xd_SYM) #fil)
        (setq #j (1+ #j))
      )
      (princ "\n -----------------------------------------------------------------"  #fil)
      (princ #fil)
    )
    ;else
    (progn  ; "G_LSYM"なしの場合  ﾜｰｸﾄｯﾌﾟなど
      (setq #xd (assoc -3 (entget #ZUKEI '("*"))))
      (setq #xd (cdr #xd))
      (setq #type (cdr (assoc 0 (entget #ZUKEI))))
      (setq #hand (cdr (assoc 5 (entget #ZUKEI)))) ; 図形ﾊﾝﾄﾞﾙ

      (if #xd
        (progn
          (princ "\n" #fil)
          (princ #ZUKEI #fil)
          (princ "  ﾀｲﾌﾟ=" #fil) (princ #type #fil)
          (princ "  ﾊﾝﾄﾞﾙ=" #fil)(princ #hand #fil)
          (setq #j 0)
          (repeat (length #xd)
            (setq #xd2 (nth #j #xd))
            (cond
              ((= "G_WRKT" (car #xd2))
                (setq #name1
                  (list
                    ":G_WRKT ﾜｰｸﾄｯﾌﾟ                               "
                    ":工種記号                                     "
                    ":SERIES記号                                   "
                    ":材質記号                                     "
                    ":形状タイプ１        0:Ｉ型 1:Ｌ型 2:U型      "
                    ":形状タイプ２        F:フラット D:段差        "
                    ":ｼｽﾃﾑﾎﾟｰﾙ穴あり=P                             "
                    ":WTセットコード    隣接する全てのWTにｾｯﾄ      "
                    ":左右ｶｯﾄﾀｲﾌﾟ 0:なし,1:VPK,2:X,3:H,4:段差      "
                    ":下端取付け高さ   ワークトップ下面の位置      "
                    ":方向ｶｯﾄのｶｯﾄ方向 S:ｼﾝｸ側 G:ｺﾝﾛ側 空白:方向無 "
                    ":カウンター厚さ       ワークトップの厚み      "
                    ":★未使用★                                   "
                    ":バックガード高さ                             "
                    ":バックガード厚さ                             "
                    ":★未使用★                                   "
                    ":前垂れ高さ                                   "
                    ":前垂れ厚さ                                   "
                    ":前垂れシフト量                               "
                    ":加工穴データ数  1～3                         "
                    ":加工穴図形ハンドル１ ｼﾝｸ穴G_HOLEﾊﾝﾄﾞﾙ        "
                    ":加工穴図形ハンドル２                         "
                    ":加工穴図形ハンドル３                         "
                    ":水栓穴データ数  1～7                         "
                    ":水栓穴図形ハンドル１水栓穴G_HOLEﾊﾝﾄﾞﾙ        "
                    ":水栓穴図形ハンドル２                         "
                    ":水栓穴図形ハンドル３                         "
                    ":水栓穴図形ハンドル４                         "
                    ":水栓穴図形ハンドル５                         "
                    ":水栓穴図形ハンドル６                         "
                    ":水栓穴図形ハンドル７                         "
                    ":左右勝手フラグ  L:左 R:右 不明==>R           "
                    ":ﾌﾙﾌﾗｯﾄ,ｾﾐﾌﾗｯﾄ判定用                          "
                    ":コーナー基点   ワークトップ底面の左上点      "
                    ":GSM図形をWTに変更した場合:1 それ以外0        "
                    ":GSM図形をWTに変更した場合のｶｳﾝﾀｰ品番         "
                    ":★未使用★                                   "
                    ":★未使用★                                   "
                    ":★未使用★                                   "
                    ":WT底面図形ハンドル   WT押し出し用ﾎﾟﾘﾗｲﾝ      "
                    ":シンク側奥行                                 "
                    ":★未使用★                                   "
                    ":★未使用★                                   "
                    ":間口1 ｶｯﾄ,勝手,ｼﾝｸ位置等に関係ない間口1      "
                    ":間口2 ｶｯﾄ,勝手,ｼﾝｸ位置等に関係ない間口2      "
                    ":間口3 ｶｯﾄ,勝手,ｼﾝｸ位置等に関係ない間口3      "
                    ":品　名　　                                   "
                    ":備　考    　　                               "
                    ":ｶｯﾄ相手WTﾊﾝﾄﾞﾙ左                             "
                    ":ｶｯﾄ相手WTﾊﾝﾄﾞﾙ右                             "
                    ":BG SOLID図形ﾊﾝﾄﾞﾙ1 BG分離はBG SOLID1         "
                    ":BG SOLID図形ﾊﾝﾄﾞﾙ2 BG分離はBG SOLID2         "
                    ":FG 底面図形ﾊﾝﾄﾞﾙ1  FG底面ﾎﾟﾘﾗｲﾝﾊﾝﾄﾞﾙ1        "
                    ":FG 底面図形ﾊﾝﾄﾞﾙ2  FG底面ﾎﾟﾘﾗｲﾝﾊﾝﾄﾞﾙ2        "
                    ":間口伸縮量1                                  "
                    ":間口伸縮量2                                  "
                    ":WTの幅   ｽﾃﾝﾚｽL型対応ﾘｽﾄ形式(2400 1650)      "
                    ":WTの伸縮量                                   "
                    ":WTの奥行 ｽﾃﾝﾚｽL型対応ﾘｽﾄ形式(750 650)        "
                    ":特注フラグ 特注:TOKU  規格:空白              "
                    ":段差部分も含めたWT外形PLINEﾊﾝﾄﾞﾙ             "
                    ":カットライン図形ハンドル1                    "
                    ":カットライン図形ハンドル2                    "
                    ":カットライン図形ハンドル3   U型で使用        "
                    ":カットライン図形ハンドル4 　U型で使用        "
                ))

                (setq #k 0) ; 拡張データ"G_WRKT"
                (princ "\n -----------------------------------------------------------------"  #fil)
                (repeat (length #xd2)
                  (princ "\n[" #fil)(princ #k #fil)(princ "]" #fil)
                  (princ (nth #k #name1) #fil)
                  (princ (nth #k #xd2) #fil)
                  (setq #k (1+ #k))
                )
              )
              ((= "G_WTSET" (car #xd2))
                (setq #name2
                  (list
                    ":G_WTSET ﾜｰｸﾄｯﾌﾟ情報                          "
                    ":特注フラグ    0:特注 1:特注以外              "
                    ":品番名称      WT品番                         "
                    ":取付高さ      827など                        "
                    ":金額                                         "
                    ":品名                                         "
                    ":巾                                           "
                    ":高さ                                         "
                    ":奥行                                         "
                    ":特注コード                                   "
                    ":予備２                                       "
                    ":予備３                                       "
                    ":WT穴寸法情報個数                             "
                    ":穴寸法1 左から穴までの寸法1                  "
                    ":穴寸法2 左から穴までの寸法2                  "
                    ":穴寸法3 左から穴までの寸法3                  "
                    ":穴寸法4 左から穴までの寸法4                  "
                    ":穴寸法5 左から穴までの寸法5                  "
                    ":穴寸法6 左から穴までの寸法6                  "
                    ":穴寸法7 左から穴までの寸法7                  "
                    ":穴寸法8 左から穴までの寸法8                  "
                    ":穴寸法8 左から穴までの寸法8                  "
                    ":穴寸法9 左から穴までの寸法9                  "
                    ":                                             "
                    ":                                             "
                    ":                                             "
                    ":                                             "
                ))
                (setq #k 0) ; 拡張データ"G_WTSET"
                (princ "\n -----------------------------------------------------------------"  #fil)
                (repeat (length #xd2)
                  (princ "\n[" #fil)(princ #k #fil)(princ "]" #fil)
                  (princ (nth #k #name2) #fil)
                  (princ (nth #k #xd2) #fil)
                  (setq #k (1+ #k))
                )
              )
              (T ; 通常
                (setq #k 0)
                (princ "\n -----------------------------------------------------------------" #fil)
                (repeat (length #xd2)
                  (princ "\n[" #fil)(princ #k #fil)(princ "]" #fil)(princ (nth #k #xd2) #fil)
                  (setq #k (1+ #k))
                )
              )
            );_cond

            (setq #j (1+ #j))
          );repeat
          (princ "\n -----------------------------------------------------------------" #fil)
        )
      );_if
    )
  );_if

  (if (/= #ss nil)
    (progn
;;;      (command "_.change" #ss "" "P" "C" "1" "") ; 色付け
      (setq #lis (CMN_ss_to_en #ss)) ; 選択ｾｯﾄ-->図形名ﾘｽﾄ
      (setq #kosu (length #lis)) ; ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰの総数

      (if #lis ; "G_LSYM"ありの場合
        (progn
          (princ "\nｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰの総数: " #fil)
          (princ #kosu #fil)
          (princ "\n" #fil)(princ "\n <拡張ﾃﾞｰﾀ>" #fil)(princ "\n" #fil)

          (setq #i 0)
          (foreach en #lis ; 全グループメンバー対象
            (setq #xd (assoc -3 (entget en '("*"))))
            (setq #type  (cdr (assoc 0   (entget en)))) ; 図形ﾀｲﾌﾟ
            (setq #hand  (cdr (assoc 5   (entget en)))) ; 図形ﾊﾝﾄﾞﾙ
            (setq #layer (cdr (assoc 8   (entget en)))) ; 画層
            (setq #210   (cdr (assoc 210 (entget en)))) ; 押し出し方向

            (if #xd
              (progn
                (princ "\n *** NO." #fil)(princ #i #fil)(princ " ***" #fil)
                (princ en #fil)
                (princ "\n ﾊﾝﾄﾞﾙ = " #fil)   (princ #hand  #fil)
                (princ " ﾀｲﾌﾟ = "    #fil)   (princ #type  #fil)
                (princ " 画層 = "    #fil)   (princ #layer #fil)
                (princ " 押出し方向 = " #fil)(princ #210   #fil)
                (setq #xd (cdr #xd))

                (setq #j 0)
                (repeat (length #xd)
                  (setq #xd2 (nth #j #xd))
                  (setq #k 0)
                  (repeat (length #xd2)
                    (princ "\n[" #fil)(princ #k #fil)(princ "]" #fil)(princ (nth #k #xd2) #fil) ; [12](1070 . 4)
                    (setq #k (1+ #k))
                  )
                  (setq #j (1+ #j))
                )
                (princ "\n -----------------------------------------------------------------" #fil)
              )
            );_if

            (setq #i (1+ #i))
          );_(foreach
        )
      );_if
    )
  );_if

  (if #fil
    (progn
      (close #fil)
      (princ "\nﾌｧｲﾙに書き込みました.")
      (startapp "notepad.exe" (strcat CG_SYSPATH "all.txt"))
    )
  );_if
  (princ)
);c:all

;;;<HOM>*************************************************************************
;;; <関数名>    : c:SelXd
;;; <処理概要>  : 選択した図形のｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰの拡張ﾃﾞｰﾀのうち指定したものを赤くする
;;; <作成>      : 01/08/03 YM
;;;*************************************************************************>MOH<
(defun c:SelXd(
  /
  #APP #APP$ #APP_NO #DUM #EN #J #K #SS #SS_LIS$ #SYM #XD #XD2
  #APP$$ #COL #EG$ #HAND #RET$
  )
  (C:ALP) ; undo "M" 全画層表示
  (setvar "PDSIZE" 50)
  (princ "ｼﾝﾎﾞﾙをもつ部材を選択: ")
  (setq #en T)
  (while #en
    (setq #en (car (entsel)))
    (if (= #en nil)
      (progn
        (CFAlertErr "部材が選択されませんでした")
        (setq #en T)
      )
      (progn
        (setq #sym (SearchGroupSym #en)) ; ｼﾝﾎﾞﾙ図形名
        (if #sym
          (setq #en nil)
          (progn
            (setq #en T)
            (CFAlertErr "G_SYMがありません")
          )
        );_if
      )
    )
  );while

  ; 全グループメンバー図形
  (setq #ss (CFGetSameGroupSS #sym))
  (if (or (= #ss nil)(= (sslength #ss) 0))
    (progn
      (CFAlertErr "ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰがありません")
      (quit)
    )
  );_if

;;;  (command "chprop" #ss "" "C" "7" "") ; 白

  (setq #ss_lis$ (CMN_ss_to_en #ss)) ; 選択ｾｯﾄ-->図形名ﾘｽﾄ

  (setq #APP$$ nil)
  (foreach en #ss_lis$ ; 全グループメンバー対象
    (setq #eg$ (entget en '("*")))
    (setq #xd (assoc -3 #eg$))
    (if #xd ; Xdataあり
      (progn
        (setq #xd (cdr #xd))
        (setq #j 0)
        (repeat (length #xd) ; Xdata複数のときﾙｰﾌﾟ
          (setq #xd2 (nth #j #xd))
          (setq #k 0)
          (setq #APP (nth 0 #xd2))
          (if (or (= #APP "G_PMEN")(= #APP "G_PTEN")(= #APP "G_PLIN")(= #APP "G_MEJI"))
            (progn
              (setq #hand (cdr (assoc 5 #eg$)))
              (setq #dum (nth 1 #xd2))
              (if (= (car #dum) 1070)
                (setq #APP_NO (cdr #dum))
                (setq #APP_NO nil)
              );_if
              (setq #APP$$ (append #APP$$ (list (list #APP #APP_NO #hand))))
            )
          )
          (setq #j (1+ #j))
        )
      )
    );_if
  );_(foreach

  (setq #APP$$ (ListSortLevel2 #APP$$ 0 1))

  (setq #ret$ (XdataDlg #APP$$)) ; ダイアログボックスの表示
  (if (= #ret$ nil)
    (progn
      (command "undo" "b" )
      (quit)
    )
    (progn
      (setq #hand (nth 0 #ret$)) ; ﾊﾝﾄﾞﾙ
      (setq #en (handent #hand))
      (setq #Col  (nth 1 #ret$)) ; 色
      (command "chprop" #en "" "C" #Col "") ; 白
    )
  );_if

  (princ)
);c:SelXd

;;;<HOM>*************************************************************************
;;; <関数名>    : XdataDlg
;;; <処理概要>  : Xdata選択ダイアログ
;;; <戻り値>    : (ﾊﾝﾄﾞﾙ,色ｺｰﾄﾞ)
;;; <作成>      : 01/08/03 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun XdataDlg (
  &APP$$
  /
  #DCL_ID #POP$ #RET$
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #COL #HAND
            )
            (setq #hand (nth (atoi (get_tile "Xdata")) #pop$))
            (cond
              ((= "1" (get_tile "radio1"))(setq #Col "1"))
              ((= "1" (get_tile "radio2"))(setq #Col "2"))
              ((= "1" (get_tile "radio3"))(setq #Col "3"))
              ((= "1" (get_tile "radio4"))(setq #Col "4"))
              ((= "1" (get_tile "radio5"))(setq #Col "5"))
              ((= "1" (get_tile "radio6"))(setq #Col "6"))
            );_cond
            (done_dialog)
            (list #hand #Col)
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( / ) ; 材質ポップアップリスト
            (setq #pop$ '())
            (start_list "Xdata" 3)
            (foreach APP$ &APP$$
              (add_list (strcat (nth 0 APP$) "    " (itoa (nth 1 APP$)) "    " (nth 2 APP$)))
              (setq #pop$ (append #pop$ (list (nth 2 APP$)))) ; ﾊﾝﾄﾞﾙのみ保存
            )
            (end_list)
            (set_tile "Xdata" "0") ; 最初にﾌｫｰｶｽ
            (princ)
          );##Addpop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "XdataDlg" #dcl_id)) (exit))

  ;;; ﾎﾟｯﾌﾟｱｯﾌﾟﾘｽﾄ
  (##Addpop)
  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret$
);XdataDlg

;;;<HOM>*************************************************************************
;;; <関数名>    : c:IID
;;; <処理概要>  : 選択した図形の図形ID表示
;;; <作成>      : 06/28 YM
;;;*************************************************************************>MOH<
(defun c:IID(
  /
  #EN #SYM #ZUKEI_ID
  )
  (princ "部材を選択: ")
  (setq #en (car (entsel)))
  (if (= #en nil)
    (progn
      (CFAlertErr "部材が選択されませんでした")(quit)
    )
  )

  (setq #sym (SearchGroupSym #en))   ; ｼﾝﾎﾞﾙ図形名 ; 親図形名
  (if #sym
    (progn
      (setq #ZUKEI_ID (nth 0 (CFGetXData #sym "G_LSYM"))) ; 図形ID
      (princ "\n図形ID= ")(princ #ZUKEI_ID)(terpri)
    );_(progn
    (progn  ; "G_LSYM"なしの場合  ﾜｰｸﾄｯﾌﾟなど
      (CFAlertErr "ｼﾝﾎﾞﾙがありません")(quit)
    );_(progn
  );_(if
  (princ)
);c:IID



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; KPCAD XLINEをｸﾞﾙｰﾌﾟに追加  00/03/01 YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:ADDG(
 /
  #300 #EN2
 )
  (setq #300 (SKGetGroupName (car (entsel "\nｸﾞﾙｰﾌﾟのﾒﾝﾊﾞｰ図形を選択: "))))
  (setq #en2 (car (entsel "\nｸﾞﾙｰﾌﾟに追加したいﾌﾞﾚｰｸﾗｲﾝを選択: ")))
  (if (= (cdr (assoc 0 (entget #en2))) "XLINE")
    (progn
      (command "-group" "A" #300 #en2 "")
      (CFSetXData #en2 "G_BRK"
        (list 3)
      )
      (princ "\nｸﾞﾙｰﾌﾟに追加しました.")
    )
    (progn
      (princ "\nXLINEではありません。")
    )
  )
  (princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; KPCAD 選択図形のﾀｲﾌﾟ,ﾊﾝﾄﾞﾙ,拡張ﾃﾞｰﾀを表示  00/02/25 YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:et( / #et)
  (setq #et (entget (car (entsel "図形を選択: ")) '("*") ))
;;;  (terpri)(princ (assoc 0 #et))
;;;  (terpri)(princ (assoc 5 #et)) ; ﾊﾝﾄﾞﾙ
;;;  (terpri)(princ (assoc -3 #et)) ; 拡張ﾃﾞｰﾀ
 (terpri)(princ #et)           ; 図形情報
  (princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; KPCAD 全ての画層を表示  pdmode=34 00/02/25 YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:ALP( / )
  (command "undo" "M") ; ﾏｰｸをつける
  (command "-layer" "T" "*" "ON" "*" "U" "*" "")
  (command "pdmode" "34")
  (command "regen")
  (princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; "G_PMEN"部材に赤色(1)をつける
;;; "G_PMEN"部材に赤色(2)をつける
;;; "G_BODY"部材に緑色(3)をつける  00/02/25 YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:TEST_PRIM( / #EN #I #SS)

  (command "undo" "M") ; ﾏｰｸをつける
  (C:ALP)
  (setq #ss (ssget "X"))   ; 図面上すべての図形
  (if (= #ss nil)(quit))
  (if (= 0 (sslength #ss))(quit))

  (command "chprop" #ss "" "C" "7" "") ; 白

;;;----------------------------------------------------
  (setq #ss (ssget "X" '((-3 ("G_PMEN")))))
  (if (/= #ss nil)
    (progn
      (if (< 0 (sslength #ss))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            (command "chprop" #en "" "C" "1" "") ; 赤
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if

;;;----------------------------------------------------
  (setq #ss (ssget "X" '((-3 ("G_PRIM")))))
  (if (/= #ss nil)
    (progn
      (if (< 0 (sslength #ss))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            (command "chprop" #en "" "C" "2" "") ; 黄
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if

;;;----------------------------------------------------
  (setq #ss (ssget "X" '((-3 ("G_BODY")))))
  (if (/= #ss nil)
    (progn
      (if (< 0 (sslength #ss))
        (progn
          (setq #i 0)
          (repeat (sslength #ss)
            (setq #en (ssname #ss #i))
            (command "chprop" #en "" "C" "3" "") ; 緑
            (setq #i (1+ #i))
          )
        )
      );_if
    )
  );_if

);_defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 図形ﾊﾝﾄﾞﾙを入力--->その図形が赤になる  00/02/28 YM
;;; 元に戻すには(command "undo" "B")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:HCOL ( / #EN #HAND #SS)

;;;  (princ "\nしばらくお待ちください...")
  (command "undo" "M") ; ﾏｰｸをつける
;;;  (C:ALP)
;;;  (setq #ss (ssget "X"))   ; 図面上すべての図形
;;;  (if (= #ss nil)(quit))
;;;  (if (= 0 (sslength #ss))(quit))
;;;
;;;  (command "chprop" #ss "" "C" "7" "") ; 白

  (setq #hand (getstring "\nﾊﾝﾄﾞﾙ入力: "))
  (setq #en (handent #hand))

  (command "chprop" #en "" "C" "1" "") ; 赤

  (princ "\n///////////////////")
  (princ "\n\"UU\"で元に戻る")
  (princ "\n///////////////////")
  (princ)
);_defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 表示画層の設定(プラン検索同様)  00/03/17 YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:ddd ( / )

;;;03/09/29YM@MOD  ;// 表示画層の設定
;;;03/09/29YM@MOD  (command "_layer"
;;;03/09/29YM@MOD    "F"   "*"                ;全ての画層をフリーズ
;;;03/09/29YM@MOD    "T"   "Z_00*"            ;  Z_00立体ソリッド画層のフリーズ解除
;;;03/09/29YM@MOD    "T"   "N_*"              ;  N_*シンボル原点図形画層のフリーズ解除
;;;03/09/29YM@MOD    "T"   "M_*"              ;  M_*目地領域図形画層の解除
;;;03/09/29YM@MOD    "T"   "0"                ;  "0"画層の解除
;;;03/09/29YM@MOD    "ON"  "M_*"              ;  M_*目地領域図形画層の表示
;;;03/09/29YM@MOD    "OFF" "N_B*" ""          ;  N_B*ブレークライン図形の非表示
;;;03/09/29YM@MOD  )
;;;03/09/29YM@MOD  (command "_.layer" "T" "Z_KUTAI" "") ; 01/02/20 YM ADD

  (SetLayer);03/09/29 YM MOD

  (command "pdmode" "0")
  (command "regen")
)

;;;<HOM>*************************************************************************
;;; <関数名>    : c:clZ
;;; <処理概要>  : 図面のゴミ削除
;;;               ｼﾝﾎﾞﾙを伴わない孤立PMEN図形および、あればそのｸﾞﾙｰﾌﾟを削除
;;; <戻り値>    : なし
;;; <作成>      : 2000.6.16 YM
;;;*************************************************************************>MOH<
(defun c:clZ(
  /
  #ELM #FLG #I #SS #SS_PMEN #SYM #MSGFLG
  )
  (setq #ss_PMEN (ssget "X" '((-3 ("G_PMEN"))))) ; G_PMEN 図形選択ｾｯﾄ
  (if (= #ss_PMEN nil) (setq #ss_PMEN (ssadd)))

  (setq #MSGflg nil)
  (setq #i 0)
  (repeat (sslength #ss_PMEN)
    (setq #flg nil)
    (setq #elm (ssname #ss_PMEN #i))
    (setq #sym (SearchGroupSym #elm))
    (if (= #sym nil)
      (progn ; ｼﾝﾎﾞﾙがない
        (setq #ss (CFGetSameGroupSS #elm))
        (if #ss
          (if (> (sslength #ss) 0)
            (progn
              (command "_.erase" #ss "") ; 削除処理
              (princ "\n壊れた図形を削除しました。")
              (setq #flg T)
              (setq #MSGflg T)
            )
          );_if
        );_if
        (if (and (entget #elm)(= #flg nil))
          (progn
            (command "_.erase" #elm "") ; 削除処理
            (princ "\n壊れた図形を削除しました。")
            (setq #MSGflg T)
          )
        );_if
      )
    );_if
    (setq #i (1+ #i))
  );_(repeat

  (if (= #MSGflg nil)
    (princ "\n壊れた図形はありませんでした。")
  );_if

  (princ)
);c:clZ

;;;<HOM>*************************************************************************
;;; <関数名>    : c:PTN
;;; <処理概要>  : 図面上で"G_PRIM"の底面図形が正しくｾｯﾄされていないｱｲﾃﾑの図形IDを探す
;;; <戻り値>    : なし
;;; <作成>      : 2000.4.8 YM
;;;*************************************************************************>MOH<
(defun c:PTN(
  /
  #ELM #FLG #I #MSG #SS_PRIM #SYM #TEI #XD #ZUKEI_ID
  )
  (princ)
  (princ "\n検索中...")
  (princ)
  (command "undo" "M") ; ﾏｰｸをつける
  (C:ALP) ; 画層解除
  (setq #ss_PRIM (ssget "X" '((-3 ("G_PRIM"))))) ; G_PRIM 図形選択ｾｯﾄ
  (if (= #ss_PRIM nil) (setq #ss_PRIM (ssadd)))
  (setq #i 0 #flg nil)
  (repeat (sslength #ss_PRIM)                    ; "G_LSYM"を持つもの
    (setq #elm (ssname #ss_PRIM #i))
    (setq #tei (nth 10 (CFGetXData #elm "G_PRIM")))  ; 底面図形名
    (if (or (= #tei nil) (= #tei "0"))   ; 不正あり
      (progn
        (setq #flg T)
        (setq #sym (SearchGroupSym #elm))        ;  #elm ; SOLID図形名
        (setq #ZUKEI_ID (nth 0 (CFGetXData #sym "G_LSYM"))) ; 図形ID
        (princ (strcat "\n図形ID = " #ZUKEI_ID))
      )
    );_if
    (setq #i (1+ #i))
  );_(repeat

  (if #flg
    (setq #msg "\n\"G_PRIM\"の底面図形が不正なアイテムがありました.\n関戸さんに図形IDを連絡してください.")
    (setq #msg "\n\図面上の\"G_PRIM\"は正常でした.")
  );_if
  (CFAlertMsg #msg)
  (command "undo" "B")
  (princ)
);c:PTN

;;;<HOM>*************************************************************************
;;; <関数名>    : c:PM2N
;;; <処理概要>  : 図面上で"G_PMEN"2がｾｯﾄされていないｱｲﾃﾑの図形IDを返す
;;; <戻り値>    : なし
;;; <作成>      : 2000.4.18 YM
;;;*************************************************************************>MOH<
(defun c:PM2N (
  /
  #ELM #FLG #I #MSG #ss_LSYM #SYM #TEI #XD #ZUKEI_ID #msg
  #EN #EN$ #LOOP #ZU_ID #J
  )
  (command "._zoom" "E")
  (princ)
  (princ "\nベースキャビを検索中...")
  (princ)
  (command "undo" "M") ; ﾏｰｸをつける
  (C:ALP) ; 画層解除
  (setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM"))))) ; G_LSYM 図形選択ｾｯﾄ

  (if (= #ss_LSYM nil) (setq #ss_LSYM (ssadd)))
  (setq #i 0 #flg nil)
  (repeat (sslength #ss_LSYM)                    ; "G_LSYM"を持つもの
    (setq #sym (ssname #ss_LSYM #i))

    (if (and (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)
             (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS))
      (progn
        (GroupInSolidChgCol2 #sym CG_InfoSymCol) ; 色を変える
        (setq #en$ (CFGetGroupEnt #sym))   ; 各ﾍﾞｰｽｷｬﾋﾞの同一ｸﾞﾙｰﾌﾟ
        (setq #j 0)
        (setq #loop T)
        (while (and #loop (< #j (length #en$))) ; PMEN2を検索する
          (setq #en (nth #j #en$))
          (if (= 2 (car (CFGetXData #en "G_PMEN")))
            (setq #loop nil) ; １つ見つけたらループを抜ける
          );_if
          (setq #j (1+ #j))
        );_(while

        (if #loop ; PMEN2がない
          (progn
            (setq #flg T)
            (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; 図形ID
            (setq #msg (strcat "\n 図形ID=" #zu_id "に PMEN2 がありません。"))
            (princ #msg)
          )
        );_if
        (GroupInSolidChgCol2 #sym "BYLAYER")
      )
    );_if

    (setq #i (1+ #i))
  );_(repeat

  (if #flg
    (setq #msg "\nPMEN2がセットされていないアイテムがありました.\n関戸さんに図形IDを連絡してください.")
    (setq #msg "\n\図面上のPMEN2は全て正常でした.")
  );_if
  (CFAlertMsg #msg)
  (command "undo" "B")
  (command "._zoom" "P")
  (princ)
);c:PTN

;//////////////////////////////////////////////////////////
;;; ﾎﾟﾘﾗｲﾝの頂点にﾎﾟｲﾝﾄを打って見えるようにする 07/14 YM
;//////////////////////////////////////////////////////////
(defun c:p000 (
  /
  #EN #ET$
  )
  (command "undo" "M") ; ﾏｰｸをつける
  (setq #en (car (entsel "\nﾎﾟﾘﾗｲﾝを指示: ")))
  (setq #et$ (entget #en))
  (foreach #et #et$
    (if (= (car #et) 10)
      (command "point" (cdr #et))
    )
  )
  (setvar "PDSIZE" 20)
  (setvar "PDMODE" 34)
  (command "regen")
  (princ)
);c:p000

;//////////////////////////////////////////////////////////
;;; 図形のｸﾞﾙｰﾌﾟ内でG_PMENのみ表示する 07/14 YM
;//////////////////////////////////////////////////////////
(defun c:p001 (
  /
  #ELM #I #SS #XD$
  )
  (setq #ss (CFGetSameGroupSS (car (entsel "\n ｼﾝｸを指示: "))))

  (setq #i 0)(princ "\n")
  (repeat (sslength #ss)
    (setq #elm (ssname #ss #i))
    (setq #xd$ (CFGetXData #elm "G_PMEN"))
    (if #xd$
      (progn
        (princ "\n i = ")(princ #i)(princ "  ")(princ #xd$)
      )
    );_if
    (setq #i (1+ #i))
  )
  (princ)
);c:p000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 選択セットのハンドルを表示する YM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun srcSShand (
  &ss
  /
  #ELM #HAND #I
  )

  (setq #i 0)
  (repeat (sslength &ss)
    (setq #elm (ssname &ss #i))
    (setq #hand (cdr (assoc 5 (entget #elm))))
    (princ #hand)(terpri)
    (setq #i (1+ #i))
  )
);srcSShand

;;;<HOM>*************************************************************************
;;; <関数名>    : c:ChgSKK
;;; <処理概要>  : 選択されたアイテムの性格CODEを変更する。
;;; <戻り値>    : なし
;;; <作成>      : 2000.08.04 HT
;;;*************************************************************************>MOH<

(defun c:ChgSKK (
  /
  #eEn   ; 図形名
  #Ed$   ; G_LSYM拡張データ
  #iSKK  ; 性格CODE
  )

  (setq #eEn (CFSearchGroupSym (car (entsel "\n確認するｵﾌﾞｼﾞｪｸﾄを選択: "))))
  (setq #Ed$ (CFGetXData #eEn "G_LSYM"))
  (princ "\n品番名称=")
  (princ (nth 5 #Ed$))
  (princ "\n性格CODE=")
  (princ (nth 9 #Ed$))
  (princ "\n変更後の性格CODE入力<Enter終了>:")
  (setq #iSKK (getint))
  (if #iSKK
    (progn
    (setq #Ed$ (CMN_subs_elem_list 9 #iSKK #Ed$))
    (CFSetXData #eEn "G_LSYM" #Ed$)
    )
  )
  (princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; マスタ(固定)を挿入する
(defun c:iii0 ( / #DWG #SS_DUM #SYM)

  (setq #dwg "0012001")
  ;// インサート
  (princ "\n挿入点: ")
  (command ".insert" (strcat CG_MSTDWGPATH #dwg) pause "" "")
  (princ "\n配置角度: ")
  (command pause)
  (command "_explode" (entlast))
  (setq #ss_dum (ssget "P"))
  (SKMkGroup #ss_dum)
;;;  (setq #sym (SKC_GetSymInGroup (ssname #ss_dum 0)))
     (setq #sym (PKC_GetSymInGroup #ss_dum))      ;;  2005/08/03 G.YK ADD

  ;// 拡張データの付加
  (CFSetXData #sym "G_LSYM"
    (list
      #dwg                       ;1 :本体図形ID  ; 品番図形.図形ＩＤ   OK!
      (list 0 0)                 ;2 :挿入点
      0                          ;3 :回転角度
      CG_Kcode                   ;4 :工種記号
      CG_SeriesCode              ;5 :SERIES記号
      "dummy"                    ;6 :品番名称
      "LR"                       ;7 :L/R 区分
      ""                         ;8 :扉図形ID
      #dwg                       ;9 :扉開き図形ID
      777                        ;10:性格CODE
      0                          ;11:複合フラグ
      0                          ;12:レコード番号
      0                          ;13:用途番号
      777                        ;14:寸法H
      0                          ;15:断面指示の有無
    )
  )
  (princ)
)



;;;<HOM>*************************************************************************
;;; <関数名>    : C:DBC11
;;; <処理概要>  : プラ構成下台ﾁｪｯｸ
;;; <戻り値>    : なし
;;; <作成>      : 04/08/11 YM
;;; <備考>      : ①品番図形にあるか②ID,recno④距離Xプラ管理との間口整合性
;;;*************************************************************************>MOH<
(defun C:DBC11 (
  /
  #DATE_TIME #DIRW #DIRW_OLD #DISX #DUM$$ #FIL #FLG #HIN #I #ID #ID$ #ID_OLD #KOSU 
  #LR #MAG2 #MAGU #MSG #OLD_DISX #OLD_FLG #OLD_HIN #QRY$$ #QRY_KANRI$$ #REC #REC_OLD 
  #SUMW #SUM_HIN1 #SUM_HIN2 #TYPE #W0 #WW #WW0 #XX #P-TYPE
  )
  (setq #msg "\nﾌﾟﾗ構成下台登録ﾁｪｯｸ")
  (setq #fil (open (strcat CG_SYSPATH "TMP\\CHK_HIN11-" CG_SeriesCode ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n(C:DBC11)ｺﾏﾝﾄﾞによるﾁｪｯｸ" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesCode) #fil)
  (princ "\n" #fil)

  (princ "\nDB検索中[プラ管理] 下台...")

  (setq #qry_KANRI$$
    (CFGetDBSQLRec CG_DBSESSION "プラ管理"
      (list
        (list "構成タイプ"  "1"   'INT)
        (list "order by \"プランID\"" nil 'ADDSTR)
      )
    )
  )

  (princ "\nDB検索中[プラ構成]下台...")

  (setq #dum$$ nil)
  ;各IDごとにrecNO順にﾚｺｰﾄﾞを取得する
  (foreach #qry_KANRI$ #qry_KANRI$$
    (setq #id     (nth 0 #qry_KANRI$))
    (setq #magu   (nth 5 #qry_KANRI$)) ;ｼﾝｸ側間口
    (setq #type   (nth 6 #qry_KANRI$)) ;配列"Z","K","L","M"
    (setq #p-type (nth 8 #qry_KANRI$)) ;ﾌﾟﾗﾝﾀｲﾌﾟ
    ;ﾌﾙﾌﾗｯﾄ,ｾﾐﾌﾗｯﾄは除く
    (if (or (and (= CG_SeriesCode "S")(wcmatch #p-type "F*,G*"))
            (and (= CG_SeriesCode "G")(wcmatch #p-type "F*,G*"))
            (and (= CG_SeriesCode "N")(wcmatch #p-type "F*"))
            (and (= CG_SeriesCode "D")(wcmatch #p-type "F*,G*,S*,T*")))
      nil ; ﾌﾙﾌﾗｯﾄは除く
      (progn
        ;特殊間口は変換する
        (cond
          ((= #magu "24A")(setq #magu 240))
          ((= #magu "24B")(setq #magu 240))
          ((= #magu "25A")(setq #magu 255))
          ((= #magu "25B")(setq #magu 255))
          ((= #magu "27A")(setq #magu 270))
          ((= #magu "27B")(setq #magu 270))
          (T (setq #magu (atoi (nth 5 #qry_KANRI$)))) ;ｼﾝｸ側間口
        );_cond

        (setq #qry$$
          (CFGetDBSQLRec CG_DBSESSION "プラ構成"
             (list
               (list "プランID" (rtois #id) 'INT)
               (list "order by \"RECNO\"" nil 'ADDSTR)
             )
          )
        )

        (if (= nil #qry$$)
          (princ (strcat "\n[ﾌﾟﾗ構成]がない" "ID=" (itoa (fix #id)) ) #fil)
          ;else
          (progn ;間口整合性ﾁｪｯｸ
            (setq #sum_hin1 0.0);ｼﾝｸ側
            (setq #sum_hin2 0.0);ｺﾝﾛ側
            (cond
              ((= #type "Z") ;I型
                (setq #hin  (nth 2 (last #qry$$)))
                (setq #disX (nth 9 (last #qry$$)));距離X
                (setq #W0 (atoi (CFGetNumFromStr_NAS #hin)))
                (if (wcmatch #hin "ﾌｰﾄﾞ*,食洗*,ｶﾞｽ*")
                  (setq #W0 (* #W0 1))
                  (setq #W0 (* #W0 10))
                );_if
                (setq #sum_hin1 (/ (+ #disX #W0) 10))
                (if (equal #magu #sum_hin1 0.01)
                  nil;OK!
                  ;else
                  (princ (strcat "\n[総間口不正-I型]" "ID=" (itoa (fix #id)) ",ﾌﾟﾗ管理=" (itoa #magu) ",ﾌﾟﾗ構成=" (itoa (fix #sum_hin1))) #fil)
                );_if
              )
              (T
                (cond
                  ((= #type "K")(setq #mag2 1650))
                  ((= #type "L")(setq #mag2 1800))
                  ((= #type "M")(setq #mag2 1950))
                );_cond

                ;ｺﾝﾛ側
                (setq #hin   (nth 2  (last #qry$$)))
                (setq #disX  (- (nth 10 (last #qry$$))));距離Yのﾏｲﾅｽ値
                (setq #W0    (atoi (CFGetNumFromStr_NAS #hin)))
                (if (wcmatch #hin "ﾌｰﾄﾞ*,食洗*,ｶﾞｽ*")
                  (setq #W0 (* #W0 1))
                  (setq #W0 (* #W0 10))
                );_if
                (setq #sum_hin2 (/ (+ #disX #W0) 10))
                (if (equal (/ #mag2 10) #sum_hin2 0.01)
                  nil;OK!
                  ;else
                  (princ (strcat "\n[総間口不正-L型ｺﾝﾛ側]" "ID=" (itoa (fix #id)) ",配列=" #type ",ﾌﾟﾗ構成=" (itoa (fix #sum_hin2))) #fil)
                );_if

                ;ｼﾝｸ側
                (setq #old_flg 1.0)
                (foreach #qry$ #qry$$
                  (setq #hin  (nth  2 #qry$))
                  (setq #disX (nth  9 #qry$));距離X
                  (setq #flg  (nth 12 #qry$));向きW
                  (if (equal #flg #old_flg 0.01)
                    nil
                    ;else ﾌﾗｸﾞが変わる
                    (progn
                      (setq #W0 (atoi (CFGetNumFromStr_NAS #old_hin)))
                      (if (wcmatch #old_hin "ﾌｰﾄﾞ*,食洗*,ｶﾞｽ*")
                        (setq #W0 (* #W0 1))
                        (setq #W0 (* #W0 10))
                      );_if
                      (setq #sum_hin1 (/ (+ #old_disX #W0) 10))
                      (if (equal #magu #sum_hin1 0.01)
                        nil;OK!
                        ;else
                        (princ (strcat "\n[総間口不正-L型ｼﾝｸ側]" "ID=" (itoa (fix #id)) ",ﾌﾟﾗ管理=" (itoa #magu) ",ﾌﾟﾗ構成=" (itoa (fix #sum_hin1))) #fil)
                      );_if
                    )
                  );_if
                  (setq #old_flg #flg)
                  (setq #old_disX #disX)
                  (setq #old_hin #hin)
                )
              )
            );_cond
          )
        );_if

        (if (member #id #id$)
          nil
          ;else
          (setq #dum$$ (append #dum$$ #qry$$))
        );_if
        (setq #id$ (append #id$ (list #id)))
      )
    );_if
  );foreach

  (setq #qry$$ #dum$$)

  ;下台　//////////////////////////////////////////////////////////////////////////
  (setq #sumW 0)
  (setq #id_old nil)
  (setq #rec_old nil)
  (setq #i 1) ; ｶｳﾝﾄ用
  (setq #kosu (length #qry$$))
  (foreach #qry$ #qry$$
    (if (= 0 (rem #i 100))
      (princ (strcat "\n下台 " (itoa #i) "/" (itoa #kosu)))
    );_if
    (setq #id   (nth  0 #qry$))
    (setq #rec  (nth  1 #qry$))
    (setq #hin  (nth  2 #qry$))
    (setq #LR   (nth  3 #qry$))
    (setq #XX   (nth  9 #qry$));距離X
    (setq #dirW (nth 12 #qry$));向きW
    (if (equal #dirW -1 0.001)
      (setq #XX (- (nth 10 #qry$)));距離X
    );_if

    (if (equal #rec 1 0.001)
      (progn
        ;04/07/19 YM MOD
        (setq #WW0 (atoi (CFGetNumFromStr_NAS #hin)));L型の場合ｺｰﾅｰ間口
          
        (if (wcmatch #hin "ﾌｰﾄﾞ*,食洗*,ｶﾞｽ*")
          (setq #WW0 (* 1 #WW0))
          (setq #WW0 (* 10 #WW0))
        );_if
      )
    );_if

    ;距離計算
    (if (equal #id #id_old 0.001)
      (progn ;IDが前ﾚｺｰﾄﾞと同じ
        (if (equal #XX #sumW 0.001)
          nil ; OK
          ;else
          (progn
            (if (and (equal -1 #dirW 0.001)(equal 1 #dirW_old 0.001))
              (progn ; L型ｺﾝﾛ側最初
                ;特殊処理 (ｺｰﾅｰｷｬﾋﾞ1050の場合)
                (if (= #WW0 1050)(setq #WW0 750))
                ;特殊処理 (ｺｰﾅｰｷｬﾋﾞ800の場合)
                (if (= #WW0 800)(setq #WW0 900))
                (setq #sumW #WW0)
                (if (equal #XX #WW0 0.001)
                  nil ; OK
                  ;else
                  ;距離不正
                  (princ (strcat "\n[距離不正]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))) #fil)
                );_if
              )
              (progn
                (princ (strcat "\n[距離不正]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec)) ",品番名称=" #HIN ",LR区分=" #LR) #fil)
              )
            );_if
          )
        );_if
      )
      (progn ;IDが前ﾚｺｰﾄﾞと違う
        (setq #sumW 0)
        (if (equal #XX 0 0.001)
          nil ; OK
          ;else
          ;距離不正
          (princ (strcat "\n[距離不正]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec)) ",品番名称=" #HIN ",LR区分=" #LR) #fil)
        );_if
      )
    );_if

    ;文字列の数字部分だけ取得する
    (setq #WW (atoi (CFGetNumFromStr_NAS #hin)))
    (if (wcmatch #hin "ﾌｰﾄﾞ*,食洗*,ｶﾞｽ*")
      (setq #WW (* 1 #WW))
      (setq #WW (* 10 #WW))
    );_if
    (if (= "C" (substr #hin 4 1))
      (progn
        ;特殊処理 (ｺｰﾅｰｷｬﾋﾞ1050の場合)
        (if (= #WW 1050)(setq #WW 750))
        ;特殊処理 (ｺｰﾅｰｷｬﾋﾞ800の場合)
        (if (= #WW 800)(setq #WW 900))
      )
    );_if

    (setq #sumW (+ #sumW #WW));累積

    ;ID,recNO ﾁｪｯｸ
    (if (and #id_old #rec_old)
      (progn
        (if (equal #id #id_old 0.001)
          (progn ;IDが前ﾚｺｰﾄﾞと同じ
            (if (equal (- #rec #rec_old) 1 0.001)
              nil ; OK
              ;else
              (progn
                ;recNO不整合
                (princ (strcat "\n[recNO不整合]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))) #fil)
              )
            );_if
          )
          (progn ;IDが前ﾚｺｰﾄﾞと違う
            (if (equal #rec 1 0.001)
              nil ; OK
              ;else
              ;recNO不整合
              (princ (strcat "\n[recNO不整合]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))) #fil)
            );_if
          )
        );_if

      )
    );_if

    ;品番ﾁｪｯｸ
    (if (not (wcmatch #hin "ﾌｰﾄﾞ*,食洗*,ｶﾞｽ*"))
      (progn
        (setq #qry$$
          (CFGetDBSQLRec CG_DBSESSION "品番図形"
            (list
              (list "品番名称" #HIN 'STR)
              (list "LR区分"   #LR  'STR)
            )
          )
        )
        ;ｴﾗｰ品番なしor複数
        (if (or (= nil #qry$$)(< 1 (length #qry$$)))
          (princ (strcat "\n[品番図形にないor複数]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))  ",品番名称=" #HIN ",LR区分=" #LR) #fil)
        );_if
      )
    );_if

    (setq #id_old   #id)
    (setq #rec_old  #rec)
    (setq #dirW_old #dirW)
    (setq #i (1+ #i))
  );foreach
  ;下台　//////////////////////////////////////////////////////////////////////////

  (princ "\n*** ﾁｪｯｸ完了 ***" #fil)

  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "TMP\\CHK_HIN11-" CG_SeriesCode ".txt"))
  (princ)
);C:DBC11

;;;<HOM>*************************************************************************
;;; <関数名>    : C:DBC22
;;; <処理概要>  : プラ構成吊戸ﾁｪｯｸ
;;; <戻り値>    : なし
;;; <作成>      : 04/08/23 YM
;;; <備考>      : ①品番図形にあるか②ID,recno③間隔
;         <手順>
;         [プラ管理]短尺500...ﾚｺｰﾄﾞ取得
;         [プラ管理]中尺700...ﾚｺｰﾄﾞ取得
;         [プラ管理]ﾚｺｰﾄﾞを元に[プラ構成]ﾚｺｰﾄﾞ取得
;         [プラ管理]と[プラ構成]で間口の整合性をﾁｪｯｸ ★新規追加
;;;*************************************************************************>MOH<
(defun C:DBC22 (
  /
  #DATE_TIME #DIRW #DIRW_OLD #DISX #DUM$$ #FIL #FLG #FLG_B #FLG_E #HIN #I #ID #ID$
  #ID_OLD #KOSU #LR #MAG2 #MAGU #MSG #OLD_DISX #OLD_FLG #OLD_HIN #P-TYPE #QRY$$ #QRY500-2$$
  #QRY_KANRI$ #QRY_KANRI500-2$$ #QRY_KANRI700-2$$ #REC #REC_OLD #SUMW #SUM_HIN1 #SUM_HIN2 
  #TYPE #W0 #WW #WW0 #XX
  )
  (setq #msg "\nﾌﾟﾗ構成吊戸登録ﾁｪｯｸ")
  (setq #fil (open (strcat CG_SYSPATH "TMP\\CHK_HIN22-" CG_SeriesCode ".txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\nﾌﾟﾗ構成ﾃｰﾌﾞﾙ登録品番で、品番図形に存在しないもの" #fil)
  (princ "\n(C:DBC22)ｺﾏﾝﾄﾞによるﾁｪｯｸ" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesCode) #fil)
  (princ "\n" #fil)

;;;[プラ管理]短尺500...ﾚｺｰﾄﾞ取得
  (princ "\nDB検索中[プラ管理] 短尺500...")

  (setq #qry_KANRI500-2$$ ;吊戸500mm
    (CFGetDBSQLRec CG_DBSESSION "プラ管理"
      (list
        (list "構成タイプ"  "2"   'INT)
        (list "取付タイプ2" "500" 'INT)
        (list "order by \"プランID\"" nil 'ADDSTR)
      )
    )
  )

;;;[プラ管理]中尺700...ﾚｺｰﾄﾞ取得
  (princ "\nDB検索中[プラ管理] 中尺700...")

  (setq #qry_KANRI700-2$$ ;吊戸700mm
    (CFGetDBSQLRec CG_DBSESSION "プラ管理"
      (list
        (list "構成タイプ"  "2"   'INT)
        (list "取付タイプ2" "700" 'INT)
        (list "order by \"プランID\"" nil 'ADDSTR)
      )
    )
  )
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (princ "\nDB検索中[プラ構成](短尺500)...")

  (setq #dum$$ nil)(setq #id$ nil)
  ;各IDごとにrecNO順にﾚｺｰﾄﾞを取得する
  (foreach #qry_KANRI500-2$ #qry_KANRI500-2$$
    (setq #id   (nth 0 #qry_KANRI500-2$))
    (setq #magu (nth 5 #qry_KANRI500-2$))   ;ｼﾝｸ側間口
    (setq #type (nth 6 #qry_KANRI500-2$))   ;配列"Z","K","L","M"
    (setq #p-type (nth 8 #qry_KANRI500-2$)) ;ﾌﾟﾗﾝﾀｲﾌﾟ

    ;ﾌﾙﾌﾗｯﾄ,ｾﾐﾌﾗｯﾄは除く
    (if (or (and (= CG_SeriesCode "S")(wcmatch #p-type "F*,G*"))
            (and (= CG_SeriesCode "G")(wcmatch #p-type "F*,G*"))
            (and (= CG_SeriesCode "N")(wcmatch #p-type "F*"))
            (and (= CG_SeriesCode "D")(wcmatch #p-type "F*,G*,S*,T*")))
      nil ; ﾌﾙﾌﾗｯﾄは除く
      (progn
        ;特殊間口は変換する
        (cond
          ((= #magu "24A")(setq #magu 240))
          ((= #magu "24B")(setq #magu 240))
          ((= #magu "25A")(setq #magu 255))
          ((= #magu "25B")(setq #magu 255))
          ((= #magu "27A")(setq #magu 270))
          ((= #magu "27B")(setq #magu 270))
          (T (setq #magu (atoi (nth 5 #qry_KANRI500-2$)))) ;ｼﾝｸ側間口
        );_cond

        (setq #qry500-2$$
          (CFGetDBSQLRec CG_DBSESSION "プラ構成"
             (list
               (list "プランID" (rtois #id) 'INT)
               (list "order by \"RECNO\"" nil 'ADDSTR)
             )
          )
        )
        (if (= nil #qry_KANRI500-2$$)
          (princ (strcat "\n[ﾌﾟﾗ構成]がない" "ID=" (itoa (fix #id)) ) #fil)
          ;else
          (progn ;間口整合性ﾁｪｯｸ
            (setq #sum_hin1 0.0);ｼﾝｸ側
            (setq #sum_hin2 0.0);ｺﾝﾛ側
            (cond
              ((= #type "Z") ;I型
                (setq #hin  (nth 2 (last #qry500-2$$)))
                (setq #disX (nth 9 (last #qry500-2$$)));距離X
                (setq #W0 (atoi (CFGetNumFromStr2 #hin)))
                (if (wcmatch #hin "ﾌｰﾄﾞ*")
                  (setq #W0 (* #W0 1))
                  (setq #W0 (* #W0 10))
                );_if
                (setq #sum_hin1 (/ (+ #disX #W0) 10))
                (if (equal #magu #sum_hin1 0.01)
                  nil;OK!
                  ;else
                  (princ (strcat "\n[総間口不正-I型]" "ID=" (itoa (fix #id)) ",ﾌﾟﾗ管理=" (itoa #magu) ",ﾌﾟﾗ構成=" (itoa (fix #sum_hin1))) #fil)
                );_if
              )
              (T
                (cond
                  ((= #type "K")(setq #mag2 1650))
                  ((= #type "L")(setq #mag2 1800))
                  ((= #type "M")(setq #mag2 1950))
                );_cond

                ;ｺﾝﾛ側
                (setq #hin   (nth 2  (last #qry500-2$$)))
                (setq #disX  (- (nth 10 (last #qry500-2$$))));距離Yのﾏｲﾅｽ値
                (setq #W0    (atoi (CFGetNumFromStr2 #hin)))
                (if (wcmatch #hin "ﾌｰﾄﾞ*,食洗*,ｶﾞｽ*")
                  (setq #W0 (* #W0 1))
                  (setq #W0 (* #W0 10))
                );_if
                (setq #sum_hin2 (/ (+ #disX #W0) 10))
                (if (equal (/ #mag2 10) #sum_hin2 0.01)
                  nil;OK!
                  ;else
                  (princ (strcat "\n[総間口不正-L型ｺﾝﾛ側]" "ID=" (itoa (fix #id)) ",配列=" #type ",ﾌﾟﾗ構成=" (itoa (fix #sum_hin2))) #fil)
                );_if

;;;               (setq #hin  (nth 2 (last #qry500-2$$)))
;;;               (setq #disX (nth 9 (last #qry500-2$$)));距離X
;;;               (setq #W0 (atoi (CFGetNumFromStr2 #hin)))
;;;               (if (wcmatch #hin "ﾌｰﾄﾞ*")
;;;                 (setq #W0 (* #W0 1))
;;;                 (setq #W0 (* #W0 10))
;;;               );_if
;;;               (setq #sum_hin2 (/ (+ #disX #W0) 10))
;;;               (if (equal (/ #mag2 10) #sum_hin2 0.01)
;;;                 nil;OK!
;;;                 ;else
;;;                 (princ (strcat "\n[総間口不正-L型ｺﾝﾛ側]" "ID=" (itoa (fix #id)) ",配列=" #type ",ﾌﾟﾗ構成=" (itoa (fix #sum_hin2))) #fil)
;;;               );_if

                ;ｼﾝｸ側
                (setq #old_flg 1.0)
                (foreach #qry$ #qry500-2$$
                  (setq #hin  (nth  2 #qry$))
                  (setq #disX (nth  9 #qry$));距離X
                  (setq #flg  (nth 12 #qry$));向きW
                  (if (equal #flg #old_flg 0.01)
                    nil
                    ;else ﾌﾗｸﾞが変わる
                    (progn
                      (setq #W0 (atoi (CFGetNumFromStr2 #old_hin)))
                      (if (wcmatch #old_hin "ﾌｰﾄﾞ*,食洗*,ｶﾞｽ*")
                        (setq #W0 (* #W0 1))
                        (setq #W0 (* #W0 10))
                      );_if
                      (setq #sum_hin1 (/ (+ #old_disX #W0) 10))
                      (if (equal #magu #sum_hin1 0.01)
                        nil;OK!
                        ;else
                        (princ (strcat "\n[総間口不正-L型ｼﾝｸ側]" "ID=" (itoa (fix #id)) ",ﾌﾟﾗ管理=" (itoa #magu) ",ﾌﾟﾗ構成=" (itoa (fix #sum_hin1))) #fil)
                      );_if
                    )
                  );_if
                  (setq #old_flg #flg)
                  (setq #old_disX #disX)
                  (setq #old_hin #hin)
                );foreach

;;;               ;ｼﾝｸ側
;;;               (setq #old_flg 1.0)
;;;               (foreach #qry500-2$ #qry500-2$$
;;;                 (setq #hin  (nth  2 #qry500-2$))
;;;                 (setq #disX (nth  9 #qry500-2$));距離X
;;;                 (setq #flg  (nth 12 #qry500-2$));向きW
;;;                 (if (equal #flg #old_flg 0.01)
;;;                   nil
;;;                   ;else ﾌﾗｸﾞが変わる
;;;                   (progn
;;;                     (setq #W0 (atoi (CFGetNumFromStr2 #old_hin)))
;;;                     (if (wcmatch #old_hin "ﾌｰﾄﾞ*")
;;;                       (setq #W0 (* #W0 1))
;;;                       (setq #W0 (* #W0 10))
;;;                     );_if
;;;                     (setq #sum_hin1 (/ (+ #old_disX #W0) 10))
;;;                     (if (equal #magu #sum_hin1 0.01)
;;;                       nil;OK!
;;;                       ;else
;;;                       (princ (strcat "\n[総間口不正-L型ｼﾝｸ側]" "ID=" (itoa (fix #id)) ",ﾌﾟﾗ管理=" (itoa #magu) ",ﾌﾟﾗ構成=" (itoa (fix #sum_hin1))) #fil)
;;;                     );_if
;;;                   )
;;;                 );_if
;;;                 (setq #old_flg #flg)
;;;                 (setq #old_disX #disX)
;;;                 (setq #old_hin #hin)
;;;               )

              )
            );_cond
          )
        );_if

        (if (member #id #id$)
          nil
          ;else
          (setq #dum$$ (append #dum$$ #qry500-2$$))
        );_if
        (setq #id$ (append #id$ (list #id)))
      )
    );_if
  );foreach
  (setq #qry_KANRI500-2$$ #dum$$)

  ;吊戸500mm　//////////////////////////////////////////////////////////////////////////
  (princ "\n＜短尺＞:**********************************************************" #fil)
  (setq #sumW 0)
  (setq #id_old nil)
  (setq #rec_old nil)
  (setq #i 1) ; ｶｳﾝﾄ用
  (setq #kosu (length #qry500-2$$))
  (foreach #qry500-2$ #qry500-2$$
    (if (= 0 (rem #i 100))
      (princ (strcat "\n短尺 " (itoa #i) "/" (itoa #kosu)))
    );_if
    (setq #id   (nth  0 #qry500-2$))
    (setq #rec  (nth  1 #qry500-2$))
    (setq #hin  (nth  2 #qry500-2$))
    (setq #LR   (nth  3 #qry500-2$))
    (setq #XX   (nth  9 #qry500-2$));距離X
    (setq #dirW (nth 12 #qry500-2$));向きW
    (if (equal #dirW -1 0.001)
      (setq #XX (- (nth 10 #qry500-2$)));距離X
    );_if

    (if (equal #rec 1 0.001)
      (progn
        ;04/07/19 YM MOD
        (setq #WW0 (atoi (CFGetNumFromStr2 #hin)));L型の場合ｺｰﾅｰ間口
        (if (wcmatch #hin "ﾌｰﾄﾞ*")
          (setq #WW0 (* 1 #WW0))
          (setq #WW0 (* 10 #WW0))
        );_if
      )
    );_if

    ;距離計算
    (if (equal #id #id_old 0.001)
      (progn ;IDが前ﾚｺｰﾄﾞと同じ
        (if (equal #XX #sumW 0.001)
          nil ; OK
          ;else
          (progn
            (if (and (equal -1 #dirW 0.001)(equal 1 #dirW_old 0.001))
              (progn ; L型ｺﾝﾛ側最初
                ;特殊処理 (ｺｰﾅｰｷｬﾋﾞ1050の場合)
                (if (= #WW0 1050)(setq #WW0 750))
                ;特殊処理 (ｺｰﾅｰｷｬﾋﾞ800の場合)
                (if (= #WW0 800)(setq #WW0 900))
                (setq #sumW #WW0)
                (if (equal #XX #WW0 0.001)
                  nil ; OK
                  ;else
                  ;距離不正
                  (princ (strcat "\n[距離不正]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec)) ",品番名称=" #HIN ",LR区分=" #LR) #fil)
                );_if
              )
              (progn
                (princ (strcat "\n[距離不正]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec)) ",品番名称=" #HIN ",LR区分=" #LR) #fil)
              )
            );_if
          )
        );_if
      )
      (progn ;IDが前ﾚｺｰﾄﾞと違う
        (setq #sumW 0)
        (if (equal #XX 0 0.001)
          nil ; OK
          ;else
          ;距離不正
          (princ (strcat "\n[距離不正]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec)) ",品番名称=" #HIN ",LR区分=" #LR) #fil)
        );_if
      )
    );_if

    ;文字列の数字部分だけ取得する
    (setq #WW (atoi (CFGetNumFromStr2 #hin)))
    ;04/07/19 YM MOD
    (if (wcmatch #hin "ﾌｰﾄﾞ*")
      (setq #WW (* 1 #WW))
      (setq #WW (* 10 #WW))
    );_if

    (if (= "C" (substr #hin 5 1))
      (progn
        ;特殊処理 (ｺｰﾅｰｷｬﾋﾞ1050の場合)
        (if (= #WW 1050)(setq #WW 750))
        ;特殊処理 (ｺｰﾅｰｷｬﾋﾞ800の場合)
        (if (= #WW 800)(setq #WW 900))
      )
    );_if

    (setq #sumW (+ #sumW #WW));累積

    ;ID,recNO ﾁｪｯｸ
    (if (and #id_old #rec_old)
      (progn
        (if (equal #id #id_old 0.001)
          (progn ;IDが前ﾚｺｰﾄﾞと同じ
            (if (equal (- #rec #rec_old) 1 0.001)
              nil ; OK
              ;else
              (progn
                ;recNO不整合
                (princ (strcat "\n[recNO不整合]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))) #fil)
              )
            );_if
          )
          (progn ;IDが前ﾚｺｰﾄﾞと違う
            (if (equal #rec 1 0.001)
              nil ; OK
              ;else
              ;recNO不整合
              (princ (strcat "\n[recNO不整合]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))) #fil)
            );_if
          )
        );_if

      )
    );_if

    ;品番ﾁｪｯｸ
    (if (not (wcmatch #hin "ﾌｰﾄﾞ*"))
      (progn
        (setq #qry$$
          (CFGetDBSQLRec CG_DBSESSION "品番図形"
            (list
              (list "品番名称" #HIN 'STR)
              (list "LR区分"   #LR  'STR)
            )
          )
        )
        ;ｴﾗｰ品番なしor複数
        (if (or (= nil #qry$$)(< 1 (length #qry$$)))
          (princ (strcat "\n[品番図形にないor複数]" "ID=" (itoa (fix #id)) ",recNO=" (itoa (fix #rec))  ",品番名称=" #HIN ",LR区分=" #LR) #fil)
        );_if
      )
    );_if

    (setq #id_old   #id)
    (setq #rec_old  #rec)
    (setq #dirW_old #dirW)
    (setq #i (1+ #i))
  );foreach
  ;吊戸500mm　//////////////////////////////////////////////////////////////////////////


  (princ "\n*** ﾁｪｯｸ完了 ***" #fil)

  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "TMP\\CHK_HIN22-" CG_SeriesCode ".txt"))
  (princ)
);C:DBC22


;;;<HOM>*************************************************************************
;;; <関数名>    : c:GSM
;;; <処理概要>  : 図面上で"G_PMEN"2がｾｯﾄされていないﾍﾞｰｽｷｬﾋﾞの図形IDを返す
;;;             : 図面上で"G_PLIN"2がｾｯﾄされていないｺﾝﾛｷｬﾋﾞの図形IDを返す
;;; <戻り値>    : なし
;;; <作成>      : 2000.12.12 YM
;;;*************************************************************************>MOH<
(defun c:GSM (
  /
  #ANA #ANA0 #EN #EN$ #FLG #I #J #K #KOSU #LOOP #MSG #N2 #PT$ #SS_LSYM #SYM #XD #XD0
  #ZU_ID #name
  )
  (command "._zoom" "E")
  (princ)
  (princ "\nﾍﾞｰｽｷｬﾋﾞ(性格ｺｰﾄﾞ=\"11?\")を検索中...")
  (princ)
  (command "undo" "M") ; ﾏｰｸをつける
  (C:ALP) ; 画層解除
  (setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM"))))) ; G_LSYM 図形選択ｾｯﾄ

  (if (= #ss_LSYM nil) (setq #ss_LSYM (ssadd)))
  (setq #i 0 #flg nil)
  (repeat (sslength #ss_LSYM)                    ; "G_LSYM"を持つもの
    (setq #sym (ssname #ss_LSYM #i))

    (if (and (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB)
             (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS))
      (progn ; ﾍﾞｰｽｷｬﾋﾞだった
        (GroupInSolidChgCol2 #sym CG_InfoSymCol) ; 色を変える
        (setq #en$ (CFGetGroupEnt #sym))   ; 各ﾍﾞｰｽｷｬﾋﾞの同一ｸﾞﾙｰﾌﾟ
;////////////////////////////////////////////////////////////////////////////////
        (if (= (CFGetSymSKKCode #sym 3) CG_SKK_THR_GAS)
          (progn ; ｺﾝﾛｷｬﾋﾞだった
            (setq #j 0)
            (setq #loop T)
            (while (and #loop (< #j (length #en$))) ; PMEN2を検索する
              (setq #en (nth #j #en$))
              (if (= 2 (car (CFGetXData #en "G_PLIN")))
                (setq #loop nil) ; １つ見つけたらループを抜ける
              );_if
              (setq #j (1+ #j))
            );_(while

            (if #loop ; PLIN2がない
              (progn
                (setq #flg T)
                (setq #name  (nth 8 (CFGetXData #sym "G_LSYM"))) ; 品番名称
                (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; 図形ID
                (setq #msg (strcat "\n 図形ID=" #zu_id "にｺﾝﾛ取付け線(PLIN2)がありません。" #name))
                (princ #msg)
              )
            );_if
          )
        );_if
;////////////////////////////////////////////////////////////////////////////////
        (setq #j 0)
        (setq #loop T)
        (while (and #loop (< #j (length #en$))) ; PMEN2を検索する
          (setq #en (nth #j #en$))
          (if (= 2 (car (CFGetXData #en "G_PMEN")))
            (progn
              (setq #pt$ (GetLWPolyLinePt #en)) ; 外形点列
              (setq #loop nil) ; １つ見つけたらループを抜ける
              (if (= (CFGetSymSKKCode #sym 3) CG_SKK_THR_CNR) ; ｺｰﾅｰｷｬﾋﾞ
                (setq #kosu 6)
                (setq #kosu 4)
              );_if
              (if (/= (length #pt$) #kosu)
                (progn
                  (setq #name  (nth 8 (CFGetXData #sym "G_LSYM"))) ; 品番名称
                  (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; 図形ID
                  (setq #msg (strcat "\n 図形ID=" #zu_id "の外形領域(PMEN2)頂点数不正。" #name))
                  (princ #msg)
                )
              );_if
            )
          );_if
          (setq #j (1+ #j))
        );_(while

        (if #loop ; PMEN2がない
          (progn
            (setq #flg T)
            (setq #name  (nth 8 (CFGetXData #sym "G_LSYM"))) ; 品番名称
            (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; 図形ID
            (setq #msg (strcat "\n 図形ID=" #zu_id "に外形領域(PMEN2)がありません。" #name))
            (princ #msg)
          )
        );_if
;////////////////////////////////////////////////////////////////////////////////

; 01/01/09 "G_BODY" ﾁｪｯｸ/////////////////////////////////////////////////////////
        (setq #j 0)(setq #loop nil)
        (while (< #j (length #en$))
          (setq #en (nth #j #en$))
          (if (setq #xd0 (CFGetXData #en "G_BODY"))
            (progn
              (setq #kosu (nth 1 #xd0))    ; 穴図形数
              (setq #k 2)
              (repeat #kosu
                (setq #ana0 (nth #k #xd0)) ; 穴図形ﾊﾝﾄﾞﾙ
                (if (= #ana0 nil)(setq #loop T))
                (setq #k (1+ #k))
              )
            )
          );_if
          (setq #j (1+ #j))
        );_(while

        (if #loop ; "G_BODY"穴図形ﾊﾝﾄﾞﾙが不正
          (progn
            (setq #flg T)
            (setq #name  (nth 8 (CFGetXData #sym "G_LSYM"))) ; 品番名称
            (setq #zu_id (nth 0 (CFGetXData #sym "G_LSYM"))) ; 図形ID
            (setq #msg (strcat "\n 図形ID=" #zu_id "穴図形ﾊﾝﾄﾞﾙが不正です。" #name))
            (princ #msg)
          )
        );_if
;////////////////////////////////////////////////////////////////////////////////

        (GroupInSolidChgCol2 #sym "BYLAYER")
      )
    );_if

    (setq #i (1+ #i))
  );_(repeat

  (if #flg
    (setq #msg "\nPMEN2,PLIN2,G_BODYが正しくセットされていないアイテムありました。\n担当者に連絡して下さい。")
    (setq #msg "\n\図面上のPMEN2,PLIN2,G_BODYは全て正常でした.")
  );_if
  (CFAlertMsg #msg)
  (command "undo" "B")
  (command "._zoom" "P")
  (princ)
);c:GSM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 性格ｺｰﾄﾞ表示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:skk (
  /
  #SKK #en
  )
  (setq #en T)
  (while #en
    (setq #en (car (entsel "\n部材を選択")))
    (setq #skk (nth 9 (CFGetXData (CFSearchGroupSym #en) "G_LSYM")))
    (CFAlertMsg (strcat "性格ｺｰﾄﾞ: " (itoa #skk)))
  )
  (princ)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 拡張ﾃﾞｰﾀ一時変更
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:mmm (
  /
  #SYM #XD$
  )
  (setq #sym (c:oya))
  (setq #xd$ (CFGetXData #sym "G_LSYM"))
  (CFSetXData
    #sym
    "G_LSYM"
    (CFModList
      #xd$
      (list (list 13 781))
    )
  )
  (princ)
)

;*****************************************************************************:
; 性格ｺｰﾄﾞ入力==>【品番基本】に登録されている品番のﾘｽﾄから
; (setq #sFile (strcat CG_SYSPATH "SELPARTS.CFG"))を作成し、ｷｬﾋﾞﾈｯﾄを自動配置
; 01/05/23 YM ﾁｪｯｸ用ｷｬﾋﾞﾈｯﾄ自動配置ｺﾏﾝﾄﾞ
;*****************************************************************************:
(defun C:AutoPut (
  /
  #DUM$$ #EN #HINBAN #I #ii #KOSU #LR #OP #QRY$$ #QRY2$ #SFILE #SKK #ST #KAO$
  #SA
  )
  ;// コマンドの初期化
  (StartUndoErr)

  (setq CG_TESTMODE T) ; ﾃｽﾄﾓｰﾄﾞ
  (setq CG_TESTNO 0)   ; 回数
  (setq CG_TEST_X 0)   ; 配置X
  (setq CG_TEST_Y 0)   ; 配置Y
  (setq #skk (getstring "\n性格ｺｰﾄﾞを入力せよ。"))
  (setq #Qry$$
    (CFGetDBSQLRec CG_DBSESSION "品番基本"
      (list (list "性格CODE" #skk    'INT))
    )
  )
  (if (= #Qry$$ nil)
    (progn
      (CFAlertMsg "\nﾚｺｰﾄﾞがありませんでした。")
      (quit)
    )
  );_if
  (setq #i 0 #kosu 0)
  (foreach #dum$ #Qry$$
    (if (equal 1 (nth 1 #dum$) 0.1) ; LR有無あり
      (setq #kosu (1+ #kosu))
    );_if
    (setq #i (1+ #i))
  )
  (princ (strcat "\n【品番基本】にﾚｺｰﾄﾞが " (itoa (length #Qry$$)) " 件あります。"
                "(LR有無あり= " (itoa #kosu) " 件)"))
  (princ "\n＜何件目から何件目の品番を配置するか指定＞")
  (setq #st (getint "\nﾚｺｰﾄﾞの開始番号(0,1,2...)を入力せよ。"))
  (setq #en (getint "\nﾚｺｰﾄﾞの終了番号(0,1,2...)を入力せよ。"))
  (if (or (> #st #en)(<= (length #Qry$$) #st)(<= (length #Qry$$) #en))
    (progn
      (CFAlertMsg "\n指定番号不正！")
      (quit)
    )
  );_if

  (setq #i 0 #dum$$ nil)
  (foreach #dum$ #Qry$$
    (if (and (<= #st #i)(>= #en #i))
      (setq #dum$$ (append #dum$$ (list #dum$)))
    );_if
    (setq #i (1+ #i))
  )
  (setq #Qry$$ #dum$$)

  (setq #KAO$ (list "(｡･｡･)" "(｡･o･｡)" "d(-｡･｡)" "(>o<)" "(｡･｡･｡)"
                    "( ｡･_･)" "(･｡･｡ )" "(o･｡･o)" "(^-^*)" "(;･｡･)"))
    ;////////////////////////////////////////////////////////
    ; ==>INT
    ;////////////////////////////////////////////////////////
    (defun ##int ( &val / )
      (fix (+ &val 0.0001))
    )
    ;////////////////////////////////////////////////////////
    ; SELPARTS.CFGの作成
    ;////////////////////////////////////////////////////////
    (defun ##Write (
      /
      #DIS #STRANG #STRH #ID
      #OP #SA #SFILE
      )
      ;  01 : 階層タイプ
      ;  02 : 品番名称
      ;  03 : LR区分
      ;  04 : 取付タイプ
      ;  05 : 用途番号
      ;  06 : 寸法W
      ;  07 : 寸法D
      ;  08 : 寸法H
      ;  09 : 図形ID
      ;  10 : 展開ID
      ;  11 : 入力名称
      ;  12 : 性格CODE
      ;  13 : 入力コード
      ;  20 : 伸縮
      (setq #sFile (strcat CG_SYSPATH "SELPARTS.CFG"))
      (setq #op (open #sFile "w"))
      (princ "01=0" #op)(princ "\n" #op)
      (princ "02=" #op) (princ (nth  0 #Qry2$) #op) (princ "\n" #op)         ; 品番名称
      (princ "03=" #op) (princ (nth  1 #Qry2$) #op) (princ "\n" #op)
      (princ "04=" #op) (princ (##int (nth  2 #Qry2$)) #op) (princ "\n" #op) ; LR区分
      (princ "05=" #op) (princ (##int (nth  3 #Qry2$)) #op) (princ "\n" #op) ; 用途番号
      (princ "06=" #op) (princ (##int (nth  4 #Qry2$)) #op) (princ "\n" #op) ; 寸法W
      (princ "07=" #op) (princ (##int (nth  5 #Qry2$)) #op) (princ "\n" #op) ; 寸法D
      (princ "08=" #op) (princ (##int (nth  6 #Qry2$)) #op) (princ "\n" #op) ; 寸法H
      (princ "09=" #op) (princ (nth  7 #Qry2$) #op) (princ "\n" #op)         ; 図形ID
      (princ "10=" #op) (princ (nth  8 #Qry2$) #op) (princ "\n" #op)
      (princ "11=" #op) (princ (nth  9 #Qry2$) #op) (princ "\n" #op)
      (princ "12=" #op) (princ #skk #op)            (princ "\n" #op)
      (princ "13=0" #op)(princ "\n" #op)
      (close #op)

      ; 挿入点座標の計算
      (setq CG_TESTNO (1+ CG_TESTNO)) ; 回数
      (if (<= (nth  4 #Qry2$) 500)
        (setq CG_TEST_X (+ CG_TEST_X 500 500)) ; W値累積
        (setq CG_TEST_X (+ CG_TEST_X 500 (##int (nth  4 #Qry2$)))) ; W値累積
      );_if
      (if (and (< 10 CG_TESTNO)(= 1 (rem CG_TESTNO 30)))
        (setq CG_TEST_Y (+ CG_TEST_Y -3000) CG_TEST_X 0) ; 配置Y
      );_if

      ; 図面に情報を書き込む
      (setq #strH "60")
      (setq #strANG "0")
      (setq #dis 80 #sa 900)
      (command "._TEXT"
        (list CG_TEST_X (- CG_TEST_Y #sa (* #dis 0)) 0) #strH #strANG
        (strcat (nth 0 #Qry2$)(nth 1 #Qry2$))
      )
      (command "._TEXT"
        (list CG_TEST_X (- CG_TEST_Y #sa (* #dis 1)) 0) #strH #strANG
        (strcat "寸法W: " (rtos (nth 4 #Qry2$)))
      )
      (command "._TEXT"
        (list CG_TEST_X (- CG_TEST_Y #sa (* #dis 2)) 0) #strH #strANG
        (strcat "寸法D: " (rtos (nth 5 #Qry2$)))
      )
      (command "._TEXT"
        (list CG_TEST_X (- CG_TEST_Y #sa (* #dis 3)) 0) #strH #strANG
        (strcat "寸法H: " (rtos (nth 6 #Qry2$)))
      )
      (if (nth 7 #Qry2$)
        (setq #ID (nth 7 #Qry2$))
        (setq #ID "図形ID未登録")
      );_if
      (command "._TEXT"
        (list CG_TEST_X (- CG_TEST_Y #sa (* #dis 4)) 0) #strH #strANG
        (strcat "図形ID: " #ID)
      )

      (princ)
    );##Write
    ;////////////////////////////////////////////////////////

  ; 品番図形,品番基本を検索
  (setq #i #st #ii 0)
  (foreach #Qry$ #Qry$$
    (princ (strcat "\n***** " (itoa #i) "番目 ***** " (nth #ii #KAO$)))
    (setq #hinban (nth 0 #Qry$))
    (setq #skk    (nth 3 #Qry$))
    (if (= 1 (nth 1 #Qry$))
      (setq #LR "R")
      (setq #LR "Z")
    )
    (setq #Qry2$ ; LR込み複数あり
      (car (CFGetDBSQLRec CG_DBSESSION "品番図形"
        (list
          (list "品番名称" #HINBAN 'STR)
          (list "LR区分"   #LR     'STR)
        )
      ))
    )
    (if (equal (nth 11 #Qry$) 0 0.1)
      (progn ; 入力ｺｰﾄﾞ=0
        ; SELPARTS.CFGの作成
        (##Write)
        ; 配置
        (C:PosParts)
        (if (= #LR "R")
          (progn ; "R"なら"L"も配置する
            (setq #LR "L")
            (setq #Qry2$ ; LR込み複数あり
              (car (CFGetDBSQLRec CG_DBSESSION "品番図形"
                (list
                  (list "品番名称" #HINBAN 'STR)
                  (list "LR区分"   #LR     'STR)
                )
              ))
            )
            ; SELPARTS.CFGの作成
            (##Write)
            ; 配置
            (C:PosParts)
          )
        );_if
      )
    );_if
    (setq #i (1+ #i))
    (if (< (- (length #KAO$) 2) #ii)
      (setq #ii 0)
      (setq #ii (1+ #ii))
    );_if
  );_foreach
  (setq CG_TESTMODE nil) ; ﾃｽﾄﾓｰﾄﾞ

  (if (CFYesNoDialog "図形ﾁｪｯｸを行いますか？")(C:GSM))

  (princ "\n配置終了。")
  (princ "　\"clear\"ｺﾏﾝﾄﾞで図面上のｷｬﾋﾞﾈｯﾄをすべて削除できます。")
  (setq *error* nil)
);C:AutoPut

;*****************************************************************************:
; 品番のﾃｷｽﾄﾌｧｲﾙ==> ｷｬﾋﾞﾈｯﾄを自動配置
;*****************************************************************************:
(defun C:newAutoPut (
	/
	#ALL$$ #DUM$$ #EN #ERR #HINBAN #I #II #KAISO$$ #KAO$ #KOSU #LIST$$ #LOOP #LR #LR_KOSU
	#QRY$$ #QRY2$ #QRY2$$ #SFILE #SKK #ST #UP_NO
	#SKK2 #SYM #ZZ #GSMW #HINBANW #HINZUKEIW #fil
	)


		;////////////////////////////////////////////////////////
		; SELPARTS.CFGの作成
		;////////////////////////////////////////////////////////
		(defun ##HANTEI (
			/
			#GSMW #HINBANW #HINZUKEIW #MAG 
			)

			(if (or (equal #skk1 1.0 0.001))
				(progn ;ｷｬﾋﾞﾈｯﾄなら
					(setq #hinzukeiW (nth 3 #Qry2$));[品番図形]W値
					(setq #hinzukeiH (nth 5 #Qry2$));[品番図形]H値

					(setq #gsmW (nth 3 CG_GSYM$))
					(setq #gsmH (nth 5 CG_GSYM$))

					(setq #mag (substr #HINBAN 3 2));間口文字列
					(cond
						((wcmatch #HINBAN "*90*")
						  (setq #hinbanW 900.0)
					 	)
						((wcmatch #HINBAN "*75*")
						  (setq #hinbanW 750.0)
					 	)
						((wcmatch #HINBAN "*60*")
						  (setq #hinbanW 600.0)
					 	)
						((wcmatch #HINBAN "*45*")
						  (setq #hinbanW 450.0)
					 	)
						((wcmatch #HINBAN "*30*")
						  (setq #hinbanW 300.0)
					 	)
						((wcmatch #HINBAN "*15*")
						  (setq #hinbanW 150.0)
					 	)

						((wcmatch #HINBAN "*A5*")
						  (setq #hinbanW 1050.0)
					 	)
						((wcmatch #HINBAN "*B0*")
						  (setq #hinbanW 1200.0)
					 	)
						((wcmatch #HINBAN "*C5*")
						  (setq #hinbanW 1350.0)
					 	)
						((wcmatch #HINBAN "*D0*")
						  (setq #hinbanW 1500.0)
					 	)
						((wcmatch #HINBAN "*E5*")
						  (setq #hinbanW 1650.0)
					 	)
						((wcmatch #HINBAN "*F0*")
						  (setq #hinbanW 1800.0)
					 	)
						(T
						  nil
					 	)
					);_cond
					
					(princ (strcat "\n" (nth 6 #Qry2$) "," #HINBAN ",") #fil)
					(princ "品番図形W," #fil)(princ #hinzukeiW #fil)
					(princ ",GSM_W値," #fil) (princ #gsmW      #fil)
					(princ ",機種名W値," #fil)(princ #hinbanW   #fil)

					(princ "品番図形H," #fil)(princ #hinzukeiH #fil)
					(princ ",GSM_H値  ," #fil)(princ #gsmH      #fil)

					;判定
					(setq #flg0 nil);NGならT

					(if (and (equal #hinzukeiW #gsmW 0.001)
									 (equal #gsmW #hinbanW 0.001))
						(progn
							nil ;問題なし
						)
						(progn ;問題あり
							(setq #flg0 T);NGならT
						)
					);_if

					(if (equal #hinzukeiH #gsmH 0.001)
						(progn
							nil ;問題なし
						)
						(progn ;問題あり
							(setq #flg0 T);NGならT
						)
					);_if

					(if #flg0
						(princ "★ＮＧ★" #fil)
					);_if

				)
			);_if
			(princ)
		);##HANTEI
		;////////////////////////////////////////////////////////



		;////////////////////////////////////////////////////////
		; SELPARTS.CFGの作成
		;////////////////////////////////////////////////////////
		(defun ##Write (
			/
			#DIS #ID #SA #STRANG #STRH
			)

			; 図面に情報を書き込む
			(setq #strH "60")
			(setq #strANG "0")
			;2016/11/11 YM MOD-S
;;;			(setq #dis 80 #sa 1500)
			(setq #dis 80 #sa 300)
			;2016/11/11 YM MOD-E

			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 0)) 0) #strH #strANG
			 	(strcat (nth 0 #Qry2$)(nth 1 #Qry2$))
			)
			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 1)) 0) #strH #strANG
			 	(strcat "品番図形W: " (rtos (nth 3 #Qry2$)))
			)
			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 2)) 0) #strH #strANG
			 	(strcat "品番図形D: " (rtos (nth 4 #Qry2$)))
			)
			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 3)) 0) #strH #strANG
			 	(strcat "品番図形H: " (rtos (nth 5 #Qry2$)))
			)

			(if (nth 7 #Qry2$)
				(setq #ID (nth 6 #Qry2$))
				(setq #ID "図形ID未登録")
			);_if

			;2016/11/11 YM ADD-S
			(if #Qry3$
				(if (nth 4 #Qry3$)
					(setq #DRID (strcat "DR" (substr (nth 4 #Qry3$) 1 5 )))
					;else
					(setq #DRID "図形ID未登録")
				);_if
			);_if
			;2016/11/11 YM ADD-E

			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 4)) 0) #strH #strANG
			 	(strcat "図形ID: " #ID)
			)

			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 5)) 0) #strH #strANG
			 	(strcat "扉図ID: " #DRID)
			)

			(command "._TEXT"
		 		(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 6)) 0) #strH #strANG
			 	(strcat "性格ｺｰﾄﾞ: " (itoa (fix #SKK)))
			)


			(command "._TEXT"
				(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 8)) 0) #strH #strANG
			 	(strcat "GSM_W: " (rtos (nth 3 CG_GSYM$)))
			)
			(command "._TEXT"
				(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 9)) 0) #strH #strANG
			 	(strcat "GSM_D: " (rtos (nth 4 CG_GSYM$)))
			)
			(command "._TEXT"
				(list CG_TEST_X (- CG_TEST_Y #sa (* #dis 10)) 0) #strH #strANG
			 	(strcat "GSM_H: " (rtos (nth 5 CG_GSYM$)))
			)

			(princ)
		);##Write
		;////////////////////////////////////////////////////////


  ;// コマンドの初期化
;;;  (StartUndoErr)

	(setq #sFile (getfiled "機種名ﾘｽﾄのﾃｷｽﾄﾌｧｲﾙ" CG_SYSPATH "TXT" 4))
	(setq #List$$ (ReadCSVFile #sFile)) ; 新製品品番

	(setq CG_TESTMODE T) ; ﾃｽﾄﾓｰﾄﾞ
	(setq CG_TESTNO 0)   ; 回数
	(setq CG_TEST_X 0)   ; 配置X
	(setq CG_TEST_Y 0)   ; 配置Y

	(setq #ALL$$ nil)
	(setq #LR_KOSU 0)
	(setq #ERR nil) ; ｴﾗｰﾌﾗｸﾞ(ﾃｷｽﾄﾌｧｲﾙの品番に追加部材を含むと'T)


	; ﾌｧｲﾙOPEN
  (setq #fil (open (strcat CG_SYSPATH "自動配置.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
	(princ #date_time #fil) ; 日付書き込み
	(princ "\n" #fil)


	;2014/08/19 YM ADD-S 品番の変わりに図形IDでもOK
	(if (= 'INT (type (read (car (car #List$$)))))
		(progn ;図形IDだった
			;品番名称に変換

			(setq #hin$ nil)
			(foreach #List$ #List$$
				(setq #zukeiID (car #List$))
			  (setq #Qry$$
			    (CFGetDBSQLRec CG_DBSESSION "品番図形"
			      (list	(list "図形ID" #zukeiID 'STR))
			    )
			  )
				(if (= #Qry$$ nil) ; //////////////////////////////////////////////////////////////////
					(progn
						(CFAlertMsg	(strcat "\n品番図形にﾚｺｰﾄﾞがない.\n★★★ " #zukeiID " ★★★"))
						(setq #ERR T)
					)
					(progn
						;品番名称
						(setq #hin (car (car #Qry$$)))
						(setq #hin$ (append #hin$ (list (list #hin))))
					)
				);_if

			);_foreach

			(setq #List$$ #hin$)
		)
	);_if
	;2014/08/19 YM ADD-E 品番の変わりに図形IDでもOK


;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(foreach #List$ #List$$
		(setq #hinban (car #List$))
	  (setq #Qry$$
	    (CFGetDBSQLRec CG_DBSESSION "品番基本"
	      (list	(list "品番名称" #hinban 'STR))
	    )
	  )
		(if (or (= #Qry$$ nil)(> (length #Qry$$) 1)) ; //////////////////////////////////////////////////////////////////
			(progn
				(CFAlertMsg	(strcat "\n品番基本にﾚｺｰﾄﾞがないかまたは複数ありました.\n★★★ " #hinban " ★★★"))
				(setq #ERR T)
			)
			(progn
				(setq #ALL$$ (append #ALL$$ (list (car #Qry$$)))) ; 全対象ﾚｺｰﾄﾞ
;;;				(setq #SKK (nth 3 (car #Qry$$))) ; 性格ｺｰﾄﾞ
			)
		);_if

		(if (= 1 (nth 1 (car #Qry$$)))
			(setq #LR_KOSU (1+ #LR_KOSU))
		);_if
	);_foreach

	(if #ERR
		(progn
			(CFAlertMsg "自動配置を終了します.")
			(quit)
		)
	);_if

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq #kosu (length #ALL$$))

	(princ (strcat "\n対象品番が " (itoa #kosu) " 件あります"))
	(princ (strcat "[L/R込みで " (itoa (+ #kosu #LR_KOSU)) " 個]"))

	; 品番図形,品番基本を検索
	(foreach #Qry$ #ALL$$

		(setq #hinban (nth 0 #Qry$))
		(setq #skk    (nth 3 #Qry$))
		;2014/07/21 YM ADD
		(setq #skk1 (CFGetSeikakuToSKKCode #skk 1)) ;1桁目
		(setq #skk2 (CFGetSeikakuToSKKCode #skk 2)) ;2桁目
		(setq #skk3 (CFGetSeikakuToSKKCode #skk 3)) ;3桁目
		(if (equal #skk2 2.0 0.001)
			(setq #ZZ 2300)
			;else
			(setq #ZZ 0)
		);_if
		
		(if (equal 1.0 (nth 1 #Qry$) 0.001)
			(setq #LR "R")
			;else
			(setq #LR "Z")
		)
	  (setq #Qry2$$ ; LR込み複数あり
	    (CFGetDBSQLRec CG_DBSESSION "品番図形"
	      (list
					(list "品番名称" #HINBAN 'STR)
	        (list "LR区分"   #LR     'STR)
	      )
	    )
	  )
		(if (or (= #Qry2$$ nil)(> (length #Qry2$$) 1)) ; //////////////////////////////////////////////////////////////////
			(progn
				(CFAlertMsg	(strcat "\n品番図形にﾚｺｰﾄﾞがないかまたは複数ありました.\n★★★ " #hinban " ★★★"))
			)
			(progn
				(setq #Qry2$ (car #Qry2$$))
			)
		);_if




		;2016/11/11 YM ADD-S
	  (setq #Qry3$$ ; LR込み複数あり
	    (CFGetDBSQLRec CG_DBSESSION "品番シリ"
	      (list
					(list "品番名称" #HINBAN 'STR)
	        (list "LR区分"   #LR     'STR)
	      )
	    )
	  )
		(if (= #Qry3$$ nil)
			(progn
				nil ;扉なし
			)
			(progn
				(setq #Qry3$ (car #Qry3$$));最初に見つかったもの
			)
		);_if
		;2016/11/11 YM ADD-E


		; 挿入点座標の計算
		(setq CG_TESTNO (1+ CG_TESTNO)) ; 回数
		(if (<= (nth  3 #Qry2$) 500)    ;寸法W値
			(setq CG_TEST_X (+ CG_TEST_X 2000)) ; W値累積
			(setq CG_TEST_X (+ CG_TEST_X 1000  (nth  3 #Qry2$))) ; W値累積
		);_if

		; 配置
;;;				(C:PosParts)
		(setq #sym (NS_PosParts #HINBAN #LR (list CG_TEST_X CG_TEST_Y #ZZ) 0.0 nil))
		;扉貼り付け
		(PCD_MakeViewAlignDoor (list #sym) 3 nil)
		(setq CG_GSYM$ (CFGetXData #sym "G_SYM"))  ;G_SYM

		;図面にﾃｷｽﾄ出力
;2016/11/11 YM DEL-S
;;;		(command "vpoint" "0,0,1")
;;;		(command "_.ZOOM" "C" (list CG_TEST_X CG_TEST_Y) 2000)
;2016/11/11 YM DEL-E

;UCS座標系変更 ;2016/11/11 YM ADD
	  (command "._ucs" "X" 90)
	  (command "._plan" "C")

		(##Write)

;WORLD座標系 ;2016/11/11 YM ADD
	  (command "._ucs" "W" )

		;◆◆◆機種名と間口があっているか？
		(##HANTEI)

		(if (= #LR "R")
			(progn ; "R"なら"L"も配置する
				(setq #LR "L")
			  (setq #Qry2$ ; LR込み複数あり
			    (car (CFGetDBSQLRec CG_DBSESSION "品番図形"
			      (list
							(list "品番名称" #HINBAN 'STR)
			        (list "LR区分"   #LR     'STR)
			      )
			    ))
			  )

				; 挿入点座標の計算
				(setq CG_TESTNO (1+ CG_TESTNO)) ; 回数
				(if (<= (nth  3 #Qry2$) 500);寸法W値
					(setq CG_TEST_X (+ CG_TEST_X 2000)) ; W値累積
					(setq CG_TEST_X (+ CG_TEST_X 1000  (nth  3 #Qry2$))) ; W値累積
				);_if
				(setq #sym (NS_PosParts #HINBAN #LR (list CG_TEST_X CG_TEST_Y #ZZ) 0.0 nil))
				;扉貼り付け
				(PCD_MakeViewAlignDoor (list #sym) 3 nil)
				(setq CG_GSYM$ (CFGetXData #sym "G_SYM"))  ;G_SYM
				;図面にﾃｷｽﾄ出力
;2016/11/11 YM DEL-S
;;;				(command "vpoint" "0,0,1")
;;;				(command "_.ZOOM" "C" (list CG_TEST_X CG_TEST_Y) 2000)
;2016/11/11 YM DEL-E

;UCS座標系変更 ;2016/11/11 YM ADD
	  (command "._ucs" "X" 90)
	  (command "._plan" "C")

		(##Write)

;WORLD座標系 ;2016/11/11 YM ADD
	  (command "._ucs" "W" )

				;◆◆◆機種名と間口があっているか？
				(##HANTEI)

			)
		);_if
	
	);_foreach


	(setq CG_TESTMODE nil) ; ﾃｽﾄﾓｰﾄﾞ



	;ｸﾞﾛｰﾊﾞﾙｸﾘｱｰ
	(setq CG_GSYM$ nil)

	(if #fil (close #fil))
	(startapp "notepad.exe" (strcat CG_SYSPATH "自動配置.txt"))


	(princ "\n--- 配置終了 ---")
  (setq *error* nil)
);C:newAutoPut





;*****************************************************************************:
; 品番のﾃｷｽﾄﾌｧｲﾙ==> ｷｬﾋﾞﾈｯﾄを自動配置(連続配置)
;*****************************************************************************:
(defun C:newAutoPutC (
	/
	#ALL$$ #DUM$$ #EN #ERR #HINBAN #I #II #KAISO$$ #KAO$ #KOSU #LIST$$ #LOOP #LR #LR_KOSU
	#QRY$$ #QRY2$ #QRY2$$ #SFILE #SKK #ST #UP_NO
	#SKK2 #SYM #ZZ #GSMW #HINBANW #HINZUKEIW #fil
	)

		;////////////////////////////////////////////////////////
		; SELPARTS.CFGの作成
		;////////////////////////////////////////////////////////
		(defun ##HANTEI (
			/
			#GSMW #HINBANW #HINZUKEIW #MAG 
			)

			(setq #hinzukeiW (nth 3 #Qry2$));[品番図形]W値
			(setq #hinzukeiH (nth 5 #Qry2$));[品番図形]H値

			(setq #gsmW (nth 3 CG_GSYM$))
			(setq #gsmH (nth 5 CG_GSYM$))

			(if (or (equal #skk1 1.0 0.001))
				(progn ;ｷｬﾋﾞﾈｯﾄなら

					(cond
						;2016/12/28 YM ADD-S
						((wcmatch #HINBAN "*87*")
						  (setq #hinbanW 875.0)
					 	)
						((wcmatch #HINBAN "*72*")
						  (setq #hinbanW 725.0)
					 	)
						;2016/12/28 YM ADD-E
						((wcmatch #HINBAN "*90*")
						  (setq #hinbanW 900.0)
					 	)
						((wcmatch #HINBAN "*75*")
						  (setq #hinbanW 750.0)
					 	)
						((wcmatch #HINBAN "*60*")
						  (setq #hinbanW 600.0)
					 	)
						((wcmatch #HINBAN "*45*")
						  (setq #hinbanW 450.0)
					 	)
						((wcmatch #HINBAN "*30*")
						  (setq #hinbanW 300.0)
					 	)
						((wcmatch #HINBAN "*15*")
						  (setq #hinbanW 150.0)
					 	)

						((wcmatch #HINBAN "*A5*")
						  (setq #hinbanW 1050.0)
					 	)
						((wcmatch #HINBAN "*B0*")
						  (setq #hinbanW 1200.0)
					 	)
						((wcmatch #HINBAN "*C5*")
						  (setq #hinbanW 1350.0)
					 	)
						((wcmatch #HINBAN "*D0*")
						  (setq #hinbanW 1500.0)
					 	)
						((wcmatch #HINBAN "*E5*")
						  (setq #hinbanW 1650.0)
					 	)
						((wcmatch #HINBAN "*F0*")
						  (setq #hinbanW 1800.0)
					 	)
						(T
						  nil
					 	)
					);_cond

				)
				(progn ;ｷｬﾋﾞ以外　品番から間口はわからない
					(setq #hinbanW #hinzukeiW)
				)
			);_if
					
			(princ (strcat "\n'" (nth 6 #Qry2$) "," #HINBAN "," #LR "," ) #fil);図形ID,品番,LR
			(princ "品番図形W,"  #fil)(princ #hinzukeiW #fil)
			(princ ",GSM_W値,"   #fil)(princ #gsmW      #fil)
			
			(if (or (equal #skk1 1.0 0.001))
				(progn ;ｷｬﾋﾞﾈｯﾄなら
					(princ ",機種名W値," #fil)(princ #hinbanW   #fil)
				)
			);_if

			(princ ",品番図形H," #fil)(princ #hinzukeiH #fil)
			(princ ",GSM_H値  ," #fil)(princ #gsmH      #fil)

			;判定
			(setq #flg0 nil);NGならT

			(if (and (equal #hinzukeiW #gsmW 0.001)
							 (equal #gsmW #hinbanW 0.001))
				(progn
					nil ;問題なし
				)
				(progn ;問題あり
					(setq #flg0 T);NGならT
				)
			);_if

					(if (equal #hinzukeiH #gsmH 0.001)
						(progn
							nil ;問題なし
						)
						(progn ;問題あり
							(setq #flg0 T);NGならT
						)
					);_if

					(if #flg0
						(princ ",★ＮＧ★" #fil)
					);_if


			(princ)
		);##HANTEI
		;////////////////////////////////////////////////////////


  ;// コマンドの初期化
;;;  (StartUndoErr)

	(setq #sFile (getfiled "機種名ﾘｽﾄのﾃｷｽﾄﾌｧｲﾙ" CG_SYSPATH "TXT" 4))
	(setq #List$$ (ReadCSVFile #sFile)) ; 新製品品番

	(setq CG_TESTMODE T) ; ﾃｽﾄﾓｰﾄﾞ
	(setq CG_TESTNO 0)   ; 回数
	(setq CG_TEST_X 0)   ; 配置X
	(setq CG_TEST_Y 0)   ; 配置Y

	(setq #ALL$$ nil)
	(setq #LR_KOSU 0)
	(setq #ERR nil) ; ｴﾗｰﾌﾗｸﾞ(ﾃｷｽﾄﾌｧｲﾙの品番に追加部材を含むと'T)


	; ﾌｧｲﾙOPEN
  (setq #fil (open (strcat CG_SYSPATH "自動配置.csv") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
	(princ #date_time #fil) ; 日付書き込み
	(princ "\n" #fil)


	;2014/08/19 YM ADD-S 品番の変わりに図形IDでもOK
	(if (= 'INT (type (read (car (car #List$$)))))
		(progn ;図形IDだった
			;品番名称に変換

			(setq #hin$ nil)
			(foreach #List$ #List$$
				(setq #zukeiID (car #List$))
			  (setq #Qry$$
			    (CFGetDBSQLRec CG_DBSESSION "品番図形"
			      (list	(list "図形ID" #zukeiID 'STR))
			    )
			  )
				(if (= #Qry$$ nil) ; //////////////////////////////////////////////////////////////////
					(progn
						(CFAlertMsg	(strcat "\n品番図形にﾚｺｰﾄﾞがない.\n★★★ " #zukeiID " ★★★"))
						(setq #ERR T)
					)
					(progn
						;品番名称
						(setq #hin (car (car #Qry$$)))
						(setq #hin$ (append #hin$ (list (list #hin))))
					)
				);_if

			);_foreach

			(setq #List$$ #hin$)
		)
	);_if
	;2014/08/19 YM ADD-E 品番の変わりに図形IDでもOK


;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(foreach #List$ #List$$
		(setq #hinban (car #List$))
	  (setq #Qry$$
	    (CFGetDBSQLRec CG_DBSESSION "品番基本"
	      (list	(list "品番名称" #hinban 'STR))
	    )
	  )
		(if (or (= #Qry$$ nil)(> (length #Qry$$) 1)) ; //////////////////////////////////////////////////////////////////
			(progn
				(CFAlertMsg	(strcat "\n品番基本にﾚｺｰﾄﾞがないかまたは複数ありました.\n★★★ " #hinban " ★★★"))
				(setq #ERR T)
			)
			(progn
				(setq #Qry$ (car #Qry$$))
				(if (equal 1.0 (nth 1 #Qry$) 0.001)
					(progn
						(setq #LR "L")
						(setq #ALL$$ (append #ALL$$ (list (append #Qry$ (list #LR)))))
						(setq #LR "R")
						(setq #ALL$$ (append #ALL$$ (list (append #Qry$ (list #LR)))))
					)
					;else
					(progn
						(setq #LR "Z")
						(setq #ALL$$ (append #ALL$$ (list (append #Qry$ (list #LR)))))
					)
				);_if


;;;				(setq #SKK (nth 3 (car #Qry$$))) ; 性格ｺｰﾄﾞ
			)
		);_if

	);_foreach


	(if #ERR
		(progn
			(CFAlertMsg "自動配置を終了します.")
			(quit)
		)
	);_if

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq #kosu (length #ALL$$))

	; 品番図形,品番基本を検索
	(foreach #Qry$ #ALL$$

		(setq #hinban (nth  0 #Qry$))
		(setq #skk    (nth  3 #Qry$))
		(setq #LR     (nth 11 #Qry$))

		;2014/07/21 YM ADD
		(setq #skk1 (CFGetSeikakuToSKKCode #skk 1)) ;1桁目
		(setq #skk2 (CFGetSeikakuToSKKCode #skk 2)) ;2桁目
		(setq #skk3 (CFGetSeikakuToSKKCode #skk 3)) ;3桁目
		(if (equal #skk2 2.0 0.001)
			(setq #ZZ 2300)
			;else
			(setq #ZZ 0)
		);_if
		
	  (setq #Qry2$$ ; LR込み複数あり
	    (CFGetDBSQLRec CG_DBSESSION "品番図形"
	      (list
					(list "品番名称" #HINBAN 'STR)
	        (list "LR区分"   #LR     'STR)
	      )
	    )
	  )

		(if (or (= #Qry2$$ nil)(> (length #Qry2$$) 1)) ; //////////////////////////////////////////////////////////////////
			(progn
				(CFAlertMsg	(strcat "\n品番図形にﾚｺｰﾄﾞがないかまたは複数ありました.\n★★★ " #hinban " ★★★"))
			)
			(progn
				(setq #Qry2$ (car #Qry2$$))
			)
		);_if

		; 挿入点座標の計算
		(setq CG_TESTNO (1+ CG_TESTNO)) ; 回数
		; 配置
		(setq #sym (NS_PosParts #HINBAN #LR (list CG_TEST_X CG_TEST_Y #ZZ) 0.0 nil))
		;扉貼り付け
		(PCD_MakeViewAlignDoor (list #sym) 3 nil)
		(setq CG_GSYM$ (CFGetXData #sym "G_SYM")) ;G_SYM

		;◆◆◆機種名と間口があっているか？
		(##HANTEI)

		;G_CGﾁｪｯｸ
		(setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
		(setq #id  (nth 0 #xd_LSYM$));図形ID
		(setq #hin (nth 5 #xd_LSYM$));品番
		(setq #LR  (nth 6 #xd_LSYM$));LR
		(setq #seikaku (nth 9 #xd_LSYM$));性格CODE

	  (setq #ss (CFGetSameGroupSS #sym));ｸﾞﾙｰﾌﾟ図形
	  (setq #i 0)(setq #GCG_FLG nil)
	  (repeat (sslength #ss)
	    (setq #en (ssname #ss #i))
	    (setq #xd$ (CFGetXData #en "G_CG"))
			(if #xd$
				(progn
					(setq #GCG_FLG T)
					(princ "\nG_CG: " #fil)(princ #xd$ #fil)
				)
			);_if
	    (setq #i (1+ #i))
	  );repeat
		(if (= #GCG_FLG nil)
			(princ "\n★★★　G_CGがない" #fil)
		);_if
		(princ "\n********************************" #fil)

		;GSMのW値だけ次の配置位置を増やす
		(setq #gsmW (nth 3 CG_GSYM$))
		(setq CG_TEST_X (+ CG_TEST_X #gsmW))
	
	);_foreach


	(setq CG_TESTMODE nil) ; ﾃｽﾄﾓｰﾄﾞ

;;;  (if (CFYesNoDialog "図形ﾁｪｯｸを行いますか？")(C:GSM))

	;ｸﾞﾛｰﾊﾞﾙｸﾘｱｰ
	(setq CG_GSYM$ nil)

	(if #fil (close #fil))
	(startapp "notepad.exe" (strcat CG_SYSPATH "自動配置.csv"))

	(princ "\n配置終了")

  (setq *error* nil)
);C:newAutoPutC


;<HOM>*************************************************************************
; <関数名>    : NS_PosParts
; <処理概要>  : 配置
; <戻り値>    :
; <作成>      : 2014/06/23 YM ADD
; <備考>      :
;*************************************************************************>MOH<
(defun NS_PosParts (
	&HinBan
	&LR
	&Pos
	&Ang
	&Dan  ;;  断面指示有無  2005/01/13 G.YK ADD
  /
	#ANG #DWG #FIGUREREOCRD #GLSYM #KIHONREOCRD #POS #SS_DUM #SYM
  )
  (setq #sym nil) ; 04/10/01 G.YK ADD

	;性格CODE取得のため
  (setq #KihonReocrd (car 
	  (CFGetDBSQLRec CG_DBSESSION "品番基本"
	    (list
		    (list "品番名称" &HinBan 'STR)
		    (list "LR有無"   (if (= "Z" &LR) "0" "1") 'INT)
	    )
		)
  ))
;;;  (WebOutLog "品番基本:")(WebOutLog #KihonReocrd)
;;(princ "\n#KihonReocrd: ")(princ #KihonReocrd)

	;図形ID取得のため
  (setq #FigureReocrd (car 
	  (CFGetDBSQLRec CG_DBSESSION "品番図形"
		  (list
		    (list "品番名称" &HinBan 'STR)
		    (list "LR区分"   &LR     'STR)
		  )
		)
  ))



  (setq #dwg (nth 6 #FigureReocrd))

  (if (findfile (strcat CG_MSTDWGPATH #dwg ".dwg"))
    (progn
	    ; 部材の挿入
	    (command "_insert" (strcat CG_MSTDWGPATH #dwg) &Pos "1" "" (rtd &Ang))

	    ; 配置原点と角度を確保 LSYMの設定のため
	    (setq #Pos (cdr (assoc 10 (entget (entlast)))))
	    (setq #Ang (cdr (assoc 50 (entget (entlast)))))

	    ; 分解&グループ化
	    (command "_explode" (entlast))  ; インサート図形分解
			(setq #ss_dum (ssget "P"))
			(SKMkGroup #ss_dum)
			(setq #sym (PKC_GetSymInGroup #ss_dum))

	    ; LSYMの設定
	    (setq #glsym
	      (list
		      #dwg                        ;1 :本体図形ID  :『品番図形』.図形ID
		      #Pos                        ;2 :挿入点    :配置基点
		      #Ang                        ;3 :回転角度  :配置回転角度
		      CG_Kcode                    ;4 :工種記号  :CG_Kcode
		      CG_SeriesCode               ;5 :SERIES記号  :CG_SeriesCode
		      &HinBan                     ;6 :品番名称  :『品番図形』.品番名称
		      &LR                         ;7 :L/R区分   :『品番図形』.部材L/R区分
		      ""                          ;8 :扉図形ID  :
		      ""                          ;9 :扉開き図形ID:
		      (fix (nth 3 #KihonReocrd))  ;10:性格CODE  :『品番基本』.性格CODE
		      0                           ;11:複合フラグ  :０固定（単独部材）
		      0                           ;12:配置順番号  :配置順番号(1～)
		      (fix (nth 2 #FigureReocrd)) ;13:用途番号  :『品番図形』.用途番号
		      (nth 5 #FigureReocrd)       ;14:寸法Ｈ  :『品番図形』.寸法Ｈ
		      (if (/= &Dan nil) &Dan 0)   ;15.断面指示の有無  :『プラ構成』.断面有無  ;;  2005/01/13 G.YK ADD
	      )
	    )
	    (CFSetXData #sym "G_LSYM" #glsym)

	    (KcSetG_OPT #sym)                         ;ひもつきオプション品(図形なし)をセットする
	    (SetLayer)                                ;レイヤーを元の状態に戻す
		)
    (progn
			(CFAlertMsg (strcat "図形がありません.図形ID= "  #dwg "  \n品番名称= " &HinBan "  LR区分= "  &LR))
			(quit)
		)
	);_if

	;戻り値
  #sym
);NS_PosParts





;//////////////////////////////////////////////////////////
; C:AUTO_PLAN , C:IDCheck で使用
;//////////////////////////////////////////////////////////
(defun RepeatPlan (&i &loop #case_lis / )
  (repeat &loop     ; 繰り返し回数
    (setq #case_lis (append #case_lis (list &i)))
    (setq &i (1+ &i))
  )
  #case_lis
);RepeatPlan
;//////////////////////////////////////////////////////////

;//////////////////////////////////////////////////////////
; ﾌﾟﾗﾝ検索自動ﾃｽﾄ 00/03/03 YM
; 01/10/11 YM 改良
;//////////////////////////////////////////////////////////
(defun C:AUTO_PLAN (
  /
  #CASE_LIS #LOOP #NEND #NO #NSTART
  )
  (setq CG_TESTMODE 1)    ;ﾃｽﾄﾓｰﾄﾞ
  (setq CG_AUTOMODE 0)    ;自動ﾓｰﾄﾞ
  (setq CG_DEBUG 1)       ;ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞ

  ; 01/10/11 YM ADD-S
  (princ "\nプラン検索を連続実行します")
  (setq #nStart (getint "\n開始番号を入力(5001,7001など): "))
  (setq #nEnd   (getint "\n終了番号を入力: "))
  (setq #loop (1+ (- #nEnd #nStart)))
  ; 01/10/11 YM ADD-E

  (setq #case_lis '())
  (setq #case_lis (RepeatPlan #nStart #loop #case_lis)) ; 開始番号,繰り返し数

  (foreach #i #case_lis
    (setq CG_TESTCASE #i)
    (setq #no (strcat "case" (itoa #i)))

    (setq CG_KENMEI_PATH (strcat CG_KENMEIDATA_PATH #no "\\")) ; \BUKKEN\case?
    (setq S_FILE (strcat CG_KENMEI_PATH "MODEL.DWG")) ; \BUKKEN\case?\DWGのﾊﾟｽ

    (if (= (getvar "DWGPREFIX") CG_KENMEI_PATH)
      (progn
        (CFAlertMsg (strcat "\n ﾌｫﾙﾀﾞ削除できないため、ﾃｽﾄ対象以外のﾀﾞﾐｰ物件に移動して下さい."
                            "\n(もう一度図面を開き直して下さい)"))
        (quit)
      )
    );_if

    ;// case? フォルダ削除
    (vl-file-delete (strcat CG_KENMEI_PATH "MODEL.DWG"))
    (vl-file-delete (strcat CG_KENMEI_PATH "MODEL.BAK"))
;;;   (dos_delete (strcat CG_KENMEI_PATH "MODEL.DWG"))                         ; model.dwg
;;;   (dos_delete (strcat CG_KENMEI_PATH "MODEL.BAK"))                         ; model.dwg
;;;   (dos_rmdir (strcat CG_KENMEIDATA_PATH #no)) ; \BUKKEN\case?

    (setq CG_BukkenNo #no)
    (setq CG_BukkenName #no)

    (setq CG_SetXRecord$
      (list
        CG_DBNAME
        CG_SeriesCode
        CG_BrandCode
        CG_DRSeriCode
        CG_DRColCode
        CG_UpCabHeight
        CG_CeilHeight
        CG_RoomW
        CG_RoomD
        "1"                  ;ガス種
        "5"                  ;電気種
      )
    )

    (setq CG_OpenMode 0)
    (command "_point" "0,0")

    ;// 新規件名作成
;;;   (dos_mkdir (strcat CG_KENMEIDATA_PATH #no "\\")) ; \BUKKEN\case?

    (vl-file-copy (strcat CG_SYSPATH "ORGMODEL.DWG") S_FILE)
;;;   (dos_copy (strcat CG_SYSPATH "ORGMODEL.DWG") S_FILE)

    (if (/= (getvar "DBMOD") 0)
      (progn
        (command "_qsave")
        (vl-cmdf "._open" S_FILE)
      )
      (progn
        (vl-cmdf "._open" S_FILE)
      )
    );_if

    (S::STARTUP)
    (C:SearchPlan) ; ﾌﾟﾗﾝ検索 開始
    (c:qq) ; 図面上のｷｬﾋﾞ情報書き出し
    (setq #i (1+ #i))
  );foreach

  ; 保存
  (command "_.QSAVE")

  (setq CG_TESTMODE nil) ;ﾃｽﾄﾓｰﾄﾞ
  (setq CG_AUTOMODE 0)   ;自動ﾓｰﾄﾞ
  (setq *error* nil)
  (princ)
);C:AUTO_PLAN

;*****************************************************************************:
; cfgﾌｧｲﾙ分割作成 01/06/18 YM ﾅｽｽﾃﾝﾚｽ-ｾｽﾊﾟｼﾘｰｽﾞ用
; 元cfgﾌｧｲﾙ場所： CG_SYSPATH \TMP
;*****************************************************************************:
(defun C:MakeCFG (
  /
  #FLG #IFILE #IP #K #LINE #NUM #OFILE #OP
  )
  ;ナス-セスパ All cfg
  (setq #ifile (strcat CG_SYSPATH "TMP\\ALL_CFG_" CG_SeriesDB ".prn"))
  (setq #ip (open #ifile "r"))

  (setq #k 1001)
  (setq #num (itoa #k))
  ; 最初のﾌｧｲﾙを開く "1001"
  (setq #ofile (strcat CG_SYSPATH "TMP\\makecfg\\" "Srcpln" "_" CG_SeriesDB "_" #num ".cfg"))
  (setq #op (open #ofile "w"))

  (setq #flg T)
  (while (setq #line (read-line #ip))
    (if (and (= #flg nil)(= ";" (substr #line 1 1)))
      (progn
        (close #op)
        (setq #k (1+ #k))
        (setq #num (itoa #k))
        (setq #ofile (strcat CG_SYSPATH "TMP\\makecfg\\" "Srcpln" "_" CG_SeriesDB "_" #num ".cfg"))
        (setq #op (open #ofile "w"))
        (princ (strcat #line "\n") #op)
      )
      (princ (strcat #line "\n") #op)
    );_if
    (setq #flg nil)
  )
  (close #ip)
  (close #op)
  (princ)
);C:MakeCFG

;-------------- 旧型"G_LSYM"にする---------- 01/11/01 YM
(defun c:OLD ( / #I #SS #SYM #XD$)
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #sym (ssname #ss #i))
    (setq #xd$ (CFGetXData #sym "G_LSYM"))
    ;// 拡張データの更新
    (CFSetXData #sym "G_LSYM"
      (CFModList #xd$
        (list (list 7 "Z")(list 8 "Z"))
      )
    )
    (setq #i (1+ #i))
  )
  (princ)
);c:OLD

;*****************************************************************************:
; 複合管理,複合構成テーブル作成ツール(NAS ｺﾝﾛ選択肢追加)
; 使用場所:CG_SYSPATH \TEMP
; 02/01/21 YM
; ｺﾝﾛ選択肢ﾃｷｽﾄﾌｧｲﾙ,複合管理,複合構成の雛形CSVﾌｧｲﾙ使用
;*****************************************************************************:
(defun C:MK_HUKU_GAS (
  /
  #FP1 #FP2 #GAS #GAS_NAME #HINBAN #HUKU_ID #I #IFNAME1 #IFNAME2 #IFNAME3
  #KIGO #KIGO$ #LIST1$$ #LIST2$$ #LIST3$$ #NEWLIST$ #NEWLIST$$ #NEWLIST2$ #NEWLIST2$$
  #OFNAME1 #OFNAME2 #STRLEN
  )

  ; CKS時
;;; (setq #ptn 50) ; 雛形に含まれる構成ﾊﾟﾀｰﾝ(40→多めに50)
  ; CKS時
  (setq #ptn 10) ; 雛形に含まれる構成ﾊﾟﾀｰﾝ(8→多めに10)

    ;/////////////////////////////////////////////////////////////////
    (defun ##ChGasName (
      &ORG ; 変更元
      &GAS ; ｺﾝﾛ品番
      /
      #no #res
      )
      (setq #strlen (strlen &ORG)) ; 文字列長さ
      (setq #no (vl-string-search "+" &ORG))
      (setq #res (strcat &GAS " " (substr &ORG (1+ #no)(- #strlen #no))))
      #res
    )
    ;/////////////////////////////////////////////////////////////////
    (defun ##OUTPUT (
      &LIS$$ ; 出力ﾘｽﾄ
      &fp    ; ﾌｧｲﾙ識別子
      /
      #I #N
      )
      (setq #n 1)
      (foreach #NewList$ &LIS$$
        (setq #i 1)
        (foreach #NewList #NewList$
          (if (= #i 1)
            (princ #NewList &fp)
            (princ (strcat "," #NewList) &fp)
          );_if
          (setq #i (1+ #i))
        )
        (princ "\n" &fp)
        (setq #n (1+ #n))
      )
      (close &fp)
      (princ)
    )
    ;/////////////////////////////////////////////////////////////////


  ; ｺﾝﾛ記号
  (setq #kigo$ (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"
                     "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
                     "U" "V" "W" "X" "Y" "Z"))
;;; ;複合管理 CKS
;;; (setq #ifname1 (strcat CG_SYSPATH "TEMP\\S-GAS.txt"))    ; 選択肢ﾌｧｲﾙ(この数分ﾛｰﾌﾟ)
;;; (setq #ifname2 (strcat CG_SYSPATH "TEMP\\S-GAS-TMP.csv"))  ; 雛形となる複合管理ﾃｰﾌﾞﾙのﾚｺｰﾄﾞ
;;; (setq #ifname3 (strcat CG_SYSPATH "TEMP\\S-GAS-TMP2.csv")) ; 雛形となる複合構成ﾃｰﾌﾞﾙのﾚｺｰﾄﾞ
;;; (setq #ofname1 (strcat CG_SYSPATH "TEMP\\S-GAS-OUT.csv"))  ; 出力ﾌｧｲﾙ(複合管理)
;;; (setq #ofname2 (strcat CG_SYSPATH "TEMP\\S-GAS-OUT2.csv")) ; 出力ﾌｧｲﾙ(複合構成)

  ;複合管理 CKN
  (setq #ifname1 (strcat CG_SYSPATH "TEMP\\N-GAS.txt"))    ; 選択肢ﾌｧｲﾙ(この数分ﾛｰﾌﾟ)
  (setq #ifname2 (strcat CG_SYSPATH "TEMP\\N-GAS-TMP.csv"))  ; 雛形となる複合管理ﾃｰﾌﾞﾙのﾚｺｰﾄﾞ
  (setq #ifname3 (strcat CG_SYSPATH "TEMP\\N-GAS-TMP2.csv")) ; 雛形となる複合構成ﾃｰﾌﾞﾙのﾚｺｰﾄﾞ
  (setq #ofname1 (strcat CG_SYSPATH "TEMP\\N-GAS-OUT.csv"))  ; 出力ﾌｧｲﾙ(複合管理)
  (setq #ofname2 (strcat CG_SYSPATH "TEMP\\N-GAS-OUT2.csv")) ; 出力ﾌｧｲﾙ(複合構成)

  (setq #fp1 (open #ofname1 "w"))
  (setq #fp2 (open #ofname2 "w"))
  (setq #List1$$ (ReadCSVFile #ifname1)) ; ｺﾝﾛ選択肢
  (setq #List2$$ (ReadCSVFile #ifname2)) ; 雛形複合管理
  (setq #List3$$ (ReadCSVFile #ifname3)) ; 雛形複合構成

  (setq #NewList1$$ nil); 複合管理
  (setq #NewList2$$ nil); 複合構成

  (setq #j 0)
  (foreach #List1$ #List1$$   ; 選択肢分ﾙｰﾌﾟ
    (setq #GAS (car #List1$)) ; ｶﾞｽ品番
    (setq #kigo (nth #j #kigo$))
    (setq #k 0) ; 通し番号
    ; *** 複合管理 ***
    (foreach #List2$ #List2$$ ; 複合管理 雛形ﾚｺｰﾄﾞ分ﾙｰﾌﾟ
      (setq #huku_ID (atoi (nth 0 #List2$))) ; 複合ID 1～40ﾊﾟﾀｰﾝ
      (setq #GAS_NAME (nth 16 #List2$))
      (setq #GAS_NAME (##ChGasName #GAS_NAME #GAS))
      (setq #NewList1$
        (CFModList #List2$
          (list
            (list  0 (itoa (+ #huku_ID (* #ptn #j)))) ; 50×0,1,2...
            (list  9 #KIGO)                           ; A,B,C,...
            (list 16 #GAS_NAME)                       ; 調理器名称
            (list 17 (strcat #kigo (itoa #k)))
          )
        )
      )
      (setq #NewList1$$ (append #NewList1$$ (list #NewList$))) ; 複合管理
      (setq #k (1+ #k))
      (princ "\n")(princ (strcat #kigo (itoa #k)))
    );_foreach

    ; *** 複合構成 ***
    (foreach #List3$ #List3$$ ; 雛形ﾚｺｰﾄﾞ分ﾙｰﾌﾟ(複合構成)
      (setq #huku_ID (atoi (nth 0 #List3$))) ; 複合ID
      (setq #hinban (nth 2 #List3$))
      (if (= "" #hinban)
        (setq #hinban #GAS) ; 雛形で品番=""のときはｺﾝﾛ品番を代入
      );_if
      (setq #NewList2$
        (CFModList #List3$
          (list
            (list 0 (itoa (+ #huku_ID (* #ptn #j)))) ; 文字列に
            (list 2 #hinban)
          )
        )
      )
      (setq #NewList2$$ (append #NewList2$$ (list #NewList2$)))
    );_foreach
    (princ "\n*** j ***")(princ #j)
    (setq #j (1+ #j))
  );_foreach

  ; ﾌｧｲﾙ出力(csv形式)複合管理
  (##OUTPUT #NewList1$$ #fp1)
  ; ﾌｧｲﾙ出力(csv形式)複合構成
  (##OUTPUT #NewList2$$ #fp2)

  (princ)
);C:MK_HUKU_GAS

;//////////////////////////////////////////////////////////
; C:Del0door 図面上の"0_DOOR"画層図形を全て削除
;//////////////////////////////////////////////////////////
(defun C:Del0door (
  /
  #ELM #I #SS #LAYER$ #FLG #SS0_DOOR #STR
  )
  (StartUndoErr);// コマンドの初期化

  ; 部材更新が必要かどうか判定する
  (setq #flg nil)
  (setq #ss0_door (ssget "X" (list (cons 8 "0_door"))))
  (if (and #ss0_door (/= 0 (sslength #ss0_door)))
    (setq #flg T)
  );_if

  ; 図面の残骸を削除
;;; (CFAlertMsg "図面の残骸を削除します")
;;; (princ "図面の残骸を削除します")
  (setq #layer$
    (list "0_door" "0_plane" "0_wall")
  )
  (setq #str "") ; 警告文
  (foreach #layer #layer$
    (setq #ss (ssget "X" (list (cons 8 #layer))))
    (if (and #ss (/= 0 (sslength #ss)))
      (progn
        (setq #i 0)
        (repeat (sslength #ss)
          (setq #elm (ssname #ss #i))
          (if (entget #elm)
            (entdel #elm)
          );_if
          (setq #i (1+ #i))
        )
        (setq #str (strcat #str (itoa (sslength #ss)) "個の" #layer "\n"))
      )
    );_if
  );foreach

  (if (/= #str "")
    (progn
      (setq #str (strcat #str "\n画層の図形を削除しました"))
;;;     (CFAlertMsg #str)
      (princ #str)
    )
    (princ "\n図面に残骸がありませんでした")
  );_if

  (if #flg
    (progn
      (CFAlertMsg "\n展開図作成に失敗した残骸があるため、部材を再配置します\n(扉は全て張り直します)")
      (C:KPRefreshCAB) ; 部材更新ｺﾏﾝﾄﾞ
    )
  );_if

  (setq *error* nil)
;;; (princ "\n***********************")
;;; (princ "\n★図面の復元処理終了★")
;;; (princ "\n***********************")
  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : C:DELMEJI
; <処理概要>  : ｼﾝﾎﾞﾙとひもついてないG_MEJIを削除する
; <戻り値>    :
; <作成>      : 02/03/04 YM
; <備考>      :
;*************************************************************************>MOH<
(defun C:DELMEJI (
  /
  #I #MEJI #N #SS #XDMEJI$ ; 02/09/04 YM ADD
  )
  (setq #SS (ssget "X" '((-3 ("G_MEJI" (1070 . 1))))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0 #n 0)
      (repeat (sslength #SS)
        (setq #MEJI (ssname #SS #i))
        (setq #xdMEJI$ (CFGetXData #MEJI "G_MEJI"))
        (if (= nil (SKD_GetGroupSymbole (entget #MEJI)))
          (progn
            (setq #n (1+ #n))
            (entdel #MEJI)
          )
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  (princ)
);C:DELMEJI

;<HOM>*************************************************************************
; <関数名>    : C:qq
; <処理概要>  : ﾌﾟﾗﾝ検索品番ﾁｪｯｸ用(図面上の品番をNOTEPADに出力)
; <戻り値>    :
; <作成>      : 02/04/03 YM
; <備考>      : ﾌﾟﾗﾝは(0,0)に角度=0で配置してるものとする
;*************************************************************************>MOH<
(defun C:QQ (
  /
  #BASE$$ #FIL #GAS$$ #HINBAN #I #PT #RANGE$$ #SINK$$ #SS_LSYM #SUI$$ #SYM
  #WALL$$ #XD$ #ID #LR #XDLSYM$
  )
  ; file open
;;;  (setq #fil (open (strcat CG_SYSPATH "qq.txt") "W" ))
  (setq #fil (open (strcat CG_SYSPATH "qq.txt") "A" )) ; 02/04/16 YM MOD

  ; LSYM 検索(品番,ｼﾝﾎﾞﾙ位置のﾘｽﾄ作成)
  (setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM"))))) ; G_LSYM 図形選択ｾｯﾄ
  (if (and #ss_LSYM (< 0 (sslength #ss_LSYM)))
    (progn
      (setq #i 0)
      (setq #Base$$ nil #Wall$$ nil)
      (setq #Sink$$ nil #Gas$$  nil #Range$$ nil #Sui$$ nil)
      (repeat (sslength #ss_LSYM)
        (setq #sym (ssname #ss_LSYM #i))
        (setq #pt (cdr (assoc 10 (entget #sym))))   ; ｼﾝﾎﾞﾙ座標位置
        (setq #xdLSYM$ (CFGetXData #sym "G_LSYM"))
        (setq #hinban (nth 5 #xdLSYM$))             ; 品番
        (setq #LR     (nth 6 #xdLSYM$))             ; L/R
        (setq #hinban (strcat #hinban "(" #LR ")"))
        (setq #ID     (nth 0 #xdLSYM$))             ; 図形ID

        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_CAB) ; 性格ｺｰﾄﾞ1桁
          (progn ; ｷｬﾋﾞﾈｯﾄ
            (if (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_BAS) ; 性格ｺｰﾄﾞ2桁
              (setq #Base$$ (append #Base$$ (list (list #hinban #ID #pt)))) ; ﾍﾞｰｽ
            );_if
            (if (= (CFGetSymSKKCode #sym 2) CG_SKK_TWO_UPP) ; 性格ｺｰﾄﾞ2桁
              (setq #Wall$$ (append #Wall$$ (list (list #hinban #ID #pt)))) ; 吊戸
            );_if
          )
        );_if

        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_SNK) ; ｼﾝｸ
          (setq #Sink$$ (append #Sink$$ (list (list #hinban #ID #pt)))) ; 吊戸
        );_if

        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_GAS) ; ｺﾝﾛ
          (setq #Gas$$ (append #Gas$$ (list (list #hinban #ID #pt)))) ; 吊戸
        );_if

        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_RNG) ; ﾌｰﾄﾞ
          (setq #Range$$ (append #Range$$ (list (list #hinban #ID #pt)))) ; 吊戸
        );_if

        (if (= (CFGetSymSKKCode #sym 1) CG_SKK_ONE_WTR) ; 水栓
          (setq #Sui$$ (append #Sui$$ (list (list #hinban #ID #pt)))) ; 吊戸
        );_if

        (setq #i (1+ #i))
      )
    )
  );_if

  ;/////////////////////////////////////////////////////////////////////////////////
  ; ﾃｷｽﾄ書き出し
  ;/////////////////////////////////////////////////////////////////////////////////
      (defun ##Write (
        &lis$$
        &str
        /

        )
        (if &lis$$
          (progn
            (princ &str #fil)
            (foreach #lis$ &lis$$
              (princ (strcat "\n " (car #lis$) " , " (cadr #lis$)) #fil) ; 品番,図形ID
            )
            (princ "\n" #fil)
          )
        );_if
        (princ)
      );##Write
  ;/////////////////////////////////////////////////////////////////////////////////
  ; ｷｬﾋﾞﾈｯﾄ用 ﾃｷｽﾄ書き出し
  ;/////////////////////////////////////////////////////////////////////////////////
      (defun ##WriteCab (
        &lis$$
        &str
        /
        #1$ #GAS$$ #LIS$$ #PT #SNK$$
        )
        (princ &str #fil)
        ; ｼﾝｸ側,ｺﾝﾛ側に分ける
        (setq #snk$$ nil) ; ｼﾝｸ側
        (setq #gas$$ nil) ; ｺﾝﾛ側
        (foreach #lis$ &lis$$
          (setq #pt (caddr #lis$)) ; ｼﾝﾎﾞﾙ座標
          (if (equal (distance #pt '(0 0 0)) 0 0.001)
            (progn ; ｺｰﾅｰ
              (setq #1$ (list (list (car #lis$)(cadr #lis$)))) ; 1番目(品番,ID)
            )
            (progn
              (cond
                ((equal (cadr #pt) 0 0.001) ; Y=0
                   ; X座標,品番,図形ID
                  (setq #snk$$ (append #snk$$ (list (list (car #lis$)(cadr #lis$)(car #pt)))))
                )
                ((equal (car #pt) 0 0.001)  ; X=0
                   ; Y座標,品番,図形ID
                  (setq #gas$$ (append #gas$$ (list (list (car #lis$)(cadr #lis$)(cadr #pt)))))
                )
              );_cond
            )
          );_if
        );foreach

        ; 座標を見てｿｰﾄする
        (setq #snk$$ (CFListSort #snk$$ 2)) ; (nth 2 が小さいもの順にｿｰﾄ
        (setq #gas$$ (CFListSort #gas$$ 2)) ; (nth 2 が小さいもの順にｿｰﾄ

        (setq #lis$$ (append #1$ #snk$$ #gas$$))
        (##Write #lis$$ "")

        (princ)
      );##WriteCab
  ;/////////////////////////////////////////////////////////////////////////////////
  (princ "\n************************************************" #fil)
  (if CG_TESTCASE ; 02/04/16 YM
    (princ (strcat "\nCASE = " (itoa CG_TESTCASE)) #fil)
    (princ "\n" #fil)
  )
  (princ "\n★品番一覧★" #fil)
  (princ "\n" #fil)
  (##WriteCab #Base$$ "\n<ﾍﾞｰｽｷｬﾋﾞ>")
  (##WriteCab #Wall$$ "\n<ｳｫｰﾙｷｬﾋﾞ>")
  (##Write #Sink$$ "\n<ｼﾝｸ>")
  (princ "\n------------------------------------------------" #fil)
  (##Write #Gas$$ "\n<ｺﾝﾛ>")
  (##Write #Range$$ "\n<ﾌｰﾄﾞ>")
  (##Write #Sui$$ "\n<水栓>")

  (close #fil)
;;; (startapp "notepad.exe" (strcat CG_SYSPATH "qq.txt"))

  (princ)
);C:QQ

(defun c:ccc( )
  (KChkZumenInfo)
  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : KCGetZumenInfo
; <処理概要>  : 図面上の図形存在状況を取得する
; <戻り値>    : なし
; <作成>      : 02/04/22 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KCGetZumenInfo(
  /
  #EN #I #KOSU0 #LAYER #N1 #N10 #N11 #N12 #N2 #N3 #N4 #N5 #N6 #N7 #N8 #N9 #NAME #SS0
  )
;---図面上の図形情報を取得-----------------------------------------------------------------
  (setq #ss0 (ssget "X" ))
  (if (and #ss0 (< 0 (sslength #ss0)))
    (progn
      (setq #kosu0 (sslength #ss0))
      (princ "\n")
      (princ "\n全図形の個数= ")(princ #kosu0)
      (setq #i 0)
      (setq #n1 0 #n2 0 #n3 0 #n4 0 #n5 0 #n6 0 #n7 0 #n8 0 #n9 0 #n10 0 #n11 0 #n12 0)
      (repeat #kosu0
        (setq #en (ssname #ss0 #i))
        (setq #name  (cdr (assoc 0 (entget #en))))
        (setq #LAYER (cdr (assoc 8 (entget #en))))
        (cond
          ((= #name "LINE")       (setq #n1 (1+ #n1)))
          ((= #name "3DSOLID")    (setq #n2 (1+ #n2)))
          ((= #name "ARC")        (setq #n3 (1+ #n3)))
          ((= #name "SPLINE")     (setq #n4 (1+ #n4)))
          ((= #name "INSERT")
            (setq #n5 (1+ #n5))
            (princ (strcat "\n画層: " #LAYER))
          )
          ((= #name "ELLIPSE")    (setq #n6 (1+ #n6)))
          ((= #name "LWPOLYLINE") (setq #n7 (1+ #n7)))
          ((= #name "POINT")      (setq #n8 (1+ #n8)))
          ((= #name "CIRCLE")     (setq #n9 (1+ #n9)))
          ((= #name "DIMENSION")  (setq #n10 (1+ #n10)))
          ((= #name "VIEWPORT")   (setq #n11 (1+ #n11)))
          (T
            (princ (strcat "\n図形ﾀｲﾌﾟ: " #name))
            (setq #n12 (1+ #n12))
          )
        );_cond
        (setq #i (1+ #i))
      )
    )
  );_if

  (princ "\n------------------------------------")
  (princ (strcat "\nLINE:       " (itoa #n1)))
  (princ (strcat "\n3DSOLID:    " (itoa #n2)))
  (princ (strcat "\nARC:        " (itoa #n3)))
  (princ (strcat "\nSPLINE:     " (itoa #n4)))
  (princ (strcat "\nINSERT:     " (itoa #n5)))
  (princ (strcat "\nELLIPSE:    " (itoa #n6)))
  (princ (strcat "\nLWPOLYLINE: " (itoa #n7)))
  (princ (strcat "\nPOINT:      " (itoa #n8)))
  (princ (strcat "\nCIRCLE:     " (itoa #n9)))
  (princ (strcat "\nDIMENSION:  " (itoa #n10)))
  (princ (strcat "\nVIEWPORT:   " (itoa #n11)))
  (princ (strcat "\nその他:     " (itoa #n12)))
  (princ "\n------------------------------------")
  (princ (strcat "\n合計:       " (itoa (+ #n1 #n2 #n3 #n4 #n5 #n6 #n7 #n8 #n9 #n10 #n11 #n12))))
  (princ "\n------------------------------------")
  (princ "\n------------------------------------")
  (princ)
);KCGetZumenInfo

;<HOM>*************************************************************************
; <関数名>    : KCEraseInsert
; <処理概要>  : GSM上のINSERT図形を全て削除する
; <戻り値>    : なし
; <作成>      : 02/04/22 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KCexplode(
  /
  #KOSU #SS
  )
  ; 図形存在状況を確認
  (KCGetZumenInfo)
;-----------------------------------------------------------------------------------------------------
  (command "_layer" "U" "ASHADE" "") ; ロック解除

  (setq #ss (ssget "X" (list (cons 0 "INSERT"))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #kosu (sslength #ss))
      (princ "\n")
      (princ "\nINSERT の個数= ")(princ #kosu)
      (command "_erase" #ss "")
    )
  );_if

  (setq #ss (ssget "X" (list (cons 0 "INSERT"))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (princ "\n★INSERT の残り= ")
      (princ (sslength #ss))
    )
    (princ "\n☆NSERT なし☆")
  );_if
  (princ)
);KCexplode

;;;<HOM>*************************************************************************
;;; <関数名>    : DELPMEN
;;; <処理概要>  : 図面上でｼﾝﾎﾞﾙにひもついていないPMEN2を全て削除
;;;               削除したPMEN個数とLSYM個数を表示する
;;; <戻り値>    : なし
;;; <作成>      : 02/05/22 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun DELPMEN (
  /
  #ELM #ENSS$ #I #SYM #KOSU #LSYM$ #HINBAN
  )
  (setq #enSS$ (ssget "X" '((-3 ("G_PMEN"))))) ; 図面上PMEN
  (setq #LSYM$ (ssget "X" '((-3 ("G_LSYM"))))) ; 図面上LSYM

  (if (and #enSS$ (< 0 (sslength #enSS$)))
    (progn
      (setq #i 0 #kosu 0)
      (repeat (sslength #enSS$)
        (setq #elm (ssname #enSS$ #i))             ; PMEN図形
        (setq #sym (CFSearchGroupSym #elm))        ; 親ｼﾝﾎﾞﾙ図形
        (if (= #sym nil)
          (if (entget #elm)
            (progn
              (entdel #elm)
              (setq #kosu (1+ #kosu))
            )
          );_if
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if

  (if (and #LSYM$ (< 0 (sslength #LSYM$)))
    (progn
      (CFAlertMsg (strcat (itoa (sslength #LSYM$)) "個のLSYMが存在します"))
      (setq #i 0)
      (repeat (sslength #LSYM$)
        (setq #elm (ssname #LSYM$ #i))             ; PMEN図形
        (setq #hinban (nth 5 (CFGetXData #elm "G_LSYM")))
        (princ (strcat "\n" #hinban))
        (setq #i (1+ #i))
      )
    )
  );_if
  (CFAlertMsg (strcat (itoa #kosu) "個のPMENを削除しました\n(図面上のLSYMをﾘｽﾄｱｯﾌﾟ)"))
  (princ)
);DELPMEN

;;;<HOM>*************************************************************************
;;; <関数名>    : C:COMM01
;;; <処理概要>  : WT左上点を図示する
;;; <戻り値>    : なし
;;; <作成>      : 02/06/04 YM
;;; <備考>      : 開発者用
;;;*************************************************************************>MOH<
(defun C:COMM01 (
  /
  #I #WT #WTPT #WTSS$ #WTXD$ #LAST
  )
  ;// コマンドの初期化
  (StartUndoErr)
  (setvar "pickfirst" 1)

  (setq #wtSS$ (ssget "X" '((-3 ("G_WRKT"))))) ; 図面上WT
  (if (and #wtSS$ (< 0 (sslength #wtSS$)))
    (progn
      (setq #i 0)
      (repeat (sslength #wtSS$)
        (setq #WT (ssname #wtSS$ #i))          ; WT図形
        (setq #wtxd$ (CFGetXData #WT "G_WRKT"))
        ; ｶｯﾄ相手左
        (setq #WTpt (nth 32 #wtxd$))           ; WT左点
        (command "._circle" #WTpt "50")        ; 円を引く
        (setq #last (entlast))
        (command "chprop" #last "" "C" "1" "") ; 赤

        (command "._line" #WTpt "@100,100" "") ; 線を引く
        (setq #last (entlast))
        (command "chprop" #last "" "C" "1" "") ; 赤
        (setq #i (1+ #i))
      )
    )
  );_if
  (princ)
);C:COMM01

;;;<HOM>************************************************************************
;;; <関数名>  : C:COMM02
;;; <処理概要>: PDF出力する
;;; <戻り値>  : なし
;;; <作成>    : 02/08/07 YM
;;; <備考>    : 隠しｺﾏﾝﾄﾞ Acrobat5.0Installが前提
;;;************************************************************************>MOH<
(defun C:COMM02  (
  /
  #limmin
  #limmax
  #AREA #CTB #DEVICE #EDIT #ELAYER #ELAYER$ #ILAYER #INI$$ #LAY #OFFX #OFFY #PAPER #RET$ #SCALE #YESNO
  )
  ; 119 01/04/08 HN S-ADD 画層"0_HIDE"の非表示処理を追加
  (setq #eLayer (tblobjname "LAYER" "O_HIDE"))
  (if #eLayer
    (progn
      (setq #eLayer$ (entget #eLayer))
      (setq #iLayer (cdr (assoc 62 #eLayer$)))
      (if (< 0 #iLayer)
        (progn
          (setq #iLayer (* -1 #iLayer))
          (entmod (subst (cons 62 #iLayer) (assoc 62 #eLayer$) #eLayer$))
          (command ".REGEN")
        )
      )
    )
  )
  ; 119 01/04/08 HN E-ADD 画層"0_HIDE"の非表示処理を追加

  (if (= nil (findfile (strcat CG_SYSPATH "SCPLOT.CFG")))
    (CFAlertErr "印刷設定ファイル <SCPLOT.CFG> がありません")
  )
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device "Acrobat Distiller") ;出力デバイス名(PDF)

  (setq #edit     (cadr (assoc "EDIT"  #ini$$)))    ;エディタ名

  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;水平オフセット
  (if (= nil #offx)(setq #offx "0.0"))

  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;垂直オフセット
  (if (= nil #offy)(setq #offy "0.0"))

  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;印刷スタイルファイル名

  ;// 簡易印刷ダイアログ
  (setq #ret$ (SCPlainPlotDlg #device))

  (if (/= #ret$ nil)
    (progn
      (setq #paper (car #ret$))
      (setq #scale (cadr #ret$))
      (cond
        ((= #paper "paperA2")
          (setq #paper (cadr (assoc "PAPERA2" #ini$$)))
        )
        ((= #paper "paperA3")
          (setq #paper (cadr (assoc "PAPERA3" #ini$$)))
        )
        ((= #paper "paperA4")
         (setq #paper (cadr (assoc "PAPERA4" #ini$$)))
        )
        ((= #paper "paperB4")
         (setq #paper (cadr (assoc "PAPERB4" #ini$$)))
        )
      );_cond

      (cond
        ((= #scale "scale20")(setq #scale "1:20"))
        ((= #scale "scale30")(setq #scale "1:30"))
        ((= #scale "scale40")(setq #scale "1:40"))
        ((= #scale "scale1")(setq #scale "1:1"))
        (T (setq #scale "F"))
      );_cond

      (if (= 0 (getvar "TILEMODE"))
        (progn
          (setq #area "E")
          (setq #lay  "ﾚｲｱｳﾄ1")
        )
        (progn
          (if (= #scale "F")
            (progn
              (setq #area "E")
              (setq #offx "0.0")
              (setq #offy "0.0")
            )
            (setq #area "E")
          );_if
          (setq #lay  "Model")
        )
      );_if

      (setq #YesNo
        (CFYesNoDialog
          (strcat
            "出力デバイス名: [" #device "]\n"
            "用紙サイズ　　　: [" #paper  "]\n"
            "縮尺　　　　　　　: [" #scale  "]\n\n"
            "これで印刷してもよろしいですか？"
          )
        )
      )

      (if #YesNo ; 01/09/07 YM MOD
        (progn
          ; PLOTｺﾏﾝﾄﾞ実行(PDF出力用)
          (if (= (getvar "TILEMODE") 0)
            (progn ; ﾍﾟｰﾊﾟｰ空間 PDFをﾃﾞｽｸﾄｯﾌﾟに出力
              ;;; S-ADD K.S Omajinai 2002/08/05
              (setq #limmin (getvar "LIMMIN"))
              (setq #limmax (getvar "LIMMAX"))
              (setvar "CLAYER" "0_WAKU")
              (if (= nil (member "rectang.arx" (arx)))
                (arxload "rectang.arx")
              )
              (command "_.RECTANGLE" #limmin #limmax)
              (setvar "CLAYER" "0")
              ;;; E-ADD by K.S Omajinai 2002/08/05
              (command "_.-PLOT"
                 "Y"           ;詳細な印刷環境設定
                 #lay
                 #device       ;印刷デバイス名
                 #paper        ;用紙サイズ(テンプレート)
                 "M"           ;用紙単位
                 "L"           ;図面の方向
                 "N"           ;上下逆印刷
                 #area         ;印刷領域 図面範囲
                 #scale        ;縮尺
                 (strcat #offx "," #offy)   ;印刷オフセット
                 "Y"           ;印刷スタイル利用？
                 #ctb          ;印刷スタイル名
                 "Y"           ;線の太さを使用？
                 "N"           ;印刷尺度を使用して線の太さを尺度変更?
                 "N"           ;ﾍﾟｰﾊﾟｰ空間を最後に印刷?
                 "Y"           ;隠線処理
                 "N"           ;ファイル書き出し
                 "N"           ;変更を保存
                 "Y"           ;印刷を続ける？
              );_command "_.-PLOT"
            ) ; ﾍﾟｰﾊﾟｰ空間
        ; else
            (progn ; ﾓﾃﾞﾙ空間 PDFをﾃﾞｽｸﾄｯﾌﾟに出力
              (command "_.-PLOT"
                 "Y"           ;詳細な印刷環境設定
                 #lay
                 #device       ;印刷デバイス名
                 #paper        ;用紙サイズ(テンプレート)
                 "M"           ;用紙単位
                 "L"           ;図面の方向
                 "N"           ;上下逆印刷
                 #area         ;印刷領域 図面範囲
                 #scale        ;縮尺
                 (strcat #offx "," #offy)   ;印刷オフセット
                 "Y"           ;印刷スタイル利用？
                 #ctb          ;印刷スタイル名
                 "Y"           ;線の太さを使用？
                 "Y"           ;隠線処理
                 "N"           ;ファイル書き出し
                 "N"           ;変更を保存
                 "Y"           ;印刷を続ける？
              );_command "_.-PLOT"

            ) ; ﾓﾃﾞﾙ空間
          );_if
        )
      );_if
    )
  );_if
  (princ)
);C:COMM02

;;;<HOM>************************************************************************
;;; <関数名>  : C:COMM03
;;; <処理概要>: プレゼン用にパースをJPEGに出力する
;;; <戻り値>  : なし
;;; <作成>    : 03/01/28 YM
;;; <備考>    :
;;;************************************************************************>MOH<
(defun C:COMM03  (
  /
  #SFNAME
  )

  ;// コマンドの初期化
  (StartUndoReOpenModelErr) ;06/07/24 T.Ari MOD パースキャンセルエラー対応

  ; 図面参照
  (setq #sFName (strcat CG_KENMEI_PATH "Block\\M_0.dwg"))
  (if (= nil (findfile #sFName))
    (progn
      (CFAlertMsg (strcat "パースがありません\n展開図作成(一括)を行ってください"))
      (quit)
    )
    (progn

      (command ".qsave")
      (command "_.Open"     #sFName)
      (setq CG_OpenMode 9)
      (S::STARTUP)

    )
  );_if

  (setq *error* nil)
  (princ)
);C:COMM03

;;;<HOM>************************************************************************
;;; <関数名>  : COMM03sub
;;; <処理概要>: プレゼン用にパースをJPEGに出力する
;;; <戻り値>  : なし
;;; <作成>    : 03/01/28 YM
;;; <備考>    :
;;;************************************************************************>MOH<
(defun COMM03sub  (
  /
  #AREA #CTB #DEVICE #INI$$ #LAY #OFFX #OFFY #OUTPUT #PAPER #SCALE #SFNAME
  )
;;;WebTIFF_OUTPUT
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE2"  #ini$$))) ;出力デバイス名
  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;水平オフセット
  (if (= nil #offx)(setq #offx "0.0"))
  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;垂直オフセット
  (if (= nil #offy)(setq #offy "0.0"))
  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;印刷スタイルファイル名
  (setq #paper    (cadr (assoc "SIZE"    #ini$$)))  ;ピクセル
  (setq #scale "F")
  (setq #area  "D") ; 図面範囲
  (setq #lay  "Model")

  (setvar "DISPSILH" 1)                     ;シルエットON
  (command "_.ZOOM" "E")

  (princ "\n向きの調整を行って下さい。")
  (princ "\n")
  (SKChgView "2,-2,1")  ; 右勝手 視点南東
  (command "_3DORBIT")

;;;  (command "_.VPOINT" "R" "" 8)
;;; (command "_.DVIEW" "ALL" "" "D" 7500 "X") ;パース図に切り替え

  ; 3Dorbit

  ; 出力ﾌｧｲﾙ名 固定
  (if (= CG_AUTOMODE 1);(ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ実行時 04/09/13 YM MOD)
    (progn
      (setq #output (strcat CG_KENMEI_PATH "BLOCK" "\\PERS.jpg"))
      (if (findfile #output)(vl-file-delete #output))
    )
    (progn
      (setq #output (getfiled "名前を付けて保存" (strcat CG_KENMEI_PATH "BLOCK\\") "jpg" 1))
      ;04/08/26 YM ADD 初期ﾌｫﾙﾀﾞ\block から変更があればﾕｰｻﾞｰに確認する
      (setq #flg nil) ; 初期ﾌｫﾙﾀﾞ\blockのとき'T
      (if (wcmatch (strcase #output) (strcase (strcat CG_KENMEI_PATH "BLOCK\\*")) )
        (progn ; 初期パスを含んでいる
          ;初期ﾊﾟｽ部分を削除
          (setq #dum_path (vl-string-subst "" (strcase (strcat CG_KENMEI_PATH "BLOCK\\")) (strcase #output) ))
          (if (vl-string-search "\\" #dum_path)
            (setq #flg T) ;下に階層を含んでいる
            ;else
            (setq #flg nil) ;下に階層を含んでいない
          );_if
        )
        ;else
        (setq #flg T)
      );_if

      (if #flg
        (progn ;初期ﾌｫﾙﾀﾞと違う場合は警告を表示する
          (CFAlertMsg "プレゼンボード作成機能を使用する場合は保存場所(\block)を変更しないでください")
        )
      );_if
    )
  );_if

  (if #output
    (progn
      ; PLOTｺﾏﾝﾄﾞ実行(TIFF,JPEG出力用)
      (command "_.-PLOT"
         "Y"           ;詳細な印刷環境設定
         #lay
         #device       ;印刷デバイス名
         #paper        ;用紙サイズ(テンプレート)
         "L"           ;図面の方向
         "N"           ;上下逆印刷
         #area         ;印刷領域 図面範囲
         #scale        ;縮尺
         (strcat #offx "," #offy)   ;印刷オフセット
         "Y"           ;印刷スタイル利用？
         #ctb          ;印刷スタイル名
         "Y"           ;線の太さを使用？
         "Y"           ;隠線処理
    ;;;   (strcat CG_PDFOUTPUTPATH CG_BukkenNo "_DRW1.Tif")
        #output
         "N"           ;変更を保存
         "Y"           ;印刷を続ける？
      );_command "_.-PLOT"
    )
  );_if
  ; 印刷が終わりもとの図面に戻る
  (setq CG_OpenMode 0)
  (setq #sFname (strcat CG_KENMEI_PATH "MODEL.dwg"))
  (SCFCmnFileOpen #sFName 1)

  ; 出力先の表示
  (if (= CG_AUTOMODE 1);(ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ実行時 04/09/13 YM MOD)
    (progn
      (command ".qsave");save
      nil ; 何も表示しない
    )
    (progn
      (CFYesDialog (strcat #output "\nに出力しました"))
    )
  );_if

  (princ)
);COMM03sub



;;;<HOM>************************************************************************
;;; <関数名>  : JPG-OUTPUT
;;; <処理概要>: ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ時にﾊﾟｰｽをJPEGに出力する
;;; <戻り値>  : なし
;;; <作成>    : 04/09/13 YM
;;; <備考>    :
;;;************************************************************************>MOH<
(defun JPG-OUTPUT  (
  /
  #SFNAME
  )
  ; 図面参照
  (setq #sFName (strcat CG_KENMEI_PATH "Block\\M_0.dwg"))
  (if (= nil (findfile #sFName))
    (progn
      (CFAlertMsg (strcat "パースがありません\n展開図作成(一括)を行ってください"))
      (quit)
    )
    (progn
      (command ".qsave")
      (command "_.Open"     #sFName)
      (setq CG_OpenMode 99)
      (S::STARTUP)
    )
  );_if
  (princ)
);JPG-OUTPUT

;;;<HOM>************************************************************************
;;; <関数名>  : JPG-OUTPUT_sub
;;; <処理概要>: ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ時にﾊﾟｰｽをJPEGに出力する
;;; <戻り値>  : なし
;;; <作成>    : 04/09/13 YM
;;; <備考>    :
;;;************************************************************************>MOH<
(defun JPG-OUTPUT_sub  (
  /
  #SFNAME #AREA #CTB #DEVICE #INI$$ #LAY #OFFX #OFFY #OUTPUT #PAPER #SCALE
  )

;;;WebTIFF_OUTPUT
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE2"  #ini$$))) ;出力デバイス名
  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;水平オフセット
  (if (= nil #offx)(setq #offx "0.0"))
  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;垂直オフセット
  (if (= nil #offy)(setq #offy "0.0"))
  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;印刷スタイルファイル名
  (setq #paper    (cadr (assoc "SIZE"    #ini$$)))  ;ピクセル
  (setq #scale "F")
  (setq #area  "D") ; 図面範囲
  (setq #lay  "Model")

  (setvar "DISPSILH" 1)                     ;シルエットON
  (command "_.ZOOM" "E")

  (princ "\n向きの調整を行って下さい。")
  (princ "\n")
  (SKChgView "2,-2,1")  ; 右勝手 視点南東
  (command "_3DORBIT")

;;;  (command "_.VPOINT" "R" "" 8)
;;; (command "_.DVIEW" "ALL" "" "D" 7500 "X") ;パース図に切り替え

  ; 3Dorbit
  (setq #output (strcat CG_KENMEI_PATH "BLOCK" "\\PERS.jpg"))
  (if (findfile #output)(vl-file-delete #output))
  (if #output
    (progn
      ; PLOTｺﾏﾝﾄﾞ実行(TIFF,JPEG出力用)
      (command "_.-PLOT"
         "Y"           ;詳細な印刷環境設定
         #lay
         #device       ;印刷デバイス名
         #paper        ;用紙サイズ(テンプレート)
         "L"           ;図面の方向
         "N"           ;上下逆印刷
         #area         ;印刷領域 図面範囲
         #scale        ;縮尺
         (strcat #offx "," #offy)   ;印刷オフセット
         "Y"           ;印刷スタイル利用？
         #ctb          ;印刷スタイル名
         "Y"           ;線の太さを使用？
         "Y"           ;隠線処理
    ;;;   (strcat CG_PDFOUTPUTPATH CG_BukkenNo "_DRW1.Tif")
        #output
         "N"           ;変更を保存
         "Y"           ;印刷を続ける？
      );_command "_.-PLOT"
    )
  );_if

  ; 印刷が終わりもとの図面に戻る
  (setq CG_OpenMode 0)
  (setq #sFname (strcat CG_KENMEI_PATH "MODEL.dwg"))
  (SCFCmnFileOpen #sFName 1)

  (command ".qsave")
  (princ)
);JPG-OUTPUT_sub



;;;<HOM>*************************************************************************
;;; <関数名>    : C:mktpt
;;; <処理概要>  : ﾃﾝﾌﾟﾚｰﾄにPOINT作図する
;;; <戻り値>    : なし
;;; <作成>      : 02/06/04 YM
;;; <備考>      : 開発者用 ｵﾌﾞｼﾞｪｸﾄ範囲で簡易印刷すると全体が左下に寄るため
;;;               '(0 0)にPOINTを作図して全体的に中心に寄らす(A3)
;;;               ただしA4の場合(200 140)に作図しないと用紙からはみ出る
;;;               ﾊﾟｰｽA4のときは(200/30 140/30)=(6.7 4.7)の位置に作図する
;;;*************************************************************************>MOH<
(defun C:mktpt (
  /

  )
;;; (setq #limmax (getvar "LIMMAX"))
  (setvar "PDMODE" 34)
  (setvar "CLAYER" "0_waku")
  ; 作図
;;; (command "._POINT" '(200 140)) ; A4 Template用(立体以外)
;;; (command "._POINT" '(0 0)) ; A3 Template用(立体以外)
;;; (command "._POINT" #limmax)
;;; (command "._POINT" '(12300 8610)) ; A3 Template用(立体以外)
  (command "._POINT" '(6.7 4.7)) ; A4 Template用(立体)

  (setvar "PDMODE" 0)

  ; "0_waku"非表示
  (command "_-layer" "of" "0_waku" "")
  ; 現在画層"0"
  (setvar "CLAYER" "0")
  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : KP_DelHinbanKakko
; <処理概要>  : 文字列=品番(*)のうち(*)部分を除去したものを返す
; <戻り値>    : 文字列
; <作成>      : 01/12/03 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KP_DelHinbanKakko (
  &str ; 文字列
  /
  #I #LOOP #NO_E #NO_S #RET #RET1 #RET2
  )
  (setq #i 1 #loop T)
  (setq #no_S nil #no_E nil)
  (while (< #i (1+ (strlen &str)))
    (if (= (substr &str #i 1) "(")(setq #no_S #i)) ; ( の位置
    (if (= (substr &str #i 1) ")")(setq #no_E #i)) ; ) の位置
    (setq #i (1+ #i))
  )
  (if (and #no_S #no_E)
    (progn
      (setq #ret1 (substr &str 1 (1- #no_S))) ; ( の直前まで
      (setq #ret2 (substr &str (1+ #no_E) (strlen &str))) ; ) の直後～最後まで
      (setq #ret (strcat #ret1 #ret2))
    )
    (setq #ret &str) ; ()がない場合
  );_if
  #ret
);KP_DelHinbanKakko

;<HOM>*************************************************************************
; <関数名>    : KP_DelDrSeriStr
; <処理概要>  : 文字列=品番[S:AA]のうち[*]部分を除去したものを返す
; <戻り値>    : 文字列
; <作成>      : 01/10/10 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KP_DelDrSeriStr (
  &str ; 文字列
  /
  #I #LOOP #NO #RET #F1 #F2 #F3 #FLG
  )
  ;文字列判定 03/08/22 YM ADD-S
  (setq #f1 (vl-string-search "[" &str))
  (setq #f2 (vl-string-search ":" &str))
  (setq #f3 (vl-string-search "]" &str))
  (if (and #f1 #f2 #f3)
    (setq #flg   T)
    (setq #flg nil)
  );_if
  ;文字列判定 03/08/22 YM ADD-E

  (if #flg ;文字列判定 03/08/22 YM ADD
    (progn
      (setq #i 1 #loop T)
      (setq #no nil)
      (while (and #loop (< #i (1+ (strlen &str))))
        (if (= (substr &str #i 1) "[")
          (progn
            (setq #no #i)
            (setq #loop nil)
          )
        );_if
        (setq #i (1+ #i))
      )
      (if #no
        (setq #ret (substr &str 1 (1- #no)))
        (setq #ret &str)
      );_if
    )
    (progn
      (setq #ret &str)
    )
  );_if

  #ret
);KP_DelDrSeriStr


;<HOM>*************************************************************************
; <関数名>    : KP_GetSeriStr
; <処理概要>  : 文字列=品番[SS:AA:BB]に対して(list SS AA BB)を返す
; <戻り値>    : (list SS AA BB) or nil([]がないとき)
; <作成>      : 11/04/23 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KP_GetSeriStr (
  &str ; 文字列
  /
  #F1 #F2 #F3 #FLG #STR #STR$
  )
  ;文字列判定
  (setq #f1 (vl-string-search "[" &str))
  (setq #f2 (vl-string-search ":" &str))
  (setq #f3 (vl-string-search "]" &str))
  (if (and #f1 #f2 #f3)
    (setq #flg   T)
    (setq #flg nil)
  );_if

  (if #flg
    (progn
      ;[=14 ]=21
      (setq #str (substr &str (+ #f1 2) (- #f3 #f1 1)))
      (setq #str$ (strparse #str ":"))
    )
    (progn
      (setq #str$ nil);nilを返す
    )
  );_if

  #str$
);KP_GetSeriStr


;<HOM>*************************************************************************
; <関数名>    : KP_DelDrSeri
; <処理概要>  : 品番文字列[S:AG]の部分を"扉ｶﾗｰ"とする(KPCAD,NSCAD仕様)
; <戻り値>    : 上記変更済みﾘｽﾄ
; <作成>      : 01/10/30 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KP_DelDrSeri (
  &lis$ ; LIST
  &flg ; 1:[]部分→""(なし) , 2:品番+" "+扉ｶﾗｰ  引数追加 01/10/31 YM ADD
  /
  #HIN #NO1 #NO2 #NO3 #RET #RET$ #STR
  )

  (setq #ret$ nil)
  (foreach #lis &lis$
    (setq #str (nth 1 #lis)) ; 品番名称
    (setq #hin (KP_DelDrSeri_sub #str &flg))
    (setq #ret
      (CFModList #lis
        (list
          (list 1 #hin) ; nth 1 部分を #hin に変更
        )
      )
    )
    (setq #ret$ (append #ret$ (list #ret)))
  );foreach

  #ret$
);KP_DelDrSeri

;<HOM>*************************************************************************
; <関数名>    : KP_DelDrSeri_sub
; <処理概要>  : 品番文字列[S:AG]の部分を"扉ｶﾗｰ"とする(KPCAD,NSCAD仕様)
; <戻り値>    : 上記変更済み文字列
; <作成>      : 02/11/30 YM 改
; <備考>      :  SX対応 [P_:XPD:PD2]のﾊﾟﾀｰﾝあり
;*************************************************************************>MOH<
(defun KP_DelDrSeri_sub (
  &str ; 文字列
  &flg ; 1:品番+L/R []部分削除 , 2:品番+" "+扉ｶﾗｰ  引数追加 01/10/31 YM ADD
  /
  #HIN #NO1 #NO2 #NO3 #STR
#DOORKIGO #DRCOL #DRHANDLE #DRINFO #DRINFO$ ; 02/12/07 YM ADD
  )
  (setq #no1 (vl-string-search "[" &str)) ; "[" が何番目か or nil 先頭=0
  (setq #no2 (vl-string-search "]" &str)) ; "[" が何番目か or nil 先頭=0

  (if (and #no1 #no2)
    (progn

      (cond
        ((= &flg 1) ; 引数&flg追加 01/10/31 YM ADD
          (setq #hin
            (strcat
              (substr &str 1 #no1) ; 元の品番部分のみ
              (substr &str (+ #no2 2)(- (strlen &str) (+ #no2 1))) ; LR
            )
          )
        )
        ((= &flg 2) ; 引数&flg追加 01/10/31 YM ADD
          ; []部分の中身抜き取り [,]は含まない
          (setq #DrInfo (substr &str (+ #no1 2) (- #no2 #no1 1)))
          ; ":"で分けてﾘｽﾄ化する
          (setq #DrInfo$ (StrtoLisByBrk #DrInfo ":"))
          (setq #DrCol    (cadr  #DrInfo$))
          (setq #DrHandle (caddr #DrInfo$))
          (if (= nil #DrHandle)
            (setq #DoorKIGO #DrCol) ; 扉色
          ; else
            (setq #DoorKIGO #DrHandle) ; 取手
          );_if

          (setq #hin ; 品番+" "+扉ｶﾗｰ
            (strcat
              (substr &str 1 #no1) ; 元の品番部分のみ
              ; 01/10/30 YM 扉ｶﾗｰ追加 KPCAD,NSCAD仕様
              " " ; ｽﾍﾟｰｽ追加
              #DoorKIGO ; 扉ｶﾗｰ or 取手部分
              ; 01/10/29 YM LR不要
;;;01/10/29YM@DEL         (substr &str (1+ #no3)(- (strlen &str) #no3)) ; LR
            )
          )
        )
        (T
          (setq #hin (substr &str 1 (1- #no1))) ; 元の品番部分のみ
        )
      );_cond

    )
    (setq #hin &str) ; そのまま
  );_if

  #hin
);KP_DelDrSeri_sub

;;;02/11/30YM@DEL;<HOM>*************************************************************************
;;;02/11/30YM@DEL; <関数名>    : KP_DelDrSeri_sub
;;;02/11/30YM@DEL; <処理概要>  : 品番文字列[S:AG]の部分を"扉ｶﾗｰ"とする(KPCAD,NSCAD仕様)
;;;02/11/30YM@DEL; <戻り値>    : 上記変更済み文字列
;;;02/11/30YM@DEL; <作成>      : 01/10/31 YM
;;;02/11/30YM@DEL; <備考>      :
;;;02/11/30YM@DEL;*************************************************************************>MOH<
;;;02/11/30YM@DEL(defun KP_DelDrSeri_sub (
;;;02/11/30YM@DEL  &str ; 文字列
;;;02/11/30YM@DEL &flg ; 1:品番+L/R , 2:品番+" "+扉ｶﾗｰ  引数追加 01/10/31 YM ADD
;;;02/11/30YM@DEL  /
;;;02/11/30YM@DEL #HIN #NO1 #NO2 #NO3 #STR
;;;02/11/30YM@DEL  )
;;;02/11/30YM@DEL
;;;02/11/30YM@DEL   ;/////////////////////////////////////////////////////////////////////////
;;;02/11/30YM@DEL   ; &obj が &str の何番めか.なければnilを返す
;;;02/11/30YM@DEL   (defun ##GetIndex (
;;;02/11/30YM@DEL     &str ; STR
;;;02/11/30YM@DEL     &obj ; 対象文字
;;;02/11/30YM@DEL     /
;;;02/11/30YM@DEL     #I #LOOP #NO #STR
;;;02/11/30YM@DEL     )
;;;02/11/30YM@DEL     (setq #no nil) ; "[" が何番目か
;;;02/11/30YM@DEL     (setq #i 1 #loop T)
;;;02/11/30YM@DEL     (while (and #loop (< #i (1+ (strlen &str))))
;;;02/11/30YM@DEL       (if (= (substr &str #i 1) &obj)
;;;02/11/30YM@DEL         (progn
;;;02/11/30YM@DEL           (setq #no #i)
;;;02/11/30YM@DEL           (setq #loop nil)
;;;02/11/30YM@DEL         )
;;;02/11/30YM@DEL       );_if
;;;02/11/30YM@DEL       (setq #i (1+ #i))
;;;02/11/30YM@DEL     )
;;;02/11/30YM@DEL     #no
;;;02/11/30YM@DEL   );##GetIndex
;;;02/11/30YM@DEL   ;/////////////////////////////////////////////////////////////////////////
;;;02/11/30YM@DEL
;;;02/11/30YM@DEL (setq #no1 (##GetIndex &str "[")) ; "[" が何番目か
;;;02/11/30YM@DEL (setq #no2 (##GetIndex &str ":")) ; ":" が何番目か
;;;02/11/30YM@DEL (setq #no3 (##GetIndex &str "]")) ; "]" が何番目か
;;;02/11/30YM@DEL (if (and #no1 #no2 #no3)
;;;02/11/30YM@DEL   (progn
;;;02/11/30YM@DEL
;;;02/11/30YM@DEL     (cond
;;;02/11/30YM@DEL       ((= &flg 1) ; 引数&flg追加 01/10/31 YM ADD
;;;02/11/30YM@DEL         (setq #hin
;;;02/11/30YM@DEL           (strcat
;;;02/11/30YM@DEL             (substr &str 1 (1- #no1)) ; 元の品番部分のみ
;;;02/11/30YM@DEL             (substr &str (1+ #no3)(- (strlen &str) #no3)) ; LR
;;;02/11/30YM@DEL           )
;;;02/11/30YM@DEL         )
;;;02/11/30YM@DEL       )
;;;02/11/30YM@DEL       ((= &flg 2) ; 引数&flg追加 01/10/31 YM ADD
;;;02/11/30YM@DEL         (setq #hin ; 品番+" "+扉ｶﾗｰ
;;;02/11/30YM@DEL           (strcat
;;;02/11/30YM@DEL             (substr &str 1 (1- #no1)) ; 元の品番部分
;;;02/11/30YM@DEL             ; 01/10/30 YM 扉ｶﾗｰ追加 KPCAD,NSCAD仕様
;;;02/11/30YM@DEL             " " ; ｽﾍﾟｰｽ追加???
;;;02/11/30YM@DEL             (substr &str (1+ #no2)(- #no3 #no2 1)) ; 扉ｶﾗｰ部分 @@@
;;;02/11/30YM@DEL             ; 01/10/29 YM LR不要
;;;02/11/30YM@DEL;;;01/10/29YM@DEL          (substr &str (1+ #no3)(- (strlen &str) #no3)) ; LR
;;;02/11/30YM@DEL           )
;;;02/11/30YM@DEL         )
;;;02/11/30YM@DEL       )
;;;02/11/30YM@DEL       (T
;;;02/11/30YM@DEL         (setq #hin (substr &str 1 (1- #no1))) ; 元の品番部分のみ
;;;02/11/30YM@DEL       )
;;;02/11/30YM@DEL     );_cond
;;;02/11/30YM@DEL
;;;02/11/30YM@DEL   )
;;;02/11/30YM@DEL   (setq #hin &str) ; そのまま
;;;02/11/30YM@DEL );_if
;;;02/11/30YM@DEL
;;;02/11/30YM@DEL #hin
;;;02/11/30YM@DEL);KP_DelDrSeri_sub

;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_DELSTR
;;; <処理概要>  : 品番文字列から引数の文字を削除する
;;; <戻り値>    :
;;; <作成>      : 02/08/24 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun CMN_DELSTR (
  &string ; 文字列
  &str    ; 削除文字(1文字)
  /
  #I #RET #S
  )
  (setq #ret "") ; 戻り値
  (if &string
    (progn
      (setq #i 1)
      (repeat (strlen &string)
        (setq #s (substr &string #i 1))
        (if (= #s &str)
          nil
        ;else
          (setq #ret (strcat #ret #s))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CMN_DELSTR

;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_GetNumStr
;;; <処理概要>  : 文字列の数字部分のみをかえす
;;;               (例) "XM*IBPD-255TR"--->"255"
;;; <戻り値>    : 文字列 or ""
;;; <作成>      : 02/11/27 YM
;;; <備考>      : 数字部分が複数箇所あることを想定していない
;;;               (例)のように一箇所に連続していることを想定
;;;*************************************************************************>MOH<
(defun CMN_GetNumStr (
  &str ; 文字列
  /
  #DUM #I #RET #STR
  )
  (setq #ret "")
  (if (= 'STR (type &str))
    (progn
      (setq #i 1)
      (repeat (strlen &str)
        (setq #str (substr &str #i 1))
        (if (= 'INT (type (read #str)))
          (setq #ret (strcat #ret #str))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CMN_GetNumStr

;;;<HOM>*************************************************************************
;;; <関数名>    : CMN_string-subst
;;; <処理概要>  : 文字列(&string)の文字(&str_old)を文字(&str_new)に変更する
;;; <戻り値>    :
;;; <作成>      : 02/11/30 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun CMN_string-subst (
  &str_old ; 文字(1文字)
  &str_new ; 文字(1文字)
  &string  ; 文字列
  /
  #I #RET #S
  )
  (setq #ret "") ; 戻り値
  (if (= 'STR (type &string))
    (progn
      (setq #i 1)
      (repeat (strlen &string)
        (setq #s (substr &string #i 1))
        (if (= #s &str_old)
          (setq #ret (strcat #ret &str_new))
        ;else
          (setq #ret (strcat #ret #s))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CMN_string-subst

;;;<HOM>*************************************************************************
;;; <関数名>    : CheckCFG
;;; <処理概要>  : 文字列(&string)の文字(&str_old)を文字(&str_new)に変更する
;;; <戻り値>    :
;;; <作成>      : 02/11/30 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun CheckCFG (
  /
  #5 #CFG$ #CFG_DWG-HIN #CFG_DWG-HIN$ #DWG$ #DWG-HIN #ERR$ #HINBAN #I #ID #IFILE #LIST$$ #OK$$
  #DATE_TIME #FIL #NIL$ #CSV$$ #DUM$ #DUM$$ #ERR$$ #KFILE #NIL$$
  )

  (setq #fil (open (strcat CG_SYSPATH "結果.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n" #fil)

  ; 共通価格.xls
  (setq #kfile (strcat CG_SKDATAPATH "CFG-ch\\共通.csv"))
  (setq #CSV$$ (ReadCSVFile #kfile))
  ; 連想ﾘｽﾄにする
  (setq #dum$$ nil)
  (foreach #CSV$ #CSV$$
    (setq #dum$ (cons (nth 0 #CSV$)(nth 1 #CSV$)))
    (setq #dum$$ (append #dum$$ (list #dum$)))
  )
  (setq #CSV$$ #dum$$)
  (princ "\nM_共価格.xls 登録個数= " #fil)(princ (length #CSV$$) #fil)

  ; CFG以下のﾌｧｲﾙ
  (setq #CFG$ (vl-directory-files (strcat CG_SKDATAPATH "CFG\\") "*.cfg"))

  ; CFGの図形IDと品番の一覧
  (setq #CFG_dwg-hin$ nil)
  (foreach CFG #CFG$
    (if (= (strlen CFG) 9)
      (progn
        (setq #5 (substr CFG 1 5))
        (setq #ifile (strcat CG_SKDATAPATH "CFG-ch\\" CFG))
        (setq #List$$ (ReadCSVFile #ifile)) ; CFGの中身
        (foreach #List$ #List$$
          (setq #CFG_dwg-hin (cons (strcat #5 (car #List$)) (cadr #List$)))
          (setq #CFG_dwg-hin$ (append #CFG_dwg-hin$ (list #CFG_dwg-hin)))
        )
      )
    );_if
  )

  ; MASTER以下のﾌｧｲﾙ
  (setq #dwg$ (vl-directory-files CG_MSTDWGPATH "*.dwg"))
  (princ "\nMASTER DWG 個数= " #fil)(princ (length #dwg$) #fil)

  (setq #i 1)
  (setq #err$$ nil)   ; DWGはあるのにCFGが空白
  (setq #nil$$ nil)   ; DWGはあるのにCFGが空白
  (setq #OK$$ nil)    ; 正常
  (foreach dwg #dwg$  ; 各DWGに対してCFGの品番を検索する
    (setq #ID (substr dwg 1 7))
    (setq #hinban (cdr (assoc #ID #CFG_dwg-hin$)))
    (cond
      ((= #hinban nil) ; DWGはあるのにCFGがLevel1で空白
        ; M_共価格.xls から品番を取得
        (setq #hinban (cdr (assoc #ID #CSV$$)))
        (if (= nil #hinban)(setq #hinban "★？"))
        (setq #nil$$ (append #nil$$ (list (list dwg #hinban))))
      )
      ((= #hinban "") ; DWGはあるのにCFGがLevel2で空白
        ; M_共価格.xls から品番を取得
        (setq #hinban (cdr (assoc #ID #CSV$$)))
        (if (= nil #hinban)(setq #hinban "☆？"))
        (setq #err$$ (append #err$$ (list (list dwg #hinban))))
      )
      (progn ; 正常
        (setq #OK$$ (append #OK$$ (list (list dwg #hinban))))
      )
    );_if
    (if (= (rem #i 10) 0)
      (princ (strcat "\n" (itoa #i)))
    );_if
    (setq #i (1+ #i))
  )

  (princ "\n----------------------------------" #fil)
  (princ "\n図形ID一覧" #fil)
  (princ "\n★DWGはあるのにCFGがLevel1で空白★" #fil)
  (princ "\n----------------------------------" #fil)

  (foreach #nil$ #nil$$
    (if (= nil (cadr #nil$))
      (princ)
    )
    (princ (strcat "\n" (car #nil$) "," (cadr #nil$)) #fil)
  )

  (princ "\n----------------------------------" #fil)
  (princ "\n図形ID一覧" #fil)
  (princ "\n★DWGはあるのにCFGがLevel2で空白★" #fil)
  (princ "\n----------------------------------" #fil)

  (foreach #err$ #err$$
    (if (= nil (cadr #err$))
      (princ)
    )
    (princ (strcat "\n" (car #err$) "," (cadr #err$)) #fil)
  )
  (princ "\n" #fil)

  (princ "\n----------------------------------" #fil)
  (princ "\n図形ID一覧" #fil)
  (princ "\n★正常★" #fil)
  (princ "\n----------------------------------" #fil)

  (foreach #OK$ #OK$$
    (if (= nil (cadr #OK$))
      (princ)
    )
    (princ (strcat "\n" (car #OK$) "," (cadr #OK$)) #fil)
  )

  (startapp "notepad.exe" (strcat CG_SYSPATH "結果.txt"))
  (princ)
);CheckCFG


; ////////// ﾒﾝﾃﾅﾝｽ用ﾂｰﾙ 2003.4.24 YM ADD

;*****************************************************************************:
; 複合管理,複合構成テーブル作成ツール(ｺﾝﾛ選択肢)
; 使用場所: CG_SYSPATH \DATA
; 02/01/21 YM
; ｺﾝﾛ選択肢ﾃｷｽﾄﾌｧｲﾙ,複合管理,複合構成の雛形CSVﾌｧｲﾙ使用
;*****************************************************************************:
(defun C:GAS (
  /
  #DUM$ #FP1 #FP2 #GAS #GAS_NAME #HINBAN #HUKU_ID #ID$ #IFNAME1 #IFNAME2 #IFNAME3
  #J #K #KIGO #KIGO$ #LIST1$$ #LIST2$$ #LIST3$$ #NEWLIST$ #NEWLIST1$$ #NEWLIST2$
  #NEWLIST2$$ #OFNAME1 #OFNAME2 #PTN #RECNO #GAS-LR #LR
  )
  ;// コマンドの初期化
  (StartUndoErr)

    ;/////////////////////////////////////////////////////////////////
    ; 整数を5桁の文字列に変換する 例: 9→"00009",12→"00012"
    (defun ##Int5keta (
      &int ; 整数
      /
      #ret
      )
      (cond
        ((< &int 10   )(setq #ret (strcat "0000" (itoa &int))))
        ((< &int 100  )(setq #ret (strcat "000"  (itoa &int))))
        ((< &int 1000 )(setq #ret (strcat "00"   (itoa &int))))
        ((< &int 10000)(setq #ret (strcat "0"    (itoa &int))))
        (T             (setq #ret (strcat ""     (itoa &int))))
      );_cond
      #ret
    )
    ;/////////////////////////////////////////////////////////////////
    (defun ##OUTPUT (
      &LIS$$ ; 出力ﾘｽﾄ
      &fp    ; ﾌｧｲﾙ識別子
      /
      #I #N
      )
      (setq #n 1)
      (foreach #NewList$ &LIS$$
        (setq #i 1)
        (foreach #NewList #NewList$
          (if (= #i 1)
            (princ #NewList &fp)
            (princ (strcat "," #NewList) &fp)
          );_if
          (setq #i (1+ #i))
        )
        (princ "\n" &fp)
        (setq #n (1+ #n))
      )
      (close &fp)
      (princ)
    )
    ;/////////////////////////////////////////////////////////////////


  ; ｺﾝﾛ記号 全部で36種類まで可能
  (setq #kigo$ (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"
                     "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
                     "U" "V" "W" "X" "Y" "Z" "1" "2" "3" "4"
                     "5" "6" "7" "8" "9" "0"))
  (setq #ifname1 (strcat CG_SYSPATH "DATA\\" CG_SeriesCode "-GAS.txt"))     ; 選択肢ﾌｧｲﾙ(この数分ﾙｰﾌﾟ)
  (setq #ifname2 (strcat CG_SYSPATH "DATA\\" CG_SeriesCode "-複合管理.csv")); 雛形となる複合管理ﾃｰﾌﾞﾙの選択肢"A"のみのﾚｺｰﾄﾞ
  (setq #ifname3 (strcat CG_SYSPATH "DATA\\" CG_SeriesCode "-複合構成.csv")); 雛形となる複合構成ﾃｰﾌﾞﾙの選択肢"A"のみのﾚｺｰﾄﾞ
  (setq #ofname1 (strcat CG_SYSPATH "DATA\\" CG_SeriesCode "-複合管理GAS-OUT.csv")); 出力ﾌｧｲﾙ(複合管理)
  (setq #ofname2 (strcat CG_SYSPATH "DATA\\" CG_SeriesCode "-複合構成GAS-OUT.csv")); 出力ﾌｧｲﾙ(複合構成)

  (if (= nil (findfile #ifname1))
    (progn
      (CFAlertErr (strcat #ifname1 " がありません"))
      (quit)
    )
  );_if
  (if (= nil (findfile #ifname2))
    (progn
      (CFAlertErr (strcat #ifname2 " がありません"))
      (quit)
    )
  );_if
  (if (= nil (findfile #ifname3))
    (progn
      (CFAlertErr (strcat #ifname3 " がありません"))
      (quit)
    )
  );_if

  (setq #List1$$ (ReadCSVFile #ifname1)) ; ｺﾝﾛ選択肢
  (setq #List2$$ (ReadCSVFile #ifname2)) ; 雛形複合管理
  (setq #List3$$ (ReadCSVFile #ifname3)) ; 雛形複合構成

  (setq #id$ (mapcar 'car #List3$$))
  (setq #dum$ nil)
  (foreach #id #id$
    (if (= nil (member #id #dum$))
      (setq #dum$ (append #dum$ (list #id)))
    );_if
  )
  ; 複合構成のﾊﾟﾀｰﾝ数(選択肢"A"のみ)
  (setq #ptn (length #dum$))

  (if (< 36 (length #List1$$))
    (progn
      (CFAlertErr "ｺﾝﾛの選択肢の数が36を越えているため\nｺﾝﾛ記号を2桁にしないといけません")
      (quit)
    )
  );_if

  (setq #NewList1$$ nil) ; 複合管理
  (setq #NewList2$$ nil) ; 複合構成

  (princ "\n")(princ (strcat "ﾃﾞｰﾀ作成中...")) ; ﾁｪｯｸﾗｲﾄ
  (setq #j 0)
  (foreach #List1$ #List1$$                    ; 選択肢分ﾙｰﾌﾟ
    (setq #GAS    (car  #List1$))              ; ｶﾞｽ品番
    (setq #GAS-LR (cadr #List1$))              ; ｶﾞｽLR区分
    (setq #kigo (nth #j #kigo$))
    (setq #k 0)                                ; 通し番号
    (princ "\n")(princ (strcat "ｺﾝﾛ=" #kigo))  ; ﾁｪｯｸﾗｲﾄ
    ; *** 複合管理 ***
    (foreach #List2$ #List2$$                  ; 複合管理 雛形ﾚｺｰﾄﾞ分ﾙｰﾌﾟ
      (setq #huku_ID (atoi (nth 0 #List2$)))   ; 選択肢"A"のID
      (setq #huku_ID (itoa (+ #huku_ID (* #ptn #j))))
      (setq #GAS_NAME #GAS)
      (setq #NewList$
        (CFModList #List2$
          (list
            (list  0 #huku_ID)                 ; 複合ID(重複なし)
            (list  9 #KIGO)                    ; A,B,C,...
            (list 16 #GAS_NAME)                ; 調理器名称
            (list 17 (strcat #KIGO (##Int5keta #k))); 通し番号
          )
        )
      )
      (setq #NewList1$$ (append #NewList1$$ (list #NewList$))) ; 複合管理
      (setq #k (1+ #k))
    );_foreach

    ; *** 複合構成 ***
    (foreach #List3$ #List3$$                  ; 雛形ﾚｺｰﾄﾞ分ﾙｰﾌﾟ(複合構成)
      (setq #huku_ID (atoi (nth 0 #List3$)))   ; 選択肢"A"のID
      (setq #huku_ID (itoa (+ #huku_ID (* #ptn #j))))
      (setq #recNO    (nth 1 #List3$))         ; recNO
      (if (= "1" #recNO)
        (progn
          (setq #hinban (nth 2 #List3$))         ; ｺﾝﾛ下
          (setq #LR     (nth 3 #List3$))         ; ｺﾝﾛ下LR
        )
        (progn
          (setq #hinban #GAS)                  ; ｺﾝﾛ品番を代入
          (setq #LR  #GAS-LR)                  ; ｺﾝﾛLRを代入
        )
      );_if

      (setq #NewList2$
        (CFModList #List3$
          (list
            (list 0 #huku_ID)
            (list 2 #hinban)
            (list 3 #LR)
          )
        )
      )
      (setq #NewList2$$ (append #NewList2$$ (list #NewList2$)))
    );_foreach
    (setq #j (1+ #j))
  );_foreach

  (princ "\n")(princ (strcat "ﾃﾞｰﾀ出力中...")) ; ﾁｪｯｸﾗｲﾄ

  (setq #fp1 (open #ofname1 "w"))
  (setq #fp2 (open #ofname2 "w"))

  (if (or (= nil #fp1)(= nil #fp2))
    (progn
      (CFAlertErr "出力ﾌｧｲﾙが開けません")
      (quit)
    )
  );_if
  ; ﾌｧｲﾙ出力(csv形式)複合管理
  (##OUTPUT #NewList1$$  #fp1)
  ; ﾌｧｲﾙ出力(csv形式)複合構成
  (##OUTPUT #NewList2$$ #fp2)

  (princ "\n*** 出力終了 ***")
  (princ "\n")(princ #ofname1)
  (princ "\n")(princ #ofname2)
  (setq *error* nil)
  (princ)
);C:GAS

;;;<HOM>*************************************************************************
;;; <関数名>    : C:AutoMrr
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いてLR反転後にﾌﾟﾗﾝ保存する
;;;               ﾌｧｲﾙ名は DKSAAP2180L0.dwg → DKSAAP2180R0.dwg となる
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 03/04/28 YM
;;; <備考>      : 03/07/05 YM 新ｾｽﾊﾟ,新CKC用
;;;*************************************************************************>MOH<
(defun C:AutoMrr (
  /
  #DUM$$ #DWG$ #IFNAME1 #PATH
  )
  ;// コマンドの初期化
  (StartUndoErr)

  (setq CG_SAVE-DWG nil)

  ; 対象DWG名のﾘｽﾄを求める(#path に存在する*.DWGの個数)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\")) ; DB名に変更"NK_KSA"
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  ; ﾙｰﾌﾟ処理
  (foreach #DWG #DWG$
    ; 開くﾌｧｲﾙ名
    (setq CG_OPEN-DWG (strcat #path #DWG))
    ;ﾌﾟﾗﾝ挿入
    (sub_KP_InBlock CG_OPEN-DWG)

    ; 保存ﾌｧｲﾙ名  "L"で収納ﾌﾟﾗﾝを作って==>R に変換する
    (setq CG_SAVE-DWG (strcat #path (substr #DWG 1 10) "R" (substr #DWG 12 6)));DIPLOA
;;;   (setq CG_SAVE-DWG (strcat #path (substr #DWG 1 10) "R" (substr #DWG 12 5)));ｾｽﾊﾟ

    ; 03/05/07 YM ADD 不要なｸﾞﾙｰﾌﾟ定義を削除する
    (KP_DelUnusedGroup)
    (command "._zoom" "E")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")
    ;反転する
    (sub_AutoMrr)
    ; ｸﾞﾙｰﾌﾟ分解
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    ; ﾌﾟﾗﾝを保存(copy)する
    (sub_KP_WrBlock); CG_SAVE-DWG を使用する

    (c:clear) ; 図面ｸﾘｱｰ
    ; ｸﾞﾙｰﾌﾟ分解
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")
  )

  (setq *error* nil)

  (princ)
);C:AutoMrr

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_AutoMrr
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いてLR反転後にﾌﾟﾗﾝ保存する
;;;               ﾌｧｲﾙ名はCKTDB180P6RG.DWG → CKTDB180P6LG となる
;;; <引数>      : なし
;;; <戻り値>    : なし
;;; <作成>      : 03/04/28 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun sub_AutoMrr ( / )

  ; 03/05/06 YM ADD-S "R"ﾌﾟﾗﾝを画面ﾌｨｯﾄして保存
  (command "._zoom" "E")
  (command "_zoom" "0.8x") ; 画面ぎりぎりだと一部図形がｽﾄﾚｯﾁできないようである
  ; ｸﾞﾙｰﾌﾟ分解 03/07/09 YM ADD
  (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")
  (command "_qsave")
  ; 03/05/06 YM ADD-E

  ; LR反転する
  (sub_MirrorMove)
  (princ)
);sub_AutoMrr

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_DelUnusedGroup
;;; <処理概要>  : 未使用グループを削除する
;;; <戻り値>    : なし
;;; <作成>      : 03/05/07 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_DelUnusedGroup (
  /
  #340 #EG #EG$ #EN #GRPEN #GRPNAME #I #J #LOOP #MEM #MEM$ #COUNT #HAND
  )
  (setq #count 0) ; 削除数のｶｳﾝﾄ
  (setq #eg$ (entget (namedobjdict)))
  (setq #i 0)
  (setq #en nil)
  (while (and (= #en nil) (< #i (length #eg$)))
    (setq #eg (nth #i #eg$))
    (if (and (= 3 (car #eg)) (= "ACAD_GROUP" (cdr #eg)))
      (setq #en (cdr (nth (1+ #i) #eg$)))
    )
    (setq #i (1+ #i))
  );while

  (if #en ; "DICTIONARY"取得
    (progn
      (setq #eg$ (entget #en))
      (setq #i 0)
      (while (< #i (length #eg$))
        (setq #eg (nth #i #eg$))
        (if (= 3 (car #eg))
          (progn
            (setq #grpname (cdr #eg))                ; ｸﾞﾙｰﾌﾟ名
            (setq #grpen   (cdr (nth (1+ #i) #eg$))) ; ｸﾞﾙｰﾌﾟ図形
            (if (and #grpname #grpen)
              (progn
                (setq #mem$ (entget #grpen))
                (setq #340 nil) ; 340図形有無ﾌﾗｸﾞ なし==>nil あり==>T
                (setq #j 0 #loop T)
                (while (and #loop (< #j (length #mem$)))
                  (setq #mem (nth #j #mem$))
                  (if (= 340 (car #mem))
                    (setq #340 T #loop nil)
                  );_if
                  (setq #j (1+ #j))
                );while

                ;不用ｸﾞﾙｰﾌﾟの分解
                (if (= nil #340)
                  (progn ; 340番図形なし

;;;                   (setq #del T)  ; ｸﾞﾙｰﾌﾟ分解可能ﾌﾗｸﾞ
;;;                   (foreach #mem #mem$
;;;                     (if (and (= 70 (car #mem))(= 3 (cdr #mem)))
;;;                       ; ｸﾞﾙｰﾌﾟを分解できない(70 . 3)は何?
;;;                       ;  70 "名前なし" フラグ: 1 = 名前なし、0 = 名前あり
;;;                       (setq #del nil)  ; *無効*
;;;                     )
;;;                   )
;;;                   (if #del
;;;                     (progn
;;;                       (command "_.-group" "E" #grpname)
;;;                       (if (wcmatch (getvar "CMDNAMES") "*GROUP*")
;;;                         (command)
;;;                       );_if

                        ; "GROUP"を entdel する
                        (setq #hand (cdr (assoc 5 #mem$)))
                        ;03/06/25 YM MOD #hand = nil のときがある
                        (if #hand
                          (entdel (handent #hand))
                        );_if

                        (setq #count (1+ #count))
;;;                     )
;;;                   );_if
                  )
                );_if
              )
            );_if
          )
        );_if
        (setq #i (1+ #i))
      );while
    )
  );_if
  (princ "\n")(princ #count)(princ "個のｸﾞﾙｰﾌﾟを分解しました")
  (princ)
);KP_DelUnusedGroup

;////////////////////////////////////////////////////////////////
; 現在定義されているｸﾞﾙｰﾌﾟをテキスト出力する
;////////////////////////////////////////////////////////////////
(defun c:ggg ( / DATE_TIME #DELFLG #EG #EG$ #EN #FIL #GRPEN #GRPNAME #HAND #I #MEM$ #DATE_TIME)
  ; ﾌｧｲﾙOPEN
  (setq #fil (open (strcat CG_SYSPATH "既存ｸﾞﾙｰﾌﾟ.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n" #fil)

  (setq #eg$ (entget (namedobjdict)))
  (setq #i 0)
  (setq #en nil)
  (while (and (= #en nil) (< #i (length #eg$)))
    (setq #eg (nth #i #eg$))
    (if (and (= 3 (car #eg)) (= "ACAD_GROUP" (cdr #eg)))
      (setq #en (cdr (nth (1+ #i) #eg$)))
    )
    (setq #i (1+ #i))
  );while

  (if #en ; "DICTIONARY"取得
    (progn
      (setq #eg$ (entget #en))
      (setq #i 0)
      (while (< #i (length #eg$))
        (setq #eg (nth #i #eg$))
        (if (= 3 (car #eg))
          (progn
            (setq #grpname (cdr #eg))                ; ｸﾞﾙｰﾌﾟ名
            (princ "\n" #fil)(princ #grpname #fil)(princ "  " #fil)

            (setq #grpen   (cdr (nth (1+ #i) #eg$))) ; ｸﾞﾙｰﾌﾟ図形
            (setq #mem$ (entget #grpen))
            (setq #delflg nil) ; entdelする
            (foreach #mem #mem$
              (if (and (= 70 (car #mem))(= 3 (cdr #mem)))
                (princ "削除できない" #fil)
              );_if
            )
          )
        );_if
        (setq #i (1+ #i))
      );while
    )
  );_if

  (if #fil
    (progn
      (close #fil)
      (princ "\nﾌｧｲﾙに書き込みました.")
      (startapp "notepad.exe" (strcat CG_SYSPATH "既存ｸﾞﾙｰﾌﾟ.txt"))
    )
  );_if

  (princ)

)

;;;<HOM>*************************************************************************
;;; <関数名>    : C:AutoView
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いて隠線処理して見る
;;; <戻り値>    : なし
;;; <作成>      : 03/05/08 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:AutoView (
  /
  #DWG$ #PATH #I #IFNAME1
  )
;;; ; 対象DWG名のﾘｽﾄを求める(#path に存在する*.DWGの個数)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
;;; (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  (setq #ifname1 (strcat #path CG_SeriesCode "-DWGLIST.txt"))
  (setq #DWG$ (ReadCSVFile #ifname1))
  (setq #DWG$ (mapcar 'car #DWG$))

  ; ﾙｰﾌﾟ処理
  (setq #i 0)
  (foreach #DWG #DWG$
    (setq CG_DWG #DWG)
    ; 開くﾌｧｲﾙ名
    (setq CG_OPEN-DWG (strcat #path #DWG))
    (setq CG_OpenMode 888) ; → S::STARTUP → sub_AutoView
    ;開く処理
    (if (/= (getvar "DBMOD") 0)
      (progn
        (if (/= 0 #i)
          (progn ; 最初だけ飛ばす
            (command "._zoom" "E")
            (if (= "R" (substr CG_OLD_DWG 11 1))
              ; 右-->南東
              (SKChgView "2,-2,1")
              ; 左-->南西
              (SKChgView "-2,-2,1")
            );_if
            (command "._shademode" "2D") ; 隠線処理
          )
        );_if
        (command "_qsave")
        (vl-cmdf "._open" CG_OPEN-DWG)
        (command "._shademode" "2D") ; 隠線処理
        (CFYesDialog (strcat CG_DWG "\n前はOK?"))
      )
      (progn
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
    );_if

    (S::STARTUP)
    (setq CG_OLD_DWG #DWG)
    (setq #i (1+ #i))
  )
  (princ)
);C:AutoView

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_AutoView
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを隠線処理して見る
;;; <戻り値>    : なし
;;; <作成>      : 03/05/08 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun sub_AutoView ( / )
  (command "._zoom" "E")
  (SKChgView "-1,1,1") ; 北西等角図
  (command "._shademode" "H") ; 隠線処理
  (CFYesDialog (strcat CG_DWG "\n後ろはOK?"))
  (princ)
);sub_AutoView

;;;<HOM>*************************************************************************
;;; <関数名>    : C:AutoMove
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いてﾌﾟﾗﾝを移動して挿入基点を変更する
;;; <戻り値>    : なし
;;; <作成>      : 03/05/08 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:AutoMove (
  /
  #DWG$ #I #PATH
  )
  ; 対象DWG名のﾘｽﾄを求める(#path に存在する*.DWGの個数)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  ; ﾙｰﾌﾟ処理
  (foreach #DWG #DWG$
    (setq CG_DWG #DWG)
    ; 開くﾌｧｲﾙ名
    (setq CG_OPEN-DWG (strcat #path #DWG))
    (setq CG_OpenMode 777) ; → S::STARTUP → sub_AutoMove
    ;開く処理
    (if (/= (getvar "DBMOD") 0)
      (progn
        (command "_qsave")
        ; OPEN
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
      (progn
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
    );_if

    (S::STARTUP) ; → sub_AutoMove
    (setq CG_OLD_DWG #DWG)
  )
  (command "_qsave")
  (princ)
);C:AutoMove

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_AutoMove
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを移動して挿入基点を変更する
;;; <戻り値>    : なし
;;; <作成>      : 03/05/08 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun sub_AutoMove ( / #DIR #MPT #SS #SSGRP #WW)
  (command "._zoom" "E")

  ;移動距離
  (setq #ww (atoi (substr CG_DWG 6 3)))
  (setq #ww (* #ww 10)) ; 180-->1800mm

  ;移動方向 L or R
  (setq #dir (substr CG_DWG 11 1))

  (if (= "R" #dir)
    (setq #mpt (list #ww 0 0))
    (setq #mpt (list (- #ww) 0 0))
  );_if

  ;移動
  (setq #ss (ssget "X"))
  (setq #ssGrp (ChangeItemColor #ss '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")) "BYLAYER"))
  (command "_move" #ssGrp "" '(0 0 0) #mpt)
  ; "G_LSYM"(挿入点)更新
  (ChgLSYM1 #ssGrp)

  (if (= "R" #dir)
    ; 右-->南東
    (SKChgView "2,-2,1")
    ; 左-->南西
    (SKChgView "-2,-2,1")
  );_if

  (princ)
);sub_AutoMove

;;;<HOM>*************************************************************************
;;; <関数名>    : C:AutoPlot
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いて施工図を印刷
;;; <戻り値>    : なし
;;; <作成>      : 03/05/09 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:AutoPlot (
  /
  #DWG$ #PATH #IFNAME1
  )
  (setq CG_AUTOMODE 1)  ;自動ﾓｰﾄﾞ(ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄと同じ)
  (setvar "FILEDIA" 0)

;;; ; 対象DWG名のﾘｽﾄを求める(#path に存在する*.DWGの個数)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
;;; (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  (setq #ifname1 (strcat #path CG_SeriesCode "-DWGLIST.txt"))
  (setq #DWG$ (ReadCSVFile #ifname1))
  (setq #DWG$ (mapcar 'car #DWG$))

  ; ﾙｰﾌﾟ処理
  (foreach #DWG #DWG$
    (c:clear) ; 図面ｸﾘｱｰ
    (setq CG_DWG #DWG)
    ; 開くﾌｧｲﾙ名
    (setq CG_OPEN-DWG (strcat #path #DWG))
    (if (= nil (findfile CG_OPEN-DWG))
      (progn
        (setq #msg (strcat CG_OPEN-DWG " がありません"))
        (CFAlertMsg #msg)
      )
    )

    ;挿入処理
    (KP_InBlock_sub CG_OPEN-DWG)
    (sub_AutoPlot)
  )
  (princ)
);C:AutoPlot

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_AutoPlot
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを隠線処理して見る
;;; <戻り値>    : なし
;;; <作成>      : 03/05/08 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun sub_AutoPlot ( / )

  ;Head.cfgを書き出す
  (SKB_WriteHeadList)
  ; 保存
  (command "_.QSAVE")
  ; ﾊﾟｰｼﾞ
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  ; 展開図作成
  (C:SCFMakeMaterial)
  ;図面ﾚｲｱｳﾄ
  (setq CG_AUTOMODE_DIMMK (list (list "1" "1" "A" "Y") (list (list "A3-30-5-I型平ABD仕" "04"))))
  (C:SCFLayout)
  ;図面参照
  (setq CG_AUTOMODE_ZUMEN ; 展開図R
    (strcat CG_KENMEI_PATH "OUTPUT\\A3-30-5-I型平ABD仕_0_04.dwg")
  )
  (C:SCFConf)
  ;簡易印刷
  (setq CG_AUTOMODE_PRINT (list "paperA3" "scale30")); 展開図
  (C:PlainPlot)
  ; ﾌﾟﾗﾝﾆﾝｸﾞﾒﾆｭｰ
  (C:ChgMenuPlan)
  ; 元の図面に戻る
  (C:SCFConfEnd)
  (princ)
);sub_AutoPlot

;;;<HOM>*************************************************************************
;;; <関数名>    : C:AutoDoorDel
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いて扉を削除する
;;; <戻り値>    : なし
;;; <作成>      : 03/05/13 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:AutoDoorDel (
  /
  #DWG$ #I #PATH
  )
  ; 対象DWG名のﾘｽﾄを求める(#path に存在する*.DWGの個数) NAS 収納部用
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_SeriesCode "\\"))
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  ; ﾙｰﾌﾟ処理
  (foreach #DWG #DWG$
    (setq CG_DWG #DWG)
    ; 開くﾌｧｲﾙ名
    (setq CG_OPEN-DWG (strcat #path #DWG))
    (setq CG_OpenMode 666) ; → S::STARTUP → sub_AutoDoorDel
    ;開く処理
    (if (/= (getvar "DBMOD") 0)
      (progn
        (command "_qsave")
        ; OPEN
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
      (progn
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
    );_if

    (S::STARTUP) ; → sub_AutoDoorDel
    (setq CG_OLD_DWG #DWG)
  )
  (command "_qsave")
  (princ)
);C:AutoDoorDel

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_AutoDoorDel
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いて扉を削除する
;;; <戻り値>    : なし
;;; <作成>      : 03/05/08 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun sub_AutoDoorDel (
  /
  #DIR #I #SS #SYM
  )
  (command "._zoom" "E")

;;; (if CG_DWG
;;;   (setq #dir (substr CG_DWG 11 1))
;;; )

  (setq #ss (ssget "X" '((-3 ("G_SYM"))))) ; G_LSYM 図形選択ｾｯﾄ
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        ;扉削除
        (PKD_EraseDoor #sym)
        (setq #i (1+ #i))
      )
    )
    ;else
    (CFAlertMsg "図面上に部材がありません")
  );_if

;;; (if (= "R" #dir)
;;;   ; 右-->南東
;;;   (SKChgView "2,-2,1")
;;;   ; 左-->南西
;;;   (SKChgView "-2,-2,1")
;;; );_if

  (princ)
);sub_AutoDoorDel

(defun c:dd ( / )
  (sub_AutoDoorDel)
)

;;;<HOM>*************************************************************************
;;; <関数名>    : C:AutoSAVE2000
;;; <処理概要>  : \MASTER,\DRMASTER のDWGを2000形式で保存する
;;; <戻り値>    : なし
;;; <作成>      : 03/05/15 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:AutoSAVE2000 (
  /
  #DRMASTER-DWG #DRMASTER-DWG$ #DWG$ #MASTER-DWG #MASTER-DWG$ #OPEN-DWG$ #PATH
  )
  (setvar "CMDECHO" 0)
  ; \MASTER内のDWG名のﾘｽﾄを求める
  (setq #path (strcat CG_SKDATAPATH "MASTER\\"))
  (setq #dwg$ (vl-directory-files #path "*.dwg" 1))
  (setq #MASTER-DWG$ nil)
  (foreach #dwg #dwg$
    (setq #MASTER-DWG (strcat #path #dwg))
    (setq #MASTER-DWG$ (append #MASTER-DWG$ (list #MASTER-DWG)))
  )
  ; \DRMASTER内のDWG名のﾘｽﾄを求める
  (setq #path (strcat CG_SKDATAPATH "DRMASTER\\"))
  (setq #dwg$ (vl-directory-files #path "*.dwg" 1))
  (setq #DRMASTER-DWG$ nil)
  (foreach #dwg #dwg$
    (setq #DRMASTER-DWG (strcat #path #dwg))
    (setq #DRMASTER-DWG$ (append #DRMASTER-DWG$ (list #DRMASTER-DWG)))
  )
  (setq #OPEN-DWG$ (append #MASTER-DWG$ #DRMASTER-DWG$))

  ; ﾙｰﾌﾟ処理
  (foreach #DWG #OPEN-DWG$
    ; 開くﾌｧｲﾙ名
    (setq CG_OPEN-DWG #DWG)
    (setq CG_OpenMode 555) ; → S::STARTUP → sub_Auto2000SAVE
    ;開く処理
    (if (/= (getvar "DBMOD") 0)
      (progn
        (command "_qsave")
        ; OPEN
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
      (progn
        (vl-cmdf "._open" CG_OPEN-DWG)
      )
    );_if

    (S::STARTUP) ; → sub_AutoDoorDel
;;;   (setq CG_OLD_DWG #DWG)
  )
  (command "_qsave")
  (princ)
);C:AutoSAVE2000

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_AutoSAVE2000
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを移動して挿入基点を変更する
;;; <戻り値>    : なし
;;; <作成>      : 03/05/08 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun sub_AutoSAVE2000 ( / )
  (princ)
);sub_AutoSAVE2000

















;;;<HOM>*************************************************************************
;;; <関数名>    : C:AutoKOUSIN
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いて部材更新その他を行う
;;; <戻り値>    : なし
;;; <作成>      : 03/06/24 YM 改良 04/03/10 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun C:AutoKOUSIN (
  /
  #DWG$ #PATH
  )
  ;// コマンドの初期化
  (StartUndoErr)

  ; 対象DWG名のﾘｽﾄを求める(#path に存在する*.DWGの個数)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\")) ; DB名に変更"NK_KSA"など
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

;;; ; 対象DWG名のﾘｽﾄを求める
;;; (setq #ifname1 (strcat CG_SYSPATH "plan-" CG_SeriesCode ".txt"))
;;; (setq #DWG$$ (ReadCSVFile #ifname1))
;;; (setq #DWG$ (mapcar 'car #DWG$$)) ; ﾌﾙﾊﾟｽ

  ; ﾙｰﾌﾟ処理
  (foreach #DWG #DWG$
    ; 開くﾌｧｲﾙ名
    (setq CG_OPEN-DWG (strcat #path #DWG))
    ;ﾌﾟﾗﾝ挿入
    (sub_KP_InBlock CG_OPEN-DWG)

    ; 保存ﾌｧｲﾙ名(同じ名前)
    (setq CG_SAVE-DWG (strcat #path #DWG))

    ; 03/05/07 YM ADD 不要なｸﾞﾙｰﾌﾟ定義を削除する
    (KP_DelUnusedGroup)
    (command "._zoom" "E")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")

    ;部材更新する
    (sub_AutoKOUSIN)

    ; ｸﾞﾙｰﾌﾟ分解
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    ; ﾌﾟﾗﾝを保存(copy)する
    (sub_KP_WrBlock); CG_SAVE-DWG を使用する

    (c:clear) ; 図面ｸﾘｱｰ
    ; ｸﾞﾙｰﾌﾟ分解
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")
  );foreach

  (setq *error* nil)

  (princ)
);C:AutoKOUSIN

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_AutoKOUSIN
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いて扉を削除する
;;; <戻り値>    : なし
;;; <作成>      : 03/05/08 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun sub_AutoKOUSIN ( / )
  (command "vpoint" "0,0,1")
  (command "._zoom" "E")
  ;部材更新
  (C:KPRefreshCAB)
  ;扉削除
;;;  (C:dd)
  ;未使用ｸﾞﾙｰﾌﾟ定義を削除する
  (KP_DelUnusedGroup)
  ;ﾊﾟｰｼﾞ
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_.QSAVE")
  ;保存
;;; (CFAutoSave)
  (princ)
);sub_AutoKOUSIN




;;;<HOM>*************************************************************************
;;; <関数名>    : C:AutoHINBAN_CHANGE
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いて品番修正を行う(図形,配列等は一切変更なしが前提)
;;; <戻り値>    : なし
;;; <作成>      : 06/08/11 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun C:AutoHINBAN_CHANGE (
  /
  #DWG$ #PATH #FIL #OFILE #SFILE
  )
  ;// コマンドの初期化
  (StartUndoErr)

  ; 対象DWG名のﾘｽﾄを求める(#path に存在する*.DWGの個数)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\"))
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  ;品番変更定義ﾌｧｲﾙの読み込み
  (setq #sFile (strcat #path "hinban-henkan-" CG_DBNAME ".txt"))
  (setq CG_List$ (ReadCSVFile #sFile))

  ;ﾛｸﾞﾌｧｲﾙOPEN
  (setq #ofile (strcat #path "hinban-henkan-" CG_DBNAME ".log"));結果出力ﾌｧｲﾙ
  (setq #fil (open #ofile "W" ))

  ;変更対象品番ﾘｽﾄ作成   変更品番の取得==>(cdr (assoc "SPBT180SCK" #List$$))
  (setq CG_hinban$  (mapcar 'car CG_List$))
          
  ; ﾙｰﾌﾟ処理
  (foreach #DWG #DWG$
    ; 開くﾌｧｲﾙ名
    (setq CG_OPEN-DWG (strcat #path #DWG))
    ;ﾌﾟﾗﾝ挿入
    (sub_KP_InBlock CG_OPEN-DWG)

    ; 保存ﾌｧｲﾙ名(同じ名前)
    (setq CG_SAVE-DWG (strcat #path #DWG))

    ; 03/05/07 YM ADD 不要なｸﾞﾙｰﾌﾟ定義を削除する
    (KP_DelUnusedGroup)
    (command "._zoom" "E")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")

    ;品番更新する
    (sub_AutoHINBAN_CHANGE)

    ; ｸﾞﾙｰﾌﾟ分解
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    ; ﾌﾟﾗﾝを保存(copy)する
    (sub_KP_WrBlock); CG_SAVE-DWG を使用する

    (c:clear) ; 図面ｸﾘｱｰ
    ; ｸﾞﾙｰﾌﾟ分解
    (KP_DelUnusedGroup) ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_purge" "BL" "*" "N")
    (command "_qsave")
  );foreach

  (setq *error* nil)
  (if #fil (close #fil))
  (startapp "notepad.exe" #ofile)
  (princ)
);C:AutoHINBAN_CHANGE

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_AutoHINBAN_CHANGE
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝを開いて品番修正を行う(図形,配列等は一切変更なしが前提)
;;; <戻り値>    : なし
;;; <作成>      : 06/08/11 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun sub_AutoHINBAN_CHANGE (
  /
  #HIN #I #SS #SYM #XD_LSYM$
  )
  (command "vpoint" "0,0,1")
  (command "._zoom" "E")
  ;図面上の対象品番検索
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #sym (ssname #ss #i))
    (setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
    (setq #hin (nth 5 #xd_LSYM$));品番

    (if (member #hin CG_hinban$)
      (progn ;品番変更対象
        ;更新品番
        (setq #after_hin (car (cdr (assoc #hin CG_List$))))
        (CFSetXData #sym "G_LSYM"
          (CFModList #xd_LSYM$
            (list
              (list 5 #after_hin)
            )
          )
        )
        ;log出力
        (princ (strcat "\n" #DWG ",変更前:" #hin ",変更後:" #after_hin) #fil)
      )
    );_if
    (setq #i (1+ #i))
  )

  ;未使用ｸﾞﾙｰﾌﾟ定義を削除する
  (KP_DelUnusedGroup)
  ;ﾊﾟｰｼﾞ
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_.QSAVE")
  (princ)
);sub_AutoHINBAN_CHANGE



;;;<HOM>*************************************************************************
;;; <関数名>    : C:AutoHINBAN_EXIST
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝdwgを開いて品番が[品番基本]に存在するかﾁｪｯｸする
;;; <戻り値>    : なし
;;; <作成>      : 06/08/14 YM
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun C:AutoHINBAN_EXIST (
  /
  #DWG$ #PATH #FIL #OFILE #SFILE
  )
  ;// コマンドの初期化
  (StartUndoErr)

  ; 対象DWG名のﾘｽﾄを求める(#path に存在する*.DWGの個数)
  (setq #path (strcat CG_SYSPATH "PLAN\\" CG_DBNAME "\\"))
  (setq #DWG$ (vl-directory-files #path "*.dwg" 1))

  ;ﾛｸﾞﾌｧｲﾙOPEN
  (setq #ofile (strcat #path "hinban-exist-" CG_DBNAME ".log"));結果出力ﾌｧｲﾙ
  (setq #fil (open #ofile "W" ))
          
  ; ﾙｰﾌﾟ処理
  (foreach #DWG #DWG$
    ; 開くﾌｧｲﾙ名
    (setq CG_OPEN-DWG (strcat #path #DWG))
    ;ﾌﾟﾗﾝ挿入
    (sub_KP_InBlock CG_OPEN-DWG)

    ; 保存ﾌｧｲﾙ名(同じ名前)
    (setq CG_SAVE-DWG (strcat #path #DWG))

    ; 03/05/07 YM ADD 不要なｸﾞﾙｰﾌﾟ定義を削除する
;;;   (KP_DelUnusedGroup)
;;;   (command "._zoom" "E")
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_qsave")

    ;品番の存在をﾁｪｯｸする
    (sub_AutoHINBAN_EXIST)

    ; ｸﾞﾙｰﾌﾟ分解
;;;   (KP_DelUnusedGroup)
    ; ﾌﾟﾗﾝを保存(copy)する
    (sub_KP_WrBlock); CG_SAVE-DWG を使用する

    (c:clear) ; 図面ｸﾘｱｰ
    ; ｸﾞﾙｰﾌﾟ分解
;;;   (KP_DelUnusedGroup)
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_purge" "BL" "*" "N")
;;;   (command "_qsave")
  );foreach

  (setq *error* nil)
  (if #fil (close #fil))
  (startapp "notepad.exe" #ofile)
  (princ)
);C:AutoHINBAN_EXIST

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_AutoHINBAN_EXIST
;;; <処理概要>  : ﾌﾟﾗﾝ登録したﾌﾟﾗﾝdwgを開いて品番が[品番基本]に存在するかﾁｪｯｸする
;;; <戻り値>    : なし
;;; <作成>      : 06/08/11 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun sub_AutoHINBAN_EXIST (
  /
  #HIN #I #SS #SYM #XD_LSYM$
  )
  (command "vpoint" "0,0,1")
  (command "._zoom" "E")

  (princ (strcat "\nDWG名:" #DWG) #fil)

  ;図面上の対象品番検索
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #sym (ssname #ss #i))
    (setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
    (setq #hin (nth 5 #xd_LSYM$));品番
    ;品番基本に存在するかどうかをﾁｪｯｸ
    (setq #KIHON$$
      (CFGetDBSQLRec CG_DBSESSION "品番基本"
        (list
          (list "品番名称"  #hin 'STR)
        )
      )
    )
    (if (= nil #KIHON$$)
      (princ (strcat "\n×[品番基本]に存在しない:" #hin) #fil)
      ;else
      (princ (strcat "\n◎[品番基本]に存在する:" #hin) #fil)
    );_if
    
    (setq #i (1+ #i))
  )

  ;未使用ｸﾞﾙｰﾌﾟ定義を削除する
;;; (KP_DelUnusedGroup)
  ;ﾊﾟｰｼﾞ
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_purge" "bl" "*" "N")
  (command "_.QSAVE")
  (princ)
);sub_AutoHINBAN_EXIST







;;;<HOM>*************************************************************************
;;; <関数名>    : C:HHH
;;; <処理概要>  : 図面上の全ｷｬﾋﾞﾈｯﾄの品番,図形ID,寸法Hをﾃｷｽﾄ表示する
;;; <戻り値>    : なし
;;; <作成>      : 03/05/13 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:HHH (
  /
  #DATE_TIME #FIL #HHH #HIN #I #SS #SYM #XD_LSYM$ #XD_SYM$ #ZID
  )
    ;-----------------------------------------------------------------
    (defun ##moji (
      &str
      &moji
      /
      #LOOP #N #RET
      )
      (setq #ret &str)
      (setq #n (strlen &str)) ; 文字数
      (setq #loop (- &moji #n))
      (if (< 0 #loop)
        (progn
          (repeat #loop
            (setq #ret (strcat #ret " "))
          )
        )
      );_if
      #ret
    )
    ;-----------------------------------------------------------------

  (setq #fil (open (strcat CG_SYSPATH "CHK_HHH.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n --- 図面上のｷｬﾋﾞﾈｯﾄの寸法Hﾁｪｯｸ ---" #fil)
  (princ "\n" #fil)

  (princ "\n        品番         , 図形ID  , 寸法H" #fil)

  (setq #ss (ssget "X" '((-3 ("G_SYM"))))) ; G_LSYM 図形選択ｾｯﾄ
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        (setq #xd_SYM$ (CFGetXData #sym "G_SYM"))
        (setq #hhh (nth 5 #xd_SYM$)) ; 寸法H
        (setq #xd_LSYM$ (CFGetXData #sym "G_LSYM"))
        (setq #zid (nth 0 #xd_LSYM$)) ; 図形ID
        (setq #hin (nth 5 #xd_LSYM$)) ; 品番
        (setq #hin (##moji #hin 20)) ; 文字数20になるまで末尾に空白を足す
        (princ (strcat "\n" #hin " , " #zid " , " (rtos #hhh)) #fil)
        (setq #i (1+ #i))
      )
    )
    ;else
    (CFAlertMsg "図面上に部材がありません")
  );_if

  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "CHK_HHH.txt"))
  (princ)
)

;<HOM>***********************************************************************
; <関数名>    : C:GroupHantei
; <処理概要>  : ｸﾞﾙｰﾌﾟの判定
; <戻り値>    : なし
; <作成>      : 03/05/13 YM
; <備考>      : 開発者用ﾃｽﾄｺﾏﾝﾄﾞ
; ｷｬﾋﾞﾈｯﾄ1つﾌﾟﾗﾝ保存してから挿入すると名前のあるｸﾞﾙｰﾌﾟ(扉)や、
; ｸﾞﾙｰﾌﾟの説明"DoorGroup"が消えてしまい。ｷｬﾋﾞﾈｯﾄ本体のｸﾞﾙｰﾌﾟと
; 扉のｸﾞﾙｰﾌﾟの区別がつかないので画層で違いを見る
;***********************************************************************>HOM<
(defun C:GroupHantei (
  /
  #330 #330$ #340 #340$ #340$$ #EG$ #EG2$ #EN #FIL #LAY #SYM #TYPE
  )
  (setq #fil (open (strcat CG_SYSPATH "CHECK.txt") "W" ))

  (setq #en (car (entsel "\nｷｬﾋﾞﾈｯﾄを選択: ")))
  (setq #sym (CFSearchGroupSym #en)) ; ｼﾝﾎﾞﾙ図形
  (setq #eg$ (entget #sym '("*")))

  (setq #330$ nil)
  (foreach #eg #eg$
    (if (= (car #eg) 330)
      (progn
        (setq #330 (cdr #eg))
        (setq #330$ (append #330$ (list #330)))
      )
    );_if
  )

  (setq #340$$ nil)
  (foreach #330 #330$
    (setq #eg2$ (entget #330))
    (setq #340$ nil)
    (foreach #eg2 #eg2$
      (if (= (car #eg2) 340)
        (progn
          (setq #340 (cdr #eg2))
          (setq #340$ (append #340$ (list #340)))
        )
      );_if
    )
    (setq #340$$ (append #340$$ (list #340$)))
  )

  (princ "\n--- 画層 ---" #fil)
  (foreach #340$ #340$$
    (foreach #340 #340$
      (setq #lay (cdr (assoc 8 (entget #340))))
      (princ "\n" #fil)(princ #lay #fil)
    )
    (princ "\n---" #fil)
  )

  (princ "\n--- --- ---" #fil)
  (princ "\n--- 図形ﾀｲﾌﾟ ---" #fil)

  (foreach #340$ #340$$
    (foreach #340 #340$
      (setq #type (cdr (assoc 0 (entget #340))))
      (princ "\n" #fil)(princ #type #fil)
    )
    (princ "\n---" #fil)
  )
  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "CHECK.txt"))

  (princ)
);C:GroupHantei




;;;<HOM>*************************************************************************
;;; <関数名>    : C:GetZukeiID
;;; <処理概要>  : 品番図形ﾃｰﾌﾞﾙ２重登録ﾁｪｯｸ用
;;; <戻り値>    : なし
;;; <作成>      : 00/11/28 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun C:GetZukeiID (
  /
  #DATE_TIME #FIL #HIN #HIN$ #IFNAME1 #LIST$$ #LIST1$$ #LR #QRY$ #ZUKEI
  )
  (setq #fil (open (strcat CG_SYSPATH "GetZukeiID.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み

  (princ "\n図形ID取得一覧" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ=" CG_SeriesCode) #fil)

  (setq #hin$ nil)
  (setq #ifname1 (strcat CG_SYSPATH "TEMP\\" CG_SeriesCode "-SPLAN.txt"))
  (setq #List1$$ (ReadCSVFile #ifname1)) ; ｺﾝﾛ選択肢

  (setq #list$$ nil)
  (foreach #List1$ #List1$$
    (setq #hin (car #List1$))
    (setq #qry$
      (CFGetDBSQLRec CG_DBSESSION "品番基本"
        (list
          (list "品番名称" #hin 'STR)
        )
      )
    )
    (if (or (= #qry$ nil)(> (length #qry$) 1))
      (progn
        (CFAlertMsg (strcat "検索失敗【品番基本】:" #hin))
        (quit)
      )
      (progn
        (setq #qry$ (car #qry$))
        (setq #LR (nth 1 #qry$))
        (if (= 0 #LR)
          (progn ; "Z"
            ;--------------------------------------------------------------------
            (setq #LR "Z")
            (setq #qry$
              (CFGetDBSQLRec CG_DBSESSION "品番図形"
                (list
                  (list "品番名称"   #HIN  'STR)
                  (list "LR区分"     #LR   'STR)
                )
              )
            )
            (if (or (= #qry$ nil)(> (length #qry$) 1))
              (progn
                (CFAlertMsg (strcat "検索失敗【品番図形】: " #hin "  LR: " #LR))
                (quit)
              )
              (progn ; 図形ID取得
                (setq #qry$ (car #qry$))
                (setq #zukei (nth 6 #qry$));2008/06/28 OK!
                (setq #list$$ (append #list$$ (list (list #hin #zukei))))
              )
            );_if
          )
          (progn ; "L","R"
            ;--------------------------------------------------------------------
            (setq #LR "L")
            (setq #qry$
              (CFGetDBSQLRec CG_DBSESSION "品番図形"
                (list
                  (list "品番名称"   #HIN  'STR)
                  (list "LR区分"     #LR   'STR)
                )
              )
            )
            (if (or (= #qry$ nil)(> (length #qry$) 1))
              (progn
                (CFAlertMsg (strcat "検索失敗【品番図形】: " #hin "  LR: " #LR))
                (quit)
              )
              (progn ; 図形ID取得
                (setq #qry$ (car #qry$))
                (setq #zukei (nth 6 #qry$));2008/06/28 OK!
                (setq #list$$ (append #list$$ (list (list #hin #zukei))))
              )
            );_if

            ;--------------------------------------------------------------------
            (setq #LR "R")
            (setq #qry$
              (CFGetDBSQLRec CG_DBSESSION "品番図形"
                (list
                  (list "品番名称"   #HIN  'STR)
                  (list "LR区分"     #LR   'STR)
                )
              )
            )
            (if (or (= #qry$ nil)(> (length #qry$) 1))
              (progn
                (CFAlertMsg (strcat "検索失敗【品番図形】: " #hin "  LR: " #LR))
                (quit)
              )
              (progn ; 図形ID取得
                (setq #qry$ (car #qry$))
                (setq #zukei (nth 6 #qry$));2008/06/28 OK!
                (setq #list$$ (append #list$$ (list (list #hin #zukei))))
              )
            );_if

          )
        );_if

      )
    );_if

  );foreach

  (foreach #list$ #list$$
    (setq #hin   (car  #list$))
    (setq #zukei (cadr #list$))
    (princ (strcat "\n" #HIN "," #zukei) #fil)
  )

  (close #fil)
  (startapp "notepad.exe" (strcat CG_SYSPATH "GetZukeiID.txt"))
  (princ)
);C:GetZukeiID

;;;<HOM>*************************************************************************
;;; <関数名>    : CFGetNumFromStr_NAS
;;; <処理概要>  : 文字列の数字部分だけ取得する
;;;               (例) "GS-105A"--->"105"
;;; <戻り値>    : 文字列
;;; <作成>      : 03/06/09 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun CFGetNumFromStr_NAS (
  &str ; 文字列
  /
  #I #RET #STR #END #KOSU
  )
  (setq #str &str)

  ;04/08/16 YM MOD (品番末尾"1","2","3"付きを除外する)
  (setq #kosu (strlen #str))
  (setq #end (substr #str #kosu 1));末尾の文字
  (if (or (= #end "1")(= #end "2")(= #end "3"))
    (setq #str (substr #str 1 (1- #kosu)));末尾1文字を削除した文字列
  );_if

  (setq #ret "")
  (if (= 'STR (type #str))
    (progn
      (setq #i 1)
      (repeat (strlen #str)
        (setq #s (substr #str #i 1))
        (if (wcmatch #s "#")
          (setq #ret (strcat #ret #s))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CFGetNumFromStr_NAS

;;;<HOM>*************************************************************************
;;; <関数名>    : CFGetNumFromStr
;;; <処理概要>  : 文字列の数字部分だけ取得する
;;;               (例) "GS-105A"--->"105"
;;; <戻り値>    : 文字列
;;; <作成>      : 03/06/09 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun CFGetNumFromStr (
  &str ; 文字列
  /
  #I #RET #STR
  )
  (setq #ret "")
  (if (= 'STR (type &str))
    (progn
      (setq #i 1)
      (repeat (strlen &str)
        (setq #str (substr &str #i 1))
        (if (wcmatch #str "#")
          (setq #ret (strcat #ret #str))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CFGetNumFromStr

;;;<HOM>*************************************************************************
;;; <関数名>    : CFGetNumFromStr2
;;; <処理概要>  : 文字列の数字部分だけ取得する
;;;               (例) "SAB5S060@@K"--->"060"
;;; <戻り値>    : 文字列
;;; <作成>      : 03/06/09 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun CFGetNumFromStr2 (
  &str ; 文字列
  /
  #I #RET #STR
  )
  (setq #str &str)
  (setq #str (substr #str 5 5));引数文字列の5～9文字まで
  
  (setq #ret "")
  (if (= 'STR (type #str))
    (progn
      (setq #i 1)
      (repeat (strlen #str)
        (setq #s (substr #str #i 1))
        (if (wcmatch #s "#")
          (setq #ret (strcat #ret #s))
        );_if
        (setq #i (1+ #i))
      )
    )
  );_if
  #ret
);CFGetNumFromStr2

;;;<HOM>*************************************************************************
;;; <関数名>    : KP_BuzaiHaiti
;;; <処理概要>  : 部材を配置する
;;; <戻り値>    : 配置したｼﾝﾎﾞﾙ図形
;;; <作成>      : 03/06/12 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun KP_BuzaiHaiti (
  &id     ; 図形ID  STR "???????"  ".dwg"以外の部分
  &pt     ; 挿入点　LIST
  &ang    ; 角度    REAL
  &hinban ; 品番名称
  &LR     ; LR区分
  &skk    ; [品番基本].性格ｺｰﾄﾞ
  &hh     ; [品番図形].寸法Ｈ
  /
  #DWG #ENEW #SS
  )
  ;ﾌｧｲﾙ名
  (setq #dwg (strcat &id ".dwg"))
  ;dwgの有無
  (if (findfile (strcat CG_MSTDWGPATH #dwg))
    nil
    ;else
    (progn
      (CFAlertMsg (strcat "図形ﾌｧｲﾙ " #dwg " がありません"))
      (quit)
    )
  );_if

  ; 挿入
  (command ".insert" (strcat CG_MSTDWGPATH #dwg) &pt 1 1 (rtd &ang))
  ; 分解,ｸﾞﾙｰﾌﾟ化
  (command "_explode" (entlast))
  (setq #ss (ssget "P"))
  (SKMkGroup #ss) ;分解した図形群で名前のないグループ作成
  (command "_layer" "u" "N_*" "")
  ; ｼﾝﾎﾞﾙ図形 #eNEW
  (setq #eNEW (SearchGroupSym (ssname #ss 0)))
  ;Xdataｾｯﾄ
  (CFSetXData #eNEW "G_LSYM"
    (list
      &id               ;1 :本体図形ID
      &pt               ;2 :挿入点          :配置基点     POINT
      &ang              ;3 :回転角度        :配置回転角度 REAL
      CG_KCode          ;4 :工種記号        :CG_Kcode     STR
      CG_SeriesCode     ;5 :SERIES記号      :ｼﾘｰｽﾞ記号    STR
      &hinban           ;6 :品番名称        :『品番図形』.品番名称    STR
      &LR               ;7 :L/R区分         :『品番図形』.部材L/R区分 STR
      ""                ;8 :扉図形ID        :
      &id               ;9 :扉開き図形ID    : STR
      &skk              ;10:[品番基本].性格CODE 整数
      0
      0
      0                ;13:用途番号        :『品番図形』.用途番号 整数
      &hh              ;14:寸法Ｈ          :『品番図形』.寸法Ｈ   整数
      0                ;15:断面指示の有無  :『プラ構成』.断面有無 00/07/18 SN MOD
    )
  )
  ;画層制御
  (command "_layer" "on" "M_*" "")
  (command "_layer" "F" "Y_00*" "")   ; ﾌﾘｰｽﾞ
  (command "_layer" "OFF" "Y_00*" "") ; 非表示
  (command "_.layer" "F" "Z_*" "")
  (command "_.layer" "T" "Z_00*" "")
  (command "_.layer" "T" "Z_KUTAI" "") ; 01/02/20 YM ADD

  #eNEW ; ｼﾝﾎﾞﾙ
);KP_BuzaiHaiti


;;;<HOM>*************************************************************************
;;; <関数名>    : All_dwg
;;; <処理概要>  : E:\works\KPCAD\PLAN 以下の全"DWG"ﾌｧｲﾙのﾌﾙﾊﾟｽﾘｽﾄを求める
;;; <戻り値>    :
;;; <作成>      : 03/06/24 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun All_dwg (
  /
  #DATE_TIME #FIL #FULLPATHSG$ #FULLPATHSX$ #SG_PATH #SX_PATH
  )
  ;/////////////////////////////////////////////////////////////////////////////
  (defun ##KENSAKU (
    &path
    /
    #DIR_1$ #DIR_2$ #DWG_1$ #DWG_2$ #FULLPATH #FULLPATH$ #PATH
    )
    ;LEVEL1
    (setq #dir_1$ (vl-directory-files &path nil -1))
    (setq #dir_1$ (cdr (cdr #dir_1$)))
    (foreach #dir_1 #dir_1$
      ;このﾚﾍﾞﾙでDWGを検索
      (setq #path (strcat &path "\\" #dir_1))
      (setq #dwg_1$ (vl-directory-files #path "*.dwg" 1))
      ;full path を求める
      (foreach #dwg_1 #dwg_1$
        (setq #fullpath (strcat &path "\\" #dir_1 "\\" #dwg_1))
        (setq #fullpath$ (append #fullpath$ (list #fullpath)))
      )
      ;次のﾚﾍﾞﾙ
      (setq #dir_2$ (vl-directory-files #path nil -1))
      (setq #dir_2$ (cdr (cdr #dir_2$)))
      (foreach #dir_2 #dir_2$
        ;このﾚﾍﾞﾙでDWGを検索
        (setq #path (strcat &path "\\" #dir_1 "\\" #dir_2))
        (setq #dwg_2$ (vl-directory-files #path "*.dwg" 1))
        ;full path を求める
        (foreach #dwg_2 #dwg_2$
          (setq #fullpath (strcat &path "\\" #dir_1 "\\" #dir_2 "\\" #dwg_2))
          (setq #fullpath$ (append #fullpath$ (list #fullpath)))
        )
      )
    )
    #fullpath$
  );##KENSAKU
  ;/////////////////////////////////////////////////////////////////////////////
  (defun ##PRINT ( &fullpath$ / )
    (foreach #fullpath &fullpath$
      (princ (strcat "\n" #fullpath) #fil)
    )
    (princ "\n" #fil)
    (princ)
  )
  ;/////////////////////////////////////////////////////////////////////////////

  ;検索ﾊﾟｽ
  (setq #SG_path "E:\\works\\KPCAD\\PLAN\\SG")
  (setq #SX_path "E:\\works\\KPCAD\\PLAN\\X")
  (setq #fullpathSG$ nil) ; 更新対象全ﾌﾙﾊﾟｽ

  ;ﾌｧｲﾙｵｰﾌﾟﾝ
  (setq #fil (open (strcat CG_SYSPATH "plan.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n" #fil)

  ;検索
  (setq #fullpathSG$ (##KENSAKU #SG_path))
  (setq #fullpathSX$ (##KENSAKU #SX_path))

  ;出力
  (##PRINT #fullpathSG$)
  (##PRINT #fullpathSX$)

  (if #fil
    (progn
      (close #fil)
      (princ "\nﾌｧｲﾙに書き込みました.")
      (startapp "notepad.exe" (strcat CG_SYSPATH "plan.txt"))
    )
  );_if
  (princ)
);All_dwg

;*****************************************************************************:
; 品番の変換ツール
; 場所： CG_SYSPATH \TEMP
;*****************************************************************************:
(defun C:Henkan (
  /

  )
  ;// コマンドの初期化
  (StartUndoErr)
;;;CG_SeriesCode

  ;全ﾚｺｰﾄﾞを取得
  (setq #rec01$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from SINK管理")))
  (setq #rec02$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from プラ構OP")))
  (setq #rec03$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from プラ構成")))
  (setq #rec04$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 複合構成"))) ; nth 2
  (setq #rec05$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 階層" CG_SeriesCode)))
  (setq #rec06$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 品番最終")))
;;; (setq #rec1$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 品番シリ")))
;;; (setq #rec1$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 品番基本")))
;;; (setq #rec1$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from 品番図形")))

;;; (setq #ifname (strcat CG_SYSPATH "TEMP\\" CG_SeriesCode "-hinban.txt"))
;;; (setq #hinban$$ (ReadCSVFile #ifname))
;;; (setq #hinban$ (mapcar 'car #hinban$$))

  (setq #CH$$
    (list
      (list "VB-120E"     "VB-120")
      (list "VB-135BLS"   "VB-135B")
      (list "VB-135E"     "VB-135")
      (list "VB-140BLS"   "VB-140B")
      (list "VB-140E"     "VB-140")
      (list "VB-30E"      "VB-30")
      (list "VB-45E"      "VB-45")
    )
  )

  (setq #fp (open #ofile "w"))
  (setq #NewList$$ nil)
  (foreach #List$ #List$$
    (setq #str (nth 2 #List$))
    (if (= (substr #str 1 1) "G") ; 先頭文字"G"=>"V"
      (progn
        (setq #newstr (strcat "V" (substr #str 2 (1- (strlen #str)))))
        ; もし変換ﾘｽﾄにあったら更に品番変換
        (foreach #CH$ #CH$$
          (if (= (car #CH$) #newstr)
            (setq #newstr (cadr #CH$))
          );_if
        )
        (setq #NewList$ (subst #newstr #str #List$))
      )
      (setq #NewList$ #List$)
    );_if
    (setq #NewList$$ (append #NewList$$ (list #NewList$)))
  )

  ; 追加ﾚｺｰﾄﾞ作成
  (setq #n 1)
  (foreach #NewList$ #NewList$$
    (setq #i 1)
    (foreach #NewList #NewList$
      (if (= #i 1)
        (princ #NewList #fp)
        (princ (strcat "," #NewList) #fp)
      );_if
      (setq #i (1+ #i))
    )
    (princ "\n" #fp)
    (setq #n (1+ #n))
  )

  (close #fp)

  (setq *error* nil)
  (princ)
);C:Henkan

;*****************************************************************************:
; 複合構成テーブル作成ツール(ｺﾝﾛ下選択肢)
; 使用場所: CG_SYSPATH \DATA
; 03/09/17 YM
; 以下のCSVﾌｧｲﾙを準備する

;;;調理キャビ.csv
;;;GT-15E,R
;;;GT-15B,R
;;;GT-15K,R
;;;...

;;;オーブン.csv
;;;DR-505E,Z
;;;DR-505C,Z
;;;DR-404E,Z
;;;DR-404ESV,Z
;;;...

;;;コンロ.csv
;;;RBG-31A6S-BG,Z
;;;DG3295NQ1,Z
;;;RBG-31A6S-SVG,Z
;;;RBG-31A6FS-B,Z
;;;...

;;;複合構成の雛形CSVﾌｧｲﾙ(複合構成.csv)
;;;10001,1,調理,R,850,0,0,0,0,0
;;;10001,2,オーブン,Z,850,0,1,0,0,0
;;;10001,3,コンロ,Z,850,0,2,2,0,0
;;;10002,1,調理,R,850,0,0,0,0,0
;;;10002,2,オーブン,Z,850,0,1,0,0,0
;;;10002,3,コンロ,Z,850,0,2,2,0,0
;;;10002,4,YT-15S,R,850,0,1,0,0,0

;*****************************************************************************:
(defun C:OBUN (
  /
  #CAB #CAB-KIGO #CAB-LR #DUM$ #FP1 #GAS #GAS-KIGO #GAS-LR #HINBAN #HUKU_ID #I #ID$
  #IFNAME1 #IFNAME2 #IFNAME3 #IFNAME4 #J #K #KIGO$ #LIST1$$ #LIST2$$ #LIST3$$ #LIST4$$
  #LR #N #NEWLIST$ #NEWLIST$$ #OBN #OBN-KIGO #OBN-LR #OFNAME1 #PTN #XXX
  )
  ;// コマンドの初期化
  (StartUndoErr)

        ;/////////////////////////////////////////////////////////////////
        (defun ##OUTPUT (
          &LIS$$ ; 出力ﾘｽﾄ
          &fp    ; ﾌｧｲﾙ識別子
          /
          #I #N
          )
          (setq #n 1)
          (foreach #NewList$ &LIS$$
            (setq #i 1)
            (foreach #NewList #NewList$
              (if (= #i 1)
                (princ #NewList &fp)
                (princ (strcat "," #NewList) &fp)
              );_if
              (setq #i (1+ #i))
            )
            (princ "\n" &fp)
            (setq #n (1+ #n))
          )
          (close &fp)
          (princ)
        )
        ;/////////////////////////////////////////////////////////////////
        (defun ##findfile ( &path / )
          (if (= nil (findfile &path))
            (progn
              (CFAlertErr (strcat &path " がありません"))
              (quit)
            )
          );_if
          (princ)
        )
        ;/////////////////////////////////////////////////////////////////

  ; ｺﾝﾛ記号 全部で36種類まで可能
  (setq #kigo$ (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"
                     "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
                     "U" "V" "W" "X" "Y" "Z" "1" "2" "3" "4"
                     "5" "6" "7" "8" "9" "0"))
  (setq #ifname1 (strcat CG_SYSPATH "DATA\\" "コンロ.csv"))      ; ｺﾝﾛ選択肢ﾌｧｲﾙ(この数分ﾙｰﾌﾟ)
  (setq #ifname2 (strcat CG_SYSPATH "DATA\\" "オーブン.csv"))    ; ｵｰﾌﾞﾝ選択肢ﾌｧｲﾙ(この数分ﾙｰﾌﾟ)
  (setq #ifname3 (strcat CG_SYSPATH "DATA\\" "調理キャビ.csv"))  ; 調理ｷｬﾋﾞ選択肢ﾌｧｲﾙ(この数分ﾙｰﾌﾟ)
  (setq #ifname4 (strcat CG_SYSPATH "DATA\\" "複合構成.csv"))    ; 雛形となる複合構成ﾃｰﾌﾞﾙﾚｺｰﾄﾞ
  (setq #ofname1 (strcat CG_SYSPATH "DATA\\" "複合構成-OUT.csv")); 出力ﾌｧｲﾙ(複合構成)
  ;ﾌｧｲﾙの有無ﾁｪｯｸ
  (##findfile #ifname1)
  (##findfile #ifname2)
  (##findfile #ifname3)
  (##findfile #ifname4)
  ; CSVﾛｰﾄﾞ
  (setq #List1$$ (ReadCSVFile #ifname1)) ; ｺﾝﾛ選択肢ﾌｧｲﾙ
  (setq #List2$$ (ReadCSVFile #ifname2)) ; ｵｰﾌﾞﾝ選択肢ﾌｧｲﾙ
  (setq #List3$$ (ReadCSVFile #ifname3)) ; 調理ｷｬﾋﾞ選択肢ﾌｧｲﾙ
  (setq #List4$$ (ReadCSVFile #ifname4)) ; 雛形複合構成
  ; ｺﾝﾛ選択肢の数ﾁｪｯｸ
  (if (< 36 (length #List1$$))
    (progn
      (CFAlertErr "ｺﾝﾛの選択肢の数が36を越えているため\nｺﾝﾛ記号を2桁にしないといけません")
      (quit)
    )
  );_if

  (setq #id$ (mapcar 'car #List4$$)) ; 複合IDのﾘｽﾄ
  (setq #dum$ nil)
  ; 複合IDのﾘｽﾄから重複を除外
  (foreach #id #id$
    (if (= nil (member #id #dum$))
      (setq #dum$ (append #dum$ (list #id)))
    );_if
  )
  ; 複合構成のﾊﾟﾀｰﾝ数(選択肢"A"のみ)を求める
  (setq #ptn (length #dum$))

  ;★★★　ﾒｲﾝ処理実行　★★★
  (setq #NewList$$ nil) ; 複合構成(出力用ﾘｽﾄ)
  (princ "\n")(princ (strcat "ﾃﾞｰﾀ作成中...")) ; ﾁｪｯｸﾗｲﾄ
  (setq #i 0)
  (setq #n 0)                                  ; 複合ID用番号
  ; *** ｺﾝﾛ ***
  (foreach #List1$ #List1$$                    ; ｺﾝﾛ選択肢分ﾙｰﾌﾟ
    (setq #GAS    (car  #List1$))              ; ｶﾞｽ品番
    (setq #GAS-LR (cadr #List1$))              ; ｶﾞｽLR区分
    (setq #GAS-kigo (nth #i #kigo$))
    (princ "\n")(princ (strcat "ｺﾝﾛ=" #GAS-kigo)); ﾁｪｯｸﾗｲﾄ
  ; *** ｵｰﾌﾞﾝ ***
    (setq #j 0)
    (foreach #List2$ #List2$$                  ; ｵｰﾌﾞﾝ選択肢分ﾙｰﾌﾟ
      (setq #OBN    (car  #List2$))            ; ｵｰﾌﾞﾝ品番
      (setq #OBN-LR (cadr #List2$))            ; ｵｰﾌﾞﾝLR区分
      (setq #OBN-kigo (nth #j #kigo$))
      (princ "\n")(princ (strcat "ｵｰﾌﾞﾝ=" #OBN-kigo)); ﾁｪｯｸﾗｲﾄ
  ; *** 調理ｷｬﾋﾞ ***
      (setq #k 0)
      (foreach #List3$ #List3$$                ; 調理ｷｬﾋﾞ選択肢分ﾙｰﾌﾟ
        (setq #CAB    (car  #List3$))          ; 調理ｷｬﾋﾞ品番
        (setq #CAB-LR (cadr #List3$))          ; 調理ｷｬﾋﾞLR区分
        (setq #CAB-kigo (nth #k #kigo$))
  ; *** 複合構成 ***
        (foreach #List4$ #List4$$                  ; 雛形ﾚｺｰﾄﾞ分ﾙｰﾌﾟ(複合構成)
          (setq #huku_ID (atoi (nth 0 #List4$)))   ; 選択肢"A"のID
          (setq #huku_ID (itoa (+ #huku_ID (* #ptn #n))))
          (setq #XXX (nth 2 #List4$)) ; 品番を代入する部分
          (cond
            ((= "調理" #XXX)
              (setq #hinban #CAB)
              (setq #LR #CAB-LR)
            )
            ((= "オーブン" #XXX)
              (setq #hinban #OBN)
              (setq #LR #OBN-LR)
            )
            ((= "コンロ" #XXX)
              (setq #hinban #GAS)
              (setq #LR #GAS-LR)
            )
            (T ; それ以外は触らない
              (setq #hinban (nth 2 #List4$))
              (setq #LR     (nth 3 #List4$))
            )
          );_cond

          ; ﾘｽﾄの品番を入れ替える
          (setq #NewList$
            (CFModList #List4$
              (list
                (list 0 #huku_ID)
                (list 2 #hinban)
                (list 3 #LR)
              )
            )
          )
          (setq #NewList$$ (append #NewList$$ (list #NewList$)))
        );_foreach
        (setq #n (1+ #n)) ; 複合ID用番号
        (setq #k (1+ #k))
      );_foreach
      (setq #j (1+ #j))
    );_foreach
    (setq #i (1+ #i))
  );_foreach

  (princ "\n")(princ (strcat "ﾃﾞｰﾀ出力中...")) ; ﾁｪｯｸﾗｲﾄ

  (setq #fp1 (open #ofname1 "w"))
  (if (= nil #fp1)
    (progn
      (CFAlertErr "出力ﾌｧｲﾙが開けません")
      (quit)
    )
  );_if

  ; ﾌｧｲﾙ出力(csv形式)複合構成
  (##OUTPUT #NewList$$ #fp1)
  (princ "\n*** 出力終了 ***")
  (princ "\n")(princ #ofname1)
  (setq *error* nil)
  (princ)
);C:OBUN


;*****************************************************************************:
; ﾃｷｽﾄﾌｧｲﾙの品番,LRから図形IDを取得して結果をテキスト出力
; 使用file: CG_SYSPATH \log\Hinban.txt
; 06/09/01 YM
;*****************************************************************************:
(defun C:CheckHinbanZukei (
  /
  #FP #HINBAN #IFNAME1 #J #LIST1$$ #LR #OFNAME1 #QRY$$ #ZUKEIID #DOORID
	#DoorID_out #layer_out
  )
  ;// コマンドの初期化
  (StartUndoErr)

  (setq #ifname1 (strcat CG_SYSPATH "LOG\\" "Hinban.txt"))
  (setq #ofname1 (strcat CG_SYSPATH "LOG\\" "HinbanZukei.txt"))

  (setq #fp (open #ofname1 "w"))

  (if (= nil (findfile #ifname1))
    (progn
      (CFAlertErr (strcat #ifname1 " がありません"))
      (quit)
    )
  );_if

  (setq #List1$$ (ReadCSVFile #ifname1));ﾘｽﾄ読み込み

  (princ (strcat "\n品番,LR,図形ID,扉ID,画層") #fp)
  (setq #j 0)
  (foreach #List1$ #List1$$       ; 品番の数ﾙｰﾌﾟ
    (setq #Hinban (car  #List1$)) ; 品番
    (setq #LR     (cadr #List1$)) ; LR区分

    (setq #qry$$
      (CFGetDBSQLRec CG_DBSESSION "品番図形"
        (list
          (list "品番名称" #Hinban 'STR)
          (list "LR区分"   #LR     'STR)
        )
      )
    )
    (if (= #qry$$ nil)
      (setq #ZukeiID "-")
      ;else
      (if (= 1 (length #qry$$))
        (progn
          (setq #ZukeiID (nth 6 (car #qry$$)));2008/06/28 OK!
          (if (or (= nil #ZukeiID)(= "" #ZukeiID))
            (setq #ZukeiID "-")
          );_if
        )
        ;else
        (setq #ZukeiID "★レコードが複数")
      );_if
    );_if

    (setq #qry$$
      (CFGetDBSQLRec CG_DBSESSION "品番シリ"
        (list
          (list "品番名称" #Hinban 'STR)
          (list "LR区分"   #LR     'STR)
        )
      )
    )
    (if (= #qry$$ nil)
      (setq #DoorID "-")
      ;else
      (if (= 1 (length #qry$$))
        (progn
          (setq #DoorID (nth 4 (car #qry$$)));2008/06/28 OK!
          (if (or (= nil #DoorID)(= "" #DoorID))
            (progn
              (setq #DoorID_out "-")
              (setq #layer_out  "-")
            )
            (progn
              (setq #DoorID_out (substr #DoorID 1 5))
              (setq #layer_out  (substr #DoorID 6 2))
            )
          );_if
        )
        ;else
        (setq #DoorID "★レコードが複数")
      );_if
    );_if

    (if (= nil #ZukeiID)(setq #ZukeiID "-"))
    (if (= nil #DoorID_out)(setq #DoorID_out "-"))
    (if (= nil #layer_out)(setq #layer_out "-"))
    (princ (strcat "\n" #Hinban "," #LR "," #ZukeiID "," #DoorID_out "," #layer_out) #fp)
    (setq #j (1+ #j))
  );foreach

  (close #fp)  ;// ﾌｧｲﾙｸﾛｰｽﾞ
  (princ "\n*** 出力終了 ***")
  (startapp "notepad.exe" #ofname1)
  (setq *error* nil)
  (princ)
);C:CheckHinbanZukei


;;;<HOM>*************************************************************************
;;; <関数名>    : GetZumenZukeiID
;;; <処理概要>  : 図面上にある部材の図形IDをﾃｷｽﾄ出力
;;; <戻り値>    : 
;;; <作成>      : 06/06/22 YM ADD
;;; <備考>      : 
;;;*************************************************************************>MOH<
(defun C:GetZumenZukeiID (
  /
  #HIN #I #ID #LR #SS #SYM #XD$
	#SKK
  )
  (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; 図面上のG_LSYM
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (princ (strcat "\nG_LSYMを持つ図形数:" (itoa (sslength #ss))))
      (repeat (sslength #ss)
        (princ "\n--------------------------")
        (setq #sym (ssname #ss #i))
        (setq #xd$ (CFGetXData #sym "G_LSYM"))
        (setq #id  (nth 0 #xd$))
        (setq #hin (nth 5 #xd$))
        (setq #LR  (nth 6 #xd$))
        (setq #SKK (nth 9 #xd$))
        (princ (strcat "\n品番:"   #hin))
        (princ (strcat "\nL/R:"    #LR))
        (princ (strcat "\n図形ID:" #id))
        (princ (strcat "\n性格CODE:" (itoa #SKK)))
        (setq #i (1+ #i))
      );_repeat

    )
  );_if

  (princ "\n--------------------------")

  (princ)
);PKOutputWTCT


;;;<HOM>*************************************************************************
;;; <関数名>     : C:slide
;;; <処理概要>   : [品番図形]を参照してｽﾗｲﾄﾞﾌｧｲﾙの漏れをﾁｪｯｸする
;;;                対象ｼﾘｰｽﾞは、～\system\log\slide_seri.txt
;;; <戻り値>     : なし
;;; <作成>       : 05/12/21 YM
;;; <備考>       : 
;;;*************************************************************************>MOH<
(defun C:slide (
  /
  #CG_SERIESCODE #CG_SERIESDB #CSV$$ #DATE_TIME #DUM$$ #FIL #IFILE #KOSU #MDB
  #N #REC$$ #SERI #SERI$$ #ZUKEIID #ZUKEIID$ #HINBAN #NG-S #NG-Z
  )

    ;;;**********************************************************************
    ;;; ﾘｽﾄの重複レコードを除く
    ;;; 05/06/01 YM
    ;;;**********************************************************************
    (defun ##delREC0 (
      &lis$ ; #hin$のﾘｽﾄ形式
      /
      #DUM$ #HIN #HIN$ #LIS$ #RET$
      )
      (setq #dum$ nil #hin$ nil)
      (foreach #lis &lis$
        (setq #hin #lis)
        (if (member #hin #hin$)
          nil
          ;else
          (setq #dum$ (cons #lis #dum$))
        );_if
        (setq #hin$ (cons #hin #hin$))
      )
      (setq #ret$ #dum$)
      #ret$
    );##delREC0


  (setq #CG_SeriesDB CG_SeriesDB)
  (setq #CG_SeriesCode CG_SeriesCode)

  (setvar "CMDECHO" 0)
  (C:de0)

  (setq #fil (open (strcat CG_SYSPATH "LOG\\SLIDE-CHECK.txt") "W" ))
  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\nｽﾗｲﾄﾞﾌｧｲﾙ,図形ﾌｧｲﾙがないものを抽出" #fil)
  (princ "\n" #fil)

  ;対象ｼﾘｰｽﾞ情報
  (setq #ifile (strcat CG_SYSPATH "LOG\\SLIDE_seri.txt"));ﾁｪｯｸ対象ｼﾘｰｽﾞの読み込み
  (setq #CSV$$ (ReadCSVFile #ifile))
  ;先頭に";"があったら除く
  (setq #dum$$ nil)
  (foreach #CSV$ #CSV$$
    (setq #MDB (nth 0 #CSV$))
    (setq #seri (nth 1 #CSV$))
    (if (= ";" (substr #MDB 1 1))
      nil
      ;else
      (progn
        (setq #dum$$ (append #dum$$ (list (list #MDB #seri))))
      )
    );_if
  );foreach
  (setq #seri$$ #dum$$)


  
  (setq #zukeiID$ nil)
  (foreach #seri$ #seri$$ ; 各ｼﾘｰｽﾞでのloop
    (setq CG_SeriesDB (nth 0 #seri$))
    (setq CG_SeriesCode (nth 1 #seri$))
    (setq CG_DBSESSION (dbconnect CG_SeriesDB  "" ""))
    (princ (strcat "\nｼﾘｰｽﾞ:" CG_SeriesDB))
    ;★[品番図形]★-----------------------------------------------
    (setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "品番図形")))
    (foreach #rec$ #rec$$
      (setq #hinban  (nth 0 #rec$))
      (setq #zukeiID (nth 6 #rec$));2008/06/28 OK!
      (if (or (= #zukeiID nil)(= #zukeiID ""))
        (princ (strcat "\n図形ID未定義: " #hinban "," CG_SeriesDB) #fil)
        ;else
        (progn
          (setq #zukeiID$ (append #zukeiID$ (list #zukeiID)))
        )
      );_if
    )
  );foreach

  ;重複ﾚｺｰﾄﾞを除く
  (setq #zukeiID$ (##delREC0 #zukeiID$))


  (setq #n 0)(setq #kosu (length #zukeiID$))
  (princ (strcat "\nﾁｪｯｸ総数: " (itoa #kosu)) #fil)
  (princ (strcat "\nﾁｪｯｸ総数: " (itoa #kosu)))

  ;ｽﾗｲﾄﾞﾌｧｲﾙの存在ﾁｪｯｸ
  (setq #NG-z 0)
  (setq #NG-s 0)
  (foreach #zukeiID #zukeiID$
    (if (and (/= #n 0)(= 0 (rem #n 100)))
      (princ (strcat "\n" (itoa #n) "/"  (itoa #kosu)))
    );_if

    (if (findfile (strcat CG_SKDATAPATH "MASTER\\" #zukeiID ".dwg"))
      nil
      ;else
      (progn
        (setq #NG-z (1+ #NG-z))
        (princ (strcat "\n図形ﾌｧｲﾙがない: " #zukeiID ".dwg") #fil)
      )
    );_if

    (if (findfile (strcat CG_SKDATAPATH "CRT\\" #zukeiID ".sld"))
      nil
      ;else
      (progn
        (setq #NG-s (1+ #NG-s))
        (princ (strcat "\nｽﾗｲﾄﾞﾌｧｲﾙがない: " #zukeiID ".sld") #fil)
      )
    );_if

    (setq #n (1+ #n))
  );foreach

  (princ (strcat "\n図形NG個数: " (itoa #NG-z)) #fil)
  (princ (strcat "\n図形NG個数: " (itoa #NG-z)))
  (princ (strcat "\nｽﾗｲﾄﾞNG個数: " (itoa #NG-s)) #fil)
  (princ (strcat "\nｽﾗｲﾄﾞNG個数: " (itoa #NG-s)))

  (princ "\n" #fil)
  (princ "\n")

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み

  (princ "\n")
  (princ "\n" #fil)
  (princ "\n★★チェック終了★★")
  (princ "\n★★チェック終了★★" #fil)
  (close #fil)


  ;// 元のデータベースに接続する
  (setq CG_SeriesDB #CG_SeriesDB)
  (setq CG_SeriesCode #CG_SeriesCode)

  (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))

  (startapp "notepad.exe" (strcat CG_SYSPATH "LOG\\SLIDE-CHECK.txt"))
  (princ)
);C:slide


;;;<HOM>*************************************************************************
;;; <関数名>     : C:zokusei_check
;;; <処理概要>   : 属性の品番,金額,商品名のcsvを読んで存在チェック
;;;                CG_SYSPATH \LOG\NCA-ZOKUSEI.csv(NCA部分はmdb名)
;;; <戻り値>     : なし
;;; <作成>       : 06/10/10 YM
;;; <備考>       : 
;;;*************************************************************************>MOH<
(defun C:zokusei_check (
  /
  #CG_SERIESCODE #CG_SERIESDB #DATE_TIME #FIL #HINBAN #HINMEI #IFNAME #LIST$$ #OFNAME
  #REC_BASE$$ #REC_KAI$$ #REC_SERI$$ #YEN
  )

    ;;;**********************************************************************
    ;;; ﾘｽﾄの重複レコードを除く
    ;;; 05/06/01 YM
    ;;;**********************************************************************
    (defun ##delREC0 (
      &lis$ ; #hin$のﾘｽﾄ形式
      /
      #DUM$ #HIN #HIN$ #LIS$ #RET$
      )
      (setq #dum$ nil #hin$ nil)
      (foreach #lis &lis$
        (setq #hin #lis)
        (if (member #hin #hin$)
          nil
          ;else
          (setq #dum$ (cons #lis #dum$))
        );_if
        (setq #hin$ (cons #hin #hin$))
      )
      (setq #ret$ #dum$)
      #ret$
    );##delREC0


  (setq #CG_SeriesDB CG_SeriesDB)
  (setq #CG_SeriesCode CG_SeriesCode)

  (setvar "CMDECHO" 0)
  (C:de0)

  (setq #ifname (strcat CG_SYSPATH "LOG\\" CG_SeriesDB "-ZOKUSEI.csv")); 入力ﾌｧｲﾙ
  (setq #ofname (strcat CG_SYSPATH "LOG\\" CG_SeriesDB "-ZOKUSEI.out")); 出力ﾌｧｲﾙ

  (setq #fil (open #ofname "w"))
  (setq #List$$ (ReadCSVFile #ifname))

  (setq #date_time (menucmd "M=$(edtime,$(getvar,date),YYYY/M/D(DDD) HH:MM:SS)"))  ; 日付
  (princ #date_time #fil) ; 日付書き込み
  (princ "\n*** 属性データ登録ﾁｪｯｸ ***" #fil)
  (princ "\n" #fil)
  (princ (strcat "\nｼﾘｰｽﾞ:" CG_SeriesDB) #fil)
  (princ "\n" #fil)

  (foreach #List$ #List$$
    (setq #hinban (nth 0 #List$))
    (setq #yen    (nth 1 #List$))
    (setq #yen    (atof #yen))
    (setq #hinmei (nth 2 #List$))
    ;階層に存在するか
    (setq #rec_kai$$
      (CFGetDBSQLRec CG_DBSESSION (strcat "階層" CG_SeriesCode)
        (list
          (list "階層名称"  #hinban 'STR)
        )
      )
    )
    (if (= nil #rec_kai$$)
      (princ (strcat "\n★[階層]登録漏れ: " "品番名称=" #hinban) #fil)
    );_if

    ;"商品名"が合ってるか
    (if #rec_kai$$
      (if (= #hinmei (nth 7 (car #rec_kai$$)))
        nil
        ;else
        (progn
          (princ (strcat "\n★[階層]商品名不整合: 品番名称=" #hinban ",登録商品名=" (nth 7 (car #rec_kai$$)) ",属性商品名=" #hinmei) #fil)
        )
      );_if
    );_if

    ;品番基本に存在するか
    (setq #rec_base$$
      (CFGetDBSQLRec CG_DBSESSION "品番基本"
        (list
          (list "品番名称"  #hinban 'STR)
        )
      )
    )
    (if (= nil #rec_base$$)
      (princ (strcat "\n★[品番基本]登録漏れ: " "品番名称=" #hinban) #fil)
    );_if

    ;"金額"が合ってるか
    (if #rec_base$$
      (if (equal #yen (nth 14 (car #rec_base$$)) 0.001);品番基本
        nil
        ;else
        (progn
          ;品番シリに存在するか
          (setq #rec_seri$$
            (CFGetDBSQLRec CG_DBSESSION "品番シリ"
              (list
                (list "品番名称"  #hinban 'STR)
              )
            )
          )

          (if (= nil #rec_seri$$)
            (princ (strcat "\n★[品番シリ]登録漏れ疑い: " "品番名称=" #hinban) #fil)
          );_if

          (if #rec_seri$$
            (if (equal #yen (nth 8 (car #rec_seri$$)) 0.001);品番シリ
              nil
              ;else
              (princ (strcat "\n★金額不整合: 品番名称=" #hinban ",属性金額=" #yen) #fil)
            );_if
          );_if

        )
      );_if
    );_if

  );_foreach

  (princ "\n" #fil)
  (princ "\n")
  (princ "\n★★チェック終了★★")
  (princ "\n★★チェック終了★★" #fil)
  (close #fil)

  (startapp "notepad.exe" #ofname)
  (princ)
);C:zokusei_check


;//////////////////////////////////////////////////////////
; ﾌﾟﾗﾝ検索自動ﾃｽﾄ 07/05/10 YM
; AP対応天板とｼﾝｸの図形だけdwg保存
;//////////////////////////////////////////////////////////
(defun C:AUTO_PLAN_WT_SINK (
  /
  #CASE_LIS #LOOP #NEND #NO #NSTART
  #DWG #EN #HINBAN #RET #SKK #SS #SSMOVE #SSSINK #SSWT #SYM #WT #XD_SYM$ #XD_WTSET$
  )
  (setq CG_TESTMODE 1)    ;ﾃｽﾄﾓｰﾄﾞ
  (setq CG_AUTOMODE 0)    ;自動ﾓｰﾄﾞ
  (setq CG_DEBUG 0)       ;ﾃﾞﾊﾞｯｸﾞﾓｰﾄﾞ

  (princ "\nプラン検索を連続実行します")
  (setq #nStart (getint "\n開始番号を入力(1001～): "))
  (setq #nEnd   (getint "\n終了番号を入力: "))
  (setq #loop (1+ (- #nEnd #nStart)))

  (setq #case_lis '())
  (setq #case_lis (RepeatPlan #nStart #loop #case_lis)) ; 開始番号,繰り返し数

  (foreach #i #case_lis
    (setq CG_TESTCASE #i)
    (setq #no (strcat "case" (itoa #i)))

    (setq CG_KENMEI_PATH (strcat CG_KENMEIDATA_PATH #no "\\")) ; \BUKKEN\case?
    (setq S_FILE (strcat CG_KENMEI_PATH "MODEL.DWG")) ; \BUKKEN\case?\DWGのﾊﾟｽ

    (if (= (getvar "DWGPREFIX") CG_KENMEI_PATH)
      (progn
        (CFAlertMsg (strcat "\n ﾌｫﾙﾀﾞ削除できないため、ﾃｽﾄ対象以外のﾀﾞﾐｰ物件に移動して下さい."
                            "\n(もう一度図面を開き直して下さい)"))
        (quit)
      )
    );_if

    ;// case? フォルダ削除
    (vl-file-delete (strcat CG_KENMEI_PATH "MODEL.DWG"))
    (vl-file-delete (strcat CG_KENMEI_PATH "MODEL.BAK"))

    (setq CG_OpenMode 0)
    (vl-file-copy (strcat CG_SYSPATH "ORGMODEL.DWG") S_FILE)

    (if (/= (getvar "DBMOD") 0)
      (progn
        (command "_qsave")
        (vl-cmdf "._open" S_FILE)
      )
      (progn
        (vl-cmdf "._open" S_FILE)
      )
    );_if

    (S::STARTUP)
    (C:SearchPlan) ; ﾌﾟﾗﾝ検索 開始

    ;07/05/10 YM 天板ｼﾝｸ以外は削除する(ﾌﾟﾗﾝ配置後処理)
    (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
    (setq #i 0)
    (repeat (sslength #ss)
      (setq #sym (ssname #ss #i))
      (setq #xd_SYM$ (CFGetXData #sym "G_LSYM"))
      (setq #skk (nth 9 #xd_SYM$))
      (if (= #skk 410)
        nil ;ｼﾝｸの場合
        (progn
          (command "_erase" (CFGetSameGroupSS #sym) "");部材削除
        )
      );_if
      (setq #i (1+ #i))
    );repeat

    ;画層"Z_00","Z_00_00_00_01" 以外全て削除
    (setq #ss     (ssget "X"))
    (setq #ssWT   (ssget "X" '((8 . "Z_00"))))
    (setq #ssSINK (ssget "X" '((8 . "Z_00_00_00_01"))))

    (setq #i 0)
    (repeat (sslength #ss)
      (setq #en (ssname #ss #i))
      (if (and (= (ssmemb #en #ssWT) nil)
               (= (ssmemb #en #ssSINK) nil))
        (entdel #en)
      );_if
      (setq #i (1+ #i))
    );repeat

    ;不要なｸﾞﾙｰﾌﾟ定義を削除する
    (KP_DelUnusedGroup)
    ;不要画層,寸法ｽﾀｲﾙ,線種ｽﾀｲﾙ,文字ｽﾀｲﾙ削除
    (command "_purge" "A" "*" "N")
    ;天板の移動
    (setq #ssMOVE (ssget "X"))
    (command "_move" #ssMOVE "" "0,0,0" "@0,0,-829") ;移動

    ;ｼｽﾃﾑ変数
    (setvar "SNAPMODE"  0)
    (setvar "GRIDMODE"  0)
    (setvar "ORTHOMODE" 0)
    (setvar "OSMODE"    0)
    (setvar "AUTOSNAP"  0)
    (setvar "GRIPS"     1)
    (setvar "PICKFIRST" 1)
    ;向き変更
    (command "vpoint" "0,0,1")
    (command "_zoom" "e")

    ;人大,L型の場合ｺﾝﾛ側天板を削除する
    (if (and (/= (nth 16 CG_GLOBAL$) "Z")(/= (nth 16 CG_GLOBAL$) "SE"));人大,L型の場合
      (progn
        (setq #ssWT (ssget "C" '(1000 -1000) '(-1000 -1000) (list (list -3 (list "G_WRKT")))))
        (command "_.erase" #ssWT "") ; 削除処理
      )
    );_if

    ;WT品番の名前でdwg保存
    (setq #ssWT   (ssget "X" '((8 . "Z_00"))));再度WTを検索
    (setq #WT (ssname #ssWT 0))
    (setq #xd_WTSET$ (CFGetXData #WT "G_WTSET"))
    (setq #hinban (nth 1 #xd_WTSET$))
    ;ﾌｧｲﾙ名加工
    (setq #hinban (strcat (substr #hinban 1 2) "__" (substr #hinban 5 5) "_" (substr #hinban 11)))
    (setq #dwg (strcat CG_SYSPATH "TMP\\" #hinban ".dwg"))
    (command "_.QSAVE")
    ;ﾌｧｲﾙが存在したら削除する
    (vl-file-delete #dwg)
    ;ﾌｧｲﾙｺﾋﾟｰ
    (setq #ret (vl-file-copy S_FILE #dwg))
    (setq #i (1+ #i))
  );foreach

  ; 保存
  (command "_.QSAVE")

  (setq CG_TESTMODE nil) ;ﾃｽﾄﾓｰﾄﾞ
  (setq CG_AUTOMODE 0)   ;自動ﾓｰﾄﾞ
  (setq *error* nil)
  (princ)
);C:AUTO_PLAN_WT_SINK


;//////////////////////////////////////////////////////////
(defun C:APWT (
  /
  )
  (C:AUTO_PLAN_WT_SINK)
  (princ)
)


;-- 2011/11/08 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <関数名>    : C:KAIHUKU
;;; <処理概要>  : 強制的にAutoCAD上の図面を"Model.dwg"[出力関係メニュー]に
;;;             : 戻す
;;; <作成>      : 11/11/08  A.Satoh
;;;*************************************************************************>MOH<
(defun C:KAIHUKU (
	/
	#sFname
	)

  (if (/= nil CG_KENMEI_PATH)
    (progn
			; レイアウト出力処理が途中中断している場合は、強制的に無効化する
			(setq CG_OpenMode nil)

			; 物件図面名を取得する
			(setq #sFname (strcat CG_KENMEI_PATH "MODEL.dwg"))

			(cond
				((= (strcase (getvar "DWGNAME")) "MODEL.DWG")
					(CFAlertMsg "物件図面が開かれています。回復の必要はありません。")
				)
				(T
		      ; 出力関係メニューに切り替える
    		  (ChgSystemCADMenu "PLOT")

					(if (member CG_AUTOMODE '(1 2 3))
						(progn
							(if (= 0 (getvar "DBMOD"))
								(command "_.Open" #sFName)
								(command "_.Open" "Y" #sFName)
							)
							(setq CG_OpenMode nil)
							(S::STARTUP)
						)
						(SCFCmnFileOpen #sFName 1)
					)
				)
			)
		)
		(CFAlertMsg "物件が呼び出されていません.")
	)

  (princ)

)
;-- 2011/11/08 A.Satoh Add - E

(princ)