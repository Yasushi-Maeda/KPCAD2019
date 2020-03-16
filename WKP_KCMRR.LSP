;;;<HOM>*************************************************************************
;;; <関数名>    : C:MirrorCopyParts
;;; <処理概要>  : 反転コピーコマンド
;;; <戻り値>    :
;;; <作成日>    : 1999-06-14
;;; <備考>      : 00/02/18 YM lemon 2/9 反映
;;;*************************************************************************>MOH<
(defun C:MirrorCopyParts (
  /
  #DUMEN #EN$ #EN2$ #P1 #P2 #PP1 #PP2 #SS #SSFL #SSWT #PDS
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:MirrorCopyParts ////")
  (CFOutStateLog 1 1 " ")

;;; ビューを元に保存する
  (command "_view" "S" "TEMP_MRR")

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
      (defun TempErr ( msg / )
        (setq KEKOMI_COM nil) ; ｹｺﾐ伸縮中
        (setq KEKOMI_BRK nil)
        (setq CG_GAIKEI nil) ; 01/07/04 YM ADD
        (command "_undo" "b")
        (setq *error* nil)
        (princ)
      )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
  (setq *error* TempErr)
  (setq CG_GAIKEI nil) ; 01/07/04 YM ADD
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")

;;;  (StartUndoErr);00/08/25 SN ADD 最初に行う
  (CFCmdDefBegin 7);00/09/26 SN ADD

  (setvar "pdmode" 34)         ; 06/12 YM
  (setq #PDS (getvar "PDSIZE"))
  (setvar "pdsize" 20)

  (command "_.vpoint" (list 0 0 1))

  (setq #p1 (getpoint  "\n反転する領域の一点目: "))
  (setq #p2 (getcorner #p1 "\n反転する領域の二点目: "))
  (command "_.rectangle" #p1 #p2)
  (setq #dumEn (entlast))

  (setq #pp1 (getpoint "\n対称軸の一点目: "))
  (setq #pp2 (getpoint "\n対称軸の二点目: " #pp1))

  (entdel #dumEn)

  (CFNoSnapReset);00/08/25 SN ADD
  (CFNoSnapStart);00/08/25 SN ADD
  ;// ミラー反転処理 G_LSYM
;;;  (command "_.vpoint" (list 0 0 1))
  (setq #ss (ssget "C" #p1 #p2 '((-3 ("G_LSYM")))))  ; 窓選択
  (if (and #ss (> (sslength #ss) 0))
    (progn
      (setq #en$ (PCM_MirrorParts #ss #pp1 #pp2 nil)) ; LSYM反転

;;;06/08/16 YM MOD-S
;;;     (foreach #en #en$
;;;       (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
;;;         (setq #en2$ (cons #en #en2$)) ; ﾍﾞｰｽｷｬﾋﾞ
;;;       )
;;;     )
      (setq #en2$ #en$);性格ｺｰﾄﾞの制限をなくした
;;;06/08/16 YM MOD-E

      ;// 扉面の貼り付け
      (PCD_MakeViewAlignDoor #en2$ 3 nil)

;;;     ; 01/03/12 YM ADD 特注ｷｬﾋﾞと一般ｷｬﾋﾞを分ける
;;;     (setq #symTOKU$ nil #symNORMAL$ nil)
;;;     (foreach en #en2$
;;;       (if (and (setq #TOKU$ (CFGetXData en "G_TOKU"))
;;;                (= (nth 3 #TOKU$) 1))
;;;         (setq #symTOKU$ (append #symTOKU$ (list en))) ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞを使用
;;;         (setq #symNORMAL$ (append #symNORMAL$ (list en)))
;;;       );_if
;;;     )
;;;     ; 特注ｷｬﾋﾞ扉貼りつけは、特注ｷｬﾋﾞｺﾏﾝﾄﾞ時と同じ条件にして
;;;     ; PCD_MakeViewAlignDoorに渡す(ﾌﾞﾚｰｸﾗｲﾝを一時追加)
;;;     ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ実行中ﾌﾗｸﾞを立てる (CG_TOKU) 01/03/12 YM ADD
;;;     (setq CG_TOKU T CG_OUTCMDNAME nil) ; 特注ｷｬﾋﾞ実行中
;;;     (foreach #symTOKU #symTOKU$
;;;       (setq #TOKU$ (CFGetXData #symTOKU "G_TOKU"))
;;;       (setq CG_TOKU_BW (nth 4 #TOKU$)) ; ﾌﾞﾚｰｸﾗｲﾝ位置
;;;       (setq CG_TOKU_BD (nth 5 #TOKU$)) ; ﾌﾞﾚｰｸﾗｲﾝ位置
;;;       (setq CG_TOKU_BH (nth 6 #TOKU$)) ; ﾌﾞﾚｰｸﾗｲﾝ位置
;;;       ;// 扉面の貼り付け
;;;       (PCD_MakeViewAlignDoor (list #symTOKU) 3 T)
;;;       ; 01/03/12 YM ADD 特注ｷｬﾋﾞだけ2D-PMEN7にも張りつける
;;;       (setq CG_OUTCMDNAME "SCFMakeMaterial") ; 01/03/11 YM ADD 2D-PMEN7に画層"0_door"で扉を張るため
;;;       (PCD_MakeViewAlignDoor (list #symTOKU) 2 nil)
;;;       (setq CG_OUTCMDNAME nil)
;;;       (command "_layer" "OFF" "0_door" "") ; 画層 "0_door" 非表示
;;;     )
;;;     (setq CG_TOKU nil) ; 特注ｷｬﾋﾞ実行中
;;;
;;;      ;// 扉面の貼り付け(特注以外の場合)
;;;     (if #symNORMAL$
;;;       (PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
;;;     );_if

    )
  );_if

  ;// ワークトップの反転処理 00/06/02 YM
  (setq #ssWT (ssget "C" #p1 #p2 '((-3 ("G_WRKT")))))
  (if (and (/= #ssWT nil) (/= (sslength #ssWT) 0))
    (PKW_MirrorWorkTop #ssWT #pp1 #pp2 nil) ; 反転コピーnil 06/02 YM
  )
  ;// 天井フィラーの反転処理 00/06/02 YM
  (setq #ssFL (ssget "C" #p1 #p2 '((-3 ("G_FILR")))))
  (if (and (/= #ssFL nil) (/= (sslength #ssFL) 0))
    (PKW_MirrorFiler #ssFL #pp1 #pp2 nil)   ; 反転コピー専用 06/02 YM
  )
;;; (command "zoom" "p") ; 視点を元に戻す
  (princ "\n反転コピー完了しました.")

  (CFNoSnapFinish);00/08/25 SN ADD

  (setq *error* nil)
  (setvar "pdmode" 0) ; 06/12 YM
  (setvar "pdsize" #PDS)

  (command "_layer" "on" "M_*" "") ; 07/07 YM ADD(ﾐﾗｰ反転時"OF"になるものがある)
  (CFCmdDefFinish);00/09/26 SN ADD
;;; ビューを元に戻す
  (command "_view" "R" "TEMP_MRR")

  ;04/05/26 YM ADD
  (command "_REGEN")

  (princ)
)
;C:MirrorCopyParts

;;;<HOM>*************************************************************************
;;; <関数名>    : C:MirrorMoveParts
;;; <処理概要>  : 反転移動コマンド
;;; <戻り値>    :
;;; <作成日>    : 1999-06-14
;;; <備考>      :  00/02/18 YM lemon 2/9 反映
;;;*************************************************************************>MOH<
(defun C:MirrorMoveParts (
  /
  #DUMEN #EN$ #EN2$ #P1 #P2 #PDS #PP1 #PP2 #SS #SSFL #SSWT #HNDB #SSARW
  #SYMNORMAL$ #SYMTOKU$ #TOKU$
#I #SYM #TTOKUFLG ;2011/12/09 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:MirrorMoveParts ////")
  (CFOutStateLog 1 1 " ")

;;; ビューを元に保存する
  (command "_view" "S" "TEMP_MRR")

;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
      (defun TempErr ( msg / )
        (setq KEKOMI_COM nil) ; ｹｺﾐ伸縮中
        (setq KEKOMI_BRK nil)
        (setq CG_GAIKEI nil) ; 01/07/04 YM ADD
        (command "_undo" "b")
        (setq *error* nil)
        (princ)
      )
;;;EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
  (setq *error* TempErr)
  (setq CG_GAIKEI nil) ; 01/07/04 YM ADD
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")
;;;  (StartUndoErr); 00/08/25 SN MOD
  (CFCmdDefBegin 7);00/09/26 SN ADD

  (setvar "pdmode" 34)         ; 06/12 YM
  (setq #PDS (getvar "PDSIZE"))
  (setvar "pdsize" 20)

  (command "_.vpoint" (list 0 0 1))

  ;(princ "\n反転移動する設備部材を選択: ")
  (setq #p1 (getpoint  "\n反転する領域の一点目: "))
  (setq #p2 (getcorner #p1 "\n反転する領域の二点目: "))
  (command "_.rectangle" #p1 #p2)
  (setq #dumEn (entlast))

  (setq #pp1 (getpoint "\n対称軸の一点目: "))
  (setq #pp2 (getpoint "\n対称軸の二点目: " #pp1))

  (entdel #dumEn)

  (CFNoSnapReset);00/08/25 SN ADD
  (CFNoSnapStart);00/08/25 SN ADD
  ;// ミラー反転処理
;;;  (command "_.vpoint" (list 0 0 1))
  (setq #ss    (ssget "C" #p1 #p2 '((-3 ("G_LSYM")))))
  (setq #ssARW (ssget "C" #p1 #p2 '((-3 ("G_ARW" )))))  ; 窓選択"G_ARW
  (if #ssARW ; 反転移動時は矢印を消す,基準ｱｲﾃﾑは消す 07/18 YM
    (if (> (sslength #ssARW) 0)
      (progn
        (if (CFGetXRecord "BASESYM")
          (CFSetXRecord "BASESYM" nil) ; 基準ｱｲﾃﾑ登録を削除
        );_if
        (command "_erase" #ssARW "")
      )
    );_if
  );_if

  (if (and #ss (> (sslength #ss) 0))
    (progn
			;2011/12/09 YM ADD-S
			; 特注ｷｬﾋﾞがあれば反転移動させない
			(setq #i 0)
			(setq #tTOKUflg nil)  ; 特注ｷｬﾋﾞを含んでいる-->ｺﾏﾝﾄﾞ中止
			(repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        (if (CFGetXData #sym "G_TOKU")
          (setq #tTOKUflg T)  ; 特注ｷｬﾋﾞを含んでいる-->ｺﾏﾝﾄﾞ中止
				);_if
				(setq #i (1+ #i))
			)
			(if #tTOKUflg
				(progn
					(CFAlertMsg "\n特注ｷｬﾋﾞが存在するので反転移動はできません")
					(quit)
				)
			);_if
			;2011/12/09 YM ADD-E

      (setq #en$ (PCM_MirrorParts #ss #pp1 #pp2 T)) ; LSYM反転

;;;06/08/16 YM MOD-S
;;;     (foreach #en #en$
;;;       (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
;;;         (setq #en2$ (cons #en #en2$))
;;;       )
;;;     )
      (setq #en2$ #en$);性格ｺｰﾄﾞの制限をなくした
;;;06/08/16 YM MOD-E

      ;// 扉面の貼り付け
      (PCD_MakeViewAlignDoor #en2$ 3 nil)

;;;     ; 01/03/12 YM ADD 特注ｷｬﾋﾞと一般ｷｬﾋﾞを分ける
;;;     (setq #symTOKU$ nil #symNORMAL$ nil)
;;;     (foreach en #en2$
;;;       (if (and (setq #TOKU$ (CFGetXData en "G_TOKU"))
;;;                (= (nth 3 #TOKU$) 1))
;;;         (setq #symTOKU$ (append #symTOKU$ (list en))) ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞを使用
;;;         (setq #symNORMAL$ (append #symNORMAL$ (list en)))
;;;       );_if
;;;     )
;;;     ; 特注ｷｬﾋﾞ扉貼りつけは、特注ｷｬﾋﾞｺﾏﾝﾄﾞ時と同じ条件にして
;;;     ; PCD_MakeViewAlignDoorに渡す(ﾌﾞﾚｰｸﾗｲﾝを一時追加)
;;;     ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ実行中ﾌﾗｸﾞを立てる (CG_TOKU) 01/03/12 YM ADD
;;;     (setq CG_TOKU T CG_OUTCMDNAME nil) ; 特注ｷｬﾋﾞ実行中
;;;     (foreach #symTOKU #symTOKU$
;;;       (setq #TOKU$ (CFGetXData #symTOKU "G_TOKU"))
;;;       (setq CG_TOKU_BW (nth 4 #TOKU$)) ; ﾌﾞﾚｰｸﾗｲﾝ位置
;;;       (setq CG_TOKU_BD (nth 5 #TOKU$)) ; ﾌﾞﾚｰｸﾗｲﾝ位置
;;;       (setq CG_TOKU_BH (nth 6 #TOKU$)) ; ﾌﾞﾚｰｸﾗｲﾝ位置
;;;       ;// 扉面の貼り付け
;;;       (PCD_MakeViewAlignDoor (list #symTOKU) 3 T)
;;;       ; 01/03/12 YM ADD 特注ｷｬﾋﾞだけ2D-PMEN7にも張りつける
;;;       (setq CG_OUTCMDNAME "SCFMakeMaterial") ; 01/03/11 YM ADD 2D-PMEN7に画層"0_door"で扉を張るため
;;;       (PCD_MakeViewAlignDoor (list #symTOKU) 2 nil)
;;;       (setq CG_OUTCMDNAME nil)
;;;       (command "_layer" "OFF" "0_door" "") ; 画層 "0_door" 非表示
;;;     )
;;;     (setq CG_TOKU nil) ; 特注ｷｬﾋﾞ実行中
;;;
;;;      ;// 扉面の貼り付け(特注以外の場合)
;;;     (if #symNORMAL$
;;;       (PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
;;;     );_if

    )
  );_if

  ;// ワークトップの反転処理 00/06/02 YM
  (command "_.vpoint" (list 0 0 1))
  (setq #ssWT (ssget "C" #p1 #p2 '((-3 ("G_WRKT")))))
  (if (and (/= #ssWT nil) (/= (sslength #ssWT) 0))
    (PKW_MirrorWorkTop #ssWT #pp1 #pp2 T)   ; 反転移動 T 06/02 YM
  )
  ;// 天井フィラーの反転処理 00/06/02 YM
  (setq #ssFL (ssget "C" #p1 #p2 '((-3 ("G_FILR")))))
  (if (and (/= #ssFL nil) (/= (sslength #ssFL) 0))
    (PKW_MirrorFiler #ssFL #pp1 #pp2 T) ; 反転移動専用 06/02 YM
  )
;;; (command "zoom" "p") ; 視点を元に戻す
  (princ "\n反転移動完了しました.")

  (CFNoSnapFinish);00/08/25 SN ADD

  (setq *error* nil)
  (setvar "pdmode" 0) ; 06/12 YM
  (setvar "pdsize" #PDS)
  (command "_layer" "on" "M_*" "") ; 07/07 YM ADD(ﾐﾗｰ反転時"OF"になるものがある)
  (CFCmdDefFinish);00/09/26 SN ADD

;;; ビューを元に戻す
  (command "_view" "R" "TEMP_MRR")

  ;04/05/26 YM ADD
  (command "_REGEN")

  (princ)
)
;C:MirrorMoveParts

;;;<HOM>*************************************************************************
;;; <関数名>    : sub_MirrorMove
;;; <処理概要>  : 反転移動(関数CALL用)
;;; <戻り値>    : なし
;;; <作成日>    : 03/04/28 YM
;;; <備考>      : 反転対象選択:(3600,0)～(0,-3600) 軸:(0,0)～(0,-3600)
;                 左上基点の部材を反転して右上基点にし、プラン保存するのに使用
;;;*************************************************************************>MOH<
(defun sub_MirrorMove (
  /
  #DUMEN #EN$ #EN2$ #P1 #P2 #PDS #PP1 #PP2 #SS #SSARW #SSFL #SSWT
  )
  (setvar "PICKSTYLE" 0)
  (setvar "CMDECHO" 0)
  (command "_undo" "M")
  (command "_undo" "a" "off")
  (CFCmdDefBegin 7);00/09/26 SN ADD
  (setvar "pdmode" 34)         ; 06/12 YM
  (setq #PDS (getvar "PDSIZE"))
  (setvar "pdsize" 20)
  (command "_.vpoint" (list 0 0 1)) ; 真上からの視点

;03/12/06 YM ADD ｻｲﾄﾞﾊﾟﾈﾙが伸縮しないので余裕を見る
(command "_zoom" "0.5x") ; 画面ぎりぎりだと一部図形がｽﾄﾚｯﾁできないようである

  ;反転対象部材を自動選択

;03/12/06 YM ADD ｻｲﾄﾞﾊﾟﾈﾙが伸縮しないので余裕を見る
  (setq #p1 '(500.0 500.0 0.0))
  (setq #p2 '(-2700.0 -1000.0 0.0))

;;;  (setq #p1 '(0.0 0.0 0.0))
;;;  (setq #p2 '(-3600.0 -3600.0 0.0))

  (command "_.rectangle" #p1 #p2)
  (setq #dumEn (entlast))

  ; 対象軸自動設定
  (setq #pp1 '(0.0 0.0 0.0))
  (setq #pp2 '(0.0 -1000.0 0.0))

  (entdel #dumEn)

  (CFNoSnapReset);00/08/25 SN ADD
  (CFNoSnapStart);00/08/25 SN ADD
  ;// ミラー反転処理
  (setq #ss    (ssget "C" #p1 #p2 '((-3 ("G_LSYM")))))
  (setq #ssARW (ssget "C" #p1 #p2 '((-3 ("G_ARW" )))))  ; 窓選択"G_ARW
  (if #ssARW ; 反転移動時は矢印を消す,基準ｱｲﾃﾑは消す 07/18 YM
    (if (> (sslength #ssARW) 0)
      (progn
        (if (CFGetXRecord "BASESYM")
          (CFSetXRecord "BASESYM" nil) ; 基準ｱｲﾃﾑ登録を削除
        );_if
        (command "_erase" #ssARW "")
      )
    );_if
  );_if

  (if (and #ss (> (sslength #ss) 0))
    (progn
      (setq #en$ (PCM_MirrorParts #ss #pp1 #pp2 T)) ; LSYM反転
      (foreach #en #en$
        (if (= CG_SKK_ONE_CAB (CFGetSymSKKCode #en 1))
          (setq #en2$ (cons #en #en2$))
        )
      )
      ;// 扉面の貼り付け
;;;     (PCD_MakeViewAlignDoor #en2$ 3 nil)
    )
  );_if

  ;// ワークトップの反転処理 00/06/02 YM
  (command "_.vpoint" (list 0 0 1))
  (setq #ssWT (ssget "C" #p1 #p2 '((-3 ("G_WRKT")))))
  (if (and (/= #ssWT nil) (/= (sslength #ssWT) 0))
    (PKW_MirrorWorkTop #ssWT #pp1 #pp2 T)   ; 反転移動 T 06/02 YM
  )

  ;// 天井フィラーの反転処理 00/06/02 YM
  (setq #ssFL (ssget "C" #p1 #p2 '((-3 ("G_FILR")))))
  (if (and (/= #ssFL nil) (/= (sslength #ssFL) 0))
    (PKW_MirrorFiler #ssFL #pp1 #pp2 T) ; 反転移動専用 06/02 YM
  )
  (princ "\n反転移動完了しました.")

  (CFNoSnapFinish);00/08/25 SN ADD

  (setq *error* nil)
  (setvar "pdmode" 0) ; 06/12 YM
  (setvar "pdsize" #PDS)
  (command "_layer" "on" "M_*" "") ; 07/07 YM ADD(ﾐﾗｰ反転時"OF"になるものがある)
  (CFCmdDefFinish);00/09/26 SN ADD
  ;南西等角図
;;; (SKChgView "-2,-2,1")
  (princ)
);sub_MirrorMove

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_ONEWTMrrCopy
;;; <処理概要>  : １つのWTをﾐﾗｰ反転ｺﾋﾟｰ"G_WRKT"左右ｶｯﾄWT=""をｾｯﾄ
;;; <戻り値>    : 反転ｺﾋﾟｰ後のWT図形名
;;; <作成日>    : 00/06/02 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PK_ONEWTMrrCopy (
  &wt          ;(PICKSET)ワークトップの選択セット
  &p1          ;(LIST)対称軸の一点目
  &p2          ;(LIST)対称軸の二点目
  &MRflg       ; &wtが一番右のWT==>T それ以外=nil
  /
  #BASEPT2 #BG1 #BG2 #BGTEI #DEP$ #ENWKTOP #FG #J
  #LEN$ #SETLR #SETLST$ #TEIWT #XD$ #XD_BG$ #ZAICode #ZaiF
  #BASEPT1 #CUT #CUTL #CUTR #DUMPT #PT$ #XD_WT$ #XD_WTSET$ #xd-opt$
  #SetCode #nMAG1 #nMAG2 #nMAG3
#HINBAN #STRLEN ; 03/01/28 YM ADD
  )

  (setq #xd$       (CFGetXData &wt "G_WRKT" ))        ; 元のﾜｰｸﾄｯﾌﾟ
  (setq #xd_WTSET$ (CFGetXData &wt "G_WTSET"))
  (setq #xd-opt$  (CFGetXData &wt "G_OPT")) ; 01/02/28 YM ADD

  (command "_mirror" &wt "" &p1 &p2 "N")              ;ﾜｰｸﾄｯﾌﾟﾐﾗｰ反転
  (setq #enWkTop (entlast))                           ;ﾐﾗｰ反転後ﾜｰｸﾄｯﾌﾟ図形名
  (command "_mirror" (nth 38 #xd$) "" &p1 &p2 "N")    ;ﾜｰｸﾄｯﾌﾟ底面図形ﾊﾝﾄﾞﾙ
  (setq #teiWT (entlast))                             ;ﾐﾗｰ反転後ﾜｰｸﾄｯﾌﾟ底面図形ﾊﾝﾄﾞﾙ

  (if &MRflg ; 一番右のWTのときのみ反転ｺﾋﾟｰする
    (progn
      (command "_mirror" (nth 59 #xd$) "" &p1 &p2 "N")   ;段差部含むﾜｰｸﾄｯﾌﾟ底面図形ﾊﾝﾄﾞﾙ
      (setq CG_GAIKEI (entlast))
    )
  );_if

  (if (/= (nth 49 #xd$) "") ; BG1
    (progn
      (command "_mirror" (nth 49 #xd$) "" &p1 &p2 "N") ;BG1図形ﾊﾝﾄﾞﾙ
      (setq #bg1 (entlast)) ; SOLID or 底面

      (if (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID")
        (progn ; SOLID の場合
          (setq #xd_BG$ (CFGetXData (nth 49 #xd$) "G_BKGD"))
          (command "_mirror" (nth 1 #xd_BG$) "" &p1 &p2 "N") ;BG1底面図形ﾊﾝﾄﾞﾙ
          (setq #bgtei (entlast))
          (CFSetXData #bg1 "G_BKGD"
            (CFModList #xd_BG$
              (list
                (list 1 #bgtei)
                (list 2 #enWkTop)
              )
            )
          )
        )
      );_if
    )
    (setq #bg1 "") ; SOLID or 底面
  );_if

  (if (/= (nth 50 #xd$) "") ; BG2
    (progn
      (command "_mirror" (nth 50 #xd$) "" &p1 &p2 "N") ;BG2図形ﾊﾝﾄﾞﾙ
      (setq #bg2 (entlast)) ; SOLID or 底面

      (if (= (cdr (assoc 0 (entget (nth 50 #xd$)))) "3DSOLID")
        (progn ; SOLID の場合
          (setq #xd_BG$ (CFGetXData (nth 50 #xd$) "G_BKGD"))
          (command "_mirror" (nth 1 #xd_BG$) "" &p1 &p2 "N") ;BG2底面図形ﾊﾝﾄﾞﾙ
          (setq #bgtei (entlast))
          (CFSetXData #bg2 "G_BKGD"
            (CFModList #xd_BG$
              (list
                (list 1 #bgtei)
                (list 2 #enWkTop)
              )
            )
          )
        )
      );_if
    )
    (setq #bg2 "") ; SOLID or 底面
  );_if

  ; 02/09/02 YM ADD R付きは前垂れ追加
  (if (/= (nth 51 #xd$) "")
    (progn
      (command "_mirror" (nth 51 #xd$) "" &p1 &p2 "N") ;FG底面図形ﾊﾝﾄﾞﾙ
      (setq #FG (entlast))
    )
  );_if

  ;;; 水栓穴
  (setq #setLst$ (list (list 22 (nth 22 #xd$))))   ;水栓穴 ﾃﾞｰﾀ数
  (setq #j 23)
  (repeat (nth 22 #xd$) ; 水栓穴個数回のﾙｰﾌﾟ =1
    (command "_mirror" (nth #j #xd$) "" &p1 &p2 "N")
    (setq #setLst$
      (append #setLst$ (list (list #j (entlast))))
    )
    (setq #j (1+ #j))
  )

  ;;; LR 区分 01/12/12 YM MOD ?勝手対応
  (cond
    ((= "R" (nth 30 #xd$))
      (setq #setLR "L")
    )
    ((= "L" (nth 30 #xd$))
      (setq #setLR "R")
    )
    (T
      (setq #setLR "?")
    )
  );_cond

  ;;; ｶｯﾄﾀｲﾌﾟ
  (setq #cut (nth 7 #xd$))
  (setq #cut (strcat (substr #cut 2 1)(substr #cut 1 1)))
;-- 2011/08/31 A.Satoh Del - S
;  ;;; ｶｯﾄ記号
;  (setq #cutL (nth 37 #xd$))
;  (setq #cutR (nth 36 #xd$))
;-- 2011/08/31 A.Satoh Del - E

  ;;; 間口1,2,3
  (cond
    ((= (nth 3 #xd$) 0)
      (setq #nMAG1 (nth 42 #xd$))
      (setq #nMAG2 (nth 43 #xd$))
      (setq #nMAG3 (nth 44 #xd$))
    )
    ((= (nth 3 #xd$) 1)
      (setq #nMAG1 (nth 43 #xd$))
      (setq #nMAG2 (nth 42 #xd$))
      (setq #nMAG3 (nth 44 #xd$))
    )
    ((= (nth 3 #xd$) 2)
      (setq #nMAG1 (nth 44 #xd$))
      (setq #nMAG2 (nth 43 #xd$))
      (setq #nMAG3 (nth 42 #xd$))
    )
  );_cond

  ;;; WT長さ
  (setq #LEN$ (nth 55 #xd$)) ; そのまま ｽﾃﾝﾚｽL==>650,650長辺先 750先 その他長辺先
  (setq #DEP$ (nth 57 #xd$)) ; そのまま
  ;;; 奥行き値の反転
  (setq #ZAICode (nth 2 #xd$))
  (setq #ZaiF (KCGetZaiF #ZAICode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ

  (setq #basePt1 (nth 32 #xd$)) ; WT左上点
  (command "_point" #basePt1)   ;ﾀﾞﾐｰﾎﾟｲﾝﾄ作成
  (command "_mirror" (entlast) "" &p1 &p2 "Y")
  (setq #dumPt (cdr (assoc 10 (entget (entlast))))) ; ﾎﾟｲﾝﾄ座標 WT右
  (entdel (entlast))            ;ﾀﾞﾐｰﾎﾟｲﾝﾄ削除

  (setq #pt$ (GetLWPolyLinePt #teiWT)) ; WT底面外形点列

  (if (and (not (equal (KPGetSinaType) -1 0.1))(= #ZaiF 1)(= (nth 3 #xd$) 1) ; ｽﾃﾝL型
           (= 6 (length #pt$))) ; ｽﾃﾝL型 01/08/29 YM ADD ｽﾃﾝﾚｽL型段差で分離したI形状WT対応
    (setq #basePt2 #dumPt) ; 新WT左上点
    (progn
      ;;; 反転後の配置点など情報獲得用ダミー点のミラー
;;;01/08/29YM@MOVE      (setq #pt$ (GetLWPolyLinePt #teiWT)) ; WT底面外形点列
      (setq #pt$ (GetPtSeries #dumPt #pt$)) ; 点列内の#dumPtを先頭に時計周りにする
      (setq #basePt2 (last #pt$))  ; 新WT左上点
    )
  );_if

  ; ｾｯﾄｺｰﾄﾞがあれば更新 01/03/26 YM ADD
  (if (and (nth 6 #xd$) (/= (nth 6 #xd$) ""))
    (cond
      ((= "L" (nth 30 #xd$)) ; 元が左勝手
        (setq #SetCode (vl-string-subst "R " "L " (nth 6 #xd$)))
      )
      ((= "R" (nth 30 #xd$)) ; 元が右勝手
        (setq #SetCode (vl-string-subst "L " "R " (nth 6 #xd$)))
      )
      (T
        (setq #SetCode (nth 6 #xd$))
      )
    );_cond
    (setq #SetCode (nth 6 #xd$))
  );_if

; 02/12/06 YM MOD-S 品番LR変更ﾛｼﾞｯｸ変更
;;;(setq #hinban_old #hinban)
;;;(setq #hinban (vl-string-subst "TR " "TL " #hinban))
;;;(if (= #hinban_old #hinban) ; 品番が変わっていなかったら
;;; (setq #hinban (vl-string-subst "TL " "TR " #hinban))
;;;);_if

  ; 02/08/29 YM ADD-S
  (if (= 1 (nth 33 #xd$))
    (progn ; R付き天板だったら品番更新する
      (setq #hinban (nth 34 #xd$))
      (setq #strlen (strlen #hinban)) ; 02/11/27 YM ADD
      (cond
        ((= "R" (substr #hinban 14 1))
          ; 02/11/27 YM MOD-S 材質、ｼﾘｰｽﾞ記号1,2桁対応
          (setq #hinban (strcat (substr #hinban 1 (1- #strlen)) "L"))
          ; 02/11/27 YM MOD-E
;;;         (setq #hinban (strcat (substr #hinban 1 13) "L"))
        )
        ((= "L" (substr #hinban 14 1))
          ; 02/11/27 YM MOD-S
          (setq #hinban (strcat (substr #hinban 1 (1- #strlen)) "R"))
          ; 02/11/27 YM MOD-E
;;;         (setq #hinban (strcat (substr #hinban 1 13) "R"))
        )
      );_cond
    )
  );_if
  ; 02/08/29 YM ADD-E
; 02/12/06 YM MOD-E 品番LR変更ﾛｼﾞｯｸ変更

  ;// 反転後の拡張データを設定
  ; 02/09/02 YM MOD R付かどうかで分岐するように変更
  (if (= 1 (nth 33 #xd$))
    (progn
      (setq #setLst$
        (append
          (list (list 6 #SetCode)(list  7 #cut)); WTｾｯﾄｺｰﾄﾞ,ｶｯﾄﾀｲﾌﾟ
          #setLst$
          (list
            (list 30 #setLR)   ;ＬＲフラグ
            (list 32 #basePt2) ;WT左上点
            (list 34 #hinban)  ; ★R付き天板は更新が必要★
;-- 2011/08/31 A.Satoh Del - S
;            (list 36 #cutL)    ;ｶｯﾄ左
;            (list 37 #cutR)    ;ｶｯﾄ右
;-- 2011/08/31 A.Satoh Del - E
            (list 38 #teiWT)   ;WT底面図形
            (list 42 #nMAG1)   ;間口1
            (list 43 #nMAG2)   ;間口2
            (list 44 #nMAG3)   ;間口3
            (list 49 #bg1)     ;BG1底面図形
            (list 50 #bg2)     ;BG2底面図形
            (list 51 #FG )     ;FG 底面図形
            (list 55 #LEN$)    ;押し出し長さ
            (list 57 #DEP$)    ;奥行き
            (if CG_GAIKEI ; 01/07/04 YM ADD
              (list 59 CG_GAIKEI);WT底面(全体)
              (list 59 "");WT底面(全体)
            );_if
          )
        )
      )
    )
  ; else
    (progn
      (setq #setLst$
        (append
          (list (list 6 #SetCode)(list  7 #cut)); WTｾｯﾄｺｰﾄﾞ,ｶｯﾄﾀｲﾌﾟ
          #setLst$
          (list
            (list 30 #setLR)   ;ＬＲフラグ
            (list 32 #basePt2) ;WT左上点
;-- 2011/08/31 A.Satoh Del - S
;            (list 36 #cutL)    ;ｶｯﾄ左
;            (list 37 #cutR)    ;ｶｯﾄ右
;-- 2011/08/31 A.Satoh Del - E
            (list 38 #teiWT)   ;WT底面図形
            (list 42 #nMAG1)   ;間口1
            (list 43 #nMAG2)   ;間口2
            (list 44 #nMAG3)   ;間口3
    ;;;01/08/30YM@DEL       (list 47 "")       ;ｶｯﾄ左WT ﾀﾞﾐｰ 後で入れる U型で3枚目反転できない原因となるから上書きしなし
    ;;;01/08/30YM@DEL       (list 48 "")       ;ｶｯﾄ右WT ﾀﾞﾐｰ 後で入れる U型で3枚目反転できない原因となるから上書きしなし
            (list 49 #bg1)     ;BG1底面図形
            (list 50 #bg2)     ;BG2底面図形
            (list 51 #FG )     ;FG 底面図形
            (list 55 #LEN$)    ;押し出し長さ
            (list 57 #DEP$)    ;奥行き
            (if CG_GAIKEI ; 01/07/04 YM ADD
              (list 59 CG_GAIKEI);WT底面(全体)
              (list 59 "");WT底面(全体)
            );_if
          )
        )
      )
    )
  );_if

  ;// ワークトップ拡張データの更新
  (CFSetXData #enWkTop "G_WRKT"
    (CFModList #xd$ #setLst$)
  )
  (if #xd-opt$ (CFSetXData #enWkTop "G_OPT" #xd-opt$)) ; 01/02/28 YM ADD

  (setq #xd_WT$ (CFGetXData #enWkTop "G_WRKT" )) ; 新しいWT
  (command "_.vpoint" (list 0 0 1))
  ;;; G_WTSET 穴寸法更新
  (if #xd_WTSET$
    (progn
      (setq #hinban (nth 1 #xd_WTSET$))
      (if (and (> (strlen #hinban) 11)
               (= (substr #hinban 8 1) (nth 30 #xd$))
               (= (substr #hinban 11 1) (nth 30 #xd$))
          )
        (progn
          (setq #hinban (strcat
                          (substr #hinban 1 7)
                          (if (= (nth 30 #xd$) "R") "L" "R")
                          (substr #hinban 9 2)
                          (if (= (nth 30 #xd$) "R") "L" "R")
                          (substr #hinban 12 (- (strlen #hinban) 11))
                        ))
          (setq #xd_WTSET$ (CFModList #xd_WTSET$ (list (list 1 #hinban))))
        )
      )
      (PKResetWTSETdim$ #enWkTop #xd_WT$ #xd_WTSET$ #ZAICode)
    )
  );_if

  #enWkTop
);PK_ONEWTMrrCopy

;;;<HOM>*************************************************************************
;;; <関数名>    : PK_ONEWTMrrMove
;;; <処理概要>  : １つのWTをﾐﾗｰ反転移動 "G_WRKT"左右ｶｯﾄWT=""をｾｯﾄ
;;; <戻り値>    : &wt
;;; <作成日>    : 00/06/02 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PK_ONEWTMrrMove (
  &wt          ;(PICKSET)ワークトップ
  &p1          ;(LIST)対称軸の一点目
  &p2          ;(LIST)対称軸の二点目
  &MRflg       ; &wtが一番右のWT==>T それ以外=nil
  /
  #BASEPT1 #BASEPT2 #CUT #CUTL #CUTR #DEP$ #DUMPT
  #LEN$ #PT$ #SETLR #XD$ #XD_BG$ #ZAICode #XD_WT$ #XD_WTSET$
  #KOSU #SS #SUI$ #ZaiF #xd-opt$ #SetCode #nMAG1 #nMAG2 #nMAG3 #N
#HINBAN #STRLEN ; 03/01/28 YM ADD
;-- 2011/06/14 A.Satoh Add - S
  #LRKeta #tenban_hin #tenban_kingaku #tenban_haba #tenban_takasa #tenban_oku
  #LIST$$ #DB_NAME #qry$$ #qry$
;-- 2011/06/14 A.Satoh Add - E
#ELM$ #ELM$$ #ELM1 #ELM2 #II #KETA #LRKETA$ #SLRKETA ;2014/08/01 YM ADD

  )

  (setq #xd$ (CFGetXData &wt "G_WRKT"))               ; 元のﾜｰｸﾄｯﾌﾟ
  (setq #xd_WTSET$ (CFGetXData &wt "G_WTSET"))
  (setq #xd-opt$  (CFGetXData &wt "G_OPT")) ; 01/02/28 YM ADD
  (command "_mirror" &wt "" &p1 &p2 "Y")              ;ﾜｰｸﾄｯﾌﾟﾐﾗｰ反転
  (command "_mirror" (nth 38 #xd$) "" &p1 &p2 "Y")    ;ﾜｰｸﾄｯﾌﾟ底面図形ﾊﾝﾄﾞﾙ

  (if &MRflg ; 一番右のWTのときのみに反転移動する
    (command "_mirror" (nth 59 #xd$) "" &p1 &p2 "Y")  ;段差部含むﾜｰｸﾄｯﾌﾟ底面図形ﾊﾝﾄﾞﾙ
  );_if

  (if (/= (nth 49 #xd$) "") ; BG1
    (progn
      (command "_mirror" (nth 49 #xd$) "" &p1 &p2 "Y") ;BG1図形ﾊﾝﾄﾞﾙ
      (if (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID")
        (progn ; SOLID の場合
          (setq #xd_BG$ (CFGetXData (nth 49 #xd$) "G_BKGD"))
          (command "_mirror" (nth 1 #xd_BG$) "" &p1 &p2 "Y") ;BG1底面図形ﾊﾝﾄﾞﾙ
        )
      );_if
    )
  );_if

  (if (/= (nth 50 #xd$) "") ; BG2
    (progn
      (command "_mirror" (nth 50 #xd$) "" &p1 &p2 "Y") ;BG2図形ﾊﾝﾄﾞﾙ
      (if (= (cdr (assoc 0 (entget (nth 50 #xd$)))) "3DSOLID")
        (progn ; SOLID の場合
          (setq #xd_BG$ (CFGetXData (nth 50 #xd$) "G_BKGD"))
          (command "_mirror" (nth 1 #xd_BG$) "" &p1 &p2 "Y") ;BG2底面図形ﾊﾝﾄﾞﾙ
        )
      );_if
    )
  );_if

  ; 02/09/02 YM ADD IF文追加 R付き天板は前垂れ無し
  (if (/= (nth 51 #xd$) "") ; BG2
    (progn
      (command "_mirror" (nth 51 #xd$) "" &p1 &p2 "Y") ;FG底面図形ﾊﾝﾄﾞﾙ
    )
  );_if

  ;;; LR 区分 01/12/12 YM MOD ?勝手対応
  (cond
    ((= "R" (nth 30 #xd$))
      (setq #setLR "L")
    )
    ((= "L" (nth 30 #xd$))
      (setq #setLR "R")
    )
;-- 2012/05/24 A.Satoh Add 段落ち天板品番確定対応 - S
		((= "Z" (nth 30 #xd$))
			(setq #setLR "Z")
		)
;-- 2012/05/24 A.Satoh Add 段落ち天板品番確定対応 - E
    (T
      (setq #setLR "?")
    )
  );_cond

  ;;; ｶｯﾄﾀｲﾌﾟ
  (setq #cut (nth 7 #xd$))
  (setq #cut (strcat (substr #cut 2 1)(substr #cut 1 1)))
;-- 2011/08/31 A.Satoh Del - S
;  ;;; ｶｯﾄ記号
;  (setq #cutL (nth 37 #xd$))
;  (setq #cutR (nth 36 #xd$))
;-- 2011/08/31 A.Satoh Del - E

  ;;; 間口1,2,3
  (cond
    ((= (nth 3 #xd$) 0)
      (setq #nMAG1 (nth 42 #xd$))
      (setq #nMAG2 (nth 43 #xd$))
      (setq #nMAG3 (nth 44 #xd$))
    )
    ((= (nth 3 #xd$) 1)
      (setq #nMAG1 (nth 43 #xd$))
      (setq #nMAG2 (nth 42 #xd$))
      (setq #nMAG3 (nth 44 #xd$))
    )
    ((= (nth 3 #xd$) 2)
      (setq #nMAG1 (nth 44 #xd$))
      (setq #nMAG2 (nth 43 #xd$))
      (setq #nMAG3 (nth 42 #xd$))
    )
  );_cond

;-- 2011/08/31 A.Satoh Del - S
;  (setq #cutL (nth 37 #xd$))
;  (setq #cutR (nth 36 #xd$))
;-- 2011/08/31 A.Satoh Del - E
  ;;; WT長さ
  (setq #LEN$ (nth 55 #xd$)) ; そのまま ｽﾃﾝﾚｽL==>650,650長辺先 750先 その他長辺先
  (setq #DEP$ (nth 57 #xd$)) ; そのまま
  ;;; 奥行き値の反転
  (setq #ZAICode (nth 2 #xd$))
  (setq #ZaiF (KCGetZaiF #ZAICode)) ; 素材F 0:人工大理石 1:ｽﾃﾝﾚｽ

  (setq #basePt1 (nth 32 #xd$)) ; WT左上点
  (command "_point" #basePt1)   ;ﾀﾞﾐｰﾎﾟｲﾝﾄ作成
  (command "_mirror" (entlast) "" &p1 &p2 "Y")

  (setq #dumPt (cdr (assoc 10 (entget (entlast))))) ; ﾎﾟｲﾝﾄ座標 WT右
  (entdel (entlast))            ;ﾀﾞﾐｰﾎﾟｲﾝﾄ削除

  (setq #pt$ (GetLWPolyLinePt (nth 38 #xd$))) ; WT底面外形点列 01/08/29 YM MOVE 下から移動

  (if (and (not (equal (KPGetSinaType) -1 0.1))(= #ZaiF 1)(= (nth 3 #xd$) 1)
           (= 6 (length #pt$))) ; ｽﾃﾝL型 01/08/29 YM ADD ｽﾃﾝﾚｽL型段差で分離したI形状WT対応
    (setq #basePt2 #dumPt)                ; 新WT左上点
    (progn
      ;;; 反転後の配置点など情報獲得用ダミー点のミラー
      (setq #basePt1 (nth 32 #xd$))               ; WT左上点
;;;01/08/29YM@MOVE    (setq #pt$ (GetLWPolyLinePt (nth 38 #xd$))) ; WT底面外形点列
      (setq #pt$ (GetPtSeries #dumPt #pt$))       ; 点列内の#dumPtを先頭に時計周りにする
;-- 2012/02/28 A.Satoh Mod - S
;;;;;      (setq #basePt2 (last #pt$))                 ; 新WT左上点
			; 新ＷＴ基点
			(if (= (nth 3 #xd$) 0)	; I型
      	(setq #basePt2 (last #pt$))
      	(setq #basePt2 #dumPt)
			)
;-- 2012/02/28 A.Satoh Mod - E
      (if (= (length #basePt2) 2)(setq #basePt2 (list (car #basePt2) (cadr #basePt2) 0.0))) ; 07/18 YM
    )
  );_if

  ; 01/08/23 YM ADD-S ////////////////////////////////////////////////
  ;;; 水栓穴の更新
  (setq #n 23)  ; 00/09/27 YM
  (repeat (nth 22 #xd$)
    (command "_mirror" (nth #n #xd$) "" &p1 &p2 "Y") ; 移動
    (setq #n (1+ #n))
  )
  ; 01/08/23 YM ADD-E ////////////////////////////////////////////////

;;; ;;; 水栓穴の更新
;;; (setq #n 23)  ; 00/09/27 YM
;;; (repeat (nth 22 #xd$)
;;;   (entdel (nth #n #xd$))
;;;   (setq #n (1+ #n))
;;; ) ; 00/09/27 YM

;;; (setq #pt$ (PKGetWT_outPT &wt 1)) ; 外形点列 ; 01/08/10 YM ADD(引数追加)
;;; (command "_layer" "T" "Z_wtbase" "")
;;; (setq #ss (ssget "CP" #pt$ (list (list -3 (list "G_WTR"))))) ; 領域内の水栓
;;; (command "_layer" "F" "Z_wtbase" "")
;;; (if (= #ss nil)(setq #ss (ssadd)))
;;;
;;; (setq #sui$ (CMN_ss_to_en #ss))
;;;   (setq #kosu (length #sui$))
;;;   (if (> 7 (length #sui$))
;;;     (repeat (- 7 (length #sui$)) (setq #sui$ (append #sui$ (list ""))))
;;;   );_if

  ; ｾｯﾄｺｰﾄﾞがあれば更新 01/03/26 YM ADD
  (if (and (nth 6 #xd$) (/= (nth 6 #xd$) ""))
    (cond
      ((= "L" (nth 30 #xd$)) ; 元が左勝手
        (setq #SetCode (vl-string-subst "R " "L " (nth 6 #xd$)))
      )
      ((= "R" (nth 30 #xd$)) ; 元が右勝手
        (setq #SetCode (vl-string-subst "L " "R " (nth 6 #xd$)))
      )
      (T
        (setq #SetCode (nth 6 #xd$))
      )
    );_cond
    (setq #SetCode (nth 6 #xd$))
  );_if

; 02/12/06 YM MOD-S 品番LR変更ﾛｼﾞｯｸ変更
;;;(setq #hinban_old #hinban)
;;;(setq #hinban (vl-string-subst "TR " "TL " #hinban))
;;;(if (= #hinban_old #hinban) ; 品番が変わっていなかったら
;;; (setq #hinban (vl-string-subst "TL " "TR " #hinban))
;;;);_if

  ; 02/08/29 YM ADD-S
  (if (= 1 (nth 33 #xd$))
    (progn ; R付き天板だったら品番更新する
      (setq #hinban (nth 34 #xd$))
      (setq #strlen (strlen #hinban)) ; 02/11/27 YM ADD
      (cond
        ((= "R" (substr #hinban #strlen 1))
          ; 02/11/27 YM MOD-S 材質、ｼﾘｰｽﾞ記号1,2桁対応
          (setq #hinban (strcat (substr #hinban 1 (1- #strlen)) "L"))
          ; 02/11/27 YM MOD-E
;;;         (setq #hinban (strcat (substr #hinban 1 13) "L"))
        )
        ((= "L" (substr #hinban #strlen 1))
          ; 02/11/27 YM MOD-S
          (setq #hinban (strcat (substr #hinban 1 (1- #strlen)) "R"))
          ; 02/11/27 YM MOD-E
;;;         (setq #hinban (strcat (substr #hinban 1 13) "R"))
        )
      );_cond
    )
  );_if
  ; 02/08/29 YM ADD-E
; 02/12/06 YM MOD-E 品番LR変更ﾛｼﾞｯｸ変更

  ;// ワークトップ拡張データの更新
  ; 02/09/02 YM MOD R付かどうかで分岐するように変更
  (if (= 1 (nth 33 #xd$))
    (progn
      (CFSetXData &wt "G_WRKT"
        (CFModList #xd$
          (list
            (list  6 #SetCode) ; WTｾｯﾄｺｰﾄﾞ
            (list  7 #cut)     ;ｶｯﾄﾀｲﾌﾟ
            (list 30 #setLR)   ;ＬＲフラグ
            (list 32 #basePt2) ;WT左上点
            (list 34 #hinban)  ; ★R付きの場合更新が必要★
;-- 2011/08/31 A.Satoh Del - S
;            (list 36 #cutL)    ;ｶｯﾄ左
;            (list 37 #cutR)    ;ｶｯﾄ右
;-- 2011/08/31 A.Satoh Del - E
            (list 42 #nMAG1)   ;間口1
            (list 43 #nMAG2)   ;間口2
            (list 44 #nMAG3)   ;間口3
            (list 55 #LEN$)    ;押し出し長さ
            (list 57 #DEP$)    ;奥行き
          )
        )
      )
    )
  ; else
    (progn
      (CFSetXData &wt "G_WRKT"
        (CFModList #xd$
          (list
            (list  6 #SetCode) ; WTｾｯﾄｺｰﾄﾞ
            (list  7 #cut)     ;ｶｯﾄﾀｲﾌﾟ
    ; 移動なので更新不要 01/08/23 YM DEL-S
    ;;;        (list 22 (sslength #ss))
    ;;;        (list 23 (nth 0 #sui$))
    ;;;        (list 24 (nth 1 #sui$))
    ;;;        (list 25 (nth 2 #sui$))
    ;;;        (list 26 (nth 3 #sui$))
    ;;;        (list 27 (nth 4 #sui$))
    ;;;        (list 28 (nth 5 #sui$))
    ;;;        (list 29 (nth 6 #sui$))
    ; 移動なので更新不要 01/08/23 YM DEL-E
            (list 30 #setLR)   ;ＬＲフラグ
            (list 32 #basePt2) ;WT左上点
;-- 2011/08/31 A.Satoh Del - S
;            (list 36 #cutL)    ;ｶｯﾄ左
;            (list 37 #cutR)    ;ｶｯﾄ右
;-- 2011/08/31 A.Satoh Del - E
            (list 42 #nMAG1)   ;間口1
            (list 43 #nMAG2)   ;間口2
            (list 44 #nMAG3)   ;間口3
    ;;;01/08/30M@DEL        (list 47 "")       ;ｶｯﾄ左WT ﾀﾞﾐｰ 後で入れる U型で3枚目反転できない原因となるから上書きしなし
    ;;;01/08/30M@DEL        (list 48 "")       ;ｶｯﾄ右WT ﾀﾞﾐｰ 後で入れる U型で3枚目反転できない原因となるから上書きしなし
            (list 55 #LEN$)    ;押し出し長さ
            (list 57 #DEP$)    ;奥行き
          )
        )
      )
    )
  );_if

  (setq #xd_WT$ (CFGetXData &wt "G_WRKT" )) ; 新しいWT
  (command "_.vpoint" (list 0 0 1))
  ;;; G_WTSET 穴寸法更新
  (if #xd_WTSET$
    (progn
      (setq #hinban (nth 1 #xd_WTSET$))
;-- 2011/06/14 A.Satoh Mod - S
;     (if (and (> (strlen #hinban) 11)
;              (= (substr #hinban 8 1) (nth 30 #xd$))
;              (= (substr #hinban 11 1) (nth 30 #xd$))
;         )
;       (progn
;         (setq #hinban (strcat
;                         (substr #hinban 1 7)
;                         (if (= (nth 30 #xd$) "R") "L" "R")
;                         (substr #hinban 9 2)
;                         (if (= (nth 30 #xd$) "R") "L" "R")
;                         (substr #hinban 12 (- (strlen #hinban) 11))
;                       ))
;         (setq #xd_WTSET$ (CFModList #xd_WTSET$ (list (list 1 #hinban))))
;       )
;     )
      ; 変更桁数の取得
;2014/08/04 YM MOD-S
;;;      (setq #LRKeta (CFgetini "TENBAN_LR" CG_DBNAME (strcat CG_SKPATH "ERRMSG.INI")))
      (setq #sLRKeta (CFgetini "TENBAN_LR" "KETA" (strcat CG_SKPATH "ERRMSG.INI")))
			(setq #LRKeta$ (strparse #sLRKeta ","))
			(setq #ii 1)
			(setq #elm$$ nil)
			(repeat (/ (length #LRKeta$) 2)
				(setq #elm1 (nth (- (* 2 #ii) 2) #LRKeta$))
				(setq #elm2 (nth (- (* 2 #ii) 1) #LRKeta$))
				(setq #elm$ (cons #elm1 #elm2))
				(setq #elm$$ (append #elm$$ (list #elm$)))
				(setq #ii (1+ #ii))
			)
			(setq #keta (itoa (strlen #hinban)))
			(setq #LRKeta (cdr (assoc #keta #elm$$)))
			(if (= nil #LRKeta)
				(setq #LRKeta "999");Errmsgから桁が求まらない(特注天板など)
			);_if

;2014/08/04 YM MOD-E


;2014/08/04 YM MOD-S 特注かどうか判断
			
			(if (= (nth 58 #xd$) "TOKU")
				(progn
					nil ;何もしない
				)
				(progn ;規格天板

					(setq #hinban (strcat
													(substr #hinban 1 (1- (atoi #LRKeta)))
													(if (= (substr #hinban (atoi #LRKeta) 1) "R") "L" "R")
													(substr #hinban (1+ (atoi #LRKeta)) (- (strlen #hinban) (atoi #LRKeta)))
												)
					)

          ; 品番から品名、金額、幅、高さ、奥行を取得する。
          ; 現状、品番のみで取得している為、複数取得される場合がある。
          ; 複数取得された場合は、先頭レコードのみを採用する。
          ; 客先確認後、修正予定
          (setq #LIST$$
            (list
              (list "最終品番" #hinban 'STR)
            )
          )
          (setq #DB_NAME "天板価格")
          (setq #qry$$ (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$))
          (if (and #qry$$ (> (length #qry$$) 0))
            (progn
              (setq #qry$ (car #qry$$))
              (setq #tenban_kingaku     (nth 2 #qry$))   ; 金額
              (setq #tenban_haba    (nth 3 #qry$))   ; 巾
              (setq #tenban_takasa  (nth 4 #qry$))   ; 高さ
              (setq #tenban_oku (nth 5 #qry$))   ; 奥行
              (setq #tenban_hin  (nth 6 #qry$))   ; 品名

              (setq #xd_WTSET$ (CFModList #xd_WTSET$
                        (list (list 1 #hinban)
															(list 3 #tenban_kingaku)
															(list 4 #tenban_hin)
															(list 5 #tenban_haba)
															(list 6 #tenban_takasa)
															(list 7 #tenban_oku)
												)))
            )
            (progn ;HITしない
              (setq #xd_WTSET$ (CFModList #xd_WTSET$ (list (list 1 #hinban))))
            )
          );_if

        )
      );_if







;-- 2011/06/14 A.Satoh Mod - E
      (PKResetWTSETdim$ &wt #xd_WT$ #xd_WTSET$ #ZAICode)
    )
  );_if
  &wt
);PK_ONEWTMrrMove

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_MirrorWorkTop
;;; <処理概要>  : ワークトップの反転コピー
;;; <戻り値>    :
;;; <作成日>    : 1999-06-14 00/06/01 新型WT対応 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKW_MirrorWorkTop (
  &wtSS          ;(PICKSET)ワークトップの選択セット
  &p1            ;(LIST)対称軸の一点目
  &p2            ;(LIST)対称軸の二点目
  &flg           ; T==>移動,nil==>ｺﾋﾟｰ
  /
  #I #MRWT #MRWT$ #NWT #NWT$ #SET$ #WTL #WTXD0$ #XD$ #XDL$ #WT_LEFT #WT_RIGHT
;-- 2011/07/29 A.Satoh Add - S
  #enCut #CutHand #enCut2 #CutHand2
;-- 2011/07/29 A.Satoh Add - E
;-- 2011/09/05 A.Satoh Add - S
  #enCut3 #CutHand3 #enCut4 #CutHand4 #xd_wrkt$
;-- 2011/09/05 A.Satoh Add - E
#wt_pnt$ #basePt$ #dep$ ;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_MirrorWorkTop ////")
  (CFOutStateLog 1 1 " ")

;-- 2011/09/05 A.Satoh Mod - S
;;-- 2011/07/29 A.Satoh Add - S
;  ; WTカットライン図形名を取得する
;  (setq #CutHand (nth 35 (CFGetXData (ssname &wtSS 0) "G_WRKT")))
;  (if (and #CutHand (/= #CutHand ""))
;    (setq #enCut (handent #CutHand))
;  )
;
;  (setq #CutHand2 (nth 36 (CFGetXData (ssname &wtSS 0) "G_WRKT")))
;  (if (and #CutHand2 (/= #CutHand2 ""))
;    (setq #enCut2 (handent #CutHand2))
;  )
;;-- 2011/07/29 A.Satoh Add - E
  ; WTカットライン図形名を取得する
  (setq #xd_wrkt$ (CFGetXData (ssname &wtSS 0) "G_WRKT"))
  (setq #CutHand (nth 60 #xd_wrkt$))
  (if (and #CutHand (/= #CutHand ""))
    (setq #enCut (handent #CutHand))
  )

  (setq #CutHand2 (nth 61 #xd_wrkt$))
  (if (and #CutHand2 (/= #CutHand2 ""))
    (setq #enCut2 (handent #CutHand2))
  )

  (setq #CutHand3 (nth 62 #xd_wrkt$))
  (if (and #CutHand3 (/= #CutHand3 ""))
    (setq #enCut3 (handent #CutHand3))
  )

  (setq #CutHand4 (nth 63 #xd_wrkt$))
  (if (and #CutHand4 (/= #CutHand4 ""))
    (setq #enCut4 (handent #CutHand4))
  )
;-- 2011/09/05 A.Satoh Mod - E

  (setq #MRWT$ (PKSStoMRWT$ &wtSS)) ; WT選択ｾｯﾄ-->最右WT図形ﾘｽﾄに変換
  (setq #i 0)
  (foreach #MRWT #MRWT$ ; 各最右 or 単独WT
    (setq #NWT$ nil) ; 初期化忘れて複数ﾌﾟﾗﾝのﾐﾗｰ反転時に左右WT図形ﾊﾝﾄﾞﾙがおかしくｾｯﾄされる 01/03/27 YM
    (setq #xd$ (CFGetXData #MRWT "G_WRKT"))
    (if &flg
      (setq #NWT (PK_ONEWTMrrMove #MRWT &p1 &p2 T)) ; １つのWTをﾐﾗｰ反転移動"G_WRKT"左右ｶｯﾄWT=""をｾｯﾄ
      (setq #NWT (PK_ONEWTMrrCopy #MRWT &p1 &p2 T)) ; １つのWTをﾐﾗｰ反転ｺﾋﾟｰ"G_WRKT"左右ｶｯﾄWT=""をｾｯﾄ
    )

    (setq #NWT$ (append #NWT$ (list #NWT)))       ; 新しくできたWT

    (setq #WTL (nth 47 #xd$))                     ; 左WT図形ﾊﾝﾄﾞﾙ

;;;01/08/30YM@DEL   ; 01/08/30 YM ADD-S 左右隣接WTをｸﾘｱｰする
;;;01/08/30YM@DEL   ;// ワークトップ拡張データの更新
;;;01/08/30YM@DEL   (CFSetXData #MRWT "G_WRKT"
;;;01/08/30YM@DEL     (CFModList #xd$
;;;01/08/30YM@DEL       (list
;;;01/08/30YM@DEL         (list 47 "");ｶｯﾄ左WT ﾀﾞﾐｰ 後で入れる
;;;01/08/30YM@DEL         (list 48 "");ｶｯﾄ右WT ﾀﾞﾐｰ 後で入れる
;;;01/08/30YM@DEL       )
;;;01/08/30YM@DEL     )
;;;01/08/30YM@DEL   )
;;;01/08/30YM@DEL   ; 01/08/30 YM ADD-E 左右隣接WTをｸﾘｱｰする

    (while (and #WTL (/= #WTL ""))                ; 左にWTがあれば
      (if &flg
        (setq #NWT (PK_ONEWTMrrMove #WTL &p1 &p2 nil)); １つのWTをﾐﾗｰ反転移動"G_WRKT"左右ｶｯﾄWT=""をｾｯﾄ
        (setq #NWT (PK_ONEWTMrrCopy #WTL &p1 &p2 nil)); １つのWTをﾐﾗｰ反転ｺﾋﾟｰ"G_WRKT"左右ｶｯﾄWT=""をｾｯﾄ
      )
      (setq #NWT$ (append #NWT$ (list #NWT)))     ; 新しくできたWT or 移動の場合は元のWT
      (setq #xdL$ (CFGetXData #WTL "G_WRKT"))

;;;01/08/30YM@DEL     ; 01/08/30 YM ADD-S 左右隣接WTをｸﾘｱｰする(Xdata #xdL$ を取得してから)
;;;01/08/30YM@DEL     ;// ワークトップ拡張データの更新
;;;01/08/30YM@DEL     (CFSetXData #WTL "G_WRKT"
;;;01/08/30YM@DEL       (CFModList #xdL$
;;;01/08/30YM@DEL         (list
;;;01/08/30YM@DEL           (list 47 "");ｶｯﾄ左WT ﾀﾞﾐｰ 後で入れる
;;;01/08/30YM@DEL           (list 48 "");ｶｯﾄ右WT ﾀﾞﾐｰ 後で入れる
;;;01/08/30YM@DEL         )
;;;01/08/30YM@DEL       )
;;;01/08/30YM@DEL     )
;;;01/08/30YM@DEL     ; 01/08/30 YM ADD-E 左右隣接WTをｸﾘｱｰする

      (setq #WTL (nth 47 #xdL$))                  ; 更に左にあるか
      (if (= #WTL "") (setq #WTL nil))            ; なかったら nil
    )

    ; 01/08/30 YM MOD-S 左右隣接WTｾｯﾄ不具合修正 ﾛｼﾞｯｸ変更
    (setq #NWT$ (reverse #NWT$))
    (setq #i 0)
    (foreach #NWT #NWT$
      (if (nth (1+ #i) #NWT$)
        (setq #WT_Left (nth (1+ #i) #NWT$))
        (setq #WT_Left "")
      );_if

      (if (and (< -1 (1- #i))(nth (1- #i) #NWT$))
        (setq #WT_Right (nth (1- #i) #NWT$))
        (setq #WT_Right "")
      );_if

;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 - S
      ;// ワークトップ拡張データの更新
;;;;;      (CFSetXData #NWT "G_WRKT"
;;;;;        (CFModList (setq #xdL$ (CFGetXData #NWT "G_WRKT"))
;;;;;          (list
;;;;;            (list 47 #WT_Left) ; ｶｯﾄ左WT ﾀﾞﾐｰ 後で入れる
;;;;;            (list 48 #WT_Right); ｶｯﾄ右WT ﾀﾞﾐｰ 後で入れる
;;;;;          )
;;;;;        )
;;;;;      )
			(setq #xdL$ (CFGetXData #NWT "G_WRKT"))
			(setq #wt_pnt$ (GetLWPolyLinePt (nth 38 #xdL$)))			; WT外形点列
			(setq #wt_pnt$ (GetPtSeries (nth 32 #xdL$) #wt_pnt$))	; WT左上点を先頭に時計周り
			(cond
				((= (nth 3 #xdL$) 0)	; I型
					(setq #basePt$ (nth 32 #xdL$))
					(setq #dep$ (nth 57 #xdL$))
				)
				((= (nth 3 #xdL$) 1)	; L型
					(setq #basePt$ (nth 32 #xdL$))
					(setq #dep$ (list (cadr (nth 57 #xdL$)) (car (nth 57 #xdL$)) (caddr (nth 57 #xdL$))))
				)
				((= (nth 3 #xdL$) 2)	; U型
					(setq #basePt$ (nth 1 #wt_pnt$))
					(setq #dep$ (list (caddr (nth 57 #xdL$)) (cadr (nth 57 #xdL$)) (car (nth 57 #xdL$))))
				)
			)

			(CFSetXData #NWT "G_WRKT"
				(CFModList #xdL$
					(list
						(list 32 #basePt$)  ; ワークトップ底面の左上点
						(list 47 #WT_Left)  ; ｶｯﾄ左WT ﾀﾞﾐｰ 後で入れる
						(list 48 #WT_Right) ; ｶｯﾄ右WT ﾀﾞﾐｰ 後で入れる
						(list 57 #dep$)      ; WTの奥行
					)
				)
			)
;-- 2012/04/20 A.Satoh Mod シンク配置不具合対応 - E
      (setq #i (1+ #i))
    );_foreach

    ; 01/08/30 YM MOD-E 左右隣接WTｾｯﾄ不具合修正

;;;01/08/30YM@MOD   (if (> (length #NWT$) 1) ; 単独WTでない場合ｶｯﾄ左右WT再設定
;;;01/08/30YM@MOD     (progn
;;;01/08/30YM@MOD       (setq #i 0)
;;;01/08/30YM@MOD       (foreach #NWT #NWT$
;;;01/08/30YM@MOD         (cond
;;;01/08/30YM@MOD           ((= #i 0) ; 最初ｶｯﾄ右のみ
;;;01/08/30YM@MOD             (setq #set$ (list (list 48 (nth (1+ #i) #NWT$)))) ; ｶｯﾄ右
;;;01/08/30YM@MOD           )
;;;01/08/30YM@MOD           ((= #i (1- (length #NWT$))) ; 最後ｶｯﾄ左のみ
;;;01/08/30YM@MOD             (setq #set$ (list (list 47 (nth (1- #i) #NWT$)))) ; ｶｯﾄ左
;;;01/08/30YM@MOD           )
;;;01/08/30YM@MOD           (T ; 途中ｶｯﾄは左右
;;;01/08/30YM@MOD             (setq #set$
;;;01/08/30YM@MOD               (list
;;;01/08/30YM@MOD                 (list 47 (nth (1- #i) #NWT$)) ; ｶｯﾄ左
;;;01/08/30YM@MOD                 (list 48 (nth (1+ #i) #NWT$)) ; ｶｯﾄ右
;;;01/08/30YM@MOD               )
;;;01/08/30YM@MOD             )
;;;01/08/30YM@MOD           )
;;;01/08/30YM@MOD         );_cond
;;;01/08/30YM@MOD
;;;01/08/30YM@MOD         (CFSetXData #NWT "G_WRKT"
;;;01/08/30YM@MOD           (CFModList
;;;01/08/30YM@MOD             (CFGetXData #NWT "G_WRKT")
;;;01/08/30YM@MOD             #set$
;;;01/08/30YM@MOD           )
;;;01/08/30YM@MOD         )
;;;01/08/30YM@MOD         (setq #i (1+ #i))
;;;01/08/30YM@MOD       );_foreach
;;;01/08/30YM@MOD     )
;;;01/08/30YM@MOD   );_if

  );_foreach

;-- 2011/08/01 A.Satoh Add - S
  ; カット線の反転
  (if (/= #enCut nil)
    (command "_.MIRROR" #enCut "" &p1 &p2 "Y")
  )

  (if (/= #enCut2 nil)
    (command "_.MIRROR" #enCut2 "" &p1 &p2 "Y")
  )
;-- 2011/08/01 A.Satoh Add - E
;-- 2011/09/05 A.Satoh Add - S
  (if (/= #enCut3 nil)
    (command "_.MIRROR" #enCut3 "" &p1 &p2 "Y")
  )

  (if (/= #enCut4 nil)
    (command "_.MIRROR" #enCut4 "" &p1 &p2 "Y")
  )
;-- 2011/09/05 A.Satoh Add - E

  (princ)
);PKW_MirrorWorkTop

;;;<HOM>*************************************************************************
;;; <関数名>    : PKW_MirrorFiler
;;; <処理概要>  : 天井フィラーの反転コピー、移動
;;; <戻り値>    :
;;; <作成日>    : 1999-06-14 00/06/01 PKW_MirrorWorkTopSS から分離 YM
;;; <備考>      :
;;;*************************************************************************>MOH<
(defun PKW_MirrorFiler (
  &FLSS          ;(PICKSET)天井フィラーの選択セット
  &p1            ;(LIST)対称軸の一点目
  &p2            ;(LIST)対称軸の二点目
  &flg           ; T==>移動,nil==>ｺﾋﾟｰ
  /
  #EN #FILER #FPLINE #HAND #I #XD$ #YESNO
  #38 #EDUM #EG$ #LAYER #PT$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_MirrorFiler ////")
  (CFOutStateLog 1 1 " ")

  (if &flg
    (setq #YesNo "Y")
    (setq #YesNo "N")
  );_if

  (setq #i 0)
  (repeat (sslength &FLSS)
    (setq #en (ssname &FLSS #i))
    (if (setq #xd$ (CFGetXData #en "G_FILR"))           ;// 天井ﾌｨﾗｰ
      (progn
        (command "_mirror" #en "" &p1 &p2 #YesNo)
        (if &flg
          (setq #filer #en)       ;ﾐﾗｰ反転移動後ﾌｨﾗｰ図形名
          (setq #filer (entlast)) ;ﾐﾗｰ反転ｺﾋﾟｰ後ﾌｨﾗｰ図形名
        );_if
        (command "_mirror" (nth 2 #xd$) "" &p1 &p2 #YesNo)
        ; 鏡像なのでPLINEの向きが逆になっている
        (if &flg
          (setq #fpline (nth 2 #xd$)) ;ﾐﾗｰ反転移動後ﾌｨﾗｰPLINE図形名
          (setq #fpline (entlast))    ;ﾐﾗｰ反転ｺﾋﾟｰ後ﾌｨﾗｰPLINE図形名
        );_if

        ; 向きを逆にする 01/04/25 YM START ---------------------------------
        (setq #eg$ (entget #fpline))
        (setq #layer (cdr (assoc  8 #eg$))) ; PLINEの画層
        (setq #38    (cdr (assoc 38 #eg$))) ; PLINEの高度
        (setq #pt$ nil)
        (foreach eg #eg$
          (if (= 10 (car eg))
            (setq #pt$ (append #pt$ (list (cdr eg)))) ; PLINE頂点を集める
          );_if
        )
        (setq #pt$ (reverse #pt$)) ; 頂点を逆向きにする
        (setq #eDUM (MakeLwPolyLine #pt$ 0 #38)) ; PLINE作成
        (entmod (subst (cons 8 #layer) (assoc 8 (entget #eDUM)) (entget #eDUM)))
        (entdel #fpline)
        (setq #fpline #eDUM)
        ; 向きを逆にする 01/04/25 YM END -----------------------------------

        (CFSetXData #filer "G_FILR" ; 01/02/28 YM ADD
          (CFModList #xd$ (list (list 2 #fpline)))
        )

      )
    );_if
    (setq #i (1+ #i))
  );_repeat
  (princ)
);PKW_MirrorFiler

;<HOM>*************************************************************************
; <関数名>    : PKMoveSNKbeforeOther
; <処理概要>  : 選択ｾｯﾄを、ｼﾝｸを先頭にした図形名ﾘｽﾄにする
; <戻り値>    : 図形名ﾘｽﾄ
; <作成日>    : 00/07/18 YM
; <備考>      : 01/03/22 水栓,ｺﾝﾛも優先する
;*************************************************************************>MOH<
(defun PKMoveSNKbeforeOther (
  &SS ;(PICKSET)
  /
  #EN$ #ENOTR$ #ENSNK$ #LIS$ #ENGAS$ #ENWTR$ #ONE
  )
  (setq #enSNK$ nil #enGAS$ nil #enWTR$ nil #enOTR$ nil)
  (setq #en$ (CMN_ss_to_en &SS))
  (foreach #en #en$
    (setq #one (CFGetSymSKKCode #en 1))
    (cond
      ((= #one CG_SKK_ONE_SNK) ; 性格ｺｰﾄﾞ1桁 CG_SKK_ONE_SNK = 4(ｼﾝｸ)
        (setq #enSNK$ (append #enSNK$ (list #en)))   ; ｼﾝｸばかり集める
      )
      ((= #one CG_SKK_ONE_GAS) ; 性格ｺｰﾄﾞ1桁 CG_SKK_ONE_GAS = 2(ｺﾝﾛ)
        (setq #enGAS$ (append #enGAS$ (list #en)))   ; ｺﾝﾛばかり集める
      )
      ((= #one CG_SKK_ONE_WTR) ; 性格ｺｰﾄﾞ1桁 CG_SKK_ONE_WTR = 5(水栓)
        (setq #enWTR$ (append #enWTR$ (list #en)))   ; 水栓ばかり集める
      )
      (T
        (setq #enOTR$ (append #enOTR$ (list #en)))   ; ｼﾝｸ,水栓,ｺﾝﾛ以外ばかり集める
      )
    );_cond
  )
  (setq #lis$ (append #enSNK$ #enGAS$ #enWTR$ #enOTR$)) ; ｼﾝｸを前に持ってくる
);PKMoveSNKbeforeOther

;<HOM>*************************************************************************
; <関数名>    : PKMoveSNKbeforeOther_Lipple
; <処理概要>  : 選択ｾｯﾄを、ｼﾝｸを先頭にした図形名ﾘｽﾄにする
; <戻り値>    : 図形名ﾘｽﾄ
; <作成日>    : 00/07/18 YM
; <備考>      : 01/03/22 水栓,ｺﾝﾛも優先する
;*************************************************************************>MOH<
(defun PKMoveSNKbeforeOther_Lipple (
  &SS ;(PICKSET)
  /
  #EN$ #ENCAB$ #ENGAS$ #ENOTR$ #ENWTR$ #LIS$ #ONE
  )
  (setq #en$ (CMN_ss_to_en &SS))
  (setq #enCAB$ nil #enGAS$ nil #enWTR$ nil #enOTR$ nil)
  (foreach #en #en$
    (setq #one (CFGetSymSKKCode #en 1))
    (cond
      ((= #one CG_SKK_ONE_CAB) ; 性格ｺｰﾄﾞ1桁 CG_SKK_ONE_CAB = 1(ｷｬﾋﾞ)
        (setq #enCAB$ (append #enCAB$ (list #en)))   ; ｷｬﾋﾞばかり集める
      )
      ((= #one CG_SKK_ONE_GAS) ; 性格ｺｰﾄﾞ1桁 CG_SKK_ONE_GAS = 2(ｺﾝﾛ)
        (setq #enGAS$ (append #enGAS$ (list #en)))   ; ｺﾝﾛばかり集める
      )
      ((= #one CG_SKK_ONE_WTR) ; 性格ｺｰﾄﾞ1桁 CG_SKK_ONE_WTR = 5(水栓)
        (setq #enWTR$ (append #enWTR$ (list #en)))   ; 水栓ばかり集める
      )
      (T
        (setq #enOTR$ (append #enOTR$ (list #en)))   ; ｼﾝｸ,水栓,ｺﾝﾛ以外ばかり集める
      )
    );_cond
  )
  (setq #lis$ (append #enGAS$ #enCAB$ #enWTR$ #enOTR$)) ; ｺﾝﾛｷｬﾋﾞを前に持ってくる
);PKMoveSNKbeforeOther_Lipple

;<HOM>*************************************************************************
; <関数名>    : PKC_MirrorParts
; <処理概要>  : 部材反転(プラン検索用）
; <戻り値>    :
; <作成日>    : 1999-06-14
; <備考>      : ファミリー品番のプラン情報のＬ／Ｒ区分が２（右勝手）の場合、
;               配置済みの部材全体にミラー反転処理を行う
;*************************************************************************>MOH<
(defun PKC_MirrorParts (
    /
    #ss
    #ss2
    #en #en$
    #i
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKC_MirrorParts ////")
  (CFOutStateLog 1 1 " ")

  ;// 前提条件
  ;//   プラン構成部材が配置済みであること

  ;// 配置済み部材のＬ／Ｒ区分をチェックし、Ｌ／Ｒ区分がない場合以外はL/R区分および
  ;// Ｗ方向フラグを反転させた後、部材を配置し直す

  ;// 扉図形については３Ｄ目地領域、または正面用扉領域（Ｐ面）の中で反転処理を行う
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (PKC_MirrorPartsSub #ss)

  ;// 天井フィラーをミラー反転する
  (setq #ss (ssget "X" '((8 . "Z_00"))))
  (if (and (/= #ss nil) (/= 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (setq #ss2 (ssadd))
      (repeat (sslength #ss)
        (setq #en$ (CFGetGroupEnt (ssname #ss #i)))
        (foreach #en #en$
          (ssadd #en #ss2)
        )
        (setq #i (1+ #i))
      )
      (command "_mirror"
        #ss2
        ""
        (list 0.0 0.0)
        (list 0.0 10.0)
        "Y"
      )
    )
  )
);PKC_MirrorParts

;;  2005/08/02 G.YK ADD-S
;<HOM>*************************************************************************
; <関数名>    : PKC_GetSymInGroup
; <処理概要>  : 選択セットよりグループシンボルを取得する。
;               あちらこちらに似たような処理があるので、ここに集約する。
; <戻り値>    :
; <作成日>    : 2005/08/02 G.YK
; <備考>      :
;*************************************************************************>MOH<
(defun PKC_GetSymInGroup (
  &ss
  /
  #i #loop #sym
  )
  (setq #sym nil)
  (setq #loop T)
  (setq #i 0)
  (while (and #loop (< #i (sslength &ss)))
    (setq #sym (SKC_GetSymInGroup (ssname &ss #i)))
    (if #sym (setq #loop nil))
    (setq #i (1+ #i))
  )
  #sym
)
;;  2005/08/02 G.YK ADD-E

;<HOM>*************************************************************************
; <関数名>    : PKC_MirrorPartsSub
; <処理概要>  : 部材反転
; <戻り値>    :
; <作成日>    : 1999-06-14
; <備考>      :
;*************************************************************************>MOH<
(defun PKC_MirrorPartsSub (
  &symSs         ;(PICKSET)シンボルの選択セット
  /
  #ANG #BPT #DWG #GRP #I #LR #ONE #RET$ #SEIKAKU #SET-LR #SS #SSYM
  #SYM #W #X #XD-LSYM$ #XD-SINK$ #XD-SYM$ #XD2$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKC_MirrorPartsSub ////")
  (CFOutStateLog 1 1 " ")

  ;P型ﾌｰﾄﾞ(性格ｺｰﾄﾞ328)が存在すればｼﾝﾎﾞﾙ図形を格納
  ;2010/11/10 YM ADD
  (setq CG_P_HOOD_SYM nil);初期化

  (setq #ss &symSS)
  (setq #i 0)
  (repeat (sslength #ss)
    (setq #sym (ssname #ss #i))
    (setq #xd-lsym$ (CFGetXData #sym "G_LSYM"))
    (setq #xd-sym$  (CFGetXData #sym "G_SYM"))
    (setq #bpt      (cdr (assoc 10 (entget #sym))))
    (setq #seikaku  (nth 9 #xd-lsym$))   ;性格CODE
    ;;; "G_SINK" 追加 05/18 YM
    (if (= #seikaku CG_SKK_INT_SNK) ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
      (setq #xd-sink$  (CFGetXData #sym "G_SINK"))
    );_if

    (setq #ang      (nth 2 #xd-lsym$))   ;回転角度
    (setq #dwg      (nth 0 #xd-lsym$))

    ;// L/R区分の取得
    (setq #LR (nth 6 #xd-lsym$))     ; 00/02/18 YM MOD
    (if (/= #LR "Z")   ;L/R区分あり  ; 00/02/18 YM MOD
      (progn
        ;// 左勝手部材を取得しなおし、再配置
        (setq #ret (PKC_GetLRParts #xd-lsym$))
        (setq #dwg #ret)

        (setq #ssym (CFGetSameGroupSS #sym))
        (command "_erase" #ssym "")
        (command "_insert" (strcat CG_MSTDWGPATH #dwg) #bpt "1" "" (rtd #ang))
        (setq #sym (entlast))
        (setq #grp #dwg)
        (command "_explode" (entlast))                    ;インサート図形分解
        (setq #ssym (ssget "P"))
        (SKMkGroup #ssym)          ;分解した図形群で名前のないグループ作成

;2008/10/30 YM DEL 本番機障害
;;;       (setq #sym (SKC_GetSymInGroup (ssname #ssym 0)))
          (setq #sym (PKC_GetSymInGroup #ssym)) ;;  TS関数

        (setq #xd2$ (CFGetXData #sym "G_SYM"))
        (if (/= CG_SKK_THR_CNR (CFGetSeikakuToSKKCode #seikaku 3))
          (CFSetXData #sym "G_SYM" #xd-sym$)
        )
        ;;; "G_SINK" 追加 05/18 YM
        (if (= #seikaku CG_SKK_INT_SNK) ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
          (CFSetXData #sym "G_SINK" #xd-sink$)
        );_if

        (if (= #LR "L")        ; 00/02/18 YM MOD
          (setq #set-LR "R")   ; 00/02/18 YM MOD
          (setq #set-LR "L")   ; 00/02/18 YM MOD
        )                      ; 00/02/18 YM MOD
      )
    ;else
      (progn
        (setq #ssym (CFGetSameGroupSS #sym))
        (setq #set-LR "Z")   ; 00/02/18 YM MOD
      )
    )
    (setq #w (nth 3 #xd-sym$))    ;Ｗ寸法
    (setq #x (car #bpt))
    (cond
;;; 2008/09/26YM@DEL      ((= CG_SKK_THR_CNR (CFGetSeikakuToSKKCode #seikaku 3));ｺｰﾅｰｷｬﾋﾞ
;;; 2008/09/26YM@DEL      ;// －９０度回転させる
;;; 2008/09/26YM@DEL        (CFOutStateLog 1 6 "    PKC_MirrorPartsSub:コーナー部材")
;;; 2008/09/26YM@DEL        (setq #ang (dtr (- (rtd #ang) 90)))
;;; 2008/09/26YM@DEL        (command ".rotate" #ssym "" #bpt -90)
;;; 2008/09/26YM@DEL      )

      ;以下TSからｺﾋﾟｰ 2008/09/26 YM ADD-S
      ((= CG_SKK_THR_CNR (CFGetSeikakuToSKKCode #seikaku 3));ｺｰﾅｰｷｬﾋﾞ(右勝手);04/08/09 YM MOD
        ;// －９０度回転させる
        (command ".move" #ssym "" (list 0 0) (list (* -2 #x) 0))
        (setq #bpt (cdr (assoc 10 (entget #sym))))
        (command ".rotate" #ssym "" #bpt 90)
        (setq #ang 0.0)
      )
      ;以下TSからｺﾋﾟｰ 2008/09/26 YM ADD-E

      ;03/11/28 YM MOD 対面ﾌﾟﾗﾝ 配置角度180度部材対応
      (T
        (cond
          ;今までどおりL型ｺﾝﾛ側
          ((and (< 1.5 #ang)(< #ang 3.0))  ;Ｌ型のＹ軸方向の部材の場合 90度
            (command ".move" #ssym "" (list 0 0) (list (* -2 #x) 0))
            (setq #bpt (cdr (assoc 10 (entget #sym))))
            (setq #ang (dtr (- (rtd #ang) 180)))
            (command ".rotate" #ssym "" #bpt 180)
            (command ".move" #ssym "" (list 0 0) (list 0 #w))
          )
          ;左勝手L型対応 04/08/09 YM ADD
          ((and (< 3.2 #ang)(< #ang 6.0))  ;Ｌ型のＹ軸方向の部材の場合 90度(左勝手);04/12/02 G.KIN MOD
;;          ((and (< 3.0 #ang)(< #ang 6.0))  ;Ｌ型のＹ軸方向の部材の場合 90度(左勝手)
            (command ".move" #ssym "" (list 0 0) (list (* -2 #x) 0))
            (setq #bpt (cdr (assoc 10 (entget #sym))))
            (setq #ang (dtr (- (rtd #ang) 180)))
            (command ".rotate" #ssym "" #bpt 180)
            (command ".move" #ssym "" (list 0 0) (list 0 (- #w)))
          )

          ;03/11/28 YM ADD 対面ﾌﾟﾗﾝの背面ｷｬﾋﾞ用 配置角度180度部材対応
          ((and (< 3.0 #ang)(< #ang 6.0))  ;04/12/02 G.KIN MOD
;;          ((< 6.0 #ang)
            (if (= #seikaku CG_SKK_INT_SNK)
              (command ".move" #ssym "" (list 0 0) (list    (* -2 #x)     0))
              (command ".move" #ssym "" (list 0 0) (list (+ (* -2 #x) #w) 0))
            )
            (setq #bpt (cdr (assoc 10 (entget #sym))));04/08/09 YM DEL
          )
          (T ;それ以外 ｼﾝｸ側配置角度=0
            (setq #one (CFGetSeikakuToSKKCode #seikaku 1))
            (if (or (= #one CG_SKK_ONE_SNK) (= #one CG_SKK_ONE_WTR))
              (command ".move" #ssym "" (list 0 0) (list (* -2 #x) 0))
              ;else
              (command ".move" #ssym "" (list 0 0) (list (- (* -2 #x) #w) 0))
            )
          )
        );_cond
      )

;03/11/28 YM MOD 配置角度180度部材対応
;;;      (T
;;;        (if (/= (fix #ang) 0)  ;Ｌ型のＹ軸方向の部材の場合
;;;          (progn
;;;            (CFOutStateLog 1 6 "  PKC_MirrorPartsSub:Ｌ型Ｙ軸方向部材")
;;;            (if (/= (fix #x) 0)
;;;              (progn
;;;                (command ".move" #ssym "" (list 0 0) (list (* -2 #x) 0))
;;;                (setq #bpt (cdr (assoc 10 (entget #sym))))
;;;              )
;;;            )
;;;            (setq #ang (dtr (- (rtd #ang) 180)))
;;;            (command ".rotate" #ssym "" #bpt 180)
;;;            (command ".move" #ssym "" (list 0 0) (list 0 #w))
;;;          );_(progn
;;;          (progn
;;;            (setq #one (CFGetSeikakuToSKKCode #seikaku 1))
;;;            (if (or (= #one CG_SKK_ONE_SNK) (= #one CG_SKK_ONE_WTR))
;;;              (command ".move" #ssym "" (list 0 0) (list (* -2 #x) 0))
;;;              (command ".move" #ssym "" (list 0 0) (list (- (* -2 #x) #w) 0))
;;;            )
;;;          );_(progn
;;;        )
;;;      )


    );_cond

    (setq #bpt      (cdr (assoc 10 (entget #sym))))

    ;P型ﾌｰﾄﾞ(性格ｺｰﾄﾞ328)が存在すればｼﾝﾎﾞﾙ図形を格納
    ;2010/11/10 YM ADD
    (if CG_HOOD_FLG ;ﾚﾝｼﾞﾌｰﾄﾞを仮に(0,0)に配置したとき
      (if (or (equal (nth 9  #xd-lsym$) 328 0.01)
              (equal (nth 9  #xd-lsym$) 320 0.01))
        (setq CG_P_HOOD_SYM #sym)
      );_if
    );_if

    ;// 拡張データの再設定
    (CFSetXData #sym "G_LSYM"
      (list
        #dwg                ;1 :本体図形ID      :『品番図形』.図形ID
        #bpt                ;2 :挿入点          :配置基点
        #ang                ;3 :回転角度        :配置回転角度
        (nth 3  #xd-lsym$)  ;4 :工種記号        :CG_Kcode
        (nth 4  #xd-lsym$)  ;5 :SERIES記号    :CG_SeriesCode
        (nth 5  #xd-lsym$)  ;6 :品番名称        :『品番図形』.品番名称
        #set-LR             ;7 :L/R区分         :『品番図形』.部材L/R区分
        (nth 7  #xd-lsym$)  ;8 :扉図形ID        :
      (if (/= #LR "Z")
        ""                ;9 :扉開き図形ID    : HOPE-0351 01/02/28 YM
        (nth 8  #xd-lsym$)
      );_if
        (nth 9  #xd-lsym$)  ;10:性格CODE      :『品番基本』.性格CODE
        (nth 10 #xd-lsym$)  ;11:複合フラグ      :０固定（単独部材）
        (nth 11 #xd-lsym$)  ;12:配置順番号      :配置順番号(1～)
        (nth 12 #xd-lsym$)  ;13:用途番号        :『品番図形』.用途番号
        (nth 13 #xd-lsym$)  ;14:寸法Ｈ          :『品番図形』.寸法Ｈ
        (nth 14 #xd-lsym$)  ;15:断面指示の有無  :断面指示の有無
        (nth 15 #xd-lsym$)  ;16:分類(ｷｯﾁﾝ"A" or 収納"D") : 2011/07/04 YM ADD
      )
    )
    (KcSetG_OPT #sym) ; 拡張ﾃﾞｰﾀ"G_OPT"ｾｯﾄ 01/02/16 MH ADD
    (setq #i (1+ #i))
  );repeat
);PKC_MirrorPartsSub

;<HOM>*************************************************************************
; <関数名>    : PKC_MoveParts
; <処理概要>  : 右勝手のときは部材移動して挿入基点を移動して(0,0)にする
; <戻り値>    :
; <作成日>    : 2009/11/23 YM ADD 収納拡大
; <備考>      :
;*************************************************************************>MOH<
(defun PKC_MoveParts (
  /
  #BPT #I #MAGU #QRY$ #SS #SSYM #SYM #X-MOVE #XDLSYM$
  )
  ;移動量
  (setq #magu (nth (+ (* 100 CG_D_EXTEND_KAI) 55) CG_GLOBAL$))
  (setq #qry$
    (CFGetDBSQLRec CG_DBSESSION "間口"
      (list (list "間口記号" #magu 'STR))
    )
  )
  (setq #x-move (nth 2 (car #qry$)))
         
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (setq #i 0)
  ;挿入基点を(0,0)にするための移動
  (repeat (sslength #ss)
    (setq #sym (ssname #ss #i))
    (setq #ssym (CFGetSameGroupSS #sym))
    (command ".move" #ssym "" (list 0 0) (list #x-move 0))
    (setq #bpt (cdr (assoc 10 (entget #sym))))
    (setq #xdLSYM$ (CFGetXData #sym "G_LSYM"))
    (CFSetXData #sym "G_LSYM"
      (CFModList
        #xdLSYM$
        (list (list 1 #bpt))
      )
    )
    (setq #i (1+ #i))
  );repeat
  (princ)
);PKC_MoveParts

;<HOM>*************************************************************************
; <関数名>    : PKC_GetLRParts
; <処理概要>  : 反転部材を取得する
; <戻り値>    :
;         STR : 図形ＩＤ
; <作成>      : 1999-07-17
; <備考>      : 2003/05/28 YM 戻り値追加
;*************************************************************************>MOH<
(defun PKC_GetLRParts (
    &xd-lsym$   ;レイアウト用部材拡張データ
    /
    #LR
    #qry$
    #seri$
    #msg #XD-LSYM$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKC_GetLRParts ////")
  (CFOutStateLog 1 1 " ")

  (setq #seri$ (CFGetXRecord "SERI"))
  (if #seri$
    (progn
      (setq CG_DBNAME      (nth 0 #seri$))
      (setq CG_SeriesCode  (nth 1 #seri$))
      (setq CG_BrandCode   (nth 2 #seri$))
    )
  )
  ;// 共通データベースへの接続
  (if (= CG_CDBSESSION nil)
    (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  )
  ;// SERIES別データベースへの接続
  (if (= CG_DBSESSION nil)
    (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
  )
  (setq #LR  (nth 6 &xd-lsym$))              ;LR区分
  (if (= #LR "L")    ; 00/02/18 YM MOD
    (setq #LR "R")   ; 00/02/18 YM MOD
    (setq #LR "L")   ; 00/02/18 YM MOD
  )   ;反転部材を取得するため

  (setq #qry$
;;;    (car; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
      (CFGetDBSQLHinbanTable "品番図形"
         (nth 5 &xd-lsym$)
         (list
           (list "品番名称"      (nth 5 &xd-lsym$)          'STR)
           (list "LR区分"        #LR                        'STR)
           (list "用途番号"      (rtois (nth 12 &xd-lsym$)) 'INT)
         )
      )
;;;    ); 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
  )
  (if (= #qry$ nil)
    (progn
      (CFAlertErr "反転部材が見つかりませんでした")
      (CFOutStateLog 0 1 "反転部材が見つかりませんでした")
      (CFOutStateLog 0 1 "『品番図形』にレコードがありませんでした")
      nil       ; 00/02/18 YM MOD
      (*ERROR*) ; 00/02/18 YM MOD
    )
  ;else
    (progn
      (CFOutStateLog 1 1 "*** 取得ﾚｺｰﾄﾞ ***")
      (CFOutStateLog 1 1 #qry$)

      (if (= (length #qry$) 1) ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD
        (progn
          (setq #qry$ (car #qry$))
        )
        (progn ; 複数ﾋｯﾄしたときはｴﾗｰ
          (setq #msg (strcat "『品番図形』にレコードが複数ありました.\nPKC_GetLRParts"))
          (CFOutStateLog 0 1 #msg)
          (CFAlertMsg #msg)
          (*error*)
        )
      );_if                    ; 00/02/16 @YM@ ﾁｪｯｸ強化 ADD

      (CFOutStateLog 1 6 (strcat "  PKC_GetLRParts:反転部材=[" (nth 6 #qry$) "]")) ; 08/06/28 YM OK!
      ;// 図形ＩＤを返す
;;;01/02/28YM@      (nth 7 #qry$)   ; 00/02/18 YM MOD
      (nth 6 #qry$) ; 08/06/28 YM OK! (DWG,展開ID)==>DWG
    )
  )
);PKC_GetLRParts

;<HOM>*************************************************************************
; <関数名>    : PKStretchFloorFiler
; <処理概要>  : ﾌﾛｱﾌｨﾗｰの伸縮処理(ﾐﾗｰ反転時)
; <戻り値>    : なし
; <作成>      : 00/06/26 YM
; <備考>      :
;*************************************************************************>MOH<
(defun PKStretchFloorFiler (
  &sym      ;シンボル図形
  &val_w    ;寸法Ｗ
  &val_d    ;寸法Ｄ
  &val_h    ;寸法Ｈ
  /
  #VAL_D #VAL_H #VAL_W #VIEWEN #XD$
  )
  (command "_layer" "u" "N_*" "")
  (command "_layer" "on" "M_*" "")
  (setq #viewEn (MakeWorkView)) ; 00/02/29 YM ADD

  (setq #xd$ (CFGetXData &sym "G_SYM"))

  (setq #val_w (if (/= (nth 3 #xd$) &val_w) &val_w 0))
  (setq #val_d (if (/= (nth 4 #xd$) &val_d) &val_d 0))
  (setq #val_h (if (/= (nth 5 #xd$) &val_h) &val_h 0))

  ;// 部材の拡張ﾃﾞｰﾀのｻｲｽﾞを更新
  (CFSetXData &sym "G_SYM"
    (CFModList
      #xd$
      (list
        (list 11 #val_w) ;伸縮フラグＷ
        (list 12 #val_d) ;伸縮フラグＤ
        (list 13 #val_h) ;伸縮フラグＨ
      )
    )
  )

  (command "_view" "S" "TEMP_Fil")
  (StretchPartsSub &sym)
  (command "_view" "R" "TEMP_Fil")

  (if (/= #viewEn nil) (entdel #viewEn)) ; 00/02/29 YM ADD
  (princ)
);PKStretchFloorFiler

;<HOM>*************************************************************************
; <関数名>    : C:KPRefreshCAB
; <処理概要>  : ｷｬﾋﾞﾈｯﾄ再配置ｺﾏﾝﾄﾞ(最新のﾏｽﾀdwgを反映する目的)
; <戻り値>    : なし
; <作成日>    : 01/07/23 YM
; <備考>      : 特注、躯体以外で"G_SYM"をもつ部材
;　             再配置後にG_LSYM,G_SINK,G_OPTを再セット
;               ｺﾝﾛ,ｼﾝｸ側面図移動、扉貼り直し。基準ｱｲﾃﾑなし状態
;*************************************************************************>MOH<
(defun C:KPRefreshCAB (
  /
  #DBASEPT #EGASCABSYM #EGASSYM #EN0 #ESNKCABSYM #ESNKSYM #I #ISKK
  #RANG #SDWG #SS #SSNEWSYM #SSOLDSYM #SYM #TKUTAIFLG #TTOKUFLG
  #XDLSYM$ #XDOPT$ #XDSNK$ #XDSYM$ #sym$ #ssARW #QRY0$
  #QRY$ #SYNO ; 01/08/24 YM ADD
  #SEC #TSEKISAN ; 01/09/03 YM ADD
#BIKOU #DUM1 #DUM2 #HINMEI #XDWRKT$ ; 03/01/28 YM ADD
#RD #RH #RNEW_D #RNEW_H #RNEW_W #RW #XDNEWSYM$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPRefresh ////")
  (CFOutStateLog 1 1 " ")

  (StartUndoErr);// コマンドの初期化
  (CFCmdDefBegin 7);00/09/26 SN ADD

  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (setq #tTOKUflg nil #tKUTAIflg nil)
      ; 側面図移動に使う 01/07/17 YM ADD
      (setq #eGASSYM    nil)
      (setq #eGASCABSYM nil)
      (setq #eSNKSYM    nil)
      (setq #eSNKCABSYM nil)
      (setq #sym$ nil) ; 再配置後のｼﾝﾎﾞﾙ図形名ﾘｽﾄ
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        (cond
          ((CFGetXData #sym "G_TOKU")
            (setq #tTOKUflg T)  ; 特注ｷｬﾋﾞを含んでいる-->後で警告する
          )
          ((CFGetXData #sym "G_KUTAI")
            (setq #tKUTAIflg T) ; 躯体を含んでいる-->後で警告する
          )
          (T ; 再配置する
            (setq #xdLSYM$ (CFGetXData #sym "G_LSYM"))
            (setq #xdSYM$  (CFGetXData #sym "G_SYM"))
            ; 01/12/20 YM ADD-S
            (setq #rW (nth 3 #xdSYM$))
            (setq #rD (nth 4 #xdSYM$))
            (setq #rH (nth 5 #xdSYM$))
            ; 01/12/20 YM ADD-E
            (setq #xdOPT$  (CFGetXData #sym "G_OPT"))
            (setq #xdSNK$  (CFGetXData #sym "G_SINK"))
            (setq #dBasePT (cdr (assoc 10 (entget #sym)))) ; 配置位置
            (setq #rANG (nth 2 #xdLSYM$));配置角度
            (setq #sDWG (nth 0 #xdLSYM$));図形ID
            (setq #iSKK (nth 9 #xdLSYM$));性格CODE
            ; 元図形削除
            (setq #ssOLDSYM (CFGetSameGroupSS #sym))
            (command "_erase" #ssOLDSYM "")
            (command "_purge" "BL" "*" "N")
            (command "_purge" "BL" "*" "N")
            (command "_purge" "BL" "*" "N")

            (command "_insert" (strcat CG_MSTDWGPATH #sDWG) #dBasePT 1 1 (rtd #rANG))
            (command "_explode" (entlast))  ;インサート図形分解
            (setq #ssNEWSYM (ssget "P"))
            (setq #en0 (ssname #ssNEWSYM 0))

            (SKMkGroup #ssNEWSYM) ;分解した図形群で名前のないグループ作成
;;;           (setq #sym (SKC_GetSymInGroup #en0)) ; ｼﾝﾎﾞﾙ取得
              (setq #sym (PKC_GetSymInGroup #ssNEWSYM))      ;;  2005/08/03 G.YK ADD

            ; 01/12/20 YM ADD-S
            (setq #xdNEWSYM$  (CFGetXData #sym "G_SYM"))
            (setq #rNEW_W (nth 3 #xdNEWSYM$))
            (setq #rNEW_D (nth 4 #xdNEWSYM$))
            (setq #rNEW_H (nth 5 #xdNEWSYM$))
            ; 01/12/20 YM ADD-E

            ; 品番基本検索
            (setq #Qry0$
              (CFGetDBSQLRec CG_DBSESSION "品番基本"
                (list
                  (list "品番名称" (nth 5 #xdLSYM$) 'STR)
                )
              )
            )
            ;// 拡張データの再設定 01/07/31 "G_LSYM"を更新する
            (if (and #Qry0$ (= (length #Qry0$) 1))
              (progn
                ; 01/09/03 YM ADD-S
                (if (equal 1.0 (nth 10 (car #Qry0$)) 0.1) ; 01/09/03 YM MOD 品番基本.積算F
                  (setq #tSEKISAN T)
                  (setq #tSEKISAN nil)
                );_if
                (setq #iskk (fix (nth 3 (car #Qry0$))))
                (setq #sec 0) ; デフォルトで断面指示 OFF
                (if (or
                  (= #iskk CG_SKK_INT_SCA);シンクキャビ ; 01/08/31 YM MOD 112-->ｸﾞﾛｰﾊﾞﾙ化
                  (= #iskk CG_SKK_INT_GCA);コンロキャビ（床置きオーブン） ; 01/08/31 YM MOD 113-->ｸﾞﾛｰﾊﾞﾙ化
                  (= #iskk CG_SKK_INT_CNR);コーナーキャビ（フロア） ; 01/08/31 YM MOD 115-->ｸﾞﾛｰﾊﾞﾙ化
                  (= #iskk 125);コーナーキャビ（ウォール）
                  (= #iskk CG_SKK_INT_GAS);ビルトインコンロ ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
                  (= #iskk CG_SKK_INT_RNG);レンジフード ; 01/08/31 YM MOD 320-->ｸﾞﾛｰﾊﾞﾙ化
                  (= #iskk CG_SKK_INT_RNG_MT);レンジフード ; 02/03/27 YM MOD 328-->ｸﾞﾛｰﾊﾞﾙ化 ﾏｳﾝﾄ型ﾌｰﾄﾞ対応
                  (and (= #tSEKISAN nil)(= #iskk CG_SKK_INT_SUI));水栓 ; 01/08/31 YM MOD 510-->ｸﾞﾛｰﾊﾞﾙ化 01/09/03 YM MOD 積算F=1でないなら
                  ); or
                  (setq #sec 1)
                ); if

                (CFSetXData #sym "G_LSYM"
                  (CFModList #xdLSYM$
                    (list
                      (list 9  #iskk) ;10:性格CODE :『品番基本』.性格CODE
                      (list 14 #sec)  ;15:断面指示
                    )
                  )
                )
              )
              (CFSetXData #sym "G_LSYM" #xdLSYM$) ; 性格ｺｰﾄﾞを更新しない
            );_if

            ; 01/08/24 YM ADD-S ///////////////////////////////////////////
            (setq #sYNO (itoa (nth 12 #xdLSYM$))) ; "用途番号"
            (setq #qry$
              (CFGetDBSQLRec CG_DBSESSION "品番図形"
                (list
                  (list "品番名称"   (nth 5 #xdLSYM$) 'STR)
                  (list "LR区分"     (nth 6 #xdLSYM$) 'STR)
        ;;;         (list "取付タイプ" #TYPE 'INT)
                  (list "用途番号"   #sYNO            'INT)
                )
              )
            )
            ;// 拡張データの再設定 01/07/31 "G_LSYM"を更新する
            (if (and #qry$ (= (length #qry$) 1))
              (progn
                (setq #xdLSYM$ (CFGetXData #sym "G_LSYM")) ; 02/03/27 YM ADD 性格ｺｰﾄﾞが更新されない
                (CFSetXData #sym "G_LSYM"
                  (CFModList #xdLSYM$
                    (list
;;;                     (list 13 (fix (nth 6 (car #qry$))))
                      (list 13 (fix (nth 5 (car #qry$))));2008/11/20 YM MOD [品番図形]
                    ) ; 品番図形.寸法H
                  )
                )
              )
              (progn
                (CFSetXData #sym "G_LSYM" #xdLSYM$) ; 寸法Ｈを更新しない
              )
            );_if
            ; 01/08/24 YM ADD-E ///////////////////////////////////////////

;;;01/09/03YM@MOD           (if #xdOPT$ (CFSetXData #sym "G_OPT" #xdOPT$))
            ; 入替えｺﾏﾝﾄﾞ時の処理を追加 01/09/03 YM MOD-S
            ; ⑩拡張ﾃﾞｰﾀ "G_OPT" セット
            (KcSetG_OPT #sym)
            ; 入替えｺﾏﾝﾄﾞ時の処理を追加 01/09/03 YM MOD-E

            (if #xdSNK$ (CFSetXData #sym "G_SINK" #xdSNK$))

            ; 側面図移動に使う 01/07/17 YM ADD
            (cond
              ((= #iSKK CG_SKK_INT_GAS)(setq #eGASSYM    #sym)) ; ｺﾝﾛの場合 ; 01/08/31 YM MOD 210-->ｸﾞﾛｰﾊﾞﾙ化
              ((= #iSKK CG_SKK_INT_GCA)(setq #eGASCABSYM #sym)) ; ｺﾝﾛｷｬﾋﾞの場合 ; 01/08/31 YM MOD 113-->ｸﾞﾛｰﾊﾞﾙ化
              ((= #iSKK CG_SKK_INT_SNK)(setq #eSNKSYM    #sym)) ; ｼﾝｸの場合 ; 01/08/31 YM MOD 410-->ｸﾞﾛｰﾊﾞﾙ化
              ((= #iSKK CG_SKK_INT_SCA)(setq #eSNKCABSYM #sym)) ; ｼﾝｸｷｬﾋﾞの場合 ; 01/08/31 YM MOD 112-->ｸﾞﾛｰﾊﾞﾙ化
            );_cond

            ; 01/12/20 YM ADD-S 伸縮していたものは再伸縮する
            (if (not (equal #rNEW_W #rW 0.0001))
              (SKY_Stretch_Parts #sym #rW #rNEW_D #rNEW_H)
            );_if
            (if (not (equal #rNEW_D #rD 0.0001))
              (SKY_Stretch_Parts #sym #rW #rD #rNEW_H)
            );_if
            (if (not (equal #rNEW_H #rH 0.0001))
              (SKY_Stretch_Parts #sym #rW #rD #rH)
            );_if
            ; 01/12/20 YM ADD-E 伸縮していたものは再伸縮する

            (setq #sym$ (append #sym$ (list #sym)))
          )
        );_cond

        (setq #i (1+ #i))
      );repeat

      ;// 扉面の貼り付け
      (PCD_MakeViewAlignDoor #sym$ 3 nil)
      (command "_purge" "BL" "*" "N")
      ; 基準ｷｬﾋﾞ=nil
      (CFSetXRecord "BASESYM" nil)
      ; 基準ｷｬﾋﾞ矢印
      (setq #ssARW (ssget "X" '((-3 ("G_ARW")))))
      (if (and #ssARW (< 0 (sslength #ssARW)))
        (command "_erase" #ssARW "")
      );_if

      ; 側面図移動 01/07/17 YM ADD
      (if (and #eGASSYM #eGASCABSYM)
        (PKC_MoveToSGCabinetSub #eGASSYM #eGASCABSYM)
      );_if
      (if (and #eSNKSYM #eSNKCABSYM)
        (PKC_MoveToSGCabinetSub #eSNKSYM #eSNKCABSYM)
      );_if

      (if (or #tTOKUflg #tKUTAIflg)
        (CFAlertMsg "\n特注ｷｬﾋﾞ,洗面ｶｳﾝﾀｰ,躯体は再配置しませんでした。")
      );_if
      (princ "\n部材を再配置しました。")
    )
  );_if

  ;04/05/26 YM ADD
  (command "_REGEN")

  (setq *error* nil)
  (command "_layer" "on" "M_*" "") ; 07/07 YM ADD(ﾐﾗｰ反転時"OF"になるものがある)
  (CFCmdDefFinish);00/09/26 SN ADD
  (princ)

);C:KPRefreshCAB

(princ)
