
;<HOM>*************************************************************************
; <関数名>    : C:SCFOutPattern
; <処理概要>  : 出力パターン設定
; <戻り値>    : なし
; <作成>      : 1999-06-17
; <備考>      : なし
;*************************************************************************>MOH<
(defun C:SCFOutPattern (
  /
  #Txt$ #DclRet$
  )

  (SCFStartShori "SCFOutPattern")  ; 2000/09/08 HT ADD
  (StartUndoErr)

  ; 2000/07/04 HT DEL 商品図 施工図選択なくす  START
  ;視点方向
  ; (setq #View$
  ;  (list
  ;    (list "02" "L")    ; 商品図
  ;    (list "03" "S")    ; 施工図
  ;  )
  ;)
  ; 2000/07/04 HT DEL 商品図 施工図選択なくす  END

  ;TXT読込み
  ; パターン設定を読み込む
  ; 商品図と施工図作成の設定は、未使用（寸法制御ダイアログで設定に変更2000/07/04）
  (setq #Txt$ (SKOutPatReadScv (strcat CG_SKPATH "outpat.cfg")))
  ;ダイアログ表示
  ; 2000/07/04 HT MOD 商品図 施工図選択なくす  
  ; (setq #DclRet$ (SCFOutPatDlgMain #Txt$ #View$))
  (setq #DclRet$ (SCFOutPatDlgMain #Txt$))
  (if (/= nil #DclRet$)
    (progn
      ;TXT出力
      (SCFOutPatWriteScv (strcat CG_SKPATH "outpat.cfg") #DclRet$)
    )
  )

  ; 終了処理 2000/09/07 HT
  (SCFEndShori)
  (princ)
) ; C:SCFOutPattern

;<HOM>*************************************************************************
; <関数名>    : SCFOutPatDlgMain
; <処理概要>  : 出力パターン設定ダイアログ
; <戻り値>    : なし
; <作成>      : 1999-06-17
; <備考>      : なし
;*************************************************************************>MOH<
(defun SCFOutPatDlgMain (
  &Txt$       ; 出力ﾊﾟﾀｰﾝﾌｧｲﾙﾘｽﾄ
  ; &View$      ; 視点方向ﾘｽﾄ  ; 2000/07/04 HT DEL 商品図 施工図選択なくす
  /
  #iId #iRet #sNo #sYashi #iType
  )

  ;ﾘｽﾄﾎﾞｯｸｽに値を表示する
  (defun ##SetList ( &sKey &List$ / #vAl )
    (start_list &sKey)
    (foreach #vAl &List$
      (add_list #vAl)
    )
    (end_list)
  )
  ;ﾊﾟﾀｰﾝを新規登録する
  (defun ##New_Click (
    /
    #sNpat #sPat #iAuto #A$ #H$ #iI
    )
    (setq #sNpat (get_tile "edtPat"))
    (cond
      ((= "" #sNpat)
        (CFAlertMsg "ﾊﾟﾀｰﾝ名を入力してください.")
      )
      ((member (strcase #sNpat) #Pat$)
        (CFAlertMsg "入力されたﾊﾟﾀｰﾝ名は既に存在します.")
        (mode_tile "edtPat" 2)
      )
      (T
        (setq #New$ (list (strcase #sNpat) 1))
        (setq #Txt$ (SCFOpSortList (append #Txt$ (list #New$))))
        (setq #Pat$  (mapcar 'car  #Txt$))
        (setq #Auto$ (mapcar 'cadr #Txt$))
        (##SetList "popPat" #Pat$)
        (set_tile "edtPat" "")
        (setq #iI 0)
        (mapcar
         '(lambda ( #sPat )
            (if (equal #sPat (strcase #sNpat))
              (set_tile "popPat" (itoa #iI))
            )
            (setq #iI (1+ #iI))
          )
          #Pat$
        )
        (##Pat_Change)
      )
    )
  )
  ;ﾊﾟﾀｰﾝ名を変更する
  (defun ##Edt_Click (
    /
    #sEpat #sFpat #Edit$ #iI #sPat
    )
    (setq #sEpat (strcase (get_tile "edtPat")))
    (setq #sFpat (nth (atoi (get_tile "popPat")) #Pat$))
    (cond
      ((= "" #sEpat)
        (CFAlertMsg "変更するﾊﾟﾀｰﾝ名を入力してください.")
      )
      ((member #sEpat #Pat$)
        (CFAlertMsg "入力されたﾊﾟﾀｰﾝ名は既に存在します.")
        (mode_tile "edtPat" 2)
      )
      (T
        (setq #Edit$ (append (list #sEpat 1) (cdr (cdr (assoc #sFpat #Txt$)))))
        (setq #Txt$ (SCFSubstList #Txt$ (atoi (get_tile "popPat")) #Edit$))
        (setq #Txt$ (SCFOpSortList #Txt$))
        (setq #Pat$  (mapcar 'car  #Txt$))
        (setq #Auto$ (mapcar 'cadr #Txt$))
        (##SetList "popPat" #Pat$)
        (set_tile "edtPat" "")
        (setq #iI 0)
        (mapcar
         '(lambda ( #sPat )
            (if (equal #sPat (strcase #sEpat))
              (set_tile "popPat" (itoa #iI))
            )
            (setq #iI (1+ #iI))
          )
          #Pat$
        )
        (##Pat_Change)
      )
    )
  )
  ;ﾊﾟﾀｰﾝを削除する
  (defun ##Del_Click (
    /
    #sDpat #iOk #sPat #iAuto #A$ #H$ #H_n$ #Txt_n$
    )
    (setq #sDpat (nth (atoi (get_tile "popPat")) #Pat$))
    (setq #iOk
      (CFYesNoDialog
        (strcat "  「ﾊﾟﾀｰﾝ：" #sDpat "」  を削除します.\n   よろしいですか？")
      )
    )
    (if (= T #iOk)
      (progn
        (setq #Txt$ (SCFSubstList #Txt$ (atoi (get_tile "popPat")) nil))
        (setq #Txt$ (SCFOpSortList #Txt$))
        (setq #Pat$  (mapcar 'car  #Txt$))
        (setq #Auto$ (mapcar 'cadr #Txt$))
        (##SetList "popPat" #Pat$)
        (set_tile "edtPat" "")
        (set_tile "popPat" "0")
        (##Pat_Change)
      )
    )
  )
  ;ﾊﾟﾀｰﾝ詳細を表示する
  (defun ##Pat_Change (
    /
    #sCpat #sPat #iAuto #iFlg #Lst$ #Disp$
    )
    (setq #sCpat (nth (atoi (get_tile "popPat")) #Pat$))
    ;使用ﾀｲﾙ表示変更
    (mapcar
     '(lambda ( #sPat #iAuto )
        (if (equal #sPat #sCpat)
          (setq #iFlg #iAuto)
        )
      )
      #Pat$ #Auto$
    )
    ; パターンが選択された時、有効無効にする
    (if (= 0 #iFlg)
      (progn
        (mode_tile "btnEdt"  1)
        (mode_tile "btnDel"  1)
        (mode_tile "btnPat"  1)
        (mode_tile "btnPdel" 1)
      )
      (progn
        (mode_tile "btnEdt"  0)
        (mode_tile "btnDel"  0)
        (mode_tile "btnPat"  0)
        (mode_tile "btnPdel" 0)
      )
    )
    ;詳細ﾘｽﾄ表示
    (setq #Lst$ (cdr (cdr (assoc #sCpat #Txt$))))
    (if (/= nil (car #Lst$))
      (progn
        (mapcar
         '(lambda ( #Lst$ )
            ; 2000/07/04 HT DEL 商品図 施工図選択なくす START
            ; (setq #V$ nil)
            ; (setq #Kind$ (cdr #Lst$))
            ; (if (member (car (nth 0 &View$)) #Kind$)
            ;   (cond
            ;     ((= "L" (cadr (nth 0 &View$))) (setq #V$ (cons "商品" #V$)))
            ;     ((= "S" (cadr (nth 0 &View$))) (setq #V$ (cons "施工" #V$)))
            ;  )
            ; )
            ; (if (member (car (nth 1 &View$)) #Kind$)
            ;  (cond
            ;    ((= "L" (cadr (nth 1 &View$))) (setq #V$ (cons "商品" #V$)))
            ;    ((= "S" (cadr (nth 1 &View$))) (setq #V$ (cons "施工" #V$)))
            ;  )
            ;)
            ;(setq #V$ (reverse #V$))
            ;(setq #sView "")
            ;(if (/= nil #V$)
            ;  (progn
            ;    (mapcar '(lambda ( #sV ) (setq #sView (strcat #sView "/" #sV))) #V$)
            ;    (setq #sView (strcat "[" (substr #sView 2) "]"))
            ;  )
            ;)
            ; (setq #Disp$ (cons (strcat (car #Lst$) "\t" #sView) #Disp$))
            (setq #Disp$ (cons (car #Lst$) #Disp$))
            ; 2000/07/04 HT DEL 商品図 施工図選択なくす END
          )
          #Lst$
        )
      )
    )
    (##SetList "lstTmp" (reverse #Disp$))
  )
  ;詳細ﾊﾟﾀｰﾝを設定する
  (defun ##Set_Click (
    /
    #sPat #Lst$
    )
    (setq #sPat (nth (atoi (get_tile "popPat")) #Pat$))
    (setq #Lst$ (assoc #sPat #Txt$))
    (setq #Lst$ (SCFOutPatDlgSub #Lst$ &View$))
    (setq #Txt$ (SCFSubstList #Txt$ (atoi (get_tile "popPat")) #Lst$))
    (setq #Txt$ (SCFOpSortList #Txt$))
    (setq #Pat$  (mapcar 'car  #Txt$))
    (setq #Auto$ (mapcar 'cadr #Txt$))
    (##Pat_Change)
  )
  ;詳細ﾊﾟﾀｰﾝを削除
  (defun ##Pdel_Click (
    /
    #sPat #Lst$ #iTmp
    )
    (setq #sPat (nth (atoi (get_tile "popPat")) #Pat$))
    (setq #Lst$ (assoc #sPat #Txt$))
    (setq #iTmp  (+ 2 (atoi (get_tile "lstTmp"))))
    (setq #Lst$ (SCFSubstList #Lst$ #iTmp nil))
    (setq #Txt$ (SCFSubstList #Txt$ (atoi (get_tile "popPat")) #Lst$))
    (setq #Txt$ (SCFOpSortList #Txt$))
    (setq #Pat$  (mapcar 'car  #Txt$))
    (setq #Auto$ (mapcar 'cadr #Txt$))
    (##Pat_Change)
  )
  (setq #Txt$ &Txt$)
  (setq #Pat$  (mapcar 'car  #Txt$))
  (setq #Auto$ (mapcar 'cadr #Txt$))

  ;ﾀﾞｲｱﾛｸﾞ表示
  (setq #iId (GetDlgID "CSFop"))
  (if (not (new_dialog "outpatmain" #iId))(exit))

    (##SetList "popPat" #Pat$)
    (##Pat_Change)
    (action_tile "btnPat"  "(##Set_Click)")
    (action_tile "btnPdel" "(##Pdel_Click)")
    (action_tile "popPat"  "(##Pat_Change)")
    (action_tile "btnNew"  "(##New_Click)")
    (action_tile "btnEdt"  "(##Edt_Click)")
    (action_tile "btnDel"  "(##Del_Click)")
    (action_tile "accept"  "(done_dialog 1)")
    (action_tile "cancel"  "(done_dialog 0)")

  (setq #iRet (start_dialog))
  (unload_dialog #iId)

  (if (= #iRet 1) ;OKボタン押下
    #Txt$
    nil
  )
) ; SCFOutPatDlgMain


;<HOM>*************************************************************************
; <関数名>    : SCFOutPatDlgSub
; <処理概要>  : 出力パターン設定ダイアログSUB
; <戻り値>    : なし
; <作成>      : 1999-06-18
; <備考>      : なし
;*************************************************************************>MOH<

(defun SCFOutPatDlgSub (
  &Lst$       ; 選択された項目のリスト
  &View$      ; 視点方向ﾘｽﾄ
  /
  #Tmp$ #Atmp$ #sTmp #Tmp_n$ #View$ #iId ##OK_Click #iRet #Ret$
  #LBlist$  ; 現在リストボックスで表示されているデータリスト		
  )

  ; OKボタンが押された時に呼ばれる関数
  (defun ##OK_Click(
    /
    #Lst$
    )
    ; 2000/07/04 HT DEL 商品図 施工図選択なくす START
    ;(setq #sL (get_tile "tglRay"))
    ;(setq #sS (get_tile "tglSet"))
    ;(if (= "1" (get_tile "tglRay"))
    ;  (setq #Lst$ (cons (cadr (assoc "L" #View$)) #Lst$))
    ;)
    ;(if (= "1" (get_tile "tglSet"))
    ;  (setq #Lst$ (cons (cadr (assoc "S" #View$)) #Lst$))
    ;)
    ;(if (= nil #Lst$)
    ;  (setq #Lst$ (list ""))
    ;)
    ;(setq #Lst$ (reverse #Lst$))
    ; 2000/07/04 HT DEL 商品図 施工図選択なくす END
    ; 2000/07/04 HT ADD 商品図 施工図選択なくす 
    (setq #Lst$ (list ""))
    ; 選択されたテンプレートを取得
    (setq #Lst$ (cons (nth (atoi (get_tile "lstTmp")) #LBlist$) #Lst$))
    (setq #Ret$ (append &Lst$ (list #Lst$)))
    (done_dialog 1)
  )

  ; 2000/07/04 HT ADD サイズと尺度
  ; すべてチェックボタンが押された時に呼ばれる関数
  (defun ##ALL_Click (
    /
    )
    ; すべてチェックボタンON OFFで、ラジオボタンを有効無効にする
    (if (= "1" (get_tile "tglALL"))
      (progn
        (mode_tile "rdoA4" 1)
        (mode_tile "rdoA3" 1)
        (mode_tile "rdoA2" 1)
        (mode_tile "rdoB4" 1)
        (mode_tile "rdo20" 1)
        (mode_tile "rdo30" 1)
        (mode_tile "rdo40" 1)
        (mode_tile "rdo01" 1)
	; すべての状態でリストボックス表示
        (##SetList "lstTmp" #Tmp$)
      )
      (progn
        (mode_tile "rdoA4" 0)
        (mode_tile "rdoA3" 0)
        (mode_tile "rdoA2" 0)
        (mode_tile "rdoB4" 0)
        (mode_tile "rdo20" 0)
        (mode_tile "rdo30" 0)
        (mode_tile "rdo40" 0)
        (mode_tile "rdo01" 0)
	; 今のラジオボタンの状態でリストボックス表示
        (##rdo_Click)
      )
    )
  )

  
  ;ﾘｽﾄﾎﾞｯｸｽに値を表示する
  (defun ##SetList ( &sKey &List$ / #vAl )
    (setq #LBlist$ &List$)
    (start_list &sKey)
    (foreach #vAl &List$
      (add_list #vAl)
    )
    (end_list)
  )

  ; 2000/07/04 HT ADD サイズと尺度
  ; 用紙サイズと尺度のラジオボタンが押された時に呼ばれる関数
  (defun ##rdo_Click (  /  #sSizeScale #Tmp2$)
    ; ALLのチェックがOFFなら指定された用紙サイズと尺度のみ
    ; リストボックスに表示する
    (if (= "0" (get_tile "tglALL"))
      (progn
	      ; テンプレート名最初5バイトで判定
	      ; ex) A3-01  A3サイズ1倍(立体),  A4-40	A4サイズ40倍
	      (setq #sSizeScale (strcat 
	        (substr (get_tile "rdoSize") 4 2)
	        "-"
	        (substr (get_tile "rdoScale") 4 2)
	      ))
	      (setq #Tmp2$ '())
	      (mapcar '(lambda(#sPat)
		        (if (= (substr #sPat 1 5) #sSizeScale)
		          (progn
							  ; テンプレート全体(既に設定されているものは除く)  
							  ; サイズと尺度の該当するもののみ取り込む  
				  			(setq #Tmp2$ (append #Tmp2$ (list #sPat)))  
				  	  )
		        );_if
        	)
	        #Tmp$
	      );mapcar
	      ; リストボックスに表示
	      (##SetList "lstTmp" #Tmp2$)
      )
    );_if

  );(defun ##rdo_Click

  ;ﾃﾝﾌﾟﾚｰﾄ名獲得
  ; 既にパターン設定されているものは表示されない(リストから省く)
  ; #Tmp$に「すべて」がONの時のデータをためる
  (setq #Tmp$ (SCFGetDirFile CG_TMPHPATH))
  (setq #Atmp$ (mapcar 'car (cdr (cdr &Lst$))))
  (if (/= nil #Atmp$)
    (progn
      (mapcar
       '(lambda ( #sTmp )
          (if (not (member #sTmp #Atmp$))
            (setq #Tmp_n$ (cons #sTmp #Tmp_n$))
          )
        )
        #Tmp$
      )
      (setq #Tmp$ (reverse #Tmp_n$))
    )
  )

  (if (/= nil #Tmp$)
    (progn
      (setq #View$ (mapcar 'reverse &View$))
      ;ﾀﾞｲｱﾛｸﾞ表示
      (setq #iId (GetDlgID "CSFop"))
      (if (not (new_dialog "outpatsub" #iId))(exit))
        ; 2000/07/03 用紙サイズと尺度フィルターをかける START 
        ; ALLにチェックONの時、用紙サイズと尺度選択できない
        (set_tile "rdoSize" "rdoA4")
        (set_tile "rdoScale" "rdo40")
        (set_tile "tglALL" "1")
        (##ALL_Click)
        ; 2000/07/03 用紙サイズと尺度フィルターをかける END
        (set_tile "lstTmp" "0")
        (set_tile "txtPat" (car &Lst$))
        (##SetList "lstTmp" #Tmp$)
        ; 2000/07/04 HT ADD サイズと尺度 START
        (action_tile "tglALL" "(##ALL_Click)")
        (action_tile "rdoSize" "(##rdo_Click)")
        (action_tile "rdoScale" "(##rdo_Click)")
        ; 2000/07/04 HT ADD サイズと尺度 END
        (action_tile "accept" "(##OK_Click)")
        (action_tile "cancel" "(done_dialog 0)")
      (setq #iRet (start_dialog))
      (unload_dialog #iId)
    )
    (CFAlertMsg "ﾃﾝﾌﾟﾚｰﾄが存在しません")
  )

  (if (= 1 #iRet)
    #Ret$
    &Lst$
  )
) ; SCFOutPatDlgSub

;<HOM>*************************************************************************
; <関数名>    : SCFGetDirFile
; <処理概要>  : 指定ﾃﾞｨﾚｸﾄﾘ内のﾌｧｲﾙをすべて獲得する（拡張子なし）
; <戻り値>    : なし
; <作成>      : 1999-06-18
; <備考>      : なし
;*************************************************************************>MOH<

(defun SCFGetDirFile (
  &sDir       ; ﾃﾞｨﾚｸﾄﾘ
  /
  #file_o$
  )
  ; 2000/08/08  HT R14不要 DEL
  ;(if (= "14" CG_ACAD_VER)
  ;  (progn
  ;    (dos_chdir &sdir)
  ;    (setq #file_o$ (dos_dir "*.dwt"))
  ;  )
  ;  (progn
      (setq #file_o$ (vl-directory-files &sdir "*.dwt" 1))
  ;  )
  ;)

  (mapcar '(lambda ( #fname ) (nth 1 (fnsplitl #fname))) #file_o$)
) ; SCFGetDirFile

;<HOM>*************************************************************************
; <関数名>    : SCFSubstList
; <処理概要>  : リストの指定項目を更新する
; <戻り値>    : なし
; <作成>      : 1999-06-21
; <備考>      : 引数：要素にnilを格納するとその項目は削除されます.
;*************************************************************************>MOH<

(defun SCFSubstList (
  &List$      ; 元のリスト
  &iNo        ; 更新個所のNo
  &Elm        ; 要素
  /
  #iI #New$
  )
  (setq #iI 0)
  (repeat (length &List$)
    (if (= #iI &iNo)
      (if (/= nil &Elm)
        (setq #New$ (cons &Elm           #New$))
      )
      (setq #New$ (cons (nth #iI &List$) #New$))
    )
    (setq #iI (1+ #iI))
  )
  (reverse #New$)
) ; SCFSubstList

;<HOM>*************************************************************************
; <関数名>    : SCFOpSortList
; <処理概要>  : 出力パターンで変更可能なリストのみｿｰﾄする
; <戻り値>    : なし
; <作成>      : 1999-06-21
; <備考>      : なし
;*************************************************************************>MOH<

(defun SCFOpSortList (
  &Txt$
  /
  #Pat$ #Auto$ #sPat #iAuto #A$ #H$ #Txt$
  )
  (setq #Pat$  (mapcar 'car  &Txt$))
  (setq #Auto$ (mapcar 'cadr &Txt$))
  (mapcar
   '(lambda ( #sPat #iAuto )
      (if (= 0 #iAuto)
        (setq #A$ (cons #sPat #A$))
        (setq #H$ (cons #sPat #H$))
      )
    )
    #Pat$ #Auto$
  )
  (setq #A$ (reverse #A$))
  (if (/= nil #H$)
    (setq #H$ (acad_strlsort #H$))
  )
  (setq #Pat$ (append #A$ #H$))

  (mapcar
   '(lambda ( #sPat )
      (setq #Txt$ (cons (assoc #sPat &Txt$) #Txt$))
    )
    #Pat$
  )

  (reverse #Txt$)
) ; SCFOpSortList

;<HOM>*************************************************************************
; <関数名>    : SCFOutPatWriteScv
; <処理概要>  : 出力パターン設定ファイル書込み
; <戻り値>    : なし
; <作成>      : 1999-06-23
; <備考>      : なし
;*************************************************************************>MOH<

(defun SCFOutPatWriteScv (
  &sFname     ; ﾌｧｲﾙ名
  &Txt$       ; 書込み文字列リスト
  /
  #fp #Lst$ #Tmp$ #sTr #s
  )
  (setq #fp  (open &sFname "w"))
  (if (/= nil #fp)
    (progn
      (mapcar
       '(lambda ( #Lst$ )
          ;ﾊﾟﾀｰﾝ名記入
          (princ (strcat "*" (nth 0 #Lst$) "," (itoa (nth 1 #Lst$))) #fp)
          ;ﾊﾟﾀｰﾝ記入
          (mapcar
           '(lambda ( #Tmp$ )
              (setq #sTr "")
              (mapcar
               '(lambda ( #s )
                  (setq #sTr (strcat #sTr #s ","))
                )
                #Tmp$
              )
              (setq #sTr (substr #sTr 1 (1- (strlen #sTr))))
              (princ (strcat "\n" #sTr) #fp)
            )
            (cdr (cdr #Lst$))
          )
          (princ "\n" #fp)
        )
        &Txt$
      )
    )
  )
  (close #fp)

  (princ)
) ; SCFOutPatWriteScv

