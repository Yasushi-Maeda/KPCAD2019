;;;<HOM>************************************************************************
;;; <関数名>  : LOADLOAD
;;; <処理概要>: load.lsp　を関数化した
;;; <戻り値>  : 2008/07/03 YM ADD
;;; <備考>    : なし
;;;************************************************************************>MOH<
(defun LOADLOAD (
  /
  )
	(princ (strcat "\n★★★　LOADLOAD　ＳＴＡＲＴ　★★★"))

;06/06/14 AO 製品版、OEM版の両方でFASをロードする
;06/06/14 AO DEL (if (= "ACAD" CG_PROGRAM)
;06/06/14 AO DEL   (setq CG_LOAD_EXT ".LSP")
;06/06/14 AO DEL   ;else
;06/06/14 AO DEL   (setq CG_LOAD_EXT ".FAS")
;06/06/14 AO DEL )

;06/06/14 AO ADD ロードするファイル名より拡張子を削除 ⇒ fasをロード
(setq CG_LOAD_EXT "")
;06/06/14 AO MOD 以降 CG_LOAD_EXT(拡張子)は空文字となり,FASをロードする

;@@@(princ "\nload.fas をﾛｰﾄﾞ中...\n")
(load (strcat CG_LISPPATH "WKP_KCCMN"        CG_LOAD_EXT))  ;共通ファイル
;プラン検索
(load (strcat CG_LISPPATH "WKP_KCSRCPLN"     CG_LOAD_EXT))
;ワークトップ関連
(load (strcat CG_LISPPATH "WKP_KCWKTOPZ"     CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCWKTOPZ2"    CG_LOAD_EXT))  ;ワークトップ品番確定
(load (strcat CG_LISPPATH "WKP_KCWTGP"       CG_LOAD_EXT))  ;ワークトップ平面図作成 new
(load (strcat CG_LISPPATH "WKP_KCLOSNK"      CG_LOAD_EXT))  ;シンク関連
(load (strcat CG_LISPPATH "WKP_KCSIDE"       CG_LOAD_EXT))  ;サイドパネル関連
(load (strcat CG_LISPPATH "WKP_KCDOOR"       CG_LOAD_EXT))  ;扉面関連
(load (strcat CG_LISPPATH "WKP_KCSELECT"     CG_LOAD_EXT))  ;商品選択
(load (strcat CG_LISPPATH "WKP_KCBALOON"     CG_LOAD_EXT))  ;仕様表番号関連
(load (strcat CG_LISPPATH "WKP_KCMRR"        CG_LOAD_EXT))  ;ミラー反転
(load (strcat CG_LISPPATH "WKP_KCSTRCH"      CG_LOAD_EXT))  ;伸縮関連
(load (strcat CG_LISPPATH "WKP_KCMKFLR"      CG_LOAD_EXT))  ;天井フィラー関連
(load (strcat CG_LISPPATH "WKP_KCCHECK"      CG_LOAD_EXT))  ;配置チェック関連
(load (strcat CG_LISPPATH "WKP_KCKUTAI"      CG_LOAD_EXT))  ;躯体関連 00/12/04 SN ADD
;設備配置・編集関連
(load (strcat CG_LISPPATH "WKP_KCPARTS"      CG_LOAD_EXT))  ;設備配置関連
(load (strcat CG_LISPPATH "WKP_KCCNFPTS"     CG_LOAD_EXT))  ;設備配置関連
(load (strcat CG_LISPPATH "WKP_KCDELPTS"     CG_LOAD_EXT))  ;設備配置関連
(load (strcat CG_LISPPATH "WKP_KCSUBPTS"     CG_LOAD_EXT))  ;補足部材
(load (strcat CG_LISPPATH "WKP_KCEDPTS"      CG_LOAD_EXT))  ;設備編集
(load (strcat CG_LISPPATH "WKP_KCEDCMN"      CG_LOAD_EXT))  ;設備編集共通
;印刷関連
(load (strcat CG_LISPPATH "WKP_KCFCmn"       CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCFDimM"      CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCFDimS"      CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCFdm"        CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCFdyasi"     CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCFmat"       CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCFmktmp"     CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCFop"        CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCFsyasi"     CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCMITUMO"     CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCFlay"       CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCFDiv"       CG_LOAD_EXT))  ;00/03/12 HN ADD
(load (strcat CG_LISPPATH "WKP_KCFDimH"      CG_LOAD_EXT))  ;00/03/12 HN ADD
(load (strcat CG_LISPPATH "WKP_KCPlot"       CG_LOAD_EXT))  ;00/06/20 SN ADD
(load (strcat CG_LISPPATH "WKP_KCFsyasiE"    CG_LOAD_EXT))  ;00/10/16 HT ADD
;バス関連
(load (strcat CG_LISPPATH "WKP_KBSRCPLN"     CG_LOAD_EXT))  ;バスプラン検索
(load (strcat CG_LISPPATH "WKP_KBTABLE"      CG_LOAD_EXT))  ;仕様表関連
(load (strcat CG_LISPPATH "WKP_KBDINSID"     CG_LOAD_EXT))  ;
(load (strcat CG_LISPPATH "WKP_KBDDRAIN"     CG_LOAD_EXT))  ;
(load (strcat CG_LISPPATH "WKP_KBDIM"        CG_LOAD_EXT))  ;
(load (strcat CG_LISPPATH "WKP_KBCMN"        CG_LOAD_EXT))  ;バス共通
;その他
(load (strcat CG_LISPPATH "WKP_KCVIEW2"      CG_LOAD_EXT))  ;ビューポート操作関連 MOD 00/02/14 YM
;メーカー独自 01/10/09 YM ADD
(load (strcat CG_LISPPATH "WKP_KCEXTEND"     CG_LOAD_EXT))
;現在不使用
;@DEL@(load (strcat CG_LISPPATH "KCMAIN.fas"))     ;メイン  01/08/09 HN DEL
;@DEL@(load (strcat CG_LISPPATH "KCPANEL.fas"))    ;インテリアパネル関連  01/08/17 HN DEL
;@DEL@(load (strcat CG_LISPPATH "KCEXP.fas"))      ;伸縮処理  01/08/17 YM DEL
;@DEL@(load (strcat CG_LISPPATH "KCHanger.fas"))   ;ハンガー関連    00/03/12 HM ADD  01/08/19 HN DEL
;@DEL@(load (strcat CG_LISPPATH "KCRange.fas"))    ;レンジフード関連    00/05/21 HM ADD
;@DEL@(load (strcat CG_LISPPATH "KCFDisp.fas"))    ;00/05/03 HN ADD 03/09/29 YM DEL

	(princ (strcat "\n★★★　LOADLOAD　ＥＮＤ　★★★"))

);LOADLOAD

(princ)