

(setq CG_R "100")       ; 01/07/09 YM R���ނ̌a��̫�Ēl
(setq CG_SELECT_WID 50) ; �Ԍ��L�k�ő��I�����镝
(setq CG_LenDircut 50)  ; ������Đ؂荞�ݕ�

;;;�֐������p
;;;(defun C:SetWkTop ܰ�į�߂̕i�Ԃ��m�肷�� KcwktopZ2_M(N)�Ɉړ�
;;;(defun PKGetSinaCode ���[�N�g�b�v�̕i�R�[�h��Ԃ�

; �����@�����߂�
;;;(defun PKGetANAdim-I2 ���[�N�g�b�v���������߂�(I�`��ܰ�į�ߐ�p)�ݸ,��ە����Ή�

;;;(defun PKGetANAdim-U2 ���[�N�g�b�v���������߂�(U�^��p)�ݸ,��ە����Ή�
;;;(defun PKGetDimSeries2 ���@�����Ԃ�(�����@�̐���)
;;;(defun KPW_GetWorkTopInfoDlg ���[�N�g�b�v�̕i�Ԏ擾�_�C�A���O
;;;(defun PKW_MakeHoleWorkTop2 �V���N���A�R�������A�������Ɍ����J����
;;;(defun PKY_ShowWTSET_Dlog ���[�N�g�b�v���\���_�C�A���O
;;;(defun PKW_SQLResultCheck �`�F�b�N�����֐�
;;;(defun PKW_GetWorkTopAreaSym3 �w�胏�[�N�g�b�v�̈���̃V���N�A�����A�K�X�R�������擾����
;;;(defun PKMultiSnkGas �ݸ�A��ۂ̐����R�ȏ゠�邩�ǂ�����������

; �Ԍ��L�k
;;;(defun C:StretchWkTop ���[�N�g�b�v�Ԍ��L�k
;;;(defun PKSTRETCH_TEI ��ʐ}�`��L�k
;;;(defun PK_PtSTRETCHsub BG,FG��ʊO�`�_���L�k
;;;(defun SubStretchWkTop ���[�N�g�b�v�Ԍ��L�k

; �ގ��ύX
;;;(defun C:ChZaiWKTop �ގ��ύX�����
;;;(defun PKW_ZaiDlg �ގ��ύX�_�C�A���O�\��

;;;(defun KP_Std_DimCHeckD �W��WT���ǂ����̐��@����( �i���p)
;;;(defun KP_Std_DimCHeckI �W��WT���ǂ����̐��@����( I�^�p)
;;;(defun KP_Std_DimCHeckL �W��WT���ǂ����̐��@����(���ڽL�^�p)
;;;(defun KP_Std_DimCHeck_RLS �W��WT���ǂ����̐��@����( �l��L�^�ݸ���p)
;;;(defun KP_Std_DimCHeck_RLG �W��WT���ǂ����̐��@����( �l��L�^��ۑ��p)

(setq CG_TCUT 1) ; J���ݒi���ڑ���WT������ 01/07/10 YM ADD

;;;�֐������p
;;;(defun KPW_DesideWorkTop3 ���[�N�g�b�v�̕i�Ԋm��
;;;(defun KPW_GetWorkTopID2 ���[�N�g�b�v�̕i�Ԏ擾


;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_CT_EXIST
;;; <�����T�v>  : ���ʶ�����̕i�Ԋm�����ނ̎g�p�ۂ𔻒�
;;; <�߂�l>    : T or nil
;;; <�쐬>      : 01/08/31 YM
;;; <���l>      : CT��{���iTable�����݂��邩�ǂ���
;;;*************************************************************************>MOH<
(defun KP_CT_EXIST (
  /
  #QRY_COL$$ #QRY_ZAI$$
  )
  ; CT�ގ�
  (setq #Qry_zai$$
    (DBSqlAutoQuery CG_DBSESSION
      (strcat "select * from CT�ގ�")
    )
  )
  ; �{�E��COLOR
  (setq #Qry_col$$
    (DBSqlAutoQuery CG_DBSESSION
      (strcat "select * from �{�E��COLOR" )
    )
  )
  (if (and #Qry_zai$$ #Qry_col$$)
    T
    nil
  );_if
);KP_CT_EXIST

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KP_SetCounter
;;; <�����T�v>  : ���ʶ�����̕i�Ԃ��m�肷��
;;; <�߂�l>    :
;;; <�쐬>      : 01/08/27 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KP_SetCounter (
  /
  #ECOUNTER #LOOP #SKK$
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KP_SetCounter ////")
  (CFOutStateLog 1 1 " ")
  ;// �R�}���h�̏�����
  (StartUndoErr)
  (CFCmdDefBegin 0)
  (CFNoSnapReset)

  (if (= nil (KP_CT_EXIST)) ; CT��i�����݂���
;;;01/08/31YM@MOD (if (and (/= CG_SeriesCode "F")(/= CG_SeriesCode "V"))
    (progn ; �Z�i�ł��r�j�ł��Ȃ�������
      (CFAlertMsg msg8)
      (quit)
    )
    (progn

      ;// �V���N�L���r�l�b�g���w��������
      (setq #loop T)
      (while #loop
        (setq #eCOUNTER (car (entsel "\n�J�E���^�[�g�b�v��I��: ")))
        (if #eCOUNTER
          (progn
            (setq #eCOUNTER (CFSearchGroupSym #eCOUNTER)) ; �ݸ����ِ}�`��
            (if #eCOUNTER
              (progn
                ;// ���������L���r�l�b�g�̐��iCODE���擾����
                (setq #skk$ (CFGetSymSKKCode #eCOUNTER nil))
                (if (and (equal (car   #skk$) CG_SKK_ONE_CNT 0.01) ; ����� =7 ; 01/08/29 YM MOD
                         (equal (cadr  #skk$) CG_SKK_TWO_BAS 0.01) ; �ް�  =1 ; 01/08/29 YM MOD
                         (equal (caddr #skk$) CG_SKK_THR_ETC 0.01)); ���̑�=0 ; 01/08/29 YM MOD
                  (setq #loop nil) ; ���ʶ����������  ; 01/08/29 YM MOD PMEN4�̗L�������Ȃ�
                  (CFAlertMsg "�J�E���^�[�g�b�v�ł͂���܂���")
                );_if
              )
              (CFAlertMsg "�J�E���^�[�g�b�v�ł͂���܂���")
            );_if
          )
          (CFAlertMsg "�J�E���^�[�g�b�v�ł͂���܂���")
        );_if
      );_while

      (GroupInSolidChgCol2 #eCOUNTER CG_InfoSymCol) ; �F��ς���
      (KP_DesideCTTop #eCOUNTER); ���ʶ�����̕i�Ԃ��m��&�m�F&"G_TOKU"���
      (GroupInSolidChgCol2 #eCOUNTER "BYLAYER")     ; �F��ς���
      (princ "\n�J�E���^�[�g�b�v�̕i�Ԃ��m�肵�܂����B")
    )
  );_if

  (CFNoSnapFinish)
  (CFCmdDefFinish)
  (setq *error* nil)
  (princ)
);C:KP_SetCounter

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_DesideCTTop
;;; <�����T�v>  : ���ʶ�����̕i�Ԃ��m��&�m�F&"G_TOKU"���
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/08/28 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_DesideCTTop (
  &eCOUNTER ; ���������ِ}�`
  /
  #ECOUNTER #LR #PMEN2 #RET$ #RPRICE #SHINBAN #SORG_HIN #SPRICE #XD_LSYM$
  )
  (setq #eCOUNTER &eCOUNTER)
  ; ������̕i�Ԗ���
  (setq #xd_LSYM$ (CFGetXData #eCOUNTER "G_LSYM"))
  (setq #sOrg_Hin (nth 5 #xd_LSYM$)) ; �i��
  (setq #LR       (nth 6 #xd_LSYM$)) ; LR
  (setq #pmen2 (PKGetPMEN_NO #eCOUNTER 2)) ; PMEN2 ���������p
  (if (= nil #pmen2)
    (progn
      nil ; 01/09/04 YM ADD
;;;     (CFAlertMsg "�����į�߂ɊO�`�̈�(P��2)������܂���B")
;;;01/09/04YM@DEL     (quit)
    )
  );_if

  ; ������i�Ԋm�菈��
  (setq #ret$ (KP_DesideCTTop_sub #eCOUNTER #sOrg_Hin #LR #pmen2)) ; ���������ِ}�`,���i��,LR,PMEN2
  (if (= #ret$ nil)
    (quit)
    (progn
      (setq #sHinban (car  #ret$))
      (setq #rPrice  (cadr #ret$))
    )
  );_if

  ; �m�F�޲�۸�
  (setq #sPrice (itoa (fix (+ 0.001 #rPrice))))
  (setq #ret$ (ShowCT_Dlog #sHinban #sPrice))
  (if (= #ret$ nil)
    (quit)
    (progn
      (setq #sHinban (car  #ret$))
      (setq #rPrice  (cadr #ret$))
    )
  );_if

  ; Xdata "G_TOKU" ��Ă���
  (if (= (tblsearch "APPID" "G_TOKU") nil) (regapp "G_TOKU"))
  (CFSetXData #eCOUNTER "G_TOKU"
    (list
      #sHinban     ; ������i��
      #rPrice      ; ���i
      (list 0 0 0) ; ��а
      2 ; 1:�������޺���� 0:��АL�k 2:���ʶ����
      0 ; W ��ڰ�ײ݈ʒu(��а)
      0 ; D ��ڰ�ײ݈ʒu(��а)
      0 ; H ��ڰ�ײ݈ʒu(��а)
      #sOrg_Hin    ; �i��
    )
  )
  (princ)
);KP_DesideCTTop

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_DesideCTTop_sub
;;; <�����T�v>  : ���ʶ�����̕i�Ԃ��m�肷��
;;; <�߂�l>    : (�i��,���i)
;;; <�쐬>      : 01/08/27 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_DesideCTTop_sub (
  &eCOUNTER ; ���������ِ}�`
  &sOrg_Hin ; ���̕i�Ԗ���
  &LR       ; LR�敪
  &pmen2    ; �O�`�̈�(���������p)
  /
  #510$ #PT$ #QRY_PRICE$$ #QRY_SUI$$ #QRY_TYPE$$ #RET$ #RPRICE #SCOL #SSUI$ #SSUI$$
  #SSUI_HIN #SSUI_KIGO #STYPE #SZAI #LR #SHINBAN
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KP_DesideCTTop_sub ////")
  (CFOutStateLog 1 1 " ")
  ; �޲�۸ނ̕\��
  (setq #ret$ (KP_CTZaiDlg &sOrg_Hin &LR))
  (if (= #ret$ nil)
    (quit)
    (progn
      (setq #sZAI (car  #ret$)) ; ������ގ�
      (setq #sCOL (cadr #ret$)) ; �޳ٶװ
    )
  );_if

  ; ���i�����߂���������
  (setq #qry_type$$
    (CFGetDBSQLRec CG_DBSESSION "CT�^�C�v"
      (list
        (list "�ގ��L��"       #sZAI 'STR)
        (list "�{�E���J���L��" #sCOL 'STR)
      )
    )
  )
  (if (and #qry_type$$ (= 1 (length #qry_type$$)))
    (setq #sType (itoa (fix (+ 0.001 (nth 2 (car #qry_type$$)))))); ���i����HIT(������)
    (setq #sType "-999")                                ; ���i����
  );_if

  ; �����̌���
  (if (= &pmen2 nil) ; 01/09/04 YM ADD &pmen2=nil�̂Ƃ������s
    (setq #510$ nil) ; 01/09/04 YM ADD &pmen2=nil�̂Ƃ������s
    (progn ; PMEN2������Ƃ�
      (setq #pt$ (GetLWPolyLinePt &pmen2))  ; �ݸ����PMEN2 �O�`�̈�
      (setq #pt$ (AddPtList #pt$))          ; �����Ɏn�_��ǉ�����
      (command "vpoint" "0,0,1") ; ���_��^�ォ��
      (setq #510$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; �̈������ ; 01/08/31 YM MOD 510-->��۰��ى�
      (command "zoom" "p") ; ���_��߂�
    )
  );_if

  (setq #sSUI$$ nil)
  (foreach #510 #510$
    (setq #sSUI_Hin (nth 5 (CFGetXData #510 "G_LSYM"))); �����̕i��
    (setq #qry_sui$$
      (CFGetDBSQLRec CG_DBSESSION "CT����"
        (list (list "�i�Ԗ���" #sSUI_Hin 'STR))
      )
    )
    (if (and #qry_sui$$ (= 1 (length #qry_sui$$)))
      (setq #sSUI$ (list (nth 0 (car #qry_sui$$))(nth 1 (car #qry_sui$$)))) ; ID,�����L��
      (setq #sSUI$ (list 0 "?"))                                            ; ID,�����L��
    );_if
    (setq #sSUI$$ (append #sSUI$$ (list #sSUI$)))
  );foreach

  (setq #sSUI$$ (CFListSort #sSUI$$ 0)) ; nth 0 (ID)�����������̏��ɿ��
  ; CT��i�����p�̐����L��
  (setq #sSUI_KIGO "")
  (foreach #sSUI$ #sSUI$$
    (setq #sSUI_KIGO (strcat #sSUI_KIGO (nth 1 #sSUI$)))
  )

  ; ��������i��������
  (setq #qry_price$$
    (CFGetDBSQLRec CG_DBSESSION "CT��i"
      (list
        (list "�i�Ԋ�{��" &sOrg_Hin  'STR)
        (list "�����L��"   #sSUI_KIGO 'STR)
        (list "���i�^�C�v" #sType     'INT)
      )
    )
  )
  (if (and #qry_price$$ (= 1 (length #qry_price$$)))
    (setq #rPrice (nth 4 (car #qry_price$$))) ; ��������i
    (setq #rPrice 0)                          ; ��������i
  );_if

  ; ������i�ԍ쐬
  (if (= &LR "Z")
    (setq #LR "")
    (setq #LR &LR)
  );_if

  (if (= #sSUI_KIGO "")
    (setq #sSUI_KIGO "?")
  );_if

  (setq #sHinban (strcat &sOrg_Hin #LR #sSUI_KIGO #sZAI #sCOL))

  (list #sHinban #rPrice)
);KP_DesideCTTop_sub

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_CTZaiDlg
;;; <�����T�v>  : ������ގ�,�޳ٶװ�I���޲�۸�
;;; <�߂�l>    : (������ގ�,�޳ٶװ)
;;; <�쐬>      : 01/08/28 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_CTZaiDlg (
  &sOrg_Hin ; ���̕i�Ԗ���
  &LR       ; LR�敪
  /
  #DCL_ID #POP_COL$ #POP_ZAI$ #QRY_COL$$ #QRY_ZAI$$ #RET$ #dum$$
  #HINBAN
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KP_CTZaiDlg ////")
  (CFOutStateLog 1 1 " ")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem (
            /
            #zai #col
            )
            (setq #zai (nth (atoi (get_tile "zai")) #pop_zai$)) ; ������ގ��L��
            (setq #col (nth (atoi (get_tile "col")) #pop_col$)) ; �޳ٶװ�L��
            (done_dialog)
            (list #zai #col)
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �߯�߱���ؽ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##Addpop ( / ) ; �ގ��|�b�v�A�b�v���X�g
            ; ������ގ�
            (setq #pop_zai$ '())
            (start_list "zai" 3)
            (foreach #Qry_zai$ #Qry_zai$$
              (add_list (strcat (nth 2 #Qry_zai$) "         " (nth 3 #Qry_zai$)))
              (setq #pop_zai$ (append #pop_zai$ (list (nth 2 #Qry_zai$)))) ; �ގ��L���̂ݕۑ�
            )
            (end_list)
            (set_tile "zai" "0") ; �ŏ���̫���

            ; �޳ٶװ
            (setq #pop_col$ '())
            (start_list "col" 3)
            (foreach #Qry_col$ #Qry_col$$
              (add_list (strcat (nth 1 #Qry_col$) "         " (nth 2 #Qry_col$)))
              (setq #pop_col$ (append #pop_col$ (list (nth 1 #Qry_col$)))) ; �ގ��L���̂ݕۑ�
            )
            (end_list)
            (set_tile "col" "0") ; �ŏ���̫���

            (princ)
          );##Addpop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ; �ގ��L���̑I��
  (setq #Qry_zai$$
    (DBSqlAutoQuery CG_DBSESSION
      (strcat "select * from CT�ގ�")
    )
  )
  (setq #Qry_zai$$ (CFListSort #Qry_zai$$ 0)) ; nth 0 (ID)�����������̏��ɿ��

  ; �p��F��1�łȂ�����
  (setq #dum$$ nil)
  (foreach #Qry$ #Qry_zai$$
    (if (/= 1 (nth 6 #Qry$))
      (setq #dum$$ (append #dum$$ (list #Qry$)))
    );_if
  )
  (setq #Qry_zai$$ #dum$$)

  ; �{�E��COLOR�̑I��
  (setq #Qry_col$$
    (DBSqlAutoQuery CG_DBSESSION
      (strcat "select * from �{�E��COLOR" )
    )
  )

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "CT_ZaiDlg" #dcl_id)) (exit))

  ;;; �߯�߱���ؽ�
  (##Addpop)

  ; �i�ԕ\��
  (if (= &LR "Z")
    (setq #hinban &sOrg_Hin)
    (setq #hinban (strcat &sOrg_Hin "(" &LR ")"))
  )
  (set_tile "txt1" (strcat "�J�E���^�[�i��: " #hinban))

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret$
);KP_CTZaiDlg

;<HOM>*************************************************************************
; <�֐���>    : ShowCT_Dlog
; <�����T�v>  : �����į�ߕi�Ԋm�����މ��i,�i�Ԋm�F�޲�۸�
; <�߂�l>    : ���i,�i��
; <�쐬>      : 01/08/28 YM
; <���l>      :
; ***********************************************************************************>MOH<
(defun ShowCT_Dlog (
  &HINBAN
  &PRICE ; ���i��̫�Ēl
  /
  #RES$ #SDCLID
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���p���l���ǂ���
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CHK_edit (
    &sKEY ; key
    &DEF  ; ��̫�Ēl
    &flg  ; �����׸� 0:���p���l , 1:���p���l>0 , 2:nil�łȂ�������
    /
    #val
    )
    (setq #val (read (get_tile &sKEY)))
    (cond
      ((and (= &flg 2)(= #val nil))
        (alert "���������͂��ĉ������B")
        (set_tile &sKEY &DEF)
        (mode_tile &sKEY 2)
      )
      ((= &flg 0)
        (if (or (= (type #val) 'INT)
                (= (type #val) 'REAL))
          (princ) ; ���p����������
          (progn
            (alert "���p�����l����͂��ĉ������B")
            (set_tile &sKEY &DEF)
            (mode_tile &sKEY 2)
          )
        );_if
      )
      ((= &flg 1)
        (if (and (= (type #val) 'INT)
                 (> #val 0.001)) ; �X�ɐ����ǂ������ׂ�(0�͕s��)
          (princ) ; OK
          (progn
            (alert "0���傫�Ȕ��p�����l����͂��ĉ������B")
            (set_tile &sKEY &DEF)
            (mode_tile &sKEY 2)
          )
        );_if
      )
    );_cond
    (princ)
  );##CHK_edit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (defun ##GetDlgItem (
      / ; �޲�۸ނ̌��ʂ��擾����
      #RES$
      )
      (setq #RES$
        (list
          (get_tile "edtTOKU_ID")         ; �i��
          (atof (get_tile "edtTOKU_PRI")) ; ���i
        )
      )
      (done_dialog)
      #RES$
    );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;; �_�C�A���O�̎��s��
  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (= nil (new_dialog "ShowCTDlg" #sDCLID)) (exit))

  ; �����l�̐ݒ� ; txtORG_PRICE
  (set_tile "edtTOKU_ID" &HINBAN)
  (set_tile "edtTOKU_PRI" &PRICE)

  (mode_tile "edtTOKU_PRI" 2)

  ;;; �^�C���̃��A�N�V�����ݒ�
  (action_tile "edtTOKU_ID"  "(##CHK_edit \"edtTOKU_ID\"  &HINBAN 2)")
  (action_tile "edtTOKU_PRI" "(##CHK_edit \"edtTOKU_PRI\" &PRICE  1)")
  (action_tile "accept" "(setq #RES$ (##GetDlgItem))")
  (start_dialog)
  (unload_dialog #sDCLID)
  ; ���X�g��Ԃ�
  #RES$
);ShowCT_Dlog

;;; <HOM>***********************************************************************************
;;; <�֐���>    : PKGetSinaCode
;;; <�����T�v>  : ���[�N�g�b�v�̕i�R�[�h��Ԃ�
;;; <�߂�l>    : ���~���s���~����(���ڽL�^�́A��1�~��2�~����)
;;; <�쐬>      : 2000-05-23  : YM
;;; <���l>      :
;;; ***********************************************************************************>MOH<
(defun PKGetSinaCode (
  #ZAIF  ; �f��F
  #WRKT$ ; "G_WRKT"
  /
  #DUM1 #DUM123 #DUM2 #DUM3
  #CUTL #CUTR #CUTTYPE
  )
  (setq #CutType (nth 7 #WRKT$)) ; �������
  (setq #cutL (substr #CutType 1 1))
  (setq #cutR (substr #CutType 2 1))

  (if (and (= #ZaiF 1)(= (nth 3 #WRKT$) 1)(= #cutL "0")(= #cutR "0"))
    (progn ; ���ڽL�`��
      (setq #dum1 (itoa (fix (+ (car  (nth 55 #WRKT$)) 0.001))))
      (setq #dum2 (itoa (fix (+ (cadr (nth 55 #WRKT$)) 0.001))))
      (if (/= (nth 10 #WRKT$) "") ; ����
        (setq #dum3 (itoa (fix (+ (nth 10 #WRKT$) 0.001))))
      )
      (setq #dum123 (strcat #dum1 "x " #dum2 "x " #dum3))
    )
    (progn ; ���ڽL�`��ȊO�̂Ƃ�
      (setq #dum1 (itoa (fix (+ (car (nth 55 #WRKT$)) 0.001))))
      (if (/= (car (nth 57 #WRKT$)) "") ; ���s��
        (setq #dum2 (itoa (fix (+ (car (nth 57 #WRKT$)) 0.001))))
      )
      (if (/= (nth 10 #WRKT$) "") ; ����
        (setq #dum3 (itoa (fix (+ (nth 10 #WRKT$) 0.001))))
      )
      (setq #dum123 (strcat #dum1 "x " #dum2 "x " #dum3))
    )
  );_if
  #dum123
);PKGetSinaCode

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KPGetSinkANA
;;; <�����T�v>  : �e�ݸ�́AWT�ގ��ɉ������ݸ���̈�PMEN4����?��ؽĂ�Ԃ�(�ݸ�����Ή�)
;;; <�߂�l>    : �e�ݸ�̓K�؂ȼݸ��(���ۂɌ����J����)
;;; <�쐬>      : 01/03/27 YM
;;; <���l>      : ���ڽ�Ȃ�PMEN4����1,�l��Ȃ�PMEN4����0�̂����e�ݸ�ɑ΂���1��(�ݸ�������͏��Ԃ��d�v)
;;; ***********************************************************************************>MOH<
(defun KPGetSinkANA (
  &eSNK_P4$$  ; �e�ݸ����PMEN4ؽĂ�ؽ�
  &ZaiF       ; �f��F
  /
  #ESNK_P$ #ESNK_P4$$ #SETFLG #XDP4$ #ZAIF
  )
  (setq #eSNK_P4$$ &eSNK_P4$$ #ZaiF &ZaiF)

  (setq #eSNK_P$ nil)
  (foreach #eSNK_P4$ #eSNK_P4$$ ; �ݸ�̐�ٰ��
    (cond
      ((= #ZaiF 1) ; ���ڽ
        (setq #setFLG nil)
        (foreach PMEN4 #eSNK_P4$   ; �ݸ1�ɕ�����PMEN4 #eSNK_P4$
          (setq #xdP4$ (CFGetXData PMEN4 "G_PMEN"))
          (if (= (nth 1 #xdP4$) 1) ; PMEN4����1�̂��̂΂���W�߂�
            (if (= #setFLG nil)
              (progn
                (setq #eSNK_P$ (append #eSNK_P$ (list PMEN4))) ; �����̼ݸ�ɂ���1����PMEN4����1���#eSNK_P$
                (setq #setFLG T) ; 1�¾�Ă���΂�����Ă��Ȃ�
              )
            );_if
          );_if
        )
        (if (and (< 0 (length #eSNK_P4$))(= #setFLG nil))
          (progn
            (CFAlertMsg "���ڽ�p�ݸ���̈�(����1)���ݸ�ɒ�`����Ă��܂���B")
            (quit)
          )
        );_if
      )
      ((or (= #ZaiF 0)(= #ZaiF -1)(= #ZaiF -2)) ; �l�H�嗝�� 01/07/03 YM
        (setq #setFLG nil)
        (foreach PMEN4 #eSNK_P4$   ; �ݸ1�ɕ�����PMEN4 #eSNK_P4$
          (setq #xdP4$ (CFGetXData PMEN4 "G_PMEN"))
          (if (= (nth 1 #xdP4$) 0) ; PMEN4����0�̂��̂΂���W�߂�
            (if (= #setFLG nil)
              (progn
                (setq #eSNK_P$ (append #eSNK_P$ (list PMEN4))) ; �����̼ݸ�ɂ���1����PMEN4����0���#eSNK_P$
                (setq #setFLG T) ; 1�¾�Ă���΂�����Ă��Ȃ�
              )
            );_if
          );_if
        )
        (if (and (< 0 (length #eSNK_P4$))(= #setFLG nil))
          (progn
            (CFAlertMsg "�l��p�ݸ���̈�(����0)���ݸ�ɒ�`����Ă��܂���B")
            (quit)
          )
        );_if
      )
      (T
        (CFAlertMsg "\n�wWT�ގ��x��\"�f��F\"���s���ł��B\n0�܂���1�ł͂���܂���B")(quit)
      )
    );_cond
  );foreach

  #eSNK_P$
);KPGetSinkANA

;<HOM>*************************************************************************
; <�֐���>    : GetWT_MigiShitaPt
; <�����T�v>  : �V�̊O�`�_����擾
; <�߂�l>    : �V�̊O�`�_��,�V�Ԍ�
; <�쐬>      : 2010/11/09 YM
; <���l>      : �ΏہFI�^�AP�^�̂�
;*************************************************************************>MOH<
(defun GetWT_MigiShitaPt (
  &WT ;�V�}�`
  /
  #BASEP #P3 #PT$ #TEI #WTXD$
  )
  (setq #wtXd$ (CFGetXData &WT "G_WRKT"))

  ; CG_P_HOOD_SYM P�^̰�ނ̼���ِ}�`
  (setq #tei   (nth 38 #wtXd$))      ; WT��ʐ}�`�����
  (setq #BaseP (nth 32 #wtXd$))      ; WT����_
  ;(setq #Magu  (nth 42 #wtXd$))      ; WT�Ԍ�
  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��
;;; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
  (setq #pt$ (GetPtSeries #BaseP #pt$))

  #pt$ ;�O�`�_��
);GetWT_MigiShitaPt


;;; <HOM>***********************************************************************************
;;; <�֐���>    : PKGetANAdim-I2
;;; <�����T�v>  : ���[�N�g�b�v���������߂�(I�`��ܰ�į�ߐ�p)�ݸ,��ە����Ή�
;;; <�߂�l>    : WT������̐��@����
;;; <�쐬>      : 00/09/25 YM �W����
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;; ***********************************************************************************>MOH<
(defun PKGetANAdim-I2 (
  &eWT      ; WT�}�`��
  &WRKT$    ; G_WRKT
  &eSNK_P$  ; SNK-PMEN(����ؽ�)
  &eGAS_P$  ; GAS-PMEN(����ؽ�)
  /
  #ANA$ #ANGX #BASEP #DIM$ #LEN1 #LIS1$$ #MAX #MIN #P1 #P2 #PT$ #PTANA$
  #REG1$ #RET$ #TEI #X1
  )
  (setq #ANA$ (append &eSNK_P$ &eGAS_P$)) ; PMEN����ِ}�`
;;; nil������
  (setq #ANA$ (NilDel_List #ANA$))

;;;   p1                           p2 ����H���,J��Ē���
;;;   +----------------------------+
;;;   |    +-------+    +---+     /
;;;   |    | S or G|    |   |    /
;;;   |    +-------+    +---+   /
;;;   +________________________/
;;;   |
;;;   |
;;;  x1     ���z�_x1 (H��Ă̂Ƃ��K�v)

  (setq #tei   (nth 38 &WRKT$))      ; WT��ʐ}�`�����
  (setq #BaseP (nth 32 &WRKT$))      ; WT����_
  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��
;;; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #angX (+ (angle #p1 #p2) (dtr -90)))
  (setq #x1 (polar #p1 #angX 100)) ; ���z�_1
  (setq #LEN1 (distance #p1 #p2))

  (command "_layer" "T" "Z_01*" "") ; PMEN��w�ذ�މ���

  (setq #reg1$ (append #pt$ (list (car #pt$))))

  (setq #lis1$$ '())
  (if #ANA$ ; PMEN����
    (foreach #ANA #ANA$
      (setq #ptANA$ (GetLWPolyLinePt #ANA)) ; PMEN�O�`�_��
      (if (IsEntInPolygon #ANA #reg1$ "CP") ; �̈�1��PMEN�����݂����
        (progn
          (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p1 #x1)))
          (setq #min (car  #ret$)) ; �����ŏ�
          (setq #max (cadr #ret$)) ; �����ő�
          (setq #lis1$$ (append #lis1$$ (list (list #min) (list #max))))
        )
      );_if
    )
  );_if

;;; �̈�1�����@��������߂�(�[���猊�܂ł̋���)
  (setq #dim$
    (PKGetDimSeries2
      #lis1$$  ; (�����ŏ�,�����ő�)��ؽ�
      #LEN1    ; �S��
    )
  )
  (command "_layer" "F" "Z_01*" "") ; PMEN��w�ذ��
  (setq #dim$ (append #dim$ (list #LEN1))) ; �S����������
  #dim$
);PKGetANAdim-I2


;;; <HOM>***********************************************************************************
;;; <�֐���>    : PKGetANAdim-I1
;;; <�����T�v>  : ���[�N�g�b�v���������߂�(I�`��ܰ�į�ߐ�p)�ݸ�̂ݑΉ�
;;; <�߂�l>    : WT������̐��@����
;;; <�쐬>      : 2017/01/13 YM
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;; ***********************************************************************************>MOH<
(defun PKGetANAdim-I1 (
  &eWT      ; WT�}�`��
  &WRKT$    ; G_WRKT
  &eSNK_P$  ; SNK-PMEN(����ؽ�)
  /
  #ANA$ #ANGX #BASEP #DIM$ #LEN1 #LIS1$$ #MAX #MIN #P1 #P2 #PT$ #PTANA$
  #REG1$ #RET$ #TEI #X1
  )
  (setq #ANA$ (append &eSNK_P$ )) ; PMEN����ِ}�`
;;; nil������
  (setq #ANA$ (NilDel_List #ANA$))

;;;   p1                           p2 ����H���,J��Ē���
;;;   +----------------------------+
;;;   |    +-------+              /
;;;   |    | S     |             /
;;;   |    +-------+            /
;;;   +________________________/
;;;   |
;;;   |
;;;  x1     ���z�_x1 (H��Ă̂Ƃ��K�v)

  (setq #tei   (nth 38 &WRKT$))      ; WT��ʐ}�`�����
  (setq #BaseP (nth 32 &WRKT$))      ; WT����_
  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��
;;; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #angX (+ (angle #p1 #p2) (dtr -90)))
  (setq #x1 (polar #p1 #angX 100)) ; ���z�_1
  (setq #LEN1 (distance #p1 #p2))

  (command "_layer" "T" "Z_01*" "") ; PMEN��w�ذ�މ���

  (setq #reg1$ (append #pt$ (list (car #pt$))))

  (setq #lis1$$ '())
  (if #ANA$ ; PMEN����
    (foreach #ANA #ANA$
      (setq #ptANA$ (GetLWPolyLinePt #ANA)) ; PMEN�O�`�_��
      (if (IsEntInPolygon #ANA #reg1$ "CP") ; �̈�1��PMEN�����݂����
        (progn
          (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p1 #x1)))
          (setq #min (car  #ret$)) ; �����ŏ�
          (setq #max (cadr #ret$)) ; �����ő�
          (setq #lis1$$ (append #lis1$$ (list (list #min) (list #max))))
        )
      );_if
    )
  );_if

;;; �̈�1�����@��������߂�(�[���猊�܂ł̋���)
  (setq #dim$
    (PKGetDimSeries2
      #lis1$$  ; (�����ŏ�,�����ő�)��ؽ�
      #LEN1    ; �S��
    )
  )
  (command "_layer" "F" "Z_01*" "") ; PMEN��w�ذ��
  (setq #dim$ (append #dim$ (list #LEN1))) ; �S����������
  #dim$
);PKGetANAdim-I1

;;; <HOM>***********************************************************************************
;;; <�֐���>    : PKGetANAdim-U2
;;; <�����T�v>  : ���[�N�g�b�v���������߂�(U�^��p)�ݸ,��ە����Ή�
;;; <�߂�l>    : WT������̐��@����
;;; <�쐬>      : 00/09/25 YM �W����
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;; ***********************************************************************************>MOH<
(defun PKGetANAdim-U2 (
  &eWT      ; WT�}�`��
  &WRKT$    ; G_WRKT
  &eSNK_P$  ; SNK-PMEN(����ؽ�)
  &eGAS_P$  ; GAS-PMEN(����ؽ�)
  /
  #ANA$ #BASEP #DIM$ #DIM1$ #DIM2$ #DIM3$ #LEN1 #LEN2 #LEN3 #LIS1$$ #LIS2$$ #LIS3$$ #MAX #MIN
  #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #PT$ #PTANA$ #PTANA1$$ #PTANA2$$ #PTANA3$$
  #REG1$ #REG2$ #REG3$ #RET$ #TEI #X1 #X2 #X3 #X4
  )
  (setq #ANA$ (append &eSNK_P$ &eGAS_P$)) ; PMEN����ِ}�`
;;; nil������
  (setq #ANA$ (NilDel_List #ANA$))

;;; p1+----------+--LEN3-------------+p2
;;;   |          x1                  |
;;;   |          |     �̈�3         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |  �̈�2   |
;;;LEN2          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   +x3--------+-------------------+p6
;;;   |          p5                  |
;;;   |          |     �̈�1         |
;;;   |          x4                  |
;;; p8+----------+--LEN1-------------+p7

  (setq #tei   (nth 38 &WRKT$))      ; WT��ʐ}�`�����
  (setq #BaseP (nth 32 &WRKT$))      ; WT����_
  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��
;;; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))
  (setq #p7 (nth 6 #pt$))
  (setq #p8 (nth 7 #pt$))
  (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
  (setq #x2 (CFGetDropPt #p4 (list #p1 #p8)))
  (setq #x3 (CFGetDropPt #p5 (list #p1 #p8)))
  (setq #x4 (CFGetDropPt #p5 (list #p8 #p7)))
  (setq #LEN1 (distance #p7 #p8))
  (setq #LEN2 (distance #p1 #p8))
  (setq #LEN3 (distance #p1 #p2))

  (command "_layer" "T" "Z_01*" "") ; PMEN��w�ذ�މ���

  (setq #reg1$ (list #x3 #p6 #p7 #p8 #x3)) ; �̈�1
  (setq #reg2$ (list #p1 #x1 #x4 #p8 #p1)) ; �̈�2
  (setq #reg3$ (list #p1 #p2 #p3 #x2 #p1)) ; �̈�3

  (setq #lis1$$ '())
  (setq #lis2$$ '())
  (setq #lis3$$ '())
  (if #ANA$ ; PMEN����
    (progn
      (foreach #ANA #ANA$
        (setq #ptANA$ (GetLWPolyLinePt #ANA)) ; PMEN�O�`�_��
        (if (IsEntInPolygon #ANA #reg1$ "CP") ; �̈�1��PMEN�����݂����
          (progn
            (setq #ptANA1$$ (append #ptANA1$$ (list #ptANA$)))
            (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p6 #p7)))
            (setq #min (car  #ret$)) ; �����ŏ�
            (setq #max (cadr #ret$)) ; �����ő�
            (setq #lis1$$ (append #lis1$$ (list (list #min) (list #max))))
          )
        );_if
        (if (IsEntInPolygon #ANA #reg2$ "CP") ; �̈�2��PMEN�����݂����
          (progn
            (setq #ptANA2$$ (append #ptANA2$$ (list #ptANA$)))
            (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p7 #p8)))
            (setq #min (car  #ret$))
            (setq #max (cadr #ret$))
            (setq #lis2$$ (append #lis2$$ (list (list #min) (list #max))))
          )
        );_if
        (if (IsEntInPolygon #ANA #reg3$ "CP") ; �̈�3��PMEN�����݂����
          (progn
            (setq #ptANA3$$ (append #ptANA3$$ (list #ptANA$)))
            (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p1 #p8)))
            (setq #min (car  #ret$)) ; �����ŏ�
            (setq #max (cadr #ret$)) ; �����ő�
            (setq #lis3$$ (append #lis3$$ (list (list #min) (list #max))))
          )
        );_if
      )
    )
  );_if

;;; �̈�1�����@��������߂�(�[���猊�܂ł̋���)
  (setq #dim1$
    (PKGetDimSeries2
      #lis1$$  ; (�����ŏ�,�����ő�)��ؽ�
      #LEN1    ; �S��
    )
  )
;;; �̈�2�����@��������߂�(�[���猊�܂ł̋���)
  (setq #dim2$
    (PKGetDimSeries2
      #lis2$$  ; (�����ŏ�,�����ő�)��ؽ�
      #LEN2    ; �S��
    )
  )
;;; �̈�2�����@��������߂�(�[���猊�܂ł̋���)
  (setq #dim3$
    (PKGetDimSeries2
      #lis3$$  ; (�����ŏ�,�����ő�)��ؽ�
      #LEN3    ; �S��
    )
  )

  (setq #dim$ (append #dim1$ #dim2$ #dim3$))
  (command "_layer" "F" "Z_01*" "") ; PMEN��w�ذ��
  (setq #dim$ (append #dim$ (list #LEN1 #LEN2 #LEN3)))
  #dim$
);PKGetANAdim-U2

;;; <HOM>***********************************************************************************
;;; <�֐���>    : PKGetDimSeries2
;;; <�����T�v>  : ���@�����Ԃ�(�����@�̐���)
;;; <�߂�l>    : (����,����,...)
;;; <�쐬>      : 00/06/28 YM
;;; <���l>      :
;;; ***********************************************************************************>MOH<
(defun PKGetDimSeries2 (
  &lis$$ ; ((���܂ł̋����ŏ�),(���܂ł̋����ő�),...) ؽĂ�ؽ�
  &LEN   ; �S��
  /
  #DIM #DIM$ #DIS #DIS_OLD #I #LIS$$ #SUM
  )
;;; �����̏��������̏��ɿ��
  (setq #lis$$ (CFListSort &lis$$ 0)) ; (nth 0 �����������̏��ɿ��
  (setq #i 0 #dim$ '() #sum 0)
  (foreach #lis$ #lis$$
    (setq #dis (car #lis$))
    (if (= #i 0)
      (setq #dim #dis) ; �ŏ�
      (setq #dim (- #dis #dis_old))
    )
    (setq #dim$ (append #dim$ (list #dim)))
    (setq #sum (+ #sum #dim))
    (setq #dis_old #dis)
    (setq #i (1+ #i))
  );_foreach
  (if (= #dim$ nil)
    (setq #dim$ (list &LEN))
    (setq #dim$ (append #dim$ (list (- &LEN #sum))))
  )
  #dim$
);PKGetDimSeries2

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KPW_GetWorkTopInfoDlg
;;; <�����T�v>  : ���[�N�g�b�v�̕i�Ԏ擾�_�C�A���O
;;; <�߂�l>    : (�i��  ���i)
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      : �L�����Z������"canceled"���Ԃ�
;;; ***********************************************************************************>MOH<
(defun KPW_GetWorkTopInfoDlg (
  &WRKT$
  &DF_NAME    ; �f�t�H���g�̖��O
  &DF_PRICE   ; �f�t�H���g�̉��i
  /
  #RESULT$ #SDCLID #TYPE1 #WTLEN1 #WTLEN2 #WT_DEP1 #WT_DEP2 #WT_T
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KPW_GetWorkTopInfoDlg ////")
  (CFOutStateLog 1 1 " ")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckNum (&sKEY / #val #ret)
    (setq #ret nil)
    (setq #val (read (get_tile &sKEY)))
    (if (= (type (read (get_tile &sKEY))) 'INT)
      (if (<= #val 0)
        (progn
          (alert "0���傫�Ȑ����l����͂��ĉ�����")
          (set_tile &sKEY "")
          (mode_tile &sKEY 2)
        )
        (setq #ret T)
      );_if
      (progn
        (alert "0���傫�Ȑ����l����͂��ĉ�����")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckStr (&sKEY / #ret)
    (setq #ret nil)
    (if (= (type (read (get_tile &sKEY))) 'SYM)
      (setq #ret T)
      (progn
        (alert "���������͂��ĉ�����")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; �S���ڃ`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (defun ##Check&GetAllVal ( / #DLG$)
    (cond
      ((not (##CheckNum "edtWT_PRI"))  nil) ; ���ڂɴװ�������nil��Ԃ�
      ((not (##CheckStr "edtWT_NAME")) nil) ; ���ڂɴװ�������nil��Ԃ�
      (T ; ���ڂɴװ�Ȃ�
        (setq #DLG$
          (list
            (strcase (get_tile "edtWT_NAME"))  ; �i�� �啶���ɂ���
            (atoi (get_tile "edtWT_PRI"))      ; ���i(�~)
          )
        )
        (done_dialog)
        #DLG$
      )
    );_cond
  ); end of ##Check&GetAllVal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; �S���ڃ`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (defun ##Exit ( / )
    (done_dialog)
    nil
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; ���݂̕i�Ԃɑ΂��ĉ��i���������� 01/04/05 YM
  (defun ##SerchPrice ( / #DLG$ #qry$ #PRICE #WTID)
    (setq #WTid (get_tile "edtWT_NAME"))
    (setq #qry$
      (CFGetDBSQLRec CG_DBSESSION "WT��i"
        (list (list "�ŏI�i��" #WTid         'STR))
      )
    )
    (if (and #qry$ (= (length #qry$) 1))
      (progn
        (setq #price (nth 3 (car #qry$))) ; ���i������
        (set_tile "edtWT_PRI" (itoa (fix (+ #price 0.001))) )
      )
      (mode_tile "edtWT_PRI" 2)
    )
    (princ)
  );##SerchPrice
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
;;; (setq #type1   (nth 3 &WRKT$))    ; �`������ =1:L�^
;;;  (setq #ZaiCode (nth 2 &WRKT$))    ;�ގ��L��
;;; (setq #ZaiF (KCGetZaiF #ZaiCode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ
  (setq #WTLEN1  (itoa (fix (+ (car  (nth 55 &WRKT$)) 0.001)))) ; WT��1
  (setq #WTLEN2  (itoa (fix (+ (cadr (nth 55 &WRKT$)) 0.001)))) ; WT��2
  (setq #WT_DEP1 (itoa (fix (+ (car  (nth 57 &WRKT$)) 0.001)))) ; WT���s��1
  (setq #WT_DEP2 (itoa (fix (+ (cadr (nth 57 &WRKT$)) 0.001)))) ; WT���s��2
  (setq #WT_T    (itoa (fix (+       (nth 10 &WRKT$)  0.001)))) ; WT����

  (if (= nil (new_dialog "GetWorkTopInfoDlg" #sDCLID)) (exit)) ; L�^�p
;;; ��ُ����l�ݒ�
  (set_tile "edtWT_NAME" &DF_NAME)
  (set_tile "edtWT_PRI" (itoa &DF_PRICE))
  (set_tile "txt11" #WTLEN1)
  (set_tile "txt22" #WTLEN2)
  (set_tile "txt33" #WT_DEP1)
  (set_tile "txt44" #WT_DEP2)
  (set_tile "txt55" #WT_T)
  ; ���� ���i�̓��͒l�`�F�b�N(0�ȏ�̎������ǂ���)
  (action_tile "edtWT_PRI"  "(##CheckNum \"edtWT_PRI\")")
  (action_tile "edtWT_NAME" "(##CheckStr \"edtWT_NAME\")")
  ; OK�{�^���������ꂽ��S���ڂ��`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (action_tile "accept" "(setq #RESULT$ (##Check&GetAllVal))")
  (action_tile "cancel" "(setq #RESULT$ (##Exit))") ; cancel
  (start_dialog)
  (unload_dialog #sDCLID)
  #RESULT$
);KPW_GetWorkTopInfoDlg

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_MakeHoleWorkTop2
;;; <�����T�v>  : �V���N���A�R�������A�������Ɍ����J����
;;; <�߂�l>    :
;;; <�쐬>      : 99-10-19
;;; <���l>      : 07/06 YM �ݸ,��ە����Ή�
;;;*************************************************************************>MOH<
(defun PKW_MakeHoleWorkTop2 (
  &enWt         ;(ENAME)���[�N�g�b�v�}�`�i�J�b�g�̏ꍇ�A�V���N���j
  &snkPen$      ;(ENAME)�V���N�o�ʐ}�`
  &gasPen$      ;(ENAME)�K�X�o�ʐ}�`
  /
  #EG #GASPEN$ #HOLE #I #OBJ #SNK-XD$ #SNKPEN$ #SNK_SYM #WTXD$ #SETXD$
#EANA ; 02/12/04 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_MakeHoleWorkTop2 ////")
  (CFOutStateLog 1 1 " ")

;;; nil������
  (setq #snkPen$ &snkPen$)
  (setq #gasPen$ &gasPen$)
  (setq #wtXd$ (CFGetXData &enWt "G_WRKT"))
  (if (= nil (tblsearch "APPID" "G_HOLE")) (regapp "G_HOLE"))

  ; 02/05/22 YM �i�Ԋm��ς�WT��ɐ�����z�u���Č��������s���ۂ�
  ; �K�v�ȃV���N���������Ă��܂��s��Ή��̂��߃V���N�Ɍ���������K�v������
  ; �Ƃ��Ɍ����ĉ��H���}�`���폜����(����ȊO&snkPen$=nil�̂Ƃ��͍폜���Ȃ�
  ; 02/04/17 YM ADD-S ���H���}�`���폜����
  ; �i�Ԋm��ς�WT���ĕi�Ԋm�肷��Ƃ��Ɏc���Ă��܂�
  (if (/= nil &snkPen$)
    (progn ; 02/05/22 YM ADD if��

      (setq #i 19)
      (repeat (nth 18 #wtXd$)
        (setq #eANA (nth #i #wtXd$))
        (if (/= nil (entget #eANA))
          (entdel #eANA)
        );_if
        (setq #i (1+ #i))
      )

    ) ; 02/05/22 YM ADD if��
  );_if

;;; �ݸ�̏ꍇ
  (setq #SetXd$ nil)
  (if #snkPen$ ; 00/11/28 YM ADD
    (progn
      (setq #SetXd$ (list (list 18 (length #snkPen$)))) ; �ݸ����
      (setq #i 19)
    )
  );_if
  (foreach #snkPen #snkPen$
;;;CG_SNK_HOLE_DEL
    (setq #eg (entget #snkPen))
    (setq #eg (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (cdr #eg)) (cdr #eg)))
    (setq #eg (subst (cons 62 2) (assoc 62 #eg) #eg))
    (entmake #eg)    ; ���̈�̕����쐬(��ʗ̈�p)
    (setq #hole (entlast))
    (CFSetXData #hole "G_HOLE" ; �ݸ�̏ꍇ "G_HOLE" ���c��
      (list #snkPen)
    )
    (setq #obj (getvar "delobj"))
    (setvar "delobj" 0) ; 0 �I�u�W�F�N�g�͕ێ�����܂��B
    ;2008/07/28 YM MOD 2009�Ή�
    (command "_extrude" #hole "" -3000 )             ;�����o��
;;;    (command "_extrude" #hole "" -3000 "")             ;�����o��
    (command "_move" (entlast) "" "0,0,0" "@0,0,1000") ;�ړ�
    (command "_subtract" &enWt "" (entlast) "")        ;�����Z
    (setvar "delobj" #obj) ; 0 �A�C�e���͕ێ�����܂�
    (setq #SNK_sym (SearchGroupSym #snkPen)) ; �ݸ����ȯĐe�}�`��
    (setq #SNK-xd$ (CFGetXData #SNK_sym "G_SINK"))
    (CFSetXData
      #SNK_sym
      "G_SINK"
      (CFModList
        #SNK-xd$
        (list (list 3 #hole))
      )
    )
    (setq #SetXd$ (append #SetXd$ (list (list #i #hole)))) ; "G_WRKT"��ėp 00/11/28 YM ADD
    (setq #i (1+ #i))
  );foreach

  ;;; �ݸ����"G_WRKT"�ɾ�Ă��� 00/11/28 YM ADD
  (if #SetXd$
    (CFSetXData &enWt "G_WRKT"
      (CFModList #wtXd$ #SetXd$)
    )
  );_if


;2008/10/23 YM DEL ��ی��͊J���Ȃ�
;;; ��ۂ̏ꍇ
;;; 2008/10/23YM@DEL  (foreach #gasPen #gasPen$
;;; 2008/10/23YM@DEL    (setq #eg (entget #gasPen))
;;; 2008/10/23YM@DEL    (setq #eg (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (cdr #eg)) (cdr #eg)))
;;; 2008/10/23YM@DEL    (setq #eg (subst (cons 62 2) (assoc 62 #eg) #eg))
;;; 2008/10/23YM@DEL    (entmake #eg)    ; ���̈�̕����쐬(��ʗ̈�p)
;;; 2008/10/23YM@DEL    (setq #hole (entlast))
;;; 2008/10/23YM@DEL    ;2008/07/28 YM MOD 2009�Ή�
;;; 2008/10/23YM@DEL    (command "_extrude" #hole "" -3000 )             ;�����o��
;;; 2008/10/23YM@DEL;;;    (command "_extrude" #hole "" -3000 "")             ;�����o��
;;; 2008/10/23YM@DEL    (command "_move" (entlast) "" "0,0,0" "@0,0,1000") ;�ړ�
;;; 2008/10/23YM@DEL    (command "_subtract" &enWt "" (entlast) "")        ;�����Z
;;; 2008/10/23YM@DEL  )

  ;// �������̈����������
;2010/01/07 YM ADD KPCAD�i�Ԋm�莞�A(nth 22 #wtXd$)�ɐ}�`��������̂ŗ����邩�����
;;;  (setq #i 23)
;;;  (repeat (nth 22 #wtXd$)
;;;   (setq #eg (entget (nth #i #wtXd$)))
;;;    (setq #eg (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (cdr #eg)) (cdr #eg)))
;;;    (setq #eg (subst (cons 62 2) (assoc 62 #eg) #eg))
;;;    (entmake #eg)    ; ���̈�̕����쐬(��ʗ̈�p)
;;;   ;2008/07/28 YM MOD 2009�Ή�
;;;    (command "_extrude" (entlast) ""-1500 )         ;�����o��
;;;;;;    (command "_extrude" (entlast) ""-1500 "")         ;�����o��
;;;    (command "_move" (entlast) "" "0,0,0" "@0,0,200") ;�ړ�
;;;    (command "_subtract" &enWt "" (entlast) "" )      ;�����Z
;;;   (setq #i (1+ #i))
;;;  )

  (princ)
)
;PKW_MakeHoleWorkTop2

;<HOM>*************************************************************************
; <�֐���>    : PKY_ShowWTSET_Dlog
; <�����T�v>  : ���[�N�g�b�v���\���_�C�A���O
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2000-01-31 ���� ����
; <���l>      :
; ***********************************************************************************>MOH<
(defun PKY_ShowWTSET_Dlog (
  &WRKT$
  &WTSET$
  /
  #SDCLID
  #loop
  #RESULT$
  )
  ; 2006/09/15 T.Ari MOD �m�F��ʂ̐ݒ�l��V�ɐݒ肷��B&0�~�����͂��ꂽ�ꍇ�ɍē��͂𑣂��悤�ɕύX
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKY_ShowWTSET_Dlog ////")
  (CFOutStateLog 1 1 " ")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckNum (&val / #val #ret)
    (setq #ret nil)
    (setq #val (read &val))
    (if (= (type (read &val)) 'INT)
      (if (<= #val -0.001)
        (progn
          (alert "0�ȏ�̐����l����͂��ĉ�����")
        )
        (setq #ret T)
      );_if
      (progn
        (alert "0�ȏ�̐����l����͂��ĉ�����")
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckStr (&val / #ret)
    (setq #ret nil)
    (if (= (vl-string-search "?" &val) nil)
      (setq #ret T)
      (progn
        (alert "�i�Ԃ���͂��ĉ�����")
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; ���͍��ڎ擾�`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (defun ##GetAllVal ( / #DLG$)
    (setq #DLG$ (list (get_tile "edtWT_ID") (get_tile "edtWT_PRI")))
    (done_dialog)
    #DLG$
  ); end of ##GetAllVal
  (if (not &WTSET$)
    (progn (alert "���[�N�g�b�v�i�ԏ��̎擾�Ɏ��s���܂���") (exit))
  );_if
  (if (= "" (nth 1 &WTSET$)) (set_tile "error" "�i�Ԃ��m�肳��Ă��܂���"))
  (setq #RESULT$ (list (nth 1 &WTSET$) (rtos (nth 3 &WTSET$) 2 0)))
  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (setq #loop T)
  (while #loop
    (if (= nil (new_dialog "ShowWorkTopInfoDlg" #sDCLID)) (exit))
    ; �����l�̐ݒ�
    (set_tile "edtWT_ID" (nth 0 #RESULT$))
    (set_tile "edtWT_PRI" (nth 1 #RESULT$))
    ; �����Ȃ�A���@���ݒ�
    (if (= 0 (car &WTSET$)) (set_tile "edtWT_LEN" (nth 4 &WTSET$)))
    (action_tile "accept" "(setq #RESULT$ (##GetAllVal))")
  
    (start_dialog)
    (cond
      ((not (##CheckStr (nth 0 #RESULT$)))
      )
      ((not (##CheckNum (nth 1 #RESULT$)))
      )
      ((equal (atof (nth 1 #RESULT$)) 0.0 0.0001)
        (if (CFYesNoDialog "���i��0�~�ŗǂ��ł����H")
          (setq #loop nil)
        )
      )
      (T 
        (setq #loop nil)
      )
    )
  )
  (unload_dialog #sDCLID)
  (list (strcase (nth 0 #RESULT$)) (atof (nth 1  #RESULT$)))
);PKY_ShowWTSET_Dlog

;<HOM>*************************************************************************
; <�֐���>    : PKW_SQLResultCheck
; <�����T�v>  : �`�F�b�N�����֐�
; <�߂�l>    : ���X�g (SQL���ʃ��X�g  �G���[������)
; <�쐬>      : 00/02/17 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PKW_SQLResultCheck (
  &SQL_R$     ; SQL�̌��ʃ��X�g
  &sKANS      ; �G���[�ɕ\��������֐���
  &sNAME      ; �G���[�ɕ\��������e�[�u����
  &sEMSG      ; ���b�Z�[�W
  &iNUM       ; nth�� �l�̂���ׂ��ʒu
  /
  #msg
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_SQLResultCheck ////")
  (CFOutStateLog 1 1 " ")

  (if (= &SQL_R$ nil)
    ; ���ʃ��X�g�����Ȃ������ꍇ�A�G���[������Ƀe�[�u�����ǉ��A���̂܂ܐi�߂�
    (setq &sEMSG (strcat &sEMSG &sNAME))
    (progn
      (CFOutStateLog 1 1 "*** �擾ں��� ***")
      (CFOutStateLog 1 1 &SQL_R$)
      (if (= (length &SQL_R$) 1)
        (progn
        (setq &SQL_R$ (car &SQL_R$))
        (if (= nil (nth &iNUM &SQL_R$)) (setq &sEMSG (strcat &sEMSG &sNAME)))
        ); end of progn
        ; ���ʃ��X�g��������ꂽ�ꍇ�A�G���[���o���R�}���h���I��������
        (progn
          (setq #msg (strcat &sNAME "�Ƀ��R�[�h����������܂���.\n" &sKANS))
          (CFOutStateLog 0 1 #msg)
          (CFAlertMsg #msg)
          (*error*)
        )
      )
    )
  )
  (list &SQL_R$ &sEMSG) ; �`�F�b�N���ʂ�Ԃ�
); end of PKW_SQLResultCheck

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_GetWorkTopAreaSym3
;;; <�����T�v>  : �w�胏�[�N�g�b�v�̈���̃V���N�A�����A�K�X�R�������擾����
;;; <�߂�l>    : ((�ݸ,�ݸ����,P��1,P��4)��ؽ�,(���,��۷���,P��5)��ؽ�,����ؽ�)
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      : �ݸ,��ە����Ή�
;;;               vpoint (0,0,1)�O��
;;;               ����Ȱ��ݑΉ� 01/02 16 YM ADD
;;;*************************************************************************>MOH<
(defun PKW_GetWorkTopAreaSym3 (
  &enWt ;(ENAME)���[�N�g�b�v�}�`��
  /
;-- 2011/06/16 A.Satoh Mod(#CUTL #CUTR���폜) - S
; #BASEWT #CUTL #CUTR #EN #ENGAS #ENGASCAB$ #ENSNK #ENSNKCAB$ #EWTR$ #LOOP
  #BASEWT #EN #ENGAS #ENGASCAB$ #ENSNK #ENSNKCAB$ #EWTR$ #LOOP
;-- 2011/06/16 A.Satoh Mod(#CUTL #CUTR���폜) - S
  #GAS$$ #GASPEN5 #I #P-SS #PT$ #SNK$$ #SNKPEN1$ #SNKPEN4$ #TEIWT #XD$ #XDWT$
#GASPEN9 #LOOP5 #LOOP9 #RET ;2013/09/10 YM ADD
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// PKW_GetWorkTopAreaSym3 ////")
  (CFOutStateLog 1 1 " ")

  (setq #xdWT$ (CFGetXData &enWt "G_WRKT"))
  (setq #baseWT (nth 32 #xdWT$)) ; WT����_
;-- 2011/06/16 A.Satoh Del - S
; (setq #cutL   (nth 36 #xdWT$)) ; WT��č�
; (setq #cutR   (nth 37 #xdWT$)) ; WT��ĉE
;-- 2011/06/16 A.Satoh Del - E
  (setq #teiWT  (nth 38 #xdWT$)) ; WT��ʐ}�`
  (setq #pt$ (GetLWPolyLinePt #teiWT))    ; WT�O�`�_��
  (setq #pt$ (GetPtSeries #baseWT #pt$))  ; WT����_ ��擪�Ɏ��v����
;-- 2011/06/16 A.Satoh Del - S
;;;; D��Ď��ɔ����Ăv�s���h�`��̂Ƃ����E�ɗ̈��100mm��������
; (if (= #cutL "D")
;   (setq #pt$ (PKExtendPTAreaRL100mm #pt$ "L"))
; );_if
; (if (= #cutR "D")
;   (setq #pt$ (PKExtendPTAreaRL100mm #pt$ "R"))
; );_if
;-- 2011/06/16 A.Satoh Del - E

  (setq #pt$ (AddPtList #pt$))

;;; (�ݸ,�ݸ����,P��1,P��4)��ؽĂ����߂�
  (setq #enSNKCAB$ '())
  (setq #SNK$$ '())

  (setq #enSNKCAB$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SCA)) ; �ݸ���� ; 01/08/31 YM MOD 112-->��۰��ى�

  (if #enSNKCAB$
		(progn
			(princ "\n�������@�ݸ���ނ��� ")
	    (foreach #enSNKCAB #enSNKCAB$
	      (setq #enSNK   nil)
	      (setq #snkPen1$ nil)
	      (setq #snkPen4$ nil)

	      (setq #enSNK (PKGetSinkSymBySinkCabCP #enSNKCAB)) ; �ݸ
	      (if #enSNK ; �ݸ���������� PMEN1,PMEN4 �����߂�
	        (progn
						(princ "\n�������@�ݸ����")
	          (setq #p-ss (CFGetSameGroupSS #enSNK))
	          (setq #i 0)
	          (repeat (sslength #p-ss)
	            (setq #en (ssname #p-ss #i))
	            (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
	            (if (and #xd$ (= 1 (car #xd$)))
	              (setq #snkPen1$ (append #snkPen1$ (list #en)))
	            );_(if
	            (if (and #xd$ (= 4 (car #xd$)))
	              (setq #snkPen4$ (append #snkPen4$ (list #en)))
	            );_(if
	            (setq #i (1+ #i))
	          )
	        )
					(progn
						(princ "\n�������@�ݸ�Ȃ�")
					)
	      );_if
	      (setq #SNK$$ (append #SNK$$ (list (list #enSNK #enSNKCAB #snkPen1$ #snkPen4$))))
	    );_foreach

		)
		(progn
			(princ "\n�������@�ݸ���ނȂ�")
		)
  );_if

;;; (���,��۷���,P��5)��ؽĂ����߂�
  (setq #enGASCAB$ '())
  (setq #GAS$$ '())
;;; �_���WT����_���n�_�Ƃ��A���v����
  (setq #enGASCAB$ (PKGetSymBySKKCodeCP2 #pt$)) ; ��۷���
  (if #enGASCAB$
    (foreach #enGASCAB #enGASCAB$
      (setq #enGAS   nil)
      (setq #GasPen5 nil)
      (setq #GasPen9 nil);2013/09/10 YM ADD
      (setq #enGAS (PKGetGasSymByGasCabCP #enGASCAB)) ; ���

      (if #enGAS
        (setq #p-ss (CFGetSameGroupSS #enGAS)) ; ��ۂ����������ۓ��� PMEN5 �����߂�
        (setq #p-ss (CFGetSameGroupSS #enGASCAB)) ; ��ۂ��Ȃ��������۷��ޓ��ŒT��
      );_if

      (setq #i 0 #loop T)
			(setq #loop5 nil)
			(setq #loop9 nil)
      (while (and #loop (< #i (sslength #p-ss)))
        (setq #en (ssname #p-ss #i))
        (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
        (if (and #xd$ (= 5 (car #xd$)))       ; PMEN5���g�p����
					;2013/09/10 YM MOD-S
          (setq #GasPen5 #en #loop5 T)
;;;          (setq #GasPen5 #en #loop nil)
					;2013/09/10 YM MOD-E
        );_if

				;2013/09/10 YM ADD-S P��9��V�K�ǉ����������.������P��9���Ȃ��ꍇ��P��5���]���ǂ���Q�Ƃ�����
        (if (and #xd$ (= 9 (car #xd$)))       ; PMEN5���g�p����
          (setq #GasPen9 #en #loop9 T)
        );_if

				(if (and #loop5 #loop9)
					(setq #loop nil)
				);_if
				;2013/09/10 YM ADD-E

        (setq #i (1+ #i))
      )

			;2013/09/10 YM MOD-S
			(if #GasPen9 ;P��9�����݂�����D��
				(setq #RET #GasPen9)
				;else
				(setq #RET #GasPen5);�Ȃ����P��5
			);_if
;;;      (setq #GAS$$ (append #GAS$$ (list (list #enGAS #enGASCAB #GasPen5))))
      (setq #GAS$$ (append #GAS$$ (list (list #enGAS #enGASCAB #RET))))
			;2013/09/10 YM MOD-E

    );_foreach
  );_if

;;; ��������ؽĂ����߂�
  (setq #eWTR$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; ���� ; 01/08/31 YM MOD 510-->��۰��ى�
  (list #SNK$$ #GAS$$ #eWTR$)
);PKW_GetWorkTopAreaSym3

;;;01/02/16YM@;;;<HOM>*************************************************************************
;;;01/02/16YM@;;; <�֐���>    : PKW_GetWorkTopAreaSym3
;;;01/02/16YM@;;; <�����T�v>  : �w�胏�[�N�g�b�v�̈���̃V���N�A�����A�K�X�R�������擾����
;;;01/02/16YM@;;; <�߂�l>    : ((�ݸ,�ݸ����,P��1,P��4)��ؽ�,(���,��۷���,P��5)��ؽ�,����ؽ�)
;;;01/02/16YM@;;; <�쐬>      : 00/09/21 YM �W����
;;;01/02/16YM@;;; <���l>      : �ݸ,��ە����Ή�
;;;01/02/16YM@;;;               vpoint (0,0,1)�O��
;;;01/02/16YM@;;;*************************************************************************>MOH<
;;;01/02/16YM@(defun PKW_GetWorkTopAreaSym3 (
;;;01/02/16YM@  &enWt ;(ENAME)���[�N�g�b�v�}�`��
;;;01/02/16YM@  /
;;;01/02/16YM@  #BASEWT #CUTL #CUTR #EN #ENGAS #ENGASCAB$ #ENSNK #ENSNKCAB$ #EWTR$
;;;01/02/16YM@  #GAS$$ #GASPEN5 #I #P-SS #PT$ #SNK$$ #SNKPEN1 #SNKPEN4 #TEIWT #XD$ #XDWT$
;;;01/02/16YM@  )
;;;01/02/16YM@  (CFOutStateLog 1 1 " ")
;;;01/02/16YM@  (CFOutStateLog 1 1 "//// PKW_GetWorkTopAreaSym3 ////")
;;;01/02/16YM@  (CFOutStateLog 1 1 " ")
;;;01/02/16YM@
;;;01/02/16YM@  (setq #xdWT$ (CFGetXData &enWt "G_WRKT"))
;;;01/02/16YM@  (setq #baseWT (nth 32 #xdWT$)) ; WT����_
;;;01/02/16YM@  (setq #cutL   (nth 36 #xdWT$)) ; WT��č�
;;;01/02/16YM@  (setq #cutR   (nth 37 #xdWT$)) ; WT��ĉE
;;;01/02/16YM@  (setq #teiWT  (nth 38 #xdWT$)) ; WT��ʐ}�`
;;;01/02/16YM@  (setq #pt$ (GetLWPolyLinePt #teiWT))    ; WT�O�`�_��
;;;01/02/16YM@  (setq #pt$ (GetPtSeries #baseWT #pt$))  ; WT����_ ��擪�Ɏ��v����
;;;01/02/16YM@;;; D��Ď��ɔ����Ăv�s���h�`��̂Ƃ����E�ɗ̈��100mm��������
;;;01/02/16YM@  (if (= #cutL "D")
;;;01/02/16YM@    (setq #pt$ (PKExtendPTAreaRL100mm #pt$ "L"))
;;;01/02/16YM@  );_if
;;;01/02/16YM@  (if (= #cutR "D")
;;;01/02/16YM@    (setq #pt$ (PKExtendPTAreaRL100mm #pt$ "R"))
;;;01/02/16YM@  );_if
;;;01/02/16YM@
;;;01/02/16YM@  (setq #pt$ (AddPtList #pt$))
;;;01/02/16YM@
;;;01/02/16YM@;;; (�ݸ,�ݸ����,P��1,P��4)��ؽĂ����߂�
;;;01/02/16YM@  (setq #enSNKCAB$ '())
;;;01/02/16YM@  (setq #SNK$$ '())
;;;01/02/16YM@
;;;01/02/16YM@  (setq #enSNKCAB$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SCA)) ; �ݸ���� ; 01/08/31 YM MOD 112-->��۰��ى�
;;;01/02/16YM@
;;;01/02/16YM@  (if #enSNKCAB$
;;;01/02/16YM@    (foreach #enSNKCAB #enSNKCAB$
;;;01/02/16YM@      (setq #enSNK   nil)
;;;01/02/16YM@      (setq #snkPen1 nil)
;;;01/02/16YM@      (setq #snkPen4 nil)
;;;01/02/16YM@
;;;01/02/16YM@      (setq #enSNK (PKGetSinkSymBySinkCabCP #enSNKCAB)) ; �ݸ
;;;01/02/16YM@      (if #enSNK ; �ݸ���������� PMEN1,PMEN4 �����߂�
;;;01/02/16YM@        (progn
;;;01/02/16YM@          (setq #p-ss (CFGetSameGroupSS #enSNK))
;;;01/02/16YM@          (setq #i 0)
;;;01/02/16YM@          (repeat (sslength #p-ss)
;;;01/02/16YM@            (setq #en (ssname #p-ss #i))
;;;01/02/16YM@            (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
;;;01/02/16YM@            (if (and #xd$ (= 1 (car #xd$)))       ;  �ݸ���t���̈� ���ڽ��PMEN1���g�p����
;;;01/02/16YM@              (setq #snkPen1 #en)
;;;01/02/16YM@            );_(if
;;;01/02/16YM@            (if (and #xd$ (= 4 (car #xd$)))       ;  �ݸ���t���̈� ��߽��PMEN4���g�p����
;;;01/02/16YM@              (setq #snkPen4 #en)
;;;01/02/16YM@            );_(if
;;;01/02/16YM@            (setq #i (1+ #i))
;;;01/02/16YM@          )
;;;01/02/16YM@        )
;;;01/02/16YM@      );_if
;;;01/02/16YM@      (setq #SNK$$ (append #SNK$$ (list (list #enSNK #enSNKCAB #snkPen1 #snkPen4))))
;;;01/02/16YM@    );_foreach
;;;01/02/16YM@  );_if
;;;01/02/16YM@
;;;01/02/16YM@;;; (���,��۷���,P��5)��ؽĂ����߂�
;;;01/02/16YM@  (setq #enGASCAB$ '())
;;;01/02/16YM@  (setq #GAS$$ '())
;;;01/02/16YM@;;; �_���WT����_���n�_�Ƃ��A���v����
;;;01/02/16YM@  (setq #enGASCAB$ (PKGetSymBySKKCodeCP2 #pt$)) ; ��۷���
;;;01/02/16YM@  (if #enGASCAB$
;;;01/02/16YM@    (foreach #enGASCAB #enGASCAB$
;;;01/02/16YM@      (setq #enGAS   nil)
;;;01/02/16YM@      (setq #GasPen5 nil)
;;;01/02/16YM@
;;;01/02/16YM@      (setq #enGAS (PKGetGasSymByGasCabCP #enGASCAB)) ; ���
;;;01/02/16YM@
;;;01/02/16YM@      (if #enGAS ; ��ۂ��������� PMEN5 �����߂�
;;;01/02/16YM@        (progn
;;;01/02/16YM@          (setq #p-ss (CFGetSameGroupSS #enGAS))
;;;01/02/16YM@          (setq #i 0)
;;;01/02/16YM@          (repeat (sslength #p-ss)
;;;01/02/16YM@            (setq #en (ssname #p-ss #i))
;;;01/02/16YM@            (setq #xd$ (CFGetXData #en "G_PMEN")) ; G_PMEN�g���ް�
;;;01/02/16YM@            (if (and #xd$ (= 5 (car #xd$)))       ; PMEN5���g�p����
;;;01/02/16YM@              (setq #GasPen5 #en)
;;;01/02/16YM@            );_(if
;;;01/02/16YM@            (setq #i (1+ #i))
;;;01/02/16YM@          )
;;;01/02/16YM@        )
;;;01/02/16YM@      );_if
;;;01/02/16YM@      (setq #GAS$$ (append #GAS$$ (list (list #enGAS #enGASCAB #GasPen5))))
;;;01/02/16YM@    );_foreach
;;;01/02/16YM@  );_if
;;;01/02/16YM@
;;;01/02/16YM@;;; ��������ؽĂ����߂�
;;;01/02/16YM@  (setq #eWTR$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SUI)) ; ���� ; 01/08/31 YM MOD 510-->��۰��ى�
;;;01/02/16YM@  (list #SNK$$ #GAS$$ #eWTR$)
;;;01/02/16YM@);PKW_GetWorkTopAreaSym3

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKMultiSnkGas
;;; <�����T�v>  : �ݸ�A��ۂ̐����R�ȏ゠�邩�ǂ�����������
;;; <�߂�l>    : �����T �Ȃ����nil
;;; <�쐬>      : 07/06 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKMultiSnkGas (
  &pt$ ;WT�O�`�_��(�n�_�𖖔��ɒǉ��ς�)
  /
  #GAS$ #SNK$
  )

  (setq #snk$ (PKGetSymBySKKCodeCP &pt$ CG_SKK_INT_SNK)) ; �ݸ�����ؽ� ; 01/08/31 YM MOD 410-->��۰��ى�
  (setq #gas$ (PKGetSymBySKKCodeCP &pt$ CG_SKK_INT_GAS)) ; ��ۼ����ؽ� ; 01/08/31 YM MOD 210-->��۰��ى�
  (if (<= 3 (+ (length #snk$)(length #gas$)))
    T   ; �R�ȏ�
    nil ; OK
  );\if

);PKMultiSnkGas


;;;/////////////////////////////////////////////////////////////////////////////
;;;/////////////////////////////////////////////////////////////////////////////
;;;/////////////////////////////////////////////////////////////////////////////

;;;01/06/28YM@;<HOM>*************************************************************************
;;;01/06/28YM@; <�֐���>    : C:StretchWkTop
;;;01/06/28YM@; <�����T�v>  : ���[�N�g�b�v�Ԍ��L�k
;;;01/06/28YM@; <�߂�l>    :
;;;01/06/28YM@; <�쐬>      : 1999-10-21 �V�^WT�Ή� 2000.4.13 YM
;;;01/06/28YM@; <���l>      : ��ʂ���蒼��(stretch���g��Ȃ������ް�ޮ�)
;;;01/06/28YM@;*************************************************************************>MOH<
;;;01/06/28YM@(defun C:StretchWkTop (
;;;01/06/28YM@  /
;;;01/06/28YM@  #55 #ANG #BASEPT #BASE_NEW #BG #BG0 #BG_H #BG_PT$ #BG_REGION #BG_SEP
;;;01/06/28YM@  #BG_SOLID #BG_T #BG_TEI #BG_TEI1 #BG_TEI2 #CL #CR #CUTL #CUTR #CUTTYPE
;;;01/06/28YM@  #D150BG #DEP #FG #FG01 #FG02 #FG1_PT$ #FG2_PT$ #FG_H #FG_REGION #FG_S
;;;01/06/28YM@  #FG_SOLID1 #FG_SOLID2 #FG_T #FG_TEI1 #FG_TEI2 #FLG #ISTRETCH #LOOP #P2 #PD
;;;01/06/28YM@  #PTS #RET$ #SS #TYPE0 #WT #WT0 #WTEN #WTL #WTLEN1 #WTLEN2 #WTLEN3 #WTR #WT_H
;;;01/06/28YM@  #WT_LEN$ #WT_PT$ #WT_REGION #WT_SOLID #WT_T #WT_TEI #XD$ #XD0$ #XDL$ #XDR$
;;;01/06/28YM@  #X #XD_NEW$ #ZAICODE #KAIJO #YESNOMSG #ZAIF
;;;01/06/28YM@  )
;;;01/06/28YM@
;;;01/06/28YM@; 01/06/28 YM ADD ����ނ̐��� Lipple
;;;01/06/28YM@(if (equal (KPGetSinaType) 2 0.1)
;;;01/06/28YM@  (progn
;;;01/06/28YM@    (CFAlertMsg msg8)
;;;01/06/28YM@    (quit)
;;;01/06/28YM@  )
;;;01/06/28YM@  (progn
;;;01/06/28YM@
;;;01/06/28YM@  (CFOutStateLog 1 1 " ")
;;;01/06/28YM@  (CFOutStateLog 1 1 "//// C:StretchWkTop ////")
;;;01/06/28YM@  (CFOutStateLog 1 1 " ")
;;;01/06/28YM@  (setq #KAIJO nil)  ; �i�Ԋm������׸�
;;;01/06/28YM@
;;;01/06/28YM@  ;// �R�}���h�̏�����
;;;01/06/28YM@  (StartUndoErr)
;;;01/06/28YM@  (CFCmdDefBegin 6);00/09/26 SN ADD
;;;01/06/28YM@  (setq #PD (getvar "pdmode")) ; 06/12 YM
;;;01/06/28YM@  (setvar "pdmode" 34)         ; 06/12 YM
;;;01/06/28YM@
;;;01/06/28YM@  ;// ���[�N�g�b�v�̎w��
;;;01/06/28YM@  (initget 0)
;;;01/06/28YM@  (setq #loop T)
;;;01/06/28YM@  (while #loop
;;;01/06/28YM@    (setq #wtEn (car (entsel "\n���[�N�g�b�v��I��: ")))
;;;01/06/28YM@    (if #wtEn
;;;01/06/28YM@      (setq #xd$ (CFGetXData #wten "G_WRKT"))
;;;01/06/28YM@      (setq #xd$ nil)
;;;01/06/28YM@    );_if
;;;01/06/28YM@    (if (= #xd$ nil)
;;;01/06/28YM@      (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
;;;01/06/28YM@    ;else
;;;01/06/28YM@      (cond
;;;01/06/28YM@        ((CFGetXData #wtEn "G_WTSET")
;;;01/06/28YM@          (setq #YesNoMsg "���[�N�g�b�v�͕i�Ԋm�肳��Ă��܂��B\n�����𑱂��܂����H")
;;;01/06/28YM@          (if (CFYesNoDialog #YesNoMsg)
;;;01/06/28YM@            (progn
;;;01/06/28YM@              (setq #loop nil) ; YES �Ȃ�p��
;;;01/06/28YM@              (setq #KAIJO T)  ; �i�Ԋm������׸�
;;;01/06/28YM@            )
;;;01/06/28YM@            (*error*)        ; NO  �Ȃ�STOP
;;;01/06/28YM@          );_if
;;;01/06/28YM@        )
;;;01/06/28YM@        (T
;;;01/06/28YM@          (setq #loop nil)
;;;01/06/28YM@        )
;;;01/06/28YM@      );_cond
;;;01/06/28YM@    );_if
;;;01/06/28YM@
;;;01/06/28YM@  );while
;;;01/06/28YM@
;;;01/06/28YM@  (PCW_ChColWT #wtEn "MAGENTA" nil) ; �F��ς���
;;;01/06/28YM@
;;;01/06/28YM@  (setq #CutType (nth 7 #xd$))         ; �������
;;;01/06/28YM@;;; ��ċL��
;;;01/06/28YM@  (setq #CL (substr #CutType 1 1))
;;;01/06/28YM@  (setq #CR (substr #CutType 2 1))
;;;01/06/28YM@
;;;01/06/28YM@  (cond
;;;01/06/28YM@    ((and (= #CL "0") (= #CR "0")) ; �X�e��L�^ or I�^
;;;01/06/28YM@      (initget 1 "Left Right")
;;;01/06/28YM@;;;      (initget 1)
;;;01/06/28YM@;;;      (setq #pts (getpoint "\n�L�k�����w��: "))
;;;01/06/28YM@      (setq #x (getkword "\n�L�k�����w�� /L=��/R=�E/:  "))
;;;01/06/28YM@    )
;;;01/06/28YM@    ((and (/= #CL "0") (/= #CR "0"))
;;;01/06/28YM@      (CFAlertMsg "���̃��[�N�g�b�v�͐L�k�ł��܂���B")(quit)
;;;01/06/28YM@    )
;;;01/06/28YM@    ((and (= #CL "0") (/= #CR "0"))
;;;01/06/28YM@      (setq #x "Left")
;;;01/06/28YM@    )
;;;01/06/28YM@    ((and (/= #CL "0") (= #CR "0"))
;;;01/06/28YM@      (setq #x "Right")
;;;01/06/28YM@    )
;;;01/06/28YM@  );_cond
;;;01/06/28YM@
;;;01/06/28YM@  (setq #iStretch (getdist "\n�L�k��: "))
;;;01/06/28YM@  (if (= #iStretch nil) (setq #iStretch 0))
;;;01/06/28YM@
;;;01/06/28YM@  (PCW_ChColWT #wtEn "BYLAYER" nil)
;;;01/06/28YM@
;;;01/06/28YM@  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
;;;01/06/28YM@  (CFNoSnapStart) ; 00/02/07@YM@
;;;01/06/28YM@
;;;01/06/28YM@  (setq #ZaiCode (nth 2 #xd$))
;;;01/06/28YM@  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ
;;;01/06/28YM@
;;;01/06/28YM@  (setq #WT_H (nth  8 #xd$))  ; WT����
;;;01/06/28YM@  (setq #WT_T (nth 10 #xd$))  ; WT����
;;;01/06/28YM@  (setq #BG_H (nth 12 #xd$))  ; BG����
;;;01/06/28YM@  (if (equal #BG_H 150 0.1)
;;;01/06/28YM@    (setq #D150BG T)
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (setq #BG_T (nth 13 #xd$))  ; BG����
;;;01/06/28YM@  (setq #FG_H (nth 15 #xd$))  ; FG����
;;;01/06/28YM@  (setq #FG_T (nth 16 #xd$))  ; FG����
;;;01/06/28YM@  (setq #FG_S (nth 17 #xd$))  ; FG��ė�
;;;01/06/28YM@  (setq #cutL (nth 36 #xd$))  ; �J�b�g��
;;;01/06/28YM@  (setq #cutR (nth 37 #xd$))  ; �J�b�g�E
;;;01/06/28YM@  (setq #WT_LEN$  (nth 55 #xd$))    ; WT����
;;;01/06/28YM@  (setq #dep (car (nth 57 #xd$)))   ; WT���s��
;;;01/06/28YM@
;;;01/06/28YM@  (setq #WT_tei (nth 38 #xd$))             ; WT��ʐ}�`�����
;;;01/06/28YM@  (setq #BASEPT (nth 32 #xd$))             ; WT����_
;;;01/06/28YM@  (setq #BG_tei1 (nth 49 #xd$))            ; BG SOLID1 or ���1
;;;01/06/28YM@  (setq #BG_tei2 (nth 50 #xd$))            ; BG SOLID2 or ���2 ��������΂��̂܂�
;;;01/06/28YM@
;;;01/06/28YM@  (if (= (cdr (assoc 0 (entget #BG_tei1))) "3DSOLID") ; �ޯ��ް�ޕ����^ 00/09/29 YM MOD
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (setq #BG_SEP 1) ; �����^
;;;01/06/28YM@      (if (/= #BG_tei1 "")
;;;01/06/28YM@        (if (setq #xd0$ (CFGetXData #BG_tei1 "G_BKGD"))
;;;01/06/28YM@          (setq #BG_tei1 (nth 1 #xd0$)) ; BG1������ײ�
;;;01/06/28YM@        )
;;;01/06/28YM@      )
;;;01/06/28YM@      (if (/= #BG_tei2 "")
;;;01/06/28YM@        (if (setq #xd0$ (CFGetXData #BG_tei2 "G_BKGD"))
;;;01/06/28YM@          (setq #BG_tei2 (nth 1 #xd0$)) ; BG2������ײ� ��������΂��̂܂�
;;;01/06/28YM@        );_if
;;;01/06/28YM@      );_if
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (setq #BG_pt$ nil #FG1_pt$ nil #FG2_pt$ nil)
;;;01/06/28YM@
;;;01/06/28YM@  (setq #FG_tei1 (nth 51 #xd$))               ; FG1��� *
;;;01/06/28YM@  (setq #FG_tei2 (nth 52 #xd$))               ; F2G��� *
;;;01/06/28YM@  (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))    ; WT�O�`�_��
;;;01/06/28YM@  (if (/= #BG_tei1 "")
;;;01/06/28YM@    (setq #BG_pt$ (GetLWPolyLinePt #BG_tei1))   ; BG1�O�`�_��
;;;01/06/28YM@  )
;;;01/06/28YM@  (if (/= #FG_tei1 "")
;;;01/06/28YM@    (setq #FG1_pt$ (GetLWPolyLinePt #FG_tei1))  ; FG1�O�`�_��
;;;01/06/28YM@  );_if
;;;01/06/28YM@  (if (/= #FG_tei2 "")
;;;01/06/28YM@    (setq #FG2_pt$ (GetLWPolyLinePt #FG_tei2)); FG2�O�`�_��
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  ;// �����̃��[�N�g�b�v���폜
;;;01/06/28YM@  (entdel #wtEn)
;;;01/06/28YM@  (if (/= #FG_tei1 "")(entdel #FG_tei1))
;;;01/06/28YM@  (if (/= #FG_tei2 "")(entdel #FG_tei2))
;;;01/06/28YM@  (if (/= #BG_tei1 "")(entdel #BG_tei1))
;;;01/06/28YM@  (entdel #WT_tei)
;;;01/06/28YM@
;;;01/06/28YM@; BG�د��1�̍폜 1��WT��BG��2����ꍇ�ABG�د��2�͐L�k���Ȃ���������Ȃ�
;;;01/06/28YM@  (if (= #BG_SEP 1) ; �ޯ��ް�ޕ����^
;;;01/06/28YM@    (if (and (/= (nth 49 #xd$) "")
;;;01/06/28YM@             (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID"))
;;;01/06/28YM@      (entdel (nth 49 #xd$)) ; BG�د��1�̍폜
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@;;; ��ʂ��گ�
;;;01/06/28YM@;;;  1                          2                  4  4                       2
;;;01/06/28YM@;;;  +--------------------------+   +--------------+  +-----------------------+
;;;01/06/28YM@;;;  |                          |   |              |  |                       |
;;;01/06/28YM@;;;  |                          |   |              |  |                       |
;;;01/06/28YM@;;;  |       5                  |   |              |  |                       |
;;;01/06/28YM@;;;  |       +------------------+   |       +------+  |                       |
;;;01/06/28YM@;;;  |       |                  1   |       |      3  +-----------------------+
;;;01/06/28YM@;;;  |       |                      |       |         3                       1
;;;01/06/28YM@;;;  |       |                      |       |
;;;01/06/28YM@;;;  +-------+                      |       |
;;;01/06/28YM@;;; 4        3                      |       |
;;;01/06/28YM@;;;                                 |       |
;;;01/06/28YM@;;;                                 |       |
;;;01/06/28YM@;;;                                 +-------+
;;;01/06/28YM@;;;                                2         1
;;;01/06/28YM@;;;
;;;01/06/28YM@
;;;01/06/28YM@;;; ��ʂ��گ�
;;;01/06/28YM@  (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT ����_
;;;01/06/28YM@  (setq #p2 (nth 1 #WT_pt$))
;;;01/06/28YM@
;;;01/06/28YM@  (if (and (equal #ZaiF 1 0.1)(= (nth 3 #xd$) 1))
;;;01/06/28YM@    (progn ; L�`�� 00/09/28 YM
;;;01/06/28YM@      (setq #type0 "SL")
;;;01/06/28YM@      (if (= #x "Left") (setq #pts (last #WT_pt$)))
;;;01/06/28YM@      (if (= #x "Right") (setq #pts #p2))
;;;01/06/28YM@      (if (< (distance #pts #p2) (distance #pts (last #WT_pt$))) ; �L�k����
;;;01/06/28YM@        (progn
;;;01/06/28YM@          (setq #ang (angle #BASEPT #p2))
;;;01/06/28YM@          (setq #base_new #BASEPT)
;;;01/06/28YM@          (setq  #flg "R") ; �E����
;;;01/06/28YM@        )
;;;01/06/28YM@        (progn
;;;01/06/28YM@          (setq #ang (angle #BASEPT (last #WT_pt$)))
;;;01/06/28YM@          (setq #base_new #BASEPT)
;;;01/06/28YM@          (setq #flg "L") ; L ������
;;;01/06/28YM@        )
;;;01/06/28YM@      )
;;;01/06/28YM@    )
;;;01/06/28YM@    (progn ; L�`��ȊO
;;;01/06/28YM@      (setq #type0 nil)
;;;01/06/28YM@      (if (= #x "Left") (setq #pts #BASEPT))
;;;01/06/28YM@      (if (= #x "Right") (setq #pts #p2))
;;;01/06/28YM@      (if (< (distance #pts #p2) (distance #pts #BASEPT)) ; �L�k����
;;;01/06/28YM@        (progn
;;;01/06/28YM@          (setq #ang (angle #BASEPT #p2))
;;;01/06/28YM@          (setq #base_new #BASEPT)
;;;01/06/28YM@          (setq #flg "R") ; �E����
;;;01/06/28YM@        )
;;;01/06/28YM@        (progn
;;;01/06/28YM@          (setq #ang (angle #p2 #BASEPT))
;;;01/06/28YM@          (setq #base_new (polar #BASEPT #ang #iStretch))
;;;01/06/28YM@          (setq #flg "L") ; ������
;;;01/06/28YM@        )
;;;01/06/28YM@      )
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (setq #ret$ (PKSTRETCH_TEI  #flg #type0 #WT_pt$ #BG_pt$ #FG1_pt$ #FG2_pt$ #BASEPT #ang #iStretch))
;;;01/06/28YM@  (setq #WT_pt$  (nth 0 #ret$))
;;;01/06/28YM@  (setq #BG_pt$  (nth 1 #ret$))
;;;01/06/28YM@  (setq #FG1_pt$ (nth 2 #ret$))
;;;01/06/28YM@  (setq #FG2_pt$ (nth 3 #ret$))
;;;01/06/28YM@
;;;01/06/28YM@  (setq #BG_SOLID nil #FG_SOLID1 nil #FG_SOLID2 nil)
;;;01/06/28YM@  (setq #BG0 nil #FG01 nil #FG02 nil)
;;;01/06/28YM@;;; WT�č쐬
;;;01/06/28YM@  (MakeLWPL #WT_pt$ 1)
;;;01/06/28YM@  (setq #WT0 (entlast)) ; �c��
;;;01/06/28YM@  (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #WT0)) (entget #WT0))) ; ������ײ�
;;;01/06/28YM@  (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT0)) (entget #WT0)))
;;;01/06/28YM@  (setq #WT (entlast)) ; �c��
;;;01/06/28YM@  (setq #WT_region (Make_Region2 #WT))
;;;01/06/28YM@  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
;;;01/06/28YM@;;; BG�č쐬
;;;01/06/28YM@  (if #BG_pt$
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (MakeLWPL #BG_pt$ 1)
;;;01/06/28YM@      (setq #BG0 (entlast)) ; �c��
;;;01/06/28YM@      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG0)) (entget #BG0))) ; ������ײ�
;;;01/06/28YM@      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG0)) (entget #BG0)))
;;;01/06/28YM@      (setq #BG (entlast)) ; �c��
;;;01/06/28YM@      (setq #BG_region (Make_Region2 #BG))
;;;01/06/28YM@      (setq #BG_SOLID  (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@;;; FG1�č쐬
;;;01/06/28YM@  (if #FG1_pt$
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (MakeLWPL #FG1_pt$ 1)
;;;01/06/28YM@      (setq #FG01 (entlast)) ; �c��
;;;01/06/28YM@      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG01)) (entget #FG01))) ; ������ײ�
;;;01/06/28YM@      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG01)) (entget #FG01)))
;;;01/06/28YM@      (setq #FG (entlast)) ; �c��
;;;01/06/28YM@      (setq #FG_region (Make_Region2 #FG))
;;;01/06/28YM@      (setq #FG_SOLID1  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@;;; FG2�č쐬
;;;01/06/28YM@  (if #FG2_pt$
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (MakeLWPL #FG2_pt$ 1)
;;;01/06/28YM@      (setq #FG02 (entlast)) ; �c��
;;;01/06/28YM@      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG02)) (entget #FG02))) ; ������ײ�
;;;01/06/28YM@      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG02)) (entget #FG02)))
;;;01/06/28YM@      (setq #FG (entlast)) ; �c��
;;;01/06/28YM@      (setq #FG_region (Make_Region2 #FG))
;;;01/06/28YM@      (setq #FG_SOLID2  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (setq #ss (ssadd))
;;;01/06/28YM@  (ssadd #WT_SOLID #ss)
;;;01/06/28YM@  (if #FG_SOLID1 (ssadd #FG_SOLID1 #ss))
;;;01/06/28YM@  (if #FG_SOLID2 (ssadd #FG_SOLID2 #ss))
;;;01/06/28YM@
;;;01/06/28YM@  (if (= #BG_SEP 1) ; �ޯ��ް�ޕ����^
;;;01/06/28YM@    (progn ; �ޯ��ް�ޕ����^
;;;01/06/28YM@      (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
;;;01/06/28YM@      (if #BG_SOLID
;;;01/06/28YM@        (setq #BG_tei #BG_SOLID)
;;;01/06/28YM@        (setq #BG_tei "")
;;;01/06/28YM@      );_if
;;;01/06/28YM@    )
;;;01/06/28YM@    (progn ; �ޯ��ް�ޕ����^�ȊO
;;;01/06/28YM@      (if #BG_SOLID
;;;01/06/28YM@        (ssadd #BG_SOLID #ss)
;;;01/06/28YM@      );_if
;;;01/06/28YM@      (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
;;;01/06/28YM@      (if #BG0
;;;01/06/28YM@        (setq #BG_tei #BG0)
;;;01/06/28YM@        (setq #BG_tei "")
;;;01/06/28YM@      );_if
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (if #FG01
;;;01/06/28YM@    (setq #FG_tei1 #FG01)
;;;01/06/28YM@    (setq #FG_tei1 "")
;;;01/06/28YM@  );_if
;;;01/06/28YM@  (if #FG02
;;;01/06/28YM@    (setq #FG_tei2 #FG02)
;;;01/06/28YM@    (setq #FG_tei2 "")
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (if (and (= #type0 "SL")(= #flg "L")) ; ���ڽL�^ �̺�ۑ��L�k���s�����ꍇ
;;;01/06/28YM@    (setq #55 (mapcar '+ (nth 55 #xd$) (list 0.0 #iStretch 0.0)));[56]���݂�WT�̉����o������ *** ؽČ`�� ***
;;;01/06/28YM@    (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]���݂�WT�̉����o������ *** ؽČ`�� ***
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (setq #WTLEN1 (nth 0 #55))
;;;01/06/28YM@  (setq #WTLEN2 (nth 1 #55))
;;;01/06/28YM@  (setq #WTLEN3 (nth 2 #55))
;;;01/06/28YM@
;;;01/06/28YM@  (setq #xd_new$
;;;01/06/28YM@  (list
;;;01/06/28YM@    (list 32 #base_new) ; 33.�R�[�i�[���_  WT����_
;;;01/06/28YM@    (list 38 #WT0)      ;[39]WT��ʐ}�`�����
;;;01/06/28YM@    (list 49 #BG_tei)   ;[50]�����^�̏ꍇBG1 SOLID�}�`�����  ����ȊO�͒�ʐ}�`����� @@@ *
;;;01/06/28YM@    (list 51 #FG_tei1)  ;[52]FG1 ��ʐ}�`����� *
;;;01/06/28YM@    (list 52 #FG_tei2)  ;[53]FG2 ��ʐ}�`����� *
;;;01/06/28YM@    (list 55 #55)       ;[56]���݂�WT�̉����o������ *** ؽČ`�� *** 00/05/01 YM
;;;01/06/28YM@  ))
;;;01/06/28YM@
;;;01/06/28YM@  ;// �g���f�[�^�̍Đݒ�
;;;01/06/28YM@  (CFSetXData #WT_SOLID "G_WRKT"
;;;01/06/28YM@    (CFModList #xd$ #xd_new$)
;;;01/06/28YM@  )
;;;01/06/28YM@
;;;01/06/28YM@  (setq #WTL (nth 47 #xd$)) ; ��đ���WT��
;;;01/06/28YM@  (setq #WTR (nth 48 #xd$)) ; ��đ���WT�E
;;;01/06/28YM@
;;;01/06/28YM@  ;// ���葤���[�N�g�b�v�̊g���f�[�^���X�V����
;;;01/06/28YM@  (if (and (/= #WTL "") (/= #WTL nil))
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; ����
;;;01/06/28YM@      (CFSetXData #WTL "G_WRKT"
;;;01/06/28YM@        (CFModList #xdL$
;;;01/06/28YM@          (list
;;;01/06/28YM@            (list 48 #WT_SOLID)     ;[49]�J�b�g����WT����ىE U�^�͍��E�ɂ���
;;;01/06/28YM@          )
;;;01/06/28YM@        )
;;;01/06/28YM@      )
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (if (and (/= #WTR "") (/= #WTR nil))
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; �E��
;;;01/06/28YM@      (CFSetXData #WTR "G_WRKT"
;;;01/06/28YM@        (CFModList
;;;01/06/28YM@          #xdR$
;;;01/06/28YM@          (list
;;;01/06/28YM@            (list 47 #WT_SOLID)     ;[48]�J�b�g����WT����ٍ� U�^�͍��E�ɂ���
;;;01/06/28YM@          )
;;;01/06/28YM@        )
;;;01/06/28YM@      )
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@;;; �g���ް� G_BKGD�̾��
;;;01/06/28YM@;;; 1. �i�Ԗ���
;;;01/06/28YM@;;; 2. BG��ʐ}�`�����
;;;01/06/28YM@;;; 3. �֘AWT�}�`�����
;;;01/06/28YM@  (if (= #BG_SEP 1) ; �ޯ��ް�ޕ����^
;;;01/06/28YM@    (progn
;;;01/06/28YM@      (if #BG_SOLID
;;;01/06/28YM@        (progn
;;;01/06/28YM@          (PKSetBGXData
;;;01/06/28YM@            (list #BG_SOLID (nth 50 #xd$)) ; BG�}�`��ؽ� (list #BG_SOLID1 #BG_SOLID2)
;;;01/06/28YM@            #cutL         ; WT��č�
;;;01/06/28YM@            #cutR         ; WT��ĉE
;;;01/06/28YM@            (nth 2 #xd$)  ; �ގ��L��
;;;01/06/28YM@            (list #BG0 #BG_tei2) ; BG��ʐ}�`�� (list #BG01 #BG02)
;;;01/06/28YM@            #WT_SOLID   ; �֘AWT�}�`��
;;;01/06/28YM@            #D150BG ; D150BG
;;;01/06/28YM@          )
;;;01/06/28YM@        )
;;;01/06/28YM@      );_if
;;;01/06/28YM@    )
;;;01/06/28YM@  );_if
;;;01/06/28YM@
;;;01/06/28YM@  (CFCmdDefFinish);00/09/26 SN ADD
;;;01/06/28YM@  (setvar "pdmode" #PD) ; 06/12 YM
;;;01/06/28YM@  (if #KAIJO
;;;01/06/28YM@    (princ "\n�i�Ԋm�肪��������܂����B")
;;;01/06/28YM@  );_if
;;;01/06/28YM@  (princ)
;;;01/06/28YM@
;;;01/06/28YM@  ); 01/06/28 YM ADD ����ނ̐��� Lipple
;;;01/06/28YM@);_if
;;;01/06/28YM@
;;;01/06/28YM@);C:StretchWkTop

;<HOM>*************************************************************************
; <�֐���>    : C:StretchWkTop
; <�����T�v>  : ���[�N�g�b�v�Ԍ��L�k
; <�߂�l>    :
; <�쐬>      : 1999-10-21 �V�^WT�Ή� 2000.4.13 YM
; <���l>      : ��ʂ�stretch����(�V�����ް�ޮ�)
;*************************************************************************>MOH<
(defun C:StretchWkTop (
  /
  #55 #ANG #BASEPT #BASE_NEW #BG #BG0 #BG_H #BG_REGION #BG_SEP #BG_SOLID
  #BG_T #BG_TEI #BG_TEI1 #BG_TEI2 #CL #CR #CUTL #CUTR #CUTTYPE #D150BG #DEP
  #FG #FG01 #FG02 #FG_H #FG_REGION #FG_S #FG_SOLID1 #FG_SOLID2 #FG_T #FG_TEI1 #FG_TEI2
  #FLG #GRIDMODE #ISTRETCH #KAIJO #LOOP #ORTHOMODE #OSMODE #P1 #P2 #P3 #P4 #P5 #P6
  #PD #PTE #PTS #SNAPMODE #SS #SSTRETCH #TYPE0 #UF #WT #WT0 #WTEN #WTL #WTLEN1 #WTLEN2 #WTLEN3
  #WTR #WT_H #WT_LEN$ #WT_PT$ #WT_REGION #WT_SOLID #WT_T #WT_TEI #X
  #XD$ #XD0$ #XDL$ #XDR$ #XD_NEW$ #YESNOMSG #ZAICODE #ZAIF
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:StretchWkTop ////")
  (CFOutStateLog 1 1 " ")
  (setq #KAIJO nil)  ; �i�Ԋm������׸�

  ;// �R�}���h�̏�����
  (StartUndoErr)

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

; 01/06/28 YM ADD ����ނ̐��� Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)

  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM

  ;// ���[�N�g�b�v�̎w��
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\n���[�N�g�b�v��I��: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
    ;else
      (cond
        ; 02/08/29 YM ADD-S R�t�V�͊Ԍ��L�k�s��
        ((= 1 (nth 33 #xd$))
          (CFAlertMsg "���̃��[�N�g�b�v�͊Ԍ��L�k�ł��܂���B")
          (*error*)
        )
        ; 02/08/29 YM ADD-E
        ((CFGetXData #wtEn "G_WTSET")
          (setq #YesNoMsg "���[�N�g�b�v�͕i�Ԋm�肳��Ă��܂��B\n�����𑱂��܂����H")
          (if (CFYesNoDialog #YesNoMsg)
            (progn
              (setq #loop nil) ; YES �Ȃ�p��
              (setq #KAIJO T)  ; �i�Ԋm������׸�
            )
            (*error*)        ; NO  �Ȃ�STOP
          );_if
        )
        (T
          (setq #loop nil)
        )
      );_cond
    );_if

  );while

  (PCW_ChColWT #wtEn "MAGENTA" nil) ; �F��ς���

  (setq #CutType (nth 7 #xd$))         ; �������
;;; ��ċL��
  (setq #CL (substr #CutType 1 1))
  (setq #CR (substr #CutType 2 1))

  ; �޲��ݽ�\��
  (cond
    ((and (= #CL "0") (= #CR "0")) ; �X�e��L�^ or I�^
      (initget 1 "Left Right")
;;;      (initget 1)
;;;      (setq #pts (getpoint "\n�L�k�����w��: "))
      (setq #x (getkword "\n�L�k�����w�� /L=��/R=�E/:  "))
    )
    ((and (/= #CL "0") (/= #CR "0"))
      (CFAlertMsg "���̃��[�N�g�b�v�͐L�k�ł��܂���B")(quit)
    )
    ((and (= #CL "0") (/= #CR "0"))
      (setq #x "Left")
    )
    ((and (/= #CL "0") (= #CR "0"))
      (setq #x "Right")
    )
  );_cond

  (setq #iStretch (getdist "\n�L�k��: "))
  (if (= #iStretch nil) (setq #iStretch 0))
  (cond
    ((= #x "Left")
      ; 01/08/29 YM ADD-S
      (if (< #iStretch 0)
        (setq #sStretch (strcat "@"  (rtos (abs #iStretch)) ",0")) ; ���̂Ƃ�
        (setq #sStretch (strcat "@-" (rtos (abs #iStretch)) ",0")) ; ���̂Ƃ�
      );_if
      ; 01/08/29 YM ADD-E
;;;01/08/29YM@DEL     (setq #sStretch (strcat "@-" (rtos #iStretch) ",0"))
    )
    ((= #x "Right")
      (setq #sStretch (strcat "@" (rtos #iStretch) ",0"))
    )
  );_cond

  (PCW_ChColWT #wtEn "BYLAYER" nil)

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart) ; 00/02/07@YM@

  (setq #ZaiCode (nth 2 #xd$))
  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ

  (setq #WT_H (nth  8 #xd$))  ; WT����
  (setq #WT_T (nth 10 #xd$))  ; WT����
  (setq #BG_H (nth 12 #xd$))  ; BG����
  (if (equal #BG_H 150 0.1)
    (setq #D150BG T)
  );_if

  (setq #BG_T (nth 13 #xd$))  ; BG����
  (setq #FG_H (nth 15 #xd$))  ; FG����
  (setq #FG_T (nth 16 #xd$))  ; FG����
  (setq #FG_S (nth 17 #xd$))  ; FG��ė�
;-- 2011/09/01 A.Satoh Mod - S
;  (setq #cutL (nth 36 #xd$))  ; �J�b�g��
;  (setq #cutR (nth 37 #xd$))  ; �J�b�g�E
  (setq #cutL "")  ; �J�b�g��
  (setq #cutR "")  ; �J�b�g�E
;-- 2011/09/01 A.Satoh Mod - S
  (setq #WT_LEN$  (nth 55 #xd$)) ; WT����
  (setq #dep (car (nth 57 #xd$))); WT���s��
  ; �e��ʎ擾
  (setq #WT_tei (nth 38 #xd$))   ; WT��ʐ}�`�����
  (setq #BASEPT (nth 32 #xd$))   ; WT����_
  (setq #BG_tei1 (nth 49 #xd$))  ; BG SOLID1 or ���1
  (setq #BG_tei2 (nth 50 #xd$))  ; BG SOLID2 or ���2 ��������΂��̂܂�

  (if (and (/= #BG_tei1 "")
           (= (cdr (assoc 0 (entget #BG_tei1))) "3DSOLID")) ; �ޯ��ް�ޕ����^ 00/09/29 YM MOD
    (progn
      (setq #BG_SEP 1) ; �����^
      (if (setq #xd0$ (CFGetXData #BG_tei1 "G_BKGD"))
        (setq #BG_tei1 (nth 1 #xd0$)) ; BG1������ײ�
      )
      (if (/= #BG_tei2 "")
        (if (setq #xd0$ (CFGetXData #BG_tei2 "G_BKGD"))
          (setq #BG_tei2 (nth 1 #xd0$)) ; BG2������ײ� ��������΂��̂܂�
        );_if
      );_if
    )
  );_if

  (setq #FG_tei1 (nth 51 #xd$))               ; FG1��� *
  (setq #FG_tei2 (nth 52 #xd$))               ; F2G��� *

;;; ; �e��ʓ_��擾
;;; (setq #BG_pt$ nil #FG1_pt$ nil #FG2_pt$ nil)
  (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))    ; WT�O�`�_��
;;;  (if (/= #BG_tei1 "")
;;;   (setq #BG_pt$ (GetLWPolyLinePt #BG_tei1)) ; BG1�O�`�_��
;;; )
;;;  (if (/= #FG_tei1 "")
;;;   (setq #FG1_pt$ (GetLWPolyLinePt #FG_tei1)); FG1�O�`�_��
;;; );_if
;;;  (if (/= #FG_tei2 "")
;;;   (setq #FG2_pt$ (GetLWPolyLinePt #FG_tei2)); FG2�O�`�_��
;;; );_if

  ;// �����̃��[�N�g�b�v(�O���ꍞ��3DSOLID)���폜
  (entdel #wtEn)
;;;  (if (/= #FG_tei1 "")(entdel #FG_tei1))
;;;  (if (/= #FG_tei2 "")(entdel #FG_tei2))
;;;  (if (/= #BG_tei1 "")(entdel #BG_tei1))
;;;  (entdel #WT_tei)

; BG�د��1�̍폜 1��WT��BG��2����ꍇ�ABG�د��2�͐L�k���Ȃ���������Ȃ�
  (if (= #BG_SEP 1) ; �ޯ��ް�ޕ����^
    (if (and (/= (nth 49 #xd$) "")
             (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID"))
      (entdel (nth 49 #xd$)) ; BG�د��1�̍폜
    )
  );_if

;;; ��ʂ��گ�
;;;  1                          2                  4  4                       2
;;;  +--------------------------+   +--------------+  +-----------------------+
;;;  |                          |   |              |  |                       |
;;;  |                          |   |              |  |                       |
;;;  |       5                  |   |              |  |                       |
;;;  |       +------------------+   |       +------+  |                       |
;;;  |       |                  1   |       |      3  +-----------------------+
;;;  |       |                      |       |         3                       1
;;;  |       |                      |       |
;;;  +-------+                      |       |
;;; 4        3                      |       |
;;;                                 |       |
;;;                                 |       |
;;;                                 +-------+
;;;                                2         1
;;;

;;; ��ʂ��گ�

  (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT ����_���玞�v����ɕ��ёւ���

  ; ucs�ύX����ޭ���^�ォ��ɂ���
  (setq #uf (getvar "UCSFOLLOW"))
  (setvar "UCSFOLLOW"  1)
  ; WT��ʉ�w�ذ�މ���
  (command "_layer" "T" SKW_AUTO_SECTION "")

  ;// �r���[��o�^
  (command "_view" "S" "TEMP_MG")

;-- 2011/09/01 A.Satoh Mod - S
;  (if (and (not (equal (KPGetSinaType) -1 0.1))
;;;;          (equal #ZaiF 1 0.1) ;2010/01/08 YM DEL
;           (= (nth 3 #xd$) 1)(= (length #WT_pt$) 6))
;    (progn ; L�`�� 00/09/28 YM
;      (setq #type0 "SL")
;      (setq #p1 (nth 0 #WT_pt$))
;      (setq #p2 (nth 1 #WT_pt$))
;      (setq #p3 (nth 2 #WT_pt$))
;      (setq #p4 (nth 3 #WT_pt$))
;      (setq #p5 (nth 4 #WT_pt$))
;      (setq #p6 (nth 5 #WT_pt$))
;      (if (= #x "Left")
;        (progn
;          (setq #base_new #BASEPT)
;          (setq #flg "L") ; L ������
;          (setq #pts (polar #p6 (angle #p6 #p1) CG_SELECT_WID)) ; ���I��_1
;          (setq #pte #p5) ; ���I��_2
;          ;;; UCS
;          (command "._ucs" "3" #p6 #p1 (polar #p6 (angle #p2 #p1) 1000))
;        )
;      );_if
;      (if (= #x "Right")
;        (progn
;          (setq #base_new #BASEPT)
;          (setq  #flg "R") ; �E����
;          (setq #pts #p2) ; ���I��_1
;          (setq #pte (polar #p3 (angle #p2 #p1) CG_SELECT_WID)) ; ���I��_2
;          ;;; UCS
;          (command "._ucs" "3" #p1 #p2 (polar #p1 (angle #p6 #p1) 1000))
;        )
;      );_if
;    )
;    (progn ; L�`��ȊO
;      (setq #p1 (nth 0 #WT_pt$))
;      (setq #p2 (nth 1 #WT_pt$))
;      (setq #p3 (nth 2 #WT_pt$))
;
;      (setq #type0 nil)
;      (if (= #x "Left")
;        (progn
;          (setq #ang (angle #p2 #BASEPT))
;          (setq #base_new (polar #BASEPT #ang #iStretch))
;          (setq #flg "L") ; ������
;          (setq #pts (polar #p1 (angle #p1 #p2) CG_SELECT_WID)) ; ���I��_1
;          (setq #pte (last #WT_pt$))                 ; ���I��_2
;        )
;      );_if
;      (if (= #x "Right")
;        (progn
;          (setq #base_new #BASEPT)
;          (setq #flg "R") ; �E����
;          (setq #pts #p2) ; ���I��_1
;          (setq #pte (polar #p3 (angle #p2 #p1) CG_SELECT_WID)) ; ���I��_2
;        )
;      );_if
;      ;;; UCS
;      (command "._ucs" "3" #p1 #p2 (polar #p1 (+ (angle #p1 #p2) (dtr 90)) 1000))
;    )
;  );_if
  (cond
    ((and (not (equal (KPGetSinaType) -1 0.1))
           (= (nth 3 #xd$) 1)(= (length #WT_pt$) 6))    ; L�^
      (setq #type0 "SL")
      (setq #p1 (nth 0 #WT_pt$))
      (setq #p2 (nth 1 #WT_pt$))
      (setq #p3 (nth 2 #WT_pt$))
      (setq #p4 (nth 3 #WT_pt$))
      (setq #p5 (nth 4 #WT_pt$))
      (setq #p6 (nth 5 #WT_pt$))
      (if (= #x "Left")
        (progn
          (setq #base_new #BASEPT)
          (setq #flg "L") ; L ������
          (setq #pts (polar #p6 (angle #p6 #p1) CG_SELECT_WID)) ; ���I��_1
          (setq #pte #p5) ; ���I��_2
          ;;; UCS
          (command "._ucs" "3" #p6 #p1 (polar #p6 (angle #p2 #p1) 1000))
        )
      );_if
      (if (= #x "Right")
        (progn
          (setq #base_new #BASEPT)
          (setq  #flg "R") ; �E����
          (setq #pts #p2) ; ���I��_1
          (setq #pte (polar #p3 (angle #p2 #p1) CG_SELECT_WID)) ; ���I��_2
          ;;; UCS
          (command "._ucs" "3" #p1 #p2 (polar #p1 (angle #p6 #p1) 1000))
        )
      );_if
    )
    ((and (not (equal (KPGetSinaType) -1 0.1))
           (= (nth 3 #xd$) 2)(= (length #WT_pt$) 8))    ; U�^
      (setq #type0 "SL")
      (setq #p1 (nth 0 #WT_pt$))
      (setq #p2 (nth 1 #WT_pt$))
      (setq #p3 (nth 2 #WT_pt$))
      (setq #p4 (nth 3 #WT_pt$))
      (setq #p5 (nth 4 #WT_pt$))
      (setq #p6 (nth 5 #WT_pt$))
      (setq #p7 (nth 6 #WT_pt$))
      (setq #p8 (nth 7 #WT_pt$))
      (if (= #x "Left")
        (progn
          (setq #base_new #BASEPT)
          (setq #flg "L") ; L ������
          (setq #pts (polar #p7 (angle #p7 #p8) CG_SELECT_WID)) ; ���I��_1
          (setq #pte #p6) ; ���I��_2
          ;;; UCS
          (command "._ucs" "3" #p7 #p8 (polar #p7 (angle #p8 #p1) 1000))
        )
      );_if
      (if (= #x "Right")
        (progn
          (setq #base_new #BASEPT)
          (setq  #flg "R") ; �E����
          (setq #pts #p2) ; ���I��_1
          (setq #pte (polar #p3 (angle #p2 #p1) CG_SELECT_WID)) ; ���I��_2
          ;;; UCS
          (command "._ucs" "3" #p1 #p2 (polar #p1 (angle #p8 #p1) 1000))
        )
      );_if
    )
    (T  ; ��L�ȊO(�h�`��j
      (setq #p1 (nth 0 #WT_pt$))
      (setq #p2 (nth 1 #WT_pt$))
      (setq #p3 (nth 2 #WT_pt$))

      (setq #type0 nil)
      (if (= #x "Left")
        (progn
          (setq #ang (angle #p2 #BASEPT))
          (setq #base_new (polar #BASEPT #ang #iStretch))
          (setq #flg "L") ; ������
          (setq #pts (polar #p1 (angle #p1 #p2) CG_SELECT_WID)) ; ���I��_1
          (setq #pte (last #WT_pt$))                 ; ���I��_2
        )
      );_if
      (if (= #x "Right")
        (progn
          (setq #base_new #BASEPT)
          (setq #flg "R") ; �E����
          (setq #pts #p2) ; ���I��_1
          (setq #pte (polar #p3 (angle #p2 #p1) CG_SELECT_WID)) ; ���I��_2
        )
      );_if
      ;;; UCS
      (command "._ucs" "3" #p1 #p2 (polar #p1 (+ (angle #p1 #p2) (dtr 90)) 1000))
    )
  )
;-- 2011/09/01 A.Satoh Mod - E

  ;; �X�g���b�`���s
  ; 02/04/17 YM MOD-S �ݸ��,�������͂̂���
  (command
    "_.stretch"
      (ssget "C"
        (trans #pts 0 1)
        (trans #pte 0 1)
        (list
          (cons 8 SKW_AUTO_SECTION)
          (cons -4 "<NOT")
            (list -3 '("G_HOLE"))
          (cons -4 "NOT>")

          (cons -4 "<NOT")
            (list -3 '("G_WTR"))
          (cons -4 "NOT>")
        )
      )
    ""    ; �I���m��
    (trans #pts 0 1)  ; �L�k�J�n�_
    #sStretch    ; �L�k��
  )
  ; 02/04/17 YM MOD-E

  ; 02/04/17 YM DEL-S
;;;  (command
;;;    "_.stretch"
;;;     (ssget "C"
;;;       (trans #pts 0 1)
;;;       (trans #pte 0 1)
;;;       (list (cons 8 SKW_AUTO_SECTION)) ; WT��ʂ̉�w
;;;     )
;;;    ""    ; �I���m��
;;;    (trans #pts 0 1)  ; �L�k�J�n�_
;;;    #sStretch    ; �L�k��
;;;  )
  ; 02/04/17 YM DEL-E

;;;  ;; UCS �߂�
  (command "_.UCS" "P") ; ���O�ɖ߂�
;;; (command "zoom" "p") ; ���_��߂�
  (setvar "UCSFOLLOW"  #uf) ; �V�X�e���ϐ���߂�

;;;  #WT_tei  ; WT��ʐ}�`�����
;;;  #BG_tei1 ; BG SOLID1 or ���1
;;;  #BG_tei2 ; BG SOLID2 or ���2 ��������΂��̂܂�
;;;  #FG_tei1 ; FG1��� *
;;;  #FG_tei2 ; F2G��� *

  (setq #BG_SOLID nil #FG_SOLID1 nil #FG_SOLID2 nil)
  (setq #BG0 nil #FG01 nil #FG02 nil)

;;; (setq #delobj (getvar "delobj")) ; extrude��̒�ʂ�ێ�����"delobj"=0
;;; (setvar "delobj" 0) ; extrude��̒�ʂ�ێ�����"delobj"=0

;;; WT�č쐬
  (setq #WT0 #WT_tei) ; �c��
  (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #WT0)) (entget #WT0))) ; ������ײ�
  (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT0)) (entget #WT0)))
  (setq #WT (entlast)) ; �c��
  (setq #WT_region (Make_Region2 #WT))
  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
;;; BG�č쐬
  (if (and #BG_tei1 (/= #BG_tei1 ""))
    (progn
      (setq #BG0 #BG_tei1) ; �c��
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG0)) (entget #BG0))) ; ������ײ�
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG0)) (entget #BG0)))
      (setq #BG (entlast)) ; �c��
      (setq #BG_region (Make_Region2 #BG))
      (setq #BG_SOLID  (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
    )
  );_if
;;; FG1�č쐬
  (if (and #FG_tei1 (/= #FG_tei1 ""))
    (progn
      (setq #FG01 #FG_tei1) ; �c��
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG01)) (entget #FG01))) ; ������ײ�
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG01)) (entget #FG01)))
      (setq #FG (entlast)) ; �c��
      (setq #FG_region (Make_Region2 #FG))
      (setq #FG_SOLID1  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if
;;; FG2�č쐬
  (if (and #FG_tei2 (/= #FG_tei2 ""))
    (progn
      (setq #FG02 #FG_tei2) ; �c��
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG02)) (entget #FG02))) ; ������ײ�
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG02)) (entget #FG02)))
      (setq #FG (entlast)) ; �c��
      (setq #FG_region (Make_Region2 #FG))
      (setq #FG_SOLID2  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if

;;; (setvar "delobj" #delobj) ; �V�X�e���ϐ���߂�

  (setq #ss (ssadd))
  (ssadd #WT_SOLID #ss)
  (if #FG_SOLID1 (ssadd #FG_SOLID1 #ss))
  (if #FG_SOLID2 (ssadd #FG_SOLID2 #ss))

  (if (= #BG_SEP 1) ; �ޯ��ް�ޕ����^
    (progn ; �ޯ��ް�ޕ����^
      (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
      (if #BG_SOLID
        (setq #BG_tei #BG_SOLID)
        (setq #BG_tei "")
      );_if
    )
    (progn ; �ޯ��ް�ޕ����^�ȊO
      (if #BG_SOLID
        (ssadd #BG_SOLID #ss)
      );_if
      (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
      (if #BG0
        (setq #BG_tei #BG0)
        (setq #BG_tei "")
      );_if
    )
  );_if

  (if #FG01
    (setq #FG_tei1 #FG01)
    (setq #FG_tei1 "")
  );_if
  (if #FG02
    (setq #FG_tei2 #FG02)
    (setq #FG_tei2 "")
  );_if

  (if (and (= #type0 "SL")(= #flg "L")) ; ���ڽL�^ �̺�ۑ��L�k���s�����ꍇ
    (setq #55 (mapcar '+ (nth 55 #xd$) (list 0.0 #iStretch 0.0)));[56]���݂�WT�̉����o������ *** ؽČ`�� ***
    (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]���݂�WT�̉����o������ *** ؽČ`�� ***
  );_if

  (setq #WTLEN1 (nth 0 #55))
  (setq #WTLEN2 (nth 1 #55))
  (setq #WTLEN3 (nth 2 #55))

  (setq #xd_new$
  (list
    (list 32 #base_new) ; 33.�R�[�i�[���_  WT����_
;;;    (list 38 #WT0)      ;[39]WT��ʐ}�`�����
;;;    (list 49 #BG_tei)   ;[50]�����^�̏ꍇBG1 SOLID�}�`�����  ����ȊO�͒�ʐ}�`����� @@@ *
;;;    (list 51 #FG_tei1)  ;[52]FG1 ��ʐ}�`����� *
;;;    (list 52 #FG_tei2)  ;[53]FG2 ��ʐ}�`����� *
    (list 55 #55)       ;[56]���݂�WT�̉����o������ *** ؽČ`�� *** 00/05/01 YM
;-- 2011/09/01 A.Satoh Add - S
    (list 58 "TOKU")
;-- 2011/09/01 A.Satoh Add - E
  ))

  ;// �g���f�[�^�̍Đݒ�
  (CFSetXData #WT_SOLID "G_WRKT"
    (CFModList #xd$ #xd_new$)
  )

  (setq #WTL (nth 47 #xd$)) ; ��đ���WT��
  (setq #WTR (nth 48 #xd$)) ; ��đ���WT�E

  ;// ���葤���[�N�g�b�v�̊g���f�[�^���X�V����
  (if (and (/= #WTL "") (/= #WTL nil))
    (progn
      (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; ����
      (CFSetXData #WTL "G_WRKT"
        (CFModList #xdL$
          (list
            (list 48 #WT_SOLID)     ;[49]�J�b�g����WT����ىE U�^�͍��E�ɂ���
;-- 2011/09/01 A.Satoh Add - S
            (list 58 "TOKU")
;-- 2011/09/01 A.Satoh Add - E
          )
        )
      )
    )
  );_if

  (if (and (/= #WTR "") (/= #WTR nil))
    (progn
      (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; �E��
      (CFSetXData #WTR "G_WRKT"
        (CFModList
          #xdR$
          (list
            (list 47 #WT_SOLID)     ;[48]�J�b�g����WT����ٍ� U�^�͍��E�ɂ���
;-- 2011/09/01 A.Satoh Add - S
            (list 58 "TOKU")
;-- 2011/09/01 A.Satoh Add - E
          )
        )
      )
    )
  );_if

;;; �g���ް� G_BKGD�̾��
;;; 1. �i�Ԗ���
;;; 2. BG��ʐ}�`�����
;;; 3. �֘AWT�}�`�����
  (if (= #BG_SEP 1) ; �ޯ��ް�ޕ����^
    (progn
      (if #BG_SOLID
        (progn
          (PKSetBGXData
            (list #BG_SOLID (nth 50 #xd$)) ; BG�}�`��ؽ� (list #BG_SOLID1 #BG_SOLID2)
            #cutL         ; WT��č�
            #cutR         ; WT��ĉE
            (nth 2 #xd$)  ; �ގ��L��
            (list #BG0 #BG_tei2) ; BG��ʐ}�`�� (list #BG01 #BG02)
            #WT_SOLID   ; �֘AWT�}�`��
            #D150BG ; D150BG
          )
        )
      );_if
    )
  );_if

  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)
  (setvar "pdmode" #PD) ; 06/12 YM
  (if #KAIJO
    (princ "\n�i�Ԋm�肪��������܂����B")
  );_if

  ; WT��ʉ�w�ذ��
  (command "_layer" "F" SKW_AUTO_SECTION "")


	  ;// �r���[��߂�
	  (command "_view" "R" "TEMP_MG")

  ); 01/06/28 YM ADD ����ނ̐��� Lipple
);_if

  (setq *error* nil)
  (princ)

);C:StretchWkTop

;<HOM>*************************************************************************
; <�֐���>    : KPMakeFGTeimen
; <�����T�v>  : FG��ʍ쐬
; <�߂�l>    : FG��ʐ}�`PLINE
; <�쐬>      : 01/07/10 YM
; <���l>      : R���ޗ���
;*************************************************************************>MOH<
(defun KPMakeFGTeimen (
  &flg
  &WT_pt$  ;WT�O�`�_��
  &arc1    ; �~�ʉE��
  &arc2    ; �~�ʍ���
  &FG_T    ; �O�������
  &rr      ; R(�~�ʂ̔��a)
  /
  #A0 #A1 #A2 #A3 #A4 #A5 #A6 #A7 #ARC11 #ARC11_IN #ARC22 #ARC22_IN
  #CLAYER #FG0 #LAST #LINE1 #LINE1_IN #LINE2 #LINE2_IN #LINE3 #LINE3_IN #LINE4 #LINE5
  #OFPT #P1 #P2 #P3 #P4 #P5 #SSFG
  )
; p1                p2
; +-----------------+arc1
; |                 |
; |    p5           |"Right"����
; +----+            |
;p6      +----------+arc2
;       p4          p3

;      p1                p2
; arc1 +-----------------+
;      |                 |
;      |            p4   |"Left"����
;      |            +----+
; arc2 +----------+      p3
;      p6         p5

  ; ���݉�w�̕ύX
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKW_AUTO_SOLID)

  (setq #p1   (nth 0 &WT_pt$)) ; WT����_
  (setq #p2   (nth 1 &WT_pt$)) ; WT�E��_
  (setq #p3   (nth 2 &WT_pt$))
  (setq #p4   (nth 3 &WT_pt$))
  (setq #p5   (nth 4 &WT_pt$))
  (setq #last (last  &WT_pt$))

  (setq #ssFG (ssadd))
  ; �~�ʕ����쐬
  (entmake (entget &arc1))
  (setq #arc11 (entlast))
  (entmake (entget &arc2))
  (setq #arc22 (entlast))

  (setq #ofPT (mapcar '+ #p1 #p3))
  (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
  (command "_offset" &FG_T #arc11 #ofPT "")
  (setq #arc11_in (entlast))
  (command "_offset" &FG_T #arc22 #ofPT "")
  (setq #arc22_in (entlast))

  (cond
    ((= &flg "Right")
      ; ����J���
      ; a1               a2
      ; +----------------+
      ; +a0--------------+�@<--����ARC11_in,�O��ARC11
      ; |  "Right"         + +a3
      ; |                  | |
      ; |  a7          a8  + +a4
      ; +---+------------+�@<--����ARC22_in,�O��ARC22
      ;     +------------+
      ;    a6            a5

      (setq #a0 (polar #p1 (angle #p2 #p3) &FG_T))
      (setq #a1 #p1)
      (setq #a2 (polar #p2 (angle #p2 #p1) (atof &rr)))
      (setq #a3 (polar #p2 (angle #p2 #p3) (atof &rr)))
      (setq #a4 (polar #p3 (angle #p3 #p2) (atof &rr)))
      (setq #a5 (polar #p3 (angle #p2 #p1) (atof &rr)))
      (setq #a6 #p4)
      (setq #a7 (polar #a6 (angle #p3 #p2) &FG_T))
    )
    ((= &flg "Left")
      ; �E��J���
      ;    a2             a1
      ;    +---------------+
      ;a3  +---------------+a0
      ; ++ "Left"          |
      ; ||                 |
      ; ++            a7   |
      ;a4 +------------+---+a3
      ;   +------------+
      ;   a5          a6

      (setq #a0 (polar #p2   (angle #p2 #p3) &FG_T))
      (setq #a1 #p2)
      (setq #a2 (polar #p1   (angle #p1 #p2) (atof &rr)))
      (setq #a3 (polar #p1   (angle #p2 #p3) (atof &rr)))
      (setq #a4 (polar #last (angle #p3 #p2) (atof &rr)))
      (setq #a5 (polar #last (angle #p1 #p2) (atof &rr)))
;;;     (setq #a6 #p5)
      (setq #a6 #p3);2008/09/27 YM MOD
      (setq #a7 (polar #a6   (angle #p3 #p2) &FG_T))
    )
  );_cond

  (command "._line" #a1 #a2 "")
  (setq #line1 (entlast))
  (command "_offset" &FG_T #line1 #ofPT "")
  (setq #line1_in (entlast))

  (command "._line" #a3 #a4 "")
  (setq #line2 (entlast))
  (command "_offset" &FG_T #line2 #ofPT "")
  (setq #line2_in (entlast))

  (command "._line" #a5 #a6 "")
  (setq #line3 (entlast))
  (command "_offset" &FG_T #line3 #ofPT "")
  (setq #line3_in (entlast))

  (command "._line" #a6 #a7 "")
  (setq #line4 (entlast))

  (command "._line" #a1 #a0 "")
  (setq #line5 (entlast))

  (ssadd #arc11 #ssFG)
  (ssadd #arc22 #ssFG)
  (ssadd #arc11_in #ssFG)
  (ssadd #arc22_in #ssFG)

  (ssadd #line1 #ssFG)
  (ssadd #line1_in #ssFG)
  (ssadd #line2 #ssFG)
  (ssadd #line2_in #ssFG)
  (ssadd #line3 #ssFG)
  (ssadd #line3_in #ssFG)
  (ssadd #line4 #ssFG)
  (ssadd #line5 #ssFG)

  (command "_pedit" #arc11 "Y" "J" #ssFG "" "X") ; "X" ���ײ݂̑I�����I��
  (setq #FG0 (entlast))

  ; ���݉�w��߂�
  (setvar "CLAYER" #clayer)

  #FG0
);KPMakeFGTeimen

;<HOM>*************************************************************************
; <�֐���>    : KPMakeFGTeimen_L2
; <�����T�v>  : FG��ʍ쐬
; <�߂�l>    : FG��ʐ}�`PLINE
; <�쐬>      : 01/07/10 YM
; <�C��>        01/08/02 YM MOD
;               1:����,2:����,3:�E����R���މ\�ɂ���(���G�ɂȂ���)
;               "Left" �����̂�R���ނ̹��
;*************************************************************************>MOH<
(defun KPMakeFGTeimen_L2 (
  &WT_pt$  ;WT�O�`�_��
  &arc1    ; �~�ʍ���
  &FG_T    ; �O�������
  &rr      ; R(�~�ʂ̔��a)
  /
  #A0 #A1 #A2 #A3 #A3_IN #A4 #A4_IN #A5 #A6 #A7 #ARC11 #ARC11_IN #CLAYER #FG0
  #LAST #LINE1 #LINE1_IN #LINE2 #LINE2_IN #LINE3 #LINE3_IN #LINE4 #LINE5 #OFPT
  #P1 #P2 #P3 #P4 #P5 #P6 #SSFG
  )
; p1                p2
; +-----------------+arc1
; |                 |
; |    p5           |"Right"����
; +----+            |
;p6      +----------+arc2
;       p4          p3

;      p1                p2
; arc1 +-----------------+
;      |                 |
;      |            p4   |"Left"����
;      |            +----+
; arc2 +----------+      p3
;      p6         p5

  ; ���݉�w�̕ύX
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKW_AUTO_SOLID)

  (setq #p1   (nth 0 &WT_pt$)) ; WT����_
  (setq #p2   (nth 1 &WT_pt$)) ; WT�E��_
  (setq #p3   (nth 2 &WT_pt$))
  (setq #p4   (nth 3 &WT_pt$))
  (setq #p5   (nth 4 &WT_pt$))
  (setq #last (last  &WT_pt$))

  (setq #ssFG (ssadd))
  ; �~�ʕ����쐬
  (entmake (entget &arc1))
  (setq #arc11 (entlast))
;;; (entmake (entget &arc2))
;;; (setq #arc22 (entlast))

  (setq #ofPT (mapcar '+ #p1 #p3))
  (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))

  (command "_offset" &FG_T #arc11 #ofPT "")
  (setq #arc11_in (entlast))
;;; (command "_offset" &FG_T #arc22 #ofPT "")
;;; (setq #arc22_in (entlast))

  ; �E��J���
  ;    a2             a1
  ;    +---------------+
  ;a3  +---------------+a0
  ; ++ "Left"          |
  ; ||                 |
  ; ++            a7   |
  ;a4 +------------+---+a3
  ;   +------------+
  ;   a5          a6

  (setq #a0 (polar #p2   (angle #p2 #p3) &FG_T))
  (setq #a1 #p2)
  (setq #a2 (polar #p1   (angle #p1 #p2) (atof &rr)))
  (setq #a3 (polar #p1   (angle #p2 #p3) (atof &rr)))
;;; (setq #a4 (polar #last (angle #p3 #p2) (atof &rr)))
  (setq #a4 #last)
;;; (setq #a5 (polar #last (angle #p1 #p2) (atof &rr)))
  (setq #a5 #last)
  (setq #a6 #p5)
  (setq #a7 (polar #a6   (angle #p3 #p2) &FG_T))

  (command "._line" #a1 #a2 "")
  (setq #line1 (entlast))
  (command "_offset" &FG_T #line1 #ofPT "")
  (setq #line1_in (entlast))

  (command "._line" #a3 #a4 "")
  (setq #line2 (entlast))
;;; (command "_offset" &FG_T #line2 #ofPT "")
  (setq #a3_in (polar #a3 (angle #p1 #p2) &FG_T))
  (setq #a4_in (polar #a4 (angle #p1 #p2) &FG_T))
  (setq #a4_in (polar #a4_in (angle #p3 #p2) &FG_T))
  (command "._line" #a3_in #a4_in "")
  (setq #line2_in (entlast))

  (command "._line" #a5 #a6 "")
  (setq #line3 (entlast))
;;; (command "_offset" &FG_T #line3 #ofPT "")
  (command "._line" #a7 #a4_in "")
  (setq #line3_in (entlast))

  (command "._line" #a6 #a7 "")
  (setq #line4 (entlast))

  (command "._line" #a1 #a0 "")
  (setq #line5 (entlast))

  (ssadd #arc11 #ssFG)
;;; (ssadd #arc22 #ssFG)
  (ssadd #arc11_in #ssFG)
;;; (ssadd #arc22_in #ssFG)

  (ssadd #line1 #ssFG)
  (ssadd #line1_in #ssFG)
  (ssadd #line2 #ssFG)
  (ssadd #line2_in #ssFG)
  (ssadd #line3 #ssFG)
  (ssadd #line3_in #ssFG)
  (ssadd #line4 #ssFG)
  (ssadd #line5 #ssFG)

  (command "_pedit" #arc11 "Y" "J" #ssFG "" "X") ; "X" ���ײ݂̑I�����I��
  (setq #FG0 (entlast))

  ; ���݉�w��߂�
  (setvar "CLAYER" #clayer)
  #FG0
);KPMakeFGTeimen_L2

;<HOM>*************************************************************************
; <�֐���>    : KPMakeFGTeimen_L3
; <�����T�v>  : FG��ʍ쐬
; <�߂�l>    : FG��ʐ}�`PLINE
; <�쐬>      : 01/07/10 YM
; <�C��>        01/08/02 YM MOD
;               1:����,2:����,3:�E����R���މ\�ɂ���(���G�ɂȂ���)
;               "Left" �E���̂�R���ނ̹��
;*************************************************************************>MOH<
(defun KPMakeFGTeimen_L3 (
  &WT_pt$  ;WT�O�`�_��
  &arc2    ; �~�ʍ���
  &FG_T    ; �O�������
  &rr      ; R(�~�ʂ̔��a)
  /
  #A0 #A1 #A2 #A2_IN #A3 #A4 #A5 #A6 #A7 #ARC22 #ARC22_IN #CLAYER #FG0
  #LAST #LINE1 #LINE2 #LINE2_IN #LINE3 #LINE3_IN #LINE4 #OFPT #P1 #P2 #P3 #P4 #P5
  #SSFG
  )
; p1                p2
; +-----------------+arc1
; |                 |
; |    p5           |"Right"����
; +----+            |
;p6      +----------+arc2
;       p4          p3

;      p1                p2
; arc1 +-----------------+
;      |                 |
;      |            p4   |"Left"����
;      |            +----+
; arc2 +----------+      p3
;      p6         p5

  ; ���݉�w�̕ύX
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKW_AUTO_SOLID)

  (setq #p1   (nth 0 &WT_pt$)) ; WT����_
  (setq #p2   (nth 1 &WT_pt$)) ; WT�E��_
  (setq #p3   (nth 2 &WT_pt$))
  (setq #p4   (nth 3 &WT_pt$))
  (setq #p5   (nth 4 &WT_pt$))
  (setq #last (last  &WT_pt$))

  (setq #ssFG (ssadd))
  ; �~�ʕ����쐬
;;; (entmake (entget &arc1))
;;; (setq #arc11 (entlast))
  (entmake (entget &arc2))
  (setq #arc22 (entlast))

  (setq #ofPT (mapcar '+ #p1 #p3))
  (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))

;;; (command "_offset" &FG_T #arc11 #ofPT "")
;;; (setq #arc11_in (entlast))
  (command "_offset" &FG_T #arc22 #ofPT "")
  (setq #arc22_in (entlast))

  ; �E��J���
  ;    a2             a1
  ;    +---------------+
  ;a3  +---------------+a0
  ; ++ "Left"          |
  ; ||                 |
  ; ++            a7   |
  ;a4 +------------+---+a3
  ;   +------------+
  ;   a5          a6

  (setq #a0 (polar #p2   (angle #p2 #p3) &FG_T))
  (setq #a1 #p2)
  (setq #a2 #p1)
;;; (setq #a2 (polar #p1   (angle #p1 #p2) (atof &rr)))
  (setq #a3 #p1)
;;; (setq #a3 (polar #p1   (angle #p2 #p3) (atof &rr)))
  (setq #a4 (polar #last (angle #p3 #p2) (atof &rr)))
  (setq #a5 (polar #last (angle #p1 #p2) (atof &rr)))
  (setq #a6 #p5)
  (setq #a7 (polar #a6   (angle #p3 #p2) &FG_T))

  (setq #a2_in (polar #p1 (angle #p1 #p2) &FG_T))
  (command "._line" #a2 #a2_in "")
  (setq #line1 (entlast))
;;; (command "_offset" &FG_T #line1 #ofPT "")
;;; (setq #line1_in (entlast))

  (command "._line" #a3 #a4 "")
  (setq #line2 (entlast))
  (command "_offset" &FG_T #line2 #ofPT "")
;;; (setq #a3_in (polar #a3 (angle #p1 #p2) &FG_T))
;;; (setq #a4_in (polar #a4 (angle #p1 #p2) &FG_T))
;;; (command "._line" #a2_in #a4_in "")
  (setq #line2_in (entlast))

  (command "._line" #a5 #a6 "")
  (setq #line3 (entlast))
  (command "_offset" &FG_T #line3 #ofPT "")
;;; (command "._line" #a7 #a4_in "")
  (setq #line3_in (entlast))

  (command "._line" #a6 #a7 "")
  (setq #line4 (entlast))

;;; (command "._line" #a1 #a0 "")
;;; (setq #line5 (entlast))

;;; (ssadd #arc11 #ssFG)
  (ssadd #arc22 #ssFG)
;;; (ssadd #arc11_in #ssFG)
  (ssadd #arc22_in #ssFG)

  (ssadd #line1 #ssFG)
;;; (ssadd #line1_in #ssFG)
  (ssadd #line2 #ssFG)
  (ssadd #line2_in #ssFG)
  (ssadd #line3 #ssFG)
  (ssadd #line3_in #ssFG)
  (ssadd #line4 #ssFG)
;;; (ssadd #line5 #ssFG)

  (command "_pedit" #arc22 "Y" "J" #ssFG "" "X") ; "X" ���ײ݂̑I�����I��
  (setq #FG0 (entlast))

  ; ���݉�w��߂�
  (setvar "CLAYER" #clayer)
  #FG0
);KPMakeFGTeimen_L3

;<HOM>*************************************************************************
; <�֐���>    : KPMakeFGTeimen_R2
; <�����T�v>  : FG���PLINE�쐬
; <�߂�l>    : FG��ʐ}�`PLINE
; <�쐬>      : 01/07/10 YM
; <���l>      : R���ޗ����O����p
; <�C��>        01/08/02 YM MOD
;               1:����,2:����,3:�E����R���މ\�ɂ���(���G�ɂȂ���)
;               "Right" �����̂�R���ނ̹��
;*************************************************************************>MOH<
(defun KPMakeFGTeimen_R2 (
  &WT_pt$  ;WT�O�`�_��
  &arc2    ; �~�ʍ���
  &FG_T    ; �O�������
  &rr      ; R(�~�ʂ̔��a)
  /
  #A0 #A1 #A2 #A2_IN #A3 #A4 #A4_IN #A5 #A6 #A7 #ARC22 #ARC22_IN #CLAYER #FG0 #LAST
  #LINE1 #LINE1_IN #LINE2 #LINE2_IN #LINE3 #LINE3_IN #LINE4 #LINE5 #OFPT
  #P1 #P2 #P3 #P4 #P5 #SSFG
  )
; p1                p2
; +-----------------+arc1
; |                 |
; |    p5           |"Right"����
; +----+            |
;p6      +----------+arc2
;       p4          p3

;      p1                p2
; arc1 +-----------------+
;      |                 |
;      |            p4   |"Left"����
;      |            +----+
; arc2 +----------+      p3
;      p6         p5

  ; ���݉�w�̕ύX
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKW_AUTO_SOLID)

  (setq #p1   (nth 0 &WT_pt$)) ; WT����_
  (setq #p2   (nth 1 &WT_pt$)) ; WT�E��_
  (setq #p3   (nth 2 &WT_pt$))
  (setq #p4   (nth 3 &WT_pt$))
  (setq #p5   (nth 4 &WT_pt$))
  (setq #last (last  &WT_pt$))

  (setq #ssFG (ssadd))
  ; �~�ʕ����쐬
;;; (entmake (entget &arc1))
;;; (setq #arc11 (entlast))
  (entmake (entget &arc2))
  (setq #arc22 (entlast))

  (setq #ofPT (mapcar '+ #p1 #p3))
  (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
;;; (command "_offset" &FG_T #arc11 #ofPT "")
;;; (setq #arc11_in (entlast))
  (command "_offset" &FG_T #arc22 #ofPT "")
  (setq #arc22_in (entlast))

  ; ����J���
  ; a1               a2
  ; +----------------+
  ; +a0--------------+�@<--����ARC11_in,�O��ARC11
  ; |  "Right"         + +a3
  ; |                  | |
  ; |  a7          a8  + +a4
  ; +---+------------+�@<--����ARC22_in,�O��ARC22
  ;     +------------+
  ;    a6            a5

  (setq #a0 (polar #p1 (angle #p2 #p3) &FG_T))
  (setq #a1 #p1)
  (setq #a2 #p2)
;;;     (setq #a2 (polar #p2 (angle #p2 #p1) (atof &rr)))
  (setq #a3 #p2)
;;;     (setq #a3 (polar #p2 (angle #p2 #p3) (atof &rr)))
  (setq #a4 (polar #p3 (angle #p3 #p2) (atof &rr)))
  (setq #a5 (polar #p3 (angle #p2 #p1) (atof &rr)))
  (setq #a6 #p4)
  (setq #a7 (polar #a6 (angle #p3 #p2) &FG_T))

  (setq #a2_in (polar #p2    (angle #p2 #p1) &FG_T))
  (command "._line" #a2 #a2_in "")
  (setq #line1 (entlast))

;;; (command "._line" #a1 #a2 "")
;;; (setq #line1 (entlast))
;;;
;;; (setq #a2_in (polar #p2    (angle #p2 #p1) &FG_T))
;;; (setq #a2_in (polar #a2_in (angle #p2 #p3) &FG_T))
;;; (command "._line" #a0 #a2_in "")
;;; (setq #line1_in (entlast))

  (command "._line" #a3 #a4 "")
  (setq #line2 (entlast))

  (command "_offset" &FG_T #line2 #ofPT "")
  (setq #line2_in (entlast))

;;; (setq #a4_in (polar #a4    (angle #p2 #p1) &FG_T))
;;; (command "._line" #a2_in #a4_in "")
;;; (setq #line2_in (entlast))

  (command "._line" #a5 #a6 "")
  (setq #line3 (entlast))
  (command "_offset" &FG_T #line3 #ofPT "")
  (setq #line3_in (entlast))

  (command "._line" #a6 #a7 "")
  (setq #line4 (entlast))

  (command "._line" #a1 #a0 "")
  (setq #line5 (entlast))

;;; (ssadd #arc11 #ssFG)
  (ssadd #arc22 #ssFG)
;;; (ssadd #arc11_in #ssFG)
  (ssadd #arc22_in #ssFG)

  (ssadd #line1 #ssFG)
;;; (ssadd #line1_in #ssFG)
  (ssadd #line2 #ssFG)
  (ssadd #line2_in #ssFG)
  (ssadd #line3 #ssFG)
  (ssadd #line3_in #ssFG)
  (ssadd #line4 #ssFG)
  (ssadd #line5 #ssFG)

  (command "_pedit" #arc22 "Y" "J" #ssFG "" "X") ; "X" ���ײ݂̑I�����I��
  (setq #FG0 (entlast))

  ; ���݉�w��߂�
  (setvar "CLAYER" #clayer)
  #FG0
);KPMakeFGTeimen_R2

;<HOM>*************************************************************************
; <�֐���>    : KPMakeFGTeimen_R3
; <�����T�v>  : FG���PLINE�쐬
; <�߂�l>    : FG��ʐ}�`PLINE
; <�쐬>      : 01/07/10 YM
; <���l>      : R���ޗ����O����p
; <�C��>        01/08/02 YM MOD
;               1:����,2:����,3:�E����R���މ\�ɂ���(���G�ɂȂ���)
;               "Right" �E���̂�R���ނ̹��
;*************************************************************************>MOH<
(defun KPMakeFGTeimen_R3 (
  &WT_pt$  ;WT�O�`�_��
  &arc1    ; �~�ʉE��
  &FG_T    ; �O�������
  &rr      ; R(�~�ʂ̔��a)
  /
  #A0 #A1 #A2 #A3 #A3_IN #A4 #A4_IN #A5 #A5_IN #A6 #A7 #ARC11 #ARC11_IN #ARC22
  #CLAYER #FG0 #LAST #LINE1 #LINE1_IN #LINE2 #LINE2_IN #LINE3 #LINE3_IN #LINE4 #LINE5
  #OFPT #P1 #P2 #P3 #P4 #P5 #SSFG
  )
; p1                p2
; +-----------------+arc1
; |                 |
; |    p5           |"Right"����
; +----+            |
;p6      +----------+arc2
;       p4          p3

;      p1                p2
; arc1 +-----------------+
;      |                 |
;      |            p4   |"Left"����
;      |            +----+
; arc2 +----------+      p3
;      p6         p5

  ; ���݉�w�̕ύX
  (setq #clayer (getvar "CLAYER"))
  (setvar "CLAYER" SKW_AUTO_SOLID)

  (setq #p1   (nth 0 &WT_pt$)) ; WT����_
  (setq #p2   (nth 1 &WT_pt$)) ; WT�E��_
  (setq #p3   (nth 2 &WT_pt$))
  (setq #p4   (nth 3 &WT_pt$))
  (setq #p5   (nth 4 &WT_pt$))
  (setq #last (last  &WT_pt$))

  (setq #ssFG (ssadd))
  ; �~�ʕ����쐬
  (entmake (entget &arc1))
  (setq #arc11 (entlast))
;;; (entmake (entget &arc2))
;;; (setq #arc22 (entlast))

  (setq #ofPT (mapcar '+ #p1 #p3))
  (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
  (command "_offset" &FG_T #arc11 #ofPT "")
  (setq #arc11_in (entlast))
;;; (command "_offset" &FG_T #arc22 #ofPT "")
;;; (setq #arc22_in (entlast))

  ; ����J���
  ; a1               a2
  ; +----------------+
  ; +a0--------------+�@<--����ARC11_in,�O��ARC11
  ; |  "Right"         + +a3
  ; |                  | |
  ; |  a7          a8  + +a4
  ; +---+------------+�@<--����ARC22_in,�O��ARC22
  ;     +------------+
  ;    a6            a5

  (setq #a0 (polar #p1 (angle #p2 #p3) &FG_T))
  (setq #a1 #p1)
;;; (setq #a2 #p2)
  (setq #a2 (polar #p2 (angle #p2 #p1) (atof &rr)))
;;; (setq #a3 #p2)
  (setq #a3 (polar #p2 (angle #p2 #p3) (atof &rr)))
  (setq #a4 #p3)
;;; (setq #a4 (polar #p3 (angle #p3 #p2) (atof &rr)))
  (setq #a5 #p3)
;;; (setq #a5 (polar #p3 (angle #p2 #p1) (atof &rr)))
  (setq #a6 #p4)
  (setq #a7 (polar #a6 (angle #p3 #p2) &FG_T))

;;; (setq #a2_in (polar #p2    (angle #p2 #p1) &FG_T))
;;; (command "._line" #a2 #a2_in "")
;;; (setq #line1 (entlast))

  (command "._line" #a1 #a2 "")
  (setq #line1 (entlast))

  (command "_offset" &FG_T #line1 #ofPT "")
  (setq #line1_in (entlast))

;;; (setq #a2_in (polar #p2    (angle #p2 #p1) &FG_T))
;;; (setq #a2_in (polar #a2_in (angle #p2 #p3) &FG_T))
;;; (command "._line" #a0 #a2_in "")
;;; (setq #line1_in (entlast))

  (command "._line" #a3 #a4 "")
  (setq #line2 (entlast))

;;; (command "_offset" &FG_T #line2 #ofPT "")
;;; (setq #line2_in (entlast))

  (setq #a3_in (polar #a3    (angle #p2 #p1) &FG_T))
  (setq #a4_in (polar #a4    (angle #p3 #p2) &FG_T))
  (setq #a4_in (polar #a4_in (angle #p2 #p1) &FG_T))
  (command "._line" #a3_in #a4_in "")
  (setq #line2_in (entlast))

  (command "._line" #a5 #a6 "")
  (setq #line3 (entlast))
;;; (command "_offset" &FG_T #line3 #ofPT "")
;;; (setq #line3_in (entlast))
  (command "._line" #a7 #a4_in "")
  (setq #line3_in (entlast))

  (command "._line" #a6 #a7 "")
  (setq #line4 (entlast))

  (command "._line" #a1 #a0 "")
  (setq #line5 (entlast))

  (ssadd #arc11 #ssFG)
;;; (ssadd #arc22 #ssFG)
  (ssadd #arc11_in #ssFG)
;;; (ssadd #arc22_in #ssFG)

  (ssadd #line1 #ssFG)
  (ssadd #line1_in #ssFG)
  (ssadd #line2 #ssFG)
  (ssadd #line2_in #ssFG)
  (ssadd #line3 #ssFG)
  (ssadd #line3_in #ssFG)
  (ssadd #line4 #ssFG)
  (ssadd #line5 #ssFG)

  (command "_pedit" #arc11 "Y" "J" #ssFG "" "X") ; "X" ���ײ݂̑I�����I��
  (setq #FG0 (entlast))

  ; ���݉�w��߂�
  (setvar "CLAYER" #clayer)
  #FG0
);KPMakeFGTeimen_R3

;<HOM>*************************************************************************
; <�֐���>    : PKSTRETCH_TEI
; <�����T�v>  : ��ʐ}�`��L�k
; <�߂�l>    :
; <�쐬>      : 1999-10-21 �V�^WT�Ή� 2000.4.13 YM
; <���l>      :
;*************************************************************************>MOH<
(defun PKSTRETCH_TEI (
  &flg      ; �L�k���׸�
  &type0    ; ="SL" ���ڽL�^ =nil ����ȊO
  &WTpt$    ; ��ʓ_�� WT
  &BGpt$    ; ��ʓ_�� BG
  &FGpt1$   ; ��ʓ_�� FG1
  &FGpt2$   ; ��ʓ_�� FG2
  &BasePt   ; WT�R�[�i�[��_
  &ang      ; �L�k�����p�x
  &iStretch ; ��گ���
  /
  #BGPT$ #DIST #END #FGPT$ #I #LST$$
  #P11 #P11BG #P1BG #P2 #P22 #P22BG #P22FG #P2BG #P2FG
  #P3 #P33 #P33BG #P33FG #P3BG #P3FG #P44 #P44BG #P4BG
  #PT #PT$ #WTPT$ #FGPT1$ #FGPT2$
  )

  (setq #WTPT$ nil #BGPT$ nil #FGPT1$ nil #FGPT2$ nil)
  (setq #pt$ (GetPtSeries &BasePt &WTpt$)) ; WT ����_
  (setq #p2  (nth 1 #pt$))
  (setq #p3  (nth 2 #pt$))
  (setq #end (last  #pt$))

;;; base               --->�L�k����
;;;  +----------------+p2----*p22
;;;  |                |      |
;;;  |                |      |
;;;  |                |      |
;;;  +----------------+p3----*p33
;;;                ����ް����牓���_
  (if (= &flg "R")
    (progn ; �E���L�k
      ;;; WT ;;;
      (setq #p22 (polar #p2 &ang &iStretch))
      (setq #p33 (polar #p3 &ang &iStretch))
      (setq #WTPT$ '())
      (setq #i 0)
      (repeat (length &WTpt$)
        (setq #pt (nth #i &WTpt$))
        (if (< (distance #pt #p2) 0.1)
          (setq #pt #p22) ; #p1�̕ς���#p22�����ւ���
        )
        (if (< (distance #pt #p3) 0.1)
          (setq #pt #p33) ; #p2�̕ς���#p33�����ւ���
        )
        (setq #WTPT$ (append #WTPT$ (list #pt)))
        (setq #i (1+ #i))
      )
      ;;; BG ;;;
      (if &BGpt$
        (setq #BGPT$ (PK_PtSTRETCHsub &BGpt$ #p2 &ang &iStretch))
      );_if

      ;;; FG ;;;
      (if &FGpt1$
        (setq #FGPT1$ (PK_PtSTRETCHsub  &FGpt1$ #p3 &ang &iStretch)) ; �ʏ�
      );_if

      (if &FGpt2$
        (setq #FGPT2$ (PK_PtSTRETCHsub &FGpt2$ #p2 &ang &iStretch))
      );_if

    )
  );_if

;;;   <---�L�k����                |          |
;;; p11 *----+base------------+   |    L     |
;;;          |                |   |          |
;;;          |                |   +----------+p5
;;;          |                |   |end       |
;;; p44 *----+end-------------+   |          |
;;;                               *          *
;;;                              p11         p44
  (if (= &flg "L")
    (progn ; ���� or L�^�̉����L�k
;;;      (if (and (= &type0 "SL")(= (length #pt$) 6)) ; ���ڽL�^ 01/08/23 YM MOD
      (if (= &type0 "SL") ; ���ڽL�^
        (progn
          (setq #p11 (polar #end &ang &iStretch))
          (setq #p44 (polar (nth 4 #pt$) &ang &iStretch))

          (setq #WTPT$ '() #i 0)
          (repeat (length &WTpt$)
            (setq #pt (nth #i &WTpt$))
            (if (< (distance #pt #end) 0.1)
              (setq #pt #p11)
            )
            (if (< (distance #pt (nth 4 #pt$)) 0.1)
              (setq #pt #p44)
            )
            (setq #WTPT$ (append #WTPT$ (list #pt)))
            (setq #i (1+ #i))
          )
      ;;; BG ;;;
          (if &BGpt$
            (setq #BGPT$ (PK_PtSTRETCHsub &BGpt$ #end &ang &iStretch))
          );_if

      ;;; FG ;;;
          (if &FGpt1$
            (setq #FGPT1$ (PK_PtSTRETCHsub &FGpt1$ (nth 4 #pt$) &ang &iStretch))
          );_if

          (if &FGpt2$
            (setq #FGPT2$ (PK_PtSTRETCHsub &FGpt2$ #end &ang &iStretch))
          );_if

        )
        ;;; else
        (progn            ; ���ڽL�^�ȊO
          (setq #p11 (polar &BasePt &ang &iStretch))
          (setq #p44 (polar #end &ang &iStretch))

          (setq #WTPT$ '())
          (setq #i 0)
          (repeat (length &WTpt$)
            (setq #pt (nth #i &WTpt$))
            (if (< (distance #pt &BasePt) 0.1)
              (setq #pt #p11)
            )
            (if (< (distance #pt #end) 0.1)
              (setq #pt #p44)
            )
            (setq #WTPT$ (append #WTPT$ (list #pt)))
            (setq #i (1+ #i))
          )
      ;;; BG ;;;
          (if &BGpt$
            (setq #BGPT$ (PK_PtSTRETCHsub &BGpt$ &BasePt &ang &iStretch))
          );_if

      ;;; FG ;;;
          (if &FGpt1$
            (setq #FGPT1$ (PK_PtSTRETCHsub &FGpt1$ #end &ang &iStretch))
          );_if

          (if &FGpt2$
            (setq #FGPT2$ (PK_PtSTRETCHsub &FGpt2$ &BasePt &ang &iStretch))
          );_if

        )
      );_if
    )
  );_if

  (list #WTPT$ #BGPT$ #FGPT1$ #FGPT2$)
);PKSTRETCH_TEI

;<HOM>*************************************************************************
; <�֐���>    : PK_PtSTRETCHsub
; <�����T�v>  : BG,FG��ʊO�`�_���L�k
; <�߂�l>    : �L�k��̓_��
; <�쐬>      : 00/06/13 YM
; <���l>      :
;*************************************************************************>MOH<
(defun PK_PtSTRETCHsub (
  &pt$ ; BG or FG �L�k�O�̓_��
  &BP  ; ��_
  &ang
  &iStretch
  /
  #DIST #I #LST$$ #P0 #P00 #P1 #P11 #PT #RETPT$
  )
  ;;; ��_������W�̋߂����Ƀ\�[�g����
  (setq #lst$$ '())
  (foreach #pt &pt$
    (setq #dist (distance &BP #pt))
    (setq #lst$$ (cons (list #pt #dist) #lst$$))
  )
  (setq #lst$$ (CFListSort #lst$$ 1))
  (setq #p0 (car (nth 0 #lst$$)))
  (setq #p1 (car (nth 1 #lst$$)))
  (setq #p00 (polar #p0 &ang &iStretch))
  (setq #p11 (polar #p1 &ang &iStretch))

  ;;; �_�̓���ւ�
  (setq #retPT$ '())
  (setq #i 0)
  (repeat (length &pt$)
    (setq #pt (nth #i &pt$))
    (if (< (distance #pt #p0) 0.1)
      (setq #pt #p00) ; #p0 �̕ς��� #p00 �����ւ���
    )
    (if (< (distance #pt #p1) 0.1)
      (setq #pt #p11) ; #p1 �̕ς��� #p11 �����ւ���
    )
    (setq #retPT$ (append #retPT$ (list #pt)))
    (setq #i (1+ #i))
  )
  #retPT$
);PK_PtSTRETCHsub

;<HOM>*************************************************************************
; <�֐���>    : SubStretchWkTop
; <�����T�v>  : ���[�N�g�b�v�Ԍ��L�k call�p
; <�߂�l>    : �Ԍ��L�k��̃��[�N�g�b�v
; <�쐬>      :  01/03/23 YM
; <���l>      :
;*************************************************************************>MOH<
(defun SubStretchWkTop (
  &wtEn ; WT�}�`��
  &LR   ; �L�k����
  &size ; �L�k����
  /
  #55 #ANG #BASEPT #BASE_NEW #BG #BG0 #BG_H #BG_PT$ #BG_REGION #BG_SEP #BG_SOLID
  #BG_T #BG_TEI #BG_TEI1 #BG_TEI2 #CUTL #CUTR #D150BG #DEP #FG #FG01 #FG02 #FG1_PT$
  #FG2_PT$ #FG_H #FG_REGION #FG_S #FG_SOLID1 #FG_SOLID2 #FG_T #FG_TEI1 #FG_TEI2 #FLG
  #ISTRETCH #P2 #PTS #RET$ #SS #TYPE0 #WT #WT0 #WTEN #WTL #WTLEN1 #WTLEN2 #WTLEN3 #WTR
  #WT_H #WT_LEN$ #WT_PT$ #WT_REGION #WT_SOLID #WT_T #WT_TEI #XD$ #XD0$ #XDL$ #XDR$ #XD_NEW$
  #ZAICODE #ZAIF #WTLR
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// SubStretchWkTop ////")
  (CFOutStateLog 1 1 " ")

  (setq #wtEn &wtEn)
  (setq #xd$ (CFGetXData #wtEn "G_WRKT"))
  ;// �R�}���h�̏�����
;;;  (StartUndoErr)
  (setq #iStretch &size) ; T��ėp

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ��̉���
  (CFNoSnapStart)

  (setq #ZaiCode (nth 2 #xd$))
  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ

  (setq #WT_H (nth  8 #xd$))  ; WT����
  (setq #WT_T (nth 10 #xd$))  ; WT����
  (setq #BG_H (nth 12 #xd$))  ; BG����
  (setq #D150BG nil)

  (setq #BG_T (nth 13 #xd$))  ; BG����
  (setq #FG_H (nth 15 #xd$))  ; FG����
  (setq #FG_T (nth 16 #xd$))  ; FG����
  (setq #FG_S (nth 17 #xd$))  ; FG��ė�
  (setq #WTLR (nth 30 #xd$))  ; WTLR
  (setq #cutL (nth 36 #xd$))  ; �J�b�g�� I,H,X,P,K,L,V,S,Z
  (setq #cutR (nth 37 #xd$))  ; �J�b�g�E
  (setq #WT_LEN$  (nth 55 #xd$))    ; WT����
  (setq #dep (car (nth 57 #xd$)))   ; WT���s��

  (setq #WT_tei (nth 38 #xd$))             ; WT��ʐ}�`�����
  (setq #BASEPT (nth 32 #xd$))             ; WT����_
  (setq #BG_tei1 (nth 49 #xd$))            ; BG SOLID1 or ���1 *
  (setq #BG_tei2 (nth 50 #xd$))            ; BG SOLID2 or ���2 * ��������΂��̂܂�

  (if (= (cdr (assoc 0 (entget #BG_tei1))) "3DSOLID") ; �ޯ��ް�ޕ����^
    (setq #BG_SEP 1) ; �ޯ��ް�ޕ����^�׸� 1:�����^
    (setq #BG_SEP 0) ; �ޯ��ް�ޕ����^�׸� 1:�����^
  );_if

  (if (/= #BG_tei1 "")
    (if (setq #xd0$ (CFGetXData #BG_tei1 "G_BKGD"))
      (setq #BG_tei1 (nth 1 #xd0$)) ; BG1������ײ�
    )
  )
  (if (/= #BG_tei2 "")
    (if (setq #xd0$ (CFGetXData #BG_tei2 "G_BKGD"))
      (setq #BG_tei2 (nth 1 #xd0$)) ; BG2������ײ� ��������΂��̂܂�
    );_if
  );_if

  (setq #BG_pt$ nil #FG1_pt$ nil #FG2_pt$ nil)

  (setq #FG_tei1 (nth 51 #xd$))               ; FG1��� *
  (setq #FG_tei2 (nth 52 #xd$))               ; F2G��� *
  (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))    ; WT�O�`�_��
  (if (/= #BG_tei1 "")
    (setq #BG_pt$ (GetLWPolyLinePt #BG_tei1))   ; BG1�O�`�_��
  )
  (if (/= #FG_tei1 "")
    (setq #FG1_pt$ (GetLWPolyLinePt #FG_tei1))  ; FG1�O�`�_��
  );_if
  (if (/= #FG_tei2 "")
    (setq #FG2_pt$ (GetLWPolyLinePt #FG_tei2)); FG2�O�`�_��
  );_if

  ;// �����̃��[�N�g�b�v���폜
  (entdel #wtEn)
  (if (/= #FG_tei1 "")(entdel #FG_tei1))
  (if (/= #FG_tei2 "")(entdel #FG_tei2))
  (if (/= #BG_tei1 "")(entdel #BG_tei1))
  (entdel #WT_tei)

; BG�د��1�̍폜 1��WT��BG��2����ꍇ�ABG�د��2�͐L�k���Ȃ���������Ȃ�
; �ޯ��ް�ޕ����^
  (if (and (/= (nth 49 #xd$) "")
           (= (cdr (assoc 0 (entget (nth 49 #xd$)))) "3DSOLID"))
    (entdel (nth 49 #xd$)) ; BG�د��1�̍폜
  )

;;; ��ʂ��گ�
;;;  1                          2                  4  4                       2
;;;  +--------------------------+   +--------------+  +-----------------------+
;;;  |                          |   |              |  |                       |
;;;  |                          |   |              |  |                       |
;;;  |       5                  |   |              |  |                       |
;;;  |       +------------------+   |       +------+  |                       |
;;;  |       |                  1   |       |      3  +-----------------------+
;;;  |       |                      |       |         3                       1
;;;  |       |                      |       |
;;;  +-------+                      |       |
;;; 4        3                      |       |
;;;                                 |       |
;;;                                 |       |
;;;                                 +-------+
;;;                                2         1
;;;

;;; ��ʂ��گ�
  (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT ����_
  (setq #p2 (nth 1 #WT_pt$))

  ; 01/08/23 YM MOD-S L�^��ݗ����ڑ��i��WT�̕�������I�`��WT�Ή��̂���
  (if (and (not (equal (KPGetSinaType) -1 0.1))(= (nth 3 #xd$) 1)(= #ZaiF 1)(= (length #WT_pt$) 6))
    (progn ; ���ڽL�`�� 00/09/28 YM
      (setq #type0 "SL")
  ; 01/08/23 YM MOD-E L�^��ݗ����ڑ��i��WT�̕�������I�`��WT�Ή��̂���

;;;01/08/23YM@  (if (and (not (equal (KPGetSinaType) -1 0.1))(= (nth 3 #xd$) 1)(= #ZaiF 1))
;;;01/08/23YM@    (progn ; ���ڽL�`�� 00/09/28 YM
;;;01/08/23YM@      (setq #type0 "SL")

      (if (= &LR "L") (setq #pts (last #WT_pt$)))
      (if (= &LR "R") (setq #pts #p2))

      (if (< (distance #pts #p2) (distance #pts (last #WT_pt$))) ; �L�k����
        (progn
          (setq #ang (angle #BASEPT #p2))
          (setq #base_new #BASEPT)
          (setq  #flg "R") ; �E����
        )
        (progn
          (setq #ang (angle #BASEPT (last #WT_pt$)))
          (setq #base_new #BASEPT)
          (setq #flg "L") ; L ������
        )
      )
    )
    (progn ; L�`��ȊO

      (if (= &LR "L") (setq #pts #BASEPT))
      (if (= &LR "R") (setq #pts #p2))

      (setq #type0 nil)
      (if (< (distance #pts #p2) (distance #pts #BASEPT)) ; �L�k����
        (progn
          (setq #ang (angle #BASEPT #p2))
          (setq #base_new #BASEPT)
          (setq #flg "R") ; �E����
        )
        (progn
          (setq #ang (angle #p2 #BASEPT))
          (setq #base_new (polar #BASEPT #ang #iStretch))
          (setq #flg "L") ; ������
        )
      );_if
    )
  );_if

  (setq #ret$ (PKSTRETCH_TEI #flg #type0 #WT_pt$ #BG_pt$ #FG1_pt$ #FG2_pt$ #BASEPT #ang #iStretch))
  (setq #WT_pt$  (nth 0 #ret$))
  (setq #BG_pt$  (nth 1 #ret$))
  (setq #FG1_pt$ (nth 2 #ret$))
  (setq #FG2_pt$ (nth 3 #ret$))

  (setq #BG_SOLID nil #FG_SOLID1 nil #FG_SOLID2 nil)
  (setq #BG0 nil #FG01 nil #FG02 nil)
;;; WT�č쐬
  (MakeLWPL #WT_pt$ 1)
  (setq #WT0 (entlast)) ; �c��
  (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #WT0)) (entget #WT0))) ; ������ײ�
  (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT0)) (entget #WT0)))
  (setq #WT (entlast)) ; �c��
  (setq #WT_region (Make_Region2 #WT))
  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
;;; BG�č쐬
  (if #BG_pt$
    (progn
      (MakeLWPL #BG_pt$ 1)
      (setq #BG0 (entlast)) ; �c��
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG0)) (entget #BG0))) ; ������ײ�
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG0)) (entget #BG0)))
      (setq #BG (entlast)) ; �c��
      (setq #BG_region (Make_Region2 #BG))
      (setq #BG_SOLID  (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
    )
  );_if
;;; FG1�č쐬
  (if #FG1_pt$
    (progn
      (MakeLWPL #FG1_pt$ 1)
      (setq #FG01 (entlast)) ; �c��
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG01)) (entget #FG01))) ; ������ײ�
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG01)) (entget #FG01)))
      (setq #FG (entlast)) ; �c��
      (setq #FG_region (Make_Region2 #FG))
      (setq #FG_SOLID1  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if
;;; FG2�č쐬
  (if #FG2_pt$
    (progn
      (MakeLWPL #FG2_pt$ 1)
      (setq #FG02 (entlast)) ; �c��
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG02)) (entget #FG02))) ; ������ײ�
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG02)) (entget #FG02)))
      (setq #FG (entlast)) ; �c��
      (setq #FG_region (Make_Region2 #FG))
      (setq #FG_SOLID2  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if

  (setq #ss (ssadd))
  (ssadd #WT_SOLID #ss)
  (if #FG_SOLID1 (ssadd #FG_SOLID1 #ss))
  (if #FG_SOLID2 (ssadd #FG_SOLID2 #ss))

  (if (equal #BG_SEP 0 0.1) ; �����^�ł͂Ȃ�
    (if #BG_SOLID (ssadd #BG_SOLID #ss))
  );_if

  (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
  (if (and (entget #BG_SOLID)
           (= (cdr (assoc 0 (entget #BG_SOLID))) "3DSOLID"))
    (setq #BG_tei #BG_SOLID) ; BG 3DSOLID
    (setq #BG_tei #BG0)      ; BG ���
  );_if

  (if #FG01
    (setq #FG_tei1 #FG01)
    (setq #FG_tei1 "")
  );_if
  (if #FG02
    (setq #FG_tei2 #FG02)
    (setq #FG_tei2 "")
  );_if

  (if (= #WTLR "R") ; �E���� 01/07/06 YM ADD
    (cond
      ((and (= #type0 "SL")(= #flg "L")) ; ���ڽL�^ �̺�ۑ��L�k���s�����ꍇ
        (setq #55 (mapcar '+ (nth 55 #xd$) (list 0.0 #iStretch 0.0)));[56]���݂�WT�̉����o������ *** ؽČ`�� ***
      )
      ((and (= #type0 "SL")(= #flg "R")) ; ���ڽL�^ �̺�ۑ��L�k���s�����ꍇ
        (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]���݂�WT�̉����o������ *** ؽČ`�� ***
      )
      (T
        (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]���݂�WT�̉����o������ *** ؽČ`�� ***
      )
    );_cond
;else ������
    (cond
      ((and (= #type0 "SL")(= #flg "L")) ; ���ڽL�^ �̺�ۑ��L�k���s�����ꍇ
        (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]���݂�WT�̉����o������ *** ؽČ`�� ***
      )
      ((and (= #type0 "SL")(= #flg "R")) ; ���ڽL�^ �̺�ۑ��L�k���s�����ꍇ
        (setq #55 (mapcar '+ (nth 55 #xd$) (list 0.0 #iStretch 0.0)));[56]���݂�WT�̉����o������ *** ؽČ`�� ***
      )
      (T
        (setq #55 (mapcar '+ (nth 55 #xd$) (list #iStretch 0.0 0.0)));[56]���݂�WT�̉����o������ *** ؽČ`�� ***
      )
    );_cond
  );_if

  (setq #WTLEN1 (nth 0 #55))
  (setq #WTLEN2 (nth 1 #55))
  (setq #WTLEN3 (nth 2 #55))
  (setq #ZaiCode (nth 2 #xd$))

  (setq #xd_new$
  (list
    (list 32 #base_new) ; 33.�R�[�i�[���_  WT����_
    (list 38 #WT0)      ;[39]WT��ʐ}�`�����
    (list 49 #BG_tei)   ;[50]�����^�̏ꍇBG1 SOLID�}�`�����  ����ȊO�͒�ʐ}�`����� @@@ *
    (list 51 #FG_tei1)  ;[52]FG1 ��ʐ}�`����� *
    (list 52 #FG_tei2)  ;[53]FG2 ��ʐ}�`����� *
    (list 55 #55)       ;[56]���݂�WT�̉����o������ *** ؽČ`�� *** 00/05/01 YM
  ))

  ;// �g���f�[�^�̍Đݒ�
  (CFSetXData #WT_SOLID "G_WRKT"
    (CFModList
      #xd$ #xd_new$
    )
  )

  (setq #WTL (nth 47 #xd$)) ; ��đ���WT��
  (setq #WTR (nth 48 #xd$)) ; ��đ���WT�E

  ;// ���葤���[�N�g�b�v�̊g���f�[�^���X�V����
  (if (and (/= #WTL "") (/= #WTL nil))
    (progn
      (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; ����
      (CFSetXData #WTL "G_WRKT"
        (CFModList #xdL$
          (list
            (list 48 #WT_SOLID)     ;[49]�J�b�g����WT����ىE U�^�͍��E�ɂ���
          )
        )
      )
    )
  );_if

  (if (and (/= #WTR "") (/= #WTR nil))
    (progn
      (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; �E��
      (CFSetXData #WTR "G_WRKT"
        (CFModList #xdR$
          (list
            (list 47 #WT_SOLID)     ;[48]�J�b�g����WT����ٍ� U�^�͍��E�ɂ���
          )
        )
      )
    )
  );_if

;;; �g���ް� G_BKGD�̾��
;;; 1. �i�Ԗ���
;;; 2. BG��ʐ}�`�����
;;; 3. �֘AWT�}�`�����
  (if #BG_SOLID
    (progn
      (PKSetBGXData
        (list #BG_SOLID (nth 50 #xd$)) ; BG�}�`��ؽ� (list #BG_SOLID1 #BG_SOLID2)
        #cutL         ; WT��č�
        #cutR         ; WT��ĉE
        (nth 2 #xd$); �ގ��L��
        (list #BG0 #BG_tei2) ; BG��ʐ}�`�� (list #BG01 #BG02)
        #WT_SOLID   ; �֘AWT�}�`��
        #D150BG ; D150BG
      )
    )
  );_if

  ;// �n�X�i�b�v�֘A�V�X�e���ϐ������ɖ߂�
  (CFNoSnapEnd) ; 00/02/07@YM@

  #WT_SOLID
);SubStretchWkTop

;<HOM>*************************************************************************
; <�֐���>    : C:ChZaiWkTop
; <�����T�v>  : �ގ��ύX�����
; <�߂�l>    :
; <�쐬>      : 1999-11-15
; <���l>      : 2000.4.30 YM �C��
;*************************************************************************>MOH<
(defun C:ChZaiWKTop (
  /
  #wtEn #wtxd$ #XD$
  #loop #ZAI0 #zai
  #WTL #WTR #WTXD0$ #set_flg #ZaiF #ERRMSG
#HINBAN #NUM1 #NUM2 ; 02/12/04 YM ADD
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:ChZaiWKTop ////")
  (CFOutStateLog 1 1 " ")
  ;// �R�}���h�̏�����
  (StartUndoErr)
  (CFCmdDefBegin 6);00/09/26 SN ADD

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

; 01/06/28 YM ADD ����ނ̐��� Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn

  ;// ���[�N�g�b�v�̎w��
  (initget 0)
  (setq #set_flg nil)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\n���[�N�g�b�v��I��: ")))
    (if #wtEn
      (setq #wtxd$ (CFGetXData #wtEn "G_WRKT"))
      (setq #wtxd$ nil)
    );_if

    (if (= #wtxd$ nil)
      (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
      (progn
        (setq #ZAI0 (nth 2 #wtXd$))
        (setq #ZaiF (KCGetZaiF #ZAI0)) ; �f��F 0:�l�H�嗝�� 1:���ڽ
;;; �֘AWT�ŕi�Ԋm�肳��Ă�����̂����邩�T��
        (setq #xd$ (CFGetXData #wtEn "G_WTSET"))
        (if #xd$ (setq #set_flg T))

        ;;; ��đ��荶
        (setq #WTL (nth 47 #wtxd$)) ; ��WT�}�`�����
        (while (and #WTL (/= #WTL "")) ; ����WT�������
          (setq #wtxd0$ (CFGetXData #WTL "G_WRKT"))
          (setq #xd$ (CFGetXData #WTL "G_WTSET"))
          (if #xd$ (setq #set_flg T))
          (setq #WTL (nth 47 #wtxd0$))     ; �X�ɍ��ɂ��邩
          (if (= #WTL "") (setq #WTL nil)) ; �Ȃ������� nil
        )
        ;;; ��đ���E
        (setq #WTR (nth 48 #wtxd$)) ; �EWT�}�`�����
        (while (and #WTR (/= #WTR "")) ; �E��WT�������
          (setq #wtxd0$ (CFGetXData #WTR "G_WRKT"))
          (setq #xd$ (CFGetXData #WTR "G_WTSET"))
          (if #xd$ (setq #set_flg T))
          (setq #WTR (nth 48 #wtxd0$))     ; �X�ɉE�ɂ��邩
          (if (= #WTR "") (setq #WTR nil)) ; �Ȃ������� nil
        )
;;;01/11/22YM@DEL        (if (= #ZaiF 1)
;;;01/11/22YM@DEL          (progn
;;;01/11/22YM@DEL            (CFAlertMsg "�X�e�����X�𑼂̍ގ��ɕύX�ł��܂���B")
;;;01/11/22YM@DEL            (quit)
;;;01/11/22YM@DEL          )
          (setq #loop nil)
;;;01/11/22YM@DEL        );_if

        (if #set_flg
          (progn
            (if (CFYesNoDialog "���[�N�g�b�v�͊��ɕi�Ԋm�肳��Ă��܂��B\n�����𑱂��܂����H")
              (progn ; YES �Ȃ�F��߂�
                (PCW_ChColWT #wtEn "BYLAYER" T)
              )
              (quit) ; NO
            );_if
          )
        )

      )
    );_if
  );while

  (PCW_ChColWT #wtEn "MAGENTA" T) ; �F��ς��� 00/04/27 YM
  ;// �ގ��L���̑I��(�޲�۸ނ̕\��)

  ; 02/08/29 YM ADD R�t���V�Ή� �޲�۸ޕ���[CT�ގ�]�Q��
  (if (= 1 (nth 33 #wtXd$))

    ; �ގ��޲�۸ޕ\��(R�t���V�̏ꍇ)
    (setq #zai (PKW_CTZaiDlg #ZAI0)) ; 02/08/29 YM ADD
; else
    ;;;01/11/22YM@DEL  (setq #zai (PKW_ZaiDlg #ZAI0)) ; #ZAI0
    ; ���ݽ��ڽ�Ž��ڽ�̑I������2�ȏ゠��Ƃ��ͽ��ڽ���m�ގ��ύX�\
    ; �ʏ�ǂ���
;-- 2011/09/18 A.Satoh Mod - S
;;;;;    (setq #zai (PKW_ZaiDlgS #ZAI0)) ; 01/11/22 YM ADD
    (setq #zai (PKW_ZaiDlgS #ZAI0 #wtEn #wtxd$)) ; 01/11/22 YM ADD
;-- 2011/09/18 A.Satoh Mod - E

  );_if

  (PCW_ChColWT #wtEn "BYLAYER" T)

  ; �����ײ�ү���ޕ\�� 0/08/29 YM ADD-S
  ;// �ގ��̍X�V
  (if (and #zai (/= #ZAI0 #zai))
    ; �߂�l�� nil �łȂ��Č��̍ގ��ƈႤ�ꍇ
    (princ "\n�ގ���ύX���܂����B")
  ; else
    (princ "\n�ގ���ύX���܂���ł����B")
  );_if
  ; �����ײ�ү���ޕ\�� 0/08/29 YM ADD-E

  ;// �ގ��̍X�V
  (if #zai
    (progn ; �߂�l�� nil �łȂ�
      (command "vpoint" "0,0,1")          ; ���_��^�ォ��
      (setq CG_WorkTop (substr #zai 2 1)) ; �F���O���[�o���ݒ� 06/02 YM

      ; 02/08/29 YM ADD-S
      (if (= 1 (nth 33 #wtXd$))
        (progn ; R�t���V��������i�ԍX�V����
          (setq #hinban (nth 34 #wtXd$))
          ; 02/11/27 YM MOD-S �ذ�ދL��1,2�� �ގ�1,2���ɑΉ�
          (setq #num1 (strlen CG_SeriesCode)) ; �ذ�ދL��������
          (setq #num2 (strlen #ZAI0))         ; �ގ��L��������
          (setq #hinban
            (strcat (substr #hinban 1 #num1)
              #zai
              (substr #hinban (1+ (+ #num1 #num2)) (- (strlen #hinban) (+ #num1 #num2)))
            )
          )
          ; 02/11/27 YM MOD-E

          ; 02/11/27 YM MOD �ذ�ދL��1,2�� �ގ�1,2���ɑΉ�
;;;         (setq #hinban
;;;           (strcat (substr #hinban 1 2)
;;;                   #zai
;;;                   (substr #hinban 5 (- (strlen #hinban) 4))
;;;           )
;;;         )

        )
      );_if
      ; 02/08/29 YM ADD-E

      ; 02/09/02 YM MOD R�t���ǂ����ŕ��򂷂�悤�ɕύX
      (if (= 1 (nth 33 #wtXd$))
        (progn
          (CFSetXData #wtEn "G_WRKT"
            (CFModList #wtxd$
              (list
                (list  2 #zai)
                (list 18 0)       ; 01/11/22 YM ADD
                (list 19 "")      ; 01/11/22 YM ADD
                (list 34 #hinban) ; ��R�t���V�̏ꍇ��
              )
            )
          )
        )
        (progn
          (CFSetXData #wtEn "G_WRKT"
            (CFModList #wtxd$
              (list
                (list  2 #zai)
                (list 18 0)  ; 01/11/22 YM ADD
                (list 19 "") ; 01/11/22 YM ADD
              )
            )
          )
        )
      );_if

      ; 01/06/08 YM ADD �ݸ,�������𖄂߂� START
      (if (CFGetXData #wtEn "G_WTSET")
        (progn
          (KPSrcSNKembedANA #wtEn)
          (DelAppXdata #wtEn "G_WTSET")  ; "G_WTSET"������
        )
      );_if
      ; 01/06/08 YM ADD �ݸ,�������𖄂߂� END

      ;;; ��đ��荶
      (setq #WTL (nth 47 #wtxd$))    ; ��WT�}�`�����
      (while (and #WTL (/= #WTL "")) ; ����WT�������
        (setq #wtxd0$ (CFGetXData #WTL "G_WRKT"))
        (CFSetXData #WTL "G_WRKT"
          (CFModList #wtxd0$
            (list
              (list  2 #zai)
              (list 18 0)  ; 01/11/22 YM ADD
              (list 19 "") ; 01/11/22 YM ADD
            )
          )
        )
        ; 01/06/08 YM ADD �ݸ,�������𖄂߂� START
        (if (CFGetXData #WTL "G_WTSET")
          (progn
            (KPSrcSNKembedANA #WTL)
            (DelAppXdata #WTL "G_WTSET")     ; "G_WTSET"������
          )
        );_if
        ; 01/06/08 YM ADD �ݸ,�������𖄂߂� END

        (setq #WTL (nth 47 #wtxd0$))     ; �X�ɍ��ɂ��邩
        (if (= #WTL "") (setq #WTL nil)) ; �Ȃ������� nil
      )
      ;;; ��đ���E
      (setq #WTR (nth 48 #wtxd$))    ; �EWT�}�`�����
      (while (and #WTR (/= #WTR "")) ; �E��WT�������
        (setq #wtxd0$ (CFGetXData #WTR "G_WRKT"))
        (CFSetXData #WTR "G_WRKT"
          (CFModList #wtxd0$
            (list
              (list  2 #zai)
              (list 18 0)  ; 01/11/22 YM ADD
              (list 19 "") ; 01/11/22 YM ADD
            )
          )
        )
        ; 01/06/08 YM ADD �ݸ,�������𖄂߂� START
        (if (CFGetXData #WTR "G_WTSET")
          (progn
            (KPSrcSNKembedANA #WTR)
            (DelAppXdata #WTR "G_WTSET")     ; "G_WTSET"������
          )
        );_if
        ; 01/06/08 YM ADD �ݸ,�������𖄂߂� END

        (setq #WTR (nth 48 #wtxd0$))     ; �X�ɉE�ɂ��邩
        (if (= #WTR "") (setq #WTR nil)) ; �Ȃ������� nil
      )
      (command "zoom" "p") ; ���_��߂�
    )
    (quit) ; �X�V���Ȃ�
  );_if

  ); 01/06/28 YM ADD ����ނ̐��� Lipple
);_if

  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)


);C:ChZaiWKTop

;<HOM>*************************************************************************
; <�֐���>    : KPSrcSNKembedANA
; <�����T�v>  : WT�O�`����ݸ��T���ļݸ���𖄂߂�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/06/08 YM
; <���l>      : ! ssget "CP"���K�v !
;*************************************************************************>MOH<
(defun KPSrcSNKembedANA (
  &wtEn
  /
  #410$ #PT$ #TEIWT #WTEN #WTXD$
  )
  (setq #wtxd$ (CFGetXData &wtEn "G_WRKT"))
  (setq #teiWT  (nth 38 #wtxd$))      ; WT��ʐ}�`
  (setq #pt$ (GetLWPolyLinePt #teiWT)); WT�O�`�_��
  (setq #pt$ (AddPtList #pt$))
  (setq #410$ (PKGetSymBySKKCodeCP #pt$ CG_SKK_INT_SNK)) ; �̈��ݸ ; 01/08/31 YM MOD 410-->��۰��ى�
  (foreach #410 #410$
    (PKWTSinkAnaEmbed &wtEn #410 nil) ; WT�}�`,�ݸ����ِ}�`��n����WT�̌��𖄂߂�
  )
  (princ)
);KPSrcSNKembedANA

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_ZaiDlg
;;; <�����T�v>  : �ގ��ύX�_�C�A���O�\��
;;; <�߂�l>    : �ގ��L��
;;; <�쐬>      : 00/09/29 YM �W����
;;; <���l>      : ���ڽ<==>�l��̕ύX�͋֎~ 01/04/12 YM
;;;*************************************************************************>MOH<
(defun PKW_ZaiDlg (
  &wtZai
  /
  #dcl_id ##GetDlgItem
  #Qry$ #Qry$$ #dum$$
  #no #i #ZAI #BG_KEI #ELM #I
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( / #zai)
            (setq #zai
              (caddr (nth (atoi (get_tile "zai")) #dum$$))
            )
            (if (/= &wtZai #zai)
              (progn ; �ύX���������ꍇ
                (princ "\n�ގ���ύX���܂����B")
                (done_dialog)
                #zai
              )
              (progn
                (princ "\n�ގ���ύX���܂���ł����B")
                (done_dialog)
                nil
              )
            );_if
          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// �ގ��L���̑I��
  (setq #Qry$$
    (DBSqlAutoQuery CG_DBSESSION (strcat "select * from WT�ގ� where SERIES�L��='" CG_SeriesCode "'"))
  )
  (setq #Qry$$ (CFListSort #Qry$$ 0)) ; (nth 0 �����������̏��ɿ�� 01/05/30 YM ADD

  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "ChgZaiDlg" #dcl_id)) (exit))

  ; ���ڽ�͕\�����Ȃ� 01/04/12 YM ADD
  (setq #dum$$ nil)
  (foreach #Qry$ #Qry$$
;;;01/08/10YM@    (if (/= 1 (nth 4 #Qry$))
    (if (and (/= 1 (nth 4 #Qry$))(/= 1 (nth 6 #Qry$))) ; �p��F��1�łȂ����� 01/08/10 YM ADD
      (setq #dum$$ (append #dum$$ (list #Qry$)))
    );_if
  )

  (start_list "zai" 3)
  (setq #i 0 #no 0)
  (foreach #dum$ #dum$$
    (add_list (strcat (nth 2 #dum$) " �F " (nth 3 #dum$)))
    (if (= (nth 2 #dum$) &wtZai)
      (setq #no #i)
    )
    (setq #i (1+ #i))
  )
  (end_list)
  (set_tile "zai" (itoa #no))

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #zai (##GetDlgItem))")
  (action_tile "cancel" "(setq #zai nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)

  ;// �V���N�A�������A������ނ̑I��ԍ��y�ь��a�A�\�����a��Ԃ�
  #zai ; �߂�l 00/03/19 (�ގ��L��,�׸�#CG_WtDepth) #CG_WtDepth=0,1,10,100�̘a

);PKW_ZaiDlg

;;;<HOM>*************************************************************************
;;; <�֐���>    : PKW_ZaiDlgS
;;; <�����T�v>  : �ގ��ύX��pnew�_�C�A���O�\��
;;; <�߂�l>    : (�ގ��L��)
;;; <�쐬>      : 00/09/29 YM �W����
;;; <���l>      : ���ݽ��ڽ�Ž��ڽ�̑I������2�ȏ゠��Ƃ��ͽ��ڽ���m�ގ��ύX�\ 01/11/22 YM
;;;*************************************************************************>MOH<
(defun PKW_ZaiDlgS (
  &wtZai
;-- 2011/09/18 A.Satoh Add - S
  &eWTP
  &wtxd$
;-- 2011/09/18 A.Satoh Add - S
  /
;-- 2011/09/18 A.Satoh Mod - S
;;;;;  #dcl_id ##GetDlgItem
;;;;;  #Qry$ #Qry$$ #dum$$
;;;;;  #no #i #ZAI #BG_KEI #ELM #I
  #Qry$$ #qry$ #err_flg #ret$ #SNK$$ #SNK$ #eSNK$ #zai #xd_SNK$ #snk_kigou
  #oku$$ #oku$ #oku #msg #zai_Kanri$$ #zai_Kanri$ #zai$ #dcl_id #dum$$ #dum$
  #idx #no
;-- 2011/09/18 A.Satoh Mod - E
  #ZAI_DUM$$ #ZAI_TYP #ZAI_KANRI ;2011/09/19 YM ADD
#snk_dep   ;-- 2012/04/20 A.Satoh Add �V���N�z�u�s��Ή�
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          (defun ##GetDlgItem ( / #zai)
            (setq #zai
              (nth 1 (nth (atoi (get_tile "zai")) #dum$$))
            )
; 02/08/29 YM DEL-S
;;;            (if (/= &wtZai #zai)
;;;              (progn ; �ύX���������ꍇ
;;;                (princ "\n�ގ���ύX���܂����B")
;;;                (done_dialog)
;;;                #zai
;;;              )
;;;              (progn
;;;                (princ "\n�ގ���ύX���܂���ł����B")
;;;                (done_dialog)
;;;                nil
;;;              )
;;;            );_if
; 02/08/29 YM DEL-E

            (done_dialog)
            #zai

          );##GetDlgItem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;// �ގ��L���̑I��
  (setq #Qry$$
    (DBSqlAutoQuery CG_DBSESSION (strcat "select * from WT�ގ� where �p��F=0"))
  )
  (setq #Qry$$ (CFListSort #Qry$$ 0)) ; (nth 0 �����������̏��ɿ�� 01/05/30 YM ADD

;-- 2011/09/18 A.Satoh Add - S
  ; �V��ʐ}�`�����ʐ}�`�̈�����߂�
  (setq #err_flg nil)
  (setq #zai nil)

  (command "vpoint" "0,0,1")

  (setq #ret$ (PKW_GetWorkTopAreaSym3 &eWTP)); ���� = �����̑Ώۃ��[�N�g�b�v�}�`��

  (command "zoom" "p")

  (setq #SNK$$ (nth 0 #ret$))
  (foreach #SNK$ #SNK$$
    (setq #eSNK$ (append #eSNK$ (list (nth 0 #SNK$))))
  )
  (setq #eSNK$ (NilDel_List #eSNK$))
  (if (= #eSNK$ nil)
    (progn
      nil ;2011/09/19 YM �ݸ���Ȃ��Ă��������s��
;;;2011/09/19YM      (setq #err_flg T)
;;;2011/09/19YM      (CFAlertMsg "�w�肳�ꂽ�V�ɂͼݸ������܂���")
    )
    (progn
      ; �V���N�L�������o��
      (setq #xd_SNK$ (CFGetXData (car #eSNK$) "G_LSYM"))
      (if #xd_SNK$
        (setq #snk_kigou (nth 5 #xd_SNK$))
        (progn
          (setq #err_flg T)
          (CFAlertMsg "�ݸ��񂪑��݂��܂���")
        )
      )
    )
  )

  (if (= #err_flg nil)
    (progn
;-- 2012/04/20 A.Satoh Mod �V���N�z�u�s��Ή� - S
      ; ���s��
;;;;;      (setq #oku$$
;;;;;        (CFGetDBSQLRec CG_DBSESSION "���s"
;;;;;          (list
;;;;;            (list "���s" (itoa (fix (+ (car (nth 57 &wtxd$)) 0.01))) 'INT)
;;;;;          )
;;;;;        )
;;;;;      )
			(setq #snk_dep (nth 39 &wtxd$))
			(if (or (= #snk_dep 0.0) (= #snk_dep nil))
				(progn
					(setq #snk_dep (getSinkDep &eWTP))
					(if (or (= #snk_dep 0.0) (= #snk_dep nil))
						(setq #snk_dep (car (nth 57 &wtxd$)))
					)
				)
			)
      (setq #oku$$
        (CFGetDBSQLRec CG_DBSESSION "���s"
          (list
            (list "���s" (itoa (fix (+ #snk_dep 0.01))) 'INT)
          )
        )
      )
;;(princ "\n#snk_dep = ")(princ #snk_dep)
;;(princ "\n#oku$$ = ")(princ #oku$$)(princ)
;-- 2012/04/20 A.Satoh Mod �V���N�z�u�s��Ή� - E
      (if (and #oku$$ (= 1 (length #oku$$)))
        (progn
          (setq #oku$ (nth 0 #oku$$))
          (setq #oku (nth 1 #oku$))
        )
        (progn
          (setq #err_flg T)
;-- 2012/04/20 A.Satoh Mod �V���N�z�u�s��Ή� - S
;;;;;          (setq #msg (strcat "�w���s�x��ں��ނ�����܂���B\n�ݸ����ȯĕi�Ԗ���=" (itoa (fix (+ (car (nth 57 &wtxd$)) 0.01)))))
          (setq #msg (strcat "�w���s�x��ں��ނ�����܂���B\n���s�T�C�Y=" (itoa (fix (+ #snk_dep 0.01)))))
;-- 2012/04/20 A.Satoh Mod �V���N�z�u�s��Ή� - E
          (CFAlertMsg #msg)
        )
      )
    )
  )

  (if (= #err_flg nil)
    (progn
      (if #eSNK$
        (progn

          ; �ގ��ύX�Ǘ��e�[�u������ގ��L�����X�g���쐬����
          (setq #zai_Kanri$$
            (CFGetDBSQLRec CG_DBSESSION "�ގ��ύX�Ǘ�"
              (list
                (list "���s"   #oku 'STR)
                (list "�V���N" #snk_kigou 'STR)
              )
            )
          )

          ;;; �װ����
          (if (and #zai_Kanri$$ (= 1 (length #zai_Kanri$$)))
            (progn
              (setq #zai_Kanri$ (car #zai_Kanri$$))
              (setq #zai_Kanri (nth 3 #zai_Kanri$))
              (setq #zai$ (strparse #zai_Kanri ","))
            )
            (progn
              (setq #err_flg T)
              (setq #msg (strcat "�w�ގ��ύX�Ǘ��x��ں��ނ�����܂���B\n���s=" #oku "  �ݸ=" #snk_kigou))
              (CFAlertMsg #msg)
            )
          );_if

        )
        (progn ;�ݸ���Ȃ��Ƃ�

          (setq #zai_dum$$
            (CFGetDBSQLRec CG_DBSESSION "WT�ގ�"
              (list
                (list "�ގ��L��"   &wtZai 'STR)
              )
            )
          )
          (setq #zai_typ (nth 8 (car #zai_dum$$)))
          (if (or (= #zai_typ nil)(= #zai_typ ""))
            (progn
              (setq #msg "\n���݂̍ގ��͕ύX�ł��܂���")
              (CFAlertMsg #msg)
              (setq #err_flg T)
            )
            (progn
              (setq #zai_Kanri$$
                (CFGetDBSQLRec CG_DBSESSION "WT�ގ�"
                  (list
                    (list "�ގ��ύX���"   #zai_typ 'STR)
                  )
                )
              )
              (foreach #zai_Kanri$ #zai_Kanri$$
                (nth 1 #zai_Kanri$)
                (setq #zai$ (append #zai$ (list (nth 1 #zai_Kanri$))))
              )
            )
          );_if
        )
      );_if

    )
  );_if

  (if (= #err_flg nil)
    (progn
;-- 2011/09/18 A.Satoh Mod - E
  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (not (new_dialog "ChgZaiDlg" #dcl_id)) (exit))

;-- 2011/09/18 A.Satoh Mod - S
      (setq #dum$$ nil)
      (setq #idx 0)
      (repeat (length #zai$)
        (foreach #qry$ #QRY$$
          (if (= (nth #idx #zai$) (nth 1 #qry$))
            (setq #dum$$ (append #dum$$ (list #qry$)))
          )
        )
        (setq #idx (1+ #idx))
      )

      (setq #idx 0 #no 0)
      (start_list "zai" 3)
      (foreach #dum$ #dum$$
        (add_list (strcat (nth 1 #dum$) " �F " (nth 2 #dum$)))
        (if (= (nth 1 #dum$) &wtZai)
          (setq #no #idx)
        )
        (setq #idx (1+ #idx))
      )
      (end_list)
      (set_tile "zai" (itoa #no))
;;;;;  ; ���ݽ��ڽ�Ž��ڽ�̑I������2�ȏ゠��Ƃ��ͽ��ڽ���m�ގ��ύX�\
;;;;;  (setq #ZaiF (KCGetZaiF &wtZai)) ; �f��F 0:�l�H�嗝�� 1:���ڽ
;;;;;  (if (= #ZaiF 1)
;;;;;    (progn ; ���ڽ
;;;;;      (setq #dum$$ nil)
;;;;;      (foreach #Qry$ #Qry$$
;;;;;        (if (= 1 (nth 3 #Qry$)) ;���ڽ
;;;;;          (setq #dum$$ (append #dum$$ (list #Qry$)))
;;;;;        );_if
;;;;;      )
;;;;;    )
;;;;;    (progn ; ���ڽ�ȊO
;;;;;      (setq #dum$$ nil)
;;;;;      (foreach #Qry$ #Qry$$
;;;;;        (if (= 0 (nth 3 #Qry$)) ;�l��
;;;;;          (setq #dum$$ (append #dum$$ (list #Qry$)))
;;;;;        );_if
;;;;;      )
;;;;;    )
;;;;;  );_if
;;;;;
;;;;;  (start_list "zai" 3)
;;;;;  (setq #i 0 #no 0)
;;;;;  (foreach #dum$ #dum$$
;;;;;    (add_list (strcat (nth 1 #dum$) " �F " (nth 2 #dum$)))
;;;;;    (if (= (nth 1 #dum$) &wtZai)
;;;;;      (setq #no #i)
;;;;;    )
;;;;;    (setq #i (1+ #i))
;;;;;  )
;;;;;  (end_list)
;;;;;  (set_tile "zai" (itoa #no))
;-- 2011/09/18 A.Satoh Mod - E

  ;// ��ق�ر���ݐݒ�
  (action_tile "accept" "(setq #zai (##GetDlgItem))")
  (action_tile "cancel" "(setq #zai nil) (done_dialog)")

  (start_dialog)
  (unload_dialog #dcl_id)
;-- 2011/09/18 A.Satoh Add - S
    )
  )
;-- 2011/09/18 A.Satoh Add - E

  ;// �V���N�A�������A������ނ̑I��ԍ��y�ь��a�A�\�����a��Ԃ�
  #zai ; �߂�l 00/03/19 (�ގ��L��,�׸�#CG_WtDepth) #CG_WtDepth=0,1,10,100�̘a

);PKW_ZaiDlgS

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckD
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(WK �i���p)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 00/12/19 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckD (
  &ret$     ; �W���������@ؽ�
  &SnkP     ; SINK PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  &cutTYPE  ; WT�������
  /
  #DIMA #DIMB1 #DIMB2 #DIMC #DISTL #DISTR #L1 #L2 #R1 #R2 #SNKPT$
  #STD_FLG #WTPT$
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #DimA  (nth 0 &ret$)) ; ���@A
  (setq #DimB1 (nth 1 &ret$)) ; ���@B1
  (setq #WTpt$ &WTpt$)

;L1+------------------+R1
;  | B +--------+  A  |
;  |<->|  �ݸ   |<--->|
;  |   +--------+     |
;L2+------------------+R2

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; �ݸ�O�`�_��

  (if (= (substr &cutTYPE 1 1) "4")
    (progn ; �������i���̂Ƃ�
      ; �E��������
      (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " �i��WT�E��-�ݸ�W�����@: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " �i��WT�E��-�ݸ�����@:   " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")
      ; ����������
      (setq #distL (GetDistLineToPline (list #L1 #L2) #SNKpt$))
      (if (not (equal #distL #DimB1 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " �i��WT����-�ݸ�W�����@: " (rtos #DimB1)))
      (CFOutStateLog 1 1 (strcat " �i��WT����-�ݸ�����@:   " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")
    )
  );_if

  (if (= (substr &cutTYPE 2 1) "4")
    (progn ; �E�����i��
      ; �E��������
      (setq #distR (GetDistLineToPline (list #L1 #L2) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " �i��WT����-�ݸ�W�����@: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " �i��WT����-�ݸ�����@:   " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")
      ; ����������
      (setq #distL (GetDistLineToPline (list #R1 #R2) #SNKpt$))
      (if (not (equal #distL #DimB1 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " �i��WT�E��-�ݸ�W�����@: " (rtos #DimB1)))
      (CFOutStateLog 1 1 (strcat " �i��WT�E��-�ݸ�����@:   " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckD

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckI
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(ж�� I�^�p)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 01/02/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckI (
  &ret$     ; �W���������@ؽ�
  &SnkP     ; SINK PMEN PLINE
  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  &WTLR     ; ���E�̏���
  /
  #ANG #DIMA #DIMB #DIMB1 #DIMB2 #DIMC #DIST #DISTL #DISTR #GASPT$
  #L1 #L2 #R1 #R2 #SNKPT$ #STD_FLG #WTBASE #WTPT$ #X1 #Y1 #Errflg
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA  (nth 0 &ret$)) ; ���@A
  (setq #DimB  (nth 1 &ret$)) ; ���@B
  (setq #DimC  (nth 2 &ret$)) ; ���@C
;L1+---------------------------+R1
;  | B +----+ C +--------+  A  |
;  |<->|��� |<->|  �ݸ   |<--->|
;  |   +----+   +--------+     |
;L2+---------------------------+R2

;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
  (setq #x1 (nth 1 #WTpt$)) ; WT�E��_
  ;;; WT����(0,0)�Ƃ���UCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; �ݸ�O�`�_��
  (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ��ۊO�`�_��

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; ����ł��Ȃ�==>"ĸ"
    (progn
      (cond
        ((= &WTLR "R") ; �E����̂Ƃ�
          (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))
        )
        ((= &WTLR "L") ; ������̂Ƃ�
          (setq #distR (GetDistLineToPline (list #L1 #L2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #R1 #R2) #GASpt$))
        )
        (T ; ����ȊO 01/12/12 YM ADD "?"�Ή�
          (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))
        )
      );_if

;;;01/12/12YM@MOD     (if (= &WTLR "R")
;;;01/12/12YM@MOD       (progn ; �E����̂Ƃ�
;;;01/12/12YM@MOD         (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
;;;01/12/12YM@MOD         (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))
;;;01/12/12YM@MOD       )
;;;01/12/12YM@MOD       (progn ; ������̂Ƃ�
;;;01/12/12YM@MOD         (setq #distR (GetDistLineToPline (list #L1 #L2) #SNKpt$))
;;;01/12/12YM@MOD         (setq #distL (GetDistLineToPline (list #R1 #R2) #GASpt$))
;;;01/12/12YM@MOD       )
;;;01/12/12YM@MOD     );_if

      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      ; �ݸ-��ۊԂ�����
      (setq #dist (GetDistPlineToPlineX #SNKpt$ #GASpt$)) ; UCS��v�s�z�u�p�x=0��O��
      (if (not (equal #dist  #DimC 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�W�����@: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�����@:   " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " WT-��ەW�����@: " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-��ێ����@:   " (rtos #distL)))
      (CFOutStateLog 1 1 (strcat "�ݸ-��ەW�����@: " (rtos #DimC)))
      (CFOutStateLog 1 1 (strcat "�ݸ-��ێ����@:   " (rtos #dist)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-�ݸ�W�����@:  " (rtos #DimA)))
      (princ (strcat "\n WT-�ݸ�����@:    " (rtos #distR)))
      (princ (strcat "\n WT-��ەW�����@:  " (rtos #DimB)))
      (princ (strcat "\n WT-��ێ����@:    " (rtos #distL)))
      (princ (strcat "\n �ݸ-��ەW�����@: " (rtos #DimC)))
      (princ (strcat "\n �ݸ-��ێ����@:   " (rtos #dist)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n�W��ܰ�į�߂ł͂���܂���B"))
      (command "._ucs" "P")
    )
  );_if

  ; 02/08/23 YM ADD-S �K�i�i�Ɣ��肳�ꂽ���@���۰��ٕۑ�����
  (if #STD_flg
    (setq CG_DIMSEQ &ret$)
  );_if
  ; 02/08/23 YM ADD-E

  #STD_flg
);KP_Std_DimCHeckI

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckI-G
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(ж�� I�^��ۂ̂ݗp)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 02/12/06 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckI-G (
  &ret$     ; �W���������@ؽ�
  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  &WTLR     ; ���E�̏���
  /
  #ANG #DIMA #DIMB #DISTL #DISTR #ERRFLG #GASPT$ #L1 #L2 #R1 #R2 #STD_FLG #WTBASE
  #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA  (nth 0 &ret$)) ; ���@A
  (setq #DimB  (nth 1 &ret$)) ; ���@B
;L1+------------------+R1
;  | B +----+    A    |
;  |<->|��� |<------->|
;  |   +----+         |
;L2+------------------+R2

;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
  (setq #x1 (nth 1 #WTpt$)) ; WT�E��_
  ;;; WT����(0,0)�Ƃ���UCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ��ۊO�`�_��

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; ����ł��Ȃ�==>"ĸ"
    (progn
      (setq #distR (GetDistLineToPline (list #R1 #R2) #GASpt$))
      (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-��ۘe�E�W�����@: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-��ۘe�E�����@:   " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " WT-��ۘe���W�����@: " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-��ۘe�������@:   " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-��ۘe�E�W�����@:  " (rtos #DimA)))
      (princ (strcat "\n WT-��ۘe�E�����@:    " (rtos #distR)))
      (princ (strcat "\n WT-��ۘe���W�����@:  " (rtos #DimB)))
      (princ (strcat "\n WT-��ۘe�������@:    " (rtos #distL)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n�W��ܰ�į�߂ł͂���܂���B"))
      (command "._ucs" "P")
    )
  );_if

  ; 02/08/23 YM ADD-S �K�i�i�Ɣ��肳�ꂽ���@���۰��ٕۑ�����
  (if #STD_flg
    (setq CG_DIMSEQ &ret$)
  );_if
  ; 02/08/23 YM ADD-E

  #STD_flg
);KP_Std_DimCHeckI-G

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_DimCHeckI-G
;;; <�����T�v>  : (�~�J�hI�^��ۂ̂ݺ�ۘe���@��Ԃ�)
;;; <�߂�l>    : (�E��ۘe,����ۘe)
;;; <�쐬>      : 02/12/06 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_DimCHeckI-G (
  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  /
  #ANG #DISTL #DISTR #GASPT$ #L1 #L2 #R1 #R2 #WTBASE #WTPT$ #X1 #Y1 #RET$
  )
  (if (= nil &GasP)
    (progn ; 02/12/19 YM ADD �޽�J�������̂Ƃ�������-->�װ����
      (setq #ret$ (list 0 0))
    )
    (progn
      (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
    ;L1+------------------+R1
    ;  | B +----+    A    |
    ;  |<->|��� |<------->|
    ;  |   +----+         |
    ;L2+------------------+R2

    ;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
      (setq #x1 (nth 1 #WTpt$)) ; WT�E��_
      ;;; WT����(0,0)�Ƃ���UCS
      (setq #ang (angle #WTbase #x1))
      (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
      (command "._ucs" "3" #WTbase #x1 #y1)

      (setq #L1  (nth 0 #WTpt$))
      (setq #L2  (last  #WTpt$))
      (setq #R1  (nth 1 #WTpt$))
      (setq #R2  (nth 2 #WTpt$))

      (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ��ۊO�`�_��
      (setq #distR (GetDistLineToPline (list #R1 #R2) #GASpt$)) ; �E��ۘe
      (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$)) ; ����ۘe
      (command "._ucs" "P")
      (setq #ret$ (list #distR #distL))
    )
  );_if
);KP_DimCHeckI-G

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckI-ISC
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(ж�� I�^�������ߓV��)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 02/08/30 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckI-ISC (
  &ret$     ; �W���������@ؽ�
  &SnkP     ; SINK PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  &WTLR     ; ���E�̏���
  /
  #ANG #DIMA #DIMB #DIMC #DISTL #DISTR #ERRFLG #L1 #L2 #R1 #R2 #SNKPT$ #STD_FLG
  #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA  (nth 0 &ret$)) ; ���@A
  (setq #DimB  (nth 1 &ret$)) ; ���@B
  (setq #DimC  (nth 2 &ret$)) ; ���@C
;L1+---------------------------+R1
;  |     C      +--------+  A  |
;  |<---------->|  �ݸ   |<--->|
;  |            +--------+     |
;L2+---------------------------+R2

;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
  (setq #x1 (nth 1 #WTpt$)) ; WT�E��_
  ;;; WT����(0,0)�Ƃ���UCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; �ݸ�O�`�_��

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; ����ł��Ȃ�==>"ĸ"
    (progn
      (cond
        ((= &WTLR "R") ; �E����̂Ƃ�
          (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #L1 #L2) #SNKpt$))
        )
        ((= &WTLR "L") ; ������̂Ƃ�
          (setq #distR (GetDistLineToPline (list #L1 #L2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #R1 #R2) #SNKpt$))
        )
        (T ; ����ȊO 01/12/12 YM ADD "?"�Ή�
          (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
          (setq #distL (GetDistLineToPline (list #L1 #L2) #SNKpt$))
        )
      );_if

      (if (or (and (equal #distR #DimA 0.1)(equal #distL #DimC 0.1))
              (and (equal #distR #DimC 0.1)(equal #distL #DimA 0.1)))
        nil ; �K�i�i
      ; else
        (setq #STD_flg nil)
      );_if

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�E�����@:    " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�������@:    " (rtos #distL)))
      (CFOutStateLog 1 1 (strcat " WT-�ݸ���W�����@1: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-�ݸ���W�����@2: " (rtos #DimB)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat " WT-�ݸ�E�����@:    " (rtos #distR)))
      (princ (strcat " WT-�ݸ�������@:    " (rtos #distL)))
      (princ (strcat " WT-�ݸ���W�����@1: " (rtos #DimA)))
      (princ (strcat " WT-�ݸ���W�����@2: " (rtos #DimB)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n�W��ܰ�į�߂ł͂���܂���B"))
      (command "._ucs" "P")
    )
  );_if

  #STD_flg
);KP_Std_DimCHeckI-ISC

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckIDAN
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(ж�� I�^�i�����ݗp)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 01/02/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckIDAN (
  &ret$     ; �W���������@ؽ�
  &SnkP     ; SINK PMEN PLINE
;;;  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  #CutType  ; �������"40","04"�Ȃ�
  /
  #ANG #DIMA #DIMB #DISTL #DISTR #ERRFLG #L1 #L2 #R1 #R2 #SNKPT$ #STD_FLG #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA  (nth 0 &ret$)) ; ���@A
  (setq #DimB  (nth 1 &ret$)) ; ���@B(�i���ڑ����Ƃ̋���)

;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
  (setq #x1 (nth 1 #WTpt$)) ; WT�E��_
  ;;; WT����(0,0)�Ƃ���UCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; �ݸ�O�`�_��
;;;  (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ��ۊO�`�_��

;              L1
;  +-----------+------------------+R1
;  |   +----+  | B +--------+  A  |
;  |   |��� |  |<->|  �ݸ   |<--->|
;  |   +----+  |   +--------+     |
;  +-----------+------------------+R2
;              L2

;  L1
;  +------------------+------------+R1
;  |     +--------+ B |  +------+  |
;  |<-A->|�ݸ     |<->|  |  ��� |  |
;  |     +--------+   |  +------+  |
;  +------------------+------------+R2
; L2

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; ����ł��Ȃ�==>"ĸ"
    (progn
      (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
      (setq #distL (GetDistLineToPline (list #L1 #L2) #SNKpt$))

      (if (= (substr #CutType 1 1) "4") ; �����i���ڑ���(�E����)
        (progn
          (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
          (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

          (CFOutStateLog 1 1 "--------------------------------------------------")
          (CFOutStateLog 1 1 (strcat " WT-�ݸ�W�����@:         " (rtos #DimA)))
          (CFOutStateLog 1 1 (strcat " WT�E-�ݸ�����@:         " (rtos #distR)))
          (CFOutStateLog 1 1 (strcat " �i���ڑ���-�ݸ�W�����@: " (rtos #DimB)))
          (CFOutStateLog 1 1 (strcat " WT��-�ݸ�����@:         " (rtos #distL)))
          (CFOutStateLog 1 1 "--------------------------------------------------")

          (princ "\n--------------------------------------------------")
          (princ (strcat "\n WT-�ݸ�W�����@:         " (rtos #DimA)))
          (princ (strcat "\n WT�E-�ݸ�����@:         " (rtos #distR)))
          (princ (strcat "\n �i���ڑ���-�ݸ�W�����@: " (rtos #DimB)))
          (princ (strcat "\n WT��-�ݸ�����@:         " (rtos #distL)))
          (princ "\n--------------------------------------------------")

        )
        (progn ; �E���i���ڑ���(������)
          (if (not (equal #distR #DimB 0.1))(setq #STD_flg nil))
          (if (not (equal #distL #DimA 0.1))(setq #STD_flg nil))

          (CFOutStateLog 1 1 "--------------------------------------------------")
          (CFOutStateLog 1 1 (strcat " WT-�ݸ�W�����@:         " (rtos #DimA)))
          (CFOutStateLog 1 1 (strcat " WT�E-�ݸ�����@:         " (rtos #distL)))
          (CFOutStateLog 1 1 (strcat " �i���ڑ���-�ݸ�W�����@: " (rtos #DimB)))
          (CFOutStateLog 1 1 (strcat " WT��-�ݸ�����@:         " (rtos #distR)))
          (CFOutStateLog 1 1 "--------------------------------------------------")

          (princ "\n--------------------------------------------------")
          (princ (strcat "\n WT-�ݸ�W�����@:         " (rtos #DimA)))
          (princ (strcat "\n WT�E-�ݸ�����@:         " (rtos #distL)))
          (princ (strcat "\n �i���ڑ���-�ݸ�W�����@: " (rtos #DimB)))
          (princ (strcat "\n WT��-�ݸ�����@:         " (rtos #distR)))
          (princ "\n--------------------------------------------------")
        )
      );_if

      (if (= #STD_flg nil)(princ "\n�W��ܰ�į�߂ł͂���܂���B"))
      (command "._ucs" "P")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckIDAN

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckIS
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(ж�� L�^�l��ݸ���p)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 01/02/13 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckIS (
  &ret$     ; �W���������@ؽ�
  &SnkP     ; SINK PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  &WTLR     ; ���E�̏���
  /
  #ANG #DIMA #DISTR #ERRFLG #L1 #L2 #R1 #R2 #SNKPT$ #STD_FLG #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA  (nth 0 &ret$)) ; ���@A
;L1+---------------------------+R1
;  |            +--------+  A  |
;  |            |  �ݸ   |<--->|
;  |            +--------+     |
;L2+---------------------------+R2

;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
  (setq #x1 (nth 1 #WTpt$)) ; WT�E��_
  ;;; WT����(0,0)�Ƃ���UCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

; 02/12/06 YM ���W�b�N�ύX�΂߶�ĂŌ듮��
  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (polar #L1 (- #ang (dtr 90)) 1000))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (polar #R1 (- #ang (dtr 90)) 1000))

; 02/12/06 YM ���W�b�N�ύX�΂߶�ĂŌ듮��
;;;  (setq #L1  (nth 0 #WTpt$))
;;;  (setq #L2  (last  #WTpt$))
;;;  (setq #R1  (nth 1 #WTpt$))
;;;  (setq #R2  (nth 2 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; �ݸ�O�`�_��
  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; ����ł��Ȃ�==>"ĸ"
    (progn
      (cond
        ((= &WTLR "R")(setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$)));�E����̂Ƃ�
        ((= &WTLR "L")(setq #distR (GetDistLineToPline (list #L1 #L2) #SNKpt$)));������̂Ƃ�
        (T            (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$)));�H����̂Ƃ� 01/12/12 YM ADD
      );_cond
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�W�����@: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�����@:   " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-�ݸ�W�����@: " (rtos #DimA)))
      (princ (strcat "\n WT-�ݸ�����@:   " (rtos #distR)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n�W��ܰ�į�߂ł͂���܂���B"))
      (command "._ucs" "P")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckIS

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckIG
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(ж�� I�^�p)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 01/02/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckIG (
  &ret$     ; �W���������@ؽ�
  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  &WTLR     ; ���E�̏���
  /
  #ANG #DIMB #DISTL #ERRFLG #GASPT$ #L1 #L2 #R1 #R2 #STD_FLG #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimB  (nth 1 &ret$)) ; ���@B
;L1+---------------------------+R1
;  | B +----+                  |
;  |<->|��� |                  |
;  |   +----+                  |
;L2+---------------------------+R2

;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
  (setq #x1 (nth 1 #WTpt$)) ; WT�E��_
  ;;; WT����(0,0)�Ƃ���UCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

; 02/12/06 YM ���W�b�N�ύX�΂߶�ĂŌ듮��
  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (polar #L1 (- #ang (dtr 90)) 1000))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (polar #R1 (- #ang (dtr 90)) 1000))

; 02/12/06 YM ���W�b�N�ύX�΂߶�ĂŌ듮��
;;;  (setq #L1  (nth 0 #WTpt$))
;;;  (setq #L2  (last  #WTpt$))
;;;  (setq #R1  (nth 1 #WTpt$))
;;;  (setq #R2  (nth 2 #WTpt$))

  (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ��ۊO�`�_��
  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; ����ł��Ȃ�==>"ĸ"
    (progn
      (cond
        ((= &WTLR "R")(setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))); �E����̂Ƃ�
        ((= &WTLR "L")(setq #distL (GetDistLineToPline (list #R1 #R2) #GASpt$))); ������̂Ƃ�
        (T            (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))); ? ����̂Ƃ����E���� 01/12/12 YM
      );_cond
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-��ەW�����@: " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-��ێ����@:   " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-��ەW�����@: " (rtos #DimB)))
      (princ (strcat "\n WT-��ێ����@:   " (rtos #distL)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n�W��ܰ�į�߂ł͂���܂���B"))
      (command "._ucs" "P")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckIG

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckIGDAN
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(ж�� �l��L�^J���ݺ�ۑ�)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 01/03/24 YM
;;; <���l>      : �i����ۑ���ۂȂ��΂߶��
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckIGDAN (
  &ret$     ; �W���������@ؽ�
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  /
  #ANG #DIMB #DIST #ERRFLG #L1 #L2 #R1 #R2 #STD_FLG #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimB  (nth 0 &ret$)) ; ���@B(��ۑ��Ԍ�)
;         B
;L1+---------------+R1
;  |
;  |  �E����
;  |
;L2+------+R2

;         B
;L1+---------------+R1
;   .              |
;    .  �E����     |
;     .            |
;       L2+--------+R2

;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
  (setq #x1 (nth 1 #WTpt$)) ; WT�E��_
  ;;; WT����(0,0)�Ƃ���UCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; ����ł��Ȃ�==>"ĸ"
    (progn
      (setq #dist (distance #L1 #R1))
      (if (not (equal #dist #DimB 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " ��ەW���Ԍ�: " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " ��ۊԌ�����: " (rtos #dist)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n ��ەW���Ԍ�: " (rtos #DimB)))
      (princ (strcat "\n ��ۊԌ�����: " (rtos #dist)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n�W��ܰ�į�߂ł͂���܂���B"))
      (command "._ucs" "P")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckIGDAN

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckIGDAN2
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(ж�� �l��L�^J���ݺ�ۑ�)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 01/07/06 YM
;;; <���l>      : SK���ڽ�i����ۑ���ۂȂ��΂߶��(���@A�͒Z����)
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckIGDAN2 (
  &ret$     ; �W���������@ؽ�
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  /
  #ANG #DIMB #DIST #ERRFLG #L1 #L2 #R1 #R2 #STD_FLG #WTBASE #WTPT$ #X1 #Y1
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimB  (nth 0 &ret$)) ; ���@B(��ۑ��Ԍ�)
;         B
;L1+---------------+R1
;  |
;  |  �E����
;  |
;L2+------+R2

;         B
;L1+---------------+R1
;   .              |
;    .  �E����     |
;     .            |
;       L2+--------+R2

;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
  (setq #x1 (nth 1 #WTpt$)) ; WT�E��_
  ;;; WT����(0,0)�Ƃ���UCS
  (setq #ang (angle #WTbase #x1))
  (setq #y1 (polar #WTbase (+ #ang (dtr 90)) 1000))
  (command "._ucs" "3" #WTbase #x1 #y1)

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))

  (setq #Errflg nil)
  (if #Errflg
    (setq #STD_flg nil) ; ����ł��Ȃ�==>"ĸ"
    (progn
      (setq #dist (distance #L2 #R2))
;;;     (setq #dist (distance #L1 #R1))
      (if (not (equal #dist #DimB 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " ��ەW���Ԍ�: " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " ��ۊԌ�����: " (rtos #dist)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n ��ەW���Ԍ�: " (rtos #DimB)))
      (princ (strcat "\n ��ۊԌ�����: " (rtos #dist)))
      (princ "\n--------------------------------------------")
      (if (= #STD_flg nil)(princ "\n�W��ܰ�į�߂ł͂���܂���B"))
      (command "._ucs" "P")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeckIGDAN2

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckL
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(ж�� ���ڽL�^�p)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 01/02/12 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckL (
  &ret$     ; �W���������@ؽ�
  &SnkP     ; SINK PMEN PLINE
  &GasP     ; GAS  PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  &WTLR     ; ���E�̏���
  /
  #DIMA #DIMB #DISTL #DISTR #GASPT$ #P1 #P2 #P3 #P4 #P5 #P6 #SNKPT$ #STD_FLG #WTBASE #WTPT$
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA (nth 0 &ret$)) ; ���@A
  (setq #DimB (nth 1 &ret$)) ; ���@B

; �E����   X1
;  p1------*-------------------+p2
;  |       |    +--------+  A  |
;  |       |    |  �ݸ   |<--->|
;  |       |    +--------+     |
;X2*------ p4------------------+p3
;  |       |
;  |       |
;  | +---+ |
;  | |���| |
;  | +---+ |
;  |   |   |
;  |   |B  |
;  |   |   |
;  p6------p5

;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
  (setq #p1 (nth 0 #WTpt$))
  (setq #p2 (nth 1 #WTpt$))
  (setq #p3 (nth 2 #WTpt$))
  (setq #p4 (nth 3 #WTpt$))
  (setq #p5 (nth 4 #WTpt$))
  (setq #p6 (nth 5 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; �ݸ�O�`�_��
  (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ��ۊO�`�_��

  ; 01/12/12 YM ADD "?"����Ή�
  (cond
    ((= &WTLR "R") ; �E����̂Ƃ�
      ; �E��������
      (setq #distR (GetDistLineToPline (list #p2 #p3) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      ; ����������
      (setq #distL (GetDistLineToPline (list #p5 #p6) #GASpt$))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�W�����@      : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�����@        : " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " WT-��ەW�����@      : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-��ێ����@        : " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-�ݸ�W�����@      : " (rtos #DimA)))
      (princ (strcat "\n WT-�ݸ�����@        : " (rtos #distR)))
      (princ (strcat "\n WT-��ەW�����@      : " (rtos #DimB)))
      (princ (strcat "\n WT-��ێ����@        : " (rtos #distL)))
      (princ "\n--------------------------------------------")
    )
    ((= &WTLR "L") ; ������̂Ƃ�
      ; �E��������
      (setq #distL (GetDistLineToPline (list #p5 #p6) #SNKpt$))
      (if (not (equal #distL #DimA 0.1))(setq #STD_flg nil))
      ; ����������
      (setq #distR (GetDistLineToPline (list #p2 #p3) #GASpt$))
      (if (not (equal #distR #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�W�����@      : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�����@        : " (rtos #distL)))
      (CFOutStateLog 1 1 (strcat " WT-��ەW�����@      : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-��ێ����@        : " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-�ݸ�W�����@      : " (rtos #DimA)))
      (princ (strcat "\n WT-�ݸ�����@        : " (rtos #distL)))
      (princ (strcat "\n WT-��ەW�����@      : " (rtos #DimB)))
      (princ (strcat "\n WT-��ێ����@        : " (rtos #distR)))
      (princ "\n--------------------------------------------")

    )
    (T  ; ?����̂Ƃ�
      ; �E��������
      (setq #distR (GetDistLineToPline (list #p2 #p3) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      ; ����������
      (setq #distL (GetDistLineToPline (list #p5 #p6) #GASpt$))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�W�����@      : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " WT-�ݸ�����@        : " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " WT-��ەW�����@      : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " WT-��ێ����@        : " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n--------------------------------------------")
      (princ (strcat "\n WT-�ݸ�W�����@      : " (rtos #DimA)))
      (princ (strcat "\n WT-�ݸ�����@        : " (rtos #distR)))
      (princ (strcat "\n WT-��ەW�����@      : " (rtos #DimB)))
      (princ (strcat "\n WT-��ێ����@        : " (rtos #distL)))
      (princ "\n--------------------------------------------")
    )

  );_if
  (if (= #STD_flg nil)(princ "\n�W��ܰ�į�߂ł͂���܂���B"))
  #STD_flg
);KP_Std_DimCHeckL

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeckLDAN
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(ж�� ���ڽL�^J���ݗp)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 01/03/23 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeckLDAN (
  &ret$     ; �W���������@ؽ�
  &SnkP     ; SINK PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  &WTLR     ; ���E�̏���
  /
  #DIMA #DIMB #DISTL #DISTR #P1 #P2 #P3 #P4 #P5 #P6 #SNKPT$ #STD_FLG #WTBASE #WTPT$
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$ #WTbase (nth 0 &WTpt$))
  (setq #DimA (nth 0 &ret$)) ; ���@A
  (setq #DimB (nth 1 &ret$)) ; ���@B

; �E����
;  p1--------------------------+p2
;  |            +--------+  A  |
;  |            |  �ݸ   |<--->|
; B|            +--------+     |
;  |       p4------------------+p3
;  |       |
;  p6------p5

; ������
;  p1----------+p2
;  |           |
;  |           |B
;  |           |
;  |       p4--+p3
;  |       |
;  | +---+ |
;  | |   | |
;  | +---+ |
;  |       |
;  |   A   |
;  |       |
;  p6------p5

;;; PLINE �ƒ����̋��������߂邽�߂́A�����̒[�_���W
  (setq #p1 (nth 0 #WTpt$))
  (setq #p2 (nth 1 #WTpt$))
  (setq #p3 (nth 2 #WTpt$))
  (setq #p4 (nth 3 #WTpt$))
  (setq #p5 (nth 4 #WTpt$))
  (setq #p6 (nth 5 #WTpt$))

  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; �ݸ�O�`�_��

  ; 01/12/12 YM ADD "?"����Ή�
  (cond
    ((= &WTLR "R") ; �E����̂Ƃ�
      ; �E��������
      (setq #distR (GetDistLineToPline (list #p2 #p3) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      ; ��ۑ�������
      (setq #distL (distance #p1 #p6))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " �W���ݸ�e���@   : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " ���ݸ�e�����@   : " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " �W����ۑ��Ԍ�   : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " ����ۑ��Ԍ�     : " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n-----------------------------------------")
      (princ (strcat "\n �W���ݸ�e���@   : " (rtos #DimA)))
      (princ (strcat "\n ���ݸ�e�����@   : " (rtos #distR)))
      (princ (strcat "\n �W����ۑ��Ԍ�   : " (rtos #DimB)))
      (princ (strcat "\n ����ۑ��Ԍ�     : " (rtos #distL)))
      (princ "\n-----------------------------------------")

    )
    ((= &WTLR "L") ; ������̂Ƃ�
      ; �ݸ�e(����)������
      (setq #distL (GetDistLineToPline (list #p5 #p6) #SNKpt$))
      (if (not (equal #distL #DimA 0.1))(setq #STD_flg nil))
      ; ���Α�(�E��)������
      (setq #distR (distance #p1 #p2))
      (if (not (equal #distR #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " �W���ݸ�e���@   : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " �ݸ���e�����@   : " (rtos #distL)))
      (CFOutStateLog 1 1 (strcat " �W����ۑ��Ԍ�   : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " ��ۑ��Ԍ������@ : " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n-----------------------------------------")
      (princ (strcat "\n �W���ݸ�e���@   : " (rtos #DimA)))
      (princ (strcat "\n �ݸ���e�����@   : " (rtos #distL)))
      (princ (strcat "\n �W����ۑ��Ԍ�   : " (rtos #DimB)))
      (princ (strcat "\n ��ۑ��Ԍ������@ : " (rtos #distR)))
      (princ "\n-----------------------------------------")

    )
    (T ; ?����̂Ƃ�
      ; �E��������
      (setq #distR (GetDistLineToPline (list #p2 #p3) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      ; ��ۑ�������
      (setq #distL (distance #p1 #p6))
      (if (not (equal #distL #DimB 0.1))(setq #STD_flg nil))

      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " �W���ݸ�e���@   : " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " ���ݸ�e�����@   : " (rtos #distR)))
      (CFOutStateLog 1 1 (strcat " �W����ۑ��Ԍ�   : " (rtos #DimB)))
      (CFOutStateLog 1 1 (strcat " ����ۑ��Ԍ�     : " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")

      (princ "\n-----------------------------------------")
      (princ (strcat "\n �W���ݸ�e���@   : " (rtos #DimA)))
      (princ (strcat "\n ���ݸ�e�����@   : " (rtos #distR)))
      (princ (strcat "\n �W����ۑ��Ԍ�   : " (rtos #DimB)))
      (princ (strcat "\n ����ۑ��Ԍ�     : " (rtos #distL)))
      (princ "\n-----------------------------------------")

    )

  );_if

  #STD_flg
);KP_Std_DimCHeckLDAN

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeck_RLS
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(WK ��߽L�^�ݸ���p)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 00/12/20 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeck_RLS (
  &ret$     ; �W���������@ؽ�
  &SnkP     ; SINK PMEN PLINE
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  &cutTYPE  ; WT�������
  /
  #DIMA #DIMB1 #DISTL #DISTR #L1 #L2 #R1 #R2 #SNKPT$ #STD_FLG #WTPT$ #X1
  )
  (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
  (setq #WTpt$ &WTpt$)
  (setq #DimA  (nth 0 &ret$)) ; ���@A
  (setq #DimB1 (nth 1 &ret$)) ; ���@B1

; �΂߶��(�E����)
;L1+----@X1--------------------+R1
;       |       +--------+  A  |
;       |  B1   |  �ݸ   |<--->|
;       <------>+--------+     |
;     L2+----------------------+R2

; �΂߶��(������)
;L1+----------------------@X1--+R1
;  |   A   +--------+     |
;  |<----->|  �ݸ   |  B1 |
;  |       +--------+<---->
;L2+----------------------+R2

  (setq #L1  (nth 0 #WTpt$))
  (setq #L2  (last  #WTpt$))
  (setq #R1  (nth 1 #WTpt$))
  (setq #R2  (nth 2 #WTpt$))
  (setq #SNKpt$ (GetLWPolyLinePt &SnkP)) ; �ݸ�O�`�_��

  (if (= (substr &cutTYPE 1 1) "3")
    (progn ; �E����̂Ƃ�(�����΂߶��)
      (setq #x1 (CFGetDropPt #L2 (list #L1 #R1)))
      ; �E��������
      (setq #distR (GetDistLineToPline (list #R1 #R2) #SNKpt$))
      (if (not (equal #distR #DimA 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " L�^��߽WT-�ݸ�W�����@A: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " L�^��߽WT-�ݸ�����@:    " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")
      ; ����������
      (setq #distL (GetDistLineToPline (list #X1 #L2) #SNKpt$))
      (if (not (equal #distL #DimB1 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " L�^��߽WT-�ݸ�W�����@B1: " (rtos #DimB1)))
      (CFOutStateLog 1 1 (strcat " L�^��߽WT-�ݸ�����@:     " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")
    )
  );_if

  (if (= (substr &cutTYPE 2 1) "3")
    (progn ; ������̂Ƃ�(�E���΂߶��)
      (setq #x1 (CFGetDropPt #R2 (list #L1 #R1)))
      ; �E��������
      (setq #distR (GetDistLineToPline (list #X1 #R2) #SNKpt$))
      (if (not (equal #distR #DimB1 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " L�^��߽WT-�ݸ�W�����@B1: " (rtos #DimB1)))
      (CFOutStateLog 1 1 (strcat " L�^��߽WT-�ݸ�����@:     " (rtos #distR)))
      (CFOutStateLog 1 1 "--------------------------------------------")
      ; ����������
      (setq #distL (GetDistLineToPline (list #L1 #L2) #SNKpt$))
      (if (not (equal #distL #DimA 0.1))(setq #STD_flg nil))
      (CFOutStateLog 1 1 "--------------------------------------------")
      (CFOutStateLog 1 1 (strcat " L�^��߽WT-�ݸ�W�����@A: " (rtos #DimA)))
      (CFOutStateLog 1 1 (strcat " L�^��߽WT-�ݸ�����@:    " (rtos #distL)))
      (CFOutStateLog 1 1 "--------------------------------------------")
    )
  );_if
  #STD_flg
);KP_Std_DimCHeck_RLS

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_Std_DimCHeck_RLG
;;; <�����T�v>  : �W��WT���ǂ����̐��@����(WK ��߽L�^��ۑ��p)
;;; <�߂�l>    : �W��:T �W���ȊO:nil
;;; <�쐬>      : 00/12/20 YM
;;; <���l>      : ��ی�W600�łȂ��Ɣ���s�v(�W��WT�łȂ�)
;;;*************************************************************************>MOH<
(defun KP_Std_DimCHeck_RLG (
  &ret$     ; �W���������@ؽ�
  &GasP     ; GAS  PMEN PLINE
  &eGAS     ; ��ۼ���ِ}�`
  &WTpt$    ; WT�O�`�_��(WT����_���玞�v�܂��)
  &cutTYPE  ; WT�������
  /
  #DIMB2 #DIMC #DISTL #DISTR #GASPT$ #L1 #L2 #R1 #R2 #STD_FLG #WTPT$ #X1
  )
  (if (equal (nth 3 (CFGetXData &eGAS "G_SYM")) 600 0.1) ; ��ې��@W
    (progn ; ������s��
      (setq #STD_flg T) ; �W�����@==>T �W���łȂ�==>nil �ŏ��W���Ɖ���
      (setq #WTpt$ &WTpt$)
      (setq #DimB2 (nth 2 &ret$)) ; ���@B2
      (setq #DimC  (nth 3 &ret$)) ; ���@C

    ; �΂߶��(�E����)
    ;L1+----@X1--------------------+R1
    ;       |       +--------+  C  |
    ;       |  B2   |  ���   |<--->|
    ;       <------>+--------+     |
    ;     L2+----------------------+R2

    ; �΂߶��(������)
    ;L1+----------------------@X1--+R1
    ;  |   C   +--------+     |
    ;  |<----->|  ���   |  B2 |
    ;  |       +--------+<---->
    ;L2+----------------------+R2

      (setq #L1  (nth 0 #WTpt$))
      (setq #L2  (last  #WTpt$))
      (setq #R1  (nth 1 #WTpt$))
      (setq #R2  (nth 2 #WTpt$))
      (setq #GASpt$ (GetLWPolyLinePt &GasP)) ; ��ۊO�`�_��

      (if (= (substr &cutTYPE 1 1) "3")
        (progn ; �E����̂Ƃ�(�����΂߶��)
          (setq #x1 (CFGetDropPt #L2 (list #L1 #R1)))
          ; �E��������
          (setq #distR (GetDistLineToPline (list #R1 #R2) #GASpt$))
          (if (not (equal #distR #DimC 0.1))(setq #STD_flg nil))
          (CFOutStateLog 1 1 "--------------------------------------------")
          (CFOutStateLog 1 1 (strcat " L�^��߽WT-��ەW�����@C: " (rtos #DimC)))
          (CFOutStateLog 1 1 (strcat " L�^��߽WT-��ێ����@:    " (rtos #distR)))
          (CFOutStateLog 1 1 "--------------------------------------------")
          ; ����������
          (setq #distL (GetDistLineToPline (list #X1 #L2) #GASpt$))
          (if (not (equal #distL #DimB2 0.1))(setq #STD_flg nil))
          (CFOutStateLog 1 1 "--------------------------------------------")
          (CFOutStateLog 1 1 (strcat " L�^��߽WT-��ەW�����@B2: " (rtos #DimB2)))
          (CFOutStateLog 1 1 (strcat " L�^��߽WT-��ێ����@:     " (rtos #distL)))
          (CFOutStateLog 1 1 "--------------------------------------------")
        )
      );_if

      (if (= (substr &cutTYPE 2 1) "3")
        (progn ; ������̂Ƃ�(�E���΂߶��)
          (setq #x1 (CFGetDropPt #R2 (list #L1 #R1)))
          ; �E��������
          (setq #distR (GetDistLineToPline (list #X1 #R2) #GASpt$))
          (if (not (equal #distR #DimB2 0.1))(setq #STD_flg nil))
          (CFOutStateLog 1 1 "--------------------------------------------")
          (CFOutStateLog 1 1 (strcat " L�^��߽WT-��ەW�����@B2: " (rtos #DimB2)))
          (CFOutStateLog 1 1 (strcat " L�^��߽WT-��ێ����@:     " (rtos #distR)))
          (CFOutStateLog 1 1 "--------------------------------------------")
          ; ����������
          (setq #distL (GetDistLineToPline (list #L1 #L2) #GASpt$))
          (if (not (equal #distL #DimC 0.1))(setq #STD_flg nil))
          (CFOutStateLog 1 1 "--------------------------------------------")
          (CFOutStateLog 1 1 (strcat " L�^��߽WT-��ەW�����@C: " (rtos #DimC)))
          (CFOutStateLog 1 1 (strcat " L�^��߽WT-��ێ����@:    " (rtos #distL)))
          (CFOutStateLog 1 1 "--------------------------------------------")
        )
      );_if
    )
    (progn ; ����s�v
      (setq #STD_flg nil)
    )
  );_if
  #STD_flg
);KP_Std_DimCHeck_RLG

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetDistLineToPline
;;; <�����T�v>  : PLINE�̊e�_���璼���ɉ��낵�����������̍ŏ������߂�
;;;               ���҂������΁@-999 ��Ԃ�
;;; <�߂�l>    : PLINE�̊e�_���璼���ɉ��낵�����������̍ŏ�(����)
;;; <�쐬>      : 00/10/27 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun GetDistLineToPline (
  &line$ ; �����̎n�_,�I�_ؽ�
  &pt$   ; PLINE�O�`�_��
  /
  #DIS #DIS_MIN
  )
  (setq #dis_min 1.0e+10)
  (if (PKDirectPT &pt$ &line$) ; �_�񂪂��ׂĒ���&ret_lis$�̓������ɂ��� = nil �Ȃ� T
    (setq #dis_min -999)
    (progn
      (foreach #pt &pt$
        (setq #dis (distance #pt (CFGetDropPt #pt &line$))) ; �����ɂ��낵�������̒���
        (if (<= #dis #dis_min)
          (setq #dis_min #dis) ; ������PMEN�̍ŒZ���� = #dis_min
        );_if
      )
    )
  );_if
  #dis_min
);GetDistLineToPline

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetDistPlineToPlineX
;;; <�����T�v>  : PLINE��PLINE�̍ŒZ����(����)�����߂�(�ݸ��)
;;; <�߂�l>    : PLINE��PLINE�̍ŒZ����(����)
;;; <�쐬>      : 00/10/27 YM
;;; <���l>      : UCS��v�s�z�u�p�x=0��O��
;;;*************************************************************************>MOH<
(defun GetDistPlineToPlineX (
  &pt1$   ; �ݸPLINE�O�`�_��
  &pt2$   ; ���PLINE�O�`�_��
  /
  #DIS_MIN #MAX1 #MAX2 #MIN1 #MIN2 #X1$ #X2$ #PT1$ #PT2$
  )
  (setq #pt1$ '())
  (setq #pt2$ '())
  (foreach #p1 &pt1$
    (setq #pt1$ (append #pt1$ (list (trans #p1 0 1)))) ; հ�ް���W�n�ɕϊ�
  )
  (foreach #p2 &pt2$
    (setq #pt2$ (append #pt2$ (list (trans #p2 0 1)))) ; հ�ް���W�n�ɕϊ�
  )
  (setq #x1$ (mapcar 'car #pt1$))
  (setq #x2$ (mapcar 'car #pt2$))
  (setq #max1 (apply 'max #x1$))
  (setq #min1 (apply 'min #x1$))
  (setq #max2 (apply 'max #x2$))
  (setq #min2 (apply 'min #x2$))
  (if (< #max1 #min2)
    (setq #dis_min (- #min2 #max1))
    (setq #dis_min (- #min1 #max2))
  );_if
);GetDistPlineToPlineX

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetDistPlineToPlineY
;;; <�����T�v>  : PLINE��PLINE�̍ŒZ����(����)�����߂�(��ۑ�)
;;; <�߂�l>    : PLINE��PLINE�̍ŒZ����(����)
;;; <�쐬>      : 00/10/27 YM
;;; <���l>      : UCS��v�s�z�u�p�x=0��O��
;;;*************************************************************************>MOH<
(defun GetDistPlineToPlineY (
  &pt1$   ; �ݸPLINE�O�`�_��
  &pt2$   ; ���PLINE�O�`�_��
  /
  #DIS_MIN #MAX1 #MAX2 #MIN1 #MIN2 #Y1$ #Y2$ #PT1$ #PT2$
  )
  (setq #pt1$ '())
  (setq #pt2$ '())
  (foreach #p1 &pt1$
    (setq #pt1$ (append #pt1$ (list (trans #p1 0 1)))) ; հ�ް���W�n�ɕϊ�
  )
  (foreach #p2 &pt2$
    (setq #pt2$ (append #pt2$ (list (trans #p2 0 1)))) ; հ�ް���W�n�ɕϊ�
  )
  (setq #y1$ (mapcar 'cadr #pt1$))
  (setq #y2$ (mapcar 'cadr #pt2$))
  (setq #max1 (apply 'max #y1$))
  (setq #min1 (apply 'min #y1$))
  (setq #max2 (apply 'max #y2$))
  (setq #min2 (apply 'min #y2$))
  (if (< #max1 #min2)
    (setq #dis_min (- #min2 #max1))
    (setq #dis_min (- #min1 #max2))
  );_if
);GetDistPlineToPlineY

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KP_GetStdDim
;;; <�����T�v>  : �W��WT���ǂ������肷��e�퐡�@�l�𓾂�
;;; <�߂�l>    : ���X�g (���@A,���@B,���@C)
;;; <�쐬>      : 01/02/12 YM
;;; <���l>      : �Ԍ�1,2�ͼݸ��,��ۑ��̏��ň����n��
;                  Genic,Notil,Cena�p
;;; ***********************************************************************************>MOH<
(defun KP_GetStdDim (
  &MAG1    ; �Ԍ�1 "2550"
  &MAG2    ; �Ԍ�2 "0" "1650"
  &WT_type ; WT���� "I","L"
  &ZaiF    ; �f�� 0,1
  &SNK     ; �ݸ�L��"SA"
  &WTLR    ; ����
  &Type    ; ���� "F" or "J"
  /
  #DIMA #DIMB #DIMC #ERR1 #QRY$$ #RET$ #ZAIF #msg
  )
  (setq #msg "�W��WT�̔��肪�ł��܂���ł����B")
  ; ��������
  (if (and &MAG1 &MAG2 &WT_type &ZaiF &SNK &WTLR &Type)
    (progn
      (setq #Err1 nil)
      (setq #ZaiF (itoa (fix &ZaiF)))
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "�W��WT���@"
          (list
            (list "�Ԍ�1"      &MAG1    'INT)
            (list "�Ԍ�2"      &MAG2    'INT)
            (list "WT�`��"     &WT_type 'STR)
            (list "�^�C�v"     &Type    'STR)
            (list "�f��F"      #ZaiF    'INT)
            (list "�V���N�L��" &SNK     'STR)
          )
        )
      )
      (if #qry$$
        (progn
          (CFOutStateLog 1 1 "---�W��WT�V���N-----------------------------")
          (CFOutStateLog 1 1 #qry$$)
          (CFOutStateLog 1 1 (strcat "�Ԍ�1     :" &MAG1))
          (CFOutStateLog 1 1 (strcat "�Ԍ�2     :" &MAG2))
          (CFOutStateLog 1 1 (strcat "WT�`��    :" &WT_type))
          (CFOutStateLog 1 1 (strcat "�^�C�v    :" &Type))
          (CFOutStateLog 1 1 (strcat "�f��F     :" #ZaiF))
          (CFOutStateLog 1 1 (strcat "�V���N�L��:" &SNK))

          (setq #ret$ nil)
          (foreach #qry$ #qry$$
            (CFOutStateLog 1 1 "--------------------------------------------")
            (setq #DimA (nth 7 #qry$)) ; ���@A
            (setq #DimB (nth 8 #qry$)) ; ���@B
            (setq #DimC (nth 9 #qry$)) ; ���@C
            (setq #ret$ (append #ret$ (list (list #DimA #DimB #DimC))))
            (CFOutStateLog 1 1 (strcat "���@A     :" (rtos #DimA)))
            (CFOutStateLog 1 1 (strcat "���@B     :" (rtos #DimB)))
            (CFOutStateLog 1 1 (strcat "���@C     :" (rtos #DimC)))
          )
          (CFOutStateLog 1 1 "--------------------------------------------")
        )
        (progn
          (setq #Err1 T) ; ں��ނȂ�
          (CFAlertMsg (strcat #msg "ں��ނ�����܂���B"))
        )
      );_if
    )
    (progn
      (setq #Err1 T) ; ����nil
      (CFAlertMsg (strcat #msg  "������������܂���B"))
    )
  );_if

  (if #Err1
    nil
    #ret$
  );_if
);KP_GetStdDim

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KP_GetStdDimS&S
;;; <�����T�v>  : �W��WT���ǂ������肷��e�퐡�@�l�𓾂�
;;; <�߂�l>    : ���X�g (���@A,���@B,���@C)
;;; <�쐬>      : 01/07/03 YM
;;; <���l>      :
;;; ***********************************************************************************>MOH<
(defun KP_GetStdDimS&S (
  &MAG1    ; �Ԍ�1 "2550"
  &WT_type ; WT���� "I","L"
  &ZaiF    ; �f�� 0,1
  &SNK     ; �ݸ�L��"SA"
  &WTLR    ; ����
  &Type    ; ���� "F" or "J"
  /
  #DIMA #DIMB #DIMC #ERR1 #QRY$$ #RET$ #ZAIF #msg
  )
  (setq #msg "�W��WT�̔��肪�ł��܂���ł����B")
  ; ��������
  (if (and &MAG1 &WT_type &ZaiF &SNK &WTLR &Type)
    (progn
      (setq #Err1 nil)
      (setq #ZaiF (itoa (fix &ZaiF)))
      (setq #qry$$
        (CFGetDBSQLRec CG_DBSESSION "�W��WT���@"
          (list
            (list "�Ԍ�1"      &MAG1    'INT)
            (list "WT�`��"     &WT_type 'STR)
            (list "�^�C�v"     &Type    'STR)
            (list "�f��F"      #ZaiF    'INT)
            (list "�V���N�L��" &SNK     'STR)
          )
        )
      )
      (if #qry$$
        (progn
          (CFOutStateLog 1 1 "---�W��WT�V���N-----------------------------")
          (CFOutStateLog 1 1 #qry$$)
          (CFOutStateLog 1 1 (strcat "�Ԍ�1     :" &MAG1))
          (CFOutStateLog 1 1 (strcat "WT�`��    :" &WT_type))
          (CFOutStateLog 1 1 (strcat "�^�C�v    :" &Type))
          (CFOutStateLog 1 1 (strcat "�f��F     :" #ZaiF))
          (CFOutStateLog 1 1 (strcat "�V���N�L��:" &SNK))

          (setq #ret$ nil)
          (foreach #qry$ #qry$$
            (CFOutStateLog 1 1 "--------------------------------------------")
            (setq #DimA (nth 7 #qry$)) ; ���@A
            (setq #DimB (nth 8 #qry$)) ; ���@B
            (setq #DimC (nth 9 #qry$)) ; ���@C
            (setq #ret$ (append #ret$ (list (list #DimA #DimB #DimC))))
            (CFOutStateLog 1 1 (strcat "���@A     :" (rtos #DimA)))
            (CFOutStateLog 1 1 (strcat "���@B     :" (rtos #DimB)))
            (CFOutStateLog 1 1 (strcat "���@C     :" (rtos #DimC)))
          )
          (CFOutStateLog 1 1 "--------------------------------------------")
        )
        (progn
          (setq #Err1 T) ; ں��ނȂ�
          (CFAlertMsg (strcat #msg "ں��ނ�����܂���B"))
        )
      );_if
    )
    (progn
      (setq #Err1 T) ; ����nil
      (CFAlertMsg (strcat #msg  "������������܂���B"))
    )
  );_if

  (if #Err1
    nil
    #ret$
  );_if
);KP_GetStdDimS&S

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; �ȉ����g�p WT���H����� 01/07/25 YM
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;01/07/25YM@;;; <HOM>***********************************************************************************
;;;01/07/25YM@;;; <�֐���>    : KPRendDig
;;;01/07/25YM@;;; <�����T�v>  : �q�G���h���H���_�C�A���O
;;;01/07/25YM@;;; <�߂�l>    : (���H��,R[�a]) ���H��="1"����,"2"�E��,"3"�E��,"4"����
;;;01/07/25YM@;;; <�쐬>      : 00/07/25 YM
;;;01/07/25YM@;;; <���l>      : ���g�p
;;;01/07/25YM@;;; ***********************************************************************************>MOH<
;;;01/07/25YM@(defun KPRendDig (
;;;01/07/25YM@  &sX ; R���މ\�� "Right","Left","LeftRight"
;;;01/07/25YM@  &CutType ; "00","30"�Ȃ� 0:��ĂȂ�,1:J���,2:Y���,3:45�x���,4:�i���ڑ�(�`��)
;;;01/07/25YM@  &rDid$   ; R���މ۔��萡�@ؽ�(WT���s��,WT���Ӓ���)
;;;01/07/25YM@  /
;;;01/07/25YM@  #DCL_ID #FX #FY #RET$
;;;01/07/25YM@  )
;;;01/07/25YM@  (CFOutStateLog 1 1 " ")
;;;01/07/25YM@  (CFOutStateLog 1 1 "//// KPRendDig ////")
;;;01/07/25YM@  (CFOutStateLog 1 1 " ")
;;;01/07/25YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/07/25YM@          (defun ##GetDlgItem (
;;;01/07/25YM@            /
;;;01/07/25YM@
;;;01/07/25YM@            )
;;;01/07/25YM@            ; R���މ��H
;;;01/07/25YM@            (setq #tgl_LU (get_tile "tgl_LU"))
;;;01/07/25YM@            (setq #tgl_RU (get_tile "tgl_RU"))
;;;01/07/25YM@            (setq #tgl_LD (get_tile "tgl_LD"))
;;;01/07/25YM@            (setq #tgl_RD (get_tile "tgl_RD"))
;;;01/07/25YM@            ; �ޯ��ް��
;;;01/07/25YM@            (setq #tgl_BG_U  (get_tile "tgl_BG_U"))
;;;01/07/25YM@            (setq #tgl_BG_L  (get_tile "tgl_BG_L"))
;;;01/07/25YM@            (setq #tgl_BG_R  (get_tile "tgl_BG_R"))
;;;01/07/25YM@            ; �O����
;;;01/07/25YM@            (setq #tgl_FG_L  (get_tile "tgl_FG_L"))
;;;01/07/25YM@            (setq #tgl_FG_U  (get_tile "tgl_FG_U"))
;;;01/07/25YM@            (setq #tgl_FG_D  (get_tile "tgl_FG_D"))
;;;01/07/25YM@            (setq #tgl_FG_R  (get_tile "tgl_FG_R"))
;;;01/07/25YM@            ; R(�a)
;;;01/07/25YM@            (setq #r-kei (get_tile "r-kei"))
;;;01/07/25YM@
;;;01/07/25YM@            (list #tgl_LU #tgl_RU #tgl_LD #tgl_RD #tgl_U #tgl_L #tgl_R)
;;;01/07/25YM@          )
;;;01/07/25YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/07/25YM@          ; R���މ��H�̗L���ɂ��FG��t���ۂ�ύX
;;;01/07/25YM@          (defun ##Check_BGtgl ( / )
;;;01/07/25YM@            ; R(�a)
;;;01/07/25YM@            (if (or (= "1" (get_tile "tgl_LU"))(= "1" (get_tile "tgl_LD"))
;;;01/07/25YM@                    (= "1" (get_tile "tgl_RU"))(= "1" (get_tile "tgl_RD")))
;;;01/07/25YM@              (mode_tile "r-kei" 0) ; R���ނǂꂩ��������������==>�g�p�\
;;;01/07/25YM@              (progn
;;;01/07/25YM@                (set_tile "r-kei" "")
;;;01/07/25YM@                (mode_tile "r-kei" 1) ; �g�p�֎~
;;;01/07/25YM@              )
;;;01/07/25YM@            );_if
;;;01/07/25YM@
;;;01/07/25YM@            ; ����or��,�E��or��R���މ��H����==>�E or ���O���ꋭ���I�ɂ���
;;;01/07/25YM@            (if (or (= "1" (get_tile "tgl_LU"))(= "1" (get_tile "tgl_LD")))
;;;01/07/25YM@              (progn ; ������������
;;;01/07/25YM@                (set_tile  "tgl_FG_L" "1") ; ����
;;;01/07/25YM@                (mode_tile "tgl_FG_L" 1)   ; �g�p�֎~
;;;01/07/25YM@              )
;;;01/07/25YM@              (progn
;;;01/07/25YM@                (set_tile  "tgl_FG_L" "0") ; �����Ȃ�
;;;01/07/25YM@                (if (= #cutR "0") ; ��ĂȂ�
;;;01/07/25YM@                  (mode_tile "tgl_FG_R" 0) ; �g�p�\
;;;01/07/25YM@                  (mode_tile "tgl_FG_R" 1) ; �g�p�֎~
;;;01/07/25YM@                );_if
;;;01/07/25YM@              )
;;;01/07/25YM@            );_if
;;;01/07/25YM@            (if (or (= "1" (get_tile "tgl_RU"))(= "1" (get_tile "tgl_RD")))
;;;01/07/25YM@              (progn ; ������������
;;;01/07/25YM@                (set_tile  "tgl_FG_R" "1") ; ����
;;;01/07/25YM@                (mode_tile "tgl_FG_R" 1)   ; �g�p�֎~
;;;01/07/25YM@              )
;;;01/07/25YM@              (progn
;;;01/07/25YM@                (set_tile  "tgl_FG_R" "0") ; �����Ȃ�
;;;01/07/25YM@                ; ���EFG�Ͷ�ĂȂ��̂Ƃ��̂ݎg�p�\
;;;01/07/25YM@                (if (= #cutL "0") ; ��ĂȂ�
;;;01/07/25YM@                  (mode_tile "tgl_FG_L" 0) ; �g�p�\
;;;01/07/25YM@                  (mode_tile "tgl_FG_L" 1) ; �g�p�֎~
;;;01/07/25YM@                );_if
;;;01/07/25YM@              )
;;;01/07/25YM@            );_if
;;;01/07/25YM@
;;;01/07/25YM@            (princ)
;;;01/07/25YM@          );##Check_BGtgl
;;;01/07/25YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/07/25YM@          ; �����޲�۸ސݒ�(�Ō�܂ŕς��Ȃ�)���ڂ̸�ڲ��Ă��s��
;;;01/07/25YM@          (defun ##firstSET ( / )
;;;01/07/25YM@            ; ���EBG�� J��Ă̂Ƃ��̂ݎg�p�\
;;;01/07/25YM@            (if (= #cutL "1") ; J���
;;;01/07/25YM@              (mode_tile "tgl_BG_L" 0) ; �g�p�\
;;;01/07/25YM@              (mode_tile "tgl_BG_L" 1) ; �g�p�֎~
;;;01/07/25YM@            );_if
;;;01/07/25YM@            ; �E��BG J��Ă̂Ƃ��̂ݎg�p�\
;;;01/07/25YM@            (if (= #cutR "1") ; J���
;;;01/07/25YM@              (mode_tile "tgl_BG_R" 0) ; �g�p�\
;;;01/07/25YM@              (mode_tile "tgl_BG_R" 1) ; �g�p�֎~
;;;01/07/25YM@            );_if
;;;01/07/25YM@
;;;01/07/25YM@            ; ���EFG�Ͷ�ĂȂ��̂Ƃ��̂ݎg�p�\
;;;01/07/25YM@            (if (= #cutL "0") ; ��ĂȂ�
;;;01/07/25YM@              (mode_tile "tgl_FG_L" 0) ; �g�p�\
;;;01/07/25YM@              (mode_tile "tgl_FG_L" 1) ; �g�p�֎~
;;;01/07/25YM@            );_if
;;;01/07/25YM@            (if (= #cutR "0") ; ��ĂȂ�
;;;01/07/25YM@              (mode_tile "tgl_FG_R" 0) ; �g�p�\
;;;01/07/25YM@              (mode_tile "tgl_FG_R" 1) ; �g�p�֎~
;;;01/07/25YM@            );_if
;;;01/07/25YM@
;;;01/07/25YM@            ; �E���̂�R���މ\==>�����s�� �E��BG�s��
;;;01/07/25YM@            ; �����̂�R���މ\==>�E���s�� ����BG�s��
;;;01/07/25YM@            (cond
;;;01/07/25YM@              ((= &sX "Right")
;;;01/07/25YM@                (set_tile "tgl_LU" "0")
;;;01/07/25YM@                (set_tile "tgl_LD" "0")
;;;01/07/25YM@                (mode_tile "tgl_LU" 1)
;;;01/07/25YM@                (mode_tile "tgl_LD" 1)
;;;01/07/25YM@              )
;;;01/07/25YM@              ((= &sX "Left")
;;;01/07/25YM@                (set_tile "tgl_RU" "0")
;;;01/07/25YM@                (set_tile "tgl_RD" "0")
;;;01/07/25YM@                (mode_tile "tgl_RU" 1) ; �g�p�֎~
;;;01/07/25YM@                (mode_tile "tgl_RD" 1) ; �g�p�֎~
;;;01/07/25YM@              )
;;;01/07/25YM@              (T
;;;01/07/25YM@                nil
;;;01/07/25YM@              )
;;;01/07/25YM@            );_cond
;;;01/07/25YM@
;;;01/07/25YM@            ; R(�a)��ި���ޯ��
;;;01/07/25YM@            (mode_tile "r-kei" 1) ; �g�p�֎~
;;;01/07/25YM@            (princ)
;;;01/07/25YM@          );##Check_BGtgl
;;;01/07/25YM@;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;01/07/25YM@
;;;01/07/25YM@  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
;;;01/07/25YM@  (if (not (new_dialog "RendDlg" #dcl_id)) (exit))
;;;01/07/25YM@
;;;01/07/25YM@;;; ������ِݒ�
;;;01/07/25YM@  (setq #cutL (substr &CutType 1 1))
;;;01/07/25YM@  (setq #cutR (substr &CutType 2 1))
;;;01/07/25YM@  (##firstSET)
;;;01/07/25YM@
;;;01/07/25YM@  ; ��ق�ر���ݐݒ�
;;;01/07/25YM@  (action_tile "tgl_LU" "(##Check_BGtgl)") ; ����R���H
;;;01/07/25YM@  (action_tile "tgl_LD" "(##Check_BGtgl)") ; ����R���H
;;;01/07/25YM@  (action_tile "tgl_RU" "(##Check_BGtgl)") ; �E��R���H
;;;01/07/25YM@  (action_tile "tgl_RD" "(##Check_BGtgl)") ; �E��R���H
;;;01/07/25YM@
;;;01/07/25YM@  (action_tile "accept" "(setq #ret$ (##GetDlgItem))")
;;;01/07/25YM@  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
;;;01/07/25YM@
;;;01/07/25YM@  (setq #fX (dimx_tile "image"))
;;;01/07/25YM@  (setq #fY (dimy_tile "image"))
;;;01/07/25YM@  (start_image "image")
;;;01/07/25YM@  (fill_image  0 0 #fX #fY -0)
;;;01/07/25YM@
;;;01/07/25YM@  ;�ײ��̧��
;;;01/07/25YM@  (setq #sSLIDE (strcat CG_SYSPATH  "WT" &CutType ".sld"))
;;;01/07/25YM@  (cond
;;;01/07/25YM@    ((findfile #sSLIDE)
;;;01/07/25YM@      (slide_image 0 0 #fX (- #fY 10) #sSLIDE)
;;;01/07/25YM@    )
;;;01/07/25YM@    (t
;;;01/07/25YM@      (slide_image 0 0 #fX (- #fY 10) (strcat CG_SYSPATH "notfile.sld"))
;;;01/07/25YM@    )
;;;01/07/25YM@  );_cond
;;;01/07/25YM@  (end_image)
;;;01/07/25YM@
;;;01/07/25YM@  (start_dialog)
;;;01/07/25YM@  (unload_dialog #dcl_id)
;;;01/07/25YM@
;;;01/07/25YM@  #ret$ ; �߂�l (���H��,R[�a]) ���H��="1"����,"2"�E��,"3"�E��,"4"����
;;;01/07/25YM@);KPRendDig
;;;01/07/25YM@
;;;01/07/25YM@;<HOM>*************************************************************************
;;;01/07/25YM@; <�֐���>    : C:RendWT_test
;;;01/07/25YM@; <�����T�v>  : ���[�N�g�b�v�̒[���q���ނɂ���(ýėp)
;;;01/07/25YM@; <�߂�l>    : �Ȃ�
;;;01/07/25YM@; <�쐬>      : 01/07/25 YM
;;;01/07/25YM@; <���l>      :
;;;01/07/25YM@;*************************************************************************>MOH<
;;;01/07/25YM@(defun C:RendWT_test (
;;;01/07/25YM@  /
;;;01/07/25YM@  #ARC1 #ARC2 #BASEPT #BG_H #BG_SOLID #BG_T #CL #CR #CUTTYPE #DELOBJ
;;;01/07/25YM@  #FG_H #FG_S #FG_T #GRIDMODE #KAIJO #LAST #LINE$ #LOOP #ORTHOMODE #OSMODE
;;;01/07/25YM@  #P1 #P2 #P3 #PD #RR #SNAPMODE #SS #SS_DUM #WTEN #WTL #WTR #WT_H #WT_PT$
;;;01/07/25YM@  #WT_REGION #WT_SOLID #WT_T #WT_TEI #sX #XD$ #XDL$ #XDR$ #XD_NEW$ #YESNOMSG
;;;01/07/25YM@  #BG #BG0 #BG_REGION #DUM1 #DUM2 #BG_TEI1 #BG_TEI2 #FG_TEI1 #FG_TEI2
;;;01/07/25YM@  #dist1 #dist2 #DEP #FG0 #FG_REGION #FG_SOLID #P4 #P5
;;;01/07/25YM@  )
;;;01/07/25YM@  (CFOutStateLog 1 1 " ")
;;;01/07/25YM@  (CFOutStateLog 1 1 "//// C:RendWT ////")
;;;01/07/25YM@  (CFOutStateLog 1 1 " ")
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    ;&ss("LINE"�I���)�̂����n�_or�I�_��&pt�ƈ�v����}�`ؽĂ�Ԃ�
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    (defun ##GETLINE (
;;;01/07/25YM@      &ss
;;;01/07/25YM@      &pt
;;;01/07/25YM@      /
;;;01/07/25YM@      #EN #I #LIST$
;;;01/07/25YM@      )
;;;01/07/25YM@      (setq #list$ nil)
;;;01/07/25YM@      (if (and &ss (< 0 (sslength &ss)))
;;;01/07/25YM@        (progn
;;;01/07/25YM@          (setq #i 0)
;;;01/07/25YM@          (repeat (sslength &ss)
;;;01/07/25YM@            (setq #en (ssname &ss #i))
;;;01/07/25YM@            (if (or (< (distance (cdr (assoc 10 (entget #en))) &pt) 0.1)
;;;01/07/25YM@                    (< (distance (cdr (assoc 11 (entget #en))) &pt) 0.1))
;;;01/07/25YM@              (setq #list$ (append #list$ (list #en)))
;;;01/07/25YM@            );_if
;;;01/07/25YM@            (setq #i (1+ #i))
;;;01/07/25YM@          )
;;;01/07/25YM@        )
;;;01/07/25YM@      );_if
;;;01/07/25YM@      #list$
;;;01/07/25YM@    )
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    ;&en("LINE"�}�`)-->�n�_,�I�_�̒��_��Ԃ�
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    (defun ##CENTER_PT ( &en / #DUM)
;;;01/07/25YM@      (setq #dum (mapcar '+ (cdr (assoc 10 (entget &en)))
;;;01/07/25YM@                            (cdr (assoc 11 (entget &en)))))
;;;01/07/25YM@      (setq #dum (mapcar '* #dum '(0.5 0.5 0.5)))
;;;01/07/25YM@    )
;;;01/07/25YM@
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    ;����:&en(������ʐ}�` or "")���폜����
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    (defun ##ENTDEL ( &en / )
;;;01/07/25YM@      (if (and &en (/= &en "")(entget &en))
;;;01/07/25YM@        (entdel &en)
;;;01/07/25YM@      );_if
;;;01/07/25YM@      (princ)
;;;01/07/25YM@    )
;;;01/07/25YM@
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    ;fillet����
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////////////////////
;;;01/07/25YM@    (defun ##FILLET ( &line$ / #ARC #EN1 #EN2 #SP1 #SP2)
;;;01/07/25YM@      (if &line$
;;;01/07/25YM@        (progn
;;;01/07/25YM@          (setq #en1 (car  &line$))
;;;01/07/25YM@          (setq #en2 (cadr &line$))
;;;01/07/25YM@          (setq #sp1 (##CENTER_PT #en1))
;;;01/07/25YM@          (setq #sp2 (##CENTER_PT #en2))
;;;01/07/25YM@          (command "_fillet" (list #en1 #sp1)(list #en2 #sp2))
;;;01/07/25YM@          (setq #arc (entlast))
;;;01/07/25YM@        )
;;;01/07/25YM@        (progn
;;;01/07/25YM@          (CFAlertMsg "�t�B���b�g�������ł��܂���ł����B")(quit)
;;;01/07/25YM@        )
;;;01/07/25YM@      );_if
;;;01/07/25YM@      #arc
;;;01/07/25YM@    )
;;;01/07/25YM@
;;;01/07/25YM@    ;//////////////////////////////////////////////////////////
;;;01/07/25YM@
;;;01/07/25YM@  (setq #KAIJO nil)  ; �i�Ԋm������׸�
;;;01/07/25YM@  ;// �R�}���h�̏�����
;;;01/07/25YM@  (StartUndoErr)
;;;01/07/25YM@; 01/06/28 YM ADD ����ނ̐��� SK�ȊO���s�s��
;;;01/07/25YM@(if (not (equal (KPGetSinaType) -1 0.1))
;;;01/07/25YM@  (progn
;;;01/07/25YM@    nil ; �ذ�ނɂ�鐧�����Ȃ��� 01/07/25 YM MOD
;;;01/07/25YM@;;;01/07/25@    (CFAlertMsg msg8)
;;;01/07/25YM@;;;01/07/25@    (quit)
;;;01/07/25YM@  )
;;;01/07/25YM@  (progn
;;;01/07/25YM@    (setq #SNAPMODE  (getvar "SNAPMODE"))
;;;01/07/25YM@    (setq #GRIDMODE  (getvar "GRIDMODE"))
;;;01/07/25YM@    (setq #ORTHOMODE (getvar "ORTHOMODE"))
;;;01/07/25YM@    (setq #OSMODE    (getvar "OSMODE"))
;;;01/07/25YM@    (setvar "SNAPMODE"  0)
;;;01/07/25YM@    (setvar "GRIDMODE"  0)
;;;01/07/25YM@    (setvar "ORTHOMODE" 0)
;;;01/07/25YM@    (setvar "OSMODE"    0)
;;;01/07/25YM@    (setq #PD (getvar "pdmode")) ; 06/12 YM
;;;01/07/25YM@    (setvar "pdmode" 34)         ; 06/12 YM
;;;01/07/25YM@    ;// ���[�N�g�b�v�̎w��
;;;01/07/25YM@    (initget 0)
;;;01/07/25YM@    (setq #loop T)
;;;01/07/25YM@    (while #loop
;;;01/07/25YM@      (setq #wtEn (car (entsel "\n���[�N�g�b�v��I��: ")))
;;;01/07/25YM@      (if #wtEn
;;;01/07/25YM@        (setq #xd$ (CFGetXData #wten "G_WRKT"))
;;;01/07/25YM@        (setq #xd$ nil)
;;;01/07/25YM@      );_if
;;;01/07/25YM@      (if (= #xd$ nil)
;;;01/07/25YM@        (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
;;;01/07/25YM@      ;else
;;;01/07/25YM@        (cond
;;;01/07/25YM@          ((CFGetXData #wtEn "G_WTSET")
;;;01/07/25YM@            (setq #YesNoMsg "���[�N�g�b�v�͕i�Ԋm�肳��Ă��܂��B\n�����𑱂��܂����H")
;;;01/07/25YM@            (if (CFYesNoDialog #YesNoMsg)
;;;01/07/25YM@              (progn
;;;01/07/25YM@                (setq #loop nil) ; YES �Ȃ�p��
;;;01/07/25YM@                (setq #KAIJO T)  ; �i�Ԋm������׸�
;;;01/07/25YM@              )
;;;01/07/25YM@              (*error*)        ; NO  �Ȃ�STOP
;;;01/07/25YM@            );_if
;;;01/07/25YM@          )
;;;01/07/25YM@          (T
;;;01/07/25YM@            (setq #loop nil)
;;;01/07/25YM@          )
;;;01/07/25YM@        );_cond
;;;01/07/25YM@      );_if
;;;01/07/25YM@
;;;01/07/25YM@    );while
;;;01/07/25YM@
;;;01/07/25YM@    ; �������� �l��J��ĂȂ�R���މ\
;;;01/07/25YM@    (setq #CutType (nth 7 #xd$)) ; �������
;;;01/07/25YM@    ; ��ċL��
;;;01/07/25YM@    (setq #CL (substr #CutType 1 1))
;;;01/07/25YM@    (setq #CR (substr #CutType 2 1))
;;;01/07/25YM@
;;;01/07/25YM@    (cond
;;;01/07/25YM@      ((and (/= #CL "0") (= #CR "0"))
;;;01/07/25YM@        (setq #sX "Right") ; R���ޑ�=�E
;;;01/07/25YM@      )
;;;01/07/25YM@      ((and (= #CL "0") (/= #CR "0"))
;;;01/07/25YM@        (setq #sX "Left") ; R���ޑ�=��
;;;01/07/25YM@      )
;;;01/07/25YM@      ((and (= #CL "0") (= #CR "0"))
;;;01/07/25YM@        (setq #sX "LeftRight") ; R���ޑ�=�ǂ�����\
;;;01/07/25YM@      )
;;;01/07/25YM@      (T
;;;01/07/25YM@        (CFAlertMsg "���̃��[�N�g�b�v�͂q�G���h���H�ł��܂���B")(quit)
;;;01/07/25YM@      )
;;;01/07/25YM@    );_cond
;;;01/07/25YM@
;;;01/07/25YM@;;;01/07/25YM@    (cond
;;;01/07/25YM@;;;01/07/25YM@      ((and (= #CL "1") (= #CR "0"))
;;;01/07/25YM@;;;01/07/25YM@        (setq #sX "Right") ; R���ޑ�=�E
;;;01/07/25YM@;;;01/07/25YM@      )
;;;01/07/25YM@;;;01/07/25YM@      ((and (= #CL "0") (= #CR "1"))
;;;01/07/25YM@;;;01/07/25YM@        (setq #sX "Left") ; R���ޑ�=��
;;;01/07/25YM@;;;01/07/25YM@      )
;;;01/07/25YM@;;;01/07/25YM@      (T
;;;01/07/25YM@;;;01/07/25YM@        (CFAlertMsg "���̃��[�N�g�b�v�͂q�G���h���H�ł��܂���B")(quit)
;;;01/07/25YM@;;;01/07/25YM@      )
;;;01/07/25YM@;;;01/07/25YM@    );_cond
;;;01/07/25YM@
;;;01/07/25YM@    (PCW_ChColWT #wtEn "MAGENTA" nil) ; �F��ς���
;;;01/07/25YM@
;;;01/07/25YM@    ; WT���擾
;;;01/07/25YM@    (setq #WT_H (nth  8 #xd$))  ; WT����
;;;01/07/25YM@    (setq #WT_T (nth 10 #xd$))  ; WT����
;;;01/07/25YM@    (setq #BG_H (nth 12 #xd$))  ; BG����
;;;01/07/25YM@    (setq #BG_T (nth 13 #xd$))  ; BG����
;;;01/07/25YM@    (setq #FG_H (nth 15 #xd$))  ; FG����
;;;01/07/25YM@    (setq #FG_T (nth 16 #xd$))  ; FG����
;;;01/07/25YM@    (setq #FG_S (nth 17 #xd$))  ; FG��ė�
;;;01/07/25YM@
;;;01/07/25YM@    ; �e��ʎ擾
;;;01/07/25YM@    (setq #WT_tei (nth 38 #xd$))   ; WT��ʐ}�`�����
;;;01/07/25YM@    (setq #BASEPT (nth 32 #xd$))   ; WT����_
;;;01/07/25YM@    (setq #BG_tei1 (nth 49 #xd$))  ; BG SOLID1 or ���1
;;;01/07/25YM@    (setq #BG_tei2 (nth 50 #xd$))  ; BG SOLID2 or ���2 ��������΂��̂܂�
;;;01/07/25YM@    (setq #FG_tei1 (nth 51 #xd$))  ; FG1��� *
;;;01/07/25YM@    (setq #FG_tei2 (nth 52 #xd$))  ; F2G��� *
;;;01/07/25YM@    (setq #dep (car (nth 57 #xd$))); WT���s��
;;;01/07/25YM@
;;;01/07/25YM@    ; WT��ʓ_��擾
;;;01/07/25YM@    (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))     ; WT�O�`�_��
;;;01/07/25YM@    (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT ����_���玞�v����ɕ��ёւ���
;;;01/07/25YM@    (setq #p1 (nth 0 #WT_pt$)) ; WT����_
;;;01/07/25YM@    (setq #p2 (nth 1 #WT_pt$)) ; WT�E��_
;;;01/07/25YM@    (setq #p3 (nth 2 #WT_pt$))
;;;01/07/25YM@    (setq #p4 (nth 3 #WT_pt$))
;;;01/07/25YM@    (setq #p5 (nth 4 #WT_pt$))
;;;01/07/25YM@    (setq #p6 (nth 5 #WT_pt$))
;;;01/07/25YM@
;;;01/07/25YM@    ; #rDist1=���s�� #rDist2=WT�O�`�̉���
;;;01/07/25YM@    (setq #rDid$ (KPGetRendDist #WT_pt$ #CutType))
;;;01/07/25YM@    ; R�����޲�۸ނ�\��
;;;01/07/25YM@    (setq #ret$ (KPRendDig #sX #CutType #rDid$))
;;;01/07/25YM@
;;;01/07/25YM@    ; fillet�̉ۂ𔻒肷�邽�ߋ��������߂� 01/07/18 YM ADD
;;;01/07/25YM@
;;;01/07/25YM@    (cond
;;;01/07/25YM@      ((= #sX "Right")
;;;01/07/25YM@        (setq #dist1 (* 0.5 (distance #p2 #p3)))
;;;01/07/25YM@        (setq #dist2 (distance #p3 #p4))
;;;01/07/25YM@      )
;;;01/07/25YM@      ((= #sX "Left")
;;;01/07/25YM@        (setq #dist1 (* 0.5 (distance #p1 #last)))
;;;01/07/25YM@        (setq #dist2 (distance #p5 #last))
;;;01/07/25YM@      )
;;;01/07/25YM@    );_cond
;;;01/07/25YM@
;;;01/07/25YM@    ; R(�a)�����
;;;01/07/25YM@    (setq #loop T)
;;;01/07/25YM@    (while #loop
;;;01/07/25YM@      (setq #rr (getreal (strcat "\n�q�����<" CG_R ">: ")))
;;;01/07/25YM@      (if (= #rr nil)
;;;01/07/25YM@        (progn
;;;01/07/25YM@          (setq #rr CG_R)
;;;01/07/25YM@          (setq #loop nil)
;;;01/07/25YM@        )
;;;01/07/25YM@        (progn
;;;01/07/25YM@          (if (or (<= #dist1 #rr)(<= #dist2 #rr)) ; ���s���̔����𒴂��Ă͂����Ȃ�
;;;01/07/25YM@            (progn
;;;01/07/25YM@              (setq #loop T)
;;;01/07/25YM@              (princ "\n�l���傫�����ăt�B���b�g�ł��܂���B")
;;;01/07/25YM@            )
;;;01/07/25YM@            (progn
;;;01/07/25YM@              (setq #rr (rtos #rr)) ; string
;;;01/07/25YM@              (setq #loop nil)
;;;01/07/25YM@            )
;;;01/07/25YM@          );_if
;;;01/07/25YM@        )
;;;01/07/25YM@      ); if
;;;01/07/25YM@    )
;;;01/07/25YM@
;;;01/07/25YM@    (command "_fillet" "R" #rr)
;;;01/07/25YM@
;;;01/07/25YM@    ; �F��߂�
;;;01/07/25YM@    (PCW_ChColWT #wtEn "BYLAYER" nil)
;;;01/07/25YM@
;;;01/07/25YM@    ;// �����̃��[�N�g�b�v(�O���ꍞ��3DSOLID)���폜
;;;01/07/25YM@    (entdel #wtEn)
;;;01/07/25YM@    ; ������ʍ폜
;;;01/07/25YM@    (##ENTDEL #BG_tei1)
;;;01/07/25YM@    (##ENTDEL #BG_tei2)
;;;01/07/25YM@    (##ENTDEL #FG_tei1)
;;;01/07/25YM@    (##ENTDEL #FG_tei2)
;;;01/07/25YM@
;;;01/07/25YM@    ; WT��ʂ��߰���ĕ���
;;;01/07/25YM@    (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT_tei)) (entget #WT_tei)))
;;;01/07/25YM@    (command "_explode" (entlast))
;;;01/07/25YM@    (setq #ss_dum (ssget "P")) ; LINE�̏W�܂�
;;;01/07/25YM@    ; ��ʂ�Fillet����
;;;01/07/25YM@    (cond
;;;01/07/25YM@      ((= #sX "Right")
;;;01/07/25YM@        (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2��[�_�Ɏ���"LINE"��ؽĂ��擾
;;;01/07/25YM@        (setq #arc1  (##FILLET #line$))       ; Fillet����"ARC"���擾
;;;01/07/25YM@        (setq #line$ (##GETLINE #ss_dum #p3))
;;;01/07/25YM@        (setq #arc2  (##FILLET #line$))
;;;01/07/25YM@        ; BG��ʍ쐬
;;;01/07/25YM@        (setq #dum1 (polar #p1   (angle #p1 #p2) #BG_T))
;;;01/07/25YM@        (setq #dum2 (polar #last (angle #p1 #p2) #BG_T))
;;;01/07/25YM@        (setq #BG0 (MakeTEIMEN (list #p1 #dum1 #dum2 #last))) ; �ޯ��ް�ޒ�ʍ쐬
;;;01/07/25YM@        ; FG��ʍ쐬 01/07/10 YM ADD
;;;01/07/25YM@        (setq #FG0 (KPMakeFGTeimen #sX #WT_pt$ #arc1 #arc2 #FG_T #rr))
;;;01/07/25YM@      )
;;;01/07/25YM@      ((= #sX "Left")
;;;01/07/25YM@        (setq #line$ (##GETLINE #ss_dum #p1))
;;;01/07/25YM@        (setq #arc1  (##FILLET #line$))
;;;01/07/25YM@        (setq #line$ (##GETLINE #ss_dum #last))
;;;01/07/25YM@        (setq #arc2  (##FILLET #line$))
;;;01/07/25YM@        ; BG��ʍ쐬
;;;01/07/25YM@        (setq #dum1 (polar #p2 (angle #p2 #p1) #BG_T))
;;;01/07/25YM@        (setq #dum2 (polar #p3 (angle #p2 #p1) #BG_T))
;;;01/07/25YM@        (setq #BG0 (MakeTEIMEN (list #p2 #p3 #dum2 #dum1))) ; �ޯ��ް�ޒ��
;;;01/07/25YM@        ; FG��ʍ쐬 01/07/10 YM ADD
;;;01/07/25YM@        (setq #FG0 (KPMakeFGTeimen #sX #WT_pt$ #arc1 #arc2 #FG_T #rr))
;;;01/07/25YM@      )
;;;01/07/25YM@    );_cond
;;;01/07/25YM@    ; Fillet�ɂ���č쐬���ꂽ"ARC"��ǉ�����-->pedit
;;;01/07/25YM@    (ssadd #arc1 #ss_dum)
;;;01/07/25YM@    (ssadd #arc2 #ss_dum)
;;;01/07/25YM@
;;;01/07/25YM@    ; Pedit ���ײ݉� WT �č쐬
;;;01/07/25YM@    (command "_pedit" #arc1 "Y" "J" #ss_dum "" "X") ; "X" ���ײ݂̑I�����I��
;;;01/07/25YM@
;;;01/07/25YM@    (setq #delobj (getvar "delobj")) ; extrude��̒�ʂ�ێ�����  "delobj"=0
;;;01/07/25YM@    (setvar "delobj" 1)              ; extrude��̒�ʂ�ێ����Ȃ�"delobj"=1
;;;01/07/25YM@
;;;01/07/25YM@    (setq #WT_region (Make_Region2 (entlast)))
;;;01/07/25YM@    (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))
;;;01/07/25YM@
;;;01/07/25YM@  ;;; BG_SOLID�č쐬
;;;01/07/25YM@    (if #BG0
;;;01/07/25YM@      (progn
;;;01/07/25YM@        (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG0)) (entget #BG0))) ; ������ײ�(��w��ς��Ďc��)
;;;01/07/25YM@        (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG0)) (entget #BG0))) ; SOLID��w�ɂ���-->�����o���p
;;;01/07/25YM@        (setq #BG (entlast)) ; extrude�p
;;;01/07/25YM@        (setq #BG_region (Make_Region2 #BG))
;;;01/07/25YM@        (setq #BG_SOLID  (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
;;;01/07/25YM@      )
;;;01/07/25YM@    );_if
;;;01/07/25YM@
;;;01/07/25YM@    ; FG_SOLID�č쐬
;;;01/07/25YM@    (if #FG0
;;;01/07/25YM@      (progn
;;;01/07/25YM@  ;;;     (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG0)) (entget #FG0))) ; ������ײ�(�c��)
;;;01/07/25YM@  ;;;     (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #FG0)) (entget #FG0)))
;;;01/07/25YM@  ;;;     (setq #FG (entlast)) ; extrude�p
;;;01/07/25YM@  ;;;     (setq #FG_region (Make_Region2 #FG))
;;;01/07/25YM@        (setq #FG_region (Make_Region2 #FG0))
;;;01/07/25YM@        (setq #FG_SOLID  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
;;;01/07/25YM@      )
;;;01/07/25YM@    );_if
;;;01/07/25YM@
;;;01/07/25YM@    (setvar "delobj" #delobj) ; �V�X�e���ϐ���߂�
;;;01/07/25YM@
;;;01/07/25YM@    (setq #ss (ssadd))
;;;01/07/25YM@    (ssadd #WT_SOLID #ss)
;;;01/07/25YM@    (if #BG_SOLID (ssadd #BG_SOLID #ss)) ; BG_SOLID��ǉ�
;;;01/07/25YM@    (if #FG_SOLID (ssadd #FG_SOLID #ss)) ; FG_SOLID��ǉ�
;;;01/07/25YM@
;;;01/07/25YM@    ;BG,WT�̘a���Ƃ�
;;;01/07/25YM@    (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
;;;01/07/25YM@
;;;01/07/25YM@    ;// �g���f�[�^�̍Đݒ�
;;;01/07/25YM@    (setq #xd_new$
;;;01/07/25YM@    (list
;;;01/07/25YM@      (list 49 #BG0);[50]:BG SOLID��ʐ}�`�����1
;;;01/07/25YM@      (list 50   "");[51]:BG SOLID��ʐ}�`�����2
;;;01/07/25YM@      (list 51   "");[52]:FG ��ʐ}�`�����1
;;;01/07/25YM@      (list 51   "");[52]:FG ��ʐ}�`�����1
;;;01/07/25YM@      (list 52   "");[53]:FG ��ʐ}�`�����2
;;;01/07/25YM@    ))
;;;01/07/25YM@    (CFSetXData #WT_SOLID "G_WRKT"
;;;01/07/25YM@      (CFModList #xd$ #xd_new$)
;;;01/07/25YM@    )
;;;01/07/25YM@
;;;01/07/25YM@    (setq #WTL (nth 47 #xd$)) ; ��đ���WT��
;;;01/07/25YM@    (setq #WTR (nth 48 #xd$)) ; ��đ���WT�E
;;;01/07/25YM@
;;;01/07/25YM@    ;����WT�̊g���f�[�^���X�V����
;;;01/07/25YM@    (if (and (/= #WTL "") (/= #WTL nil))
;;;01/07/25YM@      (progn
;;;01/07/25YM@        (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; ����
;;;01/07/25YM@        (CFSetXData #WTL "G_WRKT"
;;;01/07/25YM@          (CFModList #xdL$
;;;01/07/25YM@            (list
;;;01/07/25YM@              (list 48 #WT_SOLID)     ;[49]�J�b�g����WT����ىE U�^�͍��E�ɂ���
;;;01/07/25YM@            )
;;;01/07/25YM@          )
;;;01/07/25YM@        )
;;;01/07/25YM@      )
;;;01/07/25YM@    );_if
;;;01/07/25YM@
;;;01/07/25YM@    ;�E��WT�̊g���f�[�^���X�V����
;;;01/07/25YM@    (if (and (/= #WTR "") (/= #WTR nil))
;;;01/07/25YM@      (progn
;;;01/07/25YM@        (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; �E��
;;;01/07/25YM@        (CFSetXData #WTR "G_WRKT"
;;;01/07/25YM@          (CFModList
;;;01/07/25YM@            #xdR$
;;;01/07/25YM@            (list
;;;01/07/25YM@              (list 47 #WT_SOLID)     ;[48]�J�b�g����WT����ٍ� U�^�͍��E�ɂ���
;;;01/07/25YM@            )
;;;01/07/25YM@          )
;;;01/07/25YM@        )
;;;01/07/25YM@      )
;;;01/07/25YM@    );_if
;;;01/07/25YM@
;;;01/07/25YM@    (setvar "SNAPMODE"  #SNAPMODE)
;;;01/07/25YM@    (setvar "GRIDMODE"  #GRIDMODE)
;;;01/07/25YM@    (setvar "ORTHOMODE" #ORTHOMODE)
;;;01/07/25YM@    (setvar "OSMODE"    #OSMODE)
;;;01/07/25YM@    (setvar "pdmode" #PD) ; 06/12 YM
;;;01/07/25YM@    (if #KAIJO
;;;01/07/25YM@      (princ "\n�i�Ԋm�肪��������܂����B")
;;;01/07/25YM@    );_if
;;;01/07/25YM@
;;;01/07/25YM@  ); 01/06/28 YM ADD ����ނ̐��� Lipple
;;;01/07/25YM@);_if
;;;01/07/25YM@
;;;01/07/25YM@  (setq *error* nil)
;;;01/07/25YM@  (princ)
;;;01/07/25YM@
;;;01/07/25YM@);C:RendWT_test

;-- 2011/12/17 A.Satoh Mod - S
;;;;;;;;<HOM>*************************************************************************
;;;;;;;; <�֐���>    : KPGetRendDist
;;;;;;;; <�����T�v>  : R���މ۔���̂��߂̐��@���擾
;;;;;;;; <�߂�l>    : (����1,����2)=(WT���s��,WT�O�`�̉��Ӓ���)
;;;;;;;; <�쐬>      : 01/07/25 YM
;;;;;;;; <���l>      : <���g�p>
;;;;;;;;*************************************************************************>MOH<
;;;;;(defun KPGetRendDist (
;;;;;  &WT_pt$  ; WT�O�`�_��
;;;;;  &CutType ; WT�������"00","20"�Ȃ�"���E" 0:��ĂȂ�,1:J���,2:Y���,3:45�x���,4:�i���ڑ�
;;;;;  /
;;;;;  #P1 #P2 #P3 #P4 #P5 #P6 #RDIS1 #RDIS2
;;;;;  )
;;;;;  ; fillet�̉ۂ𔻒肷�邽�ߋ��������߂�
;;;;;  ; p1                p2
;;;;;  ; +-----------------+
;;;;;  ; |                 |
;;;;;  ; |    p5           |"Right"����
;;;;;  ; +----+            |
;;;;;  ;p6      +----------+
;;;;;  ;       p4          p3
;;;;;
;;;;;  ; p1                p2
;;;;;  ; +-----------------+
;;;;;  ; |                 |
;;;;;  ; |            p4   |"Left"����
;;;;;  ; |            +----+
;;;;;  ; +----------+      p3
;;;;;  ; p6         p5
;;;;;
;;;;;  (setq #p1 (nth 0 &WT_pt$)) ; WT����_
;;;;;  (setq #p2 (nth 1 &WT_pt$)) ; WT�E��_
;;;;;  (setq #p3 (nth 2 &WT_pt$))
;;;;;  (setq #p4 (nth 3 &WT_pt$))
;;;;;  (setq #p5 (nth 4 &WT_pt$))
;;;;;  (setq #p6 (nth 5 &WT_pt$))
;;;;;
;;;;;  (cond
;;;;;    ((or (= &CutType "00")(= &CutType "10")(= &CutType "20")(= &CutType "30")(= &CutType "00"))
;;;;;      (setq #rDis1 (distance #p2 #p3)) ; ���s��
;;;;;      (setq #rDis2 (distance #p3 #p4)) ; WT����
;;;;;    )
;;;;;    ((= &CutType "01")
;;;;;      (setq #rDis1 (distance #p1 #p6)) ; ���s��
;;;;;      (setq #rDis2 (distance #p5 #p6)) ; WT����
;;;;;    )
;;;;;    ((= &CutType "02")
;;;;;      (setq #rDis1 (distance #p1 #p5)) ; ���s��
;;;;;      (setq #rDis2 (distance #p4 #p5)) ; WT����
;;;;;    )
;;;;;    ((or (= &CutType "03")(= &CutType "04"))
;;;;;      (setq #rDis1 (distance #p1 #p4)) ; ���s��
;;;;;      (setq #rDis2 (distance #p3 #p4)) ; WT����
;;;;;    )
;;;;;    (T
;;;;;      (CFAlertMsg "�q�G���h���H�̔��肪�o���܂���B")
;;;;;    )
;;;;;  );_cond
;;;;;  (list #rDis1 #rDis2)
;;;;;);KPGetRendDist
;;;<HOM>*************************************************************************
;;; <�֐���>    : KPGetRendDist
;;; <�����T�v>  : R���މ۔���̂��߂̐��@���擾
;;; <�߂�l>    : (����1,����2)=(WT���s��,WT�O�`�̉��Ӓ���)
;;; <�쐬>      : 01/07/25 YM
;;; <���l>      : 11/12/17 A.Satoh Modify
;;;*************************************************************************>MOH<
(defun KPGetRendDist (
	&WT_pt$		; WT�O�`�_��
	&pnt$			; �w��ʒu���W�iWT�O�`�_����̍��W�j
	/
	#idx #pnt1$ #pnt2$
	)

	(setq #idx 0)
	(repeat (length &WT_pt$)
		(if (= &pnt$ (nth #idx &WT_pt$))
			(if (= #idx 0)
				(progn
					(setq #pnt1$ (nth (1- (length &WT_pt$)) &WT_pt$))
					(setq #pnt2$ (nth 1 &WT_pt$))
				)
				(if (= #idx (1- (length &WT_pt$)))
					(progn
						(setq #pnt1$ (nth (1- #idx) &WT_pt$))
						(setq #pnt2$ (nth 0 &WT_pt$))
					)
					(progn
						(setq #pnt1$ (nth (1- #idx) &WT_pt$))
						(setq #pnt2$ (nth (1+ #idx) &WT_pt$))
					)
				)
			)
		)

		(setq #idx (1+ #idx))
	)

	(list (distance &pnt$ #pnt1$) (distance &pnt$ #pnt2$))

) ;KPGetRendDist
;-- 2011/12/17 A.Satoh Mod - E

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPSetClayerOtherFreeze
;;; <�����T�v>  : ������w(�Ȃ���΍쐬)�����݉�w�ɂ��Ă���ȊO���ذ��
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/07/25 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KPSetClayerOtherFreeze (
  &LAYER ; ��w��(string)
  &col   ; �F�ԍ�=1-255(nil===>��)
  &line  ; ���핶����  (nil===>"CONTINUOUS")
  /
  )
  (if (= nil &col)(setq &col 7))
  (if (= nil &line)(setq &line "CONTINUOUS"))
  ; �e���|������w�̍쐬
  (if (tblsearch "LAYER" &LAYER)
    (progn
      (command "_layer" "U" &LAYER "") ; �x�����b�Z�[�W�΍��2���ɕ�����  Uۯ�����
      (command "_layer" "ON" &LAYER "T" &LAYER "")  ; ON�\�� T�ذ�މ���
     )
    (command "_layer" "N" &LAYER "C" &col &LAYER "L" &line &LAYER "")
  )
  (setvar "CLAYER" &LAYER)
  ; ���݉�w(=SKD_TEMP_LAYER)�ȊO���ذ��
  (command "_layer" "F" "*" "") ;�S�Ẳ�w���ذ��
  (princ)
);KPSetClayerOtherFreeze

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPMakeDummyLineBG
;;; <�����T�v>  : հ�ް�I��p��BG�ʒu��LINE����}
;;; <�߂�l>    : ��}����LINE�}�`ؽ�
;;; <�쐬>      : 01/07/25 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KPMakeDummyLineBG (
  &CutType ; WT���E�������"00","30"�Ȃ� 0]�Ȃ�,1:J���,2:Y���,3:45�x���
  &WT_pt$  ; WT�O�`�_��
  &WT_T    ; WT����
  /
  #CUTTYPE #EPL$ #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #WT_PT$
  )
    ;----------------------------------------------------------------------
    ; line����}���Đ}�`��Ԃ�
    (defun ##Line ( &p1 &p2 / )
      (command "_line" &p1 &p2 "")
      (entlast)
    )
    ;----------------------------------------------------------------------
    ; ���W�l�̂y��ҏW
    (defun ##ADDZ ( &p &Z / )
      (list (car &p) (cadr &p) &Z)
    )
    ;----------------------------------------------------------------------

  (setq #WT_pt$ &WT_pt$ #CutType &CutType)
  (setq #p1 (##ADDZ (nth 0 #WT_pt$) &WT_T)) ; WT����_
  (setq #p2 (##ADDZ (nth 1 #WT_pt$) &WT_T)) ; WT�E��_
  (setq #p3 (##ADDZ (nth 2 #WT_pt$) &WT_T))
  (setq #p4 (##ADDZ (nth 3 #WT_pt$) &WT_T))
  (setq #p5 (##ADDZ (nth 4 #WT_pt$) &WT_T))
  (setq #p6 (##ADDZ (nth 5 #WT_pt$) &WT_T))
  (setq #p7 (##ADDZ (nth 6 #WT_pt$) &WT_T))
  (setq #p8 (##ADDZ (nth 7 #WT_pt$) &WT_T))

  (setq #ePL$ nil)
  (cond
    ((= #CutType "11")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p8 #p1)
        )
      )
    )
    ((= #CutType "12")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p1 #p7)
        )
      )
    )
    ((= #CutType "00")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p3 #p4)
          (##Line #p4 #p1)
        )
      )
    )
    ((= #CutType "10")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p6 #p1)
        )
      )
    )
    ((or (= #CutType "01")(= #CutType "21"))
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
        )
      )
    )
    (T ; ����ȊO�͏㑤�̂ݑI��
      (setq #ePL$ (list (##Line #p1 #p2)))
    )
  );_cond
  #ePL$
);KPMakeDummyLineBG

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPMakeDummyLineFG
;;; <�����T�v>  : հ�ް�I��p��FG�ʒu��LINE����}
;;; <�߂�l>    : ��}����LINE�}�`ؽ�
;;; <�쐬>      : 01/07/26 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KPMakeDummyLineFG (
  &CutType ; WT���E�������"00","30"�Ȃ� 0]�Ȃ�,1:J���,2:Y���,3:45�x���
  &WT_pt$  ; WT�O�`�_��
  &WT_T    ; WT����
  /
  #CUTTYPE #EPL$ #P1 #P2 #P3 #P4 #P5 #P6 #P7 #P8 #WT_PT$
  )
    ;----------------------------------------------------------------------
    ; line����}���Đ}�`��Ԃ�
    (defun ##Line ( &p1 &p2 / )
      (command "_line" &p1 &p2 "")
      (entlast)
    )
    ;----------------------------------------------------------------------
    ; ���W�l�̂y��ҏW
    (defun ##ADDZ ( &p &Z / )
      (list (car &p) (cadr &p) &Z)
    )
    ;----------------------------------------------------------------------

  (setq #WT_pt$ &WT_pt$ #CutType &CutType)
  (setq #p1 (##ADDZ (nth 0 #WT_pt$) &WT_T)) ; WT����_
  (setq #p2 (##ADDZ (nth 1 #WT_pt$) &WT_T)) ; WT�E��_
  (setq #p3 (##ADDZ (nth 2 #WT_pt$) &WT_T))
  (setq #p4 (##ADDZ (nth 3 #WT_pt$) &WT_T))
  (setq #p5 (##ADDZ (nth 4 #WT_pt$) &WT_T))
  (setq #p6 (##ADDZ (nth 5 #WT_pt$) &WT_T))
  (setq #p7 (##ADDZ (nth 6 #WT_pt$) &WT_T))
  (setq #p8 (##ADDZ (nth 7 #WT_pt$) &WT_T))

  (setq #ePL$ nil)
  (cond
    ((= #CutType "00")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p3 #p4)
          (##Line #p4 #p1)
        )
      )
    )
    ((= #CutType "01")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p5 #p6)
          (##Line #p6 #p1)
        )
      )
    )
    ((= #CutType "02")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p4 #p5)
          (##Line #p5 #p1)
        )
      )
    )
    ((or (= #CutType "03")(= #CutType "04"))
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p3 #p4)
          (##Line #p4 #p1)
        )
      )
    )
    ((= #CutType "10")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p3 #p4)
          (##Line #p6 #p1)
        )
      )
    )
    ((or (= #CutType "20")(= #CutType "30")(= #CutType "40"))
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p3 #p4)
        )
      )
    )
    ((= #CutType "11")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p5 #p6)
          (##Line #p8 #p1)
        )
      )
    )
    ((= #CutType "22")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p4 #p5)
        )
      )
    )
    ((= #CutType "33")
      (setq #ePL$
        (list
          (##Line #p3 #p4)
        )
      )
    )
    ((= #CutType "33")
      (setq #ePL$
        (list
          (##Line #p3 #p4)
        )
      )
    )
    ((= #CutType "12")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p4 #p5)
          (##Line #p7 #p1)
        )
      )
    )
    ((= #CutType "21")
      (setq #ePL$
        (list
          (##Line #p1 #p2)
          (##Line #p2 #p3)
          (##Line #p5 #p6)
        )
      )
    )
    (T ; ����ȊO�͏㑤�̂ݑI��
      (setq #ePL$ (list (##Line #p1 #p2)))
    )
  );_cond
  #ePL$
);KPMakeDummyLineFG

;;;<HOM>*************************************************************************
;;; <�֐���>    : KPMakeDummyLineRend
;;; <�����T�v>  : հ�ް�I��p��Rend�ʒu��LINE����}
;;; <�߂�l>    : ��}����LINE�}�`ؽ�
;;; <�쐬>      : 01/07/26 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun KPMakeDummyLineRend (
  &LR     ; Rend�� "Left" or "Right"
  &WT_pt$ ; WT�O�`�_��
  &WT_T   ; WT����
  /
  #DPT1 #DPT2 #DPT3 #DPT4 #DPT5 #DPT6 #EPL$ #LAST #P1 #P2 #P3 #WT_PT$
  )
  ;----------------------------------------------------------------------
  ; line����}���Đ}�`��Ԃ�
  (defun ##Line ( &p1 &p2 / )
    (command "_line" &p1 &p2 "")
    (entlast)
  )
  ;----------------------------------------------------------------------
  ; ���W�l�̂y��ҏW
  (defun ##ADDZ ( &p &Z / )
    (list (car &p) (cadr &p) &Z)
  )
  ;----------------------------------------------------------------------

  (setq #WT_pt$ &WT_pt$)
  (setq #p1 (##ADDZ (nth 0 #WT_pt$) &WT_T)) ; WT����_
  (setq #p2 (##ADDZ (nth 1 #WT_pt$) &WT_T)) ; WT�E��_
  (setq #p3 (##ADDZ (nth 2 #WT_pt$) &WT_T))
  (setq #last (##ADDZ (last #WT_pt$) &WT_T))

  (setq #ePL$ nil)
  (cond
    ((= &LR "Right")
      (setq #dPT1 (polar #p2 (angle #p2 #p1)(atoi CG_R)))
      (setq #dPT2 #p2)
      (setq #dPT3 (polar #p2 (angle #p2 #p3)(atoi CG_R)))
      (setq #dPT4 (polar #p3 (angle #p3 #p2)(atoi CG_R)))
      (setq #dPT5 #p3)
      (setq #dPT6 (polar #p3 (angle #p2 #p1)(atoi CG_R)))

      (setq #ePL$
        (list
          (list (##Line #dPT1 #dPT2) #p2)
          (list (##Line #dPT2 #dPT3) #p2)
          (list (##Line #dPT4 #dPT5) #p3)
          (list (##Line #dPT5 #dPT6) #p3)
        )
      )
    )
    ((= &LR "Left")
      (setq #dPT1 (polar #p1   (angle #p1 #p2)  (atoi CG_R)))
      (setq #dPT2 #p1)
      (setq #dPT3 (polar #p1   (angle #p1 #last)(atoi CG_R)))
      (setq #dPT4 (polar #last (angle #last #p1)(atoi CG_R)))
      (setq #dPT5 #last)
      (setq #dPT6 (polar #last (angle #p1 #p2)  (atoi CG_R)))

      (setq #ePL$
        (list
          (list (##Line #dPT1 #dPT2) #p1)
          (list (##Line #dPT2 #dPT3) #p1)
          (list (##Line #dPT4 #dPT5) #last)
          (list (##Line #dPT5 #dPT6) #last)
        )
      )
    )
    (T
      (CFAlertMsg "�q�G���h���H�܂���B")(*error*)
    )
  );_cond
  #ePL$
);KPMakeDummyLineRend

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KPAdd_BG
;;; <�����T�v>  : ����WT��BG��ǉ�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/07/25 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KPAdd_BG (
  /
  #BASEPT #BG0 #BG_H #BG_REGION #BG_SOLID #BG_T
  #CL #CLAYER #CR #CUTTYPE #EPL #EPL$ #EPL_OFFSET #FG_H #FG_S
  #FG_T #GRIDMODE #LOOP #OFPT #ORTHOMODE #OSMODE
  #PD #SNAPMODE #SS #WTEN #WT_H #WT_PT$ #WT_T
  #WT_TEI #XD$ #AUTOSNAP
  )
    ;----------------------------------------------------------------------
    ; ���W�l�̂y��ҏW
    (defun ##ADDZ ( &p &Z / )
      (list (car &p) (cadr &p) &Z)
    )
    ;----------------------------------------------------------------------

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPAdd_BG ////")
  (CFOutStateLog 1 1 " ")
  ;// �R�}���h�̏�����
  (StartUndoErr)

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setq #AUTOSNAP  (getvar "AUTOSNAP"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)
  (setvar "AUTOSNAP"  0)
  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM
  ;// ���[�N�g�b�v�̎w��
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\n���[�N�g�b�v��I��: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
      (setq #loop nil)
    );_if

  );while

  ; WT���E�������0:�Ȃ�,1:J���,2:Y���,3:45���,4:�i���ڑ�
  (setq #CutType (nth 7 #xd$)) ; �������
  ; ��ċL��
  (setq #CL (substr #CutType 1 1))
  (setq #CR (substr #CutType 2 1))
  (if (or (= "3" #CL)(= "3" #CR))
    (progn
      (CFAlertMsg "���̃��[�N�g�b�v�̓o�b�N�K�[�h��ǉ��ł��܂���B")
      (*error*)
    )
    (progn
      ; WT���擾
      (setq #WT_H (nth  8 #xd$))  ; WT����
      (setq #WT_T (nth 10 #xd$))  ; WT����
      (setq #BG_H (nth 12 #xd$))  ; BG����
      (setq #BG_T (nth 13 #xd$))  ; BG����
      (setq #FG_H (nth 15 #xd$))  ; FG����
      (setq #FG_T (nth 16 #xd$))  ; FG����
      (setq #FG_S (nth 17 #xd$))  ; FG��ė�

      ; �e��ʎ擾
      (setq #WT_tei (nth 38 #xd$))   ; WT��ʐ}�`�����
      (setq #BASEPT (nth 32 #xd$))   ; WT����_

      ; WT��ʓ_��擾
      (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))     ; WT�O�`�_��
      (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT ����_���玞�v����ɕ��ёւ���

      (setq #clayer (getvar "CLAYER")); ���݉�w
      ; ������w(�Ȃ���΍쐬)�����݉�w�ɂ��Ă���ȊO���ذ�� �F�ԍ�1-255,����
      (KPSetClayerOtherFreeze SKD_TEMP_LAYER 1 SKW_AUTO_LAY_LINE)
      ; BG�쐬����հ�ް�ɑI�������邽�߂�LINE����} ��w=SKD_TEMP_LAYER�̂ݕ\��
      (setq #ePL$ (KPMakeDummyLineBG #CutType #WT_pt$ (+ #WT_H #WT_T))) ; �߂�l=հ�ް�I��p�ɍ�}����LINE�}�`ؽ�
      ; BG���̎w��(LINE�̎w��)
      (if (< 1 (length #ePL$)) ; �I����������
        (progn
          (initget 0)
          (setq #loop T)
          (while #loop
            (setq #ePL (car (entsel "\n�o�b�N�K�[�h�ǉ������w��: ")))
            (if #ePL
              (progn
                (foreach #e #ePL$
                  (if (equal #ePL #e)
                    (setq #loop nil)
                  );_if
                )
              )
            );_if
          );while
        )
        (setq #ePL (car #ePL$))
      );_if

      ; ������Z=0�Ɉړ�(�̾�Ă����܂������Ȃ�����)
      (command "_move" #ePL "" '(0 0 0) (strcat "@0,0," (rtos (- (+ #WT_H #WT_T)))))

      ; �̾�Ă��Đ�����ǉ�
      (setq #ofPT (mapcar '+ (nth 0 #WT_pt$)(nth 2 #WT_pt$)))
      (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
      (command "_offset" #BG_T #ePL #ofPT "")
      (setq #ePL_offset (entlast))

      ; BG��ʍ쐬
      (setq #BG0
        (MakeTEIMEN
          (list
            (##ADDZ (cdr (assoc 10 (entget #ePL))) 0)
            (##ADDZ (cdr (assoc 11 (entget #ePL))) 0)
            (##ADDZ (cdr (assoc 11 (entget #ePL_offset))) 0)
            (##ADDZ (cdr (assoc 10 (entget #ePL_offset))) 0)
          )
        )
      )
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #BG0)) (entget #BG0))) ; ������ײ�

      ; հ�ް�I��pLINE�Ƶ̾��LINE�̍폜
      (foreach #e #ePL$
        (entdel #e)
      )
      (entdel #ePL_offset)
      ; �\����w�̐ݒ�(���ɖ߂�)
      (SetLayer)
      (setvar "CLAYER" #clayer) ; ���݉�w��߂�
      ; BGSOLID�쐬
      (setvar "delobj" 1) ; �����o����ɒ�ʂ��폜����
      (setq #BG_region (Make_Region2 #BG0))
      (setq #BG_SOLID  (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
      ;BG,WT�̘a���Ƃ�
      (setq #ss (ssadd))
      (ssadd #wtEn #ss)
      (if #BG_SOLID (ssadd #BG_SOLID #ss)) ; BG_SOLID��ǉ�
      (command "_union" #ss "")
      ; �i�Ԋm�肳��Ă���ΐF�ւ�
      (if (CFGetXData #wtEn "G_WTSET")
        (command "_.change" #wtEn "" "P" "C" CG_WorkTopCol "")
      );_if
    )
  );_if

  (setvar "SNAPMODE"  #SNAPMODE )
  (setvar "GRIDMODE"  #GRIDMODE )
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE   )
  (setvar "AUTOSNAP"  #AUTOSNAP )
  (setvar "pdmode" #PD) ; 06/12 YM

  (setq *error* nil)
  (princ)

);C:KPAdd_BG

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KPAdd_FG
;;; <�����T�v>  : ����WT��BG��ǉ�����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/07/25 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KPAdd_FG (
  /
  #AUTOSNAP #BASEPT #BG_H #BG_T #CL #CLAYER #CR #CUTTYPE #EPL #EPL$ #EPL_OFFSET
  #FG0 #FG_H #FG_REGION #FG_S #FG_SOLID #FG_T #GRIDMODE #LOOP #OFPT #ORTHOMODE
  #OSMODE #PD #SNAPMODE #SS #WTEN #WT_H #WT_PT$ #WT_T #WT_TEI #XD$
  )
    ;----------------------------------------------------------------------
    ; ���W�l�̂y��ҏW
    (defun ##ADDZ ( &p &Z / )
      (list (car &p) (cadr &p) &Z)
    )
    ;----------------------------------------------------------------------

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPAdd_FG ////")
  (CFOutStateLog 1 1 " ")
  ;// �R�}���h�̏�����
  (StartUndoErr)

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setq #AUTOSNAP  (getvar "AUTOSNAP"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)
  (setvar "AUTOSNAP"  0)
  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM
  ;// ���[�N�g�b�v�̎w��
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\n���[�N�g�b�v��I��: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
      (setq #loop nil)
    );_if

  );while

  ; WT���E�������0:�Ȃ�,1:J���,2:Y���,3:45���,4:�i���ڑ�
  (setq #CutType (nth 7 #xd$)) ; �������
  ; ��ċL��
  (setq #CL (substr #CutType 1 1))
  (setq #CR (substr #CutType 2 1))
  (if (or (= "3" #CL)(= "3" #CR))
    (progn
      nil ; �����Ȃ�
;;;     (CFAlertMsg "���̃��[�N�g�b�v�̓o�b�N�K�[�h��ǉ��ł��܂���B")
;;;     (*error*)
    )
    (progn
      ; WT���擾
      (setq #WT_H (nth  8 #xd$))  ; WT����
      (setq #WT_T (nth 10 #xd$))  ; WT����
      (setq #BG_H (nth 12 #xd$))  ; BG����
      (setq #BG_T (nth 13 #xd$))  ; BG����
      (setq #FG_H (nth 15 #xd$))  ; FG����
      (setq #FG_T (nth 16 #xd$))  ; FG����
      (setq #FG_S (nth 17 #xd$))  ; FG��ė�

      ; �e��ʎ擾
      (setq #WT_tei (nth 38 #xd$))   ; WT��ʐ}�`�����
      (setq #BASEPT (nth 32 #xd$))   ; WT����_

      ; WT��ʓ_��擾
      (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))     ; WT�O�`�_��
      (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT ����_���玞�v����ɕ��ёւ���

      (setq #clayer (getvar "CLAYER")); ���݉�w
      ; ������w(�Ȃ���΍쐬)�����݉�w�ɂ��Ă���ȊO���ذ�� �F�ԍ�1-255,����
      (KPSetClayerOtherFreeze SKD_TEMP_LAYER 1 SKW_AUTO_LAY_LINE)
      ; BG�쐬����հ�ް�ɑI�������邽�߂�LINE����} ��w=SKD_TEMP_LAYER�̂ݕ\��
      (setq #ePL$ (KPMakeDummyLineFG #CutType #WT_pt$ (+ #WT_H #WT_T))) ; �߂�l=հ�ް�I��p�ɍ�}����LINE�}�`ؽ�
      ; BG���̎w��(LINE�̎w��)
      (if (< 1 (length #ePL$)) ; �I����������
        (progn
          (initget 0)
          (setq #loop T)
          (while #loop
            (setq #ePL (car (entsel "\n�O����ǉ������w��: ")))
            (if #ePL
              (progn
                (foreach #e #ePL$
                  (if (equal #ePL #e)
                    (setq #loop nil)
                  );_if
                )
              )
            );_if
          );while
        )
        (setq #ePL (car #ePL$))
      );_if

      ; ������Z=0�Ɉړ�(�̾�Ă����܂������Ȃ�����)
      (command "_move" #ePL "" '(0 0 0) (strcat "@0,0," (rtos (- (+ #WT_H #WT_T)))))

      ; �̾�Ă��Đ�����ǉ�
      (setq #ofPT (mapcar '+ (nth 0 #WT_pt$)(nth 2 #WT_pt$)))
      (setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
      (command "_offset" #BG_T #ePL #ofPT "")
      (setq #ePL_offset (entlast))

      ; FG��ʍ쐬
      (setq #FG0
        (MakeTEIMEN
          (list
            (##ADDZ (cdr (assoc 10 (entget #ePL))) 0)
            (##ADDZ (cdr (assoc 11 (entget #ePL))) 0)
            (##ADDZ (cdr (assoc 11 (entget #ePL_offset))) 0)
            (##ADDZ (cdr (assoc 10 (entget #ePL_offset))) 0)
          )
        )
      )
      (entmod  (subst (cons 8 SKW_AUTO_SECTION) (assoc 8 (entget #FG0)) (entget #FG0))) ; ������ײ�

      ; հ�ް�I��pLINE�Ƶ̾��LINE�̍폜
      (foreach #e #ePL$
        (entdel #e)
      )
      (entdel #ePL_offset)
      ; �\����w�̐ݒ�(���ɖ߂�)
      (SetLayer)
      (setvar "CLAYER" #clayer) ; ���݉�w��߂�
      ; BGSOLID�쐬
      (setvar "delobj" 1) ; �����o����ɒ�ʂ��폜����
      (setq #FG_region (Make_Region2 #FG0))
      (setq #FG_SOLID  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
      ;FG,WT�̘a���Ƃ�
      (setq #ss (ssadd))
      (ssadd #wtEn #ss)
      (if #FG_SOLID (ssadd #FG_SOLID #ss)) ; FG_SOLID��ǉ�
      (command "_union" #ss "")
      ; �i�Ԋm�肳��Ă���ΐF�ւ�
      (if (CFGetXData #wtEn "G_WTSET")
        (command "_.change" #wtEn "" "P" "C" CG_WorkTopCol "")
      );_if
    )
  );_if

  (setvar "SNAPMODE"  #SNAPMODE )
  (setvar "GRIDMODE"  #GRIDMODE )
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE   )
  (setvar "AUTOSNAP"  #AUTOSNAP )
  (setvar "pdmode" #PD) ; 06/12 YM

  (setq *error* nil)
  (princ)

);C:KPAdd_FG

;<HOM>*************************************************************************
; <�֐���>    : C:KPRendWT
; <�����T�v>  : ���[�N�g�b�v�̒[���q���ނɂ���
; <�߂�l>    : �Ȃ�
; <�쐬>      : 01/07/09 YM
; <���l>      : ��ʂ�FILLET->extrude BG��̌^��z��
; <Ver.UP>      01/08/02 YM
;               �ذ�ނɂ�鐧���Ȃ���.�Б�J��Ă̂�.BG�`��͌���WT�������p��
;               �O�����R���ނɉ����č쐬
;*************************************************************************>MOH<
(defun C:KPRendWT (
  /
;-- 2011/12/17 A.Satoh Mod - S
;-- 2011/08/09 A.Satoh Mod - S
;  #ARC1 #ARC2 #BASEPT #BG_H #BG_SOLID #BG_T #CL #CR #CUTTYPE #DELOBJ
;  #FG_H #FG_S #FG_T #GRIDMODE #KAIJO #LAST #LINE$ #LOOP #ORTHOMODE #OSMODE
;  #P1 #P2 #P3 #PD #RR #SNAPMODE #SS #SS_DUM #WTEN #WTL #WTR #WT_H #WT_PT$
;  #WT_REGION #WT_SOLID #WT_T #WT_TEI #X #XD$ #XDL$ #XDR$ #XD_NEW$ #YESNOMSG
;  #BG #BG0 #BG_REGION #DUM1 #DUM2 #BG_TEI1 #BG_TEI2 #FG_TEI1 #FG_TEI2
;  #dist1 #dist2 #DEP #FG0 #FG_REGION #FG_SOLID #P4 #P5
;  #BG_SOLID1 #BG_SOLID2 #DIST$ #ITYPE
  #SNAPMODE #GRIDMODE #ORTHOMODE #OSMODE #PD #CMDECHO
  #def_rr #rr #ssWT #idx #eWTP #WRKT$ #kaku #BG1 #BG2
;-- 2011/08/09 A.Satoh Mod - E
;|
	#SNAPMODE #GRIDMODE #ORTHOMODE #OSMODE #PD #CMDECHO #loop #wtEn$ #wtEn #xd_WRKT$
	#sel_pnt$ #xd_WTEST$ #kaku #WT_H #WT_T #BG_H #BG_T #FG_H #FG_T #FG_S #WT_tei
	#BASEPT #BG_tei1 #BG_tei2 #FG_tei1 #FG_tei2 #dep #WT_pt$ #pt$ #dist$ #def_rr #rr
	#ss_dum #line$ #arc #FG0 #delobj #WT_region #WT_SOLID #BG_SOLID1 #BG_SOLID2 #BG
	#BG_region #FG_region #FG_SOLID #ss #xd_new$ #WTL #WTR #xdL$ #xdR$ #clayer
|;
;-- 2011/12/17 A.Satoh Mod - E
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPRendWT ////")
  (CFOutStateLog 1 1 " ")

;-- 2011/12/13 A.Satoh Add - S
;|
    ;//////////////////////////////////////////////////////////
		;//////////////////////////////////////////////////////////////////////////
		; ���[�U�[���͂q(�a)���Ó�������(�߂�l:T or nil)
		;//////////////////////////////////////////////////////////////////////////
		(defun ##RENDhantei (
			&dist$ ; (���s��,WT����)
			&R     ; R(�a)
			/
			#ret #dist1 #dist2
			)

			(setq #dist1 (car  &dist$))
			(setq #dist2 (cadr &dist$))

			(if (and (< &R #dist1)(< &R #dist2))
				(setq #ret T)
				(setq #ret nil)
			)

			#ret
		) ;##RENDhantei

		;//////////////////////////////////////////////////////////////////////////
		; &ss("LINE"�I���)�̂����n�_or�I�_��&pt�ƈ�v����}�`ؽĂ�Ԃ�
		;//////////////////////////////////////////////////////////////////////////
		(defun ##GETLINE (
			&ss
			&pt
			/
			#list$ #idx #en
			)

			(setq #list$ nil)
			(if (and &ss (< 0 (sslength &ss)))
				(progn
					(setq #idx 0)
					(repeat (sslength &ss)
						(setq #en (ssname &ss #idx))
						(if (or (< (distance (cdr (assoc 10 (entget #en))) &pt) 0.1)
										(< (distance (cdr (assoc 11 (entget #en))) &pt) 0.1))
							(setq #list$ (append #list$ (list #en)))
						)
						(setq #idx (1+ #idx))
					)
				)
			)

			#list$
		)

		;//////////////////////////////////////////////////////////////////////////
		; &en("LINE"�}�`)-->�n�_,�I�_�����_��Ԃ�
		;//////////////////////////////////////////////////////////////////////////
		(defun ##CENTER_PT (
			&en
			/
			#dum
			)

			(setq #dum (mapcar '+ (cdr (assoc 10 (entget &en))) (cdr (assoc 11 (entget &en)))))

      (setq #dum (mapcar '* #dum '(0.5 0.5 0.5)))

    )

		;//////////////////////////////////////////////////////////////////////////
		; &en(������ʐ}�` or "")���폜����
		;//////////////////////////////////////////////////////////////////////////
		(defun ##ENTDEL (
			&en
			)

			(if (and &en (/= &en "")(entget &en))
				(entdel &en)
			)

			(princ)
		)

		;//////////////////////////////////////////////////////////////////////////
		; fillet����
		;//////////////////////////////////////////////////////////////////////////
		(defun ##FILLET (
			&line$
			/
			#en1 #en2 #sp1 #sp2 #arc
			)

			(if &line$
				(progn
					(setq #en1 (car  &line$))
					(setq #en2 (cadr &line$))
					(setq #sp1 (##CENTER_PT #en1))
					(setq #sp2 (##CENTER_PT #en2))
					(command "_fillet" (list #en1 #sp1)(list #en2 #sp2))
					(setq #arc (entlast))
				)
				(progn
					(CFAlertMsg "�t�B���b�g�������ł��܂���ł����B")(quit)
				)
			)

			#arc
		)
    ;//////////////////////////////////////////////////////////////////////////
|;
;-- 2011/12/13 A.Satoh Add - E

;-- 2011/08/09 A.Satoh Mod - S
  ;// �R�}���h�̏�����
  (StartUndoErr)

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setq #PD        (getvar "PDMODE"))
  (setq #CMDECHO   (getvar "CMDECHO"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)
  (setvar "PDMODE"   34)
  (setvar "CMDECHO"   0)

;-- 2011/12/13 A.Satoh Mod - S
;|
  ; ���݉�w���擾
  (setq #clayer (getvar "CLAYER"))

  ; ������w(�Ȃ���΍쐬)�����݉�w�ɂ��Ă���ȊO���ذ�� �F�ԍ�1-255,����
  (KPSetClayerOtherFreeze SKW_AUTO_SOLID 1 SKW_AUTO_LAY_LINE)

	; �ォ��̎����ɕύX
  (command "vpoint" "0,0,1")
  (command "zoom" "0.8x")

	(setq #loop T)
	(while #loop
		(setq #wtEn$ (entsel "\n���[�N�g�b�v��̂q���H�ʒu��I��"))
		(setq #wtEn (car #wtEn$))
		(if #wtEn
			(setq #xd_WRKT$ (CFGetXData #wten "G_WRKT"))
      (setq #xd_WRKT$ nil)
    )

		(if (= #xd_WRKT$ nil)
			(CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
			(progn
				(setq #sel_pnt$ (cadr #wtEn$))
				(setq #xd_WTEST$ (CFGetXData #wtEn "G_WTSET"))
				(if #xd_WTSET$
					(setq #kaku T)
					(setq #kaku nil)
				)
				(setq #loop nil)
			)
		)
	)

	; ��w�̕\����Ԃ����ɖ߂�
	(SetLayer)

  ; ���݉�w��߂�
  (setvar "CLAYER" #clayer)

	; ���������ɖ߂�
  (command "zoom" "p")
  (command "zoom" "p")

(princ "\nWT�I���ʒu���W = ")(princ #sel_pnt$)

	; WT���擾
	(setq #WT_H    (nth  8 #xd_WRKT$))		; WT����
	(setq #WT_T    (nth 10 #xd_WRKT$))		; WT����
	(setq #BG_H    (nth 12 #xd_WRKT$))		; BG����
	(setq #BG_T    (nth 13 #xd_WRKT$))		; BG����
	(setq #FG_H    (nth 15 #xd_WRKT$))		; FG����
	(setq #FG_T    (nth 16 #xd_WRKT$))		; FG����
	(setq #FG_S    (nth 17 #xd_WRKT$))		; FG��ė�

	; �e��ʎ擾
	(setq #WT_tei  (nth 38 #xd_WRKT$))		; WT��ʐ}�`�����
	(setq #BASEPT  (nth 32 #xd_WRKT$))		; WT����_
	(setq #BG_tei1 (nth 49 #xd_WRKT$))		; BG SOLID1 or ���1
	(setq #BG_tei2 (nth 50 #xd_WRKT$))		; BG SOLID2 or ���2 ��������΂��̂܂�
	(setq #FG_tei1 (nth 51 #xd_WRKT$))		; FG1��� *
	(setq #FG_tei2 (nth 52 #xd_WRKT$))		; F2G��� *
	(setq #dep (car (nth 57 #xd_WRKT$)))	; WT���s��

	; WT��ʓ_��擾
	(setq #WT_pt$ (GetLWPolyLinePt #WT_tei))			; WT�O�`�_��
	(setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$))	; WT ����_���玞�v����ɕ��ёւ���
(princ "\nWT��ʓ_�񃊃X�g = ") (princ #WT_pt$)

	; WT��ʓ_�񃊃X�g����I���ʒu�ɍł��߂����W�_�����߂�
	(setq #pt$ (GetNearPoint #WT_pt$ #sel_pnt$))

(princ "\n���H�ʒu���W = ") (princ #pt$)

	; �q�G���h�i�t�B���b�g�j�ۃ`�F�b�N�p���@�擾
	(setq #dist$ (KPGetRendDist #WT_pt$ #pt$))

	; R(�a)�����
	(setq #def_rr "60")
	(setq #loop T)
	(while #loop
		(setq #rr (getreal (strcat "\n���aR�����<" #def_rr ">: ")))
		(if (= #rr nil)
			(progn
				(setq #rr (atoi #def_rr))
				(setq #loop nil)
			)
			(if (##RENDhantei #dist$ #rr) ; ���s���̔����𒴂��Ă͂����Ȃ�
				(setq #loop nil)
				(progn
					(setq #loop T)
					(princ "\n�l���傫�����ăt�B���b�g�ł��܂���B")
				)
			)
		)
	)

	; �t�B���b�g�~�ʂ̔��a��ݒ�
  (command "_fillet" "R" #rr)

	; �����̃��[�N�g�b�v(�O���ꍞ��3DSOLID)���폜
	(entdel #wtEn)

	; ������ʍ폜
	(##ENTDEL #FG_tei1)
	(##ENTDEL #FG_tei2)

	; WT��ʂ��߰���ĕ���
	(entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT_tei)) (entget #WT_tei)))
	(command "_explode" (entlast))
	(setq #ss_dum (ssget "P"))

	; ��ʂ�Fillet����
	(setq #line$ (##GETLINE #ss_dum #pt$))
	(setq #arc (##FILLET #line$))
	(ssadd #arc #ss_dum)

	; FG��ʍ쐬
	(setq #FG0 (KPMakeFGTeimen_WT #WT_pt$ #arc #FG_T #rr #pt$))

	(setq #delobj (getvar "delobj"))
	(setvar "delobj" 1)

	; Pedit ���ײ݉� WT �č쐬
	(command "_pedit" (ssname #ss_dum 0) "Y" "J" #ss_dum "" "X")

	(setq #WT_region (Make_Region2 (entlast)))
	(setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))

	; BG_SOLID�č쐬
	(setq #BG_SOLID1 nil #BG_SOLID2 nil)
	(if (and #BG_tei1 (/= #BG_tei1 ""))
		(progn
			(entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG_tei1)) (entget #BG_tei1)))
			(setq #BG (entlast))
			(setq #BG_region (Make_Region2 #BG))
			(setq #BG_SOLID1 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
		)
	)

	(if (and #BG_tei2 (/= #BG_tei2 ""))
		(progn
			(entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG_tei2)) (entget #BG_tei2)))
			(setq #BG (entlast))
			(setq #BG_region (Make_Region2 #BG))
			(setq #BG_SOLID2 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
		)
	)

  ; FG_SOLID�č쐬
	(if #FG0
		(progn
			(setq #FG_region (Make_Region2 #FG0))
			(setq #FG_SOLID  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
		)
	);_if

	; �V�X�e���ϐ���߂�
	(setvar "delobj" #delobj)

	(setq #ss (ssadd))
	(ssadd #WT_SOLID #ss)

	; BG_SOLID��ǉ�
	(if #BG_SOLID1
		(ssadd #BG_SOLID1 #ss)
	)

	; BG_SOLID��ǉ�
	(if #BG_SOLID2
		(ssadd #BG_SOLID2 #ss)
	)

	; FG_SOLID��ǉ�
	(if #FG_SOLID
		(ssadd #FG_SOLID #ss)
	)

	;BG,WT�̘a���Ƃ�i�����Ȃ��̈�ł��n�j�I�j
	(command "_union" #ss "")

	;// �g���f�[�^�̍Đݒ� �O����Ȃ�
	(setq #xd_new$ (list (list 51 "") (list 52 "")))
	(CFSetXData #WT_SOLID "G_WRKT" (CFModList #xd_WRKT$ #xd_new$))

	(setq #WTL (nth 47 #xd_WRKT$)) ; ��đ���WT��
	(setq #WTR (nth 48 #xd_WRKT$)) ; ��đ���WT�E

	;����WT�̊g���f�[�^���X�V����
	(if (and (/= #WTL "") (/= #WTL nil))
		(progn
			(setq #xdL$ (CFGetXData #WTL "G_WRKT"))
			(CFSetXData #WTL "G_WRKT" (CFModList #xdL$ (list (list 48 #WT_SOLID))))
		)
	)

  ;�E��WT�̊g���f�[�^���X�V����
  (if (and (/= #WTR "") (/= #WTR nil))
    (progn
      (setq #xdR$ (CFGetXData #WTR "G_WRKT"))
      (CFSetXData #WTR "G_WRKT" (CFModList #xdR$ (list (list 47 #WT_SOLID))))
		)
	)
|;

  ; �t�B���b�g�����s
  (princ "\n�V�̊p��I��: ")
  (command "_.FILLET" pause)

  ; R(�a)�����
  (setq #def_rr "60")
  (setq #rr (getreal (strcat "\n���aR�����<" #def_rr ">: ")))
  (if (= #rr nil)
    (setq #rr (atoi #def_rr))
  )
  (command #rr "")

  ; ���[�N�g�b�v:�t�B���b�g�����̐F��ς���
  (setq #ssWT (ssget "X" '((-3 ("G_WRKT")))))
  (if (and #ssWT (> (sslength #ssWT) 0))
    (progn
      (setq #idx 0)
      (repeat (sslength #ssWT)
        (setq #eWTP (ssname #ssWT #idx))

        (setq #WRKT$ (CFGetXData #eWTP "G_WRKT"))

        (if (CFGetXData #eWTP "G_WTSET")
          (setq #kaku T)
          (setq #kaku nil)
        )

        (if (= #kaku T)
          (progn
            (command "_.change" #eWTP "" "P" "C" CG_WorkTopCol "")

            ; BG,FG���ꏏ�ɐF�ւ�����
            (setq #BG1 (nth 49 #WRKT$))
            (setq #BG2 (nth 50 #WRKT$))
            (if (/= #BG1 "")
              (if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
                (command "_.change" #BG1 "" "P" "C" CG_WorkTopCol "")
              )
            );_if
            (if (/= #BG2 "")
              (if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
                (command "_.change" #BG2 "" "P" "C" CG_WorkTopCol "")
              )
            )
          )
          (progn
            (command "_.change" #eWTP "" "P" "C" "BYLAYER" "")
          )
        )

        (setq #idx (1+ #idx))
      )
    )
  )
;-- 2011/12/13 A.Satoh Mod - E

  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)
  (setvar "PDMODE"    #PD)
  (setvar "CMDECHO"   #CMDECHO)

  (setq *error* nil)
  (princ)

;|
    ;//////////////////////////////////////////////////////////////////////////
    ;հ�ް����R(�a)���Ó�������(�߂�l:T or nil)
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##RENDhantei (
      &dist$ ; (���s��,WT����)
      &iType ; R�������� 1:���� , 2:�E�� , 3:����
      &R     ; R(�a)
      /
      #ret #dist1 #dist2
      )
      (setq #dist1 (car  &dist$))
      (setq #dist2 (cadr &dist$))
      (cond
        ((or (= &iType 2)(= &iType 3))
          (if (and (< &R #dist1)(< &R #dist2))
            (setq #ret T)
            (setq #ret nil)
          );_if
        )
        ((= &iType 1) ; ����
          (if (and (< &R (* 0.5 #dist1))(< &R #dist2))
            (setq #ret T)
            (setq #ret nil)
          );_if
        )
      );_cond
      #ret
    );##RENDhantei
    ;//////////////////////////////////////////////////////////////////////////
    ;&ss("LINE"�I���)�̂����n�_or�I�_��&pt�ƈ�v����}�`ؽĂ�Ԃ�
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##GETLINE (
      &ss
      &pt
      /
      #EN #I #LIST$
      )
      (setq #list$ nil)
      (if (and &ss (< 0 (sslength &ss)))
        (progn
          (setq #i 0)
          (repeat (sslength &ss)
            (setq #en (ssname &ss #i))
            (if (or (< (distance (cdr (assoc 10 (entget #en))) &pt) 0.1)
                    (< (distance (cdr (assoc 11 (entget #en))) &pt) 0.1))
              (setq #list$ (append #list$ (list #en)))
            );_if
            (setq #i (1+ #i))
          )
        )
      );_if
      #list$
    )
    ;//////////////////////////////////////////////////////////////////////////
    ;&en("LINE"�}�`)-->�n�_,�I�_�����_��Ԃ�
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##CENTER_PT ( &en / #DUM)
      (setq #dum (mapcar '+ (cdr (assoc 10 (entget &en)))
                            (cdr (assoc 11 (entget &en)))))
      (setq #dum (mapcar '* #dum '(0.5 0.5 0.5)))
    )

    ;//////////////////////////////////////////////////////////////////////////
    ;&en(������ʐ}�` or "")���폜����
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##ENTDEL ( &en / )
      (if (and &en (/= &en "")(entget &en))
        (entdel &en)
      );_if
      (princ)
    )

    ;//////////////////////////////////////////////////////////////////////////
    ;fillet����
    ;//////////////////////////////////////////////////////////////////////////
    (defun ##FILLET ( &line$ / #ARC #EN1 #EN2 #SP1 #SP2)
      (if &line$
        (progn
          (setq #en1 (car  &line$))
          (setq #en2 (cadr &line$))
          (setq #sp1 (##CENTER_PT #en1))
          (setq #sp2 (##CENTER_PT #en2))
          (command "_fillet" (list #en1 #sp1)(list #en2 #sp2))
          (setq #arc (entlast))
        )
        (progn
          (CFAlertMsg "�t�B���b�g�������ł��܂���ł����B")(quit)
        )
      );_if
      #arc
    )

    ;//////////////////////////////////////////////////////////

  (setq #KAIJO nil)  ; �i�Ԋm������׸�
  ;// �R�}���h�̏�����
  (StartUndoErr)
  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)
  (setq #PD (getvar "pdmode")) ; 06/12 YM
  (setvar "pdmode" 34)         ; 06/12 YM
  ;// ���[�N�g�b�v�̎w��
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\n���[�N�g�b�v��I��: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
    ;else
      (cond
        ((CFGetXData #wtEn "G_WTSET")
          (setq #YesNoMsg "���[�N�g�b�v�͕i�Ԋm�肳��Ă��܂��B\n�����𑱂��܂����H")
          (if (CFYesNoDialog #YesNoMsg)
            (progn
              (setq #loop nil) ; YES �Ȃ�p��
              (setq #KAIJO T)  ; �i�Ԋm������׸�
            )
            (*error*)        ; NO  �Ȃ�STOP
          );_if
        )
        (T
          (setq #loop nil)
        )
      );_cond
    );_if

  );while

  ; �������� �l��J��ĂȂ�R���މ\
  (setq #CutType (nth 7 #xd$)) ; �������
  ; ��ċL��
  (setq #CL (substr #CutType 1 1))
  (setq #CR (substr #CutType 2 1))

  (cond
    ((and (= #CL "1") (= #CR "0"))
      (setq #x "Right") ; R���ޑ�=�E
    )
    ((and (= #CL "0") (= #CR "1"))
      (setq #x "Left") ; R���ޑ�=��
    )
    (T
      (CFAlertMsg "���̃��[�N�g�b�v�͂q�G���h���H�ł��܂���B")(quit)
    )
  );_cond

  (PCW_ChColWT #wtEn "MAGENTA" nil) ; �F��ς���

  ; WT���擾
  (setq #WT_H (nth  8 #xd$))  ; WT����
  (setq #WT_T (nth 10 #xd$))  ; WT����
  (setq #BG_H (nth 12 #xd$))  ; BG����
  (setq #BG_T (nth 13 #xd$))  ; BG����
  (setq #FG_H (nth 15 #xd$))  ; FG����
  (setq #FG_T (nth 16 #xd$))  ; FG����
  (setq #FG_S (nth 17 #xd$))  ; FG��ė�

  ; �e��ʎ擾
  (setq #WT_tei (nth 38 #xd$))   ; WT��ʐ}�`�����
  (setq #BASEPT (nth 32 #xd$))   ; WT����_
  (setq #BG_tei1 (nth 49 #xd$))  ; BG SOLID1 or ���1
  (setq #BG_tei2 (nth 50 #xd$))  ; BG SOLID2 or ���2 ��������΂��̂܂�
  (setq #FG_tei1 (nth 51 #xd$))  ; FG1��� *
  (setq #FG_tei2 (nth 52 #xd$))  ; F2G��� *
  (setq #dep (car (nth 57 #xd$))); WT���s��

  ; WT��ʓ_��擾
  (setq #WT_pt$ (GetLWPolyLinePt #WT_tei))     ; WT�O�`�_��
  (setq #WT_pt$ (GetPtSeries #BASEPT #WT_pt$)) ; WT ����_���玞�v����ɕ��ёւ���
  (setq #p1 (nth 0 #WT_pt$)) ; WT����_
  (setq #p2 (nth 1 #WT_pt$)) ; WT�E��_
  (setq #p3 (nth 2 #WT_pt$))
  (setq #p4 (nth 3 #WT_pt$))
  (setq #p5 (nth 4 #WT_pt$))
  (setq #last (last #WT_pt$))
  ; R���މ������p���@ WT�������"10","01"
  (setq #dist$ (KPGetRendDist #WT_pt$ #CutType)) ; (���s��,WT����)
;;; &WT_pt$  ; WT�O�`�_��
;;; &CutType ; WT�������"00","20"�Ȃ�"���E" 0:��ĂȂ�,1:J���,2:Y���,3:45�x���,4:�i���ڑ�

  ; ���H���߂����
  (setq #loop T)
  (while #loop
    (setq #iType (getint "\nR�������� /1=����/2=����/3=�E��/ <����>:  "))
    (if (= #iType nil)
      (progn
        (setq #iType 1)
        (setq #loop nil)
      )
      (progn
        (if (or (= #iType 1)(= #iType 2)(= #iType 3))
          (setq #loop nil)
          (setq #loop T)
        );_if
      )
    ); if
  )

  ; R(�a)�����
  (setq #loop T)
  (while #loop
    (setq #rr (getreal (strcat "\n�q�����<" CG_R ">: ")))
    (if (= #rr nil)
      (progn
        (setq #rr CG_R)
        (setq #loop nil)
      )
      (progn
        (if (##RENDhantei #dist$ #iType #rr) ; ���s���̔����𒴂��Ă͂����Ȃ�
          (progn ; ����ر�
            (setq #rr (rtos #rr)) ; string
            (setq #loop nil)
          )
          (progn
            (setq #loop T)
            (princ "\n�l���傫�����ăt�B���b�g�ł��܂���B")
          )
        );_if
      )
    ); if
  )

  (command "_fillet" "R" #rr)

  ; �F��߂�
  (PCW_ChColWT #wtEn "BYLAYER" nil)

  ;// �����̃��[�N�g�b�v(�O���ꍞ��3DSOLID)���폜
  (entdel #wtEn)
  ; ������ʍ폜
;;; (##ENTDEL #BG_tei1)
;;; (##ENTDEL #BG_tei2)
  (##ENTDEL #FG_tei1)
  (##ENTDEL #FG_tei2)

  ; WT��ʂ��߰���ĕ���
  (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #WT_tei)) (entget #WT_tei)))
  (command "_explode" (entlast))
  (setq #ss_dum (ssget "P")) ; LINE�̏W�܂�
  ; ��ʂ�Fillet����
  (cond
    ((= #x "Right")
      (cond
        ((= #iType 1) ; ����R����
          (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2��[�_�Ɏ���"LINE"��ؽĂ��擾
          (setq #arc1  (##FILLET #line$))       ; Fillet����"ARC"���擾
          (setq #line$ (##GETLINE #ss_dum #p3))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc1 #ss_dum)
          (ssadd #arc2 #ss_dum)
          ; FG��ʍ쐬 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen #x #WT_pt$ #arc1 #arc2 #FG_T #rr))
        )
        ((= #iType 2) ; ����R����
;;;         (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2��[�_�Ɏ���"LINE"��ؽĂ��擾
;;;         (setq #arc1  (##FILLET #line$))       ; Fillet����"ARC"���擾
          (setq #line$ (##GETLINE #ss_dum #p3))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc2 #ss_dum)
          ; FG��ʍ쐬 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen_R2 #WT_pt$ #arc2 #FG_T #rr))
        )
        ((= #iType 3) ; �E��R����
          (setq #line$ (##GETLINE #ss_dum #p2)) ; #p2��[�_�Ɏ���"LINE"��ؽĂ��擾
          (setq #arc1  (##FILLET #line$))       ; Fillet����"ARC"���擾
;;;         (setq #line$ (##GETLINE #ss_dum #p3))
;;;         (setq #arc2  (##FILLET #line$))
          ; FG��ʍ쐬 01/07/10 YM ADD
          (ssadd #arc1 #ss_dum)
          (setq #FG0 (KPMakeFGTeimen_R3 #WT_pt$ #arc1 #FG_T #rr))
        )
      );_cond
    )
    ((= #x "Left")
      (cond
        ((= #iType 1) ; ����R����
          (setq #line$ (##GETLINE #ss_dum #p1))
          (setq #arc1  (##FILLET #line$))
          (setq #line$ (##GETLINE #ss_dum #last))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc1 #ss_dum)
          (ssadd #arc2 #ss_dum)
          ; FG��ʍ쐬 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen #x #WT_pt$ #arc1 #arc2 #FG_T #rr))
        )
        ((= #iType 2) ; ����R����
          (setq #line$ (##GETLINE #ss_dum #p1))
          (setq #arc1  (##FILLET #line$))
;;;         (setq #line$ (##GETLINE #ss_dum #last))
;;;         (setq #arc2  (##FILLET #line$))
          ; FG��ʍ쐬 01/07/10 YM ADD
          (ssadd #arc1 #ss_dum)
          (setq #FG0 (KPMakeFGTeimen_L2 #WT_pt$ #arc1 #FG_T #rr))
        )
        ((= #iType 3) ; �E��R����
;;;         (setq #line$ (##GETLINE #ss_dum #p1))
;;;         (setq #arc1  (##FILLET #line$))
          (setq #line$ (##GETLINE #ss_dum #last))
          (setq #arc2  (##FILLET #line$))
          (ssadd #arc2 #ss_dum)
          ; FG��ʍ쐬 01/07/10 YM ADD
          (setq #FG0 (KPMakeFGTeimen_L3 #WT_pt$ #arc2 #FG_T #rr))
        )
      );_cond
    )
  );_cond

;;; ; Fillet�ɂ���č쐬���ꂽ"ARC"��ǉ�����-->pedit
;;; (ssadd #arc1 #ss_dum)
;;; (ssadd #arc2 #ss_dum)

  (setq #delobj (getvar "delobj")) ; extrude��̒�ʂ�ێ�����  "delobj"=0
  (setvar "delobj" 1)              ; extrude��̒�ʂ�ێ����Ȃ�"delobj"=1

  ; Pedit ���ײ݉� WT �č쐬
  (command "_pedit" (ssname #ss_dum 0) "Y" "J" #ss_dum "" "X") ; "X" ���ײ݂̑I�����I��

  (setq #WT_region (Make_Region2 (entlast)))
  (setq #WT_SOLID (PKMKWT #WT_region #WT_T #WT_H))

;;; BG_SOLID�č쐬
;;; #BG_tei1
;;; #BG_tei2
  (setq #BG_SOLID1 nil #BG_SOLID2 nil)
  (if (and #BG_tei1 (/= #BG_tei1 ""))
    (progn
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG_tei1)) (entget #BG_tei1))) ; SOLID��w�ɂ���-->�����o���p
      (setq #BG (entlast)) ; extrude�p
      (setq #BG_region (Make_Region2 #BG))
      (setq #BG_SOLID1 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
    )
  );_if

  (if (and #BG_tei2 (/= #BG_tei2 ""))
    (progn
      (entmake (subst (cons 8 SKW_AUTO_SOLID) (assoc 8 (entget #BG_tei2)) (entget #BG_tei2))) ; SOLID��w�ɂ���-->�����o���p
      (setq #BG (entlast)) ; extrude�p
      (setq #BG_region (Make_Region2 #BG))
      (setq #BG_SOLID2 (PKMKBG2 #BG_region #BG_H #WT_T #WT_H))
    )
  );_if

  ; FG_SOLID�č쐬
  (if #FG0
    (progn
      (setq #FG_region (Make_Region2 #FG0))
      (setq #FG_SOLID  (PKMKFG2 #FG_region #FG_H #WT_H #WT_T))
    )
  );_if

  (setvar "delobj" #delobj) ; �V�X�e���ϐ���߂�

  (setq #ss (ssadd))
  (ssadd #WT_SOLID #ss)
  (if #BG_SOLID1 (ssadd #BG_SOLID1 #ss)) ; BG_SOLID��ǉ�
  (if #BG_SOLID2 (ssadd #BG_SOLID2 #ss)) ; BG_SOLID��ǉ�
  (if #FG_SOLID  (ssadd #FG_SOLID #ss))  ; FG_SOLID��ǉ�

  ;BG,WT�̘a���Ƃ�
  (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I

  ;// �g���f�[�^�̍Đݒ� �O����Ȃ�
  (setq #xd_new$
  (list
    (list 51   "");[52]:FG ��ʐ}�`�����1
    (list 52   "");[53]:FG ��ʐ}�`�����2
  ))
  (CFSetXData #WT_SOLID "G_WRKT"
    (CFModList #xd$ #xd_new$)
  )

  (setq #WTL (nth 47 #xd$)) ; ��đ���WT��
  (setq #WTR (nth 48 #xd$)) ; ��đ���WT�E

  ;����WT�̊g���f�[�^���X�V����
  (if (and (/= #WTL "") (/= #WTL nil))
    (progn
      (setq #xdL$ (CFGetXData #WTL "G_WRKT")) ; ����
      (CFSetXData #WTL "G_WRKT"
        (CFModList #xdL$
          (list
            (list 48 #WT_SOLID)     ;[49]�J�b�g����WT����ىE U�^�͍��E�ɂ���
          )
        )
      )
    )
  );_if

  ;�E��WT�̊g���f�[�^���X�V����
  (if (and (/= #WTR "") (/= #WTR nil))
    (progn
      (setq #xdR$ (CFGetXData #WTR "G_WRKT")) ; �E��
      (CFSetXData #WTR "G_WRKT"
        (CFModList
          #xdR$
          (list
            (list 47 #WT_SOLID)     ;[48]�J�b�g����WT����ٍ� U�^�͍��E�ɂ���
          )
        )
      )
    )
  );_if

  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)
  (setvar "pdmode" #PD) ; 06/12 YM
  (if #KAIJO
    (princ "\n�i�Ԋm�肪��������܂����B")
  );_if

  (setq *error* nil)
  (princ)
|;
;-- 2011/08/09 A.Satoh Mod - E

);C:KPRendWT


;-- 2011/12/17 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <�֐���>    : GetNearPoint
;;; <�����T�v>  : �_�񃊃X�g����w��̍��W�ɍł��߂����W�_�����߂�
;;; <�߂�l>    : ���W�_
;;; <�쐬>      : 11/12/17 A.Satoh
;;; <���l>      : 2D�̂ݑΉ��i���������߂�ہA�y���W�͍l�����Ȃ��j
;;;*************************************************************************>MOH<
(defun GetNearPoint (
	&point$		; �_�񃊃X�g
	&pnt$				; �������̎w����W
	/
	#pnt$ #ret$ #wk_dist #idx #dist
	)

	(setq #pnt$ (list (car &pnt$) (cadr &pnt$)))

	(setq #ret$ (car &point$))
	(setq #wk_dist (distance #pnt$ (car &point$)))
	(setq #idx 1)
	(repeat (1- (length &point$))
		(setq #dist (distance #pnt$ (nth #idx &point$)))
		(if (> #wk_dist #dist)
			(progn
				(setq #ret$ (nth #idx &point$))
				(setq #wk_dist #dist)
			)
		)
		(setq #idx (1+ #idx))
	)

	#ret$

) ;GetNearPoint


;<HOM>*************************************************************************
; <�֐���>    : KPMakeFGTeimen_WT
; <�����T�v>  : FG���PLINE�쐬
; <�߂�l>    : FG��ʐ}�`PLINE
; <�쐬>      : 11/12/17 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun KPMakeFGTeimen_WT (
	&WT_pt$  ;WT�O�`�_��
	&arc     ; �~�ʍ���
	&FG_T    ; �O�������
	&rr      ; R(�~�ʂ̔��a)
	&pnt$    ; R���H�ʒu���W
  /
  )

	; ���݉�w�̕ύX
	(setq #clayer (getvar "CLAYER"))
	(setvar "CLAYER" SKW_AUTO_SOLID)

	(setq #idx 0)
	(repeat (length &WT_pt$)
		(if (= &pnt$ (nth #idx &WT_pt$))
			(if (= #idx 0)
				(progn
					(setq #p1$ (nth (1- (length &WT_pt$)) &WT_pt$))
					(setq #p2$ (nth 1 &WT_pt$))
				)
				(if (= #idx (1- (length &WT_pt$)))
					(progn
						(setq #p1$ (nth (1- #idx) &WT_pt$))
						(setq #p2$ (nth 0 &WT_pt$))
					)
					(progn
						(setq #p1$ (nth (1- #idx) &WT_pt$))
						(setq #p2$ (nth (1+ #idx) &WT_pt$))
					)
				)
			)
		)
		(setq #idx (1+ #idx))
	)

	(setq #p1   (nth 0 &WT_pt$)) ; WT����_
	(setq #p2   (nth 1 &WT_pt$)) ; WT�E��_
	(setq #p3   (nth 2 &WT_pt$))
	(setq #p4   (nth 3 &WT_pt$))
	(setq #p5   (nth 4 &WT_pt$))
	(setq #last (last  &WT_pt$))

	(setq #ssFG (ssadd))

	; �~�ʕ����쐬
	(entmake (entget &arc))
	(setq #arc (entlast))

	(setq #ofPT (mapcar '+ #p1$ #p2$))
	(setq #ofPT (mapcar '* #ofPT '(0.5 0.5 0.5)))
	(command "_offset" &FG_T #arc #ofPT "")
	(setq #arc_in (entlast))

  ; ����J���
  ; a1               a2
  ; +----------------+
  ; +a0--------------+�@<--����ARC11_in,�O��ARC11
  ; |  "Right"         + +a3
  ; |                  | |
  ; |  a7          a8  + +a4
  ; +---+------------+�@<--����ARC22_in,�O��ARC22
  ;     +------------+
  ;    a6            a5

	(setq #a0 (polar #p1 (angle #p2 #p3) &FG_T))
	(setq #a1 #p1)
	(setq #a2 #p2)
	(setq #a3 #p2)
	(setq #a4 (polar #p3 (angle #p3 #p2) (atof &rr)))
	(setq #a5 (polar #p3 (angle #p2 #p1) (atof &rr)))
	(setq #a6 #p4)
	(setq #a7 (polar #a6 (angle #p3 #p2) &FG_T))

	(setq #a2_in (polar #p2    (angle #p2 #p1) &FG_T))
	(command "._line" #a2 #a2_in "")
	(setq #line1 (entlast))

	(command "._line" #a3 #a4 "")
	(setq #line2 (entlast))

	(command "_offset" &FG_T #line2 #ofPT "")
	(setq #line2_in (entlast))

	(command "._line" #a5 #a6 "")
	(setq #line3 (entlast))
	(command "_offset" &FG_T #line3 #ofPT "")
	(setq #line3_in (entlast))

	(command "._line" #a6 #a7 "")
	(setq #line4 (entlast))

	(command "._line" #a1 #a0 "")
	(setq #line5 (entlast))

	(ssadd #arc #ssFG)
	(ssadd #arc_in #ssFG)

	(ssadd #line1 #ssFG)
	(ssadd #line2 #ssFG)
	(ssadd #line2_in #ssFG)
	(ssadd #line3 #ssFG)
	(ssadd #line3_in #ssFG)
	(ssadd #line4 #ssFG)
	(ssadd #line5 #ssFG)

	(command "_pedit" #arc "Y" "J" #ssFG "" "X") ; "X" ���ײ݂̑I�����I��
	(setq #fg0 (entlast))

	; ���݉�w��߂�
	(setvar "CLAYER" #clayer)

	#fg0

) ;KPMakeFGTeimen_WT
;-- 2011/12/17 A.Satoh Add - E


;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KPCutWKTOP
;;; <�����T�v>  : ���[�N�g�b�v�̐؂茇�����s��
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/08/17 YM
;;; <���l>      : �؂茇��������SOLID��հ�ް���쐬����PLINE�������o��
;;;*************************************************************************>MOH<
(defun C:KPCutWKTOP (
  /
  #EREC #ESOLID #ITYPE #LOOP #OBJ #REC$ #SCECOLOR #STYPE #TCLOSE #WTEN #XD$
;-- 2011/09/07 A.Satoh Add - S
  #wt_xd$
;-- 2011/09/07 A.Satoh Add - E
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KPCutWKTOP ////")
  (CFOutStateLog 1 1 " ")
  ;// �R�}���h�̏�����
  (StartUndoErr)

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

  ;// ���[�N�g�b�v�̎w��
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\n���[�N�g�b�v��I��: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
      (setq #loop nil)
    );_if

  );while

  ;// �r���[��o�^
  (command "_view" "S" "TEMP_WTCUT")
  (command "vpoint" "0,0,1")

  ; �}�`�F�ԍ��̕ύX
  (setq #sCECOLOR (getvar "CECOLOR"))

  (if (CFGetXData #wtEn "G_WTSET")
    (setvar "CECOLOR" CG_WorkTopCol)
    (setvar "CECOLOR" "7")
  );_if

  ; �Ώۗ̈�}�`�̎�ނ�I��
  (princ "\n�؂茇���͈͂̎w��: ")
  (initget "1 2")
  (setq #sType (getkword "\n��`(1)/�̈�(2)<1>: "))
  (if (= nil #sType)
    (setq #sType "1")
  )
  (setq #iType (atoi #sType))
  ; ���o���̈�̍쐬
  (if (< 0 #iType)
    (progn
      ; �̈�I���E��}
      (setq #Rec$ (CFDrawRectOrRegionTransUcs #iType))
      (setq #eRec (entlast))
      ; 70�Ԃ�1���ǂ���(���Ă��邩)
      (setq #tClose (cdr (assoc 70 (entget #eRec))))
      (if (= #tClose 1)
        (progn
          (setq #obj (getvar "delobj"))
          (setvar "delobj" 1) ; 0 �I�u�W�F�N�g�͕ێ�����܂��B
          ;2008/07/28 YM MOD 2009�Ή�
;-- 2011/06/23 A.Satoh - S
          (command "_.extrude" #eRec "" 3000) ; ����PLINE��Z�����ɉ����o��
;         (command "_.extrude" #eRec "" 3000 "") ; ����PLINE��Z�����ɉ����o��
;-- 2011/06/23 A.Satoh - E
;;;         (command "_.extrude" #eRec "" 3000 "") ; ����PLINE��Z�����ɉ����o��
          (setq #eSOLID (entlast)) ; SOLID �}�`��
          (command "_subtract" #wtEn "" #eSOLID "") ;�����Z
          (setvar "delobj" #obj) ; 0 �A�C�e���͕ێ�����܂�

;--2011/09/07 A.Satoh Add - S
          (setq #wt_xd$ (CFGetXData #wtEn "G_WTSET"))
          (if (/= #wt_xd$ nil)
            (CFSetXData #wtEn "G_WTSET" (CFModList #wt_xd$ (list (list 0 0))))
          )
          (CFSetXData #wtEn "G_WRKT" (CFModList #xd$ (list (list 58 "TOKU"))))
;--2011/09/07 A.Satoh Add - E
        )
        (progn
          (CFAlertMsg "\n�����|�����C�����쐬���ĉ������B")
          (quit)
        )
      );_if
    )
  )

  ;// �r���[��߂�
  (command "_view" "R" "TEMP_WTCUT")

  ; �V�X�e���ϐ������ɖ߂�
  (setvar "CECOLOR" #sCECOLOR)

  (setq *error* nil)
  (princ)
);C:KPCutWKTOP

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:BG_FG_ADD
;;; <�����T�v>  : ��BG_�O����ǉ��R�}���h
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 11/09/27 A.Satoh
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun C:BG_FG_ADD (
  /
  #err_flg #SNAPMODE #GRIDMODE #ORTHOMODE #OSMODE
  #ssWT #loop #wtEn #xd$ #syori #iHEIGH #iTHIN
  #list$ #msg #inp_flg
  )

;-- 2012/03/01 A.Satoh Add - S
	;****************************************************
	; �G���[����
	;****************************************************
  (defun BG_FG_ADDUndoErr( &msg )
    (command "_undo" "b")
    (CFCmdDefFinish)
    (setq *error* nil)
    (princ)
  )
	;****************************************************
;-- 2012/03/01 A.Satoh Add - E

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:BG_FG_ADD ////")
  (CFOutStateLog 1 1 " ")

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

;-- 2012/03/01 A.Satoh Del - S
;;;;;  ; �R�}���h�̏�����
;;;;;  (StartUndoErr)
;-- 2012/03/01 A.Satoh Del - E

;-- 2012/03/01 A.Satoh Add - S
  (setq *error* BG_FG_ADDUndoErr)
;-- 2012/03/01 A.Satoh Add - E
  (setq #err_flg nil)
  (setq #inp_flg nil)
  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)
;-- 2012/03/01 A.Satoh Add - S
  (command "_undo" "M")
  (command "_undo" "a" "off")
  (CFCmdDefBegin 6)
;-- 2012/03/01 A.Satoh Add - E

  (setq #ssWT (ssget "X" '((-3 ("G_WRKT")))))
  (if (or (= nil #ssWT)(= 0 (sslength #ssWT)))
    (progn
      (CFAlertMsg "\n�}�ʏ�Ƀ��[�N�g�b�v������܂���B")
      (setq #err_flg T)
    )
  )

  (if (= #err_flg nil)
    (progn
      ; ���[�N�g�b�v�̎w��
      (setq #loop T)
      (while #loop
        (setq #wtEn (car (entsel "\n���[�N�g�b�v��I��: ")))
        (if #wtEn
          (setq #xd$ (CFGetXData #wten "G_WRKT"))
          (setq #xd$ nil)
        )

        (if (= #xd$ nil)
          (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
          (setq #loop nil)
        )
      )

      ; BG/�O����I���_�C�A���O����
      (setq #syori (BG_FG_ADD_Dlg))
      (if (/= #syori nil)
        (progn
          (if (= #syori 1)
            (progn
              (setq #iHEIGH (nth 12 #xd$)) ; SOLID�����o������
              (setq #iTHIN (nth 13 #xd$))  ; SOLID����
            )
            (progn
              (setq #iHEIGH (- 0 (nth 15 #xd$))) ; SOLID�����o������
              (setq #iTHIN (nth 16 #xd$))              ; SOLID����
            )
          )

          (if (or (equal #iHEIGH 0 0.01) (equal #iTHIN 0 0.01))
            (progn
              (setq #list$ (BG_FG_ADD_InputDlg #syori #iHEIGH #iTHIN))
              (if (= #list$ nil)
                (progn
                  (if (= #syori 1)
                    (setq #msg "�ޯ��ް�ނ̍����A���݂��ݒ肳��Ă��܂���B\n������ݾق��܂��B")
                    (setq #msg "�O����̍����A���݂��ݒ肳��Ă��܂���B\n������ݾق��܂��B")
                  )
                  (CFAlertMsg #msg)
                  (setq #err_flg T)
                )
                (progn
                  (setq #iHEIGH (nth 0 #list$)) ; SOLID�����o������
                  (setq #iTHIN  (nth 1 #list$)) ; SOLID����
                  (setq #inp_flg T)
                )
              )
            )
          )
;;;;;          (BG_FG_ADD_MakeBGinsertSUB #wtEn #syori #iHEIGH #iTHIN)
        )
      )
    )
  )

  (if (= #err_flg nil)
    (progn
      (BG_FG_ADD_MakeBGinsertSUB #wtEn #syori #iHEIGH #iTHIN)
      (if (= #inp_flg T)
        (if (= #syori 1)
          (CFSetXData #wtEn "G_WRKT"
            (CFModList #xd$
              (list
                (list 12 (* #iHEIGH 1.0))
                (list 13 (* #iTHIN 1.0))
              )
            )
          )
          (CFSetXData #wtEn "G_WRKT"
            (CFModList #xd$
              (list
                (list 15 (* #iHEIGH 1.0))
                (list 16 (* #iTHIN 1.0))
              )
            )
          )
        )
      )
    )
  )

;-- 2012/03/01 A.Satoh Add - S
	(CFCmdDefFinish)
;-- 2012/03/01 A.Satoh Add - E
  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)

  (setq *error* nil)

;  (alert "�������@�H�����@������")
  (princ)
) ;C:BG_FG_ADD

;-- 2011/09/27 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <�֐���>    : BG_FG_ADD_Dlg
;;; <�����T�v>  : BG/�O����I���_�C�A���O����
;;; <����>      : �Ȃ�
;;; <�߂�l>    : 1:�o�b�N�K�[�h 2:�O���� nil:�L�����Z��
;;; <�쐬>      : 11/09/27 A.Satoh
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun BG_FG_ADD_Dlg (
  /
  #dcl_id #ret
  )

;***************************************************************
  (defun ##GetItemData (
    /
    #err_flg #syori #bg #fg
    )

    (setq #err_flg nil)
    (setq #syori nil)

    (setq #bg (get_tile "radBG"))
    (setq #fg (get_tile "radFG"))

    ; ���̓`�F�b�N
    (if (and (= #bg "0") (= #fg "0"))
      (progn
        (alert "�ޯ��ް��/�O���ꂪ�I������Ă��܂���B")
        (setq #err_flg T)
      )
    )

    (if (= #err_flg nil)
      (progn
        (if (= #bg "1")
          (setq #syori 1)
          (setq #syori 2)
        )

        (done_dialog)
      )
    )

    #syori

  ) ; ##GetItemData
;***************************************************************

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))

  (if (= nil (new_dialog "BG_FG_Dlg" #dcl_id)) (exit))

  (action_tile "accept" "(setq #ret (##GetItemData))")
  (action_tile "cancel" "(setq #ret nil)(done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)

  #ret

) ;BG_FG_ADD_Dlg


;;;<HOM>*************************************************************************
;;; <�֐���>    : BG_FG_ADD_InputDlg
;;; <�����T�v>  : BG/�O���� �����E�������̓_�C�A���O����
;;; <����>      : &syori : 1:�ޯ��ް�� 2:�O����
;;;             : &iHEIGH: SOLID�����o������
;;;             : &iTHIN : SOLID����
;;; <�߂�l>    : ���͒l���X�g or nil
;;; <�쐬>      : 11/09/30 A.Satoh
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun BG_FG_ADD_InputDlg (
  &syori   ; 1:�ޯ��ް�� 2:�O����
  &iHEIGH  ; SOLID�����o������
  &iTHIN   ; SOLID����
  /
  #dcl_id #list$
  )

;***************************************************************
  (defun ##GetItemData (
    /
    #err_flg #ret$ #iHEIGH_STR #iHEIGH #iTHIN_STR #iTHIN
    )

    (setq #err_flg nil)

    (setq #iHEIGH_STR (get_tile "height"))
    (setq #iTHIN_STR  (get_tile "width"))

    ; ���̓`�F�b�N
    (if (or (= #iHEIGH_STR "") (= #iHEIGH_STR nil))
      (progn
        (alert "���������͂���Ă��܂���")
        (mode_tile "height" 2)
        (setq #err_flg T)
      )
      (if (= (type (read #iHEIGH_STR)) 'INT)
        (progn
          (setq #iHEIGH (read #iHEIGH_STR))
          (if (<= #iHEIGH 0)
            (progn
              (alert "1�ȏ�̐����l����͂��ĉ�����")
              (mode_tile "height" 2)
              (setq #err_flg T)
            )
          )
        )
        (progn
          (alert "�����l����͂��ĉ�����")
          (mode_tile "height" 2)
          (setq #err_flg T)
        )
      )
    )

    (if (= #err_flg nil)
      (if (or (= #iTHIN_STR "") (= #iTHIN_STR nil))
        (progn
          (alert "���݂����͂���Ă��܂���")
          (mode_tile "width" 2)
          (setq #err_flg T)
        )
        (if (= (type (read #iTHIN_STR)) 'INT)
          (progn
            (setq #iTHIN (read #iTHIN_STR))
            (if (<= #iTHIN 0)
              (progn
                (alert "1�ȏ�̐����l����͂��ĉ�����")
                (mode_tile "width" 2)
                (setq #err_flg T)
              )
            )
          )
          (progn
            (alert "�����l����͂��ĉ�����")
            (mode_tile "width" 2)
            (setq #err_flg T)
          )
        )
      )
    )

    (if (= #err_flg nil)
      (progn
        (setq #ret$ (list #iHEIGH #iTHIN))
        (done_dialog)
      )
    )

    #ret$

  ) ; ##GetItemData
;***************************************************************

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
  (if (= nil (new_dialog "BG_FG_InputDlg" #dcl_id)) (exit))

  (if (= &syori 1)
    (set_tile "lab" "�ޯ��ް�� ����/���ݓ���")
    (set_tile "lab" "�O���� ����/���ݓ���")
  )
  (set_tile "height" (rtos &iHEIGH))
  (set_tile "width"  (rtos &iTHIN))

  (action_tile "accept" "(setq #list$ (##GetItemData))")
  (action_tile "cancel" "(setq #list$ nil)(done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)

  #list$

) ;BG_FG_ADD_InputDlg


;;;<HOM>*************************************************************************
;;; <�֐���>    : BG_FG_ADD_MakeBGinsertSUB
;;; <�����T�v>  : BG,FG�쐬���}����WT��UNION
;;; <����>      : &wtEn   : ���[�N�g�b�v�}�`��
;;;             : &syori  : �쐬�R�[�h 1:�ޯ��ް�� 2:�O����
;;;             : &iHIGH  : SOLID�����o������
;;;             : &iTHIN  : SOLID����
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 11/09/27 A.Satoh
;;; <���l>      : 
;;;*************************************************************************>MOH<
(defun BG_FG_ADD_MakeBGinsertSUB (
  &wtEn      ; ���[�N�g�b�v�}�`��
  &syori     ; �쐬�R�[�h 1:�ޯ��ް�� 2:�O����
  &iHIGH     ; SOLID�����o������
  &iTHIN     ; SOLID����
  /
  #xd_WRKT$ #height #wt_h #tei_pt$ #clayer #sCECOLOR
  #pt$$ #en$ #pt1$ #dST_PT #dEN_PT #pt_en
  #loop #ofP #ofP2 #ePL #midP #ePL2 #pt2$ 
  #bg_pt$ #bg_en #obj #eBG_SOLID #dINS_PT #dBpt #ss
  )

  ; ���[�N�g�b�v��ʐ}�`�_������߂�
  (setq #xd_WRKT$ (CFGetXData &wtEn "G_WRKT"))
  (setq #height (nth 8 #xd_WRKT$))
  (setq #wt_h (nth 10 #xd_WRKT$))
  (setq #tei_pt$ (GetPtSeries (nth 32 #xd_WRKT$) (GetLWPolyLinePt (nth 38 #xd_WRKT$))))
;-- 2011/11/21 A.Satoh Add - S
	(setq #tei_pt$ (append #tei_pt$ (list (nth 0 #tei_pt$))))
;-- 2011/11/21 A.Satoh Add - E

  ; ���݉�w���擾
  (setq #clayer (getvar "CLAYER"))

  ; ������w(�Ȃ���΍쐬)�����݉�w�ɂ��Ă���ȊO���ذ�� �F�ԍ�1-255,����
  (KPSetClayerOtherFreeze SKW_AUTO_SOLID 1 SKW_AUTO_LAY_LINE)

  ; �}�`�F�ԍ��̕ύX
  (setq #sCECOLOR (getvar "CECOLOR"))

  (if (CFGetXData &wtEn "G_WTSET")
    (setvar "CECOLOR" CG_WorkTopCol)
    (setvar "CECOLOR" "7")
  )

  (setvar "OSMODE" 1) ; �[�_

  ; �ޯ��ް��/�O����ǉ��ʒu�̎w��
  ; �i�_��w��j
  (setq #pt$$ (BG_FG_ADD_DrawPline #height &iTHIN))
  (setq #en$ (car #pt$$))
  (setq #pt1$ (cadr #pt$$))
  (setq #dST_PT (car #pt1$))
  (setq #dEN_PT (last #pt1$))

  (setvar "OSMODE"    0)

; �����p�b�菈��
  ; ���������͎����ŎZ�o����
  (command "vpoint" "0,0,1")
  (command "zoom" "0.8x")
  (setq #loop T)
  (while #loop
    (setq #ofP (getpoint "\n�ݒu��������������w�� :"))
    (if (= (JudgeNaigai #ofP #tei_pt$) nil)
      (CFAlertMsg "���[�N�g�b�v�̓������w�����ĉ������B")
      (progn
        (mapcar 'entdel #en$)
        (setq #loop nil)
      )
    )
  )

  (if (not (equal &iTHIN 0 0.01))
    (progn
      (setq #ePL (MakeLwPolyLine #pt1$ 0 #height))

      ; �I�t�Z�b�g�ʂ��}�C�i�X�l�̏ꍇ�A�I�t�Z�b�g�_���|�����C���̊O�ɏo��
      (if (> 0 &iTHIN)
        (progn
          (setq #midP (inters #ofP
            (pcpolar #ofP (+ (* 0.5 pi) (angle (car #pt1$)(cadr #pt1$))) 100)
            (car #pt1$)(cadr #pt1$) nil)
          )
          (setq #ofP2 (pcpolar #midP (angle #ofP #midP) (distance #ofP #midP)))
        )
        (setq #ofP2 (list (car #ofP)(cadr #ofP)))
      )

      (command "_offset" (abs &iTHIN) #ePL #ofP2 "")
      (setq #ePL2 (entlast))
      (setq #pt2$ (GetLWPolyLinePt #ePL2))
      (setq #pt2$ (reverse #pt2$))
      (entdel #ePL)
      (entdel #ePL2)
      (setq #pt1$ (append #pt1$ #pt2$))
    )
  )
  (command "zoom" "p")
  (command "zoom" "p")

  (setq #bg_pt$ nil)
  (foreach #pt #pt1$
    (setq #bg_pt$
      (append #bg_pt$ (list (list (car #pt) (cadr #pt) #height)))
    )
  )

  (setq #bg_en (MakeTEIMEN #bg_pt$)) ; �ޯ��ް�ޒ��

  (setq #obj (getvar "delobj"))
  (setvar "delobj" 1) ; 0 �I�u�W�F�N�g�͕ێ�����܂�

  ; BG_SOLID�쐬
;-- 2012/03/01 A.Satoh Mod - S
;;;;;  (command "_.extrude" #bg_en "" &iHIGH) ; ����PLINE��Z�����ɉ����o��
  (if (= (vl-cmdf "_.extrude" #bg_en "" &iHIGH) nil) ; ����PLINE��Z�����ɉ����o��
		(progn
			(vl-cmdf)
			(exit)
		)
	)
;-- 2012/03/01 A.Satoh Mod - E
  (setq #eBG_SOLID (entlast)) ; SOLID �}�`��

  ; SOLID �ړ�
  (setq #dINS_PT (car #bg_pt$))
  (setq #dBpt (list (nth 0 #dST_PT) (nth 1 #dST_PT) (+ #height #wt_h)))
  (command "._MOVE" #eBG_SOLID "" #dINS_PT #dBpt)

  ; WT��BG��UNION���Ƃ�
  (setq #ss (ssadd))
  (ssadd &wtEn #ss)
  (ssadd #eBG_SOLID #ss)
  (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I

  (setvar "delobj" #obj) ; 0 �A�C�e���͕ێ�����܂�

  ; �\����w�̐ݒ�(���ɖ߂�)
  (SetLayer)
  (setvar "CLAYER" #clayer) ; ���݉�w��߂�

  ; �V�X�e���ϐ������ɖ߂�
  (setvar "CECOLOR" #sCECOLOR)

);BG_FG_ADD_MakeBGinsertSUB

;<HOM>*************************************************************************
; <�֐���>    : BG_FG_ADD_DrawPline
; <�����T�v>  : �A�����������}�������̒[�_�̃��X�g���擾����
; <�߂�l>    : �쐬�����_�񃊃X�g
; <�쐬>      : 11/09/27 A.Satoh
; <���l>      :
;*************************************************************************>MOH<
(defun BG_FG_ADD_DrawPline (
  &height       ; �v�s���t������
  &defoD        ; �f�t�H���g�̃I�t�Z�b�g��(BG���ݖ���FG����)
  /
  #loop #p1 #pt$ #p2 #en$ #os #ret$
  )

  (setq #loop T)
  (setq #p1 (getpoint (strcat "\n�n�_: ")))
  (setq #pt$ (list #p1))
  (while (= T #loop)
    (if (/= nil #p1) ; C�Ȃ����[�h
      (progn
        (initget 128 "-a 1a 2a 3a 4a 5a 6a 7a 8a 9a U")
        (setq #p2 (getpoint #p1 (strcat "\n���_ /U=�߂�/: ")))
        (if (and (= 'STR (type #p2)) (numberp (read #p2)))
          (progn
            (initget "U")
            (setq #p2 (getpoint #p1 (strcat "\n���_ /U=�߂�/: ")))
          )
        )
      )
    )

    (cond
      ((= nil #p2)
        (setq #loop nil)
      )
      ((= "U" #p2)
        (setq #p1 (trans (cdr (assoc 10 (entget (car #en$)))) 0 1))
        (entdel (car #en$))
        (setq #en$ (cdr #en$))
        (setq #pt$ (cdr #pt$))
      )
      (T
        (setq #pt$ (cons #p2 #pt$))
        (setq #os (getvar "OSMODE"))
        (setvar "OSMODE" 0)
        (command "_line" #p1 #p2 "")
        (command "_change" (entlast) "" "P" "C" "1" "")
        (setvar "OSMODE" #os)
        (setq #p1 #p2)
        (setq #en$ (cons (entlast) #en$))
      )
    )
  )

  (setq #pt$ (reverse #pt$))

  (setq #ret$ nil)
  (foreach #pt #pt$
    (setq #ret$
      (append #ret$ (list (list (car #pt) (cadr #pt))))
    )
  )

  (list #en$ #ret$)

); BG_FG_ADD_DrawPline
;-- 2011/09/27 A.Satoh Add - E

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KP_MakeBGinsert
;;; <�����T�v>  : BG�쐬���}����WT��UNION
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/09/10 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KP_MakeBGinsert (
  /

  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KP_MakeBGinsert ////")
  (CFOutStateLog 1 1 " ")
  ;// �R�}���h�̏�����
  (StartUndoErr)
  ; BG����=50 BG����=20mm
  (KP_MakeBGinsertSUB 1 CG_BG_H CG_BG_T) ; BG��_����ʂ̍���

  (setq *error* nil)
  (princ)
);C:KP_MakeBGinsert

;;;<HOM>*************************************************************************
;;; <�֐���>    : C:KP_MakeFGinsert
;;; <�����T�v>  : FG�쐬���}����WT��UNION
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/09/10 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:KP_MakeFGinsert (
  /

  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:KP_MakeFGinsert ////")
  (CFOutStateLog 1 1 " ")
  ;// �R�}���h�̏�����
  (StartUndoErr)
  ; �O���ꍂ��-WT����=40-19=21 �O�������=20mm
  (KP_MakeBGinsertSUB 2 (- CG_FG_H CG_WT_T) CG_FG_T) ; FG��_����ʂ̍���

  (setq *error* nil)
  (princ)
);C:KP_MakeFGinsert

;;;<HOM>*************************************************************************
;;; <�֐���>    : KP_MakeBGinsertSUB
;;; <�����T�v>  : BG�쐬���}����WT��UNION
;;; <����>      : �Ȃ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 01/08/30 YM
;;; <���l>      : BG��������-->BG_SOLID�쐬-->հ�ް�}��-->WT��UNION
;;; <�C��>        FG�z�u����ނɂ��g�p,����ȗ���
;;;*************************************************************************>MOH<
(defun KP_MakeBGinsertSUB (
  &tflg  ; �}�����̊�_ 1:����(���), 2:����(���)
  &iHIGH ; SOLID�����o������
  &iTHIN ; SOLID����
  /
  #BG_EN #CLAYER #EBG_SOLID #GRIDMODE #ITYPE #LOOP #OBJ #ORTHOMODE #OSMODE #P1 #P2 #P3 #P4
  #RLEN #SCECOLOR #SNAPMODE #SS #SSWT #WTEN #XD$ #LPT #DEN_PT #DST_PT
#DINS_PT
  )

  (setq #SNAPMODE  (getvar "SNAPMODE"))
  (setq #GRIDMODE  (getvar "GRIDMODE"))
  (setq #ORTHOMODE (getvar "ORTHOMODE"))
  (setq #OSMODE    (getvar "OSMODE"))
  (setvar "SNAPMODE"  0)
  (setvar "GRIDMODE"  0)
  (setvar "ORTHOMODE" 0)
  (setvar "OSMODE"    0)

  (setq #ssWT (ssget "X" '((-3 ("G_WRKT")))))
  (if (or (= nil #ssWT)(= 0 (sslength #ssWT)))
    (progn
      (CFAlertMsg "\n�}�ʏ�Ƀ��[�N�g�b�v������܂���B")
      (quit)
    )
  );_if

  ;// ���[�N�g�b�v�̎w��
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #wtEn (car (entsel "\n���[�N�g�b�v��I��: ")))
    (if #wtEn
      (setq #xd$ (CFGetXData #wten "G_WRKT"))
      (setq #xd$ nil)
    );_if
    (if (= #xd$ nil)
      (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
      (setq #loop nil)
    );_if

  );while

  (setq #clayer (getvar "CLAYER")); ���݉�w
  ; ������w(�Ȃ���΍쐬)�����݉�w�ɂ��Ă���ȊO���ذ�� �F�ԍ�1-255,����
  (KPSetClayerOtherFreeze SKW_AUTO_SOLID 1 SKW_AUTO_LAY_LINE)

  ; �}�`�F�ԍ��̕ύX
  (setq #sCECOLOR (getvar "CECOLOR"))

  (if (CFGetXData #wtEn "G_WTSET")
    (setvar "CECOLOR" CG_WorkTopCol)
    (setvar "CECOLOR" "7")
  );_if

  (setvar "OSMODE"    1) ; �[�_

  ; 01/09/10 YM MOD-S
  (setq #dST_PT (getpoint "\n1�_��(���[)���w��: "))
  (setq #dEN_PT (getpoint "\n2�_��(�E�[)���w��: "))
  (setq #rLEN (distance #dST_PT #dEN_PT))
  ; ����(���)��_(�Œ�) --- BG
  ; ����(���)��_(�Œ�) --- �O����
  (setq #iType &tflg)
  ; 01/09/10 YM MOD-E

;;;01/09/06YM@MOD (setq #rLEN (getreal "\n�ޯ��ް�ނ̒��������: "))
;;;01/09/10YM@MOD ; 01/09/06 YM MOD-S
;;;01/09/10YM@MOD (setq #rLEN (getdist "\n�ޯ��ް�ނ̒�������͂܂���2�_�w��: "))
;;;01/09/10YM@MOD ; 01/09/06 YM MOD-E
;;;01/09/10YM@MOD
;;;01/09/10YM@MOD ; �ޯ��ް�ނ̊�_�����
;;;01/09/10YM@MOD (setq #loop T)
;;;01/09/10YM@MOD (while #loop
;;;01/09/10YM@MOD   (setq #iType (getint "\n�ޯ��ް�ނ̊�_ /1=����/2=�E��/3=�E��/4=����/ <����>:  "))
;;;01/09/10YM@MOD   (if (= #iType nil)
;;;01/09/10YM@MOD     (progn
;;;01/09/10YM@MOD       (setq #iType 1)
;;;01/09/10YM@MOD       (setq #loop nil)
;;;01/09/10YM@MOD     )
;;;01/09/10YM@MOD     (progn
;;;01/09/10YM@MOD       (if (or (= #iType 1)(= #iType 2)(= #iType 3)(= #iType 4))
;;;01/09/10YM@MOD         (setq #loop nil)
;;;01/09/10YM@MOD         (setq #loop T)
;;;01/09/10YM@MOD       );_if
;;;01/09/10YM@MOD     )
;;;01/09/10YM@MOD   ); if
;;;01/09/10YM@MOD )

  (setvar "OSMODE"    0) ; 01/9/10 YM ADD OSNAP ����

  (setq #p1 (list 0     0))
  (setq #p2 (list #rLEN 0))
  (setq #p3 (list #rLEN (- &iTHIN)))
  (setq #p4 (list 0     (- &iTHIN)))
  (setq #bg_en (MakeTEIMEN (list #p1 #p2 #p3 #p4))) ; �ޯ��ް�ޒ��

  (setq #obj (getvar "delobj"))
  (setvar "delobj" 1) ; 0 �I�u�W�F�N�g�͕ێ�����܂�
  ; BG_SOLID�쐬
  ;2008/07/28 YM MOD 2009�Ή�
  (command "_.extrude" #bg_en "" &iHIGH "") ; ����PLINE��Z�����ɉ����o��
;;;  (command "_.extrude" #bg_en "" &iHIGH "") ; ����PLINE��Z�����ɉ����o��
  (setq #eBG_SOLID (entlast)) ; SOLID �}�`��
  ; SOLID �ړ�

;;;01/09/10YM@MOD (princ "\n�}���_: ") ; 01/08/31 YM ADD

  ; 01/09/10 YM MOD-S
  (cond
    ((= #iType 1)(setq #dINS_PT #p1))
    ((= #iType 2)(setq #dINS_PT (list 0 0 &iHIGH)))
  );_cond
  (command "._MOVE" #eBG_SOLID "" #dINS_PT #dST_PT)
  ; 01/09/10 YM MOD-E

;;;01/09/10YM@MOD (cond
;;;01/09/10YM@MOD   ((= #iType 1)(command ".MOVE" #eBG_SOLID "" #p1 PAUSE))
;;;01/09/10YM@MOD   ((= #iType 2)(command ".MOVE" #eBG_SOLID "" #p2 PAUSE))
;;;01/09/10YM@MOD   ((= #iType 3)(command ".MOVE" #eBG_SOLID "" #p3 PAUSE))
;;;01/09/10YM@MOD   ((= #iType 4)(command ".MOVE" #eBG_SOLID "" #p4 PAUSE))
;;;01/09/10YM@MOD );_cond

;;;01/09/10YM@MOD (setq #lpt (getvar "LASTPOINT"))
;;;01/09/10YM@MOD (princ "\n�z�u�p�x: ") ; 01/08/31 YM ADD
;;;01/09/10YM@MOD (command ".ROTATE" #eBG_SOLID "" #lpt PAUSE)

  (command ".ROTATE" #eBG_SOLID "" #dST_PT #dEN_PT)

  ; 01/09/10 YM ADD-S �O����̏ꍇ�ABG����+WT���ݕ����ɉ�����
;;; (command ".MOVE" &ss "" "0,0,0" (list 0 0 (- (caddr #bpt) (caddr #lpt))))

  ; 01/09/10 YM ADD-E �O����̏ꍇ�ABG����+WT���ݕ����ɉ�����

  ; WT��BG��UNION���Ƃ�
  (setq #ss (ssadd))
  (ssadd #wtEn #ss)
  (ssadd #eBG_SOLID #ss)
  (command "_union" #ss "") ; �����Ȃ��̈�ł��n�j�I
  (setvar "delobj" #obj) ; 0 �A�C�e���͕ێ�����܂�

  ; �\����w�̐ݒ�(���ɖ߂�)
  (SetLayer)
  (setvar "CLAYER" #clayer) ; ���݉�w��߂�

  (setvar "SNAPMODE"  #SNAPMODE)
  (setvar "GRIDMODE"  #GRIDMODE)
  (setvar "ORTHOMODE" #ORTHOMODE)
  (setvar "OSMODE"    #OSMODE)

  ; �V�X�e���ϐ������ɖ߂�
  (setvar "CECOLOR" #sCECOLOR)

  (setq *error* nil)
  (princ)
);KP_MakeBGinsertSUB


;;;<HOM>*************************************************************************
;;; <�֐���>    : C:SetWkTop
;;; <�����T�v>  : ܰ�į�߂̕i�Ԃ��m�肷��
;;; <�߂�l>    :
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:SetWkTop (
  /
  #WT #LOOP #XD$ #WTL #WTLL #WTR #WTRR #XDWTL$ #XDWTR$
;-- 2011/08/26 A.Satoh Add - S
  #wk_xd$
;-- 2011/08/26 A.Satoh Add - E
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:SetWkTop ////")
  (CFOutStateLog 1 1 " ")
  ;// �R�}���h�̏�����
  (StartUndoErr)
  (CFCmdDefBegin 0); 01/07/02 YM ADD
  (CFNoSnapReset)

	;�t���[���L�b�`���@�ꕔ����ގg�p���~
	(FK_MSG)

; 01/06/28 YM ADD ����ނ̐��� Lipple
(if (equal (KPGetSinaType) 2 0.1)
  (progn
    (CFAlertMsg msg8)
    (quit)
  )
  (progn

;-- 2011/08/26 A.Satoh Mod - S
;  ;// ���[�N�g�b�v�̎w��
;  (initget 0)
;  (setq #loop T)
;  (while #loop
;    (setq #WT (car (entsel "\n���[�N�g�b�v��I��: ")))
;    (if #WT
;      (setq #xd$ (CFGetXData #WT "G_WRKT"))
;      (setq #xd$ nil)
;    );_if
;
;    (cond
;      ((= #xd$ nil)
;        (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
;      )
;;;;01/08/20YM@      ((CFGetXData #WT "G_WTSET")
;;;;01/08/20YM@        (CFAlertMsg "���[�N�g�b�v�͊��ɕi�Ԋm�肳��Ă��܂��B")
;;;;01/08/20YM@      )
;      (T
;        (setq #loop nil)
;      )
;    )
;  )
  ;// ���[�N�g�b�v�̎w��
  (initget 0)
  (setq #loop T)
  (while #loop
    (setq #WT (car (entsel "\n���[�N�g�b�v��I��: ")))
    (if #WT
      (setq #xd$ (CFGetXData #WT "G_WRKT"))
      (setq #xd$ nil)
    );_if

    (if (/= #xd$ nil)
      (progn
        (setq #wk_xd$ (CFGetXData #WT "G_WTSET"))
        (if (/= #wk_xd$ nil)
          (if (= (nth 0 #wk_xd$) 0)
            (progn  ; �����i�ł���ꍇ
              (PCW_ChColWT #WT "MAGENTA" nil)
              (setq #loop nil)
            )
            (progn  ; �K�i�i�ł���ꍇ
              (CFAlertMsg "�w�肵�����[�N�g�b�v�͋K�i�i�ł���A�i�Ԃ��m�肳��Ă��܂��B")
              (exit)
            )
          )
          (setq #loop nil)
        )
      )
      (progn
        (CFAlertMsg "���[�N�g�b�v�ł͂���܂���B")
      )
    )
  )
;-- 2011/08/26 A.Satoh Mod - E

;;; (command "vpoint" "0,0,1")

  ;// �i�Ԋm�菈�� �v���������ȊO
;-- 2011/09/01 A.Satoh Mod - S
;  (KPW_DesideWorkTop_FREE #WT)
  (setq #data$ (KPW_DesideWorkTop_FREE #WT))
;-- 2011/09/01 A.Satoh Mod - S

;;; ; �אڷ��ނ��i�Ԋm��
;;; (setq #WTL (nth 47 #xd$)) ; WTL
;;; (setq #WTR (nth 48 #xd$)) ; WTR
;;; (if (and #WTL (/= #WTL "")(= nil (CFGetXData #WTL "G_WTSET")))
;;;   (progn ; ���ɂ����
;;;     (setq #xdWTL$ (CFGetXData #WTL "G_WRKT"))
;;;     (KPW_DesideWorkTop3 2 #WTL)
;;;     (setq #WTLL (nth 47 #xdWTL$)) ; WTLL
;;;     (if (and #WTLL (/= #WTLL ""))(KPW_DesideWorkTop3 2 #WTLL))
;;;   )
;;; );_if
;;; (if (and #WTR (/= #WTR "")(= nil (CFGetXData #WTR "G_WTSET")))
;;;   (progn ; �E�ɂ����
;;;     (setq #xdWTR$ (CFGetXData #WTR "G_WRKT"))
;;;     (KPW_DesideWorkTop3 2 #WTR)
;;;     (setq #WTRR (nth 48 #xdWTR$)) ; WTRR
;;;     (if (and #WTRR (/= #WTRR ""))(KPW_DesideWorkTop3 2 #WTRR))
;;;   )
;;; );_if

;;; (command "zoom" "p")

;-- 2011/09/01 A.Satoh Mod - S
;  (princ "\n���[�N�g�b�v�̕i�Ԃ��m�肵�܂����B")
  (if (/= #data$ nil)
    (princ "\n���[�N�g�b�v�̕i�Ԃ��m�肵�܂����B")
  )
;-- 2011/09/01 A.Satoh Mod - E
  ); 01/06/28 YM ADD ����ނ̐��� Lipple
);_if

  (CFNoSnapFinish)
  (CFCmdDefFinish);00/09/26 SN ADD
  (setq *error* nil)
  (princ)

);C:SetWkTop


;;; <HOM>***********************************************************************************
;;; <�֐���>    : KPW_DesideWorkTop3
;;; <�����T�v>  : ���[�N�g�b�v�̕i�Ԋm��(woodone) �v���������p
;;; <�߂�l>    :
;;; <�쐬>      : 08/06/25 YM
;;; <���l>      : 
;;; ***********************************************************************************>MOH<
(defun KPW_DesideWorkTop3 (
  &eWTP ; �����̑Ώۃ��[�N�g�b�v�}�`��
  /
  #BG1 #BG2 #CHECK #DB_NAME #DIM$ #EGAS$ #EGAS_P5$ #ESNK$ #ESNK_P$ #ESNK_P1$ #ESNK_P4$$ #GAS$$
  #LIST$$ #PD #PDSIZE #QRY$ #QRY$$ #RET$ #SNK$$ #SNKCAB$ #WRKT$ #WTSET$ #WT_HABA #WT_HINBAN
  #WT_HINMEI #WT_OKUYUKI #WT_PRI #WT_TAKASA #ZAICODE #ZAIF
	#CG_TOKU_HINBAN ;2018/07/27 YM ADD
  )
  (setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "PDSIZE" 10)
  (setvar "pdmode" 34)
  (command "vpoint" "0,0,1")

  ; ���[�N�g�b�v�̊g���f�[�^��ϐ��Ɏ擾
  (setq #WRKT$ (CFGetXData &eWTP "G_WRKT"))
  (setq #ZaiCode (nth 2 #WRKT$))
  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ

  ; ���[�N�g�b�v�̈�ɂ���V���N�A�����A�K�X�R������S�Č������Ă���
  (setq #ret$ (PKW_GetWorkTopAreaSym3 &eWTP)); ���� = �����̑Ώۃ��[�N�g�b�v�}�`��
  (setq #SNK$$  (nth 0 #ret$))
  (setq #GAS$$  (nth 1 #ret$))
;;; �ϐ��֑��<�ݸ>
  (foreach #SNK$ #SNK$$
    (setq #eSNK$    (append #eSNK$    (list (nth 0 #SNK$)))) ; �ݸ�����ؽ�(nil)�܂�
    (setq #SNKCAB$  (append #SNKCAB$  (list (nth 1 #SNK$)))) ; �ݸ���޼����ؽ�
    (setq #eSNK_P4$$ (append #eSNK_P4$$ (list (nth 3 #SNK$)))) ; �ݸPMEN4�����ؽ�(nil)�܂�
  )

  (setq #eSNK$    (NilDel_List #eSNK$    ))
  (setq #SNKCAB$  (NilDel_List #SNKCAB$  ))
  (setq #eSNK_P1$ (NilDel_List #eSNK_P1$ ))
  (setq #eSNK_P4$$ (NilDel_List #eSNK_P4$$ ))

  ; �e�ݸ�̍ގ��ɉ������ݸ���̈��ؽĂ�Ԃ�(�ݸ�����Ή�)
  ;�ݸ���̈�̑������݂Ĕ��f
  (setq #eSNK_P$ (KPGetSinkANA #eSNK_P4$$ #ZaiF)) ; �e�ݸ����PMEN4ؽĂ�ؽ�

;;; �ϐ��֑��<���>
  (foreach #GAS$ #GAS$$
    (setq #eGAS$    (append #eGAS$    (list (nth 0 #GAS$)))) ; ���ؽ�(nil)�܂�
    (setq #eGAS_P5$ (append #eGAS_P5$ (list (nth 2 #GAS$)))) ; ���PMEN5�����ؽ�(nil)�܂�
  )
  (setq #eGAS$    (NilDel_List #eGAS$    ))
  (setq #eGAS_P5$ (NilDel_List #eGAS_P5$ ))

  ; ܰ�į�ߌ��������߂� &eWTP
  (if (= (nth 3 #WRKT$) 1) ; 1:L�^
    (setq #dim$ (PKGetANAdim-L2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; L�`��̏ꍇ
    (setq #dim$ (PKGetANAdim-I2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; I�`��̏ꍇ
  );_if

  ;;; ���[�N�g�b�v�̕i�Ԏ擾
  (setq #LIST$$
    (list
      (list "�ގ��L��"       (nth 16 CG_GLOBAL$) 'STR)
      (list "�`��"           (nth  5 CG_GLOBAL$) 'STR)
      (list "�V���N�L��"     (nth 17 CG_GLOBAL$) 'STR)
      (list "�V���N���Ԍ�"   (nth  4 CG_GLOBAL$) 'STR)
      (list "���s��"         (nth  7 CG_GLOBAL$) 'STR)
      (list "�V���N�ʒu"     (nth  2 CG_GLOBAL$) 'STR)
      (list "�R�����ʒu"     (nth  9 CG_GLOBAL$) 'STR)
      (list "LR�敪"         (nth 11 CG_GLOBAL$) 'STR)
    )
  )
  (setq #DB_NAME "�V���i")

  (setq #qry$$
    (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$)
  )

  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #qry$ (car #qry$$))
      (setq #WT_HINBAN  (nth 1 #qry$))   ; �i��
      (setq #WT_PRI     (nth 2 #qry$))   ; ���z
      (setq #WT_HABA    (nth 3 #qry$))   ; ��
      (setq #WT_TAKASA  (nth 4 #qry$))   ; ����
      (setq #WT_OKUYUKI (nth 5 #qry$))   ; ���s
      (setq #WT_HINMEI  (nth 6 #qry$))   ; �i��
    )
    (progn ;HIT���Ȃ��Ⴕ���͕���
      (setq #WT_HINBAN  "ERROR")   ; �i��
      (setq #WT_PRI           0)   ; ���z
      (setq #WT_HABA        "0")   ; ��
      (setq #WT_TAKASA      "0")   ; ����
      (setq #WT_OKUYUKI     "0")   ; ���s
      (setq #WT_HINMEI  "ERROR")   ; �i��
    )
  );_if


  ; �l�����ꂽ�t���O�A�i�ԁA���i�A�R�[�h�i���@�j���g���f�[�^�Ɋi�[
  (if (= (tblsearch "APPID" "G_WTSET") nil) (regapp "G_WTSET"))

  (setq #WTSET$
    (list
      1              ; G_WTSET �����t���O (0:����,1:�K�i)
      #WT_HINBAN     ; G_WTSET �i��
      (nth 8 #WRKT$) ; G_WTSET ��t������(��������WT�}�`��񂩂�Ƃ�)
      #WT_PRI        ; G_WTSET ���z(����)
      #WT_HINMEI     ; �i��
      #WT_HABA       ; ��
      #WT_TAKASA     ; ����
      #WT_OKUYUKI    ; ���s
      ""             ; �\��1
      ""             ; �\��2
      ""             ; �\��3
    )
  )

  ; �����@�ǉ�(��)
  (setq #WTSET$ (append #WTSET$ (list (length #dim$)))) ; WT����񐡖@�����
  (foreach #dim #dim$
    (setq #WTSET$ (append #WTSET$ (list #dim))) ; �����@
  )

  (CFSetXData &eWTP "G_WTSET" #WTSET$)
  ; ���[�N�g�b�v�̐F���m��F�ɕς���i�g���f�[�^���m�F�̏�j
  (if (CFGetXData &eWTP "G_WTSET")
    (progn
      (command "_.change" &eWTP "" "P" "C" CG_WorkTopCol "")
      ;;; BG,FG���ꏏ�ɐF�ւ�����
      (setq #BG1 (nth 49 #WRKT$))
      (setq #BG2 (nth 50 #WRKT$))
      (if (/= #BG1 "")
        (progn
          (if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
            (command "_.change" #BG1 "" "P" "C" CG_WorkTopCol "")
          )
        )
      );_if
      (if (/= #BG2 "")
        (progn
          (if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
            (command "_.change" #BG2 "" "P" "C" CG_WorkTopCol "")
          )
        )
      );_if
    )
    (progn
      (command "_.change" &eWTP "" "P" "C" "BYLAYER" "")
    )
  );_if

  ; ���e�\��(���ۂɌ����[�N�g�b�v�ɓ������l)
  ; 2006/09/15 T.Ari MOD �m�F��ʂ̐ݒ�l��V�ɐݒ肷��悤�ɕύX
  (if (< 1 &nFLG) 
    (progn
      (setq #CHECK (PKY_ShowWTSET_Dlog #WRKT$ (CFGetXData &eWTP "G_WTSET")))
      (setq #WTSET$ (CFModList (CFGetXData &eWTP "G_WTSET") (list (list 1 (nth 0 #CHECK)) (list 3 (nth 1 #CHECK)))))
      (CFSetXData &eWTP "G_WTSET" #WTSET$)
    )
  )
;-- 2011/10/29 A.Satoh Add - S
      (CFSetXData &eWTP "G_WRKT" (CFModList (CFGetXData &eWTP "G_WRKT") (list (list 35 (nth  2 CG_GLOBAL$)))))
;-- 2011/10/29 A.Satoh Add - E
  ;;; �ݸ�A��ہA�������������u
  (PKW_MakeHoleWorkTop2 &eWTP #eSNK_P$ #eGAS_P5$) ; #eSNK_P$ #eGAS_P5$ (nil)�L�蓾��

  (command "zoom" "p")
  (setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)
  (princ)
);KPW_DesideWorkTop3

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KPW_DesideWorkTop_FREE
;;; <�����T�v>  : ���[�N�g�b�v�̕i�Ԋm��(woodone) �v���������ȊO�p
;;; <�߂�l>    :
;;; <�쐬>      : 2010/01/07 YM ADD
;;; <���l>      : 
;;; ***********************************************************************************>MOH<
(defun KPW_DesideWorkTop_FREE (
  &eWTP ; �����̑Ώۃ��[�N�g�b�v�}�`��
  /
;-- 2011/09/14 A.Satoh Mod - S
;  #BG1 #BG2 #CHECK #DIM$ #EGAS$ #EGAS_P5$ #ESNK$ #ESNK_P$ #ESNK_P1$ #ESNK_P4$$
;  #GAS$$ #PD #PDSIZE #QRY$ #QRY$$ #RET$ #SNK$$ #SNKCAB$ #WRKT$ #WTSET$ #WT_HABA
;  #WT_HINBAN #WT_HINMEI #WT_OKUYUKI #WT_PRI #WT_TAKASA #ZAICODE #ZAIF
;;-- 2011/06/23 A.Satoh Add - S
;  #TYPE #WTLR #WTL #WTR #SINK #MAGUCHI #OKU #len$ #dep$ #SINK_ITI #HINBAN #TOKU_FLG
;;-- 2011/06/23 A.Satoh Add - E
;;-- 2011/08/26 A.Satoh Add - S
;  #syori_flg #tori_height #SetXd$ #WTSET2$
;  #toku_f
;  #baseP #tei #WTpt$ #GASpt$ #p1 #p2 #p3 #p4 #p5 #p6 #distGas
;;-- 2011/08/26 A.Satoh Add - E
  #PD #pdsize #WRKT$ #tori_height #syori_flg #WTSET2$ #hinban_dat$
  #ZaiCode #ZaiF #TYPE #WTLR #WTL #WTR #len$ #dep$ #keijo #ret$ #toku_f
  #SNK$ #SNK$$ #eSNK$ #SNKCAB$ #eSNK_P1$ #eSNK_P4$$ #eSNK_P$
  #GAS$ #GAS$$ #eGAS$ #eGAS_P5$ #baseP #tei #WTpt$ #GASpt$
  #p1 #p2 #p3 #p4 #p5 #p6 #distGas #SINK #sink$ #SINK_ITI
  #qry$$ #qry$ #MAGUCHI #OKU #LIST$$ #TOKU_FLG #WT_HINBAN #WT_PRI #WT_HABA
  #WT_TAKASA #WT_OKUYUKI #WT_HINMEI #SetXd$ #BG1 #BG2 #WTSET$ #dim #dim$
  #CutDirect #cut1 #cut2 #cut$$ #cut$

#GAS_ANA #GAS_PMEN5 #IH_NUM #LAYER #MSG #QRY_CUT$$ #QRY_SNK$$ #SQL #XDPMEN$ ;2014/12/04 YM ADD
;-- 2011/09/14 A.Satoh Mod - S
;-- 2011/09/30 A.Satoh Add - S
  #distSink
;-- 2011/09/30 A.Satoh Add - E
#wt_type$ #dan_f #dan_LR ;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή�
#eGASCAB$ ;2017/01/14
  )
  (setq #PD (getvar "pdmode"))
  (setq #pdsize (getvar "PDSIZE"))
  (setvar "PDSIZE" 10)
  (setvar "pdmode" 34)
  (command "vpoint" "0,0,1")

  ; ���[�N�g�b�v�̊g���f�[�^��ϐ��Ɏ擾
  (setq #WRKT$ (CFGetXData &eWTP "G_WRKT"))
;-- 2011/08/26 A.Satoh Add - S
  (setq #tori_height (nth 8 #WRKT$))
  (setq #syori_flg nil)
  (setq #WTSET2$ (CFGetXData &eWTP "G_WTSET"))
  (if (= #WTSET2$ nil)
    (setq #syori_flg T)
  )

  (if (= #syori_flg nil)
    (progn
      (setq #hinban_dat$
        (list
          (nth 0 #WTSET2$)         ; �����t���O
          (nth 1 #WTSET2$)         ; �i��
          (rtos (nth 3 #WTSET2$))  ; ���z
          (nth 5 #WTSET2$)         ; ��
          (nth 6 #WTSET2$)         ; ����
          (nth 7 #WTSET2$)         ; ���s
          (nth 4 #WTSET2$)         ; �i��
          (nth 8 #WTSET2$)         ; �����R�[�h
        )
      )
    )
    (progn
;-- 2011/08/26 A.Satoh Add - E
  (setq #ZaiCode (nth 2 #WRKT$))
  (princ "\n�������@�ގ�= ")(princ #ZaiCode)

  (setq #ZaiF (KCGetZaiF #ZaiCode)) ; �f��F 0:�l�H�嗝�� 1:���ڽ
;-- 2011/06/23 A.Satoh Add - S
  (setq #TYPE (nth  3 #WRKT$)) ; �`������
  (setq #WTLR (nth 30 #WRKT$)) ; ���E����
  (princ "\n�������@���E����= ")(princ #WTLR)
  (setq #WTL  (nth 47 #WRKT$)) ; WT�n���h����
  (setq #WTR  (nth 48 #WRKT$)) ; WT�n���h���E
  (setq #len$ (nth 55 #WRKT$)) ; WT�̕����X�g
  (setq #dep$ (nth 57 #WRKT$)) ; WT�̉��s���X�g
;-- 2011/09/19 A.Satoh Add - S
  (setq #CutDirect (nth  9 #WRKT$)) ; �J�b�g����
  (if (and (/= (nth 60 #WRKT$) nil) (/= (nth 60 #WRKT$) ""))
    (setq #cut1  (handent (nth 60 #WRKT$)))
    (setq #cut1 "")
  )
  (if (and (/= (nth 61 #WRKT$) nil) (/= (nth 61 #WRKT$) ""))
    (setq #cut2  (handent (nth 61 #WRKT$)))
    (setq #cut2 "")
  )
;-- 2011/09/19 A.Satoh Add - E

  ; �`����擾����
  (setq #keijo (WKP_GetWorkTop_KEIJO #TYPE #dep$ #len$))
  (princ "\n�������@�`��= ")(princ #keijo)
;-- 2011/06/23 A.Satoh Add - E

  ; ���[�N�g�b�v�̈�ɂ���V���N�A�����A�K�X�R������S�Č������Ă���
  (setq #ret$ (PKW_GetWorkTopAreaSym3 &eWTP)); ���� = �����̑Ώۃ��[�N�g�b�v�}�`��
  (setq #SNK$$  (nth 0 #ret$))
  (setq #GAS$$  (nth 1 #ret$)); ���Ԍ��R�����Ȃ��̂Ƃ�(nil , �޽���ސ}�` , nil)

;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - S
			(setq #toku_f nil)
;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - E
;-- 2011/08/29 A.Satoh Add - S
      (if (= (nth 58 #WRKT$) "TOKU")
        (progn
          (setq #toku_f T)
          (princ "\n�������@�V�Ɋ��ɓ����̖ڈ󂠂�")
        )
        (progn
          (setq #toku_f nil)
        )
      )

;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - S
			(setq #dan_f nil)
			(if (= #toku_f nil)
				(if (and (= #WTLR "Z") (= #TYPE 0) (= (length #SNK$$) 1) (= (length #GAS$$) 0))
					(progn
						(princ "\n�������@�i�����m�F�_�C�A���O�������s��")
						; �i�����m�F�_�C�A���O�������s��
						(setq #wt_type$ (KPW_CheckDanotiWorkTopDlg))
						(if (= #wt_type$ nil)
							(progn
								; �i�Ԋm�菈�����I������
								(exit)
							)
							(progn
								(setq #dan_f (nth 0 #wt_type$))
								(setq #dan_LR (nth 1 #wt_type$))
							)
						)
					)
				)
			)

			(if (= #dan_f nil)
				(progn
;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - E
      (if (= #toku_f nil)

;2012/05/25 YM MOD-S
				(cond
					((= (length #SNK$$) 0)
            (setq #toku_f T)
            (princ "\n�������@�ݸ�Ȃ�����")
				 	)
					((= (length #SNK$$) 1)
            (princ "\n�������@�ݸ1��")
				 	)
					(T
            (setq #toku_f T)
            (princ "\n�������@�ݸ��������")
				 	)
				);_cond

;;;        (if (/= (length #SNK$$) 1);(list #enSNK #enSNKCAB #snkPen1$ #snkPen4$)
;;;          (progn
;;;            (setq #toku_f T)
;;;            (princ "\n�������@�ݸ��������")
;;;          )
;;;          ;else
;;;          (if (= nil (nth 0 (car #SNK$$)))
;;;            (progn
;;;              (setq #toku_f T)
;;;              (princ "\n�������@�ݸ�Ȃ�����")
;;;            )
;;;          );_if
;;;        );_if
;2012/05/25 YM MOD-E

      );_if


      (if (= #toku_f nil)

;2012/05/25 YM MOD-S
				(cond
					((= (length #GAS$$) 0)
            (setq #toku_f T)
            (princ "\n�������@GAS�Ȃ�����")
				 	)
					((= (length #GAS$$) 1)
            (princ "\n�������@GAS1��") ;���Ԍ��ݸ�݂̂Ͷ޽���ނ�����̂�(nil �}�` nil) GAS1�� �Ɣ��f�����
				 	)
					(T
            (setq #toku_f T)
            (princ "\n�������@GAS��������")
				 	)
				);_cond

;;;        (if (/= (length #GAS$$) 1);(list #enGAS #enGASCAB #GasPen5)
;;;          (progn
;;;            (setq #toku_f T)
;;;            (princ "\n�������@GAS��������")
;;;          )
;;;          ;else
;;;          (progn
;;;            (if (= nil (nth 0 (car #GAS$$)))
;;;              (progn
;;;                (setq #toku_f T)
;;;                (princ "\n�������@GAS�Ȃ�����")
;;;              )
;;;            );_if
;;;          )
;;;        );_if
;2012/05/25 YM MOD-E

      );_if
;-- 2011/08/29 A.Satoh Add - E
;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - S
				)
			)
;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - E

;;; �ϐ��֑��<�ݸ>
  (foreach #SNK$ #SNK$$
    (setq #eSNK$     (append #eSNK$     (list (nth 0 #SNK$)))) ; �ݸ�����ؽ�(nil)�܂�
    (setq #SNKCAB$   (append #SNKCAB$   (list (nth 1 #SNK$)))) ; �ݸ���޼����ؽ�
    (setq #eSNK_P4$$ (append #eSNK_P4$$ (list (nth 3 #SNK$)))) ; �ݸPMEN4�����ؽ�(nil)�܂�
  )

  (setq #eSNK$     (NilDel_List #eSNK$    ))
  (setq #SNKCAB$   (NilDel_List #SNKCAB$  ))
  (setq #eSNK_P1$  (NilDel_List #eSNK_P1$ ))
  (setq #eSNK_P4$$ (NilDel_List #eSNK_P4$$ ))

  ; �e�ݸ�̍ގ��ɉ������ݸ���̈��ؽĂ�Ԃ�(�ݸ�����Ή�)
  ;�ݸ���̈�̑������݂Ĕ��f
  (setq #eSNK_P$ (KPGetSinkANA #eSNK_P4$$ #ZaiF)) ; �e�ݸ����PMEN4ؽĂ�ؽ�

;-- 2011/09/30 A.Satoh Add - S
  ; �V���N�e���@�����߂�
;  (if (/= nil (nth 0 (car #SNK$$)))
  (if (/= nil #eSNK_P$)
    (progn
;-- 2012/05/18 A.Satoh Mod �i�����V�i�Ԋm��Ή� - S
;;;;;      (setq #distSink (KPW_GetDispSink #WRKT$ (car #eSNK_P$)))
;;;;;      (if (/= #type 2)
;;;;;        (if (< #distSink 75.0)
;;;;;          (progn
;;;;;            (CFAlertMsg "�ݸ�e��75mm�ȏ㖳���ׁA�V�̐��삪�ł��܂���B")
;;;;;            (exit)
;;;;;          )
;;;;;        )
;;;;;				)
;;;;;      )
      (setq #distSink (KPW_GetDispSink #WRKT$ (car #eSNK_P$) #dan_f #dan_LR))
      (if (/= #type 2)
				(if (< #distSink 75.0)
					(if (not (equal (- 75.0 #distSink) 0 0.0001))
						(progn
							(CFAlertMsg "�ݸ�e��75mm�ȏ㖳���ׁA�V�̐��삪�ł��܂���B")
							(exit)
						)
					)
				)
      )
;-- 2012/05/18 A.Satoh Mod �i�����V�i�Ԋm��Ή� - E
    )
  )
;-- 2011/09/30 A.Satoh Add - E

;;; �ϐ��֑��<���>
	(setq #eGAS$    nil)
	(setq #eGASCAB$ nil) 
	(setq #eGAS_P5$ nil)

  (foreach #GAS$ #GAS$$
    (setq #eGAS$    (append #eGAS$    (list (nth 0 #GAS$)))) ; ���ؽ�(nil)�܂�
		;2017/01/13 YM ADD #eGASCAB$ �ǉ� ���Ԍ��Ͷ޽���ނ���
    (setq #eGASCAB$ (append #eGASCAB$ (list (nth 1 #GAS$)))) ; �޽����
    (setq #eGAS_P5$ (append #eGAS_P5$ (list (nth 2 #GAS$)))) ; ���PMEN5�����ؽ�(nil)�܂�
  )
  (setq #eGAS$    (NilDel_List #eGAS$    ))
  (setq #eGAS_P5$ (NilDel_List #eGAS_P5$ ))

  ; ܰ�į�ߌ��������߂� &eWTP
;-- 2011/09/01 A.Satoh Mod - S
;  (if (= (nth 3 #WRKT$) 1) ; 1:L�^
;    (setq #dim$ (PKGetANAdim-L2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; L�`��̏ꍇ
;    (setq #dim$ (PKGetANAdim-I2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; I�`��̏ꍇ
;  );_if
	(setq #dim$ nil)
	(if (and #eSNK_P$ #eGAS_P5$)
		(progn ;2014/11/29 YM ADD nil�΍�
			(princ "\n�������@�ݸ����A�޽����")

		  (cond
		    ((= (nth 3 #WRKT$) 1) ; 1:L�^
					(princ "\n�������@L�^�����@�v��")
		      (setq #dim$ (PKGetANAdim-L2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; L�`��̏ꍇ
		    )
		    ((= (nth 3 #WRKT$) 2) ; 2:U�^
					(princ "\n�������@U�^�����@�v��")
		      (setq #dim$ (PKGetANAdim-U2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; U�`��̏ꍇ
		    )
		    (T    ; ��L�ȊO(0:I�^)
					(princ "\n�������@I�^�����@�v��")
		      (setq #dim$ (PKGetANAdim-I2 &eWTP #WRKT$ #eSNK_P$ #eGAS_P5$)) ; I�`��̏ꍇ
		    )
		  );cond
		)
		(progn ;�V���N���R�������Ȃ�

			;2017/01/13 YM MOD-S  ���Ԍ��ݸ�݂̂Ƃ���ȊO�𕪊�
			(if (and #eGASCAB$ (= nil #eGAS_P5$) (= nil #eGAS$))
				(progn ;���Ԍ��ݸ�̂� I�^�z��
					(princ "\n�������@���Ԍ��ݸ�݂̂Œʂ�(�����@�v��)")
					(setq #dim$ (PKGetANAdim-I1 &eWTP #WRKT$ #eSNK_P$)) ; I�`��ݸ�݂̂̏ꍇ��z��
				)
				(progn ;����
					(setq #dim$ nil)
					(setq #toku_f T)
					(princ "\n�������@GAS or SINK�Ȃ�����")
				)
			);_if

		)
	);_if

			(princ "\n�������@�����@= ")(princ #dim$)

;-- 2011/09/01 A.Satoh Mod - E

;-- 2011/08/30 A.Satoh Add - S
      (if (= #toku_f nil)
        (progn
;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - S
					(if (= #dan_f nil)
						(progn
;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - E
          ;;; �R�����e���@�����߂�
		          (setq #baseP (nth 32 #WRKT$)) ; WT����_
		          (setq #tei (nth 38 #WRKT$))   ; WT��ʐ}�`�����
		          (setq #WTpt$ (GetLWPolyLinePt #tei))
		          (setq #WTpt$ (GetPtSeries #BaseP #WTpt$)) ; WT��ʍ��W�_������v�����
							(if #eGAS_P5$ ;2012/0810 YM ADD �޽�Ȃ��̂Ƃ�nil
		          	(setq #GASpt$ (GetLWPolyLinePt (car #eGAS_P5$))) ; ��ۊO�`�_��
								(setq #GASpt$ nil)
							);_if

		          (cond
		            ((= #TYPE 0)  ; I�^
		              (setq #p1 (nth 0 #WTpt$))
		              (setq #p2 (nth 1 #WTpt$))
		              (setq #p3 (nth 2 #WTpt$))
		              (setq #p4 (last  #WTpt$))

		              ; �R�����e���@�̎Z�o
		              (cond
		                ((= #WTLR "R") ; �E����̂Ƃ�
											(if #GASpt$ ;2012/0810 YM ADD �޽�Ȃ��̂Ƃ�nil
												(progn
				                  (setq #distGas (GetDistLineToPline (list #p1 #p4) #GASpt$))
				                  (princ "\n�������@���ۂ�GAS�e= ")(princ #distGas)
												)
												;else
												(progn
													(setq #distGas 0)(princ "\n�������@GAS�Ȃ�(GAS�e=0)")
												)
											);_if
		                )
		                ((= #WTLR "L") ; ������̂Ƃ�
											(if #GASpt$ ;2012/0810 YM ADD �޽�Ȃ��̂Ƃ�nil
												(progn
				                  (setq #distGas (GetDistLineToPline (list #p2 #p3) #GASpt$))
				                  (princ "\n�������@���ۂ�GAS�e= ")(princ #distGas)
												)
												;else
												(progn
													(setq #distGas 0)(princ "\n�������@GAS�Ȃ�(GAS�e=0)")
												)
											);_if
		                )
		                (T ; ����ȊO
											(if #GASpt$ ;2012/0810 YM ADD �޽�Ȃ��̂Ƃ�nil
												(progn
				                  (setq #distGas (GetDistLineToPline (list #p1 #p4) #GASpt$))
				                  (princ "\n�������@���ۂ�GAS�e= ")(princ #distGas)
												)
												;else
												(progn
													(setq #distGas 0)(princ "\n�������@GAS�Ȃ�(GAS�e=0)")
												)
											);_if
		                )
		              );_cond

              ; �R�����e���@��150mm�ȊO�ł���Γ���
              ;2011/09/15 YM MOD "/="���g����10��ϲŽ13��̌덷�Ō딻�肷��̂�equal �덷���e=0.001�ɏC��
;;; 2011/09/20YM              (if (equal #distGas 150.0 0.001)
;;; 2011/09/20YM                nil
;;; 2011/09/20YM                ;else
;;; 2011/09/20YM                (progn
;;; 2011/09/20YM                  (setq #toku_f T)
;;; 2011/09/20YM                  (princ "\n�������@GAS�e150�ȊO����")
;;; 2011/09/20YM                )
;;; 2011/09/20YM              );_if
            )
            ((= #TYPE 1)  ; L�^
              (setq #p1 (nth 0 #WTpt$))
              (setq #p2 (nth 1 #WTpt$))
              (setq #p3 (nth 2 #WTpt$))
              (setq #p4 (nth 3 #WTpt$))
              (setq #p5 (nth 4 #WTpt$))
              (setq #p6 (nth 5 #WTpt$))

              ; �R�����e���@�̎Z�o
              (cond
                ((= #WTLR "R") ; �E����̂Ƃ�
                  (setq #distGas (GetDistLineToPline (list #p5 #p6) #GASpt$))
                  (princ "\n�������@���ۂ�GAS�e= ")(princ #distGas)
                )
                ((= #WTLR "L") ; ������̂Ƃ�
                  (setq #distGas (GetDistLineToPline (list #p2 #p3) #GASpt$))
                  (princ "\n�������@���ۂ�GAS�e= ")(princ #distGas)
                )
                (T ; ����ȊO
                  (setq #distGas (GetDistLineToPline (list #p5 #p6) #GASpt$))
                  (princ "\n�������@���ۂ�GAS�e= ")(princ #distGas)
                )
              )

              ; �R�����e���@��150mm�ȊO�ł���Γ���
;;; 2011/09/20YM              (if (equal #distGas 150.0 0.001)
;;; 2011/09/20YM                (progn
;;; 2011/09/20YM                  (setq #toku_f T)
;;; 2011/09/20YM                  (princ "\n�������@GAS�e150�ȊO����")
;;; 2011/09/20YM                )
;;; 2011/09/20YM              )
            )
            (T            ; ���̑�(U�^)
              (setq #toku_f T)
              (princ "\n�������@U�^����")
            )
          )
;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - S
						)
            (setq #distGas nil)
					)
;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - E
        )
      )

			;2018/07/27 YM ADD-S
			(cond
				((= BU_CODE_0013 "1") ; PSKC�̏ꍇ
					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
				)
				((= BU_CODE_0013 "2") ; PSKD�̏ꍇ
					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKD)
				)
				(T ;����ȊO
					(setq #CG_TOKU_HINBAN CG_TOKU_HINBAN_PSKC)
				)
			);_if
			;2018/07/27 YM ADD-E


      (if (= #toku_f nil)
        (progn
;-- 2011/08/30 A.Satoh Add - E
;-- 2011/09/14 A.Satoh Mod - S
;-- 2011/06/29 A.Satoh Add - S
;  ; �V���N�L�������߂�
;  (setq #SINK (WKP_GetWorkTop_SINK_KIGO #eSNK$ #eGAS_P5$))
;  (if (= #SINK nil)
;    (setq #SINK "")
;  )
;
;  ; �V���N���Ԍ������߂�
;  (if #len$
;    (setq #MAGUCHI (strcat "W" (substr (itoa (fix (+ (car  #len$) 0.01))) 1 3)))
;    (setq #MAGUCHI "?")
;  )
;
;  ; ���s�������߂�
;  (if #dep$
;    (setq #OKU (strcat "D" (itoa (fix (+ (car #dep$) 0.01)))))
;    (setq #OKU "?")
;  )
;
;  ; �V���N�ʒu�����߂�
;  (setq #SINK_ITI (WKP_GetWorkTop_SINK_ITI #WRKT$ (car #eSNK_P$)))
;  (if (= #SINK_ITI nil)
;    (setq #SINK_ITI "")
;  )
;
;-- 2011/06/29 A.Satoh Add - E
;
;  ;;; ���[�N�g�b�v�̕i�Ԏ擾
;  (setq #QRY$$ nil)
          ; �V���N�L�������߂�
          (setq #SINK (WKP_GetWorkTop_SINK_KIGO #eSNK$ #eGAS_P5$))
          (if (= #SINK nil)
            (setq #SINK "?")
          )
          (princ "\n�������@�V���N�L��= ")(princ #SINK)

          ; �V���N���Ԍ������߂�
          (if #len$
            (progn
              (setq #qry$$
                (CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
                  (list
                    (list "�Ԍ�" (itoa (fix (+ (car  #len$) 0.01))) 'INT)
                  )
                )
              )
              (if (and #qry$$ (= 1 (length #qry$$)))
                (progn
                  (setq #qry$ (nth 0 #qry$$))
                  (setq #MAGUCHI (nth 1 #qry$))
                )
                (setq #MAGUCHI "?")
              )
            )
            (setq #MAGUCHI "?")
          )
          (princ "\n�������@�V���N���Ԍ�= ")(princ #MAGUCHI)

          ; ���s�������߂�
          (if #dep$
            (progn
              (setq #qry$$
                (CFGetDBSQLRec CG_DBSESSION "���s"
                  (list
                    (list "���s" (itoa (fix (+ (car  #dep$) 0.01))) 'INT)
                  )
                )
              )
              (if (and #qry$$ (= 1 (length #qry$$)))
                (progn
                  (setq #qry$ (nth 0 #qry$$))
                  (setq #OKU (nth 1 #qry$))
                )
                (setq #OKU "?")
              )
            )
            (setq #OKU "?")
          )
          (princ "\n�������@���s��= ")(princ #OKU)

          (setq #sink$ (list #MAGUCHI #keijo #OKU #SINK #distGas))

          ; �V���N�ʒu�����߂�
;-- 2011/09/30 A.Satoh Mod - S
;;;;;          (setq #SINK_ITI (WKP_GetWorkTop_SINK_ITI #WRKT$ (car #eSNK_P$) #sink$ #ZaiF))
;-- 2012/05/17 A.Satoh Mod �i�����V�i�Ԋm��Ή� - S
;;;;;          (setq #SINK_ITI (WKP_GetWorkTop_SINK_ITI #distSink #sink$ #ZaiF))
          (setq #SINK_ITI (WKP_GetWorkTop_SINK_ITI #distSink #sink$ #ZaiF #dan_f))
;-- 2012/05/17 A.Satoh Mod �i�����V�i�Ԋm��Ή� - E
;-- 2011/09/30 A.Satoh Mod - E
;-- 2011/09/14 A.Satoh Mod - E

;2011/09/16 YM ADD-S
          (setq #qry_SNK$$
            (CFGetDBSQLRec CG_DBSESSION "WT�V���N"
              (list
                (list "�V���N�L��" #SINK 'STR)
              )
            )
          )
					;2012/08/02 YM ADD-S �ݸ���Ȃ��ƕi�Ԋm��ł��Ȃ�
					(if #qry_SNK$$
	          ;�y�V���i�z�����p�̼ݸ�L���ɕϊ�����. "H_105"�Ȃǂł͌����ł��Ȃ�
	          (setq #SINK (nth 10 (car #qry_SNK$$)))
						;else
						(setq #SINK "?");�ݸ�Ȃ�(�s��)
					);_if
					;2012/08/02 YM ADD-E �ݸ���Ȃ��ƕi�Ԋm��ł��Ȃ�

;2011/09/16 YM ADD-E

;-- 2011/06/23 A.Satoh - S
;-- 2012/05/18 A.Satoh Mod �i�����V�i�Ԋm��Ή� - S
;;;;;  (setq #LIST$$
;;;;;    (list
;;;;;      (list "�ގ��L��"       #ZaiCode 'STR)
;;;;;      (list "�`��"           #keijo 'STR)
;;;;;      (list "�V���N�L��"     #SINK 'STR)
;;;;;      (list "�V���N���Ԍ�"   #MAGUCHI 'STR)
;;;;;      (list "���s��"         #OKU 'STR)
;;;;;      (list "�V���N�ʒu"     #SINK_ITI 'STR)
;;;;;      (list "�R�����ʒu"     "S" 'STR)
;;;;;      (list "LR�敪"         #WTLR 'STR)
;;;;;    )
;;;;;  )

	;2014/05/13 YM ADD-S
	(setq #GAS_ANA "S")
	(if #eGAS_P5$ ;�޽��ۂ���
		(progn
			(setq #GAS_PMEN5 (car #eGAS_P5$))
      (setq #xdPMEN$ (CFGetXData #GAS_PMEN5 "G_PMEN")) ; G_PMEN�g���ް�
      (if (and #xdPMEN$ (= 5 (car #xdPMEN$)))
				(progn
        	(setq #IH_NUM (nth 1 #xdPMEN$));�C�O��IH�͓V�¶޽���J�����قȂ�
					(if (= #IH_NUM 492)
						(setq #GAS_ANA "G")
						;else
						(setq #GAS_ANA "S")
					);_if
				)
      );_if
		)
		(progn
			(setq #GAS_ANA "S")
		)
	);_if
	;2014/05/13 YM ADD-E

	(if (= #dan_f T)
		(setq #LIST$$
			(list
				(list "�ގ��L��"       #ZaiCode 'STR)
				(list "�`��"           #keijo 'STR)
				(list "�V���N�L��"     #SINK 'STR)
				(list "�V���N���Ԍ�"   #MAGUCHI 'STR)
				(list "���s��"         #OKU 'STR)
				(list "�V���N�ʒu"     #SINK_ITI 'STR)
				(list "�R�����ʒu"     #GAS_ANA 'STR)
				(list "LR�敪"         #dan_LR 'STR)
			)
		)
		(setq #LIST$$
			(list
				(list "�ގ��L��"       #ZaiCode 'STR)
				(list "�`��"           #keijo 'STR)
				(list "�V���N�L��"     #SINK 'STR)
				(list "�V���N���Ԍ�"   #MAGUCHI 'STR)
				(list "���s��"         #OKU 'STR)
				(list "�V���N�ʒu"     #SINK_ITI 'STR)
				(list "�R�����ʒu"     #GAS_ANA 'STR)
				(list "LR�敪"         #WTLR 'STR)
			)
		)
	)
;-- 2012/05/18 A.Satoh Mod �i�����V�i�Ԋm��Ή� - E

  (setq #QRY$$
    (CFGetDBSQLRec CG_DBSESSION "�V���i" #LIST$$)
  )

	(princ "\n")
	(princ "\n�������@�y�V���i�z����KEY")
	(princ "\n---------------------------------------")
	(princ (strcat "\n�ގ��L��= "        #ZaiCode ))
	(princ (strcat  "\n�`��= "           #keijo   ))
	(princ (strcat  "\n�V���N�L��= "     #SINK    ))
	(princ (strcat  "\n�V���N���Ԍ�= "   #MAGUCHI ))
	(princ (strcat  "\n���s��= "         #OKU     ))
	(princ (strcat  "\n�V���N�ʒu= "     #SINK_ITI))
	(princ (strcat  "\n�R�����ʒu= "     #GAS_ANA ))
	(if #dan_f					
		(princ (strcat  "\nLR�敪= "       #dan_LR  ))
		;else
		(princ (strcat  "\nLR�敪= "       #WTLR    ))
	);_if
	(princ "\n---------------------------------------")
	(princ "\n")

	(princ "\n�������@�y�V���i�z��������=")(princ #QRY$$)
	

;-- 2011/06/23 A.Satoh - E
;���͎������Ȃ� 2010/01/07 YM
;;;     (setq #LIST$$
;;;       (list
;;;         (list "�ގ��L��"       (nth 16 CG_GLOBAL$) 'STR)
;;;         (list "�`��"           (nth  5 CG_GLOBAL$) 'STR)
;;;         (list "�V���N�L��"     (nth 17 CG_GLOBAL$) 'STR)
;;;         (list "�V���N���Ԍ�"   (nth  4 CG_GLOBAL$) 'STR)
;;;         (list "���s��"         (nth  7 CG_GLOBAL$) 'STR)
;;;         (list "�V���N�ʒu"     (nth  2 CG_GLOBAL$) 'STR)
;;;         (list "�R�����ʒu"     (nth  9 CG_GLOBAL$) 'STR)
;;;         (list "LR�敪"         (nth 11 CG_GLOBAL$) 'STR)
;;;       )
;;;     )
;;;     (setq #DB_NAME "�V���i")
;;;
;;;     (setq #qry$$
;;;       (CFGetDBSQLRec CG_DBSESSION #DB_NAME #LIST$$)
;;;     )

;-- 2011/07/04 A.Satoh Mod - S
; (if (and #QRY$$ (= 1 (length #QRY$$)))
;   (progn
;     (setq #QRY$ (car #QRY$$))
;     (setq #WT_HINBAN  (nth 1 #QRY$))   ; �i��
;     (setq #WT_PRI     (nth 2 #QRY$))   ; ���z
;     (setq #WT_HABA    (nth 3 #QRY$))   ; ��
;     (setq #WT_TAKASA  (nth 4 #QRY$))   ; ����
;     (setq #WT_OKUYUKI (nth 5 #QRY$))   ; ���s
;     (setq #WT_HINMEI  (nth 6 #QRY$))   ; �i��
;   )
;   (progn ;HIT���Ȃ��Ⴕ���͕���
;     (setq #WT_HINBAN  "ERROR")   ; �i��
;     (setq #WT_PRI           0)   ; ���z
;     (setq #WT_HABA        "0")   ; ��
;     (setq #WT_TAKASA      "0")   ; ����
;     (setq #WT_OKUYUKI     "0")   ; ���s
;     (setq #WT_HINMEI  "ERROR")   ; �i��
;   )
; );_if

  (if #QRY$$
    (progn
      (if (= 1 (length #QRY$$))
        (progn
;-- 2011/09/19 A.Satoh Add - S
          ; ��Đ������̊m�F�A�C��
          (if (and (= #TYPE 1) (/= #CutDirect ""))        ; L�^�ł���A�J�b�g���������݂���
            (progn


							;2014/12/04 YM ADD S ������đΉ�
							;�ގ����璼����Ă��ǂ������f
						  (setq #Qry_cut$$ 
						    (DBSqlAutoQuery CG_DBSESSION
									(setq #sql (strcat "select �J�b�g�^�C�v from WT�ގ� where �ގ��L��='"  #ZaiCode "'"))
						    )
						  )
							(if (and (= 1 (length #Qry_cut$$)) (= "S" (car (car #Qry_cut$$))) )
								(progn ;������Ă�����(WT�J�b�g���������s�v �ݸ��"S"����ɋK�i��)

									;(alert (strcat "��ĕ��� = " (nth 4 #cut$) "\n#CutDirect = " #CutDirect))
                  (if (/= #CutDirect "S");�ݸ���łȂ�������(�܂�"G"��������)�������J�b�g����ύX
                    (progn
											(CFAlertMsg "�����J�b�g�̕�����������(�R������)�ɂȂ��Ă��܂��B�V���N���ɕύX���܂��B")
                      ; ��Đ��P�̃��C�����m�F���A���̃��C�������ɶ�Đ��P�A��Đ��Q�̃��C�������ւ���
                      (setq #layer (cdr (assoc 8 (entget #cut1))))
                      (if (= #layer "WTCUT_HIDE")
                        (progn
                          (command "_.CHANGE" #cut1 "" "P" "LA" SKW_AUTO_SOLID "")
                          (command "_.CHANGE" #cut2 "" "P" "LA" "WTCUT_HIDE" "")
                        )
                        (progn
                          (command "_.CHANGE" #cut1 "" "P" "LA" "WTCUT_HIDE" "")
                          (command "_.CHANGE" #cut2 "" "P" "LA" SKW_AUTO_SOLID "")
                        )
                      );_if
                      (setq #CutDirect "S")
                      (setq #TOKU_FLG 1);�K�i
                    )
										(progn
											nil ;�V���N���������牽�����Ȃ�
										)
                  );_if

								)
								;else ������ĈȊO(�]��ۼޯ�)
								(progn

		              (setq #cut$$
		                (CFGetDBSQLRec CG_DBSESSION "WT�J�b�g����"
		                  (list
		                    (list "�V���N���Ԍ�" (substr #MAGUCHI 1 4)  'STR)
		                    (list "�`��"         #keijo    'STR)
		                    (list "�V���N�ʒu"   #SINK_ITI 'STR)
		                    (list "���s��"       #OKU      'STR)
		                  )
		                )
		              )
		              (if (and #cut$$ (= 1 (length #cut$$)))
		                (progn
		                  (setq #cut$ (nth 0 #cut$$))
											;(alert (strcat "��ĕ��� = " (nth 4 #cut$) "\n#CutDirect = " #CutDirect))
		                  (if (/= #CutDirect (nth 4 #cut$))
		                    (progn
		                      (if (CFYesNoDialog "J��Ă̕������������ɂȂ��Ă��܂��B�K�i���ɕύX���܂����H")
		                        (progn
		                          ; ��Đ��P�̃��C�����m�F���A���̃��C�������ɶ�Đ��P�A��Đ��Q�̃��C�������ւ���
		                          (setq #layer (cdr (assoc 8 (entget #cut1))))
		                          (if (= #layer "WTCUT_HIDE")
		                            (progn
		                              (command "_.CHANGE" #cut1 "" "P" "LA" SKW_AUTO_SOLID "")
		                              (command "_.CHANGE" #cut2 "" "P" "LA" "WTCUT_HIDE" "")
		                            )
		                            (progn
		                              (command "_.CHANGE" #cut1 "" "P" "LA" "WTCUT_HIDE" "")
		                              (command "_.CHANGE" #cut2 "" "P" "LA" SKW_AUTO_SOLID "")
		                            )
		                          );_if
		                          (setq #CutDirect (nth 4 #cut$))
		                          (setq #TOKU_FLG 1);�K�i
		                        )
														;else
		                        (setq #TOKU_FLG 0);����
		                      );_if CFYesNoDialog
		                    )
												;else
		                    (setq #TOKU_FLG 1);�K�i
		                  )
		                )
		                (progn
		                  (setq #msg (strcat "�wWT�J�b�g�����x��ں��ނ�����܂���B\n�����V�Ƃ��ēo�^���܂��B"))
		                  (setq #msg (strcat #msg "\n�V���N���Ԍ�=" #MAGUCHI " �`��=" #keijo " �V���N�ʒu=" #SINK_ITI " ���s��=" #OKU))
		                  (CFAlertMsg #msg)
		                  (setq #TOKU_FLG 0)
		                )
		              );_if

								);������ĈȊO(�]��ۼޯ�)
							);_if


            )
            (progn
              (setq #TOKU_FLG 1)
            )
          );_if  ; L�^�ł���A�����J�b�g�ł���


          (if (= #TOKU_FLG 0)
            (progn
              (setq #TOKU_FLG          0)   ; �����t���O
;;;              (setq #WT_HINBAN  "ZZ6500")   ; �i��
              (setq #WT_HINBAN  #CG_TOKU_HINBAN)   ; �i�� 2016/08/30 YM ADD (5)�V�Ȃ̂ŋ@��ȊO
              (setq #WT_PRI          "0")   ; ���z
              (setq #WT_HABA          "")   ; ��
              (setq #WT_TAKASA        "")   ; ����
              (setq #WT_OKUYUKI       "")   ; ���s
;;;              (setq #WT_HINMEI "ĸ���(ZZ6500)")   ; �i��
              (setq #WT_HINMEI CG_TOKU_HINMEI)   ; �i�� 2016/08/30 YM ADD
            )
            (progn
;-- 2011/09/19 A.Satoh Add - E
          (setq #QRY$ (car #QRY$$))
          (setq #TOKU_FLG    1)                   ; �����t���O
          (setq #WT_HINBAN  (nth 1 #QRY$))        ; �i��
          (setq #WT_PRI     (rtos (nth 2 #QRY$))) ; ���z
          (setq #WT_HABA    (nth 3 #QRY$))        ; ��
          (setq #WT_TAKASA  (nth 4 #QRY$))        ; ����
          (setq #WT_OKUYUKI (nth 5 #QRY$))        ; ���s
		          (setq #WT_HINMEI  (nth 6 #QRY$))        ; �i��
;-- 2011/09/19 A.Satoh Add - S
            )
          );_if

;-- 2011/09/19 A.Satoh Add - E
        )
        (progn
          (setq #TOKU_FLG          0)   ; �����t���O
;;;          (setq #WT_HINBAN  "ZZ6500")   ; �i��
          (setq #WT_HINBAN  #CG_TOKU_HINBAN)   ; �i�� 2016/08/30 YM ADD (5)�V�Ȃ̂ŋ@��ȊO
          (setq #WT_PRI          "0")   ; ���z
          (setq #WT_HABA          "")   ; ��
          (setq #WT_TAKASA        "")   ; ����
          (setq #WT_OKUYUKI       "")   ; ���s
;;;          (setq #WT_HINMEI "ĸ���(ZZ6500)")   ; �i��
          (setq #WT_HINMEI CG_TOKU_HINMEI)   ; �i�� 2016/08/30 YM ADD
        )
      )
    )
    (progn
      (setq #TOKU_FLG          0)   ; �����t���O
;;;      (setq #WT_HINBAN  "ZZ6500")   ; �i��
      (setq #WT_HINBAN  #CG_TOKU_HINBAN)   ; �i�� 2016/08/30 YM ADD (5)�V�Ȃ̂ŋ@��ȊO
      (setq #WT_PRI          "0")   ; ���z
      (setq #WT_HABA          "")   ; ��
      (setq #WT_TAKASA        "")   ; ����
      (setq #WT_OKUYUKI       "")   ; ���s
;;;      (setq #WT_HINMEI "ĸ���(ZZ6500)")   ; �i��
			(setq #WT_HINMEI CG_TOKU_HINMEI)   ; �i�� 2016/08/30 YM ADD
    )
  )
;-- 2011/07/04 A.Satoh Mod - E
;-- 2011/08/29 A.Satoh Add - S
    )
    (progn
      (setq #TOKU_FLG          0)   ; �����t���O
;;;      (setq #WT_HINBAN  "ZZ6500")   ; �i��
      (setq #WT_HINBAN  #CG_TOKU_HINBAN)   ; �i�� 2016/08/30 YM ADD (5)�V�Ȃ̂ŋ@��ȊO
      (setq #WT_PRI          "0")   ; ���z
      (setq #WT_HABA          "")   ; ��
      (setq #WT_TAKASA        "")   ; ����
      (setq #WT_OKUYUKI       "")   ; ���s
;;;      (setq #WT_HINMEI "ĸ���(ZZ6500)")   ; �i��
      (setq #WT_HINMEI CG_TOKU_HINMEI)   ; �i�� 2016/08/30 YM ADD
    )
  )
;-- 2011/08/29 A.Satoh Add - E

;-- 2011/08/26 A.Satoh Add - S
      (setq #hinban_dat$
        (list
          #TOKU_FLG     ; �����t���O
          #WT_HINBAN    ; �i��
          #WT_PRI       ; ���z
          #WT_HABA      ; ��
          #WT_TAKASA    ; ����
          #WT_OKUYUKI   ; ���s
          #WT_HINMEI    ; �i��
          ""            ; �����R�[�h
        )
      )
    )
  )

  ; �V�i���m��_�C�A���O����
;-- 2011/12/12 A.Satoh Mod - S
;;;;;  (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$))
  (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$ #TYPE))
;-- 2011/12/12 A.Satoh Mod - E
  (if (/= #hinban_dat$ nil)
    (progn
;-- 2011/08/26 A.Satoh Add - E

  ; �l�����ꂽ�t���O�A�i�ԁA���i�A�R�[�h�i���@�j���g���f�[�^�Ɋi�[
  (if (= (tblsearch "APPID" "G_WTSET") nil) (regapp "G_WTSET"))

;-- 2011/08/26 A.Satoh Mod - S
;  (setq #WTSET$
;    (list
;;-- 2011/07/04 A.Satoh Mod - S
;;     1              ; G_WTSET �����t���O (0:����,1:�K�i)
;      #TOKU_FLG      ; G_WTSET �����t���O (0:����,1:�K�i)
;;-- 2011/07/04 A.Satoh Mod - E
;      #WT_HINBAN     ; G_WTSET �i��
;      (nth 8 #WRKT$) ; G_WTSET ��t������(��������WT�}�`��񂩂�Ƃ�)
;      #WT_PRI        ; G_WTSET ���z(����)
;      #WT_HINMEI     ; �i��
;      #WT_HABA       ; ��
;      #WT_TAKASA     ; ����
;      #WT_OKUYUKI    ; ���s
;      ""             ; �\��1
;      ""             ; �\��2
;      ""             ; �\��3
;    )
;  )
;
;  ; �����@�ǉ�(��)
;  (setq #WTSET$ (append #WTSET$ (list (length #dim$)))) ; WT����񐡖@�����
;  (foreach #dim #dim$
;    (setq #WTSET$ (append #WTSET$ (list #dim))) ; �����@
;  )
;  (CFSetXData &eWTP "G_WTSET" #WTSET$)
      (if (= #syori_flg nil)
        (CFSetXData &eWTP "G_WTSET" (CFModList #WTSET2$
            (list
              (list 1 (nth 1 #hinban_dat$))
              (list 3 (nth 2 #hinban_dat$))
              (list 4 (nth 6 #hinban_dat$))
              (list 5 (nth 3 #hinban_dat$))
              (list 6 (nth 4 #hinban_dat$))
              (list 7 (nth 5 #hinban_dat$))
              (list 8 (nth 7 #hinban_dat$))
							(if (= (nth 9 #WTSET2$) "")
								(list 9 (nth 1 #hinban_dat$))
								(list 9 (nth 9 #WTSET2$))
							)
            ))
        )
        (progn
          (setq #WTSET$
            (list
              (nth 0 #hinban_dat$)
              (nth 1 #hinban_dat$)
              #tori_height   ; G_WTSET ��t������(��������WT�}�`��񂩂�Ƃ�)
              (nth 2 #hinban_dat$)
              (nth 6 #hinban_dat$)
              (nth 3 #hinban_dat$)
              (nth 4 #hinban_dat$)
              (nth 5 #hinban_dat$)
              (nth 7 #hinban_dat$)
							(nth 1 #hinban_dat$)
;              ""             ; �\��2
              ""             ; �\��3
            )
          )

          ; �����@�ǉ�(��)
          (setq #WTSET$ (append #WTSET$ (list (length #dim$)))) ; WT����񐡖@�����
          (foreach #dim #dim$
            (setq #WTSET$ (append #WTSET$ (list #dim))) ; �����@
          )

          (CFSetXData &eWTP "G_WTSET" #WTSET$)
        )
      )

      (setq #SetXd$ (CFGetXData &eWTP "G_WRKT"))
;-- 2011/09/19 A.Satoh Add - S
;;;;;      (if (= (nth 0 #hinban_dat$) 0)
;;;;;        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 58 "TOKU"))))
;;;;;        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 58 ""))))
;;;;;      )
;-- 2011/10/28 A.Satoh Mod - S
;;;;;      (if (= (nth 0 #hinban_dat$) 0)
;;;;;        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 9 #CutDirect) (list 58 "TOKU"))))
;;;;;        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 9 #CutDirect) (list 58 ""))))
;;;;;      )
      (if (= (nth 0 #hinban_dat$) 0)
        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 9 #CutDirect) (list 35 "")        (list 58 "TOKU"))))
        (CFSetXData &eWTP "G_WRKT" (CFModList #SetXd$ (list (list 9 #CutDirect) (list 35 #SINK_ITI) (list 58 ""))))
      )
;-- 2011/10/28 A.Satoh Mod - S
;-- 2011/09/19 A.Satoh Add - S

;-- 2011/08/31 A.Satoh Add - S
      ; �ݸ�A��ہA�������������u
      (PKW_MakeHoleWorkTop2 &eWTP #eSNK_P$ #eGAS_P5$) ; #eSNK_P$ #eGAS_P5$ (nil)�L�蓾��
;-- 2011/08/31 A.Satoh Add - E
    )
  )
;-- 2011/08/26 A.Satoh Mod - E

  ; ���[�N�g�b�v�̐F���m��F�ɕς���i�g���f�[�^���m�F�̏�j
  (if (CFGetXData &eWTP "G_WTSET")
    (progn
      (command "_.change" &eWTP "" "P" "C" CG_WorkTopCol "")
      ;;; BG,FG���ꏏ�ɐF�ւ�����
      (setq #BG1 (nth 49 #WRKT$))
      (setq #BG2 (nth 50 #WRKT$))
      (if (/= #BG1 "")
        (progn
          (if (= "3DSOLID" (cdr (assoc 0 (entget #BG1))))
            (command "_.change" #BG1 "" "P" "C" CG_WorkTopCol "")
          )
        )
      );_if
      (if (/= #BG2 "")
        (progn
          (if (= "3DSOLID" (cdr (assoc 0 (entget #BG2))))
            (command "_.change" #BG2 "" "P" "C" CG_WorkTopCol "")
          )
        )
      );_if
    )
    (progn
      (command "_.change" &eWTP "" "P" "C" "BYLAYER" "")
    )
  );_if

;-- 2011/08/26 A.Satoh Del - S
;  ; ���e�\��(���ۂɌ����[�N�g�b�v�ɓ������l)
;  ; 2006/09/15 T.Ari MOD �m�F��ʂ̐ݒ�l��V�ɐݒ肷��悤�ɕύX
;  (setq #CHECK (PKY_ShowWTSET_Dlog #WRKT$ (CFGetXData &eWTP "G_WTSET")))
;  (setq #WTSET$ (CFModList (CFGetXData &eWTP "G_WTSET") (list (list 1 (nth 0 #CHECK)) (list 3 (nth 1 #CHECK)))))
;  (CFSetXData &eWTP "G_WTSET" #WTSET$)
;-- 2011/08/26 A.Satoh Del - E

;-- 2011/08/31 A.Satoh Del - S
;  ;;; �ݸ�A��ہA�������������u
;  (PKW_MakeHoleWorkTop2 &eWTP #eSNK_P$ #eGAS_P5$) ; #eSNK_P$ #eGAS_P5$ (nil)�L�蓾��
;-- 2011/08/31 A.Satoh Del - E

  (command "zoom" "p")
  (setvar "pdmode" #PD)
  (setvar "PDSIZE" #pdsize)
;-- 2011/09/01 A.Satoh Mod - S
;  (princ)
  #hinban_dat$
;-- 2011/09/01 A.Satoh Mod - S
);KPW_DesideWorkTop_FREE

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KP_GetSinkKIGO
;;; <�����T�v>  : Xdata"G_SINK"�̼ݸ�L������WT�i�ԗp�̼ݸ�L�����擾����
;;; <�߂�l>    : WT�i�ԗp�̼ݸ�L��
;;; <�쐬>      : NAS�p 02/09/13
;;; <���l>      : �������s-->"?"
;;; ***********************************************************************************>MOH<
(defun KP_GetSinkKIGO (
  &Sink_KIGO  ; �ݸ�L��
  /
  #NAME$ #RET
  )
  (setq #name$ ; �P��������
    (CFGetDBSQLRec CG_DBSESSION "WT�V���N"
      (list (list "�V���N�L��" &Sink_KIGO 'STR))
    )
  )
  (if (and #name$ (= 1 (length #name$)))
;-- 2011/08/29 A.Satoh Mod - S
;    (setq #ret (nth 17 (car #name$)))
    (setq #ret (nth 1 (car #name$)))
;-- 2011/08/29 A.Satoh Mod - S
    (setq #ret "?")
  );_if
  #ret
);KP_GetSinkKIGO

;;; <HOM>***********************************************************************************
;;; <�֐���>    : PKGetANAdim-L2
;;; <�����T�v>  : ���[�N�g�b�v���������߂�(L�^��p)�ݸ,��ە����Ή�
;;; <�߂�l>    : WT������̐��@����
;;; <�쐬>      : 00/09/25 YM �W����
;;; <���l>      : �̈�_��ؽĂ͕��Ă���(�n�_=�I�_)���Ƃ��K�v
;;;               ssget "CP"���g������ vpoint (0,0,1)�` zoom "P" ���K�v
;;; ***********************************************************************************>MOH<
(defun PKGetANAdim-L2 (
  &eWT      ; WT�}�`��
  &WRKT$    ; G_WRKT
  &eSNK_P$  ; SNK-PMEN(����ؽ�)
  &eGAS_P$  ; GAS-PMEN(����ؽ�)
  /
  #ANA$ #BASEP #DIM$ #DIM1$ #DIM2$ #HABA1$ #HABA2$ #LEN1 #LEN2 #LIS1$$ #LIS2$$
  #MAX #MIN #P1 #P2 #P3 #P4 #P5 #P6 #PT$ #PTANA$ #PTANA1$$ #PTANA2$$
  #REG1$ #REG2$ #RET$ #TEI #X1 #X2
  )
  (setq #ANA$ (append &eSNK_P$ &eGAS_P$)) ; PMEN����ِ}�`
;;; nil������
  (setq #ANA$ (NilDel_List #ANA$))

;;; p1+----------+--LEN2-------------+p2
;;;   |          x1                  |
;;;   |          |     �̈�2         |
;;;   |          p4                  |
;;;   +x2------- +-------------------+p3
;;;   |          |
;;;   |          |
;;;   |  �̈�1   |
;;;LEN1          |
;;;   |          |
;;;   |  +----+  |
;;;   |  | S  |  |
;;;   |  +----+  |
;;;   |          |
;;;   |          |
;;; p6+----------+p5

  (setq #tei   (nth 38 &WRKT$))      ; WT��ʐ}�`�����
  (setq #BaseP (nth 32 &WRKT$))      ; WT����_
  (setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��
;;; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
  (setq #pt$ (GetPtSeries #BaseP #pt$))
  (setq #p1 (nth 0 #pt$))
  (setq #p2 (nth 1 #pt$))
  (setq #p3 (nth 2 #pt$))
  (setq #p4 (nth 3 #pt$))
  (setq #p5 (nth 4 #pt$))
  (setq #p6 (nth 5 #pt$))
  (setq #x1 (CFGetDropPt #p4 (list #p1 #p2)))
  (setq #x2 (CFGetDropPt #p4 (list #p1 #p6)))
  (setq #LEN1 (distance #p1 #p6))
  (setq #LEN2 (distance #p1 #p2))

  (command "_layer" "T" "Z_01*" "") ; PMEN��w�ذ�މ���

  (setq #reg1$ (list #p1 #x1 #p5 #p6 #p1)) ; �̈�1
  (setq #reg2$ (list #p1 #p2 #p3 #x2 #p1)) ; �̈�2

  (setq #lis1$$ '())
  (setq #lis2$$ '())
  (if #ANA$ ; PMEN����
    (progn
      (foreach #ANA #ANA$
        (setq #ptANA$ (GetLWPolyLinePt #ANA)) ; PMEN�O�`�_��
        (if (IsEntInPolygon #ANA #reg1$ "CP") ; �̈�1��PMEN�����݂����
          (progn
            (setq #ptANA1$$ (append #ptANA1$$ (list #ptANA$)))
            (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p5 #p6)))
            (setq #min (car  #ret$)) ; �����ŏ�
            (setq #max (cadr #ret$)) ; �����ő�
            (setq #lis1$$ (append #lis1$$ (list (list #min) (list #max))))
          )
        );_if
        (if (IsEntInPolygon #ANA #reg2$ "CP") ; �̈�2��PMEN�����݂����
          (progn
            (setq #ptANA2$$ (append #ptANA2$$ (list #ptANA$)))
            (setq #ret$ (GetMinMaxLineToPT$ #ptANA$ (list #p1 #p6)))
            (setq #min (car  #ret$))
            (setq #max (cadr #ret$))
            (setq #lis2$$ (append #lis2$$ (list (list #min) (list #max))))
          )
        );_if
      )
    )
  );_if

;;; �̈�1�����@��������߂�(�[���猊�܂ł̋���)
  (setq #dim1$
    (PKGetDimSeries2
      #lis1$$  ; (�����ŏ�,�����ő�)��ؽ�
      #LEN1    ; �S��
    )
  )
;;; �̈�2�����@��������߂�(�[���猊�܂ł̋���)
  (setq #dim2$
    (PKGetDimSeries2
      #lis2$$  ; (�����ŏ�,�����ő�)��ؽ�
      #LEN2    ; �S��
    )
  )

  (setq #dim$ (append #dim1$ #dim2$))
  (command "_layer" "F" "Z_01*" "") ; PMEN��w�ذ��
  (setq #dim$ (append #dim$ (list #LEN1 #LEN2)))
  #dim$
);PKGetANAdim-L2

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KPGetSK4
;;; <�����T�v>  : WT�i�ԍ���4�����߂�
;;; <�߂�l>    : ������ؽ�
;;; <�쐬>      : 01/07/10 YM
;;; <���l>      : NAS�p
;;; ***********************************************************************************>MOH<
(defun KPGetSK4 (
  &len$     ; WT���ۂ̕�(�i�������͊܂܂Ȃ�)
  &ZaiF     ; �f��F 0:�l��,1:���ڽ
  &WT_type  ; I,L
  &FD       ; "F" or "D"�i��
  &PLINE    ; �i���������܂߂�WT�O�`���ײ�
  &BaseP    ; WT����_
  /
  #NMAG1 #NMAG2 #SK4 #SMAG1 #SMAG2 #SSMAG1 #SSMAG2 #DIST1 #DIST2 #WTPT$
  )
  (setq #nMAG1 (fix (+ (car  &len$) 0.1))) ; 'INT 2550
  (setq #nMAG2 (fix (+ (cadr &len$) 0.1)))

  (if (and (equal &ZaiF 1 0.1)(= &WT_type "L")(= &FD "D"))
    (progn ; ���ڽL�^�̂Ƃ��i�������܂ފO�`����S�̊Ԍ������߂�
      ; �W��WT�����WT�O�`�_�񂪕K�v
      (setq #WTpt$ (GetLWPolyLinePt &PLINE)) ; �O�`�_��
      ; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
      (setq #WTpt$ (GetPtSeries &BaseP #WTpt$))
      ; 02/04/17 YM ADD-S �G���[��� #WTpt$=nil��
      (if #WTpt$
        (progn
          (setq #dist1 (+ (distance (nth 0 #WTpt$)(nth 1 #WTpt$)) 0.001))
          (setq #dist2 (+ (distance (nth 0 #WTpt$)(nth 5 #WTpt$)) 0.001))
          (if (<= #dist1 #dist2)
            (setq #nMAG2 (fix (+ #dist1 0.001))) ; 'INT 2550
            (setq #nMAG2 (fix (+ #dist2 0.001))) ; 'INT 2550
          );_if
        )
        (progn ; ���ڽL�^�i���΂߶��,������ĂȂǂ̂Ƃ�
          (setq #nMAG2 0)
        )
      );_if

    )
  );_if

  ; 01/12/07 YM ADD-S ���ڽI�^�ޮ�į�ߑΉ�
  (if (and (equal &ZaiF 1 0.1)(= &WT_type "I")(= &FD "D"))
    (progn ; ���ڽI�^�̂Ƃ��i�������܂ފO�`����S�̊Ԍ������߂�
      ; �W��WT�����WT�O�`�_�񂪕K�v
      (setq #WTpt$ (GetLWPolyLinePt &PLINE)) ; �O�`�_��
      (setq #dist1 (+ (distance (nth 0 #WTpt$)(nth 1 #WTpt$)) 0.001))
      (setq #dist2 (+ (distance (nth 1 #WTpt$)(nth 2 #WTpt$)) 0.001))
      (if (<= #dist1 #dist2)
        (setq #nMAG1 (fix (+ #dist2 0.001))) ; 'INT 2550
        (setq #nMAG1 (fix (+ #dist1 0.001))) ; 'INT 2550
      );_if
    )
  );_if
  ; 01/12/07 YM ADD-E ���ڽI�^�ޮ�į�ߑΉ�

  (setq #sMAG1 (itoa #nMAG1)) ; 'STR "2550"

  (setq #sMAG2 (itoa #nMAG2))
  (setq #ssMAG1 (substr #sMAG1 1 (1- (strlen #sMAG1)))) ; "2550"==>"255"
  (setq #ssMAG2 (substr #sMAG2 1 (1- (strlen #sMAG2))))

  (if (and (equal &ZaiF 1 0.1)(= &WT_type "L"))
    (progn ; ���ڽL�^
      (setq #sk4 (strcat (substr #ssMAG1 1 2)(substr #ssMAG2 2 1))) ; 255�~165==>256
    )
    (progn ; ����ȊO(I�`��I,L,U�^)
      (setq #sk4 #ssMAG1)
      (if (= (strlen #sk4) 2)
        (setq #sk4 (strcat "0" #sk4))
      );_if
    )
  );_if
  #sk4
);KPGetSK4

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KPGetSK5
;;; <�����T�v>  : WT�i�ԍ���4�����߂�
;;; <�߂�l>    : ������ؽ�
;;; <�쐬>      : 03/10/14 YM
;;; <���l>      : NAS �ި��۱�p
;;; ***********************************************************************************>MOH<
(defun KPGetSK5 (
  &Fullflat ; ���ׯ��׸�
  &len$     ; WT���ۂ̕�(�i�������͊܂܂Ȃ�)
  &ZaiF     ; �f��F 0:�l��,1:���ڽ
  &WT_type  ; I,L
  &FD       ; "F" or "D"�i��
  &PLINE    ; �i���������܂߂�WT�O�`���ײ�
  &BaseP    ; WT����_
  /
  #NMAG1 #NMAG2 #SK4 #SMAG1 #SMAG2 #SSMAG1 #SSMAG2 #DIST1 #DIST2 #WTPT$
  )
  (setq #nMAG1 (fix (+ (car  &len$) 0.1))) ; 'INT 2550
  (setq #nMAG2 (fix (+ (cadr &len$) 0.1)))
  ;���ׯĂ�23mm����
  ;04/04/0 YM MOD ���ׯĂ�21mm����
  (if &Fullflat
    (setq #nMAG1 (- #nMAG1 23));04/06/14 YM MOD
;;;   (setq #nMAG1 (- #nMAG1 21));04/04/09 YM MOD
  );_if

  (if (and (equal &ZaiF 1 0.1)(= &WT_type "L")(= &FD "D"))
    (progn ; ���ڽL�^�̂Ƃ��i�������܂ފO�`����S�̊Ԍ������߂�
      ; �W��WT�����WT�O�`�_�񂪕K�v
      (setq #WTpt$ (GetLWPolyLinePt &PLINE)) ; �O�`�_��
      ; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
      (setq #WTpt$ (GetPtSeries &BaseP #WTpt$))
      ; 02/04/17 YM ADD-S �G���[��� #WTpt$=nil��
      (if #WTpt$
        (progn
          (setq #dist1 (+ (distance (nth 0 #WTpt$)(nth 1 #WTpt$)) 0.001))
          (setq #dist2 (+ (distance (nth 0 #WTpt$)(nth 5 #WTpt$)) 0.001))
          (if (<= #dist1 #dist2)
            (setq #nMAG2 (fix (+ #dist1 0.001))) ; 'INT 2550
            (setq #nMAG2 (fix (+ #dist2 0.001))) ; 'INT 2550
          );_if
        )
        (progn ; ���ڽL�^�i���΂߶��,������ĂȂǂ̂Ƃ�
          (setq #nMAG2 0)
        )
      );_if

    )
  );_if

  ; 01/12/07 YM ADD-S ���ڽI�^�ޮ�į�ߑΉ�
  (if (and (equal &ZaiF 1 0.1)(= &WT_type "I")(= &FD "D"))
    (progn ; ���ڽI�^�̂Ƃ��i�������܂ފO�`����S�̊Ԍ������߂�
      ; �W��WT�����WT�O�`�_�񂪕K�v
      (setq #WTpt$ (GetLWPolyLinePt &PLINE)) ; �O�`�_��
      (setq #dist1 (+ (distance (nth 0 #WTpt$)(nth 1 #WTpt$)) 0.001))
      (setq #dist2 (+ (distance (nth 1 #WTpt$)(nth 2 #WTpt$)) 0.001))
      (if (<= #dist1 #dist2)
        (setq #nMAG1 (fix (+ #dist2 0.001))) ; 'INT 2550
        (setq #nMAG1 (fix (+ #dist1 0.001))) ; 'INT 2550
      );_if
    )
  );_if
  ; 01/12/07 YM ADD-E ���ڽI�^�ޮ�į�ߑΉ�

  (setq #sMAG1 (itoa #nMAG1)) ; 'STR "2550"

  (setq #sMAG2 (itoa #nMAG2))
  (setq #ssMAG1 (substr #sMAG1 1 (1- (strlen #sMAG1)))) ; "2550"==>"255"
  (setq #ssMAG2 (substr #sMAG2 1 (1- (strlen #sMAG2))))

  (if (and (equal &ZaiF 1 0.1)(= &WT_type "L"))
    (progn ; ���ڽL�^
      (setq #sk4 (strcat (substr #ssMAG1 1 2)(substr #ssMAG2 2 1))) ; 255�~165==>256
    )
    (progn ; ����ȊO(I�`��I,L,U�^)
      (setq #sk4 #ssMAG1)
      (if (= (strlen #sk4) 2)
        (setq #sk4 (strcat "0" #sk4))
      );_if
    )
  );_if
  #sk4
);KPGetSK5

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KPGetSK5_eyefull
;;; <�����T�v>  : WT�i�ԍ���4�����߂�
;;; <�߂�l>    : ������ؽ�
;;; <�쐬>      : 03/11/28 YM
;;; <���l>      : NAS ����ΰїp
;;; ***********************************************************************************>MOH<
(defun KPGetSK5_eyefull (
  &Fullflat ; ���ׯ��׸�
  &len$     ; WT���ۂ̕�(�i�������͊܂܂Ȃ�)
  &ZaiF     ; �f��F 0:�l��,1:���ڽ
  &WT_type  ; I,L
  &FD       ; "F" or "D"�i��
  &PLINE    ; �i���������܂߂�WT�O�`���ײ�
  &BaseP    ; WT����_
  /
  #NMAG1 #NMAG2 #SK4 #SMAG1 #SSMAG1
  )
  (setq #nMAG1 (fix (+ (car  &len$) 0.1))) ; 'INT 2550
  (setq #nMAG2 (fix (+ (cadr &len$) 0.1)))
  ;���ׯĂ�23mm����
  (if &Fullflat
    (progn
      (cond
        ((equal #nMAG1 2440.0 0.001)
          (setq #nMAG1 2411)
        )
        ((equal #nMAG1 2590.0 0.001)
          (setq #nMAG1 2511)
        )
      );_cond
      (setq #sMAG1 (itoa #nMAG1)) ; 'STR "2550"
      (setq #sk4 #sMAG1)
    )
    (progn
      (setq #sMAG1 (itoa #nMAG1)) ; 'STR "2550"
      (setq #ssMAG1 (substr #sMAG1 1 (1- (strlen #sMAG1)))) ; "2550"==>"255"
      (setq #sk4 #ssMAG1)
      (if (= (strlen #sk4) 2)
        (setq #sk4 (strcat "0" #sk4))
      );_if
    )
  );_if

  #sk4
);KPGetSK5_eyefull


;;;<HOM>*************************************************************************
;;; <�֐���>    : PKResetWTSETdim$
;;; <�����T�v>  : WTSET�̌����@�����ăZ�b�g �i��10,11���ړ���ւ�
;;; <�߂�l>    : �Ȃ�
;;; <�쐬��>    : 00/06/02 YM
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun PKResetWTSETdim$ (
  &wt      ; WT�}�`��
  &xdWT    ; �V�v�s"G_WRKT"
  &xdWTSET ; �X�V�O"G_WTSET"
  &zai     ; WT�ގ�
  /
  #CUTL #CUTR #CUTTYPE #DIM$ #DLOG$ #EGAS$ #EGAS_P5$ #ESNK$ #ESNK_P$ #ESNK_P1$ #ESNK_P4$$
  #GAS$$ #HOLE #I #NWT_FLG #NWT_PRI #RET$ #SETXD$ #SNK$$ #SNKCAB$ #SWT_ID #WTSET$
  #WT_HINBAN #XD-SNK$ #ZAIF
#DF_BIKOU #DF_HINMEI #BIKOU #DUM1 #DUM2 #HINMEI #XDWRKT$ ; 03/01/28 YM ADD
;-- 2011/09/19 A.Satoh Add - S
  #hinban_dat$
;-- 2011/09/19 A.Satoh Add - E
  )
  (setq #CutType (nth 7 &xdWT)) ; �������
  (setq #cutL (substr #CutType 1 1))
  (setq #cutR (substr #CutType 2 1))

;;; ���ڽ�Ȃ�PMEN1 ����ȊO��PMEN4==>�d�l�ύX01/03/27 YM ���ڽ�Ȃ�PMEN4����1 �l���PMEN4����0
  (setq #ZaiF (KCGetZaiF &zai)) ; �f��F 0:�l�H�嗝�� 1:���ڽ

  ;;; ���@����
  (setq #ret$ (PKW_GetWorkTopAreaSym3 &wt)); ����=�����̑Ώۃ��[�N�g�b�v�}�`��
  (setq #SNK$$ (nth 0 #ret$))
  (setq #GAS$$ (nth 1 #ret$))
;;; �ϐ��֑��<�ݸ>
  (foreach #SNK$ #SNK$$
    (setq #eSNK$    (append #eSNK$    (list (nth 0 #SNK$)))) ; �ݸ�����ؽ�(nil)�܂�
    (setq #SNKCAB$  (append #SNKCAB$  (list (nth 1 #SNK$)))) ; �ݸ���޼����ؽ�
    (setq #eSNK_P1$ (append #eSNK_P1$ (list (nth 2 #SNK$)))) ; �ݸPMEN1�����ؽ�(nil)�܂�
    (setq #eSNK_P4$$ (append #eSNK_P4$$ (list (nth 3 #SNK$)))) ; �ݸPMEN4�����ؽ�(nil)�܂�
  )
  (setq #eSNK$    (NilDel_List #eSNK$    ))
  (setq #SNKCAB$  (NilDel_List #SNKCAB$  ))
  (setq #eSNK_P1$ (NilDel_List #eSNK_P1$ ))
  (setq #eSNK_P4$$ (NilDel_List #eSNK_P4$$ ))

  ; �e�ݸ�̍ގ��ɉ������ݸ���̈��ؽĂ�Ԃ�(�ݸ�����Ή�)
  ;01/03/27 YM MOD �ݸ���̈�̑������݂Ĕ��f STRAT
  (setq #eSNK_P$ (KPGetSinkANA #eSNK_P4$$ #ZaiF)) ; �e�ݸ����PMEN4ؽĂ�ؽ�
  ;01/03/27 YM MOD �ݸ���̈�̑������݂Ĕ��f END

;;;01/03/27YM@  (cond ; 00/09/26 YM
;;;01/03/27YM@    ((equal #ZaiF 1 0.1)
;;;01/03/27YM@      (setq #eSNK_P$ #eSNK_P1$) ; ���ڽ
;;;01/03/27YM@    )
;;;01/03/27YM@    ((equal #ZaiF 0 0.1)
;;;01/03/27YM@      (setq #eSNK_P$ #eSNK_P4$) ; �l�H�嗝��
;;;01/03/27YM@    )
;;;01/03/27YM@    (T
;;;01/03/27YM@      (CFAlertMsg "\n�wWT�ގ��x��\"�f��F\"���s���ł��B")(quit)
;;;01/03/27YM@    )
;;;01/03/27YM@  );_cond

;;; �ϐ��֑��<���>
  (foreach #GAS$ #GAS$$
    (setq #eGAS$    (append #eGAS$    (list (nth 0 #GAS$)))) ; ���ؽ�(nil)�܂�
    (setq #eGAS_P5$ (append #eGAS_P5$ (list (nth 2 #GAS$)))) ; ���PMEN5�����ؽ�(nil)�܂�
  )
  (setq #eGAS$    (NilDel_List #eGAS$    ))
  (setq #eGAS_P5$ (NilDel_List #eGAS_P5$ ))

;;; ; ܰ�į�ߌ��������߂� &wt
;;; (if (and (= #ZaiF 1)(= (nth 3 &xdWT) 1))
;;;   (setq #dim$ (PKGetANAdim-L2 &wt &xdWT #eSNK_P$ #eGAS_P5$)) ; L�`��̏ꍇ(���ڽL�^)
;;;   (setq #dim$ (PKGetANAdim-I2 &wt &xdWT #eSNK_P$ #eGAS_P5$)) ; I�`��̏ꍇ
;;; );_if

  ; ܰ�į�ߌ��������߂�
  (if (and (= #ZaiF 1)(= (nth 3 &xdWT) 1)(= #cutL "0")(= #cutR "0")) ; 01/02/13 YM �C��
    (setq #dim$ (PKGetANAdim-L2 &wt &xdWT #eSNK_P$ #eGAS_P5$)) ; L�`��̏ꍇ(���ڽL�^��ĂȂ�)
    (setq #dim$ (PKGetANAdim-I2 &wt &xdWT #eSNK_P$ #eGAS_P5$)) ; I�`��̏ꍇ
  );_if

;;;   ((= (nth 3 #WRKT$) 2) ; U�`��̏ꍇ
;;;     (setq #dim$ (PKGetANAdim-U2 &wt &xdWT #eSNK_P$ #eGAS_P5$))
;;;   )

;;; ���i��հ�ް������
  (cond
    ((= "L" (nth 30 &xdWT)) ; ������ɂȂ���
      (setq #WT_HINBAN (vl-string-subst "TL" "TR" (nth 1 &xdWTSET)))
      (setq #WT_HINBAN (vl-string-subst "T-L" "T-R" (nth 1 &xdWTSET)))
    )
    ((= "R" (nth 30 &xdWT)) ; �E����ɂȂ���
      (setq #WT_HINBAN (vl-string-subst "TR" "TL" (nth 1 &xdWTSET)))
      (setq #WT_HINBAN (vl-string-subst "T-R" "T-L" (nth 1 &xdWTSET)))
    )
    (T
      (setq #WT_HINBAN (nth 1 &xdWTSET))
    )
  );_cond

  ; 03/01/27 YM ADD-S
  ; [46]�i��������ΗD�悵�ĕ\������
  (setq #DF_HINMEI (KPGetWTHinmei &zai)); WT�ގ�����WT�i�������߂�
  (setq #dum1 (nth 45 &xdWT))
  (if (and #dum1 (/= "" #dum1))
    (setq #DF_HINMEI #dum1)
  );_if

  (setq #dum2 (nth 46 &xdWT)) ; ���l
  (if (and #dum2 (/= "" #dum2))
    (setq #DF_BIKOU #dum2)
  ; else
    (setq #DF_BIKOU "")
  );_if
  ; 03/01/27 YM ADD-E

;-- 2011/09/19 A.Satoh Mod - S
  ; �V��񃊃X�g���쐬����
  (setq #hinban_dat$
    (list
      (nth 0 &xdWTSET)  ; �����t���O(����) 0:���� 1:�K�i
      #WT_HINBAN        ; �i��(������)
      (rtos (nth 3 &xdWTSET)) ; ���z(������)
      (nth 5 &xdWTSET)  ; ��(������)
      (nth 6 &xdWTSET)  ; ����(������)
      (nth 7 &xdWTSET)  ; ���s(������)
      (nth 4 &xdWTSET)  ; �i��(������)
      (nth 8 &xdWTSET)  ; �����R�[�h(������)
    )
  )

;-- 2011/12/12 A.Satoh Add - S
;;;;;  (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$))
  (setq #hinban_dat$ (KPW_SetWorkTopInfoDlg #hinban_dat$ (nth 3 &xdWT)))
;-- 2011/12/12 A.Satoh Add - E
  (if (/= #hinban_dat$ nil)
    (progn
      (if (= (tblsearch "APPID" "G_WTSET") nil) (regapp "G_WTSET"))
      (setq #WTSET$
        (list
          (nth 0 #hinban_dat$)
          (nth 1 #hinban_dat$)
          (nth 8 &xdWT)   ; G_WTSET ��t������(��������WT�}�`��񂩂�Ƃ�)
          (nth 2 #hinban_dat$)
          (nth 6 #hinban_dat$)
          (nth 3 #hinban_dat$)
          (nth 4 #hinban_dat$)
          (nth 5 #hinban_dat$)
          (nth 7 #hinban_dat$)
					(nth 1 #hinban_dat$)
;         	""             ; �\��2
          ""             ; �\��3
        )
      )
      (setq #WTSET$ (append #WTSET$ (list (length #dim$)))) ; WT����񐡖@�����
      (foreach #dim #dim$
        (setq #WTSET$ (append #WTSET$ (list #dim))) ; �����@
      )
      (CFSetXData &wt "G_WTSET" #WTSET$)
    )
;-- 2011/10/07 A.Satoh Add - S
    (exit)
;-- 2011/10/07 A.Satoh Add - E
  )

;;;;;  (setq #DLOG$
;;;;;;;;01/04/12YM@    (KPW_GetWorkTopInfoDlg &xdWT
;;;;;    (KPW_GetWorkTopInfoDlg_ChSeri &xdWT ; ���i�������ݕt�� 01/04/12 YM MOD
;;;;;      #WT_HINBAN (fix (+ (nth 3 &xdWTSET) 0.001))
;;;;;      #DF_HINMEI #DF_BIKOU ; 03/01/27 YM ADD
;;;;;    )
;;;;;  ) ; Xdata,���O,���i
;;;;;  (if (= 'LIST (type #DLOG$))
;;;;;    (progn
;;;;;;-- 2011/08/31 A.Satoh Mod - S
;;;;;;      (setq #nWT_FLG 1)                     ; �����׸ސ��� 0:���� @@@@@@@@@@@@@���߂��� 09/22 YM
;;;;;      (setq #nWT_FLG (nth 0 &xdWTSET))
;;;;;;-- 2011/08/31 A.Satoh Mod - E
;;;;;      (setq #sWT_ID (car #DLOG$))           ; �i�ԕ�����
;;;;;
;;;;;      ; �S�p��߰��𔼊p��߰��ɒu�������� 01/06/27 YM ADD
;;;;;      (setq #sWT_ID (vl-string-subst "  " "�@" #sWT_ID)) ; հ�ް���͕i��
;;;;;
;;;;;      (setq #nWT_PRI (float (cadr #DLOG$))) ; ���i���ʎ���
;;;;;    ); end of progn
;;;;;    ; ؽĂ����Ȃ������ꍇ�A��ݾق��ꂽ�Ɣ��f�Bquit
;;;;;    (quit)
;;;;;  ); end of if
;;;;;
;;;;;  ;03/01/27 YM ADD-S �i���A���l��Xdata�ɕێ�����
;;;;;  (setq #HINMEI (nth 2 #DLOG$)) ; �i��
;;;;;  (if (= nil #HINMEI)(setq #HINMEI ""))
;;;;;  (setq #BIKOU  (nth 3 #DLOG$)) ; ���l
;;;;;  (if (= nil #BIKOU)(setq #BIKOU ""))
;;;;;  ;03/01/27 YM ADD-E
;;;;;
;;;;;  ; �l�����ꂽ�t���O�A�i�ԁA���i�A�R�[�h�i���@�j���g���f�[�^�Ɋi�[
;;;;;  (if (= (tblsearch "APPID" "G_WTSET") nil) (regapp "G_WTSET"))
;;;;;  (setq #WTSET$
;;;;;    (list
;;;;;      #nWT_FLG       ; G_WTSET �����t���O
;;;;;      #sWT_ID        ; G_WTSET �i�ԕ�����
;;;;;      (nth 8 &xdWT)  ; G_WTSET ��t������(��������WT�}�`��񂩂�Ƃ�)
;;;;;      #nWT_PRI       ; G_WTSET ���i����
;;;;;      (nth 4 &xdWTSET) ; �i���� 01/03/26 YM MOD
;;;;;;-- 2011/06/22 A.Satoh Add - S
;;;;;      (nth 5 &xdWTSET)  ; G_WTSET ��
;;;;;      (nth 6 &xdWTSET)  ; G_WTSET ����
;;;;;      (nth 7 &xdWTSET)  ; G_WTSET ���s
;;;;;      (nth 8 &xdWTSET)  ; G_WTSET �\���P
;;;;;      (nth 9 &xdWTSET)  ; G_WTSET �\���Q
;;;;;      (nth 10 &xdWTSET) ; G_WTSET �\���R
;;;;;;-- 2011/06/22 A.Satoh Add - E
;;;;;    )
;;;;;  )
;;;;;  ; �����@�ǉ�
;;;;;  (setq #WTSET$ (append #WTSET$ (list (length #dim$)))) ; WT����񐡖@�����
;;;;;  (foreach #dim #dim$
;;;;;    (setq #WTSET$ (append #WTSET$ (list #dim))) ; �����@
;;;;;  )
;;;;;  (CFSetXData &wt "G_WTSET" #WTSET$)
;;;;;  ;;; 01/01/22 YM ADD
;;;;;  ;;; �ݸ����"G_WRKT"�ɾ�Ă���
;;;;;  (if #eSNK$
;;;;;    (progn
;;;;;      (setq #i 0)
;;;;;      (setq #SetXd$ nil)
;;;;;      (repeat (length #eSNK$)
;;;;;        (setq #xd-snk$ (CFGetXData (nth #i #eSNK$) "G_SINK"))
;;;;;        (setq #HOLE (nth 3 #xd-snk$)) ; �ݸ���}�`��
;;;;;        (if (and #HOLE (/= #HOLE "")) ; "G_WRKT"�ɾ��
;;;;;          (setq #SetXd$ (append #SetXd$ (list (list (+ #i 19) #HOLE))))
;;;;;        );_if
;;;;;        (setq #i (1+ #i))
;;;;;      );repeat
;;;;;      (setq #SetXd$ (cons (list 18 (length #eSNK$)) #SetXd$))
;;;;;
;;;;;      (CFSetXData &wt "G_WRKT"
;;;;;        (CFModList &xdWT #SetXd$)
;;;;;      )
;;;;;    )
;;;;;  );_if
;;;;;
;;;;;  ; 03/01/28 YM ADD-S
;;;;;  (setq #xdWRKT$ (CFGetXData &wt "G_WRKT"))
;;;;;  (CFSetXData &wt "G_WRKT"
;;;;;    (CFModList #xdWRKT$
;;;;;      (list
;;;;;        (list 45 #HINMEI) ;[46]�i��
;;;;;        (list 46 #BIKOU)  ;[47]���l
;;;;;      )
;;;;;    )
;;;;;  )
;;;;;  ; 03/01/28 YM ADD-E
;-- 2011/09/19 A.Satoh Mod - E

  (princ)
);PKResetWTSETdim$

;;; <HOM>***********************************************************************************
;;; <�֐���>    : KPW_GetWorkTopInfoDlg_ChSeri
;;; <�����T�v>  : ���[�N�g�b�v�̕i�Ԏ擾�_�C�A���O
;;; <�߂�l>    : (�i��  ���i)
;;; <�쐬>      : 00/09/21 YM �W����
;;; <���l>      : �L�����Z������"canceled"���Ԃ�
;;; ***********************************************************************************>MOH<
(defun KPW_GetWorkTopInfoDlg_ChSeri (
  &WRKT$
  &DF_NAME    ; �f�t�H���g�̕i��
  &DF_PRICE   ; �f�t�H���g�̉��i
  &DF_HINMEI  ; �f�t�H���g�̕i��
  &DF_BIKOU   ; �f�t�H���g�̔��l
  /
  #RESULT$ #SDCLID #TYPE1 #WTLEN1 #WTLEN2 #WT_DEP1 #WT_DEP2 #WT_T
  )
  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KPW_GetWorkTopInfoDlg_ChSeri ////")
  (CFOutStateLog 1 1 " ")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckNum (&sKEY / #val #ret)
    (setq #ret nil)
    (setq #val (read (get_tile &sKEY)))
    (if (= (type (read (get_tile &sKEY))) 'INT)
      (if (<= #val -0.001)
        (progn
          (alert "0�ȏ�̐����l����͂��ĉ�����")
          (set_tile &sKEY "")
          (mode_tile &sKEY 2)
        )
        (setq #ret T)
      );_if
      (progn
        (alert "0�ȏ�̐����l����͂��ĉ�����")
        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun ##CheckStr (&sKEY / #ret)
    (setq #ret nil)
;;;01/11/27YM@MOD    (if (= (type (read (get_tile &sKEY))) 'SYM)

; ���l���e 03/01/27 YM MOD-S
;;;    (if (and (= (type (read (get_tile &sKEY))) 'SYM)
;;;            (= (vl-string-search "?" (get_tile &sKEY)) nil)) ; "?"���܂�ł��Ȃ� 01/11/27 YM ADD
    (if (= (vl-string-search "?" (get_tile &sKEY)) nil)
; ���l���e 03/01/27 YM MOD-E

      (setq #ret T)
      (progn
        (alert "�i�Ԃ���͂��ĉ�����")
;;;01/11/27YM@MOD        (set_tile &sKEY "")
        (mode_tile &sKEY 2)
      )
    );_if
    #ret
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; �S���ڃ`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (defun ##Check&GetAllVal ( / #DLG$)
    (cond
      ((not (##CheckNum "edtWT_PRI"))  nil) ; ���ڂɴװ�������nil��Ԃ�
      ((not (##CheckStr "edtWT_NAME")) nil) ; ���ڂɴװ�������nil��Ԃ�
      (T ; ���ڂɴװ�Ȃ�
        (setq #DLG$
          (list
            (strcase (get_tile "edtWT_NAME"))  ; �i�� �啶���ɂ���
            (atoi (get_tile "edtWT_PRI"))      ; ���i(�~)
            ; 03/01/27 YM ADD-S
            (get_tile "edtWT_HINMEI")
            (get_tile "edtWT_BIKOU")
            ; 03/01/27 YM ADD-E
          )
        )
        (done_dialog)
        #DLG$
      )
    );_cond
  ); end of ##Check&GetAllVal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; �S���ڃ`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (defun ##Exit ( / )
    (done_dialog)
    nil
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; ���݂̕i�Ԃɑ΂��ĉ��i���������� 01/04/05 YM
  (defun ##SerchPrice ( / #DLG$ #qry$ #PRICE #WTID)
    (setq #WTid (get_tile "edtWT_NAME"))
    (repeat (strlen #WTid)
      (setq #WTid (vl-string-subst "" "-" #WTid))
    )
    (setq #qry$
      (CFGetDBSQLRec CG_DBSESSION "WT��i"
        (list (list "�i��CD" #WTid 'STR))
      )
    )
    (if (and #qry$ (= (length #qry$) 1))
      (progn
;;;       (setq #price (nth 3 (car #qry$))) ; ���i������

        ;2007/10/29 YM MOD �V�����i�����ċ�ʂ���
        (cond
          ((= (new_old_kakaku_hantei) "NEW")
            (setq #price (nth 8 (car #qry$))) ; ���z2
          )
          ((= (new_old_kakaku_hantei) "OLD");�]��
            (setq #price (nth 3 (car #qry$))) ; ���z
          )
          (T ;�]��
            (setq #price (nth 3 (car #qry$))) ; ���z
          )
        );_cond

        ; ���i���ݸ�Ή� 01/07/02 YM ADD
        (if (or (= nil #price)(= "" #price))
          (setq #price 0) ; ���i������
        );_if
        (set_tile "edtWT_PRI" (itoa (fix (+ #price 0.001))) )
      )
      (mode_tile "edtWT_PRI" 2)
    )
    (princ)
  );##SerchPrice
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #sDCLID (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))

  (setq #WTLEN1  (itoa (fix (+ (car  (nth 55 &WRKT$)) 0.001)))) ; WT��1
  (setq #WTLEN2  (itoa (fix (+ (cadr (nth 55 &WRKT$)) 0.001)))) ; WT��2
  (setq #WT_DEP1 (itoa (fix (+ (car  (nth 57 &WRKT$)) 0.001)))) ; WT���s��1
  (setq #WT_DEP2 (itoa (fix (+ (cadr (nth 57 &WRKT$)) 0.001)))) ; WT���s��2
  (setq #WT_T    (itoa (fix (+       (nth 10 &WRKT$)  0.001)))) ; WT����

  (if (= nil (new_dialog "GetWorkTopInfoDlg_ChSeriADD" #sDCLID)) (exit)) ; L�^�p �i���A���l�ǉ�
;;; (if (= nil (new_dialog "GetWorkTopInfoDlg_ChSeri" #sDCLID)) (exit)) ; L�^�p
;;; ��ُ����l�ݒ�
  (set_tile "edtWT_NAME" &DF_NAME)
  (set_tile "edtWT_PRI" (itoa &DF_PRICE))

  ; 03/01/27 YM ADD-S
  (set_tile "edtWT_HINMEI" &DF_HINMEI)
  (set_tile "edtWT_BIKOU"  &DF_BIKOU)
  ; 03/01/27 YM ADD-E

  (set_tile "txt11" #WTLEN1)
  (set_tile "txt22" #WTLEN2)
  (set_tile "txt33" #WT_DEP1)
  (set_tile "txt44" #WT_DEP2)
  (set_tile "txt55" #WT_T)
  ; ���� ���i�̓��͒l�`�F�b�N(0�ȏ�̎������ǂ���)
  (action_tile "BUTTON"  "(##SerchPrice)")
;;;  (action_tile "edtWT_PRI"  "(##CheckNum \"edtWT_PRI\")")
;;;  (action_tile "edtWT_NAME" "(##CheckStr \"edtWT_NAME\")")
  ; OK�{�^���������ꂽ��S���ڂ��`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (action_tile "accept" "(setq #RESULT$ (##Check&GetAllVal))")
  (action_tile "cancel" "(setq #RESULT$ (##Exit))") ; cancel
  (start_dialog)
  (unload_dialog #sDCLID)
  #RESULT$
);KPW_GetWorkTopInfoDlg_ChSeri

;-- 2011/06/23 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : WKP_GetWorkTop_KEIJO
; <�����T�v>  : ���[�N�g�b�v�`�󌈒�
; <�߂�l>    : �`��ID
; <���l>      : 
;*************************************************************************>MOH<
(defun WKP_GetWorkTop_KEIJO (
  &TYPE     ; �`��^�C�v
  &dep$     ; ���s���X�g
  &len$     ; �����X�g
  /
  #KEIJO
  )

  (cond
    ;�h�^����
		;2018/06/20 YM MOD-S
    ((= &TYPE 0) ;I�`��,�ׯĊ܂�(�l��or���)
      (if (and (car &dep$) (< 725.0 (car &dep$)))
        (setq #KEIJO "IPA")
        (setq #KEIJO "I00")
      )
    )
;;;    ((= &TYPE 0) ;I�`��,�ׯĊ܂�(�l��or���)
;;;      (if (and (car &dep$) (< 750.0 (car &dep$)))
;;;        (setq #KEIJO "IPA")
;;;        (setq #KEIJO "I00")
;;;      )
;;;    )
		;2018/06/20 YM MOD-E

    ;�k�^����
    ((= &TYPE 1) ;L,���
      (if (cadr &len$)
        (cond
          ((equal (cadr &len$) 1650 0.01)
            (setq #KEIJO "L16")
          )
          ((equal (cadr &len$) 1800 0.01)
            (setq #KEIJO "L18")
          )
          ((equal (cadr &len$) 1950 0.01)
            (setq #KEIJO "L19")
          )
          ((equal (cadr &len$) 2100 0.01)
            (setq #KEIJO "L21")
          )
          (T
            (setq #KEIJO "?")
          )
        )
      )
    )
    (T
      (setq #KEIJO "?")
    )
  );_cond

  #KEIJO
);WKP_GetWorkTop_KEIJO


;<HOM>*************************************************************************
; <�֐���>    : WKP_GetWorkTop_SINK_KIGO
; <�����T�v>  : �V���N�L������
; <�߂�l>    : �V���N�L��
; <���l>      : 
;*************************************************************************>MOH<
(defun WKP_GetWorkTop_SINK_KIGO (
  &eSNK$
  &eGAS_P5$
  /
  #SINK #xd_SINK$
  )

  (if (< 0 (length &eSNK$))
    (progn ; �ݸ����
      (if (= 1 (length &eSNK$)) ; �ݸ1��
        (if (setq #xd_SINK$ (CFGetXData (car &eSNK$) "G_SINK"))
          (progn
            (setq #SINK (nth 0 #xd_SINK$))
            (setq #SINK (KP_GetSinkKIGO #SINK))
          )
          ;else
          (setq #SINK "?")
        );_if
        ;else
        (setq #SINK "?")
      );_if
    )
    ;else
    (progn ; �ݸ�Ȃ�
      (if (< 0 (length &eGAS_P5$))
        (setq #SINK "GG") ; �ݸ�Ȃ��Ŷ޽����
        ;else
        (setq #SINK "N") ; �ݸ�Ȃ��Ŷ޽�Ȃ�
      );_if
    )
  );_if

  #SINK
);WKP_GetWorkTop_SINK_KIGO


;<HOM>*************************************************************************
; <�֐���>    : WKP_GetWorkTop_SINK_ITI
; <�����T�v>  : �V���N�ʒu�����߂�
; <�߂�l>    : �V���N�ʒu or nil
; <���l>      : 
;*************************************************************************>MOH<
(defun WKP_GetWorkTop_SINK_ITI (
;-- 2011/09/30 A.Satoh Mod - S
;;;;;  &WRKT$
;;;;;  &eSNK
  &distSink
;-- 2011/09/30 A.Satoh Mod - E
;-- 2011/09/14 A.Satoh Add - S
  &sink$  ; (�Ԍ� �`�� ���s�� �V���N�L�� �R�����e���@)
  &ZaiF   ; 0:�l���嗝�� 1:�X�e�����X
;-- 2011/09/14 A.Satoh Add - E
	&dan_f  ;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - S
  /
;-- 2011/09/30 A.Satoh Mod - S
;;;;;  #SINK_ITI #Type #WTLR #baseP #tei #WTpt$ #SINKpt$
;;;;;  #p1 #p2 #p3 #p4 #p5 #p6 #distSink
;;;;;;-- 2011/09/14 A.Satoh Add - S
;;;;;  #qry$$ #qry$ #culm
;;;;;;-- 2011/09/14 A.Satoh Add - E
  #SINK_ITI #culm #qry$$ 
;-- 2011/09/30 A.Satoh Mod - E
  )
	;2012/08/02 YM ADD-S �ݸ���Ȃ��ƕi�Ԋm��ł��Ȃ�
	(if (= &distSink nil)
		(setq &distSink 0.0)
	);_if
	;2012/08/02 YM ADD-E �ݸ���Ȃ��ƕi�Ԋm��ł��Ȃ�

  (setq #SINK_ITI nil)

;-- 2011/09/30 A.Satoh Del - S
;;;;;  ;;; �V���N�e���@�����߂�
;;;;;  (setq #Type  (nth  3 &WRKT$)) ; �`������
;;;;;  (setq #WTLR  (nth 30 &WRKT$)) ; ���E����
;;;;;  (setq #baseP (nth 32 &WRKT$)) ; WT����_
;;;;;  (setq #tei   (nth 38 &WRKT$))   ; WT��ʐ}�`�����
;;;;;  (setq #WTpt$ (GetLWPolyLinePt #tei))
;;;;;  (setq #WTpt$ (GetPtSeries #BaseP #WTpt$)) ; WT��ʍ��W�_������v�����
;;;;;  (setq #SINKpt$ (GetLWPolyLinePt &eSNK)) ; �V���N�O�`�_��
;;;;;
;;;;;  (cond
;;;;;    ((= #Type 0)  ; I�^
;;;;;      (setq #p1 (nth 0 #WTpt$))
;;;;;      (setq #p2 (nth 1 #WTpt$))
;;;;;      (setq #p3 (nth 2 #WTpt$))
;;;;;      (setq #p4 (last  #WTpt$))
;;;;;
;;;;;      ; �V���N�e���@�̎Z�o
;;;;;      (cond
;;;;;        ((= #WTLR "R") ; �E����̂Ƃ�
;;;;;          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
;;;;;          (princ "\n�������@SINK�e= ")(princ #distSink)
;;;;;        )
;;;;;        ((= #WTLR "L") ; ������̂Ƃ�
;;;;;          (setq #distSink (GetDistLineToPline (list #p1 #p4) #SINKpt$))
;;;;;          (princ "\n�������@SINK�e= ")(princ #distSink)
;;;;;        )
;;;;;        (T ; ����ȊO
;;;;;          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
;;;;;          (princ "\n�������@SINK�e= ")(princ #distSink)
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;    ((= #Type 1)  ; L�^
;;;;;      (setq #p1 (nth 0 #WTpt$))
;;;;;      (setq #p2 (nth 1 #WTpt$))
;;;;;      (setq #p3 (nth 2 #WTpt$))
;;;;;      (setq #p4 (nth 3 #WTpt$))
;;;;;      (setq #p5 (nth 4 #WTpt$))
;;;;;      (setq #p6 (nth 5 #WTpt$))
;;;;;
;;;;;      ; �V���N�e���@�̎Z�o
;;;;;      (cond
;;;;;        ((= #WTLR "R") ; �E����̂Ƃ�
;;;;;          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
;;;;;          (princ "\n�������@SINK�e= ")(princ #distSink)
;;;;;        )
;;;;;        ((= #WTLR "L") ; ������̂Ƃ�
;;;;;          (setq #distSink (GetDistLineToPline (list #p5 #p6) #SINKpt$))
;;;;;          (princ "\n�������@SINK�e= ")(princ #distSink)
;;;;;        )
;;;;;        (T ; ����ȊO
;;;;;          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
;;;;;          (princ "\n�������@SINK�e= ")(princ #distSink)
;;;;;        )
;;;;;      )
;;;;;    )
;;;;;    (T            ; ���̑�(U�^)
;;;;;      (setq #distSink 0.0)
;;;;;      (princ "\n�������@U�^���� SINK�e= ")(princ #distSink)
;;;;;    )
;;;;;  )
;-- 2011/09/30 A.Satoh Del - E

  ; �V���N�ʒu���擾����
;-- 2011/09/14 A.Satoh Add - S
  (cond
    ((= &ZaiF 0)  ; �l���嗝��
      (setq #culm "�l��V���N�e")
    )
    ((= &ZaiF 1)  ; �X�e�����X
      (setq #culm "�X�e���V���N�e")
    )
  )

;-- 2012/05/17 A.Satoh Mod �i�����V�i�Ԋm��Ή� - S
;;;;;  (setq #qry$$
;;;;;    (CFGetDBSQLRec CG_DBSESSION "�K�i�V�e���@"
;;;;;      (list
;;;;;        (list "�Ԍ�"         (nth 0 &sink$)        'STR)
;;;;;        (list "�`��"         (nth 1 &sink$)        'STR)
;;;;;        (list "���s��"       (nth 2 &sink$)        'STR)
;;;;;        (list "�V���N�L��"   (nth 3 &sink$)        'STR)
;;;;;;        (list "�V���N�e���@" (rtos #distSink)      'INT)
;;;;;        (list #culm          (rtos &distSink)      'INT)
;;;;;        (list "�R�����e���@" (rtos (nth 4 &sink$)) 'INT)
;;;;;      )
;;;;;    )
;;;;;  )
	(if (= &dan_f nil)
		(progn
;;;			(princ "\n�������@�R�����e���@= ")(princ (rtos (nth 4 &sink$)))
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�K�i�V�e���@"
					(list
						(list "�Ԍ�"         (nth 0 &sink$)        'STR)
						(list "�`��"         (nth 1 &sink$)        'STR)
						(list "���s��"       (nth 2 &sink$)        'STR)
						(list "�V���N�L��"   (nth 3 &sink$)        'STR)
						(list #culm          (rtos &distSink)      'INT)
						(list "�R�����e���@" (rtos (nth 4 &sink$)) 'INT)
					)
				)
			)
		)
		(progn
;;;			(princ (strcat "\n������" #culm "= "))(princ (rtos &distSink))
			(setq #qry$$
				(CFGetDBSQLRec CG_DBSESSION "�K�i�V�e���@"
					(list
						(list "�Ԍ�"         (nth 0 &sink$)        'STR)
						(list "�`��"         (nth 1 &sink$)        'STR)
						(list "���s��"       (nth 2 &sink$)        'STR)
						(list "�V���N�L��"   (nth 3 &sink$)        'STR)
						(list #culm          (rtos &distSink)      'INT)
					)
				)
			)
		)
	);_if

	(princ "\n")
	(princ "\n�������@�y�K�i�V�e���@�z����KEY")
	(princ "\n---------------------------------------")
	(princ (strcat   "\n�Ԍ�= "         (nth 0 &sink$)        ))
	(princ (strcat   "\n�`��= "         (nth 1 &sink$)        ))
	(princ (strcat   "\n���s��= "       (nth 2 &sink$)        ))
	(princ (strcat   "\n�V���N�L��= "   (nth 3 &sink$)        ))
	(princ (strcat   "\n" #culm "= "    (rtos &distSink)      ))
	(if (= &dan_f nil)
		(princ (strcat "\n�R�����e���@= " (rtos (nth 4 &sink$)) ))
	);_if
	(princ "\n---------------------------------------")
	(princ "\n")


;-- 2012/05/17 A.Satoh Mod �i�����V�i�Ԋm��Ή� - E

  (if (and #qry$$ (= 1 (length #qry$$)))
    (progn
      (setq #qry$ (nth 0 #qry$$))
      (setq #SINK_ITI (nth 3 #qry$))
    )
		(progn
			;2017/01/13 YM ADD ����ǉ�
			;����HIT�����ꍇ(���Ԍ��Q�� or �R��)�ǂꂩ���[�U�[�ɐq�˂�
			(if (< 1 (length #qry$$))
				(progn
					;;; S2T , S2N , S3S
					(initget 1 "1 2 3 ")
					(setq #WORD (getkword "\n���M�@��`����w�� /1=2���c /2=2���΂� /3=3�� /: "))
				  (cond
						((= #WORD "1")(setq #SINK_ITI "S2T"))
						((= #WORD "2")(setq #SINK_ITI "S2N"))
						((= #WORD "3")(setq #SINK_ITI "S3S"))
						(T
							(setq #SINK_ITI "?")
					 	)
					);_cond
				)
				(progn ;HIT���Ȃ��ꍇ
					(princ "\n�������@�y�K�i�V�e���@�zHIT���Ȃ�")
    			(setq #SINK_ITI "?")
				)
			);_if
		)
  );_if

  (princ "\n�������@�K�i�V�¼ݸ�e= ")(princ #SINK_ITI)

;-- 2011/09/14 A.Satoh Add - E

;-- 2011/09/14 A.Satoh Del - S
;;*********************************
;; �b�菈��
;  (setq #SINK_ITI "E")
;;*********************************
;-- 2011/09/14 A.Satoh Del - E

  #SINK_ITI

);WKP_GetWorkTop_SINK_ITI
;-- 2011/06/23 A.Satoh Add - E


;-- 2011/09/30 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : KPW_GetDispSink
; <�����T�v>  : �V���N�e���@���Z�o����
; <�߂�l>    : �V���N�e���@�l(���l)
; <���l>      : 
;*************************************************************************>MOH<
(defun KPW_GetDispSink (
  &WRKT$
  &eSNK
;-- 2012/05/18 A.Satoh Add �i�����V�Ή� - S
	&dan_f
	&dan_LR
;-- 2012/05/18 A.Satoh Add �i�����V�Ή� - E
  /
  #Type #WTLR #baseP #tei #WTpt$ #SINKpt$ #p1 #p2 #p3 #p4 #distSink
  )

  (setq #Type  (nth  3 &WRKT$)) ; �`������
  (setq #WTLR  (nth 30 &WRKT$)) ; ���E����
  (setq #baseP (nth 32 &WRKT$)) ; WT����_
  (setq #tei   (nth 38 &WRKT$))   ; WT��ʐ}�`�����
  (setq #WTpt$ (GetLWPolyLinePt #tei))
  (setq #WTpt$ (GetPtSeries #BaseP #WTpt$)) ; WT��ʍ��W�_������v�����
  (setq #SINKpt$ (GetLWPolyLinePt &eSNK)) ; �V���N�O�`�_��

  (cond
    ((= #Type 0)  ; I�^
      (setq #p1 (nth 0 #WTpt$))
      (setq #p2 (nth 1 #WTpt$))
      (setq #p3 (nth 2 #WTpt$))
      (setq #p4 (last  #WTpt$))

      ; �V���N�e���@�̎Z�o
      (cond
        ((= #WTLR "R") ; �E����̂Ƃ�
          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
          (princ "\n�������@���ۂ�SINK�e= ")(princ #distSink)
        )
        ((= #WTLR "L") ; ������̂Ƃ�
          (setq #distSink (GetDistLineToPline (list #p1 #p4) #SINKpt$))
          (princ "\n�������@���ۂ�SINK�e= ")(princ #distSink)
        )
        (T ; ����ȊO
;-- 2012/05/18 A.Satoh Mod �i�����V�Ή� - S
;;;;;          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
					(if &dan_f
						(if (= &dan_LR "L")
          		(setq #distSink (GetDistLineToPline (list #p1 #p4) #SINKpt$))
							(setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
						)
						(setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
					)
;-- 2012/05/18 A.Satoh Mod �i�����V�Ή� - E
          (princ "\n�������@���ۂ�SINK�e= ")(princ #distSink)
        )
      )
    )
    ((= #Type 1)  ; L�^
      (setq #p1 (nth 0 #WTpt$))
      (setq #p2 (nth 1 #WTpt$))
      (setq #p3 (nth 2 #WTpt$))
      (setq #p4 (nth 3 #WTpt$))
      (setq #p5 (nth 4 #WTpt$))
      (setq #p6 (nth 5 #WTpt$))

      ; �V���N�e���@�̎Z�o
      (cond
        ((= #WTLR "R") ; �E����̂Ƃ�
          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
          (princ "\n�������@���ۂ�SINK�e= ")(princ #distSink)
        )
        ((= #WTLR "L") ; ������̂Ƃ�
          (setq #distSink (GetDistLineToPline (list #p5 #p6) #SINKpt$))
          (princ "\n�������@���ۂ�SINK�e= ")(princ #distSink)
        )
        (T ; ����ȊO
          (setq #distSink (GetDistLineToPline (list #p2 #p3) #SINKpt$))
          (princ "\n�������@���ۂ�SINK�e= ")(princ #distSink)
        )
      )
    )
    (T            ; ���̑�(U�^)
      (setq #distSink 0.0)
      (princ "\n�������@U�^���� SINK�e= ")(princ #distSink)
    )
  )

  #distSink
) ; KPW_GetDispSink
;-- 2011/09/30 A.Satoh Add - E


;-- 2011/08/26 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : KPW_SetWorkTopInfoDlg
; <�����T�v>  : �V�i���m��_�C�A���O����
; <�߂�l>    : �V���͏�񃊃X�g or nil
; <���l>      : &hinban_dat$
;             :  �����@�F���z��������
;             :  �߂�l�F���z�����l
;
;*************************************************************************>MOH<
(defun KPW_SetWorkTopInfoDlg (
  &hinban_dat$  ; �V��񃊃X�g
                ; [0] �����t���O(����) 0:���� 1:�K�i
                ; [1] �i��(������)
                ; [2] ���z(������)
                ; [3] ��(������)
                ; [4] ����(������)
                ; [5] ���s(������)
                ; [6] �i��(������)
                ; [7] �����R�[�h(������)
	&type					; �`��^�C�v�@0:I�^ 1:L�^ 2:U�^
  /
  #dcl_id #ret$
  #TOKU_FLG #WT_HINBAN #WT_PRI #WT_HABA #WT_TAKASA #WT_OKUYUKI #WT_HINMEI #TOKU_CD
  #TOKU1 #TOKU2
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KPW_SetWorkTopInfoDlg ////")
  (CFOutStateLog 1 1 " ")

	;***********************************************************************
	; ����̕�����ɑ΂��A�S�p���܂܂�邩���`�F�b�N����
	; �߂�l:T �S�p����@nil:���p�̂�
	; �����R�[�h��127(0x80)���傫���ꍇ�͑S�p�����Ƃ݂Ȃ�
	;***********************************************************************
	(defun ##CheckStr (
		&str
		/
		#idx #flg
		)

		(setq #flg nil)
		(setq #idx 1)

		(while (and (<= #idx (strlen &str)) (not #flg))
			(setq #code (ascii(substr &str #idx 1)))
			(if (> #code 127); 0x80(127)����̏ꍇ�͑S�p�����Ƃ݂Ȃ�
				; ���p�J�i(161�`223)�͑ΏۊO�Ƃ���
				(if (or (< #code 161) (> #code 223))
					(setq #flg T)
				)
			)
			(setq #idx (1+ #idx))
		)

		#flg
	)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; �S���ڃ`�F�b�N�B�ʂ�Ό��ʃ��X�g�ɉ��H���ĕԂ��B
  (defun ##GetItemData (
    /
    #hinban #price #hinmei #tokucd #width #height #depth
    #err_flg #data$ #tokucd1 #tokucd2 #flg1 #flg2
    )

    (setq #err_flg nil)

    ; �ŏI�i�ԃ`�F�b�N
    (setq #hinban (get_tile "edtWT_NAME"))
    (if (or (= #hinban "") (= #hinban nil))
      (progn
        (set_tile "error" "�i�Ԃ����͂���Ă��܂���")
        (mode_tile "edtWT_NAME" 2)
        (setq #err_flg T)
      )
			(progn
      	(setq #hinban (strcase #hinban))
				(if (> (strlen #hinban) 15)
					(progn
            (set_tile "error" "�i�Ԃ�15���ȉ��œ��͂��ĉ�����")
            (mode_tile "edtWT_NAME" 2)
            (setq #err_flg T)
					)
				)
			)
    )

    ; ���z�`�F�b�N
    (if (= #err_flg nil)
      (progn
        (setq #price (get_tile "edtWT_PRI"))
        (if (or (= #price "") (= #price nil))
          (progn
            (set_tile "error" "���z�����͂���Ă��܂���")
            (mode_tile "edtWT_PRI" 2)
            (setq #err_flg T)
          )
          (if (= (type (read #price)) 'INT)
            (if (> 0 (read #price))
              (progn
                (set_tile "error" "���z�� 9999999 �ȉ��̐����l����͂��ĉ�����")
                (mode_tile "edtWT_PRI" 2)
                (setq #err_flg T)
              )
							(if (> (read #price) 9999999)
								(progn
	                (set_tile "error" "���z�� 9999999 �ȉ��̐����l����͂��ĉ�����")
  	              (mode_tile "edtWT_PRI" 2)
    	            (setq #err_flg T)
								)
							)
            )
            (progn
              (set_tile "error" "���z�� 9999999 �ȉ��̐����l����͂��ĉ�����")
              (mode_tile "edtWT_PRI" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; �i���擾
    (if (= #err_flg nil)
			(progn
      	(setq #hinmei (get_tile "edtWT_HINMEI"))
	      (if (= #TOKU_FLG 1)
					(progn	; �K�i�V�ł���ꍇ
						(if (> (strlen #hinmei) 38)
    		      (progn
		            (set_tile "error" "�i����38���ȉ��œ��͂��ĉ�����")
		            (mode_tile "edtWT_HINMEI" 2)
    		        (setq #err_flg T)
        		  )
						)
					)
					(progn	; �����V�ł���ꍇ
						(if (> (strlen #hinmei) 30)
    		      (progn
		            (set_tile "error" "�i����30���ȉ��œ��͂��ĉ�����")
    		        (mode_tile "edtWT_HINMEI" 2)
        		    (setq #err_flg T)
		          )
							(if (##CheckStr #hinmei)
								(progn
	  		          (set_tile "error" "�i���͔��p�̂ݓ��͉\�ł�")
  	  		        (mode_tile "edtWT_HINMEI" 2)
    	  		      (setq #err_flg T)
								)
							)
						)
					)
				)
			)
    )

    ; �����R�[�h�`�F�b�N
    (if (= #err_flg nil)
      (progn
        (setq #tokucd1 (get_tile "edtWT_Toku1"))
        (setq #tokucd2 (get_tile "edtWT_Toku2"))

        (if (or (= #tokucd1 "") (= #tokucd1 nil))
          (setq #flg1 nil)
          (setq #flg1 T)
        )
        (if (or (= #tokucd2 "") (= #tokucd2 nil))
          (setq #flg2 nil)
          (setq #flg2 T)
        )

        (cond
          ((and (= #flg1 nil) (= #flg2 nil))
            (setq #tokucd "")
          )
          ((and (= #flg1 T) (= #flg2 nil))
            (set_tile "error" "�����R�[�h�����͂���Ă��܂���")
            (mode_tile "edtWT_Toku2" 2)
            (setq #err_flg T)
          )
          ((and (= #flg1 nil) (= #flg2 T))
            (set_tile "error" "�����R�[�h�����͂���Ă��܂���")
            (mode_tile "edtWT_Toku1" 2)
            (setq #err_flg T)
          )
          (T
            (if (= (type (read #tokucd2)) 'INT)
              (if (> 1 (read #tokucd2))
                (progn
                  (set_tile "error" "1�ȏ�̐����l����͂��ĉ�����")
                  (mode_tile "edtWT_Toku2" 2)
                  (setq #err_flg T)
                )
              )
              (progn
                (set_tile "error" "1�ȏ�̐����l����͂��ĉ�����")
                (mode_tile "edtWT_Toku2" 2)
                (setq #err_flg T)
              )
            )

            (if (= #err_flg nil)
              (if (< (strlen #tokucd1) 12)
                (progn
                  (set_tile "error" "���ނ�12���œ��͂��ĉ�����")
                  (mode_tile "edtWT_Toku1" 2)
                  (setq #err_flg T)
                )
                (progn
                  (setq #tokucd1 (strcase #tokucd1))
                  (if (= (strlen #tokucd2) 1)
                    (setq #tokucd2 (strcat "00" #tokucd2))
                    (if (= (strlen #tokucd2) 2)
                      (setq #tokucd2 (strcat "0" #tokucd2))
                    )
                  )
                  (setq #tokucd (strcat #tokucd1 "-" #tokucd2))
                )
              )
            )
          )
        )
      )
    )

    ; �Ѓ`�F�b�N
    (if (= #err_flg nil)
      (progn
        (setq #width (get_tile "edtWT_Width"))
        (if (or (= #width "") (= #width nil))
          (setq #width "")
          (if (or (= (type (read #width)) 'INT) (= (type (read #width)) 'REAL))
            (if (> 0 (read #width))
              (progn
                (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
                (mode_tile "edtWT_Width" 2)
                (setq #err_flg T)
              )
							(if (> (read #width) 99999)
								(progn
	                (set_tile "error" "�Ђ� 99999 �ȉ��̐��l����͂��ĉ�����")
  	              (mode_tile "edtWT_Width" 2)
    	            (setq #err_flg T)
								)
							)
            )
            (progn
              (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
              (mode_tile "edtWT_Width" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; �����`�F�b�N
    (if (= #err_flg nil)
      (progn
        (setq #height (get_tile "edtWT_Height"))
        (if (or (= #height "") (= #height nil))
          (setq #height "")
          (if (or (= (type (read #height)) 'INT) (= (type (read #height)) 'REAL))
            (if (> 0 (read #height))
              (progn
                (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
                (mode_tile "edtWT_Height" 2)
                (setq #err_flg T)
              )
							(if (= &type 1)	; L�^�ł���ꍇ
								(if (>= (read #height) 99999)
									(progn
	  	              (set_tile "error" "������ 99999 �ȉ��̐��l����͂��ĉ�����")
  	  	            (mode_tile "edtWT_Height" 2)
    	  	          (setq #err_flg T)
									)
								)

								;2019/03/19 YM MOD
;;;								(if (>= (read #height) 1000)
								(if (>= (read #height) 3000);2019/03/19 YM MOD
									(progn
;;;	                	(set_tile "error" "������ 1000 �����̐��l����͂��ĉ�����")
	                	(set_tile "error" "������ 3000 �����̐��l����͂��ĉ�����");2019/03/19 YM MOD
	  	              (mode_tile "edtWT_Height" 2)
  	  	            (setq #err_flg T)
									)
								)
							)
            )
            (progn
              (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
              (mode_tile "edtWT_Height" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; ���s�`�F�b�N
    (if (= #err_flg nil)
      (progn
        (setq #depth (get_tile "edtWT_Depth"))
        (if (or (= #depth "") (= #depth nil))
          (setq #depth "")
          (if (or (= (type (read #depth)) 'INT) (= (type (read #depth)) 'REAL))
            (if (> 0 (read #depth))
              (progn
                (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
                (mode_tile "edtWT_Depth" 2)
                (setq #err_flg T)
              )
							(if (= &type 1)
								(if (> (read #depth) 1000)
									(progn
	  	              (set_tile "error" "���s�� 1000 �����̐��l����͂��ĉ�����")
  	  	            (mode_tile "edtWT_Depth" 2)
    	  	          (setq #err_flg T)
									)
								)
								(if (> (read #depth) 99999)
									(progn
	                	(set_tile "error" "���s�� 99999 �ȉ��̐��l����͂��ĉ�����")
	  	              (mode_tile "edtWT_Depth" 2)
  	  	            (setq #err_flg T)
									)
								)
							)
            )
            (progn
              (set_tile "error" "0�ȏ�̐��l����͂��ĉ�����")
              (mode_tile "edtWT_Depth" 2)
              (setq #err_flg T)
            )
          )
        )
      )
    )

    ; ���i0�~�̊m�F
    (if (= #err_flg nil)
      (if (equal (atof #price) 0.0 0.0001)
        (if (= (CFYesNoDialog "���i��0�~�ŗǂ��ł����H") nil)
          (setq #err_flg T)
        )
      )
    )

    ; �K�i�i�ł���ꍇ�̓��͍��ك`�F�b�N
    (if (= #err_flg nil)
      (if (= #TOKU_FLG 1)
        (if (or
              (/= #WT_HINBAN  #hinban)   ; �ŏI�i��
              (/= #WT_PRI     #price)    ; ���z
              (/= #WT_HINMEI  #hinmei)   ; �i��
              (/= #TOKU_CD    #tokucd)   ; �����R�[�h
              (/= #WT_HABA    #width)    ; ��
              (/= #WT_TAKASA  #height)   ; ����
              (/= #WT_OKUYUKI #depth)    ; ���s��
            )
          (if (= (CFYesNoDialog "���e���ύX����Ă��܂�����낵���ł����H") nil)
            (setq #err_flg T)
          )
        )
      )
    )

    ; �V��񃊃X�g�̍쐬
    (if (= #err_flg nil)
      (progn
        (setq #data$ (list #TOKU_FLG #hinban (atof #price) #width #height #depth #hinmei #tokucd))
        (done_dialog)
        #data$
      )
    )

  ); end of GetItemData
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #TOKU_FLG   (nth 0 &hinban_dat$)) ; �����t���O
  (setq #WT_HINBAN  (nth 1 &hinban_dat$)) ; �i��
  (setq #WT_PRI     (nth 2 &hinban_dat$)) ; ���z
  (setq #WT_HABA    (nth 3 &hinban_dat$)) ; ��
  (setq #WT_TAKASA  (nth 4 &hinban_dat$)) ; ����
  (setq #WT_OKUYUKI (nth 5 &hinban_dat$)) ; ���s
  (setq #WT_HINMEI  (nth 6 &hinban_dat$)) ; �i��
  (setq #TOKU_CD    (nth 7 &hinban_dat$)) ; �����R�[�h
  (if (/= #TOKU_CD "")
    (progn
      (setq #TOKU1 (substr #TOKU_CD 1 12))
      (setq #TOKU2 (substr #TOKU_CD 14 3))
    )
    (progn
      (setq #TOKU1 "")
      (setq #TOKU2 "")
    )
  )

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))

  (if (= nil (new_dialog "SetWorkTopInfoDlg" #dcl_id)) (exit))

  ; �_�C�A���O�^�C�g���ݒ�
  (if (= #TOKU_FLG 0)
    (set_tile "lab" "�����V������")
    (set_tile "lab" "�V������")
  )

  ; �����l�ݒ�
;  (if (= #TOKU_FLG 0)
;    (progn  ; ����
  (set_tile "edtWT_NAME"   #WT_HINBAN)    ; �ŏI�i��
  (set_tile "edtWT_PRI"    #WT_PRI)       ; ���z
  (set_tile "edtWT_HINMEI" #WT_HINMEI)    ; �i��
  (set_tile "edtWT_Toku1"  #TOKU1)        ; �����R�[�h�P
  (set_tile "edtWT_Toku2"  #TOKU2)        ; �����R�[�h�Q
  (set_tile "edtWT_Width"  #WT_HABA)      ; ��
  (set_tile "edtWT_Height" #WT_TAKASA)    ; ����
  (set_tile "edtWT_Depth"  #WT_OKUYUKI)   ; ���s��
  (mode_tile "edtWT_NAME"   0)
  (mode_tile "edtWT_PRI"    0)
  (mode_tile "edtWT_HINMEI" 0)
  (if (= #TOKU_FLG 0)
    (progn  ; ����
      (mode_tile "edtWT_Toku1"  0)
      (mode_tile "edtWT_Toku2"  0)
    )
    (progn  ; �K�i
      (mode_tile "edtWT_Toku1"  1)
      (mode_tile "edtWT_Toku2"  1)
    )
  )
  (mode_tile "edtWT_Width"  0)
  (mode_tile "edtWT_Height" 0)
  (mode_tile "edtWT_Depth"  0)
;    )
;    (progn  ; �K�i
;      (set_tile "edtWT_NAME"   #WT_HINBAN)    ; �ŏI�i��
;      (set_tile "edtWT_PRI"    #WT_PRI)       ; ���z
;      (set_tile "edtWT_HINMEI" #WT_HINMEI)    ; �i��
;      (set_tile "edtWT_Toku1"  "")            ; �����R�[�h�P
;      (set_tile "edtWT_Toku2"  "")            ; �����R�[�h�Q
;      (set_tile "edtWT_Width"  #WT_HABA)      ; ��
;      (set_tile "edtWT_Height" #WT_TAKASA)    ; ����
;      (set_tile "edtWT_Depth"  #WT_OKUYUKI)   ; ���s��
;      (mode_tile "edtWT_NAME"   1)
;      (mode_tile "edtWT_PRI"    1)
;      (mode_tile "edtWT_HINMEI" 1)
;      (mode_tile "edtWT_Toku1"  1)
;      (mode_tile "edtWT_Toku2"  1)
;      (mode_tile "edtWT_Width"  1)
;      (mode_tile "edtWT_Height" 1)
;      (mode_tile "edtWT_Depth"  1)
;    )
;  )

  (action_tile "accept" "(setq #ret$ (##GetItemData))")
  (action_tile "cancel" "(setq #ret$ nil)(setq #loop nil)(done_dialog)")

  (start_dialog)

  (unload_dialog #dcl_id)

  #ret$

);KPW_SetWorkTopInfoDlg
;-- 2011/08/26 A.Satoh Add - E


;-- 2012/05/17 A.Satoh Add �i�����V�i�Ԋm��Ή� - S
;<HOM>*************************************************************************
; <�֐���>    : KPW_CheckDanotiWorkTopDlg
; <�����T�v>  : �i�����m�F�_�C�A���O�������s��
; <�߂�l>    : �i�����m�F��񃊃X�g or nil
;             :  (�V��ރt���O LR�敪)
;             :    �V��ރt���O�FT �ʏ�V��  nil �i�����V��
;             :    �k�q�敪�@�F"L" ������  "R" �E����  "Z" �s��
;             :   ��:
;             :     �ʏ�V�ł���ꍇ�@(nil "Z")
;             :     �i�����V�ł���ꍇ (T "L")
; <���l>      :
;*************************************************************************>MOH<
(defun KPW_CheckDanotiWorkTopDlg (
  /
	#dcl_id #ret$
  )

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// KPW_CheckDanotiWorkTopDlg ////")
  (CFOutStateLog 1 1 " ")

	;***********************************************************************
	; �V��ރ��W�I�{�^���I�����̃_�C�A���O���䏈�����s��
	; �E�ʏ��I��
	;     ���E���胉�W�I�{�^���̔񊈐���
	; �E�i������I��
	;     ���E���胉�W�I�{�^���̊�����
	;
	; �߂�l: �Ȃ�
	;***********************************************************************
	(defun ##SetLREnable (
		/
		#Reguler #Danoti
		)

		; �G���[�^�C���̏�����
		(set_tile "error" "")

		(setq #Reguler (get_tile "Reguler"))	; �ʏ�
		(setq #Danoti  (get_tile "Danoti"))		; �i����

		; �u�ʏ�v�V���I�����ꂽ�ꍇ
		(if (= #Reguler "1")
			(progn
				(set_tile "Left" "0")
				(set_tile "Right" "0")
				(mode_tile "Left" 1)
				(mode_tile "Right" 1)
			)
		)

		; �u�i�����v�V���I�����ꂽ�ꍇ
		(if (= #Danoti "1")
			(progn
				(set_tile "Left" "0")
				(set_tile "Right" "0")
				(mode_tile "Left" 0)
				(mode_tile "Right" 0)
			)
		)

  ); end of ##SetLREnable

	;***********************************************************************
	; �i�����m�F�_�C�A���O�̂n�j�{�^�������������s��
	; �E���̓`�F�b�N
	; �E�i�����m�F���쐬
	;
	; �߂�l: �i�����m�F��񃊃X�g
	;           �t�H�[�}�b�g�F(�V��ރt���O LR�敪)
	;             �V��ރt���O�FT �i�����V��  nil �ʏ�V��
	;             LR�敪�@�@�@�@�F"L" ������  "R" �E����  "Z" �s��
	;***********************************************************************
  (defun ##KPW_CheckDanotiWorkTopDlg_CallBack (
    /
		#err_flg #Reguler #Danoti #Left #Right #dan_f #LR #ret$
    )

    (setq #err_flg nil)

		; �V��ޓ��̓`�F�b�N
		(setq #Reguler (get_tile "Reguler"))	; �ʏ�
		(setq #Danoti  (get_tile "Danoti"))		; �i����
		(if (and (= #Reguler "0") (= #Danoti "0"))
			(progn
				(set_tile "error" "�V��ނ��I������Ă��܂���")
				(setq #err_flg T)
			)
		)

		; ���E������̓`�F�b�N
		(if (= #err_flg nil)
			(if (= #Danoti "1")
				(progn
					(setq #Left  (get_tile "Left"))		; �k�F��
					(setq #Right (get_tile "Right"))	; �q�F�E
					(if (and (= #Left "0") (= #Right "0"))
						(progn
							(set_tile "error" "���E���肪�I������Ă��܂���")
							(setq #err_flg T)
						)
					)
				)
			)
		)

		; �i�����m�F���̍쐬
		(if (= #err_flg nil)
			(progn
				(if (= #Danoti "1")
					(setq #dan_f T)
					(setq #dan_f nil)
				)

				(if (= #dan_f T)
					(if (= #Left "1")
						(setq #LR "L")
						(setq #LR "R")
					)
					(setq #LR "Z")
				)

				(setq #ret$ (list #dan_f #LR))
				(done_dialog)
				#ret$
			)
		)
  ); end of ##KPW_CheckDanotiWorkTopDlg_CallBack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
	(if (= nil (new_dialog "CheckDanotiWorkTopDlg" #dcl_id)) (exit))

	; ���쏈��
	(action_tile "Reguler" "(##SetLREnable)")
	(action_tile "Danoti"  "(##SetLREnable)")
	(action_tile "accept"  "(setq #ret$ (##KPW_CheckDanotiWorkTopDlg_CallBack))")
	(action_tile "cancel"  "(setq #ret$ nil)(done_dialog)")

	(start_dialog)

	(unload_dialog #dcl_id)

	#ret$

);KPW_CheckDanotiWorkTopDlg


(princ)
