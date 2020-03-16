; 03/04/01 YM MOD DR??** ==> DR???** 変更済み

;;; 検索用
;;;(defun PCD_AlignDoor           扉図形を配置する
;;;(defun C:ChgDr                : 扉面変更(全体)
;;;(defun C:ChgDrCab             : 扉面変更(個別キャビネット)
;;;(defun PCD_MakeViewAlignDoor <---プラン検索扉貼付け
;;;(defun GetXYMaxMinFromPT$  点列のX最大,最小,Y最大,最小ﾘｽﾄを返す
;;;(defun KP_WritePOLYLINE    ﾎﾟﾘﾗｲﾝ上に同じﾎﾟﾘﾗｲﾝをかく
;;;(defun KP_MEJIRotate       目地をその場で180度回転させる
;;;(defun KP_MakeHantenMEJI   目地の定義を裏表反転させたﾎﾟﾘﾗｲﾝを返す
;;;(defun KPstrViewLayer      #strViewLayer を求める
;;;(defun KPGetDoorGroup      DoorGroup図形名を求める
;;;(defun KP_Get340SSFromDrgroup   扉"GROUP"図形(#Door)から340ﾒﾝﾊﾞｰ図形の選択ｾｯﾄを取得
;;;(defun KP_Get340SSFromDrgroup$  扉"GROUP"図形ﾘｽﾄ(#Door$)から全340ﾒﾝﾊﾞｰ図形の選択ｾｯﾄを取得
;;;(defun KP_GetDoorBasePT         扉"GROUP"図形から扉部品を見て"POINT"図形を検索し位置座標(2D)を取得
;;;(defun KP_CheckDrgroup          扉"GROUP"図形ﾘｽﾄのうち&flgと合う扉"GROUP"図形を返す
;;;(defun KPGetEnDoor              扉ｸﾞﾙｰﾌﾟのﾒﾝﾊﾞｰの1つを返す
;;;(defun KcGetDoorInsertPnt       扉図形の挿入3D点を求める
;;;(defun PcGetLRButtomPos         ポリラインと設置角度から右点、左点を算出
;;;(defun SKD_GetGroupSymbole
;;;(defun PKD_MakeSqlBase
;;;(defun SKD_GetLeftButtomPos
;;;(defun SKD_GetRightButtomPos
;;;(defun SKD_ChangeLayer
;;;(defun SKD_DeleteNotView
;;;(defun SKD_DeleteNotView_TOKU 扉図形を伸縮作業画層に移動
;;;(defun SCD_GetDoorGroupName      扉図形のグループ作成
;;;(defun SKD_GetDoorPos
;;;(defun SKD_FigureExpansion   <--- 伸縮
;;;(defun GetGruopMaxMinCoordinate      "GROUP"中のLINE,POLYLINE範囲の最大最小を求める
;;;(defun SKD_Expansion
;;;(defun SKD_DeleteInsertLayer
;;;(defun SKD_DeleteHatch
;;;(defun PKD_EraseDoor
;;;(defun SKD_ChgSeriesDlg
;;;(defun SetLayer ( / )     表示画層の設定を行う


;;;<HOM>***********************************************************************
;;; <関数名>    : ALL_DBCONNECT
;;; <処理概要>  : ｼﾘｰｽﾞ別,共通DB再接続
;;; <戻り値>    : なし
;;; <作成>      :;2011/12/05 YM ADD
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun ALL_DBCONNECT ( / )
	; ARX再ロード
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
  )
	;(command "delay" "500")

	;ｼﾘｰｽﾞ別DB再接続
	(DBDisConnect CG_DBSESSION)
	(setq CG_DBSESSION nil)
	;(command "delay" "500")
	(setq CG_DBSESSION  (dbconnect CG_DBNAME  "" ""))			

	;共通DB再接続
	(DBDisConnect CG_CDBSESSION)
	(setq CG_CDBSESSION nil)
	;(command "delay" "500")
	(setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))

	(if (= CG_DBSESSION CG_CDBSESSION)
		;同じならもう一回
		(setq CG_CDBSESSION  (dbconnect CG_CDBNAME  "" ""))
	);_if

	(princ)
);ALL_DBCONNECT

;;;<HOM>*************************************************************************
;;; <関数名>    : C:MDB
;;; <処理概要>  : その場でDB接続
;;; <作成>      : 2011/12/27 YM ADD
;;;*************************************************************************>MOH<
(defun C:MDB( / ) (ALL_DBCONNECT));C:MDB

;;;<HOM>***********************************************************************
;;; <関数名>    : PCD_AlignDoor
;;; <処理概要>  : 扉図形を配置する
;;; <戻り値>    : 成功： T      失敗：nil
;;; <作成>      :
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun PCD_AlignDoor (
  &Obj$          ;扉貼付対象のシンボル
  &SetFace       ;貼り付ける面の種類(2:2D-Ｐ面 3:3D目地領域)
  &EraseFlg      ;既存扉面の削除フラグ (T:削除 nil:削除しない)
  /
  #DData$        ; 扉面指定のあるエンティティ名格納用
  #enData$       ; 図形データ格納用
  #DbGet         ; データベースから取得したデータ格納用
  #enSymName     ; シンボルのエンティティ名を取得する
  #symData$      ; シンボルの拡張データ格納用
  #strViewLayer  ; 扉面用表示画層名格納用
  #strFileName   ; インサート図形ファイル名格納用
  #pos$          ; インサート座標値格納用
  #Door          ; グループ化された扉面データのグループのエンティティ名
  #INO
  #Temp$         ; テンポラリリスト
  #iLoop         ; ループ用
  #iFlag         ; ループアウト用フラグ
  #enName        ; foreach 用
  #ANG #ANG2 #DOORP #DRANG #EDELDOORBRK_D$ #EDELDOORBRK_H$ #EDELDOORBRK_W$
  #EG #EN$ #ENANG #FF #GG$ #GROUP$ #IVP #LEFTDOWN_PT #MEJI #MINMAX$ #OS
  #PT #RIGHTUP_PT #SM #VECTOR #VP #XLINE_H #XLINE_W #TOKU_DRGRNAME #DOOR$
  #CABANG #DOORANG #GNAM #MEJI$ #MEJIDATA$ #SURFACE #SYM0 #XDMEJI$ #MEJI_LAY
  #NEWMEJI #NEWMEJI$ #SSDOOR #MVPT #CG_DOOR_MOVE #XLINE_D
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PCD_AlignDoor ////")
  (CFOutStateLog 1 1 " ")

  (setq #os (getvar "OSMODE")); 00/02/18 YM ADD from lemon 2/9
  (setq #sm (getvar "SNAPMODE")); 00/02/18 YM ADD from lemon 2/9
  (setvar "OSMODE"     0); 00/02/18 YM ADD from lemon 2/9
  (setvar "SNAPMODE"   0); 00/02/18 YM ADD from lemon 2/9

	;2012/06/14 YM ADD-S 扉窓番号=30,46追加⇒EASYからKPCAD連携したとき、扉一括変更でMJ,FJ(扉窓番号=30,46)に変更しても扉が見えない
  (command "_purge" "BL" "*" "N")
  (command "_purge" "BL" "*" "N")


  ;; 扉図形用アプリケーション名の登録
  (regapp SKD_EXP_APP)

  ;; 伸縮作業用テンポラリ画層の作成 ;追加  00/02/15 MH ADD
  (if (tblsearch "LAYER" SKD_TEMP_LAYER)
    (progn
      (command "_layer" "U" SKD_TEMP_LAYER "")  ; 警告メッセージ対策で2文に分けた  Uﾛｯｸ解除
      (command "_layer" "ON" SKD_TEMP_LAYER "T" SKD_TEMP_LAYER "")  ; ON表示 Tﾌﾘｰｽﾞ解除
     ); end of progn        N新規 C色 L線種
    (command "_layer" "N" SKD_TEMP_LAYER "C" 1 SKD_TEMP_LAYER "L" SKW_AUTO_LAY_LINE SKD_TEMP_LAYER "")
  )
  ;// 現在のビューを保存する
  (command "_view" "S" "TEMP")
  ;// 既存の扉面が貼り付けられていれば削除
  (if CG_TOKU
    (progn ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中は扉の貼り直しをせずに既存扉を使用する
      (setq #Door$ (KPGetDoorGroup (car &Obj$))) ; 01/05/11 YM
;;;01/05/18YM@      (setq #Door (KPGetDoorGroup (car &Obj$))) ; 01/05/11 YM
    )
    (if (= &EraseFlg T)
      (foreach #en &Obj$
        (PKD_EraseDoor #en)
      )
    );_if
  );_if

  (if (or (= &SetFace nil) (= &SetFace 3))
    (progn
      ;// 3D目地領域の取得
      (setq #Temp$ (ssget "X" '((-3 ("G_MEJI" (1070 . 1))))))
      (if (/= #Temp$ nil)
        (progn
          (setq #iLoop 0)
          (while (< #iLoop (sslength #Temp$))
            (setq #MEJI (ssname #Temp$ #iLoop))   ; 01/04/04 YM ADD 使用区分=1のみ取得
            (setq #xdMEJI$ (CFGetXData #MEJI "G_MEJI"))
            (if (= 1 (nth 0 #xdMEJI$)) ; 使用区分=1のみ取得
              (progn
                (setq #MEJI$ (entget #MEJI))
                (setq #vector (cdr (assoc 210 #MEJI$))); MEJIﾎﾟﾘﾗｲﾝ押し出し方向
                (setq #surface (nth 1 #xdMEJI$)) ; 正面:0,3 背面:4 右側面:6 左側面:5
                ; 取得図形データから同一グループ内のシンボルデータを取得する
                (setq #Sym0 (SKD_GetGroupSymbole #MEJI$))
                (setq #CABang (nth 2 (CFGetXData #Sym0 "G_LSYM"))) ; ｷｬﾋﾞ配置角度

                (setq #DoorANG (angle '(0 0 0) #vector)) ; 扉法線ﾍﾞｸﾄﾙの向き
                (setq #DoorANG (Angle0to360 #DoorANG)) ; 0～360度の値にする
                ;(Angle0to360 <radian>) ; 0～360度の値にする

                ; G_MEJIの定義が逆だったら削除して再作成
;;;               (cond
;;;                 ((or (= 0 #surface)(= 3 #surface)) ; 正面のみ対応
;;;                   (if (equal (Angle0to360 (+ #CABang (dtr -90))) #DoorANG 0.001) ; MEJIが正しく定義されているか
;;;                     nil ; 何もしない
;;;                     (progn ; MEJI不正==>削除再作成
;;;                       (setq #newMEJI (KP_MakeHantenMEJI #MEJI #Sym0)) ; MEJI再作成
;;;                       (setq #newMEJI$ (entget #newMEJI))
;;;                       ; 画層を #MEJI_lay にする
;;;                       (setq #MEJI_lay (cdr (assoc 8 #MEJI$))); MEJI画層
;;;                       (entmod (subst (cons 8 #MEJI_lay) (assoc 8 #newMEJI$) #newMEJI$))
;;;                       (CFSetXData #newMEJI "G_MEJI" #xdMEJI$) ; 拡張ﾃﾞｰﾀｾｯﾄ
;;;                       (setq #gnam (SKGetGroupName #Sym0)) ; ｸﾞﾙｰﾌﾟ名取得
;;;                       ;;; newMEJIのｸﾞﾙｰﾌﾟ化
;;;                       (command "-group" "A" #gnam #newMEJI "")
;;;                        ;; 3D 目地のハッチングを消す
;;;                        (SKD_DeleteHatch #MEJI)
;;;                       (entdel #MEJI) ; 既存MEJI削除
;;;                       (setq #MEJI #newMEJI) ; 新しい目地領域を使用
;;;                     )
;;;                   );_if
;;;                 )
;;;                 ((= 4 #surface) ; 背面
;;;                   nil ; 未対応 01/04/06 YM
;;;                 )
;;;                 ((= 6 #surface) ; 右側面
;;;                   nil ; 未対応 01/04/06 YM
;;;                 )
;;;                 ((= 5 #surface) ; 左側面
;;;                   nil ; 未対応 01/04/06 YM
;;;                 )
;;;                 (T
;;;                   nil ; 未対応 01/04/06 YM
;;;                 )
;;;               );_cond

                (setq #DData$ (cons #MEJI #DData$)) ; 使用区分=1なら
                (setq #iLoop (+ #iLoop 1))
              )
            );_if

          );while
        )
      )
    )
  );_if

  (if (or (= &SetFace nil) (= &SetFace 2))
    (progn
      ;// 2D扉領域の取得
      (setq #Temp$ (ssget "X" '((-3 ("G_PMEN" (1070 . 7))))))
      (if (/= #Temp$ nil)
        (progn
          (setq #iLoop 0)
          (while (< #iLoop (sslength #Temp$))
            (setq #DData$ (cons (ssname #Temp$ #iLoop) #DData$))
            (setq #iLoop (+ #iLoop 1))
          )
        )
      )
    )
  )

  (setq CG_DOORLST '()) ; 2000/06/21 HT 速度改善のため ADD

  ;; 扉面指定されたデータが存在するかどうかチェック
  (if (/= #DData$ nil)
    (progn    ;; 扉面指定されたデータがあった
      (setq #iNo 0)

      ;; 領域数分ループ
      (while (< #iNo (length #DData$)) ; MEJIの数でﾙｰﾌﾟ

        (setq #enName (nth #iNo #DData$)) ; 図面上の"G_MEJI" (1070 . 1)全体 #DData$
        ;; 図形データ取得
        (setq #enData$ (entget #enName '("*")))  ; 拡張データも含めて取得
        ;; 取得図形データから同一グループ内のシンボルデータを取得する
        (setq #enSymName (SKD_GetGroupSymbole #enData$))

        ; 2000/06/22 [展開図作成]コマンドの時は、速度改善のため
        ; 商品図の場合のみ処理し、コピーする(SCFmat.lsp 展開元図作成 展開図)
        (if (or (and (= CG_OUTCMDNAME "SCFMakeMaterial")
              (= CG_OUTSHOHINZU (substr (cdr (assoc 8 #enData$)) 6 2))) ; 01/05/28 YM 施工図でなく商品図のとき
;;;01/05/28YM@              (= CG_OUTSEKOUZU (substr (cdr (assoc 8 #enData$)) 6 2)))
              (/= CG_OUTCMDNAME "SCFMakeMaterial")
            ) ; 2000/06/22 HT 速度改善のため ADD
          (progn
            (if (member #enSymName &Obj$)     ;選択図形以外は処理しない  "G_MEJI"図形の親が選択した対象と同じか
              (if (/= #enSymName nil); シンボルの有無をチェック
                (progn    ; シンボルが存在した
                  (setq #symData$ (CFGetXData #enSymName "G_LSYM"))
                  ;; シンボルからデータを取得できたかどうかのチェック
                  (if (/= #symData$ nil)
                    (progn    ; シンボルの拡張データを取得できた

                      ; 01/09/25 YM ADD-S G_LSYMに扉ｶﾗｰをｾｯﾄする
                      ; 拡張ﾃﾞｰﾀに扉ｼﾘｰｽﾞ&扉ｶﾗｰをｾｯﾄ
                      (if (= &SetFace 3) ; 01/10/31 YM ADD 展開図作成のとき以下の処理は要らない！
                        (progn
                          (if (= CG_DRColCode nil)(setq CG_DRColCode ""))
                          (CFSetXData #enSymName "G_LSYM"
                            (CFModList #symData$
                              (list

                                ; (list 7 (strcat CG_DRSeriCode "," CG_DRColCode)) ;[8]扉ｼﾘｰｽﾞ,扉ｶﾗｰ 01/10/05 YM ADD
                                ; [8]扉ｼﾘｰｽﾞ,扉ｶﾗｰ,取手 02/11/30 YM ADD SX対応 取手情報保持

;;;         ;KPCAD用の仮設定
;;;         (setq CG_DRSeriCode  "C")  ;扉SERIES記号
;;;         (setq CG_DRColCode  "M*")  ;扉COLOR記号
;;;         (setq CG_HIKITE      "D")  ;HIKITE記号

                                (if (or (= CG_HIKITE "")(= CG_HIKITE nil))
                                  (list 7 (strcat CG_DRSeriCode "," CG_DRColCode)) ; 今までどおり
                                  ;else
                                  (list 7 (strcat CG_DRSeriCode "," CG_DRColCode "," CG_HIKITE)) ; SX
                                );_if

                              )
                            )
                          )
                        )
                      );_if
                      ; 01/09/25 YM ADD-E G_LSYMに扉ｶﾗｰをｾｯﾄする

                      ;; データベースからベースID(扉図形ID)の取得
                      (setq #DbGet (PKD_MakeSqlBase #symData$ &SetFace)) ; 扉図形ＩＤ
                      ;; データベースからベースIDを取得できたかどうかチェック
                      (if (/= #DbGet nil)
                        (progn    ; ベースIDを取得できた
                          (setq #strFileName (strcat CG_DRMSTDWGPATH
                                                     SKD_DOOR_CODE       ;  "DR"
                                                     (substr #DbGet 1 5)    ; 03/04/01 YM MOD DR??** ==> DR???** 変更に伴う
                                                     ;;;(substr #DbGet 1 4) ; 03/04/01 YM MOD DR??** ==> DR???** 変更に伴う
                                                     SKD_DOOR_FILE_EXT)  ; ."DWG"
                          )
                          ;; 「DR+ベースID(上4桁).dwg」のファイルの有無をチェック
                          (if (/= (findfile #strFileName) nil)
                            (progn    ; ファイルがあった

                              ; #strViewLayer を求める(関数化 01/05/11 YM)
                              (setq #strViewLayer (KPstrViewLayer #enName #enData$ #DbGet))

                              ;; 座標を得る
                              ;背面の場合は右下点を取る
                              (if (= (substr #strViewLayer 3 2) "04")
                                (setq #Temp$ (SKD_GetRightButtomPos #enName))
                                (setq #Temp$ (SKD_GetLeftButtomPos  #enName))
                              )

                              ;(setq #pos$ (car #Temp$))
                              ;(setq #pos$ (trans
                              ;  (append #pos$ (list (cdr (assoc 38 #enData$)))) #enName 1 0))
                              ; 00/11/08 MH ADD 挿入基点算出部を関数化
                              (setq #pos$ (KcGetDoorInsertPnt #enSymName #enName))

  ;;;(trans pt from to [disp])
  ;;;引数
  ;;;pt : 3D 点または 3D 変位(ベクトル)を表す 3 つの実数のリスト。
  ;;;from : pt の座標系を表す整数コード、項目名、または 3D 押し出しベクト。
  ;;;      整数コードには、次の値の 1 つを指定することができます。
  ;;;0  ワールド(WCS) , 1  ユーザ(現在の UCS)

                              (setq #Temp$ (cdr #Temp$))
                             ;// 背面のP面の押し出し方向が正面と同じケースがあるため角度を反転させる
                              (setq #ang (nth 2 #symData$))

                              ; 00/08/21 ADD MH 00/08/21 DEL MH DRMASTERの変更で不要に
                              ; 背面ならNewPadシステムでは基準図形の裏表を反映させない

                              ; ここで右下点を新関数で取り直す ===>???ｺﾒﾝﾄ解除してみた 01/03/13 YM @@@@@@@@@@@@@@@@@@@@@@@@@
  ;;;                            (if (= (substr #strViewLayer 3 2) "04")
  ;;;                              (setq #pos$ (PcGetLRButtomPos #enName (nth 2 #symData$) "R"))
  ;;;                            );if
                              ; ここで右下点を新関数で取り直す ===>???ｺﾒﾝﾄ解除してみた 01/03/13 YM @@@@@@@@@@@@@@@@@@@@@@@@@

                              (if (= (substr #strViewLayer 3 2) "04") ;背面の場合は右下点を取る
                                (progn
                                  (setq #eg (entget #enSymName))
                                  (setq #pt (cdr (assoc 10 #eg)))
                                  (if (< 100 (distance (list (car #pt) (cadr #pt))
                                                       (list (car #pos$) (cadr #pos$))))
                                    (progn
                                      (setq #ang (- #ang (dtr 180)))
                                    )
                                  )
                                )
                              );_if


    (if CG_TOKU ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ時は扉をINSERTしない 01/05/11 YM ADD
      (progn
;-- 2011/12/19 A.Satoh Del（2011/11/24の改修を元に戻す）- S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;				(if CG_POS_STR
;;;;;      		(progn
;;;;;						;; 扉面図形ファイルを扉面指定領域の左下合わせで
;;;;;						;; インサートする(インサート図形名 挿入位置 X尺度 Y尺度 角度)
;;;;;						(command "_insert" #strFileName #pos$ 1 1 (angtos #ang))
;;;;;
;;;;;						;; インサート図形を分解し、不要な画層のデータは削除し、
;;;;;						;; 残った表示するデータを伸縮作業画層に移動し、グループ化する
;;;;;						(setq #Door (SKD_DeleteNotView (entlast) #strViewLayer))
;;;;;      		)
;;;;;    		)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/12/19 A.Satoh Del（2011/11/24の改修を元に戻す）- E

        ; 現在対象の扉"GROUP"図形#doorを求める==>正面,背面を分けると1つのﾌﾞﾚｰｸﾗｲﾝ位置では
        ; 両方うまく伸縮できない?==>面毎にﾌﾞﾚｰｸﾗｲﾝ位置を調整する

;-- 2011/12/19 A.Satoh Del（2011/11/24の改修を元に戻す）- S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;				(if (= CG_POS_STR nil)
;;;;;					(progn
;;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/12/19 A.Satoh Del（2011/11/24の改修を元に戻す）- E
        ; 現在処理対象は正面?背面? -->判断を扉ｸﾞﾙｰﾌﾟ名で行えるよう修正 "DoorGroup"+("3","4"など)+(番号)
        (setq #door (KP_CheckDrgroup (substr #strViewLayer 4 1) #Door$)) ; 現在処理対象は正面?背面

        ; 扉"GROUP"図形(#Door)から340ﾒﾝﾊﾞｰ図形の選択ｾｯﾄを取得、扉を伸縮画層に移動
        ; ===>複数ｸﾞﾙｰﾌﾟの全ての構成ﾒﾝﾊﾞｰを一度に扉伸縮(これもだめ)==>戻す
;;;       (SKD_DeleteNotView_TOKU (KP_Get340SSFromDrgroup$ #Door$))

        ; D方向伸縮時に扉を移動 01/05/31 YM ADD
        (if #Door ; 01/12/11 YM #Door=nilを回避する
          (setq #ssDOOR (KP_Get340SSFromDrgroup #Door)) ; 扉図形
          (setq #ssDOOR nil) ; 01/12/11 YM #Door=nilを回避する
        );_if


;@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;(setq CG_DOOR_MOVE03 nil)
;;;(setq CG_DOOR_MOVE06 nil)
;@@@@@@@@@@@@@@@@@@@@@@@@@@@

;;;01/09/25YM@DEL       (if CG_DOOR_MOVE
        (if (or CG_DOOR_MOVE06 CG_DOOR_MOVE03) ; 01/09/25 YM MOD
          (progn

            ; 01/09/25 YM ADD-S
            (if (or (and CG_DOOR_MOVE03 (= "03" (substr #strViewLayer 3 2)))  ; 正面扉は移動
                    (and CG_DOOR_MOVE06 (= "06" (substr #strViewLayer 3 2)))) ; 右側面扉は移動
              (progn
                (if (and CG_DOOR_MOVE03 (= "03" (substr #strViewLayer 3 2)))
                  (setq #CG_DOOR_MOVE CG_DOOR_MOVE03)
                );_if

                (if (and CG_DOOR_MOVE06 (= "06" (substr #strViewLayer 3 2)))
                  (setq #CG_DOOR_MOVE CG_DOOR_MOVE06)
                );_if
            ; 01/09/25 YM ADD-E

                ; 01/09/07 YM ADD-S
                ; ｳｫｰﾙｷｬﾋﾞが複数時上記の#DoorANGそのままだと別のｳｫｰﾙｷｬﾋﾞのMEJI角度になる場合あり
                ; 対象ｼﾝﾎﾞﾙ図形のMEJIから扉法線ﾍﾞｸﾄﾙの向きを取得する
                (setq #vector (cdr (assoc 210 (entget #enName)))); MEJIﾎﾟﾘﾗｲﾝ押し出し方向
                (setq #DoorANG (angle '(0 0 0) #vector)) ; 扉法線ﾍﾞｸﾄﾙの向き
                (setq #DoorANG (Angle0to360 #DoorANG)) ; 0～360度の値にする
;;;(if CG_DOOR_MOVE_RIGHT ; 移動方向が特殊
;;; (setq #DoorANG (+ #DoorANG (dtr 90))) ; 01/09/25 扉移動方向が正面ではなく、向かって右方向
;;;);_if
                ; 01/09/07 YM ADD-E

;;;               (if CG_DOOR_MOVE_RIGHT ; 移動方向が特殊 01/09/25 YM ADD
;;;                 nil ; 移動しない
;;;                 (progn
                    (setq #MVPT (pcpolar '(0 0 0) #DoorANG #CG_DOOR_MOVE))
                    ; CG_DOOR_MOVE : 移動量 , #vector : 扉法線ﾍﾞｸﾄﾙ
                    (command "_move" #ssDOOR "" '(0 0 0) #MVPT)
;;;                 )
;;;               );_if

            ; 01/09/25 YM ADD-S
              )
            );_if
            ; 01/09/25 YM ADD-E

          )
        );_if

        (if #ssDOOR ; 01/12/11 YM #Door=nilを回避する
          (SKD_DeleteNotView_TOKU #ssDOOR)
        );_if
;;;       (SKD_DeleteNotView_TOKU (KP_GetDoorSSFromSYM #enSymName)) ; 扉を伸縮画層に移動
;-- 2011/12/19 A.Satoh Del（2011/11/24の改修を元に戻す）- S
;;;;;;-- 2011/11/24 A.Satoh Add - S
;;;;;					)
;;;;;    		)
;;;;;;-- 2011/11/24 A.Satoh Add - E
;-- 2011/12/19 A.Satoh Del（2011/11/24の改修を元に戻す）- E
      )
      (progn

                              ;; 扉面図形ファイルを扉面指定領域の左下合わせで
                              ;; インサートする(インサート図形名 挿入位置 X尺度 Y尺度 角度)
                              (command "_insert" #strFileName #pos$ 1 1 (angtos #ang))
(command "_REGEN")
                              ;; インサート図形を分解し、不要な画層のデータは削除し、
                              ;; 残った表示するデータを伸縮作業画層に移動し、グループ化する
                              (setq #Door (SKD_DeleteNotView (entlast) #strViewLayer))
      )
    );_if       ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ時は扉をINSERTしない 01/05/11 YM ADD

                              ;; 扉面の配置&表示が正常に終了したかどうかのチェック
                              (if (/= #Door nil)
                                (progn    ; 扉面の表示が正常に終了した
                                  ;; 伸縮処理を行う
                                  (if CG_STRETCH
                                    (progn

  ;/////////////////////////////////////////////////////////////////////////////////////
    (if CG_TOKU ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中 ; 01/02/09 YM
      (progn
        ; 扉ｸﾞﾙｰﾌﾟのﾒﾝﾊﾞｰの1つを返す==>group名取得 01/05/11 YM ADD

;;;       (if (= (substr #strViewLayer 3 2) "04") ;背面の場合は右下点を取る
;;;         (princ)
;;;       );_if

        ; KPGetEnDoor:扉ｸﾞﾙｰﾌﾟのﾒﾝﾊﾞｰの1つを返す
        (setq #TOKU_DrGrName (SKGetGroupName (KPGetEnDoor #door)))

  ;;;     (setq SKD_GROUP_NO (SCD_GetDoorGroupName)) ; 扉ｸﾞﾙｰﾌﾟ名の番号更新
    ; 親図形の角度と目地領域の"G_MEJI"情報、LRフラグから求める点の方向を判定
        (setq #enANG (nth 2 (CFGetXData #enSymName "G_LSYM"))) ; ｱｲﾃﾑ配置角度
        (setq #VP (cadr (CFGetXData #enName "G_MEJI")))
        (cond
          ((= 6 #VP)(setq #DrANG (+ (* 0.5 pi) #enANG))); ｺｰﾅｰ側面
          ((= 4 #VP)(setq #DrANG (+ pi #enANG))); 背面
          (t (setq #DrANG #enANG)); その他は正面として算出 (= 0 #VP) 一般正面  (= 3 #VP) コーナー正面
        ); cond

        ; 既存ﾌﾞﾚｰｸﾗｲﾝ削除,一時ﾌﾞﾚｰｸﾗｲﾝ追加
        (setq #GG$ (entget #Door))
        (setq #FF T)
        (foreach #GG #GG$
          (if #FF
            (if (= (car #GG) 340)
              (if (and (= (cdr (assoc 0 (entget (cdr #GG)))) "XLINE")
                       (CFGetXData (cdr #GG) "G_BRK")) ; ﾌﾞﾚｰｸﾗｲﾝは除く
                nil
                (progn
                  (setq #FF nil)
                  (setq #doorP (cdr #GG))
                )
              );_if
            );_if
          );_if
        )
  ;;;     (setq #doorP (cdr (assoc 340 (entget #Door)))) ; #doorP がBRKだったらダメ
        (setq #eDelDoorBRK_W$ (PcRemoveBreakLine #doorP "W")) ; W方向ブレーク除去
        (setq #eDelDoorBRK_D$ (PcRemoveBreakLine #doorP "D")) ; D方向ブレーク除去
        (setq #eDelDoorBRK_H$ (PcRemoveBreakLine #doorP "H")) ; H方向ブレーク除去

        ; 正面==> #pos$ (左下),背面==> #pos$ (右下)
        ; 01/02/08 YM 扉図形の左下、右上座標(World座標系)を求める(ﾌﾞﾚｰｸﾗｲﾝ作成に用いる)
        ; #MinMax$ 正面==>左下,右上 背面==>右下,左上
        (setq #MinMax$ (GetGruopMaxMinCoordinate #Door #pos$)) ; どこに追加するかに必要

        (setq #LeftDown_PT (car  #MinMax$)) ; 左下
        (setq #RightUp_PT  (cadr #MinMax$)) ; 右上

        ;@@@@@@@@@ H 方向ブレークライン追加 01/02/07 YM CG_TOKU_BH
        ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
        (if CG_TOKU_BH
          (progn
            (setq #XLINE_H
              (PK_MakeBreakH
                #LeftDown_PT ; 扉左下
                CG_TOKU_BH
              )
            ) ; 点(x,y,*),高さZ
            (CFSetXData #XLINE_H "G_BRK" (list 3))
            ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
            (command "-group" "A" #TOKU_DrGrName #XLINE_H "")
    ;;;       (command "-group" "A" (strcat SKD_GROUP_HEAD (itoa SKD_GROUP_NO)) #XLINE_H "")
          )
        );_if

        ; 01/09/25 YM ADD-S /////////////////////////////////////////////////////
        ;@@@@@@@@@ D 方向ブレークライン追加 CG_TOKU_BD
        ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
        (if CG_TOKU_BD
          (progn
            (setq #XLINE_D
              (PK_MakeBreakD
                (cdr (assoc 10 (entget #enSymName))) ; ｼﾝﾎﾞﾙ基準点座標 --->01/09/25 YM MOD
                #enANG
                CG_TOKU_BD
              )
            )
            (CFSetXData #XLINE_D "G_BRK" (list 2))
            ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
            (command "-group" "A" #TOKU_DrGrName #XLINE_D "")
        ; 01/09/25 YM ADD-E /////////////////////////////////////////////////////
          )
        );_if


        ;@@@@@@@@@ W 方向ブレークライン追加 01/02/07 YM CG_TOKU_BW
        ;;; ﾌﾞﾚｰｸﾗｲﾝの作図
        (if CG_TOKU_BW
          (progn
            (setq #XLINE_W
              (PK_MakeBreakW
    ;;;01/09/25YM@DEL           #LeftDown_PT ; 扉左下
                (cdr (assoc 10 (entget #enSymName))) ; ｼﾝﾎﾞﾙ基準点座標 --->01/09/25 YM MOD
    ;;;               #DrANG
                #enANG ; 01/05/21 YM MOD
                CG_TOKU_BW
              )
            )
            (CFSetXData #XLINE_W "G_BRK" (list 1))
            ;;; ﾌﾞﾚｰｸﾗｲﾝのｸﾞﾙｰﾌﾟ化
            (command "-group" "A" #TOKU_DrGrName #XLINE_W "")
    ;;;       (command "-group" "A" (strcat SKD_GROUP_HEAD (itoa SKD_GROUP_NO)) #XLINE_W "")
          )
        );_if

      )
    );_if
  ;/////////////////////////////////////////////////////////////////////////////////////

                                      (SKD_Expansion #Door #enData$) ; "GROUP"DoorGroup,扉面領域MEJI,扉左下点

  ;/////////////////////////////////////////////////////////////////////////////////////
    (if CG_TOKU ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中 01/02/09 YM
      (progn
        (foreach #eD #eDelDoorBRK_W$ (entdel #eD)) ; W方向ブレーク復活
        (foreach #eD #eDelDoorBRK_D$ (entdel #eD)) ; D方向ブレーク復活
        (foreach #eD #eDelDoorBRK_H$ (entdel #eD)) ; H方向ブレーク復活
        (if #XLINE_W (entdel #XLINE_W)) ; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
        (if #XLINE_D (entdel #XLINE_D)) ; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
        (if #XLINE_H (entdel #XLINE_H)) ; 一時ﾌﾞﾚｰｸﾗｲﾝ削除
      )
    );_if
  ;/////////////////////////////////////////////////////////////////////////////////////

                                    )
                                  );_if

                                  ; 2000/06/22 [展開図作成]コマンドの時は、速度改善のための処理にした
                                  (if (= CG_OUTCMDNAME "SCFMakeMaterial")
                                    (progn
                                     ; "0_door"画層に、伸縮対象だった図形を置く(コマンド内tempとする)
;;;                                    (setq #en$ (SKD_ChangeLayer #Door "0_door"));03/09/29 YM MOD
                                     (setq #en$ (SKD_ChangeLayer_FMAT #Door "0_door"));03/09/29 YM MOD

                                    ; 2000/06/22 (シンボル図形名 (ドア図形名) P面7属性1) をグローバル変数に設定する
                                    ; 使用するのは、展開図作成処理内る
                                    ; (setq #iVP (cdr (nth 2 (cadr (assoc -3 #enData$))))) 2000/10/05 HT MOD
                                    (setq #iVP (atoi(substr #strViewLayer 3 2))) ; 背面に扉障害改修
                                    ;YM@ 例えば"Q_03_99_01_##"の場合 #iVP=3

                                    ;(if (/= 0 #iVP)
                                      ;(progn
                                      ; シンボルの角度を取得する
                                      (setq #ang2 (nth 2 (CfGetXData #enSymName "G_LSYM")))
                                      ; シンボルの角度が０（+-45度は0）でない時、Lsym回転角度で変換る
                                      (setq #ang2 (Angle0to360 #ang2))

                                      ;@YM (rtd 5.497)=314.955度,(rtd 6.283)=359.989度,(rtd 6.283)=44.9772度
                                      (if (not (or (<= 5.497 #ang2 6.283) (<= 0.0 #ang2 0.785)))
                                        (progn ;@YM 314.955度～359.989度または0度～44.9772度の範囲にない場合
                                          ; シンボルの角度を９０度単位に丸める
                                          (cond
                                            ((or (<= 5.497 #ang2 6.283) (<= 0.0 #ang2 0.785))
                                              (setq #ang2 0)
                                            )
                                            ((<= 0.785 #ang2 2.356) (setq #ang2  1.571)) ;@YM 90.0117度
                                            ((<= 2.356 #ang2 3.927) (setq #ang2 3.1415)) ;@YM 179.995度
                                            ((<= 3.927 #ang2 5.497) (setq #ang2 4.7123)) ;@YM 269.995度
                                          )
                                        )    ; ここでif文終了
                                      );_if  ; ここでif文終了

                                      ; P面7属性1を実際の視点方向にLsym回転角度で変換する
                                      ; Lsym回転角度で変換する

                                      (cond
                                        ((equal #ang2 0 0.1) ; 丸め後配置角度=0度
                                          (cond
                                            ((=  #iVP 3) (setq #iVP 3)) ; OK!
                                            ((=  #iVP 4) (setq #iVP 5))
                                            ((=  #iVP 5) (setq #iVP 4))
                                            ((=  #iVP 6) (setq #iVP 6)) ; OK!
                                          )
                                        )
                                        ((equal #ang2 1.571 0.1) ; 丸め後配置角度=90度
                                          (cond
                                            ((=  #iVP 3) (setq #iVP 6))
                                            ((=  #iVP 4) (setq #iVP 4))
                                            ((=  #iVP 5) (setq #iVP 3))
                                            ((=  #iVP 6) (setq #iVP 5))
                                          )
                                        )
                                        ((equal #ang2 3.14159 0.1) ; 丸め後配置角度=180度
                                          (cond
                                            ((=  #iVP 3) (setq #iVP 5))
                                            ((=  #iVP 4) (setq #iVP 3))
                                            ((=  #iVP 5) (setq #iVP 6))
                                            ((=  #iVP 6) (setq #iVP 4))
                                          )
                                        )
                                        ((equal #ang2 4.71239 0.1) ; 丸め後配置角度=270度
                                          (cond
                                            ((=  #iVP 3) (setq #iVP 4))
                                            ((=  #iVP 4) (setq #iVP 6))
                                            ((=  #iVP 5) (setq #iVP 5))
                                            ((=  #iVP 6) (setq #iVP 3))
                                          )
                                        )
                                      ) ; cond

                                      ; グローバル変数にため込む
                                      ; (シンボル図形名 ドア図形名リスト 視点方向)
                                      (setq CG_DOORLST (append CG_DOORLST (list (list #enSymName #en$ #iVP))))
                                    )
                                  );_if

                                  ;(command "_UCS" "P")    ; 直前の状態に戻す

                                  (if (/= CG_OUTCMDNAME "SCFMakeMaterial")
                                    (progn
  ;;;                                   (setq SKD_GROUP_NO (SCD_GetDoorGroupName)) ; 扉ｸﾞﾙｰﾌﾟ名の番号更新 01/03/12 YM ADD
                                      ;; 扉図形を伸縮作業画層から扉面指定画層に移動する
                                      (SKD_ChangeLayer #Door (cdr (assoc 8 #enData$)))

;;;(atoi(substr #strViewLayer 3 2)) ; 01/02/27 YM 参照
                              (if CG_TOKU ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞ中 01/02/09 YM
;-- 2011/12/19 A.Satoh Mod （2011/11/24 の改修を元に戻す）- S
;;;;;;-- 2011/11/24 A.Satoh Mod - S
;;;;;																(if CG_POS_STR
;;;;;												      		(progn
;;;;;																		;; 3D 目地のハッチングを消す
;;;;;																		(SKD_DeleteHatch #enName)
;;;;;																		;; グループ化
;;;;;																		(command "-group" "A" (strcat SKD_GROUP_HEAD (substr #strViewLayer 4 1)(itoa SKD_GROUP_NO)))
;;;;;																		(setq #Group$ (entget #Door))
;;;;;																		(foreach #nn #Group$ ; 扉グループの要素を一つ一つ追加する
;;;;;																			(if (= (car #nn) 340)(command (cdr #nn)))
;;;;;																		)
;;;;;																		(command #enSymName "")
;;;;;																	)
;;;;;																	nil
;;;;;																)
;;;;;
                                nil
;;;;;;-- 2011/11/24 A.Satoh Mod - E
;-- 2011/12/19 A.Satoh Mod （2011/11/24 の改修を元に戻す）- E
                                (progn ; (特注ｷｬﾋﾞｺﾏﾝﾄﾞ時は必要ない)
                                      ;; 3D 目地のハッチングを消す
                                      (SKD_DeleteHatch #enName)
                                      ;; グループ化
                                      (command "-group" "A" (strcat SKD_GROUP_HEAD (substr #strViewLayer 4 1)(itoa SKD_GROUP_NO)))
                                      (setq #Group$ (entget #Door))
                                      (foreach #nn #Group$ ; 扉グループの要素を一つ一つ追加する
                                        (if (= (car #nn) 340)(command (cdr #nn)))
                                      )
                                      (command #enSymName "")
                                )
                              );_if

                                    )
                                  );_if
                                )
                              );_if
                            )
                          );_if
                        )
                      );_if
                    )
                  );_if
                )
              );_if

            );_if

          )
        );_if
        (setq #iNo (+ #iNo 1))
      )
    )
  )
  (setvar "OSMODE"     #os)
  (setvar "SNAPMODE"   #sm)

  ;// ビューを元に戻す
  (command "_view" "R" "TEMP")
  ;// ブレークラインを非表示
  (command "_layer" "of" "N_B*" "F" SKD_TEMP_LAYER "")
  (command "_layer" "on" "M_*" "") ; 07/07 YM ADD(ﾐﾗｰ反転時"OF"になるものがある)
)
;PCD_AlignDoor


;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
(defun FK_MSG ( / )
	
	(if (= BU_CODE_0012 "1")
		(progn
;CG_FK_MSG1
			(CFYesDialog CG_FK_MSG1)
			(quit)
		)
	);_if

);FK_MSG


;<HOM>*************************************************************************
; <関数名>    : C:ChgDr
; <処理概要>  : 扉面の一括変更
; <戻り値>    :
; <作成>      : 1999-06-14
; <備考>      :
;*************************************************************************>MOH<
(defun C:ChgDr (
  /
  #XRec$
  #ret$
  #i
  #ss
  #en$ #SYMTOKU$ #TOKU$ #SYMNORMAL$ #TOKU
#FP #PLANINFO$ #SFNAME ;2010/01/08 YM ADD
;-- 2011/07/12 A.Satoh Add - S
  #en2$ #idx
;-- 2011/07/12 A.Satoh Add - E
;-- 2011/09/14 A.Satoh Add - S
  #ss2
;-- 2011/09/14 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ChgDr ////")
  (CFOutStateLog 1 1 " ")

	
  ; 01/10/31 YM ADD-S
  (setq CG_OUTCMDNAME "ChgDr")
  ; 01/10/31 YM ADD-E

  ;// コマンドの初期化
  (StartUndoErr)


	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)


  (CFCmdDefBegin 6);00/09/26 SN ADD
  ; 02/01/15 YM ADD
  (CabShow_sub) ; 非表示ｷｬﾋﾞを表示する 01/05/31 YM ADD

  ;// 現在の商品情報を取得する

;拡張ﾚｺｰﾄﾞ"SERI"の内容
;;;          (setq CG_DBNAME      (nth  0 #seri$)) ; 1.DB名称
;;;          (setq CG_SeriesCode  (nth  1 #seri$)) ; 2.SERIES記号
;;;          (setq CG_BrandCode               "N") ; 3.ブランド記号
;;;          (setq CG_DRSeriCode  (nth  2 #seri$)) ; 2.扉SERIES記号
;;;          (setq CG_DRColCode   (nth  3 #seri$)) ; 3.扉COLOR記号
;;;          (setq CG_HIKITE      (nth  4 #seri$)) ; 4.ヒキテ記号
;;;          (setq CG_UpCabHeight (nth  5 #seri$)) ; 6.取付高さ
;;;          (setq CG_CeilHeight  (nth  5 #seri$)) ; 7.天井高さ
;;;          (setq CG_RoomW       (nth  6 #seri$)) ; 8.部屋間口
;;;          (setq CG_RoomD       (nth  7 #seri$)) ; 9.部屋奥行
;;;          (setq CG_GasType     (nth  8 #seri$)) ;10.ガス種

  (setq #XRec$ (CFGetXRecord "SERI"))
  (if (= #XRec$ nil)
    (CFAlertErr "一度も商品設定がされていません\n商品設定を行って下さい")
  )

  (setq #ret$
    (SRSelectDoorSeriesDlg_Handle
      "扉面一括変更"
      (nth 0 #XRec$);対象データベース名
      (nth 1 #XRec$);SERIES記号
      (nth 3 #XRec$);扉SERIES記号
      (nth 4 #XRec$);扉COLOR記号
      (nth 5 #XRec$);引手記号
    )
  )

;-- 2011/07/12 A.Satoh Add - S
  (if (/= #ret$ nil)
    (progn
      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
;-- 2011/09/14 A.Satoh Mod - S
;      (if (/= #ss nil)
;        (progn
;          (setq #idx 0)
;          (setq #en2$ nil)
;          (repeat (sslength #ss)
;            (setq #en2$ (append #en2$ (list (ssname #ss #idx))))
;            (setq #idx (1+ #idx))
;          )
;          (if (/= #en2$ nil)
;            (if (= nil (CheckDoorGradeHinban #en2$ (car #ret$) (cadr #ret$)))
;              (setq #ret$ nil)
;            )
;          )
;        )
;      )
      (setq #idx 0)
      (setq #en2$ nil)
      (repeat (sslength #ss)
        (setq #en2$ (append #en2$ (list (ssname #ss #idx))))
        (setq #idx (1+ #idx))
      )

      (setq #ss2 (ssget "X" '((-3 ("G_FILR")))))
			(if (and #ss2 (< 0 (sslength #ss2)))
				(progn
		      (setq #idx 0)
		      (repeat (sslength #ss2)
		        (setq #en2$ (append #en2$ (list (ssname #ss2 #idx))))
		        (setq #idx (1+ #idx))
		      )
				)
			);_if
      (if (/= #en2$ nil)
        (progn
          (setq #en2$ (CheckDoorGradeHinban #en2$ (car #ret$) (cadr #ret$)))
          (if (/= #en2$ nil)
            (progn
              (setq #idx 0)
              (repeat (length #en2$)
                (if (equal CG_BASESYM (nth #idx #en2$)) ;基準ｱｲﾃﾑ
                  (GroupInSolidChgCol (nth #idx #en2$) CG_BaseSymCol)
                  (GroupInSolidChgCol2 (nth #idx #en2$) "BYLAYER")
                );_if
                (setq #idx (1+ #idx))
              )
            )
          )
        )
      )
;-- 2011/09/14 A.Satoh Mod - E
    )
  )
;-- 2011/07/12 A.Satoh Add - E

  (if (/= #ret$ nil)
    (progn
      ; 扉貼り付け後に"G_LSYM"に扉ｼﾘ,扉ｶﾗ,取手をｾｯﾄするため一時的にｸﾞﾙｰﾊﾞﾙｾｯﾄ
      (setq CG_DRSeriCode (car  #ret$))  ;扉SERIES記号(ｸﾞﾛｰﾊﾞﾙ更新)
      (setq CG_DRColCode  (cadr #ret$))  ;扉COLOR記号　(ｸﾞﾛｰﾊﾞﾙ更新)
      (setq CG_Hikite    (caddr #ret$))  ;取手記号(ｸﾞﾛｰﾊﾞﾙ更新)

      (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
      (if (and #ss (< 0 (sslength #ss))) ;2011/08/05 YM ADD if文追加部材
        (progn
          
          (setq #i 0)
          (repeat (sslength #ss)
              (setq #en$ (cons (ssname #ss #i) #en$))
            (setq #i (1+ #i))
          )
          ; 01/03/12 YM ADD 特注ｷｬﾋﾞと一般ｷｬﾋﾞを分ける
          (setq #symTOKU$ nil #symNORMAL$ nil #TOKU nil)
          (foreach en #en$
            (if (setq #TOKU$ (CFGetXData en "G_TOKU"));2011/12/09 YM MOD G_TOKU条件変更
              (progn
                (setq #TOKU T) ; 特注ｷｬﾋﾞがあった
                (setq #symTOKU$ (append #symTOKU$ (list en))) ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞを使用
              )
              (setq #symNORMAL$ (append #symNORMAL$ (list en)))
            );_if
          )

          (if #TOKU ; 01/03/22 YM ADD
            (CFAlertErr "特注キャビネットは扉面の変更を行えません。")
          );_if

          ;// 扉面の貼り付け(特注以外の場合)
          (if #symNORMAL$
            (PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
          );_if

					;2011/12/20 YM ADD-S
					;#symNORMAL$ を対象に、【品番基本】展開タイプ=0のときG_LSYM扉情報を再度更新する。
					;OPEN BOXに扉情報がなくて積算できない、扉部分変更しても扉情報がｾｯﾄされないため。
					(foreach #sym #symNORMAL$
						(setq #xd$ (CFGetXData #sym "G_LSYM"))
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

					);foreach
					;2011/12/20 YM ADD-E

        )
      );_if

      ;// 現在の商品情報の扉情報を更新する XRecordを更新する(扉一括変更)

      ; Xrecord更新
      (CFSetXRecord "SERI"
        (CFModList #XRec$
          (list
            (list 3 CG_DRSeriCode) ; CG_DRSeriCode
            (list 4 CG_DRColCode ) ; CG_DRColCode
            (list 5 CG_Hikite)     ; 引手
          )
        )
      )

; 02/12/26 YM 扉一括変更してﾒﾆｭｰ変更するとｱﾌﾟﾘｹｰｼｮﾝｴﾗｰ EFOpenErrorがﾓｼﾞｭｰﾙ MDBupd.exeで発生
; 試しにｺﾒﾝﾄ したらNAS版でOKﾐｶﾄﾞ版ではそちらもOK ﾐｶﾄﾞ版は"CG_DoorHandle"があるから?

;03/07/22 YM MOD-S ｺﾒﾝﾄ解除 扉一括変更後にﾌﾟﾗﾝ管理画面で扉色が修正されていないから

      ; 02/12/06 YM ADD-S
      ; PlanInfo.cfgを更新
      ;// 現在のプラン情報(PLANINFO.CFG)を読み込む
      (setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))
      ; 項目の更新
      (setq #PLANINFO$ (subst (list "DoorSeriesCode" CG_DRSeriCode) (assoc "DoorSeriesCode" #PLANINFO$) #PLANINFO$))
      (setq #PLANINFO$ (subst (list "DoorColorCode"   CG_DRColCode) (assoc "DoorColorCode"  #PLANINFO$) #PLANINFO$))
      (setq #PLANINFO$ (subst (list "DoorHandle"         CG_Hikite) (assoc "DoorHandle"     #PLANINFO$) #PLANINFO$))

      (setq #sFname (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
      (setq #fp  (open #sFname "w"))

      (if (/= nil #fp)
        (progn
          (foreach #elm #PLANINFO$
            (if (= ";" (substr (car #elm) 1 1))
              (princ (car #elm) #fp)
              ;else
              (progn
                (if (= (car #elm) "") ; if文分岐 03/07/22 YM ADD
                  nil ; 空行(何も書かない)
									;else
									(progn
										(if (= (cadr #elm) nil) ; if文分岐 2011/10/14 YM ADD
											(princ (car #elm) #fp)
											;else
                			(princ (strcat (car #elm) "=" (cadr #elm)) #fp)
										);_if
									)
                );_if
              )
            );_if
            (princ "\n" #fp)
          );foreach
          (close #fp)
        )
        (progn
          (CFAlertMsg "PLANINFO.CFGへの書き込みに失敗しました。")
          (*error*)
        )
      );_if
      ; 02/12/06 YM ADD-E

;03/07/22 YM MOD-S ｺﾒﾝﾄ解除 扉一括変更後にﾌﾟﾗﾝ管理画面で扉色が修正されていないから

      ;00/08/25 SN ADD 基準ｱｲﾃﾑが存在する場合は基準ｱｲﾃﾑを再表示
      (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
        (progn
          (setq CG_BASESYM (CFGetBaseSymXRec))
          (ResetBaseSym)
          (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
        ); progn
      );_if

      (command "_purge" "BL" "*" "N") ; 01/05/14 YM ADD
      (command "_purge" "BL" "*" "N") ; 01/05/14 YM ADD

      ;;; 編集  00/02/20 MH MOD 関数の最後尾からこの位置に移動
      (princ "\n扉面のSERIESを変更しました.") ;00/01/30 HN ADD メッセージ表示を追加
    )
  );_if

  ;2011/04/22 YM MOD
  (setvar "MODEMACRO"
    (strcat "ｼﾘｰｽﾞ: " CG_SeriesDB " / 扉ｸﾞﾚｰﾄﾞ: " CG_DRSeriCode " / 扉ｶﾗｰ: " CG_DRColCode " / 引手: " CG_HIKITE)
  )

  ; 01/10/31 YM ADD-S
  (setq CG_OUTCMDNAME nil)
  ; 01/10/31 YM ADD-E

  ;04/05/26 YM ADD
  (command "_REGEN")

  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)
);C:ChgDr


;<HOM>*************************************************************************
; <関数名>    : C:ChgDrCab
; <処理概要>  : キャビネット単位の扉面貼り付け
; <戻り値>    :
; <作成>      : 1999-06-14
; <備考>      :
;*************************************************************************>MOH<
(defun C:ChgDrCab (
    /
    #xd$
    #en #en$
    #ret #ret$
    #XRec$
#CG_HIKITE
;;;    #tonF ; 00/02/17 YM 未使用
    #msg #QRY$ #SYMTOKU$ #TOKU$ #SYMNORMAL$ #TOKU #CG_DRCOLCODE #CG_DRSERICODE
#CG_DOORHANDLE ; 02/11/30 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ChgDrCab ////")
  (CFOutStateLog 1 1 " ")

  ; 01/10/31 YM ADD-S
  (setq CG_OUTCMDNAME "ChgDrCab")
  ; 01/10/31 YM ADD-E

  ;// コマンドの初期化
  (StartUndoErr)
  (CFCmdDefBegin 6);00/09/26 SN ADD

	;フレームキッチン　一部ｺﾏﾝﾄﾞ使用中止
	(FK_MSG)

  ; 02/01/15 YM ADD
  (CabShow_sub) ; 非表示ｷｬﾋﾞを表示する 01/05/31 YM ADD

  ;// 現在の商品情報を取得する
  (setq #XRec$ (CFGetXRecord "SERI"))
  (if (= #XRec$ nil)
    (CFAlertErr "一度も商品設定がされていません\n商品設定を行って下さい")
    (progn
      (setq #CG_DRSeriCode (nth 3 #XRec$)) ;現在の図面の扉SERIES記号を保管
      (setq #CG_DRColCode  (nth 4 #XRec$)) ;現在の図面の扉COLOR記号を保管
      (setq #CG_HIKITE     (nth 5 #XRec$)) ;現在の図面の引手記号を保管
    )
  )

  (setq #ret$
    (SRSelectDoorSeriesDlg_Handle
      "扉面選択変更"
      (nth 0 #XRec$)
      (nth 1 #XRec$)
      (nth 3 #XRec$);扉ｼﾘ
      (nth 4 #XRec$);扉色
      (nth 5 #XRec$);引手
    )
  )

  (if (/= #ret$ nil)
    (progn
      ; 扉貼り付け後に"G_LSYM"に扉ｼﾘ,扉ｶﾗ,取手をｾｯﾄするため一時的にｸﾞﾙｰﾊﾞﾙｾｯﾄ
      (setq CG_DRSeriCode (car  #ret$))  ;扉SERIES記号(一時的に部分変更の扉ｼﾘにする)
      (setq CG_DRColCode  (cadr #ret$))  ;扉COLOR記号　(一時的に部分変更の扉ｶﾗにする)
      (setq CG_HIKITE (caddr #ret$)) ;取手記号(一時的に部分変更の取手記号にする)


      (setq #en T)
      (command "_view" "S" "TEMP")
      (command "_undo" "m")

      ;// 貼り付ける扉の指示と貼り付け
      (while #en
        (initget "E Undo");00/07/21 SN MOD Undo入力を許可
        (setq #en (entsel "\n扉面を変更するキャビネットを選択/Enter=決定/U=戻す/: "))
        ;(initget "E")
        ;(setq #en (entsel "\n扉面を変更するキャビネットを選択/Enter=決定/ "))
        (cond
          ((and (= #en nil) #en$)
            (setq #ret (CFYesNoCancelDialog "これでよろしいですか？ "))
            (cond
              ((= #ret IDYES)
                (command "_undo" "b")
                (setq #en nil)
                (repeat (length #en$);00/07/21 SN ADD 選択した数だけもとに戻す
                  (command "_undo" "b")
                )
              )
              ((= #ret IDNO)
                (setq #en T)
              )
              (T
                (quit)
              )
            )
          )
          ; 00/07/21 SN ADD Undo 処理
          ((= #en "Undo")
            (if (> (length #en$) 0 )(progn
              (command "_undo" "b")
              (if (> (length #en$) 1 )
                (setq #en$ (cdr #en$))
                (setq #en$ '())
              )
            ))
          )
          ((/= #en nil)
            (setq #en (car #en))
            (setq #en (CFSearchGroupSym #en)) ; 選択部材のｼﾝﾎﾞﾙ図形名 #en
            (if (= #en nil)
              (progn
                (CFAlertMsg "キャビネットではありません")
                (setq #en T)
              )
            ;else
              (progn
                (setq #xd$ (CFGetXData #en "G_LSYM"))

;;;02/09/04YM@DEL                (if (/= CG_SKK_ONE_CAB (CFGetSeikakuToSKKCode (nth 9 #xd$) 1))
;;;02/09/04YM@DEL                  (CFAlertMsg "キャビネットではありません")
;;;02/09/04YM@DEL                  (progn
                    (if (not (member #en #en$))
                      (progn;00/07/21 SN ADD 既に選択済みのものは対象外とする。
                        (setq #en$ (cons #en #en$)) ; 選択部材のｼﾝﾎﾞﾙ図形名ﾘｽﾄ
                        (command "_undo" "m");00/07/21 SN ADD 後で色を戻すため
                        ;// グループの図形を色替え
                        ;(GroupInSolidChgCol #en CG_InfoSymCol);00/07/21 SN MOD 基準ｱｲﾃﾑ用
;-- 2011/09/14 A.Satoh Mod - S
;                        (GroupInSolidChgCol2 #en CG_InfoSymCol);00/07/21 SN MOD
                        (GroupInSolidChgCol2 #en CG_ConfSymCol)
;-- 2011/09/14 A.Satoh Mod - E
                      )
                    );_if
;;;02/09/04YM@DEL                  )
;;;02/09/04YM@DEL                )
              )
            );_if
          )
          (T
            (setq #en T)
          )
        );_cond
      )
;;;01/03/22YM@      ;// 扉面の貼り付け
;;;01/03/22YM@      (PCD_MakeViewAlignDoor #en$ 3 T)          ;00/02/07 MH MOD

;-- 2011/07/12 A.Satoh Add - S
      (if (/= #en$ nil)
        ; 品番名称チェック処理
;-- 2011/09/14 A.Satoh Mod - S
;        (if (= nil (CheckDoorGradeHinban #en$ (car #ret$) (cadr #ret$)))
;          (progn
;            ; グローバル変数を元に戻す
;            (setq CG_DRSeriCode #CG_DRSeriCode)
;            (setq CG_DRColCode #CG_DRColCode)
;            (setq CG_HIKITE #CG_HIKITE)
;
;            (setq #ret$ nil)
;          )
;        )
        (progn
          (setq #en2$ (CheckDoorGradeHinban #en$ (car #ret$) (cadr #ret$)))
          (if (/= #en2$ nil)
            (progn
              (setq #idx 0)
              (repeat (length #en$)
                (if (equal CG_BASESYM (nth #idx #en2$)) ;基準ｱｲﾃﾑ
                  (GroupInSolidChgCol (nth #idx #en2$) CG_BaseSymCol)
                  (GroupInSolidChgCol2 (nth #idx #en2$) "BYLAYER")
                );_if
                (setq #idx (1+ #idx))
              )
            )
          )
        )
;-- 2011/09/14 A.Satoh Mod - E
      )
    )
  )

  (if (/= #ret$ nil)
    (progn
;-- 2011/07/12 A.Satoh Add - E
      ; 01/03/12 YM ADD 特注ｷｬﾋﾞと一般ｷｬﾋﾞを分ける
      (setq #symTOKU$ nil #symNORMAL$ nil #TOKU nil)
      (foreach en #en$
        (if (setq #TOKU$ (CFGetXData en "G_TOKU"));2011/12/09 YM MOD G_TOKU条件変更
          (progn
            (setq #TOKU T)
            (setq #symTOKU$ (append #symTOKU$ (list en))) ; 特注ｷｬﾋﾞｺﾏﾝﾄﾞを使用
          )
          (setq #symNORMAL$ (append #symNORMAL$ (list en)))
        );_if
      )

      (if #TOKU ; 01/03/22 YM ADD
        (CFAlertErr "特注キャビネットは扉面の変更を行えません。")
      );_if

      ;// 扉面の貼り付け(特注以外の場合)
      (if #symNORMAL$
        (PCD_MakeViewAlignDoor #symNORMAL$ 3 T)
      );_if


			;2011/12/20 YM ADD-S
			;#symNORMAL$ を対象に、【品番基本】展開タイプ=0のときG_LSYM扉情報を再度更新する。
			;OPEN BOXに扉情報がなくて積算できない、扉部分変更しても扉情報がｾｯﾄされないため。
			(foreach #sym #symNORMAL$
				(setq #xd$ (CFGetXData #sym "G_LSYM"))
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

			);foreach
			;2011/12/20 YM ADD-E


      ;00/08/25 SN ADD 基準ｱｲﾃﾑが存在する場合は基準ｱｲﾃﾑを再表示
      (if (and (CFGetBaseSymXRec)(entget (CFGetBaseSymXRec)))
        (progn
          (setq CG_BASESYM (CFGetBaseSymXRec))
          (ResetBaseSym)
          (GroupInSolidChgCol CG_BaseSym CG_BaseSymCol)
        ); progn
      )

      (command "_purge" "BL" "*" "N") ; 01/05/14 YM ADD
      (command "_purge" "BL" "*" "N") ; 01/05/14 YM ADD

      ; ｶﾗｰﾐｯｸｽﾊﾟﾀｰﾝ名をｸﾞﾛｰﾊﾞﾙｾｯﾄ 01/10/11 YM ADD-S
      (PhSelColorMixPatternDlg) ; PHCAD以外は何もしない関数(-->KcExtend)
      ; ｶﾗｰﾐｯｸｽﾊﾟﾀｰﾝ名をｸﾞﾛｰﾊﾞﾙｾｯﾄ 01/10/11 YM ADD-E

       ;;; ↓編集  00/02/20 MH MOD 関数の最後尾からこの位置に移動
      (princ "\n扉面のSERIESを変更しました.") ;00/01/30 HN ADD メッセージ表示を追加

      ; 01/11/27 YM ADD-S 扉部分変更後に配置したｷｬﾋﾞの扉は、図面の扉でないといけない
      (setq CG_DRSeriCode #CG_DRSeriCode) ;図面の扉SERIES記号に戻す
      (setq CG_DRColCode  #CG_DRColCode)  ;図面の扉COLOR記号に戻す
      ; 01/11/27 YM ADD-E 扉部分変更後に配置したｷｬﾋﾞの扉は、図面の扉でないといけない
      (setq CG_HIKITE     #CG_HIKITE)     ;図面の取手記号に戻す

    )
  )


  ; 01/10/31 YM ADD-S
  (setq CG_OUTCMDNAME nil)
  ; 01/10/31 YM ADD-E

  ;04/05/26 YM ADD
  (command "_REGEN")

  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)
);C:ChgDrCab


;-- 2011/07/12 A.Satoh Add - S
;;;<HOM>***********************************************************************
;;; <関数名>    : CheckDoorGradeHinban
;;; <処理概要>  : 扉グレード変更時品番チェック処理
;;;             :   指定された扉のグレード、色である場合に存在できない品番名称
;;;             :   が存在するか否かをチェックする
;;; <戻り値>    : T   → 存在不可品番無　nil → 存在不可品番有
;;;             : →11/09/14 変更　存在不可品番図形リスト又はnil
;;; <作成>      : 11/07/12 A.Satoh
;;; <備考>      : 11/08/03 A.Satoh 変更
;;;             :　・存在不可品番の判定方法変更
;;;             : 11/09/14 A.Satoh 変更
;;;             :　・存在不可品番対象に天井フィラー追加
;;;             :　・存在不可品番対象図形を赤色表示
;;;             :　・拡張データ[G_ERR]設定
;;;             :　・戻り値変更
;;;***********************************************************************>HOM<
(defun CheckDoorGradeHinban (
  &en$      ; 選択図形リスト
  &DrSeries ; 扉シリーズ記号
  &DrColor  ; 扉色記号
  /
;-- 2011/09/14 A.Satoh Mod - S
;  #ret #idx #en #xd_LSYM$ #hinban #qry$$ #qry$ #hinban$ #msg
  #idx #en #xd_LSYM$ #hinban #qry$$ #qry$ #hinban$ #msg #xd_FILR$ #en$ #err$
  #err_flg #en_no_err$
;-- 2011/09/14 A.Satoh Mod - E
  #ser_lst$ #col_lst$
;-- 2011/08/03 A.Satoh Add - S
  #ser #col
;-- 2011/08/03 A.Satoh Add - E
  )

;-- 2011/09/14 A.Satoh Mod - S
;  (setq #ret T)
  (setq #en$ nil)
  (setq #en_no_err$ nil)
;-- 2011/09/14 A.Satoh Mod - E
  (setq #hinban$ nil)

  (setq #idx 0)
  (repeat (length &en$)
    ; 品番名称取得
    (setq #en (nth #idx &en$))
;-- 2011/09/14 A.Satoh Mod - S
;    (setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
;    (setq #hinban (nth 5 #xd_LSYM$))
    (setq #err_flg nil)
    (setq #xd_LSYM$ (CFGetXData #en "G_LSYM"))
    (if #xd_LSYM$
      (setq #hinban (nth 5 #xd_LSYM$))
      (progn
        (setq #xd_FILR$ (CFGetXData #en "G_FILR"))
        (setq #hinban (nth 0 #xd_FILR$))
      )
    )
;-- 2011/09/14 A.Satoh Mod - E

    ; 扉シリ別非対象部材から情報を抽出する
    (setq #qry$$
      (CFGetDBSQLRec CG_DBSESSION "扉シリ別非対応部材"
        (list
          (list "品番名称" #hinban 'STR)
        )
      )
    )

    ; 扉シリーズ非対象部材チェック
    (if (and #qry$$ (= 1 (length #qry$$)))
      (progn
        (setq #qry$ (nth 0 #qry$$))
;-- 2011/08/03 A.Satoh Mod - S
;       (setq #ser_lst$ (StrParse (nth 1 #qry$) ","))
;       (setq #col_lst$ (StrParse (nth 2 #qry$) ","))
;
;       (if (and (/= (member &DrSeries #ser_lst$) nil)
;                (/= (member &DrColor #col_lst$) nil))
;         (progn
;           ; 非対象の品番名称をリスト化
;           (setq #hinban$ (append #hinban$ (list #hinban)))
;           (setq #ret nil)
;         )
;       )
        (setq #ser (nth 2 #qry$))
        (if (/= #ser "ALL")
          (setq #ser_lst$ (StrParse #ser ","))
        )
        (setq #col (nth 3 #qry$))
        (if (/= #col "ALL")
          (setq #col_lst$ (StrParse #col ","))
        )
        (setq #flag (nth 4 #qry$))

        (cond
          ((and (= #ser "ALL") (= #col "ALL"))
            (if (= #flag "NG")
              (progn
                ; 非対象の品番名称をリスト化
                (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                (setq #ret nil)
                (GroupInSolidChgCol2 #en CG_InfoSymCol)
                (setq #en$ (append #en$ (list #en)))
                (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
              )
            )
          )
          ((and (/= #ser "ALL") (= #col "ALL"))
            (if (/= (member &DrSeries #ser_lst$) nil)
              (if (= #flag "NG")
                (progn
                  ; 非対象の品番名称をリスト化
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
              (if (= #flag "OK")
                (progn
                  ; 非対象の品番名称をリスト化
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
            )
          )
          ((and (= #ser "ALL") (/= #col "ALL"))
            (if (/= (member &DrColor #col_lst$) nil)
              (if (= #flag "NG")
                (progn
                  ; 非対象の品番名称をリスト化
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
              (if (= #flag "OK")
                (progn
                  ; 非対象の品番名称をリスト化
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
            )
          )
          (T
            (if (and (/= (member &DrSeries #ser_lst$) nil)
                     (/= (member &DrColor  #col_lst$) nil))
              (if (= #flag "NG")
                (progn
                  ; 非対象の品番名称をリスト化
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
              (if (= #flag "OK")
                (progn
                  ; 非対象の品番名称をリスト化
                  (setq #hinban$ (append #hinban$ (list #hinban)))
;-- 2011/09/14 A.Satoh Mod - S
;                  (setq #ret nil)
                  (GroupInSolidChgCol2 #en CG_InfoSymCol)
                  (setq #en$ (append #en$ (list #en)))
                  (setq #err_flg T)
;-- 2011/09/14 A.Satoh Mod - E
                )
              )
            )
          )
        )
;-- 2011/08/03 A.Satoh Mod - E
      )
    )

    (if (= #err_flg nil)
      (setq #en_no_err$ (append #en_no_err$ (list #en)))
    )

    (setq #idx (1+ #idx))
  )

;-- 2011/09/14 A.Satoh Mod - S
;  (if (= #ret nil)
  (if (/= #en$ nil)
;-- 2011/09/14 A.Satoh Mod - E
    (progn
      ; メッセージ出力
      (setq #msg "\n現在の扉ｸﾞﾚｰﾄﾞ、扉色のときに存在してはいけない品番があるので変更できませんでした。\n\n品番名称：")
      (setq #idx 0)
      (repeat (length #hinban$)
        (setq #msg (strcat #msg "\n" (nth #idx #hinban$)))
        (setq #idx (1+ #idx))
      )
;-- 2011/09/14 A.Satoh Add - S
      (if (= nil (tblsearch "APPID" "G_ERR")) (regapp "G_ERR"))
      (setq #idx 0)
      (repeat (length #en$)
        (setq #en (nth #idx #en$))
        (setq #err$ (CFGetXData #en "G_ERR"))
        (if (= #err$ nil)
          (CFSetXData #en "G_ERR" (list 1))
        )
        (setq #idx (1+ #idx))
      )
;-- 2011/09/14 A.Satoh Add - E
      (CfAlertMsg #msg)
    )
  )

;-- 2011/09/14 A.Satoh Mod - S
;  #ret
  (if (/= #en_no_err$ nil)
    (progn
      (setq #idx 0)
      (repeat (length #en_no_err$)
        (if (/= (CFGetXData (nth #idx #en_no_err$) "G_ERR") nil)
          (CFSetXData (nth #idx #en_no_err$) "G_ERR" nil)
        )
        (setq #idx (1+ #idx))
      )
    )
  )

  #en$
;-- 2011/09/14 A.Satoh Mod - E

);CheckDoorGradeHinban
;-- 2011/07/12 A.Satoh Add - E


;<HOM>*************************************************************************
; <関数名>    : PCD_MakeViewAlignDoor
; <処理概要>  : 扉貼り付け用のビューを作成する
; <備考>      :
;*************************************************************************>MOH<
(defun PCD_MakeViewAlignDoor (
    &Obj$          ;(LIST)扉貼付対象のシンボル
    &SetFace       ;(INT)貼り付ける面の種類(2:2D-Ｐ面 3:3D目地領域)
    &EraseFlg      ;(INT)既存扉面の削除フラグ (T:削除 nil:削除しない)
    /
    #viewEn
  )

  (command "UCSICON" "A" "OF") ; UCS アイコンを非表示にします。
;;;@YM@;;;  (if (= 0 (getvar "TILEMODE"))                         00/02/22 ﾓﾃﾞﾙﾀﾌﾞでいこう
;;;@YM@;;;    (progn
;;;@YM@;;;      (command "_mview" (list 0 0) (list 0.2 0.2))
;;;@YM@;;;      (setq #viewEn (entlast))
;;;@YM@;;;      ;// 扉面の貼り付け
;;;@YM@;;;      (if CG_AutoAlignDoor
;;;@YM@;;;        (PCD_AlignDoor &Obj$ &SetFace &EraseFlg)
;;;@YM@;;;      )
;;;@YM@;;;      (entdel #viewEn)
;;;@YM@;;;    )
;;;@YM@;;;  ;else
;;;@YM@;;;(progn
      ;// 扉面の貼り付け
      (if CG_AutoAlignDoor
        (PCD_AlignDoor &Obj$ &SetFace &EraseFlg)
      )
;;;@YM@;;;    )
;;;@YM@;;;)                                                       00/02/22 ﾓﾃﾞﾙﾀﾌﾞでいこう
  ;(command "UCSICON" "A" "ON")
)
;PCD_MakeViewAlignDoor

;;;<HOM>***********************************************************************
;;; <関数名>    : GetXYMaxMinFromPT$
;;; <処理概要>  : 点列のX最大,最小,Y最大,最小ﾘｽﾄを返す
;;; <戻り値>    :
;;; <作成>      : 01/04/06 YM
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun GetXYMaxMinFromPT$ (
  &pt$ ; 点列
  /
  #X$ #XMAX #XMIN #Y$ #YMAX #YMIN
  )
  (setq #XMAX -1.0e+10)
  (setq #XMIN +1.0e+10)
  (setq #YMAX -1.0e+10)
  (setq #YMIN +1.0e+10)

  (setq #X$ (mapcar 'car  &pt$))
  (setq #Y$ (mapcar 'cadr &pt$))

  (foreach #X #X$
    (if (<= #XMAX #X)(setq #XMAX #X))
    (if (>= #XMIN #X)(setq #XMIN #X))
  )
  (foreach #Y #Y$
    (if (<= #YMAX #Y)(setq #YMAX #Y))
    (if (>= #YMIN #Y)(setq #YMIN #Y))
  )
  (list #XMAX #XMIN #YMAX #YMIN)
);GetXYMaxMinFromPT$

;;;<HOM>***********************************************************************
;;; <関数名>    : KP_WritePOLYLINE
;;; <処理概要>  : ﾎﾟﾘﾗｲﾝ上に同じﾎﾟﾘﾗｲﾝをかく
;;; <戻り値>    : ﾎﾟﾘﾗｲﾝ
;;; <作成>      : 01/04/06 YM
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun KP_WritePOLYLINE (
  &PLINE  ;PLINE図形
  /
;;; #210 #EG$ #PT$ #Z
#210 #EG$ #PT$ #Z
  )
  (setq #eg$ (entget &PLINE))
  (setq #Z   (cdr (assoc  38 #eg$))) ; 高度
  (setq #210 (cdr (assoc 210 #eg$))) ; 押し出し方向

    ;; VPOINT 変更 右側面図
    (command "_.vpoint" #210) ; 押し出し方向からのﾋﾞｭｰにする
    ;; UCS 変更
    (command "_.UCS" "V")

  (setq #pt$ nil)
  (foreach elm #eg$
    (if (= (car elm) 10)
      (setq #pt$ (append #pt$ (list (cdr elm)))) ; MEJI 外形点列Objectの座標系
;;;     (setq #pt$ (append #pt$ (list (trans (append (cdr elm)(list #Z)) &MEJI 1 0)))) ; MEJI 外形点列
    );_if
  )
;;; ; World座標系に変換
;;; (setq #pA (trans (append #pA (list #Z)) &MEJI 1 0))
;;; (setq #pB (trans (append #pB (list #Z)) &MEJI 1 0))


  (princ)
);KP_WritePOLYLINE

;;;<HOM>***********************************************************************
;;; <関数名>    : KP_MEJIRotate
;;; <処理概要>  : 目地をその場で180度回転させる
;;; <戻り値>    : なし
;;; <作成>      : 01/04/06 YM
;;; <備考>      : MEJI定義が逆の場合 使用しない
;;;***********************************************************************>HOM<
(defun KP_MEJIRotate (
  &MEJI  ;3D目地図形
  &MEJI$ ;図形情報
  /
  #P1 #P2 #P3 #P4 #PA #PB #PT$ #Z
  #RET$ #XMAX #XMIN #YMAX #YMIN
  )
  (setq #Z (cdr (assoc 38 &MEJI$)))
  (setq #pt$ nil)
  (foreach elm &MEJI$
    (if (= (car elm) 10)
      (setq #pt$ (append #pt$ (list (cdr elm)))) ; MEJI 外形点列Objectの座標系
;;;     (setq #pt$ (append #pt$ (list (trans (append (cdr elm)(list #Z)) &MEJI 1 0)))) ; MEJI 外形点列
    );_if
  )
  (setq #ret$ (GetXYMaxMinFromPT$ #pt$))
  (setq #XMAX (nth 0 #ret$))
  (setq #XMIN (nth 1 #ret$))
  (setq #YMAX (nth 2 #ret$))
  (setq #YMIN (nth 3 #ret$))
  (setq #pA (GetCenterPT (list #XMIN #YMAX)(list #XMAX #YMAX)))
  (setq #pB (GetCenterPT (list #XMIN #YMIN)(list #XMAX #YMIN)))
  ; World座標系に変換
  (setq #pA (trans (append #pA (list #Z)) &MEJI 1 0))
  (setq #pB (trans (append #pB (list #Z)) &MEJI 1 0))
  (command "._rotate3D" &MEJI "" "2" #pA #pB 180)
  (princ)
);KP_MEJIRotate

;<HOM>*************************************************************************
; <関数名>    : KP_MakeHantenMEJI
; <処理概要>  : 目地の定義を裏表反転させたﾎﾟﾘﾗｲﾝを返す
; <戻り値>    :
; <作成>      : 01/04/07
; <備考>      :
;*************************************************************************>MOH<
(defun KP_MakeHantenMEJI (
  &MEJI ; 目地PLINE図形
  &Sym
  /
  #MEJI$ #pt$ #RB$ #LB$ #38 #210 #210- #Z #last
  #EG$ #LU_PT #PT
  )
  (setq #MEJI$ (CFGetXData &MEJI "G_MEJI"))
  (setq #eg$ (entget &MEJI))
  (setq #LU_PT (KcGetDoorInsertPnt &Sym &MEJI)) ; 扉左下
  (command "._ucs" "M" #LU_PT) ; 扉左下が原点
  (setq #38  (cdr (assoc  38 #eg$)))
  (setq #210 (cdr (assoc 210 #eg$)))
  (setq #210- (mapcar '- #210))

  (command "_.vpoint" #210-) ; 法線押し出し方向と反対のﾋﾞｭｰにする
  (command "_.UCS" "V") ; UCS 変更(原点は同じ)

  ; 目地ﾎﾟﾘﾗｲﾝ頂点取得===>現在のUCS座標系に変換
  (setq #pt$ nil)
  (foreach elm #eg$
    (if (= (car elm) 10)
      (progn
        (setq #pt (trans (append (cdr elm) (list #38)) &MEJI 1)) ; World座標系
;;;       (setq #pt (trans (append (cdr elm) (list #38)) &MEJI 1 0)) ; World座標系
;;;       (setq #pt (trans #pt 0 1)) ; 現在のUSC座標系
        (setq #pt$ (append #pt$ (list (list (car #pt)(cadr #pt)))))
      )
    );_if
  )
  (MakeLWPL #pt$ 1)
  (setq #last (entlast))

  (command "_.UCS" "W") ; 直前に戻す
  (command "zoom" "p")  ; VPOINT ビューを戻す
  #last
);KP_MakeHantenMEJI

;<HOM>*************************************************************************
; <関数名>    : KPstrViewLayer
; <処理概要>  : #strViewLayer を求める
; <戻り値>    : #strViewLayer
; <作成>      : 01/05/11 YM
; <備考>      : PCD_AlignDoor の行数を減らすのと、この関数を再利用するため作成
;*************************************************************************>MOH<
(defun KPstrViewLayer (
  &enName
  &enData$
  &DBGET
  /
  #DBGET #ENDATA$ #ENNAME #STRVIEWLAYER #TEMP$
  )
  (setq #enName &enName)
  (setq #enData$ &enData$)
  (setq #DBGET &DBGET)

  ;; 扉面指定されたデータが3D目地領域かどうかチェック(G_MEJI)
  (if (/= (setq #Temp$ (CFGetXData #enName "G_MEJI")) nil)
    (progn    ; 扉面指定が3D目地領域だった
      ;; G_MEJI の属性1を参照し、視点区分番号を取得する
      (if (< (nth 1 #Temp$) 10)
        (setq #strViewLayer "0")
      ;else
        (setq #strViewLayer "")
      )
      (if (or (and (<= (nth 1 #Temp$) 2) (>= (nth 1 #Temp$) 0))
              (> (nth 1 #Temp$) 6))
        (setq #strViewLayer (strcat #strViewLayer (itoa 3)))
      ;else
        (setq #strViewLayer (strcat #strViewLayer (itoa (nth 1 #Temp$))))
      )
      ;; 視点区分番号を表示画層格納変数に格納する
      (setq #strViewLayer (strcat SKD_DOOR_VIEW_LAYER1
                                  #strViewLayer
                                  SKD_DOOR_VIEW_LAYER2
                                  (substr #DbGet 6 2)    ; 03/04/01 YM MOD DR??** ==> DR???** 変更に伴う
                                  ;;;(substr #DbGet 5 2) ; 03/04/01 YM MOD DR??** ==> DR???** 変更に伴う
                                  SKD_DOOR_VIEW_LAYER3)
      )
    )
  ;else
    (progn  ; 扉面指定が3D目地領域ではなかった(2D扉領域だった  P面=7)
      (setq #strViewLayer (substr (cdr (assoc 8 #enData$)) 3 2))
      ;YM@ 例(8 . "Z_03_04_00_04")なら"03"(これは視点種類)
      ;YM@ 視点種類とは:03,04,05,06==>正面,背面,L側面,R側面

      ;; 2D扉領域データの画層を表示画層格納変数に格納する
      (setq #strViewLayer (strcat SKD_DOOR_VIEW_LAYER1  ;YM@ ="Q_"
                                  #strViewLayer         ;YM@ =例えば"03"
                                  SKD_DOOR_VIEW_LAYER2  ;YM@ ="_99_"
                                  (substr #DbGet 6 2)    ; 03/04/01 YM MOD DR??** ==> DR???** 変更に伴う
                                  ;;;(substr #DbGet 5 2) ; 03/04/01 YM MOD DR??** ==> DR???** 変更に伴う
                                  SKD_DOOR_VIEW_LAYER3) ;YM@ ="_##"
      )
    )
  );_if
  #strViewLayer
);KPstrViewLayer

;;;01/05/18YM@;<HOM>*************************************************************************
;;;01/05/18YM@; <関数名>    : KPGetDoorGroup
;;;01/05/18YM@; <処理概要>  : DoorGroup図形名を求める
;;;01/05/18YM@; <戻り値>    : DoorGroup図形名
;;;01/05/18YM@; <作成>      : 01/05/11 YM
;;;01/05/18YM@; <備考>      :
;;;01/05/18YM@;*************************************************************************>MOH<
;;;01/05/18YM@(defun KPGetDoorGroup (
;;;01/05/18YM@  &en
;;;01/05/18YM@  /
;;;01/05/18YM@  #EG$ #EG2 #I #RET
;;;01/05/18YM@  )
;;;01/05/18YM@  (setq #eg$ (entget &en '("*")))
;;;01/05/18YM@  (setq #i 0)
;;;01/05/18YM@  (foreach #eg #eg$
;;;01/05/18YM@    (if (= (car #eg) 330)
;;;01/05/18YM@      (progn
;;;01/05/18YM@        (setq #eg2 (entget (cdr #eg)))
;;;01/05/18YM@        (if (= (cdr (assoc 300 #eg2)) "DoorGroup") ; グループの説明
;;;01/05/18YM@          (setq #ret (cdr #eg))
;;;01/05/18YM@        );_if
;;;01/05/18YM@      )
;;;01/05/18YM@    );_if
;;;01/05/18YM@    (setq #i (1+ #i))
;;;01/05/18YM@  )
;;;01/05/18YM@  #ret
;;;01/05/18YM@);KPGetDoorGroup

;<HOM>*************************************************************************
; <関数名>    : KPGetDoorGroup
; <処理概要>  : DoorGroup図形名を求める
; <戻り値>    : DoorGroup図形名
; <作成>      : 01/05/11 YM
; <備考>      : 01/05/18 YM 戻り値ﾘｽﾄ形式
;*************************************************************************>MOH<
(defun KPGetDoorGroup (
  &en
  /
  #EG$ #EG2 #I #RET$
  )
  (setq #eg$ (entget &en '("*")))
  (setq #i 0)
  (foreach #eg #eg$
    (if (= (car #eg) 330)
      (progn
        (setq #eg2 (entget (cdr #eg)))
        (if (= (cdr (assoc 300 #eg2)) SKD_GROUP_INFO) ; グループの説明
          (setq #ret$ (append #ret$ (list (cdr #eg))))
        );_if
      )
    );_if
    (setq #i (1+ #i))
  )
  #ret$
);KPGetDoorGroup

;<HOM>*************************************************************************
; <関数名>    : KP_Get340SSFromDrgroup
; <処理概要>  : 扉"GROUP"図形(#Door)から340ﾒﾝﾊﾞｰ図形の選択ｾｯﾄを取得
; <戻り値>    : 選択ｾｯﾄ
; <作成>      : 01/05/18 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KP_Get340SSFromDrgroup (
  &group ; 扉ｸﾞﾙｰﾌﾟ図形
  /
  #EG$ #SS
  )
  (setq #ss (ssadd))
  (setq #eg$ (entget &group))
  (foreach #elm #eg$
    (if (= (car #elm) 340)
      ; 02/01/09 YM ADD-S ｼﾝﾎﾞﾙ基準点は除く
      (if (CFGetXData (cdr #elm) "G_SYM")
        nil
        (ssadd (cdr #elm) #ss)
      );_if
      ; 02/01/09 YM ADD-E ｼﾝﾎﾞﾙ基準点は除く
    );_if

;;;02/01/09YM@MOD   (if (= (car #elm) 340)
;;;02/01/09YM@MOD     (ssadd (cdr #elm) #ss)
;;;02/01/09YM@MOD   );_if

  )
  #ss
);KP_Get340SSFromDrgroup

;<HOM>*************************************************************************
; <関数名>    : KP_Get340SSFromDrgroup$
; <処理概要>  : 扉"GROUP"図形ﾘｽﾄ(#Door$)から全340ﾒﾝﾊﾞｰ図形の選択ｾｯﾄを取得
; <戻り値>    : 選択ｾｯﾄ
; <作成>      : 01/05/18 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KP_Get340SSFromDrgroup$ (
  &group$ ; 扉ｸﾞﾙｰﾌﾟ図形ﾘｽﾄ
  /
  #EG$ #SS #group
  )
  (setq #ss (ssadd))
  (foreach #group &group$
    (setq #eg$ (entget #group))
    (foreach #elm #eg$
      (if (= (car #elm) 340)
        (ssadd (cdr #elm) #ss)
      );_if
    )
  )
  #ss
);KP_Get340SSFromDrgroup$

;<HOM>*************************************************************************
; <関数名>    : KP_GetDoorBasePT
; <処理概要>  : 扉"GROUP"図形から扉部品を見て"POINT"図形を検索し位置座標(2D)を取得
; <戻り値>    : 位置座標ﾘｽﾄ
; <作成>      : 01/06/26 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KP_GetDoorBasePT (
  &eg$
  /
  #RET
  )
  (setq #ret nil)
  (foreach #elm &eg$
    (if (and (= (car #elm) 340)
             (= (cdr (assoc 0 (entget (cdr #elm)))) "POINT"))
      (setq #ret (cdr (assoc 10 (entget (cdr #elm)))))
    );_if
  )
  (list (car #ret)(cadr #ret)) ; 2D
);KP_GetDoorBasePT

;<HOM>*************************************************************************
; <関数名>    : KP_CheckDrgroup
; <処理概要>  : 扉"GROUP"図形ﾘｽﾄのうち&flgと合う扉"GROUP"図形を返す
; <戻り値>    : 扉"GROUP"図形
; <作成>      : 01/05/18 YM 01/06/27 YM MOD
; <備考>      : 扉を構成する図形がすべて同一画層であれば1つだけ見ればいいのだが
;               正面扉構成図形の画層末尾="1"、背面扉構成図形の画層末尾="2"
;               であるものがほとんどで、例外XLINE,POINTが存在するため
;               判定の際に数が50%以上かどうかとしている。
; ===> 扉ｸﾞﾙｰﾌﾟ名の命名方法を変更 従来DoorGroup+?-->DoorGroup+正面3,背面4+?
;*************************************************************************>MOH<
(defun KP_CheckDrgroup (
  &flg    ; 正面"3",背面"4"側面5,6などのﾌﾗｸﾞ
  &group$ ; 扉ｸﾞﾙｰﾌﾟ図形ﾘｽﾄ
  /
  #EG$ #RET #EG #GNAM #GROUP #I #LOOP #LOOP2 #N
  )
  (setq #ret nil)
  (cond
    ((= &flg "3")(setq CG_TOKU "1")) ; 正面扉を処理中 01/05/21 YM ADD
    ((= &flg "4")(setq CG_TOKU "2")) ; 背面扉を処理中 01/05/21 YM ADD
    ((= &flg "5")(setq CG_TOKU "3"))
    ((= &flg "6")(setq CG_TOKU "4"))
    (T (CFAlertErr "このタイプの特注キャビネットは対応していません。")(quit))
  );_cond

  (if (= 1 (length &group$))
    (setq #ret (car &group$)) ; 1つだけなら判定しない 01/05/28 YM
    (progn
      (setq #n 0 #loop T)
      (while (and #loop (< #n (length &group$)))
        (setq #group (nth #n &group$))
        (setq #eg$ (entget #group))
        (setq #i 0 #loop2 T)
        (while (and #loop2 (< #i (length #eg$)))
          (setq #eg (nth #i #eg$))
          (if (and (= (car #eg) 340)
                   (/= (cdr (assoc 0 (entget (cdr #eg)))) "POINT"))
            (progn ; ｸﾞﾙｰﾌﾟのﾒﾝﾊﾞｰで"POINT"以外
              (setq #loop2 nil)
              (setq #gnam (SKGetGroupName (cdr #eg))) ; ｸﾞﾙｰﾌﾟ名取得
            )
          );_if
          (setq #i (1+ #i))
        );while
        (if (= &flg (substr #gnam 10 1))
          (setq #ret #group #loop nil)
        );_if
        (setq #n (1+ #n))
      );while
    )
  );_if
  #ret
);KP_CheckDrgroup

;<HOM>*************************************************************************
; <関数名>    : KPGetEnDoor
; <処理概要>  : 扉ｸﾞﾙｰﾌﾟのﾒﾝﾊﾞｰの1つを返す
; <戻り値>    : 図形
; <作成>      : 01/05/11 YM
; <備考>      :
;*************************************************************************>MOH<
(defun KPGetEnDoor (
  &group ; ｸﾞﾙｰﾌﾟ図形
  /
  #340 #EG$ #ELM #I #LOOP
  )
  (setq #eg$ (entget &group))
  (setq #loop T #i 0)
  (while (and #loop (< #i (length #eg$)))
    (setq #elm (nth #i #eg$))
    (if (= (car #elm) 340)
      (progn
        (setq #340 (cdr #elm))
        (setq #loop nil)
      )
    );_if
    (setq #i (1+ #i))
  )
  #340
);KPGetEnDoor

;<HOM>*************************************************************************
; <関数名>    : KcGetDoorInsertPnt
; <処理概要>  : 扉図形の挿入3D点を求める
; <戻り値>    :
; <作成>      : 00/11/08 MH
; <備考>      : 構成点のZ値の最小と、X値の最端 の組み合わせを基点とする
;*************************************************************************>MOH<
(defun KcGetDoorInsertPnt (
  &eITEM      ; 目地領域の所属する親図形名
  &eMEJI      ; 目地領域図形名 "G_MEJI"をもつ LWPLINE
  /
  #DXF$ #$ #Z #P$ #_PNT$ #PNT$ #minZP #enANG #VP #ANG  #kariP #kriP1 #kriP2
  #crsP #dPNT #fDIST #TESP #layer #PMEN$ #eg$
  )
  ; LWPLINE の座標を現在のUCLの座標に変換
  (setq #DXF$ (entget &eMEJI))
  (foreach #$ #DXF$ (if (= 10 (car #$)) (setq #_PNT$ (cons (cdr #$) #_PNT$))))
  (setq #Z (cdr (assoc 38 #DXF$)))
  (foreach #P$ #_PNT$ (setq #PNT$ (cons (trans (append #P$ (list #Z)) &eMEJI 1 0) #PNT$)))
  ;(setq ##PNT$ #PNT$) ; テスト用

  ; 算出された座標のうち、Z値が最小のものを求める
  (setq #minZP (car #PNT$))
  (foreach #P$ (cdr #PNT$) (if (> (caddr #minZP) (caddr #P$)) (setq #minZP #P$)))

  ; 親図形の角度と目地領域の"G_MEJI"情報、LRフラグから求める点の方向を判定
  (setq #enANG (nth 2 (CFGetXData &eITEM "G_LSYM")))
  (setq #VP (cadr (CFGetXData &eMEJI "G_MEJI")))

  ; 01/05/22 YM ADD 展開図作成時は &eMEJI=PMEN7 STRAT
  (if (= nil #VP)
    (if (and (setq #PMEN$ (CFGetXData &eMEJI "G_PMEN"))
             (= 7 (car #PMEN$)))
      (progn
        (cond
          ((= "03" (substr (cdr (assoc 8 #DXF$)) 3 2))
            (setq #VP 3)
          )
          ((= "04" (substr (cdr (assoc 8 #DXF$)) 3 2))
            (setq #VP 4)
          )
          ((= "06" (substr (cdr (assoc 8 #DXF$)) 3 2))
            (setq #VP 6)
          )
          (T
            (setq #VP nil)
          )
        );_cond
      )
    );_if
  );_if
  ; 01/05/22 YM ADD 展開図作成時は &eMEJI=PMEN7 END

  (cond
    ; コーナー側面
    ((= 6 #VP) (setq #ANG (+ (* -0.5 pi) #enANG)))
    ; 背面
    ;((= 4 #VP) (setq #ANG #enANG)); 01/02/09 MH MOD 背面も同角度に設定
    ; その他は正面として算出 (= 0 #VP) 一般正面  (= 3 #VP) コーナー正面
    (t (setq #ANG (+ pi #enANG)))
  ); cond
  ; 条件に合う点摘出
  (setq #kariP (pcpolar #minZP #ANG 50000))
  (setq #kriP1 (list (car #kariP) (cadr #kariP))) ; 2次元点に変換
  (setq #kriP2 (pcpolar #kriP1 (+ (* 0.5 pi) #ANG) 1000))
  (setq #fDIST 100000); 仮の距離値
  (foreach #P$ #PNT$
    (setq #crsP (inters #P$ (Pcpolar #P$ #ANG 1000) #kriP1 #kriP2 nil))
    (if (> #fDIST (distance #P$ #crsP)) (progn
      (setq #fDIST (distance #P$ #crsP))
      (setq #dPNT #P$)
    )); if progn
  ); foreach
  (setq #tesP (list (car #dPNT) (cadr #dPNT) (caddr #minZP)))
  (list (car #dPNT) (cadr #dPNT) (caddr #minZP))
); KcGetDoorInsertPnt

;<HOM>*************************************************************************
; <関数名>    : PcGetLRButtomPos
; <処理概要>  : ポリラインと設置角度から右点、左点を算出
; <戻り値>    : 2次元点座標
; <作成>      : 00/08/21 MH
; <備考>      :
;*************************************************************************>MOH<
(defun PcGetLRButtomPos (
  &ePL        ; 扉ポリライン図形名
  &fANG       ; XY平面における設置角度
  &LR         ; LRフラグ "L"か"R"
  /
  #PL$ #fH #dPL$ #chkP1 #chkP2 #dP #crossP #dist #chkDist #resP #resZ
  )
  ;;; 扉ポリライン図形情報を座標点リストに変換（transかかる）
  (setq #PL$ (entget &ePL))
  (setq #fH (cdr (assoc 38 #PL$)))
  (while #PL$
    (if (= 10 (car (car #PL$)))
      (setq #dPL$ (cons (trans (append (cdr (car #PL$)) (list #fH)) &ePL 1 0) #dPL$))
    ); if
    (setq #PL$ (cdr #PL$))
  )

  ;;; 基準線から各点の垂直距離を算出。最大のものが右端点 最小のものが左端点
  ; 基準線を表す２点(2次元点)
  (setq #chkP1 '(0 0))
  (setq #chkP2 (pcpolar #chkP1 (+ &fANG (* 0.5 pi)) 100))
  (setq #resP nil)
  (setq #resZ nil)
  (foreach #dP #dPL$
    (setq #crossP (inters #chkP1 #chkP2 #dP (pcpolar #dP &fANG 100) nil))
    (setq #dist (distance #dP #crossP))
    (if (not (equal (read (angtos &fANG 0 4))
                    (read (angtos (angle #crossP #dP) 0 4)) 0.001))
      (setq #dist (- #dist))
    )
    ; 座標点リストの内、X値 Y値を取得
    (if (or (not #resP)
            (and (= "R" &LR) (< #chkDist #dist))
            (and (= "L" &LR) (> #chkDist #dist)))
      (progn
        (setq #resP #dP)
        (setq #chkDist #dist)
      ); progn
    ); if
    ; 座標点リストの内、Z値 を取得
    (if (or (not #resZ) (> #resZ (caddr #dP)))
      (setq #resZ (caddr #dP))
    ); if
  ); foreach
  (list (car #resP) (cadr #resP) #resZ )
); PcGetLRButtomPos

;;;<HOM>***********************************************************************
;;; <関数名>    : SKD_GetGroupSymbole
;;; <処理概要>  : グループ内のシンボルを探しだす
;;; <戻り値>    : 成功：シンボル図形のエンティティ名   失敗：nil
;;; <作成>      : 1998/07/27 -> 1998/07/28  松木 健太郎
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun SKD_GetGroupSymbole (
    &enData$    ; グループ検索したいデータリスト
    /
    #GName$      ; グループデータ格納用
    #iGrpLoop    ; グループ要素ループ用
    #SymData$    ; シンボルフラグ
    #num         ; グループデータ取得用
    #nn
    #iFlag       ;
    #Temp$       ; テンポラリリスト
    #iLoop       ; ループ用
    #GRPDATA$
  )

  (if (/= (assoc 330 &enData$) nil)
    (progn
      (setq #iLoop 0)
      (setq #iFlag 0)
      (while (and (< #iLoop (length &enData$)) (= #iFlag 0))
        (setq #num (nth #iLoop &enData$))
        (if (= (car #num) 330)
          (progn
            (setq #GrpData$ (entget (cdr #num)))

            (setq #iGrpLoop 0)
            (setq #SymData$ nil)
            ;; グループ要素ループ
            (while (and (< #iGrpLoop (length #GrpData$)) (= #SymData$ nil))    ; 全要素を調べるか、シンボルが見つかるまでループ
              (setq #Temp$ (nth #iGrpLoop #GrpData$))
              (if (= (car #Temp$) 340)
                (progn
                  (setq #SymData$ (CFGetXData (cdr #Temp$) "G_LSYM"))
                  (if (/= #SymData$ nil)
                    (progn
                      (setq #SymData$ (cdr #Temp$))
                      (setq #iFlag 1)
                    )
                  )
                )
              )
              (setq #iGrpLoop (+ #iGrpLoop 1))
            )
          )
        )
        (setq #iLoop (+ #iLoop 1))
      )
      (if (and (/= #iFlag 0) (/= #SymData$ nil))
        (progn
;;;          (CFOutStateLog 1 4 "    SKD_GetGroupSymbole=OK")
          #SymData$    ; return;
        )
        ;; else
        (progn
          (CFOutStateLog 0 4 "    SKD_GetGroupSymbole=グループからシンボルを取得できませんでした")
          nil    ; return;
        )
      )
    )
    ;; else
    (progn
      (CFOutStateLog 0 4 "    SKD_GetGroupSymbole=指定された図形はグループ化されているデータではありません")
      nil    ; return;
    )
  )
);SKD_GetGroupSymbole

;;;<HOM>***********************************************************************
;;; <関数名>    : PKD_MakeSqlBase
;;; <処理概要>  : 扉図形ID(ベース)をデータベースから取得する
;;; <戻り値>    : 成功：検索結果(扉図形ID)   失敗：nil
;;; <作成>      : 1998/07/25 -> 1998/07/25  松木 健太郎
;;; <備考>      :
;;;***********************************************************************>HOM<
(defun PKD_MakeSqlBase (
  &exData$ ; キャビネットの拡張データ(G_LSYM)
  &SetFace ; 2:PMEN7 , 3:MEJI
  /
  #strTemp    ; 文字列テンポラリ
  #strTemp2   ; 文字列テンポラリ
  #Code$      ; 検索キー格納リスト
  #enName     ; foreach 用
  #doorId
  #Qry$ #msg #DOORINFO #DRSERICODE #RET$ #SERI$
  )
	;2011/12/27 YM ADD-S DB接続が急に切れてしまう暫定対応
	(setq #doorId nil)
	(setq #skk (nth 9 &exData$))

;2016/03/16 YM ADD 食洗性格コード＝１１０　値が入っていると食洗に扉を貼らない Windows7はこの状態なので扉を貼る
(setq CG_SKK_INT_SYOKU nil)
;2016/03/16 YM ADD 食洗性格コード＝１１０　値が入っていると食洗に扉を貼らない

	(if (= #skk CG_SKK_INT_SYOKU)
		(progn
			nil ;何もしない
		)
		(progn


		;;;	;2011/12/05 YM MOD-S
		;;;	; SERIES別データベースへの接続
		;;;	(if (= CG_DBSESSION nil)
		;;;		(progn
		;;;			(princ "\n☆☆☆ SERIES別データベースへの再接続 ☆☆☆")
		;;;      (princ (strcat "\n☆☆☆　ｾｯｼｮﾝdisconnect & asilisp.arxを再ロードしてDBにCONNECT　☆☆☆"))
		;;;
		;;;			;ｼﾘｰｽﾞ別DB,共通DB再接続
		;;;			(ALL_DBCONNECT)
		;;;		)
		;;;	);_if
		;;;	;2011/12/05 YM MOD-E

		  (princ "\n☆☆☆　CG_DBSESSION　☆☆☆ :")(princ CG_DBSESSION)
		;-- 2011/11/29 A.Satoh Add - E

		  ; 01/10/31 YM ADD-S 部分扉変更キャビのとき展開図作成で図面の扉SERIESで扉を貼る
		  (if (= &SetFace 2)
		    (progn ; 展開図作成時
		      (setq #DoorInfo (nth 7 &exData$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"
		      (setq #ret$ (StrParse #DoorInfo ","))
		      (if (and #DoorInfo (/= #DoorInfo ""))
		        (progn
		          (setq #DRSeriCode (nth 0 #ret$))
		          (setq #CG_Hikite  (nth 2 #ret$));2011/04/22 YM ADD


		          (setq #Qry$
		            (CFGetDBSQLRec CG_DBSESSION "品番シリ"
		              (list
		                (list "品番名称"     (nth 5 &exData$)         'STR)
		                (list "LR区分"       (nth 6 &exData$)         'STR)
		                (list "扉シリ記号"   #DRSeriCode              'STR)
		                (list "引手記号"     #CG_Hikite               'STR)
		              )
		            )
		          )

		        )
		      );_if
		    )
		    (progn ; &SetFace=3のとき通常扉貼り付け

		      (setq #Qry$
		        (CFGetDBSQLRec CG_DBSESSION "品番シリ"
		          (list
		            (list "品番名称"     (nth 5 &exData$)         'STR)
		            (list "LR区分"       (nth 6 &exData$)         'STR)
		            (list "扉シリ記号"   CG_DRSeriCode            'STR)
		            (list "引手記号"     CG_Hikite                'STR)
		          )
		        )
		      )

		    )
		  );_if
		  ; 01/10/31 YM ADD-E 部分扉変更キャビのとき展開図作成で図面の扉SERIESで扉を貼る

			;2011/12/05 YM ADD
			(if (= nil #Qry$)
				(progn
		;;;			;ｼﾘｰｽﾞ別DB,共通DB再接続
		;;;			(ALL_DBCONNECT)

					;再検索
				  (if (= &SetFace 2)
				    (progn ; 展開図作成時
				      (setq #DoorInfo (nth 7 &exData$)) ; "扉ｼﾘｰｽﾞ,扉ｶﾗｰ記号"
				      (setq #ret$ (StrParse #DoorInfo ","))
				      (if (and #DoorInfo (/= #DoorInfo ""))
				        (progn
				          (setq #DRSeriCode (nth 0 #ret$))
				          (setq #CG_Hikite  (nth 2 #ret$));2011/04/22 YM ADD


				          (setq #Qry$
				            (CFGetDBSQLRec CG_DBSESSION "品番シリ"
				              (list
				                (list "品番名称"     (nth 5 &exData$)         'STR)
				                (list "LR区分"       (nth 6 &exData$)         'STR)
				                (list "扉シリ記号"   #DRSeriCode              'STR)
				                (list "引手記号"     #CG_Hikite               'STR)
				              )
				            )
				          )

				        )
				      );_if
				    )
				    (progn ; &SetFace=3のとき通常扉貼り付け

				      (setq #Qry$
				        (CFGetDBSQLRec CG_DBSESSION "品番シリ"
				          (list
				            (list "品番名称"     (nth 5 &exData$)         'STR)
				            (list "LR区分"       (nth 6 &exData$)         'STR)
				            (list "扉シリ記号"   CG_DRSeriCode            'STR)
				            (list "引手記号"     CG_Hikite                'STR)
				          )
				        )
				      )

				    )
				  );_if

				)
			);_if

		;;;01/08/31YM@  (setq #Qry$ (DBCheck #Qry$ "『品番シリ』" "PKD_MakeSqlBase"))

		  ; 01/08/31 YM ﾚｺｰﾄﾞなくても落ちないように
		  (if (and #Qry$ (= 1 (length #Qry$)))
		    (progn
		      (setq #doorId (nth 4 (car #Qry$))) ; 扉図ID
		    )
		    (progn
		      (setq #doorId nil) ; 品番シリにﾚｺｰﾄﾞがない or 重複
		      (princ (strcat "\n【品番シリ】にレコードがないかまたは重複しています。\n品番名称:" (nth 5 &exData$)
		                          "\n扉を貼る必要がない場合、マスタ図形の目地領域と扉貼りつけ領域を削除して下さい." "\n")
		      )
		    )
		  );_if

    )
  );_if

  #doorId
);PKD_MakeSqlBase

;<HOM>***********************************************************************
; <関数名>    : SKD_GetLeftButtomPos
; <処理概要>  : 扉面指定図形内の左下の座標を探し出す
; <戻り値>    : 成功： ((左下座標点リスト) (押し出し方向リスト))　　　失敗：nil
; <作成>      : 1998/07/27 -> 1998/07/27   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKD_GetLeftButtomPos (
    &enName      ; 扉面指定図形名
    /
    #Data$       ; 図形データ格納用
    #sx          ; 最小X値
    #sy          ; 最小Y値
    #nn          ; foreach 用
  )
  ;; 図形のデータを取得する
  (setq #Data$ (entget &enName))

  ;; 最小値のデフォルト設定
  (setq #sx (nth 0 (cdr (assoc 10 #Data$))))
  (setq #sy (nth 1 (cdr (assoc 10 #Data$))))

  ;; 図形構成データ数分ループ
  (foreach #nn #Data$
    ;; リストが座標値データかどうかのチェック
    (if (= (car #nn) 10)
      (progn    ; 座標値データだった
        ;; X値が現在の最小値より小さいかどうかチェック
        (if (<= (nth 0 (cdr #nn)) #sx)
          (progn    ; 小さかった
            ;; Y値が現在の最小値より小さいかどうかチェック
            (if (<= (nth 1 (cdr #nn)) #sy)
              (progn    ; 小さかった
                ;; 最小値の更新
                (setq #sx (nth 0 (cdr #nn)))
                (setq #sy (nth 1 (cdr #nn)))
              )
            )
          )
        )
      )
    )
  )

  ;; 両方の値が入力されているかどうかチェック
  (if (and (/= #sx nil) (/= #sy nil))
    (progn    ; 入力されていた
      (CFOutStateLog 1 4 "    SKD_GetLeftButtomPos=OK")
      (cons (list #sx #sy) (assoc 210 #Data$))    ; return;
    )
    ;; else
    (progn    ; どちらかが入力されていなかった
      (CFOutStateLog 0 4 "    SKD_GetLeftButtomPos=座標値を取得できませんでした")
      nil    ; return;
    )
  )
);SKD_GetLeftButtomPos

;<HOM>***********************************************************************
; <関数名>    : SKD_GetRightButtomPos
; <処理概要>  : 扉面指定図形内の右下の座標を探し出す
; <戻り値>    : 成功： ((右下座標点リスト) (押し出し方向リスト))　　　失敗：nil
; <作成>      : 1999/04/13    川本
; <備考>      :
;***********************************************************************>HOM<
(defun SKD_GetRightButtomPos (
    &enName      ; 扉面指定図形名
    /
    #Data$       ; 図形データ格納用
    #sx          ; 最小X値
    #sy          ; 最小Y値

    #nn          ; foreach 用
  )
  ;; 図形のデータを取得する
  (setq #Data$ (entget &enName))

  ;; 最小値のデフォルト設定
  (setq #sx (nth 0 (cdr (assoc 10 #Data$))))
  (setq #sy (nth 1 (cdr (assoc 10 #Data$))))

  ;; 図形構成データ数分ループ
  (foreach #nn #Data$
    ;; リストが座標値データかどうかのチェック
    (if (= (car #nn) 10)
      (progn    ; 座標値データだった
        ;; X値が現在の最小値より小さいかどうかチェック
        (if (>= (nth 0 (cdr #nn)) #sx) ; 背面扉不具合 00/06/30 MH MOD
        ;(if (> (nth 0 (cdr #nn)) #sx)
          (progn    ; 小さかった
            ;; Y値が現在の最小値より小さいかどうかチェック
            (if (<= (nth 1 (cdr #nn)) #sy)
              (progn    ; 小さかった
                ;; 最小値の更新
                (setq #sx (nth 0 (cdr #nn)))
                (setq #sy (nth 1 (cdr #nn)))
              )
            )
          )
        )
      )
    )
  )
  ;; 両方の値が入力されているかどうかチェック
  (if (and (/= #sx nil) (/= #sy nil))
    (progn    ; 入力されていた
      (CFOutStateLog 1 4 "    SKD_GetLeftButtomPos=OK")
      (cons (list #sx #sy) (assoc 210 #Data$))    ; return;
    )
    ;; else
    (progn    ; どちらかが入力されていなかった
      (CFOutStateLog 0 4 "    SKD_GetLeftButtomPos=座標値を取得できませんでした")
      nil    ; return;
    )
  )
);SKD_GetRightButtomPos

;<HOM>***********************************************************************
; <関数名>    : SKD_ChangeLayer
; <処理概要>  : 伸縮作業用画層から扉面指定されている画層に移動する
; <戻り値>    : なし
; <作成>      : 1998/07/31 -> 1998/07/31   松木 健太郎 2000/06/22 HT戻り値作成
; <備考>      :
;***********************************************************************>HOM<
(defun SKD_ChangeLayer (
    &enGroup    ; グループ化したグループのグループ名
    &strLayer   ; 移動先画層名
    /
    #Name$      ; グループ内の図形名格納用
    #Data$      ; グループ内の図形データのデータリスト格納用

    #nn         ; foreach用
    #lst$       ; 画層移動した図形名
#LAYER
  )
  (setq #Name$ (entget &enGroup))
  (setq #lst$ '())
  ;; データリスト数分ループ
  (foreach #nn #Name$
    ;; グループ構成図形名データかどうかのチェック
    (if (= (car #nn) 340)
      (progn    ; 図形名データだった
        ;; その図形のデータを取得する
        (setq #Data$ (entget (cdr #nn) '("*")))
        (setq #layer (cdr (assoc 8 #Data$)));03/10/17 YM ADD

        ;; 画層が伸縮作業用画層かどうかのチェック
        (if (= #layer SKD_TEMP_LAYER)
          (progn    ; 伸縮作業画層だった
            ;; 図形内の画層情報を書き換える(画層の移動)
;;;           (setq #Data$ (vl-remove (cons 62 1) #Data$)) ; 01/05/14 YM 効かない
            (entmod (subst (cons 8 &strLayer) (cons 8 SKD_TEMP_LAYER) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; 色を画層の色にする
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if

        ;★★★03/09/29 YM ADD-S 扉開き勝手線用
        ;; 画層が伸縮作業用画層かどうかのチェック
        ;画層"DOOR_OPEN"の扉図形は"SKD_TEMP_LAYER_0"としてからDOOR_OPENに戻す

        (if (= #layer SKD_TEMP_LAYER_0)
          (progn    ; 伸縮作業画層だった
            ;; 図形内の画層情報を書き換える(画層の移動)
            (entmod (subst (cons 8 DOOR_OPEN) (cons 8 SKD_TEMP_LAYER_0) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; 色を画層の色にする
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if
        ;★★★03/09/29 YM ADD-E 扉開き勝手線用

        ;★★★03/10/17 YM ADD-S 扉開き勝手線用
        ;画層"DOOR_OPEN_04"の扉図形は"SKD_TEMP_LAYER_4"としてからDOOR_OPEN_04に戻す
        ;画層"DOOR_OPEN_06"の扉図形は"SKD_TEMP_LAYER_6"としてからDOOR_OPEN_06に戻す
        (if (= #layer SKD_TEMP_LAYER_4);背面扉開き勝手線
          (progn    ; 伸縮作業画層だった
            ;; 図形内の画層情報を書き換える(画層の移動)
            (entmod (subst (cons 8 DOOR_OPEN_04) (cons 8 SKD_TEMP_LAYER_4) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; 色を画層の色にする
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if

        (if (= #layer SKD_TEMP_LAYER_6);右側面扉開き勝手線
          (progn    ; 伸縮作業画層だった
            ;; 図形内の画層情報を書き換える(画層の移動)
            (entmod (subst (cons 8 DOOR_OPEN_06) (cons 8 SKD_TEMP_LAYER_6) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; 色を画層の色にする
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if
        ;★★★03/10/17 YM ADD-E 扉開き勝手線用
      )
    );_if
  )
  #lst$
);SKD_ChangeLayer

;<HOM>***********************************************************************
; <関数名>    : SKD_ChangeLayer_FMAT
; <処理概要>  : 伸縮作業用画層から扉面指定されている画層に移動する
; <戻り値>    : なし
; <作成>      : 1998/07/31 -> 1998/07/31   松木 健太郎 2000/06/22 HT戻り値作成
; <備考>      : 03/09/29 YM 展開図作成専用 "DOOR_OPEN"画層の扉図形は
;               "SKD_TEMP_LAYER_0"→"0_door_0"にする
;***********************************************************************>HOM<
(defun SKD_ChangeLayer_FMAT (
    &enGroup    ; グループ化したグループのグループ名
    &strLayer   ; 移動先画層名
    /
    #Name$      ; グループ内の図形名格納用
    #Data$      ; グループ内の図形データのデータリスト格納用

    #nn         ; foreach用
    #lst$       ; 画層移動した図形名
  )
  (setq #Name$ (entget &enGroup))
  (setq #lst$ '())
  ;; データリスト数分ループ
  (foreach #nn #Name$
    ;; グループ構成図形名データかどうかのチェック
    (if (= (car #nn) 340)
      (progn    ; 図形名データだった
        ;; その図形のデータを取得する
        (setq #Data$ (entget (cdr #nn) '("*")))
        ;; 画層が伸縮作業用画層かどうかのチェック
        (if (= (cdr (assoc 8 #Data$)) SKD_TEMP_LAYER)
          (progn    ; 伸縮作業画層だった
            ;; 図形内の画層情報を書き換える(画層の移動)
;;;           (setq #Data$ (vl-remove (cons 62 1) #Data$)) ; 01/05/14 YM 効かない
            (entmod (subst (cons 8 &strLayer) (cons 8 SKD_TEMP_LAYER) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; 色を画層の色にする
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if

        ;★★★03/09/29 YM ADD-S 扉開き勝手線用
        ;; 画層が伸縮作業用画層かどうかのチェック
        ;画層"0"の扉図形は"SKD_TEMP_LAYER_0"としてから元に戻す→展開図作成で"0_door_0"
        (if (= (cdr (assoc 8 #Data$)) SKD_TEMP_LAYER_0)
          (progn    ; 伸縮作業画層だった
            ;; 図形内の画層情報を書き換える(画層の移動)
            (entmod (subst (cons 8 "0_door_0") (cons 8 SKD_TEMP_LAYER_0) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; 色を画層の色にする
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if
        ;★★★03/09/29 YM ADD-E 扉開き勝手線用

        ;★★★03/10/17 YM ADD-S 扉開き勝手線 背面、右側面用
        ;; 画層が伸縮作業用画層かどうかのチェック
        ;画層"0"の扉図形は"SKD_TEMP_LAYER_0"としてから元に戻す→展開図作成で"0_door_0"
        (if (= (cdr (assoc 8 #Data$)) SKD_TEMP_LAYER_4);背面
          (progn    ; 伸縮作業画層だった
            ;; 図形内の画層情報を書き換える(画層の移動)
            (entmod (subst (cons 8 "0_door_4") (cons 8 SKD_TEMP_LAYER_4) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; 色を画層の色にする
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if
        (if (= (cdr (assoc 8 #Data$)) SKD_TEMP_LAYER_6);右側面
          (progn    ; 伸縮作業画層だった
            ;; 図形内の画層情報を書き換える(画層の移動)
            (entmod (subst (cons 8 "0_door_6") (cons 8 SKD_TEMP_LAYER_6) #Data$))
            (command "_chprop" (cdr #nn) "" "C" "BYLAYER" "") ; 色を画層の色にする
            (setq #lst$ (append #lst$ (list (cdr #nn))))
          )
        );_if
        ;★★★03/10/17 YM ADD-E 扉開き勝手線 背面、右側面用

      )
    );_if
  )
  #lst$
);SKD_ChangeLayer_FMAT

;<HOM>***********************************************************************
; <関数名>    : SKD_DeleteNotView
; <処理概要>  : インサート図形を分解し、不要な画層のデータは削除し、
;                残った表示するデータを伸縮作業画層に移動し、グループ化する
; <戻り値>    : 成功： グループ化したグループのエンティティ名　　　失敗：nil
; <作成>      : 1998/07/29 -> 1998/07/30   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKD_DeleteNotView (
  &enName        ; 処理するインサート図形の図形名
  &strViewLayer  ; 表示する画層名
  /
  #ssData$       ; 分解後の図形データ名格納用
  #enData$       ; 図形データ格納用
  #enName$       ; 有効図形名リスト格納用
  #strDelBreak   ; 削除ブレークラインの画層名

  #iLoop         ; ループ用
  #nn            ; foreach 用
#LAYER #dir #330 #EG$
  )
  ;; インサート図形を分解する
  (command "_explode" &enName)

  ;; 分解されたデータの取得
  (setq #ssData$ (ssget "P"))
  (setq #enName$ nil)

  ;方向
  (setq #dir         (substr &strViewLayer 3 2));03/10/17 YM ADD

  (setq #strDelBreak (substr &strViewLayer 3 2))
  ;; 削除するブレークラインの画層名を決める
  (cond
    ((or (= #strDelBreak "05") (= #strDelBreak "06"))    ; 側面だった
      (setq #strDelBreak "N_BREAKW")
    )
    (T    ; 正面、背面、その他だった
      (setq #strDelBreak "N_BREAKD")
    )
  )

  ;; 分解されたデータ数分ループ
  (setq #iLoop 0)
  (while (< #iLoop (sslength #ssData$))
    (setq #enData$ (entget (ssname #ssData$ #iLoop)))
    (setq #layer (cdr (assoc 8 #enData$)));03/10/17 YM ADD

    ;; データの画層が表示する画層と同一かどうかチェック
    (if (= (wcmatch #layer &strViewLayer) T)                  ;"Q_03_99_01_##" 
      (progn    ; 同一画層だった
        ;; 画層を移動先画層に変更する
        (entmod (subst (cons 8 SKD_TEMP_LAYER) (assoc 8 #enData$) #enData$))
        ;; 図形名を格納する
        (setq #enName$ (cons (cdr (car #enData$)) #enName$)) ; (-1 . 図形名)
      )
      ;; else
      (progn    ; 同一画層ではなかった
        ;; デフォルト指定画層かどうかのチェック
        (if (= (wcmatch #layer SKD_MATCH_LAYER) T)             ;"Q_00_99_##_"
          (progn    ; デフォルト指定画層だった
            ;; 画層を移動先画層に変更する
            (entmod (subst (cons 8 SKD_TEMP_LAYER) (assoc 8 #enData$) #enData$))
            ;; 図形名を格納する
            (setq #enName$ (cons (cdr (car #enData$)) #enName$))
          )
          ;; else
          (progn    ; デフォルト指定画層ではなかった
            ;; ブレークラインかどうかのチェック
            (if (/= (wcmatch (strcase #layer) SKD_BREAK_LINE) T);"N_BREAK@"
              (progn    ; ブレークラインではなかった

                ;★★★03/09/29 YM ADD-S 扉開き勝手線用
                ;画層"DOOR_OPEN"の扉図形は別扱い→"SKD_TEMP_LAYER_0"画層にしてからDOOR_OPENに戻す→展開図作成で"0_door_0"
                ;"DOOR_OPEN_04"背面"DOOR_OPEN_06"右側面　も追加
                (cond
                  ((= DOOR_OPEN   (strcase #layer))
                    (if (or (= #dir "04")(= #dir "05")(= #dir "06"))
                      (progn
                        (entdel (ssname #ssData$ #iLoop))
                      )
                      ;else
                      (progn
                        (entmod (subst (cons 8 SKD_TEMP_LAYER_0) (assoc 8 #enData$) #enData$))
                        (setq #enName$ (cons (cdr (car #enData$)) #enName$))
                      )
                    );_if
                  )
                  ((= DOOR_OPEN_04 (strcase #layer))
                    (if (or (= #dir "03")(= #dir "05")(= #dir "06"))
                      (progn
                        (entdel (ssname #ssData$ #iLoop))
                      )
                      ;else
                      (progn
                        (entmod (subst (cons 8 SKD_TEMP_LAYER_4) (assoc 8 #enData$) #enData$))
                        (setq #enName$ (cons (cdr (car #enData$)) #enName$))
                      )
                    );_if
                  )
                  ((= DOOR_OPEN_06 (strcase #layer))
                    (if (or (= #dir "03")(= #dir "04")(= #dir "05"))
                      (progn
                        (entdel (ssname #ssData$ #iLoop))
                      )
                      ;else
                      (progn
                        (entmod (subst (cons 8 SKD_TEMP_LAYER_6) (assoc 8 #enData$) #enData$))
                        (setq #enName$ (cons (cdr (car #enData$)) #enName$))
                      )
                    );_if
                  )
                  (T  ;今までどおり
                    ;; データ削除
                    (entdel (ssname #ssData$ #iLoop))
                  )
                );_cond

;;;03/10/17YM ADD               (if (= DOOR_OPEN (strcase (cdr (assoc 8 #enData$))))
;;;03/10/17YM ADD                 (progn
;;;03/10/17YM ADD                   (entmod (subst (cons 8 SKD_TEMP_LAYER_0) (assoc 8 #enData$) #enData$))
;;;03/10/17YM ADD                   (setq #enName$ (cons (cdr (car #enData$)) #enName$))
;;;03/10/17YM ADD                 )
;;;03/10/17YM ADD                 ;else
;;;03/10/17YM ADD                 (progn;今までどおり
;;;03/10/17YM ADD                   ;; データ削除
;;;03/10/17YM ADD                   (entdel (ssname #ssData$ #iLoop))
;;;03/10/17YM ADD                 )
;;;03/10/17YM ADD               );_if

              )
              ;; else
              (progn
                ;; 削除するブレークラインかどうかのチェック
                (if (= (strcase #layer) #strDelBreak)
                  (progn    ; 削除するブレークラインだった
                    ;; データ削除
                    (entdel (ssname #ssData$ #iLoop))
                  )
                  ;; else
                  (progn
                    ;; 図形名を格納する
                    (setq #enName$ (cons (cdr (car #enData$)) #enName$))
                  )
                )
              )
            )
          )
        )
      )
    )
    (setq #iLoop (+ #iLoop 1))
  )

  ;; 格納した移動後図形名のリストが nil でないかどうかチェック
  (if (/= #enName$ nil)
    (progn    ; リスト内に図形名が存在した
      (setq SKD_GROUP_NO (SCD_GetDoorGroupName)) ; 00/06/30 YM NR(4/25)から挿入
;;;      (setq SKD_GROUP_NO (+ SKD_GROUP_NO 1))  ; 00/06/30 YM MOD

      ;; 格納した移動後図形の全てを同一のグループにする(グループ化)
      (command "-group" "C" (strcat SKD_GROUP_HEAD (substr &strViewLayer 4 1) (itoa SKD_GROUP_NO)) SKD_GROUP_INFO)
      (foreach #nn #enName$
        (command #nn)
      )
      (command "")
      ;; グループ化したデータのグループ図形名を取得する

			;2015/12/17 YM MOD-S
;;;      (setq #enData$ (cdr (assoc -1 (entget (cdr (assoc 330 (entget (nth 0 #enName$))))))))
			;グループ図形名を取得するロジックを変更する　誤って取得して扉の画層を"M*"に戻せない不具合がある
			(setq #eg$ (entget (nth 0 #enName$)))
			(foreach #eg #eg$
				(if (= 330 (car #eg))
					(progn
						(setq #330 (cdr #eg))
						(if (= "GROUP" (cdr (assoc 0 (entget #330))))
							(setq #enData$ (cdr (assoc -1 (entget #330))))
						);_if
					)
				);_if
			);foreach
			;2015/12/17 YM MOD-E


      ;; 正常終了
      #enData$    ; return;
    )
    ;; else
    (progn    ; 図形名が存在しなかった(nil)
      ;; 異常終了：表示画層のデータが存在しませんでした
      nil    ; return;
    )
  )
);SKD_DeleteNotView

;<HOM>***********************************************************************
; <関数名>    : SKD_DeleteNotView_TOKU
; <処理概要>  : 扉図形を伸縮作業画層に移動
; <戻り値>    : なし
; <作成>      : 特注ｷｬﾋﾞｺﾏﾝﾄﾞ用 01/05/11 YM
; <備考>      :
;***********************************************************************>HOM<
(defun SKD_DeleteNotView_TOKU (
  &enDoor$       ; 扉図形選択ｾｯﾄ
  /
  #ENDATA$ #ILOOP #LAYER
  )
  (setq #iLoop 0)
  (while (< #iLoop (sslength &enDoor$))
    (setq #enData$ (entget (ssname &enDoor$ #iLoop)))
    (setq #layer (cdr (assoc 8 #enData$)));03/10/17 YM ADD

    ; POINT,XLINE以外の画層をSKD_TEMP_LAYERにする
;-- 2012/03/27 A.Satoh Mod CG取っ手が出ない - S
;;;;;    (if (or (= (cdr (assoc 0 #enData$)) "POINT")(= (cdr (assoc 0 #enData$)) "XLINE"))
    (if (= (cdr (assoc 0 #enData$)) "XLINE")
;-- 2012/03/27 A.Satoh Mod CG取っ手が出ない - S
      nil
      ;else
      (progn
;-- 2012/03/27 A.Satoh Add CG取っ手が出ない - S
				(if (= (cdr (assoc 0 #enData$)) "POINT")
					(if (= (car (CFGetXData (ssname &enDoor$ #iLoop) "G_PTEN")) 21)
						(cond
							((= DOOR_OPEN (strcase #layer))
								(entmod (subst (cons 8 SKD_TEMP_LAYER_0) (assoc 8 #enData$) #enData$))
							)
							((= DOOR_OPEN_04 (strcase #layer))
								(entmod (subst (cons 8 SKD_TEMP_LAYER_4) (assoc 8 #enData$) #enData$))
							)
							((= DOOR_OPEN_06 (strcase #layer))
								(entmod (subst (cons 8 SKD_TEMP_LAYER_6) (assoc 8 #enData$) #enData$))
							)
							(T
								(entmod (subst (cons 8 SKD_TEMP_LAYER)   (assoc 8 #enData$) #enData$))
							)
						)
					)
					(progn
						; ポイント図形でなければ
;-- 2012/03/27 A.Satoh Add CG取っ手が出ない - E

        ;★★★03/09/29 YM ADD-S 扉開き勝手線用
        ;画層"DOOR_OPEN"の扉図形は別扱い→"SKD_TEMP_LAYER_0"画層にしてからDOOR_OPENに戻す→展開図作成で"0_door_0"
        ;画層"DOOR_OPEN_04"背面"DOOR_OPEN_06"右側面も追加
        (cond
          ((= DOOR_OPEN (strcase #layer))
            (entmod (subst (cons 8 SKD_TEMP_LAYER_0) (assoc 8 #enData$) #enData$))
          )
          ((= DOOR_OPEN_04 (strcase #layer))
            (entmod (subst (cons 8 SKD_TEMP_LAYER_4) (assoc 8 #enData$) #enData$))
          )
          ((= DOOR_OPEN_06 (strcase #layer))
            (entmod (subst (cons 8 SKD_TEMP_LAYER_6) (assoc 8 #enData$) #enData$))
          )
          (T
            (entmod (subst (cons 8 SKD_TEMP_LAYER)   (assoc 8 #enData$) #enData$))
          )
        );_cond
;-- 2012/03/27 A.Satoh Add CG取っ手が出ない - S
					)
				)
;-- 2012/03/27 A.Satoh Add CG取っ手が出ない - E

;;;03/10/17YM ADD       (if (= DOOR_OPEN (strcase #layer))
;;;03/10/17YM ADD         (entmod (subst (cons 8 SKD_TEMP_LAYER_0) (assoc 8 #enData$) #enData$))
;;;03/10/17YM ADD         ;else
;;;03/10/17YM ADD         (entmod (subst (cons 8 SKD_TEMP_LAYER)   (assoc 8 #enData$) #enData$))
;;;03/10/17YM ADD       );_if

      )
    );_if
    (setq #iLoop (+ #iLoop 1))
  );while
  (princ)
);SKD_DeleteNotView_TOKU

;;;<HOM>*************************************************************************
;;; <関数名>    : SCD_GetDoorGroupName
;;; <処理概要>  : 扉図形のグループ作成
;;; <戻り値>    :
;;;         STR : 扉図形名
;;; <作成>      : 00/02/29
;;; <備考>      : 00/06/30 YM NR(4/25)から挿入
;;;*************************************************************************>MOH<
(defun SCD_GetDoorGroupName (
  /
  #Eg$ #eXen #Sub$ #Eg$$ #sName #sTmp
  #eg #eg$ #i #en #no #no$
  )
  (setq #eg$ (entget (namedobjdict)))
  (setq #i 0)
  (setq #en nil)
  (while (and (= #en nil) (< #i (length #eg$)))
    (setq #eg (nth #i #eg$))
    (if (and (= 3 (car #eg)) (= "ACAD_GROUP" (cdr #eg)))
      (setq #en (cdr (nth (1+ #i) #eg$)))
    )
    (setq #i (1+ #i))
  )
  (if (= #en nil)
    (setq #no 0)
    (progn
      (setq #eg$ (entget #en))
      (setq #i 0)
      (while (< #i (length #eg$))
        (setq #eg (nth #i #eg$))
        (if (and (= 3 (car #eg)) (= "DOORGROUP" (substr (cdr #eg) 1 9)))
;;;01/06/27YM@          (setq #no$ (cons (atoi (substr (cdr #eg) 10)) #no$))
          (setq #no$ (cons (atoi (substr (cdr #eg) 11)) #no$)) ; 正面:"DOORGROUP30",背面:"DOORGROUP40"に変更
        )
        (setq #i (1+ #i))
      )
      (if (= #no$ nil)
        (setq #no 0)
        (progn
          ;// 開き番号を取得する
          (setq #i 1)
          (setq #no nil)
          (while (= #no nil)
            (if (= nil (member #i #no$))
              (setq #no #i)
            )
            (setq #i (1+ #i))
          )
        )
      )
    )
  )
  #no
);SCD_GetDoorGroupName

;<HOM>***********************************************************************
; <関数名>    : SKD_GetDoorPos
; <処理概要>  : 扉面の領域を取得する
; <戻り値>    : 成功： 右上と左上の座標を返す　　　失敗：nil
; <作成>      : 1998/08/03 -> 1998/08/03   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKD_GetDoorPos (
    &enGroup    ; 扉面のグループ名
    /
    #enName$    ; グループ内図形名格納用
    #enData$    ; 図形内データリスト格納用

    #MaxX       ; X 最大座標値
    #MaxY       ; Y 最大座標値
    #MaxZ       ; Z 最大座標値
    #MinX       ; X 最小座標値
    #MinY       ; Y 最小座標値
    #MinZ       ; Z 最小座標値

    #Temp$      ; テンポラリリスト
    #nn         ; foreach 用
    #mm         ; foreach 用
    #View$
  )
  ;; グループデータ取得
  (setq #enName$ (entget &enGroup))

  ;; グループ要素数分ループ
  (foreach #nn #enName$
    ;; グループ構成図形名かどうかのチェック
    (if (= (car #nn) 340)
      (progn    ; グループ構成図形名だった
        ;; グループ構成図形のデータを取得
        (setq #enData$ (entget (cdr #nn)))
        ;; データ構成数分ループ
        (if (or (= (cdr (assoc 0 #enData$)) "LINE") (= (cdr (assoc 0 #enData$)) "LWPOLYLINE") (= (cdr (assoc 0 #enData$)) "POLYLINE"))
          (progn
            (foreach #mm #enData$
              ;; データが座標値かどうかのチェック
              (if (or (= (car #mm) 10) (= (car #mm) 11))
                (progn    ; 座標値だった
                  ;; 座標変換
                  (setq #Temp$ (trans (cdr #mm) (cdr #nn) 1 0))

                  ;; 初期値の代入がされているかどうかのチェック
                  (if (= #MaxX nil)
                    (progn    ; 初期値が代入されていなかった
                      ;; 初期値入力
                      (setq #MaxX (nth 0 #Temp$))
                      (setq #MaxY (nth 1 #Temp$))
                      (setq #MaxZ (nth 2 #Temp$))
                      (setq #MinX (nth 0 #Temp$))
                      (setq #MinY (nth 1 #Temp$))
                      (setq #MinZ (nth 2 #Temp$))
                    )
                  )
                  ;; 最大 X 値チェック
                  (if (< #MaxX (nth 0 #Temp$))
                    (progn
                      (setq #MaxX (nth 0 #Temp$))
                    )
                  )
                  ;; 最大 Y 値チェック
                  (if (< #MaxY (nth 1 #Temp$))
                    (progn
                      (setq #MaxY (nth 1 #Temp$))
                    )
                  )
                  ;; 最大 Z 値チェック
                  (if (< #MaxZ (nth 2 #Temp$))
                    (progn
                      (setq #MaxZ (nth 2 #Temp$))
                    )
                  )
                  ;; 最小 X 値チェック
                  (if (> #MinX (nth 0 #Temp$))
                    (progn
                      (setq #MinX (nth 0 #Temp$))
                    )
                  )
                  ;; 最小 Y 値チェック
                  (if (> #MinY (nth 1 #Temp$))
                    (progn
                      (setq #MinY (nth 1 #Temp$))
                    )
                  )
                  ;; 最小 Z 値チェック
                  (if (> #MinZ (nth 2 #Temp$))
                    (progn
                      (setq #MinZ (nth 2 #Temp$))
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

  (if (and (/= #MaxX nil) (/= #MaxY nil) (/= #MinX nil) (/= #MinY nil))
    (progn
      (CFOutStateLog 1 4 "      SKD_GetDoorPos=End OK")
      ;; return;
      (setq #view$ (trans (getvar "VIEWDIR") 1 0))
;;; 00/05/11 DEL MH 背面処理部を削除
;;; 00/05/11 DEL MH (if (and (equal (car #view$) 0 0.01) (equal (cadr #view$) 1 0.01) (equal (caddr #view$) 0 0.01))
;;; 00/05/11 DEL MH         (list (list #MinX #MaxY) (list #MaxX #MinY)) ;背面の時
      (list (list #MaxX #MaxY) (list #MinX #MinY)) ;背面でない
;;; 00/05/11 DEL MH       )
    )
    ;; else
    (progn
      (CFOutStateLog 0 4 "      SKD_GetDoorPos=End 扉面領域が正常に取得できませんでした")
      ;; return;
      nil
    )
  )
);SKD_GetDoorPos

;<HOM>***********************************************************************
; <関数名>    : SKD_FigureExpansion
; <処理概要>  : 図形を伸縮する
; <戻り値>    : 成功： T　　　失敗：nil
; <作成>      : 1998/07/31 -> 1998/08/03   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKD_FigureExpansion (
  &enGroup    ; 伸縮を行うグループのグループ名
  &Rect$      ; 扉面領域の矩形座標((右上座標) (左下座標))
  &ViewZ$     ; Z 軸上での正の点を指定(押し出し方向)(ex : (0 -1 0))
  /
  #enName$    ; グループ構成図形名格納用
  #brkH$      ; ブレークラインH方向図形名格納用
;;;01/09/25YM@DEL  #brkE$      ; ブレークラインW方向もしくは、D方向の図形名格納用
  #brkW$      ; ブレークラインW方向
  #brkD$      ; ブレークラインD方向
  #DoorPos$   ; 扉面領域の右上座標と左下座標格納用((右上X座標 右上Y座標) (左下X座標 左下Y座標))
  #iExpAmount ; 伸縮量格納用
  #BrkLine    ; ブレークライン位置格納用
  #Temp$      ; テンポラリリスト
  #nn         ; foreach 用
  #iLoop      ; ループ用
  #BrkLine$    ; ブレークライン位置格納用
  #BrkD$ #BrkW$ #OS #SM #UF #GR #OT #UV
  #clayer
  )
  (CFOutStateLog 1 4 "    SKD_FigureExpansion=Start")

;;;(command "-layer" "T" "*" "ON" "*" "U" "*" "") ; 00/03/09 YM ADD

  (setq #os (getvar "OSMODE"))     ; 00/03/08 YM ADD
  (setq #sm (getvar "SNAPMODE"))   ; 00/03/08 YM ADD
  (setq #uf (getvar "UCSFOLLOW"))  ; 00/03/08 YM ADD
  (setq #uv (getvar "UCSVIEW"))    ; 00/03/08 YM ADD
  (setq #gr (getvar "GRIDMODE"))   ; 00/03/08 YM ADD
  (setq #ot (getvar "ORTHOMODE"))  ; 00/03/08 YM ADD

;;;  (setq #wv (getvar "WORLDVIEW"))

  (setvar "OSMODE"     0) ; 00/03/08 YM ADD
  (setvar "SNAPMODE"   0) ; 00/03/08 YM ADD
  ;(setvar "UCSFOLLOW"  1) ; 00/03/08 YM ADD ; 2000/09/12 HT MOD 速度改善のため
  (setvar "UCSFOLLOW"  0) ; 00/03/08 YM ADD  ; 2000/09/12 HT MOD 速度改善のため
  (setvar "UCSVIEW"  0)   ; 00/03/08 YM ADD
  (setvar "GRIDMODE" 0)   ; 00/03/08 YM ADD
  (setvar "ORTHOMODE" 0)  ; 00/03/08 YM ADD
;;;  (setvar "WORLDVIEW"  0)

  ;; UCS 変更
  (command "_UCS" "ZA" "0,0,0" &ViewZ$)

  (command "_PLAN" "C")  ; 2000/09/12 HT MOD 速度改善のため
  ;; グループ内の図形名を取得
  (setq #enName$ (entget &enGroup))
  ;; ブレークラインの有無をチェック
  (foreach #nn #enName$
    ;; グループ構成図形名かどうかのチェック
    (if (= (car #nn) 340)
      (progn    ; 図形名だった
        ;; ブレークラインの拡張情報の有無チェック
        (setq #Temp$ (CFGetXData (cdr #nn) "G_BRK"))
        (if (/= #Temp$ nil)
          (progn    ; ブレークライン拡張情報があった
            ;; ブレークラインの方向をチェック
            (cond
              ((= (nth 0 #Temp$) 1)    ; W方向かどうかのチェック(1)
                (setq #brkW$ (cons (cdr #nn) #brkW$))
;;;01/09/25YM@DEL                (setq #brkE$ (cons (cdr #nn) #brkE$))
              )
              ((= (nth 0 #Temp$) 2)    ; D方向かどうかのチェック(2)
                (setq #brkD$ (cons (cdr #nn) #brkD$))
;;;01/09/25YM@DEL                (setq #brkE$ (cons (cdr #nn) #brkE$))
              )
              ((= (nth 0 #Temp$) 3)    ; H方向かどうかのチェック(3)
                (setq #brkH$ (cons (cdr #nn) #brkH$))
              )
            )
          )
        )
      )
    )
  )

  ;; 扉面の領域を取得する
  (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
  (if (/= #DoorPos$ nil)
    (if (or (/= #brkW$ nil) (/= #brkD$ nil) (/= #brkH$ nil))
      (progn
         (command "_vpoint" &ViewZ$)
      )
    )
  )

  ;/////////////////////////////////////////////////////////////
  ; 現在画層の変更
;;;01/06/07YM@  (setq #clayer (getvar "CLAYER"))
;;;01/06/07YM@  (setvar "CLAYER" SKD_TEMP_LAYER)
;;;01/06/07YM@  ; 現在画層以外をﾌﾘｰｽﾞ 01/06/07
;;;01/06/07YM@  (command "_layer" "F" "*" "") ;全ての画層をﾌﾘｰｽﾞ
;;;01/06/07YM@  (command "_zoom" "E") ; object範囲ｽﾞｰﾑ
;;;01/06/07YM@  (command "_zoom" "0.8x")

  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKD_TEMP_LAYER)
  ; 現在画層以外をﾌﾘｰｽﾞ 01/06/07
  (command "_layer" "F" "*" "") ;全ての画層をﾌﾘｰｽﾞ

  ;03/10/20 YM ADD-S
  (command "_.layer" "T" SKD_TEMP_LAYER_0 "") ; 03/10/17 YM ADD
  (command "_.layer" "T" SKD_TEMP_LAYER_4 "") ; 03/10/17 YM ADD
  (command "_.layer" "T" SKD_TEMP_LAYER_6 "") ; 03/10/17 YM ADD
  ;03/10/20 YM ADD-E

  (command "_zoom" "E") ; object範囲ｽﾞｰﾑ
  (command "_zoom" "0.5x")

  ;; H 方向ブレークラインの有無チェック
  (if (and (/= #brkH$ nil) (/= #DoorPos$ nil))
    (progn    ; H 方向ブレークラインがあった
      (setq #brkH$ (SKESortBreakLine (list 2 #brkH$) (append (nth 1 #DoorPos$) '(0))))
      ;; 伸縮量を求める
      (cond ; 01/08/20 YM ADD ｳｫｰﾙとﾍﾞｰｽで場合分け
        ((= CG_BASE_UPPER nil) ; ﾍﾞｰｽのとき今までのﾛｼﾞｯｸ(ｼﾝﾎﾞﾙが上付き===>T,下つき=nil)
          ; ﾌﾛｱｷｬﾋﾞ
          (setq #iExpAmount (/ (- (nth 1 (nth 0 &Rect$)) (nth 1 (nth 0 #DoorPos$))) (length #brkH$)))
        )
        ((= CG_BASE_UPPER T) ; ｳｫｰﾙのとき追加のﾛｼﾞｯｸ(ｼﾝﾎﾞﾙが上付き===>T,下つき=nil)
          ; ｳｫｰﾙｷｬﾋﾞ
          (setq #iExpAmount (/ (- (nth 1 (nth 1 &Rect$)) (nth 1 (nth 1 #DoorPos$))) (length #brkH$)))
        )
      );_cond ; 01/08/20 YM ADD ｳｫｰﾙとﾍﾞｰｽで場合分け

	;2015/12/17 YM ADD-S 伸縮量0のときは伸縮しない
	(if (< 0.01 (abs #iExpAmount) )
		(progn

      (setq #iLoop 0)
      ;; H 方向ブレークラインを使用し、H 方向伸縮を行う
      ;; ブレークラインの本数分ループ
      (while (and (< #iLoop (length #brkH$)) (/= #DoorPos$ nil))
        (setq #nn (nth #iLoop #brkH$))
        (setq #Temp$ (entget #nn '("*")))
        (setq #BrkLine (trans (cdr (assoc 10 #Temp$)) 0 1))
        (setq #BrkLine (nth 1 #BrkLine))
        (cond ; 01/08/20 YM ADD ｳｫｰﾙとﾍﾞｰｽで場合分け
          ((= CG_BASE_UPPER nil) ; ﾍﾞｰｽのとき今までのﾛｼﾞｯｸ(ｼﾝﾎﾞﾙが上付き===>T,下つき=nil)
            (if (ssget "C"
                (nth 0 #DoorPos$)
                (list (nth 0 (nth 1 #DoorPos$)) #BrkLine)
                (list (cons 8 "SKD_TEMP_LAYER\*"));03/10/20 YM MOD
;;;               (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (nth 0 #DoorPos$)
                    (list (nth 0 (nth 1 #DoorPos$)) #BrkLine)
                    (list (cons 8 "SKD_TEMP_LAYER\*"));03/10/20 YM MOD
;;;                   (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@0," (rtos #iExpAmount))
                )
                ;; 扉面の領域を取得する
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
          ((= CG_BASE_UPPER T) ; ｳｫｰﾙのとき追加のﾛｼﾞｯｸ(ｼﾝﾎﾞﾙが上付き===>T,下つき=nil)
            (if (ssget "C"
                (list (nth 0 (nth 0 #DoorPos$)) #BrkLine)
                (nth 1 #DoorPos$)
                (list (cons 8 "SKD_TEMP_LAYER\*"))
;;;               (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (list (nth 0 (nth 0 #DoorPos$)) #BrkLine)
                    (nth 1 #DoorPos$)
                    (list (cons 8 "SKD_TEMP_LAYER\*"))
;;;                   (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@0," (rtos #iExpAmount))
                )
                ;; 扉面の領域を取得する
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
        );_cond ; 01/08/20 YM ADD ｳｫｰﾙとﾍﾞｰｽで場合分け
        (setq #iLoop (+ #iLoop 1))
      )

		)
	);_if
	;2015/12/17 YM ADD-E 伸縮量0のときは伸縮しない


    )
  );_if  H 方向


  ;; W 方向もしくは、D 方向のブレークラインの有無チェック--->W方向のみ01/09/25 YM
;;;01/09/25YM@DEL  (if (and (/= #DoorPos$ nil) (/= #brkE$ nil))
  (if (and (/= #DoorPos$ nil) (/= #brkW$ nil))
    (progn    ; ブレークラインがあった
      (setq #brkW$ (SKESortBreakLine (list 0 #brkW$) (nth 1 #DoorPos$)))
;;;01/09/25YM@DEL      (setq #brkE$ (SKESortBreakLine (list 0 #brkE$) (nth 1 #DoorPos$)))
      ;; 伸縮量を求める
      (setq #iExpAmount (/ (- (nth 0 (nth 0 &Rect$)) (nth 0 (nth 0 #DoorPos$))) (length #brkW$)))
;;;01/09/25YM@DEL      (setq #iExpAmount (/ (- (nth 0 (nth 0 &Rect$)) (nth 0 (nth 0 #DoorPos$))) (length #brkE$)))
      (if (= CG_TOKU "2") ; 背面処理中 01/05/21 YM ADD
        (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkW$)))
;;;01/09/25YM@DEL       (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkE$)))
      );_if

      (if (= CG_TOKU "4") ; 右側面処理中 01/09/25 YM ADD
        (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkW$)))
;;;01/09/25YM@DEL       (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkE$)))
      );_if

;;;00/05/11 DEL MH 背面処理部削除
;;; 00/04/27 MH ADD 180度回転図形への対応
;;;    (if (and (equal (car &ViewZ$) 0 0.01)
;;;             (equal (cadr &ViewZ$) 1 0.01)
;;;             (equal (caddr &ViewZ$) 0 0.01))
;;;      (setq #iExpAmount (- (/ (- (nth 0 (nth 0 #DoorPos$)) (nth 0 (nth 0 &Rect$)) )
;;;        (length #brkE$)))) ;背面
;;;      (setq #iExpAmount (/ (- (nth 0 (nth 0 &Rect$)) (nth 0 (nth 0 #DoorPos$)))
;;;        (length #brkE$))) ;背面でない
;;;    )
;;;   ;; 背面
;;; 00/04/27 MH ADD 180度回転図形への対応



	;2015/12/17 YM ADD-S 伸縮量0のときは伸縮しない
	(if (< 0.01 (abs #iExpAmount) )
		(progn



      ;; ブレークラインを使用し、伸縮を行う
      (setq #iLoop 0)

;;;  00/03/09 YM break line の assoc 10 のx座標が大きいもの順に並べ替え
      (setq #BrkLine$ '())
;;;01/09/25YM@DEL      (while (< #iLoop (length #brkE$))
;;;01/09/25YM@DEL        (setq #nn (nth #iLoop #brkE$))
      (while (< #iLoop (length #brkW$))
        (setq #nn (nth #iLoop #brkW$))
        (setq #Temp$ (entget #nn '("*")))
        (setq #BrkLine$ (append #BrkLine$ (list (trans (cdr (assoc 10 #Temp$)) 0 1))))  ;;;  00/03/09 YM
        (setq #iLoop (+ #iLoop 1))
      )

      (setq #BrkLine$ (reverse (CFListSort #BrkLine$ 0)))

      (setq #iLoop 0)
      ;; ブレークラインの本数分ループ
;;;      (while (and (< #iLoop (length #brkE$)) (/= #DoorPos$ nil))   ;;;  00/03/09 YM
;;;01/09/25YM@DEL      (while (and (< #iLoop (length #brkE$)) (/= #DoorPos$ nil))
      (while (and (< #iLoop (length #brkW$)) (/= #DoorPos$ nil))
;;;        (setq #nn (nth #iLoop #brkE$))  ;;;  00/03/09 YM
;;;        (setq #Temp$ (entget #nn '("*")))  ;;;  00/03/09 YM
;;;        (setq #BrkLine (trans (cdr (assoc 10 #Temp$)) 0 1))  ;;;  00/03/09 YM
        (setq #BrkLine (nth #iLoop #BrkLine$))  ;;;  00/03/09 YM

;;;01/09/25YM@DEL        (cond
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 1)    ; W方向ブレークライン
            (setq #BrkLine (nth 0 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 2)    ; D方向ブレークライン
;;;01/09/25YM@DEL            (setq #BrkLine (nth 0 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 3)    ; H方向ブレークライン
;;;01/09/25YM@DEL            (setq #BrkLine (nth 1 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL        );_cond

        ; 特殊処理
        (cond
          ; 01/09/25 YM ADD-S
          ((= CG_TOKU "4") ; 右側面処理中
            (if (ssget "C"
                  (list #BrkLine     (nth 1 (nth 0 #DoorPos$))) ; ﾌﾞﾚｰｸ位置の調整
;;;01/09/25YM@DEL (list (- #BrkLine) (nth 1 (nth 0 #DoorPos$))) ; ﾌﾞﾚｰｸ位置の調整 こちらが正しい???
                  (nth 1 #DoorPos$)
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (list #BrkLine (nth 1 (nth 0 #DoorPos$)))
                    (nth 1 #DoorPos$)
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; 扉面の領域を取得する
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
          ; 01/09/25 YM ADD-E
          ((= CG_TOKU "2") ; 背面処理中 01/05/21 YM ADD
            (if (ssget "C"
                  (list #BrkLine     (nth 1 (nth 0 #DoorPos$))) ; ﾌﾞﾚｰｸ位置の調整
;;;01/09/25YM@DEL (list (- #BrkLine) (nth 1 (nth 0 #DoorPos$))) ; ﾌﾞﾚｰｸ位置の調整 こちらが正しい???
                  (nth 1 #DoorPos$)
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (list #BrkLine (nth 1 (nth 0 #DoorPos$)))
                    (nth 1 #DoorPos$)
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; 扉面の領域を取得する
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
          ;以下通常処理
          (T
            (if (ssget "C"
                  (nth 0 #DoorPos$)
                  (list #BrkLine (nth 1 (nth 1 #DoorPos$)))
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (nth 0 #DoorPos$)                                                 ; 00/03/09 YM MOD
                    (list #BrkLine (nth 1 (nth 1 #DoorPos$)))
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; 扉面の領域を取得する
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
        );_cond

        (setq #iLoop (+ #iLoop 1))
      );while


		)
	);_if
	;2015/12/17 YM ADD-E 伸縮量0のときは伸縮しない




    )
  );_if W 方向



  ;; D 方向のブレークラインの有無チェック01/09/25 YM ADD-S /////////////////////////////////////
  (if (and (/= #DoorPos$ nil) (/= #brkD$ nil))
    (progn    ; ブレークラインがあった
      (setq #brkD$ (SKESortBreakLine (list 0 #brkD$) (nth 1 #DoorPos$)))
      ;; 伸縮量を求める
      (setq #iExpAmount (/ (- (nth 0 (nth 0 &Rect$)) (nth 0 (nth 0 #DoorPos$))) (length #brkD$)))
      (if (= CG_TOKU "2") ; 背面処理中 01/05/21 YM ADD
        (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkD$)))
      );_if

      (if (= CG_TOKU "4") ; 右側面処理中 01/09/25 YM ADD
;;;01/09/25YM@DEL       (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkD$)))
        (setq #iExpAmount (/ (- (nth 0 (nth 1 &Rect$)) (nth 0 (nth 1 #DoorPos$))) (length #brkD$)))
      );_if

      ;; ブレークラインを使用し、伸縮を行う
      (setq #iLoop 0)

;;;  00/03/09 YM break line の assoc 10 のx座標が大きいもの順に並べ替え
      (setq #BrkLine$ '())
      (while (< #iLoop (length #brkD$))
        (setq #nn (nth #iLoop #brkD$))
        (setq #Temp$ (entget #nn '("*")))
        (setq #BrkLine$ (append #BrkLine$ (list (trans (cdr (assoc 10 #Temp$)) 0 1))))  ;;;  00/03/09 YM
        (setq #iLoop (+ #iLoop 1))
      )

      (setq #BrkLine$ (reverse (CFListSort #BrkLine$ 0)))

      (setq #iLoop 0)
      ;; ブレークラインの本数分ループ
      (while (and (< #iLoop (length #brkD$)) (/= #DoorPos$ nil))
        (setq #BrkLine (nth #iLoop #BrkLine$))  ;;;  00/03/09 YM

;;;01/09/25YM@DEL        (cond
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 1)    ; W方向ブレークライン
;;;01/09/25YM@DEL            (setq #BrkLine (nth 0 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 2)    ; D方向ブレークライン
            (setq #BrkLine (nth 0 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL          ((= (nth 0 (CFGetXData #nn "G_BRK")) 3)    ; H方向ブレークライン
;;;01/09/25YM@DEL            (setq #BrkLine (nth 1 #BrkLine))
;;;01/09/25YM@DEL          )
;;;01/09/25YM@DEL        );_cond

        ; 特殊処理
        (cond
          ; 01/09/25 YM ADD-S
          ((= CG_TOKU "4") ; 右側面処理中
            (if (ssget "C"
                  (list #BrkLine (nth 1 (nth 0 #DoorPos$))) ; ﾌﾞﾚｰｸ位置の調整
                  (nth 1 #DoorPos$) ; ﾌﾞﾚｰｸ位置の調整
;;;                 (list (- (nth 0 (nth 0 #DoorPos$)) #iExpAmount) (nth 1 (nth 1 #DoorPos$))) ; ﾌﾞﾚｰｸ位置の調整
;;;01/09/25YM@DEL                 (nth 1 #DoorPos$)
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                  (list #BrkLine (nth 1 (nth 0 #DoorPos$))) ; ﾌﾞﾚｰｸ位置の調整
                    (nth 1 #DoorPos$)
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; 扉面の領域を取得する
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
          ; 01/09/25 YM ADD-E
          ((= CG_TOKU "2") ; 背面処理中 01/05/21 YM ADD
            (if (ssget "C"
                  (list #BrkLine     (nth 1 (nth 0 #DoorPos$))) ; ﾌﾞﾚｰｸ位置の調整
;;;01/09/25YM@DEL (list (- #BrkLine) (nth 1 (nth 0 #DoorPos$))) ; ﾌﾞﾚｰｸ位置の調整 こちらが正しい???

                  (nth 1 #DoorPos$)
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (list #BrkLine (nth 1 (nth 0 #DoorPos$)))
                    (nth 1 #DoorPos$)
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; 扉面の領域を取得する
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
          ;以下通常処理
          (T
            (if (ssget "C"
                  (nth 0 #DoorPos$)
                  (list #BrkLine (nth 1 (nth 1 #DoorPos$)))
                  (list (cons 8 SKD_TEMP_LAYER))
                )
              (progn
                (command "_stretch"
                  (ssget "C"
                    (nth 0 #DoorPos$)                                                 ; 00/03/09 YM MOD
                    (list #BrkLine (nth 1 (nth 1 #DoorPos$)))
                    (list (cons 8 SKD_TEMP_LAYER))
                  )
                  ""
                  (nth 0 #DoorPos$)
                  (strcat "@" (rtos #iExpAmount) ",0")
                )
                ;; 扉面の領域を取得する
                (setq #DoorPos$ (SKD_GetDoorPos &enGroup))
              )
            );_if
          )
        );_cond

        (setq #iLoop (+ #iLoop 1))
      );while
    )
  );_if D 方向
  ;; D 方向のブレークラインの有無チェック01/09/25 YM ADD-E /////////////////////////////////////



  (SetLayer) ; 表示画層の設定(元に戻す)
  (setvar "CLAYER" #clayer) ; 現在画層を戻す

;;;01/06/07YM@  ; 現在画層の変更
;;;01/06/07YM@  (SetLayer) ; 表示画層の設定(元に戻す)
;;;01/06/07YM@  (setvar "CLAYER" #clayer) ; 現在画層を戻す
  ;/////////////////////////////////////////////////////////////

  (command "_UCS" "P")    ;直前の状態に戻す ; 速度改善のためにUCSFOLLOWを0とし、VIEWがかわらないようにした。

  (setvar "OSMODE"     #os) ; 00/03/08 YM ADD
  (setvar "SNAPMODE"   #sm) ; 00/03/08 YM ADD
  (setvar "UCSFOLLOW"  #uf) ; 00/03/08 YM ADD
  (setvar "UCSVIEW"    #uv) ; 00/03/08 YM ADD
  (setvar "GRIDMODE"   #gr) ; 00/03/08 YM ADD
  (setvar "ORTHOMODE"  #ot) ; 00/03/08 YM ADD

  ;; 扉面領域を取得できたかどうかのチェック
  (if (/= #DoorPos$ nil)
    (progn    ; 取得できた
      (CFOutStateLog 1 4 "    SKD_FigureExpansion=End OK")
      T    ; return;
    )
    ;; else
    (progn    ; 扉面領域が取得できなかった
      (CFOutStateLog 0 4 "    SKD_FigureExpansion=End 扉面領域の取得ができませんでした。扉図形データが異常な可能性があります")
      nil    ; return;
    )
  )

);SKD_FigureExpansion

;<HOM>***********************************************************************
; <関数名>    : GetGruopMaxMinCoordinate
; <処理概要>  : "GROUP"中のLINE,POLYLINE範囲の最大最小を求める
; <戻り値>    : (list (list #MinX #MinY #MinZ) (list #MaxX #MaxY #MaxZ))
; <作成>      : 1998/07/30 -> 1998/07/31   松木 健太郎
; <備考>      : 扉図形の最大、最小座標を求める(ﾌﾞﾚｰｸﾗｲﾝ作成に用いる)
;***********************************************************************>HOM<
(defun GetGruopMaxMinCoordinate (
  &enGroup ; 伸縮を行うグループ"GROUP"
  &LeftUnderPT ; 扉左下点 MEJI左下
  /
  #10 #11 #DIS #EG$ #ET$ #FLG #PNT$ #RIGHTUPPT #TYPE #XYZ #Z #_PNT$
  )
;/////////////////////////////////////////////////////////////
; 2D-->3D
;/////////////////////////////////////////////////////////////
    (defun ##2Dto3D ( &xy / )
      (if (= (caddr &xy) nil)
        (list (car &xy)(cadr &xy) 0)
        &xy
      );_if
    )
;/////////////////////////////////////////////////////////////

  (setq #et$ (entget &enGroup))
  (setq #flg nil)
  (setq #PNT$ nil) ; 扉構成図形の端点座標ﾘｽﾄ
  (foreach #et #et$
    (if (= (car #et) 340)
      (progn
        (setq #eg$ (entget (cdr #et)))
        (setq #type (cdr (assoc 0 #eg$))) ; 図形ﾀｲﾌﾟ
        (cond
          ((= #type "LINE")
            (setq #10 (cdr (assoc 10 #eg$)))
            (setq #11 (cdr (assoc 11 #eg$)))
            (setq #10 (##2Dto3D #10))
            (setq #11 (##2Dto3D #11))
            (setq #PNT$ (append #PNT$ (list #10 #11)))
          )
          ((= #type "LWPOLYLINE")
            (setq #Z (cdr (assoc 38 #eg$)))
            (setq #_PNT$ nil)
            (foreach #eg #eg$ (if (= 10 (car #eg))(setq #_PNT$ (cons (cdr #eg) #_PNT$))))
            (foreach #P #_PNT$
              (setq #xyz (trans (append #P (list #Z)) (cdr #et) 1 0))
              (setq #PNT$ (append #PNT$ (list #xyz)))
            )
          )
        );_cond
      )
    );_if
  );foreach

  ;;; 扉右上点を求めるMEJI左下と一番離れている点
  (setq #dis -999)
  (foreach #PNT #PNT$ ; 扉を構成するLINE,POLYLINEの各端点
    (if (< #dis (distance #PNT &LeftUnderPT))
      (progn
        (setq #dis (distance #PNT &LeftUnderPT))
        (setq #RightUpPT #PNT)
      )
    );_if
  )
  (list &LeftUnderPT #RightUpPT)
);GetGruopMaxMinCoordinate

;<HOM>***********************************************************************
; <関数名>    : SKD_Expansion
; <処理概要>  : 扉図形を伸縮する(実際は SKD_FigureExpansion が伸縮処理を行う)
;                ここでは、領域の矩形座標の抽出だけ行う
; <戻り値>    : 成功： T　　　失敗：nil
; <作成>      : 1998/07/30 -> 1998/07/31   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKD_Expansion (
  &enGroup    ; 伸縮を行うグループのグループ名  "GROUP"
  &eMEJI$     ; 扉面領域のデータリスト "G_MEJI"
  /
  #Rect$      ; 矩形座標格納用
  #MaxX       ; X 最大座標値
  #MaxY       ; Y 最大座標値
  #MinX       ; X 最小座標値
  #MinY       ; Y 最小座標値

  #Temp$      ; テンポラリリスト
  #nn         ; foreach 用
  #View$ #view
  #Sp$ #Ep$
  #lay
  )
  (CFOutStateLog 1 4 "    SKD_Expansion=Start")

  ;; 矩形座標格納変数の初期化
  (setq #Rect$ nil)
  (setq #Sp$ nil)
  (setq #Ep$ nil)
  ;; 00/11/13 MH 多角形の領域があるので、条件変更
  ;; 扉面領域の座標数が4以上であるかどうかのチェック
  (if (>= (cdr (assoc 90 &eMEJI$)) 4)
  ;; 扉面領域の座標数が4であるかどうかのチェック
  ;(if (= (cdr (assoc 90 &eMEJI$)) 4)
    (progn    ; 頂点数が4以上だった
      ;; データ要素数分ループ
      (foreach #nn &eMEJI$
        ;; リストのデータが座標値であるかどうかチェック
        (if (= (car #nn) 10)
          (progn    ; 座標値だった
            (setq #Temp$ (cdr #nn))
            ;; デフォルトの値で初期化
            (if (= #MaxX nil)
              (progn
                ;; 初期値入力
                (setq #MaxX (nth 0 #Temp$))
                (setq #MaxY (nth 1 #Temp$))
                (setq #MinX (nth 0 #Temp$))
                (setq #MinY (nth 1 #Temp$))
              )
            )
            ;; 最大 X 値チェック
            (if (< #MaxX (nth 0 #Temp$))
              (progn
                (setq #MaxX (nth 0 #Temp$))
              )
            )
            ;; 最大 Y 値チェック
            (if (< #MaxY (nth 1 #Temp$))
              (progn
                (setq #MaxY (nth 1 #Temp$))
              )
            )
            ;; 最小 X 値チェック
            (if (> #MinX (nth 0 #Temp$))
              (progn
                (setq #MinX (nth 0 #Temp$))
              )
            )
            ;; 最小 Y 値チェック
            (if (> #MinY (nth 1 #Temp$))
              (progn
                (setq #MinY (nth 1 #Temp$))
              )
            )
          )
        )
      )
      ;; 座標をリストに格納する
      (setq #lay (cdr (assoc 8 &eMEJI$)))
      (setq #View$ (cdr (assoc 210 &eMEJI$)))

;;;00/05/11DEL 背面特殊処理部削除
;;;00/05/11DEL      (if (and (equal (car #View$) 0 0.01) (equal (cadr #View$) 1 0.01) (equal (caddr #View$) 0 0.01))
;;;00/05/11DEL        (progn
;;;00/05/11DEL          (setq #Rect$ (list (list #MinX #MaxY) (list #MaxX #MinY))) ;背面の時
;;;00/05/11DEL        )
;;;00/05/11DEL        (progn

          (setq #Rect$ (list (list #MaxX #MaxY) (list #MinX #MinY))) ;背面でない

;;;00/05/11DEL        )
;;;00/05/11DEL      )
      ;; 伸縮処理を行う
      (if (/= (SKD_FigureExpansion &enGroup #Rect$ #View$) nil)
        (progn
          (CFOutStateLog 1 4 "    SKD_Expansion=End OK")
          T    ;return;
        )
        ;; else
        (progn
          (CFOutStateLog 0 4 "    SKD_Expansion=End 伸縮処理が正常に行われませんでした")
          nil    ; return;
        )
      )
    )
    ;; else
    (progn    ; 頂点数が以下だった
      (CFOutStateLog 0 4 "    SKD_Expansion=End 扉面領域の頂点数が異常(4以下)です")
      nil    ; return;
    )
  )
);SKD_Expansion

;<HOM>***********************************************************************
; <関数名>    : SKD_DeleteInsertLayer
; <処理概要>  : インサートされた扉図形の画層を全て削除する
; <戻り値>    : 成功： T　　　失敗：nil
; <作成>      : 1998/08/03 -> 1998/08/03   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKD_DeleteInsertLayer (
    /
    #iLoop      ; ループ用
  )
  (setq #iLoop 0)
  (while (< #iLoop 5)
    (command "_purge" "B" "*" "N")
    (setq #iLoop (+ #iLoop 1))
  )
  (command "_purge" "LA" "Q_*" "N")
)
;SKD_DeleteInsertLayer

;<HOM>***********************************************************************
; <関数名>    : SCD_DeleteHatch
; <処理概要>  : ハッチ図形を消す
; <戻り値>    : 成功： T      失敗：nil
; <作成>      : 1998/08/04 -> 1998/08/04   松木 健太郎
; <備考>      :
;***********************************************************************>HOM<
(defun SKD_DeleteHatch (
    &enName    ; 扉面領域の図形名
    /
    #Data$      ; データリスト格納用
    #nn         ; foreach 用
    #lay
  )
  (if (/= (CFGetXData &enName "G_MEJI") nil)
    (progn
      (setq #Data$ (entget &enName))
      (foreach #nn #Data$
        (if (= (car #nn) 330)
          (progn
            ;(if (= (cdr (assoc 0 (entget (cdr #nn)))) "HATCH")
            (setq #lay (cdr (assoc 8 (entget (cdr #nn)))))
            (if (and
                 (/= #lay nil)
                 (= nil (CFGetXData (cdr #nn) "G_MEJI"))
                 (wcmatch #lay "M_*")
                )
              (progn
                (entdel (cdr #nn))
              )
            )
          )
        )
      )
    )
  )
  T    ; return;
)
;SKD_DeleteHatch

;<HOM>***********************************************************************
; <関数名>    : SKD_EraseDoor
; <処理概要>  : 既に存在する扉面を削除する
; <戻り値>    : なし
; <作成>      : 1999-06-15
; <備考>      : なし
;***********************************************************************>HOM<
(defun SKD_EraseDoor (
    &en       ;(ENAME)扉面を削除するシンボル図形名
    &SetFace  ;(INT)  削除する面の種類(2:2D-Ｐ面 3:3D目地領域)
    /
    #eg$ #eg #eg2 #eg2$ #delFlg #300 #330 #340 #i #j #lay #loop
  )
  ;// シンボル基準図形をロック
  (command "_.layer" "lo" "N_SYMBOL" "")
  (setvar "PICKSTYLE" 1)
  (setq #eg$ (entget &en '("*")))

  (setq #i 0)
  (foreach #eg #eg$
    ;// グループ関連の図形の時に処理を行う
    (if (= (car #eg) 330)
      (progn
        (setq #eg2$ (entget (cdr #eg)))
        (setq #300 (cdr (assoc 300 #eg2$)))      ;グループ定義名称
        (setq #330 (cdr (assoc 330 #eg2$)))
        (setq #340 (cdr (assoc 340 #eg2$)))

        (if (= #300 "DoorGroup")
          ;// グループ定義名称が"DoorGroup" の場合
          (progn
            (setq #loop T)
            (setq #j 0)
            (setq #delFlg nil)

            (while (and #loop (< #j (length #eg2$)))
              (setq #eg2 (nth #j #eg2$))
              (if (= (car #eg2) 340)
                (progn
                  ;// 画層を取得する
                  (setq #lay (cdr (assoc 8 (entget (cdr #eg2)))))
                  (cond
                    ;// ３Ｄ扉面の場合は、画層Ｍ＿＊ 、Ｚ＿＊を削除対象とする
                    ((= &SetFace 3)
                      (if (and #lay (= nil (wcmatch #lay "N_*")))
                        (progn
                          (entdel (cdr #eg2))
                          (setq #delFlg T)
                        )
                      )
                    )
                    ;// ２Ｄ扉面の場合は、画層Ｚ＿＊を削除対象とする
                    ((= &SetFace 2)
                      (if (and #lay (wcmatch #lay "Z_*"))
                        (progn
                          (entdel (cdr #eg2))
                          (setq #delFlg T)
                        )
                      )
                    )
                  )
                )
              )
              (setq #j (1+ #j))
            )
            ;// グループ定義図形名を削除する
            (if (= #delFlg T)
              (entdel (cdr (car #eg2$)))
            )
          )
        ;else
          ;// グループ定義名になにも入っていない場合
          (progn
            (setq #lay (cdr (assoc 8 (entget #340))))
            (if (and
                     #lay
                     (/= (strcase #lay) "N_SYMBOL")
                     (= (wcmatch #lay "Y_*") nil)
                )
              (progn
                (cond
                  ;// ３Ｄ扉面の場合は、画層Ｍ＿＊ 、Ｚ＿＊を削除対象とする
                  ((and (= &SetFace 3) (= nil (wcmatch #lay "Z_*")))
                    (command "_.ERASE" #340 "")  ;グループモードで削除 PICKAUTO=1
                  )
                  ;// ２Ｄ扉面の場合は、画層Ｚ＿＊を削除対象とする
                  ;((and (= &SetFace 2) (wcmatch #lay "Z_*"))
                  ;  (command "_.ERASE" #340 "")  ;グループモードで削除 PICKAUTO=1
                  ;)
                )
              )
            )
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
  (setvar "PICKSTYLE" 0)
  (command "_.layer" "u" "N_SYMBOL" "")
)
;SKD_EraseDoor

;<HOM>***********************************************************************
; <関数名>    : PKD_EraseDoor
; <処理概要>  : 既に存在する扉面を削除する
; <戻り値>    :
; <作成>      :
; <備考>      :
;***********************************************************************>HOM<
(defun PKD_EraseDoor (
    &en
    /
    #eg$ #eg #eg2 #300 #330 #340 #i #lay
  )
  ;// シンボル基準図形をロック
  (command "_layer" "lo" "N_SYMBOL" "") ; LOﾛｯｸ
  (setvar "PICKSTYLE" 1)
  (setq #eg$ (entget &en '("*")))
  (setq #i 0)
  (foreach #eg #eg$
    (if (= (car #eg) 330)
      (progn
        (setq #eg2 (entget (cdr #eg)))
        (setq #300 (cdr (assoc 300 #eg2))) ; グループの説明
;;;        (setq #330 (cdr (assoc 330 #eg2))) ; 未使用 YM 00/02/29
        (setq #340 (cdr (assoc 340 #eg2)))
        (if (= #300 SKD_GROUP_INFO) ; グループの説明
          (progn
            (command "_erase" #340 "")
            (entdel (cdr (car #eg2)))
          )
          ;03/05/09 YM DEL-S
;;;         (progn
;;;           (setq #lay (cdr (assoc 8 (entget #340)))) ; 画層を調べる
;;;         )
          ;#300=""で#340がたまたま"M_*"だったらﾊﾟｰｽが消えてしまう
          ;#300=""のときの処理は必要ないのではないか?-->普段通らない-->ｺﾒﾝﾄする
;;;03/05/09YM@DEL          (progn
;;;03/05/09YM@DEL            (setq #lay (cdr (assoc 8 (entget #340))))
;;;03/05/09YM@DEL;;;;編集  ;00/02/14 MH MOD
;;;03/05/09YM@DEL            (if (and (= 'STR (type #lay)) (/= #lay "N_SYMBOL") (= nil (wcmatch #lay "Z_*")))
;;;03/05/09YM@DEL;;;            (if (and (/= #lay "N_SYMBOL") (= nil (wcmatch #lay "Z_*")))
;;;03/05/09YM@DEL            ;(if (= nil (wcmatch (cdr (assoc 8 (entget #340))) "N_*"))
;;;03/05/09YM@DEL              (progn
;;;03/05/09YM@DEL                (command "_erase" #340 "")
;;;03/05/09YM@DEL              )
;;;03/05/09YM@DEL            )
;;;03/05/09YM@DEL          )
          ;03/05/09 YM DEL-E

;一時的に復活 03/06/10 YM
          (progn
            (setq #lay (cdr (assoc 8 (entget #340))))
;;;;編集  ;00/02/14 MH MOD
;;;;編集  ;04/04/12 SK MOD グループ内の"Y_*" 図形も考慮するよう変更
            ; 06/09/12 このルートはいらないはず。
            ; 必要な図形を消してしまう。
;            (if (and (= 'STR (type #lay)) (/= #lay "N_SYMBOL") (= nil (wcmatch #lay "Z_*"))(= nil (wcmatch #lay "Y_*")))  ; 06/09/12 T.Ari Mod
             (if nil
;;;            (if (and (= 'STR (type #lay)) (/= #lay "N_SYMBOL") (= nil (wcmatch #lay "Z_*")))
;;;            (if (and (/= #lay "N_SYMBOL") (= nil (wcmatch #lay "Z_*")))
            ;(if (= nil (wcmatch (cdr (assoc 8 (entget #340))) "N_*"))
              (progn
                (command "_erase" #340 "")
              )
            )
          )
        )
      )
    )
    (setq #i (1+ #i))
  )
  (setvar "PICKSTYLE" 0)
  (command "_layer" "u" "N_SYMBOL" "")
)
;PKD_EraseDoor

;<HOM>***********************************************************************
; <関数名>    : KP_GetAllDoor
; <処理概要>  : 図面上の全扉図形の選択ｾｯﾄを返す
; <戻り値>    : 選択ｾｯﾄ
; <作成>      : 03/05/13 YM
; <備考>      : 【ﾌﾟﾗﾝ保存】時に扉を削除してから保存する
;***********************************************************************>HOM<
(defun KP_GetAllDoor (
  /
  #300 #EG$ #EG2$ #I #SS #SSDOOR #SYM #340 #LAY
  )
  (setq #ssDOOR (ssadd))
  (setq #ss (ssget "X" '((-3 ("G_SYM"))))) ; G_LSYM 図形選択ｾｯﾄ
  (if (and #ss (< 0 (sslength #ss)))
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #sym (ssname #ss #i))
        (setq #eg$ (entget #sym '("*")))
        (foreach #eg #eg$
          (if (= (car #eg) 330)
            (progn
              (setq #eg2$ (entget (cdr #eg)))
              (setq #300 (cdr (assoc 300 #eg2$))) ; グループの説明
              (if (= #300 SKD_GROUP_INFO)
                (foreach #eg2 #eg2$
                  (if (= (car #eg2) 340)
                    (progn
                      ;画層"N_SYMBOL"を除く
                      (setq #340 (cdr #eg2))
                      (setq #lay (cdr (assoc 8 (entget #340))))
                      (if (/= #lay "N_SYMBOL")
                        (ssadd (cdr #eg2) #ssDOOR)
                      );_if
                    )
                  );_if
                )
              );_if
            )
          );_if
        );foreach
        (setq #i (1+ #i))
      );repeat
    )
  );_if
  #ssDOOR ; 扉図形選択ｾｯﾄ
);KP_GetAllDoor

;<HOM>*************************************************************************
; <関数名>    : SKD_ChgSeriesDlg
; <処理概要>  : 扉SERIES変更ダイアログ
; <戻り値>    :
; <作成>      : 1999-10-21
; <備考>      :
;*************************************************************************>MOH<
(defun SKD_ChgSeriesDlg (
    &SeriCode        ;(STR)SERIES記号
    &BrandCode       ;(STR)ブランド記号
    &DrCode          ;(STR)扉SERIES記号
    &DrColCode       ;(STR)扉COLOR記号
    /
    #dcl_id
    #lst
    #no
    ##GetDlgItem
    ##SelectSeries
    #ret$
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##GetDlgItem ( / #lst )
    ;// 径入力チェック
    (setq #lst
      (list
        (get_tile "seri")
        (get_tile "col")
      )
    )
    (done_dialog)
    #lst
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##SelectSeries ( / #lst )
    (start_list "col" 3)
    (foreach #lst &hole-qry$$
      (add_list (strcat (itoa (fix (nth 1 #lst))) "：" (nth 2 #lst)))
    )
    (end_list)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// 戻り値の初期設定
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "PosSinkDlg" #dcl_id)) (exit))

  (start_list "sink" 3)
  (foreach #lst &snk-qry$$
    (add_list (strcat (nth 1 #lst) "：" (nth 2 #lst)))
  )
  (end_list)

  ;// ﾀｲﾙのﾘｱｸｼｮﾝ設定
  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
  (action_tile "seri"    "(##SelectSeries)")
  (action_tile "cancel" "(setq #ret$ nil)(done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
  ;// シンク、水栓穴、水栓種類の選択番号及び穴径、予備穴径を返す
  #ret$
)
;SKD_ChgSeriesDlg

;<HOM>***********************************************************************
; <関数名>    : SetLayer
; <処理概要>  : 表示画層の設定を行う
; <戻り値>    : なし
; <作成>      : 01/06/07 YM
; <備考>      :
;***********************************************************************>HOM<
(defun SetLayer ( / )
  ;// 表示画層の設定
  (command "_layer"
    "F"   "*"                ;全ての画層をフリーズ
    "T"   "Z_00*"            ;  Z_00立体ソリッド画層のフリーズ解除
    "T"   "N_*"              ;  N_*シンボル原点図形画層のフリーズ解除
    "T"   "M_*"              ;  M_*目地領域図形画層の解除
    "T"   "0"                ;  "0"画層の解除
    "ON"  "M_*"              ;  M_*目地領域図形画層の表示
    "OFF" "N_B*" ""          ;  N_B*ブレークライン図形の非表示
  )
  (command "_.layer" "T" "Z_KUTAI" "") ; 01/02/20 YM ADD
  (command "_.layer" "T" "0_*" "")     ; 01/06/11 YM ADD

  (command "_.layer" "T" DOOR_OPEN    "") ; 03/09/29 YM ADD
  (command "_.layer" "T" DOOR_OPEN_04 "") ; 03/10/17 YM ADD
  (command "_.layer" "T" DOOR_OPEN_06 "") ; 03/10/17 YM ADD

;;;01/07/16YM@  (command "_.layer" "T" "0_door" "")  ; 01/06/11 YM ADD
  (princ)
);SetLayer

(princ)