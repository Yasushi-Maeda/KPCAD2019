;<HOM>*************************************************************************
; <関数名>    : CFGetXData
; <処理概要>  : 図形の拡張データを取得する
; <戻り値>    :
;        LIST : 拡張データの内容のリスト
; <備考>      :
;               Ex.(GetXData #en "KIKI")  -> (20 "SMK" "0")
;                  (GetXData #en "WIRE") -> (8 20 19 "ZYO")
;                  (GetXData #en "*")    -> (20 "SMK" "0")
;*************************************************************************>MOH<
(defun CFGetXData (
    &en     ;(ENT) 図形名
    &apn    ;(STR) アプリケーション名
    /
    #elm #xd$ #ret #lst$ #i
#ename ;-- 2012/02/27 A.Satoh Add
  )
  (setq #xd$ (cdr (cadr (assoc -3 (entget &en (list &apn))))))
;;; ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;; 拡張データ:(-3 ("G_LSYM" (1000 . "0020901") ( ) ...( ) ))

;;; (princ "\n#xd$=")(princ #xd$)
;;; #xd$=((1000 . JBT1-015DL) (1000 . ) (1000 . ) (1040 . 150.0)
;;;       (1040 . 605.0) (1040 . 825.0) (1040 . 0.0) (1070 . 3)
;;;       (1070 . 1) (1070 . 1) (1070 . 1) (1070 . 0)
;;;       (1070 . 0) (1070 . 0) (1070 . 0) (1070 . 0) (1070 . 0))
;;; ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (if #xd$
    (progn
      (setq #i 0)
      (while (< #i (length #xd$))
        (setq #elm (nth #i #xd$))
        (if (= (car #elm) 1005)
;-- 2012/02/27 A.Satoh Mod - S
;;;;;          (setq #elm (cons 1005 (handent (cdr #elm))))
					(progn
						(setq #ename (handent (cdr #elm)))
						(if (= #ename nil)
							(setq #elm (cons 1000 (cdr #elm)))
							(setq #elm (cons 1005 #ename))
						)
					)
;-- 2012/02/27 A.Satoh Mod - E
        )
        (if (= (cdr #elm) "{")
          (progn
            (setq #i (1+ #i))
            (setq #elm (nth #i #xd$))
            (setq #lst$ nil)
            (while (/= (cdr #elm) "}")
              (if (= (car #elm) 1005)
;-- 2012/02/27 A.Satoh Mod - S
;;;;;                (setq #elm (cons 1005 (handent (cdr #elm))))
								(progn
									(setq #ename (handent (cdr #elm)))
									(if (= #ename nil)
										(setq #elm (cons 1000 (cdr #elm)))
										(setq #elm (cons 1005 #ename))
									)
								)
;-- 2012/02/27 A.Satoh Mod - E
              )
              (setq #lst$ (append #lst$ (list (cdr #elm))))
              (setq #i (1+ #i))
              (setq #elm (nth #i #xd$))
            )
            (setq #ret (append #ret (list #lst$)))
          )
        ;else
          (progn
            (setq #ret (append #ret (list (cdr #elm))))
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
  #ret
)
;CFGetXData

;<HOM>*************************************************************************
; <関数名>    : CFSetXData
; <処理概要>  : 図形に拡張データを付加する
; <戻り値>    :
;       ENAME : 拡張データ付加後のｴﾝﾃｨﾃｨ名
; <作成>      : 98-03-25 川本成二
; <備考>      : なし
;*************************************************************************>MOH<
(defun CFSetXData (
    &en     ;(ENT)  図形名
    &apn    ;(STR)  ｱﾌﾟﾘｹｰｼｮﾝ名
    &lst$   ;(LIST) 拡張ﾃﾞｰﾀ付加内容のﾘｽﾄ  (10 "MOJI" 3.456)等
    /
    #eg     ;図形情報
    #xdata$ ;拡張ﾃﾞｰﾀ
    #typ    ;ｼﾝﾎﾞﾙﾀｲﾌﾟ
    #elm    ;拡張ﾃﾞｰﾀ要素
    #elm$   ;
  )
  (setq #xdata$ (list &apn))
  (setq #eg (entget &en))
  (foreach #elm &lst$ ; 拡張ﾃﾞｰﾀ付加内容のﾘｽﾄの各要素
    (setq #typ (type #elm))
    (cond
      ((= #typ 'INT)  ;整数
        (setq #elm$ (cons 1070 #elm))
      )
      ((= #typ 'REAL) ;実数
        (setq #elm$ (cons 1040 #elm))
      )
      ((= #typ 'STR)  ;文字列
        (setq #elm$ (cons 1000 #elm))
      )
      ((= #typ 'LIST) ;ﾘｽﾄ
        (setq #elm$ (cons 1010 #elm))
      )
      ((= #typ 'ENAME) ;図形ﾊﾝﾄﾞﾙ
        (setq #elm$ (cons 1005 (cdr (assoc 5 (entget #elm)))))
      )
    );_(cond
    (setq #xdata$ (append #xdata$ (list #elm$)))
  )

  ;// 図形更新
  (entmod (append #eg (list (list -3 #xdata$)))) ; 図形情報に拡張データを付加

  ;// 図形名を返す
  &en ; 引数と同じ
)
;CFSetXData

;<HOM>************************************************************************
; <関数名>    : CFModList
; <処理概要>  : ﾘｽﾄ中の指定要素を変更する
; <戻り値>    :
;        LIST : 変更後のﾘｽﾄ
; <作成>      : 98-03-25 川本成二
; <備考>      : なし
;************************************************************************>MOH<
(defun CFModList (
    &lst$       ;変更要素
    &lst$$      ;対象ﾘｽﾄ
    /
    #i #j
    ;@@@#no #dat$ #NO$ ;00/01/30 HN MOD 重複変数宣言を修正
    #no #dat$
    #lst$ #no$
  )
  (setq #no$  (mapcar 'car &lst$$))
  (setq #dat$ (mapcar 'cadr &lst$$))
  (setq #i 0)
  (setq #j 0)
  (foreach #lst &lst$
    (if (member #i #no$)
      (progn
        (setq #lst$ (cons (nth #j #dat$) #lst$))
        (setq #j (1+ #j))
      )
      (setq #lst$ (cons #lst #lst$))
    )
    (setq #i (1+ #i))
  )
  (reverse #lst$)
)
;CFModList

;<HOM>*************************************************************************
; <関数名>    : CFSetXRecord
; <処理概要>  : 図面に拡張ﾚｺｰﾄﾞを付加する
; <戻り値>    : なし
; <作成>      : 98-03-25 川本成二
; <備考>      : なし
;*************************************************************************>MOH<
(defun CFSetXRecord (
    &symbol   ;(STR) オブジェクトのキー名
    &lst$     ;(LIST)設定するデータ
    /
    #elm #elm$ #elm2 #xname
    #xrec$
    #typ
    #xlist$
  )
  (setq #xlist$ (dictsearch (namedobjdict) &symbol))
  (if (/= #xlist$ nil)
    (entdel (cdr (car #xlist$)))
  )
  ;// Xrecord のデータ リストを作成します
  (setq #xrec$ '((0 . "XRECORD")(100 . "AcDbXrecord")))
  (foreach #elm &lst$
    (setq #typ (type #elm))
    (cond
      ((= #typ 'INT)  ;整数
        (setq #elm$ (cons 62 #elm))
      )
      ((= #typ 'REAL) ;実数
        (setq #elm$ (cons 40 #elm))
      )
      ((= #typ 'STR)  ;文字列
        (setq #elm$ (cons 1 #elm))
      )
      ((= #typ 'LIST) ;ﾘｽﾄ
        ;// 対応できない
        (princ)
      )
      ((= #typ 'ENAME) ;図形名
        ;// 対応できない
        (princ)
      )
    )
    (setq #xrec$ (append #xrec$ (list #elm$)))
  )
  ;// entmakex を使って、オーナーのない Xrecord を作成します
  (setq #xname (entmakex #xrec$))
  ;// 新しい Xrecord を、名前の付いたオブジェクト ディクショナリに
  ;// 追加します
  (dictadd (namedobjdict) &symbol #xname)
)
;CFSetXRecord

;<HOM>*************************************************************************
; <関数名>    : CFGetXRecord
; <処理概要>  : 図面の拡張ﾚｺｰﾄﾞを取得する
; <戻り値>    :
;        LIST : 拡張ﾚｺｰﾄﾞの内容のﾘｽﾄ
; <作成>      : 98-03-25 川本成二
; <備考>      : なし
;*************************************************************************>MOH<
(defun CFGetXRecord (
  &symbol
  /
  #xlist$
  #elm
  #ret
  #i
  #loop
  )
  ; 名前の付いたオブジェクト ディクショナリで Xrecord を検索します
  (setq #xlist$ (dictsearch (namedobjdict) &symbol))
  (if (/= #xlist$ nil)
    (progn
      (setq #i 0)
      (setq #loop T)
      (while #loop
        (setq #elm (nth #i #xlist$))
        (if (= (car #elm) 100)
          (setq #loop nil)
        )
        (setq #i (1+ #i))
      )
      (while (/= nil (setq #elm (nth #i #xlist$)))
        (setq #ret (append #ret (list (cdr #elm))))
        (setq #i (1+ #i))
      )
      #ret
    )
  )
  ; 00/01/20 HN S-ADD 2000用に変更 #ret → (cdr #ret)
  (if (= "14" (substr (getvar "acadver") 1 2))
      #ret
      (cdr #ret)
  )
  ; 00/01/20 HN E-ADD 2000用に変更 #ret → (cdr #ret)
)
;CFGetXRecord

;<HOM>************************************************************************
; <関数名>    : CFDelListItem
; <処理概要>  : リスト中の指定要素を削除する
; <戻り値>    :
;      リスト : 削除後のリスト
;
; <備考>      : 始めにみつかった要素のみ削除
;               DelListItem は Common.lsp
;************************************************************************>MOH<
(setq CFDelListItem DelListItem)

;<HOM>***********************************************************************
; <関数名>   : CFAreaInPt
; <機能概要> : 注目点に対する多角形の内外判定を行う。
; <戻り値>   :
;        INT : -1:OUTSIDE 0:ON_LINE 1:INSIDE
; <備考>     : なし
;***********************************************************************>MOH<*/
(defun CFAreaInPt (
    &pt      ; lNX : 注目点Ｘ座標
            ; lNY : 注目点Ｙ座標
    &plst$  ; 多角形頂点リスト
    /
    #x1 #y1 #x2 #y2 #aa #bb #cc #dd #i #cnt #dx #dy #eps #ret #cc
  )
  ;// 初期化
  (setq #cnt 0)
  (setq #eps 0.000001)
  ;// 注目点から引いた反直線上の交点をカウントする
  (setq #x2 (car (car &plst$)))
  (setq #y2 (cadr(car &plst$)))
  (setq #i 1)
  (setq #ret nil)
  (while (and (< #i (length &plst$))(= nil #ret))
    (setq #x1 #x2
      #y1 #y2
      #x2 (car (nth #i &plst$))
      #y2 (cadr(nth #i &plst$))
    )
    ;// 境界線の場合
    (if (equal &pt (list #x1 #y1 ) #eps)
      (setq #ret 0)
    )
    (if (and (= nil #ret)(/= &pt (list #x1 #y1 )))
      (progn
        (setq #aa (- #y1 #y2)
          #bb (- #x2 #x1)
          #cc (- (* #aa #x1 -1)(* #bb #y1))
          #dd (+ (* #aa #aa) (* #bb #bb))
          #dx (/ (- (* #bb #bb (car &pt))
                (* #aa #bb (cadr &pt))
                (* #aa #cc  ))
                #dd
              )
        #dy (/ (+ (* #aa #bb (car &pt) -1)
                (* #aa #aa (cadr &pt))
                (* #bb #cc -1))
                #dd
              )
        )
        (if (and (or (<= (*(- #dx #x1)(- #dx #x2) 0.)) (== #bb 0. ))
                 (or (<= (*(- #dy #y1)(- #dy #y2) 0.)) (== #aa 0. ))
                 (< (+ (*(- #dx (car &pt))(- #dx (car &pt)))
                       (*(- #dy (cadr &pt))(- #dy (cadr &pt)))
                   )
                   #eps
                 )
            )
            (setq #ret 0)
        )
      )
    )
    (if
      (and
        (or(and(<= #y1 (cadr &pt))(<(cadr &pt) #y2))
           (and(<= #y2 (cadr &pt))(<(cadr &pt) #y1))
        )
        (= nil #ret)
      )
      (if (> (/ (*(- #x2 #x1) (-(cadr &pt) #y1)) (- #y2 #y1))
             (- (car &pt) #x1)
          )
        (setq #cnt(1+ #cnt))
      )
    )
    (setq #i (1+ #i))
  )
  (if(= nil #ret)
    (setq #ret (1-(* 2(rem #cnt 2))))
  )
  #ret
)
;CFAreaInPt

;;<HOM>*************************************************************************
;; <関数名>    : CFGetSameGroupSS
;; <処理概要>  : 同一のﾒﾝﾊﾞｰｴﾝﾃｨﾃｨを取出す
;; <戻り値>    :
;;        LIST : ﾒﾝﾊﾞｰｴﾝﾃｨﾃｨ選択ｾｯﾄ
;; <作成>      : 98-03-25 川本成二
;; <備考>      : なし
;;*************************************************************************>MOH<
;(defun CFGetSameGroupSS (
;    &en
;    /
;    #eg$
;    #lst
;    #ss
;  )
;  (setq #ss (ssadd))
;  (setq #eg$ (entget (cdr (assoc 330 (entget &en)))))  ;// 親図面情報を取得
;  (foreach #lst #eg$  ;// ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰ図形の取得
;    (if (= 340 (car #lst))
;      (setq #ss (ssadd (cdr #lst) #ss))
;    )
;  )
;  #ss
;)
;;CFGetSameGroupSS

;<HOM>*************************************************************************
; <関数名>    : CFGetSameGroupSS
; <処理概要>  : 同一ｸﾞﾙｰﾌﾟのﾒﾝﾊﾞｰｴﾝﾃｨﾃｨを取出す
; <戻り値>    : 選択セット
;        LIST : ﾒﾝﾊﾞｰｴﾝﾃｨﾃｨのﾘｽﾄ (ENAME ENAME ...)
; <作成>      : 98-03-25 川本成二
; <修正>      : 98-07-29 森本かおり
; <備考>      : なし
;*************************************************************************>MOH<
(defun CFGetSameGroupSS (
    &en      ; (ENAME)    シンボル図形名
    /
    #ss #en$ #eg$ #eg #gen #geg$ #en
  )

  (setq #ss (ssadd)) ; 新規
  (setq #en$ nil)
  (setq #eg$ (entget &en)) ; 引数図形名ｴﾝﾃｨﾃｨｰ ﾃﾞｰﾀ

  (foreach #eg #eg$
    (if (= 330 (car #eg))
      (progn
        (setq #gen  (cdr #eg))                ; 330 図形名
        (setq #geg$ (entget #gen))            ; 330 ｴﾝﾃｨﾃｨｰ ﾃﾞｰﾀ

;;;       (princ "\n (length #geg$) = ")(princ (length #geg$))  ; @YM@ 00/01/27

        (foreach #geg #geg$
          (if (= 340 (car #geg))
            (progn
;;;             (setq #ss (ssadd (cdr #geg) #ss)) ; 340 図形名
              (ssadd (cdr #geg) #ss)  ; @YM@ 00/01/27
            );_progn
            ;(setq #en$ (cons (cdr #geg) #en$))
          )
        );_foreach
      )
    );_if
  )
  #ss
)
;CFGetSameGroupSS

;<HOM>*************************************************************************
; <関数名>    : CFDrawRectOrRegionTransUcs
; <処理概要>  : ﾀｲﾌﾟにより、矩形または領域のﾎﾟﾘﾗｲﾝを作図させる
; <戻り値>    :
;        LIST : 作成した点列
; <作成>      : 97-05-07 川本成二
; <備考>      :
;*************************************************************************>MOH<
(defun CFDrawRectOrRegionTransUcs (
    &type   ;(INT)1:矩形入力 2:領域入力
    /
    #p1 #p2 #pt$
    #en$
  )
  ;// 矩形か領域のﾎﾟﾘﾗｲﾝを作図させる
  (if (= &type 1)
    ;// 矩形領域
    (progn
      (setq #p1 (getpoint "\n始めの点: "))
      (setq #p2 (getcorner #p1 "\n次の点: "))
      (if (< (cadr #p1) (cadr #p2))
        (setq #pt$
          (list
            ;;#p1
            (list (car #p1) (cadr #p1) 0.0)
            (list (car #p2) (cadr #p1) 0.0)
            ;;#p2
            (list (car #p2) (cadr #p2) 0.0)
            (list (car #p1) (cadr #p2) 0.0)
          )
        )
      ;else
        (setq #pt$
          (list
            ;;#p1
            (list (car #p1) (cadr #p1) 0.0)
            (list (car #p1) (cadr #p2) 0.0)
            ;;#p2
            (list (car #p2) (cadr #p2) 0.0)
            (list (car #p2) (cadr #p1) 0.0)
          )
        )
      )
      (MakeCmLwPolyLine #pt$ "C")
    )
  ;else
    ;// 領域
    (progn
      (setq #pt$ (CFGetDrawPlinePt 1))
      (MakeCmLwPolyLine #pt$ "C")
    )
  )
  #pt$
)
;CFDrawRectOrRegionTransUcs

;<HOM>*************************************************************************
; <関数名>    : CFGetDrawPlinePt
; <処理概要>  : 連続する線を作図させその端点のリストを取得する
; <戻り値>    :
;        LIST : 作成した点列
; <作成>      : 97-05-07 川本成二
; <備考>      :
;*************************************************************************>MOH<
(defun CFGetDrawPlinePt (
    &mode         ;(INT) 閉じるを有効とするか(メッセージのみ)
                  ;      0:無効
                  ;      1:有効
    /
    #en$ #loop #msg #p1 #p2 #pt$ #os
  )
  (setq #loop T)
  (setq #msg "\n始めの点: ")
  (setq #p1 (getpoint "\n始めの点: "))
  (setq #p1 (list (car #p1) (cadr #p1)))
  (setq #pt$ (list #p1))
  (while (= T #loop)
    (initget "U C")
    (if (/= nil #p1)
      (if (= &mode 1)
        (setq #p2 (getpoint #p1 "\n次の点/U=戻る/C=閉じる: "))
        (setq #p2 (getpoint #p1 "\n次の点/U=戻る : "))
      )
    )
    (cond
      ((or (= "C" #p2) (= nil #p2))
        (setq #loop nil)
      )
      ((= "U" #p2)
        (setq #p1 (trans (cdr (assoc 10 (entget (car #en$)))) 0 1))
        (entdel (car #en$))
        (setq #en$ (cdr #en$))
        (setq #pt$ (cdr #pt$))
      )
      (T
        (setq #p2 (list (car #p2) (cadr #p2)))
        (setq #pt$ (cons #p2 #pt$))
        (setq #os (getvar "OSMODE"))
        (setvar "OSMODE" 0)
        (command "_line" #p1 #p2 "")
        (setvar "OSMODE" #os)
        (setq #p1 #p2)
        (setq #en$ (cons (entlast) #en$))
      )
    )
  )
  (mapcar 'entdel #en$)
  (setq #pt$ (reverse #pt$))
)
;CFGetDrawPlinePt

;<HOM>*************************************************************************
; <関数名>    : CFGetGroupEnt
; <処理概要>  : 同一ｸﾞﾙｰﾌﾟのﾒﾝﾊﾞｰｴﾝﾃｨﾃｨを取出す
; <戻り値>    :
;        LIST : ﾒﾝﾊﾞｰｴﾝﾃｨﾃｨのﾘｽﾄ (ENAME ENAME ...)
; <作成>      : 98-03-25 川本成二
; <備考>      : なし
;*************************************************************************>MOH<
(defun CFGetGroupEnt (
    &en       ;(ENAME)任意のグループ内の図形
    /
    #en #eg$ #lst #en$ #geg$ #gen
  )
  (setq #en$ nil)
  (setq #eg$ (entget &en))
  (foreach #eg #eg$
    (if (= 330 (car #eg))
      (progn
        (setq #gen  (cdr #eg))
        (setq #geg$ (entget #gen))
        (foreach #geg #geg$
          (if (= 340 (car #geg))
            (if (assoc 8 (entget (cdr #geg))) ; 00/02/17 HN ADD 画層名のnilチェックを追加
              (setq #en$ (cons (cdr #geg) #en$))
            )
          )
        )
      )
    )
  )
  #en$
)
;CFGetGroupEnt

;<HOM>*************************************************************************
; <関数名>    : CFublock
; <処理概要>  : 名前のない複合図形の作成
; <戻り値>    :
; <作成>      : 98-04-28
; <備考>      :
;*************************************************************************>MOH<
(defun CFublock (
    &pt       ;(LIST)   ブロック基点
    &ss       ;(PICKSET)ブロック化する図形選択セット
    /
    #i #eg #name
  )
  (entmake (list '(0 . "BLOCK")'(2 . "*Uxx")'(70 . 1)(cons 10 &pt)))
  (setq #i 0)
  (repeat (sslength &ss)
    (setq #eg (entget (ssname &ss #i)))
    (entmake  (cdr #eg))
    (setq #i  (1+ #i))
  )
  (setq #name (entmake '((0 . "ENDBLK"))))
  (setq #i 0)
  (repeat (sslength &ss)
    (entdel (ssname &ss #i))
    (setq #i (1+ #i))
  )
  (entmake (list '(0 . "INSERT")(cons 2 #name)(cons 10 &pt)))
)
;CFublock

;<HOM>*************************************************************************
; <関数名>    : CFListSort
; <処理概要>  : リストのリストを指定要素番号でソートする
; <戻り値>    : ソートされたリストのリスト
; <作成>      : 1998-08-13
; <備考>      :
;*************************************************************************>MOH<
(defun CFListSort (
    &llist$$   ;リストのリスト
    &key       ;ソートするリストの要素番号 0 ～
    /
    #number_items       #partition_size
    #number_partitions  #first_index
    #last_index         #unsorted
    #count              #ptr_lst
    #sorted_list        #i         #j
    #t1                 #t2
  )

  (if (and &llist$$ &key)
    (progn
      (setq #number_items (length &llist$$)
            #partition_size #number_items
            #ptr_lst nil                  ;pointer list
            #count 0
            #unsorted T                   ;assume list #is not sorted
      )

      (while (< #count #number_items)
        (setq #ptr_lst (append #ptr_lst (list #count)) ;built pointer list
              #count (1+ #count)
        )
      ) ;while

    ;------------------------------------------------------------------

      (while #unsorted

        (setq #partition_size (fix (/ (1+ #partition_size) 2))
              #number_partitions (fix (/ #number_items #partition_size))
        )

        (if (= #partition_size 1)
          (setq #unsorted nil)       ;assume list #is sorted
        )

        (if (/= (rem #number_items #partition_size) 0)
          (setq #number_partitions (1+ #number_partitions))
        )
        (setq #first_index 0
              #i 1
        )
        (while (< #i #number_partitions)
          (setq #last_index (+ #first_index #partition_size))

          (if (> #last_index (- #number_items #partition_size))
            (setq #last_index (- #number_items #partition_size))
          )

          ;loop thru and test (j) to (j+offset) in pointer list

          (setq #j #first_index)
          (while (< #j #last_index)
            (if (> (nth &key (nth (nth #j #ptr_lst) &llist$$))
                   (nth &key (nth
                      (nth (+ #j #partition_size) #ptr_lst) &llist$$)
                   )
                )

              ; then swap items in pointer list
              (setq #t1 (nth #j #ptr_lst)
                    #t2 (nth (+ #j #partition_size) #ptr_lst)
                    #ptr_lst (subst #t2 -1
                              (subst #t1 #t2
                                (subst -1 #t1 #ptr_lst)
                              )
                            )
                    #unsorted T
              ) ;setq
            ) ;if

            (setq #j (1+ #j))

          ) ;while #j

          (setq #first_index (+ #first_index #partition_size)
                #i (1+ #i)
          )

        ) ;while #i


      ) ;while #unsorted

    ;------------------------------------------------------------------
      ;Build new list using sorted pointers

      (setq #count 0 #sorted_list nil)
      (while (< #count #number_items)
        (setq #sorted_list
                (append #sorted_list        ;build updated list
                  (list
                    (nth
                      (nth #count #ptr_lst)  ;pointer
                      &llist$$
                    )
                  )
                )
              #count (1+ #count)
        ) ;setq
      ) ;while

      #sorted_list                          ;return sorted list
    ) ;progn

    ;else
    nil
  ) ;if
)
;CFListSort

;<HOM>*************************************************************************
; <関数名>    : CFMargeSort
; <処理概要>  : リストのマージソートを行う
; <戻り値>    : ソートされたリスト
; <作成>      : 97-02-17
; <作成者>    : 中村 靖
; <備考>      : なし
;*************************************************************************>MOH<
(defun CFMargeSort (
    &L1$  ;(LIST)ソートを行うリスト
    /
    #flg #i1 #itmp #L2$ #Ltmp$
  )
  (if (and(= 'LIST(type &L1$))(/= 0 (length &L1$)))
    (progn
      (setq #i1 1)                                  ;#i1     &L1$$ｶｳﾝﾀ
      (setq #Ltmp$ '())                             ;#Ltmp$  一時比較用ﾘｽﾄ
      (setq #L2$   '())                             ;#Ltmp$  一時比較用ｶｳﾝﾀ
      (setq #Ltmp$ (cons (nth 0 &L1$) #Ltmp$))      ;#L2$    結果ﾘｽﾄ(返値)
      (setq #L2$   #Ltmp$)                          ;#flg    挿入前 nil   挿入後 T
      (while (< #i1 (length   &L1$))
        (setq #Ltmp$ (reverse #L2$))
        (setq #L2$ '())
        (setq #itmp   0)
        (setq #flg nil)
        (while (< #itmp (length #Ltmp$))
          (cond
            ((> (nth #i1 &L1$)(nth #itmp #Ltmp$))                     ;比較値より小
              (setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
            )
            ((and (= #flg nil)(<= (nth #i1 &L1$)(nth #itmp #Ltmp$)))  ;比較値より大
              (setq #L2$ (cons (nth #i1    &L1$  ) #L2$))
              (setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
              (setq #flg T)
            )
            (T                                                        ;代入後
              (setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
            )
          )
          (setq #itmp (1+ #itmp))
        )
        (if (= #flg nil)                                              ;比較値が最大
          (setq #L2$ (cons (nth #i1    &L1$  ) #L2$))
        )
        (setq #i1 (1+ #i1))
      )
      (reverse #L2$)
    )
  )
)
;CFMargeSort

;<HOM>*************************************************************************
; <関数名>    : CFAlertErr
; <処理概要>  : 警告ダイアログ表示後、エラー終了
; <戻り値>    : なし
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun CFAlertErr (
    &msg        ;(STR)メッセージ内容
  )
  (c:msgbox &msg "警告" (logior MB_OK MB_ICONEXCLAMATION))
;;;  (*error*)
)
;CFAlertErr

;<HOM>*************************************************************************
; <関数名>    : CFAlertMsg
; <処理概要>  : 警告ダイアログ表示
; <戻り値>    : なし
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun CFAlertMsg (
    &msg        ;(STR)メッセージ内容
  )
  (c:msgbox &msg "警告" (logior MB_OK MB_ICONEXCLAMATION))
)
;CFAlertMsg

;<HOM>*************************************************************************
; <関数名>    : CFYesNoDialog
; <処理概要>  : 確認ダイアログ表示(Yes,Cancel)
; <戻り値>    :
;           T : はい
;         nil : いいえ
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun CFYesNoDialog (
    &msg        ;(STR)メッセージ内容
  )
  (if (= IDYES (c:msgbox &msg "確認" (logior MB_YESNO MB_ICONQUESTION)))
    T
    nil
  )
)
;CFYesNoDialog

;<HOM>*************************************************************************
; <関数名>    : CfYesNoJpDlg
; <処理概要>  : 確認ダイアログ(はい,いいえ)
; <戻り値>    : T:(はい)  nil:(いいえ)
; <作成>      : 00/08/04 MH
; <備考>      :
;*************************************************************************>MOH<
(defun CfYesNoJpDlg (
  &sMSG       ;(文字列) 確認メッセージ
  &sDFO       ;(文字列) "Yes" "No" どちらをデフォルトに？
  /
  #dcl_id #ret
  )
  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (not (new_dialog
    (if (= "YES" (strcase &sDFO)) "YesDefo_No_Dlg" "Yes_NoDefo_Dlg") #dcl_id)) (exit))
  (set_tile "msg" &sMSG)
  (action_tile "accept" "(setq #ret T)  (done_dialog)")
  (action_tile "cancel" "(setq #ret nil)(done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret
); CfYesNoJpDlg

;<HOM>*************************************************************************
; <関数名>    : CFAlertYesNoDialog
; <処理概要>  : 警告ダイアログ表示(Yes,Cancel)
; <戻り値>    :
;           T : はい
;         nil : いいえ
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun CFAlertYesNoDialog (
    &msg        ;(STR)メッセージ内容
  )
  (if (= IDYES (c:msgbox &msg "警告" (logior MB_YESNO MB_ICONASTERISK)))
    T
    nil
  )
)
;CFAlertYesNoDialog

;<HOM>*************************************************************************
; <関数名>    : CFYesNoCancelDialog
; <処理概要>  : 確認ダイアログ表示(Yes,No,Cancel)
; <戻り値>    :
;    ID_YES   : はい
;    ID_CANCEL: キャンセル
;    ID_NO    : いいえ
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun CFYesNoCancelDialog (
    &msg        ;(STR)メッセージ内容
    /
    #ret
  )
  (c:msgbox &msg "確認" (logior MB_YESNOCANCEL MB_ICONQUESTION))
)
;CFYesNoCancelDialog

;<HOM>*************************************************************************
; <関数名>    : CFYesDialog
; <処理概要>  : 確認ダイアログ表示(Yes)
; <戻り値>    :
;    ID_YES   : はい
; <作成>      : 1999-10-05
; <備考>      :
;*************************************************************************>MOH<
(defun CFYesDialog (
    &msg        ;(STR)メッセージ内容
  )
  (c:msgbox &msg "確認" (logior MB_OK MB_ICONASTERISK))
)
;CFYesDialog

;<HOM>************************************************************************
; <関数名>    : CFModListItem
; <処理概要>  : ﾘｽﾄ中の指定要素を変更する
; <戻り値>    :
;        LIST : 変更後のﾘｽﾄ
; <作成>      : 98-03-25 川本成二
; <備考>      : なし
;************************************************************************>MOH<
(defun CFModListItem (
    &mem      ;(???) 変更要素
    &n        ;(INT) 変更要素番号
    &list$    ;(LIST)対象ﾘｽﾄ
    /
  )
  (cond
    ((equal &n 1)
      (cons &mem (cdr &list$))
    )
    (T
      (cons (car &list$) (CFModListItem &mem (1- &n) (cdr &list$)))
    )
  )
)
;CFModListItem

;<HOM>************************************************************************
; <関数名>    : CFarea_rl
; <処理概要>  : 点のベクトルに対する左右の判定
; <戻り値>    :
;         INT : 1:左 -1:右 0:延長線上
;
; <作成>      : 97-03-18 中村靖
; <備考>      : pp が sp -> ep の左右どちらにあるか判定する
;
;                                           pp( 1)
;
;                 sp =============> ep      pp( 0)
;
;                                           pp(-1)
;************************************************************************>MOH<
(defun CFArea_rl (
    &sp     ;(LIST)ベクトルの一点目
    &ep     ;(LIST)ベクトルの二点目
    &pp     ;(LIST)判定する点
    /
    #RL
  )
  (setq #RL(- (* (-(car &ep)(car &sp))(-(cadr &pp)(cadr &sp)))
              (* (-(car &pp)(car &sp))(-(cadr &ep)(cadr &sp)))
           )
  )
  (cond ((> #RL 0) 1)       ;左
        ((< #RL 0)-1)       ;どちらでもない
        (T        0)        ;右
  )
)
;CFarea_rl

;<HOM>*************************************************************************
; <関数名>    : CFGetDropPt
;
; <処理概要>  : 指定点から指定線分に対しての垂点を返す
;
; <戻り値>    : 垂直交点座標 (px py 0) : 正常
;               nil                    : 求まらない
;
; <備考>      :
;                                       ／
;                                     ／
;                     求まった座標→＊
;                                 ／  ＼
;                               ／      ＼
;                                         ＼
;                                           ＼    &pt$
;                                             + ←指定座標
;*************************************************************************>MOH<
(defun CFGetDropPt (
    &pt    ;(LIST)座標
    &pt$   ;(LIST)始終点座標リスト
    /
    #eg #pls #ple #ans #ang #ptv
  )
  ;// 指定線分エンティティから始終点を取り出す
  (setq #pls (nth 0 &pt$))
  (setq #ple (nth 1 &pt$))

  ;// 始点を中心とした終点の角度を求める
  (setq #ang  (angle #pls #ple))

  ;// 指定点から指定線分に垂直な長さ10の仮想線分を作成
  (setq #ptv  (polar &pt (+ #ang(/ PI 2.)) 10))

  ;// 指定線分と仮想線分の仮想交点を求める
  (setq #ans (inters #pls #ple &pt #ptv nil))

  ;// 垂点を返す
  #ans
)
;CFGetDropPt

;<HOM>*************************************************************************
; <関数名>    : CFCnvElistToSS
; <処理概要>  : 図形リストを選択セットに変換する
; <戻り値>    :
;     PICKSET : 選択セット
; <備考>      :
;*************************************************************************>MOH<
(defun CFCnvElistToSS (
    &en$             ;(LIST)図形リスト
    /
    #ss
    #en
  )
  (setq #ss (ssadd))
  (foreach #en &en$
    (ssadd #en #ss)
  )
  #ss
)
;CFCnvElistToSS

;;;<HOM>***********************************************************************
;;; <関数名>    : CfDwgOpenByScript
;;; <処理概要>  : 図面ファイルをオープンする。
;;; <戻り値>    : なし
;;; <作成>      : 2000/02/03 中村 博伸
;;; <備考>      : オープン用のスクリプト-ファイルを作成して、呼び出します。
;;;               (command ".OPEN") の方式では、Acad.lspを自動読込みしない為。
;;;***********************************************************************>MOH<
(defun CfDwgOpenByScript (
  &sFileOpen    ; オープン-ファイル名
  /
  #sFileScr     ; スクリプト-ファイル名
  #pFileScr     ; スクリプト-ファイルのファイル-ポインタ
  )

  (if (/= nil (findfile &sFileOpen))
    (progn
      ;00/08/29 HN MOD パス指定追加
      ;@@@(setq #sFileScr "Open.scr")
      (setq #sFileScr (strcat CG_SYSPATH "Open.scr"))

      (setq #pFileScr (open #sFileScr "w"))
      (if (/= nil #pFileScr)
        (progn
          (write-line "_.OPEN" #pFileScr)
          (if (/= 0 (getvar "DBMOD"))
            (write-line "Y" #pFileScr)
          )
          (write-line &sFileOpen #pFileScr)
          (close #pFileScr)
        )
      )
    )
    (progn
      (princ (strcat "\nﾌｧｲﾙ " &sFileOpen " が存在しません。"))
    )
  )

  (command "._SCRIPT" #sFileScr)

  (princ)
) ; CfDwgOpenByScript

;;;<HOM>***********************************************************************
;;; <関数名>    : CfDwgNewByScript
;;; <処理概要>  : 新規図面ファイルをオープンする。
;;; <戻り値>    : なし
;;; <作成>      : 2000/02/03 中村 博伸
;;; <備考>      : オープン用のスクリプト-ファイルを作成して、呼び出します。
;;;               (command ".OPEN") の方式では、Acad.lspを自動読込みしない為。
;;;***********************************************************************>MOH<
(defun CfDwgNewByScript (
  &sFileTemp    ; テンプレート-ファイル名
  /
  #sFileScr     ; スクリプト-ファイル名
  #pFileScr     ; スクリプト-ファイルのファイル-ポインタ
  )

  ;00/08/29 HN MOD パス指定追加
  ;@@@(setq #sFileScr "New.scr")
  (setq #sFileScr (strcat CG_SYSPATH "New.scr"))

  (setq #pFileScr (open #sFileScr "w"))
  (if (/= nil #pFileScr)

    (progn
      (write-line "_.NEW" #pFileScr)
      (if (/= 0 (getvar "DBMOD"))
        (write-line "Y" #pFileScr)
      )
      (write-line &sFileTemp #pFileScr)
      (close #pFileScr)
    )
  )

  (command "._SCRIPT" #sFileScr)

  (princ)
) ; CfDwgNewByScript

;<HOM>*************************************************************************
; <関数名>    : CFRefreshHatchEnt
; <処理概要>  : ハッチング図形を更新する
; <戻り値>    : なし
; <備考>      : ハッチング図形を (entmake) 関数で作成した場合、
;               スケールが現在のスケールに反映されないため、
;               (command "-hatchedit")により属性の再更新しなけ
;               ればならないため本関数を作成した
;  00/02/07 1/31からコピー
;*************************************************************************>MOH<
(defun CFRefreshHatchEnt (;  00/02/07 1/31からコピー
  /
  #flg
  #ss
  #i
  #eHat
  #sPat
  )
  ;ペーパー空間のとき、一度モデル空間に移動し、ハッチングを更新する。
  (if (= 0 (getvar "TILEMODE"))
    (progn
      (setq #flg T)
      (command "_.mspace")
    )
  )
  (setq #ss (ssget "X" '((0 . "HATCH"))))
  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #eHat (ssname #ss #i))
        (setq #sPat (cdr (assoc 2 (entget #eHat))))
        (if (= "SOLID" #sPat)
          (command "_.-hatchedit" #eHat "P" "")
          (command "_.-hatchedit" #eHat "P" "" "" "")
        )
        (setq #i (1+ #i))
      )
    )
  )
  (if (/= nil #flg)
    (command "_.pspace")
  )
)

;00/08/24 SN S-MOD
; ﾈｽﾄされた各関数でｺｰﾙされ外部変数が上書きされるので代入では復帰できない。
; よって、記憶する外部変数をlistにし後入れ先出し法により入れ子に対応する。
; CFNoSnapResetはｺﾏﾝﾄﾞ一連動作の先頭でｺｰﾙする。
; CFNoSnapFinishはｺﾏﾝﾄﾞ一連動作の最後でｺｰﾙする。
;   入れ子のつじつまが合わない時、
;   強制的に一番最初に入れたﾃﾞｰﾀを取り外部変数をﾘｾｯﾄする。
;

(defun CFNoSnapStart ();  00/02/07 1/31からコピー
  ;ﾘｽﾄの先頭に最終のｼｽﾃﾑ変数を追加
  (setq CG_OSMODE   (cons (getvar "OSMODE")   CG_OSMODE))

	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(setq CG_3DOSMODE  (cons (getvar "3DOSMODE" ) CG_3DOSMODE ));2011/06/30 YM ADD
  		(setq CG_UCSDETECT (cons (getvar "UCSDETECT") CG_UCSDETECT))
		)
	);_if
  (setq CG_SNAPMODE (cons (getvar "SNAPMODE") CG_SNAPMODE))

  (setvar "OSMODE"   0)


	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(setvar "3DOSMODE"  1) ;2011/06/30 YM ADD
			(setvar "UCSDETECT" 0) ;ダイナミック UCS をアクティブにしない 2011/10/11 YM ADD
		)
	);_if
  (setvar "SNAPMODE" 0)
);defun



(defun CFNoSnapEnd ();  00/02/07 1/31からコピー
  ;ﾘｽﾄの先頭からｼｽﾃﾑ変数を設定
  (if (car CG_OSMODE)   (setvar "OSMODE"   (car CG_OSMODE)))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(if (car CG_3DOSMODE)  (setvar "3DOSMODE"  (car CG_3DOSMODE )));2011/06/30 YM ADD
  		(if (car CG_UCSDETECT) (setvar "UCSDETECT" (car CG_UCSDETECT)))
		)
	);_if
  (if (car CG_SNAPMODE) (setvar "SNAPMODE" (car CG_SNAPMODE)))

  ;ﾘｽﾄ再作成
  (setq CG_OSMODE   (cdr CG_OSMODE))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
	  	(setq CG_3DOSMODE  (cdr CG_3DOSMODE ));2011/06/30 YM ADD
	  	(setq CG_UCSDETECT (cdr CG_UCSDETECT))
		)
	);_if
  (setq CG_SNAPMODE (cdr CG_SNAPMODE))
)
(defun CFNoSnapReset()
  (setq CG_OSMODE   '())
  (setq CG_3DOSMODE   '());2011/06/30 YM ADD
  (setq CG_SNAPMODE '())
)
(defun CFNoSnapFinish()
  ;ﾘｽﾄの最後からｼｽﾃﾑ変数を設定
  (if (last CG_OSMODE)   (setvar "OSMODE"   (last CG_OSMODE)))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(if (last CG_3DOSMODE)  (setvar "3DOSMODE"  (last CG_3DOSMODE )));2011/06/30 YM ADD
  		(if (last CG_UCSDETECT) (setvar "UCSDETECT" (last CG_UCSDETECT)))
		)
	);_if
  (if (last CG_SNAPMODE) (setvar "SNAPMODE" (last CG_SNAPMODE)))
  (CFNoSnapReset)
)
;(defun CFNoSnapStart ();  00/02/07 1/31からコピー
;  (setq CG_OSMODE   (getvar "OSMODE"))
;  (setq CG_SNAPMODE (getvar "SNAPMODE"))
;  (setvar "OSMODE"   0)
;  (setvar "SNAPMODE" 0)
;)
;(defun CFNoSnapEnd ();  00/02/07 1/31からコピー
;  (setvar "OSMODE"   CG_OSMODE)
;  (setvar "SNAPMODE" CG_SNAPMODE)
;)
;00/08/24 SN E-MOD
;<HOM>*************************************************************************
; <関数名>    : CFCmdDefStart
; <処理概要>  : コマンド実行時に
;               スナップ・グリッド・直交モード・Ｏスナップ
;               をデフォルト設定する。
; <引数>      : &mode ﾋﾞｯﾄ演算 それぞれの和で設定する。
;               0:全てOFF
;               1:スナップモード　ＯＮ
;               2:グリッドモード　ＯＮ
;               4:直交モード　　　ＯＮ
;               8:ＯスナップモードＯＮ
;               例)配置ｺﾏﾝﾄﾞ              &mode=7  ON ON ON OFF
;                  ｷｬﾋﾞﾈｯﾄを選択するｺﾏﾝﾄﾞ &mode=6 OFF ON ON OFF
; <戻り値>    : なし
; <作成>      : 00/09/07 SN
; <備考>      :
;*************************************************************************>MOH<
;開始
(defun CFCmdDefStart ( &mode )
  ;ﾘｽﾄの先頭に最終のｼｽﾃﾑ変数を追加
  (setq CG_DEFSNAPMODE  (cons (getvar "SNAPMODE" ) CG_DEFSNAPMODE ))
  (setq CG_DEFGRIDMODE  (cons (getvar "GRIDMODE" ) CG_DEFGRIDMODE ))
  (setq CG_DEFORTHOMODE (cons (getvar "ORTHOMODE") CG_DEFORTHOMODE))
  (setq CG_DEFOSMODE    (cons (getvar "OSMODE"   ) CG_DEFOSMODE   ))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
	  	(setq CG_DEF3DOSMODE   (cons (getvar "3DOSMODE" )  CG_DEF3DOSMODE  ));2011/06/30 YM ADD
	  	(setq CG_DEFUCSDETECT  (cons (getvar "UCSDETECT" ) CG_DEFUCSDETECT ))
		)
	);_if

  (if &mode (progn
    ;それぞれのビットによりＯＮ／ＯＦＦを切り替える
    (if (= (rem &mode 2) 1);ｽﾅｯﾌﾟﾓｰﾄﾞ
      (setvar "SNAPMODE"  1)
      (setvar "SNAPMODE"  0)
    )
    (if (= (rem (lsh &mode -1) 2) 1);ｸﾞﾘｯﾄﾞﾓｰﾄﾞ
      (setvar "GRIDMODE"  1)
      (setvar "GRIDMODE"  0)
    )
    (if (= (rem (lsh &mode -2) 2) 1);直交ﾓｰﾄﾞ
      (setvar "ORTHOMODE" 1)
      (setvar "ORTHOMODE" 0)
    )
    (if (= (rem (lsh &mode -3) 2) 1);Oｽﾅｯﾌﾟﾓｰﾄﾞ
			(progn
	      ;設置値を保持しつつOFFの場合は設定する。
	      (if (> (car CG_DEFOSMODE) 16383) (setvar "OSMODE" (- (car CG_DEFOSMODE) 16384)))
			)
			;else
			(progn
				(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
					(progn
						;2011/06/30 YM ADD-S【OSNAP OFF】3DOSNAPもついでに一緒にOFFにする
						(setvar "3DOSMODE"  1) ;すべての 3D オブジェクト スナップを無効にする
						(setvar "UCSDETECT" 0) ;ダイナミック UCS をアクティブにしない 2011/10/11 YM ADD
					)
				);_if
	      ;設置値を保持しつつOFFにする(osnap)
	      (if (< (car CG_DEFOSMODE) 16384) (setvar "OSMODE" (+ (car CG_DEFOSMODE) 16384)))
			)
    )
  ));End if-progn
)
;終了
(defun CFCmdDefEnd ()
  ;ﾘｽﾄの先頭からｼｽﾃﾑ変数を設定
  (if (car CG_DEFSNAPMODE ) (setvar "SNAPMODE"  (car CG_DEFSNAPMODE )))
  (if (car CG_DEFGRIDMODE ) (setvar "GRIDMODE"  (car CG_DEFGRIDMODE )))
  (if (car CG_DEFORTHOMODE) (setvar "ORTHOMODE" (car CG_DEFORTHOMODE)))
  (if (car CG_DEFOSMODE   ) (setvar "OSMODE"    (car CG_DEFOSMODE   )))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(if (car CG_DEF3DOSMODE )  (setvar "3DOSMODE"   (car CG_DEF3DOSMODE  )));2011/06/30 YM ADD
  		(if (car CG_DEFUCSDETECT ) (setvar "UCSDETECT"  (car CG_DEFUCSDETECT )))
		)
	);_if
  ;ﾘｽﾄ再作成
  (setq CG_DEFSNAPMODE  (cdr CG_DEFSNAPMODE ))
  (setq CG_DEFGRIDMODE  (cdr CG_DEFGRIDMODE ))
  (setq CG_DEFORTHOMODE (cdr CG_DEFORTHOMODE))
  (setq CG_DEFOSMODE    (cdr CG_DEFOSMODE   ))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(setq CG_DEF3DOSMODE   (cdr CG_DEF3DOSMODE  ));2011/06/30 YM ADD
  		(setq CG_DEFUCSDETECT  (cdr CG_DEFUCSDETECT ))
		)
	);_if
)
;外部変数初期化
(defun CFCmdDefReset()
  (setq CG_DEFSNAPMODE  '())
  (setq CG_DEFGRIDMODE  '())
  (setq CG_DEFORTHOMODE '())
  (setq CG_DEFOSMODE    '())
  (setq CG_DEF3DOSMODE  '());2011/06/30 YM ADD
  (setq CG_DEFUCSDETECT '())
)
;初期化後開始
(defun CFCmdDefBegin( &mode )
  (CFCmdDefReset)
  (CFCmdDefStart &mode)
)
;強制終了&初期化
(defun CFCmdDefFinish()
  ;ﾘｽﾄの最後からｼｽﾃﾑ変数を設定
  (if (last CG_DEFSNAPMODE ) (setvar "SNAPMODE"  (last CG_DEFSNAPMODE )))
  (if (last CG_DEFGRIDMODE ) (setvar "GRIDMODE"  (last CG_DEFGRIDMODE )))
  (if (last CG_DEFORTHOMODE) (setvar "ORTHOMODE" (last CG_DEFORTHOMODE)))
  (if (last CG_DEFOSMODE   ) (setvar "OSMODE"    (last CG_DEFOSMODE   )))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
	  	(if (last CG_DEF3DOSMODE  ) (setvar "3DOSMODE"   (last CG_DEF3DOSMODE )));2011/06/30 YM ADD
	  	(if (last CG_DEFUCSDETECT ) (setvar "UCSDETECT"  (last CG_DEFUCSDETECT )))
		)
	);_if
  (CFNoSnapReset)
)


;<HOM>*************************************************************************
; <関数名>    : CFgetini
; <処理概要>  : ini ファイルの内容を読み込む
; <戻り値>    :
;         STR : 読み込んだ項目文列
;             ; 読み込めなかった場合 nil
; <備考>      :
;*************************************************************************>MOH<
(defun CFgetini (
   &sSection	; [セクション]
   &sEntry	; エントリー=
   &sFilename	; \\ファイル名 (フルパスで指定)
   /
   #pRet	; ファイル識別子
   #sLine	; 現在読み込み行
   #sSection	; 現在セクション
   #sEntry	; 現在エントリ
   #sEntStr	;
   #sTmp	;
   #iColumn	;
   #sRet	;
#END_FLG
   )
;///////////////////////////////////////////////////////////////////////
  	;; コメントを省いた文字列にする
	;; 省いた結果意味のない行になる場合は nil を返す
  	(defun Comment_Omit (
			&sLine
			/
			 #iIDX	;
			)
	    ; コメント行
        ; XXX 条件はこれでいいか？？
      (setq #iIDX (vl-string-position (ascii ";") &sLine))
      (if (/= #iIDX nil)
				(progn
				  (setq &sLine (substr &sLine 1 #iIDX)) 
				 )
      );_if

	      ; 意味のある行には = か [ ] が含まれるはず
      (if (or (vl-string-position  (ascii "=") &sLine)
      	 (and (vl-string-position  (ascii "[") &sLine)
	            (vl-string-position  (ascii "]") &sLine)))
				  &sLine
				  nil
      );_if
	);Comment_Omit
;///////////////////////////////////////////////////////////////////////
  	; ファイルをオープン
	(setq #END_FLG T) ; 取得したら終わる 01/02/06 YM ADD

	(setq #pRet (open &sFilename "r"))
	(if (/= #pRet nil)
	  (progn
      (setq #sLine (read-line #pRet))
      ; 1行ずつ読み込む
	    (while (and #END_FLG (/= #sLine nil))
	      ; コメント行を省く
	      (setq #sLine (Comment_Omit #sLine))
	      ; 有効な行だった場合
	      (if (/= #sLine nil)
					(progn 
          ; 現在行のセクション名を取得する
					  (setq #sTmp (vl-string-right-trim " \t\n" (vl-string-left-trim "[" #sLine)))
	          (if (/= #sTmp #sLine)
            	(setq #sSection (substr #sLine 2 (- (strlen #sTmp) 1)))
	          );_if
	      
	          ; 現在行のセクション名と指定したセクション名が等しい場合
		  			; エントリを検索する
					  (if (= &sSection #sSection)
					    (progn 
                (setq #sLine (read-line #pRet))
					      (while (and #END_FLG (/= #sLine nil))
									; コメント行を省く
					        (setq #sLine (Comment_Omit #sLine))
									; 有効な行だった場合
									(if (/= #sLine nil)
				          ; エントリを取得する
				          ; XXX エントリは最初のカラムから始まり、スペース,=を含まない、としてよいか？
									  (progn 
									    (setq #sEntry (car (strparse #sLine "=")))
							  	    (setq #sEntStr (cadr (strparse #sLine "=")))
									    ; 取得した有効なエントリと指定したエントリを比較する
									    (if  (and (/= #sEntry nil) (= #sEntry &sEntry))
					              (progn
								 	        (setq #sRet #sEntStr)
													(setq #END_FLG nil) ; 取得したら終わる 01/02/06 YM ADD
													;;; \\n を\nに置換する
													(while (vl-string-search "\\n" #sRet) ; "\\n"があるか?
														(setq #sRet (vl-string-subst "\n" "\\n" #sRet)) ; 最初の1つ置換
													)
					              )
		                  );_if
									  )
	        				) ; (if (/= #sLine nil)
									(setq #sLine (read-line #pRet))
		      			) ; (while (/= #sLine nil)
			   	    ) ; progn
					  ) ; if (= &sSection #sSection)
					)
	      );_if
	      (setq #sLine (read-line #pRet))
	    ); while (/= #sLine nil)

;2014/12/04 Y.Ikeda ADD ファイルクローズ
      (close #pRet)

		)
		(progn
		; ファイルオープンエラー  
	  	(print (strcat "ファイルがない:" &sFilename))
      nil
		)
	);_if

	(if (= nil #sRet)
		(CFAlertMsg (strcat "メッセージ [" &sSection "] " &sEntry " 番が参照できません。"
												"\nErrmsg.ini のバージョンをご確認ください。"))
	);_if
	#sRet
);CFgetini

;;;<HOM>************************************************************************
;;; <関数名>  : CFDispYashiLayer
;;; <処理概要>: 矢視画層を表示する
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun CFDispYashiLayer (
  )
  ;// なければ矢視の画層を作成する
  (MakeLayer CG_YASHI_LAYER       CG_YASHI_COL "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_LAYER  CG_YASHI_COL "CONTINUOUS")

  ;// なければ矢視領域の画層を作成する
  (MakeLayer CG_YASHI_AREA_LAYER           CG_YASHI_AREA_COL "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")

  (command "_.LAYER" "ON" "N_YASHI*" "")

)
;CFDispYashiLayer

;;;<HOM>************************************************************************
;;; <関数名>  : CFHideYashiLayer
;;; <処理概要>: 矢視画層を非表示にする
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun CFHideYashiLayer (
  )
  ;// なければ矢視の画層を作成する
  (MakeLayer CG_YASHI_LAYER       CG_YASHI_COL "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_LAYER  CG_YASHI_COL "CONTINUOUS")

  ;// なければ矢視領域の画層を作成する
  (MakeLayer CG_YASHI_AREA_LAYER           CG_YASHI_AREA_COL "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")

  (command "_.LAYER" "OF" "N_YASHI*" "")
)
;CFHideYashiLayer

(princ)

