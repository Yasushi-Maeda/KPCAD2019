;<HOM>*************************************************************************
; <関数名>    : PosKUTAI
; <処理概要>  : 躯体配置
; <戻り値>    :
; <作成>      : 2000/11/21 SN
; <備考>      :
;*************************************************************************>MOH<
(defun c:PosKUTAI( 
  /
  #fig$
  #LUPREC #ELEVATION
  #FName #FlogName
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:PosParts ////")
  (CFOutStateLog 1 1 " ")
  ;;; コマンド&エラー処理の初期化
  (StartUndoErr)
  ;;; ｽﾅｯﾌﾟ関連の初期化(内部の処理で変更しても元に戻るように)
  (CFCmdDefBegin nil)
  ;;;基準高さを記憶 PcSetKUTAI内で変更される為
  (setq #ELEVATION (getvar "ELEVATION"))
  ;;;RTOSはシステム変数LUPRECによって小数桁を制限できる。
  (setq #LUPREC (getvar "LUPREC"))
  (setvar "LUPREC" 2)

  ;;; 躯体情報の取得
  (if (not (setq #fig$ (SKY_GetItemInfo)))
    (CFAlertErr "品番情報を取得できませんでした"))

  ;;; 伸縮処理でSELPARTS.CFGをﾁｪｯｸしている為、以降の作業に支障がでる。
  ;;; よって作業終了後名前を変更・削除する。一時ﾌｧｲﾙなので問題ない。
  (setq #FName    (strcat CG_SYSPATH "SELPARTS.CFG"))
  (setq #FlogName (strcat CG_SYSPATH "SELPARTS.LOG"))
  (vl-file-delete  #FlogName)
  (vl-file-rename  #FName #FlogName)
  ;(vl-file-delete #FName)

  ;; 躯体の配置
  (PcSetKUTAI #fig$)

  ;;;変更したシステム変数を元に戻す
  (setvar "LUPREC"    #LUPREC)
  (setvar "ELEVATION" #ELEVATION)
	(command "_.layer" "T" "Z_KUTAI" "") ; 01/03/30 YM ADD

  ;;; ｽﾅｯﾌﾟ関連を戻す(内部の処理で変更しても元に戻るように)
  (CFCmdDefFinish)
  ;;; ｴﾗｰ処理を戻す
  (setq *error* nil)
  (princ)
)
;<HOM>*************************************************************************
; <関数名>    : PosKUTAI
; <処理概要>  : 躯体配置
; <戻り値>    :
; <作成>      : 2000/11/21 SN
; <備考>      :
;*************************************************************************>MOH<
(defun PcSetKUTAI( 
  &fig$
  /
  #Name #Type
  #sql #qry$
  #Indcd                      ;指示仕様ｺｰﾄﾞ
  #Indmsg1 #Indmsg2 #Indmsg3  ;指示誘導ﾒｯｾｰｼﾞ
  #IndId1  #IndId2  #IndId3   ;指示誘導ﾒｯｾｰｼﾞID
  #P1$     #P2$     #P3$      ;指示点
  #Wname #Dname #Hname #Bname ;入力項目
  #Wcd   #Dcd   #Hcd   #Bcd   ;入力ｺｰﾄﾞ
  #Wxd   #Dxd   #Hxd   #Bxd   ;入力初期値(XDATA G_SYM)
  #Wset  #Dset  #Hset  #Bset  ;最終的な幅奥行高さ
  #wdhb$ #eawd$
  #msg
  #xdg_sym$
  #fname #ss #eNEW #wBase #dBase #dINS #WAng #DAng
  #wk
  #HaitiMode ; 0:中心に一旦配置
             ; 1:枠外に一旦配置し配置操作時に中心に移動
             ; 2:枠外に配置後一旦削除し再度INSERT
  #ii #sOlayer #sNlayer #eget #emod #fHmov #strFLG #orgLYR$
#LASTZ #MSG #OS #OT #SM ; 01/04/09 YM
  )
  (setq #HaitiMode 2)

  ;;; 躯体入力時の指示誘導ﾒｯｾｰｼﾞ取得関数
  (defun #getindmsg( &no / #sql #qry$ )
    (setq #sql (strcat "select 指示MSG from 躯体MSG where MSG_ID=" &no))
    (setq #qry$ (car (DBSqlAutoQuery CG_CDBSession #sql)))
    (if #qry$
      (car #qry$)
      (progn
        (setq msg "  PcSetKUTAI:『指示MSG』が見つかりませんでした")
        (CFOutStateLog 0 1 msg)
        (CFOutStateLog 0 1 (strcat "        " #sql))
        (CFAlertMsg #msg)
        nil
      )
    )
  );End

  ;;; 躯体入力時のﾀﾞｲｱﾛｸﾞ名称取得関数
  (defun #getitemname( &no / #sql #qry$ )
    (setq #sql (strcat "select 項目名称 from 躯体名称 where 名称ID=" &no))
    (setq #qry$ (car (DBSqlAutoQuery CG_CDBSession #sql)))
    (if #qry$
      (car #qry$)
      (progn
        (setq msg "  PcSetKUTAI:『項目名称』が見つかりませんでした")
        (CFOutStateLog 0 1 msg)
        (CFOutStateLog 0 1 (strcat "        " #sql))
        (CFAlertMsg #msg)
        nil
      )
    )
  );End

  ;;;躯体図形情報を取得
  (setq #Name (car &fig$))
  (setq #sql (strcat "select * from 躯体図形 where 躯体名称='" #Name "'"))
  (setq #qry$ (car (DBSqlAutoQuery CG_CDBSession #sql)))
  (if (= #qry$ nil)
    (progn
      (setq #msg "  PcSetKUTAI:『躯体図形』が見つかりませんでした")
      (CFOutStateLog 0 1 #msg)
      (CFOutStateLog 0 1 (strcat "        " #sql))
      (CFAlertMsg #msg)
      (exit)
    )
  )

  ;;; 躯体ﾀｲﾌﾟ
  (setq #Type  (fix(nth 2 #qry$)))
  ;;; 躯体配置時の指示仕様ｺｰﾄﾞ
  (setq #Indcd (fix(nth 3 #qry$)))
  ;;; 躯体配置時の指示誘導ﾒｯｾｰｼﾞID取得
  (setq #IndId1 (fix(nth 4 #qry$)))
  (setq #IndId2 (fix(nth 5 #qry$)))
  (setq #IndId3 (fix(nth 6 #qry$)))
  ;;; 躯体配置時の指示誘導ﾒｯｾｰｼﾞ取得
  (if (/= (nth  4 #qry$) 0) (setq #Indmsg1 (#getindmsg (itoa #IndId1))))
  (if (/= (nth  5 #qry$) 0) (setq #Indmsg2 (#getindmsg (itoa #IndId2))))
  (if (/= (nth  6 #qry$) 0) (setq #Indmsg3 (#getindmsg (itoa #IndId3))))
  ;;; 躯体入力時のﾀﾞｲｱﾛｸﾞ名称取得関数
  (if (/= (nth  7 #qry$) 0) (setq #Wname (#getitemname (rtos(nth  7 #qry$)))))
  (if (/= (nth  8 #qry$) 0) (setq #Dname (#getitemname (rtos(nth  8 #qry$)))))
  (if (/= (nth  9 #qry$) 0) (setq #Hname (#getitemname (rtos(nth  9 #qry$)))))
  (if (/= (nth 10 #qry$) 0) (setq #Bname (#getitemname (rtos(nth 10 #qry$)))))
  ;;; 躯体入力時のｺｰﾄﾞ
  (setq #Wcd (fix(nth 11 #qry$)))
  (setq #Dcd (fix(nth 12 #qry$)))
  (setq #Hcd (fix(nth 13 #qry$)))
  (setq #Bcd (fix(nth 14 #qry$)))
  ;図形ID取得
  (setq #fname (nth 15 #qry$))

  (setq #dBase (getvar "VIEWCTR"))      ;現在のVIEWの中心を取得

  (setq #wBase (list 10000 10000 10000));範囲外仮配置場所
  (if (= #HaitiMode 0) (setq #wBase #dBase));中心配置なら仮配置場所を変更
  ;;; ↓↓Kcparts.lspの(Pcsetitem)から抜出し↓↓
  ;;; 初めての作図の可能性があるため、作図用の画層設置
  (MakeLayer "Z_00_00_00_01" 7 "CONTINUOUS")
  (Pc_CheckInsertDwg (strcat #fname ".dwg") CG_MSTDWGPATH) ; 01/02/07 MH ADD
  ;一旦見えないところにINSERT→EXPLODE→GROUPで配置する。
  (command ".insert" (strcat CG_MSTDWGPATH #fname) #wBase 1 1 0) 
  (command "_explode" (entlast))
  (setq #ss (ssget "P"))
  (SKMkGroup #ss) ;分解した図形群で名前のないグループ作成
  (command "_layer" "u" "N_*" "")
  (setq #eNEW (SearchGroupSym (ssname #ss 0)))
  (setq #wBase (cdr (assoc 10 (entget #eNEW))))
  ;(command "_.layer" "on" "M_*" ""); 全共通画層処理 00/12/22 SN DEL 躯体には無いので不要
  ;;; ↑↑Kcparts.lspの(Pcsetitem)から抜出し↑↑

  ;;; XData G_SYM から必要情報取得
  (setq #xdg_sym$ (CFGetXData #eNEW "G_SYM"))
  (setq #Wxd (nth 3 #xdg_sym$))
  (setq #Dxd (nth 4 #xdg_sym$))
  (setq #Hxd (nth 5 #xdg_sym$))
  (setq #Bxd (nth 6 #xdg_sym$))
  (if (= #HaitiMode 2)(progn  ;再INSERTするなら
    (command "._erase" #ss "");一旦消す。
    (setq #ss nil)            ;選択ｾｯﾄもｸﾘｱ
  ));End if-progn
  ;;; 入力コードによるダイアログ表示値の変更
  (setq #Wset #Wxd)
  (setq #Dset #Dxd)
 
  (cond
    ;上端/下端入力(CG_CeilHeight=上端); 01/04/10 MH ADD 天井から設置の条件追加
    ((= (nth 10 #xdg_sym$) -1)
      (setq #Hset #Hxd)
      (setq #Bset CG_CeilHeight)
    )
    ;上端/下端入力(取付高=上端)
    ((= #Hcd 1)
      (setq #Hset #Bxd)         ;上端はB値
      (setq #Bset (- #Bxd #Hxd));下端はB値-H値
    )
    ;上端/下端入力(取付高=下端)
    ((= #Hcd 2)
      (setq #Hset (+ #Hxd #Bxd));上端はH値+B値
      (setq #Bset #Bxd)         ;下端はB値
    )
    (T
      (setq #Hset #Hxd)
      (setq #Bset #Bxd)
    )
  );End cond

  ;;; ユーザ図形サイズの変更ダイアログ
  ;;; 戻り値は(W値 D値 H値 B値)
  (setq #wdhb$ (kutaidlg #Name #Wname #Dname #Hname #Bname #Wcd #Dcd #Hcd #Bcd #Wset #Dset #Hset #Bset))

  ;;; ダイアログ入力値の取得
  (setq #Wset (atof(nth 0 #wdhb$)))
  (setq #Dset (atof(nth 1 #wdhb$)))
  (setq #Hset (atof(nth 2 #wdhb$)))
  (setq #Bset (atof(nth 3 #wdhb$)))
  ;;;入力ｺｰﾄﾞによるWDHB値の入替
  (if (= #Wcd 1);直径の時はD=W
    (setq #Dset #Wset)
  );End if
  (cond
    ;上端/下端入力(取付高=上端)
    ((= #Hcd 1)
      (setq #wk #Hset)            ;取付け高を一時保存
      (setq #Hset (- #Hset #Bset));H値は上端-下端
      (setq #Bset #wk)            ;取付け高は上端
    )
    ;上端/下端入力(取付高=下端)
    ((= #Hcd 2)
      (setq #Hset (- #Hset #Bset));H値は上端-下端
    )
  );End cond
 
  (setvar "ELEVATION" #Bset)
  ;;;仮配置が範囲外 or
  ;;;仮配置が中心で基準高さが変っていたら一旦基準高さと躯体基準位置を変更
  (if (or (= #HaitiMode 1)
          (and (= #HaitiMode 0) (caddr #dBase) (/= #Bset (caddr #dBase))))(progn
    (setq #dBase (list (car #dBase) (cadr #dBase) #Bset))
    (command "._move" #ss "" #wBase #dBase)
  ));End if-progn
  ;;; ユーザ挿入操作
  ;;; 戻り値は(ename Angle Wlen Dlen)
  (setq #eawd$ (kutaihaiti #Indcd #Indmsg1 #Indmsg2 #Indmsg3 #Wset #Dset #HaitiMode #ss #eNEW #fname))
  ;;;基準図形・基点・角度の取得＆点指示によるWDHB値の入替
  (setq #eNEW (nth 0 #eawd$))
  (setq #dIns (cdr (assoc 10 (entget #eNEW))))
  (setq #WAng (nth 1 #eawd$));回転角度
  ;;2点目・3点目の意味を指示仕様CDにより振り分ける
  (cond
    ((= #indcd 4);2点指示
      (setq #Wset (nth 2 #eawd$))
    )
    ((= #indcd 5);2点+D方向
      (setq #Wset (nth 2 #eawd$))
    )
    ((= #indcd 6);3点指示
      (setq #Wset (nth 2 #eawd$))
      (setq #Dset (nth 3 #eawd$))
    )
  );End cond


  ; 01/02/27 YM START
	; 指定取り付け高さと違う場合は移動する
	(setq #lastZ (caddr #dIns))
	(if (equal #lastZ #Bset 0.001) ; ｺﾏﾝﾄﾞﾗｲﾝ指定高さと違うなら移動する
		nil
		(progn
;;; ｼｽﾃﾑ変数設定 01/04/09 YM 一時解除
  (setq #os (getvar "OSMODE"   ))
  (setq #sm (getvar "SNAPMODE" ))
  (setq #ot (getvar "ORTHOMODE"))
  (setvar "OSMODE"    0)
  (setvar "SNAPMODE"  0)
  (setvar "ORTHOMODE" 0)

			(command "_move" (CFGetSameGroupSS #eNEW) "" '(0 0 0) (list 0 0 (- #Bset #lastZ)))
			(setq #dIns (list (car #dIns)(cadr #dIns) #Bset))

;;; ｼｽﾃﾑ変数設定 01/04/09 YM
  (setvar "OSMODE"    #os)
  (setvar "SNAPMODE"  #sm)
  (setvar "ORTHOMODE" #ot)

		)
	);_if
	; 01/02/27 YM END

  ;;;XDATA設定
  (if (= nil (tblsearch "APPID" "G_LSYM")) (regapp "G_LSYM"))
  (CFSetXData #eNew "G_LSYM"
    (list
      #fname                ;1 :本体図形ID      :『品番図形』.図形ID
      #dIns                 ;2 :挿入点          :配置基点
      #WAng                 ;3 :回転角度        :配置回転角度
      CG_KCode              ;4 :工種記号        :CG_Kcode
      CG_SeriesCode         ;5 :SERIES記号    :CG_SeriesCode
      #Name                 ;6 :品番名称        :『品番図形』.品番名称
      "Z"                   ;7 :L/R区分         :『品番図形』.部材L/R区分
      ""                    ;8 :扉図形ID        :
      ""                    ;9 :扉開き図形ID    :
      999                   ;10:性格CODE      :『品番基本』.性格CODE
      0                     ;11:複合フラグ      :０固定（単独部材）
      0                     ;12:配置順番号      :配置順番号(1～)
      0                     ;13:用途番号        :『品番図形』.用途番号
      #Hxd                  ;14:寸法Ｈ          :『品番図形』.寸法Ｈ
      0                     ;15:断面指示の有無  :『プラ構成』.断面有無 00/07/18 SN MOD
    )
  )
  (if (= nil (tblsearch "APPID" "G_KUTAI")) (regapp "G_KUTAI"))
  (CFSetXData #eNew "G_KUTAI"
    (list
      #Type                 ;1 :躯体ﾀｲﾌﾟ
    )
  )
  
  ; 伸縮関連処理  01/02/02 MH ADD "G_PRIM" 3D図形リメイク処理追加 
  ;             ↑DXFを変更してentmodしても色など反映しない3D不具合の対策
  (CFCmdDefStart 0);ｽﾅｯﾌﾟ関係解除
  (setq #strFLG nil)

  ;;;変更のあった個所を順次伸縮していく
  (if (not (equal #Wxd #Wset 0.0001))(progn
    (setq #strFLG 'T)
    (SKY_Stretch_Parts #eNEW #Wset #Dxd #Hxd)
    ; 縦伸縮にともなう位置移動 (Wフラグ= -1のアイテム) 01/02/27 YM ADD
    (if (= -1 (nth 8 #xdg_sym$)) (PcMoveItem #eNEW #dIns))
  )); if progn
  (if (not (equal #Dxd #Dset 0.0001))(progn
    (setq #strFLG 'T)
    (SKY_Stretch_Parts #eNEW #Wset #Dset #Hxd)
    ; 縦伸縮にともなう位置移動 (Dフラグ= -1のアイテム) 01/02/27 YM ADD
    (if (= -1 (nth 9 #xdg_sym$)) (PcMoveItem #eNEW #dIns))
  )); if progn
  (if (not (equal #Hxd #Hset 0.0001))(progn
    (setq #strFLG 'T)
    (SKY_Stretch_Parts #eNEW #Wset #Dset #Hset)
    ; 縦伸縮にともなう位置移動 (Hフラグ= -1のアイテム) 01/02/02 MH ADD
    (if (= -1 (nth 10 #xdg_sym$)) (PcMoveItem #eNEW #dIns))
  )); if progn
  
  ; 伸縮が無かった場合、グループ中の"G_PRIM"を持つ3DSOLID再構成
  (if (not #strFLG) (setq #eNEW (KcRemakePrimInGroup #eNEW)))
  
  (CFCmdDefEnd);ｽﾅｯﾌﾟ関連を戻す

  ;;;XDATA設定 G_SYMは伸縮処理で内容変更される為、伸縮後再設定する。
  (CFSetXData #eNew "G_SYM"
    (list
      (nth  0 #xdg_sym$)   ;シンボル名称
      (nth  1 #xdg_sym$)   ;コメント１
      (nth  2 #xdg_sym$)   ;コメント２
      (nth  3 #xdg_sym$)   ;シンボル基準値Ｗ
      (nth  4 #xdg_sym$)   ;シンボル基準値Ｄ
      (nth  5 #xdg_sym$)   ;シンボル基準値Ｈ
      (nth  6 #xdg_sym$)   ;シンボル取付け高さ
      (nth  7 #xdg_sym$)   ;入力方法
      (nth  8 #xdg_sym$)   ;Ｗ方向フラグ
      (nth  9 #xdg_sym$)   ;Ｄ方向フラグ
      (nth 10 #xdg_sym$)   ;Ｈ方向フラグ
      ;伸縮フラグＷ
      (if (equal #Wxd #Wset 0.0001)
        (nth 11 #xdg_sym$)
        #Wset
      )
      ;伸縮フラグＤ
      (if (equal #Dxd #Dset 0.0001)
        (nth 12 #xdg_sym$)
        #Dset
      )
      ;伸縮フラグＨ
      (if (equal #Hxd #Hset 0.0001)
        (nth 13 #xdg_sym$)
        #Hset
      )
      (nth 14 #xdg_sym$)   ;ブレークライン数Ｗ
      (nth 15 #xdg_sym$)   ;ブレークライン数Ｄ
      (nth 16 #xdg_sym$)   ;ブレークライン数Ｈ
    )
  )
 
  ;;;躯体の画層をZ_00_00_00_01からZ_KUTAIに変更する(伸縮作業の後に行うこと)
  (MakeLayer "Z_KUTAI" 7 "CONTINUOUS")
  (setq #ii 0)
  (setq #ss (CFGetSameGroupSS #eNEW))
  (repeat (sslength #ss)
    (setq #eget (entget (ssname #ss #ii)(list"*")))
    (setq #orgLYR$ (assoc 8 #eget))
    ; 画層Z_00_00_00_01上の図形, 目地図形 画層 M_* が対象
    (if (and #orgLYR$ (wcmatch (cdr #orgLYR$) "M_*,Z_00_00_00_01")) (progn
      (setq #emod (subst (cons 8 "Z_KUTAI") #orgLYR$  #eget))
      (setq #emod (subst (cons 62 256)      (assoc 62 #emod) #emod))
      (entmod #emod)
    )); if progn
    (setq #ii (1+ #ii))
  );End repeat

  (princ)
)

;<HOM>*************************************************************************
; <関数名>    : KcRemakePrimInGroup
; <処理概要>  : グループ中の"G_PRIM"を持つ3DSOLID再構成
; <戻り値>    : 
; <作成>      : 01/02/07 MH
; <備考>      : DXFを変更してentmodしてもSOLOD図形に反映されない不具合の対策用
;*************************************************************************>MOH<
(defun KcRemakePrimInGroup (
  &eEN 
  / 
  #eEN #eg$ #lst #eg$  #en2 #eg2$ #gnam 
  )
  (setq #eEN &eEN)
  (setq #eg$ (entget (cdr (assoc 330 (entget #eEN))))) ; 親図面情報を取得
  (foreach #lst #eg$  ;// ｸﾞﾙｰﾌﾟﾒﾝﾊﾞｰ図形の取得
    (if (= 340 (car #lst)) (progn
      (setq #en2 (cdr #lst))
      (setq #eg2$ (entget #en2 '("G_PRIM")))
      (if (and (/= nil #eg2$) (= (cdr (assoc 0 #eg2$)) "3DSOLID")
               (= (cdr (assoc 8 #eg2$)) "Z_00_00_00_01") )
        (if (CFGetXData #en2 "G_PRIM")
          (progn
            (setq #gnam (SKGetGroupName #en2))
            (setq #en2  (SKS_RemakePrim #en2))
            (command "-group" "A" #gnam #en2 "")
          ); progn
          (progn
            (setq #gnam (SKGetGroupName #en2))
            (command "-group" "A" #gnam #en2 "")
          ); progn
        ) ; if
      ); if 
    )); if progn
  ); foreach
  #eEN
); KcRemakePrimInGroup 

;<HOM>*************************************************************************
; <関数名>    : kutaihaiti
; <処理概要>  : 躯体配置処理
; <引　数>    : &ind        躯体図形DBの指示仕様CD
;             : &Msg#       指示誘導ﾒｯｾｰｼﾞ
;             : &Wset &Dset ﾀﾞｲｱﾛｸﾞ入力幅・奥行
;             : &HaitiMode    2:開始点指示時にINSERTする。
;             :             /=2:開始点指示時は選択ｾｯﾄをmoveする。
;             : &ss         躯体選択ｾｯﾄ HaitiMode/=2の時のみ有効
;             : &ebase      基準図形    HaitiMode/=2の時のみ有効
;             : &fname      挿入図形名  HaitiMode =2の時のみ有効
; <戻り値>    : (eObj Angle Wlen Dlen)
;             : 値が不要な要素はnil
; <作成>      : 2000/11/21 SN
; <備考>      :
;*************************************************************************>MOH<
(defun kutaihaiti(
  &indcd
  &Msg1 &Msg2 &Msg3
  &Wset &Dset
  &HaitiMode &ss &ebase &fname
  /
  #ANGBASE #ANGDIR #LASTPOINT
  #Msg1 #Msg2 #Msg3
  #p1 #p2 #p3 #p4
  #wang #dang
  #wlen #dlen
  #ebase
  #ss
  #ii
  )
  ;(getangle)を使用する場合の開始角度と回転方向指示
  ;;;;方向指示が必要な場合の為にgetangleのBASEを初期化
  (setq #ANGBASE (getvar "ANGBASE"))
  (setq #ANGDIR  (getvar "ANGDIR" ))
  (setvar "ANGBASE" 0.0)
  (setvar "ANGDIR"  0  )

  ;;;ﾒｯｾｰｼﾞに改行と:を付加
  (if &Msg1 (setq #Msg1 (strcat "\n" &Msg1 ":")))
  (if &Msg2 (setq #Msg2 (strcat "\n" &Msg2 ":")))
  (if &Msg3 (setq #Msg3 (strcat "\n" &Msg3 ":")))

  (if (= #HaitiMode 2)
    (progn
      ;;;最初の点指示(全ﾓｰﾄﾞ共通)
      (princ #Msg1)
      (MakeLayer "Z_KUTAI" 7 "CONTINUOUS")
      (command ".insert" (strcat CG_MSTDWGPATH &fname) pause 1 1 0)
      (command "_explode" (entlast))
      (setq #ss (ssget "P"))
      (SKMkGroup #ss) ;分解した図形群で名前のないグループ作成
      (command "_layer" "u" "N_*" "")
      (setq #ebase (SearchGroupSym (ssname #ss 0)))
      (setq #p1 (cdr(assoc 10 (entget #ebase))))
      ;(command "_.layer" "on" "M_*" ""); 全共通画層処理 00/12/22 SN DEL 躯体には無いので不要
    )
    (progn
      (setq #ebase &ebase)
      (setq #ss &ss)
      ;;;現在の基点
      (setq #p1 (cdr(assoc 10 (entget #ebase))))
      ;;;最初の点指示(全ﾓｰﾄﾞ共通)
      (princ #Msg1)
      (command "._move" #ss "" #p1 pause)
    )
  );End if
  (setq #p1 (cdr(assoc 10 (entget #ebase))))
  ;;;指示仕様コードによる分岐
  (cond
    ;1点
    ((= &indcd 1)
      (setq #wang 0.0)                               ;回転角度0
      (setq #wlen &Wset)                             ;W値
      (setq #dlen &Dset)                             ;D値
    )
    ;1点+方向指示
    ((= &indcd 2)
      (princ #Msg2)                                   ;指示誘導ﾒｯｾｰｼﾞ
      (setq #p2 (getCommandRotatePoint #ss #p1 &Wset));回転&回転角上の点を取得
      (setq #wang (angle #p1 #p2))                    ;回転角度
      (setq #wlen &Wset)                              ;W値
      (setq #dlen &Dset)                              ;D値
    )
    ;1点+W方向+D方向
    ((= &indcd 3)
      ;２点目取得処理
      (princ #Msg2)                                   ;指示誘導ﾒｯｾｰｼﾞ
      (setq #p2 (getCommandRotatePoint #ss #p1 &Wset));回転&回転角上の点を取得
      (setq #wang (angle #p1 #p2))                    ;回転角度
      (setq #wlen &Wset)                              ;W値
      ;３点目取得処理
      (setq #p3 (getpoint #Msg3))                     ;３点目取得
      (if (not #p3)                                   ;入力改行なら
        (setq #dang (+ #wang pi))                     ;D方向なし
        (setq #dang (angle #p1 #p3))                  ;D方向角度
      )
      (setq #dlen &Dset)                              ;D値
      ;;方向変更による補正
      (if (< #dang #wang)                             ;差を出す為にD方向を大きくする。
        (setq #dang (+ #dang (* 2 pi)))
      )
      (if (> pi (- #dang #wang))(progn                ;D方向のﾍﾞｸﾄﾙがW方向に対して0～πなら
        (setq #p4 (polar #p1 #wang (/ #wlen 2)))      ;躯体の基点からW方向への中点
        (command "._rotate" #ss "" #p4 180)           ;180度回転
        (setq #wang (+ #wang pi))                     ;180度加算
      ));End if-progn
    )
    ((= &indcd 4);2点指示
      (setq #p2 (getpoint #p1 #Msg2))                 ;２点目取得
      (if (not #p2)                                   ;入力改行なら
        (progn
          (setq #wang 0.0)                            ;回転角度
          (setq #wlen &Wset)                          ;W値
        )
        (progn
          (setq #wang (angle #p1 #p2))                ;回転角度
          (command "._rotate" #ss "" #p1 (rtd #wang)) ;回転
          (setq #wlen (distance #p1 #p2))             ;W値
        )
      );End if
      (setq #dlen &Dset)                              ;D値
    )
    ((= &indcd 5);2点+D方向
      ;２点目取得処理
      (setq #p2 (getpoint #p1 #Msg2))                 ;２点目取得
      (if (not #p2)                                   ;入力改行なら
        (progn
          (setq #wang 0.0)                            ;0度
          (setq #wlen &Wset)                          ;W値
        )
        (progn
          (setq #wang (angle #p1 #p2))                ;回転角度
          (command "._rotate" #ss "" #p1 (rtd #wang)) ;回転
          (setq #wlen (distance #p1 #p2))             ;W値
        )
      );End if
      ;３点目取得処理
      (setq #p3 (getpoint #Msg3))                     ;３点目取得
      (if (not #p3)                                   ;入力改行なら
        (setq #dang (+ #wang pi))                     ;D方向なし
        (setq #dang (angle #p1 #p3))                  ;D方向角度
      );End if
      (setq #dlen &Dset)                              ;D値
      ;;方向変更による補正
      (if (< #dang #wang)                             ;差を出す為にD方向を大きくする。
        (setq #dang (+ #dang (* 2 pi)))
      )
      (if (> pi (- #dang #wang))(progn                ;D方向のﾍﾞｸﾄﾙがW方向に対して0～πなら
        (setq #p4 (polar #p1 #wang (/ #wlen 2)))      ;躯体の基点からW方向への中点
        (command "._rotate" #ss "" #p4 180)           ;180度回転
        (setq #wang (+ #wang pi))                     ;180度加算
      ));End if-progn
    )
    ;;;3点指示
    ((= &indcd 6)
      ;２点目取得処理
      (setq #p2 (getpoint #p1 #Msg2))                 ;２点目取得
      (if (not #p2)                                   ;入力改行なら
        (progn
          (setq #wang 0.0)                            ;0度
          (setq #wlen &Wset)                          ;W値
        )
        (progn
          (setq #wang (angle #p1 #p2))                ;回転角度
          (command "._rotate" #ss "" #p1 (rtd #wang)) ;回転
          (setq #wlen (distance #p1 #p2))             ;W値
        )
      );End if
      ;３点目取得処理
      (setq #p3 (getpoint #p1 #Msg3))                 ;３点目取得
      (if (not #p3)                                   ;入力改行なら
        (progn
          (setq #dang (+ #wang pi))                   ;D方向なし
          (setq #dlen &Dset)                          ;D値
        )
        (progn
          (setq #dang (angle #p1 #p3))                ;D方向角度
          (setq #dlen (distance #p1 #p3))             ;D値
        )
      )
      ;;方向変更による補正
      (if (< #dang #wang)                             ;差を出す為にD方向を大きくする。
        (setq #dang (+ #dang (* 2 pi)))
      );End if
      (if (> pi (- #dang #wang))(progn                ;D方向のﾍﾞｸﾄﾙがW方向に対して0～πなら
        (setq #p4 (polar #p1 #wang (/ #wlen 2)))      ;躯体の基点からW方向への中点
        (command "._rotate" #ss "" #p4 180)           ;180度回転
        (setq #wang (+ #wang pi))                     ;180度加算
      ));End if-progn
    )
  );End cond
  (setq #ss nil)
  ;(getangle)を使用する場合の開始角度と回転方向指示
  ;;;;方向指示が必要な場合の為にgetangleのBASEを初期化
  (setvar "ANGBASE" #ANGBASE)
  (setvar "ANGDIR"  #ANGDIR )

  (list #ebase #wang #wlen #dlen)
);kutaihaiti
;<HOM>*************************************************************************
; <関数名>    : kutaidlg
; <処理概要>  : 躯体ダイアログ処理
; <引　数>    : &?label 各入力項目名称 nilならばその項目は入力不可にする。
; <戻り値>    : ("w値" "d値" "h値" "b値")
; <作成>      : 2000/11/21 SN
; <備考>      :
;*************************************************************************>MOH<
(defun kutaidlg( 
  &Name
  &Wlabel &Dlabel &Hlabel &Blabel
  &Wcd    &Dcd    &Hcd    &Bcd
  &W      &D      &H      &B
  /
  #dcl_id
  #ret
  #cnum #cno
  )

  ;;; ｴﾃﾞｨｯﾄﾎﾞｯｸｽｺｰﾙﾊﾞｯｸ
  (defun edit_action (#key #val #why)
    (if (= #why 2)
      ;入力値のﾁｪｯｸを行います。
      (if (not(CheckStrNum #val))(progn
        (alert "数値を入力してください。")
        (mode_tile #key 2 )
      ));End if-progn
    );End if
  );End edit_action

  ;;; OKﾎﾞﾀﾝが押された時の関数
  (defun #action_accept( / #w_id #d_id #h_id #b_id #cno #wk)
    (setq #cno 0)
    ;W値入力項目
    (if &Wlabel
      (progn
        (setq #cno (1+ #cno))
        (setq #w_id (get_tile (strcat "EDIT" (itoa #cno))))
      )
      (setq #w_id (rtos &W))
    );End if-progn
    ;D値入力項目
    (if &Dlabel
      (progn
        (setq #cno (1+ #cno))
        (setq #d_id (get_tile (strcat "EDIT" (itoa #cno))))
      )
      (setq #d_id (rtos &D))
    );End if-progn
    ;H値入力項目
    (if &Hlabel
      (progn
        (setq #cno (1+ #cno))
        (setq #h_id (get_tile (strcat "EDIT" (itoa #cno))))
      )
      (setq #h_id (rtos &H))
    );End if-progn
    ;B値入力項目
    (if &Blabel
      (progn
        (setq #cno (1+ #cno))
        (setq #b_id (get_tile (strcat "EDIT" (itoa #cno))))
      )
      (setq #b_id (rtos &B))
    );End if-progn
    (list #w_id #d_id #h_id #b_id)
  );End #action_accept

  ;;; ﾀﾞｲｱﾛｸﾞの表示ﾗﾍﾞﾙがあれば実行
  (if (or &Wlabel &Dlabel &Hlabel &Blabel)
    (progn
      ;;; 表示項目数を数える
      (setq #cnum 0)
      (if &Wlabel (setq #cnum (1+ #cnum)))
      (if &Dlabel (setq #cnum (1+ #cnum)))
      (if &Hlabel (setq #cnum (1+ #cnum)))
      (if &Blabel (setq #cnum (1+ #cnum)))
      ;;; ﾀﾞｲｱﾛｸﾞのﾛｰﾄﾞと起動
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCKUTAI.DCL")))
      (if #dcl_id (progn
        (set_tile "TITLE" &Name)
        ;項目数に見合ったダイアログ
        (if (new_dialog (strcat "GetKUTAIInfoDlg" (itoa #cnum)) #dcl_id) (progn
          (setq #cno 0)
          ;W値入力項目
          (if &Wlabel (progn
            (setq #cno (1+ #cno))
            (set_tile (strcat "TEXT" (itoa #cno)) &Wlabel)
            (set_tile (strcat "EDIT" (itoa #cno)) (rtos &W))
            (action_tile (strcat "EDIT" (itoa #cno)) "(edit_action $key $value $reason)")
            (if (< #Wcd 0) (mode_tile (strcat "EDIT" (itoa #cno)) 1))
          ));End if-progn
          ;D値入力項目
          (if &Dlabel (progn
            (setq #cno (1+ #cno))
            (set_tile (strcat "TEXT" (itoa #cno)) &Dlabel)
            (set_tile (strcat "EDIT" (itoa #cno)) (rtos &D))
            (action_tile (strcat "EDIT" (itoa #cno)) "(edit_action $key $value $reason)")
            (if (< #Dcd 0) (mode_tile (strcat "EDIT" (itoa #cno)) 1))
          ));End if-progn
          ;H値入力項目
          (if &Hlabel (progn
            (setq #cno (1+ #cno))
            (set_tile (strcat "TEXT" (itoa #cno)) &Hlabel)
            (set_tile (strcat "EDIT" (itoa #cno)) (rtos &H))
            (action_tile (strcat "EDIT" (itoa #cno)) "(edit_action $key $value $reason)")
            (if (< #Hcd 0) (mode_tile (strcat "EDIT" (itoa #cno)) 1))
          ));End if-progn
          ;B値入力項目
          (if &Blabel (progn
            (setq #cno (1+ #cno))
            (set_tile (strcat "TEXT" (itoa #cno)) &Blabel)
            (set_tile (strcat "EDIT" (itoa #cno)) (rtos &B))
            (action_tile (strcat "EDIT" (itoa #cno)) "(edit_action $key $value $reason)")
            (if (< #Bcd 0) (mode_tile (strcat "EDIT" (itoa #cno)) 1))
          ));End if-progn
          (action_tile "accept" "(setq #ret (#action_accept))(done_dialog)")
          (action_tile "cancel" "(setq #ret nil)(done_dialog)")
          (start_dialog)
        ));End if-progn
        (unload_dialog #dcl_id)
      ));End if-progn
    );End progn
    (setq #ret (list &W &D &H &B))
  );End if
  #ret
);kutaidlg

;<HOM>*************************************************************************
; <関数名>    : CheckStrNum
; <処理概要>  : 文字列が"0"～"9"or"."の構成かチェックする。
; <引　数>    : 
; <戻り値>    : 文字列が"0"～"9"or"."の構成ならT
;               それ以外ならnilを返す。
; <作成>      : 2000/11/28 SN
; <備考>      :
;*************************************************************************>MOH<
(defun CheckStrNum( &str / #ii #chr #retflag #dotflag)
  (setq #dotflag nil)
  (setq #retflag T)
  (setq #ii 1)
  (repeat (strlen &str)
    (setq #chr (substr &str #ii 1))
    (cond
      ((= "." #chr)
        (if #dotflag
          (setq #retflag nil);既に"."検出済なら異常
          (setq #dotflag T)  ;    "."検出未なら検出済に・・
        )
      )
      ((not(and (<= "0" #chr) (<= #chr "9")))
        (setq #retflag nil);0～9以外なら異常
      )
    )
    (setq #ii (1+ #ii))
  )
  #retflag
)
;<HOM>*************************************************************************
; <関数名>    : getnumLASTPROMPT
; <処理概要>  : システム変数LASTPROMPTの最後尾にある数値を取得
; <引　数>    : なし
; <戻り値>    : 数字があればその数値を
;               それ以外ならnilを返す。
; <作成>      : 2000/11/29 SN
; <備考>      :
;*************************************************************************>MOH<
(defun getnumLASTPROMPT( / #lastprompt #chr #numstr #ii #flag)
  (setq #lastprompt (getvar "LASTPROMPT"))
  (setq #ii (strlen #lastprompt))
  (setq #numstr "")
  (setq #flag T)
  (while #flag
    (setq #chr (substr #lastprompt #ii 1))
    (if (or (= "." #chr) (and (<= "0" #chr ) (<= #chr "9")))
      (setq #numstr (strcat #chr #numstr))
      (setq #flag nil)
    );End if
    (setq #ii (1- #ii))
  );End while
  ;数字が無ければnilを返す
  (if (= #numstr "")
    nil
    (atof #numstr)
  )
);End getnumLASTPROMPT

;<HOM>*************************************************************************
; <関数名>    : getCommandRotatePoint
; <処理概要>  : rotateコマンドを実行、その回転角度を得る為の点を返す。
; <引　数>    : &ss    回転するｵﾌﾞｼﾞｪｸﾄの選択ｾｯﾄ
;             : &pbase 回転基点
;             : &len   戻り値点を得る為の回転基点からの距離
; <戻り値>    : 回転角度を得る為の点
; <作成>      : 2000/11/30 SN
; <備考>      :
;*************************************************************************>MOH<
;;; rotateコマンド後の指示点を得る
(defun getCommandRotatePoint( &ss &pbase &len / #lastpt #retpt #ang #dummyP #dummyObj)
  ;;;結果点取得用にﾀﾞﾐｰ点を作成
  (setq #dummyP (polar &pbase 0 &len))
  (if (entmake (list (cons 0 "POINT") (cons 10 #dummyP)))(progn
    (setq #dummyObj (entlast))
    (ssadd #dummyObj &ss)
  ));End if
  ;LASTPOINTでは取得できないことが判った
  ;;現在までの最終点を取得
  ;(setq #lastpt (getvar "LASTPOINT"))
  ;選択ｾｯﾄ内ｵﾌﾞｼﾞｪｸﾄの回転
  (command "._rotate" &ss "" &pbase pause)
  ;;最終点を取得
  ;(setq #retpt (getvar "LASTPOINT"))
  ;(if (equal #retpt #lastpt)
    ;rotate後点が変っていなければ角度値を入力されたと解釈
    (if #dummyObj
      (progn
        ;ﾀﾞﾐｰ点があればその点の座標を取得
        (setq #retpt (cdr(assoc 10 (entget #dummyObj))))
      )
      (progn
        ;ﾀﾞﾐｰ点が無ければ角度0の点を返す
        (setq #retpt #dummyP)
  ;      ;ﾀﾞﾐｰ点がなければ入力角度から座標を算出
  ;      ;ﾌﾟﾛﾝﾌﾟﾄから最後尾の数字を取る
  ;      (setq #ang (getnumLASTPROMPT))
  ;      (setq #retpt (polar &pbase #ang &len))
      );End progn
    );End if
  ;);End if
  ;;;点取得用ﾀﾞﾐｰ点を削除
  (if #dummyObj (progn
    (ssdel #dummyObj &ss)
    (entdel #dummyObj)
  ));End if-progn
  #retpt
);End getCommandRotatePoint
