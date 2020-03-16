
(setq SG_PCLAYER    "Z_00_00_00_01")  ;3Dソリッドの画層
(setq SG_YCLAYER    "Y_00_00_00_01")  ;底面領域の画層

;<HOM>*************************************************************************
; <関数名>    : SKS_StretchParts
; <処理概要>  : 部材伸縮処理
; <戻り値>    :
; <作成日>    : 1998-07-30
; <作成者>    : S.Kawamoto
; <備考>      : どこからも呼び出していないようである YM
;*************************************************************************>MOH<
(defun SKS_StretchParts (
    /
    #i #ss
  )
  ;// 図面のクリーンアップ
  (SKS_CleanUpPrim) ; 図面内で不必要となったデータを削除

  ;// ３Ｄ立体の再作成
  (PKS_StretchPrimAll) ; サイドパネルの伸縮にも使用
)
;SKS_StretchParts

;<HOM>*************************************************************************
; <関数名>    : SKS_CleanUpPrim
; <処理概要>  : 図面内で不必要となったデータを削除
; <戻り値>    :
; <作成日>    : 1998-07-30
; <作成者>    : S.Kawamoto
; <備考>      : どこからも呼び出していない上の関数からのみ呼び出している YM
;*************************************************************************>MOH<
(defun SKS_CleanUpPrim (
    /
    #ss #solid #i #en #eg
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKS_CleanUpPrim ////")
  (CFOutStateLog 1 1 " ")

  (command "_layer" "lo" "Z_00_00_??_01" "")
  (command "_layer" "lo" "Y_00_00_??_01" "")
  (setq #solid (ssget "X" '((8 . "Z_00*"))))
  (setq #ss (ssadd))
  (setq #i 0)
  (repeat (sslength #solid)
    (setq #en (ssname #solid #i))
    (setq #eg (entget (ssname #solid #i)))
    (if (/= (cdr (assoc 8 #eg)) "Z_00")
      (ssadd #en #ss)
    )
    (setq #i (1+ #i))

  )
  (command "_erase" #ss "")  ; Z_00*画層のうちZ_00画層以外のものを削除
  (setq #ss (ssget "X" '((8 . "Y_00*"))))
  (command "_erase" #ss "")  ; Y_00*画層を削除
  (command "_layer" "u" "Z_00_00_??_01" "")
  (command "_layer" "u" "Y_00_00_??_01" "")
  (princ)
)
;SKS_CleanUpPrim

;<HOM>*************************************************************************
; <関数名>    : PKS_StretchPrimAll
; <処理概要>  : 要素図形の拡張データ情報から要素を再作成する
; <戻り値>    :
; <作成日>    : 1998-07-30
; <作成者>    : S.Kawamoto
; <備考>      : ; サイドパネルの伸縮に使用している
;*************************************************************************>MOH<
(defun PKS_StretchPrimAll (
  /
  #ss #i #en #eg #300 #330 #sym #xd$
  #eg$ #eg2$ #en2
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKS_StretchPrimAll ////")
  (CFOutStateLog 1 1 " ")

  (setvar "PICKSTYLE" 0)

  (setq #ss (ssget "X" '((-3 ("G_LSYM"))))) ; 図面上ｼﾝﾎﾞﾙ図形すべて
  (if (/= #ss nil)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #en (ssname #ss #i))
        (setq #xd$ (CFGetXData #en "G_SYM"))
        (if (or (/= 0 (fix (nth 11 #xd$))) (/= 0 (fix (nth 12 #xd$))) (/= 0 (fix (nth 13 #xd$)))) ; 伸縮ﾌﾗｸﾞW,D,Hのどれかが0でない
          (progn
            ;// ２Ｄ図形の伸縮
            (SKEExpansion #en)

            ;// ３Ｄ図形の伸縮
            (setq #eg$ (entget (cdr (assoc 330 (entget #en)))))  ;// 親図面情報を取得
            (foreach #lst #eg$
              (if (= 340 (car #lst))
                (progn
                  (setq #en2 (cdr #lst))  ;// ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰ図形 #en2
                  (setq #eg2$ (entget #en2 '("G_PRIM")))
                  (if (and (/= nil #eg2$) (= (cdr (assoc 0 #eg2$)) "3DSOLID") (= (cdr (assoc 8 #eg2$)) "Z_00_00_00_01"))
                    (progn
                      (princ "\n立体を再作成しています...")
;;;                      (setq #330 (cdr (assoc 330 #eg2$))); scstretchはｺﾒﾝﾄしている 00/02/29 YM DEL
;;;                      (setq #eg2$ (entget #330))         ; scstretchはｺﾒﾝﾄしている 00/02/29 YM DEL
                      (setq #300 (SKGetGroupName #en2))
                      (command "_ucs" "w")
                      (setq #en2 (SKS_RemakePrim #en2)) ; #en2  "G_PRIM"を持った"3DSOLID"で、画層"Z_00_00_00_01"
                      (command "_ucs" "p")
                      (if (/= #en2 nil)
                        (command "-group" "A" #300 #en2 "")
                      )
                    )
                  )
                )
              )
            )
            (CFSetXData #en "G_SYM" ; 更新
              (list
                (nth 0 #xd$)    ;シンボル名称
                (nth 1 #xd$)    ;コメント１
                (nth 2 #xd$)    ;コメント２
                (if (/= (nth 11 #xd$) 0) ; 伸縮フラグＷが0でなかったら、シンボル基準値Ｗのかわりに伸縮フラグＷを入れる
                  (nth 11 #xd$) ;伸縮フラグＷ  0 or 1
                  (nth 3 #xd$)  ;シンボル基準値Ｗ
                )
                (if (/= (nth 12 #xd$) 0) ; 伸縮フラグＤが0でなかったら、シンボル基準値Ｄのかわりに伸縮フラグＤを入れる
                  (nth 12 #xd$) ;伸縮フラグＤ  0 or 1
                  (nth 4 #xd$)  ;シンボル基準値Ｄ
                )
                (if (/= (nth 13 #xd$) 0) ; 伸縮フラグＨが0でなかったら、シンボル基準値Ｈのかわりに伸縮フラグＨを入れる
                  (nth 13 #xd$) ;伸縮フラグＨ  0 or 1
                  (nth 5 #xd$)  ;シンボル基準値Ｈ
                )
                (nth 6 #xd$)    ;シンボル取付け高さ
                (nth 7 #xd$)    ;入力方法
                (nth 8 #xd$)    ;Ｗ方向フラグ
                (nth 9 #xd$)    ;Ｄ方向フラグ
                (nth 10 #xd$)   ;Ｈ方向フラグ
                (nth 11 #xd$)   ;伸縮フラグＷ  0 or 1
                (nth 12 #xd$)   ;伸縮フラグＤ  0 or 1
                (nth 13 #xd$)   ;伸縮フラグＨ  0 or 1
                (nth 14 #xd$)   ;ブレークライン数Ｗ
                (nth 15 #xd$)   ;ブレークライン数Ｄ
                (nth 16 #xd$)   ;ブレークライン数Ｈ
              )
            )
          )
        )
        (setq #i (1+ #i))
      )
      (command "_vpoint" "0,0,1")
      (command "_ucs" "w")
    )
  )
)
;PKS_StretchPrimAll


;<HOM>*************************************************************************
; <関数名>    : SKS_RemakePrim
; <処理概要>  : 要素図形の拡張データ情報から要素を再作成する
; <ヒキスウ>  : 図形名"G_PRIM"を持った"3DSOLID"で、画層"Z_00_00_00_01"にあるもの
; <戻り値>    :
; <作成日>    : 1998-07-30
; <作成者>    : S.Kawamoto
; <備考>      : 要素図形(G_PRIM)、要素底面図形(G_BODY)、要素穴底面図形(G_ANA)
;               の情報を元に再作成する
;*************************************************************************>MOH<
(defun SKS_RemakePrim (
    &prm        ;(ENAME)要素ｴﾝﾃｨﾃｨ名   "G_PRIM"を持った"3DSOLID"で、画層"Z_00_00_00_01"
    /
    #prxd$ #dn #eg$ #prm #bdxd$ #ana$ #i #ana #anxd$ #typ #RET
;;;  #ss ; 00/02/29 YM DEL 使ってない
   #38 #dn38 #EXT_H
;-- 2011/08/23 A.Satoh Add - S
;  #base_hei #en38
;-- 2011/08/23 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKS_RemakePrim ////")
  (CFOutStateLog 1 1 " ")

  ; 02/06/13 YM ADD-S extrudeのときに一時的にワールド座標系にする
  (command "._UCS" "S" "TMP_UCS") ; 現在のUCSを保存する
  (command "._UCS" "W")           ; world座標系にする
  ; 02/06/13 YM ADD-E

;;;  (setq #ss (ssadd)) ; 00/02/29 YM DEL 使ってない

  ;// ﾌﾟﾘﾐﾃｨﾌﾞの拡張ﾃﾞｰﾀを取得
  (setq #prxd$ (CFGetXData &prm "G_PRIM"))
  ;;; 00/05/31 MH ADD
  (if (not #prxd$) (progn (CFAlertErr (strcat
  "伸縮対象のソリッド図形にプリミティブ情報 \"G_PRIM\"がありませんでした"
  "\n\nSKS_RemakePrim")) (exit)))
  (setq #dn (nth 10  #prxd$))   ;// 3DSOLIDの底面領域図形名(ポリライン)
  (if (/= #dn nil)
    (progn
;;;      (setq #ss (ssadd #dn #ss)) ; 00/02/25 YM MOD
;;;      (ssadd #dn #ss) ; 00/02/25 YM MOD  ; 00/02/29 YM DEL 使ってない

;-- 2012/02/17 A.Satoh Add CG対応 - S
			(setq #xd_CG$ (CFGetXData &prm "G_CG"))
;-- 2012/02/17 A.Satoh Add CG対応 - S
      ;// 底面領域のｺﾋﾟｰをｿﾘｯﾄﾞに展開する
      (setq #eg$ (entget #dn)) ; 底面領域図形(ポリライン)情報
;;;   (subst newitem olditem lst)
      (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER = "Z_00_00_00_01"
;;;   (cons 8 SG_PCLAYER)と(assoc 8 #eg$)は同じ？？？
      (setq #eg$ (entget (entlast))); コピーした底面領域図形情報(画層は同じでもﾊﾝﾄﾞﾙは変わる) ---> (entlast)
;-- 2011/08/23 A.Satoh Add - S
;      (setq #base_hei (nth 6 #prxd$))
;      (if (> 0 #base_hei)
;        (progn
;          (setq #en38 (cdr (assoc 38 #eg$)))
;          (entmod (subst (cons 38 (- #en38 #base_hei)) (assoc 38 #eg$) #eg$))
;         (if (> (nth 7 #prxd$) 0)
;           (setq #prxd$ (subst (* (nth 7 #prxd$) -1) (nth 7 #prxd$) #prxd$))
;         )
;        )
;      )
;-- 2011/08/23 A.Satoh Add - E
      (setvar "CLAYER" SG_PCLAYER)  ; 現在の画層をSG_PCLAYERに設定
      ;// 要素の再作成
      (if (/= (car #prxd$) 3) ; "G_PRIM" ﾀｲﾌﾟが単一面でない 厚み付き or 線識面
        (progn
          ;2010/01/08 YM MOD AutoCAD2009対応
          (command "_extrude" (entlast) "" "T" (nth 9 #prxd$) (nth 7 #prxd$) )  ;// 厚み"7"とﾃｰﾊﾟ角度"9"で押出し
;;;          (command "_extrude" (entlast) "" (nth 7 #prxd$) (nth 9 #prxd$))  ;// 厚み"7"とﾃｰﾊﾟ角度"9"で押出し
;;;                           ^^^^^^^^^entmakeでｺﾋﾟｰした底面ﾎﾟﾘﾗｲﾝ

;;;          ;// 元のﾌﾟﾘﾐﾃｨﾌﾞを削除
      ;;; 00/04/20 DEL MH
;;;         (entdel &prm) ; 引数 3DSOLID
          (setq #prm (entlast)) ; "3DSOLID"
;;;                  ^^^^^^^^^押し出しｿﾘｯﾄﾞ

      ;;; 00/04/20 ADD MH ここで、元プリミティブと新ソリッドを比較させて共通範囲が無い場合
      ;;; 押し出し方向が逆であったと判断。新ソリッドを削除して逆方向で作成し直す。
; 02/06/13 YM DEL-S 押し出し判定しない(RemakePrimのときに一時的にﾜｰﾙﾄﾞ座標系にする)
;;;          (if (not (PcChkIntersect #prm &prm))
;;;            (progn
;;;              (entdel #prm)
;;;              (entmake #eg$) ; SG_PCLAYER = "Z_00_00_00_01"
;;;              (command "_extrude" (entlast) "" (- (nth 7 #prxd$)) (nth 9 #prxd$))
;;;              (setq #prm (entlast)) ; "3DSOLID"
;;;            ); progn
;;;          )
; 02/06/13 YM DEL-E
          (entdel &prm) ; 判定が済んだので、元プリティブ削除

          (CFSetXData #prm "G_PRIM" #prxd$) ; 新プリミティブに拡張ﾃﾞｰﾀ"G_PRIM"をｾｯﾄ
;-- 2012/02/17 A.Satoh Add CG対応 - S
					(if #xd_CG$
						; 新プリミティブに拡張データ"G_CG"をセット
						(CFSetXData #prm "G_CG" #xd_CG$)
					)
;-- 2012/02/17 A.Satoh Add CG対応 - S

;;;          (setq #ss (ssadd #prm #ss)) ; 00/02/25 YM MOD
;;;          (ssadd #prm #ss) ; 00/02/25 YM MOD ; 00/02/29 YM DEL 使ってない

          (setq #dn38 (cdr (assoc 38 (entget #dn)))) ; 底面図形(ポリライン)の高度

          ;// 穴の作り直し
          (setq #bdxd$ (CFGetXData #dn "G_BODY"))    ; 底面図形(ポリライン)の"G_BODY" : PLINE 底面 or 上面に付加する情報
          (if (/= #bdxd$ nil)
            (progn
              (setq #ana$ nil)
              (setq #i 2)
              (repeat (nth 1 #bdxd$)        ; 穴ﾃﾞｰﾀ数分繰り返す
                (setq #ana (nth #i #bdxd$)) ; 穴図形名 #i=2
;;;                (setq #ss (ssadd #ana #ss)) ; 00/02/25 YM MOD
;;;                (ssadd #ana #ss) ; 00/02/25 YM MOD ; 00/02/29 YM DEL 使ってない

                (setq #anxd$ (CFGetXData #ana "G_ANA"))
                (setq #eg$ (entget #ana)) ; 穴図形情報

                ;// 穴の押出し
                (setq #typ (nth 1 #anxd$)) ; 穴深さﾀｲﾌﾟ

                (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; 00/02/29 YM ADD ; 穴図形のｺﾋﾟｰSG_PCLAYER="Z_00_00_00_01"
                (cond
                  ((= #typ 0)  ;// 貫通穴
;;;                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$))       ; 穴図形のｺﾋﾟｰ  SG_PCLAYER="Z_00_00_00_01"

                    ;2010/01/08 YM MOD AutoCAD2009対応
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) (nth 7 #prxd$)) ; 穴の押し出し nth 7厚み  nth 3ﾃｰﾊﾟ角度
;;;                    (command "_extrude" (entlast) "" (nth 7 #prxd$) (nth 3 #anxd$)) ; 穴の押し出し nth 7厚み  nth 3ﾃｰﾊﾟ角度
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 0 (nth 2 #anxd$) (nth 3 #anxd$))) ; 穴深さﾀｲﾌﾟ 0 貫通穴
                  )
                  ((= #typ 1)  ;// 底面くり貫き
;;;                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER="Z_00_00_00_01"
                    (if KEKOMI_COM ; 01/01/12 YM MOD 羊羹型対応
                      (setq #ext_H (- (nth 2 #anxd$) KEKOMI_COM))
                      (setq #ext_H (nth 2 #anxd$))
                    );_if
                   
                    ;2010/01/08 YM MOD AutoCAD2009対応
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) #ext_H) ; 穴の押し出し nth 2穴深さ  nth 3ﾃｰﾊﾟ角度
;;;                    (command "_extrude" (entlast) "" #ext_H (nth 3 #anxd$)) ; 穴の押し出し nth 2穴深さ  nth 3ﾃｰﾊﾟ角度
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 1 #ext_H (nth 3 #anxd$))) ; 穴深さﾀｲﾌﾟ 1 底面くり貫き
                  )
                  ((= #typ 2)  ;// 上面くり貫き
;;;                    (entmake (subst (cons 8 SG_PCLAYER) (assoc 8 #eg$) #eg$)) ; SG_PCLAYER="Z_00_00_00_01"

                    ;2010/01/08 YM MOD AutoCAD2009対応
                    (command "_extrude" (entlast) "" "T" (nth 3 #anxd$) (nth 2 #anxd$)) ; 穴の押し出し nth 2穴深さ  nth 3ﾃｰﾊﾟ角度
;;;                    (command "_extrude" (entlast) "" (nth 2 #anxd$) (nth 3 #anxd$)) ; 穴の押し出し nth 2穴深さ  nth 3ﾃｰﾊﾟ角度
                    (CFSetXData #ana "G_ANA" (list (car #anxd$) 2 (nth 2 #anxd$) (nth 3 #anxd$))) ; 穴深さﾀｲﾌﾟ 2 貫通穴
                  )
                )

                ;// 要素との差をとる
                (command "_subtract" #prm "" (entlast) "")
;;;                                          ^^^^^^^^^押し出し作成穴ｿﾘｯﾄﾞ
                (setq #i (1+ #i))
              );_(repeat
            )
          );_if
          ; 02/06/13 YM DEL-S
;;;          (entlast)
          ; 02/06/13 YM DEL-E

          ; 02/06/13 YM MOD-S
          (setq #ret (entlast)) ; 戻り値を#retとする
          ; 02/06/13 YM MOD-E

        );_progn ; "G_PRIM" ﾀｲﾌﾟが単一面でない 厚み付き or 線識面
      ;else

          ; 02/06/13 YM DEL-S
;;;       nil      ; "G_PRIM" ﾀｲﾌﾟが単一面のとき
          ; 02/06/13 YM DEL-E

        ; 02/06/13 YM MOD-S
        (setq #ret nil)      ; "G_PRIM" ﾀｲﾌﾟが単一面のとき ; 戻り値を#retとする
        ; 02/06/13 YM MOD-E
      );_if
    )
  )

  ; 02/06/13 YM ADD-S extrudeのときに一時的にワールド座標系にする
  (command "._UCS" "R" "TMP_UCS") ; 登録したUCSを呼び出す
  (command "._UCS" "D" "TMP_UCS") ; 登録したUCSを削除する
  ; 02/06/13 YM ADD-E

  #ret ; 戻り値を#retとする 02/06/13 YM ADD
)
;SKS_RemakePrim

;<HOM>***********************************************************************
; <関数名>    : SKS_ExpansionSolid
; <処理概要>  : 伸縮されるソリッド図形に属する底面図形の要素厚みを変更する
; <戻り値>    : 成功： T　　　失敗：nil
; <作成日>    : 1998-07-30
; <作成者>    : S.Kawamoto
; <備考>      :
;***********************************************************************>HOM<
(defun SKS_ExpansionSolid (
  &vflg    ;(INT) W(1),D(2),H(3) フラグ
  &p1      ;(INT) 領域１
  &p2      ;(INT) 領域２
  &wid     ;(REAL)伸縮幅
  &lay     ;(STR) 画層名
  &EXT_flg ; 01/03/01 YM ADD 上付きか下付きかのフラグ (1 or 2) 伸縮フラグ=ノーマル:1 アッパー:2
  /
  #ssC
  #ssW
  #i #en #xd$ #h #dn #eg #210 #setflg #vflg
  #view #viewdir #ANA #ANA$ #BODY$ #H_ANA #NN
;-- 2011/08/19 A.Satoh Add - S
  #ana_hei #base_hei #ana_xd$
;-- 2011/08/19 A.Satoh Add - E
;-- 2011/08/23 A.Satoh Add - S
;  #set_hei
;-- 2011/08/23 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKS_ExpansionSolid ////")
  (CFOutStateLog 1 1 " ")

  (setq #ssC (ssget "C" &p1 &p2 (list (cons 0 "3DSOLID") (cons 8 &lay))))
  (if (= #ssC nil)
    (progn
      (CFOutStateLog 1 7 "      SKEExpansionSolid=伸縮対象にソリッドが含まれない")
      T
    )
    (progn
      (setq #ssW (ssget "W" &p1 &p2 (list (cons 0 "3DSOLID") (cons 8 &lay))))
      (command "_ucs" "w")
      (setq #viewdir (getvar "VIEWDIR"))
      (command "_ucs" "p")
      (setq #i 0)
      (repeat (sslength #ssC)
        (setq #en (ssname #ssC #i))
        (setq #xd$ (CFGetXData #en "G_PRIM"))
        ;;; 00/05/30 MH ADD
;;;        (if (not #xd$) (progn (CFAlertErr (strcat  ; 01/02/22 YM DEL
;;;          "伸縮対象のソリッド図形にプリミティブ情報 \"G_PRIM\"がありませんでした"
;;;          "\n\nSKS_ExpansionSolid")) (exit)))

        (setq #setflg nil) ; 01/02/22 YM 下から移動

        (if #xd$ ; 01/02/22 YM
          (progn ; "G_PRIM"があるとき ; 01/02/22 YM

            (setq #h (nth 7 #xd$))
;-- 2011/08/23 A.Satoh Add - S
;            (setq #set_hei (nth 6 #xd$))
;            (if (and (= &vflg 3) (> 0 #set_hei) (= &EXT_flg 2))
;              (setq #h (* #h -1))
;            )
;-- 2011/08/23 A.Satoh Add - E
            (setq #dn (nth 10 #xd$))
            (setq #eg (entget #dn))
            (setq #210 (cdr (assoc CG_SKK_INT_GAS #eg))) ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
            (setq #view (list  (fix (car   #210)) (fix (cadr  #210)) (fix (caddr #210))))
            (setq #viewdir (list (fix (car #viewdir)) (fix (cadr #viewdir)) (fix (caddr #viewdir))))

;;;           (setq #setflg nil)
            (cond
              ((or (= &vflg 1) (= &vflg 2))    ;ＷまたはＤ方向伸縮の場合
                (if (or (equal #viewdir (list 0 -1 0)) (equal #viewdir (list 0 1 0))) ;現在が正面or背面
                  (if (or (equal (list -1 0 0) #view) (equal (list 1 0 0) #view))
                    (if (or (= #ssW nil) (= (ssmemb #en #ssW) nil)) ; 指定されたオブジェクト(図形)が選択セットのメンバーかどうかをテスト
                      (progn
                        (setq #setflg T)
                      )
                    )
                  )
                  (if (or (equal (list 0 -1 0) #view) (equal (list 0 1 0) #view)) ;現在が右側面or左側面
                    (if (or (= #ssW nil) (= (ssmemb #en #ssW) nil))
                      (setq #setflg T)
                    )
                  )
                )
              )
              ((= &vflg 3)  ;Ｈ方向伸縮の場合
                (if (equal (list 0 0 1) #view)
                  (if (or (= #ssW nil) (= (ssmemb #en #ssW) nil))
                    (setq #setflg T)
                  )
                )
              )
            )
            ; 01/03/01 YM 不具合調査
            ; ｼﾝﾎﾞﾙ上付きＨ方向拡張==>伸縮幅&wid(-)
            ;<例>
            ; G_PRIM押し出し量-500==>-600
            ; G_PRIM押し出し量 466==> 366×(正しくは566になるべき)

            ; ｼﾝﾎﾞﾙ下付きＨ方向拡張==>伸縮幅&wid(+)
            ;<例>
            ; G_PRIM押し出し量 701==> 770
            ; これらの例から、押し出し量の絶対値が増加するように設定しなければならない
            ; (伸縮の場合は逆となる)

            ; 上付き押し出し量＋なら減算
            ; 上付き押し出し量－なら加算
            ; 下付き押し出し量＋なら加算
            ; 下付き押し出し量－なら減算
            (if (= #setflg T)
              (progn
                (CFSetXData #en "G_PRIM"
                  (list
                    (nth 0 #xd$)
                    (nth 1 #xd$)
                    (nth 2 #xd$)
                    (nth 3 #xd$)
                    (nth 4 #xd$)
                    (nth 5 #xd$)
                    (nth 6 #xd$)

                    (cond ; 01/03/01 YM 不具合対応押し出し量不具合対応
                      ((= &EXT_flg 1) ; ﾉｰﾏﾙ(下付き)
                        (if (< 0 #h)
                          (+ #h &wid)     ;要素厚み+伸縮幅
                          (- #h &wid)     ;要素厚み-伸縮幅
                        );_if
                      )
                      ((= &EXT_flg 2) ; ｱｯﾊﾟｰ(上付き)
                        (if (< 0 #h)
                          (- #h &wid)     ;要素厚み-伸縮幅
                          (+ #h &wid)     ;要素厚み+伸縮幅
                        );_if
                      )
                      (T
                        (if (< 0 #h)
                          (+ #h &wid)     ;要素厚み+伸縮幅
                          (- #h &wid)     ;要素厚み-伸縮幅
                        );_if
                      )
                    );_cond

                    (nth 8 #xd$)
                    (nth 9 #xd$)
                    (nth 10 #xd$)
                  )
                )
                ; 01/03/08 YM ADD 穴の押し出し量も更新しないといけない(垂れ壁)
                (setq #BODY$ (CFGetXData (nth 10 #xd$) "G_BODY")) ; 底面情報取得
                (setq #nn 2)
                (repeat (nth 1 #BODY$)
                  (setq #ANA (nth #nn #BODY$))
;-- 2011/08/19 A.Satoh Mod - S
                  (setq #ANA$ (CFGetXData #ANA "G_ANA")) ; 穴情報取得
                  (if #ANA$
                    (progn
                      (setq #h_ana (nth 2 #ANA$)) ; 穴高さ

                      (setq #ana_xd$ (entget #ANA '("*")))
                      (setq #ana_hei (cdr (assoc 38 #ana_xd$)))
                      (setq #base_hei (nth 1 &p2))

;                     (if (> (+ #ana_hei #h_ana) #base_hei)
;                       (progn
;-- 2011/12/20 A.Satoh Add - S
											(cond
												((= &EXT_flg 1)	; ﾉｰﾏﾙ(下付き)
													(cond
														((< #ana_hei #base_hei)		; ブレークラインが穴ベース図形の上にある
															(if (> (+ #ana_hei #h_ana) #base_hei)	; ブレークラインが穴範囲内にある場合
	    	        	              (CFSetXData #ANA "G_ANA"
  	    	        	              (list
    	    	        	              (nth 0 #ANA$)
      	    	        	            (nth 1 #ANA$)
																		(if (< 0 #h_ana)
																			(+ #h_ana &wid) ;穴厚み+伸縮幅
																			(- #h_ana &wid) ;穴厚み-伸縮幅
																		)
              		    	            (nth 3 #ANA$)
                		    	        )
																)
															)
														)
														((>= #ana_hei #base_hei)	; ブレークラインが穴ベース図形の下にある
  	          	              (CFSetXData #ANA "G_ANA"
    	          	              (list
      	          	              (nth 0 #ANA$)
        	          	            (nth 1 #ANA$)
;-- 2012/01/05 A.Satoh Mod - S
;;;;;																	(if (< 0 #h_ana)
;;;;;																		(+ #h_ana &wid) ;穴厚み+伸縮幅
;;;;;																		(- #h_ana &wid) ;穴厚み-伸縮幅
;;;;;																	)
																	#h_ana
;-- 2012/01/05 A.Satoh Mod - E
              	  	              (nth 3 #ANA$)
                	  	          )
                  	  	      )
;-- 2012/01/05 A.Satoh Del - S
;;;;;
;;;;; 	                  	  	    (setq #ana_xd$ (subst (cons 38 (+ #ana_hei &wid)) (assoc 38 #ana_xd$) #ana_xd$))
;;;;;   	                  	  	  (entmod #ana_xd$)
;-- 2012/01/05 A.Satoh Del - E
														)
													)
												)
												((= &EXT_flg 2)	; ｱｯﾊﾟｰ(上付き)
    	     	              (CFSetXData #ANA "G_ANA"
      	     	              (list
															(nth 0 #ANA$)
															(nth 1 #ANA$)
															(if (< 0 #h_ana)
																(- #h_ana &wid) ;穴厚み-伸縮幅
																(+ #h_ana &wid) ;穴厚み+伸縮幅
															)
															(nth 3 #ANA$)
														)
													)
												)
											)
;;;;;                      (if (equal #ana_hei 0)
;;;;;                        (if (> (+ #ana_hei #h_ana) #base_hei)
;;;;;                          (CFSetXData #ANA "G_ANA"
;;;;;                            (list
;;;;;                              (nth 0 #ANA$)
;;;;;                              (nth 1 #ANA$)
;;;;;                              (cond ; 穴高さ更新
;;;;;                                ((= &EXT_flg 1) ; ﾉｰﾏﾙ(下付き)
;;;;;                                  (if (< 0 #h_ana)
;;;;;                                    (+ #h_ana &wid) ;穴厚み+伸縮幅
;;;;;                                    (- #h_ana &wid) ;穴厚み-伸縮幅
;;;;;                                  );_if
;;;;;                                )
;;;;;                                ((= &EXT_flg 2) ; ｱｯﾊﾟｰ(上付き)
;;;;;                                  (if (< 0 #h_ana)
;;;;;                                    (- #h_ana &wid) ;穴厚み-伸縮幅
;;;;;                                    (+ #h_ana &wid) ;穴厚み+伸縮幅
;;;;;                                  );_if
;;;;;                                )
;;;;;                              );_cond
;;;;;                              (nth 3 #ANA$)
;;;;;                            )
;;;;;                          )
;;;;;                        )
;;;;;												(if (> (+ #ana_hei #h_ana) #base_hei)
;;;;; 	                        (progn
;;;;;   	                        (setq #ana_xd$ (subst (cons 38 (+ #ana_hei &wid)) (assoc 38 #ana_xd$) #ana_xd$))
;;;;;     	                      (entmod #ana_xd$)
;;;;;       	                  )
;;;;;         	              )
;;;;;                      )
                    )
                  );_if
;-- 2011/12/20 A.Satoh Add - E
;                  (setq #ANA$ (CFGetXData #ANA "G_ANA")) ; 穴情報取得
;                  (if #ANA$
;                    (progn
;                      (setq #h_ana (nth 2 #ANA$)) ; 穴高さ
;
;                      (CFSetXData #ANA "G_ANA"
;                        (list
;                          (nth 0 #ANA$)
;                          (nth 1 #ANA$)
;                          
;                          (cond ; 穴高さ更新
;                            ((= &EXT_flg 1) ; ﾉｰﾏﾙ(下付き)
;                              (if (< 0 #h_ana)
;                                (+ #h_ana &wid) ;穴厚み+伸縮幅
;                                (- #h_ana &wid) ;穴厚み-伸縮幅
;                              );_if
;                            )
;                            ((= &EXT_flg 2) ; ｱｯﾊﾟｰ(上付き)
;                              (if (< 0 #h_ana)
;                                (- #h_ana &wid) ;穴厚み-伸縮幅
;                                (+ #h_ana &wid) ;穴厚み+伸縮幅
;                              );_if
;                            )
;                          );_cond
;
;                          (nth 3 #ANA$)
;                        )
;                      )
;                    )
;                  );_if
;-- 2011/08/19 A.Satoh Mod - E

                  (setq #nn (1+ #nn))
                );repeat
              )
            );_if

          ) ; 01/02/22 YM
        );_if ; 01/02/22 YM
        (setq #i (1+ #i))
      )
    )
  )
  #setflg
);SKS_ExpansionSolid

;<HOM>*************************************************************************
; <関数名>    : SKS_MakeViewStretchPrimAll
; <処理概要>  : ビューを作成し、部材伸縮を行う
; <備考>      : 01/07/11 YM from NR ﾌﾟﾗﾝ検索ｻｲﾄﾞﾊﾟﾈﾙ対応
;*************************************************************************>MOH<
(defun SKS_MakeViewStretchPrimAll (
    /
    #viewEn
    #os #sn
    #res$
    #xmax #ymax
    #wid
  )
  ;// システム変数を設定
  (setq #os (getvar "OSMODE"))
  (setq #sn (getvar "SNAPMODE"))
  (setvar "OSMODE"   0)
  (setvar "GRIDMODE" 0)
  (setvar "SNAPMODE" 0)
  (command "_.UCSICON" "A" "OF")  ;UCSアイコンを全て非表示

  (if (= 0 (getvar "TILEMODE"))
    (progn
      ;// ビューのサイズを取得する
      (command "_.pspace")
      (setvar "SNAPMODE" 0)
      (setvar "OSMODE"   0)
      (setvar "GRIDMODE" 0)

      (setq #res$ (GetViewSize))
      (setq #xmax (nth 1 #res$))
      (setq #ymax (nth 3 #res$))
      (setq #wid (/ (- #xmax (car #res$)) 15.))
      (command "_.mview" (list #xmax #ymax) (list (- #xmax #wid) (- #ymax #wid)))
      (setq #viewEn (entlast))
      (command "_.mspace")

      ;// 部材の伸縮
      (PKS_StretchPrimAll) ; SKS->PKS
      (command "_.PSPACE")
      (entdel #viewEn)
      (command "_.MSPACE")
    )
  ;else
    (progn
      ;// 部材の伸縮
      (PKS_StretchPrimAll) ; SKS->PKS
    )
  )
  ;// システム変数を元に戻す
  (setvar "OSMODE"   #os)
  (setvar "SNAPMODE" #sn)
);SKS_MakeViewStretchPrimAll

;<HOM>*************************************************************************
; <関数名>    : SKS_StretchPartsSub
; <処理概要>  : 部材の伸縮
; <戻り値>    :
; <作成>      : 1998-07-30
; <備考>      :
;*************************************************************************>MOH<
(defun SKS_StretchPartsSub (
    &sym
    /
    #ss #i #en #eg$ #300 #330 #xd$ #gnam #en2 #eg2$ #lst
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SKS_StretchPartsSub ////")
  (CFOutStateLog 1 1 " ")

  (setvar "PICKSTYLE" 0)
  (setq #en &sym)
  (setq #xd$ (CFGetXData #en "G_SYM"))
  (if (or (/= 0 (fix (nth 11 #xd$))) (/= 0 (fix (nth 12 #xd$))) (/= 0 (fix (nth 13 #xd$)))) ; 伸縮ﾌﾗｸﾞW,D,Hのどれかが0でない
    (progn
      ;// ２Ｄ図形の伸縮
      ;(command "_layer" "T" "*" "")
      (SKS_Expansion #en)

      ;// ３Ｄ図形の伸縮
      (setq #eg$ (entget (cdr (assoc 330 (entget #en)))))  ;// 親図面情報を取得
      (foreach #lst #eg$  ;// ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰ図形の取得
        (if (= 340 (car #lst))
          (progn
            (setq #en2 (cdr #lst)) ; ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰ図形 #en2
            (setq #eg2$ (entget #en2 '("G_PRIM")))
            (if (and (/= nil #eg2$) (= (cdr (assoc 0 #eg2$)) "3DSOLID") (= (cdr (assoc 8 #eg2$)) "Z_00_00_00_01"))
              (progn ; ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰ のうち"G_PRIM" "3DSOLID" 画層="Z_00_00_00_01"
                (setq #gnam (SKGetGroupName #en2)) ; ｸﾞﾙｰﾌﾟ名の取得
                (setq #en2 (SKS_RemakePrim #en2)) ; #en2  "G_PRIM"を持った"3DSOLID"で、画層"Z_00_00_00_01"
                (if (/= #en2 nil)
                  (progn
                    (command "-group" "A" #gnam #en2 "")
                  )
                )
              )
            )
          )
        )
      )
      (CFSetXData #en "G_SYM" ; 拡張ﾃﾞｰﾀ更新
        (list
          (nth 0 #xd$)    ;シンボル名称          そのまま
          (nth 1 #xd$)    ;コメント１            そのまま
          (nth 2 #xd$)    ;コメント２            そのまま

          (if (/= (nth 11 #xd$) 0)      ; 伸縮ﾌﾗｸﾞが0でなかったら
            (nth 11 #xd$)   ; 伸縮ﾌﾗｸﾞＷ
            (nth 3 #xd$)    ;シンボル基準値Ｗ    そのまま
          )
          (if (/= (nth 12 #xd$) 0)      ; 伸縮ﾌﾗｸﾞが0でなかったら
            (nth 12 #xd$)   ; 伸縮ﾌﾗｸﾞＤ
            (nth 4 #xd$)    ;シンボル基準値Ｄ    そのまま
          )
          (if (/= (nth 13 #xd$) 0)      ; 伸縮ﾌﾗｸﾞが0でなかったら
            (nth 13 #xd$)   ; 伸縮ﾌﾗｸﾞＨ
            (nth 5 #xd$)    ;シンボル基準値Ｈ    そのまま
          )

          (nth 6 #xd$)    ;シンボル取付け高さ    そのまま
          (nth 7 #xd$)    ;入力方法              そのまま
          (nth 8 #xd$)    ;Ｗ方向フラグ          そのまま
          (nth 9 #xd$)    ;Ｄ方向フラグ          そのまま
          (nth 10 #xd$)   ;Ｈ方向フラグ          そのまま
          (nth 11 #xd$)   ;伸縮フラグＷ          そのまま
          (nth 12 #xd$)   ;                      そのまま
          (nth 13 #xd$)   ;                      そのまま
          (nth 14 #xd$)   ;ブレークライン数Ｗ    そのまま
          (nth 15 #xd$)   ;ブレークライン数Ｄ    そのまま
          (nth 16 #xd$)   ;ブレークライン数Ｈ    そのまま
        )
      )
    )
  )
  (command "_vpoint" "0,0,1") ; 平面図
  (command "_ucs" "w")        ; ﾜｰﾙﾄﾞ
)
;SKS_StretchPartsSub

;<HOM>***********************************************************************
; <関数名>    : SKS_Expansion
; <処理概要>  : シンボルに属する 2D 図形を全て伸縮する
; <ヒキスウ>  : ｼﾝﾎﾞﾙ図形
; <戻り値>    : 成功： T　　　失敗：nil
; <作成>      : 1998/08/05, 1998/08/17 -> 1998/08/17   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKS_Expansion
  (
    &enSym      ; 伸縮を行うシンボル図形名
  /
    #SymData$   ; シンボルデータ格納用
    #enGroup    ; シンボルの所属するグループ名格納用
    #GrpData$   ; グループ構成図形名(グループのデータ)格納用
    #expData$   ; 伸縮処理を行う図形データ名格納用
    #iRad       ; シンボルの回転角度格納用
    #SymPos$    ; シンボルの挿入点格納用
    #ViewZ$     ; 押し出し方向格納用
    #iHSize     ; 現在の H 方向のサイズ格納用
    #iWSize     ; 現在の W 方向のサイズ格納用
    #iDSize     ; 現在の D 方向のサイズ格納用
    #iHExp      ; H 方向の伸縮幅格納用
    #iWExp      ; W 方向の伸縮幅格納用
    #iDExp      ; D 方向の伸縮幅格納用
    #BrkH$      ; H 方向のブレークライン名格納用
    #BrkW$      ; W 方向のブレークライン名格納用
    #BrkD$      ; D 方向のブレークライン名格納用
    #bCabFlag   ; キャビネットフラグ(アッパーキャビネット:1 それ以外:0)
    #Pos$       ; 伸縮対称図形の矩形領域座標格納用
    #iExpSize   ; 伸縮を行うサイズ格納用
    #iLoop      ; ループ用
    #nn         ; foreach 用
    #strLayer   ; 画層名格納用
    #Temp$      ; テンポラリリスト
    ;; ローカル定数格納用
    Exp_F_View  ; 回転角0正面視点位置定数格納用
    Exp_FM_View ; 回転角マイナス正面視点位置定数格納用
    Exp_FP_View ; 回転角プラス正面視点位置定数格納用
    Exp_S_View  ; 回転角0側面視点位置定数格納用
    Exp_SM_View ; 回転角マイナス側面視点位置定数格納用
    Exp_SP_View ; 回転角プラス側面視点位置定数格納用
    Exp_Temp_Layer; 伸縮作業用画層名格納用
    Upper_Cab_Code ; グローバル定数用
  )
  ;; 伸縮処理開始
  (CFOutStateLog 1 7 "      SKEExpansion=Start")
  ;T    ; return;
  ;; ローカル定数の初期化(初期値代入)
  (setq Exp_F_View  '(0 -1 0))  ; 回転角0正面視点位置定数格納用
  (setq Exp_FM_View '(-1 0 0))  ; 回転角マイナス正面視点位置定数格納用
  (setq Exp_FP_View '(1 0 0))   ; 回転角プラス正面視点位置定数格納用
  (setq Exp_S_View  '(-1 0 0))  ; 回転角0側面視点位置定数格納用
  (setq Exp_SM_View '(0 1 0))   ; 回転角マイナス側面視点位置定数格納用
  (setq Exp_SP_View '(0 -1 0))  ; 回転角プラス側面視点位置定数格納用

  (setq Exp_Temp_Layer  "EXP_TEMP_LAYER") ; 伸縮作業用画層名

  ;; 伸縮作業用テンポラリ画層の作成
  (command "_layer" "N" Exp_Temp_Layer "C" 1 Exp_Temp_Layer "L" SKW_AUTO_LAY_LINE Exp_Temp_Layer ""); 伸縮作業用テンポラリ画層の作成

  (setq #bCabFlag 0)
  (setq #SymData$ (CFGetXData &enSym "G_LSYM")); シンボルの "G_LSYM" 拡張データを取得する

  (if (/= #SymData$ nil)                                     ; "G_LSYM" データを取得できたかどうかのチェック
    (progn                                                   ; 取得できた
      (setq #iRad    (nth 2 #SymData$))                      ; 回転角度(nth 2)を取得する
      (setq #SymPos$ (nth 1 #SymData$))                      ; 挿入点(nth 1)を取得する
      (setq #Temp$   (nth 9 #SymData$))                      ; 性格CODE取得
      (if (= CG_SKK_TWO_UPP (CFGetSeikakuToSKKCode #Temp$ 2)); 性格CODEがアッパーキャビネットかどうかのチェック
        (setq #bCabFlag 1)                                   ; ｱｯﾊﾟｰｷｬﾋﾞ
      )
      (setq #SymData$ (CFGetXData &enSym "G_SYM")); シンボルの "G_SYM" 拡張データを取得する

      (if (/= #SymData$ nil)               ; "G_SYM" データを取得できたかどうかのチェック
        (progn                             ; 取得できた
          (setq #iWSize (nth  3 #SymData$)); 現在の W サイズ(nth 3)
          (setq #iDSize (nth  4 #SymData$)); 現在の D サイズ(nth 4)
          (setq #iHSize (nth  5 #SymData$)); 現在の H サイズ(nth 5)
          (setq #iWExp  (nth 11 #SymData$)); W 方向(nth 11)の伸縮幅
          (setq #iDExp  (nth 12 #SymData$)); D 方向(nth 12)の伸縮幅
          (setq #iHExp  (nth 13 #SymData$)); H 方向(nth 13)の伸縮幅
          (setq #SymData$ (entget &enSym)) ; ｼﾝﾎﾞﾙ図形情報を取得する
          (setq #enGroup (cdr (assoc 330 #SymData$)))      ; シンボルのグループ名を取得する "G_GROUP"
          (setq #GrpData$ (entget #enGroup))               ; グループ内データ(グループ名リスト)を取得する "G_GROUP"図形情報

          (foreach #nn #GrpData$                           ; 2D 図形で伸縮処理を行うデータを絞り込む。ブレークラインを抽出する
            (if (= (car #nn) 340)                          ; グループ構成図形名かどうかのチェック
              (progn                                       ; グループ構成図形名だった
                (setq #Temp$ (entget (cdr #nn)))           ; グループ構成図形名情報

                (if (/= (cdr (assoc 0 #Temp$)) "XLINE")    ; グループ構成図形がソリッドデータ(0 . "3DSOLID")以外かどうかのチェック
;;;                                                                                                ^^^^^^^^"XLINE"??? "3DSOLID"???
                  (progn                                   ; ソリッドデータではなかった
                    (setq #strLayer (cdr (assoc 8 #Temp$))); 画層名の取得
                    (setq #expData$ (cons (list (cdr #nn) #strLayer) #expData$)); (図形名 画層名)
                    (entmod
                      (subst (cons 8 Exp_Temp_Layer) (assoc 8 #Temp$) #Temp$)   ; 伸縮対象図形を伸縮処理画層に移動する
                    )
                  )
                );_if

                (if (= (cdr (assoc 0 #Temp$)) "XLINE")                                 ; グループ構成図形がブレークラインかどうかのチェック
                  (progn                                                               ; ブレークラインだった
                    (setq #Temp$ (CFGetXData (cdr #nn) "G_BRK"))                       ; ブレークラインの拡張データを取得
                    (if (/= #Temp$ nil)                                                ; 拡張データが存在するかどうかのチェック
                      (progn                                                           ; 拡張データが存在した
                        (cond                                                          ; H,W,D 各ブレークラインの種類毎に図形名を格納する
                          ((= (nth 0 #Temp$) 1) (setq #BrkW$ (cons (cdr #nn ) #BrkW$))); W 方向ブレークライン #BrkW$ : ﾌﾞﾚｰｸﾗｲﾝ図形名ﾘｽﾄ
                          ((= (nth 0 #Temp$) 2) (setq #BrkD$ (cons (cdr #nn ) #BrkD$))); D 方向ブレークライン #BrkD$ : ﾌﾞﾚｰｸﾗｲﾝ図形名ﾘｽﾄ
                          ((= (nth 0 #Temp$) 3) (setq #BrkH$ (cons (cdr #nn ) #BrkH$))); H 方向ブレークライン #BrkH$ : ﾌﾞﾚｰｸﾗｲﾝ図形名ﾘｽﾄ
                        )
                      )
                    )
                  )
                )
              );_progn
            );_if
          );_(foreach

          (if (and (= #BrkH$ nil) (= #BrkW$ nil) (= #BrkD$ nil))
            (CFAlertErr "このアイテムには伸縮ラインがありませんでした")
          )
          ; 伸縮処理
          (cond                                     ; 押し出し方向の判断
            ((= #iRad 0) (setq #ViewZ$ Exp_F_View)) ; #iRad : LSYM 回転角度(nth 2)
            ((< #iRad 0) (setq #ViewZ$ Exp_FM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_FP_View))
          )

          ; 伸縮を行うサイズのチェック(アッパーキャビネットの場合は +- が逆転)
          (if (and (= #bCabFlag 1) (/= #iHExp 0)) ; アッパーキャビで H方向(nth 13)の伸縮幅が０でない
            (progn
              (setq #iExpSize (list 1 (- #iHExp #iHSize) 2)) ; 伸縮幅-現在のHサイズ(nth 5)
            )
            ; else
            (progn
              (setq #iExpSize (list 0 (- #iHExp #iHSize) 1))
            )
          );_if

          (if (and (/= #BrkH$ nil) (/= #iHExp 0))
            (progn                                                    ; ブレークラインを基点から遠い順にソートする
              (setq #BrkH$ (SKESortBreakLine (list 2 #BrkH$) #SymPos$))
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkH$ #iExpSize) ; H 方向の伸縮処理
              (CFOutStateLog 1 7 "        SKEExpansion=Hブレーク OK") ; 正常終了
            )
            ;; else
            (progn
              (CFOutStateLog 1 7 "        SKEExpansion=Hブレークなし"); 正常終了
            )
          )

          (if (and (/= #BrkW$ nil) (/= #iWExp 0))
            (progn
              (setq #BrkW$ (SKESortBreakLine (list 0 #BrkW$) #SymPos$)); ブレークラインを基点から遠い順にソートする
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkW$ (list 2 (- #iWExp #iWSize))); W 方向の伸縮処理
              (CFOutStateLog 1 7 "        SKEExpansion=Wブレーク OK"); 正常終了
            )
            ; else
            (progn
              (CFOutStateLog 1 7 "        SKEExpansion=Wブレークなし"); 正常終了
            )
          )
          ; 押し出し方向の判断
          (cond
            ((= #iRad 0) (setq #ViewZ$ Exp_S_View))
            ((< #iRad 0) (setq #ViewZ$ Exp_SM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_SP_View))
          )
          (if (and (/= #BrkD$ nil) (/= #iDExp 0))
            (progn

              (setq #BrkD$ (SKESortBreakLine (list 1 #BrkD$) #SymPos$)); ブレークラインを基点から遠い順にソートする
              ; D 方向の伸縮処理
;;;@YM@             (if (and (= CG_Type2Code "W") (= CG_LRCODE "R") (equal #ViewZ$ (list 0 -1 0)))
;;;@YM@               (progn
;;;@YM@                 (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 3 (- #iDExp #iDSize)))
;;;@YM@               )
;;;@YM@               (progn
;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU T)
;--2011/07/21 A.Satoh Add - E
                  (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 2 (- #iDExp #iDSize)))
;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU nil)
;--2011/07/21 A.Satoh Add - E
;;;@YM@               )
;;;@YM@             )

              (CFOutStateLog 1 7 "        SKEExpansion=Dブレーク OK"); 正常終了
            )
            ;; else
            (progn

              (CFOutStateLog 1 7 "        SKEExpansion=Dブレークなし"); 正常終了
            )
          )

          (foreach #nn #expData$ ; 伸縮作業画層から元の画層に図形データを移動する
            (setq #Temp$ (entget (nth 0 #nn) '("*")))
            (entmod
              (subst (cons 8 (nth 1 #nn)) (cons 8 Exp_Temp_Layer) #Temp$)
            )
          )

          (CFOutStateLog 1 7 "      SKEExpansion=OK End"); 正常終了
          T   ; return;
        )
        ; else
        (progn    ; シンボルの拡張データを取得できなかった
          (CFOutStateLog 0 7 "      SKEExpansion=\"G_SYM\"拡張データを取得できませんでした error End"); 異常終了
          nil   ; return;
        )
      );_if
    )
    ;; else
    (progn    ; 拡張データを取得できなかった
      (CFOutStateLog 0 7 "      SKEExpansion=\"G_LSYM\"拡張データを取得できませんでした error End"); 異常終了
      nil   ; return;
    )
  );_if
)
;SKS_Expansion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 01/08/20 YM 以下に"KcEXP.lsp"の関数を全て移動
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;<HOM>***********************************************************************
; <関数名>    : CFPwStretch
; <処理概要>  : Z軸方向のポリラインの移動もサポートしたストレッチ
; <戻り値>    : 成功： T      失敗：nil
; <作成>      : 1998/08/19 -> 1998/08/19, 1998/10/05 -> 1998/10/07   松木 健太郎
; <備考>      : AutoCAD の標準 STRETCH コマンドが不甲斐ないので自作
;***********************************************************************>HOM<
(defun CFPwStretch (
  &enList$      ; エンティティリスト(図形名 図形名 ...) or 選択セット(ssget で取得)
  &Pos$         ; 選択領域
  &Fillter      ; 選択フィルタ
  &StartPos$    ; 伸縮開始点座標
  &strExpAmount ; 伸縮量
  /
  #enList$      ; エンティティリスト
  #plList$      ; ポリライン座標データ格納リスト((図形名 1ポリライン座標データリスト) ...)
  #plTemp$      ; ポリラインの座標データ格納用テンポラリリスト
  #plName       ; ポリライン図形名格納用
  #iLFlag       ; ループフラグ
  #Temp$        ; テンポラリリスト
  #nn           ; foreach 用
  #mm           ; foreach 用
  #iLoop        ; ループ用
  #iLoop2       ; ループ用
  #ssEn         ; ssget 取得データ格納用
  #DIMSS #ELM #EN_LAYER_LIS #ET #I #210 #ENDIM #NEWLAYER #DUMSS
;-- 2011/07/20 A.Satoh Add - S
  #idx #flg #flg2 #en #MEJI$ #ssEn2 #max_x #max_y #min_x #min_y
  #st_pnt$ #pnt_x #pnt_y #pnt_z #gname #enLayer$ #enLayer #orgLayer
;-- 2011/07/20 A.Satoh Add - E
#pnt$	;-- 2011/12/08 Add
#ORG_LAYER #ORG_LAYER_VIEW #SKIP #S_VIEW ;2017/04/17 YM ADD
  )
  ;; 引数データが ssget で取得した選択セットデータかどうかのチェック
  (if (= (type &enList$) 'PICKSET)
    (progn    ; ssget で取得した選択セットだった
      ;; 選択セットをエンティティリストに変換
      (setq #iLoop 0)
      (while (< #iLoop (sslength &enList$))
        (setq #enList$ (cons (ssname &enList$ #iLoop) #enList$))
        (setq #iLoop (+ #iLoop 1))
      )
    )
    ;; else
    (progn    ; 選択セットではなかった
      ;; コピー
      (setq #enList$ &enList$)
    )
  )
  (setq #plList$ nil)

  ;; エンティティリスト要素数分ループ
  (foreach #nn #enList$
    ;; 図形データ取得
    (setq #Temp$ (entget #nn))
    ;; 図形がポリラインデータかどうかのチェック
    (if (= (cdr (assoc 0 #Temp$)) "LWPOLYLINE")
      (progn    ; 図形データがポリラインだった
        (setq #plName nil)
        (setq #plTemp$ nil)
        ;; データ構成要素数分ループ
        (foreach #mm #Temp$
          ;; 座標データかどうかのチェック
          (if (= (car #mm) 10)
            (progn    ; 座標データだった
              ;; 初期設定ができているかどうかのチェック
              (if (= #plName nil)
                (progn    ; できていなかった
                  (setq #plName #nn)    ; 初期値代入
                  (setq #plTemp$ (list (cdr #mm)))
                )
                ;; else
                (progn    ; できていた
                  (setq #plTemp$ (append #plTemp$ (list (cdr #mm))))    ; データ追加
                )
              )
            )
          )
        )
        ;; 初期設定ができているかどうかのチェック
        (if (= #plList$ nil)
          (progn    ; できていなかった
            (setq #plList$ (list (list #plName #plTemp$)))    ; 初期値代入
          )
          ;; else
          (progn    ; できていた
            (setq #plList$ (append #plList$ (list (list #plName #plTemp$))))    ; データ追加
          )
        )

      )
    )
  )

  (setq #ssEn
    (ssget "C"
      (nth 0 &Pos$)
      (nth 1 &Pos$)
      &Fillter ; ((8 . "EXP_TEMP_LAYER"))
    )
  )


  ;DIMENSIONは伸縮対象から除く(画層"TEMP_DIM_LAYER"に移す) ; 01/03/12 YM ADD START
  (setq #dimSS (ssadd))
  (setq #i 0)
  (repeat (sslength #ssEn) ; 同一グループ内の全図形
    (setq #elm (ssname #ssEn #i)) ; 各要素
    (setq #et  (entget #elm))
    (if (= (cdr (assoc 0 #et)) "DIMENSION") ; 寸法以外 00/03/22 YM ADD
      (ssadd #elm #dimSS)
    );_if
    (setq #i (1+ #i))
  );_(repeat

  (setq #en_Layer_lis (Chg_SStoEnLayer #dimSS))         ; ﾘｽﾄ--->(<図形名> 画層)のﾘｽﾄのﾘｽﾄに変換
  (MakeTempLayer2 "TEMP_DIM_LAYER")                     ; 寸法伸縮作業用テンポラリ画層の作成
  (if (and #dimSS (> (sslength #dimSS) 0))
    (command "chprop" #dimSS "" "LA" "TEMP_DIM_LAYER" "") ; 対象図形をﾃﾝﾎﾟﾗﾘｰ画層へ移動
  );_if

;2011/07/04 YM MOD-S 小さくなりすぎてEP幅方向伸縮できない(全体ｽﾞｰﾑだとNG)
(command "_.zoom" "W" (nth 0 &Pos$) (nth 1 &Pos$))
  ; 01/06/05 YM ADD
;;;  (command "_zoom" "0.5x") ; 画面ぎりぎりだと一部図形がｽﾄﾚｯﾁできないようである

;2011/07/04 YM MOD-E 小さくなりすぎてEP幅方向伸縮できない

  ; 01/03/12 YM ADD END
  (if #ssEn
    (progn
;-- 2011/07/20 A.Satoh Add - S
      (if (= CG_OKU T)
        (progn
          ; 扉枠図形を分解する（現状のままではストレッチ出来ない為）
          (setq #idx 0)
          (setq #flg T)
          (setq #enLayer$ nil)
          (repeat (sslength #ssEn)
            (if (= #flg T)
              (progn
                (setq #en (ssname #ssEn #idx))
                (setq #MEJI$ (CFGetXData #en "G_MEJI"))
                (if (/= #MEJI$ nil)
                  (progn
                    (setq #flg nil)

                    ; 伸縮を行う図形名リスト変更用図形リストに扉枠図形名を設定する
                    (setq CG_EXPDATA$ (list #en))

                    ; グループ名を取得
                    (setq #gname (SKGetGroupName #en))

                    ; 扉枠図形を分解する
                    (command "_.EXPLODE" #en)

                    (setq #ssEn2 (ssget "P"))
                  )
                )
              )
            )
            (setq #idx (1+ #idx))
          )
        )
      )
;-- 2011/07/20 A.Satoh Add - E

      ;; ストレッチ実行
      (command
        "_.stretch"
          (ssget "C"
            (nth 0 &Pos$)
            (nth 1 &Pos$)
            &Fillter
          )
        ""    ; 選択確定
        &StartPos$    ; 伸縮開始点
        &strExpAmount    ; 伸縮量
      )

;-- 2011/07/20 A.Satoh Add - S
;2011/07/25 YM ADD 条件追加:躯体伸縮時、G_MEJIがないから#ssEn2=nilとなって以下の処理で落ちるのでnilでないことを条件に加える
;;;      (if (= CG_OKU T)
      (if (and #ssEn2 (= CG_OKU T)(< 0 (sslength #ssEn2)) )
        (progn
          ; UCS変更
          ;; UCS変換用座標リスト作成
          (setq #idx 0)
          (setq #pnt$ nil)
          (setq #max_x nil #max_y nil #min_x nil #min_y nil)
          (repeat (sslength #ssEn2)
            (setq #en (ssname #ssEn2 #idx))
            (setq #st_pnt$ (cdr (assoc 10 (entget #en))))
            (setq #pnt_x (nth 0 #st_pnt$))
            (setq #pnt_z (nth 1 #st_pnt$))
            (setq #pnt_y (nth 2 #st_pnt$))

            (if (= #max_x nil)
              (setq #max_x #pnt_x)
              (if (< #max_x #pnt_x)
                (setq #max_x #pnt_x)
              )
            )
            (if (= #max_y nil)
              (setq #max_y #pnt_y)
              (if (< #max_y #pnt_y)
                (setq #max_y #pnt_y)
              )
            )
            (if (= #min_x nil)
              (setq #min_x #pnt_x)
              (if (> #min_x #pnt_x)
                (setq #min_x #pnt_x)
              )
            )
            (if (= #min_y nil)
              (setq #min_y #pnt_y)
              (if (> #min_y #pnt_y)
                (setq #min_y #pnt_y)
              )
            )
            (setq #idx (1+ #idx))
          )
          (setq #pnt$ (list (list #min_x #pnt_z #min_y) (list #max_x #pnt_z #min_y) (list #max_x #pnt_z #max_y) (list #min_x #pnt_z #max_y)))

          (command "_.UCS" (nth 0 #pnt$) (nth 1 #pnt$) (nth (1- (length #pnt$)) #pnt$))

          ; ポリライン化
          (command "_.PEDIT" "M")
          (setq #idx 0)
          (repeat (sslength #ssEn2)
            (command (ssname #ssEn2 #idx))
            (setq #idx (1+ #idx))
          )
          (command "" "Y" "J" "" "C" "")

          (setq #en (entlast))

          ; 伸縮を行う図形名リスト変更用図形名リストに分解後の扉枠図形名を設定する
          (setq CG_EXPDATA$ (append CG_EXPDATA$ (list #en)))

          ; ポリライン図形をグループに含める
          (command "_.GROUP" "A" #gname #en "")

          ; UCSを元に戻す
          (command "_.UCS" "P")
        )
      )
;-- 2011/07/20 A.Satoh Add - E

      ; 01/06/05 YM ADD
      (command "zoom" "p") ; 画面ぎりぎりだと一部図形がｽﾄﾚｯﾁできないようである

;;;01/03/12YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/03/12YM@      ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ,ｹｺﾐ伸縮ｺﾏﾝﾄﾞ時,伸縮できないDIMENSIONをｽﾄﾚｯﾁ 01/01/23 01/01/27 YM
;;;01/03/12YM@      (if (or KEKOMI_COM CG_TOKU_H CG_TOKU_D)
;;;01/03/12YM@        (progn
;;;01/03/12YM@          (PK_KEKOMI_DIM_Stretch
;;;01/03/12YM@            "R" ; 右側面
;;;01/03/12YM@            &Pos$            ; 伸縮開始点座標
;;;01/03/12YM@            &Fillter         ; 伸縮量
;;;01/03/12YM@            &StartPos$       ; 伸縮開始点
;;;01/03/12YM@            &strExpAmount    ; 伸縮量
;;;01/03/12YM@          )
;;;01/03/12YM@        )
;;;01/03/12YM@      );_if
;;;01/03/12YM@
;;;01/03/12YM@      (if (or KEKOMI_COM CG_TOKU_H)
;;;01/03/12YM@        (progn
;;;01/03/12YM@          (PK_KEKOMI_DIM_Stretch
;;;01/03/12YM@            "L" ; 左側面
;;;01/03/12YM@            &Pos$            ; 伸縮開始点座標
;;;01/03/12YM@            &Fillter         ; 伸縮量
;;;01/03/12YM@            &StartPos$       ; 伸縮開始点
;;;01/03/12YM@            &strExpAmount    ; 伸縮量
;;;01/03/12YM@          )
;;;01/03/12YM@        )
;;;01/03/12YM@      );_if ;  01/01/23 YM (ｹｺﾐ伸縮時)
;;;01/03/12YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    )
    ;; else
    (progn
      (princ "\n*** 選択がありませんでした ****************************\n\n")
    )
  );_if

  ; 寸法以外伸縮が済んだ

  ; 寸法１つずつ伸縮する; 01/03/12 YM ADD START
  (setq #i 1)
  (foreach dum #en_Layer_lis ; (<図形名> 画層)
    (setq #enDIM (car dum))

		; DIMENSIONの元の画層を求める 2017/04 17 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		(if CG_ORG_Layer$
			(progn
				;★★★　現在伸縮対象ビュー判定　★★★
				(setq #S_VIEW nil)
;;;     (setq CG_TOKU_BW #BrkW)
;;; 	  (setq CG_TOKU_BD nil)
;;;	   	(setq CG_TOKU_BH nil)
				(if CG_TOKU_BW (setq #S_VIEW "W")) ;　巾方向伸縮中
				(if CG_TOKU_BD (setq #S_VIEW "D")) ;奥行方向伸縮中
				(if CG_TOKU_BH (setq #S_VIEW "H")) ;高さ方向伸縮中

				(setq #org_Layer (cadr (assoc (car dum) CG_ORG_Layer$)))
				(setq #org_Layer_View (substr #org_Layer 1 4)) ;"Z_01"
				;★★★　操作対象画層かどうか判定　★★★
				(setq #SKIP nil) ; SKIPするかどうか
				(cond
					((= #S_VIEW "W")
						(if (= #org_Layer_View "Z_01") (setq #SKIP T) );平面SKIP
				 	)
					((= #S_VIEW "D")
						(if (= #org_Layer_View "Z_01") (setq #SKIP T) );平面SKIP
				 	)
					((= #S_VIEW "H")
						(if (= #org_Layer_View "Z_01") (setq #SKIP T) );平面SKIP
				 	)
					(T
						(setq #SKIP nil)
				 	)
				);cond


			)
		);_if

    (setq #210 (cdr (assoc 210 (entget #enDIM))))
    (setq #newLAYER (strcat "TEMP_DIM_LAYER" (itoa #i))) ; 寸法１つずつ別画層作成
    (MakeTempLayer2 #newLAYER) ; 寸法伸縮作業用テンポラリ画層の作成
    (if #enDIM
      (command "chprop" #enDIM "" "LA" #newLAYER "") ; 対象図形をﾃﾝﾎﾟﾗﾘｰ画層へ移動
    );_if

    ;; VPOINT 変更 右側面図
    (command "_.vpoint" #210) ; 寸法押し出し方向からのﾋﾞｭｰにする
    ;; UCS 変更
    (command "_.UCS" "V")

    (setq #dumSS
      (ssget "C"
        (nth 0 &Pos$)
        (nth 1 &Pos$)
        (list (cons 8 #newLAYER))
      )
    )

		;2017/04/17 YM MOD-S
    (if (and (= #SKIP nil) (/= #dumSS nil))
;;;    (if (/= #dumSS nil)
      (progn
        ;; ストレッチ実行
        (command
          "_.stretch"
            (ssget "C"
              (nth 0 &Pos$)
              (nth 1 &Pos$)
              (list (cons 8 #newLAYER))
            )
          ""    ; 選択確定
          &StartPos$    ; 伸縮開始点
          &strExpAmount    ; 伸縮量
        )
      )
    );_if

    ;; UCS 変更
    (command "_.UCS" "P") ; 直前に戻す
    ;; VPOINT ビューを戻す
    (command "zoom" "p")
    (setq #i (1+ #i))
  );foreach

  (BackLayer #en_Layer_lis) ; 画層を元に戻す
  ; 01/03/12 YM ADD END
  

;-- 2011/11/02 A.Satoh Del - S
;  (if (= CG_ACAD_VER "14")
;    (progn
;-- 2011/11/02 A.Satoh Del - E
      ;; ポリラインのデータチェック
      (foreach #nn #plList$
        ;; ポリラインのデータ取得
        (setq #plTemp$ (entget (car #nn)))
;-- 2011/12/13 A.Satoh Add - S
				(if #plTemp$
					(progn
;-- 2011/12/13 A.Satoh Add - E
        (setq #iLoop  0)
        (setq #iLoop2 0)
        (setq #iLFlag 0)
        ;; データ構成要素数分ループ
        (while (and (< #iLoop (length #plTemp$)) (= #iLFlag 0))
          ;; データが座標データかどうかのチェック
          (if (= (car (nth #iLoop #plTemp$)) 10)
            (progn    ; 座標データだった
              ;; 旧座標と比較(どうやら、若干誤差が出るようなので、小数点第5位以下は切り捨てる)
              (if (> (distance (cdr (nth #iLoop #plTemp$)) (nth #iLoop2 (nth 0 (cdr #nn)))) 0.0001)
                (progn    ; 旧座標と違う値だった
                  ;; ポリラインは移動しているので、ループから抜け、次のデータへ
                  (setq #iLFlag 1)
                )
              )
              (setq #iLoop2 (+ #iLoop2 1))
            )
          )
          (setq #iLoop (+ #iLoop 1))
        )

        ;; ポリラインが移動していないかチェック
        (if (and (= #iLFlag 0) (/= "3DSOLID" (cdr (assoc 0 (entget (car #nn))))))
          (progn    ; 移動していなかった
;-- 2011/11/02 A.Satoh Del - S
            ;(getstring)
;-- 2011/11/02 A.Satoh Del - E
            ;; ポリラインを移動
            (command
              "_.move"
              (car #nn)
              ""
              "0,0,0"
              &strExpAmount
            )
;-- 2011/11/02 A.Satoh Del - S
            ;(getstring)
;-- 2011/11/02 A.Satoh Del - E
          )
        )
;-- 2011/12/13 A.Satoh Add - S
					)
				)
;-- 2011/12/13 A.Satoh Add - E
      )
;-- 2011/11/02 A.Satoh Del - S
;    )
;  )
;-- 2011/11/02 A.Satoh Del - E
  ;; 正常終了
  (CFOutStateLog 1 7 "        CFPwStretch=OK")
  T    ; return;
);CFPwStretch

;;;01/03/12YM@;<HOM>***********************************************************************
;;;01/03/12YM@; <関数名>    : PK_KEKOMI_DIM_Stretch
;;;01/03/12YM@; <処理概要>  : 伸縮されない"DIMENSION"を伸縮する(左右側面からのﾋﾞｭｰ)
;;;01/03/12YM@; <戻り値>    : なし
;;;01/03/12YM@; <作成>      : 01/01/23 YM
;;;01/03/12YM@; <備考>      :
;;;01/03/12YM@;***********************************************************************>HOM<
;;;01/03/12YM@(defun PK_KEKOMI_DIM_Stretch (
;;;01/03/12YM@  &flg          ; "R" or "L" 左右側面
;;;01/03/12YM@  &Pos$         ; 伸縮開始点座標
;;;01/03/12YM@  &Fillter      ; 伸縮量
;;;01/03/12YM@  &StartPos$    ; 伸縮開始点
;;;01/03/12YM@  &strExpAmount ; 伸縮量
;;;01/03/12YM@  /
;;;01/03/12YM@  #SS0
;;;01/03/12YM@  )
;;;01/03/12YM@  (if (= &flg "R")
;;;01/03/12YM@    (progn
;;;01/03/12YM@
;;;01/03/12YM@      (Setq #SS0
;;;01/03/12YM@        (ssget "C"
;;;01/03/12YM@          (nth 0 &Pos$)
;;;01/03/12YM@          (nth 1 &Pos$)
;;;01/03/12YM@          (list
;;;01/03/12YM@            (cons -4 "<AND")
;;;01/03/12YM@              (car &Fillter)
;;;01/03/12YM@              (cons 0 "DIMENSION")
;;;01/03/12YM@              (cons 210 '(1 0 0))
;;;01/03/12YM@            (cons -4 "AND>")
;;;01/03/12YM@          )
;;;01/03/12YM@        )
;;;01/03/12YM@      )
;;;01/03/12YM@
;;;01/03/12YM@      (if (and #SS0 (> (sslength #SS0) 0))
;;;01/03/12YM@        (progn
;;;01/03/12YM@
;;;01/03/12YM@          ;; VPOINT 変更 右側面図
;;;01/03/12YM@          (command "_.vpoint" '(1 0 0))
;;;01/03/12YM@          ;; UCS 変更
;;;01/03/12YM@          (command "_.UCS" "V")
;;;01/03/12YM@          (command
;;;01/03/12YM@            "_.stretch"
;;;01/03/12YM@            (ssget "C"
;;;01/03/12YM@              (nth 0 &Pos$)
;;;01/03/12YM@              (nth 1 &Pos$)
;;;01/03/12YM@              (list
;;;01/03/12YM@                (cons -4 "<AND")
;;;01/03/12YM@                  (car &Fillter)
;;;01/03/12YM@                  (cons 0 "DIMENSION")
;;;01/03/12YM@                  (cons 210 '(1 0 0))
;;;01/03/12YM@                (cons -4 "AND>")
;;;01/03/12YM@              )
;;;01/03/12YM@            )
;;;01/03/12YM@            ""               ; 選択確定
;;;01/03/12YM@            &StartPos$       ; 伸縮開始点
;;;01/03/12YM@            &strExpAmount    ; 伸縮量
;;;01/03/12YM@          )
;;;01/03/12YM@          ;; UCS 変更
;;;01/03/12YM@          (command "_.UCS" "P") ; 直前に戻す
;;;01/03/12YM@          ;; VPOINT ビューを戻す
;;;01/03/12YM@          (command "zoom" "p")
;;;01/03/12YM@
;;;01/03/12YM@        )
;;;01/03/12YM@      );if
;;;01/03/12YM@
;;;01/03/12YM@    )
;;;01/03/12YM@  );_if
;;;01/03/12YM@  (if (= &flg "L")
;;;01/03/12YM@    (progn
;;;01/03/12YM@
;;;01/03/12YM@      (Setq #SS0
;;;01/03/12YM@        (ssget "C"
;;;01/03/12YM@          (nth 0 &Pos$)
;;;01/03/12YM@          (nth 1 &Pos$)
;;;01/03/12YM@          (list
;;;01/03/12YM@            (cons -4 "<AND")
;;;01/03/12YM@              (car &Fillter)
;;;01/03/12YM@              (cons 0 "DIMENSION")
;;;01/03/12YM@              (cons 210 '(-1 0 0))
;;;01/03/12YM@            (cons -4 "AND>")
;;;01/03/12YM@          )
;;;01/03/12YM@        )
;;;01/03/12YM@      )
;;;01/03/12YM@
;;;01/03/12YM@      (if (and #SS0 (> (sslength #SS0) 0))
;;;01/03/12YM@        (progn
;;;01/03/12YM@
;;;01/03/12YM@          ;; VPOINT 変更 左側面図
;;;01/03/12YM@          (command "_.vpoint" '(-1 0 0))
;;;01/03/12YM@          ;; UCS 変更
;;;01/03/12YM@          (command "_.UCS" "V")
;;;01/03/12YM@          (command
;;;01/03/12YM@            "_.stretch"
;;;01/03/12YM@            (ssget "C"
;;;01/03/12YM@              (nth 0 &Pos$)
;;;01/03/12YM@              (nth 1 &Pos$)
;;;01/03/12YM@              (list
;;;01/03/12YM@                (cons -4 "<AND")
;;;01/03/12YM@                  (car &Fillter)
;;;01/03/12YM@                  (cons 0 "DIMENSION")
;;;01/03/12YM@                  (cons 210 '(-1 0 0))
;;;01/03/12YM@                (cons -4 "AND>")
;;;01/03/12YM@              )
;;;01/03/12YM@            )
;;;01/03/12YM@            ""    ; 選択確定
;;;01/03/12YM@            &StartPos$    ; 伸縮開始点
;;;01/03/12YM@            &strExpAmount    ; 伸縮量
;;;01/03/12YM@          )
;;;01/03/12YM@          ;; UCS 変更
;;;01/03/12YM@          (command "_.UCS" "P") ; 直前に戻す
;;;01/03/12YM@          ;; VPOINT ビューを戻す
;;;01/03/12YM@          (command "zoom" "p")
;;;01/03/12YM@
;;;01/03/12YM@        )
;;;01/03/12YM@      );if
;;;01/03/12YM@
;;;01/03/12YM@    )
;;;01/03/12YM@  );_if
;;;01/03/12YM@  (princ)
;;;01/03/12YM@);PK_KEKOMI_DIM_Stretch

;<HOM>***********************************************************************
; <関数名>    : SKEGetPos
; <処理概要>  : 図形内の最大座標と、最小座標を取得する
; <戻り値>    : 成功： ((最大座標X,Y,Z) (最小座標X,Y,Z))　　　失敗：nil
; <作成>      : 1998/08/17 -> 1998/08/18   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKEGetPos
  (
    &enList$     ; 座標を取得する図形名リスト((図形名 元の画層名) (図形名 元の画層名) ..)
  /
    #enName      ; 図形名格納用

    #MaxX        ; 最大X値
    #MaxY        ; 最大Y値
    #MaxZ        ; 最大Z値

    #MinX        ; 最小X値
    #MinY        ; 最小Y値
    #MinZ        ; 最小Z値

    #pos$        ; テンポラリ座標値格納用

    #bPosFlag    ; 座標比較フラグ

    #nn          ; foreach 用
    #mm          ; foreach 用
    #Temp$       ; テンポラリリスト
    #iHatch      ; ハッチング図形専用のテンポラリ
  )
  ;;======================================================================
  ;; 変数の初期化
  ;;======================================================================
  (setq #MaxX nil)

  ;; 図形数分ループ
  (foreach #nn &enList$
    (setq #enName (car #nn))    ; 図形名格納
    (setq #Temp$ (entget #enName '("*")))    ; 図形データ取得
    ;; データ要素数分ループ
    (foreach #mm #Temp$
      ;; 座標データかどうかのチェック
      (if (and (<= (car #mm) 18) (>= (car #mm) 10))
        (progn    ; 座標データだった
          ;; 座標比較フラグクリア
          (setq #bPosFlag nil)
          ;; データのチェック(2D座標系を持つ図形かどうかのチェック)
          (cond
            ((= (cdr (assoc 0 #Temp$)) "LWPOLYLINE")    ; ポリラインだった(2D座標系を持つ図形データだった)
              ;; 座標変換
              (setq #pos$ (trans (append (cdr #mm) (list (cdr (assoc 38 #Temp$)))) #enName 1 0))
              ;; 座標比較フラグオン
              (setq #bPosFlag 1)
            )
            ((= (cdr (assoc 0 #Temp$)) "LINE")    ; ラインだった(変形3D座標系を持つ図形データだった)
              ;; 座標変換
              (setq #pos$ (trans (cdr #mm) #enName 1 0))
              ;; 座標比較フラグオン
              (setq #bPosFlag 1)
            )
            ; 01/03/26 YM ADD START //////////// ｼﾝｸｷｬﾋﾞの上空にある"ARC"が伸縮範囲に含まれないため
            ((= (cdr (assoc 0 #Temp$)) "ARC")    ; 円弧だった(変形3D座標系を持つ図形データだった)
              ;; 座標変換
              (setq #pos$ (trans (cdr #mm) #enName 1 0))
              ;; 座標比較フラグオン
              (setq #bPosFlag 1)
            )
            ((= (cdr (assoc 0 #Temp$)) "CIRCLE") ; 円だった(変形3D座標系を持つ図形データだった)
              ;; 座標変換
              (setq #pos$ (trans (cdr #mm) #enName 1 0))
              ;; 座標比較フラグオン
              (setq #bPosFlag 1)
            )
            ; 01/03/26 YM ADD END //////////// ｼﾝｸｷｬﾋﾞの上空にある"ARC"が伸縮範囲に含まれないため
            ((or (= (cdr (assoc 0 #Temp$)) "HATCH")
                 (= (cdr (assoc 0 #Temp$)) "POINT")
             )
              ;; 座標比較フラグオフ
              (setq #bPosFlag 0)
            )
            (T    ; ポリラインではなかった(3D座標系を持つ図形データだった)
              (setq #pos$ (cdr #mm))
              ;; 座標比較フラグオン
              (setq #bPosFlag 1)
            )
          )
          ;; 座標比較フラグがオンになってるかどうかのチェック
          (if (= #bPosFlag 1)
            (progn    ; オンになっていた
              ;; デフォルト座標値の入力
              (if (= #MaxX nil)
                (progn    ; デフォルトが入力されていなかった
                  (setq #MaxX (nth 0 #pos$))
                  (setq #MaxY (nth 1 #pos$))
                  (setq #MaxZ (nth 2 #pos$))
                  (setq #MinX (nth 0 #pos$))
                  (setq #MinY (nth 1 #pos$))
                  (setq #MinZ (nth 2 #pos$))
                )
                ;; else
                (progn    ; デフォルト値は過去に入力されていた
                  ;; 最大値の判断
                  (if (> (nth 0 #pos$) #MaxX)
                    (progn
                      (setq #MaxX (nth 0 #pos$))
                    )
                  )
                  (if (> (nth 1 #pos$) #MaxY)
                    (progn
                      (setq #MaxY (nth 1 #pos$))
                    )
                  )
                  (if (> (nth 2 #pos$) #MaxZ)
                    (progn
                      (setq #MaxZ (nth 2 #pos$))
                    )
                  )
                  ;; 最小値の判断
                  (if (< (nth 0 #pos$) #MinX)
                    (progn
                      (setq #MinX (nth 0 #pos$))
                    )
                  )
                  (if (< (nth 1 #pos$) #MinY)
                    (progn
                      (setq #MinY (nth 1 #pos$))
                    )
                  )
                  (if (< (nth 2 #pos$) #MinZ)
                    (progn
                      (setq #MinZ (nth 2 #pos$))
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

  ;; 正常終了
  (CFOutStateLog 1 7 "        SKEGetPos=OK")
  (list (list #MaxX #MaxY #MaxZ) (list #MinX #MinY #MinZ))    ; return;
)
;SKEGetPos

;<HOM>***********************************************************************
; <関数名>    : SKEFigureExpansion
; <処理概要>  : 図形を伸縮する
; <戻り値>    : 成功： T      失敗：nil
; <作成>      : 1998/08/17 -> 1998/08/17, 1998/10/05 -> 1998/10/07   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKEFigureExpansion (
    &enList$     ; 伸縮を行う図形の図形名リスト((図形名 元の画層名) (図形名 元の画層名) ..)
    &ViewZ$      ; Z 軸上での正の点を指定(押し出し方向)(ex : (0 -1 0))
    &BrkType$    ; 伸縮を行うブレークラインを指定(ブレークラインは基点から遠い順にソートされていることが条件)
    &iExpSize    ; 伸縮するサイズ(伸縮方向 伸縮サイズ 伸縮フラグ)
                 ;                伸縮方向=上:0 下:1 右:2 左:3
                 ;                伸縮フラグ=ノーマル:1 アッパー:2
  /
    #Pos$        ; 部材領域の最大座標と最小座標格納用((最大X座標 最大Y座標 最大Z座標) (最小X座標 最小Y座標 最小Z座標))
    #PosS$       ; 伸縮領域始点座標
    #PosE$       ; 伸縮領域終点座標
    #iBrkLine    ; ブレークライン位置格納用
    #strExpAmount; ブレークライン1本当たりの伸縮量格納用

    #strFillLayer; フィルタをかける画層名格納用

    #PosTemp$    ; テンポラリリスト
    #Temp$       ; テンポラリリスト
    #nn          ; foreach 用
    #bLoop       ; ループフラグ
#EXT_VAL #XX1 #XX2 #YY1 #YY2 ;2010/01/08 YM ADD
  )
  ;; 伸縮を行う図形の有無と伸縮量をチェック
  (if (and (/= &enList$ nil) (/= &iExpSize 0))
    (progn    ; 伸縮を行う図形が存在した
      ;; VPOINT 変更
      (command "_.vpoint" &ViewZ$)
      ;; UCS 変更
      (command "_.UCS" "V")

      (setq #strFillLayer (cdr (assoc 8 (entget (nth 0 (nth 0 &enList$))))))
      ; 既存の場合"OFF"のことがあるので"ON"にする　01/03/22 YM ADD
      (command "_layer" "T" #strFillLayer "")
      (command "_layer" "ON" #strFillLayer "")

      ;;======================================================================
      ;; 伸縮処理
      ;;======================================================================
      (setq #bLoop nil)
      ;; ブレークラインの本数分ループする
      (foreach #nn &BrkType$
        ;; ブレークライン1本当たりの伸縮量取得
        (setq #strExpAmount (rtos (/ (nth 1 &iExpSize) (length &BrkType$))))
        ;;======================================================================
        ;; 図形の最大、最小座標を求める(伸縮対称図形全てを選択できる矩形領域の抽出)
        ;;======================================================================
        (setq #Pos$ (SKEGetPos &enList$))

        ;; ブレークラインの種類によって使用する座標を絞り込む
        (setq #Temp$ (CFGetXData #nn "G_BRK"))
        (cond
          ((= (nth 0 #Temp$) 3)    ; H 方向ブレークライン
            (setq #PosTemp$ (list
                              (list (nth 0 (nth 0 #Pos$)) (nth 1 (nth 0 #Pos$)))
                              (list (nth 0 (nth 1 #Pos$)) (nth 1 (nth 1 #Pos$)))
                            )
            )
            (setq #iBrkLine (nth 1 (trans (cdr (assoc 10 (entget #nn))) 0 1)))
          )
          ((= (nth 0 #Temp$) 1)    ; W 方向ブレークライン
            (setq #PosTemp$ (list
                              (list (nth 0 (nth 0 #Pos$)) (nth 1 (nth 0 #Pos$)))
                              (list (nth 0 (nth 1 #Pos$)) (nth 1 (nth 1 #Pos$)))
                            )
            )
            (setq #iBrkLine (nth 0 (trans (cdr (assoc 10 (entget #nn))) 0 1)))
          )
          ((= (nth 0 #Temp$) 2)    ; D 方向ブレークライン
            (setq #PosTemp$ (list
                              (list (nth 0 (nth 0 #Pos$)) (nth 1 (nth 0 #Pos$)))
                              (list (nth 0 (nth 1 #Pos$)) (nth 1 (nth 1 #Pos$)))
                            )
            )
            (setq #iBrkLine (nth 0 (trans (cdr (assoc 10 (entget #nn))) 0 1)))
          )
        );_cond

        ;;======================================================================
        ;; 伸縮に必要なパラメータを各ブレークラインの種類によって取得する
        ;;======================================================================

        ; 特注ｷｬﾋﾞ,ｹｺﾐ伸縮時は全てのﾊﾟﾗﾒｰﾀをｸﾞﾛｰﾊﾞﾙ化 01/01/27 YM -------------------
;;;       (if (or TOKU_COM KEKOMI_COM)
;;;         (progn
;;;            (setq PosS_0$ (nth 0 #PosTemp$))                         ;; 選択開始点を取得
;;;            (setq PosE_0$ (list (nth 0 (nth 1 #PosTemp$)) #iBrkLine));; 選択終点を取得
;;;            (setq strExpAmount_0 (strcat "@0," #strExpAmount))       ;; 伸縮量を取得
;;;
;;;            (setq PosS_1$ (list (nth 0 (nth 0 #PosTemp$)) (nth 1 (nth 1 #PosTemp$)))) ;; 選択開始点を取得
;;;            (setq PosE_1$ (list (nth 0 (nth 1 #PosTemp$)) #iBrkLine))                 ;; 選択終点を取得
;;;            (setq strExpAmount_1 (strcat "@0," (rtos (* -1.0 (atof #strExpAmount))))) ;; 伸縮量を取得
;;;
;;;            (setq PosS_2$ (nth 0 #PosTemp$))                         ;; 選択開始点を取得
;;;            (setq PosE_2$ (list #iBrkLine (nth 1 (nth 1 #PosTemp$))));; 選択終点を取得
;;;            (setq strExpAmount_2 (strcat "@" #strExpAmount ",0"))    ;; 伸縮量を取得
;;;
;;;            (setq PosS_3$ (list (nth 0 (nth 1 #PosTemp$)) (nth 1 (nth 0 #PosTemp$)))) ;; 選択開始点を取得
;;;            (setq PosE_3$ (list #iBrkLine (nth 1 (nth 1 #PosTemp$))))                 ;; 選択終点を取得
;;;            (setq strExpAmount_3 (strcat "@" (rtos (* -1 (atof #strExpAmount))) ",0"));; 伸縮量を取得
;;;         )
;;;       );_if
        ; 特注ｷｬﾋﾞ,ｹｺﾐ伸縮時は全てのﾊﾟﾗﾒｰﾀをｸﾞﾛｰﾊﾞﾙ化 01/01/27 YM -------------------


;;;正面から見たキャビネット範囲とBrk Line,
;;;STRETCH 範囲 #PosTemp$ (SKEFigureExpansion)の関係
;;;@1:STRAT
;;;@2:END
;;;
;;;上方向
;;;　+-------------------------@1
;;;
;;;--@2------------------------------- Brk Line
;;;
;;;  +-------------------------+
;;;
;;;下方向
;;;　+-------------------------+
;;;
;;;--@2------------------------------- Brk Line
;;;
;;;　+-------------------------@1
;;;
;;;右方向
;;;              |
;;;　+-----------|-------------@1
;;;              |
;;;              |
;;;　+-----------@2------------+
;;;              |
;;;            Brk Line
;;;
;;;左方向
;;;              |
;;;　@2----------|-------------+
;;;              |
;;;              |
;;;　+-----------@1------------+
;;;              |
;;;            Brk Line

        (setq #XX1 (nth 0 (nth 0 #PosTemp$)))
        (setq #YY1 (nth 1 (nth 0 #PosTemp$)))
        (setq #XX2 (nth 0 (nth 1 #PosTemp$)))
        (setq #YY2 (nth 1 (nth 1 #PosTemp$)))
        (setq #EXT_VAL 1000) ; STRETCHで大き目にとる値

        (cond
          ((= (nth 0 &iExpSize) 0)    ; 上方向の伸縮
            (setq #PosS$ (list (+ #XX1 #EXT_VAL) #YY1))                         ;; 選択開始点を取得
            (setq #PosE$ (list (- #XX2 #EXT_VAL) #iBrkLine));; 選択終点を取得
;;;02/02/04YM@MOD            (setq #PosS$ (nth 0 #PosTemp$))                         ;; 選択開始点を取得
;;;02/02/04YM@MOD            (setq #PosE$ (list (nth 0 (nth 1 #PosTemp$)) #iBrkLine));; 選択終点を取得
            (setq #strExpAmount (strcat "@0," #strExpAmount))       ;; 伸縮量を取得
          )
          ((= (nth 0 &iExpSize) 1)    ; 下方向の伸縮
            (setq #PosS$ (list (+ #XX1 #EXT_VAL) #YY2)) ;; 選択開始点を取得
            (setq #PosE$ (list (- #XX2 #EXT_VAL) #iBrkLine))                 ;; 選択終点を取得
;;;02/02/04YM@MOD            (setq #PosS$ (list (nth 0 (nth 0 #PosTemp$)) (nth 1 (nth 1 #PosTemp$)))) ;; 選択開始点を取得
;;;02/02/04YM@MOD            (setq #PosE$ (list (nth 0 (nth 1 #PosTemp$)) #iBrkLine))                 ;; 選択終点を取得
            (setq #strExpAmount (strcat "@0," (rtos (* -1.0 (atof #strExpAmount))))) ;; 伸縮量を取得
          )
          ((= (nth 0 &iExpSize) 2)    ; 右方向の伸縮
            (setq #PosS$ (list #XX1      (+ #YY1 #EXT_VAL)))                         ;; 選択開始点を取得
            (setq #PosE$ (list #iBrkLine (- #YY2 #EXT_VAL)));; 選択終点を取得
;;;02/02/04YM@MOD            (setq #PosS$ (nth 0 #PosTemp$))                         ;; 選択開始点を取得
;;;02/02/04YM@MOD            (setq #PosE$ (list #iBrkLine (nth 1 (nth 1 #PosTemp$))));; 選択終点を取得
            (setq #strExpAmount (strcat "@" #strExpAmount ",0"))    ;; 伸縮量を取得
          )
          ((= (nth 0 &iExpSize) 3)    ; 左方向の伸縮
            ; 02/02/04 YM MOD
            (setq #PosS$ (list #iBrkLine (+ #YY2 #EXT_VAL)))                 ;; 選択終点を取得
            (setq #PosE$ (list #XX2      (- #YY1 #EXT_VAL))) ;; 選択開始点を取得
;;;02/02/04YM@MOD            (setq #PosS$ (list (nth 0 (nth 1 #PosTemp$)) (nth 1 (nth 0 #PosTemp$)))) ;; 選択開始点を取得
;;;02/02/04YM@MOD            (setq #PosE$ (list #iBrkLine (nth 1 (nth 1 #PosTemp$))))                 ;; 選択終点を取得
            (setq #strExpAmount (strcat "@" (rtos (* -1 (atof #strExpAmount))) ",0"));; 伸縮量を取得
          )
        );_cond

;-- 2011/12/24 A.Satoh Add - S
(command "_zoom" "e");; ZOOM
(command "_zoom" "0.8x") ; 画面ぎりぎりだと一部図形がｽﾄﾚｯﾁできないようである
;-- 2011/12/24 A.Satoh Add - E
        ;;======================================================================
        ;; 3D 伸縮処理
        ;;======================================================================
        (SKS_ExpansionSolid
          (nth 0 #Temp$)                              ; 伸縮方向フラグ(W:1, D:2, H:3)
          #PosS$                                      ; 選択始点
          (if (/= #bLoop nil)
            (progn
              (if (/= (nth 0 #Temp$) 3)
                (progn
                  (list
                    (-
                      (nth 0 #PosE$)
                      (if (= (nth 2 &iExpSize) 2)
                        (progn
                          (* (/ (nth 1 &iExpSize) (length &BrkType$)) -1)    ; 1回あたりの伸縮量
                        )
                        ;; else
                        (progn
                          (/ (nth 1 &iExpSize) (length &BrkType$))    ; 1回あたりの伸縮量
                        )
                      )
                    )
                    (nth 1 #PosE$)
                  )
                )
                ;; else
                (progn
                  (list
                    (nth 0 #PosE$)
                    (-
                      (nth 1 #PosE$)
                      (if (= (nth 2 &iExpSize) 2)
                        (progn
                          (* (/ (nth 1 &iExpSize) (length &BrkType$)) -1)    ; 1回あたりの伸縮量
                        )
                        ;; else
                        (progn
                          (/ (nth 1 &iExpSize) (length &BrkType$))    ; 1回あたりの伸縮量
                        )
                      )
                    )
                  )
                )
              )
            )
            ;; else
            (progn
              #PosE$
            )
          )
          (if (= (nth 2 &iExpSize) 2)
            (progn
;;;01/06/08YM@              (* (nth 1 &iExpSize) -1) ; 伸縮量*(-1) ; 01/06/05 YM MOD
              (* (/ (nth 1 &iExpSize) (length &BrkType$)) -1)    ; 1回あたりの伸縮量
            )
            ;; else
            (progn
;;;01/06/08YM@              (nth 1 &iExpSize) ; 伸縮量 ; 01/06/05 YM MOD
              (/ (nth 1 &iExpSize) (length &BrkType$))    ; 1回あたりの伸縮量
            )
          )
          #strFillLayer                                ; フィルタマスク画層
          (nth 2 &iExpSize) ; 01/03/01 YM ADD 上付きか下付きかのフラグ (1 or 2)
        )
        (setq #bLoop T)
        ;(command "_.-layer" "on" "*" "")

        ;;======================================================================
        ;; ストレッチコマンドを使って伸縮を行う
        ;;======================================================================
;-- 2011/12/24 A.Satoh Del (ズーム処理箇所を「3D 伸縮処理」の前に変更）- S
;;;;;;03/12/06 YM ADD C:Automrr で伸縮できない　一時ｺﾒﾝﾄ
;;;;;(command "_zoom" "e");; ZOOM
;;;;;(command "_zoom" "0.5x") ; 画面ぎりぎりだと一部図形がｽﾄﾚｯﾁできないようである
;;;;;;03/12/06 YM ADD C:Automrr で伸縮できない　一時ｺﾒﾝﾄ
;-- 2011/12/24 A.Satoh Del (ズーム処理箇所を「3D 伸縮処理」の前に変更）- S

;-- 2011/07/21 A.Satoh Add - S
        ; 伸縮を行う図形の図形名リスト(グローバル変数)を初期化する
        (setq CG_EXPDATA$ nil)
;-- 2011/07/21 A.Satoh Add - E
        (CFPwStretch
          (ssget "C"  ; 伸縮図形の選択
            #PosS$    ; 選択開始点
            #PosE$    ; 選択終点
            (list (cons 8 #strFillLayer))  ; 選択フィルタ
          )
          (list #PosS$ #PosE$)
          (list (cons 8 #strFillLayer))    ; 選択フィルタ
          #PosS$
          #strExpAmount    ; 伸縮量
        )
      )
      ;(command "_.vpoint" (list 0 0 1))

      ;; 正常終了
      (CFOutStateLog 1 7 "        SKEFigureExpansion=OK")
      T    ; return;
    )
    ;; else
    (progn    ; 伸縮を行う図形が存在しなかった
      ;; 正常終了
      (CFOutStateLog 1 7 "        SKEFigureExpansion=伸縮対称図形が存在しませんでした OK")
      T    ; return;
    )
  )
);SKEFigureExpansion

;<HOM>***********************************************************************
; <関数名>    : SKESortBreakLine
; <処理概要>  : ブレークラインを基点から遠い順にソートする
; <戻り値>    : 成功： ソート後のブレークライン名リスト　　　失敗：nil
; <作成>      : 1998/08/19 -> 1998/08/19   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKESortBreakLine
  (
    &BrkLine$    ; ブレークライン名リスト(ブレークラインタイプ (ブレークライン名リスト))ブレークラインタイプ=H:2 W:0 D:1
    &Pos$        ; 配置基点
  /
    #SortLine$  ; ソート後のブレークライン格納用
    #iVal        ; 基点との距離格納用

    #Temp$      ; テンポラリデータリスト
    #TempData$  ; テンポラリエンティティ名格納用変数

    #nn          ; foreach 用
  )
  ;; 変数初期化
  (setq #SortLine$ nil)

  ;;======================================================================
  ;; ブレークラインの基点からの距離を取得する
  ;;======================================================================
  ;; ブレークラインの要素数分ループ
  (foreach #nn (nth 1 &BrkLine$)
    (setq #Temp$ (entget #nn))
    (setq #iVal (distance &Pos$ (cdr (assoc 10 #Temp$))))
    (setq #TempData$ (cons (list #iVal #nn) #TempData$))
  )

; 配置角度を考慮に入れていないのではないか↓ 01/06/05 YM MOD
;;;01/06/05YM@  (foreach #nn (nth 1 &BrkLine$)
;;;01/06/05YM@    (setq #Temp$ (entget #nn))
;;;01/06/05YM@    (setq #iVal (abs (- (nth (car &BrkLine$) &Pos$) (nth (car &BrkLine$) (cdr (assoc 10 #Temp$))))))
;;;01/06/05YM@    (setq #TempData$ (cons (list #iVal #nn) #TempData$))
;;;01/06/05YM@  )
; 配置角度を考慮に入れていないのではないか↑ 01/06/05 YM MOD

  ;;======================================================================
  ;; ブレークラインをソートし、図形名だけを格納する
  ;;======================================================================
  (setq #Temp$ (CFListSort #TempData$ 0))
  ;(setq #Temp$ (CFSortRecFirstElm #TempData$))
  (foreach #nn #Temp$
    (setq #SortLine$ (cons (nth 1 #nn) #SortLine$))
  )

  ;; 正常終了
  (CFOutStateLog 1 7 "        SKESortBreakLine=OK")
  #SortLine$    ; return;
)
;SKESortBreakLine

;<HOM>***********************************************************************
; <関数名>    : SKEExpansion
; <処理概要>  : シンボルに属する 2D 図形を全て伸縮する
; <戻り値>    : 成功： T　　　失敗：nil
; <作成>      : 1998/08/05, 1998/08/17 -> 1998/08/17   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKEExpansion (
  &enSym      ; 伸縮を行うシンボル図形名
  /
  #SymData$   ; シンボルデータ格納用
  #enGroup    ; シンボルの所属するグループ名格納用
  #GrpData$   ; グループ構成図形名(グループのデータ)格納用
  #expData$   ; 伸縮処理を行う図形データ名格納用
  #iRad       ; シンボルの回転角度格納用
  #SymPos$    ; シンボルの挿入点格納用
  #ViewZ$     ; 押し出し方向格納用
  #iHSize     ; 現在の H 方向のサイズ格納用
  #iWSize     ; 現在の W 方向のサイズ格納用
  #iDSize     ; 現在の D 方向のサイズ格納用
  #iHExp      ; H 方向の伸縮幅格納用
  #iWExp      ; W 方向の伸縮幅格納用
  #iDExp      ; D 方向の伸縮幅格納用
  #BrkH$      ; H 方向のブレークライン名格納用
  #BrkW$      ; W 方向のブレークライン名格納用
  #BrkD$      ; D 方向のブレークライン名格納用
  #bCabFlag   ; キャビネットフラグ(アッパーキャビネット:1 それ以外:0)
  #Pos$       ; 伸縮対称図形の矩形領域座標格納用
  #iExpSize   ; 伸縮を行うサイズ格納用
  #iLoop      ; ループ用
  #nn         ; foreach 用
  #strLayer   ; 画層名格納用
  #Temp$      ; テンポラリリスト
  ;; ローカル定数格納用
  Exp_F_View  ; 回転角0正面視点位置定数格納用
  Exp_FM_View ; 回転角マイナス正面視点位置定数格納用
  Exp_FP_View ; 回転角プラス正面視点位置定数格納用
  Exp_S_View  ; 回転角0側面視点位置定数格納用
  Exp_SM_View ; 回転角マイナス側面視点位置定数格納用
  Exp_SP_View ; 回転角プラス側面視点位置定数格納用
  Exp_Temp_Layer ; 伸縮作業用画層名格納用
  Upper_Cab_Code ; グローバル定数用
#STRFILLLAYER
  )
  ;; 伸縮処理開始
  (CFOutStateLog 1 7 "      SKEExpansion=Start")
  ;T    ; return;
  ;; ローカル定数の初期化(初期値代入)
  (setq Exp_F_View  '(0 -1 0))  ; 回転角0正面視点位置定数格納用
  (setq Exp_FM_View '(-1 0 0))  ; 回転角マイナス正面視点位置定数格納用
  (setq Exp_FP_View '(1 0 0))   ; 回転角プラス正面視点位置定数格納用
  (setq Exp_S_View  '(-1 0 0))  ; 回転角0側面視点位置定数格納用
  (setq Exp_SM_View '(0 1 0))   ; 回転角マイナス側面視点位置定数格納用
  (setq Exp_SP_View '(0 -1 0))  ; 回転角プラス側面視点位置定数格納用
;;; 側面は左からとしているようである YM
  (setq Exp_Temp_Layer  "EXP_TEMP_LAYER")  ; 伸縮作業用画層名

  ;; 伸縮作業用テンポラリ画層の作成
  (command "_layer" "N" Exp_Temp_Layer "C" 1 Exp_Temp_Layer "L" SKW_AUTO_LAY_LINE Exp_Temp_Layer "")
  ; 既存の場合"OFF"のことがあるので"ON"にする　01/03/22 YM ADD
  (command "_layer" "T" #strFillLayer "")
  (command "_layer" "ON" #strFillLayer "")

  (setq #bCabFlag 0)
  (setq #SymData$ (CFGetXData &enSym "G_LSYM")); シンボルの "G_LSYM" 拡張データを取得する

  (if (/= #SymData$ nil)                  ; "G_LSYM" データを取得できたかどうかのチェック
    (progn                                ; 取得できた
      (setq #iRad    (nth 2 #SymData$))   ; 取得した拡張データから回転角度(nth 2)を取得する
      (setq #SymPos$ (nth 1 #SymData$))   ; 取得した拡張データから挿入点(nth 1)を取得する
      (setq #Temp$   (nth 9 #SymData$))   ; 性格CODE取得
      (if (= CG_SKK_TWO_UPP (CFGetSeikakuToSKKCode #Temp$ 2))      ; 性格CODEがアッパーキャビネットかどうかのチェック
        (setq #bCabFlag 1)
      )
      (setq #SymData$ (CFGetXData &enSym "G_SYM"))      ; シンボルの "G_SYM" 拡張データを取得する

      (if (/= #SymData$ nil)                        ; "G_SYM" データを取得できたかどうかのチェック
        (progn                                      ; 取得できた
          (setq #iWSize (nth 3 #SymData$))          ; 取得した拡張データから現在の W サイズ(nth 3)を取得する
          (setq #iDSize (nth 4 #SymData$))          ; 取得した拡張データから現在の D サイズ(nth 4)を取得する
          (setq #iHSize (nth 5 #SymData$))          ; 取得した拡張データから現在の H サイズ(nth 5)を取得する
          (setq #iWExp  (nth 11 #SymData$))         ; 取得した拡張データから W 方向(nth 11)の伸縮幅を取得する
          (setq #iDExp  (nth 12 #SymData$))         ; 取得した拡張データから D 方向(nth 12)の伸縮幅を取得する
          (setq #iHExp  (nth 13 #SymData$))         ; 取得した拡張データから H 方向(nth 13)の伸縮幅を取得する
          (setq #SymData$ (entget &enSym))          ; シンボルのデータを取得する
          (setq #enGroup (cdr (assoc 330 #SymData$)))          ; シンボルのグループ名を取得する
          (setq #GrpData$ (entget #enGroup))                   ; グループ内データ(グループ名リスト)を取得する

          (foreach #nn #GrpData$                               ; 2D 図形で伸縮処理を行うデータを絞り込む。ブレークラインを抽出する
            (if (= (car #nn) 340)                              ; グループ構成図形名かどうかのチェック
              (progn                                           ; グループ構成図形名だった
                (setq #Temp$ (entget (cdr #nn)))               ; グループ構成図形名のデータを取得する

                (if (/= (cdr (assoc 0 #Temp$)) "XLINE")        ; グループ構成図形がソリッドデータ(0 . "3DSOLID")以外かどうかのチェック

                  (progn    ; ソリッドデータではなかった
                    (setq #strLayer (cdr (assoc 8 #Temp$)))    ; 画層名の取得
                    (setq #expData$ (cons (list (cdr #nn) #strLayer) #expData$)) ; 図形名と画層名を1リストにして格納する(図形名 画層名)
                    (entmod  ; 伸縮対称図形を伸縮処理画層に移動する
                      (subst (cons 8 Exp_Temp_Layer) (assoc 8 #Temp$) #Temp$)
                    )
                  )
                )
                (if (= (cdr (assoc 0 #Temp$)) "XLINE")                ; グループ構成図形がブレークラインかどうかのチェック
                  (progn    ; ブレークラインだった
                    (setq #Temp$ (CFGetXData (cdr #nn) "G_BRK")); ブレークラインの拡張データを取得
                    (if (/= #Temp$ nil) ; 拡張データが存在するかどうかのチェック
                      (progn    ; 拡張データが存在した
                        (cond ; H,W,D 各ブレークラインの種類毎に図形名を格納する
                          ((= (nth 0 #Temp$) 1) (setq #BrkW$ (cons (cdr #nn ) #BrkW$))); W 方向ブレークラインだった
                          ((= (nth 0 #Temp$) 2) (setq #BrkD$ (cons (cdr #nn ) #BrkD$))); D 方向ブレークラインだった
                          ((= (nth 0 #Temp$) 3) (setq #BrkH$ (cons (cdr #nn ) #BrkH$))); H 方向ブレークラインだった
                        )
                      )
                    )
                  )
                )
              )
            )
          )
          ;; 伸縮処理
          ;; 押し出し方向の判断
          (cond
            ((= #iRad 0) (setq #ViewZ$ Exp_F_View))
            ((< #iRad 0) (setq #ViewZ$ Exp_FM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_FP_View))
          )
          ;; 伸縮を行うサイズのチェック(アッパーキャビネットの場合は +- が逆転)
          (if (and (= #bCabFlag 1) (/= #iHExp 0))
            (progn
              (setq #iExpSize (list 1 (- #iHExp #iHSize) 2))
            )
            ;; else
            (progn
              (setq #iExpSize (list 0 (- #iHExp #iHSize) 1))
            )
          )
          (if (and (/= #BrkH$ nil) (/= #iHExp 0))
            (progn ; ブレークラインを基点から遠い順にソートする
              (setq #BrkH$ (SKESortBreakLine (list 2 #BrkH$) #SymPos$))
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkH$ #iExpSize)              ; H 方向の伸縮処理
              (CFOutStateLog 1 7 "        SKEExpansion=Hブレーク OK")              ; 正常終了
            )
            ;; else
            (progn
              (CFOutStateLog 1 7 "        SKEExpansion=Hブレークなし")              ; 正常終了
            )
          )

          (if (and (/= #BrkW$ nil) (/= #iWExp 0))
            (progn              ; ブレークラインを基点から遠い順にソートする
              (setq #BrkW$ (SKESortBreakLine (list 0 #BrkW$) #SymPos$))
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkW$ (list 2 (- #iWExp #iWSize))) ; W 方向の伸縮処理
              (CFOutStateLog 1 7 "        SKEExpansion=Wブレーク OK")              ; 正常終了
            )
            ;; else
            (progn
              (CFOutStateLog 1 7 "        SKEExpansion=Wブレークなし")              ; 正常終了
            )
          )

          (cond          ;; 押し出し方向の判断
            ((= #iRad 0) (setq #ViewZ$ Exp_S_View))
            ((< #iRad 0) (setq #ViewZ$ Exp_SM_View))
            ((> #iRad 0) (setq #ViewZ$ Exp_SP_View))
          )
          (if (and (/= #BrkD$ nil) (/= #iDExp 0))
            (progn
              (setq #BrkD$ (SKESortBreakLine (list 1 #BrkD$) #SymPos$))              ; ブレークラインを基点から遠い順にソートする
              ;; D 方向の伸縮処理
;;;             (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 3 (- #iDExp #iDSize)))
;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU T)
;--2011/07/21 A.Satoh Add - E
              (SKEFigureExpansion #expData$ #ViewZ$ #BrkD$ (list 2 (- #iDExp #iDSize)))
 ;--2011/07/21 A.Satoh Add - S
              (setq CG_OKU nil)
;--2011/07/21 A.Satoh Add - E
             (CFOutStateLog 1 7 "        SKEExpansion=Dブレーク OK")              ; 正常終了
            )
            ;; else
            (progn
              (CFOutStateLog 1 7 "        SKEExpansion=Dブレークなし")              ; 正常終了
            )
          )

          (foreach #nn #expData$ ; 伸縮作業画層から元の画層に図形データを移動する
            (setq #Temp$ (entget (nth 0 #nn) '("*")))
            (entmod
              (subst (cons 8 (nth 1 #nn)) (cons 8 Exp_Temp_Layer) #Temp$)
            )
          )
          (CFOutStateLog 1 7 "      SKEExpansion=OK End")          ;; 正常終了
          T    ; return;
        )
        ;; else
        (progn    ; シンボルの拡張データを取得できなかった
          (CFOutStateLog 0 7 "      SKEExpansion=\"G_SYM\"拡張データを取得できませんでした error End")          ; 異常終了
          nil    ; return;
        )
      )
    )
    ;; else
    (progn    ; 拡張データを取得できなかった
      (CFOutStateLog 0 7 "      SKEExpansion=\"G_LSYM\"拡張データを取得できませんでした error End")      ; 異常終了
      nil    ; return;
    )
  )
)
;SKEExpansion

(princ)
