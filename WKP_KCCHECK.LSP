;;;(defun PcIsExistPOnLine 
;;;(defun PcSetOpt$G_OPT
;;;(defun PcDelOpt$G_OPT
;;;(defun PcGetEn$CrossArea
;;;(defun PcChkHeightCrossing
;;;(defun PcChkZdirCross
;;;(defun PcChkItemNext
;;;(defun PcChkItemNextInList
;;;(defun PcChk4POver
;;;(defun PcJudgeCrossing
;;;(defun PcInsertItem&SetXData
;;;(defun PcChgH_GSYM
;;;(defun PcPolar
;;;(defun PcGetItem4P$
;;;(defun PcGetNextSimilarItem$

;<HOM>*************************************************************************
; <関数名>    : PcIsExistPOnLine
; <処理概要>  : 一本の線上に重なる点があるかどうかチェック
; <戻り値>    : 受け取ったリスト中に線上の点がみつかれば T なければ nil
; <作成>      : 2000-03-29   MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcIsExistPOnLine (
  &LINE$      ; 二点から成る線リスト
  &P$         ; チェック対象の点リスト
  /
  #Pnt$ #FLG #a1 #a2
  )
  (setq #FLG nil)
  (while (and (not #FLG) (setq #Pnt$ (car &P$)))
    (setq #a1 (angle #Pnt$ (car &LINE$)))
    (setq #a2 (angle #Pnt$ (cadr &LINE$)))
    (setq #FLG
      (cond
        ((equal 0 (distance #Pnt$ (car &LINE$)) 0.1) 'T)
        ((equal 0 (distance #Pnt$ (cadr &LINE$)) 0.1) 'T)
        ((equal #a1 (+ #a2 pi) 0.0001) 'T)
        ((equal #a1 (- #a2 pi) 0.0001) 'T)
        (t nil)
      )
    ); end of setq
    (setq &P$ (cdr &P$))
  ); end of while
  #FLG
); PcIsExistPOnLine

;<HOM>*************************************************************************
; <関数名>    : PcSetOpt$G_OPT
; <処理概要>  : 渡されたリストの内容を"G_OPT"に追加、または新規設置する
; <戻り値>    : なし
; <作成>      : 2000-03-30   MH
; <備考>      : リストの形式が ((品番  数) (品番  数) (品番  数)…)なのに注意
;*************************************************************************>MOH<
(defun PcSetOpt$G_OPT (
   &eEN       ; 設定対象の図形名
   &OPT$      ; 追加(新規?)オプション内容リスト
    /
   #GOP$      ; 既存のオプションリスト;
   #iHIN #OP$ #OPFLG
  )
  (if (setq #GOP$ (CFGetXData &eEN "G_OPT"))
    ;; すでにオプション情報有
    (progn
    ;;; 獲得された現在の"G_OPT"内容#GOP$を変形させる
      (setq #iHIN (+ (car #GOP$) (length &OPT$))) ; 頭の個数値+追加リスト長さ
      (setq #GOP$ (cdr #GOP$))
      (setq #GOP$ (cons #iHIN #GOP$)) ; 頭の個数値書き換え
      (setq #GOP$ (append #GOP$ (apply 'append &OPT$))) ; 今回のデータ付加
      (if (CFSetXData &eEN "G_OPT" #GOP$) ;変形させたリストで"G_OPT"設定
        (setq #OPFLG 'T)
      )
    )
    ;; オプション情報無し = 新規設置
    (progn
      (if (= (tblsearch "APPID" "G_OPT") nil) (regapp "G_OPT"))
      (setq #OP$ (cons (length &OPT$) (apply 'append &OPT$)))
      (if (CFSetXData &eEN "G_OPT" #OP$)
        (setq #OPFLG 'T)
      )
    )
  )
  #OPFLG
);PcSetOpt$G_OPT

;<HOM>*************************************************************************
; <関数名>    : PcDelOpt$G_OPT
; <処理概要>  : G_OPTから指定の品番の項目を抜く
; <戻り値>    : なし
; <作成>      : 2000-07-14   MH
; <備考>      : 抜かせる品番は、リストの形で渡す
;*************************************************************************>MOH<
(defun PcDelOpt$G_OPT (
  &eEN       ; 設定対象の図形名
  &OPT$      ; 削除オプション品番リスト
  /
  #GOP$ #i #newOP$
  )
  ;; すでにオプション情報有ならば実行
  (if (setq #GOP$ (CFGetXData &eEN "G_OPT"))
    (progn
      (setq #GOP$ (cdr #GOP$))
      (setq #i 0)
      (while (car #GOP$)
        (if (member (car #GOP$) &OPT$)
          ; 削除対象OPTだった
          (repeat 2 (setq #GOP$ (cdr #GOP$))); repeat
          ; 削除対象ではなかった
          (progn
            (setq #i (1+ #i))
            (repeat 2
              (setq #newOP$ (append #newOP$ (list (car #GOP$))))
              (setq #GOP$ (cdr #GOP$))
            ); repeat
          ); progn
        ); if
      ); while
      ; オプションリスト整形
      (setq #GOP$ (if (< 0 #i) (cons #i #newOP$) nil))
      ; 整形後のリストをアイテムに設置
      (CFSetXData &eEN "G_OPT" #GOP$)
    ); progn
  ); if
); PcDelOpt$G_OPT

;<HOM>*************************************************************************
; <関数名>    : PcGetEn$CrossArea
; <処理概要>  : 高さに関係なくあるアイテムの指定範囲に重複位置するアイテム名を提出
; <戻り値>    : 図形名のリスト なし= nil
; <作成>      : 00/03/29 MH
; <備考>      : 指定範囲に接する位置の図形も取得するかどうかフラグで判断
;*************************************************************************>MOH<
(defun PcGetEn$CrossArea (
  &eONE       ; チェック元になる図形名
  &iL &iR &iF &iB ; 範囲を指定する左右前後の伸縮値(0で元図形範囲と同値)
  &flgNX      ; このフラグが 'T なら、指定範囲に接する位置の図形も取得
  /
  #xd$ #w #d #h #ang #dSQR$
  #ss #ilen #i #i2
  #eEN #p5 #p6 #p7 #p8
  #pFLG #dCHK$ #RES$
  )
  ;;; 範囲に接する図形を取得しないのなら、範囲全体を1mm縮小する。
  (if (not &flgNX) (progn
    (setq &iL (1- &iL))
    (setq &iR (1- &iR))
    (setq &iF (1- &iF))
    (setq &iB (1- &iB))))
  (setq #dSQR$ (PcGetItem4P$ &eONE &iL &iR &iF &iB))
  ; 図面中の全アイテム取得
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  ; 比較元の図形は取り除く
  (ssdel &eONE #ss)
  (if (not #ss) (setq #ilen 0) (setq #ilen (sslength #ss)))

  ;チェック用リスト(setq #OR$ nil #CH$ nil)
  ; 元矩形と各図形の辺が交わるか、点は範囲内に入るか、をチェック
  (setq #i 0)
  (repeat #ilen
    (setq #eEN (ssname #ss #i))
    ;;; チェックするアイテムの矩形領域４点を求める
    (setq #xd$ (CFGetXData #eEN "G_SYM"))
    (setq #w (nth 3 #xd$))
    (setq #d (nth 4 #xd$))
    (setq #h (nth 5 #xd$))
    (setq #ang (nth 2 (CFGetXData #eEN "G_LSYM")))
    (setq #p5 (cdr (assoc 10 (entget #eEN))))
    ; 高さが違うケースも対象なので、Z値を最初に抜く
    (setq #p5 (list (read (rtos (car #p5) 2 10)) (read (rtos (cadr #p5) 2 10))))
    (setq #p6 (Pcpolar #p5 #ang #w))
    (setq #p7 (Pcpolar #p6 (- #ang (dtr 90)) #d))
    (setq #p8 (Pcpolar #p5 (- #ang (dtr 90)) #d))
    (setq #dCHK$ (list #p5 #p6 #p7 #p8))

    (setq #pFLG nil)
    (setq #i2 0)
    (setq #pFLG (PcJudgeCrossing #dSQR$ #dCHK$))

    (if #pFLG (setq #RES$ (cons #eEN #RES$)))
    (setq #i (1+ #i))
  ); end of repeat
  ; 結果を返す nil か リスト
  (setq #RES$ #RES$)
); PcGetEn$CrossArea

;<HOM>*************************************************************************
; <関数名>    : PcChkHeightCrossing
; <処理概要>  : 二つの図形の高さ方向の干渉確認
; <戻り値>    : 本体同士重複=-1 許容値内で重複=1 接している=0  重ならない=nil
; <作成>      : 00/04/23 MH
; <備考>      : 許容範囲を考慮にいれる
;*************************************************************************>MOH<
(defun PcChkHeightCrossing (
  &eUNDER     ; 下の図形
  &eTOP       ; 上の図形
  &fSPACE     ; 許容される2つの図形間の開き
  /
  #dORG #Z0 #Z1 #Z2
  #XD$ #TEA
  )
  ;;;下の図形の最上面でのZ値 #Z0
  (setq #xd$ (CFGetXData &eUNDER "G_SYM"))
  (setq #dORG (cdr (assoc 10 (entget &eUNDER))))
  (setq #Z0 (caddr #dORG))
  (if (= 1 (nth 10 #xd$)) (setq #Z0 (+ #Z0 (nth 5 #xd$))))
  ;;; 許容値分足す
  (if (numberp &fSPACE) (setq #Z1 (+ #Z0 &fSPACE)))

  ;;; 上の図形の最下面でのZ値 #Z2
  (setq #xd$ (CFGetXData &eTOP "G_SYM"))
  (setq #dORG (cdr (assoc 10 (entget &eTOP))))
  (setq #Z2 (caddr #dORG))
  (if (= -1 (nth 10 #xd$)) (setq #Z2 (- #Z2 (nth 5 #xd$))))

  ;;; 干渉をチェック 結果を返す
  (setq #tea (list #Z0 #Z1 #Z2))
  (cond
    ((= #Z1 #Z2) 0)
    ((and (> #Z0 #Z2) (> #Z1 #Z2)) -1)
    ((> #Z1 #Z2) 1)
    (t nil)
  ); cond
);PcChkHeightCrossing

;<HOM>*************************************************************************
; <関数名>    : PcChkZdirCross
; <処理概要>  : 二つのアイテムの高さ方向の干渉確認
; <戻り値>    : 重複=1 接している=0  重ならない=nil
; <作成>      : 00/05/11 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcChkZdirCross (
  &eONE       ; 図形１
  &eTWO       ; 図形２
  /
  #xd$ #d #Z1 #Z2 #Z3 #Z4
  )
  (setq #xd$ (CFGetXData &eONE "G_SYM"))
  (setq #d (cdr (assoc 10 (entget &eONE))))
  (setq #Z1 (caddr #d))
  (if (= 1 (nth 10 #xd$))
    (setq #Z2 (+ #Z1 (nth 5 #xd$)))
    (setq #Z2 (- #Z1 (nth 5 #xd$)))
  );if
  (setq #xd$ (CFGetXData &eTWO "G_SYM"))
  (setq #d (cdr (assoc 10 (entget &eTWO))))
  (setq #Z3 (caddr #d))
  (if (= 1 (nth 10 #xd$))
    (setq #Z4 (+ #Z3 (nth 5 #xd$)))
    (setq #Z4 (- #Z3 (nth 5 #xd$)))
  );if
  ;;; 干渉をチェック 結果を返す
  (cond
    ((equal (max #Z1 #Z2) (min #Z3 #Z4) 0.1) 0)
    ((equal (min #Z1 #Z2) (max #Z3 #Z4) 0.1) 0)
    ((and (<= #Z1 (max #Z3 #Z4)) (>= #Z1 (min #Z3 #Z4))) 1)
    ((and (<= #Z2 (max #Z3 #Z4)) (>= #Z2 (min #Z3 #Z4))) 1)
    (t nil)
  ); cond
); PcChkZdirCross

;<HOM>*************************************************************************
; <関数名>    : PcChkItemNext
; <処理概要>  : アイテムの前後左右に隣接するアイテムが存在するかチェック
; <戻り値>    : 図形名のリスト なし= nil
; <作成>      : 00/05/11 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcChkItemNext (
  &eONE       ; チェック元になる図形名
  &L &R &F &B ; チェック辺を指定するフラグ（1 か 0 入力）
  /
  #iL #iR #iF #iB #NX$ #NX2$ #RES$
  )
  ; 範囲を指定する左右前後の伸縮値(0で元図形範囲と同値)を出す
  (setq #iL (if (= 1 &L) 0 -1))
  (setq #iR (if (= 1 &R) 0 -1))
  (setq #iF (if (= 1 &F) 0 -1))
  (setq #iB (if (= 1 &B) 0 -1))
  (setq #NX$ (PcGetEn$CrossArea &eONE #iL #iR #iF #iB 'T))
  ; 算出された図形の４点がフラグ１で指定された辺より出た位置にあるかチェック
  (while (car #NX$)
    (if (PcChk4POver &eONE (car #NX$) &L &R &F &B)
      (setq #NX2$ (cons (car #NX$) #NX2$))
    );if
    (setq #NX$ (cdr #NX$))
  ); while
  ; 縦方向の位置関係をチェック
  (setq #RES$ nil)
  (while (car #NX2$)
    (if (= 1 (PcChkZdirCross &eONE (car #NX2$)))
      (setq #RES$ (cons (car #NX2$) #RES$))
    );if
    (setq #NX2$ (cdr #NX2$))
  ); while

  #RES$
); PcChkItemNext

;<HOM>*************************************************************************
; <関数名>    : PcChkItemNextInList
; <処理概要>  : 図形名リスト中にアイテムの前後左右に隣接するアイテムが存在するか？
; <戻り値>    : 図形名のリスト なし= nil
; <作成>      : 00/09/14 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcChkItemNextInList (
  &eONE       ; チェック元になる図形名
  &L &R &F &B ; チェック辺を指定するフラグ（1 か 0 入力）
  &eCHK$      ; チェック対象の図形名リスト
  /
  #iL #iR #iF #iB #NX$ #NX2$ #RES$
  )
  ; 範囲を指定する左右前後の伸縮値(0で元図形範囲と同値)を出す
  (setq #iL (if (= 1 &L) 0 -1))
  (setq #iR (if (= 1 &R) 0 -1))
  (setq #iF (if (= 1 &F) 0 -1))
  (setq #iB (if (= 1 &B) 0 -1))
  (setq #NX$ (PcGetEn$CrossItemArea &eONE #iL #iR #iF #iB 'T &eCHK$))
  ; 算出された図形の４点がフラグ１で指定された辺より出た位置にあるかチェック
  (while (car #NX$)
    (if (PcChk4POver &eONE (car #NX$) &L &R &F &B)
      (setq #NX2$ (cons (car #NX$) #NX2$))
    );if
    (setq #NX$ (cdr #NX$))
  ); while
  ; 縦方向の位置関係をチェック
  (setq #RES$ nil)
  (while (car #NX2$)
    (if (= 1 (PcChkZdirCross &eONE (car #NX2$)))
      (setq #RES$ (cons (car #NX2$) #RES$))
    );if
    (setq #NX2$ (cdr #NX2$))
  ); while

  #RES$
); PcChkItemNextInList

;<HOM>*************************************************************************
; <関数名>    : PcChk4POver
; <処理概要>  : チェック元アイテムの指定辺より外に点があるか？
; <戻り値>    : 点があった= T   なし= nil
; <作成>      : 00/05/15 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcChk4POver (
  &eONE       ; チェック元になる図形名
  &eCHK
  &iL &iR &iF &iB ; チェックさせる辺の指定 1 か 0
  /
  #4P$ #xd$ #w #d #h #ang #p5 #p6 #p7 #p8 #RESflg
  ##JudgeOver
  )
  (defun ##JudgeOver (&JP1 &JP2 &ANG &4P$ / #CHKP #IntP #RES)
    (while (and (not #RES) (setq #CHKP (car &4P$)) )
      (setq #IntP (inters &JP1 &JP2 #CHKP (Pcpolar #CHKP &ANG 100) nil))
      (if (and
            (equal &ANG (angle #IntP #CHKP) 0.001)
            (not (and (equal (car #IntP) (car #CHKP) 0.001)
                      (equal (cadr #IntP) (cadr #CHKP) 0.001)))
          ); and
        (setq #RES 'T)(setq #RES nil)
      ); if
      (setq &4P$ (cdr &4P$))
    ); while
    #RES
  ); JudgeOver

  ; チェックさせる4点を出す
  (setq #4P$ (PcGetItem4P$ &eCHK 0 0 0 0))
  ;;; チェック元アイテムの矩形領域４点を求める
  (setq #xd$ (CFGetXData &eONE "G_SYM"))
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #h (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &eONE "G_LSYM")))
  (setq #p5 (cdr (assoc 10 (entget &eONE))))
  ; 高さが違うケースも対象なので、Z値を最初に抜く
  (setq #p5 (list (read (rtos (car #p5) 2 10)) (read (rtos (cadr #p5) 2 10))))
  (setq #p6 (Pcpolar #p5 #ang #w))
  (setq #p7 (Pcpolar #p6 (- #ang (dtr 90)) #d))
  (setq #p8 (Pcpolar #p5 (- #ang (dtr 90)) #d))
  (setq #RESflg nil)
  ; 左辺チェック
  (if (= 1 &iL)
    (setq #RESflg (##JudgeOver #p5 #p8 (angle #p6 #p5) #4P$)))
  ; 右辺チェック
  (if (and (not #RESflg) (= 1 &iR))
    (setq #RESflg (##JudgeOver #p6 #p7 (angle #p5 #p6) #4P$)))
  ; 後辺チェック
  (if (and (not #RESflg) (= 1 &iB))
    (setq #RESflg (##JudgeOver #p5 #p6 (angle #p8 #p5) #4P$)))
  ; 前辺チェック
  (if (and (not #RESflg) (= 1 &iF))
    (setq #RESflg (##JudgeOver #p8 #p7 (angle #p5 #p8) #4P$)))
  #RESflg
); PcChk4POver

;<HOM>*************************************************************************
; <関数名>    : PcJudgeCrossing
; <処理概要>  : ２つのポリライン同士で交わる部分があるかどうか判断させる
; <戻り値>    : 交わる T  接触なし nil
; <作成>      : 00/03/30 MH 01/02/06 MOD
; <備考>      :
;*************************************************************************>MOH<
(defun PcJudgeCrossing (
  &dA$        ; 矩体の点リストA
  &dB$        ; 矩体の点リストB
  /
  ##getLINE$ #ALINE$ #BLINE$ #i #FLG  #CHKL$ #DA$ #DB$ 

  )
  (defun ##getLINE$ (&dP$ / #i #temp$)
    (setq #temp$ (list (list (last &dP$) (car &dP$))))
    (setq #i 0)
    (repeat (1- (length &dP$))
      (setq #temp$ (append #temp$ (list (list (nth #i &dP$) (nth (1+ #i) &dP$)))))
      (setq #i (1+ #i))
    ) 
    #temp$
  )
  ; チェック用に線リスト作成
  (if (< 1 (length &dA$)) (setq #ALINE$ (##getLINE$ &dA$)))
  (if (< 1 (length &dB$)) (setq #BLINE$ (##getLINE$ &dB$)))
  (setq #FLG nil)
  (while (and (not #FLG) (car #ALINE$))
    (setq #i 0)
    (while (and (not #FLG) (setq #CHKL$ (nth #i #BLINE$)))
      (if (inters (car (car #ALINE$)) (cadr (car #ALINE$)) (car #CHKL$) (cadr #CHKL$) T)
        (setq #FLG 'T)
      )
      (setq #i (1+ #i))
    ); while
    (setq #ALINE$ (cdr #ALINE$))
  ); while
  #FLG
); PcJudgeCrossing

;<HOM>*************************************************************************
; <関数名>    : PcInsertItem&SetXData
; <処理概要>  : 【品番図形】を元にアイテム設置
; <戻り値>    : 設置した図形名。失敗したらnil
; <作成>      : 00-04-03   MH
; <備考>      : 現在まではストレッチ処理不要なので伸縮に対応してない。
;*************************************************************************>MOH<
(defun PcInsertItem&SetXData (
  &Z_QLY$      ; 品番図形クエリ
  &dPNT        ; 挿入基点
  &fANG        ; 挿入角度
  /
  #K_QLY$ #FIG$ #eUNIT #ss #ang #pt
  #SHIN
  )
  (setq #sHIN (car &Z_QLY$))
  ;;; 品番名称から"品番基本"クエリ獲得
  (setq #K_QLY$ (PcGetPartQLY$  "品番基本" #sHIN nil nil))

  ;;; "品番図形"と"品番基本"からSELPARTS.CFG の内容リストと同じ物を作成する
  (setq #FIG$ (PcMakeFig$ByQLY &Z_QLY$ #K_QLY$ 0 0))
  (setq #eUNIT (PcSetItem "SET" nil #FIG$ &dPNT &fANG nil nil))
  #eUNIT
) ; PcInsertItem&SetXData

;<HOM>*************************************************************************
; <関数名>    : PcChgH_GSYM
; <処理概要>  : 拡張データ中のシンボル取付け高さを変更する
; <戻り値>    : 設置した図形名。失敗したらnil
; <作成>      : 2000-04-05   MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcChgH_GSYM(
  &eEN        ; 図形名
  &dPNT       ; 挿入基点
  /
  #xd$
  )
  (setq #xd$ (CFGetXData &eEN "G_SYM"))
  (CFSetXData &eEN "G_SYM"
    (list
      (nth 0 #xd$)    ;シンボル名称
      (nth 1 #xd$)    ;コメント１
      (nth 2 #xd$)    ;コメント２
      (nth 3 #xd$)    ;シンボル基準値Ｗ
      (nth 4 #xd$)    ;シンボル基準値Ｄ
      (nth 5 #xd$)    ;シンボル基準値Ｈ
      (read (rtos (caddr &dPNT) 2 1))    ;シンボル取付け高さ
      (nth 7 #xd$)    ;入力方法
      (nth 8 #xd$)    ;Ｗ方向フラグ
      (nth 9 #xd$)    ;Ｄ方向フラグ
      (nth 10 #xd$)   ;Ｈ方向フラグ
      (nth 11 #xd$)   ;伸縮フラグＷ
      (nth 12 #xd$)   ;伸縮フラグＤ
      (nth 13 #xd$)   ;伸縮フラグＨ
      (nth 14 #xd$)   ;ブレークライン数Ｗ
      (nth 15 #xd$)   ;ブレークライン数Ｄ
      (nth 16 #xd$)   ;ブレークライン数Ｈ
    )
  )
); PcChgH_GSYM

;<HOM>*************************************************************************
; <関数名>    : PcPolar
; <処理概要>  : Polar の基点にXかYゼロの点を使うと結果が狂う問題に対応した関数
; <戻り値>    : 結果の点座標
; <作成>      : 00/03/30 MH
; <備考>      : Polarの代用。作動は同じ
;*************************************************************************>MOH<
(defun PcPolar (
  &dPNT$      ; 点リスト
  &fANG       ; 角度(ラジアン)
  &fDIST      ; 移動距離
  /
  ##PcMinusOne
  #dTENP$ #dRES$  ; 結果の点座標
  )
  (defun ##PcMinusOne (&fX &fY &fZ &plusX &plusY / #fX #fY)
    (setq #fX (+ (read (rtos &fX 2 10)) &plusX))
    (setq #fY (+ (read (rtos &fY 2 10)) &plusY))
    (if &fZ
      (list #fX #fY &fZ)
      (list #fX #fY)
    )
  ); ##PcMinusOne

  ; それぞれ、0の場所に仮に1を足して、結果が出てから1 引く
  (cond
    ; X値,Y値= 0
    ((and (= 0 (car &dPNT$)) (= 0 (cadr &dPNT$)))
      (setq #dTENP$ (list (+ 1.0 (car &dPNT$)) (+ 1.0 (cadr &dPNT$))))
      (if (numberp (caddr &dPNT$))
        (setq #dTENP$ (append #dTENP$ (list (caddr &dPNT$))))
      );if
      (setq #dTENP$ (polar #dTENP$ &fANG &fDIST))
      (setq #dRES$ (##PcMinusOne (car #dTENP$) (cadr #dTENP$) (caddr #dTENP$) -1.0 -1.0))
    )
    ; X値= 0
    ((= 0 (car &dPNT$))
      (setq #dTENP$ (list (1+ (car &dPNT$)) (cadr &dPNT$)))
      (if (numberp (caddr &dPNT$))
        (setq #dTENP$ (append #dTENP$ (list (caddr &dPNT$))))
      );if
      (setq #dTENP$ (polar #dTENP$ &fANG &fDIST))
      (setq #dRES$ (##PcMinusOne (car #dTENP$) (cadr #dTENP$) (caddr #dTENP$) -1.0 0))
    )
    ; Y値= 0
    ((= 0 (cadr &dPNT$))
      (setq #dTENP$ (list (car &dPNT$) (1+ (cadr &dPNT$))))
      (if (numberp (caddr &dPNT$))
        (setq #dTENP$ (append #dTENP$ (list (caddr &dPNT$))))
      );if
      (setq #dTENP$ (polar #dTENP$ &fANG &fDIST))
      (setq #dRES$ (##PcMinusOne (car #dTENP$) (cadr #dTENP$) (caddr #dTENP$) 0 -1.0))
    )
    ; X値もY値も非0
    (t (setq #dRES$ (polar &dPNT$ &fANG &fDIST))
    )
  ); end of cond
  #dRES$
); PcPolar

;<HOM>*************************************************************************
; <関数名>    : PcGetItem4P$
; <処理概要>  : 対象設備の矩形領域４点を求める（２次元点に変換）
; <戻り値>    : ４点のリスト
; <作成>      : 2000-04-27 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcGetItem4P$ (
    &eONE     ;(ENAME)対象設備
    &iL &iR &iF &iB ; 範囲を指定する左右前後の伸縮値(0で元図形範囲と同値)
    /
    #xd$ #ang #w #d #p1 #p2 #p3 #p4
  )
  (setq #xd$ (CFGetXData &eONE "G_SYM"))
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #ang (nth 2 (CFGetXData &eONE "G_LSYM")))

  (setq #p1 (cdr (assoc 10 (entget &eONE))))
  (setq #p2 (Pcpolar #p1 #ang #w))
  (setq #p3 (Pcpolar #p2 (- #ang (dtr 90)) #d))
  (setq #p4 (Pcpolar #p1 (- #ang (dtr 90)) #d))

  (setq #p1 (list (car #p1) (cadr #p1)))
  (setq #p2 (list (car #p2) (cadr #p2)))
  (setq #p3 (list (car #p3) (cadr #p3)))
  (setq #p4 (list (car #p4) (cadr #p4)))
  ;;; 右左前後の伸縮値で、矩形領域４点を移動
  ; 前後
  (setq #p1 (Pcpolar #p1 (+ #ang (dtr 90)) &iB))
  (setq #p2 (Pcpolar #p2 (+ #ang (dtr 90)) &iB))
  (setq #p3 (Pcpolar #p3 (- #ang (dtr 90)) &iF))
  (setq #p4 (Pcpolar #p4 (- #ang (dtr 90)) &iF))
  ; 左右
  (setq #p1 (Pcpolar #p1 (+ #ang (dtr 180)) &iL))
  (setq #p2 (Pcpolar #p2 #ang               &iR))
  (setq #p3 (Pcpolar #p3 #ang               &iR))
  (setq #p4 (Pcpolar #p4 (+ #ang (dtr 180)) &iL))

  ; 結果リストを返す
  (list #p1 #p2 #p3 #p4)
);PcGetItem4P

;<HOM>*************************************************************************
; <関数名>    : PcGetNextSimilarItem$
; <処理概要>  : 指定の方向である条件の隣接図形が途切れるまで次々にリストに追加
; <戻り値>    : LIST
; <作成>      : 00-09-19 MH
; <備考>      :
;*************************************************************************>MOH<;
(defun PcGetNextSimilarItem$ (
  &chkFLG     ; 条件を指示するフラグ
  &sLR        ; 隣接を取得させる方向
  &eCH        ; 基準となる最初のアイテム
  &eNX$       ; 既に取得ずみの隣接アイテムリスト
  &eNTCHK$    ; チェック対象の図形名リスト
  /
  #eCH #exCH #eNX$ #eNEXT$ #FLG
  )
  (setq #eCH &eCH)
  (setq #eNX$ &eNX$)
  (while #eCH
    (setq #eNEXT$
      (cond
        ((= "L" &sLR) (PcChkItemNextInList #eCH 1 0 0 0 &eNTCHK$)) ; 左
        ((= "R" &sLR) (PcChkItemNextInList #eCH 0 1 0 0 &eNTCHK$)) ; 右
        (t nil)
      ); cond
    ); 指定方向隣接図形取得
    ; 隣接の中に確認対象の条件に一致する図形があれば取得。次のチェック元とする
    (setq #exCH #eCH)
    (setq #eCH nil)
    (setq #FLG nil)
    (while (and (not #FLG) (setq #eNCHK$ (car #eNEXT$)))
      (setq #FLG
        (cond
          ((= "B" &chkFLG) (PcChkBuiltIn #eNCHK$))
          ((= "C" &chkFLG)
            (setq #sHIN (nth 5 (CFGetXData #eNCHK$ "G_LSYM")))
            (wcmatch #sHIN "T-###PS*,T-###PFD*")
          )
          ((= "SameAng" &chkFLG)
            (equal (read (angtos (nth 2 (CFGetXData #eNCHK$ "G_LSYM")) 0 3))
                   (read (angtos (nth 2 (CFGetXData #exCH "G_LSYM")) 0 3)) 0.01)
          )
          (t nil)
        ); cond
      ); setq
      (if #FLG (progn
          (setq #eCH #eNCHK$)
          (setq #eNX$ (cons #eNCHK$ #eNX$))
      )); if progn
      (setq #eNEXT$ (cdr #eNEXT$))
    ); while
  ); while
  #eNX$
); PcGetNextSimilarItem$

(princ)
