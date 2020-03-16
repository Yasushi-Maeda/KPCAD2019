;;;<HOM>************************************************************************
;;; <ファイル名>: INIT.LSP
;;; <システム名>: ウッドワン様向け)
;;; <最終更新日>: 
;;; <備考>      : 
;;;************************************************************************>MOH<
;@@@(princ "\nINIT.fas をﾛｰﾄﾞ中...\n")

;;;<HOM>************************************************************************
;;; <関数名>  : InitKPCAD
;;; <処理概要>: KPCADの初期設定
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun InitKPCAD (
  /
  )
	(princ (strcat "\n★★★　関数(InitKPCAD)内 ★★★"))
  ;//フォルダ名のグローバル変数を設定
  (setq CG_SKPATH     CG_SYSPATH) ;キッチンシステム

	(if (= CG_PROGRAM "ACAD")
	  (setq CG_LISPPATH   CG_SYSPATH) ;プログラム
		;else
	  (setq CG_LISPPATH   CG_KPCAD_SYSTEM_PATH) ;プログラム
	);_if

	(princ "\n★★★CG_LISPPATH＝")(princ CG_LISPPATH)
	(princ "\n")

  (setq CG_DCLPATH    (strcat CG_SYSPATH    "SUPPORT\\"          ))

	(princ "\n★★★CG_DCLPATH＝")(princ CG_DCLPATH)
	(princ "\n")

  (setq CG_CFGPATH    (strcat CG_SYSPATH    "CFG\\"              ))
  (setq CG_TMPAPATH   (strcat CG_SYSPATH    "TEMPLATE\\DEFAULT\\"))
  (setq CG_TMPHPATH   (strcat CG_SYSPATH    "TEMPLATE\\USER\\"   ))
  (setq CG_BLOCKPATH  (strcat CG_SYSPATH    "BLOCK\\"            ))
  (setq CG_SLDPATH    (strcat CG_SYSPATH    "SLD\\"              ))
  (setq CG_LOGFILE    (strcat CG_LOGPATH    "SKDebug.log"        ))
  (setq CG_DROPENPATH (strcat CG_SKDATAPATH "DROPEN\\"           ))

  ; 02/09/03 YM ADD-S
  (if (= CG_AUTOMODE 2) ; WEB版
    (progn
      ;// ログファイルを物件番号毎に変更する
      (setq #date (menucmd "M=$(edtime,$(getvar,date),YYYY年MONTHD日)"))
      ;例 "2008年8月9日"
      (setq CG_LOGFILE (strcat CG_LOGPATH #date ".LOG"));2008/08/09 YM MOD 日付の名前でﾛｸﾞﾌｧｲﾙ
      (setq CG_ERRFILE (strcat CG_ERRPATH #date ".LOG"));2008/08/09 YM MOD 日付の名前でﾛｸﾞﾌｧｲﾙ
;;;     (if (findfile CG_LOGFILE)(vl-file-delete CG_LOGFILE))
;;;     (if (findfile CG_ERRFILE)(vl-file-delete CG_ERRFILE))
    )
  );_if

  ;-------- Dummy XRECORD から取得する ------------
  ;  (setq CG_KITTYPE "I-LEFT")
  ;  (setq CG_KITTYPE "W-LEFT")

  (regapp "G_ARW")              ;矢印の拡張データアプリケーション名
  (setvar "PLINEWID" 10)        ;矢印の線太さ

  ;// プログラムのロード
	(princ (strcat "\n☆☆☆　CmnLoadProgramのcall　☆☆☆"))
  (CmnLoadProgram)
	
	(princ (strcat "\n☆☆☆　LoadProgramKPCADのcall　☆☆☆"))
  (LoadProgramKPCAD)

	(princ (strcat "\n☆☆☆　関数(InitKPCAD)　ＥＮＤ　☆☆☆"))
  (princ)
);;;InitKPCAD

;;;<HOM>************************************************************************
;;; <関数名>  : CmnLoadProgram
;;; <処理概要>: 共通プログラムのロード
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun CmnLoadProgram (
  /
  )
	(princ (strcat "\n☆☆☆　関数(CmnLoadProgram)内 ---　☆☆☆"))
  ;// ARXロード
  ;06/06/14 AO MOD OEM版、製品版(バージョン毎にロードファイルを変更)
  (if (= "ACAD" CG_PROGRAM)
    (progn ;レギュラー版
      (princ (strcat "\n☆☆☆　必要なARXのロードを行う"))
	    (cond
	      ;2015/03/17 YM ADD 2014用
	      ((= "19" CG_ACADVER)
	          (princ (strcat "\n☆☆☆　asilispX19.arx ロード　☆☆☆"))
	          (if (= nil (member "asilispX19.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "asilispX19.arx")) ;asilisp
	          );if

	          (princ (strcat "\n☆☆☆　utils19.arx ロード　☆☆☆"))
	          (if (= nil (member "utils19.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "utils19.arx"  )) ;UTILS
	          );if

	          (princ (strcat "\n☆☆☆　SKDisableClose19.arx ロード　☆☆☆"))
	          (if (= nil (member "SKDisableClose19.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "SKDisableClose19.arx"  )) ;SKDisableClose
	          );if

	          (if (= nil (member "kpdeploy19.arx" (arx)))
	            (if (findfile (strcat CG_LISPPATH "kpdeploy19.arx"))
	              (arxload (strcat CG_LISPPATH "kpdeploy19.arx"  ))
	            );_if
	          )

	          (if (= nil (member "BukkenInfoRewrite19.arx" (arx)))
	            (if (findfile (strcat CG_LISPPATH "BukkenInfoRewrite19.arx"))
	              (arxload (strcat CG_LISPPATH "BukkenInfoRewrite19.arx"  ))
	            );_if
	          )

	          (princ (strcat "\n☆☆☆　doslibはLOADしない　☆☆☆"))
	      )

	      ;2020/01/30 YM ADD 2019用
	      ((= "23" CG_ACADVER)
	          (princ (strcat "\n☆☆☆　asilispX.arx ロード(2019)　☆☆☆"))
	          (if (= nil (member "asilispX.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "asilispX.arx")) ;asilisp
	          );if

	          (princ (strcat "\n☆☆☆　utils.arx ロード(2019)　☆☆☆"))
	          (if (= nil (member "utils.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "utils.arx"  )) ;UTILS
	          );if

	          (princ (strcat "\n☆☆☆　SKDisableClose.arx ロード(2019)　☆☆☆"))
	          (if (= nil (member "SKDisableClose.arx" (arx)))
	            (arxload (strcat CG_LISPPATH "SKDisableClose.arx"  )) ;SKDisableClose
	          );if

	          (princ (strcat "\n☆☆☆　kpdeploy.arx ロード(2019)　☆☆☆"))
	          (if (= nil (member "kpdeploy.arx" (arx)))
	            (if (findfile (strcat CG_LISPPATH "kpdeploy.arx"))
	              (arxload (strcat CG_LISPPATH "kpdeploy.arx"  ))
	            );_if
	          )

	          (princ (strcat "\n☆☆☆　BukkenInfoRewrite.arx ロード(2019)　☆☆☆"))
	          (if (= nil (member "BukkenInfoRewrite.arx" (arx)))
	            (if (findfile (strcat CG_LISPPATH "BukkenInfoRewrite.arx"))
	              (arxload (strcat CG_LISPPATH "BukkenInfoRewrite.arx"  ))
	            );_if
	          )

	          (princ (strcat "\n☆☆☆　doslibはLOADしない　☆☆☆"))
	      )

				(T
				  nil
			 	)
			);cond
    )
    ;else
    (progn ; AutoCAD 2014 OEM版
      ; ACAD OEM版
      (princ (strcat "\n☆☆☆　OEM版で通る!!!　☆☆☆"))

			(princ "\n★★★CG_LISPPATH＝")(princ CG_LISPPATH)
			(princ "\n")

      (princ (strcat "\n☆☆☆　asilispX19oem.arx ロード　☆☆☆"))
      (if (= nil (member "asilispX19oem.arx" (arx)))
        (arxload (strcat CG_LISPPATH "asilispX19oem.arx")) ;asilisp
      );if
      (princ (strcat "\n☆☆☆　asilispX19oem.arx ロード【終了】　☆☆☆"))


      (princ (strcat "\n☆☆☆　utils19oem.arx ロード　☆☆☆"))
      (if (= nil (member "utils19oem.arx" (arx)))
        (arxload (strcat CG_LISPPATH "utils19oem.arx"  )) ;UTILS
      );if
      (princ (strcat "\n☆☆☆　utils19oem.arx ロード【終了】　☆☆☆"))


      (princ (strcat "\n☆☆☆　SKDisableClose19oem.arx ロード　☆☆☆"))
      (if (= nil (member "SKDisableClose19oem.arx" (arx)))
        (arxload (strcat CG_LISPPATH "SKDisableClose19oem.arx"  )) ;SKDisableClose
      );if
      (princ (strcat "\n☆☆☆　SKDisableClose19oem.arx ロード【終了】　☆☆☆"))


      (princ (strcat "\n☆☆☆　kpdeploy19oem.arx ロード　☆☆☆"))
      (if (= nil (member "kpdeploy19oem.arx" (arx)))
        (if (findfile (strcat CG_LISPPATH "kpdeploy19oem.arx"))
          (arxload (strcat CG_LISPPATH "kpdeploy19oem.arx"  ))
        );_if
      )
      (princ (strcat "\n☆☆☆　kpdeploy19oem.arx ロード【終了】　☆☆☆"))


      (princ (strcat "\n☆☆☆　BukkenInfoRewrite19oem.arx ロード　☆☆☆"))
      (if (= nil (member "BukkenInfoRewrite19oem.arx" (arx)))
        (if (findfile (strcat CG_LISPPATH "BukkenInfoRewrite19oem.arx"))
          (arxload (strcat CG_LISPPATH "BukkenInfoRewrite19oem.arx"  ))
        );_if
      )
			(princ (strcat "\n☆☆☆　BukkenInfoRewrite19oem.arx ロード【終了】　☆☆☆"))


			;2017/06/20 YM ADD-S フレームキッチン対応 正規表現をつかうために必要
      (princ (strcat "\n☆☆☆　acetutil.arx ロード　☆☆☆"))
      (if (= nil (member "acetutil.arx" (arx)))
        (if (findfile (strcat CG_LISPPATH "acetutil.arx"))
          (arxload (strcat CG_LISPPATH "acetutil.arx"  ))
        );_if
      );_if
      (princ (strcat "\n☆☆☆　acetutil.arx ロード【終了】　☆☆☆"))
			;2017/06/20 YM ADD-E フレームキッチン対応 正規表現をつかうために必要

      (princ (strcat "\n☆☆☆　doslibはLOADしない　☆☆☆"))
    )
  );if

	(princ (strcat "\n★★★　DBSQLほか LOAD　★★★"))

  ;06/06/14 AO ADD ロードするファイル名より拡張子を削除 ⇒ fasをロード
  (load (strcat CG_LISPPATH "DBSQL"   ))  ;DBアクセス
  (load (strcat CG_LISPPATH "COMMON"  ))  ;共通
  (load (strcat CG_LISPPATH "CFOUTSTA"))  ;ログファイル出力
  (load (strcat CG_LISPPATH "CFCMN"   ))  ;共通
  ;***************************************************

	(princ (strcat "\n★★★　CmnLoadProgram　ＥＮＤ　★★★"))
  (princ)
);CmnLoadProgram

;;;<HOM>************************************************************************
;;; <関数名>  : LoadProgramKPCAD
;;; <処理概要>: KPCADプログラムのロード
;;; <戻り値>  : なし
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun LoadProgramKPCAD (
  /
  )
	(princ (strcat "\n★★★　LoadProgramKPCAD　START　★★★"))

	(princ (strcat "\n★★★　geom3d.crx load　★★★"))
  (if (= nil (member "geom3d.arx"   (arx))) (arxload "GEOM3D"));crxに変更 2015/03/18

	(princ (strcat "\n★★★　acsolids.crx load　★★★"))
  (if (= nil (member "acsolids.arx" (arx))) (arxload "ACSOLIDS"));crxに変更 2015/03/18

  (if (= CG_LoadSK nil)
    (progn
			(princ (strcat "\n★★★　Utils.fas load　★★★"))
      (load (strcat CG_LISPPATH "Utils")) ;ユーティリティ
			(princ (strcat "\n★★★　load.fas load　★★★"))
      (load (strcat CG_LISPPATH "load" ))
      (LOADLOAD)
      (setq CG_LoadSK T)
    )
  )
  (princ)
)
;;;LoadProgramKPCAD

;;;<HOM>************************************************************************
;;; <関数名>  : ReadInputCFG
;;; <処理概要>: INPUT.CFGﾌｧｲﾙをReadする
;;; <戻り値>  : キーと値のリスト群
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun ReadInputCFG (
  /
  #fp
  #rstr
  #itm$
  #res$$
  #key
  )

  (setq #fp (open "./input.cfg" "r")) ;ﾌｧｲﾙｵｰﾌﾟﾝ(READ)
  (while (setq #rstr (read-line #fp)) ;ﾌｧｲﾙを読み込む
    (if (= (substr #rstr 1 1) "*")    ;文字列をﾃﾞﾐﾘﾀで区切る
      (progn
        (if (/= #key nil)
          (progn
            (setq #res$$ (append #res$$ (list (cons #key (list #itm$)))))
            (setq #itm$ nil)
          )
        )
        (setq #key #rstr)
      )
      (progn
        (setq #itm$ (append #itm$ (list #rstr)))
      )
    )
  )
  (setq #res$$ (append #res$$ (list (cons #key (list #itm$)))))
  (close #fp)  ;// ﾌｧｲﾙｸﾛｰｽﾞ

  ;// 結果を返す
  #res$$
)
;;;ReadInputCFG

;;;<HOM>************************************************************************
;;; <関数名>    : ReadIniFile
;;; <処理概要>  : INIファイルをReadする
;;; <戻り値>    : キー文字列と値のリスト群
;;; <備考>      : なし
;;;************************************************************************>MOH<
(defun ReadIniFile (
  &inifile
  /
  #fp
  #rstr
  #itm$
  #res$$
  )

  (setq #fp (open &inifile "r"))      ;ファイルオープン(READ)
  (while (setq #rstr (read-line #fp)) ;ファイルを読み込む
    (setq #itm$ (strparse #rstr "=")) ;文字列をデミリタで区切る
    (setq #res$$ (append #res$$ (list #itm$)))
  )
  (close #fp)  ;// ファイルクローズ

  ;// 結果を返す
  #res$$
)
;;;ReadIniFile

;;;<HOM>************************************************************************
;;; <関数名>  : StrParse
;;; <処理概要>: 文字列を指定区切り文字で分割する
;;; <戻り値>  : 文字列のロスト
;;; <備考>    : Ex.(StrParse " 1,,  2,  3," ",") -> ("1" "2" "3")
;;;************************************************************************>MOH<
(defun StrParse (
  &strng
  &chs
  /
  #len
  #c
  #l
  #s
  #chsl
  #cnt
  )

  ;// S-内部関数宣言
  (defun StrTol ( &s / #lst #c )
    (repeat (setq #c (strlen &s))
      (setq #lst (cons (substr &s #c 1) #lst))
      (setq #c   (1- #c))
    )
    #lst
  )
  ;// E-内部関数宣言

  (setq #chsl (StrTol &chs))
  (setq #len  (strlen &strng) #s "" #cnt (1+ #len))
  (while (> (setq #cnt (1- #cnt)) 0)
    (setq #c (substr &strng #cnt 1))
    (if (member #c #chsl)
      (setq #l (cons #s #l) #s "")
      (setq #s (strcat #c #s))
    )
  )

  (cons #s #l)
)
;;;StrParse

;;;<HOM>************************************************************************
;;; <関数名>    : C:SaveQuit
;;; <処理概要>  : KPCAD終了コマンド
;;; <戻り値>    : なし
;;; <備考>      : 図面を保存して【中断】する　ﾌﾟﾗﾝﾆﾝｸﾞﾒﾆｭｰと図面参照時
;;;************************************************************************>MOH<
(defun C:SaveQuit (
  /
  )
  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 前処理
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO処理追加

  (if (CFYesNoDialog "現在のメニューを終了しますか？")
  ;(if (CFYesNoDialog "物件管理に戻りますか？")
    (progn
      ;// 自動保存
      (CFAutoSave)
      ; 01/07/04 YM ADD 見積りﾀﾞｲｱﾛｸﾞをKILL
;;;      (C:arxStartApp (strcat CG_SysPATH "KillMitumo.exe") 0)

      (setvar "PICKFIRST" 1) ;01/08/24 HN ADD コマンドの発行前にオブジェクトを選択
      (command ".quit")
    )
  )

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 後処理
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO処理追加

  (princ)
);C:SaveQuit


;;;<HOM>************************************************************************
;;; <関数名>    : C:SaveQuitFIX
;;; <処理概要>  : KPCAD【確定】終了
;;; <戻り値>    : なし
;;; <備考>      : 図面を保存して【確定】終了する
;;;               ①部材確認ｺﾏﾝﾄﾞ呼び出し
;;;               ②PB用逆引き
;;;               ③積算情報のUPLOAD
;;;************************************************************************>MOH<
(defun C:SaveQuitFIX (
  /
;-- 2011/10/14 A.Satoh Mod - S
	#end_type
;-- 2011/10/14 A.Satoh Mod - E
  )
  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 前処理
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO処理追加

;-- 2011/10/14 A.Satoh Mod - S
;;;;;  ;①部材確認ｺﾏﾝﾄﾞ呼び出し
;;;;;;;; (C:ConfPartsAll)  
;;;;;
;;;;;  (if (CFYesNoDialog "現在のメニューを終了しますか？")
;;;;;  ;(if (CFYesNoDialog "物件管理に戻りますか？")
;;;;;    (progn
;;;;;;-- 2011/10/11 A.Satoh Add - S
;;;;;			(setq #cancel nil)
;;;;;
;;;;;      ; 現在の扉情報等をInput.CFGに書き込む
;;;;;      (setq #ret (CFOutInputCfg))
;;;;;			(if (= #ret nil)
;;;;;				(setq #cancel T)
;;;;;			)
;;;;;;-- 2011/10/11 A.Satoh Add - E
;;;;;
;;;;;;-- 2011/10/13 A.Satoh Add - S
;;;;;			(if (= #cancel nil)
;;;;;				(if (findfile (strcat CG_SYSPATH "SelectUploadDWG.exe"))
;;;;;					(progn
;;;;;						(C:arxStartApp (strcat CG_SysPATH "SelectUploadDWG.exe") 1)
;;;;;						(setq #planinfo$$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
;;;;;						(if (= #planinfo$$ nil)
;;;;;							(progn
;;;;;								(CFAlertMsg (strcat "PLANINFO.CFGの読込に失敗しました。\n" CG_KENMEI_PATH "PLANINFO.CFG"))
;;;;;								(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
;;;;;								(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
;;;;;								(setq #cancel T)
;;;;;							)
;;;;;							(progn
;;;;;								(setq #flag nil)
;;;;;								(foreach #planinfo$ #planinfo$$
;;;;;									(if (= (nth 0 #planinfo$) "[PDF_DXF_TARGET]")
;;;;;										(setq #flag T)
;;;;;									)
;;;;;								)
;;;;;
;;;;;								(if (= #flag nil)
;;;;;									(progn
;;;;;										(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
;;;;;										(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
;;;;;										(setq #cancel T)
;;;;;									)
;;;;;								)
;;;;;							)
;;;;;						)
;;;;;					)
;;;;;					(progn
;;;;;						(CFAlertMsg "UPLOAD対象図面選択ﾓｼﾞｭｰﾙ(SelectUploadDWG.exe)がありません。")
;;;;;						(vl-file-delete (strcat CG_SYSPATH "Input.cfg"))
;;;;;						(vl-file-rename (strcat CG_SYSPATH "Input0.cfg") (strcat CG_SYSPATH "Input.cfg"))
;;;;;						(setq #cancel T)
;;;;;					)
;;;;;				)
;;;;;			)
;;;;;
;;;;;			(if (= #cancel nil)
;;;;;				(progn
;;;;;;-- 2011/10/13 A.Satoh Add - E
;;;;;
;;;;;      ;// 自動保存
;;;;;      (CFAutoSave)
;;;;;      ; 01/07/04 YM ADD 見積りﾀﾞｲｱﾛｸﾞをKILL
;;;;;;;;      (C:arxStartApp (strcat CG_SysPATH "KillMitumo.exe") 0)
;;;;;
;;;;;      (setvar "PICKFIRST" 1) ;01/08/24 HN ADD コマンドの発行前にオブジェクトを選択
;;;;;      (setvar "GRIPS"1) ;グリップを表示
;;;;;
;;;;;      (command ".quit")
;;;;;;-- 2011/10/13 A.Satoh Add - S
;;;;;				)
;;;;;			)
;;;;;;-- 2011/10/13 A.Satoh Add - E
;;;;;    )
;;;;;  )
	(cond
		((= CG_PROGMODE "PLAN")		; プランニングメニュー
			; 中断終了/破棄終了選択ダイアログ処理
			(setq #end_type (KPCAD_StopCancelDlg))
			(cond
				((= #end_type 2)	; 中断終了
					; 中断終了処理を行う
					(KPCAD_StopEnd)
				)
				((= #end_type 3)	; 破棄終了
					; 破棄終了処理を行う
					(KPCAD_CancelEnd)
				)
			)
;			(if (= #end_type T)
;				; 中断終了処理を行う
;				(KPCAD_StopEnd)
;				; 破棄終了処理を行う
;				(KPCAD_CancelEnd)
;			)
		)
		((= CG_PROGMODE "PLOT")		; 出力関係メニュー
			(if (= (strcase (getvar "DWGNAME")) "MODEL.DWG")
				(progn		; 物件図面(Model.dwg)
					(setq #end_type (KPCAD_FixEndDlg))
					(cond
						((= #end_type 1)	; 確定終了
							(KPCAD_FixEnd)
						)
						((= #end_type 2)	; 中断終了
							; 中断終了処理を行う
							(KPCAD_StopEnd)
						)
						((= #end_type 3)	; 破棄終了
							; 破棄終了処理を行う
							(KPCAD_CancelEnd)
						)
					)
				)
				(progn		; ; 図面参照時
					(setq #end_type (KPCAD_StopCancelDlg))
					(cond
						((= #end_type 2)	; 中断終了
							; 中断終了処理を行う
							(KPCAD_StopEnd)
						)
						((= #end_type 3)	; 破棄終了
							; 破棄終了処理を行う
							(KPCAD_CancelEnd)
						)
					)
;					(if (= #end_type T)
;						; 中断終了処理を行う
;						(KPCAD_StopEnd)
;						; 破棄終了処理を行う
;						(KPCAD_CancelEnd)
;					)
				)
			)
		)
	)
;-- 2011/10/14 A.Satoh Mod - E

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 後処理
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO処理追加

  (princ)
);C:SaveQuitFIX

;;;<HOM>************************************************************************
;;; <関数名>    : C:ChgMenuPlot
;;; <処理概要>  : 印刷関連メニューに切り替える
;;; <戻り値>    : なし
;;; <備考>      : 現在の状態を保存して切り替える
;;;************************************************************************>MOH<
(defun C:ChgMenuPlot (
  /
  #SS1 #SS2
;-- 2011/09/14 A.Satoh Add - S
  #idx #en$
;-- 2011/09/14 A.Satoh Add - E
	#ename$ #msg  ;-- 2012/01/27 A.Satoh Add
	#DOORINFO #HINBAN #I #QRY_KIHON$$ #SS_LSYM #SYM #TENKAI_TYPE #XD$ ;2012/02/17 YM ADD
	#DEEP_FLG #N #OBUN_FLG #PT$ #PT2$ #QRY$ #SKK #SS #SSWT #TEI #TOKU_KIGO #WT #XDWT$ ;2013/4/5 YM ADD
	#xFlr ;2013/11/20 YM ADD-S 天幕の存在
  )

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 前処理
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO処理追加

	;2013/11/20 YM ADD-S 天幕の存在
	(setq  CG_EXIST_FILR nil);初期化
	(setq #xFlr (ssget "X" (list (list -3 (list "G_FILR")))))
	(if (and #xFlr (< 0 (sslength #xFlr)))
		(setq CG_EXIST_FILR T)
	);_if
	;2013/11/20 YM ADD-E 天幕の存在

;;;01/09/03YM@MOD  ;// コマンド初期化
;;;01/09/03YM@MOD  (StartCmnErr) --->undoBがない

  ;00/07/18 SN MOD ﾜｰｸﾄｯﾌﾟが無くてもﾒﾆｭｰ切替可とする。
  ;// ワークトップが品番未確定なら自動確定する
  ;(setq #ss1 (ssget "X" '((-3 ("G_WRKT")))))
  ;(setq #ss2 (ssget "X" '((-3 ("G_LSYM")))))
  ;(if (or (= #ss1 nil) (= (sslength #ss1) 0))
  ;  (if (= (sslength #ss2) 1) ; LSYM１つだけ
  ;    (princ)
  ;    (progn
  ;      (CFAlertErr "ワークトップが配置されていません")
  ;      (quit)
  ;    )
  ;  );_if
  ;);_if

  ;// ワークトップが品番未確定なら自動確定する
;-- 2011/09/14 A.Satoh Mod - S
;  (PKAutoHinbanKakutei)
  (if (= (PKAutoHinbanKakutei) nil)
    (progn
      (CFAlertErr "品番未確定のﾜｰｸﾄｯﾌﾟが存在します")
      (quit)
    )
  )
;-- 2011/09/14 A.Satoh Mod - E

;-- 2011/09/13 A.Satoh Add - S
  (if (= (PKAutoTokuTenban) nil)
    (progn
      (CFAlertErr "規格品として品番確定されている特注ﾜｰｸﾄｯﾌﾟが存在します")
      (quit)
    )
  )
;-- 2011/09/13 A.Satoh Add - E

;-- 2011/09/14 A.Satoh Add - S
  (setq #ss1 (ssget "X" '((-4 . "<OR") (-3 ("G_LSYM")) (-3 ("G_FILR")) (-4 . "OR>"))))
  (if #ss1
    (progn
      (setq #en$ nil)
      (setq #idx 0)
      (repeat (sslength #ss1)
        (if (CFGetXData (ssname #ss1 #idx) "G_ERR")
          (setq #en$ (append #en$ (list (ssname #ss1 #idx))))
        )
        (setq #idx (1+ #idx))
      )

      (if (/= #en$ nil)
        (progn
          (command "_undo" "m")
          (setq #idx 0)
          (repeat (length #en$)
            (GroupInSolidChgCol2 (nth #idx #en$) CG_InfoSymCol)
            (setq #idx (1+ #idx))
          )
          (CFAlertErr "図面上に禁則ｴﾗｰ部材が存在します")
          (command "_undo" "b")
          (quit)
        )
      )
    )
  )
;-- 2011/09/14 A.Satoh Add - E

;-- 2012/01/27 A.Satoh Add - S
	(setq #ename$ (KPCAD_CheckErrBuzai))
	(if #ename$
		(progn
			(setq #idx 0)
			(repeat (length #ename$)
				(GroupInSolidChgCol2 (nth #idx #ename$) CG_InfoSymCol)
				(setq #idx (1+ #idx))
			)
			(setq #msg (strcat "図面上に不正な部材が存在します。"
												"\n対象の部材を削除の上、もう一度作成し直して下さい。"
												"\n不正部材の配置における詳細な手順を「情報システム部」にご報告下さい。"))
			(CFAlertErr #msg)
			(quit)
		)
	)
;-- 2012/01/27 A.Satoh Add - E




;-- 2013/04/05 YM-S
  (setq #ssWT (ssget "X" '((-3 ("G_WRKT")))))
	(if (and #ssWT (<= 1 (sslength #ssWT)))
		(progn
			(setq #n 0)
			(repeat (sslength #ssWT)
				(setq #WT (ssname #ssWT #n))
  			(setq #xdWT$ (CFGetXData #WT "G_WRKT"))
			  (setq #tei (nth 38 #xdWT$))        ; WT底面図形ﾊﾝﾄﾞﾙ
			  (setq #pt$ (GetLWPolyLinePt #tei)) ; 外形点列
			  (setq #pt2$ (append #pt$ (list (car #pt$)))) ; 終点の次に始点を追加して領域を囲う

			  (setq #magu (nth 55 #xdWT$))      ; WT間口
			  (setq #mag1 (nth 0 #magu))        ; WT間口1
			  (setq #mag2 (nth 1 #magu))        ; WT間口2

			  (command "_view" "S" "TEMP_HANTEI")
				(command "vpoint" "0,0,1")
			  ;// 領域に含まれるG_LSYMを検索する
			  (setq #ss (ssget "CP" #pt2$ (list (list -3 (list "G_LSYM"))))) ; 領域内のｼﾝﾎﾞﾙ図形
			  (command "_view" "R" "TEMP_HANTEI")

			  (setq #i 0)
				(setq #OBUN_FLG nil)
				(setq #DEEP_FLG nil)

			  (if (and #ss (> (sslength #ss) 0))
			    (progn
	          (repeat (sslength #ss)
	            (setq #sym (ssname #ss #i)) ; 領域内の各ｼﾝﾎﾞﾙ
	            (setq #xd$ (CFGetXData #sym "G_LSYM"))
							;品番
							(setq #hinban (nth 5 #xd$))
							;性格ｺｰﾄﾞ
							(setq #SKK (nth 9 #xd$))

							;;;・オーブンの判定
							;;;　性格コード１１３ かつ 複合オーブンに存在した場合
							(if (equal #SKK 113 0.001)
								(progn
									;[複合OBUN]
								  (setq #qry$
								    (CFGetDBSQLRec CG_DBSESSION "複合OBUN"
								      (list
								        (list "品番名称" #hinban 'STR)
								      )
								    )
								  )
								  (if #qry$
										(setq #OBUN_FLG T)
									);_if
								)
							);_if

							;;;・ディープ食洗の判定
							;;;　性格コード１１０ かつ 品番基本の特注対象が"X"でない場合
							(if (equal #SKK 110 0.001)
								(progn
									;[複合OBUN]
								  (setq #qry$
								    (CFGetDBSQLRec CG_DBSESSION "品番基本"
								      (list
								        (list "品番名称" #hinban 'STR)
								      )
								    )
								  )
								  (if (and #qry$ (= 1 (length #qry$)))
										(progn
											(setq #TOKU_KIGO (nth 10 (car #qry$))) ;特注対象
											(if (/= "X" #TOKU_KIGO)
												(setq #DEEP_FLG T)
											);_if
										)
									);_if
								)
							);_if

	            (setq #i (1+ #i))
	          );(repeat
			    )
			  );_if

				(setq #n (1+ #n))
			)
		)
	);_if

	(if (and #DEEP_FLG #OBUN_FLG)
		(progn
			(if (CFYesNoDialog "\nオーブンレンジとディープ食洗機は隣接できません。配置を確認して下さい。\n出力関係ﾒﾆｭｰに移行しますか？")
				;「継続」と「戻る」
				(progn ;Yes
					nil
				)
				(progn ;No
					(quit)
				)
			);_if
		)
	);_if



;-- 2013/04/05 YM-E



	;2012/02/17 YM ADD-S
	(setq #ss_LSYM (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss_LSYM (< 0 (sslength #ss_LSYM)))
    (progn
			(setq #i 0)
			(repeat (sslength #ss_LSYM)
				(setq #sym (ssname #ss_LSYM #i))
				;【品番基本】展開タイプ=0のときG_LSYM扉情報がなければｾｯﾄする(CG対応のため)
				(setq #xd$ (CFGetXData #sym "G_LSYM"))

	      (setq #DoorInfo (nth 7 #xd$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"
	      (if (or (= nil #DoorInfo)(= #DoorInfo ""))
					(progn
						(setq #hinban (nth 5 #xd$));品番名称
						;展開ﾀｲﾌﾟ取得
		        (setq #Qry_kihon$$
		          (CFGetDBSQLRec CG_DBSESSION "品番基本"
		            (list (list "品番名称"  #hinban 'STR))
		          )
		        )
						(if (and #Qry_kihon$$ (= 1 (length #Qry_kihon$$)))
							(progn
								(setq #tenkai_type (nth 4 (car #Qry_kihon$$)));展開ﾀｲﾌﾟ
								(if (equal #tenkai_type 0.0 0.001);展開ﾀｲﾌﾟ=0
									(progn ;扉情報更新
		                (CFSetXData #sym "G_LSYM"
		                  (CFModList #xd$
		                    (list
		                      (list 7 (strcat CG_DRSeriCode "," CG_DRColCode "," CG_HIKITE))
		                    )
		                  )
		                )
									)
								);_if
							)
						);_if
					)
				);_if

				;2014/04/23 YM ADD-S
				;G_LSYMの回転角度を正規化
				;(Angle0to360 6.2831999)

				;2016/02/09 YM ADD-S 上でCFMODして更新した内容が消えてしまうので#xd$を取り直し
				(setq #xd$ (CFGetXData #sym "G_LSYM"))
				;2016/02/09 YM ADD-E

				(setq #SetAng (nth 2 #xd$)) ;配置角度
				(setq #SetAng (Angle0to360 #SetAng));配置角度を正規化
        (CFSetXData #sym "G_LSYM"
          (CFModList #xd$
            (list
              (list 2 #SetAng)
            )
          )
        )
				;2014/04/23 YM ADD-E

				(setq #i (1+ #i))
			);repeart

		)
	);_if
	;2012/02/17 YM ADD-E


	;2012/08/24 YM MOV-S
	; 図面の物件名称書き換え input.cfgを見て枠内文言を書き換える
	(if (= 0 CG_SYUTURYOKU_MENU)
		(progn ;まだ一度も書き換えていない

(princ "\n　★★★　(KP_BukkenInfoRewrite)実行前　★★★")
;;;			(KP_BukkenInfoRewrite) ;OEMで動かない 2016/10/18 YM MOD
(Command "BukkenInfoRewrite")  ;OEMで動かない 2016/10/18 YM MOD
(princ "\n　★★★　(KP_BukkenInfoRewrite)実行後　★★★")
			;物件名称書き換え記録
			(setq CG_SYUTURYOKU_MENU (1+ CG_SYUTURYOKU_MENU));書き換えすると"1"になる
		)
	);_if
	;2012/08/24 YM MOV-E


  ;// 自動保存
  (CFAutoSave)

  ;00/08/01 SN ADD ﾌﾘｰﾌﾟﾗﾝﾀﾞｲｱﾛｸﾞの終了
  (C:arxStartApp (strcat CG_SysPATH "KillPlan.exe") 2)

  ;01/05/10 YM ADD 物件構成ﾃｰﾌﾞﾙの更新
;;;  (C:arxStartApp (strcat CG_SysPATH "MDBupd.exe") 0) ;2017/07/18 YM DEL 使っていない

	(princ)
	
	;2017/07/18 YM ADD
;;;	(command "delay" "2000");1秒待ち

	; 2017/06/13 KY ADD-S
	; フレームキッチン対応
	; "Hosoku.cfg"に金具を出力(フレームより算出)

	(if (= BU_CODE_0012 "1")
		(progn
			(if (CFYesNoDialog "\n金具の自動積算を行いますか？")
				(OutputKanaguInfo)
				;esle
				(princ)
			);_if
		)
	);if

	; 2017/06/13 KY ADD-E

  ;// メニューの切り替え
  (setq CG_PROGMODE "PLOT")
  (ChgSystemCADMenu CG_PROGMODE)

  ;// 矢視関連の画層を表示する
  (CFDispYashiLayer)

  ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは表示しない
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
    nil
    (CFYesDialog "出力関係メニューに切り替えました")
  );_if
  ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞでは表示しない

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 後処理
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO処理追加

  (princ)
)
;;;C:ChgMenuPlot

;;;<HOM>************************************************************************
;;; <関数名>  : C:ChgMenuPlan
;;; <処理概要>: プランニングメニューに切り替える
;;; <戻り値>  : なし
;;; <備考>    : 現在の状態を保存して切り替える
;;;************************************************************************>MOH<
(defun C:ChgMenuPlan (
  /
  )
  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 前処理
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (StartUndoErr)
  );_if
  ; 01/09/03 YM ADD-E UNDO処理追加

  ;// 自動保存
  ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは保存しない
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
    nil
    (progn
      (CFAutoSave)
      ; 01/07/03 YM ADD 見積りﾀﾞｲｱﾛｸﾞをKILL
;;;      (C:arxStartApp (strcat CG_SysPATH "KillMitumo.exe") 0)
    )
  );_if
  ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞでは保存しない

;;;01/09/07YM@MOD  (CFAutoSave)

  ; 01/07/03 YM ADD 見積りﾀﾞｲｱﾛｸﾞをKILL
;;;01/09/07YM@MOD  (C:arxStartApp (strcat CG_SysPATH "KillMitumo.exe") 0)

  ;// メニューの切り替え
  (setq CG_PROGMODE "PLAN")
  (ChgSystemCADMenu CG_PROGMODE)
  (setvar "GRIPS" 0)

  ;// 矢視関連の画層を非表示にする
  (CFHideYashiLayer)

  ; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは表示しない
  (if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
;;; (if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
    nil
    (CFYesDialog "プランニングメニューに切り替えました")
  );_if
  ; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞでは表示しない

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 後処理
  (if (= CG_AUTOMODE 0) ; 01/10/05 YM 自動ﾓｰﾄﾞでｴﾗｰ関数定義しない
    (setq *error* nil)
  );_if
  ; 01/09/03 YM ADD-E UNDO処理追加

  (princ)
)
;;;C:ChgMenuPlan

;;;<HOM>************************************************************************
;;; <関数名>  : C:Quit
;;; <処理概要>: 本システムを終了する
;;; <戻り値>  : なし
;;; <備考>    : なし 使用している?
;;;************************************************************************>MOH<
(defun C:Quit (
  /
  )

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 前処理
  (StartUndoErr)
  ; 01/09/03 YM ADD-E UNDO処理追加

  (if (CFYesNoDialog "物件管理に戻りますか？")
    (progn
      ;// 自動保存
      (CFAutoSave)
      (setvar "PICKFIRST" 1) ;01/08/24 HN ADD コマンドの発行前にオブジェクトを選択
      (command ".quit")
    )
  )

  ; 01/09/03 YM ADD-S UNDO処理追加
  ; 後処理
  (setq *error* nil)
  ; 01/09/03 YM ADD-E UNDO処理追加

  (princ)
)
;;;C:Quit

(setq C:_Quit C:Quit)

;<HOM>*************************************************************************
; <関数名>    : WebOutLog
; <処理概要>  : ﾛｸﾞﾌｧｲﾙに処理内容を出力する(WEB版)
; <戻り値>    : なし
; <作成>      : 02/09/04 YM
; <備考>      : 処理のﾛｸﾞを出力し、どこで異常終了したか原因究明に使用する
;               WEB版CADｻｰﾊﾞｰのときにのみﾛｸﾞ出力する
;*************************************************************************>MOH<
(defun WebOutLog (
  &msg ; 文字列,数値,ﾘｽﾄ,nil 可
  /
  #F
  )
  ;04/01/04 YM CG_AUTOMODE=4 を追加
  (if (and CG_LOGFILE (or (= CG_AUTOMODE 2)(= CG_AUTOMODE 4))); WEB版ｻｰﾊﾞｰﾓｰﾄﾞ
    (progn
      ; ﾛｸﾞのﾊﾟｽが通ってないときは警告表示＆くても継続実行する
      (setq #f (open CG_LOGFILE "a"))
      (if #f
        ; ﾛｸﾞのﾊﾟｽが通っている
        (progn
          (if (= 'LIST (type &msg))
            (foreach elm &msg
              (princ "\n" #f)
              (princ elm  #f)
            )
          ; else
            (progn
              (princ "\n" #f)
              (princ &msg #f)
            )
          );_if
          (close #f)
        );_if
        (progn
          (princ (strcat "ﾛｸﾞﾌｧｲﾙのﾊﾟｽが通ってないため、ﾛｸﾞを出力できません。(iniﾌｧｲﾙをご確認下さい)"
                              "\n実行上問題はないので処理を継続します。"))
        )
      );_if
    )
  );_if
  (princ)
);WebOutLog

;<HOM>*************************************************************************
; <関数名>    : SKAutoError
; <処理概要>  : 初期ｴﾗｰ関数 WEB版CADｻｰﾊﾞｰ用
;               02/09/06 YM ADD INIT.LSPのみしかLOADしていないので
;               DBDisConnectなどの関数が使えない→(SKAutoError2)は使えない
;*************************************************************************>MOH<
(defun SKAutoError ( msg / #msg )
  (princ "\n自動レイアウト処理が中断されました.")
  ;// エラーログ出力用文字列に追加する
  (if (/= msg CG_ERRMSG)
    (setq CG_ERRMSG (append CG_ERRMSG (list msg)))
  );_if

  ; ｴﾗｰﾛｸﾞに書き込み
  (CFOutErrLog)
  (setq CG_DBSESSION nil)
  (setq CG_CDBSESSION nil)

;;;  (startapp (strcat CG_SYSPATH "WARN.EXE"))
;;;  (if (= CG_AUTOFLAG "1")
    (command "_quit" "y")
;;;  )
  (princ)
);SKAutoError

;<HOM>*************************************************************************
; <関数名>    : CFOutErrLog
; <処理概要>  : エラーの内容をエラーログファイルに書き出す
; <戻り値>    : なし
; <作成>      : 1998-06-16
; <備考>      : 本ﾌﾟﾛｸﾞﾗﾑは全て自己処理のため、異常終了したときの原因究明用に、
;               各処理のﾛｸﾞをﾌｧｲﾙにまとめます。
;               引数 msg の形式は princ で出力される形式でよい
; 02/09/05 YM ADD WEB版専用
;*************************************************************************>MOH<
(defun CFOutErrLog (
    /
    #f #msg
  )
  (if (and CG_ERRFILE (= CG_AUTOMODE 2)); WEB版ｻｰﾊﾞｰﾓｰﾄﾞ
    (progn
      (setq #f (open CG_ERRFILE "w")) ; 上書きﾓｰﾄﾞに変更 02/09/06 YM ADD

      (if #f   
        (progn ; ﾛｸﾞのﾊﾟｽが通っている

;;;         (if CG_SETPLAN_NO ; ｾｯﾄﾌﾟﾗﾝNO
;;;           (progn
;;;             (princ "ｾｯﾄﾌﾟﾗﾝNO: " #f)
;;;             (princ CG_SETPLAN_NO #f)
;;;             (princ "\n" #f)
;;;             (princ "\n  error:\n" #f)
;;;           )
;;;           (progn ; 02/09/10 YM ADD
;;;             (princ "ｾｯﾄﾌﾟﾗﾝNOがありません" #f)
;;;           )
;;;         );_if
          (foreach #msg CG_ERRMSG
            (princ "    " #f)
            (princ #msg #f)
            (princ "\n" #f)
          )
          (close #f)
        )
        (progn
          (princ (strcat "ﾛｸﾞﾌｧｲﾙのﾊﾟｽが通ってないため、ﾛｸﾞを出力できません。(iniﾌｧｲﾙをご確認下さい)"
                        "\n実行上問題はないので処理を継続します。"))
        )
      );_if
    )
  );_if
  (princ)
);CFOutErrLog

(princ)
