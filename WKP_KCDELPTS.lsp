;<HOM>*************************************************************************
; <関数名>    : C:DelParts
; <処理概要>  : 設備部材の削除
; <戻り値>    :
; <作成>      : 2000-01-26
; <備考>      :
;*************************************************************************>MOH<
(defun C:DelParts (/
       #PD;00/07/03 SN ADD
       )
  (StartUndoErr);00/07/27 SN MOD
  ;(StartCmnErr);00/07/27 SN MOD
  (CFCmdDefBegin 6);00/09/07 SN ADD
  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM

  (PcDeleteItems '(("G_WRKT" "G_BKGD" "G_FILR")("G_LSYM")));00/07/31 SN MOD
  ;(PcDeleteItems);00/07/31 SN MOD
  ;(SC_DeleteParts nil) 00/05/26 MH 複数消去に更
  (CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  (setvar "pdmode" #PD) ; 06/12 YM
  (princ "\n部材を削除しました。")
  (princ)
);C:DelParts

;<HOM>*************************************************************************
; <関数名>    : C:DelPartsCnt
; <処理概要>  : 設備部材の削除（連続モード）
; <戻り値>    :
; <作成>      : 2000-01-26
; <備考>      :
;*************************************************************************>MOH<
(defun C:DelPartsCnt (/
       #PD;00/07/03 SN ADD
       )
  ;00/07/27 SN MOD 途中でｴﾗｰ終了したらPDMODEが元に戻らない不具合修正

  (StartUndoErr);00/07/27 SN MOD
  ;(StartCmnErr);00/07/27 SN MOD
  ;(CFCmdDefBegin 6);00/09/07 SN ADD
  ; 00/07/27 SN MOD PDMODEの切替は内部で行う
  ;(setq #PD (getvar "pdmode")) ; 06/12 YM
  ;(setvar "pdmode" 34)         ; 06/12 YM

  (SC_DeleteParts T)
  ;(CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  ; 00/07/27 SN MOD PDMODEの切替は内部で行う
  ;(setvar "pdmode" #PD) ; 06/12 YM

  (princ)
);C:DelPartsCnt

;<HOM>*************************************************************************
; <関数名>    : C:DelWkTop
; <処理概要>  : ワークトップの削除
; <戻り値>    :
; <作成>      :
; <備考>      : 00/07/12 C:DelPartsの内容と差し替え
;*************************************************************************>MOH<
(defun C:DelWkTop (/
       #PD;00/07/03 SN ADD
       )
  (StartUndoErr) ;00/07/31 SN MOD
  ;(StartCmnErr) ;00/07/31 SN MOD
  (CFCmdDefBegin 6);00/09/07 SN ADD
  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM

  (PcDeleteItems '(("G_WRKT")));00/07/31 SN MOD
  ;(PcDeleteItems);00/07/31 SN MOD
  ;(SC_DeleteParts nil) 00/05/26 MH 複数消去に変更
  (CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  (setvar "pdmode" #PD) ; 06/12 YM

  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : C:DelFiler
; <処理概要>  : 天井フィラーの削除
; <戻り値>    :
; <作成>      : 2000-01-26
; <備考>      :
;*************************************************************************>MOH<
(defun C:DelFiler (/
       #PD;00/07/03 SN ADD
       )
  ;00/07/27 SN MOD 途中でｴﾗｰ終了したらPDMODEが元に戻らない不具合修正
  
  ;// コマンドの初期化
  (StartUndoErr);00/07/27 SN MOD
  ;(StartCmnErr);00/07/27 SN MOD
  ;(CFCmdDefBegin 6);00/09/07 SN ADD
  
  ; 00/07/27 SN MOD PDMODEの切替は内部で行う
  ;(setq #PD (getvar "pdmode")) ; 06/12 YM
  ;(setvar "pdmode" 34)         ; 06/12 YM

  (SC_DeleteParts nil)
  ;(CFCmdDefFinish);00/09/07 SN ADD
  (setq *error* nil)
  ; 00/07/27 SN MOD PDMODEの切替は内部で行う
  ;(setvar "pdmode" #PD) ; 06/12 YM

  (princ)
)
;C:DelFiler

;<HOM>*************************************************************************
; <関数名>    : PcDeleteItems
; <処理概要>  : 設備部材の削除（LSYM,FILER,WORKTOP) 複数選択可
; <戻り値>    :
; <作成>      : 2000-05-26 MH
; <備考>      : 選択後１アイテムづつ指定除外できる
;*************************************************************************>MOH<
(defun PcDeleteItems (
  &XDataLst$$;00/07/31 SN ADD 削除対象のXDATA名をﾘｽﾄで渡す。
  /
  #ss #GLPss #i #ii #en #WTDEL$ #DEL$ #DL #NEW$ #enR #enREM
  #WT ;00/07/31 SN ADD
  )
  ;(StartUndoErr);// コマンドの初期化 ;00/07/03 SN MOD ｺﾒﾝﾄ処理
  (setq #ss (ItemSel &XDataLst$$ CG_InfoSymCol))

  ; 選択された図形をチェック 削除リストに取得
  (if #ss (progn
    (setq #i 0)
    (while (< #i (sslength #ss))
      (cond
        ((and
          (setq #en (ssname #ss #i))
          ;00/07/31 SN MOD
          (CheckXData #en (nth 0 &XDataLst$$))
          ;(or (CFGetXData #en "G_WRKT")
          ;    (CFGetXData #en "G_BKGD")
          ;    (CFGetXData #en "G_FILR"))
          (not (member #en #WTDEL$))); and
          ; 条件をみたしたものを色替え&リスト化
          ;(GroupInSolidChgCol2 #en CG_InfoSymCol) 00/09/18 SN MOD 色変更は選択関数内で行う
          (setq #WTDEL$ (cons #en #WTDEL$))
          ; この図形名を #ssから除去
          (ssdel #en #ss)
          (setq #i 0) ; #ssの内容が変わったから、 #iリセット
        )
        ((and (setq #en (SearchGroupSym (ssname #ss #i)))
              (not (member #en #DEL$))(CFGetXData #en "G_LSYM");)
          (CheckXData #en (nth 1 &XDataLst$$)))   ;00/07/31 SN MOD
          ; グループ図形色替え&削除リスト追加
          ;(GroupInSolidChgCol2 #en CG_InfoSymCol) 00/09/18 SN MOD 色変更は選択関数内で行う
          (setq #DEL$ (cons #en #DEL$))
          ; このグループ親子図形をすべて#ssから除去
          (setq #GLPss (CFGetSameGroupSS #en))
          (setq #ii 0)
          (while (< #ii (sslength #GLPss))
            (ssdel (ssname #GLPss #ii) #ss)
            (setq #ii (1+ #ii))
          );while
          (setq #i 0) ; #ssの内容が変わったから、 #iリセット
        )
        (t (setq #i (1+ #i)))
      );cond
    ); while
  )); if progn

  ; WT削除リストに残ったWTとフィラー削除実行
  (foreach #DL #WTDEL$
    (cond
      ((CFGetXData #DL "G_FILR") (SCW_DelFiler #DL))
      ((or (CFGetXData #DL "G_WRKT")
           (CFGetXData #DL "G_BKGD"))
        (GroupInSolidChgCol2 #DL "BYLAYER") ; 色を戻す
        (PCW_DelWkTop nil #DL))  ; 07/03 YM MOD
;;;        (PCW_DelWkTop 1 #DL)) ; 07/03 YM MOD
    );cond
  )

  ; 00/06/22 SN S-ADD 削除対象アイテムの色を戻す。
  (foreach #DL #DEL$
    (if (and (CFGetXRecord "BASESYM")                          ; 基準ｱｲﾃﾑが未設定
             (= (cdr (assoc 5 (entget #DL))) (car (CFGetXRecord "BASESYM")))) ; 基準ｱｲﾃﾑが &ss に入っていた
      (GroupInSolidChgCol2 #DL CG_BaseSymCol)
      (GroupInSolidChgCol2 #DL "BYLAYER")
    )
  ); foreach
  ; 00/06/22 SN E-ADD

  ; 削除リストに残ったアイテム削除実行
;;; (command "vpoint" "0,0,1") ;  "LWPOLYLINE"  画層: "Z_wtbase"
  (foreach #DL #DEL$
    (SCY_DelParts #DL nil)
  ); foreach
;;; (command "zoom" "p")
  ; 00/07/10 MH ADD 消去終了後、基準アイテムの実体がなければＸレコードを初期化
  (if (and (CFGetBaseSymXRec) (not (entget (CFGetBaseSymXRec))))
    (CFSetXRecord "BASESYM" nil))

  (setq *error* nil)
  (princ)
)
;PcDeleteItems

;<HOM>*************************************************************************
; <関数名>    : SC_DeleteParts
; <処理概要>  : 設備部材の削除（LSYM,FILER,WORKTOP)
; <戻り値>    :
; <作成>      : 2000-01-26
; <備考>      :
;*************************************************************************>MOH<
(defun SC_DeleteParts (
    &CntFlg
    /
    #en #XD
    #PD ;00/07/27 SN ADD
  #SNAPMODE #GRIDMODE #ORTHOMODE #OSMODE ; 00/09/12 SN ADD
  )

  (CFCmdDefBegin 6);00/09/26 SN ADD

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SC_DeleteParts ////")
  (CFOutStateLog 1 1 " ")

  (setq #PD (getvar "pdmode")); 00/07/27 SN ADD

  ;// ワークトップの指示
  (setq #en T)
  (while #en
    (setvar "pdmode" 34)  ;00/07/27 SN
    (initget "U")
;;;    (setq #en (entsel "\n削除するアイテムを選択/U=戻す/: "))
    (setq #en (entsel "\n削除するアイテムを選択: "))
    (setvar "pdmode" #PD) ;00/07/27 SN 一旦PDMODEを戻す
    (cond
      ((= #en "U")
        (command "_.undo" "b")
      )
      ((= #en nil)
        (princ)
      )
      (T
        (setq #en (car #en))
        (cond
          ((setq #xd (CFGetXData #en "G_WRKT"))
;;;           (if (> (length #xd) 50)
              (PCW_DelWkTop 1 #en)    ; 00/04/07 YM ADD 新型の削除 削除ｺﾏﾝﾄﾞ時ﾌﾗｸﾞ=1
;;;             (SCW_DelWkTop #en)    ; 旧型の削除
;;;           )
          )
          ((setq #xd (CFGetXData #en "G_BKGD")) ; 00/03/18 YM ADD
;;;           (if (< (length #xd) 4)
;;;             (PCW_DelBKGD #en)     ; 00/04/07 YM ADD 新型の削除
              (PCW_DelWkTop 1 #en)    ; 00/04/07 YM ADD 新型の削除 削除ｺﾏﾝﾄﾞ時ﾌﾗｸﾞ=1  ; 04/25 YM
;;;             (SCW_DelBKGD #en)     ; 旧型の削除
;;;           )
          )
;;;          ((CFGetXData #en "G_FRGD") ; 00/04/07 YM ADD
;;;            (PCW_DelFRGD #en)        ; 00/04/07 YM ADD
;;;          )

          ((CFGetXData #en "G_FILR")
            (SCW_DelFiler #en)
          )
          ((CFGetXData #en "G_ROOM")
            (CFYesDialog "選択した図形は間口領域です　")
          )
          ((CFGetXData #en "RECT")
            (CFYesDialog "選択した図形は矢視領域です　")
          )
          (T
            (setq #en (CFSearchGroupSym #en))
            (if #en
              (progn
                (SCY_DelParts #en &CntFlg)
              )
            )
          )
        )
        ;00/09/26 SN S-ADD
        ;ﾕｰｻﾞ変更の可能性があるので一旦取り込む
        (setq #SNAPMODE  (getvar "SNAPMODE" ))
        (setq #GRIDMODE  (getvar "GRIDMODE" ))
        (setq #ORTHOMODE (getvar "ORTHOMODE"))
        (setq #OSMODE    (getvar "OSMODE"   ))
        (CFCmdDefEnd);00/09/26 SN ADD
        (command "_.undo" "m");00/07/27 SN UNDOﾏｰｸ
        (CFCmdDefStart 6);00/09/26 SN ADD
        ;00/09/26 SN ADD ﾕｰｻﾞ変更設定対応
        ;一旦取り込んだものを元に戻す。
        (setvar "SNAPMODE"  #SNAPMODE )
        (setvar "GRIDMODE"  #GRIDMODE )
        (setvar "ORTHOMODE" #ORTHOMODE)
        (setvar "OSMODE"    #OSMODE   )
      )
    )
  )
  ; 00/07/10 MH ADD 消去終了後、基準アイテムの実体がなければＸレコードを初期化
  (if (and (CFGetBaseSymXRec) (not (entget (CFGetBaseSymXRec))))
    (CFSetXRecord "BASESYM" nil))
  (CFCmdDefFinish);00/09/26 SN ADD
)
;DeleteParts

;<HOM>*************************************************************************
; <関数名>    : SCY_DelParts
; <処理概要>  : 設備部材の削除（キャビネットなどG_LSYMを持つ部材）
; <戻り値>    :
; <作成>      : 2000-01-26
; <備考>      :
;*************************************************************************>MOH<
(defun SCY_DelParts (
  &enSym         ;(ENAME)
  &CntFlg        ;(INT)連続モードフラグ
  /
  #DELHAND #DELWTR #DIST #EG$ #EGWTR$ #I #MINDIST #MSG1 #NO #O #SKK #SS #SSWTR #WT
  #DUM$ #EG #HOLE #KOSU #N #SETXD$ #W-XD$ #WT_T
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SCY_DelParts ////")
  (CFOutStateLog 1 1 " ")
  (setq #msg1 "\nシンクのみの削除はできません。\nワークトップを削除してください。")
;;;  (setq #msg2 "ワークトップが品番確定されています。\n水栓は削除できません")

  (if (Setq #eg$ (entget &enSym)) ; 図形が削除されていないか
    (progn
      (setq #skk (nth 9 (CFGetXData &enSym "G_LSYM")))

      (if (= #skk CG_SKK_INT_SUI) ; 水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化
        (progn
          (command "vpoint" "0,0,1")
          (setq #o (cdr (assoc 10 #eg$)))
          (setq #WT (PK_GetWTunderSuisen #o))

          ; 全水栓穴"G_WTR"図形取得
          (setq #ssWTR (ssget "X" '((-3 ("G_WTR")))))
          ; 水栓ｼﾝﾎﾞﾙ位置に一番近いものを取得する
          (setq #i 0 #MINdist 1.0e10)
          (if #ssWTR    ; 01/05/24 HN ADD
            (repeat (sslength #ssWTR)
              (setq #egWTR$ (entget (ssname #ssWTR #i)))
              (setq #dist (distance #o (cdr (assoc 10 #egWTR$)))) ; 水栓穴中心点～水栓ｼﾝﾎﾞﾙ
              (if (<= #dist #MINdist)
                (progn
                  (setq #MINdist #dist)
                  (setq #delWTR (ssname #ssWTR #i)) ; 水栓穴図形
                  (setq #delHAND (cdr (assoc 5 (entget #delWTR)))) ; 水栓穴図形ﾊﾝﾄﾞﾙ
                )
              );_if
              (setq #i (1+ #i))
            )
          ) ;_if 01/05/24 HN ADD

          (if (> 0.1 #MINdist)  ; 01/05/24 HN 水栓穴上以外の水栓対応
            (progn
              (if #WT ; 01/06/28 YM Lipple WTなしで落ちる
                (progn

                  (setq #w-xd$ (CFGetXData #WT "G_WRKT"))
                  ; 品番確定されていたら穴埋め
                  (if (CFGetXData #WT "G_WTSET")
                    (progn
                      (setq #WT_T (nth 10 #w-xd$)) ; WT厚み
                      (setq #eg (entget #delWTR))
                      (setq #eg (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (cdr #eg)) (cdr #eg)))
                      (setq #eg (subst (cons 62 2) (assoc 62 #eg) #eg))
                      (entmake #eg) ; 穴のﾀﾞﾐｰ作成
                      (setq #hole (entlast))
                      ;2008/07/28 YM 2009対応
                      (command "_extrude" #hole "" (- #WT_T) ) ;押し出し
;;;                     (command "_extrude" #hole "" (- #WT_T) "") ;押し出し
                      (command "_union" #WT (entlast) "")        ;和演算
                    )
                  );_if

                  ; 拡張ﾃﾞｰﾀ"G_WRKT"更新(水栓項目削除)
                  (setq #kosu (nth 22 #w-xd$))
                  (setq #i 23 #dum$ nil)
                  ; 現在登録されている水栓穴ﾘｽﾄから削除対象を除いたﾘｽﾄ#dum$を求める
                  (repeat #kosu
                    (if (and (/= (nth #i #w-xd$) "")(entget (nth #i #w-xd$))) ; 無効な図形名でない
                      (if (equal (nth #i #w-xd$) (handent #delHAND)) ; "G_WTR"図形名
                        nil
                        (setq #dum$ (append #dum$ (list (nth #i #w-xd$))))
                      );_if
                    );_if
                    (setq #i (1+ #i))
                  )

                  (setq #kosu (1- #kosu)) ; 穴個数-1
                  (setq #setxd$
                    (list
                      (list 22 #kosu)
                    )
                  )
                  (setq #n 23)
                  (foreach #dum #dum$
                    (setq #setxd$ (append #setxd$ (list (list #n #dum))))
                    (setq #n (1+ #n))
                  )
                  (setq #setxd$ (append #setxd$ (list (list #n ""))))

                  ; 水栓穴"G_WTR"削除
                  (entdel (handent #delHAND))

                  ;// ワークトップ拡張データの更新
                  (CFSetXData #WT "G_WRKT"
                    (CFModList #w-xd$ #setxd$)
                  )
                
                )
              );_if 01/06/28 YM Lipple WTなしで落ちる

            )
          ) ;_if  01/05/24 HN 水栓穴上以外の水栓対応

          (command "zoom" "p")
        )
      );_if

      (if (= #skk CG_SKK_INT_SNK) ; シンク ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
        (progn
          (CFAlertMsg #msg1)
          (setq #NO T)
        )
      );_if

    )
  );_if

  ;(command "_.undo" "m") ;00/07/03 SN MOD ｺﾒﾝﾄ処理

  (if #NO ; T ==> ｼﾝｸまたは水栓、削除しない
    (princ)
    (progn ; nil
      (setq CG_BASESYM (CFGetBaseSymXRec))
      (if (equal &enSym CG_BASESYM)
        (progn
          (ResetBaseSym)
          (CFSetXRecord "BASESYM" nil)
          (setq CG_BASESYM nil)
        )
      )
      (if (= &CntFlg T)
        (progn
          ;// 対象図形周辺の図形を移動
          ; (DeleteSymRelMoveSym &enSym) 00/07/17 MH MOD 移動部分を新関数に統一
          (PcMoveItemAround "DEL" &enSym nil "R"
            (- (nth 3 (CFGetXData (CFSearchGroupSym &enSym) "G_SYM"))) nil)
          (if (/= CG_BASESYM nil)
            (progn
              (ResetBaseSym)
              (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
            )
          )
        )
      )

      (setq #ss (CFGetSameGroupSS &enSym))
      (setq #i 0)
      (repeat (sslength #ss)
        (entdel (ssname #ss #i)) ; ここで削除
        (setq #i (1+ #i))
      )
    )
  );_if

  ;(command "_.erase" #ss "")
);SCY_DelParts

;<HOM>*************************************************************************
; <関数名>    : SCW_DelFiler
; <処理概要>  : 天井フィラーの削除
; <戻り値>    :
; <作成>      : 2000-01-26
; <備考>      :
;*************************************************************************>MOH<
(defun SCW_DelFiler (
  &enFlr         ;(ENAME)フィラー図形名
  /
  #PL #SS
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SCW_DelFiler ////")
  (CFOutStateLog 1 1 " ")

  ;(command "_.undo" "m") ;00/07/03 SN MOD ｺﾒﾝﾄ処理

  (setq #pl (nth 2 (CFGetXData &enFlr "G_FILR")))
  ;(entdel &enFlr)
  (setq #ss (CFGetSameGroupSS &enFlr))
  (if (or (= #ss nil) (= (sslength #ss) 0))
    (entdel &enFlr)
    (command "_.erase" #ss "")
  )
  (entdel #pl)
)
;SCW_DelFiler

;<HOM>*************************************************************************
; <関数名>    : PCW_DelWkTop
; <処理概要>  : ワークトップの削除
; <戻り値>    :
; <作成>      : 2000-01-26
; <備考>      : 修正 YM 00/04/07 新型WT用
;*************************************************************************>MOH<
(defun PCW_DelWkTop (
  &cmd  ; 削除ｺﾏﾝﾄﾞ時=1 削除しますか？のメッセージを表示する 1以外はメッセージなし
  &wtEn ;(ENAME)ﾜｰｸﾄｯﾌﾟ図形(ﾊﾞｯｸｶﾞｰﾄﾞ図形のこともあり)
  /
  #EN$ #GASPEN #I #MSG #ONE #SNKPEN
  #SS$ #SS2 #WTL #WTR #XD$ #XD0$
  #WTEN #XD_BG #XD_WT
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PCW_DelWkTop ////")
  (CFOutStateLog 1 1 " ")

;;; BKGDのとき
  (setq #xd_BG (CFGetXData &wtEn "G_BKGD"))
  (if #xd_BG
    (setq #wtEn (nth 2 #xd_BG)) ; WT図形名
  );_if

;;; WRKTのとき
  (setq #xd_WT (CFGetXData &wtEn "G_WRKT"))
  (if #xd_WT
    (setq #wtEn &wtEn)
  );_if

  ;(if (= &cmd 1);00/07/03 SN MOD ｺﾒﾝﾄ処理
  ;  (command "_.undo" "m") ;00/07/03 SN MOD ｺﾒﾝﾄ処理
  ;);00/07/03 SN MOD ｺﾒﾝﾄ処理
  (setq #xd$ (CFGetXData #wtEn "G_WRKT"))
  (setq #ss$ '())
  (command "vpoint" "0,0,1")  ; 00/04/25 YM

  ;// 色替え確認
  (setq #ss$ (cons (PCW_ChColWTItemSSret #wtEn CG_InfoSymCol) #ss$)) ; ｼﾝｸがあれば一緒に取る 04/25 YM

  ;;; ｶｯﾄ相手左
  (setq #WTL (nth 47 #xd$))          ; 左WT図形ﾊﾝﾄﾞﾙ
  (while (and #WTL (/= #WTL ""))     ; 左にWTがあれば
    (setq #ss$ (cons (PCW_ChColWTItemSSret #WTL CG_InfoSymCol) #ss$)) ; ｼﾝｸがあれば一緒に取る 04/25 YM
    (setq #xd0$ (CFGetXData #WTL "G_WRKT"))
    (setq #WTL (nth 47 #xd0$))       ; 更に左にあるか
    (if (= #WTL "") (setq #WTL nil)) ; なかったら nil
  )

  ;;; ｶｯﾄ相手右
  (setq #WTR (nth 48 #xd$))          ; 左WT図形ﾊﾝﾄﾞﾙ
  (while (and #WTR (/= #WTR ""))     ; 左にWTがあれば
    (setq #ss$ (cons (PCW_ChColWTItemSSret #WTR CG_InfoSymCol) #ss$)) ; ｼﾝｸがあれば一緒に取る 04/25 YM
    (setq #xd0$ (CFGetXData #WTR "G_WRKT"))
    (setq #WTR (nth 48 #xd0$))       ; 更に左にあるか
    (if (= #WTR "") (setq #WTR nil)) ; なかったら nil
  )

  (command "zoom" "p")

  (if (= &cmd 1)
    (progn ; 削除ｺﾏﾝﾄﾞ時
      (if (CFGetXData #wtEn "G_WTSET")
        (setq #msg "このワークトップは既に品番確定されています。\n削除しますか？")
        (setq #msg "本当に削除してもよろしいですか？")
      )
      (if (CFYesNoDialog #msg)
        (progn
          (foreach #ss #ss$
            (command "_.erase" #ss "") ; 削除処理
          )
        )
        (command "_.undo" "b")
      );_if
    )
    (progn ; 削除ｺﾏﾝﾄﾞ時以外
      (foreach #ss #ss$
        (command "_.erase" #ss "")    ; 削除処理
      )
    )
  );_if

(princ)
)
;PCW_DelWkTop

;<HOM>*************************************************************************
; <関数名>    : PCW_ChColWTItemSSret
; <処理概要>  : ﾜｰｸﾄｯﾌﾟを渡して、WT,BG,FG,及びそれらの底面図形+水栓穴の選択ｾｯﾄを返す
;               これらの色変えも行う.(WT領域内にｼﾝｸがあればそれも YM 04/25)
; <戻り値>    : 選択ｾｯﾄ
; <作成>      : 00/04/07 YM ADD
; <備考>      :
;*************************************************************************>MOH<
(defun PCW_ChColWTItemSSret (
  &wtEn  ;(ENAME)WT図形
  &color ; 色替えする色 nil:色替えしない
  /
  #I #SS #XD$ #J #PT$ #PT2$ #SS2 #SS_SYM #SYM #SYM$ #TEI #hole #G_WTR$
;-- 2011/07/29 A.Satoh Add - S
  #cut1 #cut2 #cut3 #cut4 ;#cut
;-- 2011/07/29 A.Satoh Add - E
;-- 2012/10/01 A.Satoh Add - S
  #en
;-- 2012/10/01 A.Satoh Add - E
  )
  (setq #ss (ssadd)) ; 戻り値選択ｾｯﾄ

  (setq #xd$ (CFGetXData &wtEn "G_WRKT"))
  (ssadd &wtEn #ss)
  (command "_.change" &wtEn "" "P" "C" &color "") ; 引数WT
;;;  (command "_.change" &wtEn "" "P" "C" CG_InfoSymCol "") ; 引数WT
  (ssadd (nth 38 #xd$) #ss) ; WT底面

;-- 2012/10/01 A.Satoh Mod - S
	(if (and (nth 59 #xd$) (/= "" (nth 59 #xd$)))
		(progn
			(if (= (type (nth 59 #xd$)) 'ENAME)		; 図形名が設定されている場合
				(ssadd (nth 59 #xd$) #ss) ; WT底面
			)
			(if (= (type (nth 59 #xd$)) 'STR)			; 図形ハンドルが設定されている場合
				(progn
					(setq #en (handent (nth 59 #xd$)))
					(if #en
						(ssadd #en #ss) ; WT底面
					)
				)
			)
		)
	)
;;;  ; 01/07/04 YM ADD [60]外形も加える START
;;;;;;  (if (and (nth 59 #xd$)(/= "" (nth 59 #xd$))(entget (nth 59 #xd$)));2012/09/26 YM MOD
;;;  (if (and (nth 59 #xd$)(/= "" (nth 59 #xd$))(handent (nth 59 #xd$)));2012/09/26 YM MOD
;;;    (ssadd (nth 59 #xd$) #ss) ; WT底面
;;;  );_if
;;;  ; 01/07/04 YM ADD [60]外形も加える END
;-- 2012/10/01 A.Satoh Mod - E

  (setq #tei (nth 38 #xd$))          ; WT底面図形ﾊﾝﾄﾞﾙ
  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
  (setq #pt2$ (append #pt$ (list (car #pt$)))) ; 終点の次に始点を追加して領域を囲う

  ;// 領域に含まれる、シンク,水栓を検索する
  (setq #sym$ (PKGetSinkSuisenSymCP #pt2$))
  (foreach #sym #sym$
    (if (= (nth 9 (CFGetXData #sym "G_LSYM")) CG_SKK_INT_SNK)   ; ｼﾝｸｼﾝﾎﾞﾙ図形 ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
      (progn
        (setq #hole (nth 3 (CFGetXData #sym "G_SINK")))
				(if (= (type #hole) 'STR)
					nil ;図形が壊れている何もしない
					;else
					(progn
		        ; 02/05/21 YM MOD-S
		        (if (and #hole (/= #hole ""))
		          (ssadd #hole #ss)
							;else
							nil ;図形が壊れている何もしない
		        );_if ; ｼﾝｸ穴領域も追加
		        ; 02/05/21 YM MOD-E
					)
				);_if

;;;02/05/21YM@DEL        (if (/= #hole "")(ssadd #hole #ss)) ; ｼﾝｸ穴領域も追加
      )
    );_if

    (setq #ss2 (CFGetSameGroupSS #sym))
    (command "_.change" #ss2 "" "P" "C" &color "")
    (setq #j 0)
    (repeat (sslength #ss2)
      (ssadd (ssname #ss2 #j) #ss)
      (setq #j (1+ #j))
    )
  )
;;; 領域に含まれる水栓穴"G_WTR"ﾘｽﾄ 07/22 YM ADD
  (setq #G_WTR$ (PKGetG_WTRCP #pt2$)) 
  (foreach #G_WTR #G_WTR$
    (ssadd #G_WTR #ss)
  )

;-- 2011/09/05 A.Satoh Mod - S
;;-- 2011/07/29 A.Satoh Add - S
;  ; カットライン図形を選択セットに追加する
;  (setq #cut (nth 35 #xd$))
;  ;2011/08/02 YM ADD I型のとき削除==>天板ｸﾘｯｸで落ちる #cut = "旧ｶｯﾄ相手ﾊﾝﾄﾞﾙ" が原因
;  (if (and #cut (/= #cut "")(/= #cut "旧ｶｯﾄ相手ﾊﾝﾄﾞﾙ") (entget (handent #cut)))
;    (progn
;      (command "_.CHANGE" (handent #cut) "" "P" "C" &color "")
;      (ssadd (handent #cut) #ss)
;    )
;  )
;;-- 2011/08/31 A.Satoh Add - S
;  (setq #cut2 (nth 36 #xd$))
;  (if (and #cut2 (/= #cut2 "") (handent #cut2) (entget (handent #cut2)))
;    (progn
;      (command "_.CHANGE" (handent #cut2) "" "P" "C" &color "")
;      (ssadd (handent #cut2) #ss)
;    )
;  )
;;-- 2011/08/31 A.Satoh Add - E
;;-- 2011/07/29 A.Satoh Add - E
  (setq #cut1 (nth 60 #xd$))
  (if (and #cut1 (/= #cut1 "") (handent #cut1) (entget (handent #cut1)))
    (progn
      (command "_.CHANGE" (handent #cut1) "" "P" "C" &color "")
      (ssadd (handent #cut1) #ss)
    )
  )
  (setq #cut2 (nth 61 #xd$))
  (if (and #cut2 (/= #cut2 "") (handent #cut2) (entget (handent #cut2)))
    (progn
      (command "_.CHANGE" (handent #cut2) "" "P" "C" &color "")
      (ssadd (handent #cut2) #ss)
    )
  )
  (setq #cut3 (nth 62 #xd$))
  (if (and #cut3 (/= #cut3 "") (handent #cut3) (entget (handent #cut3)))
    (progn
      (command "_.CHANGE" (handent #cut3) "" "P" "C" &color "")
      (ssadd (handent #cut3) #ss)
    )
  )
  (setq #cut4 (nth 63 #xd$))
  (if (and #cut4 (/= #cut4 "") (handent #cut4) (entget (handent #cut4)))
    (progn
      (command "_.CHANGE" (handent #cut4) "" "P" "C" &color "")
      (ssadd (handent #cut4) #ss)
    )
  )
;-- 2011/09/05 A.Satoh Mod - S

;;; BG1 ;;;
  (if (/= (nth 49 #xd$) "")
    (progn
      (ssadd (nth 49 #xd$) #ss) ; BG SOLID1 or 底面図形ﾊﾝﾄﾞﾙ1

      (if (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID")
        (progn ; SOLIDだったら
          (command "_.change" (nth 49 #xd$) "" "P" "C" &color "")
          (ssadd (nth  1 (CFGetXData (nth 49 #xd$) "G_BKGD")) #ss) ; BG底面1も加える
        )
      );_if
    )
  );_if

;;; BG2 ;;;
  (if (/= (nth 50 #xd$) "")
    (progn
      (ssadd (nth 50 #xd$) #ss) ; BG SOLID2 or 底面図形ﾊﾝﾄﾞﾙ2

      (if (= (cdr (assoc 0 (entget (nth 50 #xd$)))) "3DSOLID")
        (progn ; SOLIDだったら
          (command "_.change" (nth 50 #xd$) "" "P" "C" &color "")
          (ssadd (nth  1 (CFGetXData (nth 50 #xd$) "G_BKGD")) #ss) ; BG底面2も加える
        )
      );_if
    )
  );_if

;;; FG1 ;;;
  (if (/= (nth 51 #xd$) "")
    (ssadd (nth 51 #xd$) #ss) ; FG1 底面図形ﾊﾝﾄﾞﾙ
  );_if

;;; FG2 ;;;
  (if (/= (nth 52 #xd$) "")
    (ssadd (nth 52 #xd$) #ss) ; FG2 底面図形ﾊﾝﾄﾞﾙ
  );_if

;;;  ;// 水栓穴  上で処理をした
  (setq #i 23)
  (repeat (nth 22 #xd$)
    (if (nth #i #xd$) ; 07/14 YM 水栓がないときに備えて
      (if (entget (nth #i #xd$))
        (ssadd (nth #i #xd$) #ss)
      );_if
    );_if
    (setq #i (1+ #i))
  )
  #ss
);PCW_ChColWTItemSSret

;<HOM>*************************************************************************
; <関数名>    : PCW_WTItemSSret
; <処理概要>  : ﾜｰｸﾄｯﾌﾟを渡して、カット相手左右のWT,BG,FG,選択ｾｯﾄを返す
; <戻り値>    : 選択ｾｯﾄ
; <作成>      : 00/04/07 YM ADD
; <備考>      :
;*************************************************************************>MOH<
(defun PCW_WTItemSSret (
  &wten  ;(ENAME)WT図形
  /
  #I #SS #XD$ #WTL #WTR #XD0$
  )
  (setq #ss (ssadd)) ; 戻り値選択ｾｯﾄ
  (setq #xd$ (CFGetXData &wtEn "G_WRKT"))
  (ssadd &wtEn #ss)
  (if (/= (nth 49 #xd$) "")
    (ssadd (nth 49 #xd$) #ss) ; BG SOLID図形ﾊﾝﾄﾞﾙ1
  )
  (if (/= (nth 50 #xd$) "")
    (ssadd (nth 50 #xd$) #ss) ; BG SOLID図形ﾊﾝﾄﾞﾙ2
  )
  (if (/= (nth 51 #xd$) "")
    (ssadd (nth 51 #xd$) #ss) ; FG SOLID図形ﾊﾝﾄﾞﾙ
  )
  ;;; ｶｯﾄ相手左
  (setq #WTL (nth 47 #xd$)) ; 左WT図形ﾊﾝﾄﾞﾙ
  (while (and #WTL (/= #WTL "")) ; 左にWTがあれば
    (setq #xd0$ (CFGetXData #WTL "G_WRKT"))
    (if (/= (nth 49 #xd$) "")
      (ssadd (nth 49 #xd$) #ss) ; BG SOLID図形ﾊﾝﾄﾞﾙ1
    )
    (if (/= (nth 50 #xd$) "")
      (ssadd (nth 50 #xd$) #ss) ; BG SOLID図形ﾊﾝﾄﾞﾙ2
    )
    (if (/= (nth 51 #xd$) "")
      (ssadd (nth 51 #xd$) #ss) ; FG SOLID図形ﾊﾝﾄﾞﾙ
    )
    (setq #WTL (nth 47 #xd0$)) ; 更に左にあるか
    (if (= #WTL "") (setq #WTL nil)) ; なかったら nil
  )
  ;;; ｶｯﾄ相手右
  (setq #WTR (nth 48 #xd$)) ; 左WT図形ﾊﾝﾄﾞﾙ
  (while (and #WTR (/= #WTR "")) ; 左にWTがあれば
    (setq #xd0$ (CFGetXData #WTR "G_WRKT"))
    (if (/= (nth 49 #xd$) "")
      (ssadd (nth 49 #xd$) #ss) ; BG SOLID図形ﾊﾝﾄﾞﾙ1
    )
    (if (/= (nth 50 #xd$) "")
      (ssadd (nth 50 #xd$) #ss) ; BG SOLID図形ﾊﾝﾄﾞﾙ2
    )
    (if (/= (nth 51 #xd$) "")
      (ssadd (nth 51 #xd$) #ss) ; FG SOLID図形ﾊﾝﾄﾞﾙ
    )
    (setq #WTR (nth 48 #xd0$)) ; 更に左にあるか
    (if (= #WTR "") (setq #WTR nil)) ; なかったら nil
  )
  #ss
);PCW_WTItemSSret

;<HOM>*************************************************************************
; <関数名>    : PCW_DelBKGD
; <処理概要>  : ﾜｰｸﾄｯﾌﾟの削除でﾊﾞｯｸｶﾞｰﾄﾞをｸﾘｯｸしたときﾜｰｸﾄｯﾌﾟも削除したいので関連WT図形名を
;               PCW_DelWkTop に引き渡す
; <戻り値>    :
; <作成>      : 00/03/18 YM ADD
; <備考>      :
;*************************************************************************>MOH<
(defun PCW_DelBKGD (
    &BGen         ;(ENAME)BKGD図形
    /
    #HAND_WT #XD_BG
  )

  (setq #xd_BG (CFGetXData &BGen "G_BKGD"))
  (if #xd_BG
    (progn
      (setq #hand_WT (nth 2 #xd_BG)) ; WT図形名
      (PCW_DelWkTop 1 #hand_WT) ; 削除ｺﾏﾝﾄﾞ時ﾌﾗｸﾞ=1
    )
    (progn
      (CFAlertMsg "拡張データ G_BKGD がありません。")
      (quit)
    )
  );_if

)
;PCW_DelBKGD

;;; 以下01/01/12 YM COPY
;*************************************************************************>MOH<
;ItemSel専用ｴﾗｰ関数
;grread関数はESCで抜けた時に｢*ｷｬﾝｾﾙ*｣のﾒｯｾｰｼﾞを出力しないので、
;元々の*error*処理の前に｢*ｷｬﾝｾﾙ*｣を出力する関数。
;*************************************************************************>MOH<
(defun cancel*error*( &msg )
  (princ "*ｷｬﾝｾﾙ*");ｷｬﾝｾﾙのﾒｯｾｰｼﾞを出力
  (org*error* "")  ;元々の*error*の処理を行う
)

;<HOM>*************************************************************************
; <関数名>    : ItemSel
; <処理概要>  : ｱｲﾃﾑ選択関数
;               指定点下にｱｲﾃﾑがある場合はｱｲﾃﾑ選択
;               指定点下にｱｲﾃﾑがない場合
;               　左から右窓：範囲内に全て入っているｱｲﾃﾑを選択
;               　右から左窓：範囲内に一部でも入っているｱｲﾃﾑを選択
; <引数>      : &XDataLst$$ 選択対象ｱｲﾃﾑのXDATA群
;               (("G_WRKT" "G_FILR")("G_LSYM")) nth 1はｸﾞﾙｰﾌﾟ処理用
;               &iCol 選択ｱｲﾃﾑ表示色
; <戻り値>    : 選択ｾｯﾄ
; <作成>      : 00/09/06 SN ADD
; <備考>      :
;             :
;*************************************************************************>MOH<
(defun ItemSel( &XDataLst$$ &iCol
  /
  #enp #pp1 #pp2 #en
  #ssRet #ss #sswork
  #gmsg #i #ii #setflag
  #engrp #ssgrp
  #xd$ #ENR
  )

  ;*********************************************
  ; 繰り返しｱｲﾃﾑの選択
  ;*********************************************
  (setq #ssRet (ssadd))
  (setq #pp1 T)
  (while #pp1
    ;---------------------------------------------
    ; ｱｲﾃﾑ一回選択の処理
    ;---------------------------------------------
    (setq org*error* *error*)   ;ItemSel特殊処理 元々の*error*関数を記憶
    (setq *error* cancel*error*);ItemSel特殊処理 *error*関数にItemSel用の関数を被せる
    (setq #enp (entselpoint "\nアイテムを選択:"))
    (setq *error* org*error*)   ;ItemSel特殊処理 元々の*error*関数に戻す
    (setq #pp1 (cadr #enp))
    ;左ﾎﾞﾀﾝ押下
    (if #pp1 (progn
      (setq #en #enp)
      ;選択点にｵﾌﾞｼﾞｪｸﾄあり
      (if (car #en)
        (progn;then
          ;選択ｵﾌﾞｼﾞｪｸﾄを選択ｾｯﾄに加算
          (setq #ss (ssadd))
          (ssadd (car #en) #ss)
        );end progn
        (progn;else
          ;窓指定処理
          (setq #pp2 nil)
          (setq #gmsg " もう一方のｺｰﾅｰを指定:")
          (while (not #pp2);ｺｰﾅｰが選択されるまでﾙｰﾌﾟ
            (setq #pp2 (getcorner #pp1 #gmsg))
            (if #pp2
              ;左ﾎﾞﾀﾝ押下
              (progn
                (if (< (car (trans #pp1 0 2)) (car (trans #pp2 0 2)))
                  ;左→右選択
                  (progn;then
                    (setq #sswork (ssget "W" #pp1 #pp2))
                    (setq #ss (ItemSurplus #sswork &XDataLst$$))
                    (setq #sswork  nil)
                  );end progn
                  ;右→左
                  (progn;else
                    (setq #ss (ssget "C" #pp1 #pp2))
                  );end progn
                );end if
              );end progn
              ;右ﾎﾞﾀﾝ押下
              (progn
                (princ "\n窓の指定が無効です.")
                (setq #gmsg "\nアイテムを選択: もう一方のｺｰﾅｰを指定:")
              )
            );end if
          );end while
        );end progn
      );end if
    ));end if - progn
    ;---------------------------------------------
    ;選択アイテムの色を変える
    ;---------------------------------------------
    (if #ss (progn
      (setq #ssGrp (ChangeItemColor #ss &XDataLst$$ &iCol))
      ;色を変えたｱｲﾃﾑを戻り値選択ｾｯﾄへ加算
      (setq #i 0)
      (repeat (sslength #ssGrp)
        (ssadd (ssname #ssGrp #i) #ssRet)
        (setq #i (1+ #i))
      )
      ;選択ｾｯﾄあり且つ色変更したアイテムが無い場合、選択不可のアイテムとみなす。
      (if (and (> (sslength #ss) 0) (<= (sslength #ssGrp) 0))
        (CFAlertErr "このアイテムは選択できません。")
      )
      (setq #ss nil)
      (setq #ssGrp nil)
    ));end if - progn
  );end while

  ;*********************************************
  ; 対象除去ｱｲﾃﾑ選択
  ;*********************************************
  (setq #enR 'T)
  ;右ﾎﾞﾀﾝ押下or戻り値選択ｾｯﾄがなくなったら終了
  (while (and #enR (> (sslength #ssRet) 0))
    (setq #enR (car (entsel "\n対象から除くアイテムを選択:")))
    ;戻り値選択ｾｯﾄのﾒﾝﾊﾞｰのみ処理する。
    (if (and #enR (ssmemb #enR #ssRet))(progn
      ;一時的に選択ｾｯﾄを作成
      (setq #sswork (ssadd))
      (ssadd #enR #sswork)
      ;選択ｱｲﾃﾑの色を戻す
      (setq #ssGrp (ChangeItemColor #sswork &XDataLst$$ nil))
      ;色を戻したｱｲﾃﾑを戻り値選択ｾｯﾄから除去
      (setq #i 0)
      (repeat (sslength #ssGrp)
        (ssdel (ssname #ssGrp #i) #ssRet)
        (setq #i (1+ #i))
      )
      (setq #sswork nil)
      (setq #ssGrp nil)
    ));end if - progn
  ); while

  #ssRet
);ItemSel

;<HOM>*************************************************************************
; <関数名>    : ItemSurplus
; <処理概要>  : ｱｲﾃﾑ選択関数
;             : 選択ｾｯﾄ内の一塊のｱｲﾃﾑを検索し
;             : 可視状態ｵﾌﾞｼﾞｪｸﾄが全て選択されているｱｲﾃﾑだけの選択ｾｯﾄを作成する。
; <戻り値>    :
; <作成>      : 00/09/06 SN ADD
; <備考>      : 
;*************************************************************************>MOH<
(defun ItemSurplus( &ss &XDataLst$$
  /
  #ssGrp #ssRet #ssErr #ssWork
  #membFlag #wFlag
  #i #i2
  #en #engrp
  #layerdata #layername$
  )

  ;現在使用中の画層一覧を取得
  ;ﾌﾘｰｽﾞor非表示状態の画層は省く
  (setq #layername$ '())
  (setq #layerdata (tblnext "LAYER" T))
  (while #layerdata
    (if (and (=  (cdr (assoc 70 #layerdata)) 0) ;画層がﾌﾘｰｽﾞではなく
             (>= (cdr (assoc 62 #layerdata)) 0));非表示でもない
      (setq #layername$ (append #layername$ (list (cdr (assoc 2 #layerdata)))))
    )
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
;;;01/04/09YM@                (setq #membFlag nil)               ;選択ｾｯﾄに含まれないｵﾌﾞｼﾞｪｸﾄあり
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

;<HOM>*************************************************************************
; <関数名>    : ChangeItemColor
; <処理概要>  : 選択ｾｯﾄに含まれるｱｲﾃﾑの色を変える
;             : 選択ｾｯﾄに一部でも含まれているとそのｸﾞﾙｰﾌﾟを探しだす。
;             : 
; <戻り値>    : 色を変えた全てのｵﾌﾞｼﾞｪｸﾄを含む選択ｾｯﾄ
;             : 
; <作成>      : 00/09/22 SN ADD
; <備考>      : &iCol=nilで なにも選択していない状態に戻す。
;*************************************************************************>MOH<
(defun ChangeItemColor( &ss &XDataLst$$ &iCol
  /
  #i #ii #iii
  #enR
  #ssRet #ssGrp #sswork
  #en #engrp
  #xd$ #wtxd$
;-- 2011/06/13 A.Satoh Add - S
  #skk
;-- 2011/06/13 A.Satoh Add - E
  )

	;2017/08/25 YM ADD ﾌﾚｰﾑｷｯﾁﾝのときは水栓性格ｺｰﾄﾞを一時的に変更する(ｸﾞﾛｰﾊﾞﾙ変数は変えない)
	(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
		(progn
			(setq #CG_SKK_INT_SUI 5555) ;ﾌﾚｰﾑｷｯﾁﾝの場合の場合5555ありえない値
		)
		(progn
			(setq #CG_SKK_INT_SUI CG_SKK_INT_SUI) ;ｽｲｰｼﾞｨの場合510
		)
	);_if

  (setq #i 0)
  (setq #ssRet (ssadd))
  (setq CG_BASESYM (CFGetBaseSymXRec))
  (repeat (sslength &ss)
    (setq #enR (ssname &ss #i))
    (if (not (ssmemb #enR #ssRet))
      (cond
        ;ｸﾞﾙｰﾌﾟｱｲﾃﾑの処理
        ((and (setq #engrp (SearchGroupSym #enR))
              (setq #ssGrp (CFGetSameGroupSS #engrp))
              (CheckXData #engrp (nth 1 &XDataLst$$)))
;-- 2011/06/13 A.Satoh Mod - S
          (setq #skk (nth 9 (CFGetXData #engrp "G_LSYM")))
          (if (and (/= #skk #CG_SKK_INT_SUI) ;2017/08/25 YM MOD CG_SKK_INT_SUI==>#CG_SKK_INT_SUI
                   (/= #skk  CG_SKK_INT_SNK))
            (progn
              ;色
              (if &iCol;色変更指示
                (GroupInSolidChgCol2 #engrp &iCol)
                (if (equal CG_BASESYM #engrp);基準ｱｲﾃﾑ
                  (GroupInSolidChgCol #engrp CG_BaseSymCol)
                  (GroupInSolidChgCol2 #engrp "BYLAYER")
                )
              )
              ;戻り値選択ｾｯﾄに加算
              (setq #ii 0)
              (repeat (sslength #ssGrp)
                (ssadd (ssname #ssGrp #ii) #ssRet)
                (setq #ii (1+ #ii))
              );end repeat
              (setq #ssGrp nil)
            )
          )
;          ;色
;          (if &iCol;色変更指示
;            (GroupInSolidChgCol2 #engrp &iCol)
;            (if (equal CG_BASESYM #engrp);基準ｱｲﾃﾑ
;              (GroupInSolidChgCol #engrp CG_BaseSymCol)
;              (GroupInSolidChgCol2 #engrp "BYLAYER")
;            )
;          )
;          ;戻り値選択ｾｯﾄに加算
;          (setq #ii 0)
;          (repeat (sslength #ssGrp)
;            (ssadd (ssname #ssGrp #ii) #ssRet)
;            (setq #ii (1+ #ii))
;          );end repeat
;          (setq #ssGrp nil)
;-- 2011/06/13 A.Satoh Mod - E
        )
        ;ﾜｰｸﾄｯﾌﾟ･ﾌｨﾗｰなどｸﾞﾙｰﾌﾟ以外のｱｲﾃﾑ
        ((CheckXData #enR (nth 0 &XDataLst$$))
          (cond
            ;ﾜｰｸﾄｯﾌﾟ
            ((setq #wtxd$ (CFGetXData #enR "G_WRKT"))
              ;ﾜｰｸﾄｯﾌﾟ関連ｱｲﾃﾑを取得
              (command "vpoint" "0,0,1")                             ;上から見ないとｼﾝｸ、水栓などすべてとれない
              (if &iCol;色変更指示
                (setq #sswork (PCW_ChColWTItemSSret #enR &iCol))     ;ﾜｰｸﾄｯﾌﾟ関連も同時選択
                (setq #sswork (PCW_ChColWTItemSSret #enR "BYLAYER")) ;ﾜｰｸﾄｯﾌﾟ関連も同時選択
              )
              (command "zoom" "p")                                   ;視点を戻す
              (if (and (not &iCol) (CFGetXData #enR "G_WTSET"))(progn;品番確定ﾜｰｸﾄｯﾌﾟ
                (GroupInSolidChgCol2 #enR CG_WorkTopCol)             ;品番確定ﾜｰｸﾄｯﾌﾟ色
                (if (/= (setq #en (nth 49 #wtxd$)) "")(progn         ;BGあり
                  (GroupInSolidChgCol2 #en CG_WorkTopCol)            ;品番確定ﾜｰｸﾄｯﾌﾟ色
                  (ssadd #en #ssRet)                                 ;BGを戻り値選択ｾｯﾄに加算
                ));end if - progn
                (if (/= (setq #en (nth 50 #wtxd$)) "")(progn         ;FGあり
                  (GroupInSolidChgCol2 #en CG_WorkTopCol)            ;品番確定ﾜｰｸﾄｯﾌﾟ色
                  (ssadd #en #ssRet)                                 ;FGを戻り値選択ｾｯﾄに加算
                ));end if - progn
              ));end if - progn
              (ssadd #enR #ssRet)                                    ;ﾜｰｸﾄｯﾌﾟを戻り値選択ｾｯﾄに加算
              ;ﾜｰｸﾄｯﾌﾟ関連を戻り値選択ｾｯﾄに加算
              (setq #ii 0)
              (repeat (sslength #sswork)
                (setq #en (ssname #sswork #ii))
                (if (not (ssmemb #en #ssRet))                        ;ﾒﾝﾊﾞｰ以外のもののみ対象にする。
                  (cond
                    ;ｸﾞﾙｰﾌﾟｱｲﾃﾑ ｼﾝｸなど
                    ((and (setq #engrp (SearchGroupSym #en))
                          (setq #ssGrp (CFGetSameGroupSS #engrp))
                          (CheckXData #engrp (nth 1 &XDataLst$$)))
                      (if (and (not &iCol) (equal CG_BASESYM #engrp));基準ｱｲﾃﾑなら色変更
                        (GroupInSolidChgCol #engrp CG_BaseSymCol)
                      )
                      ;戻り値選択ｾｯﾄに加算
                      (setq #iii 0)
                      (repeat (sslength #ssGrp)
                        (ssadd (ssname #ssGrp #iii) #ssRet)
                        (setq #iii (1+ #iii))
                      );end repeat
                      (setq #ssGrp nil)
                    )
                    (T; ﾊﾞｯｸｶﾞｰﾄﾞなど
                      ;ｸﾞﾙｰﾌﾟｱｲﾃﾑでなければそのまま色変更
                      (if (and (not &iCol) (equal CG_BASESYM #en));基準ｱｲﾃﾑなら色変更
                        (GroupInSolidChgCol #en CG_BaseSymCol)
                      )
                      (ssadd (ssname #sswork #ii) #ssRet)         ;戻り値選択ｾｯﾄに加算
                    )
                  );end cond
                );end if
                (setq #ii (1+ #ii))
              );end repeat
              (setq #sswork nil)
            )
            ;天井ﾌｨﾗｰ
            ((setq #xd$ (CFGetXData #enR "G_FILR"))
              (if &iCol                                  ;色変更指示あり
                (GroupInSolidChgCol2 #enR &iCol)         ;指示色に変更
                (if (equal CG_BASESYM #enR)              ;色変更指示なし基準ｱｲﾃﾑ
                  (GroupInSolidChgCol #enR CG_BaseSymCol);基準ｱｲﾃﾑ色に変更
                  (GroupInSolidChgCol2 #enR "BYLAYER")   ;BYLAYER色に変更
                );end if
              );end if
              (ssadd #enR #ssRet)                        ;天井ﾌｨﾗｰを戻り値選択ｾｯﾄに加算
              (ssadd (nth 2 #xd$) #ssRet)                ;底面も戻り値選択ｾｯﾄに加算
            )
            (T
              (if &iCol                                  ;色変更指示あり
                (GroupInSolidChgCol2 #enR &iCol)         ;指示色に変更
                (if (equal CG_BASESYM #enR)              ;色変更指示なし基準ｱｲﾃﾑ
                  (GroupInSolidChgCol #enR CG_BaseSymCol);基準ｱｲﾃﾑ色に変更
                  (GroupInSolidChgCol2 #enR "BYLAYER")   ;BYLAYER色に変更
                );end if
              );end if
            )
          );end cond
        )
      );cond
    );end if
    (setq #i (1+ #i))
  );end repeat
  #ssRet
);ChangeItemColor

;<HOM>*************************************************************************
; <関数名>    : entselpoint
; <処理概要>  : entsel+getpoint的な関数
;             : 
; <戻り値>    : 図形名と座標のﾘｽﾄ (<図形名: ****> (x y z))
;             : ｴﾝﾃｨﾃｨが未選択の場合は図形名はnil (nil (x y z))
; <作成>      : 00/09/12 SN ADD
; <備考>      : 
;*************************************************************************>MOH<
(defun entselpoint( &msg
   /
   #allkeys #curtype #grret #type #data
   #loopf
   #sysvar #enp #en
   )

  (setq #allkeys 12);選択方法：ｶｰｿﾙ形状を指定
  (setq #curtype 2);ｶｰｿﾙ形状：ｵﾌﾞｼﾞｪｸﾄ選択ｶｰｿﾙ□
  (setq #loopf T)
  (princ &msg)
  (while #loopf
    (setq #grret (grread nil #allkeys #curtype))
    (setq #type (car #grret))
    (setq #data (cadr #grret))
    (cond
      ;ｷｰ入力orACAD下のﾌｧﾝｸｼｮﾝｸﾘｯｸ
      ((= #type 2)
        (cond
          ; 01/05/16 HN ADD Enterｷｰの処理を追加
          ((= #data 13);[Enter]
            (setq #loopf nil)
          )
          ((= #data 2);[ｽﾅｯﾌﾟ]
            (if (= (getvar "SNAPMODE") 0)
              (progn (setvar "SNAPMODE" 1) (princ " <ｽﾅｯﾌﾟ ｵﾝ> ") )
              (progn (setvar "SNAPMODE" 0) (princ " <ｽﾅｯﾌﾟ ｵﾌ> ") )
            )
          )
          ((= #data 7);[ｸﾞﾘｯﾄﾞ]
            (if (= (getvar "GRIDMODE") 0)
              (progn (setvar "GRIDMODE" 1) (princ " <ｸﾞﾘｯﾄﾞ ｵﾝ> ") )
              (progn (setvar "GRIDMODE" 0) (princ " <ｸﾞﾘｯﾄﾞ ｵﾌ> ") )
            )
          )
          ((= #data 15);[直交ﾓｰﾄﾞ]
            (if (= (getvar "ORTHOMODE") 0)
              (progn (setvar "ORTHOMODE" 1) (princ " <直交ﾓｰﾄﾞ ｵﾝ> ") )
              (progn (setvar "ORTHOMODE" 0) (princ " <直交ﾓｰﾄﾞ ｵﾌ> ") )
            )
          )
          ((= #data 21);[極]
            (setq #sysvar (getvar "AUTOSNAP"))
            (if (= (logand (lsh #sysvar -3) 1) 0);AUTOSNAPｼｽﾃﾑ変数の8
              (progn (setvar "AUTOSNAP" (+ #sysvar 8)) (princ " <極 ｵﾝ> ") )
              (progn (setvar "AUTOSNAP" (- #sysvar 8)) (princ " <極 ｵﾌ> ") )
            )
          )
          ((= #data 23);[OTRACK]
            (setq #sysvar (getvar "AUTOSNAP"))
            (if (= (logand (lsh #sysvar -4) 1) 0);AUTOSNAPｼｽﾃﾑ変数の16
              (progn (setvar "AUTOSNAP" (+ #sysvar 16)) (princ " <O ｽﾅｯﾌﾟ ﾄﾗｯｷﾝｸﾞ ｵﾝ> ") )
              (progn (setvar "AUTOSNAP" (- #sysvar 16)) (princ " <O ｽﾅｯﾌﾟ ﾄﾗｯｷﾝｸﾞ ｵﾌ> ") )
            )
          )
        )
      )
      ;左ﾎﾞﾀﾝが押された
      ((= #type 3)
        (setq #enp (nentselp #data))
        (if (not #enp) (setq #enp (list nil #data)))
        (setq #loopf nil)
      )
      ;右ﾎﾞﾀﾝが押された
      ((= #type 25)
        (setq #enp nil)
        (setq #loopf nil)
      )
    )
  )
  #enp
)
;00/07/31 SN S-ADD ﾘｽﾄに含まれるXDataの存在を確認
(defun CheckXData( &en &xdlst$ / #xdobj #objflg )
  (setq #objflg nil)

  (foreach #xdobj &xdlst$
    (if (CFGetXData &en #xdobj)(setq #objflg T))
  )
  #objflg
)

(princ)
