;;;★★★　KPCAD連携用　★★★
;;;★★★　KPCAD連携用　★★★
;;;★★★　KPCAD連携用　★★★

;AutoCAD2014レギュラー版　ウッドワン用

;|
aaaa
bbb
ccc
ｺﾒﾝﾄ
|;

;;;<HOF>************************************************************************
;;; <ファイル名>: ACADDOC.LSP
;;; <システム名>: KitchenPlanシステム(ウッドワン様向け)
;;; <最終更新日>: 2011/10/04 YM 
;;; <備考>      : なし
;;;************************************************************************>FOH<

; ｸﾞﾛｰﾊﾞﾙ変数(★重要) 02/07/30 YM ADD
; 通常            :CG_AUTOMODE=0
; ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ     :CG_AUTOMODE=1
; WEB版CADｻｰﾊﾞｰ   :CG_AUTOMODE=2 -->起動直後"Input.cfg"を読込み-->ﾌﾟﾗﾝ検索～見積りまで
;                                \Layoutﾌｫﾙﾀﾞ内で行う
; WEB版LOCAL KPCAD:CG_AUTOMODE=3 -->起動直後"Input.cfg"を読込み-->ﾌﾟﾗﾝ検索～見積りまで
;                                通常の\BUKKENﾌｫﾙﾀﾞ内で行う
;;;<HOM>************************************************************************
;;; <関数名>  : S::STARTUP
;;; <処理概要>: KPCADシステム起動処理
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun S::STARTUP (
  /
  #seri$      ; SERIES情報
#NO #QRY$ #SDUM #SFNAME #date_time #rstr$ #FP #MSG #RSTR
#ALERTMSG #CDATE #CDATE_NOW #DUM_TENJO #SA #UNIT ;2010/01/08 YM ADD
#FIRST$ #PLANINFO$ ; 2011/01/04 YM ADD
  )
  ;CG_ACAD_INIT　は、acad.lspで初期化している
(princ "\n★★★★★★★★★★★")
(princ "\n★★★S::STARTUP★★★")
(princ "\n★★★★★★★★★★★")
(princ "\n")

	(princ "\n■■■　_FILETABCLOSE　■■■")	
	(princ "\n")

	(command "_FILETABCLOSE")

(setq #DWGPREFIX (getvar "DWGPREFIX"))
(princ "\n★★★DWGPREFIX= ")(princ #DWGPREFIX)
(princ "\n")

(setq #DWGNAME (getvar "DWGNAME"))
(princ "\n★★★DWGNAME= ")(princ #DWGNAME)
(princ "\n")

(princ "\n★★起動時システム変数の設定　開始★★★")
(princ "\n")

	;2012/08/24 YM ADD-S 出力関係ﾒﾆｭｰを実行した回数を記録する
	;物件名称書き換え回数を記録する
	(if (= CG_SYUTURYOKU_MENU nil)
		(setq CG_SYUTURYOKU_MENU 0)
	);_if
	;2012/08/24 YM ADD-E

  (setvar "CMDECHO"      0) ;プロンプトとユーザ入力をエコーバック非表示
  (setvar "SHORTCUTMENU" 2) ;編集モードのショートカット メニューを使用  01/06/08 HN ADD
  (setvar "PICKFIRST"    0) ;コマンドの発行後にオブジェクトを選択       01/08/24 HN ADD
  (setvar "GRIPS"        0) ;グリップを非表示                           01/09/09 HN ADD
  (setvar "DELOBJ"       1) ;extrudeで元のｵﾌﾞｼﾞｪｸﾄを削除する            02/06/17 YM ADD
  (setvar "PLINETYPE"    2) ;0:以前の形式のﾎﾟﾘﾗｲﾝを作成だとWTをはれない 03/02/13 YM ADD
  (setvar "MBUTTONPAN"   1) ;マウスホイール画面移動可能 03/03/28 YM ADD
	(setvar "3DOSMODE"     1) ;すべての 3D オブジェクト スナップを無効にする
  (setvar "DYNMODE"      0) ;ﾀﾞｲﾅﾐｯｸ入力を使用しない
  (setvar "XREFNOTIFY"   0) ;外部参照の通知を無効にします
  (setvar "SDI"          1) ;複数ファイルひらかない
  (setvar "MENUBAR"      1) ;従来ﾒﾆｭｰを表示 2010/01/06 YM ADD
  (setvar "UCSDETECT"    0) ;ダイナミック UCS をアクティブにしない 2011/10/11 YM ADD
  (setvar "CLAYER"     "0") ;現在の画層
;-- 2012/01/18 A.Satoh Add - S
  (setvar "SOLIDHIST"    0) ;ソリッドオブジェクトの履歴プロパティ設定：なし
														; 天板Rエンド加工の展開図作成用
;-- 2012/01/18 A.Satoh Add - E

	;2012/03/27 YM ADD-S
  (setvar "SELECTIONCYCLING" 0) ;選択の循環を強制的にOFFにする
	;2012/03/27 YM ADD-E

	;★SECURELOAD=0(信頼する場所にパスを通さなくてもロードするか聞いてこない)を定義しても、
	;　初回起動時に効かないので無駄だが定義しておく★
	;2015/03/17 YM ADD-S
	(setvar "SECURELOAD" 0)

(princ "\n★★起動時システム変数の設定　終了★★★")
(princ "\n")

  (if (= CG_ACAD_INIT nil) ; 初回図面オープン時 -------------------------------------------------------
    (progn
			(princ "\n★★★初回図面ｵｰﾌﾟﾝ時のみ通過★★★　CG_ACAD_INIT=nil")
			(princ "\n")

      ;// ｼｽﾃﾑ変数初期化
      (setvar "LISPINIT"  0)                 ;図面オープン時Lisp変数を初期化しない

			;2015/03/25 YM ADD-S レジストリからSYSPATHを取得せざるを得ない   \KPCAD_WOODONE\SYSTEM
			(setq CG_SYSPATH (vl-registry-read "HKEY_CURRENT_USER\\Software\\Apptec\\WOCAD\\AppInfo\\" "KPSysDir"))
			;2015/03/25 YM ADD パスを追加
			(setq CG_SUPPORT_PATH (getvar "DWGPREFIX"));C:\Program Files\Apptec\WOCAD 2014\Support








			(princ "\n★★★レジストリからSYSPATHを取得★★★　CG_SYSPATH=")(princ CG_SYSPATH)
			(princ "\n")

			(princ "\n★★★CG_SUPPORT_PATH＝")(princ CG_SUPPORT_PATH)
			(princ "\n")

			(setq #strlen (strlen CG_SUPPORT_PATH))
			(setq CG_WOCAD_PATH (substr CG_SUPPORT_PATH 1 (- #strlen 8))) ;C:\Program Files\Apptec\WOCAD 2014\

			(princ "\n★★★CG_WOCAD_PATH＝")(princ CG_WOCAD_PATH)
			(princ "\n")

			(setq CG_KPCAD_SYSTEM_PATH (strcat CG_WOCAD_PATH "KPCAD_SYSTEM\\")) ;C:\Program Files\Apptec\WOCAD 2014\KPCAD_SYSTEM

			(princ "\n★★★CG_KPCAD_SYSTEM_PATH＝")(princ CG_KPCAD_SYSTEM_PATH)
			(princ "\n")

;;;			(setq CG_SYSPATH (getvar "DWGPREFIX")) ;本ｼｽﾃﾑのｼｽﾃﾑﾊﾟｽ
			;2015/03/25 YM ADD-E レジストリからSYSPATHを取得せざるを得ない

			;初期設定のためのｿｰｽﾌｧｲﾙをﾛｰﾄﾞする
			;***************************************************
      (setq CG_PROGRAM (strcase (getvar "PROGRAM")))
      
      ;ACADのバージョンを取得
      (setq CG_ACADVER (substr (GETVAR "ACADVER") 1 2));2009==>17

			(princ "\n★★★CADプログラム名を取得★★★　CG_PROGRAM=")(princ CG_PROGRAM)
			(princ "\n")

			(princ "\n★★★CADバージョンを取得★★★　CG_ACADVER=")(princ CG_ACADVER)
			(princ "\n")
      
			;ｶｽﾀﾏｲｽﾞﾒﾆｭｰ(CUIﾌｧｲﾙ)のﾛｰﾄﾞ
			(princ "\n★★★KPCAD.cuixをﾛｰﾄﾞ Suppot直下におく★★★")
			(princ "\n")

			(command "Menu" (strcat CG_SYSPATH "KPCAD")) ;2015/02/18 YM KPCAD.cuixをﾛｰﾄﾞ

			(princ "\n★★★CommandLine強制表示★★★")
			(princ "\n")
			(command "CommandLine")


			(princ "\n★★INIT,GLOBALのﾛｰﾄﾞ★★★")
			(princ "\n")

			(if (= CG_PROGRAM "ACAD")
				(progn
					(load (strcat CG_SYSPATH "INIT"  )) ;ﾌﾟﾛｸﾞﾗﾑﾛｰﾄﾞ
					(load (strcat CG_SYSPATH "GLOBAL")) ;ｸﾞﾛｰﾊﾞﾙｾｯﾄ
				)
				;else
				(progn
					(load (strcat CG_KPCAD_SYSTEM_PATH "INIT"  )) ;ﾌﾟﾛｸﾞﾗﾑﾛｰﾄﾞ
					(load (strcat CG_KPCAD_SYSTEM_PATH "GLOBAL")) ;ｸﾞﾛｰﾊﾞﾙｾｯﾄ
				)
			);_if
			;***************************************************

      ; ここで分岐 WEB版CADｻｰﾊﾞｰでの自動ﾚｲｱｳﾄ実行
      ; Layout.ini の有無で判断

;;;2011/10/04YM@DEL      (setq CG_WEB_LAYOUT (WEB_Check_InputCFG)) ; WEB版自動ﾚｲｱｳﾄ==>T,それ以外nil

          ; (通常KPCAD or WEB版LOCAL CAD端末)
          (princ "\n********* 通常 or KPCAD端末 *************************")
          (princ "\n★★★　KPCAD連携起動　★★★")
          (setq CG_AUTOMODE 0)
          (princ "\nCG_AUTOMODE = ")(princ CG_AUTOMODE)

          (princ "\n★★★　INPUT.CFG　のﾛｰﾄﾞ　★★★")
          ;★★★ INPUT.CFG ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
          ;// 現在の件名情報(INPUT.CFG)を読み込む
          (setq CG_INPUTINFO$ (ReadIniFile (strcat CG_SYSPATH "INPUT.CFG")))

          (setq CG_BukkenName (cadr (assoc "ART_NAME" CG_INPUTINFO$)))           ;★物件名称★
          (princ "\n★★★　物件名称　★★★")
          (princ "\n物件名称 = ")(princ CG_BukkenName)

          (setq CG_BukkenNo "")                                                  ;物件番号

          (setq CG_EigyosyoName (cadr (assoc "BASE_BRANCH_NAME" CG_INPUTINFO$))) ;★営業所名★
          (princ "\n★★★　営業所名　★★★")
          (princ "\n営業所名 = ")(princ CG_EigyosyoName)

          (setq CG_PlanName "")                                                  ;プラン名称

          (setq CG_PlanNo (cadr (assoc "PLANNING_NO" CG_INPUTINFO$)))            ;★プラン番号★
          (princ "\n★★★　プラン番号　★★★")
          (princ "\nプラン番号 = ")(princ CG_PlanNo)

          (setq CG_VERSION_NO (cadr (assoc "VERSION_NO" CG_INPUTINFO$)))         ;★追番★
          (princ "\n★★★　追番　★★★")
          (princ "\n追番 = ")(princ CG_VERSION_NO)


          (setq CG_BASE_CHARGE_NAME (cadr (assoc "BASE_CHARGE_NAME" CG_INPUTINFO$)))         ;★営業担当★
          (princ "\n★★★　営業担当　★★★")
          (princ "\n営業担当 = ")(princ CG_BASE_CHARGE_NAME)

          (setq CG_ADDITION_CHARGE_NAME (cadr (assoc "ADDITION_CHARGE_NAME" CG_INPUTINFO$))) ;★見積(積算担当)★
          (princ "\n★★★　見積(積算担当)　★★★")
          (princ "\n見積(積算担当) = ")(princ CG_ADDITION_CHARGE_NAME)
          ;★★★ INPUT.CFG ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★


          ;// 初期設定情報(KPCAD.INI)を読み込む
          (princ "\n★★★　KPCAD.INI　のﾛｰﾄﾞ　★★★")

          (setq CG_INIINFO$    (ReadIniFile (strcat CG_SYSPATH "KPCAD.INI"))) ;00/03/05 HN MOD SYSCAD→KPCAD

          ;// 現在の件名情報(KENMEI.CFG)を読み込む
;;;          (setq CG_KENMEIINFO$ (ReadIniFile (strcat CG_SYSPATH "KENMEI.CFG"))) ; ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ時(C:KP_AutoEXEC)に再度読み込む

          ;//フォルダ名の設定
          (setq CG_SKDATAPATH      (cadr (assoc "SKDATAPATH"     CG_INIINFO$))) ;キッチン データ
          (setq CG_MSTDWGPATH      (strcat CG_SKDATAPATH "MASTER\\"  ))         ;部材マスター図面
          (setq CG_DRMSTDWGPATH    (strcat CG_SKDATAPATH "DRMASTER\\"))         ;扉面マスター図面
          (setq CG_LOGPATH         (cadr (assoc "LOGPATH"        CG_INIINFO$))) ;ログ出力ファイル
          (setq CG_KENMEIDATA_PATH (cadr (assoc "KENMEIDATAPATH" CG_INIINFO$))) ;件名データ
          (setq CG_KENMEI_PATH CG_KENMEIDATA_PATH) ; \KPCAD_WOODONE\WORK

          (setq CG_CDBNAME         (cadr (assoc "Common_DSName"  CG_INIINFO$))) ;共通ＤＢ名称 KS ADD

          (setq CG_DEBUG (cadr (assoc "DEBUG" CG_INIINFO$))) ;デバッグモード
          (if (= "1" CG_DEBUG) ; DL参照時にもﾃﾞﾊﾞｯｸﾓｰﾄﾞを追加
            (setq CG_DEBUG   1 CG_STOP   1 *error* nil)
            ;else
            (setq CG_DEBUG nil CG_STOP nil)
          );_if

          ;件名情報の設定を追加
          (setq CG_PROGMODE "PLAN")
          (setq CG_BrandCode "N")        ;ブランド記号

          ;// KPCAD初期化 ★★★ここでASILISP16をロードする★★★
          (princ "\n★★★　ｸﾞﾛｰﾊﾞﾙの設定・ARX,LISPのﾛｰﾄﾞ(InitKPCAD)　★★★")
          (InitKPCAD) ; ﾛｸﾞ,ｴﾗｰﾛｸﾞﾌｧｲﾙ名ここで定義

          (princ "\n★★★　input.cfg　のﾛｰﾄﾞ(KPCADSetFamilyCode)　★★★")
          ;ｸﾞﾛｰﾊﾞﾙ変数のｾｯﾄ
          (KPCADSetFamilyCode)

          (princ "\n★★★　running.flg　の書き込み　★★★")
          (setq #sFname (strcat CG_KENMEI_PATH "running.flg"))
          (setq #fp  (open #sFname "w"))
          (princ "running.flg" #fp);書き込み
          (close #fp)
          

          (princ "\n★★★　PLANINFO.CFG　の出力　★★★")
          (princ "\n★　CG_SeriesDB＝　")   (princ CG_SeriesDB   )
          (princ "\n★　CG_SeriesCode＝　") (princ CG_SeriesCode )
          (princ "\n★　CG_DRSeriCode＝　") (princ CG_DRSeriCode )
          (princ "\n★　CG_DRColCode＝　")  (princ CG_DRColCode  )
          (princ "\n★　CG_HIKITE＝　")     (princ CG_HIKITE     )
          (princ "\n★　CG_CeilHeight＝　") (princ CG_CeilHeight )
          (princ "\n★　CG_UpCabHeight＝　")(princ CG_UpCabHeight)

          ; PlanInfo.cfg出力
          (setq #PLANINFO$
            (list
              (list "SeriesDB"        CG_SeriesDB   );シリーズDB名
              (list "SeriesCode"      CG_SeriesCode );シリーズ記号
              (list "DoorSeriesCode"  CG_DRSeriCode );扉シリーズ記号
              (list "DoorColorCode"   CG_DRColCode  );扉カラー記号
              (list "DoorHandle"      CG_HIKITE     );引手記号
              (list "ElecType"        CG_ElecType   );電気種
              (list "GasType"         CG_GasType    );ガス種
              (list "WorkTopHeight"   CG_WTHeight   );ワークトップ高さ
              (list "Width"           (itoa (fix CG_RoomW))      );間口
              (list "Depth"           (itoa (fix CG_RoomD))      );奥行
              (list "CeilingHeight"   (itoa (fix CG_CeilHeight)) );天井高さ
              (list "SetHeight"       (itoa (fix CG_UpCabHeight)));取付高さ
            )
          )

          (setq #sFname (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
          (setq #fp  (open #sFname "w"))
          (if (/= nil #fp)
            (progn
							(princ "\n[KPCAD]\n" #fp);2011/10/14 YM ADD ｾｸｼｮﾝ追加
              (foreach #elm #PLANINFO$
                (if (= ";" (substr (car #elm) 1 1))
                  (princ (car #elm) #fp)
                  (princ (strcat (car #elm) "=" (cadr #elm)) #fp)
                );_if
                (princ "\n" #fp)
              )
              (close #fp)
            )
            (progn
              (CFAlertMsg "PLANINFO.CFGへの書き込みに失敗しました。")
              (*error*)
            )
          );_if

;-- 2011/10/21 A.Satoh Add - S
					; 図面の物件名称書き換え
;;;					(KP_BukkenInfoRewrite) ;出力関係ﾒﾆｭｰに移動
;-- 2011/10/21 A.Satoh Add - E
; --- ここから共通 ---

(princ (strcat "\n☆☆☆　--- ここから共通 ---　☆☆☆"))

;;;(princ (strcat "\n☆☆☆　CG_BukkenNo = " CG_BukkenNo))
;;;(princ (strcat "\n☆☆☆　CG_BukkenName = " CG_BukkenName))
;;;(princ (strcat "\n☆☆☆　CG_PlanNo = " CG_PlanNo))
;;;(princ (strcat "\n☆☆☆　CG_PlanName = " CG_PlanName))
;;;(princ (strcat "\n☆☆☆　CG_PROGMODE = " CG_PROGMODE))
;;;(princ (strcat "\n☆☆☆　CG_KENMEI_PATH = " CG_KENMEI_PATH))
;;;(princ (strcat "\n☆☆☆　CG_SeriesDB = " CG_SeriesDB))
;;;(princ (strcat "\n☆☆☆　CG_SeriesCode = " CG_SeriesCode))
;;;(princ (strcat "\n☆☆☆　CG_DRSeriCode = " CG_DRSeriCode))
;;;(princ (strcat "\n☆☆☆　CG_DRColCode = " CG_DRColCode))
;;;(princ (strcat "\n☆☆☆　CG_HIKITE = " CG_HIKITE))
      
;;;(princ "\n********* --- ここから共通 --- *************************")
;;;      (ChgSystemCADMenu CG_PROGMODE) WEB版は必要ない
;;;(princ "\n★ここから共通★")


      (if CG_BukkenNo
        (progn
          (if (tblsearch "LAYER" "Z_00_00_00_01")
            (command "_layer" "T" "Z_00_00_00_01" "ON" "Z_00_00_00_01" "")
            (MakeLayer "Z_00_00_00_01" 7 "CONTINUOUS")
          )
          ;2011/04/22 YM MOD
          (setvar "MODEMACRO"
            (strcat "ｼﾘｰｽﾞ: " CG_SeriesDB " / 扉ｸﾞﾚｰﾄﾞ: " CG_DRSeriCode " / 扉ｶﾗｰ: " CG_DRColCode " / 引手: " CG_HIKITE)
          )
          (MakeLayer "N_Symbol" 4 "CONTINUOUS")
          (MakeLayer "N_BreakD" 6 "CONTINUOUS")
          (MakeLayer "N_BreakW" 6 "CONTINUOUS")
          (MakeLayer "N_BreakH" 6 "CONTINUOUS")
          (command "_layer" "of" "N_B*" "")
        )
      );_if


      (setq CG_ACAD_INIT T)   ;AutoCAD初期設定完了(次回の図面オープンで上記初期設定を行わない）


;2011/02/01 YM ADD 【PG分岐】追加
(if (= BU_CODE_0001 nil) (PKC_PG_BUNKI))

      (setq CG_SetXRecord$
        (list
          CG_DBNAME       ; 0.DB名称
          CG_SeriesCode   ; 1.SERIES記号
          CG_BrandCode    ; 2.ブランド記号
          CG_DRSeriCode   ; 3.扉SERIES記号
          CG_DRColCode    ; 4.扉COLOR記号
          CG_HIKITE       ; 5.ヒキテ記号
          CG_UpCabHeight  ; 6.取付高さ
          CG_CeilHeight   ; 7.天井高さ
          CG_RoomW        ; 8.部屋間口
          CG_RoomD        ; 9.部屋奥行
          CG_GasType      ;10.ガス種
          CG_ElecType     ;11.電気種
          CG_KikiColor    ;12.機器色
          CG_KekomiCode   ;13.ケコミ飾り
        )
      )

      (cond
        ((= CG_AUTOMODE 0)
          (setq CG_OpenMode 0)  ; 通常
        )
        ((= CG_AUTOMODE 1)
          (setq CG_OpenMode -1) ; ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ
        )
        ((= CG_AUTOMODE 2)
          (setq CG_OpenMode -2) ; WEB版CADｻｰﾊﾞｰ
        )
        ((= CG_AUTOMODE 3)
          (setq CG_OpenMode -3) ; WEB版LOCAL CAD端末
        )
      );_cond

(princ (strcat "\n☆☆☆　CG_AUTOMODE = " ))(princ CG_AUTOMODE)
(princ (strcat "\n☆☆☆　CG_OpenMode = " ))(princ CG_OpenMode)

      (command "_point" "0,0")

			(setq #DWGNAME (getvar "DWGNAME"))
			(princ "\n★★★DWGNAME= ")(princ #DWGNAME)

			(setq #DWGPREFIX (getvar "DWGPREFIX"))
			(princ "\n★★★DWGPREFIX= ")(princ #DWGPREFIX)


;;;(princ "\n☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆")
;;;(princ (strcat "\n☆☆☆　CG_KENMEI_PATH = " CG_KENMEI_PATH))
;;;(princ (strcat "\n☆☆☆　ｽｸﾘﾌﾟﾄﾌｧｲﾙを使用して MODEL.DWG を開きます(CfDwgOpenByScript)"))
;;;(princ "\n☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆")

      ;// 選択された物件の図面を開く
;2015/03/17 YM ADD
;;;      (CfDwgOpenByScript (strcat CG_KENMEI_PATH "MODEL.DWG"))

      ;04/12/10 YM 上から移動
     (ChgSystemCADMenu CG_PROGMODE) ; WEB版は必要ない

    )
  );_if  ; 初回図面オープン時 -------------------------------------------------------

(princ (strcat "\n☆☆☆　初回図面オープン時処理終了!　☆☆☆"))

(princ "\n")

  (if (= CG_AUTOMODE 2)
    nil
    ;else
    (princ (strcat "\n見積No:[" CG_PlanNo "-" CG_VERSION_NO "]の図面を開いています..."))
  );_if
	(princ "\n")

  ;// 図面の拡張レコードをグローバルに設定
  (if (= nil CG_DBNAME)
    (progn
      (setq #seri$ (CFGetXRecord "SERI"))
      (if #seri$
        (progn
          (setq CG_DBNAME      (nth  0 #seri$)) ; 1.DB名称
          (setq CG_SeriesCode  (nth  1 #seri$)) ; 2.SERIES記号
          (setq CG_BrandCode               "N") ; 3.ブランド記号
          (setq CG_DRSeriCode  (nth  2 #seri$)) ; 2.扉SERIES記号★
          (setq CG_DRColCode   (nth  3 #seri$)) ; 3.扉COLOR記号★
          (setq CG_HIKITE      (nth  4 #seri$)) ; 4.ヒキテ記号★
          (setq CG_UpCabHeight (nth  5 #seri$)) ; 6.取付高さ
          (setq CG_CeilHeight  (nth  5 #seri$)) ; 7.天井高さ
          (setq CG_RoomW       (nth  6 #seri$)) ; 8.部屋間口
          (setq CG_RoomD       (nth  7 #seri$)) ; 9.部屋奥行
          (setq CG_GasType     (nth  8 #seri$)) ;10.ガス種
;;;          (setq CG_ElecType    (nth 10 #seri$)) ;11.電気種
;;;          (setq CG_KikiColor   (nth 11 #seri$)) ;12.機器色
;;;          (setq CG_KekomiCode  (nth 12 #seri$)) ;13.ケコミ飾り

          ;// SERIES別データベースへの接続
          (if (= CG_DBSESSION nil)
            (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
          );_if
        )
      );_if
    )
  );_if


;;;  (if (= nil CG_KikiColor)
;;;    (setq CG_KikiColor "5")
;;;  )

  (if CG_SCFConf ; 02/03/04 YM 図面参照時なら
    (progn
      (command "_.ZOOM" "E")
      ;2011/08/12 YM ADD 図面参照
      ;ﾊﾟｰｽ図の場合ﾊﾟｰｽﾋﾞｭｰにしたい
      (subSCFConf)
      (setq CG_SCFConf nil)

			;2011/10/11 YM ADD-S
			(defun c:p0( / )(setvar "pickfirst" 0))
			(defun c:p1( / )(setvar "pickfirst" 1))
			(defun c:g0( / )(setvar "GRIPS"     0))
			(defun c:g1( / )(setvar "GRIPS"     1))
			;2011/10/11 YM ADD-E
    )
    (progn ; それ以外 02/03/18 YM ADD-S

			;2011/10/11 YM ADD-S
			(defun c:p0( / )(princ "\nこのｺﾏﾝﾄﾞは図面参照でしか使えません")(princ))
			(defun c:p1( / )(princ "\nこのｺﾏﾝﾄﾞは図面参照でしか使えません")(princ))
			(defun c:g0( / )(princ "\nこのｺﾏﾝﾄﾞは図面参照でしか使えません")(princ))
			(defun c:g1( / )(princ "\nこのｺﾏﾝﾄﾞは図面参照でしか使えません")(princ))
			;2011/10/11 YM ADD-E

      (if (/= CG_OpenMode 5)  ; 02/04/10 YM ADD
        (setvar "TILEMODE" 1) ; ﾓﾃﾞﾙﾀﾌﾞにする
      );_if                   ; 02/04/10 YM ADD
    ) ; それ以外 02/03/18 YM ADD-E
  );_if


  ;00/09/06 SN ADD XRECORD用Listに値を設定する。
  (setq CG_SetXRecord$
    (list
      CG_DBNAME       ; 0.DB名称
      CG_SeriesCode   ; 1.SERIES記号
      CG_BrandCode    ; 3.ブランド記号
      CG_DRSeriCode   ; 2.扉SERIES記号
      CG_DRColCode    ; 3.扉COLOR記号
      CG_HIKITE       ; 4.ヒキテ記号
      CG_UpCabHeight  ; 6.取付高さ
      CG_CeilHeight   ; 5.天井高さ
      CG_RoomW        ; 6.部屋間口
      CG_RoomD        ; 7.部屋奥行
      CG_GasType      ; 8.ガス種
;;;      CG_ElecType     ;11.電気種
;;;      CG_KikiColor    ;12.機器色
;;;      CG_KekomiCode   ;13.ケコミ飾り
    )
  )
  ;2011/04/22 YM MOD
  (setvar "MODEMACRO"
    (strcat "ｼﾘｰｽﾞ: " CG_SeriesDB " / 扉ｸﾞﾚｰﾄﾞ: " CG_DRSeriCode " / 扉ｶﾗｰ: " CG_DRColCode " / 引手: " CG_HIKITE)
  )

  (setvar "EXPERT" 4)               ;確認プロンプトOFF
  (command "_UCSICON" "A" "OF")     ;UCSアイコンの非表示

  (cond
    ; 02/08/05 YM ADD-S
    ((= CG_OpenMode -3) ; WEB版LOCAL CAD端末
      (if (= "MODEL.DWG" (strcase (getvar "DWGNAME")))
        (progn

          ;(setq CG_OpenMode nil)
          (CFSetXRecord "SERI" CG_SetXRecord$)
          ;// 間口領域の更新
          (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)

          (if (= CG_DBSESSION  nil) (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" "")))
          (if (= CG_CDBSESSION nil) (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" "")))
          (princ (strcat "\n" CG_BukkenNo ":" CG_BukkenName "に設定されました"))
          ;2011/04/22 YM MOD
          (setvar "MODEMACRO"
            (strcat "ｼﾘｰｽﾞ: " CG_SeriesDB " / 扉ｸﾞﾚｰﾄﾞ: " CG_DRSeriCode " / 扉ｶﾗｰ: " CG_DRColCode " / 引手: " CG_HIKITE)
          )
          ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
          (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

          ; ﾌﾟﾗﾝ検索から展開図,ﾚｲｱｳﾄ,見積りまで自動実行(但し印刷は)
          ; CG_ZumenPRINT , CG_MitumoriPRINT が1のときに行う。
          (setq CG_OpenMode 0) ; 次に(S::STARTUP)を通るときのため
          (C:KPLocalAutoEXEC)
        )
      );_if
    )
    ; 02/08/05 YM ADD-E

    ; 02/07/29 YM ADD-S Web版CADｻｰﾊﾞｰ自動ﾚｲｱｳﾄ
    ((= CG_OpenMode -2)

      (if (= "MODEL.DWG" (strcase (getvar "DWGNAME")))
        (progn
          ;(setq CG_OpenMode nil)
          (CFSetXRecord "SERI" CG_SetXRecord$)
          ;// 間口領域の更新
          (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)

          (if (= CG_DBSESSION  nil) (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" "")))
          (if (= CG_CDBSESSION nil) (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" "")))
          (princ (strcat "\n" CG_BukkenNo ":" CG_BukkenName "に設定されました"))
          ;2011/04/22 YM MOD
          (setvar "MODEMACRO"
            (strcat "ｼﾘｰｽﾞ: " CG_SeriesDB " / 扉ｸﾞﾚｰﾄﾞ: " CG_DRSeriCode " / 扉ｶﾗｰ: " CG_DRColCode " / 引手: " CG_HIKITE)
          )
          ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
          (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

          ; ﾌﾟﾗﾝ検索から展開図,ﾚｲｱｳﾄ,見積りまで自動実行(但し印刷は)
          ; CG_ZumenPRINT , CG_MitumoriPRINT が1のときに行う。
          (setq CG_OpenMode 0) ; 次に(S::STARTUP)を通るときのため
          (C:Web_AutoEXEC)
        )
      );_if

    )

    ; 01/09/11 YM ADD-S
    ((= CG_OpenMode -1) ; ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ
      (if (= "MODEL.DWG" (strcase (getvar "DWGNAME")))
        (progn
          ;(setq CG_OpenMode nil)
          (CFSetXRecord "SERI" CG_SetXRecord$)
          ;// 間口領域の更新
          (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)

          (if (= CG_DBSESSION  nil) (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" "")))
          (if (= CG_CDBSESSION nil) (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" "")))
          (princ (strcat "\n" CG_BukkenNo ":" CG_BukkenName "に設定されました"))
          ;2011/04/22 YM MOD
          (setvar "MODEMACRO"
            (strcat "ｼﾘｰｽﾞ: " CG_SeriesDB " / 扉ｸﾞﾚｰﾄﾞ: " CG_DRSeriCode " / 扉ｶﾗｰ: " CG_DRColCode " / 引手: " CG_HIKITE)
          )
          ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
          (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

          ; ﾌﾟﾗﾝ検索から展開図,ﾚｲｱｳﾄ,見積りまで自動実行(但し印刷は)
          ; CG_ZumenPRINT , CG_MitumoriPRINT が1のときに行う。
          (setq CG_OpenMode 0) ; 次に(S::STARTUP)を通るときのため
          (C:KP_AutoEXEC)
        )
      );_if
    )
    ; 01/09/11 YM ADD-E
    ((= CG_OpenMode 1)      ;キッチン、ダイニングのプラン検索を実行する
      (C:PC_LayoutPlan)     ;00/02/03 MOD SC_LayoutPlan → PC_LayoutPlan
    )
    ((= CG_OpenMode 2)      ;物件図面に戻りプラン検索完成図面をInsertさせる
      (C:PC_InsertPlan)     ;00/02/03 MOD SC_InsertPlan → PC_InsertPlan
     )
    ((= CG_OpenMode 3)
      (C:SB_LayoutPlan)     ;システムバスのプラン検索を実行する
    )
    ;00/02/20 HN MOD 図面レイアウト処理変更
    ((= CG_OpenMode 4)      ;図面レイアウト用
      (setvar "CMDECHO" 0)
      (SCFLayoutDrawBefore)
    )
    ((= CG_OpenMode 5)      ;テンプレート作成用
      (SCFMkTplBefore)
    )
    ;;; 00/09/01 YM ADD ;;;
    ((= CG_OpenMode 6)      ;広角度ｷｬﾋﾞﾈｯﾄ配置
      (PKPutWideCab)
    )
    ((= CG_OpenMode 7)      ;広角度ｷｬﾋﾞﾈｯﾄ挿入
      (PKInsertWideCab)
    )
    ;;; 00/09/01 YM ADD ;;;
    ((= CG_OpenMode 8)      ;01/03/05 YM ADD 展開図作成後

			; 2017/09/14 KY ADD-S
			; フレームキッチン対応
			(if (= BU_CODE_0012 "1") ; フレームキッチンの場合
				(progn
					(setq #ss (ssget "X" '((-3 ("G_DEL")))))
					(if #ss
						(progn
							(command "_.ERASE" #ss "")
							(setq #ss nil)
							(CfAutoSave)
						);progn
					);if
				);progn
			);if
			; 2017/09/14 KY ADD-E

      (if CG_TENKAI_OK
        (progn
          ;;; SET品関連修正 01/02/07 YM STRAT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (setq #NO nil)
          (if (KcCheckSetMITUMORI) ; ｾｯﾄ品見積りが有効(G_WTSET存在)
            (if (CFYesNoDialog msg7)
              (progn ; SET見積りﾕｰｻﾞｰYes
                (SKChgView "2,-2,1") ; 01/05/16 YM ADD 視点南東
                (C:SetHINCheck) ; ｾｯﾄ品を考慮したTable.cfg出力
                (command "._zoom" "P") ; 視点を元に戻す 01/05/28 YM
                (setq #NO "1") ; ここではTable.cfg更新なし
              )
              (setq #NO "2") ; SET見積りﾕｰｻﾞｰNo ここでは存在しないならTable.cfg更新
            );_if
            (setq #NO "3")   ; ｾｯﾄ品見積りが無効  ここではTable.cfg強制更新
          );_if

          (cond
            ((= #NO "1")
              (princ) ; OLD_TABLE.CFG出力しない
            )
            ((= #NO "2")
              (setq #sFname (strcat CG_KENMEI_PATH "TABLE.CFG"))
              (if (= (findfile #sFname) nil)
                (SCFMakeBlockTable);Table.cfgを検索無ければ書き出す。
              );_if
            )
            ((= #NO "3")
              (if CG_TABLE ; 展開図作成ｺﾏﾝﾄﾞで出力済み
                (princ)
                (SCFMakeBlockTable) ; 出力済みでないとき強制更新
              )
            )
            (T
              (SCFMakeBlockTable) ; 強制更新
            )
          );_cond
          (setq CG_TABLE nil)
          ;;; SET品関連修正 01/02/07 YM END   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        )
      );_if
      (setq CG_TENKAI_OK nil CG_OpenMode 0) ; 01/03/08 YM ADD
    )
    ((= CG_OpenMode 0)  ;00/02/20 HN MOD 4→0 物件起動用
      (if (= "MODEL.DWG" (strcase (getvar "DWGNAME")))
        (progn
          ;(setq CG_OpenMode nil)
          (CFSetXRecord "SERI" CG_SetXRecord$)
          ;// 間口領域の更新
          (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)

          (if (= CG_DBSESSION  nil) (setq CG_DBSESSION  (dbconnect CG_DBNAME  "" "")))
          (if (= CG_CDBSESSION nil) (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" "")))
          (princ (strcat "\n" CG_BukkenNo ":" CG_BukkenName "に設定されました"))
          ;2011/04/22 YM MOD
          (setvar "MODEMACRO"
            (strcat "ｼﾘｰｽﾞ: " CG_SeriesDB " / 扉ｸﾞﾚｰﾄﾞ: " CG_DRSeriCode " / 扉ｶﾗｰ: " CG_DRColCode " / 引手: " CG_HIKITE)
          )

      ;;; (command "._style" "standard" "ＭＳ 明朝" "" "" "" "" "") ; ｼﾝｸｷｬﾋﾞの"????"をなくす07/07 YM
          ;(command "._style" "standard" "txt.shx,bigfont.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD
          (command "._style" "standard" "txt.shx,extfont2.shx" "" "" "" "" "" "") ; 2011/05/30 YM MOD

;;;01/09/03YM@MOD         (C:CabShow) ; 非表示ｷｬﾋﾞを表示する 01/05/31 YM ADD
          (CabShow_sub) ; 01/09/03 YM MOD 関数化

          ; 02/06/06 YM ADD
          (C:Del0door) ; 自動図面修復機能("0_door" "0_plane" "0_wall"画層削除、"0_door"存在→部材更新)

(princ "\nCG_OpenMode = 0 (PKAutoHinbanKakutei)直前")
          ;// ワークトップが品番未確定なら自動確定する
          (PKAutoHinbanKakutei) ; 06/26 YM ADD
(princ "\nCG_OpenMode = 0 (PKAutoHinbanKakutei)直後")

(princ "\nCG_OpenMode = 0 (PKAutoTokuTenban)直前")
;-- 2011/09/13 A.Satoh Add - S
          ; ワークトップが規格品であり、水栓が1個でない場合は、天板特注化を行う
          (PKAutoTokuTenban)
(princ "\nCG_OpenMode = 0 (PKAutoTokuTenban)直後")
;-- 2011/09/13 A.Satoh Add - E

          ;(command "_qsave")
        )
        ;01/09/16 HN S-DEL 関数最後に移動
        ;@DEL@;01/09/09 HN S-ADD Model.dwg以外は、オブジェクト選択を変更
        ;@DEL@(progn
        ;@DEL@  (setvar "PICKFIRST" 1)    ; コマンドの発行前にオブジェクトを選択
        ;@DEL@  (setvar "GRIPS"     1)    ; グリップを表示            01/09/09 HN ADD
        ;@DEL@)
        ;@DEL@;01/09/09 HN E-ADD Model.dwg以外は、オブジェクト選択を変更
        ;01/09/16 HN E-DEL 関数最後に移動
      );_if
    )

    ((= CG_OpenMode 9) ;プレゼン用パース(JPEG)印刷
      (COMM03sub)
    )
    ((= CG_OpenMode 10) ;dxf出力
      (DXF_OUT)
    )
    ((= CG_OpenMode 99) ;プレゼン用パース(JPEG)印刷
      (JPG-OUTPUT_sub)
    )

    ; 03/04/28 YM ADD
    ((= CG_OpenMode 999) ;ﾌﾟﾗﾝ登録LR反転処理用(C:AutoMrr)
      (sub_AutoMrr)
    )

    ; 03/05/08 YM ADD
    ((= CG_OpenMode 888) ;ﾌﾟﾗﾝ登録表示処理用(C:AutoView)
      (sub_AutoView)
    )

    ; 03/05/08 YM ADD
    ((= CG_OpenMode 777) ;ﾌﾟﾗﾝ登録挿入基点変更用(C:Automove)
      (sub_Automove)
    )

    ; 03/05/13 YM ADD
    ((= CG_OpenMode 666) ;ﾌﾟﾗﾝ登録扉削除用(C:AutoDoorDel)
      (sub_AutoDoorDel)
    )

    ; 03/05/13 YM ADD
    ((= CG_OpenMode 555) ;MASTER,DRMASTER 2000形式化
      (sub_AutoSAVE2000)
    )

    ; 03/06/24 YM ADD
    ((= CG_OpenMode 444) ;ﾌﾟﾗﾝ登録 部材更新、扉削除、ｸﾞﾙｰﾌﾟ削除用(C:AutoKOUSIN)
      (sub_AutoKOUSIN)
    )
  );_cond

	(princ "\n☆☆☆　CG_OpenMode によるcond文終了")

  ;00/01/27 HN S-ADD デバッグ用出力を追加
  (setvar "LISPINIT"     0)
  ;@@@(setvar "ACADLSPASDOC" 1)  ;00/05/22 HN DEL OEM対応で削除
  (setvar "CMDECHO"      0)
  ;@DEBUG@(princ "\n LISPINIT: "    )(princ (getvar "LISPINIT"    ))
  ;@DEBUG@(princ "\n ACADLSPASDOC: ")(princ (getvar "ACADLSPASDOC"))
  ;@DEBUG@(princ "\n CMDECHO: "     )(princ (getvar "CMDECHO"     ))
  ;00/01/27 HN E-ADD デバッグ用出力を追加

  ;01/09/16 HN S-ADD オブジェクト選択変更とUNDO コマンド情報を放棄
  (if (and (/= "MODEL.DWG" (strcase (getvar "DWGNAME")))
           (/= "M_0.DWG" (strcase (getvar "DWGNAME")))
					 (/= "M_1.DWG" (strcase (getvar "DWGNAME"))) ;2012/01/17 YM ADD
					 (/= "M_2.DWG" (strcase (getvar "DWGNAME"))));2012/01/17 YM ADD
    (progn
      (setvar "PICKFIRST" 1)      ; コマンドの発行前にオブジェクトを選択
      (setvar "GRIPS"     1)      ; グリップを表示
      (command ".UNDO" "C" "N")   ; UNDO コマンド情報を放棄
      (command ".UNDO"     "A")   ; UNDO コマンドをすべてオン
      
      (setvar "FILEDIA" 1)        ; 図面参照では常にダイアログ表示
      (if (/= ".dwt" (vl-filename-extension (getvar "DWGNAME")))
        (progn
          ; 図面参照では現在の高度を常に15000
          (setvar "ELEVATION" CG_LAYOUT_DIM_Z)
          (princ "\nELEVATION :")(princ (getvar "ELEVATION"))
        )
      );_if

      ;2011/07/25 YM ADD-S
      ;初回ｵｰﾌﾟﾝ時Xrecord"FIRST"をｾｯﾄする
      ;Xrecord"FIRST"がなければ躯体を非表示にする
      (setq #first$ (CFGetXRecord "FIRST"))
;-- 2011/11/15 A.Satoh Mod - S *** 暫定処理
;;;;;      (if #first$
;;;;;        (progn
;;;;;          nil
;;;;;        )
;;;;;        (progn
;;;;;          ;躯体非表示
;;;;;          (command "_.LAYER" "F" "0_KUTAI" "")
;;;;;          (CFSetXRecord "FIRST" (list 1))
;;;;;        )
;;;;;      );_if
			(if (= #first$ nil)
        (progn
          ;躯体非表示
          (command "_.LAYER" "F" "0_KUTAI" "")

					;2013/10/03 YM ADD もし施工図なら
					(if (wcmatch (strcase (getvar "DWGNAME")) "*_04*.DWG" )
	          (command "_.LAYER" "F" "0_door" "");2013/09/17 YM ADD 扉模様も最初非表示にする
					);_if

          (CFSetXRecord "FIRST" (list 2))
        )
				(if (= (nth 0 #first$) 1)
					(progn
	          ;躯体非表示
  	        (command "_.LAYER" "F" "0_KUTAI" "")

						;2013/10/03 YM ADD もし施工図なら
						(if (wcmatch (strcase (getvar "DWGNAME")) "*_04*.DWG" )
          		(command "_.LAYER" "F" "0_door" "");2013/09/17 YM ADD 扉模様も最初非表示にする
						);_if

    	      (CFSetXRecord "FIRST" (list 2))
					)
					nil
				)
			)
;-- 2011/11/15 A.Satoh Mod - E *** 暫定処理
      ;2011/07/25 YM ADD-E
    )
    ;2011/07/15 YM ADD TSからｺﾋﾟｰ
    (progn

			(princ "\n☆☆☆　Model.dwgの場合")

;-- 2011/10/05 A.Satoh Add - S
      (if (/= CG_OSMODE_BAK nil)
        (progn
          (setvar "OSMODE" CG_OSMODE_BAK)
          (setq CG_OSMODE_BAK nil)
        )
      )
      (if (/= CG_SNAPMODE_BAK nil)
        (progn
          (setvar "SNAPMODE" CG_SNAPMODE_BAK)
          (setq CG_SNAPMODE_BAK nil)
        )
      )
      (if (/= CG_ORTHOMODE_BAK nil)
        (progn
          (setvar "ORTHOMODE" CG_ORTHOMODE_BAK)
          (setq CG_ORTHOMODE_BAK nil)
        )
      )
      (if (/= CG_GRIDMODE_BAK nil)
        (progn
          (setvar "GRIDMODE" CG_GRIDMODE_BAK)
          (setq CG_GRIDMODE_BAK nil)
        )
      )

			(princ "\n☆☆☆　Model.dwgの場合 矢視画層の制御 before")
;-- 2011/10/05 A.Satoh Add - E
      ;矢視画層の制御
      (cond
        ((= CG_PROGMODE "PLAN")
          ;矢視関連図形を非表示とする
          (CFHideYashiLayer)
        )
        ((= CG_PROGMODE "PLOT")
          ;矢視関連図形を表示する
          (CFDispYashiLayer)
        )
      )
			(princ "\n☆☆☆　Model.dwgの場合 矢視画層の制御 after")

    )

  );_if
  ;01/09/16 HN E-ADD オブジェクト選択変更とUNDO コマンド情報を放棄

;@@@ ﾃﾞﾊﾞｯｸﾞ用ﾁｪｯｸﾗｲﾄ 02/07/29 YM ADD @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;; (close #fp)

	(command "_RIBBONCLOSE")
	(princ "\n■■■　S::STARTUP　終了　■■■")	
	(princ "\n")

  (princ)
);;;S::STARTUP

;;;<HOM>************************************************************************
;;; <関数名>    : WEB_Check_InputCFG
;;; <処理概要>  : "Layout.ini" の有無を判定 CG_SYSPATH=(getvar "DWGPREFIX")内
;;; <戻り値>    : T(あり) or nil(なし)
;;; <作成>      : 02/07/26 YM
;;; <備考>      : 戻り値=TならCADｻｰﾊﾞｰ上の動作(自動ﾚｲｱｳﾄ)を行う
;;;************************************************************************>MOH<
(defun WEB_Check_InputCFG (
  /
  #RET
  )
  (setq #ret nil)
  (setq CG_SYSPATH (getvar "DWGPREFIX")) ;本システムのシステムパス
  (if (findfile (strcat CG_SYSPATH "Layout.ini"))
    (progn
      (setq #ret T)
      (princ "\n --- 自動ﾚｲｱｳﾄを行います ---")
    )
  );_if
  #ret
);WEB_Check_InputCFG

;;;<HOM>************************************************************************
;;; <関数名>    : ChgSystemCADMenu
;;; <処理概要>  : メニューを切り替える
;;; <戻り値>    : なし
;;; <備考>      : 現在の状態を保存して切り替える
;;;************************************************************************>MOH<
(defun ChgSystemCADMenu (
  &mode
  /
  )
    ;///////////////////////////////////////////////////////////////////
    (defun ##TOOLBAR1 ( / )
      (command "toolbar" "KPCAD.TB_ZOOM"           "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT2"   "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT"    "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR"  "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR2" "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR3" "h"); 01/05/10 YM ADD

      (command "toolbar" "KPCAD.TB_SKVIEWPOINT2"   "s"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT"    "s"); 01/05/10 YM ADD
;;;     (command "toolbar" "KPCAD.TB_ZOOM"           "s"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR"  "s"); 01/05/10 YM ADD
      (princ)
    );##TOOLBAR
    ;///////////////////////////////////////////////////////////////////

    (defun ##TOOLBAR2 ( / )
      (command "toolbar" "KPCAD.TB_ZOOM"           "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT2"   "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT"    "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR"  "h"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR2" "h"); 01/05/10 YM ADD

      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR2" "s"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT2"   "s"); 01/05/10 YM ADD
      (command "toolbar" "KPCAD.TB_SKVIEWPOINT"    "s"); 01/05/10 YM ADD
;;;     (command "toolbar" "KPCAD.TB_ZOOM"           "s"); 01/05/10 YM ADD
      (princ)
    );##TOOLBAR
    ;///////////////////////////////////////////////////////////////////

  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (menucmd "P1=-")
  (cond
    ((= &mode "PLAN")
      (##TOOLBAR1) ; 01/05/10 YM ADD
;;;2011/09/29YM@MOD      (menucmd "P1=+KPCAD.KPCAD0")
;;;2011/09/29YM@MOD      (menucmd "P2=+KPCAD.KPCAD1")
;;;2011/09/29YM@MOD      (menucmd "P3=+KPCAD.HELP")
      ;2011/09/29YM@MOD

			; 11/10/08 YM ADD
      (command "toolbar" "KPCAD.TB_WOCAD_TOOLBAR"  "s")

      (menucmd "P1=+KPCAD.KPCAD0")
      (menucmd "P2=+KPCAD.KPCAD1")
      (menucmd "P3=+KPCAD.KPCAD11");編集ﾒﾆｭｰ
      (menucmd "P4=+KPCAD.HELP")

      ;@DEL@(setvar "GRIPS" 0) ;01/09/09 HN DEL
      ;@DEL@(setvar "PICKFIRST" 0) ;01/08/24 HN ADD コマンドの発行後にオブジェクトを選択 ;01/09/09 HN DEL
    )
    ((= &mode "PLOT")
			; 11/10/08 YM ADD
      (command "toolbar" "KPCAD.TB_WOCAD_TOOLBAR"  "h")
      (##TOOLBAR1) ; 01/05/10 YM ADD
      (menucmd "P1=+KPCAD.KPCAD5")
      ;(menucmd "P1=+KPCAD.KPCAD0")
      (menucmd "P2=+KPCAD.KPCAD2")
      (menucmd "P3=+KPCAD.KPCAD3")
      (menucmd "P4=+KPCAD.HELP")
      (menucmd "P5=+KPCAD.HELP")
      ;@DEL@(setvar "GRIPS" 0) ;01/09/09 HN DEL
      ;@DEL@(setvar "PICKFIRST" 0) ;01/08/24 HN ADD コマンドの発行後にオブジェクトを選択 ;01/09/09 HN DEL
    )
    (T ; 図面参照時
      (command "toolbar" "KPCAD.TB_SKCAD_TOOLBAR3" "s"); 2011/12/13 YM ADD 2Dﾂｰﾙﾊﾞｰ

      (##TOOLBAR2) ; 01/05/10 YM ADD
      (menucmd "P1=+KPCAD.KPCAD4")
      ;(menucmd "P1=+KPCAD.KPCAD0")
      (menucmd "P2=+KPCAD.KPCAD3")
      (menucmd "P3=+KPCAD.FILE")
      (menucmd "P4=+KPCAD.DRAW")
      (menucmd "P5=+KPCAD.EDIT");2011/11/04 YM ADD 編集ﾒﾆｭｰ追加
      (menucmd "P6=+KPCAD.DIMENSION")
      (menucmd "P7=+KPCAD.MODIFY")
      (menucmd "P8=+KPCAD.HELP")  ;00/07/05 SN MOD
      ;(menucmd "P7=+KPCAD.TOOLS");00/07/05 SN MOD
      ;(menucmd "P8=+KPCAD.HELP") ;00/07/05 SN MOD
      (setvar "GRIPS" 1)
      ;@DEL@(setvar "PICKFIRST" 1) ;01/08/24 HN ADD コマンドの発行前にオブジェクトを選択 ;01/09/09 HN DEL
      (setvar "FILEDIA"   1)  ; 01/11/22 HN ADD 図面保存コマンドで常にダイアログ表示
    )
  )
)
;;;ChgSystemCADMenu


;;;<HOM>************************************************************************
;;; <関数名>  : WebSetFamilyCode
;;; <処理概要>: ﾌﾟﾗﾝ検索に必要なｸﾞﾛｰﾊﾞﾙをｾｯﾄし共通データベースへ接続
;;;              PlanInfo.cfg項目をここで取得する
;;; <戻り値>  : なし
;;; <作成>    : 02/07/30 YM
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun WebSetFamilyCode (
  /
  #HEIGHT #HINBAN$ #QRY$ #SSIDEPANELTYPE
#DUM #I #MSG #NUM ;2010/01/08 YM ADD
  )

  ;2008/07/30 YM MOD
  ;input.cfg のLOAD
  ;★★★　ｸﾞﾛｰﾊﾞﾙ変数のｾｯﾄ(0～99まで) [SK特性].PLAN??で定義されていないものはnil値　★★★
  (princ (strcat "\n☆☆☆　ｸﾞﾛｰﾊﾞﾙ変数のｾｯﾄ(0～99まで)　☆☆☆ : "))

  (setq #i 0)
  (setq CG_GLOBAL$ nil)
  ;2009/11/18 収納拡大用
;;; (repeat 100
  (repeat 600 ;項目ID=PLAN600まで対応
    (if (< #i 10)
      (setq #num (strcat "0" (itoa #i)))
      (setq #num (itoa #i))
    );_if
    (setq #dum (CFGet_Input_cfg "SET_INFORMATION" (strcat "PLAN" #num) (strcat CG_SYSPATH "input.cfg")))
    (setq CG_GLOBAL$ (append CG_GLOBAL$ (list #dum)))
    (princ (strcat "\n PLAN" #num "=" ))(princ #dum)
    (setq #i (1+ #i))
  );repeat

  (if (= "K" (nth 3 CG_GLOBAL$))
    (progn
      (setq CG_UnitCode "K");ｷｯﾁﾝ
      (setq CG_PlanType "SK")
      (setq CG_SeriesDB (nth 1 CG_GLOBAL$))
      ;【暫定措置】引手記号のセット
      (setq CG_DRSeriCode (nth 12 CG_GLOBAL$))
      (setq CG_DRColCode (nth 13 CG_GLOBAL$))
      (setq CG_Hikite (nth 14 CG_GLOBAL$))

      ;2011/05/27 YM ADD ★ｷｯﾁﾝ立体陣笠対応
      (setq CG_DRSeriCode_D (nth 12 CG_GLOBAL$));下台
      (setq CG_DRColCode_D  (nth 13 CG_GLOBAL$));下台
      (setq CG_Hikite_D     (nth 14 CG_GLOBAL$));下台

      (setq CG_DRSeriCode_U (nth 112 CG_GLOBAL$));上台
      (setq CG_DRColCode_U  (nth 113 CG_GLOBAL$));上台
      (setq CG_Hikite_U     (nth 114 CG_GLOBAL$));上台

    )
    (progn ;収納
      (setq CG_UnitCode "D");収納
      (setq CG_PlanType "SD")
      (setq CG_SeriesDB (nth 52 CG_GLOBAL$))
      ;【暫定措置】引手記号のセット
      (setq CG_DRSeriCode (nth 62 CG_GLOBAL$))
      (setq CG_DRColCode  (nth 63 CG_GLOBAL$))
      (setq CG_Hikite     (nth 64 CG_GLOBAL$))

      ;2011/04/22 YM ADD 立体陣笠対応
      (setq CG_DRSeriCode_D (nth 62 CG_GLOBAL$));下台
      (setq CG_DRColCode_D  (nth 63 CG_GLOBAL$));下台
      (setq CG_Hikite_D     (nth 64 CG_GLOBAL$));下台

      (setq CG_DRSeriCode_M (nth 82 CG_GLOBAL$));中台
      (setq CG_DRColCode_M  (nth 83 CG_GLOBAL$));中台
      (setq CG_Hikite_M     (nth 84 CG_GLOBAL$));中台

      (setq CG_DRSeriCode_U (nth 92 CG_GLOBAL$));上台
      (setq CG_DRColCode_U  (nth 93 CG_GLOBAL$));上台
      (setq CG_Hikite_U     (nth 94 CG_GLOBAL$));上台
    )
  );_if

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
;;;SK44      :ｶﾞﾗｽﾊﾟｰﾃｨｼｮﾝ ★★★
;;;SK45      :ｴﾝﾄﾞﾊﾟﾈﾙ
;;;SK46      :天井ﾌｨﾗｰ

;;;    SD51      :ユニット
;;;    SD52      :シリーズ
;;;    SD62      :扉ｼﾘｰｽﾞ  ★
;;;    SD63      :扉カラー ★
;;;    SD64      :取手　　 ★
;;;    SD53      :奥行き
;;;    SD54      :タイプ
;;;    SD55      :収納間口
;;;    SD56      :左右勝手
;;;    SD57      :ｶｳﾝﾀｰ色
;;;    SD58      :ｿﾌﾄｸﾛｰｽﾞ
;;;    SD59      :ｱﾙﾐ枠ｶﾞﾗｽ
;;;    SD71      :ｴﾝﾄﾞﾊﾟﾈﾙ
;;;    SD72      :天井ﾌｨﾗｰ



  ;// 共通データベースへの接続

  (if (= CG_CDBSESSION nil)
    (progn
      (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))

      ; 02/09/06 YM MOD-S WEB版ｴﾗｰ処理追加
      (setq #qry$
        (CFGetDBSQLRec CG_CDBSESSION "SERIES"
          (if (= CG_UnitCode "K")
            (list (list "SERIES名称" (nth  1 CG_GLOBAL$) 'STR));SKA
            ;else
            (list (list "SERIES名称" (nth 52 CG_GLOBAL$) 'STR));SDA
          );_if
        )
      );setq
      (if (= nil #qry$)
        (progn
          (setq #msg "SERIESテーブルが見つかりません")
          (c:msgbox #msg "警告" (logior MB_OK MB_ICONEXCLAMATION)) ; 警告画面
          (setq CG_ERRMSG (list #msg))
          (*error* CG_ERRMSG)
        )
        (progn
          (if (= (length #qry$) 1)
            (setq CG_SeriesCode (nth 4 (car #qry$))) ; ｼﾘｰｽﾞ記号

          ; else
            (progn
              (setq #msg "SERIESテーブルにﾚｺｰﾄﾞが複数ありました")
              ; 02/09/06 YM MOD-S
              (c:msgbox #msg "警告" (logior MB_OK MB_ICONEXCLAMATION)) ; 警告画面
              (setq CG_ERRMSG (list #msg))
              (*error* CG_ERRMSG)
              ; 02/09/06 YM MOD-E
            )
          );_if
        )
      );_if
      ; 02/09/06 YM MOD-E
    )
  );_if
  (princ)
);WebSetFamilyCode


;;;<HOM>************************************************************************
;;; <関数名>  : KPCADSetFamilyCode
;;; <処理概要>: KPCAD起動に必要なｸﾞﾛｰﾊﾞﾙをｾｯﾄし共通データベースへ接続
;;;              PlanInfo.cfg項目をここで取得する
;;; <戻り値>  : なし
;;; <作成>    : 2011/10/04 YM ADD
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun KPCADSetFamilyCode (
  /
  #DUM #I #MSG #NUM #QRY$
#inp_flg   ;-- 2011/10/06 A.Satoh Add
#planinfo$ #planinfo$$	;-- 2011/10/18 A.Satoh Add
  )
  (princ (strcat "\n☆☆☆　ｸﾞﾛｰﾊﾞﾙ変数のｾｯﾄ(0～99まで)　☆☆☆ : "))
;-- 2011/10/06 A.Satoh Add - S
  (setq #inp_flg nil)
;-- 2011/10/06 A.Satoh Add - E
  (setq #i 0)
  (setq CG_KP_GLOBAL$ nil)
  (repeat 600 ;項目ID=PLAN600まで対応
    (if (< #i 10)
      (setq #num (strcat "0" (itoa #i)))
      (setq #num (itoa #i))
    );_if
    (setq #dum (CFGet_Input_cfg "SET_INFORMATION" (strcat "PLAN" #num) (strcat CG_SYSPATH "input.cfg")))
    (setq CG_KP_GLOBAL$ (append CG_KP_GLOBAL$ (list #dum)))
;;;    (princ (strcat "\n PLAN" #num "=" ))(princ #dum)
    (setq #i (1+ #i))
  );repeat

  ;■ｼﾘｰｽﾞ
  (setq CG_SeriesDB   (nth  1 CG_KP_GLOBAL$))
  (if (= CG_SeriesDB nil)
    (setq CG_SeriesDB   (nth 52 CG_KP_GLOBAL$));確定するはず
  );_if

;;; (if (= CG_SeriesDB nil)
;;;   (setq CG_SeriesDB "PSKB")
;;; );_if

  ;■扉ｸﾞﾚｰﾄﾞ
  (setq CG_DRSeriCode (nth 12 CG_KP_GLOBAL$))
  (if (= CG_DRSeriCode nil)
    (setq CG_DRSeriCode (nth 62 CG_KP_GLOBAL$))
  );_if

  (if (= CG_DRSeriCode nil)
;-- 2011/10/06 A.Satoh Mod - S
;;;;;    ;【暫定】きめうち
;;;;;    (setq CG_DRSeriCode "RM");初期値
    (setq #inp_flg T)
;-- 2011/10/06 A.Satoh Mod - E
  );_if

  ;■扉ｶﾗｰ
  (setq CG_DRColCode  (nth 13 CG_KP_GLOBAL$))
  (if (= CG_DRColCode nil)
    (setq CG_DRColCode (nth 63 CG_KP_GLOBAL$))
  );_if

  (if (= CG_DRColCode nil)
;-- 2011/10/06 A.Satoh Mod - S
;;;;;    ;【暫定】きめうち
;;;;;    (setq CG_DRColCode  "H" );初期値
    (setq #inp_flg T)
;-- 2011/10/06 A.Satoh Mod - E
  );_if

  ;■引手記号
  (setq CG_Hikite     (nth 14 CG_KP_GLOBAL$))
  (if (= CG_Hikite nil)
    (setq CG_Hikite (nth 64 CG_KP_GLOBAL$))
  );_if

  (if (= CG_Hikite nil)
;-- 2011/10/06 A.Satoh Mod - S
;;;;;    ;【暫定】きめうち
;;;;;    (setq CG_Hikite     "H" );初期値
    (setq #inp_flg T)
;-- 2011/10/06 A.Satoh Mod - E
  );_if

  ;■ｶﾞｽ種
  (setq CG_GasType     (nth 24 CG_KP_GLOBAL$))
	;2014/08/01 YM MOD-S
  (if (or (= CG_GasType nil)(= CG_GasType "N")(= CG_GasType ""))
;;;  (if (= CG_GasType nil)
	;2014/08/01 YM MOD-E

;-- 2011/10/06 A.Satoh Mod - S
;;;;;    ;【暫定】きめうち
;;;;;    (setq CG_GasType "13A");初期値
;-- 2011/10/21 A.Satoh Mod - S
;;;;;    (setq #inp_flg T)
		(setq CG_GasType (CFgetini "INITIAL" "GasType" (strcat CG_SKPATH "ERRMSG.INI")))
;-- 2011/10/06 A.Satoh Mod - E
  );_if

  ;未使用
  (setq CG_ElecType        "");電気種
  (setq CG_WTHeight    "H850");ワークトップ高さ

  ;初期値
;-- 2011/10/18 A.Satoh Mod - S
;;;;;  (setq CG_RoomW        3600);間口
;;;;;  (setq CG_RoomD        3600);奥行
;;;;;  (setq CG_CeilHeight   2450);天井高さ
;;;;;  (setq CG_UpCabHeight  2350);取付高さ
	(if (findfile (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
		(progn
			(setq #planinfo$$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
			(foreach #planinfo$ #planinfo$$
				(cond
					((= (nth 0 #planinfo$) "Width")
						(setq CG_RoomW       (atoi (nth 1 #planinfo$)))	; 間口
					)
					((= (nth 0 #planinfo$) "Depth")
						(setq CG_RoomD       (atoi (nth 1 #planinfo$)))	; 奥行
					)
					((= (nth 0 #planinfo$) "CeilingHeight")
						(setq CG_CeilHeight  (atoi (nth 1 #planinfo$)))	; 天井高さ
					)
					((= (nth 0 #planinfo$) "SetHeight")
						(setq CG_UpCabHeight (atoi (nth 1 #planinfo$)))	; 取付高さ
					)
				)
			)
		)
		(progn
			(setq CG_RoomW        3600)	; 間口
			(setq CG_RoomD        3600)	; 奥行

			;2013/10/21 YM MOD-S 天井高さ,吊元高さ指定可能
;;;			(setq CG_CeilHeight   2450)	; 天井高さ
;;;			(setq CG_UpCabHeight  2350)	; 取付高さ

			(setq CG_CeilHeight  (cadr (assoc "PLAN48" CG_INPUTINFO$))) ;天井高さ
			(setq CG_UpCabHeight (cadr (assoc "PLAN49" CG_INPUTINFO$))) ;取付高さ

			(if CG_CeilHeight
				(setq CG_CeilHeight (atoi (substr CG_CeilHeight 3 10))) ;天井高さ
			);_if

			(if CG_UpCabHeight
				(setq CG_UpCabHeight (atoi (substr CG_UpCabHeight 3 10))) ;取付高さ
			);_if

			(if (= CG_CeilHeight 0)(setq CG_CeilHeight nil)) ;天井高さ
			(if (= CG_UpCabHeight 0)(setq CG_UpCabHeight nil)) ;取付高さ

			(if (or (= nil CG_CeilHeight)(= nil CG_UpCabHeight))
				(progn ;値が入っていなかったら従来ﾛｼﾞｯｸ
					(setq CG_CeilHeight   2450)	; 天井高さ
					(setq CG_UpCabHeight  2350)	; 取付高さ
				)
			);_if
			;2013/10/21 YM MOD-E 天井高さ,吊元高さ指定可能

		)
	)
;-- 2011/10/18 A.Satoh Mod - E

  ;// 共通データベースへの接続
  (princ "\n☆☆☆　共通ﾃﾞｰﾀﾍﾞｰｽへの接続　☆☆☆ :")
  (princ "\n☆☆☆　CG_CDBSESSION　☆☆☆ :")(princ CG_CDBSESSION)
  (princ (strcat "\n☆☆☆　CG_CDBNAME = " CG_CDBNAME))
  (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  ;DB接続できなくなったら再接続
  (if (= nil CG_CDBSESSION)
    (progn
      (princ (strcat "\n☆☆☆　もう一度セッション取得チャレンジ　☆☆☆"))
      (princ (strcat "\n☆☆☆　asilisp.arxをアンロードして再ロードしてDBにCONNECT　☆☆☆"))

      (cond
        ((= "19" CG_ACADVER)
          (arxunload "asilispX19.arx")
          (arxload "asilispX19.arx")
        )
        ((= "18" CG_ACADVER)
          (arxunload "asilispX18.arx")
          (arxload "asilispX18.arx")
        )

        ((= "17" CG_ACADVER)
          (arxunload "asilispX17.arx")
          (arxload "asilispX17.arx")
        )
        ((= "16" CG_ACADVER)
          (arxunload "asilisp16.arx")
          (arxload "asilisp16.arx")
        )
      );_cond

      (setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
      (princ (strcat "\n◆◆◆　チャレンジ結果→→→　CG_CDBSESSION = "))(princ CG_CDBSESSION)
    )
  );_if

  (princ "\n☆☆☆　CG_CDBSESSION　☆☆☆ :")(princ CG_CDBSESSION)

;;; (if (= CG_SeriesDB nil)
;;;   (setq CG_SeriesDB "PSKB")
;;; );_if

  ;SKB or SDC or LDA を変換する
  (if CG_SeriesDB
    (progn
      (setq #qry_mdb$$
        (CFGetDBSQLRec CG_CDBSESSION "MDB変換"
          (list
            (list "変換前" CG_SeriesDB   'STR)
          )
        )
      )
      (if #qry_mdb$$
        (setq CG_SeriesDB (nth 2 (car #qry_mdb$$)))
      );_if
    )
    (progn
      (setq #msg "SERIES別mdb名が見つかりません。PSKCとします。")
      (c:msgbox #msg "警告" (logior MB_OK MB_ICONEXCLAMATION)) ; 警告画面
      (setq CG_SeriesDB "PSKC")
    )
  );_if




  ; 02/09/06 YM MOD-S WEB版ｴﾗｰ処理追加
  (setq #qry$
    (CFGetDBSQLRec CG_CDBSESSION "SERIES"
      (list
        (list "SERIES名称" CG_SeriesDB   'STR)
      )
    )
  )

  (if (= nil #qry$)
    (progn
      (setq #msg "SERIESテーブルが見つかりません")
      (c:msgbox #msg "警告" (logior MB_OK MB_ICONEXCLAMATION)) ; 警告画面
      (setq CG_ERRMSG (list #msg))
      (*error* CG_ERRMSG)
    )
    (progn
      (if (= (length #qry$) 1)
        (progn
          (setq CG_SeriesCode (nth 4 (car #qry$))) ; ｼﾘｰｽﾞ記号
          (setq CG_DBNAME (nth 7 (car #qry$))) ; 検索成功! ｼﾘｰｽﾞDB接続可能

;-- 2011/10/06 A.Satoh Add - S
          (if (= #inp_flg T)
            (progn
              ; 初期値入力ダイアログ処理
              (setq #planInfo$ (InputInitInfoDlg))
              (if #planInfo$
                (progn
                  (setq CG_DRSeriCode  (nth 0 #planInfo$))     ; 扉グレード
                  (setq CG_DRColCode   (nth 1 #planInfo$))     ; 扉色
                  (setq CG_Hikite      (nth 2 #planInfo$))     ; 引手
                  (setq CG_RoomW       (nth 3 #planInfo$))     ; 間口
                  (setq CG_RoomD       (nth 4 #planInfo$))     ; 奥行
                  (setq CG_CeilHeight  (nth 5 #planInfo$))     ; 天井高さ
                  (setq CG_UpCabHeight (nth 6 #planInfo$))     ; 取付高さ
                  (setq CG_GasType     (nth 7 #planInfo$))     ; ガス種
                )
              )
            )
          )
(princ "\n★★★扉ｸﾞﾚｰﾄﾞ(CG_DRSeriCode)  = ") (princ CG_DRSeriCode)
(princ "\n★★★扉ｶﾗｰ(CG_DRColCode)      = ") (princ CG_DRColCode)
(princ "\n★★★引手記号(CG_Hikite)      = ") (princ CG_Hikite)
(princ "\n★★★部屋枠Ｘ(CG_RoomW)       = ") (princ CG_RoomW)
(princ "\n★★★部屋枠Ｙ(CG_RoomD)       = ") (princ CG_RoomD)
(princ "\n★★★天井高さ(CG_CeilHeight)  = ") (princ CG_CeilHeight)
(princ "\n★★★取付高さ(CG_UpCabHeight) = ") (princ CG_UpCabHeight)
(princ "\n★★★ガス種(CG_GasType)       = ") (princ CG_GasType)
;-- 2011/10/06 A.Satoh Add - E
        )
      ; else
        (progn
          (setq #msg "SERIESテーブルにﾚｺｰﾄﾞが複数ありました")
          (c:msgbox #msg "警告" (logior MB_OK MB_ICONEXCLAMATION)) ; 警告画面
          (setq CG_ERRMSG (list #msg))
          (*error* CG_ERRMSG)
          ; 02/09/06 YM MOD-E
        )
      );_if
    )
  );_if

  (princ)
);KPCADSetFamilyCode


;;;2008/07/30YM@DEL;;;<HOM>************************************************************************
;;;2008/07/30YM@DEL;;; <関数名>  : WebSetGlobal
;;;2008/07/30YM@DEL;;; <処理概要>: ﾌｧﾐﾘｰｺｰﾄﾞからﾌﾟﾗﾝ検索に必要なｸﾞﾛｰﾊﾞﾙをｾｯﾄする
;;;2008/07/30YM@DEL;;; <戻り値>  : なし
;;;2008/07/30YM@DEL;;; <作成>    : 02/08/05 YM
;;;2008/07/30YM@DEL;;; <備考>    : INPUT.CFG 読込み済みを前提(CG_INPUTINFO$)
;;;2008/07/30YM@DEL;;;************************************************************************>MOH<
;;;2008/07/30YM@DEL(defun WebSetGlobal ( / )
;;;2008/07/30YM@DEL  ;// ｾｯﾄﾌﾟﾗﾝ(ﾌｧﾐﾘｰ品番)NO取得する(srcpln.cfg)
;;;2008/07/30YM@DEL ; SETPLAN_NO=KCKSWLW-ZR25ASEFD1B-0A1A-AM0A-B-SSK
;;;2008/07/30YM@DEL ; SETPLAN_NO=KCKSBBA-ZR25ASEFD1B-08501A-A7000A-B-SSK
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ; 03/05/12 YM ADD-S
;;;2008/07/30YM@DEL  (setq CG_PlanType (cadr (assoc "PLANTYPE" CG_INPUTINFO$))) ; "SK","SD"
;;;2008/07/30YM@DEL  (setq CG_SETPLAN_NO (cadr (assoc "SETPLAN_NO" CG_INPUTINFO$))) ;ｾｯﾄﾌﾟﾗﾝNO
;;;2008/07/30YM@DEL (if CG_SETPLAN_NO
;;;2008/07/30YM@DEL   (progn
;;;2008/07/30YM@DEL     (cond
;;;2008/07/30YM@DEL       ((= CG_PlanType "SK") ; WEB版キッチンはここを通る ; 03/05/12 YM
;;;2008/07/30YM@DEL;;;          (##SetGlobal_SK) ; ★関数の中身を変更→CALL位置をｼﾘｰｽﾞ別DB接続後に変更
;;;2008/07/30YM@DEL         (##SetGlobal_SK_DB) ; 03/09/03 YM MOD
;;;2008/07/30YM@DEL       )
;;;2008/07/30YM@DEL       ((= CG_PlanType "SD") ; WEB版収納部はここを通る   ; 03/05/12 YM 
;;;2008/07/30YM@DEL;;;          (##SetGlobal_SD) ; ★関数の中身を変更→CALL位置をｼﾘｰｽﾞ別DB接続後に変更
;;;2008/07/30YM@DEL         (##SetGlobal_SD_DB) ; 03/09/03 YM MOD
;;;2008/07/30YM@DEL       )
;;;2008/07/30YM@DEL       (T
;;;2008/07/30YM@DEL         (setq CG_PlanType "SK")
;;;2008/07/30YM@DEL         (##SetGlobal_SK_DB)
;;;2008/07/30YM@DEL       )
;;;2008/07/30YM@DEL     );_cond
;;;2008/07/30YM@DEL   )
;;;2008/07/30YM@DEL ; else
;;;2008/07/30YM@DEL   (progn
;;;2008/07/30YM@DEL     (*error*)
;;;2008/07/30YM@DEL   )
;;;2008/07/30YM@DEL );_if
;;;2008/07/30YM@DEL ; 03/05/12 YM ADD-E
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (princ)
;;;2008/07/30YM@DEL);WebSetGlobal
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL   ;/////////////////////////////
;;;2008/07/30YM@DEL   ; 特性値の桁数を取得する
;;;2008/07/30YM@DEL   ; nil時も考慮する
;;;2008/07/30YM@DEL   ;/////////////////////////////
;;;2008/07/30YM@DEL   (defun ##GET_KETA ( &str &num / #LIS #RET)
;;;2008/07/30YM@DEL     (setq #lis (assoc &str #dum$$));nilあり
;;;2008/07/30YM@DEL     (if #lis
;;;2008/07/30YM@DEL       (setq #ret (fix (+ (nth &num #lis) 0.0001)))
;;;2008/07/30YM@DEL       ;else
;;;2008/07/30YM@DEL       (setq #ret nil)
;;;2008/07/30YM@DEL     );_if
;;;2008/07/30YM@DEL     #ret
;;;2008/07/30YM@DEL   )
;;;2008/07/30YM@DEL   ;/////////////////////////////
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;;;<HOM>************************************************************************
;;;2008/07/30YM@DEL;;; <関数名>  : ##SetGlobal_SK
;;;2008/07/30YM@DEL;;; <処理概要>: ﾌｧﾐﾘｰｺｰﾄﾞからﾌﾟﾗﾝ検索に必要なｸﾞﾛｰﾊﾞﾙをｾｯﾄする(SK)
;;;2008/07/30YM@DEL;;; <戻り値>  : なし
;;;2008/07/30YM@DEL;;; <作成>    : 03/05/12 YM ｻﾌﾞﾙｰﾁﾝ化
;;;2008/07/30YM@DEL;;; <備考>    : INPUT.CFG 読込み済みを前提(CG_INPUTINFO$)
;;;2008/07/30YM@DEL;;;             ★桁数を[SK特性]から読取る 03/09/03 YM
;;;2008/07/30YM@DEL;;;             04/03/25 YM MOD 古いｼﾘｰｽﾞ(DIPLOAで追加したPLAN44がない)も動くように
;;;2008/07/30YM@DEL;;;************************************************************************>MOH<
;;;2008/07/30YM@DEL(defun ##SetGlobal_SK_DB ( / )
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;04/03/25 YM DEL 外部関数にする
;;;2008/07/30YM@DEL;;;    ;/////////////////////////////
;;;2008/07/30YM@DEL;;;    (defun ##GET_KETA ( &str &num / )
;;;2008/07/30YM@DEL;;;      (fix (+ (nth &num (assoc &str #dum$$)) 0.0001))
;;;2008/07/30YM@DEL;;;    )
;;;2008/07/30YM@DEL;;;    ;/////////////////////////////
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ;04/03/25 YM ADD
;;;2008/07/30YM@DEL (setq #Qry$$ nil)
;;;2008/07/30YM@DEL  (setq #Qry$$
;;;2008/07/30YM@DEL    (DBSqlAutoQuery CG_DBSESSION
;;;2008/07/30YM@DEL;;;      (strcat "select * from SK特性");04/03/25 YM MOD 識別ID="?K??"(ｷｯﾁﾝ)だけ取得
;;;2008/07/30YM@DEL     (strcat "select * from SK特性 where 識別ID like " "'" CG_SeriesCode "K__'" "order by \"ID\"");04/03/25 YM MOD
;;;2008/07/30YM@DEL   )
;;;2008/07/30YM@DEL  )
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ;04/03/25 YM ADD-S "DIVMARK" と"文字位置"=0は除外する
;;;2008/07/30YM@DEL (setq #dum$$ nil)
;;;2008/07/30YM@DEL (foreach #Qry$ #Qry$$
;;;2008/07/30YM@DEL   (if (or (equal (nth 3 #Qry$) 0.0 0.001)
;;;2008/07/30YM@DEL           (= (nth 4 #Qry$) "DIVMARK"))
;;;2008/07/30YM@DEL     (progn
;;;2008/07/30YM@DEL       nil ; 除外する
;;;2008/07/30YM@DEL     )
;;;2008/07/30YM@DEL     (progn
;;;2008/07/30YM@DEL       (setq #dum$$ (append #dum$$ (list #Qry$)))
;;;2008/07/30YM@DEL     )
;;;2008/07/30YM@DEL   );_if
;;;2008/07/30YM@DEL )
;;;2008/07/30YM@DEL (setq #Qry$$ #dum$$)
;;;2008/07/30YM@DEL ;04/03/25 YM ADD-E "DIVMARK" と"文字位置"=0は除外する
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ;特性ID(PLAN44など)をﾘｽﾄの先頭に持ってくる(ASSOCを使いたいため)
;;;2008/07/30YM@DEL (setq #dum$ nil #dum$$ nil)
;;;2008/07/30YM@DEL (foreach #Qry$ #Qry$$
;;;2008/07/30YM@DEL   (setq #dum$ (cons (nth 4 #Qry$) #Qry$))
;;;2008/07/30YM@DEL   (setq #dum$$ (append #dum$$ (list #dum$)))
;;;2008/07/30YM@DEL )
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN03" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN03" 8))
;;;2008/07/30YM@DEL (setq CG_UnitCode        (substr CG_SETPLAN_NO  #num1 #num2)) ;ユニット記号
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;;;  (setq CG_SeriesDB        (substr CG_SETPLAN_NO  2 3)) ;SERIESDB名
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN12" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN12" 8))
;;;2008/07/30YM@DEL (setq CG_DRSeriCode      (substr CG_SETPLAN_NO #num1 #num2)) ;扉SERIES記号
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN13" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN13" 8))
;;;2008/07/30YM@DEL (setq CG_DRColCode       (substr CG_SETPLAN_NO #num1 #num2)) ;扉COLOR記号
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN05" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN05" 8))
;;;2008/07/30YM@DEL  (setq CG_W2Code          (substr CG_SETPLAN_NO #num1 #num2)) ;間口2
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN11" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN11" 8))
;;;2008/07/30YM@DEL  (setq CG_LRCode          (substr CG_SETPLAN_NO #num1 #num2)) ;LR区分
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN04" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN04" 8))
;;;2008/07/30YM@DEL (setq CG_W1Code          (substr CG_SETPLAN_NO #num1 #num2)) ;間口1
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN16" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN16" 8))
;;;2008/07/30YM@DEL  (setq CG_WTZaiCode       (substr CG_SETPLAN_NO #num1 #num2)) ;材質記号
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN07" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN07" 8))
;;;2008/07/30YM@DEL  (setq CG_Type2Code       (substr CG_SETPLAN_NO #num1 #num2)) ;タイプ2 ﾌﾗｯﾄ,段差
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN06" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN06" 8))
;;;2008/07/30YM@DEL  (setq CG_Type1Code       (substr CG_SETPLAN_NO #num1 #num2)) ;タイプ1 "P1","S1"
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN17" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN17" 8))
;;;2008/07/30YM@DEL  (setq CG_SinkCode        (substr CG_SETPLAN_NO #num1 #num2)) ;ｼﾝｸ記号
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN42" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN42" 8))
;;;2008/07/30YM@DEL  (setq CG_NPCode          (substr CG_SETPLAN_NO #num1 #num2)) ;食洗機種類
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ;04/03/12 YM ADD-S WEB版DIPLOAｶｳﾝﾀｰｶﾗｰ
;;;2008/07/30YM@DEL;;;(princ "\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN44" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN44" 8))
;;;2008/07/30YM@DEL ;04/03/25 YM MOD-S
;;;2008/07/30YM@DEL ;旧ｼﾘｰｽﾞでは"PLAN44"がない→CG_Counter = "0"
;;;2008/07/30YM@DEL (if (or (= nil #num1)(= nil #num2))
;;;2008/07/30YM@DEL   (setq CG_Counter                                "0") ;ｶｳﾝﾀｰ色(ﾌﾟﾗ管理.ｿﾌﾄﾀﾞｳﾝ)
;;;2008/07/30YM@DEL   (setq CG_Counter (substr CG_SETPLAN_NO #num1 #num2)) ;ｶｳﾝﾀｰ色(ﾌﾟﾗ管理.ｿﾌﾄﾀﾞｳﾝ)
;;;2008/07/30YM@DEL );_if
;;;2008/07/30YM@DEL ;04/03/25 YM MOD-E
;;;2008/07/30YM@DEL;;;(princ "\nBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB")
;;;2008/07/30YM@DEL ;04/03/12 YM ADD-E WEB版DIPLOAｶｳﾝﾀｰｶﾗｰ
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN31" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN31" 8))
;;;2008/07/30YM@DEL  (setq CG_BaseCabHeight   (substr CG_SETPLAN_NO #num1 #num2)) ;ﾌﾛｱ  取付タイプ1
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN18" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN18" 8))
;;;2008/07/30YM@DEL  (setq CG_WtrHoleTypeCode (substr CG_SETPLAN_NO #num1 #num2)) ;水栓穴 0:なし  1:あり
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN19" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN19" 8))
;;;2008/07/30YM@DEL  (setq CG_WtrHoleCode     (substr CG_SETPLAN_NO #num1 #num2)) ;水栓   0:水栓なし 1:標準 2:寒冷地
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN20" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN20" 8))
;;;2008/07/30YM@DEL  (setq CG_CRCode          (substr CG_SETPLAN_NO #num1 #num2)) ;ｺﾝﾛ
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN32" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN32" 8))
;;;2008/07/30YM@DEL  (setq CG_UpperCabHeight  (substr CG_SETPLAN_NO #num1 #num2)) ;ｳｫｰﾙ 取付タイプ2
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN14" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN14" 8))
;;;2008/07/30YM@DEL  (setq CG_SoftDownCode    (substr CG_SETPLAN_NO #num1 #num2)) ;ｿﾌﾄﾀﾞｳﾝ
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN23" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN23" 8))
;;;2008/07/30YM@DEL  (setq CG_RangeCode       (substr CG_SETPLAN_NO #num1 #num2)) ;ﾚﾝｼﾞ
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN21" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN21" 8))
;;;2008/07/30YM@DEL  (setq CG_CRUnderCode     (substr CG_SETPLAN_NO #num1 #num2)) ;ｺﾝﾛ下
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN08" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN08" 8))
;;;2008/07/30YM@DEL  (setq CG_SinkUnderCode   (substr CG_SETPLAN_NO #num1 #num2)) ;ｼﾝｸ下仕様 タイプ3
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL ;★NASはプラン検索で耐震ロックCG_DoorGripに代入(Planinfo.cfgからとれない)
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN15" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN15" 8))
;;;2008/07/30YM@DEL  (setq CG_DoorGrip        (substr CG_SETPLAN_NO #num1 #num2)) ;耐震ﾛｯｸ 耐震ロック
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN33" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN33" 8))
;;;2008/07/30YM@DEL  (setq CG_KikiColor       (substr CG_SETPLAN_NO #num1 #num2)) ;機器色
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;2008/07/26 YM DEL
;;;2008/07/30YM@DEL;;;  (setq CG_UnitBase  "1") ;ﾌﾛｱ配置ﾌﾗｸﾞ
;;;2008/07/30YM@DEL;;;  (setq CG_UnitUpper "1") ;ｳｫｰﾙ配置ﾌﾗｸﾞ
;;;2008/07/30YM@DEL;;;  (setq CG_UnitTop   "1") ;ﾜｰｸﾄｯﾌﾟ配置ﾌﾗｸﾞ
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL  (setq CG_FilerCode     (cadr (assoc "SKOP04" CG_INPUTINFO$)))  ;天井ﾌｨﾗｰ
;;;2008/07/30YM@DEL  (setq CG_SidePanelCode (cadr (assoc "SKOP05" CG_INPUTINFO$)))  ;ｻｲﾄﾞﾊﾟﾈﾙ
;;;2008/07/30YM@DEL  (setq CG_Kcode  "K")     ; 工種記号
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (princ)
;;;2008/07/30YM@DEL);##SetGlobal_SK
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;;;<HOM>************************************************************************
;;;2008/07/30YM@DEL;;; <関数名>  : ##SetGlobal_SD
;;;2008/07/30YM@DEL;;; <処理概要>: ﾌｧﾐﾘｰｺｰﾄﾞからﾌﾟﾗﾝ検索に必要なｸﾞﾛｰﾊﾞﾙをｾｯﾄする(SD)
;;;2008/07/30YM@DEL;;; <戻り値>  : なし
;;;2008/07/30YM@DEL;;; <作成>    : 03/05/12 YM ｻﾌﾞﾙｰﾁﾝ化
;;;2008/07/30YM@DEL;;; <備考>    : INPUT.CFG 読込み済みを前提(CG_INPUTINFO$)
;;;2008/07/30YM@DEL;;;             ★桁数を[SK特性]から読取る 03/09/03 YM
;;;2008/07/30YM@DEL;;;************************************************************************>MOH<
;;;2008/07/30YM@DEL(defun ##SetGlobal_SD_DB ( / )
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL;04/03/25 YM DEL 外部関数にする
;;;2008/07/30YM@DEL;;;    ;/////////////////////////////
;;;2008/07/30YM@DEL;;;    (defun ##GET_KETA ( &str &num / )
;;;2008/07/30YM@DEL;;;      (fix (+ (nth &num (assoc &str #dum$$)) 0.0001))
;;;2008/07/30YM@DEL;;;    )
;;;2008/07/30YM@DEL;;;    ;/////////////////////////////
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #Qry$$ nil)
;;;2008/07/30YM@DEL  (setq #Qry$$
;;;2008/07/30YM@DEL    (DBSqlAutoQuery CG_DBSESSION
;;;2008/07/30YM@DEL     (strcat "select * from SK特性")
;;;2008/07/30YM@DEL   )
;;;2008/07/30YM@DEL  )
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL(princ #Qry$$)
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #dum$ nil #dum$$ nil)
;;;2008/07/30YM@DEL (foreach #Qry$ #Qry$$
;;;2008/07/30YM@DEL   (setq #dum$ (cons (nth 4 #Qry$) #Qry$))
;;;2008/07/30YM@DEL   (setq #dum$$ (append #dum$$ (list #dum$)))
;;;2008/07/30YM@DEL )
;;;2008/07/30YM@DEL;;;"DCKC???A120P3L0"
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN51" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN51" 8))
;;;2008/07/30YM@DEL (setq CG_UnitCode        (substr CG_SETPLAN_NO #num1 #num2)) ;ユニット記号
;;;2008/07/30YM@DEL;;;  (setq CG_SeriesDB   (substr CG_SETPLAN_NO  2 3)) ;SERIESDB名
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN12" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN12" 8))
;;;2008/07/30YM@DEL (setq CG_DRSeriCode (substr CG_SETPLAN_NO #num1 #num2)) ;扉SERIES記号
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN13" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN13" 8))
;;;2008/07/30YM@DEL (setq CG_DRColCode  (substr CG_SETPLAN_NO #num1 #num2)) ;扉COLOR記号
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq #num1 (##GET_KETA "PLAN56" 4))
;;;2008/07/30YM@DEL (setq #num2 (##GET_KETA "PLAN56" 8))
;;;2008/07/30YM@DEL (setq CG_LRCode     (substr CG_SETPLAN_NO #num1 #num2)) ;LR区分
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL  (setq CG_DoorGrip   "S") ;耐震ﾛｯｸ 耐震ロック
;;;2008/07/30YM@DEL  (setq CG_KikiColor  "K") ;機器色
;;;2008/07/30YM@DEL;;;  (setq CG_UnitBase  "1") ;ﾌﾛｱ配置ﾌﾗｸﾞ
;;;2008/07/30YM@DEL;;;  (setq CG_UnitUpper "1") ;ｳｫｰﾙ配置ﾌﾗｸﾞ
;;;2008/07/30YM@DEL;;;  (setq CG_UnitTop   "1") ;ﾜｰｸﾄｯﾌﾟ配置ﾌﾗｸﾞ
;;;2008/07/30YM@DEL;;;  (setq CG_FilerCode     (cadr (assoc "SDOP04" CG_INPUTINFO$)))  ;天井ﾌｨﾗｰ
;;;2008/07/30YM@DEL;;;  (setq CG_SidePanelCode (cadr (assoc "SDOP05" CG_INPUTINFO$)))  ;ｻｲﾄﾞﾊﾟﾈﾙ
;;;2008/07/30YM@DEL  (setq CG_Kcode  "K")     ; 工種記号
;;;2008/07/30YM@DEL ;扉記号を抜く
;;;2008/07/30YM@DEL ;04/03/15 YM ADD 扉ｼﾘ扉ｶﾗ記号の桁数を取得
;;;2008/07/30YM@DEL (setq #strlen_door (strlen (strcat CG_DRSeriCode CG_DRColCode)))
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL (setq CG_FamilyCode (strcat (substr CG_SETPLAN_NO 1 4)(substr CG_SETPLAN_NO (+ 5 #strlen_door) 50))) ; DWG名
;;;2008/07/30YM@DEL (princ)
;;;2008/07/30YM@DEL);##SetGlobal_SD
;;;2008/07/30YM@DEL
;;;2008/07/30YM@DEL


;<HOM>*************************************************************************
; <関数名>    : CFGet_Input_cfg
; <処理概要>  : ini ファイルの内容を読み込む
; <戻り値>    :
;         STR : 読み込んだ項目文列
;             ; 読み込めなかった場合 nil
; <備考>      : CFgetiniと同じだがnilのとき警告なしでそのまま値を返す
;*************************************************************************>MOH<
(defun CFGet_Input_cfg (
   &sSection  ; [セクション]
   &sEntry  ; エントリー=
   &sFilename ; \\ファイル名 (フルパスで指定)
   /
   #pRet  ; ファイル識別子
   #sLine ; 現在読み込み行
   #sSection  ; 現在セクション
   #sEntry  ; 現在エントリ
   #sEntStr ;
   #sTmp  ;
   #iColumn ;
   #sRet  ;
#END_FLG
   )
;///////////////////////////////////////////////////////////////////////
    ;; コメントを省いた文字列にする
  ;; 省いた結果意味のない行になる場合は nil を返す
    (defun Comment_Omit (
      &sLine
      /
       #iIDX  ;
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
    )
    (progn
    ; ファイルオープンエラー  
      (print (strcat "ファイルがない:" &sFilename))
      nil
    )
  );_if

  #sRet
);CFGet_Input_cfg


;;;<HOM>*************************************************************************
;;; <関数名>    : PKC_PG_BUNKI
;;; <処理概要>  : シリーズ及びバージョンによるPG分岐制御用コードの取得
;;; <戻り値>    :
;;; <作成>      :
;;; <備考>      : なし
;;;*************************************************************************>MOH<
(defun PKC_PG_BUNKI (
  /
  )
  (setq BU_CODE_0001 (PKC_PG_BUNKI_sub "BU_CODE_0001"))
  (setq BU_CODE_0002 (PKC_PG_BUNKI_sub "BU_CODE_0002"))
  (setq BU_CODE_0003 (PKC_PG_BUNKI_sub "BU_CODE_0003"))
  (setq BU_CODE_0004 (PKC_PG_BUNKI_sub "BU_CODE_0004"))
  (setq BU_CODE_0005 (PKC_PG_BUNKI_sub "BU_CODE_0005"))
  (setq BU_CODE_0006 (PKC_PG_BUNKI_sub "BU_CODE_0006"))
  (setq BU_CODE_0007 (PKC_PG_BUNKI_sub "BU_CODE_0007"))
  (setq BU_CODE_0008 (PKC_PG_BUNKI_sub "BU_CODE_0008"))
  (setq BU_CODE_0009 (PKC_PG_BUNKI_sub "BU_CODE_0009"))
  (setq BU_CODE_0010 (PKC_PG_BUNKI_sub "BU_CODE_0010"))
  (setq BU_CODE_0011 (PKC_PG_BUNKI_sub "BU_CODE_0011"))
  (setq BU_CODE_0012 (PKC_PG_BUNKI_sub "BU_CODE_0012"))
  (setq BU_CODE_0013 (PKC_PG_BUNKI_sub "BU_CODE_0013"))
  (setq BU_CODE_0014 (PKC_PG_BUNKI_sub "BU_CODE_0014"))
  (setq BU_CODE_0015 (PKC_PG_BUNKI_sub "BU_CODE_0015"))
  (setq BU_CODE_0016 (PKC_PG_BUNKI_sub "BU_CODE_0016"))
  (setq BU_CODE_0017 (PKC_PG_BUNKI_sub "BU_CODE_0017"))
  (setq BU_CODE_0018 (PKC_PG_BUNKI_sub "BU_CODE_0018"))
  (setq BU_CODE_0019 (PKC_PG_BUNKI_sub "BU_CODE_0019"))
  (setq BU_CODE_0020 (PKC_PG_BUNKI_sub "BU_CODE_0020"))
  (princ)
)

(defun PKC_PG_BUNKI_sub (
  &bunki_code
  /
  #Record
  )
  (setq #Record
    (car
      (CFGetDBSQLRec CG_CDBSESSION "カスタムPG分岐"
        (list
          (list "分岐CODE" &bunki_code 'STR)
          (list "SIRIES"   CG_SeriesDB 'STR)
        )
      )
    )
  )
  (if (= #Record nil)
    (progn
      (setq #Record
        (car
          (CFGetDBSQLRec CG_CDBSESSION "カスタムPG分岐"
            (list
              (list "分岐CODE" &bunki_code 'STR)
              (list "SIRIES"   "__OTHER" 'STR)
            )
          )
        )
      )
    )
  )
  (if #Record (nth 3 #Record) "")
)

(princ)
