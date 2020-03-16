;;;<HOM>************************************************************************
;;; <関数名>  : C:KpPageSetup
;;; <処理概要>: ページ設定コマンド
;;; <戻り値>  : なし
;;; <作成>    : 2001-04-08 HN 画層"0_HIDE"の非表示処理を追加
;;; <改訂>    :
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun C:KpPageSetup
  (
  /
  #eLayer     ; 画層"0_HIDE"の図形名
  #eLayer$    ; 画層"0_HIDE"の定義データ
  #iLayer     ; 画層の標準フラグ値(LAYERのグループ コード 70)
  )
  ;@@@(princ "\nKPCAD PAGESETUP...") ;DEBUG

  (setq #eLayer (tblobjname "LAYER" "O_HIDE"))
  (if #eLayer
    (progn
      (setq #eLayer$ (entget #eLayer))
      (setq #iLayer (cdr (assoc 62 #eLayer$)))
      (if (< 0 #iLayer)
        (progn
          (setq #iLayer (* -1 #iLayer))
          (entmod (subst (cons 62 #iLayer) (assoc 62 #eLayer$) #eLayer$))
          (command "_REGEN")
        )
      )
    )
  )

  (command "_PAGESETUP")

  (if #eLayer
    (progn
      (entmod #eLayer$)
      (command "_REGEN")
    )
  )

  (princ)
)
;_C:KpPageSetup

;;;<HOM>************************************************************************
;;; <関数名>  : C:KpPreview
;;; <処理概要>: 印刷プレビューコマンド
;;; <戻り値>  : なし
;;; <作成>    : 2001-04-08 HN 画層"0_HIDE"の非表示処理を追加
;;; <改訂>    :
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun C:KpPreview
  (
  /
  #eLayer     ; 画層"0_HIDE"の図形名
  #eLayer$    ; 画層"0_HIDE"の定義データ
  #iLayer     ; 画層の標準フラグ値(LAYERのグループ コード 70)
  )
  ;@@@(princ "\nKPCAD PREVIEW...") ;DEBUG

  (setq #eLayer (tblobjname "LAYER" "O_HIDE"))
  (if #eLayer
    (progn
      (setq #eLayer$ (entget #eLayer))
      (setq #iLayer (cdr (assoc 62 #eLayer$)))
      (if (< 0 #iLayer)
        (progn
          (setq #iLayer (* -1 #iLayer))
          (entmod (subst (cons 62 #iLayer) (assoc 62 #eLayer$) #eLayer$))
          (command "_REGEN")
        )
      )
    )
  )

  (command "_PREVIEW")

  (if #eLayer
    (progn
      (entmod #eLayer$)
      (command "_REGEN")
    )
  )

  (princ)
)
;_C:KpPreview

;;;<HOM>************************************************************************
;;; <関数名>  : C:KpPlot
;;; <処理概要>: 印刷プレビューコマンド
;;; <戻り値>  : なし
;;; <作成>    : 2001-04-08 HN 画層"0_HIDE"の非表示処理を追加
;;; <改訂>    :
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun C:KpPlot
  (
  /
  #eLayer     ; 画層"0_HIDE"の図形名
  #eLayer$    ; 画層"0_HIDE"の定義データ
  #iLayer     ; 画層の標準フラグ値(LAYERのグループ コード 70)
  )
  ;@@@(princ "\nKPCAD PLOT...") ;DEBUG

  (setq #eLayer (tblobjname "LAYER" "O_HIDE"))
  (if #eLayer
    (progn
      (setq #eLayer$ (entget #eLayer))
      (setq #iLayer (cdr (assoc 62 #eLayer$)))
      (if (< 0 #iLayer)
        (progn
          (setq #iLayer (* -1 #iLayer))
          (entmod (subst (cons 62 #iLayer) (assoc 62 #eLayer$) #eLayer$))
          (command "_REGEN")
        )
      )
    )
  )

  (command "PLOT")

  (if #eLayer
    (progn
      (entmod #eLayer$)
      (command "_REGEN")
    )
  )

  (princ)
)
;_C:KpPlot

;;;<HOM>************************************************************************
;;; <関数名>  : C:PlainPlot
;;; <処理概要>: 簡易出力コマンド
;;; <戻り値>  : なし
;;; <作成>    : 1999-10-12
;;; <改訂>    : 2001-04-08 HN 画層"0_HIDE"の非表示処理を追加
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun C:PlainPlot  (
  /
;;;   #ini$$
;;;   #device
;;;   #scale
;;;   #ctb
;;;   #paper
;;;   #edit
;;;   #offx #offy ; 01/04/16 KS ADD オフセット対応
;;;   #eLayer     ; 画層"0_HIDE"の図形名
;;;   #eLayer$    ; 画層"0_HIDE"の定義データ
;;;   #iLayer     ; 画層の標準フラグ値(LAYERのグループ コード 70)
  )

	(setvar "pdmode" 0) ;2011/09/30 YM ADD

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
  );_if
  ; 119 01/04/08 HN E-ADD 画層"0_HIDE"の非表示処理を追加

  (if (= nil (findfile (strcat CG_SYSPATH "SCPLOT.CFG")))
    (CFAlertErr "印刷設定ファイル <SCPLOT.CFG> がありません")
  );_if
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
	;03/07/22 YM ADD-S
  (setq #CENTER   (cadr (assoc "CENTER"  #ini$$)))  ;印刷の中心
  (if (= nil #CENTER)
    (setq #CENTER "")
  )
	;03/07/22 YM ADD-E

  (setq #device   (cadr (assoc "DEVICE"  #ini$$)))  ;出力デバイス名
  (setq #edit     (cadr (assoc "EDIT"  #ini$$)))    ;エディタ名
; 01/04/16 KS S-ADD オフセット対応
  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;水平オフセット
  (if (= nil #offx)
    (setq #offx "0.0")
  )
  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;垂直オフセット
  (if (= nil #offy)
    (setq #offy "0.0")
  )
; 01/04/16 KS E-ADD オフセット対応
;  (if (= CG_ACAD_VER "OEM")
;    (progn
;      (if (= nil (findfile (strcat CG_SYSPATH "PLOTTERS\\" #device)))
;        (CFAlertErr (strcat
;            "印刷環境設定ファイル <" #device "> がありません\n\n"
;            "Preferences と入力し下記の通りに環境設定を行って下さい\n\n"
;            "  1.[印刷]タブをクリック\n"
;            "  2.[プロッタを追加または環境設定]をクリック\n"
;            "  3.プロッタを追加ウィザードを実行\n"
;            "  4.設定するシステムプリンタを選択\n"
;            "  5.プロッタ名に[Syscad Plotter1]と入力\n"
;            "  1.SysCADフォルダ内の[addplwiz.exe]を実行\n"
;            "  2.設定するシステムプリンタを選択\n"
;            "  3.プロッタ名に[Syscad Plotter1]と入力\n"
;            )
;        )
;      )
;    )
;  )
  ;01/03/06 KS S-MOD パース対応
  ;(if (= 0 (getvar "TILEMODE"))
  ;  (CFAlertErr (strcat
  ;      "簡易出力ではパース図面の印刷はサポートされておりません\n\n"
  ;      "印刷メニューの[ページ設定]-[印刷]にてご利用下さい   "
  ;      )
  ;  )
  ;01/03/06 KS E-MOD パース対応
  ;  (progn ; ELSE 00/07/11 SN MOD 以下の処理をELSE内の処理とする。
  ;    (setq #scale    (cadr (assoc "SCALE"   #ini$$)))  ;縮尺
      (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;印刷スタイルファイル名

      ;// 簡易印刷ダイアログ

			; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでは表示しない
			(if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
		;;;	(if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
	      (setq #ret$ CG_AUTOMODE_PRINT)
	      (setq #ret$ (SCPlainPlotDlg #device))
			);_if
			; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞでは表示しない

      (if (/= #ret$ nil)
        (progn
          (setq #paper (car #ret$))
          (setq #scale (cadr #ret$))
          ;00/06/20 SN S-MOD 用紙サイズの追加
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
          ;00/06/20 SN S-MOD 縮尺の追加
          (cond
            ((= #scale "scale20")(setq #scale "1:20"))
            ((= #scale "scale30")(setq #scale "1:30"))
            ((= #scale "scale40")(setq #scale "1:40"))
; 01/04/16 KS S-ADD オフセット対応
            ((= #scale "scale1")(setq #scale "1:1"))
; 01/04/16 KS E-ADD オフセット対応
            (T (setq #scale "F"))
          );_cond

          ;00/06/20 SN E-MOD
          (if (= 0 (getvar "TILEMODE"))
            (progn
              ;(setq #area "ﾚｲｱｳﾄ")
              (setq #area "E")
              (setq #lay  "ﾚｲｱｳﾄ1")
            )
            (progn
; 02/03/18 KS S-MOD 縮尺自動時はオブジェクト範囲、他は図面範囲で印刷
							; 02/06/03 YM DEL-S
;;;              (if (= #scale "F")
;;;                (setq #area "E")
;;;                (setq #area "L")
;;;              )
							; 02/06/03 YM DEL-E

							; 02/06/03 YM MOD-S
              (if (= #scale "F")
								(progn ; 縮尺自動だったらｵﾌｾｯﾄ=0.0とする 02/06/03 YM ADD
	                (setq #area "E")
							    (setq #offx "0.0")
									(setq #offy "0.0")
								)
;;;                (setq #area "L") ; 02/06/24 YM MOD
                (setq #area "E") ; 02/06/24 YM MOD
              );_if
							; 02/06/03 YM MOD-E

; 02/03/18 KS E-MOD
              (setq #lay  "Model")
            )
          );_if

					; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞではﾀﾞｲｱﾛｸﾞ表示しない
					(if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
				;;;	(if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
						(setq #YesNo T)
						; 01/09/07 YM MOD-S 変数格納
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
						; 01/09/07 YM MOD-E 変数格納
					);_if
					; 01/09/07 YM MOD-E 自動ﾓｰﾄﾞではﾀﾞｲｱﾛｸﾞ表示しない

					(if #YesNo ; 01/09/07 YM MOD
            (progn
							; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでscript不可
							(cond
								((or (= CG_AUTOMODE 1)(= CG_AUTOMODE 3)) ; 02/07/29 YM MOD 02/08/05 YM ADD
									(if (= (getvar "TILEMODE") 0)
										(progn ; ﾍﾟｰﾊﾟｰ空間
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
			                   "_.-LAYER"
			                   "ON"
			                   "O_HIDE"      ; 01/04/10 HN E-ADD 画層"0_HIDE"の表示処理を追加
			                   ""
			                );_command "_.-PLOT"
										) ; ﾍﾟｰﾊﾟｰ空間
; else
										(progn ; ﾓﾃﾞﾙ空間
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
			                   "_.-LAYER"
			                   "ON"
			                   "O_HIDE"      ; 01/04/10 HN E-ADD 画層"0_HIDE"の表示処理を追加
			                   ""
			                );_command "_.-PLOT"

										) ; ﾓﾃﾞﾙ空間
									);_if
								)
									; ↑ AUTOMODE ここまで ↑
				;else
									; ↓ 通常のの処理 ↓

	              ;// 印刷処理
	              ;(command "_.-PLOT"
								(T ; 02/07/29 YM MOD

								 ;03/07/22 YM ADD-S Scplot.cfgで印刷の中心も選択可能にした
								 (if (or (= "C" #CENTER)(= "c" #CENTER))
                 		(setq #CENTER "C")                      ;印刷オフセット
                 		(setq #CENTER (strcat #offx "," #offy)) ;印刷オフセット
								 );_if
								 ;03/07/22 YM ADD-E Scplot.cfgで印刷の中心も選択可能にした

		              (CFScriptCommand
		                ;01/03/06 KS S-MOD パース対応
		                (append
		                  (list
		                       "_.-PLOT"
		                       "Y"           ;詳細な印刷環境設定
		                       ;"Model"       ;レイアウト
		                       #lay
		                       #device       ;印刷デバイス名
		                       #paper        ;用紙サイズ(テンプレート)
		                       "M"           ;用紙単位
		                       "L"           ;図面の方向
		                       "N"           ;上下逆印刷
		                       #area         ;印刷領域 図面範囲
		                       #scale        ;縮尺
		                       ;"0.00,0.00"  ;印刷オフセット
		                       ; 01/04/16 KS S-ADD オフセット対応
		                       ;"C"           ;印刷オフセット
;;;		                       (strcat #offx "," #offy)   ;印刷オフセット
													#CENTER ; 03/07/22 YM ADD
		                       ; 01/04/16 KS E-ADD オフセット対応
		                       "Y"           ;印刷スタイル利用？
		                       #ctb          ;印刷スタイル名
		                       "Y"           ;線の太さを使用？
		;                       "Y"           ;隠線処理
		;                       "N"           ;ファイル書き出し
		;                       "N"           ;変更を保存
		;                       "Y"           ;印刷を続ける？
		                  );_list
		                  (if (= (getvar "TILEMODE") 0)
		                    (list ; ﾍﾟｰﾊﾟｰ空間
		                      "N"           ;印刷尺度を使用して線の太さを尺度変更?
		                      "N"           ;ﾍﾟｰﾊﾟｰ空間を最後に印刷?
		                      "Y"           ;隠線処理
		                      "N"           ;ファイル書き出し
		                      "N"           ;変更を保存
		                      "Y"           ;印刷を続ける？
		                    )
		                    (list ; MODEL空間
		                      "Y"           ;隠線処理
		                      "N"           ;ファイル書き出し
		                      "N"           ;変更を保存
		                      "Y"           ;印刷を続ける？
		                    )
		                  );_if

		                  ; 01/04/10 HN S-ADD 画層"0_HIDE"の表示処理を追加
		                  (list
		                    "_.-LAYER"
		                    "ON"
		                    "O_HIDE"
		                    ""
		                  )
		                  ; 01/04/10 HN E-ADD 画層"0_HIDE"の表示処理を追加

		                );_append
		                ;01/03/06 KS E-MOD パース対応
		              );_CFScriptCommand
								)
							);_cond
							; 01/09/07 YM MOD-S 自動ﾓｰﾄﾞでscript不可

            )
          );_if
        )
      );_if

  ; 01/04/08 HN S-DEL
  ; スクリプト処理の後処理は不可
  ;DEL; 119 01/04/08 HN S-ADD 画層"0_HIDE"の非表示処理を追加
  ;DEL(if #eLayer
  ;DEL  (progn
  ;DEL    (entmod #eLayer$)
  ;DEL    (command ".REGEN")
  ;DEL  )
  ;DEL)
  ; 119 01/04/08 HN E-ADD 画層"0_HIDE"の非表示処理を追加
  ; 01/04/08 HN E-DEL

  (princ)
)
;C:PlainPlot

;;;<HOM>************************************************************************
;;; <関数名>  : WebPDF_OUTPUT
;;; <処理概要>: PDF出力する
;;; <戻り値>  : なし
;;; <作成>    : 02/08/01 YM
;;; <備考>    : NAS WEB版対応 CG_AUTOMODE = 2 が前提
;;;************************************************************************>MOH<
(defun WebPDF_OUTPUT  (
  /
    #limmin
    #limmax
#AREA #CTB #DEVICE #EDIT #ELAYER #ELAYER$ #ILAYER #INI$$ #LAY #OFFX #OFFY #PAPER #RET$ #SCALE ;04/04/14 YM ADD
;;;	#AREA #CTB #DEVICE #EDIT #ELAYER #ELAYER$ #ILAYER #INI$$ #LAY #OFFX #OFFY #PAPER #RET$ #SCALE
  )

;★パース図★
;;;コマンド: -plot
;;;詳細な印刷環境設定? [はい(Y)/いいえ(N)] <いいえ>: y
;;;レイアウト名を入力 または [一覧(?)] <ﾚｲｱｳﾄ1>:
;;;出力デバイス名を入力 または [一覧(?)] <DWF ePlot.pc3>: ?
;;;使用可能な印刷デバイス。
;;;  "RICOH imagio Neo C600 RPCS"
;;;  "Microsoft XPS Document Writer"
;;;  "EPSON LP-7000C"
;;;  "Default Windows System Printer.pc3"
;;;  "DWF6 ePlot.pc3"
;;;  "DWFx ePlot (XPS Compatible).pc3"
;;;  "DWG To PDF.pc3"★
;;;  "PublishToWeb JPG.pc3"
;;;  "PublishToWeb PNG.pc3"
;;;出力デバイス名を入力 または [一覧(?)] <DWF ePlot.pc3>: DWG To PDF.pc3　★
;;;用紙サイズを入力 または [一覧(?)] <ISO A3 (420.00 x 297.00 ミリ)>:
;;;用紙単位を入力 [インチ(I)/ミリメートル(M)] <ミリメートル>: m
;;;図面の方向を入力 [縦(P)/横(L)] <横>: 'VLIDE 図面の方向を入力 [縦(P)/横(L)] <横>: 図面の方向を入力 [縦(P)/横(L)] <横>: l
;;;上下を逆にして印刷しますか? [はい(Y)/いいえ(N)] <いいえ>: n
;;;印刷領域を入力 [表示画面(D)/オブジェクト範囲(E)/レイアウト(L)/ビュー(V)/窓(W)] <オブジェクト範囲>:
;;;[表示画面(D)/オブジェクト範囲(E)/レイアウト(L)/ビュー(V)/窓(W)] <オブジェクト範囲>: e
;;;印刷尺度を入力 (印刷 ミリメートル=作図単位) または [フィット(F)] <1:1>:
;;;印刷オフセット(x,y)を入力 または [中心(C)] <中心>:
;;;印刷スタイルを使用して印刷しますか? [はい(Y)/いいえ(N)] <はい>: y
;;;印刷スタイル テーブル名を入力 または [一覧(?)] ( . = なし) <Kpcad.ctb>:
;;;線の太さを使用して印刷しますか? [はい(Y)/いいえ(N)] <はい>: 'VLIDE 線の太さを使用して印刷しますか? [はい(Y)/いいえ(N)] : y
;;;印刷尺度を使用して線の太さを尺度変更しますか? [はい(Y)/いいえ(N)] <いいえ>:  n
;;;ペーパー空間を最初に印刷しますか? [はい(Y)/いいえ(N)] <いいえ>: n
;;;ペーパー空間のオブジェクトを隠線処理しますか? [はい(Y)/いいえ(N)] <いいえ>: y
;;;ファイル名を入力 <C:\Layout\BUKKEN\OUTPUT\A3-01-1-立体_0_00-ﾚｲｱｳﾄ1.pdf>:
;;;ページ設定の変更を保存しますか [はい(Y)/いいえ(N)]? <N> n
;;;印刷を続けますか [はい(Y)/いいえ(N)] <Y>: y

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
  (setq #device   (cadr (assoc "DEVICE"  #ini$$)))  ;出力デバイス名
  (setq #edit     (cadr (assoc "EDIT"  #ini$$)))    ;エディタ名

  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;水平オフセット
  (if (= nil #offx)(setq #offx "0.0"))

  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;垂直オフセット
  (if (= nil #offy)(setq #offy "0.0"))



	;ﾊﾟｰｽ図用 2008/08/16 YM ADD
  (setq #Poffx     (cadr (assoc "POFFSETX" #ini$$)))  ;水平オフセット
  (if (= nil #Poffx)(setq #Poffx "0.0"))

  (setq #Poffy     (cadr (assoc "POFFSETY" #ini$$)))  ;垂直オフセット
  (if (= nil #Poffy)(setq #Poffy "0.0"))


  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;印刷スタイルファイル名

  ;// 簡易印刷ダイアログ
  (setq #ret$ CG_AUTOMODE_PRINT)

  (setq #paper (car #ret$))
  (setq #scale (cadr #ret$))
  ;00/06/20 SN S-MOD 用紙サイズの追加
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

;;;	(setq #scale "F")

  (cond
    ((= #scale "scale20")(setq #scale "1:20"))
    ((= #scale "scale30")(setq #scale "1:30"))
    ((= #scale "scale40")(setq #scale "1:40"))
    ((= #scale "scale1")(setq #scale "1:1"))
    (T (setq #scale "F"))
  );_cond

  (if (= 0 (getvar "TILEMODE"))
    (progn ;ﾍﾟｰﾊﾟｰ空間
          (setq #area "E");オブジェクト範囲(E)
;;;      (setq #area "L");図面範囲(L) 2008/08/16 \\circaでなぜか8/16に落ちるのでL==>Eにした
      (setq #lay  "ﾚｲｱｳﾄ1")
    )
    (progn ;ﾓﾃﾞﾙ空間

      (setq #area "E");オブジェクト範囲(E) 2008/08/16 L==>E
;;;      (setq #area "L");図面範囲(L)

;;;      (if (= #scale "F")
;;;				(progn
;;;          (setq #area "E");オブジェクト範囲(E)
;;;;;;          (setq #area "L");図面範囲(L)
;;;			    (setq #offx "0.0")
;;;					(setq #offy "0.0")
;;;				)
;;;      );_if

      (setq #lay  "モデル")
    )
  );_if

	; PLOTｺﾏﾝﾄﾞ実行(PDF出力用)
	(if (= (getvar "TILEMODE") 0)
		(progn ; ﾍﾟｰﾊﾟｰ空間 PDFをﾃﾞｽｸﾄｯﾌﾟに出力 『ﾊﾟｰｽ図』
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
         (strcat #Poffx "," #Poffy)   ;印刷オフセット
         "Y"           ;印刷スタイル利用？
         #ctb          ;印刷スタイル名
         "Y"           ;線の太さを使用？
         "N"           ;印刷尺度を使用して線の太さを尺度変更?
         "N"           ;ﾍﾟｰﾊﾟｰ空間を最後に印刷?
         "Y"           ;隠線処理
         CG_PDF_FILENAME  ;★ファイル名を入力 <C:\Layout\BUKKEN\OUTPUT\A3-01-1-立体_0_00-ﾚｲｱｳﾄ1.pdf>:
         "N"           ;ページ設定の変更を保存しますか
         "Y"           ;印刷を続けますか
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
         "H"           ;隠線処理
         CG_PDF_FILENAME  ;★ファイル名を入力 <C:\Layout\BUKKEN\OUTPUT\A3-01-1-立体_0_00-ﾚｲｱｳﾄ1.pdf>:
         "N"           ;変更を保存
         "Y"           ;印刷を続ける？
      );_command "_.-PLOT"

		) ; ﾓﾃﾞﾙ空間
	);_if
  (princ)
);WebPDF_OUTPUT

;;;<HOM>************************************************************************
;;; <関数名>  : WebTIFF_OUTPUT
;;; <処理概要>: TIFF出力する
;;; <戻り値>  : なし
;;; <作成>    : 02/08/02 YM
;;; <備考>    : NAS WEB版対応 ﾊﾟｰｽ図を表示していることが前提
;;;************************************************************************>MOH<
(defun WebTIFF_OUTPUT  (
  /
	#AREA #CTB #DEVICE #INI$$ #LAY #OFFX #OFFY #PAPER #SCALE
  )
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE2"  #ini$$))) ;出力デバイス名
  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;水平オフセット
  (if (= nil #offx)(setq #offx "0.0"))
  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;垂直オフセット
  (if (= nil #offy)(setq #offy "0.0"))

	; 03/02/25 YM MOD-S WEB版だけペンの太さを太く
  (setq #ctb      (cadr (assoc "CTB2"    #ini$$)))  ;印刷スタイルファイル名
	(if (= nil #ctb)(setq #ctb (cadr (assoc "CTB" #ini$$))))
	; 03/02/25 YM MOD-E WEB版だけペンの太さを太く
;;;  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;印刷スタイルファイル名

  (setq #paper    (cadr (assoc "SIZE"    #ini$$)))  ;ピクセル
	(setq #scale "F")
  (setq #area  "E") ; ｵﾌﾞｼﾞｪｸﾄ範囲 03/02/19 YM MOD
;;;  (setq #area  "D") ; 図面範囲 03/02/19 YM MOD

  (if (= 0 (getvar "TILEMODE")) ; 03/02/22 YM ADD
		(progn
		  (setq #lay  "ﾚｲｱｳﾄ1") ; 03/02/22 YM ADD
		)
		(progn
			(setq #lay  "Model")
		)
	);_if

  ;;S-ADD by K.S 2002/08/05
	(setvar "DISPSILH" 1)                     ;シルエットON

	; ｽﾞｰﾑ,向き調整済み 03/02/22 YM DEL-S
;;;03/02/22YM@DEL	(command "_.ZOOM" "E")
;;;03/02/22YM@DEL;;;  (command "_.VPOINT" "R" "" 8)
;;;03/02/22YM@DEL
;;;03/02/22YM@DEL	(if (= CG_LRCode "R") ; 03/02/19 YM ADD
;;;03/02/22YM@DEL		(progn ; 右勝手のとき
;;;03/02/22YM@DEL		  (command "_.VPOINT" "R" "300" 7)
;;;03/02/22YM@DEL		)
;;;03/02/22YM@DEL		(progn ; 左勝手のとき
;;;03/02/22YM@DEL		  (command "_.VPOINT" "R" "240" 7)
;;;03/02/22YM@DEL		)
;;;03/02/22YM@DEL	);_if
;;;03/02/22YM@DEL
;;;03/02/22YM@DEL	(command "_.DVIEW" "ALL" "" "D" 7500 "X") ;パース図に切り替え
  ;;E-ADD by K.S 2002/08/05
	
	; PLOTｺﾏﾝﾄﾞ実行(TIFF出力用)
  (command "_.-PLOT"
     "Y"           ;詳細な印刷環境設定
     #lay          ;ﾚｲｱｳﾄ名を入力 <ﾚｲｱｳﾄ1>:
     #device       ;出力デバイス名を入力 <Independent JPEG Group JFIF (JPEG 圧縮).pc3>:
     #paper        ;用紙ｻｲｽﾞを入力 <Super VGA (600.00 x 800.00 ﾋﾟｸｾﾙ)>:
     "L"           ;図面の方向を入力 [縦(P)/横(L)] <横>:
     "N"           ;上下を逆にして印刷しますか? [はい(Y)/いいえ(N)] <No>:
     #area         ;印刷領域を入力 [表示画面(D)/ｵﾌﾞｼﾞｪｸﾄ範囲(E)/ﾚｲｱｳﾄ(L)/ﾋﾞｭｰ(V)/窓(W)] <ｵﾌﾞｼﾞｪｸﾄ範囲>:
     #scale        ;印刷尺度を入力 (印刷 ﾋﾟｸｾﾙ=作図単位) または [ﾌｨｯﾄ(F)] <1:1>:
     (strcat #offx "," #offy)   ;印刷ｵﾌｾｯﾄ(x,y)を入力 または [中心(C)] <Center>: 0,0
     "Y"           ;印刷ｽﾀｲﾙを使用して印刷しますか? [はい(Y)/いいえ(N)] <Yes>:
     #ctb          ;印刷ｽﾀｲﾙ ﾃｰﾌﾞﾙ名を入力 または [一覧(?)] ( . = なし) <Kpcad.ctb>:
     "Y"           ;線の太さを使用して印刷しますか? [はい(Y)/いいえ(N)] <Yes>:
     "N"           ;印刷尺度を使用して線の太さを尺度変更? [はい(Y)/いいえ(N)] <No>:
     "N"           ;ﾍﾟｰﾊﾟｰ空間を最後に印刷? [はい(Y)/いいえ(N)] <No>:
     "Y"           ;隠線を処理しますか? [はい(Y)/いいえ(N)] <No>: y
;;;		(strcat CG_PDFOUTPUTPATH CG_BukkenNo "_DRW1.Tif")
		(strcat CG_PDFOUTPUTPATH CG_BukkenNo "_DRW1")
     "N"           ;ﾚｲｱｳﾄの変更を保存しますか [はい(Y)/いいえ(N)]? <N>
     "Y"           ;印刷を続けますか [はい(Y)/いいえ(N)] <Y>:
  );_command "_.-PLOT"

  (princ)
);WebTIFF_OUTPUT


;;;<HOM>************************************************************************
;;; <関数名>  : WebJPG_OUTPUT
;;; <処理概要>: JPG出力する
;;; <戻り値>  : なし
;;; <作成>    : 04/09/13 YM
;;; <備考>    : NAS ﾌﾟﾗﾝﾆﾝｸﾞｼｰﾄ時にJPG出力
;;;************************************************************************>MOH<
(defun WebJPG_OUTPUT  (
  /
	#AREA #CTB #DEVICE #INI$$ #LAY #OFFX #OFFY #OUTPUT #PAPER #SCALE
  )
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE2"  #ini$$))) ;出力デバイス名
  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;水平オフセット
  (if (= nil #offx)(setq #offx "0.0"))
  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;垂直オフセット
  (if (= nil #offy)(setq #offy "0.0"))

	; 03/02/25 YM MOD-S WEB版だけペンの太さを太く
  (setq #ctb      (cadr (assoc "CTB2"    #ini$$)))  ;印刷スタイルファイル名
	(if (= nil #ctb)(setq #ctb (cadr (assoc "CTB" #ini$$))))
	; 03/02/25 YM MOD-E WEB版だけペンの太さを太く
;;;  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;印刷スタイルファイル名

  (setq #paper    (cadr (assoc "SIZE"    #ini$$)))  ;ピクセル
	(setq #scale "F")
  (setq #area  "E") ; ｵﾌﾞｼﾞｪｸﾄ範囲 03/02/19 YM MOD
;;;  (setq #area  "D") ; 図面範囲 03/02/19 YM MOD

  (if (= 0 (getvar "TILEMODE")) ; 03/02/22 YM ADD
		(progn
		  (setq #lay  "ﾚｲｱｳﾄ1") ; 03/02/22 YM ADD
		)
		(progn
			(setq #lay  "Model")
		)
	);_if

  ;;S-ADD by K.S 2002/08/05
	(setvar "DISPSILH" 1)                     ;シルエットON

	(setq #output (strcat CG_KENMEI_PATH "BLOCK" "\\PERS.jpg"))
	(if (findfile #output)(vl-file-delete #output))

	(if #output
		(progn
			; PLOTｺﾏﾝﾄﾞ実行(TIFF出力用)
		  (command "_.-PLOT"
		     "Y"           ;詳細な印刷環境設定
		     #lay          ;ﾚｲｱｳﾄ名を入力 <ﾚｲｱｳﾄ1>:
		     #device       ;出力デバイス名を入力 <Independent JPEG Group JFIF (JPEG 圧縮).pc3>:
		     #paper        ;用紙ｻｲｽﾞを入力 <Super VGA (600.00 x 800.00 ﾋﾟｸｾﾙ)>:
		     "L"           ;図面の方向を入力 [縦(P)/横(L)] <横>:
		     "N"           ;上下を逆にして印刷しますか? [はい(Y)/いいえ(N)] <No>:
		     #area         ;印刷領域を入力 [表示画面(D)/ｵﾌﾞｼﾞｪｸﾄ範囲(E)/ﾚｲｱｳﾄ(L)/ﾋﾞｭｰ(V)/窓(W)] <ｵﾌﾞｼﾞｪｸﾄ範囲>:
		     #scale        ;印刷尺度を入力 (印刷 ﾋﾟｸｾﾙ=作図単位) または [ﾌｨｯﾄ(F)] <1:1>:
		     (strcat #offx "," #offy)   ;印刷ｵﾌｾｯﾄ(x,y)を入力 または [中心(C)] <Center>: 0,0
		     "Y"           ;印刷ｽﾀｲﾙを使用して印刷しますか? [はい(Y)/いいえ(N)] <Yes>:
		     #ctb          ;印刷ｽﾀｲﾙ ﾃｰﾌﾞﾙ名を入力 または [一覧(?)] ( . = なし) <Kpcad.ctb>:
		     "Y"           ;線の太さを使用して印刷しますか? [はい(Y)/いいえ(N)] <Yes>:
		     "N"           ;印刷尺度を使用して線の太さを尺度変更? [はい(Y)/いいえ(N)] <No>:
		     "N"           ;ﾍﾟｰﾊﾟｰ空間を最後に印刷? [はい(Y)/いいえ(N)] <No>:
		     "Y"           ;隠線を処理しますか? [はい(Y)/いいえ(N)] <No>: y
				#output
		     "N"           ;ﾚｲｱｳﾄの変更を保存しますか [はい(Y)/いいえ(N)]? <N>
		     "Y"           ;印刷を続けますか [はい(Y)/いいえ(N)] <Y>:
		  );_command "_.-PLOT"
		)
	);_if

  (princ)
);WebJPG_OUTPUT


;<HOM>*************************************************************************
; <関数名>    : SCPlainPlotDlg
; <処理概要>  : 簡易出力コマンドダイアログ
; <戻り値>    :
; <作成>      : 1999-10-12
; <備考>      :
;*************************************************************************>MOH<
(defun SCPlainPlotDlg (
    &device          ;(STR)出力デバイス名
    /
    #dcl_id
  )
  (defun PlainPlotDlgOK ()
    (list
      (get_tile "paper")
      (get_tile "scale")
    )
  )
  ;// 用紙サイズの判定
  (setq #lm (getvar "LIMMAX"))

  (setq #dcl_id (eval (load_dialog (strcat CG_DCLPATH "KCPLOT.dcl"))))
  (new_dialog "SCPlotDlg" #dcl_id)

  ;00/06/20 SN S-MOD 用紙サイズ・縮尺の初期値を自動定
  (cond
    ((<= (car #lm) 297) ;A4-1-1
      (set_tile "paperA4" "1")
      (set_tile "scale1" "1")
;      (set_tile "scaleauto" "1")
    )
    ((<= (car #lm) 420) ;A3-1-1
      (set_tile "paperA3" "1")
      (set_tile "scale1" "1")
;      (set_tile "scaleauto" "1")
    )
    ((<= (car #lm) 594) ;A2-1-1
      (set_tile "paperA2" "1")
      (set_tile "scale1" "1")
    )
    ((<= (car #lm) 7280) ;B4-20-1
      (set_tile "paperB4" "1")
      (set_tile "scale20" "1")
    )
    ((<= (car #lm) 8400) ;A3-20-1
      (set_tile "paperA3" "1")
      (set_tile "scale20" "1")
    )
    ((<= (car #lm) 8910) ;A4-30-1
;      (set_tile "paperA3" "1")	 ;01/03/06 KS MOD
      (set_tile "paperA4" "1")
      (set_tile "scale30" "1")
    )
    ((<= (car #lm) 10920) ;B4-30-1
      (set_tile "paperB4" "1")
      (set_tile "scale30" "1")
    )
    ((<= (car #lm) 11880) ;A2-20-1
      (set_tile "paperA2" "1")
      (set_tile "scale20" "1")
    )
    ((<= (car #lm) 11880) ;A4-40-1
      (set_tile "paperA4" "1")
      (set_tile "scale40" "1")
    )
    ((<= (car #lm) 12600) ;A3-30-1
      (set_tile "paperA3" "1")
      (set_tile "scale30" "1")
    )
    ((<= (car #lm) 14400) ;B4-40-1
      (set_tile "paperB4" "1")
      (set_tile "scale40" "1")
    )
    ((<= (car #lm) 16800) ;A3-40-1
      (set_tile "paperA3" "1")
      (set_tile "scale40" "1")
    )
    ((<= (car #lm) 17820) ;A2-30-1
      (set_tile "paperA2" "1")
      (set_tile "scale30" "1")
    )
    (T
      (set_tile "paperA2" "1")
      (set_tile "scaleauto" "1")
    )
  )
  ;(if (< (car #lm) 9000)
  ;  (progn
  ;    (set_tile "paperA4" "1")
  ;  )
  ;;else
  ;  (progn
  ;    (set_tile "paperA3" "1")
  ;  )
  ;)
  ;(set_tile "scale30" "1")
  ;00/06/20 SN E-MOD
  (set_tile "dev" (strcat "出力デバイス: " &device))
  (action_tile "accept" "(setq #ret$ (PlainPlotDlgOK)) (done_dialog)")
  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
  (action_tile "setting" "(PlainPlotDlgSet)")
  (start_dialog)
  (unload_dialog #dcl_id)

  #ret$
)

;00/07/05 SN ADD ﾌﾟﾘﾝﾀ設定ﾎﾞﾀﾝ押下時の処理
; #ini$$, #device, #edit, #scale, #ctb
; はC:PlainPlotの変数
(defun PlainPlotDlgSet()
  ;(setq #ret (startapp (strcat &edit CG_SYSPATH "SCPLOT.CFG" ) ""))
  ;(if (not #ret )
  ;  (CFAlertErr (strcat CG_SYSPATH "SCPLOT.CFG" "が開けません"))
  ;)
  (c:arxStartApp (strcat #edit " " CG_SYSPATH "SCPLOT.CFG") 1)
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE"  #ini$$)))  ;出力デバイス名
  (setq #edit     (cadr (assoc "EDIT"  #ini$$)))    ;エディタ名
  (setq #scale    (cadr (assoc "SCALE"   #ini$$)))  ;縮尺
  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;印刷スタイルファイル名
  (set_tile "dev" (strcat "出力デバイス: " #device))
)

(princ)
